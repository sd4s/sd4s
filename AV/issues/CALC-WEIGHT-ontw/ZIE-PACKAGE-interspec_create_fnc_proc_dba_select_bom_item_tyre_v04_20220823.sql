--function/procedure voor opvragen van CURRENT-TYRES waar een BOM-ITEM onderdeel van uitmaakt.
--bijv.: EB_V27490E88F
/*
**************************************************************************************************************
MAINPART: EB_V27490E88F show bom-items J/N: J
**************************************************************************************************************
EF_540/65R34TVZ152;6;ENS;1;127;E_AT
XEF_P20-65L;1;ENS;1;125;Trial E_AT
EF_600/70R34TRXM60;4;ENS;1;127;E_AT_RRO
XEF_P20-18L;2;ENS;1;125;Trial E_AT
EF_540/65R34TVZM45;1;ENS;1;127;E_AT_RRO
EF_600/65R34TVZM51;1;ENS;1;127;E_AT_RRO
XEF_P20-87L;1;ENS;1;125;Trial E_AT
voor return: 7
PROC: Aantal tyres gevonden: 7
*/

--testen/runnen van FUNCTION:
SET SERVEROUTPUT ON
declare
l_component_part   varchar2(100) := 'EM_764';
l_tyres            VARRAY;
begin
  l_component_part_eenheid_kg := DBA_SELECT_BOM_ITEM_TYRE(p_component_part_no=>l_component_part
                                                        , p_show_incl_items_jn=>'N');
  dbms_output.put_line('COMPONENT-PART: '||l_component_part);	
END;
/  



--create FUNCTION TBV SAP-interface !!!
drop function DBA_FNC_SELECT_BOM_ITEM_TYRE;
--
create or replace function DBA_FNC_SELECT_BOM_ITEM_TYRE (p_component_part_no   IN  varchar2 default null
                                                        ,p_show_incl_items_jn  IN  varchar2 default 'N' ) 
RETURN NUMBER
DETERMINISTIC
AS
--Script om per bom-ITEM de gerelateerde TYRES te bepalen. Hier zit geen beperking op voor een specifiek FRAME-ID
--of iets anders. Deze procedure is voor alle componenten/materialen aan te roepen. 
--Dus niet alleen voor de FRAME-IDs waarvoor gewicht wordt berekend tbv SAP-interface.
--
--LET OP: Er wordt hier ook geen rekening gehouden met BOM-HEADER.ALTERNATIVE/PREFERRED !!!. In de output wordt
--        een PATH_ALTERNATIVE samengesteld waaraan we kunnen zien of er een switch in wel/niet PREFERRED verweven zit !!!!
--
--Parameters:  P_COMPONENT_PART_NO = bom-item, bijv.  EM_764 (prod)
--             P_SHOW_INCL_ITEMS_JN = Wel/of niet ook de afzonderlijke gewichten van alle BOM-ITEMS laten zien in OUTPUT.
--                                    Hiervoor wel zelf in SESSIE aangeven met: SET SERVEROUTPUT ON
--                                    'J' = VOOR BEHEER/DEBUG-DOELEINDEN
--                                    'N' = VOOR AANROEP VANUIT WEIGHT-CALCULATION VAN BOM-HEADER, dan wordt alleen totaal-regel getoond.
--RETURN-waarde: P_AANTAL = OUTPUT-parameter, met het aantal gerelateerde TYRES.
--
pl_component_part_no         varchar2(100)   := upper(p_component_part_no);
pl_show_incl_items_jn        varchar2(1)     := upper(p_show_incl_items_jn);
--
c_bom                       sys_refcursor;
c_bom_items                 sys_refcursor;
l_LVL                       varchar2(100);  
l_level_tree                varchar2(4000);
--bom-item-variabelen:
l_part_no                   varchar2(100);
l_revision                  varchar2(100);
l_plant                     varchar2(100);
l_alternative               number;
l_status                    varchar2(30);
l_frame_id                  varchar2(100);
l_path                      varchar2(1000);
l_path_alternative          varchar2(1000);
--
l_aantal                    number    := 0;
BEGIN
  dbms_output.enable(1000000);
  --init
  l_aantal := 0;
  --  
  if upper(pl_show_incl_items_jn) = 'J'
  then  
    dbms_output.put_line('**************************************************************************************************************');
    dbms_output.put_line('MAINPART: '||pl_component_part_no ||' show bom-items J/N: '||pl_show_incl_items_jn );
    dbms_output.put_line('**************************************************************************************************************');
  end if;
  --Indien parameter =SHOW-ITEMS=ja
  if UPPER(pl_show_incl_items_jn) in ('J')
  then
    BEGIN
      --Tonen van totale-gewicht van BOM-HEADER:
      open c_bom_items for SELECT bi2.header_part_no
				,      bi2.revision
				,      bi2.plant
				,      bi2.alternative
				,      bi2.status
				,      bi2.frame_id
				from
				(with sel_bom_item as
                    (select LEVEL   LVL
                     ,      RPAD('.', (level-1)*2, '.') || LEVEL AS level_tree
                     ,      b.part_no
                     ,      b.revision
                     ,      b.plant
                     ,      b.alternative
                     ,      b.component_part
                     ,      b.quantity
                     ,      b.uom
                     ,      b.quantity_kg
                     ,      sys_connect_by_path( b.component_part || ',' || b.part_no ,'|')  path
					 ,      sys_connect_by_path( b.part_no||'-'||b.alternative||';'||b.preferred ,'|')       path_alternative
                     FROM   (SELECT bi.part_no
                             , bi.revision
                             , bi.plant
                             , bi.alternative
                             , bh.preferred
                             , bi.component_part
                             , bi.quantity
                             , bi.uom 
                             , case when bi.uom = 'g' then (bi.quantity/1000) else bi.quantity end  quantity_kg 
                             from bom_header bh
							 ,    bom_item   bi
                             WHERE bi.part_no  = bh.part_no
							 and   bi.revision = bh.revision
							 --and   bh.preferred = 1     --we zoeken alle TYRES met alternative=1/2 !!!
							 and   bi.alternative = bh.alternative
                             AND   bi.revision =  (select max(sh.revision) 
                                                  FROM status               s
                                                  ,    specification_header sh
                                                  WHERE sh.part_no     = bi.part_no
                                                  and   sh.status      = s.status	
                                                  and   s.status_type in ('CURRENT','HISTORIC')					
                                                  )
                            ) b
                     START WITH b.part_no = pl_component_part_no   --'EB_V27490E88F'  
                     CONNECT BY NOCYCLE PRIOR b.part_no = b.component_part
                     order siblings by part_no						 
                    )
               (select distinct boh.part_no   header_part_no
                ,       boh.revision
                ,       boh.plant
                ,       boh.alternative
                ,       sh.status
                ,       sh.frame_id
                --,       boh.base_quantity
                --,       sbi.part_no            item_part_no
                --,       sbi.component_part     comp_part_no
                --,       sbi.quantity
                ,       sbi.path
                ,       sbi.path_alternative
                from   sel_bom_item         sbi
                ,      specification_header sh
                ,      bom_header           boh 
                where  sbi.part_no     = boh.part_no
                and    sbi.revision    = boh.revision
                and    sh.part_no      = boh.part_no
                and    sh.revision     = boh.revision
                and    boh.preferred   = 1
				and    sbi.alternative = boh.alternative
                and    boh.part_no NOT IN (select boi2.component_part from bom_item boi2 where boi2.component_part = boh.part_no)
                and    boh.revision = (select max(sh.revision) 
                                       from status               s  
				                       ,    specification_header sh
                                       where  sh.part_no    = boh.part_no  
                                       and    sh.status     = s.status		
                                       and    s.status_type in ('CURRENT')				--uiteindelijk alleen in current-banden geinteresseerd !	
                                      )
               ) 
			   ) bi2
               ;
      loop 
        fetch c_bom_items into l_part_no 
                              ,l_revision
                              ,l_plant   
                              ,l_alternative
						      ,l_status
						      ,l_frame_id
							  ,l_path
							  ,l_path_alternative
						      ;

        if (c_bom_items%notfound)   
        then CLOSE C_BOM_ITEMS;
	         exit;
	    end if;
		l_aantal := l_aantal + 1;
		if UPPER(pl_show_incl_items_jn) in ('J')
		then dbms_output.put_line(l_part_no||';'||l_revision||';'||l_plant||';'||l_alternative||';'||l_status||';'||l_frame_id||';'||l_path||';'||l_path_alternative );
		end if;
		--
        --exit;	  
      end loop;
	  --
	  if c_bom_items%isopen
   	  then close c_bom_items;  
      end if;
	  --
	EXCEPTION
	  WHEN OTHERS 
	  THEN 
        if c_bom_items%isopen
        then close c_bom_items;  
        end if;
        if sqlerrm not like '%ORA-01001%' 
        THEN dbms_output.put_line('ALG-EXCP BOM-ITEMS: '||SQLERRM); 
        else null;   
        end if;
	END;
	--
  end if;	 --show-items = J
  --
  --RETURN COMPONENT-PART-GEWICHT VAN BOM-HEADER:
  DBMS_OUTPUT.put_line('voor return: '||l_aantal);
  RETURN l_aantal;
  --
END DBA_FNC_SELECT_BOM_ITEM_TYRE;
/

show err




--***********************************************
--***********************************************
--create procedure 
--***********************************************
--***********************************************
drop procedure DBA_SELECT_BOM_ITEM_TYRE;
--
create or replace procedure DBA_SELECT_BOM_ITEM_TYRE (pf_component_part_no          IN  varchar2 default null
                                                     ,pf_show_incl_items_jn         IN  varchar2 default 'J' 
											         )
IS
--function/procedure voor opvragen van CURRENT-TYRES waar een BOM-ITEM onderdeel van uitmaakt.
l_component_part_eenheid_kg  number;														  
l_aantal                     number;
begin
  l_aantal := DBA_FNC_SELECT_BOM_ITEM_TYRE(p_component_part_no=>pf_component_part_no
                                                             ,p_show_incl_items_jn=>pf_show_incl_items_jn);
  dbms_output.put_line('PROC: Aantal tyres gevonden: '||l_aantal);															   
end;
/

show err;



prompt
prompt andere optie zou kunnen zijn om de VIEW DBA_WEIGHT_COMPONENT_PART uit te vragen:
prompt

select distinct mainpart, mainframeid
from dba_weight_component_part
where component_part_no = 'EB_V27490E88F'
or    part_no = 'EB_V27490E88F'
;




prompt
prompt einde script
prompt






--function/procedure voor uitvragen van GEWICHTEN van een BOM-HEADER
--obv van 1 EENHEID bom-header en alle gerelateerde BOM-ITEMS tot aan MATERIALS toe !!!

--testen/runnen van FUNCTION:
SET SERVEROUTPUT ON
declare
l_component_part             varchar2(100) := 'XGF_2656018WPRXH_s';  --'ED_700-5-11';  --EF_T235/65R17WNIXS'   --'XGF_BU11S18N1'; --'EM_764';
l_revision                   number        := 2;
l_component_part_eenheid_kg  number;
begin
  l_component_part_eenheid_kg := DBA_FNC_BEPAAL_HEADER_GEWICHT(p_header_part_no=>l_component_part
                                                              ,p_header_revision=>l_revision
                                                              , p_show_incl_items_jn=>'J');
  dbms_output.put_line('COMPONENT-PART: '||l_component_part||' gewicht: '||l_component_part_eenheid_kg);	
END;
/  



--create FUNCTION TBV SAP-interface !!!
drop function DBA_FNC_BEPAAL_HEADER_GEWICHT;
--
create or replace function DBA_FNC_BEPAAL_HEADER_GEWICHT (p_header_part_no      IN  varchar2 default null
                                                         ,p_header_revision     in  number   default null
                                                         ,p_show_incl_items_jn  IN  varchar2 default 'N' ) 
RETURN NUMBER
DETERMINISTIC
AS
--Script om per bom-header de gewichten te berekenen per band!
--SELECTIE ZIT HIERBIJ ALLEEN OP DE ONDERSTE BOM-ITEMS (=MATERIALEN/GRONDSTOFFEN) MET EEN UOM=KG
--WAARBIJ PER BOM-HEADER HET GEWICHT WORDT BEREKEND.
--LET OP: ALLE TUSSENLIGGENDE BOM-ITEM (RELATIES PART-NO/COMPONENT-PART) WORDEN HIERBIJ WEL GEBRUIKT VOOR SELECTIE,
--        MAAR DE KG VOOR DE GEWICHTSBEREKENING GENEGEERD !!!
--LET OP: Het komt voor dat er wel een BOM-ITEM-RELATIE bestaat tussen part-no + component-part maar dat
--        de component-part ondertussen al wel een HISTORIC-status heeft gekregen. 
--        In dit geval moet COMPONENT-PART wel in gewichtsberekening worden meegenomen, alhoewel de band/component-part
--        niet meer geproduceerd kan worden. De band zelf kan dan nog CURRENT-status hebben, maar gerelateerde component-part niet.
--
--Parameters:  P_PART_NO = bom-item-header, bijv.  EF_Y245/35R20QPRX (prod)
--                                                 EF_W245/40R18WPRX (test-FOUTIEVE CURSOR)
--                                                 EF_710/40R22FLT162 (test)
--                         LET OP: Er komen XG-tyres uit hongarije voor met lowercase-characters in de naamgeving van PARTNO.
--                                 Om deze reden geen UPPER-gebruiken !!!
--
--             P_HEADER_REVISION = bom-item-header-revision-number van CURRENT/HISTORIC header.
--                                 Indien een TYRE zal status altijd CURRENT zijn. 
--                                 Een component kan zelf al HISTORIC zijn maar zolang hij in BOM-ITEM zit moet hij wel worden meegenomen.
--                                 Ook de COMPONENT-BOM-HEADER kan zelfs al HISTORIC zijn...Dan alsnog meenemen in de berekening !!!
--
--             P_SHOW_INCL_ITEMS_JN = Wel/of niet ook de afzonderlijke gewichten van alle BOM-ITEMS laten zien in OUTPUT.
--                                    Hiervoor wel zelf in SESSIE aangeven met: SET SERVEROUTPUT ON
--                                    'J' = VOOR BEHEER/DEBUG-DOELEINDEN
--                                    'N' = VOOR AANROEP VANUIT WEIGHT-CALCULATION VAN BOM-HEADER, dan wordt alleen totaal-regel getoond.
--RETURN-waarde: P_COMPONENT_PART_EENHEID_KG = OUTPUT-parameter, met het EENHEID-GEWICHT VAN EEN BOM-HEADER.
--                                           DIT OP BASIS VAN DE BOM-structuur onder dit BOM-ITEM !!
--
--LET OP:
--Het is nog een optie om extra PARAMETER="ALTERNATIVE number default 1" toe te voegen. Nu wordt er nog alleen voor ALTERNATIVE=1 de bom berekend.
--
--dependencies: FUNCTIE DBA_BEPAAL_QUANTITY_KG: functie om de quantity-string te vermenigvuldiger met PART-NO-BASE-QUANTITY 
--                                              om uiteindelijk het gewicht van BOM-HEADER obv MATERIALS-gewichten te berekenen.
--
pl_header_part_no            varchar2(100)   := p_header_part_no;
pl_header_revision           number          := p_header_revision;
pl_show_incl_items_jn        varchar2(1)     := upper(p_show_incl_items_jn);
--
c_bom_items                 sys_refcursor;
l_LVL                       varchar2(100);  
l_level_tree                varchar2(4000);
--main-bom-header-variabelen:
l_mainpart                  varchar2(100);
l_mainrevision              number;
l_mainplant                 varchar2(100);
l_mainalternative           number;
l_mainbasequantity          number;
l_mainminqty                number;
l_mainmaxqty                number;
l_mainsumitemsquantity      number;
l_mainstatus                varchar2(100);
l_mainframeid               varchar2(100);
l_mainpartdescription       varchar2(1000);
l_mainpartbaseuom           varchar2(100);
--bom-item-variabelen:
l_part_no                   varchar2(100);
l_revision                  varchar2(100);
l_plant                     varchar2(100);
l_alternative               number;
l_item_header_base_quantity number;
l_component_part            varchar2(100);
l_componentdescription      varchar2(1000);
l_quantity                  number;
l_uom                       varchar2(100);
l_quantity_kg               number;
l_status                    varchar2(30);
l_characteristic_id         number;
l_functiecode               varchar2(1000);
--prior-to-variabelen:
l_path                      varchar2(4000);
l_quantity_path             varchar2(4000);
l_bom_quantity_kg          varchar2(100);    --DIT IS MATERIAAL-GEWICHT OPGEWERKT NAAR HEADER !!!
--
c_bom                           sys_refcursor;
l_header_mainpart               varchar2(100);
l_header_gewicht                varchar2(100);
l_header_bom_gewicht_som_items  varchar2(100);
--
BEGIN
  dbms_output.enable(1000000);
  --init
  if pl_header_revision is null
  then
    --indien er geen revision is meegegeven dan alsnog eerst zelf ophalen
    begin
      select max(sh1.revision) 
	  into pl_header_revision
	  from status s1
	  ,    specification_header sh1 
	  where sh1.part_no = pl_header_part_no 
	  and sh1.status = s1.status 
	  and s1.status_type in ('CURRENT','HISTORIC')
	  ;
	exception
	  when others 
	  then dbms_output.put_line('REVISION-EXCP: Revision kon niet bepaald worden voor partno: '||pl_header_part_no);
    end;
  end if;
  if upper(pl_show_incl_items_jn) = 'J'
  then  
    dbms_output.put_line('**************************************************************************************************************');
    dbms_output.put_line('MAINPART: '||pl_header_part_no ||' revision: '||pl_header_revision||' show bom-items J/N: '||pl_show_incl_items_jn );
    dbms_output.put_line('**************************************************************************************************************');
  end if;
  --Indien parameter =SHOW-ITEMS=ja
  if UPPER(pl_show_incl_items_jn) in ('J')
  then
    BEGIN
      dbms_output.put_line('l_mainpart'||';'||'l_mainrevision'||';'||'l_mainalternative'||';'||'l_mainbasequantity'||';'||'l_mainsumitemsquantity'||';'||'l_mainstatus'||';'||'l_mainframeid'||';'||'l_mainpartdescription'||';'||'l_mainpartbaseuom'||
		                    ';'||'l_component_part'||';'||'l_componentdescription'||';'||'l_item_header_base_quantity'||';'||'l_quantity'||';'||'l_uom'||';'||'l_quantity_kg'||';'||'l_bom_quantity_kg'||';'||'l_status'||';'||'l_characteristic_id'||';'||'l_functiecode' );      
      --Tonen van totale-gewicht van BOM-HEADER:
      open c_bom_items for SELECT bi2.LVL
				,      bi2.level_tree
				,      bi2.mainpart
				,      bi2.mainrevision
				,      bi2.mainplant
				,      bi2.mainalternative
				,      bi2.mainbasequantity
				,      bi2.mainminqty
				,      bi2.mainmaxqty
				,      bi2.mainsumitemsquantity
				,      bi2.mainstatus
				,      bi2.mainframeid
				,      bi2.mainpartdescription
				,      bi2.mainpartbaseuom
				,      bi2.part_no
				,      bi2.revision
				,      bi2.plant
				,      bi2.alternative
				,      bi2.component_part
				,      bi2.componentdescription
				,      bi2.item_header_base_quantity
				,      bi2.quantity
				,      bi2.uom
				,      bi2.quantity_kg
				,      bi2.status
				,      bi2.characteristic_id 
				,      bi2.functiecode
				,      bi2.path
				,      bi2.quantity_path
				,      DBA_BEPAAL_QUANTITY_KG(bi2.quantity_path)  bom_quantity_kg
				from
				(
				with sel_bom_header as 
				(select bh.part_no
				 ,      bh.revision
				 ,      bh.plant
				 ,      bh.alternative
				 ,      bh.base_quantity
				 ,      bh.min_qty
				 ,      bh.max_qty
				 ,      (select sum(case 
				                    when b.uom = 'g' 
									then (b.quantity/1000) 
									when b.uom = 'kg'
									then b.quantity
				                    else 0 end) 
						 from bom_item b where b.part_no = bh.part_no and b.revision = bh.revision and b.alternative = bh.alternative) sum_items_quantity
				 ,      s.sort_desc
				 ,      sh.frame_id
				 ,      p.description
				 ,      p.base_uom      
				 from status               s  
				 ,    part                 p
				 ,    specification_header sh
				 ,    bom_header           bh 
				 where  bh.part_no    = pl_header_part_no  --'EM_764' --'EG_H620/50R22-154G'  --l_header_part_no
				 and    bh.revision   = pl_header_revision --(select max(sh1.revision) from status s1, specification_header sh1 where sh1.part_no = bh.part_no and sh1.status = s1.status and s1.status_type in ('CURRENT','HISTORIC'))
				 and    bh.part_no    = p.part_no
				 and    bh.part_no    = sh.part_no
                 and    bh.revision   = sh.revision
                 and    sh.status     = s.status				 
				 --and    s.status_type in ('CURRENT','HISTORIC')
				 --welk alternative we gebruiken is afhankelijk van PREFERRED-ind.
                 and    bh.preferred = 1				 
				 --     and    bh.alternative = 1
				 --WE HALEN PCR-CONTROLE UIT DEZE PROCEDURE, DEZE VERPLAATSEN WE NAAR DE AANROEP-PROCEDURE
				 --DAAR ZIT AL EEN SOORTGELIJKE CHECK INCL. DE SAP-VIEW-PART-NO. DIT WORDT DAARMEE OVERBODIG...
				 /* --PS: 03-07-2022 UITGEZET...
				    --Indien we gewicht van alleen banden willen kunnen opvragen:
   				 and (  (     bh.part_no NOT IN (select boi2.component_part from bom_item boi2 where boi2.component_part = bh.part_no)
				         --focus op a_pcr-TYRE (let op: alleen voor band, voor componenten andere FRAMES!!!):
  				          and sh.frame_id   = 'A_PCR')
   				      --Indien we gewicht van een sub-part-no (zonder materialen) willen kunnen opvragen:
				      --alleen header met onderliggende componenten
				      or  bh.part_no IN (select boi2.part_no from bom_item boi2 where boi2.part_no = bh.part_no and boi2.alternative = bh.alternative)
					  )
			     */
				 and    rownum = 1
				) 
				select LEVEL   LVL
				,      RPAD('.', (level-1)*2, '.') || LEVEL AS level_tree
				,      h.part_no             mainpart
				,      h.revision            mainrevision
                ,      h.plant               mainplant
				,      h.alternative         mainalternative
				,      h.base_quantity       mainbasequantity
			    ,      h.min_qty             mainminqty
				,      h.max_qty             mainmaxqty
				,      h.sum_items_quantity  mainsumitemsquantity
				,      h.sort_desc           mainstatus
				,      h.frame_id            mainframeid
				,      h.description         mainpartdescription
				,      h.base_uom            mainpartbaseuom
				,      b.part_no
				,      b.revision
				,      b.plant
				,      b.alternative
				,      b.component_part
				,      (select pi.description from part pi where pi.part_no = b.component_part)  componentdescription
				,      b.item_header_base_quantity
				,      b.quantity
				,      b.uom
				,      b.quantity_kg
				,      b.status
				,      b.characteristic_id       --FUNCTIECODE
				,      b.functiecode             --functiecode-descr
				,      sys_connect_by_path( b.part_no||decode(b.characteristic_id,null,'','-'||b.characteristic_id) || ',' || b.component_part ,'|')  path
				,      sys_connect_by_path( '('||b.quantity_kg||'/'||b.item_header_base_quantity||')', '*')  quantity_path
				FROM   ( SELECT bi.part_no
				         ,      bi.revision
						 ,      bi.plant
						 ,      bi.alternative
						 ,      bi.component_part
						 --,      (select bh.base_quantity from bom_header bh where bh.part_no = bi.part_no and bh.revision = bi.revision and bh.alternative= bi.alternative )   item_header_base_quantity
						 ,      h.base_quantity   item_header_base_quantity
						 ,      bi.quantity
						 ,      case when bi.uom = 'pcs'
									 then (--indien een material met uom=pcs dan weight uit property halen, en uom aanpassen naar "kg"
									       SELECT 'kg'
                                           FROM specification_prop sp
                                           WHERE sp.part_no  = bi.component_part   --'GR_9787'
                                           AND   sp.revision = (select max(sh1.revision) from status s1, specification_header sh1 where sh1.part_no = sp.part_no and sh1.status = s1.status and s1.status_type in ('CURRENT'))
                                           AND   sp.section_id = 700755 --  SAP information
                                           AND   sp.sub_section_id = 701502 -- A
                                           AND   sp.property_group = 0 -- (none)
                                           AND   sp.property = 703262 -- Weight
										   UNION
										   --indien component-part met uom=pcs dan aantal meenemen in de berekening
										   select 'pcs' 
										   from dual
                                           where exists (select '' from bom_item bi3 where bi3.part_no = bi.component_part)
                                          )
				                     else bi.uom end   uom
						 --,      bi.uom
						 ,      case when bi.uom = 'g' 
                                     then (bi.quantity/1000) 
									 when bi.uom = 'kg'
									 then bi.quantity
									 when bi.uom = 'pcs'
									 then (--indien een material met uom=pcs dan weight uit property halen
									       SELECT (sp.num_1 * bi.quantity)
                                           FROM specification_prop sp
                                           WHERE sp.part_no  = bi.component_part   --'GR_9787'
                                           AND   sp.revision = (select max(sh1.revision) from status s1, specification_header sh1 where sh1.part_no = sp.part_no and sh1.status = s1.status and s1.status_type in ('CURRENT'))
                                           AND   sp.section_id = 700755 --  SAP information
                                           AND   sp.sub_section_id = 701502 -- A
                                           AND   sp.property_group = 0 -- (none)
                                           AND   sp.property = 703262 -- Weight
										   UNION
										   --indien component-part met uom=pcs dan aantal meenemen in de berekening
										   select bi.quantity 
										   from dual
                                           where exists (select '' from bom_item bi3 where bi3.part_no = bi.component_part)
                                          )
				                     else bi.quantity end   quantity_kg
						 --,      case 
						 --       when bi.uom = 'g' 
						 --		then (bi.quantity/1000) 
						 --		else bi.quantity end  quantity_kg   --hier moeten we de overige UOMs zoals pcs/m nog wel meenemen anders wordt later de factor in quantity-path=0
						 ,      s.sort_desc     status
				         ,      bi.ch_1         characteristic_id       --FUNCTIECODE
				         ,      c.description   functiecode             --functiecode-descr
  				         FROM status               s
				         ,    specification_header sh
						 ,    bom_header           h
 				         ,    characteristic       c
				         ,    bom_item             bi	 
						 WHERE h.part_no      = bi.part_no
						 and   h.revision     = bi.revision
						 and   bi.revision   = (select max(sh1.revision) from status s1, specification_header sh1 where sh1.part_no = bi.part_no and sh1.status = s1.status and s1.status_type in ('CURRENT','HISTORIC'))
						 and   h.preferred    = 1
						 and   h.alternative  = bi.alternative
				         and   bi.part_no     = sh.part_no
                         and   bi.revision    = sh.revision
						 and   sh.status      = s.status	
						 --and   s.status_type  = 'CURRENT' 
				         and   bi.ch_1        = c.characteristic_id(+)
					   ) b
				,      sel_bom_header h	   
				START WITH b.part_no = h.part_no 
				CONNECT BY NOCYCLE PRIOR b.component_part = b.part_no --and b.component_revision = b.revision
				order siblings by b.part_no
				)  bi2
				--select alleen gewicht van materialen...
				where bi2.component_part NOT IN (select bi3.part_no from bom_item bi3 where bi3.part_no = bi2.component_part)
				;
      loop 
        fetch c_bom_items into l_LVL
                          ,l_level_tree
                          ,l_mainpart  
                          ,l_mainrevision
						  ,l_mainplant
                          ,l_mainalternative
                          ,l_mainbasequantity
						  ,l_mainminqty
				          ,l_mainmaxqty
				          ,l_mainsumitemsquantity
				          ,l_mainstatus
				          ,l_mainframeid
				          ,l_mainpartdescription
				          ,l_mainpartbaseuom
                          ,l_part_no 
                          ,l_revision
                          ,l_plant   
                          ,l_alternative
                          ,l_component_part      
                          ,l_componentdescription						  
                          ,l_item_header_base_quantity
                          ,l_quantity            
                          ,l_uom                 
                          ,l_quantity_kg         
						  ,l_status
						  ,l_characteristic_id
                          ,l_functiecode
                          ,l_path                
                          ,l_quantity_path       
                          ,l_bom_quantity_kg    --gewicht-materiaal opgewerkt naar header
						  ;

        if (c_bom_items%notfound)   
        then CLOSE C_BOM_ITEMS;
	         exit;
	    end if;
        --dbms_output.put_line(l_part_no||';'||l_path||';'||l_quantity_path||';'||l_quantity_kg||';'||l_excl_quantity_kg ||';'||l_uom||';'||l_characteristic_id );
        dbms_output.put_line(l_mainpart||';'||l_mainrevision||';'||l_mainplant||';'||l_mainalternative||';'||l_mainbasequantity||';'||l_mainsumitemsquantity||';'||l_mainstatus||';'||l_mainframeid||';'||l_mainpartdescription||';'||l_mainpartbaseuom||
                        ';'||l_component_part||';'||l_componentdescription||';'||l_item_header_base_quantity||';'||l_quantity||';'||l_uom||';'||l_quantity_kg ||';'||l_bom_quantity_kg||';'||l_status||';'||l_characteristic_id||';'||l_functiecode );
		--
		/*
        DBA_INSERT_WEIGHT_CALC (p_main_part_no=>l_mainpart
                               ,p_part_no=>l_part_no
							   ,p_component_part_no=>l_component_part
							   ,p_characteristic_id=>l_characteristic_id
		                       ,p_path=>l_path
							   ,p_quantity_path=>l_quantity_path
							   ,p_quantity_kg=>l_quantity_kg
							   ,p_excl_quantity_kg=>l_bom_quantity_kg
							   ,p_uom=>l_uom
							   ,p_remark=>'TEST-RUN-PETER' );
        */							   
        --exit;	  
      end loop;
      close c_bom_items;  
	  --
	EXCEPTION
	  WHEN OTHERS 
	  THEN if sqlerrm not like '%ORA-01001%' 
           THEN dbms_output.put_line('ALG-EXCP BOM-ITMES: '||SQLERRM); 
           else null;   
           end if;
	END;
	--
  end if;	 --show-items = J
  --
  if upper(pl_show_incl_items_jn) = 'J'
  then   
    dbms_output.put_line('**************************************************************************************************************');
    dbms_output.put_line('BEREKEN TOTAALGEWICHT VAN HEADER: '||pl_header_part_no);
    dbms_output.put_line('**************************************************************************************************************');
  end if;
  --ALTIJD Tonen van totale-gewicht van BOM-HEADER:
  BEGIN
    --sum(decode(uom,'pcs',0,quantity_kg)), sum(decode(uom,'pcs',0,excl_quantity_kg))
    --Voor alle materialen die geen gewicht hebben (maar "pcs") nemen we geen gewicht mee
    open c_bom for select mainpart
                ,      sum(decode(uom,'pcs',0,quantity_kg))      gewicht
	 		    ,      sum(decode(uom,'pcs',0,bom_quantity_kg))  header_bom_gewicht_som_items
                from (
				SELECT bi2.LVL
				,      bi2.level_tree
				,      bi2.mainpart
				,      bi2.mainrevision
				,      bi2.mainalternative
				,      bi2.mainbasequantity
				,      bi2.part_no
				,      bi2.revision
				,      bi2.plant
				,      bi2.alternative
				,      bi2.characteristic_id
				,      bi2.item_header_base_quantity
				,      bi2.component_part
				,      bi2.quantity
				,      bi2.uom
				,      bi2.quantity_kg
				,      bi2.path
				,      bi2.quantity_path
				,      DBA_BEPAAL_QUANTITY_KG(bi2.quantity_path)  bom_quantity_kg
				from
				(
				with sel_bom_header as 
				(select bh.part_no
				 ,      bh.revision
				 ,      bh.plant
				 ,      bh.alternative
				 ,      bh.base_quantity
				 from status               s  
				 ,    part                 p
				 ,    specification_header sh
				 ,    bom_header           bh 
				 where  bh.part_no    = pl_header_part_no  --'EM_764' --'EG_H620/50R22-154G'  --l_header_part_no
				 and    bh.revision   = pl_header_revision --(select max(sh1.revision) from status s1, specification_header sh1 where sh1.part_no = bh.part_no and sh1.status = s1.status and s1.status_type in ('CURRENT','HISTORIC'))
				 and    bh.part_no    = p.part_no
				 and    bh.part_no    = sh.part_no
                 and    bh.revision   = sh.revision
                 and    sh.status     = s.status				 
				 --and    s.status_type = 'CURRENT' 
				 --and    s.sort_desc  IN ( 'CRRNT QR1', 'CRRNT QR2', 'CRRNT QR3', 'CRRNT QR4','CRRNT QR5')
                 --welk alternative we gebruiken is afhankelijk van PREFERRED-ind.
                 and    bh.preferred = 1				 
				 --     and    bh.alternative = 1				 
				 --WE HALEN PCR-CONTROLE UIT DEZE PROCEDURE, DEZE VERPLAATSEN WE NAAR DE AANROEP-PROCEDURE
				 --DAAR ZIT AL EEN SOORTGELIJKE CHECK INCL. DE SAP-VIEW-PART-NO. DIT WORDT DAARMEE OVERBODIG...
				 /* --PS: 03-07-2022 UITGEZET...
				 --Indien we gewicht van alleen banden willen kunnen opvragen:
				 and (  (     bh.part_no NOT IN (select boi2.component_part from bom_item boi2 where boi2.component_part = bh.part_no)
				         --focus op a_pcr-TYRE (let op: alleen voor band, voor componenten andere FRAMES!!!):
  				          and sh.frame_id   = 'A_PCR')
   				      --Indien we gewicht van een sub-part-no (zonder materialen) willen kunnen opvragen:
				      --alleen header met onderliggende componenten
				      or  bh.part_no IN (select boi2.part_no from bom_item boi2 where boi2.part_no = bh.part_no and boi2.alternative = bh.alternative)
					  )
                 */
				 and    rownum = 1
				) 
				select LEVEL   LVL
				,      RPAD('.', (level-1)*2, '.') || LEVEL AS level_tree
				,      h.part_no       mainpart
				,      h.revision      mainrevision
				,      h.alternative   mainalternative
				,      h.base_quantity mainbasequantity
				,      b.part_no
				,      b.revision
				,      b.plant
				,      b.alternative
				,      b.characteristic_id
				,      b.item_header_base_quantity
				,      b.component_part
				,      b.quantity
				,      b.uom
				,      b.quantity_kg
				,      sys_connect_by_path( b.part_no || ',' || b.component_part ,'|')  path
				,      sys_connect_by_path( '('||b.quantity_kg||'/'||b.item_header_base_quantity||')', '*')  quantity_path
				FROM   ( SELECT bi.part_no
				         , bi.revision
						 , bi.plant
						 , bi.alternative
						 , bi.ch_1           characteristic_id
						 --, (select bh.base_quantity from bom_header bh where bh.part_no = bi.part_no and bh.revision = bi.revision and bh.alternative=1) item_header_base_quantity
						 , h.base_quantity   item_header_base_quantity
						 , bi.component_part
						 , bi.quantity
					     ,      case when bi.uom = 'pcs'
						             then (--indien een material met uom=pcs dan weight uit property halen, en uom aanpassen naar "kg"
									       SELECT 'kg'
                                           FROM specification_prop sp
                                           WHERE sp.part_no  = bi.component_part   --'GR_9787'
                                           AND   sp.revision = (select max(sh1.revision) from status s1, specification_header sh1 where sh1.part_no = sp.part_no and sh1.status = s1.status and s1.status_type in ('CURRENT'))
                                           AND   sp.section_id = 700755 --  SAP information
                                           AND   sp.sub_section_id = 701502 -- A
                                           AND   sp.property_group = 0 -- (none)
                                           AND   sp.property = 703262 -- Weight
										   UNION
										   --indien component-part met uom=pcs dan aantal meenemen in de berekening
										   select 'pcs' 
										   from dual
                                           where exists (select '' from bom_item bi3 where bi3.part_no = bi.component_part)
                                          )
				                     else bi.uom end   uom
						 --, bi.uom 
						 , case when bi.uom = 'g' 
                                then (bi.quantity/1000) 
								when bi.uom = 'kg'
								then bi.quantity
								when bi.uom = 'pcs'
								then (SELECT (sp.num_1 * bi.quantity)
                                      FROM specification_prop sp
                                      WHERE sp.part_no        = bi.component_part   --'GR_9787'
                                      AND   sp.revision       = (select max(sh1.revision) from status s1, specification_header sh1 where sh1.part_no = sp.part_no and sh1.status = s1.status and s1.status_type in ('CURRENT'))
                                      AND   sp.section_id     = 700755 -- SAP information
                                      AND   sp.sub_section_id = 701502 -- A
                                      AND   sp.property_group = 0      -- (none)
                                      AND   sp.property       = 703262 -- Weight
                                      UNION
								      --indien component-part met uom=pcs dan aantal meenemen in de berekening
									  select bi.quantity 
									  from dual
                                      where exists (select '' from bom_item bi3 where bi3.part_no = bi.component_part)
                                     )
				                else bi.quantity end   quantity_kg
						 --, case when bi.uom = 'g' then (bi.quantity/1000) else bi.quantity end  quantity_kg 
                         FROM status               s
				         ,    specification_header sh
						 ,    bom_header           h
 				         ,    characteristic       c
				         ,    bom_item             bi	 
						 WHERE h.part_no      = bi.part_no
						 and   h.revision     = bi.revision
						 and   bi.revision   = (select max(sh1.revision) from status s1, specification_header sh1 where sh1.part_no = bi.part_no and sh1.status = s1.status and s1.status_type in ('CURRENT','HISTORIC'))
						 and   h.preferred    = 1
						 and   h.alternative  = bi.alternative
				         and   bi.part_no     = sh.part_no
                         and   bi.revision    = sh.revision
						 and   sh.status      = s.status	
						 --and   s.status_type  = 'CURRENT'    						 --Er komt maar 1x CRRNT voor, de rest is HISTORIC/DEV	
						 and   bi.ch_1        = c.characteristic_id(+)
					   ) b
				,      sel_bom_header h	   
				START WITH b.part_no = h.part_no 
				CONNECT BY NOCYCLE PRIOR b.component_part = b.part_no --and b.component_revision = b.revision
				order siblings by part_no
				)  bi2
                --select alleen gewicht van materialen... 
				where bi2.component_part NOT IN (select bi3.part_no from bom_item bi3 where bi3.part_no = bi2.component_part)
				)
				group by mainpart
				;
    loop 
      fetch c_bom into l_header_mainpart, l_header_gewicht, l_header_bom_gewicht_som_items;
      if (c_bom%notfound)   
      then CLOSE C_BOM;
           exit;
      end if;
	  if upper(pl_show_incl_items_jn) = 'J'
      then 
        dbms_output.put_line('**************************************************************************************************************');
        dbms_output.put_line('TOTAALGEWICHT VAN ITEM;'||pl_header_part_no||';revision;'||pl_header_revision||';base-gewicht;'||l_header_gewicht||';header-gewicht-bom-items;'||l_header_bom_gewicht_som_items );
        dbms_output.put_line('**************************************************************************************************************');
      --else
      --  dbms_output.put_line('TOTAALGEWICHT VAN ITEM;'||pl_header_part_no||';base-gewicht;'||l_header_gewicht||';header-gewicht-bom-items;'||l_header_bom_gewicht_som_items );
	  end if;
    end loop;
    --
    if c_bom%isopen
	then close c_bom;  
	end if;
	--
	--RETURN COMPONENT-PART-GEWICHT VAN BOM-HEADER:
	--p_component_part_eenheid_kg := l_header_bom_gewicht_som_items;
	--
  EXCEPTION
    WHEN OTHERS 
    THEN 
      if c_bom%isopen
	  then close c_bom;  
	  end if;
      if sqlerrm not like '%ORA-01001%' 
      THEN dbms_output.put_line('ALG-EXCP BOM-HEADER-TOTAL '||pl_header_part_no||': '||SQLERRM); 
      else null; 
	  end if;
  END;
  --
  --DBMS_OUTPUT.put_line('voor return: '||l_header_bom_gewicht_som_items);
  RETURN l_header_bom_gewicht_som_items;
  --
END DBA_FNC_BEPAAL_HEADER_GEWICHT;
/

show err




--***********************************************
--***********************************************
--create procedure 
--***********************************************
--***********************************************
drop procedure DBA_BEPAAL_BOM_HEADER_GEWICHT;
--
create or replace procedure DBA_BEPAAL_BOM_HEADER_GEWICHT (pf_header_part_no             IN  varchar2 default null
                                                          ,pf_show_incl_items_jn         IN  varchar2 default 'J' 
														  )
IS
l_component_part_eenheid_kg  number;														  
begin
  l_component_part_eenheid_kg := DBA_FNC_BEPAAL_HEADER_GEWICHT(p_header_part_no=>pf_header_part_no
                                                              ,p_show_incl_items_jn=>pf_show_incl_items_jn);
end;
/

show err;



prompt
prompt einde script
prompt






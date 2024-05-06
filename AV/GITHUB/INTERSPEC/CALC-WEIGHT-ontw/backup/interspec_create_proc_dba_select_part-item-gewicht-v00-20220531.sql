--procedure voor uitvragen van GEWICHTEN van een BOM-HEADER

create or replace procedure DBA_BEPAAL_EENHEID_GEWICHT (p_header_part_no      varchar2 default null
                                                       ,p_alternative         number   default null 
                                                       ,p_show_incl_items_jn  varchar2 default 'J')
DETERMINISTIC
AS
--Script om per bom-header/component het gewicht te berekenen van direct afhankelijke materialen/componenten. 
--Parameters:  P_PART_NO = bom-item-header, bijv.  EF_Y245/35R20QPRX (prod)
--                                                 EF_W245/40R18WPRX (test-FOUTIEVE CURSOR)
--                                                 EF_710/40R22FLT162 (test)
--             P_ALTERNATIVE = indicator die aangeeft om welk alternatief het gaat. 
--                             1=default, per eenheid
--                             2=batch, voor bulk
--             P_INCL_ITEMS_JN = Wel/of niet ook de afzonderlijke gewichten van alle BOM-ITEMS laten zien in OUTPUT.
--                               Indien 'N', dan wordt alleen totaal-regel getoond.
--
--
l_header_part_no           varchar2(100)   := p_header_part_no;
l_alternative              number(1)       := p_alternative;
l_show_incl_items_jn       varchar2(1)     := p_show_incl_items_jn;
--
c_bom_items                sys_refcursor;
--l_LVL                      varchar2(100);  
--l_level_tree               varchar2(4000);
l_mainpart                 varchar2(100);
l_mainrevision             varchar2(100);
l_mainplant                varchar2(100);
l_mainalternative          number;
l_mainbasequantity         number;
l_mainminqty               number;
l_mainmaxqty               number;
l_mainsumitemsquantity     number;
--
l_part_no                  varchar2(100);
l_revision                 varchar2(100);
l_plant                    varchar2(100);
l_alternative              number;
l_characteristic_id        number;
l_item_header_base_quantity number;
l_component_part           varchar2(100);
l_quantity                 number;
l_uom                      varchar2(100);
l_quantity_kg              number;

--l_path                     varchar2(4000);
--l_quantity_path            varchar2(4000);
--l_excl_quantity_kg         varchar2(100);
--
c_bom                      sys_refcursor;
l_header_mainpart          varchar2(100);
l_header_gewicht           varchar2(100);
l_header_gewicht_som_items varchar2(100);
--
BEGIN
  dbms_output.enable(1000000);
  if upper(l_show_incl_items_jn) = 'J'
  then  
    dbms_output.put_line('**************************************************************************************************************');
    dbms_output.put_line('MAINPART: '||l_header_part_no ||' show bom-items J/N: '||l_show_incl_items_jn );
    dbms_output.put_line('**************************************************************************************************************');
  end if;
  --Indien parameter =SHOW-ITEMS=ja
  if UPPER(l_show_incl_items_jn) in ('J')
  then
    BEGIN
      dbms_output.put_line('ITEM;path;quantity-path;gewicht;gewicht-excl;UOM');
      --Tonen van base/eenheid-gewicht van BOM-HEADER/component:
      open c_bom_items for SELECT bi2.mainpart
				,      bi2.mainrevision
				,      bi2.mainalternative
				,      bi2.mainbasequantity
				,      bi2.mainminqty
				,      bi2.mainmaxqty
				,      bi2.mainsumitemsquantity
				,      bi2.mainstatus
				,      bi2.mainframeid
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
				 ,       s.sort_desc
				 ,       sh.frame_id
				 from status               s  
				 ,    specification_header sh
				 ,    bom_header           bh 
				 where  bh.part_no    = l_header_part_no
				 and    bh.part_no    = sh.part_no
                 and    bh.revision   = sh.revision
                 and    sh.status     = s.status				 
				 and    s.sort_desc  IN ( 'CRRNT QR4','CRRNT QR5')
				 --focus op a_pcr:
				 and    sh.frame_id   = 'A_PCR'
				 --we selecteren alle alternatieven om gewicht op te halen. Indien parameter=NULL dan alle alternative-voorkomens
				 --VOOR TEST-DOELEINDEN:
				 and    bh.alternative = decode(null,null,bh.alternative,null)
				 --DEFINITIEVE-VERSIE:
				 --and    bh.alternative = decode(l_alternative,null,bh.alternative,l_alternative)
				 --Indien we gewicht van alleen banden willen kunnen opvragen:
				 --and    boh.part_no NOT IN (select boi2.component_part from bom_item boi2 where boi2.component_part = boh.part_no)
				 --Indien we gewicht van een sub-part-no (zonder materialen) willen kunnen opvragen:
				 --alleen header met onderliggende componenten
				 and    bh.part_no IN (select boi2.part_no from bom_item boi2 where boi2.part_no = bh.part_no and boi2.alternative = bh.alternative)
				 --allen max-revision
				 and    bh.revision = (select max(bh1.revision) from bom_header bh1 where bh1.part_no = bh.part_no and bh1.alternative = bh.alternative)
				 --and    rownum = 1
				 --and    boh.PART_NO = 'ET_LV634'   --'XEM_B16-1119_01'
				) 
				select h.part_no             mainpart
				,      h.revision            mainrevision
				,      h.plant               mainplant
				,      h.alternative         mainalternative
				,      h.base_quantity       mainbasequantity
				,      h.min_qty             mainminqty
				,      h.max_qty             mainmaxqty
				,      h.sum_items_quantity  mainsumitemsquantity
				,      h.sort_desc           mainstatus
				,      h.frame_id            mainframeid
				,      b.part_no
				,      b.revision
				,      b.plant
				,      b.alternative
				,      b.ch_1                       characteristic_id       --FUNCTIECODE
				,      (select bhi.base_quantity from bom_header bhi where bhi.part_no = b.part_no and bhi.revision = b.revision and bhi.alternative=b.alternative) item_header_base_quantity
				,      b.component_part
				,      b.quantity
				,      b.uom
				,      case when b.uom = 'g' 
									then (b.quantity/1000) 
									when b.uom = 'kg'
									then b.quantity
				                    else 0 end         quantity_kg 
				,      s.sort_desc
				FROM status               s
				,    specification_header sh
				,    bom_item             b
				,    sel_bom_header       h	   
				--select alleen gewicht van materialen...
				where b.part_no     = h.part_no
				and   b.alternative = h.alternative
				AND   b.revision    = h.revision
				and   h.part_no     = sh.part_no
                and   h.revision    = sh.revision
				and   sh.status     = s.status	
				) bi2;
      loop 
        fetch c_bom_items into l_mainpart  
                          ,l_mainrevision
						  ,l_mainplant
                          ,l_mainalternative
                          ,l_mainbasequantity
                          ,l_mainminqty
				          ,l_mainmaxqty
				          ,l_mainsumitemsquantity	
						  ,l_part_no 
                          ,l_revision
                          ,l_plant   
                          ,l_alternative
						  ,l_characteristic_id
                          ,l_item_header_base_quantity
                          ,l_component_part      
                          ,l_quantity            
                          ,l_uom                 
                          ,l_quantity_kg         
						  ;
        if (c_bom_items%notfound)   
        then CLOSE C_BOM_ITEMS;
	         exit;
	    end if;
        dbms_output.put_line(l_mainpart||';'||l_mainrevision||';'||l_mainalternative||';'||l_mainbasequantity||';'||l_mainsumitemsquantity||';'||l_component_part||';'||l_item_header_base_quantity||';'||l_quantity||';'||l_quantity_kg ||';'||l_uom||';'||l_characteristic_id );
        /*DBA_INSERT_WEIGHT_CALC (p_main_part_no=>l_mainpart
                               ,p_part_no=>l_part_no
							   ,p_component_part_no=>l_component_part
							   ,p_characteristic_id=>l_characteristic_id
		                       ,p_path=>l_path
							   ,p_quantity_path=>l_quantity_path
							   ,p_quantity_kg=>l_quantity_kg
							   ,p_excl_quantity_kg=>l_excl_quantity_kg
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
  end if;	 --show-items = J
  --
  if upper(l_show_incl_items_jn) = 'J'
  then   
    dbms_output.put_line('**************************************************************************************************************');
    dbms_output.put_line('BEREKEN TOTAALGEWICHT VAN HEADER: '||l_header_part_no );
    dbms_output.put_line('**************************************************************************************************************');
  end if;
  --
END;
/

show err



--***********************************************************************************************************************
--***********************************************************************************************************************
--***********************************************************************************************************************
--***********************************************************************************************************************
--***************  procedure   DBA_AANROEP_HEADER_BOM_GEWICHT                                                    ********
--***********************************************************************************************************************
--***********************************************************************************************************************
--***********************************************************************************************************************
--***********************************************************************************************************************

create or replace procedure DBA_AANROEP_HEADER_BOM_GEWICHT (p_header_part_no      varchar2   default 'ALLE' 
                                                           ,p_header_frame_id     varchar2   default 'A_PCR' 
														   ,p_aantal              number     default 1       )
DETERMINISTIC
AS
--AANROEP-procedure voor een totaal-controle van gewichten per HEADER-PART-NO op hoogste niveau.
--Selectie-criteria: Selectie vind plaats op view AV_BHR_BOM_HEADER_PART_NO.
--                   OBV: - part-no met status="CRRNT Q5"
--
--Parameters:  P_PART_NO = bom-item-header, Kan ook als FILTER gebruikt worden, ook met SUBSTRING van een PART-NO:
--                                          bijv.  EF_H215/60R16SP5X (controleer alleen header-spec = EF_H215/60R16SP5X)
--                                                 EF%               (controleer alle header-specs beginnend met EF%) 
--                                                 GF%               (controleer alle header-specs beginnend met GF%) 
--                                                 EF_Y245%          (controleer alle header-specs beginnend met EF_Y245)
--
--             P_FRAME_ID = frame-id, kan ook als filter gebruikt worden maar ALLEEN MET VOLLEDIG FRAME-ID, NIET MET SUBSTRING !!!!
--                                          bijv.  A_PCR             (controleer alle header-specs van type frame=A_PCR)
--
--             P_AANTAL = aantal rows output, werkt alleen indien P_PART_NO een volledig PART-NO betreft (dus niet SUBSTRING met "%" of ALLE)
--                                                 
--dependencies: FUNCTIE DBA_BEPAAL_QUANTITY_KG: functie om de quantity-string te vermenigvuldiger met PART-NO-BASE-QUANTITY 
--                                              om uiteindelijk het gewicht van BOM-HEADER obv MATERIALS-gewichten te berekenen.
--                                              Indien aangeroepen vanuit deze aanroep-procedure wordt er ALLEEN totaal-gewicht bepaald.
--
--Aanroep-voorbeelden:
-- 1) dba_aanroep_header_bom_gewicht('EF_H215/60R16SP5X', null    , null);    --haal alleen specifiek part-no op
-- 2) dba_aanroep_header_bom_gewicht('EF_H215/60R16SP5X', null    , 1);       --haal alleen specifiek part-no op
-- 3) dba_aanroep_header_bom_gewicht('EF_H215/60R16SP5X', null    , 10);      --haal vanaf specifiek part-no ook de volgende 9 part-no op.
-- 4) dba_aanroep_header_bom_gewicht('ALLE'             , 'A_PCR' , null);    --haal alle part-no van A_PCR op
-- 5) dba_aanroep_header_bom_gewicht('EF_H215/60R16SP5X', 'A_PCR' , null);    --haal specifiek part-no op (met juiste frame-id)
-- 6) dba_aanroep_header_bom_gewicht('EF_H215/60R16SP5X', 'A_PCR' , 10);      --haal specifiek part-no op (met juiste frame-id) en volgende 9 part-no op.
-- 7) dba_aanroep_header_bom_gewicht('EF%'              , ''      , 10);      --haal eerste 10 part-no op.
-- 8) dba_aanroep_header_bom_gewicht('EF%'              , 'A_PCR' , 10);      --haal eerste 10 part-no binnen frame-id op.
--
l_header_part_no           varchar2(100)   := p_header_part_no;
l_header_frame_id          varchar2(100)   := p_header_frame_id;
l_aantal                   number          := p_aantal;
--
cursor c_header_part_no (pl_header_part_no  varchar2 default '%'
                        ,pl_header_frame_id varchar2 default '%' 
						,pl_aantal          number   default 1   )
is
select * 
from av_bhr_bom_header_part_no   bh
where (  (   (  instr(p_header_part_no,'%') > 0
			 )
         and bh.part_no    like pl_header_part_no||'%'
         and bh.frame_id   like pl_header_frame_id||'%'
		 )
	  or (   instr(p_header_part_no,'%') = 0
	     and bh.part_no    >=   pl_header_part_no  
	     and bh.frame_id   like pl_header_frame_id||'%'
		 )
      )
and rownum < (l_aantal+1)
order by bh.part_no
;
--
BEGIN
  DBMS_OUTPUT.ENABLE(1000000);
  --part-no kan volledig part-no zijn (zonder %), een substring (met %) of waarde=ALLE bevatten.
  if upper(l_header_part_no) = 'ALLE'
  then l_header_part_no := '%';
  else l_header_part_no := upper(l_header_part_no);
  end if;
  --frame-id mag alleen waarde ALLE/<null> of volledig frame-id bevatten
  if nvl(upper(l_header_frame_id),'ALLE') = 'ALLE'
  then l_header_frame_id := '%';
  else l_header_frame_id := upper(l_header_frame_id);
  end if;
  --
  for r_header_part_no in c_header_part_no (l_header_part_no, l_header_frame_id)
  loop
    --aanroep procedure DBA_BEPAAL_BOM_GEWICHT
	--GEWICHT WORDT OP BASIS VAN PART-NO BEPAALD. SAP-CODE WORDT ALLEEN TER INFO MEEGEGEVEN !!
	dba_bepaal_bom_gewicht(p_header_part_no=>r_header_part_no.part_no
	                      ,p_header_sap_code=>r_header_part_no.sap_code
	                      ,p_show_incl_items_jn=>'N');
  end loop;
END;
/

show err



prompt
prompt einde script
prompt






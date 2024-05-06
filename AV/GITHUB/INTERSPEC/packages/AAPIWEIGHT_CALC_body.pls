create or replace PACKAGE BODY AAPIWEIGHT_CALC 
AS
psSource CONSTANT iapiType.Source_Type := 'aapiWeight_Calc';
--pnSectionMaterial CONSTANT iapiType.ID_Type := 701015;
-----------------------------------------------------------------------------------------------------------------
--Revision-History:
--REVISION DATE        WHO  DESCRIPTION
--       1 20-09-2022  PS   Incoporate all seperate functions/procedures in this new package!!!!
--       2 20-10-2022  PS   Extra afhandeling indien UOM=m, gelijk aan UOM=pcs, ophalen gewicht uit property.
--       3 22-11-2022  PS   Extra afhandeling indien UOM=ST of km, gelijk aan UOM=pcs, ophalen gewicht uit property.
--       4 14-12-2022  PS   procedure VERWERK-GEWICHT-MUTATIES aangepast,
--                          where clause in cursor c_part_tyre aangepast in CYCLE-gedeelte voor REVISION-check,
--                          part-no ipv component-part
--       5 16-12-2022  PS   procedure VERWERK-GEWICHT-MUTATIES aangepast,
--                          where clause in cursor c_part_tyre aangepast INPUT-PART moet matchen met component-part ipv part-no
--                          Anders worden de wijzigingen in materialen (en mn. gewicht in sap-property=weight) niet meegenomen !!!
--      14 19-12-2022  PS   Proceduere DBA-FNC-BEPAAL-HEADER-GEWICHT aangepast tbv WheelSetBox.
--                          Sum-constructie in totaal-telling (tweede-cursor) aangepast door eerst expliciet op UOM=kg te controleren.
--                          Daarmee voorkomen we errors voor materialen zonder SAP-information-property WEIGHT (UOM/QUANTITY)
--      15 19-01-2023  PS   Extra controle f_check_part_changed_weight ingebouwd in DBA_VERWERK_GEWICHT_MUTATIES om alleen voor tyres nieuwe
--                          gewichten te berekenen als op gewijzigde COMPONENT een gewichtsmutatie geweest is.
--
-----------------------------------------------------------------------------------------------------------------
-- GLOBAL VARIABLES:
--
gc_afrond    number := 10;   --afronden 10 cijfers achter de komma...
--
-----------------------------------------------------------------------------------------------------------------
--
--***************************************************************************************************************
-- PRIVATE BASE functions/procedures
--***************************************************************************************************************
procedure refresh_mv_bom_item_header 
is
begin
  dbms_mview.refresh('MV_BOM_ITEM_COMP_HEADER');
end refresh_mv_bom_item_header ;
--
procedure dba_insert_weight_comp_part (p_tech_calculation_date date default null
                                      ,p_datum_verwerking      date default null
                                      ,p_mainpart              varchar2
                                      ,p_mainrevision          number
                                      ,p_mainplant             varchar2
                                      ,p_mainalternative       number
                                      ,p_mainframeid           varchar2
                                      ,p_part_no               varchar2
                                      ,p_revision              number
                                      ,p_plant                 varchar2
                                      ,p_alternative           number
                                      ,p_header_issueddate     date
                                      ,p_header_status         varchar2
                                      ,p_component_part_no     varchar2
                                      ,p_component_description varchar2
                                      ,p_component_revision    number
                                      ,p_component_alternative number
                                      ,p_component_issueddate  date
                                      ,p_component_status      varchar2
                                      ,p_characteristic_id     number
                                      ,p_functiecode           varchar2
                                      ,p_path                  varchar2
                                      ,p_quantity_path         varchar2
                                      ,p_bom_quantity_kg       number
                                      ,p_comp_part_eenheid_kg  number
                                      ,p_remark                varchar2
                                      ,p_lvl                   varchar2
                                      ,p_lvl_tree              varchar2
                                      ,p_item_number           number
                                      ,p_sap_article_code       varchar2
                                      ,p_sap_da_article_code    varchar2
                                      ) 
is
pragma autonomous_transaction;
--procedure om bom-header-components incl. unit-kg op te slaan voor SAP-INTERAFACE !!
--
--Aangeroepen vanuit:  DBA_BEPAAL_COMP_PART_GEWICHT (met parameter P_INSERT_WEIGHT_COMP_JN="J" )
--
--ID:                   wordt gevuld vanuit INSERT trigger dba_weight_component_part.DBA_WEIGHT_COMP_PART_BRI !!
--TECH_CALCULATION_DATE wordt gevuld vanuit aanroepende procedure DBA_BEPAAL_COMP_PART_GEWICHT
--                      zodat deze datum voor alle COMPONENT-PARTS van een BAND/TYRE hetzelfde is, maar indien deze leeg
--                      gelaten worden dan wordt deze alsnog gevuld door trigger dba_weight_component_part.DBA_WEIGHT_COMP_PART_BRI 
--
l_calc_date   date;
l_message     varchar2(4000);
begin
  --
  insert into DBA_WEIGHT_COMPONENT_PART
  (tech_calculation_date
  ,datum_verwerking
  ,mainpart
  ,mainrevision
  ,mainplant
  ,mainalternative
  ,mainframeid
  ,part_no
  ,revision
  ,plant
  ,alternative
  ,header_issueddate
  ,header_status
  ,component_part_no
  ,component_description
  ,component_revision
  ,component_alternative
  ,component_issueddate
  ,component_status
  ,characteristic_id
  ,functiecode
  ,path
  ,quantity_path
  ,bom_quantity_kg
  ,comp_part_eenheid_kg
  ,remark    
  ,lvl
  ,lvl_tree  
  ,item_number
  ,sap_article_code
  ,sap_da_article_code
  )
  values
  (p_tech_calculation_date
  ,p_datum_verwerking
  ,p_mainpart
  ,p_mainrevision
  ,p_mainplant
  ,p_mainalternative
  ,p_mainframeid
  ,p_part_no
  ,p_revision
  ,p_plant
  ,p_alternative
  ,p_header_issueddate
  ,p_header_status
  ,p_component_part_no
  ,p_component_description
  ,p_component_revision
  ,p_component_alternative
  ,p_component_issueddate
  ,p_component_status
  ,p_characteristic_id
  ,p_functiecode
  ,p_path
  ,p_quantity_path
  ,p_bom_quantity_kg
  ,p_comp_part_eenheid_kg         
  ,p_remark 
  ,p_lvl
  ,p_lvl_tree
  ,p_item_number
  ,p_sap_article_code
  ,p_sap_da_article_code
  );
  --
  commit;
  --
exception
  when others
  then
    l_message := 'ALG-EXCP-DBA-INSERT-WEIGHT-COMP_PAR ERROR CALC-DATE: '||p_tech_calculation_date||' MAINPART: '||p_mainpart||' PART_NO: '||p_part_no||'-'||p_revision||' ALT: '||P_alternative||' ITEM-NR: '||p_item_number||' COMP-PART: '||P_COMPONENT_PART_NO||'-'||p_component_revision||
                            ' CHR: '||P_CHARACTERISTIC_ID||' path: '||P_PATH||' LVL: '||p_lvl; 
    dbms_output.put_line(l_message||' : '||sqlerrm);
    --null;
end dba_insert_weight_comp_part;
--
--
--
--***************************************************************************************************************
-- SELECT BOM-STRUCTURE functions/procedures
--***************************************************************************************************************
--
PROCEDURE SELECT_PART_GEWICHT (p_header_part_no      IN  varchar2 default null
                              ,p_header_revision     in  number   default null
                              ,p_header_alternative  IN  number   default 1 ) 
DETERMINISTIC
AS
--Script om per PART/bom-header de gewichten te berekenen !
--SELECTIE ZIT HIERBIJ ALLEEN OP DE ONDERSTE BOM-ITEMS (=MATERIALEN/GRONDSTOFFEN) MET EEN UOM=KG
--LET OP: ALLE TUSSENLIGGENDE BOM-ITEM (RELATIES PART-NO/COMPONENT-PART) WORDEN HIERBIJ WEL GEBRUIKT VOOR SELECTIE,
--        MAAR DE KG VOOR DE GEWICHTSBEREKENING GENEGEERD !!!
--LET OP: Het komt voor dat er wel een BOM-ITEM-RELATIE bestaat tussen part-no + component-part maar dat
--        de component-part ondertussen al wel een HISTORIC-status heeft gekregen. 
--        In dit geval moet COMPONENT-PART wel in gewichtsberekening worden meegenomen, alhoewel de band/component-part
--        niet meer geproduceerd kan worden. De band zelf kan dan nog CURRENT-status hebben, maar gerelateerde component-part niet.
--
--Parameters:  P_HEADER_PART_NO = bom-item-header, bijv.  EF_Y245/35R20QPRX (prod)
--                                                        EF_W245/40R18WPRX (test-FOUTIEVE CURSOR)
--                                                        EF_710/40R22FLT162 (test)
--                         LET OP: Er komen XG-tyres uit hongarije voor met lowercase-characters in de naamgeving van PARTNO.
--                                 Om deze reden geen UPPER-gebruiken !!!
--
--             P_HEADER_REVISION = Indien NULL/GEEN REVISION meegegeven, dan wordt MAX-REVISION eerst opgehaald bij P_HEADER_PART-NO.
--                                 Dit is bom-item-header-revision-number van CURRENT/HISTORIC header.
--                                 Indien een TYRE zal status altijd CURRENT zijn. 
--                                 Een component kan zelf al HISTORIC zijn maar zolang hij in BOM-ITEM zit moet hij wel worden meegenomen.
--                                 Ook de COMPONENT-BOM-HEADER kan zelfs al HISTORIC zijn...Dan alsnog meenemen in de berekening !!!
--
--             P_HEADER_ALTERNATIVE = Indien NULL/GEEN-ALTERNATIVE meegegeven dan wordt PREFERRED-ALTERNATIVE eerst opgehaald bij P_HEADER_PART_NO.
--                                    Dit is bom-item-header-alternative van CURRENT/HISTORIC-header met PREFERRED=1.
--                                    Een ALTERNATIVE waarbij PREFERRED=0, doet niet mee in TYRE-WEIGHT-berekening, maar moet 
--                                    wel worden berekend voor SAP-WEIGHT.
--
--dependencies: FUNCTIE DBA_BEPAAL_QUANTITY_KG: functie om de quantity-string te vermenigvuldiger met PART-NO-BASE-QUANTITY 
--                                              om uiteindelijk het gewicht van BOM-HEADER obv MATERIALS-gewichten te berekenen.
--
--********************************************************************************************************************************
--REVISION DATE        WHO  DESCRIPTION
--      1  03-10-2022  PS   initial 
--********************************************************************************************************************************
--
pl_header_part_no            varchar2(100)   := p_header_part_no;
pl_header_revision           number          := p_header_revision;
pl_header_alternative        number          := p_header_alternative;
pl_header_preferred          number;                  --preferred-ind bij header/alternative
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
l_item_number               number;
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
  --PS: haal max(spec-revision) op waarvoor nog een bom-header-revision voor bestaat...
    begin
      select max(sh1.revision) 
    into pl_header_revision
    from status               s1
    ,    specification_header sh1 
    ,    bom_header           bh
    where bh.part_no   = pl_header_part_no 
    and   sh1.part_no  = bh.part_no 
    AND   sh1.revision = bh.revision
    and   sh1.status   = s1.status 
    and   s1.status_type in ('CURRENT','HISTORIC')
    ;
  exception
    when others 
    then dbms_output.put_line('REVISION-EXCP: Revision kon niet bepaald worden voor partno: '||pl_header_part_no||' rev: '||pl_header_revision);
    end;
  end if;
  if pl_header_alternative is null
  then
    --indien er geen alternative is meegegeven dan alsnog eerst zelf ophalen
    --PS: haal ALTERNATIVE op bij REVISION waarbij PREFERRED=1 
    begin
      select bh.alternative
      ,      bh.preferred
      into pl_header_alternative
      ,    pl_header_preferred
      from bom_header           bh
      where bh.part_no   = pl_header_part_no 
      and   bh.revision  = pl_header_revision 
      and   bh.preferred = 1
      ;
    exception
      when others 
      then dbms_output.put_line('ALTERNATIVE-EXCP: ALTERNATIVE kon niet bepaald worden voor partno: '||pl_header_part_no||' rev: '||pl_header_revision);
      end;
    else
      --indien er WEL alternative is meegegeven dan alsnog de PREFERRED-IND ERBIJ ophalen
      --PS: haal preferred op bij ALTERNATIVE op bij header-REVISION  
      begin
        select bh.preferred
        into pl_header_preferred
        from bom_header           bh
        where bh.part_no     = pl_header_part_no 
        and   bh.revision    = pl_header_revision 
        and   bh.alternative = pl_header_alternative
        ;
      exception
        when others 
        then dbms_output.put_line('PREFERRED-EXCP: PREFERRED kon niet bepaald worden voor partno: '||pl_header_part_no||' rev: '||pl_header_revision||' alt: '||pl_header_alternative);
      end;
      --
    end if;
    dbms_output.put_line('**************************************************************************************************************');
    dbms_output.put_line('SELECT-PART-GEWICHT.HEADER-MAINPART: '||pl_header_part_no ||' revision: '||pl_header_revision||' alternative: '||pl_header_alternative );
    dbms_output.put_line('**************************************************************************************************************');
    --Indien parameter =SHOW-ITEMS=ja
    BEGIN
      dbms_output.put_line('L_LVL'||';'||'l_mainpart'||';'||'l_mainrevision'||';'||'l_mainplant'||';'||'l_mainalternative'||';'||'l_mainbasequantity'||';'||'l_mainsumitemsquantity'||';'||'l_mainstatus'||';'||'l_mainframeid'||';'||'l_mainpartdescription'||';'||'l_mainpartbaseuom'||
                        ';'||'l_part_no'||';'||'l_revision'||';'||'l_alternative'||';'||'l_item_header_base_quantity'||';'||'l_bom_item'||';'||'l_component_part'||';'||'l_componentdescription'||';'||'l_quantity'||';'||'l_uom'||
              ';'||'l_quantity_kg'||';'||'l_path'||';'||'l_quantity_path'||';'||'l_bom_quantity_kg'||';'||'l_status'||';'||'l_characteristic_id'||';'||'l_functiecode' );      

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
        ,      bi2.item_number
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
         ,      bh.preferred
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
                 --and    bh.preferred = 1         
         and    bh.alternative = pl_header_alternative  --default alternative bij preferred=1, maar kan ook expliciet preferred=0
         and    rownum = 1
        ) 
        select LEVEL   LVL
        ,      RPAD('.', (level-1)*2, '.') || LEVEL AS level_tree
        ,      bh.part_no             mainpart
        ,      bh.revision            mainrevision
                ,      bh.plant               mainplant
        ,      bh.alternative         mainalternative
        ,      bh.base_quantity       mainbasequantity
          ,      bh.min_qty             mainminqty
        ,      bh.max_qty             mainmaxqty
        ,      bh.sum_items_quantity  mainsumitemsquantity
        ,      bh.sort_desc           mainstatus
        ,      bh.frame_id            mainframeid
        ,      bh.description         mainpartdescription
        ,      bh.base_uom            mainpartbaseuom
        ,      b.part_no
        ,      b.revision
        ,      b.plant
        ,      b.alternative
        ,      b.item_number
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
                 ,      bi.item_number
                 ,      bi.component_part
                 --,      (select bh.base_quantity from bom_header bh where bh.part_no = bi.part_no and bh.revision = bi.revision and bh.alternative= bi.alternative )   item_header_base_quantity
                 ,      h.base_quantity   item_header_base_quantity
                 ,      bi.quantity
                 ,      case when bi.uom = 'pcs'
                        then (--indien een material met uom=pcs dan weight uit property halen, en uom aanpassen naar "kg"
                              SELECT 'kg'
                              FROM specification_prop sp
                              WHERE sp.part_no        = bi.component_part   --'GR_9787'
                              --PS: gebruik component-item/header-spec-header-revision
                              --PS: gebruik component-item/spec-header-revision, MATERIALS hebben alleen SPECIFICATION-header, geen bom-header !!!
                              AND   sp.revision  = (select max(sh1.revision) 
                                                    from status s1, specification_header sh1
                                                    where   sh1.part_no    = sp.part_no             --is component-part-no
                                                    and     sh1.status     = s1.status 
                                                    and     s1.status_type in ('CURRENT','HISTORIC')
                                                   )
                              AND   sp.section_id     = 700755 --  SAP information
                              AND   sp.sub_section_id = 701502 -- A
                              AND   sp.property_group = 0 -- (none)
                              AND   sp.property       = 703262 -- Weight
                              UNION
                              --indien component-part met uom=pcs dan aantal meenemen in de berekening
                              select 'pcs' 
                              from dual
                              where exists (select '' from bom_item bi3 where bi3.part_no = bi.component_part )   --revision = header-revision, geen comp-revision, dus kunnen hier niet expliciet op checken...
                             )
                         else bi.uom 
                         end   uom
                 ,      case when bi.uom = 'g' 
                        then (bi.quantity/1000) 
                        when bi.uom = 'kg'
                        then bi.quantity
                        when bi.uom = 'pcs'
                        then (--indien een material met uom=pcs dan weight uit property halen
                              SELECT (sp.num_1 * bi.quantity)
                              FROM specification_prop sp
                              WHERE sp.part_no        = bi.component_part   --'GR_9787'
                              --PS: gebruik component-item/spec-header-revision, MATERIALS hebben alleen SPECIFICATION-header, geen bom-header !!!
                              AND   sp.revision  = (select max(sh1.revision) 
                                                    from status s1, specification_header sh1
                                                    where   sh1.part_no    = sp.part_no        --is component-part-no
                                                    and     sh1.status     = s1.status 
                                                    and     s1.status_type in ('CURRENT','HISTORIC')
                                                   )
                              AND   sp.section_id     = 700755 --  SAP information
                              AND   sp.sub_section_id = 701502 -- A
                              AND   sp.property_group = 0 -- (none)
                              AND   sp.property       = 703262 -- Weight
                              UNION
                              --indien component-part met uom=pcs dan aantal meenemen in de berekening
                              select bi.quantity 
                              from dual
                              where exists (select '' from bom_item bi3 where bi3.part_no = bi.component_part )   --revision = header-revision, geen comp-revision, dus kunnen hier niet expliciet op checken...
                             )
                        else bi.quantity end   quantity_kg
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
    						 --zoek hoogste specification-revision waar nog een bom-header bij voorkomt 
     						 and   h.revision   =  (select max(sh1.revision) 
    						                        from status s1, specification_header sh1, bom_header h2 
                 												where   h2.part_no  = h.part_no 
                												and    sh1.part_no  = h2.part_no 
                												AND    sh1.revision = h2.revision 
                												and    sh1.status   = s1.status 
                												and    s1.status_type in ('CURRENT','HISTORIC')
              											   )
    						 --and   h.preferred    = 1
		    				 and   h.preferred    = decode(h.part_no, pl_header_part_no, pl_header_preferred, 1)     --indien 1e Keer dan uitgaan van meegegeven alternative, verder weer uitgaan met preferred.
    						 and   h.alternative  = decode(h.part_no, pl_header_part_no, pl_header_alternative, h.alternative)
		    				 and   h.alternative  = bi.alternative
				         and   h.part_no      = sh.part_no
                 and   h.revision     = sh.revision
    						 and   sh.status      = s.status	
    						 --and   s.status_type  = 'CURRENT' 
	 			         and   bi.ch_1        = c.characteristic_id(+)
		  			   ) b
				,      sel_bom_header bh	   
				START WITH b.part_no = bh.part_no 
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
                          ,l_item_number
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
	      --Wordt alleen getoond indien PL_SHOW_INCL_ITEMS_JN="J":
        --dbms_output.put_line('HEADER: '||l_mainpart||';'||l_mainrevision||';'||l_mainplant||';'||l_mainalternative||';'||l_mainbasequantity||';'||l_mainsumitemsquantity||';'||l_mainstatus||';'||l_mainframeid||';'||l_mainpartdescription||';'||l_mainpartbaseuom||
        --               ';'||l_part_no||';'||l_item_header_base_quantity||';'||l_component_part||';'||l_componentdescription||';'||l_quantity||';'||l_uom||';'||l_quantity_kg ||';'||l_path||';'||l_quantity_path||';'||l_bom_quantity_kg||';'||l_status||';'||l_characteristic_id||';'||l_functiecode );
        dbms_output.put_line('HEADER: '||L_LVL||';'||l_mainpart||';'||l_mainrevision||';'||l_mainplant||';'||l_mainalternative||';'||l_mainbasequantity||';'||l_mainsumitemsquantity||';'||l_mainstatus||';'||l_mainframeid||';'||l_mainpartdescription||';'||l_mainpartbaseuom||
                            ';'||l_part_no||';'||l_revision||';'||l_alternative||';'||l_item_header_base_quantity||';'||l_item_number||';'||l_component_part||';'||l_componentdescription||';'||l_quantity||';'||l_uom||
					        ';'||l_quantity_kg ||';'||l_path||';'||l_quantity_path||';'||l_bom_quantity_kg||';'||l_status||';'||l_characteristic_id||';'||l_functiecode );
		    --
        --exit;	  
      end loop;
      close c_bom_items;  
	  --
	EXCEPTION
	  WHEN OTHERS 
	  THEN if sqlerrm not like '%ORA-01001%' 
           THEN dbms_output.put_line('SELECT-PART-GEWICHT: ALG-EXCP BOM-ITEMS: '||SQLERRM); 
           else null;   
           end if;
	END;
	--
end SELECT_PART_GEWICHT;  
--
PROCEDURE SELECT_LEVEL_PART (p_header_part_no      IN  varchar2 default null
                            ,p_header_revision     in  number   default null
                            ,p_header_alternative  IN  number   default 1 
                            ,p_level               IN  number   default 2 ) 
DETERMINISTIC
AS
--Script om voor een HEADER/TYRE ALLE COMPONENT-PART de BASE/gewichten van onderliggende COMPONENT-PART-ITEMS tm een LEVEL te SELECTEREN !
--De COMPONENT-MATERIALS worden NIET geselecteerd !!!
--EN het gewicht zelf wordt NIET berekend, Alleen de info wordt opgehaald.
--
--SELECTIE ZIT HIERBIJ ALLEEN OP DE ONDERSTE BOM-ITEMS DIE ALS EEN COMPONENT BINNEN TYRE VOORKOMEN !!!
--
--LET OP: ALLE TUSSENLIGGENDE BOM-ITEM (RELATIES PART-NO/COMPONENT-PART) WORDEN HIERBIJ GEBRUIKT VOOR SELECTIE
--LET OP: Het komt voor dat er wel een BOM-ITEM-RELATIE bestaat tussen part-no + component-part maar dat
--        de component-part ondertussen al wel een HISTORIC-status heeft gekregen. 
--        In dit geval moet COMPONENT-PART wel in gewichtsberekening worden meegenomen, alhoewel de band/component-part
--        niet meer geproduceerd kan worden. De band zelf kan dan nog CURRENT-status hebben, maar gerelateerde component-part niet.
--
--Parameters:  P_HEADER_PART_NO = bom-item-header, bijv.  EF_Y245/35R20QPRX (prod)
--                                                        EF_W245/40R18WPRX (test-FOUTIEVE CURSOR)
--                                                        EF_710/40R22FLT162 (test)
--                         LET OP: Er komen XG-tyres uit hongarije voor met lowercase-characters in de naamgeving van PARTNO.
--                                 Om deze reden geen UPPER-gebruiken !!!
--
--             P_HEADER_REVISION = Indien NULL/GEEN REVISION meegegeven, dan wordt MAX-REVISION eerst opgehaald bij P_HEADER_PART-NO.
--                                 Dit is bom-item-header-revision-number van CURRENT/HISTORIC header.
--                                 Indien een TYRE zal status altijd CURRENT zijn. 
--                                 Een component kan zelf al HISTORIC zijn maar zolang hij in BOM-ITEM zit moet hij wel worden meegenomen.
--                                 Ook de COMPONENT-BOM-HEADER kan zelfs al HISTORIC zijn...Dan alsnog meenemen in de berekening !!!
--
--             P_HEADER_ALTERNATIVE = Indien NULL/GEEN-ALTERNATIVE meegegeven dan wordt PREFERRED-ALTERNATIVE eerst opgehaald bij P_HEADER_PART_NO.
--                                    Dit is bom-item-header-alternative van CURRENT/HISTORIC-header met PREFERRED=1.
--                                    Een ALTERNATIVE waarbij PREFERRED=0, doet niet mee in TYRE-WEIGHT-berekening, maar moet 
--                                    wel worden berekend voor SAP-WEIGHT.
--
--dependencies: FUNCTIE DBA_BEPAAL_QUANTITY_KG: functie om de quantity-string te vermenigvuldiger met PART-NO-BASE-QUANTITY 
--                                              om uiteindelijk het gewicht van BOM-HEADER obv MATERIALS-gewichten te berekenen.
--
--********************************************************************************************************************************
--REVISION DATE        WHO  DESCRIPTION
--      1  03-10-2022  PS   initial 
--********************************************************************************************************************************
--
pl_header_part_no            varchar2(100)   := p_header_part_no;
pl_header_revision           number          := p_header_revision;
pl_header_alternative        number          := p_header_alternative;
pl_level                     number          := p_level;
pl_header_preferred          number;         --preferred-ind bij header/alternative
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
l_item_number               number;
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
l_afronden                  number   := 5;    --afronden van gewichten op 5 posities achter de komma...
l_weight_factor_up          number;           --DIT IS WEIGHT-FACTOR FOR PART-NO TO BRING WEIGHT ONE LEVEL UP TO ITS OWN HEADER
l_bom_quantity_kg           varchar2(100);    --DIT IS MATERIAAL-GEWICHT OPGEWERKT NAAR HEADER, 
                                              --BIJ NORMALE COPONENT-PARTS IS DIT DE WEIGHT-FACTOR OM DEZE TOP-DOWN DOOR TE GEVEN OM 
                                              --UITEINDELIJK HET GEWICHT VAN MATERIALEN BINNEN HEADER TE KUNNEN BEREKENEN
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
  --PS: haal max(spec-revision) op waarvoor nog een bom-header-revision voor bestaat...
    begin
      select max(sh1.revision) 
    into pl_header_revision
    from status               s1
    ,    specification_header sh1 
    ,    bom_header           bh
    where bh.part_no   = pl_header_part_no 
    and   sh1.part_no  = bh.part_no 
    AND   sh1.revision = bh.revision
    and   sh1.status   = s1.status 
    and   s1.status_type in ('CURRENT','HISTORIC')
    ;
  exception
    when others 
    then dbms_output.put_line('REVISION-EXCP: Revision kon niet bepaald worden voor partno: '||pl_header_part_no||' rev: '||pl_header_revision);
    end;
  end if;
  if pl_header_alternative is null
  then
    --indien er geen alternative is meegegeven dan alsnog eerst zelf ophalen
    --PS: haal ALTERNATIVE op bij REVISION waarbij PREFERRED=1 
    begin
      select bh.alternative
      ,      bh.preferred
      into pl_header_alternative
      ,    pl_header_preferred
      from bom_header           bh
      where bh.part_no   = pl_header_part_no 
      and   bh.revision  = pl_header_revision 
      and   bh.preferred = 1
      ;
    exception
      when others 
      then dbms_output.put_line('ALTERNATIVE-EXCP: ALTERNATIVE kon niet bepaald worden voor partno: '||pl_header_part_no||' rev: '||pl_header_revision);
      end;
    else
      --indien er WEL alternative is meegegeven dan alsnog de PREFERRED-IND ERBIJ ophalen
      --PS: haal preferred op bij ALTERNATIVE op bij header-REVISION  
      begin
        select bh.preferred
        into pl_header_preferred
        from bom_header           bh
        where bh.part_no     = pl_header_part_no 
        and   bh.revision    = pl_header_revision 
        and   bh.alternative = pl_header_alternative
        ;
      exception
        when others 
        then dbms_output.put_line('PREFERRED-EXCP: PREFERRED kon niet bepaald worden voor partno: '||pl_header_part_no||' rev: '||pl_header_revision||' alt: '||pl_header_alternative);
      end;
      --
    end if;
    --
    if pl_level is null
    then
      pl_level := 99;
    end if;
    --    
    dbms_output.put_line('**********************************************************************************************************************');
    dbms_output.put_line('SELECT-LEVEL-PART: MAINPART: '||pl_header_part_no ||' revision: '||pl_header_revision||' alternative: '||pl_header_alternative ||' LEVEL='||pl_level);
    dbms_output.put_line('**********************************************************************************************************************');
    --Indien parameter =SHOW-ITEMS=ja
    BEGIN
      dbms_output.put_line('L_LVL'||';'||'l_mainpart'||';'||'l_mainrevision'||';'||'l_mainplant'||';'||'l_mainalternative'||';'||'l_mainbasequantity'||';'||'l_mainsumitemsquantity'||';'||'l_mainstatus'||';'||'l_mainframeid'||';'||'l_mainpartdescription'||';'||'l_mainpartbaseuom'||
                        ';'||'l_part_no'||';'||'l_revision'||';'||'l_alternative'||';'||'l_item_header_base_quantity'||';'||'l_item_number'||';'||'l_component_part'||';'||'l_componentdescription'||';'||'l_quantity'||';'||'l_uom'||
              ';'||'l_quantity_kg'||';'||'l_path'||';'||'l_quantity_path'||';'||'l_bom_quantity_kg'||';'||'l_status'||';'||'l_characteristic_id'||';'||'l_functiecode' );      
      --init
      --Tonen van totale-gewicht van BOM-HEADER:
      open c_bom_items for 
       --select mainpart
       --,      mainbasequantity
       --,      LVL
       --,      part_no
       --,      revision
       --,      item_header_base_quantity
       --,      component_part
       --,      quantity_kg
       --from
        SELECT bi2.LVL
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
        ,      bi2.item_number
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
        ,      bi2.weight_factor_up
        ,      DBA_BEPAAL_QUANTITY_KG(bi2.quantity_path)    bom_quantity_kg
        from
        (
        with sel_bom_header as 
        (select bh.part_no
         ,      bh.revision
         ,      bh.plant
         ,      bh.alternative
         ,      bh.preferred
         ,      bh.base_quantity
         ,      bh.min_qty
         ,      bh.max_qty
         ,      (select sum(case 
                            when b.uom = 'g' 
                            then (b.quantity/1000) 
                            when b.uom = 'kg'
                            then b.quantity
                            else 0 end) 
                 from bom_item b 
                 where b.part_no = bh.part_no 
                 and b.revision = bh.revision 
                 and b.alternative = bh.alternative)        sum_items_quantity
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
                 --and    bh.preferred = 1         
         and    bh.alternative = pl_header_alternative  --default alternative bij preferred=1, maar kan ook expliciet preferred=0
         and    rownum = 1
        ) 
        select LEVEL   LVL
        ,      RPAD('.', (level-1)*2, '.') || LEVEL AS level_tree
        ,      bh.part_no             mainpart
        ,      bh.revision            mainrevision
        ,      bh.plant               mainplant
        ,      bh.alternative         mainalternative
        ,      bh.base_quantity       mainbasequantity
        ,      bh.min_qty             mainminqty
        ,      bh.max_qty             mainmaxqty
        ,      bh.sum_items_quantity  mainsumitemsquantity
        ,      bh.sort_desc           mainstatus
        ,      bh.frame_id            mainframeid
        ,      bh.description         mainpartdescription
        ,      bh.base_uom            mainpartbaseuom
        ,      b.part_no
        ,      b.revision
        ,      b.plant
        ,      b.alternative
        ,      b.item_number
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
        ,      (b.quantity_kg / b.item_header_base_quantity)                                         weight_factor_up
        FROM   ( SELECT bi.part_no
                 ,      bi.revision
                 ,      bi.plant
                 ,      bi.alternative
                 ,      bi.item_number
                 ,      bi.component_part
                 --,      (select bh.base_quantity from bom_header bh where bh.part_no = bi.part_no and bh.revision = bi.revision and bh.alternative= bi.alternative )   item_header_base_quantity
                 ,      h.base_quantity   item_header_base_quantity
                 ,      bi.quantity
                 ,      case 
                        when bi.uom IN ('pcs','m')
                        then (--indien een material met uom=pcs dan weight uit property halen, en uom aanpassen naar "kg"
                              SELECT 'kg'
                              FROM specification_prop sp
                              WHERE sp.part_no        = bi.component_part   --'GR_9787'
                              --PS: gebruik component-item/header-spec-header-revision
                              --PS: gebruik component-item/spec-header-revision, MATERIALS hebben alleen SPECIFICATION-header, geen bom-header !!!
                              AND   sp.revision       = (select max(sh1.revision) 
                                                         from status s1, specification_header sh1
                                                         where   sh1.part_no    = sp.part_no             --is component-part-no
                                                         and     sh1.status     = s1.status 
                                                         and     s1.status_type in ('CURRENT','HISTORIC')
                                                        )
                              AND   sp.section_id     = 700755 --  SAP information
                              AND   sp.sub_section_id = 701502 -- A
                              AND   sp.property_group = 0 -- (none)
                              AND   sp.property       = 703262 -- Weight
                              UNION
                              --indien component-part met uom=pcs dan aantal meenemen in de berekening
                              select 'pcs-m' 
                              from dual
                              where exists (select '' from bom_item bi3 where bi3.part_no = bi.component_part )   --revision = header-revision, geen comp-revision, dus kunnen hier niet expliciet op checken...
                              )
                        else bi.uom end   uom
                 --,      bi.uom
                 ,      case when bi.uom = 'g' 
                        then (bi.quantity/1000) 
                        when bi.uom = 'kg'
                        then bi.quantity
                        when bi.uom in ('pcs','m')
                        then (--indien een material met uom=pcs dan weight uit property halen
                              SELECT (sp.num_1 * bi.quantity)
                              FROM specification_prop sp
                              WHERE sp.part_no        = bi.component_part   --'GR_9787'
                              --PS: gebruik component-item/spec-header-revision, MATERIALS hebben alleen SPECIFICATION-header, geen bom-header !!!
                              AND   sp.revision       = (select max(sh1.revision) 
                                                         from status s1, specification_header sh1
                                                         where   sh1.part_no    = sp.part_no        --is component-part-no
                                                         and     sh1.status     = s1.status 
                                                         and     s1.status_type in ('CURRENT','HISTORIC')
                                                        )
                              AND   sp.section_id     = 700755 --  SAP information
                              AND   sp.sub_section_id = 701502 -- A
                              AND   sp.property_group = 0 -- (none)
                              AND   sp.property       = 703262 -- Weight
                              UNION
                              --indien component-part met uom=pcs dan aantal meenemen in de berekening
                              select bi.quantity 
                              from dual
                              where exists (select '' from bom_item bi3 where bi3.part_no = bi.component_part )   --revision = header-revision, geen comp-revision, dus kunnen hier niet expliciet op checken...
                              )
                        else bi.quantity end   quantity_kg
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
                 --zoek hoogste specification-revision waar nog een bom-header bij voorkomt
                 and   h.revision   =  (select max(sh1.revision) 
						                            from status s1, specification_header sh1, bom_header h2 
								                        where   h2.part_no  = h.part_no 
                                        and    sh1.part_no  = h2.part_no 
                                        AND    sh1.revision = h2.revision 
                                        and    sh1.status   = s1.status 
                                        and    s1.status_type in ('CURRENT','HISTORIC')
                                       )
      					 --and   h.preferred    = 1
			           and   h.preferred    = decode(h.part_no, pl_header_part_no, pl_header_preferred, 1)     --indien 1e Keer dan uitgaan van meegegeven alternative, verder weer uitgaan met preferred.
						     and   h.alternative  = decode(h.part_no, pl_header_part_no, pl_header_alternative, h.alternative)
						     and   h.alternative  = bi.alternative
				         and   h.part_no      = sh.part_no
                 and   h.revision     = sh.revision
  					     and   sh.status      = s.status	
     						 --and   s.status_type  = 'CURRENT' 
				         and   bi.ch_1        = c.characteristic_id(+)
					   ) b
				,      sel_bom_header bh	   
				START WITH b.part_no = bh.part_no 
				CONNECT BY NOCYCLE PRIOR b.component_part = b.part_no --and b.component_revision = b.revision
				order siblings by b.part_no
				)  bi2
				--select alleen gewicht van materialen...
        --PS: ALLEEN EVEN UITGEZET OM OVERZICHT TE KRIJGEN...
				where bi2.component_part IN (select bi3.part_no from bom_item bi3 where bi3.part_no = bi2.component_part)
        and   bi2.LVL <= PL_LEVEL
       ;
      loop
        --
        --dbms_output.put_line('in loop, voor fetch');
        --fetch c_bom_items into l_header_mainpart, l_mainbasequantity, l_LVL, l_part_no, l_revision, l_item_header_base_quantity, l_component_part, l_quantity_kg ; --, l_header_gewicht, l_header_bom_gewicht_som_items;
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
                          ,l_item_number
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
                          ,l_weight_factor_up  
                          ,l_bom_quantity_kg    --gewicht-materiaal opgewerkt naar header
						  ;
        --
        if (c_bom_items%notfound)   
        then CLOSE C_BOM_ITEMS;
	         exit;
        end if;
        --
        l_weight_factor_up := round(l_weight_factor_up, l_afronden);
        l_bom_quantity_kg  := round(l_bom_quantity_kg, l_afronden);
        --Betekenis:
        --CQ = Component Quantity uit BOM-ITEM
        --BHQ = Base Quantity from PART-NO uit BOM_HEADER
        --BOM-Q = Gewicht van COMPONENT binnen PART-NO
        --WFup = WEIGHT-FACTOR to bring BOM-Q van een COMPONENT 1 LEVEL omhoog naar HEADER van PART-NO.
        dbms_output.put_line(l_mainpart||' MBQ:'||l_mainbasequantity||' LVL:'||l_lvl||' '||L_LEVEL_TREE||' Part_no:'||l_part_no||' Rev:'||l_revision||' Alt:'||l_alternative||' BHQ:'||l_item_header_base_quantity||
                            'ItemNumber: '||l_item_number||' CompPart:'||l_component_part||'-'||l_componentdescription||' CQ:'||l_quantity_kg ||' Path:'||l_path ||' Q-path:'||l_quantity_path||' WFup(CQ/BHQ):'||l_weight_factor_up||' BOM-Q:'||l_bom_quantity_kg );  
        --per component ook direct gerelateerd material tonen
        if l_mainpart = l_part_no
        then
          DBA_SELECT_PART_MATERIALS (p_header_part_no=>l_part_no, p_header_revision=>l_revision,p_alternative=>l_alternative); 
        else
          DBA_SELECT_PART_MATERIALS (p_header_part_no=>l_component_part, p_header_revision=>null,p_alternative=>null); 
        end if;
        --exit;	  
      end loop;
      close c_bom_items;  
   	  --
	EXCEPTION
	  WHEN OTHERS 
	  THEN if sqlerrm not like '%ORA-01001%' 
           THEN dbms_output.put_line('SELECT-LEVEL-PART: ALG-EXCP BOM-ITEMS: '||SQLERRM); 
           else null;   
           end if;
	END;
	--
end SELECT_LEVEL_PART; 
--
PROCEDURE SELECT_TYRE_LEVEL_PART_WEIGHT (p_header_part_no      IN  varchar2 default null
                                        ,p_header_revision     in  number   default null
                                        ,p_header_alternative  IN  number   default 1 
                                        ,p_level               IN  number   default 2 ) 
DETERMINISTIC
AS
--Script om voor een HEADER/TYRE ALLE COMPONENT-PART de BASE/gewichten van onderliggende COMPONENT-PART-ITEMS tm een LEVEL te SELECTEREN !
--LET OP: De COMPONENT-MATERIALS worden NIET geselecteerd !!!
--EN het gewicht zelf wordt NIET berekend, Alleen de info wordt opgehaald.
--
--LET OP: WERKT NU EIGENLIJK ALLEEN NOG MAAR VOOR LEVEL=1 !!!!!!!!!!!!!!!!!
--
--SELECTIE ZIT HIERBIJ ALLEEN OP DE ONDERSTE BOM-ITEMS DIE ALS EEN COMPONENT BINNEN TYRE VOORKOMEN !!!
--
--LET OP: ALLE TUSSENLIGGENDE BOM-ITEM (RELATIES PART-NO/COMPONENT-PART) WORDEN HIERBIJ GEBRUIKT VOOR SELECTIE
--LET OP: Het komt voor dat er wel een BOM-ITEM-RELATIE bestaat tussen part-no + component-part maar dat
--        de component-part ondertussen al wel een HISTORIC-status heeft gekregen. 
--        In dit geval moet COMPONENT-PART wel in gewichtsberekening worden meegenomen, alhoewel de band/component-part
--        niet meer geproduceerd kan worden. De band zelf kan dan nog CURRENT-status hebben, maar gerelateerde component-part niet.
--
--Parameters:  P_HEADER_PART_NO = bom-item-header, bijv.  EF_Y245/35R20QPRX (prod)
--                                                        EF_W245/40R18WPRX (test-FOUTIEVE CURSOR)
--                                                        EF_710/40R22FLT162 (test)
--                         LET OP: Er komen XG-tyres uit hongarije voor met lowercase-characters in de naamgeving van PARTNO.
--                                 Om deze reden geen UPPER-gebruiken !!!
--
--             P_HEADER_REVISION = Indien NULL/GEEN REVISION meegegeven, dan wordt MAX-REVISION eerst opgehaald bij P_HEADER_PART-NO.
--                                 Dit is bom-item-header-revision-number van CURRENT/HISTORIC header.
--                                 Indien een TYRE zal status altijd CURRENT zijn. 
--                                 Een component kan zelf al HISTORIC zijn maar zolang hij in BOM-ITEM zit moet hij wel worden meegenomen.
--                                 Ook de COMPONENT-BOM-HEADER kan zelfs al HISTORIC zijn...Dan alsnog meenemen in de berekening !!!
--
--             P_HEADER_ALTERNATIVE = Indien NULL/GEEN-ALTERNATIVE meegegeven dan wordt PREFERRED-ALTERNATIVE eerst opgehaald bij P_HEADER_PART_NO.
--                                    Dit is bom-item-header-alternative van CURRENT/HISTORIC-header met PREFERRED=1.
--                                    Een ALTERNATIVE waarbij PREFERRED=0, doet niet mee in TYRE-WEIGHT-berekening, maar moet 
--                                    wel worden berekend voor SAP-WEIGHT.
--
--dependencies: FUNCTIE DBA_BEPAAL_QUANTITY_KG: functie om de quantity-string te vermenigvuldiger met PART-NO-BASE-QUANTITY 
--                                              om uiteindelijk het gewicht van BOM-HEADER obv MATERIALS-gewichten te berekenen.
--
--********************************************************************************************************************************
--REVISION DATE        WHO  DESCRIPTION
--      1  03-10-2022  PS   initial 
--********************************************************************************************************************************
--
pl_header_part_no            varchar2(100)   := p_header_part_no;
pl_header_revision           number          := p_header_revision;
pl_header_alternative        number          := p_header_alternative;
pl_level                     number          := p_level;
pl_header_preferred          number;         --preferred-ind bij header/alternative
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
l_item_number               number;
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
l_weight_factor_up          number;           --DIT IS WEIGHT-FACTOR FOR PART-NO TO BRING WEIGHT ONE LEVEL UP TO ITS OWN HEADER
l_bom_quantity_kg           varchar2(100);    --DIT IS MATERIAAL-GEWICHT OPGEWERKT NAAR HEADER, 
                                              --BIJ NORMALE COPONENT-PARTS IS DIT DE WEIGHT-FACTOR OM DEZE TOP-DOWN DOOR TE GEVEN OM 
                                              --UITEINDELIJK HET GEWICHT VAN MATERIALEN BINNEN HEADER TE KUNNEN BEREKENEN
--
c_bom                           sys_refcursor;
l_header_mainpart               varchar2(100);
l_header_gewicht                varchar2(100);
l_header_bom_gewicht_som_items  varchar2(100);
--bepaal-header-gewicht
--l_afronden                      number;   --afronden gewichten op 5 cijfers achter de komma.
l_partno_gewicht                number;
l_header_partno_gewicht_up      number;  --het partno-gewicht via BOTTOM-UP terug-herleid naar TYRE/HEADER-gewicht obv COMPONENT (gewicht via bepaal-header-gewicht/materialen berekend)
l_header_partno_gewicht         number;  --het partno-gewicht vanaf TYRE/HEADER berekend tot aan COMPONENT
l_tyre_gewicht                  number;  --CUMULATIEF TYRE/HEADER-gewicht van alle opgehaalde component-partno
--
BEGIN
  dbms_output.enable(1000000);
  --init
  if pl_header_revision is null
  then
    --indien er geen revision is meegegeven dan alsnog eerst zelf ophalen
  --PS: haal max(spec-revision) op waarvoor nog een bom-header-revision voor bestaat...
    begin
      select max(sh1.revision) 
    into pl_header_revision
    from status               s1
    ,    specification_header sh1 
    ,    bom_header           bh
    where bh.part_no   = pl_header_part_no 
    and   sh1.part_no  = bh.part_no 
    AND   sh1.revision = bh.revision
    and   sh1.status   = s1.status 
    and   s1.status_type in ('CURRENT','HISTORIC')
    ;
  exception
    when others 
    then NULL;
     -- dbms_output.put_line('REVISION-EXCP: Revision kon niet bepaald worden voor partno: '||pl_header_part_no||' rev: '||pl_header_revision);
    end;
  end if;
  if pl_header_alternative is null
  then
    --indien er geen alternative is meegegeven dan alsnog eerst zelf ophalen
    --PS: haal ALTERNATIVE op bij REVISION waarbij PREFERRED=1 
    begin
      select bh.alternative
      ,      bh.preferred
      into pl_header_alternative
      ,    pl_header_preferred
      from bom_header           bh
      where bh.part_no   = pl_header_part_no 
      and   bh.revision  = pl_header_revision 
      and   bh.preferred = 1
      ;
    exception
      when others 
      then NULL;
        --dbms_output.put_line('ALTERNATIVE-EXCP: ALTERNATIVE kon niet bepaald worden voor partno: '||pl_header_part_no||' rev: '||pl_header_revision);
      end;
    else
      --indien er WEL alternative is meegegeven dan alsnog de PREFERRED-IND ERBIJ ophalen
      --PS: haal preferred op bij ALTERNATIVE op bij header-REVISION  
      begin
        select bh.preferred
        into pl_header_preferred
        from bom_header           bh
        where bh.part_no     = pl_header_part_no 
        and   bh.revision    = pl_header_revision 
        and   bh.alternative = pl_header_alternative
        ;
      exception
        when others 
        then dbms_output.put_line('PREFERRED-EXCP: PREFERRED kon niet bepaald worden voor partno: '||pl_header_part_no||' rev: '||pl_header_revision||' alt: '||pl_header_alternative);
      end;
      --
    end if;
    --
    if pl_level is null
    then
      pl_level := 2;
    end if;
    --    
    dbms_output.put_line('**********************************************************************************************************************');
    dbms_output.put_line('SELECT-TYRE-LEVEL-PART_WEIGHT MAINPART: '||pl_header_part_no ||' revision: '||pl_header_revision||' alternative: '||pl_header_alternative ||' LEVEL='||pl_level);
    dbms_output.put_line('**********************************************************************************************************************');
    --Indien parameter =SHOW-ITEMS=ja
    BEGIN
      --dbms_output.put_line('L_LVL'||';'||'l_mainpart'||';'||'l_mainrevision'||';'||'l_mainplant'||';'||'l_mainalternative'||';'||'l_mainbasequantity'||';'||'l_mainsumitemsquantity'||';'||'l_mainstatus'||';'||'l_mainframeid'||';'||'l_mainpartdescription'||';'||'l_mainpartbaseuom'||
      --                  ';'||'l_part_no'||';'||'l_revision'||';'||'l_alternative'||';'||'l_item_header_base_quantity'||';'||'l_component_part'||';'||'l_componentdescription'||';'||'l_quantity'||';'||'l_uom'||
      --        ';'||'l_quantity_kg'||';'||'l_path'||';'||'l_quantity_path'||';'||'l_bom_quantity_kg'||';'||'l_status'||';'||'l_characteristic_id'||';'||'l_functiecode' );      
      dbms_output.put_line('l_mainpart'||'   MBQ: '||' LVL:'||' L_LEVEL_TREE'||' Part_no:'||'l_revision'||' l_alternative'||' BHQ:'||' CompPart:'||  --'(= l_componentdescription) CQ:'||
                           ' Q-path:'||'='||'l_bom_quantity_kg'||' CWFup(CQ/BHQ)='||'l_weight_factor_up'||' COMP-BEPAAL-HEADER-Q-BOTTOM-UP='||'l_partno_gewicht'||' * TYRE-COMP-PARTH-Q-TOP-DOWN='||'l_header_partno_gewicht'||' = TYRE-COMP-GEN-HEADER-Q:'||'l_header_partno_gewicht_up');  
      --init
      l_tyre_gewicht := 0;              
      --Tonen van totale-gewicht van BOM-HEADER:
      open c_bom_items for 
        SELECT bi2.LVL
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
        ,      bi2.item_number
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
        ,      bi2.weight_factor_up
        ,      DBA_BEPAAL_QUANTITY_KG(bi2.quantity_path)  bom_quantity_kg
        from
        (
        with sel_bom_header as 
        (select bh.part_no
         ,      bh.revision
         ,      bh.plant
         ,      bh.alternative
         ,      bh.preferred
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
                 --and    bh.preferred = 1         
         and    bh.alternative = pl_header_alternative  --default alternative bij preferred=1, maar kan ook expliciet preferred=0
         and    rownum = 1
        ) 
        select LEVEL   LVL
        ,      RPAD('.', (level-1)*2, '.') || LEVEL AS level_tree
        ,      bh.part_no             mainpart
        ,      bh.revision            mainrevision
        ,      bh.plant               mainplant
        ,      bh.alternative         mainalternative
        ,      bh.base_quantity       mainbasequantity
        ,      bh.min_qty             mainminqty
        ,      bh.max_qty             mainmaxqty
        ,      bh.sum_items_quantity  mainsumitemsquantity
        ,      bh.sort_desc           mainstatus
        ,      bh.frame_id            mainframeid
        ,      bh.description         mainpartdescription
        ,      bh.base_uom            mainpartbaseuom
        ,      b.part_no
        ,      b.revision
        ,      b.plant
        ,      b.alternative
        ,      b.item_number
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
        ,      (b.quantity_kg / b.item_header_base_quantity)                                         weight_factor_up
        FROM   ( SELECT bi.part_no
                 ,      bi.revision
                 ,      bi.plant
                 ,      bi.alternative
                 ,      bi.item_number
                 ,      bi.component_part
                 --,      (select bh.base_quantity from bom_header bh where bh.part_no = bi.part_no and bh.revision = bi.revision and bh.alternative= bi.alternative )   item_header_base_quantity
                 ,      h.base_quantity   item_header_base_quantity
                 ,      bi.quantity
                 ,      case 
                        when bi.uom in ('pcs','m','m²')
                        then (--indien een material met uom=pcs dan weight uit property halen, en uom aanpassen naar "kg"
                              SELECT 'kg'
                              FROM specification_prop sp
                              WHERE sp.part_no        = bi.component_part   --'GR_9787'
                               AND NOT exists (select '' from bom_item bi3 where bi3.part_no = bi.component_part )
                              --PS: gebruik component-item/header-spec-header-revision
                              --PS: gebruik component-item/spec-header-revision, MATERIALS hebben alleen SPECIFICATION-header, geen bom-header !!!
                              AND   sp.revision       = (select max(sh1.revision) 
                                                         from status s1, specification_header sh1
                                                         where   sh1.part_no    = sp.part_no             --is component-part-no
                                                         and     sh1.status     = s1.status 
                                                         and     s1.status_type in ('CURRENT','HISTORIC')
                                                        )
                              AND   sp.section_id     = 700755 --  SAP information
                              --AND   sp.sub_section_id = 701502 -- A         --alle SAP-WEIGHT-properties meenemen in berekening
                              AND   sp.property_group = 0 -- (none)
                              AND   sp.property       = 703262 -- Weight
                              and   rownum = 1
                              UNION
                              --indien component-part met uom=pcs dan aantal meenemen in de berekening
                              select bi.uom   --'pcs-m' 
                              from dual
                              where exists (select '' from bom_item bi3 where bi3.part_no = bi.component_part )   --revision = header-revision, geen comp-revision, dus kunnen hier niet expliciet op checken...
                              )
                        else bi.uom 
                        end  uom
                 --,      bi.uom
                 ,      case 
                        when bi.uom = 'g' 
                        then (bi.quantity/1000) 
                        when bi.uom = 'kg'
                        then bi.quantity
                        when bi.uom in ('pcs','m','m²')
                        then (--indien een material met uom=pcs dan weight uit property halen
                              SELECT (sp.num_1 * bi.quantity)
                              FROM specification_prop sp
                              WHERE sp.part_no        = bi.component_part   --'GR_9787'
                              AND NOT exists (select '' from bom_item bi3 where bi3.part_no = bi.component_part )
                              --PS: gebruik component-item/spec-header-revision, MATERIALS hebben alleen SPECIFICATION-header, geen bom-header !!!
                              AND   sp.revision       = (select max(sh1.revision) 
                                                         from status s1, specification_header sh1
                                                         where   sh1.part_no    = sp.part_no        --is component-part-no
                                                         and     sh1.status     = s1.status 
                                                         and     s1.status_type in ('CURRENT','HISTORIC')
                                                        )
                              AND   sp.section_id     = 700755 --  SAP information
                              --AND   sp.sub_section_id = 701502 -- A    --alle SAP-WEIGHT-properties meenemen in berekening
                              AND   sp.property_group = 0 -- (none)
                              AND   sp.property       = 703262 -- Weight
                              AND   rownum = 1
                              UNION
                              --indien component-part met uom=pcs/m/m2 dan aantal meenemen in de berekening
                              select bi.quantity 
                              from dual
                              where exists (select '' from bom_item bi3 where bi3.part_no = bi.component_part )   --revision = header-revision, geen comp-revision, dus kunnen hier niet expliciet op checken...
                              )
                        else bi.quantity 
                        end   quantity_kg
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
                 --zoek hoogste specification-revision waar nog een bom-header bij voorkomt
                 and   h.revision   =  (select max(sh1.revision) 
						                            from status s1, specification_header sh1, bom_header h2 
								                        where   h2.part_no  = h.part_no 
                                        and    sh1.part_no  = h2.part_no 
                                        AND    sh1.revision = h2.revision 
                                        and    sh1.status   = s1.status 
                                        and    s1.status_type in ('CURRENT','HISTORIC')
                                       )
      					 --and   h.preferred    = 1
			           and   h.preferred    = decode(h.part_no, pl_header_part_no, pl_header_preferred, 1)     --indien 1e Keer dan uitgaan van meegegeven alternative, verder weer uitgaan met preferred.
						     and   h.alternative  = decode(h.part_no, pl_header_part_no, pl_header_alternative, h.alternative)
						     and   h.alternative  = bi.alternative
				         and   h.part_no      = sh.part_no
                 and   h.revision     = sh.revision
  					     and   sh.status      = s.status	
     						 --and   s.status_type  = 'CURRENT' 
				         and   bi.ch_1        = c.characteristic_id(+)
					   ) b
				,      sel_bom_header bh	   
				START WITH b.part_no = bh.part_no 
				CONNECT BY NOCYCLE PRIOR b.component_part = b.part_no --and b.component_revision = b.revision
				order siblings by b.part_no
				)  bi2
				--select alleen gewicht van materialen...
        --PS: ALLEEN EVEN UITGEZET OM OVERZICHT TE KRIJGEN...
				where bi2.LVL <= PL_LEVEL
        --and  bi2.component_part IN (select bi3.part_no from bom_item bi3 where bi3.part_no = bi2.component_part)
        ;
      loop
        --
        --fetch c_bom_items into l_header_mainpart, l_mainbasequantity, l_LVL, l_part_no, l_revision, l_item_header_base_quantity, l_component_part, l_quantity_kg ; --, l_header_gewicht, l_header_bom_gewicht_som_items;
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
                          ,l_item_number
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
                          ,l_weight_factor_up  
                          ,l_bom_quantity_kg    --TOTAAL gewicht-materiaal opgewerkt naar header
						  ;
        --
        if (c_bom_items%notfound)   
        then CLOSE C_BOM_ITEMS;
	         exit;
        end if;
        --
        --Bepaal HEADER-GEWICHT
        begin
          l_partno_gewicht := dba_fnc_bepaal_header_gewicht (p_header_part_no=>l_component_part
                                                            ,p_header_revision=>null     
                                                            ,p_header_alternative=>null
                                                            ,p_show_incl_items_jn=>'N' ); 
          if nvl(l_partno_gewicht,0) > 0
          then                                  
            --vul partno-gewicht met GEWICHT bepaald voor de COMPONENT zelf obv optelling MATERIALEN !!!                           
            l_partno_gewicht            := round(l_partno_gewicht, gc_afrond); 
            l_header_partno_gewicht_up  := l_partno_gewicht * (l_bom_quantity_kg);    --BOTTOM-UP materiaal-kg * quantity-kg tot aan tyre vanaf de component
            l_header_partno_gewicht     := round(  l_bom_quantity_kg , gc_afrond) ;   --TOP-DOWN quantity-kg vanaf tyre t/m component                                                       
            --l_tyre_gewicht              := l_tyre_gewicht + l_header_partno_gewicht ;                                                            
          else
            --vul partno-gewicht met BOM-ITEM-Quantity (material in kg) niet gecorrigeerd met factor...
            --COMPONENT-PART = MATERIAL, heeft zelf geen items, waardoor FUNCTIE geen partno-gewicht kan bepalen.
            l_partno_gewicht           := l_quantity_kg;
            l_header_partno_gewicht_up := null; 
            l_header_partno_gewicht    := round( l_bom_quantity_kg , gc_afrond) ;                                                          
            --l_tyre_gewicht             := l_tyre_gewicht + l_header_partno_gewicht ;
          end if;
        exception 
          when others
          then --vul partno-gewicht met BOM-ITEM-Quantity (material in kg) 
               l_partno_gewicht := l_quantity_kg;
               l_header_partno_gewicht :=  round( l_bom_quantity_kg , gc_afrond) ;                                                          
               --l_tyre_gewicht := l_tyre_gewicht + l_header_partno_gewicht ;                                                            
        end;    
        --
        l_weight_factor_up := round(l_weight_factor_up, gc_afrond);
        l_bom_quantity_kg  := round(l_bom_quantity_kg, gc_afrond);
        --Betekenis:
        --CQ = Component Quantity uit BOM-ITEM
        --BHQ = Base Quantity from PART-NO uit BOM_HEADER
        --BOM-Q = Gewicht van COMPONENT binnen PART-NO zoals geconfigureerd, wordt alleen gebruikt voor FACTOR-berekening.
        --Q-path = 1: Een string met de cumulatieve TOP-DOWN van alle item-factoren (BHQ/BOM-Q) tot/met COMPONENT.
        --         2: Eindresultaat van Q-PATH-1 string-berekening (=met welk gewicht een component/material in TYRE/HEADER voorkomt)
        --CWFup = WEIGHT-FACTOR to bring BOM-Q van een COMPONENT 1 LEVEL omhoog naar HEADER van PART-NO (BOTTOM-UP).
        --TYRE-Q: 1= l_partno_gewicht        = COMPONENT-HEADER-GEWICHT van alle materials bij deze COMPONENT via DBA_FNC_BEPAAL_HEADER_GEWICHT
        --        2= l_header_partno_gewicht = COMPONENT-HEADER-GEWICHT opgewerkt met WEIGHT-UP-FACTOR naar bovenliggende PART-NO/HEADER
        --        3= l_tyre_gewicht          = CUMULATIEF-gewicht van alle 
        dbms_output.put_line(l_mainpart||' MBQ:'||l_mainbasequantity||' LVL:'||l_lvl||' '||L_LEVEL_TREE||' Part_no:'||l_part_no||':'||l_revision||':'||l_alternative||' BHQ:'||l_item_header_base_quantity||
                            ' CompPart:'||l_component_part|| --' (= '||l_componentdescription||') ' ||
                            ' CQ:'||l_quantity_kg ||' UOM: '||l_uom||
                            --' Path:'||l_path ||
                            ' Q-path:'||l_quantity_path||'='||l_bom_quantity_kg||
                            ' CWFup(CQ/BHQ):'||l_weight_factor_up||' COMP-GEN-HEADER-Q:'||l_partno_gewicht||' * TYRE-COMP-PATH-Q:'||l_header_partno_gewicht||' = TYRE-COMP-GEN-HEADER-Q:'||l_header_partno_gewicht_up);  
        --exit;	  
      end loop;   
      close c_bom_items;  
      --   
      dbms_output.put_line('totaalgewicht Mainpart '||l_mainpart||' = '||l_tyre_gewicht);
	  --
	EXCEPTION
	  WHEN OTHERS 
	  THEN if sqlerrm not like '%ORA-01001%' 
           THEN dbms_output.put_line('SELECT-TYRE-LEVEL-PART-WEIGHT: ALG-EXCP BOM-ITEMS: '||SQLERRM); 
           else null;   
           end if;
	END;
	--
end SELECT_TYRE_LEVEL_PART_WEIGHT;   
--
procedure DBA_SELECT_PART_ITEM (p_header_part_no      varchar2 default null
                               ,p_header_revision     number   default null
                               ,p_alternative         number   default null )
DETERMINISTIC
AS
--AD-HOC procedure voor uitvragen van GEWICHT van ALLEEN de BOM-ITEMS direct ONDER een BOM-HEADER !!
--LET OP: DUS NIET DE VOLLEDIGE BOM-TREE !!!
--
--Script om per bom-header/component het gewicht te berekenen van direct afhankelijke bom-items (materialen/componenten). 
--SELECTIE ZIT HIERBIJ  OP ALLE BOM-ITEMS (=INCLUSIEF MATERIALEN/GRONDSTOFFEN) 
--WAARBIJ PER BOM-HEADER OOK RELATIES MET COMPONENT-PARTS WORDEN OPGEHAALD.
--LET OP: OOK ALLE TUSSENLIGGENDE BOM-ITEM (RELATIES PART-NO/COMPONENT-PART) WORDEN HIERBIJ GESELECTEERD !!!
--
--Parameters:  P_PART_NO = bom-item-header, bijv.  EF_H215/65R15QT5  ("CRRNT QR5", A_PCR)
--                                                 EF_Q165/80R15SCS  ("CRRNT QR5", A_PCR)
--                           EF_S640/95R13CLS  ("CRRNT QR5", A_PCR)
--             P_ALTERNATIVE = indicator die aangeeft om welk alternatief het gaat. 
--                             1=default, per eenheid
--                             2=batch, voor bulk
--
pl_header_part_no           varchar2(100)   := p_header_part_no;
pl_header_revision          number(2)       := p_header_revision;
pl_alternative              number(2)       := p_alternative;
--
c_bom_items                sys_refcursor;
--l_LVL                      varchar2(100);  
--l_level_tree               varchar2(4000);
l_mainpart                 varchar2(100);
l_mainrevision             number;
l_mainplant                varchar2(100);
l_mainalternative          number;
l_mainbasequantity         number;
l_mainminqty               number;
l_mainmaxqty               number;
l_mainsumitemsquantity     number;
l_mainstatus               varchar2(100);
l_mainframeid              varchar2(100);
l_mainpartdescription      varchar2(1000);
l_mainpartbaseuom          varchar2(100);
--
l_part_no                  varchar2(100);
l_revision                 NUMBER;
l_plant                    varchar2(100);
l_alternative              number(2);
l_characteristic_id        number;
l_item_header_base_quantity number;
l_item_number               number;
l_component_part           varchar2(100);
l_quantity                 number;
l_uom                      varchar2(100);
l_quantity_kg              number;
l_status                   varchar2(30);
l_functiecode              varchar2(1000);
l_componentdescription     varchar2(1000);
l_path                     varchar2(4000);
l_quantity_path            varchar2(4000);
l_excl_quantity_kg         varchar2(100);
--
c_bom                      sys_refcursor;
l_header_mainpart          varchar2(100);
l_header_gewicht           varchar2(100);
l_header_gewicht_som_items varchar2(100);
--
BEGIN
  dbms_output.enable(1000000);
  if pl_header_revision is null
  then
	  --indien er geen revision is meegegeven dan alsnog eerst zelf ophalen
	  --PS: haal max(spec-revision) op waarvoor nog een bom-header-revision bestaat...
    begin
      select max(sh1.revision) 
	    into pl_header_revision
	    from status               s1
	    ,    specification_header sh1 
	    ,    bom_header           bh
	    where bh.part_no   = pl_header_part_no 
	    and   sh1.part_no  = bh.part_no 
	    and   sh1.revision = bh.revision
	    and   sh1.status   = s1.status 
	    and   s1.status_type in ('CURRENT','HISTORIC')
	    ;
	  exception
	    when others 
	    then dbms_output.put_line('REVISION-EXCP: Revision kon niet bepaald worden voor partno: '||pl_header_part_no);
    end;
  end if;
  dbms_output.put_line('**************************************************************************************************************');
  dbms_output.put_line('MAINPART: '||pl_header_part_no ||' REV: '||pl_header_revision );
  dbms_output.put_line('**************************************************************************************************************');
  BEGIN
      dbms_output.put_line('l_level'||';'||'l_mainpart'||';'||'l_mainrevision'||';'||'l_mainplant'||';'||'l_mainalternative'||';'||'l_mainbasequantity'||';'||'l_mainsumitemsquantity'||';'||'l_mainstatus'||';'||'l_mainframeid'||';'||'l_mainpartdescription'||';'||'l_mainpartbaseuom'||
		                    ';'||'l_part_no'||';'||'l_revision'||';'||'l_alternative'||';'||'l_item_header_base_quantity'||';'||'l_item_number'||';'||'l_component_part'||';'||'l_componentdescription'||';'||'l_quantity'||';'||'l_uom'||
							';'||'l_quantity_kg'||';'||'l_status'||';'||'l_characteristic_id'||';'||'l_functiecode' );      
     --Tonen van base/eenheid-gewicht van BOM-HEADER/component:
      open c_bom_items for SELECT 
               bi2.mainpart
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
        ,      bi2.item_number
        ,      bi2.component_part
        ,      bi2.componentdescription
        ,      bi2.item_header_base_quantity
        ,      bi2.quantity
        ,      bi2.uom
        ,      bi2.quantity_kg
        ,      bi2.status
        ,      bi2.characteristic_id 
        ,      bi2.functiecode
				--,      bi2.path
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
                 from bom_item b 
                 where b.part_no = bh.part_no 
                 and b.revision = bh.revision 
                 and b.alternative = bh.alternative) sum_items_quantity
         ,      s.sort_desc
         ,      sh.frame_id
         ,      p.description
         ,      p.base_uom      
         from status               s  
         ,    part                 p
         ,    specification_header sh
         ,    bom_header           bh 
				 where  bh.part_no    = pl_header_part_no  --'EM_764' --'EG_H620/50R22-154G'  --l_header_part_no
         and    bh.revision   = pl_header_revision        
				 and    bh.part_no    = sh.part_no
         and    bh.revision   = sh.revision
         and    sh.status     = s.status				 
				 and    bh.part_no    = p.part_no
				 and    bh.preferred  = 1
				 and    s.status_type in ('CURRENT','HISTORIC')
				 --we selecteren alle alternatieven om gewicht op te halen. Indien parameter=NULL dan alle alternative-voorkomens
				 --VOOR TEST-DOELEINDEN:				 --and    bh.alternative = decode(null,null,bh.alternative,null)
				 --DEFINITIEVE-VERSIE:
				 and    bh.alternative = decode(pl_alternative,null,bh.alternative,pl_alternative)
				 --alleen max-revision, wordt AUTOMATISCH al geregeld door conditie BH.REVISION = PL-HEADER-REVISION 
         --Er komen nl. PART-NO voor waarbij SPECIFICATION-HEADER.revision > BOM-HEADER.REVISION...
				 --and    bh.revision = (select max(sh1.revision) from status s1, specification_header sh1 where sh1.part_no = bh.part_no and sh1.status = s1.status and s1.status_type in ('CURRENT','HISTORIC'))
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
				,      h.description         mainpartdescription
				,      h.base_uom            mainpartbaseuom
				,      b.part_no
				,      b.revision
				,      b.plant
				,      b.alternative
        ,      b.item_number
				,      b.component_part
				,      (select pi.description from part pi where pi.part_no = b.component_part)  componentdescription
				,      (select bhi.base_quantity from bom_header bhi where bhi.part_no = b.part_no and bhi.revision = b.revision and bhi.alternative=b.alternative) item_header_base_quantity
				,      b.quantity
				,      b.uom
				,      case when b.uom = 'g' 
							      then (b.quantity/1000) 
									  when b.uom = 'kg'
									  then b.quantity
				            else 0 
               end   quantity_kg 
				,      s.sort_desc     status
				,      b.ch_1          characteristic_id       --FUNCTIECODE
				,      c.description   functiecode
 				--,      sys_connect_by_path( b.part_no||decode(b.ch_1,null,'','-'||b.ch_1) || ',' || b.component_part ,'|')  path
				FROM status               s
				,    specification_header sh
				,    characteristic       c
				,    bom_item             b
				,    sel_bom_header       h	   
				--select alleen gewicht van materialen...
				where b.part_no     = h.part_no
				AND   b.revision    = h.revision
				--and   h.preferred   = 1
				and   b.alternative = h.alternative
				and   h.part_no     = sh.part_no
        and   h.revision    = sh.revision
				and   sh.status     = s.status	
				and   s.status_type in ('CURRENT','HISTORIC')
				and   b.ch_1        = c.characteristic_id(+)
				) bi2
				--select op alle BOM-ITEMS, NIET alleen de gewichten...
				--where bi2.component_part NOT IN (select bi3.part_no from bom_item bi3 where bi3.part_no = bi2.component_part)
				;
      loop 
        fetch c_bom_items into l_mainpart  
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
                              ,l_item_number
                              ,l_component_part      
                              ,l_componentdescription						  
                              ,l_item_header_base_quantity
                              ,l_quantity            
                              ,l_uom   
                              --,l_path              
                              ,l_quantity_kg     
                						  ,l_status
                 						  ,l_characteristic_id
                              ,l_functiecode
               						    ;
        if (c_bom_items%notfound)   
        then CLOSE C_BOM_ITEMS;
	         exit;
  	    end if;
        dbms_output.put_line('HEADER: '||l_mainpart||';'||l_mainrevision||';'||l_mainplant||';'||l_mainalternative||';'||l_mainbasequantity||';'||l_mainsumitemsquantity||';'||l_mainstatus||';'||l_mainframeid||';'||l_mainpartdescription||';'||l_mainpartbaseuom||
                            ';'||l_part_no||';'||l_revision||';'||l_alternative||';'||l_item_header_base_quantity||';'||l_item_number||';'||l_component_part||';'||l_componentdescription||';'||l_quantity||';'||l_uom||
					        ';'||l_quantity_kg ||';'||l_status||';'||l_characteristic_id||';'||l_functiecode||'#' );
        --exit;	  
      end loop;
      close c_bom_items;  
	    --
	EXCEPTION
	  WHEN OTHERS 
	  THEN if sqlerrm not like '%ORA-01001%' 
         THEN dbms_output.put_line('ALG-EXCP BOM-ITEMS: '||SQLERRM); 
         else null;   
         end if;
	END;
  --
  dbms_output.put_line('**************************************************************************************************************');
  dbms_output.put_line('EINDE BEREKEN TOTAALGEWICHT VAN HEADER: '||pl_header_part_no );
  dbms_output.put_line('**************************************************************************************************************');
  --
END DBA_SELECT_PART_ITEM;
--
procedure DBA_SELECT_PART_MATERIALS (p_header_part_no      varchar2 default null
                                    ,p_header_revision     number   default null
                                    ,p_alternative         number   default null )
DETERMINISTIC
AS
--AD-HOC procedure voor uitvragen van GEWICHT van ALLEEN de MATERIAL-COMPONENT-PARTS die direct ONDER een BOM-HEADER voorkomen!!
--LET OP: DUS NIET DE MATERIALEN UIT DE VOLLEDIGE BOM-TREE !!!
--
--SELECTIE ZIT HIERBIJ  OP ALLE BOM-ITEMS  VAN TYPE MATERIALEN/GRONDSTOFFEN
--WAARBIJ PER BOM-HEADER ALLEEN DIRECT GERELATEERDE COMPONENT-PARTS WORDEN OPGEHAALD.
--
--Parameters:  P_PART_NO = bom-item-header, bijv.  EF_H215/65R15QT5  ("CRRNT QR5", A_PCR)
--                                                 EF_Q165/80R15SCS  ("CRRNT QR5", A_PCR)
--                           EF_S640/95R13CLS  ("CRRNT QR5", A_PCR)
--             P_HEADER_REVISION = bom-item-header-revision. Indien geen revision wordt uitgegaan van 
--                                 max(bom_header.revision)
--             P_ALTERNATIVE = indicator die aangeeft om welk alternatief het gaat. 
--                             1=default, per eenheid
--                             2=batch, voor bulk
--
pl_header_part_no           varchar2(100)   := p_header_part_no;
pl_header_revision          number(2)       := p_header_revision;
pl_alternative              number(2)       := p_alternative;
--
c_bom_items                sys_refcursor;
--l_LVL                      varchar2(100);  
--l_level_tree               varchar2(4000);
l_mainpart                 varchar2(100);
l_mainrevision             number;
l_mainplant                varchar2(100);
l_mainalternative          number;
l_mainbasequantity         number;
l_mainminqty               number;
l_mainmaxqty               number;
l_mainsumitemsquantity     number;
l_mainstatus               varchar2(100);
l_mainframeid              varchar2(100);
l_mainpartdescription      varchar2(1000);
l_mainpartbaseuom          varchar2(100);
--
l_part_no                  varchar2(100);
l_revision                 NUMBER;
l_plant                    varchar2(100);
l_alternative              number(2);
l_characteristic_id        number;
l_item_header_base_quantity number;
l_item_number               number;
l_component_part           varchar2(100);
l_quantity                 number;
l_uom                      varchar2(100);
l_quantity_kg              number;
l_status                   varchar2(30);
l_functiecode              varchar2(1000);
l_componentdescription     varchar2(1000);
l_path                     varchar2(4000);
l_quantity_path            varchar2(4000);
l_excl_quantity_kg         varchar2(100);
--
c_bom                      sys_refcursor;
l_header_mainpart          varchar2(100);
l_header_gewicht           varchar2(100);
l_header_gewicht_som_items varchar2(100);
--
BEGIN
  dbms_output.enable(1000000);
  if pl_header_revision is null
  then
	  --indien er geen revision is meegegeven dan alsnog eerst zelf ophalen
	  --PS: haal max(bom-header-revision) op (hoeft niet overeen te komen met max(spec-revision) !!!)
    begin
      select max(sh1.revision) 
	    into pl_header_revision
	    from status               s1
	    ,    specification_header sh1 
	    ,    bom_header           bh
	    where bh.part_no   = pl_header_part_no 
	    and   sh1.part_no  = bh.part_no 
	    and   sh1.revision = bh.revision
	    and   sh1.status   = s1.status 
	    and   s1.status_type in ('CURRENT','HISTORIC')
	    ;
	  exception
	    when others 
	    then dbms_output.put_line('REVISION-EXCP: Revision kon niet bepaald worden voor partno: '||pl_header_part_no);
    end;
  end if;
  --dbms_output.put_line('**************************************************************************************************************');
  --dbms_output.put_line('MAINPART: '||pl_header_part_no ||' REV: '||pl_header_revision );
  --dbms_output.put_line('**************************************************************************************************************');
  BEGIN
      --dbms_output.put_line('l_level'||';'||'l_mainpart'||';'||'l_mainrevision'||';'||'l_mainplant'||';'||'l_mainalternative'||';'||'l_mainbasequantity'||';'||'l_mainsumitemsquantity'||';'||'l_mainstatus'||';'||'l_mainframeid'||';'||'l_mainpartdescription'||';'||'l_mainpartbaseuom'||
		  --                  ';'||'l_part_no'||';'||'l_revision'||';'||'l_alternative'||';'||'l_item_header_base_quantity'||';'||'l_item_number'||';'||'l_component_part'||';'||'l_componentdescription'||';'||'l_quantity'||';'||'l_uom'||
		  --					';'||'l_quantity_kg'||';'||'l_status'||';'||'l_characteristic_id'||';'||'l_functiecode' );      
     --Tonen van base/eenheid-gewicht van BOM-HEADER/component:
      open c_bom_items for SELECT 
               bi2.mainpart
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
        ,      bi2.item_number
        ,      bi2.component_part
        ,      bi2.componentdescription
        ,      bi2.item_header_base_quantity
        ,      bi2.quantity
        ,      bi2.uom
        ,      bi2.quantity_kg
        ,      bi2.status
        ,      bi2.characteristic_id 
        ,      bi2.functiecode
				--,      bi2.path
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
                 from bom_item b 
                 where b.part_no = bh.part_no 
                 and b.revision = bh.revision 
                 and b.alternative = bh.alternative) sum_items_quantity
         ,      s.sort_desc
         ,      sh.frame_id
         ,      p.description
         ,      p.base_uom      
         from status               s  
         ,    part                 p
         ,    specification_header sh
         ,    bom_header           bh 
				 where  bh.part_no    = pl_header_part_no  --'EM_764' --'EG_H620/50R22-154G'  --l_header_part_no
         and    bh.revision   = pl_header_revision        
				 and    bh.part_no    = sh.part_no
         and    bh.revision   = sh.revision
         and    sh.status     = s.status				 
				 and    bh.part_no    = p.part_no
				 and    bh.preferred  = 1
				 and    s.status_type in ('CURRENT','HISTORIC')
				 --we selecteren alle alternatieven om gewicht op te halen. Indien parameter=NULL dan alle alternative-voorkomens
				 --VOOR TEST-DOELEINDEN:				 --and    bh.alternative = decode(null,null,bh.alternative,null)
				 --DEFINITIEVE-VERSIE:
				 and    bh.alternative = decode(pl_alternative,null,bh.alternative,pl_alternative)
				 --alleen max-revision, wordt AUTOMATISCH al geregeld door conditie BH.REVISION = PL-HEADER-REVISION 
         --Er komen nl. PART-NO voor waarbij SPECIFICATION-HEADER.revision > BOM-HEADER.REVISION...
				 --and    bh.revision = (select max(sh1.revision) from status s1, specification_header sh1 where sh1.part_no = bh.part_no and sh1.status = s1.status and s1.status_type in ('CURRENT','HISTORIC'))
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
				,      h.description         mainpartdescription
				,      h.base_uom            mainpartbaseuom
				,      b.part_no
				,      b.revision
				,      b.plant
				,      b.alternative
        ,      b.item_number
				,      b.component_part
				,      (select pi.description from part pi where pi.part_no = b.component_part)  componentdescription
				,      (select bhi.base_quantity from bom_header bhi where bhi.part_no = b.part_no and bhi.revision = b.revision and bhi.alternative=b.alternative) item_header_base_quantity
				,      b.quantity
				,      b.uom
				,      case when b.uom = 'g' 
							      then (b.quantity/1000) 
									  when b.uom = 'kg'
									  then b.quantity
				            else 0 
               end   quantity_kg 
				,      s.sort_desc     status
				,      b.ch_1          characteristic_id       --FUNCTIECODE
				,      c.description   functiecode
 				--,      sys_connect_by_path( b.part_no||decode(b.ch_1,null,'','-'||b.ch_1) || ',' || b.component_part ,'|')  path
				FROM status               s
				,    specification_header sh
				,    characteristic       c
				,    bom_item             b
				,    sel_bom_header       h	   
				--select alleen gewicht van materialen...
				where b.part_no     = h.part_no
				AND   b.revision    = h.revision
				--and   h.preferred   = 1
				and   b.alternative = h.alternative
				and   b.part_no     = sh.part_no
        and   b.revision    = sh.revision
				and   sh.status     = s.status	
        and   b.component_part not in (select bi2.part_no from bom_item bi2 where bi2.part_no = b.component_part)
				and   s.status_type in ('CURRENT','HISTORIC')
				and   b.ch_1        = c.characteristic_id(+)
				) bi2
				--select op alle BOM-ITEMS, NIET alleen de gewichten...
				--where bi2.component_part NOT IN (select bi3.part_no from bom_item bi3 where bi3.part_no = bi2.component_part)
				;
      loop 
        fetch c_bom_items into l_mainpart  
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
                              ,l_item_number
                              ,l_component_part      
                              ,l_componentdescription						  
                              ,l_item_header_base_quantity
                              ,l_quantity            
                              ,l_uom   
                              --,l_path              
                              ,l_quantity_kg     
                						  ,l_status
                 						  ,l_characteristic_id
                              ,l_functiecode
               						    ;
        if (c_bom_items%notfound)   
        then CLOSE C_BOM_ITEMS;
	         exit;
  	    end if;
        dbms_output.put_line('MATERIAL: '||l_mainpart||';'||l_mainrevision||';'||l_mainplant||';'||l_mainalternative||';'||l_mainbasequantity||';'||l_mainsumitemsquantity||';'||l_mainstatus||';'||l_mainframeid||';'||l_mainpartdescription||';'||l_mainpartbaseuom||
                            ';'||l_part_no||';'||l_revision||';'||l_alternative||';'||l_item_header_base_quantity||';'||l_item_number||';'||l_component_part||';'||l_componentdescription||';'||l_quantity||';'||l_uom||
					        ';'||l_quantity_kg ||';'||l_status||';'||l_characteristic_id||';'||l_functiecode||'#' );
        --exit;	  
      end loop;
      close c_bom_items;  
	    --
	EXCEPTION
	  WHEN OTHERS 
	  THEN if sqlerrm not like '%ORA-01001%' 
         THEN dbms_output.put_line('ALG-EXCP BOM-ITEM-MATERIAL: '||SQLERRM); 
         else null;   
         end if;
	END;
  --
  --dbms_output.put_line('**************************************************************************************************************');
  --dbms_output.put_line('EINDE BEREKEN TOTAALGEWICHT VAN HEADER: '||pl_header_part_no );
  --dbms_output.put_line('**************************************************************************************************************');
  --
END DBA_SELECT_PART_MATERIALS;
--
PROCEDURE oud_select_part_related_tyre (p_component_part_no   IN  varchar2 default null) 
DETERMINISTIC
AS
--LET OP: NIET MEER GEBRUIKEN !! VERVANGEN DOOR PROCEDURE = SELECT_MV_PART_RELATED_TYRE 
--                               die gebruik maakt van de MV = MV_BOM_ITEM_COMP_HEADER
--
--Script om van een bom-ITEM/COMPONENT-PART de gerelateerde TYRES te bepalen die voldoen aan selectie-criteria
--en FRAME-IDs voor uitwisseling met SAP (VIA view: AV_BHR_BOM_TYRE_PART_NO !!!)
--
--
--Parameters:  P_COMPONENT_PART_NO = bom-item, bijv.  EM_764 (prod)
--
pl_component_part_no         varchar2(100)   := upper(p_component_part_no);
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
  dbms_output.put_line('**************************************************************************************************************');
  dbms_output.put_line('Component-PART: '||pl_component_part_no  );
  dbms_output.put_line('**************************************************************************************************************');
  BEGIN
        /*
        --dd. 13-03-2023: voor uitbreiding met PREFERRED + STATUS !!!!
        --
        SELECT DISTINCT bi2.part_no     mainpart
        ,      bi2.revision             mainrevision
        ,      bi2.plant                mainplant
        ,      bi2.alternative          mainalternative
        ,      BI2.STATUS               MAINSTATUS
        ,      bi2.frame_id
        ,      bi2.path
        --,      bi2.path_alternative
        from ( SELECT  bi.part_no
               ,      bi.revision     
               ,      bi.plant     
               ,      bi.alternative     
            	 ,      SH.STATUS
               ,      sh.frame_id	 
               ,      sys_connect_by_path( bi.component_part || ',' || bi.part_no ,'|')              path
               --,      sys_connect_by_path( bi.part_no||'-'||bi.alternative||';'||bi.preferred ,'|')  path_alternative
               FROM  specification_header sh  
               ,     bom_item             bi	      
               WHERE sh.part_no = bi.part_no
            	 and   sh.revision = bi.revision
               and   bi.alternative = (select MIN(bh.alternative) 
                                       from bom_header bh   
                                       where bh.part_no= bi.part_no 
                                       and preferred=1 
                                       and bh.revision = (select max(bh2.revision) 
                                                          from bom_header bh2 
                                                          where bh2.part_no=bh.part_no
                                                         ) 
                                       )
               and   bi.revision    = (select max(bh2.revision) 
                                       from bom_header bh2 
                                       where bh2.part_no=bi.part_no)    
               START WITH bi.COMPONENT_PART = PL_COMPONENT_PART_NO
               CONNECT BY NOCYCLE prior bi.part_no = bi.component_part 
                                 	 and  bi.alternative = (select MIN(bh.alternative) 
			                                                    from bom_header bh   
                                                          where bh.part_no= bi.part_no
                                                          and   bh.revision = bi.revision
                                                          and   bh.preferred=1 
                                                         )
                                    and  bi.revision    = (select max(bh2.revision) from bom_header bh2 where bh2.part_no=bi.part_no ) 
               order siblings by bi.component_part
               ) bi2
        where NOT EXISTS (select ''  from bom_item bi3 where bi3.component_part = bi2.part_no )  	--alleen finished-products die zelf niet als component voorkomen.
        and    bi2.part_no in (--Hierin zit FRAME-ID en PLANT (EF/GT) en Finished-product=EF
                               select av.PART_NO     
                               from av_bhr_bom_tyre_part_no   av
                               WHERE  av.part_no = bi2.part_no
                               AND    av.frame_id like '%'||'%' 
                              )
         ;
      */       
      --Tonen van totale-bom-STRUCTUUR vanaf COMPONENT tm TYRE !!!
      open c_bom_items       for 
        SELECT DISTINCT bi2.part_no     mainpart
        ,      bi2.revision             mainrevision
        ,      bi2.plant                mainplant
        ,      bi2.alternative          mainalternative
        ,      BI2.STATUS               MAINSTATUS
        ,      bi2.frame_id
        ,      bi2.path
		    --,      bi2.partaltpath
		    --,      bi2.partprefpath
        from ( SELECT bi.part_no
               ,      bi.revision     
               ,      bi.plant     
               ,      bi.alternative     
			         ,      bi.component_part
               ,      SH.STATUS
               ,      sh.frame_id	 
               ,      sys_connect_by_path( bi.component_part || ',' || bi.part_no ,'|')              path
               --,      sys_connect_by_path( bh.alternative ,'|')                                partaltpath
               --,      sys_connect_by_path( bh.preferred ,'|')                                partprefpath
               FROM  specification_header sh
               JOIN  bom_header  bh ON bh.part_no = sh.part_no and bh.revision = sh.revision and bh.preferred = 1 and bh.part_no not like 'XEM%'
               JOIN  bom_item    bi	ON bi.part_no = bh.part_no and bi.revision = bh.revision and bi.alternative = bh.alternative and bi.part_no not like 'XEM%'   
               WHERE (   sh.frame_id not in ('Trial E_ FM') 
                     and sh.part_no  not like ('XEM%')      )
               AND   sh.status      in (select s.status 
                                        from status s 
                                        where s.status = sh.status
                                        and   s.status_type in ('CURRENT','HISTORIC') )
               and   bh.revision    = (select max(bh2.revision) 
                                       from specification_header sh2
                                       ,    bom_header bh2 
                                       where sh2.part_no     = bH.part_no 
                                       and   bh2.alternative = bH.alternative
                                       and   BH2.preferred = 1
                                       and sh2.part_no   = bh2.part_no 
                                       and sh2.revision  = bh2.revision 
                                       and sh2.status in (select s.status 
                                                         from status s 
                                                         where s.status      = sh2.status
                                                         and   s.status_type in ('CURRENT','HISTORIC') ) )
               START WITH bi.COMPONENT_PART = PL_COMPONENT_PART_NO   --'EM_574'     
               CONNECT BY NOCYCLE prior bi.part_no = bi.component_part 
               order siblings by bi.component_part
               ) bi2
        where NOT EXISTS (select ''  from bom_item bi3 where bi3.component_part = bi2.part_no )  
        and bi2.status in (select s.status 
                           from status s 
                           where s.status      = bi2.status
                           and   s.status_type in ('CURRENT') ) 
		    and (   ( bi2.frame_id   LIKE ('A_PCR%')      --vooralsnog zonder TRIAL/XE-banden Enschede, wel XG-hongarije !!
                and (  bi2.part_no LIKE ('EF%') OR  bi2.part_no LIKE ('GF%') OR  bi2.PART_NO LIKE ('XGF%') )
                )
            OR  ( bi2.frame_id   LIKE ('A_TBR%')      --Truck-banden alleen Hongarije
                and (   bi2.part_no LIKE ('GF%') OR  BI2.PART_NO LIKE ('XGF%') )
                )
            OR  ( bi2.frame_id in ('E_PCR_VULC')      --C-alternative VulcTyre
                AND bi2.part_no like ('EV_C%')
                )
            OR  ( bi2.frame_id in ('E_SM')            --SpaceMaster Tyre
                AND bi2.part_no like ('EF%')
                )
            OR  ( bi2.frame_id in ('E_SF_Wheelset')   --SpaceMaster Wheelset (LET OP: IS GEEN FINISHED-PRODUCT !!)
	              and  (  bi2.part_no like ('EF%') or bi2.part_no like ('SW%') )
                )
            OR  ( bi2.frame_id in ('E_SF_BoxedWheels')   --SpaceMaster WheelsetBox (Bevat aantal Wheelsets)
	              and  (  bi2.part_no like ('EF%') or bi2.part_no like ('SE%') )
                )
            OR  ( bi2.frame_id in ('E_BBQ')           --Spoiler	
                and bi2.part_no like ('EQ%')
                )
            OR  ( bi2.frame_id in ('E_AT')            --Produced Agriculture Tyre (no trial/XEF)
                AND bi2.part_no like ('EF%')
                )
            )	
         ;
      loop 
        fetch c_bom_items into l_part_no 
                              ,l_revision
                              ,l_plant   
                              ,l_alternative
                              ,l_status
                              ,l_frame_id
                              ,l_path
                              --,l_path_alternative
                              ;
        if (c_bom_items%notfound)   
        then CLOSE C_BOM_ITEMS;
           exit;
        end if;
        l_aantal := l_aantal + 1;
		    dbms_output.put_line(l_part_no||';'||l_revision||';'||l_plant||';'||l_alternative||';'||l_status||';'||l_frame_id||';'||l_path);  --||';'||l_path_alternative );
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
END oud_select_part_related_tyre;
--
PROCEDURE SELECT_MV_PART_RELATED_TYRE (p_component_part_no   IN  varchar2 default null) 
DETERMINISTIC
AS
--Script om van een bom-ITEM/COMPONENT-PART de gerelateerde TYRES te bepalen die voldoen aan selectie-criteria
--BASIS = MATERIALIZED-VIEW = MV_BOM_ITEM_COMP_HEADER !!!!!!!!!!!!!!!!!!!
--(LET OP: DE REFRESH VAN DEZE MATERIALIZED-VIEW WORDT AANGESTUURD DOOR DAGELIJKSE MUTATIEVERWERKING: DBA_VERWERK_GEWICHT_MUTATIES !!!! )
--en FRAME-IDs voor uitwisseling met SAP (VIA view: AV_BHR_BOM_TYRE_PART_NO)
--
--LET OP: Dit is exacte copy van CURSOR in de DBA_VERWERK_GEWICHT_MUTATIES waarmee dagelijkse job bepaalt voor welke
--        banden opnieuw de gewichten berekend moeten worden !!!
--
--Parameters:  P_COMPONENT_PART_NO = bom-item, bijv.  EM_764 (prod)
--
pl_component_part_no         varchar2(100)   := upper(p_component_part_no);
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
  dbms_output.put_line('**************************************************************************************************************');
  dbms_output.put_line('Component-PART: '||pl_component_part_no  );
  dbms_output.put_line('**************************************************************************************************************');
  BEGIN
      --Tonen van totale-bom-STRUCTUUR vanaf COMPONENT tm TYRE !!!
      open c_bom_items       for 
        SELECT DISTINCT bi2.part_no     mainpart
        ,      bi2.revision             mainrevision
        ,      bi2.plant                mainplant
        ,      bi2.alternative          mainalternative
        ,      BI2.STATUS               MAINSTATUS
	      ,      BI2.FRAME_ID             MAINFRAMEID
        ,      bi2.path
        FROM		
        (SELECT bi.part_no
         ,      bi.revision     
         ,      bi.plant     
         ,      bi.alternative 
         ,      bi.status
         ,      bi.frame_id    
         ,      bi.component_part
         ,      bi.comp_revision
         ,      bi.comp_alternative
         ,      bi.comp_frame_id	 
         ,      sys_connect_by_path( bi.component_part || ',' || bi.part_no ,'|')              path
         FROM  MV_BOM_ITEM_COMP_HEADER bi
         WHERE (   bi.preferred = 1 
			         and bi.comp_preferred IN (1, -1) 
    				   )
         START WITH bi.COMPONENT_PART = p_component_part_no    --'EM_574'     
         CONNECT BY NOCYCLE prior bi.part_no     = bi.component_part 
                        and prior bi.revision    = bi.comp_revision 
                        and prior bi.alternative = bi.comp_alternative
                        AND prior bi.preferred   = 1
         order siblings by bi.component_part		
         ) bi2
         where NOT EXISTS (select ''  from bom_item bi3 where bi3.component_part = bi2.part_no )  
         and bi2.status in (select s.status 
                            from status s 
                            where s.status      = bi2.status
                            and   s.status_type in ('CURRENT') ) 
		     and (   ( bi2.frame_id   LIKE ('A_PCR%')      --vooralsnog zonder TRIAL/XE-banden Enschede, wel XG-hongarije !!
                and (  bi2.part_no LIKE ('EF%') OR  bi2.part_no LIKE ('GF%') OR  bi2.PART_NO LIKE ('XGF%') )
                )
            OR  ( bi2.frame_id   LIKE ('A_TBR%')      --Truck-banden alleen Hongarije
                and (   bi2.part_no LIKE ('GF%') OR  BI2.PART_NO LIKE ('XGF%') )
                )
            OR  ( bi2.frame_id in ('E_PCR_VULC')      --C-alternative VulcTyre
                AND bi2.part_no like ('EV_C%')
                )
            OR  ( bi2.frame_id in ('E_SM')            --SpaceMaster Tyre
                AND bi2.part_no like ('EF%')
                )
            OR  ( bi2.frame_id in ('E_SF_Wheelset')   --SpaceMaster Wheelset (LET OP: IS GEEN FINISHED-PRODUCT !!)
	              and  (  bi2.part_no like ('EF%') or bi2.part_no like ('SW%') )
                )
            OR  ( bi2.frame_id in ('E_SF_BoxedWheels')   --SpaceMaster WheelsetBox (Bevat aantal Wheelsets)
	              and  (  bi2.part_no like ('EF%') or bi2.part_no like ('SE%') )
                )
            OR  ( bi2.frame_id in ('E_BBQ')           --Spoiler	
                and bi2.part_no like ('EQ%')
                )
            OR  ( bi2.frame_id in ('E_AT')            --Produced Agriculture Tyre (no trial/XEF)
                AND bi2.part_no like ('EF%')
                )
            )			
        ;               
      loop 
        fetch c_bom_items into l_part_no 
                              ,l_revision
                              ,l_plant   
                              ,l_alternative
                              ,l_status
                              ,l_frame_id
                              ,l_path
                              --,l_path_alternative
                              ;
        if (c_bom_items%notfound)   
        then CLOSE C_BOM_ITEMS;
           exit;
        end if;
        l_aantal := l_aantal + 1;
		    dbms_output.put_line(l_part_no||';'||l_revision||';'||l_plant||';'||l_alternative||';'||l_status||';'||l_frame_id||';'||l_path);  --||';'||l_path_alternative );
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
END SELECT_MV_PART_RELATED_TYRE;
--
function FNC_SELECT_ALL_BOM_ITEM_TYRE (p_component_part_no   IN  varchar2 default null
                                      ,p_show_incl_items_jn  IN  varchar2 default 'N' ) 
RETURN NUMBER
DETERMINISTIC
AS
--Script om van een bom-ITEM/COMPONENT-PART de gerelateerde TYRES te bepalen. Hier zit geen beperking op voor een specifiek FRAME-ID
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
        ,      bi2.path
        ,      bi2.path_alternative
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
                     START WITH b.COMPONENT_PART = pl_component_part_no   --'EB_V27490E88F'  
                     CONNECT BY NOCYCLE PRIOR b.part_no = b.component_part
                          --and b.revision = (select sh1.revision from status s1, specification_header sh1 where sh1.part_no = b.part_no and sh1.status = s1.status and s1.status_type in ('CURRENT'))
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
                                       and    s.status_type in ('CURRENT')        --uiteindelijk alleen in current-banden geinteresseerd !  
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
END FNC_SELECT_ALL_BOM_ITEM_TYRE;
--




--***************************************************************************************************************
-- WEIGHT-CALCULATION functions/procedures
--***************************************************************************************************************
--
FUNCTION dba_bepaal_quantity_kg (P_STMNT VARCHAR2) 
RETURN VARCHAR
DETERMINISTIC
is
--Procedure om een STRING in format <BOM-ITEM COMPONENT-PART-quantity>/<BOM-HEADER COMPONENT-PART-base-Quantity> || 
--                                  <BOM-ITEM COMPONENT-PART-quantity>/<BOM-HEADER COMPONENT-PART-base-Quantity> etc.
--                        Vanaf de BOM_HEADER tot aan BOM_ITEM-MATERIAL (van item wat zelf geen header meer is).
--te vermenigvuldigen met de BOM_HEADER.BASE-QUANTITY, om vervolgens per BOM-ITEM het gewicht te bepalen van de hoeveelheid
--waarmee dit material onderdeel uitmaakt van de band/bom_header.
--
--Function to calculate the weight through a PATH-string coming from a CONNECT-TO-PRIOR-query
--Is used in the DBA_FNC_BEPAAL_HEADER_GEWICHT-procedure
--
--PARAMETER:  P_STMNT  = bom_header.part_no
--AANNAME:    In deze procedure is de <bom_header.base-quantity> default op "1" gezet. Misschien moeten we deze met een extra parameter vanuit aanroepend script doorgeven 
--            om altijd het echte BASE-QUANTITY mee te geven voor de berekening !!!
--Voorbeeld aanroep:
--SELECT DBA_BEPAAL_QUANTITY_KG('*(1/1)*(1/1)*(1.993676/1)') FROM DUAL;  --1.993676
--SELECT DBA_BEPAAL_QUANTITY_KG('*(1/1)*(1/1)*(1.993676/1)*(0.225/1)') FROM DUAL; --.4485771
--SELECT DBA_BEPAAL_QUANTITY_KG('*(1/1)*(1/1)*(1.993676/1)*(0.225/1)*(1.138/1)') FROM DUAL;  --.5104807398
--SELECT DBA_BEPAAL_QUANTITY_KG('*(1/1)*(1/1)*(1.993676/1)*(0.225/1)*(1.138/1)*(1.1077343/1.2067333)') FROM DUAL;  --.46860149211580979823793708187219164334
--SELECT DBA_BEPAAL_QUANTITY_KG('*(1/1)*(1/1)*(1.993676/1)*(0.225/1)*(1.138/1)*(1.1077343/1.2067333)*(1.009291/1.1950109)') FROM DUAL;  --.395774857433566327364349358905317245138
--SELECT DBA_BEPAAL_QUANTITY_KG('*(1/1)*(1/1)*(1.993676/1)*(0.225/1)*(1.138/1)*(1.1077343/1.2067333)*(1.009291/1.1950109)*(1.0784192/1.1120994)') FROM DUAL;  --.383788719905451483836066941634160668775
--SELECT DBA_BEPAAL_QUANTITY_KG('*(1/1)*(1/1)*(1.993676/1)*(0.225/1)*(1.138/1)*(1.1077343/1.2067333)*(1.009291/1.1950109)*(1.0784192/1.1120994)*(0.692091 /1.1080374)') FROM DUAL;
--
l_stmnt   varchar2(1000);
l_return  varchar2(1000);
l_base_quantity number := 1;
begin
  --BASE-QUANTITY = 1 in onderstaande SQL:
  l_stmnt := 'select '||l_base_quantity||' '||p_stmnt||' from dual';  
  execute immediate l_stmnt into l_return;
  return l_return;
end dba_bepaal_quantity_kg;
--
--
function fnc_bepaal_mv_header_gewicht (p_header_part_no      IN  varchar2 default null
                                      ,p_header_revision     in  number   default null
                                      ,p_header_alternative  IN  number   default 1
                                      ,p_show_incl_items_jn  IN  varchar2 default 'N' ) 
RETURN NUMBER
DETERMINISTIC
AS
--Script om per bom-header de gewichten te berekenen per band!
--BASIS IS DE MV = mv_bom_item_comp_header, Deze MV bevat NOG ALLE meest actuele REVISION met ALLE alternatives !!
--(dus voor BOM-onderzoek nog wel beperken op PREFERRED=1)
--
--SELECTIE ZIT HIERBIJ ALLEEN OP DE ONDERSTE BOM-ITEMS (=MATERIALEN/GRONDSTOFFEN) MET EEN UOM=KG
--WAARBIJ PER BOM-HEADER HET GEWICHT WORDT BEREKEND.
--parameter:  p_header_part_no     = MANDATORY, if not exists then process stops !!
--            p_header_revision    = OPTIONAL, if not given then the max(revision) will be used
--            p_header_alternative = OPTIONAL, if not given then the preferred-alternative will be used
--            p_show_incl_items_jn = OPTIONAL, if not given then NO debug-messages will be shown.
--
--LET OP: ALLE TUSSENLIGGENDE BOM-ITEM (RELATIES PART-NO/COMPONENT-PART) WORDEN HIERBIJ WEL GEBRUIKT VOOR SELECTIE,
--        MAAR DE KG VOOR DE GEWICHTSBEREKENING GENEGEERD !!!
--LET OP: Het komt voor dat er wel een BOM-ITEM-RELATIE bestaat tussen part-no + component-part maar dat
--        de component-part ondertussen al wel een HISTORIC-status heeft gekregen. 
--        In dit geval moet COMPONENT-PART wel in gewichtsberekening worden meegenomen, alhoewel de band/component-part
--        niet meer geproduceerd kan worden. De band zelf kan dan nog CURRENT-status hebben, maar gerelateerde component-part niet.
--
--Parameters:  P_HEADER_PART_NO = bom-item-header, bijv.  EF_Y245/35R20QPRX (prod)
--                                                        EF_W245/40R18WPRX (test-FOUTIEVE CURSOR)
--                                                        EF_710/40R22FLT162 (test)
--                         LET OP: Er komen XG-tyres uit hongarije voor met lowercase-characters in de naamgeving van PARTNO.
--                                 Om deze reden geen UPPER-gebruiken !!!
--
--             P_HEADER_REVISION = Indien NULL/GEEN REVISION meegegeven, dan wordt MAX-REVISION eerst opgehaald bij P_HEADER_PART-NO.
--                                 Dit is bom-item-header-revision-number van CURRENT/HISTORIC header.
--                                 Indien een TYRE zal status altijd CURRENT zijn. 
--                                 Een component kan zelf al HISTORIC zijn maar zolang hij in BOM-ITEM zit moet hij wel worden meegenomen.
--                                 Ook de COMPONENT-BOM-HEADER kan zelfs al HISTORIC zijn...Dan alsnog meenemen in de berekening !!!
--
--             P_HEADER_ALTERNATIVE = Indien NULL/GEEN-ALTERNATIVE meegegeven dan wordt PREFERRED-ALTERNATIVE eerst opgehaald bij P_HEADER_PART_NO.
--                                    Dit is bom-item-header-alternative van CURRENT/HISTORIC-header met PREFERRED=1.
--                                    Een ALTERNATIVE waarbij PREFERRED=0, doet niet mee in TYRE-WEIGHT-berekening, maar moet 
--                                    wel worden berekend voor SAP-WEIGHT.
--
--             P_SHOW_INCL_ITEMS_JN = Indien NULL/LEEG dan default waarde= 'N'
--                                    Wel/of niet ook de afzonderlijke gewichten van alle BOM-ITEMS laten zien in OUTPUT.
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
--********************************************************************************************************************************
--REVISION DATE        WHO  DESCRIPTION
--      1  03-04-2023  PS   JOINS IN QUERY VERVANGEN DOOR GEBRUIK VAN MV !!
--********************************************************************************************************************************
--
pl_header_part_no            varchar2(100)   := p_header_part_no;
pl_header_revision           number          := p_header_revision;
pl_header_alternative        number          := p_header_alternative;
pl_show_incl_items_jn        varchar2(1)     := upper(NVL(p_show_incl_items_jn,'N') );
pl_header_preferred          number;                  --preferred-ind bij header/alternative
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
l_preferred                 number;
l_part_status               varchar2(30);
l_item_header_base_quantity number;
l_item_number               number;
l_component_part            varchar2(100);
l_componentdescription      varchar2(1000);
l_comp_revision             varchar2(100);
l_comp_alternative          number;
l_comp_preferred            number;
l_comp_status               varchar2(30);
l_quantity                  number;
l_uom                       varchar2(100);
l_uom_org                   varchar2(100);    --uom-voor correctie van pcs/m in relatie met prop-weight
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
  --PS: haal max(spec-revision) op waarvoor nog een bom-header-revision voor bestaat...
    begin
      select max(sh1.revision) 
    into pl_header_revision
    from status               s1
    ,    specification_header sh1 
    ,    bom_header           bh
    where bh.part_no   = pl_header_part_no 
    and   sh1.part_no  = bh.part_no 
    AND   sh1.revision = bh.revision
    and   sh1.status   = s1.status 
    and   s1.status_type in ('CURRENT','HISTORIC')
    ;
  exception
    when others 
    then NULL;
      --dbms_output.put_line('REVISION-EXCP: Revision kon niet bepaald worden voor partno: '||pl_header_part_no||' rev: '||pl_header_revision);
    end;
  end if;
  if pl_header_alternative is null
  then
    --indien er geen alternative is meegegeven dan alsnog eerst zelf ophalen
  --PS: haal ALTERNATIVE op bij REVISION waarbij PREFERRED=1 
    begin
      select bh.alternative
    ,      bh.preferred
    into pl_header_alternative
    ,    pl_header_preferred
    from bom_header           bh
    where bh.part_no   = pl_header_part_no 
    and   bh.revision  = pl_header_revision 
    and   bh.preferred = 1
    ;
  exception
    when others 
    then NULL; 
      --dbms_output.put_line('ALTERNATIVE-EXCP: ALTERNATIVE kon niet bepaald worden voor partno: '||pl_header_part_no||' rev: '||pl_header_revision);
    end;
  else
    --indien er WEL alternative is meegegeven dan alsnog de PREFERRED-IND ERBIJ ophalen
  --PS: haal preferred op bij ALTERNATIVE op bij header-REVISION  
    begin
      select bh.preferred
    into pl_header_preferred
    from bom_header           bh
    where bh.part_no     = pl_header_part_no 
    and   bh.revision    = pl_header_revision 
    and   bh.alternative = pl_header_alternative
    ;
  exception
    when others 
    then dbms_output.put_line('PREFERRED-EXCP: PREFERRED kon niet bepaald worden voor partno: '||pl_header_part_no||' rev: '||pl_header_revision||' alt: '||pl_header_alternative);
    end;
    --
  end if;
  if upper(pl_show_incl_items_jn) = 'J'
  then  
    dbms_output.put_line('**************************************************************************************************************');
    dbms_output.put_line('FNC_BEPAAL_HEDER_GEWICHT.HEADER-MAINPART: '||pl_header_part_no ||' revision: '||pl_header_revision||' alternative: '||pl_header_alternative||' show bom-items J/N: '||pl_show_incl_items_jn );
    dbms_output.put_line('**************************************************************************************************************');
  end if;
  --Indien parameter =SHOW-ITEMS=ja
  if UPPER(pl_show_incl_items_jn) in ('J')
  then
    BEGIN
      --dbms_output.put_line('l_mainpart'||';'||'l_mainrevision'||';'||'l_mainalternative'||';'||'l_mainbasequantity'||';'||'l_mainsumitemsquantity'||';'||'l_mainstatus'||';'||'l_mainframeid'||';'||'l_mainpartdescription'||';'||'l_mainpartbaseuom'||
      --                  ';'||'l_part_no'||';'||'l_item_header_base_quantity'||';'||'l_component_part'||';'||'l_componentdescription'||';'||'l_quantity'||';'||'l_uom'||';'||'l_quantity_kg'||';'||'l_path'||';'||'l_quantity_path'||';'||'l_bom_quantity_kg'||';'||'l_status'||';'||'l_characteristic_id'||';'||'l_functiecode' );      
      dbms_output.put_line('l_mainpart'||';'||'l_mainrevision'||';'||'l_mainplant'||';'||'l_mainalternative'||';'||'l_mainbasequantity'||';'||'l_mainstatus'||';'||'l_mainframeid'||';'||'l_mainpartdescription'||';'||'l_mainpartbaseuom'||   
		          ';'||'l_part_no'||';'||'l_revision'||';'||'l_plant'||';'||'l_alternative'||';'||'l_preferred'||';'||'l_part_status'||';'||'l_item_number'||
              ';'||'l_component_part'||';'||'l_componentdescription'||';'||'l_comp_revision'||';'||'l_comp_alternative'||';'||'l_comp_preferred'||';'||'l_comp_status'||';'||'l_item_header_base_quantity'||';'||'l_quantity'||';'||'l_uom'||
							';'||'l_quantity_kg'||';'||'l_characteristic_id'||';'||'l_functiecode'||';'||'l_path'||';'||'l_quantity_path'||';'||'l_bom_quantity_kg');      
      --Tonen van totale-gewicht van BOM-HEADER:
      open c_bom_items for SELECT bi2.LVL
        ,      bi2.level_tree
        ,      bi2.mainpart
        ,      bi2.mainrevision
        ,      bi2.mainplant
        ,      bi2.mainalternative
        ,      bi2.mainbasequantity
        ,      bi2.mainstatus
        ,      bi2.mainframeid
        ,      bi2.mainpartdescription
        ,      bi2.mainpartbaseuom
        ,      bi2.part_no
        ,      bi2.revision
        ,      bi2.plant
        ,      bi2.alternative
		    ,      bi2.preferred
		    ,      bi2.part_status
        ,      bi2.item_number
        ,      bi2.component_part
        ,      bi2.componentdescription
	    	,      bi2.comp_revision
		    ,      bi2.comp_alternative
		    ,      bi2.comp_preferred
        ,      bi2.comp_status
        ,      bi2.item_header_base_quantity
        ,      bi2.quantity
        ,      bi2.uom
        ,      bi2.quantity_kg
        ,      bi2.characteristic_id 
        ,      bi2.functiecode
        ,      bi2.path
        ,      bi2.quantity_path
        ,      DBA_BEPAAL_QUANTITY_KG(bi2.quantity_path)  bom_quantity_kg
        from
        (
        with sel_bom_header as 
			    (select DISTINCT bih.part_no
    			,      bih.revision
	        ,      bih.plant
			    ,      bih.alternative
			    ,      bih.preferred
			    ,      bih.base_quantity
			    ,      bih.status     			--pas later de sort-desc erbijhalen...
			    ,      bih.frame_id
          from  mv_bom_item_comp_header bih
          where  bih.part_no     = pl_header_part_no  --'EM_764' --'EG_H620/50R22-154G'  --l_header_part_no
			    and    bih.revision    = pl_header_revision --(select max(sh1.revision) from status s1, specification_header sh1 where sh1.part_no = bh.part_no and sh1.status = s1.status and s1.status_type in ('CURRENT','HISTORIC'))
			    and    bih.alternative = pl_header_alternative  --default alternative bij preferred=1, maar kan ook expliciet preferred=0
			    AND    bih.preferred   = 1
			    ) 	
        select LEVEL   LVL
        ,      RPAD('.', (level-1)*2, '.') || LEVEL AS level_tree
        ,      bh.part_no             mainpart
        ,      bh.revision            mainrevision
        ,      bh.plant               mainplant
        ,      bh.alternative         mainalternative
		    ,      bh.preferred           mainpreferred
        ,      bh.base_quantity       mainbasequantity
        ,      (select s.sort_desc from status s where s.status = bh.status )     mainstatus
        ,      bh.frame_id            mainframeid
        ,      (select pi.description from part pi where pi.part_no = bh.part_no)  mainpartdescription
        ,      (select pi.base_uom    from part pi where pi.part_no = bh.part_no)  mainpartbaseuom
        ,      b.part_no
        ,      b.revision
        ,      b.plant
        ,      b.alternative
	    	,      b.preferred
	    	,      (select s.sort_desc from status s where s.status = b.status)     part_status
        ,      b.item_number
        ,      b.component_part
        ,      (select pi.description from part pi where pi.part_no = b.component_part)  componentdescription
	    	,      b.comp_revision
     		,      b.comp_alternative
	    	,      b.comp_preferred
        ,      (select s.sort_desc from status s where s.status = b.comp_status)  comp_status
        ,      b.item_header_base_quantity
        ,      b.quantity
        ,      b.uom
        ,      b.uom_org
        ,      b.quantity_kg
        ,      b.characteristic_id       --FUNCTIECODE
        ,      b.functiecode             --functiecode-descr
        ,      sys_connect_by_path( b.part_no||decode(b.characteristic_id,null,'','-'||b.characteristic_id) || ',' || b.component_part ,'|')  path
        ,      sys_connect_by_path( '('||b.quantity_kg||'/'||b.item_header_base_quantity||')', '*')  quantity_path
        FROM ( SELECT bi.part_no
             ,      bi.revision
             ,      bi.plant
             ,      bi.alternative
		      	 ,      bi.preferred
		      	 ,      bi.status
             ,      bi.item_number
             ,      bi.component_part
			       ,      bi.comp_revision
			       ,      bi.comp_alternative
			       ,      bi.comp_preferred
			       ,      bi.comp_status
             --,      (select bh.base_quantity from bom_header bh where bh.part_no = bi.part_no and bh.revision = bi.revision and bh.alternative= bi.alternative )   item_header_base_quantity
             ,      bi.base_quantity   item_header_base_quantity
             ,      bi.quantity
             ,      case when bi.uom in ('pcs','ST') or bi.uom like ('%m%') --m/m2/km    
                         then (--indien een material met uom=pcs dan weight uit property halen, en uom aanpassen naar "kg"
                              SELECT 'kg'
                              FROM specification_prop sp
                              WHERE sp.part_no        = bi.component_part   --'GR_9787'
                              AND NOT exists (select '' from bom_item bi3 where bi3.part_no = bi.component_part )  
                              --PS: gebruik component-item/header-spec-header-revision
                              --PS: gebruik component-item/spec-header-revision, MATERIALS hebben alleen SPECIFICATION-header, geen bom-header !!!
                              AND   sp.revision = (select max(sh1.revision) 
                                                   from status s1, specification_header sh1
                                                   where   sh1.part_no    = sp.part_no             --is component-part-no
                                                   and     sh1.status     = s1.status 
                                                   and     s1.status_type in ('CURRENT','HISTORIC')
                                                  )
                              AND   sp.section_id     = 700755 --  SAP information
                              --AND   sp.sub_section_id = 701502 -- A        --alle SAP-WEIGHT-properties meenemen in berekening
                              AND   sp.property_group = 0 -- (none)
                              AND   sp.property       = 703262 -- Weight
                              and   rownum = 1
                              UNION
                              --indien component-part met uom=pcs dan aantal meenemen in de berekening
                              select bi.uom
                              from dual
                              where exists (select '' from bom_item bi3 where bi3.part_no = bi.component_part )   --revision = header-revision, geen comp-revision, dus kunnen hier niet expliciet op checken...
                             )
                         else bi.uom 
                    end   uom
             ,      bi.uom     uom_org
             ,      case when bi.uom = 'g' 
                         then (bi.quantity/1000) 
                         when bi.uom = 'kg'
                         then bi.quantity
                         when bi.uom in ('pcs','ST') or bi.uom like ('%m%')    --m/m2/km
                         then (--indien een material met uom=pcs dan weight uit property halen
                              SELECT (sp.num_1 * bi.quantity)
                              FROM specification_prop sp
                              WHERE sp.part_no        = bi.component_part   --'GR_9787'
                              AND NOT exists (select '' from bom_item bi3 where bi3.part_no = bi.component_part ) 
                              --PS: gebruik component-item/spec-header-revision, MATERIALS hebben alleen SPECIFICATION-header, geen bom-header !!!
                              AND   sp.revision = (select max(sh1.revision) 
                                                   from status s1, specification_header sh1
                                                   where   sh1.part_no    = sp.part_no        --is component-part-no
                                                   and     sh1.status     = s1.status 
                                                   and     s1.status_type in ('CURRENT','HISTORIC')
                                                  )
                              AND   sp.section_id     = 700755 --  SAP information
                              --AND   sp.sub_section_id = 701502 -- A    --alle SAP-WEIGHT-properties meenemen in berekening
                              AND   sp.property_group = 0 -- (none)
                              AND   sp.property       = 703262 -- Weight
                              and   rownum = 1
                              UNION
                              --indien component-part met uom=pcs dan aantal meenemen in de berekening
                              select bi.quantity 
                              from dual
                              where exists (select '' from bom_item bi3 where bi3.part_no = bi.component_part )   --revision = header-revision, geen comp-revision, dus kunnen hier niet expliciet op checken...
                              )
                          else bi.quantity 
                    end   quantity_kg
             ,      bi.characteristic  characteristic_id       
             ,      (select c.description from characteristic c where c.characteristic_id = bi.characteristic)  functiecode
             FROM  mv_bom_item_comp_header bi
             WHERE (   bi.preferred = 1 
			             and bi.comp_preferred IN (1, -1) 
				           )
             ) b
        ,      sel_bom_header bh     
        START WITH b.part_no = bh.part_no and b.preferred = bh.preferred
        CONNECT BY NOCYCLE       PRIOR b.component_part   = b.part_no 
							and  prior b.comp_revision    = b.revision
							and  prior b.comp_alternative = b.alternative
							and  prior b.comp_preferred   = 1
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
                          ,l_mainstatus
                          ,l_mainframeid
                          ,l_mainpartdescription
                          ,l_mainpartbaseuom
                          ,l_part_no 
                          ,l_revision
                          ,l_plant   
                          ,l_alternative
                          ,l_preferred
                          ,l_part_status
                          ,l_item_number
                          ,l_component_part      
                          ,l_componentdescription              
                          ,l_comp_revision
                          ,l_comp_alternative
                          ,l_comp_preferred
                          ,l_comp_status
                          ,l_item_header_base_quantity
                          ,l_quantity            
                          ,l_uom    
                          ,l_quantity_kg         
                          ,l_characteristic_id
                          ,l_functiecode
                          ,l_path                
                          ,l_quantity_path       
                          ,l_bom_quantity_kg    --gewicht-materiaal opgewerkt naar header
              ;
        --
        if (c_bom_items%notfound)   
        then CLOSE C_BOM_ITEMS;
           exit;
        end if;
        --
        l_bom_quantity_kg := round(l_bom_quantity_kg, gc_afrond);
        --Wordt alleen getoond indien PL_SHOW_INCL_ITEMS_JN="J":
        --dbms_output.put_line('HEADER: '||l_mainpart||';'||l_mainrevision||';'||l_mainplant||';'||l_mainalternative||';'||l_mainbasequantity||';'||l_mainsumitemsquantity||';'||l_mainstatus||';'||l_mainframeid||';'||l_mainpartdescription||';'||l_mainpartbaseuom||
        --                  ';'||l_part_no||';'||l_item_header_base_quantity||';'||l_component_part||';'||l_componentdescription||';'||l_quantity||';'||l_uom||';'||l_quantity_kg ||';'||l_path||';'||l_quantity_path||';'||l_bom_quantity_kg||';'||l_status||';'||l_characteristic_id||';'||l_functiecode );
        dbms_output.put_line('HEADER: '||l_mainpart||';'||l_mainrevision||';'||l_mainplant||';'||l_mainalternative||';'||l_mainbasequantity||';'||l_mainsumitemsquantity||';'||l_mainstatus||';'||l_mainframeid||
                   --';'||l_mainpartdescription||';'||l_mainpartbaseuom||
                   ';'||L_level_tree||
                   ';'||l_part_no||';'||l_revision||';'||l_alternative||';'||l_item_header_base_quantity||';'||l_item_number||';'||l_component_part||';'||l_componentdescription||';'||l_quantity||';'||l_uom||'/'||l_uom_org||
                   ';'||l_quantity_kg ||';'||l_path||';'||l_quantity_path||';'||l_bom_quantity_kg||';'||l_status||';'||l_characteristic_id||';'||l_functiecode );
        --
        --exit;    
      end loop;
      close c_bom_items;  
    --
  EXCEPTION
    WHEN OTHERS 
    THEN if sqlerrm not like '%ORA-01001%' 
           THEN dbms_output.put_line('FNC-BEPAAL-HEADER-GEWICHT: ALG-EXCP BOM-ITEMS: '||SQLERRM); 
           else null;   
           end if;
  END;
  --
  end if;   --show-items = J
  --
  if upper(pl_show_incl_items_jn) = 'J'
  then   
    dbms_output.put_line('**************************************************************************************************************');
    dbms_output.put_line('BEREKEN TOTAALGEWICHT VAN HEADER: '||pl_header_part_no);
    dbms_output.put_line('**************************************************************************************************************');
  end if;
  --VERVOLGENS ALTIJD Tonen van totale-gewicht van BOM-HEADER:
  BEGIN
    --sum(decode(uom,'pcs',0,quantity_kg)), sum(decode(uom,'pcs',0,excl_quantity_kg))
    --Voor alle materialen die geen gewicht hebben (maar "pcs") nemen we geen gewicht mee
    open c_bom for 
    select mainpart
    ,      sum(decode(uom,'kg',quantity_kg,0))      gewicht
    ,      sum(decode(uom,'kg',bom_quantity_kg,0))  header_bom_gewicht_som_items
    from (
      SELECT bi2.LVL
        ,      bi2.level_tree
        ,      bi2.mainpart
        ,      bi2.mainrevision
        ,      bi2.mainplant
        ,      bi2.mainalternative
        ,      bi2.mainbasequantity
        ,      bi2.mainstatus
        ,      bi2.mainframeid
        ,      bi2.mainpartdescription
        ,      bi2.mainpartbaseuom
        ,      bi2.part_no
        ,      bi2.revision
        ,      bi2.plant
        ,      bi2.alternative
		    ,      bi2.preferred
		    ,      bi2.part_status
        ,      bi2.item_number
        ,      bi2.component_part
        ,      bi2.componentdescription
	    	,      bi2.comp_revision
		    ,      bi2.comp_alternative
		    ,      bi2.comp_preferred
        ,      bi2.comp_status
        ,      bi2.item_header_base_quantity
        ,      bi2.quantity
        ,      bi2.uom
        ,      bi2.quantity_kg
        ,      bi2.characteristic_id 
        ,      bi2.functiecode
        ,      bi2.path
        ,      bi2.quantity_path
        ,      DBA_BEPAAL_QUANTITY_KG(bi2.quantity_path)  bom_quantity_kg
        from
        (
        with sel_bom_header as 
			    (select DISTINCT bih.part_no
    			,      bih.revision
	        ,      bih.plant
			    ,      bih.alternative
			    ,      bih.preferred
			    ,      bih.base_quantity
			    ,      bih.status     			--pas later de sort-desc erbijhalen...
			    ,      bih.frame_id
          from  mv_bom_item_comp_header bih
          where  bih.part_no     = pl_header_part_no  --'EM_764' --'EG_H620/50R22-154G'  --l_header_part_no
			    and    bih.revision    = pl_header_revision --(select max(sh1.revision) from status s1, specification_header sh1 where sh1.part_no = bh.part_no and sh1.status = s1.status and s1.status_type in ('CURRENT','HISTORIC'))
			    and    bih.alternative = pl_header_alternative  --default alternative bij preferred=1, maar kan ook expliciet preferred=0
			    AND    bih.preferred   = 1
			    ) 	
        select LEVEL   LVL
        ,      RPAD('.', (level-1)*2, '.') || LEVEL AS level_tree
        ,      bh.part_no             mainpart
        ,      bh.revision            mainrevision
        ,      bh.plant               mainplant
        ,      bh.alternative         mainalternative
		    ,      bh.preferred           mainpreferred
        ,      bh.base_quantity       mainbasequantity
        ,      (select s.sort_desc from status s where s.status = bh.status )     mainstatus
        ,      bh.frame_id            mainframeid
        ,      (select pi.description from part pi where pi.part_no = bh.part_no)  mainpartdescription
        ,      (select pi.base_uom    from part pi where pi.part_no = bh.part_no)  mainpartbaseuom
        ,      b.part_no
        ,      b.revision
        ,      b.plant
        ,      b.alternative
	    	,      b.preferred
	    	,      (select s.sort_desc from status s where s.status = b.status)     part_status
        ,      b.item_number
        ,      b.component_part
        ,      (select pi.description from part pi where pi.part_no = b.component_part)  componentdescription
	    	,      b.comp_revision
     		,      b.comp_alternative
	    	,      b.comp_preferred
        ,      (select s.sort_desc from status s where s.status = b.comp_status)  comp_status
        ,      b.item_header_base_quantity
        ,      b.quantity
        ,      b.uom
        ,      b.uom_org
        ,      b.quantity_kg
        ,      b.characteristic_id       --FUNCTIECODE
        ,      b.functiecode             --functiecode-descr
        ,      sys_connect_by_path( b.part_no||decode(b.characteristic_id,null,'','-'||b.characteristic_id) || ',' || b.component_part ,'|')  path
        ,      sys_connect_by_path( '('||b.quantity_kg||'/'||b.item_header_base_quantity||')', '*')  quantity_path
        FROM ( SELECT bi.part_no
             ,      bi.revision
             ,      bi.plant
             ,      bi.alternative
		      	 ,      bi.preferred
		      	 ,      bi.status
             ,      bi.item_number
             ,      bi.component_part
			       ,      bi.comp_revision
			       ,      bi.comp_alternative
			       ,      bi.comp_preferred
			       ,      bi.comp_status
             --,      (select bh.base_quantity from bom_header bh where bh.part_no = bi.part_no and bh.revision = bi.revision and bh.alternative= bi.alternative )   item_header_base_quantity
             ,      bi.base_quantity   item_header_base_quantity
             ,      bi.quantity
             ,      case when bi.uom in ('pcs','ST') or bi.uom like ('%m%') --m/m2/km    
                         then (--indien een material met uom=pcs dan weight uit property halen, en uom aanpassen naar "kg"
                              SELECT 'kg'
                              FROM specification_prop sp
                              WHERE sp.part_no        = bi.component_part   --'GR_9787'
                              AND NOT exists (select '' from bom_item bi3 where bi3.part_no = bi.component_part )  
                              --PS: gebruik component-item/header-spec-header-revision
                              --PS: gebruik component-item/spec-header-revision, MATERIALS hebben alleen SPECIFICATION-header, geen bom-header !!!
                              AND   sp.revision = (select max(sh1.revision) 
                                                   from status s1, specification_header sh1
                                                   where   sh1.part_no    = sp.part_no             --is component-part-no
                                                   and     sh1.status     = s1.status 
                                                   and     s1.status_type in ('CURRENT','HISTORIC')
                                                  )
                              AND   sp.section_id     = 700755 --  SAP information
                              --AND   sp.sub_section_id = 701502 -- A        --alle SAP-WEIGHT-properties meenemen in berekening
                              AND   sp.property_group = 0 -- (none)
                              AND   sp.property       = 703262 -- Weight
                              and   rownum = 1
                              UNION
                              --indien component-part met uom=pcs dan aantal meenemen in de berekening
                              select bi.uom
                              from dual
                              where exists (select '' from bom_item bi3 where bi3.part_no = bi.component_part )   --revision = header-revision, geen comp-revision, dus kunnen hier niet expliciet op checken...
                             )
                         else bi.uom 
                    end   uom
             ,      bi.uom     uom_org
             ,      case when bi.uom = 'g' 
                         then (bi.quantity/1000) 
                         when bi.uom = 'kg'
                         then bi.quantity
                         when bi.uom in ('pcs','ST') or bi.uom like ('%m%')    --m/m2/km
                         then (--indien een material met uom=pcs dan weight uit property halen
                              SELECT (sp.num_1 * bi.quantity)
                              FROM specification_prop sp
                              WHERE sp.part_no        = bi.component_part   --'GR_9787'
                              AND NOT exists (select '' from bom_item bi3 where bi3.part_no = bi.component_part ) 
                              --PS: gebruik component-item/spec-header-revision, MATERIALS hebben alleen SPECIFICATION-header, geen bom-header !!!
                              AND   sp.revision = (select max(sh1.revision) 
                                                   from status s1, specification_header sh1
                                                   where   sh1.part_no    = sp.part_no        --is component-part-no
                                                   and     sh1.status     = s1.status 
                                                   and     s1.status_type in ('CURRENT','HISTORIC')
                                                  )
                              AND   sp.section_id     = 700755 --  SAP information
                              --AND   sp.sub_section_id = 701502 -- A    --alle SAP-WEIGHT-properties meenemen in berekening
                              AND   sp.property_group = 0 -- (none)
                              AND   sp.property       = 703262 -- Weight
                              and   rownum = 1
                              UNION
                              --indien component-part met uom=pcs dan aantal meenemen in de berekening
                              select bi.quantity 
                              from dual
                              where exists (select '' from bom_item bi3 where bi3.part_no = bi.component_part )   --revision = header-revision, geen comp-revision, dus kunnen hier niet expliciet op checken...
                              )
                          else bi.quantity 
                    end   quantity_kg
             ,      bi.characteristic  characteristic_id       
             ,      (select c.description from characteristic c where c.characteristic_id = bi.characteristic)  functiecode
             FROM  mv_bom_item_comp_header bi
             WHERE (   bi.preferred = 1 
			             and bi.comp_preferred IN (1, -1) 
				           )
             ) b
        ,      sel_bom_header bh     
        START WITH b.part_no = bh.part_no and b.preferred = bh.preferred
        CONNECT BY NOCYCLE   PRIOR b.component_part   = b.part_no 
						           	and  prior b.comp_revision    = b.revision
					              and  prior b.comp_alternative = b.alternative
							          and  prior b.comp_preferred   = 1
        order siblings by b.part_no
        )  bi2
        --select alleen gewicht van materialen...
        where bi2.component_part NOT IN (select bi3.part_no from bom_item bi3 where bi3.part_no = bi2.component_part)
			)
		group by mainpart
		;
    loop 
      BEGIN
        fetch c_bom into l_header_mainpart, l_header_gewicht, l_header_bom_gewicht_som_items;
        if (c_bom%notfound)   
        then CLOSE C_BOM;
             exit;
        end if;
        --
        l_header_gewicht               := round(l_header_gewicht, gc_afrond);
        l_header_bom_gewicht_som_items := round(l_header_bom_gewicht_som_items, gc_afrond);
        --
        if upper(pl_show_incl_items_jn) = 'J'
        then 
          dbms_output.put_line('**************************************************************************************************************');
          dbms_output.put_line('TOTAALGEWICHT VAN ITEM;'||pl_header_part_no||';revision;'||pl_header_revision||';base-gewicht;'||l_header_gewicht||';header-gewicht-bom-items;'||l_header_bom_gewicht_som_items );
          dbms_output.put_line('**************************************************************************************************************');
          --else
          --  dbms_output.put_line('TOTAALGEWICHT VAN ITEM;'||pl_header_part_no||';base-gewicht;'||l_header_gewicht||';header-gewicht-bom-items;'||l_header_bom_gewicht_som_items );
	      end if;
      EXCEPTION
        WHEN OTHERS 
        THEN 
          if c_bom%isopen
          then close c_bom;  
          end if;
          if sqlerrm not like '%ORA-01001%' 
          THEN dbms_output.put_line('ALG-TOTAL-LOOP-EXCP FNC-BEPAAL-HEADER-GEWICHT-SUM '||pl_header_part_no||'.'||pl_header_revision||'-'||pl_header_alternative||': '||SQLERRM); 
          else null; 
      	  end if;
      END;        
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
      THEN dbms_output.put_line('ALG-EXCP FNC-BEPAAL-HEADER-GEWICHT-TOTAL '||pl_header_part_no||'.'||pl_header_revision||'-'||pl_header_alternative||': '||SQLERRM); 
      else null; 
	  end if;
  END;
  --
  --DBMS_OUTPUT.put_line('voor return: '||l_header_bom_gewicht_som_items);
  RETURN l_header_bom_gewicht_som_items;
  --
END fnc_bepaal_mv_header_gewicht;
--
function dba_fnc_bepaal_header_gewicht (p_header_part_no      IN  varchar2 default null
                                       ,p_header_revision     in  number   default null
                                       ,p_header_alternative  IN  number   default 1
                                       ,p_show_incl_items_jn  IN  varchar2 default 'N' ) 
RETURN NUMBER
DETERMINISTIC
AS
--FUNCTIE IS GEBASEERD OP INTERSPEC-TABELLEN EN NIET OP MV !!! WORDT NIET VANUIT VERWERKING GEBRUIKT, 
--MAAR KAN AD-HOC GEBRUIKT WORDEN !!
--
--Script om per bom-header de gewichten te berekenen per band!
--SELECTIE ZIT HIERBIJ ALLEEN OP DE ONDERSTE BOM-ITEMS (=MATERIALEN/GRONDSTOFFEN) MET EEN UOM=KG
--WAARBIJ PER BOM-HEADER HET GEWICHT WORDT BEREKEND.
--parameter:  p_header_part_no     = MANDATORY, if not exists then process stops !!
--            p_header_revision    = OPTIONAL, if not given then the max(revision) will be used
--            p_header_alternative = OPTIONAL, if not given then the preferred-alternative will be used
--            p_show_incl_items_jn = OPTIONAL, if not given then NO debug-messages will be shown.
--
--LET OP: ALLE TUSSENLIGGENDE BOM-ITEM (RELATIES PART-NO/COMPONENT-PART) WORDEN HIERBIJ WEL GEBRUIKT VOOR SELECTIE,
--        MAAR DE KG VOOR DE GEWICHTSBEREKENING GENEGEERD !!!
--LET OP: Het komt voor dat er wel een BOM-ITEM-RELATIE bestaat tussen part-no + component-part maar dat
--        de component-part ondertussen al wel een HISTORIC-status heeft gekregen. 
--        In dit geval moet COMPONENT-PART wel in gewichtsberekening worden meegenomen, alhoewel de band/component-part
--        niet meer geproduceerd kan worden. De band zelf kan dan nog CURRENT-status hebben, maar gerelateerde component-part niet.
--
--Parameters:  P_HEADER_PART_NO = bom-item-header, bijv.  EF_Y245/35R20QPRX (prod)
--                                                        EF_W245/40R18WPRX (test-FOUTIEVE CURSOR)
--                                                        EF_710/40R22FLT162 (test)
--                         LET OP: Er komen XG-tyres uit hongarije voor met lowercase-characters in de naamgeving van PARTNO.
--                                 Om deze reden geen UPPER-gebruiken !!!
--
--             P_HEADER_REVISION = Indien NULL/GEEN REVISION meegegeven, dan wordt MAX-REVISION eerst opgehaald bij P_HEADER_PART-NO.
--                                 Dit is bom-item-header-revision-number van CURRENT/HISTORIC header.
--                                 Indien een TYRE zal status altijd CURRENT zijn. 
--                                 Een component kan zelf al HISTORIC zijn maar zolang hij in BOM-ITEM zit moet hij wel worden meegenomen.
--                                 Ook de COMPONENT-BOM-HEADER kan zelfs al HISTORIC zijn...Dan alsnog meenemen in de berekening !!!
--
--             P_HEADER_ALTERNATIVE = Indien NULL/GEEN-ALTERNATIVE meegegeven dan wordt PREFERRED-ALTERNATIVE eerst opgehaald bij P_HEADER_PART_NO.
--                                    Dit is bom-item-header-alternative van CURRENT/HISTORIC-header met PREFERRED=1.
--                                    Een ALTERNATIVE waarbij PREFERRED=0, doet niet mee in TYRE-WEIGHT-berekening, maar moet 
--                                    wel worden berekend voor SAP-WEIGHT.
--
--             P_SHOW_INCL_ITEMS_JN = Indien NULL/LEEG dan default waarde= 'N'
--                                    Wel/of niet ook de afzonderlijke gewichten van alle BOM-ITEMS laten zien in OUTPUT.
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
--********************************************************************************************************************************
--REVISION DATE        WHO  DESCRIPTION
--      10 25-07-2022  PS   Select the max(specification-header.revision) where a related bom-header.REVISION exists
--      11 18-08-2022  PS   extra debug-logging omtrent part-no/path/quality-path toegevoegd.
--      12 23-08-2022  PS   Extra parameter P_HEADER_ALTERNATIVE toegevoegd die het mogelijk moet maken om ook voor
--                          ALTERNATIVE waarbij PREFERRED=0 de gewichten op te vragen.
--      13 30-08-2022  PS   Excp-handler-error-text bij bepalen revision/alternative/preferred aangepast.
--      14 19-12-2022  PS   Sum-constructie in totaal-telling (tweede-cursor) aangepast door eerst expliciet op UOM=kg te controleren.
--                          Daarmee voorkomen we errors voor materialen zonder SAP-information-property WEIGHT (UOM/QUANTITY)
--********************************************************************************************************************************
--
pl_header_part_no            varchar2(100)   := p_header_part_no;
pl_header_revision           number          := p_header_revision;
pl_header_alternative        number          := p_header_alternative;
pl_show_incl_items_jn        varchar2(1)     := upper(NVL(p_show_incl_items_jn,'N') );
pl_header_preferred          number;                  --preferred-ind bij header/alternative
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
l_item_number               number;
l_component_part            varchar2(100);
l_componentdescription      varchar2(1000);
l_quantity                  number;
l_uom                       varchar2(100);
l_uom_org                   varchar2(100);    --uom-voor correctie van pcs/m in relatie met prop-weight
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
  --PS: haal max(spec-revision) op waarvoor nog een bom-header-revision voor bestaat...
    begin
      select max(sh1.revision) 
    into pl_header_revision
    from status               s1
    ,    specification_header sh1 
    ,    bom_header           bh
    where bh.part_no   = pl_header_part_no 
    and   sh1.part_no  = bh.part_no 
    AND   sh1.revision = bh.revision
    and   sh1.status   = s1.status 
    and   s1.status_type in ('CURRENT','HISTORIC')
    ;
  exception
    when others 
    then NULL;
      --dbms_output.put_line('REVISION-EXCP: Revision kon niet bepaald worden voor partno: '||pl_header_part_no||' rev: '||pl_header_revision);
    end;
  end if;
  if pl_header_alternative is null
  then
    --indien er geen alternative is meegegeven dan alsnog eerst zelf ophalen
  --PS: haal ALTERNATIVE op bij REVISION waarbij PREFERRED=1 
    begin
      select bh.alternative
    ,      bh.preferred
    into pl_header_alternative
    ,    pl_header_preferred
    from bom_header           bh
    where bh.part_no   = pl_header_part_no 
    and   bh.revision  = pl_header_revision 
    and   bh.preferred = 1
    ;
  exception
    when others 
    then NULL; 
      --dbms_output.put_line('ALTERNATIVE-EXCP: ALTERNATIVE kon niet bepaald worden voor partno: '||pl_header_part_no||' rev: '||pl_header_revision);
    end;
  else
    --indien er WEL alternative is meegegeven dan alsnog de PREFERRED-IND ERBIJ ophalen
  --PS: haal preferred op bij ALTERNATIVE op bij header-REVISION  
    begin
      select bh.preferred
    into pl_header_preferred
    from bom_header           bh
    where bh.part_no     = pl_header_part_no 
    and   bh.revision    = pl_header_revision 
    and   bh.alternative = pl_header_alternative
    ;
  exception
    when others 
    then dbms_output.put_line('PREFERRED-EXCP: PREFERRED kon niet bepaald worden voor partno: '||pl_header_part_no||' rev: '||pl_header_revision||' alt: '||pl_header_alternative);
    end;
    --
  end if;
  if upper(pl_show_incl_items_jn) = 'J'
  then  
    dbms_output.put_line('**************************************************************************************************************');
    dbms_output.put_line('FNC_BEPAAL_HEDER_GEWICHT.HEADER-MAINPART: '||pl_header_part_no ||' revision: '||pl_header_revision||' alternative: '||pl_header_alternative||' show bom-items J/N: '||pl_show_incl_items_jn );
    dbms_output.put_line('**************************************************************************************************************');
  end if;
  --Indien parameter =SHOW-ITEMS=ja
  if UPPER(pl_show_incl_items_jn) in ('J')
  then
    BEGIN
      --dbms_output.put_line('l_mainpart'||';'||'l_mainrevision'||';'||'l_mainalternative'||';'||'l_mainbasequantity'||';'||'l_mainsumitemsquantity'||';'||'l_mainstatus'||';'||'l_mainframeid'||';'||'l_mainpartdescription'||';'||'l_mainpartbaseuom'||
      --                  ';'||'l_part_no'||';'||'l_item_header_base_quantity'||';'||'l_component_part'||';'||'l_componentdescription'||';'||'l_quantity'||';'||'l_uom'||';'||'l_quantity_kg'||';'||'l_path'||';'||'l_quantity_path'||';'||'l_bom_quantity_kg'||';'||'l_status'||';'||'l_characteristic_id'||';'||'l_functiecode' );      
      dbms_output.put_line('l_mainpart'||';'||'l_mainrevision'||';'||'l_mainplant'||';'||'l_mainalternative'||';'||'l_mainbasequantity'||';'||'l_mainsumitemsquantity'||';'||'l_mainstatus'||';'||'l_mainframeid'||';'||'l_mainpartdescription'||   --';'||'l_mainpartbaseuom'||
		          ';'||'l_part_no'||';'||'l_revision'||';'||'l_alternative'||';'||'l_item_header_base_quantity'||';'||'l_item_number'||';'||'l_component_part'||';'||'l_componentdescription'||';'||'l_quantity'||';'||'l_uom/org'||
							';'||'l_quantity_kg'||';'||'l_path'||';'||'l_quantity_path'||';'||'l_bom_quantity_kg'||';'||'l_status'||';'||'l_characteristic_id'||';'||'l_functiecode' );      
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
        ,      bi2.item_number
        ,      bi2.component_part
        ,      bi2.componentdescription
        ,      bi2.item_header_base_quantity
        ,      bi2.quantity
        ,      bi2.uom
        ,      bi2.uom_org
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
         ,      bh.preferred
         ,      bh.base_quantity
         ,      bh.min_qty
         ,      bh.max_qty
         ,      (select sum(case 
                            when b.uom = 'g' 
                            then (b.quantity/1000) 
                            when b.uom = 'kg'
                            then b.quantity
                            else 0 end) 
                 from bom_item b 
                 where b.part_no = bh.part_no 
                 and b.revision = bh.revision 
                 and b.alternative = bh.alternative)      sum_items_quantity
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
         --and    bh.preferred = 1         
         and    bh.alternative = pl_header_alternative  --default alternative bij preferred=1, maar kan ook expliciet preferred=0
         and    rownum = 1
        ) 
        select LEVEL   LVL
        ,      RPAD('.', (level-1)*2, '.') || LEVEL AS level_tree
        ,      bh.part_no             mainpart
        ,      bh.revision            mainrevision
        ,      bh.plant               mainplant
        ,      bh.alternative         mainalternative
        ,      bh.base_quantity       mainbasequantity
          ,      bh.min_qty             mainminqty
        ,      bh.max_qty             mainmaxqty
        ,      bh.sum_items_quantity  mainsumitemsquantity
        ,      bh.sort_desc           mainstatus
        ,      bh.frame_id            mainframeid
        ,      bh.description         mainpartdescription
        ,      bh.base_uom            mainpartbaseuom
        ,      b.part_no
        ,      b.revision
        ,      b.plant
        ,      b.alternative
        ,      b.item_number
        ,      b.component_part
        ,      (select pi.description from part pi where pi.part_no = b.component_part)  componentdescription
        ,      b.item_header_base_quantity
        ,      b.quantity
        ,      b.uom
        ,      b.uom   uom_org
        ,      b.quantity_kg
        ,      b.status
        ,      b.characteristic_id       --FUNCTIECODE
        ,      b.functiecode             --functiecode-descr
        ,      sys_connect_by_path( b.part_no||decode(b.characteristic_id,null,'','-'||b.characteristic_id) || ',' || b.component_part ,'|')  path
        ,      sys_connect_by_path( '('||b.quantity_kg||'/'||b.item_header_base_quantity||')', '*')  quantity_path
        FROM ( SELECT bi.part_no
             ,      bi.revision
             ,      bi.plant
             ,      bi.alternative
             ,      bi.item_number
             ,      bi.component_part
             --,      (select bh.base_quantity from bom_header bh where bh.part_no = bi.part_no and bh.revision = bi.revision and bh.alternative= bi.alternative )   item_header_base_quantity
             ,      h.base_quantity   item_header_base_quantity
             ,      bi.quantity
             ,      case when bi.uom in ('pcs','ST') or bi.uom like ('%m%') --m/m2/km    
                         then (--indien een material met uom=pcs dan weight uit property halen, en uom aanpassen naar "kg"
                              SELECT 'kg'
                              FROM specification_prop sp
                              WHERE sp.part_no        = bi.component_part   --'GR_9787'
                              AND NOT exists (select '' from bom_item bi3 where bi3.part_no = bi.component_part )  
                              --PS: gebruik component-item/header-spec-header-revision
                              --PS: gebruik component-item/spec-header-revision, MATERIALS hebben alleen SPECIFICATION-header, geen bom-header !!!
                              AND   sp.revision = (select max(sh1.revision) 
                                                   from status s1, specification_header sh1
                                                   where   sh1.part_no    = sp.part_no             --is component-part-no
                                                   and     sh1.status     = s1.status 
                                                   and     s1.status_type in ('CURRENT','HISTORIC')
                                                  )
                              AND   sp.section_id     = 700755 --  SAP information
                              --AND   sp.sub_section_id = 701502 -- A        --alle SAP-WEIGHT-properties meenemen in berekening
                              AND   sp.property_group = 0 -- (none)
                              AND   sp.property       = 703262 -- Weight
                              and   rownum = 1
                              UNION
                              --indien component-part met uom=pcs dan aantal meenemen in de berekening
                              select bi.uom
                              from dual
                              where exists (select '' from bom_item bi3 where bi3.part_no = bi.component_part )   --revision = header-revision, geen comp-revision, dus kunnen hier niet expliciet op checken...
                             )
                         else bi.uom 
                    end   uom
             ,      bi.uom     uom_org
             ,      case when bi.uom = 'g' 
                         then (bi.quantity/1000) 
                         when bi.uom = 'kg'
                         then bi.quantity
                         when bi.uom in ('pcs','ST') or bi.uom like ('%m%')    --m/m2/km
                         then (--indien een material met uom=pcs dan weight uit property halen
                              SELECT (sp.num_1 * bi.quantity)
                              FROM specification_prop sp
                              WHERE sp.part_no        = bi.component_part   --'GR_9787'
                              AND NOT exists (select '' from bom_item bi3 where bi3.part_no = bi.component_part ) 
                              --PS: gebruik component-item/spec-header-revision, MATERIALS hebben alleen SPECIFICATION-header, geen bom-header !!!
                              AND   sp.revision = (select max(sh1.revision) 
                                                   from status s1, specification_header sh1
                                                   where   sh1.part_no    = sp.part_no        --is component-part-no
                                                   and     sh1.status     = s1.status 
                                                   and     s1.status_type in ('CURRENT','HISTORIC')
                                                  )
                              AND   sp.section_id     = 700755 --  SAP information
                              --AND   sp.sub_section_id = 701502 -- A    --alle SAP-WEIGHT-properties meenemen in berekening
                              AND   sp.property_group = 0 -- (none)
                              AND   sp.property       = 703262 -- Weight
                              and   rownum = 1
                              UNION
                              --indien component-part met uom=pcs dan aantal meenemen in de berekening
                              select bi.quantity 
                              from dual
                              where exists (select '' from bom_item bi3 where bi3.part_no = bi.component_part )   --revision = header-revision, geen comp-revision, dus kunnen hier niet expliciet op checken...
                              )
                          else bi.quantity 
                    end   quantity_kg
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
             --zoek hoogste specification-revision waar nog een bom-header bij voorkomt
             and   h.revision   =  (select max(sh1.revision) 
                                    from status s1, specification_header sh1, bom_header h2 
                                    where   h2.part_no  = h.part_no 
                                    and    sh1.part_no  = h2.part_no 
                                    AND    sh1.revision = h2.revision 
                                    and    sh1.status   = s1.status 
                                    and    s1.status_type in ('CURRENT','HISTORIC')
                                   )
             --and   h.preferred    = 1
             and   h.preferred    = decode(h.part_no, pl_header_part_no, pl_header_preferred, 1)     --indien 1e Keer dan uitgaan van meegegeven alternative, verder weer uitgaan met preferred.
             and   h.alternative  = decode(h.part_no, pl_header_part_no, pl_header_alternative, h.alternative)
             and   h.alternative  = bi.alternative
             and   h.part_no      = sh.part_no
             and   h.revision     = sh.revision
             and   sh.status      = s.status  
             --and   s.status_type  = 'CURRENT' 
             and   bi.ch_1        = c.characteristic_id(+)
             ) b
        ,      sel_bom_header bh     
        START WITH b.part_no = bh.part_no 
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
                          ,l_item_number
                          ,l_component_part      
                          ,l_componentdescription              
                          ,l_item_header_base_quantity
                          ,l_quantity            
                          ,l_uom    
                          ,l_uom_org             
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
        --
        l_bom_quantity_kg := round(l_bom_quantity_kg, gc_afrond);
        --Wordt alleen getoond indien PL_SHOW_INCL_ITEMS_JN="J":
        --dbms_output.put_line('HEADER: '||l_mainpart||';'||l_mainrevision||';'||l_mainplant||';'||l_mainalternative||';'||l_mainbasequantity||';'||l_mainsumitemsquantity||';'||l_mainstatus||';'||l_mainframeid||';'||l_mainpartdescription||';'||l_mainpartbaseuom||
        --                  ';'||l_part_no||';'||l_item_header_base_quantity||';'||l_component_part||';'||l_componentdescription||';'||l_quantity||';'||l_uom||';'||l_quantity_kg ||';'||l_path||';'||l_quantity_path||';'||l_bom_quantity_kg||';'||l_status||';'||l_characteristic_id||';'||l_functiecode );
        dbms_output.put_line('HEADER: '||l_mainpart||';'||l_mainrevision||';'||l_mainplant||';'||l_mainalternative||';'||l_mainbasequantity||';'||l_mainsumitemsquantity||';'||l_mainstatus||';'||l_mainframeid||
                   --';'||l_mainpartdescription||';'||l_mainpartbaseuom||
                   ';'||L_level_tree||
                   ';'||l_part_no||';'||l_revision||';'||l_alternative||';'||l_item_header_base_quantity||';'||l_item_number||';'||l_component_part||';'||l_componentdescription||';'||l_quantity||';'||l_uom||'/'||l_uom_org||
                   ';'||l_quantity_kg ||';'||l_path||';'||l_quantity_path||';'||l_bom_quantity_kg||';'||l_status||';'||l_characteristic_id||';'||l_functiecode );
        --
        --exit;    
      end loop;
      close c_bom_items;  
    --
  EXCEPTION
    WHEN OTHERS 
    THEN if sqlerrm not like '%ORA-01001%' 
           THEN dbms_output.put_line('FNC-BEPAAL-HEADER-GEWICHT: ALG-EXCP BOM-ITEMS: '||SQLERRM); 
           else null;   
           end if;
  END;
  --
  end if;   --show-items = J
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
    open c_bom for 
    select mainpart
    ,      sum(decode(uom,'kg',quantity_kg,0))      gewicht
    ,      sum(decode(uom,'kg',bom_quantity_kg,0))  header_bom_gewicht_som_items
    --,      sum(decode(uom,'pcs',0,quantity_kg))      gewicht
    --,      sum(decode(uom,'pcs',0,bom_quantity_kg))  header_bom_gewicht_som_items
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
      ,      bi2.item_number
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
         ,      bh.preferred
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
         --and    bh.preferred = 1         
         and    bh.alternative = pl_header_alternative  --default alternative bij preferred=1, maar kan ook expliciet preferred=0
         and    rownum = 1
        ) 
        select LEVEL   LVL
        ,      RPAD('.', (level-1)*2, '.') || LEVEL AS level_tree
        ,      bh.part_no       mainpart
        ,      bh.revision      mainrevision
        ,      bh.alternative   mainalternative
        ,      bh.base_quantity mainbasequantity
        ,      b.part_no
        ,      b.revision
        ,      b.plant
        ,      b.alternative
        ,      b.item_number
        ,      b.characteristic_id
        ,      b.item_header_base_quantity
        ,      b.component_part
        ,      b.quantity
        ,      b.uom
        ,      b.quantity_kg
        ,      sys_connect_by_path( b.part_no || ',' || b.component_part ,'|')  path
        ,      sys_connect_by_path( '('||b.quantity_kg||'/'||b.item_header_base_quantity||')', '*')  quantity_path
        FROM ( SELECT bi.part_no
             , bi.revision
             , bi.plant
             , bi.alternative
             , bi.item_number
             , bi.ch_1           characteristic_id
             --, (select bh.base_quantity from bom_header bh where bh.part_no = bi.part_no and bh.revision = bi.revision and bh.alternative=1) item_header_base_quantity
             , h.base_quantity   item_header_base_quantity
             , bi.component_part
             , bi.quantity
             , case when bi.uom in ('pcs','ST') or bi.uom like ('%m%') --m/m2/km
                    then (--indien een material met uom=pcs dan weight uit property halen, en uom aanpassen naar "kg"
                         SELECT 'kg'
                         FROM specification_prop sp
                         WHERE sp.part_no        = bi.component_part   --'GR_9787'
                         AND NOT exists (select '' from bom_item bi3 where bi3.part_no = bi.component_part ) 
                         --PS: gebruik component-item/header-spec-header-revision
                         --PS: gebruik component-item/spec-header-revision, MATERIALS hebben alleen SPECIFICATION-header, geen bom-header !!!
                         AND   sp.revision = (select max(sh1.revision) 
                                              from status s1, specification_header sh1
                                              where   sh1.part_no    = sp.part_no           --is component-part-no
                                              and     sh1.status     = s1.status 
                                              and     s1.status_type in ('CURRENT','HISTORIC')
                                             )
                         AND   sp.section_id     = 700755 --  SAP information
                         --AND   sp.sub_section_id = 701502 -- A     --alle SAP-WEIGHT-properties meenemen in berekening
                         AND   sp.property_group = 0 -- (none)
                         AND   sp.property       = 703262 -- Weight
                         and   rownum = 1
                         UNION
                         --indien component-part met uom=pcs dan aantal meenemen in de berekening
                         select bi.uom
                         from dual
                         where exists (select '' from bom_item bi3 where bi3.part_no = bi.component_part )   --revision = header-revision, geen comp-revision, dus kunnen hier niet expliciet op checken...
                         )
                     else bi.uom 
               end   uom
               --, bi.uom 
             , case when bi.uom = 'g' 
                    then (bi.quantity/1000) 
                    when bi.uom = 'kg'
                    then bi.quantity
                    when bi.uom in ('pcs','ST') or bi.uom like ('%m%')   --m/m2/km
                    then (SELECT (sp.num_1 * bi.quantity)
                          FROM specification_prop sp
                          WHERE sp.part_no        = bi.component_part   --'GR_9787'
                          AND NOT exists (select '' from bom_item bi3 where bi3.part_no = bi.component_part ) 
                          --PS: gebruik component-item/header-spec-header-revision
                          --PS: gebruik component-item/spec-header-revision, MATERIALS hebben alleen SPECIFICATION-header, geen bom-header !!!
                          AND   sp.revision = (select max(sh1.revision) 
                                               from status s1, specification_header sh1
                                               where   sh1.part_no    = sp.part_no        --is component-part-no
                                               and     sh1.status     = s1.status 
                                               and     s1.status_type in ('CURRENT','HISTORIC')
                                              )
                          AND   sp.section_id     = 700755 -- SAP information
                          --AND   sp.sub_section_id = 701502 -- A       --alle SAP-WEIGHT-properties meenemen in berekening
                          AND   sp.property_group = 0      -- (none)
                          AND   sp.property       = 703262 -- Weight
                          and   rownum = 1
                          UNION
                          --indien component-part met uom=pcs dan aantal meenemen in de berekening
                          select bi.quantity 
                          from dual
                          where exists (select '' from bom_item bi3 where bi3.part_no = bi.component_part )   --revision = header-revision, geen comp-revision, dus kunnen hier niet expliciet op checken...
                           )
                        else bi.quantity 
                   end   quantity_kg
             FROM status               s
             ,    specification_header sh
             ,    bom_header           h
             ,    characteristic       c
             ,    bom_item             bi   
             WHERE h.part_no      = bi.part_no
             and   h.revision     = bi.revision
             --PS: zoek hoogste spec-header-revision waar nog bom-header-revision van bestaat...
             and   h.revision    = (select max(sh1.revision) 
                                    from status s1, specification_header sh1, bom_header h2 
                                    where h2.part_no   = h.part_no 
                                    and   sh1.part_no  = h2.part_no 
                                    AND   sh1.revision = h2.revision 
                                    and   sh1.status   = s1.status 
                                    and   s1.status_type in ('CURRENT','HISTORIC')
                                   )
             --and   bi.revision   = (select max(sh1.revision) from status s1, specification_header sh1 where sh1.part_no = bi.part_no and sh1.status = s1.status and s1.status_type in ('CURRENT','HISTORIC'))
             --and   h.preferred    = 1
						 and   h.preferred    = decode(h.part_no, pl_header_part_no, pl_header_preferred, 1)     --indien 1e Keer dan uitgaan van meegegeven alternative, verder weer uitgaan met preferred.
						 and   h.alternative  = decode(h.part_no, pl_header_part_no, pl_header_alternative, h.alternative)
						 and   h.alternative  = bi.alternative
             and   bi.part_no     = sh.part_no
             and   bi.revision    = sh.revision
						 and   sh.status      = s.status	
						 --and   s.status_type  = 'CURRENT'    						 --Er komt maar 1x CRRNT voor, de rest is HISTORIC/DEV	
						 and   bi.ch_1        = c.characteristic_id(+)
					   ) b
				,      sel_bom_header bh	   
				START WITH b.part_no = bh.part_no 
				CONNECT BY NOCYCLE PRIOR b.component_part = b.part_no --and b.component_revision = b.revision
				order siblings by part_no
				)  bi2
            --select alleen gewicht van materialen... 
			where bi2.component_part NOT IN (select bi3.part_no from bom_item bi3 where bi3.part_no = bi2.component_part)
			)
		group by mainpart
		;
    loop 
      BEGIN
        fetch c_bom into l_header_mainpart, l_header_gewicht, l_header_bom_gewicht_som_items;
        if (c_bom%notfound)   
        then CLOSE C_BOM;
             exit;
        end if;
        --
        l_header_gewicht               := round(l_header_gewicht, gc_afrond);
        l_header_bom_gewicht_som_items := round(l_header_bom_gewicht_som_items, gc_afrond);
        --
        if upper(pl_show_incl_items_jn) = 'J'
        then 
          dbms_output.put_line('**************************************************************************************************************');
          dbms_output.put_line('TOTAALGEWICHT VAN ITEM;'||pl_header_part_no||';revision;'||pl_header_revision||';base-gewicht;'||l_header_gewicht||';header-gewicht-bom-items;'||l_header_bom_gewicht_som_items );
          dbms_output.put_line('**************************************************************************************************************');
          --else
          --  dbms_output.put_line('TOTAALGEWICHT VAN ITEM;'||pl_header_part_no||';base-gewicht;'||l_header_gewicht||';header-gewicht-bom-items;'||l_header_bom_gewicht_som_items );
	      end if;
      EXCEPTION
        WHEN OTHERS 
        THEN 
          if c_bom%isopen
          then close c_bom;  
          end if;
          if sqlerrm not like '%ORA-01001%' 
          THEN dbms_output.put_line('ALG-TOTAL-LOOP-EXCP FNC-BEPAAL-HEADER-GEWICHT-SUM '||pl_header_part_no||'.'||pl_header_revision||'-'||pl_header_alternative||': '||SQLERRM); 
          else null; 
      	  end if;
      END;        
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
      THEN dbms_output.put_line('ALG-EXCP FNC-BEPAAL-HEADER-GEWICHT-TOTAL '||pl_header_part_no||'.'||pl_header_revision||'-'||pl_header_alternative||': '||SQLERRM); 
      else null; 
	  end if;
  END;
  --
  --DBMS_OUTPUT.put_line('voor return: '||l_header_bom_gewicht_som_items);
  RETURN l_header_bom_gewicht_som_items;
  --
END dba_fnc_bepaal_header_gewicht;
--
procedure BEPAAL_MV_COMP_PART_GEWICHT (p_header_part_no        varchar2 
                                      ,p_header_revision       varchar2 default null
                                      ,p_alternative           number   default null
                                      ,p_show_incl_items_jn    varchar2 default 'N'
                                      ,p_insert_weight_comp_jn varchar2 default 'N'														 
										      			   	 )
DETERMINISTIC
AS
--Script om voor ALLE COMPONENT-PART (niet zijnde material/grondstof in kg) in de BOM van een 
--bom-header/component het gewicht te berekenen obv data uit MV = mv_bom_item_comp_header
--DMV de procedure FNC_BEPAAL_MV_HEADER_GEWICHT !!!
--
--Aangeroepen vanuit:  AANROEP_VUL_INIT_PART_GEWICHT
--Roept aan:           FNC_BEPAAL_MV_HEADER_GEWICHT (voor iedere component uit BOM-TREE van TYRE)
--
--Door deze procedure per COMPONENT-PART aan te roepen berekenen we voor eigenlijk alle BOM-HEADERS
--het gewicht van 1 x EENHEID van deze BOM-HEADER (dus los van base-quantity waarmee deze header
--onderdeel uitmaakt van een BAND/TYRE.
--
--ALLE COMPONENTEN die in BOM-TREE van 1x TYRE/HEADER voorkomen worden met ZELFDE TECH_CALCULATION_DATE in 
--de tabel DBA_WEIGHT_COMPONENT_PART weggeschreven !!! 
--
--SELECTIE ZIT HIERBIJ  OP ALLE BOM-ITEMS (=EXCL. de BOM-ITEMS WAARBIJ COMPONENT-PART = MATERIALEN/GRONDSTOFFEN) 
--WAARBIJ PER COMPONENT-PART HET EENHEID-GEWICHT WORDT BEREKEND. 
--Dit betekent dan ook dat voor de BAND zelf het gewicht niet berekend kan worden met deze procedure
--aangezien een band zelf niet als COMPONENT-PART in de BOM-ITEM-tabel voorkomt. 
--Het is wel zo dat je deze procedure wel weer met een BAND/TYRE-PART-NO aanroept !!!!
--Onderhuids wordt dan voor iedere BOM-HEADER het gewicht berekend.
--
--Het kan wel voorkomen dat een PART-NO meerdere keren in de BOM van een BAND voorkomt,
--in dat geval wordt alsnog voor ieder voorkomen het gewicht berekend.
--
--LET OP: Procedure werkt alleen nog maar voor ALTERNATIVE=1 items !!!. Dus als er op een lager
--        niveau bom-items voorkomen met ALTERNATIVE=2 dan worden deze NIET meegenomen in de berekening.
--        (het is ook nog de vraag wat we met deze gewichten moeten doen? Later evt. uitbreiden...)
--
--Resultaten worden weggeschreven naar een hulptabel die gebruikt wordt voor SAP-INTERFACE !!!!!
--
--Parameters:  P_HEADER_PART_NO = bom-item-header, bijv.  EF_H215/65R15QT5	("CRRNT QR5", A_PCR)
--                                                        EF_Q165/80R15SCS	("CRRNT QR5", A_PCR)
--                                                        EF_S640/95R13CLS	("CRRNT QR5", A_PCR)
--             P_HEADER_REVISION = bom-item-header-revision-number van CURRENT/HISTORIC header.
--                                 Indien een TYRE zal status altijd CURRENT zijn. 
--                                 Een component kan zelf al HISTORIC zijn maar zolang hij in BOM-ITEM zit moet hij wel worden meegenomen.
--             P_ALTERNATIVE = indicator die aangeeft om welk alternatief het gaat. 
--                             1=default, per eenheid
--                             2=batch, voor bulk
--             P_SHOW_INCL_ITEMS_JN = J = dbms-output van TREE component-parts vanuit comp-part-gewicht (en niet gewichten uit header-gewicht)
--                                    U = dbms-output vanuit comp-part-gewicht + header-gewicht !!
--                                    N = ALLEEN output weggeschreven naar DBA_WEIGHT_COMPONENT_PART !!!
--             P_INSERT_WEIGHT_COMP_JN = J = INSERT van alle component-parts (resultaat van DBA_BEPAAL_BOM_HEADER_GEWICHT) in DBA_WEIGHT_COMPONENT_PART.
--                                           Indien aangeroepen vanuit DBA_AANROEP_BEPAAL_COMP_PART_GEWICHT dan ALTIJD INSERTEN van resultaten in VERWERKINGSTABEL !!!!!
--                                       N = geen output weggeschreven naar DBA_WEIGHT_COMPONENT_PART, alleen testing/logging !!! 
--                                           Indien direct aangeroepen voor test-doeleinden, dan resultaat niet altijd wegschrijven naar VERWERKING-TABEL !
-------------------------------------------------------------------------------------------------------------------------------------
--How is the WEIGHT of TYRE/COMPONENT calculated?
--bom_quantity_kg		   =   CONCAT ( * bom_item.quantity / bom_header.base_quantity )   = Weight-factor from a SPECIFIC-component within a TYRE
--comp_part_eenheid_kg     =   DBA_FNC_BEPAAL_HEADER_GEWICHT(p_header_part_no=>l_part_no)  = Total WEIGHT of one-UNIT of a COMPONENT (is for all tyres the same)
--tyre_component_weight_kg =   BOM_QUANTITY_KG * COMP_PART_EENHEID_KG                      = WEIGHT of a COMPONENT within a specific TYRE.
--
--*************************************************************************************************************************
--REVISION DATE        WHO	DESCRIPTION
--      01 03-04-2023  PS   Copy van procedure DBA_BEPAAL_COMP_PART_GEWICHT maar dan gebasserd op MV = MV_BOM_ITEM_COMP_HEADER !!!
--      02 22-05-2023  PS   Selectie van header-issueddate in cursor omzetten naar CHAR, anders vind fetch van date in varchar plaats, waardoor we eeuu kwijtraken.
--*************************************************************************************************************************
--                          
pl_header_part_no           varchar2(100)   := p_header_part_no;
pl_header_revision          number          := p_header_revision;
pl_alternative              number(2)       := p_alternative;
pl_show_incl_items_jn       varchar2(1)     := UPPER(p_show_incl_items_jn);
pl_show_incl_header_jn      varchar2(1)     := UPPER(p_show_incl_items_jn);      --Indien pl_show_incl_items_jn=U dan krijgt deze waarde=J, anders N.
pl_insert_weight_comp_jn    varchar2(1)     := UPPER(p_insert_weight_comp_jn);
--
c_bom_items                sys_refcursor;
l_tech_calculation_date    date;    --datum waarmee alle components voor 1 BAND/HEADER in hulptabel DBA_WEIGHT_COMP_PART komen!!
l_datum_verwerking         date;    --datum die overeenkomt met datum_verwerking_vanaf als IDENTIFICATIE van een VERWERKINGSRUN/VUL-INIT uit de STUURTABEL
l_remark                   varchar2(100) := 'PRC: BEPAAL_COMP_PART_GEWICHT';
--
l_LVL                      varchar2(100);  
l_level_tree               varchar2(4000);
l_rownum                   number;
--
l_mainpart                 varchar2(100);
l_mainrevision             number;
l_mainplant                varchar2(100);
l_mainalternative          number;
l_mainbasequantity         number;
l_mainminqty               number;
l_mainmaxqty               number;
l_mainsumitemsquantity     number;
l_mainstatus               varchar2(100);
l_mainframeid              varchar2(100);
l_mainpartdescription      varchar2(1000);
l_mainpartbaseuom          varchar2(100);
l_sap_article_code         varchar2(40);
l_sap_da_article_code      varchar2(40);
--
l_part_no                  varchar2(100);
l_revision                 NUMBER;
l_plant                    varchar2(100);
l_alternative              number(2);
l_characteristic_id        number;
l_item_header_base_quantity number;
l_component_part           varchar2(100);
l_quantity                 number;
l_uom                      varchar2(100);
l_quantity_kg              number;
l_status                   varchar2(30);
l_functiecode              varchar2(1000);
l_header_issued_date       varchar2(30);
l_header_status            varchar2(30);
l_item_number              number(4,0);
l_componentdescription     varchar2(1000);
l_componentrevision        number;
l_componentalternative     number;
l_componentissueddate      varchar2(30);
l_componentstatus          varchar2(30);
l_path                     varchar2(4000);
l_quantity_path            varchar2(4000);
l_bom_quantity_kg         varchar2(100);
--
l_part_eenheid_kg            number;    --gewicht van BOM-HEADER=TYRE zelf.
l_component_part_eenheid_kg  number;    --gewicht van 1xEENHEID component-part obv volledige TREE aan BOM-ITEMS !!
--
c_bom                      sys_refcursor;
l_header_mainpart          varchar2(100);
l_header_gewicht           varchar2(100);
l_header_gewicht_som_items varchar2(100);
--
cursor c_partno_sap_code (p_part_no  varchar2)
is
SELECT sp1.char_1        sap_article_code
,      sp2.char_1        sap_da_article_code
FROM property              p1
,    specification_prop   sp1                              
,    property              p2
,    specification_prop   sp2                              
,    specification_header sh
WHERE sh.part_no   = p_part_no    --'EF_710/60R42TRO176'
and   sp1.property = p1.property
and   sp2.property = p2.property
AND   sh.revision  = (select max(sh1.revision)                               
                      from status s1, specification_header sh1                              
                      where   sh1.part_no    = sp1.part_no             --is component-part-no                              
                      and     sh1.status     = s1.status                               
                      and     s1.status_type in ('CURRENT','HISTORIC')                              
                     ) 
AND  sh.part_no  = sp1.part_no
AND  sh.part_no  = sp2.part_no
And  sh.revision = sp1.revision
And  sh.revision = sp2.revision
AND   sp1.section_id     = 700755 --  SAP information                              
and   sp1.property_group = 704056 --  SAP articlecode
and   sp1.property       = 713824 --  Commercial article code
AND   sp2.section_id     = 700755 --  SAP information                              
and   sp2.property_group = 704056 --  SAP articlecode
and   sp2.property       = 713825 --  Commercial DA article code	  
;

function get_verwerking_datum 
return date
IS
l_max_sbw  date;
begin
  --vanuit verwerking-vul-init-part-gewicht is reeds nieuw besturing-record aangemaakt met juist VANAF-datum !!
  --Deze datum nemen we over. 
  --We verwerken alle TYRES per FRAME-ID. Alleen het besturing-record zonder TM-datum hoort bij huidige FRAME-ID !!
  --(om die reden geen extra controle op juiste frame-id).
  --LETOP: als we een achterstand in moeten halen van een paar dagen, kan het zijn dat VANAF-datum dus ook 
  --       een paar dagen in het verleden ligt...
  select max(sbw.sbw_datum_verwerkt_vanaf) 
  into l_max_sbw
  from dba_sync_besturing_weight_sap   sbw
  where sbw.sbw_datum_verwerkt_tm is null
  ;
  return l_max_sbw;
  --
exception
  when no_data_found
  then return to_date(null);  
end get_verwerking_datum;
--
function p_part_exists (p_part_no          varchar2
                       ,p_revision         number 
                       ,p_datum_verwerking date   )
return boolean
IS
l_aantal  number;
begin
  l_aantal := 0;
  --dbms_output.put_line('START part: '||p_component_part_no||' revision: '||p_componentrevision||' aantal: '||l_aantal);
  select count(*) 
  into l_aantal
  from dba_weight_component_part dwc 
  where dwc.mainpart         = p_part_no
  and   dwc.part_no          = p_part_no
  and   dwc.revision         = p_revision
  and   dwc.datum_verwerking >= p_datum_verwerking
  --kan zijn dat er voor de direct gerelateerde components al record is weggeschreven. deze bevatten gewicht van component en niet van tyre zelf.
  --vandaar extra check op lege component-part 
  and   dwc.component_part_no   is null        
  and   dwc.component_revision  is null
  and   dwc.comp_part_eenheid_kg > 0
  and   dwc.tech_calculation_date >= trunc(sysdate)
  ;
  --dbms_output.put_line('RESULT part: '||p_component_part_no||' revision: '||p_componentrevision||' aantal: '||l_aantal);
  if nvl(l_aantal,0) > 0
  then return TRUE;
  else return FALSE;
  end if;
exception
  when no_data_found
  then return FALSE;  
end p_part_exists;
--
function p_component_exists (p_component_part_no  varchar2
                            ,p_componentrevision  number 
                            ,p_datum_verwerking   date  )
return boolean
IS
--Procedure om te kijken of component-part binnen zelfde RUN al een keer berekend is.
--Berekening van een component-weight is altijd hetzelde, ongeacht of deze onder een
--ander part-no, of zelfs dubbel (met ander item_number) bij eenzelfde part-no voorkomt.
l_aantal  number;
begin
  l_aantal := 0;
  --dbms_output.put_line('START part: '||p_component_part_no||' revision: '||p_componentrevision||' aantal: '||l_aantal);
  select count(*) 
  into l_aantal
  from dba_weight_component_part dwc 
  where dwc.component_part_no  = p_component_part_no
  and   dwc.component_revision = p_componentrevision
  and   dwc.datum_verwerking >= p_datum_verwerking
  and   dwc.comp_part_eenheid_kg > 0
  and   dwc.tech_calculation_date >= trunc(sysdate)
  ;
  --dbms_output.put_line('RESULT part: '||p_component_part_no||' revision: '||p_componentrevision||' aantal: '||l_aantal);
  if nvl(l_aantal,0) > 0
  then return TRUE;
  else return FALSE;
  end if;
exception
  when no_data_found
  then return FALSE;  
end p_component_exists;
--							
BEGIN
  dbms_output.enable(1000000);
  --init
  l_tech_calculation_date := sysdate;
  --Indien gestart mbv VUL-INIT of VERWERKING-MUTATIES dan is stuurtabel gevuld en gebruiken we de VERWERKING_VANAF-datum
  l_datum_verwerking      := get_verwerking_datum;   
  if  l_datum_verwerking is null
  then l_datum_verwerking := l_tech_calculation_date;
  end if;
  --
  if pl_show_incl_items_jn = 'U'
  then pl_show_incl_header_jn := 'J';
  else pl_show_incl_header_jn := 'N';
  end if;
  --
  if pl_header_revision is null
  then
	  --indien er geen revision is meegegeven dan alsnog eerst zelf ophalen
	  --PS: haal max(spec-revision) op waarvoor nog een bom-header-revision bestaat...
    begin
      select max(sh1.revision) 
	    into pl_header_revision
	    from status               s1
	    ,    specification_header sh1 
	    ,    bom_header           bh
	    where bh.part_no   = pl_header_part_no 
	    and   sh1.part_no  = bh.part_no 
	    and   sh1.revision = bh.revision
	    and   sh1.status   = s1.status 
	    and   s1.status_type in ('CURRENT','HISTORIC')
	    ;
	  exception
	    when others 
	    then dbms_output.put_line('REVISION-EXCP: Revision kon niet bepaald worden voor partno: '||pl_header_part_no);
    end;
  end if;
  --
  if upper(pl_show_incl_items_jn) IN ('J','U')
  then 
    dbms_output.put_line('**************************************************************************************************************');
    dbms_output.put_line('COMP-PART-GEWICHT-MAINPART: '||pl_header_part_no  );
    dbms_output.put_line('**************************************************************************************************************');
  end if;	
  --
  begin
	  --
	  if upper(pl_show_incl_items_jn) IN ('J','U')
    then 
      dbms_output.put_line('l_LVL'||';'||'l_mainpart'||';'||'l_mainrevision'||';'||'l_mainplant'||';'||'l_mainalternative'||';'||'l_mainframeid'||
	                   ';'||'l_part_no'||';'||'l_revision'||';'||'l_plant'||';'||'l_alternative'||';'||'l_header_issued_date'||';'||'l_header_status'||
							';'||'l_component_part'||';'||'l_componentdescription'||';'||'l_componentrevision'||';'||'l_componentalternative'||';'||'l_componentissueddate'||';'||'l_componentstatus'||
							';'||'l_characteristic_id'||';'||'l_functiecode'||';'||'l_path'||';'||'l_quantity_path'||';'||'l_bom_quantity_kg' );      
    end if;							
	  --Tonen van base/eenheid-gewicht van BOM-HEADER/component:
    open c_bom_items for SELECT bi2.LVL
				,      bi2.level_tree
				,      rownum
				,      bi2.mainpart
				,      bi2.mainrevision
				,      bi2.mainplant
				,      bi2.mainalternative
				,      bi2.mainframeid
				,      bi2.part_no
				,      bi2.revision
				,      bi2.plant
				,      bi2.alternative
				,      bi2.headerissueddate
				,      bi2.headerstatus
        ,      bi2.item_number
				,      bi2.component_part
				,      bi2.componentdescription
				,      bi2.componentrevision
				,      bi2.componentalternative
				,      bi2.componentissueddate
				,      bi2.componentstatus
				,      bi2.characteristic_id 
				,      bi2.functiecode
				,      bi2.path
				,      bi2.quantity_path
				,      DBA_BEPAAL_QUANTITY_KG(bi2.quantity_path)  bom_quantity_kg
				from
				(
				with sel_bom_header as 
			  (select DISTINCT bih.part_no
		     ,      bih.revision
			   ,      bih.plant
			   ,      bih.alternative
			   ,      bih.preferred
			   ,      bih.base_quantity
			   ,      bih.status     			--pas later de sort-desc erbijhalen...
			   ,      bih.frame_id
         from  mv_bom_item_comp_header bih
         where  bih.part_no     = pl_header_part_no  --'EM_764' --'EG_H620/50R22-154G'  --l_header_part_no
			   and    bih.revision    = pl_header_revision --(select max(sh1.revision) from status s1, specification_header sh1 where sh1.part_no = bh.part_no and sh1.status = s1.status and s1.status_type in ('CURRENT','HISTORIC'))
			   --and    bih.alternative = pl_header_alternative  --default alternative bij preferred=1, maar kan ook expliciet preferred=0
			   AND    bih.preferred   = 1
				) 
				select LEVEL   LVL
        ,      RPAD('.', (level-1)*2, '.') || LEVEL AS level_tree
        ,      bh.part_no             mainpart
        ,      bh.revision            mainrevision
        ,      bh.plant               mainplant
        ,      bh.alternative         mainalternative
	    	,      bh.preferred           mainpreferred
        ,      bh.base_quantity       mainbasequantity
        ,      (select s.sort_desc from status s where s.status = bh.status )     mainstatus
        ,      bh.frame_id            mainframeid
        ,      (select pi.description from part pi where pi.part_no = bh.part_no)  mainpartdescription
        ,      (select pi.base_uom    from part pi where pi.part_no = bh.part_no)  mainpartbaseuom
        ,      b.part_no
        ,      b.revision
        ,      b.plant
        ,      b.alternative
		    ,      b.preferred
		    ,      TO_CHAR(b.issued_date,'DD-MM-YYYY HH24:MI:SS')                   headerissueddate
	    	,      (select s.sort_desc from status s where s.status = b.status)     headerstatus
        ,      b.item_number
        ,      b.component_part
        ,      (select pi.description from part pi where pi.part_no = b.component_part)  componentdescription
	    	,      b.comp_revision              componentrevision
		    ,      b.comp_alternative           componentalternative
	    	,      b.comp_issued_date           componentissueddate
		    ,      b.comp_preferred
        ,      (select s.sort_desc from status s where s.status = b.comp_status)  componentstatus
        ,      b.item_header_base_quantity
        ,      b.quantity
        ,      b.uom
        ,      b.quantity_kg
        ,      b.characteristic_id       --FUNCTIECODE
        ,      b.functiecode             --functiecode-descr
        ,      sys_connect_by_path( b.part_no||decode(b.characteristic_id,null,'','-'||b.characteristic_id) || ',' || b.component_part ,'|')  path
        ,      sys_connect_by_path( '('||b.quantity_kg||'/'||b.item_header_base_quantity||')', '*')  quantity_path
        FROM ( SELECT bi.part_no
             ,      bi.revision
             ,      bi.plant
             ,      bi.alternative
			       ,      bi.preferred
			       ,      bi.issued_date
			       ,      bi.status
             ,      bi.item_number
             ,      bi.component_part
			       ,      bi.comp_revision
			       ,      bi.comp_alternative
             ,      bi.comp_issued_date
			       ,      bi.comp_preferred
		       	 ,      bi.comp_status
             ,      bi.base_quantity   item_header_base_quantity
             ,      bi.quantity
             ,      case when bi.uom in ('pcs','ST') or bi.uom like ('%m%') --m/m2/km    
                         then (--indien een material met uom=pcs dan weight uit property halen, en uom aanpassen naar "kg"
                              SELECT 'kg'
                              FROM specification_prop sp
                              WHERE sp.part_no        = bi.component_part   --'GR_9787'
                              AND NOT exists (select '' from bom_item bi3 where bi3.part_no = bi.component_part )  
                              --PS: gebruik component-item/header-spec-header-revision
                              --PS: gebruik component-item/spec-header-revision, MATERIALS hebben alleen SPECIFICATION-header, geen bom-header !!!
                              AND   sp.revision = (select max(sh1.revision) 
                                                   from status s1, specification_header sh1
                                                   where   sh1.part_no    = sp.part_no             --is component-part-no
                                                   and     sh1.status     = s1.status 
                                                   and     s1.status_type in ('CURRENT','HISTORIC')
                                                  )
                              AND   sp.section_id     = 700755 --  SAP information
                              --AND   sp.sub_section_id = 701502 -- A        --alle SAP-WEIGHT-properties meenemen in berekening
                              AND   sp.property_group = 0 -- (none)
                              AND   sp.property       = 703262 -- Weight
                              and   rownum = 1
                              UNION
                              --indien component-part met uom=pcs dan aantal meenemen in de berekening
                              select bi.uom
                              from dual
                              where exists (select '' from bom_item bi3 where bi3.part_no = bi.component_part )   --revision = header-revision, geen comp-revision, dus kunnen hier niet expliciet op checken...
                             )
                         else bi.uom 
                    end   uom
             ,      case when bi.uom = 'g' 
                         then (bi.quantity/1000) 
                         when bi.uom = 'kg'
                         then bi.quantity
                         when bi.uom in ('pcs','ST') or bi.uom like ('%m%')    --m/m2/km
                         then (--indien een material met uom=pcs dan weight uit property halen
                              SELECT (sp.num_1 * bi.quantity)
                              FROM specification_prop sp
                              WHERE sp.part_no        = bi.component_part   --'GR_9787'
                              AND NOT exists (select '' from bom_item bi3 where bi3.part_no = bi.component_part ) 
                              --PS: gebruik component-item/spec-header-revision, MATERIALS hebben alleen SPECIFICATION-header, geen bom-header !!!
                              AND   sp.revision = (select max(sh1.revision) 
                                                   from status s1, specification_header sh1
                                                   where   sh1.part_no    = sp.part_no        --is component-part-no
                                                   and     sh1.status     = s1.status 
                                                   and     s1.status_type in ('CURRENT','HISTORIC')
                                                  )
                              AND   sp.section_id     = 700755 --  SAP information
                              --AND   sp.sub_section_id = 701502 -- A    --alle SAP-WEIGHT-properties meenemen in berekening
                              AND   sp.property_group = 0 -- (none)
                              AND   sp.property       = 703262 -- Weight
                              and   rownum = 1
                              UNION
                              --indien component-part met uom=pcs dan aantal meenemen in de berekening
                              select bi.quantity 
                              from dual
                              where exists (select '' from bom_item bi3 where bi3.part_no = bi.component_part )   --revision = header-revision, geen comp-revision, dus kunnen hier niet expliciet op checken...
                              )
                          else bi.quantity 
                    end   quantity_kg
             ,      bi.characteristic  characteristic_id       
             ,      (select c.description from characteristic c where c.characteristic_id = bi.characteristic)  functiecode
             FROM  mv_bom_item_comp_header bi
             WHERE (   bi.preferred = 1 
			             and bi.comp_preferred IN (1, -1) 
                   )
            ) b
				,      sel_bom_header bh	   
				START WITH b.part_no = bh.part_no and b.preferred = bh.preferred
        CONNECT BY NOCYCLE PRIOR b.component_part   = b.part_no 
							        and  prior b.comp_revision    = b.revision
							        and  prior b.comp_alternative = b.alternative
							        and  prior b.comp_preferred   = 1
				order siblings by b.part_no
				)  bi2
        where bi2.component_part IN (select bi3.part_no from bom_item bi3 where bi3.part_no = bi2.component_part)   --NU itt DBA_BEPAAL_BOM_HEADER_GEWICHT: NIET de selectie voor material-codes, DIE gaan we niet de gewichten berekenen...
		 	;
    loop
      --init 
      l_sap_article_code    := null;
      l_sap_da_article_code := null;
      --
      fetch c_bom_items into l_LVL
                          ,l_level_tree
                          ,l_rownum
		                      ,l_mainpart  
                          ,l_mainrevision
						              ,l_mainplant
                          ,l_mainalternative
	            					  ,l_mainframeid
                  			  ,l_part_no 
                          ,l_revision
                          ,l_plant   
                          ,l_alternative
                          ,l_header_issued_date 
                          ,l_header_status
                          ,l_item_number
                          ,l_component_part      
                          ,l_componentdescription	
            						  ,l_componentrevision
					 	              ,l_componentalternative
            						  ,l_componentissueddate
						              ,l_componentstatus
                				  ,l_characteristic_id
                          ,l_functiecode
                          --,l_item_header_base_quantity
                          --,l_quantity            
                          --,l_uom                 
                          --,l_quantity_kg     
             						  ,l_path
            						  ,l_quantity_path
            						  ,l_bom_quantity_kg
            						  ;
      if (c_bom_items%notfound)   
      then CLOSE C_BOM_ITEMS;
	         exit;
	    end if;
      if upper(pl_show_incl_items_jn) in ('J','U')
      then 
        dbms_output.put_line('**************************************************************************************************************');
        dbms_output.put_line(l_LVL||';'||l_mainpart||';'||l_mainrevision||';'||l_mainplant||';'||l_mainalternative||';'||l_mainframeid||
		                  ';'||l_part_no||';'||l_revision||';'||l_plant||';'||l_alternative||';'||l_header_issued_date||';'||l_header_status||
					';'||l_component_part||';'||l_componentdescription||';'||l_componentrevision||';'||l_componentalternative||';'||l_componentissueddate||';'||l_componentstatus||
					';'||l_characteristic_id||';'||l_functiecode||';'||l_path||';'||l_quantity_path||';'||l_bom_quantity_kg );      
      end if;							
		  --
		  --INDIEN PART-NO = TYRE (MAINPART=PART-NO) DAN BEREKENEN WE GEWICHT VAN DE TYRE OOK NOG EVEN APART
		  --OMDAT ALLEEN DAN OOK DE DIRECT GERELATEERDE MATERIALS (MEESTAL DE STICKER/LABELS) OOK IN GEWICHT BEREKENING WORDEN MEEGENOMEN...
		  --
		  if l_mainpart = l_part_no
		  then
        --Het kan wel voorkomen dat er meerdere componenten onder mainpart voorkomen. In dit geval dus ook
        --controleren of er al een TYRE-record met een gewicht voorkomt. Als dat zo is doen we niets.
        --Dit in tegenstelling tot de componenten, waar we nog een lege regel wegschrijven, en gewicht later er pas weer bijzoeken.
        --Dat is bij een TYRE dus niet nodig...
        IF NOT p_part_exists(l_part_no, l_revision, l_datum_verwerking)
        THEN
          l_remark := 'MAINPART-HEADER-TYRE: DBA_FNC_BEPAAL_HEADER_GEWICHT';
          --dbms_output.put_line('TYRE-gewicht altijd berekenen, part-no:'||l_part_no );
          l_part_eenheid_kg := 0;
			    --We gaan voor TYRE zelf ook apart het gewicht berekenen om deze ook AFWIJKEND/EXTRA in tabel DBA_WEIGHT_COMPONENT_PART 
			    --op te slaan. We weten op dit moment ook het REVISION/ALTERNATIVE dus geven we dat direct mee !
          l_part_eenheid_kg := FNC_BEPAAL_MV_HEADER_GEWICHT(p_header_part_no=>l_part_no
		                                                        ,p_header_revision=>l_revision
				                           					                ,p_header_alternative=>l_alternative
                                                            ,p_show_incl_items_jn=>pl_show_incl_header_jn     --ALLEEN indien U dan ook output vanuit header
                                                            );
          --en schrijven we hier ook een aparte regel voor weg in hulptabel DBA_WEIGHT_COMPONENT_PART
          --zonder COMPONENT-data...
          --Ophalen van SAP-ARTICLE-CODES
          begin
            for r_partno_sap_code in c_partno_sap_code (l_part_no)
            loop
              l_sap_article_code    := r_partno_sap_code.sap_article_code;
              l_sap_da_article_code := r_partno_sap_code.sap_da_article_code;
              exit;
            end loop;
          exception
            when others
            then l_sap_article_code    := null;
                 l_sap_da_article_code := null;
          end;
          --INSERT HULPTABEL: DBA_WEIGHT_COMPONENT_PART
          --(LET OP: IS AUTONOMOUS-TRANSACTION !! Commit zit in procedure..)
          if nvl(pl_insert_weight_comp_jn,'N') = 'J'
          then
            DBA_INSERT_WEIGHT_COMP_PART (p_tech_calculation_date=>l_tech_calculation_date
		                                ,p_datum_verwerking=>l_datum_verwerking     --trunc(l_tech_calculation_date)
                                    ,p_mainpart=>l_mainpart 
                                    ,p_mainrevision=>l_mainrevision
                                    ,p_mainplant=>l_mainplant
                                    ,p_mainalternative=>l_mainalternative
                                    ,p_mainframeid=>l_mainframeid
                                    ,p_part_no=>l_part_no
								                  	,p_revision=>l_revision
                                    ,p_plant=>l_plant
                                    ,p_alternative=>l_alternative
                  									,p_header_issueddate=>to_date(l_header_issued_date,'dd-mm-yyyy hh24:mi:ss')
                  									,p_header_status=>l_header_status
                  									,p_component_part_no=>null
                                    ,p_component_description=>null
                  									,p_component_revision=>null
                  									,p_component_alternative=>null
                  									,p_component_issueddate=>null
                  									,p_component_status=>null
                								    ,p_characteristic_id=>null
                  									,p_functiecode=>null
                								    ,p_path=>l_part_no                   --alleen eigen part-no
                 								    ,p_quantity_path=>l_quantity_path
                 								    ,p_bom_quantity_kg=>1                --default = 1
                  									,p_comp_part_eenheid_kg=>l_part_eenheid_kg
                								    ,p_remark=>l_remark
                  									,p_lvl=>l_LVL
                   									,p_lvl_tree=>l_level_tree
                                    ,p_item_number=>null
                                    ,p_sap_article_code=>l_sap_article_code
                                    ,p_sap_da_article_code=>l_sap_da_article_code
                  									);
            --
			    ELSE
            if upper(pl_show_incl_items_jn) in ('J','U')
            then  dbms_output.put_line(l_remark||'(PARTNO=MAINPART:'||l_mainpart||' SAP-code: '||l_sap_article_code||') HEADER-KG:'||l_part_eenheid_kg);
			      END IF;
            --
            END IF;   --if insert-weight-comp-jn=J
          END IF;  --part-exists
          --
        end if;  --mainpart=part-no
        --
        --roep voor ALLE COMPONENT-PARTS ONDER DE MAINPART de weight-calculation via BEPAAL_BOM_HEADER_GEWICHT aan !
		    --Alleen indien deze niet voorkomt gaan we deze opnieuw berekenen !!
        --Indien niet via regulier verwerking aangeroepen dan bevat L_DATUM_VERWERKING de sysdate (via tech-calculation-date), en 
        --zal er eigenlijk nooit bestaand COMPONENT gevonden worden, en ALTIJD opnieuw berekend moeten worden...
        --Indien via AUTOMATISCHE-JOB-PROCES krijgen alle PART/COMPONENTS wel juiste VERWERKING-DATUM en worden ze wel gevonden...
		    l_component_part_eenheid_kg := 0;
        IF NOT p_component_exists(l_component_part, l_componentrevision, l_datum_verwerking)
        THEN
		     --dbms_output.put_line('COMPONENT DOESNOT EXIST YET, call dba_fnc_bepaal_header_gewicht' );
		     --We gaan voor IEDERE component vanuit de BOM het gewicht berekenen. 
	       --We weten op dit moment ook het REVISION/ALTERNATIVE dus geven we dat direct mee !
  		   l_component_part_eenheid_kg := FNC_BEPAAL_MV_HEADER_GEWICHT(p_header_part_no=>l_component_part
		                                                              ,p_header_revision=>l_componentrevision
						                                                      ,p_header_alternative=>l_componentalternative
                                                                  ,p_show_incl_items_jn=>pl_show_incl_header_jn  --ALLEEN indien U dan ook output vanuit header
                                                                   );
        ELSE
		      --we nemen gewicht over van we vorige keer al berekend hebben...
          begin
    		    select distinct dwc.comp_part_eenheid_kg 
            into   l_component_part_eenheid_kg
            from  dba_weight_component_part dwc 
            where dwc.component_part_no     = l_component_part
            and   dwc.component_revision    = l_componentrevision
            and   dwc.datum_verwerking     >= l_datum_verwerking    --Hier zit ook tijd in !!!. 
            and   dwc.comp_part_eenheid_kg  > 0
            and   dwc.tech_calculation_date >= trunc(sysdate)
            and   rownum = 1
            ;
          exception
            when others 
            then null;
              dbms_output.put_line('EXCP: COMPONENT-WEIGHT DOES ALREADY EXISTS, RETRIEVING THE WEIGHT GIVES ERROR, CHECK WEIGHT=0 FOR PART: '||l_component_part||'-'||l_componentrevision||': '||sqlerrm );
          end;
        END IF;																	  
	      --dbms_output.put_line('MAINPART: '||l_mainpart||' PART_NO: '||l_part_no||' COMPONENT-PART: '||l_component_part||' gewicht: '||l_component_part_eenheid_kg);
		    --
        l_remark  := 'COMP-PART-GEWICHT: DBA_FNC_BEPAAL_HEADER_GEWICHT';
        --INSERT HULPTABEL: DBA_WEIGHT_COMPONENT_PART
        --(LET OP: IS AUTONOMOUS-TRANSACTION !! Commit zit in procedure..)
        if nvl(pl_insert_weight_comp_jn,'N') = 'J'
        then
          DBA_INSERT_WEIGHT_COMP_PART (p_tech_calculation_date=>l_tech_calculation_date
		                                ,p_datum_verwerking=>l_datum_verwerking    --trunc(l_tech_calculation_date)
                                    ,p_mainpart=>l_mainpart 
                                    ,p_mainrevision=>l_mainrevision
                                    ,p_mainplant=>l_mainplant
                                    ,p_mainalternative=>l_mainalternative
                                    ,p_mainframeid=>l_mainframeid
                                    ,p_part_no=>l_part_no
									                  ,p_revision=>l_revision
                                    ,p_plant=>l_plant
                                    ,p_alternative=>l_alternative
                                    ,p_header_issueddate=>to_date(l_header_issued_date,'dd-mm-yyyy hh24:mi:ss')
			                              ,p_header_status=>l_header_status
                                   	,p_component_part_no=>l_component_part
                                    ,p_component_description=>l_componentdescription
                                    ,p_component_revision=>l_componentrevision
                                    ,p_component_alternative=>l_componentalternative
                                    ,p_component_issueddate=>to_date(l_componentissueddate,'dd-mm-yyyy hh24:mi:ss')
                                    ,p_component_status=>l_componentstatus
                                    ,p_characteristic_id=>l_characteristic_id
                                    ,p_functiecode=>l_functiecode
                                    ,p_path=>l_path
                                    ,p_quantity_path=>l_quantity_path
                                    ,p_bom_quantity_kg=>l_bom_quantity_kg                    
                                    ,p_comp_part_eenheid_kg=>l_component_part_eenheid_kg
                                    ,p_remark=>l_remark
                                    ,p_lvl=>l_LVL
                                    ,p_lvl_tree=>l_level_tree
                                    ,p_item_number=>l_item_number
                                    ,p_sap_article_code=>NULL
                                    ,p_sap_da_article_code=>NULL
                                    );
          --
		    else
          if upper(pl_show_incl_items_jn) in ('J','U')
          then dbms_output.put_line(l_remark||' (COMP-PART: '||l_part_no||' COMP: '||l_component_part||') HEADER-KG:'||l_component_part_eenheid_kg);
		      end if;
          --
      end if;  --insert-weight-comp-jn=J		
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
        THEN dbms_output.put_line('ALG-EXCP COMP-PART-MAINPART-BOM-ITEMS: '||SQLERRM); 
        else null;   
        end if;
	END;
  --
  if upper(pl_show_incl_items_jn) in ('J','U')
  then   
    --dbms_output.put_line('**************************************************************************************************************');
    dbms_output.put_line('COMP-PART-GEWICHT EINDE BEREKEN TOTAALGEWICHT VAN HEADER: '||pl_header_part_no ||' REVISION: '||pl_header_revision||' WEIGHT: '||l_part_eenheid_kg||' COMP-PART-WEIGHT: '||l_component_part_eenheid_kg);
    dbms_output.put_line('**************************************************************************************************************');
  end if;
  --
END BEPAAL_MV_COMP_PART_GEWICHT;
--
procedure dba_bepaal_comp_part_gewicht (p_header_part_no        varchar2 
                                       ,p_header_revision       varchar2 default null
                                       ,p_alternative           number   default null
                                       ,p_show_incl_items_jn    varchar2 default 'N'
                                       ,p_insert_weight_comp_jn varchar2 default 'N'														 
										          				 )
DETERMINISTIC
AS
--Script om voor ALLE COMPONENT-PART (niet zijnde material/grondstof in kg) in de BOM van een 
--bom-header/component het gewicht te berekenen DMV de procedure DBA_FNC_BEPAAL_HEADER_GEWICHT !!!
--
--Aangeroepen vanuit:  AANROEP_VUL_INIT_PART_GEWICHT
--Roept aan:           DBA_FNC_BEPAAL_HEADER_GEWICHT (voor iedere component uit BOM-TREE van TYRE)
--
--Door deze procedure per COMPONENT-PART aan te roepen berekenen we voor eigenlijk alle BOM-HEADERS
--het gewicht van 1 x EENHEID van deze BOM-HEADER (dus los van base-quantity waarmee deze header
--onderdeel uitmaakt van een BAND/TYRE.
--
--ALLE COMPONENTEN die in BOM-TREE van 1x TYRE/HEADER voorkomen worden met ZELFDE TECH_CALCULATION_DATE in 
--de tabel DBA_WEIGHT_COMPONENT_PART weggeschreven !!! 
--
--SELECTIE ZIT HIERBIJ  OP ALLE BOM-ITEMS (=EXCL. de BOM-ITEMS WAARBIJ COMPONENT-PART = MATERIALEN/GRONDSTOFFEN) 
--WAARBIJ PER COMPONENT-PART HET EENHEID-GEWICHT WORDT BEREKEND. 
--Dit betekent dan ook dat voor de BAND zelf het gewicht niet berekend kan worden met deze procedure
--aangezien een band zelf niet als COMPONENT-PART in de BOM-ITEM-tabel voorkomt. 
--Het is wel zo dat je deze procedure wel weer met een BAND/TYRE-PART-NO aanroept !!!!
--Onderhuids wordt dan voor iedere BOM-HEADER het gewicht berekend.
--
--Het kan wel voorkomen dat een PART-NO meerdere keren in de BOM van een BAND voorkomt,
--in dat geval wordt alsnog voor ieder voorkomen het gewicht berekend.
--
--LET OP: Procedure werkt alleen nog maar voor ALTERNATIVE=1 items !!!. Dus als er op een lager
--        niveau bom-items voorkomen met ALTERNATIVE=2 dan worden deze NIET meegenomen in de berekening.
--        (het is ook nog de vraag wat we met deze gewichten moeten doen? Later evt. uitbreiden...)
--
--Resultaten worden weggeschreven naar een hulptabel die gebruikt wordt voor SAP-INTERFACE !!!!!
--
--Parameters:  P_HEADER_PART_NO = bom-item-header, bijv.  EF_H215/65R15QT5	("CRRNT QR5", A_PCR)
--                                                        EF_Q165/80R15SCS	("CRRNT QR5", A_PCR)
--                                                        EF_S640/95R13CLS	("CRRNT QR5", A_PCR)
--             P_HEADER_REVISION = bom-item-header-revision-number van CURRENT/HISTORIC header.
--                                 Indien een TYRE zal status altijd CURRENT zijn. 
--                                 Een component kan zelf al HISTORIC zijn maar zolang hij in BOM-ITEM zit moet hij wel worden meegenomen.
--             P_ALTERNATIVE = indicator die aangeeft om welk alternatief het gaat. 
--                             1=default, per eenheid
--                             2=batch, voor bulk
--             P_SHOW_INCL_ITEMS_JN = J = dbms-output van TREE component-parts vanuit comp-part-gewicht (en niet gewichten uit header-gewicht)
--                                    U = dbms-output vanuit comp-part-gewicht + header-gewicht !!
--                                    N = ALLEEN output weggeschreven naar DBA_WEIGHT_COMPONENT_PART !!!
--             P_INSERT_WEIGHT_COMP_JN = J = INSERT van alle component-parts (resultaat van DBA_BEPAAL_BOM_HEADER_GEWICHT) in DBA_WEIGHT_COMPONENT_PART.
--                                           Indien aangeroepen vanuit DBA_AANROEP_BEPAAL_COMP_PART_GEWICHT dan ALTIJD INSERTEN van resultaten in VERWERKINGSTABEL !!!!!
--                                       N = geen output weggeschreven naar DBA_WEIGHT_COMPONENT_PART, alleen testing/logging !!! 
--                                           Indien direct aangeroepen voor test-doeleinden, dan resultaat niet altijd wegschrijven naar VERWERKING-TABEL !
-------------------------------------------------------------------------------------------------------------------------------------
--How is the WEIGHT of TYRE/COMPONENT calculated?
--bom_quantity_kg		   =   CONCAT ( * bom_item.quantity / bom_header.base_quantity )   = Weight-factor from a SPECIFIC-component within a TYRE
--comp_part_eenheid_kg     =   DBA_FNC_BEPAAL_HEADER_GEWICHT(p_header_part_no=>l_part_no)  = Total WEIGHT of one-UNIT of a COMPONENT (is for all tyres the same)
--tyre_component_weight_kg =   BOM_QUANTITY_KG * COMP_PART_EENHEID_KG                      = WEIGHT of a COMPONENT within a specific TYRE.
--
--*************************************************************************************************************************
--REVISION DATE        WHO	DESCRIPTION
--      12 25-07-2022  PS   Select the max(specification-header.revision) where a related bom-header.REVISION exists
--                          So always join bom-header/bom-specification to find the max(revision).
--      13 08-08-2022  PS   Add LVL/LVL-TREE fields to the insert-procedure DBA_INSERT_WEIGHT_COMP_PART to investigate differences better.
--      14 09-08-2022  PS   Parameter-waarde p_show_incl_items_jn uitgebreid met "U" waarde om wel/niet header-gewicht-output te kunnen tonen.
--      15 30-08-2022  PS   Aanroep van BEPAAL_BOM_HEADER_GEWICHT uitgebreid met P_HEADER_ALTERNATIVE.
--                          Bepalen van COMPONENT.ALTERNATIVE in query met aparte subselectie opgelost, werd voorheen alsnog header.alternative geselecteerd...
--      16 06-09-2022  PS   Toevoegen extra header-info voor weight-calculation 
--      17 23-02-2023  PS   Toevoegen extra sap-attributes tbv SAP-synchronisatie aan tabel DBA_WEIGHT_COMPONENT_PART
--*************************************************************************************************************************
--                          
pl_header_part_no           varchar2(100)   := p_header_part_no;
pl_header_revision          number          := p_header_revision;
pl_alternative              number(2)       := p_alternative;
pl_show_incl_items_jn       varchar2(1)     := UPPER(p_show_incl_items_jn);
pl_show_incl_header_jn      varchar2(1)     := UPPER(p_show_incl_items_jn);      --Indien pl_show_incl_items_jn=U dan krijgt deze waarde=J, anders N.
pl_insert_weight_comp_jn    varchar2(1)     := UPPER(p_insert_weight_comp_jn);
--
c_bom_items                sys_refcursor;
l_tech_calculation_date    date;    --datum waarmee alle components voor 1 BAND/HEADER in hulptabel DBA_WEIGHT_COMP_PART komen!!
l_datum_verwerking         date;    --datum die overeenkomt met datum_verwerking_vanaf als IDENTIFICATIE van een VERWERKINGSRUN/VUL-INIT uit de STUURTABEL
l_remark                   varchar2(100) := 'PRC: DBA_BEPAAL_COMP_PART_GEWICHT';
--
l_LVL                      varchar2(100);  
l_level_tree               varchar2(4000);
l_rownum                   number;
--
l_mainpart                 varchar2(100);
l_mainrevision             number;
l_mainplant                varchar2(100);
l_mainalternative          number;
l_mainbasequantity         number;
l_mainminqty               number;
l_mainmaxqty               number;
l_mainsumitemsquantity     number;
l_mainstatus               varchar2(100);
l_mainframeid              varchar2(100);
l_mainpartdescription      varchar2(1000);
l_mainpartbaseuom          varchar2(100);
l_sap_article_code         varchar2(40);
l_sap_da_article_code      varchar2(40);
--
l_part_no                  varchar2(100);
l_revision                 NUMBER;
l_plant                    varchar2(100);
l_alternative              number(2);
l_characteristic_id        number;
l_item_header_base_quantity number;
l_component_part           varchar2(100);
l_quantity                 number;
l_uom                      varchar2(100);
l_quantity_kg              number;
l_status                   varchar2(30);
l_functiecode              varchar2(1000);
l_header_issued_date       varchar2(30);
l_header_status            varchar2(30);
l_item_number              number(4,0);
l_componentdescription     varchar2(1000);
l_componentrevision        number;
l_componentalternative     number;
l_componentissueddate      varchar2(30);
l_componentstatus          varchar2(30);
l_path                     varchar2(4000);
l_quantity_path            varchar2(4000);
l_bom_quantity_kg         varchar2(100);
--
l_part_eenheid_kg            number;    --gewicht van BOM-HEADER=TYRE zelf.
l_component_part_eenheid_kg  number;    --gewicht van 1xEENHEID component-part obv volledige TREE aan BOM-ITEMS !!
--
c_bom                      sys_refcursor;
l_header_mainpart          varchar2(100);
l_header_gewicht           varchar2(100);
l_header_gewicht_som_items varchar2(100);
--
cursor c_partno_sap_code (p_part_no  varchar2)
is
SELECT sp1.char_1        sap_article_code
,      sp2.char_1        sap_da_article_code
FROM property              p1
,    specification_prop   sp1                              
,    property              p2
,    specification_prop   sp2                              
,    specification_header sh
WHERE sh.part_no   = p_part_no    --'EF_710/60R42TRO176'
and   sp1.property = p1.property
and   sp2.property = p2.property
AND   sh.revision  = (select max(sh1.revision)                               
                      from status s1, specification_header sh1                              
                      where   sh1.part_no    = sp1.part_no             --is component-part-no                              
                      and     sh1.status     = s1.status                               
                      and     s1.status_type in ('CURRENT','HISTORIC')                              
                     ) 
AND  sh.part_no  = sp1.part_no
AND  sh.part_no  = sp2.part_no
And  sh.revision = sp1.revision
And  sh.revision = sp2.revision
AND   sp1.section_id     = 700755 --  SAP information                              
and   sp1.property_group = 704056 --  SAP articlecode
and   sp1.property       = 713824 --  Commercial article code
AND   sp2.section_id     = 700755 --  SAP information                              
and   sp2.property_group = 704056 --  SAP articlecode
and   sp2.property       = 713825 --  Commercial DA article code	  
;

function get_verwerking_datum 
return date
IS
l_max_sbw  date;
begin
  --vanuit verwerking-vul-init-part-gewicht is reeds nieuw besturing-record aangemaakt met juist VANAF-datum !!
  --Deze datum nemen we over. 
  --We verwerken alle TYRES per FRAME-ID. Alleen het besturing-record zonder TM-datum hoort bij huidige FRAME-ID !!
  --(om die reden geen extra controle op juiste frame-id).
  --LETOP: als we een achterstand in moeten halen van een paar dagen, kan het zijn dat VANAF-datum dus ook 
  --       een paar dagen in het verleden ligt...
  select max(sbw.sbw_datum_verwerkt_vanaf) 
  into l_max_sbw
  from dba_sync_besturing_weight_sap   sbw
  where sbw.sbw_datum_verwerkt_tm is null
  ;
  return l_max_sbw;
  --
exception
  when no_data_found
  then return to_date(null);  
end get_verwerking_datum;
--
function p_part_exists (p_part_no          varchar2
                       ,p_revision         number 
                       ,p_datum_verwerking date   )
return boolean
IS
l_aantal  number;
begin
  l_aantal := 0;
  --dbms_output.put_line('START part: '||p_component_part_no||' revision: '||p_componentrevision||' aantal: '||l_aantal);
  select count(*) 
  into l_aantal
  from dba_weight_component_part dwc 
  where dwc.mainpart         = p_part_no
  and   dwc.part_no          = p_part_no
  and   dwc.revision         = p_revision
  and   dwc.datum_verwerking >= p_datum_verwerking
  --kan zijn dat er voor de direct gerelateerde components al record is weggeschreven. deze bevatten gewicht van component en niet van tyre zelf.
  --vandaar extra check op lege component-part 
  and   dwc.component_part_no   is null        
  and   dwc.component_revision  is null
  and   dwc.comp_part_eenheid_kg > 0
  and   dwc.tech_calculation_date >= trunc(sysdate)
  ;
  --dbms_output.put_line('RESULT part: '||p_component_part_no||' revision: '||p_componentrevision||' aantal: '||l_aantal);
  if nvl(l_aantal,0) > 0
  then return TRUE;
  else return FALSE;
  end if;
exception
  when no_data_found
  then return FALSE;  
end p_part_exists;
--
function p_component_exists (p_component_part_no  varchar2
                            ,p_componentrevision  number 
                            ,p_datum_verwerking   date  )
return boolean
IS
--Procedure om te kijken of component-part binnen zelfde RUN al een keer berekend is.
--Berekening van een component-weight is altijd hetzelde, ongeacht of deze onder een
--ander part-no, of zelfs dubbel (met ander item_number) bij eenzelfde part-no voorkomt.
l_aantal  number;
begin
  l_aantal := 0;
  --dbms_output.put_line('START part: '||p_component_part_no||' revision: '||p_componentrevision||' aantal: '||l_aantal);
  select count(*) 
  into l_aantal
  from dba_weight_component_part dwc 
  where dwc.component_part_no  = p_component_part_no
  and   dwc.component_revision = p_componentrevision
  and   dwc.datum_verwerking >= p_datum_verwerking
  and   dwc.comp_part_eenheid_kg > 0
  and   dwc.tech_calculation_date >= trunc(sysdate)
  ;
  --dbms_output.put_line('RESULT part: '||p_component_part_no||' revision: '||p_componentrevision||' aantal: '||l_aantal);
  if nvl(l_aantal,0) > 0
  then return TRUE;
  else return FALSE;
  end if;
exception
  when no_data_found
  then return FALSE;  
end p_component_exists;
--							
BEGIN
  dbms_output.enable(1000000);
  --init
  l_tech_calculation_date := sysdate;
  --Indien gestart mbv VUL-INIT of VERWERKING-MUTATIES dan is stuurtabel gevuld en gebruiken we de VERWERKING_VANAF-datum
  l_datum_verwerking      := get_verwerking_datum;   
  if  l_datum_verwerking is null
  then l_datum_verwerking := l_tech_calculation_date;
  end if;
  --
  if pl_show_incl_items_jn = 'U'
  then pl_show_incl_header_jn := 'J';
  else pl_show_incl_header_jn := 'N';
  end if;
  --
  if pl_header_revision is null
  then
	  --indien er geen revision is meegegeven dan alsnog eerst zelf ophalen
	  --PS: haal max(spec-revision) op waarvoor nog een bom-header-revision bestaat...
    begin
      select max(sh1.revision) 
	    into pl_header_revision
	    from status               s1
	    ,    specification_header sh1 
	    ,    bom_header           bh
	    where bh.part_no   = pl_header_part_no 
	    and   sh1.part_no  = bh.part_no 
	    and   sh1.revision = bh.revision
	    and   sh1.status   = s1.status 
	    and   s1.status_type in ('CURRENT','HISTORIC')
	    ;
	  exception
	    when others 
	    then dbms_output.put_line('REVISION-EXCP: Revision kon niet bepaald worden voor partno: '||pl_header_part_no);
    end;
  end if;
  --
  if upper(pl_show_incl_items_jn) IN ('J','U')
  then 
    dbms_output.put_line('**************************************************************************************************************');
    dbms_output.put_line('COMP-PART-GEWICHT-MAINPART: '||pl_header_part_no  );
    dbms_output.put_line('**************************************************************************************************************');
  end if;	
  --
  begin
	  --
	  if upper(pl_show_incl_items_jn) IN ('J','U')
    then 
      dbms_output.put_line('l_LVL'||';'||'l_mainpart'||';'||'l_mainrevision'||';'||'l_mainplant'||';'||'l_mainalternative'||';'||'l_mainframeid'||
	                   ';'||'l_part_no'||';'||'l_revision'||';'||'l_plant'||';'||'l_alternative'||';'||'l_header_issued_date'||';'||'l_header_status'||
							';'||'l_component_part'||';'||'l_componentdescription'||';'||'l_componentrevision'||';'||'l_componentalternative'||';'||'l_componentissueddate'||';'||'l_componentstatus'||
							';'||'l_characteristic_id'||';'||'l_functiecode'||';'||'l_path'||';'||'l_quantity_path'||';'||'l_bom_quantity_kg' );      
    end if;							
	  --Tonen van base/eenheid-gewicht van BOM-HEADER/component:
    open c_bom_items for SELECT bi2.LVL
				,      bi2.level_tree
				,      rownum
				,      bi2.mainpart
				,      bi2.mainrevision
				,      bi2.mainplant
				,      bi2.mainalternative
				,      bi2.mainframeid
				,      bi2.part_no
				,      bi2.revision
				,      bi2.plant
				,      bi2.alternative
				,      bi2.headerissueddate
				,      bi2.headerstatus
        ,      bi2.item_number
				,      bi2.component_part
				,      bi2.componentdescription
				,      bi2.componentrevision
				,      bi2.componentalternative
				,      bi2.componentissueddate
				,      bi2.componentstatus
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
				 ,      sh.frame_id
				 from status               s  
				 ,    specification_header sh
				 ,    bom_header           bh 
				 where  bh.part_no    = pl_header_part_no  --'EF_Q165/80R15SCS'  --'EM_764' --'EG_H620/50R22-154G'  --pl_header_part_no
         and    bh.revision   = pl_header_revision  --(select max(sh1.revision) from status s1, specification_header sh1 where sh1.part_no = bh.part_no and sh1.status = s1.status and s1.status_type in ('CURRENT','HISTORIC'))
				 and    bh.part_no    = sh.part_no
         and    bh.revision   = sh.revision
         and    sh.status     = s.status		
         --Er komt maar 1x CRRNT voor, de rest is HISTORIC/DEV, en dus is altijd max(revision)		  
				 --and    s.status_type in ('CURRENT','HISTORIC')
				 --welk alternative we moeten gebruiken is afhankelijk van PREFERRED-ind.
         and    bh.preferred  = 1
				 --and    rownum = 1
				) 
				select LEVEL   LVL
				,      RPAD('.', (level-1)*2, '.') || LEVEL AS level_tree
				,      h.part_no             mainpart
				,      h.revision            mainrevision
        ,      h.plant               mainplant
				,      h.alternative         mainalternative
				,      h.frame_id            mainframeid
				,      b.part_no
				,      b.revision
				,      b.plant
				,      b.alternative
				,      b.headerissueddate
				,      b.headerstatus
        ,      b.item_number        --PS new 20221115
				,      b.component_part
				,      (select pi.description from part pi where pi.part_no = b.component_part)           componentdescription
				,      (select max(bi2.revision) from bom_item bi2 where bi2.part_no = b.component_part)  componentrevision
				--,      b.alternative                                                                      componentalternative
        ,      (select DISTINCT bi3.alternative from bom_item bi3 
                where bi3.part_no = b.component_part 
				        and   bi3.revision = (select max(bi4.revision) from bom_item bi4 
                                      where bi4.part_no = bi3.part_no) 
                                      and   bi3.alternative = (select bh.alternative from bom_header bh 
                                                               where bh.part_no = bi3.part_no 
																		                           and bh.preferred=1 
																															 and bh.revision = (select max(bh2.revision) from bom_header bh2 where bh2.part_no = bh.part_no) )
																		  )   componentalternative 
				,      (select to_char(sh2.issued_date,'dd-mm-yyyy hh24:mi:ss') 
				        from   specification_header sh2
     						where  sh2.part_no     = b.component_part 
                and    sh2.revision = (select max(sh1.revision)  
                                       from status s1, specification_header sh1
     						                       where   sh1.part_no   = sh2.part_no      --is component-part-no   
                                       and     sh1.status   = s1.status 
                                       and     s1.status_type in ('CURRENT','HISTORIC')
                                      )
                       )	                                                                               componentissueddate
				,      (select s3.sort_desc
				        from   status s3, specification_header sh3
     						where  sh3.part_no     = b.component_part 
                and    sh3.revision = (select max(sh1.revision)  
                                       from status s1, specification_header sh1
		       			                       where   sh1.part_no   = sh3.part_no        --is component-part-no
                                       and     sh1.status   = s1.status 
                                       and     s1.status_type in ('CURRENT','HISTORIC')
                                       )
                and    s3.status  = sh3.status 
                )	                                                                               componentstatus
				,      b.item_header_base_quantity
				,      b.quantity
				,      b.uom
				,      b.quantity_kg
				,      b.characteristic_id       --FUNCTIECODE
				,      b.functiecode             --functiecode-descr
				,      sys_connect_by_path( b.part_no||decode(b.characteristic_id,null,'','-'||b.characteristic_id) || ',' || b.component_part ,'|')  path
				,      sys_connect_by_path( '('||b.quantity_kg||'/'||b.item_header_base_quantity||')', '*')  quantity_path
				FROM ( SELECT bi.part_no
				     ,      bi.revision
    				 ,      bi.plant
		    		 ,      bi.alternative
				     ,      TO_CHAR(sh.issued_date,'dd-mm-yyyy hh24:mi:ss')  headerissueddate
    				 ,      s.sort_desc                                      headerstatus
             ,      bi.item_number      --PS new 20221115
		    		 ,      bi.component_part
				     ,      bh.base_quantity   item_header_base_quantity
						 ,      bi.quantity
						 ,      bi.uom 
						 ,      case when bi.uom = 'g' then (bi.quantity/1000) else bi.quantity end  quantity_kg   --hier moeten we de overige UOMs zoals pcs/m nog wel meenemen anders wordt later de factor in quantity-path=0
				     ,      bi.ch_1         characteristic_id       --FUNCTIECODE
				     ,      c.description   functiecode             --functiecode-descr
  				   FROM status               s
						 ,    specification_header sh
						 ,    bom_header           bh
		         ,    characteristic       c
  	         ,    bom_item             bi	 
						 WHERE bh.part_no      = bi.part_no
						 and   bh.revision     = bi.revision
						 and   bh.preferred    = 1
						 and   bh.alternative  = bi.alternative
             --zoek hoogste specification-revision waar nog een bom-header bij voorkomt
						 and  bi.revision = (select max(sh1.revision) 
						                     from status s1, specification_header sh1, bom_header h2 
        	 											 where h2.part_no  = bi.part_no 
        												 and  sh1.part_no  = h2.part_no 
        												 AND  sh1.revision = h2.revision 
        												 and  sh1.status   = s1.status 
        												 and   s1.status_type in ('CURRENT','HISTORIC'))
						 and   bi.part_no     = sh.part_no
             and   bi.revision    = sh.revision
						 and   sh.status      = s.status	
						 --and   s.status_type  in ('CURRENT','HISTORIC')
  	         and   bi.ch_1        = c.characteristic_id(+)
					   ) b
				,      sel_bom_header h	   
				START WITH b.part_no = h.part_no 
				CONNECT BY NOCYCLE PRIOR b.component_part = b.part_no --and b.component_revision = b.revision
				order siblings by b.part_no
				)  bi2
        where bi2.component_part IN (select bi3.part_no from bom_item bi3 where bi3.part_no = bi2.component_part)   --NU itt DBA_BEPAAL_BOM_HEADER_GEWICHT: NIET de selectie voor material-codes, DIE gaan we niet de gewichten berekenen...
		 	;
    loop
      --init 
      l_sap_article_code    := null;
      l_sap_da_article_code := null;
      --
      fetch c_bom_items into l_LVL
                          ,l_level_tree
                          ,l_rownum
		                      ,l_mainpart  
                          ,l_mainrevision
						              ,l_mainplant
                          ,l_mainalternative
	            					  ,l_mainframeid
                  			  ,l_part_no 
                          ,l_revision
                          ,l_plant   
                          ,l_alternative
                          ,l_header_issued_date 
                          ,l_header_status
                          ,l_item_number
                          ,l_component_part      
                          ,l_componentdescription	
            						  ,l_componentrevision
					 	              ,l_componentalternative
            						  ,l_componentissueddate
						              ,l_componentstatus
                				  ,l_characteristic_id
                          ,l_functiecode
                          --,l_item_header_base_quantity
                          --,l_quantity            
                          --,l_uom                 
                          --,l_quantity_kg     
             						  ,l_path
            						  ,l_quantity_path
            						  ,l_bom_quantity_kg
            						  ;
      if (c_bom_items%notfound)   
      then CLOSE C_BOM_ITEMS;
	         exit;
	    end if;
      if upper(pl_show_incl_items_jn) in ('J','U')
      then 
        dbms_output.put_line('**************************************************************************************************************');
        dbms_output.put_line(l_LVL||';'||l_mainpart||';'||l_mainrevision||';'||l_mainplant||';'||l_mainalternative||';'||l_mainframeid||
		                  ';'||l_part_no||';'||l_revision||';'||l_plant||';'||l_alternative||';'||l_header_issued_date||';'||l_header_status||
					';'||l_component_part||';'||l_componentdescription||';'||l_componentrevision||';'||l_componentalternative||';'||l_componentissueddate||';'||l_componentstatus||
					';'||l_characteristic_id||';'||l_functiecode||';'||l_path||';'||l_quantity_path||';'||l_bom_quantity_kg );      
      end if;							
		  --
		  --INDIEN PART-NO = TYRE (MAINPART=PART-NO) DAN BEREKENEN WE GEWICHT VAN DE TYRE OOK NOG EVEN APART
		  --OMDAT ALLEEN DAN OOK DE DIRECT GERELATEERDE MATERIALS (MEESTAL DE STICKER/LABELS) OOK IN GEWICHT BEREKENING WORDEN MEEGENOMEN...
		  --
		  if l_mainpart = l_part_no
		  then
        --Het kan wel voorkomen dat er meerdere componenten onder mainpart voorkomen. In dit geval dus ook
        --controleren of er al een TYRE-record met een gewicht voorkomt. Als dat zo is doen we niets.
        --Dit in tegenstelling tot de componenten, waar we nog een lege regel wegschrijven, en gewicht later er pas weer bijzoeken.
        --Dat is bij een TYRE dus niet nodig...
        IF NOT p_part_exists(l_part_no, l_revision, l_datum_verwerking)
        THEN
          l_remark := 'MAINPART-HEADER-TYRE: DBA_FNC_BEPAAL_HEADER_GEWICHT';
          --dbms_output.put_line('TYRE-gewicht altijd berekenen, part-no:'||l_part_no );
          l_part_eenheid_kg := 0;
			    --We gaan voor TYRE zelf ook apart het gewicht berekenen om deze ook AFWIJKEND/EXTRA in tabel DBA_WEIGHT_COMPONENT_PART 
			    --op te slaan. We weten op dit moment ook het REVISION/ALTERNATIVE dus geven we dat direct mee !
          l_part_eenheid_kg := DBA_FNC_BEPAAL_HEADER_GEWICHT(p_header_part_no=>l_part_no
		                                                        ,p_header_revision=>l_revision
				                           					                ,p_header_alternative=>l_alternative
                                                            ,p_show_incl_items_jn=>pl_show_incl_header_jn     --ALLEEN indien U dan ook output vanuit header
                                                            );
          --en schrijven we hier ook een aparte regel voor weg in hulptabel DBA_WEIGHT_COMPONENT_PART
          --zonder COMPONENT-data...
          --Ophalen van SAP-ARTICLE-CODES
          begin
            for r_partno_sap_code in c_partno_sap_code (l_part_no)
            loop
              l_sap_article_code    := r_partno_sap_code.sap_article_code;
              l_sap_da_article_code := r_partno_sap_code.sap_da_article_code;
              exit;
            end loop;
          exception
            when others
            then l_sap_article_code    := null;
                 l_sap_da_article_code := null;
          end;
          --INSERT HULPTABEL: DBA_WEIGHT_COMPONENT_PART
          --(LET OP: IS AUTONOMOUS-TRANSACTION !! Commit zit in procedure..)
          if nvl(pl_insert_weight_comp_jn,'N') = 'J'
          then
            DBA_INSERT_WEIGHT_COMP_PART (p_tech_calculation_date=>l_tech_calculation_date
		                                ,p_datum_verwerking=>l_datum_verwerking     --trunc(l_tech_calculation_date)
                                    ,p_mainpart=>l_mainpart 
                                    ,p_mainrevision=>l_mainrevision
                                    ,p_mainplant=>l_mainplant
                                    ,p_mainalternative=>l_mainalternative
                                    ,p_mainframeid=>l_mainframeid
                                    ,p_part_no=>l_part_no
								                  	,p_revision=>l_revision
                                    ,p_plant=>l_plant
                                    ,p_alternative=>l_alternative
                  									,p_header_issueddate=>to_date(l_header_issued_date,'dd-mm-yyyy hh24:mi:ss')
                  									,p_header_status=>l_header_status
                  									,p_component_part_no=>null
                                    ,p_component_description=>null
                  									,p_component_revision=>null
                  									,p_component_alternative=>null
                  									,p_component_issueddate=>null
                  									,p_component_status=>null
                								    ,p_characteristic_id=>null
                  									,p_functiecode=>null
                								    ,p_path=>l_part_no                   --alleen eigen part-no
                 								    ,p_quantity_path=>l_quantity_path
                 								    ,p_bom_quantity_kg=>1                --default = 1
                  									,p_comp_part_eenheid_kg=>l_part_eenheid_kg
                								    ,p_remark=>l_remark
                  									,p_lvl=>l_LVL
                   									,p_lvl_tree=>l_level_tree
                                    ,p_item_number=>null
                                    ,p_sap_article_code=>l_sap_article_code
                                    ,p_sap_da_article_code=>l_sap_da_article_code
                  									);
            --
			    ELSE
            if upper(pl_show_incl_items_jn) in ('J','U')
            then  dbms_output.put_line(l_remark||'(PARTNO=MAINPART:'||l_mainpart||' SAP-code: '||l_sap_article_code||') HEADER-KG:'||l_part_eenheid_kg);
			      END IF;
            --
            END IF;   --if insert-weight-comp-jn=J
          END IF;  --part-exists
          --
        end if;  --mainpart=part-no
        --
        --roep voor ALLE COMPONENT-PARTS ONDER DE MAINPART de weight-calculation via BEPAAL_BOM_HEADER_GEWICHT aan !
		    --Alleen indien deze niet voorkomt gaan we deze opnieuw berekenen !!
        --Indien niet via regulier verwerking aangeroepen dan bevat L_DATUM_VERWERKING de sysdate (via tech-calculation-date), en 
        --zal er eigenlijk nooit bestaand COMPONENT gevonden worden, en ALTIJD opnieuw berekend moeten worden...
        --Indien via AUTOMATISCHE-JOB-PROCES krijgen alle PART/COMPONENTS wel juiste VERWERKING-DATUM en worden ze wel gevonden...
		    l_component_part_eenheid_kg := 0;
        IF NOT p_component_exists(l_component_part, l_componentrevision, l_datum_verwerking)
        THEN
		     --dbms_output.put_line('COMPONENT DOESNOT EXIST YET, call dba_fnc_bepaal_header_gewicht' );
		     --We gaan voor IEDERE component vanuit de BOM het gewicht berekenen. 
	       --We weten op dit moment ook het REVISION/ALTERNATIVE dus geven we dat direct mee !
  		   l_component_part_eenheid_kg := DBA_FNC_BEPAAL_HEADER_GEWICHT(p_header_part_no=>l_component_part
		                                                              ,p_header_revision=>l_componentrevision
						                                                      ,p_header_alternative=>l_componentalternative
                                                                  ,p_show_incl_items_jn=>pl_show_incl_header_jn  --ALLEEN indien U dan ook output vanuit header
                                                                   );
        ELSE
		      --we nemen gewicht over van we vorige keer al berekend hebben...
          begin
    		    select distinct dwc.comp_part_eenheid_kg 
            into   l_component_part_eenheid_kg
            from  dba_weight_component_part dwc 
            where dwc.component_part_no     = l_component_part
            and   dwc.component_revision    = l_componentrevision
            and   dwc.datum_verwerking     >= l_datum_verwerking    --Hier zit ook tijd in !!!. 
            and   dwc.comp_part_eenheid_kg  > 0
            and   dwc.tech_calculation_date >= trunc(sysdate)
            and   rownum = 1
            ;
          exception
            when others 
            then null;
              dbms_output.put_line('EXCP: COMPONENT-WEIGHT DOES ALREADY EXISTS, RETRIEVING THE WEIGHT GIVES ERROR, CHECK WEIGHT=0 FOR PART: '||l_component_part||'-'||l_componentrevision||': '||sqlerrm );
          end;
        END IF;																	  
	      --dbms_output.put_line('MAINPART: '||l_mainpart||' PART_NO: '||l_part_no||' COMPONENT-PART: '||l_component_part||' gewicht: '||l_component_part_eenheid_kg);
		    --
        l_remark  := 'COMP-PART-GEWICHT: DBA_FNC_BEPAAL_HEADER_GEWICHT';
        --INSERT HULPTABEL: DBA_WEIGHT_COMPONENT_PART
        --(LET OP: IS AUTONOMOUS-TRANSACTION !! Commit zit in procedure..)
        if nvl(pl_insert_weight_comp_jn,'N') = 'J'
        then
          DBA_INSERT_WEIGHT_COMP_PART (p_tech_calculation_date=>l_tech_calculation_date
		                                ,p_datum_verwerking=>l_datum_verwerking    --trunc(l_tech_calculation_date)
                                    ,p_mainpart=>l_mainpart 
                                    ,p_mainrevision=>l_mainrevision
                                    ,p_mainplant=>l_mainplant
                                    ,p_mainalternative=>l_mainalternative
                                    ,p_mainframeid=>l_mainframeid
                                    ,p_part_no=>l_part_no
									                  ,p_revision=>l_revision
                                    ,p_plant=>l_plant
                                    ,p_alternative=>l_alternative
                                    ,p_header_issueddate=>to_date(l_header_issued_date,'dd-mm-yyyy hh24:mi:ss')
			                              ,p_header_status=>l_header_status
                                   	,p_component_part_no=>l_component_part
                                    ,p_component_description=>l_componentdescription
                                    ,p_component_revision=>l_componentrevision
                                    ,p_component_alternative=>l_componentalternative
                                    ,p_component_issueddate=>to_date(l_componentissueddate,'dd-mm-yyyy hh24:mi:ss')
                                    ,p_component_status=>l_componentstatus
                                    ,p_characteristic_id=>l_characteristic_id
                                    ,p_functiecode=>l_functiecode
                                    ,p_path=>l_path
                                    ,p_quantity_path=>l_quantity_path
                                    ,p_bom_quantity_kg=>l_bom_quantity_kg                    
                                    ,p_comp_part_eenheid_kg=>l_component_part_eenheid_kg
                                    ,p_remark=>l_remark
                                    ,p_lvl=>l_LVL
                                    ,p_lvl_tree=>l_level_tree
                                    ,p_item_number=>l_item_number
                                    ,p_sap_article_code=>NULL
                                    ,p_sap_da_article_code=>NULL
                                    );
          --
		    else
          if upper(pl_show_incl_items_jn) in ('J','U')
          then dbms_output.put_line(l_remark||' (COMP-PART: '||l_part_no||' COMP: '||l_component_part||') HEADER-KG:'||l_component_part_eenheid_kg);
		      end if;
          --
      end if;  --insert-weight-comp-jn=J		
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
        THEN dbms_output.put_line('ALG-EXCP COMP-PART-MAINPART-BOM-ITEMS: '||SQLERRM); 
        else null;   
        end if;
	END;
  --
  if upper(pl_show_incl_items_jn) in ('J','U')
  then   
    --dbms_output.put_line('**************************************************************************************************************');
    dbms_output.put_line('COMP-PART-GEWICHT EINDE BEREKEN TOTAALGEWICHT VAN HEADER: '||pl_header_part_no ||' REVISION: '||pl_header_revision||' WEIGHT: '||l_part_eenheid_kg||' COMP-PART-WEIGHT: '||l_component_part_eenheid_kg);
    dbms_output.put_line('**************************************************************************************************************');
  end if;
  --
END DBA_BEPAAL_COMP_PART_GEWICHT;
--
--
--
--***************************************************************************************************************
-- AUTOMATISCH JOB/VERWERKING functions/procedures
--***************************************************************************************************************
--
procedure prc_check_part_changed_weight (p_part_no                   IN OUT varchar2
                                        ,p_revision                  IN OUT number 
                                        ,p_alternative               IN OUT number  
                                        ,p_new_comp_part_eenheid_kg  IN OUT number
                                        ,p_old_comp_part_eenheid_kg  IN OUT number
                                        ,p_new_header_base_quantity  IN OUT number
                                        ,p_old_header_base_quantity  IN OUT number
                                        ,p_weight_changed_ind        IN OUT varchar2 )
IS
--Procedure wordt aangeroepen met een CURRENT-PART/REVISION die in selectie-periode ontstaan is en dus een
--ISSUED_DATE heeft in deze selectie-periode. 
--LET OP: Het kan voorkomen dat MAX(REVISION) <> CURRENT-REV, Het kan NL. voorkomen dat er ook al een 
--        nieuwe DEV-PART/REVISION voorkomt (zonder issued-date) en
--        ook al in BOM-HEADER/ITEM voorkomt. Hier rekening mee houden in de controles, mogen NIET worden meegenomen.
--
--Procedure die laatste bekende gewicht uit tabel DBA_WEIGHT_COMPONENT_PART.COMP_PART_EENHEID_KG vergelijkt met 
--CURRENT-WEIGHT-berekening via DBA_FNC_BEPAAL_HEADER_GEWICHT obv actuele stand in INTERSPEC.
--
--DUS: deze functie ALLEEN gebruiken vanuit/voor dagelijkse mutatieverwerking waarbij de mutatie nog NIET is verwerkt
--     in de tabel DBA_WEIGHT_COMPONENT_PART !!!! Anders levert deze functie NOOIT een VERSCHIL op...
--
--Er worden een heleboel components gewijzigd (nieuwe revision aangemaakt) waarbij de wijzigingen
--helemaal geen gewichts-wijziging tot gevolg hebben. In zo'n geval hoeven we niet op zoek te gaan
--naar gerelateerde finished-products/tyres om daarvoor een volledig nieuwe gewichtsberekening te doen.
--Indien het een nieuw PART-no is (REVISION=1) moet het part-no zowiezo opnieuw worden meegenomen
--Parameters:   p_part_no     = part-no waarvoor nieuwe revision is aangemaakt
--              p_revision    = is het nieuwe/current-revision-nr 
--              p_alternative = alternative-waarde waarvoor gewicht berekend moet worden.
--
--Result-value: TRUE    --het gewicht is veranderd, moet opnieuw worden berekend
--              FALSE   --het gewicht is NIET veranderd, er hoeven geen nieuwe gewichten te worden berekend.
--
l_part_no           varchar2(18) := p_part_no;
l_revision          number       := p_revision;
l_alternative       number(2,0)  := p_alternative;
--
l_debug             varchar2(1)  := 'N';   --mogelijkheid voor DBA om debug aan/uit-te zetten !
--
l_base_quantity_curr number;
l_base_quantity_prev number;
l_weight_curr_rev    number;
l_weight_prev_rev    number;
--
l_result             varchar2(10);
begin
  if nvl(l_debug,'N')='J'
  then dbms_output.put_line('start part_no: '||l_part_no||' rev: '||l_revision||' alt: '||l_alternative);
  end if;
  --init
  l_weight_curr_rev := null;
  l_weight_prev_rev := null;
  l_result          := 'FALSE';   
  --
  --if l_revision = 1
  --then 
  --  if nvl(l_debug,'N')='J'
  --  then dbms_output.put_line('REVISION=1 part_no: '||l_part_no||' rev: '||l_revision);
  --  end if;
  --  l_result := 'TRUE';
  --else
    if nvl(l_debug,'N')='J'
    then dbms_output.put_line('REVISION<>1 part_no: '||l_part_no||' rev: '||l_revision);
    end if;
    --controleren eerst of base-quantity van part-no.bom-header gelijk gebleven is.
    begin
      --Hierna controleren we mbv gewicht-berekening of er ergens in de structuur van part-no.BOM 
      --is gewijzigd (aan componenten/materiaal) die gewichtswijziging tot gevolg zouden kunnen hebben.
      --EERST: we halen gewicht van een eventueel vorige revision van part-no op.
      begin
        select base_quantity
        into  l_base_quantity_curr
        from bom_header bh
        where bh.part_no     = l_part_no
        and   bh.revision    = l_revision
        and   bh.alternative = l_alternative
        ;
      exception
        when others
        then l_base_quantity_curr := null;
      end;
      if nvl(l_debug,'N')='J'
	    then dbms_output.put_line('BQ-check-CURR-REVISION<>1 part_no: '||l_part_no||' rev: '||l_revision||' bq: '||l_base_quantity_curr);
      end if;
      --
      BEGIN
        select base_quantity
        into  l_base_quantity_prev
        from bom_header bh
        where bh.part_no     = l_part_no
        --and   bh.revision    = l_revision
        and   bh.alternative = l_alternative
        and   bh.revision = (select max(bh2.revision)
                             from bom_header bh2
                             where bh2.part_no     = l_part_no
                             and   bh2.revision    < l_revision
                             and   bh2.alternative = l_alternative  )
        ;
      EXCEPTION
        WHEN OTHERS
        THEN l_base_quantity_prev := null;
      END;
      if nvl(l_debug,'N')='J'
	    then dbms_output.put_line('BQ-check PREV-REVISION<>1 part_no: '||l_part_no||' rev: '||l_revision||' bqprev: '||l_base_quantity_prev);
      end if;
      --
      if nvl(l_base_quantity_curr,-1) <> nvl(l_base_quantity_prev,-1)
      then 
        if nvl(l_debug,'N')='J'
        then dbms_output.put_line('BQ-check-DIFFERENCE part_no: '||l_part_no||' rev: '||l_revision||' BQprev: '||l_base_quantity_prev||' BQcurr: '||l_base_quantity_curr);
        end if;
        l_result := 'TRUE';
        --
      else
        begin
          if nvl(l_debug,'N')='J'
          then dbms_output.put_line('Voor Weight-prev-rev part_no: '||l_part_no||' rev: '||l_revision);
          end if;
          begin
            --selecteer van vorige revision het gewicht van de component/tyre.
            --Let op: vorige revision-nummer hoeft in deze tabel niet hierop volgend te zijn als vorige keer ook het gewicht niet veranderd is.
            select distinct comp_part_eenheid_kg
            into l_weight_prev_rev
            from (select distinct wcp.comp_part_eenheid_kg
                 from DBA_WEIGHT_COMPONENT_PART wcp
                 where wcp.component_part_no     = l_part_no
                 and   wcp.component_alternative = l_alternative
                 --and   wcp.component_revision = (select max(wcp2.component_revision)
                 --                                from DBA_WEIGHT_COMPONENT_PART wcp2
                 --                                where wcp2.component_part_no     = wcp.component_part_no
                 --                                and   wcp2.component_alternative = wcp.component_alternative
                 --                               )
                 --We nemen voortaan REVISION van de laatste INITIELE/MUTATIE-VERWERKING !!!
                 and   wcp.datum_verwerking = (select max(wcp2.datum_verwerking)
                                               from DBA_WEIGHT_COMPONENT_PART wcp2
                                               where wcp2.component_part_no     = wcp.component_part_no
                                               and   wcp2.component_alternative = wcp.component_alternative
                                              )
                 and rownum = 1                                     
                 UNION ALL
                 select distinct wcp.comp_part_eenheid_kg
                 from DBA_WEIGHT_COMPONENT_PART wcp
                 where wcp.mainpart              = l_part_no
                 and   wcp.mainalternative       = l_alternative
                 and   wcp.component_part_no     IS NULL
                 --and   wcp.mainrevision = (select max(wcp2.component_revision)
                 --                                from DBA_WEIGHT_COMPONENT_PART wcp2
                 --                                where wcp2.component_part_no     = wcp.component_part_no
                 --                                and   wcp2.component_alternative = wcp.component_alternative
                 --                               )
                 --We nemen voortaan REVISION van de laatste INITIELE/MUTATIE-VERWERKING !!!
                 and   wcp.datum_verwerking = (select max(wcp2.datum_verwerking)
                                               from DBA_WEIGHT_COMPONENT_PART wcp2
                                               where wcp2.MAINPART     = wcp.MAINPART
                                               and   wcp2.mainalternative = wcp.mainalternative
                                              )
                 and rownum = 1                                      
                 )
            where rownum = 1
            ;
            if nvl(l_debug,'N')='J'
            then dbms_output.put_line('NA Weight-prev-rev part_no: '||l_part_no||' rev: '||l_revision);
            end if;
          exception
            when others
            then l_weight_prev_rev := null;
          end;
          if nvl(l_debug,'N')='J'
    	    then dbms_output.put_line('REVISION<>1 part_no: '||l_part_no||' rev: '||l_revision||' PREV-WEIGHT: '||l_weight_prev_rev);
          end if;
          --DAARNA: berekenen we het nieuwe gewicht bij current-revision
          --'GM_R5026'
          l_weight_curr_rev := AAPIWEIGHT_CALC.FNC_BEPAAL_MV_HEADER_GEWICHT(p_header_part_no=>l_part_no     
                                                                           ,p_header_revision=>l_revision
                                                                           ,p_header_alternative=>l_alternative
                                                                           ,p_show_incl_items_jn=>'N' ) ;
          if nvl(l_debug,'N')='J'
    	    then dbms_output.put_line('REVISION<>1 part_no: '||l_part_no||' rev: '||l_revision||' CURR-WEIGHT: '||l_weight_curr_rev);
          end if;
          --Indien gewicht van current-version anders is dan previous-revision dan opnieuw berekenen.
          if nvl(l_weight_prev_rev,-1) <> nvl(l_weight_curr_rev,-1)
          then 
            if nvl(l_debug,'N')='J'
            then dbms_output.put_line('WEIGHT-diff part_no: '||l_part_no||' rev: '||l_revision||' Qprev: '||l_weight_prev_rev||' Qcurr: '||l_weight_curr_rev);
            end if;
            l_result := 'TRUE';
          end if;
        exception
          when no_data_found
          then --geen vorig voorkomen gevonden, dan ook altijd nieuw gewicht berekenen
               --vaak het geval indien status-verandering naar CURRENT heeft plaatsgevonden
               if nvl(l_debug,'N')='J'
               then dbms_output.put_line('EXCP-NO-DATA-FOUND part_no: '||l_part_no||' rev: '||l_revision||' Qprev: '||l_weight_prev_rev||' Qcurr: '||l_weight_curr_rev);
               end if;
               l_result := 'TRUE';
          when others
          then 
            if nvl(l_debug,'N')='J'
            then dbms_output.put_line('EXCP-OTHERS part_no: '||l_part_no||' rev: '||l_revision||' Qprev: '||l_weight_prev_rev||' Qcurr: '||l_weight_curr_rev);
            end if;
            l_result := 'TRUE';           
        end; 
        --
      end if; --base-quantity-curr/prev
      --
    exception
      when others
      then 
        if nvl(l_debug,'N')='J'
        then dbms_output.put_line('ALG-EXCP-CHECK-PART part_no: '||l_part_no||' rev: '||l_revision||'-'||sqlerrm);
        end if;
        l_result := 'TRUE';
    end;
    --
  --end if; --revision = 1
  --
  --Aanzetten voor debugging specifieke COMPONENT...
  --if l_part_no='EM_774' 
  if nvl(l_debug,'N')='J'
  then dbms_output.put_line('VOOR RETURN part_no: '||l_part_no||' rev: '||l_revision||' RESULT: '||L_RESULT||' Qprev: '||l_weight_prev_rev||' Qcurr: '||l_weight_curr_rev);
  end if;
  --
  p_new_header_base_quantity  := l_base_quantity_curr;
  p_old_header_base_quantity  := l_base_quantity_prev;
  --
  p_new_comp_part_eenheid_kg  := l_weight_curr_rev;
  p_old_comp_part_eenheid_kg  := l_weight_prev_rev; 
  --
  if l_result = 'TRUE'
  then p_weight_changed_ind := 'J';
  else p_weight_changed_ind := 'N';
  end if;
  --return l_result;
  --
exception
  when others
  then 
    if nvl(l_debug,'N')='J'
    then dbms_output.put_line('ALG-EXCP-OTHERS-CHECK-PART part_no: '||l_part_no||' rev: '||l_revision||'-'||sqlerrm);
    end if;
    --l_result := 'TRUE';  
    p_new_comp_part_eenheid_kg  := l_weight_curr_rev;
    p_old_comp_part_eenheid_kg  := l_weight_prev_rev; 
    p_weight_changed_ind := 'X'; 
    --
end prc_check_part_changed_weight;
-- 
function fnc_check_part_changed_weight (p_part_no      varchar2
                                       ,p_revision     number 
                                       ,p_alternative  number  )
RETURN VARCHAR2                                   
IS
--Procedure wordt aangeroepen met een CURRENT-PART/REVISION die in selectie-periode ontstaan is en dus een
--ISSUED_DATE heeft in deze selectie-periode. 
--LET OP: Het kan voorkomen dat MAX(REVISION) <> CURRENT-REV, Het kan NL. voorkomen dat er ook al een 
--        nieuwe DEV-PART/REVISION voorkomt (zonder issued-date) en
--        ook al in BOM-HEADER/ITEM voorkomt. Hier rekening mee houden in de controles, mogen NIET worden meegenomen.
--
--Procedure die laatste bekende gewicht uit tabel DBA_WEIGHT_COMPONENT_PART.COMP_PART_EENHEID_KG vergelijkt met 
--CURRENT-WEIGHT-berekening via DBA_FNC_BEPAAL_HEADER_GEWICHT obv actuele stand in INTERSPEC.
--
--DUS: deze functie ALLEEN gebruiken vanuit/voor dagelijkse mutatieverwerking waarbij de mutatie nog NIET is verwerkt
--     in de tabel DBA_WEIGHT_COMPONENT_PART !!!! Anders levert deze functie NOOIT een VERSCHIL op...
--
--Er worden een heleboel components gewijzigd (nieuwe revision aangemaakt) waarbij de wijzigingen
--helemaal geen gewichts-wijziging tot gevolg hebben. In zo'n geval hoeven we niet op zoek te gaan
--naar gerelateerde finished-products/tyres om daarvoor een volledig nieuwe gewichtsberekening te doen.
--Indien het een nieuw PART-no is (REVISION=1) moet het part-no zowiezo opnieuw worden meegenomen
--Parameters:   p_part_no     = part-no waarvoor nieuwe revision is aangemaakt
--              p_revision    = is het nieuwe/current-revision-nr 
--              p_alternative = alternative-waarde waarvoor gewicht berekend moet worden.
--
--Result-value: TRUE    --het gewicht is veranderd, moet opnieuw worden berekend
--              FALSE   --het gewicht is NIET veranderd, er hoeven geen nieuwe gewichten te worden berekend.
--
l_part_no           varchar2(18) := p_part_no;
l_revision          number       := p_revision;
l_alternative       number(2,0)  := p_alternative;
--
l_debug             varchar2(1)  := 'N';   --mogelijkheid voor DBA om debug aan/uit-te zetten !
--
l_base_quantity_curr number;
l_base_quantity_prev number;
l_weight_curr_rev    number;
l_weight_prev_rev    number;
--
l_tmp_result         varchar2(1);
l_result             varchar2(10);
begin
  if nvl(l_debug,'N')='J'
  then dbms_output.put_line('start part_no: '||l_part_no||' rev: '||l_revision);
  end if;
  --init
  l_weight_curr_rev := null;
  l_weight_prev_rev := null;
  l_result          := 'FALSE';
  l_tmp_result      := 'N';   
  --
  prc_check_part_changed_weight(p_part_no=>l_part_no
                               ,p_revision=>l_revision 
                               ,p_alternative=>l_alternative 
                               ,p_new_comp_part_eenheid_kg=>l_weight_curr_rev
                               ,p_old_comp_part_eenheid_kg=>l_weight_prev_rev
                               ,p_new_header_base_quantity=>l_base_quantity_curr
                               ,p_old_header_base_quantity=>l_base_quantity_prev
                               ,p_weight_changed_ind=>l_tmp_result        
                               );
  --  
  if l_tmp_result='J' 
  then l_result := 'TRUE';
  else l_result := 'FALSE';
  end if;
  --
  --Aanzetten voor debugging specifieke COMPONENT...
  --if l_part_no='EM_774' 
  if nvl(l_debug,'N')='J'
  then dbms_output.put_line('VOOR RETURN part_no: '||l_part_no||' rev: '||l_revision||' alt:'||l_alternative||' RESULT: '||L_RESULT||' WEIGHT-PREV: '||l_weight_prev_rev||' WEIGHT-CURR: '||l_weight_curr_rev);
  end if;
  --
  return l_result;
  --
exception
  when others
  then 
    if nvl(l_debug,'N')='J'
    then dbms_output.put_line('ALG-EXCP-OTHERS-CHECK-PART part_no: '||l_part_no||' rev: '||l_revision||'-'||sqlerrm);
    end if;
    l_result := 'TRUE';   
    return l_result;  
end fnc_check_part_changed_weight; 
--
--
procedure DBA_VERWERK_GEWICHT_MUTATIES (p_header_frame_id  varchar2 default 'ALLE' )
DETERMINISTIC
AS
--AANROEP-procedure om voor alle TYRES/COMPONENTEN waarvoor nieuwe REVISION gemaakt is, 
--vervolgens voor deze EN alle aan deze component gerelateerde bovenliggende BOM-HEADERS/BANDEN 
--de gewichten door te rekenen, en te verwerken in de tabel DBA_WEIGHT_COMPONENT_PART.
--LET OP: In INTERSPEC kan namelijk een component gewijzigd worden ZONDER dat BOM-HEADER/BAND een
--        nieuwe REVISION krijgt.
--Dit is de basis voor WEIGHT-CALCULATION voor ieder BOM-HEADER/COMPONENT tbv SAP-INTERFACE.
--Het gewicht wordt hier berekend uitgaande van 1 x EENHEID van een COMPONENT-PART. 
--Dat is anders dan de gewichten die berekend worden vanuit een BOM_HEADER_GEWICHT die vanuit een band 
--van alle onderliggende componenten de gewichten berekend. 
--
--Let op: SELECTIE ZIT VOORLOPIG NOG ALLEEN OP:
--           * EF%-BANDEN VAN TYPE A_PCR !!!
--           * GF%/XGF%-BANDEN VAN TYPE A_PCR/A_TBR
--        DIT WORDT GESTUURD DOOR VULLING VAN DE VIEW: AV_BHR_BOM_TYRE_PART_NO !!!
--
--Selectie-criteria: Selectie vind plaats op view AV_BHR_BOM_HEADER_PART_NO + SPECIFICATION_HEADER.ISSUED_DATE
--                   OBV: - part-no met status-type='CURRENT' 
--                   IN COMBINATIE MET: inhoud van HULPtabel DBA_WEIGHT_COMPONENT_PART en max(TECH_CALCULATION_DATE) 
--                   Alle componenten/tyres en status=CURRENT met een ISSUED-DATE hoger dan max(TECH_CALCULATION_DATE) 
--                   komen hiervoor in aanmerking
--                   Alle mutaties t/m GISTEREN (LEES: TRUNC(SYSDATE)) worden in 1x verwerkt...Dus niet lopende wijzigingen van vandaag!!
--
--Parameters:  GEEN. 
--             ER wordt obv DBA_SYNC_BESTURING_WEIGHT_SAP.SBW.SBW_DATUM_VERWERKT_TM de STARTDATUM bepaald !!
--             Voor alle TYRES waarbij een COMPONENT-PART een nieuwe revisie gekregen heeft na deze datum worden de gewichten opnieuw berekend.
--             Dit proces loopt tot/met alle mutaties van GISTEREN. 
--                                                 
--dependencies: FUNCTIE DBA_BEPAAL_BOM_PART_GEWICHT: functie om per BOM-HEADER alle onderliggende component-parts te bepalen.
--              FUNCTIE DBA_BEPAAL_BOM_HEADER_GEWICHT: functie om per BOM-HEADER uit functie DBA_BEPAAL_BOM_PART_GEWICHT 
--                                                     het gewicht te berekenen obv onderliggende component-parts.
--                                                     Dit vanuit 1xEenheid van bom-header.
--
--OUTPUT: Via de procedure DBA_BEPAAL_COMP_PART_GEWICHT wordt het gewicht per COMPONENT-PART berekend en in tabel DBA_WEIGHT_COMPONENT_PART gezet!!!
--
--SELECT COUNT(*) FROM DBA_WEIGHT_COMPONENT_PART;
--TRUNCATE table DBA_WEIGHT_COMPONENT_PART;
--
--Aanroep-voorbeelden:
--1) SET SERVEROUTPUT ON
--   exec DBA_VERWERK_GEWICHT_MUTATIES;
--
-----------------------------------------------------------------------------------------------------------
--    revision | who    | Reason
-----------------------------------------------------------------------------------------------------------
-- 14-12-2022  | P.S.   | where clause in cursor c_part_tyre aangepast in CYCLE-gedeelte voor REVISION-check, part-no ipv component-part
-- 16-12-2022  | P.S.   | where clause in cursor c_part_tyre aangepast in START-WITH-gedeelte met COMPONENT_PART om ook voor materialen de tyre te vinden.
-- 19-01-2023  | P.S.   | extra controle f_check_part_changed_weight ingebouwd in DBA_VERWERK_GEWICHT_MUTATIES om alleen voor tyres nieuwe
--                        gewichten te berekenen als op gewijzigde COMPONENT een gewichtsmutatie geweest is.
-- 06-02-2023  | P.S.   | gewichts-query van vorige revision in f_check_part_changed_weight aangepast
-- 07-03-2023  | P.S.   | CURSOR c_part_tyre aangepast voor wat betreft CONNECT-BY voortaan via part-no ipv component-part laten lopen voor alt/rev.
-----------------------------------------------------------------------------------------------------------
l_header_frame_id          varchar2(100)   := p_header_frame_id;
--
l_dba_test_mainpart        varchar2(100)   := NULL;  --'GF_1656015QT6NH' ;   --indien gevuld dan alleen controle op dit mainpart om te kijken waarom deze wordt geselecteerd...
--
--selectie-input log:
l_new_rev_log_id           number;
l_related_tyre_log_id      number;
l_tech_log_calc_date       date;
l_str_tech_log_calc_date   varchar2(100);
l_str_min_startdatum_van   varchar2(100);  --min startdatum-tm over alle frame-id
--
l_new_comp_part_eenheid_kg  number;
l_old_comp_part_eenheid_kg  number;
l_new_header_base_quantity  number;
l_old_header_base_quantity  number;
l_weight_changed_ind        varchar2(1);
l_sap_part_tyre_ind         varchar2(1);
--
c_nw_part_revision_weight_NW  sys_refcursor;
l_aantal_rev_weight           number;
c_sel_part_revision_weight    sys_refcursor;
l_sel_mainpart            varchar2(100);
l_sel_mainrevision        number;
l_sel_mainalternative     number;
l_sel_mainframeid         varchar2(100);
--sync-stuurtabel-info:
l_str_startdatum_van       varchar2(100);
l_str_startdatum_tm        varchar2(100);
l_str_MV_startdatum_tm     varchar2(100);
l_mut_verwerking_aan_ind   VARCHAR2(1);  
l_mut_sync_periode_dagen   NUMBER;
l_sync_id                  NUMBER;
l_verwerkt_aantal_tyres    number;
l_check_part_changed_weight varchar2(10);
--
l_part_tyre_ind            number;     --controle part-no wel/niet tyre
l_teller                   number;     --teller aantal tyres in array (let op: zitten nog dubbele tyres in !!)
l_tmp_teller               number;
--
type          PartType is record  (part_no      varchar2(100)
                                  ,revision     number(20)
                                  ,alternative  number(1)  );
Part          PartType;
type          TyreParttable  is table of Part%type;
TyrePartList  TyreParttable := TyreParttable();
--
l_tech_calculation_date  date;
l_startdatum             date;
l_einddatum              date;
l_duur_minuut            number;
--
l_sap_part_no           VARCHAR2(18);
l_sap_frame_id          varchar2(18);
l_part_eenheid_kg_old   number;
l_part_eenheid_kg_new   number;
l_remark                varchar2(1000);
--
--***********************************************
--AANSTURING VIA FRAME-ID VIA VIEW: AV_BHR_BOM_TYRE_PART_NO !!!!
--***********************************************
--loop voor ophalen van frame-id's om deze 1 voor 1 te verwerken !!!
--LET OP: zodra DECODE veranderd moeten we ook CURSOR=R_sel_part_revision_weight (vanaf tyre-frame-loop)
--op zelfde manier aanpassen, om gewijzigde TYRES van bijv A_PCR_v1 uit RELATED-TYRES op te kunnen halen !!!!
cursor c_tyre_frame_id (pl_header_frame_id varchar2)
is
select distinct a.frame_id
from (select decode(bh.FRAME_ID,'A_PCR_VULC v1','A_PCR', 'A_PCR_v1','A_PCR', 'A_PCR_v2','A_PCR', bh.FRAME_ID)      frame_id
     from AV_BHR_BOM_TYRE_PART_NO   bh
     where bh.frame_id like pl_header_frame_id||'%'   --in ('E_SM' ,'E_BBQ')        --alleen voor TEST-DOELEINDEN, VOOR PROD SNEL VERWIJDEREN....
     ) a
order by a.frame_id
;
--selecteer alle TYRE/COMPONENT-bom-headers met een nieuwe CURRENT-REVISION:
--Hier selecteren we alleen part/revision/alternative bij een preferred=1
cursor c_nw_part_revision (pl_str_startdatum_van varchar2
                          ,pl_str_startdatum_tm  varchar2 )
is
SELECT p.PART_NO
,      p.REVISION
,      p.FRAME_ID
,      p.STATUS
,      p.sort_desc
,      p.DESCRIPTION
,      p.ISSUED_DATE   
,      p.STATUS_CHANGE_DATE
,      p.OBSOLESCENCE_DATE
,      p.PLANT
,      p.alternative
from (SELECT sh.PART_NO
      ,      sh.REVISION
      ,      sh.FRAME_ID
      ,      sh.STATUS
      ,      s.sort_desc
      ,      sh.DESCRIPTION
      ,      sh.ISSUED_DATE   
      ,      sh.STATUS_CHANGE_DATE
      ,      sh.OBSOLESCENCE_DATE
      ,      bh.PLANT
      ,      bh.alternative
      FROM STATUS                s
      ,    SPECIFICATION_HEADER  sh
      ,    BOM_HEADER            bh
      WHERE sh.issued_date between to_date(pl_str_startdatum_van,'dd-mm-yyyy hh24:mi:ss')  and  to_date(pl_str_startdatum_tm,'dd-mm-yyyy hh24:mi:ss')   --between trunc(sysdate)-1 and trunc(sysdate)
      --alle wijzigingen t/m gisteren gaan we verwerken... 
      --and   bh.part_no like 'EM_700'  --'ED_700-5-11' 
      and   s.status      = sh.status
      and   s.status_type = 'CURRENT' 
      and   bh.part_no  = sh.part_no
      and   bh.revision = sh.revision
      and   upper(bh.preferred) = '1'
      --
      --AND bh.part_no not like 'EM%'  --EM% wel weer gewoon meenemen, maar later niet voor trial-frame-id's de related-tyre bepalen !!!
      --and rownum<10             --WEGHALEN !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     )  p
order by p.part_no
;
--selecteer alle TYRE/COMPONENT-bom-headers met een nieuwe CURRENT-REVISION met een GEWICHTSVERANDERING !!!!
--Vanuit de cursor C_NW_PART_REVISION wordt tabel DBA_WEIGHT_PART_NEW_REV_LOG gevuld !!!
--Hier selecteren we alleen part/revision/alternative waarbij HET GEWICHT veranderd is....
--cursor c_nw_part_revision_weight (pl_tech_calculation_date  varchar2,pl_str_startdatum_van     varchar2,   pl_str_startdatum_tm      varchar2 )
cursor c_nw_part_revision_weight (pl_tech_calculation_date  date )
is
SELECT dwl.PART_NO
,      dwl.REVISION
,      dwl.PLANT
,      dwl.ALTERNATIVE
,      dwl.FRAME_ID
,      dwl.ISSUED_DATE
,      dwl.STATUS
,      dwl.sap_part_tyre_ind
FROM DBA_WEIGHT_PART_NEW_REV_LOG dwl
WHERE dwl.tech_calculation_date = pl_tech_calculation_date
--WHERE dwl.tech_calculation_date = to_date(pl_tech_calculation_date,'dd-mm-yyyy hh24:mi:ss')
--and   dwl.issued_date between to_date(pl_str_startdatum_van,'dd-mm-yyyy hh24:mi:ss')  and  to_date(pl_str_startdatum_tm,'dd-mm-yyyy hh24:mi:ss')   --between trunc(sysdate)-1 and trunc(sysdate)
--and   dwl.part_no like 'EM_700'  --'ED_700-5-11' 
and   dwl.weight_changed_ind = 'J'
order by dwl.part_no
;
--
--selecteer alle BOM-TYRES waarvan nw-part-revision onderdeel van uitmaakt: 
--Hierin nemen we ook FRAME-ID mee voor selectie van JUISTE part-no. 
--Het kan dus zijn dat MUTATIE niet direct verwerkt wordt, maar pas op moment dat juiste FRAME-ID langskomt...
--Vanaf 20-03-2023 verwerken we eerst ALLE COMPONENTS met RELATED-TYRES (en pas daarna pikt de verwerking de juiste frame-tyres er uit !!!
--Parameter P-FRAME-ID wordt dus niet meer gebruikt bij NORMALE-VERWERKING!!!!
--was eerst: cursor c_part_tyre (p_part_no  varchar2 ,p_frame_id varchar2 )
cursor c_part_tyre (p_part_no  varchar2 )
is
SELECT DISTINCT bi2.part_no     mainpart
,      bi2.revision             mainrevision
,      bi2.plant                mainplant
,      bi2.alternative          mainalternative
,      bi2.preferred            mainpreferred
,      BI2.STATUS               MAINSTATUS
,      BI2.FRAME_ID             MAINFRAMEID
,      bi2.path
FROM		
(SELECT PART_NO
, REVISION
, PLANT
, ALTERNATIVE
, PREFERRED
, BASE_QUANTITY
, STATUS
, ISSUED_DATE
, FRAME_ID
, ITEM_NUMBER
, COMPONENT_PART
, COMP_REVISION
, COMP_PLANT
, COMP_ALTERNATIVE
, COMP_PREFERRED
, COMP_BASE_QUANTITY
, COMP_STATUS
, COMP_ISSUED_DATE
, COMP_FRAME_ID
, QUANTITY
, UOM
, CHARACTERISTIC
,      sys_connect_by_path( bi.component_part || ',' || bi.part_no ,'|')              path
FROM  mv_bom_item_comp_header bi
where bi.preferred = 1
and   bi.comp_preferred = 1    --raw-materials preferred=-1 nemen we hier niet mee...
START WITH bi.COMPONENT_PART = p_part_no  --'EM_574'     
CONNECT BY NOCYCLE prior bi.part_no     = bi.component_part 
               and prior bi.revision    = bi.comp_revision 
               and prior bi.alternative = bi.comp_alternative
               and prior bi.preferred   = 1
order siblings by bi.component_part		
) bi2
where NOT EXISTS (select ''  from bom_item bi3 where bi3.component_part = bi2.part_no )  
and bi2.status in (select s.status 
                     from status s 
                     where s.status      = bi2.status
                     and   s.status_type in ('CURRENT') ) 
and (  (    bi2.frame_id   LIKE ('A_PCR%')      --vooralsnog zonder TRIAL/XE-banden Enschede, wel XG-hongarije !!
       and (  bi2.part_no LIKE ('EF%') OR  bi2.part_no LIKE ('GF%') OR  bi2.PART_NO LIKE ('XGF%') )
       )
   OR  (   bi2.frame_id   LIKE ('A_TBR%')      --Truck-banden alleen Hongarije
       and (   bi2.part_no LIKE ('GF%') OR  BI2.PART_NO LIKE ('XGF%') )
       )
   OR  ( bi2.frame_id in ('E_PCR_VULC')      --C-alternative VulcTyre
       AND bi2.part_no like ('EV_C%')
       )
   OR  (   bi2.frame_id in ('E_SM')            --SpaceMaster Tyre
       AND bi2.part_no like ('EF%')
       )
   OR  (    bi2.frame_id in ('E_SF_Wheelset')   --SpaceMaster Wheelset (LET OP: IS GEEN FINISHED-PRODUCT !!)
	     and  (  bi2.part_no like ('EF%') or bi2.part_no like ('SW%') )
       )
   OR  (    bi2.frame_id in ('E_SF_BoxedWheels')   --SpaceMaster WheelsetBox (Bevat aantal Wheelsets)
	     and  (  bi2.part_no like ('EF%') or bi2.part_no like ('SE%') )
       )
   OR  (   bi2.frame_id in ('E_BBQ')           --Spoiler	
       and bi2.part_no like ('EQ%')
       )
   OR  (   bi2.frame_id in ('E_AT')            --Produced Agriculture Tyre (no trial/XEF)
       AND bi2.part_no like ('EF%')
       )
   )
;	
/*
--dd: 03-04-2023: query herschreven door te baseren op MV... 
--
cursor c_part_tyre (p_part_no  varchar2 )
is
SELECT DISTINCT bi2.part_no     mainpart
        ,      bi2.revision             mainrevision
        ,      bi2.plant                mainplant
        ,      bi2.alternative          mainalternative
		    ,      bi2.component_part
        ,      BI2.STATUS               MAINSTATUS
        ,      bi2.frame_id             mainframeid
        ,      bi2.path
		    --,      bi2.partaltpath
		    --,      bi2.partprefpath
        from ( SELECT bi.part_no
               ,      bi.revision     
               ,      bi.plant     
               ,      bi.alternative     
			         ,      bi.component_part
               ,      SH.STATUS
               ,      sh.frame_id	 
               ,      sys_connect_by_path( bi.component_part || ',' || bi.part_no ,'|')              path
               --,      sys_connect_by_path( bh.alternative ,'|')                                partaltpath
               --,      sys_connect_by_path( bh.preferred ,'|')                                partprefpath
               FROM  specification_header sh
               JOIN  bom_header  bh ON bh.part_no = sh.part_no and bh.revision = sh.revision and bh.preferred = 1
               JOIN  bom_item    bi	ON bi.part_no = bh.part_no and bi.revision = bh.revision and bi.alternative = bh.alternative    
               WHERE (   sh.frame_id not in ('Trial E_ FM') 
                     and sh.part_no  not like ('XEM%')      )
               and   sh.status      in (select s.status 
                                        from status s 
                                        where s.status = sh.status
                                        and   s.status_type in ('CURRENT','HISTORIC') )
               and   bh.revision    = (select max(bh2.revision) 
                                       from specification_header sh2
                                       ,    bom_header bh2 
                                       where sh2.part_no     = bH.part_no 
                                       and   bh2.alternative = bH.alternative
                                       and   BH2.preferred = 1
                                       and sh2.part_no   = bh2.part_no 
                                       and sh2.revision  = bh2.revision 
                                       and sh2.status in (select s.status 
                                                         from status s 
                                                         where s.status      = sh2.status
                                                         and   s.status_type in ('CURRENT','HISTORIC') ) )
               START WITH bi.COMPONENT_PART = p_part_no   --PL_COMPONENT_PART_NO   --'EM_574'     
               CONNECT BY NOCYCLE prior bi.part_no = bi.component_part 
               order siblings by bi.component_part
               ) bi2
        where NOT EXISTS (select ''  from bom_item bi3 where bi3.component_part = bi2.part_no )  
        and bi2.status in (select s.status 
                           from status s 
                           where s.status      = bi2.status
                           and   s.status_type in ('CURRENT') ) 
        --and    bi2.part_no = decode(l_dba_test_mainpart,null,bi2.part_no,l_dba_test_mainpart)   
        --AND    bi2.frame_id like p_frame_id||'%'                            
		    and (   ( bi2.frame_id   LIKE ('A_PCR%')      --vooralsnog zonder TRIAL/XE-banden Enschede, wel XG-hongarije !!
                and (  bi2.part_no LIKE ('EF%') OR  bi2.part_no LIKE ('GF%') OR  bi2.PART_NO LIKE ('XGF%') )
                )
            OR  ( bi2.frame_id   LIKE ('A_TBR%')      --Truck-banden alleen Hongarije
                and (   bi2.part_no LIKE ('GF%') OR  BI2.PART_NO LIKE ('XGF%') )
                )
            OR  ( bi2.frame_id in ('E_PCR_VULC')      --C-alternative VulcTyre
                AND bi2.part_no like ('EV_C%')
                )
            OR  ( bi2.frame_id in ('E_SM')            --SpaceMaster Tyre
                AND bi2.part_no like ('EF%')
                )
            OR  ( bi2.frame_id in ('E_SF_Wheelset')   --SpaceMaster Wheelset (LET OP: IS GEEN FINISHED-PRODUCT !!)
	              and  (  bi2.part_no like ('EF%') or bi2.part_no like ('SW%') )
                )
            OR  ( bi2.frame_id in ('E_SF_BoxedWheels')   --SpaceMaster WheelsetBox (Bevat aantal Wheelsets)
	              and  (  bi2.part_no like ('EF%') or bi2.part_no like ('SE%') )
                )
            OR  ( bi2.frame_id in ('E_BBQ')           --Spoiler	
                and bi2.part_no like ('EQ%')
                )
            OR  ( bi2.frame_id in ('E_AT')            --Produced Agriculture Tyre (no trial/XEF)
                AND bi2.part_no like ('EF%')
                )
            )	
;	
*/
--
procedure p_add_part_not_exists (p_part_no      varchar2
                                ,p_revision     number 
                                ,p_alternative  number)
IS
--We nemen bij AANWEZIGHEID-CONTROLE geen ALTERNATIVE-mee !!. We nemen in dit stadium van het proces
--de hele band mee, en pas later bij het berekenen van de TYRE-weights wordt er pas de juiste ALTERNATIVE
--geselecteerd voor het berekenen van het gewicht...
l_aantal       number(20);    --aantal voorkomens van part-no in ARRAY
l_array_teller number(20);    --totaal aantal voorkomens in ARRAY
begin
  l_aantal       := 0;
  l_array_teller := TyrePartList.count;  
  --dbms_output.put_line('START part: '||p_component_part_no||' revision: '||p_componentrevision||' aantal: '||l_aantal);
  --hier vullen van internal-table...  
  if l_array_teller = 0
  then 
    l_aantal := 0;
  else
    for i in   TyrePartList.first..TyrePartList.last
    loop
      if  TyrePartList(i).PART_NO  = p_part_no  
      and TyrePartList(i).REVISION = p_revision
      then
        l_aantal := l_aantal+1;
      end if;
    end loop;
    --
  end if;
  --
  if nvl(l_aantal,0) = 0
  then
    --interne-tabel aanvullen met nieuw part-no  
    begin
      if TyrePartList.exists(l_array_teller+1)
      then null;
      else TyrePartList.extend;
      end if;
    exception
      when Subscript_beyond_count
      then TyrePartList.extend;
    end;
    l_array_teller := l_array_teller + 1;
	  --
    TyrePartList(l_array_teller).PART_NO     := p_part_no;
    TyrePartList(l_array_teller).REVISION    := p_revision;
    TyrePartList(l_array_teller).ALTERNATIVE := p_alternative;
	  --
	  --dbms_output.put_line('RESULT part: '||p_part_no||' revision: '||p_revision||' array-teller: '||l_array_teller);
  else
    --part-no komt al in array voor, hoeven verder niets te doen...
	  null;
  end if;
exception
  when no_data_found
  then null;  
  when others
  then dbms_output.put_line('ALG-EXCP-ADD-PART-ERROR part: '||p_part_no||' revision: '||p_revision||' array-teller: '||l_array_teller||'-'||SQLERRM);
end p_add_part_not_exists; 
--
BEGIN
  DBMS_OUTPUT.ENABLE(1000000);
  dbms_output.put_line('start DBA_VERWERK_GEWICHT_MUTATIES');
  --*******************************************************
  --VERVERS eerst MV = mv_bom_item_comp_header bij !!
  --PAS NA VERVERS-ACTIE ZETTEN WE DE START-VANAF-DATUM 
  refresh_mv_bom_item_header;
  --*******************************************************
  --init
  l_teller                := 0;
  l_startdatum            := sysdate;
  l_tech_calculation_date := sysdate;
  --
  --frame-id mag alleen waarde ALLE/<null> of volledig frame-id bevatten
  if nvl(upper(l_header_frame_id),'ALLE') = 'ALLE'
  then l_header_frame_id := '%';
  else l_header_frame_id := l_header_frame_id;
  end if;
  --
  --We willen alle NEW-REVISION voor ALLE frame-id's waarvoor deze procedure wordt gestart maar 1x berekenen
  --en loggen in de log-tabel. Echter de DATUM-VERWERKT-VANAF/TM wijkt per FRAME-ID af...
  --Indien PARAMETER-FRAME-ID='ALLE' dan selecteren we de LAAGSTE-DATUM-VERWERKT_TM van meest actuele VERWERKING
  --van ALLE frame-ids.
  begin
      --bepaal LOG-DATUM VOOR DE GEHELE RUN, HIERMEE LOOPT STURING OP ISSUED-DATE-LOG-TABEL !!!!!
      l_tech_log_calc_date := sysdate;
      l_str_tech_log_calc_date := to_char(l_tech_log_calc_date,'dd-mm-yyyy hh24:mi:ss');
      dbms_output.put_line('Tech-log-datum RUN: '||to_char(l_tech_log_calc_date,'dd-mm-yyyy hh24:mi:ss')||'-str: '||l_str_tech_log_calc_date );
      --select to_char( max(dwc.tech_calculation_date), 'dd-mm-yyyy hh24:mi:ss' ) into l_str_startdatum_van from dba_weight_component_part dwc ;
      with sel_frame_id as (select max(s.id) maxid, sbw_selected_frame_id 
                           from DBA_SYNC_BESTURING_WEIGHT_SAP s
                           where s.sbw_mut_verwerking_aan = 'J'
                           and   s.sbw_selected_frame_id is not null 
                           and   s.sbw_selected_frame_id <> 'ALLE'
                           AND   s.sbw_selected_frame_id = decode(l_header_frame_id,'%',s.sbw_selected_frame_id,l_header_frame_id)
                           group by sbw_selected_frame_id
                           )
      SELECT to_char( (MIN(SBW.SBW_DATUM_VERWERKT_TM+1/(24*60*60))), 'dd-mm-yyyy hh24:mi:ss' ) 
	    into l_str_min_startdatum_van 
      from DBA_SYNC_BESTURING_WEIGHT_SAP SBW 
      ,    sel_frame_id                  SF
      WHERE sbw.id =  sf.maxid
      AND   sbw.sbw_datum_verwerkt_tm is not null         --indien deze NULL is, dan loopt er nog een andere sessie, en starten we niet een nieuwe op!!!
      ;
      dbms_output.put_line('UITVRAGEN-STUURTABEL verwerkingperiode van: '||l_str_min_startdatum_van);
  exception
    when others 
    then rollback;
         --l_str_startdatum_van := to_char( (trunc(sysdate)-1), 'dd-mm-yyyy hh24:mi:ss') ;
         dbms_output.put_line('EXCP-UITVRAGEN-STUURTABEL verwerkingperiode van: '||l_str_startdatum_van||'-'||sqlerrm);
  END;
  --tm. eind ALTIJD tm. EINDE van de vorige WERKELIJKE dag tov SYSDATE:
  --l_str_startdatum_tm := to_char( (trunc(sysdate)), 'dd-mm-yyyy' )||' 23:59:59';
  --We gaan toch weer over naar VERWERKING TOT/MET SYSDATE (in loop van FRAME-ID kan het dus voorkomen dat Verwerkingsperiodese elkaar opvolgen)
  --Dit is wel gedaan om OOK onafhankelijke FRAME-ID-verwerkingen aan te kunnen.
  l_str_startdatum_tm    := to_char( sysdate, 'dd-mm-yyyy hh24:mi:ss' );
  --voor bijwerken stuurtabel:
  l_str_MV_startdatum_tm := l_str_startdatum_tm;
  --SELECTEER ALLE NIEUWE CURRENT-COMPONENT/HEADER-REVISIONS DIE IN TIJDSINTERVAL ZIJN AANGEMAAKT...
  --dit kunnen allerlei componenten zijn, niet gerelateerd aan TYRE-FRAME-ID...
  for r_nw_part_revision in c_nw_part_revision (l_str_MIN_startdatum_van, l_str_startdatum_tm )
  loop
    --dbms_output.put_line('IN LOOP NW-PART-REVISION: '||r_nw_part_revision.part_no);
    --Er is nieuwe COMPONENT-PART-revision bijgekomen. Nu is het maar de vraag of het gewicht gewijzigd is.
    --Dat gaan we nu eerst controleren.
    --l_check_part_changed_weight := 'FALSE';
    --Indien BASE-QUANTITY al afwijkt, wordt er geen GEWICHT berekend !!!
    prc_check_part_changed_weight (p_part_no=>r_nw_part_revision.part_no
                                  ,p_revision=>r_nw_part_revision.revision
                                  ,p_alternative=>r_nw_part_revision.alternative
                                  ,p_new_comp_part_eenheid_kg=>l_new_comp_part_eenheid_kg  
                                  ,p_old_comp_part_eenheid_kg=>l_old_comp_part_eenheid_kg  
                                  ,p_new_header_base_quantity=>l_new_header_base_quantity
                                  ,p_old_header_base_quantity=>l_old_header_base_quantity
                                  ,p_weight_changed_ind=>l_weight_changed_ind  
                                  );
    begin
      --dbms_output.put_line('r_nw_part: '||r_nw_part_revision.PART_NO||':'||r_nw_part_revision.REVISION||' issued-date: '||r_nw_part_revision.issued_date||' frame: '||r_nw_part_revision.FRAME_ID );
      --*********************************
      --Check of het al een TYRE is...
      --*********************************
      --LET OP: Er zitten TYRES in systeem die vroeger als component bij een andere band voorkwamen. 
      --Deze zijn wel HISTORIC maar zitten nog wel in BOM-ITEM. Wat hiermee te doen...????
      begin
        l_sap_part_tyre_ind := 'N';
        select CASE when count(*) > 0 then 'J' else 'N' end
        into   l_sap_part_tyre_ind
        from  specification_header sh
        where sh.part_no  = r_nw_part_revision.part_no
        and   sh.revision = r_nw_part_revision.revision
        --and   sh.frame_id like r_tyre_frame_id.frame_id||'%'     --A_PCR% ook voorophalen A_PCR_VULC_v1 etc.
        --Extra check op de AV_BHR_BOM_TYRE_PART_NO omdat er ook nog componenten bestaan met een FRAME-ID gelijk aan TYRE-FRAME-ID
        --Deze moeten worden uitgesloten voor deze TYRE-controle...
        and   sh.part_no in (--Hierin zit FRAME-ID en PLANT (EF/GT) en Finished-product=EF
                             select av.PART_NO     
                             from av_bhr_bom_tyre_part_no   av
                             WHERE  av.part_no = sh.part_no
                             AND    av.frame_id like '%' 
                            )
        ;
  	  exception
       when others then l_sap_part_tyre_ind := 'N';
  	  end;
      --<insert log-record...>
      select DBA_WEIGHT_PARTNEWREV_LOG_SEQ.nextval into l_new_rev_log_id from dual;
      --
      insert into DBA_WEIGHT_PART_NEW_REV_LOG
      ( ID
      , tech_calculation_date       
      , DATUM_VERWERKING        
      , part_no                     
      , revision                    
      , plant                       
      , alternative                 
			, frame_id                    
      , issued_date                 
      , status                      
			, new_part_ind                 
			, new_comp_part_eenheid_kg    
			, old_comp_part_eenheid_kg    
      , new_header_base_quantity
      , old_header_base_quantity
			, weight_changed_ind
      , sap_part_tyre_ind 
      )
      values
      (l_new_rev_log_id
      ,l_tech_log_calc_date
      ,TO_DATE(l_str_min_startdatum_van,'dd-mm-yyyy hh24:mi:ss')
      ,r_nw_part_revision.part_no
      ,r_nw_part_revision.revision
      ,r_nw_part_revision.plant
      ,r_nw_part_revision.alternative
      ,r_nw_part_revision.frame_id
      ,r_nw_part_revision.issued_date
      ,r_nw_part_revision.status
      ,decode(l_old_comp_part_eenheid_kg,null,decode(l_old_header_base_quantity,null,'J','N'),'N')
      ,l_new_comp_part_eenheid_kg
      ,l_old_comp_part_eenheid_kg
      ,l_new_header_base_quantity
      ,l_old_header_base_quantity
      ,l_weight_changed_ind
      ,l_sap_part_tyre_ind 
      ); 
    exception 
      when others 
      then null;
           dbms_output.put_line('EXCP-INSERT-DBA_WEIGHT_PART_NEW_REV_LOG part-no: '||r_nw_part_revision.part_no||': '||sqlerrm);
    end;
    --
    --Er is nieuwe TYRE-revision bijgekomen. Nu is het maar de vraag of het gewicht gewijzigd is.
    --Dat gaan we nu eerst controleren.
    --l_check_part_changed_weight := 'FALSE';
    --l_check_part_changed_weight := fnc_check_part_changed_weight (p_part_no=>r_nw_part_revision.part_no
    --                                                             ,p_revision=>r_nw_part_revision.revision
    --                                                             ,p_alternative=>r_nw_part_revision.alternative);
    --  
    --if l_check_part_changed_weight = 'TRUE'                                                                       
    --then 
      --l_teller := l_teller + 1;                                        
      --Er is een gewichtsberekening NOODZAKELIJK. GEWICHT VAN COMPONENT IS GEWIJZIGD. 
      --begin
        --<update log-record >
        --UPDATE DBA_WEIGHT_PART_NEW_REV_LOG set weight_changed_ind='J' where id = l_new_rev_log_id;
        --
      --exception
        --when others
        --then null;
      --end;
   -- else
      --<update log-record...>
      --  UPDATE DBA_WEIGHT_PART_NEW_REV_LOG set weight_changed_ind='N' where id = l_new_rev_log_id;
    --end if;                                                                           
    --
    commit;
    --
  end loop;  --r_nw_part_revision
  --
      --**************************************************************************************************
      --**************************************************************************************************
      --START VERWERKING...
      --Gebruik hier de DATUM-PERIODE over alle FRAMES heen !!!!
      --l_str_MIN_startdatum_van, l_str_startdatum_tm
      --**************************************************************************************************
      --**************************************************************************************************
      --SELECTEER ALLE NIEUWE CURRENT-COMPONENT/HEADER-REVISIONS MET GEWICHTSWIJZIGING DIE IN TIJDSINTERVAL ZIJN AANGEMAAKT...
      --dit kunnen allerlei componenten zijn, niet gerelateerd aan TYRE-FRAME-ID...
      --for r_nw_part_revision_weight in c_nw_part_revision_weight (l_str_tech_log_calc_date, l_str_startdatum_van, l_str_startdatum_tm ) 
      open c_nw_part_revision_weight_NW for 
      SELECT count(*)
      FROM DBA_WEIGHT_PART_NEW_REV_LOG dwl
      WHERE dwl.tech_calculation_date = l_tech_log_calc_date    --to_date(l_str_tech_log_calc_date,'dd-mm-yyyy hh24:mi:ss')
      and   dwl.weight_changed_ind = 'J'
      ;
      loop
        fetch c_nw_part_revision_weight_NW into l_aantal_rev_weight;
        dbms_output.put_line('Aantal changed-weight: '||l_aantal_rev_weight);
        if (c_nw_part_revision_weight_NW%notfound)   
        then CLOSE c_nw_part_revision_weight_NW;
	           exit;
	      end if;
      end loop;
      --
      dbms_output.put_line('voor loop nw-part-revision-weight date:'||l_str_tech_log_calc_date);
      --SELECTIE VAN ALLE part-no UIT DEZE RUN (obv TECH-CALCULATION_DATE) WAARVAN GEWICHT GEWIJZIGD IS...
      --Tabel die als basis gebruikt wordt: DBA_WEIGHT_PART_NEW_REV_LOG (die is hiervoor gevuld met ind-wel/niet gewicht gewijzigd is)
      for r_nw_part_revision_weight in c_nw_part_revision_weight ( l_tech_log_calc_date ) 
      loop
        dbms_output.put_line('IN loop PART-NO:'||r_nw_part_revision_weight.part_no);
        --start-record       
        begin
          --TOEVOEGEN VAN EXTRA RECORD AAN LOG-TABEL TBV VOORTGANGSCONTROLE...
          --EN OM TE ZIEN OP WELK PART-NO HET PROCES OP BEPAALD MOMENT BLIJFT HANGEN !!!
          --KAN LATER EVENTUEEL WEER UITGEZET WORDEN ALS PROCES STABIEL BLIJFT !!!
          --<insert log-record...>
          select DBA_WEIGHT_RELTYRE_LOG_SEQ.nextval into l_related_tyre_log_id from dual;
          --
          insert into DBA_WEIGHT_RELATED_TYRE_LOG
              (ID                                  
              ,TECH_CALCULATION_DATE                          
              ,DATUM_VERWERKING                        
              ,PART_NO                           
              ,REVISION                                     
              ,PLANT                            
              ,ALTERNATIVE                               
              ,FRAME_ID                         
              ,ISSUED_DATE                                    
              ,MAINPART                          
              ,MAINREVISION                                 
              ,MAINPLANT                        
              ,MAINALTERNATIVE
              )
              values
              (l_related_tyre_log_id
              ,l_tech_log_calc_date
              ,TO_DATE(l_str_min_startdatum_van,'dd-mm-yyyy hh24:mi:ss')   
              ,r_nw_part_revision_weight.part_no
              ,r_nw_part_revision_weight.revision
              ,r_nw_part_revision_weight.plant
              ,r_nw_part_revision_weight.alternative
              ,r_nw_part_revision_weight.frame_id
              ,r_nw_part_revision_weight.issued_date
              ,NULL
              ,NULL
              ,NULL
              ,NULL
              );
              --
              COMMIT;
              --
        exception
          when others
          then null;              
        end;      
        --Ieder voorkomen in NW-PART-REVISION-WEIGHT is NIEUW + heeft een GEWICHTSWIJZIGING ondergaan !!!!
        --Indien NEW-REVISION-WEIGHT = TYRE dan kunnen we deze direct toevoegen aan ARRAY...
        if r_nw_part_revision_weight.sap_part_tyre_ind = 'J' 
        then
           --p_add_part_not_exists (p_part_no=>r_nw_part_revision_weight.PART_NO 
           --                      ,p_revision=>r_nw_part_revision_weight.REVISION 
           --                      ,p_alternative=>r_nw_part_revision_weight.ALTERNATIVE); 
           begin
             --<insert log-record...>
             select DBA_WEIGHT_RELTYRE_LOG_SEQ.nextval into l_related_tyre_log_id from dual;
             --
             insert into DBA_WEIGHT_RELATED_TYRE_LOG
                (ID                                  
                ,TECH_CALCULATION_DATE                          
                ,DATUM_VERWERKING                       
                ,PART_NO                           
                ,REVISION                                     
                ,PLANT                            
                ,ALTERNATIVE                               
                ,FRAME_ID                         
                ,ISSUED_DATE                                    
                ,MAINPART                          
                ,MAINREVISION                                 
                ,MAINPLANT                        
                ,MAINALTERNATIVE
                ,MAINFRAMEID
                )
                values
                (l_related_tyre_log_id
                ,l_tech_log_calc_date
                ,TO_DATE(l_str_min_startdatum_van,'dd-mm-yyyy hh24:mi:ss')
                ,r_nw_part_revision_weight.part_no
                ,r_nw_part_revision_weight.revision
                ,r_nw_part_revision_weight.plant
                ,r_nw_part_revision_weight.alternative
                ,r_nw_part_revision_weight.frame_id
                ,r_nw_part_revision_weight.issued_date
                ,r_nw_part_revision_weight.part_no        --mainpart
                ,r_nw_part_revision_weight.revision
                ,r_nw_part_revision_weight.plant
                ,r_nw_part_revision_weight.alternative
                ,r_nw_part_revision_weight.frame_id
                );
                --
                COMMIT;
                --
              exception
                when others
                then 
                  dbms_output.put_line('EXCP-INSERT SKIP PART=TYRE: '||r_nw_part_revision_weight.PART_NO||':'||r_nw_part_revision_weight.REVISION||' alt: '||r_nw_part_revision_weight.ALTERNATIVE );
                  RAISE;
              end;                                 
        else   
          --INDIEN HET GEEN BAND MAAR EEN COMPONENT BETREFT MOETEN WE EERST BEPALEN WELKE TYRES ER AAN COMPONENT-RELATED ZIJN 
          --Voor alle aan GEWICHTSGEWIJZIGDE COMPONENT-PARTS RELATED-TYRES moet dus een volledig nieuwe berekening volgen...!!!!
          --SELECT ALLEEN TYRES GERELATEERD AAN ACTUELE-FRAME-ID:
          --
          --R-PART-TYPE GEBRUIKT MV OM RELATED-TYRES TE VINDEN:
          for r_part_tyre in c_part_tyre ( r_nw_part_revision_weight.part_no )
          loop
            l_teller := l_teller + 1;
            --dbms_output.put_line('GERELATEERDE-TYRE-'||l_teller||': '||r_part_tyre.MAINPART||':'||r_part_tyre.MAINREVISION||' alt: '||r_part_tyre.MAINALTERNATIVE );
            --eerst controle van TYRE-MAINPART-NO op FRAME-ID...(deze zit nl. niet in de R_NW_PART_REVISION-cursor...
            begin
              --Indien gewicht afwijkt gaan we hierna voor alle gerelateerde tyres, ook voor ALLE COMPONENTS nieuwe gewichten berekenen...
              --if r_part_tyre.mainpart in ('XGF_G19C052B','XGF_2454519QPREVB1' )
              --then dbms_output.put_line('TOEVOEGEN-TYRE '||r_part_tyre.mainpart||' dmv '||r_nw_part_revision.part_no||'-'||r_tyre_frame_id.frame_id); 
              --end if; 
              --hier vullen van internal-table R_TYRE_FRAME_ID...
              --debugging om te checken waarom deze er via component=EM_774 in komen te staan...Zou niet moeten kunnen... 
              if r_part_tyre.mainpart in ('GF_1656015QT6NH')
              then dbms_output.put_line('TOEVOEGEN-TYRE '||r_part_tyre.mainpart||'-'||r_part_tyre.mainframeid||' dmv '||r_nw_part_revision_weight.part_no||' obv comp-part: '||r_nw_part_revision_weight.part_no||'-'||r_nw_part_revision_weight.revision);
              end if;
              --
              --p_add_part_not_exists (p_part_no=>r_part_tyre.mainpart
              --                      ,p_revision=>r_part_tyre.mainrevision
              --                      ,p_alternative=>r_part_tyre.mainalternative); 
              --TOEVOEGEN AAN LOG-TABEL...
              begin
                --<insert log-record...>
                select DBA_WEIGHT_RELTYRE_LOG_SEQ.nextval into l_related_tyre_log_id from dual;
                --
                insert into DBA_WEIGHT_RELATED_TYRE_LOG
                (ID                                  
                ,TECH_CALCULATION_DATE                          
                ,DATUM_VERWERKING                          
                ,PART_NO                           
                ,REVISION                                     
                ,PLANT                            
                ,ALTERNATIVE                               
                ,FRAME_ID                         
                ,ISSUED_DATE                                    
                ,MAINPART                          
                ,MAINREVISION                                 
                ,MAINPLANT                        
                ,MAINALTERNATIVE
                ,MAINFRAMEID
                )
                values
                (l_related_tyre_log_id
                ,l_tech_log_calc_date
                ,TO_DATE(l_str_min_startdatum_van,'dd-mm-yyyy hh24:mi:ss')
                ,r_nw_part_revision_weight.part_no
                ,r_nw_part_revision_weight.revision
                ,r_nw_part_revision_weight.plant
                ,r_nw_part_revision_weight.alternative
                ,r_nw_part_revision_weight.frame_id
                ,r_nw_part_revision_weight.issued_date
                ,r_part_tyre.mainpart
                ,r_part_tyre.mainrevision
                ,r_part_tyre.mainplant
                ,r_part_tyre.mainalternative
                ,r_part_tyre.mainframeid
                );
                --
                COMMIT;
                --
              exception
                when others
                then null;
              end;
            exception
              when others 
              then 
                --Het is niet het juiste FRAME-ID... Wordt niet meegenomen in de gewichtberekening
                dbms_output.put_line('FRAME-ID NOT CORRECT, SKIP PART=TYRE: '||r_nw_part_revision_weight.PART_NO||':'||r_nw_part_revision_weight.REVISION||' alt: '||r_nw_part_revision_weight.ALTERNATIVE );
                --dbms_output.put_line('FRAME-ID NOT CORRECT, SKIP PART=TYRE: '||r_nw_part_revision_weight.PART_NO||':'||r_nw_part_revision_weight.REVISION||' alt: '||r_nw_part_revision_weight.ALTERNATIVE||' FRAME: '||l_sap_frame_ID );
                raise;
            end;
            --
          end loop;   --r_part_tyre
          --
        end if;   --new-tyre-sap 
        --
      end loop;   --r_nw_part_revision_weight
      --
      --
      --
      --
  --*****************************************************************************************
  -- ALLE HULPTABELLEN STAAN NU KLAAR:
  -- 1)ALLE NIEUWE PARTS MET NIEUWE ISSUED_DATE IN TABEL DBA_WEIGHT_NEW_REV_LOG
  -- 2)ALLE RELATED TYRES MET JUISTE FRAME-ID IN TABEL   DBA_WEIGHT_RELATED_TYRE_LOG
  --*****************************************************************************************
  --Start HOOFD-LOOP over FRAME-ID
  --WE VERWERKEN PER FRAME-ID uit VIEW=AV_BHR_BOM_TYRE_PART_NO de aanwezig TYRE-PART-NO !!! 
  --OOK OP DIE MANIER BIJGEHOUDEN IN STUURTABEL !!!
  --STAPPEN:
  -- 0)PER FRAME-ID
  -- 1)VUL STUURTABEL DBA_SYNC_BESTURING_WEIGHT_SAP
  -- 2)VUL INTERNE-ARRAY MET ALLE RELATED-TYRES VAN DIT FRAME UIT DBA_WEIGHT_RELATED_TYRE_LOG IN INTERNE-ARRAY
  -- 3)BEREKEN VOOR ALLE TYRES IN INTERNE-ARRAY HET GEWICHT (INCL. ALLE ONDERLIGGENDE COMPONENTEN)
  --*****************************************************************************************
  FOR r_tyre_frame_id in c_tyre_frame_id ( l_header_frame_id )
  LOOP
    --init
    l_str_startdatum_van    := null;
    l_str_startdatum_tm     := null;
    l_verwerkt_aantal_tyres := 0; 
    l_tmp_teller := TyrePartList.count;
    if l_tmp_teller > 0 
    then TyrePartList.delete;
    end if;
    --
    begin   
      --van. max-calc-datum uit tabel 
      --select to_char( max(dwc.tech_calculation_date), 'dd-mm-yyyy hh24:mi:ss' ) into l_str_startdatum_van from dba_weight_component_part dwc ;
      SELECT sbw_mut_verwerking_aan
      ,      sbw_sync_periode_dagen
      ,      to_char( (SBW.SBW_DATUM_VERWERKT_TM+1/(24*60*60)), 'dd-mm-yyyy hh24:mi:ss' ) 
	    into l_mut_verwerking_aan_ind
      ,    l_mut_sync_periode_dagen
      ,    l_str_startdatum_van 
      from DBA_SYNC_BESTURING_WEIGHT_SAP SBW 
      WHERE sbw.id = (select max(sbw2.id) from DBA_SYNC_BESTURING_WEIGHT_SAP SBW2 where sbw2.sbw_selected_frame_id = r_tyre_frame_id.frame_id ) 
      and   sbw.sbw_selected_frame_id = r_tyre_frame_id.frame_id    --we gaan per FRAME-ID nu de mutaties-verwerken
      AND   sbw.sbw_datum_verwerkt_tm is not null                   --indien deze NULL is, dan loopt er nog een andere sessie, en starten we niet een nieuwe op!!!
      ;
      dbms_output.put_line('UITVRAGEN-STUURTABEL verwerkingperiode van: '||l_str_startdatum_van);
    exception
      when others 
      then rollback;
           --l_str_startdatum_van := to_char( (trunc(sysdate)-1), 'dd-mm-yyyy hh24:mi:ss') ;
           dbms_output.put_line('EXCP-UITVRAGEN-STUURTABEL verwerkingperiode van: '||l_str_startdatum_van||'-'||sqlerrm);
    END;
    --tm. eind ALTIJD tm. EINDE van de vorige WERKELIJKE dag tov SYSDATE:
    --l_str_startdatum_tm := to_char( (trunc(sysdate)), 'dd-mm-yyyy' )||' 23:59:59';
    --We gaan toch weer over naar VERWERKING TOT/MET SYSDATE (in loop van FRAME-ID kan het dus voorkomen dat Verwerkingsperiodese elkaar opvolgen)
    --Dit is wel gedaan om OOK onafhankelijke FRAME-ID-verwerkingen aan te kunnen.
    l_str_startdatum_tm    := to_char( sysdate, 'dd-mm-yyyy hh24:mi:ss' );
    --l_str_MV_startdatum_tm 
    --
    dbms_output.put_line('verwerkingperiode van: '||l_str_startdatum_van||' t/m '||l_str_startdatum_tm);
    --
    if upper(l_mut_verwerking_aan_ind) = 'J'
    then
      begin
	      --insert nieuwe verwerkingsregel in SYNC-BESTURING-tabel
        --De velden VERWERKT-TM + AANTAL-TYRES vullen met UPDATE achteraf !!!!
        select dba_weight_calc_seq.nextval into l_sync_id from dual;
        --
        insert into DBA_SYNC_BESTURING_WEIGHT_SAP
        ( ID
	      , SBW_MUT_VERWERKING_AAN 
        , SBW_SYNC_PERIODE_DAGEN
        , SBW_DATUM_VERWERKT_VANAF
        , SBW_DATUM_VERWERKT_TM
        , SBW_AANTAL_TYRES 
        , SBW_DATUM_ONTLADEN_SAP_TM
        , SBW_SYNC_TYPE
        , SBW_SELECTED_FRAME_ID
        , SBW_TECH_CALCULATION_DATE
        )
        values (l_sync_id
	             ,l_mut_verwerking_aan_ind
	             ,l_mut_sync_periode_dagen
        			 ,to_date(l_str_startdatum_van,'dd-mm-yyyy hh24:mi:ss')
        			 ,to_date(null)
        			 ,0
        			 , to_date(null)
               ,'MUTATIE' 
               ,r_tyre_frame_id.frame_id    --A_PCR, E_AT, etc
               ,l_tech_log_calc_date   --gelijk aan verwerkingsdatum REV-LOG/RELATED-TYRES-LOG
        			 );
	      --********************************
        commit;
	      --********************************
        --dbms_output.put_line('STUURTABEL-RECORD TOEGEVOEGD met ID =' ||l_sync_id);
        --
      exception
        when others 
        then rollback;
          --l_str_startdatum_van := to_char( (trunc(sysdate)-1), 'dd-mm-yyyy hh24:mi:ss') ;
          dbms_output.put_line('EXCP-INSERT-STUURTABEL verwerkingperiode van: '||l_str_startdatum_van||'-'||sqlerrm);
      End; 
      --*********************************************************
      -- HIER DE INTERNE-ARRAY PER FRAME-ID GAAN VULLEN...
      --*********************************************************
      --LOOP OVER INHOUD VAN DBA_WEIGHT_RELATED_TYRE_LOG 
      --  WHERE SAP_TYRE_IND='J' AND MAINFRAMEID=TYRE-FRAME-ID AND WEIGHT-CHANG-IND='J' AND TECH-CALCULATION-DATE=LOG-DATE
      --let op: IN TABEL DBA_WEIGHT_RELATED_TYRE_LOG KOMT TYRE MET ORIGINELE FRAME-ID VOOR, MOET DUS EERST WORDEN
      --        OMGEZET NAAR BESTURING-FRAME-ID (indien een vorm van A_PCR)!! Anders wordt tyre niet meegenomen in verwerking...
      open c_sel_part_revision_weight 
      for 
      SELECT DISTINCT dwl.mainpart
      ,      dwl.mainrevision
      ,      dwl.mainalternative
      ,      dwl.mainframeid
      FROM DBA_WEIGHT_RELATED_TYRE_LOG dwl
      WHERE dwl.tech_calculation_date = l_tech_log_calc_date    --to_date(l_str_tech_log_calc_date,'dd-mm-yyyy hh24:mi:ss')
      and  decode(dwl.mainframeid,'A_PCR_VULC v1','A_PCR', 'A_PCR_v1','A_PCR', 'A_PCR_v2','A_PCR', dwl.mainframeid) = r_tyre_frame_id.frame_id 
      --and   dwl.mainframeid = r_tyre_frame_id.frame_id 
      ;
      loop
        fetch c_sel_part_revision_weight into l_sel_mainpart
                                             ,l_sel_mainrevision
                                             ,l_sel_mainalternative
                                             ,l_sel_mainframeid;
        dbms_output.put_line('mainpart: '||l_sel_mainpart);
        if (c_sel_part_revision_weight%notfound)   
        then CLOSE c_sel_part_revision_weight;
	           exit;
	      end if;
        --
        p_add_part_not_exists (p_part_no=>l_sel_mainpart 
                              ,p_revision=>l_sel_mainrevision 
                              ,p_alternative=>l_sel_mainalternative ); 
        --                                    
      end loop;
      --
      --
      /*
      for r_nw_part_revision        in c_nw_part_revision (l_str_startdatum_van, l_str_startdatum_tm )
      loop
        l_part_tyre_ind := 0;
        --dbms_output.put_line('r_nw_part: '||r_nw_part_revision.PART_NO||':'||r_nw_part_revision.REVISION||' issued-date: '||r_nw_part_revision.issued_date||' frame: '||r_nw_part_revision.FRAME_ID );
        --*********************************
        --Check of het al een TYRE is...
        --*********************************
        --In dat geval kunnen we tyre al direct in ARRAY opnemen.
        --LET OP: Er zitten TYRES in systeem die vroeger als component bij een andere band voorkwamen. Deze zijn wel HISTORIC maar zitten nog wel in BOM-ITEM. Wat hiermee te doen...????
        begin
          select count(*)
          into   l_part_tyre_ind
          from  specification_header sh
          where sh.part_no  = r_nw_part_revision.part_no
          and   sh.revision = r_nw_part_revision.revision
          --and   sh.frame_id like r_tyre_frame_id.frame_id||'%'     --A_PCR% ook voorophalen A_PCR_VULC_v1 etc.
          --Extra check op de AV_BHR_BOM_TYRE_PART_NO omdat er ook nog componenten bestaan met een FRAME-ID gelijk aan TYRE-FRAME-ID
          --Deze moeten worden uitgesloten voor deze TYRE-controle...
          and   sh.part_no in (--Hierin zit FRAME-ID en PLANT (EF/GT) en Finished-product=EF
                               select av.PART_NO     
                               from av_bhr_bom_tyre_part_no   av
                               WHERE  av.part_no = sh.part_no
                               AND    av.frame_id like r_tyre_frame_id.frame_id||'%' 
                              )
          ;
    	  exception
	        when others then l_part_tyre_ind := 0;
    	  end;
	      --Afhankelijk van component/tyre vullen we ARRAY.
        if nvl(l_part_tyre_ind,0) > 0
        then
          --PART = TYRE, MET JUISTE FRAME-ID, direct opvoeren:
          l_teller := l_teller + 1;
          --dbms_output.put_line('PART=TYRE-'||l_teller||': '||r_nw_part_revision.PART_NO||':'||r_nw_part_revision.REVISION||' alt: '||r_nw_part_revision.ALTERNATIVE );
          --eerst controle op FRAME-ID...(deze zit nl. niet in de R_NW_PART_REVISION-cursor...
          begin
            if r_nw_part_revision.revision = 1
            then
              l_teller := l_teller + 1;
              --TYRE heeft NEW-REVISION=1. Altijd direct gewicht berekenen!!
              --hier direct vullen van internal-table met TYRE-PART-NO...
              --debugging om te checken waarom deze er via component=EM_774 in komen te staan...Zou niet moeten kunnen... 
              --if r_nw_part_revision.PART_NO  in ('EF_Y285/30R19UVPX','EF_Y265/45R20UVPX')
              --then dbms_output.put_line('TOEVOEGEN-REV-1-TYRE '||r_nw_part_revision.PART_NO||' dmv '||r_nw_part_revision.part_no||'-'||r_tyre_frame_id.frame_id||' obv comp-part: '||r_nw_part_revision.part_no||'-'||r_nw_part_revision.revision);
              --end if;
              p_add_part_not_exists (p_part_no=>r_nw_part_revision.PART_NO 
                                    ,p_revision=>r_nw_part_revision.REVISION 
                                    ,p_alternative=>r_nw_part_revision.ALTERNATIVE); 
            else
              --Er is nieuwe TYRE-revision bijgekomen. Nu is het maar de vraag of het gewicht gewijzigd is.
              --Dat gaan we nu eerst controleren.
              l_check_part_changed_weight := 'FALSE';
              l_check_part_changed_weight := fnc_check_part_changed_weight (p_part_no=>r_nw_part_revision.part_no
                                                                           ,p_revision=>r_nw_part_revision.revision
                                                                           ,p_alternative=>r_nw_part_revision.alternative);
              --  
              if l_check_part_changed_weight = 'TRUE'                                                                       
              then 
                l_teller := l_teller + 1;                                        
                --Er is een gewichtsberekening NOODZAKELIJK. GEWICHT VAN COMPONENT IS GEWIJZIGD. 
                --Neem PART-TYRE op in ARRAY-te-verwerken-TYRES                               
                p_add_part_not_exists (p_part_no=>r_nw_part_revision.PART_NO 
                                    ,p_revision=>r_nw_part_revision.REVISION 
                                    ,p_alternative=>r_nw_part_revision.ALTERNATIVE);
              end if;                                          
            end if;                                                                           
            --if r_nw_part_revision.part_no='EM_774'
            --then dbms_output.put_line('Result CHECK-PART_CHANGED-WEIGHT: '||l_check_part_changed_weight);
            --end if;                                                                        
            --
          exception
	          when others 
            then 
              --Het is niet het juiste FRAME-ID... Wordt niet meegenomen in de gewichtberekening
              dbms_output.put_line('FRAME-ID NOT CORRECT, SKIP PART=TYRE: '||r_nw_part_revision.PART_NO||':'||r_nw_part_revision.REVISION||' alt: '||r_nw_part_revision.ALTERNATIVE||' FRAME: '||l_sap_frame_ID );
          end;
          --
	      else
          --nvl(l_part_tyre_ind,0) = 0
          --BOM-HEADER = COMPONENT-PART: 
          --dbms_output.put_line('r_nw_part: '||r_nw_part_revision.PART_NO||':'||r_nw_part_revision.REVISION||' issued-date: '||r_nw_part_revision.issued_date||' frame: '||r_nw_part_revision.FRAME_ID );
          --Het komt voor dat we wel nieuwe REVISION hebben, maar dat het voor gewichtsberekening niets uitmaakt. 
          --In dit geval namen we gerelateerde TYRES toch gewoon me in de controle/berekening, maar uit efficiency-overwegingen
          --is het toch handiger om deze al op voorhand eruit te filteren. We doen anders teveel overbodige weight-calculations !!!
          l_check_part_changed_weight := 'FALSE';
          l_check_part_changed_weight := fnc_check_part_changed_weight (p_part_no=>r_nw_part_revision.part_no
                                                                       ,p_revision=>r_nw_part_revision.revision
                                                                       ,p_alternative=>r_nw_part_revision.alternative);
          --if r_nw_part_revision.part_no='EM_774'
          --then dbms_output.put_line('Result CHECK-PART_CHANGED-WEIGHT: '||l_check_part_changed_weight);
          --end if;                                                                        
          --
          if l_check_part_changed_weight = 'TRUE'                                                                       
          then                                         
            --Er is een gewichtsberekening NOODZAKELIJK. GEWICHT VAN COMPONENT IS GEWIJZIGD. 
            --Neem PART-TYRE op in ARRAY-te-verwerken-TYRES
            --(BOM-HEADER = COMPONENT-PART, GA HIER EERST ALLE GERELATEERDE TYRES VOOR BIJ ZOEKEN
            -- OP TYRE ZIT UITEINDELIJK IN DE CURSOR INCLUSIEF EEN SAP-CONTROLE...)
            for r_part_tyre in c_part_tyre ( r_nw_part_revision.part_no, r_tyre_frame_id.frame_id)
            loop
              l_teller := l_teller + 1;
              --dbms_output.put_line('GERELATEERDE-TYRE-'||l_teller||': '||r_part_tyre.MAINPART||':'||r_part_tyre.MAINREVISION||' alt: '||r_part_tyre.MAINALTERNATIVE );
              --
              --eerst controle van TYRE-MAINPART-NO op FRAME-ID...(deze zit nl. niet in de R_NW_PART_REVISION-cursor...
              begin
                --Indien gewicht afwijkt gaan we hierna voor alle gerelateerde tyres, ook voor ALLE COMPONENTS nieuwe gewichten berekenen...
                --if r_part_tyre.mainpart in ('XGF_G19C052B','XGF_2454519QPREVB1' )
                --then dbms_output.put_line('TOEVOEGEN-TYRE '||r_part_tyre.mainpart||' dmv '||r_nw_part_revision.part_no||'-'||r_tyre_frame_id.frame_id); 
                --end if; 
                --hier vullen van internal-table R_TYRE_FRAME_ID...
                --debugging om te checken waarom deze er via component=EM_774 in komen te staan...Zou niet moeten kunnen... 
                if r_part_tyre.mainpart in ('GF_1656015QT6NH')
                then dbms_output.put_line('TOEVOEGEN-TYRE '||r_part_tyre.mainpart||'-'||r_tyre_frame_id.frame_id||' dmv '||r_nw_part_revision.part_no||' obv comp-part: '||r_nw_part_revision.part_no||'-'||r_nw_part_revision.revision);
                end if;
                --
                p_add_part_not_exists (p_part_no=>r_part_tyre.mainpart
                                      ,p_revision=>r_part_tyre.mainrevision
                                      ,p_alternative=>r_part_tyre.mainalternative); 
              exception
	              when others 
                then 
                  --Het is niet het juiste FRAME-ID... Wordt niet meegenomen in de gewichtberekening
                  dbms_output.put_line('FRAME-ID NOT CORRECT, SKIP PART=TYRE: '||r_nw_part_revision.PART_NO||':'||r_nw_part_revision.REVISION||' alt: '||r_nw_part_revision.ALTERNATIVE||' FRAME: '||l_sap_frame_ID );
              end;
    		      --
            end loop;   --r_part_tyre
            --
          else
            null;
            --dbms_output.put_line('GEEN GEWICHTSWIJZIGING PART-NO: '||r_nw_part_revision.part_no||' rev: '||r_nw_part_revision.revision||' alt: '||r_nw_part_revision.alternative);
          end if;  --f_check_part_changed_weight
          --
        end if; --part=tyre
	      --
      end loop;  --r_nw_part_revision
      */
      --
      --********************************************************************************************************************** 
      --********************************************************************************************************************** 
      --********************************************************************************************************************** 
      --DBMS_OUTPUT.PUT_LINE('NA loop gewijzigde parts, ROEP voor alle ARRAY-PARTS dba_bepaal_comp_part_gewicht aan...');
      --loop door VARRAY om GEWICHTEN TE BEREKENEN...
      --LET OP: het kan zijn dat een ALTERNATIVE=2 component is gewijzigd, de daarbij behorende finished-products/tyres worden geselecteerd
      --        maar de gewichtsberekening uiteindelijk toch maar alleen via de PREFERRED=1 (en dus meestal via ALTERNATIVE=1) verloopt !!!!
      --        De ALTERNATIVE=2-components zullen op deze manier dus (nog) NIET in de tabel DBA_WEIGHT_COMPONENT_PARTS worden geinsert.
      --********************************************************************************************************************** 
      --********************************************************************************************************************** 
      --********************************************************************************************************************** 
      l_verwerkt_aantal_tyres := TyrePartList.count;
      dbms_output.put_line('Sync-id: '||l_sync_id||' Frame-id: '||r_tyre_frame_id.frame_id||' Aantal te verwerken TyrePartList: '||l_verwerkt_aantal_tyres);
      --
      if TyrePartList.count > 0
      then
        for i in TyrePartList.first..TyrePartList.last
        loop
          --aanroep procedure DBA_BEPAAL_COMP_PART_GEWICHT  (geen LOGGING, wel INSERT-VERWERKING-tabel)
          --dba_bepaal_comp_part_gewicht(p_header_part_no=>TyrePartList(i).part_no
          --                           ,p_header_revision=>TyrePartList(i).revision
          --                            ,p_alternative=>TyrePartList(i).alternative
          --                            ,p_show_incl_items_jn=>'N' 
          --                            ,p_insert_weight_comp_jn=>'J' );    
          bepaal_MV_comp_part_gewicht(p_header_part_no=>TyrePartList(i).part_no
                                      ,p_header_revision=>TyrePartList(i).revision
                                      ,p_alternative=>TyrePartList(i).alternative
                                      ,p_show_incl_items_jn=>'N' 
                                      ,p_insert_weight_comp_jn=>'J' );    
          --   
          dbms_output.put_line('Frame: '||r_tyre_frame_id.frame_id||' header-part-no: '||TyrePartList(i).part_no||' revision: '||TyrePartList(i).revision||' alternative: '||TyrePartList(i).alternative||' COMPLETED...');
          --Na iedere 10-part-no werken we stuurtabel bij...	
          if upper(l_mut_verwerking_aan_ind) = 'J'
          AND mod(i,10)=0
          then
            BEGIN
              --WERK eindstand bij:
              UPDATE DBA_SYNC_BESTURING_WEIGHT_SAP 
        	    set  SBW_AANTAL_TYRES      = i
      	      WHERE id = l_sync_id 
      	      ;
              --************** 
      	      COMMIT;
      	      --**************
            EXCEPTION
              when OTHERS 
              then rollback;
                   --Dbms_output.put_line('EXCP-UPDATE-STUURTABEL-VOORTGANG-TELLER , SYNC-ID: '||l_sync_id||' VERWERKT-TM: '||l_str_startdatum_tm||' aantal tyres: '||l_teller||'-'||sqlerrm );
            END;
          end if;
        end loop;  --TyrePartList 
      end if;
      --
      BEGIN
        --WERK eindstand bij:
        UPDATE DBA_SYNC_BESTURING_WEIGHT_SAP 
    	  set  SBW_DATUM_VERWERKT_TM = to_date(l_str_MV_startdatum_tm,'dd-mm-yyyy hh24:mi:ss')
    	  ,    SBW_AANTAL_TYRES      = l_verwerkt_aantal_tyres
    	  WHERE id = l_sync_id 
    	  ;
        --**************
        COMMIT;
        --**************
      EXCEPTION
        when OTHERS 
        then
          rollback;
          dbms_output.put_line('EXCP-UPDATE-STUURTABEL, SYNC-ID: '||l_sync_id||' VERWERKT-TM: '||l_str_startdatum_tm||' aantal tyres: '||l_verwerkt_aantal_tyres||'-'||sqlerrm );
      END;
      DBMS_OUTPUT.PUT_LINE('NA loop gewicht-berekening #parts: '||l_verwerkt_aantal_tyres);
      l_einddatum := sysdate;
      l_duur_minuut := ( l_einddatum - l_startdatum ) * 24 * 60;
      dbms_output.put_line('Uitvragen van hulptabel DBA_WEIGHT_COMPONENT_PART, aantal: '||l_teller||' duur(min): '||l_duur_minuut);
      dbms_output.put_line('SELECT * FROM DBA_WEIGHT_COMPONENT_PART where  tech_calculation_date > trunc(sysdate)-1 order by id;');
      --
    else
      --verwerking is HANDMATIG uitgezet...PROCES STOPT
      DBMS_OUTPUT.PUT_LINE('PROCES STOPT, MUTATIE-VERWERKING GEWICHTEN-SAP STAAT UIT !! (zie DBA_SYNC_BESTURING_WEIGHT_SAP.SBW_MUT_VERWERKING_AAN) ');
    end if;  --mut-verwerking-aan
    --
  end loop; --END HOOFDLOOP r_tyre_frame_id
  --
  --
END DBA_VERWERK_GEWICHT_MUTATIES;
--
--
--LET OP: ALLEEN HANDMATIG STARTEN INDIEN VOLLEDIGE NIEUWE LOAD VAN STUURTABEL + DBA_WEIGHT_COMPONENT_PART NODIG IS !!!!
procedure AANROEP_VUL_INIT_PART_GEWICHT (p_header_part_no        varchar2   default 'ALLE' 
                                        ,p_header_frame_id       varchar2   default 'ALLE' 
                                        ,p_aantal                number     default 999999999
                                        ,p_show_incl_items_jn    varchar2   default 'N' 
                                        ,p_insert_weight_comp_jn varchar2   default 'J'			)
DETERMINISTIC
AS
--LET OP: DIT IS INTIELE PROCES VOOR BEREKENEN VAN ALLE COMPONENT-PARTS ALLE BOM-HEADER/TYRES . 
--MET DEFAULT-PARAMETER-waardes wordt een VOLLEDIGE INITIELE-LOAD-BEREKENING van alle A_PCR-banden uitgevoerd !!!!!
--(geregeld via de input-view AV_BHR_BOM_TYRE_PART_NO waar de juiste selectie-criteria in vastgelegd zijn)
--en komt nieuwe BASIS-STUUR-regel in stuurtabel DBA_SYNC_BESTURING_WEIGHT_SAP te staan, waarmee dagelijkse 
--MUTATIE-VERWERKING verder mee kan...
--Dus:   exec DBA_AANROEP_COMP_PART_GEWICHT;      --berekend gewicht voor alle part-no van ENSCHEDE + HONGARY !!
--
--NA EEN HANDMATIGE INITIELE LOAD, KAN PROCES AUTOMATISCH VIA JOB "VERWERK_GEWICHT_MUTATIES" DAGELIJKS WORDEN BIJGEHOUDEN !!!!
--
--Voor alle COMPONENT-PARTS wordt vervolgens APART de Eenheid-WEIGHT van deze COMPONENT-PART berekend. Dus LOOP in een LOOP !
--Dit is de basis voor WEIGHT-CALCULATION voor ieder BOM-HEADER/COMPONENT tbv SAP-INTERFACE.
--Het gewicht wordt hier berekend uitgaande van 1 x EENHEID van een COMPONENT-PART. 
--Dat is anders dan de gewichten die berekend worden vanuit een BOM_HEADER_GEWICHT die vanuit een band 
--van alle onderliggende componenten de gewichten berekend. 
--
--Selectie-criteria: Selectie vind plaats op view AV_BHR_BOM_HEADER_PART_NO.
--                   OBV: - part-no met status-type="CURRENT"
--
--Parameters:  P_PART_NO = bom-item-header, Indien leeg, dan krijgt waarde='ALLE' !!!!
--                         part-no kan volledig part-no zijn (zonder %), een substring (met %) of waarde=ALLE bevatten.
--                         Kan ook als FILTER gebruikt worden, ook met SUBSTRING van een PART-NO:
--                                          bijv.  EF_H215/60R16SP5X (controleer alleen header-spec = EF_H215/60R16SP5X)
--                                                 EF%               (controleer alle header-specs beginnend met EF%) 
--                                                 GF%               (controleer alle header-specs beginnend met GF%) 
--                                                 EF_Y245%          (controleer alle header-specs beginnend met EF_Y245)
--
--             P_FRAME_ID = frame-id, Indien leeg, dan krijgt waarde='ALLE' !!!!
--                          Frame-id mag alleen waarde ALLE/<null> of volledig frame-id bevatten
--                          Waarde = ALLE, dan worden alle FRAME-ID's uit view "AV_BHR_BOM_TYRE_PART_NO" gebruikt !!!
--                          Dus bijv. A_PCR (part-no like EF, GF, XGF), en A_TBR (part_no=GF,XGF)
--                          In deze VIEW wordt dus al een SELECTIE gemaakt vanuit welke PLANT (Enschede/Gyongios) geselecteerd worden !!!
--                          kan ook als filter gebruikt worden maar ALLEEN MET VOLLEDIG FRAME-ID, NIET MET SUBSTRING !!!!
--                                          bijv.  A_PCR             (controleer alle header-specs van type frame=A_PCR)
--
--             P_AANTAL = aantal rows output. Indien leeg dan krijgt waarde=999999999
--                        Dit is alleen voor testdoeleinden, en werkt alleen bij gebruik van WILDCARDS/'ALLE' in partno of sap-no !!
--                        Als je 1 specifieke band met PARTNO/SAPNO opvraagt zal resultaat altijd maar 1 zijn.
--
--             P_SHOW_INCL_ITEMS_JN = J=Ja, N=Nee. Indien leeg dan krijgt waarde='N'
--                                    Indien "J" dan tonen van de componenten in de BOM-HEADER-STRUCTURE vanuit procedure DBA_BEPAAL_COMP_PART_GEWICHT !!!
--
--             P_INSERT_WEIGHT_COMP_JN = J=Ja, N=Nee. Indien leeg dan krijgt waarde='J'
--                                       J = INSERT van alle component-parts (resultaat van DBA_BEPAAL_BOM_HEADER_GEWICHT) in DBA_WEIGHT_COMPONENT_PART.
--                                           Indien aangeroepen vanuit DBA_AANROEP_BEPAAL_COMP_PART_GEWICHT dan ALTIJD INSERTEN van resultaten in VERWERKINGSTABEL !!!!!
--                                       N = geen output weggeschreven naar DBA_WEIGHT_COMPONENT_PART, alleen testing/logging !!! 
--                                           Indien direct aangeroepen voor test-doeleinden, dan resultaat niet altijd wegschrijven naar VERWERKING-TABEL !
--                                                 
--dependencies: FUNCTIE DBA_BEPAAL_QUANTITY_KG: functie om de quantity-string te vermenigvuldiger met PART-NO-BASE-QUANTITY 
--                                              om uiteindelijk het gewicht van BOM-HEADER obv MATERIALS-gewichten te berekenen.
--                                              Indien aangeroepen vanuit deze aanroep-procedure wordt er ALLEEN totaal-gewicht bepaald.
--              FUNCTIE DBA_BEPAAL_BOM_HEADER_GEWICHT: functie om per BOM-HEADER het gewicht te berekenen obv onderliggende component-parts.
--                                                     Dit vanuit 1xEenheid van bom-header.
--
--OUTPUT: Via de procedure DBA_BEPAAL_COMP_PART_GEWICHT wordt het gewicht per COMPONENT-PART berekend en in tabel DBA_WEIGHT_COMPONENT_PART gezet!!!
--
--voorbereiden initial-load:
--SELECT COUNT(*) FROM DBA_WEIGHT_COMPONENT_PART;
--TRUNCATE table DBA_WEIGHT_COMPONENT_PART;
--run totaal:
--exec AANROEP_VUL_INIT_PART_GEWICHT('ALLE', 'ALLE');     --haal alle A_PCR/A_TBR partno voor Enschede/Gyongios op mbv AV_BHR_BOM_TYRE_PART_NO
--of run in 2 stappen:
--exec AANROEP_VUL_INIT_PART_GEWICHT('ALLE', 'A_PCR');    --haal alle A_PCR partno voor Enschede/Gyongios op mbv AV_BHR_BOM_TYRE_PART_NO
--exec AANROEP_VUL_INIT_PART_GEWICHT('ALLE', 'A_TBR');    --haal alle A_TBR partno voor Gyongios op mbv AV_BHR_BOM_TYRE_PART_NO
--
--AD-HOC Aanroep-voorbeelden tijdens ontw/test:
-- 1) exec AANROEP_VUL_INIT_PART_GEWICHT('EF_H215/60R16SP5X', null    , null, 'J','N' );   --haal alleen specifiek part-no op
-- 2) exec AANROEP_VUL_INIT_PART_GEWICHT('EF_H215/60R16SP5X', null    , 1, 'J','N');       --haal alleen specifiek part-no op
-- 3) exec AANROEP_VUL_INIT_PART_GEWICHT('EF_H215/60R16SP5X', null    , 10, 'J','N');      --haal vanaf specifiek part-no ook de volgende 9 part-no op.
-- 4) exec AANROEP_VUL_INIT_PART_GEWICHT('ALLE'             , 'A_PCR' , null, 'J','N');    --haal alle part-no van A_PCR op
-- 5) exec AANROEP_VUL_INIT_PART_GEWICHT('EF_H165/80R15CLSM', 'A_PCR' , null, 'J','N');    --haal specifiek part-no op (met juiste frame-id)
-- 6) exec AANROEP_VUL_INIT_PART_GEWICHT('EF_H215/60R16SP5X', 'A_PCR' , 10, 'J','N');      --haal specifiek part-no op (met juiste frame-id) en volgende 9 part-no op.
-- 7) exec AANROEP_VUL_INIT_PART_GEWICHT('EF%'              , ''      , 10, 'J','N');      --haal eerste 10 part-no op.
-- 8) exec AANROEP_VUL_INIT_PART_GEWICHT('EF%'              , 'A_PCR' , 10, 'J','N');      --haal eerste 10 part-no beginnend met EF% binnen frame-id op.
-- 9) exec AANROEP_VUL_INIT_PART_GEWICHT('ALLE'             , 'A_PCR' , 10, 'J','N');      --haal de eerste 10 part-no van A_PCR op
--10) SET SERVEROUTPUT ON
--    exec AANROEP_VUL_INIT_PART_GEWICHT('ALLE'             , 'A_PCR' , 1000000, 'J','N');  --haal alle part-no van A_PCR op
--    exec AANROEP_VUL_INIT_PART_GEWICHT('EF%'              , 'A_PCR' , 1000000, 'J','N';   --haal alle part-no van ENSCHEDE van A_PCR op
--
--*************************************************************************************************************************
--REVISION DATE        WHO	DESCRIPTION
--      06 25-07-2022  PS   INDIEN p-insert-WEIGHT-comp-jn = N dan helemaal geen controle/insert op SYNC-BESTURING-tabel uitvoeren...
--      07 26-07-2022  PS   EXCEPTION-HANDLER OM uitvragen van sync-besturing-tabel
--      08 08-08-2022  PS   Add DEFAULT-waardes aan procedure parameters IPV default-aanduiding !
--
--*************************************************************************************************************************
--  --
l_header_part_no           varchar2(100)   := p_header_part_no;
l_header_frame_id          varchar2(100)   := p_header_frame_id;
l_aantal                   number          := p_aantal;
l_show_incl_items_jn       varchar2(1)     := UPPER(p_show_incl_items_jn);
l_insert_weight_comp_jn    varchar2(1)     := UPPER(p_insert_weight_comp_jn);
--stuurinfo-attributen !!!
l_str_startdatum_van       varchar2(100);
l_str_startdatum_tm        varchar2(100);
l_mut_verwerking_aan_ind   VARCHAR2(1);  
l_mut_sync_periode_dagen   NUMBER;
l_sync_id                  NUMBER;
l_verwerkt_aantal_tyres    number;
--***********************************************
--AANSTURING VIA FRAME-ID VIA VIEW: AV_BHR_BOM_TYRE_PART_NO !!!!
--LETOP: bij A_PCR komen meerdere varianten voor, deze allemaal via A_PCR verwerken!!!
--***********************************************
cursor c_tyre_frame_id (pl_header_part_no  varchar2 default '%'
                       ,pl_header_frame_id varchar2 default '%' ) 
is
select distinct a.frame_id
from (select decode(bh.FRAME_ID,'A_PCR_VULC v1','A_PCR','A_PCR_v1','A_PCR','A_PCR_v2','A_PCR', bh.FRAME_ID)     frame_id
     from AV_BHR_BOM_TYRE_PART_NO   bh
     where (  (   instr(pl_header_part_no,'%') = 0 
              and bh.part_no    = pl_header_part_no
              and bh.frame_id   like pl_header_frame_id||'%'
     		     )
     	    or (   instr(pl_header_part_no,'%') > 0
     	       and bh.part_no    like pl_header_part_no||'%'   
    	       and bh.frame_id   like pl_header_frame_id||'%'
             )
          )
     --and bh.frame_id in ('E_SM' ,'E_BBQ')      
    ) a
order by a.frame_id
;
--***********************************************
--AANROEP VIA VIEW: AV_BHR_BOM_TYRE_PART_NO !!!!
--***********************************************
cursor c_tyre_part_no (pl_header_part_no  varchar2 default '%'
                      ,pl_header_frame_id varchar2 default '%' 
                      ,pl_aantal          number   default 1   ) 
is
select PART_NO 
,      REVISION     
,      PLANT        
,      ALTERNATIVE  
,      BASE_QUANTITY
,      FRAME_ID     
,      SORT_DESC    
,      SAP_CODE     
from AV_BHR_BOM_TYRE_PART_NO   bh
where (  (   (  instr(pl_header_part_no,'%') = 0
			 )
         and bh.part_no    = pl_header_part_no
         and bh.frame_id   like pl_header_frame_id||'%'
		 )
	  or (   instr(pl_header_part_no,'%') > 0
	     and bh.part_no    like pl_header_part_no||'%'   
	     and bh.frame_id   like pl_header_frame_id||'%'
		 )
      )
--vooralsnog alleen voor A_PCR (en zonder X-banden Enschede)	  
--and substr(bh.part_no,1,2) not in ('XE')
--and frame_id = 'A_PCR'
and rownum < (pl_aantal+1)
order by bh.frame_id, bh.part_no
;
l_startdatum  date;
l_einddatum   date;
l_duur_minuut number;
l_teller      number;
--
BEGIN
  DBMS_OUTPUT.ENABLE(1000000);
  dbms_output.put_line('Aanroep header-part-no: '||l_header_part_no||' frame: '||l_header_frame_id||' aantal: '||l_aantal);
  --*******************************************************
  --VERVERS eerst MV = mv_bom_item_comp_header bij !!
  --PAS NA VERVERS-ACTIE ZETTEN WE DE START-VANAF-DATUM 
  refresh_mv_bom_item_header;
  --*******************************************************
  --init
  l_teller     := 0;
  l_startdatum := sysdate;
  l_aantal                 := nvl(l_aantal,999999999);
  l_show_incl_items_jn     := nvl(l_show_incl_items_jn,'N');
  l_insert_weight_comp_jn  := nvl(l_insert_weight_comp_jn,'J');
  --
  --part-no kan volledig part-no zijn (zonder %), een substring (met %) of waarde=ALLE bevatten.
  if upper(l_header_part_no) = 'ALLE'
  then l_header_part_no := '%';
  else l_header_part_no := upper(l_header_part_no);
  end if;
  --frame-id mag alleen waarde ALLE/<null> of volledig frame-id bevatten
  if nvl(upper(l_header_frame_id),'ALLE') = 'ALLE'
  then l_header_frame_id := '%';
  else l_header_frame_id := l_header_frame_id;
  end if;
  --
  --Start LOOP over FRAME-ID
  --WE VERWERKEN PER FRAME-ID uit VIEW=AV_BHR_BOM_TYRE_PART_NO de aanwezig TYRE-PART-NO !!! 
  --OOK OP DIE MANIER BIJGEHOUDEN IN STUURTABEL !!!
  --Hiervoor is evt. waarde FRAME_ID=ALLE al vervangen door '%' 
  FOR r_tyre_frame_id in c_tyre_frame_id (l_header_part_no, l_header_frame_id )
  LOOP
    --init
    l_teller     := 0;
    --Indien stuurtabel bijhouden dan PARAMETER=INSERT-WEIGHT-COMP-JN="J"
    IF nvl(l_insert_weight_comp_jn,'N' ) = 'J' 
    THEN
      begin   
	      --van. max-calc-datum uit tabel 
        --select to_char( max(dwc.tech_calculation_date), 'dd-mm-yyyy hh24:mi:ss' ) into l_str_startdatum_van from dba_weight_component_part dwc ;
	      SELECT sbw_mut_verwerking_aan
	      ,      sbw_sync_periode_dagen
	      ,      to_char( sysdate, 'dd-mm-yyyy hh24:mi:ss' ) 
	      into l_mut_verwerking_aan_ind
	      ,    l_mut_sync_periode_dagen
	      ,    l_str_startdatum_van 
	      from DBA_SYNC_BESTURING_WEIGHT_SAP SBW 
	      WHERE sbw.id = (select max(sbw2.id) from DBA_SYNC_BESTURING_WEIGHT_SAP SBW2 where sbw2.sbw_selected_frame_id = r_tyre_frame_id.frame_id ) 
        AND   sbw.sbw_selected_frame_id = r_tyre_frame_id.frame_id    --controle op specifiek frame-id
	      AND   sbw.sbw_datum_verwerkt_tm is not null         --indien deze NULL is, dan loopt er nog een andere sessie, en starten we niet een nieuwe op!!!
	      ;
        dbms_output.put_line('UITVRAGEN-STUURTABEL Frame-id: '||r_tyre_frame_id.frame_id||' verwerkingperiode van: '||l_str_startdatum_van);
      exception
	      when no_data_found
	      then 
          --rollback;
          --controle of er helemaal geen voorkomen bestaat. In dit geval kunnen we met een INITIELE load verder...
          begin
            SELECT sbw_mut_verwerking_aan
            ,      sbw_sync_periode_dagen
            ,      to_char( sysdate, 'dd-mm-yyyy hh24:mi:ss' ) 
     	      into l_mut_verwerking_aan_ind
    	      ,    l_mut_sync_periode_dagen
    	      ,    l_str_startdatum_van 
    	      from DBA_SYNC_BESTURING_WEIGHT_SAP SBW 
    	      WHERE sbw.id = (select max(sbw2.id) from DBA_SYNC_BESTURING_WEIGHT_SAP SBW2 where sbw2.sbw_selected_frame_id = r_tyre_frame_id.frame_id ) 
            AND   sbw.sbw_selected_frame_id = r_tyre_frame_id.frame_id    --controle op specifiek frame-id
    	      --AND   sbw.sbw_datum_verwerkt_tm is not null         
    	      ;
          exception
            when no_data_found
            then --er is helemaal geen voorkomen gevonden, we kunnen initiele waarde inserten.
                 l_mut_verwerking_aan_ind := 'J';
	               l_mut_sync_periode_dagen := 1;
	               l_str_startdatum_van     := to_char( sysdate, 'dd-mm-yyyy hh24:mi:ss' );
                 dbms_output.put_line('UITVRAGEN-STUURTABEL TOEVOEGEN NIEUW Frame-id: '||r_tyre_frame_id.frame_id||' verwerkingperiode van: '||l_str_startdatum_van);  
            when others 
            then
    	        dbms_output.put_line('EXCP-NO-DATA-FOUND UITVRAGEN-STUURTABEL Frame-id: '||r_tyre_frame_id.frame_id||'  datum_verwerkt_tm is LEEG, PROCES STOPT '); 
              RAISE;
          end; 
        when others 
        then rollback;
          --l_str_startdatum_van := to_char( (trunc(sysdate)-1), 'dd-mm-yyyy hh24:mi:ss') ;
          dbms_output.put_line('EXCP-UITVRAGEN-STUURTABEL Frame-id: '||r_tyre_frame_id.frame_id||' verwerkingperiode van: '||l_str_startdatum_van||'-'||sqlerrm); 
          RAISE;
      End;
      --
      --tm. eind ALTIJD tm. EINDE van de vorige WERKELIJKE dag tov SYSDATE:
      l_str_startdatum_tm := l_str_startdatum_van;    --to_char( (trunc(sysdate)-1/(24*60+60)), 'dd-mm-yyyy hh24:mi:ss' );
      --
      dbms_output.put_line('Frame-id: '||r_tyre_frame_id.frame_id||' verwerkingperiode van: '||l_str_startdatum_van||' t/m '||l_str_startdatum_tm);
      --
      begin 
        --insert nieuwe verwerkingsregel in SYNC-BESTURING-tabel
        --De velden VERWERKT-TM + AANTAL-TYRES vullen met UPDATE achteraf !!!!
        select dba_weight_calc_seq.nextval into l_sync_id from dual;
        --
        insert into DBA_SYNC_BESTURING_WEIGHT_SAP
        ( ID
        , SBW_MUT_VERWERKING_AAN 
        , SBW_SYNC_PERIODE_DAGEN
        , SBW_DATUM_VERWERKT_VANAF
        , SBW_DATUM_VERWERKT_TM
        , SBW_AANTAL_TYRES 
        , SBW_DATUM_ONTLADEN_SAP_TM
        , SBW_SYNC_TYPE
        , SBW_SELECTED_FRAME_ID
        )
        values (l_sync_id
	             ,l_mut_verwerking_aan_ind
	             ,l_mut_sync_periode_dagen
			         ,to_date(l_str_startdatum_van,'dd-mm-yyyy hh24:mi:ss')
			         ,to_date(null)
			         ,0
               , to_date(null)
               ,'INITIAL' 
               ,r_tyre_frame_id.frame_id    --nvl(p_header_frame_id,'ALLE') --VANAF 25-10-2022 per FRAME-ID verwerken !!!
               );
  	    --********************************
        commit;
  	    --********************************
        dbms_output.put_line('STUURTABEL-RECORD TOEGEVOEGD met ID =' ||l_sync_id||' Frame-id: '||r_tyre_frame_id.frame_id);
        --
      exception
        when others 
        then rollback;
          --l_str_startdatum_van := to_char( (trunc(sysdate)-1), 'dd-mm-yyyy hh24:mi:ss') ;
          dbms_output.put_line('EXCP-INSERT-STUURTABEL Frame-id: '||r_tyre_frame_id.frame_id||' verwerkingperiode van: '||l_str_startdatum_van||'-'||sqlerrm);
      End; 
      --
    END IF;  --l_insert_weight_comp_jn=J
    --Het maakt niet uit wat de STUURTABEL aan inhoud bevat !!!
    dbms_output.put_line('Aanroep cursor TYRE-PART-NO met header-part-no:'||l_header_part_no||' header-frame-id: '||r_tyre_frame_id.frame_id||' aantal: '||nvl(l_aantal,1) );
    --Indien DEZE INITIELE AANROEP-PROCEDURE wordt gestart wordt NIEUW SCENARIO/BEGINPUNT gestart, zonder met historie rekening te houden !!!!
    --Hiervoor is HEADER-PART-NO=ALLE al vervangen door '%', FRAME-ID heeft altijd al NORMALE WAARDE...
    for r_tyre_part_no in c_tyre_part_no (l_header_part_no, r_tyre_frame_id.frame_id, nvl(l_aantal,1) )
    loop
      --voor dba-beheer-test-werk
      if nvl(l_aantal,0) < 10
      then dbms_output.put_line('header-part-no: '||r_tyre_part_no.part_no||' revision: '||r_tyre_part_no.revision||' alternative: '||r_tyre_part_no.alternative||' STARTED...');
      end if;
      l_teller := l_teller + 1;
      --aanroep procedure DBA_BEPAAL_COMP_PART_GEWICHT  
      --GEWICHT WORDT OP BASIS VAN PART-NO BEPAALD. SAP-CODE WORDT ALLEEN TER INFO MEEGEGEVEN !!
      --DBA_BEPAAL_COMP_PART_GEWICHT(p_header_part_no=>r_tyre_part_no.part_no
   	  --                            ,p_header_revision=>r_tyre_part_no.revision
	    --                            ,p_alternative=>r_tyre_part_no.alternative
		  --      			              	,p_show_incl_items_jn=>l_show_incl_items_jn 
		  --			  			              ,p_insert_weight_comp_jn=>l_insert_weight_comp_jn);
      --                                  
      bepaal_MV_comp_part_gewicht(p_header_part_no=>r_tyre_part_no.part_no
                                 ,p_header_revision=>r_tyre_part_no.revision
                                 ,p_alternative=>r_tyre_part_no.alternative
                                 ,p_show_incl_items_jn=>l_show_incl_items_jn 
                                 ,p_insert_weight_comp_jn=>l_insert_weight_comp_jn );    
                                  
      --   
      if nvl(l_aantal,0) < 10
  	  then dbms_output.put_line('header-part-no: '||r_tyre_part_no.part_no||' revision: '||r_tyre_part_no.revision||' alternative: '||r_tyre_part_no.alternative||' COMPLETED...');
  	  end if;
      --Na iedere 10-part-no werken we stuurtabel bij...	
      if nvl(l_insert_weight_comp_jn,'N' ) = 'J' 
      AND mod(l_teller,10)=0
      then
        BEGIN
          --WERK eindstand bij:
          UPDATE DBA_SYNC_BESTURING_WEIGHT_SAP 
    	    set  SBW_AANTAL_TYRES      = l_teller
  	      WHERE id = l_sync_id 
  	      ;
          --************** 
  	      COMMIT;
  	      --**************
        EXCEPTION
          when OTHERS 
          then rollback;
              --Dbms_output.put_line('EXCP-UPDATE-STUURTABEL-VOORTGANG-TELLER , SYNC-ID: '||l_sync_id||' VERWERKT-TM: '||l_str_startdatum_tm||' aantal tyres: '||l_teller||'-'||sqlerrm );
        END;
      end if;
    end loop;  --tyre-part-no
    --
    --Indien stuurtabel bijhouden dan PARAMETER=INSERT-WEIGHT-COMP-JN="J"
    IF nvl(l_insert_weight_comp_jn,'N' ) = 'J' 
    THEN
      BEGIN
        --WERK eindstand bij:
        UPDATE DBA_SYNC_BESTURING_WEIGHT_SAP 
  	    set  SBW_DATUM_VERWERKT_TM = to_date(l_str_startdatum_tm,'dd-mm-yyyy hh24:mi:ss')
  	    ,    SBW_AANTAL_TYRES      = l_teller
  	    WHERE id = l_sync_id  
  	    ;
        --**************
  	    COMMIT;  
  	    --**************
      EXCEPTION
        when OTHERS 
        then
          rollback;
          Dbms_output.put_line('EXCP-UPDATE-STUURTABEL, SYNC-ID: '||l_sync_id||' VERWERKT-TM: '||l_str_startdatum_tm||' aantal tyres: '||l_teller||'-'||sqlerrm );
      END;
    	--
    END IF; --insert-weight-comp-jn
    --
  END LOOP;  --TYRE-FRAME-ID
  --
  l_einddatum := sysdate;
  l_duur_minuut := ( l_einddatum - l_startdatum ) * 24 * 60;
  dbms_output.put_line('Uitvragen van hulptabel DBA_WEIGHT_COMPONENT_PART, aantal: '||l_teller||' duur(min): '||l_duur_minuut);
  dbms_output.put_line('SELECT count(*), trunc(component_issueddate) FROM DBA_WEIGHT_COMPONENT_PART where component_issueddate > trunc(sysdate)-14 group by trunc(component_issueddate) order by trunc(component_issueddate);');
  dbms_output.put_line('SELECT count(*), mainpart, tech_calculation_date FROM DBA_WEIGHT_COMPONENT_PART where tech_calculation_date > trunc(sysdate) group by mainpart, tech_calculation_date order by mainpart, tech_calculation_date;');
  if l_header_part_no not in ('ALLE','%')
  then
    dbms_output.put_line('SELECT * FROM DBA_WEIGHT_COMPONENT_PART where part_no = '||''''||l_header_part_no||''''||' and tech_calculation_date > trunc(sysdate)-1 order by id;');
    dbms_output.put_line('SELECT * FROM DBA_WEIGHT_COMPONENT_PART where mainpart = '||''''||l_header_part_no||''''||' and tech_calculation_date > trunc(sysdate)-1 order by id;');
  end if;
  --
END AANROEP_VUL_INIT_PART_GEWICHT;



END AAPIWEIGHT_CALC;
/

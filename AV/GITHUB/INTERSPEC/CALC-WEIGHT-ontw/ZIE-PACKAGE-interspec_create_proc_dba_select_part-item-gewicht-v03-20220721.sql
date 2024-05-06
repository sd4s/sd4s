--procedure voor uitvragen van GEWICHTEN van een BOM-HEADER

create or replace procedure DBA_SELECT_PART_ITEM_GEWICHT (p_header_part_no      varchar2 default null
                                                         ,p_alternative         number   default null )
DETERMINISTIC
AS
--Script om per bom-header/component het gewicht te berekenen van direct afhankelijke bom-items (materialen/componenten). 
--SELECTIE ZIT HIERBIJ  OP ALLE BOM-ITEMS (=INCLUSIEF MATERIALEN/GRONDSTOFFEN) 
--WAARBIJ PER BOM-HEADER OOK RELATIES MET COMPONENT-PARTS WORDEN OPGEHAALD.
--LET OP: OOK ALLE TUSSENLIGGENDE BOM-ITEM (RELATIES PART-NO/COMPONENT-PART) WORDEN HIERBIJ GESELECTEERD !!!
--
--Parameters:  P_PART_NO = bom-item-header, bijv.  EF_H215/65R15QT5	("CRRNT QR5", A_PCR)
--                                                 EF_Q165/80R15SCS	("CRRNT QR5", A_PCR)
--												   EF_S640/95R13CLS	("CRRNT QR5", A_PCR)
--             P_ALTERNATIVE = indicator die aangeeft om welk alternatief het gaat. 
--                             1=default, per eenheid
--                             2=batch, voor bulk
--
pl_header_part_no           varchar2(100)   := p_header_part_no;
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
l_component_part           varchar2(100);
l_quantity                 number;
l_uom                      varchar2(100);
l_quantity_kg              number;
l_status                   varchar2(30);
l_functiecode              varchar2(1000);
l_componentdescription     varchar2(1000);
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
  dbms_output.put_line('**************************************************************************************************************');
  dbms_output.put_line('MAINPART: '||pl_header_part_no  );
  dbms_output.put_line('**************************************************************************************************************');
    BEGIN
      dbms_output.put_line('l_mainpart'||';'||'l_mainrevision'||';'||'l_mainalternative'||';'||'l_mainbasequantity'||';'||'l_mainsumitemsquantity'||';'||'l_mainstatus'||';'||'l_mainframeid'||';'||'l_mainpartdescription'||';'||'l_mainpartbaseuom'||
		                    ';'||'l_component_part'||';'||'l_componentdescription'||';'||'l_item_header_base_quantity'||';'||'l_quantity'||';'||'l_uom'||';'||'l_quantity_kg'||';'||'l_status'||';'||'l_characteristic_id'||';'||'l_functiecode' );      
	  --Tonen van base/eenheid-gewicht van BOM-HEADER/component:
      open c_bom_items for SELECT bi2.mainpart
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
				--,      bi2.part_no
				--,      bi2.revision
				--,      bi2.plant
				--,      bi2.alternative
				,      bi2.component_part
				,      bi2.componentdescription
				,      bi2.item_header_base_quantity
				,      bi2.quantity
				,      bi2.uom
				,      bi2.quantity_kg
				,      bi2.status
				,      bi2.characteristic_id 
				,      bi2.functiecode
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
				 --allen max-revision
				 and    bh.revision = (select max(sh1.revision) from status s1, specification_header sh1 where sh1.part_no = bh.part_no and sh1.status = s1.status and s1.status_type in ('CURRENT','HISTORIC'))
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
				--,      b.part_no
				--,      b.revision
				--,      b.plant
				--,      b.alternative
				,      b.component_part
				,      (select pi.description from part pi where pi.part_no = b.component_part)  componentdescription
				,      (select bhi.base_quantity from bom_header bhi where bhi.part_no = b.part_no and bhi.revision = b.revision and bhi.alternative=b.alternative) item_header_base_quantity
				,      b.quantity
				,      b.uom
				,      case when b.uom = 'g' 
									then (b.quantity/1000) 
									when b.uom = 'kg'
									then b.quantity
				                    else 0 end         quantity_kg 
				,      s.sort_desc     status
				,      b.ch_1          characteristic_id       --FUNCTIECODE
				,      c.description   functiecode
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
				and    s.status_type in ('CURRENT','HISTORIC')
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
						  --,l_part_no 
                          --,l_revision
                          --,l_plant   
                          --,l_alternative
                          ,l_component_part      
                          ,l_componentdescription						  
                          ,l_item_header_base_quantity
                          ,l_quantity            
                          ,l_uom                 
                          ,l_quantity_kg     
						  ,l_status
						  ,l_characteristic_id
                          ,l_functiecode
						  ;
        if (c_bom_items%notfound)   
        then CLOSE C_BOM_ITEMS;
	         exit;
	    end if;
        dbms_output.put_line(l_mainpart||';'||l_mainrevision||';'||l_mainalternative||';'||l_mainbasequantity||';'||l_mainsumitemsquantity||';'||l_mainstatus||';'||l_mainframeid||';'||l_mainpartdescription||';'||l_mainpartbaseuom||
		                    ';'||l_component_part||';'||l_componentdescription||';'||l_item_header_base_quantity||';'||l_quantity||';'||l_uom||';'||l_quantity_kg ||';'||l_status||';'||l_characteristic_id||';'||l_functiecode );
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
END;
/

show err


prompt
prompt einde script
prompt






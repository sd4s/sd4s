create or replace procedure DBA_BEPAAL_BOM_GEWICHT (p_header_part_no      varchar2 default null
                                                   ,p_header_sap_code     varchar2 default null
                                                   ,p_show_incl_items_jn  varchar2 default 'J')
DETERMINISTIC
AS
--Script om per bom-header de gewichten te berekenen per band!
--Parameters:  P_PART_NO = bom-item-header, bijv.  EF_Y245/35R20QPRX (prod)
--                                                 EF_W245/40R18WPRX (test-FOUTIEVE CURSOR)
--                                                 EF_710/40R22FLT162 (test)
--             P_INCL_ITEMS_JN = Wel/of niet ook de afzonderlijke gewichten van alle BOM-ITEMS laten zien in OUTPUT.
--                               Indien 'N', dan wordt alleen totaal-regel getoond.
--
--dependencies: FUNCTIE DBA_BEPAAL_QUANTITY_KG: functie om de quantity-string te vermenigvuldiger met PART-NO-BASE-QUANTITY 
--                                              om uiteindelijk het gewicht van BOM-HEADER obv MATERIALS-gewichten te berekenen.
--
l_header_part_no           varchar2(100)   := p_header_part_no;
l_header_sap_code          varchar2(100)   := p_header_sap_code;
l_show_incl_items_jn       varchar2(1)     := p_show_incl_items_jn;
--
c_bom_items                sys_refcursor;
l_LVL                      varchar2(100);  
l_level_tree               varchar2(4000);
l_mainpart                 varchar2(100);
l_mainrevision             varchar2(100);
l_mainalternative          number;
l_mainbasequantity         number;
l_part_no                  varchar2(100);
l_revision                 varchar2(100);
l_plant                    varchar2(100);
l_alternative              number;
l_characteristic_id        number;
l_header_base_quantity     number;
l_component_part           varchar2(100);
l_quantity                 number;
l_uom                      varchar2(100);
l_quantity_kg              number;
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
  if upper(l_show_incl_items_jn) = 'J'
  then  
    dbms_output.put_line('**************************************************************************************************************');
    dbms_output.put_line('MAINPART: '||l_header_part_no ||' (SAP_CODE: '||l_header_sap_code||') show bom-items J/N: '||l_show_incl_items_jn );
    dbms_output.put_line('**************************************************************************************************************');
  end if;
  --Indien parameter =SHOW-ITEMS=ja
  if UPPER(l_show_incl_items_jn) in ('J')
  then
    BEGIN
      dbms_output.put_line('ITEM;path;quantity-path;gewicht;gewicht-excl;UOM');
      --Tonen van totale-gewicht van BOM-HEADER:
      open c_bom_items for SELECT bi2.LVL
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
				,      bi2.header_base_quantity
				,      bi2.component_part
				,      bi2.quantity
				,      bi2.uom
				,      bi2.quantity_kg
				,      bi2.path
				,      bi2.quantity_path
				,      DBA_BEPAAL_QUANTITY_KG(bi2.quantity_path)  excl_quantity_kg
				from
				(
				with sel_bom_header as 
				(select boh.part_no, boh.revision, boh.plant, boh.alternative, boh.base_quantity
				 from   bom_header boh 
				 where  boh.alternative = 1
				 --Indien we gewicht van alleen banden willen kunnen opvragen:
				 --and    boh.part_no NOT IN (select boi2.component_part from bom_item boi2 where boi2.component_part = boh.part_no)
				 --Indien we gewicht van een sub-part-no (zonder materialen) willen kunnen opvragen:
				 and    boh.part_no IN (select boi2.part_no from bom_item boi2 where boi2.part_no = boh.part_no)
				 --
				 and    boh.revision = (select max(boh1.revision) from bom_header boh1 where boh1.part_no = boh.part_no)
				 and    boh.part_no = l_header_part_no
				 and    rownum = 1
				 --and    boh.PART_NO = 'XEM_B16-1119_01'
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
				,      b.characteristic_id       --FUNCTIECODE
				,      b.header_base_quantity
				,      b.component_part
				,      b.quantity
				,      b.uom
				,      b.quantity_kg
				,      sys_connect_by_path( b.part_no||decode(b.characteristic_id,null,'','-'||b.characteristic_id) || ',' || b.component_part ,'|')  path
				,      sys_connect_by_path( '('||b.quantity_kg||'/'||b.header_base_quantity||')', '*')  quantity_path
				FROM   ( SELECT bi.part_no
				         , bi.revision
						 , bi.plant
						 , bi.alternative
						 , bi.ch_1           characteristic_id
						 , (select bh.base_quantity from bom_header bh where bh.part_no = bi.part_no and bh.revision = bi.revision and bh.alternative=1) header_base_quantity
						 , bi.component_part
						 , bi.quantity
						 , bi.uom 
						 , case when bi.uom = 'g' then (bi.quantity/1000) else bi.quantity end  quantity_kg 
						 from bom_item   bi
						 WHERE bi.alternative = 1
						 AND   bi.revision = (select max(boi3.revision) from bom_item boi3 where boi3.part_no = bi.part_no)
					   ) b
				,      sel_bom_header h	   
				START WITH b.part_no = h.part_no 
				CONNECT BY NOCYCLE PRIOR b.component_part = b.part_no --and b.component_revision = b.revision
				order siblings by part_no
				)  bi2
				--select alleen gewicht van materialen...
				where bi2.component_part NOT IN (select bi3.part_no from bom_item bi3 where bi3.part_no = bi2.component_part)
				;
      loop 
        fetch c_bom_items into l_LVL
                          ,l_level_tree
                          ,l_mainpart  
                          ,l_mainrevision
                          ,l_mainalternative
                          ,l_mainbasequantity
                          ,l_part_no 
                          ,l_revision
                          ,l_plant   
                          ,l_alternative
						  ,l_characteristic_id
                          ,l_header_base_quantity
                          ,l_component_part      
                          ,l_quantity            
                          ,l_uom                 
                          ,l_quantity_kg         
                          ,l_path                
                          ,l_quantity_path       
                          ,l_excl_quantity_kg  ;
        if (c_bom_items%notfound)   
        then CLOSE C_BOM_ITEMS;
	         exit;
	    end if;
        dbms_output.put_line(l_part_no||';'||l_path||';'||l_quantity_path||';'||l_quantity_kg||';'||l_excl_quantity_kg ||';'||l_uom||';'||l_characteristic_id );
        DBA_INSERT_WEIGHT_CALC (p_main_part_no=>l_mainpart
                               ,p_part_no=>l_part_no
							   ,p_component_part_no=>l_component_part
							   ,p_characteristic_id=>l_characteristic_id
		                       ,p_path=>l_path
							   ,p_quantity_path=>l_quantity_path
							   ,p_quantity_kg=>l_quantity_kg
							   ,p_excl_quantity_kg=>l_excl_quantity_kg
							   ,p_uom=>l_uom
							   ,p_remark=>'TEST-RUN-PETER' );
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
    dbms_output.put_line('BEREKEN TOTAALGEWICHT VAN HEADER: '||l_header_part_no||' (SAP_CODE: '||l_header_sap_code||')' );
    dbms_output.put_line('**************************************************************************************************************');
  end if;
  --Tonen van totale-gewicht van BOM-HEADER:
  BEGIN
    --sum(decode(uom,'pcs',0,quantity_kg)), sum(decode(uom,'pcs',0,excl_quantity_kg))
    --Voor alle materialen die geen gewicht hebben (maar "pcs") nemen we geen gewicht mee
    open c_bom for select mainpart, sum(decode(uom,'pcs',0,quantity_kg)) gewicht, sum(decode(uom,'pcs',0,excl_quantity_kg)) gewicht_excl_kg_som_items
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
				,      bi2.header_base_quantity
				,      bi2.component_part
				,      bi2.quantity
				,      bi2.uom
				,      bi2.quantity_kg
				,      bi2.path
				,      bi2.quantity_path
				,      DBA_BEPAAL_QUANTITY_KG(bi2.quantity_path)  excl_quantity_kg
				from
				(
				with sel_bom_header as 
				(select boh.part_no, boh.revision, boh.plant, boh.alternative, boh.base_quantity
				 from   bom_header boh 
				 where  boh.alternative = 1
				 --Indien we gewicht van alleen banden willen kunnen opvragen:
				 --and    boh.part_no NOT IN (select boi2.component_part from bom_item boi2 where boi2.component_part = boh.part_no)
				 --Indien we gewicht van een sub-part-no (zonder materialen) willen kunnen opvragen:
				 and    boh.part_no IN (select boi2.part_no from bom_item boi2 where boi2.part_no = boh.part_no)
				 --
				 and    boh.revision = (select max(boh1.revision) from bom_header boh1 where boh1.part_no = boh.part_no)
				 and    boh.part_no = l_header_part_no
				 and    rownum = 1
				 --and    boh.PART_NO = 'XEM_B16-1119_01'
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
				,      b.header_base_quantity
				,      b.component_part
				,      b.quantity
				,      b.uom
				,      b.quantity_kg
				,      sys_connect_by_path( b.part_no || ',' || b.component_part ,'|')  path
				,      sys_connect_by_path( '('||b.quantity_kg||'/'||b.header_base_quantity||')', '*')  quantity_path
				FROM   ( SELECT bi.part_no
				         , bi.revision
						 , bi.plant
						 , bi.alternative
						 , bi.ch_1           characteristic_id
						 , (select bh.base_quantity from bom_header bh where bh.part_no = bi.part_no and bh.revision = bi.revision and bh.alternative=1) header_base_quantity
						 , bi.component_part
						 , bi.quantity
						 , bi.uom 
						 , case when bi.uom = 'g' then (bi.quantity/1000) else bi.quantity end  quantity_kg 
						 from bom_item   bi
						 WHERE bi.alternative = 1
						 AND   bi.revision = (select max(boi3.revision) from bom_item boi3 where boi3.part_no = bi.part_no)
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
      fetch c_bom into l_header_mainpart, l_header_gewicht, l_header_gewicht_som_items;
      if (c_bom%notfound)   
      then CLOSE C_BOM;
           exit;
      end if;
	  if upper(l_show_incl_items_jn) = 'J'
      then 
        dbms_output.put_line('**************************************************************************************************************');
        dbms_output.put_line('TOTAALGEWICHT VAN ITEM;'||l_header_part_no||';sap_code;'||l_header_sap_code||';base-gewicht;'||l_header_gewicht||';gewicht-excl;'||l_header_gewicht_som_items );
        dbms_output.put_line('**************************************************************************************************************');
      else
        dbms_output.put_line('TOTAALGEWICHT VAN ITEM;'||l_header_part_no||';sap_code;'||l_header_sap_code||';base-gewicht;'||l_header_gewicht||';gewicht-excl;'||l_header_gewicht_som_items );
	  end if;
    end loop;
    --
    close c_bom;
  EXCEPTION
  WHEN OTHERS 
  THEN if sqlerrm not like '%ORA-01001%' 
       THEN dbms_output.put_line('ALG-EXCP BOM-HEADER-TOTAL '||l_header_part_no||' (sap_code: '||l_header_sap_code||'): '||SQLERRM); 
       else null; 
	   end if;
  END;
  --
END;
/

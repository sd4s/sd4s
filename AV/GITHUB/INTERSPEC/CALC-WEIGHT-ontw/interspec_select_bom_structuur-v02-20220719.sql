--Script om ad-hoc de bom-structuur van een BAND uit te vragen.
--Gelijk aan procedure DBA_BEPAAL_BOM_HEADER_GEWICHT !!!

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
,      bi2.header_base_quantity
,      bi2.component_part
,      bi2.quantity
,      bi2.uom
,      bi2.quantity_kg
 ,     bi2.characteristic_id       --FUNCTIECODE
,      bi2.path
,      bi2.quantity_path
,      DBA_BEPAAL_QUANTITY_KG(bi2.quantity_path)  excl_quantity_kg
from
(
with sel_bom_header as 
(select boh.part_no, boh.revision, boh.plant, boh.alternative, boh.base_quantity
 from   bom_header boh 
 where  boh.part_no in ('XGF_1557013QT5NTRW')
 and    boh.preferred  = 1
 and    boh.part_no  NOT IN (select boi2.component_part from bom_item boi2 where boi2.component_part = boh.part_no)
 and    boh.revision = (select max(sh1.revision) 
	                    from status s1
                        ,    specification_header sh1 
                        where sh1.part_no = boh.part_no 
                        and   sh1.status = s1.status 
                        and s1.status_type in ('CURRENT','HISTORIC')
                       )
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
,      b.header_base_quantity
,      b.component_part
,      b.quantity
,      b.uom
,      b.quantity_kg
,      b.ch_1         characteristic_id       --FUNCTIECODE
,      sys_connect_by_path( b.part_no || ',' || b.component_part ,'|')  path
,      sys_connect_by_path( '('||b.quantity_kg||'/'||b.header_base_quantity||')', '*')  quantity_path
FROM   ( SELECT bi.part_no, bi.revision, bi.plant, bi.alternative
         , (select bh.base_quantity from bom_header bh where bh.part_no = bi.part_no and bh.revision = bi.revision and bh.alternative=1) header_base_quantity
		 , bi.component_part
		 , bi.quantity
		 , bi.uom 
		 , case when bi.uom = 'g' then (bi.quantity/1000) else bi.quantity end  quantity_kg 
		 , bi.ch_1
         from bom_header  bh
		 ,    bom_item    bi
         WHERE bh.part_no      = bi.part_no
         and   bh.revision     = bi.revision
		 AND   bh.preferred    = 1
		 and   bh.alternative  = bi.alternative
         and   bh.revision   = (select max(sh1.revision) from status s1, specification_header sh1 where sh1.part_no = bi.part_no and sh1.status = s1.status and s1.status_type in ('CURRENT','HISTORIC'))
	   ) b
,      sel_bom_header h	   
START WITH b.part_no = h.part_no 
CONNECT BY NOCYCLE PRIOR b.component_part = b.part_no --and b.component_revision = b.revision
order siblings by part_no
)  bi2
--indien we alleen het materaiaal willen zien:
--where bi2.component_part NOT IN (select bi3.part_no from bom_item bi3 where bi3.part_no = bi2.component_part)
;


--einde script




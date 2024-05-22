select * from property where description like 'SAP%material%';
--717751	SAP material group	1

SELECT * 
FROM specification_prop sp                              
WHERE sp.part_no   like '%'     --  = 'EM_741'                              
--AND NOT exists (select '' from bom_item bi3 where bi3.part_no = bi.component_part )                                
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
--AND   sp.property_group = 0 -- (none)                              
--AND   sp.property       = 703262 -- Weight                              
AND   sp.property       = 717751  -- SAP material group
--and   rownum = 1                              
;


--in value / value_s zit waarde van property !!!
select *
from specdata s
where s.part_no='EM_774' 
AND property=717751
;
--866   3C002: Final Batches Radial

--ASSOCIATION   =155  
select * from ASSOCIATION where association = 155;
--155	SAP material group PCT	C

--CHARACTERISTIC=866
select * from characteristic where characteristic_id = 866;
866	3C002: Final Batches Radial	1	0




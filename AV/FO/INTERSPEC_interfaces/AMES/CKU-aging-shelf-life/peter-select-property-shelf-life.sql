--select property SHELF-LIFE tbv AMES (via interface to SAP)
--In INTERSPEC-SAP-interface EXP2SAP komt alleen volgende property voor:
--        Name = 'MaxShelfLife'
	
--	

select * from property where description like '%Shelf%';
/*
property 	description							intl	status
---------	---------------------------------	------	--------
703296		Shelf life (on delivery)			1		0
708568		Shelf life min. (after production)	1		0
709448		Shelf life max. (after production)	1		0
--
712816		Shelf life							1		0              -->dit is SHELF-LIFE-property !!!
*/

--****************************
--SHELF LIFE 
--****************************
SELECT DISTINCT SECTION_ID, SECTION_REV, SUB_SECTION_ID, SUB_SECTION_REV, PROPERTY_GROUP, PROPERTY_GROUP_REV 
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
--AND   sp.section_id     = 700577 --  Chemical and physical properties                            
AND   sp.property       = 712816  -- Shelf Life
--and   rownum = 1                              
;

--700577	0	0	0	0	0
--700577	100	0	100	0	1

SELECT * FROM SECTION WHERE SECTION_ID = 700577;
--700577	Chemical and physical properties	1	0

--selectie PROPERTY-VALUES:
select part_no, revision, property, CHAR_1
from specification_prop sp    
WHERE  sp.revision = (select max(sh1.revision)                               
                     from status s1, specification_header sh1                              
                     where   sh1.part_no    = sp.part_no             --is component-part-no                              
                     and     sh1.status     = s1.status                               
                     and     s1.status_type in ('CURRENT','HISTORIC')                              
                    )                   
AND   sp.property       = 712816  -- SAP material group
AND CHAR_1 is not null
;
	
--COUNT PER CHAR_1 VALUE:
select property, CHAR_1, count(*)
from specification_prop sp    
WHERE  sp.revision = (select max(sh1.revision)                               
                     from status s1, specification_header sh1                              
                     where   sh1.part_no    = sp.part_no             --is component-part-no                              
                     and     sh1.status     = s1.status                               
                     and     s1.status_type in ('CURRENT','HISTORIC')                              
                    )                   
AND   sp.property       = 712816  -- SAP material group
AND CHAR_1 is not null
GROUP BY property, CHAR_1
order by property, CHAR_1
;
/*
712816	1 year				4
712816	1					14
712816	1 YEAR				1
712816	1 Year				584
712816	1 Year 				1
712816	1 Years				19
712816	1 day				1
712816	1 year				172
712816	1.5 Year			6
712816	1.5 Years			155
712816	1.5 years			2
712816	111					2
712816	12 months			18
712816	12 months 			1
712816	15 days				1
712816	18 months			1
712816	2 Year				20
712816	2 Years				53
712816	2 year				4
712816	2 years				23
712816	2,5 year			16
712816	24 months			18
712816	3 months			2
712816	3 months to 1 year		9
712816	30 Months			1
712816	5 years				47
712816	6 Months			8
712816	6 months			230
712816	6 months 			1
712816	60 months			1
712816	8 months			2
712816	9 Months			1
712816	9 months			4
712816	ASIA : 6 Months / EA : 1 Year	1
712816	ASIA : 6 months / EA : 1 Year	2
712816	Asia :6 months / EA :1 year		3
*/


select SUBSTR(part_no,1,3), CHAR_1, count(*)
from specification_prop sp    
WHERE  sp.revision = (select max(sh1.revision)                               
                     from status s1, specification_header sh1                              
                     where   sh1.part_no    = sp.part_no             --is component-part-no                              
                     and     sh1.status     = s1.status                               
                     and     s1.status_type in ('CURRENT','HISTORIC')                              
                    )                   
AND   sp.property       = 712816  -- Aging (maximal)
GROUP BY SUBSTR(part_no,1,3), CHAR_1
order by SUBSTR(part_no,1,3), CHAR_1
;
--<only-materials>
/*
140388D
150056
150781
600288
600303_JUN_ZHA
600303_SNT_DON
600311A
600311_HYO_NOH
...
*/
	

--****************************
--SHELF LIFE MAX  (=ZIT WEL IN INTERSPEC-SAP-INTERFACE ...!!)
--709448		Shelf life max. (after production)	1		0
--****************************
SELECT DISTINCT SECTION_ID, SECTION_REV, SUB_SECTION_ID, SUB_SECTION_REV, PROPERTY_GROUP, PROPERTY_GROUP_REV 
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
--AND   sp.section_id     = 700755 --  SAP information                              
--AND   sp.sub_section_id = 701502 -- A        --alle SAP-WEIGHT-properties meenemen in berekening                              
--AND   sp.property_group = 0 -- (none)                              
--AND   sp.property       = 703262 -- Weight                              
AND   sp.property       = 709448  -- SAP material group
--and   rownum = 1                              
;

701055	100	700542	100	702616	100
700583	100	700542	100	702616	100
701058	100	700542	100	702616	100

SELECT * FROM SECTION WHERE SECTION_ID IN (701055, 700583,701058 );
700583	Processing
701055	Processing R&D
701058	Processing Gyongyoshalasz

SELECT * FROM SUB_SECTION WHERE sub_SECTION_ID IN (700542);
700542	General

SELECT * FROM PROPERTY_GROUP WHERE PROPERTY_GROUP IN (702616);
702616	Shelf life		1	0	1


--COUNT PER CHAR_1 VALUE:
select property, CHAR_1, count(*)
from specification_prop sp    
WHERE  sp.revision = (select max(sh1.revision)                               
                     from status s1, specification_header sh1                              
                     where   sh1.part_no    = sp.part_no             --is component-part-no                              
                     and     sh1.status     = s1.status                               
                     and     s1.status_type in ('CURRENT','HISTORIC')                              
                    )                   
AND   sp.property       = 709448  -- Shelf Life MAX
AND CHAR_1 is not null
GROUP BY property, CHAR_1
order by property, CHAR_1
;
--709448	<null>	2973

-->CONCLUSION: SHELF-LIFE-MAX IS EMPTY !!!!

select SUBSTR(part_no,1,3), CHAR_1, count(*)
from specification_prop sp    
WHERE  sp.revision = (select max(sh1.revision)                               
                     from status s1, specification_header sh1                              
                     where   sh1.part_no    = sp.part_no             --is component-part-no                              
                     and     sh1.status     = s1.status                               
                     and     s1.status_type in ('CURRENT','HISTORIC')                              
                    )                   
AND   sp.property       = 709448  -- Aging (maximal)
GROUP BY SUBSTR(part_no,1,3), CHAR_1
order by SUBSTR(part_no,1,3), CHAR_1
;



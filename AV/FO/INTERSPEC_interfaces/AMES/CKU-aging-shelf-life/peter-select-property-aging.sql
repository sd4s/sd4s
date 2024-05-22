--select property AGING tbv SAP (via interface to SAP)
--In INTERSPEC-SAP-interface EXP2SAP only the following property exists:
--       Name = 'MinAging'
--USERS complain that the field Aging in SAP keeps empty (value=0), while they can see in INTERSPEC that the MAX-AGE does have a value !!
--This can easily be explained, because only the MIN-AGING is part of the INTERSPEC-SAP-INTERFACE.
--The value = 0 we see in SAP comes most likely from the MIN-AGING-property in INTERSPEC.
--The the interface works as configured.
--Why do we have an issue right now? This interface isn't changed lately, also looking at the property-values in INTERSPEC.
--Are we recently started to use this property?
--
--CONCLUSION: WHICH ATTRIBUTE IS GIVING PROBLEMS, THE SHELF-LIFE OF AGING (MAX/MIN) ???
--            DO WE SEND THE CORRECT VALUES TO SAP, BECAUSE: 
--            SHELF-LIFE interface-SAP we send the MAX-SHELF-LIFE , IS ALWAYS EMPTY, SHELF-LIFE IS FILLED INSTEAD...
--            AGING      interface-SAP we send the MIN-AGING, MOST OF THE TIME EMPTY, MAX-AGING IS FILLED INSTEAD...
--

select * from property where description like '%Aging%';
/*
property 	description							intl	status
---------	---------------------------------	------	--------
710530		Aging (Maximal)						1		0
710529		Aging (minimal)						1		0
--
713638		Aging wire box in creel room		1		0
713637		Aging wire in creel room			1		0
*/

--****************************
--AGING MAXIMAAL 
--710530		Aging (Maximal)						1		0
--****************************
SELECT DISTINCT SECTION_ID, SECTION_REV, SUB_SECTION_ID, SUB_SECTION_REV, PROPERTY_GROUP, PROPERTY_GROUP_REV 
FROM specification_prop sp                              
WHERE sp.part_no   like '%'     --  = 'EM_741'                              
AND   sp.revision = (select max(sh1.revision)                               
                     from status s1, specification_header sh1                              
                     where   sh1.part_no    = sp.part_no             --is component-part-no                              
                     and     sh1.status     = s1.status                               
                     and     s1.status_type in ('CURRENT','HISTORIC')                              
                    )                              
--AND   sp.section_id     = 700577 --  Chemical and physical properties                            
AND   sp.property       = 710530  -- Aging (maximal)
--and   rownum = 1                              
;

--700755	200	701506	100	703176	200
--700755	200	0		100	703176	200
--700755	200	701582	100	703176	200
--700755	200	701503	100	703176	200
--700755	200	701502	100	703176	200
--700755	100	0		100	703176	100
--700755	200	701504	100	703176	200

SELECT * FROM SECTION WHERE SECTION_ID = 700755;
--700755	SAP information	1	0

SELECT * FROM SUB_SECTION WHERE sub_SECTION_ID IN (  701502, 701503, 701504, 701506, 701582);
--701502	A	1	0
--701503	B	1	0
--701504	C	1	0
--701506	R	1	0
--701582	D	1	0

SELECT * FROM PROPERTY_GROUP WHERE PROPERTY_GROUP IN (703176);
--703176	Aging SAP		1	0	1

	
--COUNT PER NUM_1 VALUE:
select section_id, sub_section_id, property, NUM_1, count(*)
from specification_prop sp    
WHERE  sp.revision = (select max(sh1.revision)                               
                     from status s1, specification_header sh1                              
                     where   sh1.part_no    = sp.part_no             --is component-part-no                              
                     and     sh1.status     = s1.status                               
                     and     s1.status_type in ('CURRENT','HISTORIC')                              
                    )                   
AND   sp.property       = 710530  -- Aging (maximal)
GROUP BY section_id, sub_section_id,property, NUM_1
order by section_id, sub_section_id,property, NUM_1
;
/*
700755	0		710530	-1	5
700755	0		710530	0.66	1
700755	0		710530	1	23
700755	0		710530	2	114
700755	0		710530	3	781
700755	0		710530	4	1
700755	0		710530	5	1036
700755	0		710530	6	122
700755	0		710530	7	2868
700755	0		710530	9	1
700755	0		710530	10	2407
700755	0		710530	12	160
700755	0		710530	14	1247
700755	0		710530	15	5800
700755	0		710530	18	54
700755	0		710530	20	1
700755	0		710530	21	2091
700755	0		710530	24	44
700755	0		710530	25	1
700755	0		710530	30	5838
700755	0		710530	31	1329
700755	0		710530	45	1
700755	0		710530	60	442
700755	0		710530	90	108
700755	0		710530	91	2
700755	0		710530	180	62
700755	0		710530	182	1
700755	0		710530	270	343
700755	0		710530	365	3
700755	0		710530	450	2162
700755	0		710530	540	101
700755	0		710530	1035	9
700755	0		710530	1095	5228
700755	0		710530	2000	12
700755	0		710530	2190	21
700755	0		710530		2293
700755	701502	710530		114
700755	701503	710530		114
700755	701504	710530		114
700755	701506	710530		114
700755	701582	710530		114
*/

--CONCLUSIE: ALLEEN WAARDES VOOR AGING-MAXIMAAL BINNEN SUB-SECTION-ID=0 !!!!!!!!!!!!

select SUBSTR(part_no,1,3), NUM_1, count(*)
from specification_prop sp    
WHERE  sp.revision = (select max(sh1.revision)                               
                     from status s1, specification_header sh1                              
                     where   sh1.part_no    = sp.part_no             --is component-part-no                              
                     and     sh1.status     = s1.status                               
                     and     s1.status_type in ('CURRENT','HISTORIC')                              
                    )                   
AND   sp.property       = 710530  -- Aging (maximal)
GROUP BY SUBSTR(part_no,1,3), NUM_1
order by SUBSTR(part_no,1,3), NUM_1
;

/*
EF_	25	1
EF_	450	6
EF_	1095	5
EF_		15
...
GF_	90	4
GF_	180	4
GF_	270	5
GF_	450	767
GF_	540	29
GF_	1095	17
GF_		134
...
XEF	180	1
XEF	450	23
XEF	1095	66
XEF		191
...
XGF	90	30
XGF	180	50
XGF	270	337
XGF	450	1366
XGF	540	71
XGF	1035	9
XGF	1095	1541
XGF	2000	12
XGF		590

--conclusion: AGING-MAXIMAAL IS FILLED IN SOMETIMES WITH FINISHED-PRODUCTS, BUT MUCH MORE WITH THE COMPONENTS !!!!!!!!!
--
*/
	

--****************************
--AGING MINIMAL (ZIT WEL IN INTERSPEC-SAP-INTERFACE...)
--710529		Aging (minimal)	
--****************************
SELECT DISTINCT SECTION_ID, SECTION_REV, SUB_SECTION_ID, SUB_SECTION_REV, PROPERTY_GROUP, PROPERTY_GROUP_REV 
FROM specification_prop sp                              
WHERE sp.revision = (select max(sh1.revision)                               
                     from status s1, specification_header sh1                              
                     where   sh1.part_no    = sp.part_no             --is component-part-no                              
                     and     sh1.status     = s1.status                               
                     and     s1.status_type in ('CURRENT','HISTORIC')                              
                    )                              
AND   sp.property       = 710529  -- Aging (minimal)	
;

700755	200	701506	100	703176	200
700755	200	0		100	703176	200
700755	200	701582	100	703176	200
700755	0	0		0	703176	0
700755	200	701502	100	703176	200
700755	200	701503	100	703176	200
700755	100	0		100	703176	100
700755	200	701504	100	703176	200


SELECT * FROM SECTION WHERE SECTION_ID IN (700755 );
--700755	SAP information	1	0

SELECT * FROM SUB_SECTION WHERE sub_SECTION_ID IN (701502, 701503, 701504, 701506, 701582 );
--701502	A	1	0
--701503	B	1	0
--701504	C	1	0
--701506	R	1	0
--701582	D	1	0

SELECT * FROM PROPERTY_GROUP WHERE PROPERTY_GROUP IN (703176);
--703176	Aging SAP		1	0	1


--COUNT PER NUM_1 VALUE:
select section_id, sub_section_id, property, NUM_1, count(*)
from specification_prop sp    
WHERE  sp.revision = (select max(sh1.revision)                               
                     from status s1, specification_header sh1                              
                     where   sh1.part_no    = sp.part_no             --is component-part-no                              
                     and     sh1.status     = s1.status                               
                     and     s1.status_type in ('CURRENT','HISTORIC')                              
                    )                   
AND   sp.property       = 710529  -- Aging (minimal)	
GROUP BY section_id, sub_section_id,property, NUM_1
order by section_id, sub_section_id,property, NUM_1
;
/*
700755	0	710529	-1	5
700755	0	710529	0	20226
700755	0	710529	1	2334
700755	0	710529	2	516
700755	0	710529	3	5
700755	0	710529	4	4580
700755	0	710529	6	7
700755	0	710529	8	2128
700755	0	710529	10	34
700755	0	710529	16	58
700755	0	710529	24	303
700755	0	710529	72	1
700755	0	710529	90	2
700755	0	710529		2653
700755	701502	710529		114
700755	701503	710529		114
700755	701504	710529		114
700755	701506	710529		114
700755	701582	710529		114
*/

-->CONCLUSION: SHELF-LIFE-MIN IS ALMOST EVERYWARE EMPTY !!!! 


select SUBSTR(part_no,1,3), NUM_1, count(*)
from specification_prop sp    
WHERE  sp.revision = (select max(sh1.revision)                               
                     from status s1, specification_header sh1                              
                     where   sh1.part_no    = sp.part_no             --is component-part-no                              
                     and     sh1.status     = s1.status                               
                     and     s1.status_type in ('CURRENT','HISTORIC')                              
                    )                   
AND   sp.property       = 710529  -- Aging (minimal)	
GROUP BY SUBSTR(part_no,1,3), NUM_1
order by SUBSTR(part_no,1,3), NUM_1
;

/*
EF_	0	11
EF_	10	1
EF_		15
..
GF_	0	826
GF_		134
...
XEF	0	90
XEF		191
--
XGF	0	3320
XGF	1	63
XGF	10	33
XGF		590

--conclusion: ALMOST EVERY FINISHED-PRODUCTS HAS A MIN-AGING WITH A VALUE EQUALS 0/NULL !!!!
*/


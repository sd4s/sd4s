--EPREL-RESULTS contains a VALUE with a decimal-komma instead of a decimal-point !!!!!!!!
--Bijv. PART-NO:  GF_2055017WPPXH (rev: 13)		Property-group: PAC outdoor testing		Property: ECE Noise labeling
--                                                                                                ECE Wet Grip labeling (vehicle)
--                                                                                                ECE Snowflake R117
--                                                                                                ECE Rolling resistance Labeling
--                GF_2055017WPPXV (rev: 14)		Property-group: PAC outdoor testing		Property: ECE Noise labeling
--                                                                                                ECE Wet Grip labeling (vehicle)
--                                                                                                ECE Snowflake R117
--                                                                                                ECE Rolling resistance Labeling
--                GF_2054517WPPXV (rev: 9)		Property-group: PAC outdoor testing		Property: ECE Noise labeling
--                                                                                                ECE Wet Grip labeling (vehicle)
--                                                                                                ECE Snowflake R117
--                                                                                                ECE Rolling resistance Labeling
--
--                GF_2554520WPPXV (rev: 8)                      PAC indoor testing                Tyre width (max)
--                                                                                                Tyre width (average)
--                                                                                                Tyre diameter
--                                                                                                Tyre weight
--                                                                                                etc.


select * from property_group where description like '%PAC%' ;
704036	PAC indoor testing
704037	PAC outdoor testing


select sp.part_no, sp.revision, sp.section_id, sp.sub_section_id, sp.property_group, sp.property, p.description, num_1, num_2, num_3, num_4, num_5, num_6, num_7, num_8, num_9, char_1, char_2, char_3, char_4, char_5
from specification_prop sp
JOIN property            p on p.property = sp.property
WHERE sp.part_no='GF_2055017WPPXH'
AND sp.property_group in (704036, 704037)
--and   sp.section_id = 701115 and sp.sub_section_id =0 and sp.property_group in (704036, 704037) 
order by sp.part_no, sp.revision, sp.section_id, sp.sub_section_id, sp.property_group, sp.property
;
/*
GF_2055017WPPXH	4	701115	0	704037	708628	ECE Noise labeling			73.9		73.4									
GF_2055017WPPXH	4	701115	0	704037	708629	ECE Wet Grip labeling (trailer)		1.43		1.58										
GF_2055017WPPXH	4	701115	0	704037	713650	ECE Snowflake R117		110				107								
GF_2055017WPPXH	4	701115	0	704037	713651	ECE Wet Grip labeling (vehicle)						1.1								
--
--CONCLUSIE: Zien hier geen RESULT-column terug.
*/
select sp.part_no, sp.revision, sp.section_id, sp.sub_section_id, sp.property_group, sp.property, p.description, num_1, num_2, num_3, num_4, num_5, num_6, num_7, num_8, num_9, char_1, char_2, char_3, char_4, char_5
from specification_prop sp
JOIN property            p on p.property = sp.property
WHERE sp.part_no='GF_2055017WPPXH' and sp.revision = 13
AND sp.property_group in (704036, 704037)
AND sp.property       in (708628, 708629, 713650, 713651)
and REGEXP_LIKE(sp.CHAR_2, '^-?\d+,\d+$') 
order by part_no, revision, section_id, property_group, sequence_no
;
--GF_2055017WPPXH	13	701115	0	704037	713650	ECE Snowflake R117		110				107				23.591.KEC	1,26			

select sp.part_no, sp.revision, sp.section_id, sp.sub_section_id, sp.property_group, sp.property, p.description, num_1, num_2, num_3, num_4, num_5, num_6, num_7, num_8, num_9, char_1, char_2, char_3, char_4, char_5
from specification_prop sp
JOIN property            p on p.property = sp.property
WHERE sp.part_no='GF_2055017WPPXV' and sp.revision = 14
AND sp.property_group in (704036, 704037)
AND sp.property       in (708628, 708629, 713650, 713651)
and REGEXP_LIKE(sp.CHAR_2, '^-?\d+,\d+$') 
order by part_no, revision, section_id, property_group, sequence_no
;
--GF_2055017WPPXV	14	701115	0	704037	713651	ECE Wet Grip labeling (vehicle)								1.1				23.975.GEK	1,45			
--GF_2055017WPPXV	14	701115	0	704037	713650	ECE Snowflake R117							110				107				23.591.KEC	1,26			


select sp.part_no, sp.revision, sp.section_id, sp.sub_section_id, sp.property_group, sp.property, p.description, num_1, num_2, num_3, num_4, num_5, num_6, num_7, num_8, num_9, char_1, char_2, char_3, char_4, char_5
from specification_prop sp
JOIN property            p on p.property = sp.property
WHERE sp.part_no='GF_2054517WPPXV' and sp.revision = 9
AND sp.property_group in (704036, 704037)
AND sp.property       in (708628, 708629, 713650, 713651)
and REGEXP_LIKE(sp.CHAR_2, '^-?\d+,\d+$') 
order by part_no, revision, section_id, property_group, sequence_no
;
--GF_2054517WPPXV	9	701115	0	704037	713651	ECE Wet Grip labeling (vehicle)						1.1				23.975.GEK	1,45			
--GF_2054517WPPXV	9	701115	0	704037	713650	ECE Snowflake R117		110				107				23.591.KEC	1,26			

select sp.part_no, sp.revision, sp.section_id, sp.sub_section_id, sp.property_group, sp.property, p.description, num_1, num_2, num_3, num_4, num_5, num_6, num_7, num_8, num_9, char_1, char_2, char_3, char_4, char_5
from specification_prop sp
JOIN property            p on p.property = sp.property
WHERE sp.part_no='GF_2554520WPPXV' and sp.revision = 8
AND sp.property_group in (704036, 704037)
AND sp.property       in (708628, 708629, 713650, 713651)
and REGEXP_LIKE(sp.CHAR_2, '^-?\d+,\d+$') 
order by part_no, revision, section_id, property_group, sequence_no
;
--GF_2554520WPPXV	8	701115	0	704037	713650	ECE Snowflake R117		1.1				1.07				23.591.KEC	1,26			



--***************************************************************************************
--***************************************************************************************
--TOTAAL-properties
select sp.part_no, sp.revision, sp.section_id, sp.sub_section_id, sp.property_group, sp.property, p.description, num_1, num_2, num_3, num_4, num_5, num_6, num_7, num_8, num_9, char_1, char_2, char_3, char_4, char_5
from specification_prop sp
JOIN property            p on p.property = sp.property
--WHERE sp.part_no='GF_2554520WPPXV' and sp.revision = 8
WHERE sp.property_group in (704036, 704037)
--AND   sp.property       in (708628, 708629, 713650, 713651)
and REGEXP_LIKE(sp.CHAR_2, '^-?\d+,\d+$') 
order by part_no, revision, section_id, property_group, sequence_no
;
/*
AF_H215/70R16PHT	2	701115	0	704037	708628	ECE Noise labeling						73.9				21.233.LRM	73,63			
AF_H215/70R16PHT	2	701115	0	704037	708629	ECE Wet Grip labeling (trailer)	1.39	1.25				1.25				20.828.LRM	1,39			
AF_H215/70R16PHT	2	701115	0	704037	713651	ECE Wet Grip labeling (vehicle)		1.25				1.25				20.828.LRM	1,39			
AF_H215/70R16PHT	3	701115	0	704037	708628	ECE Noise labeling						73.9				21.233.LRM	73,63			
AF_H215/70R16PHT	3	701115	0	704037	708629	ECE Wet Grip labeling (trailer)	1.39	1.25				1.25				20.828.LRM	1,39			
AF_H215/70R16PHT	3	701115	0	704037	713651	ECE Wet Grip labeling (vehicle)		1.25				1.25				20.828.LRM	1,39			
AF_H215/70R16PHT	4	701115	0	704037	708628	ECE Noise labeling						73.9				21.233.LRM	73,63			
AF_H215/70R16PHT	4	701115	0	704037	708629	ECE Wet Grip labeling (trailer)	1.39	1.25				1.25				20.828.LRM	1,39			
AF_H215/70R16PHT	4	701115	0	704037	713651	ECE Wet Grip labeling (vehicle)		1.25				1.25				20.828.LRM	1,39			
AF_H215/70R16PHT	5	701115	0	704037	708628	ECE Noise labeling						73.9				21.233.LRM	73,63			
AF_H215/70R16PHT	5	701115	0	704037	708629	ECE Wet Grip labeling (trailer)	1.39	1.25				1.25				20.828.LRM	1,39			
AF_H215/70R16PHT	5	701115	0	704037	713651	ECE Wet Grip labeling (vehicle)		1.25				1.25				20.828.LRM	1,39			
AF_R195/75R16C2AP2	4	701115	0	704037	708628	ECE Noise labeling			74.9		74.4					20.826.LRM	74,49			
AF_R195/75R16C2AP2	4	701115	0	704037	708629	ECE Wet Grip labeling (trailer)										19.423.JRA	1,24			
AF_R195/75R16C2AP2	5	701115	0	704037	708628	ECE Noise labeling			74.9		74.4					20.826.LRM	74,49			
AF_R195/75R16C2AP2	5	701115	0	704037	708629	ECE Wet Grip labeling (trailer)										19.423.JRA	1,24			
AF_R195/75R16C2AP2	6	701115	0	704037	708628	ECE Noise labeling			74.9		74.4					20.826.LRM	74,49			
AF_R195/75R16C2AP2	6	701115	0	704037	708629	ECE Wet Grip labeling (trailer)										19.423.JRA	1,24			
AF_R195/75R16C2AP2	7	701115	0	704037	708628	ECE Noise labeling			74.9		74.4					20.826.LRM	74,49			
AF_R195/75R16C2AP2	7	701115	0	704037	708629	ECE Wet Grip labeling (trailer)										19.423.JRA	1,24			
GF_1955017WPRHB		4	701115	0	704037	708628	ECE Noise labeling	72.3		73.9	73.4		73.9				23.106.YGR	72,3			
GF_1955017WPRHB		4	701115	0	704037	713651	ECE Wet Grip labeling (vehicle)	1.65	1.4				1.1				22.884.YGR	1,65			
GF_1955017WPRHB		4	701115	0	704037	713650	ECE Snowflake R117		1.07				1.07				22.812.YGR	1,08			
GF_2054517WPPXV		8	701115	0	704037	713651	ECE Wet Grip labeling (vehicle)						1.1				23.975.GEK	1,45			
GF_2054517WPPXV		8	701115	0	704037	713650	ECE Snowflake R117		110				107				23.591.KEC	1,26			
GF_2054517WPPXV		9	701115	0	704037	713651	ECE Wet Grip labeling (vehicle)						1.1				23.975.GEK	1,45			
GF_2054517WPPXV		9	701115	0	704037	713650	ECE Snowflake R117		110				107				23.591.KEC	1,26			
GF_2055017WPPXH		10	701115	0	704037	713650	ECE Snowflake R117		110				107				23.591.KEC	1,26			
GF_2055017WPPXH		11	701115	0	704037	713650	ECE Snowflake R117		110				107				23.591.KEC	1,26			
GF_2055017WPPXH		12	701115	0	704037	713650	ECE Snowflake R117		110				107				23.591.KEC	1,26			
GF_2055017WPPXH		13	701115	0	704037	713650	ECE Snowflake R117		110				107				23.591.KEC	1,26			
GF_2055017WPPXV		11	701115	0	704037	713651	ECE Wet Grip labeling (vehicle)						1.1				23.975.GEK	1,45			
GF_2055017WPPXV		11	701115	0	704037	713650	ECE Snowflake R117		110				107				23.591.KEC	1,26			
GF_2055017WPPXV		12	701115	0	704037	713651	ECE Wet Grip labeling (vehicle)						1.1				23.975.GEK	1,45			
GF_2055017WPPXV		12	701115	0	704037	713650	ECE Snowflake R117		110				107				23.591.KEC	1,26			
GF_2055017WPPXV		13	701115	0	704037	713651	ECE Wet Grip labeling (vehicle)						1.1				23.975.GEK	1,45			
GF_2055017WPPXV		13	701115	0	704037	713650	ECE Snowflake R117		110				107				23.591.KEC	1,26			
GF_2055017WPPXV		14	701115	0	704037	713651	ECE Wet Grip labeling (vehicle)						1.1				23.975.GEK	1,45			
GF_2055017WPPXV		14	701115	0	704037	713650	ECE Snowflake R117		110				107				23.591.KEC	1,26			
GF_2055517QPEXW		6	701115	0	704037	708629	ECE Wet Grip labeling (trailer)		1.43				1				22.757.RTW03	1,61			
GF_2055517QPEXW		6	701115	0	704037	713651	ECE Wet Grip labeling (vehicle)		1.43				1.1				22.757.RTW03	1,61			
GF_2055517QPEXW		6	701115	0	704037	713650	ECE Snowflake R117		110				107				22.757.RTW03	1,10			
GF_2255518QPEXV		4	701115	0	704037	708629	ECE Wet Grip labeling (trailer)		1.43				1				22.757.RTW03	1,61			
GF_2255518QPEXV		4	701115	0	704037	713651	ECE Wet Grip labeling (vehicle)		1.43				1				22.757.RTW03	1,61			
GF_2255518QPEXV		4	701115	0	704037	713650	ECE Snowflake R117		110				107				22.757.RTW03	1,10			
GF_2355020QPEXV		4	701115	0	704037	708629	ECE Wet Grip labeling (trailer)		1.43				1				22.757.RTW03	1,61			
GF_2355020QPEXV		4	701115	0	704037	713651	ECE Wet Grip labeling (vehicle)		1.43				1				22.644.RTW03	1,61			
GF_2355020QPEXV		5	701115	0	704037	708629	ECE Wet Grip labeling (trailer)		1.43				1				22.757.RTW03	1,61			
GF_2355020QPEXV		5	701115	0	704037	713651	ECE Wet Grip labeling (vehicle)		1.43				1				22.644.RTW03	1,61			
GF_2554520WPPXV		6	701115	0	704037	713650	ECE Snowflake R117		1.1				1.07				23.591.KEC	1,26			
GF_2554520WPPXV		7	701115	0	704037	713650	ECE Snowflake R117		1.1				1.07				23.591.KEC	1,26			
GF_2554520WPPXV		8	701115	0	704037	713650	ECE Snowflake R117		1.1				1.07				23.591.KEC	1,26			
GF_385552260KERT2	1	701115	0	704037	713651	ECE Wet Grip labeling (vehicle)										CV222110868	1,17			
GF_385552260KERT2	1	701115	0	704037	713650	ECE Snowflake R117										TW-TLA22-AP144-E117SP	1,35			
GF_385552260KERT2	2	701115	0	704037	713651	ECE Wet Grip labeling (vehicle)										CV222110868	1,17			
GF_385552260KERT2	2	701115	0	704037	713650	ECE Snowflake R117										TW-TLA22-AP144-E117SP	1,35			
--
--conclusie: hier zitten alle SPECS in waarvoor probleem gemeld is !!!
--           aantal specs valt eigenlijk nu wel mee.
*/


select sp.part_no, sp.revision, sp.property, p.description, SP.char_2 
, case WHEN REGEXP_LIKE (SP.CHAR_2, '^-?\d+,\d+$')  THEN to_number(REGEXP_REPLACE (SP.CHAR_2, ',', '.' )) ELSE 9999 end  expresult 
from specification_prop sp
JOIN property            p on p.property = sp.property
--WHERE sp.part_no='GF_2554520WPPXV' and sp.revision = 8
WHERE sp.property_group in (704036, 704037)
AND   sp.property       in (708628, 708629, 713650, 713651)
and REGEXP_LIKE(sp.CHAR_2, '^-?\d+,\d+$') 
order by part_no, revision, section_id, property_group, sequence_no
;



--************************************************************
--************************************************************
--SPECDATA:
--************************************************************
--************************************************************
select *
from specdata sp
JOIN property            p on p.property = sp.property
WHERE sp.part_no='GF_2554520WPPXV' and sp.revision = 8
AND sp.property_group in (704036, 704037)
AND   sp.property       in (708628, 708629, 713650, 713651)
and REGEXP_LIKE(sp.VALUE_S, '^-?\d+,\d+$') 
order by part_no, revision, section_id, property_group, sequence_no
;
--GF_2554520WPPXV	8	701115	0	28	1	704037	100	704037	713650	0	701900	0	1,26	700569	702204	-1	-1	-1	2	1		100	100	100	200	100	100	100	0	0	100	0	1	713650	ECE Snowflake R117	1	0


select *
from specdata sp
JOIN property            p on p.property = sp.property
WHERE sp.part_no='GF_2054517WPPXV' and sp.revision = 9
AND sp.property_group in (704036, 704037)
AND   sp.property       in (708628, 708629, 713650, 713651)
and REGEXP_LIKE(sp.VALUE_S, '^-?\d+,\d+$') 
order by part_no, revision, section_id, property_group, sequence_no
;
--GF_2054517WPPXV	9	701115	0	19	1	704037	100	704037	713651	0	701900	0	1,45	700569	702210
--GF_2054517WPPXV	9	701115	0	28	1	704037	100	704037	713650	0	701900	0	1,26	700569	702204

select *
from specdata sp
JOIN property            p on p.property = sp.property
WHERE sp.part_no='GF_2055017WPPXV' and sp.revision = 14
AND sp.property_group in (704036, 704037)
AND   sp.property       in (708628, 708629, 713650, 713651)
and REGEXP_LIKE(sp.VALUE_S, '^-?\d+,\d+$') 
order by part_no, revision, section_id, property_group, sequence_no
;
--GF_2055017WPPXV	14	701115	0	19	1	704037	100	704037	713651	0	701900	0	1,45	700569	702210
--GF_2055017WPPXV	14	701115	0	28	1	704037	100	704037	713650	0	701900	0	1,26	700569	702204

select *
from specdata sp
JOIN property            p on p.property = sp.property
WHERE sp.part_no='GF_2055017WPPXH' and sp.revision = 13
AND sp.property_group in (704036, 704037)
AND   sp.property       in (708628, 708629, 713650, 713651)
and REGEXP_LIKE(sp.VALUE_S, '^-?\d+,\d+$') 
order by part_no, revision, section_id, property_group, sequence_no
;
--GF_2055017WPPXH	13	701115	0	28	1	704037	100	704037	713650	0	701900	0	1,26	700569	702204

--********************
--TOTAL SPECDATA:
--TOTAAL-properties
select sp.part_no, sp.revision, sp.section_id, sp.sub_section_id, sp.property_group, sp.property, p.description, value, value_s
from specdata sp
JOIN property            p on p.property = sp.property
--WHERE sp.part_no='GF_2554520WPPXV' and sp.revision = 8
WHERE sp.property_group in (704036, 704037)
AND   sp.property       in (708628, 708629, 713650, 713651)
and REGEXP_LIKE(sp.VALUE_S, '^-?\d+,\d+$') 
order by part_no, revision, section_id, property_group, sequence_no
;
/*
AF_H215/70R16PHT	2	701115	0	704037	708628	ECE Noise labeling	0	73,63
AF_H215/70R16PHT	2	701115	0	704037	708629	ECE Wet Grip labeling (trailer)	0	1,39
AF_H215/70R16PHT	2	701115	0	704037	713651	ECE Wet Grip labeling (vehicle)	0	1,39
AF_H215/70R16PHT	3	701115	0	704037	708628	ECE Noise labeling	0	73,63
AF_H215/70R16PHT	3	701115	0	704037	708629	ECE Wet Grip labeling (trailer)	0	1,39
AF_H215/70R16PHT	3	701115	0	704037	713651	ECE Wet Grip labeling (vehicle)	0	1,39
AF_H215/70R16PHT	4	701115	0	704037	708628	ECE Noise labeling	0	73,63
AF_H215/70R16PHT	4	701115	0	704037	708629	ECE Wet Grip labeling (trailer)	0	1,39
AF_H215/70R16PHT	4	701115	0	704037	713651	ECE Wet Grip labeling (vehicle)	0	1,39
AF_H215/70R16PHT	5	701115	0	704037	708628	ECE Noise labeling	0	73,63
AF_H215/70R16PHT	5	701115	0	704037	708629	ECE Wet Grip labeling (trailer)	0	1,39
AF_H215/70R16PHT	5	701115	0	704037	713651	ECE Wet Grip labeling (vehicle)	0	1,39
AF_R195/75R16C2AP2	4	701115	0	704037	708628	ECE Noise labeling	0	74,49
AF_R195/75R16C2AP2	4	701115	0	704037	708629	ECE Wet Grip labeling (trailer)	0	1,24
AF_R195/75R16C2AP2	5	701115	0	704037	708628	ECE Noise labeling	0	74,49
AF_R195/75R16C2AP2	5	701115	0	704037	708629	ECE Wet Grip labeling (trailer)	0	1,24
AF_R195/75R16C2AP2	6	701115	0	704037	708628	ECE Noise labeling	0	74,49
AF_R195/75R16C2AP2	6	701115	0	704037	708629	ECE Wet Grip labeling (trailer)	0	1,24
AF_R195/75R16C2AP2	7	701115	0	704037	708628	ECE Noise labeling	0	74,49
AF_R195/75R16C2AP2	7	701115	0	704037	708629	ECE Wet Grip labeling (trailer)	0	1,24
GF_1955017WPRHB		4	701115	0	704037	708628	ECE Noise labeling	0	72,3
GF_1955017WPRHB		4	701115	0	704037	713651	ECE Wet Grip labeling (vehicle)	0	1,65
GF_1955017WPRHB		4	701115	0	704037	713650	ECE Snowflake R117	0	1,08
GF_2054517WPPXV		8	701115	0	704037	713651	ECE Wet Grip labeling (vehicle)	0	1,45
GF_2054517WPPXV		8	701115	0	704037	713650	ECE Snowflake R117	0	1,26
GF_2054517WPPXV		9	701115	0	704037	713651	ECE Wet Grip labeling (vehicle)	0	1,45
GF_2054517WPPXV		9	701115	0	704037	713650	ECE Snowflake R117	0	1,26
GF_2055017WPPXH		10	701115	0	704037	713650	ECE Snowflake R117	0	1,26
GF_2055017WPPXH		11	701115	0	704037	713650	ECE Snowflake R117	0	1,26
GF_2055017WPPXH		12	701115	0	704037	713650	ECE Snowflake R117	0	1,26
GF_2055017WPPXH		13	701115	0	704037	713650	ECE Snowflake R117	0	1,26
GF_2055017WPPXV		11	701115	0	704037	713651	ECE Wet Grip labeling (vehicle)	0	1,45
GF_2055017WPPXV		11	701115	0	704037	713650	ECE Snowflake R117	0	1,26
GF_2055017WPPXV		12	701115	0	704037	713651	ECE Wet Grip labeling (vehicle)	0	1,45
GF_2055017WPPXV		12	701115	0	704037	713650	ECE Snowflake R117	0	1,26
GF_2055017WPPXV		13	701115	0	704037	713651	ECE Wet Grip labeling (vehicle)	0	1,45
GF_2055017WPPXV		13	701115	0	704037	713650	ECE Snowflake R117	0	1,26
GF_2055017WPPXV		14	701115	0	704037	713651	ECE Wet Grip labeling (vehicle)	0	1,45
GF_2055017WPPXV		14	701115	0	704037	713650	ECE Snowflake R117	0	1,26
GF_2055517QPEXW		6	701115	0	704037	708629	ECE Wet Grip labeling (trailer)	0	1,61
GF_2055517QPEXW		6	701115	0	704037	713651	ECE Wet Grip labeling (vehicle)	0	1,61
GF_2055517QPEXW		6	701115	0	704037	713650	ECE Snowflake R117	0	1,10
GF_2255518QPEXV		4	701115	0	704037	708629	ECE Wet Grip labeling (trailer)	0	1,61
GF_2255518QPEXV		4	701115	0	704037	713651	ECE Wet Grip labeling (vehicle)	0	1,61
GF_2255518QPEXV		4	701115	0	704037	713650	ECE Snowflake R117	0	1,10
GF_2355020QPEXV		4	701115	0	704037	708629	ECE Wet Grip labeling (trailer)	0	1,61
GF_2355020QPEXV		4	701115	0	704037	713651	ECE Wet Grip labeling (vehicle)	0	1,61
GF_2355020QPEXV		5	701115	0	704037	708629	ECE Wet Grip labeling (trailer)	0	1,61
GF_2355020QPEXV		5	701115	0	704037	713651	ECE Wet Grip labeling (vehicle)	0	1,61
GF_2554520WPPXV		6	701115	0	704037	713650	ECE Snowflake R117	0	1,26
GF_2554520WPPXV		7	701115	0	704037	713650	ECE Snowflake R117	0	1,26
GF_2554520WPPXV		8	701115	0	704037	713650	ECE Snowflake R117	0	1,26
GF_385552260KERT2	1	701115	0	704037	713651	ECE Wet Grip labeling (vehicle)	0	1,17
GF_385552260KERT2	1	701115	0	704037	713650	ECE Snowflake R117	0	1,35
GF_385552260KERT2	2	701115	0	704037	713651	ECE Wet Grip labeling (vehicle)	0	1,17
GF_385552260KERT2	2	701115	0	704037	713650	ECE Snowflake R117	0	1,35
*/




--************************************************************************************************
--************************************************************************************************
--TOTAAL PAC-INDOOR + PAC-OUTDOOR (SELECTIE ALLEEN OP PROPERTY-GROUPEN !!!!!!!!!!!!!!!!!!!!)
--************************************************************************************************
--************************************************************************************************
select sp.part_no, sp.revision, sp.section_id, sp.sub_section_id, sp.property_group, sp.property, p.description, num_1, num_2, num_3, num_4, num_5, num_6, num_7, num_8, num_9, char_1, char_2, char_3, char_4, char_5
from specification_prop sp
JOIN property            p on p.property = sp.property
--WHERE sp.part_no='GF_2554520WPPXV' and sp.revision = 8
WHERE sp.property_group in (704036, 704037)
--AND   sp.property       in (708628, 708629, 713650, 713651)
and REGEXP_LIKE(sp.CHAR_2, '^-?\d+,\d+$') 
order by part_no, revision, section_id, property_group, sequence_no
;


select sp.part_no, sp.revision, sp.section_id, sp.sub_section_id, sp.property_group, sp.property, p.description, value, value_s
from specdata sp
JOIN property            p on p.property = sp.property
--WHERE sp.part_no='GF_2554520WPPXV' and sp.revision = 8
WHERE sp.property_group in (704036, 704037)
--AND   sp.property       in (708628, 708629, 713650, 713651)
AND ( sp.part_no like 'EF%' OR sp.part_no like 'GF%')
and REGEXP_LIKE(sp.VALUE_S, '^-?\d+,\d+$') 
order by part_no, revision, section_id, property_group, sequence_no
;
--625 rijen !!!!!




--***************************************************************
--***************************************************************
-- HERSTELLEN van VALUE_S met numerieke-waardes en komma als decimaal-scheider...
--***************************************************************
--***************************************************************



--SPECIFICATION_PROP:
update SPECIFICATION_PROP sp
set sp.CHAR_2 = case WHEN REGEXP_LIKE (sp.CHAR_2, '^-?\d+,\d+$')  
                      THEN REGEXP_REPLACE (sp.CHAR_2, ',', '.' ) 
					  ELSE sp.CHAR_2 
			     end 
WHERE  REGEXP_LIKE(sp.CHAR_2, '^-?\d+,\d+$') 
--and   sp.part_no='GF_2055017WPPXH' and sp.revision = 13
and   sp.property_group in (704036, 704037)
--AND   sp.property       in (708628, 708629, 713650, 713651)
AND ( sp.part_no like 'EF%' OR sp.part_no like 'GF%')
;


--SPECDATA:
update SPECDATA sp
set sp.value = case   WHEN REGEXP_LIKE (sp.value_s, '^-?\d+,\d+$')  
                      THEN to_number( REGEXP_REPLACE (sp.value_s, ',', '.' )  )
					  ELSE sp.value
			     end 
,   sp.value_S = case WHEN REGEXP_LIKE (sp.value_s, '^-?\d+,\d+$')  
                      THEN REGEXP_REPLACE (sp.value_s, ',', '.' )  
					  ELSE sp.value_s
			     end 
WHERE  REGEXP_LIKE(sp.value_s, '^-?\d+,\d+$') 
AND NOT REGEXP_LIKE(sp.value_s, '^-?\d+,\d+,')     --niet een string met meerdere komma's
AND   nvl(sp.value,0) = 0 
--and   sp.part_no='GF_2055017WPPXH' and sp.revision = 13
AND   sp.property_group in (704036, 704037)
--AND   sp.property       in (708628, 708629, 713650, 713651)
AND ( sp.part_no like 'EF%' OR sp.part_no like 'GF%')
;

commit;

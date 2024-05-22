--HERSTEL-SCRIPT om voor PROPERTIES alle VALUE_S-strings in numerieke-waardes de komma te vervangen door een PUNT !!!

--SPECDATA:
--decimal-KOMMA
with q_sp as
( select sp.part_no, sp.revision, sp.section_id, sp.sub_section_id, sp.property_group, sp.property, sp.value_s, sp.value
       from specdata sp
       WHERE  REGEXP_LIKE(sp.value_s, '^-?\d+,\d+$') 
       --WHERE  REGEXP_LIKE(sp.value_s, '^,\d+$')        --levert geen resultaat
)
select count(*)
from q_sp  qs
--where qs.revision = (select max(sp2.revision) from specdata sp2 where sp2.part_no        = qs.part_no )   
where qs.revision = (select max(sp2.revision) from specification_header sp2 where sp2.part_no = qs.part_no )   
--where qs.value = 0  
--WHERE nvl(qs.value,-1)  <> 0
;
--DECIMAL-POINT
with q_sp as
( select sp.part_no, sp.revision, sp.section_id, sp.sub_section_id, sp.property_group, sp.property, sp.value_s, sp.value
       from specdata sp
       WHERE  REGEXP_LIKE(sp.value_s, '^-?\d+\.\d+$') 
       --WHERE  REGEXP_LIKE(sp.value_s, '^,\d+$')        --levert geen resultaat
)
select count(*)
from q_sp  qs
--where qs.revision = (select max(sp2.revision) from specdata sp2 where sp2.part_no        = qs.part_no )   
--where qs.revision = (select max(sp2.revision) from specification_header sp2 where sp2.part_no = qs.part_no )   
where qs.value = 0  
--WHERE nvl(qs.value,-1)  <> 0
;

--total:                             194.362.095 rows
--total value_s with comma:               17.404 rows  
--total starting with comma:                   0 rows
--total-only-current-revision:             5.003 rows
--total value_s with comma + value=0:     15.105 rows  
--total value_s with comma + value<>0:     2.300 rows  
--total value_s with point            11.894.242 rows
--total value_s with point + value=0:            rows


select s.part_no, s.revision, s.section_id, s.sub_section_id, s.property_group, s.property, s.prop_descr, s.value_s, s.value
--, case WHEN REGEXP_LIKE (s.value_s, '^-?\d+,\d+$')  THEN REGEXP_REPLACE (s.value_s, ',', '.' ) ELSE 'FOUT' end  expresult 
from ( select sp.part_no, sp.revision, sp.section_id, sp.sub_section_id, sp.property_group, sp.property, p.description prop_descr, sp.value_s, sp.value
       from specdata sp
	   JOIN property p on p.property = sp.property
       WHERE  REGEXP_LIKE(sp.value_s, '^-?\d+,\d+$') 
      )  s
WHERE nvl(s.value,-1)  <> 0
;
--
/*
select sp.part_no, sp.revision, sp.section_id, sp.sub_section_id, sp.property_group, sp.property, p.description, num_1, num_2, num_3, num_4, num_5, num_6, num_7, num_8, num_9, char_1, char_2, char_3, char_4, char_5
from specification_prop sp
JOIN property p on p.property = sp.property
WHERE sp.part_no = 'EF_T215/55R17WNIXS'
and   sp.section_id = 700835 and sp.sub_section_id =0 and sp.property_group in (701559) and sp.property=705170
order by sp.part_no, sp.revision, sp.section_id, sp.sub_section_id, sp.property_group, sp.property
;

EF_T215/55R17WNIXS	2	700835	0	701559	705170	Cord angle belt layer 1	25.0371710114149	2	2								A_B			
EF_T215/55R17WNIXS	3	700835	0	701559	705170	Cord angle belt layer 1	25.0371710114149	2	2								A_B			
EF_T215/55R17WNIXS	4	700835	0	701559	705170	Cord angle belt layer 1	25.0371710114149	2	2								A_B			
EF_T215/55R17WNIXS	5	700835	0	701559	705170	Cord angle belt layer 1	25.0371710114149	2	2								A_B			
EF_T215/55R17WNIXS	6	700835	0	701559	705170	Cord angle belt layer 1	25.0371710114149	2	2								A_B			
EF_T215/55R17WNIXS	7	700835	0	701559	705170	Cord angle belt layer 1	25.0371710114149	2	2								A_B			
EF_T215/55R17WNIXS	8	700835	0	701559	705170	Cord angle belt layer 1	25.0371710114149	2	2								A_B			
EF_T215/55R17WNIXS	9	700835	0	701559	705170	Cord angle belt layer 1	25.0371710114149	2	2								A_B			
EF_T215/55R17WNIXS	10	700835	0	701559	705170	Cord angle belt layer 1	25.0371710114149	2	2								A_B			
EF_T215/55R17WNIXS	11	700835	0	701559	705170	Cord angle belt layer 1	25.0371710114149	2	2								A_B			
EF_T215/55R17WNIXS	12	700835	0	701559	705170	Cord angle belt layer 1	25.0371710114149	2	2								A_B			
EF_T215/55R17WNIXS	13	700835	0	701559	705170	Cord angle belt layer 1	25.0371710114149	2	2								A_B			
EF_T215/55R17WNIXS	14	700835	0	701559	705170	Cord angle belt layer 1	25.0371710114149	2	2								A_B			
EF_T215/55R17WNIXS	15	700835	0	701559	705170	Cord angle belt layer 1	25.0371710114149	2	2								A_B			
EF_T215/55R17WNIXS	16	700835	0	701559	705170	Cord angle belt layer 1	25.0371710114149	2	2								A_B			
EF_T215/55R17WNIXS	17	700835	0	701559	705170	Cord angle belt layer 1	25.0371710114149	2	2								A_B			

select sp.part_no, sp.revision, sp.section_id, sp.sub_section_id, sp.property_group, sp.property, p.description, value_s, value
from specdata sp
JOIN property p on p.property = sp.property
WHERE sp.part_no = 'EF_T215/55R17WNIXS'
and   sp.section_id = 700835 and sp.sub_section_id =0 and sp.property_group in (701559) and sp.property=705170
order by sp.part_no, sp.revision, sp.section_id, sp.sub_section_id, sp.property_group, sp.property
;
EF_T215/55R17WNIXS	7	700835	0	701559	705170	Cord angle belt layer 1	25,0371710114149	25.0371710114149
EF_T215/55R17WNIXS	7	700835	0	701559	705170	Cord angle belt layer 1	N					0
EF_T215/55R17WNIXS	7	700835	0	701559	705170	Cord angle belt layer 1	A_B					0
EF_T215/55R17WNIXS	7	700835	0	701559	705170	Cord angle belt layer 1	2					2
EF_T215/55R17WNIXS	7	700835	0	701559	705170	Cord angle belt layer 1	2					2

--> STRING-VALUE wordt in SPECDATA wel gevuld terwijl alleen NUM-VALUE gevuld is, en krijgt nu wel een KOMMA !!!!!!

--GT_QST70140007
select sp.part_no, sp.revision, sp.section_id, sp.sub_section_id, sp.property_group, sp.property, p.description, value_s, value
from specdata sp
JOIN property p on p.property = sp.property
WHERE sp.part_no = 'GT_QST70140007' and sp.revision=6
and   sp.section_id = 700775 and sp.sub_section_id =0 and sp.property_group in (701576) and sp.property=705710
order by sp.part_no, sp.revision, sp.section_id, sp.sub_section_id, sp.property_group, sp.property
;
GT_QST70140007	6	700775	0	701576	705710	Coordinate 02	2,90000000000001	2.90000000000001
GT_QST70140007	6	700775	0	701576	705710	Coordinate 02	0	0
GT_QST70140007	6	700775	0	701576	705710	Coordinate 02	0	0
GT_QST70140007	6	700775	0	701576	705710	Coordinate 02	1,53789473684211	1.53789473684211
GT_QST70140007	6	700775	0	701576	705710	Coordinate 02	0	0
GT_QST70140007	6	700775	0	701576	705710	Coordinate 02	1,53789473684211	1.53789473684211
GT_QST70140007	6	700775	0	701576	705710	Coordinate 02		

--> STRING-VALUE wordt in SPECDATA met een verkeerde waarde gevuld !!!. Krijgt naast de komma, ook 

--EK_B600/65R38-153K

select sp.part_no, sp.revision, sp.section_id, sp.sub_section_id, sp.property_group, sp.property, p.description, num_1, num_2, num_3, num_4, num_5, num_6, num_7, num_8, num_9, char_1, char_2, char_3, char_4, char_5
from specification_prop sp
JOIN property p on p.property = sp.property
WHERE sp.part_no = 'EK_B600/65R38-153K'
and   sp.section_id = 700583 and sp.sub_section_id =701270 and sp.property_group in (702476) and sp.property in (708086, 708178)
order by sp.part_no, sp.revision, sp.section_id, sp.sub_section_id, sp.property_group, sp.property
;
--                                                                                                                                  char_1
--EK_B600/65R38-153K	25	700583	701270	702476	708086	Bottom rollers (low pressure)											1,0			
--EK_B600/65R38-153K	25	700583	701270	702476	708178	Setting bead positioning ring											974,3			

--char-1 value is transformed to SPECDATA.value_s. This is OK.
*/

select s.part_no, s.revision, s.section_id, s.sub_section_id, s.property_group, s.property, s.prop_descr, s.value_s, s.value
, case WHEN REGEXP_LIKE (s.value_s, '^-?\d+,\d+$')  THEN REGEXP_REPLACE (s.value_s, ',', '.' ) ELSE 'OK' end  expresult 
from ( select sp.part_no, sp.revision, sp.section_id, sp.sub_section_id, sp.property_group, sp.property, p.description prop_descr, sp.value_s, sp.value
       from specdata sp
	   JOIN property p on p.property = sp.property
       WHERE  REGEXP_LIKE(sp.value_s, '^-?\d+,\d+$') 
       and sp.part_no='AF_R195/75R16C2AP2'
      )  s
order by s.part_no, s.revision, s.section_id, s.sub_section_id, s.property_group, s.property
;
/*
AF_R195/75R16C2AP2	8	701115	0	704036	706068	Apollo High Speed (extended version of ECE R30)	115,115	0
AF_R195/75R16C2AP2	7	701115	0	704036	706068	Apollo High Speed (extended version of ECE R30)	115,115	0
AF_R195/75R16C2AP2	6	701115	0	704036	706068	Apollo High Speed (extended version of ECE R30)	115,115	0
AF_R195/75R16C2AP2	5	701115	0	704036	706068	Apollo High Speed (extended version of ECE R30)	115,115	0
AF_R195/75R16C2AP2	4	701115	0	704036	706068	Apollo High Speed (extended version of ECE R30)	115,115	0
AF_R195/75R16C2AP2	8	701115	0	704036	707489	Apollo Bead comp, minimum at +0.38	3065,3085	0
AF_R195/75R16C2AP2	7	701115	0	704036	707489	Apollo Bead comp, minimum at +0.38	3065,3085	0
AF_R195/75R16C2AP2	6	701115	0	704036	707489	Apollo Bead comp, minimum at +0.38	3065,3085	0
AF_R195/75R16C2AP2	5	701115	0	704036	707489	Apollo Bead comp, minimum at +0.38	3065,3085	0
AF_R195/75R16C2AP2	4	701115	0	704036	707489	Apollo Bead comp, minimum at +0.38	3065,3085	0
AF_R195/75R16C2AP2	8	701115	0	704036	707488	Apollo Bead comp, minimum at -0.29	2020,2030	0
AF_R195/75R16C2AP2	7	701115	0	704036	707488	Apollo Bead comp, minimum at -0.29	2020,2030	0
AF_R195/75R16C2AP2	6	701115	0	704036	707488	Apollo Bead comp, minimum at -0.29	2020,2030	0
AF_R195/75R16C2AP2	5	701115	0	704036	707488	Apollo Bead comp, minimum at -0.29	2020,2030	0
AF_R195/75R16C2AP2	4	701115	0	704036	707488	Apollo Bead comp, minimum at -0.29	2020,2030	0
AF_R195/75R16C2AP2	7	701115	0	704036	705650	Tyre weight	12,83	0
AF_R195/75R16C2AP2	6	701115	0	704036	705650	Tyre weight	12,83	0
AF_R195/75R16C2AP2	5	701115	0	704036	705650	Tyre weight	12,83	0
AF_R195/75R16C2AP2	4	701115	0	704036	705650	Tyre weight	12,83	0
AF_R195/75R16C2AP2	7	701115	0	704037	708628	ECE Noise labeling	74,49	0
AF_R195/75R16C2AP2	6	701115	0	704037	708628	ECE Noise labeling	74,49	0
AF_R195/75R16C2AP2	5	701115	0	704037	708628	ECE Noise labeling	74,49	0
AF_R195/75R16C2AP2	4	701115	0	704037	708628	ECE Noise labeling	74,49	0
AF_R195/75R16C2AP2	7	701115	0	704037	708629	ECE Wet Grip labeling (trailer)	1,24	0
AF_R195/75R16C2AP2	6	701115	0	704037	708629	ECE Wet Grip labeling (trailer)	1,24	0
AF_R195/75R16C2AP2	5	701115	0	704037	708629	ECE Wet Grip labeling (trailer)	1,24	0
AF_R195/75R16C2AP2	4	701115	0	704037	708629	ECE Wet Grip labeling (trailer)	1,24	0
AF_R195/75R16C2AP2	4	701115	0	704036	708608	ECE Rolling resistance Labeling	8,29	0
AF_R195/75R16C2AP2	8	701115	0	704036	714343	Apollo Long term endurance C2 (Belt)	103,103	0
AF_R195/75R16C2AP2	7	701115	0	704036	714343	Apollo Long term endurance C2 (Belt)	103,103	0
AF_R195/75R16C2AP2	6	701115	0	704036	714343	Apollo Long term endurance C2 (Belt)	103,103	0
AF_R195/75R16C2AP2	5	701115	0	704036	714343	Apollo Long term endurance C2 (Belt)	103,103	0
AF_R195/75R16C2AP2	4	701115	0	704036	714343	Apollo Long term endurance C2 (Belt)	103,103	0
*/


select sp.part_no, sp.revision, sp.section_id, sp.sub_section_id, sp.property_group, sp.property, p.description, num_1, num_2, num_3, num_4, num_5, num_6, num_7, num_8, num_9, char_1, char_2, char_3, char_4, char_5
from specification_prop sp
JOIN property p on p.property = sp.property
WHERE sp.part_no='AF_R195/75R16C2AP2'
and   sp.section_id = 701115 and sp.sub_section_id =0 and sp.property_group in (704036, 704037) 
order by sp.part_no, sp.revision, sp.section_id, sp.sub_section_id, sp.property_group, sp.property
;
/*
part-no	revision	section	sub-section	property-group	property	description	num_1	num_2	num_3	num_4	num_5	num_6	num_7	num_8	num_9	char_1	char_2	char_3	char_4	char_5
AF_R195/75R16C2AP2	1	701115	0	704036	708608	ECE Rolling resistance Labeling	8.42									CHE-PV-R117-2020-836	8.42			
AF_R195/75R16C2AP2	1	701115	0	704037	708628	ECE Noise labeling										19.423.JRA 	73			
AF_R195/75R16C2AP2	1	701115	0	704037	713650	ECE Snowflake R117		110				107				21.153.LRM	1.02			
AF_R195/75R16C2AP2	1	701115	0	704037	713651	ECE Wet Grip labeling (vehicle)										19.423.JRA 	1.52			
AF_R195/75R16C2AP2	2	701115	0	704036	708608	ECE Rolling resistance Labeling	8.42									CHE-PV-R117-2020-836	8.42			
AF_R195/75R16C2AP2	2	701115	0	704037	708628	ECE Noise labeling										19.423.JRA 	73			
AF_R195/75R16C2AP2	2	701115	0	704037	713650	ECE Snowflake R117		110				107				21.153.LRM	1.02			
AF_R195/75R16C2AP2	2	701115	0	704037	713651	ECE Wet Grip labeling (vehicle)										19.423.JRA 	1.52			
AF_R195/75R16C2AP2	3	701115	0	704036	708608	ECE Rolling resistance Labeling	8.42										8.42			
AF_R195/75R16C2AP2	3	701115	0	704037	708628	ECE Noise labeling														
AF_R195/75R16C2AP2	3	701115	0	704037	713650	ECE Snowflake R117		110				107				21.153.LRM	1.02			
AF_R195/75R16C2AP2	3	701115	0	704037	713651	ECE Wet Grip labeling (vehicle)										19.423.JRA 	1.52			
AF_R195/75R16C2AP2	4	701115	0	704036	704650	FMVSS Tyre Strength		39670									78574			
AF_R195/75R16C2AP2	4	701115	0	704036	705649	Tyre diameter		690	706			698					700			
AF_R195/75R16C2AP2	4	701115	0	704036	705650	Tyre weight	12.87										12,83			
AF_R195/75R16C2AP2	4	701115	0	704036	705651	Tyre width (max)		188	204			196					194			
AF_R195/75R16C2AP2	4	701115	0	704036	706068	Apollo High Speed (extended version of ECE R30)	85	80				60					115,115			
AF_R195/75R16C2AP2	4	701115	0	704036	706075	FMVSS Bead Unseating		9780									16689			
AF_R195/75R16C2AP2	4	701115	0	704036	707488	Apollo Bead comp, minimum at -0.29		1800	4500								20,202,030			
AF_R195/75R16C2AP2	4	701115	0	704036	707489	Apollo Bead comp, minimum at +0.38		2300	5000								30,653,085			
AF_R195/75R16C2AP2	4	701115	0	704036	708608	ECE Rolling resistance Labeling	8.7					10				AP-PV-R117-2022-2337	8,29			
AF_R195/75R16C2AP2	4	701115	0	704036	713021	FMVSS High Speed	420	390				330					420			
AF_R195/75R16C2AP2	4	701115	0	704036	713022	FMVSS Endurance		34				34					43			
AF_R195/75R16C2AP2	4	701115	0	704036	713228	Apollo Electrical Resistance	100		10000								215,7,220,22			
AF_R195/75R16C2AP2	4	701115	0	704036	713756	Tread Wear Indicator (TWI)	1.6										1,69-1,72			
AF_R195/75R16C2AP2	4	701115	0	704036	714342	Apollo Long term endurance C2 (failures)			0			0					0			
AF_R195/75R16C2AP2	4	701115	0	704036	714343	Apollo Long term endurance C2 (Belt)		71									103,103			
AF_R195/75R16C2AP2	4	701115	0	704036	715328	Apollo pop-up pressure						250					74			
AF_R195/75R16C2AP2	4	701115	0	704037	708628	ECE Noise labeling			74.9		74.4					20.826.LRM	74,49			
AF_R195/75R16C2AP2	4	701115	0	704037	708629	ECE Wet Grip labeling (trailer)										19.423.JRA	1,24			
AF_R195/75R16C2AP2	4	701115	0	704037	713650	ECE Snowflake R117		110				105				21.153.LRM	105			
AF_R195/75R16C2AP2	4	701115	0	704037	713651	ECE Wet Grip labeling (vehicle)						0.95				19.423.JRA	2			
AF_R195/75R16C2AP2	5	701115	0	704036	704650	FMVSS Tyre Strength		39670									78,574			
AF_R195/75R16C2AP2	5	701115	0	704036	705649	Tyre diameter		690	706			698					700			
AF_R195/75R16C2AP2	5	701115	0	704036	705650	Tyre weight	12.87										12,83			
AF_R195/75R16C2AP2	5	701115	0	704036	705651	Tyre width (max)		188	204			196					194			
AF_R195/75R16C2AP2	5	701115	0	704036	706068	Apollo High Speed (extended version of ECE R30)	85	80				60					115,115			
AF_R195/75R16C2AP2	5	701115	0	704036	706075	FMVSS Bead Unseating		9780									16,689			
AF_R195/75R16C2AP2	5	701115	0	704036	707488	Apollo Bead comp, minimum at -0.29		1800	4500								20,202,030			
AF_R195/75R16C2AP2	5	701115	0	704036	707489	Apollo Bead comp, minimum at +0.38		2300	5000								30,653,085			
AF_R195/75R16C2AP2	5	701115	0	704036	708608	ECE Rolling resistance Labeling	8.7					10				AP-PV-R117-2022-2337	8.29			
AF_R195/75R16C2AP2	5	701115	0	704036	713021	FMVSS High Speed	420	390				330					420			
AF_R195/75R16C2AP2	5	701115	0	704036	713022	FMVSS Endurance		34				34					43			
AF_R195/75R16C2AP2	5	701115	0	704036	713228	Apollo Electrical Resistance	100		10000								215,7,220,22			
AF_R195/75R16C2AP2	5	701115	0	704036	713756	Tread Wear Indicator (TWI)	1.6										1,69-1,72			
AF_R195/75R16C2AP2	5	701115	0	704036	714342	Apollo Long term endurance C2 (failures)			0			0					0			
AF_R195/75R16C2AP2	5	701115	0	704036	714343	Apollo Long term endurance C2 (Belt)		71									103,103			
AF_R195/75R16C2AP2	5	701115	0	704036	715328	Apollo pop-up pressure						250					74			
AF_R195/75R16C2AP2	5	701115	0	704037	708628	ECE Noise labeling			74.9		74.4					20.826.LRM	74,49			
AF_R195/75R16C2AP2	5	701115	0	704037	708629	ECE Wet Grip labeling (trailer)										19.423.JRA	1,24			
AF_R195/75R16C2AP2	5	701115	0	704037	713650	ECE Snowflake R117		110				105				21.153.LRM	105			
AF_R195/75R16C2AP2	5	701115	0	704037	713651	ECE Wet Grip labeling (vehicle)						0.95				19.423.JRA	1.55			
AF_R195/75R16C2AP2	6	701115	0	704036	704650	FMVSS Tyre Strength		39670									78574			
AF_R195/75R16C2AP2	6	701115	0	704036	705649	Tyre diameter		690	706			698					700			
AF_R195/75R16C2AP2	6	701115	0	704036	705650	Tyre weight	12.87										12,83			
AF_R195/75R16C2AP2	6	701115	0	704036	705651	Tyre width (max)		188	204			196					194			
AF_R195/75R16C2AP2	6	701115	0	704036	706068	Apollo High Speed (extended version of ECE R30)	85	80				60					115,115			
AF_R195/75R16C2AP2	6	701115	0	704036	706075	FMVSS Bead Unseating		9780									16689			
AF_R195/75R16C2AP2	6	701115	0	704036	707488	Apollo Bead comp, minimum at -0.29		1800	4500								20,202,030			
AF_R195/75R16C2AP2	6	701115	0	704036	707489	Apollo Bead comp, minimum at +0.38		2300	5000								30,653,085			
AF_R195/75R16C2AP2	6	701115	0	704036	708608	ECE Rolling resistance Labeling	8.7					10				AP-PV-R117-2022-2337	8.29			
AF_R195/75R16C2AP2	6	701115	0	704036	713021	FMVSS High Speed	420	390				330					420			
AF_R195/75R16C2AP2	6	701115	0	704036	713022	FMVSS Endurance		34				34					43			
AF_R195/75R16C2AP2	6	701115	0	704036	713228	Apollo Electrical Resistance	100		10000								215,7,220,22			
AF_R195/75R16C2AP2	6	701115	0	704036	713756	Tread Wear Indicator (TWI)	1.6										1,69-1,72			
AF_R195/75R16C2AP2	6	701115	0	704036	714342	Apollo Long term endurance C2 (failures)			0			0					0			
AF_R195/75R16C2AP2	6	701115	0	704036	714343	Apollo Long term endurance C2 (Belt)		71									103,103			
AF_R195/75R16C2AP2	6	701115	0	704036	715328	Apollo pop-up pressure						250					74			
AF_R195/75R16C2AP2	6	701115	0	704037	708628	ECE Noise labeling			74.9		74.4					20.826.LRM	74,49			
AF_R195/75R16C2AP2	6	701115	0	704037	708629	ECE Wet Grip labeling (trailer)										19.423.JRA	1,24			
AF_R195/75R16C2AP2	6	701115	0	704037	713650	ECE Snowflake R117		110				105				21.153.LRM	105			
AF_R195/75R16C2AP2	6	701115	0	704037	713651	ECE Wet Grip labeling (vehicle)						0.95				19.423.JRA	1.55			
AF_R195/75R16C2AP2	7	701115	0	704036	704650	FMVSS Tyre Strength		39670									78574			
AF_R195/75R16C2AP2	7	701115	0	704036	705649	Tyre diameter		690	706			698					700			
AF_R195/75R16C2AP2	7	701115	0	704036	705650	Tyre weight	12.87										12,83			
AF_R195/75R16C2AP2	7	701115	0	704036	705651	Tyre width (max)		188	204			196					194			
AF_R195/75R16C2AP2	7	701115	0	704036	706068	Apollo High Speed (extended version of ECE R30)	85	80				60					115,115			
AF_R195/75R16C2AP2	7	701115	0	704036	706075	FMVSS Bead Unseating		9780									16,689			
AF_R195/75R16C2AP2	7	701115	0	704036	707488	Apollo Bead comp, minimum at -0.29		1800	4500								20,202,030			
AF_R195/75R16C2AP2	7	701115	0	704036	707489	Apollo Bead comp, minimum at +0.38		2300	5000								30,653,085			
AF_R195/75R16C2AP2	7	701115	0	704036	708608	ECE Rolling resistance Labeling	8.7					10				AP-PV-R117-2022-2337	8.29			
AF_R195/75R16C2AP2	7	701115	0	704036	713021	FMVSS High Speed	420	390				330					420			
AF_R195/75R16C2AP2	7	701115	0	704036	713022	FMVSS Endurance		34				34					43			
AF_R195/75R16C2AP2	7	701115	0	704036	713228	Apollo Electrical Resistance	100		10000								215,7,220,22			
AF_R195/75R16C2AP2	7	701115	0	704036	713756	Tread Wear Indicator (TWI)	1.6										1,69-1,72			
AF_R195/75R16C2AP2	7	701115	0	704036	714342	Apollo Long term endurance C2 (failures)			0			0					0			
AF_R195/75R16C2AP2	7	701115	0	704036	714343	Apollo Long term endurance C2 (Belt)		71									103,103			
AF_R195/75R16C2AP2	7	701115	0	704036	715328	Apollo pop-up pressure						250					74			
AF_R195/75R16C2AP2	7	701115	0	704037	708628	ECE Noise labeling			74.9		74.4					20.826.LRM	74,49			
AF_R195/75R16C2AP2	7	701115	0	704037	708629	ECE Wet Grip labeling (trailer)										19.423.JRA	1,24			
AF_R195/75R16C2AP2	7	701115	0	704037	713650	ECE Snowflake R117		110				105				21.153.LRM	105			
AF_R195/75R16C2AP2	7	701115	0	704037	713651	ECE Wet Grip labeling (vehicle)						0.95				19.423.JRA	1.55			
AF_R195/75R16C2AP2	8	701115	0	704036	704650	FMVSS Tyre Strength		39670									78574			
AF_R195/75R16C2AP2	8	701115	0	704036	705649	Tyre diameter		690	706			698					700			
AF_R195/75R16C2AP2	8	701115	0	704036	705650	Tyre weight	12.87										12.83			
AF_R195/75R16C2AP2	8	701115	0	704036	705651	Tyre width (max)		188	204			196					194			
AF_R195/75R16C2AP2	8	701115	0	704036	706068	Apollo High Speed (extended version of ECE R30)	85	80				60					115,115			
AF_R195/75R16C2AP2	8	701115	0	704036	706075	FMVSS Bead Unseating		9780									16689			
AF_R195/75R16C2AP2	8	701115	0	704036	707488	Apollo Bead comp, minimum at -0.29		1800	4500								20,202,030			
AF_R195/75R16C2AP2	8	701115	0	704036	707489	Apollo Bead comp, minimum at +0.38		2300	5000								30,653,085			
AF_R195/75R16C2AP2	8	701115	0	704036	708608	ECE Rolling resistance Labeling	8.7					10				AP-PV-R117-2022-2337	8.29			
AF_R195/75R16C2AP2	8	701115	0	704036	713021	FMVSS High Speed	420	390				330					420			
AF_R195/75R16C2AP2	8	701115	0	704036	713022	FMVSS Endurance		34				34					43			
AF_R195/75R16C2AP2	8	701115	0	704036	713228	Apollo Electrical Resistance	100		10000								215.7,220.22			
AF_R195/75R16C2AP2	8	701115	0	704036	713756	Tread Wear Indicator (TWI)	1.6										1.69-1.72			
AF_R195/75R16C2AP2	8	701115	0	704036	714342	Apollo Long term endurance C2 (failures)			0			0					0			
AF_R195/75R16C2AP2	8	701115	0	704036	714343	Apollo Long term endurance C2 (Belt)		71									103,103			
AF_R195/75R16C2AP2	8	701115	0	704036	715328	Apollo pop-up pressure						250					74			
AF_R195/75R16C2AP2	8	701115	0	704037	708628	ECE Noise labeling			74.9		74.4					20.826.LRM	74.49			
AF_R195/75R16C2AP2	8	701115	0	704037	708629	ECE Wet Grip labeling (trailer)										19.423.JRA	1.24			
AF_R195/75R16C2AP2	8	701115	0	704037	713650	ECE Snowflake R117		1.1				1.05				21.153.LRM	1.05			
AF_R195/75R16C2AP2	8	701115	0	704037	713651	ECE Wet Grip labeling (vehicle)						0.95				19.423.JRA	1.55			
*/

--																												NUM_1 	NUM_2	NUM_3	NUM_4 	NUM_5	NUM_6	CHAR_1	CHAR_2	
--SPEC-PROP: AF_R195/75R16C2AP2	5	701115	0	704036	705651	Tyre width (max)										188		204						196				194												

select sp.part_no, sp.revision, sp.section_id, sp.sub_section_id, sp.property_group, sp.property, p.description, value_s, value
from specdata sp
JOIN property p on p.property = sp.property
WHERE sp.part_no='AF_R195/75R16C2AP2' and sp.revision=5
and   sp.section_id = 701115 and sp.sub_section_id =0 and sp.property_group in (704036, 704037)  and sp.property=705651
order by sp.part_no, sp.revision, sp.section_id, sp.sub_section_id, sp.property_group, sp.property
;
/*
AF_R195/75R16C2AP2	5	701115	0	704036	705651	Tyre width (max)	188	188
AF_R195/75R16C2AP2	5	701115	0	704036	705651	Tyre width (max)		
AF_R195/75R16C2AP2	5	701115	0	704036	705651	Tyre width (max)		
AF_R195/75R16C2AP2	5	701115	0	704036	705651	Tyre width (max)		
AF_R195/75R16C2AP2	5	701115	0	704036	705651	Tyre width (max)	194	0
AF_R195/75R16C2AP2	5	701115	0	704036	705651	Tyre width (max)		
AF_R195/75R16C2AP2	5	701115	0	704036	705651	Tyre width (max)	196	196
AF_R195/75R16C2AP2	5	701115	0	704036	705651	Tyre width (max)		0
AF_R195/75R16C2AP2	5	701115	0	704036	705651	Tyre width (max)	204	204
*/

--																												NUM_1 	NUM_2	NUM_3	NUM_4 	NUM_5	NUM_6	CHAR_1	CHAR_2	
--SPEC-PROP: AF_R195/75R16C2AP2	5	701115	0	704036	706068	Apollo High Speed (extended version of ECE R30)	85		80								60				115,115												

select sp.part_no, sp.revision, sp.section_id, sp.sub_section_id, sp.property_group, sp.property, p.description, value_s, value
from specdata sp
JOIN property p on p.property = sp.property
WHERE sp.part_no='AF_R195/75R16C2AP2' and sp.revision=5
and   sp.section_id = 701115 and sp.sub_section_id =0 and sp.property_group in (704036, 704037)  and sp.property=706068
order by sp.part_no, sp.revision, sp.section_id, sp.sub_section_id, sp.property_group, sp.property
;
/*
AF_R195/75R16C2AP2	5	701115	0	704036	706068	Apollo High Speed (extended version of ECE R30)	80		80
AF_R195/75R16C2AP2	5	701115	0	704036	706068	Apollo High Speed (extended version of ECE R30)		
AF_R195/75R16C2AP2	5	701115	0	704036	706068	Apollo High Speed (extended version of ECE R30)	85		85
AF_R195/75R16C2AP2	5	701115	0	704036	706068	Apollo High Speed (extended version of ECE R30)		
AF_R195/75R16C2AP2	5	701115	0	704036	706068	Apollo High Speed (extended version of ECE R30)	115,115	0
AF_R195/75R16C2AP2	5	701115	0	704036	706068	Apollo High Speed (extended version of ECE R30)		
AF_R195/75R16C2AP2	5	701115	0	704036	706068	Apollo High Speed (extended version of ECE R30)	60		60
AF_R195/75R16C2AP2	5	701115	0	704036	706068	Apollo High Speed (extended version of ECE R30)			0
AF_R195/75R16C2AP2	5	701115	0	704036	706068	Apollo High Speed (extended version of ECE R30)		
*/


select sp.part_no, sp.revision, sp.section_id, sp.sub_section_id, sp.property_group, sp.property, p.description, num_1, num_2, num_3, num_4, num_5, num_6, num_7, num_8, num_9, char_1, char_2, char_3, char_4, char_5
from specification_prop sp
JOIN property p on p.property = sp.property
WHERE sp.part_no='XM_B08-110A'
and   sp.section_id = 700584 and sp.sub_section_id =0 and sp.property_group in (701300, 701299) 
order by sp.part_no, sp.revision, sp.section_id, sp.sub_section_id, sp.property_group, sp.property
;
XM_B08-110A	1	700584	0	701299	703588	MH 160°C	15.13			16.93	13.33									
XM_B08-110A	1	700584	0	701299	703589	ML 160°C	1.51			1.72	1.3									
XM_B08-110A	1	700584	0	701299	703590	RH 160°C	12.28			14.25	10.31									
XM_B08-110A	1	700584	0	701299	703593	t95 160°C	6.62			8.88	4.36									
XM_B08-110A	1	700584	0	701299	703595	ts1 160°C	1.91			2.6	1.21									
XM_B08-110A	1	700584	0	701300	703172	ML 190°C	1.43	0.98	1.88	1.77	1.09									
XM_B08-110A	1	700584	0	701300	703173	RH 190°C	6.51	4.83	8.19	7.77	5.25									
XM_B08-110A	1	700584	0	701300	703174	MH 190°C	14.61	11.01	18.21	17.31	11.91									
XM_B08-110A	1	700584	0	701300	703216	t90%  190°C	0.949	0.709	1.189	1.129	0.769									
XM_B08-110A	1	700584	0	701300	703218	ts1 190°C	0.46	0.37	0.55	0.52	0.4									
XM_B08-110A	1	700584	0	701300	705364	S''H 190°C	16.66	2.78	30.54	27.07	6.25									

--koe komen deze in SPECDATA voor?
XM_B08-110A	1	700584	0	701299	703589	1.3		1.3
XM_B08-110A	1	700584	0	701299	703589	1.51	1.51
XM_B08-110A	1	700584	0	701299	703589	1.72	1.72
XM_B08-110A	1	700584	0	701299	703588	13.33	13.33
XM_B08-110A	1	700584	0	701299	703588	15.13	15.13
XM_B08-110A	1	700584	0	701299	703588	16.93	16.93
XM_B08-110A	1	700584	0	701300	705364	2.78	2.78
XM_B08-110A	1	700584	0	701300	705364	6.25	6.25
XM_B08-110A	1	700584	0	701300	705364	16.66	16.66
XM_B08-110A	1	700584	0	701300	705364	27.07	27.07
XM_B08-110A	1	700584	0	701300	705364	30.54	30.54
XM_B08-110A	1	700584	0	701297	703241	15.1	15.1
XM_B08-110A	1	700584	0	701297	703241	16.7	16.7
XM_B08-110A	1	700584	0	701297	703241	18.2	18.2
XM_B08-110A	1	700584	0	701297	703230	7.29	7.29
XM_B08-110A	1	700584	0	701297	703230	8.87	8.87
XM_B08-110A	1	700584	0	701297	703230	10.45	10.45
XM_B08-110A	1	700584	0	701297	703200	439.9	439.9
XM_B08-110A	1	700584	0	701297	703200	534.1	534.1
XM_B08-110A	1	700584	0	701297	703200	628.3	628.3
XM_B08-110A	1	700584	0	701297	705375	10.3	10.3
XM_B08-110A	1	700584	0	701297	705375	15.7	15.7
XM_B08-110A	1	700584	0	701297	705370	65.3	65.3
XM_B08-110A	1	700584	0	701297	705370	68.6	68.6
XM_B08-110A	1	700584	0	701297	703197	86.7	86.7
XM_B08-110A	1	700584	0	701297	703197	91.4	91.4

--CONCLUSIE: IEDERE NUM/CHAR-WAARDE WORDT APARTE REGEL IN SPECDATA, WAARBIJ dan VALUE_S + VALUE gevuld worden...




--***************************************************************
--***************************************************************
-- HERSTELLEN van VALUE_S met numerieke-waardes en komma als decimaal-scheider...
--***************************************************************
--***************************************************************
--PARAMETER:
update SPECDATA s
set s.value_s = case WHEN REGEXP_LIKE (s.value_s, '^-?\d+,\d+$')  
                      THEN REGEXP_REPLACE (s.value_s, ',', '.' ) 
					  ELSE s.value_s 
			     end 
WHERE  REGEXP_LIKE(s.value_s, '^-?\d+,\d+$') 
;















--einde script...


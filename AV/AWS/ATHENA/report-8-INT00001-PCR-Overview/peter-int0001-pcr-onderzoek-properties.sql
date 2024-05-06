--INT00001R-PCR-overview

--FRAME_ID IN ('A_PCR','A_PRC_v1')

--PART-NO = 'EF_H165/80R14CLS'

select * from property p where p.description like 'Building%'
select * from property p where p.description like 'Speed%'
select * from property p where p.description like 'Section%'
select * from property p where p.description like 'Aspect%'
select * from property p where p.description like 'Rim%'
select * from property p where p.description like 'Product%'    --code + line
select * from property p where p.description like 'Load%'       --index + class
select * from property p where p.description like 'Categor%'


--onderzoek properties:
703411	Building method
703425	Speed index
703424	Section width
703417	Aspect ratio
703423	Rimcode
706448	Productlinecode
703422	Productline
703421	Load index
703544	Load index class
703418	Category


select d.part_no 
,      d.section_id
,      s.description
,      d.sub_section_id
,      d.property_group
,      d.property
,      p.description
,      d.value_s
from specdata d
JOIN section  s on s.section_id = d.section_id
JOIN property p on p.property = d.property
where d.part_no='EF_H165/80R14CLS'
and  d.revision = (select max(sh.revision) from specification_header sh where sh.part_no = d.part_no)
--and d.property in (703411)
and (   d.section_id = 700579
    and d.property in (703411, 703425, 703424, 703417, 703423, 706448, 703422, 703421, 703544, 703418)
	)
;

select * from property p where p.description like 'Bead%dist%'
select * from property p where p.description like 'Stret%dist%'
select * from property p where p.description like 'Innerliner%'    --width + gauge


705286	Bead distance
707135	Stretching distance


--BOM-STRUCTUUR UIT WEIGHT-TABEL:
--'EF_H165/80R14CLS'
SELECT * FROM DBA_VW_CRRNT_MAINPART_PARTS WHERE MAINPART='EF_H165/80R14CLS';
/*
--
TYRE		7689488	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	H165/80R14CLS	EF_H165/80R14CLS		20	1	7.6193386203	28-08-2023 15:27:58	CRRNT QR4
--
COMPONENT	7439508	EF_H165/80R14CLS	20	09-11-2023 01:07:01	E1	DE04-00-230		ER_DE04-00-230		NYLON OVERHEAD (tbv mini-slitter-> 0012)	1	1	0.1904398871	24-06-0019 00:00:00	CRRNT QR5
COMPONENT	7648331	EF_H165/80R14CLS	20	08-12-2023 01:06:47	E1	568				EM_568				RM Body Ply compound			5	1	0.9999993627	13-06-0021 00:00:00	CRRNT QR4
COMPONENT	7689489	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	BH165/80R14CLS	EV_BH165/80R14CLS	165 HR 14  84H SPRINT CLASSIC	5	1	7.6093386203	30-11-0023 00:00:00	CRRNT QR4
COMPONENT	7689490	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	BH168014CLS-G	EG_BH168014CLS-G	GREENTYRE  SPRINT CLASSIC		6	1	7.6093386203	24-10-0023 00:00:00	CRRNT QR4
COMPONENT	7689491	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	11205AR56S		EB_11205AR56S		14" HIEL  L=5 DR=6 HVS-AR (hoog:50 basis:7.2).	3	1	0.460413913	18-04-0023 00:00:00	CRRNT QR3
COMPONENT	7689492	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	700				EM_700				FM Bead 						82	1	0.9999989227	29-03-0023 00:00:00	CRRNT QR5
COMPONENT	7689493	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	400				EM_400				MB Bead 						27	1	1.0000005738	21-03-0023 00:00:00	CRRNT QR5
COMPONENT	7689494	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	747				EM_747				FM Apex PCR						37	1	0.9999997889	23-08-0023 00:00:00	CRRNT QR4
COMPONENT	7689495	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	447				EM_447				MB Apex							16	1	1.0000007065	16-06-0022 00:00:00	CRRNT QR4
COMPONENT	7689496	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	PA17ZF365-686	EP_PA17ZF365-686	PRE-ASS.  ZIJKANT-17Z B170 VOERING-F365 B=686	3	1	1.9100691843	11-12-0023 00:00:00	CRRNT QR5
COMPONENT	7689497	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	F365			EI_F365				VOERING 732  1.50X365			5	1	0.672999351	20-02-0014 00:00:00	CRRNT QR5
COMPONENT	7689498	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	732				EM_732				FM innerliner PCR				89	1	0.9999990357	21-12-0023 00:00:00	CRRNT QR5
COMPONENT	7689499	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	432				EM_432				MB innerliner PCR				44	1	0.9999995146	01-09-0022 00:00:00	CRRNT QR5
COMPONENT	7689500	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	L17Z			ES_L17Z				ZIJKANT LINKS   B=170			8	1	0.6185349166	19-12-0022 00:00:00	CRRNT QR3
COMPONENT	7689501	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	721				EM_721				Yearly Compensated - FM LRR Sidewall PCR	101	1	1.000001656	08-11-0023 00:00:00	CRRNT QR5
COMPONENT	7689502	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	521				EM_521				Yearly Compensated - Remill LRR Sidewall PCR	18	1	1.0000009312	23-11-0023 00:00:00	CRRNT QR5
COMPONENT	7689503	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	421				EM_421				Yearly Compensated - MB LRR Sidewall PCR	40	1	1.0000004656	08-11-0023 00:00:00	CRRNT QR5
COMPONENT	7689504	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	741				EM_741				FM LRR Rim cushion				45	1	1.00000095	21-12-0023 00:00:00	CRRNT QR5
COMPONENT	7689505	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	541				EM_541				Remill LRR Rim cushion			9	1	1.0000012575	23-05-0022 00:00:00	CRRNT QR4
COMPONENT	7689506	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	441				EM_441				MB LRR Rim cushion				14	1	1.0000006288	23-05-0022 00:00:00	CRRNT QR4
COMPONENT	7689507	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	R17Z			ES_R17Z				ZIJKANT RECHTS  B=170			8	1	0.6185349166	19-12-0022 00:00:00	CRRNT QR3
COMPONENT	7689508	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	721				EM_721				Yearly Compensated - FM LRR Sidewall PCR	101	1	1.000001656	08-11-0023 00:00:00	CRRNT QR5
COMPONENT	7689509	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	521				EM_521				Yearly Compensated - Remill LRR Sidewall PCR	18	1	1.0000009312	23-11-0023 00:00:00	CRRNT QR5
COMPONENT	7689510	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	421				EM_421				Yearly Compensated - MB LRR Sidewall PCR	40	1	1.0000004656	08-11-0023 00:00:00	CRRNT QR5
COMPONENT	7689511	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	741				EM_741				FM LRR Rim cushion				45	1	1.00000095	21-12-0023 00:00:00	CRRNT QR5
COMPONENT	7689512	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	541				EM_541				Remill LRR Rim cushion			9	1	1.0000012575	23-05-0022 00:00:00	CRRNT QR4
COMPONENT	7689513	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	441				EM_441				MB LRR Rim cushion				14	1	1.0000006288	23-05-0022 00:00:00	CRRNT QR4
COMPONENT	7689514	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	DE04-00-0012	ER_DE04-00-0012		CAPSTRIP 12 mm					16	1	0.0092570345	10-11-0023 00:00:00	CRRNT QR3
COMPONENT	7689515	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	DE04-00-215		ER_DE04-00-215		NYLON OVERHEAD (tbv mini-slitter-> 0012)	1	1	0.1780198945	10-11-0023 00:00:00	CRRNT QR3
COMPONENT	7689516	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	DE04			EC_DE04				REKNUMMER DE04					13	1	0.8279995091	13-09-0023 00:00:00	CRRNT QR5
COMPONENT	7689517	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	764				EM_764				FM Capply PCR					85	1	0.9999992133	21-12-0023 00:00:00	CRRNT QR5
COMPONENT	7689518	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	464				EM_464				MB Capply PCR					30	1	0.9999998238	25-04-0023 00:00:00	CRRNT QR5
COMPONENT	7689519	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	KE21-25-120		ER_KE21-25-120		GORDELMATERIAAL WIT				8	1	0.2737201523	19-09-0018 00:00:00	CRRNT QR5
COMPONENT	7689520	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	KE21			EC_KE21				STAALKOORD KE21 WIT				16	1	2.2810012691	25-01-0018 00:00:00	CRRNT QR5
COMPONENT	7689521	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	753				EM_753				FM Steel Belt H/V				71	1	1.0000010428	17-10-0023 00:00:00	CRRNT QR5
COMPONENT	7689522	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	653				EM_653				Remill Steel Belt H/V			16	1	1.0000009664	03-10-0023 00:00:00	CRRNT QR5
COMPONENT	7689523	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	453				EM_453				MB Steel Belt H/V				24	1	1.000000526	02-03-0020 00:00:00	CRRNT QR5
COMPONENT	7689524	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	KE21-25-130STR	ER_KE21-25-130STR	GORDELMATERIAAL WIT + stroken 755 0.75x20 (2x)	1	1	0.3423075918	07-12-0020 00:00:00	CRRNT QR3
COMPONENT	7689525	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	KE21			EC_KE21				STAALKOORD KE21 WIT				16	1	2.2810012691	25-01-0018 00:00:00	CRRNT QR5
COMPONENT	7689526	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	753				EM_753				FM Steel Belt H/V				71	1	1.0000010428	17-10-0023 00:00:00	CRRNT QR5
COMPONENT	7689527	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	653				EM_653				Remill Steel Belt H/V			16	1	1.0000009664	03-10-0023 00:00:00	CRRNT QR5
COMPONENT	7689528	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	453				EM_453				MB Steel Belt H/V				24	1	1.000000526	02-03-0020 00:00:00	CRRNT QR5
COMPONENT	7689529	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	Y40				EX_Y40				GORDELRANDSTROOK  755 0.75X40  (STRAM)	6	1	0.0457774268	31-08-0020 00:00:00	CRRNT QR4
COMPONENT	7689530	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	Y798			EX_Y798				Belt U-wrap  matrial 755 0.75X798 (U-wrap).	5	1	0.8233350152	23-08-0021 00:00:00	CRRNT QR4
COMPONENT	7689531	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	755				EM_755				FM Steel Belt W/Y, LT			69	1	1.0000000206	17-11-0023 00:00:00	CRRNT QR5
COMPONENT	7689532	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	655				EM_655				Remill Steel Belt W/Y, LT		22	1	1.0000008657	03-10-0023 00:00:00	CRRNT QR5
COMPONENT	7689533	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	555				EM_555				Remill Steel Belt W/Y, LT		19	1	1.0000008756	03-10-0023 00:00:00	CRRNT QR5
COMPONENT	7689534	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	455				EM_455				MB Steel Belt W/Y / LT			17	1	1.0000001805	14-05-0019 00:00:00	CRRNT QR5
COMPONENT	7689535	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	ME01-90-0540	ER_ME01-90-0540		PLY GR/GE						5	1	0.8640004058	05-09-0013 00:00:00	CRRNT QR5
COMPONENT	7689536	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	ME01			EC_ME01				REKNUMMER ME01 GROEN/GEEL		17	1	1.6000007514	11-01-0024 00:00:00	CRRNT QR3
COMPONENT	7689537	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	768				EM_768				FM Body Ply compound			25	1	1.0000007253	13-01-0024 00:00:00	CRRNT QR4
COMPONENT	7689538	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	468				EM_468				MB Body Ply compound			23	1	1.0000000917	12-01-0024 00:00:00	CRRNT QR4
COMPONENT	7689539	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	LV172			ET_LV172			LOOPVLAK SPRINT CLASSIC B166 SB124	36	1	1.3170665181	30-11-0023 00:00:00	CRRNT QR3
COMPONENT	7689540	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	722				EM_722				Base							70	2	0.9999993931	09-01-0024 00:00:00	CRRNT QR4
COMPONENT	7689541	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	522				EM_522				Base							19	1	0.9999994662	14-06-0021 00:00:00	CRRNT QR4
COMPONENT	7689542	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	422				EM_422				Base							28	1	0.9999995553	25-04-0023 00:00:00	CRRNT QR5
COMPONENT	7689543	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	722				EM_722				Base							70	2	0.9999993931	09-01-0024 00:00:00	CRRNT QR4
COMPONENT	7689544	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	522				EM_522				Base							19	1	0.9999994662	14-06-0021 00:00:00	CRRNT QR4
COMPONENT	7689545	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	422				EM_422				Base							28	1	0.9999995553	25-04-0023 00:00:00	CRRNT QR5
COMPONENT	7689546	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	726				EM_726				FM Wingtip PCR					86	2	0.9999993108	17-10-0023 00:00:00	CRRNT QR5
COMPONENT	7689547	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	526				EM_526				Remill Wingtip PCR				13	1	0.9999985772	06-12-0021 00:00:00	CRRNT QR5
COMPONENT	7689548	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	426				EM_426				MB Wingtip PCR					30	1	0.9999991996	08-02-0022 00:00:00	CRRNT QR5
COMPONENT	7689549	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	775				EM_775				FM Tread Summer V/W				52	2	1.0000011663	07-12-0023 00:00:00	CRRNT QR5
COMPONENT	7689550	EF_H165/80R14CLS	20	13-01-2024 01:07:32	E1	475				EM_475				MB Tread Summer V/W				36	1	1.0000002516	13-04-0023 00:00:00	CRRNT QR5
*/




--*******************************
--bom FUNCTIE-CODE VULCANIZED-TYRE
 SELECT bi.part_no                                            AS parent_part_no
 ,      bi.revision                                           AS parent_rev
 ,      sh.status                                             AS parent_status
 ,      s.status_type                                         AS parent_status_type
 ,      coalesce(sh.issued_date, sh.planned_effective_date)   AS parent_issued_date
 ,      sh.obsolescence_date
 ,      bh.preferred
 ,      bh.alternative
 ,	    bh.base_quantity        AS parent_quantity
 ,	    sh2.part_no             AS component_part_no
 ,      p.description           AS component_part_no_descr
 ,      bi.ch_1                 AS characteristic_id
 ,      ch.description          AS FUNCTION
 ,      sh2.revision            as component_revision
 ,      bi.plant
 ,      bi.item_number
 ,      bi.quantity
 ,      bi.uom
 FROM specification_header  SH  
 JOIN status                 S ON (S.status    = SH.status and S.status_type IN ('HISTORIC', 'CURRENT') )
 JOIN class3                 C ON (C.class     = SH.class3_id)
 JOIN bom_header            BH ON ( Bh.part_no = SH.part_no AND BH.revision = SH.revision )
 JOIN bom_item              bi ON ( bi.part_no = bh.part_no AND bi.revision = bh.revision AND bi.plant =  bh.plant AND bi.alternative = bh.alternative )                    --BOM-ITEMS RELATED TO SELECTED-PART-NO
 JOIN specification_header SH2 ON ( sh2.part_no = bi.component_part )
 JOIN part                   p on ( sh2.part_no = p.part_no )
 JOIN status                s2 ON ( s2.status  = sh2.status AND s2.status_type IN ('HISTORIC', 'CURRENT') )
 LEFT OUTER JOIN characteristic             ch ON ( ch.characteristic_id = bi.ch_1) 
 LEFT JOIN characteristic_association ca ON ( ca.characteristic    = ch.characteristic_id AND ca.intl = ch.intl )
 LEFT JOIN association                 a ON (  a.association       = ca.association       AND a.intl  = ca.intl  )
 WHERE SH.revision = ( SELECT MAX(sh3.revision)
                      FROM specification_header  sh3
                      JOIN status                 s3 on (s3.status = sh3.status)
                      WHERE sh3.part_no   = SH.part_no
                      AND   s3.status_type IN ('HISTORIC', 'CURRENT')
                      )
 AND   SH2.revision = (select max(sh4.revision) 
                       from specification_header sh4 
					   JOIN status               s4 on s4.status = sh4.status 
					   WHERE sh4.part_no = sh2.part_no 
					   and   s4.status_type IN ('HISTORIC', 'CURRENT') 
					  )
 AND a.description = 'Function'	
 AND sh.part_no = 'EF_H165/80R14CLS'
 --ORDER by sh.part_no, bi.item_number 
;
--PART-NO                                                               COMPONENT_PART                                          CH1     FUNCTION-CODE
--EF_H165/80R14CLS	20	127	CURRENT	28-08-2023 15:27:58		1	1	1	EV_BH165/80R14CLS	   165 HR 14  84H SPRINT CLASSIC	903334	Vulcanized tyre		5	ENS	10	1	pcs

--*************************************
--bom FUNCTIONCODE STRUCTURE GREEN-TRYPE
 SELECT bi.part_no                                            AS parent_part_no
 ,      bi.revision                                           AS parent_rev
 ,      sh.status                                             AS parent_status
 ,      s.status_type                                         AS parent_status_type
 ,      coalesce(sh.issued_date, sh.planned_effective_date)   AS parent_issued_date
 ,      sh.obsolescence_date
 ,      bh.preferred
 ,      bh.alternative
 ,	    bh.base_quantity        AS parent_quantity
 ,	    sh2.part_no             AS component_part_no
 ,      p.description           AS component_part_no_descr
 ,      bi.ch_1                 AS characteristic_id
 ,      ch.description          AS FUNCTION
 ,      sh2.revision            as component_revision
 ,      bi.plant
 ,      bi.item_number
 ,      bi.quantity
 ,      bi.uom
 FROM specification_header  SH  
 JOIN status                 S ON (S.status    = SH.status and S.status_type IN ('HISTORIC', 'CURRENT') )
 JOIN class3                 C ON (C.class     = SH.class3_id)
 JOIN bom_header            BH ON ( Bh.part_no = SH.part_no AND BH.revision = SH.revision )
 JOIN bom_item              bi ON ( bi.part_no = bh.part_no AND bi.revision = bh.revision AND bi.plant =  bh.plant AND bi.alternative = bh.alternative )                    --BOM-ITEMS RELATED TO SELECTED-PART-NO
 JOIN specification_header SH2 ON ( sh2.part_no = bi.component_part )
 JOIN part                   p on ( sh2.part_no = p.part_no )
 JOIN status                s2 ON ( s2.status  = sh2.status AND s2.status_type IN ('HISTORIC', 'CURRENT') )
 LEFT OUTER JOIN characteristic             ch ON ( ch.characteristic_id = bi.ch_1) 
 LEFT JOIN characteristic_association ca ON ( ca.characteristic    = ch.characteristic_id AND ca.intl = ch.intl )
 LEFT JOIN association                 a ON (  a.association       = ca.association       AND a.intl  = ca.intl  )
 WHERE SH.revision = ( SELECT MAX(sh3.revision)
                      FROM specification_header  sh3
                      JOIN status                 s3 on (s3.status = sh3.status)
                      WHERE sh3.part_no   = SH.part_no
                      AND   s3.status_type IN ('HISTORIC', 'CURRENT')
                      )
 AND   SH2.revision = (select max(sh4.revision) 
                       from specification_header sh4 
					   JOIN status               s4 on s4.status = sh4.status 
					   WHERE sh4.part_no = sh2.part_no 
					   and   s4.status_type IN ('HISTORIC', 'CURRENT') 
					  )
 AND a.description = 'Function'	
 AND sh.part_no = 'EV_BH165/80R14CLS'  --'EF_H165/80R14CLS'
 --ORDER by sh.part_no, bi.item_number 
;
--PART-NO                                                               COMPONENT_PART                                  CH1     FUNCTION-CODE
--EV_BH165/80R14CLS	5	127	CURRENT	30-11-2023 13:06:00		1	1	1	EG_BH168014CLS-G	GREENTYRE  SPRINT CLASSIC	903332	Greentyre		6	ENS	10	1	pcs


--******************************************************************************
--******************************************************************************
--UITVRAGEN BOM-COMPONENTS FUNCTIONCODE STRUCTURE ONDER GREENTYRE-COMPONENTS
--******************************************************************************
--******************************************************************************
 SELECT bi.part_no                                            AS parent_part_no
 ,      bi.revision                                           AS parent_rev
 ,      sh.status                                             AS parent_status
 ,      s.status_type                                         AS parent_status_type
 ,      coalesce(sh.issued_date, sh.planned_effective_date)   AS parent_issued_date
 ,      sh.obsolescence_date
 ,      bh.preferred
 ,      bh.alternative
 ,	    bh.base_quantity        AS parent_quantity
 ,	    sh2.part_no             AS component_part_no
 ,      p.description           AS component_part_no_descr
 ,      bi.ch_1                 AS characteristic_id
 ,      ch.description          AS FUNCTION
 ,      sh2.revision            as component_revision
 ,      bi.plant
 ,      bi.item_number
 ,      bi.quantity
 ,      bi.uom
 FROM specification_header  SH  
 JOIN status                 S ON (S.status    = SH.status and S.status_type IN ('HISTORIC', 'CURRENT') )
 JOIN class3                 C ON (C.class     = SH.class3_id)
 JOIN bom_header            BH ON ( Bh.part_no = SH.part_no AND BH.revision = SH.revision )
 JOIN bom_item              bi ON ( bi.part_no = bh.part_no AND bi.revision = bh.revision AND bi.plant =  bh.plant AND bi.alternative = bh.alternative )                    --BOM-ITEMS RELATED TO SELECTED-PART-NO
 JOIN specification_header SH2 ON ( sh2.part_no = bi.component_part )
 JOIN part                   p on ( sh2.part_no = p.part_no )
 JOIN status                s2 ON ( s2.status  = sh2.status AND s2.status_type IN ('HISTORIC', 'CURRENT') )
 LEFT OUTER JOIN characteristic             ch ON ( ch.characteristic_id = bi.ch_1) 
 LEFT JOIN characteristic_association ca ON ( ca.characteristic    = ch.characteristic_id AND ca.intl = ch.intl )
 LEFT JOIN association                 a ON (  a.association       = ca.association       AND a.intl  = ca.intl  )
 WHERE SH.revision = ( SELECT MAX(sh3.revision)
                      FROM specification_header  sh3
                      JOIN status                 s3 on (s3.status = sh3.status)
                      WHERE sh3.part_no   = SH.part_no
                      AND   s3.status_type IN ('HISTORIC', 'CURRENT')
                      )
 AND   SH2.revision = (select max(sh4.revision) 
                       from specification_header sh4 
					   JOIN status               s4 on s4.status = sh4.status 
					   WHERE sh4.part_no = sh2.part_no 
					   and   s4.status_type IN ('HISTORIC', 'CURRENT') 
					  )
 AND a.description = 'Function'	
 AND sh.part_no = 'EG_BH168014CLS-G' --'EV_BH165/80R14CLS'  --'EF_H165/80R14CLS'
 --ORDER by sh.part_no, bi.item_number 
;

--PART-NO                                                               COMPONENT_PART      component_description                           CH1     FUNCTION-CODE
--EG_BH168014CLS-G	6	127	CURRENT	24-10-2023 14:45:10		1	1	1	EP_PA17ZF365-686	PRE-ASS.ZIJKANT-17Z B170 VOERING-F365 B=686		903325	Pre Assembly	3		ENS	10	1.054	m
--EG_BH168014CLS-G	6	127	CURRENT	24-10-2023 14:45:10		1	1	1	ER_DE04-00-0012		CAPSTRIP 12 mm									903372	Capstrip		16		ENS	120	22.03	m
--EG_BH168014CLS-G	6	127	CURRENT	24-10-2023 14:45:10		1	1	1	EB_11205AR56S		14 HIEL  L=5 DR=6 HVS-AR (hoog:50 basis:7.2).	903365	Bead			3		ENS	90	2		pcs
--EG_BH168014CLS-G	6	127	CURRENT	24-10-2023 14:45:10		1	1	1	ET_LV172			LOOPVLAK SPRINT CLASSIC B166 SB124				903311	Tread			36		ENS	130	1.840119	m
--EG_BH168014CLS-G	6	127	CURRENT	24-10-2023 14:45:10		1	1	1	ER_ME01-90-0540		PLY GR/GE										903320	Ply 			1	5	ENS	70	1.067425	m   --verder onderzoeken
--EG_BH168014CLS-G	6	127	CURRENT	24-10-2023 14:45:10		1	1	1	ER_KE21-25-130STR	GORDELMATERIAAL WIT + stroken 755 0.75x20 (2x)	903316	Belt 			1	1	ENS	100	1.824	m
--EG_BH168014CLS-G	6	127	CURRENT	24-10-2023 14:45:10		1	1	1	ER_KE21-25-120		GORDELMATERIAAL WIT								903317	Belt 			2	8	ENS	110	1.831	m


--*****************************************
--*****************************************
--GREENTYRE-PROPERTIES
--*****************************************
select sh.part_no
,      sh.revision
,      bh.plant
,      bh.preferred
,      bh.alternative
,      sh.status
,      sh.frame_id
,      sp.section_id
,      s.description     AS  section_descr
,      sp.SUB_section_id
,      ss.description    AS  subsection_descr
,      sp.property_group
,      pg.description    AS  pg_descr
,      sp.property
,      p.description     AS  p_descr
,      sps.type
,      sps.ref_id
,      h.header_id
,      pl.field_id
,      sps.display_format
,      l.description    AS  layout_descr
,      h.description    AS  header_descr
,      sp.uom_id 
,	   u.description    AS uom_descr
,      sp.attribute
,	   a.description    AS attribute_descr
,      sp.test_method
,	   tm.description   AS test_method_descr
,      sp.characteristic
,      c.description    AS ch_1_descr
,      sp.ch_2
,	   c2.description   AS ch_2_descr
,      sp.ch_3
,	   c3.description   AS ch_3_descr
,      CASE when pl.field_id = 1  then 'Num_1'
            when pl.field_id = 2  then 'Num_2'
            when pl.field_id = 3  then 'Num_3'
            when pl.field_id = 4  then 'Num_4'
            when pl.field_id = 5  then 'Num_5'
            when pl.field_id = 6  then 'Num_6'
            when pl.field_id = 7  then 'Num_7'
            when pl.field_id = 8  then 'Num_8'
            when pl.field_id = 9  then 'Num_9'
            when pl.field_id = 10 then 'Num_10'
            when pl.field_id = 11 then 'Char_1'
            when pl.field_id = 12 then 'Char_2'
            when pl.field_id = 13 then 'Char_3'
            when pl.field_id = 14 then 'Char_4'
            when pl.field_id = 15 then 'Char_5'
            when pl.field_id = 16 then 'Char_6'
            when pl.field_id = 17 then 'Boolean_1'
            when pl.field_id = 18 then 'Boolean_2'
            when pl.field_id = 19 then 'Boolean_3'
            when pl.field_id = 20 then 'Boolean_4'
            when pl.field_id = 21 then 'Date_1'
            when pl.field_id = 22 then 'Date_2'
            when pl.field_id = 23 then 'UOM_id'
            when pl.field_id = 24 then 'Attribute'
            when pl.field_id = 25 then 'Test method'
            when pl.field_id = 26 then 'Characteristic'
            when pl.field_id = 27 then 'Property'
            when pl.field_id = 30 then 'Ch_2 (Characteristic 2)'
            when pl.field_id = 31 then 'Ch_3 (Characteristic 3)'
            when pl.field_id = 32 then 'Tm_det_1 (Test method detail)'
            when pl.field_id = 33 then 'Tm_det_2 (Test method detail)'
            when pl.field_id = 34 then 'Tm_det_3 (Test method detail)'
            when pl.field_id = 35 then 'Tm_det_4 (Test method detail)'
            when pl.field_id = 40 then 'Info'
            else 'NULL'
       END db_field
,      CASE when pl.field_id = 1  then cast(sp.Num_1 as varchar(30) )
            when pl.field_id = 2  then cast(sp.Num_2 as varchar(30) )
            when pl.field_id = 3  then cast(sp.Num_3 as varchar(30) )
            when pl.field_id = 4  then cast(sp.Num_4 as varchar(30) )
            when pl.field_id = 5  then cast(sp.Num_5 as varchar(30) )
            when pl.field_id = 6  then cast(sp.Num_6 as varchar(30) )
            when pl.field_id = 7  then cast(sp.Num_7 as varchar(30) )
            when pl.field_id = 8  then cast(sp.Num_8 as varchar(30) )
            when pl.field_id = 9  then cast(sp.Num_9 as varchar(30) )
            when pl.field_id = 10  then cast(sp.Num_10 as varchar(30) )
            when pl.field_id = 11 then sp.Char_1
            when pl.field_id = 12 then sp.Char_2
            when pl.field_id = 13 then sp.Char_3
            when pl.field_id = 14 then sp.Char_4
            when pl.field_id = 15 then sp.Char_5
            when pl.field_id = 16 then sp.Char_6
            when pl.field_id = 17 then sp.Boolean_1
            when pl.field_id = 18 then sp.Boolean_2
            when pl.field_id = 19 then sp.Boolean_3
            when pl.field_id = 20 then sp.Boolean_4
            when pl.field_id = 21 then to_char(sp.Date_1, 'dd-mm-yyyy hh24:mi:ss')
            when pl.field_id = 22 then to_char(sp.Date_2, 'dd-mm-yyyy hh24:mi:ss')
            when pl.field_id = 23 then cast(sp.UOM_id         as varchar(30) )
            when pl.field_id = 24 then cast(sp.Attribute      as varchar(30) )
            when pl.field_id = 25 then cast(sp.Test_method    as varchar(30) )
            when pl.field_id = 26 then cast(sp.Characteristic as varchar(30) )
            when pl.field_id = 27 then cast(sp.Property       as varchar(30) )
            when pl.field_id = 30 then cast(sp.Ch_2           as varchar(30) ) 
            when pl.field_id = 31 then cast(sp.Ch_3           as varchar(30) )
            when pl.field_id = 32 then sp.Tm_det_1
            when pl.field_id = 33 then sp.Tm_det_2
            when pl.field_id = 34 then sp.Tm_det_3
            when pl.field_id = 35 then sp.Tm_det_4
            when pl.field_id = 40 then sp.Info  
            else 'NULL'
       END db_field_value
from specification_header      sh
JOIN status                    st   on ( st.status    = sh.status )
JOIN bom_header                bh   on ( bh.part_no   = sh.part_no  and bh.revision = sh.revision )
JOIN specification_prop        sp   on ( sp.part_no   = sh.part_no  and sh.revision = sp.revision )
join specification_section     sps  on ( sps.part_no  = sp.part_no  and sps.revision = sp.revision and  sps.section_id  = sp.section_id  and sps.sub_section_id = sp.sub_section_id  )
JOIN layout                    l    ON ( l.layout_id  = sps.display_format and l.revision = sps.display_format_rev AND l.status = 2)
JOIN property_layout           pl   ON ( pl.layout_id = l.layout_id        and pl.revision = l.revision )
join header                    h    on ( h.header_id  = pl.header_id )
JOIN SECTION                   s    ON ( s.section_id        = sp.section_id )
JOIN SUB_SECTION               ss   on ( ss.sub_section_id   = sp.sub_section_id )
JOIN PROPERTY_GROUP            pg   ON ( pg.property_GROUP   = sp.property_group )
JOIN PROPERTY                  p    on ( p.property          = sp.property )
LEFT JOIN uom             u ON (pl.field_id = 23 AND u.uom_id             = sp.uom_id)
LEFT JOIN attribute       a ON (pl.field_id = 24 AND a.attribute          = sp.attribute)
LEFT JOIN test_method    tm ON (pl.field_id = 25 AND tm.test_method       = sp.test_method)
LEFT JOIN characteristic c  ON (pl.field_id = 26 AND c.characteristic_id  = sp.characteristic)
LEFT JOIN characteristic c2 ON (pl.field_id = 30 AND c2.characteristic_id = sp.ch_2)
LEFT JOIN characteristic c3 ON (pl.field_id = 31 AND c3.characteristic_id = sp.ch_3)
WHERE   NOT (  (  pl.field_id = 27  
               AND UPPER(h.description) = 'PROPERTY' )  --or (  pl.field_id = 23  )
            )	
--relatie is essentieel voor het bepalen van juiste display-format bij een property/group:			
AND    (  ( sps.type = 1 and sps.ref_id = sp.property_group )
       or ( sps.type = 4 and sps.ref_id = sp.property )
       )
--and   FS.FRAME_NO       = SH.FRAME_ID
--AND   SH.FRAME_ID like 'A_PCR_GT v1' 
--AND   SPS.SECTION_ID=701058
--and   SH.part_no = 'XGG_BF66A17J1' 
--and p.description like 'Side ring%'
--and   sp.part_no = 'XGG_BF66A17J1' 	
AND   st.status_type IN ('HISTORIC', 'CURRENT') 
and   sp.revision = (select max(sh2.revision) from specification_header sh2 where sh2.part_no = sp.part_no)
--order by  SH.part_no, SH.frame_id, SP.section_id, SP.sub_section_id, SP.property_group, SP.property
AND   sh.part_no = 'EG_BH168014CLS-G' --'EV_BH165/80R14CLS'  --'EF_H165/80R14CLS'
;

/*
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700542	General	701556	Building machine settings	705286	Bead distance	1	701556	700010	23	701928	IS_production_B&V	UoM	700649	mm	0		0								UOM_id	700649
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700542	General	701556	Building machine settings	705286	Bead distance	1	701556	700498	1	701928	IS_production_B&V	Target	700649		0		0								Num_1	380
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700542	General	701556	Building machine settings	705286	Bead distance	1	701556	700501	25	701928	IS_production_B&V	Apollo test code	700649		0		0								Test method	0
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700542	General	701556	Building machine settings	705286	Bead distance	1	701556	700503	17	701928	IS_production_B&V	Cr. par.	700649		0		0								Boolean_1	N
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700542	General	701556	Building machine settings	705286	Bead distance	1	701556	700811	2	701928	IS_production_B&V	- tol	700649		0		0								Num_2	
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700542	General	701556	Building machine settings	705286	Bead distance	1	701556	700812	3	701928	IS_production_B&V	+ tol	700649		0		0								Num_3	
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700542	General	701556	Building machine settings	705221	PA width		1	701556	700010	23	701928	IS_production_B&V	UoM			0		0								UOM_id	
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700542	General	701556	Building machine settings	705221	PA width		1	701556	700498	1	701928	IS_production_B&V	Target			0		0								Num_1	686
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700542	General	701556	Building machine settings	705221	PA width		1	701556	700501	25	701928	IS_production_B&V	Apollo test code			0		0								Test method	0
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700542	General	701556	Building machine settings	705221	PA width		1	701556	700503	17	701928	IS_production_B&V	Cr. par.			0		0								Boolean_1	N
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700542	General	701556	Building machine settings	705221	PA width		1	701556	700811	2	701928	IS_production_B&V	- tol			0		0								Num_2	
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700542	General	701556	Building machine settings	705221	PA width		1	701556	700812	3	701928	IS_production_B&V	+ tol			0		0								Num_3	
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700542	General	701556	Building machine settings	705220	PA overlap (sidewall / innerliner)	1	701556	700010	23	701928	IS_production_B&V	UoM			0		0								UOM_id	
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700542	General	701556	Building machine settings	705220	PA overlap (sidewall / innerliner)	1	701556	700498	1	701928	IS_production_B&V	Target			0		0								Num_1	9.5
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700542	General	701556	Building machine settings	705220	PA overlap (sidewall / innerliner)	1	701556	700501	25	701928	IS_production_B&V	Apollo test code			0		0								Test method	0
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700542	General	701556	Building machine settings	705220	PA overlap (sidewall / innerliner)	1	701556	700503	17	701928	IS_production_B&V	Cr. par.			0		0								Boolean_1	N
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700542	General	701556	Building machine settings	705220	PA overlap (sidewall / innerliner)	1	701556	700811	2	701928	IS_production_B&V	- tol			0		0								Num_2	
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700542	General	701556	Building machine settings	705220	PA overlap (sidewall / innerliner)	1	701556	700812	3	701928	IS_production_B&V	+ tol			0		0								Num_3	
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700542	General	701556	Building machine settings	705207	Lift belt package	1	701556	700010	23	701928	IS_production_B&V	UoM	700569	%	0		0								UOM_id	700569
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700542	General	701556	Building machine settings	705207	Lift belt package	1	701556	700498	1	701928	IS_production_B&V	Target	700569		0		0								Num_1	2.18
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700542	General	701556	Building machine settings	705207	Lift belt package	1	701556	700501	25	701928	IS_production_B&V	Apollo test code	700569		0		0								Test method	0
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700542	General	701556	Building machine settings	705207	Lift belt package	1	701556	700503	17	701928	IS_production_B&V	Cr. par.	700569		0		0								Boolean_1	N
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700542	General	701556	Building machine settings	705207	Lift belt package	1	701556	700811	2	701928	IS_production_B&V	- tol	700569		0		0								Num_2	
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700542	General	701556	Building machine settings	705207	Lift belt package	1	701556	700812	3	701928	IS_production_B&V	+ tol	700569		0		0								Num_3	
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700542	General	701556	Building machine settings	703514	Circumference B&T drum	1	701556	700010	23	701928	IS_production_B&V	UoM	700649	mm	0		0								UOM_id	700649
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700542	General	701556	Building machine settings	703514	Circumference B&T drum	1	701556	700498	1	701928	IS_production_B&V	Target	700649		0		0								Num_1	1821
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700542	General	701556	Building machine settings	703514	Circumference B&T drum	1	701556	700501	25	701928	IS_production_B&V	Apollo test code	700649		0		0								Test method	0
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700542	General	701556	Building machine settings	703514	Circumference B&T drum	1	701556	700503	17	701928	IS_production_B&V	Cr. par.	700649		0		0								Boolean_1	N
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700542	General	701556	Building machine settings	703514	Circumference B&T drum	1	701556	700811	2	701928	IS_production_B&V	- tol	700649		0		0								Num_2	
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700542	General	701556	Building machine settings	703514	Circumference B&T drum	1	701556	700812	3	701928	IS_production_B&V	+ tol	700649		0		0								Num_3	
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700542	General	701556	Building machine settings	703452	Circumference carcass drum	1	701556	700010	23	701928	IS_production_B&V	UoM	700649	mm	0		0								UOM_id	700649
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700542	General	701556	Building machine settings	703452	Circumference carcass drum	1	701556	700498	1	701928	IS_production_B&V	Target	700649		0		0								Num_1	1052
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700542	General	701556	Building machine settings	703452	Circumference carcass drum	1	701556	700501	25	701928	IS_production_B&V	Apollo test code	700649		0		0								Test method	0
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700542	General	701556	Building machine settings	703452	Circumference carcass drum	1	701556	700503	17	701928	IS_production_B&V	Cr. par.	700649		0		0								Boolean_1	N
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700542	General	701556	Building machine settings	703452	Circumference carcass drum	1	701556	700811	2	701928	IS_production_B&V	- tol	700649		0		0								Num_2	
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700542	General	701556	Building machine settings	703452	Circumference carcass drum	1	701556	700812	3	701928	IS_production_B&V	+ tol	700649		0		0								Num_3	
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700542	General	701567	Process capstrip	705223	Phase 2	1	701567	700840	1	701749	IS_Capstrip_PROP_NUM1-NUM4	Width [mm]			0										Num_1	0
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700542	General	701567	Process capstrip	705223	Phase 2	1	701567	700841	2	701749	IS_Capstrip_PROP_NUM1-NUM4	Degrees [°]			0										Num_2	1814
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700542	General	701567	Process capstrip	705223	Phase 2	1	701567	700842	3	701749	IS_Capstrip_PROP_NUM1-NUM4	Pitch [mm/rev.]			0										Num_3	12.5
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700542	General	701567	Process capstrip	705223	Phase 2	1	701567	700843	4	701749	IS_Capstrip_PROP_NUM1-NUM4	Pre-stress [N]			0										Num_4	30
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700542	General	701567	Process capstrip	705222	Phase 1	1	701567	700840	1	701749	IS_Capstrip_PROP_NUM1-NUM4	Width [mm]			0										Num_1	0
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700542	General	701567	Process capstrip	705222	Phase 1	1	701567	700841	2	701749	IS_Capstrip_PROP_NUM1-NUM4	Degrees [°]			0										Num_2	346
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700542	General	701567	Process capstrip	705222	Phase 1	1	701567	700842	3	701749	IS_Capstrip_PROP_NUM1-NUM4	Pitch [mm/rev.]			0										Num_3	.1
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700542	General	701567	Process capstrip	705222	Phase 1	1	701567	700843	4	701749	IS_Capstrip_PROP_NUM1-NUM4	Pre-stress [N]			0										Num_4	30
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700542	General	702316	Remarks processing	712209	Stempel opties	1	702316	700511	16	702788	IS_Single_Extra_Long_Char_DF	Value			0										Char_6	
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700542	General	702316	Remarks processing	710928	Ring / centerdeck options	1	702316	700511	16	702788	IS_Single_Extra_Long_Char_DF	Value			0										Char_6	20\125
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700542	General	0	default property group	705238	Recipe no.	4	705238	700511	11	700930	IS_Single_Value_CHAR_DF	Value			0										Char_1	019
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700968	HPBMA: HALFAUTOMATEN 82,84,86,88	701556	Building machine settings	707129	Tread table height	1	701556	700010	23	701928	IS_production_B&V	UoM	700649	mm	0		0								UOM_id	700649
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700968	HPBMA: HALFAUTOMATEN 82,84,86,88	701556	Building machine settings	707129	Tread table height	1	701556	700498	1	701928	IS_production_B&V	Target	700649		0		0								Num_1	583
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700968	HPBMA: HALFAUTOMATEN 82,84,86,88	701556	Building machine settings	707129	Tread table height	1	701556	700501	25	701928	IS_production_B&V	Apollo test code	700649		0		0								Test method	0
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700968	HPBMA: HALFAUTOMATEN 82,84,86,88	701556	Building machine settings	707129	Tread table height	1	701556	700503	17	701928	IS_production_B&V	Cr. par.	700649		0		0								Boolean_1	N
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700968	HPBMA: HALFAUTOMATEN 82,84,86,88	701556	Building machine settings	707129	Tread table height	1	701556	700811	2	701928	IS_production_B&V	- tol	700649		0		0								Num_2	
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700968	HPBMA: HALFAUTOMATEN 82,84,86,88	701556	Building machine settings	707129	Tread table height	1	701556	700812	3	701928	IS_production_B&V	+ tol	700649		0		0								Num_3	
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700968	HPBMA: HALFAUTOMATEN 82,84,86,88	701556	Building machine settings	705647	Turn-up distance	1	701556	700010	23	701928	IS_production_B&V	UoM	700649	mm	0		0								UOM_id	700649
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700968	HPBMA: HALFAUTOMATEN 82,84,86,88	701556	Building machine settings	705647	Turn-up distance	1	701556	700498	1	701928	IS_production_B&V	Target	700649		0		0								Num_1	324
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700968	HPBMA: HALFAUTOMATEN 82,84,86,88	701556	Building machine settings	705647	Turn-up distance	1	701556	700501	25	701928	IS_production_B&V	Apollo test code	700649		0		0								Test method	0
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700968	HPBMA: HALFAUTOMATEN 82,84,86,88	701556	Building machine settings	705647	Turn-up distance	1	701556	700503	17	701928	IS_production_B&V	Cr. par.	700649		0		0								Boolean_1	N
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700968	HPBMA: HALFAUTOMATEN 82,84,86,88	701556	Building machine settings	705647	Turn-up distance	1	701556	700811	2	701928	IS_production_B&V	- tol	700649		0		0								Num_2	
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700968	HPBMA: HALFAUTOMATEN 82,84,86,88	701556	Building machine settings	705647	Turn-up distance	1	701556	700812	3	701928	IS_production_B&V	+ tol	700649		0		0								Num_3	
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700968	HPBMA: HALFAUTOMATEN 82,84,86,88	701556	Building machine settings	705630	Shaping distance	1	701556	700010	23	701928	IS_production_B&V	UoM	700649	mm	0		0								UOM_id	700649
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700968	HPBMA: HALFAUTOMATEN 82,84,86,88	701556	Building machine settings	705630	Shaping distance	1	701556	700498	1	701928	IS_production_B&V	Target	700649		0		0								Num_1	254
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700968	HPBMA: HALFAUTOMATEN 82,84,86,88	701556	Building machine settings	705630	Shaping distance	1	701556	700501	25	701928	IS_production_B&V	Apollo test code	700649		0		0								Test method	0
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700968	HPBMA: HALFAUTOMATEN 82,84,86,88	701556	Building machine settings	705630	Shaping distance	1	701556	700503	17	701928	IS_production_B&V	Cr. par.	700649		0		0								Boolean_1	N
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700968	HPBMA: HALFAUTOMATEN 82,84,86,88	701556	Building machine settings	705630	Shaping distance	1	701556	700811	2	701928	IS_production_B&V	- tol	700649		0		0								Num_2	
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700968	HPBMA: HALFAUTOMATEN 82,84,86,88	701556	Building machine settings	705630	Shaping distance	1	701556	700812	3	701928	IS_production_B&V	+ tol	700649		0		0								Num_3	
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700968	HPBMA: HALFAUTOMATEN 82,84,86,88	701556	Building machine settings	705231	Preshaping distance	1	701556	700010	23	701928	IS_production_B&V	UoM	700649	mm	0		0								UOM_id	700649
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700968	HPBMA: HALFAUTOMATEN 82,84,86,88	701556	Building machine settings	705231	Preshaping distance	1	701556	700498	1	701928	IS_production_B&V	Target	700649		0		0								Num_1	312
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700968	HPBMA: HALFAUTOMATEN 82,84,86,88	701556	Building machine settings	705231	Preshaping distance	1	701556	700501	25	701928	IS_production_B&V	Apollo test code	700649		0		0								Test method	0
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700968	HPBMA: HALFAUTOMATEN 82,84,86,88	701556	Building machine settings	705231	Preshaping distance	1	701556	700503	17	701928	IS_production_B&V	Cr. par.	700649		0		0								Boolean_1	N
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700968	HPBMA: HALFAUTOMATEN 82,84,86,88	701556	Building machine settings	705231	Preshaping distance	1	701556	700811	2	701928	IS_production_B&V	- tol	700649		0		0								Num_2	
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700968	HPBMA: HALFAUTOMATEN 82,84,86,88	701556	Building machine settings	705231	Preshaping distance	1	701556	700812	3	701928	IS_production_B&V	+ tol	700649		0		0								Num_3	
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700968	HPBMA: HALFAUTOMATEN 82,84,86,88	701570	Tooling	707188	Spacer PA applicator	1	701570	700511	11	700930	IS_Single_Value_CHAR_DF	Value			0										Char_1	ABDRUM 14"
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700968	HPBMA: HALFAUTOMATEN 82,84,86,88	701570	Tooling	707168	Bead transfer ring	1	701570	700511	11	700930	IS_Single_Value_CHAR_DF	Value			0										Char_1	HAR14  TYPE1
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700968	HPBMA: HALFAUTOMATEN 82,84,86,88	701570	Tooling	707149	Roll over can	1	701570	700511	11	700930	IS_Single_Value_CHAR_DF	Value			0										Char_1	OSR500
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700968	HPBMA: HALFAUTOMATEN 82,84,86,88	701570	Tooling	707148	Building drum	1	701570	700511	11	700930	IS_Single_Value_CHAR_DF	Value			0										Char_1	BTS14
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700968	HPBMA: HALFAUTOMATEN 82,84,86,88	701570	Tooling	705670	B&T spacer	1	701570	700511	11	700930	IS_Single_Value_CHAR_DF	Value			0										Char_1	ABWKK-24.50
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700968	HPBMA: HALFAUTOMATEN 82,84,86,88	701570	Tooling	705628	Ringwidth	1	701570	700511	11	700930	IS_Single_Value_CHAR_DF	Value			0										Char_1	LR14-20
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700968	HPBMA: HALFAUTOMATEN 82,84,86,88	701570	Tooling	705030	Centerdeck	1	701570	700511	11	700930	IS_Single_Value_CHAR_DF	Value			0										Char_1	MS14-095
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700968	HPBMA: HALFAUTOMATEN 82,84,86,88	701570	Tooling	703413	B&T stamps	1	701570	700511	11	700930	IS_Single_Value_CHAR_DF	Value			0										Char_1	545-645
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700968	HPBMA: HALFAUTOMATEN 82,84,86,88	0	default property group	710528	volgnummer	4	710528	700511	1	702968	IS_Prop_Num	Value			0										Num_1	10
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700973	HPBMG: HALFAUTOMAAT  92	701556	Building machine settings	705647	Turn-up distance	1	701556	700010	23	701928	IS_production_B&V	UoM	700649	mm	0		0								UOM_id	700649
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700973	HPBMG: HALFAUTOMAAT  92	701556	Building machine settings	705647	Turn-up distance	1	701556	700498	1	701928	IS_production_B&V	Target	700649		0		0								Num_1	324
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700973	HPBMG: HALFAUTOMAAT  92	701556	Building machine settings	705647	Turn-up distance	1	701556	700501	25	701928	IS_production_B&V	Apollo test code	700649		0		0								Test method	0
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700973	HPBMG: HALFAUTOMAAT  92	701556	Building machine settings	705647	Turn-up distance	1	701556	700503	17	701928	IS_production_B&V	Cr. par.	700649		0		0								Boolean_1	N
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700973	HPBMG: HALFAUTOMAAT  92	701556	Building machine settings	705647	Turn-up distance	1	701556	700811	2	701928	IS_production_B&V	- tol	700649		0		0								Num_2	
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700973	HPBMG: HALFAUTOMAAT  92	701556	Building machine settings	705647	Turn-up distance	1	701556	700812	3	701928	IS_production_B&V	+ tol	700649		0		0								Num_3	
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700973	HPBMG: HALFAUTOMAAT  92	701556	Building machine settings	705630	Shaping distance	1	701556	700010	23	701928	IS_production_B&V	UoM	700649	mm	0		0								UOM_id	700649
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700973	HPBMG: HALFAUTOMAAT  92	701556	Building machine settings	705630	Shaping distance	1	701556	700498	1	701928	IS_production_B&V	Target	700649		0		0								Num_1	254
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700973	HPBMG: HALFAUTOMAAT  92	701556	Building machine settings	705630	Shaping distance	1	701556	700501	25	701928	IS_production_B&V	Apollo test code	700649		0		0								Test method	0
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700973	HPBMG: HALFAUTOMAAT  92	701556	Building machine settings	705630	Shaping distance	1	701556	700503	17	701928	IS_production_B&V	Cr. par.	700649		0		0								Boolean_1	N
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700973	HPBMG: HALFAUTOMAAT  92	701556	Building machine settings	705630	Shaping distance	1	701556	700811	2	701928	IS_production_B&V	- tol	700649		0		0								Num_2	
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700973	HPBMG: HALFAUTOMAAT  92	701556	Building machine settings	705630	Shaping distance	1	701556	700812	3	701928	IS_production_B&V	+ tol	700649		0		0								Num_3	
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700973	HPBMG: HALFAUTOMAAT  92	701556	Building machine settings	705231	Preshaping distance	1	701556	700010	23	701928	IS_production_B&V	UoM	700649	mm	0		0								UOM_id	700649
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700973	HPBMG: HALFAUTOMAAT  92	701556	Building machine settings	705231	Preshaping distance	1	701556	700498	1	701928	IS_production_B&V	Target	700649		0		0								Num_1	312
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700973	HPBMG: HALFAUTOMAAT  92	701556	Building machine settings	705231	Preshaping distance	1	701556	700501	25	701928	IS_production_B&V	Apollo test code	700649		0		0								Test method	0
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700973	HPBMG: HALFAUTOMAAT  92	701556	Building machine settings	705231	Preshaping distance	1	701556	700503	17	701928	IS_production_B&V	Cr. par.	700649		0		0								Boolean_1	N
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700973	HPBMG: HALFAUTOMAAT  92	701556	Building machine settings	705231	Preshaping distance	1	701556	700811	2	701928	IS_production_B&V	- tol	700649		0		0								Num_2	
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700973	HPBMG: HALFAUTOMAAT  92	701556	Building machine settings	705231	Preshaping distance	1	701556	700812	3	701928	IS_production_B&V	+ tol	700649		0		0								Num_3	
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700973	HPBMG: HALFAUTOMAAT  92	701570	Tooling	707188	Spacer PA applicator	1	701570	700511	11	700930	IS_Single_Value_CHAR_DF	Value			0										Char_1	ABDRUM 14"
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700973	HPBMG: HALFAUTOMAAT  92	701570	Tooling	707168	Bead transfer ring	1	701570	700511	11	700930	IS_Single_Value_CHAR_DF	Value			0										Char_1	HAR14  TYPE2
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700973	HPBMG: HALFAUTOMAAT  92	701570	Tooling	707149	Roll over can	1	701570	700511	11	700930	IS_Single_Value_CHAR_DF	Value			0										Char_1	OSR500
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700973	HPBMG: HALFAUTOMAAT  92	701570	Tooling	707148	Building drum	1	701570	700511	11	700930	IS_Single_Value_CHAR_DF	Value			0										Char_1	BTS14
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700973	HPBMG: HALFAUTOMAAT  92	701570	Tooling	705670	B&T spacer	1	701570	700511	11	700930	IS_Single_Value_CHAR_DF	Value			0										Char_1	ABWKK-24.50
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700973	HPBMG: HALFAUTOMAAT  92	701570	Tooling	705628	Ringwidth	1	701570	700511	11	700930	IS_Single_Value_CHAR_DF	Value			0										Char_1	LR14-20
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700973	HPBMG: HALFAUTOMAAT  92	701570	Tooling	705030	Centerdeck	1	701570	700511	11	700930	IS_Single_Value_CHAR_DF	Value			0										Char_1	MS14-095
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700973	HPBMG: HALFAUTOMAAT  92	701570	Tooling	703413	B&T stamps	1	701570	700511	11	700930	IS_Single_Value_CHAR_DF	Value			0										Char_1	550-650
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700583	Processing	700973	HPBMG: HALFAUTOMAAT  92	0	default property group	710528	volgnummer	4	710528	700511	1	702968	IS_Prop_Num	Value			0										Num_1	20
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700584	Properties	0	(none)	701557	Construction parameters	712213	extra pressing of carcass splice	1	701557	700511	17	702088	IS_Single_Boolean	Value			0										Boolean_1	N
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700584	Properties	0	(none)	701557	Construction parameters	712211	2 ply	1	701557	700511	17	702088	IS_Single_Boolean	Value			0										Boolean_1	N
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700584	Properties	0	(none)	701557	Construction parameters	712210	88 degrees plies	1	701557	700511	17	702088	IS_Single_Boolean	Value			0										Boolean_1	N
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700584	Properties	0	(none)	701557	Construction parameters	707770	BEC strip	1	701557	700511	17	702088	IS_Single_Boolean	Value			0										Boolean_1	N
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700584	Properties	0	(none)	701557	Construction parameters	706588	Endless capply	1	701557	700511	17	702088	IS_Single_Boolean	Value			0										Boolean_1	Y
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700584	Properties	0	(none)	701557	Construction parameters	705632	Sidewall over tread	1	701557	700511	17	702088	IS_Single_Boolean	Value			0										Boolean_1	N
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700584	Properties	0	(none)	701557	Construction parameters	705244	Rimcushion under bead	1	701557	700511	17	702088	IS_Single_Boolean	Value			0										Boolean_1	Y
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700584	Properties	0	(none)	701564	Greentyre properties	707130	Overlap capply	1	701564	700010	23	701928	IS_production_B&V	UoM	700649	mm	0		0								UOM_id	700649
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700584	Properties	0	(none)	701564	Greentyre properties	707130	Overlap capply	1	701564	700498	1	701928	IS_production_B&V	Target	700649		0		0								Num_1	
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700584	Properties	0	(none)	701564	Greentyre properties	707130	Overlap capply	1	701564	700501	25	701928	IS_production_B&V	Apollo test code	700649		0		0								Test method	0
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700584	Properties	0	(none)	701564	Greentyre properties	707130	Overlap capply	1	701564	700503	17	701928	IS_production_B&V	Cr. par.	700649		0		0								Boolean_1	N
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700584	Properties	0	(none)	701564	Greentyre properties	707130	Overlap capply	1	701564	700811	2	701928	IS_production_B&V	- tol	700649		0		0								Num_2	
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700584	Properties	0	(none)	701564	Greentyre properties	707130	Overlap capply	1	701564	700812	3	701928	IS_production_B&V	+ tol	700649		0		0								Num_3	
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700584	Properties	0	(none)	701564	Greentyre properties	706128	Number of capply layers	1	701564	700010	23	701928	IS_production_B&V	UoM			0		0								UOM_id	
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700584	Properties	0	(none)	701564	Greentyre properties	706128	Number of capply layers	1	701564	700498	1	701928	IS_production_B&V	Target			0		0								Num_1	1
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700584	Properties	0	(none)	701564	Greentyre properties	706128	Number of capply layers	1	701564	700501	25	701928	IS_production_B&V	Apollo test code			0		0								Test method	0
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700584	Properties	0	(none)	701564	Greentyre properties	706128	Number of capply layers	1	701564	700503	17	701928	IS_production_B&V	Cr. par.			0		0								Boolean_1	N
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700584	Properties	0	(none)	701564	Greentyre properties	706128	Number of capply layers	1	701564	700811	2	701928	IS_production_B&V	- tol			0		0								Num_2	
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700584	Properties	0	(none)	701564	Greentyre properties	706128	Number of capply layers	1	701564	700812	3	701928	IS_production_B&V	+ tol			0		0								Num_3	
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700584	Properties	0	(none)	701564	Greentyre properties	705668	Sidewall distance (in turnup pos.)	1	701564	700010	23	701928	IS_production_B&V	UoM	700649	mm	0		0								UOM_id	700649
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700584	Properties	0	(none)	701564	Greentyre properties	705668	Sidewall distance (in turnup pos.)	1	701564	700498	1	701928	IS_production_B&V	Target	700649		0		0								Num_1	100
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700584	Properties	0	(none)	701564	Greentyre properties	705668	Sidewall distance (in turnup pos.)	1	701564	700501	25	701928	IS_production_B&V	Apollo test code	700649		0		0								Test method	0
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700584	Properties	0	(none)	701564	Greentyre properties	705668	Sidewall distance (in turnup pos.)	1	701564	700503	17	701928	IS_production_B&V	Cr. par.	700649		0		0								Boolean_1	N
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700584	Properties	0	(none)	701564	Greentyre properties	705668	Sidewall distance (in turnup pos.)	1	701564	700811	2	701928	IS_production_B&V	- tol	700649		0		0								Num_2	
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700584	Properties	0	(none)	701564	Greentyre properties	705668	Sidewall distance (in turnup pos.)	1	701564	700812	3	701928	IS_production_B&V	+ tol	700649		0		0								Num_3	
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700584	Properties	0	(none)	701564	Greentyre properties	705642	Total width capstrip	1	701564	700010	23	701928	IS_production_B&V	UoM	700649	mm	0		0								UOM_id	700649
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700584	Properties	0	(none)	701564	Greentyre properties	705642	Total width capstrip	1	701564	700498	1	701928	IS_production_B&V	Target	700649		0		0								Num_1	138
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700584	Properties	0	(none)	701564	Greentyre properties	705642	Total width capstrip	1	701564	700501	25	701928	IS_production_B&V	Apollo test code	700649		0		0								Test method	0
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700584	Properties	0	(none)	701564	Greentyre properties	705642	Total width capstrip	1	701564	700503	17	701928	IS_production_B&V	Cr. par.	700649		0		0								Boolean_1	N
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700584	Properties	0	(none)	701564	Greentyre properties	705642	Total width capstrip	1	701564	700811	2	701928	IS_production_B&V	- tol	700649		0		0								Num_2	
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700584	Properties	0	(none)	701564	Greentyre properties	705642	Total width capstrip	1	701564	700812	3	701928	IS_production_B&V	+ tol	700649		0		0								Num_3	
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700584	Properties	0	(none)	701564	Greentyre properties	705408	Circumference shape to tread	1	701564	700010	23	701928	IS_production_B&V	UoM	700649	mm	0		0								UOM_id	700649
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700584	Properties	0	(none)	701564	Greentyre properties	705408	Circumference shape to tread	1	701564	700498	1	701928	IS_production_B&V	Target	700649		0		0								Num_1	1884
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700584	Properties	0	(none)	701564	Greentyre properties	705408	Circumference shape to tread	1	701564	700501	25	701928	IS_production_B&V	Apollo test code	700649		0		0								Test method	0
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700584	Properties	0	(none)	701564	Greentyre properties	705408	Circumference shape to tread	1	701564	700503	17	701928	IS_production_B&V	Cr. par.	700649		0		0								Boolean_1	N
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700584	Properties	0	(none)	701564	Greentyre properties	705408	Circumference shape to tread	1	701564	700811	2	701928	IS_production_B&V	- tol	700649		0		0								Num_2	
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700584	Properties	0	(none)	701564	Greentyre properties	705408	Circumference shape to tread	1	701564	700812	3	701928	IS_production_B&V	+ tol	700649		0		0								Num_3	
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700584	Properties	0	(none)	701564	Greentyre properties	703508	Circumference greentyre	1	701564	700010	23	701928	IS_production_B&V	UoM	700649	mm	0		0								UOM_id	700649
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700584	Properties	0	(none)	701564	Greentyre properties	703508	Circumference greentyre	1	701564	700498	1	701928	IS_production_B&V	Target	700649		0		0								Num_1	1888
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700584	Properties	0	(none)	701564	Greentyre properties	703508	Circumference greentyre	1	701564	700501	25	701928	IS_production_B&V	Apollo test code	700649		0		0								Test method	0
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700584	Properties	0	(none)	701564	Greentyre properties	703508	Circumference greentyre	1	701564	700503	17	701928	IS_production_B&V	Cr. par.	700649		0		0								Boolean_1	N
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700584	Properties	0	(none)	701564	Greentyre properties	703508	Circumference greentyre	1	701564	700811	2	701928	IS_production_B&V	- tol	700649		0		0								Num_2	
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700584	Properties	0	(none)	701564	Greentyre properties	703508	Circumference greentyre	1	701564	700812	3	701928	IS_production_B&V	+ tol	700649		0		0								Num_3	
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700755	SAP information	0	(none)	703176	Aging SAP	710530	Aging (Maximal)	1	703176	700010	23	702068	IS_Prop_UoM_Num	UoM			0										UOM_id	
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700755	SAP information	0	(none)	703176	Aging SAP	710530	Aging (Maximal)	1	703176	700511	1	702068	IS_Prop_UoM_Num	Value			0										Num_1	31
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700755	SAP information	0	(none)	0	default property group	703262	Weight	4	703262	700010	23	702068	IS_Prop_UoM_Num	UoM			0										UOM_id	
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700755	SAP information	0	(none)	0	default property group	703262	Weight	4	703262	700511	1	702068	IS_Prop_UoM_Num	Value			0										Num_1	1
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700755	SAP information	0	(none)	0	default property group	705428	Article group PG	4	705428	700511	26	700929	IS_Single_Value_ASSOC_DF	Value			0				900248	NU: GREENTYRE CLASSIC/SPRINT      					Characteristic	900248
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700755	SAP information	0	(none)	0	default property group	705429	Packaging PG	4	705429	700751	26	701388	IS_PROP_ASS_NUM	Packaging			0				900456	PLR4: Rek 4					Characteristic	900456
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700755	SAP information	0	(none)	0	default property group	705429	Packaging PG	4	705429	701151	1	701388	IS_PROP_ASS_NUM	Amount			0				900456						Num_1	24
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700755	SAP information	0	(none)	0	default property group	709030	Physical in product	4	709030	700511	26	700929	IS_Single_Value_ASSOC_DF	Value			0				900484	Yes					Characteristic	900484
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700755	SAP information	0	(none)	0	default property group	710531	Article type	4	710531	700511	26	700929	IS_Single_Value_ASSOC_DF	Value			0				900975	G: Greentyres Alternatief					Characteristic	900975
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700755	SAP information	0	(none)	0	default property group	714488	Use for OE	4	714488	700511	26	700929	IS_Single_Value_ASSOC_DF	Value			0				900485	No					Characteristic	900485
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700755	SAP information	0	(none)	0	default property group	717751	SAP material group	4	717751	700511	26	700929	IS_Single_Value_ASSOC_DF	Value			0				874	3GT03: Radial SS Green Tyre					Characteristic	874
EG_BH168014CLS-G	6	ENS	1	1	127	E_PCR_GT_B	700915	Config	0	(none)	0	default property group	709128	Base UoM	4	709128	700511	11	700930	IS_Single_Value_CHAR_DF	Value			0										Char_1	pcs
*/


--
--CAPSTRIP-PROPERTIES
select sh.part_no
,      sh.revision
,      bh.plant
,      bh.preferred
,      bh.alternative
,      sh.status
,      sh.frame_id
,      sp.section_id
,      s.description     AS  section_descr
,      sp.SUB_section_id
,      ss.description    AS  subsection_descr
,      sp.property_group
,      pg.description    AS  pg_descr
,      sp.property
,      p.description     AS  p_descr
,      sps.type
,      sps.ref_id
,      h.header_id
,      pl.field_id
,      sps.display_format
,      l.description    AS  layout_descr
,      h.description    AS  header_descr
,      sp.uom_id 
,	   u.description    AS uom_descr
,      sp.attribute
,	   a.description    AS attribute_descr
,      sp.test_method
,	   tm.description   AS test_method_descr
,      sp.characteristic
,      c.description    AS ch_1_descr
,      sp.ch_2
,	   c2.description   AS ch_2_descr
,      sp.ch_3
,	   c3.description   AS ch_3_descr
,      CASE when pl.field_id = 1  then 'Num_1'
            when pl.field_id = 2  then 'Num_2'
            when pl.field_id = 3  then 'Num_3'
            when pl.field_id = 4  then 'Num_4'
            when pl.field_id = 5  then 'Num_5'
            when pl.field_id = 6  then 'Num_6'
            when pl.field_id = 7  then 'Num_7'
            when pl.field_id = 8  then 'Num_8'
            when pl.field_id = 9  then 'Num_9'
            when pl.field_id = 10 then 'Num_10'
            when pl.field_id = 11 then 'Char_1'
            when pl.field_id = 12 then 'Char_2'
            when pl.field_id = 13 then 'Char_3'
            when pl.field_id = 14 then 'Char_4'
            when pl.field_id = 15 then 'Char_5'
            when pl.field_id = 16 then 'Char_6'
            when pl.field_id = 17 then 'Boolean_1'
            when pl.field_id = 18 then 'Boolean_2'
            when pl.field_id = 19 then 'Boolean_3'
            when pl.field_id = 20 then 'Boolean_4'
            when pl.field_id = 21 then 'Date_1'
            when pl.field_id = 22 then 'Date_2'
            when pl.field_id = 23 then 'UOM_id'
            when pl.field_id = 24 then 'Attribute'
            when pl.field_id = 25 then 'Test method'
            when pl.field_id = 26 then 'Characteristic'
            when pl.field_id = 27 then 'Property'
            when pl.field_id = 30 then 'Ch_2 (Characteristic 2)'
            when pl.field_id = 31 then 'Ch_3 (Characteristic 3)'
            when pl.field_id = 32 then 'Tm_det_1 (Test method detail)'
            when pl.field_id = 33 then 'Tm_det_2 (Test method detail)'
            when pl.field_id = 34 then 'Tm_det_3 (Test method detail)'
            when pl.field_id = 35 then 'Tm_det_4 (Test method detail)'
            when pl.field_id = 40 then 'Info'
            else 'NULL'
       END db_field
,      CASE when pl.field_id = 1  then cast(sp.Num_1 as varchar(30) )
            when pl.field_id = 2  then cast(sp.Num_2 as varchar(30) )
            when pl.field_id = 3  then cast(sp.Num_3 as varchar(30) )
            when pl.field_id = 4  then cast(sp.Num_4 as varchar(30) )
            when pl.field_id = 5  then cast(sp.Num_5 as varchar(30) )
            when pl.field_id = 6  then cast(sp.Num_6 as varchar(30) )
            when pl.field_id = 7  then cast(sp.Num_7 as varchar(30) )
            when pl.field_id = 8  then cast(sp.Num_8 as varchar(30) )
            when pl.field_id = 9  then cast(sp.Num_9 as varchar(30) )
            when pl.field_id = 10  then cast(sp.Num_10 as varchar(30) )
            when pl.field_id = 11 then sp.Char_1
            when pl.field_id = 12 then sp.Char_2
            when pl.field_id = 13 then sp.Char_3
            when pl.field_id = 14 then sp.Char_4
            when pl.field_id = 15 then sp.Char_5
            when pl.field_id = 16 then sp.Char_6
            when pl.field_id = 17 then sp.Boolean_1
            when pl.field_id = 18 then sp.Boolean_2
            when pl.field_id = 19 then sp.Boolean_3
            when pl.field_id = 20 then sp.Boolean_4
            when pl.field_id = 21 then to_char(sp.Date_1, 'dd-mm-yyyy hh24:mi:ss')
            when pl.field_id = 22 then to_char(sp.Date_2, 'dd-mm-yyyy hh24:mi:ss')
            when pl.field_id = 23 then cast(sp.UOM_id         as varchar(30) )
            when pl.field_id = 24 then cast(sp.Attribute      as varchar(30) )
            when pl.field_id = 25 then cast(sp.Test_method    as varchar(30) )
            when pl.field_id = 26 then cast(sp.Characteristic as varchar(30) )
            when pl.field_id = 27 then cast(sp.Property       as varchar(30) )
            when pl.field_id = 30 then cast(sp.Ch_2           as varchar(30) ) 
            when pl.field_id = 31 then cast(sp.Ch_3           as varchar(30) )
            when pl.field_id = 32 then sp.Tm_det_1
            when pl.field_id = 33 then sp.Tm_det_2
            when pl.field_id = 34 then sp.Tm_det_3
            when pl.field_id = 35 then sp.Tm_det_4
            when pl.field_id = 40 then sp.Info  
            else 'NULL'
       END db_field_value
from specification_header      sh
JOIN status                    st   on ( st.status    = sh.status )
JOIN bom_header                bh   on ( bh.part_no   = sh.part_no  and bh.revision = sh.revision )
JOIN specification_prop        sp   on ( sp.part_no   = sh.part_no  and sh.revision = sp.revision )
join specification_section     sps  on ( sps.part_no  = sp.part_no  and sps.revision = sp.revision and  sps.section_id  = sp.section_id  and sps.sub_section_id = sp.sub_section_id  )
JOIN layout                    l    ON ( l.layout_id  = sps.display_format and l.revision = sps.display_format_rev AND l.status = 2)
JOIN property_layout           pl   ON ( pl.layout_id = l.layout_id        and pl.revision = l.revision )
join header                    h    on ( h.header_id  = pl.header_id )
JOIN SECTION                   s    ON ( s.section_id        = sp.section_id )
JOIN SUB_SECTION               ss   on ( ss.sub_section_id   = sp.sub_section_id )
JOIN PROPERTY_GROUP            pg   ON ( pg.property_GROUP   = sp.property_group )
JOIN PROPERTY                  p    on ( p.property          = sp.property )
LEFT JOIN uom             u ON (pl.field_id = 23 AND u.uom_id             = sp.uom_id)
LEFT JOIN attribute       a ON (pl.field_id = 24 AND a.attribute          = sp.attribute)
LEFT JOIN test_method    tm ON (pl.field_id = 25 AND tm.test_method       = sp.test_method)
LEFT JOIN characteristic c  ON (pl.field_id = 26 AND c.characteristic_id  = sp.characteristic)
LEFT JOIN characteristic c2 ON (pl.field_id = 30 AND c2.characteristic_id = sp.ch_2)
LEFT JOIN characteristic c3 ON (pl.field_id = 31 AND c3.characteristic_id = sp.ch_3)
WHERE   NOT (  (  pl.field_id = 27  
               AND UPPER(h.description) = 'PROPERTY' )  --or (  pl.field_id = 23  )
            )	
--relatie is essentieel voor het bepalen van juiste display-format bij een property/group:			
AND    (  ( sps.type = 1 and sps.ref_id = sp.property_group )
       or ( sps.type = 4 and sps.ref_id = sp.property )
       )
--and   FS.FRAME_NO       = SH.FRAME_ID
--AND   SH.FRAME_ID like 'A_PCR_GT v1' 
--AND   SPS.SECTION_ID=701058
--and   SH.part_no = 'XGG_BF66A17J1' 
--and p.description like 'Side ring%'
--and   sp.part_no = 'XGG_BF66A17J1' 	
AND   st.status_type IN ('HISTORIC', 'CURRENT') 
and   sp.revision = (select max(sh2.revision) from specification_header sh2 where sh2.part_no = sp.part_no)
--order by  SH.part_no, SH.frame_id, SP.section_id, SP.sub_section_id, SP.property_group, SP.property
AND   sh.part_no = 'ER_DE04-00-0012' --'EV_BH165/80R14CLS'  --'EF_H165/80R14CLS'
;


ER_DE04-00-0012	16	ENS	1	1	126	E_Capply	700583	Processing	701822	MSLIT: Minislitter	0	default property group	710528	volgnummer	4	710528	700511	1	702968	IS_Prop_Num	Value			0										Num_1	10
ER_DE04-00-0012	16	ENS	1	1	126	E_Capply	700584	Properties	0		(none)			701817	Dimensions SFP			704688	Angle	1	701817	700010	23	702108	IS_Production_B&V_2	UoM	701009	°	0		0								UOM_id	701009
ER_DE04-00-0012	16	ENS	1	1	126	E_Capply	700584	Properties	0		(none)			701817	Dimensions SFP			704688	Angle	1	701817	700498	1	702108	IS_Production_B&V_2	Target	701009		0		0								Num_1	0
ER_DE04-00-0012	16	ENS	1	1	126	E_Capply	700584	Properties	0		(none)			701817	Dimensions SFP			704688	Angle	1	701817	700501	25	702108	IS_Production_B&V_2	Apollo test code	701009		0		0								Test method	0
ER_DE04-00-0012	16	ENS	1	1	126	E_Capply	700584	Properties	0		(none)			701817	Dimensions SFP			704688	Angle	1	701817	700503	17	702108	IS_Production_B&V_2	Cr. par.	701009		0		0								Boolean_1	N
ER_DE04-00-0012	16	ENS	1	1	126	E_Capply	700584	Properties	0		(none)			701817	Dimensions SFP			704688	Angle	1	701817	700811	2	702108	IS_Production_B&V_2	- tol	701009		0		0								Num_2	
ER_DE04-00-0012	16	ENS	1	1	126	E_Capply	700584	Properties	0		(none)			701817	Dimensions SFP			704688	Angle	1	701817	700812	3	702108	IS_Production_B&V_2	+ tol	701009		0		0								Num_3	
ER_DE04-00-0012	16	ENS	1	1	126	E_Capply	700584	Properties	0		(none)			701817	Dimensions SFP			703268	Width	1	701817	700010	23	702108	IS_Production_B&V_2	UoM	700649	mm	0		0								UOM_id	700649
ER_DE04-00-0012	16	ENS	1	1	126	E_Capply	700584	Properties	0		(none)			701817	Dimensions SFP			703268	Width	1	701817	700498	1	702108	IS_Production_B&V_2	Target	700649		0		0								Num_1	12
ER_DE04-00-0012	16	ENS	1	1	126	E_Capply	700584	Properties	0		(none)			701817	Dimensions SFP			703268	Width	1	701817	700501	25	702108	IS_Production_B&V_2	Apollo test code	700649		0		0								Test method	0
ER_DE04-00-0012	16	ENS	1	1	126	E_Capply	700584	Properties	0		(none)			701817	Dimensions SFP			703268	Width	1	701817	700503	17	702108	IS_Production_B&V_2	Cr. par.	700649		0		0								Boolean_1	N
ER_DE04-00-0012	16	ENS	1	1	126	E_Capply	700584	Properties	0		(none)			701817	Dimensions SFP			703268	Width	1	701817	700811	2	702108	IS_Production_B&V_2	- tol	700649		0		0								Num_2	-1
ER_DE04-00-0012	16	ENS	1	1	126	E_Capply	700584	Properties	0		(none)			701817	Dimensions SFP			703268	Width	1	701817	700812	3	702108	IS_Production_B&V_2	+ tol	700649		0		0								Num_3	1
ER_DE04-00-0012	16	ENS	1	1	126	E_Capply	700755	SAP information	0	(none)			703176	Aging SAP				710530	Aging (Maximal)	1	703176	700010	23	702068	IS_Prop_UoM_Num	UoM	700627	day	0										UOM_id	700627
ER_DE04-00-0012	16	ENS	1	1	126	E_Capply	700755	SAP information	0	(none)			703176	Aging SAP				710530	Aging (Maximal)	1	703176	700511	1	702068	IS_Prop_UoM_Num	Value	700627		0										Num_1	14
ER_DE04-00-0012	16	ENS	1	1	126	E_Capply	700755	SAP information	0	(none)			703176	Aging SAP				710529	Aging (minimal)	1	703176	700010	23	702068	IS_Prop_UoM_Num	UoM	700626	hours	0										UOM_id	700626
ER_DE04-00-0012	16	ENS	1	1	126	E_Capply	700755	SAP information	0	(none)			703176	Aging SAP				710529	Aging (minimal)	1	703176	700511	1	702068	IS_Prop_UoM_Num	Value	700626		0										Num_1	0
ER_DE04-00-0012	16	ENS	1	1	126	E_Capply	700755	SAP information	0	(none)			0		default property group	705428	Article group PG	4	705428	700511	26	700929	IS_Single_Value_ASSOC_DF	Value			0				900205	L9: NOH EN GORDEL-STRIPS          					Characteristic	900205
ER_DE04-00-0012	16	ENS	1	1	126	E_Capply	700755	SAP information	0	(none)			0		default property group	705429	Packaging PG	4	705429	700751	26	701388	IS_PROP_ASS_NUM	Packaging			0				901439	KLOS					Characteristic	901439
ER_DE04-00-0012	16	ENS	1	1	126	E_Capply	700755	SAP information	0	(none)			0		default property group	705429	Packaging PG	4	705429	701151	1	701388	IS_PROP_ASS_NUM	Amount			0				901439						Num_1	2800
ER_DE04-00-0012	16	ENS	1	1	126	E_Capply	700755	SAP information	0	(none)			0		default property group	709030	Physical in product	4	709030	700511	26	700929	IS_Single_Value_ASSOC_DF	Value			0				900484	Yes					Characteristic	900484
ER_DE04-00-0012	16	ENS	1	1	126	E_Capply	700755	SAP information	0	(none)			0		default property group	710531	Article type	4	710531	700511	26	700929	IS_Single_Value_ASSOC_DF	Value			0				900976	H: Halffabrikaten Volgordelijk					Characteristic	900976
ER_DE04-00-0012	16	ENS	1	1	126	E_Capply	700755	SAP information	0	(none)			0		default property group	717751	SAP material group	4	717751	700511	26	700929	IS_Single_Value_ASSOC_DF	Value			0				876	3Q002: Ply Squeegee Radial					Characteristic	876


--bom van capstrip binnen capstrip
 SELECT bi.part_no                                            AS parent_part_no
 ,      bi.revision                                           AS parent_rev
 ,      sh.status                                             AS parent_status
 ,      s.status_type                                         AS parent_status_type
 ,      coalesce(sh.issued_date, sh.planned_effective_date)   AS parent_issued_date
 ,      sh.obsolescence_date
 ,      bh.preferred
 ,      bh.alternative
 ,	    bh.base_quantity        AS parent_quantity
 ,	    sh2.part_no             AS component_part_no
 ,      p.description           AS component_part_no_descr
 ,      bi.ch_1                 AS characteristic_id
 ,      ch.description          AS FUNCTION
 ,      sh2.revision            as component_revision
 ,      bi.plant
 ,      bi.item_number
 ,      bi.quantity
 ,      bi.uom
 FROM specification_header  SH  
 JOIN status                 S ON (S.status    = SH.status and S.status_type IN ('HISTORIC', 'CURRENT') )
 JOIN class3                 C ON (C.class     = SH.class3_id)
 JOIN bom_header            BH ON ( Bh.part_no = SH.part_no AND BH.revision = SH.revision )
 JOIN bom_item              bi ON ( bi.part_no = bh.part_no AND bi.revision = bh.revision AND bi.plant =  bh.plant AND bi.alternative = bh.alternative )                    --BOM-ITEMS RELATED TO SELECTED-PART-NO
 JOIN specification_header SH2 ON ( sh2.part_no = bi.component_part )
 JOIN part                   p on ( sh2.part_no = p.part_no )
 JOIN status                s2 ON ( s2.status  = sh2.status AND s2.status_type IN ('HISTORIC', 'CURRENT') )
 LEFT OUTER JOIN characteristic             ch ON ( ch.characteristic_id = bi.ch_1) 
 LEFT JOIN characteristic_association ca ON ( ca.characteristic    = ch.characteristic_id AND ca.intl = ch.intl )
 LEFT JOIN association                 a ON (  a.association       = ca.association       AND a.intl  = ca.intl  )
 WHERE SH.revision = ( SELECT MAX(sh3.revision)
                      FROM specification_header  sh3
                      JOIN status                 s3 on (s3.status = sh3.status)
                      WHERE sh3.part_no   = SH.part_no
                      AND   s3.status_type IN ('HISTORIC', 'CURRENT')
                      )
 AND   SH2.revision = (select max(sh4.revision) 
                       from specification_header sh4 
					   JOIN status               s4 on s4.status = sh4.status 
					   WHERE sh4.part_no = sh2.part_no 
					   and   s4.status_type IN ('HISTORIC', 'CURRENT') 
					  )
 AND a.description = 'Function'	
 AND sh.part_no = 'ER_DE04-00-215' --'EV_BH165/80R14CLS'  --'EF_H165/80R14CLS'
 --ORDER by sh.part_no, bi.item_number 
;

--ER_DE04-00-215	1	126	CURRENT	10-11-2023 11:35:20		1	1	1	EC_DE04	REKNUMMER DE04	903361	Composite	13	ENS	10	0.215	m²





--*******************************************
--PLY 1 = ER_ME01-90-0540
select * from property p where p.description like '%width%'    
718219	Inner Liner width

--PROPERTY-GROUP = 
701817	Dimensions SFP


--GORDELMATERIAAL
select d.part_no 
,      d.section_id
,      s.description
,      d.sub_section_id
,      d.property_group
,      d.property
,      p.description
,      d.value_s
from specdata d
JOIN section  s on s.section_id = d.section_id
JOIN property p on p.property = d.property
where d.part_no='ER_KE21-25-130STR'  -- 'ER_ME01-90-0540'
and  d.revision = (select max(sh.revision) from specification_header sh where sh.part_no = d.part_no)
--and d.property in (703411)
--and (   d.property_group = 701817
    --and d.property in (703411, 703425, 703424, 703417, 703423, 706448, 703422, 703421, 703544, 703418)
--	)
;
/*
ER_ME01-90-0540	700584	Properties	0	701817	703268	Width	540          --> DEZE HEBBEN WE NODIG
ER_ME01-90-0540	700584	Properties	0	701817	703268	Width	N
ER_ME01-90-0540	700584	Properties	0	701817	703268	Width	-2
ER_ME01-90-0540	700584	Properties	0	701817	703268	Width	2
ER_ME01-90-0540	700584	Properties	0	701817	704688	Angle	90           --> DEZE HEBBEN WE NODIG
ER_ME01-90-0540	700584	Properties	0	701817	704688	Angle	N
ER_ME01-90-0540	700584	Properties	0	701817	704688	Angle	-1
ER_ME01-90-0540	700584	Properties	0	701817	704688	Angle	1
*/


--PROPERTIES PLY = ER_ME01-90-0540	
select sh.part_no
,      sh.revision
,      bh.plant
,      bh.preferred
,      bh.alternative
,      sh.status
,      sh.frame_id
,      sp.section_id
,      s.description section_descr
,      sp.SUB_section_id
,      ss.description subsection_descr
,      sp.property_group
,      pg.description pg_descr
,      sp.property
,      p.description p_descr
,      sps.type
,      sps.ref_id
,      h.header_id
,      pl.field_id
,      sps.display_format
,      l.description      layout_descr
,      h.description      header_descr
,      sp.uom_id 
,	   u.description    AS uom_descr
,      sp.attribute
,	   a.description    AS attribute_descr
,      sp.test_method
,	   tm.description   AS test_method_descr
,      sp.characteristic
,      c.description    AS ch_1_descr
,      sp.ch_2
,	   c2.description   AS ch_2_descr
,      sp.ch_3
,	   c3.description   AS ch_3_descr
,      CASE when pl.field_id = 1  then 'Num_1'
            when pl.field_id = 2  then 'Num_2'
            when pl.field_id = 3  then 'Num_3'
            when pl.field_id = 4  then 'Num_4'
            when pl.field_id = 5  then 'Num_5'
            when pl.field_id = 6  then 'Num_6'
            when pl.field_id = 7  then 'Num_7'
            when pl.field_id = 8  then 'Num_8'
            when pl.field_id = 9  then 'Num_9'
            when pl.field_id = 10 then 'Num_10'
            when pl.field_id = 11 then 'Char_1'
            when pl.field_id = 12 then 'Char_2'
            when pl.field_id = 13 then 'Char_3'
            when pl.field_id = 14 then 'Char_4'
            when pl.field_id = 15 then 'Char_5'
            when pl.field_id = 16 then 'Char_6'
            when pl.field_id = 17 then 'Boolean_1'
            when pl.field_id = 18 then 'Boolean_2'
            when pl.field_id = 19 then 'Boolean_3'
            when pl.field_id = 20 then 'Boolean_4'
            when pl.field_id = 21 then 'Date_1'
            when pl.field_id = 22 then 'Date_2'
            when pl.field_id = 23 then 'UOM_id'
            when pl.field_id = 24 then 'Attribute'
            when pl.field_id = 25 then 'Test method'
            when pl.field_id = 26 then 'Characteristic'
            when pl.field_id = 27 then 'Property'
            when pl.field_id = 30 then 'Ch_2 (Characteristic 2)'
            when pl.field_id = 31 then 'Ch_3 (Characteristic 3)'
            when pl.field_id = 32 then 'Tm_det_1 (Test method detail)'
            when pl.field_id = 33 then 'Tm_det_2 (Test method detail)'
            when pl.field_id = 34 then 'Tm_det_3 (Test method detail)'
            when pl.field_id = 35 then 'Tm_det_4 (Test method detail)'
            when pl.field_id = 40 then 'Info'
            else 'NULL'
       END db_field
,      CASE when pl.field_id = 1  then cast(sp.Num_1 as char(30) )
            when pl.field_id = 2  then cast(sp.Num_2 as char(30) )
            when pl.field_id = 3  then cast(sp.Num_3 as char(30) )
            when pl.field_id = 4  then cast(sp.Num_4 as char(30) )
            when pl.field_id = 5  then cast(sp.Num_5 as char(30) )
            when pl.field_id = 6  then cast(sp.Num_6 as char(30) )
            when pl.field_id = 7  then cast(sp.Num_7 as char(30) )
            when pl.field_id = 8  then cast(sp.Num_8 as char(30) )
            when pl.field_id = 9  then cast(sp.Num_9 as char(30) )
            when pl.field_id = 10  then cast(sp.Num_10 as char(30) )
            when pl.field_id = 11 then sp.Char_1
            when pl.field_id = 12 then sp.Char_2
            when pl.field_id = 13 then sp.Char_3
            when pl.field_id = 14 then sp.Char_4
            when pl.field_id = 15 then sp.Char_5
            when pl.field_id = 16 then sp.Char_6
            when pl.field_id = 17 then sp.Boolean_1
            when pl.field_id = 18 then sp.Boolean_2
            when pl.field_id = 19 then sp.Boolean_3
            when pl.field_id = 20 then sp.Boolean_4
            when pl.field_id = 21 then to_char(sp.Date_1, 'dd-mm-yyyy hh24:mi:ss')
            when pl.field_id = 22 then to_char(sp.Date_2, 'dd-mm-yyyy hh24:mi:ss')
            when pl.field_id = 23 then cast(sp.UOM_id as char(30))
            when pl.field_id = 24 then cast(sp.Attribute as char(30))
            when pl.field_id = 25 then cast(sp.Test_method as char(30))
            when pl.field_id = 26 then cast(sp.Characteristic as char(30))
            when pl.field_id = 27 then cast(sp.Property as char(30) )
            when pl.field_id = 30 then cast(sp.Ch_2 as char(30) ) 
            when pl.field_id = 31 then cast(sp.Ch_3 as char(30) )
            when pl.field_id = 32 then sp.Tm_det_1
            when pl.field_id = 33 then sp.Tm_det_2
            when pl.field_id = 34 then sp.Tm_det_3
            when pl.field_id = 35 then sp.Tm_det_4
            when pl.field_id = 40 then sp.Info  
            else 'NULL'
       END db_field_value
from specification_header      sh
JOIN status                    st   on st.status    = sh.status
JOIN bom_header                bh   on bh.part_no   = sh.part_no  and bh.revision = sh.revision
JOIN specification_prop        sp   on sp.part_no   = sh.part_no  and sh.revision = sp.revision
join specification_section     sps  on sps.part_no  = sp.part_no  and sps.revision = sp.revision and  sps.section_id  = sp.section_id  and sps.sub_section_id = sp.sub_section_id 
JOIN layout                    l    ON l.layout_id  = sps.display_format and l.revision = sps.display_format_rev
JOIN property_layout           pl   ON pl.layout_id = l.layout_id        and pl.revision = l.revision
join header                    h    on h.header_id  = pl.header_id 
JOIN SECTION                   s    ON s.section_id = sp.section_id
JOIN SUB_SECTION               ss   on ss.sub_section_id   = sp.sub_section_id
JOIN PROPERTY_GROUP            pg   ON pg.property_GROUP   = sp.property_group
JOIN PROPERTY                  p    on p.property          = sp.property
LEFT JOIN uom             u ON (pl.field_id = 23 AND u.uom_id             = sp.uom_id)
LEFT JOIN attribute       a ON (pl.field_id = 24 AND a.attribute          = sp.attribute)
LEFT JOIN test_method    tm ON (pl.field_id = 25 AND tm.test_method       = sp.test_method)
LEFT JOIN characteristic c  ON (pl.field_id = 26 AND c.characteristic_id  = sp.characteristic)
LEFT JOIN characteristic c2 ON (pl.field_id = 30 AND c2.characteristic_id = sp.ch_2)
LEFT JOIN characteristic c3 ON (pl.field_id = 31 AND c3.characteristic_id = sp.ch_3)
WHERE   NOT (  (  pl.field_id = 27  AND UPPER(h.description) = 'PROPERTY' )  --or (  pl.field_id = 23  )
	      )	
and   (   sp.part_no = 'ER_ME01-90-0540' )
AND   st.status_type IN ('HISTORIC', 'CURRENT') 
and   sp.revision = (select max(sh2.revision) from specification_header sh2 where sh2.part_no = sp.part_no)
--order by  SH.part_no, SH.frame_id, SP.section_id, SP.sub_section_id, SP.property_group, SP.property
;

/*
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700584	Properties	0	(none)	701817	Dimensions SFP	703268	Width	1	701817	700010	23	702108	IS_Production_B&V_2	UoM	700649	mm	0		0								UOM_id	700649                        
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700584	Properties	0	(none)	701817	Dimensions SFP	704688	Angle	1	701817	700010	23	702108	IS_Production_B&V_2	UoM	701009	°	0		0								UOM_id	701009                        
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	703176	Aging SAP	710529	Aging (minimal)	4	703262	700010	23	702068	IS_Prop_UoM_Num	UoM	700626	hours	0		0								UOM_id	700626                        
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	703176	Aging SAP	710530	Aging (Maximal)	4	703262	700010	23	702068	IS_Prop_UoM_Num	UoM	700627	day	0		0								UOM_id	700627                        
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	703176	Aging SAP	710529	Aging (minimal)	1	703176	700010	23	702068	IS_Prop_UoM_Num	UoM	700626	hours	0		0								UOM_id	700626                        
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	703176	Aging SAP	710530	Aging (Maximal)	1	703176	700010	23	702068	IS_Prop_UoM_Num	UoM	700627	day	0		0								UOM_id	700627                        
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	0	default property group	703262	Weight	4	703262	700010	23	702068	IS_Prop_UoM_Num	UoM			0		0								UOM_id	
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	0	default property group	705428	Article group PG	4	703262	700010	23	702068	IS_Prop_UoM_Num	UoM			0		0		900199						UOM_id	
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	0	default property group	705429	Packaging PG	4	703262	700010	23	702068	IS_Prop_UoM_Num	UoM			0		0		900450						UOM_id	
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	0	default property group	709030	Physical in product	4	703262	700010	23	702068	IS_Prop_UoM_Num	UoM			0		0		900484						UOM_id	
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	0	default property group	710531	Article type	4	703262	700010	23	702068	IS_Prop_UoM_Num	UoM			0		0		900977						UOM_id	
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	0	default property group	703262	Weight	1	703176	700010	23	702068	IS_Prop_UoM_Num	UoM			0		0								UOM_id	
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	0	default property group	705428	Article group PG	1	703176	700010	23	702068	IS_Prop_UoM_Num	UoM			0		0		900199						UOM_id	
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	0	default property group	705429	Packaging PG	1	703176	700010	23	702068	IS_Prop_UoM_Num	UoM			0		0		900450						UOM_id	
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	0	default property group	709030	Physical in product	1	703176	700010	23	702068	IS_Prop_UoM_Num	UoM			0		0		900484						UOM_id	
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	0	default property group	710531	Article type	1	703176	700010	23	702068	IS_Prop_UoM_Num	UoM			0		0		900977						UOM_id	
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	703176	Aging SAP	710529	Aging (minimal)	4	705429	700751	26	701388	IS_PROP_ASS_NUM	Packaging	700626		0		0								Characteristic	
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	703176	Aging SAP	710530	Aging (Maximal)	4	705429	700751	26	701388	IS_PROP_ASS_NUM	Packaging	700627		0		0								Characteristic	
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	0	default property group	703262	Weight	4	705429	700751	26	701388	IS_PROP_ASS_NUM	Packaging			0		0								Characteristic	
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	0	default property group	705428	Article group PG	4	705429	700751	26	701388	IS_PROP_ASS_NUM	Packaging			0		0		900199	L0: GESNEDEN PLY (PERSONEN).      					Characteristic	900199                        
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	0	default property group	705429	Packaging PG	4	705429	700751	26	701388	IS_PROP_ASS_NUM	Packaging			0		0		900450	LN150					Characteristic	900450                        
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	0	default property group	709030	Physical in product	4	705429	700751	26	701388	IS_PROP_ASS_NUM	Packaging			0		0		900484	Yes					Characteristic	900484                        
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	0	default property group	710531	Article type	4	705429	700751	26	701388	IS_PROP_ASS_NUM	Packaging			0		0		900977	I: Halffabrikaten Alternatief					Characteristic	900977                        
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700584	Properties	0	(none)	701817	Dimensions SFP	703268	Width	1	701817	700811	2	702108	IS_Production_B&V_2	- tol	700649		0		0								Num_2	-2                            
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700584	Properties	0	(none)	701817	Dimensions SFP	704688	Angle	1	701817	700811	2	702108	IS_Production_B&V_2	- tol	701009		0		0								Num_2	-1                            
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700584	Properties	0	(none)	701817	Dimensions SFP	703268	Width	1	701817	700812	3	702108	IS_Production_B&V_2	+ tol	700649		0		0								Num_3	2                             
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700584	Properties	0	(none)	701817	Dimensions SFP	704688	Angle	1	701817	700812	3	702108	IS_Production_B&V_2	+ tol	701009		0		0								Num_3	1                             
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700583	Processing	701724	BIAS6	0	default property group	710528	volgnummer	4	710528	700511	1	702968	IS_Prop_Num	Value			0		0								Num_1	10                            
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	703176	Aging SAP	710529	Aging (minimal)	4	710531	700511	26	700929	IS_Single_Value_ASSOC_DF	Value	700626		0		0								Characteristic	
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	703176	Aging SAP	710530	Aging (Maximal)	4	710531	700511	26	700929	IS_Single_Value_ASSOC_DF	Value	700627		0		0								Characteristic	
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	703176	Aging SAP	710529	Aging (minimal)	4	709030	700511	26	700929	IS_Single_Value_ASSOC_DF	Value	700626		0		0								Characteristic	
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	703176	Aging SAP	710530	Aging (Maximal)	4	709030	700511	26	700929	IS_Single_Value_ASSOC_DF	Value	700627		0		0								Characteristic	
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	703176	Aging SAP	710529	Aging (minimal)	4	705428	700511	26	700929	IS_Single_Value_ASSOC_DF	Value	700626		0		0								Characteristic	
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	703176	Aging SAP	710530	Aging (Maximal)	4	705428	700511	26	700929	IS_Single_Value_ASSOC_DF	Value	700627		0		0								Characteristic	
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	703176	Aging SAP	710529	Aging (minimal)	4	703262	700511	1	702068	IS_Prop_UoM_Num	Value	700626		0		0								Num_1	0                             
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	703176	Aging SAP	710530	Aging (Maximal)	4	703262	700511	1	702068	IS_Prop_UoM_Num	Value	700627		0		0								Num_1	30                            
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	703176	Aging SAP	710529	Aging (minimal)	1	703176	700511	1	702068	IS_Prop_UoM_Num	Value	700626		0		0								Num_1	0                             
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	703176	Aging SAP	710530	Aging (Maximal)	1	703176	700511	1	702068	IS_Prop_UoM_Num	Value	700627		0		0								Num_1	30                            
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	0	default property group	703262	Weight	4	710531	700511	26	700929	IS_Single_Value_ASSOC_DF	Value			0		0								Characteristic	
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	0	default property group	705428	Article group PG	4	710531	700511	26	700929	IS_Single_Value_ASSOC_DF	Value			0		0		900199	L0: GESNEDEN PLY (PERSONEN).      					Characteristic	900199                        
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	0	default property group	705429	Packaging PG	4	710531	700511	26	700929	IS_Single_Value_ASSOC_DF	Value			0		0		900450	LN150					Characteristic	900450                        
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	0	default property group	709030	Physical in product	4	710531	700511	26	700929	IS_Single_Value_ASSOC_DF	Value			0		0		900484	Yes					Characteristic	900484                        
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	0	default property group	710531	Article type	4	710531	700511	26	700929	IS_Single_Value_ASSOC_DF	Value			0		0		900977	I: Halffabrikaten Alternatief					Characteristic	900977                        
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	0	default property group	703262	Weight	4	709030	700511	26	700929	IS_Single_Value_ASSOC_DF	Value			0		0								Characteristic	
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	0	default property group	705428	Article group PG	4	709030	700511	26	700929	IS_Single_Value_ASSOC_DF	Value			0		0		900199	L0: GESNEDEN PLY (PERSONEN).      					Characteristic	900199                        
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	0	default property group	705429	Packaging PG	4	709030	700511	26	700929	IS_Single_Value_ASSOC_DF	Value			0		0		900450	LN150					Characteristic	900450                        
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	0	default property group	709030	Physical in product	4	709030	700511	26	700929	IS_Single_Value_ASSOC_DF	Value			0		0		900484	Yes					Characteristic	900484                        
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	0	default property group	710531	Article type	4	709030	700511	26	700929	IS_Single_Value_ASSOC_DF	Value			0		0		900977	I: Halffabrikaten Alternatief					Characteristic	900977                        
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	0	default property group	703262	Weight	4	705428	700511	26	700929	IS_Single_Value_ASSOC_DF	Value			0		0								Characteristic	
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	0	default property group	705428	Article group PG	4	705428	700511	26	700929	IS_Single_Value_ASSOC_DF	Value			0		0		900199	L0: GESNEDEN PLY (PERSONEN).      					Characteristic	900199                        
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	0	default property group	705429	Packaging PG	4	705428	700511	26	700929	IS_Single_Value_ASSOC_DF	Value			0		0		900450	LN150					Characteristic	900450                        
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	0	default property group	709030	Physical in product	4	705428	700511	26	700929	IS_Single_Value_ASSOC_DF	Value			0		0		900484	Yes					Characteristic	900484                        
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	0	default property group	710531	Article type	4	705428	700511	26	700929	IS_Single_Value_ASSOC_DF	Value			0		0		900977	I: Halffabrikaten Alternatief					Characteristic	900977                        
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	0	default property group	703262	Weight	4	703262	700511	1	702068	IS_Prop_UoM_Num	Value			0		0								Num_1	1                             
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	0	default property group	705428	Article group PG	4	703262	700511	1	702068	IS_Prop_UoM_Num	Value			0		0		900199						Num_1	
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	0	default property group	705429	Packaging PG	4	703262	700511	1	702068	IS_Prop_UoM_Num	Value			0		0		900450						Num_1	150                           
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	0	default property group	709030	Physical in product	4	703262	700511	1	702068	IS_Prop_UoM_Num	Value			0		0		900484						Num_1	
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	0	default property group	710531	Article type	4	703262	700511	1	702068	IS_Prop_UoM_Num	Value			0		0		900977						Num_1	
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	0	default property group	703262	Weight	1	703176	700511	1	702068	IS_Prop_UoM_Num	Value			0		0								Num_1	1                             
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	0	default property group	705428	Article group PG	1	703176	700511	1	702068	IS_Prop_UoM_Num	Value			0		0		900199						Num_1	
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	0	default property group	705429	Packaging PG	1	703176	700511	1	702068	IS_Prop_UoM_Num	Value			0		0		900450						Num_1	150                           
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	0	default property group	709030	Physical in product	1	703176	700511	1	702068	IS_Prop_UoM_Num	Value			0		0		900484						Num_1	
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	0	default property group	710531	Article type	1	703176	700511	1	702068	IS_Prop_UoM_Num	Value			0		0		900977						Num_1	
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	703176	Aging SAP	710529	Aging (minimal)	4	705429	701151	1	701388	IS_PROP_ASS_NUM	Amount	700626		0		0								Num_1	0                             
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	703176	Aging SAP	710530	Aging (Maximal)	4	705429	701151	1	701388	IS_PROP_ASS_NUM	Amount	700627		0		0								Num_1	30                            
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	0	default property group	703262	Weight	4	705429	701151	1	701388	IS_PROP_ASS_NUM	Amount			0		0								Num_1	1                             
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	0	default property group	705428	Article group PG	4	705429	701151	1	701388	IS_PROP_ASS_NUM	Amount			0		0		900199						Num_1	
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	0	default property group	705429	Packaging PG	4	705429	701151	1	701388	IS_PROP_ASS_NUM	Amount			0		0		900450						Num_1	150                           
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	0	default property group	709030	Physical in product	4	705429	701151	1	701388	IS_PROP_ASS_NUM	Amount			0		0		900484						Num_1	
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700755	SAP information	0	(none)	0	default property group	710531	Article type	4	705429	701151	1	701388	IS_PROP_ASS_NUM	Amount			0		0		900977						Num_1	
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700584	Properties	0	(none)	701817	Dimensions SFP	703268	Width	1	701817	700498	1	702108	IS_Production_B&V_2	Target	700649		0		0								Num_1	540                           
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700584	Properties	0	(none)	701817	Dimensions SFP	704688	Angle	1	701817	700498	1	702108	IS_Production_B&V_2	Target	701009		0		0								Num_1	90                            
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700584	Properties	0	(none)	701817	Dimensions SFP	703268	Width	1	701817	700501	25	702108	IS_Production_B&V_2	Apollo test code	700649		0		0								Test method	0                             
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700584	Properties	0	(none)	701817	Dimensions SFP	704688	Angle	1	701817	700501	25	702108	IS_Production_B&V_2	Apollo test code	701009		0		0								Test method	0                             
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700584	Properties	0	(none)	701817	Dimensions SFP	703268	Width	1	701817	700503	17	702108	IS_Production_B&V_2	Cr. par.	700649		0		0								Boolean_1	N
ER_ME01-90-0540	5	ENS	1	1	128	E_Ply	700584	Properties	0	(none)	701817	Dimensions SFP	704688	Angle	1	701817	700503	17	702108	IS_Production_B&V_2	Cr. par.	701009		0		0								Boolean_1	N
*/



--select p_descr , db_field_value
--from <view>
--where part_no = ''
--and   property_group = 701817    --dimensions SFP
--and   header_descr = 'target'
--

select * from specification_prop where part_no = 'ER_ME01-90-0540' and property_group = 701817 ;

--BEAD-PROPERTIES  EB_11205AR56S
select sh.part_no
,      sh.revision
,      bh.plant
,      bh.preferred
,      bh.alternative
,      sh.status
,      sh.frame_id
,      sp.section_id
,      s.description section_descr
,      sp.SUB_section_id
,      ss.description subsection_descr
,      sp.property_group
,      pg.description pg_descr
,      sp.property
,      p.description p_descr
,      sps.type
,      sps.ref_id
,      h.header_id
,      pl.field_id
,      sps.display_format
,      l.description      layout_descr
,      h.description      header_descr
,      sp.uom_id 
,	   u.description    AS uom_descr
,      sp.attribute
,	   a.description    AS attribute_descr
,      sp.test_method
,	   tm.description   AS test_method_descr
,      sp.characteristic
,      c.description    AS ch_1_descr
,      sp.ch_2
,	   c2.description   AS ch_2_descr
,      sp.ch_3
,	   c3.description   AS ch_3_descr
,      CASE when pl.field_id = 1  then 'Num_1'
            when pl.field_id = 2  then 'Num_2'
            when pl.field_id = 3  then 'Num_3'
            when pl.field_id = 4  then 'Num_4'
            when pl.field_id = 5  then 'Num_5'
            when pl.field_id = 6  then 'Num_6'
            when pl.field_id = 7  then 'Num_7'
            when pl.field_id = 8  then 'Num_8'
            when pl.field_id = 9  then 'Num_9'
            when pl.field_id = 10 then 'Num_10'
            when pl.field_id = 11 then 'Char_1'
            when pl.field_id = 12 then 'Char_2'
            when pl.field_id = 13 then 'Char_3'
            when pl.field_id = 14 then 'Char_4'
            when pl.field_id = 15 then 'Char_5'
            when pl.field_id = 16 then 'Char_6'
            when pl.field_id = 17 then 'Boolean_1'
            when pl.field_id = 18 then 'Boolean_2'
            when pl.field_id = 19 then 'Boolean_3'
            when pl.field_id = 20 then 'Boolean_4'
            when pl.field_id = 21 then 'Date_1'
            when pl.field_id = 22 then 'Date_2'
            when pl.field_id = 23 then 'UOM_id'
            when pl.field_id = 24 then 'Attribute'
            when pl.field_id = 25 then 'Test method'
            when pl.field_id = 26 then 'Characteristic'
            when pl.field_id = 27 then 'Property'
            when pl.field_id = 30 then 'Ch_2 (Characteristic 2)'
            when pl.field_id = 31 then 'Ch_3 (Characteristic 3)'
            when pl.field_id = 32 then 'Tm_det_1 (Test method detail)'
            when pl.field_id = 33 then 'Tm_det_2 (Test method detail)'
            when pl.field_id = 34 then 'Tm_det_3 (Test method detail)'
            when pl.field_id = 35 then 'Tm_det_4 (Test method detail)'
            when pl.field_id = 40 then 'Info'
            else 'NULL'
       END db_field
,      CASE when pl.field_id = 1  then cast(sp.Num_1 as char(30) )
            when pl.field_id = 2  then cast(sp.Num_2 as char(30) )
            when pl.field_id = 3  then cast(sp.Num_3 as char(30) )
            when pl.field_id = 4  then cast(sp.Num_4 as char(30) )
            when pl.field_id = 5  then cast(sp.Num_5 as char(30) )
            when pl.field_id = 6  then cast(sp.Num_6 as char(30) )
            when pl.field_id = 7  then cast(sp.Num_7 as char(30) )
            when pl.field_id = 8  then cast(sp.Num_8 as char(30) )
            when pl.field_id = 9  then cast(sp.Num_9 as char(30) )
            when pl.field_id = 10  then cast(sp.Num_10 as char(30) )
            when pl.field_id = 11 then sp.Char_1
            when pl.field_id = 12 then sp.Char_2
            when pl.field_id = 13 then sp.Char_3
            when pl.field_id = 14 then sp.Char_4
            when pl.field_id = 15 then sp.Char_5
            when pl.field_id = 16 then sp.Char_6
            when pl.field_id = 17 then sp.Boolean_1
            when pl.field_id = 18 then sp.Boolean_2
            when pl.field_id = 19 then sp.Boolean_3
            when pl.field_id = 20 then sp.Boolean_4
            when pl.field_id = 21 then to_char(sp.Date_1, 'dd-mm-yyyy hh24:mi:ss')
            when pl.field_id = 22 then to_char(sp.Date_2, 'dd-mm-yyyy hh24:mi:ss')
            when pl.field_id = 23 then cast(sp.UOM_id as char(30))
            when pl.field_id = 24 then cast(sp.Attribute as char(30))
            when pl.field_id = 25 then cast(sp.Test_method as char(30))
            when pl.field_id = 26 then cast(sp.Characteristic as char(30))
            when pl.field_id = 27 then cast(sp.Property as char(30) )
            when pl.field_id = 30 then cast(sp.Ch_2 as char(30) ) 
            when pl.field_id = 31 then cast(sp.Ch_3 as char(30) )
            when pl.field_id = 32 then sp.Tm_det_1
            when pl.field_id = 33 then sp.Tm_det_2
            when pl.field_id = 34 then sp.Tm_det_3
            when pl.field_id = 35 then sp.Tm_det_4
            when pl.field_id = 40 then sp.Info  
            else 'NULL'
       END db_field_value
from specification_header      sh
JOIN status                    st   on st.status    = sh.status
JOIN bom_header                bh   on bh.part_no   = sh.part_no  and bh.revision = sh.revision
JOIN specification_prop        sp   on sp.part_no   = sh.part_no  and sh.revision = sp.revision
join specification_section     sps  on sps.part_no  = sp.part_no  and sps.revision = sp.revision and  sps.section_id  = sp.section_id  and sps.sub_section_id = sp.sub_section_id 
JOIN layout                    l    ON l.layout_id  = sps.display_format and l.revision = sps.display_format_rev
JOIN property_layout           pl   ON pl.layout_id = l.layout_id        and pl.revision = l.revision
join header                    h    on h.header_id  = pl.header_id 
JOIN SECTION                   s    ON s.section_id = sp.section_id
JOIN SUB_SECTION               ss   on ss.sub_section_id   = sp.sub_section_id
JOIN PROPERTY_GROUP            pg   ON pg.property_GROUP   = sp.property_group
JOIN PROPERTY                  p    on p.property          = sp.property
LEFT JOIN uom             u ON (pl.field_id = 23 AND u.uom_id             = sp.uom_id)
LEFT JOIN attribute       a ON (pl.field_id = 24 AND a.attribute          = sp.attribute)
LEFT JOIN test_method    tm ON (pl.field_id = 25 AND tm.test_method       = sp.test_method)
LEFT JOIN characteristic c  ON (pl.field_id = 26 AND c.characteristic_id  = sp.characteristic)
LEFT JOIN characteristic c2 ON (pl.field_id = 30 AND c2.characteristic_id = sp.ch_2)
LEFT JOIN characteristic c3 ON (pl.field_id = 31 AND c3.characteristic_id = sp.ch_3)
WHERE   NOT (  (  pl.field_id = 27  AND UPPER(h.description) = 'PROPERTY' )  --or (  pl.field_id = 23  )
	      )	
and   (   sp.part_no = 'EB_11205AR56S' )
AND   st.status_type IN ('HISTORIC', 'CURRENT') 
and   sp.revision = (select max(sh2.revision) from specification_header sh2 where sh2.part_no = sp.part_no)
--order by  SH.part_no, SH.frame_id, SP.section_id, SP.sub_section_id, SP.property_group, SP.property
;

--TREAD PROPERTIES = ET_LV172  = LOOPVLAK SPRINT CLASSIC B166 SB124
select sh.part_no
,      sh.revision
,      bh.plant
,      bh.preferred
,      bh.alternative
,      sh.status
,      sh.frame_id
,      sp.section_id
,      s.description section_descr
,      sp.SUB_section_id
,      ss.description subsection_descr
,      sp.property_group
,      pg.description pg_descr
,      sp.property
,      p.description p_descr
,      sps.type
,      sps.ref_id
,      h.header_id
,      pl.field_id
,      sps.display_format
,      l.description      layout_descr
,      h.description      header_descr
,      sp.uom_id 
,	   u.description    AS uom_descr
,      sp.attribute
,	   a.description    AS attribute_descr
,      sp.test_method
,	   tm.description   AS test_method_descr
,      sp.characteristic
,      c.description    AS ch_1_descr
,      sp.ch_2
,	   c2.description   AS ch_2_descr
,      sp.ch_3
,	   c3.description   AS ch_3_descr
,      CASE when pl.field_id = 1  then 'Num_1'
            when pl.field_id = 2  then 'Num_2'
            when pl.field_id = 3  then 'Num_3'
            when pl.field_id = 4  then 'Num_4'
            when pl.field_id = 5  then 'Num_5'
            when pl.field_id = 6  then 'Num_6'
            when pl.field_id = 7  then 'Num_7'
            when pl.field_id = 8  then 'Num_8'
            when pl.field_id = 9  then 'Num_9'
            when pl.field_id = 10 then 'Num_10'
            when pl.field_id = 11 then 'Char_1'
            when pl.field_id = 12 then 'Char_2'
            when pl.field_id = 13 then 'Char_3'
            when pl.field_id = 14 then 'Char_4'
            when pl.field_id = 15 then 'Char_5'
            when pl.field_id = 16 then 'Char_6'
            when pl.field_id = 17 then 'Boolean_1'
            when pl.field_id = 18 then 'Boolean_2'
            when pl.field_id = 19 then 'Boolean_3'
            when pl.field_id = 20 then 'Boolean_4'
            when pl.field_id = 21 then 'Date_1'
            when pl.field_id = 22 then 'Date_2'
            when pl.field_id = 23 then 'UOM_id'
            when pl.field_id = 24 then 'Attribute'
            when pl.field_id = 25 then 'Test method'
            when pl.field_id = 26 then 'Characteristic'
            when pl.field_id = 27 then 'Property'
            when pl.field_id = 30 then 'Ch_2 (Characteristic 2)'
            when pl.field_id = 31 then 'Ch_3 (Characteristic 3)'
            when pl.field_id = 32 then 'Tm_det_1 (Test method detail)'
            when pl.field_id = 33 then 'Tm_det_2 (Test method detail)'
            when pl.field_id = 34 then 'Tm_det_3 (Test method detail)'
            when pl.field_id = 35 then 'Tm_det_4 (Test method detail)'
            when pl.field_id = 40 then 'Info'
            else 'NULL'
       END db_field
,      CASE when pl.field_id = 1  then cast(sp.Num_1 as char(30) )
            when pl.field_id = 2  then cast(sp.Num_2 as char(30) )
            when pl.field_id = 3  then cast(sp.Num_3 as char(30) )
            when pl.field_id = 4  then cast(sp.Num_4 as char(30) )
            when pl.field_id = 5  then cast(sp.Num_5 as char(30) )
            when pl.field_id = 6  then cast(sp.Num_6 as char(30) )
            when pl.field_id = 7  then cast(sp.Num_7 as char(30) )
            when pl.field_id = 8  then cast(sp.Num_8 as char(30) )
            when pl.field_id = 9  then cast(sp.Num_9 as char(30) )
            when pl.field_id = 10  then cast(sp.Num_10 as char(30) )
            when pl.field_id = 11 then sp.Char_1
            when pl.field_id = 12 then sp.Char_2
            when pl.field_id = 13 then sp.Char_3
            when pl.field_id = 14 then sp.Char_4
            when pl.field_id = 15 then sp.Char_5
            when pl.field_id = 16 then sp.Char_6
            when pl.field_id = 17 then sp.Boolean_1
            when pl.field_id = 18 then sp.Boolean_2
            when pl.field_id = 19 then sp.Boolean_3
            when pl.field_id = 20 then sp.Boolean_4
            when pl.field_id = 21 then to_char(sp.Date_1, 'dd-mm-yyyy hh24:mi:ss')
            when pl.field_id = 22 then to_char(sp.Date_2, 'dd-mm-yyyy hh24:mi:ss')
            when pl.field_id = 23 then cast(sp.UOM_id as char(30))
            when pl.field_id = 24 then cast(sp.Attribute as char(30))
            when pl.field_id = 25 then cast(sp.Test_method as char(30))
            when pl.field_id = 26 then cast(sp.Characteristic as char(30))
            when pl.field_id = 27 then cast(sp.Property as char(30) )
            when pl.field_id = 30 then cast(sp.Ch_2 as char(30) ) 
            when pl.field_id = 31 then cast(sp.Ch_3 as char(30) )
            when pl.field_id = 32 then sp.Tm_det_1
            when pl.field_id = 33 then sp.Tm_det_2
            when pl.field_id = 34 then sp.Tm_det_3
            when pl.field_id = 35 then sp.Tm_det_4
            when pl.field_id = 40 then sp.Info  
            else 'NULL'
       END db_field_value
from specification_header      sh
JOIN status                    st   on st.status    = sh.status
JOIN bom_header                bh   on bh.part_no   = sh.part_no  and bh.revision = sh.revision
JOIN specification_prop        sp   on sp.part_no   = sh.part_no  and sh.revision = sp.revision
join specification_section     sps  on sps.part_no  = sp.part_no  and sps.revision = sp.revision and  sps.section_id  = sp.section_id  and sps.sub_section_id = sp.sub_section_id 
JOIN layout                    l    ON l.layout_id  = sps.display_format and l.revision = sps.display_format_rev
JOIN property_layout           pl   ON pl.layout_id = l.layout_id        and pl.revision = l.revision
join header                    h    on h.header_id  = pl.header_id 
JOIN SECTION                   s    ON s.section_id = sp.section_id
JOIN SUB_SECTION               ss   on ss.sub_section_id   = sp.sub_section_id
JOIN PROPERTY_GROUP            pg   ON pg.property_GROUP   = sp.property_group
JOIN PROPERTY                  p    on p.property          = sp.property
LEFT JOIN uom             u ON (pl.field_id = 23 AND u.uom_id             = sp.uom_id)
LEFT JOIN attribute       a ON (pl.field_id = 24 AND a.attribute          = sp.attribute)
LEFT JOIN test_method    tm ON (pl.field_id = 25 AND tm.test_method       = sp.test_method)
LEFT JOIN characteristic c  ON (pl.field_id = 26 AND c.characteristic_id  = sp.characteristic)
LEFT JOIN characteristic c2 ON (pl.field_id = 30 AND c2.characteristic_id = sp.ch_2)
LEFT JOIN characteristic c3 ON (pl.field_id = 31 AND c3.characteristic_id = sp.ch_3)
WHERE   NOT (  (  pl.field_id = 27  AND UPPER(h.description) = 'PROPERTY' )  --or (  pl.field_id = 23  )
	      )	
and   (   sp.part_no = 'ET_LV172' )
AND   st.status_type IN ('HISTORIC', 'CURRENT') 
and   sp.revision = (select max(sh2.revision) from specification_header sh2 where sh2.part_no = sp.part_no)
--order by  SH.part_no, SH.frame_id, SP.section_id, SP.sub_section_id, SP.property_group, SP.property
;


--bom-components incl functiecode...
 SELECT bi.part_no                                            AS parent_part_no
 ,      bi.revision                                           AS parent_rev
 ,      sh.status                                             AS parent_status
 ,      s.status_type                                         AS parent_status_type
 ,      coalesce(sh.issued_date, sh.planned_effective_date)   AS parent_issued_date
 ,      sh.obsolescence_date
 ,      bh.preferred
 ,      bh.alternative
 ,	    bh.base_quantity        AS parent_quantity
 ,	    sh2.part_no             AS component_part_no
 ,      p.description           AS component_part_no_descr
 ,      bi.ch_1                 AS characteristic_id
 ,      ch.description          AS FUNCTION
 ,      sh2.revision            as component_revision
 ,      bi.plant
 ,      bi.item_number
 ,      bi.quantity
 ,      bi.uom
 FROM specification_header  SH  
 JOIN status                 S ON (S.status    = SH.status and S.status_type IN ('HISTORIC', 'CURRENT') )
 JOIN class3                 C ON (C.class     = SH.class3_id)
 JOIN bom_header            BH ON ( Bh.part_no = SH.part_no AND BH.revision = SH.revision )
 JOIN bom_item              bi ON ( bi.part_no = bh.part_no AND bi.revision = bh.revision AND bi.plant =  bh.plant AND bi.alternative = bh.alternative )                    --BOM-ITEMS RELATED TO SELECTED-PART-NO
 JOIN specification_header SH2 ON ( sh2.part_no = bi.component_part )
 JOIN part                   p on ( sh2.part_no = p.part_no )
 JOIN status                s2 ON ( s2.status  = sh2.status AND s2.status_type IN ('HISTORIC', 'CURRENT') )
 LEFT OUTER JOIN characteristic             ch ON ( ch.characteristic_id = bi.ch_1) 
 LEFT JOIN characteristic_association ca ON ( ca.characteristic    = ch.characteristic_id AND ca.intl = ch.intl )
 LEFT JOIN association                 a ON (  a.association       = ca.association       AND a.intl  = ca.intl  )
 WHERE SH.revision = ( SELECT MAX(sh3.revision)
                      FROM specification_header  sh3
                      JOIN status                 s3 on (s3.status = sh3.status)
                      WHERE sh3.part_no   = SH.part_no
                      AND   s3.status_type IN ('HISTORIC', 'CURRENT')
                      )
 AND   SH2.revision = (select max(sh4.revision) 
                       from specification_header sh4 
					   JOIN status               s4 on s4.status = sh4.status 
					   WHERE sh4.part_no = sh2.part_no 
					   and   s4.status_type IN ('HISTORIC', 'CURRENT') 
					  )
 AND a.description = 'Function'	
 AND sh.part_no = 'ET_LV172' --'EV_BH165/80R14CLS'  --'EF_H165/80R14CLS'
 --ORDER by sh.part_no, bi.item_number 
;
/*
ET_LV172	36	126	CURRENT	30-11-2023 00:00:03		1	2	1	EM_775	FM Tread Summer V/W	903348	Tread compound		52	ENS	20	0.747486	kg
ET_LV172	36	126	CURRENT	30-11-2023 00:00:03		1	2	1	EM_722	Base				903312	Base 1 compound		70	ENS	30	0.158498	kg
ET_LV172	36	126	CURRENT	30-11-2023 00:00:03		1	2	1	EM_722	Base				903314	Base 2 compound		70	ENS	50	0.313147	kg
ET_LV172	36	126	CURRENT	30-11-2023 00:00:03		1	2	1	EM_726	FM Wingtip PCR		903313	Wingtip compound	86	ENS	40	0.097935	kg
*/



--PROPERTIES SIDEWALL = ES_R17Z    SIDEWALL RIGHT
select sh.part_no
,      sh.revision
,      bh.plant
,      bh.preferred
,      bh.alternative
,      sh.status
,      sh.frame_id
,      sp.section_id
,      s.description section_descr
,      sp.SUB_section_id
,      ss.description subsection_descr
,      sp.property_group
,      pg.description pg_descr
,      sp.property
,      p.description p_descr
,      sps.type
,      sps.ref_id
,      h.header_id
,      pl.field_id
,      sps.display_format
,      l.description      layout_descr
,      h.description      header_descr
,      sp.uom_id 
,	   u.description    AS uom_descr
,      sp.attribute
,	   a.description    AS attribute_descr
,      sp.test_method
,	   tm.description   AS test_method_descr
,      sp.characteristic
,      c.description    AS ch_1_descr
,      sp.ch_2
,	   c2.description   AS ch_2_descr
,      sp.ch_3
,	   c3.description   AS ch_3_descr
,      CASE when pl.field_id = 1  then 'Num_1'
            when pl.field_id = 2  then 'Num_2'
            when pl.field_id = 3  then 'Num_3'
            when pl.field_id = 4  then 'Num_4'
            when pl.field_id = 5  then 'Num_5'
            when pl.field_id = 6  then 'Num_6'
            when pl.field_id = 7  then 'Num_7'
            when pl.field_id = 8  then 'Num_8'
            when pl.field_id = 9  then 'Num_9'
            when pl.field_id = 10 then 'Num_10'
            when pl.field_id = 11 then 'Char_1'
            when pl.field_id = 12 then 'Char_2'
            when pl.field_id = 13 then 'Char_3'
            when pl.field_id = 14 then 'Char_4'
            when pl.field_id = 15 then 'Char_5'
            when pl.field_id = 16 then 'Char_6'
            when pl.field_id = 17 then 'Boolean_1'
            when pl.field_id = 18 then 'Boolean_2'
            when pl.field_id = 19 then 'Boolean_3'
            when pl.field_id = 20 then 'Boolean_4'
            when pl.field_id = 21 then 'Date_1'
            when pl.field_id = 22 then 'Date_2'
            when pl.field_id = 23 then 'UOM_id'
            when pl.field_id = 24 then 'Attribute'
            when pl.field_id = 25 then 'Test method'
            when pl.field_id = 26 then 'Characteristic'
            when pl.field_id = 27 then 'Property'
            when pl.field_id = 30 then 'Ch_2 (Characteristic 2)'
            when pl.field_id = 31 then 'Ch_3 (Characteristic 3)'
            when pl.field_id = 32 then 'Tm_det_1 (Test method detail)'
            when pl.field_id = 33 then 'Tm_det_2 (Test method detail)'
            when pl.field_id = 34 then 'Tm_det_3 (Test method detail)'
            when pl.field_id = 35 then 'Tm_det_4 (Test method detail)'
            when pl.field_id = 40 then 'Info'
            else 'NULL'
       END db_field
,      CASE when pl.field_id = 1  then cast(sp.Num_1 as char(30) )
            when pl.field_id = 2  then cast(sp.Num_2 as char(30) )
            when pl.field_id = 3  then cast(sp.Num_3 as char(30) )
            when pl.field_id = 4  then cast(sp.Num_4 as char(30) )
            when pl.field_id = 5  then cast(sp.Num_5 as char(30) )
            when pl.field_id = 6  then cast(sp.Num_6 as char(30) )
            when pl.field_id = 7  then cast(sp.Num_7 as char(30) )
            when pl.field_id = 8  then cast(sp.Num_8 as char(30) )
            when pl.field_id = 9  then cast(sp.Num_9 as char(30) )
            when pl.field_id = 10  then cast(sp.Num_10 as char(30) )
            when pl.field_id = 11 then sp.Char_1
            when pl.field_id = 12 then sp.Char_2
            when pl.field_id = 13 then sp.Char_3
            when pl.field_id = 14 then sp.Char_4
            when pl.field_id = 15 then sp.Char_5
            when pl.field_id = 16 then sp.Char_6
            when pl.field_id = 17 then sp.Boolean_1
            when pl.field_id = 18 then sp.Boolean_2
            when pl.field_id = 19 then sp.Boolean_3
            when pl.field_id = 20 then sp.Boolean_4
            when pl.field_id = 21 then to_char(sp.Date_1, 'dd-mm-yyyy hh24:mi:ss')
            when pl.field_id = 22 then to_char(sp.Date_2, 'dd-mm-yyyy hh24:mi:ss')
            when pl.field_id = 23 then cast(sp.UOM_id as char(30))
            when pl.field_id = 24 then cast(sp.Attribute as char(30))
            when pl.field_id = 25 then cast(sp.Test_method as char(30))
            when pl.field_id = 26 then cast(sp.Characteristic as char(30))
            when pl.field_id = 27 then cast(sp.Property as char(30) )
            when pl.field_id = 30 then cast(sp.Ch_2 as char(30) ) 
            when pl.field_id = 31 then cast(sp.Ch_3 as char(30) )
            when pl.field_id = 32 then sp.Tm_det_1
            when pl.field_id = 33 then sp.Tm_det_2
            when pl.field_id = 34 then sp.Tm_det_3
            when pl.field_id = 35 then sp.Tm_det_4
            when pl.field_id = 40 then sp.Info  
            else 'NULL'
       END db_field_value
from specification_header      sh
JOIN status                    st   on st.status    = sh.status
JOIN bom_header                bh   on bh.part_no   = sh.part_no  and bh.revision = sh.revision
JOIN specification_prop        sp   on sp.part_no   = sh.part_no  and sh.revision = sp.revision
join specification_section     sps  on sps.part_no  = sp.part_no  and sps.revision = sp.revision and  sps.section_id  = sp.section_id  and sps.sub_section_id = sp.sub_section_id 
JOIN layout                    l    ON l.layout_id  = sps.display_format and l.revision = sps.display_format_rev
JOIN property_layout           pl   ON pl.layout_id = l.layout_id        and pl.revision = l.revision
join header                    h    on h.header_id  = pl.header_id 
JOIN SECTION                   s    ON s.section_id = sp.section_id
JOIN SUB_SECTION               ss   on ss.sub_section_id   = sp.sub_section_id
JOIN PROPERTY_GROUP            pg   ON pg.property_GROUP   = sp.property_group
JOIN PROPERTY                  p    on p.property          = sp.property
LEFT JOIN uom             u ON (pl.field_id = 23 AND u.uom_id             = sp.uom_id)
LEFT JOIN attribute       a ON (pl.field_id = 24 AND a.attribute          = sp.attribute)
LEFT JOIN test_method    tm ON (pl.field_id = 25 AND tm.test_method       = sp.test_method)
LEFT JOIN characteristic c  ON (pl.field_id = 26 AND c.characteristic_id  = sp.characteristic)
LEFT JOIN characteristic c2 ON (pl.field_id = 30 AND c2.characteristic_id = sp.ch_2)
LEFT JOIN characteristic c3 ON (pl.field_id = 31 AND c3.characteristic_id = sp.ch_3)
WHERE   NOT (  (  pl.field_id = 27  AND UPPER(h.description) = 'PROPERTY' )  --or (  pl.field_id = 23  )
	      )	
and   (   sp.part_no = 'ES_R17Z' )
AND   st.status_type IN ('HISTORIC', 'CURRENT') 
and   sp.revision = (select max(sh2.revision) from specification_header sh2 where sh2.part_no = sp.part_no)
--order by  SH.part_no, SH.frame_id, SP.section_id, SP.sub_section_id, SP.property_group, SP.property
;
/*
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701636	Extrudate characteristics	705788	Area	1	701576	700010	23	701828	IS_EXTR_COORDINATES	UoM	700579	mm²	0										UOM_id	700579                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701636	Extrudate characteristics	705788	Area	1	702062	700010	23	702068	IS_Prop_UoM_Num	UoM	700579	mm²	0										UOM_id	700579                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701636	Extrudate characteristics	705788	Area	1	701636	700010	23	701848	IS_EXTR_AREA	UoM	700579	mm²	0										UOM_id	700579                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702062	Tread characteristics	707029	Triplex angle ß	1	701576	700010	23	701828	IS_EXTR_COORDINATES	UoM	701009	°	0										UOM_id	701009                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702062	Tread characteristics	707029	Triplex angle ß	1	702062	700010	23	702068	IS_Prop_UoM_Num	UoM	701009	°	0										UOM_id	701009                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702062	Tread characteristics	707029	Triplex angle ß	1	701636	700010	23	701848	IS_EXTR_AREA	UoM	701009	°	0										UOM_id	701009                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	703411	Building method	1	701576	700010	23	701828	IS_EXTR_COORDINATES	UoM			0				900649						UOM_id	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	707128	Contour	1	701576	700010	23	701828	IS_EXTR_COORDINATES	UoM			0				900651						UOM_id	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	707131	Version	1	701576	700010	23	701828	IS_EXTR_COORDINATES	UoM			0				900515						UOM_id	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	703411	Building method	1	702062	700010	23	702068	IS_Prop_UoM_Num	UoM			0				900649						UOM_id	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	707128	Contour	1	702062	700010	23	702068	IS_Prop_UoM_Num	UoM			0				900651						UOM_id	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	707131	Version	1	702062	700010	23	702068	IS_Prop_UoM_Num	UoM			0				900515						UOM_id	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	703411	Building method	1	701636	700010	23	701848	IS_EXTR_AREA	UoM			0				900649						UOM_id	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	707128	Contour	1	701636	700010	23	701848	IS_EXTR_AREA	UoM			0				900651						UOM_id	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	707131	Version	1	701636	700010	23	701848	IS_EXTR_AREA	UoM			0				900515						UOM_id	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705708	Coordinate 00	1	701576	700010	23	701828	IS_EXTR_COORDINATES	UoM	700649	mm	0										UOM_id	700649                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705709	Coordinate 01	1	701576	700010	23	701828	IS_EXTR_COORDINATES	UoM	700649	mm	0										UOM_id	700649                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705710	Coordinate 02	1	701576	700010	23	701828	IS_EXTR_COORDINATES	UoM	700649	mm	0										UOM_id	700649                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705711	Coordinate 03	1	701576	700010	23	701828	IS_EXTR_COORDINATES	UoM	700649	mm	0										UOM_id	700649                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705712	Coordinate 04	1	701576	700010	23	701828	IS_EXTR_COORDINATES	UoM	700649	mm	0										UOM_id	700649                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705713	Coordinate 05	1	701576	700010	23	701828	IS_EXTR_COORDINATES	UoM	700649	mm	0										UOM_id	700649                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705714	Coordinate 06	1	701576	700010	23	701828	IS_EXTR_COORDINATES	UoM	700649	mm	0										UOM_id	700649                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705715	Coordinate 07	1	701576	700010	23	701828	IS_EXTR_COORDINATES	UoM	700649	mm	0										UOM_id	700649                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705716	Coordinate 08	1	701576	700010	23	701828	IS_EXTR_COORDINATES	UoM	700649	mm	0										UOM_id	700649                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705717	Coordinate 09	1	701576	700010	23	701828	IS_EXTR_COORDINATES	UoM	700649	mm	0										UOM_id	700649                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705718	Coordinate 10	1	701576	700010	23	701828	IS_EXTR_COORDINATES	UoM	700649	mm	0										UOM_id	700649                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705719	Coordinate 11	1	701576	700010	23	701828	IS_EXTR_COORDINATES	UoM	700649	mm	0										UOM_id	700649                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705720	Coordinate 12	1	701576	700010	23	701828	IS_EXTR_COORDINATES	UoM	700649	mm	0										UOM_id	700649                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705721	Coordinate 13	1	701576	700010	23	701828	IS_EXTR_COORDINATES	UoM	700649	mm	0										UOM_id	700649                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705708	Coordinate 00	1	702062	700010	23	702068	IS_Prop_UoM_Num	UoM	700649	mm	0										UOM_id	700649                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705709	Coordinate 01	1	702062	700010	23	702068	IS_Prop_UoM_Num	UoM	700649	mm	0										UOM_id	700649                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705710	Coordinate 02	1	702062	700010	23	702068	IS_Prop_UoM_Num	UoM	700649	mm	0										UOM_id	700649                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705711	Coordinate 03	1	702062	700010	23	702068	IS_Prop_UoM_Num	UoM	700649	mm	0										UOM_id	700649                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705712	Coordinate 04	1	702062	700010	23	702068	IS_Prop_UoM_Num	UoM	700649	mm	0										UOM_id	700649                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705713	Coordinate 05	1	702062	700010	23	702068	IS_Prop_UoM_Num	UoM	700649	mm	0										UOM_id	700649                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705714	Coordinate 06	1	702062	700010	23	702068	IS_Prop_UoM_Num	UoM	700649	mm	0										UOM_id	700649                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705715	Coordinate 07	1	702062	700010	23	702068	IS_Prop_UoM_Num	UoM	700649	mm	0										UOM_id	700649                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705716	Coordinate 08	1	702062	700010	23	702068	IS_Prop_UoM_Num	UoM	700649	mm	0										UOM_id	700649                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705717	Coordinate 09	1	702062	700010	23	702068	IS_Prop_UoM_Num	UoM	700649	mm	0										UOM_id	700649                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705718	Coordinate 10	1	702062	700010	23	702068	IS_Prop_UoM_Num	UoM	700649	mm	0										UOM_id	700649                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705719	Coordinate 11	1	702062	700010	23	702068	IS_Prop_UoM_Num	UoM	700649	mm	0										UOM_id	700649                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705720	Coordinate 12	1	702062	700010	23	702068	IS_Prop_UoM_Num	UoM	700649	mm	0										UOM_id	700649                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705721	Coordinate 13	1	702062	700010	23	702068	IS_Prop_UoM_Num	UoM	700649	mm	0										UOM_id	700649                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705708	Coordinate 00	1	701636	700010	23	701848	IS_EXTR_AREA	UoM	700649	mm	0										UOM_id	700649                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705709	Coordinate 01	1	701636	700010	23	701848	IS_EXTR_AREA	UoM	700649	mm	0										UOM_id	700649                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705710	Coordinate 02	1	701636	700010	23	701848	IS_EXTR_AREA	UoM	700649	mm	0										UOM_id	700649                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705711	Coordinate 03	1	701636	700010	23	701848	IS_EXTR_AREA	UoM	700649	mm	0										UOM_id	700649                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705712	Coordinate 04	1	701636	700010	23	701848	IS_EXTR_AREA	UoM	700649	mm	0										UOM_id	700649                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705713	Coordinate 05	1	701636	700010	23	701848	IS_EXTR_AREA	UoM	700649	mm	0										UOM_id	700649                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705714	Coordinate 06	1	701636	700010	23	701848	IS_EXTR_AREA	UoM	700649	mm	0										UOM_id	700649                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705715	Coordinate 07	1	701636	700010	23	701848	IS_EXTR_AREA	UoM	700649	mm	0										UOM_id	700649                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705716	Coordinate 08	1	701636	700010	23	701848	IS_EXTR_AREA	UoM	700649	mm	0										UOM_id	700649                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705717	Coordinate 09	1	701636	700010	23	701848	IS_EXTR_AREA	UoM	700649	mm	0										UOM_id	700649                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705718	Coordinate 10	1	701636	700010	23	701848	IS_EXTR_AREA	UoM	700649	mm	0										UOM_id	700649                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705719	Coordinate 11	1	701636	700010	23	701848	IS_EXTR_AREA	UoM	700649	mm	0										UOM_id	700649                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705720	Coordinate 12	1	701636	700010	23	701848	IS_EXTR_AREA	UoM	700649	mm	0										UOM_id	700649                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705721	Coordinate 13	1	701636	700010	23	701848	IS_EXTR_AREA	UoM	700649	mm	0										UOM_id	700649                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	0	default property group	705789	Extrudate construction	1	701576	700010	23	701828	IS_EXTR_COORDINATES	UoM			0				900534						UOM_id	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	0	default property group	705789	Extrudate construction	1	702062	700010	23	702068	IS_Prop_UoM_Num	UoM			0				900534						UOM_id	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	0	default property group	705789	Extrudate construction	1	701636	700010	23	701848	IS_EXTR_AREA	UoM			0				900534						UOM_id	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	701598	Main extrudate dimensions	705782	Total width	1	702063	700010	23	702128	IS_Production_B&V_3	UoM	700649	mm	0		0								UOM_id	700649                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	701598	Main extrudate dimensions	705783	Transition sidewall - rimcushion	1	702063	700010	23	702128	IS_Production_B&V_3	UoM	700649	mm	0		0								UOM_id	700649                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	701598	Main extrudate dimensions	712308	Rimcushion width	1	702063	700010	23	702128	IS_Production_B&V_3	UoM	700649	mm	0		0								UOM_id	700649                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	701598	Main extrudate dimensions	705782	Total width	1	701598	700010	23	702108	IS_Production_B&V_2	UoM	700649	mm	0		0								UOM_id	700649                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	701598	Main extrudate dimensions	705783	Transition sidewall - rimcushion	1	701598	700010	23	702108	IS_Production_B&V_2	UoM	700649	mm	0		0								UOM_id	700649                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	701598	Main extrudate dimensions	712308	Rimcushion width	1	701598	700010	23	702108	IS_Production_B&V_2	UoM	700649	mm	0		0								UOM_id	700649                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	702063	Typical weight	705784	Typical weight	1	702063	700010	23	702128	IS_Production_B&V_3	UoM	700573	kg	0		0								UOM_id	700573                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	702063	Typical weight	708868	Mass / meter	1	702063	700010	23	702128	IS_Production_B&V_3	UoM	701469	kg/m	0		0								UOM_id	701469                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	702063	Typical weight	705784	Typical weight	1	701598	700010	23	702108	IS_Production_B&V_2	UoM	700573	kg	0		0								UOM_id	700573                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	702063	Typical weight	708868	Mass / meter	1	701598	700010	23	702108	IS_Production_B&V_2	UoM	701469	kg/m	0		0								UOM_id	701469                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	703176	Aging SAP	710529	Aging (minimal)	4	703262	700010	23	702068	IS_Prop_UoM_Num	UoM	700626	hours	0										UOM_id	700626                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	703176	Aging SAP	710530	Aging (Maximal)	4	703262	700010	23	702068	IS_Prop_UoM_Num	UoM	700627	day	0										UOM_id	700627                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	703176	Aging SAP	710529	Aging (minimal)	1	703176	700010	23	702068	IS_Prop_UoM_Num	UoM	700626	hours	0										UOM_id	700626                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	703176	Aging SAP	710530	Aging (Maximal)	1	703176	700010	23	702068	IS_Prop_UoM_Num	UoM	700627	day	0										UOM_id	700627                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	0	default property group	703262	Weight	4	703262	700010	23	702068	IS_Prop_UoM_Num	UoM			0										UOM_id	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	0	default property group	705428	Article group PG	4	703262	700010	23	702068	IS_Prop_UoM_Num	UoM			0				900202						UOM_id	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	0	default property group	705429	Packaging PG	4	703262	700010	23	702068	IS_Prop_UoM_Num	UoM			0				903339						UOM_id	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	0	default property group	709030	Physical in product	4	703262	700010	23	702068	IS_Prop_UoM_Num	UoM			0				900484						UOM_id	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	0	default property group	710531	Article type	4	703262	700010	23	702068	IS_Prop_UoM_Num	UoM			0				900977						UOM_id	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	0	default property group	703262	Weight	1	703176	700010	23	702068	IS_Prop_UoM_Num	UoM			0										UOM_id	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	0	default property group	705428	Article group PG	1	703176	700010	23	702068	IS_Prop_UoM_Num	UoM			0				900202						UOM_id	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	0	default property group	705429	Packaging PG	1	703176	700010	23	702068	IS_Prop_UoM_Num	UoM			0				903339						UOM_id	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	0	default property group	709030	Physical in product	1	703176	700010	23	702068	IS_Prop_UoM_Num	UoM			0				900484						UOM_id	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	0	default property group	710531	Article type	1	703176	700010	23	702068	IS_Prop_UoM_Num	UoM			0				900977						UOM_id	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700583	Processing	702482	TSE	701570	Tooling	705785	Die	4	705384	700041	26	701488	IS_BOM_alternative	Plant			0										Characteristic	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700583	Processing	702482	TSE	701570	Tooling	705786	Preformer	4	705384	700041	26	701488	IS_BOM_alternative	Plant			0										Characteristic	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700583	Processing	702482	TSE	0	default property group	705384	BOM alternative	4	705384	700041	26	701488	IS_BOM_alternative	Plant			0				900476	Ens	900477		900478		Characteristic	900476                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700583	Processing	702482	TSE	0	default property group	710528	volgnummer	4	705384	700041	26	701488	IS_BOM_alternative	Plant			0										Characteristic	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	703176	Aging SAP	710529	Aging (minimal)	4	705429	700751	26	701388	IS_PROP_ASS_NUM	Packaging	700626		0										Characteristic	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	703176	Aging SAP	710530	Aging (Maximal)	4	705429	700751	26	701388	IS_PROP_ASS_NUM	Packaging	700627		0										Characteristic	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	0	default property group	703262	Weight	4	705429	700751	26	701388	IS_PROP_ASS_NUM	Packaging			0										Characteristic	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	0	default property group	705428	Article group PG	4	705429	700751	26	701388	IS_PROP_ASS_NUM	Packaging			0				900202	L5: ZIJKANTEN PERSONEN + INSERTS  					Characteristic	900202                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	0	default property group	705429	Packaging PG	4	705429	700751	26	701388	IS_PROP_ASS_NUM	Packaging			0				903339	CASZY					Characteristic	903339                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	0	default property group	709030	Physical in product	4	705429	700751	26	701388	IS_PROP_ASS_NUM	Packaging			0				900484	Yes					Characteristic	900484                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	0	default property group	710531	Article type	4	705429	700751	26	701388	IS_PROP_ASS_NUM	Packaging			0				900977	I: Halffabrikaten Alternatief					Characteristic	900977                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700583	Processing	702482	TSE	701570	Tooling	705785	Die	4	705384	700771	30	701488	IS_BOM_alternative	Usage			0										Ch_2 (Characteristic 2)	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700583	Processing	702482	TSE	701570	Tooling	705786	Preformer	4	705384	700771	30	701488	IS_BOM_alternative	Usage			0										Ch_2 (Characteristic 2)	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700583	Processing	702482	TSE	0	default property group	705384	BOM alternative	4	705384	700771	30	701488	IS_BOM_alternative	Usage			0				900476		900477	Prod	900478		Ch_2 (Characteristic 2)	900477                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700583	Processing	702482	TSE	0	default property group	710528	volgnummer	4	705384	700771	30	701488	IS_BOM_alternative	Usage			0										Ch_2 (Characteristic 2)	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700583	Processing	702482	TSE	701570	Tooling	705785	Die	4	705384	700772	31	701488	IS_BOM_alternative	Alternative			0										Ch_3 (Characteristic 3)	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700583	Processing	702482	TSE	701570	Tooling	705786	Preformer	4	705384	700772	31	701488	IS_BOM_alternative	Alternative			0										Ch_3 (Characteristic 3)	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700583	Processing	702482	TSE	0	default property group	705384	BOM alternative	4	705384	700772	31	701488	IS_BOM_alternative	Alternative			0				900476		900477		900478	1	Ch_3 (Characteristic 3)	900478                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700583	Processing	702482	TSE	0	default property group	710528	volgnummer	4	705384	700772	31	701488	IS_BOM_alternative	Alternative			0										Ch_3 (Characteristic 3)	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	701598	Main extrudate dimensions	705782	Total width	1	701598	700811	2	702108	IS_Production_B&V_2	- tol	700649		0		0								Num_2	-3.5                          
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	701598	Main extrudate dimensions	705783	Transition sidewall - rimcushion	1	701598	700811	2	702108	IS_Production_B&V_2	- tol	700649		0		0								Num_2	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	701598	Main extrudate dimensions	712308	Rimcushion width	1	701598	700811	2	702108	IS_Production_B&V_2	- tol	700649		0		0								Num_2	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	702063	Typical weight	705784	Typical weight	1	701598	700811	2	702108	IS_Production_B&V_2	- tol	700573		0		0								Num_2	-7                            
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	702063	Typical weight	708868	Mass / meter	1	701598	700811	2	702108	IS_Production_B&V_2	- tol	701469		0		0								Num_2	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	701598	Main extrudate dimensions	705782	Total width	1	701598	700812	3	702108	IS_Production_B&V_2	+ tol	700649		0		0								Num_3	3.5                           
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	701598	Main extrudate dimensions	705783	Transition sidewall - rimcushion	1	701598	700812	3	702108	IS_Production_B&V_2	+ tol	700649		0		0								Num_3	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	701598	Main extrudate dimensions	712308	Rimcushion width	1	701598	700812	3	702108	IS_Production_B&V_2	+ tol	700649		0		0								Num_3	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	702063	Typical weight	705784	Typical weight	1	701598	700812	3	702108	IS_Production_B&V_2	+ tol	700573		0		0								Num_3	7                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	702063	Typical weight	708868	Mass / meter	1	701598	700812	3	702108	IS_Production_B&V_2	+ tol	701469		0		0								Num_3	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701636	Extrudate characteristics	705788	Area	1	702060	700511	26	701769	IS_Single_ASSOC_40_DF	Value	700579		0										Characteristic	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701636	Extrudate characteristics	705788	Area	4	705789	700511	26	700929	IS_Single_Value_ASSOC_DF	Value	700579		0										Characteristic	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701636	Extrudate characteristics	705788	Area	1	701576	700511	27	701828	IS_EXTR_COORDINATES	Value	700579		0										Property	705788                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701636	Extrudate characteristics	705788	Area	1	702062	700511	1	702068	IS_Prop_UoM_Num	Value	700579		0										Num_1	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701636	Extrudate characteristics	705788	Area	1	701636	700511	27	701848	IS_EXTR_AREA	Value	700579		0										Property	705788                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702062	Tread characteristics	707029	Triplex angle ß	1	702060	700511	26	701769	IS_Single_ASSOC_40_DF	Value	701009		0										Characteristic	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702062	Tread characteristics	707029	Triplex angle ß	4	705789	700511	26	700929	IS_Single_Value_ASSOC_DF	Value	701009		0										Characteristic	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702062	Tread characteristics	707029	Triplex angle ß	1	701576	700511	27	701828	IS_EXTR_COORDINATES	Value	701009		0										Property	707029                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702062	Tread characteristics	707029	Triplex angle ß	1	702062	700511	1	702068	IS_Prop_UoM_Num	Value	701009		0										Num_1	9.7                           
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702062	Tread characteristics	707029	Triplex angle ß	1	701636	700511	27	701848	IS_EXTR_AREA	Value	701009		0										Property	707029                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	703411	Building method	1	702060	700511	26	701769	IS_Single_ASSOC_40_DF	Value			0				900649	HAPBM					Characteristic	900649                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	707128	Contour	1	702060	700511	26	701769	IS_Single_ASSOC_40_DF	Value			0				900651	B contour					Characteristic	900651                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	707131	Version	1	702060	700511	26	701769	IS_Single_ASSOC_40_DF	Value			0				900515	Sportrac 2					Characteristic	900515                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	703411	Building method	4	705789	700511	26	700929	IS_Single_Value_ASSOC_DF	Value			0				900649	HAPBM					Characteristic	900649                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	707128	Contour	4	705789	700511	26	700929	IS_Single_Value_ASSOC_DF	Value			0				900651	B contour					Characteristic	900651                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	707131	Version	4	705789	700511	26	700929	IS_Single_Value_ASSOC_DF	Value			0				900515	Sportrac 2					Characteristic	900515                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	703411	Building method	1	701576	700511	27	701828	IS_EXTR_COORDINATES	Value			0				900649						Property	703411                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	707128	Contour	1	701576	700511	27	701828	IS_EXTR_COORDINATES	Value			0				900651						Property	707128                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	707131	Version	1	701576	700511	27	701828	IS_EXTR_COORDINATES	Value			0				900515						Property	707131                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	703411	Building method	1	702062	700511	1	702068	IS_Prop_UoM_Num	Value			0				900649						Num_1	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	707128	Contour	1	702062	700511	1	702068	IS_Prop_UoM_Num	Value			0				900651						Num_1	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	707131	Version	1	702062	700511	1	702068	IS_Prop_UoM_Num	Value			0				900515						Num_1	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	703411	Building method	1	701636	700511	27	701848	IS_EXTR_AREA	Value			0				900649						Property	703411                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	707128	Contour	1	701636	700511	27	701848	IS_EXTR_AREA	Value			0				900651						Property	707128                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	707131	Version	1	701636	700511	27	701848	IS_EXTR_AREA	Value			0				900515						Property	707131                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705708	Coordinate 00	1	702060	700511	26	701769	IS_Single_ASSOC_40_DF	Value	700649		0										Characteristic	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705709	Coordinate 01	1	702060	700511	26	701769	IS_Single_ASSOC_40_DF	Value	700649		0										Characteristic	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705710	Coordinate 02	1	702060	700511	26	701769	IS_Single_ASSOC_40_DF	Value	700649		0										Characteristic	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705711	Coordinate 03	1	702060	700511	26	701769	IS_Single_ASSOC_40_DF	Value	700649		0										Characteristic	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705712	Coordinate 04	1	702060	700511	26	701769	IS_Single_ASSOC_40_DF	Value	700649		0										Characteristic	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705713	Coordinate 05	1	702060	700511	26	701769	IS_Single_ASSOC_40_DF	Value	700649		0										Characteristic	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705714	Coordinate 06	1	702060	700511	26	701769	IS_Single_ASSOC_40_DF	Value	700649		0										Characteristic	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705715	Coordinate 07	1	702060	700511	26	701769	IS_Single_ASSOC_40_DF	Value	700649		0										Characteristic	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705716	Coordinate 08	1	702060	700511	26	701769	IS_Single_ASSOC_40_DF	Value	700649		0										Characteristic	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705717	Coordinate 09	1	702060	700511	26	701769	IS_Single_ASSOC_40_DF	Value	700649		0										Characteristic	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705718	Coordinate 10	1	702060	700511	26	701769	IS_Single_ASSOC_40_DF	Value	700649		0										Characteristic	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705719	Coordinate 11	1	702060	700511	26	701769	IS_Single_ASSOC_40_DF	Value	700649		0										Characteristic	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705720	Coordinate 12	1	702060	700511	26	701769	IS_Single_ASSOC_40_DF	Value	700649		0										Characteristic	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705721	Coordinate 13	1	702060	700511	26	701769	IS_Single_ASSOC_40_DF	Value	700649		0										Characteristic	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705708	Coordinate 00	4	705789	700511	26	700929	IS_Single_Value_ASSOC_DF	Value	700649		0										Characteristic	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705709	Coordinate 01	4	705789	700511	26	700929	IS_Single_Value_ASSOC_DF	Value	700649		0										Characteristic	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705710	Coordinate 02	4	705789	700511	26	700929	IS_Single_Value_ASSOC_DF	Value	700649		0										Characteristic	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705711	Coordinate 03	4	705789	700511	26	700929	IS_Single_Value_ASSOC_DF	Value	700649		0										Characteristic	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705712	Coordinate 04	4	705789	700511	26	700929	IS_Single_Value_ASSOC_DF	Value	700649		0										Characteristic	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705713	Coordinate 05	4	705789	700511	26	700929	IS_Single_Value_ASSOC_DF	Value	700649		0										Characteristic	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705714	Coordinate 06	4	705789	700511	26	700929	IS_Single_Value_ASSOC_DF	Value	700649		0										Characteristic	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705715	Coordinate 07	4	705789	700511	26	700929	IS_Single_Value_ASSOC_DF	Value	700649		0										Characteristic	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705716	Coordinate 08	4	705789	700511	26	700929	IS_Single_Value_ASSOC_DF	Value	700649		0										Characteristic	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705717	Coordinate 09	4	705789	700511	26	700929	IS_Single_Value_ASSOC_DF	Value	700649		0										Characteristic	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705718	Coordinate 10	4	705789	700511	26	700929	IS_Single_Value_ASSOC_DF	Value	700649		0										Characteristic	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705719	Coordinate 11	4	705789	700511	26	700929	IS_Single_Value_ASSOC_DF	Value	700649		0										Characteristic	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705720	Coordinate 12	4	705789	700511	26	700929	IS_Single_Value_ASSOC_DF	Value	700649		0										Characteristic	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705721	Coordinate 13	4	705789	700511	26	700929	IS_Single_Value_ASSOC_DF	Value	700649		0										Characteristic	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705708	Coordinate 00	1	701576	700511	27	701828	IS_EXTR_COORDINATES	Value	700649		0										Property	705708                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705709	Coordinate 01	1	701576	700511	27	701828	IS_EXTR_COORDINATES	Value	700649		0										Property	705709                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705710	Coordinate 02	1	701576	700511	27	701828	IS_EXTR_COORDINATES	Value	700649		0										Property	705710                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705711	Coordinate 03	1	701576	700511	27	701828	IS_EXTR_COORDINATES	Value	700649		0										Property	705711                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705712	Coordinate 04	1	701576	700511	27	701828	IS_EXTR_COORDINATES	Value	700649		0										Property	705712                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705713	Coordinate 05	1	701576	700511	27	701828	IS_EXTR_COORDINATES	Value	700649		0										Property	705713                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705714	Coordinate 06	1	701576	700511	27	701828	IS_EXTR_COORDINATES	Value	700649		0										Property	705714                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705715	Coordinate 07	1	701576	700511	27	701828	IS_EXTR_COORDINATES	Value	700649		0										Property	705715                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705716	Coordinate 08	1	701576	700511	27	701828	IS_EXTR_COORDINATES	Value	700649		0										Property	705716                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705717	Coordinate 09	1	701576	700511	27	701828	IS_EXTR_COORDINATES	Value	700649		0										Property	705717                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705718	Coordinate 10	1	701576	700511	27	701828	IS_EXTR_COORDINATES	Value	700649		0										Property	705718                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705719	Coordinate 11	1	701576	700511	27	701828	IS_EXTR_COORDINATES	Value	700649		0										Property	705719                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705720	Coordinate 12	1	701576	700511	27	701828	IS_EXTR_COORDINATES	Value	700649		0										Property	705720                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705721	Coordinate 13	1	701576	700511	27	701828	IS_EXTR_COORDINATES	Value	700649		0										Property	705721                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705708	Coordinate 00	1	702062	700511	1	702068	IS_Prop_UoM_Num	Value	700649		0										Num_1	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705709	Coordinate 01	1	702062	700511	1	702068	IS_Prop_UoM_Num	Value	700649		0										Num_1	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705710	Coordinate 02	1	702062	700511	1	702068	IS_Prop_UoM_Num	Value	700649		0										Num_1	15                            
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705711	Coordinate 03	1	702062	700511	1	702068	IS_Prop_UoM_Num	Value	700649		0										Num_1	30                            
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705712	Coordinate 04	1	702062	700511	1	702068	IS_Prop_UoM_Num	Value	700649		0										Num_1	40                            
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705713	Coordinate 05	1	702062	700511	1	702068	IS_Prop_UoM_Num	Value	700649		0										Num_1	55                            
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705714	Coordinate 06	1	702062	700511	1	702068	IS_Prop_UoM_Num	Value	700649		0										Num_1	80                            
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705715	Coordinate 07	1	702062	700511	1	702068	IS_Prop_UoM_Num	Value	700649		0										Num_1	100                           
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705716	Coordinate 08	1	702062	700511	1	702068	IS_Prop_UoM_Num	Value	700649		0										Num_1	120                           
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705717	Coordinate 09	1	702062	700511	1	702068	IS_Prop_UoM_Num	Value	700649		0										Num_1	135                           
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705718	Coordinate 10	1	702062	700511	1	702068	IS_Prop_UoM_Num	Value	700649		0										Num_1	145                           
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705719	Coordinate 11	1	702062	700511	1	702068	IS_Prop_UoM_Num	Value	700649		0										Num_1	155                           
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705720	Coordinate 12	1	702062	700511	1	702068	IS_Prop_UoM_Num	Value	700649		0										Num_1	170                           
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705721	Coordinate 13	1	702062	700511	1	702068	IS_Prop_UoM_Num	Value	700649		0										Num_1	170                           
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705708	Coordinate 00	1	701636	700511	27	701848	IS_EXTR_AREA	Value	700649		0										Property	705708                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705709	Coordinate 01	1	701636	700511	27	701848	IS_EXTR_AREA	Value	700649		0										Property	705709                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705710	Coordinate 02	1	701636	700511	27	701848	IS_EXTR_AREA	Value	700649		0										Property	705710                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705711	Coordinate 03	1	701636	700511	27	701848	IS_EXTR_AREA	Value	700649		0										Property	705711                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705712	Coordinate 04	1	701636	700511	27	701848	IS_EXTR_AREA	Value	700649		0										Property	705712                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705713	Coordinate 05	1	701636	700511	27	701848	IS_EXTR_AREA	Value	700649		0										Property	705713                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705714	Coordinate 06	1	701636	700511	27	701848	IS_EXTR_AREA	Value	700649		0										Property	705714                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705715	Coordinate 07	1	701636	700511	27	701848	IS_EXTR_AREA	Value	700649		0										Property	705715                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705716	Coordinate 08	1	701636	700511	27	701848	IS_EXTR_AREA	Value	700649		0										Property	705716                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705717	Coordinate 09	1	701636	700511	27	701848	IS_EXTR_AREA	Value	700649		0										Property	705717                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705718	Coordinate 10	1	701636	700511	27	701848	IS_EXTR_AREA	Value	700649		0										Property	705718                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705719	Coordinate 11	1	701636	700511	27	701848	IS_EXTR_AREA	Value	700649		0										Property	705719                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705720	Coordinate 12	1	701636	700511	27	701848	IS_EXTR_AREA	Value	700649		0										Property	705720                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705721	Coordinate 13	1	701636	700511	27	701848	IS_EXTR_AREA	Value	700649		0										Property	705721                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	0	default property group	705789	Extrudate construction	1	702060	700511	26	701769	IS_Single_ASSOC_40_DF	Value			0				900534	Sidewall					Characteristic	900534                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	0	default property group	705789	Extrudate construction	4	705789	700511	26	700929	IS_Single_Value_ASSOC_DF	Value			0				900534	Sidewall					Characteristic	900534                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	0	default property group	705789	Extrudate construction	1	701576	700511	27	701828	IS_EXTR_COORDINATES	Value			0				900534						Property	705789                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	0	default property group	705789	Extrudate construction	1	702062	700511	1	702068	IS_Prop_UoM_Num	Value			0				900534						Num_1	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	0	default property group	705789	Extrudate construction	1	701636	700511	27	701848	IS_EXTR_AREA	Value			0				900534						Property	705789                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700583	Processing	702482	TSE	701570	Tooling	705785	Die	1	701570	700511	11	700930	IS_Single_Value_CHAR_DF	Value			0										Char_1	T4006
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700583	Processing	702482	TSE	701570	Tooling	705786	Preformer	1	701570	700511	11	700930	IS_Single_Value_CHAR_DF	Value			0										Char_1	TS202
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700583	Processing	702482	TSE	701570	Tooling	705785	Die	4	710528	700511	1	702968	IS_Prop_Num	Value			0										Num_1	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700583	Processing	702482	TSE	701570	Tooling	705786	Preformer	4	710528	700511	1	702968	IS_Prop_Num	Value			0										Num_1	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700583	Processing	702482	TSE	0	default property group	705384	BOM alternative	1	701570	700511	11	700930	IS_Single_Value_CHAR_DF	Value			0				900476		900477		900478		Char_1	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700583	Processing	702482	TSE	0	default property group	710528	volgnummer	1	701570	700511	11	700930	IS_Single_Value_CHAR_DF	Value			0										Char_1	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700583	Processing	702482	TSE	0	default property group	705384	BOM alternative	4	710528	700511	1	702968	IS_Prop_Num	Value			0				900476		900477		900478		Num_1	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700583	Processing	702482	TSE	0	default property group	710528	volgnummer	4	710528	700511	1	702968	IS_Prop_Num	Value			0										Num_1	10                            
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	703176	Aging SAP	710529	Aging (minimal)	4	710531	700511	26	700929	IS_Single_Value_ASSOC_DF	Value	700626		0										Characteristic	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	703176	Aging SAP	710530	Aging (Maximal)	4	710531	700511	26	700929	IS_Single_Value_ASSOC_DF	Value	700627		0										Characteristic	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	703176	Aging SAP	710529	Aging (minimal)	4	709030	700511	26	700929	IS_Single_Value_ASSOC_DF	Value	700626		0										Characteristic	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	703176	Aging SAP	710530	Aging (Maximal)	4	709030	700511	26	700929	IS_Single_Value_ASSOC_DF	Value	700627		0										Characteristic	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	703176	Aging SAP	710529	Aging (minimal)	4	705428	700511	26	700929	IS_Single_Value_ASSOC_DF	Value	700626		0										Characteristic	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	703176	Aging SAP	710530	Aging (Maximal)	4	705428	700511	26	700929	IS_Single_Value_ASSOC_DF	Value	700627		0										Characteristic	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	703176	Aging SAP	710529	Aging (minimal)	4	703262	700511	1	702068	IS_Prop_UoM_Num	Value	700626		0										Num_1	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	703176	Aging SAP	710530	Aging (Maximal)	4	703262	700511	1	702068	IS_Prop_UoM_Num	Value	700627		0										Num_1	14                            
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	703176	Aging SAP	710529	Aging (minimal)	1	703176	700511	1	702068	IS_Prop_UoM_Num	Value	700626		0										Num_1	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	703176	Aging SAP	710530	Aging (Maximal)	1	703176	700511	1	702068	IS_Prop_UoM_Num	Value	700627		0										Num_1	14                            
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	0	default property group	703262	Weight	4	710531	700511	26	700929	IS_Single_Value_ASSOC_DF	Value			0										Characteristic	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	0	default property group	705428	Article group PG	4	710531	700511	26	700929	IS_Single_Value_ASSOC_DF	Value			0				900202	L5: ZIJKANTEN PERSONEN + INSERTS  					Characteristic	900202                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	0	default property group	705429	Packaging PG	4	710531	700511	26	700929	IS_Single_Value_ASSOC_DF	Value			0				903339	CASZY					Characteristic	903339                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	0	default property group	709030	Physical in product	4	710531	700511	26	700929	IS_Single_Value_ASSOC_DF	Value			0				900484	Yes					Characteristic	900484                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	0	default property group	710531	Article type	4	710531	700511	26	700929	IS_Single_Value_ASSOC_DF	Value			0				900977	I: Halffabrikaten Alternatief					Characteristic	900977                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	0	default property group	703262	Weight	4	709030	700511	26	700929	IS_Single_Value_ASSOC_DF	Value			0										Characteristic	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	0	default property group	705428	Article group PG	4	709030	700511	26	700929	IS_Single_Value_ASSOC_DF	Value			0				900202	L5: ZIJKANTEN PERSONEN + INSERTS  					Characteristic	900202                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	0	default property group	705429	Packaging PG	4	709030	700511	26	700929	IS_Single_Value_ASSOC_DF	Value			0				903339	CASZY					Characteristic	903339                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	0	default property group	709030	Physical in product	4	709030	700511	26	700929	IS_Single_Value_ASSOC_DF	Value			0				900484	Yes					Characteristic	900484                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	0	default property group	710531	Article type	4	709030	700511	26	700929	IS_Single_Value_ASSOC_DF	Value			0				900977	I: Halffabrikaten Alternatief					Characteristic	900977                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	0	default property group	703262	Weight	4	705428	700511	26	700929	IS_Single_Value_ASSOC_DF	Value			0										Characteristic	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	0	default property group	705428	Article group PG	4	705428	700511	26	700929	IS_Single_Value_ASSOC_DF	Value			0				900202	L5: ZIJKANTEN PERSONEN + INSERTS  					Characteristic	900202                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	0	default property group	705429	Packaging PG	4	705428	700511	26	700929	IS_Single_Value_ASSOC_DF	Value			0				903339	CASZY					Characteristic	903339                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	0	default property group	709030	Physical in product	4	705428	700511	26	700929	IS_Single_Value_ASSOC_DF	Value			0				900484	Yes					Characteristic	900484                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	0	default property group	710531	Article type	4	705428	700511	26	700929	IS_Single_Value_ASSOC_DF	Value			0				900977	I: Halffabrikaten Alternatief					Characteristic	900977                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	0	default property group	703262	Weight	4	703262	700511	1	702068	IS_Prop_UoM_Num	Value			0										Num_1	1                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	0	default property group	705428	Article group PG	4	703262	700511	1	702068	IS_Prop_UoM_Num	Value			0				900202						Num_1	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	0	default property group	705429	Packaging PG	4	703262	700511	1	702068	IS_Prop_UoM_Num	Value			0				903339						Num_1	140                           
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	0	default property group	709030	Physical in product	4	703262	700511	1	702068	IS_Prop_UoM_Num	Value			0				900484						Num_1	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	0	default property group	710531	Article type	4	703262	700511	1	702068	IS_Prop_UoM_Num	Value			0				900977						Num_1	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	0	default property group	703262	Weight	1	703176	700511	1	702068	IS_Prop_UoM_Num	Value			0										Num_1	1                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	0	default property group	705428	Article group PG	1	703176	700511	1	702068	IS_Prop_UoM_Num	Value			0				900202						Num_1	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	0	default property group	705429	Packaging PG	1	703176	700511	1	702068	IS_Prop_UoM_Num	Value			0				903339						Num_1	140                           
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	0	default property group	709030	Physical in product	1	703176	700511	1	702068	IS_Prop_UoM_Num	Value			0				900484						Num_1	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	0	default property group	710531	Article type	1	703176	700511	1	702068	IS_Prop_UoM_Num	Value			0				900977						Num_1	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	701598	Main extrudate dimensions	705782	Total width	1	702063	700951	2	702128	IS_Production_B&V_3	- tol [%]	700649		0		0								Num_2	-3.5                          
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	701598	Main extrudate dimensions	705783	Transition sidewall - rimcushion	1	702063	700951	2	702128	IS_Production_B&V_3	- tol [%]	700649		0		0								Num_2	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	701598	Main extrudate dimensions	712308	Rimcushion width	1	702063	700951	2	702128	IS_Production_B&V_3	- tol [%]	700649		0		0								Num_2	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	702063	Typical weight	705784	Typical weight	1	702063	700951	2	702128	IS_Production_B&V_3	- tol [%]	700573		0		0								Num_2	-7                            
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	702063	Typical weight	708868	Mass / meter	1	702063	700951	2	702128	IS_Production_B&V_3	- tol [%]	701469		0		0								Num_2	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	701598	Main extrudate dimensions	705782	Total width	1	702063	700952	3	702128	IS_Production_B&V_3	+ tol [%]	700649		0		0								Num_3	3.5                           
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	701598	Main extrudate dimensions	705783	Transition sidewall - rimcushion	1	702063	700952	3	702128	IS_Production_B&V_3	+ tol [%]	700649		0		0								Num_3	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	701598	Main extrudate dimensions	712308	Rimcushion width	1	702063	700952	3	702128	IS_Production_B&V_3	+ tol [%]	700649		0		0								Num_3	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	702063	Typical weight	705784	Typical weight	1	702063	700952	3	702128	IS_Production_B&V_3	+ tol [%]	700573		0		0								Num_3	7                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	702063	Typical weight	708868	Mass / meter	1	702063	700952	3	702128	IS_Production_B&V_3	+ tol [%]	701469		0		0								Num_3	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	703176	Aging SAP	710529	Aging (minimal)	4	705429	701151	1	701388	IS_PROP_ASS_NUM	Amount	700626		0										Num_1	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	703176	Aging SAP	710530	Aging (Maximal)	4	705429	701151	1	701388	IS_PROP_ASS_NUM	Amount	700627		0										Num_1	14                            
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	0	default property group	703262	Weight	4	705429	701151	1	701388	IS_PROP_ASS_NUM	Amount			0										Num_1	1                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	0	default property group	705428	Article group PG	4	705429	701151	1	701388	IS_PROP_ASS_NUM	Amount			0				900202						Num_1	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	0	default property group	705429	Packaging PG	4	705429	701151	1	701388	IS_PROP_ASS_NUM	Amount			0				903339						Num_1	140                           
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	0	default property group	709030	Physical in product	4	705429	701151	1	701388	IS_PROP_ASS_NUM	Amount			0				900484						Num_1	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700755	SAP information	0	(none)	0	default property group	710531	Article type	4	705429	701151	1	701388	IS_PROP_ASS_NUM	Amount			0				900977						Num_1	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	701598	Main extrudate dimensions	705782	Total width	1	702063	700498	1	702128	IS_Production_B&V_3	Target	700649		0		0								Num_1	170                           
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	701598	Main extrudate dimensions	705783	Transition sidewall - rimcushion	1	702063	700498	1	702128	IS_Production_B&V_3	Target	700649		0		0								Num_1	100                           
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	701598	Main extrudate dimensions	712308	Rimcushion width	1	702063	700498	1	702128	IS_Production_B&V_3	Target	700649		0		0								Num_1	70                            
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	701598	Main extrudate dimensions	705782	Total width	1	701598	700498	1	702108	IS_Production_B&V_2	Target	700649		0		0								Num_1	170                           
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	701598	Main extrudate dimensions	705783	Transition sidewall - rimcushion	1	701598	700498	1	702108	IS_Production_B&V_2	Target	700649		0		0								Num_1	100                           
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	701598	Main extrudate dimensions	712308	Rimcushion width	1	701598	700498	1	702108	IS_Production_B&V_2	Target	700649		0		0								Num_1	70                            
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	702063	Typical weight	705784	Typical weight	1	702063	700498	1	702128	IS_Production_B&V_3	Target	700573		0		0								Num_1	.61853375                     
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	702063	Typical weight	708868	Mass / meter	1	702063	700498	1	702128	IS_Production_B&V_3	Target	701469		0		0								Num_1	.61853375                     
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	702063	Typical weight	705784	Typical weight	1	701598	700498	1	702108	IS_Production_B&V_2	Target	700573		0		0								Num_1	.61853375                     
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	702063	Typical weight	708868	Mass / meter	1	701598	700498	1	702108	IS_Production_B&V_2	Target	701469		0		0								Num_1	.61853375                     
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	701598	Main extrudate dimensions	705782	Total width	1	702063	700501	25	702128	IS_Production_B&V_3	Apollo test code	700649		0		0								Test method	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	701598	Main extrudate dimensions	705783	Transition sidewall - rimcushion	1	702063	700501	25	702128	IS_Production_B&V_3	Apollo test code	700649		0		0								Test method	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	701598	Main extrudate dimensions	712308	Rimcushion width	1	702063	700501	25	702128	IS_Production_B&V_3	Apollo test code	700649		0		0								Test method	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	701598	Main extrudate dimensions	705782	Total width	1	701598	700501	25	702108	IS_Production_B&V_2	Apollo test code	700649		0		0								Test method	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	701598	Main extrudate dimensions	705783	Transition sidewall - rimcushion	1	701598	700501	25	702108	IS_Production_B&V_2	Apollo test code	700649		0		0								Test method	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	701598	Main extrudate dimensions	712308	Rimcushion width	1	701598	700501	25	702108	IS_Production_B&V_2	Apollo test code	700649		0		0								Test method	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	702063	Typical weight	705784	Typical weight	1	702063	700501	25	702128	IS_Production_B&V_3	Apollo test code	700573		0		0								Test method	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	702063	Typical weight	708868	Mass / meter	1	702063	700501	25	702128	IS_Production_B&V_3	Apollo test code	701469		0		0								Test method	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	702063	Typical weight	705784	Typical weight	1	701598	700501	25	702108	IS_Production_B&V_2	Apollo test code	700573		0		0								Test method	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	702063	Typical weight	708868	Mass / meter	1	701598	700501	25	702108	IS_Production_B&V_2	Apollo test code	701469		0		0								Test method	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	701598	Main extrudate dimensions	705782	Total width	1	702063	700503	17	702128	IS_Production_B&V_3	Cr. par.	700649		0		0								Boolean_1	N
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	701598	Main extrudate dimensions	705783	Transition sidewall - rimcushion	1	702063	700503	17	702128	IS_Production_B&V_3	Cr. par.	700649		0		0								Boolean_1	N
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	701598	Main extrudate dimensions	712308	Rimcushion width	1	702063	700503	17	702128	IS_Production_B&V_3	Cr. par.	700649		0		0								Boolean_1	N
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	701598	Main extrudate dimensions	705782	Total width	1	701598	700503	17	702108	IS_Production_B&V_2	Cr. par.	700649		0		0								Boolean_1	N
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	701598	Main extrudate dimensions	705783	Transition sidewall - rimcushion	1	701598	700503	17	702108	IS_Production_B&V_2	Cr. par.	700649		0		0								Boolean_1	N
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	701598	Main extrudate dimensions	712308	Rimcushion width	1	701598	700503	17	702108	IS_Production_B&V_2	Cr. par.	700649		0		0								Boolean_1	N
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	702063	Typical weight	705784	Typical weight	1	702063	700503	17	702128	IS_Production_B&V_3	Cr. par.	700573		0		0								Boolean_1	N
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	702063	Typical weight	708868	Mass / meter	1	702063	700503	17	702128	IS_Production_B&V_3	Cr. par.	701469		0		0								Boolean_1	N
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	702063	Typical weight	705784	Typical weight	1	701598	700503	17	702108	IS_Production_B&V_2	Cr. par.	700573		0		0								Boolean_1	N
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700584	Properties	0	(none)	702063	Typical weight	708868	Mass / meter	1	701598	700503	17	702108	IS_Production_B&V_2	Cr. par.	701469		0		0								Boolean_1	N
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701636	Extrudate characteristics	705788	Area	1	701576	700852	1	701828	IS_EXTR_COORDINATES	x	700579		0										Num_1	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701636	Extrudate characteristics	705788	Area	1	701636	700852	1	701848	IS_EXTR_AREA	x	700579		0										Num_1	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702062	Tread characteristics	707029	Triplex angle ß	1	701576	700852	1	701828	IS_EXTR_COORDINATES	x	701009		0										Num_1	9.7                           
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702062	Tread characteristics	707029	Triplex angle ß	1	701636	700852	1	701848	IS_EXTR_AREA	x	701009		0										Num_1	9.7                           
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	703411	Building method	1	701576	700852	1	701828	IS_EXTR_COORDINATES	x			0				900649						Num_1	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	707128	Contour	1	701576	700852	1	701828	IS_EXTR_COORDINATES	x			0				900651						Num_1	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	707131	Version	1	701576	700852	1	701828	IS_EXTR_COORDINATES	x			0				900515						Num_1	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	703411	Building method	1	701636	700852	1	701848	IS_EXTR_AREA	x			0				900649						Num_1	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	707128	Contour	1	701636	700852	1	701848	IS_EXTR_AREA	x			0				900651						Num_1	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	707131	Version	1	701636	700852	1	701848	IS_EXTR_AREA	x			0				900515						Num_1	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705708	Coordinate 00	1	701576	700852	1	701828	IS_EXTR_COORDINATES	x	700649		0										Num_1	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705709	Coordinate 01	1	701576	700852	1	701828	IS_EXTR_COORDINATES	x	700649		0										Num_1	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705710	Coordinate 02	1	701576	700852	1	701828	IS_EXTR_COORDINATES	x	700649		0										Num_1	15                            
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705711	Coordinate 03	1	701576	700852	1	701828	IS_EXTR_COORDINATES	x	700649		0										Num_1	30                            
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705712	Coordinate 04	1	701576	700852	1	701828	IS_EXTR_COORDINATES	x	700649		0										Num_1	40                            
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705713	Coordinate 05	1	701576	700852	1	701828	IS_EXTR_COORDINATES	x	700649		0										Num_1	55                            
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705714	Coordinate 06	1	701576	700852	1	701828	IS_EXTR_COORDINATES	x	700649		0										Num_1	80                            
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705715	Coordinate 07	1	701576	700852	1	701828	IS_EXTR_COORDINATES	x	700649		0										Num_1	100                           
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705716	Coordinate 08	1	701576	700852	1	701828	IS_EXTR_COORDINATES	x	700649		0										Num_1	120                           
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705717	Coordinate 09	1	701576	700852	1	701828	IS_EXTR_COORDINATES	x	700649		0										Num_1	135                           
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705718	Coordinate 10	1	701576	700852	1	701828	IS_EXTR_COORDINATES	x	700649		0										Num_1	145                           
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705719	Coordinate 11	1	701576	700852	1	701828	IS_EXTR_COORDINATES	x	700649		0										Num_1	155                           
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705720	Coordinate 12	1	701576	700852	1	701828	IS_EXTR_COORDINATES	x	700649		0										Num_1	170                           
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705721	Coordinate 13	1	701576	700852	1	701828	IS_EXTR_COORDINATES	x	700649		0										Num_1	170                           
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705708	Coordinate 00	1	701636	700852	1	701848	IS_EXTR_AREA	x	700649		0										Num_1	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705709	Coordinate 01	1	701636	700852	1	701848	IS_EXTR_AREA	x	700649		0										Num_1	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705710	Coordinate 02	1	701636	700852	1	701848	IS_EXTR_AREA	x	700649		0										Num_1	15                            
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705711	Coordinate 03	1	701636	700852	1	701848	IS_EXTR_AREA	x	700649		0										Num_1	30                            
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705712	Coordinate 04	1	701636	700852	1	701848	IS_EXTR_AREA	x	700649		0										Num_1	40                            
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705713	Coordinate 05	1	701636	700852	1	701848	IS_EXTR_AREA	x	700649		0										Num_1	55                            
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705714	Coordinate 06	1	701636	700852	1	701848	IS_EXTR_AREA	x	700649		0										Num_1	80                            
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705715	Coordinate 07	1	701636	700852	1	701848	IS_EXTR_AREA	x	700649		0										Num_1	100                           
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705716	Coordinate 08	1	701636	700852	1	701848	IS_EXTR_AREA	x	700649		0										Num_1	120                           
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705717	Coordinate 09	1	701636	700852	1	701848	IS_EXTR_AREA	x	700649		0										Num_1	135                           
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705718	Coordinate 10	1	701636	700852	1	701848	IS_EXTR_AREA	x	700649		0										Num_1	145                           
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705719	Coordinate 11	1	701636	700852	1	701848	IS_EXTR_AREA	x	700649		0										Num_1	155                           
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705720	Coordinate 12	1	701636	700852	1	701848	IS_EXTR_AREA	x	700649		0										Num_1	170                           
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705721	Coordinate 13	1	701636	700852	1	701848	IS_EXTR_AREA	x	700649		0										Num_1	170                           
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	0	default property group	705789	Extrudate construction	1	701576	700852	1	701828	IS_EXTR_COORDINATES	x			0				900534						Num_1	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	0	default property group	705789	Extrudate construction	1	701636	700852	1	701848	IS_EXTR_AREA	x			0				900534						Num_1	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701636	Extrudate characteristics	705788	Area	1	701576	700853	2	701828	IS_EXTR_COORDINATES	y_C1	700579		0										Num_2	421.75                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702062	Tread characteristics	707029	Triplex angle ß	1	701576	700853	2	701828	IS_EXTR_COORDINATES	y_C1	701009		0										Num_2	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	703411	Building method	1	701576	700853	2	701828	IS_EXTR_COORDINATES	y_C1			0				900649						Num_2	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	707128	Contour	1	701576	700853	2	701828	IS_EXTR_COORDINATES	y_C1			0				900651						Num_2	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	707131	Version	1	701576	700853	2	701828	IS_EXTR_COORDINATES	y_C1			0				900515						Num_2	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705708	Coordinate 00	1	701576	700853	2	701828	IS_EXTR_COORDINATES	y_C1	700649		0										Num_2	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705709	Coordinate 01	1	701576	700853	2	701828	IS_EXTR_COORDINATES	y_C1	700649		0										Num_2	.5                            
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705710	Coordinate 02	1	701576	700853	2	701828	IS_EXTR_COORDINATES	y_C1	700649		0										Num_2	2.5                           
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705711	Coordinate 03	1	701576	700853	2	701828	IS_EXTR_COORDINATES	y_C1	700649		0										Num_2	5                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705712	Coordinate 04	1	701576	700853	2	701828	IS_EXTR_COORDINATES	y_C1	700649		0										Num_2	5                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705713	Coordinate 05	1	701576	700853	2	701828	IS_EXTR_COORDINATES	y_C1	700649		0										Num_2	4.5                           
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705714	Coordinate 06	1	701576	700853	2	701828	IS_EXTR_COORDINATES	y_C1	700649		0										Num_2	3.8                           
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705715	Coordinate 07	1	701576	700853	2	701828	IS_EXTR_COORDINATES	y_C1	700649		0										Num_2	4                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705716	Coordinate 08	1	701576	700853	2	701828	IS_EXTR_COORDINATES	y_C1	700649		0										Num_2	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705717	Coordinate 09	1	701576	700853	2	701828	IS_EXTR_COORDINATES	y_C1	700649		0										Num_2	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705718	Coordinate 10	1	701576	700853	2	701828	IS_EXTR_COORDINATES	y_C1	700649		0										Num_2	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705719	Coordinate 11	1	701576	700853	2	701828	IS_EXTR_COORDINATES	y_C1	700649		0										Num_2	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705720	Coordinate 12	1	701576	700853	2	701828	IS_EXTR_COORDINATES	y_C1	700649		0										Num_2	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705721	Coordinate 13	1	701576	700853	2	701828	IS_EXTR_COORDINATES	y_C1	700649		0										Num_2	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	0	default property group	705789	Extrudate construction	1	701576	700853	2	701828	IS_EXTR_COORDINATES	y_C1			0				900534						Num_2	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701636	Extrudate characteristics	705788	Area	1	701576	700854	3	701828	IS_EXTR_COORDINATES	y_C2	700579		0										Num_3	152.5                         
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702062	Tread characteristics	707029	Triplex angle ß	1	701576	700854	3	701828	IS_EXTR_COORDINATES	y_C2	701009		0										Num_3	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	703411	Building method	1	701576	700854	3	701828	IS_EXTR_COORDINATES	y_C2			0				900649						Num_3	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	707128	Contour	1	701576	700854	3	701828	IS_EXTR_COORDINATES	y_C2			0				900651						Num_3	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	707131	Version	1	701576	700854	3	701828	IS_EXTR_COORDINATES	y_C2			0				900515						Num_3	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705708	Coordinate 00	1	701576	700854	3	701828	IS_EXTR_COORDINATES	y_C2	700649		0										Num_3	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705709	Coordinate 01	1	701576	700854	3	701828	IS_EXTR_COORDINATES	y_C2	700649		0										Num_3	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705710	Coordinate 02	1	701576	700854	3	701828	IS_EXTR_COORDINATES	y_C2	700649		0										Num_3	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705711	Coordinate 03	1	701576	700854	3	701828	IS_EXTR_COORDINATES	y_C2	700649		0										Num_3	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705712	Coordinate 04	1	701576	700854	3	701828	IS_EXTR_COORDINATES	y_C2	700649		0										Num_3	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705713	Coordinate 05	1	701576	700854	3	701828	IS_EXTR_COORDINATES	y_C2	700649		0										Num_3	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705714	Coordinate 06	1	701576	700854	3	701828	IS_EXTR_COORDINATES	y_C2	700649		0										Num_3	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705715	Coordinate 07	1	701576	700854	3	701828	IS_EXTR_COORDINATES	y_C2	700649		0										Num_3	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705716	Coordinate 08	1	701576	700854	3	701828	IS_EXTR_COORDINATES	y_C2	700649		0										Num_3	3.5                           
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705717	Coordinate 09	1	701576	700854	3	701828	IS_EXTR_COORDINATES	y_C2	700649		0										Num_3	3                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705718	Coordinate 10	1	701576	700854	3	701828	IS_EXTR_COORDINATES	y_C2	700649		0										Num_3	2.5                           
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705719	Coordinate 11	1	701576	700854	3	701828	IS_EXTR_COORDINATES	y_C2	700649		0										Num_3	2                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705720	Coordinate 12	1	701576	700854	3	701828	IS_EXTR_COORDINATES	y_C2	700649		0										Num_3	.5                            
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705721	Coordinate 13	1	701576	700854	3	701828	IS_EXTR_COORDINATES	y_C2	700649		0										Num_3	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	0	default property group	705789	Extrudate construction	1	701576	700854	3	701828	IS_EXTR_COORDINATES	y_C2			0				900534						Num_3	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701636	Extrudate characteristics	705788	Area	1	701576	700855	4	701828	IS_EXTR_COORDINATES	y_C3	700579		0										Num_4	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702062	Tread characteristics	707029	Triplex angle ß	1	701576	700855	4	701828	IS_EXTR_COORDINATES	y_C3	701009		0										Num_4	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	703411	Building method	1	701576	700855	4	701828	IS_EXTR_COORDINATES	y_C3			0				900649						Num_4	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	707128	Contour	1	701576	700855	4	701828	IS_EXTR_COORDINATES	y_C3			0				900651						Num_4	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	707131	Version	1	701576	700855	4	701828	IS_EXTR_COORDINATES	y_C3			0				900515						Num_4	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705708	Coordinate 00	1	701576	700855	4	701828	IS_EXTR_COORDINATES	y_C3	700649		0										Num_4	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705709	Coordinate 01	1	701576	700855	4	701828	IS_EXTR_COORDINATES	y_C3	700649		0										Num_4	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705710	Coordinate 02	1	701576	700855	4	701828	IS_EXTR_COORDINATES	y_C3	700649		0										Num_4	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705711	Coordinate 03	1	701576	700855	4	701828	IS_EXTR_COORDINATES	y_C3	700649		0										Num_4	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705712	Coordinate 04	1	701576	700855	4	701828	IS_EXTR_COORDINATES	y_C3	700649		0										Num_4	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705713	Coordinate 05	1	701576	700855	4	701828	IS_EXTR_COORDINATES	y_C3	700649		0										Num_4	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705714	Coordinate 06	1	701576	700855	4	701828	IS_EXTR_COORDINATES	y_C3	700649		0										Num_4	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705715	Coordinate 07	1	701576	700855	4	701828	IS_EXTR_COORDINATES	y_C3	700649		0										Num_4	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705716	Coordinate 08	1	701576	700855	4	701828	IS_EXTR_COORDINATES	y_C3	700649		0										Num_4	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705717	Coordinate 09	1	701576	700855	4	701828	IS_EXTR_COORDINATES	y_C3	700649		0										Num_4	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705718	Coordinate 10	1	701576	700855	4	701828	IS_EXTR_COORDINATES	y_C3	700649		0										Num_4	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705719	Coordinate 11	1	701576	700855	4	701828	IS_EXTR_COORDINATES	y_C3	700649		0										Num_4	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705720	Coordinate 12	1	701576	700855	4	701828	IS_EXTR_COORDINATES	y_C3	700649		0										Num_4	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705721	Coordinate 13	1	701576	700855	4	701828	IS_EXTR_COORDINATES	y_C3	700649		0										Num_4	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	0	default property group	705789	Extrudate construction	1	701576	700855	4	701828	IS_EXTR_COORDINATES	y_C3			0				900534						Num_4	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701636	Extrudate characteristics	705788	Area	1	701576	700856	5	701828	IS_EXTR_COORDINATES	y_C4	700579		0										Num_5	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702062	Tread characteristics	707029	Triplex angle ß	1	701576	700856	5	701828	IS_EXTR_COORDINATES	y_C4	701009		0										Num_5	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	703411	Building method	1	701576	700856	5	701828	IS_EXTR_COORDINATES	y_C4			0				900649						Num_5	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	707128	Contour	1	701576	700856	5	701828	IS_EXTR_COORDINATES	y_C4			0				900651						Num_5	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	707131	Version	1	701576	700856	5	701828	IS_EXTR_COORDINATES	y_C4			0				900515						Num_5	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705708	Coordinate 00	1	701576	700856	5	701828	IS_EXTR_COORDINATES	y_C4	700649		0										Num_5	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705709	Coordinate 01	1	701576	700856	5	701828	IS_EXTR_COORDINATES	y_C4	700649		0										Num_5	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705710	Coordinate 02	1	701576	700856	5	701828	IS_EXTR_COORDINATES	y_C4	700649		0										Num_5	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705711	Coordinate 03	1	701576	700856	5	701828	IS_EXTR_COORDINATES	y_C4	700649		0										Num_5	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705712	Coordinate 04	1	701576	700856	5	701828	IS_EXTR_COORDINATES	y_C4	700649		0										Num_5	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705713	Coordinate 05	1	701576	700856	5	701828	IS_EXTR_COORDINATES	y_C4	700649		0										Num_5	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705714	Coordinate 06	1	701576	700856	5	701828	IS_EXTR_COORDINATES	y_C4	700649		0										Num_5	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705715	Coordinate 07	1	701576	700856	5	701828	IS_EXTR_COORDINATES	y_C4	700649		0										Num_5	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705716	Coordinate 08	1	701576	700856	5	701828	IS_EXTR_COORDINATES	y_C4	700649		0										Num_5	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705717	Coordinate 09	1	701576	700856	5	701828	IS_EXTR_COORDINATES	y_C4	700649		0										Num_5	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705718	Coordinate 10	1	701576	700856	5	701828	IS_EXTR_COORDINATES	y_C4	700649		0										Num_5	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705719	Coordinate 11	1	701576	700856	5	701828	IS_EXTR_COORDINATES	y_C4	700649		0										Num_5	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705720	Coordinate 12	1	701576	700856	5	701828	IS_EXTR_COORDINATES	y_C4	700649		0										Num_5	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705721	Coordinate 13	1	701576	700856	5	701828	IS_EXTR_COORDINATES	y_C4	700649		0										Num_5	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	0	default property group	705789	Extrudate construction	1	701576	700856	5	701828	IS_EXTR_COORDINATES	y_C4			0				900534						Num_5	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701636	Extrudate characteristics	705788	Area	1	701576	700857	6	701828	IS_EXTR_COORDINATES	y_Tot.	700579		0										Num_6	574.25                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702062	Tread characteristics	707029	Triplex angle ß	1	701576	700857	6	701828	IS_EXTR_COORDINATES	y_Tot.	701009		0										Num_6	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	703411	Building method	1	701576	700857	6	701828	IS_EXTR_COORDINATES	y_Tot.			0				900649						Num_6	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	707128	Contour	1	701576	700857	6	701828	IS_EXTR_COORDINATES	y_Tot.			0				900651						Num_6	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	707131	Version	1	701576	700857	6	701828	IS_EXTR_COORDINATES	y_Tot.			0				900515						Num_6	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705708	Coordinate 00	1	701576	700857	6	701828	IS_EXTR_COORDINATES	y_Tot.	700649		0										Num_6	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705709	Coordinate 01	1	701576	700857	6	701828	IS_EXTR_COORDINATES	y_Tot.	700649		0										Num_6	.5                            
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705710	Coordinate 02	1	701576	700857	6	701828	IS_EXTR_COORDINATES	y_Tot.	700649		0										Num_6	2.5                           
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705711	Coordinate 03	1	701576	700857	6	701828	IS_EXTR_COORDINATES	y_Tot.	700649		0										Num_6	5                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705712	Coordinate 04	1	701576	700857	6	701828	IS_EXTR_COORDINATES	y_Tot.	700649		0										Num_6	5                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705713	Coordinate 05	1	701576	700857	6	701828	IS_EXTR_COORDINATES	y_Tot.	700649		0										Num_6	4.5                           
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705714	Coordinate 06	1	701576	700857	6	701828	IS_EXTR_COORDINATES	y_Tot.	700649		0										Num_6	3.8                           
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705715	Coordinate 07	1	701576	700857	6	701828	IS_EXTR_COORDINATES	y_Tot.	700649		0										Num_6	4                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705716	Coordinate 08	1	701576	700857	6	701828	IS_EXTR_COORDINATES	y_Tot.	700649		0										Num_6	3.5                           
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705717	Coordinate 09	1	701576	700857	6	701828	IS_EXTR_COORDINATES	y_Tot.	700649		0										Num_6	3                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705718	Coordinate 10	1	701576	700857	6	701828	IS_EXTR_COORDINATES	y_Tot.	700649		0										Num_6	2.5                           
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705719	Coordinate 11	1	701576	700857	6	701828	IS_EXTR_COORDINATES	y_Tot.	700649		0										Num_6	2                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705720	Coordinate 12	1	701576	700857	6	701828	IS_EXTR_COORDINATES	y_Tot.	700649		0										Num_6	.5                            
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705721	Coordinate 13	1	701576	700857	6	701828	IS_EXTR_COORDINATES	y_Tot.	700649		0										Num_6	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	0	default property group	705789	Extrudate construction	1	701576	700857	6	701828	IS_EXTR_COORDINATES	y_Tot.			0				900534						Num_6	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701636	Extrudate characteristics	705788	Area	1	701636	700871	2	701848	IS_EXTR_AREA	C1	700579		0										Num_2	421.75                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702062	Tread characteristics	707029	Triplex angle ß	1	701636	700871	2	701848	IS_EXTR_AREA	C1	701009		0										Num_2	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	703411	Building method	1	701636	700871	2	701848	IS_EXTR_AREA	C1			0				900649						Num_2	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	707128	Contour	1	701636	700871	2	701848	IS_EXTR_AREA	C1			0				900651						Num_2	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	707131	Version	1	701636	700871	2	701848	IS_EXTR_AREA	C1			0				900515						Num_2	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705708	Coordinate 00	1	701636	700871	2	701848	IS_EXTR_AREA	C1	700649		0										Num_2	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705709	Coordinate 01	1	701636	700871	2	701848	IS_EXTR_AREA	C1	700649		0										Num_2	.5                            
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705710	Coordinate 02	1	701636	700871	2	701848	IS_EXTR_AREA	C1	700649		0										Num_2	2.5                           
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705711	Coordinate 03	1	701636	700871	2	701848	IS_EXTR_AREA	C1	700649		0										Num_2	5                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705712	Coordinate 04	1	701636	700871	2	701848	IS_EXTR_AREA	C1	700649		0										Num_2	5                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705713	Coordinate 05	1	701636	700871	2	701848	IS_EXTR_AREA	C1	700649		0										Num_2	4.5                           
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705714	Coordinate 06	1	701636	700871	2	701848	IS_EXTR_AREA	C1	700649		0										Num_2	3.8                           
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705715	Coordinate 07	1	701636	700871	2	701848	IS_EXTR_AREA	C1	700649		0										Num_2	4                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705716	Coordinate 08	1	701636	700871	2	701848	IS_EXTR_AREA	C1	700649		0										Num_2	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705717	Coordinate 09	1	701636	700871	2	701848	IS_EXTR_AREA	C1	700649		0										Num_2	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705718	Coordinate 10	1	701636	700871	2	701848	IS_EXTR_AREA	C1	700649		0										Num_2	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705719	Coordinate 11	1	701636	700871	2	701848	IS_EXTR_AREA	C1	700649		0										Num_2	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705720	Coordinate 12	1	701636	700871	2	701848	IS_EXTR_AREA	C1	700649		0										Num_2	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705721	Coordinate 13	1	701636	700871	2	701848	IS_EXTR_AREA	C1	700649		0										Num_2	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	0	default property group	705789	Extrudate construction	1	701636	700871	2	701848	IS_EXTR_AREA	C1			0				900534						Num_2	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701636	Extrudate characteristics	705788	Area	1	701636	700872	3	701848	IS_EXTR_AREA	C2	700579		0										Num_3	152.5                         
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702062	Tread characteristics	707029	Triplex angle ß	1	701636	700872	3	701848	IS_EXTR_AREA	C2	701009		0										Num_3	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	703411	Building method	1	701636	700872	3	701848	IS_EXTR_AREA	C2			0				900649						Num_3	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	707128	Contour	1	701636	700872	3	701848	IS_EXTR_AREA	C2			0				900651						Num_3	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	707131	Version	1	701636	700872	3	701848	IS_EXTR_AREA	C2			0				900515						Num_3	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705708	Coordinate 00	1	701636	700872	3	701848	IS_EXTR_AREA	C2	700649		0										Num_3	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705709	Coordinate 01	1	701636	700872	3	701848	IS_EXTR_AREA	C2	700649		0										Num_3	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705710	Coordinate 02	1	701636	700872	3	701848	IS_EXTR_AREA	C2	700649		0										Num_3	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705711	Coordinate 03	1	701636	700872	3	701848	IS_EXTR_AREA	C2	700649		0										Num_3	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705712	Coordinate 04	1	701636	700872	3	701848	IS_EXTR_AREA	C2	700649		0										Num_3	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705713	Coordinate 05	1	701636	700872	3	701848	IS_EXTR_AREA	C2	700649		0										Num_3	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705714	Coordinate 06	1	701636	700872	3	701848	IS_EXTR_AREA	C2	700649		0										Num_3	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705715	Coordinate 07	1	701636	700872	3	701848	IS_EXTR_AREA	C2	700649		0										Num_3	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705716	Coordinate 08	1	701636	700872	3	701848	IS_EXTR_AREA	C2	700649		0										Num_3	3.5                           
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705717	Coordinate 09	1	701636	700872	3	701848	IS_EXTR_AREA	C2	700649		0										Num_3	3                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705718	Coordinate 10	1	701636	700872	3	701848	IS_EXTR_AREA	C2	700649		0										Num_3	2.5                           
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705719	Coordinate 11	1	701636	700872	3	701848	IS_EXTR_AREA	C2	700649		0										Num_3	2                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705720	Coordinate 12	1	701636	700872	3	701848	IS_EXTR_AREA	C2	700649		0										Num_3	.5                            
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705721	Coordinate 13	1	701636	700872	3	701848	IS_EXTR_AREA	C2	700649		0										Num_3	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	0	default property group	705789	Extrudate construction	1	701636	700872	3	701848	IS_EXTR_AREA	C2			0				900534						Num_3	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701636	Extrudate characteristics	705788	Area	1	701636	700873	4	701848	IS_EXTR_AREA	C3	700579		0										Num_4	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702062	Tread characteristics	707029	Triplex angle ß	1	701636	700873	4	701848	IS_EXTR_AREA	C3	701009		0										Num_4	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	703411	Building method	1	701636	700873	4	701848	IS_EXTR_AREA	C3			0				900649						Num_4	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	707128	Contour	1	701636	700873	4	701848	IS_EXTR_AREA	C3			0				900651						Num_4	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	707131	Version	1	701636	700873	4	701848	IS_EXTR_AREA	C3			0				900515						Num_4	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705708	Coordinate 00	1	701636	700873	4	701848	IS_EXTR_AREA	C3	700649		0										Num_4	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705709	Coordinate 01	1	701636	700873	4	701848	IS_EXTR_AREA	C3	700649		0										Num_4	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705710	Coordinate 02	1	701636	700873	4	701848	IS_EXTR_AREA	C3	700649		0										Num_4	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705711	Coordinate 03	1	701636	700873	4	701848	IS_EXTR_AREA	C3	700649		0										Num_4	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705712	Coordinate 04	1	701636	700873	4	701848	IS_EXTR_AREA	C3	700649		0										Num_4	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705713	Coordinate 05	1	701636	700873	4	701848	IS_EXTR_AREA	C3	700649		0										Num_4	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705714	Coordinate 06	1	701636	700873	4	701848	IS_EXTR_AREA	C3	700649		0										Num_4	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705715	Coordinate 07	1	701636	700873	4	701848	IS_EXTR_AREA	C3	700649		0										Num_4	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705716	Coordinate 08	1	701636	700873	4	701848	IS_EXTR_AREA	C3	700649		0										Num_4	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705717	Coordinate 09	1	701636	700873	4	701848	IS_EXTR_AREA	C3	700649		0										Num_4	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705718	Coordinate 10	1	701636	700873	4	701848	IS_EXTR_AREA	C3	700649		0										Num_4	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705719	Coordinate 11	1	701636	700873	4	701848	IS_EXTR_AREA	C3	700649		0										Num_4	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705720	Coordinate 12	1	701636	700873	4	701848	IS_EXTR_AREA	C3	700649		0										Num_4	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705721	Coordinate 13	1	701636	700873	4	701848	IS_EXTR_AREA	C3	700649		0										Num_4	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	0	default property group	705789	Extrudate construction	1	701636	700873	4	701848	IS_EXTR_AREA	C3			0				900534						Num_4	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701636	Extrudate characteristics	705788	Area	1	701636	700874	5	701848	IS_EXTR_AREA	C4	700579		0										Num_5	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702062	Tread characteristics	707029	Triplex angle ß	1	701636	700874	5	701848	IS_EXTR_AREA	C4	701009		0										Num_5	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	703411	Building method	1	701636	700874	5	701848	IS_EXTR_AREA	C4			0				900649						Num_5	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	707128	Contour	1	701636	700874	5	701848	IS_EXTR_AREA	C4			0				900651						Num_5	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	707131	Version	1	701636	700874	5	701848	IS_EXTR_AREA	C4			0				900515						Num_5	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705708	Coordinate 00	1	701636	700874	5	701848	IS_EXTR_AREA	C4	700649		0										Num_5	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705709	Coordinate 01	1	701636	700874	5	701848	IS_EXTR_AREA	C4	700649		0										Num_5	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705710	Coordinate 02	1	701636	700874	5	701848	IS_EXTR_AREA	C4	700649		0										Num_5	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705711	Coordinate 03	1	701636	700874	5	701848	IS_EXTR_AREA	C4	700649		0										Num_5	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705712	Coordinate 04	1	701636	700874	5	701848	IS_EXTR_AREA	C4	700649		0										Num_5	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705713	Coordinate 05	1	701636	700874	5	701848	IS_EXTR_AREA	C4	700649		0										Num_5	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705714	Coordinate 06	1	701636	700874	5	701848	IS_EXTR_AREA	C4	700649		0										Num_5	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705715	Coordinate 07	1	701636	700874	5	701848	IS_EXTR_AREA	C4	700649		0										Num_5	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705716	Coordinate 08	1	701636	700874	5	701848	IS_EXTR_AREA	C4	700649		0										Num_5	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705717	Coordinate 09	1	701636	700874	5	701848	IS_EXTR_AREA	C4	700649		0										Num_5	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705718	Coordinate 10	1	701636	700874	5	701848	IS_EXTR_AREA	C4	700649		0										Num_5	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705719	Coordinate 11	1	701636	700874	5	701848	IS_EXTR_AREA	C4	700649		0										Num_5	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705720	Coordinate 12	1	701636	700874	5	701848	IS_EXTR_AREA	C4	700649		0										Num_5	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705721	Coordinate 13	1	701636	700874	5	701848	IS_EXTR_AREA	C4	700649		0										Num_5	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	0	default property group	705789	Extrudate construction	1	701636	700874	5	701848	IS_EXTR_AREA	C4			0				900534						Num_5	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701636	Extrudate characteristics	705788	Area	1	701636	700875	6	701848	IS_EXTR_AREA	Total	700579		0										Num_6	574.25                        
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702062	Tread characteristics	707029	Triplex angle ß	1	701636	700875	6	701848	IS_EXTR_AREA	Total	701009		0										Num_6	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	703411	Building method	1	701636	700875	6	701848	IS_EXTR_AREA	Total			0				900649						Num_6	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	707128	Contour	1	701636	700875	6	701848	IS_EXTR_AREA	Total			0				900651						Num_6	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	707131	Version	1	701636	700875	6	701848	IS_EXTR_AREA	Total			0				900515						Num_6	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705708	Coordinate 00	1	701636	700875	6	701848	IS_EXTR_AREA	Total	700649		0										Num_6	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705709	Coordinate 01	1	701636	700875	6	701848	IS_EXTR_AREA	Total	700649		0										Num_6	.5                            
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705710	Coordinate 02	1	701636	700875	6	701848	IS_EXTR_AREA	Total	700649		0										Num_6	2.5                           
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705711	Coordinate 03	1	701636	700875	6	701848	IS_EXTR_AREA	Total	700649		0										Num_6	5                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705712	Coordinate 04	1	701636	700875	6	701848	IS_EXTR_AREA	Total	700649		0										Num_6	5                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705713	Coordinate 05	1	701636	700875	6	701848	IS_EXTR_AREA	Total	700649		0										Num_6	4.5                           
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705714	Coordinate 06	1	701636	700875	6	701848	IS_EXTR_AREA	Total	700649		0										Num_6	3.8                           
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705715	Coordinate 07	1	701636	700875	6	701848	IS_EXTR_AREA	Total	700649		0										Num_6	4                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705716	Coordinate 08	1	701636	700875	6	701848	IS_EXTR_AREA	Total	700649		0										Num_6	3.5                           
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705717	Coordinate 09	1	701636	700875	6	701848	IS_EXTR_AREA	Total	700649		0										Num_6	3                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705718	Coordinate 10	1	701636	700875	6	701848	IS_EXTR_AREA	Total	700649		0										Num_6	2.5                           
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705719	Coordinate 11	1	701636	700875	6	701848	IS_EXTR_AREA	Total	700649		0										Num_6	2                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705720	Coordinate 12	1	701636	700875	6	701848	IS_EXTR_AREA	Total	700649		0										Num_6	.5                            
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705721	Coordinate 13	1	701636	700875	6	701848	IS_EXTR_AREA	Total	700649		0										Num_6	0                             
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	0	default property group	705789	Extrudate construction	1	701636	700875	6	701848	IS_EXTR_AREA	Total			0				900534						Num_6	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701636	Extrudate characteristics	705788	Area	1	701636	701572	7	701848	IS_EXTR_AREA	C5	700579		0										Num_7	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702062	Tread characteristics	707029	Triplex angle ß	1	701636	701572	7	701848	IS_EXTR_AREA	C5	701009		0										Num_7	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	703411	Building method	1	701636	701572	7	701848	IS_EXTR_AREA	C5			0				900649						Num_7	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	707128	Contour	1	701636	701572	7	701848	IS_EXTR_AREA	C5			0				900651						Num_7	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	702060	Sidewall characteristics	707131	Version	1	701636	701572	7	701848	IS_EXTR_AREA	C5			0				900515						Num_7	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705708	Coordinate 00	1	701636	701572	7	701848	IS_EXTR_AREA	C5	700649		0										Num_7	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705709	Coordinate 01	1	701636	701572	7	701848	IS_EXTR_AREA	C5	700649		0										Num_7	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705710	Coordinate 02	1	701636	701572	7	701848	IS_EXTR_AREA	C5	700649		0										Num_7	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705711	Coordinate 03	1	701636	701572	7	701848	IS_EXTR_AREA	C5	700649		0										Num_7	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705712	Coordinate 04	1	701636	701572	7	701848	IS_EXTR_AREA	C5	700649		0										Num_7	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705713	Coordinate 05	1	701636	701572	7	701848	IS_EXTR_AREA	C5	700649		0										Num_7	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705714	Coordinate 06	1	701636	701572	7	701848	IS_EXTR_AREA	C5	700649		0										Num_7	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705715	Coordinate 07	1	701636	701572	7	701848	IS_EXTR_AREA	C5	700649		0										Num_7	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705716	Coordinate 08	1	701636	701572	7	701848	IS_EXTR_AREA	C5	700649		0										Num_7	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705717	Coordinate 09	1	701636	701572	7	701848	IS_EXTR_AREA	C5	700649		0										Num_7	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705718	Coordinate 10	1	701636	701572	7	701848	IS_EXTR_AREA	C5	700649		0										Num_7	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705719	Coordinate 11	1	701636	701572	7	701848	IS_EXTR_AREA	C5	700649		0										Num_7	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705720	Coordinate 12	1	701636	701572	7	701848	IS_EXTR_AREA	C5	700649		0										Num_7	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	701576	Coordinates	705721	Coordinate 13	1	701636	701572	7	701848	IS_EXTR_AREA	C5	700649		0										Num_7	
ES_R17Z	8	ENS	1	1	126	E_Sidewall	700775	SPPL	0	(none)	0	default property group	705789	Extrudate construction	1	701636	701572	7	701848	IS_EXTR_AREA	C5			0				900534						Num_7	
*/
--Eva Flentge
--Timo de Vries
--Ninke Vogelsang
--Oplossing: Toevoegen USER aan REPORTINGSERVICES_AD   !!!!!!!!

--UNI00403R_EXECUTION


-INCLUDE UNI00403P_auth

select AD.AD
,      AD.PERSON
,      AD.EMAIL
,      AD.DEF_UP
,      profattr.up
,      profattr.value
FROM UTAD   ad
JOIN UTUPAU profattr  on profattr.up = ad.def_up
WHERE AD.version_is_current = 1
and   ad.ad IN ('PSC' , 'PGO' )
and   ad.ss not in ('@O')
and   profattr.au = 'user_group' 
order by ad.ad
;
/*
PGO	Patrick Goosens	patrick.goossens@apollotyres.com	1	1	Application management
PSC	Peter Schepens	Peter.Schepens@apollotyres.com		1	1	Application management
*/

/*
TABLE FILE REPORTINGSERVICES_AD                           --> dit is SQLSERVER-05-Tabel waarin AD-user is opgeslagen !!!
PRINT
	COMBINEDEMAIL	NOPRINT
	COMPUTE EMAIL/A256 = LOCASE(256, COMBINEDEMAIL, 'A256');
 
BY WINDOWSACCOUNT	NOPRINT
 
WHERE WINDOWSACCOUNT EQ '&_UID'; ON TABLE HOLD AS UNI00403H_WINDOWSACCOUNT FORMAT ALPHA
END
*/

REPORTINGSERVICES_AD
Deze vind ik terug onder WEBFOCUS/MASTER_MISCELLANEOUS
Tabel die wordt geraadpleegd voor ophalen van USER-AD-account icm EMAIL-adres
SEGNAME=REPORTINGSERVICES_AD, 
   CARDINALITY=6376, 
   TABLENAME=General.dbo."reportingservices_ad", 
   CONNECTION=ENSSQL05, 
   KEYS=0, $


/*
-:NOADID
JOIN
	DEF_UP IN UVAD TAG unilab TO
	UP IN UVUPAU TAG profattr AS J1
END
DEFINE FILE UVAD
	LEMAIL/A256 = LOCASE(256, unilab.EMAIL, 'A256');
END
TABLE FILE UVAD
SUM COMPUTE _USERGROUP/A40	= profattr.VALUE;
	COMPUTE _USERID/A20		= AD;
 
BY AD NOPRINT
 
WHERE &LEMAIL IN FILE UNI00403H_WINDOWSACCOUNT;          --> WINDOWS-ACCOUNT !!!!
WHERE unilab.AD EQ '&UNI_ID';
WHERE profattr.AU EQ 'user_group';
WHERE SS NE '@O';
*/
 






SELECT prof.up
,      prof.description
,      user_group.up
,      user_group.au      user_group_au
,      user_group.value   user_group_value
FROM  utup   prof
INNER JOIN  utupau user_group  ON (prof.up = user_group.up)
order by prof.up, user_group_au
/*
1	Application management	1	avUpClass		Application management
1	Application management	1	user_group		Application management
2	Viewers					2	user_group		Viewers
3	Preparation lab			3	avManagedByUp	22
3	Preparation lab			3	avUpClass		Execution
3	Preparation lab			3	user_group		Preparation lab
4	Preparation lab mgt		4	avUpClass		Lab management
4	Preparation lab mgt		4	user_group		Preparation lab
5	Physical lab			5	avManagedByUp	22
5	Physical lab			5	avUpClass		Execution
5	Physical lab			5	user_group		Physical lab
6	Physical lab mgt		6	avUpClass		Lab management
6	Physical lab mgt		6	user_group		Physical lab
7	Chemical lab			7	avManagedByUp	22
7	Chemical lab			7	avUpClass		Execution
7	Chemical lab			7	user_group		Chemical lab
8	Chemical lab mgt		8	avUpClass		Lab management
8	Chemical lab mgt		8	user_group		Chemical lab
9	Certificate control		9	avUpClass		Execution
9	Certificate control		9	user_group		Certificate control
10	Tyre testing std		10	avManagedByUp	11
10	Tyre testing std		10	avUpClass		Execution
10	Tyre testing std		10	user_group		Indoor testing
11	Tyre testing std mgt	11	avUpClass		Lab management
11	Tyre testing std mgt	11	user_group		Indoor testing
12	Tyre testing adv.		12	avManagedByUp	13
12	Tyre testing adv.		12	avUpClass		Execution
12	Tyre testing adv.		12	user_group		Outdoor testing
13	Tyre testing adv mgt	13	avUpClass		Lab management
13	Tyre testing adv mgt	13	user_group		Outdoor testing
14	Process tech. VF		14	avUpClass		Development
14	Process tech. VF		14	user_group		Process tech. VF
15	Process tech. VF mgt	15	avUpClass		Lab management
15	Process tech. VF mgt	15	user_group		Process tech. VF
16	Process tech. BV		16	avUpClass		Development
16	Process tech. BV		16	user_group		Process tech. BV
17	Process tech. BV mgt	17	avUpClass		Lab management
17	Process tech. BV mgt	17	user_group		Process tech. BV
20	Purchasing				20	user_group		Purchasing
22	Material lab mgt		22	avUpClass		Lab management
22	Material lab mgt		22	user_group		Material lab
23	QEA						23	avUpClass		Development
23	QEA						23	user_group		QEA
24	Compounding				24	avUpClass		Development
24	Compounding				24	user_group		Compounding
25	Reinforcement			25	avUpClass		Development
25	Reinforcement			25	user_group		Reinforcement
26	Construction PCT		26	avUpClass		Development
26	Construction PCT		26	user_group		Construction PCT
27	Research				27	avUpClass		Development
27	Research				27	user_group		Research
28	Proto PCT				28	avUpClass		Lab management
28	Proto PCT				28	avUpClass		Execution
28	Proto PCT				28	user_group		Proto PCT
29	Proto Extrusion			29	avUpClass		Execution
29	Proto Extrusion			29	avUpClass		Lab management
29	Proto Extrusion			29	user_group		Proto Extrusion
30	Proto Mixing			30	avUpClass		Lab management
30	Proto Mixing			30	avUpClass		Execution
30	Proto Mixing			30	user_group		Proto Mixing
31	Proto Tread				31	avUpClass		Execution
31	Proto Tread				31	avUpClass		Lab management
31	Proto Tread				31	user_group		Proto Tread
32	Proto Calander			32	avUpClass		Lab management
32	Proto Calander			32	avUpClass		Execution
32	Proto Calander			32	user_group		Proto Calander
33	Construction AT			33	avUpClass		Development
33	Construction AT			33	user_group		Construction AT
34	Proto AT				34	avUpClass		Lab management
34	Proto AT				34	avUpClass		Execution
34	Proto AT				34	user_group		Proto AT
35	Construction SM			35	avUpClass		Development
35	Construction SM			35	user_group		Construction SM
36	FEA						36	avManagedByUp	37
36	FEA						36	avUpClass		Execution
36	FEA						36	user_group		FEA
37	FEA mgt					37	avUpClass		Lab management
37	FEA mgt					37	user_group		FEA
38	Tyre Order				38	user_group		Tyre Order
39	BAM mgt					39	avUpClass		Lab management
39	BAM mgt					39	user_group		BAM
40	BAM						40	avUpClass		Development
40	BAM						40	user_group		BAM
42	Construction TBR		42	avUpClass		Development
42	Construction TBR		42	user_group		Construction PCT
43	Raw Materials			43	avSite			Chennai
44	Construction TWT		44	avUpClass		Development
44	Construction TWT		44	user_group		Construction PCT
45	Raw Materials Chennai	45	avSite			Chennai
47	Tyre mounting std		47	avManagedByUp	11
47	Tyre mounting std		47	avUpClass		Execution
47	Tyre mounting std		47	user_group		Indoor testing
*/
SELECT prof.up
,      prof.description
,      user_group.up
,      user_group.au      user_group_au
,      user_group.value   user_group_value
,      user_class.up
,      user_class.au      user_class_au
,      user_class.value   user_class_value
FROM  utup   prof
INNER JOIN  utupau user_group  ON (prof.up = user_group.up)
INNER JOIN  utupau user_class ON (	user_class.up      = user_group.up
								AND user_class.version = user_group.version
								--and user_class.au      = user_group.au
								AND user_class.au      = 'avUpClass'
								AND user_class.value   = 'Execution'
								)
/*
3	Preparation lab		3	avManagedByUp	22	3	avUpClass	Execution
3	Preparation lab		3	avUpClass		Execution	3	avUpClass	Execution
3	Preparation lab		3	user_group		Preparation lab	3	avUpClass	Execution
5	Physical lab		5	avManagedByUp	22	5	avUpClass	Execution
5	Physical lab		5	avUpClass		Execution	5	avUpClass	Execution
5	Physical lab		5	user_group		Physical lab	5	avUpClass	Execution
7	Chemical lab		7	avManagedByUp	22	7	avUpClass	Execution
7	Chemical lab		7	avUpClass		Execution	7	avUpClass	Execution
7	Chemical lab		7	user_group		Chemical lab	7	avUpClass	Execution
9	Certificate control	9	avUpClass		Execution	9	avUpClass	Execution
9	Certificate control	9	user_group		Certificate control	9	avUpClass	Execution
10	Tyre testing std	10	avManagedByUp	11	10	avUpClass	Execution
10	Tyre testing std	10	avUpClass		Execution	10	avUpClass	Execution
10	Tyre testing std	10	user_group		Indoor testing	10	avUpClass	Execution
12	Tyre testing adv.	12	avManagedByUp	13	12	avUpClass	Execution
12	Tyre testing adv.	12	avUpClass		Execution	12	avUpClass	Execution
12	Tyre testing adv.	12	user_group		Outdoor testing	12	avUpClass	Execution
28	Proto PCT			28	avUpClass		Execution	28	avUpClass	Execution
28	Proto PCT			28	avUpClass		Lab management	28	avUpClass	Execution
28	Proto PCT			28	user_group		Proto PCT	28	avUpClass	Execution
29	Proto Extrusion		29	avUpClass		Execution	29	avUpClass	Execution
29	Proto Extrusion		29	avUpClass		Lab management	29	avUpClass	Execution
29	Proto Extrusion		29	user_group		Proto Extrusion	29	avUpClass	Execution
30	Proto Mixing		30	avUpClass		Execution	30	avUpClass	Execution
30	Proto Mixing		30	avUpClass		Lab management	30	avUpClass	Execution
30	Proto Mixing		30	user_group		Proto Mixing	30	avUpClass	Execution
31	Proto Tread			31	avUpClass		Execution	31	avUpClass	Execution
31	Proto Tread			31	avUpClass		Lab management	31	avUpClass	Execution
31	Proto Tread			31	user_group		Proto Tread	31	avUpClass	Execution
32	Proto Calander		32	avUpClass		Execution	32	avUpClass	Execution
32	Proto Calander		32	avUpClass		Lab management	32	avUpClass	Execution
32	Proto Calander		32	user_group		Proto Calander	32	avUpClass	Execution
34	Proto AT			34	avUpClass		Lab management	34	avUpClass	Execution
34	Proto AT			34	avUpClass		Execution	34	avUpClass	Execution
34	Proto AT			34	user_group		Proto AT	34	avUpClass	Execution
36	FEA					36	avManagedByUp	37	36	avUpClass	Execution
36	FEA					36	avUpClass		Execution	36	avUpClass	Execution
36	FEA					36	user_group		FEA	36	avUpClass	Execution
47	Tyre mounting std	47	avManagedByUp	11	47	avUpClass	Execution
47	Tyre mounting std	47	avUpClass		Execution	47	avUpClass	Execution
47	Tyre mounting std	47	user_group		Indoor testing	47	avUpClass	Execution
*/

SELECT prof.up
,      prof.description
--,      user_group.up
,      user_group.au      user_group_au
,      user_group.value   user_group_value
--,      user_class.up
,      user_class.au      user_class_au
,      user_class.value   user_class_value
,      pref.us
,      pref.pref_name
,      pref.pref_value
,      dprf.pref_name
,      dprf.pref_value
,	COALESCE(NULLIF(pref.pref_value, '-'), NULLIF(dprf.pref_value, '-')) AS prof_lab
,	COALESCE(NULLIF(pref.pref_value, '-'), NULLIF(dprf.pref_value, '-'), 'NULL') AS prof_lab2
FROM  utup   prof
INNER JOIN  utupau user_group  ON (prof.up = user_group.up)
INNER JOIN  utupau user_class ON (	user_class.up      = user_group.up
								AND user_class.version = user_group.version
								--and user_class.au      = user_group.au
								AND user_class.au      = 'avUpClass'
								AND user_class.value   = 'Execution'
								)
LEFT OUTER JOIN utupuspref pref ON (	pref.up = prof.up
									AND pref.version = prof.version
									AND pref.pref_name = 'lab'
									AND pref.us = 'PSC'  --'PSC'    --'++USER_ID'
									)
LEFT OUTER JOIN utuppref dprf ON (		dprf.up	= prof.up
								AND dprf.version = prof.version
								AND dprf.pref_name = 'lab'
								)
where prof.version_is_current = '1' 
order by prof.up
;

/*
										USER-GROUP-VALUE
3	Preparation lab		avManagedByUp	22				avUpClass	Execution				lab	PV RnD	PV RnD	PV RnD
3	Preparation lab		avUpClass		Execution		avUpClass	Execution				lab	PV RnD	PV RnD	PV RnD
3	Preparation lab		user_group		Preparation lab	avUpClass	Execution				lab	PV RnD	PV RnD	PV RnD
5	Physical lab		avManagedByUp	22				avUpClass	Execution				lab	PV RnD	PV RnD	PV RnD
5	Physical lab		avUpClass		Execution		avUpClass	Execution				lab	PV RnD	PV RnD	PV RnD
5	Physical lab		user_group		Physical lab	avUpClass	Execution				lab	PV RnD	PV RnD	PV RnD
7	Chemical lab		avManagedByUp	22				avUpClass	Execution				lab	PV RnD	PV RnD	PV RnD
7	Chemical lab		avUpClass		Execution		avUpClass	Execution				lab	PV RnD	PV RnD	PV RnD
7	Chemical lab		user_group		Chemical lab	avUpClass	Execution				lab	PV RnD	PV RnD	PV RnD
9	Certificate control	avUpClass		Execution		avUpClass	Execution							NULL
9	Certificate control	user_group		Certificate control	avUpClass	Execution							NULL
10	Tyre testing std	avManagedByUp	11				avUpClass	Execution				lab	Gyongyos	Gyongyos	Gyongyos
10	Tyre testing std	avUpClass		Execution		avUpClass	Execution				lab	Gyongyos	Gyongyos	Gyongyos
10	Tyre testing std	user_group		Indoor testing	avUpClass	Execution				lab	Gyongyos	Gyongyos	Gyongyos
12	Tyre testing adv.	avManagedByUp	13				avUpClass	Execution							NULL
12	Tyre testing adv.	avUpClass		Execution		avUpClass	Execution							NULL
12	Tyre testing adv.	user_group		Outdoor testing	avUpClass	Execution							NULL
28	Proto PCT			avUpClass		Execution		avUpClass	Execution							NULL
28	Proto PCT			avUpClass		Lab management	avUpClass	Execution							NULL
28	Proto PCT			user_group		Proto PCT		avUpClass	Execution							NULL
29	Proto Extrusion		avUpClass		Execution		avUpClass	Execution							NULL
29	Proto Extrusion		avUpClass		Lab management	avUpClass	Execution							NULL
29	Proto Extrusion		user_group		Proto Extrusion	avUpClass	Execution							NULL
30	Proto Mixing		avUpClass		Execution		avUpClass	Execution							NULL
30	Proto Mixing		avUpClass		Lab management	avUpClass	Execution							NULL
30	Proto Mixing		user_group		Proto Mixing	avUpClass	Execution							NULL
31	Proto Tread			avUpClass		Execution		avUpClass	Execution							NULL
31	Proto Tread			avUpClass		Lab management	avUpClass	Execution							NULL
31	Proto Tread			user_group		Proto Tread		avUpClass	Execution							NULL
32	Proto Calander		avUpClass		Execution		avUpClass	Execution				lab	Enschede	Enschede	Enschede
32	Proto Calander		avUpClass		Lab management	avUpClass	Execution				lab	Enschede	Enschede	Enschede
32	Proto Calander		user_group		Proto Calander	avUpClass	Execution				lab	Enschede	Enschede	Enschede
34	Proto AT			avUpClass		Lab management	avUpClass	Execution							NULL
34	Proto AT			avUpClass		Execution		avUpClass	Execution							NULL
34	Proto AT			user_group		Proto AT		avUpClass	Execution							NULL
36	FEA					avManagedByUp	37				avUpClass	Execution				lab	PV RnD	PV RnD	PV RnD
36	FEA					avUpClass		Execution		avUpClass	Execution				lab	PV RnD	PV RnD	PV RnD
36	FEA					user_group		FEA				avUpClass	Execution				lab	PV RnD	PV RnD	PV RnD
47	Tyre mounting std	avManagedByUp	11				avUpClass	Execution				lab	Enschede	Enschede	Enschede
47	Tyre mounting std	avUpClass		Execution		avUpClass	Execution				lab	Enschede	Enschede	Enschede
47	Tyre mounting std	user_group		Indoor testing	avUpClass	Execution				lab	Enschede	Enschede	Enschede

3	Preparation lab		avManagedByUp	22				avUpClass	Execution						lab	PV RnD		PV RnD		PV RnD
3	Preparation lab		avUpClass		Execution		avUpClass	Execution						lab	PV RnD		PV RnD		PV RnD
3	Preparation lab		user_group		Preparation lab	avUpClass	Execution						lab	PV RnD		PV RnD		PV RnD
5	Physical lab		avManagedByUp	22				avUpClass	Execution	PGO	lab	Enschede	lab	PV RnD		Enschede	Enschede
5	Physical lab		avUpClass		Execution		avUpClass	Execution	PGO	lab	Enschede	lab	PV RnD		Enschede	Enschede
5	Physical lab		user_group		Physical lab	avUpClass	Execution	PGO	lab	Enschede	lab	PV RnD		Enschede	Enschede
7	Chemical lab		avManagedByUp	22				avUpClass	Execution	PGO	lab	PV RnD		lab	PV RnD		PV RnD		PV RnD
7	Chemical lab		avUpClass		Execution		avUpClass	Execution	PGO	lab	PV RnD		lab	PV RnD		PV RnD		PV RnD
7	Chemical lab		user_group		Chemical lab	avUpClass	Execution	PGO	lab	PV RnD		lab	PV RnD		PV RnD		PV RnD
9	Certificate control	avUpClass		Execution		avUpClass	Execution													NULL
9	Certificate control	user_group		Certificate control	avUpClass	Execution												NULL
10	Tyre testing std	avManagedByUp	11				avUpClass	Execution	PGO	lab	Enschede	lab	Gyongyos	Enschede	Enschede
10	Tyre testing std	avUpClass		Execution		avUpClass	Execution	PGO	lab	Enschede	lab	Gyongyos	Enschede	Enschede
10	Tyre testing std	user_group		Indoor testing	avUpClass	Execution	PGO	lab	Enschede	lab	Gyongyos	Enschede	Enschede
12	Tyre testing adv.	avManagedByUp	13				avUpClass	Execution	PGO	lab	Enschede					Enschede	Enschede
12	Tyre testing adv.	avUpClass		Execution		avUpClass	Execution	PGO	lab	Enschede					Enschede	Enschede
12	Tyre testing adv.	user_group		Outdoor testing	avUpClass	Execution	PGO	lab	Enschede					Enschede	Enschede
28	Proto PCT			avUpClass		Execution		avUpClass	Execution													NULL
28	Proto PCT			avUpClass		Lab management	avUpClass	Execution													NULL
28	Proto PCT			user_group		Proto PCT		avUpClass	Execution													NULL
29	Proto Extrusion		avUpClass		Execution		avUpClass	Execution													NULL
29	Proto Extrusion		avUpClass		Lab management	avUpClass	Execution													NULL
29	Proto Extrusion		user_group		Proto Extrusion	avUpClass	Execution													NULL
30	Proto Mixing		avUpClass		Execution		avUpClass	Execution													NULL
30	Proto Mixing		avUpClass		Lab management	avUpClass	Execution													NULL
30	Proto Mixing		user_group		Proto Mixing	avUpClass	Execution													NULL
31	Proto Tread			avUpClass		Execution		avUpClass	Execution													NULL
31	Proto Tread			avUpClass		Lab management	avUpClass	Execution													NULL
31	Proto Tread			user_group		Proto Tread		avUpClass	Execution													NULL
32	Proto Calander		avUpClass		Execution		avUpClass	Execution						lab	Enschede	Enschede	Enschede
32	Proto Calander		avUpClass		Lab management	avUpClass	Execution						lab	Enschede	Enschede	Enschede
32	Proto Calander		user_group		Proto Calander	avUpClass	Execution						lab	Enschede	Enschede	Enschede
34	Proto AT			avUpClass		Lab management	avUpClass	Execution													NULL
34	Proto AT			avUpClass		Execution		avUpClass	Execution													NULL
34	Proto AT			user_group		Proto AT		avUpClass	Execution													NULL
36	FEA					avManagedByUp	37				avUpClass	Execution						lab	PV RnD		PV RnD		PV RnD
36	FEA					avUpClass		Execution		avUpClass	Execution						lab	PV RnD		PV RnD		PV RnD
36	FEA					user_group		FEA				avUpClass	Execution						lab	PV RnD		PV RnD		PV RnD
47	Tyre mounting std	avManagedByUp	11				avUpClass	Execution						lab	Enschede	Enschede	Enschede
47	Tyre mounting std	avUpClass		Execution		avUpClass	Execution						lab	Enschede	Enschede	Enschede
47	Tyre mounting std	user_group		Indoor testing	avUpClass	Execution						lab	Enschede	Enschede	Enschede

*/

select user_group, count(*) from utscmegkuser_group group by user_group;
/*
Chemical lab			76761
FEA						185264
Indoor testing			915578
Material lab			1877428
Outdoor testing			148275
Physical lab			1413200
Preparation lab			387467
Process tech. VF		686765
Proto AT				67
Proto Calander			1194
Proto Extrusion			7593
Proto Mixing			26465
Proto PCT				1438
Raw material mgt		192
Research				827
Tyre Order				3433
Tyre mounting std		31758
Tyre testing			3433
Tyre testing adv.		148275
Tyre testing std		915578
Tyre testing std mgt	6093
Tyres test standard		9
*/


SELECT prof.up
,      prof.description
,      user_group.au      user_group_au
,      user_group.value   user_group_value
,      user_class.au      user_class_au
,      user_class.value   user_class_value
,      pref.us
,	COALESCE(NULLIF(pref.pref_value, '-'), NULLIF(dprf.pref_value, '-')) AS prof_lab
,	COALESCE(NULLIF(pref.pref_value, '-'), NULLIF(dprf.pref_value, '-'), 'NULL') AS prof_lab2
,	COUNT(DISTINCT utscme.me) AS me_count
FROM  utup   prof
INNER JOIN  utupau user_group  ON (prof.up = user_group.up)
INNER JOIN  utupau user_class ON (	user_class.up      = user_group.up
								AND user_class.version = user_group.version
								AND user_class.au      = 'avUpClass'
								AND user_class.value   = 'Execution'
								)
LEFT OUTER JOIN utupuspref pref ON (	pref.up = prof.up
									AND pref.version = prof.version
									AND pref.pref_name = 'lab'
									AND pref.us = 'PGO'  --'PSC'    --'++USER_ID'
									)
LEFT OUTER JOIN utuppref dprf ON (		dprf.up	= prof.up
								AND dprf.version = prof.version
								AND dprf.pref_name = 'lab'
								)
INNER JOIN utscmegkuser_group   me_user_group   ON (me_user_group.user_group = user_group.value )  --ORIGINEEL:   user_group.value  !!!!MAAR DAN WERKT HET NIET: WEL: prof.description
INNER JOIN utscme ON (	utscme.SC     = me_user_group.SC
					AND utscme.PG     = me_user_group.PG
					AND utscme.PGNODE = me_user_group.PGNODE
					AND utscme.PA     = me_user_group.PA
					AND utscme.PANODE = me_user_group.PANODE
					AND utscme.ME     = me_user_group.ME
					AND utscme.MENODE = me_user_group.MENODE
					AND (	(pref.pref_value IS NOT NULL AND pref.pref_value = utscme.lab)
						OR	(dprf.pref_value IS NOT NULL AND dprf.pref_value = utscme.lab)
						OR	(pref.pref_value IS NULL     AND dprf.pref_value IS NULL       AND NULLIF(utscme.lab, '-') IS NULL)
						)
					)
where prof.version_is_current = '1' 
GROUP BY prof.up
,        prof.description
,      user_group.au
,      user_group.value
,      user_class.au   
,      user_class.value
,      pref.us
,	COALESCE(NULLIF(pref.pref_value, '-'), NULLIF(dprf.pref_value, '-')) 
,	COALESCE(NULLIF(pref.pref_value, '-'), NULLIF(dprf.pref_value, '-'), 'NULL') 
ORDER BY prof.up
;
 
/*#
--PGO: JOIN VIA: ME_USER_GROUP.USER_GROUP = user_group.value
3	Preparation lab		user_group	Preparation lab	avUpClass	Execution		PV RnD		PV RnD		53
5	Physical lab		user_group	Physical lab	avUpClass	Execution	PGO	Enschede	Enschede	288
7	Chemical lab		user_group	Chemical lab	avUpClass	Execution	PGO	PV RnD		PV RnD		122
10	Tyre testing std	user_group	Indoor testing	avUpClass	Execution	PGO	Enschede	Enschede	354   (PSC heeft er maar 181)
12	Tyre testing adv.	user_group	Outdoor testing	avUpClass	Execution	PGO	Enschede	Enschede	13    
28	Proto PCT			user_group	Proto PCT		avUpClass	Execution					NULL		11
29	Proto Extrusion		user_group	Proto Extrusion	avUpClass	Execution					NULL		3
30	Proto Mixing		user_group	Proto Mixing	avUpClass	Execution					NULL		3
32	Proto Calander		user_group	Proto Calander	avUpClass	Execution		Enschede	Enschede	4
34	Proto AT			user_group	Proto AT		avUpClass	Execution					NULL		5
36	FEA					user_group	FEA				avUpClass	Execution		PV RnD		PV RnD		87
47	Tyre mounting std	user_group	Indoor testing	avUpClass	Execution		Enschede	Enschede	340

--PSC
3	Preparation lab		user_group	Preparation lab	avUpClass	Execution		PV RnD		PV RnD		53
5	Physical lab		user_group	Physical lab	avUpClass	Execution		PV RnD		PV RnD		287
7	Chemical lab		user_group	Chemical lab	avUpClass	Execution		PV RnD		PV RnD		122
10	Tyre testing std	user_group	Indoor testing	avUpClass	Execution		Gyongyos	Gyongyos	181
12	Tyre testing adv.	user_group	Outdoor testing	avUpClass	Execution					NULL		63
28	Proto PCT			user_group	Proto PCT		avUpClass	Execution					NULL		11
29	Proto Extrusion		user_group	Proto Extrusion	avUpClass	Execution					NULL		3
30	Proto Mixing		user_group	Proto Mixing	avUpClass	Execution					NULL		3
32	Proto Calander		user_group	Proto Calander	avUpClass	Execution		Enschede	Enschede	4
34	Proto AT			user_group	Proto AT		avUpClass	Execution					NULL		5
36	FEA					user_group	FEA				avUpClass	Execution		PV RnD		PV RnD		87
47	Tyre mounting std	user_group	Indoor testing	avUpClass	Execution		Enschede	Enschede	340

*/ 
 
 
select count(*),user_group from utscmegkuser_group group by user_group;
/*
76757	Chemical lab
185264	FEA
915556	Indoor testing
1877416	Material lab
148275	Outdoor testing
1413192	Physical lab
387467	Preparation lab
686765	Process tech. VF
67		Proto AT
1194	Proto Calander
7593	Proto Extrusion
26465	Proto Mixing
1438	Proto PCT
192		Raw material mgt
827		Research
3433	Tyre Order
31754	Tyre mounting std
3433	Tyre testing
148275	Tyre testing adv.
915556	Tyre testing std
6093	Tyre testing std mgt
9		Tyres test standard
--
--CONCLUSIE: UTUPAU.USER_GROUP (ONLY execution and Lab Management) <> UTSCMEGKUSER_GROUP 
--           USER-GROUP = gelijk aan UTUP.DESRIPTION !!!
*/
 

SELECT prof.up
,      prof.description
,      user_group.au      user_group_au
,      user_group.value   user_group_value
,      user_class.au      user_class_au
,      user_class.value   user_class_value
,      pref.us
,	COALESCE(NULLIF(pref.pref_value, '-'), NULLIF(dprf.pref_value, '-')) AS prof_lab
,	COALESCE(NULLIF(pref.pref_value, '-'), NULLIF(dprf.pref_value, '-'), 'NULL') AS prof_lab2
,	COUNT(DISTINCT utscme.me) AS me_count
FROM  utup   prof
INNER JOIN  utupau user_group  ON (prof.up = user_group.up)
INNER JOIN  utupau user_class ON (	user_class.up      = user_group.up
								AND user_class.version = user_group.version
								AND user_class.au      = 'avUpClass'
								AND user_class.value   = 'Execution'
								)
LEFT OUTER JOIN utupuspref pref ON (	pref.up = prof.up
									AND pref.version = prof.version
									AND pref.pref_name = 'lab'
									AND pref.us = 'PGO'  --'PSC'    --'++USER_ID'
									)
LEFT OUTER JOIN utuppref dprf ON (		dprf.up	= prof.up
								AND dprf.version = prof.version
								AND dprf.pref_name = 'lab'
								)
INNER JOIN utscmegkuser_group   me_user_group   ON (me_user_group.user_group = user_group.value )  
INNER JOIN utscme ON (	utscme.SC     = me_user_group.SC
					AND utscme.PG     = me_user_group.PG
					AND utscme.PGNODE = me_user_group.PGNODE
					AND utscme.PA     = me_user_group.PA
					AND utscme.PANODE = me_user_group.PANODE
					AND utscme.ME     = me_user_group.ME
					AND utscme.MENODE = me_user_group.MENODE
					AND (	(pref.pref_value IS NOT NULL AND pref.pref_value = utscme.lab)
						OR	(dprf.pref_value IS NOT NULL AND dprf.pref_value = utscme.lab)
						OR	(pref.pref_value IS NULL     AND dprf.pref_value IS NULL       AND NULLIF(utscme.lab, '-') IS NULL)
						)
					)
INNER JOIN      utss ss_me ON (utscme.ss = ss_me.ss)
INNER JOIN      utsc       ON (utscme.sc = utsc.sc)
INNER JOIN      utss ss_sc ON (utsc.ss   = ss_sc.ss)
LEFT OUTER JOIN utrq       ON (utsc.rq = utrq.rq)
LEFT OUTER JOIN utss ss_rq ON (utrq.ss = ss_rq.ss) 
where prof.version_is_current = '1' 
and user_group.au = 'user_group'
--AND user_group.value = 'Chemical lab'  -- '++USER_GROUP'
AND (	utscme.ss IN ('AV', '@P', 'IE', 'OS', 'OW', 'WA', 'ER')
	OR	(   utscme.ss = 'CM' 
	    AND utsc.ss IN ('OS', 'OW')
		)
    )
AND (  utrq.ss IN ('AV', '@P', 'SU') 
    OR utsc.rq IS NULL)
GROUP BY prof.up
,        prof.description
,      user_group.au
,      user_group.value
,      user_class.au   
,      user_class.value
,      pref.us
,	COALESCE(NULLIF(pref.pref_value, '-'), NULLIF(dprf.pref_value, '-')) 
,	COALESCE(NULLIF(pref.pref_value, '-'), NULLIF(dprf.pref_value, '-'), 'NULL') 
ORDER BY prof.up
;

/*
--USER-GROUP: Chemical lab:
7	Chemical lab	user_group	Chemical lab	avUpClass	Execution	PGO	PV RnD	PV RnD	49

--ALLE user-groups PSC:
3	Preparation lab		user_group	Preparation lab	avUpClass	Execution		PV RnD		PV RnD		23
5	Physical lab		user_group	Physical lab	avUpClass	Execution	PGO	Enschede	Enschede	122
7	Chemical lab		user_group	Chemical lab	avUpClass	Execution	PGO	PV RnD		PV RnD		49
10	Tyre testing std	user_group	Indoor testing	avUpClass	Execution	PGO	Enschede	Enschede	223
12	Tyre testing adv.	user_group	Outdoor testing	avUpClass	Execution	PGO	Enschede	Enschede	1
28	Proto PCT			user_group	Proto PCT		avUpClass	Execution					NULL		3
29	Proto Extrusion		user_group	Proto Extrusion	avUpClass	Execution					NULL		1
32	Proto Calander		user_group	Proto Calander	avUpClass	Execution		Enschede	Enschede	4
36	FEA					user_group	FEA				avUpClass	Execution		PV RnD		PV RnD		55
47	Tyre mounting std	user_group	Indoor testing	avUpClass	Execution		Enschede	Enschede	194
*/


SELECT prof.up
,      prof.description
,      user_group.au      user_group_au
,      user_group.value   user_group_value
,      user_class.au      user_class_au
,      user_class.value   user_class_value
,      pref.us
,	COALESCE(NULLIF(pref.pref_value, '-'), NULLIF(dprf.pref_value, '-'))         AS prof_lab
,	COALESCE(NULLIF(pref.pref_value, '-'), NULLIF(dprf.pref_value, '-'), 'NULL') AS prof_lab2
,   utrq.rq       as request_code
,	utscme.ss     AS me_ss
,   ss_me.name    AS me_ss_name
,	utsc.ss       AS sc_ss
,   ss_sc.name    AS sc_ss_name
,   utsc.priority AS sc_priority
,	CASE WHEN utsc.priority < 4 THEN utsc.sc ELSE NULL END AS sc_prio_lt_4
,	CASE WHEN utsc.priority < 3 THEN utsc.sc ELSE NULL END AS sc_prio_lt_3
,	CASE WHEN utsc.priority = 1 THEN utsc.sc ELSE NULL END AS sc_prio_eq_1
,	sccontext.context        AS sc_context
,	utsc.sc
,	utrq.ss                  AS rq_ss
,   ss_rq.name               AS rq_ss_name
,   utrq.priority            AS rq_priority
,	CAST(utrq.date1 AS date) AS rq_reqd_ready
,	CASE WHEN utrq.date1 IS NOT NULL AND utrq.date1 < TRUNC(SYSDATE) THEN utrq.rq ELSE NULL END                                           AS rq_overdue
,	CASE WHEN utrq.date1 IS NOT NULL AND utrq.date1 >= TRUNC(SYSDATE) AND utrq.date1 < TRUNC(SYSDATE) + 7 THEN utrq.rq ELSE NULL END      AS rq_due_1wk
,	CASE WHEN utrq.date1 IS NOT NULL AND utrq.date1 >= TRUNC(SYSDATE) + 7 AND utrq.date1 < TRUNC(SYSDATE) + 14 THEN utrq.rq ELSE NULL END AS rq_due_3wk           --++LATE_D = 14
,	CASE WHEN utrq.date1 IS NOT NULL AND utrq.date1 >= TRUNC(SYSDATE) + 14 THEN utrq.rq ELSE NULL END                                     AS rq_due               --++LATE_D = 14
,	CASE WHEN utrq.priority < 4 THEN utrq.rq ELSE NULL END AS rq_prio_lt_4
,	CASE WHEN utrq.priority < 3 THEN utrq.rq ELSE NULL END AS rq_prio_lt_3
,	CASE WHEN utrq.priority = 1 THEN utrq.rq ELSE NULL END AS rq_prio_eq_1
,	rqexecwk.RqExecutionWeek          AS rq_exec_week
,	to_number(to_char(SYSDATE, 'IW')) AS this_week
,	utrq.rq
,	COUNT(DISTINCT utscme.me)         AS me_count
FROM  utup   prof
INNER JOIN  utupau user_group  ON (prof.up = user_group.up)
INNER JOIN  utupau user_class ON (	user_class.up      = user_group.up
								AND user_class.version = user_group.version
								AND user_class.au      = 'avUpClass'
								AND user_class.value   = 'Execution'
								)
LEFT OUTER JOIN utupuspref pref ON (	pref.up = prof.up
									AND pref.version = prof.version
									AND pref.pref_name = 'lab'
									AND pref.us = 'PGO'  --'PSC'    --'++USER_ID'
									)
LEFT OUTER JOIN utuppref dprf ON (		dprf.up	= prof.up
								AND dprf.version = prof.version
								AND dprf.pref_name = 'lab'
								)
INNER JOIN utscmegkuser_group   me_user_group   ON (me_user_group.user_group = user_group.value )  
INNER JOIN utscme ON (	utscme.SC     = me_user_group.SC
					AND utscme.PG     = me_user_group.PG
					AND utscme.PGNODE = me_user_group.PGNODE
					AND utscme.PA     = me_user_group.PA
					AND utscme.PANODE = me_user_group.PANODE
					AND utscme.ME     = me_user_group.ME
					AND utscme.MENODE = me_user_group.MENODE
					AND (	(pref.pref_value IS NOT NULL AND pref.pref_value = utscme.lab)
						OR	(dprf.pref_value IS NOT NULL AND dprf.pref_value = utscme.lab)
						OR	(pref.pref_value IS NULL     AND dprf.pref_value IS NULL       AND NULLIF(utscme.lab, '-') IS NULL)
						)
					)
INNER JOIN      utss ss_me ON (utscme.ss = ss_me.ss)
INNER JOIN      utsc       ON (utscme.sc = utsc.sc)
INNER JOIN      utss ss_sc ON (utsc.ss   = ss_sc.ss)
LEFT OUTER JOIN utrq       ON (utsc.rq = utrq.rq)
LEFT OUTER JOIN utss ss_rq ON (utrq.ss = ss_rq.ss) 
LEFT OUTER JOIN utscgkcontext         sccontext ON (sccontext.sc = utsc.sc )
LEFT OUTER JOIN utrqgkRqExecutionWeek rqexecwk  ON (   rqexecwk.rq = utrq.rq	
                                                   AND rqexecwk.RqExecutionWeek = to_char(SYSDATE, 'FMIW') )
where prof.version_is_current = '1' 
and user_group.au    = 'user_group'
AND user_group.value = 'Physical lab'  --'Chemical lab'     -- '++USER_GROUP'
AND (	utscme.ss IN ('AV', '@P', 'IE', 'OS', 'OW', 'WA', 'ER')
	OR	(   utscme.ss = 'CM' 
	    AND utsc.ss IN ('OS', 'OW')
		)
    )
AND (  utrq.ss IN ('AV', '@P', 'SU') 
    OR utsc.rq IS NULL)
AND NOT EXISTS (SELECT 1
				FROM utrqgkistest rqistest
				WHERE rqistest.rq = utrq.rq
				AND rqistest.istest = '1'
				)
AND NOT EXISTS (SELECT 1
				FROM utscgkistest scistest
				WHERE scistest.sc = utsc.sc
				AND scistest.istest = '1'
				)
AND NOT EXISTS (SELECT 1
				FROM utscmegkme_is_relevant merelv
				WHERE utscme.sc		= merelv.sc
				AND utscme.pg		= merelv.pg
				AND utscme.pgnode	= merelv.pgnode
				AND utscme.pa		= merelv.pa
				AND utscme.panode	= merelv.panode
				AND utscme.me		= merelv.me
				AND utscme.menode	= merelv.menode
				AND merelv.me_is_relevant	= '0'
				)	
GROUP BY prof.up
,        prof.description
,      user_group.au
,      user_group.value
,      user_class.au   
,      user_class.value
,      pref.us
,	COALESCE(NULLIF(pref.pref_value, '-'), NULLIF(dprf.pref_value, '-')) 
,	COALESCE(NULLIF(pref.pref_value, '-'), NULLIF(dprf.pref_value, '-'), 'NULL') 
,	utscme.ss     
,   ss_me.name    
,	utsc.ss       
,   ss_sc.name    
,   utsc.priority 
,	CASE WHEN utsc.priority < 4 THEN utsc.sc ELSE NULL END 
,	CASE WHEN utsc.priority < 3 THEN utsc.sc ELSE NULL END 
,	CASE WHEN utsc.priority = 1 THEN utsc.sc ELSE NULL END 
,	sccontext.context        
,	utsc.sc
,	utrq.ss                  
,   ss_rq.name               
,   utrq.priority            
,	CAST(utrq.date1 AS date) 
,	CASE WHEN utrq.date1 IS NOT NULL AND utrq.date1 < TRUNC(SYSDATE) THEN utrq.rq ELSE NULL END                                                
,	CASE WHEN utrq.date1 IS NOT NULL AND utrq.date1 >= TRUNC(SYSDATE) AND utrq.date1 < TRUNC(SYSDATE) + 7 THEN utrq.rq ELSE NULL END           
,	CASE WHEN utrq.date1 IS NOT NULL AND utrq.date1 >= TRUNC(SYSDATE) + 7 AND utrq.date1 < TRUNC(SYSDATE) + 14 THEN utrq.rq ELSE NULL END     --++LATE_D = 14
,	CASE WHEN utrq.date1 IS NOT NULL AND utrq.date1 >= TRUNC(SYSDATE) + 14 THEN utrq.rq ELSE NULL END                                         --++LATE_D = 14
,	CASE WHEN utrq.priority < 4 THEN utrq.rq ELSE NULL END 
,	CASE WHEN utrq.priority < 3 THEN utrq.rq ELSE NULL END 
,	CASE WHEN utrq.priority = 1 THEN utrq.rq ELSE NULL END 
,	rqexecwk.RqExecutionWeek          
,	to_number(to_char(SYSDATE, 'IW')) 
,	utrq.rq
ORDER BY utrq.rq
,        sccontext.context
,        utsc.sc
,        utscme.ss
;

/*
7	Chemical lab	user_group	Chemical lab	avUpClass	Execution	PGO	PV RnD	PV RnD	@P	Planned	@P	Planned	3	ANM2319049T01			Trials	ANM2319049T01	@P	Planned	3						ANM2319049T				35	ANM2319049T	8
7	Chemical lab	user_group	Chemical lab	avUpClass	Execution	PGO	PV RnD	PV RnD	@P	Planned	@P	Planned	3	ANM2319049T02			Trials	ANM2319049T02	@P	Planned	3						ANM2319049T				35	ANM2319049T	8
7	Chemical lab	user_group	Chemical lab	avUpClass	Execution	PGO	PV RnD	PV RnD	@P	Planned	@P	Planned	3	ANM2319049T03			Trials	ANM2319049T03	@P	Planned	3						ANM2319049T				35	ANM2319049T	8
7	Chemical lab	user_group	Chemical lab	avUpClass	Execution	PGO	PV RnD	PV RnD	@P	Planned	@P	Planned	3	ANM2319049T04			Trials	ANM2319049T04	@P	Planned	3						ANM2319049T				35	ANM2319049T	5
7	Chemical lab	user_group	Chemical lab	avUpClass	Execution	PGO	PV RnD	PV RnD	@P	Planned	@P	Planned	3	ANM2319049T07			Trials	ANM2319049T07	@P	Planned	3						ANM2319049T				35	ANM2319049T	5
7	Chemical lab	user_group	Chemical lab	avUpClass	Execution	PGO	PV RnD	PV RnD	@P	Planned	@P	Planned	3	ANM2319049T10			Trials	ANM2319049T10	@P	Planned	3						ANM2319049T				35	ANM2319049T	5
7	Chemical lab	user_group	Chemical lab	avUpClass	Execution	PGO	PV RnD	PV RnD	@P	Planned	@P	Planned	3	ANM2319049T13			Trials	ANM2319049T13	@P	Planned	3						ANM2319049T				35	ANM2319049T	5
7	Chemical lab	user_group	Chemical lab	avUpClass	Execution	PGO	PV RnD	PV RnD	@P	Planned	@P	Planned	3	ANM2319049T16			Trials	ANM2319049T16	@P	Planned	3						ANM2319049T				35	ANM2319049T	5
7	Chemical lab	user_group	Chemical lab	avUpClass	Execution	PGO	PV RnD	PV RnD	@P	Planned	@P	Planned	3	ANM2319049T19			Trials	ANM2319049T19	@P	Planned	3						ANM2319049T				35	ANM2319049T	5
7	Chemical lab	user_group	Chemical lab	avUpClass	Execution	PGO	PV RnD	PV RnD	@P	Planned	@P	Planned	3	ANM2319049T22			Trials	ANM2319049T22	@P	Planned	3						ANM2319049T				35	ANM2319049T	5
7	Chemical lab	user_group	Chemical lab	avUpClass	Execution	PGO	PV RnD	PV RnD	@P	Planned	@P	Planned	3	ANM2319049T25			Trials	ANM2319049T25	@P	Planned	3						ANM2319049T				35	ANM2319049T	4
7	Chemical lab	user_group	Chemical lab	avUpClass	Execution	PGO	PV RnD	PV RnD	@P	Planned	@P	Planned	3	ANM2319049T28			Trials	ANM2319049T28	@P	Planned	3						ANM2319049T				35	ANM2319049T	5
7	Chemical lab	user_group	Chemical lab	avUpClass	Execution	PGO	PV RnD	PV RnD	@P	Planned	@P	Planned	3	ANM2319049T31			Trials	ANM2319049T31	@P	Planned	3						ANM2319049T				35	ANM2319049T	4
7	Chemical lab	user_group	Chemical lab	avUpClass	Execution	PGO	PV RnD	PV RnD	@P	Planned	@P	Planned	3	ANM2319049T34			Trials	ANM2319049T34	@P	Planned	3						ANM2319049T				35	ANM2319049T	2
7	Chemical lab	user_group	Chemical lab	avUpClass	Execution	PGO	PV RnD	PV RnD	@P	Planned	@P	Planned	3	ANM2319049T35			Trials	ANM2319049T35	@P	Planned	3						ANM2319049T				35	ANM2319049T	2
7	Chemical lab	user_group	Chemical lab	avUpClass	Execution	PGO	PV RnD	PV RnD	@P	Planned	@P	Planned	3	ANM2319049T36			Trials	ANM2319049T36	@P	Planned	3						ANM2319049T				35	ANM2319049T	2
7	Chemical lab	user_group	Chemical lab	avUpClass	Execution	PGO	PV RnD	PV RnD	@P	Planned	@P	Planned	3	ANM2319049T37			Trials	ANM2319049T37	@P	Planned	3						ANM2319049T				35	ANM2319049T	2
7	Chemical lab	user_group	Chemical lab	avUpClass	Execution	PGO	PV RnD	PV RnD	@P	Planned	@P	Planned	3	ANM2319049T38			Trials	ANM2319049T38	@P	Planned	3						ANM2319049T				35	ANM2319049T	2
7	Chemical lab	user_group	Chemical lab	avUpClass	Execution	PGO	PV RnD	PV RnD	@P	Planned	@P	Planned	3	ANM2319049T39			Trials	ANM2319049T39	@P	Planned	3						ANM2319049T				35	ANM2319049T	2
7	Chemical lab	user_group	Chemical lab	avUpClass	Execution	PGO	PV RnD	PV RnD	@P	Planned	@P	Planned	3	ANM2319049T40			Trials	ANM2319049T40	@P	Planned	3						ANM2319049T				35	ANM2319049T	1
...
*/







/*
SELECT 
	COALESCE(NULLIF(pref.pref_value, '-'), NULLIF(dprf.pref_value, '-')) AS prof_lab
,	COALESCE(NULLIF(pref.pref_value, '-'), NULLIF(dprf.pref_value, '-'), 'NULL') AS prof_lab2
,	prof.up
,	user_group.value AS user_group
,	uvscme.ss AS me_ss, ss_me.name AS me_ss_name
,	COUNT(DISTINCT uvscme.me) AS me_count
,	uvsc.ss AS sc_ss
,   ss_sc.name AS sc_ss_name
,   uvsc.priority AS sc_priority
,	CASE WHEN uvsc.priority < 4 THEN uvsc.sc ELSE NULL END AS sc_prio_lt_4
,	CASE WHEN uvsc.priority < 3 THEN uvsc.sc ELSE NULL END AS sc_prio_lt_3
,	CASE WHEN uvsc.priority = 1 THEN uvsc.sc ELSE NULL END AS sc_prio_eq_1
,	sccontext.context AS sc_context
,	uvsc.sc
,	uvrq.ss AS rq_ss
,   ss_rq.name AS rq_ss_name
,   uvrq.priority AS rq_priority
,	CAST(uvrq.date1 AS date) AS rq_reqd_ready
,	CASE WHEN uvrq.date1 IS NOT NULL AND uvrq.date1 < TRUNC(SYSDATE) THEN uvrq.rq ELSE NULL END AS rq_overdue
,	CASE WHEN uvrq.date1 IS NOT NULL AND uvrq.date1 >= TRUNC(SYSDATE) AND uvrq.date1 < TRUNC(SYSDATE) + 7 THEN uvrq.rq ELSE NULL END AS rq_due_1wk
,	CASE WHEN uvrq.date1 IS NOT NULL AND uvrq.date1 >= TRUNC(SYSDATE) + 7 AND uvrq.date1 < TRUNC(SYSDATE) + &LATE_D THEN uvrq.rq ELSE NULL END AS rq_due_3wk
,	CASE WHEN uvrq.date1 IS NOT NULL AND uvrq.date1 >= TRUNC(SYSDATE) + &LATE_D THEN uvrq.rq ELSE NULL END AS rq_due
,	CASE WHEN uvrq.priority < 4 THEN uvrq.rq ELSE NULL END AS rq_prio_lt_4
,	CASE WHEN uvrq.priority < 3 THEN uvrq.rq ELSE NULL END AS rq_prio_lt_3
,	CASE WHEN uvrq.priority = 1 THEN uvrq.rq ELSE NULL END AS rq_prio_eq_1
,	rqexecwk.RqExecutionWeek AS rq_exec_week
,	to_number(to_char(SYSDATE, 'IW')) AS this_week
,	uvrq.rq
*/

/*
SELECT user_group.*
FROM utupau  user_group
INNER JOIN utupau user_class ON (	user_class.up = user_group.up
								AND user_class.version = user_group.version
								AND user_class.au = 'avUpClass'
								AND user_class.value = 'Execution'
								)
INNER JOIN utup prof ON (	prof.up = user_group.up	
						AND prof.version_is_current = '1' )
LEFT OUTER JOIN utupuspref pref ON (	pref.up = prof.up
									AND pref.version = prof.version
									AND pref.pref_name = 'lab'
									AND pref.us = 'PSC'    --'++USER_ID'
									)
;									

-* If no user preference 'lab' is found, use the profile preference 'lab' from uvuppref
 LEFT OUTER JOIN uvuppref dprf ON (
 		dprf.up	= prof.up
	AND dprf.version = prof.version
	AND dprf.pref_name = 'lab'
 )
*/ 

/*
-* Request data (Method -> Sample -> Request)
 INNER JOIN uvscmegkuser_group me_user_group ON (me_user_group.user_group = user_group.value)
 INNER JOIN uvscme ON (
		uvscme.SC = me_user_group.SC
	AND uvscme.PG = me_user_group.PG
	AND uvscme.PGNODE = me_user_group.PGNODE
	AND uvscme.PA = me_user_group.PA
	AND uvscme.PANODE = me_user_group.PANODE
	AND uvscme.ME = me_user_group.ME
	AND uvscme.MENODE = me_user_group.MENODE
 
	AND (
			(pref.pref_value IS NOT NULL AND pref.pref_value = uvscme.lab)
		OR	(dprf.pref_value IS NOT NULL AND dprf.pref_value = uvscme.lab)
		OR	(pref.pref_value IS NULL AND dprf.pref_value IS NULL AND NULLIF(uvscme.lab, '-') IS NULL)
	)
 )
 
 INNER JOIN uvss ss_me ON (uvscme.ss = ss_me.ss)
 INNER JOIN uvsc ON (uvscme.sc = uvsc.sc)
 INNER JOIN uvss ss_sc ON (uvsc.ss = ss_sc.ss)
 LEFT OUTER JOIN uvrq ON (uvsc.rq = uvrq.rq)
 LEFT OUTER JOIN uvss ss_rq ON (uvrq.ss = ss_rq.ss) 
*/ 
 
 
/*
 LEFT OUTER JOIN uvscgkcontext sccontext ON (sccontext.sc = uvsc.sc )
 LEFT OUTER JOIN uvrqgkRqExecutionWeek rqexecwk ON (rqexecwk.rq = uvrq.rq	AND rqexecwk.RqExecutionWeek = to_char(SYSDATE, 'FMIW') )
*/
 
/*
 WHERE user_group.au = 'user_group'
 AND user_group.value = '&USER_GROUP'
 AND (
		uvscme.ss IN ('AV', '@P', 'IE', 'OS', 'OW', 'WA', 'ER')
	OR	(uvscme.ss = 'CM' AND uvsc.ss IN ('OS', 'OW'))
 )
 AND (uvrq.ss IN ('AV', '@P', 'SU') OR uvsc.rq IS NULL)
*/
/* 
 AND NOT EXISTS (
	SELECT 1
	 FROM uvrqgkistest rqistest
	 WHERE rqistest.rq = uvrq.rq
	  AND rqistest.istest = '1'
  )
  AND NOT EXISTS (
	SELECT 1
	 FROM uvscgkistest scistest
	 WHERE scistest.sc = uvsc.sc
	  AND scistest.istest = '1'
  )
  AND NOT EXISTS (
	SELECT 1
	 FROM uvscmegkme_is_relevant merelv
	 WHERE uvscme.sc		= merelv.sc
	  AND uvscme.pg		= merelv.pg
	  AND uvscme.pgnode	= merelv.pgnode
	  AND uvscme.pa		= merelv.pa
	  AND uvscme.panode	= merelv.panode
	  AND uvscme.me		= merelv.me
	  AND uvscme.menode	= merelv.menode
	  AND merelv.me_is_relevant	= '0'
  )
 
 GROUP BY
	pref.pref_value, dprf.pref_value,
	prof.up, user_group.value,
	uvscme.ss, ss_me.name, uvsc.priority,
	uvsc.sc, uvsc.ss, ss_sc.name,
-*	scexecwk.value,
	sccontext.context,
	uvrq.rq, uvrq.ss, uvrq.priority, uvrq.date1, ss_rq.name,
	rqexecwk.RqExecutionWeek
 ORDER BY
	uvrq.rq, sccontext.context, uvsc.sc, uvscme.ss
; 
*/






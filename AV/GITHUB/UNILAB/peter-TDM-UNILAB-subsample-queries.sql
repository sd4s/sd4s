--BESTAAND SAMPLE:

--descr atoutdoorevents
select event_num, event_type, obj_tp, obj_id, modify_reason, handled_on, handling_errcode, created_on 
from atoutdoorevents
order by event_num;

--ATOUTDOOREVENTS.OBJ_ID = UTSC.SC
select sc from utsc where sc like '20.651.IBO%'
/*
20.651.IBO01
20.651.IBO01.X.FL
20.651.IBO01.X.FR
20.651.IBO01.Y2.FL
20.651.IBO01.Y2.FR
20.651.IBO01.Y2.RL
20.651.IBO01.Y2.RR
--
20.651.IBO02
20.651.IBO02.Y2.FL
20.651.IBO02.Y2.FR
20.651.IBO02.Y2.RL
20.651.IBO02.Y2.RR
*/
select sc, ST, ST_VERSION, SAMPLING_DATE, CREATION_DATE, CREATED_BY, RQ, LC,SS  
from utsc where sc like '20.651.IBO%'
/*
20.651.IBO01	T-T: PCT normal set	0001.05	01-10-20 14:21:27,000000000	01-10-20 14:22:12,000000000	%	20.651.IBO	SP	AV
20.651.IBO01.X.FL	WheelSetEntity	0001.00	01-10-20 15:18:07,000000000	01-10-20 15:18:08,000000000	UNILAB	20.651.IBO	SP	AV
20.651.IBO01.X.FR	WheelSetEntity	0001.00	01-10-20 15:18:08,000000000	01-10-20 15:18:09,000000000	UNILAB	20.651.IBO	SP	AV
20.651.IBO01.Y2.FL	WheelSetEntity	0001.00	01-10-20 15:15:56,000000000	01-10-20 15:15:57,000000000	UNILAB	20.651.IBO	SP	AV
20.651.IBO01.Y2.FR	WheelSetEntity	0001.00	01-10-20 15:15:57,000000000	01-10-20 15:15:58,000000000	UNILAB	20.651.IBO	SP	AV
20.651.IBO01.Y2.RL	WheelSetEntity	0001.00	01-10-20 15:15:57,000000000	01-10-20 15:15:58,000000000	UNILAB	20.651.IBO	SP	AV
20.651.IBO01.Y2.RR	WheelSetEntity	0001.00	01-10-20 15:15:58,000000000	01-10-20 15:15:58,000000000	UNILAB	20.651.IBO	SP	AV
20.651.IBO02	T-T: PCT normal set	0001.05	01-10-20 14:21:27,000000000	01-10-20 15:29:42,000000000	%	20.651.IBO	SP	AV
20.651.IBO02.Y2.FL	WheelSetEntity	0001.00	01-10-20 15:32:11,000000000	01-10-20 15:32:11,000000000	UNILAB	20.651.IBO	SP	AV
20.651.IBO02.Y2.FR	WheelSetEntity	0001.00	01-10-20 15:32:11,000000000	01-10-20 15:32:11,000000000	UNILAB	20.651.IBO	SP	AV
20.651.IBO02.Y2.RL	WheelSetEntity	0001.00	01-10-20 15:32:11,000000000	01-10-20 15:32:12,000000000	UNILAB	20.651.IBO	SP	AV
20.651.IBO02.Y2.RR	WheelSetEntity	0001.00	01-10-20 15:32:12,000000000	01-10-20 15:32:12,000000000	UNILAB	20.651.IBO	SP	AV
*/

--REQUEST is bij allen hetzelfde:
SELECT RQ, RT, RT_VERSION, DESCRIPTION, SAMPLING_DATE, CREATION_DATE, LC, SS FROM UTRQ where rq = '20.651.IBO';
/*
20.651.IBO	T-T: PCT Outdoor	0001.10	Testing PCT outdoor	01-10-20 14:21:27,000000000	01-10-20 14:21:30,000000000	R1	AV
*/

--relatie Sample - worksheet
SELECT * FROM UTWSSC WHERE SC LIKE '20.651.IBO%';
/*
WS				ROWNR	SC
20.651.IBO-001	1	20.651.IBO01
20.651.IBO-002	1	20.651.IBO01
20.651.IBO-003	1	20.651.IBO01
20.651.IBO-X	1	20.651.IBO01.X.FL
20.651.IBO-X	2	20.651.IBO01.X.FR
20.651.IBO-Y2	1	20.651.IBO01.Y2.FL
20.651.IBO-Y2	2	20.651.IBO01.Y2.FR
20.651.IBO-Y2	3	20.651.IBO01.Y2.RL
20.651.IBO-Y2	4	20.651.IBO01.Y2.RR
--
20.651.IBO-002	2	20.651.IBO02
20.651.IBO-Y2	5	20.651.IBO02.Y2.FL
20.651.IBO-Y2	6	20.651.IBO02.Y2.FR
20.651.IBO-Y2	7	20.651.IBO02.Y2.RL
20.651.IBO-Y2	8	20.651.IBO02.Y2.RR
*/

--UTSCME
select * FROM UTSCME where SC LIKE '20.651.IBO%'
/*
SC					PG				PGNODE	PACKAGE				PANODE	ME		MENODE	MT_VERSION	DESCRIPTION			VALUE_F	VALUE_S	UNIT				
20.651.IBO01		Outdoor testing	1000000	Aquaplaning long	2000000	TT860A	2000000	0003.01		Aquaplaning longitudinal				km/h
20.651.IBO01		Outdoor testing	1000000	Aquaplaning long	2000000	TT998A	1000000	0001.02		Test details			
20.651.IBO01		Outdoor testing	1000000	Brake dry ABS dist	1000000	TT800A	2000000	0003.02		Dry braking ABS			
20.651.IBO01		Outdoor testing	1000000	Brake dry ABS dist	1000000	TT998A	1000000	0001.02		Test details			
20.651.IBO01		Outdoor testing	1000000	Brake snow ABS dist	1500000	TT803A	2000000	0003.00		Snow deceleration			%
20.651.IBO01		Outdoor testing	1000000	Brake snow ABS dist	1500000	TT998A	1000000	0001.02		Test details			
20.651.IBO01.X.FL	Mounting		1000000	Mounting			1000000	TP800A1	1000000	0001.01		Tyre mounting			
20.651.IBO01.X.FR	Mounting		1000000	Mounting			1000000	TP800A1	1000000	0001.01		Tyre mounting			
20.651.IBO01.Y2.FL	Mounting		1000000	Mounting			1000000	TP800A1	1000000	0001.01		Tyre mounting			
20.651.IBO01.Y2.FR	Mounting		1000000	Mounting			1000000	TP800A1	1000000	0001.01		Tyre mounting			
20.651.IBO01.Y2.RL	Mounting		1000000	Mounting			1000000	TP800A1	1000000	0001.01		Tyre mounting			
20.651.IBO01.Y2.RR	Mounting		1000000	Mounting			1000000	TP800A1	1000000	0001.01		Tyre mounting			
20.651.IBO02		Outdoor testing	1000000	Brake dry ABS dist	1000000	TT800A	2000000	0003.02		Dry braking ABS			
20.651.IBO02		Outdoor testing	1000000	Brake dry ABS dist	1000000	TT998A	1000000	0001.02		Test details			
20.651.IBO02.Y2.FL	Mounting		1000000	Mounting			1000000	TP800A1	1000000	0001.01		Tyre mounting			
20.651.IBO02.Y2.FR	Mounting		1000000	Mounting			1000000	TP800A1	1000000	0001.01		Tyre mounting			
20.651.IBO02.Y2.RL	Mounting		1000000	Mounting			1000000	TP800A1	1000000	0001.01		Tyre mounting			
20.651.IBO02.Y2.RR	Mounting		1000000	Mounting			1000000	TP800A1	1000000	0001.01		Tyre mounting			
*/

--UTSCMEAU - Vanuit nieuwe SUBSAMPLE ligt er een relatie naar MASTER-SAMPLE via AU=avSuperSampleSc
--           Door daar de gevonden waarde aan sample te relateren krijgen we subsamples: UTSCMEAU.VALUE = UTSC.WSSC 
/*
SC				PG				PGNODE	PACKAGE				PANODE	ME		MENODE	AU					AU_VERSION	AUSEQ	VALUE
20.651.IBO01	Outdoor testing	1000000	Aquaplaning long	2000000	TT860A	2000000	avCustSubSampleMT				5	TP800A1
20.651.IBO01	Outdoor testing	1000000	Aquaplaning long	2000000	TT860A	2000000	avCustSubSamplePP				4	Mounting
20.651.IBO01	Outdoor testing	1000000	Aquaplaning long	2000000	TT860A	2000000	avCustSubSamplePR				3	Mounting
20.651.IBO01	Outdoor testing	1000000	Aquaplaning long	2000000	TT860A	2000000	avCustSubSampleST				2	WheelSetEntity
20.651.IBO01	Outdoor testing	1000000	Aquaplaning long	2000000	TT860A	2000000	avImportId						1	
20.651.IBO01	Outdoor testing	1000000	Brake dry ABS dist	1000000	TT800A	2000000	avCustSubSampleMT				5	TP800A1
20.651.IBO01	Outdoor testing	1000000	Brake dry ABS dist	1000000	TT800A	2000000	avCustSubSamplePP				4	Mounting
20.651.IBO01	Outdoor testing	1000000	Brake dry ABS dist	1000000	TT800A	2000000	avCustSubSamplePR				3	Mounting
20.651.IBO01	Outdoor testing	1000000	Brake dry ABS dist	1000000	TT800A	2000000	avCustSubSampleST				2	WheelSetEntity
20.651.IBO01	Outdoor testing	1000000	Brake dry ABS dist	1000000	TT800A	2000000	avImportId						1	
20.651.IBO01.X.FL	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSqlCurrentPartno						6	XEF_ZHVB27
20.651.IBO01.X.FL	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSubSampleMeLink						1	20401479
20.651.IBO01.X.FL	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSuperSampleMe							5	TT860A#2000000
20.651.IBO01.X.FL	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSuperSamplePa							4	Aquaplaning long#2000000
20.651.IBO01.X.FL	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSuperSamplePg							3	Outdoor testing#1000000
20.651.IBO01.X.FL	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSuperSampleSc							2	20.651.IBO01         --> !!!!!!!!!!!!!!!!
20.651.IBO01.X.FR	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSqlCurrentPartno						6	XEF_ZHVB27
20.651.IBO01.X.FR	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSubSampleMeLink						1	20401479
20.651.IBO01.X.FR	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSuperSampleMe							5	TT860A#2000000
20.651.IBO01.X.FR	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSuperSamplePa							4	Aquaplaning long#2000000
20.651.IBO01.X.FR	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSuperSamplePg							3	Outdoor testing#1000000
20.651.IBO01.X.FR	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSuperSampleSc							2	20.651.IBO01
20.651.IBO01.Y2.FL	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSqlCurrentPartno						6	XEF_ZHVB27
20.651.IBO01.Y2.FL	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSubSampleMeLink						1	20401480
20.651.IBO01.Y2.FL	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSuperSampleMe							5	TT800A#2000000
20.651.IBO01.Y2.FL	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSuperSamplePa							4	Brake dry ABS dist#1000000
20.651.IBO01.Y2.FL	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSuperSamplePg							3	Outdoor testing#1000000
20.651.IBO01.Y2.FL	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSuperSampleSc							2	20.651.IBO01		--> !!!!!!!!!!!!!!!!
20.651.IBO01.Y2.FR	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSqlCurrentPartno						6	XEF_ZHVB27
20.651.IBO01.Y2.FR	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSubSampleMeLink						1	20401480
20.651.IBO01.Y2.FR	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSuperSampleMe							5	TT800A#2000000
20.651.IBO01.Y2.FR	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSuperSamplePa							4	Brake dry ABS dist#1000000
20.651.IBO01.Y2.FR	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSuperSamplePg							3	Outdoor testing#1000000
20.651.IBO01.Y2.FR	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSuperSampleSc							2	20.651.IBO01		--> !!!!!!!!!!!!!!!!
20.651.IBO01.Y2.RL	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSqlCurrentPartno						6	XEF_ZHVB27
20.651.IBO01.Y2.RL	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSubSampleMeLink						1	20401480
20.651.IBO01.Y2.RL	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSuperSampleMe							5	TT800A#2000000
20.651.IBO01.Y2.RL	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSuperSamplePa							4	Brake dry ABS dist#1000000
20.651.IBO01.Y2.RL	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSuperSamplePg							3	Outdoor testing#1000000
20.651.IBO01.Y2.RL	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSuperSampleSc							2	20.651.IBO01		--> !!!!!!!!!!!!!!!!
20.651.IBO01.Y2.RR	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSqlCurrentPartno						6	XEF_ZHVB27
20.651.IBO01.Y2.RR	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSubSampleMeLink						1	20401480
20.651.IBO01.Y2.RR	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSuperSampleMe							5	TT800A#2000000
20.651.IBO01.Y2.RR	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSuperSamplePa							4	Brake dry ABS dist#1000000
20.651.IBO01.Y2.RR	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSuperSamplePg							3	Outdoor testing#1000000
20.651.IBO01.Y2.RR	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSuperSampleSc							2	20.651.IBO01		--> !!!!!!!!!!!!!!!!	
20.651.IBO02	Outdoor testing	1000000	Brake dry ABS dist	1000000	TT800A	2000000	avCustSubSampleMT				5	TP800A1
20.651.IBO02	Outdoor testing	1000000	Brake dry ABS dist	1000000	TT800A	2000000	avCustSubSamplePP				4	Mounting
20.651.IBO02	Outdoor testing	1000000	Brake dry ABS dist	1000000	TT800A	2000000	avCustSubSamplePR				3	Mounting
20.651.IBO02	Outdoor testing	1000000	Brake dry ABS dist	1000000	TT800A	2000000	avCustSubSampleST				2	WheelSetEntity
20.651.IBO02	Outdoor testing	1000000	Brake dry ABS dist	1000000	TT800A	2000000	avImportId						1	
20.651.IBO02.Y2.FL	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSqlCurrentPartno						6	XEF_ZHVB25
20.651.IBO02.Y2.FL	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSubSampleMeLink						1	20401483
20.651.IBO02.Y2.FL	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSuperSampleMe							5	TT800A#2000000
20.651.IBO02.Y2.FL	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSuperSamplePa							4	Brake dry ABS dist#1000000
20.651.IBO02.Y2.FL	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSuperSamplePg							3	Outdoor testing#1000000
20.651.IBO02.Y2.FL	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSuperSampleSc							2	20.651.IBO02		--> !!!!!!!!!!!!!!!!
20.651.IBO02.Y2.FR	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSqlCurrentPartno						6	XEF_ZHVB25
20.651.IBO02.Y2.FR	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSubSampleMeLink						1	20401483
20.651.IBO02.Y2.FR	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSuperSampleMe							5	TT800A#2000000
20.651.IBO02.Y2.FR	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSuperSamplePa							4	Brake dry ABS dist#1000000
20.651.IBO02.Y2.FR	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSuperSamplePg							3	Outdoor testing#1000000
20.651.IBO02.Y2.FR	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSuperSampleSc							2	20.651.IBO02		--> !!!!!!!!!!!!!!!!
20.651.IBO02.Y2.RL	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSqlCurrentPartno						6	XEF_ZHVB25
20.651.IBO02.Y2.RL	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSubSampleMeLink						1	20401483
20.651.IBO02.Y2.RL	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSuperSampleMe							5	TT800A#2000000
20.651.IBO02.Y2.RL	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSuperSamplePa							4	Brake dry ABS dist#1000000
20.651.IBO02.Y2.RL	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSuperSamplePg							3	Outdoor testing#1000000
20.651.IBO02.Y2.RL	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSuperSampleSc							2	20.651.IBO02		--> !!!!!!!!!!!!!!!!
20.651.IBO02.Y2.RR	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSqlCurrentPartno						6	XEF_ZHVB25
20.651.IBO02.Y2.RR	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSubSampleMeLink						1	20401483
20.651.IBO02.Y2.RR	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSuperSampleMe							5	TT800A#2000000
20.651.IBO02.Y2.RR	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSuperSamplePa							4	Brake dry ABS dist#1000000
20.651.IBO02.Y2.RR	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSuperSamplePg							3	Outdoor testing#1000000
20.651.IBO02.Y2.RR	Mounting	1000000	Mounting	1000000	TP800A1	1000000	avSuperSampleSc							2	20.651.IBO02
*/

--UTWSGKNUMBEROFVARIANTS: NumberOfVariants = aantal ta meken subsamples...
--RELATIE met UTWSGKNUMBEROFVARIANTS.WS = UTWSGKAVTESTMETHOD.WS
--
select * from UTWSGKAVTESTMETHOD WHERE WS LIKE '20.651.IBO%';
/*
TT860AA	20.651.IBO-001
TT800AA	20.651.IBO-002
TT803AA	20.651.IBO-003
TT860AA	20.651.IBO-X
TT800AA	20.651.IBO-Y2
*/

SELECT * FROM UTWSGKNUMBEROFVARIANTS WHERE WS LIKE '20.651.IBO%';
/*
1	20.651.IBO-001
2	20.651.IBO-002
1	20.651.IBO-003
1	20.651.IBO-X
2	20.651.IBO-Y2
*/



--actions in UTCF:
select * from utcf where cf='WS_A01';
select * from utcf where cf='WS_A07';



--Hoe ligt de relatie tussen CS en CF ?
select column_name, table_name from all_tab_COLUMNS where column_name like 'CF%' and table_name like 'UT%';
/*
CF_VALUE	UTAU				--> CF_VALUE IS OVERAL NULL...
CF_VALUE	UTAU_20090318
CF_VALUE	UTAU_20090408COMBI
CF_VALUE	UTAU_20090408PROD
CF	UTCF
CF_FILE	UTCF
CF_TYPE	UTCF
*/


--worksheet (WORDT DUS AL AANGEMAAKT VOORDAT UTSC van subsamples wordt aangemaakt!!!)
select * from UTWS where WS like '20.651%'
/*
WS				WT					WT_VERSION	DESCRIPTION			CREATION_DATE				CREATED_BY	LC
20.651.IBO-001	PCTOutdoorTesting	0001.00	PCT outdoor testing		01-10-20 15:14:10,000000000	UNILAB		W1
20.651.IBO-002	PCTOutdoorTesting	0001.00	PCT outdoor testing		01-10-20 15:14:10,000000000	UNILAB		W1
20.651.IBO-003	PCTOutdoorTesting	0001.00	PCT outdoor testing		01-10-20 15:14:10,000000000	UNILAB		W1
20.651.IBO-Y2	PCTOutdoorPrep		0001.01	PCT outdoor preperation	01-10-20 15:15:20,000000000	UNILAB		W2
20.651.IBO-X	PCTOutdoorPrep		0001.01	PCT outdoor preperation	01-10-20 15:18:00,000000000	UNILAB		W2
*/

--UTGKWS:  mogelijke GK binnen WS
--LET OP: VOOR IEDERE GK is ook FYSIEK een TABEL aanwezig !!! UTWSGK<GK-naam>
select * from UTGKWS ORDER BY GK;
/*
GK				VERSION	VERSION_IS_CURRENT	EFFECTIVE-FROM	DESCRIPTION
avBrakeInMilage		0	1	04-12-12 15:26:06,000000000		Brake in milage         --OK
avRqRequiredReady	0	1	30-03-20 13:47:35,000000000		Required Ready Date		--OK
avTestMethod		0	1	29-10-13 10:00:13,000000000		Test method				--OK
avTestMethodDesc	0	1	29-10-13 10:00:27,000000000		Test method description	--OK
BoldPattern			0	1	24-01-19 14:42:09,000000000		Bold Pattern			--OK
Driver				0	1	08-09-16 14:06:18,000000000		Driver					--OK
NumberOfRefs		0	1	04-12-12 15:25:53,000000000		Number of refs			--OK
NumberOfSets		0	1	04-12-12 15:25:45,000000000		Number of sets			--OK
NumberOfVariants	0	1	19-08-13 15:39:59,000000000		Number of variants		--OK
opensheets			0	1	05-02-07 13:53:48,000000000		Open Worksheets			--OK
Outsource			0	1	15-04-20 10:24:25,000000000		Outsource?				--OK
p_infl_front		0	1	04-12-12 15:25:05,000000000		Pressure front			--OK
p_infl_rear			0	1	04-12-12 15:24:58,000000000		Pressure rear			--OK
RefSetDesc			0	1	04-12-12 15:24:51,000000000		Ref set description		--OK
RequestCode			0	1	29-10-13 10:01:02,000000000		Request code			--OK
Rim					0	1	05-08-15 10:05:10,000000000		Rim inch				--OK
Rim Central Bore	0	1	05-08-15 09:39:25,000000000		Rim Central Bore		--????? KOMT NIET VOOR, DUBBEL MET VOLGENDE?
RimCentralBore		0	1	05-08-15 09:40:52,000000000		Rim Central Bore		--OK
RimETfront			0	1	04-12-12 15:24:37,000000000		Rim ET front			--OK
RimETrear			0	1	04-12-12 15:24:31,000000000		Rim ET rear				--OK
RimWidthFront		0	1	04-12-12 15:24:24,000000000		Rim width front			--OK
RimWidthRear		0	1	04-12-12 15:24:17,000000000		Rim width rear			--OK
SPEC_TYPE			0	1	04-12-12 15:24:09,000000000		Spec type				--OK
SubProgramID		0	1	04-12-12 15:24:02,000000000		Sub program ID			--OK
TestLocation		0	1	09-01-19 10:07:00,000000000		Test location			--OK
TestPrio			0	1	04-03-14 13:12:29,000000000		Test prio				--OK
TestSetPosition		0	1	12-05-20 14:43:01,000000000		TestSetPosition			--OK
TestSetSize			0	1	04-12-12 15:23:29,000000000		Test set size			--OK
TestVehicleType		0	1	04-12-12 15:23:22,000000000		Test vehicle type		--OK
TestWeek			0	1	04-12-19 13:09:52,000000000		Test week				--OK
WsPrio				0	1	04-12-12 15:25:30,000000000		Outdoor priority		--OK
WsTestLocation		0	1	04-12-12 15:25:23,000000000		Outdoor test location	--OK
--
--onderstaande GK komen niet als GK voor in UTGKWS, maar wel als FYSIEKE-tabellen:
UTWSGKWSTRACK	
UTWSGKWSVEHICLE
UTWSGKWSWEEK
*/


--UTWSGK
select * from utwsgk WHERE WS LIKE '20.651.IBO%' order by WS, GK, GKSEQ;
/*
20.651.IBO-X	avBrakeInMilage		500	
20.651.IBO-X	avRqRequiredReady		500	
20.651.IBO-X	avTestMethod		500	TT860AA
20.651.IBO-X	avTestMethodDesc		500	Aquaplaning longitudinal
20.651.IBO-X	BoldPattern		500	5x112
20.651.IBO-X	NumberOfRefs		500	1
20.651.IBO-X	NumberOfVariants		500	1			--> !!!!!!!!!!!!!!!
20.651.IBO-X	opensheets		500	20.651.IBO-X
20.651.IBO-X	Outsource		500	N
20.651.IBO-X	p_infl_front		500	2.20
20.651.IBO-X	p_infl_rear		500	2.00
20.651.IBO-X	RefSetDesc		500	
20.651.IBO-X	RequestCode		500	20.651.IBO
20.651.IBO-X	RimCentralBore		500	57.1
20.651.IBO-X	RimETfront		500	50
20.651.IBO-X	RimETrear		500	50
20.651.IBO-X	RimWidthFront		500	6.5
20.651.IBO-X	RimWidthRear		500	6.5
20.651.IBO-X	SubProgramID		500	X
20.651.IBO-X	TestLocation		500	ATP
20.651.IBO-X	TestPrio		500	
20.651.IBO-X	TestSetPosition		500	FL;FR
20.651.IBO-X	TestSetSize		500	2
20.651.IBO-X	TestVehicleType		500	VW Golf
20.651.IBO-X	TestWeek		501	2020-46
20.651.IBO-Y2	avBrakeInMilage		500	
20.651.IBO-Y2	avRqRequiredReady		500	
20.651.IBO-Y2	avTestMethod		500	TT800AA
20.651.IBO-Y2	avTestMethodDesc		500	Braking dry ABS distance
20.651.IBO-Y2	BoldPattern		500	5x112
20.651.IBO-Y2	NumberOfRefs		500	1
20.651.IBO-Y2	NumberOfVariants		500	2			--> !!!!!!!!!!!!!!!
20.651.IBO-Y2	opensheets		500	20.651.IBO-Y2
20.651.IBO-Y2	Outsource		500	N
20.651.IBO-Y2	p_infl_front		500	2.20
20.651.IBO-Y2	p_infl_rear		500	2.00
20.651.IBO-Y2	RefSetDesc		500	
20.651.IBO-Y2	RequestCode		500	20.651.IBO
20.651.IBO-Y2	RimCentralBore		500	57.1
20.651.IBO-Y2	RimETfront		500	50
20.651.IBO-Y2	RimETrear		500	50
20.651.IBO-Y2	RimWidthFront		500	6.5
20.651.IBO-Y2	RimWidthRear		500	6.5
20.651.IBO-Y2	SubProgramID		500	Y2
20.651.IBO-Y2	TestLocation		500	ATP
20.651.IBO-Y2	TestPrio		500	
20.651.IBO-Y2	TestSetPosition		500	FL;FR;RL;RR
20.651.IBO-Y2	TestSetSize		500	4
20.651.IBO-Y2	TestVehicleType		500	VW Golf
20.651.IBO-Y2	TestWeek		501	2020-46
20.651.IBO-001	avBrakeInMilage		500	
20.651.IBO-001	avRqRequiredReady		500	
20.651.IBO-001	avTestMethod		500	TT860AA
20.651.IBO-001	avTestMethodDesc		500	Aquaplaning longitudinal
20.651.IBO-001	BoldPattern		502	5x112
20.651.IBO-001	NumberOfRefs		500	1
20.651.IBO-001	NumberOfVariants		500	1			--> !!!!!!!!!!!!!!!
20.651.IBO-001	opensheets		500	20.651.IBO-001
20.651.IBO-001	Outsource		500	N
20.651.IBO-001	p_infl_front		500	2.20
20.651.IBO-001	p_infl_rear		500	2.00
20.651.IBO-001	RequestCode		500	20.651.IBO
20.651.IBO-001	RimCentralBore		503	57.1
20.651.IBO-001	RimETfront		500	50
20.651.IBO-001	RimETrear		500	50
20.651.IBO-001	RimWidthFront		500	6.5
20.651.IBO-001	RimWidthRear		500	6.5
20.651.IBO-001	SubProgramID		500	X
20.651.IBO-001	TestLocation		500	ATP
20.651.IBO-001	TestPrio		500	
20.651.IBO-001	TestSetPosition		500	FL;FR
20.651.IBO-001	TestSetSize		500	2
20.651.IBO-001	TestVehicleType		500	VW Golf
20.651.IBO-001	TestWeek		504	2020-46
20.651.IBO-002	avBrakeInMilage		500	
20.651.IBO-002	avRqRequiredReady		500	
20.651.IBO-002	avTestMethod		500	TT800AA
20.651.IBO-002	avTestMethodDesc		500	Braking dry ABS distance
20.651.IBO-002	BoldPattern		502	5x112
20.651.IBO-002	NumberOfRefs		500	1
20.651.IBO-002	NumberOfVariants		500	2		--> !!!!!!!!!!!!!!!
20.651.IBO-002	opensheets		500	20.651.IBO-002
20.651.IBO-002	Outsource		500	N
20.651.IBO-002	p_infl_front		500	2.20
20.651.IBO-002	p_infl_rear		500	2.00
20.651.IBO-002	RequestCode		500	20.651.IBO
20.651.IBO-002	RimCentralBore		503	57.1
20.651.IBO-002	RimETfront		500	50
20.651.IBO-002	RimETrear		500	50
20.651.IBO-002	RimWidthFront		500	6.5
20.651.IBO-002	RimWidthRear		500	6.5
20.651.IBO-002	SubProgramID		500	Y2
20.651.IBO-002	TestLocation		500	ATP
20.651.IBO-002	TestPrio		500	
20.651.IBO-002	TestSetPosition		500	FL;FR;RL;RR
20.651.IBO-002	TestSetSize		500	4
20.651.IBO-002	TestVehicleType		500	VW Golf
20.651.IBO-002	TestWeek		504	2020-46
20.651.IBO-003	avBrakeInMilage		500	200
20.651.IBO-003	avRqRequiredReady		500	
20.651.IBO-003	avTestMethod		500	TT803AA
20.651.IBO-003	avTestMethodDesc		500	Snow acc dec
20.651.IBO-003	BoldPattern		502	5x112
20.651.IBO-003	NumberOfRefs		500	1
20.651.IBO-003	NumberOfVariants		500	1			--> !!!!!!!!!!!!!!!
20.651.IBO-003	opensheets		500	20.651.IBO-003
20.651.IBO-003	Outsource		500	N
20.651.IBO-003	p_infl_front		500	2.20
20.651.IBO-003	p_infl_rear		500	2.00
20.651.IBO-003	RequestCode		500	20.651.IBO
20.651.IBO-003	RimCentralBore		503	57.1
20.651.IBO-003	RimETfront		500	50
20.651.IBO-003	RimETrear		500	50
20.651.IBO-003	RimWidthFront		500	6.5
20.651.IBO-003	RimWidthRear		500	6.5
20.651.IBO-003	SubProgramID		500	W
20.651.IBO-003	TestLocation		500	Ivalo
20.651.IBO-003	TestPrio		500	
20.651.IBO-003	TestSetSize		500	4
20.651.IBO-003	TestVehicleType		500	VW Golf
20.651.IBO-003	TestWeek		504	2020-46
*/

--utwsgkrequestcode
select * from utwsgkrequestcode where ws like '20.651.IBO%';
/*
20.651.IBO	20.651.IBO-001
20.651.IBO	20.651.IBO-002
20.651.IBO	20.651.IBO-003
20.651.IBO	20.651.IBO-X
20.651.IBO	20.651.IBO-Y2
*/

--UTWSGKSUBPROGRAMID:
select * from utwsgksubprogramid where ws like '20.651.IBO%';
/*
X	20.651.IBO-001
Y2	20.651.IBO-002
W	20.651.IBO-003
X	20.651.IBO-X
Y2	20.651.IBO-Y2
*/

--WORKSHEET-Attributes: UTWSAU
select * from utwsau where ws like '20.651.IBO%';
/*
20.651.IBO-001	NumberOfRefs		1	1
20.651.IBO-002	NumberOfRefs		1	1
20.651.IBO-003	NumberOfRefs		1	1
20.651.IBO-X	RefSetDesc		7	
20.651.IBO-X	RimETfront		6	
20.651.IBO-X	RimETrear		5	
20.651.IBO-X	RimWidthFront		4	
20.651.IBO-X	RimWidthRear		3	
20.651.IBO-X	SubProgramID		2	
20.651.IBO-X	TestVehicleType		1	
20.651.IBO-X	avBrakeInMilage		8	
20.651.IBO-Y2	RefSetDesc		7	
20.651.IBO-Y2	RimETfront		6	
20.651.IBO-Y2	RimETrear		5	
20.651.IBO-Y2	RimWidthFront		4	
20.651.IBO-Y2	RimWidthRear		3	
20.651.IBO-Y2	SubProgramID		2	
20.651.IBO-Y2	TestVehicleType		1	
*/


SELECT
  utlc.lc,
  utlc.name,
  utss_f.name AS ss_from,
  utss_t.name AS ss_to,
  a.af
FROM utlcaf  a
LEFT JOIN utlc utlc on (a.lc = utlc.lc)
LEFT JOIN utss utss_f ON (ss_from = utss_f.ss)
LEFT JOIN utss utss_t ON (ss_to = utss_t.ss)
WHERE a.af IN ('WS_A01', 'WS_A07')
/*
LC		NAME				SS_FROM	SS_TO		AF
W2		worksheet prep		Planned	Available	WS_A07
W2		worksheet prep		Initial	Planned		WS_A07
W2		worksheet prep		Submit	Planned		WS_A07
W1		worksheet testing	Planned	Planned		WS_A01
W1		worksheet testing	Submit	Planned		WS_A01
*/







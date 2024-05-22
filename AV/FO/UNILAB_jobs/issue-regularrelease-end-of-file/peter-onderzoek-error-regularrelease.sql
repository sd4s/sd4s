--JOB REGULAR-RELEASE LOOPT SINDS 23-11-2023 STUK !!!!!!!
/*
ERROR STACK:
ORA-01423: error encountered while checking for extra rows in exact fetch
ORA-03113: end-of-file on communication channel

ERROR BACKTRACE:
ORA-06512: at "UNILAB.UNAPIUC", line 1607

ERROR MESSAGE:
ORA-01423: error encountered while checking for extra rows in exact fetch
ORA-03113: end-of-file on communication channel
*/



--JOB 
DECLARE
r number;
begin
  r := apaoregularrelease.evaluateTimeCountBased;
end;
/
--Job draait 1x minuut !!
/*
22/11/2023 23:00:51.500000000 +01:00
22/11/2023 23:01:51.500000000 +01:00
22/11/2023 23:02:51.500000000 +01:00
22/11/2023 23:03:51.500000000 +01:00
22/11/2023 23:04:51.500000000 +01:00
22/11/2023 23:05:51.500000000 +01:00
22/11/2023 23:06:51.500000000 +01:00
22/11/2023 23:07:51.500000000 +01:00
--
--CONCLUSIE: JOB draait nog steeds !!!
--           Proces loopt alleen ergens op stuk....
*/
/*
29431241	23/10/2023 04:00:35.857000 +02:00	RUN		SUCCEEDED				23/10/2023 03:00:35.400000 +01:00	23/10/2023 03:00:35.435000 +01:00	+000 00:00:00	1	269,53003	10976	+000 00:00:00.25
29431248	23/10/2023 04:01:35.866000 +02:00	RUN		SUCCEEDED				23/10/2023 03:01:35.400000 +01:00	23/10/2023 03:01:35.444000 +01:00	+000 00:00:00	1	269,53007	5596	+000 00:00:00.27
29431255	23/10/2023 04:02:35.858000 +02:00	RUN		SUCCEEDED				23/10/2023 03:02:35.400000 +01:00	23/10/2023 03:02:35.437000 +01:00	+000 00:00:00	1	269,53013	5708	+000 00:00:00.23
29431263	23/10/2023 04:03:35.867000 +02:00	RUN		SUCCEEDED				23/10/2023 03:03:35.400000 +01:00	23/10/2023 03:03:35.429000 +01:00	+000 00:00:00	1	17,30883	8384	+000 00:00:00.25
*/

sys-package-variable: SYS.DBMS_SCHEDULER.LOGGING_OFF

-- allowed job logging levels
logging_off   CONSTANT PLS_INTEGER := 32;
logging_runs  CONSTANT PLS_INTEGER := 64;
logging_failed_runs CONSTANT PLS_INTEGER := 128;
logging_full  CONSTANT PLS_INTEGER := 256;

set serveroutput on

declare
r number;
begin
 r := SYS.DBMS_SCHEDULER.LOGGING_OFF ;
 dbms_output.put_line('result OFF: '||r);
  --
   r := SYS.DBMS_SCHEDULER.LOGGING_ON ;
 dbms_output.put_line('result ON: '||r);

end;
/
 
-- Constants for raise events flags
job_started           CONSTANT PLS_INTEGER := 1;
job_succeeded         CONSTANT PLS_INTEGER := 2;
job_failed            CONSTANT PLS_INTEGER := 4;
job_broken            CONSTANT PLS_INTEGER := 8;
job_completed         CONSTANT PLS_INTEGER := 16;
job_stopped           CONSTANT PLS_INTEGER := 32;
job_sch_lim_reached   CONSTANT PLS_INTEGER := 64;
job_disabled          CONSTANT PLS_INTEGER := 128;
job_chain_stalled     CONSTANT PLS_INTEGER := 256;
job_all_events        CONSTANT PLS_INTEGER := 511;
job_over_max_dur      CONSTANT PLS_INTEGER := 512;
job_run_completed     CONSTANT PLS_INTEGER := job_succeeded + job_failed + job_stopped;
 

UTERROR:
--
APAOFUNCTIONS.CreateSample	CreateSample failed. Return code:1
APAOFUNCTIONS.CreateSample	CreateSample: sc=,st=EM_768,cic=,cpg=MANUAL ASSIGNMENT,mr=Job
CreateNextUniqueCodeValue	"ORA-01423: error encountered while checking for extra rows in exact fetch ORA-03113: end-of-file on communication channel"

--Onderzoek PACKAGE-FLOW

CURSOR: SELECT *    FROM ATAOREGULARRELEASE_PLANNED  ORDER BY SC, PGNODE;
2346001402	MDR vulc prop 190C	1000000
2346001403	MDR vulc prop 190C	1000000
2346001404	MDR vulc prop 190C	1000000
2346001405	MDR vulc prop 190C	1000000

select * from utscii where sc = '2346001402';
2346001402	avCompound	1000000	avBatchno			1000000	0001.00	5006		110	46	0	0	0	Batch number
2346001402	avCompound	1000000	avOrderBatch		4000000	0001.00	2974_5006	110	92	0	0	0	Concat Order-Batch
2346001402	avCompound	1000000	avOrderno			2000000	0001.00	2974		110	23	0	0	0	Order number
2346001402	avCompound	1000000	avProductionDate	3000000	0001.03	16-11-2023	110	69	0	0	0	Production date

select * from utscgk where sc = '2346001402';
2346001402	Context			500	Release
2346001402	PART_NO			500	EM_716
2346001402	SPEC_TYPE		509	FM
2346001402	day				500	16
2346001402	isTest			512	0
2346001402	month			500	11
2346001402	partGroup		505	Compound
2346001402	partGroup		506	Final mix
2346001402	partGroup		510	VR-produced
2346001402	scCreateUp		508	Material lab mgt
2346001402	scListUp		501	Preparation lab
2346001402	scListUp		503	Physical lab
2346001402	scListUp		504	Chemical lab
2346001402	scListUp		507	Material lab mgt
2346001402	scListUp		514	Viewers
2346001402	scListUp		515	Certificate control
2346001402	scListUp		516	Process tech. VF
2346001402	scListUp		517	Purchasing
2346001402	scListUp		518	QEA
2346001402	scListUp		519	Compounding
2346001402	scListUp		520	Reinforcement
2346001402	scListUp		521	Research
2346001402	scListUp		522	Proto Mixing
2346001402	scReceiverUp	513	Preparation lab
2346001402	scReceiverUp	523	Material lab mgt
2346001402	scReceiverUp	524	Proto Mixing
2346001402	week			500	46
2346001402	year			500	2023

--cursoren in APAOREGULARRELEASE.TIMECOUNTBASED  AANGESTUURD OBV SC !!!
SELECT pp, version, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5, a.freq_tp
	  FROM utstpp a, utsc b
	 WHERE b.sc = '2346001402'
	   AND a.st = b.st
	   AND a.version = b.st_version
	   AND a.freq_tp = 'A'
	   AND NOT exists (SELECT *
	   						FROM utscpg
	   					  WHERE sc = b.sc
	   					    AND pg = a.pp);
							
/*							
Greenstrength at 23C	0081.01	EM_716	 	 	 	 	S
Greenstrength at 40C	0081.01	EM_716	 	 	 	 	S
MDR vulc prop 190C		0081.01	EM_716	 	 	 	 	N
Ozon - static (ISO)		0081.01	EM_716	 	 	 	 	S
Properties FM			0081.01	EM_716	 	 	 	 	S
RPA vulc prop 160C		0081.01	EM_716	 	 	 	 	S
Rheological props		0081.01	EM_716	 	 	 	 	S
*/

--CONCLUSIE: ER KOMEN GEEN PP = PG VOOR MET EEN FREQ=A=ALWAYS !!!!!!
--           maar blijkt ook NIET gebruikt te worden....

SELECT pp, version, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5, a.freq_tp
	  FROM utstpp a, utsc b
	 WHERE b.sc = '2346001402'
	   AND a.st = b.st
	   AND a.version = b.st_version
	   AND a.freq_tp != 'A'
	   AND NOT exists (SELECT *
	   						FROM utscpg
	   					  WHERE sc = b.sc
	   					    AND pg = a.pp);

/*
Greenstrength at 23C	0081.01	EM_716	 	 	 	 	S
Greenstrength at 40C	0081.01	EM_716	 	 	 	 	S
Ozon - static (ISO)		0081.01	EM_716	 	 	 	 	S
Properties FM			0081.01	EM_716	 	 	 	 	S
RPA vulc prop 160C		0081.01	EM_716	 	 	 	 	S
Rheological props		0081.01	EM_716	 	 	 	 	S
*/

--CONCLUSIE: DEZE LEVERT MAAR 6 VAN DE 7 PP OP !!! 
--           HIER ONTBREEKT PP = MDR vulc prop 190C		0081.01	EM_716	 	 	 	 	N    --> MET FREQUENCY=NEVER !!!!

--welke parameters horen bij PG=MDR vulc prop 190C ??
select * from utscpa where sc = '2346001402' and  pg = 'MDR vulc prop 190C'
2346001402	MDR vulc prop 190C	1000000	MH 190C			2000000		0300.03	MH 190°C	10.33	10.330	dNm
2346001402	MDR vulc prop 190C	1000000	ML 190C			1000000		0400.04	ML 190°C	1.5		1.500	dNm
2346001402	MDR vulc prop 190C	1000000	RH 190C			10000000	0300.03	RH 190°C	10.56	10.560	cNm/s
2346001402	MDR vulc prop 190C	1000000	S_loss_H 190C	11000000	0300.04	S''H 190°C	1.33	1.330	cNm
2346001402	MDR vulc prop 190C	1000000	t30 190C		4000000		0001.00	t30% 190°C	0.913	0.913	min
2346001402	MDR vulc prop 190C	1000000	t50 190C		5000000		0001.01	t50% 190°C	1.084	1.084	min
2346001402	MDR vulc prop 190C	1000000	t70 190C		6000000		0001.00	t70% 190°C	1.304	1.304	min
2346001402	MDR vulc prop 190C	1000000	t80 190C		7000000		0001.00	t80% 190°C	1.488	1.488	min
2346001402	MDR vulc prop 190C	1000000	t90 190C		8000000		0400.01	t90% 190°C	1.815	1.815	min
2346001402	MDR vulc prop 190C	1000000	tRH 190C		9000000		0001.01	tRH 190°C	0.988	0.988	min
2346001402	MDR vulc prop 190C	1000000	tanH 190C		12000000	0001.00	tanH 190°C	2.974	2.974	
2346001402	MDR vulc prop 190C	1000000	ts1 190C		3000000		0300.03	ts1 190°C	0.709	0.709	min

select * from utscpgau where sc = '2346001402';

--HIERNA BEGINT PROCEDURE ZELF

SELECT st  FROM utsc	 WHERE sc = '2346001402';
EM_716

SELECT FROM ataoregularrelease WHERE st = 'EM_716';
EM_716	22-11-2023 11.29.44.000000000 PM
DELETE FROM ataoregularrelease WHERE st = 'EM_716';

SELECT COUNT(*)
	  FROM utstpp a, utsc b
	 WHERE b.sc = '2346001402'
	   AND a.st = b.st
	   AND a.version = b.st_version
	   AND a.freq_tp != 'A';
--7 x
--CONCLUSIE: HIER TELLEN WE 7 RIJEN, MAAR CURSOR LEVERT ER MAAR 6X OP. 
--           DAT LIGT AAN SUBQUERY-CONTROLE = AND NOT exists (SELECT * FROM utscpg WHERE sc = b.sc AND pg = a.pp);
--           DUS komt PP = PG al voor ?

--controle pg van org-sample.
SELECT *
FROM utscpg
WHERE sc = '2346001402'
--AND pg = a.pp
2346001402	MDR vulc prop 190C	1000000	0081.01	EM_716	 	 	 	 	MDR vulcanisation properties, 190°C				16-11-2023 06.32.39.000000000 PM	16-11-2023 06.32.38.000000000 PM			0	16-11-2023 06.32.38.000000000 PM	UNILAB	1		1	1	0	0	DD	0			1	1	1	1	G2	0	CM	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	16-11-2023 06.32.38.858000000 PM CET	16-11-2023 06.32.38.000000000 PM CET	16-11-2023 06.32.38.000000000 PM CET

--conclusie: KLOPT DUS: DEZE KOMT AL VOOR !!!!!!!!!! DIT IS VAN OORSPRONKELIJKE SAMPLE OBV WAARVAN REGULAR-RELEASE-SAMPLE WORDT AANGEMAAKT.
--
--SCHRIJF MELDINGEN WEG...
--APAOGEN.LogError(ics_package_name || '.EvaluateTimeCountBased', lvs_sqlerrm);
PROCEDURE LogError (avs_function_name  IN API_NAME_TYPE,
                    avs_message        IN VARCHAR2,
                    avb_with_rollback  IN BOOLEAN := TRUE,
                    avb_with_commit    IN BOOLEAN := TRUE,
                    avi_message_length IN INTEGER := 255) IS
					
					
--IF COUNT(*) > 0
--ER WORDT SAMPLE AANGEMAAKT MET ZELFDE SAMPLE-TYPE ALS DE ORIGINELE.
FUNCTION CreateSample( avs_sc      IN OUT VARCHAR,
                       avs_st      IN    VARCHAR2,
                       avs_create_ic       IN     VARCHAR2,
                       avs_create_pg       IN     VARCHAR2,
                       avs_modify_reason   IN    APAOGEN.MODIFY_REASON_TYPE)
RETURN APAOGEN.RETURN_TYPE IS


lvi_ret_code := APAOFUNCTIONS.CreateSample ( lvs_sc,                      --LVS_SC is NULL
                     						lvs_st,                       --LVS_ST = 'EM_716' 
                     						'',
                     						'MANUAL ASSIGNMENT',
											avs_modify_reason);


--
--LOG ERROR WITH NEW SAMPLE-CODE...

--FROM apaofunctions.createsample
lvi_ret_code := UNAPISC.CREATESAMPLE( avs_st,
                         lvs_st_version,
                         avs_sc,
                         lvd_ref_date,                   -- lvd_ref_date   := CURRENT_TIMESTAMP;
                         avs_create_ic,
                         avs_create_pg,
                         lvs_userid,
                         lts_fieldtype_tab_tab,
                         lts_fieldnames_tab_tab,
                         lts_fieldvalues_tab_tab,
                         lvi_nr_of_rows,                  --HOEVEEL SAMPLES AANMAKEN? = "0"
                         avs_modify_reason);
--
--IF ERROR THEN ERROR-MESSAGE is already stORED IN UTERROR.

--hIERIN ZIT CONTROLE OP MAX-SAMPLES:
set serveroutput on
DECLARE
L_MAX_NUMBER_OF_SAMPLES number;
L_RESULT NUMBER;
BEGIN
L_RESULT := UNAPIGEN.GETMAXSAMPLES(L_MAX_NUMBER_OF_SAMPLES);
DBMS_OUTPUT.PUT_LINE('MAX: ' ||l_result);
end;
/
--max=0 !!! CONCLUSIE: GEEN PROBLEEM !!! DUS VERDER ZOEKEN NAAR OORZAAK...

IF NVL(A_SC, ' ') = ' ' THEN
      L_RET_CODE := GENERATESAMPLECODE(A_ST, A_ST_VERSION, L_REF_DATE,
                                       A_FIELDTYPE_TAB, A_FIELDNAMES_TAB, A_FIELDVALUES_TAB, A_NR_OF_ROWS,
                                       A_SC, L_EDIT_ALLOWED, L_VALID_CF);

      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
         RAISE STPERROR;
      END IF;
   END IF;

--GENERATESAMPLECEODE
IF NVL(L_SC_UC, ' ') = ' ' THEN
      BEGIN
         SELECT UC
         INTO L_SC_UC
         FROM UTUC
         WHERE DEF_MASK_FOR = 'sc';

--default UC = Basic Mask 

--UTUC
/*
XML					0	1	10-11-2010 04.48.36.000000000 PM		XML for PIBS	ORACLEPROD-{YYYY}-{XML}.XML	ORACLEPROD-{2023}-{1448}.XML	
Basic Mask			0	1	05-02-2007 12.44.04.000000000 PM		Basic Mask	{YYYY}{MM}{DD}-{test_counter1\DD}	{2021}{04}{28}-{001}	sc
Basic Request Mask	0	1	05-02-2007 12.44.04.000000000 PM		Basic Request Mask	RQ-{YYYY}{MM}{DD}-{test_counter0\DD}	RQ-{2009}{09}{25}-{001}	rq
Worksheet Mask		0	1	05-02-2007 12.44.04.000000000 PM		Worksheet Mask	WS-{wscounter\NORESET}	WS-{0052}	ws
Study Mask			0	1	05-02-2007 12.44.04.000000000 PM		Study Mask	SD-{sdcounter\NORESET}		sd
doc_name			0	1	05-02-2007 12.44.04.000000000 PM		Identify long-text results	{YYYY}-{MM}{DD}-{doc_cnt\DD}#TXT	{2023}-{11}{15}-{0001}#TXT	lt
doc_link			0	1	05-02-2007 12.44.04.000000000 PM		Identify links	{YYYY}-{MM}{DD}-{link_cnt\DD}#LNK	{2023}-{11}{22}-{0003}#LNK	
prcalc_cn			0	1	05-02-2007 12.44.04.000000000 PM		Credit Note	C-{YY}{CREDIT}		
prcalc_invoice		0	1	05-02-2007 12.44.04.000000000 PM		Invoice	I-{YY}{INVOICE}		
prcalc_offer		0	1	05-02-2007 12.44.04.000000000 PM		Offer	O-{YY}{OFFER}		
u4specx_stuc		0	1	05-02-2007 12.44.07.000000000 PM		u4specx_stuc	u4specxst-{u4specx_stseq}		
u4specx_ppuc		0	1	05-02-2007 12.44.07.000000000 PM		u4specx_ppuc	u4specxpp-{u4specx_ppseq}		
avRqDef-T			0	1	30-09-2008 08.45.51.000000000 PM		avRqDef-Test	{userid}{YY}{WW}{avRqCCC\WW}T	{HVB}{17}{51}{045}	
avRqDef-M			0	1	30-09-2008 08.46.56.000000000 PM		avRqDef-Manufacture	{userid}{YY}{WW}{avRqCCC\WW}M	{JFA}{08}{40}{007}	
avRqDef-F			0	1	30-09-2008 08.48.25.000000000 PM		avRqDef-Factory	{userid}{YY}{WW}{avRqCCC\WW}F		
avRqDef-P			0	1	30-09-2008 08.48.50.000000000 PM		avRqDef-Purchasing	{userid}{YY}{WW}{avRqCCC\WW}P		
avScRq				0	1	30-09-2008 08.51.12.000000000 PM		avScRq	{rq}{rq seq1\2}	{MAR2347092T}{04}	
avScStdPrd			0	1	20-02-2007 12.27.43.000000000 PM		avScStdPrd: Standard for production samp	{YY}{WW}{avCCCCCC\WW}	{23}{47}{002626}	
avRqDef				0	1	18-08-2008 06.16.28.000000000 PM		avRqDef	{userid}{YY}{WW}{avRqCCC\WW}	{JTL}{13}{02}{002}	
ImportId			0	1	29-05-2007 10.35.39.000000000 AM		Import ID	{YY}{WW}{ImportId}	{23}{47}{1271}	
avRqDefAu			0	1	02-10-2008 08.56.45.000000000 PM		avRqDefAu	{userid}{YY}{WW}{avRqCCC\WW}{rtau->avRqTypeCodeId}	{MAR}{23}{47}{093}{T}	
avRqOutTest			0	1	05-03-2013 04.05.13.000000000 PM		avRqOutTest	{YY}.{avRqOutdoorCCC\YY}.{userid}	{23}.{960}.{VUD}	
avRqTrial			0	1	02-07-2020 10.53.07.000000000 AM		Code for Trial request	{userid}_{rtau->avSite\Left(1)}{YY}{avRqTrialCCC}	{GKU}_{E}{23}{514}	
avScRqTrial			0	1	02-07-2020 10.57.54.000000000 AM		Samples for Trial requests	{rq}{avCC\2}	{SAG_E23482}{86}	
doc_blob			0	1	01-07-2015 01.32.35.000000000 PM		Identifies blob id	{YYYY}-{MM}{DD}-{blob_cnt\DD}#BLB	{2023}-{11}{23}-{0026}#BLB	
TestMounting		0	1	07-11-2017 02.18.12.000000000 PM		test on if I can save "wrong" codemask	{sc}{paau"SubProgramID"}{paau"Position}		
*/


--CONTINUE 
   L_FIELDTYPE_TAB(NVL(A_NR_OF_ROWS, 0) +1) := 'st';
   L_FIELDNAMES_TAB (NVL(A_NR_OF_ROWS, 0) +1) :=  'st';
   L_FIELDVALUES_TAB(NVL(A_NR_OF_ROWS, 0) +1) :=  A_ST;
   L_FIELDTYPE_TAB(NVL(A_NR_OF_ROWS, 0) +2) := 'st';
   L_FIELDNAMES_TAB (NVL(A_NR_OF_ROWS, 0) +2) :=  'st_version';
   L_FIELDVALUES_TAB(NVL(A_NR_OF_ROWS, 0) +2) :=  A_ST_VERSION;
   L_NR_OF_ROWS :=   NVL(A_NR_OF_ROWS, 0) +2;
   
   L_RET_CODE := UNAPIUC.CREATENEXTUNIQUECODEVALUE(L_SC_UC, L_FIELDTYPE_TAB, L_FIELDNAMES_TAB, L_FIELDVALUES_TAB, 
                                                   L_NR_OF_ROWS,A_REF_DATE, A_SC,
                                                   A_EDIT_ALLOWED, A_VALID_CF);

--UNAPIUC.CREATENEXTUNIQUECODEVALUE



IF L_PLAN_SAMPLE THEN
      L_EVENT_TP := 'SamplePlanned';
      L_EV_SEQ_NR := -1;
      L_EV_DETAILS := 'st_version=' || A_ST_VERSION || 
                      '#ss_to=@P';
      L_RESULT := UNAPIEV.INSERTEVENT('PlanSample', UNAPIGEN.P_EVMGR_NAME, 'sc',
                                      A_SC, '', '', '', L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);
      IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.P_TXN_ERROR := L_RESULT;
         RAISE STPERROR;
      END IF;
--
      INSERT INTO UTSCHS(SC, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
      VALUES(A_SC, NVL(A_USERID, UNAPIGEN.P_USER), UNAPIGEN.SQLUSERDESCRIPTION(NVL(A_USERID, UNAPIGEN.P_USER)), 
             L_EVENT_TP, 'sample "'||A_SC||'" is planned.', 
             CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);   
   END IF;
--select * from utschs  where sc = '2346001402'


--UPDATE NEW REGULAR-RELEASE UTSC-SAMPLE
UPDATE utsc  SET ss = '@P', lc = 'S1', lc_version = 0 WHERE sc = lvs_sc;

--------------------------------------------------------------------------------
-- Log audittrail
--------------------------------------------------------------------------------
lvi_ret_code := APAOFUNCTIONS.AddScComment( lvs_sc, 'Changed status to ''@P'' by ' || ics_package_name || '.AssignCOA');
lvi_ret_code := APAOFUNCTIONS.AddScComment( avs_sc, 'Samplecode ' || lvs_sc || ' has been created...');
lvi_ret_code := APAOFUNCTIONS.AddScPgComment( avs_sc, UNAPIEV.P_PG, UNAPIEV.P_PGNODE, 'Samplecode ' || lvs_sc || ' has been created...');
		
SELECT * FROM UTSCHS WHERE SC = '2346001402'; 		
2346001402	UNILAB	Unilab 4 Supervisor	ScInfoCreated	Info cards for sample "2346001402" are created	16-11-2023 06.32.39.000000000 PM	
2346001402	UNILAB	Unilab 4 Supervisor	SampleCreated	sample "2346001402" is created	16-11-2023 06.32.39.000000000 PM	
2346001402	UNILAB	Unilab 4 Supervisor	InfoFieldValueChanged	sample "2346001402" is updated.	16-11-2023 06.32.39.000000000 PM	
2346001402	UNILAB	Unilab 4 Supervisor	EvMgrStatusChanged	status of sample code "2346001402" is automatically changed from "Initial" [@~] to "Available" [AV].	16-11-2023 06.32.39.000000000 PM	
2346001402	UNILAB	Unilab 4 Supervisor	ScGroupKeyUpdated	sample "2346001402" group key "week" is created/updated.	16-11-2023 06.32.39.000000000 PM	
2346001402	UNILAB	Unilab 4 Supervisor	ScGroupKeyUpdated	sample "2346001402" group key "day" is created/updated.	16-11-2023 06.32.39.000000000 PM	
2346001402	UNILAB	Unilab 4 Supervisor	ScGroupKeyUpdated	sample "2346001402" group key "month" is created/updated.	16-11-2023 06.32.39.000000000 PM	
2346001402	UNILAB	Unilab 4 Supervisor	ScGroupKeyUpdated	sample "2346001402" group key "year" is created/updated.	16-11-2023 06.32.39.000000000 PM	
2346001402	UNILAB	Unilab 4 Supervisor	ScGroupKeyUpdated	sample "2346001402" group key "Context" is created/updated.	16-11-2023 06.32.42.000000000 PM	
2346001402	UNILAB	Unilab 4 Supervisor	EvMgrStatusChanged	status of sample code "2346001402" is automatically changed from "Available" [AV] to "Completed" [CM].	16-11-2023 06.32.42.000000000 PM	
2346001402	UNILAB	Unilab 4 Supervisor	CustomComment	Custom comment added by APAOFUNCTIONS.AddScComment	22-11-2023 11.36.29.000000000 PM	Samplecode 2347001760 has been created...
2346001402	UNILAB	Unilab 4 Supervisor	CustomComment	Custom comment added by APAOFUNCTIONS.AddScComment	22-11-2023 11.36.29.000000000 PM	Parametergroup <Greenstrength at 23C> of samplecode 2347001760 has been deleted
2346001402	UNILAB	Unilab 4 Supervisor	CustomComment	Custom comment added by APAOFUNCTIONS.AddScComment	22-11-2023 11.36.29.000000000 PM	Parametergroup <Greenstrength at 40C> of samplecode 2347001760 has been deleted
2346001402	UNILAB	Unilab 4 Supervisor	CustomComment	Custom comment added by APAOFUNCTIONS.AddScComment	22-11-2023 11.36.29.000000000 PM	Parametergroup <Ozon - static (ISO)> of samplecode 2347001760 has been deleted
2346001402	UNILAB	Unilab 4 Supervisor	CustomComment	Custom comment added by APAOFUNCTIONS.AddScComment	22-11-2023 11.36.29.000000000 PM	Parametergroup <Properties FM> of samplecode 2347001760 has been deleted
2346001402	UNILAB	Unilab 4 Supervisor	CustomComment	Custom comment added by APAOFUNCTIONS.AddScComment	22-11-2023 11.36.29.000000000 PM	Parametergroup <RPA vulc prop 160C> of samplecode 2347001760 has been deleted
2346001402	UNILAB	Unilab 4 Supervisor	CustomComment	Custom comment added by APAOFUNCTIONS.AddScComment	22-11-2023 11.36.29.000000000 PM	Parametergroup <Rheological props> of samplecode 2347001760 has been deleted
2346001402	UNILAB	Unilab 4 Supervisor	CustomComment	Custom comment added by APAOFUNCTIONS.AddScComment	22-11-2023 11.37.26.000000000 PM	Samplecode 2347001760 will not be used...
		
--conclusie: HIJ KOMT DUS BLIJKBAAR NIET BIJ HET WEGSCHRIJVEN VAN AUDIT-HISTORY-RECORDS...
--           EN ZIEN WE OOK NIET WELK SAMPLE DAT ER IS AANGEMAAKT.	

--controle of SAMPLE wel goed is aangemaakt...
SELECT * FROM UTERROR WHERE API_NAME = 'APAOFUNCTIONS.CreateSample' 
JOB	Database	UNILAB	22-03-2023 09.03.50.000000000 PM	22-03-2023 09.03.50.000000000 PM CET	APAOFUNCTIONS.CreateSample	CreateSample: sc=,st=EM_700,cic=,cpg=MANUAL ASSIGNMENT,mr=Job	4879436
JOB	Database	UNILAB	22-03-2023 09.03.50.000000000 PM	22-03-2023 09.03.50.000000000 PM CET	APAOFUNCTIONS.CreateSample	CreateSample failed. Return code:11	4879437
		

--CONTROLE SC-ATTRIBUTES
select SC, ST, SS, LC, LC_VERSION FROM UTSC WHERE SC='2346001402';
2346001402	EM_716	CM	S1	0

--LOOP START VOOR ALLE 7 PP MET FREQ <> ALWAYS
LOOP  lvr_pp in lvq_pp_not_always
  IF APAOFUNCTIONS.EvalAssignmentfreq(lvs_sc, lvr_pp.pp) THEN

FUNCTION EvalAssignmentfreq(avs_sc IN APAOGEN.NAME_TYPE,
                            avs_pp IN APAOGEN.NAME_TYPE)
RETURN BOOLEAN IS

lcs_function_name    CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'EvalAssignmentfreq';

lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvb_ret_code     BOOLEAN;
lvi_row                    INTEGER;
--Specific local variables
lvs_main_object_tp         VARCHAR2(2);
lvs_main_object_id         VARCHAR2(20);
lvs_main_object_version    VARCHAR2(20);
lvs_object_tp              VARCHAR2(4);
lvs_object_id              VARCHAR2(20);
lvs_object_version         VARCHAR2(20);
lvc_freq_tp                CHAR(1);
lvi_freq_val               NUMBER;
lvs_freq_unit              VARCHAR2(20);
lvc_invert_freq            CHAR(1);
lvd_ref_date               TIMESTAMP WITH TIME ZONE;
lvd_last_sched             TIMESTAMP WITH TIME ZONE;
lvi_last_cnt               NUMBER;
lvs_last_val               VARCHAR2(40);

BEGIN
 BEGIN
   SELECT b.sc, b.st_version,
      a.freq_tp, a.freq_val, a.freq_unit, a.invert_freq,
      a.last_sched, a.last_cnt, a.last_val
    INTO lvs_main_object_id, lvs_main_object_version,
         lvc_freq_tp, lvi_freq_val, lvs_freq_unit, lvc_invert_freq,
       lvd_last_sched, lvi_last_cnt, lvs_last_val
    FROM utstpp a, utsc b
   WHERE b.sc = avs_sc
     AND a.st = b.st
     AND a.version = b.st_version
     AND a.pp = avs_pp;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
     RETURN FALSE;
  END;

 lvs_main_object_tp  := 'sc';
 lvs_object_tp    := ''; --currently not used
 lvs_object_id    := ''; --currently not used
 lvs_object_version  := ''; --currently not used
 lvd_ref_date    := CURRENT_TIMESTAMP;

 lvb_ret_code := UNAPIAUT.EVALASSIGNMENTFREQ(lvs_main_object_tp,
                           lvs_main_object_id,
                           lvs_main_object_version,
                           lvs_object_tp,
                           lvs_object_id,
                           lvs_object_version,
                           lvc_freq_tp,
                           lvi_freq_val,
                           lvs_freq_unit,
                           lvc_invert_freq,
                           lvd_ref_date,
                           lvd_last_sched,
                           lvi_last_cnt,
                           lvs_last_val);
   RETURN lvb_ret_code;
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
        APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN FALSE;
END EvalAssignmentfreq;

--ONDERZOEK CURSOR

--Greenstrength at 23C

SELECT b.sc, b.st_version,
      a.freq_tp, a.freq_val, a.freq_unit, a.invert_freq,
      a.last_sched, a.last_cnt, a.last_val
    FROM utstpp a, utsc b
   WHERE b.sc = '2346001402'
     AND a.st = b.st
     AND a.version = b.st_version
     AND a.pp = 'MDR vulc prop 190C'  --'Greenstrength at 23C';

2346001402	0081.01	S	1	sc	0	22-11-2023 11.40.21.000000000 PM	0	
2346001402	0081.01	N	1		0		0	

--ATAOCONSTANT
au_expiration	avCustExpiration	



--dd. 23-11-2023
2347000968	MDR vulc prop 190C	1000000
2347000983	MDR vulc prop 190C	1000000
2347000995	MDR vulc prop 190C	1000000

--CONCLUSIE: SAMPLES VAN GISTEREN ZIJN ONDERTUSSEN WEL UIT DE TABEL REGULARRELEASEPLANNED VERWIJDERD !!!
--           KOMT WAARSCHIJNLIJK DOOR DE DELETE/COMMIT IN DE JOB-PROCEDURE, VOORDAT NIEUWE SAMPLE VOLLEDIG IS AANGEMAAKT.
--           PROCES CRASHED NU, EN ZIJN WE SAMPLE KWIJT....  (SLECHT OPGEZET DUS...)
--

--Kijken we in voorbeeld-UNILINK-bestand wat in verleden gebruikt is voor het testen komen we volgende tegen:
pg=MDR vulc prop 190C
pp_key1=ZZ_716

select * from utscpg where pg ='MDR vulc prop 190C' and pp_key1='ZZ_716';
112108638	MDR vulc prop 190C	1000000	0041.01	ZZ_716	 	 	 	 	MDR vulcanisation properties, 190°C		
112108639	MDR vulc prop 190C	1000000	0041.01	ZZ_716	 	 	 	 	MDR vulcanisation properties, 190°C		
112108640	MDR vulc prop 190C	1000000	0041.01	ZZ_716	 	 	 	 	MDR vulcanisation properties, 190°C		
112108641	MDR vulc prop 190C	1000000	0041.01	ZZ_716	 	 	 	 	MDR vulcanisation properties, 190°C		
112109931	MDR vulc prop 190C	1000000	0041.01	ZZ_716	 	 	 	 	MDR vulcanisation properties, 190°C		
112109932	MDR vulc prop 190C	1000000	0041.01	ZZ_716	 	 	 	 	MDR vulcanisation properties, 190°C		
112109936	MDR vulc prop 190C	1000000	0041.01	ZZ_716	 	 	 	 	MDR vulcanisation properties, 190°C		
112201362	MDR vulc prop 190C	1000000	0041.01	ZZ_716	 	 	 	 	MDR vulcanisation properties, 190°C		
112201363	MDR vulc prop 190C	1000000	0041.01	ZZ_716	 	 	 	 	MDR vulcanisation properties, 190°C		
1913006622	MDR vulc prop 190C	1000000	0041.01	ZZ_716	 	 	 	 	MDR vulcanisation properties, 190°C		
1913006623	MDR vulc prop 190C	1000000	0041.01	ZZ_716	 	 	 	 	MDR vulcanisation properties, 190°C		
1913006629	MDR vulc prop 190C	1000000	0041.01	ZZ_716	 	 	 	 	MDR vulcanisation properties, 190°C		
1913006630	MDR vulc prop 190C	1000000	0041.01	ZZ_716	 	 	 	 	MDR vulcanisation properties, 190°C		
1913006633	MDR vulc prop 190C	1000000	0041.01	ZZ_716	 	 	 	 	MDR vulcanisation properties, 190°C		
1913006634	MDR vulc prop 190C	1000000	0041.01	ZZ_716	 	 	 	 	MDR vulcanisation properties, 190°C		

select * from utschs where sc = '112108638';
112108638	UNILAB	Unilab 4 Supervisor	ScInfoCreated		Info cards for sample "112108638" are created	28-05-2011 03.29.17.000000000 PM		106436	587275
112108638	UNILAB	Unilab 4 Supervisor	SampleCreated		sample "112108638" is created					28-05-2011 03.29.17.000000000 PM		106436	587276
112108638	UNILAB	Unilab 4 Supervisor	InfoFieldValueChanged	sample "112108638" is updated.				28-05-2011 03.29.17.000000000 PM		106436	587280
112108638	UNILAB	Unilab 4 Supervisor	EvMgrStatusChanged	status of sample code "112108638" is automatically changed from "Initial" [@~] to "Available" [AV].	28-05-2011 03.29.19.000000000 PM		106438	587269
112108638	UNILAB	Unilab 4 Supervisor	ScGroupKeyUpdated	sample "112108638" group key "week" is created/updated.	28-05-2011 03.29.19.000000000 PM		106438	587339
112108638	UNILAB	Unilab 4 Supervisor	ScGroupKeyUpdated	sample "112108638" group key "day" is created/updated.	28-05-2011 03.29.19.000000000 PM		106438	587344
112108638	UNILAB	Unilab 4 Supervisor	ScGroupKeyUpdated	sample "112108638" group key "month" is created/updated.	28-05-2011 03.29.19.000000000 PM		106438	587349
112108638	UNILAB	Unilab 4 Supervisor	ScGroupKeyUpdated	sample "112108638" group key "year" is created/updated.	28-05-2011 03.29.19.000000000 PM		106438	587350
112108638	UNILAB	Unilab 4 Supervisor	CustomComment		Custom comment added by APAOFUNCTIONS.AddScComment	28-05-2011 03.29.22.000000000 PM	Samplecode 112108642 has been created...	106438	587350
112108638	UNILAB	Unilab 4 Supervisor	CustomComment		Custom comment added by APAOFUNCTIONS.AddScComment	28-05-2011 03.29.22.000000000 PM	Parametergroup <Greenstrength at 40C> of samplecode 112108642 has been deleted	106438	587350
112108638	UNILAB	Unilab 4 Supervisor	CustomComment		Custom comment added by APAOFUNCTIONS.AddScComment	28-05-2011 03.29.22.000000000 PM	Parametergroup <Ozon - dynamic (ISO)> of samplecode 112108642 has been deleted	106438	587350
112108638	UNILAB	Unilab 4 Supervisor	CustomComment		Custom comment added by APAOFUNCTIONS.AddScComment	28-05-2011 03.29.22.000000000 PM	Parametergroup <Ozon - static (ISO)> of samplecode 112108642 has been deleted	106438	587350
112108638	UNILAB	Unilab 4 Supervisor	CustomComment		Custom comment added by APAOFUNCTIONS.AddScComment	28-05-2011 03.29.22.000000000 PM	Parametergroup <Properties FM> of samplecode 112108642 has been deleted	106438	587350
112108638	UNILAB	Unilab 4 Supervisor	CustomComment		Custom comment added by APAOFUNCTIONS.AddScComment	28-05-2011 03.29.22.000000000 PM	Parametergroup <RPA vulc prop 160C> of samplecode 112108642 has been deleted	106438	587350
112108638	UNILAB	Unilab 4 Supervisor	CustomComment		Custom comment added by APAOFUNCTIONS.AddScComment	28-05-2011 03.29.22.000000000 PM	Parametergroup <Rheological props> of samplecode 112108642 has been deleted	106438	587350
112108638	UNILAB	Unilab 4 Supervisor	EvMgrStatusChanged	status of sample code "112108638" is automatically changed from "Available" [AV] to "Out of Spec Conf." [SC].	28-05-2011 03.29.24.000000000 PM		106438	587315
112108638	UNILAB	Unilab 4 Supervisor	CustomComment		Custom comment added by APAOFUNCTIONS.AddScComment	28-05-2011 03.29.24.000000000 PM	Samplecode 112108642 will not be used...	106438	587350
112108638	UNILAB	Unilab 4 Supervisor	ScGroupKeyUpdated	sample "112108638" group key "Context" is created/updated.	28-05-2011 03.29.24.000000000 PM		106438	587500

select * from utscii where sc='112108638'
112108638	avCompound	1000000	avBatchno			1000000	0001.00	11052801		110	46	0	0	0	Batch number
112108638	avCompound	1000000	avOrderBatch		4000000	0001.00	110505A_5021	110	92	0	0	0	Concat Order-Batch
112108638	avCompound	1000000	avOrderno			2000000	0001.00	110505A			110	23	0	0	0	Order number
112108638	avCompound	1000000	avProductionDate	3000000	0001.02	11/10/2010		110	69	0	0	0	Production date


--START DE JOB NOGMAALS...
select * from uterror where api_name = 'APAOFUNCTIONS.CreateSample' order by err_seq DESC; 
JOB	Database	UNILAB	23-11-2023 07.22.35.000000000 PM	23-11-2023 07.22.35.000000000 PM CET	APAOFUNCTIONS.CreateSample	CreateSample-SUCCEEDED: sc=2347003161,st=EM_716,cic=,cpg=MANUAL ASSIGNMENT,mr=Job
JOB	Database	UNILAB	23-11-2023 07.21.44.000000000 PM	23-11-2023 07.21.44.000000000 PM CET	APAOFUNCTIONS.CreateSample	CreateSample-SUCCEEDED: sc=2347003160,st=EM_916,cic=,cpg=MANUAL ASSIGNMENT,mr=Job
JOB	Database	UNILAB	23-11-2023 07.20.52.000000000 PM	23-11-2023 07.20.52.000000000 PM CET	APAOFUNCTIONS.CreateSample	CreateSample-SUCCEEDED: sc=2347003159,st=EM_916,cic=,cpg=MANUAL ASSIGNMENT,mr=Job
JOB	Database	UNILAB	23-11-2023 07.20.01.000000000 PM	23-11-2023 07.20.01.000000000 PM CET	APAOFUNCTIONS.CreateSample	CreateSample-SUCCEEDED: sc=2347003157,st=EM_916,cic=,cpg=MANUAL ASSIGNMENT,mr=Job
JOB	Database	UNILAB	23-11-2023 07.19.09.000000000 PM	23-11-2023 07.19.09.000000000 PM CET	APAOFUNCTIONS.CreateSample	CreateSample-SUCCEEDED: sc=2347003156,st=EM_916,cic=,cpg=MANUAL ASSIGNMENT,mr=Job
JOB	Database	UNILAB	23-11-2023 07.18.18.000000000 PM	23-11-2023 07.18.18.000000000 PM CET	APAOFUNCTIONS.CreateSample	CreateSample-SUCCEEDED: sc=2347003155,st=EM_716,cic=,cpg=MANUAL ASSIGNMENT,mr=Job
JOB	Database	UNILAB	23-11-2023 07.18.18.000000000 PM	23-11-2023 07.18.18.000000000 PM CET	APAOFUNCTIONS.CreateSample	CreateSample-SUCCEEDED: sc=2347003154,st=EM_916,cic=,cpg=MANUAL ASSIGNMENT,mr=Job
JOB	Database	UNILAB	23-11-2023 07.17.27.000000000 PM	23-11-2023 07.17.27.000000000 PM CET	APAOFUNCTIONS.CreateSample	CreateSample-SUCCEEDED: sc=2347003153,st=EM_916,cic=,cpg=MANUAL ASSIGNMENT,mr=Job
JOB	Database	UNILAB	23-11-2023 07.16.37.000000000 PM	23-11-2023 07.16.37.000000000 PM CET	APAOFUNCTIONS.CreateSample	CreateSample-SUCCEEDED: sc=2347003152,st=EM_716,cic=,cpg=MANUAL ASSIGNMENT,mr=Job
JOB	Database	UNILAB	23-11-2023 07.15.38.000000000 PM	23-11-2023 07.15.38.000000000 PM CET	APAOFUNCTIONS.CreateSample	CreateSample-SUCCEEDED: sc=2347003145,st=EM_916,cic=,cpg=MANUAL ASSIGNMENT,mr=Job


select count(*) from ataoregularrelease_planned;
--830
--828
--827
--883
select max(sc) max_sc, min(sc) min_sc from ataoregularrelease_planned;
--2347002935	2347000490
--2347002940	2347000491
--2347002952	2347000499
--2347002952	2347000501
--2347002958	2347000510
--2347002989	2347000526
select count(*) from utsc where creation_date > trunc(sysdate);
--344
--353
select max(sc) from utsc where creation_date > trunc(sysdate);
--WTR2347100T01
	
select sc, creation_date from utsc where creation_date > trunc(sysdate)
and creation_date = (select max(sc2.creation_date) from utsc sc2 where creation_date > trunc(sysdate) );
2347002958			23-11-2023 03.35.57.000000000 PM
23.961.PAK02.W.RR	23-11-2023 03.43.05.000000000 PM
2347002990			23-11-2023 03.58.23.000000000 PM
--NA HERSTART...
2347003158	23-11-2023 07.20.07.000000000 PM

--oracle-session: DELETE FROM UNILAB.ATDEBUG WHERE sc = '2347002997'


--nader onderzoek op de UTUC regel 1608

SELECT WEEK_NR
FROM UTWEEKNR
WHERE DAY_OF_YEAR = TO_TIMESTAMP_TZ(TO_CHAR(sysdate,'DD/MM/YYYY')||' 00:00:00 '||DBTIMEZONE, 'DD/MM/YYYY HH24:MI:SS TZR');

27-11-2023 12.00.00.000000000 AM	1	48	2023	0	0	27-11-2023 12.00.00.000000000 AM +01:00								
26-11-2023 12.00.00.000000000 AM	7	47	2023	0	0	26-11-2023 12.00.00.000000000 AM +01:00								
25-11-2023 12.00.00.000000000 AM	6	47	2023	0	0	25-11-2023 12.00.00.000000000 AM +01:00								
24-11-2023 12.00.00.000000000 AM	5	47	2023	0	0	24-11-2023 12.00.00.000000000 AM +01:00								
23-11-2023 12.00.00.000000000 AM	4	47	2023	0	0	23-11-2023 12.00.00.000000000 AM +01:00								
22-11-2023 12.00.00.000000000 AM	3	47	2023	0	0	22-11-2023 12.00.00.000000000 AM +01:00								
21-11-2023 12.00.00.000000000 AM	2	47	2023	0	0	21-11-2023 12.00.00.000000000 AM +01:00								
20-11-2023 12.00.00.000000000 AM	1	47	2023	0	0	20-11-2023 12.00.00.000000000 AM +01:00								
19-11-2023 12.00.00.000000000 AM	7	46	2023	0	0	19-11-2023 12.00.00.000000000 AM +01:00								
18-11-2023 12.00.00.000000000 AM	6	46	2023	0	0	18-11-2023 12.00.00.000000000 AM +01:00								
17-11-2023 12.00.00.000000000 AM	5	46	2023	0	0	17-11-2023 12.00.00.000000000 AM +01:00								
16-11-2023 12.00.00.000000000 AM	4	46	2023	0	0	16-11-2023 12.00.00.000000000 AM +01:00								
15-11-2023 12.00.00.000000000 AM	3	46	2023	0	0	15-11-2023 12.00.00.000000000 AM +01:00								
14-11-2023 12.00.00.000000000 AM	2	46	2023	0	0	14-11-2023 12.00.00.000000000 AM +01:00								
13-11-2023 12.00.00.000000000 AM	1	46	2023	0	0	13-11-2023 12.00.00.000000000 AM +01:00								
12-11-2023 12.00.00.000000000 AM	7	45	2023	0	0	12-11-2023 12.00.00.000000000 AM +01:00								
			   



	 
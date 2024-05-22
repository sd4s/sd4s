--Probleem: Er blijven heel veel ARCHIVE-LOG-SWITCHES binnenkomen.

--Bekijk via TOAD ALL de oracle-sessions (incl. RDBMS-jobs)
--Bekijk de ORACLE-JOB-session J00/J01/J02/J03.

--J00

/* Formatted on 27/10/2022 16:41:50 (QP5 v5.362) */
DECLARE
    job         BINARY_INTEGER := :job;
    next_date   DATE := :mydate;
    broken      BOOLEAN := FALSE;
BEGIN
    pa_limsspc.f_transferallhistobs;
    :mydate := next_date;
    IF broken
    THEN
        :b := 1;
    ELSE
        :b := 0;
    END IF;
END;


--J01:	C:\oracle\diag\rdmbs\is61\trace\IS61_J001_361536.trc

/* Formatted on 27/10/2022 16:42:29 (QP5 v5.362) */
DECLARE
    job         BINARY_INTEGER := :job;
    next_date   DATE := :mydate;
    broken      BOOLEAN := FALSE;
BEGIN
    DECLARE
        lnRetVal   iapiType.ErrorNum_Type;
    BEGIN
        lnRetVal := iapiEmail.SendEmails;
    END;
    :mydate := next_date;
    IF broken
    THEN
        :b := 1;
    ELSE
        :b := 0;
    END IF;
END;

--J02: leeg

--J03:  J003_579812.trc

/* Formatted on 27/10/2022 16:46:25 (QP5 v5.362) */
DECLARE
    job         BINARY_INTEGER := :job;
    next_date   DATE := :mydate;
    broken      BOOLEAN := FALSE;
BEGIN
    iapiQueue.ExecuteQueue;
    :mydate := next_date;

    IF broken
    THEN
        :b := 1;
    ELSE
        :b := 0;
    END IF;
END;

--J04:  J04_500904.trc

/* Formatted on 27/10/2022 16:47:22 (QP5 v5.362) */
DECLARE
    job         BINARY_INTEGER := :job;
    next_date   DATE := :mydate;
    broken      BOOLEAN := FALSE;
BEGIN
    pa_limsinterface.p_transfercfgandspc;
    :mydate := next_date;

    IF broken
    THEN
        :b := 1;
    ELSE
        :b := 0;
    END IF;
END;

/* Formatted on 27/10/2022 16:48:24 (QP5 v5.362) */
  SELECT DISTINCT job.plant, JOB.REVISION, JOB.PART_NO, JOB.PRIORITY, RESULT_PROCEED
    FROM ITLIMSJOB JOB, ITLIMSPLANT PL
   WHERE     JOB.TO_BE_UPDATED = '2'
         AND JOB.DATE_TRANSFERRED IS NOT NULL
         AND JOB.RESULT_TRANSFER = 1
         AND (PL.CONNECT_STRING, PL.LANG_ID, PL.LANG_ID_4ID) IN
                 (SELECT PL2.CONNECT_STRING, PL2.LANG_ID, PL2.LANG_ID_4ID
                    FROM ITLIMSPLANT PL2
                   WHERE PL2.PLANT = :B1)
         AND PL.PLANT = JOB.PLANT
ORDER BY JOB.PRIORITY

--result:
-- 4	615851	2	GYO


CREATE OR REPLACE FORCE VIEW "INTERSPC"."AV_DBA_MONITOR_LIMSJOB_ACTIVE" ("PLANT", "PART_NO", "REVISION", "DATE_READY", "DATE_PROCEED", "RESULT_PROCEED", "RESULT_TRANSFER", "TO_BE_TRANSFERRED", "RESULT_LAST_UPDATE", "TO_BE_UPDATED", "PRIORITY", "HERSTEL_ACTIE") AS 
SELECT DISTINCT 
 JOB.PLANT
,JOB.PART_NO
,JOB.REVISION
,JOB.DATE_READY
,JOB.DATE_PROCEED
,JOB.RESULT_PROCEED
,JOB.RESULT_TRANSFER
,JOB.TO_BE_TRANSFERRED
,JOB.RESULT_LAST_UPDATE
,JOB.TO_BE_UPDATED
,JOB.PRIORITY
,'UITZET-CMD: UPDATE ITLIMSJOB SET RESULT_PROCEED=1, TO_BE_UPDATED=DECODE(TO_BE_UPDATED,2,1,TO_BE_UPDATED), TO_BE_TRANSFERRED=DECODE(TO_BE_TRANSFERRED,2,1,TO_BE_TRANSFERRED) WHERE PLANT='||''''||JOB.PLANT||''''||' AND PART_NO='||''''||JOB.PART_NO||''''||' AND REVISION='||JOB.REVISION||' AND NVL(RESULT_PROCEED,0)<>1;'
FROM  ITLIMSJOB JOB
WHERE (  (   JOB.TO_BE_UPDATED = '2'
         OR  (   JOB.TO_BE_UPDATED <> '0'
		     AND JOB.RESULT_LAST_UPDATE <> '1' )
		 )
      OR (    JOB.TO_BE_TRANSFERRED = '2'
         OR  (   JOB.TO_BE_TRANSFERRED <> '0'
		     AND JOB.RESULT_TRANSFER <> '1' )
         )
	  )
AND nvl(JOB.RESULT_PROCEED,0) <> 1
;

--CONCLUSIE: DOOR DE WAARDE IN ATTRIBUUT TO_BE_UPDATED=2 WERD PART-NO IEDERE KEER WEER GESELECTEERD VOOR VERWERKING !!!!!!!

--try to fix this:

SELECT DISTINCT JOB.PLANT
,JOB.PART_NO
,JOB.REVISION
,JOB.DATE_READY
,JOB.DATE_PROCEED
,JOB.RESULT_PROCEED
,JOB.RESULT_TRANSFER
,JOB.TO_BE_TRANSFERRED
,JOB.RESULT_LAST_UPDATE
,JOB.TO_BE_UPDATED
,JOB.PRIORITY
,'UITZET-CMD: UPDATE ITLIMSJOB SET RESULT_PROCEED=1, TO_BE_UPDATED=DECODE(TO_BE_UPDATED,2,1,TO_BE_UPDATED), TO_BE_TRANSFERRED=DECODE(TO_BE_TRANSFERRED,2,1,TO_BE_TRANSFERRED) WHERE PLANT='||''''||JOB.PLANT||''''||' AND PART_NO='||''''||JOB.PART_NO||''''||' AND REVISION='||JOB.REVISION||' AND NVL(RESULT_PROCEED,0)<>1;'
FROM  ITLIMSJOB JOB
WHERE part_no =  '615851'
;

plant 	partno rev  date-ready          date-proceed       	result-proc	result-transf	to-be-transf	result-last-upd	to-be-upd	priority	command
ENS		615851	5	21-10-2022 09:39:30	22-10-2022 00:01:12	1			1				0				1				0			1			UITZET-CMD: UPDATE ITLIMSJOB SET RESULT_PROCEED=1, TO_BE_UPDATED=DECODE(TO_BE_UPDATED,2,1,TO_BE_UPDATED), TO_BE_TRANSFERRED=DECODE(TO_BE_TRANSFERRED,2,1,TO_BE_TRANSFERRED) WHERE PLANT='ENS' AND PART_NO='615851' AND REVISION=5 AND NVL(RESULT_PROCEED,0)<>1;
GYO		615851	4	21-10-2022 09:27:53	21-10-2022 09:29:47	1			1				0								2			2			UITZET-CMD: UPDATE ITLIMSJOB SET RESULT_PROCEED=1, TO_BE_UPDATED=DECODE(TO_BE_UPDATED,2,1,TO_BE_UPDATED), TO_BE_TRANSFERRED=DECODE(TO_BE_TRANSFERRED,2,1,TO_BE_TRANSFERRED) WHERE PLANT='GYO' AND PART_NO='615851' AND REVISION=4 AND NVL(RESULT_PROCEED,0)<>1;


--MET STANDAARD HERSTEL-UPDATE PROBEREN TE HERSTELLEN....

UPDATE ITLIMSJOB 
SET RESULT_PROCEED=1
, TO_BE_UPDATED=DECODE(TO_BE_UPDATED,2,1,TO_BE_UPDATED)
, TO_BE_TRANSFERRED=DECODE(TO_BE_TRANSFERRED,2,1,TO_BE_TRANSFERRED) 
WHERE PLANT='GYO'     
AND PART_NO='615851' 
AND REVISION='4' 
--AND NVL(RESULT_PROCEED,0)<>1
;

--MET DEFAULT SQL-STATEMENT ALS OPLOS-METHODE LUKT HET NIET DIRECT, DE RESULT_PROCEED IS AL 1 IN DIT GEVAL, WAARDOOR ER NIETS GEUPDATE WERD.
--OM DEZE REDEN DE NLV(RESULT_PROCEED,0)<>1 UIT WHERE-CLAUSE HALEN !!! DAN LUKT HET WEL.


SELECT DISTINCT JOB.PLANT
,JOB.PART_NO
,JOB.REVISION
,JOB.DATE_READY
,JOB.DATE_PROCEED
,JOB.RESULT_PROCEED
,JOB.RESULT_TRANSFER
,JOB.TO_BE_TRANSFERRED
,JOB.RESULT_LAST_UPDATE
,JOB.TO_BE_UPDATED
,JOB.PRIORITY
,'UITZET-CMD: UPDATE ITLIMSJOB SET RESULT_PROCEED=1, TO_BE_UPDATED=DECODE(TO_BE_UPDATED,2,1,TO_BE_UPDATED), TO_BE_TRANSFERRED=DECODE(TO_BE_TRANSFERRED,2,1,TO_BE_TRANSFERRED) WHERE PLANT='||''''||JOB.PLANT||''''||' AND PART_NO='||''''||JOB.PART_NO||''''||' AND REVISION='||JOB.REVISION||' AND NVL(RESULT_PROCEED,0)<>1;'
FROM  ITLIMSJOB JOB
WHERE part_no =  '615851'
;

plant 	partno rev  date-ready          date-proceed       	result-proc	result-transf	to-be-transf	result-last-upd	to-be-upd	priority	command
ENS		615851	5	21-10-2022 09:39:30	22-10-2022 00:01:12	1			1				0				1				0			1			UITZET-CMD: UPDATE ITLIMSJOB SET RESULT_PROCEED=1, TO_BE_UPDATED=DECODE(TO_BE_UPDATED,2,1,TO_BE_UPDATED), TO_BE_TRANSFERRED=DECODE(TO_BE_TRANSFERRED,2,1,TO_BE_TRANSFERRED) WHERE PLANT='ENS' AND PART_NO='615851' AND REVISION=5 AND NVL(RESULT_PROCEED,0)<>1;
GYO		615851	4	21-10-2022 09:27:53	21-10-2022 09:29:47	1			1				0								1			2			UITZET-CMD: UPDATE ITLIMSJOB SET RESULT_PROCEED=1, TO_BE_UPDATED=DECODE(TO_BE_UPDATED,2,1,TO_BE_UPDATED), TO_BE_TRANSFERRED=DECODE(TO_BE_TRANSFERRED,2,1,TO_BE_TRANSFERRED) WHERE PLANT='GYO' AND PART_NO='615851' AND REVISION=4 AND NVL(RESULT_PROCEED,0)<>1;

--CONCLUSIE: LIJKT OPGELOST TE ZIJN. SYSTEEM WORDT WEER RUSTIG !!!


--ECHTER DE VOLGENDE OCHTEND OM 03:00 UUR SNACHTS BEGINT HET PROCES WEER SPONTAAN TE LOPEN !!!!!!!!
--GEEN IDEE WAAROM...
--GAAN TOCH MAAR WEER HETZELFDE DOEN ALS HIERVOOR. NOGMAALS DE TO-BE-UPDATED MET ANDERE WAARDEVOORZIEN...




UPDATE ITLIMSJOB 
SET RESULT_PROCEED=1
, TO_BE_UPDATED=DECODE(TO_BE_UPDATED,2,1,TO_BE_UPDATED)
, TO_BE_TRANSFERRED=DECODE(TO_BE_TRANSFERRED,2,1,TO_BE_TRANSFERRED) 
WHERE PLANT='GYO'     
AND PART_NO='615851' 
AND REVISION='4' 
--AND NVL(RESULT_PROCEED,0)<>1
;

ENS	615851	5	21-10-2022 09:39:30	22-10-2022 00:01:12	1	1	0	1	0	1
GYO	615851	4	21-10-2022 09:27:53	21-10-2022 09:29:47	1	1	0		1	2

--ALS DIT NIET WERKT, DAN ZULLEN WE DE "TO_BE_UPDATED" NIET MET WAARDE=1, MAAR MET WAARDE=0 MOETEN GAAN BIJWERKEN.
--

UPDATE ITLIMSJOB 
SET RESULT_PROCEED=1
, TO_BE_UPDATED=DECODE(TO_BE_UPDATED,2,0,1,0,TO_BE_UPDATED)
, TO_BE_TRANSFERRED=DECODE(TO_BE_TRANSFERRED,2,1,TO_BE_TRANSFERRED) 
WHERE PLANT='GYO'     
AND PART_NO='615851' 
AND REVISION='4' 
--AND NVL(RESULT_PROCEED,0)<>1
;

ENS	615851	5	21-10-2022 09:39:30	22-10-2022 00:01:12	1	1	0	1	0	1
GYO	615851	4	21-10-2022 09:27:53	21-10-2022 09:29:47	1	1	0		0	2

--MAANDAG MAAR KIJKEN WAT HET RESULTAAT IS...

--J05: leeg

























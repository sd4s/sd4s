CREATE OR REPLACE PROCEDURE dba_set_job_verw_gewicht_mut
IS
--************************************************************************************************
--Procedure om database-jobs te starten, te weten:
--6) aapiweight_calc.dba_verwerk_gewicht_mutaties
--
--LET OP: Met behulp van procedure: INTERSPC.DBA_REMOVE_SET_JOBS zijn deze jobs te stoppen !!!!!
--
--************************************************************************************************
-- revision-history   who      what
-- 22-09-2022         Peter S. Create unwrapped-verion
-- 22-09-2022         Peter S. Add job VERWERK_GEWICHT_MUTATIES, om dagelijks mutaties op gewicht 
--                             te berereken en op te slaan in DBA_WEIGHT_COMPONENT_PART.
--************************************************************************************************
JOB                           BINARY_INTEGER;
WHAT                          VARCHAR2(255);
NEXT_DATE                     DATE;
INTERVAL                      VARCHAR2(255);
NO_PARSE                      BOOLEAN;
L_PARENT                      ITDBPROFILE.OWNER%TYPE;
L_3TIER_DB                    NUMBER;
--select job, what, 
CURSOR L_JOB_CURSOR(A_WHAT  IN VARCHAR2 )
IS
SELECT JOB
FROM DBA_JOBS
WHERE UPPER( WHAT ) LIKE UPPER( A_WHAT )
;
BEGIN
   --aapiweight_calc.dba_verwerk_gewicht_mutaties
   --************************************************************************************
   DBMS_OUTPUT.PUT_LINE( '- aapiweight_calc.dba_verwerk_gewicht_mutaties.' );
   --************************************************************************************
   --
   OPEN L_JOB_CURSOR( '%verwerk_gewicht_mutaties%' );
   LOOP
     FETCH L_JOB_CURSOR
     INTO JOB;
     EXIT WHEN L_JOB_CURSOR%NOTFOUND;
     DBMS_JOB.REMOVE( JOB );
     COMMIT;
   END LOOP;
   --
   CLOSE L_JOB_CURSOR;
   --
   --DEFAULT: run dagelijks om 01:00:00 uur !!!
   --TEST-mode: run ieder vol uur na sysdate
   --INTERVAL := 'SYSDATE + 2/24';              
   INTERVAL := 'TRUNC(SYSDATE) + 1 + 1/24';              
   NO_PARSE := FALSE;
   WHAT     := 'aapiweight_calc.dba_verwerk_gewicht_mutaties;';
   --NEXT_DATE :=   SYSDATE + 2/24;              
   NEXT_DATE :=   TRUNC( SYSDATE ) + 1 + 1/24;              
   --                
   DBMS_JOB.SUBMIT( JOB,
                    WHAT,
                    NEXT_DATE,
                    INTERVAL,
                    NO_PARSE );
   DBMS_JOB.NEXT_DATE( JOB,
                       NEXT_DATE );
   COMMIT;
   DBMS_OUTPUT.PUT_LINE(    'interval   '|| INTERVAL|| '  next_date  '|| TO_CHAR( NEXT_DATE,'DD-MON-YY HH24:MI:SS' ) );
   --
END dba_set_job_verw_gewicht_mut;
/

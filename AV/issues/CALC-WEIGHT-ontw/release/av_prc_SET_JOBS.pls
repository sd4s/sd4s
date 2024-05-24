CREATE OR REPLACE PROCEDURE set_jobs
IS
--************************************************************************************************
--Procedure om database-jobs te starten, te weten:
--1) iapiDeletion.RemoveObsoleteData
--2) iapiSpecificationStatus.AutoStatus
--3) PA_TRANSFER.P_TRANSFER_SCHEDULE
--4) sp_approve_blocked_spec
--5) iapiCheckProcessing.CheckProcessing
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
--
CURSOR L_JOB_CURSOR(A_WHAT  IN VARCHAR2 )
IS
SELECT JOB
FROM DBA_JOBS
WHERE UPPER( WHAT ) LIKE UPPER( A_WHAT )
;
BEGIN
   --************************************************************************************
   DBMS_OUTPUT.PUT_LINE( '- iapiDeletion.RemoveObsoleteData.' );
   --************************************************************************************
   OPEN L_JOB_CURSOR( '%RemoveObsoleteData%' );
   LOOP
     FETCH L_JOB_CURSOR
     INTO JOB;
	 --
     EXIT WHEN L_JOB_CURSOR%NOTFOUND;
     DBMS_JOB.REMOVE( JOB );
     COMMIT;
   END LOOP;
   --
   CLOSE L_JOB_CURSOR;
   --
   INTERVAL := 'TRUNC(SYSDATE) + 1';
   NO_PARSE := FALSE;
   WHAT     := 'iapiDeletion.RemoveObsoleteData;';
   NEXT_DATE :=   TRUNC( SYSDATE ) + 1;                
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
   --************************************************************************************
   DBMS_OUTPUT.PUT_LINE( '- iapiSpecificationStatus.AutoStatus.' );
   --************************************************************************************
   OPEN L_JOB_CURSOR( '%Autostatus%' );
   LOOP
     FETCH L_JOB_CURSOR
     INTO JOB;
     --
     EXIT WHEN L_JOB_CURSOR%NOTFOUND;
     DBMS_JOB.REMOVE( JOB );
     COMMIT;
   END LOOP;
   --
   CLOSE L_JOB_CURSOR;
   --
   INTERVAL := 'TRUNC(SYSDATE) + 1';
   NO_PARSE := FALSE;
   WHAT     := 'iapiSpecificationStatus.AutoStatus;';
   NEXT_DATE :=   TRUNC( SYSDATE ) + 1;                
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
   --************************************************************************************
   DBMS_OUTPUT.PUT_LINE( '- PA_TRANSFER.P_TRANSFER_SCHEDULE.' );
   --************************************************************************************
   BEGIN
     SELECT PARAMETER_DATA
     INTO L_3TIER_DB
     FROM INTERSPC_CFG
     WHERE SECTION = 'interspec'
     AND PARAMETER = '3 tier db'
	 ;
   EXCEPTION
     WHEN NO_DATA_FOUND
     THEN L_3TIER_DB := 0;
   END;
   DBMS_OUTPUT.PUT_LINE(    'Interspc_cfg setting [3 tier db] =   '|| L_3TIER_DB );
   IF L_3TIER_DB = 1
   THEN
     DBMS_OUTPUT.PUT_LINE( '   => Checking P_TRANSFER_SCHEDULE' );
	 --
     SELECT MAX( PARENT_OWNER )
     INTO L_PARENT
     FROM ITDBPROFILE
     WHERE OWNER = ( SELECT PARAMETER_DATA
                     FROM INTERSPC_CFG
                     WHERE PARAMETER = 'owner'
                     AND SECTION = 'interspec' 
				   );
     --
     IF L_PARENT IS NOT NULL
     THEN
       OPEN L_JOB_CURSOR( '%TRANSFER%' );
       LOOP
         FETCH L_JOB_CURSOR
         INTO JOB;
         EXIT WHEN L_JOB_CURSOR%NOTFOUND;
         DBMS_JOB.REMOVE( JOB );
         COMMIT;
       END LOOP;
       CLOSE L_JOB_CURSOR;
       --
       INTERVAL := 'TRUNC(SYSDATE) + 1';
       NO_PARSE := FALSE;
       WHAT     := 'PA_TRANSFER.P_TRANSFER_SCHEDULE;';
       NEXT_DATE :=   TRUNC( SYSDATE ) + 1;                 
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
     END IF;
   ELSE
      DBMS_OUTPUT.PUT_LINE( '   => Not starting P_TRANSFER_SCHEDULE' );
   END IF;
   --
   --************************************************************************************
   DBMS_OUTPUT.PUT_LINE( '- sp_approve_blocked_spec.' );
   --************************************************************************************
   --
   OPEN L_JOB_CURSOR( '%approve%' );
   LOOP
     FETCH L_JOB_CURSOR
     INTO JOB;
     EXIT WHEN L_JOB_CURSOR%NOTFOUND;
     DBMS_JOB.REMOVE( JOB );
     COMMIT;
   END LOOP;
   CLOSE L_JOB_CURSOR;
   --
   INTERVAL := 'TRUNC(SYSDATE) + 1';
   NO_PARSE := FALSE;
   WHAT     := 'sp_approve_blocked_spec;';
   NEXT_DATE :=   TRUNC( SYSDATE ) + 1;              
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
   --************************************************************************************
   DBMS_OUTPUT.PUT_LINE( '- iapiCheckProcessing.CheckProcessing.' );
   --************************************************************************************
   --
   OPEN L_JOB_CURSOR( '%iapiCheckProcessing%' );
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
   INTERVAL := 'TRUNC(SYSDATE) + 1';
   NO_PARSE := FALSE;
   WHAT     := 'iapiCheckProcessing.CheckProcessing(1);';
   NEXT_DATE :=   TRUNC( SYSDATE ) + 1;              
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
   INTERVAL := 'TRUNC(SYSDATE) + 1 + 1/24';
   NO_PARSE := FALSE;
   WHAT     := 'aapiweight_calc.dba_verwerk_gewicht_mutaties;';
   NEXT_DATE :=   TRUNC( SYSDATE ) + 1;              
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
END SET_JOBS;
/

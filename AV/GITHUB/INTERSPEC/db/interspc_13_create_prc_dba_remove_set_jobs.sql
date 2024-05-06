CREATE OR REPLACE PROCEDURE dba_remove_set_jobs
IS
--Procedure om alle JOBS uit procedure SET_JOBS te killen/removen. 
--Deze jobs zitten niet standaard in de STOPALLDBJOBS en moeten we dus handmatig uitzetten !!!
--
--Het betreft dan de jobs:
--1260  TRUNC(SYSDATE) + 1    iapiDeletion.RemoveObsoleteData;
--1261  TRUNC(SYSDATE) + 1    iapiSpecificationStatus.AutoStatus;
--1262	TRUNC(SYSDATE) + 1		sp_approve_blocked_spec;
--1263	TRUNC(SYSDATE) + 1		iapiCheckProcessing.CheckProcessing(1);
--
JOB                           BINARY_INTEGER;
WHAT                          VARCHAR2( 255 );
NEXT_DATE                     DATE;
INTERVAL                      VARCHAR2( 255 );
NO_PARSE                      BOOLEAN;
L_PARENT                      ITDBPROFILE.OWNER%TYPE;
L_3TIER_DB                    NUMBER;
--
CURSOR L_JOB_CURSOR( A_WHAT IN  VARCHAR2 )
IS
SELECT JOB
FROM DBA_JOBS
WHERE UPPER( WHAT ) LIKE UPPER( A_WHAT )
;
BEGIN
   DBMS_OUTPUT.PUT_LINE( '- iapiDeletion.RemoveObsoleteData.' );
   OPEN L_JOB_CURSOR( '%RemoveObsoleteData%' );
   LOOP
      FETCH L_JOB_CURSOR
       INTO JOB;
      EXIT WHEN L_JOB_CURSOR%NOTFOUND;
      DBMS_JOB.REMOVE( JOB );
      COMMIT;
   END LOOP;
   CLOSE L_JOB_CURSOR;
   --***********************************************************************
   DBMS_OUTPUT.PUT_LINE( '- iapiSpecificationStatus.AutoStatus.' );
   OPEN L_JOB_CURSOR( '%Autostatus%' );
   LOOP
      FETCH L_JOB_CURSOR
       INTO JOB;
      EXIT WHEN L_JOB_CURSOR%NOTFOUND;
      DBMS_JOB.REMOVE( JOB );
      COMMIT;
   END LOOP;
   CLOSE L_JOB_CURSOR;
   --***********************************************************************
   --Deze zetten we standaard uit, omdat deze remove-JOB conflicteert met
   --de STARTALLJOBS-procedures:  pa_limsinterface.p_transfercfgandspc;
   --                             pa_limsspc.f_transferallhistobs;
   --door de substring "transfer" die in naamgeving voorkomt...
   --
   --DBMS_OUTPUT.PUT_LINE( '- PA_TRANSFER.P_TRANSFER_SCHEDULE.' );
   --OPEN L_JOB_CURSOR( '%TRANSFER%' );
   --LOOP
   --   FETCH L_JOB_CURSOR
   --   INTO JOB;
   --   EXIT WHEN L_JOB_CURSOR%NOTFOUND;
   --   DBMS_JOB.REMOVE( JOB );
   --   COMMIT;
   --END LOOP;
   --CLOSE L_JOB_CURSOR;
   --***********************************************************************
   DBMS_OUTPUT.PUT_LINE( '- sp_approve_blocked_spec.' );
   OPEN L_JOB_CURSOR( '%approve%' );
   LOOP
      FETCH L_JOB_CURSOR
       INTO JOB;
      EXIT WHEN L_JOB_CURSOR%NOTFOUND;
      DBMS_JOB.REMOVE( JOB );
      COMMIT;
   END LOOP;
   CLOSE L_JOB_CURSOR;
   --***********************************************************************
   DBMS_OUTPUT.PUT_LINE( '- iapiCheckProcessing.CheckProcessing.' );
   OPEN L_JOB_CURSOR( '%iapiCheckProcessing%' );
   LOOP
      FETCH L_JOB_CURSOR
       INTO JOB;
      EXIT WHEN L_JOB_CURSOR%NOTFOUND;
      DBMS_JOB.REMOVE( JOB );
      COMMIT;
   END LOOP;
   CLOSE L_JOB_CURSOR;
   --
END DBA_REMOVE_SET_JOBS;
/

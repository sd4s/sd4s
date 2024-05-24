PACKAGE BODY unapieqm AS

L_SQLERRM         VARCHAR2(255);
L_SQL_STRING      VARCHAR2(2000);
L_WHERE_CLAUSE    VARCHAR2(1000);
L_EVENT_TP        UTEV.EV_TP%TYPE;
L_EV_DETAILS      VARCHAR2(255);
L_RET_CODE        NUMBER;
L_RESULT          NUMBER;
L_FETCHED_ROWS    NUMBER;
L_EV_SEQ_NR       NUMBER;
L_ERRM            VARCHAR2(255);

STPERROR          EXCEPTION;

CURSOR C_SYSTEM (A_SETTING_NAME VARCHAR2) IS
   SELECT SETTING_VALUE
   FROM UTSYSTEM
   WHERE SETTING_NAME = A_SETTING_NAME;

FUNCTION GETVERSION
   RETURN VARCHAR2
IS
BEGIN
   RETURN('06.07.00.00_00.13');
EXCEPTION
   WHEN OTHERS THEN
      RETURN (NULL);
END GETVERSION;




FUNCTION MANEUVEREQMANAGER             
(A_ACTION   IN  VARCHAR2,              
 A_RUNNING  OUT CHAR)                  
RETURN NUMBER IS         

L_JOB            VARCHAR2(30); 
L_JOB_STRING     VARCHAR2(100);
L_ENABLED         VARCHAR2(5);
L_ACTION         VARCHAR2(4000);
L_INTERVAL       VARCHAR2(40);
L_SETTING_VALUE  VARCHAR2(40);
L_FOUND          BOOLEAN;
L_LEAVE_LOOP     BOOLEAN;
L_ATTEMPTS       INTEGER;
L_ISDBAUSER      INTEGER;

CURSOR L_JOBS_CURSOR (A_SEARCH VARCHAR2) IS
   SELECT JOB_NAME, ENABLED, JOB_ACTION
   FROM SYS.DBA_SCHEDULER_JOBS 
   WHERE INSTR(UPPER(JOB_ACTION), A_SEARCH)<>0;

BEGIN


   
   L_RET_CODE := UNAPIEV.CREATEDEFAULTSERVICELAYER;
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
       L_ERRM := 'createDefaultServiceLayer failed ' || TO_CHAR(L_RET_CODE);
       RAISE STPERROR;
  END IF;

   L_JOB_STRING := 'BEGIN UNAPIEQM.EQUIPMENTMANAGERJOB; END;';
   
   
   
   
   
   
   OPEN L_JOBS_CURSOR(L_JOB_STRING);
   FETCH L_JOBS_CURSOR INTO L_JOB,L_ENABLED,L_ACTION ;
   L_FOUND := L_JOBS_CURSOR%FOUND;
   CLOSE L_JOBS_CURSOR;

   L_ISDBAUSER := UNAPIGEN.ISEXTERNALDBAUSER;

   IF L_FOUND THEN
      
      
      IF A_ACTION IN ('START', 'STOP') OR
         UPPER(L_ENABLED) = 'FALSE' THEN
         IF (UNAPIGEN.ISUSERAUTHORISED(UNAPIGEN.P_CURRENT_UP, UNAPIGEN.P_USER, 'database', 'startstopjobs') <> UNAPIGEN.DBERR_SUCCESS) AND
            L_ISDBAUSER <> UNAPIGEN.DBERR_SUCCESS THEN
            RETURN(UNAPIGEN.DBERR_EVMGRSTARTNOTAUTHORISED);
         END IF;
      END IF;
      
      IF A_ACTION = 'STOP' THEN
         
         
         
         DBMS_SCHEDULER.DROP_JOB(L_JOB);
         
      ELSIF UPPER(L_ENABLED) = 'FALSE' THEN
         
         
         
         DBMS_SCHEDULER.ENABLE(L_JOB); 
      END IF;
   ELSE 
      IF A_ACTION = 'START' THEN
         
         
         IF (UNAPIGEN.ISUSERAUTHORISED(UNAPIGEN.P_CURRENT_UP, UNAPIGEN.P_USER, 'database', 'startstopjobs') <> UNAPIGEN.DBERR_SUCCESS) AND
            L_ISDBAUSER <> UNAPIGEN.DBERR_SUCCESS THEN
            RETURN(UNAPIGEN.DBERR_EVMGRSTARTNOTAUTHORISED);
         END IF;
         
         OPEN C_SYSTEM ('EQCA_POLLINGINTERVAL');
         FETCH C_SYSTEM INTO L_SETTING_VALUE;
         IF C_SYSTEM%NOTFOUND THEN
            L_SETTING_VALUE := '0';
         END IF;
         CLOSE C_SYSTEM;

         L_INTERVAL := NVL(L_SETTING_VALUE, '0');

         IF L_INTERVAL <> '0' THEN
            
            
            
             L_JOB := DBMS_SCHEDULER.GENERATE_JOB_NAME ('UNI_J_EQUIPMGRJOB');
        DBMS_SCHEDULER.CREATE_JOB
           ( 
                  JOB_NAME          =>  '"' ||UNAPIGEN.P_DBA_NAME||'".'||L_JOB,
              JOB_CLASS            => 'UNI_JC_OTHER_JOBS',
        JOB_TYPE             => 'PLSQL_BLOCK',
        JOB_ACTION           => L_JOB_STRING,
        START_DATE           => CURRENT_TIMESTAMP+ ((1/24)/60),
        
        
        REPEAT_INTERVAL      =>  UNAPIEV.SQLTRANSLATEDJOBINTERVAL(L_INTERVAL, 'minutes'),
        ENABLED              => TRUE
      );
      DBMS_SCHEDULER.SET_ATTRIBUTE (
                    NAME           => L_JOB,
                    ATTRIBUTE      => 'restartable',
                    VALUE          => TRUE);
          END IF;
      END IF;
   END IF;

   UNAPIGEN.U4COMMIT;

   
   
   
   
      
   IF A_ACTION = 'CHECK' THEN
      IF L_FOUND AND UPPER(L_ENABLED) = 'TRUE' THEN
         A_RUNNING := '1';
      ELSE
         A_RUNNING := '0';
      END IF;
   ELSE
      IF L_INTERVAL = '0' AND A_ACTION = 'START' THEN
         A_RUNNING := '0';
      ELSE
         L_LEAVE_LOOP := FALSE;
         L_ATTEMPTS := 0;
         WHILE NOT L_LEAVE_LOOP LOOP
            L_ATTEMPTS := L_ATTEMPTS + 1;
            OPEN L_JOBS_CURSOR(L_JOB_STRING);
            FETCH L_JOBS_CURSOR INTO L_JOB,L_ENABLED,L_ACTION ;
            L_FOUND := L_JOBS_CURSOR%FOUND;
            CLOSE L_JOBS_CURSOR;
            IF A_ACTION = 'START' THEN
               IF L_FOUND THEN
                  A_RUNNING := '1';
                  L_LEAVE_LOOP := TRUE;
               ELSE
                  IF L_ATTEMPTS >= 30 THEN
                     A_RUNNING := '0';
                     L_SQLERRM := 'Equipment Manager not started ! (timeout after 60 seconds)';
                     RAISE STPERROR;
                  ELSE
                     DBMS_LOCK.SLEEP(2);
                  END IF;
               END IF;
            ELSE
               IF NOT L_FOUND THEN 
                  A_RUNNING := '0';
                  L_LEAVE_LOOP := TRUE;
               ELSE
                  IF L_ATTEMPTS >= 30 THEN
                     A_RUNNING := '1';
                     L_SQLERRM := 'Equipment Manager not stopped ! (timeout after 60 seconds)';
                     RAISE STPERROR;
                  ELSE
                     DBMS_LOCK.SLEEP(2);
                  END IF;
               END IF;
            END IF;
         END LOOP;
      END IF;
   END IF;
   RETURN(UNAPIGEN.DBERR_SUCCESS);
   
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      L_SQLERRM := SQLERRM;
   END IF;
   INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                     'ManeuverEqManager' , L_SQLERRM );
   UNAPIGEN.U4COMMIT;
   IF L_JOBS_CURSOR%ISOPEN THEN
      CLOSE L_JOBS_CURSOR;
   END IF;
   IF C_SYSTEM%ISOPEN THEN
      CLOSE C_SYSTEM;
   END IF;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END MANEUVEREQMANAGER;

FUNCTION EVALEQINTERVENTIONRULE                 
(A_EQ                      IN      VARCHAR2,    
 A_LAB                     IN      VARCHAR2,    
 A_CA                      IN      VARCHAR2,    
 A_FREQ_TP                 IN      CHAR,        
 A_FREQ_VAL                IN      NUMBER,      
 A_FREQ_UNIT               IN      VARCHAR2,                 
 A_WARNING_UPFRONT         IN      CHAR,        
 A_GRACE_VAL               IN      NUMBER,      
 A_GRACE_UNIT              IN      VARCHAR2,    
 A_SUSPEND                 IN      CHAR,        
 A_LAST_SCHED              IN OUT  DATE,        
 A_LAST_VAL                IN OUT  VARCHAR2,    
 A_LAST_COUNT              IN OUT  NUMBER,      
 A_OLD_CA_WARN_LEVEL       IN      CHAR,        
 A_NEW_CA_WARN_LEVEL       OUT     CHAR,        
 A_INTERVENTION            OUT     CHAR)        
RETURN NUMBER IS

A_VERSION             VARCHAR2(20);
L_DYN_CURSOR          INTEGER;
L_FREQ_VAL            NUMBER;
L_LAST_CNT            NUMBER(5);
L_LAST_VAL            VARCHAR2(40);
L_LAST_SCHED          TIMESTAMP WITH TIME ZONE;
L_NEXT_SCHED          TIMESTAMP WITH TIME ZONE;
L_CURRENT_TIMESTAMP             TIMESTAMP WITH TIME ZONE;
L_REF_DATE            TIMESTAMP WITH TIME ZONE;
L_NEW_CA_WARN_LEVEL   VARCHAR2(1);
L_OUT_OF_GRACE_DATE   TIMESTAMP WITH TIME ZONE;
L_IN_WARNING_DATE     TIMESTAMP WITH TIME ZONE;
L_INTERVENTION        BOOLEAN;

BEGIN
   
   
   A_VERSION := UNVERSION.P_NO_VERSION;
   IF A_VERSION IS NULL THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
      RAISE STPERROR;
   END IF;
   

   
   L_SQLERRM := '';
   A_NEW_CA_WARN_LEVEL := A_OLD_CA_WARN_LEVEL;
   A_INTERVENTION := '0';
   
   IF A_FREQ_TP = 'C' THEN
      
      
      
      L_REF_DATE := CURRENT_TIMESTAMP;
      L_LAST_SCHED := A_LAST_SCHED;
      L_LAST_CNT := A_LAST_COUNT;
      L_LAST_VAL := A_LAST_VAL;
      L_NEW_CA_WARN_LEVEL := A_OLD_CA_WARN_LEVEL;
      
      L_SQL_STRING := 'BEGIN :l_ret_code := UNFREQ.'|| A_FREQ_UNIT ||
          '(:a_eq, :a_lab, :a_version, :a_ca, :a_freq_val, :a_invert_freq, :a_ref_date, ' ||
          ':a_last_sched, :a_last_cnt, :a_last_val, :a_old_ca_warn_level, ' ||
          ':a_grace_val, :a_grace_unit, :a_suspend, :a_new_ca_warn_level); END;';

      L_DYN_CURSOR := DBMS_SQL.OPEN_CURSOR;

      DBMS_SQL.PARSE(L_DYN_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
      DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':l_ret_code', L_RET_CODE);
      DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_eq', A_EQ, 20);
      DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_lab', A_LAB, 20);
      DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_version', A_VERSION, 20);
      DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_ca', A_CA, 20);
      DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_freq_val', A_FREQ_VAL);
      DBMS_SQL.BIND_VARIABLE_CHAR(L_DYN_CURSOR, ':a_invert_freq', A_WARNING_UPFRONT, 1);
      DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_ref_date', L_REF_DATE);
      DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_old_ca_warn_level', A_OLD_CA_WARN_LEVEL, 1);
      DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_grace_val', A_GRACE_VAL);
      DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_grace_unit', A_GRACE_UNIT, 20);
      DBMS_SQL.BIND_VARIABLE_CHAR(L_DYN_CURSOR, ':a_suspend', A_SUSPEND, 1);
      DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_last_sched', L_LAST_SCHED);
      DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_last_cnt', L_LAST_CNT);
      DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_last_val', L_LAST_VAL, 40);
      DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_new_ca_warn_level', L_NEW_CA_WARN_LEVEL, 1);

      L_RESULT := DBMS_SQL.EXECUTE(L_DYN_CURSOR);
      DBMS_SQL.VARIABLE_VALUE(L_DYN_CURSOR, ':l_ret_code', L_RET_CODE);
      DBMS_SQL.VARIABLE_VALUE(L_DYN_CURSOR, ':a_last_sched', L_LAST_SCHED);
      DBMS_SQL.VARIABLE_VALUE(L_DYN_CURSOR, ':a_last_cnt', L_LAST_CNT);
      DBMS_SQL.VARIABLE_VALUE(L_DYN_CURSOR, ':a_last_val', L_LAST_VAL);
      DBMS_SQL.VARIABLE_VALUE(L_DYN_CURSOR, ':a_new_ca_warn_level', L_NEW_CA_WARN_LEVEL);

      A_LAST_SCHED := L_LAST_SCHED;
      A_LAST_COUNT := L_LAST_CNT;
      A_LAST_VAL := L_LAST_VAL;
      A_NEW_CA_WARN_LEVEL := L_NEW_CA_WARN_LEVEL;
      
      DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);

      IF L_RET_CODE = UNAPIGEN.DBERR_SUCCESS THEN
         A_INTERVENTION := '1';
      END IF;   
            
   ELSIF A_FREQ_TP='S' THEN 
         
      A_LAST_COUNT := A_LAST_COUNT+1;         
      IF A_OLD_CA_WARN_LEVEL NOT IN ('3', '4') THEN
         IF A_OLD_CA_WARN_LEVEL = '2' THEN
            
            IF A_LAST_COUNT >= A_GRACE_VAL THEN
               A_NEW_CA_WARN_LEVEL := '3';
            END IF;
         ELSE 
            IF A_LAST_COUNT >= A_FREQ_VAL THEN
               A_INTERVENTION := '1';
               A_LAST_COUNT := 0;
               A_LAST_SCHED := CURRENT_TIMESTAMP;

               IF A_SUSPEND = '0' THEN
                  A_NEW_CA_WARN_LEVEL := '3';
               ELSE
                  IF A_LAST_COUNT >= A_GRACE_VAL THEN
                     A_NEW_CA_WARN_LEVEL := '3';
                  ELSE
                     A_NEW_CA_WARN_LEVEL := '2';
                  END IF;
               END IF;
            ELSIF A_WARNING_UPFRONT = '1' AND
                  A_LAST_COUNT >= A_FREQ_VAL-A_GRACE_VAL THEN
               A_NEW_CA_WARN_LEVEL := '1';
            END IF;
         END IF;
      END IF;   
   ELSIF A_FREQ_TP='T' THEN 

      A_LAST_COUNT := A_LAST_COUNT+1;
      L_CURRENT_TIMESTAMP := CURRENT_TIMESTAMP;

      IF A_OLD_CA_WARN_LEVEL NOT IN ('3', '4') THEN

         IF A_OLD_CA_WARN_LEVEL = '2' THEN
            
            
            L_RET_CODE := UNAPIAUT.CALCULATEDELAY(A_GRACE_VAL, A_GRACE_UNIT, A_LAST_SCHED, L_OUT_OF_GRACE_DATE);
            IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
               L_SQLERRM := 'CalculateDelay returned '||TO_CHAR(L_RET_CODE)||'#freq_val='||TO_CHAR(A_GRACE_VAL)||
                            '#freq_unit='||A_GRACE_UNIT||'#ref_date='||TO_CHAR(A_LAST_SCHED);
               RAISE STPERROR;
            END IF;
            
            IF L_CURRENT_TIMESTAMP >= L_OUT_OF_GRACE_DATE THEN
               A_NEW_CA_WARN_LEVEL := '3';
            END IF;
         ELSE 
            
            
            L_NEXT_SCHED := A_LAST_SCHED;
            L_INTERVENTION := UNAPIAUT.EVALASSIGNMENTFREQ('', '','', '', '','', 'T', A_FREQ_VAL, A_FREQ_UNIT, '0',
                                                    L_CURRENT_TIMESTAMP, L_NEXT_SCHED, A_LAST_COUNT, A_LAST_VAL);

            IF L_INTERVENTION THEN
               A_INTERVENTION := '1';
               A_LAST_COUNT := 0;
               A_LAST_SCHED := L_NEXT_SCHED;                   
            ELSE
               
               L_RET_CODE := UNAPIAUT.CALCULATEDELAY(A_FREQ_VAL, A_FREQ_UNIT, A_LAST_SCHED, L_NEXT_SCHED);
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'CalculateDelay returned '||TO_CHAR(L_RET_CODE)||'#freq_val='||TO_CHAR(A_FREQ_VAL)||
                               '#freq_unit='||A_FREQ_UNIT||'#ref_date='||TO_CHAR(A_LAST_SCHED);
                  RAISE STPERROR;
               END IF;            
            END IF;
            
            IF L_CURRENT_TIMESTAMP >= L_NEXT_SCHED THEN
               
               L_RET_CODE := UNAPIAUT.CALCULATEDELAY(A_GRACE_VAL, A_GRACE_UNIT, L_NEXT_SCHED, L_OUT_OF_GRACE_DATE);
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'CalculateDelay returned '||TO_CHAR(L_RET_CODE)||'#freq_val='||TO_CHAR(A_GRACE_VAL)||
                               '#freq_unit='||A_GRACE_UNIT||'#ref_date='||TO_CHAR(L_NEXT_SCHED);
                  RAISE STPERROR;
               END IF;

        
               IF A_SUSPEND = '0' THEN
                  A_NEW_CA_WARN_LEVEL := '3';
               ELSE
                  IF L_CURRENT_TIMESTAMP >= L_OUT_OF_GRACE_DATE THEN
                     A_NEW_CA_WARN_LEVEL := '3';
                  ELSE
                     A_NEW_CA_WARN_LEVEL := '2';
                  END IF;
               END IF;
            ELSIF A_WARNING_UPFRONT = '1' THEN
            
               
               L_RET_CODE := UNAPIAUT.CALCULATEDELAY(-A_GRACE_VAL, A_GRACE_UNIT, L_NEXT_SCHED, L_IN_WARNING_DATE);
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'CalculateDelay returned '||TO_CHAR(L_RET_CODE)||'#freq_val='||TO_CHAR(-A_FREQ_VAL)||
                               '#grace_unit='||A_FREQ_UNIT||'#ref_date='||TO_CHAR(L_NEXT_SCHED);
                  RAISE STPERROR;
               END IF;

               IF L_CURRENT_TIMESTAMP >= L_IN_WARNING_DATE THEN
                  A_NEW_CA_WARN_LEVEL := '1';
               END IF;
            END IF;
         END IF;
      END IF;
   END IF;
   RETURN (UNAPIGEN.DBERR_SUCCESS);
   
EXCEPTION
WHEN OTHERS THEN
   UNAPIGEN.U4ROLLBACK;
   IF SQLCODE<>1 THEN
      L_SQLERRM := SQLERRM;
      INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
      VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
              'EvalEqInterventionRule', L_SQLERRM);
   ELSIF L_SQLERRM IS NOT NULL THEN
      INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
      VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
              'EvalEqInterventionRule', L_SQLERRM);
   END IF;      
   UNAPIGEN.U4COMMIT;
   IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
      DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
   END IF;   
   RETURN (UNAPIGEN.DBERR_GENFAIL);
END EVALEQINTERVENTIONRULE;

PROCEDURE CREATEEQINTREVENTIONSCORME             
(A_EQ                      IN      VARCHAR2,     
 A_LAB                     IN      VARCHAR2,     
 A_CA                      IN      VARCHAR2,     
 A_ST                      IN      VARCHAR2,     
 A_MT                      IN      VARCHAR2,     
 A_CA_SC                   OUT     VARCHAR2,     
 A_CA_PG                   OUT     VARCHAR2,     
 A_CA_PGNODE               OUT     NUMBER,       
 A_CA_PA                   OUT     VARCHAR2,     
 A_CA_PANODE               OUT     NUMBER,       
 A_CA_ME                   OUT     VARCHAR2,     
 A_CA_MENODE               OUT     NUMBER,       
 A_MODIFY_REASON           IN      VARCHAR2)     
IS

A_VERSION                        VARCHAR2(20);
A_ST_VERSION                     VARCHAR2(20);
A_MT_VERSION                     VARCHAR2(20);
L_ROW                            INTEGER;
L_PA_SEQ                         NUMBER;
L_PA_NR_OF_ROWS                  NUMBER;
L_PA_SC_TAB                      UNAPIGEN.VC20_TABLE_TYPE;
L_PA_PG_TAB                      UNAPIGEN.VC20_TABLE_TYPE;
L_PA_PGNODE_TAB                  UNAPIGEN.LONG_TABLE_TYPE;
L_PA_PA_TAB                      UNAPIGEN.VC20_TABLE_TYPE;
L_PA_PANODE_TAB                  UNAPIGEN.LONG_TABLE_TYPE;
L_PA_PR_VERSION_TAB              UNAPIGEN.VC20_TABLE_TYPE;
L_PA_DESCRIPTION_TAB             UNAPIGEN.VC40_TABLE_TYPE;
L_PA_VALUE_F_TAB                 UNAPIGEN.FLOAT_TABLE_TYPE;
L_PA_VALUE_S_TAB                 UNAPIGEN.VC40_TABLE_TYPE;
L_PA_UNIT_TAB                    UNAPIGEN.VC20_TABLE_TYPE;
L_PA_EXEC_START_DATE_TAB         UNAPIGEN.DATE_TABLE_TYPE;
L_PA_EXEC_END_DATE_TAB           UNAPIGEN.DATE_TABLE_TYPE;
L_PA_EXECUTOR_TAB                UNAPIGEN.VC20_TABLE_TYPE;
L_PA_PLANNED_EXECUTOR_TAB        UNAPIGEN.VC20_TABLE_TYPE;
L_PA_MANUALLY_ENTERED_TAB        UNAPIGEN.CHAR1_TABLE_TYPE;
L_PA_ASSIGN_DATE_TAB             UNAPIGEN.DATE_TABLE_TYPE;
L_PA_ASSIGNED_BY_TAB             UNAPIGEN.VC20_TABLE_TYPE;
L_PA_MANUALLY_ADDED_TAB          UNAPIGEN.CHAR1_TABLE_TYPE;
L_PA_FORMAT_TAB                  UNAPIGEN.VC40_TABLE_TYPE;
L_PA_TD_INFO_TAB                 UNAPIGEN.NUM_TABLE_TYPE;
L_PA_TD_INFO_UNIT_TAB            UNAPIGEN.VC20_TABLE_TYPE;
L_PA_CONFIRM_UID_TAB             UNAPIGEN.CHAR1_TABLE_TYPE;
L_PA_ALLOW_ANY_ME_TAB            UNAPIGEN.CHAR1_TABLE_TYPE;
L_PA_DELAY_TAB                   UNAPIGEN.NUM_TABLE_TYPE;
L_PA_DELAY_UNIT_TAB              UNAPIGEN.VC20_TABLE_TYPE;
L_PA_MIN_NR_RESULTS_TAB          UNAPIGEN.NUM_TABLE_TYPE;
L_PA_CALC_METHOD_TAB             UNAPIGEN.CHAR1_TABLE_TYPE;
L_PA_CALC_CF_TAB                 UNAPIGEN.VC20_TABLE_TYPE;
L_PA_ALARM_ORDER_TAB             UNAPIGEN.VC3_TABLE_TYPE;
L_PA_VALID_SPECSA_TAB            UNAPIGEN.CHAR1_TABLE_TYPE;
L_PA_VALID_SPECSB_TAB            UNAPIGEN.CHAR1_TABLE_TYPE;
L_PA_VALID_SPECSC_TAB            UNAPIGEN.CHAR1_TABLE_TYPE;
L_PA_VALID_LIMITSA_TAB           UNAPIGEN.CHAR1_TABLE_TYPE;
L_PA_VALID_LIMITSB_TAB           UNAPIGEN.CHAR1_TABLE_TYPE;
L_PA_VALID_LIMITSC_TAB           UNAPIGEN.CHAR1_TABLE_TYPE;
L_PA_VALID_TARGETA_TAB           UNAPIGEN.CHAR1_TABLE_TYPE;
L_PA_VALID_TARGETB_TAB           UNAPIGEN.CHAR1_TABLE_TYPE;
L_PA_VALID_TARGETC_TAB           UNAPIGEN.CHAR1_TABLE_TYPE;
L_PA_MT_TAB                      UNAPIGEN.VC20_TABLE_TYPE;
L_PA_MT_VERSION_TAB              UNAPIGEN.VC20_TABLE_TYPE;
L_PA_MT_NR_MEASUR_TAB            UNAPIGEN.NUM_TABLE_TYPE;
L_PA_LOG_EXCEPTIONS_TAB          UNAPIGEN.CHAR1_TABLE_TYPE;
L_PA_REANALYSIS_TAB              UNAPIGEN.NUM_TABLE_TYPE;
L_PA_PA_CLASS_TAB                UNAPIGEN.VC2_TABLE_TYPE;
L_PA_LOG_HS_TAB                  UNAPIGEN.CHAR1_TABLE_TYPE;
L_PA_LOG_HS_DETAILS_TAB          UNAPIGEN.CHAR1_TABLE_TYPE;
L_PA_LC_TAB                      UNAPIGEN.VC2_TABLE_TYPE;
L_PA_LC_VERSION_TAB              UNAPIGEN.VC20_TABLE_TYPE;
L_PA_MODIFY_FLAG_TAB             UNAPIGEN.NUM_TABLE_TYPE;

L_ME_SEQ                         NUMBER;            
L_ME_NR_OF_ROWS                  NUMBER;
L_ME_MT_NR_MEASUR                NUMBER;
L_ME_SC_TAB                      UNAPIGEN.VC20_TABLE_TYPE;
L_ME_PG_TAB                      UNAPIGEN.VC20_TABLE_TYPE;
L_ME_PGNODE_TAB                  UNAPIGEN.LONG_TABLE_TYPE;
L_ME_PA_TAB                      UNAPIGEN.VC20_TABLE_TYPE;
L_ME_PANODE_TAB                  UNAPIGEN.LONG_TABLE_TYPE;
L_ME_ME_TAB                      UNAPIGEN.VC20_TABLE_TYPE;
L_ME_MENODE_TAB                  UNAPIGEN.LONG_TABLE_TYPE;
L_ME_MT_VERSION_TAB              UNAPIGEN.VC20_TABLE_TYPE;
L_ME_DESCRIPTION_TAB             UNAPIGEN.VC40_TABLE_TYPE;
L_ME_VALUE_F_TAB                 UNAPIGEN.FLOAT_TABLE_TYPE;
L_ME_VALUE_S_TAB                 UNAPIGEN.VC40_TABLE_TYPE;
L_ME_UNIT_TAB                    UNAPIGEN.VC20_TABLE_TYPE;
L_ME_EXEC_START_DATE_TAB         UNAPIGEN.DATE_TABLE_TYPE;
L_ME_EXEC_END_DATE_TAB           UNAPIGEN.DATE_TABLE_TYPE;
L_ME_EXECUTOR_TAB                UNAPIGEN.VC20_TABLE_TYPE;
L_ME_LAB_TAB                     UNAPIGEN.VC20_TABLE_TYPE;
L_ME_EQ_TAB                      UNAPIGEN.VC20_TABLE_TYPE;
L_ME_EQ_VERSION_TAB              UNAPIGEN.VC20_TABLE_TYPE;
L_ME_PLANNED_EXECUTOR_TAB        UNAPIGEN.VC20_TABLE_TYPE;
L_ME_PLANNED_EQ_TAB              UNAPIGEN.VC20_TABLE_TYPE;
L_ME_PLANNED_EQ_VERSION_TAB      UNAPIGEN.VC20_TABLE_TYPE;
L_ME_MANUALLY_ENTERED_TAB        UNAPIGEN.CHAR1_TABLE_TYPE;
L_ME_ALLOW_ADD_TAB               UNAPIGEN.CHAR1_TABLE_TYPE;
L_ME_ASSIGN_DATE_TAB             UNAPIGEN.DATE_TABLE_TYPE;
L_ME_ASSIGNED_BY_TAB             UNAPIGEN.VC20_TABLE_TYPE;
L_ME_MANUALLY_ADDED_TAB          UNAPIGEN.CHAR1_TABLE_TYPE;
L_ME_DELAY_TAB                   UNAPIGEN.NUM_TABLE_TYPE;
L_ME_DELAY_UNIT_TAB              UNAPIGEN.VC20_TABLE_TYPE;
L_ME_FORMAT_TAB                  UNAPIGEN.VC40_TABLE_TYPE;
L_ME_ACCURACY_TAB                UNAPIGEN.FLOAT_TABLE_TYPE;
L_ME_REAL_COST_TAB               UNAPIGEN.VC40_TABLE_TYPE;
L_ME_REAL_TIME_TAB               UNAPIGEN.VC40_TABLE_TYPE;
L_ME_CALIBRATION_TAB             UNAPIGEN.CHAR1_TABLE_TYPE;
L_ME_CONFIRM_COMPLETE_TAB        UNAPIGEN.CHAR1_TABLE_TYPE;
L_ME_AUTORECALC_TAB              UNAPIGEN.CHAR1_TABLE_TYPE;
L_ME_ME_RESULT_EDITABLE_TAB      UNAPIGEN.CHAR1_TABLE_TYPE;
L_ME_NEXT_CELL_TAB               UNAPIGEN.VC20_TABLE_TYPE;
L_ME_SOP_TAB                     UNAPIGEN.VC40_TABLE_TYPE;
L_ME_SOP_VERSION_TAB             UNAPIGEN.VC20_TABLE_TYPE;
L_ME_PLAUS_LOW_TAB               UNAPIGEN.FLOAT_TABLE_TYPE;
L_ME_PLAUS_HIGH_TAB              UNAPIGEN.FLOAT_TABLE_TYPE;
L_ME_WINSIZE_X_TAB               UNAPIGEN.NUM_TABLE_TYPE;
L_ME_WINSIZE_Y_TAB               UNAPIGEN.NUM_TABLE_TYPE;
L_ME_REANALYSIS_TAB              UNAPIGEN.NUM_TABLE_TYPE;
L_ME_ME_CLASS_TAB                UNAPIGEN.VC2_TABLE_TYPE;
L_ME_LOG_HS_TAB                  UNAPIGEN.CHAR1_TABLE_TYPE;
L_ME_LOG_HS_DETAILS_TAB          UNAPIGEN.CHAR1_TABLE_TYPE;
L_ME_LC_TAB                      UNAPIGEN.VC2_TABLE_TYPE;
L_ME_LC_VERSION_TAB              UNAPIGEN.VC20_TABLE_TYPE;
L_ME_MODIFY_FLAG_TAB             UNAPIGEN.NUM_TABLE_TYPE;

L_CA_SC                          VARCHAR2(20);
L_CA_PG                          VARCHAR2(20);
L_CA_PGNODE                      NUMBER(9);
L_CA_PP_VERSION                  VARCHAR2(20);
L_CA_PA                          VARCHAR2(20);
L_CA_PANODE                      NUMBER(9);
L_CA_PR_VERSION_IN               VARCHAR2(20);
L_CA_ME                          VARCHAR2(20);
L_CA_MENODE                      NUMBER(9);
L_CA_MT_VERSION_IN               VARCHAR2(20);

L_FIELDTYPE_TAB                  UNAPIGEN.VC20_TABLE_TYPE;
L_FIELDNAMES_TAB                 UNAPIGEN.VC20_TABLE_TYPE;
L_FIELDVALUES_TAB                UNAPIGEN.VC40_TABLE_TYPE;
L_FIELDNR_OF_ROWS                NUMBER;

L_CREATE_SCME     BOOLEAN;
CURSOR L_SCME_CURSOR(A_SC VARCHAR2, A_ME VARCHAR2, A_MT_VERSION VARCHAR2) IS
   SELECT SC, PG, PGNODE, PA, PANODE, ME, MENODE
   FROM UTSCME
   WHERE SC = A_SC
     AND ME = A_ME
     AND MT_VERSION = A_MT_VERSION;

BEGIN

   
   A_VERSION := UNVERSION.P_NO_VERSION;
   IF A_VERSION IS NULL THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
      RAISE STPERROR;
   END IF;

   IF A_ST IS NOT NULL THEN
      BEGIN
         SELECT VERSION
         INTO A_ST_VERSION
         FROM UTST
         WHERE ST = A_ST
         AND VERSION_IS_CURRENT = '1';
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOCURRENTSTVERSION;
         RAISE STPERROR;
      END;
   END IF;

   IF A_MT IS NOT NULL THEN
      BEGIN
         SELECT VERSION
         INTO A_MT_VERSION
         FROM UTMT
         WHERE MT = A_MT
         AND VERSION_IS_CURRENT = '1';
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOCURRENTMTVERSION;
         RAISE STPERROR;
      END;
   END IF;
   

   L_CA_SC := NULL;
   L_CA_PG := NULL;
   L_CA_PGNODE := NULL;
   L_CA_PA := NULL;
   L_CA_PANODE := NULL;
   L_CA_ME := NULL;
   L_CA_MENODE := NULL;

   
   
   
   
   
   UNAPIGEN.P_LAB := A_LAB; 
   
   IF A_ST IS NULL AND A_MT IS NULL THEN
      
      NULL;
   ELSE
      L_FIELDNR_OF_ROWS := 0;
      L_RET_CODE := UNAPISC.CREATESAMPLE(A_ST, A_ST_VERSION, L_CA_SC, CURRENT_TIMESTAMP, 
                                         'ON SAMPLE CREATION', 'ON SAMPLE CREATION', 
                                         UNAPIGEN.P_USER, 
                                         L_FIELDTYPE_TAB, L_FIELDNAMES_TAB, L_FIELDVALUES_TAB, L_FIELDNR_OF_ROWS,
                                         A_MODIFY_REASON);
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         L_SQLERRM := 'CreateSample returned '||TO_CHAR(L_RET_CODE)||' st='||A_ST||
                      '#st_version='||A_ST_VERSION||'#l_ca_sc='||L_CA_SC||
                      '#ref_date='||TO_CHAR(CURRENT_TIMESTAMP)||'#create_ic=ON SAMPLE CREATION'||
                      '#create_pg=ON SAMPLE CREATION'||
                      '#user='||UNAPIGEN.P_USER;
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
         RAISE STPERROR;
      END IF;
   END IF;
   
   L_CREATE_SCME := FALSE;
   IF A_ST IS NOT NULL THEN
      IF A_MT IS NOT NULL THEN
         
         OPEN L_SCME_CURSOR(L_CA_SC, A_MT, A_MT_VERSION);
         FETCH L_SCME_CURSOR
         INTO L_CA_SC, L_CA_PG, L_CA_PGNODE, L_CA_PA, L_CA_PANODE, L_CA_ME, L_CA_MENODE;
         CLOSE L_SCME_CURSOR;
         IF L_CA_ME IS NULL THEN
            L_CREATE_SCME := TRUE;
         END IF;     
      ELSE
         
         L_CREATE_SCME := FALSE;
      END IF;
   ELSE
      IF A_MT IS NOT NULL THEN
         L_CREATE_SCME := TRUE;
      ELSE
         L_CREATE_SCME := FALSE;
      END IF;
   END IF;
   
   IF L_CREATE_SCME THEN
      
      L_CA_PG := '/';
      L_CA_PGNODE := NULL;
      L_CA_PP_VERSION := UNVERSION.P_NO_VERSION;
      L_CA_PA := '/';
      L_CA_PANODE := NULL;
      L_CA_PR_VERSION_IN := UNVERSION.P_NO_VERSION;

      L_PA_SEQ := 1;
      L_PA_NR_OF_ROWS := NULL;
      
      L_RET_CODE := UNAPIPA.INITSCPARAMETER(L_CA_PA,
                        L_CA_PR_VERSION_IN,
                        L_PA_SEQ,
                        L_CA_SC,
                        L_CA_PG,
                        L_CA_PGNODE,
                        L_CA_PP_VERSION,
                        ' ', ' ', ' ', ' ', ' ',
                        L_PA_PR_VERSION_TAB,
                        L_PA_DESCRIPTION_TAB,
                        L_PA_VALUE_F_TAB,
                        L_PA_VALUE_S_TAB,
                        L_PA_UNIT_TAB,
                        L_PA_EXEC_START_DATE_TAB,
                        L_PA_EXEC_END_DATE_TAB,
                        L_PA_EXECUTOR_TAB,
                        L_PA_PLANNED_EXECUTOR_TAB,
                        L_PA_MANUALLY_ENTERED_TAB,
                        L_PA_ASSIGN_DATE_TAB,
                        L_PA_ASSIGNED_BY_TAB,
                        L_PA_MANUALLY_ADDED_TAB,
                        L_PA_FORMAT_TAB,
                        L_PA_TD_INFO_TAB,
                        L_PA_TD_INFO_UNIT_TAB,
                        L_PA_CONFIRM_UID_TAB,
                        L_PA_ALLOW_ANY_ME_TAB,
                        L_PA_DELAY_TAB,
                        L_PA_DELAY_UNIT_TAB,
                        L_PA_MIN_NR_RESULTS_TAB,
                        L_PA_CALC_METHOD_TAB,
                        L_PA_CALC_CF_TAB,
                        L_PA_ALARM_ORDER_TAB,
                        L_PA_VALID_SPECSA_TAB,
                        L_PA_VALID_SPECSB_TAB,
                        L_PA_VALID_SPECSC_TAB,
                        L_PA_VALID_LIMITSA_TAB,
                        L_PA_VALID_LIMITSB_TAB,
                        L_PA_VALID_LIMITSC_TAB,
                        L_PA_VALID_TARGETA_TAB,
                        L_PA_VALID_TARGETB_TAB,
                        L_PA_VALID_TARGETC_TAB,
                        L_PA_MT_TAB,
                        L_PA_MT_VERSION_TAB,
                        L_PA_MT_NR_MEASUR_TAB,
                        L_PA_LOG_EXCEPTIONS_TAB,
                        L_PA_REANALYSIS_TAB,
                        L_PA_PA_CLASS_TAB,
                        L_PA_LOG_HS_TAB,
                        L_PA_LOG_HS_DETAILS_TAB,
                        L_PA_LC_TAB,
                        L_PA_LC_VERSION_TAB,
                        L_PA_NR_OF_ROWS);

      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         L_SQLERRM := 'InitScParameter returned '||TO_CHAR(L_RET_CODE)||
                      ' pr=/#pr_version=/#seq='||TO_CHAR(L_PA_SEQ)||'#sc='||L_CA_SC||
                      '#pg='||L_CA_PG||'#pgnode='||TO_CHAR(L_CA_PGNODE)||
                      '#nr_of_rows='||TO_CHAR(L_PA_NR_OF_ROWS);
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
         RAISE STPERROR;
      END IF;

      FOR L_ROW IN 1..L_PA_NR_OF_ROWS LOOP
         L_PA_SC_TAB(L_ROW) := L_CA_SC;
         L_PA_PG_TAB(L_ROW) := L_CA_PG;
         L_PA_PGNODE_TAB(L_ROW) := L_CA_PGNODE;
         L_PA_PA_TAB(L_ROW) := L_CA_PA;
         L_PA_PANODE_TAB(L_ROW) := L_CA_PANODE;
         L_PA_MODIFY_FLAG_TAB(L_ROW) := UNAPIGEN.MOD_FLAG_INSERT;
      END LOOP;

      L_RET_CODE := UNAPIPA.SAVESCPARAMETER('0',
                        L_PA_SC_TAB,
                        L_PA_PG_TAB,
                        L_PA_PGNODE_TAB,
                        L_PA_PA_TAB,
                        L_PA_PANODE_TAB,
                        L_PA_PR_VERSION_TAB,
                        L_PA_DESCRIPTION_TAB,
                        L_PA_VALUE_F_TAB,
                        L_PA_VALUE_S_TAB,
                        L_PA_UNIT_TAB,
                        L_PA_EXEC_START_DATE_TAB,
                        L_PA_EXEC_END_DATE_TAB,
                        L_PA_EXECUTOR_TAB,
                        L_PA_PLANNED_EXECUTOR_TAB,
                        L_PA_MANUALLY_ENTERED_TAB,
                        L_PA_ASSIGN_DATE_TAB,
                        L_PA_ASSIGNED_BY_TAB,
                        L_PA_MANUALLY_ADDED_TAB,
                        L_PA_FORMAT_TAB,
                        L_PA_TD_INFO_TAB,
                        L_PA_TD_INFO_UNIT_TAB,
                        L_PA_CONFIRM_UID_TAB,
                        L_PA_ALLOW_ANY_ME_TAB,
                        L_PA_DELAY_TAB,
                        L_PA_DELAY_UNIT_TAB,
                        L_PA_MIN_NR_RESULTS_TAB,
                        L_PA_CALC_METHOD_TAB,
                        L_PA_CALC_CF_TAB,
                        L_PA_ALARM_ORDER_TAB,
                        L_PA_VALID_SPECSA_TAB,
                        L_PA_VALID_SPECSB_TAB,
                        L_PA_VALID_SPECSC_TAB,
                        L_PA_VALID_LIMITSA_TAB,
                        L_PA_VALID_LIMITSB_TAB,
                        L_PA_VALID_LIMITSC_TAB,
                        L_PA_VALID_TARGETA_TAB,
                        L_PA_VALID_TARGETB_TAB,
                        L_PA_VALID_TARGETC_TAB,
                        L_PA_MT_TAB,
                        L_PA_MT_VERSION_TAB,
                        L_PA_MT_NR_MEASUR_TAB,
                        L_PA_LOG_EXCEPTIONS_TAB,
                        L_PA_PA_CLASS_TAB,
                        L_PA_LOG_HS_TAB,
                        L_PA_LOG_HS_DETAILS_TAB,
                        L_PA_LC_TAB,
                        L_PA_LC_VERSION_TAB,
                        L_PA_MODIFY_FLAG_TAB,
                        L_PA_NR_OF_ROWS,
                        A_MODIFY_REASON);

      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         L_SQLERRM := 'SaveScParameter returned '||TO_CHAR(L_RET_CODE)||' sc='||L_CA_SC||
                      '#pg='||L_CA_PG||'#pgnode='||TO_CHAR(L_CA_PGNODE)||
                      '#pa='||L_CA_PA||'#panode='||TO_CHAR(L_CA_PANODE)||
                      '#nr_of_rows='||TO_CHAR(L_PA_NR_OF_ROWS)||'#modify_flag(1)='||TO_CHAR(L_PA_MODIFY_FLAG_TAB(1));
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
         RAISE STPERROR;
      END IF;

      
      L_CA_PGNODE := L_PA_PGNODE_TAB(1);
      L_CA_PANODE := L_PA_PANODE_TAB(1);

      L_CA_ME := A_MT;
      L_CA_MT_VERSION_IN := A_MT_VERSION;
            
      L_ME_SEQ := 1;      
      L_ME_NR_OF_ROWS := NULL;
      
      L_RET_CODE := UNAPIME.INITSCMETHOD(L_CA_ME,
                       L_CA_MT_VERSION_IN,
                       L_ME_SEQ,
                       L_CA_SC,
                       L_CA_PG,
                       L_CA_PGNODE,
                       L_CA_PA,
                       L_CA_PANODE,
                       L_CA_PR_VERSION_IN,
                       L_ME_MT_NR_MEASUR,
                       L_ME_REANALYSIS_TAB,
                       L_ME_MT_VERSION_TAB,
                       L_ME_DESCRIPTION_TAB,
                       L_ME_VALUE_F_TAB,
                       L_ME_VALUE_S_TAB,
                       L_ME_UNIT_TAB,
                       L_ME_EXEC_START_DATE_TAB,
                       L_ME_EXEC_END_DATE_TAB,
                       L_ME_EXECUTOR_TAB,
                       L_ME_LAB_TAB,
                       L_ME_EQ_TAB,
                       L_ME_EQ_VERSION_TAB,
                       L_ME_PLANNED_EXECUTOR_TAB,
                       L_ME_PLANNED_EQ_TAB,
                       L_ME_PLANNED_EQ_VERSION_TAB,
                       L_ME_MANUALLY_ENTERED_TAB,
                       L_ME_ALLOW_ADD_TAB,
                       L_ME_ASSIGN_DATE_TAB,
                       L_ME_ASSIGNED_BY_TAB,
                       L_ME_MANUALLY_ADDED_TAB,
                       L_ME_DELAY_TAB,
                       L_ME_DELAY_UNIT_TAB,
                       L_ME_FORMAT_TAB,
                       L_ME_ACCURACY_TAB,
                       L_ME_REAL_COST_TAB,
                       L_ME_REAL_TIME_TAB,
                       L_ME_CALIBRATION_TAB,
                       L_ME_CONFIRM_COMPLETE_TAB,
                       L_ME_AUTORECALC_TAB,
                       L_ME_ME_RESULT_EDITABLE_TAB,
                       L_ME_NEXT_CELL_TAB,
                       L_ME_SOP_TAB,
                       L_ME_SOP_VERSION_TAB,
                       L_ME_PLAUS_LOW_TAB,
                       L_ME_PLAUS_HIGH_TAB,
                       L_ME_WINSIZE_X_TAB,
                       L_ME_WINSIZE_Y_TAB,
                       L_ME_ME_CLASS_TAB,
                       L_ME_LOG_HS_TAB,
                       L_ME_LOG_HS_DETAILS_TAB,
                       L_ME_LC_TAB,
                       L_ME_LC_VERSION_TAB,
                       L_ME_NR_OF_ROWS);

      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         L_SQLERRM := 'InitScMethod returned '||TO_CHAR(L_RET_CODE)||
                      ' mt='||L_CA_ME||'#mt_version='||L_CA_MT_VERSION_IN||
                      '#seq='||TO_CHAR(L_ME_SEQ)||'#sc='||L_CA_SC||
                      '#pg='||L_CA_PG||'#pgnode='||TO_CHAR(L_CA_PGNODE)||
                      '#pa='||L_CA_PA||'#panode='||TO_CHAR(L_CA_PANODE)||
                      '#nr_of_rows='||TO_CHAR(L_ME_NR_OF_ROWS);
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
         RAISE STPERROR;
      END IF;

      FOR L_ROW IN 1..L_ME_NR_OF_ROWS LOOP
         L_ME_SC_TAB(L_ROW) := L_CA_SC;
         L_ME_PG_TAB(L_ROW) := L_CA_PG;
         L_ME_PGNODE_TAB(L_ROW) := L_CA_PGNODE;
         L_ME_PA_TAB(L_ROW) := L_CA_PA;
         L_ME_PANODE_TAB(L_ROW) := L_CA_PANODE;
         L_ME_ME_TAB(L_ROW) := L_CA_ME;
         L_ME_MENODE_TAB(L_ROW) := L_CA_MENODE;
         L_ME_LAB_TAB(L_ROW) := A_LAB;
         L_ME_EQ_TAB(L_ROW) := A_EQ;
         L_ME_EQ_VERSION_TAB(L_ROW) := A_VERSION;
         L_ME_CALIBRATION_TAB(L_ROW) := '1';                  
         L_ME_MODIFY_FLAG_TAB(L_ROW) := UNAPIGEN.MOD_FLAG_INSERT;
      END LOOP;

      L_RET_CODE := UNAPIME.SAVESCMETHOD('0',
                 L_ME_SC_TAB,
                 L_ME_PG_TAB,
                 L_ME_PGNODE_TAB,
                 L_ME_PA_TAB,
                 L_ME_PANODE_TAB,
                 L_ME_ME_TAB,
                 L_ME_MENODE_TAB,
                 L_ME_REANALYSIS_TAB,
                 L_ME_MT_VERSION_TAB,
                 L_ME_DESCRIPTION_TAB,
                 L_ME_VALUE_F_TAB,
                 L_ME_VALUE_S_TAB,
                 L_ME_UNIT_TAB,
                 L_ME_EXEC_START_DATE_TAB,
                 L_ME_EXEC_END_DATE_TAB,
                 L_ME_EXECUTOR_TAB,
                 L_ME_LAB_TAB,
                 L_ME_EQ_TAB,
                 L_ME_EQ_VERSION_TAB,
                 L_ME_PLANNED_EXECUTOR_TAB,
                 L_ME_PLANNED_EQ_TAB,
                 L_ME_PLANNED_EQ_VERSION_TAB,
                 L_ME_MANUALLY_ENTERED_TAB,
                 L_ME_ALLOW_ADD_TAB,
                 L_ME_ASSIGN_DATE_TAB,
                 L_ME_ASSIGNED_BY_TAB,
                 L_ME_MANUALLY_ADDED_TAB,
                 L_ME_DELAY_TAB,
                 L_ME_DELAY_UNIT_TAB,
                 L_ME_FORMAT_TAB,
                 L_ME_ACCURACY_TAB,
                 L_ME_REAL_COST_TAB,
                 L_ME_REAL_TIME_TAB,
                 L_ME_CALIBRATION_TAB,
                 L_ME_CONFIRM_COMPLETE_TAB,
                 L_ME_AUTORECALC_TAB,
                 L_ME_ME_RESULT_EDITABLE_TAB,
                 L_ME_NEXT_CELL_TAB,
                 L_ME_SOP_TAB,
                 L_ME_SOP_VERSION_TAB,
                 L_ME_PLAUS_LOW_TAB,
                 L_ME_PLAUS_HIGH_TAB,
                 L_ME_WINSIZE_X_TAB,
                 L_ME_WINSIZE_Y_TAB,
                 L_ME_ME_CLASS_TAB,
                 L_ME_LOG_HS_TAB,
                 L_ME_LOG_HS_DETAILS_TAB,
                 L_ME_LC_TAB,
                 L_ME_LC_VERSION_TAB,
                 L_ME_MODIFY_FLAG_TAB,
                 L_ME_NR_OF_ROWS,
                 A_MODIFY_REASON);

      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         L_SQLERRM := 'SaveScMethod returned '||TO_CHAR(L_RET_CODE)||' sc='||L_CA_SC||
                      '#pg='||L_CA_PG||'#pgnode='||TO_CHAR(L_CA_PGNODE)||
                      '#pa='||L_CA_PA||'#panode='||TO_CHAR(L_CA_PANODE)||
                      '#me='||L_CA_ME||'#menode='||TO_CHAR(L_CA_MENODE)||
                      '#nr_of_rows='||TO_CHAR(L_ME_NR_OF_ROWS)||'#modify_flag(1)='||TO_CHAR(L_ME_MODIFY_FLAG_TAB(1));

         UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
         RAISE STPERROR;
      END IF;
      L_CA_MENODE := L_ME_MENODE_TAB(1);
   END IF;
   
   A_CA_SC := L_CA_SC;
   A_CA_PG := L_CA_PG;
   A_CA_PGNODE := L_CA_PGNODE;
   A_CA_PA := L_CA_PA;
   A_CA_PANODE := L_CA_PANODE;
   A_CA_ME := L_CA_ME;
   A_CA_MENODE := L_CA_MENODE;
   UNAPIGEN.P_LAB := NULL; 

EXCEPTION
WHEN OTHERS THEN
   UNAPIGEN.P_LAB := NULL; 
   RAISE;
   
END CREATEEQINTREVENTIONSCORME;




FUNCTION STARTEQMANAGER              
RETURN NUMBER IS

L_RUNNING    CHAR(1);

BEGIN
   RETURN(MANEUVEREQMANAGER('START',L_RUNNING));
END STARTEQMANAGER;

FUNCTION STOPEQMANAGER               
RETURN NUMBER IS

L_RUNNING    CHAR(1);

BEGIN
   RETURN(MANEUVEREQMANAGER('STOP',L_RUNNING));
END STOPEQMANAGER;

FUNCTION ISEQMANAGERRUNNING          
RETURN NUMBER IS

L_RUNNING    CHAR(1);

BEGIN
   L_RET_CODE := MANEUVEREQMANAGER('CHECK',L_RUNNING);
   IF L_RET_CODE = UNAPIGEN.DBERR_SUCCESS THEN
      IF L_RUNNING = '0' THEN
         RETURN(UNAPIGEN.DBERR_NOOBJECT);
      ELSE
         RETURN(UNAPIGEN.DBERR_SUCCESS);
      END IF;      
   ELSE
      RETURN(L_RET_CODE);      
   END IF;
END ISEQMANAGERRUNNING;

FUNCTION CREATEEQINTERVENTION
(A_EQ                      IN      VARCHAR2,     
 A_LAB                     IN      VARCHAR2,     
 A_CA                      IN      VARCHAR2,     
 A_ST                      IN      VARCHAR2,     
 A_MT                      IN      VARCHAR2,     
 A_MODIFY_REASON           IN      VARCHAR2)     
RETURN NUMBER IS

A_VERSION                        VARCHAR2(20);
A_CA_VERSION                     VARCHAR2(20);
L_CA_SC                          VARCHAR2(20);
L_CA_PG                          VARCHAR2(20);
L_CA_PGNODE                      NUMBER(9);
L_CA_PA                          VARCHAR2(20);
L_CA_PANODE                      NUMBER(9);
L_CA_ME                          VARCHAR2(20);
L_CA_MENODE                      NUMBER(9);
L_SVGK_VALUE                     UNAPIGEN.VC40_TABLE_TYPE;
L_SVGK_NR_OF_ROWS                INTEGER;
L_HS_DETAILS_SEQ_NR              INTEGER;
L_OLD_EQ                         VARCHAR2(20);
L_OLD_EQ_VERSION                 VARCHAR2(20);
L_OLD_CALIBRATION                CHAR(1);
L_ME_LOG_HS_DETAILS              CHAR(1);
L_GK                             VARCHAR2(20);

L_GK_PRESENT                     BOOLEAN;

CURSOR L_EQCA_CURSOR (A_EQ VARCHAR2, A_LAB VARCHAR2, A_VERSION VARCHAR2, A_CA VARCHAR2) IS
   SELECT EQ, VERSION, CA, SC
   FROM UTEQCA
   WHERE EQ = A_EQ
     AND LAB = A_LAB
     AND VERSION = A_VERSION
     AND CA = A_CA;
L_EQCA_REC   L_EQCA_CURSOR%ROWTYPE;


CURSOR L_GK_CURSOR(A_GK_NAME VARCHAR2) IS
SELECT GK 
FROM UTGKSC 
WHERE GK = A_GK_NAME;

CURSOR L_SCME_CURSOR(C_SC VARCHAR2, 
                     C_PG VARCHAR2, C_PGNODE NUMBER,
                     C_PA VARCHAR2, C_PANODE NUMBER,
                     C_ME VARCHAR2, C_MENODE NUMBER) IS
   SELECT EQ, EQ_VERSION, CALIBRATION, LOG_HS_DETAILS
   FROM UTSCME
   WHERE SC = C_SC
   AND PG = C_PG
   AND PGNODE = C_PGNODE
   AND PA = C_PA
   AND PANODE = C_PANODE
   AND ME = C_ME
   AND MENODE = C_MENODE;

BEGIN
   

   
   A_VERSION := UNVERSION.P_NO_VERSION;
   IF A_VERSION IS NULL THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
      RAISE STPERROR;
   END IF;

   A_CA_VERSION := UNVERSION.P_NO_VERSION;
   IF A_CA_VERSION IS NULL THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
      RAISE STPERROR;
   END IF;
   

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_EQ, ' ') = ' ' OR
      NVL(A_LAB, ' ') = ' ' OR
      NVL(A_CA, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   L_SQLERRM := NULL;
   
   
   
   OPEN L_EQCA_CURSOR(A_EQ, A_LAB, A_VERSION, A_CA);
   FETCH L_EQCA_CURSOR
   INTO L_EQCA_REC;
   
   IF L_EQCA_CURSOR%NOTFOUND THEN
      CLOSE L_EQCA_CURSOR;
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      RAISE STPERROR;
   ELSE
      IF L_EQCA_REC.SC IS NOT NULL THEN
         CLOSE L_EQCA_CURSOR;
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_CAINPROGRESS;
         RAISE STPERROR;         
      END IF;       
   END IF;
   CLOSE L_EQCA_CURSOR;

   IF A_ST IS NULL AND A_MT IS NULL THEN
      
      L_CA_SC := NULL;
      L_CA_PG := NULL;
      L_CA_PGNODE := NULL;
      L_CA_PA := NULL;
      L_CA_PANODE := NULL;
      L_CA_ME := NULL;
      L_CA_MENODE := NULL;
   ELSE
      CREATEEQINTREVENTIONSCORME(A_EQ , 
                                 A_LAB,
                                 A_CA ,
                                 A_ST,
                                 A_MT ,
                                 L_CA_SC,
                                 L_CA_PG,
                                 L_CA_PGNODE,
                                 L_CA_PA,
                                 L_CA_PANODE,
                                 L_CA_ME,
                                 L_CA_MENODE,
                                 A_MODIFY_REASON);
   END IF;
   
   
   
   
   IF L_CA_ME IS NOT NULL THEN
      OPEN L_SCME_CURSOR(L_CA_SC, L_CA_PG, L_CA_PGNODE, L_CA_PA, L_CA_PANODE, L_CA_ME, L_CA_MENODE);
      FETCH L_SCME_CURSOR INTO L_OLD_EQ, L_OLD_EQ_VERSION, L_OLD_CALIBRATION, L_ME_LOG_HS_DETAILS;
      IF L_SCME_CURSOR%NOTFOUND THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
         RAISE STPERROR;
      END IF;
      CLOSE L_SCME_CURSOR;

      UPDATE UTSCME
      SET EQ = A_EQ,      
          EQ_VERSION = A_VERSION,
          CALIBRATION = '1'
      WHERE SC = L_CA_SC
      AND PG = L_CA_PG
      AND PGNODE = L_CA_PGNODE
      AND PA = L_CA_PA
      AND PANODE = L_CA_PANODE
      AND ME = L_CA_ME
      AND MENODE = L_CA_MENODE;
   END IF;
   
   
   
   
   UPDATE UTEQCA
   SET SC = L_CA_SC, 
       PG = L_CA_PG,
       PGNODE = L_CA_PGNODE,
       PA = L_CA_PA,
       PANODE = L_CA_PANODE, 
       ME = L_CA_ME,
       MENODE = L_CA_MENODE 
   WHERE VERSION = A_VERSION
     AND EQ = A_EQ
     AND LAB = A_LAB
     AND CA = A_CA;

   
   
   
   IF L_CA_SC IS NOT NULL THEN
      L_SVGK_VALUE(1) := A_EQ;
      L_SVGK_NR_OF_ROWS := 1;
      L_RET_CODE := UNAPISCP.SAVE1SCGROUPKEY(L_CA_SC, 'intervention4eq', A_VERSION,
                                             L_SVGK_VALUE, L_SVGK_NR_OF_ROWS, '');
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         L_SQLERRM :=  
          'Save1ScGroupKey#return=' || TO_CHAR(L_RET_CODE) ||
          '#sc=' || L_CA_SC || 
          '#gk=' || 'intervention4eq' ||
          '#gk_version=' || A_VERSION ||
          '#value(1)=' || L_SVGK_VALUE(1) ||
          '#nr_of_rows=' || TO_CHAR(L_SVGK_NR_OF_ROWS);
         RAISE STPERROR;
      END IF;

      L_SVGK_VALUE(1) := A_CA;
      L_SVGK_NR_OF_ROWS := 1;
      L_RET_CODE := UNAPISCP.SAVE1SCGROUPKEY(L_CA_SC, 'interventionrule', A_VERSION,
                                             L_SVGK_VALUE, L_SVGK_NR_OF_ROWS, '');
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         L_SQLERRM :=  
          'Save1ScGroupKey#return=' || TO_CHAR(L_RET_CODE) ||
          '#sc=' || L_CA_SC || 
          '#gk=' || 'interventionrule' ||
          '#gk_version=' || A_CA_VERSION ||
          '#value(1)=' || L_SVGK_VALUE(1) ||
          '#nr_of_rows=' || TO_CHAR(L_SVGK_NR_OF_ROWS);
         RAISE STPERROR;
      END IF;   
      
      L_GK_PRESENT := TRUE;
      OPEN L_GK_CURSOR('intervention4lab') ;
      FETCH L_GK_CURSOR INTO L_GK;
      IF L_GK_CURSOR%NOTFOUND THEN
        L_GK_PRESENT := FALSE;
      END IF;
      CLOSE L_GK_CURSOR; 
      IF  L_GK_PRESENT = TRUE  THEN
          L_SVGK_VALUE(1) := A_LAB;
          L_SVGK_NR_OF_ROWS := 1;
          L_RET_CODE := UNAPISCP.SAVE1SCGROUPKEY(L_CA_SC, 'intervention4lab', A_VERSION,
                                                 L_SVGK_VALUE, L_SVGK_NR_OF_ROWS, '');
          IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
             L_SQLERRM :=  
              'Save1ScGroupKey#return=' || TO_CHAR(L_RET_CODE) ||
              '#sc=' || L_CA_SC || 
              '#gk=' || 'intervention4lab' ||
              '#gk_version=' || A_CA_VERSION ||
              '#value(1)=' || L_SVGK_VALUE(1) ||
              '#nr_of_rows=' || TO_CHAR(L_SVGK_NR_OF_ROWS);
             RAISE STPERROR;
          END IF;  
      END IF;
   END IF;

   
   
   
   
   
   
   
   L_EVENT_TP := 'EqCaMethodCreated';
   L_EV_SEQ_NR := -1;
   L_EV_DETAILS := 'version='||A_VERSION||'#lab='||A_LAB||
                   '#ca='||A_CA||'#st='||A_ST||'#mt='||A_MT||
                   '#sc='||L_CA_SC||
                   '#pg='||L_CA_PG||'#pgnode='||TO_CHAR(L_CA_PGNODE)||
                   '#pa='||L_CA_PA||'#panode='||TO_CHAR(L_CA_PANODE)||
                   '#me='||L_CA_ME||'#menode='||TO_CHAR(L_CA_MENODE);
   L_RESULT := UNAPIEV.INSERTEVENT('CreateEqIntervention', UNAPIGEN.P_EVMGR_NAME, 'eq', A_EQ, 
                                   '', '', '', L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;

   IF A_MODIFY_REASON IS NOT NULL THEN
      INSERT INTO UTEQHS(EQ, LAB, VERSION, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, 
                         WHY, TR_SEQ, EV_SEQ)
      SELECT A_EQ, A_LAB, A_VERSION, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
             'equipment "'||A_EQ||'" intervention "'||A_CA||'" is created.', 
             CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR
      FROM DUAL
      WHERE EXISTS (SELECT B.EQ,B.VERSION 
                    FROM UTEQ B 
                    WHERE B.VERSION=A_VERSION
                      AND B.LAB = A_LAB
                      AND B.EQ=A_EQ 
                      AND B.LOG_HS='1');
   END IF;

   
   
   
   INSERT INTO UTEQHS(EQ, LAB, VERSION, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, 
                      WHY, TR_SEQ, EV_SEQ)
   SELECT A_EQ, A_LAB, A_VERSION, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
          'equipment "'||A_EQ||'" intervention "'||A_CA||'" is created.', 
          CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, L_EV_DETAILS, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR
   FROM DUAL
   WHERE EXISTS (SELECT B.EQ,B.VERSION 
                 FROM UTEQ B 
                 WHERE B.VERSION=A_VERSION 
                   AND B.LAB = A_LAB
                   AND B.EQ=A_EQ 
                   AND B.LOG_HS='1');

   IF L_CA_ME IS NOT NULL THEN
      L_HS_DETAILS_SEQ_NR := 0;
      IF L_ME_LOG_HS_DETAILS = '1' THEN
         IF NVL((L_OLD_EQ <> A_EQ), TRUE) AND NOT(L_OLD_EQ IS NULL AND A_EQ IS NULL) THEN 
            L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
            INSERT INTO UTSCMEHSDETAILS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, 
                                        TR_SEQ, EV_SEQ, SEQ, DETAILS)
            VALUES(L_CA_SC, L_CA_PG, L_CA_PGNODE, L_CA_PA, L_CA_PANODE, L_CA_ME, L_CA_MENODE, 
                   UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR,
                   'method  "'||L_CA_ME||'" is updated: property <eq> changed value from "'||L_OLD_EQ||'" to "'||A_EQ||'".');
         END IF;
         IF NVL((L_OLD_EQ_VERSION <> A_VERSION), TRUE) AND NOT(L_OLD_EQ_VERSION IS NULL AND A_VERSION IS NULL) THEN 
            L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
            INSERT INTO UTSCMEHSDETAILS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, 
                                        TR_SEQ, EV_SEQ, SEQ, DETAILS)
            VALUES(L_CA_SC, L_CA_PG, L_CA_PGNODE, L_CA_PA, L_CA_PANODE, L_CA_ME, L_CA_MENODE, 
                   UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR,
                   'method  "'||L_CA_ME||'" is updated: property <eq_version> changed value from "'||L_OLD_EQ_VERSION||'" to "'||A_VERSION||'".');
         END IF;
         IF NVL((L_OLD_CALIBRATION <> '1'), TRUE) THEN 
            L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
            INSERT INTO UTSCMEHSDETAILS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, 
                                        TR_SEQ, EV_SEQ, SEQ, DETAILS)
            VALUES(L_CA_SC, L_CA_PG, L_CA_PGNODE, L_CA_PA, L_CA_PANODE, L_CA_ME, L_CA_MENODE, 
                   UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR,
                   'method  "'||L_CA_ME||'" is updated: property <calibration> changed value from "'||L_OLD_CALIBRATION||'" to "1".');
         END IF;
      END IF;
   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('CreateEqIntervention', SQLERRM);
   ELSIF L_SQLERRM IS NOT NULL THEN
      UNAPIGEN.LOGERROR('CreateEqIntervention', L_SQLERRM);   
   END IF;
   IF L_EQCA_CURSOR%ISOPEN THEN
      CLOSE L_EQCA_CURSOR;
   END IF;
   IF L_SCME_CURSOR%ISOPEN THEN
      CLOSE L_SCME_CURSOR;
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'CreateEqIntervention'));
END CREATEEQINTERVENTION;

PROCEDURE EQUIPMENTMANAGERJOB        
IS

L_NEW_CA_WARN_LEVEL      VARCHAR2(1);
L_INTERVENTION           VARCHAR2(1);
L_DBA_NAME               VARCHAR2(40);
L_NUMERIC_CHARACTERS     VARCHAR2(2);
L_DATEFORMAT             VARCHAR2(255);
L_UP                     NUMBER(5);
L_USER_PROFILE           VARCHAR2(40);
L_LANGUAGE               VARCHAR2(20);
L_TK                     VARCHAR2(20);
L_SQLERRM2               VARCHAR2(255);
L_TIMEZONE                      VARCHAR2(64);
L_JOB_SETCONCUSTOMPAR    VARCHAR2(255);

CURSOR L_EQCA_CURSOR  IS
   SELECT EQ, LAB, VERSION, CA, SEQ, ST, MT, 
          FREQ_TP, 
          FREQ_VAL, 
          FREQ_UNIT,
          NVL(INVERT_FREQ, '0') WARNING_UPFRONT,
          NVL(LAST_SCHED, TO_TIMESTAMP_TZ('01/01/1970 00:00:00','DD/MM/YYYY HH24:MI:SS'))LAST_SCHED,
          LAST_VAL, 
          NVL(LAST_CNT, 0) LAST_CNT,
          NVL(SUSPEND, '0') SUSPEND,
          NVL(GRACE_VAL,0) GRACE_VAL,
          NVL(GRACE_UNIT,'DD') GRACE_UNIT, 
          NVL(CA_WARN_LEVEL,'0') CA_WARN_LEVEL
   FROM UTEQCA
   WHERE FREQ_TP='T'
   ORDER BY EQ,SEQ;
      
BEGIN
   L_TIMEZONE := 'SERVER';
   L_SQLERRM := NULL;
   
   
   
   L_DATEFORMAT := 'DDfx/fxMM/RR HH24fx:fxMI:SS';
   OPEN C_SYSTEM ('JOBS_DATE_FORMAT');
   FETCH C_SYSTEM INTO L_DATEFORMAT;
   CLOSE C_SYSTEM;

   OPEN C_SYSTEM ('DBA_NAME');
   FETCH C_SYSTEM INTO L_DBA_NAME;
   IF C_SYSTEM%NOTFOUND THEN
      CLOSE C_SYSTEM;
      L_SQLERRM := 'DBA_NAME system default not defined ';
      RAISE STPERROR;
   END IF;
   CLOSE C_SYSTEM;
   
   L_NUMERIC_CHARACTERS := 'DB';
   L_RET_CODE := UNAPIGEN.SETCONNECTION4INSTALL('EquipmentManagerJob', 
                                        L_DBA_NAME, 
                                        'EqMgr', L_NUMERIC_CHARACTERS, L_DATEFORMAT, L_TIMEZONE,
                                        L_UP, L_USER_PROFILE, L_LANGUAGE, L_TK, '1');
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      L_SQLERRM := 'SetConnection failed ' || TO_CHAR(L_RET_CODE);
      IF L_RET_CODE = UNAPIGEN.DBERR_NOTAUTHORISED THEN
         L_SQLERRM2 := UNAPIAUT.P_NOT_AUTHORISED;
      END IF;
      RAISE STPERROR;
   END IF;
   
   OPEN C_SYSTEM ('JOB_SETCONCUSTOMPAR');
   FETCH C_SYSTEM INTO  L_JOB_SETCONCUSTOMPAR;
   IF C_SYSTEM%NOTFOUND THEN
       CLOSE C_SYSTEM;
        L_JOB_SETCONCUSTOMPAR:='';
   END IF;
   CLOSE C_SYSTEM;   
   L_RET_CODE :=  UNAPIGEN.SETCUSTOMCONNECTIONPARAMETER(L_JOB_SETCONCUSTOMPAR);
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
       L_ERRM := 'SetCustomConnectionParameter failed ' || TO_CHAR(L_RET_CODE);
       RAISE STPERROR;
   END IF;
  

   
   
   
   
   
   FOR L_EQCA_REC IN L_EQCA_CURSOR LOOP

      L_RET_CODE := UNAPIGEN.BEGINTRANSACTION;

      
      
      
      L_RET_CODE := EVALEQINTERVENTIONRULE(
                       L_EQCA_REC.EQ, 
                       L_EQCA_REC.LAB, 
                       L_EQCA_REC.CA, 
                       L_EQCA_REC.FREQ_TP, 
                       L_EQCA_REC.FREQ_VAL, 
                       L_EQCA_REC.FREQ_UNIT, 
                       L_EQCA_REC.WARNING_UPFRONT, 
                       L_EQCA_REC.GRACE_VAL, 
                       L_EQCA_REC.GRACE_UNIT,
                       L_EQCA_REC.SUSPEND,
                       L_EQCA_REC.LAST_SCHED, 
                       L_EQCA_REC.LAST_VAL, 
                       L_EQCA_REC.LAST_CNT, 
                       L_EQCA_REC.CA_WARN_LEVEL,
                       L_NEW_CA_WARN_LEVEL,
                       L_INTERVENTION);
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         L_SQLERRM := 'Fatal error EvalEqInterventionRule failed '||TO_CHAR(L_RET_CODE);
         RAISE STPERROR;
      END IF;

      
      
      
      
      IF L_INTERVENTION = '1' THEN
         L_RET_CODE := CREATEEQINTERVENTION(
                           L_EQCA_REC.EQ,
                           L_EQCA_REC.LAB,
                           L_EQCA_REC.CA,
                           L_EQCA_REC.ST,
                           L_EQCA_REC.MT,
                           'EqManagerJob Intervention:'||L_EQCA_REC.CA||
                           ' on eq:'||L_EQCA_REC.EQ);
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            IF L_RET_CODE <> UNAPIGEN.DBERR_CAINPROGRESS THEN
               L_SQLERRM := 'Fatal error CreateEqIntervention failed '||TO_CHAR(L_RET_CODE);
               RAISE STPERROR;
            ELSE
               
               UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_SUCCESS;
            END IF;
         END IF;
      END IF;

      
      
      
      
      
      
      
      
      
      
      
      IF L_EQCA_REC.CA_WARN_LEVEL <> L_NEW_CA_WARN_LEVEL THEN

         UPDATE UTEQCA A
         SET A.CA_WARN_LEVEL = L_NEW_CA_WARN_LEVEL
         WHERE A.VERSION = L_EQCA_REC.VERSION
           AND A.EQ = L_EQCA_REC.EQ
           AND A.LAB = L_EQCA_REC.LAB
           AND A.CA = L_EQCA_REC.CA
           AND TO_NUMBER(L_NEW_CA_WARN_LEVEL) > NVL(TO_NUMBER(A.CA_WARN_LEVEL),0);

         L_EV_SEQ_NR := -1;
         L_EVENT_TP := 'EqCaWarnLevelChanged';   
         L_EV_DETAILS := 'lab='|| L_EQCA_REC.LAB ||'#version=' || L_EQCA_REC.VERSION || '#ca=' || L_EQCA_REC.CA || 
                         '#old_ca_warn_level=' || NVL(L_EQCA_REC.CA_WARN_LEVEL,'0') || 
                         '#new_ca_warn_level=' || L_NEW_CA_WARN_LEVEL;
         L_RESULT := UNAPIEV.INSERTEVENT('EquipmentManagerJob', UNAPIGEN.P_EVMGR_NAME,
                                         'eq', L_EQCA_REC.EQ, '', '', '', 
                                         L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);

         IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
            L_SQLERRM := 'Fatal error InsertEvent failed '||TO_CHAR(L_RESULT);
            RAISE STPERROR;
         END IF;

         UPDATE UTEQ A
         SET A.CA_WARN_LEVEL = L_NEW_CA_WARN_LEVEL
         WHERE A.VERSION = L_EQCA_REC.VERSION
           AND A.EQ = L_EQCA_REC.EQ
           AND A.LAB = L_EQCA_REC.LAB
           AND L_NEW_CA_WARN_LEVEL > NVL(A.CA_WARN_LEVEL,0);

         L_EV_SEQ_NR := -1;
         L_EVENT_TP := 'EqWarnLevelChanged';
         L_EV_DETAILS := 'lab='|| L_EQCA_REC.LAB ||'#version=' || L_EQCA_REC.VERSION ||
                         '#old_ca_warn_level='  || L_EQCA_REC.CA_WARN_LEVEL || 
                         '#new_ca_warn_level=' || L_NEW_CA_WARN_LEVEL;
         L_RESULT := UNAPIEV.INSERTEVENT('EquipmentManagerJob', UNAPIGEN.P_EVMGR_NAME,
                                         'eq', L_EQCA_REC.EQ, '', '', '', 
                                         L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);

         IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
            L_SQLERRM := 'Fatal error InsertEvent failed '||TO_CHAR(L_RESULT);
            RAISE STPERROR;
         END IF;

      END IF;

      
      
      
      UPDATE UTEQCA
      SET LAST_SCHED = L_EQCA_REC.LAST_SCHED,
          LAST_SCHED_TZ = DECODE(L_EQCA_REC.LAST_SCHED, LAST_SCHED_TZ, LAST_SCHED_TZ, L_EQCA_REC.LAST_SCHED),
          LAST_CNT   = L_EQCA_REC.LAST_CNT,
          LAST_VAL   = L_EQCA_REC.LAST_VAL
      WHERE VERSION = L_EQCA_REC.VERSION
        AND EQ = L_EQCA_REC.EQ
        AND LAB = L_EQCA_REC.LAB
        AND CA = L_EQCA_REC.CA;
      L_RET_CODE := UNAPIGEN.ENDTRANSACTION;
      
   END LOOP;
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      L_SQLERRM := SQLERRM;
   END IF;
   UNAPIGEN.U4ROLLBACK;
   IF L_SQLERRM IS NOT NULL THEN
      INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
      VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
             'EquipmentManagerJob', L_SQLERRM);   
      UNAPIGEN.U4COMMIT;
   END IF;
   IF L_SQLERRM2 IS NOT NULL THEN
      INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
      VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
             'EquipmentManagerJob', L_SQLERRM2);   
      UNAPIGEN.U4COMMIT;
   END IF;   
END EQUIPMENTMANAGERJOB;

FUNCTION EVALCOUNTBASEDEQCARULES                 
(A_EQ                      IN      VARCHAR2,     
 A_LAB                     IN      VARCHAR2)     
RETURN NUMBER IS

A_VERSION                VARCHAR2(20);
L_NEW_CA_WARN_LEVEL      VARCHAR2(1);
L_INTERVENTION           VARCHAR2(1);
L_DATEFORMAT             VARCHAR2(255);
L_UP                     NUMBER(5);
L_USER_PROFILE           VARCHAR2(40);
L_LANGUAGE               VARCHAR2(20);
L_TK                     VARCHAR2(20);

CURSOR L_EQCA_CURSOR (A_EQ VARCHAR2, A_LAB VARCHAR2, A_VERSION VARCHAR2)  IS
   SELECT EQ, LAB, VERSION, CA, SEQ, ST, MT, 
          FREQ_TP, 
          FREQ_VAL,
          FREQ_UNIT,
          NVL(INVERT_FREQ, '0') WARNING_UPFRONT,
          NVL(LAST_SCHED, TO_TIMESTAMP_TZ('01/01/1970 00:00:00','DD/MM/YYYY HH24:MI:SS'))LAST_SCHED,
          LAST_VAL, 
          NVL(LAST_CNT, 0) LAST_CNT,
          NVL(SUSPEND, '0') SUSPEND,
          NVL(GRACE_VAL,0) GRACE_VAL,
          NVL(GRACE_UNIT,'DD') GRACE_UNIT, 
          NVL(CA_WARN_LEVEL,'0') CA_WARN_LEVEL
   FROM UTEQCA
   WHERE VERSION = A_VERSION
     AND EQ = A_EQ
     AND LAB = A_LAB
     AND FREQ_TP IN ('S', 'C')
   ORDER BY EQ,SEQ;

BEGIN

   
   A_VERSION := UNVERSION.P_NO_VERSION;
   IF A_VERSION IS NULL THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
      RAISE STPERROR;
   END IF;
   

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   L_SQLERRM := NULL;

   
   
   
   
   
   FOR L_EQCA_REC IN L_EQCA_CURSOR(A_EQ, A_LAB, A_VERSION) LOOP

      
      
      
      L_RET_CODE := EVALEQINTERVENTIONRULE(
                       L_EQCA_REC.EQ, 
                       L_EQCA_REC.LAB, 
                       L_EQCA_REC.CA, 
                       L_EQCA_REC.FREQ_TP, 
                       L_EQCA_REC.FREQ_VAL, 
                       L_EQCA_REC.FREQ_UNIT, 
                       L_EQCA_REC.WARNING_UPFRONT, 
                       L_EQCA_REC.GRACE_VAL, 
                       L_EQCA_REC.GRACE_UNIT,
                       L_EQCA_REC.SUSPEND,
                       L_EQCA_REC.LAST_SCHED, 
                       L_EQCA_REC.LAST_VAL, 
                       L_EQCA_REC.LAST_CNT, 
                       L_EQCA_REC.CA_WARN_LEVEL,
                       L_NEW_CA_WARN_LEVEL,
                       L_INTERVENTION);
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         L_SQLERRM := 'Fatal error EvalEqInterventionRule failed '||TO_CHAR(L_RET_CODE);
         RAISE STPERROR;
      END IF;

      
      
      
      
      IF L_INTERVENTION = '1' THEN
         L_RET_CODE := CREATEEQINTERVENTION(
                           L_EQCA_REC.EQ,
                           L_EQCA_REC.LAB, 
                           L_EQCA_REC.CA,
                           L_EQCA_REC.ST,
                           L_EQCA_REC.MT,
                           'CountBased Rule Intervention:'||L_EQCA_REC.CA||
                           ' on eq:'||L_EQCA_REC.EQ);
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            IF L_RET_CODE <> UNAPIGEN.DBERR_CAINPROGRESS THEN
               L_SQLERRM := 'Fatal error CreateEqIntervention failed '||TO_CHAR(L_RET_CODE);
               RAISE STPERROR;
            ELSE
               
               UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_SUCCESS;
            END IF;
         END IF;
      END IF;

      
      
      
      
      
      
      
      
      
      
      
      IF L_EQCA_REC.CA_WARN_LEVEL <> L_NEW_CA_WARN_LEVEL THEN

         UPDATE UTEQCA A
         SET A.CA_WARN_LEVEL = L_NEW_CA_WARN_LEVEL
         WHERE A.VERSION = L_EQCA_REC.VERSION
           AND A.EQ = L_EQCA_REC.EQ
           AND A.LAB = L_EQCA_REC.LAB           
           AND A.CA = L_EQCA_REC.CA
           AND TO_NUMBER(L_NEW_CA_WARN_LEVEL) > NVL(TO_NUMBER(A.CA_WARN_LEVEL),0);

         L_EV_SEQ_NR := -1;
         L_EVENT_TP := 'EqCaWarnLevelChanged';   
         L_EV_DETAILS := 'lab='|| L_EQCA_REC.LAB ||'#version=' || L_EQCA_REC.VERSION || 
                         '#ca=' || L_EQCA_REC.CA || 
                         '#old_ca_warn_level=' || NVL(L_EQCA_REC.CA_WARN_LEVEL,'0') || 
                         '#new_ca_warn_level=' || L_NEW_CA_WARN_LEVEL;
         L_RESULT := UNAPIEV.INSERTEVENT('EvalCountBasedEqCaRules', UNAPIGEN.P_EVMGR_NAME,
                                         'eq', L_EQCA_REC.EQ, '', '', '',
                                         L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);

         IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
            L_SQLERRM := 'Fatal error InsertEvent failed '||TO_CHAR(L_RESULT);
            RAISE STPERROR;
         END IF;
         
         UPDATE UTEQ A
         SET A.CA_WARN_LEVEL = L_NEW_CA_WARN_LEVEL
         WHERE A.VERSION = L_EQCA_REC.VERSION
           AND A.EQ = L_EQCA_REC.EQ
           AND A.LAB = L_EQCA_REC.LAB           
           AND TO_NUMBER(L_NEW_CA_WARN_LEVEL) > NVL(TO_NUMBER(A.CA_WARN_LEVEL),0);

         L_EV_SEQ_NR := -1;
         L_EVENT_TP := 'EqWarnLevelChanged';
         L_EV_DETAILS := 'lab='|| L_EQCA_REC.LAB ||'#version=' || L_EQCA_REC.VERSION || 
                         '#old_ca_warn_level=' || L_EQCA_REC.CA_WARN_LEVEL || 
                         '#new_ca_warn_level=' || L_NEW_CA_WARN_LEVEL;
         L_RESULT := UNAPIEV.INSERTEVENT('EvalCountBasedEqCaRules', UNAPIGEN.P_EVMGR_NAME,
                                         'eq', L_EQCA_REC.EQ, '', '', '', 
                                         L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);

         IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
            L_SQLERRM := 'Fatal error InsertEvent failed '||TO_CHAR(L_RESULT);
            RAISE STPERROR;
         END IF;

      END IF;

      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      UPDATE UTEQCA
      SET LAST_SCHED = L_EQCA_REC.LAST_SCHED,
          LAST_SCHED_TZ = DECODE(L_EQCA_REC.LAST_SCHED, LAST_SCHED_TZ, LAST_SCHED_TZ, L_EQCA_REC.LAST_SCHED),
          LAST_CNT   = DECODE(LAST_CNT, L_EQCA_REC.LAST_CNT, LAST_CNT+1, L_EQCA_REC.LAST_CNT),
          LAST_VAL   = L_EQCA_REC.LAST_VAL
      WHERE VERSION = L_EQCA_REC.VERSION
        AND EQ = L_EQCA_REC.EQ
        AND LAB = L_EQCA_REC.LAB        
        AND CA = L_EQCA_REC.CA;
      
   END LOOP;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(L_RET_CODE);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('EvalCountBasedEqCaRules', SQLERRM);
   ELSIF L_SQLERRM IS NOT NULL THEN
      UNAPIGEN.LOGERROR('EvalCountBasedEqCaRules', L_SQLERRM);   
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'EvalCountBasedEqCaRules'));
END EVALCOUNTBASEDEQCARULES;

FUNCTION CHANGEEQCASTATUS
(A_EQ                IN      VARCHAR2,     
 A_LAB               IN      VARCHAR2,     
 A_CA                IN      VARCHAR2,     
 A_NEW_CA_WARN_LEVEL IN      CHAR,         
 A_MODIFY_REASON     IN      VARCHAR2)     
RETURN NUMBER IS

A_VERSION                 VARCHAR2(20);
L_OLD_EQ_WARN_LEVEL       VARCHAR2(1);
L_OLD_EQCA_WARN_LEVEL     VARCHAR2(1);
L_MAX_EQCA_WARN_LEVEL     VARCHAR2(1);
L_MODIFY_REASON           VARCHAR2(255);
L_SVGK_VERSION            VARCHAR2(20);
L_SVGK_VALUE              UNAPIGEN.VC40_TABLE_TYPE;
L_SVGK_NR_OF_ROWS         INTEGER;

CURSOR L_EQ_WARN_LEVEL_CURSOR(A_EQ VARCHAR2, A_LAB VARCHAR2, A_VERSION VARCHAR2) IS
   SELECT NVL(CA_WARN_LEVEL, '0') CA_WARN_LEVEL
   FROM UTEQ
   WHERE VERSION = A_VERSION
     AND LAB = A_LAB
     AND EQ = A_EQ;

CURSOR L_EQCA_CURSOR(A_EQ VARCHAR2, A_LAB VARCHAR2, A_VERSION VARCHAR2, A_CA VARCHAR2) IS
   SELECT *
   FROM UTEQCA
   WHERE VERSION = A_VERSION
     AND EQ = A_EQ
     AND LAB = A_LAB
     AND CA = A_CA;
L_EQCA_REC L_EQCA_CURSOR%ROWTYPE;

CURSOR L_MAX_EQCA_WARN_LEVEL_CURSOR (A_EQ VARCHAR2, A_LAB VARCHAR2, A_VERSION VARCHAR2) IS
   SELECT NVL(MAX(CA_WARN_LEVEL), '0') MAX_EQCA_WARN_LEVEL
   FROM UTEQCA
   WHERE VERSION = A_VERSION
     AND LAB = A_LAB
     AND EQ = A_EQ;
   
BEGIN
   
   A_VERSION := UNVERSION.P_NO_VERSION;
   IF A_VERSION IS NULL THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
      RAISE STPERROR;
   END IF;
   

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_EQ, ' ') = ' ' OR
      NVL(A_LAB, ' ') = ' ' OR
      NVL(A_CA, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   IF A_NEW_CA_WARN_LEVEL NOT IN ('0', '1', '2', '3', '4') OR
      A_NEW_CA_WARN_LEVEL IS NULL THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_CAWARNLEVEL;
      RAISE STPERROR;
   END IF;

   OPEN L_EQ_WARN_LEVEL_CURSOR(A_EQ, A_LAB, A_VERSION);
   FETCH L_EQ_WARN_LEVEL_CURSOR
   INTO L_OLD_EQ_WARN_LEVEL;
   CLOSE L_EQ_WARN_LEVEL_CURSOR;

   OPEN L_EQCA_CURSOR(A_EQ, A_LAB, A_VERSION, A_CA);
   FETCH L_EQCA_CURSOR
   INTO L_EQCA_REC;
   CLOSE L_EQCA_CURSOR;
   
   UPDATE UTEQCA
   SET CA_WARN_LEVEL = A_NEW_CA_WARN_LEVEL
   WHERE VERSION = A_VERSION
     AND EQ = A_EQ
     AND LAB = A_LAB
     AND CA = A_CA;

   
   IF SQL%ROWCOUNT = 0 THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOTFOUND;
      RAISE STPERROR;
   END IF;

   L_EV_SEQ_NR := -1;
   L_EVENT_TP := 'EqCaWarnLevelChanged';   
   L_EV_DETAILS := 'version=' || A_VERSION ||'#lab=' || A_LAB || 
                   '#ca=' || A_CA || 
                   '#old_ca_warn_level=' || NVL(L_EQCA_REC.CA_WARN_LEVEL,'0') || 
                   '#new_ca_warn_level=' || A_NEW_CA_WARN_LEVEL;
   L_RESULT := UNAPIEV.INSERTEVENT('ChangeEqCaStatus', UNAPIGEN.P_EVMGR_NAME, 'eq', A_EQ, 
                                   '', '', '', L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);
                                    
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;

   
   IF A_MODIFY_REASON IS NULL THEN
      L_MODIFY_REASON := 'old_ca_warn_level='  || NVL(L_EQCA_REC.CA_WARN_LEVEL,'0') || 
                         '#new_ca_warn_level=' || A_NEW_CA_WARN_LEVEL;
   ELSE
      L_MODIFY_REASON := A_MODIFY_REASON;
   END IF;
   L_RET_CODE := UNAPIEQM.ADDEQCALOG(A_EQ, A_LAB, A_CA, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, L_EQCA_REC.SC,
                                    L_EQCA_REC.PG, L_EQCA_REC.PGNODE,
                                    L_EQCA_REC.PA, L_EQCA_REC.PANODE,
                                    L_EQCA_REC.ME, L_EQCA_REC.MENODE,
                                    NVL(L_EQCA_REC.CA_WARN_LEVEL,'0'),
                                    L_MODIFY_REASON);
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;
   
   
   IF A_NEW_CA_WARN_LEVEL IN ('0', '4') THEN
      UPDATE UTEQCA
      SET SC = NULL,
          PG = NULL,
          PGNODE = NULL,
          PA = NULL,
          PANODE = NULL,
          ME = NULL,
          MENODE = NULL
       WHERE VERSION = A_VERSION
         AND EQ = A_EQ
         AND LAB = A_LAB
         AND CA = A_CA;
    END IF;
    
   
   OPEN L_MAX_EQCA_WARN_LEVEL_CURSOR(A_EQ, A_LAB, A_VERSION);
   FETCH L_MAX_EQCA_WARN_LEVEL_CURSOR
   INTO L_MAX_EQCA_WARN_LEVEL;
   CLOSE L_MAX_EQCA_WARN_LEVEL_CURSOR;
      
   UPDATE UTEQ
   SET CA_WARN_LEVEL = L_MAX_EQCA_WARN_LEVEL
   WHERE VERSION = A_VERSION
     AND EQ = A_EQ
     AND LAB = A_LAB
     AND NVL(CA_WARN_LEVEL,'0') <> L_MAX_EQCA_WARN_LEVEL;
   
   
   L_EV_SEQ_NR := -1;
   L_EVENT_TP := 'EqWarnLevelChanged';   
   L_EV_DETAILS := 'version=' || A_VERSION || 
                   '#lab=' || A_LAB ||    
                   '#old_ca_warn_level=' || L_OLD_EQ_WARN_LEVEL || 
                   '#new_ca_warn_level=' || L_MAX_EQCA_WARN_LEVEL;
   L_RESULT := UNAPIEV.INSERTEVENT('ChangeEqCaStatus', UNAPIGEN.P_EVMGR_NAME, 'eq', A_EQ, 
                                   '', '', '', L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);

   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;
      
   
   
   
   INSERT INTO UTEQHS(EQ, LAB, VERSION, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, 
                      WHY, TR_SEQ, EV_SEQ)
   SELECT A_EQ, A_LAB, A_VERSION, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
          'equipment "'||A_EQ||'" intervention "'||A_CA||'" warning level is updated from "'||L_OLD_EQ_WARN_LEVEL||'" to "'||L_MAX_EQCA_WARN_LEVEL||'".', 
          CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'ca=' || A_CA || '#' || L_EV_DETAILS, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR
   FROM DUAL
   WHERE EXISTS (SELECT B.EQ, B.VERSION 
                   FROM UTEQ B 
                  WHERE B.VERSION=A_VERSION AND B.EQ=A_EQ AND B.LAB=A_LAB AND B.LOG_HS='1');

   
   
   
   
   IF A_NEW_CA_WARN_LEVEL IN ('0', '4') AND 
      L_EQCA_REC.SC IS NOT NULL THEN
      
      
      L_RET_CODE := UNAPIAUT.DISABLEALLOWMODIFYCHECK('1');
      
      L_SVGK_NR_OF_ROWS := 0;
      L_RET_CODE := UNAPISCP.SAVE1SCGROUPKEY(L_EQCA_REC.SC, 'intervention4eq', L_SVGK_VERSION,
                                             L_SVGK_VALUE, L_SVGK_NR_OF_ROWS, '');
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         L_SQLERRM :=  
          'Save1ScGroupKey#return=' || TO_CHAR(L_RET_CODE) ||
          '#sc=' || L_EQCA_REC.SC || 
          '#gk=' || 'intervention4eq' ||
          '#nr_of_rows=' || TO_CHAR(L_SVGK_NR_OF_ROWS);
         RAISE STPERROR;
      END IF;

      L_SVGK_NR_OF_ROWS := 0;
      L_RET_CODE := UNAPISCP.SAVE1SCGROUPKEY(L_EQCA_REC.SC, 'interventionrule', L_SVGK_VERSION,
                                             L_SVGK_VALUE, L_SVGK_NR_OF_ROWS, '');
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         L_SQLERRM :=  
          'Save1ScGroupKey#return=' || TO_CHAR(L_RET_CODE) ||
          '#sc=' || L_EQCA_REC.SC || 
          '#gk=' || 'interventionrule' ||
          '#nr_of_rows=' || TO_CHAR(L_SVGK_NR_OF_ROWS);
         RAISE STPERROR;
      END IF;   

      L_SVGK_NR_OF_ROWS := 0;
      L_RET_CODE := UNAPISCP.SAVE1SCGROUPKEY(L_EQCA_REC.SC, 'intervention4lab', L_SVGK_VERSION,
                                             L_SVGK_VALUE, L_SVGK_NR_OF_ROWS, '');
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         L_SQLERRM :=  
          'Save1ScGroupKey#return=' || TO_CHAR(L_RET_CODE) ||
          '#sc=' || L_EQCA_REC.SC || 
          '#gk=' || 'intervention4lab' ||
          '#nr_of_rows=' || TO_CHAR(L_SVGK_NR_OF_ROWS);
         RAISE STPERROR;
      END IF;

      
      L_RET_CODE := UNAPIAUT.DISABLEALLOWMODIFYCHECK('0');

   END IF;
      
   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('ChangeEqCaStatus', SQLERRM);
   
   ELSIF L_SQLERRM IS NOT NULL THEN
   
      UNAPIGEN.LOGERROR('ChangeEqCaStatus', L_SQLERRM);   
   END IF;
   IF L_EQ_WARN_LEVEL_CURSOR%ISOPEN THEN
      CLOSE L_EQ_WARN_LEVEL_CURSOR;
   END IF;
   IF L_EQCA_CURSOR%ISOPEN THEN
      CLOSE L_EQCA_CURSOR;
   END IF;
   IF L_MAX_EQCA_WARN_LEVEL_CURSOR%ISOPEN THEN
      CLOSE L_MAX_EQCA_WARN_LEVEL_CURSOR;
   END IF;
   
   L_RET_CODE := UNAPIAUT.DISABLEALLOWMODIFYCHECK('0');
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'ChangeEqCaStatus'));
END CHANGEEQCASTATUS;

FUNCTION ADDEQCALOG
(A_EQ            IN        VARCHAR2,      
 A_LAB           IN        VARCHAR2,      
 A_CA            IN        VARCHAR2,      
 A_WHO           IN        VARCHAR2,      
 A_LOGDATE       IN        DATE,          
 A_SC            IN        VARCHAR2,      
 A_PG            IN        VARCHAR2,      
 A_PGNODE        IN        NUMBER,        
 A_PA            IN        VARCHAR2,      
 A_PANODE        IN        NUMBER,        
 A_ME            IN        VARCHAR2,      
 A_MENODE        IN        NUMBER,        
 A_CA_WARN_LEVEL IN        CHAR,          
 A_MODIFY_REASON IN        VARCHAR2)      
RETURN NUMBER IS

A_VERSION      VARCHAR2(20);

BEGIN
   
   A_VERSION := UNVERSION.P_NO_VERSION;
   IF A_VERSION IS NULL THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
      RAISE STPERROR;
   END IF;
   

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;
   
   
   INSERT INTO UTEQCALOG
   (EQ, LAB, VERSION, CA, SEQ, WHO, LOGDATE, LOGDATE_TZ, SC, PG, PGNODE, PA, PANODE, ME, MENODE, CA_WARN_LEVEL, WHY)
   VALUES
   (A_EQ, A_LAB, A_VERSION, A_CA, NULL, A_WHO, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, 
    A_CA_WARN_LEVEL, A_MODIFY_REASON);
   
   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(L_RET_CODE);
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('AddEqCaLog', SQLERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'AddEqCaLog'));
END ADDEQCALOG;

FUNCTION GETEQCALOG
(A_EQ             OUT      VARCHAR2,                    
 A_LAB            OUT      VARCHAR2,                    
 A_CA             OUT      UNAPIGEN.VC20_TABLE_TYPE,    
 A_WHO            OUT      UNAPIGEN.VC20_TABLE_TYPE,    
 A_LOGDATE        OUT      UNAPIGEN.DATE_TABLE_TYPE,    
 A_SC             OUT      UNAPIGEN.VC20_TABLE_TYPE,    
 A_PG             OUT      UNAPIGEN.VC20_TABLE_TYPE,    
 A_PGNODE         OUT      UNAPIGEN.LONG_TABLE_TYPE,    
 A_PA             OUT      UNAPIGEN.VC20_TABLE_TYPE,    
 A_PANODE         OUT      UNAPIGEN.LONG_TABLE_TYPE,    
 A_ME             OUT      UNAPIGEN.VC20_TABLE_TYPE,    
 A_MENODE         OUT      UNAPIGEN.LONG_TABLE_TYPE,    
 A_CA_WARN_LEVEL  OUT      UNAPIGEN.CHAR1_TABLE_TYPE,   
 A_WHY            OUT      UNAPIGEN.VC255_TABLE_TYPE,   
 A_NR_OF_ROWS     IN OUT   NUMBER,                      
 A_WHERE_CLAUSE   IN       VARCHAR2)                    
RETURN NUMBER IS

L_EQ                VARCHAR2(20);
L_LAB               VARCHAR2(20);
L_CA                VARCHAR2(20);
L_WHO               VARCHAR2(20);
L_LOGDATE           TIMESTAMP WITH TIME ZONE;
L_SC                VARCHAR2(20);
L_PG                VARCHAR2(20);
L_PGNODE            NUMBER(9);
L_PA                VARCHAR2(20);
L_PANODE            NUMBER(9);
L_ME                VARCHAR2(20);
L_MENODE            NUMBER(9);
L_CA_WARN_LEVEL     CHAR(1);
L_WHY               VARCHAR2(255);
L_CALOG_CURSOR      INTEGER;

BEGIN

   IF NVL(A_NR_OF_ROWS,0) = 0 THEN
      A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
   ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
      RETURN(UNAPIGEN.DBERR_NROFROWS);
   END IF;

   IF NVL(A_WHERE_CLAUSE, ' ') = ' ' THEN
      RETURN(UNAPIGEN.DBERR_WHERECLAUSE);
   ELSIF UPPER(SUBSTR(A_WHERE_CLAUSE,1,6)) <> 'WHERE ' THEN
      L_WHERE_CLAUSE := ', dd'||UNAPIGEN.P_DD||'.uveq eq WHERE eq.version_is_current = ''1'' '||
                        'AND calog.version = eq.version '||
                        'AND calog.eq = eq.eq '||
                        'AND calog.lab = eq.lab '||
                        'AND calog.eq = ''' || REPLACE(A_WHERE_CLAUSE, '''', '''''') || 
                        ''' AND calog.lab=''-'' ORDER BY calog.logdate DESC';
   ELSE
      L_WHERE_CLAUSE := A_WHERE_CLAUSE; 
   END IF;

   L_CALOG_CURSOR := DBMS_SQL.OPEN_CURSOR;
   L_SQL_STRING := 'SELECT calog.eq, calog.lab, calog.ca, calog.who, calog.logdate, calog.sc, calog.pg, calog.pgnode, '||
                   'calog.pa, calog.panode, calog.me, calog.menode, calog.ca_warn_level, calog.why '||
                   'FROM dd' || UNAPIGEN.P_DD || '.uveqcalog calog ' ||
                   L_WHERE_CLAUSE;
   DBMS_SQL.PARSE(L_CALOG_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 

   DBMS_SQL.DEFINE_COLUMN(L_CALOG_CURSOR,       1, L_EQ, 20);
   DBMS_SQL.DEFINE_COLUMN(L_CALOG_CURSOR,       2, L_LAB, 20);
   DBMS_SQL.DEFINE_COLUMN(L_CALOG_CURSOR,       3, L_CA, 20);
   DBMS_SQL.DEFINE_COLUMN(L_CALOG_CURSOR,       4, L_WHO, 20);
   DBMS_SQL.DEFINE_COLUMN(L_CALOG_CURSOR,       5, L_LOGDATE);
   DBMS_SQL.DEFINE_COLUMN(L_CALOG_CURSOR,       6, L_SC, 20);
   DBMS_SQL.DEFINE_COLUMN(L_CALOG_CURSOR,       7, L_PG, 20);
   DBMS_SQL.DEFINE_COLUMN(L_CALOG_CURSOR,       8, L_PGNODE);
   DBMS_SQL.DEFINE_COLUMN(L_CALOG_CURSOR,       9, L_PA, 20);
   DBMS_SQL.DEFINE_COLUMN(L_CALOG_CURSOR,      10, L_PANODE);
   DBMS_SQL.DEFINE_COLUMN(L_CALOG_CURSOR,      11, L_ME, 20);
   DBMS_SQL.DEFINE_COLUMN(L_CALOG_CURSOR,      12, L_MENODE);
   DBMS_SQL.DEFINE_COLUMN_CHAR(L_CALOG_CURSOR, 13, L_CA_WARN_LEVEL, 1);
   DBMS_SQL.DEFINE_COLUMN(L_CALOG_CURSOR,      14, L_WHY, 255);

   L_RESULT := DBMS_SQL.EXECUTE_AND_FETCH(L_CALOG_CURSOR);
   L_FETCHED_ROWS := 0;

   LOOP

      EXIT WHEN L_RESULT = 0 OR L_FETCHED_ROWS >= A_NR_OF_ROWS;

      DBMS_SQL.COLUMN_VALUE(L_CALOG_CURSOR,       1, L_EQ);
      DBMS_SQL.COLUMN_VALUE(L_CALOG_CURSOR,       2, L_LAB);
      DBMS_SQL.COLUMN_VALUE(L_CALOG_CURSOR,       3, L_CA);
      DBMS_SQL.COLUMN_VALUE(L_CALOG_CURSOR,       4, L_WHO);
      DBMS_SQL.COLUMN_VALUE(L_CALOG_CURSOR,       5, L_LOGDATE);
      DBMS_SQL.COLUMN_VALUE(L_CALOG_CURSOR,       6, L_SC);
      DBMS_SQL.COLUMN_VALUE(L_CALOG_CURSOR,       7, L_PG);
      DBMS_SQL.COLUMN_VALUE(L_CALOG_CURSOR,       8, L_PGNODE);
      DBMS_SQL.COLUMN_VALUE(L_CALOG_CURSOR,       9, L_PA);
      DBMS_SQL.COLUMN_VALUE(L_CALOG_CURSOR,      10, L_PANODE);
      DBMS_SQL.COLUMN_VALUE(L_CALOG_CURSOR,      11, L_ME);
      DBMS_SQL.COLUMN_VALUE(L_CALOG_CURSOR,      12, L_MENODE);
      DBMS_SQL.COLUMN_VALUE_CHAR(L_CALOG_CURSOR, 13, L_CA_WARN_LEVEL);
      DBMS_SQL.COLUMN_VALUE(L_CALOG_CURSOR,      14, L_WHY);

      L_FETCHED_ROWS := L_FETCHED_ROWS + 1;
      A_EQ := L_EQ;
      A_LAB := L_LAB;
      A_CA(L_FETCHED_ROWS)  := L_CA;
      A_WHO(L_FETCHED_ROWS) := L_WHO;
      A_LOGDATE(L_FETCHED_ROWS) := TO_CHAR(L_LOGDATE);
      A_SC(L_FETCHED_ROWS) := L_SC;
      A_PG(L_FETCHED_ROWS) := L_PG;
      A_PGNODE(L_FETCHED_ROWS) := L_PGNODE;
      A_PA(L_FETCHED_ROWS) := L_PA;
      A_PANODE(L_FETCHED_ROWS) := L_PANODE;
      A_ME(L_FETCHED_ROWS) := L_ME;
      A_MENODE(L_FETCHED_ROWS) := L_MENODE;
      A_CA_WARN_LEVEL(L_FETCHED_ROWS) := L_CA_WARN_LEVEL;
      A_WHY(L_FETCHED_ROWS) := L_WHY;

      IF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
         L_RESULT := DBMS_SQL.FETCH_ROWS(L_CALOG_CURSOR);
      END IF;
   END LOOP;

   DBMS_SQL.CLOSE_CURSOR(L_CALOG_CURSOR);

   IF L_FETCHED_ROWS = 0 THEN
      L_RET_CODE := UNAPIGEN.DBERR_NORECORDS;
   ELSE
      A_NR_OF_ROWS := L_FETCHED_ROWS;
      L_RET_CODE := UNAPIGEN.DBERR_SUCCESS;
   END IF;

   RETURN(L_RET_CODE);

EXCEPTION
   WHEN OTHERS THEN
      L_SQLERRM := SQLERRM;
      UNAPIGEN.U4ROLLBACK;
      INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
      VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
             'GetEqCaLog', L_SQLERRM);
      UNAPIGEN.U4COMMIT;
      IF DBMS_SQL.IS_OPEN(L_CALOG_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_CALOG_CURSOR);
      END IF;
      RETURN(UNAPIGEN.DBERR_GENFAIL);
END GETEQCALOG;

END UNAPIEQM;
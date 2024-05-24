PACKAGE BODY unapirq2 AS

TYPE BOOLEAN_TABLE_TYPE IS TABLE OF BOOLEAN INDEX BY BINARY_INTEGER;

L_SQLERRM         VARCHAR2(255);
L_SQL_STRING      VARCHAR2(2000);
L_WHERE_CLAUSE    VARCHAR2(1000);
L_EVENT_TP        UTEV.EV_TP%TYPE;
L_RET_CODE        NUMBER;
L_RESULT          NUMBER;
L_FETCHED_ROWS    NUMBER;
L_EV_SEQ_NR       NUMBER;
L_EV_DETAILS      VARCHAR2(255);
STPERROR          EXCEPTION;

CURSOR L_UTSCRQ_CURSOR(A_RQ VARCHAR2) IS
   SELECT SC
   FROM UTSC
   WHERE RQ=A_RQ;

FUNCTION GETVERSION
   RETURN VARCHAR2
IS
BEGIN
   RETURN('06.07.00.00_00.21');
EXCEPTION
   WHEN OTHERS THEN
      RETURN (NULL);
END GETVERSION;

FUNCTION DELETEREQUEST                  
(A_RQ            IN  VARCHAR2,          
 A_MODIFY_REASON IN  VARCHAR2)          
RETURN NUMBER IS

L_ALLOW_MODIFY          CHAR(1);
L_ACTIVE                CHAR(1);
L_LC                    CHAR(2);
L_LC_VERSION            CHAR(20);
L_SS                    VARCHAR2(2);
L_LOG_HS                CHAR(1);
L_LOG_HS_DETAILS        CHAR(1);
L_RQ_CURSOR             INTEGER;
L_OBJECT_ID             VARCHAR2(255);
L_SETTING_VALUE         VARCHAR2(40);
L_NEW_MASTERRQ          VARCHAR2(20);
L_RT_VERSION            CHAR(20);
L_HS_DETAILS_SEQ_NR     INTEGER;
L_SC_LOG_HS_DETAILS     CHAR(1);

CURSOR L_RQGK_CURSOR IS
   SELECT DISTINCT GK
   FROM UTRQGK
   WHERE RQ = A_RQ;

CURSOR C_SYSTEM (A_SETTING_NAME VARCHAR2) IS
   SELECT SETTING_VALUE
   FROM UTSYSTEM
   WHERE SETTING_NAME = A_SETTING_NAME;
   
CURSOR L_RQSC_CURSOR IS
   SELECT RQ,SC
   FROM UTRQSC
   WHERE RQ = A_RQ;
   
BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_RQ, ' ')= ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   L_RET_CODE := UNAPIAUT.GETRQAUTHORISATION(A_RQ, L_RT_VERSION, L_LC, L_LC_VERSION, L_SS,
                                             L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS, L_LOG_HS_DETAILS);

   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS  THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   IF L_ACTIVE = '1' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_OPACTIVE;
      RAISE STPERROR;
   END IF;

   
   IF UNAPIGEN.ISSYSTEM21CFR11COMPLIANT = UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOTALLOWEDIN21CFR11;
      RAISE STPERROR;
   END IF;

   
   DELETE FROM UTRQII
   WHERE RQ = A_RQ;

   
   DELETE FROM UTRQICAU
   WHERE RQ = A_RQ;

   DELETE FROM UTRQICHS
   WHERE RQ = A_RQ;

   DELETE FROM UTRQICHSDETAILS
   WHERE RQ = A_RQ;

   DELETE FROM UTRQIC
   WHERE RQ = A_RQ;

   
   DELETE FROM UTRQPPAU
   WHERE RQ = A_RQ;

   DELETE FROM UTRQPP
   WHERE RQ = A_RQ;

   
   DELETE FROM UTRQAU
   WHERE RQ = A_RQ;

   DELETE FROM UTRQHS
   WHERE RQ = A_RQ;

   DELETE FROM UTRQHSDETAILS
   WHERE RQ = A_RQ;

   L_RQ_CURSOR := DBMS_SQL.OPEN_CURSOR;
   
   FOR L_RQGKDEL IN L_RQGK_CURSOR LOOP
      BEGIN
         L_SQL_STRING := 'DELETE FROM utrqgk' || L_RQGKDEL.GK ||
                         ' WHERE rq = ''' || REPLACE(A_RQ, '''', '''''') || ''''; 
         DBMS_SQL.PARSE(L_RQ_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
         L_RESULT := DBMS_SQL.EXECUTE(L_RQ_CURSOR);
      EXCEPTION
      WHEN OTHERS THEN
         IF SQLCODE = -942 THEN
            NULL; 
         ELSE
            RAISE;
         END IF;
      END;
   END LOOP;

   DBMS_SQL.CLOSE_CURSOR(L_RQ_CURSOR);

   DELETE FROM UTRQGK
   WHERE RQ = A_RQ;

   DELETE FROM UTEVTIMED
   WHERE (OBJECT_TP='rq' AND OBJECT_ID=A_RQ)
      OR INSTR(EV_DETAILS, 'rq='||A_RQ) <> 0;

   DELETE FROM UTEVRULESDELAYED
   WHERE (OBJECT_TP='rq' AND OBJECT_ID=A_RQ)
      OR INSTR(EV_DETAILS, 'rq='||A_RQ) <> 0;

   DELETE FROM UTRQ
   WHERE RQ = A_RQ;
      
   OPEN C_SYSTEM ('RQDELETECASCADEONSC');
   FETCH C_SYSTEM INTO L_SETTING_VALUE;
   IF C_SYSTEM%NOTFOUND THEN
      L_SETTING_VALUE := 'NO';
   END IF;
   CLOSE C_SYSTEM;
   
   L_EVENT_TP := 'RequestDeleted';
   L_EV_SEQ_NR := -1;
   L_EV_DETAILS := 'rt_version=' || L_RT_VERSION;
   L_RESULT := UNAPIEV.INSERTEVENT('DeleteRequest', UNAPIGEN.P_EVMGR_NAME, 'rq', A_RQ, L_LC, 
                                   L_LC_VERSION, L_SS, L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;

   IF L_SETTING_VALUE = 'YES' THEN
      FOR L_RQSC_REC IN L_RQSC_CURSOR LOOP
         L_RET_CODE := UNAPISC.DELETESAMPLE(L_RQSC_REC.SC, A_MODIFY_REASON);
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            RAISE STPERROR;
         END IF;
      END LOOP;
   ELSE
      
      
      
      L_HS_DETAILS_SEQ_NR := 0;
      FOR L_RQSC_REC IN L_RQSC_CURSOR LOOP
         UPDATE UTSC
         SET RQ = NULL
         WHERE SC = L_RQSC_REC.SC
         RETURNING LOG_HS_DETAILS
         INTO L_SC_LOG_HS_DETAILS;
         
         
         
         
         IF L_SC_LOG_HS_DETAILS = '1' THEN
            
            
            
               L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
               INSERT INTO UTSCHSDETAILS(SC, TR_SEQ, EV_SEQ, SEQ, DETAILS)
               VALUES(L_RQSC_REC.SC, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR, 
                      'sample "'||L_RQSC_REC.SC||'" is updated: property <rq> changed value from "' || A_RQ || '" to NULL.');
         END IF;

         
         
         
         L_RET_CODE := UNAPISC.UPDATELINKEDSCII(L_RQSC_REC.SC, 'rq', '0', '', '', '',
                                                '', '', '',
                                                '', '', '',
                                                '', '', '', 
                                                '', '', NULL,  '',
                                                '', '', '', '', '',
                                                '', '');
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            RAISE STPERROR;
         END IF;
      END LOOP;
   END IF;

   DELETE FROM UTRQSC
   WHERE RQ = A_RQ;
   
   
   
   
   L_OBJECT_ID := 'rq='|| A_RQ;
   FOR L_SEQ_NO IN 1..UNAPIGEN.PA_OBJECT_NR LOOP
      IF SUBSTR(UNAPIGEN.PA_OBJECT_ID(L_SEQ_NO), 1, LENGTH(L_OBJECT_ID)) = L_OBJECT_ID THEN
         UNAPIGEN.PA_OBJECT_ID(L_SEQ_NO) := NULL;
      END IF;
   END LOOP;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('DeleteRequest', SQLERRM);
   END IF;
   IF DBMS_SQL.IS_OPEN(L_RQ_CURSOR) THEN
      DBMS_SQL.CLOSE_CURSOR(L_RQ_CURSOR);
   END IF;
   IF C_SYSTEM%ISOPEN THEN
      CLOSE C_SYSTEM;
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'DeleteRequest'));
END DELETEREQUEST;

FUNCTION INITRQANALYSESDETAILS                         
(A_RT               IN      VARCHAR2,                  
 A_RT_VERSION       IN OUT  VARCHAR2,                  
 A_RQ               IN      VARCHAR2,                  
 A_FILTER_FREQ      IN      CHAR,                      
 A_REF_DATE         IN      DATE,                      
 A_ADD_STPP         IN      CHAR,                      
 A_PP               OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PP_VERSION       OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PP_KEY1          OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PP_KEY2          OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PP_KEY3          OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PP_KEY4          OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PP_KEY5          OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_DELAY            OUT     UNAPIGEN.NUM_TABLE_TYPE,   
 A_DELAY_UNIT       OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_INHERIT_AU       OUT     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_NR_OF_ROWS       IN OUT  NUMBER)                    
RETURN NUMBER IS

L_REF_DATE           TIMESTAMP WITH TIME ZONE;
L_ASSIGN             BOOLEAN;
L_TOT_NR_ROWS        NUMBER;
L_FILTER_FREQ        CHAR(1);
L_DYN_CURSOR         INTEGER;

CURSOR L_RTPP_CURSOR IS
   SELECT A.RT, A.VERSION RT_VERSION, A.PP, A.PP_VERSION, A.PP_KEY1, A.PP_KEY2, A.PP_KEY3, A.PP_KEY4, A.PP_KEY5,
          A.SEQ, A.FREQ_TP, A.FREQ_VAL, A.FREQ_UNIT, A.INVERT_FREQ,
          A.LAST_SCHED, A.LAST_CNT, A.LAST_VAL, A.DELAY, A.DELAY_UNIT, A.INHERIT_AU,
          UNAPIGEN.VALIDATEPPVERSION(A.PP, A.PP_VERSION, A.PP_KEY1, A.PP_KEY2, A.PP_KEY3, A.PP_KEY4, A.PP_KEY5) VERSION_VALIDATION
   FROM UTRTPP A, UTPP B
   WHERE A.RT = A_RT
   AND A.VERSION = A_RT_VERSION
   AND A.PP = B.PP
   AND UNAPIGEN.VALIDATEPPVERSION(A.PP, A.PP_VERSION, A.PP_KEY1, A.PP_KEY2, A.PP_KEY3, A.PP_KEY4, A.PP_KEY5, B.VERSION) = B.VERSION 
   AND A.PP_KEY1 = B.PP_KEY1
   AND A.PP_KEY2 = B.PP_KEY2
   AND A.PP_KEY3 = B.PP_KEY3
   AND A.PP_KEY4 = B.PP_KEY4
   AND A.PP_KEY5 = B.PP_KEY5
   ORDER BY A.SEQ;

   
   PROCEDURE ASSIGN(C_PP IN VARCHAR2,
                    C_PP_VERSION IN VARCHAR2,
                    C_PP_KEY1 IN VARCHAR2,
                    C_PP_KEY2 IN VARCHAR2,
                    C_PP_KEY3 IN VARCHAR2,
                    C_PP_KEY4 IN VARCHAR2,
                    C_PP_KEY5 IN VARCHAR2,
                    C_DELAY IN NUMBER,
                    C_DELAY_UNIT IN VARCHAR2,
                    C_INHERIT_AU IN CHAR) IS

   BEGIN
      
      
      
      A_PP(L_TOT_NR_ROWS + 1) := C_PP;
      A_PP_VERSION(L_TOT_NR_ROWS + 1) := C_PP_VERSION;
      A_PP_KEY1(L_TOT_NR_ROWS + 1) := C_PP_KEY1;
      A_PP_KEY2(L_TOT_NR_ROWS + 1) := C_PP_KEY2;
      A_PP_KEY3(L_TOT_NR_ROWS + 1) := C_PP_KEY3;
      A_PP_KEY4(L_TOT_NR_ROWS + 1) := C_PP_KEY4;
      A_PP_KEY5(L_TOT_NR_ROWS + 1) := C_PP_KEY5;
      A_DELAY(L_TOT_NR_ROWS + 1) := C_DELAY;
      A_DELAY_UNIT(L_TOT_NR_ROWS + 1) := C_DELAY_UNIT;
      A_INHERIT_AU(L_TOT_NR_ROWS + 1) := C_INHERIT_AU;
   END ASSIGN;

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_NR_OF_ROWS, 0) = 0 THEN
      A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
   ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NROFROWS;
      RAISE STPERROR;
   END IF;

   
   
   
   
   
   
   
   IF NVL(A_RT, ' ') = ' ' OR
      NVL(A_RQ, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   A_RT_VERSION := UNAPIGEN.USEVERSION('rt', A_RT, A_RT_VERSION);

   L_REF_DATE := A_REF_DATE;
   IF L_REF_DATE IS NULL THEN
      SELECT SAMPLING_DATE
      INTO L_REF_DATE
      FROM UTRQ
      WHERE RQ = A_RQ;      
   END IF;
   IF L_REF_DATE IS NULL THEN
      L_REF_DATE := CURRENT_TIMESTAMP;
   END IF;

   L_FILTER_FREQ := NVL(A_FILTER_FREQ, '1');
   L_TOT_NR_ROWS := 0;

   
   
   
   FOR L_RTPP_REC IN L_RTPP_CURSOR LOOP

      L_RTPP_REC.PP_VERSION := UNAPIGEN.VALIDATEPPVERSION(L_RTPP_REC.PP, L_RTPP_REC.PP_VERSION, L_RTPP_REC.PP_KEY1, L_RTPP_REC.PP_KEY2, L_RTPP_REC.PP_KEY3, L_RTPP_REC.PP_KEY4, L_RTPP_REC.PP_KEY5);
      L_ASSIGN := FALSE;
      IF L_FILTER_FREQ = '0' THEN
         L_ASSIGN := TRUE;
      ELSIF L_FILTER_FREQ = '1' THEN
         L_ASSIGN := TRUE;
         IF L_RTPP_REC.FREQ_TP = 'C' THEN
            
            
            
            
            L_SQL_STRING := 'BEGIN :l_ret_code := UNFREQ.'|| L_RTPP_REC.FREQ_UNIT ||
                '(:a_rq, :a_rt, :a_rt_version, :a_pp, :a_pp_version, :a_pp_key1, ' ||
                ':a_pp_key2,:a_pp_key3,:a_pp_key4,:a_pp_key5,:a_freq_val, :a_invert_freq,:a_ref_date, ' ||
                ':a_last_sched, :a_last_cnt, :a_last_val); END;';

            L_DYN_CURSOR := DBMS_SQL.OPEN_CURSOR;

            DBMS_SQL.PARSE(L_DYN_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':l_ret_code', L_RET_CODE);
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_rq', A_RQ, 20);
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_rt', A_RT, 20);
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_rt_version', A_RT_VERSION, 20);
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_pp', L_RTPP_REC.PP, 20);
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_pp_version', L_RTPP_REC.PP_VERSION, 20);
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_pp_key1', L_RTPP_REC.PP_KEY1, 20);
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_pp_key2', L_RTPP_REC.PP_KEY2, 20);
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_pp_key3', L_RTPP_REC.PP_KEY3, 20);
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_pp_key4', L_RTPP_REC.PP_KEY4, 20);
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_pp_key5', L_RTPP_REC.PP_KEY5, 20);
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_freq_val', L_RTPP_REC.FREQ_VAL);
            DBMS_SQL.BIND_VARIABLE_CHAR(L_DYN_CURSOR, ':a_invert_freq', L_RTPP_REC.INVERT_FREQ, 1);
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_ref_date', L_REF_DATE);
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_last_sched', L_RTPP_REC.LAST_SCHED);
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_last_cnt', L_RTPP_REC.LAST_CNT);
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_last_val', L_RTPP_REC.LAST_VAL, 40);

            L_RESULT := DBMS_SQL.EXECUTE(L_DYN_CURSOR);
            DBMS_SQL.VARIABLE_VALUE(L_DYN_CURSOR, ':l_ret_code', L_RET_CODE);
            DBMS_SQL.VARIABLE_VALUE(L_DYN_CURSOR, ':a_last_sched', L_RTPP_REC.LAST_SCHED);
            DBMS_SQL.VARIABLE_VALUE(L_DYN_CURSOR, ':a_last_cnt', L_RTPP_REC.LAST_CNT);
            DBMS_SQL.VARIABLE_VALUE(L_DYN_CURSOR, ':a_last_val', L_RTPP_REC.LAST_VAL);
               
            DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
   
            IF L_RET_CODE <>  UNAPIGEN.DBERR_SUCCESS THEN
               L_ASSIGN := FALSE;
            END IF;
         ELSE
            IF NOT UNAPIAUT.EVALASSIGNMENTFREQ('rq', A_RQ, '',
                              'pp', L_RTPP_REC.PP, L_RTPP_REC.PP_VERSION,
                                               L_RTPP_REC.FREQ_TP,
                                               L_RTPP_REC.FREQ_VAL,
                                               L_RTPP_REC.FREQ_UNIT,
                                               L_RTPP_REC.INVERT_FREQ,
                                               L_REF_DATE,
                                               L_RTPP_REC.LAST_SCHED,
                                               L_RTPP_REC.LAST_CNT,
                                               L_RTPP_REC.LAST_VAL) THEN
               L_ASSIGN := FALSE;
            END IF;
         END IF;
         
         
         
         
         UPDATE UTRTPP
         SET LAST_SCHED = L_RTPP_REC.LAST_SCHED,
             LAST_SCHED_TZ = DECODE( L_RTPP_REC.LAST_SCHED, LAST_SCHED_TZ, LAST_SCHED_TZ,  L_RTPP_REC.LAST_SCHED),
             LAST_CNT = L_RTPP_REC.LAST_CNT,
             LAST_VAL = L_RTPP_REC.LAST_VAL
         WHERE RT = L_RTPP_REC.RT
           AND VERSION = L_RTPP_REC.RT_VERSION
           AND PP = L_RTPP_REC.PP
           AND PP_KEY1 = L_RTPP_REC.PP_KEY1
           AND PP_KEY2 = L_RTPP_REC.PP_KEY2
           AND PP_KEY3 = L_RTPP_REC.PP_KEY3
           AND PP_KEY4 = L_RTPP_REC.PP_KEY4
           AND PP_KEY5 = L_RTPP_REC.PP_KEY5
           AND UNAPIGEN.USEPPVERSION(PP,PP_VERSION,PP_KEY1,PP_KEY2,PP_KEY3,PP_KEY4,PP_KEY5) = UNAPIGEN.USEPPVERSION(L_RTPP_REC.PP,L_RTPP_REC.PP_VERSION,L_RTPP_REC.PP_KEY1,L_RTPP_REC.PP_KEY2,L_RTPP_REC.PP_KEY3,L_RTPP_REC.PP_KEY4,L_RTPP_REC.PP_KEY5) 
           AND SEQ = L_RTPP_REC.SEQ;

      END IF;

      IF L_ASSIGN THEN
         
         
         
         ASSIGN(L_RTPP_REC.PP, L_RTPP_REC.PP_VERSION, L_RTPP_REC.PP_KEY1,L_RTPP_REC.PP_KEY2,
                L_RTPP_REC.PP_KEY3,L_RTPP_REC.PP_KEY4,L_RTPP_REC.PP_KEY5, L_RTPP_REC.DELAY,
                L_RTPP_REC.DELAY_UNIT, L_RTPP_REC.INHERIT_AU);
         L_TOT_NR_ROWS := L_TOT_NR_ROWS + 1;
      END IF;
   END LOOP;
   
   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   
   
   
   IF L_TOT_NR_ROWS > A_NR_OF_ROWS THEN
      INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
      VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 
             'InitRqAnalysesDetails','a_nr_of_rows (' || A_NR_OF_ROWS ||
             ') too small for required ParameterProfile initialisation');
   END IF;

   A_NR_OF_ROWS := L_TOT_NR_ROWS;
   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('InitRqAnalysesDetails', SQLERRM);
   END IF;
   IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
      DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'InitRqAnalysesDetails'));
END INITRQANALYSESDETAILS;

FUNCTION INITRQSAMPLINGDETAILS                         
(A_RT               IN      VARCHAR2,                  
 A_RT_VERSION       IN OUT  VARCHAR2,                  
 A_RQ               IN      VARCHAR2,                  
 A_FILTER_FREQ      IN      CHAR,                      
 A_REF_DATE         IN      DATE,                      
 A_ST               OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_ST_VERSION       OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_DELAY            OUT     UNAPIGEN.NUM_TABLE_TYPE,   
 A_DELAY_UNIT       OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_INHERIT_AU       OUT     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_NR_PLANNED_SC    OUT     UNAPIGEN.NUM_TABLE_TYPE,   
 A_NR_OF_ROWS       IN OUT  NUMBER)                    
RETURN NUMBER IS

L_REF_DATE           TIMESTAMP WITH TIME ZONE;
L_ASSIGN             BOOLEAN;
L_ST                 UNAPIGEN.VC20_TABLE_TYPE;
L_DELAY              UNAPIGEN.NUM_TABLE_TYPE;
L_DELAY_UNIT         UNAPIGEN.VC20_TABLE_TYPE;
L_INHERIT_AU         UNAPIGEN.CHAR1_TABLE_TYPE;
L_NR_PLANNED_SC      UNAPIGEN.NUM_TABLE_TYPE;

L_TOT_NR_ROWS        NUMBER;
L_FILTER_FREQ        CHAR(1);
L_DYN_CURSOR         INTEGER;

TYPE RTST_TYPE       IS REF CURSOR;
L_RTST_DYN_CURSOR    RTST_TYPE ;
L_RTST_REC           UTRTSTBUFFER%ROWTYPE ;
L_RTST_SQL_STRING    VARCHAR2(2000); 

   
   PROCEDURE ASSIGN(C_ST            IN VARCHAR2,
                    C_ST_VERSION    IN VARCHAR2,
                    C_DELAY         IN NUMBER,
                    C_DELAY_UNIT    IN VARCHAR2,
                    C_INHERIT_AU    IN CHAR,
                    C_NR_PLANNED_SC IN NUMBER) IS


   BEGIN
      
      
      
      A_ST(L_TOT_NR_ROWS + 1) := C_ST;
      A_ST_VERSION(L_TOT_NR_ROWS + 1) := C_ST_VERSION;
      A_DELAY(L_TOT_NR_ROWS + 1) := C_DELAY;
      A_DELAY_UNIT(L_TOT_NR_ROWS + 1) := C_DELAY_UNIT;
      A_INHERIT_AU(L_TOT_NR_ROWS + 1) := C_INHERIT_AU;
      A_NR_PLANNED_SC(L_TOT_NR_ROWS + 1) := C_NR_PLANNED_SC;
   END ASSIGN;
BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_NR_OF_ROWS, 0) = 0 THEN
      A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
   ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NROFROWS;
      RAISE STPERROR;
   END IF;

   
   
   
   
   
   
   
   IF NVL(A_RT, ' ') = ' ' OR
      NVL(A_RQ, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   A_RT_VERSION := UNAPIGEN.USEVERSION('rt', A_RT, A_RT_VERSION);

   L_REF_DATE := A_REF_DATE;
   IF L_REF_DATE IS NULL THEN
      SELECT SAMPLING_DATE
      INTO L_REF_DATE
      FROM UTRQ
      WHERE RQ = A_RQ;      
   END IF;
   IF L_REF_DATE IS NULL THEN
      L_REF_DATE := CURRENT_TIMESTAMP;
   END IF;

   L_FILTER_FREQ := NVL(A_FILTER_FREQ, '1');
   L_TOT_NR_ROWS := 0;

   
   
   
   L_RET_CODE := UNAPIAUT.INITRTSTBUFFER (A_RT, A_RT_VERSION) ;
   L_RTST_SQL_STRING := 'SELECT a.* FROM utrtstbuffer a, dd'||UNAPIGEN.P_DD||'.uvst b ' ||
                        'WHERE a.rt = :a_rt AND a.version = :a_rt_version ' || 
                        'AND a.st = b.st AND UNAPIGEN.ValidateVersion(''st'', a.st, a.st_version) = b.version ' ||
                        'ORDER BY seq' ;

    OPEN L_RTST_DYN_CURSOR FOR L_RTST_SQL_STRING USING A_RT, A_RT_VERSION ;
    LOOP 
        FETCH L_RTST_DYN_CURSOR INTO L_RTST_REC ;
        EXIT WHEN L_RTST_DYN_CURSOR%NOTFOUND ;

      L_RTST_REC.ST_VERSION := UNAPIGEN.VALIDATEVERSION('st', L_RTST_REC.ST, L_RTST_REC.ST_VERSION);
      L_ASSIGN := FALSE;
      IF L_FILTER_FREQ = '0' THEN
         L_ASSIGN := TRUE;
      ELSIF L_FILTER_FREQ = '1' THEN
         L_ASSIGN := TRUE;
         IF L_RTST_REC.FREQ_TP = 'C' THEN
            
            
            
            
            L_SQL_STRING := 'BEGIN :l_ret_code := UNFREQ.'|| L_RTST_REC.FREQ_UNIT ||
                '(:a_rq, :a_rt, :a_rt_version, :a_st, :a_st_version, :a_freq_val, :a_invert_freq,:a_ref_date, ' ||
                ':a_last_sched, :a_last_cnt, :a_last_val); END;';

            L_DYN_CURSOR := DBMS_SQL.OPEN_CURSOR;

            DBMS_SQL.PARSE(L_DYN_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':l_ret_code', L_RET_CODE);
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_rq', A_RQ, 20);
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_rt', A_RT, 20);
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_rt_version', A_RT_VERSION, 20);
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_st', L_RTST_REC.ST, 20);
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_st_version', L_RTST_REC.ST_VERSION, 20);
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_freq_val', L_RTST_REC.FREQ_VAL);
            DBMS_SQL.BIND_VARIABLE_CHAR(L_DYN_CURSOR, ':a_invert_freq', L_RTST_REC.INVERT_FREQ, 1);
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_ref_date', L_REF_DATE);
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_last_sched', L_RTST_REC.LAST_SCHED);
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_last_cnt', L_RTST_REC.LAST_CNT);
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_last_val', L_RTST_REC.LAST_VAL, 40);

            L_RESULT := DBMS_SQL.EXECUTE(L_DYN_CURSOR);
            DBMS_SQL.VARIABLE_VALUE(L_DYN_CURSOR, ':l_ret_code', L_RET_CODE);
            DBMS_SQL.VARIABLE_VALUE(L_DYN_CURSOR, ':a_last_sched', L_RTST_REC.LAST_SCHED);
            DBMS_SQL.VARIABLE_VALUE(L_DYN_CURSOR, ':a_last_cnt', L_RTST_REC.LAST_CNT);
            DBMS_SQL.VARIABLE_VALUE(L_DYN_CURSOR, ':a_last_val', L_RTST_REC.LAST_VAL);
               
            DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
   
            IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
               L_ASSIGN := FALSE;
            END IF;
         ELSE
            IF NOT UNAPIAUT.EVALASSIGNMENTFREQ('rq', A_RQ, '',
                              'st', L_RTST_REC.ST, L_RTST_REC.ST_VERSION,
                                               L_RTST_REC.FREQ_TP,
                                               L_RTST_REC.FREQ_VAL,
                                               L_RTST_REC.FREQ_UNIT,
                                               L_RTST_REC.INVERT_FREQ,
                                               L_REF_DATE,
                                               L_RTST_REC.LAST_SCHED,
                                               L_RTST_REC.LAST_CNT,
                                               L_RTST_REC.LAST_VAL) THEN
               L_ASSIGN := FALSE;
            END IF;
         END IF;
         
         
         
         
         UPDATE UTRTSTBUFFER
         SET LAST_SCHED = L_RTST_REC.LAST_SCHED,
             LAST_SCHED_TZ =  DECODE(L_RTST_REC.LAST_SCHED, LAST_SCHED_TZ, LAST_SCHED_TZ, L_RTST_REC.LAST_SCHED),
             LAST_CNT = L_RTST_REC.LAST_CNT,
             LAST_VAL = L_RTST_REC.LAST_VAL,
             HANDLED = 'Y'
         WHERE RT = L_RTST_REC.RT
           AND VERSION = L_RTST_REC.VERSION
           AND ST = L_RTST_REC.ST
           AND SEQ = L_RTST_REC.SEQ;

      END IF;

      IF L_ASSIGN THEN
         
         
         
         ASSIGN(L_RTST_REC.ST, L_RTST_REC.ST_VERSION, L_RTST_REC.DELAY,
                L_RTST_REC.DELAY_UNIT, L_RTST_REC.INHERIT_AU,
                NVL(L_RTST_REC.NR_PLANNED_SC,0));
         L_TOT_NR_ROWS := L_TOT_NR_ROWS + 1;
      END IF;
   END LOOP;
   CLOSE L_RTST_DYN_CURSOR ;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   
   
   
   IF L_TOT_NR_ROWS > A_NR_OF_ROWS THEN
      INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
      VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
             'InitRqSamplingDetails','a_nr_of_rows (' || A_NR_OF_ROWS ||
             ') too small for required sample initialisation');
   END IF;

   A_NR_OF_ROWS := L_TOT_NR_ROWS;
   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('InitRqSamplingDetails', SQLERRM);
   END IF;
   IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
      DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
   END IF;
   IF L_RTST_DYN_CURSOR%ISOPEN THEN
      CLOSE L_RTST_DYN_CURSOR ;
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'InitRqSamplingDetails'));
END INITRQSAMPLINGDETAILS;

FUNCTION CREATERQSAMPLINGDETAILS                        
(A_RT               IN      VARCHAR2,                   
 A_RT_VERSION       IN OUT  VARCHAR2,                   
 A_RQ               IN      VARCHAR2,                   
 A_FILTER_FREQ      IN      CHAR,                       
 A_REF_DATE         IN      DATE,                       
 A_ADD_STPP         IN      CHAR,                       
 A_USERID           IN      VARCHAR2,                   
 A_FIELDTYPE_TAB    IN      UNAPIGEN.VC20_TABLE_TYPE,   
 A_FIELDNAMES_TAB   IN      UNAPIGEN.VC20_TABLE_TYPE,   
 A_FIELDVALUES_TAB  IN      UNAPIGEN.VC40_TABLE_TYPE,   
 A_NR_OF_ROWS       IN      NUMBER,
 A_MODIFY_REASON    IN      VARCHAR2)                   
RETURN NUMBER IS

L_SC                 VARCHAR2(20);
L_PPPP_TAB           UNAPIGEN.VC20_TABLE_TYPE;
L_PPPP_VERSION_TAB   UNAPIGEN.VC20_TABLE_TYPE;
L_PPPP_KEY1_TAB      UNAPIGEN.VC20_TABLE_TYPE;
L_PPPP_KEY2_TAB      UNAPIGEN.VC20_TABLE_TYPE;
L_PPPP_KEY3_TAB      UNAPIGEN.VC20_TABLE_TYPE;
L_PPPP_KEY4_TAB      UNAPIGEN.VC20_TABLE_TYPE;
L_PPPP_KEY5_TAB      UNAPIGEN.VC20_TABLE_TYPE;
L_PPDELAY_TAB        UNAPIGEN.NUM_TABLE_TYPE;
L_PPDELAY_UNIT_TAB   UNAPIGEN.VC20_TABLE_TYPE;
L_PPINHERIT_AU_TAB   UNAPIGEN.CHAR1_TABLE_TYPE;
L_PP_NR_OF_ROWS      INTEGER;
L_STST_TAB           UNAPIGEN.VC20_TABLE_TYPE;
L_STST_VERSION_TAB   UNAPIGEN.VC20_TABLE_TYPE;
L_STDELAY_TAB        UNAPIGEN.NUM_TABLE_TYPE;
L_STDELAY_UNIT_TAB   UNAPIGEN.VC20_TABLE_TYPE;
L_STINHERIT_AU_TAB   UNAPIGEN.CHAR1_TABLE_TYPE;
L_STNR_PLANNED_SC    UNAPIGEN.NUM_TABLE_TYPE;
L_ST_NR_OF_ROWS      INTEGER;

L_ROW                     INTEGER;
L_STROW                   INTEGER;
L_ERRM                    VARCHAR2(255);

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   A_RT_VERSION := UNAPIGEN.USEVERSION('rt', A_RT, A_RT_VERSION);
   
   
      
   L_RET_CODE := INITRQANALYSESDETAILS(A_RT, A_RT_VERSION, A_RQ, NULL, A_REF_DATE, 
                                       A_ADD_STPP, L_PPPP_TAB, L_PPPP_VERSION_TAB,
            L_PPPP_KEY1_TAB, L_PPPP_KEY2_TAB, L_PPPP_KEY3_TAB, L_PPPP_KEY4_TAB, L_PPPP_KEY5_TAB,
                                       L_PPDELAY_TAB, L_PPDELAY_UNIT_TAB,
                                       L_PPINHERIT_AU_TAB,
                                       L_PP_NR_OF_ROWS);
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      L_ERRM := 'rt=' || A_RT || '#rt_version='|| A_RT_VERSION || '#rq='|| A_RQ ||
                '#ref_date=NULL#filter_freq=NULL#'||
                '#InitRqAnalysesDetails#ErrorCode=' || TO_CHAR(L_RET_CODE);
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   
   
   
   L_RET_CODE := INITRQSAMPLINGDETAILS(A_RT, A_RT_VERSION, A_RQ, 
                                       NULL, A_REF_DATE, L_STST_TAB, L_STST_VERSION_TAB,
                                       L_STDELAY_TAB, L_STDELAY_UNIT_TAB,
                                       L_STINHERIT_AU_TAB, L_STNR_PLANNED_SC,
                                       L_ST_NR_OF_ROWS);
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      L_ERRM := 'rt=' || A_RT || '#rt_version='|| A_RT_VERSION || '#rq='|| A_RQ ||
                '#ref_date=NULL#filter_freq=NULL#'||
                '#InitRqSamplingDetails#ErrorCode=' || TO_CHAR(L_RET_CODE);
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   
   
   
   
   
   L_ERRM := '';
   FOR L_STROW IN 1..L_ST_NR_OF_ROWS LOOP
      FOR L_ROW IN 1..L_STNR_PLANNED_SC(L_STROW) LOOP

         L_SC := NULL;
         L_RET_CODE := UNAPIRQ2.CREATERQSAMPLE2(A_RT, A_RT_VERSION, A_RQ, L_STST_TAB(L_STROW), L_STST_VERSION_TAB(L_STROW), L_SC,
                                       A_REF_DATE, L_STDELAY_TAB(L_STROW), L_STDELAY_UNIT_TAB(L_STROW),
                                       '', NVL(A_USERID, UNAPIGEN.P_USER), 
                                       L_PPPP_TAB, L_PPPP_VERSION_TAB, L_PPPP_KEY1_TAB, L_PPPP_KEY2_TAB,
            L_PPPP_KEY3_TAB,L_PPPP_KEY4_TAB,L_PPPP_KEY5_TAB, L_PP_NR_OF_ROWS, 
                                       A_FIELDTYPE_TAB, A_FIELDNAMES_TAB, A_FIELDVALUES_TAB, A_NR_OF_ROWS,
                                       'Request creation');
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            L_ERRM := 'rt=' || A_RT || '#rt_version='|| A_RT_VERSION || '#rq='|| A_RQ ||
                '#st=' || L_STST_TAB(L_STROW) || '#st_version='|| L_STST_VERSION_TAB(L_STROW) ||
                '#sc=NULL#ref_date=NULL#create_ic=''''' ||
                '#nr_of_rows=' || L_PP_NR_OF_ROWS ||
                '#CreateRqSample#ErrorCode=' || TO_CHAR(L_RET_CODE);
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            RAISE STPERROR;
         END IF;
      END LOOP;
   END LOOP;
   
   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('CreateRqSampleDetails', SQLERRM);
   ELSIF L_ERRM IS NOT NULL THEN
      UNAPIGEN.LOGERROR('CreateRqSampleDetails', L_ERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'CreateRqSampleDetails'));
END CREATERQSAMPLINGDETAILS;




FUNCTION CREATERQSAMPLE
(A_RT               IN     VARCHAR2,                    
 A_RT_VERSION       IN OUT VARCHAR2,                    
 A_RQ               IN     VARCHAR2,                    
 A_ST               IN     VARCHAR2,                    
 A_ST_VERSION       IN OUT VARCHAR2,                    
 A_SC               IN OUT VARCHAR2,                    
 A_REF_DATE         IN     DATE,                        
 A_CREATE_IC        IN     VARCHAR2,                    
 A_USERID           IN     VARCHAR2,                    
 A_FIELDTYPE_TAB    IN     UNAPIGEN.VC20_TABLE_TYPE,    
 A_FIELDNAMES_TAB   IN     UNAPIGEN.VC20_TABLE_TYPE,    
 A_FIELDVALUES_TAB  IN     UNAPIGEN.VC40_TABLE_TYPE,    
 A_FIELDNR_OF_ROWS  IN     NUMBER,                      
 A_PP               IN     UNAPIGEN.VC20_TABLE_TYPE,    
 A_PP_VERSION       IN OUT UNAPIGEN.VC20_TABLE_TYPE,    
 A_PP_KEY1          IN     UNAPIGEN.VC20_TABLE_TYPE,    
 A_PP_KEY2          IN     UNAPIGEN.VC20_TABLE_TYPE,    
 A_PP_KEY3          IN     UNAPIGEN.VC20_TABLE_TYPE,    
 A_PP_KEY4          IN     UNAPIGEN.VC20_TABLE_TYPE,    
 A_PP_KEY5          IN     UNAPIGEN.VC20_TABLE_TYPE,    
 A_NR_OF_ROWS       IN     NUMBER,                      
 A_MODIFY_REASON    IN     VARCHAR2)                    
RETURN NUMBER IS




L_LC                   VARCHAR2(2);
L_LC_VERSION           VARCHAR2(20);
L_SS                   VARCHAR2(2);
L_LOG_HS               CHAR(1);
L_LOG_HS_DETAILS       CHAR(1);
L_ALLOW_MODIFY         CHAR(1);
L_ACTIVE               CHAR(1);
L_ROW                  INTEGER;
L_ERRM                 VARCHAR2(255);
L_EDIT_ALLOWED         CHAR(1);
L_VALID_CF             VARCHAR2(20);
L_ADD_STPP             CHAR(1);
L_CREATE_PG            VARCHAR2(40);
L_PGNODE               NUMBER(9);
L_RT_VERSION           VARCHAR2(20);
L_FIELDTYPE_TAB        UNAPIGEN.VC20_TABLE_TYPE;
L_FIELDNAMES_TAB       UNAPIGEN.VC20_TABLE_TYPE;
L_FIELDVALUES_TAB      UNAPIGEN.VC40_TABLE_TYPE;
L_FIELDNR_OF_ROWS      NUMBER;
L_RQ_IN_FIELDS         BOOLEAN;
L_RT_IN_FIELDS         BOOLEAN;
L_RT_VERSION_IN_FIELDS BOOLEAN;

CURSOR L_RT_CURSOR(A_RT VARCHAR2, A_RT_VERSION VARCHAR2) IS
   SELECT ADD_STPP
   FROM UTRT
   WHERE RT = A_RT
   AND VERSION = A_RT_VERSION;

CURSOR L_PGNODE_CURSOR (A_SC VARCHAR2, A_PG VARCHAR2) IS
   SELECT MAX(PGNODE)
   FROM UTSCPG 
   WHERE SC = A_SC
   AND PG = A_PG;

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_RQ, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   A_RT_VERSION := UNAPIGEN.USEVERSION('rt', A_RT, A_RT_VERSION);
   A_ST_VERSION := UNAPIGEN.USEVERSION('st', A_ST, A_ST_VERSION);

   
   
   
   
   
   
   UPDATE UTRQ
      SET SC_COUNTER = SC_COUNTER
    WHERE RQ = A_RQ;

   
   L_RQ_IN_FIELDS := FALSE;
   L_RT_IN_FIELDS := FALSE;
   L_RT_VERSION_IN_FIELDS := FALSE;   
   L_FIELDNR_OF_ROWS := A_FIELDNR_OF_ROWS;
   FOR L_ROW IN 1..A_FIELDNR_OF_ROWS LOOP
      L_FIELDTYPE_TAB(L_ROW) := A_FIELDTYPE_TAB(L_ROW);
      L_FIELDNAMES_TAB(L_ROW) := A_FIELDNAMES_TAB(L_ROW);
      L_FIELDVALUES_TAB(L_ROW) := A_FIELDVALUES_TAB(L_ROW);
      IF L_FIELDTYPE_TAB(L_ROW) = 'rq' AND L_FIELDNAMES_TAB(L_ROW) = 'rq' THEN
         L_RQ_IN_FIELDS := TRUE;
      END IF;
      IF L_FIELDTYPE_TAB(L_ROW) = 'rt' AND L_FIELDNAMES_TAB(L_ROW) = 'rt' THEN
         L_RT_IN_FIELDS := TRUE;
      END IF;
      IF L_FIELDTYPE_TAB(L_ROW) = 'rt' AND L_FIELDNAMES_TAB(L_ROW) = 'rt_version' THEN
         L_RT_VERSION_IN_FIELDS := TRUE;
      END IF;      
   END LOOP;
   IF NOT L_RQ_IN_FIELDS THEN
      L_FIELDNR_OF_ROWS := L_FIELDNR_OF_ROWS + 1;
      L_FIELDTYPE_TAB(L_FIELDNR_OF_ROWS) := 'rq';
      L_FIELDNAMES_TAB(L_FIELDNR_OF_ROWS) := 'rq';
      L_FIELDVALUES_TAB(L_FIELDNR_OF_ROWS) := A_RQ;
   END IF;
   IF NOT L_RT_IN_FIELDS THEN
      L_FIELDNR_OF_ROWS := L_FIELDNR_OF_ROWS + 1;
      L_FIELDTYPE_TAB(L_FIELDNR_OF_ROWS) := 'rt';
      L_FIELDNAMES_TAB(L_FIELDNR_OF_ROWS) := 'rt';
      L_FIELDVALUES_TAB(L_FIELDNR_OF_ROWS) := A_RT;
   END IF;
   IF NOT L_RT_VERSION_IN_FIELDS THEN
      L_FIELDNR_OF_ROWS := L_FIELDNR_OF_ROWS + 1;
      L_FIELDTYPE_TAB(L_FIELDNR_OF_ROWS) := 'rt';
      L_FIELDNAMES_TAB(L_FIELDNR_OF_ROWS) := 'rt_version';
      L_FIELDVALUES_TAB(L_FIELDNR_OF_ROWS) := A_RT_VERSION;
   END IF;

   
   
   
   
   IF NVL(A_SC, ' ') = ' ' THEN
      L_RET_CODE := UNAPIRQ.GENERATERQSAMPLECODE(A_RT, A_RT_VERSION, A_REF_DATE, A_RQ, A_ST, A_ST_VERSION,
                                                 L_FIELDTYPE_TAB, L_FIELDNAMES_TAB, L_FIELDVALUES_TAB, L_FIELDNR_OF_ROWS,
                                                 A_SC, L_EDIT_ALLOWED, L_VALID_CF);

      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         L_ERRM := 'rt=' || A_RT || 
                   '#rt_version=' || A_RT_VERSION || 
                   '#rq='|| A_RQ ||
                   '#st='|| A_ST || 
                   '#st_version=' || A_ST_VERSION || 
                   '#ref_date=' || A_REF_DATE || 
                   '#GenerateRqSampleCode#ErrorCode=' || TO_CHAR(L_RET_CODE);
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
         RAISE STPERROR;
      END IF;
   END IF;

   L_RT_VERSION := A_RT_VERSION;
   L_RET_CODE := UNAPIAUT.GETRQAUTHORISATION(A_RQ, L_RT_VERSION, L_LC, L_LC_VERSION, L_SS,
                                             L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS, L_LOG_HS_DETAILS);
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS  THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   
   
   
   
   OPEN L_RT_CURSOR (A_RT, A_RT_VERSION);
   FETCH L_RT_CURSOR
   INTO L_ADD_STPP;
   IF L_RT_CURSOR%NOTFOUND THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      RAISE STPERROR;
   END IF;
   CLOSE L_RT_CURSOR;
   IF L_ADD_STPP = '1' THEN
      L_CREATE_PG := 'ON SAMPLE CREATION';
   ELSE
      L_CREATE_PG := 'NO';
   END IF;
         
   
   L_RET_CODE := UNAPISC.CREATESAMPLE2(A_ST, A_ST_VERSION, A_SC, A_REF_DATE, 0, 'DD', A_CREATE_IC,
                                      L_CREATE_PG, NVL(A_USERID, UNAPIGEN.P_USER), 
                                      L_FIELDTYPE_TAB, L_FIELDNAMES_TAB, L_FIELDVALUES_TAB, L_FIELDNR_OF_ROWS,
                                      A_MODIFY_REASON);
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      L_ERRM := 'st=' || A_ST ||
                '#st_version=' || A_ST_VERSION || 
                '#sc=' || A_SC ||
                '#ref_date=' || A_REF_DATE || 
                '#create_ic=' || A_CREATE_IC ||
                '#create_pg=' || L_CREATE_PG || 
                '#CreateSample#ErrorCode=' || TO_CHAR(L_RET_CODE);
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;
   
   
   
   
   
   FOR L_ROW IN 1..A_NR_OF_ROWS LOOP
      L_RET_CODE := UNAPISC.ADDSCANALYSESDETAILS(A_SC, A_ST, A_ST_VERSION, A_PP(L_ROW), A_PP_VERSION(L_ROW),
                            A_PP_KEY1(L_ROW), A_PP_KEY2(L_ROW),A_PP_KEY3(L_ROW),A_PP_KEY4(L_ROW),A_PP_KEY5(L_ROW), -1, NULL); 
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
         RAISE STPERROR;
      END IF;

      
      
      
      
      
      L_PGNODE := NULL;
      OPEN L_PGNODE_CURSOR (A_SC, A_PP(L_ROW));
      FETCH L_PGNODE_CURSOR
      INTO L_PGNODE;
      IF L_PGNODE_CURSOR%NOTFOUND THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
         RAISE STPERROR;
      END IF;
      CLOSE L_PGNODE_CURSOR;

      DELETE FROM UTSCPGAU
      WHERE SC=A_SC
      AND PG=A_PP(L_ROW)
      AND PGNODE = L_PGNODE;
      
      
      
      
      
      
      INSERT INTO UTSCPGAU(SC, PG, PGNODE, AU, AU_VERSION, AUSEQ, VALUE)
      SELECT A_SC, A_PP(L_ROW), L_PGNODE, A.AU, '' D_VERSION, A.AUSEQ, A.VALUE
      FROM UTPPAU A, UTPP B, UTRTPP C, UTAU D
      WHERE A.PP = A_PP(L_ROW)
        AND A.VERSION = A_PP_VERSION(L_ROW)
        AND A.PP_KEY1 = A_PP_KEY1(L_ROW)
        AND A.PP_KEY2 = A_PP_KEY2(L_ROW)
        AND A.PP_KEY3 = A_PP_KEY3(L_ROW)
        AND A.PP_KEY4 = A_PP_KEY4(L_ROW)
        AND A.PP_KEY5 = A_PP_KEY5(L_ROW)
        AND A.PP = B.PP
        AND A.VERSION = B.VERSION
        AND A.PP_KEY1 = B.PP_KEY1
        AND A.PP_KEY2 = B.PP_KEY2
        AND A.PP_KEY3 = B.PP_KEY3
        AND A.PP_KEY4 = B.PP_KEY4
        AND A.PP_KEY5 = B.PP_KEY5
        AND A.AU = D.AU
        AND UNAPIGEN.VALIDATEVERSION('au', A.AU, A.AU_VERSION) = D.VERSION     
        AND C.RT = A_RT
        AND C.VERSION = A_RT_VERSION     
        AND C.PP = B.PP
        AND C.PP_KEY1 = B.PP_KEY1
        AND C.PP_KEY2 = B.PP_KEY2
        AND C.PP_KEY3 = B.PP_KEY3
        AND C.PP_KEY4 = B.PP_KEY4
        AND C.PP_KEY5 = B.PP_KEY5
        AND UNAPIGEN.USEPPVERSION(C.PP, C.PP_VERSION, C.PP_KEY1, C.PP_KEY2, C.PP_KEY3, C.PP_KEY4, C.PP_KEY5) = B.VERSION     
        AND DECODE(D.INHERIT_AU,'0',DECODE(C.INHERIT_AU,'2',B.INHERIT_AU,C.INHERIT_AU),D.INHERIT_AU) = '1'
        AND A.AU NOT IN (SELECT DISTINCT J.AU
                         FROM UTRTPPAU J, UTRTPP K, UTPP L, UTAU M
                         WHERE J.PP = L.PP
                           AND UNAPIGEN.USEPPVERSION(J.PP, J.PP_VERSION, J.PP_KEY1, J.PP_KEY2, J.PP_KEY3, J.PP_KEY4, J.PP_KEY5) = L.VERSION                      
                           AND J.PP_KEY1 = L.PP_KEY1
                           AND J.PP_KEY2 = L.PP_KEY2
                           AND J.PP_KEY3 = L.PP_KEY3
                           AND J.PP_KEY4 = L.PP_KEY4
                           AND J.PP_KEY5 = L.PP_KEY5
                           AND J.RT = A_RT
                           AND J.VERSION = A_RT_VERSION                        
                           AND J.PP = A_PP(L_ROW)
                           AND UNAPIGEN.USEPPVERSION(J.PP, J.PP_VERSION, J.PP_KEY1, J.PP_KEY2, J.PP_KEY3, J.PP_KEY4, J.PP_KEY5) = A_PP_VERSION(L_ROW)
                           AND J.PP = K.PP
                           AND UNAPIGEN.USEPPVERSION(J.PP, J.PP_VERSION, J.PP_KEY1, J.PP_KEY2, J.PP_KEY3, J.PP_KEY4, J.PP_KEY5) = UNAPIGEN.USEPPVERSION(K.PP, K.PP_VERSION, K.PP_KEY1, K.PP_KEY2, K.PP_KEY3, K.PP_KEY4, K.PP_KEY5)                                                
                           AND J.PP_KEY1 = K.PP_KEY1
                           AND J.PP_KEY2 = K.PP_KEY2
                           AND J.PP_KEY3 = K.PP_KEY3
                           AND J.PP_KEY4 = K.PP_KEY4
                           AND J.PP_KEY5 = K.PP_KEY5
                           AND J.RT = K.RT
                           AND J.VERSION = K.VERSION                        
                           AND DECODE(M.INHERIT_AU,'0',DECODE(K.INHERIT_AU,'2',L.INHERIT_AU,K.INHERIT_AU),M.INHERIT_AU) = '1'
                           AND M.AU = J.AU
                           AND M.VERSION = UNAPIGEN.VALIDATEVERSION('au', J.AU, J.AU_VERSION))
      
      
      
      
      UNION
      SELECT A_SC, A_PP(L_ROW), L_PGNODE, V.AU, '' Y_VERSION, V.AUSEQ+500, V.VALUE
      FROM UTRTPPAU V, UTRTPP W, UTPP X, UTAU Y
      WHERE V.PP = X.PP
        AND UNAPIGEN.USEPPVERSION(V.PP, V.PP_VERSION, V.PP_KEY1, V.PP_KEY2, V.PP_KEY3, V.PP_KEY4, V.PP_KEY5) = X.VERSION
        AND V.PP_KEY1 = X.PP_KEY1
        AND V.PP_KEY2 = X.PP_KEY2
        AND V.PP_KEY3 = X.PP_KEY3
        AND V.PP_KEY4 = X.PP_KEY4
        AND V.PP_KEY5 = X.PP_KEY5
        AND V.RT = A_RT
        AND V.VERSION = A_RT_VERSION
        AND V.PP = A_PP(L_ROW)
        AND UNAPIGEN.USEPPVERSION( V.PP, V.PP_VERSION, V.PP_KEY1, V.PP_KEY2, V.PP_KEY3, V.PP_KEY4, V.PP_KEY5) = A_PP_VERSION(L_ROW)
        AND V.PP_KEY1 = A_PP_KEY1(L_ROW)
        AND V.PP_KEY2 = A_PP_KEY2(L_ROW)
        AND V.PP_KEY3 = A_PP_KEY3(L_ROW)
        AND V.PP_KEY4 = A_PP_KEY4(L_ROW)
        AND V.PP_KEY5 = A_PP_KEY5(L_ROW)
        AND V.RT = W.RT
        AND V.VERSION = W.VERSION
        AND V.PP = W.PP
        AND UNAPIGEN.USEPPVERSION(V.PP, V.PP_VERSION, V.PP_KEY1, V.PP_KEY2, V.PP_KEY3, V.PP_KEY4, V.PP_KEY5) = UNAPIGEN.USEPPVERSION(W.PP, W.PP_VERSION, W.PP_KEY1, W.PP_KEY2, W.PP_KEY3, W.PP_KEY4, W.PP_KEY5)     
        AND V.PP_KEY1 = W.PP_KEY1
        AND V.PP_KEY2 = W.PP_KEY2
        AND V.PP_KEY3 = W.PP_KEY3
        AND V.PP_KEY4 = W.PP_KEY4
        AND V.PP_KEY5 = W.PP_KEY5
        AND DECODE(Y.INHERIT_AU,'0',DECODE(W.INHERIT_AU,'2',X.INHERIT_AU,W.INHERIT_AU),Y.INHERIT_AU) = '1' 
        AND V.AU = Y.AU
        AND UNAPIGEN.VALIDATEVERSION('au', V.AU, V.AU_VERSION) = Y.VERSION;
   END LOOP;

   
   
   
   
   INSERT INTO UTRQSC (RQ, SC, SEQ, ASSIGN_DATE, ASSIGN_DATE_TZ, ASSIGNED_BY)
   SELECT A_RQ, A_SC, NVL(MAX(SEQ),0)+1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, NVL(A_USERID, UNAPIGEN.P_USER)
   FROM UTRQSC
   WHERE RQ = A_RQ;
   
   UPDATE UTSC 
   SET RQ = A_RQ
   WHERE SC = A_SC;
   
   
   
   
   L_RET_CODE := UNAPISC.UPDATELINKEDSCII(A_SC, 'rq', '1', '', '', '',
                                          '', '', '',
                                          '', '', '',
                                          '', '', '',
                                          '', '', A_RQ,  '',
                                          '', '', '', '', '',
                                          '', '');
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

























         
   
   UPDATE UTRQ
      SET SC_COUNTER = (SELECT COUNT(*) FROM UTRQSC WHERE RQ = A_RQ)
    WHERE RQ = A_RQ;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('CreateRqSample', SQLERRM);
   ELSIF L_ERRM IS NOT NULL THEN
      UNAPIGEN.LOGERROR('CreateRqSample', L_ERRM);
   END IF;
   IF L_RT_CURSOR%ISOPEN THEN
      CLOSE L_RT_CURSOR;
   END IF;
   IF L_PGNODE_CURSOR%ISOPEN THEN
      CLOSE L_PGNODE_CURSOR;
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'CreateRqSample'));
END CREATERQSAMPLE;

FUNCTION CREATERQSAMPLE2                                
(A_RT               IN     VARCHAR2,                    
 A_RT_VERSION       IN OUT VARCHAR2,                    
 A_RQ               IN     VARCHAR2,                    
 A_ST               IN     VARCHAR2,                    
 A_ST_VERSION       IN OUT VARCHAR2,                    
 A_SC               IN OUT VARCHAR2,                    
 A_REF_DATE         IN     DATE,                        
 A_DELAY            IN     NUMBER,                      
 A_DELAY_UNIT       IN     VARCHAR2,                    
 A_CREATE_IC        IN     VARCHAR2,                    
 A_USERID           IN     VARCHAR2,                    
 A_PP               IN     UNAPIGEN.VC20_TABLE_TYPE,    
 A_PP_VERSION       IN OUT UNAPIGEN.VC20_TABLE_TYPE,    
 A_PP_KEY1          IN     UNAPIGEN.VC20_TABLE_TYPE,    
 A_PP_KEY2          IN     UNAPIGEN.VC20_TABLE_TYPE,    
 A_PP_KEY3          IN     UNAPIGEN.VC20_TABLE_TYPE,    
 A_PP_KEY4          IN     UNAPIGEN.VC20_TABLE_TYPE,    
 A_PP_KEY5          IN     UNAPIGEN.VC20_TABLE_TYPE,    
 A_NR_OF_ROWS       IN     NUMBER,                      
 A_FIELDTYPE_TAB    IN     UNAPIGEN.VC20_TABLE_TYPE,    
 A_FIELDNAMES_TAB   IN     UNAPIGEN.VC20_TABLE_TYPE,    
 A_FIELDVALUES_TAB  IN     UNAPIGEN.VC40_TABLE_TYPE,    
 A_FIELDNR_OF_ROWS  IN     NUMBER,                      
 A_MODIFY_REASON    IN     VARCHAR2)                    
RETURN NUMBER IS




L_LC                   VARCHAR2(2);
L_LC_VERSION           VARCHAR2(20);
L_SS                   VARCHAR2(2);
L_LOG_HS               CHAR(1);
L_LOG_HS_DETAILS       CHAR(1);
L_ALLOW_MODIFY         CHAR(1);
L_ACTIVE               CHAR(1);
L_ROW                  INTEGER;
L_ERRM                 VARCHAR2(255);
L_EDIT_ALLOWED         CHAR(1);
L_VALID_CF             VARCHAR2(20);
L_ADD_STPP             CHAR(1);
L_CREATE_PG            VARCHAR2(40);
L_PGNODE               NUMBER(9);
L_RT_VERSION           VARCHAR2(20);
L_FIELDTYPE_TAB        UNAPIGEN.VC20_TABLE_TYPE;
L_FIELDNAMES_TAB       UNAPIGEN.VC20_TABLE_TYPE;
L_FIELDVALUES_TAB      UNAPIGEN.VC40_TABLE_TYPE;
L_FIELDNR_OF_ROWS      NUMBER;
L_RQ_IN_FIELDS         BOOLEAN;
L_RT_IN_FIELDS         BOOLEAN;
L_RT_VERSION_IN_FIELDS BOOLEAN;

CURSOR L_RT_CURSOR(A_RT VARCHAR2, A_RT_VERSION VARCHAR2) IS
   SELECT ADD_STPP
   FROM UTRT
   WHERE RT = A_RT
   AND VERSION = A_RT_VERSION;

CURSOR L_PGNODE_CURSOR (A_SC VARCHAR2, A_PG VARCHAR2) IS
   SELECT MAX(PGNODE)
   FROM UTSCPG 
   WHERE SC = A_SC
   AND PG = A_PG;

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_RQ, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   A_RT_VERSION := UNAPIGEN.USEVERSION('rt', A_RT, A_RT_VERSION);
   A_ST_VERSION := UNAPIGEN.USEVERSION('st', A_ST, A_ST_VERSION);

   
   
   
   
   
   
   UPDATE UTRQ
      SET SC_COUNTER = SC_COUNTER
    WHERE RQ = A_RQ;

   
   L_RQ_IN_FIELDS := FALSE;
   L_RT_IN_FIELDS := FALSE;
   L_RT_VERSION_IN_FIELDS := FALSE;   
   L_FIELDNR_OF_ROWS := A_FIELDNR_OF_ROWS;
   FOR L_ROW IN 1..A_FIELDNR_OF_ROWS LOOP
      L_FIELDTYPE_TAB(L_ROW) := A_FIELDTYPE_TAB(L_ROW);
      L_FIELDNAMES_TAB(L_ROW) := A_FIELDNAMES_TAB(L_ROW);
      L_FIELDVALUES_TAB(L_ROW) := A_FIELDVALUES_TAB(L_ROW);
      IF L_FIELDTYPE_TAB(L_ROW) = 'rq' AND L_FIELDNAMES_TAB(L_ROW) = 'rq' THEN
         L_RQ_IN_FIELDS := TRUE;
      END IF;
      IF L_FIELDTYPE_TAB(L_ROW) = 'rt' AND L_FIELDNAMES_TAB(L_ROW) = 'rt' THEN
         L_RT_IN_FIELDS := TRUE;
      END IF;
      IF L_FIELDTYPE_TAB(L_ROW) = 'rt' AND L_FIELDNAMES_TAB(L_ROW) = 'rt_version' THEN
         L_RT_VERSION_IN_FIELDS := TRUE;
      END IF;      
   END LOOP;
   IF NOT L_RQ_IN_FIELDS THEN
      L_FIELDNR_OF_ROWS := L_FIELDNR_OF_ROWS + 1;
      L_FIELDTYPE_TAB(L_FIELDNR_OF_ROWS) := 'rq';
      L_FIELDNAMES_TAB(L_FIELDNR_OF_ROWS) := 'rq';
      L_FIELDVALUES_TAB(L_FIELDNR_OF_ROWS) := A_RQ;
   END IF;
   IF NOT L_RT_IN_FIELDS THEN
      L_FIELDNR_OF_ROWS := L_FIELDNR_OF_ROWS + 1;
      L_FIELDTYPE_TAB(L_FIELDNR_OF_ROWS) := 'rt';
      L_FIELDNAMES_TAB(L_FIELDNR_OF_ROWS) := 'rt';
      L_FIELDVALUES_TAB(L_FIELDNR_OF_ROWS) := A_RT;
   END IF;
   IF NOT L_RT_VERSION_IN_FIELDS THEN
      L_FIELDNR_OF_ROWS := L_FIELDNR_OF_ROWS + 1;
      L_FIELDTYPE_TAB(L_FIELDNR_OF_ROWS) := 'rt';
      L_FIELDNAMES_TAB(L_FIELDNR_OF_ROWS) := 'rt_version';
      L_FIELDVALUES_TAB(L_FIELDNR_OF_ROWS) := A_RT_VERSION;
   END IF;

   
   
   
      
   IF NVL(A_SC, ' ') = ' ' THEN
      L_RET_CODE := UNAPIRQ.GENERATERQSAMPLECODE(A_RT, A_RT_VERSION, A_REF_DATE, A_RQ, A_ST, A_ST_VERSION,
                                                 L_FIELDTYPE_TAB, L_FIELDNAMES_TAB, L_FIELDVALUES_TAB, L_FIELDNR_OF_ROWS,
                                                 A_SC, L_EDIT_ALLOWED, L_VALID_CF);

      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         L_ERRM := 'rt=' || A_RT || 
                   '#rt_version=' || A_RT_VERSION || 
                   '#rq='|| A_RQ ||
                   '#st='|| A_ST || 
                   '#st_version=' || A_ST_VERSION || 
                   '#ref_date='|| A_REF_DATE || 
                   '#GenerateRqSampleCode#ErrorCode=' || TO_CHAR(L_RET_CODE);
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
         RAISE STPERROR;
      END IF;
   END IF;

   L_RT_VERSION := A_RT_VERSION;
   L_RET_CODE := UNAPIAUT.GETRQAUTHORISATION(A_RQ, L_RT_VERSION, L_LC, L_LC_VERSION, L_SS,
                                             L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS, L_LOG_HS_DETAILS);
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS  THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   
   
   
   
   OPEN L_RT_CURSOR (A_RT, A_RT_VERSION);
   FETCH L_RT_CURSOR
   INTO L_ADD_STPP;
   IF L_RT_CURSOR%NOTFOUND THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      RAISE STPERROR;
   END IF;
   CLOSE L_RT_CURSOR;
   IF L_ADD_STPP = '1' THEN
      L_CREATE_PG := 'ON SAMPLE CREATION';
   ELSE
      L_CREATE_PG := 'NO';
   END IF;
   L_RET_CODE := UNAPISC.CREATESAMPLE2(A_ST, A_ST_VERSION, A_SC, A_REF_DATE, A_DELAY, A_DELAY_UNIT,
                                       A_CREATE_IC, L_CREATE_PG, NVL(A_USERID, UNAPIGEN.P_USER),
                                       L_FIELDTYPE_TAB, L_FIELDNAMES_TAB, L_FIELDVALUES_TAB, L_FIELDNR_OF_ROWS,
                                       A_MODIFY_REASON);
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      L_ERRM := 'st=' || A_ST || 
                '#st_version=' || A_ST_VERSION || 
                '#sc=' || A_SC ||
                '#ref_date=' || A_REF_DATE || 
                '#create_ic=' || A_CREATE_IC ||
                '#create_pg=' || L_CREATE_PG || 
                '#CreateSample#ErrorCode=' || TO_CHAR(L_RET_CODE);
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;
      
   
   
   
   
   FOR L_ROW IN 1..A_NR_OF_ROWS LOOP
      L_RET_CODE := UNAPISC.ADDSCANALYSESDETAILS(A_SC, A_ST, A_ST_VERSION, A_PP(L_ROW), A_PP_VERSION(L_ROW),
                       A_PP_KEY1(L_ROW), A_PP_KEY2(L_ROW),A_PP_KEY3(L_ROW),A_PP_KEY4(L_ROW),A_PP_KEY5(L_ROW), -1, ''); 
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
         RAISE STPERROR;
      END IF;

      
      
      
      
      
      L_PGNODE := NULL;
      OPEN L_PGNODE_CURSOR (A_SC, A_PP(L_ROW));
      FETCH L_PGNODE_CURSOR
      INTO L_PGNODE;
      IF L_PGNODE_CURSOR%NOTFOUND THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
         RAISE STPERROR;
      END IF;
      CLOSE L_PGNODE_CURSOR;

      DELETE FROM UTSCPGAU
      WHERE SC=A_SC
      AND PG=A_PP(L_ROW)
      AND PGNODE = L_PGNODE;
      
      
      
      
      
      
      INSERT INTO UTSCPGAU(SC, PG, PGNODE, AU, AU_VERSION, AUSEQ, VALUE)
      SELECT A_SC, A_PP(L_ROW), L_PGNODE, A.AU, '' D_VERSION, A.AUSEQ, A.VALUE
      FROM UTPPAU A, UTPP B, UTRTPP C, UTAU D
      WHERE A.PP = A_PP(L_ROW)
        AND A.VERSION = A_PP_VERSION(L_ROW)
        AND A.PP_KEY1 = A_PP_KEY1(L_ROW)
        AND A.PP_KEY2 = A_PP_KEY2(L_ROW)
        AND A.PP_KEY3 = A_PP_KEY3(L_ROW)
        AND A.PP_KEY4 = A_PP_KEY4(L_ROW)
        AND A.PP_KEY5 = A_PP_KEY5(L_ROW)
        AND A.PP = B.PP
        AND A.VERSION = B.VERSION
        AND A.PP_KEY1 = B.PP_KEY1
        AND A.PP_KEY2 = B.PP_KEY2
        AND A.PP_KEY3 = B.PP_KEY3
        AND A.PP_KEY4 = B.PP_KEY4
        AND A.PP_KEY5 = B.PP_KEY5
        AND A.AU = D.AU
        AND UNAPIGEN.VALIDATEVERSION('au', A.AU, A.AU_VERSION) = D.VERSION     
        AND C.RT = A_RT
        AND C.VERSION = A_RT_VERSION     
        AND C.PP = B.PP
        AND C.PP_KEY1 = B.PP_KEY1
        AND C.PP_KEY2 = B.PP_KEY2
        AND C.PP_KEY3 = B.PP_KEY3
        AND C.PP_KEY4 = B.PP_KEY4
        AND C.PP_KEY5 = B.PP_KEY5
        AND UNAPIGEN.USEPPVERSION(C.PP, C.PP_VERSION, C.PP_KEY1, C.PP_KEY2, C.PP_KEY3, C.PP_KEY4, C.PP_KEY5) = B.VERSION     
        AND DECODE(D.INHERIT_AU,'0',DECODE(C.INHERIT_AU,'2',B.INHERIT_AU,C.INHERIT_AU),D.INHERIT_AU) = '1'
        AND A.AU NOT IN (SELECT DISTINCT J.AU
                         FROM UTRTPPAU J, UTRTPP K, UTPP L, UTAU M
                         WHERE J.PP = L.PP
                           AND UNAPIGEN.USEPPVERSION(J.PP, J.PP_VERSION, J.PP_KEY1, J.PP_KEY2, J.PP_KEY3, J.PP_KEY4,J.PP_KEY5) = L.VERSION                      
                           AND J.PP_KEY1 = L.PP_KEY1
                           AND J.PP_KEY2 = L.PP_KEY2
                           AND J.PP_KEY3 = L.PP_KEY3
                           AND J.PP_KEY4 = L.PP_KEY4
                           AND J.PP_KEY5 = L.PP_KEY5
                           AND J.RT = A_RT
                           AND J.VERSION = A_RT_VERSION                        
                           AND J.PP = A_PP(L_ROW)
                           AND UNAPIGEN.USEPPVERSION(J.PP, J.PP_VERSION, J.PP_KEY1, J.PP_KEY2, J.PP_KEY3, J.PP_KEY4,J.PP_KEY5) = A_PP_VERSION(L_ROW)
                           AND J.PP = K.PP
                           AND UNAPIGEN.USEPPVERSION(J.PP, J.PP_VERSION, J.PP_KEY1, J.PP_KEY2, J.PP_KEY3, J.PP_KEY4, J.PP_KEY5) = UNAPIGEN.USEPPVERSION(K.PP, K.PP_VERSION, K.PP_KEY1, K.PP_KEY2, K.PP_KEY3, K.PP_KEY4, K.PP_KEY5)                                                
                           AND J.PP_KEY1 = K.PP_KEY1
                           AND J.PP_KEY2 = K.PP_KEY2
                           AND J.PP_KEY3 = K.PP_KEY3
                           AND J.PP_KEY4 = K.PP_KEY4
                           AND J.PP_KEY5 = K.PP_KEY5
                           AND J.RT = K.RT
                           AND J.VERSION = K.VERSION                        
                           AND DECODE(M.INHERIT_AU,'0',DECODE(K.INHERIT_AU,'2',L.INHERIT_AU,K.INHERIT_AU),M.INHERIT_AU) = '1'
                           AND M.AU = J.AU
                           AND M.VERSION = UNAPIGEN.VALIDATEVERSION('au', J.AU, J.AU_VERSION))
      
      
      
      
      UNION
      SELECT A_SC, A_PP(L_ROW), L_PGNODE, V.AU, '' Y_VERSION, V.AUSEQ+500, V.VALUE
      FROM UTRTPPAU V, UTRTPP W, UTPP X, UTAU Y
      WHERE V.PP = X.PP
        AND UNAPIGEN.USEPPVERSION(V.PP, V.PP_VERSION, V.PP_KEY1, V.PP_KEY2,V.PP_KEY3, V.PP_KEY4,V.PP_KEY5) = X.VERSION
        AND V.PP_KEY1 = X.PP_KEY1
        AND V.PP_KEY2 = X.PP_KEY2
        AND V.PP_KEY3 = X.PP_KEY3
        AND V.PP_KEY4 = X.PP_KEY4
        AND V.PP_KEY5 = X.PP_KEY5
        AND V.RT = A_RT
        AND V.VERSION = A_RT_VERSION
        AND V.PP = A_PP(L_ROW)
        AND UNAPIGEN.USEPPVERSION( V.PP, V.PP_VERSION, V.PP_KEY1, V.PP_KEY2,V.PP_KEY3, V.PP_KEY4,V.PP_KEY5) = A_PP_VERSION(L_ROW)
        AND V.PP_KEY1 = A_PP_KEY1(L_ROW)
        AND V.PP_KEY2 = A_PP_KEY2(L_ROW)
        AND V.PP_KEY3 = A_PP_KEY3(L_ROW)
        AND V.PP_KEY4 = A_PP_KEY4(L_ROW)
        AND V.PP_KEY5 = A_PP_KEY5(L_ROW)
        AND V.RT = W.RT
        AND V.VERSION = W.VERSION
        AND V.PP = W.PP
        AND UNAPIGEN.USEPPVERSION(V.PP, V.PP_VERSION, V.PP_KEY1, V.PP_KEY2,V.PP_KEY3, V.PP_KEY4,V.PP_KEY5) = UNAPIGEN.USEPPVERSION( W.PP, W.PP_VERSION, W.PP_KEY1, W.PP_KEY2,W.PP_KEY3, W.PP_KEY4,W.PP_KEY5)     
        AND V.PP_KEY1 = W.PP_KEY1
        AND V.PP_KEY2 = W.PP_KEY2
        AND V.PP_KEY3 = W.PP_KEY3
        AND V.PP_KEY4 = W.PP_KEY4
        AND V.PP_KEY5 = W.PP_KEY5
        AND DECODE(Y.INHERIT_AU,'0',DECODE(W.INHERIT_AU,'2',X.INHERIT_AU,W.INHERIT_AU),Y.INHERIT_AU) = '1' 
        AND V.AU = Y.AU
        AND UNAPIGEN.VALIDATEVERSION('au', V.AU, V.AU_VERSION) = Y.VERSION;
   END LOOP;

   
   
   
   
   INSERT INTO UTRQSC (RQ, SC, SEQ, ASSIGN_DATE, ASSIGN_DATE_TZ, ASSIGNED_BY)
   SELECT A_RQ, A_SC, NVL(MAX(SEQ),0)+1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, NVL(A_USERID, UNAPIGEN.P_USER)
   FROM UTRQSC
   WHERE RQ = A_RQ;
   
   UPDATE UTSC 
   SET RQ = A_RQ
   WHERE SC = A_SC;
   
   
   
   
   L_RET_CODE := UNAPISC.UPDATELINKEDSCII(A_SC, 'rq', '1', '', '', '',
                                          '', '', '',
                                          '', '', '',
                                          '', '', '',
                                          '', '', A_RQ, '',
                                          '', '', '', '', '',
                                          '', '');
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;
   
























         
   
   UPDATE UTRQ
      SET SC_COUNTER = (SELECT COUNT(*) FROM UTRQSC WHERE RQ = A_RQ)
    WHERE RQ = A_RQ;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('CreateRqSample', SQLERRM);
   ELSIF L_ERRM IS NOT NULL THEN
      UNAPIGEN.LOGERROR('CreateRqSample', L_ERRM);
   END IF;
   IF L_RT_CURSOR%ISOPEN THEN
      CLOSE L_RT_CURSOR;
   END IF;
   IF L_PGNODE_CURSOR%ISOPEN THEN
      CLOSE L_PGNODE_CURSOR;
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'CreateRqSample'));
END CREATERQSAMPLE2;

FUNCTION GETRQSAMPLE                                    
(A_RQ               OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_SC               OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_ST               OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_ST_VERSION       OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_DESCRIPTION      OUT    UNAPIGEN.VC40_TABLE_TYPE,    
 A_ASSIGN_DATE      OUT    UNAPIGEN.DATE_TABLE_TYPE,    
 A_ASSIGNED_BY      OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_NR_OF_ROWS       IN OUT NUMBER,                      
 A_WHERE_CLAUSE     IN     VARCHAR2)                    
RETURN NUMBER IS

L_RQ             VARCHAR2(20);
L_SC             VARCHAR2(20);
L_ST             VARCHAR2(20);
L_ST_VERSION     VARCHAR2(20);
L_DESCRIPTION    VARCHAR2(40);
L_ASSIGN_DATE    TIMESTAMP WITH TIME ZONE;
L_ASSIGNED_BY    VARCHAR2(20);
L_SC_CURSOR      INTEGER;

BEGIN

   IF NVL(A_NR_OF_ROWS,0) = 0 THEN
      A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
   ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
      RETURN(UNAPIGEN.DBERR_NROFROWS);
   END IF;

   IF NVL(A_WHERE_CLAUSE, ' ') = ' ' THEN
       RETURN(UNAPIGEN.DBERR_WHERECLAUSE);
   ELSIF
     UPPER(SUBSTR(A_WHERE_CLAUSE,1,6)) <> 'WHERE ' THEN
     L_WHERE_CLAUSE := 'WHERE rq = ''' || REPLACE(A_WHERE_CLAUSE, '''', '''''') || 
                       ''' ORDER BY seq';
   ELSE
      L_WHERE_CLAUSE := A_WHERE_CLAUSE; 
   END IF;

   L_SC_CURSOR := DBMS_SQL.OPEN_CURSOR;
   L_SQL_STRING := 'SELECT rq, sc, assign_date, assigned_by ' ||
                   'FROM dd' || UNAPIGEN.P_DD || '.uvrqsc ' || L_WHERE_CLAUSE;

   DBMS_SQL.PARSE(L_SC_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 

   DBMS_SQL.DEFINE_COLUMN(L_SC_CURSOR, 1, L_RQ, 20);
   DBMS_SQL.DEFINE_COLUMN(L_SC_CURSOR, 2, L_SC, 20);
   DBMS_SQL.DEFINE_COLUMN(L_SC_CURSOR, 3, L_ASSIGN_DATE);
   DBMS_SQL.DEFINE_COLUMN(L_SC_CURSOR, 4, L_ASSIGNED_BY, 20);
   L_RESULT := DBMS_SQL.EXECUTE_AND_FETCH(L_SC_CURSOR);
   L_FETCHED_ROWS := 0;

   LOOP

      EXIT WHEN L_RESULT = 0 OR L_FETCHED_ROWS >= A_NR_OF_ROWS;

      DBMS_SQL.COLUMN_VALUE(L_SC_CURSOR, 1, L_RQ);
      DBMS_SQL.COLUMN_VALUE(L_SC_CURSOR, 2, L_SC);
      DBMS_SQL.COLUMN_VALUE(L_SC_CURSOR, 3, L_ASSIGN_DATE);
      DBMS_SQL.COLUMN_VALUE(L_SC_CURSOR, 4, L_ASSIGNED_BY);

      L_FETCHED_ROWS := L_FETCHED_ROWS + 1;
      A_RQ(L_FETCHED_ROWS) := L_RQ;
      A_SC(L_FETCHED_ROWS) := L_SC;
      A_ASSIGN_DATE(L_FETCHED_ROWS) := L_ASSIGN_DATE;
      A_ASSIGNED_BY(L_FETCHED_ROWS) := L_ASSIGNED_BY;

      L_SQL_STRING:=   'SELECT st, st_version, description '
                     ||'FROM dd'||UNAPIGEN.P_DD||'.uvsc '
                     ||'WHERE sc = :l_sc';
      BEGIN
         EXECUTE IMMEDIATE L_SQL_STRING 
         INTO L_ST, L_ST_VERSION, L_DESCRIPTION
         USING L_SC;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            
            NULL;
      END;

      IF SQL%NOTFOUND THEN
         L_ST := NULL;
         L_ST_VERSION := NULL;
         L_DESCRIPTION := NULL;
      END IF;
      A_ST(L_FETCHED_ROWS) := L_ST;
      A_ST_VERSION(L_FETCHED_ROWS) := L_ST_VERSION;
      A_DESCRIPTION(L_FETCHED_ROWS) := L_DESCRIPTION;

      IF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
         L_RESULT := DBMS_SQL.FETCH_ROWS(L_SC_CURSOR);
      END IF;

   END LOOP;

   DBMS_SQL.CLOSE_CURSOR(L_SC_CURSOR);

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
             'GetRqSample', L_SQLERRM);
      UNAPIGEN.U4COMMIT;
      IF DBMS_SQL.IS_OPEN(L_SC_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_SC_CURSOR);
      END IF;
      RETURN(UNAPIGEN.DBERR_GENFAIL);
END GETRQSAMPLE;

FUNCTION SAVERQSAMPLE                                   
(A_RQ               IN     VARCHAR2,                    
 A_SC               IN     UNAPIGEN.VC20_TABLE_TYPE,    
 A_ASSIGN_DATE      IN     UNAPIGEN.DATE_TABLE_TYPE,    
 A_ASSIGNED_BY      IN     UNAPIGEN.VC20_TABLE_TYPE,    
 A_NR_OF_ROWS       IN     NUMBER,                      
 A_MODIFY_REASON    IN     VARCHAR2)                    
RETURN NUMBER IS

L_LC                      VARCHAR2(2);
L_LC_VERSION              VARCHAR2(20);
L_SS                      VARCHAR2(2);
L_LOG_HS                  CHAR(1);
L_LOG_HS_DETAILS          CHAR(1);
L_ALLOW_MODIFY            CHAR(1);
L_ACTIVE                  CHAR(1);
L_SEQ_NO                  NUMBER;
L_CURRENT_TIMESTAMP                 VARCHAR2(30);
L_NEW_MASTERRQ            VARCHAR2(20);
L_ROW                     INTEGER;
L_FOUND                   BOOLEAN;
L_HS_SEQ                  INTEGER;
L_RT_VERSION              VARCHAR2(20);
L_SC_LOG_HS               CHAR(1);
L_SC_LOG_HS_DETAILS       CHAR(1);
L_OLD_SC_COUNTER          NUMBER;
L_NEW_SC_COUNTER          NUMBER;

L_UTRQSCOLD   UORQSCLIST := UORQSCLIST();
L_NUMREC      INTEGER;
L_RQSCOLD_REC UTRQSC%ROWTYPE;
L_RQSCNEW_REC UTRQSC%ROWTYPE;

CURSOR L_UTRQSC_CURSOR(A_RQ VARCHAR2) IS
   SELECT *
   FROM UTRQSC
   WHERE RQ=A_RQ;

CURSOR L_OLDRQSC_CURSOR(A_SC VARCHAR2) IS
   SELECT RQSC.RQ, RQSC.SC, RQSC.SEQ, RQSC.ASSIGN_DATE,RQSC.ASSIGNED_BY
   FROM TABLE(CAST(L_UTRQSCOLD AS UORQSCLIST)) RQSC
   WHERE SC = A_SC;

CURSOR L_MODIFIEDSC_CURSOR(A_RQ VARCHAR2) IS
   
   SELECT RQSC.RQ, RQSC.SC, RQSC.SEQ, RQSC.ASSIGN_DATE,RQSC.ASSIGNED_BY, 'ADDED' ACTION
   FROM UTRQSC RQSC
   WHERE RQ = A_RQ
   AND SC IN(SELECT A.SC
             FROM UTRQSC A
             WHERE A.RQ=A_RQ
             MINUS
             SELECT B.SC
             FROM TABLE(CAST(L_UTRQSCOLD AS UORQSCLIST)) B)
   UNION ALL
   
   SELECT RQSC.RQ, RQSC.SC, RQSC.SEQ, RQSC.ASSIGN_DATE,RQSC.ASSIGNED_BY, 'DELETED' ACTION
   FROM TABLE(CAST(L_UTRQSCOLD AS UORQSCLIST)) RQSC
   WHERE RQ = A_RQ
   AND SC IN(SELECT B.SC
             FROM TABLE(CAST(L_UTRQSCOLD AS UORQSCLIST)) B
             MINUS
             SELECT A.SC
             FROM UTRQSC A
             WHERE A.RQ=A_RQ)
   
   UNION ALL
     (SELECT RQSC.RQ, RQSC.SC, RQSC.SEQ, RQSC.ASSIGN_DATE,RQSC.ASSIGNED_BY, 'UPDATED' ACTION
      FROM UTRQSC RQSC
      WHERE RQ = A_RQ
      AND SC IN(SELECT B.SC
                FROM TABLE(CAST(L_UTRQSCOLD AS UORQSCLIST)) B
                INTERSECT
                SELECT A.SC
                FROM UTRQSC A
                WHERE A.RQ=A_RQ)
      MINUS
      SELECT RQSC.RQ, RQSC.SC, RQSC.SEQ, RQSC.ASSIGN_DATE,RQSC.ASSIGNED_BY, 'UPDATED' ACTION
            FROM TABLE(CAST(L_UTRQSCOLD AS UORQSCLIST)) RQSC
            WHERE RQ = A_RQ
            AND SC IN(SELECT B.SC
                      FROM TABLE(CAST(L_UTRQSCOLD AS UORQSCLIST)) B
                      INTERSECT
                      SELECT A.SC
                      FROM UTRQSC A
                      WHERE A.RQ=A_RQ)
     )           
   ORDER BY 3;  
   
CURSOR C_RQ_CURSOR (C_RQ VARCHAR2) IS
   SELECT SC_COUNTER
     FROM UTRQ
    WHERE RQ = C_RQ;

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   L_SQLERRM := NULL;
   IF NVL(A_RQ, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   
   OPEN C_RQ_CURSOR(A_RQ);
   FETCH C_RQ_CURSOR INTO L_OLD_SC_COUNTER;
   CLOSE C_RQ_CURSOR;

   L_RET_CODE := UNAPIAUT.GETRQAUTHORISATION(A_RQ, L_RT_VERSION, L_LC, L_LC_VERSION, L_SS,
                                             L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS, L_LOG_HS_DETAILS);

   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   UPDATE UTRQ
   SET ALLOW_MODIFY = '#'
   WHERE RQ = A_RQ;
   IF SQL%ROWCOUNT < 1 THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      RAISE STPERROR ;
   END IF;

   
   
   
   
   
   
   
   
   L_NUMREC := 1;
   FOR L_UTRQSC_REC IN L_UTRQSC_CURSOR(A_RQ) LOOP
      L_UTRQSCOLD.EXTEND;
      L_UTRQSCOLD(L_NUMREC) := UORQSC(L_UTRQSC_REC.RQ, L_UTRQSC_REC.SC, L_UTRQSC_REC.SEQ, L_UTRQSC_REC.ASSIGN_DATE, L_UTRQSC_REC.ASSIGNED_BY) ;
      L_NUMREC := L_NUMREC + 1;
   END LOOP;

   
   
   
   DELETE UTRQSC
   WHERE RQ = A_RQ;
   
   
   
   
   L_EVENT_TP := 'RqSamplesAdded';
   L_EV_SEQ_NR := -1;
   L_EV_DETAILS := 'rt_version=' || L_RT_VERSION;
   L_RESULT := UNAPIEV.INSERTEVENT('SaveRqSample', UNAPIGEN.P_EVMGR_NAME, 'rq', A_RQ, L_LC, 
                                   L_LC_VERSION, L_SS, L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS  THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;

   IF L_LOG_HS = '1' THEN
      INSERT INTO UTRQHS (RQ, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
      VALUES (A_RQ, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
              'request "'||A_RQ||'" samples are updated.', 
              CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
   END IF;

   L_HS_SEQ := 0;
   IF L_LOG_HS_DETAILS = '1' THEN
      L_HS_SEQ := L_HS_SEQ + 1;
      INSERT INTO UTRQHSDETAILS (RQ, TR_SEQ, EV_SEQ, SEQ, DETAILS)
      VALUES (A_RQ, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_SEQ, 
              'request "'||A_RQ||'" samples are updated.');
   END IF;

   
   
   
   L_CURRENT_TIMESTAMP := CURRENT_TIMESTAMP;
   FOR L_SEQ_NO IN 1..A_NR_OF_ROWS LOOP
      IF NVL(A_SC(L_SEQ_NO), ' ') = ' ' THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
         RAISE STPERROR;
      END IF;
      
      INSERT INTO UTRQSC (RQ, SC, SEQ, 
                          ASSIGN_DATE, ASSIGN_DATE_TZ, ASSIGNED_BY)
      VALUES (A_RQ, A_SC(L_SEQ_NO), L_SEQ_NO, 
              NVL(A_ASSIGN_DATE(L_SEQ_NO),L_CURRENT_TIMESTAMP), NVL(A_ASSIGN_DATE(L_SEQ_NO),L_CURRENT_TIMESTAMP), 
              NVL(A_ASSIGNED_BY(L_SEQ_NO), UNAPIGEN.P_USER));
   END LOOP;

   
   
      
   
   
     
   IF (L_LOG_HS_DETAILS = '1') THEN
      FOR L_REC IN L_MODIFIEDSC_CURSOR(A_RQ) LOOP
         IF L_REC.ACTION = 'ADDED' THEN
            L_HS_SEQ := L_HS_SEQ + 1;
            INSERT INTO UTRQHSDETAILS (RQ, TR_SEQ, EV_SEQ, SEQ, DETAILS)
            VALUES (A_RQ, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_SEQ, 
                    'sample "'||L_REC.SC||'" is added to request "'||A_RQ||'".');
         ELSIF L_REC.ACTION = 'DELETED' THEN
            L_HS_SEQ := L_HS_SEQ + 1;
            INSERT INTO UTRQHSDETAILS (RQ, TR_SEQ, EV_SEQ, SEQ, DETAILS)
            VALUES (A_RQ, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_SEQ, 
                    'sample "'||L_REC.SC||'" is removed from request "'||A_RQ||'".');
         ELSIF L_REC.ACTION = 'UPDATED' THEN
            
            
            
            OPEN L_OLDRQSC_CURSOR(L_REC.SC);
            FETCH L_OLDRQSC_CURSOR
            INTO L_RQSCOLD_REC.RQ, L_RQSCOLD_REC.SC, L_RQSCOLD_REC.SEQ, L_RQSCOLD_REC.ASSIGN_DATE, L_RQSCOLD_REC.ASSIGNED_BY;
            
            IF L_OLDRQSC_CURSOR%NOTFOUND THEN
               RAISE NO_DATA_FOUND;
            END IF;
            CLOSE L_OLDRQSC_CURSOR;
            L_RQSCNEW_REC.RQ := L_REC.RQ;
            L_RQSCNEW_REC.SC := L_REC.SC;
            
            
            L_RQSCNEW_REC.SEQ := L_RQSCOLD_REC.SEQ;
            L_RQSCNEW_REC.ASSIGN_DATE := L_REC.ASSIGN_DATE;
            L_RQSCNEW_REC.ASSIGNED_BY := L_REC.ASSIGNED_BY;
            UNAPIHSDETAILS.ADDRQSCHSDETAILS(L_RQSCOLD_REC, L_RQSCNEW_REC, UNAPIGEN.P_TR_SEQ, 
                                            L_EV_SEQ_NR, L_HS_SEQ);

         END IF;
      END LOOP;        
   END IF;
   
   L_UTRQSCOLD.DELETE;
   
   
   
   
   FOR L_UTSCRQ_REC IN L_UTSCRQ_CURSOR(A_RQ) LOOP
      
      L_SEQ_NO := 1;
      L_FOUND := FALSE;
      LOOP
         EXIT WHEN L_SEQ_NO > A_NR_OF_ROWS;
         IF A_SC(L_SEQ_NO) = L_UTSCRQ_REC.SC THEN
            L_FOUND := TRUE;
            EXIT;
         END IF;
         L_SEQ_NO := L_SEQ_NO + 1;
      END LOOP;

      IF NOT L_FOUND THEN
         UPDATE UTSC
         SET RQ = NULL
         WHERE RQ = A_RQ
         AND SC = L_UTSCRQ_REC.SC
         RETURNING LOG_HS, LOG_HS_DETAILS
         INTO L_SC_LOG_HS, L_SC_LOG_HS_DETAILS;         

         IF L_SC_LOG_HS = '1' THEN
            INSERT INTO UTSCHS (SC, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
            VALUES (L_UTSCRQ_REC.SC, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
                    'sample "'||L_UTSCRQ_REC.SC||'" is updated.', 
                    CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
         END IF;
         IF L_SC_LOG_HS_DETAILS = '1' THEN
            
            
            
            L_HS_SEQ := L_HS_SEQ + 1;
            INSERT INTO UTSCHSDETAILS (SC, TR_SEQ, EV_SEQ, SEQ, DETAILS)
            VALUES (L_UTSCRQ_REC.SC, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_SEQ, 
                    'sample "'||L_UTSCRQ_REC.SC||'" is updated: property <rq> changed value from "'||A_RQ||'" to "".');
         END IF;
         
         
         
         
         L_RET_CODE := UNAPISC.UPDATELINKEDSCII(L_UTSCRQ_REC.SC, 'rq', '0', '', '', '',
                                                '', '', '',
                                                '', '', '',
                                                '', '', '',
                                                '', '', NULL,  '',
                                                '', '', '', '', '',
                                                '', '');
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            RAISE STPERROR;
         END IF;
         
      END IF;
      
   END LOOP;
   
   
   UPDATE UTRQ
      SET SC_COUNTER = (SELECT COUNT(*) FROM UTRQSC WHERE RQ = A_RQ)
    WHERE RQ = A_RQ
   RETURNING SC_COUNTER
     INTO L_NEW_SC_COUNTER;

   IF (L_LOG_HS_DETAILS = '1') THEN
      IF NVL((L_OLD_SC_COUNTER <> L_NEW_SC_COUNTER), TRUE) AND 
         NOT(L_OLD_SC_COUNTER IS NULL AND L_NEW_SC_COUNTER IS NULL) THEN 
         L_HS_SEQ := L_HS_SEQ + 1;
         INSERT INTO UTRQHSDETAILS(RQ, TR_SEQ, EV_SEQ, SEQ, DETAILS)
         VALUES(A_RQ, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_SEQ, 
                'request "'||A_RQ||'" is updated: property <sc_counter> changed value from "'||
                    L_OLD_SC_COUNTER||'" to "'||L_NEW_SC_COUNTER||'".');
      END IF;
   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN (UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('SaveRqSample', SQLERRM);
   END IF;
   IF L_MODIFIEDSC_CURSOR%ISOPEN THEN
      CLOSE L_MODIFIEDSC_CURSOR;
   END IF;
   IF C_RQ_CURSOR%ISOPEN THEN
      CLOSE C_RQ_CURSOR;
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'SaveRqSample'));
END SAVERQSAMPLE;

FUNCTION SAVE1RQSAMPLE                                  
(A_RQ               IN     VARCHAR2,                    
 A_SC               IN     VARCHAR2,                    
 A_ASSIGN_DATE      IN     DATE,                        
 A_ASSIGNED_BY      IN     VARCHAR2,                    
 A_MODIFY_REASON    IN     VARCHAR2)                    
RETURN NUMBER IS

L_LC                VARCHAR2(2);
L_LC_VERSION        VARCHAR2(20);
L_SS                VARCHAR2(2);
L_LOG_HS            CHAR(1);
L_LOG_HS_DETAILS    CHAR(1);
L_ALLOW_MODIFY      CHAR(1);
L_ACTIVE            CHAR(1);
L_SEQ_NO            NUMBER;
L_HS_DETAILS_SEQ_NR INTEGER;
L_RT_VERSION        VARCHAR2(20);
L_OLD_SC_COUNTER    NUMBER;
L_NEW_SC_COUNTER    NUMBER;

CURSOR C_RQ_CURSOR (C_RQ VARCHAR2) IS
   SELECT SC_COUNTER
     FROM UTRQ
    WHERE RQ = C_RQ;

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_RQ, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   IF NVL(A_SC, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   
   OPEN C_RQ_CURSOR(A_RQ);
   FETCH C_RQ_CURSOR INTO L_OLD_SC_COUNTER;
   CLOSE C_RQ_CURSOR;

   L_RET_CODE := UNAPIAUT.GETRQAUTHORISATION(A_RQ, L_RT_VERSION, L_LC, L_LC_VERSION, L_SS,
                                             L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS, L_LOG_HS_DETAILS);

   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   UPDATE UTRQ
   SET ALLOW_MODIFY = '#'
   WHERE RQ = A_RQ;
   IF SQL%ROWCOUNT < 1 THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      RAISE STPERROR ;
   END IF;

   
   
   
   DELETE UTRQSC
   WHERE RQ = A_RQ
   AND SC = A_SC;
   
   
   
   
   INSERT INTO UTRQSC (RQ, SC, SEQ, 
                       ASSIGN_DATE, ASSIGN_DATE_TZ, ASSIGNED_BY)
   SELECT  A_RQ, A_SC, NVL(MAX(SEQ),0)+1, 
           NVL(A_ASSIGN_DATE,CURRENT_TIMESTAMP), NVL(A_ASSIGN_DATE,CURRENT_TIMESTAMP), NVL(A_ASSIGNED_BY,UNAPIGEN.P_USER)
   FROM UTRQSC
   WHERE RQ = A_RQ;

   
   
   
   L_RET_CODE := UNAPISC.UPDATELINKEDSCII(A_SC, 'rq', '0', '', '', '',
                                          '', '', '',
                                          '', '', '',
                                          '', '', '',
                                          '', '', A_RQ,   '',
                                          '', '', '', '', '',
                                          '', '');
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   
   UPDATE UTRQ
      SET SC_COUNTER = (SELECT COUNT(*) FROM UTRQSC WHERE RQ = A_RQ)
    WHERE RQ = A_RQ
   RETURNING SC_COUNTER
     INTO L_NEW_SC_COUNTER;

   
   
   
   L_EVENT_TP := 'Rq1SampleAdded';
   L_EV_SEQ_NR := -1;
   L_EV_DETAILS := 'sc=' || A_SC ||
                   '#rt_version=' || L_RT_VERSION;
   L_RESULT := UNAPIEV.INSERTEVENT('Save1RqSample', UNAPIGEN.P_EVMGR_NAME,
                                   'rq', A_RQ, L_LC, L_LC_VERSION, L_SS, L_EVENT_TP, 
                                   L_EV_DETAILS,  L_EV_SEQ_NR);
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS  THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;

   IF L_LOG_HS = '1' THEN
      INSERT INTO UTRQHS (RQ, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
      VALUES (A_RQ, NVL(A_ASSIGNED_BY, UNAPIGEN.P_USER), UNAPIGEN.SQLUSERDESCRIPTION(NVL(A_ASSIGNED_BY, UNAPIGEN.P_USER)), 
             L_EVENT_TP, 'request "'||A_RQ||'" sample  "'||A_SC||'" is added.', 
             CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
   END IF;

   L_HS_DETAILS_SEQ_NR := 0;
   IF L_LOG_HS_DETAILS = '1' THEN
      L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
      INSERT INTO UTRQHSDETAILS (RQ, TR_SEQ, EV_SEQ, SEQ, DETAILS)
      VALUES (A_RQ, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR, 
              'request "'||A_RQ||'" sample  "'||A_SC||'" is added.');
      IF NVL((L_OLD_SC_COUNTER <> L_NEW_SC_COUNTER), TRUE) AND 
         NOT(L_OLD_SC_COUNTER IS NULL AND L_NEW_SC_COUNTER IS NULL) THEN 
         L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
         INSERT INTO UTRQHSDETAILS(RQ, TR_SEQ, EV_SEQ, SEQ, DETAILS)
         VALUES(A_RQ, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR, 
                'request "'||A_RQ||'" is updated: property <sc_counter> changed value from "'||
                    L_OLD_SC_COUNTER||'" to "'||L_NEW_SC_COUNTER||'".');
      END IF;
   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN (UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE <> 1 THEN
         UNAPIGEN.LOGERROR('Save1RqSample', SQLERRM);
      END IF;
      IF C_RQ_CURSOR%ISOPEN THEN
         CLOSE C_RQ_CURSOR;
      END IF;
      RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'Save1RqSample'));
END SAVE1RQSAMPLE;

FUNCTION REMOVERQSAMPLE                                 
(A_RQ               IN     VARCHAR2,                    
 A_SC               IN     VARCHAR2,                    
 A_MODIFY_REASON    IN     VARCHAR2)                    
RETURN NUMBER IS

L_LC                VARCHAR2(2);
L_LC_VERSION        VARCHAR2(20);
L_SS                VARCHAR2(2);
L_LOG_HS            CHAR(1);
L_LOG_HS_DETAILS    CHAR(1);
L_ALLOW_MODIFY      CHAR(1);
L_ACTIVE            CHAR(1);
L_SEQ_NO            NUMBER;
L_HS_DETAILS_SEQ_NR INTEGER;
L_RT_VERSION        VARCHAR2(20);
L_SC_LOG_HS_DETAILS CHAR(1);
L_OLD_SC_COUNTER    NUMBER;
L_NEW_SC_COUNTER    NUMBER;
   
CURSOR C_RQ_CURSOR (C_RQ VARCHAR2) IS
   SELECT SC_COUNTER
     FROM UTRQ
    WHERE RQ = C_RQ;

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_RQ, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   IF NVL(A_SC, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   
   OPEN C_RQ_CURSOR(A_RQ);
   FETCH C_RQ_CURSOR INTO L_OLD_SC_COUNTER;
   CLOSE C_RQ_CURSOR;

   L_RET_CODE := UNAPIAUT.GETRQAUTHORISATION(A_RQ, L_RT_VERSION, L_LC, L_LC_VERSION, L_SS,
                                             L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS, L_LOG_HS_DETAILS);
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   UPDATE UTRQ
   SET ALLOW_MODIFY = '#'
   WHERE RQ = A_RQ;
   IF SQL%ROWCOUNT < 1 THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      RAISE STPERROR ;
   END IF;

   
   
   
   DELETE UTRQSC
   WHERE RQ = A_RQ
   AND SC = A_SC;

   
   
   
   UPDATE UTSC
   SET RQ = NULL
   WHERE SC = A_SC
   AND RQ = A_RQ
   RETURNING LOG_HS_DETAILS
   INTO L_SC_LOG_HS_DETAILS;

   
   
   
   L_RET_CODE := UNAPISC.UPDATELINKEDSCII(A_SC, 'rq', '0', '', '', '',
                                          '', '', '',
                                          '', '', '',
                                          '', '', '',
                                          '', '', NULL,   '',
                                          '', '', '', '', '',
                                          '', '');
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;
      
   
   
   
   L_EVENT_TP := 'RqSampleRemoved';
   L_EV_SEQ_NR := -1;
   L_EV_DETAILS := 'sc=' || A_SC ||
                   '#rt_version=' || L_RT_VERSION;
   L_RESULT := UNAPIEV.INSERTEVENT('RemoveRqSample', UNAPIGEN.P_EVMGR_NAME,
                                   'rq', A_RQ, L_LC, L_LC_VERSION, L_SS, L_EVENT_TP, 
                                   L_EV_DETAILS,  L_EV_SEQ_NR);
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS  THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;

   IF L_LOG_HS = '1' THEN
      INSERT INTO UTRQHS (RQ, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
      VALUES (A_RQ, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
              'request "'||A_RQ||'" sample  "'||A_SC||'" is removed.', 
              CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
   END IF;

   L_HS_DETAILS_SEQ_NR := 0;
   IF L_LOG_HS_DETAILS = '1' THEN
      L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
      INSERT INTO UTRQHSDETAILS (RQ, TR_SEQ, EV_SEQ, SEQ, DETAILS)
      VALUES (A_RQ, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR,
              'request "'||A_RQ||'" sample  "'||A_SC||'" is removed.');
   END IF;
   IF L_SC_LOG_HS_DETAILS = '1' THEN
      
      
      
      L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
      INSERT INTO UTSCHSDETAILS(SC, TR_SEQ, EV_SEQ, SEQ, DETAILS)
      VALUES(A_SC, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR, 
             'sample "'||A_SC||'" is updated: property <rq> changed value from "' || A_RQ || '" to NULL.');
   END IF;

   
   UPDATE UTRQ
      SET SC_COUNTER = (SELECT COUNT(*) FROM UTRQSC WHERE RQ = A_RQ)
    WHERE RQ = A_RQ
   RETURNING SC_COUNTER
     INTO L_NEW_SC_COUNTER;

   IF (L_LOG_HS_DETAILS = '1') THEN
      IF NVL((L_OLD_SC_COUNTER <> L_NEW_SC_COUNTER), TRUE) AND 
         NOT(L_OLD_SC_COUNTER IS NULL AND L_NEW_SC_COUNTER IS NULL) THEN 
         L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
         INSERT INTO UTRQHSDETAILS(RQ, TR_SEQ, EV_SEQ, SEQ, DETAILS)
         VALUES(A_RQ, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR, 
                'request "'||A_RQ||'" is updated: property <sc_counter> changed value from "'||
                    L_OLD_SC_COUNTER||'" to "'||L_NEW_SC_COUNTER||'".');
      END IF;
   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN (UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE <> 1 THEN
         UNAPIGEN.LOGERROR('RemoveRqSample', SQLERRM);
      END IF;
      IF C_RQ_CURSOR%ISOPEN THEN
         CLOSE C_RQ_CURSOR;
      END IF;
      RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'RemoveRqSample'));
END REMOVERQSAMPLE;

FUNCTION INITANDSAVERQSCATTRIBUTES                     
(A_RQ               IN      VARCHAR2,                  
 A_SC               IN      VARCHAR2,                  
 A_RT               IN      VARCHAR2,                  
 A_RT_VERSION       IN      VARCHAR2,                  
 A_ST               IN      VARCHAR2,                  
 A_ST_VERSION       IN      VARCHAR2)                  
RETURN NUMBER IS

CURSOR L_ST_CURSOR(A_SC VARCHAR2) IS
   SELECT ST, ST_VERSION
   FROM UTSC
   WHERE SC = A_SC;
L_ST            VARCHAR2(20);
L_ST_VERSION    VARCHAR2(20);

CURSOR L_RT_CURSOR(A_RQ VARCHAR2) IS
   SELECT RT, RT_VERSION
   FROM UTRQ
   WHERE RQ = A_RQ;
L_RT            VARCHAR2(20);
L_RT_VERSION    VARCHAR2(20);

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;
   
   IF A_ST IS NULL THEN
      OPEN L_ST_CURSOR(A_SC);
      FETCH L_ST_CURSOR
      INTO L_ST, L_ST_VERSION;
      CLOSE L_ST_CURSOR;   
   ELSE
      L_ST := A_ST;
      IF A_ST_VERSION IS NULL THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_STVERSION;
         RAISE STPERROR;
      END IF;
      L_ST_VERSION := A_ST_VERSION;
   END IF;

   IF A_RT IS NULL THEN
      OPEN L_RT_CURSOR(A_SC);
      FETCH L_RT_CURSOR
      INTO L_RT, L_RT_VERSION;
      CLOSE L_RT_CURSOR;   
   ELSE
      L_RT := A_RT;
      IF A_RT_VERSION IS NULL THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_RTVERSION;
         RAISE STPERROR;
      END IF;
      L_RT_VERSION := A_RT_VERSION;
   END IF;

   
   
   
   
   INSERT INTO UTSCAU(SC, AU, AU_VERSION, AUSEQ, VALUE)
   SELECT A_SC, A.AU, '' D_VERSION, A.AUSEQ, A.VALUE
   FROM UTSTAU A, UTST B, UTRTST C, UTAU D
   WHERE A.ST = L_ST
     AND A.VERSION = L_ST_VERSION
     AND A.ST = B.ST
     AND A.VERSION = B.VERSION
     AND A.AU = D.AU
     AND UNAPIGEN.VALIDATEVERSION('au', A.AU, A.AU_VERSION) = D.VERSION
     AND C.RT = L_RT
     AND C.VERSION = L_RT_VERSION     
     AND C.ST = B.ST
     AND UNAPIGEN.VALIDATEVERSION('st', C.ST, C.ST_VERSION) = B.VERSION     
     AND DECODE(D.INHERIT_AU,'0',DECODE(C.INHERIT_AU,'2',B.INHERIT_AU,C.INHERIT_AU),D.INHERIT_AU) = '1'
     AND A.AU NOT IN (SELECT DISTINCT J.AU
                      FROM UTRTSTAU J, UTRTST K, UTST L, UTAU M
                      WHERE J.ST = L.ST
                        AND UNAPIGEN.VALIDATEVERSION('st', J.ST, J.ST_VERSION) = L.VERSION
                        AND J.RT = L_RT
                        AND J.VERSION = L_RT_VERSION
                        AND J.ST = L_ST
                        AND UNAPIGEN.VALIDATEVERSION('st', J.ST, J.ST_VERSION) = L_ST_VERSION
                        AND J.ST = K.ST
                        AND UNAPIGEN.VALIDATEVERSION('st', J.ST, J.ST_VERSION) = UNAPIGEN.VALIDATEVERSION('st', K.ST, K.ST_VERSION)                        
                        AND J.RT = K.RT
                        AND J.VERSION = K.VERSION
                        AND DECODE(M.INHERIT_AU,'0',DECODE(K.INHERIT_AU,'2',L.INHERIT_AU,K.INHERIT_AU),M.INHERIT_AU) = '1'
                        AND J.AU = M.AU
                        AND M.VERSION = UNAPIGEN.VALIDATEVERSION('au', J.AU, J.AU_VERSION))
   
   
   
   
   UNION
   SELECT A_SC, V.AU, '' Y_VERSION, V.AUSEQ+500, V.VALUE
   FROM UTRTSTAU V, UTRTST W, UTST X, UTAU Y
   WHERE V.ST = X.ST
     AND UNAPIGEN.VALIDATEVERSION('st', V.ST, V.ST_VERSION) = X.VERSION
     AND V.RT = L_RT
     AND V.VERSION = L_RT_VERSION     
     AND V.ST = L_ST
     AND UNAPIGEN.VALIDATEVERSION('st', V.ST, V.ST_VERSION) = L_ST_VERSION
     AND V.RT = W.RT
     AND V.VERSION = W.VERSION     
     AND V.ST = W.ST
     AND UNAPIGEN.VALIDATEVERSION('st', V.ST, V.ST_VERSION) = UNAPIGEN.VALIDATEVERSION('st', W.ST, W.ST_VERSION)     
     AND DECODE(Y.INHERIT_AU,'0',DECODE(W.INHERIT_AU,'2',X.INHERIT_AU,W.INHERIT_AU),Y.INHERIT_AU) = '1' 
     AND V.AU = Y.AU
     AND UNAPIGEN.VALIDATEVERSION('au', V.AU, V.AU_VERSION) = Y.VERSION;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('InitAndSaveRqScAttributes', SQLERRM);
   END IF;
   IF L_ST_CURSOR%ISOPEN THEN
      CLOSE L_ST_CURSOR;
   END IF;
   IF L_RT_CURSOR%ISOPEN THEN
      CLOSE L_RT_CURSOR;
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'InitAndSaveRqScAttributes'));
END INITANDSAVERQSCATTRIBUTES;

FUNCTION SAVERQPARAMETERPROFILE
(A_RQ               IN     VARCHAR2,                    
 A_PP               IN     UNAPIGEN.VC20_TABLE_TYPE,    
 A_PP_VERSION       IN     UNAPIGEN.VC20_TABLE_TYPE,    
 A_PP_KEY1          IN     UNAPIGEN.VC20_TABLE_TYPE,    
 A_PP_KEY2          IN     UNAPIGEN.VC20_TABLE_TYPE,    
 A_PP_KEY3          IN     UNAPIGEN.VC20_TABLE_TYPE,    
 A_PP_KEY4          IN     UNAPIGEN.VC20_TABLE_TYPE,    
 A_PP_KEY5          IN     UNAPIGEN.VC20_TABLE_TYPE,    
 A_DELAY            IN     UNAPIGEN.NUM_TABLE_TYPE,     
 A_DELAY_UNIT       IN     UNAPIGEN.VC20_TABLE_TYPE,    
 A_FREQ_TP          IN     UNAPIGEN.CHAR1_TABLE_TYPE,   
 A_FREQ_VAL         IN     UNAPIGEN.NUM_TABLE_TYPE,     
 A_FREQ_UNIT        IN     UNAPIGEN.VC20_TABLE_TYPE,    
 A_INVERT_FREQ      IN     UNAPIGEN.CHAR1_TABLE_TYPE,   
 A_LAST_SCHED       IN     UNAPIGEN.DATE_TABLE_TYPE,    
 A_LAST_CNT         IN     UNAPIGEN.NUM_TABLE_TYPE,     
 A_LAST_VAL         IN     UNAPIGEN.VC40_TABLE_TYPE,    
 A_INHERIT_AU       IN     UNAPIGEN.CHAR1_TABLE_TYPE,   
 A_NR_OF_ROWS       IN     NUMBER,                      
 A_MODIFY_REASON    IN     VARCHAR2)                    
RETURN NUMBER IS

L_LC                   VARCHAR2(2);
L_LC_VERSION           VARCHAR2(20);
L_SS                   VARCHAR2(2);
L_LOG_HS               CHAR(1);
L_LOG_HS_DETAILS       CHAR(1);
L_ALLOW_MODIFY         CHAR(1);
L_ACTIVE               CHAR(1);
L_SEQ_NO               NUMBER;
L_WHAT_DESCRIPTION     VARCHAR2(255);
L_HS_SEQ               INTEGER;
L_RT_VERSION           VARCHAR2(20);

CURSOR L_RQPPOLD_CURSOR (A_RQ IN VARCHAR2, A_PP IN VARCHAR2, A_SEQ IN NUMBER) IS
   SELECT RQ, PP, PP_VERSION, PP_KEY1, PP_KEY2, PP_KEY3, PP_KEY4, PP_KEY5, -SEQ SEQ, 
          DELAY, DELAY_UNIT, FREQ_TP, FREQ_VAL, FREQ_UNIT, 
          INVERT_FREQ, LAST_SCHED, LAST_CNT, LAST_VAL, INHERIT_AU
   FROM UTRQPP A
   WHERE A.RQ = A_RQ
     AND A.PP = A_PP
     AND A.SEQ = -A_SEQ;
L_RQPPOLD_REC UTRQPP%ROWTYPE;
L_RQPPNEW_REC UTRQPP%ROWTYPE;
   
CURSOR L_MODIFIEDPP_CURSOR IS
   
   (SELECT A.PP PP, A.PP_VERSION PP_VERSION, A.PP_KEY1 PP_KEY1, A.PP_KEY2 PP_KEY2, 
       A.PP_KEY3 PP_KEY3, A.PP_KEY4 PP_KEY4, A.PP_KEY5 PP_KEY5, 'DELETE' ACTION
    FROM UTRQPP A
    WHERE A.RQ = A_RQ
    AND SEQ < 0
   MINUS
    SELECT A.PP PP, A.PP_VERSION PP_VERSION, A.PP_KEY1 PP_KEY1, A.PP_KEY2 PP_KEY2, 
       A.PP_KEY3 PP_KEY3, A.PP_KEY4 PP_KEY4, A.PP_KEY5 PP_KEY5, 'DELETE' ACTION
    FROM UTRQPP A
    WHERE A.RQ = A_RQ
    AND SEQ > 0)
   UNION ALL
   
   (SELECT A.PP PP, A.PP_VERSION PP_VERSION, A.PP_KEY1 PP_KEY1, A.PP_KEY2 PP_KEY2, 
       A.PP_KEY3 PP_KEY3, A.PP_KEY4 PP_KEY4, A.PP_KEY5 PP_KEY5, 'NEW' ACTION
    FROM UTRQPP A
    WHERE A.RQ = A_RQ
    AND SEQ > 0
   MINUS
    SELECT A.PP PP, A.PP_VERSION PP_VERSION, A.PP_KEY1 PP_KEY1, A.PP_KEY2 PP_KEY2, 
       A.PP_KEY3 PP_KEY3, A.PP_KEY4 PP_KEY4, A.PP_KEY5 PP_KEY5, 'NEW' ACTION
    FROM UTRQPP A
    WHERE A.RQ = A_RQ
    AND SEQ < 0);

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_RQ, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   L_RET_CODE := UNAPIAUT.GETRQAUTHORISATION(A_RQ, L_RT_VERSION, L_LC, L_LC_VERSION, L_SS,
                                             L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS, L_LOG_HS_DETAILS);

   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   UPDATE UTRQ
   SET ALLOW_MODIFY = '#'
   WHERE RQ = A_RQ;
   
   IF SQL%ROWCOUNT < 1 THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      RAISE STPERROR ;
   END IF;

   
   
   
   L_EVENT_TP := 'RqPpUpdated';
   L_EV_SEQ_NR := -1;
   L_EV_DETAILS := 'rt_version=' || L_RT_VERSION;
   L_RESULT := UNAPIEV.INSERTEVENT('SaveRqParameterProfile', UNAPIGEN.P_EVMGR_NAME, 'rq', A_RQ, L_LC, 
                                   L_LC_VERSION, L_SS, L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS  THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;

   IF L_LOG_HS = '1' THEN
      INSERT INTO UTRQHS (RQ, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
      VALUES (A_RQ, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
              'request "'||A_RQ||'" parameter profiles are updated.', 
              CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
   END IF;

   L_HS_SEQ := 0;
   IF L_LOG_HS_DETAILS = '1' THEN
      L_HS_SEQ := L_HS_SEQ + 1;
      INSERT INTO UTRQHSDETAILS (RQ, TR_SEQ, EV_SEQ, SEQ, DETAILS)
      VALUES (A_RQ, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_SEQ, 
              'request "'||A_RQ||'" parameter profiles are updated.');
   END IF;




   
   
   
   
   UPDATE UTRQPP
   SET SEQ = -SEQ
   WHERE RQ = A_RQ;

   FOR L_SEQ_NO IN 1..A_NR_OF_ROWS LOOP
      IF NVL(A_PP(L_SEQ_NO), ' ') = ' ' THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
         RAISE STPERROR;
      END IF;

      IF NVL(A_FREQ_TP(L_SEQ_NO), ' ') NOT IN ('A','S','T','C','N') THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_FREQTP;
         RAISE STPERROR;
      END IF;

      IF A_FREQ_TP(L_SEQ_NO) IN ('C','T','S') THEN
         IF A_FREQ_UNIT(L_SEQ_NO) IS NULL THEN
            UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_FREQUNIT;
            RAISE STPERROR;         
         ELSIF A_FREQ_TP(L_SEQ_NO) = 'T' AND
            A_FREQ_UNIT(L_SEQ_NO) NOT IN ('MI','HH','DD','WW','MM','YY') THEN
            UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_FREQUNIT;
            RAISE STPERROR;         
         END IF;
      END IF;

      IF NVL(A_INVERT_FREQ(L_SEQ_NO), ' ') NOT IN ('1','0') THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_INVERTFREQ;
         RAISE STPERROR;
      END IF;

      IF NVL(A_INHERIT_AU(L_SEQ_NO), ' ') NOT IN ('1','0') THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_INHERITAU;
         RAISE STPERROR;
      END IF;

      INSERT INTO UTRQPP (RQ, PP, PP_VERSION, PP_KEY1, PP_KEY2, PP_KEY3, PP_KEY4, PP_KEY5, 
                          SEQ, DELAY, DELAY_UNIT,
                          FREQ_TP, FREQ_VAL, FREQ_UNIT, INVERT_FREQ,
                          LAST_SCHED, LAST_SCHED_TZ, LAST_CNT, LAST_VAL, INHERIT_AU)
      VALUES (A_RQ, A_PP(L_SEQ_NO), A_PP_VERSION(L_SEQ_NO), A_PP_KEY1(L_SEQ_NO),
              A_PP_KEY2(L_SEQ_NO), A_PP_KEY3(L_SEQ_NO), A_PP_KEY4(L_SEQ_NO), A_PP_KEY5(L_SEQ_NO), 
              L_SEQ_NO, A_DELAY(L_SEQ_NO), A_DELAY_UNIT(L_SEQ_NO), A_FREQ_TP(L_SEQ_NO),
              A_FREQ_VAL(L_SEQ_NO), A_FREQ_UNIT(L_SEQ_NO),
              A_INVERT_FREQ(L_SEQ_NO), TO_TIMESTAMP_TZ(A_LAST_SCHED(L_SEQ_NO)), TO_TIMESTAMP_TZ(A_LAST_SCHED(L_SEQ_NO)),
              A_LAST_CNT(L_SEQ_NO), A_LAST_VAL(L_SEQ_NO), A_INHERIT_AU(L_SEQ_NO));

      IF L_LOG_HS_DETAILS = '1' THEN
         
         
         
         L_RQPPOLD_REC := NULL;
         OPEN L_RQPPOLD_CURSOR(A_RQ, A_PP(L_SEQ_NO), L_SEQ_NO);
         FETCH L_RQPPOLD_CURSOR
         INTO L_RQPPOLD_REC.RQ, L_RQPPOLD_REC.PP, L_RQPPOLD_REC.PP_VERSION, L_RQPPOLD_REC.PP_KEY1, 
              L_RQPPOLD_REC.PP_KEY2,L_RQPPOLD_REC.PP_KEY3, L_RQPPOLD_REC.PP_KEY4, L_RQPPOLD_REC.PP_KEY5, 
              L_RQPPOLD_REC.SEQ, L_RQPPOLD_REC.DELAY, L_RQPPOLD_REC.DELAY_UNIT, 
              L_RQPPOLD_REC.FREQ_TP, L_RQPPOLD_REC.FREQ_VAL, L_RQPPOLD_REC.FREQ_UNIT,
              L_RQPPOLD_REC.INVERT_FREQ, L_RQPPOLD_REC.LAST_SCHED, L_RQPPOLD_REC.LAST_CNT,
              L_RQPPOLD_REC.LAST_VAL, L_RQPPOLD_REC.INHERIT_AU;
         IF L_RQPPOLD_CURSOR%NOTFOUND THEN
            L_RQPPOLD_REC.RQ := A_RQ;
            L_RQPPOLD_REC.PP := A_PP(L_SEQ_NO);
            L_RQPPOLD_REC.PP_VERSION := A_PP_VERSION(L_SEQ_NO);
            L_RQPPOLD_REC.PP_KEY1 := A_PP_KEY1(L_SEQ_NO);
            L_RQPPOLD_REC.PP_KEY2 := A_PP_KEY2(L_SEQ_NO);
            L_RQPPOLD_REC.PP_KEY3 := A_PP_KEY3(L_SEQ_NO);
            L_RQPPOLD_REC.PP_KEY4 := A_PP_KEY4(L_SEQ_NO);
            L_RQPPOLD_REC.PP_KEY5 := A_PP_KEY5(L_SEQ_NO);
            L_RQPPOLD_REC.SEQ := L_SEQ_NO;
            L_RQPPOLD_REC.DELAY := A_DELAY(L_SEQ_NO);
            L_RQPPOLD_REC.DELAY_UNIT := A_DELAY_UNIT(L_SEQ_NO);
            L_RQPPOLD_REC.FREQ_TP := A_FREQ_TP(L_SEQ_NO);
            L_RQPPOLD_REC.FREQ_VAL := A_FREQ_VAL(L_SEQ_NO);
            L_RQPPOLD_REC.FREQ_UNIT := A_FREQ_UNIT(L_SEQ_NO);
            L_RQPPOLD_REC.INVERT_FREQ:= A_INVERT_FREQ(L_SEQ_NO);
            L_RQPPOLD_REC.LAST_SCHED := TO_TIMESTAMP_TZ(A_LAST_SCHED(L_SEQ_NO));
            L_RQPPOLD_REC.LAST_CNT := A_LAST_CNT(L_SEQ_NO);
            L_RQPPOLD_REC.LAST_VAL := A_LAST_VAL(L_SEQ_NO);
            L_RQPPOLD_REC.INHERIT_AU := A_INHERIT_AU(L_SEQ_NO);
         END IF;
         CLOSE L_RQPPOLD_CURSOR;

         
         
         
         L_RQPPNEW_REC.RQ := A_RQ;
         L_RQPPNEW_REC.PP := A_PP(L_SEQ_NO);
         L_RQPPNEW_REC.PP_VERSION := A_PP_VERSION(L_SEQ_NO);
         L_RQPPNEW_REC.PP_KEY1 := A_PP_KEY1(L_SEQ_NO);
         L_RQPPNEW_REC.PP_KEY2 := A_PP_KEY2(L_SEQ_NO);
         L_RQPPNEW_REC.PP_KEY3 := A_PP_KEY3(L_SEQ_NO);
         L_RQPPNEW_REC.PP_KEY4 := A_PP_KEY4(L_SEQ_NO);
         L_RQPPNEW_REC.PP_KEY5 := A_PP_KEY5(L_SEQ_NO);
         L_RQPPNEW_REC.SEQ := L_SEQ_NO;
         L_RQPPNEW_REC.DELAY := A_DELAY(L_SEQ_NO);
         L_RQPPNEW_REC.DELAY_UNIT := A_DELAY_UNIT(L_SEQ_NO);
         L_RQPPNEW_REC.FREQ_TP := A_FREQ_TP(L_SEQ_NO);
         L_RQPPNEW_REC.FREQ_VAL := A_FREQ_VAL(L_SEQ_NO);
         L_RQPPNEW_REC.FREQ_UNIT := A_FREQ_UNIT(L_SEQ_NO);
         L_RQPPNEW_REC.INVERT_FREQ:= A_INVERT_FREQ(L_SEQ_NO);
         L_RQPPNEW_REC.LAST_SCHED := TO_TIMESTAMP_TZ(A_LAST_SCHED(L_SEQ_NO));
         L_RQPPNEW_REC.LAST_CNT := A_LAST_CNT(L_SEQ_NO);
         L_RQPPNEW_REC.LAST_VAL := A_LAST_VAL(L_SEQ_NO);
         L_RQPPNEW_REC.INHERIT_AU := A_INHERIT_AU(L_SEQ_NO);
         
         UNAPIHSDETAILS.ADDRQPPHSDETAILS(L_RQPPOLD_REC, L_RQPPNEW_REC,
                                         UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_SEQ);
                                                 
      END IF;
   END LOOP;

   
   
      
   
   IF (L_LOG_HS_DETAILS = '1') THEN
      FOR L_PP_REC IN L_MODIFIEDPP_CURSOR LOOP
         IF L_PP_REC.ACTION = 'DELETE' THEN
            L_WHAT_DESCRIPTION := 'Parameter profile "'||L_PP_REC.PP||'" is removed from request "'||A_RQ||'".';
         ELSE 
            L_WHAT_DESCRIPTION := 'Parameter profile "'||L_PP_REC.PP||'" is added to request "'||A_RQ||'".';
         END IF;
         L_HS_SEQ := L_HS_SEQ + 1;
         INSERT INTO UTRQHSDETAILS(RQ, TR_SEQ, EV_SEQ, SEQ, DETAILS)
         VALUES(A_RQ, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_SEQ, L_WHAT_DESCRIPTION);
      END LOOP;
   END IF;
  
   
   
   
   DELETE FROM UTRQPP
   WHERE RQ = A_RQ
   AND SEQ < 0;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN (UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('SaveRqParameterProfile', SQLERRM);
   END IF;
   IF L_RQPPOLD_CURSOR%ISOPEN THEN
      CLOSE L_RQPPOLD_CURSOR;
   END IF;
   IF L_MODIFIEDPP_CURSOR%ISOPEN THEN
      CLOSE L_MODIFIEDPP_CURSOR;
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'SaveRqParameterProfile'));
END SAVERQPARAMETERPROFILE;

FUNCTION GETRQPARAMETERPROFILE
(A_RQ               OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_PP               OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_PP_VERSION       OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_PP_KEY1          OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_PP_KEY2          OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_PP_KEY3          OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_PP_KEY4          OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_PP_KEY5          OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_DESCRIPTION      OUT    UNAPIGEN.VC40_TABLE_TYPE,    
 A_DELAY            OUT    UNAPIGEN.NUM_TABLE_TYPE,     
 A_DELAY_UNIT       OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_FREQ_TP          OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   
 A_FREQ_VAL         OUT    UNAPIGEN.NUM_TABLE_TYPE,     
 A_FREQ_UNIT        OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_INVERT_FREQ      OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   
 A_LAST_SCHED       OUT    UNAPIGEN.DATE_TABLE_TYPE,    
 A_LAST_CNT         OUT    UNAPIGEN.NUM_TABLE_TYPE,     
 A_LAST_VAL         OUT    UNAPIGEN.VC40_TABLE_TYPE,    
 A_INHERIT_AU       OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   
 A_NR_OF_ROWS       IN OUT NUMBER,                      
 A_WHERE_CLAUSE     IN     VARCHAR2)                    
RETURN NUMBER IS

L_RQ             VARCHAR2(20);
L_PP             VARCHAR2(20);
L_PP_VERSION     VARCHAR2(20);
L_PP_KEY1        VARCHAR2(20);
L_PP_KEY2        VARCHAR2(20);
L_PP_KEY3        VARCHAR2(20);
L_PP_KEY4        VARCHAR2(20);
L_PP_KEY5        VARCHAR2(20);
L_DESCRIPTION    VARCHAR2(40);
L_DELAY          NUMBER;
L_DELAY_UNIT     VARCHAR2(20);
L_FREQ_TP        CHAR(1);
L_FREQ_VAL       NUMBER;
L_FREQ_UNIT      VARCHAR2(20);
L_INVERT_FREQ    CHAR(1);
L_LAST_SCHED     TIMESTAMP WITH TIME ZONE;
L_LAST_CNT       NUMBER;
L_LAST_VAL       VARCHAR2(40);
L_INHERIT_AU     CHAR(1);
L_RQPP_CURSOR      INTEGER;

BEGIN

   IF NVL(A_NR_OF_ROWS,0) = 0 THEN
      A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
   ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
      RETURN(UNAPIGEN.DBERR_NROFROWS);
   END IF;

   IF NVL(A_WHERE_CLAUSE, ' ') = ' ' THEN
       RETURN(UNAPIGEN.DBERR_WHERECLAUSE);
   ELSIF
     UPPER(SUBSTR(A_WHERE_CLAUSE,1,6)) <> 'WHERE ' THEN
     L_WHERE_CLAUSE := 'WHERE rq = ''' || REPLACE(A_WHERE_CLAUSE, '''', '''''') || 
                       ''' ORDER BY seq';
   ELSE
      L_WHERE_CLAUSE := A_WHERE_CLAUSE; 
   END IF;

   L_RQPP_CURSOR := DBMS_SQL.OPEN_CURSOR;
   L_SQL_STRING := 'SELECT rq, pp, pp_version, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5, delay, delay_unit, freq_tp, freq_val,'||
                   'freq_unit, invert_freq, last_sched, last_cnt, last_val,' ||
                   'inherit_au ' ||
                   'FROM dd' || UNAPIGEN.P_DD || '.uvrqpp ' || L_WHERE_CLAUSE;

   DBMS_SQL.PARSE(L_RQPP_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 

   DBMS_SQL.DEFINE_COLUMN(L_RQPP_CURSOR,      1   , L_RQ,          20);
   DBMS_SQL.DEFINE_COLUMN(L_RQPP_CURSOR,      2   , L_PP,          20);
   DBMS_SQL.DEFINE_COLUMN(L_RQPP_CURSOR,      3   , L_PP_VERSION,  20);
   DBMS_SQL.DEFINE_COLUMN(L_RQPP_CURSOR,      4   , L_PP_KEY1,     20);
   DBMS_SQL.DEFINE_COLUMN(L_RQPP_CURSOR,      5   , L_PP_KEY2,     20);
   DBMS_SQL.DEFINE_COLUMN(L_RQPP_CURSOR,      6   , L_PP_KEY3,     20);
   DBMS_SQL.DEFINE_COLUMN(L_RQPP_CURSOR,      7   , L_PP_KEY4,     20);
   DBMS_SQL.DEFINE_COLUMN(L_RQPP_CURSOR,      8   , L_PP_KEY5,     20);
   DBMS_SQL.DEFINE_COLUMN(L_RQPP_CURSOR,      9   , L_DELAY);
   DBMS_SQL.DEFINE_COLUMN(L_RQPP_CURSOR,      10  , L_DELAY_UNIT,  20);
   DBMS_SQL.DEFINE_COLUMN_CHAR(L_RQPP_CURSOR, 11  , L_FREQ_TP,     1);
   DBMS_SQL.DEFINE_COLUMN(L_RQPP_CURSOR,      12  , L_FREQ_VAL);
   DBMS_SQL.DEFINE_COLUMN(L_RQPP_CURSOR,      13  , L_FREQ_UNIT,   20);
   DBMS_SQL.DEFINE_COLUMN_CHAR(L_RQPP_CURSOR, 14  , L_INVERT_FREQ, 1);
   DBMS_SQL.DEFINE_COLUMN(L_RQPP_CURSOR,      15  , L_LAST_SCHED);
   DBMS_SQL.DEFINE_COLUMN(L_RQPP_CURSOR,      16  , L_LAST_CNT);
   DBMS_SQL.DEFINE_COLUMN(L_RQPP_CURSOR,      17  , L_LAST_VAL,    40);
   DBMS_SQL.DEFINE_COLUMN_CHAR(L_RQPP_CURSOR, 18  , L_INHERIT_AU,  1);
   L_RESULT := DBMS_SQL.EXECUTE_AND_FETCH(L_RQPP_CURSOR);
   L_FETCHED_ROWS := 0;

   LOOP

      EXIT WHEN L_RESULT = 0 OR L_FETCHED_ROWS >= A_NR_OF_ROWS;

      DBMS_SQL.COLUMN_VALUE(L_RQPP_CURSOR,        1,   L_RQ);
      DBMS_SQL.COLUMN_VALUE(L_RQPP_CURSOR,        2,   L_PP);
      DBMS_SQL.COLUMN_VALUE(L_RQPP_CURSOR,        3,   L_PP_VERSION);
      DBMS_SQL.COLUMN_VALUE(L_RQPP_CURSOR,        4,   L_PP_KEY1);
      DBMS_SQL.COLUMN_VALUE(L_RQPP_CURSOR,        5,   L_PP_KEY2);
      DBMS_SQL.COLUMN_VALUE(L_RQPP_CURSOR,        6,   L_PP_KEY3);
      DBMS_SQL.COLUMN_VALUE(L_RQPP_CURSOR,        7,   L_PP_KEY4);
      DBMS_SQL.COLUMN_VALUE(L_RQPP_CURSOR,        8,   L_PP_KEY5);
      DBMS_SQL.COLUMN_VALUE(L_RQPP_CURSOR,        9,   L_DELAY);
      DBMS_SQL.COLUMN_VALUE(L_RQPP_CURSOR,        10,  L_DELAY_UNIT);
      DBMS_SQL.COLUMN_VALUE_CHAR(L_RQPP_CURSOR,   11,  L_FREQ_TP);
      DBMS_SQL.COLUMN_VALUE(L_RQPP_CURSOR,        12,  L_FREQ_VAL);
      DBMS_SQL.COLUMN_VALUE(L_RQPP_CURSOR,        13,  L_FREQ_UNIT);
      DBMS_SQL.COLUMN_VALUE_CHAR(L_RQPP_CURSOR,   14,  L_INVERT_FREQ);
      DBMS_SQL.COLUMN_VALUE(L_RQPP_CURSOR,        15,  L_LAST_SCHED);
      DBMS_SQL.COLUMN_VALUE(L_RQPP_CURSOR,        16,  L_LAST_CNT);
      DBMS_SQL.COLUMN_VALUE(L_RQPP_CURSOR,        17,  L_LAST_VAL);
      DBMS_SQL.COLUMN_VALUE_CHAR(L_RQPP_CURSOR,   18,  L_INHERIT_AU);

      L_FETCHED_ROWS                 :=  L_FETCHED_ROWS + 1;
      A_RQ(L_FETCHED_ROWS)           :=  L_RQ;
      A_PP(L_FETCHED_ROWS)           :=  L_PP;
      A_PP_VERSION(L_FETCHED_ROWS)   :=  L_PP_VERSION;
      A_PP_KEY1(L_FETCHED_ROWS)      :=  L_PP_KEY1;
      A_PP_KEY2(L_FETCHED_ROWS)      :=  L_PP_KEY2;
      A_PP_KEY3(L_FETCHED_ROWS)      :=  L_PP_KEY3;
      A_PP_KEY4(L_FETCHED_ROWS)      :=  L_PP_KEY4;
      A_PP_KEY5(L_FETCHED_ROWS)      :=  L_PP_KEY5;
      A_DELAY(L_FETCHED_ROWS)        :=  L_DELAY;
      A_DELAY_UNIT(L_FETCHED_ROWS)   :=  L_DELAY_UNIT;
      A_FREQ_TP (L_FETCHED_ROWS)     :=  L_FREQ_TP;
      A_FREQ_VAL (L_FETCHED_ROWS)    :=  L_FREQ_VAL;
      A_FREQ_UNIT (L_FETCHED_ROWS)   :=  L_FREQ_UNIT;
      A_INVERT_FREQ(L_FETCHED_ROWS)  :=  L_INVERT_FREQ;
      A_LAST_SCHED(L_FETCHED_ROWS)   :=  TO_CHAR(L_LAST_SCHED);
      A_LAST_CNT (L_FETCHED_ROWS)    :=  L_LAST_CNT;
      A_LAST_VAL (L_FETCHED_ROWS)    :=  L_LAST_VAL;
      A_INHERIT_AU(L_FETCHED_ROWS)   :=  L_INHERIT_AU;      

      L_DESCRIPTION := NULL;
      L_SQL_STRING:=   'SELECT description '
                     ||'FROM dd'||UNAPIGEN.P_DD||'.uvpp '
                     ||'WHERE version = NVL(UNAPIGEN.UsePpVersion(:l_pp,:l_pp_version,:l_pp_key1,:l_pp_key2,:l_pp_key3,:l_pp_key4,:l_pp_key5), '
                     ||                    'UNAPIGEN.UsePpVersion(:l_pp,''*'',:l_pp_key1,:l_pp_key2,:l_pp_key3,:l_pp_key4,:l_pp_key5)) '
                     ||'AND pp = :l_pp '
                     ||'AND pp_key1 = :l_pp_key1 '
                     ||'AND pp_key2 = :l_pp_key2 '
                     ||'AND pp_key3 = :l_pp_key3 '
                     ||'AND pp_key4 = :l_pp_key4 '
                     ||'AND pp_key5 = :l_pp_key5';
      BEGIN
         EXECUTE IMMEDIATE L_SQL_STRING 
         INTO L_DESCRIPTION
         USING L_PP, L_PP_VERSION, L_PP_KEY1, L_PP_KEY2, L_PP_KEY3, L_PP_KEY4, L_PP_KEY5,
               L_PP, L_PP_KEY1, L_PP_KEY2, L_PP_KEY3, L_PP_KEY4, L_PP_KEY5,
               L_PP, L_PP_KEY1, L_PP_KEY2, L_PP_KEY3, L_PP_KEY4, L_PP_KEY5;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            
            NULL;
      END;

      IF SQL%NOTFOUND THEN
         L_DESCRIPTION := L_PP;
      END IF;

      A_DESCRIPTION(L_FETCHED_ROWS) := L_DESCRIPTION;

      IF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
         L_RESULT := DBMS_SQL.FETCH_ROWS(L_RQPP_CURSOR);
      END IF;

   END LOOP;

   DBMS_SQL.CLOSE_CURSOR(L_RQPP_CURSOR);

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
             'GetRqParameterProfile', L_SQLERRM);
      UNAPIGEN.U4COMMIT;
      IF DBMS_SQL.IS_OPEN(L_RQPP_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_RQPP_CURSOR);
      END IF;
      RETURN(UNAPIGEN.DBERR_GENFAIL);
END GETRQPARAMETERPROFILE;

FUNCTION SAVERQPPATTRIBUTE                            
(A_RQ             IN        VARCHAR2,                 
 A_PP             IN        VARCHAR2,                 
 A_PP_VERSION     IN        VARCHAR2,                 
 A_AU             IN        UNAPIGEN.VC20_TABLE_TYPE, 
 A_AU_VERSION     IN        UNAPIGEN.VC20_TABLE_TYPE, 
 A_VALUE          IN        UNAPIGEN.VC40_TABLE_TYPE, 
 A_NR_OF_ROWS     IN        NUMBER,                   
 A_MODIFY_REASON  IN        VARCHAR2)                 
RETURN NUMBER IS

L_LOG_HS              CHAR(1);
L_LOG_HS_DETAILS      CHAR(1);
L_ACTIVE              CHAR(1);
L_LC                  VARCHAR2(2);
L_LC_VERSION          VARCHAR2(20);
L_SS                  VARCHAR2(2);
L_ALLOW_MODIFY        CHAR(1);
L_WHAT_DESCRIPTION    VARCHAR2(255);
L_HS_SEQ              INTEGER;
L_RT_VERSION          VARCHAR2(20);

CURSOR L_MODIFIEDPPAU_CURSOR IS
   
   (SELECT A.AU AU, A.AU_VERSION AU_VERSION, A.VALUE VALUE, 'DELETE' ACTION
    FROM UTRQPPAU A
    WHERE A.RQ = A_RQ
    AND A.PP = A_PP
    AND UNAPIGEN.USEPPVERSION(A.PP,A.PP_VERSION,A.PP_KEY1,A.PP_KEY2,A.PP_KEY3,A.PP_KEY4,A.PP_KEY5) = A_PP_VERSION 
    AND AUSEQ < 0
   MINUS
    SELECT A.AU AU, A.AU_VERSION AU_VERSION, A.VALUE VALUE, 'DELETE' ACTION
    FROM UTRQPPAU A
    WHERE A.RQ = A_RQ
    AND A.PP = A_PP
    AND UNAPIGEN.USEPPVERSION(A.PP,A.PP_VERSION,A.PP_KEY1,A.PP_KEY2,A.PP_KEY3,A.PP_KEY4,A.PP_KEY5) = A_PP_VERSION 
    AND AUSEQ > 0)
   UNION ALL
   
   (SELECT A.AU AU, A.AU_VERSION AU_VERSION, A.VALUE VALUE, 'NEW' ACTION
    FROM UTRQPPAU A
    WHERE A.RQ = A_RQ
    AND A.PP = A_PP
    AND UNAPIGEN.USEPPVERSION(A.PP,A.PP_VERSION,A.PP_KEY1,A.PP_KEY2,A.PP_KEY3,A.PP_KEY4,A.PP_KEY5) = A_PP_VERSION 
    AND AUSEQ > 0
   MINUS
    SELECT A.AU AU, A.AU_VERSION AU_VERSION, A.VALUE VALUE, 'NEW' ACTION
    FROM UTRQPPAU A
    WHERE A.RQ = A_RQ
    AND A.PP = A_PP
    AND UNAPIGEN.USEPPVERSION(A.PP,A.PP_VERSION,A.PP_KEY1,A.PP_KEY2,A.PP_KEY3,A.PP_KEY4,A.PP_KEY5) = A_PP_VERSION 
    AND AUSEQ < 0);

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_RQ, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   IF NVL(A_PP, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   L_RET_CODE := UNAPIAUT.GETRQAUTHORISATION(A_RQ, L_RT_VERSION, L_LC, L_LC_VERSION, L_SS, 
                                             L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS, L_LOG_HS_DETAILS);
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   UPDATE UTRQ
   SET ALLOW_MODIFY='#'
   WHERE RQ = A_RQ;
   




   L_EVENT_TP := 'RqPpAttributesUpdated';
   L_EV_SEQ_NR := -1;
   L_EV_DETAILS := 'rq=' || A_RQ ||
                   '#pp_version=' || A_PP_VERSION;
   L_RESULT := UNAPIEV.INSERTEVENT('SaveRqPpAttribute', UNAPIGEN.P_EVMGR_NAME, 'pp', A_PP, L_LC, 
                                   L_LC_VERSION, L_SS, L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;

   IF (L_LOG_HS = '1') THEN
       INSERT INTO UTRQHS(RQ, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
       VALUES(A_RQ, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
              'request "'||A_RQ||'" parameter profiles attributes are updated.', 
              CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
   END IF;

   L_HS_SEQ := 0;
   IF (L_LOG_HS_DETAILS = '1') THEN
       L_HS_SEQ := L_HS_SEQ + 1;
       INSERT INTO UTRQHSDETAILS(RQ, TR_SEQ, EV_SEQ, SEQ, DETAILS)
       VALUES(A_RQ, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_SEQ, 
              'request "'||A_RQ||'" parameter profiles attributes are updated.');
   END IF;

   
   
   
   UPDATE UTRQPPAU
   SET AUSEQ = -AUSEQ
   WHERE RQ = A_RQ
   AND PP = A_PP
   AND UNAPIGEN.USEPPVERSION(PP,PP_VERSION,PP_KEY1,PP_KEY2,PP_KEY3,PP_KEY4,PP_KEY5) = A_PP_VERSION; 

   FOR L_SEQ_NO IN 1..A_NR_OF_ROWS LOOP
      INSERT INTO UTRQPPAU(RQ, PP, PP_VERSION, AU, AUSEQ, VALUE)
      VALUES(A_RQ, A_PP, A_PP_VERSION, A_AU(L_SEQ_NO), L_SEQ_NO, A_VALUE(L_SEQ_NO));
   END LOOP;

   
   
      
   
   
   
   IF (L_LOG_HS_DETAILS = '1') THEN
      FOR L_PPAU_REC IN L_MODIFIEDPPAU_CURSOR LOOP
         IF L_PPAU_REC.ACTION = 'DELETE' THEN
            L_WHAT_DESCRIPTION := 'Attribute "'||L_PPAU_REC.AU||'" with value "'||L_PPAU_REC.VALUE||'" is removed from request "'||A_RQ||'", parameter profile "'||A_PP||'".';
         ELSE
            L_WHAT_DESCRIPTION := 'Attribute "'||L_PPAU_REC.AU||'" is added to request "'||A_RQ||'", parameter profile "'||A_PP||'", value is "'||L_PPAU_REC.VALUE||'".';
         END IF;
         L_HS_SEQ := L_HS_SEQ + 1;
         INSERT INTO UTRQHSDETAILS(RQ, TR_SEQ, EV_SEQ, SEQ, DETAILS)
         VALUES(A_RQ, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_SEQ, L_WHAT_DESCRIPTION);
      END LOOP;
   END IF;
  
   
   
   
   DELETE FROM UTRQPPAU
   WHERE RQ = A_RQ
   AND PP = A_PP
   AND UNAPIGEN.USEPPVERSION(PP,PP_VERSION,PP_KEY1,PP_KEY2,PP_KEY3,PP_KEY4,PP_KEY5) = A_PP_VERSION 
   AND AUSEQ < 0;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('SaveRqPpAttribute', SQLERRM);
   END IF;
   IF L_MODIFIEDPPAU_CURSOR%ISOPEN THEN
      CLOSE L_MODIFIEDPPAU_CURSOR;
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'SaveRqPpAttribute'));
END SAVERQPPATTRIBUTE;

FUNCTION GETRQPPATTRIBUTE                              
(A_RQ                 OUT   UNAPIGEN.VC20_TABLE_TYPE,  
 A_PP                 OUT   UNAPIGEN.VC20_TABLE_TYPE,  
 A_PP_VERSION         OUT   UNAPIGEN.VC20_TABLE_TYPE,  
 A_AU                 OUT   UNAPIGEN.VC20_TABLE_TYPE,  
 A_AU_VERSION         OUT   UNAPIGEN.VC20_TABLE_TYPE,  
 A_VALUE              OUT   UNAPIGEN.VC40_TABLE_TYPE,  
 A_DESCRIPTION        OUT   UNAPIGEN.VC40_TABLE_TYPE,  
 A_IS_PROTECTED       OUT   UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_SINGLE_VALUED      OUT   UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_NEW_VAL_ALLOWED    OUT   UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_STORE_DB           OUT   UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_VALUE_LIST_TP      OUT   UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_RUN_MODE           OUT   UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_SERVICE            OUT   UNAPIGEN.VC255_TABLE_TYPE, 
 A_CF_VALUE           OUT   UNAPIGEN.VC20_TABLE_TYPE,  
 A_NR_OF_ROWS         IN OUT NUMBER,                   
 A_WHERE_CLAUSE       IN     VARCHAR2)                 
RETURN NUMBER IS

L_AU              VARCHAR2(20);
L_AU_VERSION      VARCHAR2(20);
L_RQ              VARCHAR2(20);
L_PP              VARCHAR2(20);
L_PP_VERSION      VARCHAR2(20);
L_VALUE           VARCHAR2(40);
L_DESCRIPTION     VARCHAR2(40);
L_IS_PROTECTED    CHAR(1);
L_SINGLE_VALUED   CHAR(1);
L_NEW_VAL_ALLOWED CHAR(1);
L_STORE_DB        CHAR(1);
L_VALUE_LIST_TP   CHAR(1);
L_RUN_MODE        CHAR(1);
L_SERVICE         VARCHAR2(255);
L_CF_VALUE        VARCHAR2(20);
L_AU_CURSOR       INTEGER;

BEGIN
  IF NVL(A_NR_OF_ROWS,0) = 0 THEN
     A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
  ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
     RETURN(UNAPIGEN.DBERR_NROFROWS);
  END IF;

  IF NVL(A_WHERE_CLAUSE, ' ') = ' ' THEN
      RETURN(UNAPIGEN.DBERR_WHERECLAUSE);
  ELSIF
     UPPER(SUBSTR(A_WHERE_CLAUSE,1,6)) <> 'WHERE ' THEN
     L_WHERE_CLAUSE := 'WHERE rq = ''' || REPLACE(A_WHERE_CLAUSE, '''', '''''') || 
                       ''' ORDER BY pp, auseq';
  ELSE
     L_WHERE_CLAUSE := A_WHERE_CLAUSE; 
  END IF;

  L_SQL_STRING := 'SELECT rq, pp, pp_version, au, au_version, value FROM dd' ||
                   UNAPIGEN.P_DD || '.uvrqppau ' || L_WHERE_CLAUSE;

  L_AU_CURSOR := DBMS_SQL.OPEN_CURSOR;
  DBMS_SQL.PARSE(L_AU_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 

  DBMS_SQL.DEFINE_COLUMN(L_AU_CURSOR, 1, L_RQ, 20);
  DBMS_SQL.DEFINE_COLUMN(L_AU_CURSOR, 2, L_PP, 20);
  DBMS_SQL.DEFINE_COLUMN(L_AU_CURSOR, 3, L_PP_VERSION, 20);
  DBMS_SQL.DEFINE_COLUMN(L_AU_CURSOR, 4, L_AU, 20);
  DBMS_SQL.DEFINE_COLUMN(L_AU_CURSOR, 5, L_AU_VERSION, 20);
  DBMS_SQL.DEFINE_COLUMN(L_AU_CURSOR, 6, L_VALUE, 40);
  L_RESULT := DBMS_SQL.EXECUTE(L_AU_CURSOR);

  L_FETCHED_ROWS := 0;

  LOOP
     IF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
        L_RESULT := DBMS_SQL.FETCH_ROWS(L_AU_CURSOR);
     END IF;

     EXIT WHEN L_RESULT = 0 OR L_FETCHED_ROWS >= A_NR_OF_ROWS;
     DBMS_SQL.COLUMN_VALUE(L_AU_CURSOR, 1, L_RQ);
     DBMS_SQL.COLUMN_VALUE(L_AU_CURSOR, 2, L_PP);
     DBMS_SQL.COLUMN_VALUE(L_AU_CURSOR, 3, L_PP_VERSION);
     DBMS_SQL.COLUMN_VALUE(L_AU_CURSOR, 4, L_AU);
     DBMS_SQL.COLUMN_VALUE(L_AU_CURSOR, 5, L_AU_VERSION);
     DBMS_SQL.COLUMN_VALUE(L_AU_CURSOR, 6, L_VALUE);

     L_FETCHED_ROWS := L_FETCHED_ROWS + 1;

     A_RQ(L_FETCHED_ROWS) := L_RQ;
     A_PP(L_FETCHED_ROWS) := L_PP;
     A_PP_VERSION(L_FETCHED_ROWS) := L_PP_VERSION;
     A_AU(L_FETCHED_ROWS) := L_AU;
     A_AU_VERSION(L_FETCHED_ROWS) := L_AU_VERSION;
     A_VALUE(L_FETCHED_ROWS) := L_VALUE;

      L_SQL_STRING:=   'SELECT description, is_protected, single_valued, new_val_allowed, store_db, '
                     ||'value_list_tp, run_mode, service, cf_value '
                     ||'FROM dd'||UNAPIGEN.P_DD||'.uvau '
                     ||'WHERE version = NVL(UNAPIGEN.UseVersion(''au'',:l_au,:l_au_version), '
                     ||                    'UNAPIGEN.UseVersion(''au'',:l_au,''*'')) '
                     ||'AND au = :l_au';
      BEGIN
         EXECUTE IMMEDIATE L_SQL_STRING 
         INTO L_DESCRIPTION, L_IS_PROTECTED, L_SINGLE_VALUED, L_NEW_VAL_ALLOWED, L_STORE_DB,
              L_VALUE_LIST_TP, L_RUN_MODE, L_SERVICE, L_CF_VALUE
         USING L_AU, L_AU_VERSION, L_AU, L_AU;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            
            NULL;
      END;

     IF SQL%NOTFOUND THEN
        
        
        
        A_DESCRIPTION(L_FETCHED_ROWS)     := L_AU;
        A_IS_PROTECTED(L_FETCHED_ROWS)    := '1';
        A_SINGLE_VALUED(L_FETCHED_ROWS)   := '1';
        A_NEW_VAL_ALLOWED(L_FETCHED_ROWS) := '0';
        A_STORE_DB(L_FETCHED_ROWS)        := '0';
        A_VALUE_LIST_TP(L_FETCHED_ROWS)   := 'E';
        A_RUN_MODE(L_FETCHED_ROWS)        := 'H';
        A_SERVICE(L_FETCHED_ROWS)         := NULL;
        A_CF_VALUE(L_FETCHED_ROWS)        := NULL;
     ELSE
        A_DESCRIPTION(L_FETCHED_ROWS) := L_DESCRIPTION;
        A_IS_PROTECTED(L_FETCHED_ROWS) := L_IS_PROTECTED;
        A_SINGLE_VALUED(L_FETCHED_ROWS) := L_SINGLE_VALUED;
        A_NEW_VAL_ALLOWED(L_FETCHED_ROWS) := L_NEW_VAL_ALLOWED;
        A_STORE_DB(L_FETCHED_ROWS) := L_STORE_DB;
        A_VALUE_LIST_TP(L_FETCHED_ROWS) := L_VALUE_LIST_TP;
        A_RUN_MODE(L_FETCHED_ROWS) := L_RUN_MODE;
        A_SERVICE(L_FETCHED_ROWS) := L_SERVICE;
        A_CF_VALUE(L_FETCHED_ROWS) := L_CF_VALUE;
     END IF;
  END LOOP;

  DBMS_SQL.CLOSE_CURSOR(L_AU_CURSOR);

  IF L_FETCHED_ROWS = 0 THEN
     L_RET_CODE := UNAPIGEN.DBERR_NORECORDS;
  ELSE
     L_RET_CODE := UNAPIGEN.DBERR_SUCCESS;
     A_NR_OF_ROWS := L_FETCHED_ROWS;
  END IF;

  RETURN(L_RET_CODE);

EXCEPTION
  WHEN OTHERS THEN
     L_SQLERRM := SQLERRM;
     UNAPIGEN.U4ROLLBACK;
     INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
     VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 
            'GetRqPpAttribute', L_SQLERRM);
     UNAPIGEN.U4COMMIT;
      IF DBMS_SQL.IS_OPEN(L_AU_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_AU_CURSOR);
      END IF;
     RETURN(UNAPIGEN.DBERR_GENFAIL);
END GETRQPPATTRIBUTE;

FUNCTION COPYRQSAMPLINGDETAILS                         
(A_RQ_FROM             IN        VARCHAR2,             
 A_RT_TO               IN        VARCHAR2,             
 A_RT_TO_VERSION       IN OUT    VARCHAR2,              
 A_RQ_TO               IN        VARCHAR2,             
 A_REF_DATE            IN        DATE,                 
 A_COPY_SCIC           IN        VARCHAR2,             
 A_COPY_SCPG           IN        VARCHAR2,             
 A_USERID              IN        VARCHAR2,             
 A_MODIFY_REASON       IN        VARCHAR2)             
RETURN NUMBER IS

L_ERRM                    VARCHAR2(255);
L_SC_FROM                 VARCHAR2(20);
L_ST_TO                   VARCHAR2(20);
L_ST_TO_VERSION           VARCHAR2(20);
L_SC_TO                   VARCHAR2(20);
L_LOG_HS_RQ               CHAR(1);
L_LOG_HS_DETAILS_RQ       CHAR(1);
L_HS_DETAILS_SEQ_NR       INTEGER;
L_FIELDTYPE_TAB        UNAPIGEN.VC20_TABLE_TYPE;
L_FIELDNAMES_TAB       UNAPIGEN.VC20_TABLE_TYPE;
L_FIELDVALUES_TAB      UNAPIGEN.VC40_TABLE_TYPE;
L_FIELDNR_OF_ROWS      NUMBER;
L_EDIT_ALLOWED         CHAR(1);
L_VALID_CF             VARCHAR2(20);

   
CURSOR L_RQSC_CURSOR(A_RQ VARCHAR2) IS
   SELECT A.SC, A.SEQ, B.ST, B.ST_VERSION
   FROM UTRQSC A, UTSC B
   WHERE A.RQ = A_RQ
   AND B.SC = A.SC
   ORDER BY A.SEQ;

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   
   IF NVL(A_RQ_FROM, ' ') = ' ' OR
      NVL(A_RT_TO, ' ') = ' ' OR
      NVL(A_RQ_TO, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   
   L_ERRM := NULL;

   
   FOR L_RQSC_REC IN L_RQSC_CURSOR(A_RQ_FROM) LOOP
   
      L_SC_FROM := L_RQSC_REC.SC ;
      L_ST_TO := L_RQSC_REC.ST ;
      L_ST_TO_VERSION := L_RQSC_REC.ST_VERSION ;

      L_FIELDNR_OF_ROWS := 0;
      L_FIELDNR_OF_ROWS := L_FIELDNR_OF_ROWS + 1;
      L_FIELDTYPE_TAB(L_FIELDNR_OF_ROWS) := 'rq';
      L_FIELDNAMES_TAB(L_FIELDNR_OF_ROWS) := 'rq';
      L_FIELDVALUES_TAB(L_FIELDNR_OF_ROWS) := A_RQ_TO;

      L_FIELDNR_OF_ROWS := L_FIELDNR_OF_ROWS + 1;
      L_FIELDTYPE_TAB(L_FIELDNR_OF_ROWS) := 'rt';
      L_FIELDNAMES_TAB(L_FIELDNR_OF_ROWS) := 'rt';
      L_FIELDVALUES_TAB(L_FIELDNR_OF_ROWS) := A_RT_TO;

      L_FIELDNR_OF_ROWS := L_FIELDNR_OF_ROWS + 1;
      L_FIELDTYPE_TAB(L_FIELDNR_OF_ROWS) := 'rt';
      L_FIELDNAMES_TAB(L_FIELDNR_OF_ROWS) := 'rt_version';
      L_FIELDVALUES_TAB(L_FIELDNR_OF_ROWS) := A_RT_TO_VERSION;


      L_RET_CODE := UNAPIRQ.GENERATERQSAMPLECODE(A_RT_TO, A_RT_TO_VERSION, A_REF_DATE, A_RQ_TO, L_ST_TO, L_ST_TO_VERSION,
                                                 L_FIELDTYPE_TAB, L_FIELDNAMES_TAB, L_FIELDVALUES_TAB, L_FIELDNR_OF_ROWS,
                                                 L_SC_TO, L_EDIT_ALLOWED, L_VALID_CF);

      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         L_ERRM := 'rt=' || A_RT_TO || 
                   '#rt_version=' || A_RT_TO_VERSION || 
                   '#rq='|| A_RQ_TO ||
                   '#st='|| L_ST_TO || 
                   '#st_version=' || L_ST_TO_VERSION || 
                   '#ref_date='|| A_REF_DATE || 
                   '#GenerateRqSampleCode#ErrorCode=' || TO_CHAR(L_RET_CODE);
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
         RAISE STPERROR;
      END IF;

      
      L_RET_CODE := UNAPISC.COPYSAMPLE(L_SC_FROM, L_ST_TO, L_ST_TO_VERSION, L_SC_TO,
                       A_REF_DATE, A_COPY_SCIC, A_COPY_SCPG, A_USERID, A_MODIFY_REASON);
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
         L_ERRM  := 'sc_from=' || L_SC_FROM || 
                    '#st_to=' || L_ST_TO ||
                    '#st_to_version=' || L_ST_TO_VERSION ||
                    '#sc_to=' || L_SC_TO ||
                    '#CopySample#ErrorCode=' || TO_CHAR(L_RET_CODE);
         RAISE STPERROR;
      END IF;

      
      INSERT INTO UTRQSC (RQ, SC, SEQ, ASSIGN_DATE, ASSIGN_DATE_TZ, ASSIGNED_BY)
      VALUES ( A_RQ_TO, L_SC_TO, L_RQSC_REC.SEQ, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, NVL(A_USERID, UNAPIGEN.P_USER) ) ;

      UPDATE UTSC 
      SET RQ = A_RQ_TO
      WHERE SC = L_SC_TO;

      
      L_RET_CODE := UNAPISC.UPDATELINKEDSCII(L_SC_TO, 'rq', '1', '', '', '',
                                             '', '', '',
                                             '', '', '',
                                             '', '', '',
                                             '', '', A_RQ_TO, '',
                                             '', '', '', '', '',
                                             '', '');
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
         RAISE STPERROR;
      END IF;
   END LOOP;

   
   UPDATE UTRQ
      SET SC_COUNTER = (SELECT COUNT(*) FROM UTRQSC WHERE RQ = A_RQ_TO)
    WHERE RQ = A_RQ_TO;

   BEGIN
      SELECT LOG_HS, LOG_HS_DETAILS
      INTO L_LOG_HS_RQ, L_LOG_HS_DETAILS_RQ
      FROM UTRQ
      WHERE RQ = A_RQ_TO;
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      RAISE STPERROR;
   END;

   L_RET_CODE := UNAPIGEN.GETNEXTEVENTSEQNR(L_EV_SEQ_NR);
   IF L_RET_CODE <> 0 THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;
   L_EVENT_TP := 'RqSamplingDetailsCreated';

   IF NVL(L_LOG_HS_RQ, ' ') = '1' THEN
      INSERT INTO UTRQHS(RQ, WHO, WHO_DESCRIPTION, WHAT, 
                         WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
      VALUES (A_RQ_TO, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
              'request "'||A_RQ_TO||'" sampling details are created.', 
              CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
   END IF;
   
   L_HS_DETAILS_SEQ_NR := 0;
   IF NVL(L_LOG_HS_DETAILS_RQ, ' ') = '1' THEN
      L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
      INSERT INTO UTRQHSDETAILS(RQ, TR_SEQ, EV_SEQ, SEQ, DETAILS)
      VALUES (A_RQ_TO, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR,
              'request "'||A_RQ_TO||'" sampling details are created.');
   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('CopyRqSamplingDetails', SQLERRM);
   ELSIF L_ERRM IS NOT NULL THEN
      UNAPIGEN.LOGERROR('CopyRqSamplingDetails', L_ERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'CopyRqSamplingDetails'));
END COPYRQSAMPLINGDETAILS;

FUNCTION COPYREQUEST                 
(A_RQ_FROM         IN     VARCHAR2,  
 A_RT_TO           IN     VARCHAR2,  
 A_RT_TO_VERSION   IN OUT VARCHAR2,   
 A_RQ_TO           IN OUT VARCHAR2,  
 A_REF_DATE        IN     DATE,      
 A_COPY_IC         IN     VARCHAR2,  
 A_COPY_SC         IN     VARCHAR2,  
 A_COPY_SCIC       IN     VARCHAR2,  
 A_COPY_SCPG       IN     VARCHAR2,  
 A_USERID          IN     VARCHAR2,  
 A_MODIFY_REASON   IN     VARCHAR2)  
RETURN NUMBER IS

L_RT_TO                VARCHAR2(20);
L_RT_TO_VERSION        VARCHAR2(20);
L_RT_ACTIVE            CHAR(1);
L_SAMPLING_DATE        TIMESTAMP WITH TIME ZONE;
L_REF_DATE             TIMESTAMP WITH TIME ZONE;
L_RETRIES              INTEGER;
L_FIELDNR_OF_ROWS      NUMBER;
L_FIELDTYPE_TAB        UNAPIGEN.VC20_TABLE_TYPE;
L_FIELDNAMES_TAB       UNAPIGEN.VC20_TABLE_TYPE;
L_FIELDVALUES_TAB      UNAPIGEN.VC40_TABLE_TYPE;
L_EDIT_ALLOWED         CHAR(1);
L_VALID_CF             VARCHAR2(20);
L_RT_VERSION           VARCHAR2(20);
L_LC                   VARCHAR2(2);
L_LC_VERSION           VARCHAR2(20);
L_SS                   VARCHAR2(2);
L_ALLOW_MODIFY         CHAR(1);
L_ACTIVE               CHAR(1);
L_LOG_HS               CHAR(1);
L_LOG_HS_DETAILS       CHAR(1);
L_RT_REC               UTRT%ROWTYPE;
L_COPY_SC              VARCHAR2(40);
L_RQ_CLASS             VARCHAR2(2);
L_HS_DETAILS_SEQ_NR    INTEGER;
L_RQ_TO_GK_CURSOR      INTEGER;
L_ST_TO                VARCHAR2(20);
L_ST_TO_VERSION        VARCHAR2(20);
L_EVMGR_NAME            VARCHAR2(20);
L_COPY_EVENT_MGR        VARCHAR2(20);

CURSOR L_RQ_RT_CURSOR(A_RQ_FROM VARCHAR2) IS
   SELECT RT, RT_VERSION
   FROM UTRQ
   WHERE RQ = A_RQ_FROM;

CURSOR L_RT_ACTIVE_CURSOR(A_RT VARCHAR2, A_RT_VERSION VARCHAR2) IS
   SELECT ACTIVE
   FROM UTRT
   WHERE RT = A_RT
   AND VERSION = A_RT_VERSION;

CURSOR L_RQ_FROM_GK_CURSOR(A_RQ_FROM VARCHAR2) IS
   SELECT GK, GKSEQ, VALUE
   FROM UTRQGK
   WHERE RQ = A_RQ_FROM;

CURSOR L_ALLRQIC_CURSOR(A_RQ VARCHAR2) IS
   SELECT IC, ICNODE
   FROM UTRQIC
   WHERE RQ = A_RQ
   ORDER BY ICNODE;












CURSOR L_RQIC_POS_CURSOR(A_RQ_FROM VARCHAR2, A_RQ_TO VARCHAR2, A_IC VARCHAR2) IS
   SELECT A.IC_TO, A.ICNODE_TO, B.IC_FROM, B.ICNODE_FROM 
   FROM (SELECT IC IC_TO, ICNODE ICNODE_TO, ROWNUM POSITION
         FROM (SELECT IC, ICNODE 
               FROM UTRQIC
               WHERE RQ = A_RQ_TO 
               AND IC = A_IC
               GROUP BY IC,ICNODE)) A,
        (SELECT IC IC_FROM, ICNODE ICNODE_FROM, ROWNUM POSITION
         FROM (SELECT IC,ICNODE 
               FROM UTRQIC
               WHERE RQ = A_RQ_FROM
               AND IC = A_IC
               GROUP BY IC,ICNODE)) B
   WHERE A.POSITION = B.POSITION(+);
L_RQIC_POS_REC     L_RQIC_POS_CURSOR%ROWTYPE;    
L_RQIC_POS_FOUND   BOOLEAN;    

CURSOR L_OBJECTS_CURSOR(A_OBJECT_TYPE VARCHAR2) IS
   SELECT LOG_HS
   FROM UTOBJECTS
   WHERE OBJECT = A_OBJECT_TYPE;

CURSOR L_ALLRQSC_CURSOR(A_RQ VARCHAR2) IS
   SELECT SC, SEQ
   FROM UTRQSC
   WHERE RQ = A_RQ
   ORDER BY SEQ;

CURSOR L_SC_CURSOR(A_SC VARCHAR2) IS
   SELECT ST, ST_VERSION
   FROM UTSC
   WHERE SC = A_SC;












CURSOR L_RQSC_POS_CURSOR(A_RQ_FROM VARCHAR2, A_RQ_TO VARCHAR2, 
                         A_ST_TO VARCHAR2, A_ST_TO_VERSION VARCHAR2) IS
SELECT A.SC_TO, A.SEQ_TO, B.SC_FROM, B.SEQ_FROM 
FROM (SELECT SC SC_TO, SEQ SEQ_TO, ROWNUM POSITION
      FROM (SELECT C.SC, C.SEQ 
            FROM UTRQSC C, UTSC D
            WHERE C.RQ = A_RQ_TO
            AND C.SC = D.SC
            AND D.ST = A_ST_TO
            AND D.ST_VERSION = A_ST_TO_VERSION
            GROUP BY C.SC, C.SEQ)) A,
     (SELECT SC SC_FROM, SEQ SEQ_FROM, ROWNUM POSITION
      FROM (SELECT C.SC, C.SEQ 
            FROM UTRQSC C, UTSC D
            WHERE C.RQ = A_RQ_FROM
            AND C.SC = D.SC
            AND D.ST = A_ST_TO
            AND D.ST_VERSION = A_ST_TO_VERSION
            GROUP BY C.SC, C.SEQ)) B
WHERE A.POSITION = B.POSITION(+);
L_RQSC_POS_REC     L_RQSC_POS_CURSOR%ROWTYPE;    
L_RQSC_POS_FOUND   BOOLEAN;    

CURSOR L_ALLSCIC_CURSOR(A_SC VARCHAR2) IS
   SELECT IC, ICNODE
   FROM UTSCIC
   WHERE SC = A_SC
   ORDER BY ICNODE;












CURSOR L_SCIC_POS_CURSOR(A_SC_FROM VARCHAR2, A_SC_TO VARCHAR2, A_IC VARCHAR2) IS
SELECT A.IC_TO, A.ICNODE_TO, B.IC_FROM, B.ICNODE_FROM 
FROM (SELECT IC IC_TO, ICNODE ICNODE_TO, ROWNUM POSITION
      FROM (SELECT IC,ICNODE FROM UTSCIC
            WHERE SC = A_SC_TO 
            AND IC = A_IC
            GROUP BY IC,ICNODE)) A,
     (SELECT IC IC_FROM, ICNODE ICNODE_FROM, ROWNUM POSITION
      FROM (SELECT IC,ICNODE FROM UTSCIC
            WHERE SC = A_SC_FROM
            AND IC = A_IC
            GROUP BY IC,ICNODE)) B
WHERE A.POSITION = B.POSITION(+);
L_SCIC_POS_REC     L_SCIC_POS_CURSOR%ROWTYPE;    
L_SCIC_POS_FOUND   BOOLEAN;    

CURSOR L_ALLSCPG_CURSOR(A_SC VARCHAR2) IS
   SELECT PG, PGNODE
   FROM UTSCPG
   WHERE SC = A_SC
   ORDER BY PGNODE;












CURSOR L_SCPG_POS_CURSOR(A_SC_FROM VARCHAR2, A_SC_TO VARCHAR2, A_PG VARCHAR2) IS
SELECT A.PG_TO, A.PGNODE_TO, B.PG_FROM, B.PGNODE_FROM 
FROM (SELECT PG PG_TO, PGNODE PGNODE_TO, ROWNUM POSITION
      FROM (SELECT PG,PGNODE FROM UTSCPG
            WHERE SC = A_SC_TO 
            AND PG = A_PG
            GROUP BY PG,PGNODE)) A,
     (SELECT PG PG_FROM, PGNODE PGNODE_FROM, ROWNUM POSITION
      FROM (SELECT PG,PGNODE FROM UTSCPG
            WHERE SC = A_SC_FROM
            AND PG = A_PG
            GROUP BY PG,PGNODE)) B
WHERE A.POSITION = B.POSITION(+);
L_SCPG_POS_REC     L_SCPG_POS_CURSOR%ROWTYPE;    
L_SCPG_POS_FOUND   BOOLEAN;    

BEGIN

   BEGIN
      SELECT SETTING_VALUE
      INTO L_COPY_EVENT_MGR
      FROM UTSYSTEM
      WHERE SETTING_NAME = 'COPY_EVENT_MGR';
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
      L_COPY_EVENT_MGR := 'U4EVMGR' ; 
   END;

   L_EVMGR_NAME := UNAPIGEN.P_EVMGR_NAME;
   UNAPIGEN.P_EVMGR_NAME := L_COPY_EVENT_MGR;

   
   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   
   L_SQLERRM := '';
   
   
   IF NVL(A_RQ_FROM, ' ') = ' ' THEN
      L_RET_CODE := UNAPIGEN.DBERR_NOOBJID;
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   IF NVL(A_COPY_IC, ' ') NOT IN 
     ('CREATE IC', 'CREATE IC COPY IIVALUE', 'COPY IC', 'COPY IC COPY IIVALUE') THEN
     L_SQLERRM:= 'copy_ic has illegal value';
     UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_COPYIC;
     RAISE STPERROR;
   END IF;

   IF NVL(A_COPY_SC, ' ') NOT IN 
     ('CREATE SC', 'CREATE SC COPY PGVALUE', 'CREATE SC COPY IIVALUE', 
      'CREATE SC COPY PGVALUE COPY IIVALUE', 'CREATE SC COPY IIVALUE COPY PGVALUE',
      'COPY SC', 'WHEN INFO AVAILABLE') THEN
      
      
     UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_COPYSC;
     L_SQLERRM:= 'copy_sc has illegal value';
     RAISE STPERROR;
   END IF;
   
   IF A_RT_TO IS NOT NULL THEN
      A_RT_TO_VERSION := UNAPIGEN.VALIDATEVERSION('rt', A_RT_TO, A_RT_TO_VERSION);
      L_RT_TO         := A_RT_TO;
      L_RT_TO_VERSION := A_RT_TO_VERSION;
   ELSE
      
      OPEN L_RQ_RT_CURSOR(A_RQ_FROM);
      FETCH L_RQ_RT_CURSOR
      INTO L_RT_TO, L_RT_TO_VERSION;
      IF L_RQ_RT_CURSOR%NOTFOUND THEN
         CLOSE L_RQ_RT_CURSOR;
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
         L_SQLERRM:= 'request a_rq_from='||A_RQ_FROM||' does not exist';
         RAISE STPERROR;
      END IF;
      CLOSE L_RQ_RT_CURSOR;

      
      L_RT_ACTIVE := '0';
      OPEN L_RT_ACTIVE_CURSOR(L_RT_TO, L_RT_TO_VERSION);
      FETCH L_RT_ACTIVE_CURSOR
      INTO L_RT_ACTIVE;
      IF L_RT_ACTIVE_CURSOR%NOTFOUND THEN
         CLOSE L_RT_ACTIVE_CURSOR;
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
         L_SQLERRM:= 'request type rt='||L_RT_TO||'#version='||L_RT_TO_VERSION||' does not exist';
         RAISE STPERROR;
      END IF;
      CLOSE L_RT_ACTIVE_CURSOR;

      IF L_RT_ACTIVE = '0' THEN
         
         L_RT_TO_VERSION := NULL;
         A_RT_TO_VERSION := UNAPIGEN.VALIDATEVERSION('rt', L_RT_TO, L_RT_TO_VERSION);
      ELSE
         A_RT_TO_VERSION := L_RT_TO_VERSION;
      END IF;
   END IF;   
   
   
      
   
   
   IF A_REF_DATE IS NULL THEN
      L_SAMPLING_DATE := NULL;
      L_REF_DATE      := NULL;
   ELSE
      L_SAMPLING_DATE := A_REF_DATE;
      L_REF_DATE      := A_REF_DATE;
   END IF;

   
   L_RETRIES := UNAPIEV.P_RETRIESWHENINTRANSITION;
   LOOP
      L_RET_CODE := UNAPIRQP.ISREQUESTNOTINTRANSITION(A_RQ_FROM);
      EXIT WHEN L_RET_CODE <> UNAPIGEN.DBERR_TRANSITION;
      EXIT WHEN L_RETRIES <= 0;
      L_RETRIES := L_RETRIES - 1;
      DBMS_LOCK.SLEEP(UNAPIEV.P_INTERVALWHENINTRANSITION);
   END LOOP;
   
   IF L_RET_CODE = UNAPIGEN.DBERR_TRANSITION THEN
      L_SQLERRM := 'Request to copy from (rq='||A_RQ_FROM||')is in transition';
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
      RAISE STPERROR;
   ELSIF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      L_SQLERRM := 'UNAPISCP.IsRequestNotInTransition returned='||L_RET_CODE;
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
      RAISE STPERROR;
   END IF;

   
   
   L_FIELDNR_OF_ROWS := 0;
   IF NVL(A_RQ_TO, ' ') = ' ' THEN
      L_RET_CODE := UNAPIRQ.GENERATEREQUESTCODE(L_RT_TO, L_RT_TO_VERSION, L_REF_DATE, 
                                                L_FIELDTYPE_TAB, L_FIELDNAMES_TAB, 
                                                L_FIELDVALUES_TAB, L_FIELDNR_OF_ROWS,
                                                A_RQ_TO, L_EDIT_ALLOWED, L_VALID_CF);
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
         RAISE STPERROR;
      END IF;
   END IF;

   
   
   
   L_RT_VERSION := L_RT_TO_VERSION;
   L_RET_CODE := UNAPIAUT.GETRQAUTHORISATION(A_RQ_TO, L_RT_VERSION, L_LC, L_LC_VERSION, L_SS,
                                             L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS, L_LOG_HS_DETAILS);
   IF L_RET_CODE <> UNAPIGEN.DBERR_NOOBJECT THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_RQALREADYEXIST;
      RAISE STPERROR;
   END IF;

   
   
   
   
   
   
   

   IF (NVL(L_RT_TO, ' ') <> ' ') AND (NVL(L_RT_TO_VERSION, ' ') <> ' ') THEN
      BEGIN
         SELECT *
         INTO L_RT_REC
         FROM UTRT
         WHERE RT = L_RT_TO
           AND VERSION = L_RT_TO_VERSION;
         L_RT_REC.RQ_LC_VERSION := UNAPIGEN.USEVERSION('lc', L_RT_REC.RQ_LC, L_RT_REC.RQ_LC_VERSION);
           
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
         RAISE STPERROR;
      END;
   END IF;
   
   
   L_COPY_SC := A_COPY_SC;
   IF NVL(L_COPY_SC, 'ON REQUEST CREATION') = 'WHEN INFO AVAILABLE' THEN
      L_RQ_CLASS := '1';
   ELSIF (NVL(L_RT_TO, ' ') <> ' ') AND (NVL(L_RT_TO_VERSION, ' ') <> ' ') THEN 
      L_RQ_CLASS := L_RT_REC.RT_CLASS;
   ELSE
      L_RQ_CLASS := NULL;
   END IF;

   
   
   IF (NVL(L_RT_TO, ' ') <> ' ') AND (NVL(L_RT_TO_VERSION, ' ') <> ' ') THEN
      INSERT INTO UTRQ(RQ, RT, RT_VERSION, DESCRIPTION, SAMPLING_DATE, SAMPLING_DATE_TZ, CREATION_DATE, CREATION_DATE_TZ, CREATED_BY,
                       PRIORITY, LABEL_FORMAT, DESCR_DOC, DESCR_DOC_VERSION, RQ_CLASS, LOG_HS, 
                       LOG_HS_DETAILS, ALLOW_MODIFY, ACTIVE,  LC, LC_VERSION, 
                       ALLOW_ANY_ST, ALLOW_NEW_SC)
      VALUES(A_RQ_TO, L_RT_TO, L_RT_TO_VERSION, L_RT_REC.DESCRIPTION, L_SAMPLING_DATE, L_SAMPLING_DATE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
             NVL(A_USERID,UNAPIGEN.P_USER), L_RT_REC.PRIORITY, L_RT_REC.LABEL_FORMAT, 
             L_RT_REC.DESCR_DOC, L_RT_REC.DESCR_DOC_VERSION, L_RQ_CLASS, L_LOG_HS, 
             L_LOG_HS_DETAILS, '#', '0', L_RT_REC.RQ_LC, L_RT_REC.RQ_LC_VERSION,
             L_RT_REC.ALLOW_ANY_ST,L_RT_REC.ALLOW_NEW_SC);
       UNAPIAUT.UPDATELCINAUTHORISATIONBUFFER('rq', A_RQ_TO , '', L_RT_REC.RQ_LC, L_RT_REC.RQ_LC_VERSION);                 
   ELSE
      INSERT INTO UTRQ(RQ, SAMPLING_DATE, SAMPLING_DATE_TZ, CREATION_DATE, CREATION_DATE_TZ, CREATED_BY, RQ_CLASS, LOG_HS, 
                       LOG_HS_DETAILS, ALLOW_MODIFY, ACTIVE, LC, LC_VERSION, 
                       ALLOW_ANY_ST, ALLOW_NEW_SC)
      VALUES(A_RQ_TO, L_SAMPLING_DATE, L_SAMPLING_DATE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, NVL(A_USERID,UNAPIGEN.P_USER), L_RQ_CLASS, 
             L_LOG_HS, L_LOG_HS_DETAILS, '#', '0', '', '', '1', '1');
   END IF;

   
   
   
   INSERT INTO UTRQAU(RQ, AU, AUSEQ, VALUE)
   SELECT A_RQ_TO, AU, AUSEQ, VALUE
   FROM UTRQAU
   WHERE RQ = A_RQ_FROM;   
   
   
   IF INSTR(A_COPY_SC, 'COPY SC') <> 0 THEN   
      INSERT INTO UTRQPP
      (RQ, PP, PP_VERSION, PP_KEY1, PP_KEY2, PP_KEY3, PP_KEY4, PP_KEY5,
       SEQ, DELAY, DELAY_UNIT, FREQ_TP, FREQ_VAL, FREQ_UNIT, INVERT_FREQ,
       LAST_SCHED, LAST_SCHED_TZ, LAST_CNT, LAST_VAL, INHERIT_AU)
      SELECT A_RQ_TO, PP, PP_VERSION, PP_KEY1, PP_KEY2, PP_KEY3, PP_KEY4, PP_KEY5,
             SEQ, DELAY, DELAY_UNIT, FREQ_TP, FREQ_VAL, FREQ_UNIT, INVERT_FREQ,
             LAST_SCHED, LAST_SCHED_TZ, LAST_CNT, LAST_VAL, INHERIT_AU
      FROM UTRQPP
      WHERE RQ = A_RQ_FROM;   
   ELSIF INSTR(A_COPY_SC, 'CREATE SC') <> 0 THEN   
      INSERT INTO UTRQPP
            (RQ, PP, PP_VERSION, PP_KEY1, PP_KEY2, PP_KEY3, PP_KEY4, PP_KEY5,
             SEQ, DELAY, DELAY_UNIT, FREQ_TP, FREQ_VAL, FREQ_UNIT, INVERT_FREQ,
             LAST_SCHED, LAST_SCHED_TZ, LAST_CNT, LAST_VAL, INHERIT_AU)
      SELECT A_RQ_TO, PP, PP_VERSION, PP_KEY1, PP_KEY2, PP_KEY3, PP_KEY4, PP_KEY5,
             SEQ, DELAY, DELAY_UNIT, FREQ_TP, FREQ_VAL, FREQ_UNIT, INVERT_FREQ,
             LAST_SCHED, LAST_SCHED_TZ, LAST_CNT, LAST_VAL, INHERIT_AU
      FROM UTRTPP
      WHERE RT = L_RT_TO
      AND VERSION = L_RT_TO_VERSION;
   END IF;
   
   L_RQ_TO_GK_CURSOR := DBMS_SQL.OPEN_CURSOR;
   
   
   
   
   FOR L_RQ_FROM_GK_REC IN L_RQ_FROM_GK_CURSOR(A_RQ_FROM) LOOP
      BEGIN
         IF L_RQ_FROM_GK_REC.VALUE IS NOT NULL THEN
            L_SQL_STRING := 'INSERT INTO utrqgk' || L_RQ_FROM_GK_REC.GK ||
                            '(rq, ' || L_RQ_FROM_GK_REC.GK || ') VALUES (''' ||
                             REPLACE(A_RQ_TO, '''', '''''') || ''',''' || 
                             REPLACE(L_RQ_FROM_GK_REC.VALUE, '''', '''''') || ''')'; 

            DBMS_SQL.PARSE(L_RQ_TO_GK_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
            L_RESULT := DBMS_SQL.EXECUTE(L_RQ_TO_GK_CURSOR);

            IF L_RESULT = 0 THEN
               UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NORECORDS;
               RAISE STPERROR;
            END IF;
         END IF;

         
         INSERT INTO UTRQGK(RQ, GK, GKSEQ, VALUE)
         VALUES(A_RQ_TO, L_RQ_FROM_GK_REC.GK, L_RQ_FROM_GK_REC.GKSEQ, L_RQ_FROM_GK_REC.VALUE);
      EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
         
         
         NULL;
      WHEN OTHERS THEN
         
         
         IF SQLCODE=-942 THEN
            NULL;
         ELSE
            RAISE;
         END IF;
      END;
   END LOOP;
   DBMS_SQL.CLOSE_CURSOR(L_RQ_TO_GK_CURSOR);

   
   IF INSTR(A_COPY_IC, 'CREATE IC') <> 0 THEN
      L_RET_CODE := UNAPIRQ.CREATERQINFODETAILS(L_RT_TO, L_RT_TO_VERSION, A_RQ_TO,
                                                UNAPIGEN.PERFORM_FREQ_FILTERING,
                                                L_REF_DATE, A_MODIFY_REASON);
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         L_SQLERRM := 'CreateRqInfoDetails returned='||L_RET_CODE||
                      '#rt='||L_RT_TO|| 
                      '#rt_version='||L_RT_TO_VERSION|| 
                      '#rq='||A_RQ_TO;
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
         RAISE STPERROR;
      END IF;
   ELSIF INSTR(A_COPY_IC, 'COPY IC') <> 0 THEN
      L_RET_CODE := UNAPIRQ.COPYRQINFODETAILS(A_RQ_FROM, L_RT_TO, L_RT_TO_VERSION, A_RQ_TO, 
                                              A_MODIFY_REASON);
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         L_SQLERRM := 'CopyRqInfoDetails returned='||L_RET_CODE||
                      '#rq_from='||A_RQ_FROM||
                      '#rt='||L_RT_TO||
                      '#rt_version='||L_RT_TO_VERSION||
                      '#rq_to='||A_RQ_TO;
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
         RAISE STPERROR;
      END IF;   
   END IF;

   
   
   
   FOR L_RQGK_REC IN (SELECT GK, VALUE FROM UTRQGK WHERE RQ=A_RQ_FROM) LOOP
      L_FIELDNR_OF_ROWS:= L_FIELDNR_OF_ROWS+1;
      L_FIELDTYPE_TAB(L_FIELDNR_OF_ROWS):= 'gk';
      L_FIELDNAMES_TAB(L_FIELDNR_OF_ROWS):= L_RQGK_REC.GK;
      L_FIELDVALUES_TAB(L_FIELDNR_OF_ROWS):= L_RQGK_REC.VALUE;
   END LOOP;
   
   IF INSTR(A_COPY_SC, 'CREATE SC') <> 0 THEN
      L_RET_CODE := UNAPIRQ2.CREATERQSAMPLINGDETAILS(L_RT_TO, L_RT_TO_VERSION, A_RQ_TO, 
                       UNAPIGEN.PERFORM_FREQ_FILTERING, L_REF_DATE, '',
                       A_USERID, L_FIELDTYPE_TAB, L_FIELDNAMES_TAB, L_FIELDVALUES_TAB, 
                       L_FIELDNR_OF_ROWS, A_MODIFY_REASON);
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         L_SQLERRM := 'CreateRqSamplingDetails returned='||L_RET_CODE||
                      '#rt='||L_RT_TO||
                      '#rt_version='||NVL(L_RT_TO_VERSION, 'NULL')||
                      '#rq='||A_RQ_TO;
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
         RAISE STPERROR;
      END IF;
   ELSIF INSTR(A_COPY_SC, 'COPY SC') <> 0 THEN
      L_RET_CODE := UNAPIRQ2.COPYRQSAMPLINGDETAILS(A_RQ_FROM, L_RT_TO, L_RT_TO_VERSION, A_RQ_TO, 
                       L_REF_DATE, A_COPY_SCIC, A_COPY_SCPG, A_USERID, A_MODIFY_REASON);
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         L_SQLERRM := 'CopyRqSamplingDetails returned='||L_RET_CODE||
                      '#rq_from='||A_RQ_FROM||
                      '#rt='||L_RT_TO||
                      '#rt_version='||NVL(L_RT_TO_VERSION, 'NULL')||
                      '#rq_to='||A_RQ_TO||
                      '#copy_scic='||A_COPY_SCIC||
                      '#copy_scpg='||A_COPY_SCPG;
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
         RAISE STPERROR;
      END IF;
   END IF;

   
   
   
   L_EVENT_TP := 'RequestCreated';
   L_EV_SEQ_NR := -1;
   L_EV_DETAILS := 'rt_version=' || L_RT_TO_VERSION;
   L_RESULT := UNAPIEV.INSERTEVENT('CopyRequest', UNAPIGEN.P_EVMGR_NAME, 'rq',
                                   A_RQ_TO, '', '', '', L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;

   INSERT INTO UTRQHS(RQ, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
   VALUES(A_RQ_TO, NVL(A_USERID, UNAPIGEN.P_USER), 
          UNAPIGEN.SQLUSERDESCRIPTION(NVL(A_USERID, UNAPIGEN.P_USER)), L_EVENT_TP, 
          'Request "'||A_RQ_TO||'" is created by copying request "'||A_RQ_FROM||'"', 
          CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);

   L_HS_DETAILS_SEQ_NR := 0;
   L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
   INSERT INTO UTRQHSDETAILS(RQ, TR_SEQ, EV_SEQ, SEQ, DETAILS)
   VALUES(A_RQ_TO, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR, 
          'Request "'||A_RQ_TO||'" is created by copying request "'||A_RQ_FROM||'"');
   
   
   IF INSTR(A_COPY_IC, 'COPY IIVALUE') <> 0 THEN
      
      FOR L_ALLRQIC_REC IN L_ALLRQIC_CURSOR(A_RQ_TO) LOOP
         
         
         L_RQIC_POS_FOUND := FALSE;
         OPEN L_RQIC_POS_CURSOR(A_RQ_FROM, A_RQ_TO, L_ALLRQIC_REC.IC);
         LOOP
            FETCH L_RQIC_POS_CURSOR
            INTO L_RQIC_POS_REC;
            IF L_RQIC_POS_REC.IC_TO = L_ALLRQIC_REC.IC AND
               L_RQIC_POS_REC.ICNODE_TO = L_ALLRQIC_REC.ICNODE THEN
               L_RQIC_POS_FOUND := TRUE;
               EXIT;
            END IF;
            EXIT WHEN L_RQIC_POS_CURSOR%NOTFOUND;
         END LOOP;
         CLOSE L_RQIC_POS_CURSOR;

         IF L_RQIC_POS_FOUND AND L_RQIC_POS_REC.IC_FROM IS NOT NULL THEN
            L_RET_CODE := UNAPIRQIC.COPYRQINFOVALUES(A_RQ_FROM, L_RQIC_POS_REC.IC_FROM, 
                             L_RQIC_POS_REC.ICNODE_FROM, L_RT_TO, L_RT_TO_VERSION, A_RQ_TO, 
                             L_RQIC_POS_REC.IC_TO, L_RQIC_POS_REC.ICNODE_TO, A_MODIFY_REASON);
            IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
               L_SQLERRM := 'CopyRqInfoValues returned='||L_RET_CODE||
                            '#rq_from='||A_RQ_FROM||
                            '#ic_from='||L_RQIC_POS_REC.IC_FROM||
                            '#icnode_from='|| L_RQIC_POS_REC.ICNODE_FROM||
                            '#rt='||L_RT_TO||
                            '#rt_version='||L_RT_TO_VERSION||
                            '#rq_to='||A_RQ_TO||
                            '#ic_to='||L_RQIC_POS_REC.IC_TO||
                            '#icnode_to='|| L_RQIC_POS_REC.ICNODE_TO;
               UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
               RAISE STPERROR;
            END IF;
         END IF;
      END LOOP;         
   END IF;

   
   
   
   IF INSTR(A_COPY_SC, 'CREATE SC') <> 0 THEN
      
      FOR L_ALLRQSC_REC IN L_ALLRQSC_CURSOR(A_RQ_TO) LOOP
         
         

         FOR L_SC_REC IN L_SC_CURSOR(L_ALLRQSC_REC.SC) LOOP
            L_ST_TO := L_SC_REC.ST;
            L_ST_TO_VERSION := L_SC_REC.ST_VERSION;
         END LOOP;

         L_RQSC_POS_FOUND := FALSE;
         OPEN L_RQSC_POS_CURSOR(A_RQ_FROM, A_RQ_TO, L_ST_TO, L_ST_TO_VERSION);
         LOOP
            FETCH L_RQSC_POS_CURSOR
            INTO L_RQSC_POS_REC;
            IF L_RQSC_POS_REC.SC_TO = L_ALLRQSC_REC.SC AND
               L_RQSC_POS_REC.SEQ_TO = L_ALLRQSC_REC.SEQ THEN
               L_RQSC_POS_FOUND := TRUE;
               EXIT;
            END IF;
            EXIT WHEN L_RQSC_POS_CURSOR%NOTFOUND;
         END LOOP;
         CLOSE L_RQSC_POS_CURSOR;

         IF L_RQSC_POS_FOUND AND L_RQSC_POS_REC.SC_FROM IS NOT NULL THEN
            
            IF INSTR(A_COPY_SC, 'COPY IIVALUE') <> 0 THEN
               
               FOR L_ALLSCIC_REC IN L_ALLSCIC_CURSOR(L_RQSC_POS_REC.SC_TO) LOOP
                  
                  
                  L_SCIC_POS_FOUND := FALSE;
                  OPEN L_SCIC_POS_CURSOR(L_RQSC_POS_REC.SC_FROM, L_RQSC_POS_REC.SC_TO, L_ALLSCIC_REC.IC);
                  LOOP
                     FETCH L_SCIC_POS_CURSOR
                     INTO L_SCIC_POS_REC;
                     IF L_SCIC_POS_REC.IC_TO = L_ALLSCIC_REC.IC AND
                        L_SCIC_POS_REC.ICNODE_TO = L_ALLSCIC_REC.ICNODE THEN
                        L_SCIC_POS_FOUND := TRUE;
                        EXIT;
                     END IF;
                     EXIT WHEN L_SCIC_POS_CURSOR%NOTFOUND;
                  END LOOP;
                  CLOSE L_SCIC_POS_CURSOR;

                  IF L_SCIC_POS_FOUND AND L_SCIC_POS_REC.IC_FROM IS NOT NULL THEN
                     L_RET_CODE := UNAPIIC.COPYSCINFOVALUES
                                      (L_RQSC_POS_REC.SC_FROM, L_SCIC_POS_REC.IC_FROM, 
                                       L_SCIC_POS_REC.ICNODE_FROM, L_ST_TO, 
                                       L_ST_TO_VERSION, L_RQSC_POS_REC.SC_TO, L_SCIC_POS_REC.IC_TO, 
                                       L_SCIC_POS_REC.ICNODE_TO, A_MODIFY_REASON);
                     IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                        L_SQLERRM := 'CopyScInfoValues returned='||L_RET_CODE||
                                     '#sc_from='||L_RQSC_POS_REC.SC_FROM||
                                     '#ic_from='||L_SCIC_POS_REC.IC_FROM||
                                     '#icnode_from='|| L_SCIC_POS_REC.ICNODE_FROM||
                                     '#st='||L_ST_TO||
                                     '#st_version='||L_ST_TO_VERSION||
                                     '#sc_to='||L_RQSC_POS_REC.SC_TO||
                                     '#ic_to='||L_SCIC_POS_REC.IC_TO||
                                     '#icnode_to='|| L_SCIC_POS_REC.ICNODE_TO;
                        UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
                        RAISE STPERROR;
                     END IF;
                  END IF;
               END LOOP;         
            END IF;
            
            
            IF INSTR(A_COPY_SC, 'COPY PGVALUE') <> 0 THEN
               
               FOR L_ALLSCPG_REC IN L_ALLSCPG_CURSOR(L_RQSC_POS_REC.SC_TO) LOOP
                  
                  
                  L_SCPG_POS_FOUND := FALSE;
                  OPEN L_SCPG_POS_CURSOR(L_RQSC_POS_REC.SC_FROM, L_RQSC_POS_REC.SC_TO, L_ALLSCPG_REC.PG);
                  LOOP
                     FETCH L_SCPG_POS_CURSOR
                     INTO L_SCPG_POS_REC;
                     IF L_SCPG_POS_REC.PG_TO = L_ALLSCPG_REC.PG AND
                        L_SCPG_POS_REC.PGNODE_TO = L_ALLSCPG_REC.PGNODE THEN
                        L_SCPG_POS_FOUND := TRUE;
                        EXIT;
                     END IF;
                     EXIT WHEN L_SCPG_POS_CURSOR%NOTFOUND;
                  END LOOP;
                  CLOSE L_SCPG_POS_CURSOR;

                  IF L_SCPG_POS_FOUND AND L_SCPG_POS_REC.PG_FROM IS NOT NULL THEN
                     L_RET_CODE := UNAPIPG.COPYSCPGPARESULTS
                                      (L_RQSC_POS_REC.SC_FROM, L_SCPG_POS_REC.PG_FROM, 
                                       L_SCPG_POS_REC.PGNODE_FROM, L_ST_TO, 
                                       L_ST_TO_VERSION, L_RQSC_POS_REC.SC_TO, L_SCPG_POS_REC.PG_TO, 
                                       L_SCPG_POS_REC.PGNODE_TO, A_MODIFY_REASON);
                     IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                        L_SQLERRM := 'CopyScPgPaResults returned='||L_RET_CODE||
                                     '#sc_from='||L_RQSC_POS_REC.SC_FROM||
                                     '#pg_from='||L_SCPG_POS_REC.PG_FROM||
                                     '#pgnode_from='|| L_SCPG_POS_REC.PGNODE_FROM||
                                     '#st='||L_ST_TO||
                                     '#st_version='||L_ST_TO_VERSION||
                                     '#sc_to='||L_RQSC_POS_REC.SC_TO||
                                     '#pg_to='||L_SCPG_POS_REC.PG_TO||
                                     '#pgnode_to='|| L_SCPG_POS_REC.PGNODE_TO;
                        UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
                        RAISE STPERROR;
                     END IF;   
                  END IF;
               END LOOP;
            END IF;
         END IF;
      END LOOP;         
   END IF;

   
   
   L_EVENT_TP := 'RequestCopied';
   L_EV_DETAILS := 'rq_from='||A_RQ_FROM||'#rt_version='||L_RT_TO_VERSION;
   L_EV_SEQ_NR := -1;
   L_RESULT := UNAPIEV.INSERTEVENT('CopyRequest', UNAPIGEN.P_EVMGR_NAME, 'rq',
                                   A_RQ_TO, '', '', '', L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;

   
   INSERT INTO UTRQHS(RQ, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
   VALUES(A_RQ_TO, NVL(A_USERID, UNAPIGEN.P_USER), 
          UNAPIGEN.SQLUSERDESCRIPTION(NVL(A_USERID, UNAPIGEN.P_USER)), L_EVENT_TP, 
          'rq_from='||A_RQ_FROM, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, NULL, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);

   L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
   INSERT INTO UTRQHSDETAILS(RQ, TR_SEQ, EV_SEQ, SEQ, DETAILS)
   VALUES(A_RQ_TO, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR, 'rq_from='||A_RQ_FROM);

   IF A_MODIFY_REASON IS NOT NULL THEN
      INSERT INTO UTRQHS(RQ, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
      VALUES(A_RQ_TO, NVL(A_USERID, UNAPIGEN.P_USER), 
             UNAPIGEN.SQLUSERDESCRIPTION(NVL(A_USERID, UNAPIGEN.P_USER)), L_EVENT_TP, 
             'rq_from='||A_RQ_FROM, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
   END IF;
   
   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   UNAPIGEN.P_EVMGR_NAME := L_EVMGR_NAME;
   RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('CopyRequest', SQLERRM);
   
   ELSIF L_SQLERRM IS NOT NULL THEN
   
      UNAPIGEN.LOGERROR('CopyRequest', L_SQLERRM);   
   END IF;
   IF L_RQ_RT_CURSOR%ISOPEN THEN
      CLOSE L_RQ_RT_CURSOR;
   END IF;
   IF L_RT_ACTIVE_CURSOR%ISOPEN THEN
      CLOSE L_RT_ACTIVE_CURSOR;
   END IF;
   IF DBMS_SQL.IS_OPEN(L_RQ_TO_GK_CURSOR) THEN
      DBMS_SQL.CLOSE_CURSOR(L_RQ_TO_GK_CURSOR);
   END IF;
   IF L_RQIC_POS_CURSOR%ISOPEN THEN
      CLOSE L_RQIC_POS_CURSOR;
   END IF;
   IF L_RQSC_POS_CURSOR%ISOPEN THEN
      CLOSE L_RQSC_POS_CURSOR;
   END IF;
   IF L_SCIC_POS_CURSOR%ISOPEN THEN
      CLOSE L_SCIC_POS_CURSOR;
   END IF;
   IF L_SCPG_POS_CURSOR%ISOPEN THEN
      CLOSE L_SCPG_POS_CURSOR;
   END IF;
   IF L_OBJECTS_CURSOR%ISOPEN THEN
      CLOSE L_OBJECTS_CURSOR;
   END IF;
   UNAPIGEN.P_EVMGR_NAME := L_EVMGR_NAME;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'CopyRequest'));
END COPYREQUEST;

END UNAPIRQ2;
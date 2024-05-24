PACKAGE BODY unapisc AS

TYPE BOOLEAN_TABLE_TYPE IS TABLE OF BOOLEAN INDEX BY BINARY_INTEGER;
P_SELECTSC_CURSOR        INTEGER;
P_SELECTSCGK_CURSOR      INTEGER;
P_SELECTSCPROP_CURSOR    INTEGER;

L_SQLERRM         VARCHAR2(255);
L_SQL_STRING      VARCHAR2(4000);
L_WHERE_CLAUSE    VARCHAR2(3000);
L_ORDER_BY_CLAUSE VARCHAR2(1000);
L_EVENT_TP        UTEV.EV_TP%TYPE;
L_RET_CODE        NUMBER;
L_RESULT          NUMBER;
L_FETCHED_ROWS    NUMBER;
L_EV_SEQ_NR       NUMBER;
L_EV_DETAILS      VARCHAR2(255);
STPERROR          EXCEPTION;

FUNCTION GETVERSION
   RETURN VARCHAR2
IS
BEGIN
   RETURN('06.07.00.00_21.01');
EXCEPTION
   WHEN OTHERS THEN
      RETURN (NULL);
END GETVERSION;

FUNCTION SAVESAMPLE
(A_SC                  IN     VARCHAR2,       
 A_ST                  IN     VARCHAR2,       
 A_ST_VERSION          IN     VARCHAR2,       
 A_DESCRIPTION         IN     VARCHAR2,       
 A_SHELF_LIFE_VAL      IN     NUMBER,         
 A_SHELF_LIFE_UNIT     IN     VARCHAR2,       
 A_SAMPLING_DATE       IN     DATE,           
 A_CREATION_DATE       IN     DATE,           
 A_CREATED_BY          IN     VARCHAR2,       
 A_EXEC_START_DATE     IN     DATE,           
 A_EXEC_END_DATE       IN     DATE,           
 A_PRIORITY            IN     NUMBER,         
 A_LABEL_FORMAT        IN     VARCHAR2,       
 A_DESCR_DOC           IN     VARCHAR2,       
 A_DESCR_DOC_VERSION   IN     VARCHAR2,       
 A_RQ                  IN     VARCHAR2,       
 A_SD                  IN     VARCHAR2,       
 A_DATE1               IN     DATE,           
 A_DATE2               IN     DATE,           
 A_DATE3               IN     DATE,           
 A_DATE4               IN     DATE,           
 A_DATE5               IN     DATE,           
 A_ALLOW_ANY_PP        IN     CHAR,           
 A_SC_CLASS            IN     VARCHAR2,       
 A_LOG_HS              IN     CHAR,           
 A_LOG_HS_DETAILS      IN     CHAR,           
 A_LC                  IN     VARCHAR2,       
 A_LC_VERSION          IN     VARCHAR2,       
 A_MODIFY_REASON       IN     VARCHAR2)       
RETURN NUMBER IS

L_TIMED_EVENT_TP           VARCHAR2(255);
L_LC                       VARCHAR2(2);
L_LC_VERSION               VARCHAR2(20);
L_SS                       VARCHAR2(2);
L_LOG_HS                   CHAR(1);
L_LOG_HS_DETAILS           CHAR(1);
L_ALLOW_MODIFY             CHAR(1);
L_ACTIVE                   CHAR(1);
L_INSERT                   CHAR(1);
L_DELAYED_TILL             TIMESTAMP WITH TIME ZONE;
L_CURRENT_TIMESTAMP                  TIMESTAMP WITH TIME ZONE;
L_REF_DATE                 TIMESTAMP WITH TIME ZONE;
L_SD                       VARCHAR2(20);
L_RQ                       VARCHAR2(20);
L_OLD_RQ                   VARCHAR2(20);
L_RQ_LC                    VARCHAR2(2);
L_RQ_LC_VERSION            VARCHAR2(20);
L_RQ_SS                    VARCHAR2(2);
L_RQ_LOG_HS                CHAR(1);
L_RQ_LOG_HS_DETAILS        CHAR(1);
L_RQ_LOG_HS_DUMMY          CHAR(1);
L_RQ_LOG_HS_DETAILS_DUMMY  CHAR(1);
L_RQ_ALLOW_MODIFY          CHAR(1);
L_RQ_ACTIVE                CHAR(1);
L_HS_DETAILS_SEQ_NR        INTEGER;
L_ST_VERSION               VARCHAR2(20);
L_RT_VERSION               VARCHAR2(20);
L_PARTIAL_SAVE             BOOLEAN;
L_PARTIAL_SAVE_RET_CODE    INTEGER;
L_OLD_SC_COUNTER           NUMBER;
L_NEW_SC_COUNTER           NUMBER;
L_MAX_NUMBER_OF_SAMPLES    INTEGER;
L_COUNT_SAMPLES            INTEGER;

CURSOR L_SC_CURSOR IS
   SELECT RQ
   FROM UTSC
   WHERE SC=A_SC;

CURSOR L_SCOLD_CURSOR (A_SC IN VARCHAR2) IS
   SELECT A.*
   FROM UDSC A
   WHERE A.SC = A_SC;
L_SCOLD_REC UDSC%ROWTYPE;
L_SCNEW_REC UDSC%ROWTYPE;


CURSOR L_RQ_CURSOR(A_RQ VARCHAR2) IS
   SELECT LOG_HS, LOG_HS_DETAILS, SC_COUNTER
   FROM UTRQ
   WHERE RQ=A_RQ;

L_HS_SEQ                  INTEGER;

BEGIN

   L_PARTIAL_SAVE := FALSE;
   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   
   IF UNAPIGEN.P_PP_KEY4PRODUCT IS NULL THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_SETCONNECTION;
      RAISE STPERROR;               
   END IF;

   IF NVL(A_SC, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   IF NVL(A_LOG_HS, ' ') NOT IN ('1','0') THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_LOGHS;
      RAISE STPERROR;
   END IF;

   IF NVL(A_ALLOW_ANY_PP, ' ') NOT IN ('1','0') THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_ALLOWANYPP;
      RAISE STPERROR;
   END IF;

   L_CURRENT_TIMESTAMP := CURRENT_TIMESTAMP;
   L_ST_VERSION := A_ST_VERSION;
   L_RET_CODE := UNAPIAUT.GETSCAUTHORISATION(A_SC, L_ST_VERSION, L_LC, L_LC_VERSION, L_SS,
                                             L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS, L_LOG_HS_DETAILS);

   IF L_RET_CODE = UNAPIGEN.DBERR_NOOBJECT THEN
      L_INSERT := '1';
   ELSIF L_RET_CODE = UNAPIGEN.DBERR_SUCCESS THEN
      L_INSERT := '0';
   ELSE
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   L_RQ := NULL;
   IF A_RQ IS NOT NULL THEN
      L_RET_CODE := UNAPIAUT.GETRQAUTHORISATION(A_RQ, L_RT_VERSION, L_RQ_LC, L_RQ_LC_VERSION, L_RQ_SS,
                                           L_RQ_ALLOW_MODIFY, L_RQ_ACTIVE, L_RQ_LOG_HS, L_RQ_LOG_HS_DETAILS);
      
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         IF L_RET_CODE IN (UNAPIGEN.DBERR_TRANSITION, UNAPIGEN.DBERR_READONLY) THEN
            
            
            NULL; 
         ELSIF L_RET_CODE IN (UNAPIGEN.DBERR_RTVERSION, UNAPIGEN.DBERR_NOOBJECT) THEN
            
            
            L_PARTIAL_SAVE := TRUE;
            L_PARTIAL_SAVE_RET_CODE := UNAPIGEN.DBERR_RQDOESNOTEXIST;
            L_RQ := NULL;
         ELSE
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            RAISE STPERROR;
         END IF;
      END IF;
      L_RQ := A_RQ;
   END IF;
   

   IF L_INSERT = '1' THEN                
      IF NVL(A_LC, ' ') <> ' ' THEN
         L_LC := A_LC;
      END IF;
      IF NVL(A_LC_VERSION, ' ') <> ' ' THEN
         L_LC_VERSION := A_LC_VERSION;
      END IF;

      
      
      
      L_RET_CODE := UNAPIGEN.GETMAXSAMPLES(L_MAX_NUMBER_OF_SAMPLES);
      IF NVL(L_MAX_NUMBER_OF_SAMPLES,3000) >= 0 THEN
         
         
         SELECT COUNT(*)
         INTO L_COUNT_SAMPLES
         FROM UTSC;

         IF (L_COUNT_SAMPLES+1) >= L_MAX_NUMBER_OF_SAMPLES THEN
            L_SQLERRM := 'The maximum number of samples for your system has been reached. You need another type license.';
            UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
            RAISE STPERROR;      
         END IF;
      END IF;

      
      INSERT INTO UTSC(SC, ST, ST_VERSION, DESCRIPTION, SHELF_LIFE_VAL, SHELF_LIFE_UNIT,
                       SAMPLING_DATE,SAMPLING_DATE_TZ, CREATION_DATE, CREATION_DATE_TZ, CREATED_BY,
                       PRIORITY, LABEL_FORMAT, DESCR_DOC, 
                       RQ, 
                       SD,
                       DATE1, DATE1_TZ, DATE2, DATE2_TZ, DATE3, DATE3_TZ, DATE4, DATE4_TZ,
                       DATE5, DATE5_TZ, ALLOW_ANY_PP,
                       SC_CLASS, LOG_HS, LOG_HS_DETAILS, ALLOW_MODIFY, ACTIVE, LC, LC_VERSION)
      VALUES(A_SC, A_ST, L_ST_VERSION, A_DESCRIPTION, A_SHELF_LIFE_VAL, A_SHELF_LIFE_UNIT,
             A_SAMPLING_DATE, A_SAMPLING_DATE, A_CREATION_DATE, A_CREATION_DATE, A_CREATED_BY,
             A_PRIORITY, A_LABEL_FORMAT, A_DESCR_DOC, 
             L_RQ, 
             A_SD,
             A_DATE1, A_DATE1, A_DATE2, A_DATE2, A_DATE3, A_DATE3, A_DATE4, A_DATE4, A_DATE5, A_DATE5, 
             A_ALLOW_ANY_PP, A_SC_CLASS, A_LOG_HS, A_LOG_HS_DETAILS, '#', '0', L_LC, L_LC_VERSION);
      UNAPIAUT.UPDATELCINAUTHORISATIONBUFFER('sc', A_SC, '', L_LC, L_LC_VERSION);
      L_EVENT_TP := 'SampleCreated';
   ELSE                             

      
      
      
      OPEN L_SCOLD_CURSOR(A_SC);
      FETCH L_SCOLD_CURSOR
      INTO L_SCOLD_REC;
      CLOSE L_SCOLD_CURSOR;
      L_SCNEW_REC := L_SCOLD_REC;

      SELECT RQ
      INTO L_OLD_RQ
      FROM UTSC
      WHERE SC = A_SC;

      
      
      
      
      
      UPDATE UTSC
      SET DESCRIPTION      = A_DESCRIPTION,
          SHELF_LIFE_VAL   = A_SHELF_LIFE_VAL,
          SHELF_LIFE_UNIT  = A_SHELF_LIFE_UNIT,
          SAMPLING_DATE    = A_SAMPLING_DATE,
          SAMPLING_DATE_TZ = DECODE(A_SAMPLING_DATE, SAMPLING_DATE_TZ, SAMPLING_DATE_TZ, A_SAMPLING_DATE),
          PRIORITY         = A_PRIORITY,
          LABEL_FORMAT     = A_LABEL_FORMAT,
          DESCR_DOC        = A_DESCR_DOC,
          RQ               = L_RQ,           
          SD               = A_SD,
          DATE1            = A_DATE1,
          DATE2            = A_DATE2,
          DATE3            = A_DATE3,
          DATE4            = A_DATE4,
          DATE5            = A_DATE5,
          DATE1_TZ         = DECODE(A_DATE1, DATE1, DATE1_TZ, A_DATE1) ,
          DATE2_TZ         = DECODE(A_DATE2, DATE2, DATE2_TZ, A_DATE2) ,
          DATE3_TZ         = DECODE(A_DATE3, DATE3, DATE3_TZ, A_DATE3),
          DATE4_TZ         = DECODE(A_DATE4, DATE4, DATE4_TZ, A_DATE4),
          DATE5_TZ         = DECODE(A_DATE5, DATE5, DATE5_TZ, A_DATE5),
          ALLOW_ANY_PP     = A_ALLOW_ANY_PP,
          LOG_HS           = A_LOG_HS,
          LOG_HS_DETAILS   = A_LOG_HS_DETAILS,
          ALLOW_MODIFY     = '#'
      WHERE SC = A_SC
      RETURNING DESCRIPTION, SHELF_LIFE_VAL, SHELF_LIFE_UNIT, SAMPLING_DATE, SAMPLING_DATE_TZ, PRIORITY, 
                LABEL_FORMAT, DESCR_DOC, RQ, SD, DATE1, DATE1_TZ, DATE2, DATE2_TZ, DATE3, DATE3_TZ, 
      DATE4, DATE4_TZ, DATE5, DATE5_TZ, ALLOW_ANY_PP, 
                LOG_HS, LOG_HS_DETAILS, ALLOW_MODIFY
      INTO L_SCNEW_REC.DESCRIPTION, L_SCNEW_REC.SHELF_LIFE_VAL, L_SCNEW_REC.SHELF_LIFE_UNIT, 
           L_SCNEW_REC.SAMPLING_DATE, L_SCNEW_REC.SAMPLING_DATE_TZ, L_SCNEW_REC.PRIORITY, L_SCNEW_REC.LABEL_FORMAT, 
           L_SCNEW_REC.DESCR_DOC, L_SCNEW_REC.RQ, L_SCNEW_REC.SD, L_SCNEW_REC.DATE1, L_SCNEW_REC.DATE1_TZ, 
           L_SCNEW_REC.DATE2, L_SCNEW_REC.DATE2_TZ, L_SCNEW_REC.DATE3, L_SCNEW_REC.DATE3_TZ,
      L_SCNEW_REC.DATE4, L_SCNEW_REC.DATE4_TZ, L_SCNEW_REC.DATE5, L_SCNEW_REC.DATE5_TZ,
           L_SCNEW_REC.ALLOW_ANY_PP, L_SCNEW_REC.LOG_HS, L_SCNEW_REC.LOG_HS_DETAILS, 
           L_SCNEW_REC.ALLOW_MODIFY;
      
      L_EVENT_TP := 'SampleUpdated';
   END IF;

   
   
   
   L_RET_CODE := UNAPISC.UPDATELINKEDSCII
                   (A_SC, NULL, '1', A_ST, L_ST_VERSION, A_DESCRIPTION,
                    A_SHELF_LIFE_VAL, A_SHELF_LIFE_UNIT, A_SAMPLING_DATE,
                    A_CREATION_DATE, A_CREATED_BY, A_EXEC_START_DATE,
                    A_EXEC_END_DATE, A_PRIORITY, A_LABEL_FORMAT,
                    A_DESCR_DOC, A_DESCR_DOC_VERSION, L_RQ, A_SD,
                    A_DATE1, A_DATE2, A_DATE3, A_DATE4, A_DATE5,
                    A_ALLOW_ANY_PP, A_SC_CLASS);
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   L_EV_SEQ_NR := -1;
   L_EV_DETAILS := 'st_version=' || L_ST_VERSION;
   L_RESULT := UNAPIEV.INSERTEVENT('SaveSample', UNAPIGEN.P_EVMGR_NAME, 'sc', A_SC, L_LC, 
                                   L_LC_VERSION, L_SS, L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS  THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;

   
   
   
   IF NVL(L_LOG_HS, ' ') <> A_LOG_HS THEN
      IF A_LOG_HS = '1' THEN
         INSERT INTO UTSCHS(SC, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
         VALUES(A_SC, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, 'History switched ON', 
                'Audit trail is turned on.', 
                L_CURRENT_TIMESTAMP, L_CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
      ELSE
         INSERT INTO UTSCHS(SC, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
         VALUES(A_SC, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, 'History switched OFF', 
                'Audit trail is turned off.', 
                L_CURRENT_TIMESTAMP, L_CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
      END IF;
   END IF;

   
   
   
   L_HS_DETAILS_SEQ_NR := 0;
   IF NVL(L_LOG_HS_DETAILS, ' ') <> A_LOG_HS_DETAILS THEN
      IF A_LOG_HS_DETAILS = '1' THEN
         L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
         INSERT INTO UTSCHSDETAILS(SC, TR_SEQ, EV_SEQ, SEQ, DETAILS)
         VALUES(A_SC, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR, 
                'Audit trail is turned on.');
      ELSE
         L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
         INSERT INTO UTSCHSDETAILS(SC, TR_SEQ, EV_SEQ, SEQ, DETAILS)
         VALUES(A_SC, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR, 
                'Audit trail is turned off.');
      END IF;
   END IF;

   
   
   
   IF NVL(L_LOG_HS, ' ') = '1' THEN
      IF L_EVENT_TP = 'SampleCreated' THEN
         INSERT INTO UTSCHS(SC, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
         VALUES(A_SC, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
                'sample "'||A_SC||'" is created.', 
                L_CURRENT_TIMESTAMP, L_CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
      ELSE
         INSERT INTO UTSCHS(SC, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
         VALUES(A_SC, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
                'sample "'||A_SC||'" is updated.', 
                L_CURRENT_TIMESTAMP, L_CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
      END IF;
   END IF;

   
   
   
   IF NVL(L_LOG_HS_DETAILS, ' ') = '1' THEN
      IF L_EVENT_TP = 'SampleCreated' THEN
         L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
         INSERT INTO UTSCHSDETAILS(SC, TR_SEQ, EV_SEQ, SEQ, DETAILS)
         VALUES(A_SC, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR, 
                'sample "'||A_SC||'" is created.');
      ELSE
         L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
         INSERT INTO UTSCHSDETAILS(SC, TR_SEQ, EV_SEQ, SEQ, DETAILS)
         VALUES(A_SC, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR, 
                'sample "'||A_SC||'" is updated.');
         UNAPIHSDETAILS.ADDSCHSDETAILS(L_SCOLD_REC, L_SCNEW_REC, UNAPIGEN.P_TR_SEQ, 
                                       L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR); 
      END IF;
   END IF;

   IF NVL(L_OLD_RQ, ' ') <> NVL(L_RQ, ' ') THEN
      L_EV_SEQ_NR := -1;
      L_EVENT_TP := 'ScRequestModified';
      IF L_OLD_RQ IS NULL THEN
         L_EV_DETAILS := 'st_version=' || L_ST_VERSION;
      ELSE
         L_EV_DETAILS := 'old_rq='||L_OLD_RQ ||
                         '#st_version=' || L_ST_VERSION;
      END IF;
      L_RESULT := UNAPIEV.INSERTEVENT('SaveSample', UNAPIGEN.P_EVMGR_NAME, 'sc', A_SC, L_LC, 
                                      L_LC_VERSION, L_SS, L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);
      IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS  THEN
         UNAPIGEN.P_TXN_ERROR := L_RESULT;
         RAISE STPERROR;
      END IF;
      
      IF L_RQ IS NOT NULL THEN
         
         
         
         
         
         
         
         UPDATE UTRQ
            SET SC_COUNTER = SC_COUNTER
          WHERE RQ = L_RQ;

         
         OPEN L_RQ_CURSOR(L_RQ);
         FETCH L_RQ_CURSOR INTO L_RQ_LOG_HS_DUMMY, L_RQ_LOG_HS_DETAILS_DUMMY, L_OLD_SC_COUNTER;
         CLOSE L_RQ_CURSOR;

         DELETE FROM UTRQSC
         WHERE RQ = L_RQ
         AND SC = A_SC;

         INSERT INTO UTRQSC (RQ, SC, SEQ,
                             ASSIGN_DATE, ASSIGN_DATE_TZ, ASSIGNED_BY)
         SELECT L_RQ, A_SC, NVL(MAX(SEQ),0)+1,
                 CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, UNAPIGEN.P_USER
         FROM UTRQSC
         WHERE RQ = L_RQ;
         IF SQL%ROWCOUNT = 0 THEN 
            INSERT INTO UTRQSC (RQ, SC, SEQ,
                                ASSIGN_DATE, ASSIGN_DATE_TZ, ASSIGNED_BY)
            VALUES (L_RQ, A_SC, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, UNAPIGEN.P_USER);
         END IF;
         
         
         UPDATE UTRQ
            SET SC_COUNTER = (SELECT COUNT(*) FROM UTRQSC WHERE RQ = L_RQ)
          WHERE RQ = L_RQ
         RETURNING SC_COUNTER
           INTO L_NEW_SC_COUNTER;

         IF L_RQ_LOG_HS = '1' THEN
            INSERT INTO UTRQHS (RQ, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
            VALUES (L_RQ, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, 
                   L_EVENT_TP, 'request "'||L_RQ||'" sample  "'||A_SC||'" is added.', 
                   CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);         
         END IF;
         IF L_RQ_LOG_HS_DETAILS = '1' THEN
            L_HS_SEQ := 1;
            INSERT INTO UTRQHSDETAILS (RQ, TR_SEQ, EV_SEQ, SEQ, DETAILS)
            VALUES (L_RQ, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_SEQ, 
                    'request "'||L_RQ||'" sample  "'||A_SC||'" is added.');         
            IF NVL((L_OLD_SC_COUNTER <> L_NEW_SC_COUNTER), TRUE) AND 
               NOT(L_OLD_SC_COUNTER IS NULL AND L_NEW_SC_COUNTER IS NULL) THEN 
               L_HS_SEQ := L_HS_SEQ + 1;
               INSERT INTO UTRQHSDETAILS(RQ, TR_SEQ, EV_SEQ, SEQ, DETAILS)
               VALUES(L_RQ, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_SEQ, 
                      'request "'||L_RQ||'" is updated: property <sc_counter> changed value from "'||
                          L_OLD_SC_COUNTER||'" to "'||L_NEW_SC_COUNTER||'".');
            END IF;
         END IF;
      END IF;
      
      IF L_OLD_RQ IS NOT NULL THEN
         
         
         
         
         OPEN L_RQ_CURSOR(L_OLD_RQ);
         FETCH L_RQ_CURSOR
         INTO L_RQ_LOG_HS, L_RQ_LOG_HS_DETAILS, L_OLD_SC_COUNTER;
         CLOSE L_RQ_CURSOR;

         DELETE FROM UTRQSC
         WHERE RQ = L_OLD_RQ
         AND SC = A_SC;

         
         UPDATE UTRQ
            SET SC_COUNTER = (SELECT COUNT(*) FROM UTRQSC WHERE RQ = L_OLD_RQ)
          WHERE RQ = L_OLD_RQ
         RETURNING SC_COUNTER
           INTO L_NEW_SC_COUNTER;

         IF L_RQ_LOG_HS = '1' THEN
            INSERT INTO UTRQHS (RQ, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
            VALUES (L_OLD_RQ, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
                    'request "'||L_OLD_RQ||'" sample  "'||A_SC||'" is removed.', 
                    CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
         END IF;
         IF L_RQ_LOG_HS_DETAILS = '1' THEN
            L_HS_SEQ := 1;
            INSERT INTO UTRQHSDETAILS (RQ, TR_SEQ, EV_SEQ, SEQ, DETAILS)
            VALUES (L_OLD_RQ, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_SEQ, 
                    'sample "'||A_SC||'" is removed from request "'||L_OLD_RQ||'".');
            IF NVL((L_OLD_SC_COUNTER <> L_NEW_SC_COUNTER), TRUE) AND 
               NOT(L_OLD_SC_COUNTER IS NULL AND L_NEW_SC_COUNTER IS NULL) THEN 
               L_HS_SEQ := L_HS_SEQ + 1;
               INSERT INTO UTRQHSDETAILS(RQ, TR_SEQ, EV_SEQ, SEQ, DETAILS)
               VALUES(L_OLD_RQ, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_SEQ, 
                      'request "'||L_OLD_RQ||'" is updated: property <sc_counter> changed value from "'||
                          L_OLD_SC_COUNTER||'" to "'||L_NEW_SC_COUNTER||'".');
            END IF;
         END IF;
      END IF;
   END IF;

   L_EV_SEQ_NR := -1;
   L_EV_DETAILS := 'st_version=' || L_ST_VERSION;
   L_TIMED_EVENT_TP := 'ScShelfLifeExceeded';
   L_REF_DATE := NVL(A_SAMPLING_DATE, L_CURRENT_TIMESTAMP);
   IF L_INSERT = '1' THEN
      
      
      
      
      IF NVL(A_SHELF_LIFE_VAL, 0) <> 0 THEN
         
         
         
         L_RET_CODE := UNAPIAUT.CALCULATEDELAY(A_SHELF_LIFE_VAL,
                                               A_SHELF_LIFE_UNIT,
                                               L_REF_DATE, L_DELAYED_TILL);
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            RAISE STPERROR;
         END IF;

         
         
         
         L_RESULT := UNAPIEV.INSERTTIMEDEVENT('SaveSample', UNAPIGEN.P_EVMGR_NAME, 'sc', A_SC, L_LC, 
                                               L_LC_VERSION, L_SS, L_TIMED_EVENT_TP, L_EV_DETAILS,
                                               L_EV_SEQ_NR, L_DELAYED_TILL);
         IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
            UNAPIGEN.P_TXN_ERROR := L_RESULT;
            RAISE STPERROR;
         END IF;
      END IF;
   ELSE
      
      
      
      
      IF NVL(L_SCOLD_REC.SHELF_LIFE_VAL, 0) <> NVL(A_SHELF_LIFE_VAL, 0) OR
         NVL(L_SCOLD_REC.SHELF_LIFE_UNIT, ' ') <> NVL(A_SHELF_LIFE_UNIT, ' ') THEN

         
         
         
         L_RET_CODE := UNAPIAUT.CALCULATEDELAY(A_SHELF_LIFE_VAL,
                                               A_SHELF_LIFE_UNIT,
                                               L_REF_DATE, L_DELAYED_TILL);
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            RAISE STPERROR;
         END IF;

         IF NVL(L_SCOLD_REC.SHELF_LIFE_VAL, 0) = 0 THEN

            L_EV_SEQ_NR  := -1;
            L_RESULT := UNAPIEV.INSERTTIMEDEVENT('SaveSample', UNAPIGEN.P_EVMGR_NAME, 'sc', A_SC, L_LC, 
                                                 L_LC_VERSION, L_SS, L_TIMED_EVENT_TP, L_EV_DETAILS,
                                                 L_EV_SEQ_NR, L_DELAYED_TILL);
            IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
               UNAPIGEN.P_TXN_ERROR := L_RESULT;
               RAISE STPERROR;
            END IF;
         ELSE
            
            
            
            IF NVL(A_SHELF_LIFE_VAL, 0) <> 0 THEN
              
               
               
               
               L_RET_CODE := UNAPIEV.UPDATETIMEDEVENT('sc', A_SC, L_TIMED_EVENT_TP, L_EV_DETAILS, 
                                                      L_DELAYED_TILL);
               IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
                  UNAPIGEN.P_TXN_ERROR := L_RESULT;
                  RAISE STPERROR;
               END IF;
            ELSE
               
               
               
               DELETE FROM UTEVTIMED
               WHERE OBJECT_TP = 'sc'
                 AND OBJECT_ID = A_SC
                 AND EV_TP = 'ScShelfLifeExceeded';
               L_EVENT_TP := 'ScShelfLifeExceeded';
               L_RESULT := UNAPIEV.INSERTEVENT('SaveSample', UNAPIGEN.P_EVMGR_NAME, 'sc', A_SC, L_LC, 
                                               L_LC_VERSION, L_SS, L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);
               IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS  THEN
                  UNAPIGEN.P_TXN_ERROR := L_RESULT;
                  RAISE STPERROR;
               END IF;
            END IF;
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
      UNAPIGEN.LOGERROR('SaveSample', SQLERRM);
   ELSIF L_SQLERRM IS NOT NULL THEN
      UNAPIGEN.LOGERROR('SaveSample', L_SQLERRM);
   END IF;
   IF L_SC_CURSOR%ISOPEN THEN
      CLOSE L_SC_CURSOR;
   END IF;
   IF L_RQ_CURSOR%ISOPEN THEN
      CLOSE L_RQ_CURSOR;
   END IF;
   IF L_SCOLD_CURSOR%ISOPEN THEN
      CLOSE L_SCOLD_CURSOR;
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'SaveSample'));
END SAVESAMPLE;

FUNCTION UPDATELINKEDSCII                     
(A_SC                  IN     VARCHAR2,       
 A_SC_STD_PROPERTY     IN     VARCHAR2,       
 A_SC_CREATION         IN     CHAR,           
 A_ST                  IN     VARCHAR2,       
 A_ST_VERSION          IN     VARCHAR2,       
 A_DESCRIPTION         IN     VARCHAR2,       
 A_SHELF_LIFE_VAL      IN     NUMBER,         
 A_SHELF_LIFE_UNIT     IN     VARCHAR2,       
 A_SAMPLING_DATE       IN     DATE,           
 A_CREATION_DATE       IN     DATE,           
 A_CREATED_BY          IN     VARCHAR2,       
 A_EXEC_START_DATE     IN     DATE,           
 A_EXEC_END_DATE       IN     DATE,           
 A_PRIORITY            IN     NUMBER,         
 A_LABEL_FORMAT        IN     VARCHAR2,       
 A_DESCR_DOC           IN     VARCHAR2,       
 A_DESCR_DOC_VERSION   IN     VARCHAR2,       
 A_RQ                  IN     VARCHAR2,       
 A_SD                  IN     VARCHAR2,       
 A_DATE1               IN     DATE,           
 A_DATE2               IN     DATE,           
 A_DATE3               IN     DATE,           
 A_DATE4               IN     DATE,           
 A_DATE5               IN     DATE,           
 A_ALLOW_ANY_PP        IN     CHAR,           
 A_SC_CLASS            IN     VARCHAR2)       
RETURN NUMBER IS

BEGIN
   RETURN(UNAPISC2.UPDATELINKEDSCII(A_SC, A_SC_STD_PROPERTY, A_SC_CREATION,
                                    A_ST, A_ST_VERSION, A_DESCRIPTION, A_SHELF_LIFE_VAL,
                                    A_SHELF_LIFE_UNIT, A_SAMPLING_DATE,
                                    A_CREATION_DATE, A_CREATED_BY,
                                    A_EXEC_START_DATE, A_EXEC_END_DATE,
                                    A_PRIORITY, A_LABEL_FORMAT,
                                    A_DESCR_DOC, A_DESCR_DOC_VERSION, A_RQ, A_SD,
                                    A_DATE1, A_DATE2, A_DATE3,
                                    A_DATE4, A_DATE5,
                                    A_ALLOW_ANY_PP,
                                    A_SC_CLASS));
END UPDATELINKEDSCII;

FUNCTION GETSAMPLE
(A_SC                  OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_ST                  OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_ST_VERSION          OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_DESCRIPTION         OUT     UNAPIGEN.VC40_TABLE_TYPE,  
 A_SHELF_LIFE_VAL      OUT     UNAPIGEN.NUM_TABLE_TYPE,   
 A_SHELF_LIFE_UNIT     OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_SAMPLING_DATE       OUT     UNAPIGEN.DATE_TABLE_TYPE,  
 A_CREATION_DATE       OUT     UNAPIGEN.DATE_TABLE_TYPE,  
 A_CREATED_BY          OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_EXEC_START_DATE     OUT     UNAPIGEN.DATE_TABLE_TYPE,  
 A_EXEC_END_DATE       OUT     UNAPIGEN.DATE_TABLE_TYPE,  
 A_PRIORITY            OUT     UNAPIGEN.NUM_TABLE_TYPE,   
 A_LABEL_FORMAT        OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_DESCR_DOC           OUT     UNAPIGEN.VC40_TABLE_TYPE,  
 A_DESCR_DOC_VERSION   OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_RQ                  OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_SD                  OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_DATE1               OUT     UNAPIGEN.DATE_TABLE_TYPE,  
 A_DATE2               OUT     UNAPIGEN.DATE_TABLE_TYPE,  
 A_DATE3               OUT     UNAPIGEN.DATE_TABLE_TYPE,  
 A_DATE4               OUT     UNAPIGEN.DATE_TABLE_TYPE,  
 A_DATE5               OUT     UNAPIGEN.DATE_TABLE_TYPE,  
 A_ALLOW_ANY_PP        OUT     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_SC_CLASS            OUT     UNAPIGEN.VC2_TABLE_TYPE,   
 A_LOG_HS              OUT     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_LOG_HS_DETAILS      OUT     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_ALLOW_MODIFY        OUT     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_AR                  OUT     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_ACTIVE              OUT     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_LC                  OUT     UNAPIGEN.VC2_TABLE_TYPE,   
 A_LC_VERSION          OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_SS                  OUT     UNAPIGEN.VC2_TABLE_TYPE,   
 A_NR_OF_ROWS          IN OUT  NUMBER,                    
 A_WHERE_CLAUSE        IN      VARCHAR2)                  
RETURN NUMBER IS

BEGIN

   RETURN(UNAPISC2.GETSAMPLE(A_SC,
                             A_ST,
                             A_ST_VERSION,
                             A_DESCRIPTION,
                             A_SHELF_LIFE_VAL,
                             A_SHELF_LIFE_UNIT,
                             A_SAMPLING_DATE,
                             A_CREATION_DATE,
                             A_CREATED_BY,
                             A_EXEC_START_DATE,
                             A_EXEC_END_DATE,
                             A_PRIORITY,
                             A_LABEL_FORMAT,
                             A_DESCR_DOC,
                             A_DESCR_DOC_VERSION,
                             A_RQ,
                             A_SD,
                             A_DATE1,
                             A_DATE2,
                             A_DATE3,
                             A_DATE4,
                             A_DATE5,
                             A_ALLOW_ANY_PP,
                             A_SC_CLASS,
                             A_LOG_HS,
                             A_LOG_HS_DETAILS,
                             A_ALLOW_MODIFY,
                             A_AR,
                             A_ACTIVE,
                             A_LC,
                             A_LC_VERSION,
                             A_SS,
                             A_NR_OF_ROWS,
                             A_WHERE_CLAUSE));
                             
END GETSAMPLE;


FUNCTION SELECTSAMPLE 
(A_COL_ID              IN      UNAPIGEN.VC40_TABLE_TYPE,  
 A_COL_TP              IN      UNAPIGEN.VC40_TABLE_TYPE,  
 A_COL_VALUE           IN      UNAPIGEN.VC40_TABLE_TYPE,  
 A_COL_NR_OF_ROWS      IN      NUMBER,                    
 A_SC                  OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_ST                  OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_ST_VERSION          OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_DESCRIPTION         OUT     UNAPIGEN.VC40_TABLE_TYPE,  
 A_SHELF_LIFE_VAL      OUT     UNAPIGEN.NUM_TABLE_TYPE,   
 A_SHELF_LIFE_UNIT     OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_SAMPLING_DATE       OUT     UNAPIGEN.DATE_TABLE_TYPE,  
 A_CREATION_DATE       OUT     UNAPIGEN.DATE_TABLE_TYPE,  
 A_CREATED_BY          OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_EXEC_START_DATE     OUT     UNAPIGEN.DATE_TABLE_TYPE,  
 A_EXEC_END_DATE       OUT     UNAPIGEN.DATE_TABLE_TYPE,  
 A_PRIORITY            OUT     UNAPIGEN.NUM_TABLE_TYPE,   
 A_LABEL_FORMAT        OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_DESCR_DOC           OUT     UNAPIGEN.VC40_TABLE_TYPE,  
 A_DESCR_DOC_VERSION   OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_RQ                  OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_SD                  OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_DATE1               OUT     UNAPIGEN.DATE_TABLE_TYPE,  
 A_DATE2               OUT     UNAPIGEN.DATE_TABLE_TYPE,  
 A_DATE3               OUT     UNAPIGEN.DATE_TABLE_TYPE,  
 A_DATE4               OUT     UNAPIGEN.DATE_TABLE_TYPE,  
 A_DATE5               OUT     UNAPIGEN.DATE_TABLE_TYPE,  
 A_ALLOW_ANY_PP        OUT     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_SC_CLASS            OUT     UNAPIGEN.VC2_TABLE_TYPE,   
 A_LOG_HS              OUT     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_LOG_HS_DETAILS      OUT     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_ALLOW_MODIFY        OUT     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_AR                  OUT     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_ACTIVE              OUT     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_LC                  OUT     UNAPIGEN.VC2_TABLE_TYPE,   
 A_LC_VERSION          OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_SS                  OUT     UNAPIGEN.VC2_TABLE_TYPE,   
 A_NR_OF_ROWS          IN OUT  NUMBER,                    
 A_ORDER_BY_CLAUSE     IN      VARCHAR2,                  
 A_NEXT_ROWS           IN      NUMBER)                    
RETURN NUMBER IS

L_COL_OPERATOR           UNAPIGEN.VC20_TABLE_TYPE;
L_COL_ANDOR              UNAPIGEN.VC3_TABLE_TYPE;

BEGIN

FOR L_X IN 1..A_COL_NR_OF_ROWS LOOP
    L_COL_OPERATOR(L_X) := '=';
    L_COL_ANDOR(L_X) := 'AND';
END LOOP;

   RETURN(UNAPISC.SELECTSAMPLE(A_COL_ID,
                               A_COL_TP,
                               A_COL_VALUE,
                               L_COL_OPERATOR,
                               L_COL_ANDOR,
                               A_COL_NR_OF_ROWS,
                               A_SC,
                               A_ST,
                               A_ST_VERSION,
                               A_DESCRIPTION,
                               A_SHELF_LIFE_VAL,
                               A_SHELF_LIFE_UNIT,
                               A_SAMPLING_DATE,
                               A_CREATION_DATE,
                               A_CREATED_BY,
                               A_EXEC_START_DATE,
                               A_EXEC_END_DATE,
                               A_PRIORITY,
                               A_LABEL_FORMAT,
                               A_DESCR_DOC,
                               A_DESCR_DOC_VERSION,
                               A_RQ,
                               A_SD,
                               A_DATE1,
                               A_DATE2,
                               A_DATE3,
                               A_DATE4,
                               A_DATE5,
                               A_ALLOW_ANY_PP,
                               A_SC_CLASS,
                               A_LOG_HS,
                               A_LOG_HS_DETAILS,
                               A_ALLOW_MODIFY,
                               A_AR,
                               A_ACTIVE,
                               A_LC,
                               A_LC_VERSION,
                               A_SS,
                               A_NR_OF_ROWS,
                               A_ORDER_BY_CLAUSE,
                               A_NEXT_ROWS));

END SELECTSAMPLE;

FUNCTION SELECTSAMPLE 
(A_COL_ID              IN      UNAPIGEN.VC40_TABLE_TYPE,  
 A_COL_TP              IN      UNAPIGEN.VC40_TABLE_TYPE,  
 A_COL_VALUE           IN      UNAPIGEN.VC40_TABLE_TYPE,  
 A_COL_OPERATOR        IN      UNAPIGEN.VC20_TABLE_TYPE,  
 A_COL_ANDOR           IN      UNAPIGEN.VC3_TABLE_TYPE,   
 A_COL_NR_OF_ROWS      IN      NUMBER,                    
 A_SC                  OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_ST                  OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_ST_VERSION          OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_DESCRIPTION         OUT     UNAPIGEN.VC40_TABLE_TYPE,  
 A_SHELF_LIFE_VAL      OUT     UNAPIGEN.NUM_TABLE_TYPE,   
 A_SHELF_LIFE_UNIT     OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_SAMPLING_DATE       OUT     UNAPIGEN.DATE_TABLE_TYPE,  
 A_CREATION_DATE       OUT     UNAPIGEN.DATE_TABLE_TYPE,  
 A_CREATED_BY          OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_EXEC_START_DATE     OUT     UNAPIGEN.DATE_TABLE_TYPE,  
 A_EXEC_END_DATE       OUT     UNAPIGEN.DATE_TABLE_TYPE,  
 A_PRIORITY            OUT     UNAPIGEN.NUM_TABLE_TYPE,   
 A_LABEL_FORMAT        OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_DESCR_DOC           OUT     UNAPIGEN.VC40_TABLE_TYPE,  
 A_DESCR_DOC_VERSION   OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_RQ                  OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_SD                  OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_DATE1               OUT     UNAPIGEN.DATE_TABLE_TYPE,  
 A_DATE2               OUT     UNAPIGEN.DATE_TABLE_TYPE,  
 A_DATE3               OUT     UNAPIGEN.DATE_TABLE_TYPE,  
 A_DATE4               OUT     UNAPIGEN.DATE_TABLE_TYPE,  
 A_DATE5               OUT     UNAPIGEN.DATE_TABLE_TYPE,  
 A_ALLOW_ANY_PP        OUT     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_SC_CLASS            OUT     UNAPIGEN.VC2_TABLE_TYPE,   
 A_LOG_HS              OUT     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_LOG_HS_DETAILS      OUT     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_ALLOW_MODIFY        OUT     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_AR                  OUT     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_ACTIVE              OUT     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_LC                  OUT     UNAPIGEN.VC2_TABLE_TYPE,   
 A_LC_VERSION          OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_SS                  OUT     UNAPIGEN.VC2_TABLE_TYPE,   
 A_NR_OF_ROWS          IN OUT  NUMBER,                    
 A_ORDER_BY_CLAUSE     IN      VARCHAR2,                  
 A_NEXT_ROWS           IN      NUMBER)                    
RETURN NUMBER IS

L_SC                             VARCHAR2(20);
L_ST                             VARCHAR2(20);
L_ST_VERSION                     VARCHAR2(20);
L_DESCRIPTION                    VARCHAR2(40);
L_SHELF_LIFE_VAL                 NUMBER(3);
L_SHELF_LIFE_UNIT                VARCHAR2(20);
L_SAMPLING_DATE                  TIMESTAMP WITH TIME ZONE;
L_CREATION_DATE                  TIMESTAMP WITH TIME ZONE;
L_CREATED_BY                     VARCHAR2(20);
L_EXEC_START_DATE                TIMESTAMP WITH TIME ZONE;
L_EXEC_END_DATE                  TIMESTAMP WITH TIME ZONE;
L_PRIORITY                       NUMBER(3);
L_LABEL_FORMAT                   VARCHAR2(20);
L_DESCR_DOC                      VARCHAR2(40);
L_DESCR_DOC_VERSION              VARCHAR2(20);
L_RQ                             VARCHAR2(20);
L_SD                             VARCHAR2(20);
L_DATE1                          TIMESTAMP WITH TIME ZONE;
L_DATE2                          TIMESTAMP WITH TIME ZONE;
L_DATE3                          TIMESTAMP WITH TIME ZONE;
L_DATE4                          TIMESTAMP WITH TIME ZONE;
L_DATE5                          TIMESTAMP WITH TIME ZONE;
L_ALLOW_ANY_PP                   CHAR(1);
L_SC_CLASS                       VARCHAR2(2);
L_LOG_HS                         CHAR(1);
L_LOG_HS_DETAILS                 CHAR(1);
L_ALLOW_MODIFY                   CHAR(1);
L_AR                             CHAR(1);
L_ACTIVE                         CHAR(1);
L_LC                             VARCHAR2(2);
L_LC_VERSION                     VARCHAR2(20);
L_SS                             VARCHAR2(2);
L_ORDER_BY_CLAUSE                VARCHAR2(255);
L_FROM_CLAUSE                    VARCHAR2(255);
L_NEXT_SCGK_JOIN                 VARCHAR2(4);
L_NEXT_STGK_JOIN                 VARCHAR2(4);
L_NEXT_RQGK_JOIN                 VARCHAR2(4);
L_NEXT_SDGK_JOIN                 VARCHAR2(4);
L_NEXT_SC_JOIN                   VARCHAR2(4);
L_COLUMN_HANDLED                 BOOLEAN_TABLE_TYPE;
L_ANYOR_PRESENT                  BOOLEAN;
L_COL_ANDOR                      VARCHAR2(3);
L_PREV_COL_TP                    VARCHAR2(40);
L_PREV_COL_ID                    VARCHAR2(40);
L_PREV_COL_INDEX                 INTEGER;
L_WHERE_CLAUSE4JOIN              VARCHAR2(1000);
L_LENGTH                         INTEGER;

BEGIN

   IF NVL(A_NR_OF_ROWS,0) = 0 THEN
      A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
   ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
      RETURN(UNAPIGEN.DBERR_NROFROWS);
   END IF;

   IF NVL(A_NEXT_ROWS, 0) NOT IN (-1, 0, 1) THEN
      RETURN(UNAPIGEN.DBERR_NEXTROWS);
   END IF;

   
   IF A_NEXT_ROWS = -1 THEN
      IF P_SELECTSC_CURSOR IS NOT NULL THEN
         DBMS_SQL.CLOSE_CURSOR(P_SELECTSC_CURSOR);
         P_SELECTSC_CURSOR := NULL;
      END IF;
      RETURN (UNAPIGEN.DBERR_SUCCESS);
   END IF;

   
   IF A_NEXT_ROWS = 1 THEN
      IF P_SELECTSC_CURSOR IS NULL THEN
         RETURN(UNAPIGEN.DBERR_NOCURSOR);
      END IF;
   END IF;

   
   IF NVL(A_NEXT_ROWS,0) = 0 THEN
      P_SELECTION_VAL_TAB.DELETE;
      L_SQL_STRING := 'SELECT a.sc, a.st, a.st_version, a.description, a.shelf_life_val, ' ||
                      'a.shelf_life_unit, a.sampling_date, a.creation_date, ' ||
                      'a.created_by, a.exec_start_date, a.exec_end_date, ' ||
                      'a.priority, a.label_format, a.descr_doc, a.descr_doc_version, a.rq, a.sd,' ||
                      'a.date1, a.date2, a.date3, a.date4, a.date5, ' ||
                      'a.allow_any_pp, a.sc_class, a.log_hs, a.log_hs_details, ' ||
                      'a.allow_modify, a.active, a.lc, a.lc_version, a.ss, a.ar FROM ';

      L_FROM_CLAUSE := 'dd' || UNAPIGEN.P_DD || '.uvsc a';

      
      L_WHERE_CLAUSE4JOIN := '';
      L_WHERE_CLAUSE := '';
      L_ANYOR_PRESENT := FALSE;
      FOR I IN 1..A_COL_NR_OF_ROWS LOOP
         L_COLUMN_HANDLED(I) := FALSE;
         IF LTRIM(RTRIM(UPPER(A_COL_ANDOR(I)))) = 'OR' AND
            NVL(A_COL_VALUE(I), ' ') <> ' ' THEN
            L_ANYOR_PRESENT := TRUE;
         END IF;
         
         
         IF I<>1 THEN
            IF NVL(A_COL_TP(I), ' ') = NVL(A_COL_TP(I-1), ' ') AND
               NVL(A_COL_ID(I), ' ') = NVL(A_COL_ID(I-1), ' ') AND
               NVL(A_COL_OPERATOR(I), '=') = '=' AND
               NVL(A_COL_OPERATOR(I-1), '=') = '=' AND
               NVL(A_COL_ANDOR(I-1), 'AND') =  'AND' AND
               (NVL(A_COL_VALUE(I), ' ') <> ' ' OR NVL(A_COL_VALUE(I-1), ' ') <> ' ') THEN
               IF I> 2 AND A_COL_ANDOR(I-2) = 'OR' THEN
                  L_ANYOR_PRESENT := TRUE;
               END IF;
            END IF;
         END IF;         
      END LOOP;

      
      
      

      L_NEXT_SCGK_JOIN := 'a';
      L_NEXT_STGK_JOIN := 'a';
      L_NEXT_RQGK_JOIN := 'a';
      L_NEXT_SDGK_JOIN := 'a';
      L_NEXT_SC_JOIN := 'a';
      FOR I IN REVERSE 1..A_COL_NR_OF_ROWS LOOP
         IF NVL(LTRIM(A_COL_ID(I)), ' ') = ' ' THEN
            RETURN(UNAPIGEN.DBERR_SELCOLSINVALID);
         END IF;

         
         L_COL_ANDOR := 'AND';
         IF I<>1 THEN
            L_COL_ANDOR := A_COL_ANDOR(I-1);
         END IF;
         IF L_COL_ANDOR IS NULL THEN
            
            L_COL_ANDOR := 'AND';
         END IF;
         IF L_COLUMN_HANDLED(I) = FALSE THEN
            IF NVL(A_COL_TP(I), ' ') = 'scgk' THEN 
               IF NVL(A_COL_VALUE(I), ' ') <> ' ' THEN
                  UNAPIGEN.WHERECLAUSESTRINGBUILDER (A_BASE_TABLE => 'utsc', A_INDEX =>I, A_COL_TP => A_COL_TP(I), A_COL_ID => A_COL_ID(I),
                                   A_COL_VALUE => A_COL_VALUE(I), A_COL_OPERATOR => A_COL_OPERATOR(I),
                                   A_COL_ANDOR => L_COL_ANDOR, A_ANYOR_PRESENT => L_ANYOR_PRESENT,
                                   A_JOINTABLE_PREFIX => 'utscgk', A_JOINCOLUMN1 => 'sc', A_JOINCOLUMN2 => '', 
                                   A_PREV_COL_TP => L_PREV_COL_TP, A_PREV_COL_ID => L_PREV_COL_ID, A_PREV_COL_INDEX => L_PREV_COL_INDEX,
                                   A_NEXTTABLE_TOJOIN => L_NEXT_SCGK_JOIN, A_FROM_CLAUSE => L_FROM_CLAUSE,
                                   A_WHERE_CLAUSE4JOIN => L_WHERE_CLAUSE4JOIN, A_WHERE_CLAUSE => L_WHERE_CLAUSE,
                                 A_SQL_VAL_TAB => P_SELECTION_VAL_TAB);                  
               ELSIF INSTR(A_ORDER_BY_CLAUSE, 't'|| TO_CHAR(I)) <> 0 THEN
                  L_FROM_CLAUSE := L_FROM_CLAUSE || ', utscgk' || A_COL_ID(I) || ' t' || I;
                  L_COL_ANDOR := 'AND'; 
                  
                  L_WHERE_CLAUSE4JOIN := L_WHERE_CLAUSE4JOIN ||
                                    't' || I || '.sc(+) = a.sc ' || L_COL_ANDOR || ' ';
               END IF;
               L_COLUMN_HANDLED(I) := TRUE; 
            ELSIF NVL(A_COL_TP(I), ' ') = 'stgk' THEN 
               IF NVL(A_COL_VALUE(I), ' ') <> ' ' THEN
                  UNAPIGEN.WHERECLAUSESTRINGBUILDER (A_BASE_TABLE => 'utsc', A_INDEX =>I, A_COL_TP => A_COL_TP(I), A_COL_ID => A_COL_ID(I),
                                   A_COL_VALUE => A_COL_VALUE(I), A_COL_OPERATOR => A_COL_OPERATOR(I),
                                   A_COL_ANDOR => L_COL_ANDOR, A_ANYOR_PRESENT => L_ANYOR_PRESENT,
                                   A_JOINTABLE_PREFIX => 'utstgk', A_JOINCOLUMN1 => 'st', A_JOINCOLUMN2 => 'version', 
                                   A_PREV_COL_TP => L_PREV_COL_TP, A_PREV_COL_ID => L_PREV_COL_ID, A_PREV_COL_INDEX => L_PREV_COL_INDEX,
                                   A_NEXTTABLE_TOJOIN => L_NEXT_STGK_JOIN, A_FROM_CLAUSE => L_FROM_CLAUSE,
                                   A_WHERE_CLAUSE4JOIN => L_WHERE_CLAUSE4JOIN, A_WHERE_CLAUSE => L_WHERE_CLAUSE,
                                 A_SQL_VAL_TAB => P_SELECTION_VAL_TAB);                  
               ELSIF INSTR(A_ORDER_BY_CLAUSE, 't'|| TO_CHAR(I)) <> 0 THEN
                  L_FROM_CLAUSE := L_FROM_CLAUSE || ', utstgk' || A_COL_ID(I) || ' t' || I;
                  L_COL_ANDOR := 'AND'; 
                  
                  L_WHERE_CLAUSE4JOIN := L_WHERE_CLAUSE4JOIN ||
                                       't' || I || '.st(+) = a.st AND '||
                                    't' || I || '.version(+) = a.st_version ' || L_COL_ANDOR || ' ';
               END IF;
               L_COLUMN_HANDLED(I) := TRUE; 
            ELSIF NVL(A_COL_TP(I), ' ') = 'rqgk' THEN 
               IF NVL(A_COL_VALUE(I), ' ') <> ' ' THEN
                  UNAPIGEN.WHERECLAUSESTRINGBUILDER (A_BASE_TABLE => 'utsc', A_INDEX =>I, A_COL_TP => A_COL_TP(I), A_COL_ID => A_COL_ID(I),
                                   A_COL_VALUE => A_COL_VALUE(I), A_COL_OPERATOR => A_COL_OPERATOR(I),
                                   A_COL_ANDOR => L_COL_ANDOR, A_ANYOR_PRESENT => L_ANYOR_PRESENT,
                                   A_JOINTABLE_PREFIX => 'utrqgk', A_JOINCOLUMN1 => 'rq', A_JOINCOLUMN2 => '', 
                                   A_PREV_COL_TP => L_PREV_COL_TP, A_PREV_COL_ID => L_PREV_COL_ID, A_PREV_COL_INDEX => L_PREV_COL_INDEX,
                                   A_NEXTTABLE_TOJOIN => L_NEXT_RQGK_JOIN, A_FROM_CLAUSE => L_FROM_CLAUSE,
                                   A_WHERE_CLAUSE4JOIN => L_WHERE_CLAUSE4JOIN, A_WHERE_CLAUSE => L_WHERE_CLAUSE,
                                 A_SQL_VAL_TAB => P_SELECTION_VAL_TAB);                  
               ELSIF INSTR(A_ORDER_BY_CLAUSE, 't'|| TO_CHAR(I)) <> 0 THEN
                  L_FROM_CLAUSE := L_FROM_CLAUSE || ', utrqgk' || A_COL_ID(I) || ' t' || I;
                  L_COL_ANDOR := 'AND'; 
                  
                  L_WHERE_CLAUSE4JOIN := L_WHERE_CLAUSE4JOIN ||
                                       't' || I || '.rq(+) = a.rq '|| L_COL_ANDOR || ' ';
               END IF;
               L_COLUMN_HANDLED(I) := TRUE; 
            ELSIF NVL(A_COL_TP(I), ' ') = 'sdgk' THEN 
               IF NVL(A_COL_VALUE(I), ' ') <> ' ' THEN
                  UNAPIGEN.WHERECLAUSESTRINGBUILDER (A_BASE_TABLE => 'utsc', A_INDEX =>I, A_COL_TP => A_COL_TP(I), A_COL_ID => A_COL_ID(I),
                                   A_COL_VALUE => A_COL_VALUE(I), A_COL_OPERATOR => A_COL_OPERATOR(I),
                                   A_COL_ANDOR => L_COL_ANDOR, A_ANYOR_PRESENT => L_ANYOR_PRESENT,
                                   A_JOINTABLE_PREFIX => 'utsdgk', A_JOINCOLUMN1 => 'sd', A_JOINCOLUMN2 => '', 
                                   A_PREV_COL_TP => L_PREV_COL_TP, A_PREV_COL_ID => L_PREV_COL_ID, A_PREV_COL_INDEX => L_PREV_COL_INDEX,
                                   A_NEXTTABLE_TOJOIN => L_NEXT_SDGK_JOIN, A_FROM_CLAUSE => L_FROM_CLAUSE,
                                   A_WHERE_CLAUSE4JOIN => L_WHERE_CLAUSE4JOIN, A_WHERE_CLAUSE => L_WHERE_CLAUSE,
                                 A_SQL_VAL_TAB => P_SELECTION_VAL_TAB);                  
               ELSIF INSTR(A_ORDER_BY_CLAUSE, 't'|| TO_CHAR(I)) <> 0 THEN
                  L_FROM_CLAUSE := L_FROM_CLAUSE || ', utsdgk' || A_COL_ID(I) || ' t' || I;
                  L_COL_ANDOR := 'AND'; 
                  
                  L_WHERE_CLAUSE4JOIN := L_WHERE_CLAUSE4JOIN ||
                                       't' || I || '.sd(+) = a.sd '|| L_COL_ANDOR || ' ';
               END IF;
               L_COLUMN_HANDLED(I) := TRUE; 
            ELSE
               
               IF NVL(A_COL_VALUE(I), ' ') <> ' ' THEN
                  UNAPIGEN.WHERECLAUSESTRINGBUILDER (A_BASE_TABLE => 'utsc', A_INDEX =>I, A_COL_TP => A_COL_TP(I), A_COL_ID => A_COL_ID(I),
                                   A_COL_VALUE => A_COL_VALUE(I), A_COL_OPERATOR => A_COL_OPERATOR(I),
                                   A_COL_ANDOR => L_COL_ANDOR, A_ANYOR_PRESENT => L_ANYOR_PRESENT,
                                   A_JOINTABLE_PREFIX => '', A_JOINCOLUMN1 => '', A_JOINCOLUMN2 => '', 
                                   A_PREV_COL_TP => L_PREV_COL_TP, A_PREV_COL_ID => L_PREV_COL_ID, A_PREV_COL_INDEX => L_PREV_COL_INDEX,
                                   A_NEXTTABLE_TOJOIN => L_NEXT_SC_JOIN, A_FROM_CLAUSE => L_FROM_CLAUSE,
                                   A_WHERE_CLAUSE4JOIN => L_WHERE_CLAUSE4JOIN, A_WHERE_CLAUSE => L_WHERE_CLAUSE,
                                 A_SQL_VAL_TAB => P_SELECTION_VAL_TAB);                  
               END IF;
               L_COLUMN_HANDLED(I) := TRUE; 
            END IF;
         END IF;
      END LOOP;

      
      IF SUBSTR(L_WHERE_CLAUSE4JOIN, -4) = 'AND ' THEN
         L_WHERE_CLAUSE4JOIN := SUBSTR(L_WHERE_CLAUSE4JOIN, 1,
                                  LENGTH(L_WHERE_CLAUSE4JOIN)-4);
      END IF;
      
      
      IF SUBSTR(L_WHERE_CLAUSE, -4) = 'AND ' THEN
         L_WHERE_CLAUSE := SUBSTR(L_WHERE_CLAUSE, 1,
                                  LENGTH(L_WHERE_CLAUSE)-4);
      END IF;
      IF UPPER(SUBSTR(L_WHERE_CLAUSE, -4)) = ' OR ' THEN
         L_WHERE_CLAUSE := SUBSTR(L_WHERE_CLAUSE, 1,
                                  LENGTH(L_WHERE_CLAUSE)-3);
      END IF;
      
      IF L_WHERE_CLAUSE4JOIN IS NOT NULL THEN
         IF L_WHERE_CLAUSE IS NULL THEN
            L_WHERE_CLAUSE := ' WHERE ' || L_WHERE_CLAUSE4JOIN;
         ELSE
            L_WHERE_CLAUSE := ' WHERE (' || L_WHERE_CLAUSE4JOIN || ') AND ('||L_WHERE_CLAUSE||') ';
         END IF;
      ELSE
         IF L_WHERE_CLAUSE IS NOT NULL THEN
            L_WHERE_CLAUSE := ' WHERE '||L_WHERE_CLAUSE;
         ELSE
            L_WHERE_CLAUSE := ' ';
         END IF;
      END IF;

      IF NVL(A_ORDER_BY_CLAUSE, ' ') = ' ' THEN
         L_ORDER_BY_CLAUSE := ' ORDER BY a.sc';
      ELSE
         L_ORDER_BY_CLAUSE := A_ORDER_BY_CLAUSE;
      END IF;

      L_SQL_STRING := L_SQL_STRING || L_FROM_CLAUSE || L_WHERE_CLAUSE || L_ORDER_BY_CLAUSE;
      P_SELECTION_CLAUSE := L_FROM_CLAUSE || L_WHERE_CLAUSE;

      IF P_SELECTSC_CURSOR IS NULL THEN
         P_SELECTSC_CURSOR := DBMS_SQL.OPEN_CURSOR;
      END IF;

      UNAPIAUT.ADDORACLECBOHINT (L_SQL_STRING) ;
      DBMS_SQL.PARSE(P_SELECTSC_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
      FOR L_X IN 1..P_SELECTION_VAL_TAB.COUNT() LOOP
         DBMS_SQL.BIND_VARIABLE(P_SELECTSC_CURSOR, ':col_val'||L_X , P_SELECTION_VAL_TAB(L_X)); 
      END LOOP;      
      
      DBMS_SQL.DEFINE_COLUMN(P_SELECTSC_CURSOR,       1,  L_SC,               20);
      DBMS_SQL.DEFINE_COLUMN(P_SELECTSC_CURSOR,       2,  L_ST,               20);
      DBMS_SQL.DEFINE_COLUMN(P_SELECTSC_CURSOR,       3,  L_ST_VERSION,       20);
      DBMS_SQL.DEFINE_COLUMN(P_SELECTSC_CURSOR,       4,  L_DESCRIPTION,      40);
      DBMS_SQL.DEFINE_COLUMN(P_SELECTSC_CURSOR,       5,  L_SHELF_LIFE_VAL);
      DBMS_SQL.DEFINE_COLUMN(P_SELECTSC_CURSOR,       6,  L_SHELF_LIFE_UNIT,  20);
      DBMS_SQL.DEFINE_COLUMN(P_SELECTSC_CURSOR,       7,  L_SAMPLING_DATE);
      DBMS_SQL.DEFINE_COLUMN(P_SELECTSC_CURSOR,       8,  L_CREATION_DATE);
      DBMS_SQL.DEFINE_COLUMN(P_SELECTSC_CURSOR,       9,  L_CREATED_BY,       20);
      DBMS_SQL.DEFINE_COLUMN(P_SELECTSC_CURSOR,       10, L_EXEC_START_DATE);
      DBMS_SQL.DEFINE_COLUMN(P_SELECTSC_CURSOR,       11, L_EXEC_END_DATE);
      DBMS_SQL.DEFINE_COLUMN(P_SELECTSC_CURSOR,       12, L_PRIORITY);
      DBMS_SQL.DEFINE_COLUMN(P_SELECTSC_CURSOR,       13, L_LABEL_FORMAT,     20);
      DBMS_SQL.DEFINE_COLUMN(P_SELECTSC_CURSOR,       14, L_DESCR_DOC,        40);
      DBMS_SQL.DEFINE_COLUMN(P_SELECTSC_CURSOR,       15, L_DESCR_DOC_VERSION,20);
      DBMS_SQL.DEFINE_COLUMN(P_SELECTSC_CURSOR,       16, L_RQ,               20);
      DBMS_SQL.DEFINE_COLUMN(P_SELECTSC_CURSOR,       17, L_SD,               20);
      DBMS_SQL.DEFINE_COLUMN(P_SELECTSC_CURSOR,       18, L_DATE1);
      DBMS_SQL.DEFINE_COLUMN(P_SELECTSC_CURSOR,       19, L_DATE2);
      DBMS_SQL.DEFINE_COLUMN(P_SELECTSC_CURSOR,       20, L_DATE3);
      DBMS_SQL.DEFINE_COLUMN(P_SELECTSC_CURSOR,       21, L_DATE4);
      DBMS_SQL.DEFINE_COLUMN(P_SELECTSC_CURSOR,       22, L_DATE5);
      DBMS_SQL.DEFINE_COLUMN_CHAR(P_SELECTSC_CURSOR,  23, L_ALLOW_ANY_PP,     1);
      DBMS_SQL.DEFINE_COLUMN(P_SELECTSC_CURSOR,       24, L_SC_CLASS,         2);
      DBMS_SQL.DEFINE_COLUMN_CHAR(P_SELECTSC_CURSOR,  25, L_LOG_HS,           1);
      DBMS_SQL.DEFINE_COLUMN_CHAR(P_SELECTSC_CURSOR,  26, L_LOG_HS_DETAILS,   1);
      DBMS_SQL.DEFINE_COLUMN_CHAR(P_SELECTSC_CURSOR,  27, L_ALLOW_MODIFY,     1);
      DBMS_SQL.DEFINE_COLUMN_CHAR(P_SELECTSC_CURSOR,  28, L_ACTIVE,           1);
      DBMS_SQL.DEFINE_COLUMN(P_SELECTSC_CURSOR,       29, L_LC,               2);
      DBMS_SQL.DEFINE_COLUMN(P_SELECTSC_CURSOR,       30, L_LC_VERSION,       20);
      DBMS_SQL.DEFINE_COLUMN(P_SELECTSC_CURSOR,       31, L_SS,               2);
      DBMS_SQL.DEFINE_COLUMN_CHAR(P_SELECTSC_CURSOR,  32, L_AR,               1);
      L_RESULT := DBMS_SQL.EXECUTE(P_SELECTSC_CURSOR);

   END IF;

   L_RESULT := DBMS_SQL.FETCH_ROWS(P_SELECTSC_CURSOR);
   L_FETCHED_ROWS := 0;

   LOOP
      EXIT WHEN L_RESULT = 0 OR L_FETCHED_ROWS >= A_NR_OF_ROWS;

      DBMS_SQL.COLUMN_VALUE(P_SELECTSC_CURSOR,         1 ,  L_SC);
      DBMS_SQL.COLUMN_VALUE(P_SELECTSC_CURSOR,         2 ,  L_ST);
      DBMS_SQL.COLUMN_VALUE(P_SELECTSC_CURSOR,         3 ,  L_ST_VERSION);
      DBMS_SQL.COLUMN_VALUE(P_SELECTSC_CURSOR,         4 ,  L_DESCRIPTION);
      DBMS_SQL.COLUMN_VALUE(P_SELECTSC_CURSOR,         5 ,  L_SHELF_LIFE_VAL);
      DBMS_SQL.COLUMN_VALUE(P_SELECTSC_CURSOR,         6 ,  L_SHELF_LIFE_UNIT);
      DBMS_SQL.COLUMN_VALUE(P_SELECTSC_CURSOR,         7 ,  L_SAMPLING_DATE);
      DBMS_SQL.COLUMN_VALUE(P_SELECTSC_CURSOR,         8 ,  L_CREATION_DATE);
      DBMS_SQL.COLUMN_VALUE(P_SELECTSC_CURSOR,         9 ,  L_CREATED_BY);
      DBMS_SQL.COLUMN_VALUE(P_SELECTSC_CURSOR,         10,  L_EXEC_START_DATE);
      DBMS_SQL.COLUMN_VALUE(P_SELECTSC_CURSOR,         11,  L_EXEC_END_DATE);
      DBMS_SQL.COLUMN_VALUE(P_SELECTSC_CURSOR,         12,  L_PRIORITY);
      DBMS_SQL.COLUMN_VALUE(P_SELECTSC_CURSOR,         13,  L_LABEL_FORMAT);
      DBMS_SQL.COLUMN_VALUE(P_SELECTSC_CURSOR,         14,  L_DESCR_DOC);
      DBMS_SQL.COLUMN_VALUE(P_SELECTSC_CURSOR,         15,  L_DESCR_DOC_VERSION);
      DBMS_SQL.COLUMN_VALUE(P_SELECTSC_CURSOR,         16,  L_RQ);
      DBMS_SQL.COLUMN_VALUE(P_SELECTSC_CURSOR,         17,  L_SD);
      DBMS_SQL.COLUMN_VALUE(P_SELECTSC_CURSOR,         18,  L_DATE1);
      DBMS_SQL.COLUMN_VALUE(P_SELECTSC_CURSOR,         19,  L_DATE2);
      DBMS_SQL.COLUMN_VALUE(P_SELECTSC_CURSOR,         20,  L_DATE3);
      DBMS_SQL.COLUMN_VALUE(P_SELECTSC_CURSOR,         21,  L_DATE4);
      DBMS_SQL.COLUMN_VALUE(P_SELECTSC_CURSOR,         22,  L_DATE5);
      DBMS_SQL.COLUMN_VALUE_CHAR(P_SELECTSC_CURSOR,    23,  L_ALLOW_ANY_PP);
      DBMS_SQL.COLUMN_VALUE(P_SELECTSC_CURSOR,         24,  L_SC_CLASS);
      DBMS_SQL.COLUMN_VALUE_CHAR(P_SELECTSC_CURSOR,    25,  L_LOG_HS);
      DBMS_SQL.COLUMN_VALUE_CHAR(P_SELECTSC_CURSOR,    26,  L_LOG_HS_DETAILS);
      DBMS_SQL.COLUMN_VALUE_CHAR(P_SELECTSC_CURSOR,    27,  L_ALLOW_MODIFY);
      DBMS_SQL.COLUMN_VALUE_CHAR(P_SELECTSC_CURSOR,    28,  L_ACTIVE);
      DBMS_SQL.COLUMN_VALUE(P_SELECTSC_CURSOR,         29,  L_LC);
      DBMS_SQL.COLUMN_VALUE(P_SELECTSC_CURSOR,         30,  L_LC_VERSION);
      DBMS_SQL.COLUMN_VALUE(P_SELECTSC_CURSOR,         31,  L_SS);
      DBMS_SQL.COLUMN_VALUE_CHAR(P_SELECTSC_CURSOR,    32,  L_AR);

      L_FETCHED_ROWS := L_FETCHED_ROWS + 1;

      A_SC(L_FETCHED_ROWS)                  :=   L_SC;
      A_ST(L_FETCHED_ROWS)                  :=   L_ST;
      A_ST_VERSION(L_FETCHED_ROWS)          :=   L_ST_VERSION;
      A_DESCRIPTION(L_FETCHED_ROWS)         :=   L_DESCRIPTION;
      A_SHELF_LIFE_VAL(L_FETCHED_ROWS)      :=   L_SHELF_LIFE_VAL;
      A_SHELF_LIFE_UNIT(L_FETCHED_ROWS)     :=   L_SHELF_LIFE_UNIT;
      A_SAMPLING_DATE(L_FETCHED_ROWS)       :=   L_SAMPLING_DATE;
      A_CREATION_DATE(L_FETCHED_ROWS)       :=   L_CREATION_DATE;
      A_CREATED_BY(L_FETCHED_ROWS)          :=   L_CREATED_BY;
      A_EXEC_START_DATE(L_FETCHED_ROWS)     :=   L_EXEC_START_DATE;
      A_EXEC_END_DATE(L_FETCHED_ROWS)       :=   L_EXEC_END_DATE;
      A_PRIORITY(L_FETCHED_ROWS)            :=   L_PRIORITY;
      A_LABEL_FORMAT(L_FETCHED_ROWS)        :=   L_LABEL_FORMAT;
      A_DESCR_DOC(L_FETCHED_ROWS)           :=   L_DESCR_DOC;
      A_DESCR_DOC_VERSION(L_FETCHED_ROWS)   :=   L_DESCR_DOC_VERSION;
      A_RQ(L_FETCHED_ROWS)                  :=   L_RQ;
      A_SD(L_FETCHED_ROWS)                  :=   L_SD;
      A_DATE1(L_FETCHED_ROWS)               :=   L_DATE1;
      A_DATE2(L_FETCHED_ROWS)               :=   L_DATE2;
      A_DATE3(L_FETCHED_ROWS)               :=   L_DATE3;
      A_DATE4(L_FETCHED_ROWS)               :=   L_DATE4;
      A_DATE5(L_FETCHED_ROWS)               :=   L_DATE5;
      A_ALLOW_ANY_PP(L_FETCHED_ROWS)        :=   L_ALLOW_ANY_PP;
      A_SC_CLASS(L_FETCHED_ROWS)            :=   L_SC_CLASS;
      A_LOG_HS(L_FETCHED_ROWS)              :=   L_LOG_HS;
      A_LOG_HS_DETAILS(L_FETCHED_ROWS)      :=   L_LOG_HS_DETAILS;
      A_ALLOW_MODIFY(L_FETCHED_ROWS)        :=   L_ALLOW_MODIFY;
      A_ACTIVE(L_FETCHED_ROWS)              :=   L_ACTIVE;
      A_LC(L_FETCHED_ROWS)                  :=   L_LC;
      A_LC_VERSION(L_FETCHED_ROWS)          :=   L_LC_VERSION;
      A_SS(L_FETCHED_ROWS)                  :=   L_SS;
      A_AR(L_FETCHED_ROWS)                  :=   L_AR;

      IF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
         L_RESULT := DBMS_SQL.FETCH_ROWS(P_SELECTSC_CURSOR);
      END IF;

   END LOOP;

   
   IF (L_FETCHED_ROWS = 0) THEN
       DBMS_SQL.CLOSE_CURSOR(P_SELECTSC_CURSOR);
       P_SELECTSC_CURSOR := NULL;
       RETURN(UNAPIGEN.DBERR_NORECORDS);
   ELSIF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
      DBMS_SQL.CLOSE_CURSOR(P_SELECTSC_CURSOR);
      P_SELECTSC_CURSOR := NULL;
      A_NR_OF_ROWS := L_FETCHED_ROWS;
   END IF;
   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
   WHEN OTHERS THEN
      L_SQLERRM := SQLERRM;
      UNAPIGEN.U4ROLLBACK;
      INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
      VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
             'SelectSample', L_SQLERRM);
      UNAPIGEN.U4COMMIT;
      L_LENGTH := 200;
      FOR L_X IN 1..10 LOOP
         IF ( LENGTH(L_SQL_STRING) > ((L_LENGTH*(L_X-1))+1) ) THEN
            INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
            VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                   'SelectSample', '(SQL)'||SUBSTR(L_SQL_STRING, (L_LENGTH*(L_X-1))+1, L_LENGTH));             
         ELSE
            EXIT;
         END IF;
      END LOOP;            
      UNAPIGEN.U4COMMIT;
      IF DBMS_SQL.IS_OPEN(P_SELECTSC_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(P_SELECTSC_CURSOR);
      END IF;
      RETURN(UNAPIGEN.DBERR_GENFAIL);
END SELECTSAMPLE;

FUNCTION SELECTSCGKVALUES
(A_COL_ID           IN      UNAPIGEN.VC40_TABLE_TYPE,  
 A_COL_TP           IN      UNAPIGEN.VC40_TABLE_TYPE,  
 A_COL_VALUE        IN      UNAPIGEN.VC40_TABLE_TYPE,  
 A_COL_NR_OF_ROWS   IN      NUMBER,                    
 A_GK               IN      VARCHAR2,                  
 A_VALUE            OUT     UNAPIGEN.VC40_TABLE_TYPE,  
 A_NR_OF_ROWS       IN OUT  NUMBER,                    
 A_ORDER_BY_CLAUSE  IN      VARCHAR2,                  
 A_NEXT_ROWS        IN      NUMBER)                    
RETURN NUMBER IS
L_COL_OPERATOR           UNAPIGEN.VC20_TABLE_TYPE;
L_COL_ANDOR              UNAPIGEN.VC3_TABLE_TYPE;
BEGIN
FOR L_X IN 1..A_COL_NR_OF_ROWS LOOP
    L_COL_OPERATOR(L_X) := '=';
    L_COL_ANDOR(L_X) := 'AND';
END LOOP;
 RETURN(UNAPISC.SELECTSCGKVALUES(A_COL_ID,
                                 A_COL_TP,
                                 A_COL_VALUE,
                                 L_COL_OPERATOR,
                                 L_COL_ANDOR,
                                 A_COL_NR_OF_ROWS,
                                 A_GK,
                                 A_VALUE,
                                 A_NR_OF_ROWS,
                                 A_ORDER_BY_CLAUSE,
                                 A_NEXT_ROWS));
END SELECTSCGKVALUES;

FUNCTION SELECTSCGKVALUES
(A_COL_ID           IN      UNAPIGEN.VC40_TABLE_TYPE,  
 A_COL_TP           IN      UNAPIGEN.VC40_TABLE_TYPE,  
 A_COL_VALUE        IN      UNAPIGEN.VC40_TABLE_TYPE,  
 A_COL_OPERATOR     IN      UNAPIGEN.VC20_TABLE_TYPE,  
 A_COL_ANDOR        IN      UNAPIGEN.VC3_TABLE_TYPE,   
 A_COL_NR_OF_ROWS   IN      NUMBER,                    
 A_GK               IN      VARCHAR2,                  
 A_VALUE            OUT     UNAPIGEN.VC40_TABLE_TYPE,  
 A_NR_OF_ROWS       IN OUT  NUMBER,                    
 A_ORDER_BY_CLAUSE  IN      VARCHAR2,                  
 A_NEXT_ROWS        IN      NUMBER)                    
RETURN NUMBER IS

L_VALUE                          VARCHAR2(40);
L_ORDER_BY_CLAUSE                VARCHAR2(255);
L_FROM_CLAUSE                    VARCHAR2(500);
L_NEXT_SCGK_JOIN                 VARCHAR2(4);
L_NEXT_STGK_JOIN                 VARCHAR2(4);
L_NEXT_RQGK_JOIN                 VARCHAR2(4);
L_NEXT_MEGK_JOIN                 VARCHAR2(4);
L_NEXT_SDGK_JOIN                 VARCHAR2(4);
L_NEXT_ME_JOIN                   VARCHAR2(4);
L_NEXT_SC_JOIN                   VARCHAR2(4);
L_COLUMN_HANDLED                 BOOLEAN_TABLE_TYPE;
L_ANYOR_PRESENT                  BOOLEAN;
L_COL_ANDOR                      VARCHAR2(3);
L_PREV_COL_TP                    VARCHAR2(40);
L_PREV_COL_ID                    VARCHAR2(40);
L_PREV_COL_INDEX                 INTEGER;
L_WHERE_CLAUSE4JOIN              VARCHAR2(2000);
L_LENGTH                         INTEGER;
L_ME_SCANNED                     BOOLEAN;
L_FROM_CLAUSE_EXT_WITH_UVSCME    BOOLEAN;
L_JOIN_COLUMN4ME                 VARCHAR2(4);
L_SQL_VAL_TAB                    VC40_NESTEDTABLE_TYPE := VC40_NESTEDTABLE_TYPE();

BEGIN

   IF NVL(A_NR_OF_ROWS,0) = 0 THEN
      A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
   ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
      RETURN (UNAPIGEN.DBERR_NROFROWS);
   END IF;

   IF NVL(A_NEXT_ROWS, 0) NOT IN (-1, 0, 1) THEN
      RETURN(UNAPIGEN.DBERR_NEXTROWS);
   END IF;

   
   IF A_NEXT_ROWS = -1 THEN
      IF P_SELECTSCGK_CURSOR IS NOT NULL THEN
         DBMS_SQL.CLOSE_CURSOR(P_SELECTSCGK_CURSOR);
         P_SELECTSCGK_CURSOR := NULL;
      END IF;
      RETURN (UNAPIGEN.DBERR_SUCCESS);
   END IF;

   
   IF A_NEXT_ROWS = 1 THEN
      IF P_SELECTSCGK_CURSOR IS NULL THEN
         RETURN(UNAPIGEN.DBERR_NOCURSOR);
      END IF;
   END IF;

   
   IF NVL(A_NEXT_ROWS,0) = 0 THEN

      
      L_SQL_STRING := 'SELECT DISTINCT b.' || A_GK ||' FROM ';
      L_FROM_CLAUSE := 'dd' || UNAPIGEN.P_DD || '.uvsc a, utscgk' || A_GK || ' b';

      
      L_WHERE_CLAUSE4JOIN := 'a.sc = b.sc AND '; 
      L_WHERE_CLAUSE := '';
      L_ANYOR_PRESENT := FALSE;
      FOR I IN 1..A_COL_NR_OF_ROWS LOOP
         L_COLUMN_HANDLED(I) := FALSE;
         IF LTRIM(RTRIM(UPPER(A_COL_ANDOR(I)))) = 'OR' AND
            NVL(A_COL_VALUE(I), ' ') <> ' ' THEN
            L_ANYOR_PRESENT := TRUE;
         END IF;
         
         
         IF I<>1 THEN
            IF NVL(A_COL_TP(I), ' ') = NVL(A_COL_TP(I-1), ' ') AND
               NVL(A_COL_ID(I), ' ') = NVL(A_COL_ID(I-1), ' ') AND
               NVL(A_COL_OPERATOR(I), '=') = '=' AND
               NVL(A_COL_OPERATOR(I-1), '=') = '=' AND
               NVL(A_COL_ANDOR(I-1), 'AND') =  'AND' AND
               (NVL(A_COL_VALUE(I), ' ') <> ' ' OR NVL(A_COL_VALUE(I-1), ' ') <> ' ') THEN
               IF I> 2 AND A_COL_ANDOR(I-2) = 'OR' THEN
                  L_ANYOR_PRESENT := TRUE;
               END IF;
            END IF;
         END IF;         
      END LOOP;
      
      
      

      L_NEXT_SCGK_JOIN := 'b';
      L_NEXT_STGK_JOIN := 'a';
      L_NEXT_RQGK_JOIN := 'a';
      L_NEXT_MEGK_JOIN := 'b';
      L_NEXT_SDGK_JOIN := 'a';
      L_NEXT_ME_JOIN := 'me';
      L_NEXT_SC_JOIN := 'a';
      
      

      
      
      
      
      L_ME_SCANNED := FALSE;
      L_FROM_CLAUSE_EXT_WITH_UVSCME := FALSE ;
      LOOP
         FOR I IN REVERSE 1..A_COL_NR_OF_ROWS LOOP
            IF NVL(LTRIM(A_COL_ID(I)), ' ') = ' ' THEN
               RETURN(UNAPIGEN.DBERR_SELCOLSINVALID);
            END IF;
            
            L_COL_ANDOR := 'AND';
            IF I<>1 THEN
               L_COL_ANDOR := A_COL_ANDOR(I-1);
            END IF;
            IF L_COL_ANDOR IS NULL THEN
               
               L_COL_ANDOR := 'AND';
            END IF;

            IF L_COLUMN_HANDLED(I) = FALSE THEN
               IF L_ME_SCANNED = FALSE THEN
                  IF NVL(A_COL_TP(I), ' ') = 'me' THEN 
                     IF (NVL(A_COL_VALUE(I), ' ') <> ' ') AND
                        INSTR(L_FROM_CLAUSE, '.uvscme me') = 0 THEN
                        L_FROM_CLAUSE := 'dd' || UNAPIGEN.P_DD || '.uvscme me,' || L_FROM_CLAUSE ;
                        L_WHERE_CLAUSE4JOIN := L_WHERE_CLAUSE4JOIN || ' me.sc = b.sc AND '; 
                        L_FROM_CLAUSE_EXT_WITH_UVSCME := TRUE ;
                     END IF;
                     IF NVL(A_COL_VALUE(I), ' ') <> ' ' THEN
                        UNAPIGEN.WHERECLAUSESTRINGBUILDER (A_BASE_TABLE => 'utsc', A_INDEX =>I, A_COL_TP => A_COL_TP(I), A_COL_ID => A_COL_ID(I),
                                       A_COL_VALUE => A_COL_VALUE(I), A_COL_OPERATOR => A_COL_OPERATOR(I),
                                       A_COL_ANDOR => L_COL_ANDOR, A_ANYOR_PRESENT => L_ANYOR_PRESENT,
                                       A_JOINTABLE_PREFIX => '', A_JOINCOLUMN1 => '', A_JOINCOLUMN2 => '', 
                                       A_PREV_COL_TP => L_PREV_COL_TP, A_PREV_COL_ID => L_PREV_COL_ID, A_PREV_COL_INDEX => L_PREV_COL_INDEX,
                                       A_NEXTTABLE_TOJOIN => L_NEXT_ME_JOIN, A_FROM_CLAUSE => L_FROM_CLAUSE,
                                       A_WHERE_CLAUSE4JOIN => L_WHERE_CLAUSE4JOIN, A_WHERE_CLAUSE => L_WHERE_CLAUSE,
                                       A_BASETABLE4GK_ALIAS => 'me',
                                       A_SQL_VAL_TAB => L_SQL_VAL_TAB);                                                     
                     END IF;
                     L_COLUMN_HANDLED(I) := TRUE; 
                     
                     IF L_FROM_CLAUSE_EXT_WITH_UVSCME THEN
                       L_NEXT_MEGK_JOIN := 'me';  
                     END IF ;
                  END IF;
               ELSE
                  
                  IF NVL(A_COL_TP(I), ' ') = 'scgk' THEN 
                     IF NVL(A_COL_VALUE(I), ' ') <> ' ' THEN
                        UNAPIGEN.WHERECLAUSESTRINGBUILDER (A_BASE_TABLE => 'utsc', A_INDEX =>I, A_COL_TP => A_COL_TP(I), A_COL_ID => A_COL_ID(I),
                                       A_COL_VALUE => A_COL_VALUE(I), A_COL_OPERATOR => A_COL_OPERATOR(I),
                                       A_COL_ANDOR => L_COL_ANDOR, A_ANYOR_PRESENT => L_ANYOR_PRESENT,
                                       A_JOINTABLE_PREFIX => 'utscgk', A_JOINCOLUMN1 => 'sc', A_JOINCOLUMN2 => '', 
                                       A_PREV_COL_TP => L_PREV_COL_TP, A_PREV_COL_ID => L_PREV_COL_ID, A_PREV_COL_INDEX => L_PREV_COL_INDEX,
                                       A_NEXTTABLE_TOJOIN => L_NEXT_SCGK_JOIN, A_FROM_CLAUSE => L_FROM_CLAUSE,
                                       A_WHERE_CLAUSE4JOIN => L_WHERE_CLAUSE4JOIN, A_WHERE_CLAUSE => L_WHERE_CLAUSE,
                                       A_SQL_VAL_TAB => L_SQL_VAL_TAB);                  
                     END IF;
                     L_COLUMN_HANDLED(I) := TRUE; 
                  ELSIF NVL(A_COL_TP(I), ' ') = 'stgk' THEN 
                     IF NVL(A_COL_VALUE(I), ' ') <> ' ' THEN
                        UNAPIGEN.WHERECLAUSESTRINGBUILDER (A_BASE_TABLE => 'utsc', A_INDEX =>I, A_COL_TP => A_COL_TP(I), A_COL_ID => A_COL_ID(I),
                                       A_COL_VALUE => A_COL_VALUE(I), A_COL_OPERATOR => A_COL_OPERATOR(I),
                                       A_COL_ANDOR => L_COL_ANDOR, A_ANYOR_PRESENT => L_ANYOR_PRESENT,
                                       A_JOINTABLE_PREFIX => 'utstgk', A_JOINCOLUMN1 => 'st', A_JOINCOLUMN2 => 'version', 
                                       A_PREV_COL_TP => L_PREV_COL_TP, A_PREV_COL_ID => L_PREV_COL_ID, A_PREV_COL_INDEX => L_PREV_COL_INDEX,
                                       A_NEXTTABLE_TOJOIN => L_NEXT_STGK_JOIN, A_FROM_CLAUSE => L_FROM_CLAUSE,
                                       A_WHERE_CLAUSE4JOIN => L_WHERE_CLAUSE4JOIN, A_WHERE_CLAUSE => L_WHERE_CLAUSE,
                                       A_SQL_VAL_TAB => L_SQL_VAL_TAB);                  
                     END IF;
                     L_COLUMN_HANDLED(I) := TRUE; 
                  ELSIF NVL(A_COL_TP(I), ' ') = 'rqgk' THEN 
                     IF NVL(A_COL_VALUE(I), ' ') <> ' ' THEN
                        UNAPIGEN.WHERECLAUSESTRINGBUILDER (A_BASE_TABLE => 'utsc', A_INDEX =>I, A_COL_TP => A_COL_TP(I), A_COL_ID => A_COL_ID(I),
                                       A_COL_VALUE => A_COL_VALUE(I), A_COL_OPERATOR => A_COL_OPERATOR(I),
                                       A_COL_ANDOR => L_COL_ANDOR, A_ANYOR_PRESENT => L_ANYOR_PRESENT,
                                       A_JOINTABLE_PREFIX => 'utrqgk', A_JOINCOLUMN1 => 'rq', A_JOINCOLUMN2 => '', 
                                       A_PREV_COL_TP => L_PREV_COL_TP, A_PREV_COL_ID => L_PREV_COL_ID, A_PREV_COL_INDEX => L_PREV_COL_INDEX,
                                       A_NEXTTABLE_TOJOIN => L_NEXT_RQGK_JOIN, A_FROM_CLAUSE => L_FROM_CLAUSE,
                                       A_WHERE_CLAUSE4JOIN => L_WHERE_CLAUSE4JOIN, A_WHERE_CLAUSE => L_WHERE_CLAUSE,
                                       A_SQL_VAL_TAB => L_SQL_VAL_TAB);                  
                     END IF;
                     L_COLUMN_HANDLED(I) := TRUE; 
                  ELSIF NVL(A_COL_TP(I), ' ') = 'sdgk' THEN 
                     IF NVL(A_COL_VALUE(I), ' ') <> ' ' THEN
                        UNAPIGEN.WHERECLAUSESTRINGBUILDER (A_BASE_TABLE => 'utsc', A_INDEX =>I, A_COL_TP => A_COL_TP(I), A_COL_ID => A_COL_ID(I),
                                       A_COL_VALUE => A_COL_VALUE(I), A_COL_OPERATOR => A_COL_OPERATOR(I),
                                       A_COL_ANDOR => L_COL_ANDOR, A_ANYOR_PRESENT => L_ANYOR_PRESENT,
                                       A_JOINTABLE_PREFIX => 'utsdgk', A_JOINCOLUMN1 => 'sd', A_JOINCOLUMN2 => '', 
                                       A_PREV_COL_TP => L_PREV_COL_TP, A_PREV_COL_ID => L_PREV_COL_ID, A_PREV_COL_INDEX => L_PREV_COL_INDEX,
                                       A_NEXTTABLE_TOJOIN => L_NEXT_SDGK_JOIN, A_FROM_CLAUSE => L_FROM_CLAUSE,
                                       A_WHERE_CLAUSE4JOIN => L_WHERE_CLAUSE4JOIN, A_WHERE_CLAUSE => L_WHERE_CLAUSE,
                                       A_SQL_VAL_TAB => L_SQL_VAL_TAB);                  
                     END IF;
                     L_COLUMN_HANDLED(I) := TRUE; 
                  ELSIF NVL(A_COL_TP(I), ' ') = 'megk' THEN 
                     IF L_NEXT_MEGK_JOIN = 'b' OR L_ANYOR_PRESENT THEN
                        L_JOIN_COLUMN4ME := 'sc';
                     ELSE
                        L_JOIN_COLUMN4ME := 'me';
                     END IF;
                     IF NVL(A_COL_VALUE(I), ' ') <> ' ' THEN
                        UNAPIGEN.WHERECLAUSESTRINGBUILDER (A_BASE_TABLE => 'utsc', A_INDEX =>I, A_COL_TP => A_COL_TP(I), A_COL_ID => A_COL_ID(I),
                                       A_COL_VALUE => A_COL_VALUE(I), A_COL_OPERATOR => A_COL_OPERATOR(I),
                                       A_COL_ANDOR => L_COL_ANDOR, A_ANYOR_PRESENT => L_ANYOR_PRESENT,
                                       A_JOINTABLE_PREFIX => 'utscmegk', A_JOINCOLUMN1 => L_JOIN_COLUMN4ME, A_JOINCOLUMN2 => '', 
                                       A_PREV_COL_TP => L_PREV_COL_TP, A_PREV_COL_ID => L_PREV_COL_ID, A_PREV_COL_INDEX => L_PREV_COL_INDEX,
                                       A_NEXTTABLE_TOJOIN => L_NEXT_MEGK_JOIN, A_FROM_CLAUSE => L_FROM_CLAUSE,
                                       A_WHERE_CLAUSE4JOIN => L_WHERE_CLAUSE4JOIN, A_WHERE_CLAUSE => L_WHERE_CLAUSE,
                                       A_SQL_VAL_TAB => L_SQL_VAL_TAB);                  
                     END IF;
                     L_COLUMN_HANDLED(I) := TRUE; 
                  ELSIF NVL(A_COL_TP(I), ' ') = 'me' THEN 
                     
                     NULL;

                  ELSE 
                     IF NVL(A_COL_VALUE(I), ' ') <> ' ' THEN
                        UNAPIGEN.WHERECLAUSESTRINGBUILDER (A_BASE_TABLE => 'utsc', A_INDEX =>I, A_COL_TP => A_COL_TP(I), A_COL_ID => A_COL_ID(I),
                                       A_COL_VALUE => A_COL_VALUE(I), A_COL_OPERATOR => A_COL_OPERATOR(I),
                                       A_COL_ANDOR => L_COL_ANDOR, A_ANYOR_PRESENT => L_ANYOR_PRESENT,
                                       A_JOINTABLE_PREFIX => '', A_JOINCOLUMN1 => '', A_JOINCOLUMN2 => '', 
                                       A_PREV_COL_TP => L_PREV_COL_TP, A_PREV_COL_ID => L_PREV_COL_ID, A_PREV_COL_INDEX => L_PREV_COL_INDEX,
                                       A_NEXTTABLE_TOJOIN => L_NEXT_SC_JOIN, A_FROM_CLAUSE => L_FROM_CLAUSE,
                                       A_WHERE_CLAUSE4JOIN => L_WHERE_CLAUSE4JOIN, A_WHERE_CLAUSE => L_WHERE_CLAUSE,
                                       A_SQL_VAL_TAB => L_SQL_VAL_TAB);                  
                     END IF;
                     L_COLUMN_HANDLED(I) := TRUE; 
                  END IF;
               END IF;
            END IF;
         END LOOP;
         EXIT WHEN L_ME_SCANNED;
         L_ME_SCANNED := TRUE;
      END LOOP;

      
      IF SUBSTR(L_WHERE_CLAUSE4JOIN, -4) = 'AND ' THEN
         L_WHERE_CLAUSE4JOIN := SUBSTR(L_WHERE_CLAUSE4JOIN, 1,
                                  LENGTH(L_WHERE_CLAUSE4JOIN)-4);
      END IF;
      
      
      IF SUBSTR(L_WHERE_CLAUSE, -4) = 'AND ' THEN
         L_WHERE_CLAUSE := SUBSTR(L_WHERE_CLAUSE, 1,
                                  LENGTH(L_WHERE_CLAUSE)-4);
      END IF;
      IF UPPER(SUBSTR(L_WHERE_CLAUSE, -4)) = ' OR ' THEN
         L_WHERE_CLAUSE := SUBSTR(L_WHERE_CLAUSE, 1,
                                  LENGTH(L_WHERE_CLAUSE)-3);
      END IF;
      
      IF L_WHERE_CLAUSE4JOIN IS NOT NULL THEN
         IF L_WHERE_CLAUSE IS NULL THEN
            L_WHERE_CLAUSE := ' WHERE ' || L_WHERE_CLAUSE4JOIN;
         ELSE
            L_WHERE_CLAUSE := ' WHERE (' || L_WHERE_CLAUSE4JOIN || ') AND ('||L_WHERE_CLAUSE||') ';
         END IF;
      ELSE
         IF L_WHERE_CLAUSE IS NOT NULL THEN
            L_WHERE_CLAUSE := ' WHERE '||L_WHERE_CLAUSE;
         ELSE
            L_WHERE_CLAUSE := ' ';
         END IF;
      END IF;

      L_ORDER_BY_CLAUSE := NVL(A_ORDER_BY_CLAUSE, ' ORDER BY 1');

      L_SQL_STRING := L_SQL_STRING || L_FROM_CLAUSE || L_WHERE_CLAUSE || L_ORDER_BY_CLAUSE;

      L_LENGTH := 200;
      FOR L_X IN 1..10 LOOP
         IF ( LENGTH(L_SQL_STRING) > ((L_LENGTH*(L_X-1))+1) ) THEN
            DBMS_OUTPUT.PUT_LINE(SUBSTR(L_SQL_STRING, (L_LENGTH*(L_X-1))+1, L_LENGTH));
         ELSE
            EXIT;
         END IF;
      END LOOP;            

      IF P_SELECTSCGK_CURSOR IS NULL THEN
         P_SELECTSCGK_CURSOR := DBMS_SQL.OPEN_CURSOR;
      END IF;

      UNAPIAUT.ADDORACLECBOHINT (L_SQL_STRING) ;
      DBMS_SQL.PARSE(P_SELECTSCGK_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
      FOR L_X IN 1..L_SQL_VAL_TAB.COUNT() LOOP
         DBMS_SQL.BIND_VARIABLE(P_SELECTSCGK_CURSOR, ':col_val'||L_X , L_SQL_VAL_TAB(L_X)); 
      END LOOP;   

      DBMS_SQL.DEFINE_COLUMN(P_SELECTSCGK_CURSOR, 1, L_VALUE, 40);

      L_RESULT := DBMS_SQL.EXECUTE(P_SELECTSCGK_CURSOR);

   END IF;

   L_RESULT := DBMS_SQL.FETCH_ROWS(P_SELECTSCGK_CURSOR);
   L_FETCHED_ROWS := 0;

   LOOP
      EXIT WHEN L_RESULT = 0 OR L_FETCHED_ROWS >= A_NR_OF_ROWS;

      DBMS_SQL.COLUMN_VALUE(P_SELECTSCGK_CURSOR, 1, L_VALUE);

      L_FETCHED_ROWS := L_FETCHED_ROWS + 1;

      A_VALUE(L_FETCHED_ROWS) := L_VALUE;

      IF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
         L_RESULT := DBMS_SQL.FETCH_ROWS(P_SELECTSCGK_CURSOR);
      END IF;
   END LOOP;

   
   IF (L_FETCHED_ROWS = 0) THEN
       DBMS_SQL.CLOSE_CURSOR(P_SELECTSCGK_CURSOR);
       P_SELECTSCGK_CURSOR := NULL;
       RETURN(UNAPIGEN.DBERR_NORECORDS);
   ELSIF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
      DBMS_SQL.CLOSE_CURSOR(P_SELECTSCGK_CURSOR);
      P_SELECTSCGK_CURSOR := NULL;
      A_NR_OF_ROWS := L_FETCHED_ROWS;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
   WHEN OTHERS THEN
      L_SQLERRM := SQLERRM;
      UNAPIGEN.U4ROLLBACK;
      INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
      VALUES (UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
              'SelectScGkValues', L_SQLERRM);
      UNAPIGEN.U4COMMIT;
      L_LENGTH := 200;
      FOR L_X IN 1..10 LOOP
         IF ( LENGTH(L_SQL_STRING) > ((L_LENGTH*(L_X-1))+1) ) THEN
            INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
            VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                   'SelectScGkValues', '(SQL)'||SUBSTR(L_SQL_STRING, (L_LENGTH*(L_X-1))+1, L_LENGTH));             
         ELSE
            EXIT;
         END IF;
      END LOOP;            
      L_LENGTH := 200;
      FOR L_X IN 1..10 LOOP
         IF ( LENGTH(L_SQLERRM) > ((L_LENGTH*(L_X-1))+1) ) THEN
            DBMS_OUTPUT.PUT_LINE(SUBSTR(L_SQLERRM, (L_LENGTH*(L_X-1))+1, L_LENGTH));
         ELSE
            EXIT;
         END IF;
      END LOOP;            
      UNAPIGEN.U4COMMIT;
      IF DBMS_SQL.IS_OPEN (P_SELECTSCGK_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR (P_SELECTSCGK_CURSOR);
      END IF;
      RETURN(UNAPIGEN.DBERR_GENFAIL);
END SELECTSCGKVALUES;

FUNCTION SELECTSCPROPVALUES
(A_COL_ID           IN      UNAPIGEN.VC40_TABLE_TYPE,  
 A_COL_TP           IN      UNAPIGEN.VC40_TABLE_TYPE,  
 A_COL_VALUE        IN      UNAPIGEN.VC40_TABLE_TYPE,  
 A_COL_NR_OF_ROWS   IN      NUMBER,                    
 A_PROP             IN      VARCHAR2,                  
 A_VALUE            OUT     UNAPIGEN.VC40_TABLE_TYPE,  
 A_NR_OF_ROWS       IN OUT  NUMBER,                    
 A_ORDER_BY_CLAUSE  IN      VARCHAR2,                  
 A_NEXT_ROWS        IN      NUMBER)                    
RETURN NUMBER IS
L_COL_OPERATOR           UNAPIGEN.VC20_TABLE_TYPE;
L_COL_ANDOR              UNAPIGEN.VC3_TABLE_TYPE;
BEGIN
FOR L_X IN 1..A_COL_NR_OF_ROWS LOOP
    L_COL_OPERATOR(L_X) := '=';
    L_COL_ANDOR(L_X) := 'AND';
END LOOP;
 RETURN(UNAPISC.SELECTSCPROPVALUES(A_COL_ID,
                                 A_COL_TP,
                                 A_COL_VALUE,
                                 L_COL_OPERATOR,
                                 L_COL_ANDOR,
                                 A_COL_NR_OF_ROWS,
                                 A_PROP,
                                 A_VALUE,
                                 A_NR_OF_ROWS,
                                 A_ORDER_BY_CLAUSE,
                                 A_NEXT_ROWS));
END SELECTSCPROPVALUES;

FUNCTION SELECTSCPROPVALUES
(A_COL_ID           IN      UNAPIGEN.VC40_TABLE_TYPE,  
 A_COL_TP           IN      UNAPIGEN.VC40_TABLE_TYPE,  
 A_COL_VALUE        IN      UNAPIGEN.VC40_TABLE_TYPE,  
 A_COL_OPERATOR     IN      UNAPIGEN.VC20_TABLE_TYPE,  
 A_COL_ANDOR        IN      UNAPIGEN.VC3_TABLE_TYPE,   
 A_COL_NR_OF_ROWS   IN      NUMBER,                    
 A_PROP             IN      VARCHAR2,                  
 A_VALUE            OUT     UNAPIGEN.VC40_TABLE_TYPE,  
 A_NR_OF_ROWS       IN OUT  NUMBER,                    
 A_ORDER_BY_CLAUSE  IN      VARCHAR2,                  
 A_NEXT_ROWS        IN      NUMBER)                    
RETURN NUMBER IS

L_VALUE                          VARCHAR2(40);
L_ORDER_BY_CLAUSE                VARCHAR2(255);
L_FROM_CLAUSE                    VARCHAR2(500);
L_NEXT_SC_JOIN                   VARCHAR2(4);
L_NEXT_ME_JOIN                   VARCHAR2(4);
L_NEXT_SCGK_JOIN                 VARCHAR2(4);
L_NEXT_STGK_JOIN                 VARCHAR2(4);
L_NEXT_RQGK_JOIN                 VARCHAR2(4);
L_NEXT_MEGK_JOIN                 VARCHAR2(4);
L_NEXT_SDGK_JOIN                 VARCHAR2(4);
L_COLUMN_HANDLED                 BOOLEAN_TABLE_TYPE;
L_ANYOR_PRESENT                  BOOLEAN;
L_COL_ANDOR                      VARCHAR2(3);
L_PREV_COL_TP                    VARCHAR2(40);
L_PREV_COL_ID                    VARCHAR2(40);
L_PREV_COL_INDEX                 INTEGER;
L_WHERE_CLAUSE4JOIN              VARCHAR2(2000);
L_LENGTH                         INTEGER;
L_ME_SCANNED                     BOOLEAN;
L_FROM_CLAUSE_EXT_WITH_UVSCME    BOOLEAN;
L_JOIN_COLUMN4ME                 VARCHAR2(4);
L_SQL_VAL_TAB                    VC40_NESTEDTABLE_TYPE := VC40_NESTEDTABLE_TYPE();

BEGIN

   IF NVL(A_NR_OF_ROWS,0) = 0 THEN
      A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
   ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
      RETURN (UNAPIGEN.DBERR_NROFROWS);
   END IF;

   IF NVL(A_NEXT_ROWS, 0) NOT IN (-1, 0, 1) THEN
      RETURN(UNAPIGEN.DBERR_NEXTROWS);
   END IF;

   
   IF A_NEXT_ROWS = -1 THEN
      IF P_SELECTSCPROP_CURSOR IS NOT NULL THEN
         DBMS_SQL.CLOSE_CURSOR(P_SELECTSCPROP_CURSOR);
         P_SELECTSCPROP_CURSOR := NULL;
      END IF;
      RETURN (UNAPIGEN.DBERR_SUCCESS);
   END IF;

   
   IF A_NEXT_ROWS = 1 THEN
      IF P_SELECTSCPROP_CURSOR IS NULL THEN
         RETURN(UNAPIGEN.DBERR_NOCURSOR);
      END IF;
   END IF;

   
   IF NVL(A_NEXT_ROWS,0) = 0 THEN

      L_SQL_STRING := 'SELECT DISTINCT a.' || A_PROP ||' FROM ';
      L_FROM_CLAUSE := 'dd' || UNAPIGEN.P_DD || '.uvsc a';

      
      L_WHERE_CLAUSE4JOIN := '';
      L_WHERE_CLAUSE := '';
      L_ANYOR_PRESENT := FALSE;
      FOR I IN 1..A_COL_NR_OF_ROWS LOOP
         L_COLUMN_HANDLED(I) := FALSE;
         IF LTRIM(RTRIM(UPPER(A_COL_ANDOR(I)))) = 'OR' AND
            NVL(A_COL_VALUE(I), ' ') <> ' ' THEN
            L_ANYOR_PRESENT := TRUE;
         END IF;
         
         
         IF I<>1 THEN
            IF NVL(A_COL_TP(I), ' ') = NVL(A_COL_TP(I-1), ' ') AND
               NVL(A_COL_ID(I), ' ') = NVL(A_COL_ID(I-1), ' ') AND
               NVL(A_COL_OPERATOR(I), '=') = '=' AND
               NVL(A_COL_OPERATOR(I-1), '=') = '=' AND
               NVL(A_COL_ANDOR(I-1), 'AND') =  'AND' AND
               (NVL(A_COL_VALUE(I), ' ') <> ' ' OR NVL(A_COL_VALUE(I-1), ' ') <> ' ') THEN
               IF I> 2 AND A_COL_ANDOR(I-2) = 'OR' THEN
                  L_ANYOR_PRESENT := TRUE;
               END IF;
            END IF;
         END IF;         
      END LOOP;

      L_NEXT_SC_JOIN := 'a';
      L_NEXT_ME_JOIN := 'me';
      L_NEXT_SCGK_JOIN := 'a';
      L_NEXT_STGK_JOIN := 'a';
      L_NEXT_RQGK_JOIN := 'a';
      L_NEXT_MEGK_JOIN := 'a';
      L_NEXT_SDGK_JOIN := 'a';
      
      

      
      
      
      
      L_ME_SCANNED := FALSE;
      L_FROM_CLAUSE_EXT_WITH_UVSCME := FALSE ;
      LOOP
         FOR I IN REVERSE 1..A_COL_NR_OF_ROWS LOOP
            IF NVL(LTRIM(A_COL_ID(I)), ' ') = ' ' THEN
               RETURN(UNAPIGEN.DBERR_SELCOLSINVALID);
            END IF;
            
            L_COL_ANDOR := 'AND';
            IF I<>1 THEN
               L_COL_ANDOR := A_COL_ANDOR(I-1);
            END IF;
            IF L_COL_ANDOR IS NULL THEN
               
               L_COL_ANDOR := 'AND';
            END IF;

            IF L_COLUMN_HANDLED(I) = FALSE THEN
               IF L_ME_SCANNED = FALSE THEN
                  IF NVL(A_COL_TP(I), ' ') = 'me' THEN 
                     IF (NVL(A_COL_VALUE(I), ' ') <> ' ') AND
                        INSTR(L_FROM_CLAUSE, '.uvscme me') = 0 THEN
                        L_FROM_CLAUSE := 'dd' || UNAPIGEN.P_DD || '.uvscme me,' || L_FROM_CLAUSE ;
                        L_WHERE_CLAUSE4JOIN := L_WHERE_CLAUSE4JOIN || ' me.sc = a.sc AND '; 
                        L_FROM_CLAUSE_EXT_WITH_UVSCME := TRUE ;
                     END IF;
                     IF NVL(A_COL_VALUE(I), ' ') <> ' ' THEN
                        UNAPIGEN.WHERECLAUSESTRINGBUILDER (A_BASE_TABLE => 'utsc', A_INDEX =>I, A_COL_TP => A_COL_TP(I), A_COL_ID => A_COL_ID(I),
                                       A_COL_VALUE => A_COL_VALUE(I), A_COL_OPERATOR => A_COL_OPERATOR(I),
                                       A_COL_ANDOR => L_COL_ANDOR, A_ANYOR_PRESENT => L_ANYOR_PRESENT,
                                       A_JOINTABLE_PREFIX => '', A_JOINCOLUMN1 => '', A_JOINCOLUMN2 => '', 
                                       A_PREV_COL_TP => L_PREV_COL_TP, A_PREV_COL_ID => L_PREV_COL_ID, A_PREV_COL_INDEX => L_PREV_COL_INDEX,
                                       A_NEXTTABLE_TOJOIN => L_NEXT_ME_JOIN, A_FROM_CLAUSE => L_FROM_CLAUSE,
                                       A_WHERE_CLAUSE4JOIN => L_WHERE_CLAUSE4JOIN, A_WHERE_CLAUSE => L_WHERE_CLAUSE,
                                       A_BASETABLE4GK_ALIAS => 'me',
                                       A_SQL_VAL_TAB => L_SQL_VAL_TAB);                                                                        
                     END IF;
                     L_COLUMN_HANDLED(I) := TRUE; 
                     
                     IF L_FROM_CLAUSE_EXT_WITH_UVSCME THEN
                        L_NEXT_MEGK_JOIN := 'me';  
                     END IF ;
                  END IF;
               ELSE
                  
                  IF NVL(A_COL_TP(I), ' ') = 'scgk' THEN 
                     IF NVL(A_COL_VALUE(I), ' ') <> ' ' THEN
                        UNAPIGEN.WHERECLAUSESTRINGBUILDER (A_BASE_TABLE => 'utsc', A_INDEX =>I, A_COL_TP => A_COL_TP(I), A_COL_ID => A_COL_ID(I),
                                       A_COL_VALUE => A_COL_VALUE(I), A_COL_OPERATOR => A_COL_OPERATOR(I),
                                       A_COL_ANDOR => L_COL_ANDOR, A_ANYOR_PRESENT => L_ANYOR_PRESENT,
                                       A_JOINTABLE_PREFIX => 'utscgk', A_JOINCOLUMN1 => 'sc', A_JOINCOLUMN2 => '', 
                                       A_PREV_COL_TP => L_PREV_COL_TP, A_PREV_COL_ID => L_PREV_COL_ID, A_PREV_COL_INDEX => L_PREV_COL_INDEX,
                                       A_NEXTTABLE_TOJOIN => L_NEXT_SCGK_JOIN, A_FROM_CLAUSE => L_FROM_CLAUSE,
                                       A_WHERE_CLAUSE4JOIN => L_WHERE_CLAUSE4JOIN, A_WHERE_CLAUSE => L_WHERE_CLAUSE,
                                       A_SQL_VAL_TAB => L_SQL_VAL_TAB);                                    
                     END IF;
                     L_COLUMN_HANDLED(I) := TRUE; 
                  ELSIF NVL(A_COL_TP(I), ' ') = 'stgk' THEN 
                     IF NVL(A_COL_VALUE(I), ' ') <> ' ' THEN
                        UNAPIGEN.WHERECLAUSESTRINGBUILDER (A_BASE_TABLE => 'utsc', A_INDEX =>I, A_COL_TP => A_COL_TP(I), A_COL_ID => A_COL_ID(I),
                                       A_COL_VALUE => A_COL_VALUE(I), A_COL_OPERATOR => A_COL_OPERATOR(I),
                                       A_COL_ANDOR => L_COL_ANDOR, A_ANYOR_PRESENT => L_ANYOR_PRESENT,
                                       A_JOINTABLE_PREFIX => 'utstgk', A_JOINCOLUMN1 => 'st', A_JOINCOLUMN2 => 'version', 
                                       A_PREV_COL_TP => L_PREV_COL_TP, A_PREV_COL_ID => L_PREV_COL_ID, A_PREV_COL_INDEX => L_PREV_COL_INDEX,
                                       A_NEXTTABLE_TOJOIN => L_NEXT_STGK_JOIN, A_FROM_CLAUSE => L_FROM_CLAUSE,
                                       A_WHERE_CLAUSE4JOIN => L_WHERE_CLAUSE4JOIN, A_WHERE_CLAUSE => L_WHERE_CLAUSE,
                                       A_SQL_VAL_TAB => L_SQL_VAL_TAB);                                    
                     END IF;
                     L_COLUMN_HANDLED(I) := TRUE; 
                  ELSIF NVL(A_COL_TP(I), ' ') = 'rqgk' THEN 
                     IF NVL(A_COL_VALUE(I), ' ') <> ' ' THEN
                        UNAPIGEN.WHERECLAUSESTRINGBUILDER (A_BASE_TABLE => 'utsc', A_INDEX =>I, A_COL_TP => A_COL_TP(I), A_COL_ID => A_COL_ID(I),
                                       A_COL_VALUE => A_COL_VALUE(I), A_COL_OPERATOR => A_COL_OPERATOR(I),
                                       A_COL_ANDOR => L_COL_ANDOR, A_ANYOR_PRESENT => L_ANYOR_PRESENT,
                                       A_JOINTABLE_PREFIX => 'utrqgk', A_JOINCOLUMN1 => 'rq', A_JOINCOLUMN2 => '', 
                                       A_PREV_COL_TP => L_PREV_COL_TP, A_PREV_COL_ID => L_PREV_COL_ID, A_PREV_COL_INDEX => L_PREV_COL_INDEX,
                                       A_NEXTTABLE_TOJOIN => L_NEXT_RQGK_JOIN, A_FROM_CLAUSE => L_FROM_CLAUSE,
                                       A_WHERE_CLAUSE4JOIN => L_WHERE_CLAUSE4JOIN, A_WHERE_CLAUSE => L_WHERE_CLAUSE,
                                       A_SQL_VAL_TAB => L_SQL_VAL_TAB);                                    
                     END IF;
                     L_COLUMN_HANDLED(I) := TRUE; 
                  ELSIF NVL(A_COL_TP(I), ' ') = 'sdgk' THEN 
                     IF NVL(A_COL_VALUE(I), ' ') <> ' ' THEN
                        UNAPIGEN.WHERECLAUSESTRINGBUILDER (A_BASE_TABLE => 'utsc', A_INDEX =>I, A_COL_TP => A_COL_TP(I), A_COL_ID => A_COL_ID(I),
                                       A_COL_VALUE => A_COL_VALUE(I), A_COL_OPERATOR => A_COL_OPERATOR(I),
                                       A_COL_ANDOR => L_COL_ANDOR, A_ANYOR_PRESENT => L_ANYOR_PRESENT,
                                       A_JOINTABLE_PREFIX => 'utsdgk', A_JOINCOLUMN1 => 'sd', A_JOINCOLUMN2 => '', 
                                       A_PREV_COL_TP => L_PREV_COL_TP, A_PREV_COL_ID => L_PREV_COL_ID, A_PREV_COL_INDEX => L_PREV_COL_INDEX,
                                       A_NEXTTABLE_TOJOIN => L_NEXT_SDGK_JOIN, A_FROM_CLAUSE => L_FROM_CLAUSE,
                                       A_WHERE_CLAUSE4JOIN => L_WHERE_CLAUSE4JOIN, A_WHERE_CLAUSE => L_WHERE_CLAUSE,
                                       A_SQL_VAL_TAB => L_SQL_VAL_TAB);                                    
                     END IF;
                     L_COLUMN_HANDLED(I) := TRUE; 
                  ELSIF NVL(A_COL_TP(I), ' ') = 'megk' THEN 
                     IF L_NEXT_MEGK_JOIN = 'a' OR L_ANYOR_PRESENT THEN
                        L_JOIN_COLUMN4ME := 'sc';
                     ELSE
                        L_JOIN_COLUMN4ME := 'me';
                     END IF;
                     IF NVL(A_COL_VALUE(I), ' ') <> ' ' THEN
                        UNAPIGEN.WHERECLAUSESTRINGBUILDER (A_BASE_TABLE => 'utsc', A_INDEX =>I, A_COL_TP => A_COL_TP(I), A_COL_ID => A_COL_ID(I),
                                       A_COL_VALUE => A_COL_VALUE(I), A_COL_OPERATOR => A_COL_OPERATOR(I),
                                       A_COL_ANDOR => L_COL_ANDOR, A_ANYOR_PRESENT => L_ANYOR_PRESENT,
                                       A_JOINTABLE_PREFIX => 'utscmegk', A_JOINCOLUMN1 => L_JOIN_COLUMN4ME, A_JOINCOLUMN2 => '', 
                                       A_PREV_COL_TP => L_PREV_COL_TP, A_PREV_COL_ID => L_PREV_COL_ID, A_PREV_COL_INDEX => L_PREV_COL_INDEX,
                                       A_NEXTTABLE_TOJOIN => L_NEXT_MEGK_JOIN, A_FROM_CLAUSE => L_FROM_CLAUSE,
                                       A_WHERE_CLAUSE4JOIN => L_WHERE_CLAUSE4JOIN, A_WHERE_CLAUSE => L_WHERE_CLAUSE,
                                       A_SQL_VAL_TAB => L_SQL_VAL_TAB);                                    
                     END IF;
                     L_COLUMN_HANDLED(I) := TRUE; 
                  ELSIF NVL(A_COL_TP(I), ' ') = 'me' THEN 
                    
                    NULL;
                  ELSE 
                     IF NVL(A_COL_VALUE(I), ' ') <> ' ' THEN
                        UNAPIGEN.WHERECLAUSESTRINGBUILDER (A_BASE_TABLE => 'utsc', A_INDEX =>I, A_COL_TP => A_COL_TP(I), A_COL_ID => A_COL_ID(I),
                                       A_COL_VALUE => A_COL_VALUE(I), A_COL_OPERATOR => A_COL_OPERATOR(I),
                                       A_COL_ANDOR => L_COL_ANDOR, A_ANYOR_PRESENT => L_ANYOR_PRESENT,
                                       A_JOINTABLE_PREFIX => '', A_JOINCOLUMN1 => '', A_JOINCOLUMN2 => '', 
                                       A_PREV_COL_TP => L_PREV_COL_TP, A_PREV_COL_ID => L_PREV_COL_ID, A_PREV_COL_INDEX => L_PREV_COL_INDEX,
                                       A_NEXTTABLE_TOJOIN => L_NEXT_SC_JOIN, A_FROM_CLAUSE => L_FROM_CLAUSE,
                                       A_WHERE_CLAUSE4JOIN => L_WHERE_CLAUSE4JOIN, A_WHERE_CLAUSE => L_WHERE_CLAUSE,
                                       A_SQL_VAL_TAB => L_SQL_VAL_TAB);                                    
                     END IF;
                     L_COLUMN_HANDLED(I) := TRUE; 
                  END IF;
               END IF;
            END IF;
         END LOOP;
         EXIT WHEN L_ME_SCANNED;
         L_ME_SCANNED := TRUE;
      END LOOP;

      
      IF SUBSTR(L_WHERE_CLAUSE4JOIN, -4) = 'AND ' THEN
         L_WHERE_CLAUSE4JOIN := SUBSTR(L_WHERE_CLAUSE4JOIN, 1,
                                  LENGTH(L_WHERE_CLAUSE4JOIN)-4);
      END IF;
      
      
      IF SUBSTR(L_WHERE_CLAUSE, -4) = 'AND ' THEN
         L_WHERE_CLAUSE := SUBSTR(L_WHERE_CLAUSE, 1,
                                  LENGTH(L_WHERE_CLAUSE)-4);
      END IF;
      IF UPPER(SUBSTR(L_WHERE_CLAUSE, -4)) = ' OR ' THEN
         L_WHERE_CLAUSE := SUBSTR(L_WHERE_CLAUSE, 1,
                                  LENGTH(L_WHERE_CLAUSE)-3);
      END IF;
      
      IF L_WHERE_CLAUSE4JOIN IS NOT NULL THEN
         IF L_WHERE_CLAUSE IS NULL THEN
            L_WHERE_CLAUSE := ' WHERE ' || L_WHERE_CLAUSE4JOIN;
         ELSE
            L_WHERE_CLAUSE := ' WHERE (' || L_WHERE_CLAUSE4JOIN || ') AND ('||L_WHERE_CLAUSE||') ';
         END IF;
      ELSE
         IF L_WHERE_CLAUSE IS NOT NULL THEN
            L_WHERE_CLAUSE := ' WHERE '||L_WHERE_CLAUSE;
         ELSE
            L_WHERE_CLAUSE := ' ';
         END IF;
      END IF;

      L_ORDER_BY_CLAUSE := NVL(A_ORDER_BY_CLAUSE, ' ORDER BY 1');

      L_SQL_STRING := L_SQL_STRING || L_FROM_CLAUSE || L_WHERE_CLAUSE || L_ORDER_BY_CLAUSE;

      L_LENGTH := 200;
      FOR L_X IN 1..10 LOOP
         IF ( LENGTH(L_SQL_STRING) > ((L_LENGTH*(L_X-1))+1) ) THEN
            DBMS_OUTPUT.PUT_LINE(SUBSTR(L_SQL_STRING, (L_LENGTH*(L_X-1))+1, L_LENGTH));
         ELSE
            EXIT;
         END IF;
      END LOOP;            

      IF P_SELECTSCPROP_CURSOR IS NULL THEN
         P_SELECTSCPROP_CURSOR := DBMS_SQL.OPEN_CURSOR;
      END IF;

      UNAPIAUT.ADDORACLECBOHINT (L_SQL_STRING) ;
      DBMS_SQL.PARSE(P_SELECTSCPROP_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
      FOR L_X IN 1..L_SQL_VAL_TAB.COUNT() LOOP
         DBMS_SQL.BIND_VARIABLE(P_SELECTSCPROP_CURSOR, ':col_val'||L_X , L_SQL_VAL_TAB(L_X)); 
      END LOOP;

      DBMS_SQL.DEFINE_COLUMN(P_SELECTSCPROP_CURSOR, 1, L_VALUE, 40);

      L_RESULT := DBMS_SQL.EXECUTE(P_SELECTSCPROP_CURSOR);
   END IF;

   L_RESULT := DBMS_SQL.FETCH_ROWS(P_SELECTSCPROP_CURSOR);
   L_FETCHED_ROWS := 0;

   LOOP
      EXIT WHEN L_RESULT = 0 OR L_FETCHED_ROWS >= A_NR_OF_ROWS;

      DBMS_SQL.COLUMN_VALUE(P_SELECTSCPROP_CURSOR, 1, L_VALUE);

      L_FETCHED_ROWS := L_FETCHED_ROWS + 1;

      A_VALUE(L_FETCHED_ROWS) := L_VALUE;

      IF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
         L_RESULT := DBMS_SQL.FETCH_ROWS(P_SELECTSCPROP_CURSOR);
      END IF;
   END LOOP;

   
   IF (L_FETCHED_ROWS = 0) THEN
       DBMS_SQL.CLOSE_CURSOR(P_SELECTSCPROP_CURSOR);
       P_SELECTSCPROP_CURSOR := NULL;
       RETURN(UNAPIGEN.DBERR_NORECORDS);
   ELSIF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
      DBMS_SQL.CLOSE_CURSOR(P_SELECTSCPROP_CURSOR);
      P_SELECTSCPROP_CURSOR := NULL;
      A_NR_OF_ROWS := L_FETCHED_ROWS;
   END IF;
   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
   WHEN OTHERS THEN
      L_SQLERRM := SQLERRM;
      UNAPIGEN.U4ROLLBACK;
      INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
      VALUES (UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 
              'SelectScPropValues', L_SQLERRM);
      UNAPIGEN.U4COMMIT;
      L_LENGTH := 200;
      FOR L_X IN 1..10 LOOP
         IF ( LENGTH(L_SQL_STRING) > ((L_LENGTH*(L_X-1))+1) ) THEN
            INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
            VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                   'SelectScGkValues', '(SQL)'||SUBSTR(L_SQL_STRING, (L_LENGTH*(L_X-1))+1, L_LENGTH));             
         ELSE
            EXIT;
         END IF;
      END LOOP;            
      L_LENGTH := 200;
      FOR L_X IN 1..10 LOOP
         IF ( LENGTH(L_SQLERRM) > ((L_LENGTH*(L_X-1))+1) ) THEN
            DBMS_OUTPUT.PUT_LINE(SUBSTR(L_SQLERRM, (L_LENGTH*(L_X-1))+1, L_LENGTH));
         ELSE
            EXIT;
         END IF;
      END LOOP;            
      UNAPIGEN.U4COMMIT;
      IF DBMS_SQL.IS_OPEN (P_SELECTSCPROP_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR (P_SELECTSCPROP_CURSOR);
      END IF;
      RETURN(UNAPIGEN.DBERR_GENFAIL);
END SELECTSCPROPVALUES;

FUNCTION DELETESAMPLE
(A_SC            IN  VARCHAR2,          
 A_MODIFY_REASON IN  VARCHAR2)          
RETURN NUMBER IS

L_ALLOW_MODIFY         CHAR(1);
L_ACTIVE               CHAR(1);
L_LC                   VARCHAR2(2);
L_LC_VERSION           VARCHAR2(20);
L_SS                   VARCHAR2(2);
L_LOG_HS               CHAR(1);
L_LOG_HS_DETAILS       CHAR(1);
L_SC_CURSOR            INTEGER;
L_OBJECT_ID            VARCHAR2(255);
L_RQ                   VARCHAR2(20);
L_ST_VERSION           VARCHAR2(20);

CURSOR L_SCGK_CURSOR IS
   SELECT DISTINCT GK
   FROM UTSCGK
   WHERE SC = A_SC;

CURSOR L_SCMEGK_CURSOR IS
   SELECT DISTINCT GK
   FROM UTSCMEGK
   WHERE SC = A_SC;

CURSOR L_RQ_CURSOR(A_RQ VARCHAR2) IS
   SELECT LOG_HS, LOG_HS_DETAILS
   FROM UTRQ
   WHERE RQ=A_RQ;
L_RQ_LOG_HS_DETAILS          CHAR(1);
L_RQ_LOG_HS                  CHAR(1);
L_HS_SEQ                     INTEGER;

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_SC, ' ')= ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   L_RET_CODE := UNAPIAUT.GETSCAUTHORISATION(A_SC, L_ST_VERSION, L_LC, L_LC_VERSION, L_SS,
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

   L_SC_CURSOR := DBMS_SQL.OPEN_CURSOR;

   
   DELETE FROM UTSCII
   WHERE SC = A_SC;

   
   DELETE FROM UTSCICAU
   WHERE SC = A_SC;

   DELETE FROM UTSCICHS
   WHERE SC = A_SC;

   DELETE FROM UTSCICHSDETAILS
   WHERE SC = A_SC;

   DELETE FROM UTSCIC
   WHERE SC = A_SC;

   
   DELETE FROM UTRSCRD
   WHERE SC = A_SC;

   DELETE FROM UTRSCMECELLLISTOUTPUT
   WHERE SC = A_SC;

   DELETE FROM UTRSCMECELLOUTPUT
   WHERE SC = A_SC;

   DELETE FROM UTRSCMECELLINPUT
   WHERE SC = A_SC;

   DELETE FROM UTRSCMECELLLIST
   WHERE SC = A_SC;

   DELETE FROM UTRSCMECELL
   WHERE SC = A_SC;

   DELETE FROM UTRSCME
   WHERE SC = A_SC;

   DELETE FROM UTRSCPASPA
   WHERE SC = A_SC;

   DELETE FROM UTRSCPASPB
   WHERE SC = A_SC;

   DELETE FROM UTRSCPASPC
   WHERE SC = A_SC;

   DELETE FROM UTRSCPASQC
   WHERE SC = A_SC;

   DELETE FROM UTRSCPA
   WHERE SC = A_SC;

   DELETE FROM UTRSCPG
   WHERE SC = A_SC;

   
   DELETE FROM UTSCRD
   WHERE SC = A_SC;

   
   DELETE FROM UTSCMEAU
   WHERE SC = A_SC;

   DELETE FROM UTSCMEHS
   WHERE SC = A_SC;

   DELETE FROM UTSCMEHSDETAILS
   WHERE SC = A_SC;

   FOR L_SCMEGKDEL IN L_SCMEGK_CURSOR LOOP
      BEGIN
         L_SQL_STRING := 'DELETE FROM utscmegk' || L_SCMEGKDEL.GK ||
                         ' WHERE sc = ''' || REPLACE(A_SC, '''', '''''') || ''''; 
         DBMS_SQL.PARSE(L_SC_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
         L_RESULT := DBMS_SQL.EXECUTE(L_SC_CURSOR);
      EXCEPTION
      WHEN OTHERS THEN
         IF SQLCODE = -942 THEN
            NULL; 
         ELSE
            RAISE;
         END IF;
      END;
   END LOOP;

   DELETE FROM UTSCMEGK
   WHERE SC = A_SC;

   DELETE FROM UTSCMECELLLIST
   WHERE SC = A_SC;

   DELETE FROM UTSCMECELLLISTOUTPUT
   WHERE SC = A_SC;

   DELETE FROM UTSCMECELLINPUT
   WHERE SC = A_SC;

   DELETE FROM UTSCMECELLOUTPUT
   WHERE SC = A_SC;

   DELETE FROM UTSCMECELL
   WHERE SC = A_SC;

   DELETE FROM UTSCME
   WHERE SC = A_SC;

   
   

   UPDATE UTWSSC
   SET SC = ''
   WHERE SC = A_SC;

   UPDATE UTWTROWS
   SET SC = ''
   WHERE SC = A_SC;

   DELETE FROM UTWSME
   WHERE SC = A_SC;

   DELETE FROM UTWSII
   WHERE SC = A_SC;

   
   DELETE FROM UTSCPAAU
   WHERE SC = A_SC;

   DELETE FROM UTSCPAHS
   WHERE SC = A_SC;

   DELETE FROM UTSCPAHSDETAILS
   WHERE SC = A_SC;

   DELETE FROM UTSCPASPA
   WHERE SC = A_SC;

   DELETE FROM UTSCPASPB
   WHERE SC = A_SC;

   DELETE FROM UTSCPASPC
   WHERE SC = A_SC;

   DELETE FROM UTSCPATD
   WHERE SC = A_SC;

   DELETE FROM UTSCPASQC
   WHERE SC = A_SC;

   DELETE FROM UTSCPA
   WHERE SC = A_SC;

   DELETE /*+ RULE */ FROM UTCHDP
   WHERE (CH, DATAPOINT_LINK)
      IN (SELECT B.CH, B.DATAPOINT_LINK
          FROM UTCH A, UTCHDP B
          WHERE B.DATAPOINT_LINK LIKE A_SC || '#%' 
            AND B.CH = A.CH
            AND A.ALLOW_MODIFY IN ('1', '#')
            AND NVL(UNAPIAUT.SQLGETCHALLOWMODIFY(B.CH),'0')='1');          

   
   DELETE FROM UTSCPGAU
   WHERE SC = A_SC;

   DELETE FROM UTSCPGHS
   WHERE SC = A_SC;

   DELETE FROM UTSCPGHSDETAILS
   WHERE SC = A_SC;

   DELETE FROM UTSCPG
   WHERE SC = A_SC;

   
   DELETE FROM UTSCAU
   WHERE SC = A_SC;

   DELETE FROM UTSCHS
   WHERE SC = A_SC;

   DELETE FROM UTSCHSDETAILS
   WHERE SC = A_SC;

   FOR L_SCGKDEL IN L_SCGK_CURSOR LOOP
      BEGIN
         L_SQL_STRING := 'DELETE FROM utscgk' || L_SCGKDEL.GK ||
                         ' WHERE sc = ''' || REPLACE(A_SC, '''', '''''') || ''''; 
         DBMS_SQL.PARSE(L_SC_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
         L_RESULT := DBMS_SQL.EXECUTE(L_SC_CURSOR);
      EXCEPTION
      WHEN OTHERS THEN
         IF SQLCODE = -942 THEN
            NULL; 
         ELSE
            RAISE;
         END IF;
      END;
   END LOOP;

   DBMS_SQL.CLOSE_CURSOR(L_SC_CURSOR);

   DELETE FROM UTSCGK
   WHERE SC = A_SC;

   DELETE FROM UTEVTIMED
   WHERE (OBJECT_TP='sc' AND OBJECT_ID=A_SC)
      OR INSTR(EV_DETAILS, 'sc='||A_SC) <> 0;

   DELETE FROM UTEVRULESDELAYED
   WHERE (OBJECT_TP='sc' AND OBJECT_ID=A_SC)
      OR INSTR(EV_DETAILS, 'sc='||A_SC) <> 0;

   DELETE FROM UTDELAY
   WHERE SC= A_SC;

   SELECT RQ
   INTO L_RQ
   FROM UTSC
   WHERE SC = A_SC;

   DELETE FROM UTSC
   WHERE SC = A_SC;

   L_EVENT_TP := 'SampleDeleted';
   L_EV_SEQ_NR := -1;
   L_EV_DETAILS := NULL;
   IF L_RQ IS NOT NULL THEN
      L_EV_DETAILS := 'rq=' || L_RQ || 
                      '#st_version=' || L_ST_VERSION;
   ELSE
      L_EV_DETAILS := 'st_version=' || L_ST_VERSION;
   END IF;
   L_RESULT := UNAPIEV.INSERTEVENT('DeleteSample', UNAPIGEN.P_EVMGR_NAME, 'sc', A_SC, L_LC, 
                                   L_LC_VERSION, L_SS, L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;

   FOR L_RQSC_REC IN (SELECT RQ, SC FROM UTRQSC WHERE SC = A_SC) LOOP
      DELETE FROM UTRQSC
      WHERE SC = A_SC
      AND RQ = L_RQSC_REC.RQ;
      
      OPEN L_RQ_CURSOR(L_RQSC_REC.RQ);
      FETCH L_RQ_CURSOR
      INTO L_RQ_LOG_HS, L_RQ_LOG_HS_DETAILS;
      CLOSE L_RQ_CURSOR;
      
      IF L_RQ_LOG_HS = '1' THEN
         L_HS_SEQ := 1;
         INSERT INTO UTRQHS (RQ, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
         VALUES (L_RQSC_REC.RQ, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
                 'request "'||L_RQSC_REC.RQ||'" sample  "'||A_SC||'" is removed.', 
                 CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
      END IF;
      
      IF L_RQ_LOG_HS_DETAILS = '1' THEN
         L_HS_SEQ := 1;
         INSERT INTO UTRQHSDETAILS (RQ, TR_SEQ, EV_SEQ, SEQ, DETAILS)
         VALUES (L_RQSC_REC.RQ, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_SEQ, 
                 'request "'||L_RQSC_REC.RQ||'" sample  "'||A_SC||'" is removed.');
      END IF;
   END LOOP;

   
   
   
   L_OBJECT_ID := 'sc='|| A_SC;
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
      UNAPIGEN.LOGERROR('DeleteSample', SQLERRM);
   END IF;
   IF DBMS_SQL.IS_OPEN(L_SC_CURSOR) THEN
      DBMS_SQL.CLOSE_CURSOR(L_SC_CURSOR);
   END IF;
   IF L_RQ_CURSOR%ISOPEN THEN
      CLOSE L_RQ_CURSOR;
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'DeleteSample'));
END DELETESAMPLE;


FUNCTION GETPREFVALUE                                  
(A_UP_IN            IN     NUMBER,                     
 A_US_IN            IN     VARCHAR2,                   
 A_PREF_NAME_IN     IN     VARCHAR2,                   
 A_PREF_VALUE       OUT    VARCHAR2)                   
RETURN NUMBER IS

L_UPUSPREF_UP           UNAPIGEN.LONG_TABLE_TYPE;
L_UPUSPREF_US           UNAPIGEN.VC20_TABLE_TYPE;
L_UPUSPREF_PREF_NAME    UNAPIGEN.VC20_TABLE_TYPE;
L_UPUSPREF_PREF_VALUE   UNAPIGEN.VC40_TABLE_TYPE;
L_UPUSPREF_INHERIT_PREF UNAPIGEN.CHAR1_TABLE_TYPE;
L_UPUSPREF_NR_OF_ROWS   NUMBER;
L_UP_IN                 NUMBER;

BEGIN
   
   
   
   IF UNAPIEV.P_EV_MGR_SESSION THEN
      BEGIN
         SELECT DEF_UP
         INTO L_UP_IN
         FROM UTAD
         WHERE AD = A_US_IN;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RETURN(UNAPIGEN.DBERR_NOOBJECT);
      END;
   ELSE
     L_UP_IN := A_UP_IN;
   END IF;

   L_RET_CODE := UNAPIUPP.GETUPUSPREF(L_UP_IN, NVL(A_US_IN,UNAPIGEN.P_USER) , A_PREF_NAME_IN,
                                      L_UPUSPREF_UP, L_UPUSPREF_US, L_UPUSPREF_PREF_NAME,
                                      L_UPUSPREF_PREF_VALUE, L_UPUSPREF_INHERIT_PREF,
                                      L_UPUSPREF_NR_OF_ROWS);
   IF L_RET_CODE = UNAPIGEN.DBERR_NORECORDS THEN
      A_PREF_VALUE := '';
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   ELSIF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      L_SQLERRM := 'GetUpUsPref returned '||TO_CHAR(L_RET_CODE) || ' for (up,user,pref_name)=('||
                   TO_CHAR(A_UP_IN) || ',' ||  NVL(A_US_IN,UNAPIGEN.P_USER) || ',' || A_PREF_NAME_IN ||')';
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   ELSIF L_UPUSPREF_NR_OF_ROWS > 1 THEN
      L_SQLERRM := 'GetUpUsPref returned too much rows for (up,user,pref_name)=('||
                   TO_CHAR(A_UP_IN) || ',' ||  NVL(A_US_IN,UNAPIGEN.P_USER) || ',' || A_PREF_NAME_IN ||')';
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   END IF;
   A_PREF_VALUE := L_UPUSPREF_PREF_VALUE(1);
   RETURN(UNAPIGEN.DBERR_SUCCESS);
END GETPREFVALUE;

FUNCTION CREATESAMPLE                   
(A_ST               IN     VARCHAR2,                  
 A_ST_VERSION       IN OUT VARCHAR2,                   
 A_SC               IN OUT VARCHAR2,                  
 A_REF_DATE         IN     DATE,                      
 A_CREATE_IC        IN     VARCHAR2,                  
 A_CREATE_PG        IN     VARCHAR2,                  
 A_USERID           IN     VARCHAR2,                  
 A_FIELDTYPE_TAB    IN     UNAPIGEN.VC20_TABLE_TYPE,  
 A_FIELDNAMES_TAB   IN     UNAPIGEN.VC20_TABLE_TYPE,  
 A_FIELDVALUES_TAB  IN     UNAPIGEN.VC40_TABLE_TYPE,  
 A_NR_OF_ROWS       IN     NUMBER,                    
 A_MODIFY_REASON    IN     VARCHAR2)                  
RETURN NUMBER IS

L_SAMPLING_DATE         TIMESTAMP WITH TIME ZONE;
L_PREF_VALUE            VARCHAR2(40);
L_CREATE_IC             VARCHAR2(40);
L_CREATE_PG             VARCHAR2(40);
L_DATE_CURSOR           INTEGER;
L_ST_REC                UTST%ROWTYPE;
L_EDIT_ALLOWED          CHAR(1);
L_VALID_CF              VARCHAR2(20);
L_DELAYED_TILL          TIMESTAMP WITH TIME ZONE;
L_TIMED_EVENT_TP        VARCHAR2(255);
L_REF_DATE              TIMESTAMP WITH TIME ZONE;
L_LC                    VARCHAR2(2);
L_LC_VERSION            VARCHAR2(20);
L_SS                    VARCHAR2(2);
L_LOG_HS                CHAR(1);
L_LOG_HS_DETAILS        CHAR(1);
L_ALLOW_MODIFY          CHAR(1);
L_ACTIVE                CHAR(1);
L_SC_CLASS              VARCHAR2(2);
L_ST_VERSION            VARCHAR2(20);
L_SD                    VARCHAR2(20);
L_RQ                    VARCHAR2(20);
L_DELAY                 NUMBER;
L_DELAY_UNIT            VARCHAR2(20);
L_PLAN_SAMPLE           BOOLEAN;
L_SINGLE_VALUED_GK      CHAR(1);
L_GK_PRESENT            CHAR(1);
L_INSERT                BOOLEAN;
L_API_NAME              VARCHAR2(20);
L_CHECK_IF_GK_PRESENT   BOOLEAN;
L_RQ_LC                 VARCHAR2(2);
L_RQ_LC_VERSION         VARCHAR2(20);
L_RQ_SS                 VARCHAR2(2);
L_RQ_LOG_HS             CHAR(1);
L_RQ_LOG_HS_DETAILS     CHAR(1);
L_RQ_ALLOW_MODIFY       CHAR(1);
L_RQ_ACTIVE             CHAR(1);
L_RT                    VARCHAR2(20);
L_RT_VERSION            VARCHAR2(20);
L_SD_LC                 VARCHAR2(2);
L_SD_LC_VERSION         VARCHAR2(20);
L_SD_SS                 VARCHAR2(2);
L_SD_LOG_HS             CHAR(1);
L_SD_LOG_HS_DETAILS     CHAR(1);
L_SD_ALLOW_MODIFY       CHAR(1);
L_SD_ACTIVE             CHAR(1);
L_PT                    VARCHAR2(20);
L_PT_VERSION            VARCHAR2(20);
L_CSNODE                NUMBER(9);
L_TPNODE                NUMBER(9);
L_PTCELLSTSEQ           NUMBER(9);
L_FIELDTYPE_TAB         UNAPIGEN.VC20_TABLE_TYPE;
L_FIELDNAMES_TAB        UNAPIGEN.VC20_TABLE_TYPE;
L_FIELDVALUES_TAB       UNAPIGEN.VC40_TABLE_TYPE;
L_FIELDNR_OF_ROWS       NUMBER;
L_MAX_NUMBER_OF_SAMPLES INTEGER;
L_COUNT_SAMPLES         INTEGER;


CURSOR L_STGK_CURSOR(C_ST_INHERIT_GK CHAR) IS
   SELECT A.GK, A.GKSEQ, A.VALUE, B.VERSION GK_VERSION
   FROM UTGKSC B, UTSTGK A
   WHERE A.ST = A_ST
     AND A.VERSION = UNAPIGEN.USEVERSION('st', A_ST, A_ST_VERSION)
     AND A.GK = B.GK
     AND B.STRUCT_CREATED = '1'
     AND B.VERSION_IS_CURRENT = '1'
     AND B.VERSION = DECODE(A.GK_VERSION, NULL, B.VERSION, UNAPIGEN.USEVERSION('gkst', A.GK, A.GK_VERSION))
     AND DECODE(C_ST_INHERIT_GK, '0',B.INHERIT_GK, C_ST_INHERIT_GK) = '1';
CURSOR L_GKSC_CURSOR (A_GK IN VARCHAR2) IS
   SELECT SINGLE_VALUED
   FROM UTGKSC
   WHERE GK = A_GK
   AND STRUCT_CREATED='1';

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   
   IF UNAPIGEN.P_PP_KEY4PRODUCT IS NULL THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_SETCONNECTION;
      RAISE STPERROR;               
   END IF;

   
   
   
   
   
   
   

   
   IF A_ST IS NOT NULL THEN
      A_ST_VERSION := UNAPIGEN.VALIDATEVERSION('st', A_ST, A_ST_VERSION);
   ELSE
      IF A_ST_VERSION IS NULL THEN
         A_ST_VERSION := UNVERSION.P_NO_VERSION;
      END IF;
   END IF;
   
   
   
   
   L_SQLERRM := '';
   
   IF A_REF_DATE IS NULL THEN
      L_REF_DATE := NULL;
      L_SAMPLING_DATE := NULL;
   ELSE
      L_SAMPLING_DATE := A_REF_DATE;
      L_REF_DATE := A_REF_DATE;
   END IF;

   
   
   
   L_RET_CODE := UNAPIGEN.GETMAXSAMPLES(L_MAX_NUMBER_OF_SAMPLES);
   IF NVL(L_MAX_NUMBER_OF_SAMPLES,3000) >= 0 THEN
      
      
      SELECT COUNT(*)
      INTO L_COUNT_SAMPLES
      FROM UTSC;
      
      IF (L_COUNT_SAMPLES+1) >= L_MAX_NUMBER_OF_SAMPLES THEN
         L_SQLERRM := 'The maximum number of samples for your system has been reached. You need another type license.';
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
         RAISE STPERROR;      
      END IF;
   END IF;      
   
   
   
   
   
   IF NVL(A_SC, ' ') = ' ' THEN
      L_RET_CODE := GENERATESAMPLECODE(A_ST, A_ST_VERSION, L_REF_DATE,
                                       A_FIELDTYPE_TAB, A_FIELDNAMES_TAB, A_FIELDVALUES_TAB, A_NR_OF_ROWS,
                                       A_SC, L_EDIT_ALLOWED, L_VALID_CF);

      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
         RAISE STPERROR;
      END IF;
   END IF;

    
    IF A_ST IS NULL THEN
       IF A_ST_VERSION IS NULL THEN
          A_ST_VERSION := UNVERSION.P_NO_VERSION;
       END IF;
    END IF;

   
   
   
   
   
   
   
   
   L_ST_VERSION := A_ST_VERSION;
   L_RET_CODE := UNAPIAUT.GETSCAUTHORISATION(A_SC, L_ST_VERSION, L_LC, L_LC_VERSION, L_SS,
                                             L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS, L_LOG_HS_DETAILS);

   IF L_RET_CODE = UNAPIGEN.DBERR_NOCURRENTLCVERSION THEN
      L_SQLERRM := 'No current life cycle for default sample life cycle';
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
      RAISE STPERROR;
   ELSIF L_RET_CODE = UNAPIGEN.DBERR_STVERSION THEN
      L_SQLERRM := 'Sample type version not specified';
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
      RAISE STPERROR;
   ELSIF L_RET_CODE <> UNAPIGEN.DBERR_NOOBJECT  THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_SCALREADYEXIST;
      RAISE STPERROR;
   END IF;

   
   
   
   
   
   
   
   

   IF NVL(A_ST, ' ') <> ' ' THEN

      BEGIN
         SELECT *
         INTO L_ST_REC
         FROM UTST
         WHERE ST=A_ST
         AND VERSION = A_ST_VERSION;

      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
         RAISE STPERROR;
      END;

   END IF;

   
   
   
   L_CREATE_PG := A_CREATE_PG;
   IF NVL(L_CREATE_PG, ' ') = ' ' THEN

      
      
      L_RET_CODE := GETPREFVALUE(UNAPIGEN.P_CURRENT_UP, A_USERID, 'scCreatePg',
                                 L_PREF_VALUE);
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
         RAISE STPERROR;
      END IF;
      L_CREATE_PG := L_PREF_VALUE;
   END IF;

   IF NVL(L_CREATE_PG, 'ON SAMPLE CREATION') = 'WHEN INFO AVAILABLE' THEN
      L_SC_CLASS := '1';
   ELSIF NVL(A_ST, ' ') <> ' ' THEN
      L_SC_CLASS := L_ST_REC.ST_CLASS ;
   ELSE
      L_SC_CLASS := NULL;
   END IF;

   
   
   
   L_RQ := NULL;
   L_SD := NULL;
   L_PLAN_SAMPLE := FALSE;
   FOR L_ROW IN 1..A_NR_OF_ROWS LOOP
      IF A_FIELDTYPE_TAB(L_ROW) = 'rq' THEN
         L_RQ := A_FIELDVALUES_TAB(L_ROW);
      END IF;
      IF A_FIELDTYPE_TAB(L_ROW) = 'sd' THEN
         L_SD := A_FIELDVALUES_TAB(L_ROW);
      END IF;
      IF A_FIELDTYPE_TAB(L_ROW) = 'delay' THEN
         L_DELAY := A_FIELDVALUES_TAB(L_ROW);
      END IF;
      IF A_FIELDTYPE_TAB(L_ROW) = 'delay_unit' THEN
         L_DELAY_UNIT := A_FIELDVALUES_TAB(L_ROW);
      END IF;
      IF A_FIELDTYPE_TAB(L_ROW) = 'plan_sample' THEN
         L_PLAN_SAMPLE := TRUE;
      END IF;
      IF A_FIELDTYPE_TAB(L_ROW) = 'csnode' THEN
         L_CSNODE := A_FIELDVALUES_TAB(L_ROW);
      END IF;
      IF A_FIELDTYPE_TAB(L_ROW) = 'tpnode' THEN
         L_TPNODE := A_FIELDVALUES_TAB(L_ROW);
      END IF;
      IF A_FIELDTYPE_TAB(L_ROW) = 'ptcellstseq' THEN
         L_PTCELLSTSEQ := A_FIELDVALUES_TAB(L_ROW);
      END IF;
   END LOOP;
   IF L_RQ IS NOT NULL THEN
      L_RET_CODE := UNAPIAUT.GETRQAUTHORISATION(L_RQ, L_RT_VERSION, L_RQ_LC, L_RQ_LC_VERSION, L_RQ_SS,
                                           L_RQ_ALLOW_MODIFY, L_RQ_ACTIVE, L_RQ_LOG_HS, L_RQ_LOG_HS_DETAILS);
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
         RAISE STPERROR;
      END IF;   
      BEGIN
         SELECT RT
         INTO L_RT
         FROM UTRQ
         WHERE RQ = L_RQ;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         L_RT := NULL;
      END;      
   END IF;
   IF L_SD IS NOT NULL THEN
      L_RET_CODE := UNAPIAUT.GETSDAUTHORISATION(L_SD, L_PT_VERSION, L_SD_LC, L_SD_LC_VERSION, L_SD_SS,
                                           L_SD_ALLOW_MODIFY, L_SD_ACTIVE, L_SD_LOG_HS, L_SD_LOG_HS_DETAILS);
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
         RAISE STPERROR;
      END IF;   
      BEGIN
         SELECT PT
         INTO L_PT
         FROM UTSD
         WHERE SD = L_SD;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         L_PT := NULL;
      END;      
   END IF;
   
   
   
   
   
   IF NVL(A_ST, ' ') <> ' ' THEN

      L_LC_VERSION := UNAPIGEN.USEVERSION('lc', L_ST_REC.SC_LC, L_ST_REC.SC_LC_VERSION);
      INSERT INTO UTSC(SC, ST, ST_VERSION, DESCRIPTION, 
                       SHELF_LIFE_VAL, SHELF_LIFE_UNIT, SAMPLING_DATE, SAMPLING_DATE_TZ, 
                       CREATION_DATE, CREATION_DATE_TZ, CREATED_BY,
                       PRIORITY, LABEL_FORMAT, DESCR_DOC, DESCR_DOC_VERSION,
                       RQ, SD, SC_CLASS, LOG_HS, LOG_HS_DETAILS, ALLOW_MODIFY, ACTIVE, 
                       LC, LC_VERSION, ALLOW_ANY_PP)
      VALUES(A_SC, A_ST, L_ST_REC.VERSION, L_ST_REC.DESCRIPTION,
             L_ST_REC.SHELF_LIFE_VAL, L_ST_REC.SHELF_LIFE_UNIT, L_SAMPLING_DATE, L_SAMPLING_DATE,
             CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, NVL(A_USERID,UNAPIGEN.P_USER),
             L_ST_REC.PRIORITY, L_ST_REC.LABEL_FORMAT, L_ST_REC.DESCR_DOC, L_ST_REC.DESCR_DOC_VERSION,
             L_RQ, L_SD, L_SC_CLASS, L_LOG_HS, L_LOG_HS_DETAILS, '#', '0',
             L_ST_REC.SC_LC, L_LC_VERSION, L_ST_REC.ALLOW_ANY_PP);

      IF L_PLAN_SAMPLE THEN
         UPDATE UTST
         SET LAST_SCHED = L_REF_DATE, 
            LAST_SCHED_TZ = DECODE(L_REF_DATE, LAST_SCHED_TZ, LAST_SCHED_TZ, L_REF_DATE)
         WHERE ST = A_ST
           AND VERSION = A_ST_VERSION; 
      END IF;
      UNAPIAUT.UPDATELCINAUTHORISATIONBUFFER('sc', A_SC, '', L_ST_REC.SC_LC, L_LC_VERSION);
   ELSE

      INSERT INTO UTSC(SC, SAMPLING_DATE, SAMPLING_DATE_TZ, CREATION_DATE, CREATION_DATE_TZ, CREATED_BY,
                       RQ, SD, LOG_HS, LOG_HS_DETAILS, ALLOW_MODIFY, ACTIVE,
                       LC, LC_VERSION, ALLOW_ANY_PP, SC_CLASS,
                       SHELF_LIFE_VAL, SHELF_LIFE_UNIT)
      VALUES (A_SC, L_SAMPLING_DATE, L_SAMPLING_DATE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, NVL(A_USERID,UNAPIGEN.P_USER),
              L_RQ, L_SD, L_LOG_HS, L_LOG_HS_DETAILS, '#', '0',
              '', '', '1', L_SC_CLASS,
              0, 'DD');
   END IF;

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

      INSERT INTO UTSCHS(SC, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
      VALUES(A_SC, NVL(A_USERID, UNAPIGEN.P_USER), UNAPIGEN.SQLUSERDESCRIPTION(NVL(A_USERID, UNAPIGEN.P_USER)), 
             L_EVENT_TP, 'sample "'||A_SC||'" is planned.', 
             CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);   
   END IF;
   
   
   
   
   
   
   
   IF NVL(A_ST, ' ') <> ' ' THEN

      
      IF L_RQ IS NOT NULL AND
         L_RT IS NOT NULL THEN
         L_RET_CODE := UNAPIRQ2.INITANDSAVERQSCATTRIBUTES
                         (L_RQ, A_SC, L_RT, L_RT_VERSION, A_ST, A_ST_VERSION);
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            L_SQLERRM := 'InitAndSaveRqScAttributes#ret_code='||L_RET_CODE||
                         '#rq='||L_RQ||
                         '#rt='||L_RT||
                         '#rt_version='||L_RT_VERSION||
                         '#sc='||A_SC||
                         '#st='||A_ST||
                         '#st_version='||A_ST_VERSION;
            RAISE STPERROR;
         END IF;      
      
      ELSIF L_SD IS NOT NULL AND
         L_PT IS NOT NULL THEN
         L_RET_CODE := UNAPISD2.INITANDSAVESDCELLSCATTRIBUTES 
                          (L_SD, L_CSNODE, L_TPNODE, L_PTCELLSTSEQ, A_SC) ;
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            L_SQLERRM := 'InitAndSaveSdCellScAttributes#ret_code='||L_RET_CODE||
                         '#sd='||L_SD||
                         '#csnode='||L_CSNODE||
                         '#tpnode='||L_TPNODE||
                         '#ptcellstseq='||L_PTCELLSTSEQ||
                         '#sc='||A_SC;
            RAISE STPERROR;
         END IF;         
      ELSIF NVL(L_ST_REC.INHERIT_AU, '0') = '1' THEN
         INSERT INTO UTSCAU
         (SC, AU, AU_VERSION, AUSEQ, VALUE)
         SELECT A_SC, A.AU, '' B_VERSION, A.AUSEQ, A.VALUE
         FROM UTAU B, UTSTAU A
         WHERE A.ST = A_ST
         AND A.VERSION = A_ST_VERSION
         AND A.AU = B.AU
         AND UNAPIGEN.USEVERSION('au', A.AU, A.AU_VERSION) = B.VERSION;
      ELSE
         INSERT INTO UTSCAU
         (SC, AU, AU_VERSION, AUSEQ, VALUE)
         SELECT A_SC, A.AU, '' B_VERSION, A.AUSEQ, A.VALUE
         FROM UTAU B, UTSTAU A
         WHERE A.ST = A_ST
         AND A.VERSION = A_ST_VERSION
         AND A.AU = B.AU
         AND UNAPIGEN.USEVERSION('au', A.AU, A.AU_VERSION) = B.VERSION
         AND B.INHERIT_AU = '1';
      END IF;

      
      
      
      FOR L_STGK_REC IN L_STGK_CURSOR(NVL(L_ST_REC.INHERIT_GK, '0')) LOOP
         BEGIN
            
            INSERT INTO UTSCGK(SC, GK, GKSEQ, VALUE)
            VALUES(A_SC, L_STGK_REC.GK,  L_STGK_REC.GKSEQ, L_STGK_REC.VALUE);

            IF L_STGK_REC.VALUE IS NOT NULL THEN
               EXECUTE IMMEDIATE 'INSERT INTO utscgk' || L_STGK_REC.GK ||
                                 '(sc, ' || L_STGK_REC.GK || ') VALUES (:a_sc, :a_gk)'
               USING A_SC, L_STGK_REC.VALUE;
               
               IF SQL%ROWCOUNT = 0 THEN
                  UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NORECORDS;
                  RAISE STPERROR;
               END IF;
            END IF;
         EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            
            
            NULL;
         END;
      END LOOP;

      
      
      
      
    
      FOR L_ROW IN 1..A_NR_OF_ROWS LOOP
         IF A_FIELDTYPE_TAB(L_ROW) = 'gk' THEN
            OPEN L_GKSC_CURSOR(A_FIELDNAMES_TAB(L_ROW));
            FETCH L_GKSC_CURSOR
            INTO L_SINGLE_VALUED_GK;
            IF L_GKSC_CURSOR%FOUND THEN
               L_INSERT := FALSE;
               L_CHECK_IF_GK_PRESENT := FALSE;
               IF L_SINGLE_VALUED_GK = '1' THEN
                  BEGIN

                     IF A_FIELDVALUES_TAB(L_ROW) IS NOT NULL THEN
                        EXECUTE IMMEDIATE 'UPDATE utscgk' || A_FIELDNAMES_TAB(L_ROW) ||
                                          ' SET '||A_FIELDNAMES_TAB(L_ROW) || ' = :a_gk ' ||
                                          ' WHERE sc = :a_sc'
                        USING A_FIELDVALUES_TAB(L_ROW), A_SC;

                        IF SQL%ROWCOUNT = 0 THEN
                           L_INSERT := TRUE;
                        END IF;
                     END IF;
                  
                     IF NOT L_INSERT THEN
                        
                        UPDATE UTSCGK
                        SET VALUE = A_FIELDVALUES_TAB(L_ROW)
                        WHERE SC = A_SC
                        AND GK = A_FIELDNAMES_TAB(L_ROW);

                        IF SQL%ROWCOUNT = 0 THEN
                           L_INSERT := TRUE;
                        END IF;
                     END IF;
                  EXCEPTION
                  WHEN DUP_VAL_ON_INDEX THEN
                     
                     
                     
                     
                     
                     L_CHECK_IF_GK_PRESENT := TRUE;
                  END;
               
               ELSE
                  L_CHECK_IF_GK_PRESENT := TRUE;
               END IF;
               
               IF L_CHECK_IF_GK_PRESENT THEN
                  
                  
                  BEGIN
                     SELECT '1'
                     INTO L_GK_PRESENT
                     FROM UTSCGK
                     WHERE SC = A_SC
                     AND GK = A_FIELDNAMES_TAB(L_ROW)
                     AND VALUE = A_FIELDVALUES_TAB(L_ROW);
                  EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     L_INSERT := TRUE;
                  END;
               END IF;
               
               IF L_INSERT THEN
                  BEGIN
                     
                     INSERT INTO UTSCGK(SC, GK, GKSEQ, VALUE)
                     SELECT A_SC, A_FIELDNAMES_TAB(L_ROW),  NVL(MAX(GKSEQ),0)+1, A_FIELDVALUES_TAB(L_ROW)
                     FROM UTSCGK
                     WHERE SC = A_SC;

                     IF A_FIELDVALUES_TAB(L_ROW) IS NOT NULL THEN
                        EXECUTE IMMEDIATE 'INSERT INTO utscgk' || A_FIELDNAMES_TAB(L_ROW) ||
                                          '(sc, ' || A_FIELDNAMES_TAB(L_ROW) || ') VALUES (:a_sc, :a_gk)'
                        USING A_SC, A_FIELDVALUES_TAB(L_ROW);

                        IF SQL%ROWCOUNT = 0 THEN
                           UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NORECORDS;
                           RAISE STPERROR;
                        END IF;
                     END IF;
                  EXCEPTION
                  WHEN DUP_VAL_ON_INDEX THEN
                     
                     
                     NULL;
                  END;
               END IF;
            END IF;
            CLOSE L_GKSC_CURSOR;
         END IF;
      END LOOP;
      
      
      
      L_CREATE_IC := A_CREATE_IC;
      IF NVL(L_CREATE_IC, ' ') = ' ' THEN
         
         
         L_RET_CODE := GETPREFVALUE(UNAPIGEN.P_CURRENT_UP, A_USERID, 'scCreateIc',
                                    L_PREF_VALUE);
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            RAISE STPERROR;
         END IF;
         L_CREATE_IC := L_PREF_VALUE;
      END IF;
      IF NVL(L_CREATE_IC, 'ON SAMPLE CREATION') = 'ON SAMPLE CREATION' THEN
         L_RET_CODE := UNAPIIC.CREATESCINFODETAILS(A_ST, A_ST_VERSION, A_SC,
                                        UNAPIGEN.PERFORM_FREQ_FILTERING,
                                        L_REF_DATE, A_MODIFY_REASON);
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            RAISE STPERROR;
         END IF;
      END IF;

      
      
      
      IF NVL(L_CREATE_PG, 'ON SAMPLE CREATION') = 'ON SAMPLE CREATION' THEN
         
         
         L_FIELDNR_OF_ROWS := 0;
         L_RET_CODE := UNAPISC.CREATESCANALYSESDETAILS(A_ST, A_ST_VERSION, A_SC,
                                            UNAPIGEN.PERFORM_FREQ_FILTERING,
                                            L_REF_DATE, 
                                            L_FIELDTYPE_TAB, L_FIELDNAMES_TAB, 
                                            L_FIELDVALUES_TAB, L_FIELDNR_OF_ROWS,
                                            A_MODIFY_REASON);
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            RAISE STPERROR;
         END IF;
      END IF;

   END IF;

   
   
   
   L_EVENT_TP := 'SampleCreated';
   L_EV_SEQ_NR := -1;
   L_EV_DETAILS := 'st_version='||A_ST_VERSION;
   L_API_NAME := 'CreateSample';
   IF L_PLAN_SAMPLE THEN
      L_API_NAME := 'PlanSample';
   END IF;

   IF L_DELAY <> 0 AND L_DELAY_UNIT IS NOT NULL THEN
      
      
      
      L_RET_CODE := UNAPIAUT.CALCULATEDELAY(L_DELAY,
                                            L_DELAY_UNIT,
                                            L_REF_DATE, L_DELAYED_TILL);
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
         RAISE STPERROR;
      END IF;

      
      
      
      L_TIMED_EVENT_TP := 'ScActivate';
      L_RESULT := UNAPIEV.INSERTTIMEDEVENT(L_API_NAME, UNAPIGEN.P_EVMGR_NAME, 'sc', A_SC, '', '', 
                                           '', L_TIMED_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR, 
                                           L_DELAYED_TILL);
      IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.P_TXN_ERROR := L_RESULT;
         RAISE STPERROR;
      END IF;

      
      
      
      INSERT INTO UTDELAY(SC, OBJECT_TP, DELAY, DELAY_UNIT,
                          DELAYED_FROM, DELAYED_FROM_TZ, DELAYED_TILL, DELAYED_TILL_TZ)
      VALUES(A_SC, 'sc', L_DELAY, L_DELAY_UNIT,
             L_REF_DATE, L_REF_DATE, L_DELAYED_TILL, L_DELAYED_TILL);

      L_EV_DETAILS := L_EV_DETAILS || '#ss_to=@D';
   END IF;

   IF NOT L_PLAN_SAMPLE THEN
      L_RESULT := UNAPIEV.INSERTEVENT(L_API_NAME, UNAPIGEN.P_EVMGR_NAME, 'sc',
                                      A_SC, '', '', '', L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);
      IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.P_TXN_ERROR := L_RESULT;
         RAISE STPERROR;
      END IF;

      INSERT INTO UTSCHS(SC, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION,
                         LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
      VALUES(A_SC, NVL(A_USERID, UNAPIGEN.P_USER), UNAPIGEN.SQLUSERDESCRIPTION(NVL(A_USERID, UNAPIGEN.P_USER)),
             L_EVENT_TP, 'sample "'||A_SC||'" is created',
             CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
   END IF;

   
   
   
   
   IF NVL(L_ST_REC.SHELF_LIFE_VAL, 0) <> 0 THEN
      
      
      
      L_RET_CODE := UNAPIAUT.CALCULATEDELAY(L_ST_REC.SHELF_LIFE_VAL,
                                            L_ST_REC.SHELF_LIFE_UNIT,
                                            L_REF_DATE, L_DELAYED_TILL);
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
         RAISE STPERROR;
      END IF;

      
      
      
      L_TIMED_EVENT_TP := 'ScShelfLifeExceeded';
      L_EV_DETAILS := 'st_version='||A_ST_VERSION; 
      L_RESULT := UNAPIEV.INSERTTIMEDEVENT('CreateSample', UNAPIGEN.P_EVMGR_NAME, 'sc', A_SC, '', '', 
                                           '', L_TIMED_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR, 
                                           L_DELAYED_TILL);
      IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.P_TXN_ERROR := L_RESULT;
         RAISE STPERROR;
      END IF;
   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('CreateSample', SQLERRM);
   ELSIF L_SQLERRM IS NOT NULL THEN
      UNAPIGEN.LOGERROR('CreateSample', L_SQLERRM);
   END IF;
   IF DBMS_SQL.IS_OPEN(L_DATE_CURSOR) THEN
      DBMS_SQL.CLOSE_CURSOR(L_DATE_CURSOR);
   END IF;
   IF L_GKSC_CURSOR%ISOPEN THEN
      CLOSE L_GKSC_CURSOR;
   END IF;



   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'CreateSample'));
END CREATESAMPLE;




FUNCTION CREATESAMPLE2                                
(A_ST               IN     VARCHAR2,                  
 A_ST_VERSION       IN OUT VARCHAR2,                   
 A_SC               IN OUT VARCHAR2,                  
 A_REF_DATE         IN     DATE,                      
 A_DELAY            IN     NUMBER,                    
 A_DELAY_UNIT       IN     VARCHAR2,                   
 A_CREATE_IC        IN     VARCHAR2,                  
 A_CREATE_PG        IN     VARCHAR2,                  
 A_USERID           IN     VARCHAR2,                  
 A_FIELDTYPE_TAB    IN     UNAPIGEN.VC20_TABLE_TYPE,  
 A_FIELDNAMES_TAB   IN     UNAPIGEN.VC20_TABLE_TYPE,  
 A_FIELDVALUES_TAB  IN     UNAPIGEN.VC40_TABLE_TYPE,  
 A_NR_OF_ROWS       IN     NUMBER,                    
 A_MODIFY_REASON    IN     VARCHAR2)                  
RETURN NUMBER IS

L_FIELDTYPE_TAB           UNAPIGEN.VC20_TABLE_TYPE;
L_FIELDNAMES_TAB          UNAPIGEN.VC20_TABLE_TYPE;
L_FIELDVALUES_TAB         UNAPIGEN.VC40_TABLE_TYPE;
L_NR_OF_ROWS              NUMBER;

BEGIN
   
 
   L_NR_OF_ROWS := A_NR_OF_ROWS;
   FOR L_ROW IN 1..L_NR_OF_ROWS LOOP
      L_FIELDTYPE_TAB(L_ROW) := A_FIELDTYPE_TAB(L_ROW);
      L_FIELDNAMES_TAB(L_ROW) := A_FIELDNAMES_TAB(L_ROW);
      L_FIELDVALUES_TAB(L_ROW) := A_FIELDVALUES_TAB(L_ROW);
   END LOOP;
   L_NR_OF_ROWS := NVL(L_NR_OF_ROWS,0)+1;
   L_FIELDTYPE_TAB(L_NR_OF_ROWS) := 'delay';
   L_FIELDNAMES_TAB(L_NR_OF_ROWS) := 'delay';
   L_FIELDVALUES_TAB(L_NR_OF_ROWS) := A_DELAY;

   L_NR_OF_ROWS := NVL(L_NR_OF_ROWS,0)+1;
   L_FIELDTYPE_TAB(L_NR_OF_ROWS) := 'delay_unit';
   L_FIELDNAMES_TAB(L_NR_OF_ROWS) := 'delay_unit';
   L_FIELDVALUES_TAB(L_NR_OF_ROWS) := A_DELAY_UNIT;
   
   
   RETURN(UNAPISC.CREATESAMPLE(A_ST, A_ST_VERSION, A_SC, A_REF_DATE, 
                               A_CREATE_IC, A_CREATE_PG, A_USERID, 
                               L_FIELDTYPE_TAB, L_FIELDNAMES_TAB, L_FIELDVALUES_TAB, L_NR_OF_ROWS,
                               A_MODIFY_REASON));
END CREATESAMPLE2;

FUNCTION PLANSAMPLE                        
(A_ST               IN     VARCHAR2,                  
 A_ST_VERSION       IN OUT VARCHAR2,                   
 A_SC               IN OUT VARCHAR2,                  
 A_REF_DATE         IN     DATE,                      
 A_CREATE_IC        IN     VARCHAR2,                  
 A_CREATE_PG        IN     VARCHAR2,                  
 A_USERID           IN     VARCHAR2,                  
 A_FIELDTYPE_TAB    IN     UNAPIGEN.VC20_TABLE_TYPE,  
 A_FIELDNAMES_TAB   IN     UNAPIGEN.VC20_TABLE_TYPE,  
 A_FIELDVALUES_TAB  IN     UNAPIGEN.VC40_TABLE_TYPE,  
 A_NR_OF_ROWS       IN     NUMBER,                    
 A_MODIFY_REASON    IN     VARCHAR2)                  
RETURN NUMBER IS

L_FIELDTYPE_TAB           UNAPIGEN.VC20_TABLE_TYPE;
L_FIELDNAMES_TAB          UNAPIGEN.VC20_TABLE_TYPE;
L_FIELDVALUES_TAB         UNAPIGEN.VC40_TABLE_TYPE;
L_NR_OF_ROWS              NUMBER;

BEGIN
   
   FOR L_ROW IN 1..A_NR_OF_ROWS LOOP
      L_FIELDTYPE_TAB(L_ROW) := A_FIELDTYPE_TAB(L_ROW);
      L_FIELDNAMES_TAB(L_ROW) := A_FIELDNAMES_TAB(L_ROW);
      L_FIELDVALUES_TAB(L_ROW) := A_FIELDVALUES_TAB(L_ROW);
   END LOOP;
   L_NR_OF_ROWS := NVL(A_NR_OF_ROWS,0)+1;
   L_FIELDTYPE_TAB(L_NR_OF_ROWS) := 'plan_sample';
   L_FIELDNAMES_TAB(L_NR_OF_ROWS) := NULL;
   L_FIELDVALUES_TAB(L_NR_OF_ROWS) := NULL;

   
   RETURN(UNAPISC.CREATESAMPLE(A_ST, A_ST_VERSION, A_SC, A_REF_DATE, 
                               A_CREATE_IC, A_CREATE_PG, A_USERID, 
                               L_FIELDTYPE_TAB, L_FIELDNAMES_TAB, L_FIELDVALUES_TAB, L_NR_OF_ROWS,
                               A_MODIFY_REASON));
END PLANSAMPLE;

FUNCTION GENERATESAMPLECODE
(A_ST               IN     VARCHAR2,                  
 A_ST_VERSION       IN OUT VARCHAR2,                   
 A_REF_DATE         IN     DATE,                      
 A_FIELDTYPE_TAB    IN     UNAPIGEN.VC20_TABLE_TYPE,  
 A_FIELDNAMES_TAB   IN     UNAPIGEN.VC20_TABLE_TYPE,  
 A_FIELDVALUES_TAB  IN     UNAPIGEN.VC40_TABLE_TYPE,  
 A_NR_OF_ROWS       IN     NUMBER,                    
 A_SC               OUT    VARCHAR2,                  
 A_EDIT_ALLOWED     OUT    CHAR,                      
 A_VALID_CF         OUT    VARCHAR2)                  
RETURN NUMBER IS

L_SC_UC         VARCHAR2(20);
L_NEXT_VAL      VARCHAR2(255);

L_FIELDTYPE_TAB       UNAPIGEN.VC20_TABLE_TYPE;
L_FIELDNAMES_TAB      UNAPIGEN.VC40_TABLE_TYPE;
L_FIELDVALUES_TAB     UNAPIGEN.VC40_TABLE_TYPE;
L_NR_OF_ROWS          NUMBER;
L_I                   NUMBER;


BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   A_ST_VERSION := UNAPIGEN.USEVERSION('st', A_ST, A_ST_VERSION);
   
   
   
   IF NVL(A_ST, ' ') <> ' ' THEN
      BEGIN
         SELECT SC_UC
         INTO L_SC_UC
         FROM UTST
         WHERE ST = A_ST
         AND VERSION = A_ST_VERSION;

      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         
         
         
         NULL;
      END;
   END IF;

   
   
   
   
   IF NVL(L_SC_UC, ' ') = ' ' THEN
      BEGIN
         SELECT UC
         INTO L_SC_UC
         FROM UTUC
         WHERE DEF_MASK_FOR = 'sc';

      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NODFLTMASKFORSC;
         RAISE STPERROR;
      WHEN TOO_MANY_ROWS THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_MULTDEFMASKFORSC;
         RAISE STPERROR;
      END;
   END IF;

   
   IF (A_NR_OF_ROWS > 0) THEN
    FOR L_I IN 1..A_NR_OF_ROWS LOOP
        L_FIELDTYPE_TAB(L_I) := A_FIELDTYPE_TAB(L_I);
        L_FIELDNAMES_TAB(L_I) := A_FIELDNAMES_TAB(L_I);
        L_FIELDVALUES_TAB(L_I) := A_FIELDVALUES_TAB(L_I);
    END LOOP  ;
   END IF ;
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

   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
     UNAPIGEN.LOGERROR('GenerateSampleCode', SQLERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'GenerateSampleCode'));
END GENERATESAMPLECODE;

FUNCTION SQLGETSCBESTMATCHINGPPLS                            
(A_SC                     IN      VARCHAR2,                  
 A_ST                     IN      VARCHAR2,                  
 A_ST_VERSION             IN      VARCHAR2,                  
 A_FIELDTYPE_TAB          IN      VC20_NESTEDTABLE_TYPE,     
 A_FIELDNAMES_TAB         IN      VC20_NESTEDTABLE_TYPE,     
 A_FIELDVALUES_TAB        IN      VC40_NESTEDTABLE_TYPE,     
 A_FIELDNR_OF_ROWS        IN      NUMBER)                    
RETURN UOSTPPKEYLIST IS
BEGIN
   RETURN(UNAPISC2.SQLGETSCBESTMATCHINGPPLS(A_SC, A_ST, A_ST_VERSION, A_FIELDTYPE_TAB, A_FIELDNAMES_TAB, A_FIELDVALUES_TAB, A_FIELDNR_OF_ROWS));
END SQLGETSCBESTMATCHINGPPLS;

FUNCTION INITSCANALYSESDETAILS
(A_ST                     IN      VARCHAR2,                  
 A_ST_VERSION             IN OUT  VARCHAR2,                   
 A_SC                     IN      VARCHAR2,                  
 A_FILTER_FREQ            IN      CHAR,                      
 A_REF_DATE               IN      DATE,                      
 A_FIELDTYPE_TAB          IN      UNAPIGEN.VC20_TABLE_TYPE,  
 A_FIELDNAMES_TAB         IN      UNAPIGEN.VC20_TABLE_TYPE,  
 A_FIELDVALUES_TAB        IN      UNAPIGEN.VC40_TABLE_TYPE,  
 A_FIELDNR_OF_ROWS        IN      NUMBER,                    
 A_PG                     OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PP_VERSION             OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PP_KEY1                OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PP_KEY2                OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PP_KEY3                OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PP_KEY4                OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PP_KEY5                OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_DESCRIPTION            OUT     UNAPIGEN.VC40_TABLE_TYPE,  
 A_VALUE_F                OUT     UNAPIGEN.FLOAT_TABLE_TYPE, 
 A_VALUE_S                OUT     UNAPIGEN.VC40_TABLE_TYPE,  
 A_UNIT                   OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_EXEC_START_DATE        OUT     UNAPIGEN.DATE_TABLE_TYPE,  
 A_EXEC_END_DATE          OUT     UNAPIGEN.DATE_TABLE_TYPE,  
 A_EXECUTOR               OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PLANNED_EXECUTOR       OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_MANUALLY_ENTERED       OUT     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_ASSIGN_DATE            OUT     UNAPIGEN.DATE_TABLE_TYPE,  
 A_ASSIGNED_BY            OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_MANUALLY_ADDED         OUT     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_FORMAT                 OUT     UNAPIGEN.VC40_TABLE_TYPE,  
 A_CONFIRM_ASSIGN         OUT     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_ALLOW_ANY_PR           OUT     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_NEVER_CREATE_METHODS   OUT     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_DELAY                  OUT     UNAPIGEN.NUM_TABLE_TYPE,   
 A_DELAY_UNIT             OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_REANALYSIS             OUT     UNAPIGEN.NUM_TABLE_TYPE,   
 A_PG_CLASS               OUT     UNAPIGEN.VC2_TABLE_TYPE,   
 A_LOG_HS                 OUT     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_LOG_HS_DETAILS         OUT     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_LC                     OUT     UNAPIGEN.VC2_TABLE_TYPE,   
 A_LC_VERSION             OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_NR_OF_ROWS             IN OUT  NUMBER)                    
RETURN NUMBER IS

L_REF_DATE                TIMESTAMP WITH TIME ZONE;
L_ASSIGN                  BOOLEAN;
L_PG                      UNAPIGEN.VC20_TABLE_TYPE;
L_PP_VERSION              UNAPIGEN.VC20_TABLE_TYPE;
L_PP_KEY1                 UNAPIGEN.VC20_TABLE_TYPE;
L_PP_KEY2                 UNAPIGEN.VC20_TABLE_TYPE;
L_PP_KEY3                 UNAPIGEN.VC20_TABLE_TYPE;
L_PP_KEY4                 UNAPIGEN.VC20_TABLE_TYPE;
L_PP_KEY5                 UNAPIGEN.VC20_TABLE_TYPE;
L_DESCRIPTION             UNAPIGEN.VC40_TABLE_TYPE;
L_VALUE_F                 UNAPIGEN.FLOAT_TABLE_TYPE;
L_VALUE_S                 UNAPIGEN.VC40_TABLE_TYPE;
L_UNIT                    UNAPIGEN.VC20_TABLE_TYPE;
L_EXEC_START_DATE         UNAPIGEN.DATE_TABLE_TYPE;
L_EXEC_END_DATE           UNAPIGEN.DATE_TABLE_TYPE;
L_EXECUTOR                UNAPIGEN.VC20_TABLE_TYPE;
L_PLANNED_EXECUTOR        UNAPIGEN.VC20_TABLE_TYPE;
L_MANUALLY_ENTERED        UNAPIGEN.CHAR1_TABLE_TYPE;
L_ASSIGN_DATE             UNAPIGEN.DATE_TABLE_TYPE;
L_ASSIGNED_BY             UNAPIGEN.VC20_TABLE_TYPE;
L_MANUALLY_ADDED          UNAPIGEN.CHAR1_TABLE_TYPE;
L_FORMAT                  UNAPIGEN.VC40_TABLE_TYPE;
L_CONFIRM_ASSIGN          UNAPIGEN.CHAR1_TABLE_TYPE;
L_ALLOW_ANY_PR            UNAPIGEN.CHAR1_TABLE_TYPE;
L_NEVER_CREATE_METHODS    UNAPIGEN.CHAR1_TABLE_TYPE;
L_DELAY                   UNAPIGEN.NUM_TABLE_TYPE;
L_DELAY_UNIT              UNAPIGEN.VC20_TABLE_TYPE;
L_REANALYSIS              UNAPIGEN.NUM_TABLE_TYPE;
L_PG_CLASS                UNAPIGEN.VC2_TABLE_TYPE;
L_LOG_HS                  UNAPIGEN.CHAR1_TABLE_TYPE;
L_LOG_HS_DETAILS          UNAPIGEN.CHAR1_TABLE_TYPE;
L_LC                      UNAPIGEN.VC2_TABLE_TYPE;
L_LC_VERSION              UNAPIGEN.VC20_TABLE_TYPE;
L_NR_OF_ROWS              NUMBER;
L_TOT_NR_ROWS             NUMBER;
L_FILTER_FREQ             CHAR(1);
L_DYN_CURSOR              INTEGER;
L_ST_VERSION              VARCHAR2(20);
L_FIELDTYPE_NESTEDTAB     VC20_NESTEDTABLE_TYPE := VC20_NESTEDTABLE_TYPE();
L_FIELDNAMES_NESTEDTAB    VC20_NESTEDTABLE_TYPE := VC20_NESTEDTABLE_TYPE();
L_FIELDVALUES_NESTEDTAB   VC40_NESTEDTABLE_TYPE := VC40_NESTEDTABLE_TYPE();

CURSOR L_STPP_CURSOR(C_ST IN VARCHAR2, C_ST_VERSION IN VARCHAR2) IS
   SELECT A.ST, A.VERSION ST_VERSION, A.PP, A.PP_VERSION, A.SEQ, A.FREQ_TP, A.FREQ_VAL, 
          A.FREQ_UNIT, A.INVERT_FREQ, A.LAST_SCHED, A.LAST_CNT, A.LAST_VAL,
          A.PP_KEY1, A.PP_KEY2, A.PP_KEY3, A.PP_KEY4, A.PP_KEY5 
   FROM UTSTPPBUFFER A, UTPP B
   WHERE A.ST = C_ST
   AND A.VERSION = C_ST_VERSION
   AND A.PP = B.PP
   AND UNAPIGEN.USEPPVERSION(A.PP, A.PP_VERSION, A.PP_KEY1, A.PP_KEY2, A.PP_KEY3, A.PP_KEY4, A.PP_KEY5) = B.VERSION
   AND A.PP_KEY1 = B.PP_KEY1   
   AND A.PP_KEY2 = B.PP_KEY2   
   AND A.PP_KEY3 = B.PP_KEY3   
   AND A.PP_KEY4 = B.PP_KEY4   
   AND A.PP_KEY5 = B.PP_KEY5   
   ORDER BY SEQ;
L_STPP_REC      L_STPP_CURSOR%ROWTYPE;

CURSOR L_STPPMULTIPLANT_CURSOR(C_ST IN VARCHAR2, C_ST_VERSION IN VARCHAR2) IS
   SELECT A.ST, A.VERSION ST_VERSION, A.PP, A.PP_VERSION, A.SEQ, A.FREQ_TP, A.FREQ_VAL, 
          A.FREQ_UNIT, A.INVERT_FREQ, A.LAST_SCHED, A.LAST_CNT, A.LAST_VAL,
          A.PP_KEY1, A.PP_KEY2, A.PP_KEY3, A.PP_KEY4, A.PP_KEY5 
   FROM UTSTPPBUFFER A, UTPP B
   WHERE A.ST = C_ST
   AND A.VERSION = C_ST_VERSION
   AND A.PP = B.PP
   AND UNAPIGEN.USEPPVERSION(A.PP, A.PP_VERSION, A.PP_KEY1, A.PP_KEY2, A.PP_KEY3, A.PP_KEY4, A.PP_KEY5) = B.VERSION
   AND A.PP_KEY1 = B.PP_KEY1   
   AND A.PP_KEY2 = B.PP_KEY2   
   AND A.PP_KEY3 = B.PP_KEY3   
   AND A.PP_KEY4 = B.PP_KEY4   
   AND A.PP_KEY5 = B.PP_KEY5
   AND (A.ST, A.VERSION, A.PP, A.PP_VERSION, A.PP_KEY1, A.PP_KEY2, A.PP_KEY3, A.PP_KEY4, A.PP_KEY5, A.SEQ)
       IN (SELECT * FROM TABLE(CAST(UNAPISC.SQLGETSCBESTMATCHINGPPLS(A_SC, 
                                                                     C_ST,
                                                                     C_ST_VERSION,
                                                                     L_FIELDTYPE_NESTEDTAB,
                                                                     L_FIELDNAMES_NESTEDTAB, 
                                                                     L_FIELDVALUES_NESTEDTAB, 
                                                                     A_FIELDNR_OF_ROWS)
                                    AS UOSTPPKEYLIST)))
   ORDER BY SEQ;

   
   PROCEDURE ASSIGN(A_PP_TO_ASSIGN           IN VARCHAR2,
                    A_PP_KEY1_TO_ASSIGN      IN VARCHAR2,
                    A_PP_KEY2_TO_ASSIGN      IN VARCHAR2,
                    A_PP_KEY3_TO_ASSIGN      IN VARCHAR2,
                    A_PP_KEY4_TO_ASSIGN      IN VARCHAR2,
                    A_PP_KEY5_TO_ASSIGN      IN VARCHAR2) IS
   L_ROW      INTEGER;
   BEGIN
      FOR L_ROW IN 1..L_NR_OF_ROWS LOOP
         
         
         
         
         A_ASSIGN_DATE(L_TOT_NR_ROWS + L_ROW) := L_REF_DATE;
         A_ASSIGNED_BY(L_TOT_NR_ROWS + L_ROW) := UNAPIGEN.P_USER;
         
         
         
         A_PG(L_TOT_NR_ROWS + L_ROW) := A_PP_TO_ASSIGN;
         A_PP_VERSION(L_TOT_NR_ROWS + L_ROW) := L_PP_VERSION(L_ROW);
         A_PP_KEY1(L_TOT_NR_ROWS + L_ROW) := A_PP_KEY1_TO_ASSIGN;
         A_PP_KEY2(L_TOT_NR_ROWS + L_ROW) := A_PP_KEY2_TO_ASSIGN;
         A_PP_KEY3(L_TOT_NR_ROWS + L_ROW) := A_PP_KEY3_TO_ASSIGN;
         A_PP_KEY4(L_TOT_NR_ROWS + L_ROW) := A_PP_KEY4_TO_ASSIGN;
         A_PP_KEY5(L_TOT_NR_ROWS + L_ROW) := A_PP_KEY5_TO_ASSIGN;
         A_DESCRIPTION(L_TOT_NR_ROWS + L_ROW) := L_DESCRIPTION(L_ROW);
         A_VALUE_F(L_TOT_NR_ROWS + L_ROW) := L_VALUE_F(L_ROW);
         A_VALUE_S(L_TOT_NR_ROWS + L_ROW) := L_VALUE_S(L_ROW);
         A_UNIT(L_TOT_NR_ROWS + L_ROW) := L_UNIT(L_ROW);
         A_EXEC_START_DATE(L_TOT_NR_ROWS + L_ROW) := L_EXEC_START_DATE(L_ROW);
         A_EXEC_END_DATE(L_TOT_NR_ROWS + L_ROW) := L_EXEC_END_DATE(L_ROW);
         A_EXECUTOR(L_TOT_NR_ROWS + L_ROW) := L_EXECUTOR(L_ROW);
         A_PLANNED_EXECUTOR(L_TOT_NR_ROWS + L_ROW) := L_PLANNED_EXECUTOR(L_ROW);
         A_MANUALLY_ENTERED(L_TOT_NR_ROWS + L_ROW) := L_MANUALLY_ENTERED(L_ROW);
         A_MANUALLY_ADDED(L_TOT_NR_ROWS + L_ROW) := L_MANUALLY_ADDED(L_ROW);
         A_FORMAT(L_TOT_NR_ROWS + L_ROW) := L_FORMAT(L_ROW);
         A_CONFIRM_ASSIGN(L_TOT_NR_ROWS + L_ROW) := L_CONFIRM_ASSIGN(L_ROW);
         A_ALLOW_ANY_PR(L_TOT_NR_ROWS + L_ROW) := L_ALLOW_ANY_PR(L_ROW);
         A_NEVER_CREATE_METHODS(L_TOT_NR_ROWS + L_ROW) := L_NEVER_CREATE_METHODS(L_ROW);
         A_DELAY(L_TOT_NR_ROWS + L_ROW) := L_DELAY(L_ROW);
         A_DELAY_UNIT(L_TOT_NR_ROWS + L_ROW) := L_DELAY_UNIT(L_ROW);
         A_REANALYSIS(L_TOT_NR_ROWS + L_ROW) := L_REANALYSIS(L_ROW);
         A_PG_CLASS(L_TOT_NR_ROWS + L_ROW) := L_PG_CLASS(L_ROW);
         A_LOG_HS(L_TOT_NR_ROWS + L_ROW) := L_LOG_HS(L_ROW);
         A_LOG_HS_DETAILS(L_TOT_NR_ROWS + L_ROW) := L_LOG_HS_DETAILS(L_ROW);
         A_LC(L_TOT_NR_ROWS + L_ROW) := L_LC(L_ROW);
         A_LC_VERSION(L_TOT_NR_ROWS + L_ROW) := L_LC_VERSION(L_ROW);
      END LOOP;
   END ASSIGN;

BEGIN

      
   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   
   IF UNAPIGEN.P_PP_KEY4PRODUCT IS NULL THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_SETCONNECTION;
      RAISE STPERROR;               
   END IF;

   IF NVL(A_NR_OF_ROWS, 0) = 0 THEN
      A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
   ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NROFROWS;
      RAISE STPERROR;
   END IF;

   
   
   
   
   
   
   
   IF NVL(A_ST, ' ') = ' ' OR
      NVL(A_SC, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   L_ST_VERSION := UNAPIGEN.VALIDATEVERSION('st', A_ST, A_ST_VERSION);
   L_REF_DATE := A_REF_DATE;
   IF L_REF_DATE IS NULL THEN
      SELECT SAMPLING_DATE
      INTO L_REF_DATE
      FROM UTSC
      WHERE SC = A_SC;
   END IF;
   IF L_REF_DATE IS NULL THEN
      L_REF_DATE := CURRENT_TIMESTAMP;
   END IF;

   L_FILTER_FREQ := NVL(A_FILTER_FREQ, '1');
   L_NR_OF_ROWS := 0;
   L_TOT_NR_ROWS := 0;

   
   
   
   

   L_RET_CODE := UNAPIAUT.INITSTPPBUFFER (A_ST, L_ST_VERSION) ;

   IF UNAPIGEN.P_PP_KEY_NR_OF_ROWS = 0 THEN
      OPEN L_STPP_CURSOR(A_ST, L_ST_VERSION);
   ELSE
      
      FOR L_FIELDNR IN 1..A_FIELDNR_OF_ROWS LOOP
         L_FIELDTYPE_NESTEDTAB.EXTEND();
         L_FIELDTYPE_NESTEDTAB(L_FIELDNR) := A_FIELDTYPE_TAB(L_FIELDNR);
         L_FIELDNAMES_NESTEDTAB.EXTEND();
         L_FIELDNAMES_NESTEDTAB(L_FIELDNR) := A_FIELDNAMES_TAB(L_FIELDNR);
         L_FIELDVALUES_NESTEDTAB.EXTEND();
         L_FIELDVALUES_NESTEDTAB(L_FIELDNR) := A_FIELDVALUES_TAB(L_FIELDNR);         
      END LOOP;
      OPEN L_STPPMULTIPLANT_CURSOR(A_ST, L_ST_VERSION);   
   END IF;
   
   LOOP
      IF UNAPIGEN.P_PP_KEY_NR_OF_ROWS = 0 THEN
         FETCH L_STPP_CURSOR
         INTO L_STPP_REC;
         IF L_STPP_CURSOR%NOTFOUND THEN
            CLOSE L_STPP_CURSOR;
            EXIT;
         END IF;
      ELSE
         FETCH L_STPPMULTIPLANT_CURSOR
         INTO L_STPP_REC;
         IF L_STPPMULTIPLANT_CURSOR%NOTFOUND THEN
            CLOSE L_STPPMULTIPLANT_CURSOR;
            EXIT;
         END IF;
      END IF;
           
      L_STPP_REC.PP_VERSION := UNAPIGEN.VALIDATEPPVERSION(L_STPP_REC.PP, L_STPP_REC.PP_VERSION, 
                                                          L_STPP_REC.PP_KEY1, L_STPP_REC.PP_KEY2, 
                                                          L_STPP_REC.PP_KEY3, L_STPP_REC.PP_KEY4,
                                                          L_STPP_REC.PP_KEY5);
      L_ASSIGN := FALSE;
      IF L_FILTER_FREQ = '0' THEN
         L_ASSIGN := TRUE;
      ELSIF L_FILTER_FREQ = '1' THEN
         L_ASSIGN := TRUE;
         IF L_STPP_REC.FREQ_TP = 'C' THEN

            
            
            
            L_SQL_STRING := 'BEGIN :l_ret_code := UNFREQ.'|| L_STPP_REC.FREQ_UNIT ||
                '(:a_sc, :a_st, :a_st_version, :a_pp, :a_pp_version , '||
                ':a_pp_key1, :a_pp_key2, :a_pp_key3, :a_pp_key4, :a_pp_key5, '||
                ':a_freq_val, :a_invert_freq,:a_ref_date, ' ||
                ':a_last_sched, :a_last_cnt, :a_last_val); END;';

            L_DYN_CURSOR := DBMS_SQL.OPEN_CURSOR;

            DBMS_SQL.PARSE(L_DYN_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':l_ret_code', L_RET_CODE);
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_sc', A_SC, 20);
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_st', A_ST, 20);
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_st_version', A_ST_VERSION, 20);
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_pp', L_STPP_REC.PP, 20);
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_pp_version', L_STPP_REC.PP_VERSION, 20);
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_pp_key1', L_STPP_REC.PP_KEY1, 20);
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_pp_key2', L_STPP_REC.PP_KEY2, 20);
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_pp_key3', L_STPP_REC.PP_KEY3, 20);
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_pp_key4', L_STPP_REC.PP_KEY4, 20);
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_pp_key5', L_STPP_REC.PP_KEY5, 20);
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_freq_val', L_STPP_REC.FREQ_VAL);
            DBMS_SQL.BIND_VARIABLE_CHAR(L_DYN_CURSOR, ':a_invert_freq', L_STPP_REC.INVERT_FREQ, 1);
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_ref_date', L_REF_DATE);
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_last_sched', L_STPP_REC.LAST_SCHED);
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_last_cnt', L_STPP_REC.LAST_CNT);
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_last_val', L_STPP_REC.LAST_VAL, 40);

            L_RESULT := DBMS_SQL.EXECUTE(L_DYN_CURSOR);
            DBMS_SQL.VARIABLE_VALUE(L_DYN_CURSOR, ':l_ret_code', L_RET_CODE);
            DBMS_SQL.VARIABLE_VALUE(L_DYN_CURSOR, ':a_last_sched', L_STPP_REC.LAST_SCHED);
            DBMS_SQL.VARIABLE_VALUE(L_DYN_CURSOR, ':a_last_cnt', L_STPP_REC.LAST_CNT);
            DBMS_SQL.VARIABLE_VALUE(L_DYN_CURSOR, ':a_last_val', L_STPP_REC.LAST_VAL);

            DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);

            IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
               L_ASSIGN := FALSE;
            END IF;
         ELSE
            IF NOT UNAPIAUT.EVALASSIGNMENTFREQ('sc', A_SC, '', 'pg', L_STPP_REC.PP,
                                               L_STPP_REC.PP_VERSION,
                                               L_STPP_REC.FREQ_TP,
                                               L_STPP_REC.FREQ_VAL,
                                               L_STPP_REC.FREQ_UNIT,
                                               L_STPP_REC.INVERT_FREQ,
                                               L_REF_DATE,
                                               L_STPP_REC.LAST_SCHED,
                                               L_STPP_REC.LAST_CNT,
                                               L_STPP_REC.LAST_VAL) THEN
               L_ASSIGN := FALSE;
            END IF;
         END IF;

         
         
         
         UPDATE UTSTPPBUFFER
         SET LAST_SCHED = L_STPP_REC.LAST_SCHED,
             LAST_SCHED_TZ = DECODE(L_STPP_REC.LAST_SCHED, LAST_SCHED, LAST_SCHED_TZ, L_STPP_REC.LAST_SCHED) ,
             LAST_CNT = L_STPP_REC.LAST_CNT,
             LAST_VAL = L_STPP_REC.LAST_VAL,
             HANDLED = 'Y'
         WHERE ST = L_STPP_REC.ST
           AND VERSION = L_STPP_REC.ST_VERSION
           AND PP = L_STPP_REC.PP
           AND PP_KEY1 = L_STPP_REC.PP_KEY1
           AND PP_KEY2 = L_STPP_REC.PP_KEY2
           AND PP_KEY3 = L_STPP_REC.PP_KEY3
           AND PP_KEY4 = L_STPP_REC.PP_KEY4
           AND PP_KEY5 = L_STPP_REC.PP_KEY5
           AND UNAPIGEN.VALIDATEPPVERSION(PP,PP_VERSION, PP_KEY1, PP_KEY2, PP_KEY3, PP_KEY4, PP_KEY5) =
               UNAPIGEN.VALIDATEPPVERSION(L_STPP_REC.PP,L_STPP_REC.PP_VERSION,
                                          L_STPP_REC.PP_KEY1,L_STPP_REC.PP_KEY2,L_STPP_REC.PP_KEY3,
                                          L_STPP_REC.PP_KEY4,L_STPP_REC.PP_KEY5)
           AND SEQ = L_STPP_REC.SEQ; 
                                     
                                     
      END IF;

      IF L_ASSIGN THEN
         
         
         
         L_NR_OF_ROWS := 0;
         L_RET_CODE := UNAPIPG.INITSCPARAMETERGROUP(L_STPP_REC.PP, L_STPP_REC.PP_VERSION, 
                          L_STPP_REC.PP_KEY1, L_STPP_REC.PP_KEY2, L_STPP_REC.PP_KEY3, 
                          L_STPP_REC.PP_KEY4, L_STPP_REC.PP_KEY5, 
                          L_STPP_REC.SEQ, A_SC, L_PP_VERSION, L_DESCRIPTION, L_VALUE_F, 
                          L_VALUE_S, L_UNIT, L_EXEC_START_DATE, L_EXEC_END_DATE, L_EXECUTOR, 
                          L_PLANNED_EXECUTOR, L_MANUALLY_ENTERED, L_ASSIGN_DATE, L_ASSIGNED_BY,
                          L_MANUALLY_ADDED, L_FORMAT, L_CONFIRM_ASSIGN, L_ALLOW_ANY_PR, 
                          L_NEVER_CREATE_METHODS, L_DELAY, L_DELAY_UNIT, L_REANALYSIS, 
                          L_PG_CLASS, L_LOG_HS, L_LOG_HS_DETAILS, L_LC, L_LC_VERSION, 
                          L_NR_OF_ROWS);
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            RAISE STPERROR;
         END IF;

         
         
         
         IF L_NR_OF_ROWS > 0 THEN
            ASSIGN(L_STPP_REC.PP, L_STPP_REC.PP_KEY1, L_STPP_REC.PP_KEY2, L_STPP_REC.PP_KEY3,
                   L_STPP_REC.PP_KEY4, L_STPP_REC.PP_KEY5);
            L_TOT_NR_ROWS := L_TOT_NR_ROWS + L_NR_OF_ROWS;
         END IF;
      END IF;
   END LOOP;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   
   
   
   IF L_TOT_NR_ROWS > A_NR_OF_ROWS THEN
      INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
      VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 
             'InitScAnalysesDetails','a_nr_of_rows (' || A_NR_OF_ROWS ||
             ') too small for required ParameterGroup initialisation');
   END IF;

   A_NR_OF_ROWS := L_TOT_NR_ROWS;
   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('InitScAnalysesDetails', SQLERRM);
   END IF;
   IF L_STPP_CURSOR%ISOPEN THEN
      CLOSE L_STPP_CURSOR;
   END IF;
   IF L_STPPMULTIPLANT_CURSOR%ISOPEN THEN
      CLOSE L_STPPMULTIPLANT_CURSOR;
   END IF;
   IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
      DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'InitScAnalysesDetails'));
END INITSCANALYSESDETAILS;

FUNCTION CREATESCANALYSESDETAILS
(A_ST               IN      VARCHAR2,                  
 A_ST_VERSION       IN OUT  VARCHAR2,                   
 A_SC               IN      VARCHAR2,                  
 A_FILTER_FREQ      IN      CHAR,                      
 A_REF_DATE         IN      DATE,                      
 A_FIELDTYPE_TAB    IN      UNAPIGEN.VC20_TABLE_TYPE,  
 A_FIELDNAMES_TAB   IN      UNAPIGEN.VC20_TABLE_TYPE,  
 A_FIELDVALUES_TAB  IN      UNAPIGEN.VC40_TABLE_TYPE,  
 A_NR_OF_ROWS       IN      NUMBER,                    
 A_MODIFY_REASON    IN      VARCHAR2)                  
RETURN NUMBER IS

L_SC                      UNAPIGEN.VC20_TABLE_TYPE;
L_PG                      UNAPIGEN.VC20_TABLE_TYPE;
L_PGNODE                  UNAPIGEN.LONG_TABLE_TYPE;
L_PP_VERSION              UNAPIGEN.VC20_TABLE_TYPE;
L_PP_KEY1                 UNAPIGEN.VC20_TABLE_TYPE;
L_PP_KEY2                 UNAPIGEN.VC20_TABLE_TYPE;
L_PP_KEY3                 UNAPIGEN.VC20_TABLE_TYPE;
L_PP_KEY4                 UNAPIGEN.VC20_TABLE_TYPE;
L_PP_KEY5                 UNAPIGEN.VC20_TABLE_TYPE;
L_DESCRIPTION             UNAPIGEN.VC40_TABLE_TYPE;
L_VALUE_F                 UNAPIGEN.FLOAT_TABLE_TYPE;
L_VALUE_S                 UNAPIGEN.VC40_TABLE_TYPE;
L_UNIT                    UNAPIGEN.VC20_TABLE_TYPE;
L_EXEC_START_DATE         UNAPIGEN.DATE_TABLE_TYPE;
L_EXEC_END_DATE           UNAPIGEN.DATE_TABLE_TYPE;
L_EXECUTOR                UNAPIGEN.VC20_TABLE_TYPE;
L_PLANNED_EXECUTOR        UNAPIGEN.VC20_TABLE_TYPE;
L_MANUALLY_ENTERED        UNAPIGEN.CHAR1_TABLE_TYPE;
L_ASSIGN_DATE             UNAPIGEN.DATE_TABLE_TYPE;
L_ASSIGNED_BY             UNAPIGEN.VC20_TABLE_TYPE;
L_MANUALLY_ADDED          UNAPIGEN.CHAR1_TABLE_TYPE;
L_FORMAT                  UNAPIGEN.VC40_TABLE_TYPE;
L_CONFIRM_ASSIGN          UNAPIGEN.CHAR1_TABLE_TYPE;
L_ALLOW_ANY_PR            UNAPIGEN.CHAR1_TABLE_TYPE;
L_NEVER_CREATE_METHODS    UNAPIGEN.CHAR1_TABLE_TYPE;
L_DELAY                   UNAPIGEN.NUM_TABLE_TYPE;
L_DELAY_UNIT              UNAPIGEN.VC20_TABLE_TYPE;
L_REANALYSIS              UNAPIGEN.NUM_TABLE_TYPE;
L_PG_CLASS                UNAPIGEN.VC2_TABLE_TYPE;
L_LC                      UNAPIGEN.VC2_TABLE_TYPE;
L_LC_VERSION              UNAPIGEN.VC20_TABLE_TYPE;
L_LOG_HS                  UNAPIGEN.CHAR1_TABLE_TYPE;
L_LOG_HS_DETAILS          UNAPIGEN.CHAR1_TABLE_TYPE;
L_MODIFY_FLAG             UNAPIGEN.NUM_TABLE_TYPE;
L_NR_OF_ROWS              NUMBER;
L_ERRM                    VARCHAR2(255);
L_REF_DATE                TIMESTAMP WITH TIME ZONE;
L_SEQ                     NUMBER(5);
L_FILTER_FREQ             CHAR(1);
L_LOG_HS_SC               CHAR(1);
L_LOG_HS_DETAILS_SC       CHAR(1);
L_HS_DETAILS_SEQ_NR       INTEGER;
L_SUPPLIER_PP_KEY         VARCHAR2(20);
L_CUSTOMER_PP_KEY         VARCHAR2(20);
L_PGDETAILS_HANDLED       BOOLEAN_TABLE_TYPE;

BEGIN

      
   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   
   
   
   
   
   
   IF NVL(A_SC, ' ') = ' ' OR
      NVL(A_ST, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   
   A_ST_VERSION := UNAPIGEN.VALIDATEVERSION('st', A_ST, A_ST_VERSION);
   
   L_REF_DATE := A_REF_DATE;
   IF L_REF_DATE IS NULL THEN
      SELECT SAMPLING_DATE
      INTO L_REF_DATE
      FROM UTSC
      WHERE SC = A_SC;
   END IF;
   IF L_REF_DATE IS NULL THEN
      L_REF_DATE := CURRENT_TIMESTAMP;
   END IF;

   L_FILTER_FREQ := NVL(A_FILTER_FREQ, '1');
   L_ERRM := NULL;
   
   
   
   
   L_RET_CODE := UNAPISC.INITSCANALYSESDETAILS(A_ST, A_ST_VERSION, A_SC, L_FILTER_FREQ, 
                    L_REF_DATE, 
                    A_FIELDTYPE_TAB, A_FIELDNAMES_TAB, A_FIELDVALUES_TAB, A_NR_OF_ROWS,
                    L_PG, L_PP_VERSION, 
                    L_PP_KEY1, L_PP_KEY2, L_PP_KEY3, L_PP_KEY4, L_PP_KEY5, 
                    L_DESCRIPTION, L_VALUE_F, L_VALUE_S, 
                    L_UNIT, L_EXEC_START_DATE, L_EXEC_END_DATE, L_EXECUTOR, 
                    L_PLANNED_EXECUTOR, L_MANUALLY_ENTERED, L_ASSIGN_DATE,
                    L_ASSIGNED_BY, L_MANUALLY_ADDED, L_FORMAT, L_CONFIRM_ASSIGN, 
                    L_ALLOW_ANY_PR, L_NEVER_CREATE_METHODS, L_DELAY, L_DELAY_UNIT, L_REANALYSIS, 
                    L_PG_CLASS, L_LOG_HS, L_LOG_HS_DETAILS, L_LC, L_LC_VERSION, L_NR_OF_ROWS);
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      L_ERRM  := 'st=' || A_ST || 
                 '#st_version=' || A_ST_VERSION || 
                 '#sc=' || A_SC ||
                 '#filter_freq=' || L_FILTER_FREQ ||
                 '#ref_date=' || L_REF_DATE ||
                 '#nr_of_rows=' || L_NR_OF_ROWS ||
                 '#InitScAnalysesDetails#ErrorCode=' || TO_CHAR(L_RET_CODE);
      RAISE STPERROR;
   END IF;
   
   
   
   FOR L_ROW IN 1..L_NR_OF_ROWS LOOP
      L_SC(L_ROW) := A_SC;
      L_PGNODE(L_ROW) := 0;
      L_MODIFY_FLAG(L_ROW) := UNAPIGEN.MOD_FLAG_INSERT;
      L_MANUALLY_ADDED(L_ROW) := '0';
      
      
      
      L_DELAY(L_ROW) := NVL(L_DELAY(L_ROW), 0);
      L_DELAY_UNIT(L_ROW) := NVL(L_DELAY_UNIT(L_ROW), 'DD');
   END LOOP;

   
   
   
   IF L_NR_OF_ROWS > 0 THEN
      L_RET_CODE := UNAPIPG.SAVESCPARAMETERGROUP(L_SC, L_PG, L_PGNODE, L_PP_VERSION, 
                       L_PP_KEY1, L_PP_KEY2, L_PP_KEY3, L_PP_KEY4, L_PP_KEY5, 
                       L_DESCRIPTION, L_VALUE_F, L_VALUE_S, L_UNIT, L_EXEC_START_DATE, 
                       L_EXEC_END_DATE, L_EXECUTOR, L_PLANNED_EXECUTOR,
                       L_MANUALLY_ENTERED, L_ASSIGN_DATE, L_ASSIGNED_BY, 
                       L_MANUALLY_ADDED, L_FORMAT, L_CONFIRM_ASSIGN, L_ALLOW_ANY_PR, 
                       L_NEVER_CREATE_METHODS, L_DELAY, L_DELAY_UNIT, L_PG_CLASS, 
                       L_LOG_HS, L_LOG_HS_DETAILS, L_LC, L_LC_VERSION, 
                       L_MODIFY_FLAG, L_NR_OF_ROWS, A_MODIFY_REASON);
      IF L_RET_CODE = UNAPIGEN.DBERR_PARTIALSAVE THEN
         
         
         
         FOR L_ROW IN 1..L_NR_OF_ROWS LOOP
            IF L_MODIFY_FLAG(L_ROW) > UNAPIGEN.DBERR_SUCCESS THEN
               UNAPIGEN.P_TXN_ERROR := L_MODIFY_FLAG(L_ROW);
               L_ERRM  := 'sc=' || A_SC || 
                          '#pg=' || L_PG(L_ROW) ||
                          '#pgnode=' || TO_CHAR(L_PGNODE(L_ROW))||
                          '#SaveScParameterGroup#ErrorCode=' || TO_CHAR(L_RET_CODE);
               RAISE STPERROR;
            END IF;
         END LOOP;
      ELSIF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
         RAISE STPERROR;
      END IF;
   END IF;

   
   
   
   
   
   FOR L_ROW IN 1..L_NR_OF_ROWS LOOP 
      L_PGDETAILS_HANDLED(L_ROW) := FALSE;
      L_RET_CODE := UNAPIPG.GETSUPPLIERANDCUSTOMER(L_PP_KEY1(L_ROW), L_PP_KEY2(L_ROW), L_PP_KEY3(L_ROW),
                                                   L_PP_KEY4(L_ROW), L_PP_KEY5(L_ROW), 
                                                   L_SUPPLIER_PP_KEY, L_CUSTOMER_PP_KEY);
      
      IF L_SUPPLIER_PP_KEY = ' ' AND
         L_CUSTOMER_PP_KEY = ' ' THEN
                  
         L_PGDETAILS_HANDLED(L_ROW) := TRUE;
         L_RET_CODE := UNAPIPGP.INITANDSAVESCPGATTRIBUTES(A_SC, L_PG(L_ROW), L_PGNODE(L_ROW));
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            L_ERRM  := 'sc=' || A_SC || 
                       '#pg=' || L_PG(L_ROW) ||
                       '#pgnode=' || TO_CHAR(L_PGNODE(L_ROW)) ||
                       '#InitAndSaveScPgAttributes#ErrorCode=' || TO_CHAR(L_RET_CODE);
            RAISE STPERROR;
         END IF;

         
         
         
         L_RET_CODE := UNAPIPG.CREATESCPGDETAILS(A_ST, A_ST_VERSION, L_PG(L_ROW), L_PP_VERSION(L_ROW),
                                                 L_PP_KEY1(L_ROW), L_PP_KEY2(L_ROW), L_PP_KEY3(L_ROW), L_PP_KEY4(L_ROW), L_PP_KEY5(L_ROW), 
                                                 L_SEQ, A_SC, L_PGNODE(L_ROW), L_FILTER_FREQ,
                                                 L_REF_DATE, A_MODIFY_REASON);
         
         
         
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            L_ERRM  := 'sc=' || A_SC || 
                       '#pg=' || L_PG(L_ROW) ||
                       '#pgnode=' || TO_CHAR(L_PGNODE(L_ROW))||
                       '#CreateScPgDetails#ErrorCode=' || TO_CHAR(L_RET_CODE);
             UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
             RAISE STPERROR;
         END IF;
      END IF;
   END LOOP;
   FOR L_ROW IN 1..L_NR_OF_ROWS LOOP      
      IF L_PGDETAILS_HANDLED(L_ROW) = FALSE THEN
                  
         L_RET_CODE := UNAPIPGP.INITANDSAVESCPGATTRIBUTES(A_SC, L_PG(L_ROW), L_PGNODE(L_ROW));
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            L_ERRM  := 'sc=' || A_SC || 
                       '#pg=' || L_PG(L_ROW) ||
                       '#pgnode=' || TO_CHAR(L_PGNODE(L_ROW)) ||
                       '#InitAndSaveScPgAttributes#ErrorCode=' || TO_CHAR(L_RET_CODE);
            RAISE STPERROR;
         END IF;

         
         
         
         L_RET_CODE := UNAPIPG.CREATESCPGDETAILS(A_ST, A_ST_VERSION, L_PG(L_ROW), L_PP_VERSION(L_ROW),
                                                 L_PP_KEY1(L_ROW), L_PP_KEY2(L_ROW), L_PP_KEY3(L_ROW), L_PP_KEY4(L_ROW), L_PP_KEY5(L_ROW), 
                                                 L_SEQ, A_SC, L_PGNODE(L_ROW), L_FILTER_FREQ,
                                                 L_REF_DATE, A_MODIFY_REASON);
         
         
         
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            L_ERRM  := 'sc=' || A_SC || 
                       '#pg=' || L_PG(L_ROW) ||
                       '#pgnode=' || TO_CHAR(L_PGNODE(L_ROW))||
                       '#CreateScPgDetails#ErrorCode=' || TO_CHAR(L_RET_CODE);
             UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
             RAISE STPERROR;
         END IF;
      END IF;
   END LOOP;

   
   
   
   L_EV_SEQ_NR := -1;
   L_EVENT_TP := 'ScAnalysesCreated';
   L_EV_DETAILS := 'st=' || A_ST ||
                   '#st_version=' || A_ST_VERSION;
   L_RESULT := UNAPIEV.INSERTEVENT('CreateScAnalysesDetails', UNAPIGEN.P_EVMGR_NAME, 'sc', A_SC, '', 
                                   '', '', L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;
   
   BEGIN
      SELECT LOG_HS, LOG_HS_DETAILS
      INTO L_LOG_HS_SC, L_LOG_HS_DETAILS_SC
      FROM UTSC
      WHERE SC = A_SC;
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      RAISE STPERROR;
   END;

   IF NVL(L_LOG_HS_SC, ' ') = '1' THEN
      INSERT INTO UTSCHS(SC, WHO, WHO_DESCRIPTION, WHAT, 
                         WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
      VALUES (A_SC, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
              'sample "'||A_SC||'" analysis details are created.', 
              CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
   END IF;
   
   L_HS_DETAILS_SEQ_NR := 0;
   IF NVL(L_LOG_HS_DETAILS_SC, ' ') = '1' THEN
      L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
      INSERT INTO UTSCHSDETAILS(SC, TR_SEQ, EV_SEQ, SEQ, DETAILS)
      VALUES (A_SC, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR, 
              'sample "'||A_SC||'" analysis details are created.');
   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('CreateScAnalysesDetails', SQLERRM);
   ELSIF L_ERRM IS NOT NULL THEN
      UNAPIGEN.LOGERROR('CreateScAnalysesDetails', L_ERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'CreateScAnalysesDetails'));
END CREATESCANALYSESDETAILS;

FUNCTION ADDSCANALYSESDETAILS
(A_SC               IN      VARCHAR2,                  
 A_ST               IN      VARCHAR2,                  
 A_ST_VERSION       IN OUT  VARCHAR2,                   
 A_PP               IN      VARCHAR2,                  
 A_PP_VERSION       IN OUT  VARCHAR2,                   
 A_PP_KEY1          IN      VARCHAR2,                   
 A_PP_KEY2          IN      VARCHAR2,                   
 A_PP_KEY3          IN      VARCHAR2,                   
 A_PP_KEY4          IN      VARCHAR2,                   
 A_PP_KEY5          IN      VARCHAR2,                   
 A_SEQ              IN      NUMBER,                     
 A_MODIFY_REASON    IN      VARCHAR2)                  
RETURN NUMBER IS

L_SC                      UNAPIGEN.VC20_TABLE_TYPE;
L_PG                      UNAPIGEN.VC20_TABLE_TYPE;
L_PP_VERSION              UNAPIGEN.VC20_TABLE_TYPE;
L_PP_KEY1                 UNAPIGEN.VC20_TABLE_TYPE;
L_PP_KEY2                 UNAPIGEN.VC20_TABLE_TYPE;
L_PP_KEY3                 UNAPIGEN.VC20_TABLE_TYPE;
L_PP_KEY4                 UNAPIGEN.VC20_TABLE_TYPE;
L_PP_KEY5                 UNAPIGEN.VC20_TABLE_TYPE;
L_PGNODE                  UNAPIGEN.LONG_TABLE_TYPE;
L_DESCRIPTION             UNAPIGEN.VC40_TABLE_TYPE;
L_VALUE_F                 UNAPIGEN.FLOAT_TABLE_TYPE;
L_VALUE_S                 UNAPIGEN.VC40_TABLE_TYPE;
L_UNIT                    UNAPIGEN.VC20_TABLE_TYPE;
L_EXEC_START_DATE         UNAPIGEN.DATE_TABLE_TYPE;
L_EXEC_END_DATE           UNAPIGEN.DATE_TABLE_TYPE;
L_EXECUTOR                UNAPIGEN.VC20_TABLE_TYPE;
L_PLANNED_EXECUTOR        UNAPIGEN.VC20_TABLE_TYPE;
L_MANUALLY_ENTERED        UNAPIGEN.CHAR1_TABLE_TYPE;
L_ASSIGN_DATE             UNAPIGEN.DATE_TABLE_TYPE;
L_ASSIGNED_BY             UNAPIGEN.VC20_TABLE_TYPE;
L_MANUALLY_ADDED          UNAPIGEN.CHAR1_TABLE_TYPE;
L_FORMAT                  UNAPIGEN.VC40_TABLE_TYPE;
L_CONFIRM_ASSIGN          UNAPIGEN.CHAR1_TABLE_TYPE;
L_ALLOW_ANY_PR            UNAPIGEN.CHAR1_TABLE_TYPE;
L_NEVER_CREATE_METHODS    UNAPIGEN.CHAR1_TABLE_TYPE;
L_DELAY                   UNAPIGEN.NUM_TABLE_TYPE;
L_DELAY_UNIT              UNAPIGEN.VC20_TABLE_TYPE;
L_REANALYSIS              UNAPIGEN.NUM_TABLE_TYPE;
L_PG_CLASS                UNAPIGEN.VC2_TABLE_TYPE;
L_LOG_HS                  UNAPIGEN.CHAR1_TABLE_TYPE;
L_LOG_HS_DETAILS          UNAPIGEN.CHAR1_TABLE_TYPE;
L_LC                      UNAPIGEN.VC2_TABLE_TYPE;
L_LC_VERSION              UNAPIGEN.VC20_TABLE_TYPE;
L_MODIFY_FLAG             UNAPIGEN.NUM_TABLE_TYPE;
L_NR_OF_ROWS              NUMBER;
L_ERRM                    VARCHAR2(255);
L_REF_DATE                TIMESTAMP WITH TIME ZONE;
L_SEQ                     NUMBER(5);
L_FILTER_FREQ             CHAR(1);
L_LOG_HS_SC               CHAR(1);
L_LOG_HS_DETAILS_SC       CHAR(1);
L_HS_DETAILS_SEQ_NR       INTEGER;
L_SUPPLIER_PP_KEY         VARCHAR2(20);
L_CUSTOMER_PP_KEY         VARCHAR2(20);
L_PGDETAILS_HANDLED       BOOLEAN_TABLE_TYPE;

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   
   
   
   
   
   
   
   IF NVL(A_SC, ' ') = ' ' OR
      NVL(A_ST, ' ') = ' ' OR
      A_SEQ IS NULL        OR
      NVL(A_PP, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;


   
   A_ST_VERSION := UNAPIGEN.VALIDATEVERSION('st', A_ST, A_ST_VERSION);
   A_PP_VERSION := UNAPIGEN.VALIDATEPPVERSION(A_PP, A_PP_VERSION, A_PP_KEY1, A_PP_KEY2, A_PP_KEY3, A_PP_KEY4, A_PP_KEY5);

   
   
   
   
   L_FILTER_FREQ := '0';
   L_REF_DATE := NULL;
   L_ERRM := NULL;
   
   
   
   
   L_NR_OF_ROWS := 0;
   L_RET_CODE := UNAPIPG.INITSCPARAMETERGROUP(A_PP, A_PP_VERSION, A_PP_KEY1, A_PP_KEY2,
                    A_PP_KEY3, A_PP_KEY4, A_PP_KEY5, A_SEQ, A_SC,
                    L_PP_VERSION, L_DESCRIPTION, L_VALUE_F, L_VALUE_S, L_UNIT,
                    L_EXEC_START_DATE, L_EXEC_END_DATE, L_EXECUTOR, L_PLANNED_EXECUTOR,
                    L_MANUALLY_ENTERED, L_ASSIGN_DATE, L_ASSIGNED_BY, L_MANUALLY_ADDED, 
                    L_FORMAT, L_CONFIRM_ASSIGN, L_ALLOW_ANY_PR, L_NEVER_CREATE_METHODS,
                    L_DELAY, L_DELAY_UNIT, L_REANALYSIS, L_PG_CLASS, L_LOG_HS, 
                    L_LOG_HS_DETAILS, L_LC, L_LC_VERSION, L_NR_OF_ROWS);
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      L_ERRM  := 'pp=' || A_PP || '#pp_version=' || A_PP_VERSION || '#seq=' || TO_CHAR(A_SEQ) ||
                 '#sc=' || A_SC || '#filter_freq=' || L_FILTER_FREQ ||
                 '#ref_date=' || L_REF_DATE ||
                 '#nr_of_rows=' || L_NR_OF_ROWS ||
                 '#InitScParameterGroup#ErrorCode=' || TO_CHAR(L_RET_CODE);
      RAISE STPERROR;
   END IF;

   
   
   
   FOR L_ROW IN 1..L_NR_OF_ROWS LOOP
      L_SC(L_ROW) := A_SC;
      L_PG(L_ROW) := A_PP;
      L_PGNODE(L_ROW) := 0;
      L_MODIFY_FLAG(L_ROW) := UNAPIGEN.MOD_FLAG_INSERT;
      L_MANUALLY_ADDED(L_ROW) := '1';
      L_PP_KEY1(L_ROW) := A_PP_KEY1;
      L_PP_KEY2(L_ROW) := A_PP_KEY2;
      L_PP_KEY3(L_ROW) := A_PP_KEY3;
      L_PP_KEY4(L_ROW) := A_PP_KEY4;
      L_PP_KEY5(L_ROW) := A_PP_KEY5;      
      
      
      
      L_DELAY(L_ROW) := NVL(L_DELAY(L_ROW), 0);
      L_DELAY_UNIT(L_ROW) := NVL(L_DELAY_UNIT(L_ROW), 'DD');
   END LOOP;

   
   
   
      IF L_NR_OF_ROWS > 0 THEN
      L_RET_CODE := UNAPIPG.SAVESCPARAMETERGROUP(L_SC, L_PG, L_PGNODE, 
                       L_PP_VERSION, L_PP_KEY1, L_PP_KEY2,
                       L_PP_KEY3, L_PP_KEY4, L_PP_KEY5,
                       L_DESCRIPTION, L_VALUE_F, L_VALUE_S, L_UNIT,
                       L_EXEC_START_DATE, L_EXEC_END_DATE, L_EXECUTOR, 
                       L_PLANNED_EXECUTOR, L_MANUALLY_ENTERED, L_ASSIGN_DATE,
                       L_ASSIGNED_BY, L_MANUALLY_ADDED, L_FORMAT, L_CONFIRM_ASSIGN, 
                       L_ALLOW_ANY_PR, L_NEVER_CREATE_METHODS, L_DELAY, 
                       L_DELAY_UNIT, L_PG_CLASS, L_LOG_HS, L_LOG_HS_DETAILS,
                       L_LC, L_LC_VERSION, L_MODIFY_FLAG, L_NR_OF_ROWS,
                       A_MODIFY_REASON);
      IF L_RET_CODE = UNAPIGEN.DBERR_PARTIALSAVE THEN
         
         
         
         FOR L_ROW IN 1..L_NR_OF_ROWS LOOP
            IF L_MODIFY_FLAG(L_ROW) > UNAPIGEN.DBERR_SUCCESS THEN
               UNAPIGEN.P_TXN_ERROR := L_MODIFY_FLAG(L_ROW);
               L_ERRM  := 'sc=' || A_SC || '#pg=' || L_PG(L_ROW) ||
                          '#pgnode=' || TO_CHAR(L_PGNODE(L_ROW))||
                          '#SaveScParameterGroup#ErrorCode=' || TO_CHAR(L_RET_CODE);
               RAISE STPERROR;
            END IF;
         END LOOP;
      ELSIF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
         RAISE STPERROR;
      END IF;
   END IF;

   
   
   
   
   
   FOR L_ROW IN 1..L_NR_OF_ROWS LOOP

      L_PGDETAILS_HANDLED(L_ROW) := FALSE;
      L_RET_CODE := UNAPIPG.GETSUPPLIERANDCUSTOMER(L_PP_KEY1(L_ROW), L_PP_KEY2(L_ROW), L_PP_KEY3(L_ROW),
                                                   L_PP_KEY4(L_ROW), L_PP_KEY5(L_ROW), 
                                                   L_SUPPLIER_PP_KEY, L_CUSTOMER_PP_KEY);
      
      IF L_SUPPLIER_PP_KEY = ' ' AND
         L_CUSTOMER_PP_KEY = ' ' THEN
                  
         L_PGDETAILS_HANDLED(L_ROW) := TRUE;
   
         L_RET_CODE := UNAPIPGP.INITANDSAVESCPGATTRIBUTES(A_SC, L_PG(L_ROW), L_PGNODE(L_ROW));
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            L_ERRM  := 'sc=' || A_SC || '#pg=' || L_PG(L_ROW) ||
                       '#pgnode=' || TO_CHAR(L_PGNODE(L_ROW)) ||
                       '#InitAndSaveScPgAttributes#ErrorCode=' || TO_CHAR(L_RET_CODE);
            RAISE STPERROR;
         END IF;

         
         
         
         L_RET_CODE := UNAPIPG.CREATESCPGDETAILS(A_ST, A_ST_VERSION, L_PG(L_ROW), L_PP_VERSION(L_ROW),
                                                 L_PP_KEY1(L_ROW), L_PP_KEY2(L_ROW),
                                                 L_PP_KEY3(L_ROW), L_PP_KEY4(L_ROW), L_PP_KEY5(L_ROW),
                                                 L_SEQ, A_SC, L_PGNODE(L_ROW),
                                                 '1',
                                                 L_REF_DATE, A_MODIFY_REASON);

         
         
         
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            L_ERRM  := 'st=' || A_ST || '#st_version=' || A_ST_VERSION ||
                       'sc=' || A_SC || '#pg=' || L_PG(L_ROW) ||
                       '#pgnode=' || TO_CHAR(L_PGNODE(L_ROW))||
                       '#CreateScPgDetails#ErrorCode=' || TO_CHAR(L_RET_CODE);
             UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
             RAISE STPERROR;
         END IF;
      END IF;
   END LOOP;

   FOR L_ROW IN 1..L_NR_OF_ROWS LOOP

      
      IF L_PGDETAILS_HANDLED(L_ROW) = FALSE THEN                     
         L_RET_CODE := UNAPIPGP.INITANDSAVESCPGATTRIBUTES(A_SC, L_PG(L_ROW), L_PGNODE(L_ROW));
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            L_ERRM  := 'sc=' || A_SC || '#pg=' || L_PG(L_ROW) ||
                       '#pgnode=' || TO_CHAR(L_PGNODE(L_ROW)) ||
                       '#InitAndSaveScPgAttributes#ErrorCode=' || TO_CHAR(L_RET_CODE);
            RAISE STPERROR;
         END IF;

         
         
         
         L_RET_CODE := UNAPIPG.CREATESCPGDETAILS(A_ST, A_ST_VERSION, L_PG(L_ROW), L_PP_VERSION(L_ROW),
                                                 L_PP_KEY1(L_ROW), L_PP_KEY2(L_ROW),
                                                 L_PP_KEY3(L_ROW), L_PP_KEY4(L_ROW), L_PP_KEY5(L_ROW),
                                                 L_SEQ, A_SC, L_PGNODE(L_ROW),
                                                 '1',
                                                 L_REF_DATE, A_MODIFY_REASON);

         
         
         
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            L_ERRM  := 'st=' || A_ST || '#st_version=' || A_ST_VERSION ||
                       'sc=' || A_SC || '#pg=' || L_PG(L_ROW) ||
                       '#pgnode=' || TO_CHAR(L_PGNODE(L_ROW))||
                       '#CreateScPgDetails#ErrorCode=' || TO_CHAR(L_RET_CODE);
             UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
             RAISE STPERROR;
         END IF;
      END IF;
   END LOOP;

   
   
   
   L_EV_SEQ_NR := -1;
   L_EVENT_TP := 'ScAnalysesCreated';
   L_EV_DETAILS :=  'st=' || A_ST || 
                    '#st_version=' || A_ST_VERSION ||
                    '#pg=' ||A_PP ;

   L_RESULT := UNAPIEV.INSERTEVENT('AddScAnalysesDetails', UNAPIGEN.P_EVMGR_NAME, 'sc', A_SC, '', '', 
                                   '', L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;

   BEGIN
      SELECT LOG_HS, LOG_HS_DETAILS
      INTO L_LOG_HS_SC, L_LOG_HS_DETAILS_SC
      FROM UTSC
      WHERE SC = A_SC;
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      RAISE STPERROR;
   END;

   IF NVL(L_LOG_HS_SC, ' ') = '1' THEN
      INSERT INTO UTSCHS (SC, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, 
                          LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
      VALUES (A_SC, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
              'sample "'||A_SC||'" analysis details are created.', 
              CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
   END IF;

   L_HS_DETAILS_SEQ_NR := 0;
   IF NVL(L_LOG_HS_DETAILS_SC, ' ') = '1' THEN
      L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
      INSERT INTO UTSCHSDETAILS(SC, TR_SEQ, EV_SEQ, SEQ, DETAILS)
      VALUES (A_SC, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR, 
              'sample "'||A_SC||'" analysis details are created.');
   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('AddScAnalysesDetails', SQLERRM);
   ELSIF L_ERRM IS NOT NULL THEN
      UNAPIGEN.LOGERROR('AddScAnalysesDetails', L_ERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'AddScAnalysesDetails'));
END ADDSCANALYSESDETAILS;

FUNCTION COPYSCANALYSESDETAILS
(A_SC_FROM             IN        VARCHAR2,             
 A_ST_TO               IN        VARCHAR2,             
 A_ST_TO_VERSION       IN OUT    VARCHAR2,              
 A_SC_TO               IN        VARCHAR2,             
 A_COPY_PARAMETERS     IN        CHAR,                 
 A_COPY_METHODS        IN        CHAR,                 
 A_MODIFY_REASON       IN        VARCHAR2)             
RETURN NUMBER IS

BEGIN

   RETURN(UNAPISC2.COPYSCANALYSESDETAILS(A_SC_FROM, A_ST_TO, A_ST_TO_VERSION, A_SC_TO, A_COPY_PARAMETERS, A_COPY_METHODS, A_MODIFY_REASON));

END COPYSCANALYSESDETAILS;

FUNCTION CHANGESCSAMPLETYPE
(A_SC               IN     VARCHAR2,                   
 A_ST               IN     VARCHAR2,                   
 A_ST_VERSION       IN OUT VARCHAR2,                   
 A_MODIFY_REASON    IN     VARCHAR2)                   
RETURN NUMBER IS


BEGIN

   RETURN(UNAPISC2.CHANGESCSAMPLETYPE(A_SC, A_ST, A_ST_VERSION, A_MODIFY_REASON));

END CHANGESCSAMPLETYPE;

FUNCTION COPYSAMPLE                  
(A_SC_FROM         IN     VARCHAR2,  
 A_ST_TO           IN     VARCHAR2,  
 A_ST_TO_VERSION   IN OUT VARCHAR2,   
 A_SC_TO           IN OUT VARCHAR2,  
 A_REF_DATE        IN     DATE,      
 A_COPY_IC         IN     VARCHAR2,  
 A_COPY_PG         IN     VARCHAR2,  
 A_USERID          IN     VARCHAR2,  
 A_MODIFY_REASON   IN     VARCHAR2)  
RETURN NUMBER IS

BEGIN

   RETURN(UNAPISC2.COPYSAMPLE(A_SC_FROM, A_ST_TO, A_ST_TO_VERSION, A_SC_TO, A_REF_DATE,
                              A_COPY_IC, A_COPY_PG, A_USERID, A_MODIFY_REASON));

END COPYSAMPLE;




BEGIN
   NULL;
END UNAPISC;
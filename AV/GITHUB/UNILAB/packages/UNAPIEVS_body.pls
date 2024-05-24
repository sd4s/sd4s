PACKAGE BODY unapievs AS

L_SQLERRM         VARCHAR2(255);
L_SQL_STRING      VARCHAR2(10000);
L_EVENT_TP        UTEV.EV_TP%TYPE;
L_TIMED_EVENT_TP  UTEV.EV_TP%TYPE;
L_RET_CODE        NUMBER;
L_RESULT          NUMBER;
L_FETCHED_ROWS    NUMBER;
L_EV_SEQ_NR       NUMBER;
L_EV_DETAILS      VARCHAR2(255);
STPERROR          EXCEPTION;

L_EV_CURSOR       INTEGER;

FUNCTION GETVERSION
   RETURN VARCHAR2
IS
BEGIN
   RETURN('06.07.00.00_00.13');
EXCEPTION
   WHEN OTHERS THEN
      RETURN (NULL);
END GETVERSION;

FUNCTION REGISTEREVENTSERVICE
(A_EVSERVICE_NAME        IN     VARCHAR2)   
RETURN NUMBER IS
BEGIN
   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_EVSERVICE_NAME, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   INSERT INTO UTEVSERVICES (EVSERVICE_NAME, CREATED_ON, CREATED_ON_TZ)
   VALUES (A_EVSERVICE_NAME, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

   
   L_EV_SEQ_NR := -1;
   L_EVENT_TP := 'EventServicesUpdated';
   L_RESULT := UNAPIEV.BROADCASTEVENT ('RegisterEventService', UNAPIGEN.P_EVMGR_NAME, '', '', '', 
                                       '', '', L_EVENT_TP, '', L_EV_SEQ_NR);
   IF L_RESULT <> 0 THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;
   
   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
WHEN DUP_VAL_ON_INDEX THEN
   RETURN(UNAPIGEN.DBERR_SUCCESS);
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('RegisterEventService', SQLERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'RegisterEventService'));
END REGISTEREVENTSERVICE;



FUNCTION UNREGISTEREVENTSERVICE
(A_EVSERVICE_NAME        IN     VARCHAR2)   
RETURN NUMBER IS
BEGIN
   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_EVSERVICE_NAME, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   DELETE FROM UTEVSERVICES 
   WHERE EVSERVICE_NAME = A_EVSERVICE_NAME;

   
   L_EV_SEQ_NR := -1;
   L_EVENT_TP := 'EventServicesUpdated';
   L_RESULT := UNAPIEV.BROADCASTEVENT ('UnRegisterEventService', UNAPIGEN.P_EVMGR_NAME, '', '', '', 
                                       '', '', L_EVENT_TP, '', L_EV_SEQ_NR);
   IF L_RESULT <> 0 THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;
   
   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('UnRegisterEventService', SQLERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'UnRegisterEventService'));
END UNREGISTEREVENTSERVICE;



FUNCTION LOADEVENTSERVICELIST
RETURN NUMBER IS

CURSOR C_EVSERVICES IS
   SELECT *
     FROM UTEVSERVICES
   ORDER BY EVSERVICE_NAME;

BEGIN
   UNAPIEVS.P_NR_OF_SERVICES := 0;
   FOR L_REC IN C_EVSERVICES LOOP
      UNAPIEVS.P_NR_OF_SERVICES := UNAPIEVS.P_NR_OF_SERVICES + 1;
      UNAPIEVS.P_EVSERVICE(UNAPIEVS.P_NR_OF_SERVICES) := L_REC.EVSERVICE_NAME;
   END LOOP;

   LI_SERVICES_LOADED := '1';

   RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
WHEN OTHERS THEN
   L_SQLERRM := SUBSTR(SQLERRM,1,255);
   UNAPIGEN.U4ROLLBACK;
   INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
   VALUES(UNAPIEV.P_EV_REC.CLIENT_ID, UNAPIEV.P_EV_REC.APPLIC, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
          'LoadEventServiceList', L_SQLERRM);
   IF C_EVSERVICES%ISOPEN THEN
      CLOSE C_EVSERVICES;
   END IF;
   UNAPIGEN.U4COMMIT;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END LOADEVENTSERVICELIST;



FUNCTION GETEVENTS
(A_EVSERVICE_NAME            IN     VARCHAR2,                     
 A_TR_SEQ_TAB                OUT    UNAPIGEN.NUM_TABLE_TYPE,     
 A_EV_SEQ_TAB                OUT    UNAPIGEN.NUM_TABLE_TYPE,     
 A_CREATED_ON_TAB            OUT    UNAPIGEN.DATE_TABLE_TYPE,    
 A_CLIENT_ID_TAB             OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_APPLIC_TAB                OUT    UNAPIGEN.VC8_TABLE_TYPE,      
 A_DBAPI_NAME_TAB            OUT    UNAPIGEN.VC40_TABLE_TYPE,     
 A_OBJECT_TP_TAB             OUT    UNAPIGEN.VC4_TABLE_TYPE,      
 A_OBJECT_ID_TAB             OUT    UNAPIGEN.VC20_TABLE_TYPE,     
 A_OBJECT_LC_TAB             OUT    UNAPIGEN.VC2_TABLE_TYPE,      
 A_OBJECT_LC_VERSION_TAB     OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_OBJECT_SS_TAB             OUT    UNAPIGEN.VC2_TABLE_TYPE,      
 A_EV_TP_TAB                 OUT    UNAPIGEN.VC60_TABLE_TYPE,     
 A_USERNAME_TAB              OUT    UNAPIGEN.VC30_TABLE_TYPE,     
 A_EV_DETAILS_TAB            OUT    UNAPIGEN.VC255_TABLE_TYPE,    
 A_NR_OF_ROWS                IN OUT  NUMBER)                     
RETURN NUMBER IS

L_TR_SEQ            NUMBER;
L_EV_SEQ            NUMBER;
L_CREATED_ON        TIMESTAMP WITH TIME ZONE;
L_CLIENT_ID         VARCHAR2(20);
L_APPLIC            VARCHAR2(8);
L_DBAPI_NAME        VARCHAR2(40);
L_OBJECT_TP         VARCHAR2(4);
L_OBJECT_ID         VARCHAR2(20);
L_OBJECT_LC         VARCHAR2(2);
L_OBJECT_LC_VERSION VARCHAR2(20);
L_OBJECT_SS         VARCHAR2(2);
L_EV_TP             VARCHAR2(60);
L_USERNAME          VARCHAR2(30);
L_EV_DETAILS        VARCHAR2(255);

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_NR_OF_ROWS,0) = 0 THEN
      A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
   ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NROFROWS;
      RAISE STPERROR;
   END IF;

   IF NVL(A_EVSERVICE_NAME, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;
   
   
   UPDATE UTEVSINK A
      SET HANDLED_OK='1' 
    WHERE A.EVSERVICE_NAME = A_EVSERVICE_NAME
      AND A_NR_OF_ROWS > (SELECT COUNT(*)
                            FROM UTEVSINK B
                           WHERE A.EVSERVICE_NAME = B.EVSERVICE_NAME
                             AND A.TR_SEQ >= B.TR_SEQ 
                             AND A.EV_SEQ > B.EV_SEQ);

   IF NOT DBMS_SQL.IS_OPEN(L_EV_CURSOR) THEN
      L_EV_CURSOR := DBMS_SQL.OPEN_CURSOR;
      L_SQL_STRING := 'SELECT tr_seq, ev_seq, created_on, client_id, applic, dbapi_name, ' ||
                      'object_tp, object_id, object_lc, object_lc_version, object_ss, ' ||
                      'ev_tp, username, ev_details ' ||
                      'FROM utevsink WHERE evservice_name=''' || A_EVSERVICE_NAME ||   
                      ''' AND handled_ok = ''1''';   
      DBMS_SQL.PARSE(L_EV_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
      DBMS_SQL.DEFINE_COLUMN(L_EV_CURSOR, 1,  L_TR_SEQ);
      DBMS_SQL.DEFINE_COLUMN(L_EV_CURSOR, 2,  L_EV_SEQ);
      DBMS_SQL.DEFINE_COLUMN(L_EV_CURSOR, 3,  L_CREATED_ON);
      DBMS_SQL.DEFINE_COLUMN(L_EV_CURSOR, 4,  L_CLIENT_ID, 20);
      DBMS_SQL.DEFINE_COLUMN(L_EV_CURSOR, 5,  L_APPLIC, 8);
      DBMS_SQL.DEFINE_COLUMN(L_EV_CURSOR, 6,  L_DBAPI_NAME, 40);
      DBMS_SQL.DEFINE_COLUMN(L_EV_CURSOR, 7,  L_OBJECT_TP, 4);
      DBMS_SQL.DEFINE_COLUMN(L_EV_CURSOR, 8,  L_OBJECT_ID, 20);
      DBMS_SQL.DEFINE_COLUMN(L_EV_CURSOR, 9,  L_OBJECT_LC, 2);
      DBMS_SQL.DEFINE_COLUMN(L_EV_CURSOR, 10, L_OBJECT_LC_VERSION, 20);
      DBMS_SQL.DEFINE_COLUMN(L_EV_CURSOR, 11, L_OBJECT_SS, 2);
      DBMS_SQL.DEFINE_COLUMN(L_EV_CURSOR, 12, L_EV_TP, 60);
      DBMS_SQL.DEFINE_COLUMN(L_EV_CURSOR, 13, L_USERNAME, 30);
      DBMS_SQL.DEFINE_COLUMN(L_EV_CURSOR, 14, L_EV_DETAILS, 255);
      L_RESULT := DBMS_SQL.EXECUTE(L_EV_CURSOR);
   END IF;

   L_RESULT := DBMS_SQL.FETCH_ROWS(L_EV_CURSOR);
   L_FETCHED_ROWS := 0;

   LOOP
      EXIT WHEN L_RESULT = 0 OR L_FETCHED_ROWS >= A_NR_OF_ROWS;
      DBMS_SQL.COLUMN_VALUE(L_EV_CURSOR, 1,  L_TR_SEQ);
      DBMS_SQL.COLUMN_VALUE(L_EV_CURSOR, 2,  L_EV_SEQ);
      DBMS_SQL.COLUMN_VALUE(L_EV_CURSOR, 3,  L_CREATED_ON);
      DBMS_SQL.COLUMN_VALUE(L_EV_CURSOR, 4,  L_CLIENT_ID);
      DBMS_SQL.COLUMN_VALUE(L_EV_CURSOR, 5,  L_APPLIC);
      DBMS_SQL.COLUMN_VALUE(L_EV_CURSOR, 6,  L_DBAPI_NAME);
      DBMS_SQL.COLUMN_VALUE(L_EV_CURSOR, 7,  L_OBJECT_TP);
      DBMS_SQL.COLUMN_VALUE(L_EV_CURSOR, 8,  L_OBJECT_ID);
      DBMS_SQL.COLUMN_VALUE(L_EV_CURSOR, 9,  L_OBJECT_LC);
      DBMS_SQL.COLUMN_VALUE(L_EV_CURSOR, 10, L_OBJECT_LC_VERSION);
      DBMS_SQL.COLUMN_VALUE(L_EV_CURSOR, 11, L_OBJECT_SS);
      DBMS_SQL.COLUMN_VALUE(L_EV_CURSOR, 12, L_EV_TP);
      DBMS_SQL.COLUMN_VALUE(L_EV_CURSOR, 13, L_USERNAME);
      DBMS_SQL.COLUMN_VALUE(L_EV_CURSOR, 14, L_EV_DETAILS);

      L_FETCHED_ROWS := L_FETCHED_ROWS + 1;

      A_TR_SEQ_TAB(L_FETCHED_ROWS) := L_TR_SEQ;
      A_EV_SEQ_TAB(L_FETCHED_ROWS) := L_EV_SEQ;
      A_CREATED_ON_TAB(L_FETCHED_ROWS) := L_CREATED_ON;
      A_CLIENT_ID_TAB(L_FETCHED_ROWS) := L_CLIENT_ID;
      A_APPLIC_TAB(L_FETCHED_ROWS) := L_APPLIC;
      A_DBAPI_NAME_TAB(L_FETCHED_ROWS) := L_DBAPI_NAME;
      A_OBJECT_TP_TAB(L_FETCHED_ROWS) := L_OBJECT_TP;
      A_OBJECT_ID_TAB(L_FETCHED_ROWS) := L_OBJECT_ID;
      A_OBJECT_LC_TAB(L_FETCHED_ROWS) := L_OBJECT_LC;
      A_OBJECT_LC_VERSION_TAB(L_FETCHED_ROWS) := L_OBJECT_LC_VERSION;
      A_OBJECT_SS_TAB(L_FETCHED_ROWS) := L_OBJECT_SS;
      A_EV_TP_TAB(L_FETCHED_ROWS) := L_EV_TP;
      A_USERNAME_TAB(L_FETCHED_ROWS) := L_USERNAME;
      A_EV_DETAILS_TAB(L_FETCHED_ROWS) := L_EV_DETAILS;

      IF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
         L_RESULT := DBMS_SQL.FETCH_ROWS(L_EV_CURSOR);
      END IF;
   END LOOP;

   IF L_FETCHED_ROWS = 0 THEN
      L_RET_CODE := UNAPIGEN.DBERR_NORECORDS;
      DBMS_SQL.CLOSE_CURSOR(L_EV_CURSOR);
   ELSIF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
      L_RET_CODE := UNAPIGEN.DBERR_SUCCESS;
      A_NR_OF_ROWS := L_FETCHED_ROWS;
      DBMS_SQL.CLOSE_CURSOR(L_EV_CURSOR);
   ELSE   
      L_RET_CODE := UNAPIGEN.DBERR_SUCCESS;
      A_NR_OF_ROWS := L_FETCHED_ROWS;
   END IF;

   IF DBMS_SQL.IS_OPEN(L_EV_CURSOR) THEN
      DBMS_SQL.CLOSE_CURSOR(L_EV_CURSOR);
   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(L_RET_CODE);
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('GetEvents', SQLERRM);
   ELSIF L_SQLERRM IS NOT NULL THEN
      UNAPIGEN.LOGERROR('GetEvents', L_SQLERRM);
   END IF;
   IF DBMS_SQL.IS_OPEN(L_EV_CURSOR) THEN
      DBMS_SQL.CLOSE_CURSOR(L_EV_CURSOR);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'GetEvents'));
END GETEVENTS;



FUNCTION DELETEHANDLEDEVENTS
(A_EVSERVICE_NAME            IN     VARCHAR2)                    
RETURN NUMBER IS
BEGIN
   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_EVSERVICE_NAME, ' ')= ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   DELETE FROM UTEVSINK
   WHERE EVSERVICE_NAME = A_EVSERVICE_NAME
   AND HANDLED_OK = '1';

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('DeleteHandledEvents', SQLERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'DeleteHandledEvents'));
END DELETEHANDLEDEVENTS;

BEGIN
   LI_SERVICES_LOADED := '0';
END UNAPIEVS;
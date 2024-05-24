PACKAGE BODY unapiev AS

L_SQLERRM         VARCHAR2(255);
L_SQL_STRING      VARCHAR2(2000);
L_WHERE_CLAUSE    VARCHAR2(1000);
L_EVENT_TP        UTEV.EV_TP%TYPE;
L_TIMED_EVENT_TP  UTEV.EV_TP%TYPE;
L_RET_CODE        NUMBER;
L_RESULT          NUMBER;
L_FETCHED_ROWS    NUMBER;
L_EV_SEQ_NR       NUMBER;
L_EV_DETAILS      VARCHAR2(2000);
STPERROR          EXCEPTION;
L_ERRM            VARCHAR2(255);


L_EVR_NR_OF_ROWS          INTEGER;
L_EVR_APPLIC              UNAPIGEN.VC8_TABLE_TYPE;
L_EVR_DBAPI_NAME          UNAPIGEN.VC40_TABLE_TYPE;
L_EVR_OBJECT_TP           UNAPIGEN.VC4_TABLE_TYPE;
L_EVR_OBJECT_ID           UNAPIGEN.VC20_TABLE_TYPE;
L_EVR_OBJECT_LC           UNAPIGEN.VC2_TABLE_TYPE;
L_EVR_OBJECT_LC_VERSION   UNAPIGEN.VC20_TABLE_TYPE;
L_EVR_OBJECT_SS           UNAPIGEN.VC2_TABLE_TYPE;
L_EVR_EV_TP               UNAPIGEN.VC60_TABLE_TYPE;
L_EVR_CONDITION           UNAPIGEN.VC255_TABLE_TYPE;
L_EVR_AF                  UNAPIGEN.VC255_TABLE_TYPE;
L_EVR_AF_DELAY            UNAPIGEN.NUM_TABLE_TYPE;
L_EVR_AF_DELAY_UNIT       UNAPIGEN.VC20_TABLE_TYPE;

CURSOR P_EV_CURSOR(A_EVMGR_NAME VARCHAR2) IS
   SELECT EV_SEQ, CREATED_ON, OBJECT_TP, OBJECT_ID, OBJECT_LC,
          OBJECT_SS, EV_TP, EV_DETAILS
   FROM UTEV
   WHERE NVL(EVMGR_NAME, ' ') = NVL(A_EVMGR_NAME , ' ')
   ORDER BY EV_SEQ, CREATED_ON;

CURSOR C_SYSTEM (A_SETTING_NAME VARCHAR2) IS
   SELECT SETTING_VALUE
   FROM UTSYSTEM
   WHERE SETTING_NAME = A_SETTING_NAME;



PROCEDURE SAVEPOINT_UNILAB4 IS
BEGIN
   IF UNAPIEV.P_EVMGRS_EV_IN_BULK = '1' THEN
      UNAPIGEN.U4SAVEPOINT('unilab4');
   ELSE
      SAVEPOINT UNILAB4;
   END IF;
END SAVEPOINT_UNILAB4;







FUNCTION GETVERSION
   RETURN VARCHAR2
IS
BEGIN
   RETURN('06.07.00.00_00.13');
EXCEPTION
   WHEN OTHERS THEN
      RETURN (NULL);
END GETVERSION;

PROCEDURE INTERNALSTOPALLMANAGERS IS

L_JOB VARCHAR2(30); 

BEGIN

   
   
   UNAPIEV.P_STOPEVMGR := TRUE;
   
   
   
   
   L_EV_SEQ_NR := -1;
   L_EVENT_TP := 'STOP';
   L_RESULT := BROADCASTEVENT ('EventMgr',
                               UNAPIGEN.P_EVMGR_NAME, 'xx',
                               '', '', '', '', L_EVENT_TP, 'version=0', L_EV_SEQ_NR);
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
      INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
      VALUES(UNAPIEV.P_EV_REC.CLIENT_ID, UNAPIEV.P_EV_REC.APPLIC, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
             'InternalStopAllManagers', 'BroadcastEvent#return=' || TO_CHAR(L_RESULT));
      UNAPIGEN.U4COMMIT;
   END IF;
   
   
   
   IF UNAPIEV.P_EVMGRS_1QBYINSTANCE = '0' THEN
      DELETE FROM UTEV
      WHERE EV_TP='STOP'
      AND TR_SEQ = -TO_NUMBER(L_EV_SESSION)
      AND EVMGR_NAME = UNAPIGEN.P_EVMGR_NAME;
   ELSE
      EXECUTE IMMEDIATE
         'DELETE FROM utev'||UNAPIGEN.P_INSTANCENR||' WHERE ev_tp=''STOP'' AND tr_seq = -TO_NUMBER(:a_ev_session) AND evmgr_name = :a_evmgr_name'
      USING L_EV_SESSION,UNAPIGEN.P_EVMGR_NAME;
   END IF;   

   
   
   BEGIN
      SELECT JOB_NAME
      INTO L_JOB
      FROM SYS.DBA_SCHEDULER_JOBS
      WHERE INSTR(JOB_ACTION, 'UNAPIEV.EVENTMANAGERJOB('''||UNAPIGEN.P_EVMGR_NAME||''','||L_EV_SESSION)<>0;

      DBMS_SCHEDULER.DROP_JOB(L_JOB);
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
      
      NULL;
   END;
   UNAPIGEN.U4COMMIT;
   
   
   L_RESULT := STOPALLMGRS;
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
      INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
      VALUES(UNAPIEV.P_EV_REC.CLIENT_ID, UNAPIEV.P_EV_REC.APPLIC, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
             'InternalStopAllManagers', 'StopAllMgrs#return=' || TO_CHAR(L_RESULT));
      UNAPIGEN.U4COMMIT;
   END IF;
   UNAPIGEN.U4COMMIT;
END INTERNALSTOPALLMANAGERS;


FUNCTION ALERTREGISTER                                     
(A_ALERT_NAME          IN       VARCHAR2)                  
RETURN NUMBER IS

BEGIN

   
   
   
   IF NVL(A_ALERT_NAME, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;
   
   
   
   
   RETURN(UNAPIGEN.DBERR_SUCCESS);
   
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      L_SQLERRM := SUBSTR(SQLERRM,1,255);
   END IF;
   INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
          'AlertRegister', L_SQLERRM);
   UNAPIGEN.U4COMMIT;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END ALERTREGISTER;

FUNCTION ALERTREMOVE                                     
(A_ALERT_NAME          IN       VARCHAR2)                  
RETURN NUMBER IS

BEGIN

   
   
   
   IF NVL(A_ALERT_NAME, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;
   
   
   
   
   RETURN(UNAPIGEN.DBERR_SUCCESS);
   
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      L_SQLERRM := SUBSTR(SQLERRM,1,255);
   END IF;
   INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
          'AlertRemove', L_SQLERRM);
   UNAPIGEN.U4COMMIT;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END ALERTREMOVE;

FUNCTION ALERTDELETE                                     
(A_ALERT_NAME          IN       VARCHAR2,                  
 A_ALERT_DATA          IN       VARCHAR2)                  
RETURN NUMBER IS

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_ALERT_NAME, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;
   
   DELETE FROM UTCLIENTALERTS
   WHERE ALERT_NAME = A_ALERT_NAME
   AND NVL(ALERT_DATA, '*') = NVL(A_ALERT_DATA, '*');

   
   
   
   
   
   
   
   IF SQL%ROWCOUNT = 0 THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      RAISE STPERROR;
   END IF;
   
   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;
   RETURN(UNAPIGEN.DBERR_SUCCESS);
   
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      L_SQLERRM := SUBSTR(SQLERRM,1,255);
      UNAPIGEN.LOGERROR('AlertDelete', L_SQLERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'AlertDelete'));
END ALERTDELETE;

FUNCTION ALERTSEND                                     
(A_ALERT_NAME          IN       VARCHAR2,                  
 A_ALERT_DATA          IN       VARCHAR2)                  
RETURN NUMBER IS

CURSOR L_SEQ_ALERT_CURSOR IS
   SELECT SEQ_ALERT_NR.NEXTVAL FROM DUAL;
L_SEQ_ALERT_NR       INTEGER;

BEGIN

   
   
   

   IF NVL(A_ALERT_NAME, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   
   
   OPEN L_SEQ_ALERT_CURSOR;
   FETCH L_SEQ_ALERT_CURSOR INTO L_SEQ_ALERT_NR;
   CLOSE L_SEQ_ALERT_CURSOR;
   
   INSERT INTO UTCLIENTALERTS
   (ALERT_SEQ, ALERT_NAME, ALERT_DATA)
   VALUES
   (L_SEQ_ALERT_NR, A_ALERT_NAME, A_ALERT_DATA);
   
   
   
   UNAPIGEN.U4COMMIT;
   RETURN(UNAPIGEN.DBERR_SUCCESS);
   
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      L_SQLERRM := SUBSTR(SQLERRM,1,255);
   END IF;
   INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
          'AlertSend', L_SQLERRM);
   UNAPIGEN.U4COMMIT;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END ALERTSEND;

FUNCTION PRINTSCLABEL                                     
(A_SC                  IN       VARCHAR2,                  
 A_PRINTER             IN       VARCHAR2,                  
 A_LABEL_FORMAT        IN       VARCHAR2,                  
 A_NR_OF_LABELS        IN       NUMBER)                    
RETURN NUMBER IS
   
CURSOR L_SCLABEL_CURSOR (A_SC VARCHAR2) IS
   SELECT LABEL_FORMAT
   FROM UTSC
   WHERE SC = A_SC;   
L_LABEL_FORMAT    UTSC.LABEL_FORMAT%TYPE;

BEGIN
   IF NVL(A_SC, ' ') = ' ' THEN
      RETURN(UNAPIGEN.DBERR_NOOBJID);
   END IF;
   
   IF A_LABEL_FORMAT IS NULL THEN
      OPEN L_SCLABEL_CURSOR(A_SC);
      FETCH L_SCLABEL_CURSOR
      INTO L_LABEL_FORMAT;
      CLOSE L_SCLABEL_CURSOR;
   ELSE
      L_LABEL_FORMAT := A_LABEL_FORMAT;
   END IF;
   
   RETURN(UNAPIEV.ALERTSEND('PrintScLabel', 'sc='            || A_SC ||
                                            '#printer='      || A_PRINTER ||
                                            '#label_format=' || L_LABEL_FORMAT ||
                                            '#nr_of_labels=' || TO_CHAR(A_NR_OF_LABELS)));
EXCEPTION
WHEN OTHERS THEN
   IF L_SCLABEL_CURSOR%ISOPEN THEN
      CLOSE L_SCLABEL_CURSOR;
   END IF;
   RAISE;
END PRINTSCLABEL;

FUNCTION PRINTRQLABEL                                     
(A_RQ                  IN       VARCHAR2,                  
 A_PRINTER             IN       VARCHAR2,                  
 A_LABEL_FORMAT        IN       VARCHAR2,                  
 A_NR_OF_LABELS        IN       NUMBER)                    
RETURN NUMBER IS

CURSOR L_RQLABEL_CURSOR (A_RQ VARCHAR2) IS
   SELECT LABEL_FORMAT
   FROM UTRQ
   WHERE RQ = A_RQ;   
L_LABEL_FORMAT    UTRQ.LABEL_FORMAT%TYPE;
   
BEGIN
   IF NVL(A_RQ, ' ') = ' ' THEN
      RETURN(UNAPIGEN.DBERR_NOOBJID);
   END IF;
   
   IF A_LABEL_FORMAT IS NULL THEN
      OPEN L_RQLABEL_CURSOR(A_RQ);
      FETCH L_RQLABEL_CURSOR
      INTO L_LABEL_FORMAT;
      CLOSE L_RQLABEL_CURSOR;
   ELSE
      L_LABEL_FORMAT := A_LABEL_FORMAT;
   END IF;

   RETURN(UNAPIEV.ALERTSEND('PrintRqLabel', 'rq='            || A_RQ ||
                                            '#printer='      || A_PRINTER ||
                                            '#label_format=' || L_LABEL_FORMAT ||
                                            '#nr_of_labels=' || TO_CHAR(A_NR_OF_LABELS)));
EXCEPTION
WHEN OTHERS THEN
   IF L_RQLABEL_CURSOR%ISOPEN THEN
      CLOSE L_RQLABEL_CURSOR;
   END IF;
   RAISE;
END PRINTRQLABEL;

FUNCTION PRINTSDLABEL                                     
(A_SD                  IN       VARCHAR2,                  
 A_PRINTER             IN       VARCHAR2,                  
 A_LABEL_FORMAT        IN       VARCHAR2,                  
 A_NR_OF_LABELS        IN       NUMBER)                    
RETURN NUMBER IS

CURSOR L_SDLABEL_CURSOR (A_SD VARCHAR2) IS
   SELECT LABEL_FORMAT
   FROM UTSD
   WHERE SD = A_SD;   
L_LABEL_FORMAT    UTSD.LABEL_FORMAT%TYPE;
   
BEGIN
   IF NVL(A_SD, ' ') = ' ' THEN
      RETURN(UNAPIGEN.DBERR_NOOBJID);
   END IF;
   
   IF A_LABEL_FORMAT IS NULL THEN
      OPEN L_SDLABEL_CURSOR(A_SD);
      FETCH L_SDLABEL_CURSOR
      INTO L_LABEL_FORMAT;
      CLOSE L_SDLABEL_CURSOR;
   ELSE
      L_LABEL_FORMAT := A_LABEL_FORMAT;
   END IF;

   RETURN(UNAPIEV.ALERTSEND('PrintSdLabel', 'sd='            || A_SD ||
                                            '#printer='      || A_PRINTER ||
                                            '#label_format=' || L_LABEL_FORMAT ||
                                            '#nr_of_labels=' || TO_CHAR(A_NR_OF_LABELS)));
EXCEPTION
WHEN OTHERS THEN
   IF L_SDLABEL_CURSOR%ISOPEN THEN
      CLOSE L_SDLABEL_CURSOR;
   END IF;
   RAISE;
END PRINTSDLABEL;

FUNCTION ALERTWAITANY                                     
(A_ALERT_NAME          OUT      VARCHAR2,                  
 A_ALERT_DATA          OUT      VARCHAR2,                  
 A_ALERT_STATUS        OUT      NUMBER,                    
 A_ALERT_WAIT_TIME     IN       NUMBER)                    
RETURN NUMBER IS

L_ALERT_NAME               VARCHAR2(20);
L_STATUS                   INTEGER;
L_ALERT_SEQ                NUMBER;
L_ALERT_SEQ_VC             VARCHAR2(200);
L_LAST_ALERT_SEQ           NUMBER;
L_LOCKNAME                 VARCHAR2(30);
L_LOCKHANDLE               VARCHAR2(200);
L_LEAVE_WAITFORALERT_LOOP  BOOLEAN;

   
BEGIN

   
   
   

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   L_LAST_ALERT_SEQ := -1000;
   L_ERRM := '';
   L_STATUS := 0;
   L_ALERT_NAME := '';
   L_LEAVE_WAITFORALERT_LOOP := TRUE;   
   L_ALERT_SEQ_VC  := '';
   L_ALERT_SEQ     := NULL;
   L_LAST_ALERT_SEQ := -10000;
         
   
   
   
   LOOP

      
      
      
      OPEN L_ALERT_SEQ_CURSOR(L_LAST_ALERT_SEQ+1);
      FETCH L_ALERT_SEQ_CURSOR INTO L_ALERT_SEQ;
      IF L_ALERT_SEQ IS NULL THEN
         CLOSE L_ALERT_SEQ_CURSOR;
         L_STATUS := 1; 
         EXIT;
      END IF;
      CLOSE L_ALERT_SEQ_CURSOR;

      L_LAST_ALERT_SEQ := L_ALERT_SEQ;
      L_ALERT_SEQ_VC := TO_CHAR(L_ALERT_SEQ);

      IF L_LAST_ALERT_SEQ >= 0 THEN

         
         
         
         L_LOCKNAME := 'U4ALERT'||L_ALERT_SEQ_VC;
         DBMS_LOCK.ALLOCATE_UNIQUE(L_LOCKNAME, L_LOCKHANDLE, 60);

         
         
         
         
         
         
         
         L_RET_CODE := DBMS_LOCK.REQUEST(L_LOCKHANDLE, DBMS_LOCK.X_MODE, 
                                         0.01, TRUE);
         IF L_RET_CODE = UNAPIGEN.DBERR_SUCCESS THEN

            OPEN L_CLIENT_ALERTS_CURSOR(L_ALERT_SEQ);
            FETCH L_CLIENT_ALERTS_CURSOR
            INTO A_ALERT_NAME, A_ALERT_DATA;
            IF L_CLIENT_ALERTS_CURSOR%NOTFOUND THEN
               
               
               
               
               CLOSE L_CLIENT_ALERTS_CURSOR;
               L_RET_CODE := DBMS_LOCK.RELEASE(L_LOCKHANDLE);
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_ERRM :=  'Major Error : Releasing lock '||L_LOCKNAME||':('||L_LOCKHANDLE||
                             ') returned '||TO_CHAR(L_RET_CODE);
                  RAISE STPERROR;
               END IF;
            ELSE
               
               CLOSE L_CLIENT_ALERTS_CURSOR;
               EXIT;
            END IF;
         ELSE
            IF L_RET_CODE <> 1 THEN
               L_ERRM :=  'Major Error : Requesting lock '||L_LOCKNAME||':('||L_LOCKHANDLE||
                               ') returned '||TO_CHAR(L_RET_CODE);
               RAISE STPERROR;
            ELSE
               
               
               NULL;
            END IF;
         END IF;
      END IF;

   END LOOP;
   
   A_ALERT_STATUS := L_STATUS;
   
   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);
   
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      L_SQLERRM := SUBSTR(SQLERRM,1,255);
      UNAPIGEN.LOGERROR('AlertWaitAny', L_SQLERRM);
   ELSE
      L_SQLERRM := L_ERRM;
      UNAPIGEN.LOGERROR('AlertWaitAny', L_SQLERRM);
   END IF;
   IF L_ALERT_SEQ_CURSOR%ISOPEN THEN
      CLOSE L_ALERT_SEQ_CURSOR;
   END IF;
   IF L_CLIENT_ALERTS_CURSOR%ISOPEN THEN
      CLOSE L_CLIENT_ALERTS_CURSOR;
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'AlertWaitAny'));
END ALERTWAITANY;

FUNCTION DELETEEVENT                                       
(A_EV_SEQ              IN       NUMBER,                    
 A_CREATED_ON          IN       DATE,                      
 A_EVMGR_NAME          IN       VARCHAR2,                  
 A_OBJECT_TP           IN       VARCHAR2,                  
 A_OBJECT_ID           IN       VARCHAR2,                  
 A_OBJECT_LC           IN       VARCHAR2,                  
 A_OBJECT_LC_VERSION   IN       VARCHAR2,                  
 A_OBJECT_SS           IN       VARCHAR2,                  
 A_EV_TP               IN       VARCHAR2)                  
RETURN NUMBER IS

L_EV_SEQ       VARCHAR2(20);

BEGIN

   IF NVL (A_EV_SEQ ,' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   IF UNAPIGEN.P_LOG_EV THEN
      IF UNAPIEV.P_EVMGRS_1QBYINSTANCE = '0' THEN
         BEGIN
         INSERT INTO UTEVLOG
         (TR_SEQ, EV_SEQ, EV_SESSION, CREATED_ON, CREATED_ON_TZ, CLIENT_ID, 
          APPLIC, DBAPI_NAME, EVMGR_NAME, OBJECT_TP, OBJECT_ID,
          OBJECT_LC, OBJECT_LC_VERSION, OBJECT_SS, EV_TP, USERNAME, 
          EV_DETAILS, EXECUTED_ON, EXECUTED_ON_TZ, INSTANCE_NUMBER)
          SELECT TR_SEQ, EV_SEQ, L_EV_SESSION, CREATED_ON, CREATED_ON_TZ, CLIENT_ID,
                 APPLIC, DBAPI_NAME, UNAPIGEN.P_EVMGR_NAME,
                 OBJECT_TP, OBJECT_ID, OBJECT_LC, OBJECT_LC_VERSION, OBJECT_SS, 
                 EV_TP, USERNAME, EV_DETAILS, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                 UNAPIGEN.P_INSTANCENR
          FROM UTEV
          WHERE EV_SEQ = P_EV_REC.EV_SEQ;
         IF SQL%ROWCOUNT=0 THEN
            INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
            VALUES (UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                    'DeleteEvent', 'No record in utev ev_seq = '||TO_CHAR(A_EV_SEQ));
         END IF;
         EXCEPTION
         WHEN OTHERS THEN
            L_SQLERRM := SQLERRM;
            INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
            VALUES (UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                    'DeleteEvent', L_SQLERRM);
         END;
      ELSE
         BEGIN
         EXECUTE IMMEDIATE
         'INSERT INTO utevlog '||
         '(tr_seq, ev_seq, ev_session, created_on, created_on_tz, client_id,'||
         'applic, dbapi_name, evmgr_name, object_tp, object_id,'||
         'object_lc, object_lc_version, object_ss, ev_tp, username,'||
         'ev_details, executed_on, executed_on_tz, instance_number) '||
         'SELECT tr_seq, ev_seq, l_ev_session, created_on, created_on_tz, client_id,'||
                 'applic, dbapi_name, UNAPIGEN.P_EVMGR_NAME,'||
                 'object_tp, object_id, object_lc, object_lc_version, object_ss,'||
                 'ev_tp, username, ev_details, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,'||
                 'UNAPIGEN.P_INSTANCENR '||
         'FROM utev'||UNAPIGEN.P_INSTANCENR||
         ' WHERE ev_seq = :ev_seq'
         USING P_EV_REC.EV_SEQ;
         IF SQL%ROWCOUNT=0 THEN
            INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
            VALUES (UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                    'DeleteEvent', 'No record in utev ev_seq = '||TO_CHAR(A_EV_SEQ));
         END IF;
         EXCEPTION
         WHEN OTHERS THEN
            L_SQLERRM := SQLERRM;
            INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
            VALUES (UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                    'DeleteEvent', L_SQLERRM);
         END;
      END IF;
   END IF;

   IF UNAPIEV.P_EVMGRS_1QBYINSTANCE = '0' THEN
      DELETE FROM UTEV
      WHERE EV_SEQ = A_EV_SEQ AND CREATED_ON = A_CREATED_ON;
   ELSE
      EXECUTE IMMEDIATE 'DELETE FROM utev'||UNAPIGEN.P_INSTANCENR||' WHERE ev_seq = :a_ev_seq and created_on = :a_created_on'
      USING A_EV_SEQ, A_CREATED_ON;
   END IF;
   IF SQL%ROWCOUNT=0 THEN
      INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
      VALUES (UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
              'DeleteEvent', 'record not found ev_seq=' || TO_CHAR(A_EV_SEQ) ||
              ' created_on=' || TO_CHAR(A_CREATED_ON));
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

END DELETEEVENT;

FUNCTION INSERTEVENT                                       
(A_API_NAME            IN       VARCHAR2,                  
 A_EVMGR_NAME          IN       VARCHAR2,                  
 A_OBJECT_TP           IN       VARCHAR2,                  
 A_OBJECT_ID           IN       VARCHAR2,                  
 A_OBJECT_LC           IN       VARCHAR2,                  
 A_OBJECT_LC_VERSION   IN       VARCHAR2,                  
 A_OBJECT_SS           IN       VARCHAR2,                  
 A_EV_TP               IN       VARCHAR2,                  
 A_EV_DETAILS          IN       VARCHAR2,                  
 A_SEQ_NR              IN OUT   NUMBER)                    
RETURN NUMBER IS

L_TR_SEQ_NR                NUMBER;
L_SEQ_NR                   NUMBER;
L_USERNAME                 VARCHAR2(30);
L_EVMGR_NAME               VARCHAR2(20);

CURSOR L_SEQ_EVENT_CURSOR IS
   SELECT SEQ_EVENT_NR.NEXTVAL FROM DUAL;

BEGIN

   IF A_EV_TP IS NULL THEN
      RAISE_APPLICATION_ERROR(-20000, 'No event type specified in InsertEvent !');   
   END IF;
   
   
   OPEN L_SEQ_EVENT_CURSOR;
   FETCH L_SEQ_EVENT_CURSOR INTO A_SEQ_NR;
   CLOSE L_SEQ_EVENT_CURSOR;
   
   IF NVL(UNAPIGEN.P_TR_SEQ,0) <> NVL(UNAPIGEN.P_CURRENT_EVMGR_TR_SEQ,0) THEN
      UNAPIGEN.P_CURRENT_EVMGR_TR_SEQ := UNAPIGEN.P_TR_SEQ;
      UNAPIGEN.P_CURRENT_EVMGR_NAME := UNAPIGEN.P_EVMGR_NAME;
   END IF;

   IF P_EV_MGR_SESSION THEN
      L_SUBEVENTS := L_SUBEVENTS + 1;
      L_USERNAME := NVL(UNAPIEV.P_EV_REC.USERNAME,UNAPIGEN.P_USER);
      L_TR_SEQ_NR := UNAPIEV.P_EV_REC.TR_SEQ;
   ELSE
      L_USERNAME := UNAPIGEN.P_USER;
      L_TR_SEQ_NR := UNAPIGEN.P_TR_SEQ;
   END IF;

   IF UNAPIEV.P_EVMGRS_EV_IN_BULK = '1' THEN
         UNAPIEV.L_EV_TAB.EXTEND();
         UNAPIEV.L_EV_TAB(UNAPIEV.L_EV_TAB.COUNT()) := 
              UOEV(L_TR_SEQ_NR, A_SEQ_NR, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 
                   UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, A_API_NAME, NVL(A_EVMGR_NAME, UNAPIGEN.P_CURRENT_EVMGR_NAME),
                   A_OBJECT_TP, A_OBJECT_ID, A_OBJECT_LC, A_OBJECT_LC_VERSION, A_OBJECT_SS,
                   A_EV_TP, L_USERNAME, A_EV_DETAILS);
   ELSE
      IF UNAPIEV.P_EVMGRS_1QBYINSTANCE = '1' THEN
         
         
         EXECUTE IMMEDIATE
            'INSERT INTO utev'||UNAPIGEN.P_INSTANCENR||
            ' (tr_seq, ev_seq, created_on, created_on_tz, client_id, applic, dbapi_name,'||
            'evmgr_name, object_tp, object_id, object_lc, object_lc_version, object_ss,'||
            'ev_tp, username, ev_details) VALUES '||
            '(:tr_seq, :ev_seq, :created_on,:created_on_tz, :client_id,'||
            ':applic, :dbapi_name,:evmgr_name, :object_tp, :object_id,'||
            ':object_lc, :object_lc_version, :object_ss,'||
            ':ev_tp, :username, :ev_details)'
         USING
            L_TR_SEQ_NR, A_SEQ_NR, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, UNAPIGEN.P_CLIENT_ID,
            UNAPIGEN.P_APPLIC_NAME, A_API_NAME, NVL(A_EVMGR_NAME, UNAPIGEN.P_CURRENT_EVMGR_NAME), 
            A_OBJECT_TP, A_OBJECT_ID, A_OBJECT_LC, A_OBJECT_LC_VERSION,
            A_OBJECT_SS,A_EV_TP, L_USERNAME, A_EV_DETAILS;
      ELSE
         INSERT INTO UTEV(TR_SEQ, EV_SEQ, CREATED_ON, CREATED_ON_TZ, CLIENT_ID, APPLIC, DBAPI_NAME,
                          EVMGR_NAME, OBJECT_TP, OBJECT_ID, OBJECT_LC, OBJECT_LC_VERSION, OBJECT_SS,
                          EV_TP, USERNAME, EV_DETAILS)
         VALUES (L_TR_SEQ_NR,
                 A_SEQ_NR, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME,
                 A_API_NAME, NVL(A_EVMGR_NAME, UNAPIGEN.P_CURRENT_EVMGR_NAME), A_OBJECT_TP, A_OBJECT_ID, A_OBJECT_LC, A_OBJECT_LC_VERSION,
                 A_OBJECT_SS,A_EV_TP, L_USERNAME, A_EV_DETAILS);      
      END IF;   
   END IF;
   RETURN(UNAPIGEN.DBERR_SUCCESS);
END INSERTEVENT;

FUNCTION INSERTINFOFIELDEVENT                              
(A_API_NAME            IN       VARCHAR2,                  
 A_EVMGR_NAME          IN       VARCHAR2,                  
 A_OBJECT_TP           IN       VARCHAR2,                  
 A_OBJECT_ID           IN       VARCHAR2,                  
 A_OBJECT_LC           IN       VARCHAR2,                  
 A_OBJECT_LC_VERSION   IN       VARCHAR2,                  
 A_OBJECT_SS           IN       VARCHAR2,                  
 A_EV_TP               IN       VARCHAR2,                  
 A_EV_DETAILS          IN       VARCHAR2,                  
 A_SEQ_NR              IN OUT   NUMBER)                    
RETURN NUMBER IS

L_NR_OF_LINKS    NUMBER;

BEGIN
   
   
   
   
 
   
   SELECT COUNT(*)
   INTO L_NR_OF_LINKS
   FROM UTEVRULES
   WHERE OBJECT_TP = A_OBJECT_TP
     AND OBJECT_ID = A_OBJECT_ID
     AND EV_TP IN ('InfoFieldCreated', 'InfoFieldUpdated', 'InfoFieldValueChanged', 
                   'InfoFieldDeleted',
                   'RqInfoFieldCreated', 'RqInfoFieldUpdated', 'RqInfoFieldValueChanged', 
                   'RqInfoFieldDeleted',
                   'SdInfoFieldCreated', 'SdInfoFieldUpdated', 'SdInfoFieldValueChanged', 
                   'SdInfoFieldDeleted');
   
   IF A_OBJECT_ID IN ('unsupplierspecs', 'uncustomerspecs') THEN
      
      L_NR_OF_LINKS := 1;
   END IF;
     
   IF (A_OBJECT_LC IS NOT NULL) OR (L_NR_OF_LINKS > 0) THEN
      L_RESULT := UNAPIEV.INSERTEVENT(A_API_NAME, A_EVMGR_NAME, A_OBJECT_TP, A_OBJECT_ID,
                                      A_OBJECT_LC, A_OBJECT_LC_VERSION, A_OBJECT_SS, A_EV_TP, 
                                      A_EV_DETAILS, A_SEQ_NR);
      RETURN(L_RESULT);
   END IF;
      
   RETURN(UNAPIGEN.DBERR_SUCCESS);
END INSERTINFOFIELDEVENT;

FUNCTION BROADCASTEVENT                            
(A_API_NAME             IN       VARCHAR2,          
 A_EVMGR_NAME           IN       VARCHAR2,          
 A_OBJECT_TP            IN       VARCHAR2,          
 A_OBJECT_ID            IN       VARCHAR2,          
 A_OBJECT_LC            IN       VARCHAR2,          
 A_OBJECT_LC_VERSION    IN       VARCHAR2,          
 A_OBJECT_SS            IN       VARCHAR2,          
 A_EV_TP                IN       VARCHAR2,          
 A_EV_DETAILS           IN       VARCHAR2,          
 A_SEQ_NR               IN OUT   NUMBER)            
RETURN NUMBER IS
BEGIN
   RETURN(UNAPIEV.BROADCASTEVENT(A_API_NAME,
                                 A_EVMGR_NAME,
                                 A_OBJECT_TP,
                                 A_OBJECT_ID,
                                 A_OBJECT_LC,
                                 A_OBJECT_LC_VERSION,
                                 A_OBJECT_SS,
                                 A_EV_TP,
                                 A_EV_DETAILS,
                                 '1',
                                 A_SEQ_NR));                                
END BROADCASTEVENT;

FUNCTION BROADCASTEVENT                                   
(A_API_NAME                   IN       VARCHAR2,          
 A_EVMGR_NAME                 IN       VARCHAR2,          
 A_OBJECT_TP                  IN       VARCHAR2,          
 A_OBJECT_ID                  IN       VARCHAR2,          
 A_OBJECT_LC                  IN       VARCHAR2,          
 A_OBJECT_LC_VERSION          IN       VARCHAR2,          
 A_OBJECT_SS                  IN       VARCHAR2,          
 A_EV_TP                      IN       VARCHAR2,          
 A_EV_DETAILS                 IN       VARCHAR2,          
 A_WAKEUPALSOSTUDYEVENTMGR    IN       CHAR,              
 A_SEQ_NR                     IN OUT   NUMBER)            
RETURN NUMBER IS

L_SEQ_NR                   NUMBER;
L_USERNAME                 VARCHAR2(30);
L_HOW_MANY_BY_INSTANCE     INTEGER;
L_HOW_MANY_IN_TOTAL        INTEGER;
L_COUNT_INSTANCES          INTEGER;
L_INSTANCE_NR              INTEGER;
L_INSTANCE_ID              NUMBER(6);  


CURSOR L_SEQ_EVENT_CURSOR IS
   SELECT SEQ_EVENT_NR.NEXTVAL FROM DUAL;

   PROCEDURE LOCALINSERTEVENT
   (A_TR_SEQ           IN       NUMBER,
    A_EV_SEQ           IN       NUMBER,
    A_CREATED_ON       IN       TIMESTAMP WITH TIME ZONE,
    A_CREATED_ON_TZ    IN       TIMESTAMP WITH TIME ZONE,
    A_CLIENT_ID        IN       VARCHAR2,
    A_APPLIC           IN       VARCHAR2,
    A_API_NAME         IN       VARCHAR2,
    A_EVMGR_NAME       IN       VARCHAR2,
    A_OBJECT_TP        IN       VARCHAR2,
    A_OBJECT_ID        IN       VARCHAR2,
    A_OBJECT_LC        IN       VARCHAR2,
    OBJECT_LC_VERSION  IN       VARCHAR2,
    A_OBJECT_SS        IN       VARCHAR2,
    A_EV_TP            IN       VARCHAR2,
    A_USERNAME         IN       VARCHAR2,
    A_EV_DETAILS       IN       VARCHAR2,
    A_INSTANCE_NR      IN       NUMBER)
   IS
   BEGIN
   
   
   IF UNAPIEV.P_EVMGRS_1QBYINSTANCE = '1' THEN
      
      
      EXECUTE IMMEDIATE
         'INSERT INTO utev'||A_INSTANCE_NR||
         ' (tr_seq, ev_seq, created_on, created_on_tz, client_id, applic, dbapi_name,'||
         'evmgr_name, object_tp, object_id, object_lc, object_lc_version, object_ss,'||
         'ev_tp, username, ev_details) VALUES '||
         '(:tr_seq, :ev_seq, :created_on,:created_on_tz, :client_id,'||
         ':applic, :dbapi_name,:evmgr_name, :object_tp, :object_id,'||
         ':object_lc, :object_lc_version, :object_ss,'||
         ':ev_tp, :username, :ev_details)'
      USING
         A_TR_SEQ, A_EV_SEQ, A_CREATED_ON, A_CREATED_ON_TZ, A_CLIENT_ID,
         A_APPLIC, A_API_NAME, NVL(A_EVMGR_NAME, NVL(UNAPIGEN.P_CURRENT_EVMGR_NAME,'U4EVMGR')), 
         A_OBJECT_TP, A_OBJECT_ID, A_OBJECT_LC, A_OBJECT_LC_VERSION,
         A_OBJECT_SS, A_EV_TP, A_USERNAME, A_EV_DETAILS;
   ELSE
      INSERT INTO UTEV(TR_SEQ, 
                       EV_SEQ, CREATED_ON, CREATED_ON_TZ, CLIENT_ID, APPLIC, DBAPI_NAME,
                       EVMGR_NAME, OBJECT_TP, OBJECT_ID, OBJECT_LC, OBJECT_LC_VERSION, OBJECT_SS,
                       EV_TP, USERNAME, EV_DETAILS)
      VALUES (A_TR_SEQ,
              A_EV_SEQ, A_CREATED_ON, A_CREATED_ON_TZ, A_CLIENT_ID, A_APPLIC,
              A_API_NAME, NVL(A_EVMGR_NAME, NVL(UNAPIGEN.P_CURRENT_EVMGR_NAME,'U4EVMGR')), A_OBJECT_TP, A_OBJECT_ID, A_OBJECT_LC, A_OBJECT_LC_VERSION,
              A_OBJECT_SS, A_EV_TP, A_USERNAME, A_EV_DETAILS);      
   END IF;   
   END LOCALINSERTEVENT;
    
BEGIN

   
   
   
   OPEN C_SYSTEM ('EVENT_MGRS_TO_START');
   FETCH C_SYSTEM INTO L_HOW_MANY_BY_INSTANCE;
   CLOSE C_SYSTEM;

   SELECT COUNT(*)
   INTO L_HOW_MANY_IN_TOTAL
   FROM SYS.GV_$SESSION
   WHERE MODULE LIKE 'EvMgrJob%' AND MODULE NOT LIKE 'EvMgrJob9__';
   
   
   
   
   
   OPEN L_SEQ_EVENT_CURSOR;
   FETCH L_SEQ_EVENT_CURSOR 
   INTO A_SEQ_NR;
   CLOSE L_SEQ_EVENT_CURSOR;

   IF P_EV_MGR_SESSION THEN
      L_SUBEVENTS := L_SUBEVENTS + 1;
      L_USERNAME := NVL(UNAPIEV.P_EV_REC.USERNAME,UNAPIGEN.P_USER);
   ELSE
      L_USERNAME := UNAPIGEN.P_USER;
   END IF;
   
   
   
   
   
   
   FOR L_SESSION4JOB_REC IN (SELECT Z.JOB_ACTION, 
                                    SUBSTR(Z.JOB_ACTION,INSTR(Z.JOB_ACTION,'''',1,1)+1, INSTR(Z.JOB_ACTION,'''',1,2)-INSTR(Z.JOB_ACTION,'''',1,1)-1) EVMGR_NAME,
                                    Z.SEQ_NR ,
                                    X.INST_ID
                             FROM
                                 (SELECT B.JOB_ACTION, TO_NUMBER(REPLACE(SUBSTR(B.JOB_ACTION,INSTR(B.JOB_ACTION,'''',1,2)+2),');','')) SEQ_NR
                                    FROM SYS.DBA_SCHEDULER_JOBS B 
                                   WHERE INSTR(JOB_ACTION, 'UNAPIEV.EVENTMANAGERJOB')<>0) Z,                           
                                 (SELECT A.INST_ID, TO_NUMBER(SUBSTR(A.MODULE,9)) SEQ_NR
                                    FROM SYS.GV_$SESSION A
                                   WHERE MODULE LIKE 'EvMgrJob%'
                                     AND MODULE NOT LIKE 'EvMgrJob9__') X
                             WHERE X.SEQ_NR = Z.SEQ_NR       ) LOOP
      
      
      
      
      
      
      
      
      
      
      L_SEQ_NR := L_SESSION4JOB_REC.SEQ_NR;
      L_INSTANCE_NR := L_SESSION4JOB_REC.INST_ID;
      
      LOCALINSERTEVENT(-L_SEQ_NR,
              A_SEQ_NR, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME,
              A_API_NAME,L_SESSION4JOB_REC.EVMGR_NAME, A_OBJECT_TP, A_OBJECT_ID, A_OBJECT_LC, A_OBJECT_LC_VERSION,
              A_OBJECT_SS, A_EV_TP, L_USERNAME, A_EV_DETAILS, L_INSTANCE_NR);
              
      IF UNAPIEV.P_EVMGRS_POLLING_ON = '0' THEN
         IF A_EV_TP = 'STOP' THEN
            DBMS_ALERT.SIGNAL(NVL(L_SESSION4JOB_REC.EVMGR_NAME,NVL(UNAPIGEN.P_CURRENT_EVMGR_NAME,'U4EVMGR')), A_EV_TP);              
         ELSE
            DBMS_ALERT.SIGNAL(NVL(L_SESSION4JOB_REC.EVMGR_NAME,NVL(UNAPIGEN.P_CURRENT_EVMGR_NAME,'U4EVMGR')), 1);              
         END IF;                  
      END IF;
   END LOOP;
   
   
   
   IF A_WAKEUPALSOSTUDYEVENTMGR = '1' THEN
   
      SELECT COUNT(*)
      INTO L_COUNT_INSTANCES
      FROM SYS.GV_$SESSION
      WHERE MODULE LIKE 'EvMgrJob9__';
   
      
      
      
      FOR L_SESSION4JOB_REC IN (SELECT INST_ID, TO_NUMBER(SUBSTR(MODULE,9)) SEQ_NR
                             FROM SYS.GV_$SESSION
                             WHERE MODULE LIKE 'EvMgrJob9__') LOOP
         BEGIN
            SELECT INST_ID
            INTO L_INSTANCE_NR
            FROM SYS.GV_$SESSION
            WHERE MODULE LIKE 'EvMgrJob9__' AND MODULE LIKE 'EvMgrJob9'||LTRIM(TO_CHAR(L_SEQ_NR,'00'));
         EXCEPTION
         WHEN NO_DATA_FOUND THEN
            
            L_INSTANCE_NR := L_SEQ_NR;
         END;
         L_SEQ_NR := L_SESSION4JOB_REC.SEQ_NR;
         L_INSTANCE_NR := L_SESSION4JOB_REC.INST_ID;

         LOCALINSERTEVENT(-L_SEQ_NR,
                 A_SEQ_NR, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME,
                 A_API_NAME,'STUDY_EVENT_MGR', A_OBJECT_TP, A_OBJECT_ID, A_OBJECT_LC, A_OBJECT_LC_VERSION,
                 A_OBJECT_SS, A_EV_TP, L_USERNAME, A_EV_DETAILS, L_INSTANCE_NR);
      END LOOP;
      
      
      
      IF UNAPIEV.P_EVMGRS_POLLING_ON = '0' THEN
         IF A_EV_TP = 'STOP' THEN
            DBMS_ALERT.SIGNAL('STUDY_EVENT_MGR', A_EV_TP);              
         ELSE
            DBMS_ALERT.SIGNAL('STUDY_EVENT_MGR', 1);              
         END IF;                  
      END IF;
   END IF;
   RETURN(UNAPIGEN.DBERR_SUCCESS);
END BROADCASTEVENT;

FUNCTION INSERTTIMEDEVENT                                  
(A_API_NAME            IN       VARCHAR2,                  
 A_EVMGR_NAME          IN       VARCHAR2,                  
 A_OBJECT_TP           IN       VARCHAR2,                  
 A_OBJECT_ID           IN       VARCHAR2,                  
 A_OBJECT_LC           IN       VARCHAR2,                  
 A_OBJECT_LC_VERSION   IN       VARCHAR2,                  
 A_OBJECT_SS           IN       VARCHAR2,                  
 A_EV_TP               IN       VARCHAR2,                  
 A_EV_DETAILS          IN       VARCHAR2,                  
 A_SEQ_NR              IN OUT   NUMBER,                    
 A_EXECUTE_AT          IN       DATE)                      
RETURN NUMBER IS

L_SEQ_NR                   NUMBER;
L_USERNAME                 VARCHAR2(30);

BEGIN

   IF (NVL(A_SEQ_NR, -1) = -1) THEN
      
      SELECT SEQ_EVENT_NR.NEXTVAL INTO A_SEQ_NR FROM DUAL;
   END IF;

   IF P_EV_MGR_SESSION THEN
      L_USERNAME := NVL(UNAPIEV.P_EV_REC.USERNAME,UNAPIGEN.P_USER);
   ELSE
      L_USERNAME := UNAPIGEN.P_USER;
   END IF;

   INSERT INTO UTEVTIMED(EV_SEQ, CREATED_ON, CREATED_ON_TZ, CLIENT_ID, APPLIC, DBAPI_NAME,
                         EVMGR_NAME, OBJECT_TP, OBJECT_ID, OBJECT_LC, OBJECT_LC_VERSION, OBJECT_SS,
                         EV_TP, USERNAME, EV_DETAILS, EXECUTE_AT)
   VALUES(A_SEQ_NR, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME,
          A_API_NAME,A_EVMGR_NAME, A_OBJECT_TP, A_OBJECT_ID, A_OBJECT_LC, A_OBJECT_LC_VERSION,
          A_OBJECT_SS,A_EV_TP, L_USERNAME, A_EV_DETAILS, A_EXECUTE_AT);
   
   IF A_EXECUTE_AT IS NULL THEN
      UNAPIGEN.LOGERROR('AlertWaitAny', 'Warning! Timed event inerted with a NULL execution date !!!');   
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

END INSERTTIMEDEVENT;

FUNCTION UPDATETIMEDEVENT                                  
(A_OBJECT_TP           IN       VARCHAR2,                  
 A_OBJECT_ID           IN       VARCHAR2,                  
 A_EV_TP               IN       VARCHAR2,                  
 A_EV_DETAILS          IN       VARCHAR2,                  
 A_EXECUTE_AT          IN       DATE)                      
RETURN NUMBER IS

L_SEQ_NR                   NUMBER;
L_UTEVTIMED_REC            UTEVTIMED%ROWTYPE;

BEGIN

   
   SELECT *
   INTO L_UTEVTIMED_REC
   FROM UTEVTIMED
   WHERE OBJECT_TP = A_OBJECT_TP
     AND OBJECT_ID = A_OBJECT_ID
     AND EV_TP = A_EV_TP
     AND EV_DETAILS = A_EV_DETAILS;

   DELETE FROM UTEVTIMED
   WHERE EV_SEQ = L_UTEVTIMED_REC.EV_SEQ;

   INSERT INTO UTEVTIMED(EV_SEQ, CREATED_ON, CREATED_ON_TZ, CLIENT_ID, APPLIC, DBAPI_NAME,
                         EVMGR_NAME, OBJECT_TP, OBJECT_ID, OBJECT_LC, OBJECT_LC_VERSION, OBJECT_SS,
                         EV_TP, USERNAME, EV_DETAILS, EXECUTE_AT, EXECUTE_AT_TZ)
   VALUES(L_UTEVTIMED_REC.EV_SEQ, L_UTEVTIMED_REC.CREATED_ON, L_UTEVTIMED_REC.CREATED_ON_TZ,
          L_UTEVTIMED_REC.CLIENT_ID, L_UTEVTIMED_REC.APPLIC,
          L_UTEVTIMED_REC.DBAPI_NAME, L_UTEVTIMED_REC.EVMGR_NAME,
          L_UTEVTIMED_REC.OBJECT_TP, L_UTEVTIMED_REC.OBJECT_ID,
          L_UTEVTIMED_REC.OBJECT_LC, L_UTEVTIMED_REC.OBJECT_LC_VERSION, L_UTEVTIMED_REC.OBJECT_SS,
          L_UTEVTIMED_REC.EV_TP, L_UTEVTIMED_REC.USERNAME, 
          L_UTEVTIMED_REC.EV_DETAILS, A_EXECUTE_AT, A_EXECUTE_AT);

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN NO_DATA_FOUND THEN
   
   RETURN(UNAPIGEN.DBERR_SUCCESS);   
END UPDATETIMEDEVENT;

FUNCTION DELETETIMEDEVENT                                  
(A_OBJECT_TP           IN       VARCHAR2,                  
 A_OBJECT_ID           IN       VARCHAR2,                  
 A_EV_TP               IN       VARCHAR2,                  
 A_EV_DETAILS          IN       VARCHAR2)                  
RETURN NUMBER IS

BEGIN
   DELETE
   FROM UTEVTIMED
   WHERE OBJECT_TP = NVL(A_OBJECT_TP, OBJECT_TP)
     AND OBJECT_ID = NVL(A_OBJECT_ID, OBJECT_ID)
     AND EV_TP = NVL(A_EV_TP, EV_TP)
     AND EV_DETAILS LIKE NVL(A_EV_DETAILS, EV_DETAILS);

   RETURN(UNAPIGEN.DBERR_SUCCESS);

END DELETETIMEDEVENT;


FUNCTION SAVECLIENT                                         
(A_CLIENT_ID           IN       VARCHAR2,                   
 A_EVMGR_NAME          IN       VARCHAR2,                   
 A_EVMGR_TP            IN       CHAR,                       
 A_EVMGR_PUBLIC        IN       CHAR)                       
RETURN NUMBER IS

L_INSERT       BOOLEAN;
L_CLIENT_ID    VARCHAR2(20);

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_CLIENT_ID, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   IF A_EVMGR_TP NOT IN ('T','B','I') THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_EVMGRTP;
      RAISE STPERROR;
   END IF;

   IF A_EVMGR_PUBLIC NOT IN ('1','0') THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_EVMGRPUBLIC;
      RAISE STPERROR;
   END IF;

   BEGIN
      SELECT CLIENT_ID
      INTO L_CLIENT_ID
      FROM UTCLIENT
      WHERE CLIENT_ID = A_CLIENT_ID
      FOR UPDATE OF CLIENT_ID NOWAIT;
      L_INSERT := FALSE;
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
       L_INSERT := TRUE;
   END;

   IF L_INSERT THEN          
      INSERT INTO UTCLIENT(CLIENT_ID, EVMGR_NAME, EVMGR_TP, EVMGR_PUBLIC)
      VALUES (A_CLIENT_ID, A_EVMGR_NAME, A_EVMGR_TP, A_EVMGR_PUBLIC);
   ELSE                      
      UPDATE UTCLIENT
      SET EVMGR_NAME   = A_EVMGR_NAME,
          EVMGR_TP     = A_EVMGR_TP,
          EVMGR_PUBLIC = A_EVMGR_PUBLIC
      WHERE CLIENT_ID  = A_CLIENT_ID;
   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('SaveClient', SQLERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'SaveClient'));
END SAVECLIENT;

FUNCTION EVALLIFECYCLE                                     
(A_SS_TO      IN OUT VARCHAR2,                             
 A_TR_NO      OUT    NUMBER)                               
RETURN NUMBER IS

L_TR_OK                       BOOLEAN;
L_ALLOW_MODIFY                CHAR(1);
L_ACTIVE                      CHAR(1);
L_LC_NAME                     VARCHAR2(20);
L_LC_VERSION                  VARCHAR2(20);
L_CONFIG_OBJECT_VERSION       VARCHAR2(20);
L_LC                          VARCHAR2(20);
L_SS                          VARCHAR2(2);
L_LOOPED                      BOOLEAN;
L_LOG_HS                      CHAR(1);
L_LOG_HS_DETAILS              CHAR(1);

CURSOR L_TR_CURSOR IS
   SELECT SS_FROM, SS_TO, TR_NO, CONDITION
   FROM UTLCTR
   WHERE LC = P_EV_REC.OBJECT_LC
     AND VERSION = P_EV_REC.OBJECT_LC_VERSION
     AND (SS_FROM = P_EV_REC.OBJECT_SS OR SS_FROM = '@@')
     AND (A_SS_TO IS NULL OR SS_TO = A_SS_TO)
   ORDER BY SS_FROM DESC, TR_NO;

CURSOR L_EQCA_CURSOR (A_SC VARCHAR2) IS
   SELECT EQ, LAB
   FROM UTEQCA
   WHERE SC = A_SC;

CURSOR L_SC_CURSOR (A_SC VARCHAR2) IS
   SELECT LC, LC_VERSION, SS, NVL(P_RQ,RQ), NVL(P_SD,SD),LOG_HS, LOG_HS_DETAILS, ST_VERSION
   FROM UTSC
   WHERE SC = A_SC
   FOR UPDATE;
   
BEGIN

   
   
   A_TR_NO := NULL;  
   L_TR_OK := FALSE;
   P_LC_SS_FROM := NULL;
   P_LOG_HS := FALSE;
   P_LOG_HS_DETAILS := FALSE;
   L_LOG_HS := '0';
   L_LOG_HS_DETAILS := '0';
   
   IF P_EV_OUTPUT_ON THEN
      UNTRACE.LOG('   '||P_EV_REC.OBJECT_TP||' level - EvalLifeCycle start for ');
   END IF;

   
   
   
   
   
   
   
   
   
   
   BEGIN
      IF P_EV_REC.OBJECT_TP = 'me' THEN
         SELECT LC, LC_VERSION, SS, LOG_HS, LOG_HS_DETAILS, REANALYSIS, MT_VERSION
         INTO P_EV_REC.OBJECT_LC, P_EV_REC.OBJECT_LC_VERSION, P_EV_REC.OBJECT_SS, 
              L_LOG_HS, L_LOG_HS_DETAILS, P_REANALYSIS, L_CONFIG_OBJECT_VERSION
         FROM UTSCME
         WHERE SC = P_SC 
           AND PG = P_PG 
           AND PGNODE = P_PGNODE
           AND PA = P_PA 
           AND PANODE = P_PANODE
           AND ME = P_ME 
           AND MENODE = P_MENODE
           FOR UPDATE;
         IF UNAPIEV.P_MT_VERSION IS NULL THEN
            UNAPIEV.P_MT_VERSION := L_CONFIG_OBJECT_VERSION;
         END IF;
      ELSIF P_EV_REC.OBJECT_TP = 'pa' THEN
         SELECT LC, LC_VERSION, SS, LOG_HS, LOG_HS_DETAILS, PR_VERSION
         INTO P_EV_REC.OBJECT_LC, P_EV_REC.OBJECT_LC_VERSION, P_EV_REC.OBJECT_SS, 
              L_LOG_HS, L_LOG_HS_DETAILS, L_CONFIG_OBJECT_VERSION
         FROM UTSCPA
         WHERE SC = P_SC 
           AND PG = P_PG 
           AND PGNODE = P_PGNODE
           AND PA = P_PA 
           AND PANODE = P_PANODE
           FOR UPDATE;
         IF UNAPIEV.P_PR_VERSION IS NULL THEN
            UNAPIEV.P_PR_VERSION := L_CONFIG_OBJECT_VERSION;
         END IF;
      ELSIF P_EV_REC.OBJECT_TP = 'sdii' THEN
         SELECT LC, LC_VERSION, SS, LOG_HS, LOG_HS_DETAILS, IE_VERSION
         INTO P_EV_REC.OBJECT_LC, P_EV_REC.OBJECT_LC_VERSION, P_EV_REC.OBJECT_SS,
              L_LOG_HS, L_LOG_HS_DETAILS, L_CONFIG_OBJECT_VERSION
         FROM UTSDII
         WHERE SD = P_SD 
           AND IC = P_IC 
           AND ICNODE = P_ICNODE
           AND II = P_II 
           AND IINODE = P_IINODE
           FOR UPDATE;
         IF UNAPIEV.P_IE_VERSION IS NULL THEN
            UNAPIEV.P_IE_VERSION := L_CONFIG_OBJECT_VERSION;
         END IF;
      ELSIF P_EV_REC.OBJECT_TP = 'rqii' THEN
         SELECT LC, LC_VERSION, SS, LOG_HS, LOG_HS_DETAILS, IE_VERSION
         INTO P_EV_REC.OBJECT_LC, P_EV_REC.OBJECT_LC_VERSION, P_EV_REC.OBJECT_SS,
              L_LOG_HS, L_LOG_HS_DETAILS, L_CONFIG_OBJECT_VERSION
         FROM UTRQII
         WHERE RQ = P_RQ 
           AND IC = P_IC 
           AND ICNODE = P_ICNODE
           AND II = P_II 
           AND IINODE = P_IINODE
           FOR UPDATE;
         IF UNAPIEV.P_IE_VERSION IS NULL THEN
            UNAPIEV.P_IE_VERSION := L_CONFIG_OBJECT_VERSION;
         END IF;
      ELSIF P_EV_REC.OBJECT_TP = 'ii' THEN
         SELECT LC, LC_VERSION, SS, LOG_HS, LOG_HS_DETAILS, IE_VERSION
         INTO P_EV_REC.OBJECT_LC, P_EV_REC.OBJECT_LC_VERSION, P_EV_REC.OBJECT_SS, 
              L_LOG_HS, L_LOG_HS_DETAILS, L_CONFIG_OBJECT_VERSION
         FROM UTSCII
         WHERE SC = P_SC 
           AND IC = P_IC 
           AND ICNODE = P_ICNODE
           AND II = P_II 
           AND IINODE = P_IINODE
           FOR UPDATE;
         IF UNAPIEV.P_IE_VERSION IS NULL THEN
            UNAPIEV.P_IE_VERSION := L_CONFIG_OBJECT_VERSION;
         END IF;
      ELSIF P_EV_REC.OBJECT_TP = 'pg' THEN
         SELECT LC, LC_VERSION, SS, LOG_HS, LOG_HS_DETAILS, PP_VERSION
         INTO P_EV_REC.OBJECT_LC, P_EV_REC.OBJECT_LC_VERSION, P_EV_REC.OBJECT_SS, 
              L_LOG_HS, L_LOG_HS_DETAILS, L_CONFIG_OBJECT_VERSION
         FROM UTSCPG
         WHERE SC = P_SC 
           AND PG = P_PG 
           AND PGNODE = P_PGNODE
           FOR UPDATE;
         IF UNAPIEV.P_PP_VERSION IS NULL THEN
            UNAPIEV.P_PP_VERSION := L_CONFIG_OBJECT_VERSION;
         END IF;
      ELSIF P_EV_REC.OBJECT_TP = 'sdic' THEN
         SELECT LC, LC_VERSION, SS, LOG_HS, LOG_HS_DETAILS, IP_VERSION
         INTO P_EV_REC.OBJECT_LC, P_EV_REC.OBJECT_LC_VERSION, P_EV_REC.OBJECT_SS, 
              L_LOG_HS, L_LOG_HS_DETAILS, L_CONFIG_OBJECT_VERSION
         FROM UTSDIC
         WHERE SD = P_SD 
           AND IC = P_IC 
           AND ICNODE = P_ICNODE
           FOR UPDATE;
         IF UNAPIEV.P_IP_VERSION IS NULL THEN
            UNAPIEV.P_IP_VERSION := L_CONFIG_OBJECT_VERSION;
         END IF;
      ELSIF P_EV_REC.OBJECT_TP = 'rqic' THEN
         SELECT LC, LC_VERSION, SS, LOG_HS, LOG_HS_DETAILS, IP_VERSION
         INTO P_EV_REC.OBJECT_LC, P_EV_REC.OBJECT_LC_VERSION, P_EV_REC.OBJECT_SS, 
              L_LOG_HS, L_LOG_HS_DETAILS, L_CONFIG_OBJECT_VERSION
         FROM UTRQIC
         WHERE RQ = P_RQ 
           AND IC = P_IC 
           AND ICNODE = P_ICNODE
           FOR UPDATE;
         IF UNAPIEV.P_IP_VERSION IS NULL THEN
            UNAPIEV.P_IP_VERSION := L_CONFIG_OBJECT_VERSION;
         END IF;
      ELSIF P_EV_REC.OBJECT_TP = 'ic' THEN
         SELECT LC, LC_VERSION, SS, LOG_HS, LOG_HS_DETAILS, IP_VERSION
         INTO P_EV_REC.OBJECT_LC, P_EV_REC.OBJECT_LC_VERSION, P_EV_REC.OBJECT_SS, 
              L_LOG_HS, L_LOG_HS_DETAILS, L_CONFIG_OBJECT_VERSION
         FROM UTSCIC
         WHERE SC = P_SC 
           AND IC = P_IC 
           AND ICNODE = P_ICNODE
           FOR UPDATE;
         IF UNAPIEV.P_IP_VERSION IS NULL THEN
            UNAPIEV.P_IP_VERSION := L_CONFIG_OBJECT_VERSION;
         END IF;
      ELSIF P_EV_REC.OBJECT_TP = 'sc' THEN 
         
         
         
         
         
         
         OPEN L_SC_CURSOR(P_SC);
         FETCH L_SC_CURSOR
         INTO P_EV_REC.OBJECT_LC, P_EV_REC.OBJECT_LC_VERSION, P_EV_REC.OBJECT_SS, P_RQ, P_SD, 
              L_LOG_HS, L_LOG_HS_DETAILS, L_CONFIG_OBJECT_VERSION;
         CLOSE L_SC_CURSOR;
                           
         IF P_EQSC_SC <> P_SC THEN
            OPEN L_EQCA_CURSOR(P_SC);
            FETCH L_EQCA_CURSOR
            INTO P_EQSC_EQ, P_EQSC_LAB;
            IF L_EQCA_CURSOR%NOTFOUND THEN
               P_EQSC_EQ  := '-';
               P_EQSC_LAB := '-';
            END IF;
            CLOSE L_EQCA_CURSOR;
            P_EQSC_SC := P_SC;
         END IF;
         IF UNAPIEV.P_ST_VERSION IS NULL THEN
            UNAPIEV.P_ST_VERSION := L_CONFIG_OBJECT_VERSION;
         END IF;         
      ELSIF P_EV_REC.OBJECT_TP = 'rq' THEN
         SELECT LC, LC_VERSION, SS, LOG_HS, LOG_HS_DETAILS, RT_VERSION
         INTO P_EV_REC.OBJECT_LC, P_EV_REC.OBJECT_LC_VERSION, P_EV_REC.OBJECT_SS, 
              L_LOG_HS, L_LOG_HS_DETAILS, L_CONFIG_OBJECT_VERSION
         FROM UTRQ
         WHERE RQ = P_RQ
         FOR UPDATE;
         IF UNAPIEV.P_RT_VERSION IS NULL THEN
            UNAPIEV.P_RT_VERSION := L_CONFIG_OBJECT_VERSION;
         END IF;         
      ELSIF P_EV_REC.OBJECT_TP = 'sd' THEN
         SELECT LC, LC_VERSION, SS, LOG_HS, LOG_HS_DETAILS, PT_VERSION
         INTO P_EV_REC.OBJECT_LC, P_EV_REC.OBJECT_LC_VERSION, P_EV_REC.OBJECT_SS, 
              L_LOG_HS, L_LOG_HS_DETAILS, L_CONFIG_OBJECT_VERSION
         FROM UTSD
         WHERE SD = P_SD
         FOR UPDATE;
         IF UNAPIEV.P_PT_VERSION IS NULL THEN
            UNAPIEV.P_PT_VERSION := L_CONFIG_OBJECT_VERSION;
         END IF;         
      ELSIF P_EV_REC.OBJECT_TP = 'ws' THEN
         SELECT LC, LC_VERSION, SS, LOG_HS, LOG_HS_DETAILS, WT_VERSION
         INTO P_EV_REC.OBJECT_LC, P_EV_REC.OBJECT_LC_VERSION, P_EV_REC.OBJECT_SS, 
              L_LOG_HS, L_LOG_HS_DETAILS, L_CONFIG_OBJECT_VERSION
         FROM UTWS
         WHERE WS = P_WS
         FOR UPDATE;      
         IF UNAPIEV.P_WT_VERSION IS NULL THEN
            UNAPIEV.P_WT_VERSION := L_CONFIG_OBJECT_VERSION;
         END IF;         
      ELSIF P_EV_REC.OBJECT_TP = 'ch' THEN
         SELECT LC, LC_VERSION, SS, LOG_HS, LOG_HS_DETAILS, CY_VERSION
         INTO P_EV_REC.OBJECT_LC, P_EV_REC.OBJECT_LC_VERSION, P_EV_REC.OBJECT_SS, 
              L_LOG_HS, L_LOG_HS_DETAILS, L_CONFIG_OBJECT_VERSION
         FROM UTCH
         WHERE CH = P_CH
         FOR UPDATE;      
         IF UNAPIEV.P_CY_VERSION IS NULL THEN
            UNAPIEV.P_CY_VERSION := L_CONFIG_OBJECT_VERSION;
         END IF;         
      
      ELSIF P_EV_REC.OBJECT_TP = 'pp' THEN
         IF P_VERSION IS NULL THEN
            L_SQLERRM := 'Warning:event has been generated for a configuration object without specifying a version (will result in wrong lc evaluation) !' ||
                         'object_tp='||P_EV_REC.OBJECT_TP || '#object_id='||P_EV_REC.OBJECT_ID|| '#version='||P_VERSION||'#ev_tp='||P_EV_REC.EV_TP;              
            INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
            VALUES(P_EV_REC.CLIENT_ID, P_EV_REC.APPLIC, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                   'EvalLifeCycle', L_SQLERRM);
         END IF;
         SELECT LC, LC_VERSION, SS, LOG_HS, LOG_HS_DETAILS
         INTO P_EV_REC.OBJECT_LC, P_EV_REC.OBJECT_LC_VERSION, P_EV_REC.OBJECT_SS, 
              L_LOG_HS, L_LOG_HS_DETAILS
         FROM UTPP
         WHERE PP = UNAPIEV.P_EV_REC.OBJECT_ID
         AND VERSION = UNAPIEV.P_VERSION
         AND PP_KEY1 = UNAPIEV.P_PP_KEY1
         AND PP_KEY2 = UNAPIEV.P_PP_KEY2
         AND PP_KEY3 = UNAPIEV.P_PP_KEY3
         AND PP_KEY4 = UNAPIEV.P_PP_KEY4
         AND PP_KEY5 = UNAPIEV.P_PP_KEY5
         FOR UPDATE;      
      ELSIF P_EV_REC.OBJECT_TP = 'eq' THEN
         IF P_VERSION IS NULL THEN
            L_SQLERRM := 'Warning:event has been generated for a configuration object without specifying a version (will result in wrong lc evaluation) !' ||
                         'object_tp='||P_EV_REC.OBJECT_TP || '#object_id='||P_EV_REC.OBJECT_ID|| '#version='||P_VERSION||'#ev_tp='||P_EV_REC.EV_TP;              
            INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
            VALUES(P_EV_REC.CLIENT_ID, P_EV_REC.APPLIC, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                   'EvalLifeCycle', L_SQLERRM);
         END IF;
         SELECT LC, LC_VERSION, SS, LOG_HS, LOG_HS_DETAILS
         INTO P_EV_REC.OBJECT_LC, P_EV_REC.OBJECT_LC_VERSION, P_EV_REC.OBJECT_SS, 
              L_LOG_HS, L_LOG_HS_DETAILS
         FROM UTEQ
         WHERE EQ = UNAPIEV.P_EV_REC.OBJECT_ID
         AND LAB = UNAPIEV.P_LAB
         AND VERSION = UNAPIEV.P_VERSION
         FOR UPDATE;      
      ELSE
         IF P_VERSION IS NULL THEN
            L_SQLERRM := 'Warning:event has been generated for a configuration object without specifying a version (will result in wrong lc evaluation) !' ||
                         'object_tp='||P_EV_REC.OBJECT_TP || '#object_id='||P_EV_REC.OBJECT_ID|| '#version='||P_VERSION||'#ev_tp='||P_EV_REC.EV_TP;              
            INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
            VALUES(P_EV_REC.CLIENT_ID, P_EV_REC.APPLIC, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                   'EvalLifeCycle', L_SQLERRM);
         END IF;
         IF P_EV_REC.OBJECT_TP <>'lc' THEN
            L_SQL_STRING :=  'SELECT lc, lc_version, ss, log_hs, log_hs_details FROM ut' || 
                             P_EV_REC.OBJECT_TP || ' WHERE ' || P_EV_REC.OBJECT_TP ||
                             ' = ''' || REPLACE(P_EV_REC.OBJECT_ID, '''', '''''') || '''' || 
                             ' AND version = ''' || REPLACE(P_VERSION, '''', '''''') || '''' || 
                             ' FOR UPDATE';                            
         ELSE
            L_SQL_STRING :=  'SELECT lc_lc, lc_lc_version, ss, log_hs, log_hs_details FROM ut' || 
                             P_EV_REC.OBJECT_TP || ' WHERE ' || P_EV_REC.OBJECT_TP ||
                             ' = ''' || REPLACE(P_EV_REC.OBJECT_ID, '''', '''''') || '''' || 
                             ' AND version = ''' || REPLACE(P_VERSION, '''', '''''') || '''' || 
                             ' FOR UPDATE';                            
         END IF;

         DBMS_SQL.PARSE(L_OBJ_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
         DBMS_SQL.DEFINE_COLUMN(L_OBJ_CURSOR, 1, L_LC, 2);
         DBMS_SQL.DEFINE_COLUMN(L_OBJ_CURSOR, 2, L_LC_VERSION, 20);         
         DBMS_SQL.DEFINE_COLUMN(L_OBJ_CURSOR, 3, L_SS, 2);         
         DBMS_SQL.DEFINE_COLUMN_CHAR(L_OBJ_CURSOR, 4, L_LOG_HS, 1);
         DBMS_SQL.DEFINE_COLUMN_CHAR(L_OBJ_CURSOR, 5, L_LOG_HS_DETAILS, 1);
         L_RESULT := DBMS_SQL.EXECUTE_AND_FETCH(L_OBJ_CURSOR);

         IF L_RESULT > 0 THEN
           DBMS_SQL.COLUMN_VALUE(L_OBJ_CURSOR, 1, L_LC);
           DBMS_SQL.COLUMN_VALUE(L_OBJ_CURSOR, 2, L_LC_VERSION);
           DBMS_SQL.COLUMN_VALUE(L_OBJ_CURSOR, 3, L_SS);
           DBMS_SQL.COLUMN_VALUE_CHAR(L_OBJ_CURSOR, 4, L_LOG_HS);
           DBMS_SQL.COLUMN_VALUE_CHAR(L_OBJ_CURSOR, 5, L_LOG_HS_DETAILS);
           P_EV_REC.OBJECT_LC := L_LC;
           P_EV_REC.OBJECT_LC_VERSION := L_LC_VERSION;
           P_EV_REC.OBJECT_SS := L_SS;
         ELSE
            P_EV_REC.OBJECT_LC := '';
            P_EV_REC.OBJECT_SS := '';
         END IF;

      END IF;
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
      
      NULL;
   END;
   
   
   IF (P_EV_REC.OBJECT_LC IS NULL) AND (P_EV_REC.OBJECT_TP <> 'dc') THEN
      
      


                      
      BEGIN
         SELECT UTOBJECTS.DEF_LC, UTLC.NAME, UTLC.VERSION
         INTO P_EV_REC.OBJECT_LC, L_LC_NAME, P_EV_REC.OBJECT_LC_VERSION 
         FROM UTOBJECTS, UTLC
         WHERE UTOBJECTS.OBJECT = P_EV_REC.OBJECT_TP
         AND   UTOBJECTS.DEF_LC = UTLC.LC
         AND   UTLC.VERSION_IS_CURRENT = '1';
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         IF P_EV_OUTPUT_ON THEN
             UNTRACE.LOG('   lc was null, not in DB => Default lc used ' ||
                                  P_EV_REC.OBJECT_LC || ' but no current version found');
         END IF;
         L_SQLERRM := '   lc was null, not in DB => Default lc used ' ||
                                  P_EV_REC.OBJECT_LC || ' but no current version found';
         INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
         VALUES(P_EV_REC.CLIENT_ID, P_EV_REC.APPLIC, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                'EvalLifeCycle', L_SQLERRM);
         
      END;
      
      IF P_EV_OUTPUT_ON THEN
          UNTRACE.LOG('   lc was null, not in DB => Default lc used ' ||
                               P_EV_REC.OBJECT_LC || '#version='||P_EV_REC.OBJECT_LC_VERSION);
      END IF;
   ELSE
      IF P_EV_OUTPUT_ON THEN
          UNTRACE.LOG('   lc from DB' );
      END IF;
   END IF;

   IF P_EV_REC.OBJECT_SS IS NULL THEN
      P_EV_REC.OBJECT_SS := '@~';
      IF P_EV_OUTPUT_ON THEN
         UNTRACE.LOG('   ss was null => set to ' ||
                              P_EV_REC.OBJECT_SS);
      END IF;
   END IF;

   IF P_EV_OUTPUT_ON THEN
      UNTRACE.LOG('   before (lc, lc_version, ss) : (' || P_EV_REC.OBJECT_LC || ',' || P_EV_REC.OBJECT_LC_VERSION || ',' ||
                           P_EV_REC.OBJECT_SS || ')' );
   END IF;
   
   IF UNAPIEV.P_STOPLCEVALUATION THEN
      IF P_EV_OUTPUT_ON THEN
         UNTRACE.LOG('   '||P_EV_REC.OBJECT_TP||' level - EvalLifeCycle stopped for this event ');
      END IF;
      RETURN(UNAPIGEN.DBERR_NOCHANGE);
   END IF;

   
   IF P_EV_REC.OBJECT_LC_VERSION IS NULL THEN
      BEGIN
         
         SELECT VERSION
         INTO P_EV_REC.OBJECT_LC_VERSION
         FROM UTLC
         WHERE LC = P_EV_REC.OBJECT_LC
         AND VERSION_IS_CURRENT = '1';
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
       
         IF NOT (P_EV_REC.OBJECT_TP = 'dc' AND NVL(P_EV_REC.OBJECT_LC, '@D') = '@D') THEN
            L_SQLERRM := '   lc version is null in event record but there is no current version for it !' ||
                         'lc='||P_EV_REC.OBJECT_LC || '#object_tp='||P_EV_REC.OBJECT_TP|| '#object_id='||P_EV_REC.OBJECT_ID||'#ev_tp='||P_EV_REC.EV_TP;
            INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
            VALUES(P_EV_REC.CLIENT_ID, P_EV_REC.APPLIC, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                   'EvalLifeCycle', L_SQLERRM);         
         END IF;         
      END;      
   END IF;

   
   UNAPIEV.P_LC_TR.LC := P_EV_REC.OBJECT_LC;
   UNAPIEV.P_LC_TR.LC_VERSION := P_EV_REC.OBJECT_LC_VERSION;
   UNAPIEV.P_LC_TR.SS_FROM := P_EV_REC.OBJECT_SS;
   
   L_LOOPED := FALSE;
   FOR L_TR IN L_TR_CURSOR LOOP
      L_LOOPED := TRUE;
      UNAPIEV.P_LC_TR.SS_TO := L_TR.SS_TO;
      UNAPIEV.P_LC_TR.TR_NO := L_TR.TR_NO;
      UNAPIEV.P_LC_TR.LC_SS_FROM := L_TR.SS_FROM;
      IF L_TR.CONDITION IS NULL THEN
         IF P_EV_OUTPUT_ON THEN
            UNTRACE.LOG('      transition without condition '||L_TR.TR_NO);
         END IF;
         L_TR_OK := TRUE;

      ELSE
         L_SQL_STRING := 'BEGIN :l_retcode := UNCONDITION.' || L_TR.CONDITION ||
                       '; END;';

         IF P_EV_OUTPUT_ON THEN
            UNTRACE.LOG('      transition (nr,condition) : (' || L_TR.TR_NO
                                 || ',' || L_TR.CONDITION || ')');
            UNTRACE.LOG('         '||L_SQL_STRING);
         END IF;

         BEGIN
            DBMS_SQL.PARSE(L_OBJ_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
            DBMS_SQL.BIND_VARIABLE(L_OBJ_CURSOR, ':l_retcode', L_RET_CODE);
            L_RESULT := DBMS_SQL.EXECUTE(L_OBJ_CURSOR);
            DBMS_SQL.VARIABLE_VALUE(L_OBJ_CURSOR, ':l_retcode', L_RET_CODE);
         EXCEPTION
         WHEN OTHERS THEN
            L_SQLERRM := SUBSTR(SQLERRM,1,255);
            INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
            VALUES(P_EV_REC.CLIENT_ID, P_EV_REC.APPLIC, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                   SUBSTR('UNCONDITION.' || L_TR.CONDITION,1,40), L_SQLERRM);
            L_RET_CODE := UNAPIGEN.DBERR_GENFAIL;
         END;

         IF P_EV_OUTPUT_ON THEN
            UNTRACE.LOG('         Condition '|| L_TR.CONDITION ||' returned : ' ||
                                 L_RET_CODE || ' (' || UNAPIGEN.DBERR_SUCCESS || 
                                 ' when successful)');
         END IF;

         IF L_RET_CODE = UNAPIGEN.DBERR_SUCCESS THEN
            L_TR_OK := TRUE;
         END IF;
      END IF;

      IF L_TR_OK = TRUE THEN
         A_TR_NO := L_TR.TR_NO;
         A_SS_TO := L_TR.SS_TO;
         P_LC_SS_FROM := L_TR.SS_FROM;  
                                        
         EXIT;
      ELSIF L_RET_CODE = UNAPIGEN.DBERR_STOPLCEVALUATION THEN
         UNAPIEV.P_STOPLCEVALUATION := TRUE;
         IF P_EV_OUTPUT_ON THEN
            UNTRACE.LOG('      '||P_EV_REC.OBJECT_TP || ' StopLcEvaluation returned by '|| L_TR.CONDITION);
         END IF;
         EXIT;
      ELSIF L_RET_CODE = UNAPIGEN.DBERR_STOPEVMGR THEN
         INTERNALSTOPALLMANAGERS;
         IF P_EV_OUTPUT_ON THEN
            UNTRACE.LOG('      '||'StopEvMgr returned by '|| L_TR.CONDITION||' , all event managers stopped');
         END IF;
         EXIT;
      END IF;
   END LOOP;

   IF L_LOOPED = FALSE THEN
      IF P_EV_REC.OBJECT_SS IN ('@~','@P', '@D') AND
         A_SS_TO IN ( '@~', '@P', '@D' ) THEN
            P_LC_TR := NULL;
            A_TR_NO := NULL;
            L_TR_OK := TRUE;
            IF P_EV_OUTPUT_ON THEN
               UNTRACE.LOG('      '||'Transition ' || P_EV_REC.OBJECT_SS || 
                                    ' TO ' || A_SS_TO ||' not configured but possible ' );
            END IF;
      END IF;
   END IF;

   IF L_TR_OK THEN
      IF L_LOG_HS = '1' THEN
         P_LOG_HS := TRUE;
      END IF;
      IF L_LOG_HS_DETAILS = '1' THEN
         P_LOG_HS_DETAILS := TRUE;
      END IF;
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   ELSE
      P_LC_TR := NULL;
      RETURN(UNAPIGEN.DBERR_NOCHANGE);
   END IF;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE = -60 THEN
      
      UNAPIGEN.P_DEADLOCK_RAISED := TRUE;
      
      IF UNAPIGEN.P_DEADLOCK_COUNT < UNAPIGEN.P_MAX_DEADLOCK_COUNT THEN
         RAISE;
      END IF;
   END IF;               
   L_SQLERRM := SUBSTR(SQLERRM,1,255);
   INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
   VALUES(P_EV_REC.CLIENT_ID, P_EV_REC.APPLIC, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
          'EvalLifeCycle', L_SQLERRM);
   L_TR_OK := FALSE;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END EVALLIFECYCLE;

FUNCTION EXECUTETRACTIONS                                  
(A_SS_FROM       IN VARCHAR2,                              
 A_SS_TO         IN VARCHAR2,                              
 A_TR_NO         IN NUMBER,                                
 A_TRANSITION_OK IN NUMBER)                                
RETURN NUMBER IS

L_TR_OK                  BOOLEAN;
L_PREV_SS_FROM           VARCHAR2(2);
L_LENGTH                 INTEGER;
L_AF_NAME                VARCHAR2(255);
L_AF_ID                  VARCHAR2(255);
L_PKG_NAME               VARCHAR2(255);
L_FIRST_TIME_IN_LOOP     BOOLEAN;

CURSOR L_AF_CURSOR IS
   SELECT AF, SS_FROM
   FROM UTLCAF
   WHERE LC = P_EV_REC.OBJECT_LC
     AND VERSION = P_EV_REC.OBJECT_LC_VERSION
     AND (SS_FROM = NVL(P_LC_SS_FROM,A_SS_FROM) OR SS_FROM = '@@')
     AND TR_NO = A_TR_NO
     AND SS_TO = A_SS_TO
   ORDER BY SS_FROM DESC, SEQ;

BEGIN

   
   
   
   
   
   
   
   
   
   IF (A_TRANSITION_OK <> UNAPIGEN.DBERR_SUCCESS) OR (A_TR_NO IS NULL) THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;

   SAVEPOINT_UNILAB4;
   L_PREV_SS_FROM := NULL;
   L_FIRST_TIME_IN_LOOP := TRUE;
   FOR L_AF IN L_AF_CURSOR LOOP
      
      
      IF L_FIRST_TIME_IN_LOOP THEN
        SAVEPOINT_UNILAB4;
        L_FIRST_TIME_IN_LOOP := FALSE;
      END IF;
      
      L_AF_ID := L_AF.AF;
   
      
      IF NVL(L_PREV_SS_FROM, L_AF.SS_FROM) = L_AF.SS_FROM THEN 

         IF P_EV_OUTPUT_ON THEN
            UNTRACE.LOG('            '||'Execution for action : ' || L_AF.AF);
         END IF;

         
         
         IF INSTR(L_AF.AF,'(') = 0 THEN
            L_LENGTH := LENGTH(L_AF.AF);
         ELSE
            L_LENGTH := INSTR(L_AF.AF,'(') - 1;
         END IF;
         L_AF_NAME := SUBSTR(L_AF.AF, 1, L_LENGTH);
         
         IF INSTR(L_AF_NAME,'.') = 0 THEN
            L_PKG_NAME := 'UNACTION.';
         ELSE
            L_PKG_NAME := '';
         END IF;

         L_SQL_STRING := 'BEGIN :l_retcode := ' || L_PKG_NAME || L_AF.AF ||
                         '; END;';

         IF P_EV_OUTPUT_ON THEN
            UNTRACE.LOG('            '||L_SQL_STRING);
         END IF;

         BEGIN
            DBMS_SQL.PARSE(L_OBJ_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
            DBMS_SQL.BIND_VARIABLE(L_OBJ_CURSOR, ':l_retcode', L_RET_CODE);
            L_RESULT := DBMS_SQL.EXECUTE(L_OBJ_CURSOR);
            DBMS_SQL.VARIABLE_VALUE(L_OBJ_CURSOR, ':l_retcode', L_RET_CODE);
         EXCEPTION
         WHEN OTHERS THEN
            IF SQLCODE = -60 THEN
               
               UNAPIGEN.P_DEADLOCK_RAISED := TRUE;
               
               IF UNAPIGEN.P_DEADLOCK_COUNT < UNAPIGEN.P_MAX_DEADLOCK_COUNT THEN
                  RAISE;
               END IF;
            END IF;               
            L_SQLERRM := SUBSTR(SQLERRM,1,255);
            INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
            VALUES(P_EV_REC.CLIENT_ID, P_EV_REC.APPLIC, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                   SUBSTR(L_PKG_NAME||L_AF.AF,1,40), L_SQLERRM);
            L_RET_CODE := UNAPIGEN.DBERR_GENFAIL;
         END;

         IF P_EV_OUTPUT_ON THEN
            UNTRACE.LOG('            '||'Action '|| L_AF.AF || ' returned : ' ||
                                 TO_CHAR(L_RET_CODE) || ' (0 when successful)');
         END IF;
         IF UNAPIGEN.P_LOG_LC_ACTIONS OR L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            BEGIN
            INSERT INTO UTEVLOG
            (TR_SEQ, EV_SEQ, EV_SESSION, CREATED_ON, CREATED_ON_TZ, CLIENT_ID, APPLIC,
             DBAPI_NAME, EVMGR_NAME, OBJECT_TP, OBJECT_ID,
             OBJECT_LC, OBJECT_LC_VERSION, OBJECT_SS, EV_TP, EV_DETAILS, EXECUTED_ON, EXECUTED_ON_TZ,
             ERRORCODE, WHAT, INSTANCE_NUMBER )
             VALUES (P_EV_REC.TR_SEQ, P_EV_REC.EV_SEQ, 
                     L_EV_SESSION, P_EV_REC.CREATED_ON, P_EV_REC.CREATED_ON,
                     P_EV_REC.CLIENT_ID, P_EV_REC.APPLIC,
                     P_EV_REC.DBAPI_NAME, UNAPIGEN.P_EVMGR_NAME,
                     P_EV_REC.OBJECT_TP, P_EV_REC.OBJECT_ID,
                     P_EV_REC.OBJECT_LC, P_EV_REC.OBJECT_LC_VERSION, A_SS_FROM,
                     P_EV_REC.EV_TP, P_EV_REC.EV_DETAILS, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                     L_RET_CODE, L_AF.AF, UNAPIGEN.P_INSTANCENR);

            EXCEPTION
            WHEN OTHERS THEN
               L_SQLERRM := SQLERRM;
               INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME,
                                   ERROR_MSG)
               VALUES (P_EV_REC.CLIENT_ID, P_EV_REC.APPLIC, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                    'ExecuteTrActions', L_SQLERRM);
            END;
         END IF;
         SAVEPOINT_UNILAB4;
         
         IF (L_RET_CODE = UNAPIGEN.DBERR_TRANSITION) AND 
            (INSTR(UNAPIEV.P_EV_REC.EV_DETAILS,'postpone_af') = 0) THEN
         
         
         
            IF UNAPIEV.P_EV_OUTPUT_ON THEN
               UNTRACE.LOG('            Action postponed to the end of the action queue');
            END IF;
            
            L_EV_SEQ_NR := -1;
            L_EV_DETAILS := UNAPIEV.P_EV_REC.EV_DETAILS ||
                            '#af='||L_AF.AF||
                            '#postpone_af='||TO_CHAR(UNAPIGEN.DBERR_TRANSITION);
            L_RESULT := UNAPIEV.INSERTEVENT(UNAPIEV.P_EV_REC.DBAPI_NAME, UNAPIGEN.P_EVMGR_NAME, 
                                            UNAPIEV.P_EV_REC.OBJECT_TP, UNAPIEV.P_EV_REC.OBJECT_ID, 
                                            UNAPIEV.P_EV_REC.OBJECT_LC, UNAPIEV.P_EV_REC.OBJECT_LC_VERSION,
                                            UNAPIEV.P_EV_REC.OBJECT_SS, UNAPIEV.P_EV_REC.EV_TP, 
                                            L_EV_DETAILS, L_EV_SEQ_NR);
            IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
               L_SQLERRM := SUBSTR(L_RESULT,1,230);
               INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
               VALUES(P_EV_REC.CLIENT_ID, P_EV_REC.APPLIC, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                      'ExecuteTrActions', 'InsertEvent returned '||L_SQLERRM);
               RETURN(UNAPIGEN.DBERR_GENFAIL);
            END IF;
            SAVEPOINT_UNILAB4;
            RETURN(UNAPIGEN.DBERR_SUCCESS);
         ELSIF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            IF L_RET_CODE = UNAPIGEN.DBERR_STOPEVMGR THEN
               INTERNALSTOPALLMANAGERS;
            END IF;
            SAVEPOINT_UNILAB4;
            RETURN(L_RET_CODE);
         END IF;
      L_PREV_SS_FROM := L_AF.SS_FROM;
      END IF;
   END LOOP;
   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   L_SQLERRM := SUBSTR(SQLERRM,1,255);
   INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
   VALUES(P_EV_REC.CLIENT_ID, P_EV_REC.APPLIC, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
          'ExecuteTrActions', L_SQLERRM);
   INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
   VALUES(P_EV_REC.CLIENT_ID, P_EV_REC.APPLIC, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
          'ExecuteTrActions', 'The last executed action was '||L_AF_ID||'.');
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END EXECUTETRACTIONS;

FUNCTION EXECUTEACTION                                     
(A_AF            IN VARCHAR2)                              
RETURN NUMBER IS

L_LENGTH       INTEGER;
L_AF_NAME      VARCHAR2(255);
L_PKG_NAME     VARCHAR2(255);
L_AF_CURSOR    INTEGER;

BEGIN

   

   
   
   IF INSTR(A_AF,'(') = 0 THEN
      L_LENGTH := LENGTH(A_AF);
   ELSE
      L_LENGTH := INSTR(A_AF,'(') - 1;
   END IF;
   L_AF_NAME := SUBSTR(A_AF, 1, L_LENGTH);
   
   IF INSTR(L_AF_NAME,'.') = 0 THEN
      L_PKG_NAME := 'UNACTION.';
   ELSE
      L_PKG_NAME := '';
   END IF;

   L_SQL_STRING := 'BEGIN :l_retcode := ' || L_PKG_NAME || A_AF ||
                   '; END;';

   IF P_EV_OUTPUT_ON THEN
      UNTRACE.LOG('            ExecuteAction: sql_string: '||L_SQL_STRING);
   END IF;
   
   BEGIN
      L_AF_CURSOR := DBMS_SQL.OPEN_CURSOR;
      DBMS_SQL.PARSE(L_AF_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
      DBMS_SQL.BIND_VARIABLE(L_AF_CURSOR, ':l_retcode', L_RET_CODE);
      L_RESULT := DBMS_SQL.EXECUTE(L_AF_CURSOR);
      DBMS_SQL.VARIABLE_VALUE(L_AF_CURSOR, ':l_retcode', L_RET_CODE);
      DBMS_SQL.CLOSE_CURSOR(L_AF_CURSOR);
   EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE = -60 THEN
         
         UNAPIGEN.P_DEADLOCK_RAISED := TRUE;
         
         IF UNAPIGEN.P_DEADLOCK_COUNT < UNAPIGEN.P_MAX_DEADLOCK_COUNT THEN
            RAISE;
         END IF;
      END IF;               
      L_SQLERRM := SUBSTR(SQLERRM,1,255);
      INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
      VALUES(P_EV_REC.CLIENT_ID, P_EV_REC.APPLIC, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
             SUBSTR(L_PKG_NAME||A_AF,1,40), L_SQLERRM);
      IF DBMS_SQL.IS_OPEN(L_AF_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_AF_CURSOR);
      END IF;
      L_RET_CODE := UNAPIGEN.DBERR_GENFAIL;
   END;

   IF P_EV_OUTPUT_ON THEN
      UNTRACE.LOG('            ExecuteAction: action '||A_AF||
                  ' returned : '||TO_CHAR(L_RET_CODE)||' (0 when successful)');
   END IF;
   
   IF (L_RET_CODE = UNAPIGEN.DBERR_TRANSITION) AND 
      (INSTR(UNAPIEV.P_EV_REC.EV_DETAILS,'postpone_af') = 0) THEN
   
   
   
      IF UNAPIEV.P_EV_OUTPUT_ON THEN
         UNTRACE.LOG('            Action postponed to the end of the action queue');
      END IF;

      L_EV_SEQ_NR := -1;
      L_EV_DETAILS := UNAPIEV.P_EV_REC.EV_DETAILS ||
                      '#af='||A_AF||
                      '#postpone_af='||TO_CHAR(UNAPIGEN.DBERR_TRANSITION);
      L_RESULT := UNAPIEV.INSERTEVENT(UNAPIEV.P_EV_REC.DBAPI_NAME, UNAPIGEN.P_EVMGR_NAME, 
                                      UNAPIEV.P_EV_REC.OBJECT_TP, UNAPIEV.P_EV_REC.OBJECT_ID, 
                                      UNAPIEV.P_EV_REC.OBJECT_LC, UNAPIEV.P_EV_REC.OBJECT_LC_VERSION,
                                      UNAPIEV.P_EV_REC.OBJECT_SS, UNAPIEV.P_EV_REC.EV_TP, 
                                      L_EV_DETAILS, L_EV_SEQ_NR);
      IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
         L_SQLERRM := SUBSTR(L_RESULT,1,230);
         INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
         VALUES(P_EV_REC.CLIENT_ID, P_EV_REC.APPLIC, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                'ExecuteAction', 'InsertEvent returned '||L_SQLERRM);
         RETURN(UNAPIGEN.DBERR_GENFAIL);
      END IF;
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   ELSIF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      IF L_RET_CODE = UNAPIGEN.DBERR_STOPEVMGR THEN
         INTERNALSTOPALLMANAGERS;
      END IF;
      RETURN(L_RET_CODE);
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
WHEN OTHERS THEN
   L_SQLERRM := SUBSTR(SQLERRM,1,255);
   INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
   VALUES(P_EV_REC.CLIENT_ID, P_EV_REC.APPLIC, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
          'ExecuteAction', L_SQLERRM);
   IF DBMS_SQL.IS_OPEN(L_AF_CURSOR) THEN
      DBMS_SQL.CLOSE_CURSOR(L_AF_CURSOR);
   END IF;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END EXECUTEACTION;

PROCEDURE PARSEEVENTDETAILS                                 
(A_EV_DETAILS          IN        VARCHAR2,                  
 A_QUALIFIER_TABLE     OUT       UNAPIGEN.VC255_TABLE_TYPE, 
 A_QUALIFIER_VAL_TABLE OUT       UNAPIGEN.VC255_TABLE_TYPE, 
 A_NR_OF_ROWS          OUT       NUMBER)                    
IS

   L_CROSS_POS      INTEGER;
   L_PREV_POS       INTEGER;
   L_QUALIFIER      VARCHAR2(255);
   L_QUALIFIER_VAL  VARCHAR2(255);
   L_LEAVE_LOOP     BOOLEAN;
   L_DETAIL         VARCHAR2(255);
   L_EQUAL_POS      INTEGER;
   L_NR_OF_ROWS     INTEGER;

BEGIN

   
   L_LEAVE_LOOP := FALSE;
   L_PREV_POS   := 0;
   L_NR_OF_ROWS := 0;
   WHILE (L_LEAVE_LOOP = FALSE) LOOP
      L_CROSS_POS := INSTR(A_EV_DETAILS, '#', L_PREV_POS + 1);
      IF (L_CROSS_POS <> 0) THEN
         L_DETAIL := SUBSTR(A_EV_DETAILS, L_PREV_POS+1, L_CROSS_POS-L_PREV_POS-1);
         L_PREV_POS := L_CROSS_POS;
      ELSE
         L_DETAIL := SUBSTR(A_EV_DETAILS, L_PREV_POS + 1);
         L_LEAVE_LOOP:= TRUE;
      END IF;
      IF (L_DETAIL IS NOT NULL) THEN
         L_EQUAL_POS := NVL(INSTR(L_DETAIL, '='), 0);
         IF L_EQUAL_POS NOT IN (0,1) THEN
            L_QUALIFIER     := SUBSTR(L_DETAIL, 1, L_EQUAL_POS - 1);
            L_QUALIFIER_VAL := SUBSTR(L_DETAIL, L_EQUAL_POS +1);
            IF L_QUALIFIER IS NOT NULL THEN
               L_NR_OF_ROWS := L_NR_OF_ROWS + 1;
               A_QUALIFIER_TABLE(L_NR_OF_ROWS)     := L_QUALIFIER;
               A_QUALIFIER_VAL_TABLE(L_NR_OF_ROWS) := L_QUALIFIER_VAL;
            END IF;
         END IF;
      END IF;
   END LOOP;
   A_NR_OF_ROWS := L_NR_OF_ROWS;
END PARSEEVENTDETAILS;

PROCEDURE FINDDETAIL                                       
(A_QUALIFIER_TABLE      IN      UNAPIGEN.VC255_TABLE_TYPE, 
 A_QUALIFIER_VAL_TABLE  IN      UNAPIGEN.VC255_TABLE_TYPE, 
 A_QUALIFIER_TO_FIND    IN      VARCHAR2,                  
 A_QUALIFIER_VAL_FOUND  OUT     VARCHAR2,                  
 A_NR_OF_ROWS           IN      NUMBER)                    
IS

L_INDEX          INTEGER;

BEGIN

   
   L_INDEX := 1;
   A_QUALIFIER_VAL_FOUND := '';
   WHILE (L_INDEX <= A_NR_OF_ROWS) LOOP
      IF (A_QUALIFIER_TABLE(L_INDEX) = A_QUALIFIER_TO_FIND) THEN
         A_QUALIFIER_VAL_FOUND := A_QUALIFIER_VAL_TABLE(L_INDEX);
         L_INDEX := A_NR_OF_ROWS + 1;
      END IF;
      L_INDEX := L_INDEX + 1;
   END LOOP;
END FINDDETAIL;

PROCEDURE FINDDETAIL                                       
(A_QUALIFIER_TABLE      IN      UNAPIGEN.VC255_TABLE_TYPE, 
 A_QUALIFIER_VAL_TABLE  IN      UNAPIGEN.VC255_TABLE_TYPE, 
 A_QUALIFIER_TO_FIND    IN      VARCHAR2,                  
 A_QUALIFIER_VAL_FOUND  OUT     NUMBER,                    
 A_NR_OF_ROWS           IN      NUMBER)                    
IS

   L_INDEX          INTEGER;

BEGIN

   
   L_INDEX := 1;
   A_QUALIFIER_VAL_FOUND := NULL;
   WHILE (L_INDEX <= A_NR_OF_ROWS) LOOP
      IF (A_QUALIFIER_TABLE(L_INDEX) = A_QUALIFIER_TO_FIND) THEN
         A_QUALIFIER_VAL_FOUND := TO_NUMBER(A_QUALIFIER_VAL_TABLE(L_INDEX));
         L_INDEX := A_NR_OF_ROWS + 1;
      END IF;
      L_INDEX := L_INDEX + 1;
   END LOOP;
END FINDDETAIL;

PROCEDURE EVALUATEEVENTDETAILS                               
(A_EV_SEQ               IN        NUMBER)                    
IS

L_SS_STR              VARCHAR2(255);

BEGIN

   
   
   UNAPIEV.PARSEEVENTDETAILS(UNAPIEV.P_EV_REC.EV_DETAILS, UNAPIEV2.L_QUALIFIER_TABLE, 
                             UNAPIEV2.L_QUALIFIER_VAL_TABLE, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
                             
   UNAPIEV.P_RQ := ''; UNAPIEV.P_OLD_RQ := '';
   UNAPIEV.P_SC := '';
   UNAPIEV.P_CH := '';
   UNAPIEV.P_WS := ''; 
   UNAPIEV.P_ROWNR := NULL; 
   UNAPIEV.P_IC := ''; UNAPIEV.P_ICNODE := NULL;
   UNAPIEV.P_II := ''; UNAPIEV.P_IINODE := NULL;
   UNAPIEV.P_PG := ''; UNAPIEV.P_PGNODE := NULL;
   UNAPIEV.P_PA := ''; UNAPIEV.P_PANODE := NULL;
   UNAPIEV.P_ME := ''; UNAPIEV.P_MENODE := NULL; UNAPIEV.P_REANALYSIS := NULL;
   UNAPIEV.P_SS_FROM := '';  UNAPIEV.P_TR_NO := NULL;
   UNAPIEV.P_LC_SS_FROM := '';
   UNAPIEV.P_NEW_VALUE := ''; UNAPIEV.P_OLD_VALUE := '';
   UNAPIEV.P_TD_INFO := NULL; UNAPIEV.P_TD_INFO_UNIT := '';
   UNAPIEV.P_ST := '';
   UNAPIEV.P_RT := '';
   UNAPIEV.P_WT := '';
   UNAPIEV.P_CF := '';
   UNAPIEV.P_EQ := ''; UNAPIEV.P_CT := '';
   UNAPIEV.P_OLD_CA_WARN_LEVEL := '';
   UNAPIEV.P_NEW_CA_WARN_LEVEL := '';
   UNAPIEV.P_CA := '';
   UNAPIEV.P_EQSC_EVALEQLC := TRUE;
   UNAPIEV.P_STOPLCEVALUATION := FALSE;
   UNAPIEV.P_NR_RESULTS := 0;
   UNAPIEV.P_VALID_SQC := ' ';
   UNAPIEV.P_VERSION := '';
   UNAPIEV.P_WT_VERSION := '';
   UNAPIEV.P_RT_VERSION := '';
   UNAPIEV.P_ST_VERSION := '';
   UNAPIEV.P_PP_VERSION := '';
   UNAPIEV.P_PR_VERSION := '';
   UNAPIEV.P_MT_VERSION := '';
   UNAPIEV.P_IP_VERSION := '';
   UNAPIEV.P_IE_VERSION := '';
   UNAPIEV.P_PP_KEY1 := '';
   UNAPIEV.P_PP_KEY2 := '';
   UNAPIEV.P_PP_KEY3 := '';
   UNAPIEV.P_PP_KEY4 := '';
   UNAPIEV.P_PP_KEY5 := '';   
   UNAPIEV.P_CY := '';
   UNAPIEV.P_CY_VERSION := '';
   UNAPIEV.P_SD := '';
   UNAPIEV.P_CSNODE := NULL;
   UNAPIEV.P_TPNODE := NULL;
   UNAPIEV.P_OLD_CURRENT_VERSION := '';
   UNAPIEV.P_ALARMS_HANDLED := '';
   UNAPIEV.P_AF := '';
   UNAPIEV.P_POSTPONE_AF := NULL;
   UNAPIEV.P_LC_TR := NULL;
   UNAPIEV.P_SDSCTPREACHED := NULL;
   UNAPIEV.P_UPDATE_NEXT_CELL := '0';
   UNAPIEV.P_UPDATE_ME_LAB := '';

   UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                      'ss_to', L_SS_STR,  UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
   UNAPIEV.P_SS_TO := SUBSTR(L_SS_STR, 1, 2);

   UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                      'af', UNAPIEV.P_AF, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
   UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                      'postpone_af', UNAPIEV.P_POSTPONE_AF, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);

   
   IF UNAPIEV.P_EV_REC.OBJECT_TP = 'rq' THEN
      UNAPIEV.P_RQ := UNAPIEV.P_EV_REC.OBJECT_ID;
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'rt', UNAPIEV.P_RT, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'rt_version', UNAPIEV.P_RT_VERSION, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);

      IF UNAPIEV.P_RT_VERSION IS NULL AND UNAPIEV.P_RT IS NOT NULL THEN
      
         INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
         VALUES(UNAPIEV.P_EV_REC.CLIENT_ID, UNAPIEV.P_EV_REC.APPLIC, UNAPIGEN.P_USER, 
                UNAPIEV2.L_CURRENT_TIMESTAMP, UNAPIEV2.L_CURRENT_TIMESTAMP, 
                SUBSTR('Ev~'||TO_CHAR(A_EV_SEQ)||'~'||UNAPIEV.P_EV_REC.EV_TP,1,40), 
                'rt_version missing or empty in ev_details for '||UNAPIEV.P_EV_REC.OBJECT_TP||'#'||
                UNAPIEV.P_EV_REC.EV_TP);
         SAVEPOINT_UNILAB4;
      END IF;

   ELSIF UNAPIEV.P_EV_REC.OBJECT_TP = 'sc' THEN
      UNAPIEV.P_SC := UNAPIEV.P_EV_REC.OBJECT_ID;
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'st', UNAPIEV.P_ST, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'st_version', UNAPIEV.P_ST_VERSION, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);

      IF UNAPIEV.P_ST_VERSION IS NULL AND UNAPIEV.P_ST IS NOT NULL THEN
      
         INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
         VALUES(UNAPIEV.P_EV_REC.CLIENT_ID, UNAPIEV.P_EV_REC.APPLIC, UNAPIGEN.P_USER, 
                UNAPIEV2.L_CURRENT_TIMESTAMP, UNAPIEV2.L_CURRENT_TIMESTAMP,  
                SUBSTR('Ev~'||TO_CHAR(A_EV_SEQ)||'~'||UNAPIEV.P_EV_REC.EV_TP,1,40), 
                'st_version missing or empty in ev_details for '||UNAPIEV.P_EV_REC.OBJECT_TP||'#'||
                UNAPIEV.P_EV_REC.EV_TP);
         SAVEPOINT_UNILAB4;
      END IF;

   ELSIF UNAPIEV.P_EV_REC.OBJECT_TP = 'ch' THEN
      UNAPIEV.P_CH := UNAPIEV.P_EV_REC.OBJECT_ID;
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'cy', UNAPIEV.P_CY, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'cy_version', UNAPIEV.P_CY_VERSION, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);

      IF UNAPIEV.P_CY_VERSION IS NULL THEN
      
         INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
         VALUES(UNAPIEV.P_EV_REC.CLIENT_ID, UNAPIEV.P_EV_REC.APPLIC, UNAPIGEN.P_USER, 
                UNAPIEV2.L_CURRENT_TIMESTAMP, UNAPIEV2.L_CURRENT_TIMESTAMP, 
                SUBSTR('Ev~'||TO_CHAR(A_EV_SEQ)||'~'||UNAPIEV.P_EV_REC.EV_TP,1,40), 
                'cy_version missing or empty in ev_details for '||UNAPIEV.P_EV_REC.OBJECT_TP||'#'||
                UNAPIEV.P_EV_REC.EV_TP);
         SAVEPOINT_UNILAB4;
      END IF;
   ELSIF UNAPIEV.P_EV_REC.OBJECT_TP = 'ws' THEN
      UNAPIEV.P_WS := UNAPIEV.P_EV_REC.OBJECT_ID;
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'wt', UNAPIEV.P_WT, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);                          
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'wt_version', UNAPIEV.P_WT_VERSION, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
      IF UNAPIEV.P_WT_VERSION IS NULL AND UNAPIEV.P_WT IS NOT NULL THEN
      
         INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
         VALUES(UNAPIEV.P_EV_REC.CLIENT_ID, UNAPIEV.P_EV_REC.APPLIC, UNAPIGEN.P_USER, 
                UNAPIEV2.L_CURRENT_TIMESTAMP,  UNAPIEV2.L_CURRENT_TIMESTAMP, 
                SUBSTR('Ev~'||TO_CHAR(A_EV_SEQ)||'~'||UNAPIEV.P_EV_REC.EV_TP,1,40), 
                'wt_version missing or empty in ev_details for '||UNAPIEV.P_EV_REC.OBJECT_TP||'#'||
                UNAPIEV.P_EV_REC.EV_TP);
         SAVEPOINT_UNILAB4;
      END IF;

   ELSIF UNAPIEV.P_EV_REC.OBJECT_TP IN ('ic', 'rqic', 'sdic') THEN
      UNAPIEV.P_IC := UNAPIEV.P_EV_REC.OBJECT_ID;
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'sc', UNAPIEV.P_SC, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'icnode', UNAPIEV.P_ICNODE, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'rq', UNAPIEV.P_RQ, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'sd', UNAPIEV.P_SD, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'ip_version', UNAPIEV.P_IP_VERSION, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);

      IF UNAPIEV.P_IP_VERSION IS NULL THEN
      
         INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
         VALUES(UNAPIEV.P_EV_REC.CLIENT_ID, UNAPIEV.P_EV_REC.APPLIC, UNAPIGEN.P_USER, 
                UNAPIEV2.L_CURRENT_TIMESTAMP,  UNAPIEV2.L_CURRENT_TIMESTAMP, 
                SUBSTR('Ev~'||TO_CHAR(A_EV_SEQ)||'~'||UNAPIEV.P_EV_REC.EV_TP,1,40), 
                'ip_version missing or empty in ev_details for '||UNAPIEV.P_EV_REC.OBJECT_TP||'#'||
                UNAPIEV.P_EV_REC.EV_TP);
         SAVEPOINT_UNILAB4;
      END IF;

   ELSIF UNAPIEV.P_EV_REC.OBJECT_TP IN ('ii','rqii', 'sdii') THEN
      UNAPIEV.P_II := UNAPIEV.P_EV_REC.OBJECT_ID;
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'sc', UNAPIEV.P_SC, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'icnode', UNAPIEV.P_ICNODE, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'ic', UNAPIEV.P_IC, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'iinode', UNAPIEV.P_IINODE, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'rq', UNAPIEV.P_RQ, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'sd', UNAPIEV.P_SD, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'new_value', UNAPIEV.P_NEW_VALUE, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'old_value', UNAPIEV.P_OLD_VALUE, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'ie_version', UNAPIEV.P_IE_VERSION, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);

      IF UNAPIEV.P_IE_VERSION IS NULL THEN
      
         INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
         VALUES(UNAPIEV.P_EV_REC.CLIENT_ID, UNAPIEV.P_EV_REC.APPLIC, UNAPIGEN.P_USER, 
                UNAPIEV2.L_CURRENT_TIMESTAMP, UNAPIEV2.L_CURRENT_TIMESTAMP,  
                SUBSTR('Ev~'||TO_CHAR(A_EV_SEQ)||'~'||UNAPIEV.P_EV_REC.EV_TP,1,40), 
                'ie_version missing or empty in ev_details for '||UNAPIEV.P_EV_REC.OBJECT_TP||'#'||
                UNAPIEV.P_EV_REC.EV_TP);
         SAVEPOINT_UNILAB4;
      END IF;

   ELSIF UNAPIEV.P_EV_REC.OBJECT_TP = 'pg' THEN
      UNAPIEV.P_PG := UNAPIEV.P_EV_REC.OBJECT_ID;
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'sc', UNAPIEV.P_SC, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'pgnode', UNAPIEV.P_PGNODE, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'pp_version', UNAPIEV.P_PP_VERSION, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);

      IF UNAPIEV.P_PP_VERSION IS NULL THEN
      
         INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
         VALUES(UNAPIEV.P_EV_REC.CLIENT_ID, UNAPIEV.P_EV_REC.APPLIC, UNAPIGEN.P_USER, 
                UNAPIEV2.L_CURRENT_TIMESTAMP, UNAPIEV2.L_CURRENT_TIMESTAMP, 
                SUBSTR('Ev~'||TO_CHAR(A_EV_SEQ)||'~'||UNAPIEV.P_EV_REC.EV_TP,1,40), 
                'pp_version missing or empty in ev_details for '||UNAPIEV.P_EV_REC.OBJECT_TP||'#'||
                UNAPIEV.P_EV_REC.EV_TP);
         SAVEPOINT_UNILAB4;
      END IF;

    ELSIF UNAPIEV.P_EV_REC.OBJECT_TP = 'pa' THEN
       UNAPIEV.P_PA := UNAPIEV.P_EV_REC.OBJECT_ID;
       UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                          'sc', UNAPIEV.P_SC, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
       UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                          'pg', UNAPIEV.P_PG, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
       UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                          'pgnode', UNAPIEV.P_PGNODE, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
       UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                          'panode', UNAPIEV.P_PANODE, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
       UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                          'pr_version', UNAPIEV.P_PR_VERSION, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);

      IF UNAPIEV.P_PR_VERSION IS NULL THEN
      
         INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
         VALUES(UNAPIEV.P_EV_REC.CLIENT_ID, UNAPIEV.P_EV_REC.APPLIC, UNAPIGEN.P_USER, 
                UNAPIEV2.L_CURRENT_TIMESTAMP,UNAPIEV2.L_CURRENT_TIMESTAMP,  
                SUBSTR('Ev~'||TO_CHAR(A_EV_SEQ)||'~'||UNAPIEV.P_EV_REC.EV_TP,1,40), 
                'pr_version missing or empty in ev_details for '||UNAPIEV.P_EV_REC.OBJECT_TP||'#'||
                UNAPIEV.P_EV_REC.EV_TP);
         SAVEPOINT_UNILAB4;
      END IF;


   ELSIF UNAPIEV.P_EV_REC.OBJECT_TP = 'me' THEN
      UNAPIEV.P_ME := UNAPIEV.P_EV_REC.OBJECT_ID;
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'sc', UNAPIEV.P_SC, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'pg', UNAPIEV.P_PG, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'pgnode', UNAPIEV.P_PGNODE, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'pa', UNAPIEV.P_PA, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'panode', UNAPIEV.P_PANODE, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'menode', UNAPIEV.P_MENODE, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'nr_results', UNAPIEV.P_NR_RESULTS, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'mt_version', UNAPIEV.P_MT_VERSION, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'reanalysis', UNAPIEV.P_REANALYSIS, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);

      IF UNAPIEV.P_MT_VERSION IS NULL THEN
      
         INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
         VALUES(UNAPIEV.P_EV_REC.CLIENT_ID, UNAPIEV.P_EV_REC.APPLIC, UNAPIGEN.P_USER, 
                UNAPIEV2.L_CURRENT_TIMESTAMP, UNAPIEV2.L_CURRENT_TIMESTAMP, 
                SUBSTR('Ev~'||TO_CHAR(A_EV_SEQ)||'~'||UNAPIEV.P_EV_REC.EV_TP,1,40), 
                'mt_version missing or empty in ev_details for '||UNAPIEV.P_EV_REC.OBJECT_TP||'#'||
                UNAPIEV.P_EV_REC.EV_TP);
         SAVEPOINT_UNILAB4;
      END IF;

   ELSIF UNAPIEV.P_EV_REC.OBJECT_TP = 'eq' THEN
      UNAPIEV.P_EQ := UNAPIEV.P_EV_REC.OBJECT_ID;
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'lab', UNAPIEV.P_LAB, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
      UNAPIEV.P_EQSC_EVALEQLC := FALSE;

      IF UNAPIEV.P_LAB IS NULL THEN
      
         INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
         VALUES(UNAPIEV.P_EV_REC.CLIENT_ID, UNAPIEV.P_EV_REC.APPLIC, UNAPIGEN.P_USER, 
                UNAPIEV2.L_CURRENT_TIMESTAMP, UNAPIEV2.L_CURRENT_TIMESTAMP,  
                SUBSTR('Ev~'||TO_CHAR(A_EV_SEQ)||'~'||UNAPIEV.P_EV_REC.EV_TP,1,40), 
                'warning lab missing or empty in ev_details for '||UNAPIEV.P_EV_REC.OBJECT_TP||'#'||
                UNAPIEV.P_EV_REC.EV_TP||'#lab=- will be used');
         UNAPIEV.P_LAB := '-';
         SAVEPOINT_UNILAB4;
      END IF;
      
   ELSIF UNAPIEV.P_EV_REC.OBJECT_TP = 'sd' THEN
      UNAPIEV.P_SD := UNAPIEV.P_EV_REC.OBJECT_ID;
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'pt', UNAPIEV.P_PT, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'pt_version', UNAPIEV.P_PT_VERSION, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'csnode', UNAPIEV.P_CSNODE, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'tpnode', UNAPIEV.P_TPNODE, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);

      IF UNAPIEV.P_PT_VERSION IS NULL AND UNAPIEV.P_PT IS NOT NULL THEN
      
         INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
         VALUES(UNAPIEV.P_EV_REC.CLIENT_ID, UNAPIEV.P_EV_REC.APPLIC, UNAPIGEN.P_USER, 
                UNAPIEV2.L_CURRENT_TIMESTAMP, UNAPIEV2.L_CURRENT_TIMESTAMP,
                SUBSTR('Ev~'||TO_CHAR(A_EV_SEQ)||'~'||UNAPIEV.P_EV_REC.EV_TP,1,40), 
                'pt_version missing or empty in ev_details for '||UNAPIEV.P_EV_REC.OBJECT_TP||'#'||
                UNAPIEV.P_EV_REC.EV_TP);
         SAVEPOINT_UNILAB4;
      END IF;
   ELSIF UNAPIEV.P_EV_REC.OBJECT_TP = 'pp' THEN
      
      
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'pp_key1', UNAPIEV.P_PP_KEY1, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'pp_key2', UNAPIEV.P_PP_KEY2, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'pp_key3', UNAPIEV.P_PP_KEY3, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'pp_key4', UNAPIEV.P_PP_KEY4, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'pp_key5', UNAPIEV.P_PP_KEY5, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);

      IF UNAPIEV.P_PP_KEY1 IS NULL OR
         UNAPIEV.P_PP_KEY2 IS NULL OR
         UNAPIEV.P_PP_KEY3 IS NULL OR
         UNAPIEV.P_PP_KEY4 IS NULL OR
         UNAPIEV.P_PP_KEY5 IS NULL THEN
      
         INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
         VALUES(UNAPIEV.P_EV_REC.CLIENT_ID, UNAPIEV.P_EV_REC.APPLIC, UNAPIGEN.P_USER, 
                UNAPIEV2.L_CURRENT_TIMESTAMP, UNAPIEV2.L_CURRENT_TIMESTAMP, 
                SUBSTR('Ev~'||TO_CHAR(A_EV_SEQ)||'~'||UNAPIEV.P_EV_REC.EV_TP,1,40), 
                'pp_key[1..5] missing or empty in ev_details for pp#'||
                UNAPIEV.P_EV_REC.EV_TP);
         SAVEPOINT_UNILAB4;
      END IF;
   END IF;

   
   UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                      'version', UNAPIEV.P_VERSION, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
   IF UNAPIEV.P_EV_REC.OBJECT_TP NOT IN ('ws', 'rq', 'rqic', 'rqii', 'sc', 'ic', 'ii', 
                                         'pg', 'pa', 'me', 'ch', 'sd', 'sdic', 'sdii', 
                                         'cs', 'lo', 'xslt') AND 
      UNAPIEV.P_VERSION IS NULL AND
      UNAPIEV.P_EV_REC.EV_TP NOT IN ('IgnoreThisEvent', 'LoadEvRules') THEN
      
         INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
         VALUES(UNAPIEV.P_EV_REC.CLIENT_ID, UNAPIEV.P_EV_REC.APPLIC, UNAPIGEN.P_USER, 
                UNAPIEV2.L_CURRENT_TIMESTAMP, UNAPIEV2.L_CURRENT_TIMESTAMP, 
                SUBSTR('Ev~'||TO_CHAR(A_EV_SEQ)||'~'||UNAPIEV.P_EV_REC.EV_TP,1,40), 
                'Version missing in ev_details for '||UNAPIEV.P_EV_REC.OBJECT_TP||'#'||
                UNAPIEV.P_EV_REC.EV_TP);
         SAVEPOINT_UNILAB4;
   END IF;

   
   IF UNAPIEV.P_EV_REC.EV_TP = 'ObjectBecomesCurrent' THEN
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'old_current_version', UNAPIEV.P_OLD_CURRENT_VERSION, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);

   ELSIF UNAPIEV.P_EV_REC.EV_TP LIKE '%StatusChanged' OR 
         UNAPIEV.P_EV_REC.EV_TP LIKE '%Canceled' OR
         UNAPIEV.P_EV_REC.EV_TP LIKE '%Reanalysis' THEN
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'tr_no', UNAPIEV.P_TR_NO, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'ss_from', L_SS_STR, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
      UNAPIEV.P_SS_FROM := SUBSTR(L_SS_STR, 1, 2);
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'lc_ss_from', L_SS_STR, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
      UNAPIEV.P_LC_SS_FROM := NVL(SUBSTR(L_SS_STR, 1, 2),UNAPIEV.P_SS_FROM);
      UNAPIEV.P_SS_TO := UNAPIEV.P_EV_REC.OBJECT_SS;
      
      IF UNAPIEV.P_EV_REC.EV_TP = 'MeReanalysis' THEN
         UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                            'new_reanalysis', UNAPIEV.P_REANALYSIS, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
      END IF;
      
   ELSIF UNAPIEV.P_EV_REC.EV_TP IN ('RequestCopied') THEN
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'rq_from', UNAPIEV.P_SC_FROM, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
   
   ELSIF UNAPIEV.P_EV_REC.EV_TP IN ('SampleUpdated', 'ScInfoCreated', 'ScAnalysesCreated',
                                    'ScGroupKeyUpdated', 'ScAttributesUpdated', 
                                    'ScAccessRightsUpdated', 'SampleCopied') THEN
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'sc_from', UNAPIEV.P_SC_FROM, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
   
   ELSIF UNAPIEV.P_EV_REC.EV_TP = 'ScRequestModified' THEN
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'old_rq', UNAPIEV.P_OLD_RQ, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
   
   ELSIF UNAPIEV.P_EV_REC.EV_TP = 'TrendInfoUpdated' THEN
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'td_info', UNAPIEV.P_TD_INFO, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'td_info_unit', UNAPIEV.P_TD_INFO_UNIT, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'st', UNAPIEV.P_ST, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
   
   ELSIF UNAPIEV.P_EV_REC.EV_TP IN ('EqWarnLevelChanged', 'EqCaWarnLevelChanged' ) THEN
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'old_ca_warn_level', UNAPIEV.P_OLD_CA_WARN_LEVEL, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'new_ca_warn_level', UNAPIEV.P_NEW_CA_WARN_LEVEL, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'ca', UNAPIEV.P_CA, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);

   ELSIF UNAPIEV.P_EV_REC.EV_TP = 'EqCaMethodCreated' THEN
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'ca', UNAPIEV.P_CA, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'st', UNAPIEV.P_ST, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'mt', UNAPIEV.P_MT, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'sc', UNAPIEV.P_SC, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'pg', UNAPIEV.P_PG, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'pgnode', UNAPIEV.P_PGNODE, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'pa', UNAPIEV.P_PA, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'panode', UNAPIEV.P_PANODE, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'me', UNAPIEV.P_ME, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'menode', UNAPIEV.P_MENODE, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);

   ELSIF UNAPIEV.P_EV_REC.EV_TP IN ('Eq1ConstantCreated', 'Eq1ConstantUpdated', 'EqConstantsUpdated') THEN
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'ct', UNAPIEV.P_CT, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
   
   ELSIF UNAPIEV.P_EV_REC.EV_TP IN ('WsRowCreated', 'WsRowUpdated', 'WsRowDeleted', 'WsSampleCreated') THEN
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'rownr', UNAPIEV.P_ROWNR, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'sc', UNAPIEV.P_SC, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);

   ELSIF UNAPIEV.P_EV_REC.EV_TP IN ('PaSpecsUpdated','PaResultUpdated') THEN
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'alarms_handled', UNAPIEV.P_ALARMS_HANDLED, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
   
   ELSIF UNAPIEV.P_EV_REC.EV_TP IN ('SdCellSampleAdded', 'SdCellSampleLocationUpdated', 'SdCellSamplesUpdated', 'SdCellSampleDeleted','SdCellSampleLocationEnded') THEN
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'sc', UNAPIEV.P_SC, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
   ELSIF UNAPIEV.P_EV_REC.EV_TP = 'SdScTpReachedSet' THEN
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'SdScTpReached', UNAPIEV.P_SDSCTPREACHED, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'sd', UNAPIEV.P_SD, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'csnode', UNAPIEV.P_CSNODE, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
   ELSIF UNAPIEV.P_EV_REC.EV_TP IN ('MeDetailsCreated') THEN
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'updnextce', UNAPIEV.P_UPDATE_NEXT_CELL, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
   ELSIF UNAPIEV.P_EV_REC.EV_TP IN ('EvaluateMeDetails') THEN
      UNAPIEV.FINDDETAIL(UNAPIEV2.L_QUALIFIER_TABLE, UNAPIEV2.L_QUALIFIER_VAL_TABLE,
                         'updmelab', UNAPIEV.P_UPDATE_ME_LAB, UNAPIEV2.L_QUALIFIER_NR_OF_ROWS);
   END IF;
   
   
   IF UNAPIEV.P_SS_TO IS NOT NULL THEN
      UNAPIEV.P_LC_TR.SS_TO := UNAPIEV.P_SS_TO;
      UNAPIEV.P_LC_TR.LC := UNAPIEV.P_EV_REC.OBJECT_LC;
      UNAPIEV.P_LC_TR.LC_VERSION := UNAPIEV.P_EV_REC.OBJECT_LC_VERSION;
   END IF;
   IF UNAPIEV.P_SS_FROM IS NOT NULL THEN
      UNAPIEV.P_LC_TR.SS_FROM := UNAPIEV.P_SS_FROM;
   END IF;
   IF UNAPIEV.P_LC_SS_FROM IS NOT NULL THEN
      UNAPIEV.P_LC_TR.LC_SS_FROM := UNAPIEV.P_LC_SS_FROM;
   END IF;
   IF UNAPIEV.P_TR_NO IS NOT NULL THEN
      UNAPIEV.P_LC_TR.TR_NO := UNAPIEV.P_TR_NO;
   END IF;         
   
END EVALUATEEVENTDETAILS;

PROCEDURE UPDATEOBJECTRECORD                     
(A_SS_TO IN VARCHAR2)                            
IS

L_ALLOW_MODIFY                CHAR(1);
L_ACTIVE                      CHAR(1);
L_SS_FROM_NAME                VARCHAR2(20);
L_SS_TO_NAME                  VARCHAR2(20);
L_WHY                         VARCHAR2(20);
L_CURRENT_STRING              VARCHAR2(40);
L_SS_FORCED                   BOOLEAN;
L_NEW_ALLOW_MODIFY    CHAR(1);

BEGIN

   
   
   IF A_SS_TO IS NOT NULL THEN
      L_SS_FORCED := FALSE;
      IF A_SS_TO NOT IN ( '@~', '@P', '@D' ) AND 
         P_TR_NO IS NULL THEN
         L_SS_FORCED := TRUE;
      END IF;
      BEGIN
         SELECT ALLOW_MODIFY, ACTIVE
         INTO L_ALLOW_MODIFY, L_ACTIVE
         FROM UTSS
         WHERE SS = A_SS_TO;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         L_SQLERRM :=  'status '||A_SS_TO|| ' that was specified in event details does not exit in db';
         RAISE STPERROR;
      END;
      
      

      L_CURRENT_STRING := NULL;
      FOR I IN 1..UNAPIGEN.L_NR_OF_TYPES LOOP
         IF UNAPIGEN.L_OBJECT_TYPES(I) = P_EV_REC.OBJECT_TP THEN
            IF UNAPIGEN.ISSYSTEM21CFR11COMPLIANT <> UNAPIGEN.DBERR_SUCCESS THEN
               L_CURRENT_STRING := ', version_is_current = ''1''';
            END IF;
         END IF;
      END LOOP;

      IF P_EV_REC.OBJECT_TP = 'pp' THEN
         UPDATE UTPP
         SET LC = P_EV_REC.OBJECT_LC,
             LC_VERSION = P_EV_REC.OBJECT_LC_VERSION,
             SS = A_SS_TO,
             ALLOW_MODIFY = L_ALLOW_MODIFY,
             ACTIVE = L_ACTIVE,
             VERSION_IS_CURRENT = DECODE(L_CURRENT_STRING, NULL, VERSION_IS_CURRENT, '1')
         WHERE PP = P_EV_REC.OBJECT_ID
         AND VERSION = UNAPIEV.P_VERSION
         AND PP_KEY1 = UNAPIEV.P_PP_KEY1
         AND PP_KEY2 = UNAPIEV.P_PP_KEY2
         AND PP_KEY3 = UNAPIEV.P_PP_KEY3
         AND PP_KEY4 = UNAPIEV.P_PP_KEY4
         AND PP_KEY5 = UNAPIEV.P_PP_KEY5;
         IF P_EV_OUTPUT_ON THEN
            UNTRACE.LOG('      '||'Updating (lc,lc_version,ss,allow_modify,active) for pp=' ||  P_EV_REC.OBJECT_ID ||
                                 '#version= '|| P_VERSION ||
                                 '#pp_key1= '|| P_PP_KEY1 ||
                                 '#pp_key2= '|| P_PP_KEY2 ||
                                 '#pp_key3= '|| P_PP_KEY3 ||
                                 '#pp_key4= '|| P_PP_KEY4 ||
                                 '#pp_key5= '|| P_PP_KEY5 ||
                                 ' ( ' || P_EV_REC.OBJECT_LC || ',' || P_EV_REC.OBJECT_LC_VERSION ||
                                 ',' || A_SS_TO || ',' || L_ALLOW_MODIFY || ',' ||
                                 L_ACTIVE || ')' );
         END IF;
         IF SQL%ROWCOUNT = 0 THEN      
            L_SQLERRM := 'No record updated in UpdateObjectRecord! for pp='||
                          P_EV_REC.OBJECT_ID || '#version='|| P_VERSION||
                          '#pp_key1='||P_PP_KEY1||
                          '#pp_key2='||P_PP_KEY2||
                          '#pp_key3='||P_PP_KEY3||
                          '#pp_key4='||P_PP_KEY4||
                          '#pp_key5='||P_PP_KEY5;
            RAISE STPERROR;
         END IF;
      ELSIF P_EV_REC.OBJECT_TP = 'eq' THEN
         UPDATE UTEQ
         SET LC = P_EV_REC.OBJECT_LC,
             LC_VERSION = P_EV_REC.OBJECT_LC_VERSION,
             SS = A_SS_TO,
             ALLOW_MODIFY = L_ALLOW_MODIFY,
             ACTIVE = L_ACTIVE,
             VERSION_IS_CURRENT = DECODE(L_CURRENT_STRING, NULL, VERSION_IS_CURRENT, '1')
         WHERE EQ = P_EV_REC.OBJECT_ID
         AND LAB = UNAPIEV.P_LAB
         AND VERSION = UNAPIEV.P_VERSION;
         IF P_EV_OUTPUT_ON THEN
            UNTRACE.LOG('      '||'Updating (lc,lc_version,ss,allow_modify,active) for eq=' ||  P_EV_REC.OBJECT_ID ||
                                 '#lab= '|| P_LAB ||
                                 '#version= '|| P_VERSION ||
                                 ' ( ' || P_EV_REC.OBJECT_LC || ',' || P_EV_REC.OBJECT_LC_VERSION ||
                                 ',' || A_SS_TO || ',' || L_ALLOW_MODIFY || ',' ||
                                 L_ACTIVE || ')' );
         END IF;
         IF SQL%ROWCOUNT = 0 THEN      
            L_SQLERRM := 'No record updated in UpdateObjectRecord! for eq='||
                          P_EV_REC.OBJECT_ID || 
                          '#lab= '|| P_LAB ||
                          '#version='|| P_VERSION;
            RAISE STPERROR;
         END IF;
      ELSE
         IF P_EV_REC.OBJECT_TP = 'lc' THEN
           L_SQL_STRING :=  'UPDATE ut' || P_EV_REC.OBJECT_TP ||
                             ' SET lc_lc = :a_lc' ||                 
                             ', lc_lc_version = :a_lc_version' ||    
                             ', ss = :a_ss_to' ||                    
                             ', allow_modify = :a_allow_modify' ||   
                             ', active = :a_active' ||               
                             L_CURRENT_STRING ||                     
                             ' WHERE ' || P_EV_REC.OBJECT_TP ||      
                             ' = :a_object_id' ||                    
                             ' AND version = :a_version';            
         ELSIF P_EV_REC.OBJECT_TP = 'ad' THEN
            L_SQL_STRING :=  'UPDATE utad SET lc = :a_lc' ||         
                             ', lc_version = :a_lc_version' ||       
                             ', ss = :a_ss_to' ||                    
                             ', allow_modify = :a_allow_modify' ||   
                             ', active = :a_active' ||               
                             L_CURRENT_STRING ||                     
                             ' WHERE ad = :a_object_id' ||           
                             ' AND version = :a_version';            
         ELSE
            L_SQL_STRING :=  'UPDATE ut' || P_EV_REC.OBJECT_TP ||
                             ' SET lc = :a_lc' ||                    
                             ', lc_version = :a_lc_version' ||       
                             ', ss = :a_ss_to' ||                    
                             ', allow_modify = :a_allow_modify' ||   
                             ', active = :a_active' ||               
                             L_CURRENT_STRING ||                     
                             ' WHERE ' || P_EV_REC.OBJECT_TP ||      
                             ' = :a_object_id' ||                    
                             ' AND version = :a_version';            
         END IF;
         IF P_EV_OUTPUT_ON THEN
            UNTRACE.LOG('      '||'Updating (lc,lc_version,ss,allow_modify,active) for ' ||P_EV_REC.OBJECT_TP || '=' ||
                                 P_EV_REC.OBJECT_ID || '#version= '|| P_VERSION || '( ' || P_EV_REC.OBJECT_LC || ',' || P_EV_REC.OBJECT_LC_VERSION ||
                                 ',' || A_SS_TO || ',' || L_ALLOW_MODIFY || ',' ||
                                 L_ACTIVE || ')' );
         END IF;
         DBMS_SQL.PARSE(L_OBJ_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
         DBMS_SQL.BIND_VARIABLE(L_OBJ_CURSOR, ':a_lc', P_EV_REC.OBJECT_LC);
         DBMS_SQL.BIND_VARIABLE(L_OBJ_CURSOR, ':a_lc_version', P_EV_REC.OBJECT_LC_VERSION);
         DBMS_SQL.BIND_VARIABLE(L_OBJ_CURSOR, ':a_ss_to', A_SS_TO);
         DBMS_SQL.BIND_VARIABLE_CHAR(L_OBJ_CURSOR, ':a_allow_modify', L_ALLOW_MODIFY);
         DBMS_SQL.BIND_VARIABLE_CHAR(L_OBJ_CURSOR, ':a_active', L_ACTIVE);
         DBMS_SQL.BIND_VARIABLE(L_OBJ_CURSOR, ':a_object_id', P_EV_REC.OBJECT_ID);
         DBMS_SQL.BIND_VARIABLE(L_OBJ_CURSOR, ':a_version', P_VERSION);
         L_RESULT := DBMS_SQL.EXECUTE(L_OBJ_CURSOR);

         IF L_RESULT = 0 AND P_EV_REC.OBJECT_TP<>'eq' AND P_EV_REC.OBJECT_ID<>'-' THEN      
            L_SQLERRM := 'No record updated in UpdateObjectRecord! (wrong allow_modify in db) for '||
                          P_EV_REC.OBJECT_TP || '='''|| P_EV_REC.OBJECT_ID || ''' AND version= '''|| P_VERSION||'''';
            RAISE STPERROR;
         END IF;         
      END IF;
     IF UNAPIGEN.ISSYSTEMSUPPORTINGRNDSUITE = UNAPIGEN.DBERR_SUCCESS THEN
         IF P_EV_REC.OBJECT_TP IN ('ie','dc') THEN
            
            IF P_EV_OUTPUT_ON THEN
               UNTRACE.LOG('      '||'Calling RNDAPIPRP.UpdateObjectSoList for object_tp=' ||  P_EV_REC.OBJECT_TP ||
                                    '#object_id= '|| P_EV_REC.OBJECT_ID ||
                                    '#version= '|| P_VERSION);
            END IF;
            BEGIN
               EXECUTE IMMEDIATE 'DECLARE l_ret_code INTEGER; BEGIN :l_ret_code := RNDAPIPRP.UpdateObjectSoList(:object_tp, :object_id, :object_version); END;'
               USING OUT L_RET_CODE, IN P_EV_REC.OBJECT_TP, IN P_EV_REC.OBJECT_ID, IN P_VERSION;
            EXCEPTION
            WHEN OTHERS THEN
               L_SQLERRM := SQLERRM;
               INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
               VALUES (P_EV_REC.CLIENT_ID,
                       P_EV_REC.APPLIC,
                       UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                       'UpdateObjectRecord', 'Error calling RNDAPIPRP.UpdateObjectSoList for object_tp=' ||  P_EV_REC.OBJECT_TP ||
                                    '#object_id= '|| P_EV_REC.OBJECT_ID ||
                                    '#version= '|| P_VERSION);
               INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
               VALUES (P_EV_REC.CLIENT_ID,
                       P_EV_REC.APPLIC,
                       UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                       'UpdateObjectRecord', L_SQLERRM);               
            END;
            IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
               INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
               VALUES (P_EV_REC.CLIENT_ID,
                       P_EV_REC.APPLIC,
                       UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                       'UpdateObjectRecord', 'ret_code='||L_RET_CODE||'for call to RNDAPIRQP.UpdateRqSoList for object_tp=' ||  P_EV_REC.OBJECT_TP ||
                                             '#object_id= '|| P_EV_REC.OBJECT_ID ||'#version= '|| P_VERSION);
            END IF;
         END IF;
      END IF;
   ELSE
      IF P_EV_REC.OBJECT_TP = 'pp' THEN
         BEGIN
            SELECT ALLOW_MODIFY 
            INTO L_NEW_ALLOW_MODIFY
            FROM UTSS 
            WHERE SS =P_EV_REC.OBJECT_SS;
         EXCEPTION
         WHEN NO_DATA_FOUND THEN
            L_NEW_ALLOW_MODIFY := NULL;
         END;
         UPDATE UTPP
         SET ALLOW_MODIFY = NVL(L_NEW_ALLOW_MODIFY,'0')
         WHERE PP = P_EV_REC.OBJECT_ID
         AND VERSION = UNAPIEV.P_VERSION
         AND PP_KEY1 = UNAPIEV.P_PP_KEY1
         AND PP_KEY2 = UNAPIEV.P_PP_KEY2
         AND PP_KEY3 = UNAPIEV.P_PP_KEY3
         AND PP_KEY4 = UNAPIEV.P_PP_KEY4
         AND PP_KEY5 = UNAPIEV.P_PP_KEY5;
         IF SQL%ROWCOUNT = 0 THEN      
            L_SQLERRM := 'No record updated in UpdateObjectRecord! for pp='||
                          P_EV_REC.OBJECT_ID || '#version='|| P_VERSION||
                          '#pp_key1='||P_PP_KEY1||
                          '#pp_key2='||P_PP_KEY2||
                          '#pp_key3='||P_PP_KEY3||
                          '#pp_key4='||P_PP_KEY4||
                          '#pp_key5='||P_PP_KEY5;
            RAISE STPERROR;
         END IF;
      ELSIF P_EV_REC.OBJECT_TP = 'eq' THEN
         BEGIN
            SELECT ALLOW_MODIFY 
            INTO L_NEW_ALLOW_MODIFY
            FROM UTSS 
            WHERE SS =P_EV_REC.OBJECT_SS;
         EXCEPTION
         WHEN NO_DATA_FOUND THEN
            L_NEW_ALLOW_MODIFY := NULL;
         END;
         UPDATE UTEQ
         SET ALLOW_MODIFY = NVL(L_NEW_ALLOW_MODIFY,'0')
         WHERE EQ = P_EV_REC.OBJECT_ID
         AND LAB = UNAPIEV.P_LAB
         AND VERSION = UNAPIEV.P_VERSION;
         IF SQL%ROWCOUNT = 0 THEN      
            L_SQLERRM := 'No record updated in UpdateObjectRecord! for eq='||
                          P_EV_REC.OBJECT_ID || 
                          '#lab='|| P_LAB||
                          '#version='|| P_VERSION;
            RAISE STPERROR;
         END IF;
      ELSE
         IF P_EV_REC.OBJECT_TP = 'ad' THEN
            L_SQL_STRING :=  'UPDATE utad' ||                                        
                             ' SET allow_modify = NVL((SELECT allow_modify FROM utss ' ||
                                                  'WHERE ss = NVL(:a_ss, utad.ss)),''0'')' || 
                             ' WHERE ad = :a_object_id' || 
                             ' AND version = :a_version' ; 
         ELSE
            L_SQL_STRING :=  'UPDATE ut' || P_EV_REC.OBJECT_TP ||
                             ' SET allow_modify = NVL((SELECT allow_modify FROM utss ' ||
                                                  'WHERE ss = NVL(:a_ss,ut'||P_EV_REC.OBJECT_TP||'.ss)),''0'')' || 
                             ' WHERE ' || P_EV_REC.OBJECT_TP ||' = :a_object_id' || 
                             ' AND version = :a_version' ; 
         END IF; 
         DBMS_SQL.PARSE(L_OBJ_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
         DBMS_SQL.BIND_VARIABLE(L_OBJ_CURSOR, ':a_ss', P_EV_REC.OBJECT_SS);
         DBMS_SQL.BIND_VARIABLE(L_OBJ_CURSOR, ':a_object_id', P_EV_REC.OBJECT_ID);
         DBMS_SQL.BIND_VARIABLE(L_OBJ_CURSOR, ':a_version', P_VERSION);
         IF P_EV_OUTPUT_ON THEN
            UNTRACE.LOG('      '||'Updating allow_modify for ('|| P_EV_REC.OBJECT_TP || ' '
                                || P_EV_REC.OBJECT_ID || '#version= '|| P_VERSION ||
                                 ') =f(status= ' || P_EV_REC.OBJECT_SS || ')' );
         END IF;
         L_RESULT := DBMS_SQL.EXECUTE(L_OBJ_CURSOR);

         IF L_RESULT = 0 AND P_EV_REC.OBJECT_TP<>'eq' AND P_EV_REC.OBJECT_ID<>'-' THEN      
            L_SQLERRM := 'No record updated in UpdateObjectRecord! (wrong allow_modify in db) for '||
                          P_EV_REC.OBJECT_TP || '='''|| P_EV_REC.OBJECT_ID || ''' AND version= '''|| P_VERSION||'''';
            RAISE STPERROR;
         END IF;
      END IF;
   END IF;

   
   
   
   IF A_SS_TO IS NOT NULL AND P_LOG_HS THEN
      
      L_SS_FROM_NAME := UNAPIGEN.SQLSSNAME(P_EV_REC.OBJECT_SS);
      L_SS_TO_NAME := UNAPIGEN.SQLSSNAME(A_SS_TO);
      L_WHY := NULL;
      
      
      IF P_EV_REC.OBJECT_TP = 'pp' THEN
         INSERT INTO UTPPHS
         (PP, VERSION, PP_KEY1, PP_KEY2, PP_KEY3, PP_KEY4, PP_KEY5,
          WHO, WHO_DESCRIPTION, 
          WHAT, WHAT_DESCRIPTION, 
          LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
          VALUES
          (P_EV_REC.OBJECT_ID, P_VERSION, P_PP_KEY1, P_PP_KEY2, P_PP_KEY3, P_PP_KEY4, P_PP_KEY5,
           P_EV_REC.USERNAME, UNAPIGEN.SQLUSERDESCRIPTION(P_EV_REC.USERNAME),
           'EvMgrStatusChanged', 'status of '||UNAPIGEN.GETOBJTPDESCRIPTION('pp')||' "'||
                                    P_EV_REC.OBJECT_ID||'" is automatically changed from "'||L_SS_FROM_NAME||
                                    '" ['||P_EV_REC.OBJECT_SS||'] to "'||L_SS_TO_NAME||'" ['||A_SS_TO||'].',
           CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, L_WHY, UNAPIGEN.P_TR_SEQ, P_EV_REC.EV_SEQ);                         
      ELSIF P_EV_REC.OBJECT_TP = 'eq' THEN
         INSERT INTO UTEQHS
         (EQ, LAB, VERSION,
          WHO, WHO_DESCRIPTION, 
          WHAT, WHAT_DESCRIPTION, 
          LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
          VALUES
          (P_EV_REC.OBJECT_ID, P_LAB, P_VERSION,
           P_EV_REC.USERNAME, UNAPIGEN.SQLUSERDESCRIPTION(P_EV_REC.USERNAME),
           'EvMgrStatusChanged', 'status of '||UNAPIGEN.GETOBJTPDESCRIPTION('eq')||' "'||
                                    P_EV_REC.OBJECT_ID||'" is automatically changed from "'||L_SS_FROM_NAME||
                                    '" ['||P_EV_REC.OBJECT_SS||'] to "'||L_SS_TO_NAME||'" ['||A_SS_TO||'].',
           CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, L_WHY, UNAPIGEN.P_TR_SEQ, P_EV_REC.EV_SEQ);                         
      ELSE
         L_SQL_STRING := 'INSERT INTO ut' || P_EV_REC.OBJECT_TP || 'hs' ||
                         '(' || P_EV_REC.OBJECT_TP || ', version, who, who_description, '||
                           'what, what_description, logdate, logdate_tz, why, tr_seq, ev_seq)' ||
                         'VALUES(:object_id, :version, :who, :who_description, '||
                           ':what, :what_description, :logdate, :logdate_tz, :why, :tr_seq, :ev_seq)';                        
         DBMS_SQL.PARSE(L_OBJ_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
         DBMS_SQL.BIND_VARIABLE(L_OBJ_CURSOR, ':object_id', P_EV_REC.OBJECT_ID);
         DBMS_SQL.BIND_VARIABLE(L_OBJ_CURSOR, ':version', P_VERSION);
         DBMS_SQL.BIND_VARIABLE(L_OBJ_CURSOR, ':who', P_EV_REC.USERNAME);
         DBMS_SQL.BIND_VARIABLE(L_OBJ_CURSOR, ':who_description', UNAPIGEN.SQLUSERDESCRIPTION(P_EV_REC.USERNAME));
         DBMS_SQL.BIND_VARIABLE(L_OBJ_CURSOR, ':what', 'EvMgrStatusChanged');
         DBMS_SQL.BIND_VARIABLE(L_OBJ_CURSOR, ':what_description', 'status of '||UNAPIGEN.GETOBJTPDESCRIPTION(P_EV_REC.OBJECT_TP)||' "'||
                                    P_EV_REC.OBJECT_ID||'" is automatically changed from "'||L_SS_FROM_NAME||
                                    '" ['||P_EV_REC.OBJECT_SS||'] to "'||L_SS_TO_NAME||'" ['||A_SS_TO||'].');
         DBMS_SQL.BIND_VARIABLE(L_OBJ_CURSOR, ':logdate', CURRENT_TIMESTAMP);
         DBMS_SQL.BIND_VARIABLE(L_OBJ_CURSOR, ':logdate_tz', CURRENT_TIMESTAMP);
         DBMS_SQL.BIND_VARIABLE(L_OBJ_CURSOR, ':why', L_WHY);
         DBMS_SQL.BIND_VARIABLE(L_OBJ_CURSOR, ':tr_seq', UNAPIGEN.P_TR_SEQ);
         DBMS_SQL.BIND_VARIABLE(L_OBJ_CURSOR, ':ev_seq', P_EV_REC.EV_SEQ);
         L_RESULT := DBMS_SQL.EXECUTE(L_OBJ_CURSOR);
      END IF;
   END IF;

   
   
   
   IF L_SS_FORCED = TRUE AND
      UNAPIGEN.ISSYSTEM21CFR11COMPLIANT = UNAPIGEN.DBERR_SUCCESS THEN
      L_SS_TO_NAME := UNAPIGEN.SQLSSNAME(A_SS_TO);
      L_WHY := NULL;
      
      
      IF P_EV_REC.OBJECT_TP = 'pp' THEN
         INSERT INTO UTPPHS
         (PP, VERSION, PP_KEY1, PP_KEY2, PP_KEY3, PP_KEY4, PP_KEY5,
          WHO, WHO_DESCRIPTION, 
          WHAT, WHAT_DESCRIPTION, 
          LOGDATE,LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
          VALUES
          (P_EV_REC.OBJECT_ID, P_VERSION, P_PP_KEY1, P_PP_KEY2, P_PP_KEY3, P_PP_KEY4, P_PP_KEY5,
           P_EV_REC.USERNAME, UNAPIGEN.SQLUSERDESCRIPTION(P_EV_REC.USERNAME),
           'EvMgrStatusForced', 'status of '||UNAPIGEN.GETOBJTPDESCRIPTION('pp')||' "'||
                                    P_EV_REC.OBJECT_ID||'" is forced to "'||L_SS_TO_NAME||'" ['||A_SS_TO||'].',
           CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, L_WHY, UNAPIGEN.P_TR_SEQ, P_EV_REC.EV_SEQ);                         
      ELSIF P_EV_REC.OBJECT_TP = 'eq' THEN
         INSERT INTO UTEQHS
         (EQ, LAB, VERSION,
          WHO, WHO_DESCRIPTION, 
          WHAT, WHAT_DESCRIPTION, 
          LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
          VALUES
          (P_EV_REC.OBJECT_ID, P_LAB, P_VERSION,
           P_EV_REC.USERNAME, UNAPIGEN.SQLUSERDESCRIPTION(P_EV_REC.USERNAME),
           'EvMgrStatusForced', 'status of '||UNAPIGEN.GETOBJTPDESCRIPTION('eq')||' "'||
                                    P_EV_REC.OBJECT_ID||'" is forced to "'||L_SS_TO_NAME||'" ['||A_SS_TO||'].',
           CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, L_WHY, UNAPIGEN.P_TR_SEQ, P_EV_REC.EV_SEQ);                         
      ELSE
         L_SQL_STRING := 'INSERT INTO ut' || P_EV_REC.OBJECT_TP || 'hs' ||
                         '(' || P_EV_REC.OBJECT_TP || ', version, who, who_description, '||
                           'what, what_description, logdate, logdate_tz, why, tr_seq, ev_seq)' ||
                         'VALUES(:object_id, :version, :who, :who_description, '||
                           ':what, :what_description, :logdate, :logdate_tz, :why, :tr_seq, :ev_seq)';                        
         DBMS_SQL.PARSE(L_OBJ_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
         DBMS_SQL.BIND_VARIABLE(L_OBJ_CURSOR, ':object_id', P_EV_REC.OBJECT_ID);
         DBMS_SQL.BIND_VARIABLE(L_OBJ_CURSOR, ':version', P_VERSION);
         DBMS_SQL.BIND_VARIABLE(L_OBJ_CURSOR, ':who', P_EV_REC.USERNAME);
         DBMS_SQL.BIND_VARIABLE(L_OBJ_CURSOR, ':who_description', UNAPIGEN.SQLUSERDESCRIPTION(P_EV_REC.USERNAME));
         DBMS_SQL.BIND_VARIABLE(L_OBJ_CURSOR, ':what', 'EvMgrStatusForced');
         DBMS_SQL.BIND_VARIABLE(L_OBJ_CURSOR, ':what_description', 'status of '||UNAPIGEN.GETOBJTPDESCRIPTION(P_EV_REC.OBJECT_TP)||' "'||
                                    P_EV_REC.OBJECT_ID||'" is forced to "'||L_SS_TO_NAME||'" ['||A_SS_TO||'].');
         DBMS_SQL.BIND_VARIABLE(L_OBJ_CURSOR, ':logdate', CURRENT_TIMESTAMP);
         DBMS_SQL.BIND_VARIABLE(L_OBJ_CURSOR, ':logdate_tz', CURRENT_TIMESTAMP);
         DBMS_SQL.BIND_VARIABLE(L_OBJ_CURSOR, ':why', L_WHY);
         DBMS_SQL.BIND_VARIABLE(L_OBJ_CURSOR, ':tr_seq', UNAPIGEN.P_TR_SEQ);
         DBMS_SQL.BIND_VARIABLE(L_OBJ_CURSOR, ':ev_seq', P_EV_REC.EV_SEQ);
         L_RESULT := DBMS_SQL.EXECUTE(L_OBJ_CURSOR);
      END IF;
   END IF;
   
   SAVEPOINT_UNILAB4;
   L_RESULT := UNACCESS.UPDATEACCESSRIGHTS;
   SAVEPOINT_UNILAB4;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE = -60 THEN
      
      UNAPIGEN.P_DEADLOCK_RAISED := TRUE;
      
      IF UNAPIGEN.P_DEADLOCK_COUNT < UNAPIGEN.P_MAX_DEADLOCK_COUNT THEN
         RAISE;
      END IF;
   END IF;               
   IF SQLCODE <> 1 THEN
      L_SQLERRM := SUBSTR(SQLERRM,1,255);
      INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
      VALUES (P_EV_REC.CLIENT_ID,
              P_EV_REC.APPLIC,
              UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
              'UpdateObjectRecord', L_SQLERRM);
   ELSIF L_SQLERRM IS NOT NULL THEN
      INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
      VALUES(P_EV_REC.CLIENT_ID, P_EV_REC.APPLIC, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
             'UpdateObjectRecord', L_SQLERRM); 
   END IF;
   L_SQLERRM := 'object_tp='||P_EV_REC.OBJECT_TP||'#object_id='||P_EV_REC.OBJECT_ID||'#version='||NVL(P_VERSION,'Empty !!!')||
                'lc='||P_EV_REC.OBJECT_LC||'#lc_version='||P_EV_REC.OBJECT_LC_VERSION||'#ev_tp='||P_EV_REC.EV_TP;
   INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
   VALUES (P_EV_REC.CLIENT_ID,
           P_EV_REC.APPLIC,
           UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
           'UpdateObjectRecord', L_SQLERRM);
   SAVEPOINT_UNILAB4;
END UPDATEOBJECTRECORD;

PROCEDURE UPDATEOPALOBJECTRECORD            
(A_SS_TO           IN VARCHAR2)             
IS

L_ALLOW_MODIFY        CHAR(1);
L_ACTIVE              CHAR(1);
L_SEQ                 INTEGER;
L_OBJECT_ID           VARCHAR2(255);
L_HS_DETAILS_SEQ_NR   INTEGER;
L_SS_FORCED           BOOLEAN;
L_NEW_ALLOW_MODIFY    CHAR(1);

BEGIN

   
   
   IF A_SS_TO IS NOT NULL THEN
      L_SS_FORCED := FALSE;
      IF A_SS_TO NOT IN ( '@~', '@P', '@D' ) AND 
         P_TR_NO IS NULL THEN
         L_SS_FORCED := TRUE;
      END IF;
      BEGIN
         SELECT ALLOW_MODIFY, ACTIVE
         INTO L_ALLOW_MODIFY, L_ACTIVE
         FROM UTSS
         WHERE SS = A_SS_TO;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         L_SQLERRM :=  'status '||A_SS_TO|| ' that was specified in event details does not exit in db';
         RAISE STPERROR;
      END;
      
      IF P_EV_OUTPUT_ON THEN
         IF P_EV_REC.OBJECT_TP IN ('sc','rq', 'rqic', 'rqii', 'ws', 'sd', 'sdic', 'sdii') THEN
            UNTRACE.LOG('      '||'Updating ut' || P_EV_REC.OBJECT_TP ||
                                 '(lc,ss,allow_modify,active) = ' ||
                                 '( ' || P_EV_REC.OBJECT_LC || ',' || A_SS_TO ||
                                 ',' || L_ALLOW_MODIFY || ',' ||L_ACTIVE || ')' );
         ELSE
            UNTRACE.LOG('      '||'Updating utsc' || P_EV_REC.OBJECT_TP ||
                                 '(lc,ss,allow_modify,active) = ' || '( ' ||
                                 P_EV_REC.OBJECT_LC || ',' || A_SS_TO || ',' ||
                                 L_ALLOW_MODIFY || ',' ||L_ACTIVE || ')' );
         END IF;
      END IF;
      
            
      L_HS_DETAILS_SEQ_NR := 0;
      IF P_EV_REC.OBJECT_TP = 'rq' THEN
         UPDATE UTRQ
         SET LC = P_EV_REC.OBJECT_LC,
             LC_VERSION = P_EV_REC.OBJECT_LC_VERSION,
             SS = A_SS_TO,
             ALLOW_MODIFY = L_ALLOW_MODIFY,
             ACTIVE = L_ACTIVE
         WHERE RQ = P_RQ;
         IF P_LOG_HS THEN
            INSERT INTO UTRQHS(RQ, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
            VALUES(P_RQ, 
                   P_EV_REC.USERNAME, 
                   UNAPIGEN.SQLUSERDESCRIPTION(P_EV_REC.USERNAME),
                   'EvMgrStatusChanged',
                   'status of '||UNAPIGEN.GETOBJTPDESCRIPTION(P_EV_REC.OBJECT_TP)||' "'||
                      P_EV_REC.OBJECT_ID||'" is automatically changed from "'||
                      UNAPIGEN.SQLSSNAME(P_EV_REC.OBJECT_SS)||'" ['||P_EV_REC.OBJECT_SS||
                      '] to "'||UNAPIGEN.SQLSSNAME(A_SS_TO)||'" ['||A_SS_TO||'].',
                   CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                   NULL,
                   UNAPIGEN.P_TR_SEQ,
                   P_EV_REC.EV_SEQ);
         END IF;
         IF P_LOG_HS_DETAILS THEN
            L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
            INSERT INTO UTRQHSDETAILS(RQ, TR_SEQ, EV_SEQ, SEQ, DETAILS)
            VALUES(P_RQ, UNAPIGEN.P_TR_SEQ, P_EV_REC.EV_SEQ, L_HS_DETAILS_SEQ_NR, 
                   'status of '||UNAPIGEN.GETOBJTPDESCRIPTION(P_EV_REC.OBJECT_TP)||' "'||
                      P_EV_REC.OBJECT_ID||'" is automatically changed from "'||
                      UNAPIGEN.SQLSSNAME(P_EV_REC.OBJECT_SS)||'" ['||P_EV_REC.OBJECT_SS||
                      '] to "'||UNAPIGEN.SQLSSNAME(A_SS_TO)||'" ['||A_SS_TO||'].');
         END IF;
         IF L_SS_FORCED = TRUE AND
            UNAPIGEN.ISSYSTEM21CFR11COMPLIANT = UNAPIGEN.DBERR_SUCCESS THEN
            INSERT INTO UTRQHS(RQ, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
            VALUES(P_RQ, 
                   P_EV_REC.USERNAME, 
                   UNAPIGEN.SQLUSERDESCRIPTION(P_EV_REC.USERNAME),
                   'EvMgrStatusForced',
                   'Status of '||UNAPIGEN.GETOBJTPDESCRIPTION(P_EV_REC.OBJECT_TP)||' "'||
                      P_EV_REC.OBJECT_ID||'" is forced to "'||
                      UNAPIGEN.SQLSSNAME(A_SS_TO)||'" ['||A_SS_TO||'].',
                   CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                   NULL,
                   UNAPIGEN.P_TR_SEQ,
                   P_EV_REC.EV_SEQ);
            L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
            INSERT INTO UTRQHSDETAILS(RQ, TR_SEQ, EV_SEQ, SEQ, DETAILS)
            VALUES(P_RQ, UNAPIGEN.P_TR_SEQ, P_EV_REC.EV_SEQ, L_HS_DETAILS_SEQ_NR, 
                   'status of '||UNAPIGEN.GETOBJTPDESCRIPTION(P_EV_REC.OBJECT_TP)||' "'||
                      P_EV_REC.OBJECT_ID||'" is forced to "'||UNAPIGEN.SQLSSNAME(A_SS_TO)||'" ['||A_SS_TO||'].');
         END IF;
         IF P_EV_OUTPUT_ON THEN
            UNTRACE.LOG('      '||'WHERE rq=' || P_RQ );
         END IF;      
         L_OBJECT_ID := P_RQ;
         IF UNAPIGEN.ISSYSTEMSUPPORTINGRNDSUITE = UNAPIGEN.DBERR_SUCCESS THEN
            
            IF P_EV_OUTPUT_ON THEN
               UNTRACE.LOG('      '||'Calling RNDAPIRQP.UpdateRqSoList for rq=' ||  P_RQ );
            END IF;
            BEGIN
               EXECUTE IMMEDIATE 'DECLARE l_ret_code INTEGER; BEGIN :l_ret_code := RNDAPIRQP.UpdateRqSoList(:rq); END;'
               USING OUT L_RET_CODE, IN P_RQ;
            EXCEPTION
            WHEN OTHERS THEN
               L_SQLERRM := SQLERRM;
               INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
               VALUES (P_EV_REC.CLIENT_ID,
                       P_EV_REC.APPLIC,
                       UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                       'UpdateOpalObjectRecord', 'Error calling RNDAPIRQP.UpdateRqSoList for rq=' ||  P_RQ );
               INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
               VALUES (P_EV_REC.CLIENT_ID,
                       P_EV_REC.APPLIC,
                       UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                       'UpdateOpalObjectRecord', L_SQLERRM);
               
            END;
            IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
               INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
               VALUES (P_EV_REC.CLIENT_ID,
                       P_EV_REC.APPLIC,
                       UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                       'UpdateOpalObjectRecord', 'ret_code='||L_RET_CODE||'for call to RNDAPIRQP.UpdateRqSoList for rq=' ||  P_RQ );
            END IF;
         END IF;
         
      ELSIF P_EV_REC.OBJECT_TP = 'sc' THEN
         UPDATE UTSC
         SET LC = P_EV_REC.OBJECT_LC,
             LC_VERSION = P_EV_REC.OBJECT_LC_VERSION,
             SS = A_SS_TO,
             ALLOW_MODIFY = L_ALLOW_MODIFY,
             ACTIVE = L_ACTIVE
         WHERE SC = P_SC;
         IF P_LOG_HS THEN
            INSERT INTO UTSCHS(SC, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
            VALUES(P_SC,
                   P_EV_REC.USERNAME,
                   UNAPIGEN.SQLUSERDESCRIPTION(P_EV_REC.USERNAME),
                   'EvMgrStatusChanged',
                   'status of '||UNAPIGEN.GETOBJTPDESCRIPTION(P_EV_REC.OBJECT_TP)||' "'||
                                                    P_EV_REC.OBJECT_ID||'" is automatically changed from "'||UNAPIGEN.SQLSSNAME(P_EV_REC.OBJECT_SS)||
                                 '" ['||P_EV_REC.OBJECT_SS||'] to "'||UNAPIGEN.SQLSSNAME(A_SS_TO)||'" ['||A_SS_TO||'].',
                   CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                   NULL,
                   UNAPIGEN.P_TR_SEQ,
                   P_EV_REC.EV_SEQ);
         END IF;
         IF P_LOG_HS_DETAILS THEN
            L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
            INSERT INTO UTSCHSDETAILS(SC, TR_SEQ, EV_SEQ, SEQ, DETAILS)
            VALUES(P_SC, UNAPIGEN.P_TR_SEQ, P_EV_REC.EV_SEQ, L_HS_DETAILS_SEQ_NR, 
                   'status of '||UNAPIGEN.GETOBJTPDESCRIPTION(P_EV_REC.OBJECT_TP)||' "'||
                      P_EV_REC.OBJECT_ID||'" is automatically changed from "'||
                      UNAPIGEN.SQLSSNAME(P_EV_REC.OBJECT_SS)||'" ['||P_EV_REC.OBJECT_SS||
                      '] to "'||UNAPIGEN.SQLSSNAME(A_SS_TO)||'" ['||A_SS_TO||'].');
         END IF;
         IF L_SS_FORCED = TRUE AND
            UNAPIGEN.ISSYSTEM21CFR11COMPLIANT = UNAPIGEN.DBERR_SUCCESS THEN
            INSERT INTO UTSCHS(SC, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
            VALUES(P_SC,
                   P_EV_REC.USERNAME,
                   UNAPIGEN.SQLUSERDESCRIPTION(P_EV_REC.USERNAME),
                   'EvMgrStatusForced',
                   'status of '||UNAPIGEN.GETOBJTPDESCRIPTION(P_EV_REC.OBJECT_TP)||' "'||
                                                    P_EV_REC.OBJECT_ID||'" is forced to "'||
                                                    UNAPIGEN.SQLSSNAME(A_SS_TO)||'" ['||A_SS_TO||'].',
                   CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 
                   NULL,
                   UNAPIGEN.P_TR_SEQ,
                   P_EV_REC.EV_SEQ);
            L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
            INSERT INTO UTSCHSDETAILS(SC, TR_SEQ, EV_SEQ, SEQ, DETAILS)
            VALUES(P_SC, UNAPIGEN.P_TR_SEQ, P_EV_REC.EV_SEQ, L_HS_DETAILS_SEQ_NR, 
                   'status of '||UNAPIGEN.GETOBJTPDESCRIPTION(P_EV_REC.OBJECT_TP)||' "'||
                      P_EV_REC.OBJECT_ID||'" is forced to "'||
                      UNAPIGEN.SQLSSNAME(A_SS_TO)||'" ['||A_SS_TO||'].');
         END IF;
         IF P_EV_OUTPUT_ON THEN
            UNTRACE.LOG('      '||'WHERE sc=' || P_SC );
         END IF;
         L_OBJECT_ID := P_SC;

      ELSIF P_EV_REC.OBJECT_TP = 'sd' THEN
         UPDATE UTSD
         SET LC = P_EV_REC.OBJECT_LC,
             LC_VERSION = P_EV_REC.OBJECT_LC_VERSION,
             SS = A_SS_TO,
             ALLOW_MODIFY = L_ALLOW_MODIFY,
             ACTIVE = L_ACTIVE
         WHERE SD = P_SD;
         IF P_LOG_HS THEN
            INSERT INTO UTSDHS(SD, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
            VALUES(P_SD,
                   P_EV_REC.USERNAME,
                   UNAPIGEN.SQLUSERDESCRIPTION(P_EV_REC.USERNAME),
                   'EvMgrStatusChanged',
                   'status of '||UNAPIGEN.GETOBJTPDESCRIPTION(P_EV_REC.OBJECT_TP)||' "'||
                                                    P_EV_REC.OBJECT_ID||'" is automatically changed from "'||UNAPIGEN.SQLSSNAME(P_EV_REC.OBJECT_SS)||
                                 '" ['||P_EV_REC.OBJECT_SS||'] to "'||UNAPIGEN.SQLSSNAME(A_SS_TO)||'" ['||A_SS_TO||'].',
                   CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                   NULL,
                   UNAPIGEN.P_TR_SEQ,
                   P_EV_REC.EV_SEQ);
         END IF;
         IF P_LOG_HS_DETAILS THEN
            L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
            INSERT INTO UTSDHSDETAILS(SD, TR_SEQ, EV_SEQ, SEQ, DETAILS)
            VALUES(P_SD, UNAPIGEN.P_TR_SEQ, P_EV_REC.EV_SEQ, L_HS_DETAILS_SEQ_NR, 
                   'status of '||UNAPIGEN.GETOBJTPDESCRIPTION(P_EV_REC.OBJECT_TP)||' "'||
                      P_EV_REC.OBJECT_ID||'" is automatically changed from "'||
                      UNAPIGEN.SQLSSNAME(P_EV_REC.OBJECT_SS)||'" ['||P_EV_REC.OBJECT_SS||
                      '] to "'||UNAPIGEN.SQLSSNAME(A_SS_TO)||'" ['||A_SS_TO||'].');
         END IF;
         IF L_SS_FORCED = TRUE AND
            UNAPIGEN.ISSYSTEM21CFR11COMPLIANT = UNAPIGEN.DBERR_SUCCESS THEN
            INSERT INTO UTSDHS(SD, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
            VALUES(P_SD,
                   P_EV_REC.USERNAME,
                   UNAPIGEN.SQLUSERDESCRIPTION(P_EV_REC.USERNAME),
                   'EvMgrStatusForced',
                   'status of '||UNAPIGEN.GETOBJTPDESCRIPTION(P_EV_REC.OBJECT_TP)||' "'||
                                                    P_EV_REC.OBJECT_ID||'" is forced to "'||
                                                    UNAPIGEN.SQLSSNAME(A_SS_TO)||'" ['||A_SS_TO||'].',
                   CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                   NULL,
                   UNAPIGEN.P_TR_SEQ,
                   P_EV_REC.EV_SEQ);
            L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
            INSERT INTO UTSDHSDETAILS(SD, TR_SEQ, EV_SEQ, SEQ, DETAILS)
            VALUES(P_SD, UNAPIGEN.P_TR_SEQ, P_EV_REC.EV_SEQ, L_HS_DETAILS_SEQ_NR, 
                   'status of '||UNAPIGEN.GETOBJTPDESCRIPTION(P_EV_REC.OBJECT_TP)||' "'||
                      P_EV_REC.OBJECT_ID||'" is forced to "'||UNAPIGEN.SQLSSNAME(A_SS_TO)||'" ['||A_SS_TO||'].');
         END IF;         
         IF P_EV_OUTPUT_ON THEN
            UNTRACE.LOG('      '||'WHERE sd=' || P_SD );
         END IF;
         L_OBJECT_ID := P_SD;

      ELSIF P_EV_REC.OBJECT_TP = 'rqic' THEN
         UPDATE UTRQIC
         SET LC = P_EV_REC.OBJECT_LC,
             LC_VERSION = P_EV_REC.OBJECT_LC_VERSION,
             SS = A_SS_TO,
             ALLOW_MODIFY = L_ALLOW_MODIFY,
             ACTIVE = L_ACTIVE
         WHERE RQ = P_RQ
           AND IC = P_IC
           AND ICNODE = P_ICNODE;
         IF P_LOG_HS THEN
            INSERT INTO UTRQICHS(RQ, IC, ICNODE, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
            VALUES(P_RQ, P_IC, P_ICNODE, 
                   P_EV_REC.USERNAME, 
                   UNAPIGEN.SQLUSERDESCRIPTION(P_EV_REC.USERNAME),
                   'EvMgrStatusChanged',
                   'status of '||UNAPIGEN.GETOBJTPDESCRIPTION(P_EV_REC.OBJECT_TP)||' "'||
                                                    P_EV_REC.OBJECT_ID||'" is automatically changed from "'||UNAPIGEN.SQLSSNAME(P_EV_REC.OBJECT_SS)||
                                 '" ['||P_EV_REC.OBJECT_SS||'] to "'||UNAPIGEN.SQLSSNAME(A_SS_TO)||'" ['||A_SS_TO||'].',
                   CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                   NULL,
                   UNAPIGEN.P_TR_SEQ,
                   P_EV_REC.EV_SEQ);
         END IF;
         IF P_LOG_HS_DETAILS THEN
            L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
            INSERT INTO UTRQICHSDETAILS(RQ, IC, ICNODE, TR_SEQ, EV_SEQ, SEQ, DETAILS)
            VALUES(P_RQ, P_IC, P_ICNODE, UNAPIGEN.P_TR_SEQ, P_EV_REC.EV_SEQ, L_HS_DETAILS_SEQ_NR, 
                   'status of '||UNAPIGEN.GETOBJTPDESCRIPTION(P_EV_REC.OBJECT_TP)||' "'||
                      P_EV_REC.OBJECT_ID||'" is automatically changed from "'||
                      UNAPIGEN.SQLSSNAME(P_EV_REC.OBJECT_SS)||'" ['||P_EV_REC.OBJECT_SS||
                      '] to "'||UNAPIGEN.SQLSSNAME(A_SS_TO)||'" ['||A_SS_TO||'].');
         END IF;
         IF L_SS_FORCED = TRUE AND
            UNAPIGEN.ISSYSTEM21CFR11COMPLIANT = UNAPIGEN.DBERR_SUCCESS THEN
            INSERT INTO UTRQICHS(RQ, IC, ICNODE, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
            VALUES(P_RQ, P_IC, P_ICNODE, 
                   P_EV_REC.USERNAME, 
                   UNAPIGEN.SQLUSERDESCRIPTION(P_EV_REC.USERNAME),
                   'EvMgrStatusForced',
                   'status of '||UNAPIGEN.GETOBJTPDESCRIPTION(P_EV_REC.OBJECT_TP)||' "'||
                                                    P_EV_REC.OBJECT_ID||'" is forced to "'||
                                                    UNAPIGEN.SQLSSNAME(A_SS_TO)||'" ['||A_SS_TO||'].',
                   CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                   NULL,
                   UNAPIGEN.P_TR_SEQ,
                   P_EV_REC.EV_SEQ);
            L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
            INSERT INTO UTRQICHSDETAILS(RQ, IC, ICNODE, TR_SEQ, EV_SEQ, SEQ, DETAILS)
            VALUES(P_RQ, P_IC, P_ICNODE, UNAPIGEN.P_TR_SEQ, P_EV_REC.EV_SEQ, L_HS_DETAILS_SEQ_NR, 
                   'status of '||UNAPIGEN.GETOBJTPDESCRIPTION(P_EV_REC.OBJECT_TP)||' "'||
                      P_EV_REC.OBJECT_ID||'" is forced to "'||
                      UNAPIGEN.SQLSSNAME(A_SS_TO)||'" ['||A_SS_TO||'].');
         END IF;
         IF P_EV_OUTPUT_ON THEN
            UNTRACE.LOG('      '||'WHERE rq=' || P_RQ || ' AND ic=' || P_IC ||
                                 ' AND icnode= ' || P_ICNODE );
         END IF;
         L_OBJECT_ID := P_RQ||P_IC||TO_CHAR(P_ICNODE);

      ELSIF P_EV_REC.OBJECT_TP = 'sdic' THEN
         UPDATE UTSDIC
         SET LC = P_EV_REC.OBJECT_LC,
             LC_VERSION = P_EV_REC.OBJECT_LC_VERSION,
             SS = A_SS_TO,
             ALLOW_MODIFY = L_ALLOW_MODIFY,
             ACTIVE = L_ACTIVE
         WHERE SD = P_SD
           AND IC = P_IC
           AND ICNODE = P_ICNODE;
         IF P_LOG_HS THEN
            INSERT INTO UTSDICHS(SD, IC, ICNODE, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
            VALUES(P_SD, P_IC, P_ICNODE, 
                   P_EV_REC.USERNAME, 
                   UNAPIGEN.SQLUSERDESCRIPTION(P_EV_REC.USERNAME),
                   'EvMgrStatusChanged',
                   'status of '||UNAPIGEN.GETOBJTPDESCRIPTION(P_EV_REC.OBJECT_TP)||' "'||
                                                    P_EV_REC.OBJECT_ID||'" is automatically changed from "'||UNAPIGEN.SQLSSNAME(P_EV_REC.OBJECT_SS)||
                                 '" ['||P_EV_REC.OBJECT_SS||'] to "'||UNAPIGEN.SQLSSNAME(A_SS_TO)||'" ['||A_SS_TO||'].',
                   CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                   NULL,
                   UNAPIGEN.P_TR_SEQ,
                   P_EV_REC.EV_SEQ);
         END IF;
         IF P_LOG_HS_DETAILS THEN
            L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
            INSERT INTO UTSDICHSDETAILS(SD, IC, ICNODE, TR_SEQ, EV_SEQ, SEQ, DETAILS)
            VALUES(P_SD, P_IC, P_ICNODE, UNAPIGEN.P_TR_SEQ, P_EV_REC.EV_SEQ, L_HS_DETAILS_SEQ_NR, 
                   'status of '||UNAPIGEN.GETOBJTPDESCRIPTION(P_EV_REC.OBJECT_TP)||' "'||
                      P_EV_REC.OBJECT_ID||'" is automatically changed from "'||
                      UNAPIGEN.SQLSSNAME(P_EV_REC.OBJECT_SS)||'" ['||P_EV_REC.OBJECT_SS||
                      '] to "'||UNAPIGEN.SQLSSNAME(A_SS_TO)||'" ['||A_SS_TO||'].');
         END IF;
         IF L_SS_FORCED = TRUE AND
            UNAPIGEN.ISSYSTEM21CFR11COMPLIANT = UNAPIGEN.DBERR_SUCCESS THEN
            INSERT INTO UTSDICHS(SD, IC, ICNODE, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
            VALUES(P_SD, P_IC, P_ICNODE, 
                   P_EV_REC.USERNAME, 
                   UNAPIGEN.SQLUSERDESCRIPTION(P_EV_REC.USERNAME),
                   'EvMgrStatusForced',
                   'status of '||UNAPIGEN.GETOBJTPDESCRIPTION(P_EV_REC.OBJECT_TP)||' "'||
                                                    P_EV_REC.OBJECT_ID||'" is automatically changed from "'||UNAPIGEN.SQLSSNAME(P_EV_REC.OBJECT_SS)||
                                 '" ['||P_EV_REC.OBJECT_SS||'] to "'||UNAPIGEN.SQLSSNAME(A_SS_TO)||'" ['||A_SS_TO||'].',
                   CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                   NULL,
                   UNAPIGEN.P_TR_SEQ,
                   P_EV_REC.EV_SEQ);
            L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
            INSERT INTO UTSDICHSDETAILS(SD, IC, ICNODE, TR_SEQ, EV_SEQ, SEQ, DETAILS)
            VALUES(P_SD, P_IC, P_ICNODE, UNAPIGEN.P_TR_SEQ, P_EV_REC.EV_SEQ, L_HS_DETAILS_SEQ_NR, 
                   'status of '||UNAPIGEN.GETOBJTPDESCRIPTION(P_EV_REC.OBJECT_TP)||' "'||
                   P_EV_REC.OBJECT_ID||'" is forced to "'||
                   UNAPIGEN.SQLSSNAME(A_SS_TO)||'" ['||A_SS_TO||'].');
         END IF;
         IF P_EV_OUTPUT_ON THEN
            UNTRACE.LOG('      '||'WHERE sd=' || P_SD || ' AND ic=' || P_IC ||
                                 ' AND icnode= ' || P_ICNODE );
         END IF;
         L_OBJECT_ID := P_SD||P_IC||TO_CHAR(P_ICNODE);
         
      ELSIF P_EV_REC.OBJECT_TP = 'ic' THEN
         UPDATE UTSCIC
         SET LC = P_EV_REC.OBJECT_LC,
             LC_VERSION = P_EV_REC.OBJECT_LC_VERSION,
             SS = A_SS_TO,
             ALLOW_MODIFY = L_ALLOW_MODIFY,
             ACTIVE = L_ACTIVE
         WHERE SC = P_SC
           AND IC = P_IC
           AND ICNODE = P_ICNODE;
         IF P_LOG_HS THEN
            INSERT INTO UTSCICHS(SC, IC, ICNODE, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
            VALUES(P_SC, P_IC, P_ICNODE,
                   P_EV_REC.USERNAME,
                   UNAPIGEN.SQLUSERDESCRIPTION(P_EV_REC.USERNAME),
                   'EvMgrStatusChanged',
                   'status of '||UNAPIGEN.GETOBJTPDESCRIPTION(P_EV_REC.OBJECT_TP)||' "'||
                                                    P_EV_REC.OBJECT_ID||'" is automatically changed from "'||UNAPIGEN.SQLSSNAME(P_EV_REC.OBJECT_SS)||
                                 '" ['||P_EV_REC.OBJECT_SS||'] to "'||UNAPIGEN.SQLSSNAME(A_SS_TO)||'" ['||A_SS_TO||'].',
                   CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                   NULL,
                   UNAPIGEN.P_TR_SEQ,
                   P_EV_REC.EV_SEQ);
         END IF;
         IF P_LOG_HS_DETAILS THEN
            L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
            INSERT INTO UTSCICHSDETAILS(SC, IC, ICNODE, TR_SEQ, EV_SEQ, SEQ, DETAILS)
            VALUES(P_SC, P_IC, P_ICNODE, UNAPIGEN.P_TR_SEQ, P_EV_REC.EV_SEQ, L_HS_DETAILS_SEQ_NR, 
                   'status of '||UNAPIGEN.GETOBJTPDESCRIPTION(P_EV_REC.OBJECT_TP)||' "'||
                      P_EV_REC.OBJECT_ID||'" is automatically changed from "'||
                      UNAPIGEN.SQLSSNAME(P_EV_REC.OBJECT_SS)||'" ['||P_EV_REC.OBJECT_SS||
                      '] to "'||UNAPIGEN.SQLSSNAME(A_SS_TO)||'" ['||A_SS_TO||'].');
         END IF;
         IF L_SS_FORCED = TRUE AND
            UNAPIGEN.ISSYSTEM21CFR11COMPLIANT = UNAPIGEN.DBERR_SUCCESS THEN
            INSERT INTO UTSCICHS(SC, IC, ICNODE, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
            VALUES(P_SC, P_IC, P_ICNODE,
                   P_EV_REC.USERNAME,
                   UNAPIGEN.SQLUSERDESCRIPTION(P_EV_REC.USERNAME),
                   'EvMgrStatusForced',
                   'status of '||UNAPIGEN.GETOBJTPDESCRIPTION(P_EV_REC.OBJECT_TP)||' "'||
                                                    P_EV_REC.OBJECT_ID||'" is forced to "'||
                                                    UNAPIGEN.SQLSSNAME(A_SS_TO)||'" ['||A_SS_TO||'].',
                   CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                   NULL,
                   UNAPIGEN.P_TR_SEQ,
                   P_EV_REC.EV_SEQ);
            L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
            INSERT INTO UTSCICHSDETAILS(SC, IC, ICNODE, TR_SEQ, EV_SEQ, SEQ, DETAILS)
            VALUES(P_SC, P_IC, P_ICNODE, UNAPIGEN.P_TR_SEQ, P_EV_REC.EV_SEQ, L_HS_DETAILS_SEQ_NR, 
                   'status of '||UNAPIGEN.GETOBJTPDESCRIPTION(P_EV_REC.OBJECT_TP)||' "'||
                      P_EV_REC.OBJECT_ID||'" is forced to "'||
                      UNAPIGEN.SQLSSNAME(A_SS_TO)||'" ['||A_SS_TO||'].');
         END IF;         
         IF P_EV_OUTPUT_ON THEN
            UNTRACE.LOG('      '||'WHERE sc=' || P_SC || ' AND ic=' || P_IC ||
                                 ' AND icnode= ' || P_ICNODE );
         END IF;
         L_OBJECT_ID := P_SC||P_IC||TO_CHAR(P_ICNODE);
         
      ELSIF P_EV_REC.OBJECT_TP = 'rqii' THEN
         UPDATE UTRQII
         SET LC = P_EV_REC.OBJECT_LC,
             LC_VERSION = P_EV_REC.OBJECT_LC_VERSION,
             SS = A_SS_TO,
             ALLOW_MODIFY = L_ALLOW_MODIFY,
             ACTIVE = L_ACTIVE
         WHERE RQ = P_RQ
           AND IC = P_IC
           AND ICNODE = P_ICNODE
           AND II = P_II
           AND IINODE = P_IINODE;
         
         IF P_EV_OUTPUT_ON THEN
            UNTRACE.LOG('      '||'WHERE rq=' || P_RQ || ' AND ic=' || P_IC ||
                                 ' AND icnode= ' || P_ICNODE || ' AND ii=' ||
                                 P_II || ' AND iinode=' || P_IINODE );
         END IF;
         L_OBJECT_ID := P_RQ||P_IC||TO_CHAR(P_ICNODE)||P_II||TO_CHAR(P_IINODE);
         
      ELSIF P_EV_REC.OBJECT_TP = 'sdii' THEN
         UPDATE UTSDII
         SET LC = P_EV_REC.OBJECT_LC,
             LC_VERSION = P_EV_REC.OBJECT_LC_VERSION,
             SS = A_SS_TO,
             ALLOW_MODIFY = L_ALLOW_MODIFY,
             ACTIVE = L_ACTIVE
         WHERE SD = P_SD
           AND IC = P_IC
           AND ICNODE = P_ICNODE
           AND II = P_II
           AND IINODE = P_IINODE;
         
         IF P_EV_OUTPUT_ON THEN
            UNTRACE.LOG('      '||'WHERE sd=' || P_SD || ' AND ic=' || P_IC ||
                                 ' AND icnode= ' || P_ICNODE || ' AND ii=' ||
                                 P_II || ' AND iinode=' || P_IINODE );
         END IF;
         L_OBJECT_ID := P_SD||P_IC||TO_CHAR(P_ICNODE)||P_II||TO_CHAR(P_IINODE);
         
      ELSIF P_EV_REC.OBJECT_TP = 'ii' THEN
         UPDATE UTSCII
         SET LC = P_EV_REC.OBJECT_LC,
             LC_VERSION = P_EV_REC.OBJECT_LC_VERSION,
             SS = A_SS_TO,
             ALLOW_MODIFY = L_ALLOW_MODIFY,
             ACTIVE = L_ACTIVE
         WHERE SC = P_SC
           AND IC = P_IC
           AND ICNODE = P_ICNODE
           AND II = P_II
           AND IINODE = P_IINODE;
         
         IF P_EV_OUTPUT_ON THEN
            UNTRACE.LOG('      '||'WHERE sc=' || P_SC || ' AND ic=' || P_IC ||
                                 ' AND icnode= ' || P_ICNODE || ' AND ii=' ||
                                 P_II || ' AND iinode=' || P_IINODE );
         END IF;
         L_OBJECT_ID := P_SC||P_IC||TO_CHAR(P_ICNODE)||P_II||TO_CHAR(P_IINODE);
         
      ELSIF P_EV_REC.OBJECT_TP = 'pg' THEN
         UPDATE UTSCPG
         SET LC = P_EV_REC.OBJECT_LC,
             LC_VERSION = P_EV_REC.OBJECT_LC_VERSION,
             SS = A_SS_TO,
             ALLOW_MODIFY = L_ALLOW_MODIFY,
             ACTIVE = L_ACTIVE
         WHERE SC = P_SC
           AND PG = P_PG
           AND PGNODE = P_PGNODE;
         IF P_LOG_HS THEN
            INSERT INTO UTSCPGHS(SC, PG, PGNODE, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
            VALUES(P_SC, P_PG, P_PGNODE, 
                   P_EV_REC.USERNAME, 
                   UNAPIGEN.SQLUSERDESCRIPTION(P_EV_REC.USERNAME),
                   'EvMgrStatusChanged',
                   'status of '||UNAPIGEN.GETOBJTPDESCRIPTION(P_EV_REC.OBJECT_TP)||' "'||
                                                    P_EV_REC.OBJECT_ID||'" is automatically changed from "'||UNAPIGEN.SQLSSNAME(P_EV_REC.OBJECT_SS)||
                                 '" ['||P_EV_REC.OBJECT_SS||'] to "'||UNAPIGEN.SQLSSNAME(A_SS_TO)||'" ['||A_SS_TO||'].',
                   CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                   NULL,
                   UNAPIGEN.P_TR_SEQ,
                   P_EV_REC.EV_SEQ);
         END IF;
         IF P_LOG_HS_DETAILS THEN
            L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
            INSERT INTO UTSCPGHSDETAILS(SC, PG, PGNODE, TR_SEQ, EV_SEQ, SEQ, DETAILS)
            VALUES(P_SC, P_PG, P_PGNODE, UNAPIGEN.P_TR_SEQ, P_EV_REC.EV_SEQ, L_HS_DETAILS_SEQ_NR, 
                   'status of '||UNAPIGEN.GETOBJTPDESCRIPTION(P_EV_REC.OBJECT_TP)||' "'||
                      P_EV_REC.OBJECT_ID||'" is automatically changed from "'||
                      UNAPIGEN.SQLSSNAME(P_EV_REC.OBJECT_SS)||'" ['||P_EV_REC.OBJECT_SS||
                      '] to "'||UNAPIGEN.SQLSSNAME(A_SS_TO)||'" ['||A_SS_TO||'].');
         END IF;
         IF L_SS_FORCED = TRUE AND
            UNAPIGEN.ISSYSTEM21CFR11COMPLIANT = UNAPIGEN.DBERR_SUCCESS THEN
            INSERT INTO UTSCPGHS(SC, PG, PGNODE, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
            VALUES(P_SC, P_PG, P_PGNODE, 
                   P_EV_REC.USERNAME, 
                   UNAPIGEN.SQLUSERDESCRIPTION(P_EV_REC.USERNAME),
                   'EvMgrStatusForced',
                   'status of '||UNAPIGEN.GETOBJTPDESCRIPTION(P_EV_REC.OBJECT_TP)||' "'||
                                                    P_EV_REC.OBJECT_ID||'" is forced to "'||
                                                    UNAPIGEN.SQLSSNAME(A_SS_TO)||'" ['||A_SS_TO||'].',
                   CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                   NULL,
                   UNAPIGEN.P_TR_SEQ,
                   P_EV_REC.EV_SEQ);
            L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
            INSERT INTO UTSCPGHSDETAILS(SC, PG, PGNODE, TR_SEQ, EV_SEQ, SEQ, DETAILS)
            VALUES(P_SC, P_PG, P_PGNODE, UNAPIGEN.P_TR_SEQ, P_EV_REC.EV_SEQ, L_HS_DETAILS_SEQ_NR, 
                   'status of '||UNAPIGEN.GETOBJTPDESCRIPTION(P_EV_REC.OBJECT_TP)||' "'||
                      P_EV_REC.OBJECT_ID||'" is forced to "'||
                      UNAPIGEN.SQLSSNAME(A_SS_TO)||'" ['||A_SS_TO||'].');
         END IF;
         IF P_EV_OUTPUT_ON THEN
            UNTRACE.LOG('      '||'WHERE sc=' || P_SC || ' AND pg=' || P_PG ||
                                 ' AND pgnode= ' || P_PGNODE );
         END IF;
         L_OBJECT_ID := P_SC||P_PG||TO_CHAR(P_PGNODE);

      ELSIF P_EV_REC.OBJECT_TP = 'pa' THEN
         UPDATE UTSCPA
         SET LC = P_EV_REC.OBJECT_LC,
             LC_VERSION = P_EV_REC.OBJECT_LC_VERSION,
             SS = A_SS_TO,
             ALLOW_MODIFY = L_ALLOW_MODIFY,
             ACTIVE = L_ACTIVE
         WHERE SC = P_SC
           AND PG = P_PG
           AND PGNODE = P_PGNODE
           AND PA = P_PA
           AND PANODE = P_PANODE;
         IF P_LOG_HS THEN
            INSERT INTO UTSCPAHS(SC, PG, PGNODE, PA, PANODE, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
            VALUES(P_SC, P_PG, P_PGNODE, P_PA, P_PANODE, 
                   P_EV_REC.USERNAME, 
                   UNAPIGEN.SQLUSERDESCRIPTION(P_EV_REC.USERNAME),
                   'EvMgrStatusChanged',
                   'status of '||UNAPIGEN.GETOBJTPDESCRIPTION(P_EV_REC.OBJECT_TP)||' "'||
                                                    P_EV_REC.OBJECT_ID||'" is automatically changed from "'||UNAPIGEN.SQLSSNAME(P_EV_REC.OBJECT_SS)||
                                 '" ['||P_EV_REC.OBJECT_SS||'] to "'||UNAPIGEN.SQLSSNAME(A_SS_TO)||'" ['||A_SS_TO||'].',
                   CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                   NULL,
                   UNAPIGEN.P_TR_SEQ,
                   P_EV_REC.EV_SEQ);
         END IF;
         IF P_LOG_HS_DETAILS THEN
            L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
            INSERT INTO UTSCPAHSDETAILS(SC, PG, PGNODE, PA, PANODE, TR_SEQ, EV_SEQ, SEQ, DETAILS)
            VALUES(P_SC, P_PG, P_PGNODE, P_PA, P_PANODE, UNAPIGEN.P_TR_SEQ, P_EV_REC.EV_SEQ, L_HS_DETAILS_SEQ_NR, 
                   'status of '||UNAPIGEN.GETOBJTPDESCRIPTION(P_EV_REC.OBJECT_TP)||' "'||
                      P_EV_REC.OBJECT_ID||'" is automatically changed from "'||
                      UNAPIGEN.SQLSSNAME(P_EV_REC.OBJECT_SS)||'" ['||P_EV_REC.OBJECT_SS||
                      '] to "'||UNAPIGEN.SQLSSNAME(A_SS_TO)||'" ['||A_SS_TO||'].');
         END IF;
         IF L_SS_FORCED = TRUE AND
            UNAPIGEN.ISSYSTEM21CFR11COMPLIANT = UNAPIGEN.DBERR_SUCCESS THEN
            INSERT INTO UTSCPAHS(SC, PG, PGNODE, PA, PANODE, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
            VALUES(P_SC, P_PG, P_PGNODE, P_PA, P_PANODE, 
                   P_EV_REC.USERNAME, 
                   UNAPIGEN.SQLUSERDESCRIPTION(P_EV_REC.USERNAME),
                   'EvMgrStatusForced',
                   'status of '||UNAPIGEN.GETOBJTPDESCRIPTION(P_EV_REC.OBJECT_TP)||' "'||
                                                    P_EV_REC.OBJECT_ID||'" is forced to "'||
                                                    UNAPIGEN.SQLSSNAME(A_SS_TO)||'" ['||A_SS_TO||'].',
                   CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                   NULL,
                   UNAPIGEN.P_TR_SEQ,
                   P_EV_REC.EV_SEQ);
            L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
            INSERT INTO UTSCPAHSDETAILS(SC, PG, PGNODE, PA, PANODE, TR_SEQ, EV_SEQ, SEQ, DETAILS)
            VALUES(P_SC, P_PG, P_PGNODE, P_PA, P_PANODE, UNAPIGEN.P_TR_SEQ, P_EV_REC.EV_SEQ, L_HS_DETAILS_SEQ_NR, 
                   'status of '||UNAPIGEN.GETOBJTPDESCRIPTION(P_EV_REC.OBJECT_TP)||' "'||
                      P_EV_REC.OBJECT_ID||'" is forced to "'||
                      UNAPIGEN.SQLSSNAME(A_SS_TO)||'" ['||A_SS_TO||'].');
         END IF;
         IF P_EV_OUTPUT_ON THEN
            UNTRACE.LOG('      '||'WHERE sc=' || P_SC || ' AND pg=' || P_PG ||
                                 ' AND pgnode= ' || P_PGNODE || ' AND pa=' ||
                                 P_PA || ' AND panode=' || P_PANODE );
         END IF;
         L_OBJECT_ID := P_SC||P_PG||TO_CHAR(P_PGNODE)||P_PA||TO_CHAR(P_PANODE);

      ELSIF P_EV_REC.OBJECT_TP = 'me' THEN
         UPDATE UTSCME
         SET LC = P_EV_REC.OBJECT_LC,
             LC_VERSION = P_EV_REC.OBJECT_LC_VERSION,
             SS = A_SS_TO,
             ALLOW_MODIFY = L_ALLOW_MODIFY,
             ACTIVE = L_ACTIVE
         WHERE SC = P_SC
           AND PG = P_PG
           AND PGNODE = P_PGNODE
           AND PA = P_PA
           AND PANODE = P_PANODE
           AND ME = P_ME
           AND MENODE = P_MENODE;
         IF P_LOG_HS THEN
            INSERT INTO UTSCMEHS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
            VALUES(P_SC, P_PG, P_PGNODE, P_PA, P_PANODE, P_ME, P_MENODE, 
                   P_EV_REC.USERNAME, 
                   UNAPIGEN.SQLUSERDESCRIPTION(P_EV_REC.USERNAME),
                   'EvMgrStatusChanged',
                   'status of '||UNAPIGEN.GETOBJTPDESCRIPTION(P_EV_REC.OBJECT_TP)||' "'||
                                                    P_EV_REC.OBJECT_ID||'" is automatically changed from "'||UNAPIGEN.SQLSSNAME(P_EV_REC.OBJECT_SS)||
                                 '" ['||P_EV_REC.OBJECT_SS||'] to "'||UNAPIGEN.SQLSSNAME(A_SS_TO)||'" ['||A_SS_TO||'].',
                   CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                   NULL,
                   UNAPIGEN.P_TR_SEQ,
                   P_EV_REC.EV_SEQ);
         END IF;
         IF P_LOG_HS_DETAILS THEN
            L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
            INSERT INTO UTSCMEHSDETAILS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, TR_SEQ, EV_SEQ, SEQ, DETAILS)
            VALUES(P_SC, P_PG, P_PGNODE, P_PA, P_PANODE, P_ME, P_MENODE, UNAPIGEN.P_TR_SEQ, P_EV_REC.EV_SEQ, L_HS_DETAILS_SEQ_NR, 
                   'status of '||UNAPIGEN.GETOBJTPDESCRIPTION(P_EV_REC.OBJECT_TP)||' "'||
                      P_EV_REC.OBJECT_ID||'" is automatically changed from "'||
                      UNAPIGEN.SQLSSNAME(P_EV_REC.OBJECT_SS)||'" ['||P_EV_REC.OBJECT_SS||
                      '] to "'||UNAPIGEN.SQLSSNAME(A_SS_TO)||'" ['||A_SS_TO||'].');
         END IF;
         IF L_SS_FORCED = TRUE AND
            UNAPIGEN.ISSYSTEM21CFR11COMPLIANT = UNAPIGEN.DBERR_SUCCESS THEN
            INSERT INTO UTSCMEHS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
            VALUES(P_SC, P_PG, P_PGNODE, P_PA, P_PANODE, P_ME, P_MENODE, 
                   P_EV_REC.USERNAME, 
                   UNAPIGEN.SQLUSERDESCRIPTION(P_EV_REC.USERNAME),
                   'EvMgrStatusForced',
                   'status of '||UNAPIGEN.GETOBJTPDESCRIPTION(P_EV_REC.OBJECT_TP)||' "'||
                                                    P_EV_REC.OBJECT_ID||'" is forced to "'||
                                                    UNAPIGEN.SQLSSNAME(A_SS_TO)||'" ['||A_SS_TO||'].',
                   CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                   NULL,
                   UNAPIGEN.P_TR_SEQ,
                   P_EV_REC.EV_SEQ);
            L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
            INSERT INTO UTSCMEHSDETAILS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, TR_SEQ, EV_SEQ, SEQ, DETAILS)
            VALUES(P_SC, P_PG, P_PGNODE, P_PA, P_PANODE, P_ME, P_MENODE, UNAPIGEN.P_TR_SEQ, P_EV_REC.EV_SEQ, L_HS_DETAILS_SEQ_NR, 
                   'status of '||UNAPIGEN.GETOBJTPDESCRIPTION(P_EV_REC.OBJECT_TP)||' "'||
                      P_EV_REC.OBJECT_ID||'" is forced to "'||UNAPIGEN.SQLSSNAME(A_SS_TO)||'" ['||A_SS_TO||'].');
         END IF;
         IF P_EV_OUTPUT_ON THEN
            UNTRACE.LOG('      '||'WHERE sc=' || P_SC || ' AND pg=' || P_PG ||
                                 ' AND pgnode= ' || P_PGNODE || ' AND pa=' ||
                                 P_PA || ' AND panode=' ||
                                 P_PANODE || ' AND me=' ||
                                 P_ME || ' AND menode=' || P_MENODE );
         END IF;
         L_OBJECT_ID := P_SC||P_PG||TO_CHAR(P_PGNODE)||P_PA||TO_CHAR(P_PANODE)||P_ME||TO_CHAR(P_MENODE);
      
      ELSIF P_EV_REC.OBJECT_TP = 'ws' THEN
         UPDATE UTWS
         SET LC = P_EV_REC.OBJECT_LC,
             LC_VERSION = P_EV_REC.OBJECT_LC_VERSION,
             SS = A_SS_TO,
             ALLOW_MODIFY = L_ALLOW_MODIFY,
             ACTIVE = L_ACTIVE
         WHERE WS = P_WS;
         IF P_LOG_HS THEN
            INSERT INTO UTWSHS(WS, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
            VALUES(P_WS, 
                   P_EV_REC.USERNAME, 
                   UNAPIGEN.SQLUSERDESCRIPTION(P_EV_REC.USERNAME),
                   'EvMgrStatusChanged',
                   'status of '||UNAPIGEN.GETOBJTPDESCRIPTION(P_EV_REC.OBJECT_TP)||' "'||
                                                    P_EV_REC.OBJECT_ID||'" is automatically changed from "'||UNAPIGEN.SQLSSNAME(P_EV_REC.OBJECT_SS)||
                                 '" ['||P_EV_REC.OBJECT_SS||'] to "'||UNAPIGEN.SQLSSNAME(A_SS_TO)||'" ['||A_SS_TO||'].',
                   CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                   NULL,
                   UNAPIGEN.P_TR_SEQ,
                   P_EV_REC.EV_SEQ);
         END IF;
         IF P_LOG_HS_DETAILS THEN
            L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
            INSERT INTO UTWSHSDETAILS(WS, TR_SEQ, EV_SEQ, SEQ, DETAILS)
            VALUES(P_WS, UNAPIGEN.P_TR_SEQ, P_EV_REC.EV_SEQ, L_HS_DETAILS_SEQ_NR, 
                   'status of '||UNAPIGEN.GETOBJTPDESCRIPTION(P_EV_REC.OBJECT_TP)||' "'||
                      P_EV_REC.OBJECT_ID||'" is forced to "'||
                      UNAPIGEN.SQLSSNAME(A_SS_TO)||'" ['||A_SS_TO||'].');
         END IF;
         IF L_SS_FORCED = TRUE AND
            UNAPIGEN.ISSYSTEM21CFR11COMPLIANT = UNAPIGEN.DBERR_SUCCESS THEN
            INSERT INTO UTWSHS(WS, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
            VALUES(P_WS, 
                   P_EV_REC.USERNAME, 
                   UNAPIGEN.SQLUSERDESCRIPTION(P_EV_REC.USERNAME),
                   'EvMgrStatusForced',
                   'status of '||UNAPIGEN.GETOBJTPDESCRIPTION(P_EV_REC.OBJECT_TP)||' "'||
                                                    P_EV_REC.OBJECT_ID||'" is forced to "'||
                                                    UNAPIGEN.SQLSSNAME(A_SS_TO)||'" ['||A_SS_TO||'].',
                   CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                   NULL,
                   UNAPIGEN.P_TR_SEQ,
                   P_EV_REC.EV_SEQ);
            L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
            INSERT INTO UTWSHSDETAILS(WS, TR_SEQ, EV_SEQ, SEQ, DETAILS)
            VALUES(P_WS, UNAPIGEN.P_TR_SEQ, P_EV_REC.EV_SEQ, L_HS_DETAILS_SEQ_NR, 
                   'status of '||UNAPIGEN.GETOBJTPDESCRIPTION(P_EV_REC.OBJECT_TP)||' "'||
                      P_EV_REC.OBJECT_ID||'" is forced to "'||UNAPIGEN.SQLSSNAME(A_SS_TO)||'" ['||A_SS_TO||'].');
         END IF;
         IF P_EV_OUTPUT_ON THEN
            UNTRACE.LOG('      '||'WHERE ws=' || P_WS );
         END IF;   
         L_OBJECT_ID := P_WS;
         
      ELSIF P_EV_REC.OBJECT_TP = 'ch' THEN
         UPDATE UTCH
         SET LC = P_EV_REC.OBJECT_LC,
             LC_VERSION = P_EV_REC.OBJECT_LC_VERSION,
             SS = A_SS_TO,
             ALLOW_MODIFY = L_ALLOW_MODIFY,
             ACTIVE = L_ACTIVE
         WHERE CH = P_CH;
         IF P_LOG_HS THEN
            INSERT INTO UTCHHS(CH, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
            VALUES(P_CH,
                   P_EV_REC.USERNAME,
                   UNAPIGEN.SQLUSERDESCRIPTION(P_EV_REC.USERNAME),
                   'EvMgrStatusChanged',
                   'status of '||UNAPIGEN.GETOBJTPDESCRIPTION(P_EV_REC.OBJECT_TP)||' "'||
                                                    P_EV_REC.OBJECT_ID||'" is automatically changed from "'||UNAPIGEN.SQLSSNAME(P_EV_REC.OBJECT_SS)||
                                 '" ['||P_EV_REC.OBJECT_SS||'] to "'||UNAPIGEN.SQLSSNAME(A_SS_TO)||'" ['||A_SS_TO||'].',
                   CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                   NULL,
                   UNAPIGEN.P_TR_SEQ,
                   P_EV_REC.EV_SEQ);
         END IF;
         IF P_LOG_HS_DETAILS THEN
            L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
            INSERT INTO UTCHHSDETAILS(CH, TR_SEQ, EV_SEQ, SEQ, DETAILS)
            VALUES(P_CH, UNAPIGEN.P_TR_SEQ, P_EV_REC.EV_SEQ, L_HS_DETAILS_SEQ_NR, 
                   'status of '||UNAPIGEN.GETOBJTPDESCRIPTION(P_EV_REC.OBJECT_TP)||' "'||
                      P_EV_REC.OBJECT_ID||'" is automatically changed from "'||
                      UNAPIGEN.SQLSSNAME(P_EV_REC.OBJECT_SS)||'" ['||P_EV_REC.OBJECT_SS||
                      '] to "'||UNAPIGEN.SQLSSNAME(A_SS_TO)||'" ['||A_SS_TO||'].');
         END IF;
         IF L_SS_FORCED = TRUE AND
            UNAPIGEN.ISSYSTEM21CFR11COMPLIANT = UNAPIGEN.DBERR_SUCCESS THEN
            INSERT INTO UTCHHS(CH, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
            VALUES(P_CH,
                   P_EV_REC.USERNAME,
                   UNAPIGEN.SQLUSERDESCRIPTION(P_EV_REC.USERNAME),
                   'EvMgrStatusForced',
                   'status of '||UNAPIGEN.GETOBJTPDESCRIPTION(P_EV_REC.OBJECT_TP)||' "'||
                                                    P_EV_REC.OBJECT_ID||'" is forced to "'||
                                                    UNAPIGEN.SQLSSNAME(A_SS_TO)||'" ['||A_SS_TO||'].',
                   CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                   NULL,
                   UNAPIGEN.P_TR_SEQ,
                   P_EV_REC.EV_SEQ);
            L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
            INSERT INTO UTCHHSDETAILS(CH, TR_SEQ, EV_SEQ, SEQ, DETAILS)
            VALUES(P_CH, UNAPIGEN.P_TR_SEQ, P_EV_REC.EV_SEQ, L_HS_DETAILS_SEQ_NR, 
                   'status of '||UNAPIGEN.GETOBJTPDESCRIPTION(P_EV_REC.OBJECT_TP)||' "'||
                      P_EV_REC.OBJECT_ID||'" is forced to "'||
                      UNAPIGEN.SQLSSNAME(A_SS_TO)||'" ['||A_SS_TO||'].');
         END IF;
         IF P_EV_OUTPUT_ON THEN
            UNTRACE.LOG('      '||'WHERE ch=' || P_CH );
         END IF;
         L_OBJECT_ID := P_CH;
         
      ELSE
         IF P_EV_OUTPUT_ON THEN
            UNTRACE.LOG('      '||'Unknown operational object type:' ||
                                 P_EV_REC.OBJECT_TP );
            INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ,
                                API_NAME, ERROR_MSG)
            VALUES (P_EV_REC.CLIENT_ID, P_EV_REC.APPLIC, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                    'EventTrigger-'||P_EV_REC.EV_TP,
                    'Unknown operational object type:' || P_EV_REC.OBJECT_TP);
         END IF;
      END IF;   

   ELSE
      IF P_EV_OUTPUT_ON THEN
         IF P_EV_REC.OBJECT_TP IN ('sc','rq', 'rqic', 'rqii', 'ws', 'sd', 'sdic', 'sdii') THEN
            UNTRACE.LOG('      '||'Updating ut' || P_EV_REC.OBJECT_TP || 
                        ' allow_modify =f(status= ' ||
                        P_EV_REC.OBJECT_SS || ')' );
         ELSE
            UNTRACE.LOG('      '||'Updating utsc'||P_EV_REC.OBJECT_TP||' allow_modify =f(status= ' ||
                                  P_EV_REC.OBJECT_SS || ')' );
         END IF;
      END IF;
      BEGIN
         SELECT ALLOW_MODIFY 
         INTO L_NEW_ALLOW_MODIFY
         FROM UTSS 
         WHERE SS =P_EV_REC.OBJECT_SS;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         L_NEW_ALLOW_MODIFY := NULL;
      END;

      IF P_EV_REC.OBJECT_TP = 'rq' THEN
         UPDATE UTRQ
         SET ALLOW_MODIFY = NVL(L_NEW_ALLOW_MODIFY,'0')
         WHERE RQ = P_RQ
         RETURNING ALLOW_MODIFY
         INTO L_ALLOW_MODIFY;
         L_OBJECT_ID := P_RQ;
         
      ELSIF P_EV_REC.OBJECT_TP = 'sc' THEN
         UPDATE UTSC
         SET ALLOW_MODIFY = NVL(L_NEW_ALLOW_MODIFY,'0')
         WHERE SC = P_SC
         RETURNING ALLOW_MODIFY
         INTO L_ALLOW_MODIFY;
         L_OBJECT_ID := P_SC;
         
      ELSIF P_EV_REC.OBJECT_TP = 'sd' THEN
         UPDATE UTSD
         SET ALLOW_MODIFY = NVL(L_NEW_ALLOW_MODIFY,'0')
         WHERE SD = P_SD
         RETURNING ALLOW_MODIFY
         INTO L_ALLOW_MODIFY;
         L_OBJECT_ID := P_SD;
         
      ELSIF P_EV_REC.OBJECT_TP = 'ic' THEN
         UPDATE UTSCIC
         SET ALLOW_MODIFY = NVL(L_NEW_ALLOW_MODIFY,'0')
         WHERE SC = P_SC
           AND IC = P_IC
           AND ICNODE = P_ICNODE
         RETURNING ALLOW_MODIFY
         INTO L_ALLOW_MODIFY;
         IF SQL%ROWCOUNT = 0 THEN
            L_SQLERRM := 'Nothing to update in utscic : '|| P_EV_REC.EV_DETAILS ||
                         ' on event : ' || P_EV_REC.EV_TP || ' ' ||
                         P_EV_REC.OBJECT_TP || '=' || P_EV_REC.OBJECT_ID;
            RAISE STPERROR;
         END IF;
         L_OBJECT_ID := P_SC||P_IC||TO_CHAR(P_ICNODE);
         
      ELSIF P_EV_REC.OBJECT_TP = 'rqic' THEN
         UPDATE UTRQIC RQIC
         SET ALLOW_MODIFY = NVL(L_NEW_ALLOW_MODIFY,'0')
         WHERE RQ = P_RQ
           AND IC = P_IC
           AND ICNODE = P_ICNODE
         RETURNING ALLOW_MODIFY
         INTO L_ALLOW_MODIFY;
         IF SQL%ROWCOUNT = 0 THEN
            L_SQLERRM := 'Nothing to update in utrqic : '|| P_EV_REC.EV_DETAILS ||
                         ' on event : ' || P_EV_REC.EV_TP || ' ' ||
                         P_EV_REC.OBJECT_TP || '=' || P_EV_REC.OBJECT_ID;
            RAISE STPERROR;
         END IF;
         L_OBJECT_ID := P_RQ||P_IC||TO_CHAR(P_ICNODE);
         
      ELSIF P_EV_REC.OBJECT_TP = 'sdic' THEN
         UPDATE UTSDIC SDIC
         SET ALLOW_MODIFY = NVL(L_NEW_ALLOW_MODIFY,'0')
         WHERE SD = P_SD
           AND IC = P_IC
           AND ICNODE = P_ICNODE
         RETURNING ALLOW_MODIFY
         INTO L_ALLOW_MODIFY;
         IF SQL%ROWCOUNT = 0 THEN
            L_SQLERRM := 'Nothing to update in utsdic : '|| P_EV_REC.EV_DETAILS ||
                         ' on event : ' || P_EV_REC.EV_TP || ' ' ||
                         P_EV_REC.OBJECT_TP || '=' || P_EV_REC.OBJECT_ID;
            RAISE STPERROR;
         END IF;
         L_OBJECT_ID := P_SD||P_IC||TO_CHAR(P_ICNODE);
         
      ELSIF P_EV_REC.OBJECT_TP = 'ii' THEN
         UPDATE UTSCII
         SET ALLOW_MODIFY = NVL(L_NEW_ALLOW_MODIFY,'0')
         WHERE SC = P_SC
           AND IC = P_IC
           AND ICNODE = P_ICNODE
           AND II = P_II
           AND IINODE = P_IINODE
         RETURNING ALLOW_MODIFY
         INTO L_ALLOW_MODIFY;
         L_OBJECT_ID := P_SC||P_IC||TO_CHAR(P_ICNODE)||P_II||TO_CHAR(P_IINODE);
           
      ELSIF P_EV_REC.OBJECT_TP = 'rqii' THEN
         UPDATE UTRQII
         SET ALLOW_MODIFY = NVL(L_NEW_ALLOW_MODIFY,'0')
         WHERE RQ = P_RQ
           AND IC = P_IC
           AND ICNODE = P_ICNODE
           AND II = P_II
           AND IINODE = P_IINODE
         RETURNING ALLOW_MODIFY
         INTO L_ALLOW_MODIFY;
         L_OBJECT_ID := P_RQ||P_IC||TO_CHAR(P_ICNODE)||P_II||TO_CHAR(P_IINODE);  
           
      ELSIF P_EV_REC.OBJECT_TP = 'sdii' THEN
         UPDATE UTSDII
         SET ALLOW_MODIFY = NVL(L_NEW_ALLOW_MODIFY,'0')
         WHERE SD = P_SD
           AND IC = P_IC
           AND ICNODE = P_ICNODE
           AND II = P_II
           AND IINODE = P_IINODE
         RETURNING ALLOW_MODIFY
         INTO L_ALLOW_MODIFY;
         L_OBJECT_ID := P_SD||P_IC||TO_CHAR(P_ICNODE)||P_II||TO_CHAR(P_IINODE);  
           
      ELSIF P_EV_REC.OBJECT_TP = 'pg' THEN
         UPDATE UTSCPG
         SET ALLOW_MODIFY = NVL(L_NEW_ALLOW_MODIFY,'0')
         WHERE SC = P_SC
           AND PG = P_PG
           AND PGNODE = P_PGNODE
         RETURNING ALLOW_MODIFY
         INTO L_ALLOW_MODIFY;
         L_OBJECT_ID := P_SC||P_PG||TO_CHAR(P_PGNODE);
           
      ELSIF P_EV_REC.OBJECT_TP = 'pa' THEN
         UPDATE UTSCPA
         SET ALLOW_MODIFY = NVL(L_NEW_ALLOW_MODIFY,'0')
         WHERE SC = P_SC
           AND PG = P_PG
           AND PGNODE = P_PGNODE
           AND PA = P_PA
           AND PANODE = P_PANODE
         RETURNING ALLOW_MODIFY
         INTO L_ALLOW_MODIFY;
         L_OBJECT_ID := P_SC||P_PG||TO_CHAR(P_PGNODE)||P_PA||TO_CHAR(P_PANODE);
         
      ELSIF P_EV_REC.OBJECT_TP = 'me' THEN
         UPDATE UTSCME
         SET ALLOW_MODIFY = NVL(L_NEW_ALLOW_MODIFY,'0')
         WHERE SC = P_SC
           AND PG = P_PG
           AND PGNODE = P_PGNODE
           AND PA = P_PA
           AND PANODE = P_PANODE
           AND ME = P_ME
           AND MENODE = P_MENODE
         RETURNING ALLOW_MODIFY
         INTO L_ALLOW_MODIFY;
         L_OBJECT_ID := P_SC||P_PG||TO_CHAR(P_PGNODE)||P_PA||TO_CHAR(P_PANODE)||P_ME||TO_CHAR(P_MENODE);
           
      ELSIF P_EV_REC.OBJECT_TP = 'ws' THEN
         UPDATE UTWS
         SET ALLOW_MODIFY = NVL(L_NEW_ALLOW_MODIFY,'0')
         WHERE WS = P_WS
         RETURNING ALLOW_MODIFY
         INTO L_ALLOW_MODIFY;          
         L_OBJECT_ID := P_WS;
         
      ELSIF P_EV_REC.OBJECT_TP = 'ch' THEN
         UPDATE UTCH
         SET ALLOW_MODIFY = NVL(L_NEW_ALLOW_MODIFY,'0')
         WHERE CH = P_CH
         RETURNING ALLOW_MODIFY
         INTO L_ALLOW_MODIFY;
         L_OBJECT_ID := P_CH;
         
      ELSE
         IF P_EV_OUTPUT_ON THEN
            UNTRACE.LOG('      '||'Unknown operational object type:' ||
                                 P_EV_REC.OBJECT_TP );
            INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME,
                                ERROR_MSG)
            VALUES (P_EV_REC.CLIENT_ID, P_EV_REC.APPLIC, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                    'EventTrigger-'||P_EV_REC.EV_TP,
                    'Unknown operational object type:' || P_EV_REC.OBJECT_TP);
         END IF;
      END IF;
   END IF;
   
   
   
   
   FOR L_SEQ_NO IN 1..UNAPIGEN.PA_OBJECT_NR LOOP
      IF UNAPIGEN.PA_OBJECT_TP(L_SEQ_NO) = P_EV_REC.OBJECT_TP AND 
         UNAPIGEN.PA_OBJECT_ID(L_SEQ_NO) = L_OBJECT_ID THEN

         IF A_SS_TO IS NOT NULL THEN
            UNAPIGEN.PA_OBJECT_SS(L_SEQ_NO) := A_SS_TO;          
            UNAPIGEN.PA_OBJECT_ACTIVE(L_SEQ_NO) := L_ACTIVE;
         END IF;            
         UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_SEQ_NO) := L_ALLOW_MODIFY;  
         IF UNAPIGEN.PA_OBJECT_PRIV(L_SEQ_NO) = UNAPIGEN.DBERR_TRANSITION THEN
            IF L_ALLOW_MODIFY = '1' THEN
               UNAPIGEN.PA_OBJECT_PRIV(L_SEQ_NO) := UNAPIGEN.DBERR_SUCCESS;
            ELSE 
               UNAPIGEN.PA_OBJECT_PRIV(L_SEQ_NO) := UNAPIGEN.DBERR_NOTMODIFIABLE;
            END IF;
         END IF;

         EXIT;

      END IF;
   END LOOP;
   
   SAVEPOINT_UNILAB4;
   L_RESULT := UNACCESS.UPDATEACCESSRIGHTS;
   SAVEPOINT_UNILAB4;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE = -60 THEN
      
      UNAPIGEN.P_DEADLOCK_RAISED := TRUE;
      
      IF UNAPIGEN.P_DEADLOCK_COUNT < UNAPIGEN.P_MAX_DEADLOCK_COUNT THEN
         RAISE;
      END IF;
   END IF;               
   IF SQLCODE <> 1 THEN
      L_SQLERRM := SUBSTR(SQLERRM,1,255);
      INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
      VALUES(P_EV_REC.CLIENT_ID, P_EV_REC.APPLIC, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
             'UpdateOpalObjectRecord', L_SQLERRM);
   ELSIF L_SQLERRM IS NOT NULL THEN
      INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
      VALUES(P_EV_REC.CLIENT_ID, P_EV_REC.APPLIC, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
             'UpdateOpalObjectRecord', L_SQLERRM); 
   END IF;
   L_SQLERRM := 'object_tp='||P_EV_REC.OBJECT_TP||'#object_id='||P_EV_REC.OBJECT_ID||
                '#lc='||P_EV_REC.OBJECT_LC||'#lc_version='||P_EV_REC.OBJECT_LC_VERSION||'#ev_tp='||P_EV_REC.EV_TP;
   INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
   VALUES (P_EV_REC.CLIENT_ID,
           P_EV_REC.APPLIC,
           UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
           'UpdateOpalObjectRecord', L_SQLERRM);
   SAVEPOINT_UNILAB4;           
END UPDATEOPALOBJECTRECORD;

PROCEDURE TIMEDEVENTMGR IS             

L_UP                                NUMBER(5);
L_USER_PROFILE                  VARCHAR2(40);
L_LANGUAGE                      VARCHAR2(20);
L_TK                                VARCHAR2(20);
L_NUMERIC_CHARACTERS    VARCHAR2(2);
L_DATEFORMAT                  VARCHAR2(255);
L_DBA_NAME                   VARCHAR2(40);
L_CURRENT_TIMESTAMP       TIMESTAMP WITH TIME ZONE;
L_TIMEZONE                      VARCHAR2(64);
L_JOB_SETCONCUSTOMPAR    VARCHAR2(255);
L_EV_REC        UTEV%ROWTYPE;

CURSOR C_EV_RULESDELAYED IS
   SELECT *
   FROM UTEVRULESDELAYED
   WHERE EXECUTE_AT <= L_CURRENT_TIMESTAMP;

BEGIN
   L_CURRENT_TIMESTAMP := CURRENT_TIMESTAMP;
   L_TIMEZONE := 'SERVER';
   
   L_DATEFORMAT := 'DDfx/fxMM/RR HH24fx:fxMI:SS';
   OPEN C_SYSTEM ('JOBS_DATE_FORMAT');
   FETCH C_SYSTEM INTO L_DATEFORMAT;
   CLOSE C_SYSTEM;
   
   OPEN C_SYSTEM ('DBA_NAME');
   FETCH C_SYSTEM INTO L_DBA_NAME;
   IF C_SYSTEM%NOTFOUND THEN
      CLOSE C_SYSTEM;
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_SYSDEFAULTS; 
      RAISE STPERROR;
   END IF;
   CLOSE C_SYSTEM;
     
   L_NUMERIC_CHARACTERS := 'DB';
   L_RET_CODE :=  UNAPIGEN.SETCONNECTION4INSTALL('TimEvmgr', 
                                         L_DBA_NAME ,
                                         'TimedEventMgr', 
                                         L_NUMERIC_CHARACTERS, 
                                         L_DATEFORMAT,
                                         L_TIMEZONE,
                                         L_UP, 
                                         L_USER_PROFILE, 
                                         L_LANGUAGE, 
                                         L_TK,
                                         '1');
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      IF L_RET_CODE = UNAPIGEN.DBERR_NOTAUTHORISED THEN
         L_SQLERRM := UNAPIAUT.P_NOT_AUTHORISED;
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
     

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   
   
   
   IF UNAPIEV.P_EVMGRS_1QBYINSTANCE = '0' THEN
      
      INSERT INTO UTEV(TR_SEQ, EV_SEQ, CREATED_ON, CREATED_ON_TZ, CLIENT_ID, APPLIC, DBAPI_NAME, EVMGR_NAME,
                       OBJECT_TP, OBJECT_ID, OBJECT_LC, OBJECT_LC_VERSION, OBJECT_SS, EV_TP, 
                       USERNAME, EV_DETAILS)
      SELECT UNAPIGEN.P_TR_SEQ, ROWNUM, CREATED_ON, CREATED_ON_TZ, CLIENT_ID, APPLIC, DBAPI_NAME,
             UNAPIGEN.P_EVMGR_NAME, OBJECT_TP, OBJECT_ID, OBJECT_LC, OBJECT_LC_VERSION, OBJECT_SS,
             EV_TP, USERNAME, EV_DETAILS
      FROM UTEVTIMED
      WHERE EXECUTE_AT <= L_CURRENT_TIMESTAMP;
   ELSE
      EXECUTE IMMEDIATE
         'INSERT INTO utev'||UNAPIGEN.P_INSTANCENR||
         ' (tr_seq, ev_seq, created_on, created_on_tz, client_id, applic, dbapi_name,'||
         'evmgr_name, object_tp, object_id, object_lc, object_lc_version, object_ss,'||
         'ev_tp, username, ev_details) '||
         'SELECT :TR_SEQ, ROWNUM, created_on, created_on_tz, client_id, applic, dbapi_name, '||
            ':EVMGR_NAME, object_tp, object_id, object_lc, object_lc_version, object_ss, '||
            'ev_tp, username, ev_details FROM utevtimed '||
         'WHERE execute_at <= :l_current_timestamp'
      USING UNAPIGEN.P_TR_SEQ, UNAPIGEN.P_EVMGR_NAME, L_CURRENT_TIMESTAMP;
   END IF;
   
   DELETE FROM UTEVTIMED WHERE EXECUTE_AT <= L_CURRENT_TIMESTAMP;

   
   
   
   IF UNAPIEV.P_EV_OUTPUT_ON THEN
      UNTRACE.LOG('TimedEventMgr: scanning delayed actions');
   END IF;

   
   L_RESULT := UNAPIAUT.DISABLEALLOWMODIFYCHECK('1');
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL; 
      RAISE STPERROR;
   END IF;

   FOR C_DELAYED_REC IN C_EV_RULESDELAYED LOOP
      IF UNAPIEV.P_EV_OUTPUT_ON THEN
         UNTRACE.LOG('TimedEventMgr:    action='||C_DELAYED_REC.AF);
      END IF;

      
      L_EV_REC.TR_SEQ            := UNAPIEV.P_EV_REC.TR_SEQ;
      L_EV_REC.EV_SEQ            := UNAPIEV.P_EV_REC.EV_SEQ;
      L_EV_REC.CREATED_ON        := UNAPIEV.P_EV_REC.CREATED_ON;
      L_EV_REC.CLIENT_ID         := UNAPIEV.P_EV_REC.CLIENT_ID;
      L_EV_REC.APPLIC            := UNAPIEV.P_EV_REC.APPLIC;
      L_EV_REC.DBAPI_NAME        := UNAPIEV.P_EV_REC.DBAPI_NAME;
      L_EV_REC.EVMGR_NAME        := UNAPIEV.P_EV_REC.EVMGR_NAME;
      L_EV_REC.OBJECT_TP         := UNAPIEV.P_EV_REC.OBJECT_TP;
      L_EV_REC.OBJECT_ID         := UNAPIEV.P_EV_REC.OBJECT_ID;
      L_EV_REC.OBJECT_LC         := UNAPIEV.P_EV_REC.OBJECT_LC;
      L_EV_REC.OBJECT_LC_VERSION := UNAPIEV.P_EV_REC.OBJECT_LC_VERSION;
      L_EV_REC.OBJECT_SS         := UNAPIEV.P_EV_REC.OBJECT_SS;
      L_EV_REC.EV_TP             := UNAPIEV.P_EV_REC.EV_TP;
      L_EV_REC.USERNAME          := UNAPIEV.P_EV_REC.USERNAME;
      L_EV_REC.EV_DETAILS        := UNAPIEV.P_EV_REC.EV_DETAILS;   
      
      
      UNAPIEV.P_EV_REC.TR_SEQ            := C_DELAYED_REC.TR_SEQ;
      UNAPIEV.P_EV_REC.EV_SEQ            := C_DELAYED_REC.EV_SEQ;
      UNAPIEV.P_EV_REC.CREATED_ON        := C_DELAYED_REC.CREATED_ON;
      UNAPIEV.P_EV_REC.CLIENT_ID         := C_DELAYED_REC.CLIENT_ID;
      UNAPIEV.P_EV_REC.APPLIC            := C_DELAYED_REC.APPLIC;
      UNAPIEV.P_EV_REC.DBAPI_NAME        := C_DELAYED_REC.DBAPI_NAME;
      UNAPIEV.P_EV_REC.EVMGR_NAME        := C_DELAYED_REC.EVMGR_NAME;
      UNAPIEV.P_EV_REC.OBJECT_TP         := C_DELAYED_REC.OBJECT_TP;
      UNAPIEV.P_EV_REC.OBJECT_ID         := C_DELAYED_REC.OBJECT_ID;
      UNAPIEV.P_EV_REC.OBJECT_LC         := C_DELAYED_REC.OBJECT_LC;
      UNAPIEV.P_EV_REC.OBJECT_LC_VERSION := C_DELAYED_REC.OBJECT_LC_VERSION;
      UNAPIEV.P_EV_REC.OBJECT_SS         := C_DELAYED_REC.OBJECT_SS;
      UNAPIEV.P_EV_REC.EV_TP             := C_DELAYED_REC.EV_TP;
      UNAPIEV.P_EV_REC.USERNAME          := C_DELAYED_REC.USERNAME;
      UNAPIEV.P_EV_REC.EV_DETAILS        := C_DELAYED_REC.EV_DETAILS;   
      UNAPIEV.EVALUATEEVENTDETAILS(UNAPIEV.P_EV_REC.EV_SEQ);

      
      L_RESULT := UNAPIEV.EXECUTEACTION(C_DELAYED_REC.AF);

      
      UNAPIEV.P_EV_REC.TR_SEQ            := L_EV_REC.TR_SEQ;
      UNAPIEV.P_EV_REC.EV_SEQ            := L_EV_REC.EV_SEQ;
      UNAPIEV.P_EV_REC.CREATED_ON        := L_EV_REC.CREATED_ON;
      UNAPIEV.P_EV_REC.CLIENT_ID         := L_EV_REC.CLIENT_ID;
      UNAPIEV.P_EV_REC.APPLIC            := L_EV_REC.APPLIC;
      UNAPIEV.P_EV_REC.DBAPI_NAME        := L_EV_REC.DBAPI_NAME;
      UNAPIEV.P_EV_REC.EVMGR_NAME        := L_EV_REC.EVMGR_NAME;
      UNAPIEV.P_EV_REC.OBJECT_TP         := L_EV_REC.OBJECT_TP;
      UNAPIEV.P_EV_REC.OBJECT_ID         := L_EV_REC.OBJECT_ID;
      UNAPIEV.P_EV_REC.OBJECT_LC         := L_EV_REC.OBJECT_LC;
      UNAPIEV.P_EV_REC.OBJECT_LC_VERSION := L_EV_REC.OBJECT_LC_VERSION;
      UNAPIEV.P_EV_REC.OBJECT_SS         := L_EV_REC.OBJECT_SS;
      UNAPIEV.P_EV_REC.EV_TP             := L_EV_REC.EV_TP;
      UNAPIEV.P_EV_REC.USERNAME          := L_EV_REC.USERNAME;
      UNAPIEV.P_EV_REC.EV_DETAILS        := L_EV_REC.EV_DETAILS;   
      UNAPIEV.EVALUATEEVENTDETAILS(UNAPIEV.P_EV_REC.EV_SEQ);

      
      IF UNAPIGEN.P_LOG_LC_ACTIONS OR L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
         BEGIN
            INSERT INTO UTEVLOG
                   (TR_SEQ, EV_SEQ, EV_SESSION, CREATED_ON, CREATED_ON_TZ, CLIENT_ID, APPLIC,
                    DBAPI_NAME, EVMGR_NAME, OBJECT_TP, OBJECT_ID,
                    OBJECT_LC, OBJECT_LC_VERSION, OBJECT_SS, EV_TP, EV_DETAILS, EXECUTED_ON, EXECUTED_ON_TZ,
                    ERRORCODE, WHAT, INSTANCE_NUMBER )
             VALUES(C_DELAYED_REC.TR_SEQ, C_DELAYED_REC.EV_SEQ, L_EV_SESSION, 
                    C_DELAYED_REC.CREATED_ON, C_DELAYED_REC.CREATED_ON_TZ, C_DELAYED_REC.CLIENT_ID, C_DELAYED_REC.APPLIC, 
                    C_DELAYED_REC.DBAPI_NAME, C_DELAYED_REC.EVMGR_NAME, C_DELAYED_REC.OBJECT_TP, 
                    C_DELAYED_REC.OBJECT_ID, C_DELAYED_REC.OBJECT_LC, 
                    C_DELAYED_REC.OBJECT_LC_VERSION, C_DELAYED_REC.OBJECT_SS, C_DELAYED_REC.EV_TP, 
                    C_DELAYED_REC.EV_DETAILS, L_CURRENT_TIMESTAMP, L_CURRENT_TIMESTAMP, L_RESULT, C_DELAYED_REC.AF, UNAPIGEN.P_INSTANCENR);
         EXCEPTION
         WHEN OTHERS THEN
            UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL; 
            RAISE STPERROR;
         END;
      END IF;

      IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
         
         DELETE 
         FROM UTEVRULESDELAYED
         WHERE AF                = C_DELAYED_REC.AF
           AND AF_DELAY          = C_DELAYED_REC.AF_DELAY
           AND AF_DELAY_UNIT     = C_DELAYED_REC.AF_DELAY_UNIT
           AND CREATED_ON        = C_DELAYED_REC.CREATED_ON
           AND EXECUTE_AT        = C_DELAYED_REC.EXECUTE_AT;
      END IF;
      
      
      SAVEPOINT_UNILAB4;
   END LOOP;
   
   
   L_RESULT := UNAPIAUT.DISABLEALLOWMODIFYCHECK('0');
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL; 
      RAISE STPERROR;
   END IF;
   
   
   DELETE 
   FROM UTEVRULESDELAYED
   WHERE EXECUTE_AT <= L_CURRENT_TIMESTAMP;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 AND SQLCODE <> -54 THEN
      UNAPIGEN.LOGERROR('TimedEventMgr', SQLERRM);
   END IF;
   IF L_SQLERRM IS NOT NULL THEN
      UNAPIGEN.LOGERROR('TimedEventMgr', L_SQLERRM);
      UNAPIGEN.U4COMMIT;
   END IF;
   IF C_SYSTEM%ISOPEN THEN
      CLOSE C_SYSTEM;
   END IF;
   L_RET_CODE := UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'TimedEventMgr');
END TIMEDEVENTMGR;

FUNCTION LAUNCHTIMEDEVENTMGR             
(A_REMOVE CHAR)
RETURN NUMBER IS         

L_JOB            VARCHAR2(30); 
L_ENABLED         VARCHAR2(5);
L_ACTION         VARCHAR2(4000);
L_INTERVAL       VARCHAR2(40);
L_SETTING_VALUE  VARCHAR2(40);
L_FOUND          BOOLEAN;
L_LEAVE_LOOP     BOOLEAN;
L_ATTEMPTS       INTEGER;
L_ISDBAUSER      INTEGER;

CURSOR L_JOBS_CURSOR (A_SEARCH VARCHAR2) IS
   SELECT JOB_NAME,ENABLED,JOB_ACTION
   FROM SYS.DBA_SCHEDULER_JOBS 
   WHERE INSTR(UPPER(JOB_ACTION), A_SEARCH)<>0;

BEGIN

   
   L_RET_CODE := UNAPIEV.CREATEDEFAULTSERVICELAYER;
     IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      L_ERRM := 'createDefaultServiceLayer failed ' || TO_CHAR(L_RET_CODE);
      RAISE STPERROR;
   END IF;

   
   
   
   
   
   
   OPEN L_JOBS_CURSOR('TIMEDEVENTMGR');
   FETCH L_JOBS_CURSOR INTO L_JOB,L_ENABLED,L_ACTION ;
   L_FOUND := L_JOBS_CURSOR%FOUND;
   CLOSE L_JOBS_CURSOR;

   L_ISDBAUSER := UNAPIGEN.ISEXTERNALDBAUSER;

   IF L_FOUND THEN
      
      
      IF A_REMOVE = '1' OR
         UPPER(L_ENABLED) = 'TRUE' THEN
         IF UNAPIGEN.ISUSERAUTHORISED(UNAPIGEN.P_CURRENT_UP, UNAPIGEN.P_USER, 'database', 'startstopjobs') <> UNAPIGEN.DBERR_SUCCESS AND 
            L_ISDBAUSER <> UNAPIGEN.DBERR_SUCCESS THEN
            RETURN(UNAPIGEN.DBERR_EVMGRSTARTNOTAUTHORISED);
         END IF;
      END IF;
      
      IF A_REMOVE = '1' THEN
         
         
         
         DBMS_SCHEDULER.DROP_JOB(L_JOB);
         
      ELSIF UPPER(L_ENABLED) = 'FALSE' THEN
         
         
         
         DBMS_SCHEDULER.ENABLE(L_JOB);
      END IF;
   ELSE 
      IF NVL(A_REMOVE, '0') = '0' THEN
         
         
         IF UNAPIGEN.ISUSERAUTHORISED(UNAPIGEN.P_CURRENT_UP, UNAPIGEN.P_USER, 'database', 'startstopjobs') <> UNAPIGEN.DBERR_SUCCESS AND 
            L_ISDBAUSER <> UNAPIGEN.DBERR_SUCCESS THEN
            RETURN(UNAPIGEN.DBERR_EVMGRSTARTNOTAUTHORISED);
         END IF;
         
         BEGIN
            SELECT SETTING_VALUE
            INTO L_SETTING_VALUE
            FROM UTSYSTEM
            WHERE SETTING_NAME = 'POLLING_INTERVAL';

            L_INTERVAL := L_SETTING_VALUE;

         EXCEPTION
         WHEN NO_DATA_FOUND THEN
            
            L_INTERVAL := '5' ; 
            L_SQLERRM := 'utsystem.setting_name(POLLING_INTERVAL) not found => Forced to 5 minutes';
            INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
            VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                   'LaunchTimedEventManager', L_SQLERRM);
         WHEN OTHERS THEN
            
            L_INTERVAL := '5' ; 
            L_SQLERRM := SUBSTR(SQLERRM,1,255);
            INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
            VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                   'LaunchTimedEventManager', L_SQLERRM);

         END;
         
         

         
         
         
         L_JOB := 'UNI_J_TimedEvMgr';
         DBMS_SCHEDULER.CREATE_JOB(
             JOB_NAME          =>  '"' ||UNAPIGEN.P_DBA_NAME||'".'||L_JOB,
             JOB_CLASS         => 'UNI_JC_OTHER_JOBS',
             JOB_TYPE          =>  'PLSQL_BLOCK',
             JOB_ACTION        =>  'UNAPIEV.TimedEventMgr;',
             START_DATE        =>   CURRENT_TIMESTAMP+ ((1/24)/60),
             
             
             REPEAT_INTERVAL   =>  UNAPIEV.SQLTRANSLATEDJOBINTERVAL(L_INTERVAL, 'minutes'),
             ENABLED           => TRUE
        );   
         DBMS_SCHEDULER.SET_ATTRIBUTE (
                    NAME           => L_JOB,
                    ATTRIBUTE      => 'restartable',
                    VALUE          => TRUE);
      END IF;
   END IF;

   UNAPIGEN.U4COMMIT;

   
   
   
   
      
   L_LEAVE_LOOP := FALSE;
   L_ATTEMPTS := 0;
   WHILE NOT L_LEAVE_LOOP LOOP
      L_ATTEMPTS := L_ATTEMPTS + 1;
      OPEN L_JOBS_CURSOR('TIMEDEVENTMGR');
      FETCH L_JOBS_CURSOR INTO L_JOB,L_ENABLED,L_ACTION ;
      L_FOUND := L_JOBS_CURSOR%FOUND;
      CLOSE L_JOBS_CURSOR;
      IF NVL(A_REMOVE, '0') = '0' THEN
         IF L_FOUND THEN 
            L_LEAVE_LOOP := TRUE;
         ELSE
            IF L_ATTEMPTS >= 30 THEN
               L_SQLERRM := 'TimedEventManager not started ! (timeout after 60 seconds)';
               RAISE STPERROR;
            ELSE
               DBMS_LOCK.SLEEP(2);
            END IF;
         END IF;
      ELSE
         IF NOT L_FOUND THEN 
            L_LEAVE_LOOP := TRUE;
         ELSE
            IF L_ATTEMPTS >= 30 THEN
               L_SQLERRM := 'TimedEventManager not stopped ! (timeout after 60 seconds)';
               RAISE STPERROR;
            ELSE
               DBMS_LOCK.SLEEP(2);
            END IF;
         END IF;
      END IF;
   END LOOP;
   
   RETURN(UNAPIGEN.DBERR_SUCCESS);
   
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      L_SQLERRM := SQLERRM;
   END IF;
   INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                     'LaunchTimedEventMgr' , L_SQLERRM );
   UNAPIGEN.U4COMMIT;
   IF L_JOBS_CURSOR%ISOPEN THEN
      CLOSE L_JOBS_CURSOR;
   END IF;
   IF C_SYSTEM%ISOPEN THEN
      CLOSE C_SYSTEM;
   END IF;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END LAUNCHTIMEDEVENTMGR;

FUNCTION STARTTIMEDEVENTMGR
RETURN NUMBER IS
BEGIN
   RETURN(LAUNCHTIMEDEVENTMGR('0'));
END STARTTIMEDEVENTMGR;

FUNCTION STOPTIMEDEVENTMGR 
RETURN NUMBER IS
BEGIN
   RETURN(LAUNCHTIMEDEVENTMGR('1'));
END STOPTIMEDEVENTMGR;

FUNCTION CREATEEVENTMANAGERQUEUES
(A_NR_OF_INSTANCES           IN        NUMBER)         
RETURN NUMBER IS
L_COUNT                INTEGER;
L_DATAC_TABLESPACE     VARCHAR2(30);
L_INDEXC_TABLESPACE    VARCHAR2(30);
BEGIN
   
   FOR L_X IN 1..A_NR_OF_INSTANCES LOOP
      SELECT COUNT('X')
      INTO L_COUNT
      FROM USER_TABLES
      WHERE TABLE_NAME = 'UTEV'||L_X;
      
      IF L_COUNT=0 THEN
         
         
         
         BEGIN
            SELECT SETTING_VALUE
            INTO L_DATAC_TABLESPACE
            FROM UTDBA
            WHERE SETTING_NAME = 'DATA_CONFIG_TSPACE';
         EXCEPTION
         WHEN OTHERS THEN
            L_DATAC_TABLESPACE := 'UNI_DATAC';
         END;

         BEGIN
            SELECT SETTING_VALUE
            INTO L_INDEXC_TABLESPACE
            FROM UTDBA
            WHERE SETTING_NAME = '';
         EXCEPTION
         WHEN OTHERS THEN
            L_INDEXC_TABLESPACE := 'UNI_INDEXC';
         END;

         BEGIN
            L_SQL_STRING := 'CREATE TABLE utev'||L_X||' TABLESPACE '||L_DATAC_TABLESPACE||' AS SELECT * FROM utev WHERE 1=0';
            EXECUTE IMMEDIATE L_SQL_STRING;

            L_SQL_STRING := 
            'ALTER TABLE utev'||L_X||' ADD CONSTRAINT ukev'||L_X||' PRIMARY KEY(tr_seq, ev_seq) '||
            'USING INDEX TABLESPACE '||L_INDEXC_TABLESPACE;                           
            EXECUTE IMMEDIATE L_SQL_STRING;
         EXCEPTION
         WHEN OTHERS THEN
            L_SQLERRM := SUBSTR(SQLERRM,1,200);
            INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
             VALUES(UNAPIEV.P_EV_REC.CLIENT_ID, UNAPIEV.P_EV_REC.APPLIC, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                'CreateEventManagerQueues', 'Exception occured while creating table utev'||L_X||'.'||L_SQLERRM);
            UNAPIGEN.U4COMMIT;
            INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
             VALUES(UNAPIEV.P_EV_REC.CLIENT_ID, UNAPIEV.P_EV_REC.APPLIC, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                'CreateEventManagerQueues', 'SQL used:'||L_SQL_STRING);
            UNAPIGEN.U4COMMIT;        
         END;         
      END IF;      
   END LOOP;  
   RETURN(UNAPIGEN.DBERR_SUCCESS);
END CREATEEVENTMANAGERQUEUES;

FUNCTION ISEVENTMANAGERRUNNING      
(A_EVMGR_NAME    IN    VARCHAR2)
RETURN NUMBER IS         
BEGIN
   
   RETURN UNAPIEV.STARTEVENTMGR(A_EVMGR_NAME, -10);
END ISEVENTMANAGERRUNNING;





FUNCTION STARTEVENTMGR      
(A_EVMGR_NAME    IN    VARCHAR2,
 A_HOW_MANY      IN    NUMBER,
 A_STARTREF_NR   IN    NUMBER,
 A_INSTANCE_NR   IN    NUMBER) 
RETURN NUMBER IS         

L_DBA_COUNT_DD                   NUMBER;
L_COUNT_DD                       NUMBER;
L_DD_DESCR                       VARCHAR2(40);
L_JOB                            VARCHAR2(30); 
L_ENABLED                        VARCHAR2(5);
L_ACTION                         VARCHAR2(4000);
L_COUNT_JOBS                     INTEGER;
L_JOB_X                          INTEGER;
L_EVMGR_NAME                     VARCHAR2(40);
L_LEAVE_LOOP                     BOOLEAN;
L_ATTEMPTS                       INTEGER;
L_ISDBAUSER                      INTEGER;
L_HOW_MANY_BY_INSTANCE           INTEGER;
L_HOW_MANY_IN_TOTAL              INTEGER;
L_COUNT_INSTANCES                INTEGER;
L_INSTANCE_NR                    INTEGER;
L_INSTANCE_ID                    VARCHAR2(16);  
L_RESULT                         INTEGER;
L_WAKEUPALSOSTUDYEVENTMGR        CHAR(1);
L_COUNT_JOBS4INSTANCE            INTEGER;
L_STARTREF_NR                    INTEGER;
L_JOB_ID                         INTEGER;

CURSOR L_COUNT_JOBS_CURSOR (A_EVMGR_NAME VARCHAR2) IS
   SELECT COUNT(JOB_NAME)
   FROM SYS.DBA_SCHEDULER_JOBS 
   WHERE INSTR(JOB_ACTION, 'UNAPIEV.EVENTMANAGERJOB('''||A_EVMGR_NAME||''',')<>0
   OR INSTR(JOB_ACTION, 'UNAPIEV.EVENTMANAGERJOB('''||DECODE(A_EVMGR_NAME,'U4EVMGR','STUDY_EVENT_MGR','')||''',')<>0;

CURSOR C_DBA IS
   SELECT TO_NUMBER(SETTING_VALUE)
   FROM UTDBA
   WHERE SETTING_NAME = 'DATADOMAINS';

CURSOR L_COUNT_JOBS4INSTANCE_CURSOR (A_EVMGR_NAME VARCHAR2) IS
   SELECT COUNT(B.JOB_NAME)
   FROM SYS.DBA_SCHEDULER_JOBS A, SYS.DBA_SCHEDULER_RUNNING_JOBS B
   WHERE B.JOB_NAME=A.JOB_NAME 
   
   
   AND B.OWNER=A.OWNER   
   AND INSTR(A.JOB_ACTION, 'UNAPIEV.EVENTMANAGERJOB('''||A_EVMGR_NAME||''',')<>0
   AND B.RUNNING_INSTANCE = NVL(A_INSTANCE_NR, TO_NUMBER(SYS_CONTEXT ('USERENV', 'INSTANCE')));
   
BEGIN
   
   
   OPEN UNAPIEV.C_EVENT_MANAGER_SETTINGS;
   FETCH UNAPIEV.C_EVENT_MANAGER_SETTINGS
   INTO UNAPIEV.P_EVMGRS_EV_IN_BULK, UNAPIEV.P_EVMGRS_POLLING_ON,
        UNAPIEV.P_EVMGRS_POLLINGINTERV, UNAPIEV.P_EVMGRS_1QBYINSTANCE,
        UNAPIEV.P_EVMGRS_COLLECTSTAT, UNAPIGEN.P_INSTANCENR;
   CLOSE UNAPIEV.C_EVENT_MANAGER_SETTINGS;
      
   
   
   IF A_HOW_MANY <> -10 THEN
      L_RET_CODE := UNAPIEV.CREATEDEFAULTSERVICELAYER;
        IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         L_ERRM := 'createDefaultServiceLayer failed ' || TO_CHAR(L_RET_CODE);
         RAISE STPERROR;
      END IF;
   END IF;
   
   L_HOW_MANY_BY_INSTANCE := A_HOW_MANY;
   SELECT COUNT(*)
   INTO L_COUNT_INSTANCES
   FROM SYS.GV_$INSTANCE;   
   L_HOW_MANY_IN_TOTAL := A_HOW_MANY*L_COUNT_INSTANCES;

   IF A_HOW_MANY <> -10 AND
      A_HOW_MANY>0 AND
      UNAPIEV.P_EVMGRS_1QBYINSTANCE='1' THEN
      L_RET_CODE := UNAPIEV.CREATEEVENTMANAGERQUEUES(L_COUNT_INSTANCES);
        IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         L_ERRM := 'createEventManagerQueues failed ' || TO_CHAR(L_RET_CODE);
         RAISE STPERROR;
      END IF;
   END IF;
   
   
   
   
   
   OPEN C_DBA;
   FETCH C_DBA INTO L_DBA_COUNT_DD;
   IF C_DBA%NOTFOUND THEN
      CLOSE C_DBA;
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_SYSDEFAULTS; 
      RAISE STPERROR;
   END IF;
   CLOSE C_DBA;
   
   SELECT COUNT(*)
   INTO L_COUNT_DD
   FROM UTDD;
   
   IF L_DBA_COUNT_DD > L_COUNT_DD THEN
      INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
      VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
             'StartEventMgr', 
             'Number of datadomains from utdba ('||TO_CHAR(L_DBA_COUNT_DD)||') does not match number of records from utdd ('||TO_CHAR(L_COUNT_DD)||') !!!');
      
      FOR I IN 1..(L_DBA_COUNT_DD-L_COUNT_DD) LOOP
         L_DD_DESCR := 'data domain '||TO_CHAR(L_COUNT_DD+I);
         INSERT INTO UTDD(DD, DESCRIPTION)
         VALUES(L_COUNT_DD+I, L_DD_DESCR);
         INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
         VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                'StartEventMgr', 
                'Datadomain '||TO_CHAR(L_COUNT_DD+I)||' ('''||L_DD_DESCR||''') was missing, and hence added in utdd.');
      END LOOP;
      UNAPIGEN.U4COMMIT;
   ELSIF L_DBA_COUNT_DD < L_COUNT_DD THEN
      INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
      VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
             'StartEventMgr', 
             'Number of datadomains from utdba ('||TO_CHAR(L_DBA_COUNT_DD)||') does not match number of records from utdd ('||TO_CHAR(L_COUNT_DD)||') !!!');
      
      FOR I IN 1..(L_COUNT_DD-L_DBA_COUNT_DD) LOOP
         DELETE UTDD
         WHERE DD = L_DBA_COUNT_DD+I;
         INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
         VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                'StartEventMgr', 
                'Datadomain '||TO_CHAR(L_DBA_COUNT_DD+I)||' was redundant, and hence removed from utdd.');
      END LOOP;
      UNAPIGEN.U4COMMIT;
   END IF;

   L_EVMGR_NAME := A_EVMGR_NAME;
   IF A_EVMGR_NAME IS NULL THEN
      L_EVMGR_NAME := 'U4EVMGR';
   END IF;
   
   
   
   
   
   
   
   OPEN L_COUNT_JOBS_CURSOR(L_EVMGR_NAME);
   FETCH L_COUNT_JOBS_CURSOR INTO L_COUNT_JOBS;
   CLOSE L_COUNT_JOBS_CURSOR;

   IF L_COUNT_JOBS < L_HOW_MANY_IN_TOTAL OR 
      (NVL(L_HOW_MANY_IN_TOTAL, 0) = 0 AND L_COUNT_JOBS > 0) THEN
      
      L_ISDBAUSER := UNAPIGEN.ISEXTERNALDBAUSER;
      IF UNAPIGEN.ISUSERAUTHORISED(UNAPIGEN.P_CURRENT_UP, UNAPIGEN.P_USER, 'database', 'startstopjobs') <> UNAPIGEN.DBERR_SUCCESS AND
          (L_ISDBAUSER <> UNAPIGEN.DBERR_SUCCESS) THEN
         RETURN (UNAPIGEN.DBERR_EVMGRSTARTNOTAUTHORISED); 
      ELSE   
         IF L_COUNT_JOBS < L_HOW_MANY_IN_TOTAL THEN            
            L_STARTREF_NR := NVL(A_STARTREF_NR,0);
            FOR L_JOB_X IN (L_COUNT_JOBS+1)..L_HOW_MANY_IN_TOTAL LOOP
               
               L_INSTANCE_NR := FLOOR((L_JOB_X-1)/L_HOW_MANY_BY_INSTANCE)+1;
               L_JOB_ID := L_JOB_X + L_STARTREF_NR;

               
               
               IF L_EVMGR_NAME = 'STUDY_EVENT_MGR' THEN
                  IF UNAPIEV.P_EVMGRS_1QBYINSTANCE ='1' THEN
                     EXECUTE IMMEDIATE
                     'DELETE FROM utev'||L_INSTANCE_NR||
                     ' WHERE evmgr_name = :l_evmgr_name'||
                     ' AND tr_seq = -:l_job_id'
                     USING L_EVMGR_NAME, 900+L_INSTANCE_NR;
                  ELSE
                     DELETE FROM UTEV
                     WHERE EVMGR_NAME = L_EVMGR_NAME
                     AND TR_SEQ = -(900+L_INSTANCE_NR);
                  END IF;
               ELSE
                  IF UNAPIEV.P_EVMGRS_1QBYINSTANCE ='1' THEN
                     EXECUTE IMMEDIATE
                     'DELETE FROM utev'||L_INSTANCE_NR||
                     ' WHERE evmgr_name = :l_evmgr_name'||
                     ' AND tr_seq = -:l_job_id'
                     USING L_EVMGR_NAME, L_JOB_ID;
                  ELSE
                     DELETE FROM UTEV
                     WHERE EVMGR_NAME = L_EVMGR_NAME
                     AND TR_SEQ = -L_JOB_ID;
                  END IF;
               END IF;

               SELECT INSTANCE_NAME 
               INTO L_INSTANCE_ID
               FROM (SELECT INSTANCE_NAME, ROW_NUMBER() OVER (ORDER BY INSTANCE_NUMBER) AS MYROW
                     FROM SYS.GV_$INSTANCE) B
               WHERE B.MYROW = L_INSTANCE_NR;
            
               IF L_EVMGR_NAME = 'STUDY_EVENT_MGR' THEN
                  
                   L_JOB := DBMS_SCHEDULER.GENERATE_JOB_NAME ('UNI_J_STEVMGR');
                   DBMS_SCHEDULER.CREATE_JOB
                      (JOB_NAME      =>  '"' ||UNAPIGEN.P_DBA_NAME||'".'||L_JOB,
                       JOB_CLASS     => 'UNI_JC_EVENTMGR_'||L_INSTANCE_ID,
                       JOB_TYPE      => 'PLSQL_BLOCK',
                       JOB_ACTION    => 'UNAPIEV.EVENTMANAGERJOB('''||L_EVMGR_NAME||''','||
                                                    TO_CHAR(900+L_INSTANCE_NR)||');',
                       ENABLED              => TRUE);
                   DBMS_SCHEDULER.SET_ATTRIBUTE 
                      (NAME           => L_JOB,
                       ATTRIBUTE      => 'restartable',
                       VALUE          => TRUE);
               ELSE
                  
                  
                  
                  L_JOB := DBMS_SCHEDULER.GENERATE_JOB_NAME ('UNI_J_' || L_EVMGR_NAME );
                  DBMS_SCHEDULER.CREATE_JOB
                     (JOB_NAME        =>  '"' ||UNAPIGEN.P_DBA_NAME||'".'||L_JOB,
                      JOB_CLASS       => 'UNI_JC_EVENTMGR_'||L_INSTANCE_ID,
                      JOB_TYPE        => 'PLSQL_BLOCK',
                      JOB_ACTION      => 'UNAPIEV.EVENTMANAGERJOB('''|| L_EVMGR_NAME || ''',' || TO_CHAR(L_JOB_ID) || ');',
                      ENABLED         => TRUE);
                  DBMS_SCHEDULER.SET_ATTRIBUTE 
                     (NAME            => L_JOB,
                      ATTRIBUTE       => 'restartable',
                      VALUE           => TRUE);
               END IF;
            END LOOP; 
         END IF;

         
         
         
         
         
         
         
         
         
         

         L_WAKEUPALSOSTUDYEVENTMGR := '1';
         IF NVL(L_HOW_MANY_IN_TOTAL, 0) = 0 THEN
            IF UNAPIEV.P_EVMGRS_POLLING_ON = '0' THEN
               DBMS_ALERT.SIGNAL( L_EVMGR_NAME , 'STOP' );
               IF L_EVMGR_NAME='U4EVMGR' THEN
                  
                  DBMS_ALERT.SIGNAL( 'STUDY_EVENT_MGR' , 'STOP' );
               END IF;
            ELSE
               
               
               
               L_EV_SEQ_NR := -1;
               L_EVENT_TP := 'STOP';
               IF L_EVMGR_NAME='U4EVMGR' THEN
                  L_WAKEUPALSOSTUDYEVENTMGR := '1';
               ELSE
                  L_WAKEUPALSOSTUDYEVENTMGR := '0';
               END IF;
               
               L_RESULT := BROADCASTEVENT ('EventMgr', L_EVMGR_NAME, 'xx', '', '', '', '', L_EVENT_TP, 'version=0', L_WAKEUPALSOSTUDYEVENTMGR, L_EV_SEQ_NR);
               IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
                  INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
                  VALUES(UNAPIEV.P_EV_REC.CLIENT_ID, UNAPIEV.P_EV_REC.APPLIC, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                         'StartEventMgr', 'BroadcastEvent#return=' || TO_CHAR(L_RESULT));
                  UNAPIGEN.U4COMMIT;
               END IF;
            END IF;
         END IF;
         UNAPIGEN.U4COMMIT;

         
         
         
         
            
         L_LEAVE_LOOP := FALSE;
         L_ATTEMPTS := 0;
         WHILE NOT L_LEAVE_LOOP LOOP
            L_ATTEMPTS := L_ATTEMPTS + 1;
            OPEN L_COUNT_JOBS_CURSOR(L_EVMGR_NAME);
            FETCH L_COUNT_JOBS_CURSOR INTO L_COUNT_JOBS;
            CLOSE L_COUNT_JOBS_CURSOR;
            IF NVL(L_HOW_MANY_IN_TOTAL, 0) = 0 THEN
               IF L_COUNT_JOBS = 0 THEN 
                  L_LEAVE_LOOP := TRUE;
               ELSE
                  IF L_ATTEMPTS >= 30 THEN
                     L_SQLERRM := 'EventManager Jobs not stopped ! (timeout after 60 seconds)';
                     RAISE STPERROR;
                  ELSE
                     
                     
                     
                     IF UNAPIEV.P_EVMGRS_POLLING_ON = '0' THEN
                        DBMS_ALERT.SIGNAL( L_EVMGR_NAME , 'STOP' );
                     ELSE
                        
                        
                        
                        L_EV_SEQ_NR := -1;
                        L_EVENT_TP := 'STOP';
                        L_RESULT := BROADCASTEVENT ('EventMgr', L_EVMGR_NAME, 'xx', '', '', '', '', L_EVENT_TP, 'version=0', L_WAKEUPALSOSTUDYEVENTMGR, L_EV_SEQ_NR);
                        IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
                           INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
                           VALUES(UNAPIEV.P_EV_REC.CLIENT_ID, UNAPIEV.P_EV_REC.APPLIC, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                                  'StartEventMgr', 'BroadcastEvent#return=' || TO_CHAR(L_RESULT));
                           UNAPIGEN.U4COMMIT;
                        END IF;
                     END IF;
                     UNAPIGEN.U4COMMIT;
                     DBMS_LOCK.SLEEP(2);
                  END IF;
               END IF;
            ELSE
               IF L_COUNT_JOBS >= NVL(L_HOW_MANY_IN_TOTAL, 0) THEN 
                  L_LEAVE_LOOP := TRUE;
               ELSE
                  IF L_ATTEMPTS >= 30 THEN
                     L_SQLERRM := 'EventManager Jobs not started ! (timeout after 60 seconds)';
                     RAISE STPERROR;
                  ELSE
                     DBMS_LOCK.SLEEP(2);
                  END IF;
               END IF;
            END IF;
         END LOOP;
         RETURN(UNAPIGEN.DBERR_SUCCESS);
      END IF;   
   ELSIF A_HOW_MANY = -10 THEN
      
      
      
      IF L_COUNT_JOBS > 0 THEN
         IF UNAPIEV.P_EVMGRS_1QBYINSTANCE = '0' THEN
            RETURN(UNAPIGEN.DBERR_SUCCESS);
         ELSE
            
            
            
            OPEN L_COUNT_JOBS4INSTANCE_CURSOR(L_EVMGR_NAME);
            FETCH L_COUNT_JOBS4INSTANCE_CURSOR 
            INTO L_COUNT_JOBS4INSTANCE;
            CLOSE L_COUNT_JOBS4INSTANCE_CURSOR;
            IF L_COUNT_JOBS4INSTANCE <= 0 THEN
               RETURN(UNAPIGEN.DBERR_EVMGRNOTSTARTED);
            ELSE
               RETURN(UNAPIGEN.DBERR_SUCCESS);
            END IF;                                      
         END IF;
      ELSE
         RETURN(UNAPIGEN.DBERR_EVMGRNOTSTARTED);
      END IF;
   ELSE
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      L_SQLERRM := SQLERRM;
   END IF;
   INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                     'StartEventMgr' , L_SQLERRM );
   IF L_COUNT_JOBS_CURSOR%ISOPEN THEN
      CLOSE L_COUNT_JOBS_CURSOR;
   END IF;
   IF C_DBA%ISOPEN THEN
      CLOSE C_DBA;
   END IF;
   UNAPIGEN.U4COMMIT;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END STARTEVENTMGR;

FUNCTION STARTEVENTMGR                           
(A_EVMGR_NAME    IN    VARCHAR2,
 A_HOW_MANY      IN    NUMBER,
 A_STARTREF_NR   IN    NUMBER)
RETURN NUMBER IS
BEGIN
   RETURN(STARTEVENTMGR(A_EVMGR_NAME,A_HOW_MANY, A_STARTREF_NR, NULL));
END STARTEVENTMGR;


FUNCTION STARTEVENTMGR      
(A_EVMGR_NAME    IN    VARCHAR2,
 A_HOW_MANY      IN    NUMBER)
RETURN NUMBER IS
BEGIN
   RETURN(STARTEVENTMGR(A_EVMGR_NAME,A_HOW_MANY, NULL, NULL));
END STARTEVENTMGR;

FUNCTION STOPEVENTMGR      
(A_EVMGR_NAME    IN    VARCHAR2) 
RETURN NUMBER IS         

L_JOB            VARCHAR2(30); 
L_ENABLED         VARCHAR2(5);
L_ACTION         VARCHAR2(4000);
L_SETTING_VALUE  VARCHAR2(40);
L_COUNT_JOBS     INTEGER;
L_JOB_X          INTEGER;
L_EVMGR_NAME     VARCHAR2(40);
L_TRY            INTEGER;

CURSOR L_COUNT_JOBS_CURSOR (A_EVMGR_NAME VARCHAR2) IS
   SELECT COUNT(JOB_NAME)
   FROM SYS.DBA_SCHEDULER_JOBS 
   WHERE INSTR(JOB_ACTION, 'UNAPIEV.EVENTMANAGERJOB('''||A_EVMGR_NAME||''',')<>0;

BEGIN

   L_EVMGR_NAME := A_EVMGR_NAME;
   IF A_EVMGR_NAME IS NULL THEN
      L_EVMGR_NAME := 'U4EVMGR';
   END IF;
   
   
   
   
   
   
   L_TRY := 12;
   WHILE L_TRY > 0 LOOP
      OPEN L_COUNT_JOBS_CURSOR(L_EVMGR_NAME);
      FETCH L_COUNT_JOBS_CURSOR INTO L_COUNT_JOBS;
      CLOSE L_COUNT_JOBS_CURSOR;
   
      IF L_COUNT_JOBS > 0 THEN
         L_RET_CODE := STARTEVENTMGR(L_EVMGR_NAME, 0);
      ELSE
         RETURN(UNAPIGEN.DBERR_SUCCESS);
      END IF;
      L_TRY := L_TRY - 1;
      DBMS_LOCK.SLEEP(10);
   END LOOP;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
   
EXCEPTION
WHEN OTHERS THEN
   L_SQLERRM := SQLERRM;
   INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                     'StopEventMgr' , L_SQLERRM );
   IF L_COUNT_JOBS_CURSOR%ISOPEN THEN
      CLOSE L_COUNT_JOBS_CURSOR;
   END IF;
   UNAPIGEN.U4COMMIT;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END STOPEVENTMGR;

PROCEDURE EVENTMANAGERJOB        
(A_EVMGR_NAME IN VARCHAR2,
 A_EV_SESSION IN NUMBER)
IS

L_ALERT_MESSAGE          VARCHAR2(200);
L_STATUS                 INTEGER;
L_TR_SEQ                 NUMBER;
L_TR_SEQ_MSG             NUMBER;
L_TR_SEQ_VC              VARCHAR2(200);
L_LAST_TR_SEQ            NUMBER;
L_LOCKNAME               VARCHAR2(30);
L_LOCKHANDLE             VARCHAR2(200);
L_NUMERIC_CHARACTERS     VARCHAR2(2);
L_DATEFORMAT             VARCHAR2(255);
L_UP                     NUMBER(5);
L_USER_PROFILE           VARCHAR2(40);
L_LANGUAGE               VARCHAR2(20);
L_TK                     VARCHAR2(20);
L_LOCKED                 BOOLEAN;
L_NOT_THE_FIRST_TIME     BOOLEAN;
L_DBA_NAME               VARCHAR2(40);
L_CLIENT_ID                 VARCHAR2(20);
L_STOPEVMGR              BOOLEAN;
L_TIMEZONE                VARCHAR2(64);
L_JOB_SETCONCUSTOMPAR    VARCHAR2(255);

CURSOR L_TR_SEQ_CURSOR (A_TR_SEQ IN NUMBER) IS
   SELECT MIN(TR_SEQ) 
   FROM UTEV
   WHERE (TR_SEQ >= A_TR_SEQ OR TR_SEQ=-A_EV_SESSION)
   AND EVMGR_NAME = A_EVMGR_NAME;
   
BEGIN
   
                      
   
   
   
   L_DATEFORMAT := 'DD/MM/RR HH24:MI:SS';
   OPEN C_SYSTEM ('JOBS_DATE_FORMAT');
   FETCH C_SYSTEM INTO L_DATEFORMAT;
   CLOSE C_SYSTEM;
   
   OPEN C_SYSTEM ('DBA_NAME');
   FETCH C_SYSTEM INTO L_DBA_NAME;
   IF C_SYSTEM%NOTFOUND THEN
      CLOSE C_SYSTEM;
      L_ERRM := 'DBA_NAME system default not defined ';
      RAISE STPERROR;
   END IF;
   CLOSE C_SYSTEM;

   OPEN C_SYSTEM ('EV_CLIENT_ID');
   FETCH C_SYSTEM INTO L_CLIENT_ID;
   IF C_SYSTEM%NOTFOUND THEN
      CLOSE C_SYSTEM;
      L_CLIENT_ID := 'EvMgrJob';
   ELSE
      CLOSE C_SYSTEM;
   END IF;

   L_TIMEZONE := 'SERVER';   
   L_NUMERIC_CHARACTERS := 'DB';
   L_RET_CODE := UNAPIGEN.SETCONNECTION4INSTALL(L_CLIENT_ID, 
                                        L_DBA_NAME, 
                                        'EvMgrJob'||TO_CHAR(A_EV_SESSION), L_NUMERIC_CHARACTERS, L_DATEFORMAT,L_TIMEZONE,
                                         L_UP, L_USER_PROFILE, L_LANGUAGE, L_TK, '1');
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      L_ERRM := 'SetConnection failed ' || TO_CHAR(L_RET_CODE);
      IF L_RET_CODE = UNAPIGEN.DBERR_NOTAUTHORISED THEN
         L_SQLERRM := UNAPIAUT.P_NOT_AUTHORISED;
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
   

   
   
   
   
   
   
   
   
   
   IF UNAPIEV.P_EVMGRS_1QBYINSTANCE = '0' THEN
      UPDATE UTEV D
      SET D.EVMGR_NAME = 'U4EVMGR'
      WHERE TR_SEQ IN (SELECT C.TR_SEQ FROM UTEV C WHERE C.EVMGR_NAME='1')
      AND TO_CHAR(TR_SEQ) NOT IN (SELECT SUBSTR(NAME,8) TR_SEQ_LOCKED
                         FROM V$LOCK A, SYS.DBMS_LOCK_ALLOCATED B
                         WHERE A.TYPE='UL'
                         AND A.ID1=B.LOCKID 
                         AND B.NAME LIKE 'U4EVMGR%'
                         AND B.NAME<> 'U4EVMGRSTART_OR_STOP');
      IF SQL%ROWCOUNT > 0 THEN
         INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
         VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                'EvMgrJob', 'Some events have been left unhandled in the system. These events will be marked as to be reprocessed. Problem should be investigated by the dba.');
         UNAPIGEN.U4COMMIT;   
      END IF;
   ELSE
      EXECUTE IMMEDIATE 
         'UPDATE utev'||UNAPIGEN.P_INSTANCENR||' d '||
         'SET d.evmgr_name = ''U4EVMGR'' '||
         'WHERE tr_seq IN (SELECT c.tr_seq FROM utev'||UNAPIGEN.P_INSTANCENR||' c WHERE c.evmgr_name=''1'') '||
         'AND TO_CHAR(tr_seq) NOT IN (SELECT SUBSTR(name,8) tr_seq_locked '||
                            'FROM v$lock a, sys.dbms_lock_allocated b '||
                            'WHERE a.TYPE=''UL'' '||
                            'AND a.id1=b.lockid '||
                            'AND b.name LIKE ''U4EVMGR%'' '||
                            'AND b.name<> ''U4EVMGRSTART_OR_STOP'') ';
      IF SQL%ROWCOUNT > 0 THEN
         INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
         VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                'EvMgrJob', 'Some events have been left unhandled in the system. These events will be marked as to be reprocessed. Problem should be investigated by the dba.');
         UNAPIGEN.U4COMMIT;   
      END IF;
      

   END IF;
   UNAPIGEN.U4COMMIT; 
    
   UNAPIGEN.P_EVMGR_NAME := A_EVMGR_NAME;
   L_EV_SESSION := TO_CHAR(A_EV_SESSION);

   
   
   
   
   
   
   
   P_EV_MGR_SESSION := TRUE;
   L_LAST_TR_SEQ := -1000;
   L_LOCKED := FALSE;

   
   P_CLIENT_EVMGR_USED := 'NO';
   OPEN C_SYSTEM ('CLIENT_EVMGR_USED');
   FETCH C_SYSTEM 
   INTO P_CLIENT_EVMGR_USED;
   CLOSE C_SYSTEM;
   
   
   
   
   IF UNAPIEV.P_EVMGRS_POLLING_ON = '0' THEN 
      DBMS_ALERT.REGISTER(A_EVMGR_NAME);
   END IF;
   
   
   
   
   
   L_NOT_THE_FIRST_TIME := FALSE;
   L_STATUS := 0;
   L_ALERT_MESSAGE := '0';  
   L_STOPEVMGR := FALSE;
   
   
   
   
   
   
   
   
   
   
   IF UNAPIGEN.P_NODUMP_ON_DEADLOCK IS NOT NULL THEN
      EXECUTE IMMEDIATE UNAPIGEN.P_NODUMP_ON_DEADLOCK;
   END IF;
   
   LOOP
      
      
      
      
      IF L_NOT_THE_FIRST_TIME THEN
         IF UNAPIEV.P_EVMGRS_POLLING_ON = '1' THEN 
            DBMS_APPLICATION_INFO.SET_ACTION ('Sleeping between 2 processing');
            DBMS_LOCK.SLEEP(UNAPIEV.P_EVMGRS_POLLINGINTERV/1000);
            L_STATUS := 0; 
         ELSE            
            DBMS_APPLICATION_INFO.SET_ACTION ('Waiting for alert');
            DBMS_ALERT.WAITONE(A_EVMGR_NAME, L_ALERT_MESSAGE, L_STATUS, P_WAITFORALERTTIMEOUT);
         END IF;
      END IF;
      L_NOT_THE_FIRST_TIME := TRUE;
      
      IF L_STATUS = 0 THEN

         DBMS_APPLICATION_INFO.SET_ACTION ('Processing events');
         
         
         
         EXIT WHEN L_ALERT_MESSAGE = 'STOP' OR L_STOPEVMGR;

         
         
         
         L_TR_SEQ_MSG := TO_NUMBER(L_ALERT_MESSAGE);
         L_TR_SEQ_VC  := L_ALERT_MESSAGE;
         L_TR_SEQ     := NULL;
         L_LAST_TR_SEQ := -10000;
         
         
         
         
         LOOP

            
            
            
            
            IF UNAPIEV.P_EVMGRS_1QBYINSTANCE = '0' THEN
               OPEN L_TR_SEQ_CURSOR(L_LAST_TR_SEQ+1);
               FETCH L_TR_SEQ_CURSOR INTO L_TR_SEQ;
               IF L_TR_SEQ IS NULL THEN
                  CLOSE L_TR_SEQ_CURSOR;
                  EXIT;
               END IF;
               CLOSE L_TR_SEQ_CURSOR;
            ELSE
              L_TR_SEQ := NULL;
              EXECUTE IMMEDIATE
                 'SELECT MIN(tr_seq) FROM utev'||UNAPIGEN.P_INSTANCENR||' WHERE (tr_seq >= :a_tr_seq OR tr_seq=-:a_ev_session) AND evmgr_name = :a_evmgr_name'
                 INTO L_TR_SEQ
                 USING L_LAST_TR_SEQ+1,A_EV_SESSION,A_EVMGR_NAME;              
              IF L_TR_SEQ IS NULL THEN
                 EXIT;
              END IF;
            END IF;
            
            L_LAST_TR_SEQ := L_TR_SEQ;
            L_TR_SEQ_VC := TO_CHAR(L_TR_SEQ);

            
            
            
            
            
            
            
            IF L_LAST_TR_SEQ >= 0 OR L_LAST_TR_SEQ = -A_EV_SESSION THEN
               
               
               
               
               L_LOCKNAME := 'U4EVMGR'||L_TR_SEQ_VC;
               DBMS_LOCK.ALLOCATE_UNIQUE(L_LOCKNAME, L_LOCKHANDLE, 60);

               
               
               
               
               
               
               
               
               L_RET_CODE := DBMS_LOCK.REQUEST(L_LOCKHANDLE, DBMS_LOCK.X_MODE, 
                                               0.01, FALSE);
               IF L_RET_CODE = UNAPIGEN.DBERR_SUCCESS THEN
                  L_LOCKED := TRUE;

                  L_RET_CODE := UNAPIEV2.EVENTMANAGER(L_TR_SEQ);            
                  IF L_RET_CODE = UNAPIGEN.DBERR_STOPEVMGR THEN
                     L_STOPEVMGR := TRUE;
                  END IF;
                  L_RET_CODE := DBMS_LOCK.RELEASE(L_LOCKHANDLE);
                  IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                     INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
                     VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                           'EvMgrJob', 'Major Error : Releasing lock '||L_LOCKNAME||':('||L_LOCKHANDLE||
                           ')returned '||TO_CHAR(L_RET_CODE));
                    UNAPIGEN.U4COMMIT;
                  END IF;
                  L_LOCKED := FALSE;

                  
                  
                  
                  
                  UNAPIGEN.U4COMMIT;
               ELSE
                  IF L_RET_CODE <> 1 THEN
                     INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
                     VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                            'EvMgrJob', 'Major Error : Requesting lock '||L_LOCKNAME||':('||L_LOCKHANDLE||
                                     ') returned '||TO_CHAR(L_RET_CODE));
                     UNAPIGEN.U4COMMIT;
                  END IF;
               END IF;
            ELSE
               
               
               
               NULL;
               
            END IF;
            
            
            
            
            L_TR_SEQ := NULL;
            
         END LOOP;
      END IF;
   END LOOP;   

   
   
   IF UNAPIEV.P_EVMGRS_1QBYINSTANCE = '0' THEN
      DELETE FROM UTEV
      WHERE EV_TP='STOP'
      AND TR_SEQ = -A_EV_SESSION
      AND EVMGR_NAME = A_EVMGR_NAME;
   ELSE
      EXECUTE IMMEDIATE
         'DELETE FROM utev'||UNAPIGEN.P_INSTANCENR||' WHERE ev_tp=''STOP'' AND tr_seq = -:a_ev_session AND evmgr_name = :a_evmgr_name'
      USING A_EV_SESSION,A_EVMGR_NAME;
   END IF;   
   
   DBMS_APPLICATION_INFO.SET_ACTION (NULL);
   UNAPIGEN.U4COMMIT;

EXCEPTION
WHEN OTHERS THEN
   DBMS_APPLICATION_INFO.SET_ACTION (NULL);
   IF SQLCODE <> 1 THEN
      L_SQLERRM := SUBSTR(SQLERRM,1,255);
   ELSE
      IF L_SQLERRM IS NOT NULL THEN
         INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
         VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                'EvMgrJob', L_SQLERRM);      
      END IF;
      L_SQLERRM := L_ERRM;
   END IF;
   INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
          'EvMgrJob', L_SQLERRM);
   IF L_TR_SEQ_CURSOR%ISOPEN THEN
      CLOSE L_TR_SEQ_CURSOR;
   END IF;
   
   
   
   IF L_LOCKED THEN
      L_RET_CODE := DBMS_LOCK.RELEASE(L_LOCKHANDLE);
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
         VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                'EvMgrJob', 'Major error : Releasing lock '||L_LOCKNAME||':('||L_LOCKHANDLE||
                ')returned '||TO_CHAR(L_RET_CODE));
         UNAPIGEN.U4COMMIT;
      END IF;
   END IF;
   IF C_SYSTEM%ISOPEN THEN
      CLOSE C_SYSTEM;
   END IF;   
   UNAPIGEN.U4COMMIT;
END EVENTMANAGERJOB;

FUNCTION STARTALLMGRS       
RETURN NUMBER IS

L_LOCKHANDLE              VARCHAR2(200);
L_SETTING_VALUE           VARCHAR2(40);
L_LOCKED                  BOOLEAN;
L_LOCKNAME               VARCHAR2(30);
L_SESSION_TIMEZONE       VARCHAR2(64);

BEGIN

    SELECT SESSIONTIMEZONE
      INTO L_SESSION_TIMEZONE
      FROM DUAL;
    EXECUTE IMMEDIATE 'ALTER SESSION SET time_zone = DBTIMEZONE';
  
   
   
   
   
   
   L_LOCKNAME := 'U4EVMGRSTART_OR_STOP'; 
   DBMS_LOCK.ALLOCATE_UNIQUE(L_LOCKNAME, L_LOCKHANDLE, 120);

   L_LOCKED := FALSE;
   L_RET_CODE := DBMS_LOCK.REQUEST(L_LOCKHANDLE, DBMS_LOCK.X_MODE, 
                                   0.01, FALSE);
   IF L_RET_CODE = UNAPIGEN.DBERR_SUCCESS THEN
      L_LOCKED := TRUE;
      OPEN C_SYSTEM ('EVENT_MGRS_TO_START');
      FETCH C_SYSTEM INTO L_SETTING_VALUE;
      IF C_SYSTEM%NOTFOUND THEN
         CLOSE C_SYSTEM;
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_SYSDEFAULTS; 
         RAISE STPERROR;
      END IF;
      CLOSE C_SYSTEM;

      L_RET_CODE := UNAPIEV.STARTEVENTMGR(UNAPIGEN.P_EVMGR_NAME, 
                                          TO_NUMBER(L_SETTING_VALUE));
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         L_SQLERRM :=  'Event manager could not be started : fatal error '||
                       TO_CHAR(L_RET_CODE);
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE; 
         RAISE STPERROR;
      END IF;

      L_RET_CODE := UNAPIEV.STARTTIMEDEVENTMGR;
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      
         L_SQLERRM := 'Timed Event manager could not be started : fatal error '||
                      TO_CHAR(L_RET_CODE);
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE; 
         RAISE STPERROR;
      END IF;

      L_RET_CODE := UNAPIEQM.STARTEQMANAGER;
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      
         L_SQLERRM := 'Equipment manager could not be started : fatal error '||
                      TO_CHAR(L_RET_CODE);
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE; 
         RAISE STPERROR;
      END IF;

      L_RET_CODE := UNAPIGEN.STARTNEWVERSIONMGR;
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         L_SQLERRM := 'NewVersion Manager could not be started : fatal error '||
                      TO_CHAR(L_RET_CODE);
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE; 
         RAISE STPERROR;
      END IF;

      
      L_RET_CODE := UNAPIEV.STARTEVENTMGR('STUDY_EVENT_MGR',1);
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         L_SQLERRM :=  'Study event manager could not be started : fatal error '||
                       TO_CHAR(L_RET_CODE);
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE; 
         RAISE STPERROR;
      END IF;

   ELSIF L_RET_CODE = 1 THEN
      
      
      NULL;
      
   ELSIF L_RET_CODE <> 1 THEN
      
      
      L_SQLERRM := 'Major Error : Requesting lock U4EVMGRSTART_OR_STOP '||
      ' returned '||TO_CHAR(L_RET_CODE);
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL; 
      RAISE STPERROR;
   END IF;
   
   UNAPIGEN.U4COMMIT;
   
   
   
   
   EXECUTE IMMEDIATE 'ALTER SESSION SET time_zone = ''' || L_SESSION_TIMEZONE || '''';

   IF L_LOCKED THEN
      L_RET_CODE := DBMS_LOCK.RELEASE(L_LOCKHANDLE);
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         L_SQLERRM :=  'Major error : Releasing lock '||L_LOCKNAME||':('||L_LOCKHANDLE||
                       ')returned '||TO_CHAR(L_RET_CODE);
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE; 
         RAISE STPERROR;         
      END IF;
      L_LOCKED := FALSE;
   END IF;
   RETURN(UNAPIGEN.DBERR_SUCCESS);
 
EXCEPTION
WHEN OTHERS THEN
   
   EXECUTE IMMEDIATE 'ALTER SESSION SET time_zone = ''' || L_SESSION_TIMEZONE || '''';
   IF SQLCODE <> 1 THEN
      L_SQLERRM := SQLERRM;
   END IF;
   UNAPIGEN.U4ROLLBACK;
   INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
   'StartAllMgrs', L_SQLERRM);
   UNAPIGEN.U4COMMIT;
   IF C_SYSTEM%ISOPEN THEN
      CLOSE C_SYSTEM;
   END IF;

   
   
   
   IF L_LOCKED THEN
      L_RET_CODE := DBMS_LOCK.RELEASE(L_LOCKHANDLE);
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
         VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                'StartAllMgrs', 'Major error : Releasing lock '||L_LOCKNAME||':('||L_LOCKHANDLE||
                ')returned '||TO_CHAR(L_RET_CODE));
         UNAPIGEN.U4COMMIT;         
      END IF;
      L_LOCKED := FALSE;
   END IF;
   IF UNAPIGEN.P_TXN_ERROR <> UNAPIGEN.DBERR_SUCCESS THEN
      RETURN(UNAPIGEN.P_TXN_ERROR);
   ELSE
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   END IF;   
END STARTALLMGRS;


FUNCTION STOPALLMGRS       
RETURN NUMBER IS

L_LOCKHANDLE              VARCHAR2(200);
L_LOCKED                  BOOLEAN;
L_LOCKNAME                VARCHAR2(30);
L_SESSION_TIMEZONE        VARCHAR2(64);

BEGIN
    SELECT SESSIONTIMEZONE
      INTO L_SESSION_TIMEZONE
      FROM DUAL;
    EXECUTE IMMEDIATE 'ALTER SESSION SET time_zone = DBTIMEZONE';

   
   OPEN UNAPIEV.C_EVENT_MANAGER_SETTINGS;
   FETCH UNAPIEV.C_EVENT_MANAGER_SETTINGS
   INTO UNAPIEV.P_EVMGRS_EV_IN_BULK, UNAPIEV.P_EVMGRS_POLLING_ON,
        UNAPIEV.P_EVMGRS_POLLINGINTERV, UNAPIEV.P_EVMGRS_1QBYINSTANCE,
        UNAPIEV.P_EVMGRS_COLLECTSTAT, UNAPIGEN.P_INSTANCENR;
   CLOSE UNAPIEV.C_EVENT_MANAGER_SETTINGS;

   
   
   
   
   
   L_LOCKNAME := 'U4EVMGRSTART_OR_STOP';
   DBMS_LOCK.ALLOCATE_UNIQUE(L_LOCKNAME, L_LOCKHANDLE, 120);

   L_LOCKED := FALSE;
   L_RET_CODE := DBMS_LOCK.REQUEST(L_LOCKHANDLE, DBMS_LOCK.X_MODE, 
                                   0.01, FALSE);
   IF L_RET_CODE = UNAPIGEN.DBERR_SUCCESS THEN

      L_LOCKED := TRUE;
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      L_RET_CODE := UNAPIGEN.STOPNEWVERSIONMGR;
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         L_SQLERRM :=  'NewVersion Manager could not be stopped : fatal error '||
                       TO_CHAR(L_RET_CODE);
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE; 
         RAISE STPERROR;         
      END IF;

      L_RET_CODE := UNAPIEQM.STOPEQMANAGER;
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         L_SQLERRM :=  'Equipment manager could not be stopped : fatal error '||
                       TO_CHAR(L_RET_CODE);
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE; 
         RAISE STPERROR;         
      END IF;

      L_RET_CODE := UNAPIEV.STOPTIMEDEVENTMGR;
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         L_SQLERRM :=  'Timed Event manager could not be stopped : fatal error '||
                       TO_CHAR(L_RET_CODE);
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE; 
         RAISE STPERROR;         
      END IF;
      
      L_RET_CODE := UNAPIEV.STARTEVENTMGR(UNAPIGEN.P_EVMGR_NAME, 0);
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         L_SQLERRM := 'Event manager could not be stopped : fatal error '||
                      TO_CHAR(L_RET_CODE);
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE; 
         RAISE STPERROR;         
      END IF;

   ELSIF L_RET_CODE = 1 THEN
      
      
      NULL;
   ELSIF L_RET_CODE <> 1 THEN
      
      
      L_SQLERRM := 'Major Error : Requesting lock U4EVMGRSTART_OR_STOP '||
      ' returned '||TO_CHAR(L_RET_CODE);
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE; 
      RAISE STPERROR;         
   END IF;
   
   UNAPIGEN.U4COMMIT;
   
   
   
   
   EXECUTE IMMEDIATE 'ALTER SESSION SET time_zone = ''' || L_SESSION_TIMEZONE || '''';

   IF L_LOCKED THEN
      L_RET_CODE := DBMS_LOCK.RELEASE(L_LOCKHANDLE);
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         L_SQLERRM :=  'Major error : Releasing lock '||L_LOCKNAME||':('||L_LOCKHANDLE||
                       ')returned '||TO_CHAR(L_RET_CODE);
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE; 
         RAISE STPERROR;         
      END IF;
      L_LOCKED := FALSE;
   END IF;
   RETURN(UNAPIGEN.DBERR_SUCCESS);
 
EXCEPTION
WHEN OTHERS THEN
   
   EXECUTE IMMEDIATE 'ALTER SESSION SET time_zone = ''' || L_SESSION_TIMEZONE || '''';
   IF SQLCODE <> 1 THEN
      L_SQLERRM := SQLERRM;
   END IF;
   UNAPIGEN.U4ROLLBACK;
   INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
   'StopAllMgrs', L_SQLERRM);
   UNAPIGEN.U4COMMIT;
   
   
   
   IF L_LOCKED THEN
      L_RET_CODE := DBMS_LOCK.RELEASE(L_LOCKHANDLE);
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
         VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                'StopAllMgrs', 'Major error : Releasing lock '||L_LOCKNAME||':('||L_LOCKHANDLE||
                ')returned '||TO_CHAR(L_RET_CODE));
         UNAPIGEN.U4COMMIT;         
      END IF;
      L_LOCKED := FALSE;
   END IF;
   IF UNAPIGEN.P_TXN_ERROR <> UNAPIGEN.DBERR_SUCCESS THEN
      RETURN(UNAPIGEN.P_TXN_ERROR);
   ELSE
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   END IF;   
END STOPALLMGRS;




FUNCTION CREATEDEFAULTSERVICELAYER                              
   RETURN NUMBER
IS
   L_INSTANCE_NAME         VARCHAR2 (64);
   L_SERVICE_NAME          VARCHAR2 (64);
   L_JOB_CLASS_NAME        VARCHAR2 (64);
   L_FIRST_SERVICE         VARCHAR2 (64);
   L_FIRST                 BOOLEAN;
   L_TIMEZONE              VARCHAR2(64);
   L_SCHEDULER_TIMEZONE    VARCHAR2(64);
   L_TZ_REGION             VARCHAR2(64);

   CURSOR L_INSTANCES_CURSOR
   IS
      SELECT   INSTANCE_NAME
          FROM SYS.GV_$INSTANCE
      ORDER BY INST_ID;

      CURSOR L_SERVICE_NAME_CURSOR (C_SID VARCHAR2)
      IS
        SELECT NAME FROM 
        DBA_SERVICES 
        WHERE UPPER(NETWORK_NAME) = UPPER(C_SID); 

BEGIN
   OPEN L_INSTANCES_CURSOR;

   L_FIRST := TRUE;
   DBMS_SCHEDULER.GET_SCHEDULER_ATTRIBUTE('default_timezone',L_SCHEDULER_TIMEZONE);
   SELECT DBTIMEZONE INTO L_TIMEZONE FROM DUAL;
   
   L_TZ_REGION := UNDATEFMT.GETORACLETZFROMOFFSET(L_TIMEZONE);
   IF L_TZ_REGION IS NOT NULL THEN 
      L_TIMEZONE := L_TZ_REGION;
   END IF;
   IF L_SCHEDULER_TIMEZONE<>L_TIMEZONE THEN
      DBMS_SCHEDULER.SET_SCHEDULER_ATTRIBUTE('default_timezone',L_TIMEZONE);
   END IF;
   LOOP
      FETCH L_INSTANCES_CURSOR
       INTO L_INSTANCE_NAME;

      EXIT WHEN L_INSTANCES_CURSOR%NOTFOUND;
     
         L_SERVICE_NAME :=  L_INSTANCE_NAME;
        OPEN L_SERVICE_NAME_CURSOR(L_INSTANCE_NAME);
                FETCH L_SERVICE_NAME_CURSOR
                INTO L_SERVICE_NAME;
        CLOSE L_SERVICE_NAME_CURSOR;
      
     


















      IF L_FIRST
      THEN
         L_FIRST_SERVICE := L_SERVICE_NAME;
         L_FIRST := FALSE;
      END IF;

      
      L_JOB_CLASS_NAME := 'UNI_JC_EVENTMGR_' ||UPPER(L_INSTANCE_NAME);

      BEGIN
         SELECT JOB_CLASS_NAME
           INTO L_JOB_CLASS_NAME
           FROM SYS.DBA_SCHEDULER_JOB_CLASSES
          WHERE JOB_CLASS_NAME = L_JOB_CLASS_NAME;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            DBMS_SCHEDULER.CREATE_JOB_CLASS
                                         (JOB_CLASS_NAME      => L_JOB_CLASS_NAME,
                                          SERVICE             => L_SERVICE_NAME
                                         );
      END;
   END LOOP;

   CLOSE L_INSTANCES_CURSOR;

   
   BEGIN
      SELECT JOB_CLASS_NAME
        INTO L_JOB_CLASS_NAME
        FROM SYS.DBA_SCHEDULER_JOB_CLASSES
       WHERE JOB_CLASS_NAME = 'UNI_JC_OTHER_JOBS';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         DBMS_SCHEDULER.CREATE_JOB_CLASS
                                      (JOB_CLASS_NAME      => 'UNI_JC_OTHER_JOBS',
                                       SERVICE             => L_FIRST_SERVICE
                                      );
   END;
   
   
   RETURN (UNAPIGEN.DBERR_SUCCESS);
   EXCEPTION
WHEN OTHERS THEN
      IF L_INSTANCES_CURSOR%ISOPEN THEN
         CLOSE L_INSTANCES_CURSOR;
      END IF;
      UNAPIGEN.LOGERROR('createdefaultservicelayer','General Failure: '||SQLERRM);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
END CREATEDEFAULTSERVICELAYER;

FUNCTION DROPDEFAULTSERVICELAYER                              
   RETURN NUMBER
IS
   L_SERVICE_NAME     VARCHAR2 (64);
   L_JOB_CLASS_NAME   VARCHAR2 (64);

   CURSOR L_SERVICE_CURSOR(A_NAME VARCHAR2)
   IS
      SELECT   NAME
          FROM SYS.DBA_SERVICES
          WHERE INSTR(UPPER(NAME), A_NAME)<>0;
   
   CURSOR L_JOBCLASS_CURSOR(A_NAME VARCHAR2)
   IS
      SELECT   JOB_CLASS_NAME
          FROM SYS.DBA_SCHEDULER_JOB_CLASSES
          WHERE INSTR(UPPER(JOB_CLASS_NAME), A_NAME)<>0;

BEGIN
  
  









      
  OPEN L_JOBCLASS_CURSOR( 'UNI_JC_');
   LOOP
      FETCH L_JOBCLASS_CURSOR
       INTO L_JOB_CLASS_NAME;
      EXIT WHEN L_JOBCLASS_CURSOR%NOTFOUND;
      DBMS_SCHEDULER.DROP_JOB_CLASS (L_JOB_CLASS_NAME);
   END LOOP;
   CLOSE L_JOBCLASS_CURSOR;

   UNAPIGEN.U4COMMIT;
   RETURN (UNAPIGEN.DBERR_SUCCESS);
   EXCEPTION
WHEN OTHERS THEN
     IF L_SERVICE_CURSOR%ISOPEN THEN
         CLOSE L_SERVICE_CURSOR;
      END IF;
      IF L_JOBCLASS_CURSOR%ISOPEN THEN
         CLOSE L_JOBCLASS_CURSOR;
      END IF;
      UNAPIGEN.LOGERROR('createdefaultservicelayer','General Failure: '||SQLERRM);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
END DROPDEFAULTSERVICELAYER;



FUNCTION COPYASSIGNFREQ                               
(A_OBJECT_TP                IN        VARCHAR2,       
 A_OBJECT_ID                IN        VARCHAR2,       
 A_OBJECT_OLD_VERSION       IN        VARCHAR2,       
 A_OBJECT_NEW_VERSION       IN        VARCHAR2)       
RETURN NUMBER IS

L_USED_OBJECT_TP             UNAPIGEN.VC4_TABLE_TYPE;
L_USED_OBJECT_ID             VARCHAR2(20);
L_USED_PP_KEY1               VARCHAR2(20);
L_USED_PP_KEY2               VARCHAR2(20);
L_USED_PP_KEY3               VARCHAR2(20);
L_USED_PP_KEY4               VARCHAR2(20);
L_USED_PP_KEY5               VARCHAR2(20);

L_NEW_CURSOR                 UNAPIGEN.CURSOR_REF_TYPE;
L_NEW_NR_OF_ROWS             NUMBER;
L_NEW_FETCHED_ROWS           NUMBER;
L_NEW_LAST_SCHED             TIMESTAMP WITH TIME ZONE;
L_NEW_LAST_CNT               NUMBER;
L_NEW_LAST_VAL               VARCHAR2(40);
L_NEW_FREQ_TP                CHAR(1);
L_NEW_FREQ_VAL               NUMBER;
L_NEW_FREQ_UNIT              VARCHAR2(20);
L_NEW_INVERT_FREQ            CHAR(1);

L_OLD_CURSOR                 UNAPIGEN.CURSOR_REF_TYPE;
L_OLD_NR_OF_ROWS             NUMBER;
L_OLD_FETCHED_ROWS           NUMBER;
L_OLD_LAST_SCHED             TIMESTAMP WITH TIME ZONE;
L_OLD_LAST_CNT               NUMBER;
L_OLD_LAST_VAL               VARCHAR2(40);
L_OLD_FREQ_TP                CHAR(1);
L_OLD_FREQ_VAL               NUMBER;
L_OLD_FREQ_UNIT              VARCHAR2(20);
L_OLD_INVERT_FREQ            CHAR(1);

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   FOR I IN 1..L_USED_OBJECT_TP.COUNT LOOP
      L_USED_OBJECT_TP(I) := '';
   END LOOP;
   
   
   IF A_OBJECT_TP = 'rt' THEN
      L_USED_OBJECT_TP(1) := 'st';
      L_USED_OBJECT_TP(2) := 'ip';
   ELSIF A_OBJECT_TP = 'st' THEN
      L_USED_OBJECT_TP(1) := 'ip';
   ELSIF A_OBJECT_TP = 'pr' THEN
      L_USED_OBJECT_TP(1) := 'mt';
   END IF;
   
   
   L_SQL_STRING := '';
   L_NEW_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
   L_OLD_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;

	IF A_OBJECT_TP IN ('st', 'rt') THEN
		
		L_SQL_STRING := 'SELECT last_sched, last_cnt, last_val,'||
							 ' freq_tp, freq_val, freq_unit, invert_freq'|| 
							 ' FROM ut'||A_OBJECT_TP||
							 ' WHERE '||A_OBJECT_TP||' = :a_object_id '||
							 ' AND version = :a_object_new_version ';

		EXECUTE IMMEDIATE L_SQL_STRING 
		INTO L_NEW_LAST_SCHED, L_NEW_LAST_CNT, L_NEW_LAST_VAL, 
			L_NEW_FREQ_TP, L_NEW_FREQ_VAL, L_NEW_FREQ_UNIT, L_NEW_INVERT_FREQ 
		USING A_OBJECT_ID, A_OBJECT_NEW_VERSION ; 

		IF (NVL(L_NEW_LAST_SCHED, TO_DATE('01/01/0001','DD/MM/YYYY')) = TO_DATE('01/01/0001','DD/MM/YYYY')) AND 
			(NVL(L_NEW_LAST_CNT,0)  = 0) AND 
			(NVL(L_NEW_LAST_VAL,' ') = ' ') THEN

			L_SQL_STRING := 'SELECT last_sched, last_cnt, last_val, freq_tp,'||
								 ' freq_val, freq_unit, invert_freq'|| 
								 ' FROM ut'||A_OBJECT_TP||
								 ' WHERE '||A_OBJECT_TP||' = :a_object_id '||
								 ' AND version = :a_object_old_version ';

			EXECUTE IMMEDIATE L_SQL_STRING 
			INTO L_OLD_LAST_SCHED, L_OLD_LAST_CNT, L_OLD_LAST_VAL,
				  L_OLD_FREQ_TP, L_OLD_FREQ_VAL, L_OLD_FREQ_UNIT,
				  L_OLD_INVERT_FREQ
			USING A_OBJECT_ID, A_OBJECT_OLD_VERSION;

			IF (NVL(L_OLD_FREQ_TP,' ')     = NVL(L_NEW_FREQ_TP,' '))     AND 
				(NVL(L_OLD_FREQ_VAL,0)      = NVL(L_NEW_FREQ_VAL,0))      AND 
				(NVL(L_OLD_FREQ_UNIT,' ')   = NVL(L_NEW_FREQ_UNIT,' '))   AND 
				(NVL(L_OLD_INVERT_FREQ,' ') = NVL(L_NEW_INVERT_FREQ,' ')) THEN

				L_SQL_STRING := 'UPDATE ut'||A_OBJECT_TP||
									 ' SET last_sched = :l_old_last_sched, '||
									 '     last_cnt = :l_old_last_cnt, '|| 
									 '     last_val = :l_old_last_val '|| 
									 'WHERE '||A_OBJECT_TP||' = :a_object_id'||
									 ' AND version = :a_object_new_version';
				EXECUTE IMMEDIATE L_SQL_STRING
				USING L_OLD_LAST_SCHED, L_OLD_LAST_CNT, L_OLD_LAST_VAL,
					A_OBJECT_ID, A_OBJECT_NEW_VERSION;
				IF SQL%ROWCOUNT = 0 THEN
					UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOTFOUND;
					RAISE STPERROR;
				END IF;
			END IF;
      END IF;
   END IF;

   
   FOR I IN 1..L_USED_OBJECT_TP.COUNT LOOP
      L_SQL_STRING := 'SELECT '||L_USED_OBJECT_TP(I)||', '|| 
                      ' last_sched, last_cnt, last_val,'||
                      ' freq_tp, freq_val, freq_unit, invert_freq'|| 
                      ' FROM ut'||A_OBJECT_TP||L_USED_OBJECT_TP(I)||
                      ' WHERE '||A_OBJECT_TP||' = :a_object_id '||
                      ' AND version = :a_object_new_version ';

      L_NEW_FETCHED_ROWS := 0;
      OPEN L_NEW_CURSOR 
      FOR L_SQL_STRING 
      USING A_OBJECT_ID, A_OBJECT_NEW_VERSION;
      LOOP
         FETCH L_NEW_CURSOR
         INTO L_USED_OBJECT_ID, L_NEW_LAST_SCHED, 
              L_NEW_LAST_CNT, L_NEW_LAST_VAL, L_NEW_FREQ_TP, L_NEW_FREQ_VAL,
              L_NEW_FREQ_UNIT, L_NEW_INVERT_FREQ;
         EXIT WHEN L_NEW_CURSOR%NOTFOUND;
         L_NEW_FETCHED_ROWS := L_NEW_FETCHED_ROWS + 1;
         EXIT WHEN L_NEW_FETCHED_ROWS >= L_NEW_NR_OF_ROWS;

         
         IF (NVL(L_NEW_LAST_SCHED, TO_DATE('01/01/0001','DD/MM/YYYY')) = TO_DATE('01/01/0001','DD/MM/YYYY')) AND 
            (NVL(L_NEW_LAST_CNT,0)  = 0) AND 
            (NVL(L_NEW_LAST_VAL,' ') = ' ') THEN
            
            
            L_SQL_STRING := 'SELECT last_sched, last_cnt, last_val, freq_tp,'||
                            ' freq_val, freq_unit, invert_freq'|| 
                            ' FROM ut'||A_OBJECT_TP||L_USED_OBJECT_TP(I)||
                            ' WHERE '||A_OBJECT_TP||' = :a_object_id '||
                            ' AND version = :a_object_old_version '||
                            ' AND '||L_USED_OBJECT_TP(I)||' = :l_used_object_id ';
                            
                            
                            

            L_OLD_FETCHED_ROWS := 0;
            OPEN L_OLD_CURSOR 
            FOR L_SQL_STRING
            USING A_OBJECT_ID, A_OBJECT_OLD_VERSION, L_USED_OBJECT_ID;

            LOOP
               FETCH L_OLD_CURSOR
               INTO L_OLD_LAST_SCHED, L_OLD_LAST_CNT, L_OLD_LAST_VAL,
                    L_OLD_FREQ_TP, L_OLD_FREQ_VAL, L_OLD_FREQ_UNIT,
                    L_OLD_INVERT_FREQ;
               EXIT WHEN L_OLD_CURSOR%NOTFOUND;
               L_OLD_FETCHED_ROWS := L_OLD_FETCHED_ROWS + 1;               
               EXIT WHEN L_OLD_FETCHED_ROWS >= L_OLD_NR_OF_ROWS;
            END LOOP;
            CLOSE L_OLD_CURSOR;

            
            
            IF (L_OLD_FETCHED_ROWS = 1) AND 
               (NVL(L_OLD_FREQ_TP,' ')     = NVL(L_NEW_FREQ_TP,' '))     AND 
               (NVL(L_OLD_FREQ_VAL,0)      = NVL(L_NEW_FREQ_VAL,0))      AND 
               (NVL(L_OLD_FREQ_UNIT,' ')   = NVL(L_NEW_FREQ_UNIT,' '))   AND 
               (NVL(L_OLD_INVERT_FREQ,' ') = NVL(L_NEW_INVERT_FREQ,' ')) THEN
               
               
               L_SQL_STRING := 'UPDATE ut'||A_OBJECT_TP||L_USED_OBJECT_TP(I)||
                               ' SET last_sched = :l_old_last_sched, '||
                               '     last_cnt = :l_old_last_cnt, '|| 
                               '     last_val = :l_old_last_val '|| 
                               'WHERE '||A_OBJECT_TP||' = :a_object_id'||
                               ' AND version = :a_object_new_version'||
                               ' AND '||L_USED_OBJECT_TP(I)||' = :l_used_object_id';
                               
                               
                               
               EXECUTE IMMEDIATE L_SQL_STRING
               USING L_OLD_LAST_SCHED, L_OLD_LAST_CNT, L_OLD_LAST_VAL,
                  A_OBJECT_ID, A_OBJECT_NEW_VERSION, L_USED_OBJECT_ID;
               IF SQL%ROWCOUNT = 0 THEN
                  UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOTFOUND;
                  CLOSE L_NEW_CURSOR;
                  RAISE STPERROR;
               END IF;
            END IF;
         END IF;
      END LOOP;
      CLOSE L_NEW_CURSOR;
   END LOOP;

   
   L_USED_OBJECT_TP.DELETE();
   FOR I IN 1..L_USED_OBJECT_TP.COUNT LOOP
      L_USED_OBJECT_TP(I) := '';
   END LOOP;
   
   
   IF A_OBJECT_TP = 'rt' THEN
      L_USED_OBJECT_TP(1) := 'pp';
   ELSIF A_OBJECT_TP = 'st' THEN
      L_USED_OBJECT_TP(1) := 'pp';
   END IF;
   
   L_SQL_STRING := '';
   L_NEW_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
   L_OLD_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;

   
   FOR I IN 1..L_USED_OBJECT_TP.COUNT LOOP
      L_SQL_STRING := 'SELECT '||L_USED_OBJECT_TP(I)||', '|| 
                      ' last_sched, last_cnt, last_val,'||
                      ' freq_tp, freq_val, freq_unit, invert_freq, pp_key1, '||
                      ' pp_key2, pp_key3, pp_key4, pp_key5'|| 
                      ' FROM ut'||A_OBJECT_TP||L_USED_OBJECT_TP(I)||
                      ' WHERE '||A_OBJECT_TP||' = :a_object_id '||
                      ' AND version = :a_object_new_version ';

      L_NEW_FETCHED_ROWS := 0;
      OPEN L_NEW_CURSOR 
      FOR L_SQL_STRING 
      USING A_OBJECT_ID, A_OBJECT_NEW_VERSION;
      LOOP
         FETCH L_NEW_CURSOR
         INTO L_USED_OBJECT_ID, L_NEW_LAST_SCHED, 
              L_NEW_LAST_CNT, L_NEW_LAST_VAL, L_NEW_FREQ_TP, L_NEW_FREQ_VAL,
              L_NEW_FREQ_UNIT, L_NEW_INVERT_FREQ,
              L_USED_PP_KEY1, L_USED_PP_KEY2, L_USED_PP_KEY3, L_USED_PP_KEY4, L_USED_PP_KEY5;
         EXIT WHEN L_NEW_CURSOR%NOTFOUND;
         L_NEW_FETCHED_ROWS := L_NEW_FETCHED_ROWS + 1;
         EXIT WHEN L_NEW_FETCHED_ROWS >= L_NEW_NR_OF_ROWS;

         
         IF (NVL(L_NEW_LAST_SCHED, TO_DATE('01/01/0001','DD/MM/YYYY')) = TO_DATE('01/01/0001','DD/MM/YYYY')) AND 
            (NVL(L_NEW_LAST_CNT,0)  = 0) AND 
            (NVL(L_NEW_LAST_VAL,' ') = ' ') THEN
            
            
            L_SQL_STRING := 'SELECT last_sched, last_cnt, last_val, freq_tp,'||
                            ' freq_val, freq_unit, invert_freq'|| 
                            ' FROM ut'||A_OBJECT_TP||L_USED_OBJECT_TP(I)||
                            ' WHERE '||A_OBJECT_TP||' = :a_object_id '||
                            ' AND version = :a_object_old_version '||
                            ' AND '||L_USED_OBJECT_TP(I)||' = :l_used_object_id '||
                            
                            
                            
                            ' AND pp_key1 = :l_used_pp_key1 '||
                            ' AND pp_key2 = :l_used_pp_key2 '||
                            ' AND pp_key3 = :l_used_pp_key3 '||
                            ' AND pp_key4 = :l_used_pp_key4 '||
                            ' AND pp_key5 = :l_used_pp_key5 ';

            L_OLD_FETCHED_ROWS := 0;
            OPEN L_OLD_CURSOR 
            FOR L_SQL_STRING
            USING A_OBJECT_ID, A_OBJECT_OLD_VERSION, L_USED_OBJECT_ID,
                  L_USED_PP_KEY1, L_USED_PP_KEY2, L_USED_PP_KEY3, L_USED_PP_KEY4, L_USED_PP_KEY5;

            LOOP
               FETCH L_OLD_CURSOR
               INTO L_OLD_LAST_SCHED, L_OLD_LAST_CNT, L_OLD_LAST_VAL,
                    L_OLD_FREQ_TP, L_OLD_FREQ_VAL, L_OLD_FREQ_UNIT,
                    L_OLD_INVERT_FREQ;
               EXIT WHEN L_OLD_CURSOR%NOTFOUND;
               L_OLD_FETCHED_ROWS := L_OLD_FETCHED_ROWS + 1;               
               EXIT WHEN L_OLD_FETCHED_ROWS >= L_OLD_NR_OF_ROWS;
            END LOOP;
            CLOSE L_OLD_CURSOR;

            
            
            IF (L_OLD_FETCHED_ROWS = 1) AND 
               (NVL(L_OLD_FREQ_TP,' ')     = NVL(L_NEW_FREQ_TP,' '))     AND 
               (NVL(L_OLD_FREQ_VAL,0)      = NVL(L_NEW_FREQ_VAL,0))      AND 
               (NVL(L_OLD_FREQ_UNIT,' ')   = NVL(L_NEW_FREQ_UNIT,' '))   AND 
               (NVL(L_OLD_INVERT_FREQ,' ') = NVL(L_NEW_INVERT_FREQ,' ')) THEN
               
               
               L_SQL_STRING := 'UPDATE ut'||A_OBJECT_TP||L_USED_OBJECT_TP(I)||
                               ' SET last_sched = :l_old_last_sched, '||
                               '     last_cnt = :l_old_last_cnt, '|| 
                               '     last_val = :l_old_last_val '|| 
                               'WHERE '||A_OBJECT_TP||' = :a_object_id'||
                               ' AND version = :a_object_new_version'||
                               ' AND '||L_USED_OBJECT_TP(I)||' = :l_used_object_id'||
                               
                               
                               
                               ' AND pp_key1 = :l_used_pp_key1 '||
                               ' AND pp_key2 = :l_used_pp_key2 '||
                               ' AND pp_key3 = :l_used_pp_key3 '||
                               ' AND pp_key4 = :l_used_pp_key4 '||
                               ' AND pp_key5 = :l_used_pp_key5 ';
               EXECUTE IMMEDIATE L_SQL_STRING
               USING L_OLD_LAST_SCHED, L_OLD_LAST_CNT, L_OLD_LAST_VAL,
                  A_OBJECT_ID, A_OBJECT_NEW_VERSION, L_USED_OBJECT_ID,
                  L_USED_PP_KEY1, L_USED_PP_KEY2, L_USED_PP_KEY3, L_USED_PP_KEY4, L_USED_PP_KEY5;
               IF SQL%ROWCOUNT = 0 THEN
                  UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOTFOUND;
                  CLOSE L_NEW_CURSOR;
                  RAISE STPERROR;
               END IF;
            END IF;
         END IF;
      END LOOP;
      CLOSE L_NEW_CURSOR;
   END LOOP;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('CopyAssignFreq', SQLERRM);
      UNAPIGEN.LOGERROR('CopyAssignFreq', L_SQL_STRING);
   END IF;
   IF L_NEW_CURSOR%ISOPEN THEN
      CLOSE L_NEW_CURSOR;
   END IF;
   IF L_OLD_CURSOR%ISOPEN THEN
      CLOSE L_OLD_CURSOR;
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'CopyAssignFreq'));
END COPYASSIGNFREQ;

FUNCTION COPYPPASSIGNFREQ                               
(A_PP                       IN        VARCHAR2,       
 A_PP_OLD_VERSION           IN        VARCHAR2,       
 A_PP_NEW_VERSION           IN        VARCHAR2,       
 A_PP_KEY1                  IN        VARCHAR2,       
 A_PP_KEY2                  IN        VARCHAR2,       
 A_PP_KEY3                  IN        VARCHAR2,       
 A_PP_KEY4                  IN        VARCHAR2,       
 A_PP_KEY5                  IN        VARCHAR2)       
RETURN NUMBER IS

L_USED_OBJECT_TP             UNAPIGEN.VC4_TABLE_TYPE;
L_USED_OBJECT_ID             VARCHAR2(20);

L_NEW_CURSOR                 UNAPIGEN.CURSOR_REF_TYPE;
L_NEW_NR_OF_ROWS             NUMBER;
L_NEW_FETCHED_ROWS           NUMBER;
L_NEW_LAST_SCHED             TIMESTAMP WITH TIME ZONE;
L_NEW_LAST_CNT               NUMBER;
L_NEW_LAST_VAL               VARCHAR2(40);
L_NEW_FREQ_TP                CHAR(1);
L_NEW_FREQ_VAL               NUMBER;
L_NEW_FREQ_UNIT              VARCHAR2(20);
L_NEW_INVERT_FREQ            CHAR(1);

L_OLD_CURSOR                 UNAPIGEN.CURSOR_REF_TYPE;
L_OLD_NR_OF_ROWS             NUMBER;
L_OLD_FETCHED_ROWS           NUMBER;
L_OLD_LAST_SCHED             TIMESTAMP WITH TIME ZONE;
L_OLD_LAST_CNT               NUMBER;
L_OLD_LAST_VAL               VARCHAR2(40);
L_OLD_FREQ_TP                CHAR(1);
L_OLD_FREQ_VAL               NUMBER;
L_OLD_FREQ_UNIT              VARCHAR2(20);
L_OLD_INVERT_FREQ            CHAR(1);

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   FOR I IN 1..L_USED_OBJECT_TP.COUNT LOOP
      L_USED_OBJECT_TP(I) := '';
   END LOOP;
   
   
   L_USED_OBJECT_TP(1) := 'pr';
   
   L_SQL_STRING := '';
   L_NEW_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
   L_OLD_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;

   
   FOR I IN 1..L_USED_OBJECT_TP.COUNT LOOP
      L_SQL_STRING := 'SELECT '||L_USED_OBJECT_TP(I)||','|| 
                      ' last_sched, last_cnt, last_val,'||
                      ' freq_tp, freq_val, freq_unit, invert_freq'|| 
                      ' FROM utpp'||L_USED_OBJECT_TP(I)||
                      ' WHERE pp = :a_pp' || 
                      ' AND version = :a_version '||
                      ' AND pp_key1 = :a_pp_key1 '||
                      ' AND pp_key2 = :a_pp_key2 '||
                      ' AND pp_key3 = :a_pp_key3 '||
                      ' AND pp_key4 = :a_pp_key4 '||
                      ' AND pp_key5 = :a_pp_key5 ';
                      
      L_NEW_FETCHED_ROWS := 0;
      OPEN L_NEW_CURSOR 
      FOR L_SQL_STRING 
      USING A_PP, A_PP_NEW_VERSION,A_PP_KEY1, A_PP_KEY2, A_PP_KEY3, A_PP_KEY4, A_PP_KEY5;
      LOOP
         FETCH L_NEW_CURSOR
         INTO L_USED_OBJECT_ID, L_NEW_LAST_SCHED, 
              L_NEW_LAST_CNT, L_NEW_LAST_VAL, L_NEW_FREQ_TP, L_NEW_FREQ_VAL,
              L_NEW_FREQ_UNIT, L_NEW_INVERT_FREQ;
         EXIT WHEN L_NEW_CURSOR%NOTFOUND;
         L_NEW_FETCHED_ROWS := L_NEW_FETCHED_ROWS + 1;
         EXIT WHEN L_NEW_FETCHED_ROWS >= L_NEW_NR_OF_ROWS;
         

         
         IF (NVL(L_NEW_LAST_SCHED, TO_DATE('01/01/0001','DD/MM/YYYY')) = TO_DATE('01/01/0001','DD/MM/YYYY')) AND 
            (NVL(L_NEW_LAST_CNT,0)  = 0) AND 
            (NVL(L_NEW_LAST_VAL,' ') = ' ') THEN
            
            
            L_SQL_STRING := 'SELECT last_sched, last_cnt, last_val, freq_tp,'||
                            ' freq_val, freq_unit, invert_freq'|| 
                            ' FROM utpp'||L_USED_OBJECT_TP(I)||
                            ' WHERE pp = :a_pp '||
                            ' AND version = :a_version '||
                            ' AND pp_key1 = :a_pp_key1 '||
                            ' AND pp_key2 = :a_pp_key2 '||
                            ' AND pp_key3 = :a_pp_key3 '||
                            ' AND pp_key4 = :a_pp_key4 '||
                            ' AND pp_key5 = :a_pp_key5 '||
                            ' AND '||L_USED_OBJECT_TP(I)||' = :a_pr';
                            
                            
                            

            L_OLD_FETCHED_ROWS := 0;
            OPEN L_OLD_CURSOR 
            FOR L_SQL_STRING
            USING A_PP, A_PP_OLD_VERSION, A_PP_KEY1, A_PP_KEY2, A_PP_KEY3,
                  A_PP_KEY4, A_PP_KEY5, L_USED_OBJECT_ID;
            LOOP
               FETCH L_OLD_CURSOR
               INTO L_OLD_LAST_SCHED, L_OLD_LAST_CNT, L_OLD_LAST_VAL,
                    L_OLD_FREQ_TP, L_OLD_FREQ_VAL, L_OLD_FREQ_UNIT,
                    L_OLD_INVERT_FREQ;
               EXIT WHEN L_OLD_CURSOR%NOTFOUND;
               L_OLD_FETCHED_ROWS := L_OLD_FETCHED_ROWS + 1;               
               EXIT WHEN L_OLD_FETCHED_ROWS >= L_OLD_NR_OF_ROWS;

            END LOOP;
            CLOSE L_OLD_CURSOR;

            
            
            IF (L_OLD_FETCHED_ROWS = 1) AND 
               (NVL(L_OLD_FREQ_TP,' ')     = NVL(L_NEW_FREQ_TP,' '))     AND 
               (NVL(L_OLD_FREQ_VAL,0)      = NVL(L_NEW_FREQ_VAL,0))      AND 
               (NVL(L_OLD_FREQ_UNIT,' ')   = NVL(L_NEW_FREQ_UNIT,' '))   AND 
               (NVL(L_OLD_INVERT_FREQ,' ') = NVL(L_NEW_INVERT_FREQ,' ')) THEN
               
               
               L_SQL_STRING := 'UPDATE utpp'||L_USED_OBJECT_TP(I)||
                               '   SET last_sched = :l_old_last_sched, '||
                               '       last_cnt = :l_old_last_cnt, '|| 
                               '       last_val = :l_old_last_val '||
                               'WHERE pp = :a_pp '||
                               ' AND version = :a_version '||
                               ' AND pp_key1 = :a_pp_key1 '||
                               ' AND pp_key2 = :a_pp_key2 '||
                               ' AND pp_key3 = :a_pp_key3 '||
                               ' AND pp_key4 = :a_pp_key4 '||
                               ' AND pp_key5 = :a_pp_key5 '||
                               ' AND '||L_USED_OBJECT_TP(I)||' = :a_pr';
                               
                               
                               

               EXECUTE IMMEDIATE L_SQL_STRING
               USING L_OLD_LAST_SCHED, L_OLD_LAST_CNT, L_OLD_LAST_VAL,
                  A_PP, A_PP_NEW_VERSION, A_PP_KEY1, A_PP_KEY2, A_PP_KEY3, A_PP_KEY4, A_PP_KEY5,
                 L_USED_OBJECT_ID;
               IF SQL%ROWCOUNT = 0 THEN
                  UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOTFOUND;
                  CLOSE L_NEW_CURSOR;
                  RAISE STPERROR;
               END IF;

            END IF;
         END IF;
      END LOOP;
      CLOSE L_NEW_CURSOR;
   END LOOP;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('CopyPpAssignFreq', SQLERRM);
   END IF;
   IF L_NEW_CURSOR%ISOPEN THEN
      CLOSE L_NEW_CURSOR;
   END IF;
   IF L_OLD_CURSOR%ISOPEN THEN
      CLOSE L_OLD_CURSOR;
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'CopyPpAssignFreq'));
END COPYPPASSIGNFREQ;




FUNCTION CLEANSTBASEDASSIGNFREQ                       
(A_OBJECT_ID                IN        VARCHAR2,       
 A_OBJECT_OLD_VERSION       IN        VARCHAR2)       
RETURN NUMBER IS

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;
   
   DELETE 
   FROM UTSTPRFREQ
   WHERE ST = A_OBJECT_ID
   AND VERSION = A_OBJECT_OLD_VERSION;
   
   DELETE 
   FROM UTSTMTFREQ
   WHERE ST = A_OBJECT_ID
   AND VERSION = A_OBJECT_OLD_VERSION;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('CleanStBasedAssignFreq', SQLERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'CleanStBasedAssignFreq'));
END CLEANSTBASEDASSIGNFREQ;

FUNCTION EVALUATEEVENTRULES                                
(A_RULES_LOADED             IN OUT    CHAR)                
RETURN NUMBER IS

L_CURRENT_TIMESTAMP                 TIMESTAMP WITH TIME ZONE;
L_EXECUTE_AT              TIMESTAMP WITH TIME ZONE;
L_LENGTH                  INTEGER;
L_COND_CURSOR             INTEGER;
L_CASCADE                 BOOLEAN;
L_EV_TP                   VARCHAR2(60);

L_EV_REC                  UTEV%ROWTYPE;
L_EV_SS_FROM              VARCHAR2(2);
L_EV_SS_TO                VARCHAR2(2);
L_EV_LC_SS_FROM           VARCHAR2(2);
L_EV_TR_NO                NUMBER(3);
L_EV_RQ                   VARCHAR2(20);
L_EV_SD                   VARCHAR2(20);

BEGIN
   L_CURRENT_TIMESTAMP := CURRENT_TIMESTAMP;

   
   IF A_RULES_LOADED = '0' THEN
      IF UNAPIEV.P_EV_OUTPUT_ON THEN
         UNTRACE.LOG('EvaluateEventRules: loading new rules for event manager '||UNAPIGEN.P_EVMGR_NAME||' in session '||L_EV_SESSION);
      END IF;

      L_EVR_NR_OF_ROWS := 0;
      FOR L_EVR_REC IN UNAPIEV.C_EVRULES LOOP
         L_EVR_NR_OF_ROWS                            := L_EVR_NR_OF_ROWS + 1;
         L_EVR_APPLIC(L_EVR_NR_OF_ROWS)              := L_EVR_REC.APPLIC;
         L_EVR_DBAPI_NAME(L_EVR_NR_OF_ROWS)          := L_EVR_REC.DBAPI_NAME;
         L_EVR_OBJECT_TP(L_EVR_NR_OF_ROWS)           := L_EVR_REC.OBJECT_TP;
         L_EVR_OBJECT_ID(L_EVR_NR_OF_ROWS)           := L_EVR_REC.OBJECT_ID;
         L_EVR_OBJECT_LC(L_EVR_NR_OF_ROWS)           := L_EVR_REC.OBJECT_LC;
         L_EVR_OBJECT_LC_VERSION(L_EVR_NR_OF_ROWS)   := L_EVR_REC.OBJECT_LC_VERSION;
         L_EVR_OBJECT_SS(L_EVR_NR_OF_ROWS)           := L_EVR_REC.OBJECT_SS;
         L_EVR_EV_TP(L_EVR_NR_OF_ROWS)               := L_EVR_REC.EV_TP;
         L_EVR_CONDITION(L_EVR_NR_OF_ROWS)           := L_EVR_REC.CONDITION;
         L_EVR_AF(L_EVR_NR_OF_ROWS)                  := L_EVR_REC.AF;
         L_EVR_AF_DELAY(L_EVR_NR_OF_ROWS)            := L_EVR_REC.AF_DELAY;
         L_EVR_AF_DELAY_UNIT(L_EVR_NR_OF_ROWS)       := L_EVR_REC.AF_DELAY_UNIT;
      END LOOP;  
      A_RULES_LOADED := '1';
   END IF;

   
   L_RESULT := UNAPIAUT.DISABLEALLOWMODIFYCHECK('1');
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
      INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
      VALUES(UNAPIEV.P_EV_REC.CLIENT_ID, UNAPIEV.P_EV_REC.APPLIC, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
             SUBSTR('Ev~'||TO_CHAR(UNAPIEV.P_EV_REC.EV_SEQ)||'~'|| 
             UNAPIEV.P_EV_REC.EV_TP,1,40), 'DisableAllowModifyCheck(1)#return=' || TO_CHAR(L_RESULT));
   END IF;

   
   IF UNAPIEV.P_EV_OUTPUT_ON THEN
      UNTRACE.LOG('EvaluateEventRules: scanning event rules');
   END IF;
   IF UNAPIEV.P_EVMGRS_COLLECTSTAT = '1' THEN
      L_RET_CODE := UNAPIEVSTAT.COLLECTSTAT4LCTRANSITIONS;
   END IF;   
   FOR L_ROW IN 1..L_EVR_NR_OF_ROWS LOOP
      
      
      
      
      
      
      
      L_CASCADE := FALSE;
      IF NVL(L_EVR_EV_TP(L_ROW), '*') LIKE '%StatusChanged' THEN
         FOR I IN 1..UNAPIEV.P_EV_TR.COUNT LOOP
            
            IF UNAPIEV.P_EV_TR(I).TP IN ('ws','rq','sc','pg','pa','me','rqic','ic') THEN
               L_EV_TP := INITCAP(UNAPIEV.P_EV_TR(I).TP)||'StatusChanged';
            ELSE
               L_EV_TP := 'ObjectStatusChanged';
            END IF;

            IF NVL(L_EVR_APPLIC(L_ROW)    ,        NVL(UNAPIEV.P_EV_REC.APPLIC,'*')      ) = NVL(UNAPIEV.P_EV_REC.APPLIC,'*')       AND
               NVL(L_EVR_DBAPI_NAME(L_ROW),        NVL(UNAPIEV.P_EV_REC.DBAPI_NAME,'*')  ) = NVL(UNAPIEV.P_EV_REC.DBAPI_NAME,'*')   AND
               NVL(L_EVR_OBJECT_TP(L_ROW),         NVL(UNAPIEV.P_EV_TR(I).TP,'*')        ) = NVL(UNAPIEV.P_EV_TR(I).TP,'*')         AND 
               NVL(L_EVR_OBJECT_ID(L_ROW),         NVL(UNAPIEV.P_EV_TR(I).ID,'*')        ) = NVL(UNAPIEV.P_EV_TR(I).ID,'*')         AND 
               NVL(L_EVR_OBJECT_LC(L_ROW),         NVL(UNAPIEV.P_EV_TR(I).LC,'*')        ) = NVL(UNAPIEV.P_EV_TR(I).LC,'*')         AND 
               NVL(L_EVR_OBJECT_LC_VERSION(L_ROW), NVL(UNAPIEV.P_EV_TR(I).LC_VERSION,'*')) = NVL(UNAPIEV.P_EV_TR(I).LC_VERSION,'*') AND 
               NVL(L_EVR_OBJECT_SS(L_ROW),         NVL(UNAPIEV.P_EV_TR(I).SS_TO,'*')     ) = NVL(UNAPIEV.P_EV_TR(I).SS_TO,'*')      AND
               NVL(L_EVR_EV_TP(L_ROW),             NVL(L_EV_TP,'*')                      ) = NVL(L_EV_TP,'*')                       THEN

               
               L_CASCADE := TRUE;

               
               L_EV_REC.OBJECT_TP         := UNAPIEV.P_EV_REC.OBJECT_TP;
               L_EV_REC.OBJECT_ID         := UNAPIEV.P_EV_REC.OBJECT_ID;
               L_EV_REC.OBJECT_LC         := UNAPIEV.P_EV_REC.OBJECT_LC;
               L_EV_REC.OBJECT_LC_VERSION := UNAPIEV.P_EV_REC.OBJECT_LC_VERSION;
               L_EV_REC.OBJECT_SS         := UNAPIEV.P_EV_REC.OBJECT_SS;
               L_EV_REC.EV_TP             := UNAPIEV.P_EV_REC.EV_TP;
               L_EV_REC.EV_DETAILS        := UNAPIEV.P_EV_REC.EV_DETAILS;
               L_EV_SS_FROM               := UNAPIEV.P_SS_FROM;
               L_EV_SS_TO                 := UNAPIEV.P_SS_TO;
               L_EV_LC_SS_FROM            := UNAPIEV.P_LC_SS_FROM;
               L_EV_TR_NO                 := UNAPIEV.P_TR_NO;
               L_EV_RQ                    := UNAPIEV.P_RQ;
               L_EV_SD                    := UNAPIEV.P_SD;

               
               UNAPIEV.P_EV_REC.OBJECT_TP         := UNAPIEV.P_EV_TR(I).TP;
               UNAPIEV.P_EV_REC.OBJECT_ID         := UNAPIEV.P_EV_TR(I).ID;
               UNAPIEV.P_EV_REC.OBJECT_LC         := UNAPIEV.P_EV_TR(I).LC;
               UNAPIEV.P_EV_REC.OBJECT_LC_VERSION := UNAPIEV.P_EV_TR(I).LC_VERSION;
               UNAPIEV.P_EV_REC.OBJECT_SS         := UNAPIEV.P_EV_TR(I).SS_TO;
               UNAPIEV.P_EV_REC.EV_TP             := L_EV_TP;
               
               
               
               
               
               
               
               
               UNAPIEV.P_EV_REC.EV_DETAILS := 'tr_no='||UNAPIEV.P_EV_TR(I).TR_NO||
                                              '#ss_from='||UNAPIEV.P_EV_TR(I).SS_FROM||
                                              '#lc_ss_from='||UNAPIEV.P_EV_TR(I).LC_SS_FROM;
               IF UNAPIEV.P_EV_REC.OBJECT_TP = 'ws' THEN
                  UNAPIEV.P_EV_REC.EV_DETAILS := UNAPIEV.P_EV_REC.EV_DETAILS||
                     '#'||UNAPIEV.P_EV_TR(I).EV_DETAILS;
               ELSIF UNAPIEV.P_EV_REC.OBJECT_TP = 'rq' THEN
                  UNAPIEV.P_EV_REC.EV_DETAILS := UNAPIEV.P_EV_REC.EV_DETAILS||
                     '#'||UNAPIEV.P_EV_TR(I).EV_DETAILS;
               ELSIF UNAPIEV.P_EV_REC.OBJECT_TP = 'sc' THEN
                  UNAPIEV.P_EV_REC.EV_DETAILS := UNAPIEV.P_EV_REC.EV_DETAILS||
                     '#'||UNAPIEV.P_EV_TR(I).EV_DETAILS;
               ELSIF UNAPIEV.P_EV_REC.OBJECT_TP = 'pg' THEN
                  UNAPIEV.P_EV_REC.EV_DETAILS := 'sc='||UNAPIEV.P_SC||
                     '#'||UNAPIEV.P_EV_REC.EV_DETAILS;
                  IF INSTR(UNAPIEV.P_EV_TR(I).EV_DETAILS, 'pgnode') = 0 THEN
                     UNAPIEV.P_EV_REC.EV_DETAILS := UNAPIEV.P_EV_REC.EV_DETAILS||
                        '#pgnode='||UNAPIEV.P_PGNODE||'#'||UNAPIEV.P_EV_TR(I).EV_DETAILS;
                  ELSE
                     UNAPIEV.P_EV_REC.EV_DETAILS := UNAPIEV.P_EV_REC.EV_DETAILS||
                        '#'||UNAPIEV.P_EV_TR(I).EV_DETAILS;
                  END IF;
               ELSIF UNAPIEV.P_EV_REC.OBJECT_TP = 'pa' THEN
                  UNAPIEV.P_EV_REC.EV_DETAILS := 'sc='||UNAPIEV.P_SC||
                     '#pg='||UNAPIEV.P_PG||'#pgnode='||UNAPIEV.P_PGNODE||
                     '#'||UNAPIEV.P_EV_REC.EV_DETAILS;
                  IF INSTR(UNAPIEV.P_EV_TR(I).EV_DETAILS, 'panode') = 0 THEN
                     UNAPIEV.P_EV_REC.EV_DETAILS := UNAPIEV.P_EV_REC.EV_DETAILS||
                        '#panode='||UNAPIEV.P_PANODE||'#'||UNAPIEV.P_EV_TR(I).EV_DETAILS;
                  ELSE
                     UNAPIEV.P_EV_REC.EV_DETAILS := UNAPIEV.P_EV_REC.EV_DETAILS||
                        '#'||UNAPIEV.P_EV_TR(I).EV_DETAILS;
                  END IF;
               ELSIF UNAPIEV.P_EV_REC.OBJECT_TP = 'me' THEN
                  UNAPIEV.P_EV_REC.EV_DETAILS := 'sc='||UNAPIEV.P_SC||
                     '#pg='||UNAPIEV.P_PG||'#pgnode='||UNAPIEV.P_PGNODE||
                     '#pa='||UNAPIEV.P_PA||'#panode='||UNAPIEV.P_PANODE||
                     '#'||UNAPIEV.P_EV_REC.EV_DETAILS;
                  IF INSTR(UNAPIEV.P_EV_TR(I).EV_DETAILS, 'menode') = 0 THEN
                     UNAPIEV.P_EV_REC.EV_DETAILS := UNAPIEV.P_EV_REC.EV_DETAILS||
                        '#menode='||UNAPIEV.P_MENODE||'#'||UNAPIEV.P_EV_TR(I).EV_DETAILS;
                  ELSE
                     UNAPIEV.P_EV_REC.EV_DETAILS := UNAPIEV.P_EV_REC.EV_DETAILS||
                        '#'||UNAPIEV.P_EV_TR(I).EV_DETAILS;
                  END IF;
               ELSIF UNAPIEV.P_EV_REC.OBJECT_TP = 'rqic' THEN
                  UNAPIEV.P_EV_REC.EV_DETAILS := 'rq='||UNAPIEV.P_RQ||
                     '#'||UNAPIEV.P_EV_REC.EV_DETAILS;
                  IF INSTR(UNAPIEV.P_EV_TR(I).EV_DETAILS, 'icnode') = 0 THEN
                     UNAPIEV.P_EV_REC.EV_DETAILS := UNAPIEV.P_EV_REC.EV_DETAILS||
                        '#icnode='||UNAPIEV.P_ICNODE||'#'||UNAPIEV.P_EV_TR(I).EV_DETAILS;
                  ELSE
                     UNAPIEV.P_EV_REC.EV_DETAILS := UNAPIEV.P_EV_REC.EV_DETAILS||
                        '#'||UNAPIEV.P_EV_TR(I).EV_DETAILS;
                  END IF;
               ELSIF UNAPIEV.P_EV_REC.OBJECT_TP = 'ic' THEN
                  UNAPIEV.P_EV_REC.EV_DETAILS := 'sc='||UNAPIEV.P_SC||
                     '#'||UNAPIEV.P_EV_REC.EV_DETAILS;
                  IF INSTR(UNAPIEV.P_EV_TR(I).EV_DETAILS, 'icnode') = 0 THEN
                     UNAPIEV.P_EV_REC.EV_DETAILS := UNAPIEV.P_EV_REC.EV_DETAILS||
                        '#icnode='||UNAPIEV.P_ICNODE||'#'||UNAPIEV.P_EV_TR(I).EV_DETAILS;
                  ELSE
                     UNAPIEV.P_EV_REC.EV_DETAILS := UNAPIEV.P_EV_REC.EV_DETAILS||
                        '#'||UNAPIEV.P_EV_TR(I).EV_DETAILS;
                  END IF;
               ELSIF UNAPIEV.P_EV_REC.EV_TP = 'ObjectStatusChanged' THEN
                  UNAPIEV.P_EV_REC.EV_DETAILS := UNAPIEV.P_EV_REC.EV_DETAILS||
                     '#'||UNAPIEV.P_EV_TR(I).EV_DETAILS;
               END IF;
               UNAPIEV.EVALUATEEVENTDETAILS(UNAPIEV.P_EV_REC.EV_SEQ);
               
               
               UNAPIEV.P_RQ := L_EV_RQ;
               UNAPIEV.P_SD := L_EV_SD;

               
               
               EXIT;
            END IF;
         END LOOP;
      END IF;
   
      
      IF NVL(L_EVR_APPLIC(L_ROW),           NVL(UNAPIEV.P_EV_REC.APPLIC,'*')           ) = NVL(UNAPIEV.P_EV_REC.APPLIC,'*')            AND 
         NVL(L_EVR_DBAPI_NAME(L_ROW),       NVL(UNAPIEV.P_EV_REC.DBAPI_NAME,'*')       ) = NVL(UNAPIEV.P_EV_REC.DBAPI_NAME,'*')        AND 
         NVL(L_EVR_OBJECT_TP(L_ROW),        NVL(UNAPIEV.P_EV_REC.OBJECT_TP,'*')        ) = NVL(UNAPIEV.P_EV_REC.OBJECT_TP,'*')         AND 
         NVL(L_EVR_OBJECT_ID(L_ROW),        NVL(UNAPIEV.P_EV_REC.OBJECT_ID,'*')        ) = NVL(UNAPIEV.P_EV_REC.OBJECT_ID,'*')         AND 
         NVL(L_EVR_OBJECT_LC(L_ROW),        NVL(UNAPIEV.P_EV_REC.OBJECT_LC,'*')        ) = NVL(UNAPIEV.P_EV_REC.OBJECT_LC,'*')         AND 
         NVL(L_EVR_OBJECT_LC_VERSION(L_ROW),NVL(UNAPIEV.P_EV_REC.OBJECT_LC_VERSION,'*')) = NVL(UNAPIEV.P_EV_REC.OBJECT_LC_VERSION,'*') AND 
         NVL(L_EVR_OBJECT_SS(L_ROW),        NVL(UNAPIEV.P_EV_REC.OBJECT_SS,'*')        ) = NVL(UNAPIEV.P_EV_REC.OBJECT_SS,'*')         AND 
         NVL(L_EVR_EV_TP(L_ROW),            NVL(UNAPIEV.P_EV_REC.EV_TP,'*')            ) = NVL(UNAPIEV.P_EV_REC.EV_TP,'*')             THEN
         
         IF UNAPIEV.P_EV_OUTPUT_ON THEN
            UNTRACE.LOG('EvaluateEventRules: rule nr '||L_ROW||' matches the current event');
         END IF;
         
         UNAPIEV.P_EVRULE_REC.APPLIC              := NVL(L_EVR_APPLIC(L_ROW)           , UNAPIEV.P_EV_REC.APPLIC           );
         UNAPIEV.P_EVRULE_REC.DBAPI_NAME          := NVL(L_EVR_DBAPI_NAME(L_ROW)       , UNAPIEV.P_EV_REC.DBAPI_NAME       );
         UNAPIEV.P_EVRULE_REC.OBJECT_TP           := NVL(L_EVR_OBJECT_TP(L_ROW)        , UNAPIEV.P_EV_REC.OBJECT_TP        );
         UNAPIEV.P_EVRULE_REC.OBJECT_ID           := NVL(L_EVR_OBJECT_ID(L_ROW)        , UNAPIEV.P_EV_REC.OBJECT_ID        );
         UNAPIEV.P_EVRULE_REC.OBJECT_LC           := NVL(L_EVR_OBJECT_LC(L_ROW)        , UNAPIEV.P_EV_REC.OBJECT_LC        );
         UNAPIEV.P_EVRULE_REC.OBJECT_LC_VERSION   := NVL(L_EVR_OBJECT_LC_VERSION(L_ROW), UNAPIEV.P_EV_REC.OBJECT_LC_VERSION);
         UNAPIEV.P_EVRULE_REC.OBJECT_SS           := NVL(L_EVR_OBJECT_SS(L_ROW)        , UNAPIEV.P_EV_REC.OBJECT_SS        );
         UNAPIEV.P_EVRULE_REC.EV_TP               := NVL(L_EVR_EV_TP(L_ROW)            , UNAPIEV.P_EV_REC.EV_TP            );
         UNAPIEV.P_EVRULE_REC.CONDITION           := L_EVR_CONDITION(L_ROW);
         UNAPIEV.P_EVRULE_REC.AF                  := L_EVR_AF(L_ROW);
         UNAPIEV.P_EVRULE_REC.AF_DELAY            := L_EVR_AF_DELAY(L_ROW);
         UNAPIEV.P_EVRULE_REC.AF_DELAY_UNIT       := L_EVR_AF_DELAY_UNIT(L_ROW);

         
         IF UNAPIEV.P_EVRULE_REC.CONDITION IS NULL THEN
            IF P_EV_OUTPUT_ON THEN
               UNTRACE.LOG('EvaluateEventRules: transition without condition');
            END IF;
            
            L_RET_CODE := UNAPIGEN.DBERR_SUCCESS;
         ELSE
            
            L_SQL_STRING := 'BEGIN :l_retcode := UNCONDITION.'|| UNAPIEV.P_EVRULE_REC.CONDITION ||
                            '; END;'; 

            IF P_EV_OUTPUT_ON THEN
               UNTRACE.LOG('EvaluateEventRules: condition: sql_string: '||L_SQL_STRING);
            END IF;

            BEGIN
               L_COND_CURSOR := DBMS_SQL.OPEN_CURSOR;
               DBMS_SQL.PARSE(L_COND_CURSOR, L_SQL_STRING, DBMS_SQL.V7);
               DBMS_SQL.BIND_VARIABLE(L_COND_CURSOR, ':l_retcode', L_RET_CODE);
               L_RESULT := DBMS_SQL.EXECUTE(L_COND_CURSOR);
               DBMS_SQL.VARIABLE_VALUE(L_COND_CURSOR, ':l_retcode', L_RET_CODE);
               DBMS_SQL.CLOSE_CURSOR(L_COND_CURSOR);
            EXCEPTION
            WHEN OTHERS THEN
               L_SQLERRM := SUBSTR(SQLERRM,1,255);
               INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
               VALUES(UNAPIEV.P_EV_REC.CLIENT_ID, UNAPIEV.P_EVRULE_REC.APPLIC, UNAPIGEN.P_USER, 
                      CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, SUBSTR('UNCONDITION.'||UNAPIEV.P_EVRULE_REC.CONDITION,1,40), 
                      L_SQLERRM);
               IF DBMS_SQL.IS_OPEN(L_COND_CURSOR) THEN
                  DBMS_SQL.CLOSE_CURSOR(L_COND_CURSOR);
               END IF;
            END;

            IF UNAPIEV.P_EV_OUTPUT_ON THEN
               UNTRACE.LOG('EvaluateEventRules: condition '||UNAPIEV.P_EVRULE_REC.CONDITION||
                           ' returned : '||TO_CHAR(L_RET_CODE)||' (0 when successful)');
            END IF;
         END IF;

         
         IF L_RET_CODE = UNAPIGEN.DBERR_SUCCESS THEN
            IF NVL(UNAPIEV.P_EVRULE_REC.AF_DELAY,-1) > 0 THEN
            
               IF UNAPIEV.P_EV_OUTPUT_ON THEN
                  UNTRACE.LOG('EvaluateEventRules: action has to be executed later (delay)');
               END IF;

               
               L_RESULT := UNAPIAUT.CALCULATEDELAY(UNAPIEV.P_EVRULE_REC.AF_DELAY,
                                                   UNAPIEV.P_EVRULE_REC.AF_DELAY_UNIT,
                                                   L_CURRENT_TIMESTAMP,
                                                   L_EXECUTE_AT);
               IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
                  INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
                  VALUES(UNAPIEV.P_EV_REC.CLIENT_ID, UNAPIEV.P_EVRULE_REC.APPLIC, UNAPIGEN.P_USER, 
                         CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, SUBSTR('Ev~'||TO_CHAR(UNAPIEV.P_EV_REC.EV_SEQ)||'~'||
                         UNAPIEV.P_EVRULE_REC.EV_TP,1,40), 
                         'CalculateDelay#return='||TO_CHAR(L_RESULT));
               END IF;

               
               INSERT INTO UTEVRULESDELAYED
                     (TR_SEQ, EV_SEQ, CLIENT_ID, APPLIC, DBAPI_NAME, EVMGR_NAME, OBJECT_TP, 
                      OBJECT_ID, OBJECT_LC, OBJECT_LC_VERSION, OBJECT_SS, EV_TP, USERNAME, 
                      EV_DETAILS, CONDITION, AF, AF_DELAY, AF_DELAY_UNIT, CREATED_ON, CREATED_ON_TZ, EXECUTE_AT, EXECUTE_AT_TZ)
               VALUES(UNAPIGEN.P_TR_SEQ, UNAPIEV.P_EV_REC.EV_SEQ, UNAPIEV.P_EV_REC.CLIENT_ID, 
                      UNAPIEV.P_EVRULE_REC.APPLIC, UNAPIEV.P_EVRULE_REC.DBAPI_NAME, 
                      UNAPIEV.P_EV_REC.EVMGR_NAME, UNAPIEV.P_EVRULE_REC.OBJECT_TP, 
                      UNAPIEV.P_EVRULE_REC.OBJECT_ID, UNAPIEV.P_EVRULE_REC.OBJECT_LC, 
                      UNAPIEV.P_EVRULE_REC.OBJECT_LC_VERSION, UNAPIEV.P_EVRULE_REC.OBJECT_SS, 
                      UNAPIEV.P_EVRULE_REC.EV_TP, UNAPIEV.P_EV_REC.USERNAME, 
                      UNAPIEV.P_EV_REC.EV_DETAILS, UNAPIEV.P_EVRULE_REC.CONDITION, 
                      UNAPIEV.P_EVRULE_REC.AF, UNAPIEV.P_EVRULE_REC.AF_DELAY, 
                      UNAPIEV.P_EVRULE_REC.AF_DELAY_UNIT, L_CURRENT_TIMESTAMP, L_CURRENT_TIMESTAMP, L_EXECUTE_AT, L_EXECUTE_AT);
            ELSE 
            
               IF UNAPIEV.P_EV_OUTPUT_ON THEN
                  UNTRACE.LOG('EvaluateEventRules: action has to be executed now');
               END IF;
               IF UNAPIEV.P_EVMGRS_COLLECTSTAT = '1' THEN
                  L_RET_CODE := UNAPIEVSTAT.COLLECTSTAT4EVRULEEXECUTION;
               END IF;

               
               L_RESULT := UNAPIEV.EXECUTEACTION(UNAPIEV.P_EVRULE_REC.AF);
               IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
                  INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
                  VALUES(UNAPIEV.P_EV_REC.CLIENT_ID, UNAPIEV.P_EVRULE_REC.APPLIC, UNAPIGEN.P_USER, 
                         CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, SUBSTR('Ev~'||TO_CHAR(UNAPIEV.P_EV_REC.EV_SEQ)||'~'|| 
                         UNAPIEV.P_EVRULE_REC.EV_TP,1,40), 
                         'ExecuteAction('||UNAPIEV.P_EVRULE_REC.AF||')#return='||TO_CHAR(L_RESULT));
               END IF;

               
               IF UNAPIGEN.P_LOG_LC_ACTIONS OR L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
                  BEGIN
                     INSERT INTO UTEVLOG
                            (TR_SEQ, EV_SEQ, EV_SESSION, CREATED_ON, CREATED_ON_TZ, CLIENT_ID, APPLIC,
                             DBAPI_NAME, EVMGR_NAME, OBJECT_TP, OBJECT_ID,
                             OBJECT_LC, OBJECT_LC_VERSION, OBJECT_SS, EV_TP, EV_DETAILS, 
                             EXECUTED_ON, EXECUTED_ON_TZ, ERRORCODE, WHAT, INSTANCE_NUMBER)
                     VALUES(UNAPIGEN.P_TR_SEQ, UNAPIEV.P_EV_REC.EV_SEQ, L_EV_SESSION, 
                            UNAPIEV.P_EV_REC.CREATED_ON, UNAPIEV.P_EV_REC.CREATED_ON, UNAPIEV.P_EV_REC.CLIENT_ID, 
                            UNAPIEV.P_EVRULE_REC.APPLIC, UNAPIEV.P_EVRULE_REC.DBAPI_NAME, 
                            UNAPIEV.P_EV_REC.EVMGR_NAME, UNAPIEV.P_EVRULE_REC.OBJECT_TP, 
                            UNAPIEV.P_EVRULE_REC.OBJECT_ID, UNAPIEV.P_EVRULE_REC.OBJECT_LC, 
                            UNAPIEV.P_EVRULE_REC.OBJECT_LC_VERSION, 
                            UNAPIEV.P_EVRULE_REC.OBJECT_SS, UNAPIEV.P_EVRULE_REC.EV_TP, 
                            UNAPIEV.P_EV_REC.EV_DETAILS, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, L_RESULT, 
                            UNAPIEV.P_EVRULE_REC.AF, UNAPIGEN.P_INSTANCENR);
                  EXCEPTION
                  WHEN OTHERS THEN
                     L_SQLERRM := SQLERRM;
                     INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
                     VALUES(UNAPIEV.P_EV_REC.CLIENT_ID, UNAPIEV.P_EVRULE_REC.APPLIC, UNAPIGEN.P_USER, 
                            CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'EvaluateEventRules', L_SQLERRM);
                  END;
               END IF;
            END IF;
         END IF;
      END IF;
      
      IF L_CASCADE THEN
         
         UNAPIEV.P_EV_REC.OBJECT_TP         := L_EV_REC.OBJECT_TP;
         UNAPIEV.P_EV_REC.OBJECT_ID         := L_EV_REC.OBJECT_ID;
         UNAPIEV.P_EV_REC.OBJECT_LC         := L_EV_REC.OBJECT_LC;
         UNAPIEV.P_EV_REC.OBJECT_LC_VERSION := L_EV_REC.OBJECT_LC_VERSION;
         UNAPIEV.P_EV_REC.OBJECT_SS         := L_EV_REC.OBJECT_SS;
         UNAPIEV.P_EV_REC.EV_TP             := L_EV_REC.EV_TP;
         UNAPIEV.P_EV_REC.EV_DETAILS        := L_EV_REC.EV_DETAILS;
         UNAPIEV.EVALUATEEVENTDETAILS(UNAPIEV.P_EV_REC.EV_SEQ);
         UNAPIEV.P_SS_FROM                  := L_EV_SS_FROM;
         UNAPIEV.P_SS_TO                    := L_EV_SS_TO;
         UNAPIEV.P_LC_SS_FROM               := L_EV_LC_SS_FROM;
         UNAPIEV.P_TR_NO                    := L_EV_TR_NO;
         UNAPIEV.P_RQ                       := L_EV_RQ;
         UNAPIEV.P_SD                       := L_EV_SD;
      END IF;
      
      SAVEPOINT_UNILAB4;
   END LOOP;
   
   
   L_RESULT := UNAPIAUT.DISABLEALLOWMODIFYCHECK('0');
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
      INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
      VALUES(UNAPIEV.P_EV_REC.CLIENT_ID, UNAPIEV.P_EV_REC.APPLIC, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
             SUBSTR('Ev~'||TO_CHAR(UNAPIEV.P_EV_REC.EV_SEQ)||'~'|| 
             UNAPIEV.P_EV_REC.EV_TP,1,40), 'DisableAllowModifyCheck(0)#return=' || TO_CHAR(L_RESULT));
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   
   IF L_CASCADE THEN
      UNAPIEV.P_EV_REC.OBJECT_TP         := L_EV_REC.OBJECT_TP;
      UNAPIEV.P_EV_REC.OBJECT_ID         := L_EV_REC.OBJECT_ID;
      UNAPIEV.P_EV_REC.OBJECT_LC         := L_EV_REC.OBJECT_LC;
      UNAPIEV.P_EV_REC.OBJECT_LC_VERSION := L_EV_REC.OBJECT_LC_VERSION;
      UNAPIEV.P_EV_REC.OBJECT_SS         := L_EV_REC.OBJECT_SS;
      UNAPIEV.P_EV_REC.EV_TP             := L_EV_REC.EV_TP;
      UNAPIEV.P_EV_REC.EV_DETAILS        := L_EV_REC.EV_DETAILS;
      UNAPIEV.EVALUATEEVENTDETAILS(UNAPIEV.P_EV_REC.EV_SEQ);
      UNAPIEV.P_SS_FROM                  := L_EV_SS_FROM;
      UNAPIEV.P_SS_TO                    := L_EV_SS_TO;
      UNAPIEV.P_LC_SS_FROM               := L_EV_LC_SS_FROM;
      UNAPIEV.P_TR_NO                    := L_EV_TR_NO;
      UNAPIEV.P_RQ                       := L_EV_RQ;
      UNAPIEV.P_SD                       := L_EV_SD;
   END IF;

   IF SQLCODE = -60 THEN
      
      UNAPIGEN.P_DEADLOCK_RAISED := TRUE;
      
      IF UNAPIGEN.P_DEADLOCK_COUNT < UNAPIGEN.P_MAX_DEADLOCK_COUNT THEN
         RAISE;
      END IF;
   END IF;               
   L_SQLERRM := SUBSTR(SQLERRM,1,255);
   INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
   VALUES(UNAPIEV.P_EV_REC.CLIENT_ID, UNAPIEV.P_EV_REC.APPLIC, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
          'EvaluateEventRules', L_SQLERRM);
   IF DBMS_SQL.IS_OPEN(L_COND_CURSOR) THEN
      DBMS_SQL.CLOSE_CURSOR(L_COND_CURSOR);
   END IF;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END EVALUATEEVENTRULES;

FUNCTION MOVEEVENTSFROMINACTIVEQUEUE
(A_INACTIVATED_INSTANCE_NR     IN        NUMBER,         
 A_HANDLING_INSTANCE_NR        IN        NUMBER)         
RETURN NUMBER IS
BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;
   
   EXECUTE IMMEDIATE
   'INSERT INTO utev'||A_HANDLING_INSTANCE_NR||' '||
   ' (tr_seq, ev_seq, created_on, created_on_tz, client_id, applic, dbapi_name,'||
   'evmgr_name, object_tp, object_id, object_lc, object_lc_version, object_ss,'||
   'ev_tp, username, ev_details) '||
   'SELECT tr_seq, ev_seq, created_on, created_on_tz, client_id, applic, dbapi_name,'||
   'evmgr_name, object_tp, object_id, object_lc, object_lc_version, object_ss,'||
   'ev_tp, username, ev_details FROM utev'||A_INACTIVATED_INSTANCE_NR;

   EXECUTE IMMEDIATE
   'DELETE FROM utev'||A_INACTIVATED_INSTANCE_NR;
   
   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;
   RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('MoveEventsFromInactiveQueue', SQLERRM);
   ELSIF L_SQLERRM IS NOT NULL THEN
      UNAPIGEN.LOGERROR('MoveEventsFromInactiveQueue', L_SQLERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'MoveEventsFromInactiveQueue'));
END MOVEEVENTSFROMINACTIVEQUEUE;

FUNCTION HANDLEEVENTSFROMINACTIVEQUEUE
(A_EVMGR_NAME                  IN        VARCHAR2,       
 A_INACTIVE_INSTANCE_NAME      IN        VARCHAR2,       
 A_TARGET_INSTANCE_NAME        IN        VARCHAR2)       
RETURN NUMBER IS
BEGIN
   
   
   
   RETURN(UNAPIGEN.DBERR_SUCCESS);
END HANDLEEVENTSFROMINACTIVEQUEUE;

FUNCTION HANDLEEVENTSFROMINACTIVEQUEUE
(A_EVMGR_NAME                  IN        VARCHAR2,       
 A_INACTIVATED_INSTANCE_NR     IN        NUMBER,         
 A_HANDLING_INSTANCE_NR        IN        NUMBER)         
RETURN NUMBER IS
L_IS_EVENTMGR_RUNNING      INTEGER;
L_HANDLING_INSTANCE_NR     INTEGER;
L_EVMGR_NAME               VARCHAR2(40);
L_ENTER_LOOP               BOOLEAN;

CURSOR L_FIRSTAVAILABLE_INSTANCE IS
SELECT RUNNING_INSTANCE INSTANCE_NUMBER 
FROM SYS.DBA_SCHEDULER_RUNNING_JOBS;

BEGIN
   L_ENTER_LOOP:=FALSE;
   
   
   
   
   
   L_EVMGR_NAME := NVL(A_EVMGR_NAME, 'U4EVMGR');
   
   
   
   
   
   
   
   
   
   
   
   
   FOR L_REC IN 
      (SELECT INSTANCE_NUMBER 
       FROM GV$INSTANCE 
       WHERE INSTANCE_NUMBER=NVL(A_INACTIVATED_INSTANCE_NR,INSTANCE_NUMBER)
      )  
   LOOP 
      L_ENTER_LOOP:=TRUE;
      
      L_IS_EVENTMGR_RUNNING := UNAPIEV.STARTEVENTMGR(L_EVMGR_NAME, -10, L_REC.INSTANCE_NUMBER);
      IF L_IS_EVENTMGR_RUNNING = UNAPIGEN.DBERR_SUCCESS THEN
         
         IF A_INACTIVATED_INSTANCE_NR IS NOT NULL THEN
            L_SQLERRM := 'The event manager job is actually running on specific inactivated instance: '||A_INACTIVATED_INSTANCE_NR;
            UNAPIGEN.LOGERROR('HandleEventsFromInactiveQueue', L_SQLERRM);
            UNAPIGEN.U4COMMIT;
            RETURN(UNAPIGEN.DBERR_GENFAIL);
         ELSE
            
            NULL;
         END IF;
      ELSE
         
         L_HANDLING_INSTANCE_NR := NULL;
         IF A_HANDLING_INSTANCE_NR IS NOT NULL THEN
            L_IS_EVENTMGR_RUNNING := UNAPIEV.STARTEVENTMGR(L_EVMGR_NAME, -10, A_HANDLING_INSTANCE_NR);
            IF L_IS_EVENTMGR_RUNNING <> UNAPIGEN.DBERR_SUCCESS THEN
               
               IF A_HANDLING_INSTANCE_NR IS NOT NULL THEN
                  L_SQLERRM := 'The event manager job is not running on handling instance: '||A_HANDLING_INSTANCE_NR;
                  UNAPIGEN.LOGERROR('HandleEventsFromInactiveQueue', L_SQLERRM);
                  UNAPIGEN.U4COMMIT;
                  RETURN(UNAPIGEN.DBERR_GENFAIL);
               END IF;
            ELSE
               L_HANDLING_INSTANCE_NR := A_HANDLING_INSTANCE_NR;
            END IF;
         ELSE
            
            OPEN L_FIRSTAVAILABLE_INSTANCE;
            FETCH L_FIRSTAVAILABLE_INSTANCE
            INTO L_HANDLING_INSTANCE_NR;
            CLOSE L_FIRSTAVAILABLE_INSTANCE;
         END IF;
         
         
         
         IF L_HANDLING_INSTANCE_NR IS NULL THEN
            
            L_SQLERRM := 'No handling instance found with a running event manager!';
            UNAPIGEN.LOGERROR('HandleEventsFromInactiveQueue', L_SQLERRM);
            UNAPIGEN.U4COMMIT;
            RETURN(UNAPIGEN.DBERR_GENFAIL);
         END IF;
         
         L_RET_CODE := MOVEEVENTSFROMINACTIVEQUEUE(L_REC.INSTANCE_NUMBER, L_HANDLING_INSTANCE_NR);
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            L_SQLERRM := 'Error returned by MoveEventsFromInactiveQueue: ret_code='||L_RET_CODE||
                         '#inactivated instance='||L_REC.INSTANCE_NUMBER||'#handling instance='||L_HANDLING_INSTANCE_NR;
            UNAPIGEN.LOGERROR('HandleEventsFromInactiveQueue', L_SQLERRM);
            UNAPIGEN.U4COMMIT;
            RETURN(UNAPIGEN.DBERR_GENFAIL);
         END IF;
      END IF;
   END LOOP;   
   
   IF L_ENTER_LOOP=FALSE THEN
      L_SQLERRM := 'inactivated instance:'||A_INACTIVATED_INSTANCE_NR||' is not gv$instance';
      UNAPIGEN.LOGERROR('HandleEventsFromInactiveQueue', L_SQLERRM);
      UNAPIGEN.U4COMMIT;
      RETURN(UNAPIGEN.DBERR_GENFAIL);   
   END IF;
   RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
WHEN OTHERS THEN
   L_SQLERRM := SQLERRM;
   UNAPIGEN.LOGERROR('HandleEventsFromInactiveQueue', L_SQLERRM);
   UNAPIGEN.U4COMMIT;
END HANDLEEVENTSFROMINACTIVEQUEUE;

FUNCTION SQLTRANSLATEDJOBINTERVAL
(A_AMOUNT                      IN        VARCHAR2,
 A_TIME_UNIT                   IN        VARCHAR2)
RETURN VARCHAR2 IS
L_AMOUNT          NUMBER;
BEGIN
   EXECUTE IMMEDIATE 'DECLARE l_amount NUMBER; BEGIN :l_amount := '||A_AMOUNT||'; END;' USING OUT L_AMOUNT;
   RETURN(UNAPIEV.SQLTRANSLATEDJOBINTERVAL(L_AMOUNT, A_TIME_UNIT));
END SQLTRANSLATEDJOBINTERVAL;


FUNCTION SQLTRANSLATEDJOBINTERVAL
(A_AMOUNT                      IN        NUMBER,
 A_TIME_UNIT                   IN        VARCHAR2)
RETURN VARCHAR2 IS

L_AMOUNT       PLS_INTEGER;
L_TIME_UNIT    VARCHAR2(30);

BEGIN
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   

   IF A_AMOUNT <> ROUND(A_AMOUNT) OR 
      NVL(A_AMOUNT,0) <= 0 THEN
      RAISE_APPLICATION_ERROR(-20000, 'Invalid amount passed:'||A_AMOUNT||'(Supported:positive integer)');   
   END IF;
   
   L_AMOUNT := A_AMOUNT;
   L_TIME_UNIT := A_TIME_UNIT;
   IF L_TIME_UNIT = 'seconds' THEN
      IF L_AMOUNT <= 999 THEN
         RETURN('FREQ = SECONDLY; INTERVAL = ' || L_AMOUNT);
      ELSE 
         L_TIME_UNIT := 'minutes';
         L_AMOUNT := ROUND(L_AMOUNT/60);
      END IF;
   END IF;
   IF L_TIME_UNIT = 'minutes' THEN
      IF L_AMOUNT <= 999 THEN
         RETURN('FREQ = MINUTELY; INTERVAL = ' || L_AMOUNT);
      ELSE 
         L_TIME_UNIT := 'hours';
         L_AMOUNT := ROUND(L_AMOUNT/60);
      END IF;
   END IF;
   IF L_TIME_UNIT = 'hours' THEN
      IF L_AMOUNT <= 999 THEN
         RETURN('FREQ = HOURLY; INTERVAL = ' || L_AMOUNT);
      ELSE 
         L_TIME_UNIT := 'days';
         L_AMOUNT := ROUND(L_AMOUNT/24);
      END IF;
   END IF;
   IF L_TIME_UNIT = 'days' THEN
      IF L_AMOUNT <= 999 THEN
         RETURN('FREQ = DAILY; INTERVAL = ' || L_AMOUNT);
      ELSE 
        
         RAISE_APPLICATION_ERROR(-20000, 'Outside boundaries of function 999 days');
      END IF;
   END IF;
   RAISE_APPLICATION_ERROR(-20000, 'Invalid unit passed:'||L_TIME_UNIT||'(Supported ones:seconds,minutes,hours,days)');
END SQLTRANSLATEDJOBINTERVAL;


BEGIN
   P_EV_OUTPUT_ON := FALSE;
   L_EVR_NR_OF_ROWS :=0;
END UNAPIEV;
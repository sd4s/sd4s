--DBMS-ALERT wordt gebruikt voor aansturing van de EVENT-MANAGERS
--In de oracle-sql-trace kom ik volgende statements tegen:

/* Formatted on 11/03/2021 16:08:38 (QP5 v5.362) */
SELECT MESSAGE
  FROM DBMS_ALERT_INFO
 WHERE NAME = UPPER ( :B2) AND SID = :B1

/* Formatted on 11/03/2021 16:07:14 (QP5 v5.362) */
UPDATE DBMS_ALERT_INFO
   SET CHANGED = 'N'
 WHERE NAME = UPPER ( :B2) AND SID = :B1 AND CHANGED = 'Y'
 
 
descr sys.DBMS_ALERT_INFO
/*
Name    Null     Type           
------- -------- -------------- 
NAME    NOT NULL VARCHAR2(30)   
SID     NOT NULL VARCHAR2(30)   
CHANGED          VARCHAR2(1)    
MESSAGE          VARCHAR2(1800) 
*/

select * from sys.dbms_alert_info

/*
NAME			SID			CHANGED	MESSAGE
U4EVMGR			004200010001	Y	766098
DEDICEVMGR		003600030001	N	
U4EVMGR			019400050001	Y	766098
U4EVMGR			000E00030001	N	766098
STUDY_EVENT_MGR	002900010001	N	
U4EVMGR			000100010001	N	766098
DEDICEVMGR		018700030001	Y	STOP
U4EVMGR			001C00010001	N	766098
*/


DESCR UNILAB.UTCLIENTALERTS
/*
Name       Null     Type                
---------- -------- ------------------- 
ALERT_SEQ  NOT NULL NUMBER              
ALERT_NAME          VARCHAR2(20 CHAR)   
ALERT_DATA          VARCHAR2(2000 CHAR) 
*/


--vanuit DB-PACKAGES wordt DBMS-ALERT gezet

P_WAITFORALERTTIMEOUT      INTEGER DEFAULT 120; --timeout of event manager for DBMS_ALERT.WAITONE
                                                --default 120 seconds
                                                --can be set to a lower value but pay attention to the workload on system

FUNCTION AlertRegister
(a_alert_name          IN       VARCHAR2)                  /* VC20_TYPE */
RETURN NUMBER;

FUNCTION AlertRemove
(a_alert_name          IN       VARCHAR2)                  /* VC20_TYPE */
RETURN NUMBER;

FUNCTION AlertDelete
(a_alert_name          IN       VARCHAR2,                  /* VC20_TYPE */
 a_alert_data          IN       VARCHAR2)                  /* VC2000_TYPE */
RETURN NUMBER;

FUNCTION AlertSend
(a_alert_name          IN       VARCHAR2,                  /* VC20_TYPE */
 a_alert_data          IN       VARCHAR2)                  /* VC2000_TYPE */
RETURN NUMBER;

FUNCTION AlertWaitAny
(a_alert_name          OUT      VARCHAR2,                  /* VC20_TYPE */
 a_alert_data          OUT      VARCHAR2,                  /* VC2000_TYPE */
 a_alert_status        OUT      NUMBER,                    /* NUM_TYPE */
 a_alert_wait_time     IN       NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;


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
   --
   OPEN L_SEQ_ALERT_CURSOR;
   FETCH L_SEQ_ALERT_CURSOR INTO L_SEQ_ALERT_NR;
   CLOSE L_SEQ_ALERT_CURSOR;
   --
   INSERT INTO UTCLIENTALERTS    (ALERT_SEQ, ALERT_NAME, ALERT_DATA)
   VALUES   (L_SEQ_ALERT_NR, A_ALERT_NAME, A_ALERT_DATA);
   --
   UNAPIGEN.U4COMMIT;
   RETURN(UNAPIGEN.DBERR_SUCCESS);
   --
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



SELECT SEQ_ALERT_NR.NEXTVAL FROM DUAL;
DBMS_ALERT.REGISTER(A_EVMGR_NAME);
DBMS_ALERT.SIGNAL( 'STUDY_EVENT_MGR' , 'STOP' );
--
DBMS_APPLICATION_INFO.SET_ACTION ('Waiting for alert');
DBMS_ALERT.WAITONE(A_EVMGR_NAME, L_ALERT_MESSAGE, L_STATUS, P_WAITFORALERTTIMEOUT);
			


--er is blijkbaar ook een CLIENT-
-------------------------------------------------
-- insert record for Client Event Manager (CEM))
-------------------------------------------------
INSERT INTO utclientalerts (alert_seq, alert_name, alert_data)
VALUES (SEQ_ALERT_NR.NEXTVAL, 'ExecuteCmdOnClient', lvs_cmd);
					

select * from utclientalerts
/*
193012	EvaluateMeDetails	sc=RAG1951000T06#pg=Flat track other#pgnode=1000000#pa=TT271AQ#panode=1000000#me=TT271Q#menode=1000000#reanalysis=0
193011	EvaluateMeDetails	sc=RAG1951000T05#pg=Flat track other#pgnode=1000000#pa=TT271AQ#panode=1000000#me=TT271Q#menode=1000000#reanalysis=0
193010	EvaluateMeDetails	sc=RAG1951000T04#pg=Flat track other#pgnode=1000000#pa=TT271AQ#panode=1000000#me=TT271Q#menode=1000000#reanalysis=0
193009	EvaluateMeDetails	sc=RAG1951000T02#pg=Flat track other#pgnode=1000000#pa=TT271AQ#panode=1000000#me=TT271Q#menode=1000000#reanalysis=0
193008	EvaluateMeDetails	sc=RAG1951000T01#pg=Flat track other#pgnode=1000000#pa=TT271AQ#panode=1000000#me=TT271Q#menode=1000000#reanalysis=0
193007	EvaluateMeDetails	sc=RAG1951000T03#pg=Flat track other#pgnode=1000000#pa=TT271AQ#panode=1000000#me=TT271Q#menode=1000000#reanalysis=0
193006	EvaluateMeDetails	sc=RAG2104001T02#pg=Indoor testing#pgnode=2000000#pa=TT520AX-TT729XX#panode=1000000#me=CT006F#menode=2000000#reanalysis=0
192991	EvaluateMeDetails	sc=RAG2051000T23#pg=Indoor testing#pgnode=2000000#pa=TT711AA#panode=2000000#me=CT008D#menode=2000000#reanalysis=0
192990	EvaluateMeDetails	sc=RAG2051000T22#pg=Indoor testing#pgnode=2000000#pa=TT711AA#panode=2000000#me=PT410AA#menode=1000000#reanalysis=0
etc
*/

















--einde script


CREATE OR REPLACE PACKAGE
-- Unilab 4.0 Package
-- $Revision: 10 $
-- $Date: 05 02 21 4:04p $
AOSMTP AS

------------------------------------------------------------------------------------------------
--General auxiliary function that can be used to send mail from within PL/SQL
--This function will only work on Oracle8.1
--where the Jserver option has been installed
FUNCTION QueueMail(a_recipient        IN   VARCHAR2,                    /* VC40_TYPE */
                  a_subject          IN   VARCHAR2,                    /* VC255_TYPE */
                  a_text_tab         IN   Unapigen.VC255_TABLE_TYPE,   /* VC255_TABLE_TYPE */
                  a_nr_of_rows       IN   NUMBER)                      /* NUM_TYPE */
RETURN NUMBER;

PROCEDURE JOB_SMTP;

PROCEDURE DoMonitoring;

FUNCTION StartSMTPJob
RETURN NUMBER;

FUNCTION StopSMTPJob
RETURN NUMBER;

FUNCTION StartMonitoringJob
RETURN NUMBER;

FUNCTION StopMonitoringJob
RETURN NUMBER;

FUNCTION StartAnyJob(JobName IN VARCHAR2,ApiName IN VARCHAR2, JobInterval IN VARCHAR2)
RETURN NUMBER;

FUNCTION StopAnyJob(JobName IN VARCHAR2,ApiName IN VARCHAR2)
RETURN NUMBER;


END AOSMTP;
/


CREATE OR REPLACE PACKAGE BODY
-- Unilab 4.0 Package
-- $Revision: 10 $
-- $Date: 05 02 21 4:04p $
AOSMTP AS

P_SMTP_SERVER     VARCHAR2(255);
P_SMTP_DOMAIN     VARCHAR2(255);
P_SMTP_SENDER     VARCHAR2(255);

CURSOR l_system_cursor(a_setting_name VARCHAR2) IS
   SELECT setting_value
   FROM UTSYSTEM
   WHERE setting_name = a_setting_name;

------------------------------------------------------------------------------------------------
FUNCTION split_vc (delimited_txt VARCHAR2, delimiter VARCHAR2, Len OUT NUMBER)
RETURN UNAPIGEN.VC255_TABLE_TYPE
IS
  t_res UNAPIGEN.VC255_TABLE_TYPE;
  l_cnt NUMBER := 0;
BEGIN
  FOR l_t IN (with t as (SELECT delimited_txt as txt FROM dual)
                         -- end of sample data
                             SELECT REGEXP_SUBSTR (txt, '[^'||delimiter||']+', 1, level) res
                             FROM t
                             CONNECT BY LEVEL <= length(regexp_replace(txt,'[^'||delimiter||']*'))+1) LOOP
    l_cnt:=l_cnt+1;
    t_res(l_cnt):=l_t.res;
  END LOOP;
  Len:=l_cnt;
  RETURN t_res;
END;
------------------------------------------------------------------------------------------------


FUNCTION SendMail(avi_email_id IN NUMBER)
RETURN NUMBER
  --*********************************************************
  -- Main function translating the sampletypes and parameters
  -- and inserting the values in the EQUOL database.
  --*********************************************************
IS
  CURSOR c_mailbox
  IS
  SELECT MAIL_FROM, MAIL_TO, SUBJECT
    FROM ATMAILBOX
   WHERE MAIL_ID= avi_email_id;

  CURSOR c_mail
  IS
  SELECT LINE
    FROM ATMAIL
   WHERE MAIL_ID= avi_email_id
   ORDER BY LINE_ID;

lRawData      RAW(32767);
l_connection  utl_smtp.connection;
l_row         INTEGER;
l_isopen      BOOLEAN DEFAULT FALSE;
a_recipient   VARCHAR2(40);-- :='<rberghmans@enci.nl>'; --herman.kamphuis@logicacmg.com>'; --                   /* VC40_TYPE */
a_subject     VARCHAR2(40);-- :='Automatische Mail Unilab';                    /* VC255_TYPE */
l_step    VARCHAR2(20);
lvs_sqlerrm   VARCHAR2(255);
l_debug    BOOLEAN:=TRUE;
    PROCEDURE send_header(a_connection IN OUT utl_smtp.connection, a_name IN VARCHAR2, a_header IN VARCHAR2) AS
    BEGIN
       utl_smtp.write_data(a_connection, a_name || ': ' || a_header || utl_tcp.CRLF);
    END;

   PROCEDURE send_raw_header(a_connection IN OUT utl_smtp.connection, a_name IN VARCHAR2, a_header IN VARCHAR2) AS
      l_raw RAW(32767);
   BEGIN
      l_raw := utl_raw.cast_to_raw(a_name || ': ' || a_header || utl_tcp.CRLF);
      utl_smtp.write_raw_data(a_connection, l_raw);
   END;
BEGIN
   FOR l_mail IN c_mailbox LOOP
    l_step:='Open';
    l_connection := utl_smtp.open_connection(P_SMTP_SERVER);
    l_isopen := TRUE;
    l_step:='helo';
    utl_smtp.helo(l_connection, P_SMTP_DOMAIN);
    l_step:='mail';
    utl_smtp.mail(l_connection, l_mail.MAIL_FROM);
    l_step:='rcpt';
    utl_smtp.rcpt(l_connection, '<'||l_mail.MAIL_TO||'>');
    l_step:='open_data';
    utl_smtp.open_data(l_connection);
    l_step:='header1';
    send_header(l_connection, 'From',   P_SMTP_SENDER);
    l_step:='header2';
    send_header(l_connection, 'To',     l_mail.MAIL_TO);
    l_step:='header_raw';
    send_raw_header(l_connection, 'Subject', l_mail.SUBJECT);
    l_step:='header3';
    send_header(l_connection, 'Content-Type', UNAPIGEN.P_SMTP_CONTENT_TYPE);
    FOR l_msg IN c_mail LOOP
       lRawData := utl_raw.cast_to_raw(utl_tcp.CRLF ||l_msg.LINE);
       l_step:='write_data';
       UTL_smtp.write_raw_data(l_connection, lRawData);
    END LOOP;
    l_step:='close data';
    utl_smtp.close_data(l_connection);
    l_step:='quit';
    utl_smtp.quit(l_connection);
    l_isopen := FALSE;
    IF l_debug THEN
     DBMS_OUTPUT.PUT_LINE('Succesfully sent');
     DBMS_OUTPUT.PUT_LINE('Used settings:smtp_server='||P_SMTP_SERVER);
     DBMS_OUTPUT.PUT_LINE('#smtp_domain='||P_SMTP_DOMAIN);
     DBMS_OUTPUT.PUT_LINE('#smtp_sender='||l_mail.MAIL_FROM);
     DBMS_OUTPUT.PUT_LINE('#smtp_recipient='||l_mail.MAIL_TO);
     DBMS_OUTPUT.PUT_LINE('#Content-Type='||UNAPIGEN.P_SMTP_CONTENT_TYPE);
    END IF;
   END LOOP;
   RETURN UNAPIGEN.DBERR_SUCCESS;
EXCEPTION
WHEN utl_smtp.transient_error OR utl_smtp.permanent_error THEN
   lvs_sqlerrm:=avi_email_id||':'||l_step||':'||SUBSTR(SQLERRM,1,100);
   IF l_isopen THEN
      utl_smtp.quit(l_connection);
      l_isopen := FALSE;
   END IF;
   l_isopen := FALSE;
   IF l_debug THEN
    DBMS_OUTPUT.PUT_LINE(l_step);
    DBMS_OUTPUT.PUT_LINE('SendMail:'||SUBSTR(SQLERRM,1,100));
    DBMS_OUTPUT.PUT_LINE('Used settings:smtp_server='||P_SMTP_SERVER);
    DBMS_OUTPUT.PUT_LINE('#smtp_domain='||P_SMTP_DOMAIN);
    DBMS_OUTPUT.PUT_LINE('#smtp_sender='||P_SMTP_SENDER);
    DBMS_OUTPUT.PUT_LINE('#smtp_recipient='||a_recipient);
    DBMS_OUTPUT.PUT_LINE('#Content-Type='||UNAPIGEN.P_SMTP_CONTENT_TYPE);
   END IF;
   UNAPIGEN.LOGERROR('AOSMTP.SendMail',lvs_sqlerrm);
   RETURN UNAPIGEN.DBERR_GENFAIL;
WHEN OTHERS THEN
   lvs_sqlerrm:=avi_email_id||':'||l_step||':'||SUBSTR(SQLERRM,1,100);
   IF l_debug THEN
    DBMS_OUTPUT.PUT_LINE(l_step);
    DBMS_OUTPUT.PUT_LINE('SendMail:'||SUBSTR(SQLERRM,1,100));
    DBMS_OUTPUT.PUT_LINE('Used settings:smtp_server='||P_SMTP_SERVER);
    DBMS_OUTPUT.PUT_LINE('#smtp_domain='||P_SMTP_DOMAIN);
    DBMS_OUTPUT.PUT_LINE('#smtp_sender='||P_SMTP_SENDER);
    DBMS_OUTPUT.PUT_LINE('#smtp_recipient='||a_recipient);
    DBMS_OUTPUT.PUT_LINE('#Content-Type='||UNAPIGEN.P_SMTP_CONTENT_TYPE);
   END IF;
   IF l_isopen THEN
      utl_smtp.quit(l_connection);
      l_isopen := FALSE;
   END IF;
   UNAPIGEN.LOGERROR('AOSMTP.SendMail',lvs_sqlerrm);
   RETURN UNAPIGEN.DBERR_GENFAIL;
END;

PROCEDURE JOB_SMTP
  --*********************************************************
  -- Main job running the EQUOL interface.
  --*********************************************************
IS
  --*********************************************************
  -- Only select unsuccessfully handled samples.
  --*********************************************************
  CURSOR c_mailbox
  IS
  SELECT MAIL_ID
    FROM ATMAILBOX
   WHERE NVL(HANDLED,1)<>0;

  l_ret_code NUMBER;
  lvs_sqlerrm VARCHAR2(255);
BEGIN

 BEGIN
  OPEN l_system_cursor('SMTP_SERVER');
  FETCH l_system_cursor
  INTO P_SMTP_SERVER;
  IF l_system_cursor%NOTFOUND THEN
     UNAPIGEN.LOGERROR('AOSMTP.Initilisation', 'missing system setting: SMTP_SERVER');
  END IF;
  CLOSE l_system_cursor;
  OPEN l_system_cursor('SMTP_DOMAIN');
  FETCH l_system_cursor
  INTO P_SMTP_DOMAIN;
  IF l_system_cursor%NOTFOUND THEN
     UNAPIGEN.LOGERROR('AOSMTP.Initilisation', 'missing system setting: SMTP_DOMAIN');
  END IF;
  CLOSE l_system_cursor;
  OPEN l_system_cursor('SMTP_SENDER');
  FETCH l_system_cursor
  INTO P_SMTP_SENDER;
  IF l_system_cursor%NOTFOUND THEN
     UNAPIGEN.LOGERROR('AOSMTP.Initilisation', 'missing system setting: SMTP_SENDER');
  END IF;
  CLOSE l_system_cursor;
 EXCEPTION
  WHEN OTHERS THEN
     IF l_system_cursor%ISOPEN THEN
        CLOSE l_system_cursor;
     END IF;
 END;

  FOR l_mail IN c_mailbox LOOP

    l_ret_code:=SendMail(l_mail.mail_id);

    UPDATE ATMAILBOX
       SET HANDLED=l_ret_code
     WHERE MAIL_ID=l_mail.mail_id;

    COMMIT;

  END LOOP;

  DELETE FROM ATMAIL WHERE MAIL_ID IN(SELECT MAIL_ID FROM ATMAILBOX WHERE HANDLED=0);

  DELETE FROM ATMAILBOX WHERE HANDLED=0;

  COMMIT;

  RETURN;
EXCEPTION
  WHEN OTHERS THEN
    lvs_sqlerrm:=SQLERRM;
    UNAPIGEN.LogError('JOB_SMTP',SUBSTR(' err:'||lvs_sqlerrm,1,255));
    RETURN;
END JOB_SMTP;

FUNCTION SendMailAlarm(a_parameter IN VARCHAR2, a_errormsg IN VARCHAR2)
RETURN NUMBER IS
--
CURSOR c_alarm(a_parameter IN VARCHAR2 ) IS
SELECT PARAMETER_NAME,
    PARAMETER_VALUE_SQL,
    SQL_LAST_RUN_DT,
    SQL_PREV_VALUE,
    SQL_LAST_VALUE,
    PARAMETER_KPI_CALC,
    PARAMETER_KPI_LEVEL,
    PARAMETER_PRIORITY,
    EMAIL_LIST,
    EMAIL_CONFIG
  FROM ATMONITOR
  WHERE PARAMETER_NAME=a_parameter
    AND EMAIL_LIST LIKE '%@%.%';
--
--local variables for SendMail
l_creator_email           VARCHAR2(255);
l_recipient_email         VARCHAR2(255);
l_cc_email                VARCHAR2(255);
l_subject                 VARCHAR2(255);
l_sqlerrm               VARCHAR2(255);
l_content                 VARCHAR2(2000);
l_text_tab                UNAPIGEN.VC255_TABLE_TYPE;
l_nr_of_rows              NUMBER;
l_ret_code             NUMBER;
BEGIN
   -- 1. Find out which request is handled
   -- 2. Locate the platform defined in the infofield 'ULPACKPLATFORM'
   -- 3. Collect email address(es)
   -- 4. Create strings to send

   l_creator_email   := 'UNILAB';
   l_recipient_email := ' ';

   FOR l_mail_rec IN c_alarm(a_parameter) LOOP

      l_content:=NVL(l_mail_rec.EMAIL_CONFIG, 'Alarm:'||l_mail_rec.PARAMETER_NAME||
                                              '/Previous value:'||l_mail_rec.SQL_PREV_VALUE||
                                              '/Last value:'||l_mail_rec.SQL_LAST_VALUE||
                                              '/Alarm- or KPI level(max):'||l_mail_rec.PARAMETER_KPI_LEVEL||
                                              '/SQL_LAST_RUN_DT:'||TO_CHAR(l_mail_rec.SQL_LAST_RUN_DT,'DD-MM-RRRR HH24fx:MI:SS')||
                                              '/Message:'||a_errormsg);
      l_recipient_email:=l_mail_rec.EMAIL_LIST;

      IF l_recipient_email IS NOT NULL THEN
        -- fill in the subject and mailbody texts
        l_subject := 'Alarm:'||l_mail_rec.PARAMETER_NAME;
        l_text_tab:=split_vc(l_content,'/',l_nr_of_rows);

        IF l_nr_of_rows>0 THEN
          l_ret_code := QueueMail(a_recipient  => l_recipient_email,
                                          a_subject    => l_subject,
                                          a_text_tab   => l_text_tab,
                                          a_nr_of_rows => l_nr_of_rows);

          IF l_ret_code <> Unapigen.DBERR_SUCCESS THEN
               UNAPIGEN.LogError('AOSMTP.SendMailAlarm', 'SendMail failed for '||l_recipient_email);
          END IF;
        END IF;
     END IF;

   END LOOP;

   RETURN(Unapigen.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   l_sqlerrm := SUBSTR(SQLERRM,1,255);
    UNAPIGEN.LogError('AOSMTP.SendMailAlarm', 'Failed to send mail for param: '||a_parameter);
    UNAPIGEN.LogError('AOSMTP.SendMailAlarm', SUBSTR(l_sqlerrm,1,200));
   RETURN(Unapigen.DBERR_GENFAIL);
END SendMailAlarm;

------------------------------------------------------------------------------------------------
--General auxiliary function that can be used to send mail from within PL/SQL
--This function will only work on Oracle8.1
--where the Jserver option has been installed
FUNCTION QueueMail(a_recipient        IN   VARCHAR2,                    /* VC40_TYPE */
                  a_subject          IN   VARCHAR2,                    /* VC255_TYPE */
                  a_text_tab         IN   Unapigen.VC255_TABLE_TYPE,   /* VC255_TABLE_TYPE */
                  a_nr_of_rows       IN   NUMBER)                      /* NUM_TYPE */
RETURN NUMBER IS
 lvi_mail_id NUMBER;
  l_recip VARCHAR2(255);
  l_recipient VARCHAR2(255);
  l_next NUMBER;
  l_control NUMBER;
  l_sqlerrm VARCHAR2(255 CHAR);
BEGIN
  l_next:=1;
  lvi_mail_id:=0;
  l_control:=0;
  l_recipient:=a_recipient||';';
  LOOP

   l_control:=l_control+1;
   l_recip:=SUBSTR(l_recipient,l_next,INSTR(l_recipient,';',l_next)-l_next);
   l_next:=INSTR(l_recipient,';',l_next)+1;
   EXIT WHEN INSTR(l_recip,';')>0;
   EXIT WHEN INSTR(l_recip,'@')=0;
   EXIT WHEN l_recip IS NULL;
   EXIT WHEN l_control>100;

   SELECT ATMAILID.NEXTVAL
     INTO lvi_mail_id
  FROM DUAL;

   FOR l_row IN 1..a_nr_of_rows LOOP

   INSERT INTO ATMAIL(MAIL_ID,LINE_ID,LINE)
   VALUES (lvi_mail_id,l_row,a_text_tab(l_row));

   END LOOP;

  INSERT INTO ATMAILBOX(MAIL_ID,MAIL_FROM,MAIL_TO,SUBJECT,HANDLED)
   VALUES (lvi_mail_id,P_SMTP_SENDER,l_recip,SUBSTR(a_subject,1,80),NULL);

  END LOOP;
  RETURN(Unapigen.DBERR_SUCCESS);
EXCEPTION
WHEN OTHERS THEN
   l_sqlerrm := SUBSTR(SQLERRM,1,255);
   UNAPIGEN.LogError('AOSMTP.SendMail', l_sqlerrm);
   RETURN(Unapigen.DBERR_GENFAIL);
END QueueMail;

PROCEDURE DoMonitoring
IS
CURSOR CrMonitoring
IS
SELECT * FROM ATMONITOR
WHERE NVL(NEXT_RUN_DT,CURRENT_TIMESTAMP-1)<CURRENT_TIMESTAMP;

TYPE cur_typ IS REF CURSOR;
param_cursor      cur_typ; -- Declare a cursor variable
param_query       VARCHAR2(1000 CHAR);
param_res           VARCHAR2(80 CHAR);
param_kpi            NUMBER;
param_next_run  DATE;
param_run_state VARCHAR2(255 CHAR);
l_ret_code            NUMBER;
BEGIN
   BEGIN
      OPEN l_system_cursor('SMTP_SERVER');
      FETCH l_system_cursor
      INTO P_SMTP_SERVER;
      IF l_system_cursor%NOTFOUND THEN
         UNAPIGEN.LOGERROR('AOSMTP.Initilisation', 'missing system setting: SMTP_SERVER');
      END IF;
      CLOSE l_system_cursor;
      OPEN l_system_cursor('SMTP_DOMAIN');
      FETCH l_system_cursor
      INTO P_SMTP_DOMAIN;
      IF l_system_cursor%NOTFOUND THEN
         UNAPIGEN.LOGERROR('AOSMTP.Initilisation', 'missing system setting: SMTP_DOMAIN');
      END IF;
      CLOSE l_system_cursor;
      OPEN l_system_cursor('SMTP_SENDER');
      FETCH l_system_cursor
      INTO P_SMTP_SENDER;
      IF l_system_cursor%NOTFOUND THEN
         UNAPIGEN.LOGERROR('AOSMTP.Initilisation', 'missing system setting: SMTP_SENDER');
      END IF;
      CLOSE l_system_cursor;
   EXCEPTION
      WHEN OTHERS THEN
         IF l_system_cursor%ISOPEN THEN
            CLOSE l_system_cursor;
         END IF;
   END;
   FOR l_monitor IN CrMonitoring LOOP
     SAVEPOINT UNILAB4;
     param_run_state :='Monitoring Succeeded';
     BEGIN

        OPEN param_cursor FOR l_monitor.PARAMETER_VALUE_SQL;
        FETCH param_cursor  INTO param_res;
        CLOSE param_cursor;

        OPEN param_cursor FOR l_monitor.NEXT_RUN_SQL;
        FETCH param_cursor  INTO param_next_run;
        CLOSE param_cursor;

        UPDATE ATMONITOR SET SQL_LAST_RUN_DT=CURRENT_TIMESTAMP,
           SQL_PREV_VALUE=SQL_LAST_VALUE, SQL_LAST_VALUE=param_res, NEXT_RUN_DT=param_next_run
           WHERE PARAMETER_NAME=l_monitor.PARAMETER_NAME;

        COMMIT;

        param_query:=REPLACE(l_monitor.PARAMETER_KPI_CALC,'<SQL_PREV_VALUE>',l_monitor.SQL_LAST_VALUE);
        param_query:=REPLACE(param_query,'<SQL_LAST_VALUE>',param_res);

        --
        OPEN param_cursor FOR param_query;
        FETCH param_cursor  INTO param_kpi;
        CLOSE param_cursor;
        --

        IF param_kpi> l_monitor.PARAMETER_KPI_LEVEL THEN
          l_ret_code := SendMailAlarm(l_monitor.PARAMETER_NAME, param_run_state);
          IF l_ret_code<>0 THEN
             param_run_state :='Error for:'||l_monitor.PARAMETER_NAME||' code:'||l_ret_code;
             UNAPIGEN.LogError('DoMonitor', param_run_state);
           END IF;
        END IF;
        --

        UPDATE ATMONITOR SET LAST_ERROR=param_run_state
           WHERE PARAMETER_NAME=l_monitor.PARAMETER_NAME;

        COMMIT;

     EXCEPTION
       WHEN OTHERS THEN
         param_run_state:=SUBSTR(SQLERRM,1,80);
         param_run_state :='Err ['||l_monitor.PARAMETER_NAME||']:'||param_run_state;
         UPDATE ATMONITOR SET LAST_ERROR=param_run_state
           WHERE PARAMETER_NAME=l_monitor.PARAMETER_NAME;

        IF SendMailAlarm(l_monitor.PARAMETER_NAME, param_run_state)<>0 THEN
          UNAPIGEN.LogError('DoMonitor','Err ['||l_monitor.PARAMETER_NAME||']:'||param_run_state);
        END IF;
     END;

      INSERT INTO ATMONITORHIST (  PARAMETER_NAME,    LOG_DATE,    modify_reason,
              PARAMETER_VALUE_SQL,    SQL_LAST_RUN_DT,    SQL_PREV_VALUE,
              SQL_LAST_VALUE,    PARAMETER_KPI_CALC,    PARAMETER_KPI_LEVEL,
              PARAMETER_PRIORITY,    EMAIL_LIST,    EMAIL_CONFIG,
              next_run_sql,    next_run_dt)
          VALUES  (l_monitor.PARAMETER_NAME,    CURRENT_TIMESTAMP,    SUBSTR(param_run_state,1,80),
              NULL,    l_monitor.SQL_LAST_RUN_DT,    l_monitor.SQL_PREV_VALUE,
              l_monitor.SQL_LAST_VALUE,    null,    l_monitor.PARAMETER_KPI_LEVEL,
              l_monitor.PARAMETER_PRIORITY,    null,    null,
              l_monitor.next_run_sql,    l_monitor.next_run_dt);

   END LOOP;
   COMMIT;
END;

FUNCTION StartSMTPJob
RETURN NUMBER
IS
  L_SMTP_INTERVAL VARCHAR2(20);
BEGIN
 OPEN l_system_cursor('SMTP_INTERVAL');
 FETCH l_system_cursor
 INTO L_SMTP_INTERVAL;
 IF l_system_cursor%NOTFOUND THEN
    UNAPIGEN.LOGERROR('AOSMTP.StartSMTPJob', 'missing system setting: SMTP_INTERVAL');
 ELSE
    CLOSE l_system_cursor;
    RETURN(StartAnyJob('JOB_SMTP', 'AOSMTP.JOB_SMTP;','SYSDATE +'||L_SMTP_INTERVAL));
 END IF;
 CLOSE l_system_cursor;
    RETURN UNAPIGEN.DBERR_GENFAIL;
END StartSMTPJob;

FUNCTION StopSMTPJob
RETURN NUMBER IS
BEGIN
  RETURN(StopAnyJob('JB_SMTP', 'AOSMTP.JOB_SMTP;'));
END StopSMTPJob;

FUNCTION StartMonitoringJob
RETURN NUMBER
IS
  L_MONITOR_INTERVAL VARCHAR2(20);
BEGIN
 OPEN l_system_cursor('MONITOR_INTERVAL');
 FETCH l_system_cursor
 INTO L_MONITOR_INTERVAL;
 IF l_system_cursor%NOTFOUND THEN
    UNAPIGEN.LOGERROR('AOSMTP.StartMonitoringJob', 'missing system setting: MONITOR_INTERVAL');
 ELSE
    CLOSE l_system_cursor;
    RETURN(StartAnyJob('JOB_MONITOR', 'AOSMTP.DOMONITORING;','SYSDATE +'||L_MONITOR_INTERVAL));
 END IF;
 CLOSE l_system_cursor;
    RETURN UNAPIGEN.DBERR_GENFAIL;
END StartMonitoringJob;

FUNCTION StopMonitoringJob
RETURN NUMBER IS
BEGIN
  RETURN(StopAnyJob('JOB_MONITOR', 'AOSMTP.DOMONITORING;'));
END StopMonitoringJob;

FUNCTION StartAnyJob(JobName IN VARCHAR2,ApiName IN VARCHAR2, JobInterval IN VARCHAR2)
RETURN NUMBER
--**************************************************************************--
-- Description: This function loads the Job CHECK_QCLOT_EXP_DD if it is not
--              yet loaded. If it is broken, a relaunch is performed.
-- Created on:  11-01-2005 By: DH.
--**************************************************************************--
--**************************************************************************--
-- Changed on:         By:
-- Reason:
--**************************************************************************--
 IS
  l_job BINARY_INTEGER;
  l_broken CHAR(1);
  l_what VARCHAR2(2000);
  l_interval NUMBER;
  l_setting_value VARCHAR2(40);
  l_found BOOLEAN;
  l_leave_loop BOOLEAN;
  l_attempts INTEGER;
  l_dba_name VARCHAR2(40);
  lvs_seconds VARCHAR2(40);
  l_sqlerrm VARCHAR2(255);
  StpError              EXCEPTION;
  CURSOR l_jobs_cursor (a_search VARCHAR2) IS
    SELECT job,broken,what
    FROM sys.dba_jobs
    WHERE INSTR(UPPER(what), a_search)<>0;
  CURSOR c_system (a_setting_name VARCHAR2) IS
    SELECT setting_value
    FROM UTSYSTEM
    WHERE setting_name = a_setting_name;

BEGIN
  /*---------------------------------------------------------------------------*/
  /* Check IF job exists */
  /* No functions provided to check IF a job is existing in DBMS_JOB package */
  /* ALL_JOBS AND USER_JOBS views could not be used since they are referencing */
  /* the USER session as creator of the job ! */
  /*---------------------------------------------------------------------------*/
  OPEN l_jobs_cursor(JobName);
  FETCH l_jobs_cursor INTO l_job,l_broken,l_what;
  l_found := l_jobs_cursor%FOUND;
  CLOSE l_jobs_cursor;

  OPEN c_system ('DBA_NAME');
  FETCH c_system INTO l_dba_name;
  IF c_system%NOTFOUND THEN
    CLOSE c_system;
    Unapigen.P_TXN_ERROR := Unapigen.DBERR_SYSDEFAULTS;
    RAISE StpError;
  END IF;
  CLOSE c_system;

  lvs_seconds:=10;

  /* When action required : check IF authorised */
  /*--------------------------------------------*/
  --IF UPPER(l_dba_name) <> UPPER(USER) THEN
  --  RETURN(Unapigen.DBERR_EVMGRSTARTNOTAUTHORISED);
  --END IF;
  IF l_found THEN
    IF UPPER(l_broken) = 'Y' THEN
      /*-----------------*/
      /* Try to relaunch */
      /*-----------------*/
      DBMS_JOB.BROKEN(l_job, FALSE, SYSDATE);
    END IF;
  ELSE
    /*------------------------------------------*/
    /* The job has to be created */
    /*------------------------------------------*/
    DBMS_JOB.SUBMIT(l_job, ApiName, SYSDATE, JobInterval, FALSE);
  END IF;
  COMMIT;

  /*----------------------------------------------------------------------*/
  /* Leave this function when Job effectively inserted INTO the job queue */
  /* or removed FROM the job queue */
  /* To avoid double starts or double stops */
  /*----------------------------------------------------------------------*/
  l_leave_loop := FALSE;
  l_attempts := 0;
  WHILE NOT l_leave_loop LOOP
    l_attempts := l_attempts + 1;
    OPEN l_jobs_cursor(ApiName);
    FETCH l_jobs_cursor INTO l_job,l_broken,l_what;
    l_found := l_jobs_cursor%FOUND;
    CLOSE l_jobs_cursor;

    IF l_found THEN
      l_leave_loop := TRUE;
    ELSE
      IF l_attempts >= 30 THEN
        l_sqlerrm := JobName||'-job not started ! (timeout after 60 seconds)';
        RAISE StpError;
      ELSE
        DBMS_LOCK.SLEEP(2);
      END IF;
    END IF;
  END LOOP;
  RETURN(Unapigen.DBERR_SUCCESS);
EXCEPTION
 WHEN STPERROR THEN
  l_sqlerrm := SUBSTR(SQLERRM,1,255);
  INSERT INTO UTERROR(client_id, applic, who, logdate, api_name, error_msg)
  VALUES(Unapigen.P_CLIENT_ID, Unapigen.P_APPLIC_NAME, USER, SYSDATE,
  'AOCUSTOM.StartAnyJob', l_sqlerrm);
 WHEN OTHERS THEN
  IF SQLCODE <> 1 THEN
  l_sqlerrm := SQLERRM;
  END IF;
  INSERT INTO UTERROR(client_id, applic, who, logdate, api_name, error_msg)
  VALUES(Unapigen.P_CLIENT_ID, Unapigen.P_APPLIC_NAME, USER, SYSDATE,
  'AOCUSTOM.StartAnyJob', l_sqlerrm );
  COMMIT;
  IF l_jobs_cursor%ISOPEN THEN
  CLOSE l_jobs_cursor;
  END IF;
  IF c_system%ISOPEN THEN
  CLOSE c_system;
  END IF;

  RETURN(Unapigen.DBERR_GENFAIL);
END StartAnyJob;

FUNCTION StopAnyJob(JobName IN VARCHAR2,ApiName IN VARCHAR2)
RETURN NUMBER IS
  -- Stop the MRP interface
  l_job BINARY_INTEGER;
  l_broken CHAR(1);
  l_what VARCHAR2(2000);
  l_interval NUMBER;
  l_setting_value VARCHAR2(40);
  l_found BOOLEAN;
  l_leave_loop BOOLEAN;
  l_attempts INTEGER;
  l_dba_name VARCHAR2(40);
  l_job_nr NUMBER;
  l_mrp_job2 NUMBER;
  l_verv_job NUMBER;
  l_sqlerrm VARCHAR2(255);
  StpError              EXCEPTION;
  CURSOR l_jobs_cursor (a_search VARCHAR2) IS
    SELECT job,broken,what
    FROM sys.dba_jobs
    WHERE INSTR(UPPER(what), a_search)<>0;
  CURSOR c_system (a_setting_name VARCHAR2) IS
    SELECT setting_value
    FROM UTSYSTEM
    WHERE setting_name = a_setting_name;
BEGIN
  BEGIN
    SELECT NVL(MIN(job),0)
      INTO l_job_nr
      FROM sys.dba_jobs
    WHERE UPPER(what)=ApiName;
      IF l_job_nr <> 0 THEN
        DBMS_JOB.REMOVE(l_job_nr);
      END IF;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    NULL;
  END;
  -- Stop the current running process
  DBMS_ALERT.SIGNAl(JobName, 'STOP');
  COMMIT;
  /*---------------------------------------------------------------------------*/
  /* Check IF job exists */
  /* No functions provided to check IF a job is existing in DBMS_JOB package */
  /* ALL_JOBS AND USER_JOBS views could not be used since they are referencing */
  /* the USER session as creator of the job ! */
  /*---------------------------------------------------------------------------*/
  OPEN l_jobs_cursor(JobName);
  FETCH l_jobs_cursor INTO l_job,l_broken,l_what;
  l_found := l_jobs_cursor%FOUND;
  CLOSE l_jobs_cursor;

  OPEN c_system ('DBA_NAME');
  FETCH c_system INTO l_dba_name;
  IF c_system%NOTFOUND THEN
    CLOSE c_system;
    Unapigen.P_TXN_ERROR := Unapigen.DBERR_SYSDEFAULTS;
    RAISE StpError;
  END IF;
  CLOSE c_system;
  /* When action required : check IF authorised */
  /*--------------------------------------------*/
  IF UPPER(l_dba_name) <> UPPER(USER) THEN
    RETURN(Unapigen.DBERR_EVMGRSTARTNOTAUTHORISED);
  END IF;
  IF l_found THEN
    /*-----------------------*/
    /* Try to remove the job */
    /*-----------------------*/
    DBMS_JOB.REMOVE(l_job);
  END IF;
  COMMIT;
  /*----------------------------------------------------------------------*/
  /* Leave this function when Job effectively removed FROM the job queue */
  /* To avoid double starts or double stops */
  /*----------------------------------------------------------------------*/
  l_leave_loop := FALSE;
  l_attempts := 0;
  WHILE NOT l_leave_loop LOOP
    l_attempts := l_attempts + 1;
    OPEN l_jobs_cursor(JobName);
    FETCH l_jobs_cursor INTO l_job,l_broken,l_what;
    l_found := l_jobs_cursor%FOUND;
    CLOSE l_jobs_cursor;

    IF NOT l_found THEN
      l_leave_loop := TRUE;
    ELSE
      IF l_attempts >= 30 THEN
        l_sqlerrm := JobName||'-job not stopped ! (timeout after 60 seconds)';
        RAISE StpError;
      ELSE
        DBMS_LOCK.SLEEP(20000);
      END IF;
    END IF;
  END LOOP;
RETURN(Unapigen.DBERR_SUCCESS);
EXCEPTION
 WHEN STPERROR THEN
  l_sqlerrm := SUBSTR(SQLERRM,1,255);
  INSERT INTO UTERROR(client_id, applic, who, logdate, api_name, error_msg)
  VALUES(Unapigen.P_CLIENT_ID, Unapigen.P_APPLIC_NAME, USER, SYSDATE,
  'AOCUSTOM.StopAnyJob', l_sqlerrm);
  RETURN(Unapigen.DBERR_GENFAIL);
 WHEN OTHERS THEN
  IF SQLCODE <> 1 THEN
    l_sqlerrm := SQLERRM;
  END IF;

  INSERT INTO UTERROR(client_id, applic, who, logdate, api_name, error_msg)
  VALUES(Unapigen.P_CLIENT_ID, Unapigen.P_APPLIC_NAME, USER, SYSDATE,
         'AOCUSTOM.StopAnyJob' , l_sqlerrm );
  COMMIT;
  IF l_jobs_cursor%ISOPEN THEN
    CLOSE l_jobs_cursor;
  END IF;
  IF c_system%ISOPEN THEN
    CLOSE c_system;
  END IF;
  RETURN(Unapigen.DBERR_GENFAIL);
END StopAnyJob;

END AOSMTP;
/

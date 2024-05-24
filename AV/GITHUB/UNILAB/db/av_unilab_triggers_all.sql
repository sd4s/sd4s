--------------------------------------------------------
--  File created - dinsdag-oktober-27-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Trigger AT_DEBUG_TRG_BRI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "UNILAB"."AT_DEBUG_TRG_BRI" 
before insert
ON UNILAB.ATDEBUG 
referencing new as new old as old
for each row
begin
  select at_debug_seq.nextval
  into   :new.dbg_seq_no
  from   dual;
  :new.dbg_timestamp := sysdate;
  :new.dbg_type := nvl(:new.dbg_type, 'DBG');
  :new.dbg_user := user;
end;
/
ALTER TRIGGER "UNILAB"."AT_DEBUG_TRG_BRI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger AT_UPD_RQ_PREP
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "UNILAB"."AT_UPD_RQ_PREP" 
AFTER UPDATE
ON UTRQ
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
 WHEN (
OLD.SS <> 'CM' and NEW.SS = 'CM' and NEW.RT='T-T: PCT Outdoor'
      ) DECLARE
  REQ UTRQ.RQ%type;
BEGIN
   REQ := :NEW.RQ;
   INSERT INTO AT_WS_PREP_UPDATES(DATE_TIME, WS, RQ, SS, STATUS) VALUES 
    (SYSDATE, '', REQ, :NEW.SS, 0);
   AT_WMS.AT_SENDWMS(REQ); 

   EXCEPTION
     WHEN OTHERS THEN
       -- Consider logging the error and then re-raise
       RAISE;
END AT_UPD_RQ_PREP;
/
ALTER TRIGGER "UNILAB"."AT_UPD_RQ_PREP" ENABLE;
--------------------------------------------------------
--  DDL for Trigger AT_UPD_WS_PREP
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "UNILAB"."AT_UPD_WS_PREP" 
AFTER UPDATE
ON UTWS 
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
 WHEN (
(NEW.SS = 'AV' OR NEW.SS = '@P') and NEW.WT='PCTOutdoorPrep'
      ) DECLARE
  REQ UTRQ.RQ%type;
BEGIN
   SELECT REQUESTCODE INTO REQ FROM UTWSGKREQUESTCODE r WHERE r.WS = :NEW.WS;
   INSERT INTO AT_WS_PREP_UPDATES(DATE_TIME, WS, RQ, SS, STATUS) VALUES 
    (SYSDATE, :NEW.WS, REQ, :NEW.SS, 0);
   AT_WMS.AT_SENDWMS(REQ); 

   EXCEPTION
     WHEN OTHERS THEN
       -- Consider logging the error and then re-raise
       RAISE;
END AT_UPD_WS_PREP;
/
ALTER TRIGGER "UNILAB"."AT_UPD_WS_PREP" ENABLE;
--------------------------------------------------------
--  DDL for Trigger ATAO_AP00835359
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "UNILAB"."ATAO_AP00835359" 
BEFORE INSERT OR UPDATE
ON UTRT 
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
DECLARE
tmpVar NUMBER;
/******************************************************************************
   NAME:       ATAO_AP00835359
   PURPOSE:    WA for bug AP00835359

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        3-6-2009    Rody Sparenberg  Created this trigger.

   NOTES:

   This item has been logged as a bug: AP00835359: 
   Planned responsible not recognized when creating new version Description: 
   A request type has a planned responsible defined, e.g. 'Johnny'. 
   When a new version of this request type is created, 
   or another request type based on a template, 
   the planned responsible in this new request type is shown as '<<Johnny >>'. 
   The problem is that spaces are added till length 20. 
   As a workaround, a trigger can be installed to remove the spaces again.
   
******************************************************************************/
BEGIN

   :NEW.Planned_Responsible := RTRIM(:NEW.Planned_Responsible);

   EXCEPTION
     WHEN OTHERS THEN
       -- Consider logging the error and then re-raise
       RAISE;
END ATAO_AP00835359; 

/
ALTER TRIGGER "UNILAB"."ATAO_AP00835359" ENABLE;
--------------------------------------------------------
--  DDL for Trigger COSTCALCADDNULLCOLOUMN
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "UNILAB"."COSTCALCADDNULLCOLOUMN" 
   BEFORE INSERT OR UPDATE
   ON utcataloguedetails
   FOR EACH ROW
DECLARE
BEGIN
   IF ((:NEW.from_date IS NOT NULL) AND (:NEW.from_date_tz IS NULL))
   THEN
      :NEW.from_date_tz := :NEW.from_date;
   END IF;

   IF ((:NEW.to_date IS NOT NULL) AND (:NEW.to_date_tz IS NULL))
   THEN
      :NEW.to_date_tz := :NEW.to_date;
   END IF;
END;

/
ALTER TRIGGER "UNILAB"."COSTCALCADDNULLCOLOUMN" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ATERROR_MAILRULE
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "UNILAB"."TR_ATERROR_MAILRULE" 
AFTER INSERT ON aterror 
FOR EACH ROW
DECLARE
    l_sql_id     VARCHAR2(13);
    l_child_num  NUMBER;
    l_sqltext    CLOB;
    
    l_threshold  NUMBER;
    l_recipients VARCHAR2(4000);
    l_subject    VARCHAR2(255);
    l_instance   VARCHAR2(16);
    l_host       VARCHAR2(64);
    l_version    VARCHAR2(17);
    l_buffer     unapigen.vc255_table_type;
    l_index      NUMBER;
    l_retval     NUMBER;
    
    CURSOR c_rules(
        a_machine  VARCHAR2,
        a_applic   VARCHAR2,
        a_username VARCHAR2,
        a_api_name VARCHAR2,
        a_message  VARCHAR2
    ) IS
        SELECT ROWID, aterrormailrule.*
        FROM aterrormailrule
        WHERE (a_machine   LIKE machine   OR machine   IS NULL)
          AND (a_applic    LIKE applic    OR applic    IS NULL)
          AND (a_username  LIKE username  OR username  IS NULL)
          AND (a_api_name  LIKE api_name  OR api_name  IS NULL)
          AND (a_message   LIKE message   OR message   IS NULL)
          AND (
            limit IS NULL OR NVL(times_triggered, 0) < limit
            OR last_triggered IS NULL OR last_triggered + timeout < SYSDATE
          );

    CURSOR c_bind_vars(
        a_sql_id    VARCHAR2,
        a_child_num NUMBER
    ) IS
        SELECT
            name,
            position,
            was_captured,
            datatype_string,
            value_string
        FROM v$sql_bind_capture
        WHERE sql_id = a_sql_id
        AND child_number = a_child_num
    ;
    

    PROCEDURE appendLine(
        a_line IN VARCHAR2
    ) IS
        l_start NUMBER := 1;
        l_end   NUMBER;
    BEGIN
        IF (a_line IS NULL) THEN
            l_buffer(l_index) := NULL;
            l_index := l_index + 1;
            RETURN;
        END IF;
        LOOP
            l_end := INSTR(a_line, CHR(10), l_start) + 1;
            IF (l_end <= 1) THEN
                l_end := LEAST(LENGTH(a_line), l_start + 255);
            END IF;
            EXIT WHEN l_end - l_start <= 0;
            l_buffer(l_index) := TRIM(CHR(10) FROM SUBSTR(a_line, l_start, l_end - l_start));
            l_index := l_index + 1;
            l_start := l_end + 1;
        END LOOP;
    END;

    PROCEDURE appendLine(
        a_line IN CLOB
    ) IS
        l_start  NUMBER := 1;
        l_end    NUMBER;
    BEGIN
        IF (a_line IS NULL) THEN
            l_buffer(l_index) := NULL;
            l_index := l_index + 1;
            RETURN;
        END IF;
        LOOP
            l_end := dbms_lob.InStr(a_line, CHR(10), l_start) + 1;
            IF (l_end <= 1) THEN
                l_end := LEAST(dbms_lob.GetLength(a_line), l_start + 255);
            END IF;
            EXIT WHEN l_end - l_start <= 0;
            l_buffer(l_index) := TRIM(CHR(10) FROM dbms_lob.substr(a_line, l_end - l_start, l_start));
            l_index := l_index + 1;
            l_start := l_end + 1;
        END LOOP;
    END;
BEGIN
    /*
    SELECT prev_sql_id, prev_child_number
    INTO l_sql_id, l_child_num
    FROM v$session
    WHERE sid = USERENV('SID');

    BEGIN
        SELECT sql_fulltext
        INTO l_sqltext
        FROM v$sqlarea
        WHERE sql_id = l_sql_id;
    EXCEPTION
    WHEN OTHERS THEN
        NULL;
    END;
    */

    SELECT instance_name, host_name, version
    INTO l_instance, l_host, l_version
    FROM v$instance;
    
    FOR rule IN c_rules(
        :NEW.machine,
        :NEW.applic,
        :NEW.username,
        :NEW.api_name,
        :NEW.message
    ) LOOP
        UPDATE aterrormailrule
        SET
            times_triggered = CASE
                WHEN last_triggered + timeout < SYSDATE THEN 1
                ELSE NVL(times_triggered, 0) + 1
            END,
            last_triggered = SYSDATE
        WHERE ROWID = rule.ROWID
        RETURNING times_triggered - NVL(threshold, 0)
        INTO l_threshold;
        
        IF (l_threshold > 0) THEN
            l_buffer.DELETE;
            l_index := 1;

            l_recipients := rule.recipients;
            l_subject    := 'Unilab Error - ' || NVL(SUBSTR(rule.subject, 240), :NEW.api_name);
            
            appendLine('[Instance Info]');
            appendLine('Host:     ' || l_host);
            appendLine('Instance: ' || l_instance);
            appendLine('Version:  ' || l_version);
            appendLine('');
            appendLine('[Error Details]');
            appendLine('Logdate:  ' || TO_CHAR(:NEW.logdate, 'YYYY-MM-DD HH24:MI:SS'));
            appendLine('Machine:  ' || :NEW.machine);
            appendLine('Username: ' || :NEW.username);
            appendLine('Module:   ' || :NEW.applic);
            appendLine('Source:   ' || :NEW.api_name);
            appendLine('');
            appendLine('[Error Message]');
            appendLine(:NEW.message);
            appendLine('');
            appendLine('[Call Stack]');
            appendLine(dbms_utility.format_call_stack());
            appendLine('');
            appendLine('[Error Stack]');
            appendLine(dbms_utility.format_error_stack());
            appendLine('');
            appendLine('[Error Backtrace]');
            appendLine(dbms_utility.format_error_backtrace());
            appendLine('');
            /*
            appendLine('[Sql Query]');
            appendLine(l_sqltext);
            appendLine('');
            appendLine('[Bind Variables]');
            FOR rec IN c_bind_vars(l_sql_id, l_child_num) LOOP
                appendLine(
                    '[' || rec.position || '] ' ||
                    rec.datatype_string || ' '  ||
                    rec.name ||
                    CASE WHEN rec.was_captured = 'NO'
                        THEN ' [Uncaptured]'
                        ELSE ' := ' || rec.value_string
                    END
                );
            END LOOP;
            appendLine('');
            */
            appendLine('[Event Context]');
            appendLine('TR_SEQ     := ' || unapiev.p_ev_rec.tr_seq);
            appendLine('EV_SEQ     := ' || unapiev.p_ev_rec.ev_seq);
            appendLine('CREATED_ON := ' || TO_CHAR(unapiev.p_ev_rec.created_on, 'YYYY-MM-DD HH24:MI:SS'));
            appendLine('CLIENT_ID  := ' || unapiev.p_ev_rec.client_id);
            appendLine('APPLIC     := ' || unapiev.p_ev_rec.applic);
            appendLine('DBAPI_NAME := ' || unapiev.p_ev_rec.dbapi_name);
            appendLine('EVMGR_NAME := ' || unapiev.p_ev_rec.evmgr_name);
            appendLine('OBJECT_TP  := ' || unapiev.p_ev_rec.object_tp);
            appendLine('OBJECT_ID  := ' || unapiev.p_ev_rec.object_id);
            appendLine('OBJECT_LC  := ' || unapiev.p_ev_rec.object_lc);
            appendLine('OBJECT_LC_VERSION := ' || unapiev.p_ev_rec.object_lc_version);
            appendLine('OBJECT_SS  := ' || unapiev.p_ev_rec.object_ss);
            appendLine('EV_TP      := ' || unapiev.p_ev_rec.ev_tp);
            appendLine('USERNAME   := ' || unapiev.p_ev_rec.username);
            appendLine('EV_DETAILS := ' || unapiev.p_ev_rec.ev_details);
                  
            l_retval := unapiGen.SendMail(
                l_recipients,
                l_subject,
                l_buffer,
                l_index - 1
            );
        END IF;
    END LOOP;
END;
/
ALTER TRIGGER "UNILAB"."TR_ATERROR_MAILRULE" DISABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ATERROR_SEQ
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "UNILAB"."TR_ATERROR_SEQ" 
BEFORE INSERT ON aterror
FOR EACH ROW
BEGIN
    IF inserting AND :NEW.error_seq IS NULL THEN
        SELECT aterror_seq.nextval
        INTO :NEW.error_seq
        FROM sys.dual;
    END IF;
END;
/
ALTER TRIGGER "UNILAB"."TR_ATERROR_SEQ" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_LICENSECHECK_HS
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "UNILAB"."TR_LICENSECHECK_HS" 
AFTER INSERT
ON ATLICENSECHECK 
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
DECLARE
   tmpVar NUMBER;
BEGIN
   INSERT INTO atlicensecheckhs
              (RECORD, lic_consumed,
               machine, terminal, logon_station, SID,
               user_name, user_description, osuser,
               logon_date, session_logon_time, executable,
               job_last_run
              )
    VALUES (:NEW.record, :NEW.lic_consumed,
               :NEW.machine, :NEW.terminal, :NEW.logon_station, :NEW.sid,
               :NEW.user_name, :NEW.user_description, :NEW.osuser,
               :NEW.logon_date, :NEW.session_logon_time, :NEW.executable,
               :NEW.job_last_run
              );
   EXCEPTION
     WHEN OTHERS THEN
       NULL;
END TR_LICENSECHECK_HS;

/
ALTER TRIGGER "UNILAB"."TR_LICENSECHECK_HS" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_UTERROR
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "UNILAB"."TR_UTERROR" 
AFTER INSERT ON uterror
FOR EACH ROW
DECLARE
    l_error_hash NUMBER;
    l_info_level NUMBER;
BEGIN
    l_error_hash := GetErrorHash(:NEW.api_name, :NEW.error_msg);
    BEGIN
        SELECT info_level
        INTO l_info_level
        FROM aterrordetails
        WHERE error_hash = l_error_hash;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        l_info_level := 0;
    END;

    INSERT INTO aterror (
        error_hash,
        info_level,
        logdate,
        logdate_tz,
        tr_seq,
        ev_seq,
        machine,
        applic,
        username,
        api_name,
        message
    ) VALUES (
        l_error_hash,
        l_info_level,
        CURRENT_TIMESTAMP,
        CURRENT_TIMESTAMP,
        unapiev.p_ev_rec.tr_seq,
        unapiev.p_ev_rec.ev_seq,
        :NEW.client_id,
        :NEW.applic,
        :NEW.who,
        :NEW.api_name,
        :NEW.error_msg
    );
END;
/
ALTER TRIGGER "UNILAB"."TR_UTERROR" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_UTERROR_FILTER
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "UNILAB"."TR_UTERROR_FILTER" 
FOR INSERT ON uterror
COMPOUND TRIGGER
    TYPE RowTab_Type IS TABLE OF ROWID;
    
    l_row_tab RowTab_Type := RowTab_Type();
    l_index   BINARY_INTEGER;
    l_count   NUMBER;
    l_delete  NUMBER;
    
    AFTER EACH ROW IS
    BEGIN
        
        SELECT COUNT(*), MIN(filt.remove)
        INTO l_count, l_delete
        FROM aterrorfilter filt
        WHERE (:NEW.client_id LIKE filt.client_id OR filt.client_id IS NULL)
          AND (:NEW.applic    LIKE filt.applic    OR filt.applic    IS NULL)
          AND (:NEW.who       LIKE filt.who       OR filt.who       IS NULL)
          AND (:NEW.api_name  LIKE filt.api_name  OR filt.api_name  IS NULL)
          AND (:NEW.error_msg LIKE filt.error_msg OR filt.error_msg IS NULL)
        ;
        
        IF (l_count > 0) THEN
            IF (l_delete = 0) THEN
                INSERT INTO atinfo(client_id, applic, who, logdate, logdate_tz, api_name, error_msg)
                VALUES (:NEW.client_id, :NEW.applic, :NEW.who, SYSDATE, CURRENT_TIMESTAMP, :NEW.api_name, :NEW.error_msg);
            END IF;

            l_row_tab.EXTEND;
            l_row_tab(l_row_tab.LAST) := :NEW.ROWID;
        END IF;
    END AFTER EACH ROW;
    
    AFTER STATEMENT IS
    BEGIN
        l_index := l_row_tab.FIRST;
        WHILE (l_index IS NOT NULL)
        LOOP
            DELETE FROM uterror WHERE ROWID = l_row_tab(l_index);
            l_index := l_row_tab.NEXT(l_index);
        END LOOP;
        l_row_tab.DELETE;
    END AFTER STATEMENT;
END tr_uterror_filter;
/
ALTER TRIGGER "UNILAB"."TR_UTERROR_FILTER" DISABLE;
--------------------------------------------------------
--  DDL for Trigger TR_UTERROR_MAILRULE
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "UNILAB"."TR_UTERROR_MAILRULE" 
AFTER INSERT
ON UTERROR 
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE
    l_sql_id     VARCHAR2(13);
    l_child_num  NUMBER;
    l_sqltext    CLOB;
    
    l_threshold  NUMBER;
    l_recipients VARCHAR2(4000);
    l_subject    VARCHAR2(255);
    l_instance   VARCHAR2(16);
    l_host       VARCHAR2(64);
    l_version    VARCHAR2(17);
    l_buffer     unapigen.vc255_table_type;
    l_index      NUMBER;
    l_retval     NUMBER;
    
    CURSOR c_rules(
        a_machine  VARCHAR2,
        a_applic   VARCHAR2,
        a_username VARCHAR2,
        a_api_name VARCHAR2,
        a_message  VARCHAR2
    ) IS
        SELECT ROWID, aterrormailrule.*
        FROM aterrormailrule
        WHERE (a_machine  LIKE machine  OR machine  IS NULL)
          AND (a_applic   LIKE applic   OR applic   IS NULL)
          AND (a_username LIKE username OR username IS NULL)
          AND (a_api_name LIKE api_name OR api_name IS NULL)
          AND (a_message  LIKE message  OR message  IS NULL)
          AND (
            limit IS NULL OR NVL(times_triggered, 0) < limit
            OR last_triggered IS NULL OR last_triggered + timeout < SYSDATE
          )
          AND active = 'Y';
    

    PROCEDURE appendLine(
        a_line IN VARCHAR2
    ) IS
        l_start NUMBER := 1;
        l_end   NUMBER;
    BEGIN
        IF (a_line IS NULL) THEN
            l_buffer(l_index) := NULL;
            l_index := l_index + 1;
            RETURN;
        END IF;
        LOOP
            l_end := INSTR(a_line, CHR(10), l_start) + 1;
            IF (l_end <= 1) THEN
                l_end := LEAST(LENGTH(a_line) + 1, l_start + 255);
            END IF;
            EXIT WHEN l_end - l_start <= 0;
            l_buffer(l_index) := TRIM(CHR(10) FROM SUBSTR(a_line, l_start, l_end - l_start));
            l_index := l_index + 1;
            l_start := l_end + 1;
        END LOOP;
    END;

    PROCEDURE appendLine(
        a_line IN CLOB
    ) IS
        l_start  NUMBER := 1;
        l_end    NUMBER;
    BEGIN
        IF (a_line IS NULL) THEN
            l_buffer(l_index) := NULL;
            l_index := l_index + 1;
            RETURN;
        END IF;
        LOOP
            l_end := dbms_lob.InStr(a_line, CHR(10), l_start) + 1;
            IF (l_end <= 1) THEN
                l_end := LEAST(dbms_lob.GetLength(a_line) + 1, l_start + 255);
            END IF;
            EXIT WHEN l_end - l_start <= 0;
            l_buffer(l_index) := TRIM(CHR(10) FROM dbms_lob.substr(a_line, l_end - l_start, l_start));
            l_index := l_index + 1;
            l_start := l_end + 1;
        END LOOP;
    END;
BEGIN
    SELECT prev_sql_id, prev_child_number
    INTO l_sql_id, l_child_num
    FROM v$session
    WHERE sid = USERENV('SID');

    BEGIN
        SELECT sql_fulltext
        INTO l_sqltext
        FROM v$sqlarea
        WHERE sql_id = l_sql_id;
    EXCEPTION
    WHEN OTHERS THEN
        NULL;
    END;

    SELECT instance_name, host_name, version
    INTO l_instance, l_host, l_version
    FROM v$instance;
    
    FOR rule IN c_rules(
        :NEW.client_id,
        :NEW.applic,
        :NEW.who,
        :NEW.api_name,
        :NEW.error_msg
    ) LOOP
        UPDATE aterrormailrule
        SET
            times_triggered = CASE
                WHEN last_triggered + timeout < SYSDATE THEN 1
                ELSE NVL(times_triggered, 0) + 1
            END,
            last_triggered = SYSDATE
        WHERE ROWID = rule.ROWID
        RETURNING times_triggered - NVL(threshold, 0)
        INTO l_threshold;
        
        IF (l_threshold > 0) THEN
            l_buffer.DELETE;
            l_index := 1;

            l_recipients := rule.recipients;
            l_subject    := 'Unilab Error - ' || NVL(SUBSTR(rule.subject, 240), :NEW.api_name);
            
            appendLine('[Instance Info]');
            appendLine('Host:     ' || l_host);
            appendLine('Instance: ' || l_instance);
            appendLine('Version:  ' || l_version);
            appendLine('');
            appendLine('[Error Details]');
            appendLine('Logdate:  ' || TO_CHAR(:NEW.logdate, 'YYYY-MM-DD HH24:MI:SS'));
            appendLine('Machine:  ' || :NEW.client_id);
            appendLine('Username: ' || :NEW.who);
            appendLine('Module:   ' || :NEW.applic);
            appendLine('Source:   ' || :NEW.api_name);
            appendLine('');
            appendLine('[Error Message]');
            appendLine(:NEW.error_msg);
            appendLine('');
            appendLine('[Call Stack]');
            appendLine(dbms_utility.format_call_stack());
            appendLine('');
            appendLine('[Error Stack]');
            appendLine(dbms_utility.format_error_stack());
            appendLine('');
            appendLine('[Error Backtrace]');
            appendLine(dbms_utility.format_error_backtrace());
            appendLine('');
            appendLine('[Event Context]');
            appendLine('TR_SEQ     := ' || unapiev.p_ev_rec.tr_seq);
            appendLine('EV_SEQ     := ' || unapiev.p_ev_rec.ev_seq);
            appendLine('CREATED_ON := ' || TO_CHAR(unapiev.p_ev_rec.created_on, 'YYYY-MM-DD HH24:MI:SS'));
            appendLine('CLIENT_ID  := ' || unapiev.p_ev_rec.client_id);
            appendLine('APPLIC     := ' || unapiev.p_ev_rec.applic);
            appendLine('DBAPI_NAME := ' || unapiev.p_ev_rec.dbapi_name);
            appendLine('EVMGR_NAME := ' || unapiev.p_ev_rec.evmgr_name);
            appendLine('OBJECT_TP  := ' || unapiev.p_ev_rec.object_tp);
            appendLine('OBJECT_ID  := ' || unapiev.p_ev_rec.object_id);
            appendLine('OBJECT_LC  := ' || unapiev.p_ev_rec.object_lc);
            appendLine('OBJECT_LC_VERSION := ' || unapiev.p_ev_rec.object_lc_version);
            appendLine('OBJECT_SS  := ' || unapiev.p_ev_rec.object_ss);
            appendLine('EV_TP      := ' || unapiev.p_ev_rec.ev_tp);
            appendLine('USERNAME   := ' || unapiev.p_ev_rec.username);
            appendLine('EV_DETAILS := ' || unapiev.p_ev_rec.ev_details);
                  
            l_retval := unapiGen.SendMail(
                l_recipients,
                l_subject,
                l_buffer,
                l_index - 1
            );
        END IF;
    END LOOP;   
EXCEPTION
WHEN OTHERS THEN
    NULL;
END; 
/
ALTER TRIGGER "UNILAB"."TR_UTERROR_MAILRULE" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_UTEV_ARCHIVE
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "UNILAB"."TR_UTEV_ARCHIVE" 
AFTER INSERT ON utev 
FOR EACH ROW
DECLARE
    l_count  NUMBER;
    l_ignore NUMBER;
BEGIN
    
    SELECT COUNT(*), MAX(filt.ignore)
    INTO l_count, l_ignore
    FROM atevarchivefilter filt
    WHERE (:NEW.client_id  LIKE filt.client_id  OR filt.client_id  IS NULL)
      AND (:NEW.applic     LIKE filt.applic     OR filt.applic     IS NULL)
      AND (:NEW.dbapi_name LIKE filt.dbapi_name OR filt.dbapi_name IS NULL)
      AND (:NEW.evmgr_name LIKE filt.evmgr_name OR filt.evmgr_name IS NULL)
      AND (:NEW.object_tp  LIKE filt.object_tp  OR filt.object_tp  IS NULL)
      AND (:NEW.object_id  LIKE filt.object_id  OR filt.object_id  IS NULL)
      AND (:NEW.object_lc  LIKE filt.object_lc  OR filt.object_lc  IS NULL)
      AND (:NEW.object_ss  LIKE filt.object_ss  OR filt.object_ss  IS NULL)
      AND (:NEW.ev_tp      LIKE filt.ev_tp      OR filt.ev_tp      IS NULL)
      AND (:NEW.username   LIKE filt.username   OR filt.username   IS NULL)
      AND (:NEW.ev_details LIKE filt.ev_details OR filt.ev_details IS NULL)
      AND (:NEW.object_lc_version LIKE filt.object_lc_version OR filt.object_lc_version IS NULL)
    ;

    IF (l_count > 0 AND l_ignore = 0) THEN
        INSERT INTO atevarchive(
            tr_seq,
            ev_seq,
            created_on,
            client_id,
            applic,
            dbapi_name,
            evmgr_name,
            object_tp,
            object_id,
            object_lc,
            object_lc_version,
            object_ss,
            ev_tp,
            username,
            ev_details,
            created_on_tz
        )
        VALUES (
            :NEW.tr_seq,
            :NEW.ev_seq,
            :NEW.created_on,
            :NEW.client_id,
            :NEW.applic,
            :NEW.dbapi_name,
            :NEW.evmgr_name,
            :NEW.object_tp,
            :NEW.object_id,
            :NEW.object_lc,
            :NEW.object_lc_version,
            :NEW.object_ss,
            :NEW.ev_tp,
            :NEW.username,
            :NEW.ev_details,
            :NEW.created_on_tz
        );
    END IF;
END tr_utev_archive;
/
ALTER TRIGGER "UNILAB"."TR_UTEV_ARCHIVE" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRAO_UTEVLOG_DELETE
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "UNILAB"."TRAO_UTEVLOG_DELETE" 
AFTER DELETE ON
	unilab.utev
REFERENCING
	NEW AS NEW
	OLD AS Old
FOR EACH ROW
DECLARE
BEGIN
	UPDATE
		atevlog
	SET
		end_date = CURRENT_TIMESTAMP
	WHERE
		tr_seq = :OLD.tr_seq
		AND ev_seq = :OLD.ev_seq
    AND end_date IS NULL;
EXCEPTION
WHEN OTHERS THEN
  unapiGen.LogError('ATEVLOG', 'Error in trigger trao_utevlog_delete, TR' || :OLD.tr_seq || ':EV' || :OLD.ev_seq || ': ' || SQLERRM);
END trao_utevlog_delete;

/
ALTER TRIGGER "UNILAB"."TRAO_UTEVLOG_DELETE" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRAO_UTEVLOG_INSERT
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "UNILAB"."TRAO_UTEVLOG_INSERT" 
AFTER INSERT ON
	unilab.utev
REFERENCING
	NEW AS NEW
	OLD AS Old
FOR EACH ROW
DECLARE
BEGIN
	INSERT INTO
		unilab.atevlog(
			start_date,
			tr_seq,
			ev_seq,
			created_on,
			client_id,
			applic,
			dbapi_name,
			evmgr_name,
			object_tp,
			object_id,
			object_lc,
			object_lc_version,
			object_ss,
			ev_tp,
			username,
			ev_details,
			created_on_tz
		)
	VALUES (
		CURRENT_TIMESTAMP,
		:NEW.tr_seq,
		:NEW.ev_seq,
		:NEW.created_on,
		:NEW.client_id,
		:NEW.applic,
		:NEW.dbapi_name,
		:NEW.evmgr_name,
		:NEW.object_tp,
		:NEW.object_id,
		:NEW.object_lc,
		:NEW.object_lc_version,
		:NEW.object_ss,
		:NEW.ev_tp,
		:NEW.username,
		:NEW.ev_details,
		:NEW.created_on_tz
	);
EXCEPTION
WHEN OTHERS THEN
  unapiGen.LogError('ATEVLOG', 'Error in trigger trao_utevlog_insert, TR' || :NEW.tr_seq || ':EV' || :NEW.ev_seq || ': ' || SQLERRM);
END trao_utevlog_insert;

/
ALTER TRIGGER "UNILAB"."TRAO_UTEVLOG_INSERT" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRAO_UTEVLOG_UPDATE
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "UNILAB"."TRAO_UTEVLOG_UPDATE" 
AFTER UPDATE ON
	unilab.utev
REFERENCING
	NEW AS NEW
	OLD AS Old
FOR EACH ROW
DECLARE
BEGIN
  IF :NEW.evmgr_name = '1' THEN
    UPDATE
      atevlog
    SET
      update_date = CURRENT_TIMESTAMP
    WHERE
      tr_seq = :OLD.tr_seq
      AND ev_seq = :OLD.ev_seq
      AND update_date IS NULL
      AND end_date IS NULL;
  END IF;
EXCEPTION
WHEN OTHERS THEN
  unapiGen.LogError('ATEVLOG', 'Error in trigger trao_utevlog_update, TR' || :NEW.tr_seq || ':EV' || :NEW.ev_seq || ': ' || SQLERRM);
END trao_utevlog_delete;

/
ALTER TRIGGER "UNILAB"."TRAO_UTEVLOG_UPDATE" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRAO_UTPPPR
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "UNILAB"."TRAO_UTPPPR" 
AFTER UPDATE
ON UTPPPR
REFERENCING NEW AS NEW OLD AS Old
FOR EACH ROW
DECLARE

BEGIN

   INSERT INTO ATAO_UTPPPR (
   PP, VERSION, PP_KEY1, 
   PP_KEY2, PP_KEY3, PP_KEY4, 
   PP_KEY5, PR, PR_VERSION, 
   SEQ, NR_MEASUR, UNIT, 
   FORMAT, DELAY, DELAY_UNIT, 
   ALLOW_ADD, IS_PP, FREQ_TP, 
   FREQ_VAL, FREQ_UNIT, INVERT_FREQ, 
   ST_BASED_FREQ, LAST_SCHED, LAST_CNT, 
   LAST_VAL, INHERIT_AU, MT, 
   MT_VERSION, MT_NR_MEASUR, LAST_SCHED_TZ, 
   LOGDATE) 
VALUES ( :NEW.PP ,
 :NEW.VERSION ,
 :NEW.PP_KEY1 ,
 :NEW.PP_KEY2 ,
 :NEW.PP_KEY3 ,
 :NEW.PP_KEY4 ,
 :NEW.PP_KEY5 ,
 :NEW.PR ,
 :NEW.PR_VERSION ,
 :NEW.SEQ ,
 :NEW.NR_MEASUR ,
 :NEW.UNIT ,
 :NEW.FORMAT ,
 :NEW.DELAY ,
 :NEW.DELAY_UNIT ,
 :NEW.ALLOW_ADD ,
 :NEW.IS_PP ,
 :NEW.FREQ_TP ,
 :NEW.FREQ_VAL ,
 :NEW.FREQ_UNIT ,
 :NEW.INVERT_FREQ ,
 :NEW.ST_BASED_FREQ ,
 :NEW.LAST_SCHED ,
 :NEW.LAST_CNT ,
 :NEW.LAST_VAL ,
 :NEW.INHERIT_AU ,
 :NEW.MT ,
 :NEW.MT_VERSION ,
 :NEW.MT_NR_MEASUR ,
 :NEW.LAST_SCHED_TZ ,
 CURRENT_TIMESTAMP );
 
   EXCEPTION
     WHEN OTHERS THEN
       -- Consider logging the error and then re-raise
       RAISE;
END TRAO_UTPPPR;

/
ALTER TRIGGER "UNILAB"."TRAO_UTPPPR" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRAO_UTSTPP
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "UNILAB"."TRAO_UTSTPP" 
AFTER UPDATE
ON UTSTPP
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
DECLARE

BEGIN

   INSERT INTO ATAO_UTSTPP (
   ST, VERSION, PP, 
   PP_VERSION, PP_KEY1, PP_KEY2, 
   PP_KEY3, PP_KEY4, PP_KEY5, 
   SEQ, FREQ_TP, FREQ_VAL, 
   FREQ_UNIT, INVERT_FREQ, LAST_SCHED, 
   LAST_CNT, LAST_VAL, INHERIT_AU, 
   LAST_SCHED_TZ, LOGDATE) 
VALUES ( :NEW.ST ,
 :NEW.VERSION ,
 :NEW.PP ,
 :NEW.PP_VERSION ,
 :NEW.PP_KEY1 ,
 :NEW.PP_KEY2 ,
 :NEW.PP_KEY3 ,
 :NEW.PP_KEY4 ,
 :NEW.PP_KEY5 ,
 :NEW.SEQ ,
 :NEW.FREQ_TP ,
 :NEW.FREQ_VAL ,
 :NEW.FREQ_UNIT ,
 :NEW.INVERT_FREQ ,
 :NEW.LAST_SCHED ,
 :NEW.LAST_CNT ,
 :NEW.LAST_VAL ,
 :NEW.INHERIT_AU ,
 :NEW.LAST_SCHED_TZ ,
 SYSDATE);

   EXCEPTION
     WHEN OTHERS THEN
       -- Consider logging the error and then re-raise
       RAISE;
END TRAO_UTSTPP;

/
ALTER TRIGGER "UNILAB"."TRAO_UTSTPP" ENABLE;
--------------------------------------------------------
--  DDL for Trigger UT_ERROR_BRI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "UNILAB"."UT_ERROR_BRI" 
BEFORE INSERT
ON UNILAB.UTERROR 
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
BEGIN
--  if :new.error_msg like '%ORA-0%' then
      add_debug
        (p_table => 'UTERROR'
        ,p_message => :new.error_msg
        ,p_sc => null
        ,p_pg => null
        ,p_pgnode => null
        ,p_pa => null
        ,p_panode => null
        ,p_me => null
        ,p_menode => null
        ,p_ss_from => null
        ,p_ss_to => null);
--    end if;
END;
/
ALTER TRIGGER "UNILAB"."UT_ERROR_BRI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger UTASSIGNFULLTESTPLAN_TRG
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "UNILAB"."UTASSIGNFULLTESTPLAN_TRG" 
  before insert
  on unilab.utassignfulltestplan 
  referencing new as new old as old
  for each row
  declare
  r_rec utassignfulltestplan_tmp%rowtype;
begin
  if user = 'LimsAdministrator'
  then
    r_rec.object_tp            := :new.object_tp;
    r_rec.object_id            := :new.object_id;
    r_rec.object_version       := :new.object_version;
    r_rec.tst_tp               := :new.tst_tp;
    r_rec.tst_id               := :new.tst_id;
    r_rec.tst_id_version       := :new.tst_id_version;
    r_rec.tst_description      := :new.tst_description;
    r_rec.tst_nr_measur        := :new.tst_nr_measur;
    r_rec.pp                   := :new.pp;
    r_rec.pp_version           := :new.pp_version;
    r_rec.pp_key1              := :new.pp_key1;
    r_rec.pp_key2              := :new.pp_key2;
    r_rec.pp_key3              := :new.pp_key3;
    r_rec.pp_key4              := :new.pp_key4;
    r_rec.pp_key5              := :new.pp_key5;
    r_rec.pp_seq               := :new.pp_seq;
    r_rec.pr                   := :new.pr;
    r_rec.pr_version           := :new.pr_version;
    r_rec.pr_seq               := :new.pr_seq;
    r_rec.mt                   := :new.mt;
    r_rec.mt_version           := :new.mt_version;
    r_rec.mt_seq               := :new.mt_seq;
    r_rec.confirm_assign       := :new.confirm_assign;
    r_rec.is_pp_in_pp          := :new.is_pp_in_pp;
    r_rec.already_assigned     := :new.already_assigned;
    r_rec.never_create_methods := :new.never_create_methods;
    --
    r_rec.time_stamp           := sysdate;
    r_rec.dd                   := unapigen.p_dd;
    --
    unlog.test_plan
      (p_rec => r_rec);
   end if;
end;
/
ALTER TRIGGER "UNILAB"."UTASSIGNFULLTESTPLAN_TRG" ENABLE;
--------------------------------------------------------
--  DDL for Trigger UTSC_TRG_BRU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "UNILAB"."UTSC_TRG_BRU" 
BEFORE UPDATE
ON UNILAB.UTSC REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
BEGIN
   add_debug
     (p_table => 'UTSC'
     ,p_sc => :new.sc
     ,p_ss_from => :old.ss
     ,p_ss_to => :new.ss);
END;
/
ALTER TRIGGER "UNILAB"."UTSC_TRG_BRU" DISABLE;
--------------------------------------------------------
--  DDL for Trigger UTSCME_TRG_BRU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "UNILAB"."UTSCME_TRG_BRU" 
BEFORE UPDATE
ON UNILAB.UTSCME 
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
BEGIN
   add_debug
     (p_table => 'UTSCME'
     ,p_sc => :new.sc
     ,p_pg => :new.pg
     ,p_pgnode => :new.pgnode
     ,p_pa => :new.pa
     ,p_panode => :new.panode
     ,p_me => :new.me
     ,p_menode => :new.menode
     ,p_ss_from => :old.ss
     ,p_ss_to => :new.ss);
END;
/
ALTER TRIGGER "UNILAB"."UTSCME_TRG_BRU" DISABLE;
--------------------------------------------------------
--  DDL for Trigger UTSCPA_TRG_BRU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "UNILAB"."UTSCPA_TRG_BRU" 
BEFORE UPDATE
ON UNILAB.UTSCPA 
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
BEGIN
   add_debug
     (p_table => 'UTSCPA'
     ,p_sc => :new.sc
     ,p_pg => :new.pg
     ,p_pgnode => :new.pgnode
     ,p_pa => :new.pa
     ,p_panode => :new.panode
     ,p_ss_from => :old.ss
     ,p_ss_to => :new.ss);
END;
/
ALTER TRIGGER "UNILAB"."UTSCPA_TRG_BRU" DISABLE;

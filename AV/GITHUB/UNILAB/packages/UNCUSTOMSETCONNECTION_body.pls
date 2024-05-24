create or replace PACKAGE BODY
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
uncustomsetconnection AS

l_sql_string          VARCHAR2(1000);
l_result              NUMBER;
l_ret_code            NUMBER;
StpError              EXCEPTION;
l_sqlerrm             VARCHAR2(255);

FUNCTION GetVersion
   RETURN VARCHAR2
IS
BEGIN
   RETURN('06.07.00.00_00.13');
EXCEPTION
   WHEN OTHERS THEN
      RETURN (NULL);
END GetVersion;

--internal function for tracing/logging in autonomous transaction
PROCEDURE TraceError
(a_api_name     IN        VARCHAR2,    /* VC40_TYPE */
 a_error_msg    IN        VARCHAR2)    /* VC255_TYPE */
IS
PRAGMA AUTONOMOUS_TRANSACTION;

BEGIN
   --autonomous transaction used here
   --UNAPIGEN.LogError is also an autonomous transaction but may rollback the current transaction
   INSERT INTO uterror(client_id, applic, who, logdate, logdate_tz, api_name, error_msg)
   VALUES (UNAPIGEN.P_CLIENT_ID, SUBSTR(UNAPIGEN.P_APPLIC_NAME,1,8), NVL(UNAPIGEN.P_USER,USER), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
           SUBSTR(a_api_name,1,40), SUBSTR(a_error_msg,1,255));
   COMMIT;
END TraceError;

--This api function is called by all standard client application after the SetConnection API
--The value passed should be taken from a configuration file or the registry
--Read the client documentation for the exact location of that value
FUNCTION SetCustomConnectionParameter
(a_CustomconnectionParameter         IN VARCHAR2)    /* VC2000_TYPE */
RETURN NUMBER IS

l_sys_cursor          INTEGER;

l_recipient           VARCHAR2(255);
l_subject             VARCHAR2(255);
l_text_tab            UNAPIGEN.VC255_TABLE_TYPE;
l_nr_of_rows          NUMBER;
l_user_desc           VARCHAR2(40);
l_db                  VARCHAR2(40);

CURSOR c_system (a_setting_name VARCHAR2) IS
   SELECT setting_value
   FROM utsystem
   WHERE setting_name = a_setting_name;

BEGIN

   --a good illustartion of what can be done when the passed value is
   --containing TRACE=1 or TRACEFULL=1 the sql tracing is started
   --This is replacing the former extension of the ClientId with TRACE
   l_sys_cursor := DBMS_SQL.OPEN_CURSOR;

   IF INSTR(a_CustomconnectionParameter,'TRACE=1') <> 0 THEN
      l_sql_string := 'ALTER SESSION SET SQL_TRACE = TRUE';
      DBMS_SQL.PARSE(l_sys_cursor, l_sql_string, DBMS_SQL.V7);
      l_result := DBMS_SQL.EXECUTE(l_sys_cursor);
   END IF;

   IF INSTR(a_CustomconnectionParameter,'TRACEFULL=1') <> 0 THEN
      l_sql_string := 'ALTER SESSION SET SQL_TRACE = TRUE';
      DBMS_SQL.PARSE(l_sys_cursor, l_sql_string, DBMS_SQL.V7);
      l_result := DBMS_SQL.EXECUTE(l_sys_cursor);

      l_sql_string := 'ALTER SESSION SET EVENTS=''10046 TRACE NAME CONTEXT FOREVER, LEVEL 4''';
      DBMS_SQL.PARSE(l_sys_cursor, l_sql_string, DBMS_SQL.V7); -- NO single quote handling required
      l_result := DBMS_SQL.EXECUTE(l_sys_cursor);
   END IF;
   DBMS_SQL.CLOSE_CURSOR(l_sys_cursor);


   --a second illustartion of what can be done when the passed value is
   --containing SENDMAILONCONNECT=1 an email is sent to the connecting user
   IF INSTR(a_CustomconnectionParameter,'SENDMAILONCONNECT=1') <> 0 THEN

      BEGIN
         SELECT email
         INTO l_recipient
         FROM utad
         WHERE ad = UNAPIGEN.P_USER AND email IS NOT NULL;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         OPEN c_system ('DBA_EMAILADDRESS');
         FETCH c_system INTO l_recipient;
         IF c_system%NOTFOUND THEN
            CLOSE c_system;
            l_sqlerrm := 'System setting DBA_EMAILADDRESS is missing';
            RAISE StpError;
         END IF;
         CLOSE c_system;
      END;

      -- fetch description of user id
      l_user_desc := UNAPIGEN.P_USER_DESCRIPTION;

      BEGIN
         -- fetch database name
         SELECT global_name
         INTO l_db
         FROM global_name;

      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         l_sqlerrm := 'The following setting is missing: global_name.global_name';
         RAISE StpError;
      END;

      l_subject := 'User connected on the system with SENDMAIL=1 in its registry for the custom Unilab setting ...';
      l_text_tab(1)  := '   user        = '||l_user_desc;
      l_text_tab(2)  := '   application = '||UNAPIGEN.P_APPLIC_NAME;
      l_text_tab(3)  := '   database    = '||l_db;
      l_text_tab(4)  := ' at '||TO_CHAR(CURRENT_TIMESTAMP, 'DD/MM/RRRR HH24:MI:SS')||'.';
      l_text_tab(5)  := '';
      l_text_tab(6)  := 'value of registry passed:'||SUBSTR(a_CustomconnectionParameter,1,100);
      l_text_tab(7)  := '__________________________________________________________';
      l_text_tab(8)  := 'Please do not reply to this mail, as it has been generated';
      l_text_tab(9)  := 'automatically by the LIMS.';
      l_nr_of_rows := 9;
      l_ret_code := UNAPIGEN.SendMail(l_recipient, l_subject, l_text_tab, l_nr_of_rows);
      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
         l_sqlerrm := 'No mail has been sent.';
         RAISE StpError;
      END IF;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
WHEN OTHERS THEN
   TraceError('SetCustomConnectionParameter', 'Oracle error='||SUBSTR(SQLERRM,1,240));
   TraceError('SetCustomConnectionParameter', 'While performing statement'||SUBSTR(l_sql_string,1,200));
   IF DBMS_SQL.IS_OPEN(l_sys_cursor) THEN
      DBMS_SQL.CLOSE_CURSOR(l_sys_cursor);
   END IF;
   IF c_system%ISOPEN THEN
      CLOSE c_system;
   END IF;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END SetCustomConnectionParameter;

END uncustomsetconnection;
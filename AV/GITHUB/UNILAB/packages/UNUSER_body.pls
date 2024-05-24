create or replace PACKAGE BODY
-- SIMATIC IT UNILAB package
-- $Revision: 6.4.0 (V06.04.00.00_24.01) $
-- $Date: 2009-04-20T16:24:00 $
unuser AS

l_sqlerrm         VARCHAR2(255);
l_sql_string      VARCHAR2(2000);
l_where_clause    VARCHAR2(1000);
l_event_tp        utev.ev_tp%TYPE;
l_ev_details      VARCHAR2(255);
l_ret_code        NUMBER;
l_result          NUMBER;
l_fetched_rows    NUMBER;
l_ev_seq_nr       NUMBER;
StpError          EXCEPTION;

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

--PUBLIC functions
FUNCTION GetDefaultPassword                                 /* INTERNAL */
(a_us            IN   VARCHAR2,                             /* VC4_TYPE */
 a_password      OUT  VARCHAR2)                             /* VC20_TYPE */
RETURN NUMBER IS

l_us7ascii_string         VARCHAR2(30);
l_us_email                VARCHAR2(255);
l_dba_email               VARCHAR2(255);

--local variables for SendMail
l_recipient_email         VARCHAR2(255);
l_creator_email           VARCHAR2(255);
l_subject                 VARCHAR2(255);
l_text_tab                UNAPIGEN.VC255_TABLE_TYPE;
l_nr_of_rows              NUMBER;

BEGIN

   --This function should return a password of maximum 30 characters (limit set by Oracle)
   --It may be customised to send an e-mail to the appropriated persons (using the entry in utad where ad=a_us)

   --The default implementation may return the password=username for backward compatibility
   --But is not acceptable for many projects

   --Default implementation will generate a password
   --PAY ATTENTION that the generated password may only contain single-byte characters
   --(this function is NOT called when defining external or global users
   -- external or global users must be used if you want unicode characters in passwords
   l_us7ascii_string := SUBSTR(ASCIISTR(a_us),1,30);
   --password contains a special character and a number
   a_password := '1!';
   FOR l_position IN 1..LENGTH(l_us7ascii_string) LOOP
      --take all characters in a odd position
      IF MOD(l_position,2)=1 THEN
         a_password := a_password || SUBSTR(l_us7ascii_string,l_position,1);
      END IF;
   END LOOP;

   --add some random characters when length is smaller than 10 characters
   IF LENGTH(a_password) < 10 THEN
      DBMS_RANDOM.INITIALIZE(DBMS_UTILITY.GET_TIME );
      a_password := a_password||LTRIM(TO_CHAR(ABS(MOD(DBMS_RANDOM.RANDOM,9999999)), 'XXXXXXX'));
   END IF;
   --maximum of 20 characters
   IF LENGTH(a_password) > 20 THEN
      a_password := SUBSTR(a_password, 1, 20);
   END IF;

   --Add systematically an e-mail to the e-mail address of the dba_user and to the e-mail address
   l_subject := 'User account created for Unilab user "'||a_us||'"';

   l_text_tab(1) := 'An Oracle user account has been created for the Unilab user "'||a_us||'"';
   l_text_tab(2) := 'with the temporary password "'||a_password||'"';
   l_text_tab(3) := 'That password is temporary, Unilab(Oracle) will prompt you to enter a new password the first time you log in';
   l_nr_of_rows := 3;

   BEGIN
      SELECT email
      INTO l_us_email
      FROM utad
      WHERE ad= a_us;
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
      NULL;
   END;

   BEGIN
      SELECT email
      INTO l_dba_email
      FROM utad
      WHERE ad= (SELECT setting_value FROM utsystem WHERE setting_name = 'DBA_NAME');
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
      NULL;
   END;

   IF l_us_email IS NOT NULL THEN
      l_recipient_email := l_us_email;
   END IF;
   IF l_dba_email IS NOT NULL THEN
      IF l_recipient_email IS NOT NULL THEN
         l_recipient_email := l_recipient_email || ';' || l_dba_email;
      ELSE
         l_recipient_email := l_dba_email;
      END IF;
   END IF;

   IF l_recipient_email IS NOT NULL THEN
      l_ret_code := UNAPIGEN.SendMail(a_recipient  => l_recipient_email,
                                      a_subject    => l_subject,
                                      a_text_tab   => l_text_tab,
                                      a_nr_of_rows => l_nr_of_rows);
      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         TraceError('UNUSER.GetDefaultPassword', 'SendMail failed for '||l_us_email);
      END IF;
   END IF;

   --Add an entry in uterror to be suer that the temporary password is not lost
   --e-mail sending can fail for many reasons
   TraceError('UNUSER.GetDefaultPassword', 'Info(not a problem): user created with a temporary password user="'||a_us||'",  "'||a_password||'"');

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   TraceError('UNUSER.GetDefaultPassword', 'Failed to create user temporary password for user "'||a_us);
   TraceError('UNUSER.GetDefaultPassword', SUBSTR(SQLERRM,1,200));
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END GetDefaultPassword;

FUNCTION ResetPassword                                 /* INTERNAL */
(a_us            IN   VARCHAR2,                             /* VC20_TYPE */
 a_password      IN   VARCHAR2)                             /* VC20_TYPE */
RETURN NUMBER IS

l_us7ascii_string         VARCHAR2(30);
l_us_email                VARCHAR2(255);
l_dba_email               VARCHAR2(255);

--local variables for SendMail
l_recipient_email         VARCHAR2(255);
l_creator_email           VARCHAR2(255);
l_subject                 VARCHAR2(255);
l_text_tab                Unapigen.VC255_TABLE_TYPE;
l_nr_of_rows              NUMBER;
l_password varchar2(100);

BEGIN
--   a_password := a_us ;
--   TraceError('UNUSER.ResetPassword', 'Info(not a problem): user created with a temporary password user="'||a_us||'",  "'||a_password||'"');

   IF (nvl(a_password, 'x') = 'x') THEN -- Password must be generated
      l_us7ascii_string := SUBSTR(ASCIISTR(a_us),1,30);
      --password contains a special character and a number
      l_password := '1!';
      FOR l_position IN 1..LENGTH(l_us7ascii_string) LOOP
         --take all characters in a odd position
         IF MOD(l_position,2)=1 THEN
            l_password := l_password || SUBSTR(l_us7ascii_string,l_position,1);
         END IF;
      END LOOP;

      --add some random characters when length is smaller than 10 characters
      IF LENGTH(l_password) < 10 THEN
         DBMS_RANDOM.INITIALIZE(DBMS_UTILITY.GET_TIME );
         l_password := l_password||LTRIM(TO_CHAR(ABS(MOD(DBMS_RANDOM.RANDOM,9999999)), 'XXXXXXX'));
      END IF;
      --maximum of 20 characters
      IF LENGTH(l_password) > 20 THEN
         l_password := SUBSTR(l_password, 1, 20);
      END IF;
   ELSE
      l_password := a_password ;
   END IF ;

   l_sql_string := 'ALTER USER "' || a_us || '" IDENTIFIED BY "' || l_password || '" ' ;
   EXECUTE IMMEDIATE l_sql_string ;

   l_sql_string := 'ALTER USER  "' || a_us || '" PASSWORD EXPIRE';
   EXECUTE IMMEDIATE l_sql_string ;

   --Add systematically an e-mail to the e-mail address of the dba_user and to the e-mail address
   l_subject := 'Password reset for Unilab user "'||a_us||'"';

   l_text_tab(1) := 'The password has been reset for the Unilab user "'||a_us||'"';
   l_text_tab(2) := 'with the temporary password "'||l_password||'"';
   l_text_tab(3) := 'That password is temporary, Unilab(Oracle) will prompt you to enter a new password the first time you log in';
   l_nr_of_rows := 3;

   BEGIN
      SELECT email
      INTO l_us_email
      FROM utad
      WHERE ad= a_us;
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
      NULL;
   END;

   BEGIN
      SELECT email
      INTO l_dba_email
      FROM utad
      WHERE ad= (SELECT setting_value FROM utsystem WHERE setting_name = 'DBA_NAME');
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
      NULL;
   END;

   IF l_us_email IS NOT NULL THEN
      l_recipient_email := l_us_email;
   END IF;
   IF l_dba_email IS NOT NULL THEN
      IF l_recipient_email IS NOT NULL THEN
         l_recipient_email := l_recipient_email || ';' || l_dba_email;
      ELSE
         l_recipient_email := l_dba_email;
      END IF;
   END IF;

   IF l_recipient_email IS NOT NULL THEN
      l_ret_code := Unapigen.SendMail(a_recipient  => l_recipient_email,
                                      a_subject    => l_subject,
                                      a_text_tab   => l_text_tab,
                                      a_nr_of_rows => l_nr_of_rows);
      IF l_ret_code <> Unapigen.DBERR_SUCCESS THEN
         TraceError('UNUSER.ResetPassword', 'SendMail failed for '||l_us_email);
      END IF;
   END IF;

   --Add an entry in uterror to be suer that the temporary password is not lost
   --e-mail sending can fail for many reasons
   TraceError('UNUSER.ResetPassword', 'Info(not a problem): password reset with a temporary password user="'||a_us||'",  "'||l_password||'"');

   RETURN(Unapigen.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   TraceError('UNUSER.ResetPassword', 'Failed to reset password for user "'||a_us);
   TraceError('UNUSER.ResetPassword', SUBSTR(SQLERRM,1,200));
   RETURN(Unapigen.DBERR_GENFAIL);
END ResetPassword;

END unuser;
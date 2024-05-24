create or replace PACKAGE BODY
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
uniconnect7 AS

l_sqlerrm         VARCHAR2(255);
l_sql_string      VARCHAR2(2000);
l_where_clause    VARCHAR2(1000);
l_event_tp        utev.ev_tp%TYPE;
l_timed_event_tp  utevtimed.ev_tp%TYPE;
l_ret_code        NUMBER;
l_result          NUMBER;
l_return          INTEGER;
l_fetched_rows    NUMBER;
StpError          EXCEPTION;

FUNCTION GetVersion
   RETURN VARCHAR2
IS
BEGIN
   RETURN('06.07.00.00_00.13');
EXCEPTION
   WHEN OTHERS THEN
      RETURN (NULL);
END GetVersion;

/*--------------------------------------------------------------*/
/* procedures and functions related to the [switchuser] section */
/*--------------------------------------------------------------*/
PROCEDURE UCON_InitialiseSwitchUsSection     /* INTERNAL */
IS
BEGIN

   --local variables initialisation
   --all variables are set in a way that current settings will not be modified
   --when not mofified within the section
   UNICONNECT.P_SU_CLIENT_ID             := UNAPIGEN.P_CLIENT_ID;
   UNICONNECT.P_SU_US                    := UNAPIGEN.P_USER;
   UNICONNECT.P_SU_PASSWORD              := NULL;
   UNICONNECT.P_SU_APPLIC                := UNAPIGEN.P_APPLIC_NAME;
   UNICONNECT.P_SU_NUMERIC_CHARACTERS    := 'DB';     --do not change actual settings
   UNICONNECT.P_SU_DATE_FORMAT           := 'SERVER'; --do not change actual settings
   UNICONNECT.P_SU_UP                    := NULL;

END UCON_InitialiseSwitchUsSection;

FUNCTION UCON_AssignSwitchUsSectionRow       /* INTERNAL */
RETURN NUMBER IS

BEGIN

   --Important assumption : one [switchuser] section is only related to one user
   UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NONE,'      Assigning value of variable '||UNICONNECT.P_VARIABLE_NAME||' in [switchuser] section');
   IF UNICONNECT.P_VARIABLE_NAME = 'client_id' THEN
      UNICONNECT.P_SU_CLIENT_ID := UNICONNECT.P_VARIABLE_VALUE;

   ELSIF UNICONNECT.P_VARIABLE_NAME = 'us' THEN
      UNICONNECT.P_SU_US := UNICONNECT.P_VARIABLE_VALUE;

   ELSIF UNICONNECT.P_VARIABLE_NAME = 'password' THEN
      UNICONNECT.P_SU_PASSWORD := UNICONNECT.P_VARIABLE_VALUE;

   ELSIF UNICONNECT.P_VARIABLE_NAME = 'applic' THEN
      UNICONNECT.P_SU_APPLIC := UNICONNECT.P_VARIABLE_VALUE;

   ELSIF UNICONNECT.P_VARIABLE_NAME = 'numeric_characters' THEN
      UNICONNECT.P_SU_NUMERIC_CHARACTERS := UNICONNECT.P_VARIABLE_VALUE;

   ELSIF UNICONNECT.P_VARIABLE_NAME = 'date_format' THEN
      UNICONNECT.P_SU_DATE_FORMAT := UNICONNECT.P_VARIABLE_VALUE;

   ELSIF UNICONNECT.P_VARIABLE_NAME = 'up' THEN
      UNICONNECT.P_SU_UP := UNICONNECT.P_VARIABLE_VALUE;

   ELSE
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_HIGH,'      Invalid variable '||UNICONNECT.P_VARIABLE_NAME||' in [switchuser] section');
      RETURN(UNAPIGEN.DBERR_INVALIDVARIABLE);
   END IF;
   RETURN(UNAPIGEN.DBERR_SUCCESS);

END UCON_AssignSwitchUsSectionRow;

FUNCTION UCON_ExecuteSwitchUsSection         /* INTERNAL */
RETURN NUMBER IS

l_temp_up_description             VARCHAR2(40);
l_temp_language                   VARCHAR2(20);
l_temp_tk                         VARCHAR2(20);

BEGIN

   l_ret_code := UNAPIGEN.DBERR_SUCCESS;
   --1. us validation
   IF UNICONNECT.P_SU_US IS NULL THEN
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : us is mandatory for [switchuser] section !');
      l_ret_code := UNAPIGEN.DBERR_US;
      RAISE StpError;
   END IF;

   --2. Keep the job user context to be able to restore it once the file has been processed
   --   for a correct processing of the next files
   IF NOT UNICONNECT.P_SU_USER_SWITCHED THEN
      UNICONNECT.P_SU_USER_SWITCHED := TRUE;

      UNICONNECT.P_SU_JOB_CLIENT_ID        := UNAPIGEN.P_CLIENT_ID;
      UNICONNECT.P_SU_JOB_US               := UNAPIGEN.P_USER;
      UNICONNECT.P_SU_JOB_USER_DESCRIPTION := UNAPIGEN.P_USER_DESCRIPTION;
      UNICONNECT.P_SU_JOB_PASSWORD         := NULL;
      UNICONNECT.P_SU_JOB_APPLIC           := UNAPIGEN.P_APPLIC_NAME;
      UNICONNECT.P_SU_JOB_UP               := UNAPIGEN.P_CURRENT_UP;
      UNICONNECT.P_SU_JOB_DD               := UNAPIGEN.P_DD;

      SELECT SUBSTR (value,1,2)
      INTO UNICONNECT.P_SU_JOB_NUMERIC_CHARACTERS
      FROM v$nls_parameters
      WHERE parameter='NLS_NUMERIC_CHARACTERS';

      SELECT value
      INTO UNICONNECT.P_SU_JOB_DATE_FORMAT
      FROM v$nls_parameters
      WHERE parameter='NLS_DATE_FORMAT';
   END IF;

   --3. Call SwitchUser function
   UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Calling SwitchUser for :');
   UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'            client_id:'||UNICONNECT.P_SU_CLIENT_ID);
   UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'            us:'||UNICONNECT.P_SU_US);
   --UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'            password:'||UNICONNECT.P_SU_PASSWORD);
   UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'            applic:'||UNICONNECT.P_SU_APPLIC);
   UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'            decimal characters:'||UNICONNECT.P_SU_NUMERIC_CHARACTERS);
   UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'            date format:'||UNICONNECT.P_SU_DATE_FORMAT);
   UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'            up:'||UNICONNECT.P_SU_UP);

   l_ret_code := Unapigen.SwitchUser(UNICONNECT.P_SU_CLIENT_ID,
                                     UNICONNECT.P_SU_US,
                                     UNICONNECT.P_SU_PASSWORD,
                                     UNICONNECT.P_SU_APPLIC,
                                     UNICONNECT.P_SU_NUMERIC_CHARACTERS,
                                     UNICONNECT.P_SU_DATE_FORMAT,
                                     UNICONNECT.P_SU_UP,
                                     l_temp_up_description,
                                     l_temp_language,
                                     l_temp_language);

   IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : SwitchUser ret_code='||l_ret_code);
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Calling SwitchUser for :');
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'            client_id:'||UNICONNECT.P_SU_CLIENT_ID);
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'            us:'||UNICONNECT.P_SU_US);
      --UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'            password:'||UNICONNECT.P_SU_PASSWORD);
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'            applic:'||UNICONNECT.P_SU_APPLIC);
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'            decimal characters:'||UNICONNECT.P_SU_NUMERIC_CHARACTERS);
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'            date format:'||UNICONNECT.P_SU_DATE_FORMAT);
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'            up:'||UNICONNECT.P_SU_UP);
      RAISE StpError;
   ELSE
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         SwitchUser successful');
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
WHEN OTHERS THEN
   --an exception can have been raised with l_ret_code = UNAPIGEN.DBERR_SUCCESS
   --this is done to skip the section without interrupting the file parsing
   IF sqlcode <> 1 THEN
      --the exception is not a user exception
      l_sqlerrm := SUBSTR(SQLERRM, 1, 200);
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Following exception catched in UCON_ExecuteSwitchUsSection :');
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         '||l_sqlerrm);
      l_ret_code := UNAPIGEN.DBERR_GENFAIL;
   END IF;
   UNAPIGEN.P_TXN_ERROR := l_ret_code;
   RETURN(l_ret_code);
END UCON_ExecuteSwitchUsSection;

FUNCTION UCON_RestoreJobUserContext          /* INTERNAL */
RETURN NUMBER IS

l_temp_up_description             VARCHAR2(40);
l_temp_language                   VARCHAR2(20);
l_temp_tk                         VARCHAR2(20);

BEGIN

   l_ret_code := UNAPIGEN.DBERR_SUCCESS;

   --Restore the job user context when it has been switched
   IF UNICONNECT.P_SU_USER_SWITCHED THEN

      UNICONNECT.P_SU_CLIENT_ID           := UNICONNECT.P_SU_JOB_CLIENT_ID;
      UNICONNECT.P_SU_US                  := UNICONNECT.P_SU_JOB_US;
      UNICONNECT.P_SU_PASSWORD            := NULL;
      UNICONNECT.P_SU_APPLIC              := UNICONNECT.P_SU_JOB_APPLIC;
      UNICONNECT.P_SU_NUMERIC_CHARACTERS  := UNICONNECT.P_SU_JOB_NUMERIC_CHARACTERS;
      UNICONNECT.P_SU_DATE_FORMAT         := UNICONNECT.P_SU_JOB_DATE_FORMAT;
      UNICONNECT.P_SU_UP                  := UNICONNECT.P_SU_JOB_UP;

      --Call SwitchUser function
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Calling SwitchUser for :');
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'            client_id:'||UNICONNECT.P_SU_CLIENT_ID);
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'            us:'||UNICONNECT.P_SU_US);
      --UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'            password:'||UNICONNECT.P_SU_PASSWORD);
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'            applic:'||UNICONNECT.P_SU_APPLIC);
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'            decimal characters:'||UNICONNECT.P_SU_NUMERIC_CHARACTERS);
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'            date format:'||UNICONNECT.P_SU_DATE_FORMAT);
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'            up:'||UNICONNECT.P_SU_UP);

      l_ret_code := Unapigen.SwitchUser(UNICONNECT.P_SU_CLIENT_ID,
                                        UNICONNECT.P_SU_US,
                                        UNICONNECT.P_SU_PASSWORD,
                                        UNICONNECT.P_SU_APPLIC,
                                        UNICONNECT.P_SU_NUMERIC_CHARACTERS,
                                        UNICONNECT.P_SU_DATE_FORMAT,
                                        UNICONNECT.P_SU_UP,
                                        l_temp_up_description,
                                        l_temp_language,
                                        l_temp_language);

      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : SwitchUser ret_code='||l_ret_code);
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Calling SwitchUser for :');
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'            client_id:'||UNICONNECT.P_SU_CLIENT_ID);
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'            us:'||UNICONNECT.P_SU_US);
         --UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'            password:'||UNICONNECT.P_SU_PASSWORD);
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'            applic:'||UNICONNECT.P_SU_APPLIC);
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'            decimal characters:'||UNICONNECT.P_SU_NUMERIC_CHARACTERS);
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'            date format:'||UNICONNECT.P_SU_DATE_FORMAT);
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'            up:'||UNICONNECT.P_SU_UP);
         RAISE StpError;
      ELSE
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         SwitchUser successful');
      END IF;
      UNICONNECT.P_SU_USER_SWITCHED := FALSE;
   END IF;
   RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
WHEN OTHERS THEN
   --an exception can have been raised with l_ret_code = UNAPIGEN.DBERR_SUCCESS
   --this is done to skip the section without interrupting the file parsing
   IF sqlcode <> 1 THEN
      --the exception is not a user exception
      l_sqlerrm := SUBSTR(SQLERRM, 1, 200);
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Following exception catched in UCON_RestoreJobUserContext :');
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         '||l_sqlerrm);
      l_ret_code := UNAPIGEN.DBERR_GENFAIL;
   END IF;
   UNAPIGEN.P_TXN_ERROR := l_ret_code;
   RETURN(l_ret_code);
END UCON_RestoreJobUserContext;

FUNCTION UCON_CheckElecSignature             /* INTERNAL */
(a_ss_to       IN VARCHAR2) /*VC2_TYPE*/
RETURN NUMBER IS

l_setting_value                VARCHAR2(255);
l_new_ss                       VARCHAR2(2);

BEGIN

   --
   BEGIN
      SELECT setting_value
      INTO l_setting_value
      FROM utsystem
      WHERE setting_name = 'STATES_TO_SIGN_OFF'
      AND INSTR(setting_value, a_ss_to) <> 0;
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         status "'||a_ss_to||'" is one of the status that must be signed electronically');
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
      RETURN(UNAPIGEN.AbortTxn(UNAPIGEN.P_TXN_ERROR, 'UCON_CheckElecSignature'));
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
      --continue
      NULL;
   END;

   BEGIN
      SELECT ss
      INTO l_new_ss
      FROM utss
      WHERE ss = a_ss_to;
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         status "'||a_ss_to||'" is not a valid status.');
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOSS;
      RETURN(UNAPIGEN.AbortTxn(UNAPIGEN.P_TXN_ERROR, 'UCON_CheckElecSignature'));
   END;
   RETURN(UNAPIGEN.DBERR_SUCCESS);

END UCON_CheckElecSignature;

FUNCTION UCON_ExecuteResetGlobSection         /* INTERNAL */
RETURN NUMBER IS

BEGIN

   UNICONNECT.P_GLOB_SC     := NULL;
   UNICONNECT.P_GLOB_PG     := NULL;
   UNICONNECT.P_GLOB_PGNODE := NULL;
   UNICONNECT.P_GLOB_PA     := NULL;
   UNICONNECT.P_GLOB_PANODE := NULL;
   UNICONNECT.P_GLOB_ME     := NULL;
   UNICONNECT.P_GLOB_MENODE := NULL;
   UNICONNECT.P_GLOB_CE     := NULL;
   UNICONNECT.P_GLOB_CENODE := NULL;
   UNICONNECT.P_GLOB_IC     := NULL;
   UNICONNECT.P_GLOB_ICNODE := NULL;
   UNICONNECT.P_GLOB_II     := NULL;
   UNICONNECT.P_GLOB_IINODE := NULL;

   RETURN(UNAPIGEN.DBERR_SUCCESS);
END UCON_ExecuteResetGlobSection;

END uniconnect7;
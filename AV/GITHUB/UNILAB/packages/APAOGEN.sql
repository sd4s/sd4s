CREATE OR REPLACE PACKAGE APAOGEN AS
--------------------------------------------------------------------------------
--  PROJECT : Vredestein Enschede
-------------------------------------------------------------------------------
--  PACKAGE : APAOGEN
-- ABSTRACT :
--   WRITER : Rody Sparenberg
--     DATE : 01/02/2007
--   TARGET : Oracle 10.2.0
--  VERSION : 6.1.1.1	$Revision: 1 $
--------------------------------------------------------------------------------
--  REMARKS :
--------------------------------------------------------------------------------
--  CHANGES :
--
--  When      | Who       | What
--============|===========|=====================================================
-- 01/02/2007 | RS        | Created
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------
SUBTYPE DESCRIPTION_TYPE   IS utsc.description%TYPE;
SUBTYPE COUNTER_TYPE       IS INTEGER;
SUBTYPE RETURN_TYPE        IS INTEGER;
SUBTYPE API_NAME_TYPE      IS uterror.api_name%TYPE;
SUBTYPE SETTING_NAME_TYPE  IS utsystem.setting_name%TYPE;
SUBTYPE SETTING_VALUE_TYPE IS utsystem.setting_value%TYPE;

lvs_error                 VARCHAR2 (2048);SUBTYPE ERROR_MSG_TYPE     IS lvs_error%TYPE;
lvs_where_clause          VARCHAR2 (2048);SUBTYPE WHERE_CLAUSE_TYPE  IS lvs_where_clause%TYPE;
lvs_modify_reason         VARCHAR2  (255);SUBTYPE MODIFY_REASON_TYPE IS lvs_modify_reason%TYPE;
lvc_flag                      CHAR    (1);SUBTYPE FLAG_TYPE          IS lvc_flag%TYPE;
lvs_max_field_length      VARCHAR2  (255);SUBTYPE FIELD_TYPE         IS lvs_max_field_length%TYPE;
lvs_max_line_length       VARCHAR2 (2000);SUBTYPE LINE_TYPE          IS lvs_max_line_length%TYPE;
lvs_max_sql_string_length VARCHAR2 (2048);SUBTYPE SQL_STRING_TYPE    IS lvs_max_sql_string_length%TYPE;

TYPE DATE_TABLE_TYPE IS TABLE OF DATE INDEX BY BINARY_INTEGER;

--------------------------------------------------------------------------------
-- Unilab objects
--------------------------------------------------------------------------------
SUBTYPE NAME_TYPE             IS utsc.sc%TYPE;
SUBTYPE VERSION_TYPE          IS utst.version%TYPE;
SUBTYPE DESCRIPTION_TYPE      IS utsc.description%TYPE;
SUBTYPE NODE_TYPE             IS utscpg.pgnode%TYPE;
SUBTYPE AUVALUE_TYPE          IS utscau.value%TYPE;
SUBTYPE IIVALUE_TYPE          IS utscii.iivalue%TYPE;
SUBTYPE GKVALUE_TYPE          IS utscgk.value%TYPE;
SUBTYPE VALUE_F_TYPE          IS utscpa.value_f%TYPE;
SUBTYPE VALUE_S_TYPE          IS utscpa.value_s%TYPE;
SUBTYPE LC_TYPE               IS utlc.lc%TYPE;
SUBTYPE SS_TYPE               IS utss.ss%TYPE;
SUBTYPE RESULT_FORMAT_TYPE    IS utie.format%TYPE;
SUBTYPE INFOFIELD_FORMAT_TYPE IS utie.format%TYPE;

--------------------------------------------------------------------------------
-- Backwards compatibility
--------------------------------------------------------------------------------
SUBTYPE UNIT_TYPE        IS utpr.unit%TYPE;
SUBTYPE FORMAT_TYPE      IS utie.format%TYPE;
SUBTYPE US_TYPE          IS utupus.us%TYPE;
SUBTYPE UP_TYPE          IS utupus.up%TYPE;
SUBTYPE FREQ_TP_TYPE     IS utprmt.freq_tp%TYPE;
SUBTYPE FREQ_VAL_TYPE    IS utprmt.freq_val%TYPE;
SUBTYPE FREQ_UNIT_TYPE   IS utprmt.freq_unit%TYPE;
SUBTYPE REANALYSIS_TYPE  IS utrscme.reanalysis%TYPE;
SUBTYPE EQ_TYPE          IS uteq.eq%TYPE;
SUBTYPE RQ_TYPE          IS utrq.rq%TYPE;
SUBTYPE SC_TYPE          IS utsc.sc%TYPE;
SUBTYPE PG_TYPE          IS utscpg.pg%TYPE;
SUBTYPE PGNODE_TYPE      IS utscpg.pgnode%TYPE;
SUBTYPE PA_TYPE          IS utscpa.pa%TYPE;
SUBTYPE PANODE_TYPE      IS utscpa.panode%TYPE;
SUBTYPE ME_TYPE          IS utscme.me%TYPE;
SUBTYPE MENODE_TYPE      IS utscme.menode%TYPE;
SUBTYPE IC_TYPE          IS utscic.ic%TYPE;
SUBTYPE ICNODE_TYPE      IS utscic.icnode%TYPE;
SUBTYPE II_TYPE          IS utscii.ii%TYPE;
SUBTYPE IINODE_TYPE      IS utscii.icnode%TYPE;
SUBTYPE AU_TYPE          IS utau.au%TYPE;
SUBTYPE GK_TYPE          IS utscgk.gk%TYPE;
SUBTYPE RT_TYPE          IS utrt.rt%TYPE;
SUBTYPE ST_TYPE          IS utst.st%TYPE;
SUBTYPE PP_TYPE          IS utpp.pp%TYPE;
SUBTYPE PR_TYPE          IS utpr.pr%TYPE;
SUBTYPE MT_TYPE          IS utmt.mt%TYPE;
SUBTYPE IP_TYPE          IS utip.ip%TYPE;
SUBTYPE IE_TYPE          IS utie.ie%TYPE;

--------------------------------------------------------------------------------
-- Global exceptions
--------------------------------------------------------------------------------
API_FAILED         EXCEPTION; PRAGMA EXCEPTION_INIT (API_FAILED,         -10000);
CONNECTION_FAILED  EXCEPTION; PRAGMA EXCEPTION_INIT (CONNECTION_FAILED,  -10002);
TRANSACTION_FAILED EXCEPTION; PRAGMA EXCEPTION_INIT (TRANSACTION_FAILED, -10001);
QUERY_FAILED       EXCEPTION; PRAGMA EXCEPTION_INIT (QUERY_FAILED,       -10003);
EX_INVALID_VALUE   EXCEPTION; PRAGMA EXCEPTION_INIT (EX_INVALID_VALUE,   -10004);

--------------------------------------------------------------------------------
-- FUNCTION : LogError
-- ABSTRACT : Log Message in uterror. Break up in parts
--------------------------------------------------------------------------------
--   WRITER :
-- REVIEWER :
--     DATE :
--   TARGET : Oracle 10.2.0
--  VERSION : 6.1.1
--------------------------------------------------------------------------------
--            Errorcode               | Description
-- ===================================|=========================================
--   ERRORS :                         |
--------------------------------------------------------------------------------
--  REMARKS : -
--------------------------------------------------------------------------------
--  CHANGES :
--
-- When       | Who       | What
-- ===========|===========|=====================================================
--				  |           |
--------------------------------------------------------------------------------
PROCEDURE LogError (avs_function_name  IN API_NAME_TYPE,
                    avs_message        IN VARCHAR2,
                    avb_with_rollback  IN BOOLEAN := TRUE,
                    avb_with_commit    IN BOOLEAN := TRUE,
                    avi_message_length IN INTEGER := 255);

--------------------------------------------------------------------------------
-- FUNCTION : GetSystemSetting
-- ABSTRACT : Returns certain system-setting
--------------------------------------------------------------------------------
--   WRITER :
-- REVIEWER :
--     DATE :
--   TARGET : Oracle 10.2.0
--  VERSION : 6.1.1
--------------------------------------------------------------------------------
--            Errorcode               | Description
-- ===================================|=========================================
--   ERRORS :                         |
--------------------------------------------------------------------------------
--  REMARKS : -
--------------------------------------------------------------------------------
--  CHANGES :
--
-- When       | Who       | What
-- ===========|===========|=====================================================
--				  |           |
--------------------------------------------------------------------------------
FUNCTION GetSystemSetting (avs_setting_name SETTING_NAME_TYPE,
                           avs_default      SETTING_VALUE_TYPE := NULL)
RETURN SETTING_VALUE_TYPE;

--------------------------------------------------------------------------------
-- PROCEDURE : ExecuteSQL
--  ABSTRACT : Execute dynamic-sql, no rows are returned
--------------------------------------------------------------------------------
--   WRITER :
-- REVIEWER :
--     DATE :
--   TARGET : Oracle 10.2.0
--  VERSION : 6.1.1
--------------------------------------------------------------------------------
--            Errorcode               | Description
-- ===================================|=========================================
--   ERRORS :                         |
--------------------------------------------------------------------------------
--  REMARKS : -
--------------------------------------------------------------------------------
--  CHANGES :
--
-- When       | Who       | What
-- ===========|===========|=====================================================
--				  |           |
--------------------------------------------------------------------------------
FUNCTION ExecuteSQL (avs_sql VARCHAR2, avb_showsql BOOLEAN := FALSE)
RETURN RETURN_TYPE;

--------------------------------------------------------------------------------
-- PROCEDURE : ShowMessage
--  ABSTRACT : Send string to DBMS_OUPUT-window
--------------------------------------------------------------------------------
--    WRITER :
--  REVIEWER :
--      DATE :
--    TARGET : Oracle
--   VERSION : 9.2.0
--------------------------------------------------------------------------------
--             Errorcode              | Description
-- ===================================|=========================================
--    ERRORS :                        |
--------------------------------------------------------------------------------
--   REMARKS : -
--------------------------------------------------------------------------------
--   CHANGES :
--
-- When       | Who       | What
-- ===========|===========|=====================================================
--            |           |
--------------------------------------------------------------------------------
PROCEDURE ShowMessage (avs_message IN VARCHAR2, avi_message_length IN INTEGER := 255);

--------------------------------------------------------------------------------
--  FUNCTION : strtok
--  ABSTRACT :
--------------------------------------------------------------------------------
--    WRITER :
--  REVIEWER :
--      DATE :
--    TARGET : Oracle
--   VERSION : 9.2.0
--------------------------------------------------------------------------------
--             Errorcode              | Description
-- ===================================|=========================================
--    ERRORS :                        |
--------------------------------------------------------------------------------
--   REMARKS : -
--------------------------------------------------------------------------------
--   CHANGES :
--
-- When       | Who       | What
-- ===========|===========|=====================================================
--            |           |
--------------------------------------------------------------------------------
FUNCTION StrTok (avs_line      IN LINE_TYPE,
                 avc_separator IN FLAG_TYPE,
                 avi_pos       IN COUNTER_TYPE)
RETURN FIELD_TYPE;
PRAGMA RESTRICT_REFERENCES (Strtok, WNDS, WNPS, RNDS, RNPS);

FUNCTION StrTok (avs_line      IN     LINE_TYPE,
                 avc_separator IN     FLAG_TYPE,
                 avi_pos       IN OUT COUNTER_TYPE,
                 avb_variable  IN     BOOLEAN)
RETURN FIELD_TYPE;

FUNCTION StrTok (avs_line            IN LINE_TYPE,
                 avc_separator       IN FLAG_TYPE,
                 avc_start_delimiter IN FLAG_TYPE,
                 avc_end_delimiter   IN FLAG_TYPE,
                 avi_pos             IN COUNTER_TYPE)
RETURN FIELD_TYPE;
PRAGMA RESTRICT_REFERENCES (Strtok, WNDS, WNPS, RNDS, RNPS);

FUNCTION StrTok (avs_line            IN LINE_TYPE,
                 avc_separator       IN FLAG_TYPE,
                 avc_start_delimiter IN FLAG_TYPE,
                 avc_end_delimiter   IN FLAG_TYPE,
                 avi_pos             IN OUT COUNTER_TYPE,
                 avb_variable        IN     BOOLEAN)
RETURN FIELD_TYPE;

--------------------------------------------------------------------------------
--  FUNCTION : ActiveObject
--  ABSTRACT :
--------------------------------------------------------------------------------
--    WRITER :
--  REVIEWER :
--      DATE :
--    TARGET : Oracle
--   VERSION : 9.2.0
--------------------------------------------------------------------------------
--             Errorcode              | Description
-- ===================================|=========================================
--    ERRORS :                        |
--------------------------------------------------------------------------------
--   REMARKS : -
--------------------------------------------------------------------------------
--   CHANGES :
--
-- When       | Who       | What
-- ===========|===========|=====================================================
--            |           |
--------------------------------------------------------------------------------
FUNCTION ActiveObject
RETURN VARCHAR2;

--------------------------------------------------------------------------------
--  FUNCTION : SQLTable
--  ABSTRACT :
--------------------------------------------------------------------------------
--    WRITER :
--  REVIEWER :
--      DATE :
--    TARGET : Oracle
--   VERSION : 9.2.0
--------------------------------------------------------------------------------
--             Errorcode              | Description
-- ===================================|=========================================
--    ERRORS :                        |
--------------------------------------------------------------------------------
--   REMARKS : -
--------------------------------------------------------------------------------
--   CHANGES :
--
-- When       | Who       | What
-- ===========|===========|=====================================================
--            |           |
--------------------------------------------------------------------------------
FUNCTION SqlTable (ats_table IN UNAPIGEN.VC2_TABLE_TYPE)
RETURN VARCHAR2;

FUNCTION SqlTable (ats_table IN UNAPIGEN.VC20_TABLE_TYPE)
RETURN VARCHAR2;

FUNCTION SqlTable (ats_table IN UNAPIGEN.VC40_TABLE_TYPE)
RETURN VARCHAR2;

FUNCTION SqlTable (ats_table IN UNAPIGEN.VC255_TABLE_TYPE)
RETURN VARCHAR2;

FUNCTION SqlTable (ats_table IN UNAPIGEN.VC2000_TABLE_TYPE)
RETURN VARCHAR2;
--------------------------------------------------------------------------------
--  FUNCTION : EventTriggered
--  ABSTRACT :
--------------------------------------------------------------------------------
--    WRITER :
--  REVIEWER :
--      DATE :
--    TARGET : Oracle
--   VERSION : 9.2.0
--------------------------------------------------------------------------------
--             Errorcode              | Description
-- ===================================|=========================================
--    ERRORS :                        |
--------------------------------------------------------------------------------
--   REMARKS : Checks wether a given event has been triggered
--------------------------------------------------------------------------------
--   CHANGES :
--
-- When       | Who       | What
-- ===========|===========|=====================================================
--            |           |
--------------------------------------------------------------------------------
FUNCTION EventTriggered (avs_event IN VARCHAR2)
RETURN BOOLEAN;


END APAOGEN;

/


CREATE OR REPLACE PACKAGE BODY        APAOGEN AS
--------------------------------------------------------------------------------
--  PROJECT : ATOS ORIGIN
-------------------------------------------------------------------------------
--  PACKAGE : APAOGEN.SQL
-- ABSTRACT : General functions
--------------------------------------------------------------------------------
--   WRITER : ATOS ORIGIN
--     DATE :
--   TARGET : Oracle 10.2.0 / Unilab 6.3
--  VERSION : av3.0
--------------------------------------------------------------------------------
--  REMARKS : -
--------------------------------------------------------------------------------
--  CHANGES :
--
--  When        | Who       | What
-- =============|===========|===================================================
-- 03/03/2011 | RS        | Upgrade V6.3
--                        | Changed SYSDATE INTO CURRENT_TIMESTAMP
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
ics_package_name CONSTANT API_NAME_TYPE := 'APAOGEN';
ics_break_chars  CONSTANT VARCHAR2 (20) := CHR(9)||'();,. /\:';
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- FUNCTION : LogError
-- ABSTRACT : Log Message in uterror. Break up in parts
--------------------------------------------------------------------------------
--   WRITER :
-- REVIEWER :
--     DATE :
--   TARGET : Oracle 10.2.0
--  VERSION : 6.1.1
--------------------------------------------------------------------------------
--            Errorcode               | Description
-- ===================================|=========================================
--   ERRORS :                         |
--------------------------------------------------------------------------------
--  REMARKS : -
--------------------------------------------------------------------------------
--  CHANGES :
--
-- When       | Who       | What
-- ===========|===========|=====================================================
--				  |           |
--------------------------------------------------------------------------------
PROCEDURE LogError (avs_function_name  IN API_NAME_TYPE,
                    avs_message        IN VARCHAR2,
                    avb_with_rollback  IN BOOLEAN := TRUE,
                    avb_with_commit    IN BOOLEAN := TRUE,
                    avi_message_length IN INTEGER := 255)IS

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name  CONSTANT API_NAME_TYPE := ics_package_name||'.'||'LogError';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_sqlerrm  		ERROR_MSG_TYPE;
lvi_ret_code 		RETURN_TYPE;
lvs_line_left 		VARCHAR2 (32767) := avs_message;
lvs_line      		uterror.error_msg%TYPE;
lvi_counter   		INTEGER;
lvs_line_bak  		uterror.error_msg%TYPE;
lvs_line_left_bak VARCHAR2 (32767);

PROCEDURE WriteLine (avs_line VARCHAR2) IS
BEGIN
   IF avb_with_rollback THEN
      UNAPIGEN.LogError (avs_function_name, avs_line);
   ELSE
      INSERT
        INTO uterror(client_id, applic, who, logdate, api_name, error_msg)
      VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP,
             avs_function_name, avs_line);

      IF avb_with_commit THEN
         COMMIT;
      END IF;
   END IF;
END WriteLine;

BEGIN
   WHILE LENGTH (lvs_line_left) > avi_message_length LOOP
      lvs_line          := SUBSTR (lvs_line_left, 1, avi_message_length);
      lvs_line_left     := SUBSTR (lvs_line_left, avi_message_length + 1);
      lvi_counter       := -1;
      lvs_line_bak      := lvs_line;
      lvs_line_left_bak := lvs_line_left;
      WHILE INSTR (ics_break_chars, SUBSTR (lvs_line, -1)) <= 0 LOOP
         lvi_counter := lvi_counter + 1;
         lvs_line_left := SUBSTR (lvs_line, -1)||lvs_line_left;
         lvs_line := SUBSTR (lvs_line, 1, LENGTH (lvs_line) - 1);
         IF lvs_line IS NULL THEN
            lvs_line      := lvs_line_bak;
            lvs_line_left := lvs_line_left_bak;
            EXIT;
         END IF;
      END LOOP;
      WriteLine (lvs_line);
   END LOOP;

   WriteLine (lvs_line_left);
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      LogError (lcs_function_name, SQLERRM);
   END IF;
END LogError;

--------------------------------------------------------------------------------
-- FUNCTION : GetSystemSetting
-- ABSTRACT : Returns certain system-setting
--------------------------------------------------------------------------------
--   WRITER :
-- REVIEWER :
--     DATE :
--   TARGET : Oracle 10.2.0
--  VERSION : 6.1.1
--------------------------------------------------------------------------------
--            Errorcode               | Description
-- ===================================|=========================================
--   ERRORS :                         |
--------------------------------------------------------------------------------
--  REMARKS : -
--------------------------------------------------------------------------------
--  CHANGES :
--
-- When       | Who       | What
-- ===========|===========|=====================================================
--				  |           |
--------------------------------------------------------------------------------
FUNCTION GetSystemSetting (avs_setting_name SETTING_NAME_TYPE,
                           avs_default      SETTING_VALUE_TYPE := NULL)
RETURN SETTING_VALUE_TYPE  IS

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT API_NAME_TYPE := ics_package_name||'.'||'GetSystemSetting';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_sqlerrm  ERROR_MSG_TYPE;
lvs_ret_code SETTING_VALUE_TYPE;

--------------------------------------------------------------------------------
-- Local functions and/or procedures
--------------------------------------------------------------------------------

BEGIN
   BEGIN
      --------------------------------------------------------------------------
      -- First look for settingvalue as exact match, thus using the index
      --------------------------------------------------------------------------
      SELECT setting_value
        INTO lvs_ret_code
        FROM utsystem
       WHERE setting_name = avs_setting_name;
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
      --------------------------------------------------------------------------
      -- when not found, use case-insensitive search (=full table scan!)
      --------------------------------------------------------------------------
      SELECT setting_value
        INTO lvs_ret_code
        FROM utsystem
       WHERE UPPER (setting_name) = UPPER (avs_setting_name);
   END;

   -----------------------------------------------------------------------------
   -- when empty value in utsystem return default
   -----------------------------------------------------------------------------
   IF lvs_ret_code = NULL THEN
      lvs_ret_code := avs_default;
   END IF;

   RETURN lvs_ret_code;
EXCEPTION
WHEN NO_DATA_FOUND THEN
   lvs_sqlerrm := 'Systemsetting <'||avs_setting_name||'> does not exist!';
   IF avs_default IS NOT NULL THEN
      lvs_sqlerrm := lvs_sqlerrm||' Default value: <'||avs_default||'> will be used';
   END IF;
   LogError (lcs_function_name, lvs_sqlerrm);
   RETURN avs_default;
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN NULL;
END GetSystemSetting;

--------------------------------------------------------------------------------
-- PROCEDURE : ExecuteSQL
--  ABSTRACT : Execute dynamic-sql, no rows are returned
--------------------------------------------------------------------------------
--   WRITER :
-- REVIEWER :
--     DATE :
--   TARGET : Oracle 10.2.0
--  VERSION : 6.1.1
--------------------------------------------------------------------------------
--            Errorcode               | Description
-- ===================================|=========================================
--   ERRORS :                         |
--------------------------------------------------------------------------------
--  REMARKS : -
--------------------------------------------------------------------------------
--  CHANGES :
--
-- When       | Who       | What
-- ===========|===========|=====================================================
--				  |           |
--------------------------------------------------------------------------------
FUNCTION ExecuteSQL (avs_sql VARCHAR2, avb_showsql BOOLEAN := FALSE)
RETURN RETURN_TYPE IS

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_procedure_name CONSTANT API_NAME_TYPE := 'ExecuteSQL';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvi_handle   INTEGER;
lvi_ret_code INTEGER;

--------------------------------------------------------------------------------
-- Local functions and/or procedures
--------------------------------------------------------------------------------

BEGIN
   IF avb_showsql THEN ShowMessage (avs_sql); END IF;
   lvi_handle := DBMS_SQL.OPEN_CURSOR;
   DBMS_SQL.PARSE (lvi_handle, avs_sql, DBMS_SQL.NATIVE);
   lvi_ret_code := DBMS_SQL.EXECUTE (lvi_handle);
   DBMS_SQL.CLOSE_CURSOR (lvi_handle);

   RETURN UNAPIGEN.DBERR_SUCCESS;
EXCEPTION
WHEN OTHERS THEN
   IF avb_showsql THEN ShowMessage (SQLERRM); END IF;
   IF DBMS_SQL.IS_OPEN (lvi_handle) THEN
      DBMS_SQL.CLOSE_CURSOR (lvi_handle);
   END IF;
   RETURN SQLCODE;
END ExecuteSQL;
--------------------------------------------------------------------------------
-- PROCEDURE : ShowMessage
--  ABSTRACT : Send string to DBMS_OUPUT-window
--------------------------------------------------------------------------------
--    WRITER :
--  REVIEWER :
--      DATE :
--    TARGET : Oracle
--   VERSION : Oracle 10.2.0
--------------------------------------------------------------------------------
--             Errorcode              | Description
-- ===================================|=========================================
--    ERRORS :                        |
--------------------------------------------------------------------------------
--   REMARKS : -
--------------------------------------------------------------------------------
--   CHANGES :
--
-- When       | Who       | What
-- ===========|===========|=====================================================
--            |           |
--------------------------------------------------------------------------------
PROCEDURE ShowMessage (avs_message IN VARCHAR2, avi_message_length IN INTEGER := 255) IS

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_procedure_name CONSTANT API_NAME_TYPE := 'ShowMessage';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Local functions and/or procedures
--------------------------------------------------------------------------------
lvs_line_left VARCHAR2 (32767) := avs_message;
lvs_line      uterror.error_msg%TYPE;
lvi_counter   INTEGER;
lvs_line_bak  uterror.error_msg%TYPE;
lvs_line_left_bak VARCHAR2 (32767);

BEGIN
   WHILE LENGTH (lvs_line_left) > avi_message_length LOOP
      lvs_line          := SUBSTR (lvs_line_left, 1, avi_message_length);
      lvs_line_left     := SUBSTR (lvs_line_left, avi_message_length + 1);
      lvi_counter       := -1;
      lvs_line_bak      := lvs_line;
      lvs_line_left_bak := lvs_line_left;
      WHILE INSTR (ics_break_chars, SUBSTR (lvs_line, -1)) <= 0 LOOP
         lvi_counter := lvi_counter + 1;
         lvs_line_left := SUBSTR (lvs_line, -1)||lvs_line_left;
         lvs_line := SUBSTR (lvs_line, 1, LENGTH (lvs_line) - 1);
         IF lvs_line IS NULL THEN
            lvs_line      := lvs_line_bak;
            lvs_line_left := lvs_line_left_bak;
            EXIT;
         END IF;
      END LOOP;
      DBMS_OUTPUT.PUT_LINE (lvs_line);
   END LOOP;
   DBMS_OUTPUT.PUT_LINE (lvs_line_left);
END ShowMessage;

--------------------------------------------------------------------------------
--  FUNCTION : strtok
--  ABSTRACT :
--------------------------------------------------------------------------------
--    WRITER :
--  REVIEWER :
--      DATE :
--    TARGET : Oracle
--   VERSION : Oracle 10.2.0
--------------------------------------------------------------------------------
--             Errorcode              | Description
-- ===================================|=========================================
--    ERRORS :                        |
--------------------------------------------------------------------------------
--   REMARKS : -
--------------------------------------------------------------------------------
--   CHANGES :
--
-- When       | Who       | What
-- ===========|===========|=====================================================
--            |           |
--------------------------------------------------------------------------------
FUNCTION StrTok (avs_line      IN LINE_TYPE,
                 avc_separator IN FLAG_TYPE,
                 avi_pos       IN COUNTER_TYPE)
RETURN FIELD_TYPE IS

lvn_left_pos  COUNTER_TYPE := 1;
lvn_right_pos COUNTER_TYPE := 1;
lvi_pos       COUNTER_TYPE := avi_pos;
lvi_direction COUNTER_TYPE := 1;

BEGIN
   IF avs_line IS NULL THEN
      RETURN NULL;
   END IF;

   IF avi_pos = 0 THEN
      RETURN avs_line;
   END IF;

   IF avi_pos > 0 THEN
      IF avi_pos = 1 THEN
         lvn_right_pos := INSTR (avs_line, avc_separator, 1) - 1;
         IF lvn_right_pos = -1 THEN
            RETURN avs_line;
         ELSE
            RETURN LPAD (avs_line, lvn_right_pos);
         END IF;
      ELSIF avi_pos > 1 THEN
         lvn_left_pos := INSTR (avs_line, avc_separator, 1, avi_pos - 1);

         IF lvn_left_pos = 0 THEN
            RETURN NULL;
         END IF;
         lvn_right_pos := INSTR (avs_line, avc_separator, lvn_left_pos + 1) - 1;

         IF lvn_right_pos = -1 THEN
            RETURN SUBSTR (avs_line, lvn_left_pos + 1);
         ELSE
            RETURN SUBSTR (avs_line, lvn_left_pos + 1, lvn_right_pos - lvn_left_pos);
         END IF;
      END IF;
   ELSE
      IF avi_pos = -1 THEN
         lvn_left_pos := INSTR (avs_line, avc_separator, -1) + 1;
         IF lvn_left_pos = 0 THEN
            RETURN avs_line;
         ELSE
            RETURN SUBSTR (avs_line, lvn_left_pos);
         END IF;
      ELSIF avi_pos < -1 THEN
         lvn_right_pos := INSTR (avs_line, avc_separator, -1, -avi_pos - 1);

         IF lvn_right_pos = 0 THEN
            RETURN NULL;
         END IF;

         lvn_left_pos := INSTR (avs_line, avc_separator, -1, -avi_pos);
         IF lvn_left_pos = 0 THEN
            RETURN SUBSTR (avs_line, 0, lvn_right_pos - 1);
         ELSE
            RETURN SUBSTR (avs_line, lvn_left_pos + 1, lvn_right_pos - lvn_left_pos - 1);
         END IF;
      END IF;
   END IF;
END Strtok;

FUNCTION StrTok (avs_line      IN     LINE_TYPE,
                 avc_separator IN     FLAG_TYPE,
                 avi_pos       IN OUT COUNTER_TYPE,
                 avb_variable  IN     BOOLEAN)
RETURN FIELD_TYPE IS

lvn_left_pos  COUNTER_TYPE := 1;
lvn_right_pos COUNTER_TYPE := 1;

BEGIN
   IF avs_line IS NULL THEN
      RETURN NULL;
   END IF;

   IF avi_pos = 0 THEN
      avi_pos := NULL;
      RETURN avs_line;
   END IF;

   IF avi_pos > 0 THEN
      IF avi_pos = 1 THEN
         lvn_right_pos := INSTR (avs_line, avc_separator, 1) - 1;
         IF lvn_right_pos = -1 THEN
            avi_pos := NULL;
            RETURN avs_line;
         ELSE
            avi_pos := avi_pos + 1;
            RETURN LPAD(avs_line, lvn_right_pos);
         END IF;
      ELSIF avi_pos > 1 THEN
         lvn_left_pos := INSTR (avs_line, avc_separator, 1, avi_pos - 1);

         IF lvn_left_pos = 0 THEN
            avi_pos := NULL;
            RETURN NULL;
         END IF;
         lvn_right_pos := INSTR (avs_line, avc_separator, lvn_left_pos + 1) - 1;

         IF lvn_right_pos = -1 THEN
            avi_pos := NULL;
            RETURN SUBSTR (avs_line, lvn_left_pos + 1);
         ELSE
            avi_pos := avi_pos + 1;
            RETURN SUBSTR (avs_line, lvn_left_pos + 1, lvn_right_pos - lvn_left_pos);
         END IF;
      END IF;
   ELSE
      IF avi_pos = -1 THEN
         lvn_left_pos := INSTR (avs_line, avc_separator, -1) + 1;
         IF lvn_left_pos = 0 THEN
            avi_pos := NULL;
            RETURN avs_line;
         ELSE
            avi_pos := avi_pos - 1;
            RETURN SUBSTR (avs_line, lvn_left_pos);
         END IF;
      ELSIF avi_pos < -1 THEN
         lvn_right_pos := INSTR (avs_line, avc_separator, -1, -avi_pos - 1);

         IF lvn_right_pos = 0 THEN
            avi_pos := NULL;
            RETURN NULL;
         END IF;

         lvn_left_pos := INSTR (avs_line, avc_separator, -1, -avi_pos);
         IF lvn_left_pos = 0 THEN
            avi_pos := NULL;
            RETURN SUBSTR (avs_line, 0, lvn_right_pos - 1);
         ELSE
            avi_pos := avi_pos - 1;
            RETURN SUBSTR (avs_line, lvn_left_pos + 1, lvn_right_pos - lvn_left_pos - 1);
         END IF;
      END IF;
   END IF;
END Strtok;

FUNCTION StrTok (avs_line            IN LINE_TYPE,
                 avc_separator       IN FLAG_TYPE,
                 avc_start_delimiter IN FLAG_TYPE,
                 avc_end_delimiter   IN FLAG_TYPE,
                 avi_pos             IN COUNTER_TYPE)
RETURN FIELD_TYPE IS

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------
TYPE CONFIG_TYPE IS TABLE OF CHAR INDEX BY BINARY_INTEGER;

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT API_NAME_TYPE := ics_package_name||'.'||'StrTok';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_sqlerrm      ERROR_MSG_TYPE;
lvi_ret_code     FIELD_TYPE;
lvc_character    FLAG_TYPE;
lvi_pos          BINARY_INTEGER;
lvi_original_pos COUNTER_TYPE := avi_pos;
ltc_start        CONFIG_TYPE;
ltc_stop         CONFIG_TYPE;
lvi_start        COUNTER_TYPE;
lvi_stop         COUNTER_TYPE;
lvi_item		     COUNTER_TYPE;
lvs_line         VARCHAR2 (32767) := avs_line;
lvs_item         VARCHAR2 (32767) := avs_line;
lvi_length       COUNTER_TYPE;

--------------------------------------------------------------------------------
-- Local functions and/or procedures
--------------------------------------------------------------------------------

BEGIN
   IF avi_pos > 0 THEN
      lvi_pos  := 1;
      lvi_item := 0;
   ELSE
      lvi_pos  := LENGTH (lvs_line);
      lvi_item := 0;
   END IF;

   IF avi_pos > 0 THEN
      WHILE lvi_pos > 0 AND lvi_item < avi_pos LOOP
         lvc_character := SUBSTR (lvs_line, lvi_pos, 1);
         IF lvc_character = avc_start_delimiter THEN
            ltc_start (lvi_pos + 1) := avc_start_delimiter;
            lvi_pos := INSTR (lvs_line, avc_end_delimiter, lvi_pos + 1);
            IF lvi_pos > 0 THEN
               ltc_stop (lvi_pos - 1) := avc_end_delimiter;
               lvi_pos := INSTR (lvs_line, avc_separator, lvi_pos + 1);
            ELSE
               ltc_stop (LENGTH (lvs_line)) := '|';
            END IF;
         ELSIF lvc_character = avc_separator THEN
            ltc_start (lvi_pos) := NULL;
            ltc_stop  (lvi_pos) := NULL;
         ELSE
            ltc_start (lvi_pos) := lvc_character;
            lvi_pos := INSTR (lvs_line, avc_separator, lvi_pos + 1);
            IF lvi_pos > 0 THEN
               ltc_stop (lvi_pos - 1) := avc_separator;
            ELSE
               ltc_stop (LENGTH (lvs_line)) := '|';
            END IF;
         END IF;
         lvi_item := lvi_item + 1;
         IF lvi_pos > 0 THEN
            IF lvi_item != avi_pos THEN
               lvi_pos := lvi_pos + 1;
            END IF;
         END IF;
      END LOOP;

      IF lvi_item = avi_pos THEN
         lvi_pos := ltc_start.LAST;
         IF ltc_start (lvi_pos) IS NULL THEN
            RETURN NULL;
         ELSE
            lvi_start := lvi_pos;
            lvi_pos   := ltc_stop.LAST;
            lvi_stop  := lvi_pos;
            RETURN LTRIM (RTRIM (SUBSTR (lvs_line, lvi_start, lvi_stop-lvi_start+1)));
         END IF;
      ELSE
         RETURN NULL;
      END IF;
   ELSE
      WHILE lvi_pos > 0 AND lvi_item > avi_pos LOOP
         lvi_item := lvi_item - 1;
         lvc_character := SUBSTR (lvs_line, lvi_pos, 1);
         IF lvc_character = avc_end_delimiter THEN
            lvs_line   := LPAD (lvs_line, LENGTH (lvs_line) - 1);
            lvi_stop   := LENGTH (lvs_line);
            lvi_start  := INSTR (lvs_line, avc_start_delimiter, -1, 1) + 1;
            lvs_item   := SUBSTR (lvs_line, lvi_start, lvi_stop-lvi_start+1);
            lvi_length := LENGTH (lvs_item) + 3;
         ELSE
            lvs_item := StrTok (lvs_line, avc_separator, -1);
            lvi_length := LENGTH (lvs_item) + 2;
         END IF;

         IF lvs_item IS NULL THEN
            lvi_length := 0;
         END IF;
         lvs_line := LPAD (lvs_line, LENGTH (lvs_line) - lvi_length + 1);
         lvi_pos := LENGTH (lvs_line);
      END LOOP;
   END IF;
END StrTok;

FUNCTION StrTok (avs_line            IN     LINE_TYPE,
                 avc_separator       IN     FLAG_TYPE,
                 avc_start_delimiter IN     FLAG_TYPE,
                 avc_end_delimiter   IN     FLAG_TYPE,
                 avi_pos             IN OUT COUNTER_TYPE,
                 avb_variable        IN     BOOLEAN)
RETURN FIELD_TYPE IS

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------
TYPE CONFIG_TYPE IS TABLE OF CHAR INDEX BY BINARY_INTEGER;

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT API_NAME_TYPE := ics_package_name||'.'||'StrTok';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_sqlerrm      ERROR_MSG_TYPE;
lvi_ret_code     FIELD_TYPE;
lvc_character    FLAG_TYPE;
lvi_pos          BINARY_INTEGER;
ltc_start        CONFIG_TYPE;
ltc_stop         CONFIG_TYPE;
lvi_start        COUNTER_TYPE;
lvi_stop         COUNTER_TYPE;
lvi_item		     COUNTER_TYPE;

--------------------------------------------------------------------------------
-- Local functions and/or procedures
--------------------------------------------------------------------------------

BEGIN
   lvi_pos  := 1;
   lvi_item := 0;

   WHILE lvi_pos > 0 AND lvi_item < avi_pos LOOP
      lvc_character := SUBSTR (avs_line, lvi_pos, 1);
      IF lvc_character = avc_start_delimiter THEN
         ltc_start (lvi_pos + 1) := avc_start_delimiter;
         lvi_pos := INSTR (avs_line, avc_end_delimiter, lvi_pos + 1);
         IF lvi_pos > 0 THEN
            ltc_stop (lvi_pos - 1) := avc_end_delimiter;
            lvi_pos := INSTR (avs_line, avc_separator, lvi_pos + 1);
         ELSE
            ltc_stop (LENGTH (avs_line)) := '|';
         END IF;
      ELSIF lvc_character = avc_separator THEN
         ltc_start (lvi_pos) := NULL;
         ltc_stop  (lvi_pos) := NULL;
      ELSE
         ltc_start (lvi_pos) := lvc_character;
         lvi_pos := INSTR (avs_line, avc_separator, lvi_pos + 1);
         IF lvi_pos > 0 THEN
            ltc_stop (lvi_pos - 1) := avc_separator;
         ELSE
            ltc_stop (LENGTH (avs_line)) := '|';
         END IF;
      END IF;
      lvi_item := lvi_item + 1;
      IF lvi_pos > 0 THEN
         IF lvi_item != avi_pos THEN
            lvi_pos := lvi_pos + 1;
         END IF;
      END IF;
   END LOOP;

   IF lvi_item = avi_pos THEN
      lvi_pos := ltc_start.LAST;
      IF ltc_start (lvi_pos) IS NULL THEN
         avi_pos := NULL;
         RETURN NULL;
      ELSE
         lvi_start    := lvi_pos;
         lvi_pos      := ltc_stop.LAST;
         lvi_stop     := lvi_pos;
         avi_pos := avi_pos + 1;
         RETURN LTRIM (RTRIM (SUBSTR (avs_line, lvi_start, lvi_stop-lvi_start+1)));
      END IF;
   ELSE
      avi_pos := NULL;
      RETURN NULL;
   END IF;
END StrTok;
--------------------------------------------------------------------------------
--  FUNCTION : ActiveObject
--  ABSTRACT : Return active object-type
--------------------------------------------------------------------------------
--    WRITER :
--  REVIEWER :
--      DATE :
--    TARGET : Oracle
--   VERSION : Oracle 10.2.0
--------------------------------------------------------------------------------
--             Errorcode              | Description
-- ===================================|=========================================
--    ERRORS :                        |
--------------------------------------------------------------------------------
--   REMARKS : -
--------------------------------------------------------------------------------
--   CHANGES :
--
-- When       | Who       | What
-- ===========|===========|=====================================================
--            |           |
--------------------------------------------------------------------------------
FUNCTION ActiveObject
RETURN VARCHAR2 IS

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT API_NAME_TYPE := 'ActiveObject';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_sqlerrm ERROR_MSG_TYPE;

--------------------------------------------------------------------------------
-- Local functions and/or procedures
--------------------------------------------------------------------------------

BEGIN
   RETURN UNAPIEV.P_EV_REC.object_tp;
END ActiveObject;

--------------------------------------------------------------------------------
--  FUNCTION : SQLTable
--  ABSTRACT :
--------------------------------------------------------------------------------
--    WRITER :
--  REVIEWER :
--      DATE :
--    TARGET : Oracle
--   VERSION : Oracle 10.2.0
--------------------------------------------------------------------------------
--             Errorcode              | Description
-- ===================================|=========================================
--    ERRORS :                        |
--------------------------------------------------------------------------------
--   REMARKS : -
--------------------------------------------------------------------------------
--   CHANGES :
--
-- When       | Who       | What
-- ===========|===========|=====================================================
--            |           |
--------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- joins all items in tabletype (for use with INSTR in query)
-------------------------------------------------------------------------------
FUNCTION SqlTable (ats_table IN UNAPIGEN.VC2_TABLE_TYPE)
RETURN VARCHAR2 IS

lcs_function_name CONSTANT API_NAME_TYPE := ics_package_name||'.'||'SqlTable';

lvs_sqlerrm  ERROR_MSG_TYPE;
lvs_ret_code WHERE_CLAUSE_TYPE;
lvi_pos              BINARY_INTEGER;

BEGIN
   lvi_pos := ats_table.FIRST;
   WHILE lvi_pos IS NOT NULL LOOP
      lvs_ret_code := lvs_ret_code || '<' || ats_table (lvi_pos) || '>,';
      lvi_pos      := ats_table.NEXT (lvi_pos);
   END LOOP;
   lvs_ret_code := SUBSTR (lvs_ret_code, 1, LENGTH (lvs_ret_code) - 1);

   RETURN lvs_ret_code;
END SqlTable;

-------------------------------------------------------------------------------
-- joins all items in tabletype (for use with INSTR in query)
-------------------------------------------------------------------------------
FUNCTION SqlTable (ats_table IN UNAPIGEN.VC20_TABLE_TYPE)
RETURN VARCHAR2 IS

lcs_function_name CONSTANT API_NAME_TYPE := ics_package_name||'.'||'SqlTable';

lvs_sqlerrm  ERROR_MSG_TYPE;
lvs_ret_code WHERE_CLAUSE_TYPE;
lvi_pos              BINARY_INTEGER;

BEGIN
   lvi_pos := ats_table.FIRST;
   WHILE lvi_pos IS NOT NULL LOOP
      lvs_ret_code := lvs_ret_code || '<' || ats_table (lvi_pos) || '>,';
      lvi_pos      := ats_table.NEXT (lvi_pos);
   END LOOP;
   lvs_ret_code := SUBSTR (lvs_ret_code, 1, LENGTH (lvs_ret_code) - 1);

   RETURN lvs_ret_code;
END SqlTable;

-------------------------------------------------------------------------------
-- joins all items in tabletype (for use with INSTR in query)
--------------------------------------------------------------------------------
FUNCTION SqlTable (ats_table IN UNAPIGEN.VC40_TABLE_TYPE)
RETURN VARCHAR2 IS

lcs_function_name CONSTANT API_NAME_TYPE := ics_package_name||'.'||'SqlTable';

lvs_sqlerrm  ERROR_MSG_TYPE;
lvs_ret_code WHERE_CLAUSE_TYPE;
lvi_pos              BINARY_INTEGER;

BEGIN
   lvi_pos := ats_table.FIRST;
   WHILE lvi_pos IS NOT NULL LOOP
      lvs_ret_code := lvs_ret_code || '<' || ats_table (lvi_pos) || '>,';
      lvi_pos      := ats_table.NEXT (lvi_pos);
   END LOOP;
   lvs_ret_code := SUBSTR (lvs_ret_code, 1, LENGTH (lvs_ret_code) - 1);

   RETURN lvs_ret_code;
END SqlTable;

-------------------------------------------------------------------------------
-- joins all items in tabletype (for use with INSTR in query)
-------------------------------------------------------------------------------
FUNCTION SqlTable (ats_table IN UNAPIGEN.VC255_TABLE_TYPE)
RETURN VARCHAR2 IS

lcs_function_name CONSTANT API_NAME_TYPE := ics_package_name||'.'||'SqlTable';

lvs_sqlerrm  ERROR_MSG_TYPE;
lvs_ret_code WHERE_CLAUSE_TYPE;
lvi_pos              BINARY_INTEGER;

BEGIN
   lvi_pos := ats_table.FIRST;
   WHILE lvi_pos IS NOT NULL LOOP
      lvs_ret_code := lvs_ret_code || '<' || ats_table (lvi_pos) || '>,';
      lvi_pos      := ats_table.NEXT (lvi_pos);
   END LOOP;
   lvs_ret_code := SUBSTR (lvs_ret_code, 1, LENGTH (lvs_ret_code) - 1);

   RETURN lvs_ret_code;
END SqlTable;

-------------------------------------------------------------------------------
-- joins all items in tabletype (for use with INSTR in query)
-------------------------------------------------------------------------------
FUNCTION SqlTable (ats_table IN UNAPIGEN.VC2000_TABLE_TYPE)
RETURN VARCHAR2 IS

lcs_function_name CONSTANT API_NAME_TYPE := ics_package_name||'.'||'SqlTable';

lvs_sqlerrm  ERROR_MSG_TYPE;
lvs_ret_code WHERE_CLAUSE_TYPE;
lvi_pos              BINARY_INTEGER;

BEGIN
   lvi_pos := ats_table.FIRST;
   WHILE lvi_pos IS NOT NULL LOOP
      lvs_ret_code := lvs_ret_code || '<' || ats_table (lvi_pos) || '>,';
      lvi_pos      := ats_table.NEXT (lvi_pos);
   END LOOP;
   lvs_ret_code := SUBSTR (lvs_ret_code, 1, LENGTH (lvs_ret_code) - 1);

   RETURN lvs_ret_code;
END SqlTable;

--------------------------------------------------------------------------------
--  FUNCTION : EventTriggered
--  ABSTRACT :
--------------------------------------------------------------------------------
--    WRITER :
--  REVIEWER :
--      DATE :
--    TARGET : Oracle
--   VERSION : Oracle 10.2.0
--------------------------------------------------------------------------------
--             Errorcode              | Description
-- ===================================|=========================================
--    ERRORS :                        |
--------------------------------------------------------------------------------
--   REMARKS : Checks wether a given event has been triggered
--------------------------------------------------------------------------------
--   CHANGES :
--
-- When       | Who       | What
-- ===========|===========|=====================================================
--            |           |
--------------------------------------------------------------------------------
FUNCTION EventTriggered (avs_event IN VARCHAR2)
RETURN BOOLEAN IS

lcs_function_name CONSTANT API_NAME_TYPE := ics_package_name||'.'||'EventTriggered';

lvs_sqlerrm ERROR_MSG_TYPE;

BEGIN
  RETURN UPPER (UNAPIEV.P_EV_REC.ev_tp) = UPPER (avs_event) AND UNAPIEV.P_EV_REC.ev_tp IS NOT NULL;
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN FALSE;
END EventTriggered;

--------------------------------------------------------------------------------
--  FUNCTION : SqlSubstituteTildes
--  ABSTRACT :
--------------------------------------------------------------------------------
--    WRITER :
--  REVIEWER :
--      DATE :
--    TARGET : Oracle
--   VERSION : Oracle 11.2.0
--------------------------------------------------------------------------------
--             Errorcode              | Description
-- ===================================|=========================================
--    ERRORS :                        |
--------------------------------------------------------------------------------
--   REMARKS : Replacement for UNAPIGEN.SubstituteAllTildesInText
--             for use in dynamic SQL statements. Escapes apostrophes before
--             replacing the values.
--------------------------------------------------------------------------------
--   CHANGES :
--
-- When       | Who       | What
-- ===========|===========|=====================================================
--            |           |
FUNCTION SqlSubstituteTildes
(A_OBJECT_TP    IN      VARCHAR2,
 A_OBJECT_KEY   IN      VARCHAR2,
 A_TEXT         IN OUT  VARCHAR2)
RETURN NUMBER IS
   L_RET_CODE     NUMBER;
   L_TEXT         VARCHAR2(255);
   L_TEXT_PIECE   VARCHAR2(255);
   L_POS_A        INTEGER;
   L_POS_B        INTEGER;
   L_COUNT        INTEGER;
   L_SUBST_OUT_S  VARCHAR2(255);
   L_SUBST_OUT_F  NUMBER;
   L_SUBST_OUT_D  TIMESTAMP WITH TIME ZONE;
BEGIN
   L_TEXT   := A_TEXT;
   L_RET_CODE := UNAPIGEN.DBERR_SUCCESS;

   IF INSTR(L_TEXT,'@') > 0 THEN
      L_POS_B := INSTR(L_TEXT, '~', 1, 2);

      IF L_POS_B > 0 THEN
         WHILE (L_POS_B > 0) AND (L_RET_CODE = UNAPIGEN.DBERR_SUCCESS) LOOP
            IF (L_POS_B > 0) THEN
               L_POS_A      := INSTR(L_TEXT, '~');
               L_TEXT_PIECE := SUBSTR(L_TEXT, L_POS_A, L_POS_B - L_POS_A + 1);
            END IF;

            L_RET_CODE := UNAPIGEN.TILDESUBSTITUTION(A_OBJECT_TP, A_OBJECT_KEY,
                             REPLACE(L_TEXT_PIECE,'~'), L_SUBST_OUT_S, L_SUBST_OUT_F,
                             L_SUBST_OUT_D);
            L_SUBST_OUT_S := REPLACE(L_SUBST_OUT_S, '''', '''''');
            L_TEXT   := REPLACE(L_TEXT, L_TEXT_PIECE, L_SUBST_OUT_S);
            L_POS_B  := INSTR(L_TEXT, '~', 1, 2) ;
         END LOOP;
      ELSE
         L_RET_CODE := UNAPIGEN.TILDESUBSTITUTION(A_OBJECT_TP, A_OBJECT_KEY, REPLACE(L_TEXT,'~'),
                                                  L_SUBST_OUT_S, L_SUBST_OUT_F, L_SUBST_OUT_D);
         L_TEXT := REPLACE(L_SUBST_OUT_S, '''', '''''');
      END IF;
      A_TEXT := L_TEXT;
   END IF;

   RETURN(L_RET_CODE);
EXCEPTION
WHEN OTHERS THEN
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END SqlSubstituteTildes;

END APAOGEN;
/

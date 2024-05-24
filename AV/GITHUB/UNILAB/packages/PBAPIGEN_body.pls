create or replace PACKAGE BODY
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
pbapigen AS

l_ret_code        NUMBER;
l_sqlerrm         VARCHAR2(255);
l_sql_string      VARCHAR2(2000);
l_where_clause    VARCHAR2(1000);
l_event_tp        utev.ev_tp%TYPE;
l_timed_event_tp  utev.ev_tp%TYPE;
l_result          NUMBER;
l_fetched_rows    NUMBER;
l_errm            VARCHAR2(255);
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

FUNCTION GetShortCutKey
(a_shortcut            OUT       PBAPIGEN.VC8_TABLE_TYPE,    /* RAW8_TABLE_TYPE */
 a_key_tp              OUT       UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_value_s             OUT       UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_value_f             OUT       UNAPIGEN.FLOAT_TABLE_TYPE,  /* NUM_TABLE_TYPE + INDICATOR */
 a_store_db            OUT       PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_run_mode            OUT       PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_service             OUT       UNAPIGEN.VC255_TABLE_TYPE,  /* VC255_TABLE_TYPE */
 a_nr_of_rows          IN OUT    NUMBER)                     /* NUM_TYPE */
RETURN NUMBER IS
l_row               NUMBER;
l_shortcut          UNAPIGEN.RAW8_TABLE_TYPE;
l_value_f           UNAPIGEN.NUM_TABLE_TYPE;
l_store_db          UNAPIGEN.CHAR1_TABLE_TYPE;
l_run_mode          UNAPIGEN.CHAR1_TABLE_TYPE;
BEGIN
   l_ret_code := UNAPIGEN.GetShortCutKey(l_shortcut,
                                         a_key_tp,
                                         a_value_s,
                                         l_value_f,
                                         l_store_db,
                                         l_run_mode,
                                         a_service,
                                         a_nr_of_rows);
   IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
      FOR l_row IN 1..a_nr_of_rows LOOP
         a_shortcut(l_row) := UTL_RAW.cast_to_varchar2(l_shortcut(l_row));
         a_value_f(l_row)  := l_value_f(l_row);
         a_store_db(l_row) := l_store_db(l_row);
         a_run_mode(l_row) := l_run_mode(l_row);
      END LOOP;
   END IF;
   RETURN (l_ret_code);
END GetShortCutKey;


FUNCTION AddObjectComment
(a_object_tp         IN  VARCHAR2, /* VC4_TYPE */
 a_object_id         IN  VARCHAR2, /* VC20_TYPE */
 a_comment           IN  VARCHAR2) /* VC255_TYPE */
RETURN NUMBER IS
a_object_version    VARCHAR2(20);
BEGIN
   /* TO BE REMOVED WHEN VERSION_CONTROL WILL BE SUPPORTED */
    a_object_version := UNVERSION.P_NO_VERSION;
   IF  a_object_version IS NULL THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
      RAISE StpError;
   END IF;
   /* end of TO BE REMOVED WHEN VERSION_CONTROL WILL BE SUPPORTED */

   l_ret_code := UNAPIGEN.AddObjectComment(a_object_tp,
                                           a_object_id,
                                           a_object_version,
                                           a_comment);
   RETURN(l_ret_code);
END AddObjectComment;

END pbapigen ;
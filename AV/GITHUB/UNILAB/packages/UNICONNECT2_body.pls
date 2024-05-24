create or replace PACKAGE BODY
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
uniconnect2 AS

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

CURSOR l_sc_cursor (a_sc VARCHAR2) IS
   SELECT sc
   FROM utsc
   WHERE sc = a_sc;

--private package variable for [pa] section
p_pa_pgnode_setinsection      BOOLEAN DEFAULT FALSE;

FUNCTION GetVersion
   RETURN VARCHAR2
IS
BEGIN
   RETURN('06.07.00.00_00.13');
EXCEPTION
   WHEN OTHERS THEN
      RETURN (NULL);
END GetVersion;

/*------------------------------------------------------*/
/* procedures and functions related to the [sc] section */
/*------------------------------------------------------*/
PROCEDURE UCON_InitialiseScSection
IS

BEGIN

   --local section variables initialisation
   UNICONNECT.P_SC_SC := NULL;
   UNICONNECT.P_SC_ST := NULL;
   UNICONNECT.P_SC_ST_VERSION := NULL;
   UNICONNECT.P_SC_REF_DATE := CURRENT_TIMESTAMP;
   UNICONNECT.P_SC_USER_ID := UNAPIGEN.P_USER;
   UNICONNECT.P_SC_COMMENT := NULL;
   UNICONNECT.P_SC_ADD_COMMENT := NULL;
   UNICONNECT.P_SC_SS := NULL;
   UNICONNECT.P_SC_COPY_FROM := NULL;
   UNICONNECT.P_SC_LAST_SC := UNICONNECT.P_GLOB_SC; --special variable: never resetted

   --global variables
   UNICONNECT.P_GLOB_SC := NULL;

   --section internal variables initialisoation
   UNICONNECT.P_SC_FIELDNR_OF_ROWS := 0;
   UNICONNECT.P_SELSC_COL_NR_OF_ROWS := 0;
   UNICONNECT.P_SC_ST_MOD := FALSE;
   UNICONNECT.P_SC_ST_VERSION_MOD := FALSE;
   UNICONNECT.P_SC_REF_DATE_MOD := FALSE;
   UNICONNECT.P_SC_USER_ID_MOD := FALSE;

END UCON_InitialiseScSection;

FUNCTION ScUseValue       /* INTERNAL */
(a_variable_name IN VARCHAR2,
 a_alt_value     IN VARCHAR2)
RETURN VARCHAR2 IS

BEGIN

   IF a_variable_name = 'st' THEN
      IF UNICONNECT.P_SC_ST_MOD THEN
         RETURN(UNICONNECT.P_SC_ST);
      END IF;
   ELSIF a_variable_name = 'st_version' THEN
      IF UNICONNECT.P_SC_ST_VERSION_MOD THEN
         RETURN(UNICONNECT.P_SC_ST_VERSION);
      END IF;
   ELSIF a_variable_name = 'ref_date' THEN
      IF UNICONNECT.P_SC_REF_DATE_MOD THEN
         RETURN(UNICONNECT.P_SC_REF_DATE);
      END IF;
   ELSIF a_variable_name = 'user_id' THEN
      IF UNICONNECT.P_SC_USER_ID_MOD THEN
         RETURN(UNICONNECT.P_SC_USER_ID);
      END IF;
   ELSE
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_HIGH,'      Invalid variable '||a_variable_name||' in ScUseValue');
      RAISE StpError;
   END IF;
   RETURN(a_alt_value);

END ScUseValue;

FUNCTION UCON_AssignScSectionRow       /* INTERNAL */
RETURN NUMBER IS

l_sc_dot_pos   INTEGER;

BEGIN

   UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NONE,'      Assigning value of variable '||UNICONNECT.P_VARIABLE_NAME||' in [sc] section');
   l_sc_dot_pos := INSTR(UNICONNECT.P_VARIABLE_NAME, '.');
   IF UNICONNECT.P_VARIABLE_NAME = 'st' THEN
      UNICONNECT.P_SC_ST := UNICONNECT.P_VARIABLE_VALUE;
      UNICONNECT.P_SC_ST_MOD := TRUE;
   ELSIF UNICONNECT.P_VARIABLE_NAME = 'st_version' THEN
      UNICONNECT.P_SC_ST_VERSION := UNICONNECT.P_VARIABLE_VALUE;
      UNICONNECT.P_SC_ST_VERSION_MOD := TRUE;
   ELSIF UNICONNECT.P_VARIABLE_NAME = 'ref_date' THEN
      UNICONNECT.P_SC_REF_DATE := UNICONNECT.P_VARIABLE_VALUE;
      UNICONNECT.P_SC_REF_DATE_MOD := TRUE;
   ELSIF UNICONNECT.P_VARIABLE_NAME = 'user_id' THEN
      UNICONNECT.P_SC_USER_ID := UNICONNECT.P_VARIABLE_VALUE;
      UNICONNECT.P_SC_USER_ID_MOD := TRUE;
   ELSIF UNICONNECT.P_VARIABLE_NAME = 'ss' THEN
      UNICONNECT.P_SC_SS := UNICONNECT.P_VARIABLE_VALUE;
   ELSIF UNICONNECT.P_VARIABLE_NAME = 'copy_from' THEN
      UNICONNECT.P_SC_COPY_FROM := UNICONNECT.P_VARIABLE_VALUE;
   --assumption: 1 field is provided in that order in a section
   --field_type=
   --field_name=
   --field_value=
   ELSIF UNICONNECT.P_VARIABLE_NAME = 'field_type' THEN
      UNICONNECT.P_SC_FIELDNR_OF_ROWS := UNICONNECT.P_SC_FIELDNR_OF_ROWS + 1;
      UNICONNECT.P_SC_FIELDTYPE_TAB(UNICONNECT.P_SC_FIELDNR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;
      UNICONNECT.P_SC_FIELDNAMES_TAB(UNICONNECT.P_SC_FIELDNR_OF_ROWS) := NULL;
      UNICONNECT.P_SC_FIELDVALUES_TAB(UNICONNECT.P_SC_FIELDNR_OF_ROWS) := NULL;
   ELSIF UNICONNECT.P_VARIABLE_NAME = 'field_name' THEN
      UNICONNECT.P_SC_FIELDNAMES_TAB(UNICONNECT.P_SC_FIELDNR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;
   ELSIF UNICONNECT.P_VARIABLE_NAME = 'field_value' THEN
      UNICONNECT.P_SC_FIELDVALUES_TAB(UNICONNECT.P_SC_FIELDNR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;
   ELSIF UNICONNECT.P_VARIABLE_NAME = 'comment' THEN
      UNICONNECT.P_SC_COMMENT := UNICONNECT.P_VARIABLE_VALUE;
   ELSIF UNICONNECT.P_VARIABLE_NAME = 'add_comment' THEN
      UNICONNECT.P_SC_ADD_COMMENT := UNICONNECT.P_VARIABLE_VALUE;
   ELSIF UNICONNECT.P_VARIABLE_NAME IN ('sc', 'sc.sc') THEN
      UNICONNECT.P_SC_SC := UNICONNECT.P_VARIABLE_VALUE;
   ELSIF l_sc_dot_pos <> 0 THEN
      UNICONNECT.P_SELSC_COL_NR_OF_ROWS := UNICONNECT.P_SELSC_COL_NR_OF_ROWS + 1;
      UNICONNECT.P_SELSC_COL_TP_TAB(UNICONNECT.P_SELSC_COL_NR_OF_ROWS) := SUBSTR(UNICONNECT.P_VARIABLE_NAME, 1 , l_sc_dot_pos-1);
      UNICONNECT.P_SELSC_COL_ID_TAB(UNICONNECT.P_SELSC_COL_NR_OF_ROWS) := SUBSTR(UNICONNECT.P_VARIABLE_NAME, l_sc_dot_pos+1);
      UNICONNECT.P_SELSC_COL_VALUE_TAB(UNICONNECT.P_SELSC_COL_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;
   ELSE
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_HIGH,'      Invalid variable '||UNICONNECT.P_VARIABLE_NAME||' in [sc] section');
      RETURN(UNAPIGEN.DBERR_INVALIDVARIABLE);
   END IF;
   RETURN(UNAPIGEN.DBERR_SUCCESS);

END UCON_AssignScSectionRow;

FUNCTION UCON_ExecuteScSection       /* INTERNAL */
RETURN NUMBER IS

l_dyn_cursor  INTEGER;
l_sc          VARCHAR2(20);

CURSOR l_utsc_cursor (a_sc VARCHAR2) IS
   SELECT *
   FROM utsc
   WHERE sc = a_sc;

l_utsc_rec   l_utsc_cursor%ROWTYPE;

--local variables for SaveSample
l_savsc_sc                          VARCHAR2(20);
l_savsc_st                          VARCHAR2(20);
l_savsc_st_version                  VARCHAR2(20);
l_savsc_description                 VARCHAR2(40);
l_savsc_shelf_life_val              NUMBER;
l_savsc_shelf_life_unit             VARCHAR2(20);
l_savsc_sampling_date               TIMESTAMP WITH TIME ZONE;
l_savsc_creation_date               TIMESTAMP WITH TIME ZONE;
l_savsc_created_by                  VARCHAR2(20);
l_savsc_exec_start_date             TIMESTAMP WITH TIME ZONE;
l_savsc_exec_end_date               TIMESTAMP WITH TIME ZONE;
l_savsc_priority                    NUMBER;
l_savsc_label_format                VARCHAR2(20);
l_savsc_descr_doc                   VARCHAR2(40);
l_savsc_descr_doc_version           VARCHAR2(20);
l_savsc_rq                          VARCHAR2(20);
l_savsc_sd                          VARCHAR2(20);
l_savsc_date1                       TIMESTAMP WITH TIME ZONE;
l_savsc_date2                       TIMESTAMP WITH TIME ZONE;
l_savsc_date3                       TIMESTAMP WITH TIME ZONE;
l_savsc_date4                       TIMESTAMP WITH TIME ZONE;
l_savsc_date5                       TIMESTAMP WITH TIME ZONE;
l_savsc_allow_any_pp                CHAR(1);
l_savsc_sc_class                    VARCHAR2(2);
l_savsc_log_hs                      CHAR(1);
l_savsc_log_hs_details              CHAR(1);
l_savsc_lc                          VARCHAR2(2);
l_savsc_lc_version                  VARCHAR2(20);
l_savsc_modify_reason               VARCHAR2(255);

/* AUXILIARY function */
   FUNCTION CreateOrCopySample
   RETURN NUMBER IS
   BEGIN
      IF UNICONNECT.P_SC_COPY_FROM IS NULL THEN
         --CreateSample using local variables + INITIALISE global variable SC
         l_ret_code := UNAPISC.CreateSample(UNICONNECT.P_SC_ST,
                                            UNICONNECT.P_SC_ST_VERSION,
                                            UNICONNECT.P_SC_SC,
                                            UNICONNECT.P_SC_REF_DATE,
                                            '',
                                            '',
                                            UNICONNECT.P_SC_USER_ID,
                                            UNICONNECT.P_SC_FIELDTYPE_TAB,
                                            UNICONNECT.P_SC_FIELDNAMES_TAB,
                                            UNICONNECT.P_SC_FIELDVALUES_TAB,
                                            UNICONNECT.P_SC_FIELDNR_OF_ROWS,
                                            UNICONNECT.P_SC_COMMENT);

         UNICONNECT.P_GLOB_SC := UNICONNECT.P_SC_SC;
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         CreateSample ret_code='||l_ret_code||'#st='||UNICONNECT.P_SC_ST||'#st_version='||UNICONNECT.P_SC_ST_VERSION||'#sc='||UNICONNECT.P_SC_SC);
         FOR l_fieldnr IN 1..UNICONNECT.P_SC_FIELDNR_OF_ROWS  LOOP
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'            #field('||l_fieldnr||')#field_type='||UNICONNECT.P_SC_FIELDTYPE_TAB(l_fieldnr)||'#field_name='||UNICONNECT.P_SC_FIELDNAMES_TAB(l_fieldnr)||'#field_value='||UNICONNECT.P_SC_FIELDVALUES_TAB(l_fieldnr));
         END LOOP;
      ELSE
         --Translate copy_from=~Current~
         IF UNICONNECT.P_SC_COPY_FROM = '~Current~' THEN
            UNICONNECT.P_SC_COPY_FROM := UNICONNECT.P_SC_LAST_SC;
         END IF;
         --CopySample using local variables + INITIALISE global variable SC
         l_ret_code := UNAPISC.CopySample(UNICONNECT.P_SC_COPY_FROM,
                                          UNICONNECT.P_SC_ST,
                                          UNICONNECT.P_SC_ST_VERSION,
                                          UNICONNECT.P_SC_SC,
                                          UNICONNECT.P_SC_REF_DATE,
                                          'COPY IC COPY IIVALUE',
                                          'COPY PG',
                                          UNICONNECT.P_SC_USER_ID,
                                          UNICONNECT.P_SC_COMMENT);
         UNICONNECT.P_GLOB_SC := UNICONNECT.P_SC_SC;
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         CopySample ret_code='||l_ret_code||'#sc_from='||UNICONNECT.P_SC_COPY_FROM||'#st='||UNICONNECT.P_SC_ST||'#st_version='||UNICONNECT.P_SC_ST_VERSION||'#sc='||UNICONNECT.P_SC_SC);
      END IF;
      RETURN(l_ret_code);
   END CreateOrCopySample;

   FUNCTION AnyScStdPropModified
   RETURN BOOLEAN IS
   BEGIN
      IF UNICONNECT.P_SC_ST_MOD THEN
         RETURN(TRUE);
      ELSIF UNICONNECT.P_SC_ST_VERSION_MOD THEN
         RETURN(TRUE);
      ELSIF UNICONNECT.P_SC_REF_DATE_MOD THEN
         RETURN(TRUE);
      ELSIF UNICONNECT.P_SC_USER_ID_MOD THEN
         RETURN(TRUE);
      END IF;
      RETURN(FALSE);
   END AnyScStdPropModified;

   FUNCTION ChangeScStatusOrCancel
   RETURN NUMBER
   IS

   l_ret_code                    INTEGER;
   --Specific local variables for ChangeSc and CancelSc
   l_sc                          VARCHAR2(20);
   l_old_ss                      VARCHAR2(2);
   l_new_ss                      VARCHAR2(2);
   l_lc                          VARCHAR2(2);
   l_lc_version                  VARCHAR2(20);
   l_modify_reason               VARCHAR2(255);

   --Specific local variables for InsertEvent
   l_seq_nr                      NUMBER;
   l_st_version                  VARCHAR2(20);

   --
   l_tmp_retrieswhenintransition  INTEGER;
   l_tmp_intervalwhenintransition NUMBER;

   BEGIN

   -- IN and IN OUT arguments
   l_sc := UNICONNECT.P_SC_SC;
   l_old_ss := NULL;
   l_new_ss := UNICONNECT.P_SC_SS;
   l_lc := NULL;
   l_lc_version := NULL;
   l_modify_reason := UNICONNECT.P_SC_COMMENT;
   l_ret_code := UNAPIGEN.DBERR_SUCCESS;

   l_ret_code := UNICONNECT7.UCON_CheckElecSignature(l_new_ss);
   IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
     RETURN(l_ret_code);
   END IF;
   --reduce the time-out for in-transition objects (retsored at the end) to 400 ms
   l_tmp_retrieswhenintransition := UNAPIEV.P_RETRIESWHENINTRANSITION;
   l_tmp_intervalwhenintransition := UNAPIEV.P_INTERVALWHENINTRANSITION;
   --UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         In-transition interval is:'||UNAPIEV.P_RETRIESWHENINTRANSITION||' retries with a wait of '||UNAPIEV.P_INTERVALWHENINTRANSITION||' second(s)');
   UNAPIEV.P_RETRIESWHENINTRANSITION  := UNICONNECT.P_CSS_RETRIESWHENINTRANSITION;
   UNAPIEV.P_INTERVALWHENINTRANSITION := UNICONNECT.P_CSS_INTERVALWHENINTRANSITION;
   --UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         In-transition interval set to:'||UNAPIEV.P_RETRIESWHENINTRANSITION||' retries with a wait of '||UNAPIEV.P_INTERVALWHENINTRANSITION||' second(s)');

   IF l_new_ss <> '@C' THEN
      l_ret_code := UNAPISCP.ChangeScStatus (l_sc, l_old_ss, l_new_ss, l_lc, l_lc_version, l_modify_reason);

      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         ChangeScStatus ret_code='||l_ret_code||
                                '#sc='||l_sc||'#old_ss='||l_old_ss||'#new_ss='||l_new_ss);
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         lc='||l_lc||'#lc_version='||l_lc_version);
   ELSIF l_new_ss = '@C' THEN
      l_ret_code := UNAPISCP.CancelSc (l_sc, l_modify_reason);
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         CancelSc ret_code='||l_ret_code||
                                '#sc='||l_sc);
   END IF;
   IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NORMAL,'         CancelSc/ChSs failed:ret_code='||l_ret_code||
                                '#sc='||l_sc||'. Event will be sent instead.');
      IF UNAPIAUT.P_NOT_AUTHORISED IS NOT NULL THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NORMAL,'         Authorisation error='||UNAPIAUT.P_NOT_AUTHORISED);
      END IF;
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_SUCCESS; --to be sure that no rollback is taking place on EndTransaction
      --InsertEvent SampleUpdated with ss_to=<new status>
      l_seq_nr := NULL;
      SELECT st_version
      INTO l_st_version
      FROM utsc
      WHERE sc = l_sc;
      l_ret_code := UNAPIEV.InsertEvent
                      (a_api_name          => 'ChangeScStatusOrCancel',
                       a_evmgr_name        => UNAPIGEN.P_EVMGR_NAME,
                       a_object_tp         => 'sc',
                       a_object_id         => l_sc,
                       a_object_lc         => NULL,
                       a_object_lc_version => NULL,
                       a_object_ss         => NULL,
                       a_ev_tp             => 'SampleUpdated',
                       a_ev_details        => 'st_version='||l_st_version||'#ss_to='||l_new_ss,
                       a_seq_nr            => l_seq_nr);
      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         InsertEvent failed ret_code='||l_ret_code);
      ELSE
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW  ,'         InsertEvent OK');
      END IF;
   END IF;
   --restore original time-out for in-transition objects
   UNAPIEV.P_RETRIESWHENINTRANSITION  := l_tmp_retrieswhenintransition;
   UNAPIEV.P_INTERVALWHENINTRANSITION := l_tmp_intervalwhenintransition;
   --UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         In-transition interval restored to:'||UNAPIEV.P_RETRIESWHENINTRANSITION||' retries with a wait of '||UNAPIEV.P_INTERVALWHENINTRANSITION||' second(s)');

   RETURN(l_ret_code);
   EXCEPTION
   WHEN OTHERS THEN
      --restore original time-out for in-transition objects
      UNAPIEV.P_RETRIESWHENINTRANSITION  := l_tmp_retrieswhenintransition;
      UNAPIEV.P_INTERVALWHENINTRANSITION := l_tmp_intervalwhenintransition;
      --UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         In-transition interval restored to:'||UNAPIEV.P_RETRIESWHENINTRANSITION||' retries with a wait of '||UNAPIEV.P_INTERVALWHENINTRANSITION||' second(s)');
      RAISE;
   END ChangeScStatusOrCancel;

BEGIN
   /* Select create_sc */

   /* Case Y */
   IF UNICONNECT.P_SET_CREATE_SC = 'Y' THEN

      --minimal checking : sample code < 20 characters
      IF LENGTH(UNICONNECT.P_SC_SC)>20 THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Sample code too long !');
         RETURN(UNAPIGEN.DBERR_INVALIDID);
      END IF;

      --CreateOrCopySample using local variables + INITIALISE global variable SC
      l_ret_code := CreateOrCopySample;
      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         RETURN(l_ret_code);
      END IF;
   /* Case N,W */
   ELSE

      /* Select <Syntax used> */
      /* 3 possible cases = sample code ; SELECT statement ; Selection list */

      /* SELECT statement */
      IF UPPER(LTRIM(SUBSTR(UNICONNECT.P_SC_SC,1,6))) = 'SELECT' THEN
         /* sc = select statement */
         /* execute SQL statement and fetch first row */
         /* assumption for this query : the first selected column has datatype VARCHAR2(20) */

         BEGIN
            l_sc := NULL;
            l_sql_string := UNICONNECT.P_SC_SC;
            l_dyn_cursor := DBMS_SQL.OPEN_CURSOR;
            DBMS_SQL.PARSE(l_dyn_cursor, l_sql_string, DBMS_SQL.V7); -- NO single quote handling required (???)
            DBMS_SQL.DEFINE_COLUMN( l_dyn_cursor, 1, l_sc, 20);
            l_result := DBMS_SQL.EXECUTE_AND_FETCH(l_dyn_cursor);
            IF l_result > 0 THEN
               DBMS_SQL.COLUMN_VALUE( l_dyn_cursor, 1, l_sc);
            END IF;
            DBMS_SQL.CLOSE_CURSOR(l_dyn_cursor);
         EXCEPTION
         WHEN OTHERS THEN
            DBMS_SQL.CLOSE_CURSOR(l_dyn_cursor);
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Error while executing following SELECT statement');
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,l_sql_string);
            l_sqlerrm := SQLERRM;
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         '||l_sqlerrm);
            RETURN(UNAPIGEN.DBERR_GENFAIL);
         END;

         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Sample found by query :'||l_sc);
         UNICONNECT.P_SC_SC := l_sc;
         UNICONNECT.P_GLOB_SC := l_sc;

      ELSIF UNICONNECT.P_SELSC_COL_NR_OF_ROWS > 0 THEN
         /* sc = selection list */
         /* SelectSample call */
         l_sc := NULL;
         UNICONNECT.P_SC_SC := l_sc;
         UNICONNECT.P_GLOB_SC := l_sc;

         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Sample searched by Selection list :');
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         '||UNICONNECT.P_SELSC_COL_NR_OF_ROWS||'Item(s) in selection list');
         FOR l_row IN 1..UNICONNECT.P_SELSC_COL_NR_OF_ROWS LOOP
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'            '||UNICONNECT.P_SELSC_COL_TP_TAB(l_row)||'.'||
                                                   UNICONNECT.P_SELSC_COL_ID_TAB(l_row)||'='||
                                                   UNICONNECT.P_SELSC_COL_VALUE_TAB(l_row));
         END LOOP;

         --Call SelectSample with a_next_rows = 0
         UNICONNECT.P_SELSC_NR_OF_ROWS := 1;
         UNICONNECT.P_SELSC_NEXT_ROWS := 0;
         UNICONNECT.P_SELSC_ORDER_BY_CLAUSE := '';
         l_return := UNAPISC.SelectSample
                         (UNICONNECT.P_SELSC_COL_ID_TAB,
                          UNICONNECT.P_SELSC_COL_TP_TAB,
                          UNICONNECT.P_SELSC_COL_VALUE_TAB,
                          UNICONNECT.P_SELSC_COL_NR_OF_ROWS,
                          UNICONNECT.P_SELSC_SC_TAB,
                          UNICONNECT.P_SELSC_ST_TAB,
                          UNICONNECT.P_SELSC_ST_VERSION_TAB,
                          UNICONNECT.P_SELSC_DESCRIPTION_TAB,
                          UNICONNECT.P_SELSC_SHELF_LIFE_VAL_TAB,
                          UNICONNECT.P_SELSC_SHELF_LIFE_UNIT_TAB,
                          UNICONNECT.P_SELSC_SAMPLING_DATE_TAB,
                          UNICONNECT.P_SELSC_CREATION_DATE_TAB,
                          UNICONNECT.P_SELSC_CREATED_BY_TAB,
                          UNICONNECT.P_SELSC_EXEC_START_DATE_TAB,
                          UNICONNECT.P_SELSC_EXEC_END_DATE_TAB,
                          UNICONNECT.P_SELSC_PRIORITY_TAB,
                          UNICONNECT.P_SELSC_LABEL_FORMAT_TAB,
                          UNICONNECT.P_SELSC_DESCR_DOC_TAB,
                          UNICONNECT.P_SELSC_DESCR_DOC_VERSION_TAB,
                          UNICONNECT.P_SELSC_RQ_TAB,
                          UNICONNECT.P_SELSC_SD_TAB,
                          UNICONNECT.P_SELSC_DATE1_TAB,
                          UNICONNECT.P_SELSC_DATE2_TAB,
                          UNICONNECT.P_SELSC_DATE3_TAB,
                          UNICONNECT.P_SELSC_DATE4_TAB,
                          UNICONNECT.P_SELSC_DATE5_TAB,
                          UNICONNECT.P_SELSC_ALLOW_ANY_PP_TAB,
                          UNICONNECT.P_SELSC_SC_CLASS_TAB,
                          UNICONNECT.P_SELSC_LOG_HS_TAB,
                          UNICONNECT.P_SELSC_LOG_HS_DETAILS_TAB,
                          UNICONNECT.P_SELSC_ALLOW_MODIFY_TAB,
                          UNICONNECT.P_SELSC_AR_TAB,
                          UNICONNECT.P_SELSC_ACTIVE_TAB,
                          UNICONNECT.P_SELSC_LC_TAB,
                          UNICONNECT.P_SELSC_LC_VERSION_TAB,
                          UNICONNECT.P_SELSC_SS_TAB,
                          UNICONNECT.P_SELSC_NR_OF_ROWS,
                          UNICONNECT.P_SELSC_ORDER_BY_CLAUSE,
                          UNICONNECT.P_SELSC_NEXT_ROWS);
         IF l_return = UNAPIGEN.DBERR_SUCCESS THEN
            l_sc := UNICONNECT.P_SELSC_SC_TAB(1);
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Sample found by Selection list :'||l_sc);

            --Call SelectSample with a_next_rows = -1 to close opened cursor
            UNICONNECT.P_SELSC_NEXT_ROWS := -1;
            l_return := UNAPISC.SelectSample
                            (UNICONNECT.P_SELSC_COL_ID_TAB,
                             UNICONNECT.P_SELSC_COL_TP_TAB,
                             UNICONNECT.P_SELSC_COL_VALUE_TAB,
                             UNICONNECT.P_SELSC_COL_NR_OF_ROWS,
                             UNICONNECT.P_SELSC_SC_TAB,
                             UNICONNECT.P_SELSC_ST_TAB,
                             UNICONNECT.P_SELSC_ST_VERSION_TAB,
                             UNICONNECT.P_SELSC_DESCRIPTION_TAB,
                             UNICONNECT.P_SELSC_SHELF_LIFE_VAL_TAB,
                             UNICONNECT.P_SELSC_SHELF_LIFE_UNIT_TAB,
                             UNICONNECT.P_SELSC_SAMPLING_DATE_TAB,
                             UNICONNECT.P_SELSC_CREATION_DATE_TAB,
                             UNICONNECT.P_SELSC_CREATED_BY_TAB,
                             UNICONNECT.P_SELSC_EXEC_START_DATE_TAB,
                             UNICONNECT.P_SELSC_EXEC_END_DATE_TAB,
                             UNICONNECT.P_SELSC_PRIORITY_TAB,
                             UNICONNECT.P_SELSC_LABEL_FORMAT_TAB,
                             UNICONNECT.P_SELSC_DESCR_DOC_TAB,
                             UNICONNECT.P_SELSC_DESCR_DOC_VERSION_TAB,
                             UNICONNECT.P_SELSC_RQ_TAB,
                             UNICONNECT.P_SELSC_SD_TAB,
                             UNICONNECT.P_SELSC_DATE1_TAB,
                             UNICONNECT.P_SELSC_DATE2_TAB,
                             UNICONNECT.P_SELSC_DATE3_TAB,
                             UNICONNECT.P_SELSC_DATE4_TAB,
                             UNICONNECT.P_SELSC_DATE5_TAB,
                             UNICONNECT.P_SELSC_ALLOW_ANY_PP_TAB,
                             UNICONNECT.P_SELSC_SC_CLASS_TAB,
                             UNICONNECT.P_SELSC_LOG_HS_TAB,
                             UNICONNECT.P_SELSC_LOG_HS_DETAILS_TAB,
                             UNICONNECT.P_SELSC_ALLOW_MODIFY_TAB,
                             UNICONNECT.P_SELSC_AR_TAB,
                             UNICONNECT.P_SELSC_ACTIVE_TAB,
                             UNICONNECT.P_SELSC_LC_TAB,
                             UNICONNECT.P_SELSC_LC_VERSION_TAB,
                             UNICONNECT.P_SELSC_SS_TAB,
                             UNICONNECT.P_SELSC_NR_OF_ROWS,
                             UNICONNECT.P_SELSC_ORDER_BY_CLAUSE,
                             UNICONNECT.P_SELSC_NEXT_ROWS);

            IF l_return <> UNAPIGEN.DBERR_SUCCESS THEN
               UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         SelectSample call with a_next_rows=-1 failed ! ret_code='||TO_CHAR(l_return));
            END IF;
         ELSE
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_HIGH,'         No Sample found by using Selection list ret_code='||TO_CHAR(l_return));
         END IF;

         IF l_sc IS NOT NULL THEN
            UNICONNECT.P_SC_SC := l_sc;
            UNICONNECT.P_GLOB_SC := l_sc;
         END IF;

      ELSE
         /* sc = sample code */
         /* check if sc is existing */
         l_sc := NULL;
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Sample directly searched:'||UNICONNECT.P_SC_SC);
         OPEN l_sc_cursor(UNICONNECT.P_SC_SC);
         FETCH l_sc_cursor
         INTO l_sc;
         CLOSE l_sc_cursor;
         IF l_sc IS NOT NULL THEN
            UNICONNECT.P_SC_SC := l_sc;
            UNICONNECT.P_GLOB_SC := l_sc;
         END IF;

         --Tracing
         IF l_sc IS NULL THEN
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NORMAL,'         Sample :'||UNICONNECT.P_SC_SC||' not found !' );
         ELSE
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Sample :'||UNICONNECT.P_SC_SC||' found : OK ' );
         END IF;

      END IF;
      /* End Case */

      /* sc found ? */
      IF UNICONNECT.P_GLOB_SC IS NOT NULL THEN
         /* YES */
         /* Initialise specific local variables for SaveSample */
         /* Any standard property modified in section ? */
         /* overrule local variables for Savesample with local section values when specified */
         /* Call SaveSample */
         OPEN l_utsc_cursor(UNICONNECT.P_GLOB_SC);
         FETCH l_utsc_cursor
         INTO l_utsc_rec;
         CLOSE l_utsc_cursor;

         IF AnyScStdPropModified THEN

            --always use record value (can not be set in section)
            l_savsc_sc                          := l_utsc_rec.sc;
            l_savsc_description                 := l_utsc_rec.description;
            l_savsc_shelf_life_val              := l_utsc_rec.shelf_life_val;
            l_savsc_shelf_life_unit             := l_utsc_rec.shelf_life_unit;
            l_savsc_creation_date               := l_utsc_rec.creation_date;
            l_savsc_exec_start_date             := l_utsc_rec.exec_start_date;
            l_savsc_exec_end_date               := l_utsc_rec.exec_end_date;
            l_savsc_priority                    := l_utsc_rec.priority;
            l_savsc_label_format                := l_utsc_rec.label_format;
            l_savsc_descr_doc                   := l_utsc_rec.descr_doc;
            l_savsc_descr_doc_version           := l_utsc_rec.descr_doc_version;
            l_savsc_rq                          := l_utsc_rec.rq;
            l_savsc_sd                          := l_utsc_rec.sd;
            l_savsc_date1                       := l_utsc_rec.date1;
            l_savsc_date2                       := l_utsc_rec.date2;
            l_savsc_date3                       := l_utsc_rec.date3;
            l_savsc_date4                       := l_utsc_rec.date4;
            l_savsc_date5                       := l_utsc_rec.date5;
            l_savsc_allow_any_pp                := l_utsc_rec.allow_any_pp;
            l_savsc_sc_class                    := l_utsc_rec.sc_class;
            l_savsc_log_hs                      := l_utsc_rec.log_hs;
            l_savsc_log_hs_details              := l_utsc_rec.log_hs_details;
            l_savsc_lc                          := l_utsc_rec.lc;
            l_savsc_lc_version                  := l_utsc_rec.lc_version;

            --use provided comment in section
            l_savsc_modify_reason               := UNICONNECT.P_SC_COMMENT;

            --overule when set in section
            l_savsc_st                          := ScUseValue('st'           , l_utsc_rec.st);
            l_savsc_st_version                  := ScUseValue('st_version'   , l_utsc_rec.st_version);
            l_savsc_sampling_date               := ScUseValue('ref_date'     , l_utsc_rec.sampling_date);
            l_savsc_created_by                  := ScUseValue('user_id'      , l_utsc_rec.created_by);
            -- SaveSample API will only be called for existing samples
            -- => st_version argument left empty

            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Calling SaveSample for :'||l_savsc_sc );

            l_ret_code := UNAPISC.SaveSample
                            (l_savsc_sc,
                             l_savsc_st,
                             l_savsc_st_version,
                             l_savsc_description,
                             l_savsc_shelf_life_val,
                             l_savsc_shelf_life_unit,
                             l_savsc_sampling_date,
                             l_savsc_creation_date,
                             l_savsc_created_by,
                             l_savsc_exec_start_date,
                             l_savsc_exec_end_date,
                             l_savsc_priority,
                             l_savsc_label_format,
                             l_savsc_descr_doc,
                             l_savsc_descr_doc_version,
                             l_savsc_rq,
                             l_savsc_sd,
                             l_savsc_date1,
                             l_savsc_date2,
                             l_savsc_date3,
                             l_savsc_date4,
                             l_savsc_date5,
                             l_savsc_allow_any_pp,
                             l_savsc_sc_class,
                             l_savsc_log_hs,
                             l_savsc_log_hs_details,
                             l_savsc_lc,
                             l_savsc_lc_version,
                             l_savsc_modify_reason);
            IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
               UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : SaveSample failed for :'
                                                     ||l_savsc_sc|| ' ret_code='||TO_CHAR(l_ret_code) );
               RETURN(l_ret_code);
            END IF;
         END IF;
      ELSE
         /* NO */

         /* create_sc=N ? */
         IF UNICONNECT.P_SET_CREATE_SC = 'N' THEN
            /* YES */
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         sample does not exist and can not be created');
            RETURN(UNAPIGEN.DBERR_GENFAIL);
         ELSE
            /* NO */
            --CreateOrCopySample using local variables + INITIALISE global variable SC
            l_ret_code := CreateOrCopySample;
            IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
               RETURN(l_ret_code);
            END IF;
         END IF;
      END IF;

   END IF;

   IF UNICONNECT.P_SC_SS IS NOT NULL THEN
      l_ret_code := ChangeScStatusOrCancel;
      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         RETURN(l_ret_code);
      END IF;
   END IF;

   IF UNICONNECT.P_SC_ADD_COMMENT IS NOT NULL THEN
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Adding comment on sample:'||UNICONNECT.P_SC_SC);
      l_ret_code := UNAPISCP.AddScComment(UNICONNECT.P_SC_SC, UNICONNECT.P_SC_ADD_COMMENT);
      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Adding comment on sample:'||UNICONNECT.P_SC_SC||'failed:'||l_ret_code);
         IF UNAPIAUT.P_NOT_AUTHORISED IS NOT NULL THEN
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         ' || UNAPIAUT.P_NOT_AUTHORISED );
         END IF;
         RETURN(l_ret_code);
      END IF;
   END IF;
   /* End Case */

   UNICONNECT2.WriteGlobalVariablesToLog;

   RETURN(UNAPIGEN.DBERR_SUCCESS);
END UCON_ExecuteScSection;

/*------------------------------------------------------*/
/* procedures and functions related to the [pg] section */
/*------------------------------------------------------*/
PROCEDURE UCON_InitialisePgSection     /* INTERNAL */
IS
BEGIN

   --local variables initialisation
   UNICONNECT.P_PG_NR_OF_ROWS := 0;
   UNICONNECT.P_PG_SC := UNICONNECT.P_GLOB_SC;
   UNICONNECT.P_PG_MODIFY_REASON :=NULL;

   --global variables
   UNICONNECT.P_GLOB_PG := NULL;
   UNICONNECT.P_GLOB_PGNODE := NULL;

END UCON_InitialisePgSection;

FUNCTION UCON_AssignPgSectionRow       /* INTERNAL */
RETURN NUMBER IS

l_description_pos      INTEGER;

BEGIN

   --Important assumption : one [pg] section is only related to one sample

   UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NONE,'      Assigning value of variable '||UNICONNECT.P_VARIABLE_NAME||' in [pg] section');
   IF UNICONNECT.P_VARIABLE_NAME = 'sc' THEN
      UNICONNECT.P_PG_SC := UNICONNECT.P_VARIABLE_VALUE;

   ELSIF UNICONNECT.P_VARIABLE_NAME = 'value_f' THEN
      UNICONNECT.P_PG_VALUE_F_TAB(UNICONNECT.P_PG_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;
      UNICONNECT.P_PG_VALUE_F_MODTAB(UNICONNECT.P_PG_NR_OF_ROWS) := TRUE;
      UNICONNECT.P_PG_MODIFY_FLAG_TAB(UNICONNECT.P_PG_NR_OF_ROWS) := UNAPIGEN.MOD_FLAG_UPDATE;
   ELSIF UNICONNECT.P_VARIABLE_NAME = 'value_s' THEN
      UNICONNECT.P_PG_VALUE_S_TAB(UNICONNECT.P_PG_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;
      UNICONNECT.P_PG_VALUE_S_MODTAB(UNICONNECT.P_PG_NR_OF_ROWS) := TRUE;
      UNICONNECT.P_PG_MODIFY_FLAG_TAB(UNICONNECT.P_PG_NR_OF_ROWS) := UNAPIGEN.MOD_FLAG_UPDATE;
   ELSIF UNICONNECT.P_VARIABLE_NAME = 'unit' THEN
      UNICONNECT.P_PG_UNIT_TAB(UNICONNECT.P_PG_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;
      UNICONNECT.P_PG_UNIT_MODTAB(UNICONNECT.P_PG_NR_OF_ROWS) := TRUE;
      UNICONNECT.P_PG_MODIFY_FLAG_TAB(UNICONNECT.P_PG_NR_OF_ROWS) := UNAPIGEN.MOD_FLAG_UPDATE;
   ELSIF UNICONNECT.P_VARIABLE_NAME = 'manually_entered' THEN
      UNICONNECT.P_PG_MANUALLY_ENTERED_TAB(UNICONNECT.P_PG_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;
      UNICONNECT.P_PG_MANUALLY_ENTERED_MODTAB(UNICONNECT.P_PG_NR_OF_ROWS) := TRUE;
      UNICONNECT.P_PG_MODIFY_FLAG_TAB(UNICONNECT.P_PG_NR_OF_ROWS) := UNAPIGEN.MOD_FLAG_UPDATE;
   ELSIF UNICONNECT.P_VARIABLE_NAME = 'exec_start_date' THEN
      UNICONNECT.P_PG_EXEC_START_DATE_TAB(UNICONNECT.P_PG_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;
      UNICONNECT.P_PG_EXEC_START_DATE_MODTAB(UNICONNECT.P_PG_NR_OF_ROWS) := TRUE;
      UNICONNECT.P_PG_MODIFY_FLAG_TAB(UNICONNECT.P_PG_NR_OF_ROWS) := UNAPIGEN.MOD_FLAG_UPDATE;
   ELSIF UNICONNECT.P_VARIABLE_NAME = 'exec_end_date' THEN
      UNICONNECT.P_PG_EXEC_END_DATE_TAB(UNICONNECT.P_PG_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;
      UNICONNECT.P_PG_EXEC_END_DATE_MODTAB(UNICONNECT.P_PG_NR_OF_ROWS) := TRUE;
      UNICONNECT.P_PG_MODIFY_FLAG_TAB(UNICONNECT.P_PG_NR_OF_ROWS) := UNAPIGEN.MOD_FLAG_UPDATE;
   ELSIF UNICONNECT.P_VARIABLE_NAME = 'executor' THEN
      UNICONNECT.P_PG_EXECUTOR_TAB(UNICONNECT.P_PG_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;
      UNICONNECT.P_PG_EXECUTOR_MODTAB(UNICONNECT.P_PG_NR_OF_ROWS) := TRUE;
      UNICONNECT.P_PG_MODIFY_FLAG_TAB(UNICONNECT.P_PG_NR_OF_ROWS) := UNAPIGEN.MOD_FLAG_UPDATE;
   ELSIF UNICONNECT.P_VARIABLE_NAME = 'comment' THEN
      UNICONNECT.P_PG_MODIFY_REASON := UNICONNECT.P_VARIABLE_VALUE;
      UNICONNECT.P_PG_MODIFY_FLAG_TAB(UNICONNECT.P_PG_NR_OF_ROWS) := UNAPIGEN.MOD_FLAG_UPDATE;
   ELSIF UNICONNECT.P_VARIABLE_NAME = 'add_comment' THEN
      UNICONNECT.P_PG_ADD_COMMENT_TAB(UNICONNECT.P_PG_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;
   ELSIF UNICONNECT.P_VARIABLE_NAME = 'ss' THEN
      UNICONNECT.P_PG_SS_TAB(UNICONNECT.P_PG_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;
      UNICONNECT.P_PG_SS_MODTAB(UNICONNECT.P_PG_NR_OF_ROWS) := TRUE;

   ELSIF UNICONNECT.P_VARIABLE_NAME = 'description' THEN
      UNICONNECT.P_PG_DESCRIPTION_TAB(UNICONNECT.P_PG_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;
      UNICONNECT.P_PG_DESCRIPTION_MODTAB(UNICONNECT.P_PG_NR_OF_ROWS) := TRUE;
      UNICONNECT.P_PG_MODIFY_FLAG_TAB(UNICONNECT.P_PG_NR_OF_ROWS) := UNAPIGEN.MOD_FLAG_UPDATE;

   ELSIF UNICONNECT.P_VARIABLE_NAME IN ('pgnode', 'pg.pgnode') THEN
      UNICONNECT.P_PG_PGNODE_TAB(UNICONNECT.P_PG_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;

   ELSIF UNICONNECT.P_VARIABLE_NAME IN ('pp_key1', 'pg.pp_key1') THEN
      UNICONNECT.P_PG_PP_KEY1_TAB(UNICONNECT.P_PG_NR_OF_ROWS) := NVL(UNICONNECT.P_VARIABLE_VALUE, ' ');

   ELSIF UNICONNECT.P_VARIABLE_NAME IN ('pp_key2', 'pg.pp_key2') THEN
      UNICONNECT.P_PG_PP_KEY2_TAB(UNICONNECT.P_PG_NR_OF_ROWS) := NVL(UNICONNECT.P_VARIABLE_VALUE, ' ');

   ELSIF UNICONNECT.P_VARIABLE_NAME IN ('pp_key3', 'pg.pp_key3') THEN
      UNICONNECT.P_PG_PP_KEY3_TAB(UNICONNECT.P_PG_NR_OF_ROWS) := NVL(UNICONNECT.P_VARIABLE_VALUE, ' ');

   ELSIF UNICONNECT.P_VARIABLE_NAME IN ('pp_key4', 'pg.pp_key4') THEN
      UNICONNECT.P_PG_PP_KEY4_TAB(UNICONNECT.P_PG_NR_OF_ROWS) := NVL(UNICONNECT.P_VARIABLE_VALUE, ' ');

   ELSIF UNICONNECT.P_VARIABLE_NAME IN ('pp_key5', 'pg.pp_key5') THEN
      UNICONNECT.P_PG_PP_KEY5_TAB(UNICONNECT.P_PG_NR_OF_ROWS) := NVL(UNICONNECT.P_VARIABLE_VALUE, ' ');

   ELSIF UNICONNECT.P_VARIABLE_NAME IN ('pp_version', 'pg.pp_version') THEN
      UNICONNECT.P_PG_PP_VERSION_TAB(UNICONNECT.P_PG_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;

   ELSIF SUBSTR(UNICONNECT.P_VARIABLE_NAME,1,2) = 'pg' THEN
      --MUST BE PLACED after pgnode variable assignment since SUBSTR will return pg
      --initialise full array except for sample code
      UNICONNECT.P_PG_NR_OF_ROWS := UNICONNECT.P_PG_NR_OF_ROWS + 1;

      --pg can be specified by description or by name
      l_description_pos := INSTR(UNICONNECT.P_VARIABLE_NAME, '.description');
      IF l_description_pos > 0 THEN
         UNICONNECT.P_PG_PGDESCRIPTION_TAB(UNICONNECT.P_PG_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;
         UNICONNECT.P_PG_PG_TAB(UNICONNECT.P_PG_NR_OF_ROWS) := NULL;
      ELSE
         UNICONNECT.P_PG_PG_TAB(UNICONNECT.P_PG_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;
         UNICONNECT.P_PG_PGDESCRIPTION_TAB(UNICONNECT.P_PG_NR_OF_ROWS) := NULL;
      END IF;

      UNICONNECT.P_PG_PGNAME_TAB(UNICONNECT.P_PG_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_NAME;

      UNICONNECT.P_PG_PGNODE_TAB(UNICONNECT.P_PG_NR_OF_ROWS)            := NULL;
      UNICONNECT.P_PG_PP_VERSION_TAB(UNICONNECT.P_PG_NR_OF_ROWS)        := NULL;
      UNICONNECT.P_PG_PP_KEY1_TAB(UNICONNECT.P_PG_NR_OF_ROWS)           := NULL;
      UNICONNECT.P_PG_PP_KEY2_TAB(UNICONNECT.P_PG_NR_OF_ROWS)           := NULL;
      UNICONNECT.P_PG_PP_KEY3_TAB(UNICONNECT.P_PG_NR_OF_ROWS)           := NULL;
      UNICONNECT.P_PG_PP_KEY4_TAB(UNICONNECT.P_PG_NR_OF_ROWS)           := NULL;
      UNICONNECT.P_PG_PP_KEY5_TAB(UNICONNECT.P_PG_NR_OF_ROWS)           := NULL;
      UNICONNECT.P_PG_DESCRIPTION_TAB(UNICONNECT.P_PG_NR_OF_ROWS)       := NULL;
      UNICONNECT.P_PG_VALUE_F_TAB(UNICONNECT.P_PG_NR_OF_ROWS)           := NULL;
      UNICONNECT.P_PG_VALUE_S_TAB(UNICONNECT.P_PG_NR_OF_ROWS)           := NULL;
      UNICONNECT.P_PG_UNIT_TAB(UNICONNECT.P_PG_NR_OF_ROWS)              := NULL;
      UNICONNECT.P_PG_MANUALLY_ENTERED_TAB(UNICONNECT.P_PG_NR_OF_ROWS)  := NULL;
      UNICONNECT.P_PG_EXEC_START_DATE_TAB(UNICONNECT.P_PG_NR_OF_ROWS)   := NULL;
      UNICONNECT.P_PG_EXEC_END_DATE_TAB(UNICONNECT.P_PG_NR_OF_ROWS)     := NULL;
      UNICONNECT.P_PG_EXECUTOR_TAB(UNICONNECT.P_PG_NR_OF_ROWS)          := NULL;
      UNICONNECT.P_PG_MODIFY_FLAG_TAB(UNICONNECT.P_PG_NR_OF_ROWS)       := UNAPIGEN.DBERR_SUCCESS;
      UNICONNECT.P_PG_SS_TAB(UNICONNECT.P_PG_NR_OF_ROWS)                := NULL;
      UNICONNECT.P_PG_ADD_COMMENT_TAB(UNICONNECT.P_PG_NR_OF_ROWS)       := NULL;

      --initialise all modify flags to FALSE
      UNICONNECT.P_PG_DESCRIPTION_MODTAB(UNICONNECT.P_PG_NR_OF_ROWS)          := FALSE;
      UNICONNECT.P_PG_VALUE_F_MODTAB(UNICONNECT.P_PG_NR_OF_ROWS)              := FALSE;
      UNICONNECT.P_PG_VALUE_S_MODTAB(UNICONNECT.P_PG_NR_OF_ROWS)              := FALSE;
      UNICONNECT.P_PG_UNIT_MODTAB(UNICONNECT.P_PG_NR_OF_ROWS)                 := FALSE;
      UNICONNECT.P_PG_EXEC_START_DATE_MODTAB(UNICONNECT.P_PG_NR_OF_ROWS)      := FALSE;
      UNICONNECT.P_PG_EXEC_END_DATE_MODTAB(UNICONNECT.P_PG_NR_OF_ROWS)        := FALSE;
      UNICONNECT.P_PG_EXECUTOR_MODTAB(UNICONNECT.P_PG_NR_OF_ROWS)             := FALSE;
      UNICONNECT.P_PG_MANUALLY_ENTERED_MODTAB(UNICONNECT.P_PG_NR_OF_ROWS)     := FALSE;
      UNICONNECT.P_PG_SS_MODTAB(UNICONNECT.P_PG_NR_OF_ROWS)                   := FALSE;

   ELSE
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'      Invalid variable '||UNICONNECT.P_VARIABLE_NAME||' in [pg] section');
      RETURN(UNAPIGEN.DBERR_INVALIDVARIABLE);
   END IF;
   RETURN(UNAPIGEN.DBERR_SUCCESS);

END UCON_AssignPgSectionRow;

--PgUseValue is an Overloaded function : one returning a NUMBER and the other one reurning VARCHAR2
--PgUseValue will return the value specified in the section when effectively set in the section
--A modify_flag is maintained for each variable within the section (see UCON_AssignPgSectionRow)
--The argument a_alt_value (read alternative value) will be returned when the variable has
--not been set (affected) in the section

FUNCTION PgUseValue       /* INTERNAL */
(a_variable_name IN VARCHAR2,
 a_row           IN INTEGER,
 a_alt_value     IN NUMBER)
RETURN NUMBER IS

BEGIN

   IF a_variable_name = 'value_f' THEN
      IF UNICONNECT.P_PG_VALUE_F_MODTAB(a_row) THEN
         RETURN(UNICONNECT.P_PG_VALUE_F_TAB(a_row));
      END IF;
   ELSE
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'      Invalid variable '||a_variable_name||' in PgUseValue');
      RAISE StpError;
   END IF;
   RETURN(a_alt_value);

END PgUseValue;

FUNCTION PgUseValue       /* INTERNAL */
(a_variable_name IN VARCHAR2,
 a_row           IN INTEGER,
 a_alt_value     IN VARCHAR2)
RETURN VARCHAR2 IS

BEGIN

   IF a_variable_name = 'description' THEN
      IF UNICONNECT.P_PG_DESCRIPTION_MODTAB(a_row) THEN
         RETURN(UNICONNECT.P_PG_DESCRIPTION_TAB(a_row));
      END IF;
   ELSIF a_variable_name = 'value_s' THEN
      IF UNICONNECT.P_PG_VALUE_S_MODTAB(a_row) THEN
         RETURN(UNICONNECT.P_PG_VALUE_S_TAB(a_row));
      END IF;
   ELSIF a_variable_name = 'unit' THEN
      IF UNICONNECT.P_PG_UNIT_MODTAB(a_row) THEN
         RETURN(UNICONNECT.P_PG_UNIT_TAB(a_row));
      END IF;
   ELSIF a_variable_name = 'exec_start_date' THEN
      IF UNICONNECT.P_PG_EXEC_START_DATE_MODTAB(a_row) THEN
         RETURN(UNICONNECT.P_PG_EXEC_START_DATE_TAB(a_row));
      END IF;
   ELSIF a_variable_name = 'exec_end_date' THEN
      IF UNICONNECT.P_PG_EXEC_END_DATE_MODTAB(a_row) THEN
         RETURN(UNICONNECT.P_PG_EXEC_END_DATE_TAB(a_row));
      END IF;
   ELSIF a_variable_name = 'executor' THEN
      IF UNICONNECT.P_PG_EXECUTOR_MODTAB(a_row) THEN
         RETURN(UNICONNECT.P_PG_EXECUTOR_TAB(a_row));
      END IF;
   ELSIF a_variable_name = 'manually_entered' THEN
      IF UNICONNECT.P_PG_MANUALLY_ENTERED_MODTAB(a_row) THEN
         RETURN(UNICONNECT.P_PG_MANUALLY_ENTERED_TAB(a_row));
      END IF;
   ELSE
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'      Invalid variable '||a_variable_name||' in PgUseValue');
      RAISE StpError;
   END IF;
   RETURN(a_alt_value);

END PgUseValue;

--FindScPg returns the utscpg record corresponding
--to a specific search syntax
-- Examples :
-- pg or pg.pg    => a_pos=1 a_search_base='pg' => find first a_pg ORDER BY pgnode
-- pg.description => a_pos=1 a_search_base='pg' => find first a_pg using this description ORDER BY pgnode
-- pg[2] or pg[2].description  => a_pos=2 a_search_base='description' => find 2nd a_pg using this description ORDER BY pgnode
-- pg[] => a_pos=1 a_search_base='description' => find 1st a_pg which is not executed using this description ORDER BY pgnode
--
-- pp_key[1-5] is NULL when not specified in section => any value is matching
-- pp_key[1-5] = space when specified in section but empty => that key must be a blank
-- pp_key[1-5] = space when specified in section and not empty => that key must match
--
FUNCTION FindScPg (a_sc          IN     VARCHAR2,
                   a_pg          IN OUT VARCHAR2,
                   a_description IN     VARCHAR2,
                   a_pgnode      IN     NUMBER,
                   a_pp_key1     IN     VARCHAR2,
                   a_pp_key2     IN     VARCHAR2,
                   a_pp_key3     IN     VARCHAR2,
                   a_pp_key4     IN     VARCHAR2,
                   a_pp_key5     IN     VARCHAR2,
                   a_pp_version  IN     VARCHAR2,
                   a_search_base IN     VARCHAR2,
                   a_pos         IN INTEGER,
                   a_current_row IN INTEGER)
RETURN utscpg%ROWTYPE IS

l_pg_rec       utscpg%ROWTYPE;
l_leave_loop   BOOLEAN DEFAULT FALSE;
l_used         BOOLEAN DEFAULT FALSE;
l_counter      INTEGER;

--DECODE explained: when pgnode is knwown, all pp_keys are ignored
--                  when pp_keyx is not specified in the section, any value of pp_key in utscpg is matching
--This will be typically customised in project where only generic results are delivered by Uniconnect
--the where_clause will be typically extended with a condition excluding customer/supplier specific pg
CURSOR l_scpg_cursor IS
   SELECT *
   FROM utscpg
   WHERE sc = a_sc
   AND pg = a_pg
   AND pgnode = NVL(a_pgnode,pgnode)
   AND pp_key1 = DECODE(a_pgnode, NULL, DECODE(a_pp_key1, NULL, pp_key1, a_pp_key1), pp_key1)
   AND pp_key2 = DECODE(a_pgnode, NULL, DECODE(a_pp_key2, NULL, pp_key2, a_pp_key2), pp_key2)
   AND pp_key3 = DECODE(a_pgnode, NULL, DECODE(a_pp_key3, NULL, pp_key3, a_pp_key3), pp_key3)
   AND pp_key4 = DECODE(a_pgnode, NULL, DECODE(a_pp_key4, NULL, pp_key4, a_pp_key4), pp_key4)
   AND pp_key5 = DECODE(a_pgnode, NULL, DECODE(a_pp_key5, NULL, pp_key5, a_pp_key5), pp_key5)
   AND NVL(pp_version, '0') = NVL(a_pp_version, NVL(pp_version, '0'))
   ORDER BY pgnode ASC;

CURSOR l_scpg_notexecuted_cursor IS
   SELECT *
   FROM utscpg
   WHERE sc = a_sc
   AND pg = a_pg
   AND pgnode = NVL(a_pgnode,pgnode)
   AND pp_key1 = DECODE(a_pgnode, NULL, DECODE(a_pp_key1, NULL, pp_key1, a_pp_key1), pp_key1)
   AND pp_key2 = DECODE(a_pgnode, NULL, DECODE(a_pp_key2, NULL, pp_key2, a_pp_key2), pp_key2)
   AND pp_key3 = DECODE(a_pgnode, NULL, DECODE(a_pp_key3, NULL, pp_key3, a_pp_key3), pp_key3)
   AND pp_key4 = DECODE(a_pgnode, NULL, DECODE(a_pp_key4, NULL, pp_key4, a_pp_key4), pp_key4)
   AND pp_key5 = DECODE(a_pgnode, NULL, DECODE(a_pp_key5, NULL, pp_key5, a_pp_key5), pp_key5)
   AND NVL(pp_version, '0') = NVL(a_pp_version, NVL(pp_version, '0'))
   AND exec_end_date IS NULL
   ORDER BY pgnode ASC;

CURSOR l_scpgdesc_cursor IS
   SELECT *
   FROM utscpg
   WHERE sc = a_sc
   AND description = a_description
   AND pgnode = NVL(a_pgnode,pgnode)
   AND pp_key1 = DECODE(a_pgnode, NULL, DECODE(a_pp_key1, NULL, pp_key1, a_pp_key1), pp_key1)
   AND pp_key2 = DECODE(a_pgnode, NULL, DECODE(a_pp_key2, NULL, pp_key2, a_pp_key2), pp_key2)
   AND pp_key3 = DECODE(a_pgnode, NULL, DECODE(a_pp_key3, NULL, pp_key3, a_pp_key3), pp_key3)
   AND pp_key4 = DECODE(a_pgnode, NULL, DECODE(a_pp_key4, NULL, pp_key4, a_pp_key4), pp_key4)
   AND pp_key5 = DECODE(a_pgnode, NULL, DECODE(a_pp_key5, NULL, pp_key5, a_pp_key5), pp_key5)
   AND NVL(pp_version, '0') = NVL(a_pp_version, NVL(pp_version, '0'))
   ORDER BY pgnode ASC;

CURSOR l_scpgdesc_notexecuted_cursor IS
   SELECT *
   FROM utscpg
   WHERE sc = a_sc
   AND description = a_description
   AND pgnode = NVL(a_pgnode,pgnode)
   AND pp_key1 = DECODE(a_pgnode, NULL, DECODE(a_pp_key1, NULL, pp_key1, a_pp_key1), pp_key1)
   AND pp_key2 = DECODE(a_pgnode, NULL, DECODE(a_pp_key2, NULL, pp_key2, a_pp_key2), pp_key2)
   AND pp_key3 = DECODE(a_pgnode, NULL, DECODE(a_pp_key3, NULL, pp_key3, a_pp_key3), pp_key3)
   AND pp_key4 = DECODE(a_pgnode, NULL, DECODE(a_pp_key4, NULL, pp_key4, a_pp_key4), pp_key4)
   AND pp_key5 = DECODE(a_pgnode, NULL, DECODE(a_pp_key5, NULL, pp_key5, a_pp_key5), pp_key5)
   AND NVL(pp_version, '0') = NVL(a_pp_version, NVL(pp_version, '0'))
   AND exec_end_date IS NULL
   ORDER BY pgnode ASC;

BEGIN
   l_pg_rec := NULL;

   IF a_search_base = 'pg' THEN
      IF a_pos IS NULL THEN


         --find first pg which is not executed and which is not used
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Searching for first pg which is not executed and not used for sc='||
                                                a_sc||'#pg='||a_pg||'#pgnode='||NVL(TO_CHAR(a_pgnode),'NULL'));
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         pp_key1='|| a_pp_key1||'#pp_key2='||a_pp_key2||'#pp_key3='||a_pp_key3||
                                                        '#pp_key4='||a_pp_key4||'#pp_key5='||a_pp_key5||'#pp_version='||a_pp_version||'#');
         OPEN l_scpg_notexecuted_cursor;
         LOOP
            FETCH l_scpg_notexecuted_cursor
            INTO l_pg_rec;
            EXIT WHEN l_scpg_notexecuted_cursor%NOTFOUND;
            --check if pg/pgnode combination already used
            l_used := FALSE;
            FOR l_row IN 1..UNICONNECT.P_PG_NR_OF_ROWS LOOP
               IF UNICONNECT.P_PG_PG_TAB(l_row) = a_pg THEN
                  IF UNICONNECT.P_PG_PGNODE_TAB(l_row) = l_pg_rec.pgnode THEN
                     IF l_row <> a_current_row THEN
                        l_used := TRUE;
                     END IF;
                  END IF;
               END IF;
            END LOOP;
            IF l_used THEN
               l_pg_rec := NULL;
            ELSE
               EXIT;
            END IF;
         END LOOP;
         CLOSE l_scpg_notexecuted_cursor;
      ELSE

         --find pg in xth position (x=a_pos)
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Searching for pg in position '||TO_CHAR(a_pos)||' for sc='||
                                                a_sc||'#pg='||a_pg||'#pgnode='||NVL(TO_CHAR(a_pgnode),'NULL'));
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         pp_key1='|| a_pp_key1||'#pp_key2='||a_pp_key2||'#pp_key3='||a_pp_key3||
                                                        '#pp_key4='||a_pp_key4||'#pp_key5='||a_pp_key5||'#pp_version='||a_pp_version||'#');
         OPEN l_scpg_cursor;
         l_counter := 0;
         LOOP
            FETCH l_scpg_cursor
            INTO l_pg_rec;
            EXIT WHEN l_scpg_cursor%NOTFOUND;
            --check if pg/pgnode combination already used
            l_counter := l_counter + 1;
            IF l_counter >= a_pos THEN
               EXIT;
            ELSE
               l_pg_rec := NULL;
            END IF;
         END LOOP;
         CLOSE l_scpg_cursor;

      END IF;
   ELSE
      IF a_pos IS NULL THEN

         --find first pg which is not executed and which is not used
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Searching for first pg (description) which is not executed and not used for sc='||
                                                a_sc||'#description='||a_description||'#pgnode='||NVL(TO_CHAR(a_pgnode),'NULL'));
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         pp_key1='|| a_pp_key1||'#pp_key2='||a_pp_key2||'#pp_key3='||a_pp_key3||
                                                        '#pp_key4='||a_pp_key4||'#pp_key5='||a_pp_key5||'#pp_version='||a_pp_version||'#');
         OPEN l_scpgdesc_notexecuted_cursor;
         LOOP
            FETCH l_scpgdesc_notexecuted_cursor
            INTO l_pg_rec;
            EXIT WHEN l_scpgdesc_notexecuted_cursor%NOTFOUND;
            --check if pg/pgnode combination already used
            l_used := FALSE;
            FOR l_row IN 1..UNICONNECT.P_PG_NR_OF_ROWS LOOP
               IF UNICONNECT.P_PG_PG_TAB(l_row) = l_pg_rec.pg THEN
                  IF UNICONNECT.P_PG_PGNODE_TAB(l_row) = l_pg_rec.pgnode THEN
                     IF l_row <> a_current_row THEN
                        l_used := TRUE;
                     END IF;
                  END IF;
               END IF;
            END LOOP;
            IF l_used THEN
               l_pg_rec.pgnode := NULL;
            ELSE
               a_pg := l_pg_rec.pg;
               EXIT;
            END IF;
         END LOOP;
         CLOSE l_scpgdesc_notexecuted_cursor;
      ELSE

         --find pg in xth position (x=a_pos)
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Searching for pg (description) in position '||TO_CHAR(a_pos)||' for sc='||
                                                a_sc||'#description='||a_description||'#pgnode='||NVL(TO_CHAR(a_pgnode),'NULL'));
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         pp_key1='|| a_pp_key1||'#pp_key2='||a_pp_key2||'#pp_key3='||a_pp_key3||
                                                        '#pp_key4='||a_pp_key4||'#pp_key5='||a_pp_key5||'#pp_version='||a_pp_version||'#');
         OPEN l_scpgdesc_cursor;
         l_counter := 0;
         LOOP
            FETCH l_scpgdesc_cursor
            INTO l_pg_rec;
            EXIT WHEN l_scpgdesc_cursor%NOTFOUND;
            --check if pg/pgnode combination already used
            l_counter := l_counter + 1;
            IF l_counter >= a_pos THEN
               a_pg := l_pg_rec.pg;
               EXIT;
            ELSE
               l_pg_rec := NULL;
            END IF;
         END LOOP;
         CLOSE l_scpgdesc_cursor;

      END IF;
   END IF;

   RETURN (l_pg_rec);

END FindScPg;

PROCEDURE UCON_CleanupPgSection IS
BEGIN
   --Important since these variables should only
   --last for the excution of the [pg] section
   --but have to be implemented as global package variables
   --to keep it mantainable

   UNICONNECT.P_PG_SC_TAB.DELETE;
   UNICONNECT.P_PG_PG_TAB.DELETE;

   UNICONNECT.P_PG_PGNAME_TAB.DELETE;
   UNICONNECT.P_PG_PGDESCRIPTION_TAB.DELETE;

   UNICONNECT.P_PG_PGNODE_TAB.DELETE;
   UNICONNECT.P_PG_PP_KEY1_TAB.DELETE;
   UNICONNECT.P_PG_PP_KEY2_TAB.DELETE;
   UNICONNECT.P_PG_PP_KEY3_TAB.DELETE;
   UNICONNECT.P_PG_PP_KEY4_TAB.DELETE;
   UNICONNECT.P_PG_PP_KEY5_TAB.DELETE;
   UNICONNECT.P_PG_PP_VERSION_TAB.DELETE;
   UNICONNECT.P_PG_DESCRIPTION_TAB.DELETE;
   UNICONNECT.P_PG_VALUE_F_TAB.DELETE;
   UNICONNECT.P_PG_VALUE_S_TAB.DELETE;
   UNICONNECT.P_PG_UNIT_TAB.DELETE;
   UNICONNECT.P_PG_EXEC_START_DATE_TAB.DELETE;
   UNICONNECT.P_PG_EXEC_END_DATE_TAB.DELETE;
   UNICONNECT.P_PG_EXECUTOR_TAB.DELETE;
   UNICONNECT.P_PG_PLANNED_EXECUTOR_TAB.DELETE;
   UNICONNECT.P_PG_MANUALLY_ENTERED_TAB.DELETE;
   UNICONNECT.P_PG_ASSIGN_DATE_TAB.DELETE;
   UNICONNECT.P_PG_ASSIGNED_BY_TAB.DELETE;
   UNICONNECT.P_PG_MANUALLY_ADDED_TAB.DELETE;
   UNICONNECT.P_PG_FORMAT_TAB.DELETE;
   UNICONNECT.P_PG_CONFIRM_ASSIGN_TAB.DELETE;
   UNICONNECT.P_PG_ALLOW_ANY_PR_TAB.DELETE;
   UNICONNECT.P_PG_NEVER_CREATE_METHODS_TAB.DELETE;
   UNICONNECT.P_PG_DELAY_TAB.DELETE;
   UNICONNECT.P_PG_DELAY_UNIT_TAB.DELETE;
   UNICONNECT.P_PG_PG_CLASS_TAB.DELETE;
   UNICONNECT.P_PG_LOG_HS_TAB.DELETE;
   UNICONNECT.P_PG_LOG_HS_DETAILS_TAB.DELETE;
   UNICONNECT.P_PG_LC_TAB.DELETE;
   UNICONNECT.P_PG_LC_VERSION_TAB.DELETE;
   UNICONNECT.P_PG_MODIFY_FLAG_TAB.DELETE;
   UNICONNECT.P_PG_SS_TAB.DELETE;
   UNICONNECT.P_PG_ADD_COMMENT_TAB.DELETE;

   UNICONNECT.P_PG_DESCRIPTION_MODTAB.DELETE;
   UNICONNECT.P_PG_VALUE_F_MODTAB.DELETE;
   UNICONNECT.P_PG_VALUE_S_MODTAB.DELETE;
   UNICONNECT.P_PG_UNIT_MODTAB.DELETE;
   UNICONNECT.P_PG_EXEC_START_DATE_MODTAB.DELETE;
   UNICONNECT.P_PG_EXEC_END_DATE_MODTAB.DELETE;
   UNICONNECT.P_PG_EXECUTOR_MODTAB.DELETE;
   UNICONNECT.P_PG_MANUALLY_ENTERED_MODTAB.DELETE;
   UNICONNECT.P_PG_SS_MODTAB.DELETE;

   UNICONNECT.P_PG_SC := NULL;
   UNICONNECT.P_PG_NR_OF_ROWS := 0;
   UNICONNECT.P_PG_MODIFY_REASON := NULL;
END UCON_CleanupPgSection;

FUNCTION UCON_ExecutePgSection         /* INTERNAL */
RETURN NUMBER IS

l_sc                   VARCHAR2(20);
l_variable_name        VARCHAR2(20);
l_pp                   VARCHAR2(20);
l_description_pos      INTEGER;
l_openbrackets_pos     INTEGER;
l_closebrackets_pos    INTEGER;
l_pg_pos               INTEGER;
l_pg_rec_found         utscpg%ROWTYPE;
l_any_save             BOOLEAN DEFAULT FALSE;

/* InitScParameterGroup : local variables */
l_initpg_pp                          VARCHAR2(20);
l_initpg_pp_version_in               VARCHAR2(20);
l_initpg_pp_key1                     VARCHAR2(20);
l_initpg_pp_key2                     VARCHAR2(20);
l_initpg_pp_key3                     VARCHAR2(20);
l_initpg_pp_key4                     VARCHAR2(20);
l_initpg_pp_key5                     VARCHAR2(20);
l_initpg_seq                         NUMBER;
l_initpg_sc                          VARCHAR2(20);
l_initpg_nr_of_rows                  NUMBER;
l_initpg_pp_version_tab              UNAPIGEN.VC20_TABLE_TYPE;
l_initpg_description_tab             UNAPIGEN.VC40_TABLE_TYPE;
l_initpg_value_f_tab                 UNAPIGEN.FLOAT_TABLE_TYPE;
l_initpg_value_s_tab                 UNAPIGEN.VC40_TABLE_TYPE;
l_initpg_unit_tab                    UNAPIGEN.VC20_TABLE_TYPE;
l_initpg_exec_start_date_tab         UNAPIGEN.DATE_TABLE_TYPE;
l_initpg_exec_end_date_tab           UNAPIGEN.DATE_TABLE_TYPE;
l_initpg_executor_tab                UNAPIGEN.VC20_TABLE_TYPE;
l_initpg_planned_executor_tab        UNAPIGEN.VC20_TABLE_TYPE;
l_initpg_manually_entered_tab        UNAPIGEN.CHAR1_TABLE_TYPE;
l_initpg_assign_date_tab             UNAPIGEN.DATE_TABLE_TYPE;
l_initpg_assigned_by_tab             UNAPIGEN.VC20_TABLE_TYPE;
l_initpg_manually_added_tab          UNAPIGEN.CHAR1_TABLE_TYPE;
l_initpg_format_tab                  UNAPIGEN.VC40_TABLE_TYPE;
l_initpg_confirm_assign_tab          UNAPIGEN.CHAR1_TABLE_TYPE;
l_initpg_allow_any_pr_tab            UNAPIGEN.CHAR1_TABLE_TYPE;
l_initpg_never_create_me_tab         UNAPIGEN.CHAR1_TABLE_TYPE; -- 'l_initpg_never_create_me_tab'
                                                                -- instead of
                                                                -- 'l_initpg_never_create_methods_tab'
                                                                -- because max. length = 30 characters
l_initpg_delay_tab                   UNAPIGEN.NUM_TABLE_TYPE;
l_initpg_delay_unit_tab              UNAPIGEN.VC20_TABLE_TYPE;
l_initpg_reanalysis_tab              UNAPIGEN.NUM_TABLE_TYPE;
l_initpg_pg_class_tab                UNAPIGEN.VC2_TABLE_TYPE;
l_initpg_log_hs_tab                  UNAPIGEN.CHAR1_TABLE_TYPE;
l_initpg_log_hs_details_tab          UNAPIGEN.CHAR1_TABLE_TYPE;
l_initpg_lc_tab                      UNAPIGEN.VC2_TABLE_TYPE;
l_initpg_lc_version_tab              UNAPIGEN.VC20_TABLE_TYPE;

CURSOR l_ppdescription_cursor (a_description IN VARCHAR2,
                               a_pp_version  IN VARCHAR2,
                               a_pp_key1     IN VARCHAR2,
                               a_pp_key2     IN VARCHAR2,
                               a_pp_key3     IN VARCHAR2,
                               a_pp_key4     IN VARCHAR2,
                               a_pp_key5     IN VARCHAR2) IS
   SELECT pp
   FROM utpp
   WHERE description = a_description
   AND pp_key1 = DECODE(a_pp_key1, NULL, pp_key1, a_pp_key1)
   AND pp_key2 = DECODE(a_pp_key2, NULL, pp_key2, a_pp_key2)
   AND pp_key3 = DECODE(a_pp_key3, NULL, pp_key3, a_pp_key3)
   AND pp_key4 = DECODE(a_pp_key4, NULL, pp_key4, a_pp_key4)
   AND pp_key5 = DECODE(a_pp_key5, NULL, pp_key5, a_pp_key5)
   AND NVL(version, '0') = NVL(a_pp_version, NVL(version, '0'));

   FUNCTION ChangeScPgStatusOrCancel
    (a_sc                IN      VARCHAR2,     /* VC20_TYPE */
     a_pg                IN      VARCHAR2,     /* VC20_TYPE */
     a_pgnode            IN      NUMBER,       /* LONG_TYPE */
     a_new_ss            IN      VARCHAR2,     /* VC2_TYPE */
     a_modify_reason     IN      VARCHAR2)     /* VC255_TYPE */
   RETURN NUMBER
   IS

   l_ret_code                    INTEGER;
   --Specific local variables for ChangeScPg and CancelScPg
   l_old_ss                      VARCHAR2(2);
   l_lc                          VARCHAR2(2);
   l_lc_version                  VARCHAR2(20);

   --Specific local variables for InsertEvent
   l_seq_nr                      NUMBER;
   l_pp_version                  VARCHAR2(20);

   --temp variables used to stroe original retries settings
   l_tmp_retrieswhenintransition  INTEGER;
   l_tmp_intervalwhenintransition NUMBER;


   BEGIN

   -- IN and IN OUT arguments
   l_old_ss := NULL;
   l_lc := NULL;
   l_lc_version := NULL;
   l_ret_code := UNAPIGEN.DBERR_SUCCESS;

   l_ret_code := UNICONNECT7.UCON_CheckElecSignature(a_new_ss);
   IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
     RETURN(l_ret_code);
   END IF;

   --reduce the time-out for in-transition objects (retsored at the end) to 400 ms
   l_tmp_retrieswhenintransition := UNAPIEV.P_RETRIESWHENINTRANSITION;
   l_tmp_intervalwhenintransition := UNAPIEV.P_INTERVALWHENINTRANSITION;
   --UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         In-transition interval is:'||UNAPIEV.P_RETRIESWHENINTRANSITION||' retries with a wait of '||UNAPIEV.P_INTERVALWHENINTRANSITION||' second(s)');
   UNAPIEV.P_RETRIESWHENINTRANSITION  := UNICONNECT.P_CSS_RETRIESWHENINTRANSITION;
   UNAPIEV.P_INTERVALWHENINTRANSITION := UNICONNECT.P_CSS_INTERVALWHENINTRANSITION;
   --UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         In-transition interval set to:'||UNAPIEV.P_RETRIESWHENINTRANSITION||' retries with a wait of '||UNAPIEV.P_INTERVALWHENINTRANSITION||' second(s)');

   IF a_new_ss <> '@C' THEN
      l_ret_code := UNAPIPGP.ChangeScPgStatus (a_sc, a_pg, a_pgnode, l_old_ss, a_new_ss, l_lc, l_lc_version, a_modify_reason);

      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         ChangeScPgStatus ret_code='||l_ret_code||
                                '#sc='||a_sc||'#pg='||a_pg||'#pgnode='||a_pgnode);
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         #old_ss='||l_old_ss||'#new_ss='||a_new_ss);
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         #lc='||l_lc||'#lc_version='||l_lc_version);
   ELSIF a_new_ss = '@C' THEN
      l_ret_code := UNAPIPGP.CancelScPg (a_sc, a_pg, a_pgnode, a_modify_reason);
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         CancelScPg ret_code='||l_ret_code||
                                '#sc='||a_sc||'#pg='||a_pg||'#pgnode='||a_pgnode);
   END IF;
   IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NORMAL,'         CancelScPg/ChSsScPg failed:ret_code='||l_ret_code||
                                '#sc='||a_sc||'#pg='||a_pg||'#pgnode='||a_pgnode||'. Event will be sent instead.');
      IF UNAPIAUT.P_NOT_AUTHORISED IS NOT NULL THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NORMAL,'         Authorisation error='||UNAPIAUT.P_NOT_AUTHORISED);
      END IF;
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_SUCCESS; --to be sure that no rollback is taking place on EndTransaction
      --InsertEvent ParameterGroupUpdated with ss_to=<new status>
      l_seq_nr := NULL;
      SELECT pp_version
      INTO l_pp_version
      FROM utscpg
      WHERE sc = a_sc
      AND pg = a_pg
      AND pgnode = a_pgnode;
      l_ret_code := UNAPIEV.InsertEvent
                      (a_api_name          => 'ChangeScPgStatusOrCancel',
                       a_evmgr_name        => UNAPIGEN.P_EVMGR_NAME,
                       a_object_tp         => 'pg',
                       a_object_id         => a_pg,
                       a_object_lc         => NULL,
                       a_object_lc_version => NULL,
                       a_object_ss         => NULL,
                       a_ev_tp             => 'ParameterGroupUpdated',
                       a_ev_details        => 'sc='||a_sc||'#pgnode='||a_pgnode||
                                              '#pp_version='||l_pp_version||'#ss_to='||a_new_ss,
                       a_seq_nr            => l_seq_nr);
      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         InsertEvent failed ret_code='||l_ret_code);
      ELSE
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW  ,'         InsertEvent OK');
      END IF;
   END IF;
   --restore original time-out for in-transition objects
   UNAPIEV.P_RETRIESWHENINTRANSITION  := l_tmp_retrieswhenintransition;
   UNAPIEV.P_INTERVALWHENINTRANSITION := l_tmp_intervalwhenintransition;
   --UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         In-transition interval restored to:'||UNAPIEV.P_RETRIESWHENINTRANSITION||' retries with a wait of '||UNAPIEV.P_INTERVALWHENINTRANSITION||' second(s)');

   RETURN(l_ret_code);
   EXCEPTION
   WHEN OTHERS THEN
      --restore original time-out for in-transition objects
      UNAPIEV.P_RETRIESWHENINTRANSITION  := l_tmp_retrieswhenintransition;
      UNAPIEV.P_INTERVALWHENINTRANSITION := l_tmp_intervalwhenintransition;
      --UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         In-transition interval restored to:'||UNAPIEV.P_RETRIESWHENINTRANSITION||' retries with a wait of '||UNAPIEV.P_INTERVALWHENINTRANSITION||' second(s)');
      RAISE;
   END ChangeScPgStatusOrCancel;

BEGIN
   l_ret_code := UNAPIGEN.DBERR_SUCCESS;
   --1. sc validation
   IF UNICONNECT.P_PG_SC IS NULL THEN
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : sample is mandatory for [pg] section !');
      l_ret_code := UNAPIGEN.DBERR_NOPARENTOBJECT;
      RAISE StpError;
   END IF;

   --2. sc modified in [pg] section ?
   --    NO    set global variable SC
   --    YES   verify if provided sample code exist: error when not + set global variable SC
   --    Copy sc in savescparametergroup array
   IF UNICONNECT.P_GLOB_SC <> UNICONNECT.P_PG_SC THEN
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NORMAL,'         Sc directly searched:'||UNICONNECT.P_PG_SC);
      OPEN l_sc_cursor(UNICONNECT.P_PG_SC);
      FETCH l_sc_cursor
      INTO l_sc;
      CLOSE l_sc_cursor;
      IF l_sc IS NULL THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : sc does not exist ! sc is mandatory for [pg] section !');
         l_ret_code := UNAPIGEN.DBERR_NOPARENTOBJECT;
         RAISE StpError;
      END IF;
      UNICONNECT.P_GLOB_SC := UNICONNECT.P_PG_SC;
   ELSE
      UNICONNECT.P_GLOB_SC := UNICONNECT.P_PG_SC;
   END IF;

   FOR l_row IN 1..UNICONNECT.P_PG_NR_OF_ROWS LOOP
      UNICONNECT.P_PG_SC_TAB(l_row) := UNICONNECT.P_GLOB_SC;
   END LOOP;

   --3. any pg specified ?
   --    YES   do nothing
   --    NO    Major error : pg is mandatory in a [pg] section
   IF UNICONNECT.P_PG_NR_OF_ROWS = 0 THEN
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : pg is mandatory for [pg] section !');
      l_ret_code := UNAPIGEN.DBERR_NOOBJID;
      RAISE StpError;
   END IF;

   --4. create_pg ?
   --   Y|INSERT|INSERT_WITH_NODES
   --      LOOP through all pg array
   --         pg[] notation will not be ignored
   --         pgnode will not be checked (Save api will return an error when not NULL)
   --         pg.description used ?
   --         YES   pg.description => find corresponding pg description in utpp and fill in corresponding pg
   --         NO use pg or pg.pg directly
   --         Set modify flag to MOD_FLAG_CREATE|MOD_FLAG_INSERT|INSERT_WITH_NODES
   --         Set node to NULL
   --      END LOOP
   --   N|W
   --      LOOP through all pg array
   --         pg[x] syntax used and/or description syntax used ?
   --            YES   find corresponding pgnode (find xth pg for this sc and this sc order by pgnode ASC)
   --               pg[] => find the first pg which is not executed (ended)
   --               Pay attention : pg can already being used for saving another pg with the same name
   --            NO use the first pg with this name (ORDER BY pgnode)
   --         pg found ?
   --            YES   set modify flag to UNAPIGEN.DBERR_SUCCESS
   --                  set the node correctly for correct node numbering
   --                  Initialise SaveScParameterGroup array variables with the values coming from the record or from the section
   --                  (Values from the section will overrule the value from the record)
   --            NO
   --               create_pg ?
   --               N
   --                  Warning and return UNAPIGEN.DBERR_SUCCESS
   --               W
   --                  Set modify flag to UNAPIGEN.MOD_FLAG_CREATE
   --                  Set node to NULL
   --      END LOOP
   IF UNICONNECT.P_SET_CREATE_PG IN ('Y', 'INSERT', 'INSERT_WITH_NODES') THEN
      FOR l_row IN 1..UNICONNECT.P_PG_NR_OF_ROWS LOOP

         --description used ? -> find pp in utpp
         l_variable_name := UNICONNECT.P_PG_PGNAME_TAB(l_row);
         l_description_pos := INSTR(l_variable_name, '.description');
         IF l_description_pos > 0 THEN
            OPEN l_ppdescription_cursor(UNICONNECT.P_PG_PGDESCRIPTION_TAB(l_row),
                                        UNICONNECT.P_PG_PP_VERSION_TAB(l_row),
                                        UNICONNECT.P_PG_PP_KEY1_TAB(l_row),
                                        UNICONNECT.P_PG_PP_KEY2_TAB(l_row),
                                        UNICONNECT.P_PG_PP_KEY3_TAB(l_row),
                                        UNICONNECT.P_PG_PP_KEY4_TAB(l_row),
                                        UNICONNECT.P_PG_PP_KEY5_TAB(l_row));
            FETCH l_ppdescription_cursor
            INTO l_pp;
            IF l_ppdescription_cursor%NOTFOUND THEN
               --Major error no corresponding pp found
               CLOSE l_ppdescription_cursor;
               UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : no corresponding pp for description '||UNICONNECT.P_PG_PGDESCRIPTION_TAB(l_row));
               l_ret_code := UNAPIGEN.DBERR_NOOBJID;
               RAISE StpError;
            END IF;
            CLOSE l_ppdescription_cursor;
            UNICONNECT.P_PG_PG_TAB(l_row) := l_pp;
         END IF;

         --Set Modify flag to MOD_FLAG_CREATE|MOD_FLAG_INSERT|INSERT_WITH_NODES
         IF UNICONNECT.P_SET_CREATE_PG = 'INSERT' THEN
            UNICONNECT.P_PG_MODIFY_FLAG_TAB(l_row) := UNAPIGEN.MOD_FLAG_INSERT;
            UNICONNECT.P_PG_PGNODE_TAB(l_row) := NULL;
         ELSIF UNICONNECT.P_SET_CREATE_PG = 'INSERT_WITH_NODES' THEN
            UNICONNECT.P_PG_MODIFY_FLAG_TAB(l_row) := UNAPIGEN.MOD_FLAG_INSERT_WITH_NODES;
            --the node is not forced to NULL in this case
         ELSE
            UNICONNECT.P_PG_MODIFY_FLAG_TAB(l_row) := UNAPIGEN.MOD_FLAG_CREATE;
            UNICONNECT.P_PG_PGNODE_TAB(l_row) := NULL;
         END IF;
         --Set pp_keys to blank when NULL
         UNICONNECT.P_PG_PP_KEY1_TAB(l_row) := NVL(UNICONNECT.P_PG_PP_KEY1_TAB(l_row), ' ');
         UNICONNECT.P_PG_PP_KEY2_TAB(l_row) := NVL(UNICONNECT.P_PG_PP_KEY2_TAB(l_row), ' ');
         UNICONNECT.P_PG_PP_KEY3_TAB(l_row) := NVL(UNICONNECT.P_PG_PP_KEY3_TAB(l_row), ' ');
         UNICONNECT.P_PG_PP_KEY4_TAB(l_row) := NVL(UNICONNECT.P_PG_PP_KEY4_TAB(l_row), ' ');
         UNICONNECT.P_PG_PP_KEY5_TAB(l_row) := NVL(UNICONNECT.P_PG_PP_KEY5_TAB(l_row), ' ');

      END LOOP;
   ELSE
      FOR l_row IN 1..UNICONNECT.P_PG_NR_OF_ROWS LOOP

         --description used ? -> find pp in utpp
         l_variable_name := UNICONNECT.P_PG_PGNAME_TAB(l_row);
         l_description_pos := INSTR(l_variable_name, '.description');
         l_openbrackets_pos := INSTR(l_variable_name, '[');
         l_closebrackets_pos := INSTR(l_variable_name, ']');
         l_pg_pos := TO_NUMBER(SUBSTR(l_variable_name,l_openbrackets_pos+1,l_closebrackets_pos-l_openbrackets_pos-1));

         l_pg_rec_found := NULL;

         IF l_openbrackets_pos = 0 THEN
            IF l_description_pos = 0 THEN
               --pg or pg.pg used
               l_pg_rec_found := FindScPg(UNICONNECT.P_GLOB_SC, UNICONNECT.P_PG_PG_TAB(l_row),  UNICONNECT.P_PG_PGDESCRIPTION_TAB(l_row),
                                          UNICONNECT.P_PG_PGNODE_TAB(l_row),
                                          UNICONNECT.P_PG_PP_KEY1_TAB(l_row), UNICONNECT.P_PG_PP_KEY2_TAB(l_row), UNICONNECT.P_PG_PP_KEY3_TAB(l_row), UNICONNECT.P_PG_PP_KEY4_TAB(l_row), UNICONNECT.P_PG_PP_KEY5_TAB(l_row),
                                          UNICONNECT.P_PG_PP_VERSION_TAB(l_row),
                                          'pg', 1,  l_row);
            ELSE
               --pg.description used
               l_pg_rec_found := FindScPg(UNICONNECT.P_GLOB_SC, UNICONNECT.P_PG_PG_TAB(l_row), UNICONNECT.P_PG_PGDESCRIPTION_TAB(l_row),
                                          UNICONNECT.P_PG_PGNODE_TAB(l_row),
                                          UNICONNECT.P_PG_PP_KEY1_TAB(l_row), UNICONNECT.P_PG_PP_KEY2_TAB(l_row), UNICONNECT.P_PG_PP_KEY3_TAB(l_row), UNICONNECT.P_PG_PP_KEY4_TAB(l_row), UNICONNECT.P_PG_PP_KEY5_TAB(l_row),
                                          UNICONNECT.P_PG_PP_VERSION_TAB(l_row),
                                          'description',        1, l_row);
            END IF;
         ELSE
            IF l_description_pos = 0 THEN
               --pg[x] or pg[x].pg used
               l_pg_rec_found := FindScPg(UNICONNECT.P_GLOB_SC, UNICONNECT.P_PG_PG_TAB(l_row), UNICONNECT.P_PG_PGDESCRIPTION_TAB(l_row),
                                          UNICONNECT.P_PG_PGNODE_TAB(l_row),
                                          UNICONNECT.P_PG_PP_KEY1_TAB(l_row), UNICONNECT.P_PG_PP_KEY2_TAB(l_row), UNICONNECT.P_PG_PP_KEY3_TAB(l_row), UNICONNECT.P_PG_PP_KEY4_TAB(l_row), UNICONNECT.P_PG_PP_KEY5_TAB(l_row),
                                          UNICONNECT.P_PG_PP_VERSION_TAB(l_row),
                                          'pg', l_pg_pos, l_row);
            ELSE
               --pg[x].description used
               l_pg_rec_found := FindScPg(UNICONNECT.P_GLOB_SC,  UNICONNECT.P_PG_PG_TAB(l_row), UNICONNECT.P_PG_PGDESCRIPTION_TAB(l_row),
                                          UNICONNECT.P_PG_PGNODE_TAB(l_row),
                                          UNICONNECT.P_PG_PP_KEY1_TAB(l_row), UNICONNECT.P_PG_PP_KEY2_TAB(l_row), UNICONNECT.P_PG_PP_KEY3_TAB(l_row), UNICONNECT.P_PG_PP_KEY4_TAB(l_row), UNICONNECT.P_PG_PP_KEY5_TAB(l_row),
                                          UNICONNECT.P_PG_PP_VERSION_TAB(l_row),
                                          'description', l_pg_pos, l_row);
            END IF;
         END IF;

         IF l_pg_rec_found.pgnode IS NOT NULL THEN
            --pg found
            --initialise SaveScParameterGroup array with fetched values when not set in section

            --always set
            UNICONNECT.P_PG_PGNODE_TAB(l_row)               := l_pg_rec_found.pgnode;
            UNICONNECT.P_PG_PP_VERSION_TAB(l_row)           := l_pg_rec_found.pp_version;
            UNICONNECT.P_PG_PP_KEY1_TAB(l_row)              := l_pg_rec_found.pp_key1;
            UNICONNECT.P_PG_PP_KEY2_TAB(l_row)              := l_pg_rec_found.pp_key2;
            UNICONNECT.P_PG_PP_KEY3_TAB(l_row)              := l_pg_rec_found.pp_key3;
            UNICONNECT.P_PG_PP_KEY4_TAB(l_row)              := l_pg_rec_found.pp_key4;
            UNICONNECT.P_PG_PP_KEY5_TAB(l_row)              := l_pg_rec_found.pp_key5;
            UNICONNECT.P_PG_PLANNED_EXECUTOR_TAB(l_row)     := l_pg_rec_found.planned_executor;
            UNICONNECT.P_PG_ASSIGN_DATE_TAB(l_row)          := l_pg_rec_found.assign_date;
            UNICONNECT.P_PG_ASSIGNED_BY_TAB(l_row)          := l_pg_rec_found.assigned_by;
            UNICONNECT.P_PG_MANUALLY_ADDED_TAB(l_row)       := l_pg_rec_found.manually_added;
            UNICONNECT.P_PG_FORMAT_TAB(l_row)               := l_pg_rec_found.format;
            UNICONNECT.P_PG_CONFIRM_ASSIGN_TAB(l_row)       := l_pg_rec_found.confirm_assign;
            UNICONNECT.P_PG_ALLOW_ANY_PR_TAB(l_row)         := l_pg_rec_found.allow_any_pr;
            UNICONNECT.P_PG_NEVER_CREATE_METHODS_TAB(l_row) := l_pg_rec_found.never_create_methods;
            UNICONNECT.P_PG_DELAY_TAB(l_row)                := l_pg_rec_found.delay;
            UNICONNECT.P_PG_DELAY_UNIT_TAB(l_row)           := l_pg_rec_found.delay_unit;
            UNICONNECT.P_PG_PG_CLASS_TAB(l_row)             := l_pg_rec_found.pg_class;
            UNICONNECT.P_PG_LOG_HS_TAB(l_row)               := l_pg_rec_found.log_hs;
            UNICONNECT.P_PG_LOG_HS_DETAILS_TAB(l_row)       := l_pg_rec_found.log_hs_details;
            UNICONNECT.P_PG_LC_TAB(l_row)                   := l_pg_rec_found.lc;
            UNICONNECT.P_PG_LC_VERSION_TAB(l_row)           := l_pg_rec_found.lc_version;

            --only when not set in section
            UNICONNECT.P_PG_DESCRIPTION_TAB(l_row)      := PgUseValue('description'       , l_row, l_pg_rec_found.description);
            UNICONNECT.P_PG_UNIT_TAB(l_row)             := PgUseValue('unit'              , l_row, l_pg_rec_found.unit);
            UNICONNECT.P_PG_EXEC_START_DATE_TAB(l_row)  := PgUseValue('exec_start_date'   , l_row, l_pg_rec_found.exec_start_date);
            UNICONNECT.P_PG_EXEC_END_DATE_TAB(l_row)    := PgUseValue('exec_end_date'     , l_row, l_pg_rec_found.exec_end_date);
            UNICONNECT.P_PG_EXECUTOR_TAB(l_row)         := PgUseValue('executor'          , l_row, l_pg_rec_found.executor);
            UNICONNECT.P_PG_MANUALLY_ENTERED_TAB(l_row) := PgUseValue('manually_entered'  , l_row, l_pg_rec_found.manually_entered);

            -- Note : MODIFY_FLAG_TAB has been set to MOD_FLAG_UPDATE in AssignPgSection
            --Special rule for value_f and value_s :
            --Rule : when only value_f specified => value_s from record nomore used
            --          when only value_s specified => value_f from record nomore used
            --          when value_s AND value_f specified => all values from record ignored
            l_ret_code := UNICONNECT6.SpecialRulesForValues(UNICONNECT.P_PG_VALUE_S_MODTAB(l_row),
                                                            UNICONNECT.P_PG_VALUE_S_TAB(l_row),
                                                            UNICONNECT.P_PG_VALUE_F_MODTAB(l_row),
                                                            UNICONNECT.P_PG_VALUE_F_TAB(l_row),
                                                            l_pg_rec_found.format,
                                                            l_pg_rec_found.value_s,
                                                            l_pg_rec_found.value_f);
            IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
               UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         ret_code='||TO_CHAR(l_ret_code)||
                                                     ' returned by UNICONNECT6.SpecialRulesForValues#value_s='||
                                                     UNICONNECT.P_PG_VALUE_S_TAB(l_row)||'#value_f='||
                                                     TO_CHAR(UNICONNECT.P_PG_VALUE_F_TAB(l_row))||
                                                     '#format='||l_pg_rec_found.format);
               RAISE StpError;
            END IF;

            UNICONNECT.P_PG_VALUE_F_TAB(l_row)          := PgUseValue('value_f'           , l_row, l_pg_rec_found.value_f);
            UNICONNECT.P_PG_VALUE_S_TAB(l_row)          := PgUseValue('value_s'           , l_row, l_pg_rec_found.value_s);

         ELSE
            /* create_pg=N ? */
            IF UNICONNECT.P_SET_CREATE_PG = 'N' THEN

               UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NORMAL,'         Warning : section skipped : pg does not exist and can not be created');
               l_ret_code := UNAPIGEN.DBERR_SUCCESS;
               RAISE StpError;

            ELSE
               --find the pp corresponding to the provided description
               --in utpp when description used to specify the pg
               IF l_description_pos > 0 THEN
                  OPEN l_ppdescription_cursor(UNICONNECT.P_PG_PGDESCRIPTION_TAB(l_row),
                                              UNICONNECT.P_PG_PP_VERSION_TAB(l_row),
                                              UNICONNECT.P_PG_PP_KEY1_TAB(l_row),
                                              UNICONNECT.P_PG_PP_KEY2_TAB(l_row),
                                              UNICONNECT.P_PG_PP_KEY3_TAB(l_row),
                                              UNICONNECT.P_PG_PP_KEY4_TAB(l_row),
                                              UNICONNECT.P_PG_PP_KEY5_TAB(l_row));
                  FETCH l_ppdescription_cursor
                  INTO l_pp;
                  IF l_ppdescription_cursor%NOTFOUND THEN
                     --Major error no corresponding pp found
                     CLOSE l_ppdescription_cursor;
                     UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : no corresponding pp for description '||UNICONNECT.P_PG_PGDESCRIPTION_TAB(l_row));
                     l_ret_code := UNAPIGEN.DBERR_NOOBJID;
                     RAISE StpError;
                  END IF;
                  CLOSE l_ppdescription_cursor;
                  UNICONNECT.P_PG_PG_TAB(l_row) := l_pp;
               END IF;

               --Set Modify flag to MOD_FLAG_CREATE
               UNICONNECT.P_PG_MODIFY_FLAG_TAB(l_row) := UNAPIGEN.MOD_FLAG_CREATE;
               UNICONNECT.P_PG_PGNODE_TAB(l_row) := NULL;

               --Set pp_keys to blank when NULL
               UNICONNECT.P_PG_PP_KEY1_TAB(l_row) := NVL(UNICONNECT.P_PG_PP_KEY1_TAB(l_row), ' ');
               UNICONNECT.P_PG_PP_KEY2_TAB(l_row) := NVL(UNICONNECT.P_PG_PP_KEY2_TAB(l_row), ' ');
               UNICONNECT.P_PG_PP_KEY3_TAB(l_row) := NVL(UNICONNECT.P_PG_PP_KEY3_TAB(l_row), ' ');
               UNICONNECT.P_PG_PP_KEY4_TAB(l_row) := NVL(UNICONNECT.P_PG_PP_KEY4_TAB(l_row), ' ');
               UNICONNECT.P_PG_PP_KEY5_TAB(l_row) := NVL(UNICONNECT.P_PG_PP_KEY5_TAB(l_row), ' ');

            END IF;

         END IF;

      END LOOP;
   END IF;

   --5. any pg to create
   --   YES
   --      LOOP through all pg array
   --         Call InitScParameterGroup for all pg which have to be created
   --         Initialise SaveScParameterGroup array variables with the values coming
   --              from InitScParameterGroup or from the section
   --                  (Values from the section will overrule the value from the InitScParameterGroup)
   --      END LOOP
   --      Call SaveScParameterGroup
   l_any_save := FALSE;
   FOR l_row IN 1..UNICONNECT.P_PG_NR_OF_ROWS LOOP

      IF UNICONNECT.P_PG_MODIFY_FLAG_TAB(l_row) IN (UNAPIGEN.MOD_FLAG_CREATE,
                                                    UNAPIGEN.MOD_FLAG_INSERT,
                                                    UNAPIGEN.MOD_FLAG_INSERT_WITH_NODES) THEN

         l_any_save := TRUE;
         l_initpg_pp := UNICONNECT.P_PG_PG_TAB(l_row);
         l_initpg_pp_version_in := UNICONNECT.P_PG_PP_VERSION_TAB(l_row);
         l_initpg_pp_key1 := UNICONNECT.P_PG_PP_KEY1_TAB(l_row);
         l_initpg_pp_key2 := UNICONNECT.P_PG_PP_KEY2_TAB(l_row);
         l_initpg_pp_key3 := UNICONNECT.P_PG_PP_KEY3_TAB(l_row);
         l_initpg_pp_key4 := UNICONNECT.P_PG_PP_KEY4_TAB(l_row);
         l_initpg_pp_key5 := UNICONNECT.P_PG_PP_KEY5_TAB(l_row);
         l_initpg_seq := NULL;
         l_initpg_sc := UNICONNECT.P_GLOB_SC;
         l_initpg_nr_of_rows := NULL;

         l_ret_code := UNAPIPG.INITSCPARAMETERGROUP
                         (l_initpg_pp,
                          l_initpg_pp_version_in,
                          l_initpg_pp_key1,
                          l_initpg_pp_key2,
                          l_initpg_pp_key3,
                          l_initpg_pp_key4,
                          l_initpg_pp_key5,
                          l_initpg_seq,
                          l_initpg_sc,
                          l_initpg_pp_version_tab,
                          l_initpg_description_tab,
                          l_initpg_value_f_tab,
                          l_initpg_value_s_tab,
                          l_initpg_unit_tab,
                          l_initpg_exec_start_date_tab,
                          l_initpg_exec_end_date_tab,
                          l_initpg_executor_tab,
                          l_initpg_planned_executor_tab,
                          l_initpg_manually_entered_tab,
                          l_initpg_assign_date_tab,
                          l_initpg_assigned_by_tab,
                          l_initpg_manually_added_tab,
                          l_initpg_format_tab,
                          l_initpg_confirm_assign_tab,
                          l_initpg_allow_any_pr_tab,
                          l_initpg_never_create_me_tab,
                          l_initpg_delay_tab,
                          l_initpg_delay_unit_tab,
                          l_initpg_reanalysis_tab,
                          l_initpg_pg_class_tab,
                          l_initpg_log_hs_tab,
                          l_initpg_log_hs_details_tab,
                          l_initpg_lc_tab,
                          l_initpg_lc_version_tab,
                          l_initpg_nr_of_rows);

         IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : InitScParameterGroup ret_code : '||l_ret_code ||
                                           '#pp='||l_initpg_pp||'#pp_version_in='||l_initpg_pp_version_in);
            RAISE StpError;
         ELSE
            --only when not set in section
            --always use initscparametergroup values
            UNICONNECT.P_PG_PP_VERSION_TAB(l_row)             := l_initpg_pp_version_tab(1);
            UNICONNECT.P_PG_PLANNED_EXECUTOR_TAB(l_row)       := l_initpg_planned_executor_tab(1);
            UNICONNECT.P_PG_ASSIGN_DATE_TAB(l_row)            := l_initpg_assign_date_tab(1);
            UNICONNECT.P_PG_ASSIGNED_BY_TAB(l_row)            := l_initpg_assigned_by_tab(1);
            UNICONNECT.P_PG_MANUALLY_ADDED_TAB(l_row)         := l_initpg_manually_added_tab(1);
            UNICONNECT.P_PG_FORMAT_TAB(l_row)                 := l_initpg_format_tab(1);
            UNICONNECT.P_PG_CONFIRM_ASSIGN_TAB(l_row)         := l_initpg_confirm_assign_tab(1);
            UNICONNECT.P_PG_ALLOW_ANY_PR_TAB(l_row)           := l_initpg_allow_any_pr_tab(1);
            UNICONNECT.P_PG_NEVER_CREATE_METHODS_TAB(l_row)   := l_initpg_never_create_me_tab(1);
            UNICONNECT.P_PG_DELAY_TAB(l_row)                  := l_initpg_delay_tab(1);
            UNICONNECT.P_PG_DELAY_UNIT_TAB(l_row)             := l_initpg_delay_unit_tab(1);
            UNICONNECT.P_PG_PG_CLASS_TAB(l_row)               := l_initpg_pg_class_tab(1);
            UNICONNECT.P_PG_LOG_HS_TAB(l_row)                 := l_initpg_log_hs_tab(1);
            UNICONNECT.P_PG_LOG_HS_DETAILS_TAB(l_row)         := l_initpg_log_hs_details_tab(1);
            UNICONNECT.P_PG_LC_TAB(l_row)                     := l_initpg_lc_tab(1);
            UNICONNECT.P_PG_LC_VERSION_TAB(l_row)             := l_initpg_lc_version_tab(1);

            --only when not set in section
            UNICONNECT.P_PG_DESCRIPTION_TAB(l_row)      := PgUseValue('description'       , l_row, l_initpg_description_tab(1));
            UNICONNECT.P_PG_UNIT_TAB(l_row)             := PgUseValue('unit'              , l_row, l_initpg_unit_tab(1));
            UNICONNECT.P_PG_EXEC_START_DATE_TAB(l_row)  := PgUseValue('exec_start_date'   , l_row, l_initpg_exec_start_date_tab(1));
            UNICONNECT.P_PG_EXEC_END_DATE_TAB(l_row)    := PgUseValue('exec_end_date'     , l_row, l_initpg_exec_end_date_tab(1));
            UNICONNECT.P_PG_EXECUTOR_TAB(l_row)         := PgUseValue('executor'          , l_row, l_initpg_executor_tab(1));
            UNICONNECT.P_PG_MANUALLY_ENTERED_TAB(l_row) := PgUseValue('manually_entered'  , l_row, l_initpg_manually_entered_tab(1));

            --Special rule for value_f and value_s :
            --Rule : when only value_f specified => value_s from record nomore used
            --          when only value_s specified => value_f from record nomore used
            --          when value_s AND value_f specified => all values from record ignored
            l_ret_code := UNICONNECT6.SpecialRulesForValues(UNICONNECT.P_PG_VALUE_S_MODTAB(l_row),
                                                            UNICONNECT.P_PG_VALUE_S_TAB(l_row),
                                                            UNICONNECT.P_PG_VALUE_F_MODTAB(l_row),
                                                            UNICONNECT.P_PG_VALUE_F_TAB(l_row),
                                                            l_initpg_format_tab(1),
                                                            l_initpg_value_s_tab(1),
                                                            l_initpg_value_f_tab(1));
            IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
               UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         ret_code='||TO_CHAR(l_ret_code)||
                                                     ' returned by UNICONNECT6.SpecialRulesForValues#value_s='||
                                                     UNICONNECT.P_PG_VALUE_S_TAB(l_row)||'#value_f='||
                                                     TO_CHAR(UNICONNECT.P_PG_VALUE_F_TAB(l_row))||
                                                     '#format='||l_initpg_format_tab(1));
               RAISE StpError;
            END IF;
            UNICONNECT.P_PG_VALUE_F_TAB(l_row)          := PgUseValue('value_f'           , l_row, l_initpg_value_f_tab(1));
            UNICONNECT.P_PG_VALUE_S_TAB(l_row)          := PgUseValue('value_s'           , l_row, l_initpg_value_s_tab(1));
         END IF;

      ELSIF UNICONNECT.P_PG_MODIFY_FLAG_TAB(l_row) IN (UNAPIGEN.MOD_FLAG_UPDATE,
                                                       UNAPIGEN.MOD_FLAG_DELETE) THEN
         l_any_save := TRUE;
      END IF;
   END LOOP;

   IF l_any_save THEN
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Calling SaveScParameterGroup for :');
      FOR l_row IN 1..UNICONNECT.P_PG_NR_OF_ROWS LOOP
          UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'            row='||l_row||
                                    '#mod_flag='||UNICONNECT.P_PG_MODIFY_FLAG_TAB(l_row) ||
                                    '#sc='||UNICONNECT.P_PG_SC_TAB(l_row)||'#pg='||UNICONNECT.P_PG_PG_TAB(l_row)||
                                    '#pgnode='||NVL(TO_CHAR(UNICONNECT.P_PG_PGNODE_TAB(l_row)),'NULL'));
      END LOOP;

      l_ret_code := Unapipg.Savescparametergroup
                      (UNICONNECT.P_PG_SC_TAB,
                       UNICONNECT.P_PG_PG_TAB,
                       UNICONNECT.P_PG_PGNODE_TAB,
                       UNICONNECT.P_PG_PP_VERSION_TAB,
                       UNICONNECT.P_PG_PP_KEY1_TAB,
                       UNICONNECT.P_PG_PP_KEY2_TAB,
                       UNICONNECT.P_PG_PP_KEY3_TAB,
                       UNICONNECT.P_PG_PP_KEY4_TAB,
                       UNICONNECT.P_PG_PP_KEY5_TAB,
                       UNICONNECT.P_PG_DESCRIPTION_TAB,
                       UNICONNECT.P_PG_VALUE_F_TAB,
                       UNICONNECT.P_PG_VALUE_S_TAB,
                       UNICONNECT.P_PG_UNIT_TAB,
                       UNICONNECT.P_PG_EXEC_START_DATE_TAB,
                       UNICONNECT.P_PG_EXEC_END_DATE_TAB,
                       UNICONNECT.P_PG_EXECUTOR_TAB,
                       UNICONNECT.P_PG_PLANNED_EXECUTOR_TAB,
                       UNICONNECT.P_PG_MANUALLY_ENTERED_TAB,
                       UNICONNECT.P_PG_ASSIGN_DATE_TAB,
                       UNICONNECT.P_PG_ASSIGNED_BY_TAB,
                       UNICONNECT.P_PG_MANUALLY_ADDED_TAB,
                       UNICONNECT.P_PG_FORMAT_TAB,
                       UNICONNECT.P_PG_CONFIRM_ASSIGN_TAB,
                       UNICONNECT.P_PG_ALLOW_ANY_PR_TAB,
                       UNICONNECT.P_PG_NEVER_CREATE_METHODS_TAB,
                       UNICONNECT.P_PG_DELAY_TAB,
                       UNICONNECT.P_PG_DELAY_UNIT_TAB,
                       UNICONNECT.P_PG_PG_CLASS_TAB,
                       UNICONNECT.P_PG_LOG_HS_TAB,
                       UNICONNECT.P_PG_LOG_HS_DETAILS_TAB,
                       UNICONNECT.P_PG_LC_TAB,
                       UNICONNECT.P_PG_LC_VERSION_TAB,
                       UNICONNECT.P_PG_MODIFY_FLAG_TAB,
                       UNICONNECT.P_PG_NR_OF_ROWS,
                       UNICONNECT.P_PG_MODIFY_REASON);

      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : SaveScParameterGroup ret_code='||l_ret_code ||
                                   '#sc(1)='||UNICONNECT.P_PG_SC_TAB(1)||'#pg(1)='||UNICONNECT.P_PG_PG_TAB(1)||
                                   '#pgnode(1)='||NVL(TO_CHAR(UNICONNECT.P_PG_PGNODE_TAB(1)),'NULL')||'#mod_flag(1)='||UNICONNECT.P_PG_MODIFY_FLAG_TAB(1));
         IF l_ret_code = UNAPIGEN.DBERR_PARTIALSAVE AND UNICONNECT.P_PG_NR_OF_ROWS > 1 THEN
            FOR l_row IN 1..UNICONNECT.P_PG_NR_OF_ROWS LOOP
               IF UNICONNECT.P_PG_MODIFY_FLAG_TAB(l_row) > UNAPIGEN.DBERR_SUCCESS THEN
                  UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         SaveScParameterGroup authorisation problem row='||l_row||
                                            '#mod_flag='||UNICONNECT.P_PG_MODIFY_FLAG_TAB(l_row) ||
                                            '#sc='||UNICONNECT.P_PG_SC_TAB(l_row)||'#pg='||UNICONNECT.P_PG_PG_TAB(l_row)||
                                            '#pgnode='||NVL(TO_CHAR(UNICONNECT.P_PG_PGNODE_TAB(l_row)),'NULL'));
               END IF;
            END LOOP;
         END IF;
         IF UNAPIAUT.P_NOT_AUTHORISED IS NOT NULL THEN
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         ' || UNAPIAUT.P_NOT_AUTHORISED );
         END IF;
         RAISE StpError;

      END IF;
   ELSE
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NORMAL,'         No save(s) in [pg] section');
   END IF;

   --6. Perform a ChangeStatus or a Cancel when required
   FOR l_row IN 1..UNICONNECT.P_PG_NR_OF_ROWS LOOP
      IF UNICONNECT.P_PG_SS_MODTAB(l_row) THEN
         l_ret_code := ChangeScPgStatusOrCancel(UNICONNECT.P_PG_SC_TAB(l_row),
                                                UNICONNECT.P_PG_PG_TAB(l_row),
                                                UNICONNECT.P_PG_PGNODE_TAB(l_row),
                                                UNICONNECT.P_PG_SS_TAB(l_row),
                                                UNICONNECT.P_PG_MODIFY_REASON);
         IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : ChangeScPgStatusOrCancel ret_code='||l_ret_code ||
                                      '#sc='||UNICONNECT.P_PG_SC_TAB(l_row)||
                                      '#pg='||UNICONNECT.P_PG_PG_TAB(l_row)||
                                      '#pgnode='||NVL(TO_CHAR(UNICONNECT.P_PG_PGNODE_TAB(l_row)),'NULL'));
            IF UNAPIAUT.P_NOT_AUTHORISED IS NOT NULL THEN
               UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         ' || UNAPIAUT.P_NOT_AUTHORISED );
            END IF;
            RAISE StpError;
         END IF;
      END IF;
   END LOOP;

   --7. Perform a AddComment when required
   FOR l_row IN 1..UNICONNECT.P_PG_NR_OF_ROWS LOOP
      IF UNICONNECT.P_PG_ADD_COMMENT_TAB(l_row) IS NOT NULL THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Adding comment for'||
                                   '#sc='||UNICONNECT.P_PG_SC_TAB(l_row)||
                                   '#pg='||UNICONNECT.P_PG_PG_TAB(l_row)||
                                   '#pgnode='||NVL(TO_CHAR(UNICONNECT.P_PG_PGNODE_TAB(l_row)),'NULL'));
         l_ret_code := UNAPIPGP.AddScPgComment(UNICONNECT.P_PG_SC_TAB(l_row),
                                               UNICONNECT.P_PG_PG_TAB(l_row),
                                               UNICONNECT.P_PG_PGNODE_TAB(l_row),
                                               UNICONNECT.P_PG_ADD_COMMENT_TAB(l_row));

         IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : AddScPgComment ret_code='||l_ret_code ||
                                      '#sc='||UNICONNECT.P_PG_SC_TAB(l_row)||
                                      '#pg='||UNICONNECT.P_PG_PG_TAB(l_row)||
                                      '#pgnode='||NVL(TO_CHAR(UNICONNECT.P_PG_PGNODE_TAB(l_row)),'NULL'));
            IF UNAPIAUT.P_NOT_AUTHORISED IS NOT NULL THEN
               UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         ' || UNAPIAUT.P_NOT_AUTHORISED );
            END IF;
            RAISE StpError;
         END IF;
      END IF;
   END LOOP;

   --8. Initialise PG and PGNODE global variables with the last pg in array
   --   Cleanup the arrays used to save the parameter group(s) (important since it can be reused)
   IF UNICONNECT.P_PG_NR_OF_ROWS > 0 THEN
      UNICONNECT.P_GLOB_PG := UNICONNECT.P_PG_PG_TAB(UNICONNECT.P_PG_NR_OF_ROWS);
      UNICONNECT.P_GLOB_PGNODE := UNICONNECT.P_PG_PGNODE_TAB(UNICONNECT.P_PG_NR_OF_ROWS);

      UNICONNECT2.WriteGlobalVariablesToLog;
   ELSE
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NORMAL,'         Warning ! current pg and pgnode not set before leaving pg section !');
   END IF;
   UCON_CleanupPgSection;

   RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
WHEN OTHERS THEN
   --an exception can have been raised with l_ret_code = UNAPIGEN.DBERR_SUCCESS
   --this is done to skip the section without interrupting the file processing
   IF sqlcode <> 1 THEN
      --the exception is not a user exception
      l_sqlerrm := SUBSTR(SQLERRM, 1, 200);
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Following exception catched in UCON_ExecutePgSection :');
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         '||l_sqlerrm);
      l_ret_code := UNAPIGEN.DBERR_GENFAIL;
   END IF;
   UCON_CleanupPgSection;
   UNAPIGEN.P_TXN_ERROR := l_ret_code;
   RETURN(l_ret_code);
END UCON_ExecutePgSection;

/*------------------------------------------------------*/
/* procedures and functions related to the [pa] section */
/*------------------------------------------------------*/
PROCEDURE UCON_InitialisePaSection     /* INTERNAL */
IS
BEGIN

   --local variables initialisation
   UNICONNECT.P_PA_NR_OF_ROWS := 0;
   UNICONNECT.P_PA_SC := UNICONNECT.P_GLOB_SC;
   UNICONNECT.P_PA_PG := UNICONNECT.P_GLOB_PG;
   UNICONNECT.P_PA_PGNODE := UNICONNECT.P_GLOB_PGNODE;
   UNICONNECT.P_PA_PP_KEY1 := NULL;
   UNICONNECT.P_PA_PP_KEY2 := NULL;
   UNICONNECT.P_PA_PP_KEY3 := NULL;
   UNICONNECT.P_PA_PP_KEY4 := NULL;
   UNICONNECT.P_PA_PP_KEY5 := NULL;
   UNICONNECT.P_PA_PP_VERSION := NULL;

   --internal to [pa] section
   UNICONNECT.P_PA_USE_SAVESCPARESULT := TRUE;
   UNICONNECT.P_PA_PGNAME := NULL;
   UNICONNECT.P_PA_PGDESCRIPTION := NULL;
   UNICONNECT.P_PA_ALARMS_HANDLED := NULL;

   --private package variable for [pa] section
   p_pa_pgnode_setinsection := FALSE;

   --global variables
   UNICONNECT.P_GLOB_PA := NULL;
   UNICONNECT.P_GLOB_PANODE := NULL;


END UCON_InitialisePaSection;

FUNCTION UCON_AssignPaSectionRow       /* INTERNAL */
RETURN NUMBER IS

l_description_pos      INTEGER;

BEGIN

   --Important assumption : one [pa] section is only related to one parameter group within one sample

   UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NONE,'      Assigning value of variable '||UNICONNECT.P_VARIABLE_NAME||' in [pa] section');
   IF UNICONNECT.P_VARIABLE_NAME = 'sc' THEN
      UNICONNECT.P_PA_SC := UNICONNECT.P_VARIABLE_VALUE;

   ELSIF UNICONNECT.P_VARIABLE_NAME IN ('pgnode', 'pg.pgnode') THEN
      UNICONNECT.P_PA_PGNODE := UNICONNECT.P_VARIABLE_VALUE;

      --Fatal error when pg not yet specified
      IF UNICONNECT.P_PA_PGNAME IS NULL THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major problem ! pgnode in pa section must be preceded by a pg setting');
         RETURN(UNAPIGEN.DBERR_GENFAIL);
      END IF;
      p_pa_pgnode_setinsection := TRUE;

   ELSIF UNICONNECT.P_VARIABLE_NAME IN ('pp_key1', 'pg.pp_key1') THEN
      UNICONNECT.P_PA_PP_KEY1 := NVL(UNICONNECT.P_VARIABLE_VALUE, ' ');

   ELSIF UNICONNECT.P_VARIABLE_NAME IN ('pp_key2', 'pg.pp_key2') THEN
      UNICONNECT.P_PA_PP_KEY2 := NVL(UNICONNECT.P_VARIABLE_VALUE, ' ');

   ELSIF UNICONNECT.P_VARIABLE_NAME IN ('pp_key3', 'pg.pp_key3') THEN
      UNICONNECT.P_PA_PP_KEY3 := NVL(UNICONNECT.P_VARIABLE_VALUE, ' ');

   ELSIF UNICONNECT.P_VARIABLE_NAME IN ('pp_key4', 'pg.pp_key4') THEN
      UNICONNECT.P_PA_PP_KEY4 := NVL(UNICONNECT.P_VARIABLE_VALUE, ' ');

   ELSIF UNICONNECT.P_VARIABLE_NAME IN ('pp_key5', 'pg.pp_key5') THEN
      UNICONNECT.P_PA_PP_KEY5 := NVL(UNICONNECT.P_VARIABLE_VALUE, ' ');

   ELSIF UNICONNECT.P_VARIABLE_NAME IN ('pp_version', 'pg.pp_version') THEN
      UNICONNECT.P_PA_PP_VERSION := UNICONNECT.P_VARIABLE_VALUE;

   ELSIF SUBSTR(UNICONNECT.P_VARIABLE_NAME,1,2) = 'pg' THEN
      --MUST BE PLACED after pgnode/pp_key[1-5] variable assignment since SUBSTR will return pg

      --pg can be specified by description or by name
      l_description_pos := INSTR(UNICONNECT.P_VARIABLE_NAME, '.description');
      IF l_description_pos > 0 THEN
         UNICONNECT.P_PA_PGDESCRIPTION := UNICONNECT.P_VARIABLE_VALUE;
         UNICONNECT.P_PA_PGNAME        := UNICONNECT.P_VARIABLE_NAME;
         UNICONNECT.P_PA_PG := NULL;
      ELSE
         UNICONNECT.P_PA_PG            := UNICONNECT.P_VARIABLE_VALUE;
         UNICONNECT.P_PA_PGNAME        := UNICONNECT.P_VARIABLE_NAME;
         UNICONNECT.P_PA_PGDESCRIPTION := NULL;
      END IF;

      --also reset pgnode : pgnode is initialised with global setting pgnode when entering
      --the section
      UNICONNECT.P_PA_PGNODE := NULL;

   ELSIF UNICONNECT.P_VARIABLE_NAME = 'value_f' THEN
      UNICONNECT.P_PA_VALUE_F_TAB(UNICONNECT.P_PA_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;
      UNICONNECT.P_PA_VALUE_F_MODTAB(UNICONNECT.P_PA_NR_OF_ROWS) := TRUE;
      UNICONNECT.P_PA_MODIFY_FLAG_TAB(UNICONNECT.P_PA_NR_OF_ROWS) := UNAPIGEN.MOD_FLAG_UPDATE;

   ELSIF UNICONNECT.P_VARIABLE_NAME = 'value_s' THEN
      UNICONNECT.P_PA_VALUE_S_TAB(UNICONNECT.P_PA_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;
      UNICONNECT.P_PA_VALUE_S_MODTAB(UNICONNECT.P_PA_NR_OF_ROWS) := TRUE;
      UNICONNECT.P_PA_MODIFY_FLAG_TAB(UNICONNECT.P_PA_NR_OF_ROWS) := UNAPIGEN.MOD_FLAG_UPDATE;

   ELSIF UNICONNECT.P_VARIABLE_NAME = 'unit' THEN
      UNICONNECT.P_PA_UNIT_TAB(UNICONNECT.P_PA_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;
      UNICONNECT.P_PA_UNIT_MODTAB(UNICONNECT.P_PA_NR_OF_ROWS) := TRUE;
      UNICONNECT.P_PA_MODIFY_FLAG_TAB(UNICONNECT.P_PA_NR_OF_ROWS) := UNAPIGEN.MOD_FLAG_UPDATE;

   ELSIF UNICONNECT.P_VARIABLE_NAME = 'manually_entered' THEN
      UNICONNECT.P_PA_MANUALLY_ENTERED_TAB(UNICONNECT.P_PA_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;
      UNICONNECT.P_PA_MANUALLY_ENTERED_MODTAB(UNICONNECT.P_PA_NR_OF_ROWS) := TRUE;
      UNICONNECT.P_PA_MODIFY_FLAG_TAB(UNICONNECT.P_PA_NR_OF_ROWS) := UNAPIGEN.MOD_FLAG_UPDATE;

   ELSIF UNICONNECT.P_VARIABLE_NAME = 'exec_start_date' THEN
      UNICONNECT.P_PA_EXEC_START_DATE_TAB(UNICONNECT.P_PA_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;
      UNICONNECT.P_PA_EXEC_START_DATE_MODTAB(UNICONNECT.P_PA_NR_OF_ROWS) := TRUE;
      UNICONNECT.P_PA_MODIFY_FLAG_TAB(UNICONNECT.P_PA_NR_OF_ROWS) := UNAPIGEN.MOD_FLAG_UPDATE;
      UNICONNECT.P_PA_USE_SAVESCPARESULT := FALSE;  --SaveScParameter will be used instead of SaveScPaResult
                                                 --since exec_start_date not in SaveScPaResult API

   ELSIF UNICONNECT.P_VARIABLE_NAME = 'exec_end_date' THEN
      UNICONNECT.P_PA_EXEC_END_DATE_TAB(UNICONNECT.P_PA_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;
      UNICONNECT.P_PA_EXEC_END_DATE_MODTAB(UNICONNECT.P_PA_NR_OF_ROWS) := TRUE;
      UNICONNECT.P_PA_MODIFY_FLAG_TAB(UNICONNECT.P_PA_NR_OF_ROWS) := UNAPIGEN.MOD_FLAG_UPDATE;

   ELSIF UNICONNECT.P_VARIABLE_NAME = 'executor' THEN
      UNICONNECT.P_PA_EXECUTOR_TAB(UNICONNECT.P_PA_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;
      UNICONNECT.P_PA_EXECUTOR_MODTAB(UNICONNECT.P_PA_NR_OF_ROWS) := TRUE;
      UNICONNECT.P_PA_MODIFY_FLAG_TAB(UNICONNECT.P_PA_NR_OF_ROWS) := UNAPIGEN.MOD_FLAG_UPDATE;

   ELSIF UNICONNECT.P_VARIABLE_NAME = 'add_comment' THEN
      UNICONNECT.P_PA_ADD_COMMENT_TAB(UNICONNECT.P_PA_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;

   ELSIF UNICONNECT.P_VARIABLE_NAME = 'comment' THEN
      UNICONNECT.P_PA_MODIFY_REASON := UNICONNECT.P_VARIABLE_VALUE;
      UNICONNECT.P_PA_MODIFY_FLAG_TAB(UNICONNECT.P_PA_NR_OF_ROWS) := UNAPIGEN.MOD_FLAG_UPDATE;

   ELSIF UNICONNECT.P_VARIABLE_NAME = 'ss' THEN
      UNICONNECT.P_PA_SS_TAB(UNICONNECT.P_PA_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;
      UNICONNECT.P_PA_SS_MODTAB(UNICONNECT.P_PA_NR_OF_ROWS) := TRUE;

   ELSIF UNICONNECT.P_VARIABLE_NAME = 'description' THEN
      UNICONNECT.P_PA_DESCRIPTION_TAB(UNICONNECT.P_PA_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;
      UNICONNECT.P_PA_DESCRIPTION_MODTAB(UNICONNECT.P_PA_NR_OF_ROWS) := TRUE;
      UNICONNECT.P_PA_MODIFY_FLAG_TAB(UNICONNECT.P_PA_NR_OF_ROWS) := UNAPIGEN.MOD_FLAG_UPDATE;
      UNICONNECT.P_PA_USE_SAVESCPARESULT := FALSE;  --SaveScParameter will be used instead of SaveScPaResult
                                                 --since description not in SaveScPaResult API

   ELSIF UNICONNECT.P_VARIABLE_NAME IN ('panode', 'pa.panode') THEN
      UNICONNECT.P_PA_PANODE_TAB(UNICONNECT.P_PA_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;

   ELSIF UNICONNECT.P_VARIABLE_NAME IN ('pr_version', 'pa.pr_version') THEN
      UNICONNECT.P_PA_PR_VERSION_TAB(UNICONNECT.P_PA_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;

   ELSIF SUBSTR(UNICONNECT.P_VARIABLE_NAME,1,2) = 'pa' THEN
      --MUST BE PLACED after panode variable assignment since SUBSTR will return pa
      --initialise full array except for sample code, pg and pgnode
      UNICONNECT.P_PA_NR_OF_ROWS := UNICONNECT.P_PA_NR_OF_ROWS + 1;

      --pa can be specified by description or by name
      l_description_pos := INSTR(UNICONNECT.P_VARIABLE_NAME, '.description');
      IF l_description_pos > 0 THEN
         UNICONNECT.P_PA_PADESCRIPTION_TAB(UNICONNECT.P_PA_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;
         UNICONNECT.P_PA_PA_TAB(UNICONNECT.P_PA_NR_OF_ROWS) := NULL;
      ELSE
         UNICONNECT.P_PA_PA_TAB(UNICONNECT.P_PA_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;
         UNICONNECT.P_PA_PADESCRIPTION_TAB(UNICONNECT.P_PA_NR_OF_ROWS) := NULL;
      END IF;

      UNICONNECT.P_PA_PANAME_TAB(UNICONNECT.P_PA_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_NAME;

      UNICONNECT.P_PA_PANODE_TAB(UNICONNECT.P_PA_NR_OF_ROWS)            := NULL;
      UNICONNECT.P_PA_PR_VERSION_TAB(UNICONNECT.P_PA_NR_OF_ROWS)        := NULL;
      UNICONNECT.P_PA_DESCRIPTION_TAB(UNICONNECT.P_PA_NR_OF_ROWS)       := NULL;
      UNICONNECT.P_PA_VALUE_F_TAB(UNICONNECT.P_PA_NR_OF_ROWS)           := NULL;
      UNICONNECT.P_PA_VALUE_S_TAB(UNICONNECT.P_PA_NR_OF_ROWS)           := NULL;
      UNICONNECT.P_PA_UNIT_TAB(UNICONNECT.P_PA_NR_OF_ROWS)              := NULL;
      UNICONNECT.P_PA_MANUALLY_ENTERED_TAB(UNICONNECT.P_PA_NR_OF_ROWS)  := NULL;
      UNICONNECT.P_PA_EXEC_START_DATE_TAB(UNICONNECT.P_PA_NR_OF_ROWS)   := NULL;
      UNICONNECT.P_PA_EXEC_END_DATE_TAB(UNICONNECT.P_PA_NR_OF_ROWS)     := NULL;
      UNICONNECT.P_PA_EXECUTOR_TAB(UNICONNECT.P_PA_NR_OF_ROWS)          := NULL;
      UNICONNECT.P_PA_MODIFY_FLAG_TAB(UNICONNECT.P_PA_NR_OF_ROWS)       := UNAPIGEN.DBERR_SUCCESS;
      UNICONNECT.P_PA_SS_TAB(UNICONNECT.P_PA_NR_OF_ROWS)                := NULL;
      UNICONNECT.P_PA_ADD_COMMENT_TAB(UNICONNECT.P_PA_NR_OF_ROWS)       := NULL;

      --initialise all modify flags to FALSE
      UNICONNECT.P_PA_DESCRIPTION_MODTAB(UNICONNECT.P_PA_NR_OF_ROWS)          := FALSE;
      UNICONNECT.P_PA_VALUE_F_MODTAB(UNICONNECT.P_PA_NR_OF_ROWS)              := FALSE;
      UNICONNECT.P_PA_VALUE_S_MODTAB(UNICONNECT.P_PA_NR_OF_ROWS)              := FALSE;
      UNICONNECT.P_PA_UNIT_MODTAB(UNICONNECT.P_PA_NR_OF_ROWS)                 := FALSE;
      UNICONNECT.P_PA_MANUALLY_ENTERED_MODTAB(UNICONNECT.P_PA_NR_OF_ROWS)     := FALSE;
      UNICONNECT.P_PA_EXEC_START_DATE_MODTAB(UNICONNECT.P_PA_NR_OF_ROWS)      := FALSE;
      UNICONNECT.P_PA_EXEC_END_DATE_MODTAB(UNICONNECT.P_PA_NR_OF_ROWS)        := FALSE;
      UNICONNECT.P_PA_EXECUTOR_MODTAB(UNICONNECT.P_PA_NR_OF_ROWS)             := FALSE;
      UNICONNECT.P_PA_SS_MODTAB(UNICONNECT.P_PA_NR_OF_ROWS)                   := FALSE;

   ELSE
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'      Invalid variable '||UNICONNECT.P_VARIABLE_NAME||' in [pa] section');
      RETURN(UNAPIGEN.DBERR_INVALIDVARIABLE);
   END IF;
   RETURN(UNAPIGEN.DBERR_SUCCESS);

END UCON_AssignPaSectionRow;

--PaUseValue is an Overloaded function : one returning a NUMBER and the other one reurning VARCHAR2
--PaUseValue will return the value specified in the section when effectively set in the section
--A modify_flag is maintained for each variable within the section (see UCON_AssignPaSectionRow)
--The argument a_alt_value (read alternative value) will be returned when the variable has
--not been set (affected) in the section
--

FUNCTION PaUseValue       /* INTERNAL */
(a_variable_name IN VARCHAR2,
 a_row           IN INTEGER,
 a_alt_value     IN NUMBER)
RETURN NUMBER IS

BEGIN

   IF a_variable_name = 'value_f' THEN
      IF UNICONNECT.P_PA_VALUE_F_MODTAB(a_row) THEN
         RETURN(UNICONNECT.P_PA_VALUE_F_TAB(a_row));
      END IF;
   ELSE
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'      Invalid variable '||a_variable_name||' in PaUseValue');
      RAISE StpError;
   END IF;
   RETURN(a_alt_value);

END PaUseValue;

FUNCTION PaUseValue       /* INTERNAL */
(a_variable_name IN VARCHAR2,
 a_row           IN INTEGER,
 a_alt_value     IN VARCHAR2)
RETURN VARCHAR2 IS

BEGIN

   IF a_variable_name = 'description' THEN
      IF UNICONNECT.P_PA_DESCRIPTION_MODTAB(a_row) THEN
         RETURN(UNICONNECT.P_PA_DESCRIPTION_TAB(a_row));
      END IF;
   ELSIF a_variable_name = 'value_s' THEN
      IF UNICONNECT.P_PA_VALUE_S_MODTAB(a_row) THEN
         RETURN(UNICONNECT.P_PA_VALUE_S_TAB(a_row));
      END IF;
   ELSIF a_variable_name = 'unit' THEN
      IF UNICONNECT.P_PA_UNIT_MODTAB(a_row) THEN
         RETURN(UNICONNECT.P_PA_UNIT_TAB(a_row));
      END IF;
   ELSIF a_variable_name = 'exec_start_date' THEN
      IF UNICONNECT.P_PA_EXEC_START_DATE_MODTAB(a_row) THEN
         RETURN(UNICONNECT.P_PA_EXEC_START_DATE_TAB(a_row));
      END IF;
   ELSIF a_variable_name = 'exec_end_date' THEN
      IF UNICONNECT.P_PA_EXEC_END_DATE_MODTAB(a_row) THEN
         RETURN(UNICONNECT.P_PA_EXEC_END_DATE_TAB(a_row));
      END IF;
   ELSIF a_variable_name = 'executor' THEN
      IF UNICONNECT.P_PA_EXECUTOR_MODTAB(a_row) THEN
         RETURN(UNICONNECT.P_PA_EXECUTOR_TAB(a_row));
      END IF;
   ELSIF a_variable_name = 'manually_entered' THEN
      IF UNICONNECT.P_PA_MANUALLY_ENTERED_MODTAB(a_row) THEN
         RETURN(UNICONNECT.P_PA_MANUALLY_ENTERED_TAB(a_row));
      END IF;
   ELSE
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'      Invalid variable '||a_variable_name||' in PaUseValue');
      RAISE StpError;
   END IF;
   RETURN(a_alt_value);

END PaUseValue;

--FindScPa returns the utscpa record corresponding
--to a specific search syntax
--See FindScPg for examples

FUNCTION FindScPa (a_sc          IN     VARCHAR2,
                   a_pg          IN     VARCHAR2,
                   a_pgnode      IN     NUMBER,
                   a_pp_key1     IN     VARCHAR2,
                   a_pp_key2     IN     VARCHAR2,
                   a_pp_key3     IN     VARCHAR2,
                   a_pp_key4     IN     VARCHAR2,
                   a_pp_key5     IN     VARCHAR2,
                   a_pp_version  IN     VARCHAR2,
                   a_pa          IN OUT VARCHAR2,
                   a_description IN     VARCHAR2,
                   a_panode      IN     NUMBER,
                   a_pr_version  IN     VARCHAR2,
                   a_search_base IN     VARCHAR2,
                   a_pos         IN INTEGER,
                   a_current_row IN INTEGER)
RETURN utscpa%ROWTYPE IS

l_pa_rec       utscpa%ROWTYPE;
l_leave_loop   BOOLEAN DEFAULT FALSE;
l_used         BOOLEAN DEFAULT FALSE;
l_counter      INTEGER;

CURSOR l_scpa_cursor IS
   SELECT b.*
   FROM utscpa b, utscpg a
   -- subquery must be consistent with FindScPg query EXCEPT that pg is not mandatory in this subquery
   WHERE a.sc = a_sc
   AND a.pg = NVL(a_pg, a.pg)
   AND a.pgnode = NVL(a_pgnode, a.pgnode)
   AND a.pp_key1 = DECODE(a_pgnode, NULL, DECODE(a_pp_key1, NULL, a.pp_key1, a_pp_key1), a.pp_key1)
   AND a.pp_key2 = DECODE(a_pgnode, NULL, DECODE(a_pp_key2, NULL, a.pp_key2, a_pp_key2), a.pp_key2)
   AND a.pp_key3 = DECODE(a_pgnode, NULL, DECODE(a_pp_key3, NULL, a.pp_key3, a_pp_key3), a.pp_key3)
   AND a.pp_key4 = DECODE(a_pgnode, NULL, DECODE(a_pp_key4, NULL, a.pp_key4, a_pp_key4), a.pp_key4)
   AND a.pp_key5 = DECODE(a_pgnode, NULL, DECODE(a_pp_key5, NULL, a.pp_key5, a_pp_key5), a.pp_key5)
   AND NVL(a.pp_version, '0') = NVL(a_pp_version, NVL(a.pp_version, '0'))
   AND b.sc = a.sc
   AND b.pg = a.pg
   AND b.pgnode = a.pgnode
   AND b.pa = a_pa
   AND b.panode = NVL(a_panode, b.panode)
   AND NVL(b.pr_version, '0') = NVL(a_pr_version, NVL(b.pr_version, '0'))
   ORDER BY b.pgnode, b.panode;

CURSOR l_scpa_notexecuted_cursor IS
   SELECT b.*
   FROM utscpa b, utscpg a
   -- subquery must be consistent with FindScPg query EXCEPT that pg is not mandatory in this subquery
   WHERE a.sc = a_sc
   AND a.pg = NVL(a_pg, a.pg)
   AND a.pgnode = NVL(a_pgnode, a.pgnode)
   AND a.pp_key1 = DECODE(a_pgnode, NULL, DECODE(a_pp_key1, NULL, a.pp_key1, a_pp_key1), a.pp_key1)
   AND a.pp_key2 = DECODE(a_pgnode, NULL, DECODE(a_pp_key2, NULL, a.pp_key2, a_pp_key2), a.pp_key2)
   AND a.pp_key3 = DECODE(a_pgnode, NULL, DECODE(a_pp_key3, NULL, a.pp_key3, a_pp_key3), a.pp_key3)
   AND a.pp_key4 = DECODE(a_pgnode, NULL, DECODE(a_pp_key4, NULL, a.pp_key4, a_pp_key4), a.pp_key4)
   AND a.pp_key5 = DECODE(a_pgnode, NULL, DECODE(a_pp_key5, NULL, a.pp_key5, a_pp_key5), a.pp_key5)
   AND NVL(a.pp_version, '0') = NVL(a_pp_version, NVL(a.pp_version, '0'))
   AND b.sc = a.sc
   AND b.pg = a.pg
   AND b.pgnode = a.pgnode
   AND b.pa = a_pa
   AND b.panode = NVL(a_panode, b.panode)
   AND NVL(b.pr_version, '0') = NVL(a_pr_version, NVL(b.pr_version, '0'))
   AND b.exec_end_date IS NULL
   ORDER BY b.pgnode, b.panode;

CURSOR l_scpadesc_cursor IS
   SELECT b.*
   FROM utscpa b, utscpg a
   -- subquery must be consistent with FindScPg query EXCEPT that pg is not mandatory in this subquery
   WHERE a.sc = a_sc
   AND a.pg = NVL(a_pg, a.pg)
   AND a.pgnode = NVL(a_pgnode, a.pgnode)
   AND a.pp_key1 = DECODE(a_pgnode, NULL, DECODE(a_pp_key1, NULL, a.pp_key1, a_pp_key1), a.pp_key1)
   AND a.pp_key2 = DECODE(a_pgnode, NULL, DECODE(a_pp_key2, NULL, a.pp_key2, a_pp_key2), a.pp_key2)
   AND a.pp_key3 = DECODE(a_pgnode, NULL, DECODE(a_pp_key3, NULL, a.pp_key3, a_pp_key3), a.pp_key3)
   AND a.pp_key4 = DECODE(a_pgnode, NULL, DECODE(a_pp_key4, NULL, a.pp_key4, a_pp_key4), a.pp_key4)
   AND a.pp_key5 = DECODE(a_pgnode, NULL, DECODE(a_pp_key5, NULL, a.pp_key5, a_pp_key5), a.pp_key5)
   AND NVL(a.pp_version, '0') = NVL(a_pp_version, NVL(a.pp_version, '0'))
   AND b.sc = a.sc
   AND b.pg = a.pg
   AND b.pgnode = a.pgnode
   AND b.description = a_description
   AND b.panode = NVL(a_panode, b.panode)
   AND NVL(b.pr_version, '0') = NVL(a_pr_version, NVL(b.pr_version, '0'))
   ORDER BY b.pgnode, b.panode;

CURSOR l_scpadesc_notexecuted_cursor IS
   SELECT b.*
   FROM utscpa b, utscpg a
   -- subquery must be consistent with FindScPg query EXCEPT that pg is not mandatory in this subquery
   WHERE a.sc = a_sc
   AND a.pg = NVL(a_pg, a.pg)
   AND a.pgnode = NVL(a_pgnode, a.pgnode)
   AND a.pp_key1 = DECODE(a_pgnode, NULL, DECODE(a_pp_key1, NULL, a.pp_key1, a_pp_key1), a.pp_key1)
   AND a.pp_key2 = DECODE(a_pgnode, NULL, DECODE(a_pp_key2, NULL, a.pp_key2, a_pp_key2), a.pp_key2)
   AND a.pp_key3 = DECODE(a_pgnode, NULL, DECODE(a_pp_key3, NULL, a.pp_key3, a_pp_key3), a.pp_key3)
   AND a.pp_key4 = DECODE(a_pgnode, NULL, DECODE(a_pp_key4, NULL, a.pp_key4, a_pp_key4), a.pp_key4)
   AND a.pp_key5 = DECODE(a_pgnode, NULL, DECODE(a_pp_key5, NULL, a.pp_key5, a_pp_key5), a.pp_key5)
   AND NVL(a.pp_version, '0') = NVL(a_pp_version, NVL(a.pp_version, '0'))
   AND b.sc = a.sc
   AND b.pg = a.pg
   AND b.pgnode = a.pgnode
   AND b.description = a_description
   AND b.panode = NVL(a_panode, b.panode)
   AND NVL(b.pr_version, '0') = NVL(a_pr_version, NVL(b.pr_version, '0'))
   AND b.exec_end_date IS NULL
   ORDER BY b.pgnode, b.panode;

BEGIN
   l_pa_rec := NULL;

   IF a_search_base = 'pa' THEN
      IF a_pos IS NULL THEN


         --find first pa which is not executed and which is not used
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Searching for first pa which is not executed and not used for sc='||
                                                a_sc|| '#pg='||a_pg||'#pgnode='||NVL(TO_CHAR(a_pgnode),'NULL'));
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         #pp_key1='|| a_pp_key1||'#pp_key2='||a_pp_key2||'#pp_key3='||a_pp_key3||
                                                        '#pp_key4='||a_pp_key4||'#pp_key5='||a_pp_key5||'#pp_version='||a_pp_version);
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         #pa='||a_pa||'#panode='||NVL(TO_CHAR(a_panode),'NULL')||'#pr_version='||a_pr_version||'#');
         OPEN l_scpa_notexecuted_cursor;
         LOOP
            FETCH l_scpa_notexecuted_cursor
            INTO l_pa_rec;
            EXIT WHEN l_scpa_notexecuted_cursor%NOTFOUND;
            --check if pa/panode combination already used
            l_used := FALSE;
            FOR l_row IN 1..UNICONNECT.P_PA_NR_OF_ROWS LOOP
               IF UNICONNECT.P_PA_PA_TAB(l_row) = a_pa THEN
                  IF UNICONNECT.P_PA_PANODE_TAB(l_row) = l_pa_rec.panode THEN
                     IF a_current_row <> l_row THEN
                        l_used := TRUE;
                     END IF;
                  END IF;
               END IF;
            END LOOP;
            IF l_used THEN
               l_pa_rec := NULL;
            ELSE
               EXIT;
            END IF;
         END LOOP;
         CLOSE l_scpa_notexecuted_cursor;
      ELSE

         --find pa in xth position (x=a_pos)
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Searching for pa in position '||TO_CHAR(a_pos)||' for sc='||
                                                a_sc|| '#pg='||a_pg||'#pgnode='||NVL(TO_CHAR(a_pgnode),'NULL'));
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         #pp_key1='|| a_pp_key1||'#pp_key2='||a_pp_key2||'#pp_key3='||a_pp_key3||
                                                        '#pp_key4='||a_pp_key4||'#pp_key5='||a_pp_key5||'#pp_version='||a_pp_version);
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         #pa='||a_pa||'#panode='||NVL(TO_CHAR(a_panode),'NULL')||'#pr_version='||a_pr_version||'#');
         OPEN l_scpa_cursor;
         l_counter := 0;
         LOOP
            FETCH l_scpa_cursor
            INTO l_pa_rec;
            EXIT WHEN l_scpa_cursor%NOTFOUND;
            --check if pa/panode combination already used
            l_counter := l_counter + 1;
            IF l_counter >= a_pos THEN
               EXIT;
            ELSE
               l_pa_rec := NULL;
            END IF;
         END LOOP;
         CLOSE l_scpa_cursor;

      END IF;
   ELSE
      IF a_pos IS NULL THEN

         --find first pa which is not executed and which is not used
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Searching for first pa (description) which is not executed and not used for sc='||
                                                a_sc||'#pg='||a_pg||'#pgnode='||NVL(TO_CHAR(a_pgnode),'NULL')||
                                                '#description='||a_description);
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         #pp_key1='|| a_pp_key1||'#pp_key2='||a_pp_key2||'#pp_key3='||a_pp_key3||
                                                        '#pp_key4='||a_pp_key4||'#pp_key5='||a_pp_key5||'#pp_version='||a_pp_version);
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         #pa='||a_pa||'#panode='||NVL(TO_CHAR(a_panode),'NULL')||'#pr_version='||a_pr_version||'#');
         OPEN l_scpadesc_notexecuted_cursor;
         LOOP
            FETCH l_scpadesc_notexecuted_cursor
            INTO l_pa_rec;
            EXIT WHEN l_scpadesc_notexecuted_cursor%NOTFOUND;
            --check if pa/panode combination already used
            l_used := FALSE;
            FOR l_row IN 1..UNICONNECT.P_PA_NR_OF_ROWS LOOP
               IF UNICONNECT.P_PA_PA_TAB(l_row) = l_pa_rec.pa THEN
                  IF UNICONNECT.P_PA_PANODE_TAB(l_row) = l_pa_rec.panode THEN
                     IF a_current_row <> l_row THEN
                        l_used := TRUE;
                     END IF;
                  END IF;
               END IF;
            END LOOP;
            IF l_used THEN
               l_pa_rec.panode := NULL;
            ELSE
               a_pa := l_pa_rec.pa;
               EXIT;
            END IF;
         END LOOP;
         CLOSE l_scpadesc_notexecuted_cursor;
      ELSE

         --find pa in xth position (x=a_pos)
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Searching for pa (description) in position '||TO_CHAR(a_pos)||' for sc='||
                                                a_sc||'#pg='||a_pg||'#pgnode='||NVL(TO_CHAR(a_pgnode),'NULL')||
                                                '#description='||a_description);
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         #pp_key1='|| a_pp_key1||'#pp_key2='||a_pp_key2||'#pp_key3='||a_pp_key3||
                                                        '#pp_key4='||a_pp_key4||'#pp_key5='||a_pp_key5||'#pp_version='||a_pp_version);
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         #pa='||a_pa||'#panode='||NVL(TO_CHAR(a_panode),'NULL')||'#pr_version='||a_pr_version||'#');
         OPEN l_scpadesc_cursor;
         l_counter := 0;
         LOOP
            FETCH l_scpadesc_cursor
            INTO l_pa_rec;
            EXIT WHEN l_scpadesc_cursor%NOTFOUND;
            --check if pa/panode combination already used
            l_counter := l_counter + 1;
            IF l_counter >= a_pos THEN
               a_pa := l_pa_rec.pa;
               EXIT;
            ELSE
               l_pa_rec := NULL;
            END IF;
         END LOOP;
         CLOSE l_scpadesc_cursor;

      END IF;
   END IF;

   RETURN (l_pa_rec);

END FindScPa;

PROCEDURE UCON_CleanupPaSection IS
BEGIN
   --Important since these variables should only
   --last for the execution of the [pa] section
   --but have to be implemented as global package variables
   --to keep it mantainable

   UNICONNECT.P_PA_SC_TAB.DELETE;
   UNICONNECT.P_PA_PG_TAB.DELETE;
   UNICONNECT.P_PA_PGNODE_TAB.DELETE;
   UNICONNECT.P_PA_PA_TAB.DELETE;

   UNICONNECT.P_PA_PANAME_TAB.DELETE;
   UNICONNECT.P_PA_PADESCRIPTION_TAB.DELETE;

   UNICONNECT.P_PA_PANODE_TAB.DELETE;

   UNICONNECT.P_PA_PR_VERSION_TAB.DELETE;
   UNICONNECT.P_PA_DESCRIPTION_TAB.DELETE;
   UNICONNECT.P_PA_VALUE_F_TAB.DELETE;
   UNICONNECT.P_PA_VALUE_S_TAB.DELETE;
   UNICONNECT.P_PA_UNIT_TAB.DELETE;
   UNICONNECT.P_PA_EXEC_START_DATE_TAB.DELETE;
   UNICONNECT.P_PA_EXEC_END_DATE_TAB.DELETE;
   UNICONNECT.P_PA_EXECUTOR_TAB.DELETE;
   UNICONNECT.P_PA_PLANNED_EXECUTOR_TAB.DELETE;
   UNICONNECT.P_PA_MANUALLY_ENTERED_TAB.DELETE;
   UNICONNECT.P_PA_ASSIGN_DATE_TAB.DELETE;
   UNICONNECT.P_PA_ASSIGNED_BY_TAB.DELETE;
   UNICONNECT.P_PA_MANUALLY_ADDED_TAB.DELETE;
   UNICONNECT.P_PA_FORMAT_TAB.DELETE;
   UNICONNECT.P_PA_TD_INFO_TAB.DELETE;
   UNICONNECT.P_PA_TD_INFO_UNIT_TAB.DELETE;
   UNICONNECT.P_PA_CONFIRM_UID_TAB.DELETE;
   UNICONNECT.P_PA_ALLOW_ANY_ME_TAB.DELETE;
   UNICONNECT.P_PA_DELAY_TAB.DELETE;
   UNICONNECT.P_PA_DELAY_UNIT_TAB.DELETE;
   UNICONNECT.P_PA_MIN_NR_RESULTS_TAB.DELETE;
   UNICONNECT.P_PA_CALC_METHOD_TAB.DELETE;
   UNICONNECT.P_PA_CALC_CF_TAB.DELETE;
   UNICONNECT.P_PA_ALARM_ORDER_TAB.DELETE;
   UNICONNECT.P_PA_VALID_SPECSA_TAB.DELETE;
   UNICONNECT.P_PA_VALID_SPECSB_TAB.DELETE;
   UNICONNECT.P_PA_VALID_SPECSC_TAB.DELETE;
   UNICONNECT.P_PA_VALID_LIMITSA_TAB.DELETE;
   UNICONNECT.P_PA_VALID_LIMITSB_TAB.DELETE;
   UNICONNECT.P_PA_VALID_LIMITSC_TAB.DELETE;
   UNICONNECT.P_PA_VALID_TARGETA_TAB.DELETE;
   UNICONNECT.P_PA_VALID_TARGETB_TAB.DELETE;
   UNICONNECT.P_PA_VALID_TARGETC_TAB.DELETE;
   UNICONNECT.P_PA_MT_TAB.DELETE;
   UNICONNECT.P_PA_MT_VERSION_TAB.DELETE;
   UNICONNECT.P_PA_MT_NR_MEASUR_TAB.DELETE;
   UNICONNECT.P_PA_LOG_EXCEPTIONS_TAB.DELETE;
   UNICONNECT.P_PA_PA_CLASS_TAB.DELETE;
   UNICONNECT.P_PA_LOG_HS_TAB.DELETE;
   UNICONNECT.P_PA_LOG_HS_DETAILS_TAB.DELETE;
   UNICONNECT.P_PA_LC_TAB.DELETE;
   UNICONNECT.P_PA_LC_VERSION_TAB.DELETE;
   UNICONNECT.P_PA_MODIFY_FLAG_TAB.DELETE;
   UNICONNECT.P_PA_REANALYSIS_TAB.DELETE;
   UNICONNECT.P_PA_SS_TAB.DELETE;
   UNICONNECT.P_PA_ADD_COMMENT_TAB.DELETE;

   UNICONNECT.P_PA_DESCRIPTION_MODTAB.DELETE;
   UNICONNECT.P_PA_VALUE_F_MODTAB.DELETE;
   UNICONNECT.P_PA_VALUE_S_MODTAB.DELETE;
   UNICONNECT.P_PA_UNIT_MODTAB.DELETE;
   UNICONNECT.P_PA_MANUALLY_ENTERED_MODTAB.DELETE;
   UNICONNECT.P_PA_EXEC_START_DATE_MODTAB.DELETE;
   UNICONNECT.P_PA_EXEC_END_DATE_MODTAB.DELETE;
   UNICONNECT.P_PA_EXECUTOR_MODTAB.DELETE;
   UNICONNECT.P_PA_SS_MODTAB.DELETE;

   UNICONNECT.P_PA_SC := NULL;
   UNICONNECT.P_PA_PG := NULL;
   UNICONNECT.P_PA_PGNAME := NULL;
   UNICONNECT.P_PA_PGDESCRIPTION := NULL;
   UNICONNECT.P_PA_PP_KEY1 := NULL;
   UNICONNECT.P_PA_PP_KEY2 := NULL;
   UNICONNECT.P_PA_PP_KEY3 := NULL;
   UNICONNECT.P_PA_PP_KEY4 := NULL;
   UNICONNECT.P_PA_PP_KEY5 := NULL;
   UNICONNECT.P_PA_PP_VERSION := NULL;
   UNICONNECT.P_PA_PGNODE := NULL;
   UNICONNECT.P_PA_ALARMS_HANDLED := NULL;
   UNICONNECT.P_PA_USE_SAVESCPARESULT := FALSE;
   UNICONNECT.P_PA_MODIFY_REASON  := NULL;
   UNICONNECT.P_PA_NR_OF_ROWS := 0;
END UCON_CleanupPaSection;

FUNCTION UCON_ExecutePaSection         /* INTERNAL */
RETURN NUMBER IS

l_sc                   VARCHAR2(20);
l_variable_name        VARCHAR2(20);
l_description_pos      INTEGER;
l_openbrackets_pos     INTEGER;
l_closebrackets_pos    INTEGER;
l_pg_pos               INTEGER;
l_pg_rec_found         utscpg%ROWTYPE;
l_pr                   VARCHAR2(20);
l_pa_pos               INTEGER;
l_pa_rec_found         utscpa%ROWTYPE;
l_any_save             BOOLEAN DEFAULT FALSE;
l_used_api             VARCHAR2(30);
l_slashpg_pgnode       NUMBER(9);
l_slashpg_searched     BOOLEAN;
l_reanalysis           NUMBER(3);
l_internal_transaction BOOLEAN DEFAULT FALSE;
l_ret_code             INTEGER;

/* InitScParameter : local variables */
l_initpa_pr                          VARCHAR2(20);
l_initpa_pr_version_in               VARCHAR2(20);
l_initpa_seq                         NUMBER;
l_initpa_sc                          VARCHAR2(20);
l_initpa_pg                          VARCHAR2(20);
l_initpa_pgnode                      NUMBER;
l_initpa_pp_version                  VARCHAR2(20);
l_initpa_nr_of_rows                  NUMBER;
l_initpa_pr_version_tab              UNAPIGEN.VC20_TABLE_TYPE;
l_initpa_description_tab             UNAPIGEN.VC40_TABLE_TYPE;
l_initpa_value_f_tab                 UNAPIGEN.FLOAT_TABLE_TYPE;
l_initpa_value_s_tab                 UNAPIGEN.VC40_TABLE_TYPE;
l_initpa_unit_tab                    UNAPIGEN.VC20_TABLE_TYPE;
l_initpa_exec_start_date_tab         UNAPIGEN.DATE_TABLE_TYPE;
l_initpa_exec_end_date_tab           UNAPIGEN.DATE_TABLE_TYPE;
l_initpa_executor_tab                UNAPIGEN.VC20_TABLE_TYPE;
l_initpa_planned_executor_tab        UNAPIGEN.VC20_TABLE_TYPE;
l_initpa_manually_entered_tab        UNAPIGEN.CHAR1_TABLE_TYPE;
l_initpa_assign_date_tab             UNAPIGEN.DATE_TABLE_TYPE;
l_initpa_assigned_by_tab             UNAPIGEN.VC20_TABLE_TYPE;
l_initpa_manually_added_tab          UNAPIGEN.CHAR1_TABLE_TYPE;
l_initpa_format_tab                  UNAPIGEN.VC40_TABLE_TYPE;
l_initpa_td_info_tab                 UNAPIGEN.NUM_TABLE_TYPE;
l_initpa_td_info_unit_tab            UNAPIGEN.VC20_TABLE_TYPE;
l_initpa_confirm_uid_tab             UNAPIGEN.CHAR1_TABLE_TYPE;
l_initpa_allow_any_me_tab            UNAPIGEN.CHAR1_TABLE_TYPE;
l_initpa_delay_tab                   UNAPIGEN.NUM_TABLE_TYPE;
l_initpa_delay_unit_tab              UNAPIGEN.VC20_TABLE_TYPE;
l_initpa_min_nr_results_tab          UNAPIGEN.NUM_TABLE_TYPE;
l_initpa_calc_method_tab             UNAPIGEN.CHAR1_TABLE_TYPE;
l_initpa_calc_cf_tab                 UNAPIGEN.VC20_TABLE_TYPE;
l_initpa_alarm_order_tab             UNAPIGEN.VC3_TABLE_TYPE;
l_initpa_valid_specsa_tab            UNAPIGEN.CHAR1_TABLE_TYPE;
l_initpa_valid_specsb_tab            UNAPIGEN.CHAR1_TABLE_TYPE;
l_initpa_valid_specsc_tab            UNAPIGEN.CHAR1_TABLE_TYPE;
l_initpa_valid_limitsa_tab           UNAPIGEN.CHAR1_TABLE_TYPE;
l_initpa_valid_limitsb_tab           UNAPIGEN.CHAR1_TABLE_TYPE;
l_initpa_valid_limitsc_tab           UNAPIGEN.CHAR1_TABLE_TYPE;
l_initpa_valid_targeta_tab           UNAPIGEN.CHAR1_TABLE_TYPE;
l_initpa_valid_targetb_tab           UNAPIGEN.CHAR1_TABLE_TYPE;
l_initpa_valid_targetc_tab           UNAPIGEN.CHAR1_TABLE_TYPE;
l_initpa_mt_tab                      UNAPIGEN.VC20_TABLE_TYPE;
l_initpa_mt_version_tab              UNAPIGEN.VC20_TABLE_TYPE;
l_initpa_mt_nr_measur_tab            UNAPIGEN.NUM_TABLE_TYPE;
l_initpa_log_exceptions_tab          UNAPIGEN.CHAR1_TABLE_TYPE;
l_initpa_reanalysis_tab              UNAPIGEN.NUM_TABLE_TYPE;
l_initpa_pa_class_tab                UNAPIGEN.VC2_TABLE_TYPE;
l_initpa_log_hs_tab                  UNAPIGEN.CHAR1_TABLE_TYPE;
l_initpa_log_hs_details_tab          UNAPIGEN.CHAR1_TABLE_TYPE;
l_initpa_lc_tab                      UNAPIGEN.VC2_TABLE_TYPE;
l_initpa_lc_version_tab              UNAPIGEN.VC20_TABLE_TYPE;

CURSOR l_prdescription_cursor (a_description IN VARCHAR2,
                               a_pr_version  IN VARCHAR2) IS
   SELECT pr
   FROM utpr
   WHERE description = a_description
   AND NVL(version, '0') = NVL(a_pr_version, NVL(version, '0'));

CURSOR l_slashpg_cursor (a_sc IN VARCHAR2) IS
   SELECT pgnode
   FROM utscpg
   WHERE sc = a_sc
   AND pg = '/';

   FUNCTION ChangeScPaStatusOrCancel
    (a_sc                IN      VARCHAR2,     /* VC20_TYPE */
     a_pg                IN      VARCHAR2,     /* VC20_TYPE */
     a_pgnode            IN      NUMBER,       /* LONG_TYPE */
     a_pa                IN      VARCHAR2,     /* VC20_TYPE */
     a_panode            IN      NUMBER,       /* LONG_TYPE */
     a_new_ss            IN      VARCHAR2,     /* VC2_TYPE */
     a_modify_reason     IN      VARCHAR2)     /* VC255_TYPE */
   RETURN NUMBER
   IS

   l_ret_code                    INTEGER;
   --Specific local variables for ChangeScPa and CancelScPa
   l_old_ss                      VARCHAR2(2);
   l_lc                          VARCHAR2(2);
   l_lc_version                  VARCHAR2(20);

   --Specific local variables for InsertEvent
   l_seq_nr                      NUMBER;
   l_pr_version                  VARCHAR2(20);

   --temp variables used to stroe original retries settings
   l_tmp_retrieswhenintransition  INTEGER;
   l_tmp_intervalwhenintransition NUMBER;

   BEGIN

   -- IN and IN OUT arguments
   l_old_ss := NULL;
   l_lc := NULL;
   l_lc_version := NULL;
   l_ret_code := UNAPIGEN.DBERR_SUCCESS;

   l_ret_code := UNICONNECT7.UCON_CheckElecSignature(a_new_ss);
   IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
     RETURN(l_ret_code);
   END IF;

   --reduce the time-out for in-transition objects (retsored at the end) to 400 ms
   l_tmp_retrieswhenintransition := UNAPIEV.P_RETRIESWHENINTRANSITION;
   l_tmp_intervalwhenintransition := UNAPIEV.P_INTERVALWHENINTRANSITION;
   --UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         In-transition interval is:'||UNAPIEV.P_RETRIESWHENINTRANSITION||' retries with a wait of '||UNAPIEV.P_INTERVALWHENINTRANSITION||' second(s)');
   UNAPIEV.P_RETRIESWHENINTRANSITION  := UNICONNECT.P_CSS_RETRIESWHENINTRANSITION;
   UNAPIEV.P_INTERVALWHENINTRANSITION := UNICONNECT.P_CSS_INTERVALWHENINTRANSITION;
   --UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         In-transition interval set to:'||UNAPIEV.P_RETRIESWHENINTRANSITION||' retries with a wait of '||UNAPIEV.P_INTERVALWHENINTRANSITION||' second(s)');

   IF a_new_ss <> '@C' THEN
      l_ret_code := UNAPIPAP.ChangeScPaStatus (a_sc, a_pg, a_pgnode, a_pa, a_panode, l_old_ss, a_new_ss, l_lc, l_lc_version, a_modify_reason);

      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         ChangeScPaStatus ret_code='||l_ret_code||
                                '#sc='||a_sc||'#pg='||a_pg||'#pgnode='||a_pgnode);
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         #pa='||a_pa||'#panode='||a_panode);
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         #old_ss='||l_old_ss||'#new_ss='||a_new_ss);
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         #lc='||l_lc||'#lc_version='||l_lc_version);
   ELSIF a_new_ss = '@C' THEN
      l_ret_code := UNAPIPAP.CancelScPa (a_sc, a_pg, a_pgnode, a_pa, a_panode, a_modify_reason);
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         CancelScPa ret_code='||l_ret_code||
                                '#sc='||a_sc||'#pg='||a_pg||'#pgnode='||a_pgnode);
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         #pa='||a_pa||'#panode='||a_panode);
   END IF;
   IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NORMAL,'         CancelScPa/ChSsScPa failed:ret_code='||l_ret_code||
                                '#sc='||a_sc||'#pg='||a_pg||'#pgnode='||a_pgnode);
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         #pa='||a_pa||'#panode='||a_panode
                                ||'. Event will be sent instead.');
      IF UNAPIAUT.P_NOT_AUTHORISED IS NOT NULL THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NORMAL,'         Authorisation error='||UNAPIAUT.P_NOT_AUTHORISED);
      END IF;
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_SUCCESS; --to be sure that no rollback is taking place on EndTransaction
      --InsertEvent ParameterUpdated with ss_to=<new status>
      l_seq_nr := NULL;
      SELECT pr_version
      INTO l_pr_version
      FROM utscpa
      WHERE sc = a_sc
      AND pg = a_pg
      AND pgnode = a_pgnode
      AND pa = a_pa
      AND panode = a_panode;
      l_ret_code := UNAPIEV.InsertEvent
                      (a_api_name          => 'ChangeScPaStatusOrCancel',
                       a_evmgr_name        => UNAPIGEN.P_EVMGR_NAME,
                       a_object_tp         => 'pa',
                       a_object_id         => a_pa,
                       a_object_lc         => NULL,
                       a_object_lc_version => NULL,
                       a_object_ss         => NULL,
                       a_ev_tp             => 'ParameterUpdated',
                       a_ev_details        => 'sc='||a_sc||
                                              '#pg='||a_pg||'#pgnode='||a_pgnode||
                                              '#panode='||a_panode||
                                              '#pr_version='||l_pr_version||'#ss_to='||a_new_ss,
                       a_seq_nr            => l_seq_nr);
      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         InsertEvent failed ret_code='||l_ret_code);
      ELSE
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW  ,'         InsertEvent OK');
      END IF;
   END IF;
   --restore original time-out for in-transition objects
   UNAPIEV.P_RETRIESWHENINTRANSITION  := l_tmp_retrieswhenintransition;
   UNAPIEV.P_INTERVALWHENINTRANSITION := l_tmp_intervalwhenintransition;
   --UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         In-transition interval restored to:'||UNAPIEV.P_RETRIESWHENINTRANSITION||' retries with a wait of '||UNAPIEV.P_INTERVALWHENINTRANSITION||' second(s)');

   RETURN(l_ret_code);
   EXCEPTION
   WHEN OTHERS THEN
      --restore original time-out for in-transition objects
      UNAPIEV.P_RETRIESWHENINTRANSITION  := l_tmp_retrieswhenintransition;
      UNAPIEV.P_INTERVALWHENINTRANSITION := l_tmp_intervalwhenintransition;
      --UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         In-transition interval restored to:'||UNAPIEV.P_RETRIESWHENINTRANSITION||' retries with a wait of '||UNAPIEV.P_INTERVALWHENINTRANSITION||' second(s)');
      RAISE;
   END ChangeScPaStatusOrCancel;

BEGIN
   l_ret_code := UNAPIGEN.DBERR_SUCCESS;
   --Multiple API calls are performed in this section
   --A transaction is started when necessary
   IF UNAPIGEN.P_TXN_LEVEL = 0 THEN
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Starting implicit transaction');
      l_return := UNAPIGEN.BeginTransaction;
      IF l_return <> UNAPIGEN.DBERR_SUCCESS THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         UNAPIGEN.BeginTransaction failed ! ret_code='||TO_CHAR(l_return));
      END IF;
      l_internal_transaction := TRUE;
   ELSE
      l_internal_transaction := FALSE;
   END IF;

   --1. sc validation
   IF UNICONNECT.P_PA_SC IS NULL THEN
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : sample is mandatory for [pa] section !');
      l_ret_code := UNAPIGEN.DBERR_NOPARENTOBJECT;
      RAISE StpError;
   END IF;

   --2. sc modified in [pa] section ?
   --    NO    set global variable SC
   --    YES   verify if provided sample code exist :error when not + set global variable SC
   --    Copy sc in savescpa... array
   IF UNICONNECT.P_GLOB_SC <> UNICONNECT.P_PA_SC THEN
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Sc directly searched:'||UNICONNECT.P_PA_SC);
      OPEN l_sc_cursor(UNICONNECT.P_PA_SC);
      FETCH l_sc_cursor
      INTO l_sc;
      CLOSE l_sc_cursor;
      IF l_sc IS NULL THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : sc does not exist ! sc is mandatory for [pa] section !');
         l_ret_code := UNAPIGEN.DBERR_NOPARENTOBJECT;
         RAISE StpError;
      END IF;
      UNICONNECT.P_GLOB_SC := UNICONNECT.P_PA_SC;
   ELSE
      UNICONNECT.P_GLOB_SC := UNICONNECT.P_PA_SC;
   END IF;

   FOR l_row IN 1..UNICONNECT.P_PA_NR_OF_ROWS LOOP
      UNICONNECT.P_PA_SC_TAB(l_row) := UNICONNECT.P_GLOB_SC;
   END LOOP;

   -- suppressed due to a change request on 16/09/1999 (pg/pgnode are nomore mandatory)
   --
   --3. pg=NULL ?
   --   NO OK
   --   YES   Major error : pa section without pg specified in a preceding section
   --IF UNICONNECT.P_PA_PG IS NULL AND
   --   UNICONNECT.P_PA_PGDESCRIPTION IS NULL THEN
   --   UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : pg is mandatory for [pa] section !');
   --   RETURN(UNAPIGEN.DBERR_NOPARENTOBJECT);
   --END IF;

   --4. pg or pgnode modified in [pa] section
   --   NO set global varaibles PG and PGNODE
   --   YES   verify if provided pg exist :error when not + set global variable PG and PGNODE
   --      PAY attention the pg[x],pg[] and .description are supported in this case
   --   Copy PG and PGNODE in savescpa... array
   IF UNICONNECT.P_PA_PGNAME IS NOT NULL THEN

      --description used ? -> find pp in utpp
      l_variable_name := NVL(UNICONNECT.P_PA_PGNAME, 'pg');
      l_description_pos := INSTR(l_variable_name, '.description');
      l_openbrackets_pos := INSTR(l_variable_name, '[');
      l_closebrackets_pos := INSTR(l_variable_name, ']');
      l_pg_pos := TO_NUMBER(SUBSTR(l_variable_name,l_openbrackets_pos+1,l_closebrackets_pos-l_openbrackets_pos-1));

      UNICONNECT.P_PG_NR_OF_ROWS := 0; --to be sure pg arrays are not searched
      l_pg_rec_found := NULL;

      IF l_openbrackets_pos = 0 THEN
         IF l_description_pos = 0 THEN
            --pg or pg.pg used
            --passed pp_keys left blank since pgnode is mostly fixed at this point
            l_pg_rec_found := FindScPg(UNICONNECT.P_GLOB_SC, UNICONNECT.P_PA_PG, UNICONNECT.P_PA_PGDESCRIPTION,
                                       UNICONNECT.P_PA_PGNODE,
                                       UNICONNECT.P_PA_PP_KEY1, UNICONNECT.P_PA_PP_KEY2, UNICONNECT.P_PA_PP_KEY3, UNICONNECT.P_PA_PP_KEY4, UNICONNECT.P_PA_PP_KEY5,
                                       UNICONNECT.P_PA_PP_VERSION,
                                       'pg',        1, NULL);
         ELSE
            --pg.description used
            --passed pp_keys left blank since pgnode is mostly fixed at this point
            l_pg_rec_found := FindScPg(UNICONNECT.P_GLOB_SC, UNICONNECT.P_PA_PG, UNICONNECT.P_PA_PGDESCRIPTION,
                                       UNICONNECT.P_PA_PGNODE,
                                       UNICONNECT.P_PA_PP_KEY1, UNICONNECT.P_PA_PP_KEY2, UNICONNECT.P_PA_PP_KEY3, UNICONNECT.P_PA_PP_KEY4, UNICONNECT.P_PA_PP_KEY5,
                                       UNICONNECT.P_PA_PP_VERSION,
                                       'description',       1, NULL);
         END IF;
      ELSE
         IF l_description_pos = 0 THEN
            --pg[x] or pg[x].pg used
            --passed pp_keys left blank since pgnode is mostly fixed at this point
            l_pg_rec_found := FindScPg(UNICONNECT.P_GLOB_SC, UNICONNECT.P_PA_PG, UNICONNECT.P_PA_PGDESCRIPTION,
                                       UNICONNECT.P_PA_PGNODE,
                                       UNICONNECT.P_PA_PP_KEY1, UNICONNECT.P_PA_PP_KEY2, UNICONNECT.P_PA_PP_KEY3, UNICONNECT.P_PA_PP_KEY4, UNICONNECT.P_PA_PP_KEY5,
                                       UNICONNECT.P_PA_PP_VERSION,
                                       'pg', l_pg_pos, NULL);
         ELSE
            --pg[x].description used
            --passed pp_keys left blank since pgnode is mostly fixed at this point
            l_pg_rec_found := FindScPg(UNICONNECT.P_GLOB_SC,  UNICONNECT.P_PA_PG, UNICONNECT.P_PA_PGDESCRIPTION,
                                       UNICONNECT.P_PA_PGNODE,
                                       UNICONNECT.P_PA_PP_KEY1, UNICONNECT.P_PA_PP_KEY2, UNICONNECT.P_PA_PP_KEY3, UNICONNECT.P_PA_PP_KEY4, UNICONNECT.P_PA_PP_KEY5,
                                       UNICONNECT.P_PA_PP_VERSION,
                                       'description', l_pg_pos, NULL);
         END IF;
      END IF;

      IF l_pg_rec_found.pgnode IS NOT NULL THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         pg found:pg='||l_pg_rec_found.pg||'#pgnode='||l_pg_rec_found.pgnode);
         UNICONNECT.P_GLOB_PG := l_pg_rec_found.pg;
         UNICONNECT.P_GLOB_PGNODE := l_pg_rec_found.pgnode;
      ELSE
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NORMAL,'         Section skipped : pg specified not found ! pg is optional in [pa] section !');
         l_ret_code := UNAPIGEN.DBERR_SUCCESS;
         RAISE StpError;
      END IF;

   ELSE
      UNICONNECT.P_GLOB_PG := UNICONNECT.P_PA_PG;
      UNICONNECT.P_GLOB_PGNODE := UNICONNECT.P_PA_PGNODE;
   END IF;

   FOR l_row IN 1..UNICONNECT.P_PA_NR_OF_ROWS LOOP
      UNICONNECT.P_PA_PG_TAB(l_row) := UNICONNECT.P_GLOB_PG;
      UNICONNECT.P_PA_PGNODE_TAB(l_row) := UNICONNECT.P_GLOB_PGNODE;
   END LOOP;

   --5. any pa specified ?
   --   YES   do nothing
   --   NO Major error : pa is mandatory in a [pa] section
   IF UNICONNECT.P_PA_NR_OF_ROWS = 0 THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : pa is mandatory for [pa] section !');
         l_ret_code := UNAPIGEN.DBERR_NOOBJID;
         RAISE StpError;
   END IF;

   --6. create_pa ?
   --   Y|INSERT|INSERT_WITH_NODES
   --      LOOP through all pa array
   --         pa[] notation will not be ignored
   --         panode will not be checked (Save api will return an error when not NULL)
   --         pa.description used ?
   --         YES   pa.description => find corresponding pa description in utpr and fill in corresponding pa
   --         NO use pa or pa.pa directly
   --         global variable PG is NULL and not already initialised to / in savescpa array?
   --         NO do nothing
   --         YES   pg / already exist for SC ?
   --            YES   set PG and PGNODE with record found in SaveScPaArray
   --            NO set PG=/ and PGNODE=0 in SaveScPaArray
   --            DON'T SET PG AND PGNODE global variables
   --         Set modify flag to MOD_FLAG_CREATE|MOD_FLAG_INSERT|MOD_FLAG_INSERT_WITH_NODES
   --         Section setting for panode is erased when MOD_FLAG_CREATE|MOD_FLAG_INSERT are used
   --      END LOOP
   --   N|W
   --      LOOP through all pa array
   --         pa[x] syntax used and/or description syntax used ?
   --            YES   find corresponding panode (find xth pa for this SC,PG,PGNODE and this pa order by panode ASC)
   --               pa[] => find the first pa which is not executed (ended)
   --               Pay attention : pa can already being used for saving another pa with the same name
   --            NO use the first pa with this name (ORDER BY panode)
   --         pa not found AND pgnode not specified in the section AND pg specified in the [pa] section ?
   --             NO continue
   --             YES no specific position specified for the pg (pg[x] or pg[] syntax not used)
   --                 search back to pa but without specifying a specific pgnode
   --                 pa found ?
   --                 NO continue
   --                 YES   set global variables PGNODE
   --                       Copy PGNODE in savescpa... array
   --
   --         pa found ?
   --            YES
   --               Result modified in section AND result already present AND allow_reanalysis = N ?
   --                  YES   Major error : no reanalysis authorised
   --                  NO    Continue
   --               set modify flag to UNAPIGEN.DBERR_SUCCESS
   --               set the node correctly for correct node numbering
   --               Initialise SaveScPa... array variables with the values coming
   --               from the record or from the section
   --                       (Values from the section will overrule the value from the record)
   --               Initialise the pg/pgnode from the record since these are not mandatory in the section
   --            NO
   --               create_pa ?
   --               N
   --                  Major error
   --               W
   --                  global variable PG is NULL and not already initialised to / in savescpa array?
   --                  NO do nothing
   --                  YES   pg / already exist for SC ?
   --                     YES   set PG and PGNODE with record found in SaveScPaArray
   --                     NO set PG=/ and PGNODE=0 in SaveScPaArray
   --                     DON'T SET PG AND PGNODE global variables
   --                  Set modify flag to UNAPIGEN.MOD_FLAG_CREATE
   --                  Set node to NULL
   --      END LOOP
   l_slashpg_searched := FALSE;
   l_slashpg_pgnode := NULL;
   IF UNICONNECT.P_SET_CREATE_PA IN ('Y', 'INSERT', 'INSERT_WITH_NODES') THEN
      FOR l_row IN 1..UNICONNECT.P_PA_NR_OF_ROWS LOOP

         --description used ? -> find pr in utpr
         l_variable_name := UNICONNECT.P_PA_PANAME_TAB(l_row);
         l_description_pos := INSTR(l_variable_name, '.description');
         IF l_description_pos > 0 THEN
            OPEN l_prdescription_cursor(UNICONNECT.P_PA_PADESCRIPTION_TAB(l_row),
                                        UNICONNECT.P_PA_PR_VERSION_TAB(l_row));
            FETCH l_prdescription_cursor
            INTO l_pr;
            IF l_prdescription_cursor%NOTFOUND THEN
               --Major error no corresponding pp found
               CLOSE l_prdescription_cursor;
               UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : no corresponding pr for description '||UNICONNECT.P_PA_PADESCRIPTION_TAB(l_row));
               l_ret_code := UNAPIGEN.DBERR_NOOBJID;
               RAISE StpError;
            END IF;
            CLOSE l_prdescription_cursor;
            UNICONNECT.P_PA_PA_TAB(l_row) := l_pr;
         END IF;

         -- global variable PG is NULL and not already initialised to / in savescpa array?
         -- NO do nothing
         -- YES   pg / already exist for SC ?
         --       YES   set PG and PGNODE with record found in SaveScPaArray
         --       NO    set PG=/ and PGNODE=0 in SaveScPaArray
         --             DON'T SET PG AND PGNODE global variables
         IF UNICONNECT.P_GLOB_PG IS NULL THEN
            IF UNICONNECT.P_PA_PG_TAB(l_row) IS NULL THEN
               IF l_slashpg_searched = FALSE THEN
                  OPEN l_slashpg_cursor(UNICONNECT.P_GLOB_SC);
                  FETCH l_slashpg_cursor
                  INTO l_slashpg_pgnode;
                  CLOSE l_slashpg_cursor;
                  l_slashpg_searched := TRUE;
               END IF;

               IF l_slashpg_pgnode IS NOT NULL THEN
                  UNICONNECT.P_PA_PG_TAB(l_row)     := '/';
                  UNICONNECT.P_PA_PGNODE_TAB(l_row) := l_slashpg_pgnode;
               ELSE
                  UNICONNECT.P_PA_PG_TAB(l_row)     := '/';
                  UNICONNECT.P_PA_PGNODE_TAB(l_row) := 0;
               END IF;
            END IF;
         END IF;

         --Set modify flag to MOD_FLAG_CREATE|MOD_FLAG_INSERT|MOD_FLAG_INSERT_WITH_NODES
         --Section setting for panode is erased when MOD_FLAG_CREATE|MOD_FLAG_INSERT are used
         UNICONNECT.P_PA_USE_SAVESCPARESULT := FALSE;

         IF UNICONNECT.P_SET_CREATE_PA = 'INSERT' THEN
            UNICONNECT.P_PA_MODIFY_FLAG_TAB(l_row) := UNAPIGEN.MOD_FLAG_INSERT;
            UNICONNECT.P_PA_PANODE_TAB(l_row) := NULL;
         ELSIF UNICONNECT.P_SET_CREATE_PA = 'INSERT_WITH_NODES' THEN
            UNICONNECT.P_PA_MODIFY_FLAG_TAB(l_row) := UNAPIGEN.MOD_FLAG_INSERT_WITH_NODES;
         ELSE
            UNICONNECT.P_PA_MODIFY_FLAG_TAB(l_row) := UNAPIGEN.MOD_FLAG_CREATE;
            UNICONNECT.P_PA_PANODE_TAB(l_row) := NULL;
         END IF;
      END LOOP;
   ELSE

      FOR l_row IN 1..UNICONNECT.P_PA_NR_OF_ROWS LOOP

         --description used ? -> find pr in utpr
         l_variable_name := UNICONNECT.P_PA_PANAME_TAB(l_row);
         l_description_pos := INSTR(l_variable_name, '.description');
         l_openbrackets_pos := INSTR(l_variable_name, '[');
         l_closebrackets_pos := INSTR(l_variable_name, ']');
         l_pa_pos := TO_NUMBER(SUBSTR(l_variable_name,l_openbrackets_pos+1,l_closebrackets_pos-l_openbrackets_pos-1));

         l_pa_rec_found := NULL;

         IF l_openbrackets_pos = 0 THEN
            IF l_description_pos = 0 THEN
               --pa or pa.pa used
               l_pa_rec_found := FindScPa(UNICONNECT.P_GLOB_SC,
                                          UNICONNECT.P_GLOB_PG, UNICONNECT.P_GLOB_PGNODE,
                                          UNICONNECT.P_PA_PP_KEY1, UNICONNECT.P_PA_PP_KEY2, UNICONNECT.P_PA_PP_KEY3, UNICONNECT.P_PA_PP_KEY4, UNICONNECT.P_PA_PP_KEY5,
                                          UNICONNECT.P_PA_PP_VERSION,
                                          UNICONNECT.P_PA_PA_TAB(l_row), UNICONNECT.P_PA_PADESCRIPTION_TAB(l_row),
                                          UNICONNECT.P_PA_PANODE_TAB(l_row), UNICONNECT.P_PA_PR_VERSION_TAB(l_row),
                                          'pa',        1, l_row);
            ELSE
               --pa.description used
               l_pa_rec_found := FindScPa(UNICONNECT.P_GLOB_SC,
                                          UNICONNECT.P_GLOB_PG, UNICONNECT.P_GLOB_PGNODE,
                                          UNICONNECT.P_PA_PP_KEY1, UNICONNECT.P_PA_PP_KEY2, UNICONNECT.P_PA_PP_KEY3, UNICONNECT.P_PA_PP_KEY4, UNICONNECT.P_PA_PP_KEY5,
                                          UNICONNECT.P_PA_PP_VERSION,
                                          UNICONNECT.P_PA_PA_TAB(l_row), UNICONNECT.P_PA_PADESCRIPTION_TAB(l_row),
                                          UNICONNECT.P_PA_PANODE_TAB(l_row), UNICONNECT.P_PA_PR_VERSION_TAB(l_row),
                                          'description',        1, l_row);
            END IF;
         ELSE
            IF l_description_pos = 0 THEN
               --pa[x] or pa[x].pa used
               l_pa_rec_found := FindScPa(UNICONNECT.P_GLOB_SC,
                                          UNICONNECT.P_GLOB_PG, UNICONNECT.P_GLOB_PGNODE,
                                          UNICONNECT.P_PA_PP_KEY1, UNICONNECT.P_PA_PP_KEY2, UNICONNECT.P_PA_PP_KEY3, UNICONNECT.P_PA_PP_KEY4, UNICONNECT.P_PA_PP_KEY5,
                                          UNICONNECT.P_PA_PP_VERSION,
                                          UNICONNECT.P_PA_PA_TAB(l_row), UNICONNECT.P_PA_PADESCRIPTION_TAB(l_row),
                                          UNICONNECT.P_PA_PANODE_TAB(l_row), UNICONNECT.P_PA_PR_VERSION_TAB(l_row),
                                          'pa', l_pa_pos, l_row);
            ELSE
               --pa[x].description used
               l_pa_rec_found := FindScPa(UNICONNECT.P_GLOB_SC,
                                          UNICONNECT.P_GLOB_PG, UNICONNECT.P_GLOB_PGNODE,
                                          UNICONNECT.P_PA_PP_KEY1, UNICONNECT.P_PA_PP_KEY2, UNICONNECT.P_PA_PP_KEY3, UNICONNECT.P_PA_PP_KEY4, UNICONNECT.P_PA_PP_KEY5,
                                          UNICONNECT.P_PA_PP_VERSION,
                                          UNICONNECT.P_PA_PA_TAB(l_row), UNICONNECT.P_PA_PADESCRIPTION_TAB(l_row),
                                          UNICONNECT.P_PA_PANODE_TAB(l_row), UNICONNECT.P_PA_PR_VERSION_TAB(l_row),
                                          'description', l_pa_pos, l_row);
            END IF;
         END IF;

         --pa not found AND pgnode not specified in the section AND pg specified in the [pa] section ?
         --NO continue
         --YES no specific position specified for the pg (pg[x] or pg[] syntax not used)
         --       search back to pa but without specifying a specific pgnode
         --       pa found ?
         --            NO continue
         --            YES   set global variable PGNODE
         --                  Copy PGNODE in savescpa... array

         IF l_pa_rec_found.panode IS NULL AND
            p_pa_pgnode_setinsection = FALSE AND
            UNICONNECT.P_PA_PGNAME IS NOT NULL AND
            INSTR(UNICONNECT.P_PA_PGNAME, '[') = 0 THEN
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         pa not found in current pg, will try to find it in another pg with the same name');
            IF l_openbrackets_pos = 0 THEN
               IF l_description_pos = 0 THEN
                  --pa or pa.pa used
                  l_pa_rec_found := FindScPa(UNICONNECT.P_GLOB_SC,
                                             UNICONNECT.P_GLOB_PG, NULL,
                                             UNICONNECT.P_PA_PP_KEY1, UNICONNECT.P_PA_PP_KEY2, UNICONNECT.P_PA_PP_KEY3, UNICONNECT.P_PA_PP_KEY4, UNICONNECT.P_PA_PP_KEY5,
                                             UNICONNECT.P_PA_PP_VERSION,
                                             UNICONNECT.P_PA_PA_TAB(l_row), UNICONNECT.P_PA_PADESCRIPTION_TAB(l_row),
                                             UNICONNECT.P_PA_PANODE_TAB(l_row), UNICONNECT.P_PA_PR_VERSION_TAB(l_row),
                                             'pa',        1, l_row);
               ELSE
                  --pa.description used
                  l_pa_rec_found := FindScPa(UNICONNECT.P_GLOB_SC,
                                             UNICONNECT.P_GLOB_PG, NULL,
                                             UNICONNECT.P_PA_PP_KEY1, UNICONNECT.P_PA_PP_KEY2, UNICONNECT.P_PA_PP_KEY3, UNICONNECT.P_PA_PP_KEY4, UNICONNECT.P_PA_PP_KEY5,
                                             UNICONNECT.P_PA_PP_VERSION,
                                             UNICONNECT.P_PA_PA_TAB(l_row), UNICONNECT.P_PA_PADESCRIPTION_TAB(l_row),
                                             UNICONNECT.P_PA_PANODE_TAB(l_row), UNICONNECT.P_PA_PR_VERSION_TAB(l_row),
                                             'description',        1, l_row);
               END IF;
            ELSE
               IF l_description_pos = 0 THEN
                  --pa[x] or pa[x].pa used
                  l_pa_rec_found := FindScPa(UNICONNECT.P_GLOB_SC,
                                             UNICONNECT.P_GLOB_PG, NULL,
                                             UNICONNECT.P_PA_PP_KEY1, UNICONNECT.P_PA_PP_KEY2, UNICONNECT.P_PA_PP_KEY3, UNICONNECT.P_PA_PP_KEY4, UNICONNECT.P_PA_PP_KEY5,
                                             UNICONNECT.P_PA_PP_VERSION,
                                             UNICONNECT.P_PA_PA_TAB(l_row), UNICONNECT.P_PA_PADESCRIPTION_TAB(l_row),
                                             UNICONNECT.P_PA_PANODE_TAB(l_row), UNICONNECT.P_PA_PR_VERSION_TAB(l_row),
                                             'pa', l_pa_pos, l_row);
               ELSE
                  --pa[x].description used
                  l_pa_rec_found := FindScPa(UNICONNECT.P_GLOB_SC,
                                             UNICONNECT.P_GLOB_PG, NULL,
                                             UNICONNECT.P_PA_PP_KEY1, UNICONNECT.P_PA_PP_KEY2, UNICONNECT.P_PA_PP_KEY3, UNICONNECT.P_PA_PP_KEY4, UNICONNECT.P_PA_PP_KEY5,
                                             UNICONNECT.P_PA_PP_VERSION,
                                             UNICONNECT.P_PA_PA_TAB(l_row), UNICONNECT.P_PA_PADESCRIPTION_TAB(l_row),
                                             UNICONNECT.P_PA_PANODE_TAB(l_row), UNICONNECT.P_PA_PR_VERSION_TAB(l_row),
                                             'description', l_pa_pos, l_row);
               END IF;
            END IF;

            IF l_pa_rec_found.panode IS NOT NULL THEN
               UNICONNECT.P_GLOB_PGNODE := l_pa_rec_found.pgnode;
               FOR l_row IN 1..UNICONNECT.P_PA_NR_OF_ROWS LOOP
                   UNICONNECT.P_PA_PGNODE_TAB(l_row) := UNICONNECT.P_GLOB_PGNODE;
               END LOOP;
            END IF;
         END IF;

         IF l_pa_rec_found.panode IS NOT NULL THEN
            --pa found
            --Result modified in section AND result already present AND allow_reanalysis = N ?
            --   YES   Major error : no reanalysis authorised
            --   NO    Call ReanalScParameter
            IF (UNICONNECT.P_PA_VALUE_F_MODTAB(l_row) OR UNICONNECT.P_PA_VALUE_S_MODTAB(l_row)) AND
               l_pa_rec_found.exec_end_date IS NOT NULL THEN
               IF UNICONNECT.P_SET_ALLOW_REANALYSIS = 'N' THEN
                  UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : pa already executed, new pa result in [pa] section AND no reanalysis authorised !');
                  l_ret_code := UNAPIGEN.DBERR_GENFAIL;
                  RAISE StpError;
               ELSE
                  UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NORMAL,'         pa already executed and new pa result in [pa] section => pa reanalysis');
                  l_ret_code := UNAPIPA2.ReanalScParameter(l_pa_rec_found.sc,
                                                           l_pa_rec_found.pg,
                                                           l_pa_rec_found.pgnode,
                                                           l_pa_rec_found.pa,
                                                           l_pa_rec_found.panode,
                                                           l_reanalysis,
                                                           'Uniconnect : new result for this parameter');
                  IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
                     UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : ReanalScParameter failed ret_code : '||l_ret_code ||
                                                    '#sc='||l_pa_rec_found.sc||
                                                    '#pg='||l_pa_rec_found.pg||
                                                    '#pgnode='||l_pa_rec_found.pgnode||
                                                    '#pa='||l_pa_rec_found.pa||
                                                    '#panode='||l_pa_rec_found.panode);
                     RAISE StpError;
                  END IF;
               END IF;
            END IF;
            --initialise SaveScPa.... array with fetched values when not set in section

            --always set
            --Initialise the pg/pgnode also from the record since these are not mandatory in the section
            UNICONNECT.P_PA_PG_TAB(l_row)               := l_pa_rec_found.pg;
            UNICONNECT.P_PA_PGNODE_TAB(l_row)           := l_pa_rec_found.pgnode;
            UNICONNECT.P_PA_PANODE_TAB(l_row)           := l_pa_rec_found.panode;
            UNICONNECT.P_PA_PR_VERSION_TAB(l_row)       := l_pa_rec_found.pr_version;
            UNICONNECT.P_PA_PLANNED_EXECUTOR_TAB(l_row) := l_pa_rec_found.planned_executor;
            UNICONNECT.P_PA_ASSIGN_DATE_TAB(l_row)      := l_pa_rec_found.assign_date;
            UNICONNECT.P_PA_ASSIGNED_BY_TAB(l_row)      := l_pa_rec_found.assigned_by;
            UNICONNECT.P_PA_MANUALLY_ADDED_TAB(l_row)   := l_pa_rec_found.manually_added;
            UNICONNECT.P_PA_FORMAT_TAB(l_row)           := l_pa_rec_found.format;
            UNICONNECT.P_PA_TD_INFO_TAB(l_row)          := l_pa_rec_found.td_info;
            UNICONNECT.P_PA_TD_INFO_UNIT_TAB(l_row)     := l_pa_rec_found.td_info_unit;
            UNICONNECT.P_PA_CONFIRM_UID_TAB(l_row)      := l_pa_rec_found.confirm_uid;
            UNICONNECT.P_PA_ALLOW_ANY_ME_TAB(l_row)     := l_pa_rec_found.allow_any_me;
            UNICONNECT.P_PA_DELAY_TAB(l_row)            := l_pa_rec_found.delay;
            UNICONNECT.P_PA_DELAY_UNIT_TAB(l_row)       := l_pa_rec_found.delay_unit;
            UNICONNECT.P_PA_MIN_NR_RESULTS_TAB(l_row)   := l_pa_rec_found.min_nr_results;
            UNICONNECT.P_PA_CALC_METHOD_TAB(l_row)      := l_pa_rec_found.calc_method;
            UNICONNECT.P_PA_CALC_CF_TAB(l_row)          := l_pa_rec_found.calc_cf;
            UNICONNECT.P_PA_ALARM_ORDER_TAB(l_row)      := l_pa_rec_found.alarm_order;
            UNICONNECT.P_PA_VALID_SPECSA_TAB(l_row)     := l_pa_rec_found.valid_specsa;
            UNICONNECT.P_PA_VALID_SPECSB_TAB(l_row)     := l_pa_rec_found.valid_specsb;
            UNICONNECT.P_PA_VALID_SPECSC_TAB(l_row)     := l_pa_rec_found.valid_specsc;
            UNICONNECT.P_PA_VALID_LIMITSA_TAB(l_row)    := l_pa_rec_found.valid_limitsa;
            UNICONNECT.P_PA_VALID_LIMITSB_TAB(l_row)    := l_pa_rec_found.valid_limitsb;
            UNICONNECT.P_PA_VALID_LIMITSC_TAB(l_row)    := l_pa_rec_found.valid_limitsc;
            UNICONNECT.P_PA_VALID_TARGETA_TAB(l_row)    := l_pa_rec_found.valid_targeta;
            UNICONNECT.P_PA_VALID_TARGETB_TAB(l_row)    := l_pa_rec_found.valid_targetb;
            UNICONNECT.P_PA_VALID_TARGETC_TAB(l_row)    := l_pa_rec_found.valid_targetc;
            UNICONNECT.P_PA_MT_TAB(l_row)               := NULL;
            UNICONNECT.P_PA_MT_VERSION_TAB(l_row)       := NULL;
            UNICONNECT.P_PA_MT_NR_MEASUR_TAB(l_row)     := NULL;
            UNICONNECT.P_PA_LOG_EXCEPTIONS_TAB(l_row)   := l_pa_rec_found.log_exceptions;
            UNICONNECT.P_PA_PA_CLASS_TAB(l_row)         := l_pa_rec_found.pa_class;
            UNICONNECT.P_PA_LOG_HS_TAB(l_row)           := l_pa_rec_found.log_hs;
            UNICONNECT.P_PA_LOG_HS_DETAILS_TAB(l_row)   := l_pa_rec_found.log_hs_details;
            UNICONNECT.P_PA_LC_TAB(l_row)               := l_pa_rec_found.lc;
            UNICONNECT.P_PA_LC_VERSION_TAB(l_row)       := l_pa_rec_found.lc_version;

            --only when not set in section
            UNICONNECT.P_PA_DESCRIPTION_TAB(l_row)      := PaUseValue('description'       , l_row, l_pa_rec_found.description);
            UNICONNECT.P_PA_UNIT_TAB(l_row)             := PaUseValue('unit'              , l_row, l_pa_rec_found.unit);
            UNICONNECT.P_PA_MANUALLY_ENTERED_TAB(l_row) := PaUseValue('manually_entered'  , l_row, l_pa_rec_found.manually_entered);
            UNICONNECT.P_PA_EXEC_START_DATE_TAB(l_row)  := PaUseValue('exec_start_date'   , l_row, l_pa_rec_found.exec_start_date);
            UNICONNECT.P_PA_EXEC_END_DATE_TAB(l_row)    := PaUseValue('exec_end_date'     , l_row, l_pa_rec_found.exec_end_date);
            UNICONNECT.P_PA_EXECUTOR_TAB(l_row)         := PaUseValue('executor'          , l_row, l_pa_rec_found.executor);

            --Special rule for value_f and value_s :
            --Rule : when only value_f specified => value_s from record nomore used
            --          when only value_s specified => value_f from record nomore used
            --          when value_s AND value_f specified => all values from record ignored
            l_ret_code := UNICONNECT6.SpecialRulesForValues(UNICONNECT.P_PA_VALUE_S_MODTAB(l_row),
                                                            UNICONNECT.P_PA_VALUE_S_TAB(l_row),
                                                            UNICONNECT.P_PA_VALUE_F_MODTAB(l_row),
                                                            UNICONNECT.P_PA_VALUE_F_TAB(l_row),
                                                            l_pa_rec_found.format,
                                                            l_pa_rec_found.value_s,
                                                            l_pa_rec_found.value_f);
            IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
               UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         ret_code='||TO_CHAR(l_ret_code)||
                                                     ' returned by UNICONNECT6.SpecialRulesForValues#value_s='||
                                                     UNICONNECT.P_PA_VALUE_S_TAB(l_row)||'#value_f='||
                                                     TO_CHAR(UNICONNECT.P_PA_VALUE_F_TAB(l_row))||
                                                     '#format='||l_pa_rec_found.format);
               RAISE StpError;
            END IF;

            UNICONNECT.P_PA_VALUE_F_TAB(l_row)          := PaUseValue('value_f'           , l_row, l_pa_rec_found.value_f);
            UNICONNECT.P_PA_VALUE_S_TAB(l_row)          := PaUseValue('value_s'           , l_row, l_pa_rec_found.value_s);

         ELSE
            /* create_pa=N ? */
            IF UNICONNECT.P_SET_CREATE_PA = 'N' THEN

               UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NORMAL,'         Warning : section skipped : pa does not exist and can not be created');
               l_ret_code := UNAPIGEN.DBERR_SUCCESS;
               RAISE StpError;

            ELSE
               --find the pr corresponding to the provided description
               --in utpr when description used to specify the pa
               IF l_description_pos > 0 THEN
                  OPEN l_prdescription_cursor(UNICONNECT.P_PA_PADESCRIPTION_TAB(l_row),
                                              UNICONNECT.P_PA_PR_VERSION_TAB(l_row));
                  FETCH l_prdescription_cursor
                  INTO l_pr;
                  IF l_prdescription_cursor%NOTFOUND THEN
                     --Major error no corresponding pr found
                     CLOSE l_prdescription_cursor;
                     UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : no corresponding pr for description '||UNICONNECT.P_PA_PADESCRIPTION_TAB(l_row));
                     l_ret_code := UNAPIGEN.DBERR_NOOBJID;
                     RAISE StpError;
                  END IF;
                  CLOSE l_prdescription_cursor;
                  UNICONNECT.P_PA_PA_TAB(l_row) := l_pr;
               END IF;

               --Use / pg when not specified in section
               IF UNICONNECT.P_GLOB_PG IS NULL THEN
                  IF UNICONNECT.P_PA_PG_TAB(l_row) IS NULL THEN
                     IF l_slashpg_searched = FALSE THEN
                        OPEN l_slashpg_cursor(UNICONNECT.P_GLOB_SC);
                        FETCH l_slashpg_cursor
                        INTO l_slashpg_pgnode;
                        CLOSE l_slashpg_cursor;
                        l_slashpg_searched := TRUE;
                     END IF;

                     IF l_slashpg_pgnode IS NOT NULL THEN
                        UNICONNECT.P_PA_PG_TAB(l_row)     := '/';
                        UNICONNECT.P_PA_PGNODE_TAB(l_row) := l_slashpg_pgnode;
                     ELSE
                        UNICONNECT.P_PA_PG_TAB(l_row)     := '/';
                        UNICONNECT.P_PA_PGNODE_TAB(l_row) := 0;
                     END IF;
                  END IF;
               END IF;

               --Set Modify flag to MOD_FLAG_CREATE
               UNICONNECT.P_PA_MODIFY_FLAG_TAB(l_row) := UNAPIGEN.MOD_FLAG_CREATE;
               UNICONNECT.P_PA_PANODE_TAB(l_row) := NULL;
               UNICONNECT.P_PA_USE_SAVESCPARESULT := FALSE;


            END IF;

         END IF;

      END LOOP;

   END IF;

   --7.Any pa to create ?
   --   YES
   --   LOOP through all pa array
   --      Call InitScParameter for all pa which have to be created
   --      Initialise SaveScParameter array variables with the values coming
   --      from the InitScParameter or from the section
   --              (Values from the section will overrule the value from the InitScParameter)
   --   END LOOP
   --   Call SaveScParameter or SaveScPaResult (OPTIMALISATION)
   l_any_save := FALSE;
   FOR l_row IN 1..UNICONNECT.P_PA_NR_OF_ROWS LOOP

      IF UNICONNECT.P_PA_MODIFY_FLAG_TAB(l_row) IN (UNAPIGEN.MOD_FLAG_CREATE,
                                                 UNAPIGEN.MOD_FLAG_INSERT,
                                                 UNAPIGEN.MOD_FLAG_INSERT_WITH_NODES)
                                                 THEN

         l_any_save := TRUE;
         l_initpa_pr := UNICONNECT.P_PA_PA_TAB(l_row);
         l_initpa_pr_version_in := UNICONNECT.P_PA_PR_VERSION_TAB(l_row);
         l_initpa_seq := NULL;
         l_initpa_sc := UNICONNECT.P_PA_SC_TAB(l_row);
         l_initpa_pg := UNICONNECT.P_PA_PG_TAB(l_row);
         l_initpa_pgnode := UNICONNECT.P_PA_PGNODE_TAB(l_row);
         l_initpa_pp_version := NULL;
         l_initpa_nr_of_rows := NULL;

         --pp_key[1-5] left empty since pgnode is known
         l_ret_code := UNAPIPA.INITSCPARAMETER
                         (l_initpa_pr,
                          l_initpa_pr_version_in,
                          l_initpa_seq,
                          l_initpa_sc,
                          l_initpa_pg,
                          l_initpa_pgnode,
                          l_initpa_pp_version,
                          ' ', ' ', ' ', ' ', ' ',
                          l_initpa_pr_version_tab,
                          l_initpa_description_tab,
                          l_initpa_value_f_tab,
                          l_initpa_value_s_tab,
                          l_initpa_unit_tab,
                          l_initpa_exec_start_date_tab,
                          l_initpa_exec_end_date_tab,
                          l_initpa_executor_tab,
                          l_initpa_planned_executor_tab,
                          l_initpa_manually_entered_tab,
                          l_initpa_assign_date_tab,
                          l_initpa_assigned_by_tab,
                          l_initpa_manually_added_tab,
                          l_initpa_format_tab,
                          l_initpa_td_info_tab,
                          l_initpa_td_info_unit_tab,
                          l_initpa_confirm_uid_tab,
                          l_initpa_allow_any_me_tab,
                          l_initpa_delay_tab,
                          l_initpa_delay_unit_tab,
                          l_initpa_min_nr_results_tab,
                          l_initpa_calc_method_tab,
                          l_initpa_calc_cf_tab,
                          l_initpa_alarm_order_tab,
                          l_initpa_valid_specsa_tab,
                          l_initpa_valid_specsb_tab,
                          l_initpa_valid_specsc_tab,
                          l_initpa_valid_limitsa_tab,
                          l_initpa_valid_limitsb_tab,
                          l_initpa_valid_limitsc_tab,
                          l_initpa_valid_targeta_tab,
                          l_initpa_valid_targetb_tab,
                          l_initpa_valid_targetc_tab,
                          l_initpa_mt_tab,
                          l_initpa_mt_version_tab,
                          l_initpa_mt_nr_measur_tab,
                          l_initpa_log_exceptions_tab,
                          l_initpa_reanalysis_tab,
                          l_initpa_pa_class_tab,
                          l_initpa_log_hs_tab,
                          l_initpa_log_hs_details_tab,
                          l_initpa_lc_tab,
                          l_initpa_lc_version_tab,
                          l_initpa_nr_of_rows);

         IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
               UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : InitScParameter ret_code : '||l_ret_code ||
                                            '#pr='||l_initpa_pr||'#pr_version_in='||l_initpa_pr_version_in);
               RAISE StpError;
         ELSE

            --always use initscparameter values
            UNICONNECT.P_PA_PR_VERSION_TAB(l_row)       := l_initpa_pr_version_tab(1);
            UNICONNECT.P_PA_PLANNED_EXECUTOR_TAB(l_row) := l_initpa_planned_executor_tab(1);
            UNICONNECT.P_PA_ASSIGN_DATE_TAB(l_row)      := l_initpa_assign_date_tab(1);
            UNICONNECT.P_PA_ASSIGNED_BY_TAB(l_row)      := l_initpa_assigned_by_tab(1);
            UNICONNECT.P_PA_MANUALLY_ADDED_TAB(l_row)   := l_initpa_manually_added_tab(1);
            UNICONNECT.P_PA_FORMAT_TAB(l_row)           := l_initpa_format_tab(1);
            UNICONNECT.P_PA_TD_INFO_TAB(l_row)          := l_initpa_td_info_tab(1);
            UNICONNECT.P_PA_TD_INFO_UNIT_TAB(l_row)     := l_initpa_td_info_unit_tab(1);
            UNICONNECT.P_PA_CONFIRM_UID_TAB(l_row)      := l_initpa_confirm_uid_tab(1);
            UNICONNECT.P_PA_ALLOW_ANY_ME_TAB(l_row)     := l_initpa_allow_any_me_tab(1);
            UNICONNECT.P_PA_DELAY_TAB(l_row)            := l_initpa_delay_tab(1);
            UNICONNECT.P_PA_DELAY_UNIT_TAB(l_row)       := l_initpa_delay_unit_tab(1);
            UNICONNECT.P_PA_MIN_NR_RESULTS_TAB(l_row)   := l_initpa_min_nr_results_tab(1);
            UNICONNECT.P_PA_CALC_METHOD_TAB(l_row)      := l_initpa_calc_method_tab(1);
            UNICONNECT.P_PA_CALC_CF_TAB(l_row)          := l_initpa_calc_cf_tab(1);
            UNICONNECT.P_PA_ALARM_ORDER_TAB(l_row)      := l_initpa_alarm_order_tab(1);
            UNICONNECT.P_PA_VALID_SPECSA_TAB(l_row)     := l_initpa_valid_specsa_tab(1);
            UNICONNECT.P_PA_VALID_SPECSB_TAB(l_row)     := l_initpa_valid_specsb_tab(1);
            UNICONNECT.P_PA_VALID_SPECSC_TAB(l_row)     := l_initpa_valid_specsc_tab(1);
            UNICONNECT.P_PA_VALID_LIMITSA_TAB(l_row)    := l_initpa_valid_limitsa_tab(1);
            UNICONNECT.P_PA_VALID_LIMITSB_TAB(l_row)    := l_initpa_valid_limitsb_tab(1);
            UNICONNECT.P_PA_VALID_LIMITSC_TAB(l_row)    := l_initpa_valid_limitsc_tab(1);
            UNICONNECT.P_PA_VALID_TARGETA_TAB(l_row)    := l_initpa_valid_targeta_tab(1);
            UNICONNECT.P_PA_VALID_TARGETB_TAB(l_row)    := l_initpa_valid_targetb_tab(1);
            UNICONNECT.P_PA_VALID_TARGETC_TAB(l_row)    := l_initpa_valid_targetc_tab(1);
            UNICONNECT.P_PA_MT_TAB(l_row)               := l_initpa_mt_tab(1);
            UNICONNECT.P_PA_MT_VERSION_TAB(l_row)       := l_initpa_mt_version_tab(1);
            UNICONNECT.P_PA_MT_NR_MEASUR_TAB(l_row)     := l_initpa_mt_nr_measur_tab(1);
            UNICONNECT.P_PA_LOG_EXCEPTIONS_TAB(l_row)   := l_initpa_log_exceptions_tab(1);
            UNICONNECT.P_PA_PA_CLASS_TAB(l_row)         := l_initpa_pa_class_tab(1);
            UNICONNECT.P_PA_LOG_HS_TAB(l_row)           := l_initpa_log_hs_tab(1);
            UNICONNECT.P_PA_LOG_HS_DETAILS_TAB(l_row)   := l_initpa_log_hs_details_tab(1);
            UNICONNECT.P_PA_LC_TAB(l_row)               := l_initpa_lc_tab(1);
            UNICONNECT.P_PA_LC_VERSION_TAB(l_row)       := l_initpa_lc_version_tab(1);

            --only when not set in section
            UNICONNECT.P_PA_DESCRIPTION_TAB(l_row)      := PaUseValue('description'       , l_row, l_initpa_description_tab(1));
            UNICONNECT.P_PA_UNIT_TAB(l_row)             := PaUseValue('unit'              , l_row, l_initpa_unit_tab(1));
            UNICONNECT.P_PA_MANUALLY_ENTERED_TAB(l_row) := PaUseValue('manually_entered'  , l_row, l_initpa_manually_entered_tab(1));
            UNICONNECT.P_PA_EXEC_START_DATE_TAB(l_row)  := PaUseValue('exec_start_date'   , l_row, l_initpa_exec_start_date_tab(1));
            UNICONNECT.P_PA_EXEC_END_DATE_TAB(l_row)    := PaUseValue('exec_end_date'     , l_row, l_initpa_exec_end_date_tab(1));
            UNICONNECT.P_PA_EXECUTOR_TAB(l_row)         := PaUseValue('executor'          , l_row, l_initpa_executor_tab(1));

            --Special rule for value_f and value_s :
            --Rule : when only value_f specified => value_s from record nomore used
            --          when only value_s specified => value_f from record nomore used
            --          when value_s AND value_f specified => all values from record ignored
            l_ret_code := UNICONNECT6.SpecialRulesForValues(UNICONNECT.P_PA_VALUE_S_MODTAB(l_row),
                                                            UNICONNECT.P_PA_VALUE_S_TAB(l_row),
                                                            UNICONNECT.P_PA_VALUE_F_MODTAB(l_row),
                                                            UNICONNECT.P_PA_VALUE_F_TAB(l_row),
                                                            l_initpa_format_tab(1),
                                                            l_initpa_value_s_tab(1),
                                                            l_initpa_value_f_tab(1));
            IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
               UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         ret_code='||TO_CHAR(l_ret_code)||
                                                     ' returned by UNICONNECT6.SpecialRulesForValues#value_s='||
                                                     UNICONNECT.P_PA_VALUE_S_TAB(l_row)||'#value_f='||
                                                     TO_CHAR(UNICONNECT.P_PA_VALUE_F_TAB(l_row))||
                                                     '#format='||l_initpa_format_tab(1));
               RAISE StpError;
            END IF;
            UNICONNECT.P_PA_VALUE_F_TAB(l_row)          := PaUseValue('value_f'           , l_row, l_initpa_value_f_tab(1));
            UNICONNECT.P_PA_VALUE_S_TAB(l_row)          := PaUseValue('value_s'           , l_row, l_initpa_value_s_tab(1));
         END IF;

      ELSIF UNICONNECT.P_PA_MODIFY_FLAG_TAB(l_row) IN (UNAPIGEN.MOD_FLAG_UPDATE,
                                                    UNAPIGEN.MOD_FLAG_DELETE) THEN

         l_any_save := TRUE;

      END IF;
   END LOOP;

   IF l_any_save THEN
      IF UNICONNECT.P_PA_USE_SAVESCPARESULT THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Calling SaveScPaResult for :');
         l_used_api := 'SaveScPaResult';
      ELSE
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Calling SaveScParameter for :');
         l_used_api := 'SaveScParameter';
      END IF;

      FOR l_row IN 1..UNICONNECT.P_PA_NR_OF_ROWS LOOP
          UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'            row='||l_row||
                                         '#mod_flag='||UNICONNECT.P_PA_MODIFY_FLAG_TAB(l_row) ||
                                         '#sc='||UNICONNECT.P_PA_SC_TAB(l_row)||'#pg='||UNICONNECT.P_PA_PG_TAB(l_row)||
                                         '#pgnode='||NVL(TO_CHAR(UNICONNECT.P_PA_PGNODE_TAB(l_row)),'NULL')||
                                         '#pa='||UNICONNECT.P_PA_PA_TAB(l_row)||
                                         '#panode='||NVL(TO_CHAR(UNICONNECT.P_PA_PANODE_TAB(l_row)),'NULL'));
      END LOOP;

      UNICONNECT.P_PA_ALARMS_HANDLED := UNAPIGEN.ALARMS_NOT_HANDLED;


      IF UNICONNECT.P_PA_USE_SAVESCPARESULT THEN
         --SaveScPaResult will also trigger the reanalysis when exec_end_date is filled in

         l_ret_code := UNAPIPA.SAVESCPARESULT
                         (UNICONNECT.P_PA_ALARMS_HANDLED,
                          UNICONNECT.P_PA_SC_TAB,
                          UNICONNECT.P_PA_PG_TAB,
                          UNICONNECT.P_PA_PGNODE_TAB,
                          UNICONNECT.P_PA_PA_TAB,
                          UNICONNECT.P_PA_PANODE_TAB,
                          UNICONNECT.P_PA_VALUE_F_TAB,
                          UNICONNECT.P_PA_VALUE_S_TAB,
                          UNICONNECT.P_PA_UNIT_TAB,
                          UNICONNECT.P_PA_FORMAT_TAB,
                          UNICONNECT.P_PA_EXEC_END_DATE_TAB,
                          UNICONNECT.P_PA_EXECUTOR_TAB,
                          UNICONNECT.P_PA_MANUALLY_ENTERED_TAB,
                          UNICONNECT.P_PA_REANALYSIS_TAB,
                          UNICONNECT.P_PA_MODIFY_FLAG_TAB,
                          UNICONNECT.P_PA_NR_OF_ROWS,
                          UNICONNECT.P_PA_MODIFY_REASON);

      ELSE
         l_ret_code := UNAPIPA.SAVESCPARAMETER
                         (UNICONNECT.P_PA_ALARMS_HANDLED,
                          UNICONNECT.P_PA_SC_TAB,
                          UNICONNECT.P_PA_PG_TAB,
                          UNICONNECT.P_PA_PGNODE_TAB,
                          UNICONNECT.P_PA_PA_TAB,
                          UNICONNECT.P_PA_PANODE_TAB,
                          UNICONNECT.P_PA_PR_VERSION_TAB,
                          UNICONNECT.P_PA_DESCRIPTION_TAB,
                          UNICONNECT.P_PA_VALUE_F_TAB,
                          UNICONNECT.P_PA_VALUE_S_TAB,
                          UNICONNECT.P_PA_UNIT_TAB,
                          UNICONNECT.P_PA_EXEC_START_DATE_TAB,
                          UNICONNECT.P_PA_EXEC_END_DATE_TAB,
                          UNICONNECT.P_PA_EXECUTOR_TAB,
                          UNICONNECT.P_PA_PLANNED_EXECUTOR_TAB,
                          UNICONNECT.P_PA_MANUALLY_ENTERED_TAB,
                          UNICONNECT.P_PA_ASSIGN_DATE_TAB,
                          UNICONNECT.P_PA_ASSIGNED_BY_TAB,
                          UNICONNECT.P_PA_MANUALLY_ADDED_TAB,
                          UNICONNECT.P_PA_FORMAT_TAB,
                          UNICONNECT.P_PA_TD_INFO_TAB,
                          UNICONNECT.P_PA_TD_INFO_UNIT_TAB,
                          UNICONNECT.P_PA_CONFIRM_UID_TAB,
                          UNICONNECT.P_PA_ALLOW_ANY_ME_TAB,
                          UNICONNECT.P_PA_DELAY_TAB,
                          UNICONNECT.P_PA_DELAY_UNIT_TAB,
                          UNICONNECT.P_PA_MIN_NR_RESULTS_TAB,
                          UNICONNECT.P_PA_CALC_METHOD_TAB,
                          UNICONNECT.P_PA_CALC_CF_TAB,
                          UNICONNECT.P_PA_ALARM_ORDER_TAB,
                          UNICONNECT.P_PA_VALID_SPECSA_TAB,
                          UNICONNECT.P_PA_VALID_SPECSB_TAB,
                          UNICONNECT.P_PA_VALID_SPECSC_TAB,
                          UNICONNECT.P_PA_VALID_LIMITSA_TAB,
                          UNICONNECT.P_PA_VALID_LIMITSB_TAB,
                          UNICONNECT.P_PA_VALID_LIMITSC_TAB,
                          UNICONNECT.P_PA_VALID_TARGETA_TAB,
                          UNICONNECT.P_PA_VALID_TARGETB_TAB,
                          UNICONNECT.P_PA_VALID_TARGETC_TAB,
                          UNICONNECT.P_PA_MT_TAB,
                          UNICONNECT.P_PA_MT_VERSION_TAB,
                          UNICONNECT.P_PA_MT_NR_MEASUR_TAB,
                          UNICONNECT.P_PA_LOG_EXCEPTIONS_TAB,
                          UNICONNECT.P_PA_PA_CLASS_TAB,
                          UNICONNECT.P_PA_LOG_HS_TAB,
                          UNICONNECT.P_PA_LOG_HS_DETAILS_TAB,
                          UNICONNECT.P_PA_LC_TAB,
                          UNICONNECT.P_PA_LC_VERSION_TAB,
                          UNICONNECT.P_PA_MODIFY_FLAG_TAB,
                          UNICONNECT.P_PA_NR_OF_ROWS,
                          UNICONNECT.P_PA_MODIFY_REASON);

      END IF;


      IF l_ret_code NOT IN (UNAPIGEN.DBERR_SUCCESS,
                            UNAPIGEN.DBERR_PARTIALSAVE, UNAPIGEN.DBERR_PARTIALCHARTSAVE) THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : ' || l_used_api || ' ret_code='||l_ret_code ||
                                        '#sc(1)='||UNICONNECT.P_PA_SC_TAB(1)||'#pg(1)='||UNICONNECT.P_PA_PG_TAB(1)||
                                        '#pgnode(1)='||NVL(TO_CHAR(UNICONNECT.P_PA_PGNODE_TAB(1)),'NULL')||
                                        '#pa(1)='||UNICONNECT.P_PA_PA_TAB(1)||
                                        '#panode(1)='||NVL(TO_CHAR(UNICONNECT.P_PA_PANODE_TAB(1)),'NULL')||
                                        '#mod_flag(1)='||UNICONNECT.P_PA_MODIFY_FLAG_TAB(1));
         RAISE StpError;
      ELSIF l_ret_code = UNAPIGEN.DBERR_PARTIALSAVE THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_HIGH,'         Warning : ' || l_used_api || ' partial save ! ');
         IF UNAPIAUT.P_NOT_AUTHORISED IS NOT NULL THEN
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_HIGH,'            authorisation problem : ' || UNAPIAUT.P_NOT_AUTHORISED );
         END IF;
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_HIGH,'         nr_of_rows : ' || UNICONNECT.P_PA_NR_OF_ROWS );
         IF UNICONNECT.P_PA_NR_OF_ROWS > 0 THEN
            FOR l_row IN 1..UNICONNECT.P_PA_NR_OF_ROWS LOOP
               IF UNICONNECT.P_PA_MODIFY_FLAG_TAB(l_row) > UNAPIGEN.DBERR_SUCCESS THEN
                  UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_HIGH,'         ' || l_used_api || ' authorisation problem row='||l_row||
                                                 '#mod_flag='||UNICONNECT.P_PA_MODIFY_FLAG_TAB(l_row) ||
                                                 '#sc='||UNICONNECT.P_PA_SC_TAB(l_row)||'#pg='||UNICONNECT.P_PA_PG_TAB(l_row)||
                                                 '#pgnode='||NVL(TO_CHAR(UNICONNECT.P_PA_PGNODE_TAB(l_row)),'NULL')||
                                                 '#pa='||UNICONNECT.P_PA_PA_TAB(l_row)||
                                                 '#panode='||NVL(TO_CHAR(UNICONNECT.P_PA_PANODE_TAB(l_row)),'NULL'));
               END IF;
            END LOOP;
         END IF;
         IF UNAPIAUT.P_NOT_AUTHORISED IS NOT NULL THEN
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         ' || UNAPIAUT.P_NOT_AUTHORISED );
         END IF;
         --Don't ROLLBACK the transaction on PARTIALSAVE
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_SUCCESS;
      ELSIF l_ret_code = UNAPIGEN.DBERR_PARTIALCHARTSAVE THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_HIGH,'         Warning : ' || l_used_api || ' partial chart save ! ');
         IF UNAPIAUT.P_NOT_AUTHORISED IS NOT NULL THEN
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_HIGH,'            authorisation problem : ' || UNAPIAUT.P_NOT_AUTHORISED );
         END IF;
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_HIGH,'         nr_of_rows : ' || UNICONNECT.P_PA_NR_OF_ROWS );
         IF UNAPIAUT.P_NOT_AUTHORISED IS NOT NULL THEN
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         ' || UNAPIAUT.P_NOT_AUTHORISED );
         END IF;
         --Don't ROLLBACK the transaction on PARTIALCHARTSAVE
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_SUCCESS;
      END IF;
   ELSE
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NORMAL,'         No save(s) in [pa] section');
   END IF;

   -- Perform a ChangeStatus or a Cancel when required
   FOR l_row IN 1..UNICONNECT.P_PA_NR_OF_ROWS LOOP
      IF UNICONNECT.P_PA_SS_MODTAB(l_row) THEN
         l_ret_code := ChangeScPaStatusOrCancel(UNICONNECT.P_PA_SC_TAB(l_row),
                                                UNICONNECT.P_PA_PG_TAB(l_row),
                                                UNICONNECT.P_PA_PGNODE_TAB(l_row),
                                                UNICONNECT.P_PA_PA_TAB(l_row),
                                                UNICONNECT.P_PA_PANODE_TAB(l_row),
                                                UNICONNECT.P_PA_SS_TAB(l_row),
                                                UNICONNECT.P_PA_MODIFY_REASON);
         IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : ChangeScPaStatusOrCancel ret_code='||l_ret_code ||
                                      '#sc='||UNICONNECT.P_PA_SC_TAB(l_row)||
                                      '#pg='||UNICONNECT.P_PA_PG_TAB(l_row)||
                                      '#pgnode='||NVL(TO_CHAR(UNICONNECT.P_PA_PGNODE_TAB(l_row)),'NULL')||
                                      '#pa='||UNICONNECT.P_PA_PA_TAB(l_row)||
                                      '#panode='||NVL(TO_CHAR(UNICONNECT.P_PA_PANODE_TAB(l_row)),'NULL')
                                      );
            IF UNAPIAUT.P_NOT_AUTHORISED IS NOT NULL THEN
               UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         ' || UNAPIAUT.P_NOT_AUTHORISED );
            END IF;
            RAISE StpError;
         END IF;
      END IF;
   END LOOP;

   -- Perform a AddComment when required
   FOR l_row IN 1..UNICONNECT.P_PA_NR_OF_ROWS LOOP
      IF UNICONNECT.P_PA_ADD_COMMENT_TAB(l_row) IS NOT NULL THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Adding comment for'||
                                   '#sc='||UNICONNECT.P_PA_SC_TAB(l_row)||
                                   '#pg='||UNICONNECT.P_PA_PG_TAB(l_row)||
                                   '#pgnode='||NVL(TO_CHAR(UNICONNECT.P_PA_PGNODE_TAB(l_row)),'NULL')||
                                   '#pa='||UNICONNECT.P_PA_PA_TAB(l_row)||
                                   '#panode='||NVL(TO_CHAR(UNICONNECT.P_PA_PANODE_TAB(l_row)),'NULL'));
         l_ret_code := UNAPIPAP.AddScPaComment(UNICONNECT.P_PA_SC_TAB(l_row),
                                               UNICONNECT.P_PA_PG_TAB(l_row),
                                               UNICONNECT.P_PA_PGNODE_TAB(l_row),
                                               UNICONNECT.P_PA_PA_TAB(l_row),
                                               UNICONNECT.P_PA_PANODE_TAB(l_row),
                                               UNICONNECT.P_PA_ADD_COMMENT_TAB(l_row));

         IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : AddScPaComment ret_code='||l_ret_code ||
                                      '#sc='||UNICONNECT.P_PA_SC_TAB(l_row)||
                                      '#pg='||UNICONNECT.P_PA_PG_TAB(l_row)||
                                      '#pgnode='||NVL(TO_CHAR(UNICONNECT.P_PA_PGNODE_TAB(l_row)),'NULL')||
                                      '#pa='||UNICONNECT.P_PA_PA_TAB(l_row)||
                                      '#panode='||NVL(TO_CHAR(UNICONNECT.P_PA_PANODE_TAB(l_row)),'NULL'));
            IF UNAPIAUT.P_NOT_AUTHORISED IS NOT NULL THEN
               UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         ' || UNAPIAUT.P_NOT_AUTHORISED );
            END IF;
            RAISE StpError;
         END IF;
      END IF;
   END LOOP;

   --Initialise PA and PANODE global variables with the last pa in array
   --Cleanup the arrays used to save the parameter(s) (important since it can be reused)
   IF UNICONNECT.P_PA_NR_OF_ROWS > 0 THEN
      UNICONNECT.P_GLOB_PA := UNICONNECT.P_PA_PA_TAB(UNICONNECT.P_PA_NR_OF_ROWS);
      UNICONNECT.P_GLOB_PANODE := UNICONNECT.P_PA_PANODE_TAB(UNICONNECT.P_PA_NR_OF_ROWS);

      UNICONNECT2.WriteGlobalVariablesToLog;

   ELSE
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NORMAL,'         Warning ! current pa and panode not set before leaving [pa] section !');
   END IF;
   UCON_CleanupPaSection;
   UNICONNECT.P_PA_NR_OF_ROWS := 0;

   --close internal transaction before returning
   IF l_internal_transaction THEN
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Terminating implicit transaction');
      l_return := UNICONNECT.FinishTransaction;
      IF l_return <> UNAPIGEN.DBERR_SUCCESS THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         EndTransaction failed ! ret_code='||TO_CHAR(l_return));
      END IF;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
WHEN OTHERS THEN
   --finish the internal transaction when required
   --close internal transaction before returning
   IF l_internal_transaction THEN
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Terminating implicit transaction');
      l_return := UNICONNECT.FinishTransaction;
      IF l_return <> UNAPIGEN.DBERR_SUCCESS THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         EndTransaction failed ! ret_code='||TO_CHAR(l_return));
      END IF;
   END IF;
   IF sqlcode <> 1 THEN
      --the exception is not a user exception
      l_sqlerrm := SUBSTR(SQLERRM, 1, 200);
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Following exception catched in UCON_ExecutePaSection :');
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         '||l_sqlerrm);
      l_ret_code := UNAPIGEN.DBERR_GENFAIL;
   END IF;
   UNAPIGEN.P_TXN_ERROR := l_ret_code;
   UCON_CleanupPaSection;
   RETURN(l_ret_code);
END UCON_ExecutePaSection;

PROCEDURE WriteGlobalVariablesToLog IS
BEGIN
   UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         '||UNICONNECT.P_SECTION||' section terminated ');
   UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         =========================================');
   UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'            SC='||UNICONNECT.P_GLOB_SC);
   UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'            PG='||UNICONNECT.P_GLOB_PG||'#PGNODE='||UNICONNECT.P_GLOB_PGNODE
                                  ||'#PA='||UNICONNECT.P_GLOB_PA||'#PANODE='||UNICONNECT.P_GLOB_PANODE
                                  ||'#ME='||UNICONNECT.P_GLOB_ME||'#MENODE='||UNICONNECT.P_GLOB_MENODE
                                  ||'#CE='||UNICONNECT.P_GLOB_CE||'#CENODE='||UNICONNECT.P_GLOB_CENODE);
   UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'            IC='||UNICONNECT.P_GLOB_IC||'#ICNODE='||UNICONNECT.P_GLOB_ICNODE
                                  ||'#II='||UNICONNECT.P_GLOB_II||'#IINODE='||UNICONNECT.P_GLOB_IINODE);
   UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         =========================================');

END WriteGlobalVariablesToLog;

END uniconnect2;
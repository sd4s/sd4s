create or replace PACKAGE BODY
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
uniconnect3 AS

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

--private package variable for [me] section
p_me_pgnode_setinsection      BOOLEAN DEFAULT FALSE;
p_me_panode_setinsection      BOOLEAN DEFAULT FALSE;

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
/* procedures and functions related to the [me] section */
/*------------------------------------------------------*/
PROCEDURE UCON_InitialiseMeSection     /* INTERNAL */
IS
BEGIN

   --local variables initialisation
   UNICONNECT.P_ME_NR_OF_ROWS := 0;
   UNICONNECT.P_ME_SC := UNICONNECT.P_GLOB_SC;
   UNICONNECT.P_ME_PG := UNICONNECT.P_GLOB_PG;
   UNICONNECT.P_ME_PGNODE := UNICONNECT.P_GLOB_PGNODE;
   UNICONNECT.P_ME_PP_KEY1 := NULL;
   UNICONNECT.P_ME_PP_KEY2 := NULL;
   UNICONNECT.P_ME_PP_KEY3 := NULL;
   UNICONNECT.P_ME_PP_KEY4 := NULL;
   UNICONNECT.P_ME_PP_KEY5 := NULL;
   UNICONNECT.P_ME_PP_VERSION := NULL;
   UNICONNECT.P_ME_PA := UNICONNECT.P_GLOB_PA;
   UNICONNECT.P_ME_PANODE := UNICONNECT.P_GLOB_PANODE;
   UNICONNECT.P_ME_PR_VERSION := NULL;

   --internal to [me] section
   UNICONNECT.P_ME_USE_SAVESCMERESULT := FALSE;
   UNICONNECT.P_ME_ANY_RESULT := FALSE;
   UNICONNECT.P_ME_PGNAME := NULL;
   UNICONNECT.P_ME_PGDESCRIPTION := NULL;
   UNICONNECT.P_ME_PANAME := NULL;
   UNICONNECT.P_ME_PADESCRIPTION := NULL;
   UNICONNECT.P_ME_ALARMS_HANDLED := NULL;

   --private package variable for [me] section
   p_me_pgnode_setinsection  := FALSE;
   p_me_panode_setinsection  := FALSE;

   --global variables
   UNICONNECT.P_GLOB_ME := NULL;
   UNICONNECT.P_GLOB_MENODE := NULL;


END UCON_InitialiseMeSection;

FUNCTION UCON_AssignMeSectionRow       /* INTERNAL */
RETURN NUMBER IS

l_description_pos      INTEGER;

BEGIN

   --Important assumption : one [me] section is only related to one parameter within one pg within one sample

   UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NONE,'      Assigning value of variable '||UNICONNECT.P_VARIABLE_NAME||' in [me] section');
   IF UNICONNECT.P_VARIABLE_NAME = 'sc' THEN
      UNICONNECT.P_ME_SC := UNICONNECT.P_VARIABLE_VALUE;

   ELSIF UNICONNECT.P_VARIABLE_NAME IN ('pgnode', 'pg.pgnode') THEN
      UNICONNECT.P_ME_PGNODE := UNICONNECT.P_VARIABLE_VALUE;

      --Fatal error when pg not yet specified
      IF UNICONNECT.P_ME_PGNAME IS NULL THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major problem ! pgnode in me section must be preceded by a pg setting');
         RETURN(UNAPIGEN.DBERR_GENFAIL);
      END IF;
      p_me_pgnode_setinsection := TRUE;

   ELSIF UNICONNECT.P_VARIABLE_NAME IN ('pp_key1', 'pg.pp_key1') THEN
      UNICONNECT.P_ME_PP_KEY1 := NVL(UNICONNECT.P_VARIABLE_VALUE, ' ');

   ELSIF UNICONNECT.P_VARIABLE_NAME IN ('pp_key2', 'pg.pp_key2') THEN
      UNICONNECT.P_ME_PP_KEY2 := NVL(UNICONNECT.P_VARIABLE_VALUE, ' ');

   ELSIF UNICONNECT.P_VARIABLE_NAME IN ('pp_key3', 'pg.pp_key3') THEN
      UNICONNECT.P_ME_PP_KEY3 := NVL(UNICONNECT.P_VARIABLE_VALUE, ' ');

   ELSIF UNICONNECT.P_VARIABLE_NAME IN ('pp_key4', 'pg.pp_key4') THEN
      UNICONNECT.P_ME_PP_KEY4 := NVL(UNICONNECT.P_VARIABLE_VALUE, ' ');

   ELSIF UNICONNECT.P_VARIABLE_NAME IN ('pp_key5', 'pg.pp_key5') THEN
      UNICONNECT.P_ME_PP_KEY5 := NVL(UNICONNECT.P_VARIABLE_VALUE, ' ');

   ELSIF UNICONNECT.P_VARIABLE_NAME IN ('pp_version', 'pg.pp_version') THEN
      UNICONNECT.P_ME_PP_VERSION := UNICONNECT.P_VARIABLE_VALUE;

   ELSIF SUBSTR(UNICONNECT.P_VARIABLE_NAME,1,2) = 'pg' THEN
      --MUST BE PLACED after pgnode/pp_key[1-5] variable assignment since SUBSTR will return pg
      --initialise full array except for sample code

      --pg can be specified by description or by name
      l_description_pos := INSTR(UNICONNECT.P_VARIABLE_NAME, '.description');
      IF l_description_pos > 0 THEN
         UNICONNECT.P_ME_PGDESCRIPTION := UNICONNECT.P_VARIABLE_VALUE;
         UNICONNECT.P_ME_PGNAME        := UNICONNECT.P_VARIABLE_NAME;
         UNICONNECT.P_ME_PG := NULL;
      ELSE
         UNICONNECT.P_ME_PG            := UNICONNECT.P_VARIABLE_VALUE;
         UNICONNECT.P_ME_PGNAME        := UNICONNECT.P_VARIABLE_NAME;
         UNICONNECT.P_ME_PGDESCRIPTION := NULL;
      END IF;

      --also reset pgnode : pgnode is initialised with global setting PGNODE when entering
      --the section
      UNICONNECT.P_ME_PGNODE := NULL;

   ELSIF UNICONNECT.P_VARIABLE_NAME IN ('panode', 'pa.panode') THEN
      UNICONNECT.P_ME_PANODE := UNICONNECT.P_VARIABLE_VALUE;

      --Fatal error when pa not yet specified
      IF UNICONNECT.P_ME_PANAME IS NULL THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major problem ! panode in [me] section must be preceded by a pa setting');
         RETURN(UNAPIGEN.DBERR_GENFAIL);
      END IF;
      p_me_panode_setinsection := TRUE;

   ELSIF UNICONNECT.P_VARIABLE_NAME IN ('pr_version', 'pa.pr_version') THEN
      UNICONNECT.P_ME_PR_VERSION := UNICONNECT.P_VARIABLE_VALUE;

   ELSIF SUBSTR(UNICONNECT.P_VARIABLE_NAME,1,2) = 'pa' THEN
      --MUST BE PLACED after panode variable assignment since SUBSTR will return pa

      --pg can be specified by description or by name
      l_description_pos := INSTR(UNICONNECT.P_VARIABLE_NAME, '.description');
      IF l_description_pos > 0 THEN
         UNICONNECT.P_ME_PADESCRIPTION := UNICONNECT.P_VARIABLE_VALUE;
         UNICONNECT.P_ME_PANAME        := UNICONNECT.P_VARIABLE_NAME;
         UNICONNECT.P_ME_PA := NULL;
      ELSE
         UNICONNECT.P_ME_PA            := UNICONNECT.P_VARIABLE_VALUE;
         UNICONNECT.P_ME_PANAME        := UNICONNECT.P_VARIABLE_NAME;
         UNICONNECT.P_ME_PADESCRIPTION := NULL;
      END IF;

      --also reset panode : panode is initialised with global setting PANODE when entering
      --the section
      UNICONNECT.P_ME_PANODE := NULL;

   ELSIF UNICONNECT.P_VARIABLE_NAME = 'value_f' THEN
      UNICONNECT.P_ME_VALUE_F_TAB(UNICONNECT.P_ME_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;
      UNICONNECT.P_ME_VALUE_F_MODTAB(UNICONNECT.P_ME_NR_OF_ROWS) := TRUE;
      UNICONNECT.P_ME_MODIFY_FLAG_TAB(UNICONNECT.P_ME_NR_OF_ROWS) := UNAPIGEN.MOD_FLAG_UPDATE;
      UNICONNECT.P_ME_ANY_RESULT := TRUE;

   ELSIF UNICONNECT.P_VARIABLE_NAME = 'value_s' THEN
      UNICONNECT.P_ME_VALUE_S_TAB(UNICONNECT.P_ME_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;
      UNICONNECT.P_ME_VALUE_S_MODTAB(UNICONNECT.P_ME_NR_OF_ROWS) := TRUE;
      UNICONNECT.P_ME_MODIFY_FLAG_TAB(UNICONNECT.P_ME_NR_OF_ROWS) := UNAPIGEN.MOD_FLAG_UPDATE;
      UNICONNECT.P_ME_ANY_RESULT := TRUE;

   ELSIF UNICONNECT.P_VARIABLE_NAME = 'unit' THEN
      UNICONNECT.P_ME_UNIT_TAB(UNICONNECT.P_ME_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;
      UNICONNECT.P_ME_UNIT_MODTAB(UNICONNECT.P_ME_NR_OF_ROWS) := TRUE;
      UNICONNECT.P_ME_MODIFY_FLAG_TAB(UNICONNECT.P_ME_NR_OF_ROWS) := UNAPIGEN.MOD_FLAG_UPDATE;

   ELSIF UNICONNECT.P_VARIABLE_NAME = 'manually_entered' THEN
      UNICONNECT.P_ME_MANUALLY_ENTERED_TAB(UNICONNECT.P_ME_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;
      UNICONNECT.P_ME_MANUALLY_ENTERED_MODTAB(UNICONNECT.P_ME_NR_OF_ROWS) := TRUE;
      UNICONNECT.P_ME_MODIFY_FLAG_TAB(UNICONNECT.P_ME_NR_OF_ROWS) := UNAPIGEN.MOD_FLAG_UPDATE;

   ELSIF UNICONNECT.P_VARIABLE_NAME = 'exec_start_date' THEN
      UNICONNECT.P_ME_EXEC_START_DATE_TAB(UNICONNECT.P_ME_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;
      UNICONNECT.P_ME_EXEC_START_DATE_MODTAB(UNICONNECT.P_ME_NR_OF_ROWS) := TRUE;
      UNICONNECT.P_ME_MODIFY_FLAG_TAB(UNICONNECT.P_ME_NR_OF_ROWS) := UNAPIGEN.MOD_FLAG_UPDATE;
      UNICONNECT.P_ME_USE_SAVESCMERESULT := FALSE;  --SaveScMethod will be used instead of SaveScMeResult
                                                 --since exec_start_date not in SaveScMeResult API

   ELSIF UNICONNECT.P_VARIABLE_NAME = 'exec_end_date' THEN
      UNICONNECT.P_ME_EXEC_END_DATE_TAB(UNICONNECT.P_ME_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;
      UNICONNECT.P_ME_EXEC_END_DATE_MODTAB(UNICONNECT.P_ME_NR_OF_ROWS) := TRUE;
      UNICONNECT.P_ME_MODIFY_FLAG_TAB(UNICONNECT.P_ME_NR_OF_ROWS) := UNAPIGEN.MOD_FLAG_UPDATE;
      UNICONNECT.P_ME_ANY_RESULT := TRUE;

   ELSIF UNICONNECT.P_VARIABLE_NAME = 'executor' THEN
      UNICONNECT.P_ME_EXECUTOR_TAB(UNICONNECT.P_ME_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;
      UNICONNECT.P_ME_EXECUTOR_MODTAB(UNICONNECT.P_ME_NR_OF_ROWS) := TRUE;
      UNICONNECT.P_ME_MODIFY_FLAG_TAB(UNICONNECT.P_ME_NR_OF_ROWS) := UNAPIGEN.MOD_FLAG_UPDATE;

   ELSIF UNICONNECT.P_VARIABLE_NAME = 'lab' THEN
      UNICONNECT.P_ME_LAB_TAB(UNICONNECT.P_ME_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;
      UNICONNECT.P_ME_LAB_MODTAB(UNICONNECT.P_ME_NR_OF_ROWS) := TRUE;
      UNICONNECT.P_ME_MODIFY_FLAG_TAB(UNICONNECT.P_ME_NR_OF_ROWS) := UNAPIGEN.MOD_FLAG_UPDATE;

   ELSIF UNICONNECT.P_VARIABLE_NAME = 'eq' THEN
      UNICONNECT.P_ME_EQ_TAB(UNICONNECT.P_ME_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;
      UNICONNECT.P_ME_EQ_MODTAB(UNICONNECT.P_ME_NR_OF_ROWS) := TRUE;
      UNICONNECT.P_ME_MODIFY_FLAG_TAB(UNICONNECT.P_ME_NR_OF_ROWS) := UNAPIGEN.MOD_FLAG_UPDATE;

   ELSIF UNICONNECT.P_VARIABLE_NAME = 'comment' THEN
      UNICONNECT.P_ME_MODIFY_REASON := UNICONNECT.P_VARIABLE_VALUE;
      UNICONNECT.P_ME_MODIFY_FLAG_TAB(UNICONNECT.P_ME_NR_OF_ROWS) := UNAPIGEN.MOD_FLAG_UPDATE;

   ELSIF UNICONNECT.P_VARIABLE_NAME = 'add_comment' THEN
      UNICONNECT.P_ME_ADD_COMMENT_TAB(UNICONNECT.P_ME_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;

   ELSIF UNICONNECT.P_VARIABLE_NAME = 'ss' THEN
      UNICONNECT.P_ME_SS_TAB(UNICONNECT.P_ME_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;
      UNICONNECT.P_ME_SS_MODTAB(UNICONNECT.P_ME_NR_OF_ROWS) := TRUE;

   ELSIF UNICONNECT.P_VARIABLE_NAME = 'description' THEN
      UNICONNECT.P_ME_DESCRIPTION_TAB(UNICONNECT.P_ME_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;
      UNICONNECT.P_ME_DESCRIPTION_MODTAB(UNICONNECT.P_ME_NR_OF_ROWS) := TRUE;
      UNICONNECT.P_ME_MODIFY_FLAG_TAB(UNICONNECT.P_ME_NR_OF_ROWS) := UNAPIGEN.MOD_FLAG_UPDATE;
      UNICONNECT.P_ME_USE_SAVESCMERESULT := FALSE;  --SaveScMethod will be used instead of SaveScMeResult
                                                 --since description not in SaveScMeResult API

   ELSIF UNICONNECT.P_VARIABLE_NAME IN ('menode', 'me.menode') THEN
      UNICONNECT.P_ME_MENODE_TAB(UNICONNECT.P_ME_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;

   ELSIF UNICONNECT.P_VARIABLE_NAME IN ('mt_version', 'me.mt_version') THEN
      UNICONNECT.P_ME_MT_VERSION_TAB(UNICONNECT.P_ME_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;

   ELSIF SUBSTR(UNICONNECT.P_VARIABLE_NAME,1,2) = 'me' THEN
      --MUST BE PLACED after menode variable assignment since SUBSTR will return me
      --initialise full array except for sample code, pg, pgnode, pa and panode
      UNICONNECT.P_ME_NR_OF_ROWS := UNICONNECT.P_ME_NR_OF_ROWS + 1;

      --me can be specified by description or by name
      l_description_pos := INSTR(UNICONNECT.P_VARIABLE_NAME, '.description');
      IF l_description_pos > 0 THEN
         UNICONNECT.P_ME_MEDESCRIPTION_TAB(UNICONNECT.P_ME_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;
         UNICONNECT.P_ME_ME_TAB(UNICONNECT.P_ME_NR_OF_ROWS) := NULL;
      ELSE
         UNICONNECT.P_ME_ME_TAB(UNICONNECT.P_ME_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;
         UNICONNECT.P_ME_MEDESCRIPTION_TAB(UNICONNECT.P_ME_NR_OF_ROWS) := NULL;
      END IF;

      UNICONNECT.P_ME_MENAME_TAB(UNICONNECT.P_ME_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_NAME;

      UNICONNECT.P_ME_MENODE_TAB(UNICONNECT.P_ME_NR_OF_ROWS)                  := NULL;
      UNICONNECT.P_ME_MT_VERSION_TAB(UNICONNECT.P_ME_NR_OF_ROWS)              := NULL;
      UNICONNECT.P_ME_DESCRIPTION_TAB(UNICONNECT.P_ME_NR_OF_ROWS)             := NULL;
      UNICONNECT.P_ME_VALUE_F_TAB(UNICONNECT.P_ME_NR_OF_ROWS)                 := NULL;
      UNICONNECT.P_ME_VALUE_S_TAB(UNICONNECT.P_ME_NR_OF_ROWS)                 := NULL;
      UNICONNECT.P_ME_UNIT_TAB(UNICONNECT.P_ME_NR_OF_ROWS)                    := NULL;
      UNICONNECT.P_ME_MANUALLY_ENTERED_TAB(UNICONNECT.P_ME_NR_OF_ROWS)        := NULL;
      UNICONNECT.P_ME_EXEC_START_DATE_TAB(UNICONNECT.P_ME_NR_OF_ROWS)         := NULL;
      UNICONNECT.P_ME_EXEC_END_DATE_TAB(UNICONNECT.P_ME_NR_OF_ROWS)           := NULL;
      UNICONNECT.P_ME_EXECUTOR_TAB(UNICONNECT.P_ME_NR_OF_ROWS)                := NULL;
      UNICONNECT.P_ME_LAB_TAB(UNICONNECT.P_ME_NR_OF_ROWS)                     := NULL;
      UNICONNECT.P_ME_EQ_TAB(UNICONNECT.P_ME_NR_OF_ROWS)                      := NULL;
      UNICONNECT.P_ME_EQ_VERSION_TAB(UNICONNECT.P_ME_NR_OF_ROWS)              := NULL;
      UNICONNECT.P_ME_MODIFY_FLAG_TAB(UNICONNECT.P_ME_NR_OF_ROWS)             := UNAPIGEN.DBERR_SUCCESS;
      UNICONNECT.P_ME_SS_TAB(UNICONNECT.P_ME_NR_OF_ROWS)                      := NULL;
      UNICONNECT.P_ME_ADD_COMMENT_TAB(UNICONNECT.P_ME_NR_OF_ROWS)             := NULL;

      --initialise all modify flags to FALSE
      UNICONNECT.P_ME_DESCRIPTION_MODTAB(UNICONNECT.P_ME_NR_OF_ROWS)          := FALSE;
      UNICONNECT.P_ME_VALUE_F_MODTAB(UNICONNECT.P_ME_NR_OF_ROWS)              := FALSE;
      UNICONNECT.P_ME_VALUE_S_MODTAB(UNICONNECT.P_ME_NR_OF_ROWS)              := FALSE;
      UNICONNECT.P_ME_UNIT_MODTAB(UNICONNECT.P_ME_NR_OF_ROWS)                 := FALSE;
      UNICONNECT.P_ME_MANUALLY_ENTERED_MODTAB(UNICONNECT.P_ME_NR_OF_ROWS)     := FALSE;
      UNICONNECT.P_ME_EXEC_START_DATE_MODTAB(UNICONNECT.P_ME_NR_OF_ROWS)      := FALSE;
      UNICONNECT.P_ME_EXEC_END_DATE_MODTAB(UNICONNECT.P_ME_NR_OF_ROWS)        := FALSE;
      UNICONNECT.P_ME_EQ_MODTAB(UNICONNECT.P_ME_NR_OF_ROWS)                   := FALSE;
      UNICONNECT.P_ME_EXECUTOR_MODTAB(UNICONNECT.P_ME_NR_OF_ROWS)             := FALSE;
      UNICONNECT.P_ME_LAB_MODTAB(UNICONNECT.P_ME_NR_OF_ROWS)                  := FALSE;
      UNICONNECT.P_ME_SS_MODTAB(UNICONNECT.P_ME_NR_OF_ROWS)                   := FALSE;

   ELSE
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'      Invalid variable '||UNICONNECT.P_VARIABLE_NAME||' in [me] section');
      RETURN(UNAPIGEN.DBERR_INVALIDVARIABLE);
   END IF;
   RETURN(UNAPIGEN.DBERR_SUCCESS);

END UCON_AssignMeSectionRow;

--MeUseValue is an Overloaded function : one returning a NUMBER and the other one returning VARCHAR2
--MeUseValue will return the value specified in the section when effectively set in the section
--A modify_flag is maintained for each variable within the section (see UCON_AssignMeSectionRow)
--The argument a_alt_value (read alternative value) will be returned when the variable has
--not been set (affected) in the section

FUNCTION MeUseValue       /* INTERNAL */
(a_variable_name IN VARCHAR2,
 a_row           IN INTEGER,
 a_alt_value     IN NUMBER)
RETURN NUMBER IS

BEGIN

   IF a_variable_name = 'value_f' THEN
      IF UNICONNECT.P_ME_VALUE_F_MODTAB(a_row) THEN
         RETURN(UNICONNECT.P_ME_VALUE_F_TAB(a_row));
      END IF;
   ELSE
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'      Invalid variable '||a_variable_name||' in MeUseValue');
      RAISE StpError;
   END IF;
   RETURN(a_alt_value);

END MeUseValue;

FUNCTION MeUseValue       /* INTERNAL */
(a_variable_name IN VARCHAR2,
 a_row           IN INTEGER,
 a_alt_value     IN VARCHAR2)
RETURN VARCHAR2 IS

BEGIN

   IF a_variable_name = 'description' THEN
      IF UNICONNECT.P_ME_DESCRIPTION_MODTAB(a_row) THEN
         RETURN(UNICONNECT.P_ME_DESCRIPTION_TAB(a_row));
      END IF;
   ELSIF a_variable_name = 'value_s' THEN
      IF UNICONNECT.P_ME_VALUE_S_MODTAB(a_row) THEN
         RETURN(UNICONNECT.P_ME_VALUE_S_TAB(a_row));
      END IF;
   ELSIF a_variable_name = 'unit' THEN
      IF UNICONNECT.P_ME_UNIT_MODTAB(a_row) THEN
         RETURN(UNICONNECT.P_ME_UNIT_TAB(a_row));
      END IF;
   ELSIF a_variable_name = 'exec_start_date' THEN
      IF UNICONNECT.P_ME_EXEC_START_DATE_MODTAB(a_row) THEN
         RETURN(UNICONNECT.P_ME_EXEC_START_DATE_TAB(a_row));
      END IF;
   ELSIF a_variable_name = 'exec_end_date' THEN
      IF UNICONNECT.P_ME_EXEC_END_DATE_MODTAB(a_row) THEN
         RETURN(UNICONNECT.P_ME_EXEC_END_DATE_TAB(a_row));
      END IF;
   ELSIF a_variable_name = 'executor' THEN
      IF UNICONNECT.P_ME_EXECUTOR_MODTAB(a_row) THEN
         RETURN(UNICONNECT.P_ME_EXECUTOR_TAB(a_row));
      END IF;
   ELSIF a_variable_name = 'lab' THEN
      IF UNICONNECT.P_ME_LAB_MODTAB(a_row) THEN
         RETURN(UNICONNECT.P_ME_LAB_TAB(a_row));
      END IF;
   ELSIF a_variable_name = 'manually_entered' THEN
      IF UNICONNECT.P_ME_MANUALLY_ENTERED_MODTAB(a_row) THEN
         RETURN(UNICONNECT.P_ME_MANUALLY_ENTERED_TAB(a_row));
      END IF;
   ELSIF a_variable_name = 'eq' THEN
      IF UNICONNECT.P_ME_EQ_MODTAB(a_row) THEN
         RETURN(UNICONNECT.P_ME_EQ_TAB(a_row));
      END IF;
   ELSE
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'      Invalid variable '||a_variable_name||' in MeUseValue');
      RAISE StpError;
   END IF;
   RETURN(a_alt_value);

END MeUseValue;

--FindScMe returns the utscme record corresponding
--to a specific search syntax
--See FindScPg for examples

FUNCTION FindScMe (a_sc          IN     VARCHAR2,
                   a_pg          IN     VARCHAR2,
                   a_pgnode      IN     NUMBER,
                   a_pp_key1     IN     VARCHAR2,
                   a_pp_key2     IN     VARCHAR2,
                   a_pp_key3     IN     VARCHAR2,
                   a_pp_key4     IN     VARCHAR2,
                   a_pp_key5     IN     VARCHAR2,
                   a_pp_version  IN     VARCHAR2,
                   a_pa          IN     VARCHAR2,
                   a_panode      IN     NUMBER,
                   a_pr_version  IN     VARCHAR2,
                   a_me          IN OUT VARCHAR2,
                   a_description IN     VARCHAR2,
                   a_menode      IN     NUMBER,
                   a_mt_version  IN     VARCHAR2,
                   a_search_base IN     VARCHAR2,
                   a_pos         IN     INTEGER,
                   a_current_row IN     INTEGER)
RETURN utscme%ROWTYPE IS

l_me_rec       utscme%ROWTYPE;
l_leave_loop   BOOLEAN DEFAULT FALSE;
l_used         BOOLEAN DEFAULT FALSE;
l_counter      INTEGER;

CURSOR l_scme_cursor IS
   SELECT c.*
   FROM utscme c, utscpa b, utscpg a
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
   -- subquery must be consistent with FindScPa query EXCEPT that pa is not mandatory in this subquery
   AND b.sc = a.sc
   AND b.pg = a.pg
   AND b.pgnode = a.pgnode
   AND b.pa = NVL(a_pa, b.pa)
   AND b.panode = NVL(a_panode, b.panode)
   AND NVL(b.pr_version, '0') = NVL(a_pr_version, NVL(b.pr_version, '0'))
   AND c.sc = b.sc
   AND c.pg = b.pg
   AND c.pgnode = b.pgnode
   AND c.pa = b.pa
   AND c.panode = b.panode
   AND c.me = a_me
   AND c.menode = NVL(a_menode, c.menode)
   AND NVL(c.mt_version, '0') = NVL(a_mt_version, NVL(c.mt_version, '0'))
   ORDER BY c.pgnode, c.panode, c.menode ASC;

CURSOR l_scme_notexecuted_cursor IS
   SELECT c.*
   FROM utscme c, utscpa b, utscpg a
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
   -- subquery must be consistent with FindScPa query EXCEPT that pa is not mandatory in this subquery
   AND b.sc = a.sc
   AND b.pg = a.pg
   AND b.pgnode = a.pgnode
   AND b.pa = NVL(a_pa, b.pa)
   AND b.panode = NVL(a_panode, b.panode)
   AND NVL(b.pr_version, '0') = NVL(a_pr_version, NVL(b.pr_version, '0'))
   AND c.sc = b.sc
   AND c.pg = b.pg
   AND c.pgnode = b.pgnode
   AND c.pa = b.pa
   AND c.panode = b.panode
   AND c.me = a_me
   AND c.menode = NVL(a_menode, c.menode)
   AND c.exec_end_date IS NULL
   AND NVL(c.mt_version, '0') = NVL(a_mt_version, NVL(c.mt_version, '0'))
   ORDER BY c.pgnode, c.panode, c.menode ASC;

CURSOR l_scmedesc_cursor IS
   SELECT c.*
   FROM utscme c, utscpa b, utscpg a
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
   -- subquery must be consistent with FindScPa query EXCEPT that pa is not mandatory in this subquery
   AND b.sc = a.sc
   AND b.pg = a.pg
   AND b.pgnode = a.pgnode
   AND b.pa = NVL(a_pa, b.pa)
   AND b.panode = NVL(a_panode, b.panode)
   AND NVL(b.pr_version, '0') = NVL(a_pr_version, NVL(b.pr_version, '0'))
   AND c.sc = b.sc
   AND c.pg = b.pg
   AND c.pgnode = b.pgnode
   AND c.pa = b.pa
   AND c.panode = b.panode
   AND c.description = a_description
   AND c.menode = NVL(a_menode, c.menode)
   AND NVL(c.mt_version, '0') = NVL(a_mt_version, NVL(c.mt_version, '0'))
   ORDER BY c.pgnode, c.panode, c.menode ASC;

CURSOR l_scmedesc_notexecuted_cursor IS
   SELECT c.*
   FROM utscme c, utscpa b, utscpg a
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
   -- subquery must be consistent with FindScPa query EXCEPT that pa is not mandatory in this subquery
   AND b.sc = a.sc
   AND b.pg = a.pg
   AND b.pgnode = a.pgnode
   AND b.pa = NVL(a_pa, b.pa)
   AND b.panode = NVL(a_panode, b.panode)
   AND NVL(b.pr_version, '0') = NVL(a_pr_version, NVL(b.pr_version, '0'))
   AND c.sc = b.sc
   AND c.pg = b.pg
   AND c.pgnode = b.pgnode
   AND c.pa = b.pa
   AND c.panode = b.panode
   AND c.description = a_description
   AND c.menode = NVL(a_menode, c.menode)
   AND c.exec_end_date IS NULL
   AND NVL(c.mt_version, '0') = NVL(a_mt_version, NVL(c.mt_version, '0'))
   ORDER BY c.pgnode, c.panode, c.menode ASC;

BEGIN
   l_me_rec := NULL;

   IF a_search_base = 'me' THEN
      IF a_pos IS NULL THEN


         --find first me which is not executed and which is not used
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Searching for first me which is not executed and not used for sc='||
                                      a_sc|| '#pg='||a_pg||'#pgnode='||NVL(TO_CHAR(a_pgnode),'NULL'));
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         #pp_key1='|| a_pp_key1||'#pp_key2='||a_pp_key2||'#pp_key3='||a_pp_key3||
                                                        '#pp_key4='||a_pp_key4||'#pp_key5='||a_pp_key5||'#pp_version='||a_pp_version);
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         #pa='||a_pa||'#panode='||NVL(TO_CHAR(a_panode),'NULL')||'#pr_version='||a_pr_version||'#');
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         #me='||a_me||'#menode='||NVL(TO_CHAR(a_panode),'NULL')||'#mt_version='||a_mt_version||'#');

         OPEN l_scme_notexecuted_cursor;
         LOOP
            FETCH l_scme_notexecuted_cursor
            INTO l_me_rec;
            EXIT WHEN l_scme_notexecuted_cursor%NOTFOUND;
            --check if me/menode combination already used
            l_used := FALSE;
            FOR l_row IN 1..UNICONNECT.P_ME_NR_OF_ROWS LOOP
               IF UNICONNECT.P_ME_ME_TAB(l_row) = a_me THEN
                  IF UNICONNECT.P_ME_MENODE_TAB(l_row) = l_me_rec.menode THEN
                     IF a_current_row <> l_row THEN
                        l_used := TRUE;
                     END IF;
                  END IF;
               END IF;
            END LOOP;
            IF l_used THEN
               l_me_rec := NULL;
            ELSE
               EXIT;
            END IF;
         END LOOP;
         CLOSE l_scme_notexecuted_cursor;
      ELSE

         --find me in xth position (x=a_pos)
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Searching for me in position '||TO_CHAR(a_pos)||' for sc='||
                                      a_sc|| '#pg='||a_pg||'#pgnode='||NVL(TO_CHAR(a_pgnode),'NULL'));
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         #pp_key1='|| a_pp_key1||'#pp_key2='||a_pp_key2||'#pp_key3='||a_pp_key3||
                                                        '#pp_key4='||a_pp_key4||'#pp_key5='||a_pp_key5||'#pp_version='||a_pp_version);
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         #pa='||a_pa||'#panode='||NVL(TO_CHAR(a_panode),'NULL')||'#pr_version='||a_pr_version||'#');
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         #me='||a_me||'#menode='||NVL(TO_CHAR(a_panode),'NULL')||'#mt_version='||a_mt_version||'#');
         OPEN l_scme_cursor;
         l_counter := 0;
         LOOP
            FETCH l_scme_cursor
            INTO l_me_rec;
            EXIT WHEN l_scme_cursor%NOTFOUND;
            --check if me/menode combination already used
            l_counter := l_counter + 1;
            IF l_counter >= a_pos THEN
               EXIT;
            ELSE
               l_me_rec := NULL;
            END IF;
         END LOOP;
         CLOSE l_scme_cursor;

      END IF;
   ELSE
      IF a_pos IS NULL THEN

         --find first me which is not executed and which is not used
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Searching for first me (description) which is not executed and not used for sc='||
                                      a_sc||'#pg='||a_pg||'#pgnode='||NVL(TO_CHAR(a_pgnode),'NULL')||
                                      '#description='||a_description);
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         #pp_key1='|| a_pp_key1||'#pp_key2='||a_pp_key2||'#pp_key3='||a_pp_key3||
                                                        '#pp_key4='||a_pp_key4||'#pp_key5='||a_pp_key5||'#pp_version='||a_pp_version);
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         #pa='||a_pa||'#panode='||NVL(TO_CHAR(a_panode),'NULL')||'#pr_version='||a_pr_version||'#');
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         #me='||a_me||'#menode='||NVL(TO_CHAR(a_panode),'NULL')||'#mt_version='||a_mt_version||'#');

         OPEN l_scmedesc_notexecuted_cursor;
         LOOP
            FETCH l_scmedesc_notexecuted_cursor
            INTO l_me_rec;
            EXIT WHEN l_scmedesc_notexecuted_cursor%NOTFOUND;
            --check if me/menode combination already used
            l_used := FALSE;
            FOR l_row IN 1..UNICONNECT.P_ME_NR_OF_ROWS LOOP
               IF UNICONNECT.P_ME_ME_TAB(l_row) = l_me_rec.me THEN
                  IF UNICONNECT.P_ME_MENODE_TAB(l_row) = l_me_rec.menode THEN
                     IF a_current_row <> l_row THEN
                        l_used := TRUE;
                     END IF;
                  END IF;
               END IF;
            END LOOP;
            IF l_used THEN
               l_me_rec.menode := NULL;
            ELSE
               a_me := l_me_rec.me;
               EXIT;
            END IF;
         END LOOP;
         CLOSE l_scmedesc_notexecuted_cursor;
      ELSE

         --find me in xth position (x=a_pos)
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Searching for me (description) in position '||TO_CHAR(a_pos)||' for sc='||
                                      a_sc||'#pg='||a_pg||'#pgnode='||NVL(TO_CHAR(a_pgnode),'NULL')||
                                      '#description='||a_description);
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         #pp_key1='|| a_pp_key1||'#pp_key2='||a_pp_key2||'#pp_key3='||a_pp_key3||
                                                        '#pp_key4='||a_pp_key4||'#pp_key5='||a_pp_key5||'#pp_version='||a_pp_version);
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         #pa='||a_pa||'#panode='||NVL(TO_CHAR(a_panode),'NULL')||'#pr_version='||a_pr_version||'#');
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         #me='||a_me||'#menode='||NVL(TO_CHAR(a_panode),'NULL')||'#mt_version='||a_mt_version||'#');
         OPEN l_scmedesc_cursor;
         l_counter := 0;
         LOOP
            FETCH l_scmedesc_cursor
            INTO l_me_rec;
            EXIT WHEN l_scmedesc_cursor%NOTFOUND;
            --check if me/menode combination already used
            l_counter := l_counter + 1;
            IF l_counter >= a_pos THEN
               a_me := l_me_rec.me;
               EXIT;
            ELSE
               l_me_rec := NULL;
            END IF;
         END LOOP;
         CLOSE l_scmedesc_cursor;

      END IF;
   END IF;

   RETURN (l_me_rec);

END FindScMe;

PROCEDURE UCON_CleanupMeSection IS
BEGIN
   --Important since these variables should only
   --last for the execution of the [me] section
   --but have to be implemented as global package variables
   --to keep it mantainable

   UNICONNECT.P_ME_SC_TAB.DELETE;
   UNICONNECT.P_ME_PG_TAB.DELETE;
   UNICONNECT.P_ME_PGNODE_TAB.DELETE;
   UNICONNECT.P_ME_PA_TAB.DELETE;
   UNICONNECT.P_ME_PANODE_TAB.DELETE;
   UNICONNECT.P_ME_ME_TAB.DELETE;

   UNICONNECT.P_ME_MENAME_TAB.DELETE;
   UNICONNECT.P_ME_MEDESCRIPTION_TAB.DELETE;

   UNICONNECT.P_ME_MENODE_TAB.DELETE;

   UNICONNECT.P_ME_MT_VERSION_TAB.DELETE;
   UNICONNECT.P_ME_DESCRIPTION_TAB.DELETE;
   UNICONNECT.P_ME_VALUE_F_TAB.DELETE;
   UNICONNECT.P_ME_VALUE_S_TAB.DELETE;
   UNICONNECT.P_ME_UNIT_TAB.DELETE;
   UNICONNECT.P_ME_EXEC_START_DATE_TAB.DELETE;
   UNICONNECT.P_ME_EXEC_END_DATE_TAB.DELETE;
   UNICONNECT.P_ME_EXECUTOR_TAB.DELETE;
   UNICONNECT.P_ME_LAB_TAB.DELETE;
   UNICONNECT.P_ME_EQ_TAB.DELETE;
   UNICONNECT.P_ME_EQ_VERSION_TAB.DELETE;
   UNICONNECT.P_ME_PLANNED_EXECUTOR_TAB.DELETE;
   UNICONNECT.P_ME_PLANNED_EQ_TAB.DELETE;
   UNICONNECT.P_ME_PLANNED_EQ_VERSION_TAB.DELETE;
   UNICONNECT.P_ME_MANUALLY_ENTERED_TAB.DELETE;
   UNICONNECT.P_ME_ALLOW_ADD_TAB.DELETE;
   UNICONNECT.P_ME_ASSIGN_DATE_TAB.DELETE;
   UNICONNECT.P_ME_ASSIGNED_BY_TAB.DELETE;
   UNICONNECT.P_ME_MANUALLY_ADDED_TAB.DELETE;
   UNICONNECT.P_ME_DELAY_TAB.DELETE;
   UNICONNECT.P_ME_DELAY_UNIT_TAB.DELETE;
   UNICONNECT.P_ME_FORMAT_TAB.DELETE;
   UNICONNECT.P_ME_ACCURACY_TAB.DELETE;
   UNICONNECT.P_ME_REAL_COST_TAB.DELETE;
   UNICONNECT.P_ME_REAL_TIME_TAB.DELETE;
   UNICONNECT.P_ME_CALIBRATION_TAB.DELETE;
   UNICONNECT.P_ME_CONFIRM_COMPLETE_TAB.DELETE;
   UNICONNECT.P_ME_AUTORECALC_TAB.DELETE;
   UNICONNECT.P_ME_ME_RESULT_EDITABLE_TAB.DELETE;
   UNICONNECT.P_ME_NEXT_CELL_TAB.DELETE;
   UNICONNECT.P_ME_SOP_TAB.DELETE;
   UNICONNECT.P_ME_SOP_VERSION_TAB.DELETE;
   UNICONNECT.P_ME_PLAUS_LOW_TAB.DELETE;
   UNICONNECT.P_ME_PLAUS_HIGH_TAB.DELETE;
   UNICONNECT.P_ME_WINSIZE_X_TAB.DELETE;
   UNICONNECT.P_ME_WINSIZE_Y_TAB.DELETE;
   UNICONNECT.P_ME_ME_CLASS_TAB.DELETE;
   UNICONNECT.P_ME_LOG_HS_TAB.DELETE;
   UNICONNECT.P_ME_LOG_HS_DETAILS_TAB.DELETE;
   UNICONNECT.P_ME_LC_TAB.DELETE;
   UNICONNECT.P_ME_LC_VERSION_TAB.DELETE;
   UNICONNECT.P_ME_MODIFY_FLAG_TAB.DELETE;
   UNICONNECT.P_ME_REANALYSIS_TAB.DELETE;
   UNICONNECT.P_ME_SS_TAB.DELETE;
   UNICONNECT.P_ME_ADD_COMMENT_TAB.DELETE;

   UNICONNECT.P_ME_DESCRIPTION_MODTAB.DELETE;
   UNICONNECT.P_ME_VALUE_F_MODTAB.DELETE;
   UNICONNECT.P_ME_VALUE_S_MODTAB.DELETE;
   UNICONNECT.P_ME_UNIT_MODTAB.DELETE;
   UNICONNECT.P_ME_MANUALLY_ENTERED_MODTAB.DELETE;
   UNICONNECT.P_ME_EXEC_START_DATE_MODTAB.DELETE;
   UNICONNECT.P_ME_EXEC_END_DATE_MODTAB.DELETE;
   UNICONNECT.P_ME_EXECUTOR_MODTAB.DELETE;
   UNICONNECT.P_ME_LAB_MODTAB.DELETE;
   UNICONNECT.P_ME_EQ_MODTAB.DELETE;
   UNICONNECT.P_ME_SS_MODTAB.DELETE;

   UNICONNECT.P_ME_SC := NULL;
   UNICONNECT.P_ME_PG := NULL;
   UNICONNECT.P_ME_PGNAME := NULL;
   UNICONNECT.P_ME_PGDESCRIPTION := NULL;
   UNICONNECT.P_ME_PGNODE := NULL;
   UNICONNECT.P_ME_PP_KEY1 := NULL;
   UNICONNECT.P_ME_PP_KEY2 := NULL;
   UNICONNECT.P_ME_PP_KEY3 := NULL;
   UNICONNECT.P_ME_PP_KEY4 := NULL;
   UNICONNECT.P_ME_PP_KEY5 := NULL;
   UNICONNECT.P_ME_PP_VERSION := NULL;
   UNICONNECT.P_ME_PA := NULL;
   UNICONNECT.P_ME_PANAME := NULL;
   UNICONNECT.P_ME_PADESCRIPTION := NULL;
   UNICONNECT.P_ME_PANODE := NULL;
   UNICONNECT.P_ME_PR_VERSION := NULL;
   UNICONNECT.P_ME_ALARMS_HANDLED := NULL;
   UNICONNECT.P_ME_USE_SAVESCMERESULT := FALSE;
   UNICONNECT.P_ME_ANY_RESULT := FALSE;
   UNICONNECT.P_ME_MODIFY_REASON := NULL;
   UNICONNECT.P_ME_NR_OF_ROWS := 0;
END UCON_CleanupMeSection;

FUNCTION UCON_ExecuteMeSection         /* INTERNAL */
RETURN NUMBER IS

l_sc                   VARCHAR2(20);
l_variable_name        VARCHAR2(20);
l_description_pos      INTEGER;
l_openbrackets_pos     INTEGER;
l_closebrackets_pos    INTEGER;
l_pg_pos               INTEGER;
l_pg_rec_found         utscpg%ROWTYPE;
l_pa_pos               INTEGER;
l_pa_rec_found         utscpa%ROWTYPE;
l_mt                   VARCHAR2(20);
l_me_pos               INTEGER;
l_me_rec_found         utscme%ROWTYPE;
l_any_save             BOOLEAN DEFAULT FALSE;
l_used_api             VARCHAR2(30);
l_slashpg_pgnode       NUMBER(9);
l_slashpg_searched     BOOLEAN;
l_slashpa_panode       NUMBER(9);
l_slashpa_searched     BOOLEAN;
l_reanalysis           NUMBER(3);
l_internal_transaction BOOLEAN DEFAULT FALSE;
l_ret_code             INTEGER;

/* InitScMethod : local variables */
l_initme_mt                          VARCHAR2(20);
l_initme_mt_version_in               VARCHAR2(20);
l_initme_seq                         NUMBER;
l_initme_sc                          VARCHAR2(20);
l_initme_pg                          VARCHAR2(20);
l_initme_pgnode                      NUMBER;
l_initme_pa                          VARCHAR2(20);
l_initme_panode                      NUMBER;
l_initme_pr_version                  VARCHAR2(20);
l_initme_mt_nr_measur                NUMBER;
l_initme_mt_version_tab              UNAPIGEN.VC20_TABLE_TYPE;
l_initme_description_tab             UNAPIGEN.VC40_TABLE_TYPE;
l_initme_value_f_tab                 UNAPIGEN.FLOAT_TABLE_TYPE;
l_initme_value_s_tab                 UNAPIGEN.VC40_TABLE_TYPE;
l_initme_unit_tab                    UNAPIGEN.VC20_TABLE_TYPE;
l_initme_exec_start_date_tab         UNAPIGEN.DATE_TABLE_TYPE;
l_initme_exec_end_date_tab           UNAPIGEN.DATE_TABLE_TYPE;
l_initme_executor_tab                UNAPIGEN.VC20_TABLE_TYPE;
l_initme_lab_tab                     UNAPIGEN.VC20_TABLE_TYPE;
l_initme_eq_tab                      UNAPIGEN.VC20_TABLE_TYPE;
l_initme_eq_version_tab              UNAPIGEN.VC20_TABLE_TYPE;
l_initme_planned_executor_tab        UNAPIGEN.VC20_TABLE_TYPE;
l_initme_planned_eq_tab              UNAPIGEN.VC20_TABLE_TYPE;
l_initme_planned_eq_vers_tab         UNAPIGEN.VC20_TABLE_TYPE;  -- 'l_initme_planned_eq_vers_tab'
                                                                -- instead of
                                                                -- 'l_initme_planned_eq_version_tab'
                                                                -- because max. length = 30 characters
l_initme_manually_entered_tab        UNAPIGEN.CHAR1_TABLE_TYPE;
l_initme_allow_add_tab               UNAPIGEN.CHAR1_TABLE_TYPE;
l_initme_assign_date_tab             UNAPIGEN.DATE_TABLE_TYPE;
l_initme_assigned_by_tab             UNAPIGEN.VC20_TABLE_TYPE;
l_initme_manually_added_tab          UNAPIGEN.CHAR1_TABLE_TYPE;
l_initme_delay_tab                   UNAPIGEN.NUM_TABLE_TYPE;
l_initme_delay_unit_tab              UNAPIGEN.VC20_TABLE_TYPE;
l_initme_format_tab                  UNAPIGEN.VC40_TABLE_TYPE;
l_initme_accuracy_tab                UNAPIGEN.FLOAT_TABLE_TYPE;
l_initme_real_cost_tab               UNAPIGEN.VC40_TABLE_TYPE;
l_initme_real_time_tab               UNAPIGEN.VC40_TABLE_TYPE;
l_initme_calibration_tab             UNAPIGEN.CHAR1_TABLE_TYPE;
l_initme_confirm_complete_tab        UNAPIGEN.CHAR1_TABLE_TYPE;
l_initme_autorecalc_tab              UNAPIGEN.CHAR1_TABLE_TYPE;
l_initme_me_res_editable_tab         UNAPIGEN.CHAR1_TABLE_TYPE; -- 'l_initme_me_res_editable_tab'
                                                                -- instead of
                                                                -- 'l_initme_me_result_editable_tab'
                                                                -- because max. length = 30 characters
l_initme_next_cell_tab               UNAPIGEN.VC20_TABLE_TYPE;
l_initme_sop_tab                     UNAPIGEN.VC40_TABLE_TYPE;
l_initme_sop_version_tab             UNAPIGEN.VC20_TABLE_TYPE;
l_initme_plaus_low_tab               UNAPIGEN.FLOAT_TABLE_TYPE;
l_initme_plaus_high_tab              UNAPIGEN.FLOAT_TABLE_TYPE;
l_initme_winsize_x_tab               UNAPIGEN.NUM_TABLE_TYPE;
l_initme_winsize_y_tab               UNAPIGEN.NUM_TABLE_TYPE;
l_initme_reanalysis_tab              UNAPIGEN.NUM_TABLE_TYPE;
l_initme_me_class_tab                UNAPIGEN.VC2_TABLE_TYPE;
l_initme_log_hs_tab                  UNAPIGEN.CHAR1_TABLE_TYPE;
l_initme_log_hs_details_tab          UNAPIGEN.CHAR1_TABLE_TYPE;
l_initme_lc_tab                      UNAPIGEN.VC2_TABLE_TYPE;
l_initme_lc_version_tab              UNAPIGEN.VC20_TABLE_TYPE;
l_initme_nr_of_rows                  NUMBER;

CURSOR l_mtdescription_cursor (a_description IN VARCHAR2,
                               a_mt_version  IN VARCHAR2) IS
   SELECT mt
   FROM utmt
   WHERE description = a_description
   AND NVL(version, '0') = NVL(a_mt_version, NVL(version, '0'));

CURSOR l_slashpg_cursor (a_sc IN VARCHAR2) IS
   SELECT pgnode
   FROM utscpg
   WHERE sc = a_sc
   AND pg = '/';

CURSOR l_slashpa_cursor (a_sc IN VARCHAR2, a_pg IN VARCHAR2 , a_pgnode NUMBER) IS
   SELECT panode
   FROM utscpa
   WHERE sc = a_sc
   AND pg = a_pg
   AND pgnode = a_pgnode
   AND pa = '/';

   FUNCTION ChangeScMeStatusOrCancel
    (a_sc                IN      VARCHAR2,     /* VC20_TYPE */
     a_pg                IN      VARCHAR2,     /* VC20_TYPE */
     a_pgnode            IN      NUMBER,       /* LONG_TYPE */
     a_pa                IN      VARCHAR2,     /* VC20_TYPE */
     a_panode            IN      NUMBER,       /* LONG_TYPE */
     a_me                IN      VARCHAR2,     /* VC20_TYPE */
     a_menode            IN      NUMBER,       /* LONG_TYPE */
     a_new_ss            IN      VARCHAR2,     /* VC2_TYPE */
     a_modify_reason     IN      VARCHAR2)     /* VC255_TYPE */
   RETURN NUMBER
   IS

   l_ret_code                    INTEGER;
   --Specific local variables for ChangeScMeSs and CancelScMe
   l_old_ss                      VARCHAR2(2);
   l_lc                          VARCHAR2(2);
   l_lc_version                  VARCHAR2(20);

   --Specific local variables for InsertEvent
   l_seq_nr                      NUMBER;
   l_mt_version                  VARCHAR2(20);
   l_reanalysis                  NUMBER(3);

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

   SELECT mt_version, reanalysis
   INTO l_mt_version, l_reanalysis
   FROM utscme
   WHERE sc = a_sc
   AND pg = a_pg
   AND pgnode = a_pgnode
   AND pa = a_pa
   AND panode = a_panode
   AND me = a_me
   AND menode = a_menode;

   IF a_new_ss <> '@C' THEN
      l_ret_code := UNAPIMEP.ChangeScMeStatus (a_sc, a_pg, a_pgnode, a_pa, a_panode, a_me, a_menode, l_reanalysis, l_old_ss, a_new_ss, l_lc, l_lc_version, a_modify_reason);

      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         ChangeScMeStatus ret_code='||l_ret_code||
                                '#sc='||a_sc||'#pg='||a_pg||'#pgnode='||a_pgnode);
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         #pa='||a_pa||'#panode='||a_panode);
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         #me='||a_me||'#menode='||a_menode);
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         #old_ss='||l_old_ss||'#new_ss='||a_new_ss);
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         #lc='||l_lc||'#lc_version='||l_lc_version);
   ELSIF a_new_ss = '@C' THEN
      l_ret_code := UNAPIMEP.CancelScMe (a_sc, a_pg, a_pgnode, a_pa, a_panode, a_me, a_menode, l_reanalysis, a_modify_reason);
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         CancelScMe ret_code='||l_ret_code||
                                '#sc='||a_sc||'#pg='||a_pg||'#pgnode='||a_pgnode);
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         #pa='||a_pa||'#panode='||a_panode);
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         #me='||a_me||'#menode='||a_menode);
   END IF;
   IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NORMAL,'         CancelScMe/ChSsScMe failed:ret_code='||l_ret_code||
                                '#sc='||a_sc||'#pg='||a_pg||'#pgnode='||a_pgnode);
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         #pa='||a_pa||'#panode='||a_panode);
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         #me='||a_me||'#menode='||a_menode
                                ||'. Event will be sent instead.');
      IF UNAPIAUT.P_NOT_AUTHORISED IS NOT NULL THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NORMAL,'         Authorisation error='||UNAPIAUT.P_NOT_AUTHORISED);
      END IF;
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_SUCCESS; --to be sure that no rollback is taking place on EndTransaction
      --InsertEvent MethodUpdated with ss_to=<new status>
      l_seq_nr := NULL;
      l_ret_code := UNAPIEV.InsertEvent
                      (a_api_name          => 'ChangeScMeStatusOrCancel',
                       a_evmgr_name        => UNAPIGEN.P_EVMGR_NAME,
                       a_object_tp         => 'me',
                       a_object_id         => a_me,
                       a_object_lc         => NULL,
                       a_object_lc_version => NULL,
                       a_object_ss         => NULL,
                       a_ev_tp             => 'MethodUpdated',
                       a_ev_details        => 'sc='||a_sc||
                                              '#pg='||a_pg||'#pgnode='||a_pgnode||
                                              '#pa='||a_pa||'#panode='||a_panode||
                                              '#menode='||a_menode||
                                              '#mt_version='||l_mt_version||'#ss_to='||a_new_ss,
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
   END ChangeScMeStatusOrCancel;

BEGIN

   l_ret_code := UNAPIGEN.DBERR_SUCCESS;
   --Multiple API calls are performed in this section
   --A transaction is started when necessary
   IF UNAPIGEN.P_TXN_LEVEL = 0 THEN
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Starting implicit transaction');
      l_return := UNAPIGEN.BeginTransaction;
      IF l_return <> UNAPIGEN.DBERR_SUCCESS THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_HIGH,'         UNAPIGEN.BeginTransaction failed ! ret_code='||TO_CHAR(l_return));
      END IF;
      l_internal_transaction := TRUE;
   ELSE
      l_internal_transaction := FALSE;
   END IF;

   --1. sc validation
   IF UNICONNECT.P_ME_SC IS NULL THEN
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : sample is mandatory for [me] section !');
      l_ret_code := UNAPIGEN.DBERR_NOPARENTOBJECT;
      RAISE StpError;
   END IF;

   --2. sc modified in [me] section ?
   --    NO    set global variable SC
   --    YES   verify if provided sample code exist :error when not + set global variable SC
   --    Copy sc in savescme... array
   IF UNICONNECT.P_GLOB_SC <> UNICONNECT.P_ME_SC THEN
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Sc directly searched:'||UNICONNECT.P_ME_SC);
      OPEN l_sc_cursor(UNICONNECT.P_ME_SC);
      FETCH l_sc_cursor
      INTO l_sc;
      CLOSE l_sc_cursor;
      IF l_sc IS NULL THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : sc does not exist ! sc is mandatory for [me] section !');
         l_ret_code := UNAPIGEN.DBERR_NOPARENTOBJECT;
         RAISE StpError;
      END IF;
      UNICONNECT.P_GLOB_SC := UNICONNECT.P_ME_SC;
   ELSE
      UNICONNECT.P_GLOB_SC := UNICONNECT.P_ME_SC;
   END IF;

   FOR l_row IN 1..UNICONNECT.P_ME_NR_OF_ROWS LOOP
      UNICONNECT.P_ME_SC_TAB(l_row) := UNICONNECT.P_GLOB_SC;
   END LOOP;

   -- suppressed due to a change request on 16/09/1999 (pg/pgnode are nomore mandatory)
   --
   --3. pg=NULL ?
   --   NO OK
   --   YES   Major error : me section without pg specified in a preceding section
   --IF UNICONNECT.P_ME_PG IS NULL AND
   --   UNICONNECT.P_ME_PGDESCRIPTION IS NULL THEN
   --   UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : pg is mandatory for [me] section !');
   --   RETURN(UNAPIGEN.DBERR_NOPARENTOBJECT);
   --END IF;

   --4. pg or pgnode modified in [me] section
   --   NO set global varaibles PG and PGNODE
   --   YES   verify if provided pg exist :error when not + set global variable PG and PGNODE
   --      PAY attention the pg[x],pg[] and .description are supported in this case
   --   Copy PG and PGNODE in savescme... array
   IF UNICONNECT.P_ME_PGNAME IS NOT NULL THEN

      --description used ? -> find pp in utpp
      l_variable_name := NVL(UNICONNECT.P_ME_PGNAME, 'pg');
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
            l_pg_rec_found := UNICONNECT2.FindScPg(UNICONNECT.P_GLOB_SC,
                                       UNICONNECT.P_ME_PG, UNICONNECT.P_ME_PGDESCRIPTION,
                                       UNICONNECT.P_ME_PGNODE,
                                       UNICONNECT.P_ME_PP_KEY1, UNICONNECT.P_ME_PP_KEY2, UNICONNECT.P_ME_PP_KEY3, UNICONNECT.P_ME_PP_KEY4, UNICONNECT.P_ME_PP_KEY5,
                                       UNICONNECT.P_ME_PP_VERSION,
                                       'pg',        1, NULL);
         ELSE
            --pg.description used
            --passed pp_keys left blank since pgnode is mostly fixed at this point
            l_pg_rec_found := UNICONNECT2.FindScPg(UNICONNECT.P_GLOB_SC,
                                       UNICONNECT.P_ME_PG, UNICONNECT.P_ME_PGDESCRIPTION,
                                       UNICONNECT.P_ME_PGNODE,
                                       UNICONNECT.P_ME_PP_KEY1, UNICONNECT.P_ME_PP_KEY2, UNICONNECT.P_ME_PP_KEY3, UNICONNECT.P_ME_PP_KEY4, UNICONNECT.P_ME_PP_KEY5,
                                       UNICONNECT.P_ME_PP_VERSION,
                                       'description',       1, NULL);
         END IF;
      ELSE
         IF l_description_pos = 0 THEN
            --pg[x] or pg[x].pg used
            --passed pp_keys left blank since pgnode is mostly fixed at this point
            l_pg_rec_found := UNICONNECT2.FindScPg(UNICONNECT.P_GLOB_SC,
                                       UNICONNECT.P_ME_PG, UNICONNECT.P_ME_PGDESCRIPTION,
                                       UNICONNECT.P_ME_PGNODE,
                                       UNICONNECT.P_ME_PP_KEY1, UNICONNECT.P_ME_PP_KEY2, UNICONNECT.P_ME_PP_KEY3, UNICONNECT.P_ME_PP_KEY4, UNICONNECT.P_ME_PP_KEY5,
                                       UNICONNECT.P_ME_PP_VERSION,
                                       'pg', l_pg_pos, NULL);
         ELSE
            --pg[x].description used
            --passed pp_keys left blank since pgnode is mostly fixed at this point
            l_pg_rec_found := UNICONNECT2.FindScPg(UNICONNECT.P_GLOB_SC,
                                       UNICONNECT.P_ME_PG, UNICONNECT.P_ME_PGDESCRIPTION,
                                       UNICONNECT.P_ME_PGNODE,
                                       UNICONNECT.P_ME_PP_KEY1, UNICONNECT.P_ME_PP_KEY2, UNICONNECT.P_ME_PP_KEY3, UNICONNECT.P_ME_PP_KEY4, UNICONNECT.P_ME_PP_KEY5,
                                       UNICONNECT.P_ME_PP_VERSION,
                                       'description', l_pg_pos, NULL);
         END IF;
      END IF;

      IF l_pg_rec_found.pgnode IS NOT NULL THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         pg found:pg='||l_pg_rec_found.pg||'#pgnode='||l_pg_rec_found.pgnode);
         UNICONNECT.P_GLOB_PG := l_pg_rec_found.pg;
         UNICONNECT.P_GLOB_PGNODE := l_pg_rec_found.pgnode;
      ELSE
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NORMAL,'         Section skipped : pg not found ! pg is optional for [me] section !');
         l_ret_code := UNAPIGEN.DBERR_SUCCESS;
         RAISE StpError;
      END IF;

   ELSE
      UNICONNECT.P_GLOB_PG := UNICONNECT.P_ME_PG;
      UNICONNECT.P_GLOB_PGNODE := UNICONNECT.P_ME_PGNODE;
   END IF;

   FOR l_row IN 1..UNICONNECT.P_ME_NR_OF_ROWS LOOP
      UNICONNECT.P_ME_PG_TAB(l_row) := UNICONNECT.P_GLOB_PG;
      UNICONNECT.P_ME_PGNODE_TAB(l_row) := UNICONNECT.P_GLOB_PGNODE;
   END LOOP;

   -- suppressed due to a change request on 16/09/1999 (pg/pgnode are nomore mandatory)
   --
   --5. pa=NULL ?
   --   NO OK
   --   YES   Major error : me section without pa specified in a preceding section
   --IF UNICONNECT.P_ME_PA IS NULL AND
   --   UNICONNECT.P_ME_PADESCRIPTION IS NULL THEN
   --   UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : pa is mandatory for [me] section !');
   --   RETURN(UNAPIGEN.DBERR_NOPARENTOBJECT);
   --END IF;

   --6. pa or panode modified in [me] section
   --   NO set global variables PA and PANODE
   --   YES   verify if provided pa exist :error when not + set global variable PA and PANODE
   --      PAY attention the pa[x],pa[] and .description are supported in this case
   --   Copy PA and PANODE in savescme... array
   IF UNICONNECT.P_ME_PANAME IS NOT NULL THEN

      --description used ? -> find pr in utpr
      l_variable_name := NVL(UNICONNECT.P_ME_PANAME, 'pa');
      l_description_pos := INSTR(l_variable_name, '.description');
      l_openbrackets_pos := INSTR(l_variable_name, '[');
      l_closebrackets_pos := INSTR(l_variable_name, ']');
      l_pa_pos := TO_NUMBER(SUBSTR(l_variable_name,l_openbrackets_pos+1,l_closebrackets_pos-l_openbrackets_pos-1));

      UNICONNECT.P_PA_NR_OF_ROWS := 0; --to be sure pa arrays are not searched
      l_pa_rec_found := NULL;

      IF l_openbrackets_pos = 0 THEN
         IF l_description_pos = 0 THEN
            --pa or pa.pa used
            l_pa_rec_found := UNICONNECT2.FindScPa(UNICONNECT.P_GLOB_SC,
                                       UNICONNECT.P_GLOB_PG, UNICONNECT.P_GLOB_PGNODE,
                                       UNICONNECT.P_ME_PP_KEY1, UNICONNECT.P_ME_PP_KEY2, UNICONNECT.P_ME_PP_KEY3, UNICONNECT.P_ME_PP_KEY4, UNICONNECT.P_ME_PP_KEY5,
                                       UNICONNECT.P_ME_PP_VERSION,
                                       UNICONNECT.P_ME_PA, UNICONNECT.P_ME_PADESCRIPTION,
                                       UNICONNECT.P_ME_PANODE, UNICONNECT.P_ME_PR_VERSION,
                                               'pa',         1, NULL);
         ELSE
            --pa.description used
            l_pa_rec_found := UNICONNECT2.FindScPa(UNICONNECT.P_GLOB_SC,
                                       UNICONNECT.P_GLOB_PG, UNICONNECT.P_GLOB_PGNODE,
                                       UNICONNECT.P_ME_PP_KEY1, UNICONNECT.P_ME_PP_KEY2, UNICONNECT.P_ME_PP_KEY3, UNICONNECT.P_ME_PP_KEY4, UNICONNECT.P_ME_PP_KEY5,
                                       UNICONNECT.P_ME_PP_VERSION,
                                       UNICONNECT.P_ME_PA, UNICONNECT.P_ME_PADESCRIPTION,
                                       UNICONNECT.P_ME_PANODE, UNICONNECT.P_ME_PR_VERSION,
                                       'description',        1, NULL);
         END IF;
      ELSE
         IF l_description_pos = 0 THEN
            --pa[x] or pa[x].pa used
            l_pa_rec_found := UNICONNECT2.FindScPa(UNICONNECT.P_GLOB_SC,
                                       UNICONNECT.P_GLOB_PG, UNICONNECT.P_GLOB_PGNODE,
                                       UNICONNECT.P_ME_PP_KEY1, UNICONNECT.P_ME_PP_KEY2, UNICONNECT.P_ME_PP_KEY3, UNICONNECT.P_ME_PP_KEY4, UNICONNECT.P_ME_PP_KEY5,
                                       UNICONNECT.P_ME_PP_VERSION,
                                       UNICONNECT.P_ME_PA, UNICONNECT.P_ME_PADESCRIPTION,
                                       UNICONNECT.P_ME_PANODE, UNICONNECT.P_ME_PR_VERSION,
                                                'pa', l_pa_pos, NULL);
         ELSE
            --pa[x].description used
            l_pa_rec_found := UNICONNECT2.FindScPa(UNICONNECT.P_GLOB_SC,
                                       UNICONNECT.P_GLOB_PG, UNICONNECT.P_GLOB_PGNODE,
                                       UNICONNECT.P_ME_PP_KEY1, UNICONNECT.P_ME_PP_KEY2, UNICONNECT.P_ME_PP_KEY3, UNICONNECT.P_ME_PP_KEY4, UNICONNECT.P_ME_PP_KEY5,
                                       UNICONNECT.P_ME_PP_VERSION,
                                       UNICONNECT.P_ME_PA, UNICONNECT.P_ME_PADESCRIPTION,
                                       UNICONNECT.P_ME_PANODE, UNICONNECT.P_ME_PR_VERSION,
                                       'description', l_pa_pos, NULL);
         END IF;
      END IF;

      IF l_pa_rec_found.panode IS NOT NULL THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         pa found:pa='||l_pa_rec_found.pa||'#panode='||l_pa_rec_found.panode);
         UNICONNECT.P_GLOB_PA := l_pa_rec_found.pa;
         UNICONNECT.P_GLOB_PANODE := l_pa_rec_found.panode;
      ELSE
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NORMAL,'         Section skipped : pa not found ! pa is optional for [me] section !');
         l_ret_code := UNAPIGEN.DBERR_SUCCESS;
         RAISE StpError;
      END IF;

   ELSE
      UNICONNECT.P_GLOB_PA := UNICONNECT.P_ME_PA;
      UNICONNECT.P_GLOB_PANODE := UNICONNECT.P_ME_PANODE;
   END IF;

   FOR l_row IN 1..UNICONNECT.P_ME_NR_OF_ROWS LOOP
      UNICONNECT.P_ME_PA_TAB(l_row) := UNICONNECT.P_GLOB_PA;
      UNICONNECT.P_ME_PANODE_TAB(l_row) := UNICONNECT.P_GLOB_PANODE;
   END LOOP;

   --7. any me specified ?
   --   YES   do nothing
   --   NO Major error : me is mandatory in a [me] section
   IF UNICONNECT.P_ME_NR_OF_ROWS = 0 THEN
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : me is mandatory for [me] section !');
      l_ret_code := UNAPIGEN.DBERR_NOOBJID;
      RAISE StpError;
   END IF;

   --8. create_me ?
   --   Y|INSERT|INSERT_WITH_NODES
   --      LOOP through all me array
   --         me[] notation will not be ignored
   --         menode will not be checked (Save api will return an error when not NULL)
   --         me.description used ?
   --         YES   me.description => find corresponding me description in utmt and fill in corresponding me
   --         NO use me or me.me directly

   --         global variable PG is NULL and not already initialised to / in savescme array?
   --         NO do nothing
   --         YES   pg / already exist for SC ?
   --            YES   set PG and PGNODE with record found in SaveScMe Array
   --            NO set PG=/ and PGNODE=0 in SaveScMeArray
   --            DON'T SET PG AND PGNODE global variables
   --         global variable PA is NULL and not already initialised to / in savescme array?
   --         NO do nothing
   --         YES   pa / already exist for SC/PG/PGNODE ?
   --            YES   set PA and PANODE with record found in SaveScMe Array
   --            NO set PA=/ and PANODE=0 in SaveScMeArray
   --            DON'T SET PA AND PANODE global variables

   --         Set modify flag to MOD_FLAG_CREATE|MOD_FLAG_INSERT|MOD_FLAG_INSERT_WITH_NODES
   --         Section setting for menode is erased when MOD_FLAG_CREATE|MOD_FLAG_INSERT are used
   --      END LOOP
   --   N|W
   --      LOOP through all me array
   --         me[x] syntax used and/or description syntax used ?
   --            YES   find corresponding menode (find xth me for this SC,PG,PGNODE,PA,PANODE and this me order by menode ASC)
   --               me[] => find the first me which is not executed (ended)
   --               Pay attention : me can already being used for saving another me with the same name
   --            NO use the first me with this name (ORDER BY menode)
   --         me not found AND pgnode/panode not specified in the section AND pg/pa specified in the [me] section ?
   --             NO continue
   --             YES no specific position specified for the pg/pa (pg[x]/pa[x] or pg[]/pa[] syntax not used)
   --                 search back to me but without specifying a specific pgnode/panode
   --                 me found ?
   --                 NO continue
   --                 YES   set global variables PGNODE,PANODE
   --                       Copy PGNODE/PANODE in savescme... array
   --
   --         me found ?
   --            YES
   --               Result modified in section AND result already present AND allow_reanalysis = N ?
   --                  YES   Major error : no reanalysis authorised
   --                  NO    Call ReanalScMethod
   --               set modify flag to UNAPIGEN.DBERR_SUCCESS
   --               set the node correctly for correct node numbering
   --               Initialise SaveScMe... array variables with the values coming
   --               from the record or from the section
   --                       (Values from the section will overrule the value from the record)
   --               Initialise the pg/pgnode/pa/panode from the record since these are not mandatory in the section
   --            NO
   --               create_me ?
   --               N
   --                  Major error
   --               W
   --                 use / pg and / pa when not specified in section or use pg according to found pa
   --                 global variable PG is NULL and not already initialised to / in savescme array?
   --                 NO do nothing
   --                 YES pa record has been found ?
   --                     YES use that record to create the method
   --                     NO pg / already exist for SC ?
   --                        YES   set PG and PGNODE with record found in SaveScMe Array
   --                        NO set PG=/ and PGNODE=0 in SaveScMeArray
   --                        DON'T SET PG AND PGNODE global variables
   --                  global variable PA is NULL and not already initialised to / in savescme array?
   --                  NO do nothing
   --                  YES   pa / already exist for SC/PG/PGNODE ?
   --                     YES   set PA and PANODE with record found in SaveScMe Array
   --                     NO set PA=/ and PANODE=0 in SaveScMeArray
   --                     DON'T SET PA AND PANODE global variables
   --                  Set modify flag to UNAPIGEN.MOD_FLAG_CREATE
   --                  Set node to NULL
   --      END LOOP
   l_slashpg_searched := FALSE;
   l_slashpg_pgnode := NULL;
   l_slashpa_searched := FALSE;
   l_slashpa_panode := NULL;
   IF UNICONNECT.P_SET_CREATE_ME IN ('Y', 'INSERT', 'INSERT_WITH_NODES') THEN
      FOR l_row IN 1..UNICONNECT.P_ME_NR_OF_ROWS LOOP

         --description used ? -> find mt in utmt
         l_variable_name := UNICONNECT.P_ME_MENAME_TAB(l_row);
         l_description_pos := INSTR(l_variable_name, '.description');
         IF l_description_pos > 0 THEN
            OPEN l_mtdescription_cursor(UNICONNECT.P_ME_MEDESCRIPTION_TAB(l_row),
                                        UNICONNECT.P_ME_MT_VERSION_TAB(l_row));
            FETCH l_mtdescription_cursor
            INTO l_mt;
            IF l_mtdescription_cursor%NOTFOUND THEN
               --Major error no corresponding mt found
               CLOSE l_mtdescription_cursor;
               UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : no corresponding mt for description '||UNICONNECT.P_ME_MEDESCRIPTION_TAB(l_row));
               l_ret_code := UNAPIGEN.DBERR_NOOBJID;
               RAISE StpError;
            END IF;
            CLOSE l_mtdescription_cursor;
            UNICONNECT.P_ME_ME_TAB(l_row) := l_mt;
         END IF;

         -- global variable PG is NULL and not already initialised to / in savescme array?
         -- NO do nothing
         -- YES   pg / already exist for SC ?
         --    YES   set PG and PGNODE with record found in SaveScMe Array
         --    NO set PG=/ and PGNODE=0 in SaveScMeArray
         --    DON'T SET PG AND PGNODE global variables
         IF UNICONNECT.P_GLOB_PG IS NULL THEN
            IF UNICONNECT.P_ME_PG_TAB(l_row) IS NULL THEN
               IF l_slashpg_searched = FALSE THEN
                  OPEN l_slashpg_cursor(UNICONNECT.P_GLOB_SC);
                  FETCH l_slashpg_cursor
                  INTO l_slashpg_pgnode;
                  CLOSE l_slashpg_cursor;
                  l_slashpg_searched := TRUE;
                  UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW, '         Slash pg searched '||NVL(TO_CHAR(l_slashpg_pgnode),'NOT FOUND'));
               END IF;

               IF l_slashpg_pgnode IS NOT NULL THEN
                  UNICONNECT.P_ME_PG_TAB(l_row)         := '/';
                  UNICONNECT.P_ME_PGNODE_TAB(l_row)     := l_slashpg_pgnode;
               ELSE
                  UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Slash pg not found, will be created ');
                  l_ret_code := UNICONNECT6.InsertPg(UNICONNECT.P_GLOB_SC,
                                                     '/',
                                                     TRUE,
                                                     l_slashpg_pgnode);
                  IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
                     UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : InsertFirstPg eturned '||l_ret_code);
                     RAISE StpError;
                  END IF;

                  UNICONNECT.P_ME_PG_TAB(l_row)         := '/';
                  UNICONNECT.P_ME_PGNODE_TAB(l_row)     := l_slashpg_pgnode;
                  l_slashpg_searched := TRUE;
               END IF;
            END IF;
         END IF;

         -- global variable PA is NULL and not already initialised to / in savescme array?
         -- NO do nothing
         -- YES   pa / already exist for SC/PG/PGNODE ?
         --    YES   set PA and PANODE with record found in SaveScMe Array
         --    NO set PA=/ and PANODE=0 in SaveScMeArray
         --    DON'T SET PA AND PANODE global variables
         IF UNICONNECT.P_GLOB_PA IS NULL THEN
            IF UNICONNECT.P_ME_PA_TAB(l_row) IS NULL THEN
               IF l_slashpa_searched = FALSE THEN
                  OPEN l_slashpa_cursor(UNICONNECT.P_GLOB_SC,
                                        NVL(UNICONNECT.P_GLOB_PG,'/'),
                                        NVL(UNICONNECT.P_GLOB_PGNODE,l_slashpg_pgnode));
                  FETCH l_slashpa_cursor
                  INTO l_slashpa_panode;
                  CLOSE l_slashpa_cursor;
                  l_slashpa_searched := TRUE;
                  UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Slash pa searched '||NVL(TO_CHAR(l_slashpa_panode),'NOT FOUND'));
               END IF;

               IF l_slashpa_panode IS NOT NULL THEN
                  UNICONNECT.P_ME_PA_TAB(l_row)         := '/';
                  UNICONNECT.P_ME_PANODE_TAB(l_row)     := l_slashpa_panode;
               ELSE
                  UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Slash pa not found, will be created ');
                  l_ret_code := UNICONNECT6.InsertPa(UNICONNECT.P_GLOB_SC,
                                                     NVL(UNICONNECT.P_GLOB_PG,'/'),
                                                     NVL(UNICONNECT.P_GLOB_PGNODE,l_slashpg_pgnode),
                                                     '/',
                                                     TRUE,
                                                     l_slashpa_panode);
                  IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
                     UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : InsertFirstPa eturned '||l_ret_code);
                     RAISE StpError;
                  END IF;
                  UNICONNECT.P_ME_PA_TAB(l_row)         := '/';
                  UNICONNECT.P_ME_PANODE_TAB(l_row)     := l_slashpa_panode;
                  l_slashpa_searched := TRUE;
               END IF;
            END IF;
         END IF;

         --Set modify flag to MOD_FLAG_CREATE|MOD_FLAG_INSERT|MOD_FLAG_INSERT_WITH_NODES
         --Section setting for menode is erased when MOD_FLAG_CREATE|MOD_FLAG_INSERT are used
         UNICONNECT.P_ME_USE_SAVESCMERESULT := FALSE;
         IF UNICONNECT.P_SET_CREATE_ME = 'INSERT' THEN
            UNICONNECT.P_ME_MODIFY_FLAG_TAB(l_row) := UNAPIGEN.MOD_FLAG_INSERT;
            UNICONNECT.P_ME_MENODE_TAB(l_row) := NULL;
         ELSIF UNICONNECT.P_SET_CREATE_ME = 'INSERT_WITH_NODES' THEN
            UNICONNECT.P_ME_MODIFY_FLAG_TAB(l_row) := UNAPIGEN.MOD_FLAG_INSERT_WITH_NODES;
         ELSE
            UNICONNECT.P_ME_MODIFY_FLAG_TAB(l_row) := UNAPIGEN.MOD_FLAG_CREATE;
            UNICONNECT.P_ME_MENODE_TAB(l_row) := NULL;
         END IF;

      END LOOP;
   ELSE

      FOR l_row IN 1..UNICONNECT.P_ME_NR_OF_ROWS LOOP

         --description used ? -> find mt in utmt
         l_variable_name := UNICONNECT.P_ME_MENAME_TAB(l_row);
         l_description_pos := INSTR(l_variable_name, '.description');
         l_openbrackets_pos := INSTR(l_variable_name, '[');
         l_closebrackets_pos := INSTR(l_variable_name, ']');
         l_me_pos := TO_NUMBER(SUBSTR(l_variable_name,l_openbrackets_pos+1,l_closebrackets_pos-l_openbrackets_pos-1));

         l_me_rec_found := NULL;

         IF l_openbrackets_pos = 0 THEN
            IF l_description_pos = 0 THEN
               --me or me.me used
               l_me_rec_found := FindScMe(UNICONNECT.P_GLOB_SC,
                                          UNICONNECT.P_GLOB_PG, UNICONNECT.P_GLOB_PGNODE,
                                          UNICONNECT.P_ME_PP_KEY1, UNICONNECT.P_ME_PP_KEY2, UNICONNECT.P_ME_PP_KEY3, UNICONNECT.P_ME_PP_KEY4, UNICONNECT.P_ME_PP_KEY5,
                                          UNICONNECT.P_ME_PP_VERSION,
                                          UNICONNECT.P_GLOB_PA, UNICONNECT.P_GLOB_PANODE,
                                          UNICONNECT.P_ME_PR_VERSION,
                                          UNICONNECT.P_ME_ME_TAB(l_row), UNICONNECT.P_ME_MEDESCRIPTION_TAB(l_row),
                                          UNICONNECT.P_ME_MENODE_TAB(l_row), UNICONNECT.P_ME_MT_VERSION_TAB(l_row),
                                                   'me',        1, l_row);
            ELSE
               --me.description used
               l_me_rec_found := FindScMe(UNICONNECT.P_GLOB_SC,
                                          UNICONNECT.P_GLOB_PG, UNICONNECT.P_GLOB_PGNODE,
                                          UNICONNECT.P_ME_PP_KEY1, UNICONNECT.P_ME_PP_KEY2, UNICONNECT.P_ME_PP_KEY3, UNICONNECT.P_ME_PP_KEY4, UNICONNECT.P_ME_PP_KEY5,
                                          UNICONNECT.P_ME_PP_VERSION,
                                          UNICONNECT.P_GLOB_PA, UNICONNECT.P_GLOB_PANODE,
                                          UNICONNECT.P_ME_PR_VERSION,
                                          UNICONNECT.P_ME_ME_TAB(l_row), UNICONNECT.P_ME_MEDESCRIPTION_TAB(l_row),
                                          UNICONNECT.P_ME_MENODE_TAB(l_row), UNICONNECT.P_ME_MT_VERSION_TAB(l_row),
                                          'description',        1, l_row);
            END IF;
         ELSE
            IF l_description_pos = 0 THEN
               --me[x] or me[x].me used
               l_me_rec_found := FindScMe(UNICONNECT.P_GLOB_SC,
                                          UNICONNECT.P_GLOB_PG, UNICONNECT.P_GLOB_PGNODE,
                                          UNICONNECT.P_ME_PP_KEY1, UNICONNECT.P_ME_PP_KEY2, UNICONNECT.P_ME_PP_KEY3, UNICONNECT.P_ME_PP_KEY4, UNICONNECT.P_ME_PP_KEY5,
                                          UNICONNECT.P_ME_PP_VERSION,
                                          UNICONNECT.P_GLOB_PA, UNICONNECT.P_GLOB_PANODE,
                                          UNICONNECT.P_ME_PR_VERSION,
                                          UNICONNECT.P_ME_ME_TAB(l_row), UNICONNECT.P_ME_MEDESCRIPTION_TAB(l_row),
                                          UNICONNECT.P_ME_MENODE_TAB(l_row), UNICONNECT.P_ME_MT_VERSION_TAB(l_row),
                                                   'me', l_me_pos, l_row);
            ELSE
               --pg[x].description used
               l_me_rec_found := FindScMe(UNICONNECT.P_GLOB_SC,
                                          UNICONNECT.P_GLOB_PG, UNICONNECT.P_GLOB_PGNODE,
                                          UNICONNECT.P_ME_PP_KEY1, UNICONNECT.P_ME_PP_KEY2, UNICONNECT.P_ME_PP_KEY3, UNICONNECT.P_ME_PP_KEY4, UNICONNECT.P_ME_PP_KEY5,
                                          UNICONNECT.P_ME_PP_VERSION,
                                          UNICONNECT.P_GLOB_PA, UNICONNECT.P_GLOB_PANODE,
                                          UNICONNECT.P_ME_PR_VERSION,
                                          UNICONNECT.P_ME_ME_TAB(l_row), UNICONNECT.P_ME_MEDESCRIPTION_TAB(l_row),
                                          UNICONNECT.P_ME_MENODE_TAB(l_row), UNICONNECT.P_ME_MT_VERSION_TAB(l_row),
                                          'description', l_me_pos, l_row);
            END IF;
         END IF;

         -- me not found AND pgnode/panode not specified in the section AND pg/pa specified in the [me] section ?
         --    NO continue
         --    YES no specific position specified for the pg/pa (pg[x]/pa[x] or pg[]/pa[] syntax not used)
         --       search back to me but without specifying a specific pgnode/panode
         --       me found ?
         --       NO continue
         --       YES   set global variables PGNODE,PANODE
         --             Copy PGNODE/PANODE in savescme... array
         --
         IF l_me_rec_found.menode IS NULL AND
            p_me_pgnode_setinsection = FALSE AND
            p_me_panode_setinsection = FALSE AND
            UNICONNECT.P_ME_PGNAME IS NOT NULL  AND
            UNICONNECT.P_ME_PANAME IS NOT NULL AND
            INSTR(UNICONNECT.P_ME_PGNAME, '[') = 0 AND
            INSTR(UNICONNECT.P_ME_PANAME, '[') = 0 THEN
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         me not found in current pa, will try to find it in another pa with the same name');
            IF l_openbrackets_pos = 0 THEN
               IF l_description_pos = 0 THEN
                  --me or me.me used
                  l_me_rec_found := FindScMe(UNICONNECT.P_GLOB_SC,
                                             UNICONNECT.P_GLOB_PG, NULL,
                                             UNICONNECT.P_ME_PP_KEY1, UNICONNECT.P_ME_PP_KEY2, UNICONNECT.P_ME_PP_KEY3, UNICONNECT.P_ME_PP_KEY4, UNICONNECT.P_ME_PP_KEY5,
                                             UNICONNECT.P_ME_PP_VERSION,
                                             UNICONNECT.P_GLOB_PA, NULL,
                                             UNICONNECT.P_ME_PR_VERSION,
                                             UNICONNECT.P_ME_ME_TAB(l_row), UNICONNECT.P_ME_MEDESCRIPTION_TAB(l_row),
                                             UNICONNECT.P_ME_MENODE_TAB(l_row), UNICONNECT.P_ME_MT_VERSION_TAB(l_row),
                                                     'me',        1, l_row);
               ELSE
                  --me.description used
                  l_me_rec_found := FindScMe(UNICONNECT.P_GLOB_SC,
                                             UNICONNECT.P_GLOB_PG, NULL,
                                             UNICONNECT.P_ME_PP_KEY1, UNICONNECT.P_ME_PP_KEY2, UNICONNECT.P_ME_PP_KEY3, UNICONNECT.P_ME_PP_KEY4, UNICONNECT.P_ME_PP_KEY5,
                                             UNICONNECT.P_ME_PP_VERSION,
                                             UNICONNECT.P_GLOB_PA, NULL,
                                             UNICONNECT.P_ME_PR_VERSION,
                                             UNICONNECT.P_ME_ME_TAB(l_row), UNICONNECT.P_ME_MEDESCRIPTION_TAB(l_row),
                                             UNICONNECT.P_ME_MENODE_TAB(l_row), UNICONNECT.P_ME_MT_VERSION_TAB(l_row),
                                             'description',        1, l_row);
               END IF;
            ELSE
               IF l_description_pos = 0 THEN
                  --me[x] or me[x].me used
                  l_me_rec_found := FindScMe(UNICONNECT.P_GLOB_SC,
                                             UNICONNECT.P_GLOB_PG, NULL,
                                             UNICONNECT.P_ME_PP_KEY1, UNICONNECT.P_ME_PP_KEY2, UNICONNECT.P_ME_PP_KEY3, UNICONNECT.P_ME_PP_KEY4, UNICONNECT.P_ME_PP_KEY5,
                                             UNICONNECT.P_ME_PP_VERSION,
                                             UNICONNECT.P_GLOB_PA, NULL,
                                             UNICONNECT.P_ME_PR_VERSION,
                                             UNICONNECT.P_ME_ME_TAB(l_row), UNICONNECT.P_ME_MEDESCRIPTION_TAB(l_row),
                                             UNICONNECT.P_ME_MENODE_TAB(l_row), UNICONNECT.P_ME_MT_VERSION_TAB(l_row),
                                                      'me', l_me_pos, l_row);
               ELSE
                  --me[x].description used
                  l_me_rec_found := FindScMe(UNICONNECT.P_GLOB_SC,
                                             UNICONNECT.P_GLOB_PG, NULL,
                                             UNICONNECT.P_ME_PP_KEY1, UNICONNECT.P_ME_PP_KEY2, UNICONNECT.P_ME_PP_KEY3, UNICONNECT.P_ME_PP_KEY4, UNICONNECT.P_ME_PP_KEY5,
                                             UNICONNECT.P_ME_PP_VERSION,
                                             UNICONNECT.P_GLOB_PA, NULL,
                                             UNICONNECT.P_ME_PR_VERSION,
                                             UNICONNECT.P_ME_ME_TAB(l_row), UNICONNECT.P_ME_MEDESCRIPTION_TAB(l_row),
                                             UNICONNECT.P_ME_MENODE_TAB(l_row), UNICONNECT.P_ME_MT_VERSION_TAB(l_row),
                                             'description', l_me_pos, l_row);
               END IF;
            END IF;

            IF l_me_rec_found.menode IS NOT NULL THEN
               UNICONNECT.P_GLOB_PGNODE := l_me_rec_found.pgnode;
               UNICONNECT.P_GLOB_PANODE := l_me_rec_found.panode;
               FOR l_row IN 1..UNICONNECT.P_ME_NR_OF_ROWS LOOP
                   UNICONNECT.P_ME_PGNODE_TAB(l_row) := UNICONNECT.P_GLOB_PGNODE;
                   UNICONNECT.P_ME_PANODE_TAB(l_row) := UNICONNECT.P_GLOB_PANODE;
               END LOOP;
            END IF;
         END IF;

         IF l_me_rec_found.menode IS NOT NULL THEN
            -- me found ?
            --    YES
            --       Result modified in section AND result already present AND allow_reanalysis = N ?
            --          YES   Major error : no reanalysis authorised
            --          NO    Call ReanalScMethod
            IF (UNICONNECT.P_ME_VALUE_F_MODTAB(l_row) OR UNICONNECT.P_ME_VALUE_S_MODTAB(l_row)) AND
               l_me_rec_found.exec_end_date IS NOT NULL THEN
               IF UNICONNECT.P_SET_ALLOW_REANALYSIS = 'N' THEN
                  UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : me already executed, new me result in [me] section AND no reanalysis authorised !');
                  l_ret_code := UNAPIGEN.DBERR_GENFAIL;
                  RAISE StpError;
               ELSE
                  UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NORMAL,'         me already executed and new me result in [me] section => me reanalysis');
                  l_ret_code := UNAPIMEP.ReanalScMethod(l_me_rec_found.sc,
                                                        l_me_rec_found.pg,
                                                        l_me_rec_found.pgnode,
                                                        l_me_rec_found.pa,
                                                        l_me_rec_found.panode,
                                                        l_me_rec_found.me,
                                                        l_me_rec_found.menode,
                                                        l_me_rec_found.reanalysis,
                                                        'Uniconnect : new result for this method');
                  IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
                     UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : ReanalScMethod failed ret_code : '||l_ret_code ||
                                                    '#sc='||l_me_rec_found.sc||
                                                    '#pg='||l_me_rec_found.pg||
                                                    '#pgnode='||l_me_rec_found.pgnode||
                                                    '#pa='||l_me_rec_found.pa||
                                                    '#panode='||l_me_rec_found.panode||
                                                    '#me='||l_me_rec_found.me||
                                                    '#menode='||l_me_rec_found.menode);
                     RAISE StpError;
                  END IF;
               END IF;
            END IF;

            --always set
            --Initialise the pg/pgnode/pa/panode from the record since these are not mandatory in the section
            UNICONNECT.P_ME_PG_TAB(l_row)                   := l_me_rec_found.pg;
            UNICONNECT.P_ME_PGNODE_TAB(l_row)               := l_me_rec_found.pgnode;
            UNICONNECT.P_ME_PA_TAB(l_row)                   := l_me_rec_found.pa;
            UNICONNECT.P_ME_PANODE_TAB(l_row)               := l_me_rec_found.panode;
            UNICONNECT.P_ME_MENODE_TAB(l_row)               := l_me_rec_found.menode;
            UNICONNECT.P_ME_REANALYSIS_TAB(l_row)           := l_me_rec_found.reanalysis;
            UNICONNECT.P_ME_MT_VERSION_TAB(l_row)           := l_me_rec_found.mt_version;
            UNICONNECT.P_ME_EQ_VERSION_TAB(l_row)           := l_me_rec_found.eq_version;
            UNICONNECT.P_ME_PLANNED_EXECUTOR_TAB(l_row)     := l_me_rec_found.planned_executor;
            UNICONNECT.P_ME_PLANNED_EQ_TAB(l_row)           := l_me_rec_found.planned_eq;
            UNICONNECT.P_ME_PLANNED_EQ_VERSION_TAB(l_row)   := l_me_rec_found.planned_eq_version;
            UNICONNECT.P_ME_ALLOW_ADD_TAB(l_row)            := l_me_rec_found.allow_add;
            UNICONNECT.P_ME_ASSIGN_DATE_TAB(l_row)          := l_me_rec_found.assign_date;
            UNICONNECT.P_ME_ASSIGNED_BY_TAB(l_row)          := l_me_rec_found.assigned_by;
            UNICONNECT.P_ME_MANUALLY_ADDED_TAB(l_row)       := l_me_rec_found.manually_added;
            UNICONNECT.P_ME_DELAY_TAB(l_row)                := l_me_rec_found.delay;
            UNICONNECT.P_ME_DELAY_UNIT_TAB(l_row)           := l_me_rec_found.delay_unit;
            UNICONNECT.P_ME_FORMAT_TAB(l_row)               := l_me_rec_found.format;
            UNICONNECT.P_ME_ACCURACY_TAB(l_row)             := l_me_rec_found.accuracy;
            UNICONNECT.P_ME_REAL_COST_TAB(l_row)            := l_me_rec_found.real_cost;
            UNICONNECT.P_ME_REAL_TIME_TAB(l_row)            := l_me_rec_found.real_time;
            UNICONNECT.P_ME_CALIBRATION_TAB(l_row)          := l_me_rec_found.calibration;
            UNICONNECT.P_ME_CONFIRM_COMPLETE_TAB(l_row)     := l_me_rec_found.confirm_complete;
            UNICONNECT.P_ME_AUTORECALC_TAB(l_row)           := l_me_rec_found.autorecalc;
            UNICONNECT.P_ME_ME_RESULT_EDITABLE_TAB(l_row)   := l_me_rec_found.me_result_editable;
            UNICONNECT.P_ME_NEXT_CELL_TAB(l_row)            := l_me_rec_found.next_cell;
            UNICONNECT.P_ME_SOP_TAB(l_row)                  := l_me_rec_found.sop;
            UNICONNECT.P_ME_SOP_VERSION_TAB(l_row)          := l_me_rec_found.sop_version;
            UNICONNECT.P_ME_PLAUS_LOW_TAB(l_row)            := l_me_rec_found.plaus_low;
            UNICONNECT.P_ME_PLAUS_HIGH_TAB(l_row)           := l_me_rec_found.plaus_high;
            UNICONNECT.P_ME_WINSIZE_X_TAB(l_row)            := l_me_rec_found.winsize_x;
            UNICONNECT.P_ME_WINSIZE_Y_TAB(l_row)            := l_me_rec_found.winsize_y;
            UNICONNECT.P_ME_ME_CLASS_TAB(l_row)             := l_me_rec_found.me_class;
            UNICONNECT.P_ME_LOG_HS_TAB(l_row)               := l_me_rec_found.log_hs;
            UNICONNECT.P_ME_LOG_HS_DETAILS_TAB(l_row)       := l_me_rec_found.log_hs_details;
            UNICONNECT.P_ME_LC_TAB(l_row)                   := l_me_rec_found.lc;
            UNICONNECT.P_ME_LC_VERSION_TAB(l_row)           := l_me_rec_found.lc_version;

            --only when not set in section
            UNICONNECT.P_ME_DESCRIPTION_TAB(l_row)      := MeUseValue('description'       , l_row, l_me_rec_found.description);
            UNICONNECT.P_ME_UNIT_TAB(l_row)             := MeUseValue('unit'              , l_row, l_me_rec_found.unit);
            UNICONNECT.P_ME_MANUALLY_ENTERED_TAB(l_row) := MeUseValue('manually_entered'  , l_row, l_me_rec_found.manually_entered);
            UNICONNECT.P_ME_EXEC_START_DATE_TAB(l_row)  := MeUseValue('exec_start_date'   , l_row, l_me_rec_found.exec_start_date);
            UNICONNECT.P_ME_EXEC_END_DATE_TAB(l_row)    := MeUseValue('exec_end_date'     , l_row, l_me_rec_found.exec_end_date);
            UNICONNECT.P_ME_EXECUTOR_TAB(l_row)         := MeUseValue('executor'          , l_row, l_me_rec_found.executor);
            UNICONNECT.P_ME_LAB_TAB(l_row)              := MeUseValue('lab'               , l_row, l_me_rec_found.lab);
            UNICONNECT.P_ME_EQ_TAB(l_row)               := MeUseValue('eq'                , l_row, l_me_rec_found.eq);

            --Special rule for value_f and value_s :
            --Rule : when only value_f specified => value_s from record nomore used
            --          when only value_s specified => value_f from record nomore used
            --          when value_s AND value_f specified => all values from record ignored
            l_ret_code := UNICONNECT6.SpecialRulesForValues(UNICONNECT.P_ME_VALUE_S_MODTAB(l_row),
                                                            UNICONNECT.P_ME_VALUE_S_TAB(l_row),
                                                            UNICONNECT.P_ME_VALUE_F_MODTAB(l_row),
                                                            UNICONNECT.P_ME_VALUE_F_TAB(l_row),
                                                            l_me_rec_found.format,
                                                            l_me_rec_found.value_s,
                                                            l_me_rec_found.value_f);
            IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
               UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         ret_code='||TO_CHAR(l_ret_code)||
                                                     ' returned by UNICONNECT6.SpecialRulesForValues#value_s='||
                                                     UNICONNECT.P_ME_VALUE_S_TAB(l_row)||'#value_f='||
                                                     TO_CHAR(UNICONNECT.P_ME_VALUE_F_TAB(l_row))||
                                                     '#format='||l_me_rec_found.format);
               RAISE StpError;
            END IF;
            UNICONNECT.P_ME_VALUE_F_TAB(l_row)          := MeUseValue('value_f'           , l_row, l_me_rec_found.value_f);
            UNICONNECT.P_ME_VALUE_S_TAB(l_row)          := MeUseValue('value_s'           , l_row, l_me_rec_found.value_s);

         ELSE
            /* create_me=N ? */
            IF UNICONNECT.P_SET_CREATE_ME = 'N' THEN

               UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NORMAL,'         Warning : section skipped : me does not exist and can not be created');
               l_ret_code := UNAPIGEN.DBERR_SUCCESS;
               RAISE StpError;

            ELSE
               --find the mt corresponding to the provided description
               --in utmt when description used to specify the me
               IF l_description_pos > 0 THEN
                  OPEN l_mtdescription_cursor(UNICONNECT.P_ME_MEDESCRIPTION_TAB(l_row),
                                              UNICONNECT.P_ME_MT_VERSION_TAB(l_row));
                  FETCH l_mtdescription_cursor
                  INTO l_mt;
                  IF l_mtdescription_cursor%NOTFOUND THEN
                     --Major error no corresponding mt found
                     CLOSE l_mtdescription_cursor;
                     UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : no corresponding mt for description '||UNICONNECT.P_ME_MEDESCRIPTION_TAB(l_row));
                     l_ret_code := UNAPIGEN.DBERR_NOOBJID;
                     RAISE StpError;
                  END IF;
                  CLOSE l_mtdescription_cursor;
                  UNICONNECT.P_ME_ME_TAB(l_row) := l_mt;
               END IF;

               --use / pg and / pa when not specified in section or use pg according to found pa
               -- global variable PG is NULL and not already initialised to / in savescme array?
               -- NO do nothing
               -- YES pa record has been found ?
               --     YES use that record to create the method
               --     NO pg / already exist for SC ?
               --        YES   set PG and PGNODE with record found in SaveScMe Array
               --        NO set PG=/ and PGNODE=0 in SaveScMeArray
               --        DON'T SET PG AND PGNODE global variables
               IF UNICONNECT.P_GLOB_PG IS NULL THEN
                  IF l_pa_rec_found.panode IS NULL THEN
                     IF UNICONNECT.P_ME_PG_TAB(l_row) IS NULL THEN
                        IF l_slashpg_searched = FALSE THEN
                           OPEN l_slashpg_cursor(UNICONNECT.P_GLOB_SC);
                           FETCH l_slashpg_cursor
                           INTO l_slashpg_pgnode;
                           CLOSE l_slashpg_cursor;
                           l_slashpg_searched := TRUE;
                           UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Slash pg searched '||NVL(TO_CHAR(l_slashpg_pgnode),'NOT FOUND'));
                        END IF;

                        IF l_slashpg_pgnode IS NOT NULL THEN
                           UNICONNECT.P_ME_PG_TAB(l_row)         := '/';
                           UNICONNECT.P_ME_PGNODE_TAB(l_row)     := l_slashpg_pgnode;
                        ELSE
                           UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Slash pg not found, will be created ');
                           l_ret_code := UNICONNECT6.InsertPg(UNICONNECT.P_GLOB_SC,
                                                              '/',
                                                              TRUE,
                                                              l_slashpg_pgnode);
                           IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
                              UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : InsertFirstPg eturned '||l_ret_code);
                              RAISE StpError;
                           END IF;

                           UNICONNECT.P_ME_PG_TAB(l_row)         := '/';
                           UNICONNECT.P_ME_PGNODE_TAB(l_row)     := l_slashpg_pgnode;
                           l_slashpg_searched := TRUE;
                        END IF;
                     END IF;
                  ELSE
                     --the parameter was found but not the method
                     --the method must be created under that pa (and that pg)
                     UNICONNECT.P_ME_PG_TAB(l_row)         := l_pa_rec_found.pg;
                     UNICONNECT.P_ME_PGNODE_TAB(l_row)     := l_pa_rec_found.pgnode;
                  END IF;
               END IF;

               -- global variable PA is NULL and not already initialised to / in savescme array?
               -- NO do nothing
               -- YES   pa / already exist for SC/PG/PGNODE ?
               --    YES   set PA and PANODE with record found in SaveScMe Array
               --    NO set PA=/ and PANODE=0 in SaveScMeArray
               --    DON'T SET PA AND PANODE global variables
               IF UNICONNECT.P_GLOB_PA IS NULL THEN
                  IF UNICONNECT.P_ME_PA_TAB(l_row) IS NULL THEN
                     IF l_slashpa_searched = FALSE THEN
                        OPEN l_slashpa_cursor(UNICONNECT.P_GLOB_SC,
                                              NVL(UNICONNECT.P_GLOB_PG,'/'),
                                              NVL(UNICONNECT.P_GLOB_PGNODE,l_slashpg_pgnode));
                        FETCH l_slashpa_cursor
                        INTO l_slashpa_panode;
                        CLOSE l_slashpa_cursor;
                        l_slashpa_searched := TRUE;
                        UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Slash pa searched '||NVL(TO_CHAR(l_slashpa_panode),'NOT FOUND'));
                     END IF;

                     IF l_slashpa_panode IS NOT NULL THEN
                        UNICONNECT.P_ME_PA_TAB(l_row)         := '/';
                        UNICONNECT.P_ME_PANODE_TAB(l_row)     := l_slashpa_panode;
                     ELSE
                        UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Slash pa not found, will be created ');
                        l_ret_code := UNICONNECT6.InsertPa(UNICONNECT.P_GLOB_SC,
                                                           NVL(UNICONNECT.P_GLOB_PG,'/'),
                                                           NVL(UNICONNECT.P_GLOB_PGNODE,l_slashpg_pgnode),
                                                           '/',
                                                           TRUE,
                                                           l_slashpa_panode);
                        IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
                           UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : InsertFirstPa eturned '||l_ret_code);
                           RAISE StpError;
                        END IF;
                        UNICONNECT.P_ME_PA_TAB(l_row)         := '/';
                        UNICONNECT.P_ME_PANODE_TAB(l_row)     := l_slashpa_panode;
                        l_slashpa_searched := TRUE;
                     END IF;
                  END IF;
               END IF;

               --Set Modify flag to MOD_FLAG_CREATE
               UNICONNECT.P_ME_MODIFY_FLAG_TAB(l_row) := UNAPIGEN.MOD_FLAG_CREATE;
               UNICONNECT.P_ME_MENODE_TAB(l_row) := NULL;
               UNICONNECT.P_ME_USE_SAVESCMERESULT := FALSE;
            END IF;

         END IF;

      END LOOP;

   END IF;

   --9.Any me to create ?
   --   YES
   --   LOOP through all me array
   --      Call InitScMethod for all me which have to be created
   --      Initialise SaveScMe... array variables with the values coming
   --      from the InitScMethod or from the section
   --              (Values from the section will overrule the value from the InitScMethod)
   --   END LOOP
   --   Call SaveScMethod or SaveScMeResult (OPTIMALISATION)

   l_any_save := FALSE;
   FOR l_row IN 1..UNICONNECT.P_ME_NR_OF_ROWS LOOP

      IF UNICONNECT.P_ME_MODIFY_FLAG_TAB(l_row) IN (UNAPIGEN.MOD_FLAG_CREATE,
                                                 UNAPIGEN.MOD_FLAG_INSERT,
                                                 UNAPIGEN.MOD_FLAG_INSERT_WITH_NODES)
                                                 THEN

         l_any_save := TRUE;
         l_initme_mt := UNICONNECT.P_ME_ME_TAB(l_row);
         l_initme_mt_version_in := UNICONNECT.P_ME_MT_VERSION_TAB(l_row);
         l_initme_seq := NULL;
         l_initme_sc := UNICONNECT.P_ME_SC_TAB(l_row);
         l_initme_pg := UNICONNECT.P_ME_PG_TAB(l_row);
         l_initme_pgnode := UNICONNECT.P_ME_PGNODE_TAB(l_row);
         l_initme_pa := UNICONNECT.P_ME_PA_TAB(l_row);
         l_initme_panode := UNICONNECT.P_ME_PANODE_TAB(l_row);
         l_initme_pr_version := NULL;
         l_initme_nr_of_rows := NULL;

         l_ret_code := UNAPIME.INITSCMETHOD
                         (l_initme_mt,
                          l_initme_mt_version_in,
                          l_initme_seq,
                          l_initme_sc,
                          l_initme_pg,
                          l_initme_pgnode,
                          l_initme_pa,
                          l_initme_panode,
                          l_initme_pr_version,
                          l_initme_mt_nr_measur,
                          l_initme_reanalysis_tab,
                          l_initme_mt_version_tab,
                          l_initme_description_tab,
                          l_initme_value_f_tab,
                          l_initme_value_s_tab,
                          l_initme_unit_tab,
                          l_initme_exec_start_date_tab,
                          l_initme_exec_end_date_tab,
                          l_initme_executor_tab,
                          l_initme_lab_tab,
                          l_initme_eq_tab,
                          l_initme_eq_version_tab,
                          l_initme_planned_executor_tab,
                          l_initme_planned_eq_tab,
                          l_initme_planned_eq_vers_tab,
                          l_initme_manually_entered_tab,
                          l_initme_allow_add_tab,
                          l_initme_assign_date_tab,
                          l_initme_assigned_by_tab,
                          l_initme_manually_added_tab,
                          l_initme_delay_tab,
                          l_initme_delay_unit_tab,
                          l_initme_format_tab,
                          l_initme_accuracy_tab,
                          l_initme_real_cost_tab,
                          l_initme_real_time_tab,
                          l_initme_calibration_tab,
                          l_initme_confirm_complete_tab,
                          l_initme_autorecalc_tab,
                          l_initme_me_res_editable_tab,
                          l_initme_next_cell_tab,
                          l_initme_sop_tab,
                          l_initme_sop_version_tab,
                          l_initme_plaus_low_tab,
                          l_initme_plaus_high_tab,
                          l_initme_winsize_x_tab,
                          l_initme_winsize_y_tab,
                          l_initme_me_class_tab,
                          l_initme_log_hs_tab,
                          l_initme_log_hs_details_tab,
                          l_initme_lc_tab,
                          l_initme_lc_version_tab,
                          l_initme_nr_of_rows);

         IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : InitScMethod ret_code : '||l_ret_code ||
                                           '#mt='||l_initme_mt||'#mt_version_in='||l_initme_mt_version_in);
            RAISE StpError;
         ELSE

            --always use initscmethod values
            UNICONNECT.P_ME_MT_VERSION_TAB(l_row)         := l_initme_mt_version_tab(1);
            UNICONNECT.P_ME_EQ_VERSION_TAB(l_row)         := l_initme_eq_version_tab(1);
            UNICONNECT.P_ME_PLANNED_EXECUTOR_TAB(l_row)   := l_initme_planned_executor_tab(1);
            UNICONNECT.P_ME_PLANNED_EQ_TAB(l_row)         := l_initme_planned_eq_tab(1);
            UNICONNECT.P_ME_PLANNED_EQ_VERSION_TAB(l_row) := l_initme_planned_eq_vers_tab(1);
            UNICONNECT.P_ME_ALLOW_ADD_TAB(l_row)          := l_initme_allow_add_tab(1);
            UNICONNECT.P_ME_ASSIGN_DATE_TAB(l_row)        := l_initme_assign_date_tab(1);
            UNICONNECT.P_ME_ASSIGNED_BY_TAB(l_row)        := l_initme_assigned_by_tab(1);
            UNICONNECT.P_ME_MANUALLY_ADDED_TAB(l_row)     := l_initme_manually_added_tab(1);
            UNICONNECT.P_ME_DELAY_TAB(l_row)              := l_initme_delay_tab(1);
            UNICONNECT.P_ME_DELAY_UNIT_TAB(l_row)         := l_initme_delay_unit_tab(1);
            UNICONNECT.P_ME_FORMAT_TAB(l_row)             := l_initme_format_tab(1);
            UNICONNECT.P_ME_ACCURACY_TAB(l_row)           := l_initme_accuracy_tab(1);
            UNICONNECT.P_ME_REAL_COST_TAB(l_row)          := l_initme_real_cost_tab(1);
            UNICONNECT.P_ME_REAL_TIME_TAB(l_row)          := l_initme_real_time_tab(1);
            UNICONNECT.P_ME_CALIBRATION_TAB(l_row)        := l_initme_calibration_tab(1);
            UNICONNECT.P_ME_CONFIRM_COMPLETE_TAB(l_row)   := l_initme_confirm_complete_tab(1);
            UNICONNECT.P_ME_AUTORECALC_TAB(l_row)         := l_initme_autorecalc_tab(1);
            UNICONNECT.P_ME_ME_RESULT_EDITABLE_TAB(l_row) := l_initme_me_res_editable_tab(1);
            UNICONNECT.P_ME_NEXT_CELL_TAB(l_row)          := l_initme_next_cell_tab(1);
            UNICONNECT.P_ME_SOP_TAB(l_row)                := l_initme_sop_tab(1);
            UNICONNECT.P_ME_SOP_VERSION_TAB(l_row)        := l_initme_sop_version_tab(1);
            UNICONNECT.P_ME_PLAUS_LOW_TAB(l_row)          := l_initme_plaus_low_tab(1);
            UNICONNECT.P_ME_PLAUS_HIGH_TAB(l_row)         := l_initme_plaus_high_tab(1);
            UNICONNECT.P_ME_WINSIZE_X_TAB(l_row)          := l_initme_winsize_x_tab(1);
            UNICONNECT.P_ME_WINSIZE_Y_TAB(l_row)          := l_initme_winsize_y_tab(1);
            UNICONNECT.P_ME_REANALYSIS_TAB(l_row)         := l_initme_reanalysis_tab(1);
            UNICONNECT.P_ME_ME_CLASS_TAB(l_row)           := l_initme_me_class_tab(1);
            UNICONNECT.P_ME_LOG_HS_TAB(l_row)             := l_initme_log_hs_tab(1);
            UNICONNECT.P_ME_LOG_HS_DETAILS_TAB(l_row)     := l_initme_log_hs_details_tab(1);
            UNICONNECT.P_ME_LC_TAB(l_row)                 := l_initme_lc_tab(1);
            UNICONNECT.P_ME_LC_VERSION_TAB(l_row)         := l_initme_lc_version_tab(1);

            --only when not set in section
            UNICONNECT.P_ME_DESCRIPTION_TAB(l_row)      := MeUseValue('description'       , l_row, l_initme_description_tab(1));
            UNICONNECT.P_ME_UNIT_TAB(l_row)             := MeUseValue('unit'              , l_row, l_initme_unit_tab(1));
            UNICONNECT.P_ME_MANUALLY_ENTERED_TAB(l_row) := MeUseValue('manually_entered'  , l_row, l_initme_manually_entered_tab(1));
            UNICONNECT.P_ME_EXEC_START_DATE_TAB(l_row)  := MeUseValue('exec_start_date'   , l_row, l_initme_exec_start_date_tab(1));
            UNICONNECT.P_ME_EXEC_END_DATE_TAB(l_row)    := MeUseValue('exec_end_date'     , l_row, l_initme_exec_end_date_tab(1));
            UNICONNECT.P_ME_EXECUTOR_TAB(l_row)         := MeUseValue('executor'          , l_row, l_initme_executor_tab(1));
            UNICONNECT.P_ME_LAB_TAB(l_row)              := MeUseValue('lab'               , l_row, l_initme_lab_tab(1));
            UNICONNECT.P_ME_EQ_TAB(l_row)               := MeUseValue('eq'                , l_row, l_initme_eq_tab(1));

            --Special rule for value_f and value_s :
            --Rule : when only value_f specified => value_s from record nomore used
            --          when only value_s specified => value_f from record nomore used
            --          when value_s AND value_f specified => all values from record ignored
            l_ret_code := UNICONNECT6.SpecialRulesForValues(UNICONNECT.P_ME_VALUE_S_MODTAB(l_row),
                                                            UNICONNECT.P_ME_VALUE_S_TAB(l_row),
                                                            UNICONNECT.P_ME_VALUE_F_MODTAB(l_row),
                                                            UNICONNECT.P_ME_VALUE_F_TAB(l_row),
                                                            l_initme_format_tab(1),
                                                            l_initme_value_s_tab(1),
                                                            l_initme_value_f_tab(1));
            IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
               UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         ret_code='||TO_CHAR(l_ret_code)||
                                                     ' returned by UNICONNECT6.SpecialRulesForValues#value_s='||
                                                     UNICONNECT.P_ME_VALUE_S_TAB(l_row)||'#value_f='||
                                                     TO_CHAR(UNICONNECT.P_ME_VALUE_F_TAB(l_row))||
                                                     '#format='||l_initme_format_tab(1));
               RAISE StpError;
            END IF;

            UNICONNECT.P_ME_VALUE_F_TAB(l_row)          := MeUseValue('value_f'           , l_row, l_initme_value_f_tab(1));
            UNICONNECT.P_ME_VALUE_S_TAB(l_row)          := MeUseValue('value_s'           , l_row, l_initme_value_s_tab(1));

            --special rule for lab: lab is set to - when not set in section and eq set
            IF UNICONNECT.P_ME_EQ_TAB(l_row) IS NOT NULL AND
               UNICONNECT.P_ME_LAB_TAB(l_row) IS NULL THEN
               UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NORMAL,'         eq specified but not lab, lab forced to -');
               UNICONNECT.P_ME_LAB_TAB(l_row) := '-';
            END IF;
         END IF;

      ELSIF UNICONNECT.P_ME_MODIFY_FLAG_TAB(l_row) IN (UNAPIGEN.MOD_FLAG_UPDATE,
                                                    UNAPIGEN.MOD_FLAG_DELETE) THEN

         l_any_save := TRUE;
         --special rule for lab: lab is set to - when not set in section and eq set
         IF UNICONNECT.P_ME_EQ_TAB(l_row) IS NOT NULL AND
            UNICONNECT.P_ME_LAB_TAB(l_row) IS NULL THEN
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NORMAL,'         eq specified but not lab, lab forced to -');
            UNICONNECT.P_ME_LAB_TAB(l_row) := '-';
         END IF;

      END IF;
   END LOOP;

   IF l_any_save THEN
      IF UNICONNECT.P_ME_USE_SAVESCMERESULT AND UNICONNECT.P_ME_ANY_RESULT THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Calling SaveScMeResult for :');
         l_used_api := 'SaveScMeResult';
      ELSE
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Calling SaveScMethod for :');
         l_used_api := 'SaveScMethod';
      END IF;

      FOR l_row IN 1..UNICONNECT.P_ME_NR_OF_ROWS LOOP
          UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'            row='||l_row||
                                         '#mod_flag='||UNICONNECT.P_ME_MODIFY_FLAG_TAB(l_row) ||
                                         '#sc='||UNICONNECT.P_ME_SC_TAB(l_row)||'#pg='||UNICONNECT.P_ME_PG_TAB(l_row)||
                                         '#pgnode='||NVL(TO_CHAR(UNICONNECT.P_ME_PGNODE_TAB(l_row)),'NULL')||
                                         '#pa='||UNICONNECT.P_ME_PA_TAB(l_row)||
                                         '#panode='||NVL(TO_CHAR(UNICONNECT.P_ME_PANODE_TAB(l_row)),'NULL')||
                                         '#me='||UNICONNECT.P_ME_ME_TAB(l_row)||
                                         '#menode='||NVL(TO_CHAR(UNICONNECT.P_ME_MENODE_TAB(l_row)),'NULL'));
      END LOOP;

      UNICONNECT.P_ME_ALARMS_HANDLED := UNAPIGEN.ALARMS_NOT_HANDLED;

      IF UNICONNECT.P_ME_USE_SAVESCMERESULT THEN
         l_ret_code := UNAPIME.SAVESCMERESULT
                (UNICONNECT.P_ME_ALARMS_HANDLED,
                 UNICONNECT.P_ME_SC_TAB,
                 UNICONNECT.P_ME_PG_TAB,
                 UNICONNECT.P_ME_PGNODE_TAB,
                 UNICONNECT.P_ME_PA_TAB,
                 UNICONNECT.P_ME_PANODE_TAB,
                 UNICONNECT.P_ME_ME_TAB,
                 UNICONNECT.P_ME_MENODE_TAB,
                 UNICONNECT.P_ME_REANALYSIS_TAB,
                 UNICONNECT.P_ME_VALUE_F_TAB,
                 UNICONNECT.P_ME_VALUE_S_TAB,
                 UNICONNECT.P_ME_UNIT_TAB,
                 UNICONNECT.P_ME_FORMAT_TAB,
                 UNICONNECT.P_ME_EXEC_END_DATE_TAB,
                 UNICONNECT.P_ME_EXECUTOR_TAB,
                 UNICONNECT.P_ME_LAB_TAB,
                 UNICONNECT.P_ME_EQ_TAB,
                 UNICONNECT.P_ME_EQ_VERSION_TAB,
                 UNICONNECT.P_ME_MANUALLY_ENTERED_TAB,
                 UNICONNECT.P_ME_REAL_COST_TAB,
                 UNICONNECT.P_ME_REAL_TIME_TAB,
                 UNICONNECT.P_ME_MODIFY_FLAG_TAB,
                 UNICONNECT.P_ME_NR_OF_ROWS,
                 UNICONNECT.P_ME_MODIFY_REASON);


      ELSE
         l_ret_code := UNAPIME.SAVESCMETHOD
                         (UNICONNECT.P_ME_ALARMS_HANDLED,
                          UNICONNECT.P_ME_SC_TAB,
                          UNICONNECT.P_ME_PG_TAB,
                          UNICONNECT.P_ME_PGNODE_TAB,
                          UNICONNECT.P_ME_PA_TAB,
                          UNICONNECT.P_ME_PANODE_TAB,
                          UNICONNECT.P_ME_ME_TAB,
                          UNICONNECT.P_ME_MENODE_TAB,
                          UNICONNECT.P_ME_REANALYSIS_TAB,
                          UNICONNECT.P_ME_MT_VERSION_TAB,
                          UNICONNECT.P_ME_DESCRIPTION_TAB,
                          UNICONNECT.P_ME_VALUE_F_TAB,
                          UNICONNECT.P_ME_VALUE_S_TAB,
                          UNICONNECT.P_ME_UNIT_TAB,
                          UNICONNECT.P_ME_EXEC_START_DATE_TAB,
                          UNICONNECT.P_ME_EXEC_END_DATE_TAB,
                          UNICONNECT.P_ME_EXECUTOR_TAB,
                          UNICONNECT.P_ME_LAB_TAB,
                          UNICONNECT.P_ME_EQ_TAB,
                          UNICONNECT.P_ME_EQ_VERSION_TAB,
                          UNICONNECT.P_ME_PLANNED_EXECUTOR_TAB,
                          UNICONNECT.P_ME_PLANNED_EQ_TAB,
                          UNICONNECT.P_ME_PLANNED_EQ_VERSION_TAB,
                          UNICONNECT.P_ME_MANUALLY_ENTERED_TAB,
                          UNICONNECT.P_ME_ALLOW_ADD_TAB,
                          UNICONNECT.P_ME_ASSIGN_DATE_TAB,
                          UNICONNECT.P_ME_ASSIGNED_BY_TAB,
                          UNICONNECT.P_ME_MANUALLY_ADDED_TAB,
                          UNICONNECT.P_ME_DELAY_TAB,
                          UNICONNECT.P_ME_DELAY_UNIT_TAB,
                          UNICONNECT.P_ME_FORMAT_TAB,
                          UNICONNECT.P_ME_ACCURACY_TAB,
                          UNICONNECT.P_ME_REAL_COST_TAB,
                          UNICONNECT.P_ME_REAL_TIME_TAB,
                          UNICONNECT.P_ME_CALIBRATION_TAB,
                          UNICONNECT.P_ME_CONFIRM_COMPLETE_TAB,
                          UNICONNECT.P_ME_AUTORECALC_TAB,
                          UNICONNECT.P_ME_ME_RESULT_EDITABLE_TAB,
                          UNICONNECT.P_ME_NEXT_CELL_TAB,
                          UNICONNECT.P_ME_SOP_TAB,
                          UNICONNECT.P_ME_SOP_VERSION_TAB,
                          UNICONNECT.P_ME_PLAUS_LOW_TAB,
                          UNICONNECT.P_ME_PLAUS_HIGH_TAB,
                          UNICONNECT.P_ME_WINSIZE_X_TAB,
                          UNICONNECT.P_ME_WINSIZE_Y_TAB,
                          UNICONNECT.P_ME_ME_CLASS_TAB,
                          UNICONNECT.P_ME_LOG_HS_TAB,
                          UNICONNECT.P_ME_LOG_HS_DETAILS_TAB,
                          UNICONNECT.P_ME_LC_TAB,
                          UNICONNECT.P_ME_LC_VERSION_TAB,
                          UNICONNECT.P_ME_MODIFY_FLAG_TAB,
                          UNICONNECT.P_ME_NR_OF_ROWS,
                          UNICONNECT.P_ME_MODIFY_REASON);

      END IF;

      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS AND
         l_ret_code <> UNAPIGEN.DBERR_PARTIALSAVE THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : ' || l_used_api || ' ret_code='||l_ret_code ||
                                        '#sc(1)='||UNICONNECT.P_ME_SC_TAB(1)||'#pg(1)='||UNICONNECT.P_ME_PG_TAB(1)||
                                        '#pgnode(1)='||NVL(TO_CHAR(UNICONNECT.P_ME_PGNODE_TAB(1)),'NULL')||
                                        '#pa(1)='||UNICONNECT.P_ME_PA_TAB(1)||
                                        '#panode(1)='||NVL(TO_CHAR(UNICONNECT.P_ME_PANODE_TAB(1)),'NULL')||
                                        '#me(1)='||UNICONNECT.P_ME_ME_TAB(1)||
                                        '#menode(1)='||NVL(TO_CHAR(UNICONNECT.P_ME_MENODE_TAB(1)),'NULL')||
                                        '#mod_flag(1)='||UNICONNECT.P_ME_MODIFY_FLAG_TAB(1));
         RAISE StpError;
      ELSIF l_ret_code = UNAPIGEN.DBERR_PARTIALSAVE THEN
         IF UNICONNECT.P_ME_NR_OF_ROWS >= 1 THEN
            FOR l_row IN 1..UNICONNECT.P_ME_NR_OF_ROWS LOOP
               IF UNICONNECT.P_ME_MODIFY_FLAG_TAB(l_row) > UNAPIGEN.DBERR_SUCCESS THEN
                  UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         ' || l_used_api || ' authorisation problem row='||l_row||
                                                 '#mod_flag='||UNICONNECT.P_ME_MODIFY_FLAG_TAB(l_row) ||
                                                 '#sc='||UNICONNECT.P_ME_SC_TAB(l_row)||'#pg='||UNICONNECT.P_ME_PG_TAB(l_row)||
                                                 '#pgnode='||NVL(TO_CHAR(UNICONNECT.P_ME_PGNODE_TAB(l_row)),'NULL')||
                                                 '#pa='||UNICONNECT.P_ME_PA_TAB(l_row)||
                                                 '#panode='||NVL(TO_CHAR(UNICONNECT.P_ME_PANODE_TAB(l_row)),'NULL')||
                                                 '#me='||UNICONNECT.P_ME_ME_TAB(l_row)||
                                                 '#menode='||NVL(TO_CHAR(UNICONNECT.P_ME_MENODE_TAB(l_row)),'NULL'));
               END IF;
            END LOOP;
         END IF;
         IF UNAPIAUT.P_NOT_AUTHORISED IS NOT NULL THEN
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         ' || UNAPIAUT.P_NOT_AUTHORISED );
         END IF;
         --Don't ROLLBACK the transaction on PARTIAL_SAVE
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_SUCCESS;
      END IF;
   ELSE
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         No save(s) in [me] section');
   END IF;

   -- Perform a ChangeStatus or a Cancel when required
   FOR l_row IN 1..UNICONNECT.P_ME_NR_OF_ROWS LOOP
      IF UNICONNECT.P_ME_SS_MODTAB(l_row) THEN
         l_ret_code := ChangeScMeStatusOrCancel(UNICONNECT.P_ME_SC_TAB(l_row),
                                                UNICONNECT.P_ME_PG_TAB(l_row),
                                                UNICONNECT.P_ME_PGNODE_TAB(l_row),
                                                UNICONNECT.P_ME_PA_TAB(l_row),
                                                UNICONNECT.P_ME_PANODE_TAB(l_row),
                                                UNICONNECT.P_ME_ME_TAB(l_row),
                                                UNICONNECT.P_ME_MENODE_TAB(l_row),
                                                UNICONNECT.P_ME_SS_TAB(l_row),
                                                UNICONNECT.P_ME_MODIFY_REASON);
         IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : ChangeScPaStatusOrCancel ret_code='||l_ret_code ||
                                      '#sc='||UNICONNECT.P_ME_SC_TAB(l_row)||
                                      '#pg='||UNICONNECT.P_ME_PG_TAB(l_row)||
                                      '#pgnode='||NVL(TO_CHAR(UNICONNECT.P_ME_PGNODE_TAB(l_row)),'NULL')||
                                      '#pa='||UNICONNECT.P_ME_PA_TAB(l_row)||
                                      '#panode='||NVL(TO_CHAR(UNICONNECT.P_ME_PANODE_TAB(l_row)),'NULL')||
                                      '#me='||UNICONNECT.P_ME_ME_TAB(l_row)||
                                      '#menode='||NVL(TO_CHAR(UNICONNECT.P_ME_MENODE_TAB(l_row)),'NULL')
                                      );
            IF UNAPIAUT.P_NOT_AUTHORISED IS NOT NULL THEN
               UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         ' || UNAPIAUT.P_NOT_AUTHORISED );
            END IF;
            RAISE StpError;
         END IF;
      END IF;
   END LOOP;

   -- Perform a AddComment when required
   FOR l_row IN 1..UNICONNECT.P_ME_NR_OF_ROWS LOOP
      IF UNICONNECT.P_ME_ADD_COMMENT_TAB(l_row) IS NOT NULL THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Adding comment for'||
                                   '#sc='||UNICONNECT.P_ME_SC_TAB(l_row)||
                                   '#pg='||UNICONNECT.P_ME_PG_TAB(l_row)||
                                   '#pgnode='||NVL(TO_CHAR(UNICONNECT.P_ME_PGNODE_TAB(l_row)),'NULL')||
                                   '#pa='||UNICONNECT.P_ME_PA_TAB(l_row)||
                                   '#panode='||NVL(TO_CHAR(UNICONNECT.P_ME_PANODE_TAB(l_row)),'NULL')||
                                   '#me='||UNICONNECT.P_ME_ME_TAB(l_row)||
                                   '#menode='||NVL(TO_CHAR(UNICONNECT.P_ME_MENODE_TAB(l_row)),'NULL'));
         l_ret_code := UNAPIMEP.AddScMeComment(UNICONNECT.P_ME_SC_TAB(l_row),
                                               UNICONNECT.P_ME_PG_TAB(l_row),
                                               UNICONNECT.P_ME_PGNODE_TAB(l_row),
                                               UNICONNECT.P_ME_PA_TAB(l_row),
                                               UNICONNECT.P_ME_PANODE_TAB(l_row),
                                               UNICONNECT.P_ME_ME_TAB(l_row),
                                               UNICONNECT.P_ME_MENODE_TAB(l_row),
                                               UNICONNECT.P_ME_ADD_COMMENT_TAB(l_row));

         IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : AddScMeComment ret_code='||l_ret_code ||
                                      '#sc='||UNICONNECT.P_ME_SC_TAB(l_row)||
                                      '#pg='||UNICONNECT.P_ME_PG_TAB(l_row)||
                                      '#pgnode='||NVL(TO_CHAR(UNICONNECT.P_ME_PGNODE_TAB(l_row)),'NULL')||
                                      '#pa='||UNICONNECT.P_ME_PA_TAB(l_row)||
                                      '#panode='||NVL(TO_CHAR(UNICONNECT.P_ME_PANODE_TAB(l_row)),'NULL')||
                                      '#me='||UNICONNECT.P_ME_ME_TAB(l_row)||
                                      '#menode='||NVL(TO_CHAR(UNICONNECT.P_ME_MENODE_TAB(l_row)),'NULL'));
            IF UNAPIAUT.P_NOT_AUTHORISED IS NOT NULL THEN
               UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         ' || UNAPIAUT.P_NOT_AUTHORISED );
            END IF;
            RAISE StpError;
         END IF;
      END IF;
   END LOOP;

   --11. Initialise ME and MENODE global variables with the last me in array
   --Cleanup the arrays used to save the method(s) (important since it can be reused)
   IF UNICONNECT.P_ME_NR_OF_ROWS > 0 THEN
      UNICONNECT.P_GLOB_PG     := UNICONNECT.P_ME_PG_TAB(UNICONNECT.P_ME_NR_OF_ROWS);
      UNICONNECT.P_GLOB_PGNODE := UNICONNECT.P_ME_PGNODE_TAB(UNICONNECT.P_ME_NR_OF_ROWS);
      UNICONNECT.P_GLOB_PA     := UNICONNECT.P_ME_PA_TAB(UNICONNECT.P_ME_NR_OF_ROWS);
      UNICONNECT.P_GLOB_PANODE := UNICONNECT.P_ME_PANODE_TAB(UNICONNECT.P_ME_NR_OF_ROWS);
      UNICONNECT.P_GLOB_ME     := UNICONNECT.P_ME_ME_TAB(UNICONNECT.P_ME_NR_OF_ROWS);
      UNICONNECT.P_GLOB_MENODE := UNICONNECT.P_ME_MENODE_TAB(UNICONNECT.P_ME_NR_OF_ROWS);
      UNICONNECT2.WriteGlobalVariablesToLog;
   ELSE
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NORMAL,'         Warning ! current me and menode not set before leaving [me] section !');
   END IF;
   UCON_CleanupMeSection;
   UNICONNECT.P_ME_NR_OF_ROWS := 0;

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
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Following exception catched in UCON_ExecuteMeSection :');
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         '||l_sqlerrm);
      l_ret_code := UNAPIGEN.DBERR_GENFAIL;
   END IF;
   UCON_CleanupMeSection;
   UNAPIGEN.P_TXN_ERROR := l_ret_code;
   RETURN(l_ret_code);

END UCON_ExecuteMeSection;

/*--------------------------------------------------------*/
/* procedures and functions related to the [cell] section */
/*--------------------------------------------------------*/

PROCEDURE UCON_InitialiseMeCellSection     /* INTERNAL */
IS
BEGIN

   --local variables initialisation
   UNICONNECT.P_CE_NR_OF_ROWS := 0;
   UNICONNECT.P_CE_SC := UNICONNECT.P_GLOB_SC;
   UNICONNECT.P_CE_PG := UNICONNECT.P_GLOB_PG;
   UNICONNECT.P_CE_PGNODE := UNICONNECT.P_GLOB_PGNODE;
   UNICONNECT.P_CE_PP_KEY1 := NULL;
   UNICONNECT.P_CE_PP_KEY2 := NULL;
   UNICONNECT.P_CE_PP_KEY3 := NULL;
   UNICONNECT.P_CE_PP_KEY4 := NULL;
   UNICONNECT.P_CE_PP_KEY5 := NULL;
   UNICONNECT.P_CE_PP_VERSION := NULL;
   UNICONNECT.P_CE_PA := UNICONNECT.P_GLOB_PA;
   UNICONNECT.P_CE_PANODE := UNICONNECT.P_GLOB_PANODE;
   UNICONNECT.P_CE_PR_VERSION := NULL;
   UNICONNECT.P_CE_ME := UNICONNECT.P_GLOB_ME;
   UNICONNECT.P_CE_MENODE := UNICONNECT.P_GLOB_MENODE;
   UNICONNECT.P_CE_MT_VERSION := NULL;

   --internal to [cell] section
   UNICONNECT.P_CE_PGNAME := NULL;
   UNICONNECT.P_CE_PGDESCRIPTION := NULL;
   UNICONNECT.P_CE_PANAME := NULL;
   UNICONNECT.P_CE_PADESCRIPTION := NULL;
   UNICONNECT.P_CE_MENAME := NULL;
   UNICONNECT.P_CE_MEDESCRIPTION := NULL;

   --global variables
   UNICONNECT.P_GLOB_CE := NULL;
   UNICONNECT.P_GLOB_CENODE := NULL;

   --important : by default the method sheet is considered as completed
   UNICONNECT.P_CE_COMPLETED := '1';

END UCON_InitialiseMeCellSection;

FUNCTION UCON_AssignMeCellSectionRow       /* INTERNAL */
RETURN NUMBER IS

l_description_pos      INTEGER;

BEGIN

   --Important assumption : one [cell] section is only related to one method within one pa within one pg within one sample

   UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NONE,'      Assigning value of variable '||UNICONNECT.P_VARIABLE_NAME||' in [cell] section');
   IF UNICONNECT.P_VARIABLE_NAME = 'sc' THEN
      UNICONNECT.P_CE_SC := UNICONNECT.P_VARIABLE_VALUE;

   ELSIF UNICONNECT.P_VARIABLE_NAME IN ('pgnode', 'pg.pgnode') THEN
      UNICONNECT.P_CE_PGNODE := UNICONNECT.P_VARIABLE_VALUE;

      --Fatal error when pg not yet specified
      IF UNICONNECT.P_CE_PGNAME IS NULL THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major problem ! pgnode in cell section must be preceded by a pg setting');
         RETURN(UNAPIGEN.DBERR_GENFAIL);
      END IF;

   ELSIF UNICONNECT.P_VARIABLE_NAME IN ('pp_key1', 'pg.pp_key1') THEN
      UNICONNECT.P_CE_PP_KEY1 := NVL(UNICONNECT.P_VARIABLE_VALUE, ' ');

   ELSIF UNICONNECT.P_VARIABLE_NAME IN ('pp_key2', 'pg.pp_key2') THEN
      UNICONNECT.P_CE_PP_KEY2 := NVL(UNICONNECT.P_VARIABLE_VALUE, ' ');

   ELSIF UNICONNECT.P_VARIABLE_NAME IN ('pp_key3', 'pg.pp_key3') THEN
      UNICONNECT.P_CE_PP_KEY3 := NVL(UNICONNECT.P_VARIABLE_VALUE, ' ');

   ELSIF UNICONNECT.P_VARIABLE_NAME IN ('pp_key4', 'pg.pp_key4') THEN
      UNICONNECT.P_CE_PP_KEY4 := NVL(UNICONNECT.P_VARIABLE_VALUE, ' ');

   ELSIF UNICONNECT.P_VARIABLE_NAME IN ('pp_key5', 'pg.pp_key5') THEN
      UNICONNECT.P_CE_PP_KEY5 := NVL(UNICONNECT.P_VARIABLE_VALUE, ' ');

   ELSIF UNICONNECT.P_VARIABLE_NAME IN ('pp_version', 'pg.pp_version') THEN
      UNICONNECT.P_CE_PP_VERSION := UNICONNECT.P_VARIABLE_VALUE;

   ELSIF SUBSTR(UNICONNECT.P_VARIABLE_NAME,1,2) = 'pg' THEN
      --MUST BE PLACED after pgnode/pp_key[1-5] variable assignment since SUBSTR will return pg
      --initialise full array except for sample code

      --pg can be specified by description or by name
      l_description_pos := INSTR(UNICONNECT.P_VARIABLE_NAME, '.description');
      IF l_description_pos > 0 THEN
         UNICONNECT.P_CE_PGDESCRIPTION := UNICONNECT.P_VARIABLE_VALUE;
         UNICONNECT.P_CE_PGNAME        := UNICONNECT.P_VARIABLE_NAME;
         UNICONNECT.P_CE_PG := NULL;
      ELSE
         UNICONNECT.P_CE_PG            := UNICONNECT.P_VARIABLE_VALUE;
         UNICONNECT.P_CE_PGNAME        := UNICONNECT.P_VARIABLE_NAME;
         UNICONNECT.P_CE_PGDESCRIPTION := NULL;
      END IF;

      --also reset pgnode : pgnode is initialised with global setting PGNODE when entering
      --the section
      UNICONNECT.P_CE_PGNODE := NULL;

   ELSIF UNICONNECT.P_VARIABLE_NAME IN ('panode', 'pa.panode') THEN
      UNICONNECT.P_CE_PANODE := UNICONNECT.P_VARIABLE_VALUE;

      --Fatal error when pa not yet specified
      IF UNICONNECT.P_CE_PANAME IS NULL THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major problem ! panode in [cell] section must be preceded by a pa setting');
         RETURN(UNAPIGEN.DBERR_GENFAIL);
      END IF;

   ELSIF UNICONNECT.P_VARIABLE_NAME IN ('pr_version', 'pa.pr_version') THEN
      UNICONNECT.P_CE_PR_VERSION := UNICONNECT.P_VARIABLE_VALUE;

   ELSIF SUBSTR(UNICONNECT.P_VARIABLE_NAME,1,2) = 'pa' THEN
      --MUST BE PLACED after panode variable assignment since SUBSTR will return pa

      --pa can be specified by description or by name
      l_description_pos := INSTR(UNICONNECT.P_VARIABLE_NAME, '.description');
      IF l_description_pos > 0 THEN
         UNICONNECT.P_CE_PADESCRIPTION := UNICONNECT.P_VARIABLE_VALUE;
         UNICONNECT.P_CE_PANAME        := UNICONNECT.P_VARIABLE_NAME;
         UNICONNECT.P_CE_PA := NULL;
      ELSE
         UNICONNECT.P_CE_PA            := UNICONNECT.P_VARIABLE_VALUE;
         UNICONNECT.P_CE_PANAME        := UNICONNECT.P_VARIABLE_NAME;
         UNICONNECT.P_CE_PADESCRIPTION := NULL;
      END IF;

      --also reset panode : panode is initialised with global setting PANODE when entering
      --the section
      UNICONNECT.P_CE_PANODE := NULL;

   ELSIF UNICONNECT.P_VARIABLE_NAME IN ('menode', 'me.menode') THEN
      UNICONNECT.P_CE_MENODE := UNICONNECT.P_VARIABLE_VALUE;

      --Fatal error when pa not yet specified
      IF UNICONNECT.P_CE_MENAME IS NULL THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major problem ! menode in [cell] section must be preceded by a me setting');
         RETURN(UNAPIGEN.DBERR_GENFAIL);
      END IF;

   ELSIF UNICONNECT.P_VARIABLE_NAME IN ('mt_version', 'me.mt_version') THEN
      UNICONNECT.P_CE_MT_VERSION := UNICONNECT.P_VARIABLE_VALUE;

   ELSIF SUBSTR(UNICONNECT.P_VARIABLE_NAME,1,2) = 'me' THEN
      --MUST BE PLACED after menode variable assignment since SUBSTR will return me

      --me can be specified by description or by name
      l_description_pos := INSTR(UNICONNECT.P_VARIABLE_NAME, '.description');
      IF l_description_pos > 0 THEN
         UNICONNECT.P_CE_MEDESCRIPTION := UNICONNECT.P_VARIABLE_VALUE;
         UNICONNECT.P_CE_MENAME        := UNICONNECT.P_VARIABLE_NAME;
         UNICONNECT.P_CE_ME := NULL;
      ELSE
         UNICONNECT.P_CE_ME            := UNICONNECT.P_VARIABLE_VALUE;
         UNICONNECT.P_CE_MENAME        := UNICONNECT.P_VARIABLE_NAME;
         UNICONNECT.P_CE_MEDESCRIPTION := NULL;
      END IF;

      --also reset menode : menode is initialised with global setting MENODE when entering
      --the section
      UNICONNECT.P_CE_MENODE := NULL;

   ELSIF UNICONNECT.P_VARIABLE_NAME = 'value_f' THEN
      UNICONNECT.P_CE_VALUE_F_TAB(UNICONNECT.P_CE_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;
      UNICONNECT.P_CE_VALUE_F_MODTAB(UNICONNECT.P_CE_NR_OF_ROWS) := TRUE;
      UNICONNECT.P_CE_MODIFY_FLAG_TAB(UNICONNECT.P_CE_NR_OF_ROWS) := UNAPIGEN.MOD_FLAG_UPDATE;

   ELSIF UNICONNECT.P_VARIABLE_NAME = 'value_s' THEN
      UNICONNECT.P_CE_VALUE_S_TAB(UNICONNECT.P_CE_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;
      UNICONNECT.P_CE_VALUE_S_MODTAB(UNICONNECT.P_CE_NR_OF_ROWS) := TRUE;
      UNICONNECT.P_CE_MODIFY_FLAG_TAB(UNICONNECT.P_CE_NR_OF_ROWS) := UNAPIGEN.MOD_FLAG_UPDATE;

   ELSIF UNICONNECT.P_VARIABLE_NAME = 'dsp_title' THEN
      UNICONNECT.P_CE_DSP_TITLE_TAB(UNICONNECT.P_CE_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;
      UNICONNECT.P_CE_DSP_TITLE_MODTAB(UNICONNECT.P_CE_NR_OF_ROWS) := TRUE;
      UNICONNECT.P_CE_MODIFY_FLAG_TAB(UNICONNECT.P_CE_NR_OF_ROWS) := UNAPIGEN.MOD_FLAG_UPDATE;

   ELSIF UNICONNECT.P_VARIABLE_NAME = 'eq' THEN
      UNICONNECT.P_CE_EQ_TAB(UNICONNECT.P_CE_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;
      UNICONNECT.P_CE_EQ_MODTAB(UNICONNECT.P_CE_NR_OF_ROWS) := TRUE;
      UNICONNECT.P_CE_MODIFY_FLAG_TAB(UNICONNECT.P_CE_NR_OF_ROWS) := UNAPIGEN.MOD_FLAG_UPDATE;

   ELSIF UNICONNECT.P_VARIABLE_NAME = 'unit' THEN
      UNICONNECT.P_CE_UNIT_TAB(UNICONNECT.P_CE_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;
      UNICONNECT.P_CE_UNIT_MODTAB(UNICONNECT.P_CE_NR_OF_ROWS) := TRUE;
      UNICONNECT.P_CE_MODIFY_FLAG_TAB(UNICONNECT.P_CE_NR_OF_ROWS) := UNAPIGEN.MOD_FLAG_UPDATE;

   ELSIF UNICONNECT.P_VARIABLE_NAME = 'completed' THEN
      UNICONNECT.P_CE_COMPLETED := UNICONNECT.P_VARIABLE_VALUE;

   ELSIF UNICONNECT.P_VARIABLE_NAME = 'comment' THEN
      UNICONNECT.P_CE_MODIFY_REASON := UNICONNECT.P_VARIABLE_VALUE;
      UNICONNECT.P_CE_MODIFY_FLAG_TAB(UNICONNECT.P_CE_NR_OF_ROWS) := UNAPIGEN.MOD_FLAG_UPDATE;

   ELSIF UNICONNECT.P_VARIABLE_NAME = 'cellnode' THEN
      UNICONNECT.P_CE_CENODE_TAB(UNICONNECT.P_CE_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;

   ELSIF SUBSTR(UNICONNECT.P_VARIABLE_NAME,1,4) = 'cell' THEN
      --MUST BE PLACED after cellnode variable assignment since SUBSTR will return cell
      --initialise full array except for sample code, pg, pgnode, pa and panode, me and menode
      UNICONNECT.P_CE_NR_OF_ROWS := UNICONNECT.P_CE_NR_OF_ROWS + 1;

      --cell can be specified by description or by name
      l_description_pos := INSTR(UNICONNECT.P_VARIABLE_NAME, '.description');
      IF l_description_pos > 0 THEN
         UNICONNECT.P_CE_CEDESCRIPTION_TAB(UNICONNECT.P_CE_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;
         UNICONNECT.P_CE_CE_TAB(UNICONNECT.P_CE_NR_OF_ROWS) := NULL;
      ELSE
         UNICONNECT.P_CE_CE_TAB(UNICONNECT.P_CE_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;
         UNICONNECT.P_CE_CEDESCRIPTION_TAB(UNICONNECT.P_CE_NR_OF_ROWS) := NULL;
      END IF;

      UNICONNECT.P_CE_CENAME_TAB(UNICONNECT.P_CE_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_NAME;

      UNICONNECT.P_CE_CENODE_TAB(UNICONNECT.P_CE_NR_OF_ROWS)            := NULL;

      UNICONNECT.P_CE_DSP_TITLE_TAB(UNICONNECT.P_CE_NR_OF_ROWS)         := NULL;
      UNICONNECT.P_CE_VALUE_F_TAB(UNICONNECT.P_CE_NR_OF_ROWS)           := NULL;
      UNICONNECT.P_CE_VALUE_S_TAB(UNICONNECT.P_CE_NR_OF_ROWS)           := NULL;
      UNICONNECT.P_CE_EQ_TAB(UNICONNECT.P_CE_NR_OF_ROWS)                := NULL;
      UNICONNECT.P_CE_MODIFY_FLAG_TAB(UNICONNECT.P_CE_NR_OF_ROWS)       := UNAPIGEN.DBERR_SUCCESS;

      --initialise all modify flags to FALSE
      UNICONNECT.P_CE_DSP_TITLE_MODTAB(UNICONNECT.P_CE_NR_OF_ROWS)            := FALSE;
      UNICONNECT.P_CE_VALUE_F_MODTAB(UNICONNECT.P_CE_NR_OF_ROWS)              := FALSE;
      UNICONNECT.P_CE_VALUE_S_MODTAB(UNICONNECT.P_CE_NR_OF_ROWS)              := FALSE;
      UNICONNECT.P_CE_EQ_MODTAB(UNICONNECT.P_CE_NR_OF_ROWS)                   := FALSE;
      UNICONNECT.P_CE_UNIT_MODTAB(UNICONNECT.P_CE_NR_OF_ROWS)                 := FALSE;

   ELSE
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'      Invalid variable '||UNICONNECT.P_VARIABLE_NAME||' in [cell] section');
      RETURN(UNAPIGEN.DBERR_INVALIDVARIABLE);
   END IF;
   RETURN(UNAPIGEN.DBERR_SUCCESS);

END UCON_AssignMeCellSectionRow;

--MeCellUseValue is an Overloaded function : one returning a NUMBER and the other one returning VARCHAR2
--MeCellUseValue will return the value specified in the section when effectively set in the section
--A modify_flag is maintained for each variable within the section (see UCON_AssignMeCellSectionRow)
--The argument a_alt_value (read alternative value) will be returned when the variable has
--not been set (affected) in the section

FUNCTION MeCellUseValue       /* INTERNAL */
(a_variable_name IN VARCHAR2,
 a_row           IN INTEGER,
 a_alt_value     IN NUMBER)
RETURN NUMBER IS

BEGIN

   IF a_variable_name = 'value_f' THEN
      IF UNICONNECT.P_CE_VALUE_F_MODTAB(a_row) THEN
         RETURN(UNICONNECT.P_CE_VALUE_F_TAB(a_row));
      END IF;
   ELSE
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'      Invalid variable '||a_variable_name||' in MeCellUseValue');
      RAISE StpError;
   END IF;
   RETURN(a_alt_value);

END MeCellUseValue;

FUNCTION MeCellUseValue       /* INTERNAL */
(a_variable_name IN VARCHAR2,
 a_row           IN INTEGER,
 a_alt_value     IN VARCHAR2)
RETURN VARCHAR2 IS

BEGIN

   IF a_variable_name = 'dsp_title' THEN
      IF UNICONNECT.P_CE_DSP_TITLE_MODTAB(a_row) THEN
         RETURN(UNICONNECT.P_CE_DSP_TITLE_TAB(a_row));
      END IF;
   ELSIF a_variable_name = 'value_s' THEN
      IF UNICONNECT.P_CE_VALUE_S_MODTAB(a_row) THEN
         RETURN(UNICONNECT.P_CE_VALUE_S_TAB(a_row));
      END IF;
   ELSIF a_variable_name = 'eq' THEN
      IF UNICONNECT.P_CE_EQ_MODTAB(a_row) THEN
         RETURN(UNICONNECT.P_CE_EQ_TAB(a_row));
      END IF;
   ELSIF a_variable_name = 'unit' THEN
      IF UNICONNECT.P_CE_UNIT_MODTAB(a_row) THEN
         RETURN(UNICONNECT.P_CE_UNIT_TAB(a_row));
      END IF;
   ELSE
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'      Invalid variable '||a_variable_name||' in MeCellUseValue');
      RAISE StpError;
   END IF;
   RETURN(a_alt_value);

END MeCellUseValue;

--FindScMeCell returns the utscmecell record corresponding
--to a specific search syntax
--See FindScPg for examples

FUNCTION FindScMeCell
                  (a_sc          IN     VARCHAR2,
                   a_pg          IN     VARCHAR2,
                   a_pgnode      IN     NUMBER,
                   a_pa          IN     VARCHAR2,
                   a_panode      IN     NUMBER,
                   a_me          IN     VARCHAR2,
                   a_menode      IN     NUMBER,
                   a_cell        IN OUT VARCHAR2,
                   a_description IN     VARCHAR2,
                   a_cellnode    IN     NUMBER,
                   a_search_base IN     VARCHAR2,
                   a_pos         IN INTEGER)
RETURN utscmecell%ROWTYPE IS

l_cell_rec     utscmecell%ROWTYPE;
l_leave_loop   BOOLEAN DEFAULT FALSE;
l_used         BOOLEAN DEFAULT FALSE;
l_counter      INTEGER;

CURSOR l_scmecell_cursor IS
   SELECT *
   FROM utscmecell
   WHERE sc = a_sc
   AND pg = NVL(a_pg, pg)
   AND pgnode = NVL(a_pgnode, pgnode)
   AND pa = NVL(a_pa, pa)
   AND panode = NVL(a_panode, panode)
   AND me = a_me
   AND menode = NVL(a_menode, menode)
   AND cell = a_cell
   AND cellnode = NVL(a_cellnode,cellnode)
   ORDER BY pgnode, panode, menode, cellnode;

CURSOR l_scmecelldesc_cursor IS
   SELECT *
   FROM utscmecell
   WHERE sc = a_sc
   AND pg = NVL(a_pg, pg)
   AND pgnode = NVL(a_pgnode, pgnode)
   AND pa = NVL(a_pa, pa)
   AND panode = NVL(a_panode, panode)
   AND me = a_me
   AND menode = NVL(a_menode, menode)
   AND dsp_title = a_description
   AND cellnode = NVL(a_cellnode,cellnode)
   ORDER BY pgnode, panode, menode, cellnode ASC;

BEGIN
   l_cell_rec := NULL;

   IF a_search_base = 'cell' THEN

      --find cell in xth position (x=a_pos)
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Searching for cell in position '||TO_CHAR(a_pos)||' for sc='||
                                             a_sc||
                                             '#pg='||a_pg||'#pgnode='||NVL(TO_CHAR(a_pgnode),'NULL')||
                                             '#pa='||a_pa||'#panode='||NVL(TO_CHAR(a_panode),'NULL')||
                                             '#me='||a_me||'#menode='||NVL(TO_CHAR(a_menode),'NULL')||
                                             '#cell='||a_cell||'#cellnode='||NVL(TO_CHAR(a_cellnode),'NULL'));
      OPEN l_scmecell_cursor;
      l_counter := 0;
      LOOP
         FETCH l_scmecell_cursor
         INTO l_cell_rec;
         EXIT WHEN l_scmecell_cursor%NOTFOUND;
         --check if cell/cellnode combination already used
         l_counter := l_counter + 1;
         IF l_counter >= a_pos THEN
            EXIT;
         ELSE
            l_cell_rec := NULL;
         END IF;
      END LOOP;
      CLOSE l_scmecell_cursor;

   ELSE

      --find me in xth position (x=a_pos)
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Searching for cell(dsp_title) in position '||TO_CHAR(a_pos)||' for sc='||
                                             a_sc||'#pg='||a_pg||'#pgnode='||NVL(TO_CHAR(a_pgnode),'NULL')||
                                             '#pa='||a_pa||'#panode='||NVL(TO_CHAR(a_panode),'NULL')||
                                             '#me='||a_me||'#menode='||NVL(TO_CHAR(a_menode),'NULL')||
                                             '#dsp_title='||a_description||'#cellnode='||NVL(TO_CHAR(a_cellnode),'NULL'));
      OPEN l_scmecelldesc_cursor;
      l_counter := 0;
      LOOP
         FETCH l_scmecelldesc_cursor
         INTO l_cell_rec;
         EXIT WHEN l_scmecelldesc_cursor%NOTFOUND;
         --check if cell/cellnode combination already used
         l_counter := l_counter + 1;
         IF l_counter >= a_pos THEN
            a_cell := l_cell_rec.me;
            EXIT;
         ELSE
            l_cell_rec := NULL;
         END IF;
      END LOOP;
      CLOSE l_scmecelldesc_cursor;

   END IF;

   RETURN (l_cell_rec);

END FindScMeCell;

PROCEDURE UCON_CleanupMeCellSection IS
BEGIN
   --Important since these variables should only
   --last for the execution of the [cell] section
   --but have to be implemented as global package variables
   --to keep it mantainable

   UNICONNECT.P_CE_SC_TAB.DELETE;
   UNICONNECT.P_CE_PG_TAB.DELETE;
   UNICONNECT.P_CE_PGNODE_TAB.DELETE;
   UNICONNECT.P_CE_PA_TAB.DELETE;
   UNICONNECT.P_CE_PANODE_TAB.DELETE;
   UNICONNECT.P_CE_ME_TAB.DELETE;
   UNICONNECT.P_CE_MENODE_TAB.DELETE;
   UNICONNECT.P_CE_REANALYSIS_TAB.DELETE;
   UNICONNECT.P_CE_CE_TAB.DELETE;
   UNICONNECT.P_CE_CENODE_TAB.DELETE;

   UNICONNECT.P_CE_CENAME_TAB.DELETE;
   UNICONNECT.P_CE_CEDESCRIPTION_TAB.DELETE;

   UNICONNECT.P_CE_DSP_TITLE_TAB.DELETE;
   UNICONNECT.P_CE_VALUE_F_TAB.DELETE;
   UNICONNECT.P_CE_VALUE_S_TAB.DELETE;
   UNICONNECT.P_CE_CELL_TP_TAB.DELETE;
   UNICONNECT.P_CE_POS_X_TAB.DELETE;
   UNICONNECT.P_CE_POS_Y_TAB.DELETE;
   UNICONNECT.P_CE_ALIGN_TAB.DELETE;
   UNICONNECT.P_CE_WINSIZE_X_TAB.DELETE;
   UNICONNECT.P_CE_WINSIZE_Y_TAB.DELETE;
   UNICONNECT.P_CE_IS_PROTECTED_TAB.DELETE;
   UNICONNECT.P_CE_MANDATORY_TAB.DELETE;
   UNICONNECT.P_CE_HIDDEN_TAB.DELETE;
   UNICONNECT.P_CE_UNIT_TAB.DELETE;
   UNICONNECT.P_CE_FORMAT_TAB.DELETE;
   UNICONNECT.P_CE_EQ_TAB.DELETE;
   UNICONNECT.P_CE_EQ_VERSION_TAB.DELETE;
   UNICONNECT.P_CE_COMPONENT_TAB.DELETE;
   UNICONNECT.P_CE_CALC_TP_TAB.DELETE;
   UNICONNECT.P_CE_CALC_FORMULA_TAB.DELETE;
   UNICONNECT.P_CE_VALID_CF_TAB.DELETE;
   UNICONNECT.P_CE_MAX_X_TAB.DELETE;
   UNICONNECT.P_CE_MAX_Y_TAB.DELETE;
   UNICONNECT.P_CE_MULTI_SELECT_TAB.DELETE;
   UNICONNECT.P_CE_MODIFY_FLAG_TAB.DELETE;

   UNICONNECT.P_CE_DSP_TITLE_MODTAB.DELETE;
   UNICONNECT.P_CE_VALUE_F_MODTAB.DELETE;
   UNICONNECT.P_CE_VALUE_S_MODTAB.DELETE;
   UNICONNECT.P_CE_EQ_MODTAB.DELETE;
   UNICONNECT.P_CE_UNIT_MODTAB.DELETE;

   UNICONNECT.P_CE_SC := NULL;
   UNICONNECT.P_CE_PG := NULL;
   UNICONNECT.P_CE_PGNAME := NULL;
   UNICONNECT.P_CE_PGDESCRIPTION := NULL;
   UNICONNECT.P_CE_PP_KEY1 := NULL;
   UNICONNECT.P_CE_PP_KEY1 := NULL;
   UNICONNECT.P_CE_PP_KEY1 := NULL;
   UNICONNECT.P_CE_PP_KEY1 := NULL;
   UNICONNECT.P_CE_PP_KEY1 := NULL;
   UNICONNECT.P_CE_PP_VERSION := NULL;
   UNICONNECT.P_CE_PGNODE := NULL;
   UNICONNECT.P_CE_PA := NULL;
   UNICONNECT.P_CE_PANAME := NULL;
   UNICONNECT.P_CE_PADESCRIPTION := NULL;
   UNICONNECT.P_CE_PANODE := NULL;
   UNICONNECT.P_CE_PR_VERSION := NULL;

   UNICONNECT.P_CE_ME := NULL;
   UNICONNECT.P_CE_MENAME := NULL;
   UNICONNECT.P_CE_MEDESCRIPTION := NULL;
   UNICONNECT.P_CE_MENODE := NULL;
   UNICONNECT.P_CE_MT_VERSION := NULL;

   UNICONNECT.P_CE_COMPLETED  := NULL;

   UNICONNECT.P_CE_MODIFY_REASON := NULL;

   UNICONNECT.P_CE_NR_OF_ROWS  := 0;

END UCON_CleanupMeCellSection;

FUNCTION UCON_ExecuteMeCellSection         /* INTERNAL */
RETURN NUMBER IS

l_sc                   VARCHAR2(20);
l_variable_name        VARCHAR2(20);
l_description_pos      INTEGER;
l_openbrackets_pos     INTEGER;
l_closebrackets_pos    INTEGER;
l_pg_pos               INTEGER;
l_pg_rec_found         utscpg%ROWTYPE;
l_pa_pos               INTEGER;
l_pa_rec_found         utscpa%ROWTYPE;
l_me_pos               INTEGER;
l_me_rec_found         utscme%ROWTYPE;
l_cell_pos             INTEGER;
l_cell_rec_found       utscmecell%ROWTYPE;
l_any_save             BOOLEAN DEFAULT FALSE;
l_used_api             VARCHAR2(30);
l_find_ce_row          INTEGER;
l_hold                 INTEGER;
l_internal_transaction BOOLEAN DEFAULT FALSE;

--Specific local variables for GetScMeCell
l_getce_nr_of_rows                  NUMBER;
l_getce_where_clause                VARCHAR2(511);
l_getce_next_rows                   NUMBER;
l_getce_sc_tab                      UNAPIGEN.VC20_TABLE_TYPE;
l_getce_pg_tab                      UNAPIGEN.VC20_TABLE_TYPE;
l_getce_pgnode_tab                  UNAPIGEN.LONG_TABLE_TYPE;
l_getce_pa_tab                      UNAPIGEN.VC20_TABLE_TYPE;
l_getce_panode_tab                  UNAPIGEN.LONG_TABLE_TYPE;
l_getce_me_tab                      UNAPIGEN.VC20_TABLE_TYPE;
l_getce_menode_tab                  UNAPIGEN.LONG_TABLE_TYPE;
l_getce_reanalysis_tab              UNAPIGEN.NUM_TABLE_TYPE;
l_getce_cell_tab                    UNAPIGEN.VC20_TABLE_TYPE;
l_getce_cellnode_tab                UNAPIGEN.LONG_TABLE_TYPE;
l_getce_dsp_title_tab               UNAPIGEN.VC40_TABLE_TYPE;
l_getce_value_f_tab                 UNAPIGEN.FLOAT_TABLE_TYPE;
l_getce_value_s_tab                 UNAPIGEN.VC40_TABLE_TYPE;
l_getce_cell_tp_tab                 UNAPIGEN.CHAR1_TABLE_TYPE;
l_getce_pos_x_tab                   UNAPIGEN.NUM_TABLE_TYPE;
l_getce_pos_y_tab                   UNAPIGEN.NUM_TABLE_TYPE;
l_getce_align_tab                   UNAPIGEN.CHAR1_TABLE_TYPE;
l_getce_winsize_x_tab               UNAPIGEN.NUM_TABLE_TYPE;
l_getce_winsize_y_tab               UNAPIGEN.NUM_TABLE_TYPE;
l_getce_is_protected_tab            UNAPIGEN.CHAR1_TABLE_TYPE;
l_getce_mandatory_tab               UNAPIGEN.CHAR1_TABLE_TYPE;
l_getce_hidden_tab                  UNAPIGEN.CHAR1_TABLE_TYPE;
l_getce_unit_tab                    UNAPIGEN.VC20_TABLE_TYPE;
l_getce_format_tab                  UNAPIGEN.VC40_TABLE_TYPE;
l_getce_eq_tab                      UNAPIGEN.VC20_TABLE_TYPE;
l_getce_eq_version_tab              UNAPIGEN.VC20_TABLE_TYPE;
l_getce_component_tab               UNAPIGEN.VC20_TABLE_TYPE;
l_getce_calc_tp_tab                 UNAPIGEN.CHAR1_TABLE_TYPE;
l_getce_calc_formula_tab            UNAPIGEN.VC2000_TABLE_TYPE;
l_getce_valid_cf_tab                UNAPIGEN.VC20_TABLE_TYPE;
l_getce_max_x_tab                   UNAPIGEN.NUM_TABLE_TYPE;
l_getce_max_y_tab                   UNAPIGEN.NUM_TABLE_TYPE;
l_getce_multi_select_tab            UNAPIGEN.CHAR1_TABLE_TYPE;
l_getce_reanalysedresult_tab        UNAPIGEN.CHAR1_TABLE_TYPE;

l_scme_sc                           UTSCME.sc%TYPE ;
l_scme_pg                           UTSCME.pg%TYPE ;
l_scme_pgnode                       UTSCME.pgnode%TYPE ;
l_scme_pa                           UTSCME.pa%TYPE ;
l_scme_panode                       UTSCME.panode%TYPE ;
l_scme_me                           UTSCME.me%TYPE ;
l_scme_menode                       UTSCME.menode%TYPE ;
l_scme_reanalysis                   UTSCME.reanalysis%TYPE ;
l_scme_exec_end_date                UTSCME.exec_end_Date%TYPE ;
l_scme_cursor                       integer ;

BEGIN

   --1. sc validation
   IF UNICONNECT.P_CE_SC IS NULL THEN
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : sample is mandatory for [cell] section !');
      RETURN(UNAPIGEN.DBERR_NOPARENTOBJECT);
   END IF;

   --2. sc modified in [cell] section ?
   --    NO    set global variable SC
   --    YES   verify if provided sample code exist :error when not + set global variable SC
   --    Copy sc in savescmecell array
   IF UNICONNECT.P_GLOB_SC <> UNICONNECT.P_CE_SC THEN
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Sc directly searched:'||UNICONNECT.P_CE_SC);
      OPEN l_sc_cursor(UNICONNECT.P_CE_SC);
      FETCH l_sc_cursor
      INTO l_sc;
      CLOSE l_sc_cursor;
      IF l_sc IS NULL THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : sc does not exist ! sc is mandatory for [cell] section !');
         RETURN(UNAPIGEN.DBERR_NOPARENTOBJECT);
      END IF;
      UNICONNECT.P_GLOB_SC := UNICONNECT.P_CE_SC;
   ELSE
      UNICONNECT.P_GLOB_SC := UNICONNECT.P_CE_SC;
   END IF;

   FOR l_row IN 1..UNICONNECT.P_CE_NR_OF_ROWS LOOP
      UNICONNECT.P_CE_SC_TAB(l_row) := UNICONNECT.P_GLOB_SC;
   END LOOP;

   -- suppressed due to a change request on 16/09/1999 (pg/pgnode are nomore mandatory)
   --
   --3. pg=NULL ?
   --   NO OK
   --   YES   Major error : me section without pg specified in a preceding section
   --IF UNICONNECT.P_CE_PG IS NULL AND
   --   UNICONNECT.P_CE_PGDESCRIPTION IS NULL THEN
   --   UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : pg is mandatory for [cell] section !');
   --   RETURN(UNAPIGEN.DBERR_NOPARENTOBJECT);
   --END IF;

   --4. pg or pgnode modified in [cell] section
   --   NO set global variables PG and PGNODE
   --   YES   verify if provided pg exist :error when not + set global variable PG and PGNODE
   --      PAY attention the pg[x],pg[] and .description are supported in this case
   --   Copy PG and PGNODE in savescmecell array
   IF UNICONNECT.P_CE_PGNAME IS NOT NULL THEN

      --description used ? -> find pp in utpp
      l_variable_name := NVL(UNICONNECT.P_CE_PGNAME, 'pg');
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
            l_pg_rec_found := UNICONNECT2.FindScPg(UNICONNECT.P_GLOB_SC,
                                       UNICONNECT.P_CE_PG, UNICONNECT.P_CE_PGDESCRIPTION,
                                       UNICONNECT.P_CE_PGNODE,
                                       UNICONNECT.P_CE_PP_KEY1, UNICONNECT.P_CE_PP_KEY2, UNICONNECT.P_CE_PP_KEY3, UNICONNECT.P_CE_PP_KEY4, UNICONNECT.P_CE_PP_KEY5,
                                       UNICONNECT.P_CE_PP_VERSION,
                                       'pg',         1, NULL);
         ELSE
            --pg.description used
            --passed pp_keys left blank since pgnode is mostly fixed at this point
            l_pg_rec_found := UNICONNECT2.FindScPg(UNICONNECT.P_GLOB_SC,
                                       UNICONNECT.P_CE_PG, UNICONNECT.P_CE_PGDESCRIPTION,
                                       UNICONNECT.P_CE_PGNODE,
                                       UNICONNECT.P_CE_PP_KEY1, UNICONNECT.P_CE_PP_KEY2, UNICONNECT.P_CE_PP_KEY3, UNICONNECT.P_CE_PP_KEY4, UNICONNECT.P_CE_PP_KEY5,
                                       UNICONNECT.P_CE_PP_VERSION,
                                       'description',        1, NULL);
         END IF;
      ELSE
         IF l_description_pos = 0 THEN
            --pg[x] or pg[x].pg used
            --passed pp_keys left blank since pgnode is mostly fixed at this point
            l_pg_rec_found := UNICONNECT2.FindScPg(UNICONNECT.P_GLOB_SC,
                                       UNICONNECT.P_CE_PG, UNICONNECT.P_CE_PGDESCRIPTION,
                                       UNICONNECT.P_CE_PGNODE,
                                       UNICONNECT.P_CE_PP_KEY1, UNICONNECT.P_CE_PP_KEY2, UNICONNECT.P_CE_PP_KEY3, UNICONNECT.P_CE_PP_KEY4, UNICONNECT.P_CE_PP_KEY5,
                                       UNICONNECT.P_CE_PP_VERSION,
                                       'pg', l_pg_pos, NULL);
         ELSE
            --pg[x].description used
            --passed pp_keys left blank since pgnode is mostly fixed at this point
            l_pg_rec_found := UNICONNECT2.FindScPg(UNICONNECT.P_GLOB_SC,
                                       UNICONNECT.P_CE_PG, UNICONNECT.P_CE_PGDESCRIPTION,
                                       UNICONNECT.P_CE_PGNODE,
                                       UNICONNECT.P_CE_PP_KEY1, UNICONNECT.P_CE_PP_KEY2, UNICONNECT.P_CE_PP_KEY3, UNICONNECT.P_CE_PP_KEY4, UNICONNECT.P_CE_PP_KEY5,
                                       UNICONNECT.P_CE_PP_VERSION,
                                       'description', l_pg_pos, NULL);
         END IF;
      END IF;

      IF l_pg_rec_found.pgnode IS NOT NULL THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         pg found:pg='||l_pg_rec_found.pg||'#pgnode='||l_pg_rec_found.pgnode);
         UNICONNECT.P_GLOB_PG := l_pg_rec_found.pg;
         UNICONNECT.P_GLOB_PGNODE := l_pg_rec_found.pgnode;
      ELSE
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : pg not found ! pg is mandatory for [cell] section !');
         RETURN(UNAPIGEN.DBERR_NOPARENTOBJECT);
      END IF;

   ELSE
      UNICONNECT.P_GLOB_PG := UNICONNECT.P_CE_PG;
      UNICONNECT.P_GLOB_PGNODE := UNICONNECT.P_CE_PGNODE;
   END IF;

   FOR l_row IN 1..UNICONNECT.P_CE_NR_OF_ROWS LOOP
      UNICONNECT.P_CE_PG_TAB(l_row) := UNICONNECT.P_GLOB_PG;
      UNICONNECT.P_CE_PGNODE_TAB(l_row) := UNICONNECT.P_GLOB_PGNODE;
   END LOOP;

   -- suppressed due to a change request on 16/09/1999 (pg/pgnode are nomore mandatory)
   --
   --5. pa=NULL ?
   --   NO OK
   --   YES   Major error : me section without pa specified in a preceding section
   --IF UNICONNECT.P_CE_PA IS NULL AND
   --   UNICONNECT.P_CE_PADESCRIPTION IS NULL THEN
   --   UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : pa is mandatory for [cell] section !');
   --   RETURN(UNAPIGEN.DBERR_NOPARENTOBJECT);
   --END IF;

   --6. pa or panode modified in [cell] section
   --   NO set global variables PA and PANODE
   --   YES   verify if provided pa exist :error when not + set global variable PA and PANODE
   --      PAY attention the pa[x],pa[] and .description are supported in this case
   --   Copy PA and PANODE in savescmecell array
   IF UNICONNECT.P_CE_PANAME IS NOT NULL THEN

      --description used ? -> find pr in utpr
      l_variable_name := NVL(UNICONNECT.P_CE_PANAME, 'pa');
      l_description_pos := INSTR(l_variable_name, '.description');
      l_openbrackets_pos := INSTR(l_variable_name, '[');
      l_closebrackets_pos := INSTR(l_variable_name, ']');
      l_pa_pos := TO_NUMBER(SUBSTR(l_variable_name,l_openbrackets_pos+1,l_closebrackets_pos-l_openbrackets_pos-1));

      UNICONNECT.P_PA_NR_OF_ROWS := 0; --to be sure pa arrays are not searched
      l_pa_rec_found := NULL;

      IF l_openbrackets_pos = 0 THEN
         IF l_description_pos = 0 THEN
            --pa or pa.pa used
            l_pa_rec_found := UNICONNECT2.FindScPa(UNICONNECT.P_GLOB_SC,
                                       UNICONNECT.P_GLOB_PG, UNICONNECT.P_GLOB_PGNODE,
                                       UNICONNECT.P_CE_PP_KEY1, UNICONNECT.P_CE_PP_KEY2, UNICONNECT.P_CE_PP_KEY3, UNICONNECT.P_CE_PP_KEY4, UNICONNECT.P_CE_PP_KEY5,
                                       UNICONNECT.P_CE_PP_VERSION,
                                       UNICONNECT.P_CE_PA, UNICONNECT.P_CE_PADESCRIPTION,
                                       UNICONNECT.P_CE_PANODE, UNICONNECT.P_CE_PR_VERSION,
                                       'pa',         1, NULL);
         ELSE
            --pa.description used
            l_pa_rec_found := UNICONNECT2.FindScPa(UNICONNECT.P_GLOB_SC,
                                       UNICONNECT.P_GLOB_PG, UNICONNECT.P_GLOB_PGNODE,
                                       UNICONNECT.P_CE_PP_KEY1, UNICONNECT.P_CE_PP_KEY2, UNICONNECT.P_CE_PP_KEY3, UNICONNECT.P_CE_PP_KEY4, UNICONNECT.P_CE_PP_KEY5,
                                       UNICONNECT.P_CE_PP_VERSION,
                                       UNICONNECT.P_CE_PA, UNICONNECT.P_CE_PADESCRIPTION,
                                       UNICONNECT.P_CE_PANODE, UNICONNECT.P_CE_PR_VERSION,
                                       'description',        1, NULL);
         END IF;
      ELSE
         IF l_description_pos = 0 THEN
            --pa[x] or pa[x].pa used
            l_pa_rec_found := UNICONNECT2.FindScPa(UNICONNECT.P_GLOB_SC,
                                       UNICONNECT.P_GLOB_PG, UNICONNECT.P_GLOB_PGNODE,
                                       UNICONNECT.P_CE_PP_KEY1, UNICONNECT.P_CE_PP_KEY2, UNICONNECT.P_CE_PP_KEY3, UNICONNECT.P_CE_PP_KEY4, UNICONNECT.P_CE_PP_KEY5,
                                       UNICONNECT.P_CE_PP_VERSION,
                                       UNICONNECT.P_CE_PA, UNICONNECT.P_CE_PADESCRIPTION,
                                       UNICONNECT.P_CE_PANODE, UNICONNECT.P_CE_PR_VERSION,
                                       'pa', l_pa_pos, NULL);
         ELSE
            --pa[x].description used
            l_pa_rec_found := UNICONNECT2.FindScPa(UNICONNECT.P_GLOB_SC,
                                       UNICONNECT.P_GLOB_PG, UNICONNECT.P_GLOB_PGNODE,
                                       UNICONNECT.P_CE_PP_KEY1, UNICONNECT.P_CE_PP_KEY2, UNICONNECT.P_CE_PP_KEY3, UNICONNECT.P_CE_PP_KEY4, UNICONNECT.P_CE_PP_KEY5,
                                       UNICONNECT.P_CE_PP_VERSION,
                                       UNICONNECT.P_CE_PA, UNICONNECT.P_CE_PADESCRIPTION,
                                       UNICONNECT.P_CE_PANODE, UNICONNECT.P_CE_PR_VERSION,
                                       'description', l_pa_pos, NULL);
         END IF;
      END IF;

      IF l_pa_rec_found.panode IS NOT NULL THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         pa found:pa='||l_pa_rec_found.pa||'#panode='||l_pa_rec_found.panode);
         UNICONNECT.P_GLOB_PA := l_pa_rec_found.pa;
         UNICONNECT.P_GLOB_PANODE := l_pa_rec_found.panode;
      ELSE
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : pa not found ! pa is mandatory for [cell] section !');
         RETURN(UNAPIGEN.DBERR_NOPARENTOBJECT);
      END IF;

   ELSE
      UNICONNECT.P_GLOB_PA := UNICONNECT.P_CE_PA;
      UNICONNECT.P_GLOB_PANODE := UNICONNECT.P_CE_PANODE;
   END IF;

   FOR l_row IN 1..UNICONNECT.P_CE_NR_OF_ROWS LOOP
      UNICONNECT.P_CE_PA_TAB(l_row) := UNICONNECT.P_GLOB_PA;
      UNICONNECT.P_CE_PANODE_TAB(l_row) := UNICONNECT.P_GLOB_PANODE;
   END LOOP;

   --7. me=NULL ?
   --   NO OK
   --   YES   Major error : cell section without me specified in a preceding section
   IF UNICONNECT.P_CE_ME IS NULL AND
      UNICONNECT.P_CE_MEDESCRIPTION IS NULL THEN
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : me is mandatory for [cell] section !');
      RETURN(UNAPIGEN.DBERR_NOPARENTOBJECT);
   END IF;

   --8. me or menode modified in [cell] section
   --   NO set global varaibles ME and MENODE
   --   YES   verify if provided me exist :error when not + set global variable ME and MENODE
   --      PAY attention the me[x],me[] and .description are supported in this case
   --   Copy ME and MENODE in savescmecell array
   IF UNICONNECT.P_CE_MENAME IS NOT NULL THEN

      --description used ? -> find mt in utmt
      l_variable_name := NVL(UNICONNECT.P_CE_MENAME, 'me');
      l_description_pos := INSTR(l_variable_name, '.description');
      l_openbrackets_pos := INSTR(l_variable_name, '[');
      l_closebrackets_pos := INSTR(l_variable_name, ']');
      l_me_pos := TO_NUMBER(SUBSTR(l_variable_name,l_openbrackets_pos+1,l_closebrackets_pos-l_openbrackets_pos-1));

      UNICONNECT.P_ME_NR_OF_ROWS := 0; --to be sure me arrays are not searched
      l_me_rec_found := NULL;

      IF l_openbrackets_pos = 0 THEN
         IF l_description_pos = 0 THEN
            --me or me.me used
            l_me_rec_found := UNICONNECT3.FindScMe(UNICONNECT.P_GLOB_SC,
                                       UNICONNECT.P_GLOB_PG, UNICONNECT.P_GLOB_PGNODE,
                                       UNICONNECT.P_CE_PP_KEY1, UNICONNECT.P_CE_PP_KEY2, UNICONNECT.P_CE_PP_KEY3, UNICONNECT.P_CE_PP_KEY4, UNICONNECT.P_CE_PP_KEY5,
                                       UNICONNECT.P_CE_PP_VERSION,
                                       UNICONNECT.P_GLOB_PA, UNICONNECT.P_GLOB_PANODE,
                                       UNICONNECT.P_CE_PR_VERSION,
                                       UNICONNECT.P_CE_ME, UNICONNECT.P_CE_MEDESCRIPTION,
                                       UNICONNECT.P_CE_MENODE, UNICONNECT.P_CE_MT_VERSION,
                                       'me',          1, NULL);
         ELSE
            --me.description used
            l_me_rec_found := UNICONNECT3.FindScMe(UNICONNECT.P_GLOB_SC,
                                       UNICONNECT.P_GLOB_PG, UNICONNECT.P_GLOB_PGNODE,
                                       UNICONNECT.P_CE_PP_KEY1, UNICONNECT.P_CE_PP_KEY2, UNICONNECT.P_CE_PP_KEY3, UNICONNECT.P_CE_PP_KEY4, UNICONNECT.P_CE_PP_KEY5,
                                       UNICONNECT.P_CE_PP_VERSION,
                                       UNICONNECT.P_GLOB_PA, UNICONNECT.P_GLOB_PANODE,
                                       UNICONNECT.P_CE_PR_VERSION,
                                       UNICONNECT.P_CE_ME, UNICONNECT.P_CE_MEDESCRIPTION,
                                       UNICONNECT.P_CE_MENODE, UNICONNECT.P_CE_MT_VERSION,
                                       'description', 1, NULL);
         END IF;
      ELSE
         IF l_description_pos = 0 THEN
            --me[x] or me[x].me used
            l_me_rec_found := UNICONNECT3.FindScMe(UNICONNECT.P_GLOB_SC,
                                       UNICONNECT.P_GLOB_PG, UNICONNECT.P_GLOB_PGNODE,
                                       UNICONNECT.P_CE_PP_KEY1, UNICONNECT.P_CE_PP_KEY2, UNICONNECT.P_CE_PP_KEY3, UNICONNECT.P_CE_PP_KEY4, UNICONNECT.P_CE_PP_KEY5,
                                       UNICONNECT.P_CE_PP_VERSION,
                                       UNICONNECT.P_GLOB_PA, UNICONNECT.P_GLOB_PANODE,
                                       UNICONNECT.P_CE_PR_VERSION,
                                       UNICONNECT.P_CE_ME, UNICONNECT.P_CE_MEDESCRIPTION,
                                       UNICONNECT.P_CE_MENODE, UNICONNECT.P_CE_MT_VERSION,
                                       'me',   l_me_pos, NULL);
         ELSE
            --me[x].description used
            l_me_rec_found := UNICONNECT3.FindScMe(UNICONNECT.P_GLOB_SC,
                                       UNICONNECT.P_GLOB_PG, UNICONNECT.P_GLOB_PGNODE,
                                       UNICONNECT.P_CE_PP_KEY1, UNICONNECT.P_CE_PP_KEY2, UNICONNECT.P_CE_PP_KEY3, UNICONNECT.P_CE_PP_KEY4, UNICONNECT.P_CE_PP_KEY5,
                                       UNICONNECT.P_CE_PP_VERSION,
                                       UNICONNECT.P_GLOB_PA, UNICONNECT.P_GLOB_PANODE,
                                       UNICONNECT.P_CE_PR_VERSION,
                                       UNICONNECT.P_CE_ME, UNICONNECT.P_CE_MEDESCRIPTION,
                                       UNICONNECT.P_CE_MENODE, UNICONNECT.P_CE_MT_VERSION,
                                       'description', l_me_pos, NULL);
         END IF;
      END IF;

      IF l_me_rec_found.menode IS NOT NULL THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         me found:me='||l_me_rec_found.me||'#menode='||l_me_rec_found.menode);
         UNICONNECT.P_GLOB_ME := l_me_rec_found.me;
         UNICONNECT.P_GLOB_MENODE := l_me_rec_found.menode;
      ELSE
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : me not found ! me is mandatory for [cell] section !');
         RETURN(UNAPIGEN.DBERR_NOPARENTOBJECT);
      END IF;

   ELSE
      UNICONNECT.P_GLOB_ME := UNICONNECT.P_CE_ME;
      UNICONNECT.P_GLOB_MENODE := UNICONNECT.P_CE_MENODE;
   END IF;

   FOR l_row IN 1..UNICONNECT.P_CE_NR_OF_ROWS LOOP
      UNICONNECT.P_CE_ME_TAB(l_row) := UNICONNECT.P_GLOB_ME;
      UNICONNECT.P_CE_MENODE_TAB(l_row) := UNICONNECT.P_GLOB_MENODE;
   END LOOP;

   --9. any cell specified ?
   --   YES   do nothing
   --   NO Major error : cell is mandatory in a [cell] section
   IF UNICONNECT.P_CE_NR_OF_ROWS = 0 THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : cell is mandatory for [cell] section !');
         RETURN(UNAPIGEN.DBERR_NOOBJID);
   ELSE
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         '||UNICONNECT.P_CE_NR_OF_ROWS||' cells in [cell] section');
   END IF;

   --10. Call GetScMeCell and store the returned cell in a different local array (will create the cells when necessary)
   --   when no cells are found and PG|PA is NULL => pg / and pa / are not created : can be done by preceding the cell section by a method section
   --   Copy found PG/PGNODE/PA/PANODE in SaveScMeCell for the same reason
   --   LOOP through all cell array
   --        Initialise SaveScMeCell array variables with the values coming
   --               from the GetScMeCell or from the section
   --                       (Values from the section will overrule the value from the record)
   --      END LOOP
   l_getce_where_clause := 'WHERE sc = '''||UNICONNECT.P_GLOB_SC ||''' AND ';

   IF UNICONNECT.P_GLOB_PG IS NOT NULL THEN
      l_getce_where_clause := l_getce_where_clause ||
                              ' pg='''||UNICONNECT.P_GLOB_PG ||''' AND pgnode=' ||TO_CHAR(UNICONNECT.P_GLOB_PGNODE)||' AND ';

   ELSIF l_me_rec_found.menode IS NOT NULL THEN
      l_getce_where_clause := l_getce_where_clause ||
                              ' pg='''|| l_me_rec_found.pg ||''' AND pgnode=' ||TO_CHAR(l_me_rec_found.pgnode)||' AND ';

   END IF;
   IF UNICONNECT.P_GLOB_PA IS NOT NULL THEN
      l_getce_where_clause := l_getce_where_clause ||
                              ' pa='''||UNICONNECT.P_GLOB_PA ||''' AND panode=' ||TO_CHAR(UNICONNECT.P_GLOB_PANODE)||' AND ';

   ELSIF l_me_rec_found.menode IS NOT NULL THEN
      l_getce_where_clause := l_getce_where_clause ||
                              ' pa='''|| l_me_rec_found.pa ||''' AND panode=' ||TO_CHAR(l_me_rec_found.panode)||' AND ';

   END IF;

   l_getce_where_clause := l_getce_where_clause ||
                           ' me='''||UNICONNECT.P_GLOB_ME ||''' AND menode=' ||TO_CHAR(UNICONNECT.P_GLOB_MENODE)||' ORDER BY pgnode,panode, menode';

   l_sql_string := 'SELECT sc, pg, pgnode, pa, panode, me, menode, reanalysis, exec_end_date FROM utscme ' || l_getce_where_clause ;

   BEGIN -- Fetch method properties.
      l_scme_cursor := DBMS_SQL.OPEN_CURSOR;

      DBMS_SQL.PARSE (l_scme_cursor, l_sql_string, DBMS_SQL.V7);

      DBMS_SQL.DEFINE_COLUMN(l_scme_cursor,      1, l_scme_sc, 20);
      DBMS_SQL.DEFINE_COLUMN(l_scme_cursor,      2, l_scme_pg, 20);
      DBMS_SQL.DEFINE_COLUMN(l_scme_cursor,      3, l_scme_pgnode);
      DBMS_SQL.DEFINE_COLUMN(l_scme_cursor,      4, l_scme_pa, 20);
      DBMS_SQL.DEFINE_COLUMN(l_scme_cursor,      5, l_scme_panode);
      DBMS_SQL.DEFINE_COLUMN(l_scme_cursor,      6, l_scme_me, 20);
      DBMS_SQL.DEFINE_COLUMN(l_scme_cursor,      7, l_scme_menode);
      DBMS_SQL.DEFINE_COLUMN(l_scme_cursor,      8, l_scme_reanalysis);
      DBMS_SQL.DEFINE_COLUMN(l_scme_cursor,      9, l_scme_exec_end_date);
      l_result := DBMS_SQL.EXECUTE_AND_FETCH(l_scme_cursor);

      IF l_result = 0 THEN
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : me not found in [cell] section');
            l_ret_code := UNAPIGEN.DBERR_GENFAIL;
            DBMS_SQL.CLOSE_CURSOR(l_scme_cursor);
            RAISE StpError;
      END IF ;

      DBMS_SQL.COLUMN_VALUE(l_scme_cursor,      1, l_scme_sc);
      DBMS_SQL.COLUMN_VALUE(l_scme_cursor,      2, l_scme_pg);
      DBMS_SQL.COLUMN_VALUE(l_scme_cursor,      3, l_scme_pgnode);
      DBMS_SQL.COLUMN_VALUE(l_scme_cursor,      4, l_scme_pa);
      DBMS_SQL.COLUMN_VALUE(l_scme_cursor,      5, l_scme_panode);
      DBMS_SQL.COLUMN_VALUE(l_scme_cursor,      6, l_scme_me);
      DBMS_SQL.COLUMN_VALUE(l_scme_cursor,      7, l_scme_menode);
      DBMS_SQL.COLUMN_VALUE(l_scme_cursor,      8, l_scme_reanalysis);
      DBMS_SQL.COLUMN_VALUE(l_scme_cursor,      9, l_scme_exec_end_date);

      DBMS_SQL.CLOSE_CURSOR(l_scme_cursor);
   EXCEPTION
   WHEN OTHERS THEN
      l_sqlerrm := SQLERRM;

      IF DBMS_SQL.IS_OPEN (l_scme_cursor) THEN
         DBMS_SQL.CLOSE_CURSOR (l_scme_cursor);
      END IF;

      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : Exception while retrieving me in [cell] section');
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'           ' ||  l_sqlerrm);
      l_ret_code := UNAPIGEN.DBERR_GENFAIL;
      RAISE StpError;
   END ;

   IF l_scme_exec_end_date IS NOT NULL THEN
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         me already executed');
      IF UNICONNECT.P_SET_ALLOW_REANALYSIS = 'N' THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : me already executed, new result in [cell] section AND no reanalysis authorised !');
         l_ret_code := UNAPIGEN.DBERR_GENFAIL;
         RAISE StpError;
      ELSE
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         me already executed and new me result in [cell] section => me reanalysis');
         l_ret_code := UNAPIMEP.ReanalScMethod(l_scme_sc,
                                               l_scme_pg,
                                               l_scme_pgnode,
                                               l_scme_pa,
                                               l_scme_panode,
                                               l_scme_me,
                                               l_scme_menode,
                                               l_scme_reanalysis,
                                               'Uniconnect : new result for this method');
         IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : ReanalScMethod failed ret_code : '||l_ret_code ||
                                           '#sc='||l_scme_sc||
                                           '#pg='||l_scme_pg||
                                           '#pgnode='||l_scme_pgnode||
                                           '#pa='||l_scme_pa||
                                           '#panode='||l_scme_panode||
                                           '#me='||l_scme_me||
                                           '#menode='||l_scme_menode||
                                           '#reanalysis='||l_scme_reanalysis);
            RAISE StpError;
         ELSE
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         OK : ReanalScMethod performed' );
         END IF;
      END IF ;
   ELSE
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         me not yet executed');
   END IF ;

   l_getce_nr_of_rows := UNAPIGEN.P_MAX_CHUNK_SIZE;
   l_getce_next_rows := 0;

   --successive calls for SaveScMeCell (next_rows = 0, 1, 1, ... -1)  must be within
   --one transaction (a transaction must be started when not yet started in this function
   --this transaction will enclose the 2 SaveScMeCell api calls

   IF UNAPIGEN.P_TXN_LEVEL = 0 THEN
      l_return := UNAPIGEN.BeginTransaction;
      IF l_return <> UNAPIGEN.DBERR_SUCCESS THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         UNAPIGEN.BeginTransaction failed ! ret_code='||TO_CHAR(l_return));
      END IF;
      l_internal_transaction := TRUE;
   ELSE
      l_internal_transaction := FALSE;
   END IF;

   BEGIN

      l_ret_code := UNAPIME.GETSCMECELL
                   (l_getce_sc_tab,
                    l_getce_pg_tab,
                    l_getce_pgnode_tab,
                    l_getce_pa_tab,
                    l_getce_panode_tab,
                    l_getce_me_tab,
                    l_getce_menode_tab,
                    l_getce_reanalysis_tab,
                    l_getce_cell_tab,
                    l_getce_cellnode_tab,
                    l_getce_dsp_title_tab,
                    l_getce_value_f_tab,
                    l_getce_value_s_tab,
                    l_getce_cell_tp_tab,
                    l_getce_pos_x_tab,
                    l_getce_pos_y_tab,
                    l_getce_align_tab,
                    l_getce_winsize_x_tab,
                    l_getce_winsize_y_tab,
                    l_getce_is_protected_tab,
                    l_getce_mandatory_tab,
                    l_getce_hidden_tab,
                    l_getce_unit_tab,
                    l_getce_format_tab,
                    l_getce_eq_tab,
                    l_getce_eq_version_tab,
                    l_getce_component_tab,
                    l_getce_calc_tp_tab,
                    l_getce_calc_formula_tab,
                    l_getce_valid_cf_tab,
                    l_getce_max_x_tab,
                    l_getce_max_y_tab,
                    l_getce_multi_select_tab,
                    l_getce_reanalysedresult_tab,
                    l_getce_nr_of_rows,
                    l_getce_where_clause,
                    l_getce_next_rows);

      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         IF l_ret_code <> UNAPIGEN.DBERR_NORECORDS THEN
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : GetScMeCell ret_code : '||l_ret_code|| ' used where clause:' );
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         '||l_getce_where_clause );
            RAISE StpError;
         ELSE
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : No cells for this method ! (check utmtcell)' );
            RAISE StpError;
         END IF;
      ELSE
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         OK : GetScMeCell performed (will create the cells when not existing)' );
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         nr_of_rows returned '||l_getce_nr_of_rows );
      END IF;

      FOR l_row IN 1..UNICONNECT.P_CE_NR_OF_ROWS LOOP

         --find corresponding record in l_getce array (cellnode can be specified or not)
         --initialise SaveScMeCell array with fetched values when not set in section
         l_find_ce_row := 0;
         FOR l_getrow IN 1..l_getce_nr_of_rows LOOP
            IF l_getce_cell_tab(l_getrow) = UNICONNECT.P_CE_CE_TAB(l_row) OR
               l_getce_dsp_title_tab(l_getrow) = UNICONNECT.P_CE_CEDESCRIPTION_TAB(l_row) THEN
               --cell description was provided but id is empty
               IF l_getce_dsp_title_tab(l_getrow) = UNICONNECT.P_CE_CEDESCRIPTION_TAB(l_row) AND
                  UNICONNECT.P_CE_CE_TAB(l_row) IS NULL THEN
                  UNICONNECT.P_CE_CE_TAB(l_row) := l_getce_cell_tab(l_getrow);
               END IF;
               IF UNICONNECT.P_CE_CENODE_TAB(l_row) IS NULL THEN
                  l_find_ce_row := l_getrow;
                  EXIT;
               ELSE
                  --check also the provided node
                  IF UNICONNECT.P_CE_CENODE_TAB(l_row) = l_getce_cellnode_tab(l_getrow) THEN
                     l_find_ce_row := l_getrow;
                     EXIT;
                  END IF;
               END IF;
            END IF;
         END LOOP;

         IF l_find_ce_row = 0 THEN
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : No cell=' || UNICONNECT.P_CE_CE_TAB(l_row) ||
                                                  ' (optional cellnode=' || TO_CHAR(UNICONNECT.P_CE_CENODE_TAB(l_row)) ||
                                                  ') in me : '||UNICONNECT.P_CE_ME_TAB(l_row));
            RAISE StpError;
         END IF;

         --always set
         --Copy found PG/PGNODE/PA/PANODE in SaveScMeCell for the same reason

         UNICONNECT.P_CE_PG_TAB(l_row)                      := l_getce_pg_tab(l_find_ce_row);
         UNICONNECT.P_CE_PGNODE_TAB(l_row)                  := l_getce_pgnode_tab(l_find_ce_row);
         UNICONNECT.P_CE_PA_TAB(l_row)                      := l_getce_pa_tab(l_find_ce_row);
         UNICONNECT.P_CE_PANODE_TAB(l_row)                  := l_getce_panode_tab(l_find_ce_row);
         UNICONNECT.P_CE_REANALYSIS_TAB(l_row)              := l_getce_reanalysis_tab(l_find_ce_row);

         UNICONNECT.P_CE_CENODE_TAB(l_row)                  := l_getce_cellnode_tab(l_find_ce_row);
         UNICONNECT.P_CE_CELL_TP_TAB(l_row)                 := l_getce_cell_tp_tab(l_find_ce_row);
         UNICONNECT.P_CE_POS_X_TAB(l_row)                   := l_getce_pos_x_tab(l_find_ce_row);
         UNICONNECT.P_CE_POS_Y_TAB(l_row)                   := l_getce_pos_y_tab(l_find_ce_row);
         UNICONNECT.P_CE_ALIGN_TAB(l_row)                   := l_getce_align_tab(l_find_ce_row);
         UNICONNECT.P_CE_WINSIZE_X_TAB(l_row)               := l_getce_winsize_x_tab(l_find_ce_row);
         UNICONNECT.P_CE_WINSIZE_Y_TAB(l_row)               := l_getce_winsize_y_tab(l_find_ce_row);
         UNICONNECT.P_CE_IS_PROTECTED_TAB(l_row)            := l_getce_is_protected_tab(l_find_ce_row);
         UNICONNECT.P_CE_MANDATORY_TAB(l_row)               := l_getce_mandatory_tab(l_find_ce_row);
         UNICONNECT.P_CE_HIDDEN_TAB(l_row)                  := l_getce_hidden_tab(l_find_ce_row);
         UNICONNECT.P_CE_FORMAT_TAB(l_row)                  := l_getce_format_tab(l_find_ce_row);
         UNICONNECT.P_CE_EQ_VERSION_TAB(l_row)              := l_getce_eq_version_tab(l_find_ce_row);
         UNICONNECT.P_CE_COMPONENT_TAB(l_row)               := l_getce_component_tab(l_find_ce_row);
         UNICONNECT.P_CE_CALC_TP_TAB(l_row)                 := l_getce_calc_tp_tab(l_find_ce_row);
         UNICONNECT.P_CE_CALC_FORMULA_TAB(l_row)            := l_getce_calc_formula_tab(l_find_ce_row);
         UNICONNECT.P_CE_VALID_CF_TAB(l_row)                := l_getce_valid_cf_tab(l_find_ce_row);
         UNICONNECT.P_CE_MAX_X_TAB(l_row)                   := l_getce_max_x_tab(l_find_ce_row);
         UNICONNECT.P_CE_MAX_Y_TAB(l_row)                   := l_getce_max_y_tab(l_find_ce_row);
         UNICONNECT.P_CE_MULTI_SELECT_TAB(l_row)            := l_getce_multi_select_tab(l_find_ce_row);

         --only when not set in section
         UNICONNECT.P_CE_DSP_TITLE_TAB(l_row)        := MeCellUseValue('dsp_title'     , l_row, l_getce_dsp_title_tab(l_find_ce_row));
         UNICONNECT.P_CE_EQ_TAB(l_row)               := MeCellUseValue('eq'            , l_row, l_getce_eq_tab(l_find_ce_row));
         UNICONNECT.P_CE_UNIT_TAB(l_row)             := MeCellUseValue('unit'          , l_row, l_getce_unit_tab(l_find_ce_row));

         --Special rule for value_f and value_s :
         --Rule : when only value_f specified => value_s from record nomore used
         --          when only value_s specified => value_f from record nomore used
         --          when value_s AND value_f specified => all values from record ignored
         IF UNICONNECT.P_CE_VALUE_F_MODTAB(l_row) THEN
            IF UNICONNECT.P_CE_VALUE_S_MODTAB(l_row) THEN
               NULL;
            ELSE
               l_getce_value_s_tab(l_find_ce_row) := NULL;
            END IF;
         ELSIF UNICONNECT.P_CE_VALUE_S_MODTAB(l_row) THEN
            l_getce_value_f_tab(l_find_ce_row) := NULL;
         END IF;

         --Try to format value_f since SaveScMeCell is not formatting it
         BEGIN
            IF UNICONNECT.P_CE_VALUE_F_MODTAB(l_row) THEN
               IF UNICONNECT.P_CE_VALUE_S_MODTAB(l_row) THEN
                  NULL;
               ELSE
                  IF SUBSTR(UNICONNECT.P_CE_FORMAT_TAB(l_row), 1, 1) = 'C' THEN
                     IF UNICONNECT.P_CE_FORMAT_TAB(l_row) = 'C' THEN
                        UNICONNECT.P_CE_VALUE_S_TAB(l_row) := UNICONNECT.P_CE_VALUE_F_TAB(l_row);
                     ELSE
                        UNICONNECT.P_CE_VALUE_S_TAB(l_row) := SUBSTR(UNICONNECT.P_CE_VALUE_F_TAB(l_row),1,TO_NUMBER(SUBSTR(UNICONNECT.P_CE_FORMAT_TAB(l_row), 2)));
                     END IF;
                  ELSIF SUBSTR(UNICONNECT.P_CE_FORMAT_TAB(l_row), 1, 1) = 'D' THEN
                     UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NORMAL,'         Warning : value_f can not be converted to a DATE' );

                  ELSE
                     l_result := UNAPIGEN.FormatResult(UNICONNECT.P_CE_VALUE_F_TAB(l_row),
                                                       UNICONNECT.P_CE_FORMAT_TAB(l_row),
                                                       UNICONNECT.P_CE_VALUE_S_TAB(l_row));
                     IF l_result <> UNAPIGEN.DBERR_SUCCESS THEN
                        UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NORMAL,'         Warning : FormatResult failed '||l_result );

                     END IF;
                  END IF;
                  --Force using the formatted value
                  UNICONNECT.P_CE_VALUE_S_MODTAB(l_row) := TRUE;
               END IF;
            ELSIF UNICONNECT.P_CE_VALUE_S_MODTAB(l_row) THEN

               --Special rule for value_f and value_s :
               --Rule : when only value_f specified => value_s from record nomore used
               --          when only value_s specified => value_f from record nomore used
               --          when value_s AND value_f specified => all values from record ignored
               l_ret_code := UNICONNECT6.SpecialRulesForValues(UNICONNECT.P_CE_VALUE_S_MODTAB(l_row),
                                                               UNICONNECT.P_CE_VALUE_S_TAB(l_row),
                                                               UNICONNECT.P_CE_VALUE_F_MODTAB(l_row),
                                                               UNICONNECT.P_CE_VALUE_F_TAB(l_row),
                                                               l_getce_format_tab(l_find_ce_row),
                                                               l_getce_value_s_tab(l_find_ce_row),
                                                               l_getce_value_f_tab(l_find_ce_row));
               IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
                  UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_HIGH,'         ret_code='||TO_CHAR(l_ret_code)||
                                                        ' returned by UNICONNECT6.SpecialRulesForValues#value_s='||
                                                        UNICONNECT.P_CE_VALUE_S_TAB(l_row)||'#value_f='||
                                                        TO_CHAR(UNICONNECT.P_CE_VALUE_F_TAB(l_row))||
                                                        '#format='||l_getce_format_tab(l_find_ce_row));
                  RAISE StpError;

               END IF;

               BEGIN
                  --Retsore implicit conversion when no special rule found
                  IF l_getce_value_f_tab(l_find_ce_row) IS NULL THEN
                     l_getce_value_f_tab(l_find_ce_row) := UNICONNECT.P_CE_VALUE_S_TAB(l_row);
                  END IF;
               EXCEPTION
               WHEN VALUE_ERROR THEN
                  UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Info, implicit conversion failed for code='||
                                                        UNICONNECT.P_CE_VALUE_S_TAB(l_row));
               END;

            END IF;
         EXCEPTION
         WHEN VALUE_ERROR THEN
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NORMAL,'         Warning : VALUE_ERROR exception catched and ignored' );
         END;

         UNICONNECT.P_CE_VALUE_F_TAB(l_row)          := MeCellUseValue('value_f'       , l_row, l_getce_value_f_tab(l_find_ce_row));
         UNICONNECT.P_CE_VALUE_S_TAB(l_row)          := MeCellUseValue('value_s'       , l_row, l_getce_value_s_tab(l_find_ce_row));

      END LOOP;

      --close the open cursor with next_rows=-1
      l_getce_next_rows := -1;

      l_ret_code := UNAPIME.GETSCMECELL
                   (l_getce_sc_tab,
                    l_getce_pg_tab,
                    l_getce_pgnode_tab,
                    l_getce_pa_tab,
                    l_getce_panode_tab,
                    l_getce_me_tab,
                    l_getce_menode_tab,
                    l_getce_reanalysis_tab,
                    l_getce_cell_tab,
                    l_getce_cellnode_tab,
                    l_getce_dsp_title_tab,
                    l_getce_value_f_tab,
                    l_getce_value_s_tab,
                    l_getce_cell_tp_tab,
                    l_getce_pos_x_tab,
                    l_getce_pos_y_tab,
                    l_getce_align_tab,
                    l_getce_winsize_x_tab,
                    l_getce_winsize_y_tab,
                    l_getce_is_protected_tab,
                    l_getce_mandatory_tab,
                    l_getce_hidden_tab,
                    l_getce_unit_tab,
                    l_getce_format_tab,
                    l_getce_eq_tab,
                    l_getce_eq_version_tab,
                    l_getce_component_tab,
                    l_getce_calc_tp_tab,
                    l_getce_calc_formula_tab,
                    l_getce_valid_cf_tab,
                    l_getce_max_x_tab,
                    l_getce_max_y_tab,
                    l_getce_multi_select_tab,
                    l_getce_reanalysedresult_tab,
                    l_getce_nr_of_rows,
                    l_getce_where_clause,
                    l_getce_next_rows);

      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : GetScMeCell ret_code : '||l_ret_code|| ' next_rows = -1' );
         RAISE StpError;
      END IF;

      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'            Calling SaveScMeCell for : ');
      FOR l_row IN 1..UNICONNECT.P_CE_NR_OF_ROWS LOOP
          UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'            row='||l_row||
                                         '#mod_flag='||UNICONNECT.P_CE_MODIFY_FLAG_TAB(l_row) ||
                                         '#sc='||UNICONNECT.P_CE_SC_TAB(l_row)||'#pg='||UNICONNECT.P_CE_PG_TAB(l_row)||
                                         '#pgnode='||NVL(TO_CHAR(UNICONNECT.P_CE_PGNODE_TAB(l_row)),'NULL')||
                                         '#pa='||UNICONNECT.P_CE_PA_TAB(l_row)||
                                         '#panode='||NVL(TO_CHAR(UNICONNECT.P_CE_PANODE_TAB(l_row)),'NULL')||
                                         '#me='||UNICONNECT.P_CE_ME_TAB(l_row)||
                                         '#menode='||NVL(TO_CHAR(UNICONNECT.P_CE_MENODE_TAB(l_row)),'NULL')||
                                         '#cell='||UNICONNECT.P_CE_CE_TAB(l_row)||
                                         '#cellnode='||NVL(TO_CHAR(UNICONNECT.P_CE_CENODE_TAB(l_row)),'NULL'));
      END LOOP;

      l_ret_code := UNAPIME.SAVESCMECELL
                   (UNICONNECT.P_CE_COMPLETED,
                    UNICONNECT.P_CE_SC_TAB,
                    UNICONNECT.P_CE_PG_TAB,
                    UNICONNECT.P_CE_PGNODE_TAB,
                    UNICONNECT.P_CE_PA_TAB,
                    UNICONNECT.P_CE_PANODE_TAB,
                    UNICONNECT.P_CE_ME_TAB,
                    UNICONNECT.P_CE_MENODE_TAB,
                    UNICONNECT.P_CE_REANALYSIS_TAB,
                    UNICONNECT.P_CE_CE_TAB,
                    UNICONNECT.P_CE_CENODE_TAB,
                    UNICONNECT.P_CE_DSP_TITLE_TAB,
                    UNICONNECT.P_CE_VALUE_F_TAB,
                    UNICONNECT.P_CE_VALUE_S_TAB,
                    UNICONNECT.P_CE_CELL_TP_TAB,
                    UNICONNECT.P_CE_POS_X_TAB,
                    UNICONNECT.P_CE_POS_Y_TAB,
                    UNICONNECT.P_CE_ALIGN_TAB,
                    UNICONNECT.P_CE_WINSIZE_X_TAB,
                    UNICONNECT.P_CE_WINSIZE_Y_TAB,
                    UNICONNECT.P_CE_IS_PROTECTED_TAB,
                    UNICONNECT.P_CE_MANDATORY_TAB,
                    UNICONNECT.P_CE_HIDDEN_TAB,
                    UNICONNECT.P_CE_UNIT_TAB,
                    UNICONNECT.P_CE_FORMAT_TAB,
                    UNICONNECT.P_CE_EQ_TAB,
                    UNICONNECT.P_CE_EQ_VERSION_TAB,
                    UNICONNECT.P_CE_COMPONENT_TAB,
                    UNICONNECT.P_CE_CALC_TP_TAB,
                    UNICONNECT.P_CE_CALC_FORMULA_TAB,
                    UNICONNECT.P_CE_VALID_CF_TAB,
                    UNICONNECT.P_CE_MAX_X_TAB,
                    UNICONNECT.P_CE_MAX_Y_TAB,
                    UNICONNECT.P_CE_MULTI_SELECT_TAB,
                    UNICONNECT.P_CE_MODIFY_FLAG_TAB,
                    UNICONNECT.P_CE_NR_OF_ROWS,
                    0);

      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error :SaveScMeCell ret_code='||l_ret_code ||
                                        '#sc(1)='||UNICONNECT.P_CE_SC_TAB(1)||'#pg(1)='||UNICONNECT.P_CE_PG_TAB(1)||
                                        '#pgnode(1)='||NVL(TO_CHAR(UNICONNECT.P_CE_PGNODE_TAB(1)),'NULL')||
                                        '#pa(1)='||UNICONNECT.P_CE_PA_TAB(1)||
                                        '#panode(1)='||NVL(TO_CHAR(UNICONNECT.P_CE_PANODE_TAB(1)),'NULL')||
                                        '#me(1)='||UNICONNECT.P_CE_ME_TAB(1)||
                                        '#menode(1)='||NVL(TO_CHAR(UNICONNECT.P_CE_MENODE_TAB(1)),'NULL')||
                                        '#cell(1)='||UNICONNECT.P_CE_CE_TAB(1)||
                                        '#cellnode(1)='||NVL(TO_CHAR(UNICONNECT.P_CE_CENODE_TAB(1)),'NULL')||
                                        '#mod_flag(1)='||UNICONNECT.P_CE_MODIFY_FLAG_TAB(1));
         IF l_ret_code = UNAPIGEN.DBERR_PARTIALSAVE THEN
            IF UNICONNECT.P_CE_NR_OF_ROWS >=1 THEN
               FOR l_row IN 1..UNICONNECT.P_CE_NR_OF_ROWS LOOP
                  IF UNICONNECT.P_CE_MODIFY_FLAG_TAB(l_row) > UNAPIGEN.DBERR_SUCCESS THEN
                     UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         SaveScMeCell authorisation problem row='||l_row||
                                                    '#mod_flag='||UNICONNECT.P_CE_MODIFY_FLAG_TAB(l_row) ||
                                                    '#sc='||UNICONNECT.P_CE_SC_TAB(l_row)||'#pg='||UNICONNECT.P_CE_PG_TAB(l_row)||
                                                    '#pgnode='||NVL(TO_CHAR(UNICONNECT.P_CE_PGNODE_TAB(l_row)),'NULL')||
                                                    '#pa='||UNICONNECT.P_CE_PA_TAB(l_row)||
                                                    '#panode='||NVL(TO_CHAR(UNICONNECT.P_CE_PANODE_TAB(l_row)),'NULL')||
                                                    '#me='||UNICONNECT.P_CE_ME_TAB(l_row)||
                                                    '#menode='||NVL(TO_CHAR(UNICONNECT.P_CE_MENODE_TAB(l_row)),'NULL')||
                                                    '#cell='||UNICONNECT.P_CE_CE_TAB(l_row)||
                                                    '#cellnode='||NVL(TO_CHAR(UNICONNECT.P_CE_CENODE_TAB(l_row)),'NULL'));
                  END IF;
               END LOOP;
            END IF;
            IF UNAPIAUT.P_NOT_AUTHORISED IS NOT NULL THEN
               UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         ' || UNAPIAUT.P_NOT_AUTHORISED );
            END IF;

            --Parial save does not interrupt the transaction
            UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_SUCCESS;
         ELSE
            RAISE StpError;
         END IF;
      END IF;

      --finish saving cells a_next_rows = -1
      l_hold := UNICONNECT.P_CE_NR_OF_ROWS;
      UNICONNECT.P_CE_NR_OF_ROWS := 0;

      l_ret_code := UNAPIME.SAVESCMECELL
                   (UNICONNECT.P_CE_COMPLETED,
                    UNICONNECT.P_CE_SC_TAB,
                    UNICONNECT.P_CE_PG_TAB,
                    UNICONNECT.P_CE_PGNODE_TAB,
                    UNICONNECT.P_CE_PA_TAB,
                    UNICONNECT.P_CE_PANODE_TAB,
                    UNICONNECT.P_CE_ME_TAB,
                    UNICONNECT.P_CE_MENODE_TAB,
                    UNICONNECT.P_CE_REANALYSIS_TAB,
                    UNICONNECT.P_CE_CE_TAB,
                    UNICONNECT.P_CE_CENODE_TAB,
                    UNICONNECT.P_CE_DSP_TITLE_TAB,
                    UNICONNECT.P_CE_VALUE_F_TAB,
                    UNICONNECT.P_CE_VALUE_S_TAB,
                    UNICONNECT.P_CE_CELL_TP_TAB,
                    UNICONNECT.P_CE_POS_X_TAB,
                    UNICONNECT.P_CE_POS_Y_TAB,
                    UNICONNECT.P_CE_ALIGN_TAB,
                    UNICONNECT.P_CE_WINSIZE_X_TAB,
                    UNICONNECT.P_CE_WINSIZE_Y_TAB,
                    UNICONNECT.P_CE_IS_PROTECTED_TAB,
                    UNICONNECT.P_CE_MANDATORY_TAB,
                    UNICONNECT.P_CE_HIDDEN_TAB,
                    UNICONNECT.P_CE_UNIT_TAB,
                    UNICONNECT.P_CE_FORMAT_TAB,
                    UNICONNECT.P_CE_EQ_TAB,
                    UNICONNECT.P_CE_EQ_VERSION_TAB,
                    UNICONNECT.P_CE_COMPONENT_TAB,
                    UNICONNECT.P_CE_CALC_TP_TAB,
                    UNICONNECT.P_CE_CALC_FORMULA_TAB,
                    UNICONNECT.P_CE_VALID_CF_TAB,
                    UNICONNECT.P_CE_MAX_X_TAB,
                    UNICONNECT.P_CE_MAX_Y_TAB,
                    UNICONNECT.P_CE_MULTI_SELECT_TAB,
                    UNICONNECT.P_CE_MODIFY_FLAG_TAB,
                    UNICONNECT.P_CE_NR_OF_ROWS,
                    -1);

      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error :SaveScMeCell ret_code='||l_ret_code ||
                                        ' with a_next_rows=-1');
         RAISE StpError;

      END IF;
      UNICONNECT.P_CE_NR_OF_ROWS := l_hold;

      --close internal transaction
      IF l_internal_transaction THEN
         l_return := UNICONNECT.FinishTransaction;
         IF l_return <> UNAPIGEN.DBERR_SUCCESS THEN
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         EndTransaction failed ! ret_code='||TO_CHAR(l_return));
         END IF;
      END IF;

   EXCEPTION
   WHEN OTHERS THEN
      --close internal transaction
      IF l_internal_transaction THEN
         l_return := UNICONNECT.FinishTransaction;
         IF l_return <> UNAPIGEN.DBERR_SUCCESS THEN
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         EndTransaction failed ! ret_code='||TO_CHAR(l_return));
         END IF;
      END IF;
      RETURN (UNAPIGEN.DBERR_GENFAIL);
   END;

   --11. Initialise CE and CENODE global variables with the last ce in array
   --   Cleanup the arrays used to save the cell(s) (important since it can be reused)
   IF UNICONNECT.P_CE_NR_OF_ROWS > 0 THEN
      UNICONNECT.P_GLOB_CE := UNICONNECT.P_CE_CE_TAB(UNICONNECT.P_CE_NR_OF_ROWS);
      UNICONNECT.P_GLOB_CENODE := UNICONNECT.P_CE_CENODE_TAB(UNICONNECT.P_CE_NR_OF_ROWS);
      UNICONNECT2.WriteGlobalVariablesToLog;
   ELSE
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NORMAL,'         Warning ! current cell and cellnode not set before leaving [cell] section !');
   END IF;
   UCON_CleanupMeCellSection;
   UNICONNECT.P_CE_NR_OF_ROWS := 0;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

END UCON_ExecuteMeCellSection;

/*--------------------------------------------------------------*/
/* procedures and functions related to the [cell table] section */
/*--------------------------------------------------------------*/

PROCEDURE UCON_InitialiseMeCeTabSection     /* INTERNAL */
IS
BEGIN

   --local variables initialisation
   UNICONNECT.P_CET_NR_OF_ROWS := 0;
   UNICONNECT.P_CET_SC := UNICONNECT.P_GLOB_SC;
   UNICONNECT.P_CET_PG := UNICONNECT.P_GLOB_PG;
   UNICONNECT.P_CET_PGNODE := UNICONNECT.P_GLOB_PGNODE;
   UNICONNECT.P_CET_PP_KEY1 := NULL;
   UNICONNECT.P_CET_PP_KEY2 := NULL;
   UNICONNECT.P_CET_PP_KEY3 := NULL;
   UNICONNECT.P_CET_PP_KEY4 := NULL;
   UNICONNECT.P_CET_PP_KEY5 := NULL;
   UNICONNECT.P_CET_PP_VERSION := NULL;
   UNICONNECT.P_CET_PA := UNICONNECT.P_GLOB_PA;
   UNICONNECT.P_CET_PANODE := UNICONNECT.P_GLOB_PANODE;
   UNICONNECT.P_CET_PR_VERSION := NULL;
   UNICONNECT.P_CET_ME := UNICONNECT.P_GLOB_ME;
   UNICONNECT.P_CET_MENODE := UNICONNECT.P_GLOB_MENODE;
   UNICONNECT.P_CET_MT_VERSION := NULL;

   --internal to [cell table] section
   UNICONNECT.P_CET_PGNAME := NULL;
   UNICONNECT.P_CET_PGDESCRIPTION := NULL;
   UNICONNECT.P_CET_PANAME := NULL;
   UNICONNECT.P_CET_PADESCRIPTION := NULL;
   UNICONNECT.P_CET_MENAME := NULL;
   UNICONNECT.P_CET_MEDESCRIPTION := NULL;

   --global variables
   UNICONNECT.P_GLOB_CE := NULL;
   UNICONNECT.P_GLOB_CENODE := NULL;

END UCON_InitialiseMeCeTabSection;

FUNCTION UCON_AssignMeCeTabSectionRow       /* INTERNAL */
RETURN NUMBER IS

l_description_pos      INTEGER;
l_comma_pos            INTEGER;
l_open_bracket_pos     INTEGER;
l_close_bracket_pos    INTEGER;
l_index_x              INTEGER;
l_index_y              INTEGER;
l_found_seq_no         INTEGER;

BEGIN

   --Important assumption : one [cell table] section is only related to one method within one pa within one pg within one sample

   UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NONE,'      Assigning value of variable '||UNICONNECT.P_VARIABLE_NAME||' in [cell table] section');
   IF UNICONNECT.P_VARIABLE_NAME = 'sc' THEN
      UNICONNECT.P_CET_SC := UNICONNECT.P_VARIABLE_VALUE;

   ELSIF UNICONNECT.P_VARIABLE_NAME IN ('pgnode', 'pg.pgnode') THEN
      UNICONNECT.P_CET_PGNODE := UNICONNECT.P_VARIABLE_VALUE;

      --Fatal error when pg not yet specified
      IF UNICONNECT.P_CET_PGNAME IS NULL THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major problem ! pgnode in [cell table] section must be preceded by a pg setting');
         RETURN(UNAPIGEN.DBERR_GENFAIL);
      END IF;

   ELSIF UNICONNECT.P_VARIABLE_NAME IN ('pp_key1', 'pg.pp_key1') THEN
      UNICONNECT.P_CET_PP_KEY1 := NVL(UNICONNECT.P_VARIABLE_VALUE, ' ');

   ELSIF UNICONNECT.P_VARIABLE_NAME IN ('pp_key2', 'pg.pp_key2') THEN
      UNICONNECT.P_CET_PP_KEY2 := NVL(UNICONNECT.P_VARIABLE_VALUE, ' ');

   ELSIF UNICONNECT.P_VARIABLE_NAME IN ('pp_key3', 'pg.pp_key3') THEN
      UNICONNECT.P_CET_PP_KEY3 := NVL(UNICONNECT.P_VARIABLE_VALUE, ' ');

   ELSIF UNICONNECT.P_VARIABLE_NAME IN ('pp_key4', 'pg.pp_key4') THEN
      UNICONNECT.P_CET_PP_KEY4 := NVL(UNICONNECT.P_VARIABLE_VALUE, ' ');

   ELSIF UNICONNECT.P_VARIABLE_NAME IN ('pp_key5', 'pg.pp_key5') THEN
      UNICONNECT.P_CET_PP_KEY5 := NVL(UNICONNECT.P_VARIABLE_VALUE, ' ');

   ELSIF UNICONNECT.P_VARIABLE_NAME IN ('pp_version', 'pg.pp_version') THEN
      UNICONNECT.P_CET_PP_VERSION := UNICONNECT.P_VARIABLE_VALUE;

   ELSIF SUBSTR(UNICONNECT.P_VARIABLE_NAME,1,2) = 'pg' THEN
      --MUST BE PLACED after pgnode variable assignment since SUBSTR will return pg
      --initialise full array except for sample code

      --pg can be specified by description or by name
      l_description_pos := INSTR(UNICONNECT.P_VARIABLE_NAME, '.description');
      IF l_description_pos > 0 THEN
         UNICONNECT.P_CET_PGDESCRIPTION := UNICONNECT.P_VARIABLE_VALUE;
         UNICONNECT.P_CET_PGNAME        := UNICONNECT.P_VARIABLE_NAME;
         UNICONNECT.P_CET_PG := NULL;
      ELSE
         UNICONNECT.P_CET_PG            := UNICONNECT.P_VARIABLE_VALUE;
         UNICONNECT.P_CET_PGNAME        := UNICONNECT.P_VARIABLE_NAME;
         UNICONNECT.P_CET_PGDESCRIPTION := NULL;
      END IF;

      --also reset pgnode : pgnode is initialised with global setting PGNODE when entering
      --the section
      UNICONNECT.P_CET_PGNODE := NULL;

   ELSIF UNICONNECT.P_VARIABLE_NAME IN ('panode', 'pa.panode') THEN
      UNICONNECT.P_CET_PANODE := UNICONNECT.P_VARIABLE_VALUE;

      --Fatal error when pa not yet specified
      IF UNICONNECT.P_CET_PANAME IS NULL THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major problem ! panode in [cell table] section must be preceded by a pa setting');
         RETURN(UNAPIGEN.DBERR_GENFAIL);
      END IF;

   ELSIF UNICONNECT.P_VARIABLE_NAME IN ('pr_version', 'pa.pr_version') THEN
      UNICONNECT.P_CET_PR_VERSION := UNICONNECT.P_VARIABLE_VALUE;

   ELSIF SUBSTR(UNICONNECT.P_VARIABLE_NAME,1,2) = 'pa' THEN
      --MUST BE PLACED after panode variable assignment since SUBSTR will return pa

      --pa can be specified by description or by name
      l_description_pos := INSTR(UNICONNECT.P_VARIABLE_NAME, '.description');
      IF l_description_pos > 0 THEN
         UNICONNECT.P_CET_PADESCRIPTION := UNICONNECT.P_VARIABLE_VALUE;
         UNICONNECT.P_CET_PANAME        := UNICONNECT.P_VARIABLE_NAME;
         UNICONNECT.P_CET_PA := NULL;
      ELSE
         UNICONNECT.P_CET_PA            := UNICONNECT.P_VARIABLE_VALUE;
         UNICONNECT.P_CET_PANAME        := UNICONNECT.P_VARIABLE_NAME;
         UNICONNECT.P_CET_PADESCRIPTION := NULL;
      END IF;

      --also reset panode : panode is initialised with global setting PANODE when entering
      --the section
      UNICONNECT.P_CET_PANODE := NULL;

   ELSIF UNICONNECT.P_VARIABLE_NAME IN ('menode', 'me.menode') THEN
      UNICONNECT.P_CET_MENODE := UNICONNECT.P_VARIABLE_VALUE;

      --Fatal error when pa not yet specified
      IF UNICONNECT.P_CET_MENAME IS NULL THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major problem ! menode in [cell table] section must be preceded by a me setting');
         RETURN(UNAPIGEN.DBERR_GENFAIL);
      END IF;

   ELSIF UNICONNECT.P_VARIABLE_NAME IN ('mt_version', 'me.mt_version') THEN
      UNICONNECT.P_CET_MT_VERSION := UNICONNECT.P_VARIABLE_VALUE;

   ELSIF SUBSTR(UNICONNECT.P_VARIABLE_NAME,1,2) = 'me' THEN
      --MUST BE PLACED after menode variable assignment since SUBSTR will return me

      --me can be specified by description or by name
      l_description_pos := INSTR(UNICONNECT.P_VARIABLE_NAME, '.description');
      IF l_description_pos > 0 THEN
         UNICONNECT.P_CET_MEDESCRIPTION := UNICONNECT.P_VARIABLE_VALUE;
         UNICONNECT.P_CET_MENAME        := UNICONNECT.P_VARIABLE_NAME;
         UNICONNECT.P_CET_ME := NULL;
      ELSE
         UNICONNECT.P_CET_ME            := UNICONNECT.P_VARIABLE_VALUE;
         UNICONNECT.P_CET_MENAME        := UNICONNECT.P_VARIABLE_NAME;
         UNICONNECT.P_CET_MEDESCRIPTION := NULL;
      END IF;

      --also reset menode : menode is initialised with global setting MENODE when entering
      --the section
      UNICONNECT.P_CET_MENODE := NULL;


   ELSIF UNICONNECT.P_VARIABLE_NAME = 'cellnode' THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'      Invalid variable '||UNICONNECT.P_VARIABLE_NAME||' in [cell table] section');
         RETURN(UNAPIGEN.DBERR_INVALIDVARIABLE);

   ELSIF SUBSTR(UNICONNECT.P_VARIABLE_NAME,1,4) = 'cell' THEN
      --MUST BE PLACED after cellnode variable assignment since SUBSTR will return cell
      --initialise full array except for sample code, pg, pgnode, pa and panode, me and menode

      --cell can be specified by description or by name
      l_description_pos := INSTR(UNICONNECT.P_VARIABLE_NAME, '.description');
      IF l_description_pos > 0 THEN
         UNICONNECT.P_CET_CEDESCRIPTION := UNICONNECT.P_VARIABLE_VALUE;
         UNICONNECT.P_CET_CE := NULL;
      ELSE
         UNICONNECT.P_CET_CE := UNICONNECT.P_VARIABLE_VALUE;
         UNICONNECT.P_CET_CEDESCRIPTION := NULL;
      END IF;

      UNICONNECT.P_CET_CENAME := UNICONNECT.P_VARIABLE_NAME;


   ELSIF SUBSTR(UNICONNECT.P_VARIABLE_NAME, 1, 8) IN ('value_f[','value_s[', 'selected') THEN

      --extract index_x and index_y
      l_comma_pos := INSTR(UNICONNECT.P_VARIABLE_NAME, ',');
      l_open_bracket_pos := INSTR(UNICONNECT.P_VARIABLE_NAME, '[');
      l_close_bracket_pos := INSTR(UNICONNECT.P_VARIABLE_NAME, ']');
      IF l_comma_pos = 0 OR
         l_open_bracket_pos = 0 OR
         l_close_bracket_pos = 0 THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'      Invalid variable '||UNICONNECT.P_VARIABLE_NAME||' in [cell table] section');
         RETURN(UNAPIGEN.DBERR_INVALIDVARIABLE);
      END IF;
      l_index_x := SUBSTR(UNICONNECT.P_VARIABLE_NAME,
                          l_open_bracket_pos+1, l_comma_pos-l_open_bracket_pos-1);
      l_index_y := SUBSTR(UNICONNECT.P_VARIABLE_NAME,
                          l_comma_pos+1, l_close_bracket_pos-l_comma_pos-1);
      IF l_index_x IS NULL OR
         l_index_y IS NULL THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'      Invalid variable '||UNICONNECT.P_VARIABLE_NAME||' in [cell table] section');
         RETURN(UNAPIGEN.DBERR_INVALIDVARIABLE);
      END IF;
      --scan the array to see if already existing
      --create new array element when not already present
      l_found_seq_no := 0;
      FOR l_seq_no IN 1..UNICONNECT.P_CET_NR_OF_ROWS LOOP
         IF UNICONNECT.P_CET_INDEX_X_TAB(l_seq_no) = l_index_x AND
            UNICONNECT.P_CET_INDEX_Y_TAB(l_seq_no) = l_index_y THEN
            l_found_seq_no := l_seq_no;
            EXIT;
         END IF;
      END LOOP;

      IF l_found_seq_no=0 THEN
         UNICONNECT.P_CET_NR_OF_ROWS := UNICONNECT.P_CET_NR_OF_ROWS + 1;

         UNICONNECT.P_CET_INDEX_X_TAB(UNICONNECT.P_CET_NR_OF_ROWS)           := l_index_x;
         UNICONNECT.P_CET_INDEX_Y_TAB(UNICONNECT.P_CET_NR_OF_ROWS)           := l_index_y;

         UNICONNECT.P_CET_VALUE_F_TAB(UNICONNECT.P_CET_NR_OF_ROWS)           := NULL;
         UNICONNECT.P_CET_VALUE_S_TAB(UNICONNECT.P_CET_NR_OF_ROWS)           := NULL;
         UNICONNECT.P_CET_SELECTED_TAB(UNICONNECT.P_CET_NR_OF_ROWS)          := '0';
         UNICONNECT.P_CET_MODIFY_FLAG_TAB(UNICONNECT.P_CET_NR_OF_ROWS)       := UNAPIGEN.MOD_FLAG_INSERT;

         --initialise all modify flags to FALSE
         UNICONNECT.P_CET_VALUE_F_MODTAB(UNICONNECT.P_CET_NR_OF_ROWS)              := FALSE;
         UNICONNECT.P_CET_VALUE_S_MODTAB(UNICONNECT.P_CET_NR_OF_ROWS)              := FALSE;

         l_found_seq_no := UNICONNECT.P_CET_NR_OF_ROWS;
      END IF;

      IF SUBSTR(UNICONNECT.P_VARIABLE_NAME, 1, 8) = 'value_f[' THEN

         UNICONNECT.P_CET_VALUE_F_TAB(l_found_seq_no) := UNICONNECT.P_VARIABLE_VALUE;
         UNICONNECT.P_CET_VALUE_F_MODTAB(l_found_seq_no) := TRUE;

      ELSIF SUBSTR(UNICONNECT.P_VARIABLE_NAME, 1, 8) = 'value_s[' THEN

         UNICONNECT.P_CET_VALUE_S_TAB(l_found_seq_no) := UNICONNECT.P_VARIABLE_VALUE;
         UNICONNECT.P_CET_VALUE_S_MODTAB(l_found_seq_no) := TRUE;

      ELSIF SUBSTR(UNICONNECT.P_VARIABLE_NAME, 1, 8) = 'selected' THEN

         UNICONNECT.P_CET_VALUE_F_TAB(l_found_seq_no) := UNICONNECT.P_VARIABLE_VALUE;

      END IF;

   ELSE
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'      Invalid variable '||UNICONNECT.P_VARIABLE_NAME||' in [cell table] section');
      RETURN(UNAPIGEN.DBERR_INVALIDVARIABLE);
   END IF;
   RETURN(UNAPIGEN.DBERR_SUCCESS);

END UCON_AssignMeCeTabSectionRow;

PROCEDURE UCON_CleanupMeCeTabSection IS
BEGIN
   --Important since these variables should only
   --last for the execution of the [cell table] section
   --but have to be implemented as global package variables
   --to keep it mantainable

   UNICONNECT.P_CET_CE_TAB.DELETE;
   UNICONNECT.P_CET_INDEX_X_TAB.DELETE;
   UNICONNECT.P_CET_INDEX_Y_TAB.DELETE;

   UNICONNECT.P_CET_VALUE_F_TAB.DELETE;
   UNICONNECT.P_CET_VALUE_S_TAB.DELETE;
   UNICONNECT.P_CET_SELECTED_TAB.DELETE;
   UNICONNECT.P_CET_MODIFY_FLAG_TAB.DELETE;

   UNICONNECT.P_CET_VALUE_F_MODTAB.DELETE;
   UNICONNECT.P_CET_VALUE_S_MODTAB.DELETE;

   UNICONNECT.P_CET_SC := NULL;
   UNICONNECT.P_CET_PG := NULL;
   UNICONNECT.P_CET_PGNAME := NULL;
   UNICONNECT.P_CET_PGDESCRIPTION := NULL;
   UNICONNECT.P_CET_PP_KEY1 := NULL;
   UNICONNECT.P_CET_PP_KEY2 := NULL;
   UNICONNECT.P_CET_PP_KEY3 := NULL;
   UNICONNECT.P_CET_PP_KEY4 := NULL;
   UNICONNECT.P_CET_PP_KEY5 := NULL;
   UNICONNECT.P_CET_PP_VERSION := NULL;
   UNICONNECT.P_CET_PGNODE := NULL;
   UNICONNECT.P_CET_PA := NULL;
   UNICONNECT.P_CET_PANAME := NULL;
   UNICONNECT.P_CET_PADESCRIPTION := NULL;
   UNICONNECT.P_CET_PANODE := NULL;
   UNICONNECT.P_CET_PR_VERSION := NULL;
   UNICONNECT.P_CET_ME := NULL;
   UNICONNECT.P_CET_MENAME := NULL;
   UNICONNECT.P_CET_MEDESCRIPTION := NULL;
   UNICONNECT.P_CET_MENODE := NULL;
   UNICONNECT.P_CET_MT_VERSION := NULL;
   UNICONNECT.P_CET_REANALYSIS := NULL;

   UNICONNECT.P_CET_CE := NULL;

   UNICONNECT.P_CET_CENAME := NULL;
   UNICONNECT.P_CET_CEDESCRIPTION := NULL;

   UNICONNECT.P_CET_MODIFY_REASON := NULL;

   UNICONNECT.P_CET_NR_OF_ROWS  := 0;

END UCON_CleanupMeCeTabSection;

FUNCTION UCON_ExecuteMeCeTabSection         /* INTERNAL */
RETURN NUMBER IS

l_sc                   VARCHAR2(20);
l_variable_name        VARCHAR2(20);
l_description_pos      INTEGER;
l_openbrackets_pos     INTEGER;
l_closebrackets_pos    INTEGER;
l_pg_pos               INTEGER;
l_pg_rec_found         utscpg%ROWTYPE;
l_pa_pos               INTEGER;
l_pa_rec_found         utscpa%ROWTYPE;
l_me_pos               INTEGER;
l_me_rec_found         utscme%ROWTYPE;
l_cell_pos             INTEGER;
l_cell_rec_found       utscmecell%ROWTYPE;
l_any_save             BOOLEAN DEFAULT FALSE;
l_used_api             VARCHAR2(30);
l_find_ce_row          INTEGER;
l_hold                 INTEGER;
l_internal_transaction BOOLEAN DEFAULT FALSE;

l_dml_statement        VARCHAR2(2000);
l_me_exec_end_date     DATE ;

--Specific local variables for GetScMeCell
l_getcet_nr_of_rows                  NUMBER;
l_getcet_where_clause                VARCHAR2(511);
l_getcet_next_rows                   NUMBER;
l_getcet_sc_tab                      UNAPIGEN.VC20_TABLE_TYPE;
l_getcet_pg_tab                      UNAPIGEN.VC20_TABLE_TYPE;
l_getcet_pgnode_tab                  UNAPIGEN.LONG_TABLE_TYPE;
l_getcet_pa_tab                      UNAPIGEN.VC20_TABLE_TYPE;
l_getcet_panode_tab                  UNAPIGEN.LONG_TABLE_TYPE;
l_getcet_me_tab                      UNAPIGEN.VC20_TABLE_TYPE;
l_getcet_menode_tab                  UNAPIGEN.LONG_TABLE_TYPE;
l_getcet_reanalysis_tab              UNAPIGEN.NUM_TABLE_TYPE;
l_getcet_cell_tab                    UNAPIGEN.VC20_TABLE_TYPE;
l_getcet_cellnode_tab                UNAPIGEN.LONG_TABLE_TYPE;
l_getcet_dsp_title_tab               UNAPIGEN.VC40_TABLE_TYPE;
l_getcet_value_f_tab                 UNAPIGEN.FLOAT_TABLE_TYPE;
l_getcet_value_s_tab                 UNAPIGEN.VC40_TABLE_TYPE;
l_getcet_cell_tp_tab                 UNAPIGEN.CHAR1_TABLE_TYPE;
l_getcet_pos_x_tab                   UNAPIGEN.NUM_TABLE_TYPE;
l_getcet_pos_y_tab                   UNAPIGEN.NUM_TABLE_TYPE;
l_getcet_align_tab                   UNAPIGEN.CHAR1_TABLE_TYPE;
l_getcet_winsize_x_tab               UNAPIGEN.NUM_TABLE_TYPE;
l_getcet_winsize_y_tab               UNAPIGEN.NUM_TABLE_TYPE;
l_getcet_is_protected_tab            UNAPIGEN.CHAR1_TABLE_TYPE;
l_getcet_mandatory_tab               UNAPIGEN.CHAR1_TABLE_TYPE;
l_getcet_hidden_tab                  UNAPIGEN.CHAR1_TABLE_TYPE;
l_getcet_unit_tab                    UNAPIGEN.VC20_TABLE_TYPE;
l_getcet_format_tab                  UNAPIGEN.VC40_TABLE_TYPE;
l_getcet_eq_tab                      UNAPIGEN.VC20_TABLE_TYPE;
l_getcet_eq_version_tab              UNAPIGEN.VC20_TABLE_TYPE;
l_getcet_component_tab               UNAPIGEN.VC20_TABLE_TYPE;
l_getcet_calc_tp_tab                 UNAPIGEN.CHAR1_TABLE_TYPE;
l_getcet_calc_formula_tab            UNAPIGEN.VC2000_TABLE_TYPE;
l_getcet_valid_cf_tab                UNAPIGEN.VC20_TABLE_TYPE;
l_getcet_max_x_tab                   UNAPIGEN.NUM_TABLE_TYPE;
l_getcet_max_y_tab                   UNAPIGEN.NUM_TABLE_TYPE;
l_getcet_multi_select_tab            UNAPIGEN.CHAR1_TABLE_TYPE;
l_getcet_reanalysedresult_tab        UNAPIGEN.CHAR1_TABLE_TYPE;

l_scme_sc                           UTSCME.sc%TYPE ;
l_scme_pg                           UTSCME.pg%TYPE ;
l_scme_pgnode                       UTSCME.pgnode%TYPE ;
l_scme_pa                           UTSCME.pa%TYPE ;
l_scme_panode                       UTSCME.panode%TYPE ;
l_scme_me                           UTSCME.me%TYPE ;
l_scme_menode                       UTSCME.menode%TYPE ;
l_scme_reanalysis                   UTSCME.reanalysis%TYPE ;
l_scme_exec_end_date                UTSCME.exec_end_Date%TYPE ;
l_scme_cursor                       INTEGER ;

BEGIN

   --1. sc validation
   IF UNICONNECT.P_CET_SC IS NULL THEN
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : sample is mandatory for [cell table] section !');
      RETURN(UNAPIGEN.DBERR_NOPARENTOBJECT);
   END IF;

   --2. sc modified in [cell table] section ?
   --    NO    set global variable SC
   --    YES   verify if provided sample code exist :error when not + set global variable SC
   --    Copy sc in savescmecelltable array
   IF UNICONNECT.P_GLOB_SC <> UNICONNECT.P_CET_SC THEN
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Sc directly searched:'||UNICONNECT.P_CET_SC);
      OPEN l_sc_cursor(UNICONNECT.P_CET_SC);
      FETCH l_sc_cursor
      INTO l_sc;
      CLOSE l_sc_cursor;
      IF l_sc IS NULL THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : sc does not exist ! sc is mandatory for [cell table] section !');
         RETURN(UNAPIGEN.DBERR_NOPARENTOBJECT);
      END IF;
      UNICONNECT.P_GLOB_SC := UNICONNECT.P_CET_SC;
   ELSE
      UNICONNECT.P_GLOB_SC := UNICONNECT.P_CET_SC;
   END IF;

   -- suppressed due to a change request on 16/09/1999 (pg/pgnode are nomore mandatory)
   --
   --3. pg=NULL ?
   --   NO OK
   --   YES   Major error : me section without pg specified in a preceding section
   --IF UNICONNECT.P_CET_PG IS NULL AND
   --   UNICONNECT.P_CET_PGDESCRIPTION IS NULL THEN
   --   UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : pg is mandatory for [cell table] section !');
   --   RETURN(UNAPIGEN.DBERR_NOPARENTOBJECT);
   --END IF;

   --4. pg or pgnode modified in [cell table] section
   --   NO set global varaibles PG and PGNODE
   --   YES   verify if provided pg exist :error when not + set global variable PG and PGNODE
   --      PAY attention the pg[x],pg[] and .description are supported in this case
   --   Copy PG and PGNODE in savescmecelltable array
   IF UNICONNECT.P_CET_PGNAME IS NOT NULL THEN

      --description used ? -> find pp in utpp
      l_variable_name := NVL(UNICONNECT.P_CET_PGNAME, 'pg');
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
            l_pg_rec_found := UNICONNECT2.FindScPg(UNICONNECT.P_GLOB_SC,
                                       UNICONNECT.P_CET_PG, UNICONNECT.P_CET_PGDESCRIPTION,
                                       UNICONNECT.P_CET_PGNODE,
                                       UNICONNECT.P_CET_PP_KEY1, UNICONNECT.P_CET_PP_KEY2, UNICONNECT.P_CET_PP_KEY3, UNICONNECT.P_CET_PP_KEY4, UNICONNECT.P_CET_PP_KEY5,
                                       UNICONNECT.P_CET_PP_VERSION,
                                       'pg',         1, NULL);
         ELSE
            --pg.description used
            --passed pp_keys left blank since pgnode is mostly fixed at this point
            l_pg_rec_found := UNICONNECT2.FindScPg(UNICONNECT.P_GLOB_SC, UNICONNECT.P_CET_PG, UNICONNECT.P_CET_PGDESCRIPTION,
                                       UNICONNECT.P_CET_PGNODE,
                                       UNICONNECT.P_CET_PP_KEY1, UNICONNECT.P_CET_PP_KEY2, UNICONNECT.P_CET_PP_KEY3, UNICONNECT.P_CET_PP_KEY4, UNICONNECT.P_CET_PP_KEY5,
                                       UNICONNECT.P_CET_PP_VERSION,
                                       'description',        1, NULL);
         END IF;
      ELSE
         IF l_description_pos = 0 THEN
            --pg[x] or pg[x].pg used
            --passed pp_keys left blank since pgnode is mostly fixed at this point
            l_pg_rec_found := UNICONNECT2.FindScPg(UNICONNECT.P_GLOB_SC, UNICONNECT.P_CET_PG, UNICONNECT.P_CET_PGDESCRIPTION,
                                       UNICONNECT.P_CET_PGNODE,
                                       UNICONNECT.P_CET_PP_KEY1, UNICONNECT.P_CET_PP_KEY2, UNICONNECT.P_CET_PP_KEY3, UNICONNECT.P_CET_PP_KEY4, UNICONNECT.P_CET_PP_KEY5,
                                       UNICONNECT.P_CET_PP_VERSION,
                                       'pg', l_pg_pos, NULL);
         ELSE
            --pg[x].description used
            --passed pp_keys left blank since pgnode is mostly fixed at this point
            l_pg_rec_found := UNICONNECT2.FindScPg(UNICONNECT.P_GLOB_SC,  UNICONNECT.P_CET_PG, UNICONNECT.P_CET_PGDESCRIPTION,
                                       UNICONNECT.P_CET_PGNODE,
                                       UNICONNECT.P_CET_PP_KEY1, UNICONNECT.P_CET_PP_KEY2, UNICONNECT.P_CET_PP_KEY3, UNICONNECT.P_CET_PP_KEY4, UNICONNECT.P_CET_PP_KEY5,
                                       UNICONNECT.P_CET_PP_VERSION,
                                       'description', l_pg_pos, NULL);
         END IF;
      END IF;

      IF l_pg_rec_found.pgnode IS NOT NULL THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         pg found:pg='||l_pg_rec_found.pg||'#pgnode='||l_pg_rec_found.pgnode);
         UNICONNECT.P_GLOB_PG := l_pg_rec_found.pg;
         UNICONNECT.P_GLOB_PGNODE := l_pg_rec_found.pgnode;
      ELSE
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : pg not found ! pg is mandatory for [cell table] section !');
         RETURN(UNAPIGEN.DBERR_NOPARENTOBJECT);
      END IF;

   ELSE
      UNICONNECT.P_GLOB_PG := UNICONNECT.P_CET_PG;
      UNICONNECT.P_GLOB_PGNODE := UNICONNECT.P_CET_PGNODE;
   END IF;

   -- suppressed due to a change request on 16/09/1999 (pg/pgnode are nomore mandatory)
   --
   --5. pa=NULL ?
   --   NO OK
   --   YES   Major error : me section without pa specified in a preceding section
   --IF UNICONNECT.P_CET_PA IS NULL AND
   --   UNICONNECT.P_CET_PADESCRIPTION IS NULL THEN
   --   UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : pa is mandatory for [cell table] section !');
   --   RETURN(UNAPIGEN.DBERR_NOPARENTOBJECT);
   --END IF;

   --6. pa or panode modified in [cell table] section
   --   NO set global variables PA and PANODE
   --   YES   verify if provided pa exist :error when not + set global variable PA and PANODE
   --      PAY attention the pa[x],pa[] and .description are supported in this case
   --   Copy PA and PANODE in savescmecelltable array
   IF UNICONNECT.P_CET_PANAME IS NOT NULL THEN

      --description used ? -> find pr in utpr
      l_variable_name := NVL(UNICONNECT.P_CET_PANAME, 'pa');
      l_description_pos := INSTR(l_variable_name, '.description');
      l_openbrackets_pos := INSTR(l_variable_name, '[');
      l_closebrackets_pos := INSTR(l_variable_name, ']');
      l_pa_pos := TO_NUMBER(SUBSTR(l_variable_name,l_openbrackets_pos+1,l_closebrackets_pos-l_openbrackets_pos-1));

      UNICONNECT.P_PA_NR_OF_ROWS := 0; --to be sure pa arrays are not searched
      l_pa_rec_found := NULL;

      IF l_openbrackets_pos = 0 THEN
         IF l_description_pos = 0 THEN
            --pa or pa.pa used
            l_pa_rec_found := UNICONNECT2.FindScPa(UNICONNECT.P_GLOB_SC,
                                       UNICONNECT.P_GLOB_PG, UNICONNECT.P_GLOB_PGNODE,
                                       UNICONNECT.P_CET_PP_KEY1, UNICONNECT.P_CET_PP_KEY2, UNICONNECT.P_CET_PP_KEY3, UNICONNECT.P_CET_PP_KEY4, UNICONNECT.P_CET_PP_KEY5,
                                       UNICONNECT.P_CET_PP_VERSION,
                                       UNICONNECT.P_CET_PA, UNICONNECT.P_CET_PADESCRIPTION,
                                       UNICONNECT.P_CET_PANODE, UNICONNECT.P_CET_PR_VERSION,
                                       'pa',         1, NULL);
         ELSE
            --pa.description used
            l_pa_rec_found := UNICONNECT2.FindScPa(UNICONNECT.P_GLOB_SC,
                                       UNICONNECT.P_GLOB_PG, UNICONNECT.P_GLOB_PGNODE,
                                       UNICONNECT.P_CET_PP_KEY1, UNICONNECT.P_CET_PP_KEY2, UNICONNECT.P_CET_PP_KEY3, UNICONNECT.P_CET_PP_KEY4, UNICONNECT.P_CET_PP_KEY5,
                                       UNICONNECT.P_CET_PP_VERSION,
                                       UNICONNECT.P_CET_PA, UNICONNECT.P_CET_PADESCRIPTION,
                                       UNICONNECT.P_CET_PANODE, UNICONNECT.P_CET_PR_VERSION,
                                       'description',        1, NULL);
         END IF;
      ELSE
         IF l_description_pos = 0 THEN
            --pa[x] or pa[x].pa used
            l_pa_rec_found := UNICONNECT2.FindScPa(UNICONNECT.P_GLOB_SC,
                                       UNICONNECT.P_GLOB_PG, UNICONNECT.P_GLOB_PGNODE,
                                       UNICONNECT.P_CET_PP_KEY1, UNICONNECT.P_CET_PP_KEY2, UNICONNECT.P_CET_PP_KEY3, UNICONNECT.P_CET_PP_KEY4, UNICONNECT.P_CET_PP_KEY5,
                                       UNICONNECT.P_CET_PP_VERSION,
                                       UNICONNECT.P_CET_PA, UNICONNECT.P_CET_PADESCRIPTION,
                                       UNICONNECT.P_CET_PANODE, UNICONNECT.P_CET_PR_VERSION,
                                       'pa', l_pa_pos, NULL);
         ELSE
            --pa[x].description used
            l_pa_rec_found := UNICONNECT2.FindScPa(UNICONNECT.P_GLOB_SC,
                                       UNICONNECT.P_GLOB_PG, UNICONNECT.P_GLOB_PGNODE,
                                       UNICONNECT.P_CET_PP_KEY1, UNICONNECT.P_CET_PP_KEY2, UNICONNECT.P_CET_PP_KEY3, UNICONNECT.P_CET_PP_KEY4, UNICONNECT.P_CET_PP_KEY5,
                                       UNICONNECT.P_CET_PP_VERSION,
                                       UNICONNECT.P_CET_PA, UNICONNECT.P_CET_PADESCRIPTION,
                                       UNICONNECT.P_CET_PANODE, UNICONNECT.P_CET_PR_VERSION,
                                       'description', l_pa_pos, NULL);
         END IF;
      END IF;

      IF l_pa_rec_found.panode IS NOT NULL THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         pa found:pa='||l_pa_rec_found.pa||'#panode='||l_pa_rec_found.panode);
         UNICONNECT.P_GLOB_PA := l_pa_rec_found.pa;
         UNICONNECT.P_GLOB_PANODE := l_pa_rec_found.panode;
      ELSE
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : pa not found ! pa is mandatory for [cell table] section !');
         RETURN(UNAPIGEN.DBERR_NOPARENTOBJECT);
      END IF;

   ELSE
      UNICONNECT.P_GLOB_PA := UNICONNECT.P_CET_PA;
      UNICONNECT.P_GLOB_PANODE := UNICONNECT.P_CET_PANODE;
   END IF;

   --7. me=NULL ?
   --   NO OK
   --   YES   Major error : cell section without me specified in a preceding section
   IF UNICONNECT.P_CET_ME IS NULL AND
      UNICONNECT.P_CET_MEDESCRIPTION IS NULL THEN
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : me is mandatory for [cell table] section !');
      RETURN(UNAPIGEN.DBERR_NOPARENTOBJECT);
   END IF;

   --8. me or menode modified in [cell table] section
   --   NO set global varaibles ME and MENODE
   --   YES   verify if provided me exist :error when not + set global variable ME and MENODE
   --      PAY attention the me[x],me[] and .description are supported in this case
   --   Copy ME and MENODE in savescmecelltable array
   IF UNICONNECT.P_CET_MENAME IS NOT NULL THEN

      --description used ? -> find mt in utmt
      l_variable_name := NVL(UNICONNECT.P_CET_MENAME, 'me');
      l_description_pos := INSTR(l_variable_name, '.description');
      l_openbrackets_pos := INSTR(l_variable_name, '[');
      l_closebrackets_pos := INSTR(l_variable_name, ']');
      l_me_pos := TO_NUMBER(SUBSTR(l_variable_name,l_openbrackets_pos+1,l_closebrackets_pos-l_openbrackets_pos-1));

      UNICONNECT.P_ME_NR_OF_ROWS := 0; --to be sure me arrays are not searched
      l_me_rec_found := NULL;

      IF l_openbrackets_pos = 0 THEN
         IF l_description_pos = 0 THEN
            --me or me.me used
            l_me_rec_found := UNICONNECT3.FindScMe(UNICONNECT.P_GLOB_SC,
                                       UNICONNECT.P_GLOB_PG, UNICONNECT.P_GLOB_PGNODE,
                                       UNICONNECT.P_CET_PP_KEY1, UNICONNECT.P_CET_PP_KEY2, UNICONNECT.P_CET_PP_KEY3, UNICONNECT.P_CET_PP_KEY4, UNICONNECT.P_CET_PP_KEY5,
                                       UNICONNECT.P_CET_PP_VERSION,
                                       UNICONNECT.P_GLOB_PA, UNICONNECT.P_GLOB_PANODE,
                                       UNICONNECT.P_CET_PR_VERSION,
                                       UNICONNECT.P_CET_ME, UNICONNECT.P_CET_MEDESCRIPTION,
                                       UNICONNECT.P_CET_MENODE, UNICONNECT.P_CET_MT_VERSION,
                                       'me',          1, NULL);
         ELSE
            --me.description used
            l_me_rec_found := UNICONNECT3.FindScMe(UNICONNECT.P_GLOB_SC,
                                       UNICONNECT.P_GLOB_PG, UNICONNECT.P_GLOB_PGNODE,
                                       UNICONNECT.P_CET_PP_KEY1, UNICONNECT.P_CET_PP_KEY2, UNICONNECT.P_CET_PP_KEY3, UNICONNECT.P_CET_PP_KEY4, UNICONNECT.P_CET_PP_KEY5,
                                       UNICONNECT.P_CET_PP_VERSION,
                                       UNICONNECT.P_GLOB_PA, UNICONNECT.P_GLOB_PANODE,
                                       UNICONNECT.P_CET_PR_VERSION,
                                       UNICONNECT.P_CET_ME, UNICONNECT.P_CET_MEDESCRIPTION,
                                       UNICONNECT.P_CET_MENODE, UNICONNECT.P_CET_MT_VERSION,
                                       'description', 1, NULL);
         END IF;
      ELSE
         IF l_description_pos = 0 THEN
            --me[x] or me[x].me used
            l_me_rec_found := UNICONNECT3.FindScMe(UNICONNECT.P_GLOB_SC,
                                       UNICONNECT.P_GLOB_PG, UNICONNECT.P_GLOB_PGNODE,
                                       UNICONNECT.P_CET_PP_KEY1, UNICONNECT.P_CET_PP_KEY2, UNICONNECT.P_CET_PP_KEY3, UNICONNECT.P_CET_PP_KEY4, UNICONNECT.P_CET_PP_KEY5,
                                       UNICONNECT.P_CET_PP_VERSION,
                                       UNICONNECT.P_GLOB_PA, UNICONNECT.P_GLOB_PANODE,
                                       UNICONNECT.P_CET_PR_VERSION,
                                       UNICONNECT.P_CET_ME, UNICONNECT.P_CET_MEDESCRIPTION,
                                       UNICONNECT.P_CET_MENODE, UNICONNECT.P_CET_MT_VERSION,
                                       'me',   l_me_pos, NULL);
         ELSE
            --me[x].description used
            l_me_rec_found := UNICONNECT3.FindScMe(UNICONNECT.P_GLOB_SC,
                                       UNICONNECT.P_GLOB_PG, UNICONNECT.P_GLOB_PGNODE,
                                       UNICONNECT.P_CET_PP_KEY1, UNICONNECT.P_CET_PP_KEY2, UNICONNECT.P_CET_PP_KEY3, UNICONNECT.P_CET_PP_KEY4, UNICONNECT.P_CET_PP_KEY5,
                                       UNICONNECT.P_CET_PP_VERSION,
                                       UNICONNECT.P_GLOB_PA, UNICONNECT.P_GLOB_PANODE,
                                       UNICONNECT.P_CET_PR_VERSION,
                                       UNICONNECT.P_CET_ME, UNICONNECT.P_CET_MEDESCRIPTION,
                                       UNICONNECT.P_CET_MENODE, UNICONNECT.P_CET_MT_VERSION,
                                       'description', l_me_pos, NULL);
         END IF;
      END IF;

      IF l_me_rec_found.menode IS NOT NULL THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         me found:me='||l_me_rec_found.me||'#menode='||l_me_rec_found.menode);
         UNICONNECT.P_GLOB_ME := l_me_rec_found.me;
         UNICONNECT.P_GLOB_MENODE := l_me_rec_found.menode;
         IF l_me_rec_found.exec_end_date IS NOT NULL AND UNICONNECT.P_SET_ALLOW_REANALYSIS = 'N' THEN
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : me already executed, new result in [cell table] section AND no reanalysis authorised !');
            l_ret_code := UNAPIGEN.DBERR_GENFAIL;
            RAISE StpError;
         END IF ;
      ELSE
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : me not found ! me is mandatory for [cell table] section !');
         RETURN(UNAPIGEN.DBERR_NOPARENTOBJECT);
      END IF;

   ELSE
      UNICONNECT.P_GLOB_ME := UNICONNECT.P_CET_ME;
      UNICONNECT.P_GLOB_MENODE := UNICONNECT.P_CET_MENODE;
   END IF;

   --9. any cell specified ?
   --   YES   do nothing
   --   NO Major error : cell is mandatory in a [cell table] section
   IF UNICONNECT.P_CET_NR_OF_ROWS = 0 THEN
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : cell is mandatory for [cell table] section !');
      RETURN(UNAPIGEN.DBERR_NOOBJID);
   ELSE
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         '||UNICONNECT.P_CET_NR_OF_ROWS||' cell(s) in [cell table] section');
   END IF;

   --10. Call GetScMeCell and store the returned cell in a different local array (will create the cells when necessary)
   --   This will create the method sheet details when not existing already
   --   when no cells are found and PG|PA is NULL => pg / and pa / are not created : can be done by preceding the cell section by a method section
   --   Copy found PG/PGNODE/PA/PANODE in SaveScMeCellTable for the same reason
   --   LOOP through all cell array
   --       return an error when the specified cell does not exist
   --   END LOOP
   l_getcet_where_clause := 'WHERE sc = '''||UNICONNECT.P_GLOB_SC ||''' AND ';

   IF UNICONNECT.P_GLOB_PG IS NOT NULL THEN
      l_getcet_where_clause := l_getcet_where_clause ||
                              ' pg='''||UNICONNECT.P_GLOB_PG ||''' AND pgnode=' ||TO_CHAR(UNICONNECT.P_GLOB_PGNODE)||' AND ';

   ELSIF l_me_rec_found.menode IS NOT NULL THEN
      l_getcet_where_clause := l_getcet_where_clause ||
                              ' pg='''|| l_me_rec_found.pg ||''' AND pgnode=' ||TO_CHAR(l_me_rec_found.pgnode)||' AND ';

   END IF;
   IF UNICONNECT.P_GLOB_PA IS NOT NULL THEN
      l_getcet_where_clause := l_getcet_where_clause ||
                              ' pa='''||UNICONNECT.P_GLOB_PA ||''' AND panode=' ||TO_CHAR(UNICONNECT.P_GLOB_PANODE)||' AND ';

   ELSIF l_me_rec_found.menode IS NOT NULL THEN
      l_getcet_where_clause := l_getcet_where_clause ||
                              ' pa='''|| l_me_rec_found.pa ||''' AND panode=' ||TO_CHAR(l_me_rec_found.panode)||' AND ';

   END IF;

   l_getcet_where_clause := l_getcet_where_clause ||
                           ' me='''||UNICONNECT.P_GLOB_ME ||''' AND menode=' ||TO_CHAR(UNICONNECT.P_GLOB_MENODE)||' ORDER BY pgnode,panode, menode';


   l_sql_string := 'SELECT sc, pg, pgnode, pa, panode, me, menode, reanalysis, exec_end_date FROM utscme ' || l_getcet_where_clause ;

   BEGIN -- Fetch method properties.
      l_scme_cursor := DBMS_SQL.OPEN_CURSOR;

      DBMS_SQL.PARSE (l_scme_cursor, l_sql_string, DBMS_SQL.V7);

      DBMS_SQL.DEFINE_COLUMN(l_scme_cursor,      1, l_scme_sc, 20);
      DBMS_SQL.DEFINE_COLUMN(l_scme_cursor,      2, l_scme_pg, 20);
      DBMS_SQL.DEFINE_COLUMN(l_scme_cursor,      3, l_scme_pgnode);
      DBMS_SQL.DEFINE_COLUMN(l_scme_cursor,      4, l_scme_pa, 20);
      DBMS_SQL.DEFINE_COLUMN(l_scme_cursor,      5, l_scme_panode);
      DBMS_SQL.DEFINE_COLUMN(l_scme_cursor,      6, l_scme_me, 20);
      DBMS_SQL.DEFINE_COLUMN(l_scme_cursor,      7, l_scme_menode);
      DBMS_SQL.DEFINE_COLUMN(l_scme_cursor,      8, l_scme_reanalysis);
      DBMS_SQL.DEFINE_COLUMN(l_scme_cursor,      9, l_scme_exec_end_date);
      l_result := DBMS_SQL.EXECUTE_AND_FETCH(l_scme_cursor);

      IF l_result = 0 THEN
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : me not found in [cell] section');
            l_ret_code := UNAPIGEN.DBERR_GENFAIL;
            DBMS_SQL.CLOSE_CURSOR(l_scme_cursor);
            RAISE StpError;
      END IF ;

      DBMS_SQL.COLUMN_VALUE(l_scme_cursor,      1, l_scme_sc);
      DBMS_SQL.COLUMN_VALUE(l_scme_cursor,      2, l_scme_pg);
      DBMS_SQL.COLUMN_VALUE(l_scme_cursor,      3, l_scme_pgnode);
      DBMS_SQL.COLUMN_VALUE(l_scme_cursor,      4, l_scme_pa);
      DBMS_SQL.COLUMN_VALUE(l_scme_cursor,      5, l_scme_panode);
      DBMS_SQL.COLUMN_VALUE(l_scme_cursor,      6, l_scme_me);
      DBMS_SQL.COLUMN_VALUE(l_scme_cursor,      7, l_scme_menode);
      DBMS_SQL.COLUMN_VALUE(l_scme_cursor,      8, l_scme_reanalysis);
      DBMS_SQL.COLUMN_VALUE(l_scme_cursor,      9, l_scme_exec_end_date);

      DBMS_SQL.CLOSE_CURSOR(l_scme_cursor);
   EXCEPTION
   WHEN OTHERS THEN
      l_sqlerrm := SQLERRM;

      IF DBMS_SQL.IS_OPEN (l_scme_cursor) THEN
         DBMS_SQL.CLOSE_CURSOR (l_scme_cursor);
      END IF;

      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : Exception while retrieving me in [cell] section');
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'           ' ||  l_sqlerrm);
      l_ret_code := UNAPIGEN.DBERR_GENFAIL;
      RAISE StpError;
   END ;

   IF l_scme_exec_end_date IS NOT NULL THEN
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         me already executed');
      IF UNICONNECT.P_SET_ALLOW_REANALYSIS = 'N' THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : me already executed, new result in [table] section AND no reanalysis authorised !');
         l_ret_code := UNAPIGEN.DBERR_GENFAIL;
         RAISE StpError;
      ELSE
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         me already executed and new me result in [table] section => me reanalysis');
         l_ret_code := UNAPIMEP.ReanalScMethod(l_scme_sc,
                                               l_scme_pg,
                                               l_scme_pgnode,
                                               l_scme_pa,
                                               l_scme_panode,
                                               l_scme_me,
                                               l_scme_menode,
                                               l_scme_reanalysis,
                                               'Uniconnect : new result for this method');
         IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : ReanalScMethod failed ret_code : '||l_ret_code ||
                                           '#sc='||l_scme_sc||
                                           '#pg='||l_scme_pg||
                                           '#pgnode='||l_scme_pgnode||
                                           '#pa='||l_scme_pa||
                                           '#panode='||l_scme_panode||
                                           '#me='||l_scme_me||
                                           '#menode='||l_scme_menode||
                                           '#reanalysis='||l_scme_reanalysis);
            RAISE StpError;
         ELSE
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         OK : ReanalScMethod performed' );
         END IF;
      END IF ;
   ELSE
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         me not yet executed');
   END IF ;

   l_getcet_nr_of_rows := UNAPIGEN.P_MAX_CHUNK_SIZE;
   l_getcet_next_rows := 0;

   --The 2 API calls GetScMeCell and SaveScMeCellTable must be within
   --one transaction (a transaction must be started when not yet started in this function
   --this transaction will enclose the 2 api calls

   IF UNAPIGEN.P_TXN_LEVEL = 0 THEN
      l_return := UNAPIGEN.BeginTransaction;
      IF l_return <> UNAPIGEN.DBERR_SUCCESS THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         UNAPIGEN.BeginTransaction failed ! ret_code='||TO_CHAR(l_return));
      END IF;
      l_internal_transaction := TRUE;
   ELSE
      l_internal_transaction := FALSE;
   END IF;

   BEGIN

      l_ret_code := UNAPIME.GETSCMECELL
                   (l_getcet_sc_tab,
                    l_getcet_pg_tab,
                    l_getcet_pgnode_tab,
                    l_getcet_pa_tab,
                    l_getcet_panode_tab,
                    l_getcet_me_tab,
                    l_getcet_menode_tab,
                    l_getcet_reanalysis_tab,
                    l_getcet_cell_tab,
                    l_getcet_cellnode_tab,
                    l_getcet_dsp_title_tab,
                    l_getcet_value_f_tab,
                    l_getcet_value_s_tab,
                    l_getcet_cell_tp_tab,
                    l_getcet_pos_x_tab,
                    l_getcet_pos_y_tab,
                    l_getcet_align_tab,
                    l_getcet_winsize_x_tab,
                    l_getcet_winsize_y_tab,
                    l_getcet_is_protected_tab,
                    l_getcet_mandatory_tab,
                    l_getcet_hidden_tab,
                    l_getcet_unit_tab,
                    l_getcet_format_tab,
                    l_getcet_eq_tab,
                    l_getcet_eq_version_tab,
                    l_getcet_component_tab,
                    l_getcet_calc_tp_tab,
                    l_getcet_calc_formula_tab,
                    l_getcet_valid_cf_tab,
                    l_getcet_max_x_tab,
                    l_getcet_max_y_tab,
                    l_getcet_multi_select_tab,
                    l_getcet_reanalysedresult_tab,
                    l_getcet_nr_of_rows,
                    l_getcet_where_clause,
                    l_getcet_next_rows);

      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         IF l_ret_code <> UNAPIGEN.DBERR_NORECORDS THEN
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : GetScMeCell ret_code : '||l_ret_code|| ' used where clause:' );
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         '||l_getcet_where_clause );
            RAISE StpError;
         ELSE
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : No cells for this method ! (check utmtcell)' );
            RAISE StpError;
         END IF;
      ELSE
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         OK : GetScMeCell performed (will create the cells when not existing)' );
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         nr_of_rows returned '||l_getcet_nr_of_rows );
      END IF;


      --find corresponding record in l_getce array (cellnode can be specified or not)
      l_find_ce_row := 0;
      FOR l_getrow IN 1..l_getcet_nr_of_rows LOOP
         IF l_getcet_cell_tab(l_getrow) = UNICONNECT.P_CET_CE  OR
            l_getcet_dsp_title_tab(l_getrow) = UNICONNECT.P_CET_CEDESCRIPTION THEN
            --cell description was provided but id is empty
            IF l_getcet_dsp_title_tab(l_getrow) = UNICONNECT.P_CET_CEDESCRIPTION AND
               UNICONNECT.P_CET_CE IS NULL THEN
               UNICONNECT.P_CET_CE := l_getcet_cell_tab(l_getrow);
            END IF;
            IF l_getcet_cell_tp_tab(l_getrow) IN ('T', 'C', 'D') THEN
               l_find_ce_row := l_getrow;
               EXIT;
            END IF;
         END IF;
      END LOOP;

      IF l_find_ce_row = 0 THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : No cell=' || UNICONNECT.P_CET_CE ||
                                               ' with cell_tp T,C or D in me : '||UNICONNECT.P_CET_ME);
         RAISE StpError;
      END IF;

      --Initialise the nodes since these are mandatory in the section
      UNICONNECT.P_CET_PGNODE := l_getcet_pgnode_tab(l_find_ce_row);
      UNICONNECT.P_CET_PANODE := l_getcet_panode_tab(l_find_ce_row);
      UNICONNECT.P_CET_MENODE := l_getcet_menode_tab(l_find_ce_row);

      --Initialise reanalysis
      UNICONNECT.P_CET_REANALYSIS := l_getcet_reanalysis_tab(l_find_ce_row);

      --Initialise CE and CENODE global variables
      UNICONNECT.P_GLOB_CE := l_getcet_cell_tab(l_find_ce_row);
      UNICONNECT.P_GLOB_CENODE := l_getcet_cellnode_tab(l_find_ce_row);

      --Fill in the cell in the SaveScMeCellTable array
      --Only one cell table in one [cell table] section
      FOR l_row IN 1..UNICONNECT.P_CET_NR_OF_ROWS LOOP
         UNICONNECT.P_CET_CE_TAB(l_row)     := UNICONNECT.P_CET_CE;
      END LOOP;

      --Special rule for value_f and value_s :
      --Rule : when only value_f specified => value_s from record nomore used
      --          when only value_s specified => value_f from record nomore used
      --          when value_s AND value_f specified => all values from record ignored
      FOR l_row IN 1..UNICONNECT.P_CET_NR_OF_ROWS LOOP

         --Try to format value_f since SaveScMeCellTable is not formatting it
         BEGIN
            IF UNICONNECT.P_CET_VALUE_F_MODTAB(l_row) THEN
               IF UNICONNECT.P_CET_VALUE_S_MODTAB(l_row) THEN
                  NULL;
               ELSE
                  IF SUBSTR(l_getcet_format_tab(l_find_ce_row), 1, 1) = 'C' THEN
                     IF l_getcet_format_tab(l_find_ce_row) = 'C' THEN
                        UNICONNECT.P_CET_VALUE_S_TAB(l_row) := UNICONNECT.P_CET_VALUE_F_TAB(l_row);
                     ELSE
                        UNICONNECT.P_CET_VALUE_S_TAB(l_row) := SUBSTR(UNICONNECT.P_CET_VALUE_F_TAB(l_row),1,TO_NUMBER(SUBSTR(l_getcet_format_tab(l_find_ce_row), 2)));
                     END IF;
                  ELSIF SUBSTR(l_getcet_format_tab(l_find_ce_row), 1, 1) = 'D' THEN
                     UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NORMAL,'         Warning : value_f can not be converted to a DATE' );

                  ELSE
                     l_result := UNAPIGEN.FormatResult(UNICONNECT.P_CET_VALUE_F_TAB(l_row),
                                                       l_getcet_format_tab(l_find_ce_row),
                                                       UNICONNECT.P_CET_VALUE_S_TAB(l_row));
                     IF l_result <> UNAPIGEN.DBERR_SUCCESS THEN
                        UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NORMAL,'         Warning : FormatResult failed '||l_result );

                     END IF;
                  END IF;
               END IF;
            ELSIF UNICONNECT.P_CET_VALUE_S_MODTAB(l_row) THEN
               --Special rule for value_f and value_s :
               --Rule : when only value_f specified => value_s from record nomore used
               --          when only value_s specified => value_f from record nomore used
               --          when value_s AND value_f specified => all values from record ignored
               l_ret_code := UNICONNECT6.SpecialRulesForValues(UNICONNECT.P_CET_VALUE_S_MODTAB(l_row),
                                                               UNICONNECT.P_CET_VALUE_S_TAB(l_row),
                                                               UNICONNECT.P_CET_VALUE_F_MODTAB(l_row),
                                                               UNICONNECT.P_CET_VALUE_F_TAB(l_row),
                                                               l_getcet_format_tab(l_find_ce_row),
                                                               l_getcet_value_s_tab(l_find_ce_row),
                                                               l_getcet_value_f_tab(l_find_ce_row));
               IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
                  UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NORMAL,'         ret_code='||TO_CHAR(l_ret_code)||
                                                        ' returned by UNICONNECT6.SpecialRulesForValues#value_s='||
                                                        UNICONNECT.P_CET_VALUE_S_TAB(l_row)||'#value_f='||
                                                        TO_CHAR(UNICONNECT.P_CET_VALUE_F_TAB(l_row))||
                                                        '#format='||l_getcet_format_tab(l_find_ce_row));
                  RAISE StpError;
               END IF;

               BEGIN
                  --Retsore implicit conversion when no special rule found
                  IF l_getcet_value_f_tab(l_find_ce_row) IS NULL THEN
                     l_getcet_value_f_tab(l_find_ce_row) := UNICONNECT.P_CET_VALUE_S_TAB(l_row);
                  END IF;
               EXCEPTION
               WHEN VALUE_ERROR THEN
                  UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NORMAL,'         Info, implicit conversion failed for value_s='||
                                                        UNICONNECT.P_CET_VALUE_S_TAB(l_row));
               END;
               UNICONNECT.P_CET_VALUE_F_TAB(l_row) := l_getcet_value_f_tab(l_find_ce_row);

            END IF;
         EXCEPTION
         WHEN VALUE_ERROR THEN
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NORMAL,'         Warning : VALUE_ERROR exception catched and ignored' );
         END;
      END LOOP;

      --close the open cursor with next_rows=-1
      l_getcet_next_rows := -1;

      l_ret_code := UNAPIME.GETSCMECELL
                   (l_getcet_sc_tab,
                    l_getcet_pg_tab,
                    l_getcet_pgnode_tab,
                    l_getcet_pa_tab,
                    l_getcet_panode_tab,
                    l_getcet_me_tab,
                    l_getcet_menode_tab,
                    l_getcet_reanalysis_tab,
                    l_getcet_cell_tab,
                    l_getcet_cellnode_tab,
                    l_getcet_dsp_title_tab,
                    l_getcet_value_f_tab,
                    l_getcet_value_s_tab,
                    l_getcet_cell_tp_tab,
                    l_getcet_pos_x_tab,
                    l_getcet_pos_y_tab,
                    l_getcet_align_tab,
                    l_getcet_winsize_x_tab,
                    l_getcet_winsize_y_tab,
                    l_getcet_is_protected_tab,
                    l_getcet_mandatory_tab,
                    l_getcet_hidden_tab,
                    l_getcet_unit_tab,
                    l_getcet_format_tab,
                    l_getcet_eq_tab,
                    l_getcet_eq_version_tab,
                    l_getcet_component_tab,
                    l_getcet_calc_tp_tab,
                    l_getcet_calc_formula_tab,
                    l_getcet_valid_cf_tab,
                    l_getcet_max_x_tab,
                    l_getcet_max_y_tab,
                    l_getcet_multi_select_tab,
                    l_getcet_reanalysedresult_tab,
                    l_getcet_nr_of_rows,
                    l_getcet_where_clause,
                    l_getcet_next_rows);

      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : GetScMeCell ret_code : '||l_ret_code|| ' next_rows = -1' );
         RAISE StpError;
      END IF;

      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'            Calling SaveScMeCellTable for '||UNICONNECT.P_CET_NR_OF_ROWS||' subcell(s)');
      FOR l_row IN 1..UNICONNECT.P_CET_NR_OF_ROWS LOOP
          UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'            row='||l_row||
                                         '#mod_flag='||UNICONNECT.P_CET_MODIFY_FLAG_TAB(l_row) ||
                                         '#sc='||UNICONNECT.P_CET_SC||'#pg='||UNICONNECT.P_CET_PG||
                                         '#pgnode='||NVL(TO_CHAR(UNICONNECT.P_CET_PGNODE),'NULL')||
                                         '#pa='||UNICONNECT.P_CET_PA||
                                         '#panode='||NVL(TO_CHAR(UNICONNECT.P_CET_PANODE),'NULL')||
                                         '#me='||UNICONNECT.P_CET_ME||
                                         '#menode='||NVL(TO_CHAR(UNICONNECT.P_CET_MENODE),'NULL')||
                                         '#cell='||UNICONNECT.P_CET_CE_TAB(l_row));
--          UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'            row='||l_row||
--                                         '#index_x='||UNICONNECT.P_CET_INDEX_X_TAB(l_row));
--          UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'            row='||l_row||
--                                         '#index_y='||UNICONNECT.P_CET_INDEX_Y_TAB(l_row));
--          UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'            row='||l_row||
--                                         '#value_f='||UNICONNECT.P_CET_VALUE_F_TAB(l_row));
--          UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'            row='||l_row||
--                                         '#value_s='||UNICONNECT.P_CET_VALUE_S_TAB(l_row));
--          UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'            row='||l_row||
--                                         '#selected='||UNICONNECT.P_CET_SELECTED_TAB(l_row));
--          UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'            row='||l_row||
--                                         '#mod_flag='||UNICONNECT.P_CET_MODIFY_FLAG_TAB(l_row));
      END LOOP;


      l_ret_code := UNICONNECT5.SAVESCMECELLTABLE
                   (UNICONNECT.P_CET_SC,
                    UNICONNECT.P_CET_PG,
                    UNICONNECT.P_CET_PGNODE,
                    UNICONNECT.P_CET_PA,
                    UNICONNECT.P_CET_PANODE,
                    UNICONNECT.P_CET_ME,
                    UNICONNECT.P_CET_MENODE,
                    UNICONNECT.P_CET_REANALYSIS,
                    UNICONNECT.P_CET_CE_TAB,
                    UNICONNECT.P_CET_INDEX_X_TAB,
                    UNICONNECT.P_CET_INDEX_Y_TAB,
                    UNICONNECT.P_CET_VALUE_F_TAB,
                    UNICONNECT.P_CET_VALUE_S_TAB,
                    UNICONNECT.P_CET_SELECTED_TAB,
                    UNICONNECT.P_CET_MODIFY_FLAG_TAB,
                    UNICONNECT.P_CET_NR_OF_ROWS);


      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error :SaveScMeCellTable ret_code='||l_ret_code ||
                                        '#sc='||UNICONNECT.P_CET_SC||'#pg='||UNICONNECT.P_CET_PG||
                                        '#pgnode='||NVL(TO_CHAR(UNICONNECT.P_CET_PGNODE),'NULL')||
                                        '#pa='||UNICONNECT.P_CET_PA||
                                        '#panode='||NVL(TO_CHAR(UNICONNECT.P_CET_PANODE),'NULL')||
                                        '#me='||UNICONNECT.P_CET_ME||
                                        '#menode='||NVL(TO_CHAR(UNICONNECT.P_CET_MENODE),'NULL')||
                                        '#cell(1)='||UNICONNECT.P_CET_CE_TAB(1)||
                                        '#mod_flag(1)='||UNICONNECT.P_CET_MODIFY_FLAG_TAB(1));
         IF l_ret_code = UNAPIGEN.DBERR_PARTIALSAVE THEN
            IF UNICONNECT.P_CET_NR_OF_ROWS > 0 THEN
               FOR l_row IN 1..UNICONNECT.P_CET_NR_OF_ROWS LOOP
                  IF UNICONNECT.P_CET_MODIFY_FLAG_TAB(l_row) > UNAPIGEN.DBERR_SUCCESS THEN
                     UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         SaveScMeCellTable authorisation problem row='||l_row||
                                                    '#mod_flag='||UNICONNECT.P_CET_MODIFY_FLAG_TAB(l_row) ||
                                                    '#sc='||UNICONNECT.P_CET_SC||'#pg='||UNICONNECT.P_CET_PG||
                                                    '#pgnode='||NVL(TO_CHAR(UNICONNECT.P_CET_PGNODE),'NULL')||
                                                    '#pa='||UNICONNECT.P_CET_PA||
                                                    '#panode='||NVL(TO_CHAR(UNICONNECT.P_CET_PANODE),'NULL')||
                                                    '#me='||UNICONNECT.P_CET_ME||
                                                    '#menode='||NVL(TO_CHAR(UNICONNECT.P_CET_MENODE),'NULL')||
                                                    '#cell='||UNICONNECT.P_CET_CE_TAB(l_row));
                  END IF;
               END LOOP;
            END IF;
            IF UNAPIAUT.P_NOT_AUTHORISED IS NOT NULL THEN
               UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         ' || UNAPIAUT.P_NOT_AUTHORISED );
            END IF;
            --Parial save does not interrupt the transaction
            UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_SUCCESS;
         ELSE
            RAISE StpError;
         END IF;
      END IF;

      --close internal transaction
      IF l_internal_transaction THEN
         l_return := UNICONNECT.FinishTransaction;
         IF l_return <> UNAPIGEN.DBERR_SUCCESS THEN
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         EndTransaction failed ! ret_code='||TO_CHAR(l_return));
         END IF;
      END IF;

   EXCEPTION
   WHEN OTHERS THEN
      --close internal transaction
      IF l_internal_transaction THEN
         l_return := UNICONNECT.FinishTransaction;
         IF l_return <> UNAPIGEN.DBERR_SUCCESS THEN
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         EndTransaction failed ! ret_code='||TO_CHAR(l_return));
         END IF;
      END IF;
      RETURN (UNAPIGEN.DBERR_GENFAIL);
   END;

   --11. Cleanup and reset section arrays
   UNICONNECT2.WriteGlobalVariablesToLog;
   UCON_CleanupMeCeTabSection;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

END UCON_ExecuteMeCeTabSection;

END uniconnect3;
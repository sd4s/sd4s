create or replace PACKAGE BODY
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
uniconnect4 AS

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

--private package variable for [ii] section
p_ii_icnode_setinsection      BOOLEAN DEFAULT FALSE;

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
/* procedures and functions related to the [ic] section */
/*------------------------------------------------------*/
PROCEDURE UCON_InitialiseScIcSection     /* INTERNAL */
IS
BEGIN

   --local variables initialisation
   UNICONNECT.P_IC_NR_OF_ROWS := 0;
   UNICONNECT.P_IC_SC := UNICONNECT.P_GLOB_SC;
   UNICONNECT.P_IC_MODIFY_REASON :=NULL;

   --global variables
   UNICONNECT.P_GLOB_IC := NULL;
   UNICONNECT.P_GLOB_ICNODE := NULL;

END UCON_InitialiseScIcSection;

FUNCTION UCON_AssignScIcSectionRow       /* INTERNAL */
RETURN NUMBER IS

l_description_pos      INTEGER;

BEGIN

   --Important assumption : one [ic] section is only related to one sample

   UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NONE,'      Assigning value of variable '||UNICONNECT.P_VARIABLE_NAME||' in [ic] section');
   IF UNICONNECT.P_VARIABLE_NAME = 'sc' THEN
      UNICONNECT.P_IC_SC := UNICONNECT.P_VARIABLE_VALUE;

   ELSIF UNICONNECT.P_VARIABLE_NAME = 'comment' THEN
      UNICONNECT.P_IC_MODIFY_REASON := UNICONNECT.P_VARIABLE_VALUE;
      UNICONNECT.P_IC_MODIFY_FLAG_TAB(UNICONNECT.P_IC_NR_OF_ROWS) := UNAPIGEN.MOD_FLAG_UPDATE;

   ELSIF UNICONNECT.P_VARIABLE_NAME = 'add_comment' THEN
      UNICONNECT.P_IC_ADD_COMMENT_TAB(UNICONNECT.P_IC_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;

   ELSIF UNICONNECT.P_VARIABLE_NAME = 'ss' THEN
      UNICONNECT.P_IC_SS_TAB(UNICONNECT.P_IC_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;

   ELSIF UNICONNECT.P_VARIABLE_NAME IN ('icnode', 'ic.icnode') THEN
      UNICONNECT.P_IC_ICNODE_TAB(UNICONNECT.P_IC_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;

   ELSIF UNICONNECT.P_VARIABLE_NAME IN ('ip_version', 'ic.ip_version') THEN
      UNICONNECT.P_IC_IP_VERSION_TAB(UNICONNECT.P_IC_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;

   ELSIF SUBSTR(UNICONNECT.P_VARIABLE_NAME,1,2) = 'ic' THEN
      --MUST BE PLACED after icnode variable assignment since SUBSTR will return ic
      --initialise full array except for sample code
      UNICONNECT.P_IC_NR_OF_ROWS := UNICONNECT.P_IC_NR_OF_ROWS + 1;

      --ic can be specified by description or by name
      l_description_pos := INSTR(UNICONNECT.P_VARIABLE_NAME, '.description');
      IF l_description_pos > 0 THEN
         UNICONNECT.P_IC_ICDESCRIPTION_TAB(UNICONNECT.P_IC_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;
         UNICONNECT.P_IC_IC_TAB(UNICONNECT.P_IC_NR_OF_ROWS) := NULL;
      ELSE
         UNICONNECT.P_IC_IC_TAB(UNICONNECT.P_IC_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;
         UNICONNECT.P_IC_ICDESCRIPTION_TAB(UNICONNECT.P_IC_NR_OF_ROWS) := NULL;
      END IF;

      UNICONNECT.P_IC_ICNAME_TAB(UNICONNECT.P_IC_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_NAME;

      UNICONNECT.P_IC_ICNODE_TAB(UNICONNECT.P_IC_NR_OF_ROWS)            := NULL;
      UNICONNECT.P_IC_IP_VERSION_TAB(UNICONNECT.P_IC_NR_OF_ROWS)        := NULL;
      UNICONNECT.P_IC_ADD_COMMENT_TAB(UNICONNECT.P_IC_NR_OF_ROWS)       := NULL;
      UNICONNECT.P_IC_MODIFY_FLAG_TAB(UNICONNECT.P_IC_NR_OF_ROWS)       := UNAPIGEN.DBERR_SUCCESS;
      UNICONNECT.P_IC_SS_TAB(UNICONNECT.P_IC_NR_OF_ROWS)                := NULL;

      --initialise all modify flags to FALSE

   ELSE
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_HIGH,'      Invalid variable '||UNICONNECT.P_VARIABLE_NAME||' in [ic] section');
      RETURN(UNAPIGEN.DBERR_INVALIDVARIABLE);
   END IF;
   RETURN(UNAPIGEN.DBERR_SUCCESS);

END UCON_AssignScIcSectionRow;

--FindScIc returns the utscic record corresponding
--to a specific search syntax
-- Examples : see FindScPg

FUNCTION FindScIc (a_sc          IN     VARCHAR2,
                   a_ic          IN OUT VARCHAR2,
                   a_description IN     VARCHAR2,
                   a_icnode      IN     NUMBER,
                   a_ip_version  IN     VARCHAR2,
                   a_search_base IN     VARCHAR2,
                   a_pos         IN INTEGER)
RETURN utscic%ROWTYPE IS

l_ic_rec       utscic%ROWTYPE;
l_leave_loop   BOOLEAN DEFAULT FALSE;
l_counter      INTEGER;

CURSOR l_scic_cursor IS
   SELECT *
   FROM utscic
   WHERE sc = a_sc
   AND ic = a_ic
   AND icnode = NVL(a_icnode,icnode)
   AND NVL(ip_version, '0') = NVL(a_ip_version, NVL(ip_version, '0'))
   ORDER BY icnode ASC;

CURSOR l_scicdesc_cursor IS
   SELECT *
   FROM utscic
   WHERE sc = a_sc
   AND description = a_description
   AND icnode = NVL(a_icnode,icnode)
   AND NVL(ip_version, '0') = NVL(a_ip_version, NVL(ip_version, '0'))
   ORDER BY icnode ASC;

BEGIN
   l_ic_rec := NULL;

   IF a_search_base = 'ic' THEN

      --find ic in xth position (x=a_pos)
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Searching for ic in position '||TO_CHAR(a_pos)||' for sc='||
                                             a_sc
                                             ||'#ic='||a_ic||'#icnode='||NVL(TO_CHAR(a_icnode),'NULL')
                                             ||'#ip_version='||a_ip_version
                                             );
      OPEN l_scic_cursor;
      l_counter := 0;
      LOOP
         FETCH l_scic_cursor
         INTO l_ic_rec;
         EXIT WHEN l_scic_cursor%NOTFOUND;
         --check if ic/icnode combination already used
         l_counter := l_counter + 1;
         IF l_counter >= a_pos THEN
            EXIT;
         ELSE
            l_ic_rec := NULL;
         END IF;
      END LOOP;
      CLOSE l_scic_cursor;

   ELSE

      --find ic in xth position (x=a_pos)
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Searching for ic (description) in position '||TO_CHAR(a_pos)||' for sc='||
                                             a_sc||'#description='||a_description||'#icnode='||NVL(TO_CHAR(a_icnode),'NULL')
                                             ||'#ip_version='||a_ip_version
                                             );
      OPEN l_scicdesc_cursor;
      l_counter := 0;
      LOOP
         FETCH l_scicdesc_cursor
         INTO l_ic_rec;
         EXIT WHEN l_scicdesc_cursor%NOTFOUND;
         --check if ic/icnode combination already used
         l_counter := l_counter + 1;
         IF l_counter >= a_pos THEN
            a_ic := l_ic_rec.ic;
            EXIT;
         ELSE
            l_ic_rec := NULL;
         END IF;
      END LOOP;
      CLOSE l_scicdesc_cursor;

   END IF;

   RETURN (l_ic_rec);

END FindScIc;

PROCEDURE UCON_CleanupScIcSection IS
BEGIN
   --Important since these variables should only
   --last for the execution of the [ic] section
   --but have to be implemented as global package variables
   --to keep it mantainable

   UNICONNECT.P_IC_SC_TAB.DELETE;
   UNICONNECT.P_IC_IC_TAB.DELETE;

   UNICONNECT.P_IC_ICNAME_TAB.DELETE;
   UNICONNECT.P_IC_ICDESCRIPTION_TAB.DELETE;

   UNICONNECT.P_IC_ICNODE_TAB.DELETE;
   UNICONNECT.P_IC_IP_VERSION_TAB.DELETE;
   UNICONNECT.P_IC_DESCRIPTION_TAB.DELETE;
   UNICONNECT.P_IC_WINSIZE_X_TAB.DELETE;
   UNICONNECT.P_IC_WINSIZE_Y_TAB.DELETE;
   UNICONNECT.P_IC_IS_PROTECTED_TAB.DELETE;
   UNICONNECT.P_IC_HIDDEN_TAB.DELETE;
   UNICONNECT.P_IC_MANUALLY_ADDED_TAB.DELETE;
   UNICONNECT.P_IC_NEXT_II_TAB.DELETE;
   UNICONNECT.P_IC_IC_CLASS_TAB.DELETE;
   UNICONNECT.P_IC_LOG_HS_TAB.DELETE;
   UNICONNECT.P_IC_LOG_HS_DETAILS_TAB.DELETE;
   UNICONNECT.P_IC_LC_TAB.DELETE;
   UNICONNECT.P_IC_LC_VERSION_TAB.DELETE;
   UNICONNECT.P_IC_MODIFY_FLAG_TAB.DELETE;
   UNICONNECT.P_IC_ADD_COMMENT_TAB.DELETE;
   UNICONNECT.P_IC_SS_TAB.DELETE;

   UNICONNECT.P_IC_SC := NULL;
   UNICONNECT.P_IC_MODIFY_REASON := NULL;

   UNICONNECT.P_IC_NR_OF_ROWS  := 0;
END UCON_CleanupScIcSection;

FUNCTION UCON_ExecuteScIcSection         /* INTERNAL */
RETURN NUMBER IS

l_sc                   VARCHAR2(20);
l_variable_name        VARCHAR2(20);
l_ip                   VARCHAR2(20);
l_description_pos      INTEGER;
l_openbrackets_pos     INTEGER;
l_closebrackets_pos    INTEGER;
l_ic_pos               INTEGER;
l_ic_rec_found         utscic%ROWTYPE;
l_any_save             BOOLEAN DEFAULT FALSE;

/* InitScInfoCard : local variables */
l_initic_ip                          VARCHAR2(20);
l_initic_ip_version_in               VARCHAR2(20);
l_initic_seq                         NUMBER;
l_initic_st                          VARCHAR2(20);
l_initic_st_version                  VARCHAR2(20);
l_initic_sc                          VARCHAR2(20);
l_initic_nr_of_rows                  NUMBER;
l_initic_ip_version_tab              UNAPIGEN.VC20_TABLE_TYPE;
l_initic_description_tab             UNAPIGEN.VC40_TABLE_TYPE;
l_initic_winsize_x_tab               UNAPIGEN.NUM_TABLE_TYPE;
l_initic_winsize_y_tab               UNAPIGEN.NUM_TABLE_TYPE;
l_initic_is_protected_tab            UNAPIGEN.CHAR1_TABLE_TYPE;
l_initic_hidden_tab                  UNAPIGEN.CHAR1_TABLE_TYPE;
l_initic_manually_added_tab          UNAPIGEN.CHAR1_TABLE_TYPE;
l_initic_next_ii_tab                 UNAPIGEN.VC20_TABLE_TYPE;
l_initic_ic_class_tab                UNAPIGEN.VC2_TABLE_TYPE;
l_initic_log_hs_tab                  UNAPIGEN.CHAR1_TABLE_TYPE;
l_initic_log_hs_details_tab          UNAPIGEN.CHAR1_TABLE_TYPE;
l_initic_lc_tab                      UNAPIGEN.VC2_TABLE_TYPE;
l_initic_lc_version_tab              UNAPIGEN.VC20_TABLE_TYPE;

CURSOR l_ipdescription_cursor (a_description IN VARCHAR2,
                               a_ip_version  IN VARCHAR2) IS
   SELECT ip
   FROM utip
   WHERE description = a_description
   AND NVL(version, '0') = NVL(a_ip_version, NVL(version, '0'));

   FUNCTION ChangeScIcStatusOrCancel
    (a_sc                IN      VARCHAR2,     /* VC20_TYPE */
     a_ic                IN      VARCHAR2,     /* VC20_TYPE */
     a_icnode            IN      NUMBER,       /* LONG_TYPE */
     a_new_ss            IN      VARCHAR2,     /* VC2_TYPE */
     a_modify_reason     IN      VARCHAR2)     /* VC255_TYPE */
   RETURN NUMBER
   IS

   l_ret_code                    INTEGER;
   --Specific local variables for ChangeScIc and CancelScIc
   l_old_ss                      VARCHAR2(2);
   l_lc                          VARCHAR2(2);
   l_lc_version                  VARCHAR2(20);

   --Specific local variables for InsertEvent
   l_seq_nr                      NUMBER;
   l_ip_version                  VARCHAR2(20);

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
      l_ret_code := UNAPIICP.ChangeScIcStatus (a_sc, a_ic, a_icnode, l_old_ss, a_new_ss, l_lc, l_lc_version, a_modify_reason);

      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         ChangeScIcStatus ret_code='||l_ret_code||
                                '#sc='||a_sc||'#ic='||a_ic||'#icnode='||a_icnode);
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         #old_ss='||l_old_ss||'#new_ss='||a_new_ss);
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         #lc='||l_lc||'#lc_version='||l_lc_version);
   ELSIF a_new_ss = '@C' THEN
      l_ret_code := UNAPIICP.CancelScIc (a_sc, a_ic, a_icnode, a_modify_reason);
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         CancelScIc ret_code='||l_ret_code||
                                '#sc='||a_sc||'#ic='||a_ic||'#icnode='||a_icnode);
   END IF;
   IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NORMAL,'         CancelScIc/ChSsScIc failed:ret_code='||l_ret_code||
                                '#sc='||a_sc||'#ic='||a_ic||'#icnode='||a_icnode||'. Event will be sent instead.');
      IF UNAPIAUT.P_NOT_AUTHORISED IS NOT NULL THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NORMAL,'         Authorisation error='||UNAPIAUT.P_NOT_AUTHORISED);
      END IF;
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_SUCCESS; --to be sure that no rollback is taking place on EndTransaction
      --InsertEvent InfoCardUpdated with ss_to=<new status>
      l_seq_nr := NULL;
      SELECT ip_version
      INTO l_ip_version
      FROM utscic
      WHERE sc = a_sc
      AND ic = a_ic
      AND icnode = a_icnode;
      l_ret_code := UNAPIEV.InsertEvent
                      (a_api_name          => 'ChangeScIcStatusOrCancel',
                       a_evmgr_name        => UNAPIGEN.P_EVMGR_NAME,
                       a_object_tp         => 'ic',
                       a_object_id         => a_ic,
                       a_object_lc         => NULL,
                       a_object_lc_version => NULL,
                       a_object_ss         => NULL,
                       a_ev_tp             => 'InfoCardUpdated',
                       a_ev_details        => 'sc='||a_sc||'#icnode='||a_icnode||
                                              '#ip_version='||l_ip_version||'#ss_to='||a_new_ss,
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
   END ChangeScIcStatusOrCancel;

BEGIN

   l_ret_code := UNAPIGEN.DBERR_SUCCESS;
   --1. sc validation
   IF UNICONNECT.P_IC_SC IS NULL THEN
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : sample is mandatory for [ic] section !');
      l_ret_code := UNAPIGEN.DBERR_NOPARENTOBJECT;
      RAISE StpError;
   END IF;

   --2. sc modified in [ic] section ?
   --    NO    set global variable SC
   --    YES   verify if provided sample code exist :error when not + set global variable SC
   --    Copy sc in savescinfocard array
   IF NVL(UNICONNECT.P_GLOB_SC,' ') <> NVL(UNICONNECT.P_IC_SC,' ') THEN
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Sc directly searched:'||UNICONNECT.P_IC_SC);
      OPEN l_sc_cursor(UNICONNECT.P_IC_SC);
      FETCH l_sc_cursor
      INTO l_sc;
      CLOSE l_sc_cursor;
      IF l_sc IS NULL THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : sc does not exist ! sc is mandatory for [ic] section !');
         l_ret_code := UNAPIGEN.DBERR_NOPARENTOBJECT;
         RAISE StpError;
      END IF;
      UNICONNECT.P_GLOB_SC := UNICONNECT.P_IC_SC;
   ELSE
      UNICONNECT.P_GLOB_SC := UNICONNECT.P_IC_SC;
   END IF;

   FOR l_row IN 1..UNICONNECT.P_IC_NR_OF_ROWS LOOP
      UNICONNECT.P_IC_SC_TAB(l_row) := UNICONNECT.P_GLOB_SC;
   END LOOP;

   --3. any ic specified ?
   --    YES   do nothing
   --    NO    Major error : ic is mandatory in a [ic] section
   IF UNICONNECT.P_IC_NR_OF_ROWS = 0 THEN
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : ic is mandatory for [ic] section !');
      l_ret_code := UNAPIGEN.DBERR_NOOBJID;
      RAISE StpError;
   END IF;

   --4.  create_ic ?
   --   Y|INSERT|INSERT_WITH_NODES
   --      LOOP through all ic array
   --         ic[] notation will not be ignored
   --         icnode will not be checked (Save api will return an error when not NULL)
   --         ic.description used ?
   --         YES   ic.description => find corresponding ic description in utip and fill in corresponding ic
   --         NO use ic or ic.ic directly
   --         Set modify flag to MOD_FLAG_CREATE|MOD_FLAG_INSERT|MOD_FLAG_INSERT_WITH_NODES
   --         Section setting for icnode is erased when MOD_FLAG_CREATE|MOD_FLAG_INSERT are used
   --      END LOOP
   --   N|W
   --      LOOP through all ic array
   --         ic[x] syntax used and/or description syntax used ?
   --            YES   find corresponding icnode (find xth ic for this sc and this sc order by icnode ASC)
   --               ic[] notation is not supported since there is no exec_end_date for ic
   --            NO use the first ic with this name (ORDER BY icnode)
   --         ic found ?
   --            YES   set modify flag to UNAPIGEN.DBERR_SUCCESS
   --                  set the node correctly for correct node numbering
   --                  Initialise SaveScInfoCard array variables with the values coming from the record or from the section
   --                  (Values from the section will overrule the value from the record)
   --            NO
   --               create_ic ?
   --               N
   --                  Major error
   --               W
   --                  Set modify flag to UNAPIGEN.MOD_FLAG_CREATE
   --                  Set node to NULL
   --      END LOOP
   IF UNICONNECT.P_SET_CREATE_IC IN ('Y', 'INSERT', 'INSERT_WITH_NODES') THEN
      FOR l_row IN 1..UNICONNECT.P_IC_NR_OF_ROWS LOOP

         --description used ? -> find ip in utip
         l_variable_name := UNICONNECT.P_IC_ICNAME_TAB(l_row);
         l_description_pos := INSTR(l_variable_name, '.description');
         IF l_description_pos > 0 THEN
            OPEN l_ipdescription_cursor(UNICONNECT.P_IC_ICDESCRIPTION_TAB(l_row),
                                        UNICONNECT.P_IC_IP_VERSION_TAB(l_row));
            FETCH l_ipdescription_cursor
            INTO l_ip;
            IF l_ipdescription_cursor%NOTFOUND THEN
               --Major error no corresponding ip found
               CLOSE l_ipdescription_cursor;
               UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : no corresponding ip for description '||UNICONNECT.P_IC_ICDESCRIPTION_TAB(l_row));
               l_ret_code := UNAPIGEN.DBERR_NOOBJID;
               RAISE StpError;
            END IF;
            CLOSE l_ipdescription_cursor;
            UNICONNECT.P_IC_IC_TAB(l_row) := l_ip;
         END IF;

         --Set Modify flag to MOD_FLAG_CREATE|MOD_FLAG_INSERT|MOD_FLAG_INSERT_WITH_NODES
         --Section setting for icnode is erased when MOD_FLAG_CREATE|MOD_FLAG_INSERT are used
         IF UNICONNECT.P_SET_CREATE_IC = 'INSERT' THEN
            UNICONNECT.P_IC_MODIFY_FLAG_TAB(l_row) := UNAPIGEN.MOD_FLAG_INSERT;
            UNICONNECT.P_IC_ICNODE_TAB(l_row) := NULL;
         ELSIF UNICONNECT.P_SET_CREATE_IC = 'INSERT_WITH_NODES' THEN
            UNICONNECT.P_IC_MODIFY_FLAG_TAB(l_row) := UNAPIGEN.MOD_FLAG_INSERT_WITH_NODES;
         ELSE
            UNICONNECT.P_IC_MODIFY_FLAG_TAB(l_row) := UNAPIGEN.MOD_FLAG_CREATE;
            UNICONNECT.P_IC_ICNODE_TAB(l_row) := NULL;
         END IF;


      END LOOP;
   ELSE

      FOR l_row IN 1..UNICONNECT.P_IC_NR_OF_ROWS LOOP

         --description used ? -> find pp in utpp
         l_variable_name := UNICONNECT.P_IC_ICNAME_TAB(l_row);
         l_description_pos := INSTR(l_variable_name, '.description');
         l_openbrackets_pos := INSTR(l_variable_name, '[');
         l_closebrackets_pos := INSTR(l_variable_name, ']');
         l_ic_pos := TO_NUMBER(SUBSTR(l_variable_name,l_openbrackets_pos+1,l_closebrackets_pos-l_openbrackets_pos-1));

         l_ic_rec_found := NULL;

         IF l_openbrackets_pos = 0 THEN
            IF l_description_pos = 0 THEN
               --ic or ic.ic used
               l_ic_rec_found := FindScIc(UNICONNECT.P_GLOB_SC,
                                          UNICONNECT.P_IC_IC_TAB(l_row), UNICONNECT.P_IC_ICDESCRIPTION_TAB(l_row),
                                          UNICONNECT.P_IC_ICNODE_TAB(l_row), UNICONNECT.P_IC_IP_VERSION_TAB(l_row),
                                                   'ic', 1);
            ELSE
               --ic.description used
               l_ic_rec_found := FindScIc(UNICONNECT.P_GLOB_SC,
                                          UNICONNECT.P_IC_IC_TAB(l_row), UNICONNECT.P_IC_ICDESCRIPTION_TAB(l_row),
                                          UNICONNECT.P_IC_ICNODE_TAB(l_row), UNICONNECT.P_IC_IP_VERSION_TAB(l_row),
                                          'description', 1);
            END IF;
         ELSE
            IF l_description_pos = 0 THEN
               --ic[x] or ic[x].ic used
               l_ic_rec_found := FindScIc(UNICONNECT.P_GLOB_SC,
                                          UNICONNECT.P_IC_IC_TAB(l_row), UNICONNECT.P_IC_ICDESCRIPTION_TAB(l_row),
                                          UNICONNECT.P_IC_ICNODE_TAB(l_row), UNICONNECT.P_IC_IP_VERSION_TAB(l_row),
                                                   'ic', NVL(l_ic_pos,0));
            ELSE
               --ic[x].description used
               l_ic_rec_found := FindScIc(UNICONNECT.P_GLOB_SC,
                                          UNICONNECT.P_IC_IC_TAB(l_row), UNICONNECT.P_IC_ICDESCRIPTION_TAB(l_row),
                                          UNICONNECT.P_IC_ICNODE_TAB(l_row), UNICONNECT.P_IC_IP_VERSION_TAB(l_row),
                                          'description', NVL(l_ic_pos,0));
            END IF;
         END IF;

         IF l_ic_rec_found.icnode IS NOT NULL THEN
            --ic found
            --initialise SaveScInfoCard array with fetched values when not set in section

            --always set
            UNICONNECT.P_IC_ICNODE_TAB(l_row)           := l_ic_rec_found.icnode;
            UNICONNECT.P_IC_IP_VERSION_TAB(l_row)       := l_ic_rec_found.ip_version;
            UNICONNECT.P_IC_DESCRIPTION_TAB(l_row)      := l_ic_rec_found.description;
            UNICONNECT.P_IC_WINSIZE_X_TAB(l_row)        := l_ic_rec_found.winsize_x;
            UNICONNECT.P_IC_WINSIZE_Y_TAB(l_row)        := l_ic_rec_found.winsize_y;
            UNICONNECT.P_IC_IS_PROTECTED_TAB(l_row)     := l_ic_rec_found.is_protected;
            UNICONNECT.P_IC_HIDDEN_TAB(l_row)           := l_ic_rec_found.hidden;
            UNICONNECT.P_IC_MANUALLY_ADDED_TAB(l_row)   := l_ic_rec_found.manually_added;
            UNICONNECT.P_IC_NEXT_II_TAB(l_row)          := l_ic_rec_found.next_ii;
            UNICONNECT.P_IC_IC_CLASS_TAB(l_row)         := l_ic_rec_found.ic_class;
            UNICONNECT.P_IC_LOG_HS_TAB(l_row)           := l_ic_rec_found.log_hs;
            UNICONNECT.P_IC_LOG_HS_DETAILS_TAB(l_row)   := l_ic_rec_found.log_hs_details;
            UNICONNECT.P_IC_LC_TAB(l_row)               := l_ic_rec_found.lc;
            UNICONNECT.P_IC_LC_VERSION_TAB(l_row)       := l_ic_rec_found.lc_version;

            --only when not set in section

            -- Note : MODIFY_FLAG_TAB has been set to MOD_FLAG_UPDATE in AssignScIcSection

         ELSE
            /* create_ic=N ? */
            IF UNICONNECT.P_SET_CREATE_IC = 'N' THEN

               UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NORMAL,'         Warning : section skipped : ic does not exist and can not be created');
               l_ret_code := UNAPIGEN.DBERR_SUCCESS;
               RAISE StpError;

            ELSE
               --find the ip corresponding to the provided description
               --in utip when description used to specify the ic
               IF l_description_pos > 0 THEN
                  OPEN l_ipdescription_cursor(UNICONNECT.P_IC_ICDESCRIPTION_TAB(l_row),
                                              UNICONNECT.P_IC_IP_VERSION_TAB(l_row));
                  FETCH l_ipdescription_cursor
                  INTO l_ip;
                  IF l_ipdescription_cursor%NOTFOUND THEN
                     --Major error no corresponding ip found
                     CLOSE l_ipdescription_cursor;
                     UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : no corresponding ip for description '||UNICONNECT.P_IC_ICDESCRIPTION_TAB(l_row));
                     l_ret_code := UNAPIGEN.DBERR_NOOBJID;
                     RAISE StpError;
                  END IF;
                  CLOSE l_ipdescription_cursor;
                  UNICONNECT.P_IC_IC_TAB(l_row) := l_ip;
               END IF;

               --Set Modify flag to MOD_FLAG_CREATE
               UNICONNECT.P_IC_MODIFY_FLAG_TAB(l_row) := UNAPIGEN.MOD_FLAG_CREATE;
               UNICONNECT.P_IC_ICNODE_TAB(l_row) := NULL;

            END IF;

         END IF;

      END LOOP;

   END IF;

   --5. any ic to create
   --   YES
   --      LOOP through all ic array
   --         Call InitScInfoCard for all ic which have to be created
   --         Initialise SaveScInfoCard array variables with the values coming
   --              from InitScInfoCard or from the section
   --                  (Values from the section will overrule the value from the InitScInfoCard)
   --      END LOOP
   --      Call SaveScInfoCard
   l_any_save := FALSE;
   FOR l_row IN 1..UNICONNECT.P_IC_NR_OF_ROWS LOOP

      IF UNICONNECT.P_IC_MODIFY_FLAG_TAB(l_row) IN (UNAPIGEN.MOD_FLAG_CREATE,
                                                 UNAPIGEN.MOD_FLAG_INSERT,
                                                 UNAPIGEN.MOD_FLAG_INSERT_WITH_NODES)
                                                 THEN

         l_any_save := TRUE;
         l_initic_ip := UNICONNECT.P_IC_IC_TAB(l_row);
         l_initic_ip_version_in := UNICONNECT.P_IC_IP_VERSION_TAB(l_row);
         l_initic_seq := NULL;
         l_initic_sc := UNICONNECT.P_GLOB_SC;
         BEGIN
            SELECT st, st_version
            INTO l_initic_st, l_initic_st_version
            FROM utsc
            WHERE sc=UNICONNECT.P_GLOB_SC;
         EXCEPTION
         WHEN NO_DATA_FOUND THEN
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : no record found in utsc for sc='||UNICONNECT.P_GLOB_SC);
            RAISE StpError;
         END;
         l_initic_nr_of_rows := NULL;

         l_ret_code := UNAPIIC.INITSCINFOCARD
                        (l_initic_ip,
                         l_initic_ip_version_in,
                         l_initic_seq,
                         l_initic_st,
                         l_initic_st_version,
                         l_initic_sc,
                         l_initic_ip_version_tab,
                         l_initic_description_tab,
                         l_initic_winsize_x_tab,
                         l_initic_winsize_y_tab,
                         l_initic_is_protected_tab,
                         l_initic_hidden_tab,
                         l_initic_manually_added_tab,
                         l_initic_next_ii_tab,
                         l_initic_ic_class_tab,
                         l_initic_log_hs_tab,
                         l_initic_log_hs_details_tab,
                         l_initic_lc_tab,
                         l_initic_lc_version_tab,
                         l_initic_nr_of_rows);

         IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : InitScInfoCard ret_code : '||l_ret_code ||
                                      '#ip='||l_initic_ip||'#ip_version_in='||l_initic_ip_version_in);
            RAISE StpError;
         ELSE
            --only when not set in section

            --always use initscinfocard values
            UNICONNECT.P_IC_IP_VERSION_TAB(l_row)       := l_initic_ip_version_tab(1);
            UNICONNECT.P_IC_DESCRIPTION_TAB(l_row)      := l_initic_description_tab(1);
            UNICONNECT.P_IC_WINSIZE_X_TAB(l_row)        := l_initic_winsize_x_tab(1);
            UNICONNECT.P_IC_WINSIZE_Y_TAB(l_row)        := l_initic_winsize_y_tab(1);
            UNICONNECT.P_IC_IS_PROTECTED_TAB(l_row)     := l_initic_is_protected_tab(1);
            UNICONNECT.P_IC_HIDDEN_TAB(l_row)           := l_initic_hidden_tab(1);
            UNICONNECT.P_IC_MANUALLY_ADDED_TAB(l_row)   := l_initic_manually_added_tab(1);
            UNICONNECT.P_IC_NEXT_II_TAB(l_row)          := l_initic_next_ii_tab(1);
            UNICONNECT.P_IC_IC_CLASS_TAB(l_row)         := l_initic_ic_class_tab(1);
            UNICONNECT.P_IC_LOG_HS_TAB(l_row)           := l_initic_log_hs_tab(1);
            UNICONNECT.P_IC_LOG_HS_DETAILS_TAB(l_row)   := l_initic_log_hs_details_tab(1);
            UNICONNECT.P_IC_LC_TAB(l_row)               := l_initic_lc_tab(1);
            UNICONNECT.P_IC_LC_VERSION_TAB(l_row)       := l_initic_lc_version_tab(1);

            --only when not set in section

         END IF;

      ELSIF UNICONNECT.P_IC_MODIFY_FLAG_TAB(l_row) IN (UNAPIGEN.MOD_FLAG_UPDATE,
                                                    UNAPIGEN.MOD_FLAG_DELETE) THEN
         l_any_save := TRUE;

      END IF;
   END LOOP;

   IF l_any_save THEN
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Calling SaveScInfoCard for :');
      FOR l_row IN 1..UNICONNECT.P_IC_NR_OF_ROWS LOOP
          UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'            row='||l_row||
                                         '#mod_flag='||UNICONNECT.P_IC_MODIFY_FLAG_TAB(l_row) ||
                                         '#sc='||UNICONNECT.P_IC_SC_TAB(l_row)||'#ic='||UNICONNECT.P_IC_IC_TAB(l_row)||
                                         '#icnode='||NVL(TO_CHAR(UNICONNECT.P_IC_ICNODE_TAB(l_row)),'NULL'));
      END LOOP;

      l_ret_code := Unapiic.SaveScInfoCard
                            (UNICONNECT.P_IC_SC_TAB,
                             UNICONNECT.P_IC_IC_TAB,
                             UNICONNECT.P_IC_ICNODE_TAB,
                             UNICONNECT.P_IC_IP_VERSION_TAB,
                             UNICONNECT.P_IC_DESCRIPTION_TAB,
                             UNICONNECT.P_IC_WINSIZE_X_TAB,
                             UNICONNECT.P_IC_WINSIZE_Y_TAB,
                             UNICONNECT.P_IC_IS_PROTECTED_TAB,
                             UNICONNECT.P_IC_HIDDEN_TAB,
                             UNICONNECT.P_IC_MANUALLY_ADDED_TAB,
                             UNICONNECT.P_IC_NEXT_II_TAB,
                             UNICONNECT.P_IC_IC_CLASS_TAB,
                             UNICONNECT.P_IC_LOG_HS_TAB,
                             UNICONNECT.P_IC_LOG_HS_DETAILS_TAB,
                             UNICONNECT.P_IC_LC_TAB,
                             UNICONNECT.P_IC_LC_VERSION_TAB,
                             UNICONNECT.P_IC_MODIFY_FLAG_TAB,
                             UNICONNECT.P_IC_NR_OF_ROWS,
                             UNICONNECT.P_IC_MODIFY_REASON);

      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : SaveScInfoCard ret_code='||l_ret_code ||
                                        '#sc(1)='||UNICONNECT.P_IC_SC_TAB(1)||'#ic(1)='||UNICONNECT.P_IC_IC_TAB(1)||
                                        '#icnode(1)='||NVL(TO_CHAR(UNICONNECT.P_IC_ICNODE_TAB(1)),'NULL')||'#mod_flag(1)='||UNICONNECT.P_IC_MODIFY_FLAG_TAB(1));
         IF l_ret_code = UNAPIGEN.DBERR_PARTIALSAVE AND UNICONNECT.P_IC_NR_OF_ROWS > 1 THEN
            FOR l_row IN 1..UNICONNECT.P_IC_NR_OF_ROWS LOOP
               IF UNICONNECT.P_IC_MODIFY_FLAG_TAB(l_row) > UNAPIGEN.DBERR_SUCCESS THEN
                  UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         SaveScInfoCard authorisation problem row='||l_row||
                                                 '#mod_flag='||UNICONNECT.P_IC_MODIFY_FLAG_TAB(l_row) ||
                                                 '#sc='||UNICONNECT.P_IC_SC_TAB(l_row)||'#ic='||UNICONNECT.P_IC_IC_TAB(l_row)||
                                                 '#icnode='||NVL(TO_CHAR(UNICONNECT.P_IC_ICNODE_TAB(l_row)),'NULL'));
               END IF;
            END LOOP;
         END IF;
         RAISE StpError;

      END IF;
   ELSE
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NORMAL,'         No save(s) in [ic] section');
   END IF;

   --Perform a ChangeStatus or a Cancel when required
   FOR l_row IN 1..UNICONNECT.P_IC_NR_OF_ROWS LOOP
      IF UNICONNECT.P_IC_SS_TAB(l_row) IS NOT NULL THEN
         l_ret_code := ChangeScIcStatusOrCancel(UNICONNECT.P_IC_SC_TAB(l_row),
                                                UNICONNECT.P_IC_IC_TAB(l_row),
                                                UNICONNECT.P_IC_ICNODE_TAB(l_row),
                                                UNICONNECT.P_IC_SS_TAB(l_row),
                                                UNICONNECT.P_IC_MODIFY_REASON);
         IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : ChangeScIcStatusOrCancel ret_code='||l_ret_code ||
                                      '#sc='||UNICONNECT.P_IC_SC_TAB(l_row)||
                                      '#ic='||UNICONNECT.P_IC_IC_TAB(l_row)||
                                      '#icnode='||NVL(TO_CHAR(UNICONNECT.P_IC_ICNODE_TAB(l_row)),'NULL'));
            IF UNAPIAUT.P_NOT_AUTHORISED IS NOT NULL THEN
               UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         ' || UNAPIAUT.P_NOT_AUTHORISED );
            END IF;
            RAISE StpError;
         END IF;
      END IF;
   END LOOP;

   --Perform a AddComment when required
   FOR l_row IN 1..UNICONNECT.P_IC_NR_OF_ROWS LOOP
      IF UNICONNECT.P_IC_ADD_COMMENT_TAB(l_row) IS NOT NULL THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Adding Comment for'||
                                   '#sc='||UNICONNECT.P_IC_SC_TAB(l_row)||
                                   '#ic='||UNICONNECT.P_IC_IC_TAB(l_row)||
                                   '#icnode='||NVL(TO_CHAR(UNICONNECT.P_IC_ICNODE_TAB(l_row)),'NULL'));
         l_ret_code := UNAPIICP.AddScIcComment(UNICONNECT.P_IC_SC_TAB(l_row),
                                               UNICONNECT.P_IC_IC_TAB(l_row),
                                               UNICONNECT.P_IC_ICNODE_TAB(l_row),
                                               UNICONNECT.P_IC_ADD_COMMENT_TAB(l_row));

         IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : AddScIcComment ret_code='||l_ret_code ||
                                      '#sc='||UNICONNECT.P_IC_SC_TAB(l_row)||
                                      '#ic='||UNICONNECT.P_IC_IC_TAB(l_row)||
                                      '#icnode='||NVL(TO_CHAR(UNICONNECT.P_IC_ICNODE_TAB(l_row)),'NULL'));
            IF UNAPIAUT.P_NOT_AUTHORISED IS NOT NULL THEN
               UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         ' || UNAPIAUT.P_NOT_AUTHORISED );
            END IF;
            RAISE StpError;
         END IF;
      END IF;
   END LOOP;

   --6  Initialise IC and ICNODE global variables with the last ic in array
   --   Cleanup and reset used arrays
   IF UNICONNECT.P_IC_NR_OF_ROWS > 0 THEN
      UNICONNECT.P_GLOB_IC := UNICONNECT.P_IC_IC_TAB(UNICONNECT.P_IC_NR_OF_ROWS);
      UNICONNECT.P_GLOB_ICNODE := UNICONNECT.P_IC_ICNODE_TAB(UNICONNECT.P_IC_NR_OF_ROWS);
      UNICONNECT2.WriteGlobalVariablesToLog;
   ELSE
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NORMAL,'         Warning ! current ic and icnode not set before leaving ic section !');
   END IF;
   UCON_CleanupScIcSection;

   RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
WHEN OTHERS THEN
   --an exception can have been raised with l_ret_code = UNAPIGEN.DBERR_SUCCESS
   --this is done to skip the section without interrupting the file parsing
   IF sqlcode <> 1 THEN
      --the exception is not a user exception
      l_sqlerrm := SUBSTR(SQLERRM, 1, 200);
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Following exception catched in UCON_ExecuteScIcSection :');
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         '||l_sqlerrm);
      l_ret_code := UNAPIGEN.DBERR_GENFAIL;
   END IF;
   UCON_CleanupScIcSection;
   UNAPIGEN.P_TXN_ERROR := l_ret_code;
   RETURN(l_ret_code);
END UCON_ExecuteScIcSection;

/*------------------------------------------------------*/
/* procedures and functions related to the [ii] section */
/*------------------------------------------------------*/
PROCEDURE UCON_InitialiseScIiSection     /* INTERNAL */
IS
BEGIN

   --local variables initialisation
   UNICONNECT.P_II_NR_OF_ROWS := 0;
   UNICONNECT.P_II_SC := UNICONNECT.P_GLOB_SC;
   UNICONNECT.P_II_IC := UNICONNECT.P_GLOB_IC;
   UNICONNECT.P_II_ICNODE := UNICONNECT.P_GLOB_ICNODE;

   --internal to [ii] section
   UNICONNECT.P_II_USE_SAVESCIIVALUE := TRUE;
   UNICONNECT.P_II_ICNAME := NULL;
   UNICONNECT.P_II_ICDESCRIPTION := NULL;
   UNICONNECT.P_II_IP_VERSION := NULL;

   --private package variable for [ii] section
   p_ii_icnode_setinsection := FALSE;

   --global variables
   UNICONNECT.P_GLOB_II := NULL;
   UNICONNECT.P_GLOB_IINODE := NULL;


END UCON_InitialiseScIiSection;

FUNCTION UCON_AssignScIiSectionRow       /* INTERNAL */
RETURN NUMBER IS

l_description_pos      INTEGER;

BEGIN

   --Important assumption : one [ic] section is only related to one info card within one sample

   UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NONE,'      Assigning value of variable '||UNICONNECT.P_VARIABLE_NAME||' in [ii] section');
   IF UNICONNECT.P_VARIABLE_NAME = 'sc' THEN
      UNICONNECT.P_II_SC := UNICONNECT.P_VARIABLE_VALUE;

   ELSIF UNICONNECT.P_VARIABLE_NAME IN ('icnode', 'ic.icnode') THEN
      UNICONNECT.P_II_ICNODE := UNICONNECT.P_VARIABLE_VALUE;

      --Fatal error when ic not yet specified
      IF UNICONNECT.P_II_ICNAME IS NULL THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major problem ! icnode in ii section must be preceded by a ic setting');
         RETURN(UNAPIGEN.DBERR_GENFAIL);
      END IF;
      p_ii_icnode_setinsection := TRUE;

   ELSIF UNICONNECT.P_VARIABLE_NAME IN ('ip_version', 'ic.ip_version') THEN
      UNICONNECT.P_II_IP_VERSION := UNICONNECT.P_VARIABLE_VALUE;

   ELSIF UNICONNECT.P_VARIABLE_NAME = 'ss' THEN
      UNICONNECT.P_II_SS_TAB(UNICONNECT.P_II_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;

   ELSIF SUBSTR(UNICONNECT.P_VARIABLE_NAME,1,2) = 'ic' THEN
      --MUST BE PLACED after icnode variable assignment since SUBSTR will return ic

      --ic can be specified by description or by name
      l_description_pos := INSTR(UNICONNECT.P_VARIABLE_NAME, '.description');
      IF l_description_pos > 0 THEN
         UNICONNECT.P_II_ICDESCRIPTION := UNICONNECT.P_VARIABLE_VALUE;
         UNICONNECT.P_II_ICNAME        := UNICONNECT.P_VARIABLE_NAME;
         UNICONNECT.P_II_IC := NULL;
      ELSE
         UNICONNECT.P_II_IC            := UNICONNECT.P_VARIABLE_VALUE;
         UNICONNECT.P_II_ICNAME        := UNICONNECT.P_VARIABLE_NAME;
         UNICONNECT.P_II_ICDESCRIPTION := NULL;
      END IF;

      --also reset icnode : icnode is initialised with global setting icnode when entering
      --the section
      UNICONNECT.P_II_ICNODE := NULL;

   ELSIF UNICONNECT.P_VARIABLE_NAME = 'iivalue' THEN
      UNICONNECT.P_II_IIVALUE_TAB(UNICONNECT.P_II_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;
      UNICONNECT.P_II_IIVALUE_MODTAB(UNICONNECT.P_II_NR_OF_ROWS) := TRUE;
      UNICONNECT.P_II_MODIFY_FLAG_TAB(UNICONNECT.P_II_NR_OF_ROWS) := UNAPIGEN.MOD_FLAG_UPDATE;

   ELSIF UNICONNECT.P_VARIABLE_NAME = 'comment' THEN
      UNICONNECT.P_II_MODIFY_REASON := UNICONNECT.P_VARIABLE_VALUE;
      UNICONNECT.P_II_MODIFY_FLAG_TAB(UNICONNECT.P_II_NR_OF_ROWS) := UNAPIGEN.MOD_FLAG_UPDATE;

   ELSIF UNICONNECT.P_VARIABLE_NAME IN ('iinode', 'ii.iinode') THEN
      UNICONNECT.P_II_IINODE_TAB(UNICONNECT.P_II_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;

   ELSIF UNICONNECT.P_VARIABLE_NAME IN ('ie_version', 'ii.ie_version') THEN
      UNICONNECT.P_II_IE_VERSION_TAB(UNICONNECT.P_II_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;

   ELSIF SUBSTR(UNICONNECT.P_VARIABLE_NAME,1,2) = 'ii' THEN
      --MUST BE PLACED after iinode and iivalue variable assignment since SUBSTR will return ii
      --initialise full array except for sample code, ic and icnode
      UNICONNECT.P_II_NR_OF_ROWS := UNICONNECT.P_II_NR_OF_ROWS + 1;

      --ii can be specified by description or by name
      l_description_pos := INSTR(UNICONNECT.P_VARIABLE_NAME, '.description');
      IF l_description_pos > 0 THEN
         UNICONNECT.P_II_IIDESCRIPTION_TAB(UNICONNECT.P_II_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;
         UNICONNECT.P_II_II_TAB(UNICONNECT.P_II_NR_OF_ROWS) := NULL;
      ELSE
         UNICONNECT.P_II_II_TAB(UNICONNECT.P_II_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_VALUE;
         UNICONNECT.P_II_IIDESCRIPTION_TAB(UNICONNECT.P_II_NR_OF_ROWS) := NULL;
      END IF;

      UNICONNECT.P_II_IINAME_TAB(UNICONNECT.P_II_NR_OF_ROWS) := UNICONNECT.P_VARIABLE_NAME;

      UNICONNECT.P_II_IINODE_TAB(UNICONNECT.P_II_NR_OF_ROWS)            := NULL;
      UNICONNECT.P_II_IIVALUE_TAB(UNICONNECT.P_II_NR_OF_ROWS)           := NULL;
      UNICONNECT.P_II_IE_VERSION_TAB(UNICONNECT.P_II_NR_OF_ROWS)        := NULL;
      UNICONNECT.P_II_MODIFY_FLAG_TAB(UNICONNECT.P_II_NR_OF_ROWS)       := UNAPIGEN.DBERR_SUCCESS;
      UNICONNECT.P_II_SS_TAB(UNICONNECT.P_II_NR_OF_ROWS)                := NULL;

      --initialise all modify flags to FALSE
      UNICONNECT.P_II_IIVALUE_MODTAB(UNICONNECT.P_II_NR_OF_ROWS)              := FALSE;

   ELSE
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'      Invalid variable '||UNICONNECT.P_VARIABLE_NAME||' in [ii] section');
      RETURN(UNAPIGEN.DBERR_INVALIDVARIABLE);
   END IF;
   RETURN(UNAPIGEN.DBERR_SUCCESS);

END UCON_AssignScIiSectionRow;

--ScIiUseValue is an Overloaded function : one returning a NUMBER and the other one reurning VARCHAR2
--ScIiUseValue will return the value specified in the section when effectively set in the section
--A modify_flag is maintained for each variable within the section (see UCON_AssignIiSectionRow)
--The argument a_alt_value (read alternative value) will be returned when the variable has
--not been set (affected) in the section

FUNCTION ScIiUseValue       /* INTERNAL */
(a_variable_name IN VARCHAR2,
 a_row           IN INTEGER,
 a_alt_value     IN NUMBER)
RETURN NUMBER IS

BEGIN

   /* FOR FUTURE extensions */
   RETURN(a_alt_value);

END ScIiUseValue;

FUNCTION ScIiUseValue       /* INTERNAL */
(a_variable_name IN VARCHAR2,
 a_row           IN INTEGER,
 a_alt_value     IN VARCHAR2)
RETURN VARCHAR2 IS

BEGIN

   IF a_variable_name = 'iivalue' THEN
      IF UNICONNECT.P_II_IIVALUE_MODTAB(a_row) THEN
         RETURN(UNICONNECT.P_II_IIVALUE_TAB(a_row));
      END IF;
   ELSE
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'      Invalid variable '||a_variable_name||' in ScIiUseValue');
      RAISE StpError;
   END IF;
   RETURN(a_alt_value);

END ScIiUseValue;

--FindScIi returns the utscii record corresponding
--to a specific search syntax
--See FindScIi for examples

FUNCTION FindScIi (a_sc          IN     VARCHAR2,
                   a_ic          IN     VARCHAR2,
                   a_icnode      IN     NUMBER,
                   a_ip_version  IN     VARCHAR2,
                   a_ii          IN OUT VARCHAR2,
                   a_description IN     VARCHAR2,
                   a_iinode      IN     NUMBER,
                   a_ie_version  IN     VARCHAR2,
                   a_search_base IN     VARCHAR2,
                   a_pos         IN INTEGER)
RETURN utscii%ROWTYPE IS

l_ii_rec       utscii%ROWTYPE;
l_leave_loop   BOOLEAN DEFAULT FALSE;
l_counter      INTEGER;

CURSOR l_scii_cursor IS
   SELECT *
   FROM utscii
   WHERE (sc, ic, icnode) IN
         (SELECT sc, ic, icnode
          FROM utscic
          WHERE sc = a_sc
          AND ic = NVL(a_ic, ic)
          AND icnode = NVL(a_icnode,icnode)
          AND NVL(ip_version, '0') = NVL(a_ip_version, NVL(ip_version, '0'))
         )
   AND ii = a_ii
   AND iinode = NVL(a_iinode, iinode)
   AND NVL(ie_version, '0') = NVL(a_ie_version, NVL(ie_version, '0'))
   ORDER BY icnode, iinode;

CURSOR l_sciidesc_cursor IS
   SELECT *
   FROM utscii
   WHERE (sc, ic, icnode) IN
         (SELECT sc, ic, icnode
          FROM utscic
          WHERE sc = a_sc
          AND ic = NVL(a_ic, ic)
          AND icnode = NVL(a_icnode,icnode)
          AND NVL(ip_version, '0') = NVL(a_ip_version, NVL(ip_version, '0'))
         )
   AND dsp_title = a_description
   AND iinode = NVL(a_iinode, iinode)
   AND NVL(ie_version, '0') = NVL(a_ie_version, NVL(ie_version, '0'))
   ORDER BY icnode, iinode;

BEGIN
   l_ii_rec := NULL;

   IF a_search_base = 'ii' THEN

      --find ii in xth position (x=a_pos)
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Searching for ii in position '||TO_CHAR(a_pos)||' for sc='||
                                             a_sc||
                                             '#ic='||a_ic||'#icnode='||NVL(TO_CHAR(a_icnode),'NULL')||
                                             '#ip_version='||a_ip_version||
                                             '#ii='||a_ii||'#iinode='||NVL(TO_CHAR(a_iinode),'NULL')||
                                             '#ie_version='||a_ie_version);
      OPEN l_scii_cursor;
      l_counter := 0;
      LOOP
         FETCH l_scii_cursor
         INTO l_ii_rec;
         EXIT WHEN l_scii_cursor%NOTFOUND;
         --check if ii/iinode combination already used
         l_counter := l_counter + 1;
         IF l_counter >= a_pos THEN
            EXIT;
         ELSE
            l_ii_rec := NULL;
         END IF;
      END LOOP;
      CLOSE l_scii_cursor;

   ELSE

      --find ii in xth position (x=a_pos)
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Searching for ii (description) in position '||TO_CHAR(a_pos)||' for sc='||
                                             a_sc||'#ic='||
                                             a_ic||'#icnode='||NVL(TO_CHAR(a_icnode),'NULL')||
                                             '#description='||a_description||
                                             '#ip_version='||a_ip_version||
                                             '#iinode='||NVL(TO_CHAR(a_iinode),'NULL')||
                                             '#ie_version='||a_ie_version);
      OPEN l_sciidesc_cursor;
      l_counter := 0;
      LOOP
         FETCH l_sciidesc_cursor
         INTO l_ii_rec;
         EXIT WHEN l_sciidesc_cursor%NOTFOUND;
         --check if ii/iinode combination already used
         l_counter := l_counter + 1;
         IF l_counter >= a_pos THEN
            a_ii := l_ii_rec.ii;
            EXIT;
         ELSE
            l_ii_rec := NULL;
         END IF;
      END LOOP;
      CLOSE l_sciidesc_cursor;

   END IF;

   RETURN (l_ii_rec);

END FindScIi;

PROCEDURE UCON_CleanupScIiSection IS
BEGIN
   --Important since these variables should only
   --last for the execution of the [ic] section
   --but have to be implemented as global package variables
   --to keep it mantainable

   UNICONNECT.P_II_SC_TAB.DELETE;
   UNICONNECT.P_II_IC_TAB.DELETE;
   UNICONNECT.P_II_ICNODE_TAB.DELETE;
   UNICONNECT.P_II_II_TAB.DELETE;

   UNICONNECT.P_II_IINAME_TAB.DELETE;
   UNICONNECT.P_II_IIDESCRIPTION_TAB.DELETE;

   UNICONNECT.P_II_IINODE_TAB.DELETE;
   UNICONNECT.P_II_IE_VERSION_TAB.DELETE;
   UNICONNECT.P_II_IIVALUE_TAB.DELETE;
   UNICONNECT.P_II_POS_X_TAB.DELETE;
   UNICONNECT.P_II_POS_Y_TAB.DELETE;
   UNICONNECT.P_II_IS_PROTECTED_TAB.DELETE;
   UNICONNECT.P_II_MANDATORY_TAB.DELETE;
   UNICONNECT.P_II_HIDDEN_TAB.DELETE;
   UNICONNECT.P_II_DSP_TITLE_TAB.DELETE;
   UNICONNECT.P_II_DSP_LEN_TAB.DELETE;
   UNICONNECT.P_II_DSP_TP_TAB.DELETE;
   UNICONNECT.P_II_DSP_ROWS_TAB.DELETE;
   UNICONNECT.P_II_II_CLASS_TAB.DELETE;
   UNICONNECT.P_II_LOG_HS_TAB.DELETE;
   UNICONNECT.P_II_LOG_HS_DETAILS_TAB.DELETE;
   UNICONNECT.P_II_LC_TAB.DELETE;
   UNICONNECT.P_II_LC_VERSION_TAB.DELETE;
   UNICONNECT.P_II_MODIFY_FLAG_TAB.DELETE;
   UNICONNECT.P_II_SS_TAB.DELETE;
   UNICONNECT.P_II_IIVALUE_MODTAB.DELETE;

   UNICONNECT.P_II_SC := NULL;
   UNICONNECT.P_II_IC := NULL;
   UNICONNECT.P_II_ICNAME := NULL;
   UNICONNECT.P_II_ICDESCRIPTION := NULL;
   UNICONNECT.P_II_ICNODE := NULL;
   UNICONNECT.P_II_IP_VERSION := NULL;
   UNICONNECT.P_II_USE_SAVESCIIVALUE := FALSE;

   UNICONNECT.P_II_MODIFY_REASON := NULL;

   UNICONNECT.P_II_NR_OF_ROWS  := 0;
END UCON_CleanupScIiSection;

FUNCTION UCON_ExecuteScIiSection         /* INTERNAL */
RETURN NUMBER IS

l_sc                   VARCHAR2(20);
l_variable_name        VARCHAR2(20);
l_description_pos      INTEGER;
l_openbrackets_pos     INTEGER;
l_closebrackets_pos    INTEGER;
l_ic_pos               INTEGER;
l_ic_rec_found         utscic%ROWTYPE;
l_ie                   VARCHAR2(20);
l_ii_pos               INTEGER;
l_ii_rec_found         utscii%ROWTYPE;
l_any_save             BOOLEAN DEFAULT FALSE;
l_used_api             VARCHAR2(30);
l_find_iirow           INTEGER;
l_iirow                INTEGER;

/* InitScIcDetails : local variables */
l_initii_ip                          VARCHAR2(20);
l_initii_ip_version                  VARCHAR2(20);
l_initii_sc                          VARCHAR2(20);
l_initii_nr_of_rows                  NUMBER;
l_initii_next_rows                   NUMBER;
l_initii_ii_tab                      UNAPIGEN.VC20_TABLE_TYPE;
l_initii_ie_version_tab              UNAPIGEN.VC20_TABLE_TYPE;
l_initii_iivalue_tab                 UNAPIGEN.VC2000_TABLE_TYPE;
l_initii_pos_x_tab                   UNAPIGEN.NUM_TABLE_TYPE;
l_initii_pos_y_tab                   UNAPIGEN.NUM_TABLE_TYPE;
l_initii_is_protected_tab            UNAPIGEN.CHAR1_TABLE_TYPE;
l_initii_mandatory_tab               UNAPIGEN.CHAR1_TABLE_TYPE;
l_initii_hidden_tab                  UNAPIGEN.CHAR1_TABLE_TYPE;
l_initii_dsp_title_tab               UNAPIGEN.VC40_TABLE_TYPE;
l_initii_dsp_len_tab                 UNAPIGEN.NUM_TABLE_TYPE;
l_initii_dsp_tp_tab                  UNAPIGEN.CHAR1_TABLE_TYPE;
l_initii_dsp_rows_tab                UNAPIGEN.NUM_TABLE_TYPE;
l_initii_ii_class_tab                UNAPIGEN.VC2_TABLE_TYPE;
l_initii_log_hs_tab                  UNAPIGEN.CHAR1_TABLE_TYPE;
l_initii_log_hs_details_tab          UNAPIGEN.CHAR1_TABLE_TYPE;
l_initii_lc_tab                      UNAPIGEN.VC2_TABLE_TYPE;
l_initii_lc_version_tab              UNAPIGEN.VC20_TABLE_TYPE;

CURSOR l_iedescription_cursor (a_description IN VARCHAR2,
                               a_ie_version  IN VARCHAR2)
IS
   SELECT ie
   FROM utie
   WHERE dsp_title = a_description
   AND NVL(version, '0') = NVL(a_ie_version, NVL(version, '0'));

   FUNCTION ChangeScIiStatusOrCancel
    (a_sc                IN      VARCHAR2,     /* VC20_TYPE */
     a_ic                IN      VARCHAR2,     /* VC20_TYPE */
     a_icnode            IN      NUMBER,       /* LONG_TYPE */
     a_ii                IN      VARCHAR2,     /* VC20_TYPE */
     a_iinode            IN      NUMBER,       /* LONG_TYPE */
     a_new_ss            IN      VARCHAR2,     /* VC2_TYPE */
     a_modify_reason     IN      VARCHAR2)     /* VC255_TYPE */
   RETURN NUMBER
   IS

   l_ret_code                    INTEGER;
   --Specific local variables for ChangeScIiSs and CancelScIi
   l_old_ss                      VARCHAR2(2);
   l_lc                          VARCHAR2(2);
   l_lc_version                  VARCHAR2(20);

   --Specific local variables for InsertEvent
   l_seq_nr                      NUMBER;
   l_ie_version                  VARCHAR2(20);

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

   --No ChangeStatus or
   --InsertEvent InfoUpdated with ss_to=<new status>
   l_seq_nr := NULL;
   SELECT ie_version, lc, lc_version
   INTO l_ie_version, l_lc, l_lc_version
   FROM utscii
   WHERE sc = a_sc
   AND ic = a_ic
   AND icnode = a_icnode
   AND ii = a_ii
   AND iinode = a_iinode;

   IF l_lc IS NOT NULL THEN
      l_ret_code := UNAPIEV.InsertEvent
                      (a_api_name          => 'ChangeScIiStatusOrCancel',
                       a_evmgr_name        => UNAPIGEN.P_EVMGR_NAME,
                       a_object_tp         => 'ii',
                       a_object_id         => a_ii,
                       a_object_lc         => l_lc,
                       a_object_lc_version => NULL,
                       a_object_ss         => NULL,
                       a_ev_tp             => 'InfoFieldUpdated',
                       a_ev_details        => 'sc='||a_sc||
                                              '#ic='||a_ic||'#icnode='||a_icnode||
                                              '#iinode='||a_iinode||
                                              '#ie_version='||l_ie_version||'#ss_to='||a_new_ss,
                       a_seq_nr            => l_seq_nr);
      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         InsertEvent to change the status of ii failed ret_code='||l_ret_code);
      ELSE
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW  ,'         InsertEvent to change the status of ii is OK');
      END IF;
   ELSE
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_HIGH,'         Info Field status modification can not take place since it has no life cycle');
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_HIGH,'         for sc='||a_sc||
                                              '#ic='||a_ic||'#icnode='||a_icnode||
                                              '#ii='||a_ii||'#iinode='||a_iinode||
                                              '#ie_version='||l_ie_version||'#ss_to='||a_new_ss);
   END IF;
   RETURN(l_ret_code);

   END ChangeScIiStatusOrCancel;

BEGIN

   l_ret_code := UNAPIGEN.DBERR_SUCCESS;
   --1. sc validation
   IF UNICONNECT.P_II_SC IS NULL THEN
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : sample is mandatory for [ii] section !');
      l_ret_code := UNAPIGEN.DBERR_NOPARENTOBJECT;
      RAISE StpError;
   END IF;

   --2. sc modified in [ii] section ?
   --    NO    set global variable SC
   --    YES   verify if provided sample code exist :error when not + set global variable SC
   --    Copy sc in savescii... array
   IF NVL(UNICONNECT.P_GLOB_SC,' ') <> NVL(UNICONNECT.P_II_SC, ' ') THEN
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Sc directly searched:'||UNICONNECT.P_II_SC);
      OPEN l_sc_cursor(UNICONNECT.P_II_SC);
      FETCH l_sc_cursor
      INTO l_sc;
      CLOSE l_sc_cursor;
      IF l_sc IS NULL THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : sc does not exist ! sc is mandatory for [ii] section !');
         l_ret_code := UNAPIGEN.DBERR_NOPARENTOBJECT;
         RAISE StpError;
      END IF;
      UNICONNECT.P_GLOB_SC := UNICONNECT.P_II_SC;
   ELSE
      UNICONNECT.P_GLOB_SC := UNICONNECT.P_II_SC;
   END IF;

   FOR l_row IN 1..UNICONNECT.P_II_NR_OF_ROWS LOOP
      UNICONNECT.P_II_SC_TAB(l_row) := UNICONNECT.P_GLOB_SC;
   END LOOP;

   -- suppressed due to a change request on 16/09/1999 (ic/icnode are nomore mandatory)
   --
   --3. ic=NULL ?
   --   NO OK
   --   YES   Major error : ii section without ic specified in a preceding section
   --IF UNICONNECT.P_II_IC IS NULL AND
   --   UNICONNECT.P_II_ICDESCRIPTION IS NULL THEN
   --   UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : ic is mandatory for [ii] section !');
   --   RETURN(UNAPIGEN.DBERR_NOPARENTOBJECT);
   --END IF;

   --4. ic or icnode modified in [ii] section
   --   NO set global varaibles IC and ICNODE
   --   YES   verify if provided ic exist :error when not + set global variable IC and ICNODE
   --      PAY attention the ic[x] and .description are supported in this case
   --      Also : ic[] is not supported since there are no dates for ic and ii : ii[]=ii[1]
   --   Copy IC and ICNODE in savescii... array
   IF UNICONNECT.P_II_ICNAME IS NOT NULL THEN

      --description used ? -> find pp in utpp
      l_variable_name := NVL(UNICONNECT.P_II_ICNAME, 'ic');
      l_description_pos := INSTR(l_variable_name, '.description');
      l_openbrackets_pos := INSTR(l_variable_name, '[');
      l_closebrackets_pos := INSTR(l_variable_name, ']');
      l_ic_pos := TO_NUMBER(SUBSTR(l_variable_name,l_openbrackets_pos+1,l_closebrackets_pos-l_openbrackets_pos-1));

      UNICONNECT.P_IC_NR_OF_ROWS := 0; --to be sure ic arrays are not searched
      l_ic_rec_found := NULL;

      IF l_openbrackets_pos = 0 THEN
         IF l_description_pos = 0 THEN
            --ic or ic.ic used
            l_ic_rec_found := FindScIc(UNICONNECT.P_GLOB_SC,
                                       UNICONNECT.P_II_IC, UNICONNECT.P_II_ICDESCRIPTION,
                                       UNICONNECT.P_II_ICNODE, UNICONNECT.P_II_IP_VERSION,
                                       'ic', 1);
         ELSE
            --ic.description used
            l_ic_rec_found := FindScIc(UNICONNECT.P_GLOB_SC,
                                       UNICONNECT.P_II_IC, UNICONNECT.P_II_ICDESCRIPTION,
                                       UNICONNECT.P_II_ICNODE, UNICONNECT.P_II_IP_VERSION,
                                       'description', 1);
         END IF;
      ELSE
         IF l_description_pos = 0 THEN
            --ic[x] or ic[x].ic used
            l_ic_rec_found := FindScIc(UNICONNECT.P_GLOB_SC,
                                       UNICONNECT.P_II_IC, UNICONNECT.P_II_ICDESCRIPTION,
                                       UNICONNECT.P_II_ICNODE, UNICONNECT.P_II_IP_VERSION,
                                       'ic', NVL(l_ic_pos,0));
         ELSE
            --ic[x].description used
            l_ic_rec_found := FindScIc(UNICONNECT.P_GLOB_SC,
                                       UNICONNECT.P_II_IC, UNICONNECT.P_II_ICDESCRIPTION,
                                       UNICONNECT.P_II_ICNODE, UNICONNECT.P_II_IP_VERSION,
                                       'description', NVL(l_ic_pos,0));
         END IF;
      END IF;

      IF l_ic_rec_found.icnode IS NOT NULL THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         ic found:ic='||l_ic_rec_found.ic||'#icnode='||l_ic_rec_found.icnode);
         UNICONNECT.P_GLOB_IC := l_ic_rec_found.ic;
         UNICONNECT.P_GLOB_ICNODE := l_ic_rec_found.icnode;
      ELSE
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NORMAL,'         Section skipped : ic not found ! ic is optional for [ii] section !');
         l_ret_code := UNAPIGEN.DBERR_SUCCESS; --section skipped
         RAISE StpError;
      END IF;

   ELSE
      UNICONNECT.P_GLOB_IC := UNICONNECT.P_II_IC;
      UNICONNECT.P_GLOB_ICNODE := UNICONNECT.P_II_ICNODE;
   END IF;

   FOR l_row IN 1..UNICONNECT.P_II_NR_OF_ROWS LOOP
      UNICONNECT.P_II_IC_TAB(l_row) := UNICONNECT.P_GLOB_IC;
      UNICONNECT.P_II_ICNODE_TAB(l_row) := UNICONNECT.P_GLOB_ICNODE;
   END LOOP;

   --5. any ii specified ?
   --   YES   do nothing
   --   NO Major error : ii is mandatory in a [ii] section
   IF UNICONNECT.P_II_NR_OF_ROWS = 0 THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : ii is mandatory for [ii] section !');
         l_ret_code := UNAPIGEN.DBERR_NOOBJID;
         RAISE StpError;
   END IF;

   --6. create_ii ?
   --   Y|INSERT|INSERT_WITH_NODES
   --      ic=NULL ?
   --      YES   Major error : ii must be created but no ic specified (there is no / ic)
   --      NO OK
   --
   --      LOOP through all ii array
   --         ii[] notation will not be ignored
   --         iinode will not be checked (Save api will return an error when not NULL)
   --         ii.description used ?
   --         YES   ii.description => find corresponding ie description in utie and fill in corresponding ii
   --         NO use ii or ii.ii directly
   --         PAY ATTENTION MOD_FLAG_CREATE is not supported by this api
   --         Set modify flag to MOD_FLAG_INSERT|MOD_FLAG_INSERT|MOD_FLAG_INSERT_WITH_NODES
   --         Section setting for iinode is erased when MOD_FLAG_INSERT is used
   --      END LOOP
   --   N|W
   --      LOOP through all ii array
   --         ii[x] syntax used and/or description syntax used ?
   --            YES   find corresponding iinode (find xth ii for this SC,IC,ICNODE and this ii order by IINODE ASC)
   --               ii[] is not supported (=ii[1])
   --               Pay attention : ii can already being used for saving another ii with the same name
   --            NO use the first ii with this name (ORDER BY iinode)
   --         ii not found AND icnode not specified in the section AND ic specified in the [ii] section ?
   --             NO continue
   --             YES no specific position specified for the ic (ic[x] or ic[] syntax not used)
   --                 search back to ii but without specifying a specific icnode
   --                 ii found ?
   --                 NO continue
   --                 YES   set global variables ICNODE
   --                       Copy ICNODE in savescic... array
   --
   --         ii found ?
   --            YES   set modify flag to UNAPIGEN.DBERR_SUCCESS
   --               set the node correctly for correct node numbering
   --               Initialise SaveScIi... array variables with the values coming
   --               from the record or from the section
   --                       (Values from the section will overrule the value from the record)
   --               Initialise ic/icnode in the array also
   --               DON'T SET GLOBALS IC and ICNODE
   --            NO
   --               create_ii ?
   --               N
   --                  Major error
   --               W
   --                  ic=NULL ?
   --                  YES   Major error : ii must be created but no ic specified (there is no / ic)
   --                  NO OK
   --
   --                  Set modify flag to UNAPIGEN.MOD_FLAG_INSERT
   --                  Set node to NULL
   --      END LOOP
   IF UNICONNECT.P_SET_CREATE_II IN ('Y', 'INSERT', 'INSERT_WITH_NODES') THEN

      IF UNICONNECT.P_GLOB_IC IS NULL THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : ii must be created but no ic specified !');
         l_ret_code := UNAPIGEN.DBERR_NOPARENTOBJECT;
         RAISE StpError;

      END IF;

      FOR l_row IN 1..UNICONNECT.P_II_NR_OF_ROWS LOOP

         --description used ? -> find ie in utie
         l_variable_name := UNICONNECT.P_II_IINAME_TAB(l_row);
         l_description_pos := INSTR(l_variable_name, '.description');
         IF l_description_pos > 0 THEN
            OPEN l_iedescription_cursor(UNICONNECT.P_II_IIDESCRIPTION_TAB(l_row),
                                        UNICONNECT.P_II_IE_VERSION_TAB(l_row));
            FETCH l_iedescription_cursor
            INTO l_ie;
            IF l_iedescription_cursor%NOTFOUND THEN
               --Major error no corresponding ie found
               CLOSE l_iedescription_cursor;
               UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : no corresponding ie for description '||UNICONNECT.P_II_IIDESCRIPTION_TAB(l_row));
               l_ret_code := UNAPIGEN.DBERR_NOOBJID;
               RAISE StpError;

            END IF;
            CLOSE l_iedescription_cursor;
            UNICONNECT.P_II_II_TAB(l_row) := l_ie;
         END IF;

         --Set modify flag to MOD_FLAG_INSERT|MOD_FLAG_INSERT|MOD_FLAG_INSERT_WITH_NODES
         --Section setting for iinode is erased when MOD_FLAG_INSERT is used
         UNICONNECT.P_II_USE_SAVESCIIVALUE := FALSE;
         IF UNICONNECT.P_SET_CREATE_II = 'INSERT_WITH_NODES' THEN
            UNICONNECT.P_II_MODIFY_FLAG_TAB(l_row) := UNAPIGEN.MOD_FLAG_INSERT_WITH_NODES;
         ELSE
            UNICONNECT.P_II_MODIFY_FLAG_TAB(l_row) := UNAPIGEN.MOD_FLAG_INSERT;
            UNICONNECT.P_II_IINODE_TAB(l_row) := NULL;
         END IF;


      END LOOP;
   ELSE

      FOR l_row IN 1..UNICONNECT.P_II_NR_OF_ROWS LOOP

         --description used ? -> find ie in utie
         l_variable_name := UNICONNECT.P_II_IINAME_TAB(l_row);
         l_description_pos := INSTR(l_variable_name, '.description');
         l_openbrackets_pos := INSTR(l_variable_name, '[');
         l_closebrackets_pos := INSTR(l_variable_name, ']');
         l_ii_pos := TO_NUMBER(SUBSTR(l_variable_name,l_openbrackets_pos+1,l_closebrackets_pos-l_openbrackets_pos-1));

         l_ii_rec_found := NULL;

         IF l_openbrackets_pos = 0 THEN
            IF l_description_pos = 0 THEN
               --ii or ii.ii used
               l_ii_rec_found := FindScIi(UNICONNECT.P_GLOB_SC,
                                          UNICONNECT.P_GLOB_IC, UNICONNECT.P_GLOB_ICNODE, UNICONNECT.P_II_IP_VERSION,
                                          UNICONNECT.P_II_II_TAB(l_row), UNICONNECT.P_II_IIDESCRIPTION_TAB(l_row),
                                          UNICONNECT.P_II_IINODE_TAB(l_row), UNICONNECT.P_II_IE_VERSION_TAB(l_row),
                                          'ii', 1);
            ELSE
               --ii.description used
               l_ii_rec_found := FindScIi(UNICONNECT.P_GLOB_SC,
                                          UNICONNECT.P_GLOB_IC, UNICONNECT.P_GLOB_ICNODE, UNICONNECT.P_II_IP_VERSION,
                                          UNICONNECT.P_II_II_TAB(l_row), UNICONNECT.P_II_IIDESCRIPTION_TAB(l_row),
                                          UNICONNECT.P_II_IINODE_TAB(l_row), UNICONNECT.P_II_IE_VERSION_TAB(l_row),
                                          'description', 1);
            END IF;
         ELSE
            IF l_description_pos = 0 THEN
               --ii[x] or ii[x].ii used
               l_ii_rec_found := FindScIi(UNICONNECT.P_GLOB_SC,
                                          UNICONNECT.P_GLOB_IC, UNICONNECT.P_GLOB_ICNODE, UNICONNECT.P_II_IP_VERSION,
                                          UNICONNECT.P_II_II_TAB(l_row), UNICONNECT.P_II_IIDESCRIPTION_TAB(l_row),
                                          UNICONNECT.P_II_IINODE_TAB(l_row), UNICONNECT.P_II_IE_VERSION_TAB(l_row),
                                          'ii', NVL(l_ii_pos,0));
            ELSE
               --ii[x].description used
               l_ii_rec_found := FindScIi(UNICONNECT.P_GLOB_SC,
                                          UNICONNECT.P_GLOB_IC, UNICONNECT.P_GLOB_ICNODE, UNICONNECT.P_II_IP_VERSION,
                                          UNICONNECT.P_II_II_TAB(l_row), UNICONNECT.P_II_IIDESCRIPTION_TAB(l_row),
                                          UNICONNECT.P_II_IINODE_TAB(l_row), UNICONNECT.P_II_IE_VERSION_TAB(l_row),
                                          'description', NVL(l_ii_pos,0));
            END IF;
         END IF;

         -- ii not found AND icnode not specified in the section AND ic specified in the [ii] section ?
         --     NO continue
         --     YES no specific position specified for the ic (ic[x] or ic[] syntax not used)
         --         search back to ii but without specifying a specific icnode
         --         ii found ?
         --         NO continue
         --         YES   set global variables ICNODE
         --               Copy ICNODE in savescic... array
         --

         IF l_ii_rec_found.iinode IS NULL AND
            p_ii_icnode_setinsection = FALSE AND
            UNICONNECT.P_II_ICNAME IS NOT NULL AND
            INSTR(UNICONNECT.P_II_ICNAME, '[') = 0 THEN
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         ii not found in current ic, will try to find it in another ic with the same name');
            IF l_openbrackets_pos = 0 THEN
               IF l_description_pos = 0 THEN
                  --ii or ii.ii used
                  l_ii_rec_found := FindScIi(UNICONNECT.P_GLOB_SC, UNICONNECT.P_GLOB_IC, NULL, UNICONNECT.P_II_IP_VERSION,
                                             UNICONNECT.P_II_II_TAB(l_row), UNICONNECT.P_II_IIDESCRIPTION_TAB(l_row),
                                             UNICONNECT.P_II_IINODE_TAB(l_row), UNICONNECT.P_II_IE_VERSION_TAB(l_row),
                                             'ii',        1);
               ELSE
                  --ii.description used
                  l_ii_rec_found := FindScIi(UNICONNECT.P_GLOB_SC, UNICONNECT.P_GLOB_IC, NULL, UNICONNECT.P_II_IP_VERSION,
                                             UNICONNECT.P_II_II_TAB(l_row), UNICONNECT.P_II_IIDESCRIPTION_TAB(l_row),
                                             UNICONNECT.P_II_IINODE_TAB(l_row), UNICONNECT.P_II_IE_VERSION_TAB(l_row),
                                             'description',        1);
               END IF;
            ELSE
               IF l_description_pos = 0 THEN
                  --ii[x] or ii[x].ii used
                  l_ii_rec_found := FindScIi(UNICONNECT.P_GLOB_SC, UNICONNECT.P_GLOB_IC, NULL, UNICONNECT.P_II_IP_VERSION,
                                             UNICONNECT.P_II_II_TAB(l_row), UNICONNECT.P_II_IIDESCRIPTION_TAB(l_row),
                                             UNICONNECT.P_II_IINODE_TAB(l_row), UNICONNECT.P_II_IE_VERSION_TAB(l_row),
                                             'ii', NVL(l_ii_pos,0));
               ELSE
                  --ii[x].description used
                  l_ii_rec_found := FindScIi(UNICONNECT.P_GLOB_SC,  UNICONNECT.P_GLOB_IC, NULL, UNICONNECT.P_II_IP_VERSION,
                                             UNICONNECT.P_II_II_TAB(l_row), UNICONNECT.P_II_IIDESCRIPTION_TAB(l_row),
                                             UNICONNECT.P_II_IINODE_TAB(l_row), UNICONNECT.P_II_IE_VERSION_TAB(l_row),
                                             'description', NVL(l_ii_pos,0));
               END IF;
            END IF;

            IF l_ii_rec_found.iinode IS NOT NULL THEN
               UNICONNECT.P_GLOB_ICNODE := l_ii_rec_found.icnode;
               FOR l_row IN 1..UNICONNECT.P_II_NR_OF_ROWS LOOP
                   UNICONNECT.P_II_ICNODE_TAB(l_row) := UNICONNECT.P_GLOB_ICNODE;
               END LOOP;
            END IF;
         END IF;


         IF l_ii_rec_found.iinode IS NOT NULL THEN
            --ii found
            --initialise SaveScIi.... array with fetched values when not set in section

            --always set
            UNICONNECT.P_II_IC_TAB(l_row)               := l_ii_rec_found.ic;
            UNICONNECT.P_II_ICNODE_TAB(l_row)           := l_ii_rec_found.icnode;
            UNICONNECT.P_II_IINODE_TAB(l_row)           := l_ii_rec_found.iinode;
            UNICONNECT.P_II_IE_VERSION_TAB(l_row)       := l_ii_rec_found.ie_version;
            UNICONNECT.P_II_POS_X_TAB(l_row)            := l_ii_rec_found.pos_x;
            UNICONNECT.P_II_POS_Y_TAB(l_row)            := l_ii_rec_found.pos_y;
            UNICONNECT.P_II_IS_PROTECTED_TAB(l_row)     := l_ii_rec_found.is_protected;
            UNICONNECT.P_II_MANDATORY_TAB(l_row)        := l_ii_rec_found.mandatory;
            UNICONNECT.P_II_HIDDEN_TAB(l_row)           := l_ii_rec_found.hidden;
            UNICONNECT.P_II_DSP_TITLE_TAB(l_row)        := l_ii_rec_found.dsp_title;
            UNICONNECT.P_II_DSP_LEN_TAB(l_row)          := l_ii_rec_found.dsp_len;
            UNICONNECT.P_II_DSP_TP_TAB(l_row)           := l_ii_rec_found.dsp_tp;
            UNICONNECT.P_II_DSP_ROWS_TAB(l_row)         := l_ii_rec_found.dsp_rows;
            UNICONNECT.P_II_II_CLASS_TAB(l_row)         := l_ii_rec_found.ii_class;
            UNICONNECT.P_II_LOG_HS_TAB(l_row)           := l_ii_rec_found.log_hs;
            UNICONNECT.P_II_LOG_HS_DETAILS_TAB(l_row)   := l_ii_rec_found.log_hs_details;
            UNICONNECT.P_II_LC_TAB(l_row)               := l_ii_rec_found.lc;
            UNICONNECT.P_II_LC_VERSION_TAB(l_row)       := l_ii_rec_found.lc_version;

            --only when not set in section
            UNICONNECT.P_II_IIVALUE_TAB(l_row)          := ScIiUseValue('iivalue'         , l_row, l_ii_rec_found.iivalue);

         ELSE
            /* create_ii=N ? */
            IF UNICONNECT.P_SET_CREATE_II = 'N' THEN

               UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NORMAL,'         Warning : section skipped : ii does not exist and can not be created');
               l_ret_code := UNAPIGEN.DBERR_SUCCESS; --section skipped
               RAISE StpError;

            ELSE

               IF UNICONNECT.P_GLOB_IC IS NULL THEN
                  UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : ii must be created but no ic specified !');
                  l_ret_code := UNAPIGEN.DBERR_NOPARENTOBJECT;
                  RAISE StpError;
               END IF;

               --find the ie corresponding to the provided description
               --in utie when description used to specify the ie
               IF l_description_pos > 0 THEN
                  OPEN l_iedescription_cursor(UNICONNECT.P_II_IIDESCRIPTION_TAB(l_row),
                                              UNICONNECT.P_II_IE_VERSION_TAB(l_row));
                  FETCH l_iedescription_cursor
                  INTO l_ie;
                  IF l_iedescription_cursor%NOTFOUND THEN
                     --Major error no corresponding ie found
                     CLOSE l_iedescription_cursor;
                     UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : no corresponding ie for description '||UNICONNECT.P_II_IIDESCRIPTION_TAB(l_row));
                     l_ret_code := UNAPIGEN.DBERR_NOOBJID;
                     RAISE StpError;
                  END IF;
                  CLOSE l_iedescription_cursor;
                  UNICONNECT.P_II_II_TAB(l_row) := l_ie;
               END IF;

               --Set Modify flag to MOD_FLAG_INSERT
               UNICONNECT.P_II_MODIFY_FLAG_TAB(l_row) := UNAPIGEN.MOD_FLAG_INSERT;
               UNICONNECT.P_II_IINODE_TAB(l_row) := NULL;
               UNICONNECT.P_II_USE_SAVESCIIVALUE := FALSE;


            END IF;

         END IF;

      END LOOP;

   END IF;

   --7. Any ii to create ?
   --   YES
   --   LOOP through all ii array
   --      Call InitScIcDetails for all ii which have to be created
   --      Initialise SaveScInfoField array variables with the values coming
   --      from the InitScIcDetails or from the section
   --              (Values from the section will overrule the value from the InitScIcDetails)
   --   END LOOP
   --   Call SaveScInfoField or SaveScIiValue (OPTIMALISATION)
   l_any_save := FALSE;
   FOR l_row IN 1..UNICONNECT.P_II_NR_OF_ROWS LOOP

      IF UNICONNECT.P_II_MODIFY_FLAG_TAB(l_row) IN (UNAPIGEN.MOD_FLAG_CREATE,
                                                    UNAPIGEN.MOD_FLAG_INSERT,
                                                    UNAPIGEN.MOD_FLAG_INSERT_WITH_NODES)
                                                 THEN

         l_any_save := TRUE;
         l_initii_sc := UNICONNECT.P_GLOB_SC;
         l_initii_ip := UNICONNECT.P_GLOB_IC;
         BEGIN
            SELECT ip_version
            INTO l_initii_ip_version
            FROM utscic
            WHERE sc = l_initii_sc
            AND ic = l_initii_ip
            AND icnode = UNICONNECT.P_GLOB_ICNODE;
         EXCEPTION
         WHEN NO_DATA_FOUND THEN
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : info card not found for sc='||l_initii_sc ||
                                           '#ic='||l_initii_ip||'#icnode='||UNICONNECT.P_GLOB_ICNODE);
            RAISE StpError;
         END;

         l_initii_ip_version := NULL;
         l_initii_nr_of_rows := NULL;
         l_initii_next_rows := 0;

         l_ret_code := UNAPIIC.INITSCICDETAILS
                         (l_initii_ip,
                          l_initii_ip_version,
                          l_initii_sc,
                          l_initii_ii_tab,
                          l_initii_ie_version_tab,
                          l_initii_iivalue_tab,
                          l_initii_pos_x_tab,
                          l_initii_pos_y_tab,
                          l_initii_is_protected_tab,
                          l_initii_mandatory_tab,
                          l_initii_hidden_tab,
                          l_initii_dsp_title_tab,
                          l_initii_dsp_len_tab,
                          l_initii_dsp_tp_tab,
                          l_initii_dsp_rows_tab,
                          l_initii_ii_class_tab,
                          l_initii_log_hs_tab,
                          l_initii_log_hs_details_tab,
                          l_initii_lc_tab,
                          l_initii_lc_version_tab,
                          l_initii_nr_of_rows,
                          l_initii_next_rows);

         IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : INITSCICDETAILS ret_code : '||l_ret_code ||
                                           '#ip='||l_initii_ip||'#ip_version='||l_initii_ip_version);
            RAISE StpError;
         ELSE

            --find info field in returned array
            l_find_iirow := 0;

            FOR l_iirow IN 1..l_initii_nr_of_rows LOOP
               IF l_initii_ii_tab(l_iirow) = UNICONNECT.P_II_II_TAB(l_row) THEN
                  l_find_iirow := l_iirow;
               END IF;
            END LOOP;

            --perform a last call to close the open cursor in InitScIcDetails with next_rows=-1
            l_initii_next_rows := 0;

            l_ret_code := UNAPIIC.INITSCICDETAILS
                            (l_initii_ip,
                             l_initii_ip_version,
                             l_initii_sc,
                             l_initii_ii_tab,
                             l_initii_ie_version_tab,
                             l_initii_iivalue_tab,
                             l_initii_pos_x_tab,
                             l_initii_pos_y_tab,
                             l_initii_is_protected_tab,
                             l_initii_mandatory_tab,
                             l_initii_hidden_tab,
                             l_initii_dsp_title_tab,
                             l_initii_dsp_len_tab,
                             l_initii_dsp_tp_tab,
                             l_initii_dsp_rows_tab,
                             l_initii_ii_class_tab,
                             l_initii_log_hs_tab,
                             l_initii_log_hs_details_tab,
                             l_initii_lc_tab,
                             l_initii_lc_version_tab,
                             l_initii_nr_of_rows,
                             l_initii_next_rows);

            IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
               UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : INITSCICDETAILS ret_code : '||l_ret_code ||
                                              '#ip='||l_initii_ip||'#ip_version='||l_initii_ip_version||' with a_next_rows=-1');
               RAISE StpError;

            END IF;

            --major error when ie not in ip
            IF l_find_iirow =0 THEN
               UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : info field '|| UNICONNECT.P_II_II_TAB(l_row) ||
                                              ' not returned by INITSCICDETAILS for ic='||l_initii_ip ||' (ie not in utipie ?)');
               l_ret_code := UNAPIGEN.DBERR_NOOBJECT;
               RAISE StpError;
            END IF;

            --always use INITSCICDETAILS values
            UNICONNECT.P_II_IE_VERSION_TAB(l_row)       := l_initii_ie_version_tab(l_find_iirow);
            UNICONNECT.P_II_POS_X_TAB(l_row)            := l_initii_pos_x_tab(l_find_iirow);
            UNICONNECT.P_II_POS_Y_TAB(l_row)            := l_initii_pos_y_tab(l_find_iirow);
            UNICONNECT.P_II_IS_PROTECTED_TAB(l_row)     := l_initii_is_protected_tab(l_find_iirow);
            UNICONNECT.P_II_MANDATORY_TAB(l_row)        := l_initii_mandatory_tab(l_find_iirow);
            UNICONNECT.P_II_HIDDEN_TAB(l_row)           := l_initii_hidden_tab(l_find_iirow);
            UNICONNECT.P_II_DSP_TITLE_TAB(l_row)        := l_initii_dsp_title_tab(l_find_iirow);
            UNICONNECT.P_II_DSP_LEN_TAB(l_row)          := l_initii_dsp_len_tab(l_find_iirow);
            UNICONNECT.P_II_DSP_TP_TAB(l_row)           := l_initii_dsp_tp_tab(l_find_iirow);
            UNICONNECT.P_II_DSP_ROWS_TAB(l_row)         := l_initii_dsp_rows_tab(l_find_iirow);
            UNICONNECT.P_II_II_CLASS_TAB(l_row)         := l_initii_ii_class_tab(l_find_iirow);
            UNICONNECT.P_II_LOG_HS_TAB(l_row)           := l_initii_log_hs_tab(l_find_iirow);
            UNICONNECT.P_II_LOG_HS_DETAILS_TAB(l_row)   := l_initii_log_hs_details_tab(l_find_iirow);
            UNICONNECT.P_II_LC_TAB(l_row)               := l_initii_lc_tab(l_find_iirow);
            UNICONNECT.P_II_LC_VERSION_TAB(l_row)       := l_initii_lc_version_tab(l_find_iirow);

            --only when not set in section
            UNICONNECT.P_II_IIVALUE_TAB(l_row)          := ScIiUseValue('iivalue'         , l_row, l_initii_iivalue_tab(l_find_iirow));

         END IF;

      ELSIF UNICONNECT.P_II_MODIFY_FLAG_TAB(l_row) IN (UNAPIGEN.MOD_FLAG_UPDATE,
                                                    UNAPIGEN.MOD_FLAG_DELETE) THEN
         l_any_save := TRUE;
      END IF;
   END LOOP;

   IF l_any_save THEN
      IF UNICONNECT.P_II_USE_SAVESCIIVALUE THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Calling SaveScIiValue for :');
         l_used_api := 'SaveScIiValue';
      ELSE
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'         Calling SaveScInfoField for :');
         l_used_api := 'SaveScInfoField';
      END IF;

      FOR l_row IN 1..UNICONNECT.P_II_NR_OF_ROWS LOOP
          UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'            row='||l_row||
                                         '#mod_flag='||UNICONNECT.P_II_MODIFY_FLAG_TAB(l_row) ||
                                         '#sc='||UNICONNECT.P_II_SC_TAB(l_row)||'#ic='||UNICONNECT.P_II_IC_TAB(l_row)||
                                         '#icnode='||NVL(TO_CHAR(UNICONNECT.P_II_ICNODE_TAB(l_row)),'NULL')||
                                         '#ii='||UNICONNECT.P_II_II_TAB(l_row)||
                                         '#iinode='||NVL(TO_CHAR(UNICONNECT.P_II_IINODE_TAB(l_row)),'NULL'));
      END LOOP;

      IF UNICONNECT.P_II_USE_SAVESCIIVALUE THEN
         l_ret_code := UNAPIIC.SAVESCIIVALUE
                       (UNICONNECT.P_II_SC_TAB,
                        UNICONNECT.P_II_IC_TAB,
                        UNICONNECT.P_II_ICNODE_TAB,
                        UNICONNECT.P_II_II_TAB,
                        UNICONNECT.P_II_IINODE_TAB,
                        UNICONNECT.P_II_IIVALUE_TAB,
                        UNICONNECT.P_II_MODIFY_FLAG_TAB,
                        UNICONNECT.P_II_NR_OF_ROWS,
                        UNICONNECT.P_II_MODIFY_REASON);

      ELSE
         l_ret_code := UNAPIIC.SAVESCINFOFIELD
                       (UNICONNECT.P_II_SC_TAB,
                        UNICONNECT.P_II_IC_TAB,
                        UNICONNECT.P_II_ICNODE_TAB,
                        UNICONNECT.P_II_II_TAB,
                        UNICONNECT.P_II_IINODE_TAB,
                        UNICONNECT.P_II_IE_VERSION_TAB,
                        UNICONNECT.P_II_IIVALUE_TAB,
                        UNICONNECT.P_II_POS_X_TAB,
                        UNICONNECT.P_II_POS_Y_TAB,
                        UNICONNECT.P_II_IS_PROTECTED_TAB,
                        UNICONNECT.P_II_MANDATORY_TAB,
                        UNICONNECT.P_II_HIDDEN_TAB,
                        UNICONNECT.P_II_DSP_TITLE_TAB,
                        UNICONNECT.P_II_DSP_LEN_TAB,
                        UNICONNECT.P_II_DSP_TP_TAB,
                        UNICONNECT.P_II_DSP_ROWS_TAB,
                        UNICONNECT.P_II_II_CLASS_TAB,
                        UNICONNECT.P_II_LOG_HS_TAB,
                        UNICONNECT.P_II_LOG_HS_DETAILS_TAB,
                        UNICONNECT.P_II_LC_TAB,
                        UNICONNECT.P_II_LC_VERSION_TAB,
                        UNICONNECT.P_II_MODIFY_FLAG_TAB,
                        UNICONNECT.P_II_NR_OF_ROWS,
                        UNICONNECT.P_II_MODIFY_REASON);
      END IF;

      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : ' || l_used_api || ' ret_code='||l_ret_code ||
                                        '#sc(1)='||UNICONNECT.P_II_SC_TAB(1)||'#ic(1)='||UNICONNECT.P_II_IC_TAB(1)||
                                        '#icnode(1)='||NVL(TO_CHAR(UNICONNECT.P_II_ICNODE_TAB(1)),'NULL')||
                                        '#ii(1)='||UNICONNECT.P_II_II_TAB(1)||
                                        '#iinode(1)='||NVL(TO_CHAR(UNICONNECT.P_II_IINODE_TAB(1)),'NULL')||
                                        '#mod_flag(1)='||UNICONNECT.P_II_MODIFY_FLAG_TAB(1));
         IF l_ret_code = UNAPIGEN.DBERR_PARTIALSAVE AND UNICONNECT.P_II_NR_OF_ROWS > 1 THEN
            FOR l_row IN 1..UNICONNECT.P_II_NR_OF_ROWS LOOP
               IF UNICONNECT.P_II_MODIFY_FLAG_TAB(l_row) > UNAPIGEN.DBERR_SUCCESS THEN
                  UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         ' || l_used_api || ' authorisation problem row='||l_row||
                                                 '#mod_flag='||UNICONNECT.P_II_MODIFY_FLAG_TAB(l_row) ||
                                                 '#sc='||UNICONNECT.P_II_SC_TAB(l_row)||'#ic='||UNICONNECT.P_II_IC_TAB(l_row)||
                                                 '#icnode='||NVL(TO_CHAR(UNICONNECT.P_II_ICNODE_TAB(l_row)),'NULL')||
                                                 '#ii='||UNICONNECT.P_II_II_TAB(l_row)||
                                                 '#iinode='||NVL(TO_CHAR(UNICONNECT.P_II_IINODE_TAB(l_row)),'NULL'));
               END IF;
            END LOOP;
         END IF;
         RAISE StpError;

      END IF;
   ELSE
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NORMAL,'         No save(s) in [ii] section');
   END IF;

   --Perform a ChangeStatus or a Cancel when required
   FOR l_row IN 1..UNICONNECT.P_II_NR_OF_ROWS LOOP
      IF UNICONNECT.P_II_SS_TAB(l_row) IS NOT NULL THEN
         l_ret_code := ChangeScIiStatusOrCancel(UNICONNECT.P_II_SC_TAB(l_row),
                                                UNICONNECT.P_II_IC_TAB(l_row),
                                                UNICONNECT.P_II_ICNODE_TAB(l_row),
                                                UNICONNECT.P_II_II_TAB(l_row),
                                                UNICONNECT.P_II_IINODE_TAB(l_row),
                                                UNICONNECT.P_II_SS_TAB(l_row),
                                                UNICONNECT.P_II_MODIFY_REASON);
         IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Major error : ChangeScIiStatusOrCancel ret_code='||l_ret_code ||
                                      '#sc='||UNICONNECT.P_II_SC_TAB(l_row)||
                                      '#ic='||UNICONNECT.P_II_IC_TAB(l_row)||
                                      '#icnode='||NVL(TO_CHAR(UNICONNECT.P_II_ICNODE_TAB(l_row)),'NULL')||
                                      '#ii='||UNICONNECT.P_II_II_TAB(l_row)||
                                      '#iinode='||NVL(TO_CHAR(UNICONNECT.P_II_IINODE_TAB(l_row)),'NULL')
                                      );
            IF UNAPIAUT.P_NOT_AUTHORISED IS NOT NULL THEN
               UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         ' || UNAPIAUT.P_NOT_AUTHORISED );
            END IF;
            RAISE StpError;
         END IF;
      END IF;
   END LOOP;

   --Initialise II and IINODE global variables with the last ii in array
   IF UNICONNECT.P_II_NR_OF_ROWS > 0 THEN
      UNICONNECT.P_GLOB_II := UNICONNECT.P_II_II_TAB(UNICONNECT.P_II_NR_OF_ROWS);
      UNICONNECT.P_GLOB_IINODE := UNICONNECT.P_II_IINODE_TAB(UNICONNECT.P_II_NR_OF_ROWS);

      UNICONNECT2.WriteGlobalVariablesToLog;
   ELSE
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NORMAL,'         Warning ! current ii and iinode not set before leaving [ii] section !');
   END IF;
   UCON_CleanupScIiSection;

   RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
WHEN OTHERS THEN
   --an exception can have been raised with l_ret_code = UNAPIGEN.DBERR_SUCCESS
   --this is done to skip the section without interrupting the file parsing
   IF sqlcode <> 1 THEN
      --the exception is not a user exception
      l_sqlerrm := SUBSTR(SQLERRM, 1, 200);
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         Following exception catched in UCON_ExecuteScIiSection :');
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'         '||l_sqlerrm);
      l_ret_code := UNAPIGEN.DBERR_GENFAIL;
   END IF;
   UCON_CleanupScIiSection;
   UNAPIGEN.P_TXN_ERROR := l_ret_code;
   RETURN(l_ret_code);
END UCON_ExecuteScIiSection;

END uniconnect4;
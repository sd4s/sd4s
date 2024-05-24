create or replace PACKAGE BODY
-- SIMATIC IT UNILAB package
-- $Revision: 6.4.0 (V06.04.00.00_24.01) $
-- $Date: 2009-04-20T16:24:00 $
uniconnect AS

--
-- Private functions
-- 1. UCON_ExecuteSection
-- 2. UCON_InitialiseSection
-- 3. UCON_AssignRow
-- 4. UCON_ParseAndExecuteRow
-- 5. UCON_ParseAndExecuteRows
--

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

--package variable used only for dumping the full section in case of problem
--this array is not used for parsing but only for generating debug messages
P_SECTION_NR_OF_ROWS    INTEGER;
P_SECTION_TEXT          UNAPIGEN.VC2000_TABLE_TYPE;
P_SECTION_DUMPED        BOOLEAN DEFAULT FALSE;

P_DB_CHARACTERSET       VARCHAR2(40);
/* UCON Auxiliary functions */
/* UCON_ExecuteSection */

FUNCTION UCON_ExecuteSection               /* INTERNAL */
RETURN NUMBER IS

l_tx_started_internally BOOLEAN;

   PROCEDURE StartTransactionWhenNecessary
   IS
   l_sub_ret_code        NUMBER;
   BEGIN
      IF UNAPIGEN.P_TXN_LEVEL=0 THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'      Starting a transaction for section '||P_SECTION);
         l_sub_ret_code := UNAPIGEN.BeginTransaction;
         IF l_sub_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'        Start of transaction for section '||P_SECTION||' failed:'||l_sub_ret_code);
         ELSE
            l_tx_started_internally := TRUE;
         END IF;
      END IF;
   END StartTransactionWhenNecessary;

   PROCEDURE StopTransactionWhenNecessary
   IS
   l_sub_ret_code        NUMBER;
   BEGIN
      IF l_tx_started_internally THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'      Finishing the transaction for section '||P_SECTION);
         l_sub_ret_code := UNICONNECT.FinishTransaction;
         IF l_sub_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'        Finishing the transaction for section '||P_SECTION||' failed:'||l_sub_ret_code);
         ELSE
            l_tx_started_internally := FALSE;
         END IF;

      END IF;
   END StopTransactionWhenNecessary;

BEGIN

   l_tx_started_internally := FALSE;
   IF P_SECTION IS NOT NULL THEN
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'      Executing section '||P_SECTION);
   END IF;

   IF P_ROWS_IN_SECTION = 0 AND P_SECTION IS NOT NULL THEN
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NORMAL,'      Warning ! Empty section '||P_SECTION||' nothing executed (GLOBAL SECTION SETTINGS RESET)');
      UNICONNECT2.WriteGlobalVariablesToLog;
   ELSE
      l_ret_code := UNAPIGEN.DBERR_SUCCESS;
      IF P_SECTION = '[sc]' THEN
         StartTransactionWhenNecessary;
         l_ret_code := UNICONNECT2.UCON_ExecuteScSection;
         StopTransactionWhenNecessary;
      ELSIF P_SECTION = '[pg]' THEN
         StartTransactionWhenNecessary;
         l_ret_code := UNICONNECT2.UCON_ExecutePgSection;
         StopTransactionWhenNecessary;
      ELSIF P_SECTION = '[pa]' THEN
         StartTransactionWhenNecessary;
         l_ret_code := UNICONNECT2.UCON_ExecutePaSection;
         StopTransactionWhenNecessary;
      ELSIF P_SECTION = '[me]' THEN
         StartTransactionWhenNecessary;
         l_ret_code := UNICONNECT3.UCON_ExecuteMeSection;
         StopTransactionWhenNecessary;
      ELSIF P_SECTION = '[cell]' THEN
         StartTransactionWhenNecessary;
         l_ret_code := UNICONNECT3.UCON_ExecuteMeCellSection;
         StopTransactionWhenNecessary;
      ELSIF P_SECTION = '[cell table]' THEN
         StartTransactionWhenNecessary;
         l_ret_code := UNICONNECT3.UCON_ExecuteMeCeTabSection;
         StopTransactionWhenNecessary;
      ELSIF P_SECTION = '[ic]' THEN
         StartTransactionWhenNecessary;
         l_ret_code := UNICONNECT4.UCON_ExecuteScIcSection;
         StopTransactionWhenNecessary;
      ELSIF P_SECTION = '[ii]' THEN
         StartTransactionWhenNecessary;
         l_ret_code := UNICONNECT4.UCON_ExecuteScIiSection;
         StopTransactionWhenNecessary;
      ELSIF P_SECTION = '[switchuser]' THEN
         --no transaction here
         l_ret_code := UNICONNECT7.UCON_ExecuteSwitchUsSection;
      ELSIF P_SECTION = '[resetglobals]' THEN
         --no transaction here
         l_ret_code := UNICONNECT7.UCON_ExecuteResetGlobSection;
      END IF;
   END IF;

   --a section is only executed when P_SECTION is not NULL
   --reset the section variable to avoid any accidental
   --executions
   --Exception to this rule: These values may not be modified
   --when a deadlock is detected to be able to reexecute
   --the section that raised a deadlock
   IF l_ret_code <> UNAPIGEN.DBERR_DEADLOCKDETECTED THEN
      P_SECTION := NULL;
      P_ROWS_IN_SECTION := 0;
   END IF;

   -- partial save / partial chart save : continue processing the next section
   IF l_ret_code IN (UNAPIGEN.DBERR_PARTIALSAVE, UNAPIGEN.DBERR_PARTIALCHARTSAVE) THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   ELSIF l_ret_code  = UNAPIGEN.DBERR_DEADLOCKDETECTED THEN
      --deadlock error must be returned to be handled correctly by ParseAndExecuteRows
      RETURN(l_ret_code);
   ELSE
      IF UNICONNECT.P_ON_DBAPI_ERROR_CONTINUE THEN
         --execution errors are strictly ignored
         --reset the transaction error flag when not yet done
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_SUCCESS;
         RETURN(UNAPIGEN.DBERR_SUCCESS);
      ELSE
         RETURN(l_ret_code);
      END IF;
   END IF;

END UCON_ExecuteSection;

/* UCON_InitialiseSection */
FUNCTION UCON_InitialiseSection               /* INTERNAL */
(a_section   IN     VARCHAR2)
RETURN NUMBER IS
BEGIN

   /* Initialise all local and global variables in function of the section */
   UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'      Initialising section '||a_section);
   P_ROWS_IN_SECTION := 0;
   P_SECTION_DUMPED := FALSE;
   P_SECTION_NR_OF_ROWS := 1;
   P_SECTION_TEXT(P_SECTION_NR_OF_ROWS) := a_section;

   IF a_section = '[sc]' THEN

      P_SECTION := '[sc]';
      UNICONNECT2.UCON_InitialiseScSection;

   ELSIF a_section = '[pg]' THEN

      P_SECTION := '[pg]';
      UNICONNECT2.UCON_InitialisePgSection;

   ELSIF a_section = '[pa]' THEN

      P_SECTION := '[pa]';
      UNICONNECT2.UCON_InitialisePaSection;

   ELSIF a_section = '[me]' THEN

      P_SECTION := '[me]';
      UNICONNECT3.UCON_InitialiseMeSection;

   ELSIF a_section = '[cell]' THEN

      P_SECTION := '[cell]';
      UNICONNECT3.UCON_InitialiseMeCellSection;

   ELSIF a_section = '[cell table]' THEN

      P_SECTION := '[cell table]';
      UNICONNECT3.UCON_InitialiseMeCeTabSection;

   ELSIF a_section = '[ic]' THEN

      P_SECTION := '[ic]';
      UNICONNECT4.UCON_InitialiseScIcSection;

   ELSIF a_section = '[ii]' THEN

      P_SECTION := '[ii]';
      UNICONNECT4.UCON_InitialiseScIiSection;

   ELSIF a_section = '[switchuser]' THEN

      P_SECTION := '[switchuser]';
      UNICONNECT7.UCON_InitialiseSwitchUsSection;

   ELSIF a_section = '[resetglobals]' THEN

      P_SECTION := '[resetglobals]';
      P_ROWS_IN_SECTION := 1; --to avoid warning
      --do nothing

   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

END UCON_InitialiseSection;

FUNCTION UCON_AssignRow
(a_equal_pos      IN    NUMBER)
RETURN NUMBER IS

l_before_equal    VARCHAR2(20);
l_after_equal     VARCHAR2(2000);

BEGIN

   --global settings
   IF a_equal_pos > 0 THEN
      P_ROWS_IN_SECTION := P_ROWS_IN_SECTION + 1;
      l_before_equal := RTRIM(SUBSTR(P_CUR_TEXT_LINE,1,a_equal_pos-1));
      l_after_equal  := RTRIM(LTRIM(SUBSTR(P_CUR_TEXT_LINE,a_equal_pos+1)));

      IF l_before_equal IN ('create_sc', 'create_pg', 'create_pa', 'create_me',
                            'create_ic', 'create_ii', 'create_medetails', 'allow_reanalysis') THEN

         IF l_after_equal NOT IN ('Y', 'N', 'W', 'INSERT', 'INSERT_WITH_NODES') THEN
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_HIGH,'      Invalid value for create global setting:'||l_after_equal);
            RETURN(UNAPIGEN.DBERR_CREATESETTING);
         END IF;
         IF l_before_equal = 'create_sc' THEN
            IF l_after_equal NOT IN ('Y', 'N', 'W') THEN
               UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_HIGH,'      Invalid value for create global setting:'||l_after_equal);
               RETURN(UNAPIGEN.DBERR_CREATESETTING);
            END IF;
         END IF;
         IF l_before_equal = 'allow_reanalysis' THEN
            IF l_after_equal NOT IN ('Y', 'N') THEN
               UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_HIGH,'      Invalid value for create global setting:'||l_after_equal);
               RETURN(UNAPIGEN.DBERR_CREATESETTING);
            END IF;
         END IF;

         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NONE,'      Global setting:'||l_before_equal||'='||l_after_equal);

         IF l_before_equal = 'create_sc' THEN
            P_SET_CREATE_SC := l_after_equal;
            RETURN(UNAPIGEN.DBERR_SUCCESS);
         ELSIF l_before_equal = 'create_pg' THEN
            P_SET_CREATE_PG := l_after_equal;
            RETURN(UNAPIGEN.DBERR_SUCCESS);
         ELSIF l_before_equal = 'create_pa' THEN
            P_SET_CREATE_PA := l_after_equal;
            RETURN(UNAPIGEN.DBERR_SUCCESS);
         ELSIF l_before_equal = 'create_me' THEN
            P_SET_CREATE_ME := l_after_equal;
            RETURN(UNAPIGEN.DBERR_SUCCESS);
         ELSIF l_before_equal = 'create_ic' THEN
            P_SET_CREATE_IC := l_after_equal;
            RETURN(UNAPIGEN.DBERR_SUCCESS);
         ELSIF l_before_equal = 'create_ii' THEN
            P_SET_CREATE_II := l_after_equal;
            RETURN(UNAPIGEN.DBERR_SUCCESS);
         ELSIF l_before_equal = 'create_me_details' THEN
            P_SET_CREATE_ME_DETAILS := l_after_equal;
            RETURN(UNAPIGEN.DBERR_SUCCESS);
         ELSIF l_before_equal = 'allow_reanalysis' THEN
            P_SET_ALLOW_REANALYSIS := l_after_equal;
            RETURN(UNAPIGEN.DBERR_SUCCESS);
         END IF;
      END IF;
   END IF;

   --local section variable
   IF NOT P_CONTINUATION_USED THEN

      --extract the variable name
      P_VARIABLE_NAME := RTRIM(SUBSTR(P_CUR_TEXT_LINE, 1, a_equal_pos-1));

      --extract the value
      IF SUBSTR(P_CUR_TEXT_LINE, -2) = ' _' THEN
         --variable value continued on next line
         P_CONTINUATION_USED := TRUE;
         P_VARIABLE_VALUE := SUBSTR(P_CUR_TEXT_LINE, a_equal_pos+1, LENGTH(P_CUR_TEXT_LINE)-a_equal_pos-1);
      ELSE
         --normal case
         P_CONTINUATION_USED := FALSE;
         P_VARIABLE_VALUE := SUBSTR(P_CUR_TEXT_LINE, a_equal_pos+1);
      END IF;
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NONE,'      variable name='||P_VARIABLE_NAME||'#variable value='||P_VARIABLE_VALUE);

   ELSE
      --extract the value
      IF SUBSTR(P_CUR_TEXT_LINE, -2) = ' _' THEN
         --variable value continued on next line
         P_CONTINUATION_USED := TRUE;
         P_VARIABLE_VALUE := P_VARIABLE_VALUE || SUBSTR(P_CUR_TEXT_LINE, 1, LENGTH(P_CUR_TEXT_LINE)-1);
      ELSE
         --normal case
         P_CONTINUATION_USED := FALSE;
         P_VARIABLE_VALUE := P_VARIABLE_VALUE || P_CUR_TEXT_LINE;
      END IF;
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NONE,'      Continuation used: variable name='||P_VARIABLE_NAME||'#variable value='||P_VARIABLE_VALUE);
   END IF;

   --affect the value to the corresponding local section variables
   --the value is only assigned when concatenated
   IF NOT P_CONTINUATION_USED THEN
      --[sc] section variables : sc, st, ref_date, user_id, comment, ss
      IF P_SECTION = '[sc]' THEN
         l_ret_code := UNICONNECT2.UCON_AssignScSectionRow;
         IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
            RETURN(l_ret_code);
         END IF;
      ELSIF P_SECTION = '[pg]' THEN
         l_ret_code := UNICONNECT2.UCON_AssignPgSectionRow;
         IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
            RETURN(l_ret_code);
         END IF;
      ELSIF P_SECTION = '[pa]' THEN
         l_ret_code := UNICONNECT2.UCON_AssignPaSectionRow;
         IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
            RETURN(l_ret_code);
         END IF;
      ELSIF P_SECTION = '[me]' THEN
         l_ret_code := UNICONNECT3.UCON_AssignMeSectionRow;
         IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
            RETURN(l_ret_code);
         END IF;
      ELSIF P_SECTION = '[cell]' THEN
         l_ret_code := UNICONNECT3.UCON_AssignMeCellSectionRow;
         IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
            RETURN(l_ret_code);
         END IF;
      ELSIF P_SECTION = '[cell table]' THEN
         l_ret_code := UNICONNECT3.UCON_AssignMeCeTabSectionRow;
         IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
            RETURN(l_ret_code);
         END IF;
      ELSIF P_SECTION = '[ic]' THEN
         l_ret_code := UNICONNECT4.UCON_AssignScIcSectionRow;
         IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
            RETURN(l_ret_code);
         END IF;
      ELSIF P_SECTION = '[ii]' THEN
         l_ret_code := UNICONNECT4.UCON_AssignScIiSectionRow;
         IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
            RETURN(l_ret_code);
         END IF;
      ELSIF P_SECTION = '[switchuser]' THEN
         l_ret_code := UNICONNECT7.UCON_AssignSwitchUsSectionRow;
         IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
            RETURN(l_ret_code);
         END IF;
      ELSIF P_SECTION = '[resetglobals]' THEN
         --ignore all assign
         NULL;
      END IF;
   END IF;
   RETURN(UNAPIGEN.DBERR_SUCCESS);

END UCON_AssignRow;

/* UCON_ParseAndExecuteRow */
FUNCTION UCON_ParseAndExecuteRow             /* INTERNAL */
(a_is_the_last_line       IN  BOOLEAN)
RETURN NUMBER IS

l_event_tp         utev.ev_tp%TYPE;
l_ev_seq_nr        NUMBER;
l_ev_details       VARCHAR2(255);
l_first_char       CHAR(1);
l_equal_pos        INTEGER;

   PROCEDURE AddRowInDumpArray IS
   BEGIN
      /* fill in array used to dump section in case of problem : cfr UCONDumpCurrentSection */
      P_SECTION_NR_OF_ROWS := NVL(P_SECTION_NR_OF_ROWS,0) + 1;
      P_SECTION_TEXT(P_SECTION_NR_OF_ROWS) := P_CUR_TEXT_LINE;
   END;

   FUNCTION SpecialReturn
   (a_return_code         IN NUMBER)
   RETURN NUMBER IS
   BEGIN
      IF a_return_code <> UNAPIGEN.DBERR_DEADLOCKDETECTED THEN
         IF P_ON_PARSE_ERROR_CONTINUE THEN
            --parsing and execution errors are stricly ignored
            UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_SUCCESS;
            RETURN(UNAPIGEN.DBERR_SUCCESS);
         ELSE
            RETURN(a_return_code);
         END IF;
      ELSE
         --deadlock error must be returned to ParseAndExecuteRow for correct deadlock handling
         RETURN(a_return_code);
      END IF;
   END SpecialReturn;

BEGIN


   /* PAY attention the SpecialReturn function must be used instead of RETURN in this function */
   UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NONE,'   Parsing and excuting following row '||SUBSTR(P_CUR_TEXT_LINE,1,100));

   /* Parse the row */
   /* Section row ? */
   l_first_char := SUBSTR(P_CUR_TEXT_LINE,1,1);
   IF l_first_char='[' THEN

      /* Error handling when not a valid section */
      IF P_CUR_TEXT_LINE NOT IN ('[rq]', '[sc]', '[pg]', '[pa]', '[me]',
                                 '[cell]', '[cell table]', '[ic]', '[ii]',
                             '[BeginTransaction]', '[EndTransaction]', '[CloseParameterGroup]',
                             '[switchuser]', '[resetglobals]' ) THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,' Invalid section found:'||SUBSTR(P_CUR_TEXT_LINE,1,100));
         RETURN(SpecialReturn(UNAPIGEN.DBERR_INVALIDSECTION));
      END IF;

      /* Case section row (not a special section row like BeginTransaction,EndTransaction, ... */
      /* Perform the API call related to previous section                                      */
      /* Initialise section local variables with global variables                              */
      IF P_CUR_TEXT_LINE NOT IN ('[BeginTransaction]', '[EndTransaction]', '[CloseParameterGroup]') THEN

         l_ret_code := UCON_ExecuteSection;
         IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
            RETURN(SpecialReturn(l_ret_code));
         END IF;

         l_ret_code := UCON_InitialiseSection(P_CUR_TEXT_LINE);
         IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
            RETURN(SpecialReturn(l_ret_code));
         END IF;

      ELSE
      /* Case special sections */
         IF P_CUR_TEXT_LINE = '[BeginTransaction]' THEN

            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NONE,'   Executing previous section before starting the transaction');
            l_ret_code := UCON_ExecuteSection;
            IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
               RETURN(SpecialReturn(l_ret_code));
            END IF;

            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NONE,'   BeginTransaction');
            AddRowInDumpArray;
            RETURN(SpecialReturn(UNAPIGEN.BeginTransaction));

         ELSIF P_CUR_TEXT_LINE = '[EndTransaction]' THEN

            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NONE,'   Executing previous section before terminating the transaction');
            l_ret_code := UCON_ExecuteSection;
            IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
               --terminate current transaction when the transaction is failing
               IF UNAPIGEN.P_TXN_ERROR = UNAPIGEN.DBERR_SUCCESS THEN
                  UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'   EndTransaction (COMMIT)');
               ELSE
                  UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'   EndTransaction (ROLLBACK)');
               END IF;
               AddRowInDumpArray;
               l_return := UNICONNECT.FinishTransaction;

               IF l_return <> UNAPIGEN.DBERR_SUCCESS THEN
                  UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'   EndTransaction failed :'||TO_CHAR(l_return));
               END IF;
               RETURN(SpecialReturn(l_ret_code));
            END IF;

            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'   EndTransaction');
            AddRowInDumpArray;
            RETURN(SpecialReturn(UNICONNECT.FinishTransaction));
         ELSIF P_CUR_TEXT_LINE = '[CloseParameterGroup]' THEN

            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'   Execute previous section before [CloseParameterGroup]');
            l_ret_code := UCON_ExecuteSection;
            IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
               RETURN(SpecialReturn(l_ret_code));
            END IF;

            AddRowInDumpArray;
            /* Check if there is a current sample */
            IF UNICONNECT.P_GLOB_SC IS NULL THEN
               UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_HIGH,'   No current sample for CloseParameterGroup !');
               RETURN(SpecialReturn(UNAPIGEN.DBERR_NOPARENTOBJECT));
            END IF;

            /* Check if there is a current pg */
            IF UNICONNECT.P_GLOB_PG IS NULL OR
               UNICONNECT.P_GLOB_PGNODE IS NULL THEN
               UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_HIGH,'   No current pg for CloseParameterGroup !');
               RETURN(SpecialReturn(UNAPIGEN.DBERR_NOOBJECT));
            END IF;

            /* Insert ClosePg event for current pg */
            l_ev_seq_nr := -1;
            l_event_tp := 'ClosePg';
            l_ev_details := 'sc=' || UNICONNECT.P_GLOB_SC || '#pgnode=' ||
                            TO_CHAR(UNICONNECT.P_GLOB_PGNODE);

            l_ret_code := UNAPIEV.InsertEvent('UCON_ParseAndExecuteRow',
                                              UNAPIGEN.P_EVMGR_NAME,
                                              'pg', UNICONNECT.P_GLOB_PG, '', '', '',
                                              l_event_tp, l_ev_details, l_ev_seq_nr);

            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'   OK : InsertEvent ClosePg for pg='||UNICONNECT.P_GLOB_PG||' ev_details:'||l_ev_details);
            RETURN(SpecialReturn(l_ret_code));
         END IF;
      END IF;

   /* Case comment row  or empty row */
   /*  Do nothing                    */
   ELSIF l_first_char = '''' OR l_first_char is NULL THEN
      NULL;
      AddRowInDumpArray;

   /* Case assignment row  */
   /*    Error handling when not within a section */
   /*    Validate and assign the local section variables OR the global settings, Also copy local to global in some cases */
   /*    Error handling when assignment is invalid */
   /*    A row can be continued on more than one row */
   /* Case else      */
   /*    error raised when trimmed row is not empty   */
   ELSE
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NONE,'   Assignment row');
      AddRowInDumpArray;
      IF P_CONTINUATION_USED THEN
         --just continue the assignment
         l_equal_pos := 0;
         l_ret_code := UCON_AssignRow(l_equal_pos);
         IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
            RETURN(SpecialReturn(l_ret_code));
         END IF;
      ELSE
         l_equal_pos := NVL(INSTR(P_CUR_TEXT_LINE,'='),0);
         IF l_equal_pos <> 0 THEN
            l_ret_code := UCON_AssignRow(l_equal_pos);
            IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
               RETURN(SpecialReturn(l_ret_code));
            END IF;
         ELSE
            IF RTRIM(P_CUR_TEXT_LINE) IS NOT NULL THEN
               RETURN(SpecialReturn(UNAPIGEN.DBERR_INVALIDROW));
            END IF;
         END IF;
      END IF;
   END IF;

   /* Case end-of-file detected                        */
   /* Perform the API call related to last section     */
   IF a_is_the_last_line THEN
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'   End-of-file found : executing last section');
      RETURN(SpecialReturn(UCON_ExecuteSection));
   END IF;
   /* End Case */
   RETURN(UNAPIGEN.DBERR_SUCCESS);


EXCEPTION
WHEN OTHERS THEN
   --an exception has been catched
   --it must be logged and ignored when this special falg is set
   IF P_ON_EXCEPTIONS_CONTINUE THEN
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'Exception catched but parsing and execution will continue !');
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,SUBSTR(SQLERRM,1,200));
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_SUCCESS;
      RETURN(UNAPIGEN.P_TXN_ERROR);
   ELSE
      --ReRaise the exception : will be catched by the parser
      RAISE;
   END IF;

END UCON_ParseAndExecuteRow;

/* UCON_ParseAndExecuteRows */
FUNCTION UCON_ParseAndExecuteRows             /* INTERNAL */
(a_nr_of_rows     IN   NUMBER)
RETURN NUMBER IS

l_row                      INTEGER;
l_row_starting_transaction INTEGER;
l_is_the_last_line         BOOLEAN;

   --Internal function used to handle the deadlock errors
   FUNCTION RetryOnDeadlock (a_row_starting_transaction IN NUMBER,
                             a_current_row              IN NUMBER)
   RETURN NUMBER IS
   l_retry_counter            INTEGER;
   l_ret_code                 INTEGER;
   l_leave_retry_loop         BOOLEAN;
   l_is_the_last_line         BOOLEAN;
   BEGIN
      --a deadlock has been detected: the transaction must be restarted
      --l_row_starting_transaction is containing the row number that started the transaction
      --
      --2 cases: l_row_starting_transaction IS NULL => no transaction control sections, just resubmit last section
      --         l_row_starting_transaction IS NOT NULL => restart from that row to the current row
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_HIGH,'Deadlock detected on '||TO_CHAR(CURRENT_TIMESTAMP)||'. Will try to wait and reprocess current transaction');

      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'Deadlock handling: current transation rows:first_row='||TO_CHAR(a_row_starting_transaction)||
                                                     '#last_row='||TO_CHAR(a_current_row));

      IF UNAPIGEN.P_TXN_LEVEL > 0 THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'Ending current transaction before deadlock handling');
         l_ret_code := UNICONNECT.FinishTransaction;
       END IF;
      l_is_the_last_line := FALSE;
      l_retry_counter := 1;
      LOOP
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_HIGH,'Deadlock handling sleeping for 10 seconds');
         DBMS_LOCK.SLEEP(10);
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW, 'Deadlock handling: retry attempt nr'||l_retry_counter);

         IF a_row_starting_transaction IS NULL THEN

            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW, 'Deadlock handling: transaction limited to the last section');
            IF a_current_row = a_nr_of_rows THEN
               l_is_the_last_line := TRUE;
            END IF;
            l_ret_code := UCON_ParseAndExecuteRow(l_is_the_last_line);
            IF l_ret_code = UNAPIGEN.DBERR_DEADLOCKDETECTED THEN
               l_retry_counter := l_retry_counter + 1;
               IF l_retry_counter > P_MAX_DEADLOCK_RETRIES THEN
                  UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_HIGH,'Deadlock handling : maximum number of retries reached:'||P_MAX_DEADLOCK_RETRIES||'. Deadlock handling stopped.');
                  l_ret_code := UNAPIGEN.DBERR_GENFAIL;
                  EXIT;
               END IF;
            ELSE
               EXIT;
            END IF;
         ELSE
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW, 'Deadlock handling: transaction on more than one section, resubmit full transaction');
            l_leave_retry_loop := FALSE;
            P_SECTION := NULL;
            P_ROWS_IN_SECTION := 0;
            FOR l_row IN a_row_starting_transaction..a_current_row LOOP
               P_CUR_TEXT_LINE := P_TEXT_LINE(l_row);
               IF l_row = a_nr_of_rows THEN
                  l_is_the_last_line := TRUE;
               ELSE
                  l_is_the_last_line := FALSE;
               END IF;
               l_ret_code := UCON_ParseAndExecuteRow(l_is_the_last_line);
               IF l_ret_code = UNAPIGEN.DBERR_DEADLOCKDETECTED THEN
                  l_retry_counter := l_retry_counter + 1;
                  IF l_retry_counter > P_MAX_DEADLOCK_RETRIES THEN
                     UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_HIGH,'Deadlock handling : maximum number of retries reached:'||P_MAX_DEADLOCK_RETRIES||'. Deadlock handling stopped.');
                     l_ret_code := UNAPIGEN.DBERR_GENFAIL;
                     l_leave_retry_loop := TRUE;
                     EXIT; --exit also the retry loop
                  END IF;
               ELSIF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
                  l_leave_retry_loop := TRUE;
                  EXIT; --exit also the retry loop
               ELSE
                  l_leave_retry_loop := TRUE;
                  --no exit here, must execute all rows before leaving
               END IF;
            END LOOP;
            IF l_leave_retry_loop THEN
               EXIT;
            END IF;
         END IF;
      END LOOP;
      IF UNICONNECT.P_ON_DBAPI_ERROR_CONTINUE THEN
         --execution errors are strictly ignored
         --reset the transaction error flag when not yet done
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_SUCCESS;
         RETURN(UNAPIGEN.DBERR_SUCCESS);
      ELSE
         RETURN(l_ret_code);
      END IF;

   END RetryOnDeadlock;

BEGIN
      l_is_the_last_line := FALSE;
      FOR l_row IN 1..a_nr_of_rows LOOP
         IF l_row = a_nr_of_rows THEN
            l_is_the_last_line := TRUE;
         END IF;
         P_CUR_TEXT_LINE := P_TEXT_LINE(l_row);
         l_ret_code := UCON_ParseAndExecuteRow(l_is_the_last_line);
         IF UNAPIGEN.P_TXN_LEVEL > 0 AND l_row_starting_transaction IS NULL THEN
            l_row_starting_transaction := l_row;
         ELSIF UNAPIGEN.P_TXN_LEVEL <= 0 AND l_row_starting_transaction IS NOT NULL THEN
            l_row_starting_transaction := NULL;
         END IF;
         IF l_ret_code = UNAPIGEN.DBERR_DEADLOCKDETECTED THEN
            l_ret_code := RetryOnDeadlock(l_row_starting_transaction, l_row);
            IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
              RETURN(l_ret_code);
            END IF;
         ELSIF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
            RETURN(l_ret_code);
         END IF;
      END LOOP;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

END UCON_ParseAndExecuteRows;

/* UCON Main function */
FUNCTION Parser                               /* INTERNAL */
RETURN NUMBER IS

l_file_name                VARCHAR2(255);
l_read_on                  UNAPIGEN.DATE_TABLE_TYPE;
l_line_nbr                 UNAPIGEN.NUM_TABLE_TYPE;
l_nr_of_rows_in            NUMBER;
l_nr_of_rows_out           NUMBER;
l_next_rows                NUMBER;
l_row                      NUMBER;
l_leave_loop               BOOLEAN;
l_return                   NUMBER;
l_sub_ret_code             INTEGER;
l_del_ret_code             INTEGER;
l_su_ret_code              INTEGER;
l_cursor_is_closed         BOOLEAN DEFAULT TRUE;
l_text_line_tab            UNAPIGEN.VC2000_TABLE_TYPE;
l_text_line_tab_nr_of_rows INTEGER;
l_raw_data                 RAW(8000);
l_convert_from_utf16       BOOLEAN;

   PROCEDURE DetectUTF16File(a_text_line IN OUT VARCHAR2, a_isutf16littleendianfile OUT BOOLEAN)
   IS
   BEGIN
      BEGIN
         a_isutf16littleendianfile := FALSE;
         IF LENGTHB(a_text_line)>=2 THEN
            IF UTL_RAW.SUBSTR( UTL_RAW.CAST_TO_RAW(a_text_line),1,2)='FFFE' THEN
               a_isutf16littleendianfile := TRUE;
               IF LENGTHB(a_text_line)>2 THEN
                  l_raw_data := UTL_RAW.SUBSTR(UTL_RAW.CAST_TO_RAW(a_text_line),3);
                  --very strange but this is the way microsoft wants to work,
                  --we have to had the very first byte on the very first row
                  --if we want to make it work
                  a_text_line := UTL_RAW.CAST_TO_VARCHAR2('00'||l_raw_data);
                  UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NORMAL,'Detected a UTF16 little endian file - conversion will take place');
               ELSE
                  a_text_line := NULL;
               END IF;
            END IF;
         ELSE
            --do nothing
            NULL;
         END IF;
         IF a_isutf16littleendianfile = FALSE THEN
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NORMAL,'Detected an ANSI file - No conversion will take place');
         END IF;
      EXCEPTION
      WHEN VALUE_ERROR THEN
         a_isutf16littleendianfile := FALSE;
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NORMAL,'Numeric or value error while trying tp detect byte-order-marker '||l_ret_code);
      WHEN OTHERS THEN
         a_isutf16littleendianfile := FALSE;
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_HIGH,'DetectUTF16File: Error while trying tp detect byte-order-marker ');
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_HIGH,SUBSTR(SQLERRM,1,200));
      END;
   END DetectUTF16File;

   FUNCTION ConvertFromUTF16(a_text_line IN VARCHAR2)
   RETURN VARCHAR2 IS
   BEGIN
      --Fetch db character set when not yet fetched
      IF P_DB_CHARACTERSET IS NULL THEN
         SELECT value
         INTO P_DB_CHARACTERSET
         FROM NLS_DATABASE_PARAMETERS
         WHERE parameter='NLS_CHARACTERSET';
      END IF;
      IF SUBSTRB(a_text_line,1,1) = CHR(0) THEN
         --the SUBSTRB is the only I found up to now to set back the string
         --from Microsoft little endian unicode file to have the CONVERT function of
         --Oracle working correctly
         RETURN(CONVERT(SUBSTRB(a_text_line,2), P_DB_CHARACTERSET, 'AL16UTF16LE'));
      ELSE
         RETURN(CONVERT(a_text_line, P_DB_CHARACTERSET, 'AL16UTF16LE'));
      END IF;
   END ConvertFromUTF16;

BEGIN

   /*--------------------------------------------------------------------*/
   /* This function will parse and execute the generic UNILAB.uniconnect format */
   /* described in Uniconnect documentation                              */
   /*--------------------------------------------------------------------*/
   /* This custom function must be considered as a template              */
   /* It will be typically customised in projects since unicom4          */
   /* can not handle all possible cases                                  */
   /*--------------------------------------------------------------------*/

   /*-----------------------------*/
   /* Initialise global variables */
   /*-----------------------------*/
   UNAPIGEN.P_EVMGR_NAME := 'DEDICEVMGR';
   UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NORMAL,'StartTime'||TO_CHAR(CURRENT_TIMESTAMP));
   UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'Initialisation for global variables');
   P_GLOB_SC := NULL;
   P_GLOB_PG := NULL;
   P_GLOB_PGNODE := NULL;
   P_GLOB_PA := NULL;
   P_GLOB_PANODE := NULL;
   P_GLOB_ME := NULL;
   P_GLOB_MENODE := NULL;
   P_GLOB_CE := NULL;
   P_GLOB_CENODE := NULL;
   P_GLOB_IC := NULL;
   P_GLOB_ICNODE := NULL;
   P_GLOB_II := NULL;
   P_GLOB_IINODE := NULL;

   /*----------------------------------------*/
   /* Set default values for global settings */
   /*----------------------------------------*/
   P_SET_CREATE_SC         := 'W';
   P_SET_CREATE_PG         := 'W';
   P_SET_CREATE_PA         := 'W';
   P_SET_CREATE_ME         := 'W';
   P_SET_CREATE_IC         := 'W';
   P_SET_CREATE_II         := 'W';
   P_SET_CREATE_ME_DETAILS := 'W';
   P_SET_ALLOW_REANALYSIS  := 'N'; -- Default value changed for Apollo.


   /* Internal initialisation */
   P_CUR_TEXT_LINE:=NULL;
   P_CONTINUATION_USED:=FALSE;
   P_SECTION:=NULL;
   P_VARIABLE_NAME:=NULL;
   P_VARIABLE_VALUE:=NULL;
   P_SECTION_NR_OF_ROWS := 0;
   P_SECTION_DUMPED := FALSE;

   UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'Delete rows which are older than 2 weeks from utullog');
   DELETE FROM utullog
   WHERE unilink_id = UNAPIUL.P_UNILINK_ID
   AND logdate < CURRENT_TIMESTAMP-14;

   /*------------------------------------*/
   /* Loop through all records of utulin */
   /*------------------------------------*/
   UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NONE,'Loop through all records of utulin');
   l_file_name := UNAPIUL.P_FILE_NAME;
   l_nr_of_rows_in := 200;
   l_nr_of_rows_out := l_nr_of_rows_in;
   l_next_rows := 0;
   l_leave_loop := FALSE;
   l_sub_ret_code := UNAPIGEN.DBERR_SUCCESS;
   l_text_line_tab_nr_of_rows := 0;
   l_convert_from_utf16 := FALSE;

   WHILE NOT l_leave_loop LOOP
      l_ret_code := UNAPIUL.GetULTextList
              (l_file_name, l_read_on, l_line_nbr, l_text_line_tab,
               l_nr_of_rows_out,l_next_rows);
      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS AND
         l_ret_code <> UNAPIGEN.DBERR_NORECORDS THEN
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_HIGH,'GetULTextList failed='||l_ret_code);
            l_leave_loop := TRUE;
      ELSE
         l_cursor_is_closed := FALSE;
         /*---------------------------------------------------------*/
         /* Rows have been fetched or end-of-file has been detected */
         /* Start Parsing and execution of these rows               */
         /*---------------------------------------------------------*/
         IF l_ret_code = UNAPIGEN.DBERR_NORECORDS THEN
            l_leave_loop := TRUE;
         ELSE
            --if we enter for the first time in the loop, we have to detect if the first characters
            --of the very first row is a byte-order-marker implying a little conversion for every line
            --this is necessary since version 6.2 of Unilab that delivers
            --a Uniconnect client generating UTF16 files (little endian) - standard from Microsoft
            --
            IF l_text_line_tab_nr_of_rows=0 AND l_nr_of_rows_out>0 THEN
               DetectUTF16File(l_text_line_tab(1), l_convert_from_utf16);
            END IF;

            --copy in local array in global array
            FOR l_row IN 1..l_nr_of_rows_out LOOP
               IF NOT l_convert_from_utf16 THEN
                  P_TEXT_LINE(l_text_line_tab_nr_of_rows+l_row) := l_text_line_tab(l_row);
               ELSE
                  P_TEXT_LINE(l_text_line_tab_nr_of_rows+l_row) := ConvertFromUTF16(l_text_line_tab(l_row));
               END IF;
            END LOOP;
            l_text_line_tab_nr_of_rows := l_text_line_tab_nr_of_rows + l_nr_of_rows_out;
         END IF;

         IF l_nr_of_rows_out < l_nr_of_rows_in THEN
            l_leave_loop := TRUE;
         ELSE
            --fecth the following rows
            l_next_rows := 1;
         END IF;
      END IF;
   END LOOP;
   /*----------*/
   /* End Loop */
   /*----------*/

   /*-----------------------------------------------------------------------------------*/
   /* close open cursor when still open                                                 */
   /* Assumption : l_ret_code is containing the returned value of UNAPIUL.GetULTextList */
   /*-----------------------------------------------------------------------------------*/
   IF l_ret_code <> UNAPIGEN.DBERR_NORECORDS AND
      UNAPIGEN.P_TXN_ERROR <> UNAPIGEN.DBERR_SUCCESS THEN
      l_nr_of_rows_out := l_nr_of_rows_in;
      l_next_rows := -1;
      l_ret_code := UNAPIUL.GetULTextList
              (l_file_name, l_read_on, l_line_nbr, l_text_line_tab,
               l_nr_of_rows_out,l_next_rows);

      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_HIGH,'CLosing the cursor for GetULTextList failed='||l_ret_code);
      END IF;
   END IF;
   l_cursor_is_closed := TRUE;

   /*------------------*/
   /* Process the rows */
   /*------------------*/
   IF l_text_line_tab_nr_of_rows > 0 THEN
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'call UCON_ParseAndExecuteRows');
      l_sub_ret_code := UCON_ParseAndExecuteRows(l_text_line_tab_nr_of_rows);
      IF l_sub_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NORMAL,'UCON_ParseAndExecuteRows failed='||l_sub_ret_code);
         /* Partial save is already handled in Executesection */
         UNAPIGEN.P_TXN_ERROR := l_sub_ret_code;
      END IF;
   END IF;

   /*---------------------------------------------------------------------------*/
   /* Perform an EndTransaction to be sure the transaction is always terminated */
   /*---------------------------------------------------------------------------*/
   IF UNAPIGEN.P_TXN_LEVEL > 0 THEN
      IF l_sub_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'Sections executed successfully but without EndTransaction ! Endtransaction performed now');
      END IF;
      l_ret_code := UNICONNECT.FinishTransaction;
      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_HIGH,'EndTransaction Failed:'|| l_ret_code);
      END IF;
   END IF;
   /*-----------------------------*/
   /* Delete the rows from utulin */
   /*-----------------------------*/
   UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NORMAL,'Execution terminated at '||TO_CHAR(CURRENT_TIMESTAMP));
   l_del_ret_code := UNAPIUL.DeleteULText(l_file_name);
   IF l_del_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_HIGH,'Deleting Text('||l_file_name||') Failed:'|| l_del_ret_code);
   ELSE
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'Text ('||l_file_name||') deleted from utulin table');
   END IF;

   /*---------------------------------------------*/
   /* Swith back user context to job user context */
   /*---------------------------------------------*/
   l_su_ret_code := UNICONNECT7.UCON_RestoreJobUserContext;
   IF l_su_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_HIGH,'Restoring job user context failed:'|| l_su_ret_code);
   ELSE
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW, 'Restore of job user context OK');
   END IF;

   UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NORMAL,'Finish time '||TO_CHAR(CURRENT_TIMESTAMP));
   IF l_sub_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
      IF l_sub_ret_code = UNAPIGEN.DBERR_GENFAIL THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'General failure: uterror will be scanned for the last minute');
         FOR l_error_rec IN (SELECT *
                             FROM uterror
                             WHERE applic='Unilink'
                             AND logdate > CURRENT_TIMESTAMP-((1/24)/60)
                             ORDER BY logdate ASC) LOOP
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,SUBSTR(l_error_rec.error_msg,1,200));
         END LOOP;
      END IF;
      RETURN(l_sub_ret_code);
   END IF;
   IF l_del_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
      RETURN(l_del_ret_code);
   END IF;
   IF l_su_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
      RETURN(l_su_ret_code);
   END IF;
   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,'Exception catched in Parser ! Endtransaction will be performed if required');
   UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_ALERT,SUBSTR(SQLERRM,1,200));
   /*---------------------------------------------------------------------------*/
   /* Perform an EndTransaction to be sure the transaction is always terminated */
   /*---------------------------------------------------------------------------*/
   UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
   IF UNAPIGEN.P_TXN_LEVEL > 0 THEN
      l_ret_code := UNICONNECT.FinishTransaction;
      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_HIGH,'EndTransaction Failed:'|| l_ret_code);
      END IF;
   END IF;

   IF l_cursor_is_closed <> TRUE THEN
      l_nr_of_rows_out := l_nr_of_rows_in;
      l_next_rows := -1;
      l_ret_code := UNAPIUL.GetULTextList
              (l_file_name, l_read_on, l_line_nbr, l_text_line_tab,
               l_nr_of_rows_out,l_next_rows);

      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_HIGH,'CLosing the cursor for GetULTextList failed='||l_ret_code);
      END IF;
   END IF;
   l_cursor_is_closed := TRUE;

   /*--------------------------------------------------------*/
   /* Suppress the file that could not be parsed from utulin */
   /*--------------------------------------------------------*/
   UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NORMAL,'Execution failed and terminated at'||TO_CHAR(CURRENT_TIMESTAMP));
   l_del_ret_code := UNAPIUL.DeleteULText(l_file_name);
   IF l_del_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_HIGH,'Deleting Text('||l_file_name||') Failed:'|| l_del_ret_code);
   END IF;
   UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW,'Text ('||l_file_name||') deleted from utulin table');
   UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_NORMAL,'Finish time '||TO_CHAR(CURRENT_TIMESTAMP));

   /*---------------------------------------------*/
   /* Swith back user context to job user context */
   /*---------------------------------------------*/
   l_su_ret_code := UNICONNECT7.UCON_RestoreJobUserContext;
   IF l_su_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_HIGH,'Restoring job user context failed:'|| l_su_ret_code);
   ELSE
      UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_LOW, 'Restore of job user context OK');
   END IF;

   RETURN(UNAPIGEN.DBERR_GENFAIL);

END Parser;

PROCEDURE UCONDumpCurrentSection  /* INTERNAL */
IS

--This function will dump the current section to the logfile
--only one dump by section

BEGIN

   IF NOT P_SECTION_DUMPED THEN
      P_SECTION_DUMPED := TRUE;
      IF P_SECTION_NR_OF_ROWS > 0 THEN
         l_return := UNAPIUL.WriteToLog('UCON', '>>>>>>>>>>>>Section parsed:');
         FOR l_row IN 1..P_SECTION_NR_OF_ROWS LOOP
            l_return := UNAPIUL.WriteToLog('UCON','>>>>>>>>>>>>' ||P_SECTION_TEXT(l_row));
         END LOOP;
      END IF;
   END IF;

END UCONDumpCurrentSection;

PROCEDURE UCONWriteToLog            /* INTERNAL */
(a_severity IN NUMBER,           /* NUM_TYPE */
 a_text_line   IN VARCHAR2)         /* VC2000_TYPE */
IS

l_severity   VARCHAR2(20);

BEGIN

--This procedure allows to filter the messages in function of their severity
--The possible values are the same as the one used for tracing (see Trace function)
   IF a_severity >= NVL(UNAPIUL.P_TRACE_LEVEL,5) THEN

      IF a_severity = UNAPIUL.UL_TRACE_NONE THEN
         l_severity := 'NONE  ';
      ELSIF a_severity = UNAPIUL.UL_TRACE_LOW THEN
         l_severity := 'LOW   ';
      ELSIF a_severity = UNAPIUL.UL_TRACE_NORMAL THEN
         l_severity := 'NORMAL';
      ELSIF a_severity = UNAPIUL.UL_TRACE_HIGH THEN
         l_severity := 'HIGH>>>>';
      ELSIF a_severity = UNAPIUL.UL_TRACE_ALERT THEN
         l_severity := 'ALERT>>>>>>';
      ELSE
         l_severity := '      ';
      END IF;

      l_return := UNAPIUL.WriteToLog('UCON', l_severity||' '||a_text_line);

      --the full section is dumped in the logfile when seveirty is high or alert
      IF a_severity >= UNAPIUL.UL_TRACE_HIGH THEN
         UCONDumpCurrentSection;
      END IF;

   END IF;

END UCONWriteToLog;

FUNCTION FinishTransaction       /* INTERNAL */
RETURN NUMBER IS

BEGIN
   --may be replaced by UNAPIGEN.SynchrEndTransaction when required
   -- 05/02/2014 | JR | Advise from Siemens to use the SyncrEndTransaction
   --RETURN(UNAPIGEN.EndTransaction);
   RETURN(UNAPIGEN.SynchrEndTransaction);

END FinishTransaction;

FUNCTION GetVersion
  RETURN VARCHAR2
IS
BEGIN
  RETURN('06.07.00.00_13.00');
EXCEPTION
  WHEN OTHERS THEN
	 RETURN (NULL);
END GetVersion;


END uniconnect;
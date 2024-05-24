create or replace PACKAGE BODY -- Unilab 4.0 Package
-- $Revision: 3 $
-- $Date: 21/09/04 14:00 $
                                   ungkassign AS
--------------------------------------------------------------------------------
--  PROJECT : Vredestein Enschede
-------------------------------------------------------------------------------
--  PACKAGE : UNGKASSIGN
-- ABSTRACT :
--   WRITER : Rody Sparenberg
--     DATE : 25/06/2008
--   TARGET : Oracle 10.2.0 / Unilab 6.3
--  VERSION : av3.0
--------------------------------------------------------------------------------
--  REMARKS : The general rules for cf_type in utcf can be found in the
--            document: customizing the system
--            Minimal information can also be found in the header
--            of the unaction package
--------------------------------------------------------------------------------
--  CHANGES :
--
--  When      | Who       | What
--============|===========|=====================================================
-- 25/06/2008 | RS        | Added RqAlways
-- 03/03/2011 | RS        | Upgrade V6.3
--                        | Changed SYSDATE INTO CURRENT_TIMESTAMP
--                        | Changed TO_DATE INTO TO_TIMESTAMP_TZ
-- 23/06/2016 | JP/JR     | Added AssignRoles 			(ERULG011A)
-- 18/07/2016 | JP/JR     | Added AssignMeGkUserGroup	(ERULG011A)
-- 18/07/2016 | JP/JR     | Added ScPriority, ScDate1-5 (ERULG008C)
-- 27/07/2016 | JP        | Corrected case and improved error logging in scPriority, scDate1-5
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
l_sql_string    VARCHAR2(2000);
l_sqlerrm       VARCHAR2(255);
l_result        INTEGER;
l_ret_code      INTEGER;
StpError        EXCEPTION;

--------------------------------------------------------------------------------
-- functions- and/or procedures-declarations
--------------------------------------------------------------------------------
FUNCTION RqAlways
(a_gk   IN     VARCHAR2)                                  /* VC20_TYPE */
RETURN NUMBER IS
l_row           INTEGER;
l_found         BOOLEAN;
l_sub_row       INTEGER;
l_single_valued CHAR(1);
l_touched       BOOLEAN;
l_new_value     VARCHAR2(40);
l_gk_version    VARCHAR2(20);

l_svgk_sc              UNAPIGEN.VC20_TABLE_TYPE;
l_svgk_gk              UNAPIGEN.VC20_TABLE_TYPE;
l_svgk_value           UNAPIGEN.VC40_TABLE_TYPE;
l_svgk_description     UNAPIGEN.VC40_TABLE_TYPE;
l_svgk_is_protected    UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_value_unique    UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_single_valued   UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_new_val_allowed UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_mandatory       UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_value_list_tp   UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_dsp_rows        UNAPIGEN.NUM_TABLE_TYPE;
l_nr_of_rows           INTEGER;
l_svgk_where_clause    VARCHAR2(511);

BEGIN

   ---------------------------------------------------------------------------------------------
   -- !!!
   -- It is a good practice to check if the event matches '%GroupKeyUpdated' when an action will
   -- be used in an event rule. It enables us to avoid loops in event rules.
   -- !!!
   ---------------------------------------------------------------------------------------------
   IF UNAPIEV.P_EV_REC.ev_tp LIKE '%GroupKeyUpdated' THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;

   SELECT NVL(default_value, '<< not found >>')
     INTO l_svgk_value(1)
     FROM utgkrq
    WHERE gk = a_gk;

   IF l_svgk_value(1) = '<< not found >>' THEN
      l_svgk_value(1) := NULL;
   END IF;

   l_nr_of_rows := 1;
   IF UNAPIEV.P_EV_REC.object_tp= 'rq' THEN
      /* Argument gk_version is left empty */
      l_ret_code := UNAPIRQP.Save1RqGroupKey(UNAPIEV.P_RQ, a_gk, l_gk_version,
                                    l_svgk_value, l_nr_of_rows, NULL);
         IF UNAPIEV.P_EV_OUTPUT_ON THEN
            UNTRACE.LOG(
               'Save1RqGroupKey#return=' || TO_CHAR(l_ret_code) ||
               '#rq=' || UNAPIEV.P_RQ ||
               '#gk=' || a_gk ||
               '#nr_of_rows=' || TO_CHAR(l_nr_of_rows));
            END IF;
      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS AND
         l_ret_code <> UNAPIGEN.DBERR_UNIQUEGK THEN
         l_sqlerrm :=
         'Save1RqGroupKey#return=' || TO_CHAR(l_ret_code) ||
         '#rq=' || UNAPIEV.P_RQ ||
         '#gk=' || a_gk ||
         '#nr_of_rows=' || TO_CHAR(l_nr_of_rows);
         RAISE StpError;
      END IF;
   END IF;
   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF sqlcode <> 1 THEN
      l_sqlerrm := SUBSTR(SQLERRM,1,255);
   END IF;
   INSERT INTO uterror(client_id, applic, who, logdate, api_name, error_msg)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP,
                     'RqAlways' , l_sqlerrm );

   RETURN(UNAPIGEN.DBERR_GENFAIL);
END RqAlways;


---------------------------------------------------------------------------------
/*-----------------------------------------------*/
/* Custom SampleCode related groupkey assignment */
/*-----------------------------------------------*/

FUNCTION ScDateNumber
(a_gk   IN     VARCHAR2)                                  /* VC20_TYPE */
/* transforms a date info_field DD/MM/YY into YYMMDD groupkey value */
RETURN NUMBER IS
l_row           INTEGER;
l_found         BOOLEAN;
l_sub_row       INTEGER;
l_single_valued CHAR(1);
l_touched       BOOLEAN;
l_new_value     VARCHAR2(40);
l_gk_version    VARCHAR2(20);

l_svgk_sc              UNAPIGEN.VC20_TABLE_TYPE;
l_svgk_gk              UNAPIGEN.VC20_TABLE_TYPE;
l_svgk_gk_version      UNAPIGEN.VC20_TABLE_TYPE;
l_svgk_value           UNAPIGEN.VC40_TABLE_TYPE;
l_svgk_description     UNAPIGEN.VC40_TABLE_TYPE;
l_svgk_is_protected    UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_value_unique    UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_single_valued   UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_new_val_allowed UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_mandatory       UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_value_list_tp   UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_dsp_rows        UNAPIGEN.NUM_TABLE_TYPE;
l_nr_of_rows           INTEGER;
l_svgk_where_clause    VARCHAR2(511);

   PROCEDURE AddNewValue IS

   BEGIN
      -- Add l_new_value if not already in l_svgk_value
      l_found := FALSE;
      FOR l_row IN 1..l_nr_of_rows LOOP
         IF l_svgk_value(l_row) = l_new_value OR
            (l_svgk_value(l_row) IS NULL AND l_new_value IS NULL) THEN
            l_found := TRUE;
            EXIT;
         END IF;
      END LOOP;
      IF NOT l_found THEN
         l_nr_of_rows:= l_nr_of_rows+ 1;
         l_svgk_sc         ( l_nr_of_rows) := UNAPIEV.P_SC;
         l_svgk_gk         ( l_nr_of_rows) := a_gk;
         l_svgk_value      ( l_nr_of_rows) := l_new_value;
      END IF;
   END AddNewValue;

   PROCEDURE RemoveOldValue IS

   l_leave_loop   BOOLEAN;
   l_sub_row      INTEGER;
   l_old_value    VARCHAR2(40);

   BEGIN
      -- Remove old_value entry from the l_svgk_value array
      -- (even if l_old_value is NULL)
      l_leave_loop := FALSE;
      l_row := 1;
      WHILE NOT l_leave_loop LOOP
         IF l_row <= l_nr_of_rows THEN
            BEGIN
               l_old_value := TO_NUMBER( TO_CHAR( TO_TIMESTAMP_TZ(
                              UNAPIEV.P_OLD_VALUE, 'DD/MM/RR'),
                              'YYYYMMDD'));
            EXCEPTION
            WHEN OTHERS THEN
               l_old_value := NULL;
            END;
            IF l_svgk_value(l_row) = l_old_value OR
               (l_svgk_value(l_row) IS NULL AND l_old_value IS NULL)  THEN
               FOR l_sub_row IN l_row..l_nr_of_rows-1 LOOP
                  l_svgk_value(l_sub_row) := l_svgk_value(l_sub_row+1);
               END LOOP;
               l_nr_of_rows:= l_nr_of_rows- 1;
            ELSE
               l_row := l_row + 1;
            END IF;
         ELSE
            l_leave_loop := TRUE;
         END IF;
      END LOOP;

   END RemoveOldValue;

BEGIN

   ---------------------------------------------------------------------------------------------
   -- !!!
   -- It is a good practice to check if the event matches '%GroupKeyUpdated' when an action will
   -- be used in an event rule. It enables us to avoid loops in event rules.
   -- !!!
   ---------------------------------------------------------------------------------------------
   IF UNAPIEV.P_EV_REC.ev_tp LIKE '%GroupKeyUpdated' THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;

   l_nr_of_rows:= 0;
   l_touched := FALSE;
   l_ret_code := UNAPISCP.GetScGroupKey (l_svgk_sc, l_svgk_gk, l_svgk_gk_version, l_svgk_value,
                    l_svgk_description, l_svgk_is_protected, l_svgk_value_unique, l_svgk_single_valued,
                    l_svgk_new_val_allowed, l_svgk_mandatory, l_svgk_value_list_tp,
                    l_svgk_dsp_rows, l_nr_of_rows,
                    'WHERE sc = ''' || UNAPIEV.P_SC || ''' AND gk=''' || a_gk || '''' );
   IF UNAPIEV.P_EV_OUTPUT_ON THEN
      UNTRACE.LOG(
          'GetScGroupKey#return=' || TO_CHAR(l_ret_code) ||
          '#nr_of_rows=' || TO_CHAR(l_nr_of_rows) ||
          '#where_clause=' || 'WHERE sc = ''' || UNAPIEV.P_SC || ''' AND gk=''' || a_gk || '''');
   END IF;
   IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
      IF l_ret_code = UNAPIGEN.DBERR_NORECORDS THEN
         l_nr_of_rows:= 0;
      ELSE
         l_sqlerrm :=
          'GetScGroupKey#return=' || TO_CHAR(l_ret_code) ||
          '#nr_of_rows=' || TO_CHAR(l_nr_of_rows) ||
          '#where_clause=' || 'WHERE sc = ''' || UNAPIEV.P_SC || ''' AND gk=''' || a_gk || '''' ;
         RAISE StpError;
      END IF;
   END IF;

   IF l_nr_of_rows> 0 THEN
      l_single_valued := l_svgk_single_valued(1);
   ELSE
      SELECT single_valued
      INTO l_single_valued
      FROM utgksc
      WHERE gk = a_gk;
   END IF;

   BEGIN
      l_new_value := TO_NUMBER( TO_CHAR( TO_TIMESTAMP_TZ(
                     UNAPIEV.P_NEW_VALUE, 'DD/MM/RR'),
                     'YYYYMMDD'));
   EXCEPTION
   WHEN OTHERS THEN
      l_new_value := NULL;
   END;

   IF UNAPIEV.P_EV_REC.ev_tp = 'InfoFieldCreated' THEN

      l_touched := TRUE;
      IF l_single_valued = '1' THEN
         l_svgk_value(1) := l_new_value;
         l_nr_of_rows := 1;
      ELSE
         AddNewValue;
      END IF;

   ELSIF UNAPIEV.P_EV_REC.ev_tp = 'InfoFieldValueChanged' THEN

      l_touched := TRUE;
      RemoveOldValue;

      IF l_single_valued = '1' THEN
         l_svgk_value(1) := l_new_value;
         l_nr_of_rows := 1;
      ELSE
         AddNewValue;
      END IF;

   ELSIF UNAPIEV.P_EV_REC.ev_tp = 'InfoFieldDeleted' THEN

      l_touched := TRUE;
      RemoveOldValue;

   END IF;

   IF l_touched THEN
      /* Argument gk_version is left empty */
      l_ret_code := UNAPISCP.Save1ScGroupKey(UNAPIEV.P_SC, a_gk, l_gk_version,
                                             l_svgk_value, l_nr_of_rows, NULL);
         IF UNAPIEV.P_EV_OUTPUT_ON THEN
            UNTRACE.LOG(
               'Save1ScGroupKey#return=' || TO_CHAR(l_ret_code) ||
               '#sc=' || UNAPIEV.P_SC ||
               '#gk=' || a_gk ||
               '#nr_of_rows=' || TO_CHAR(l_nr_of_rows));
         END IF;
      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS AND
         l_ret_code <> UNAPIGEN.DBERR_UNIQUEGK THEN
         l_sqlerrm :=
          'Save1ScGroupKey#return=' || TO_CHAR(l_ret_code) ||
          '#sc=' || UNAPIEV.P_SC ||
          '#gk=' || a_gk ||
          '#nr_of_rows=' || TO_CHAR(l_nr_of_rows);
         RAISE StpError;
      END IF;
   END IF;
   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF sqlcode <> 1 THEN
      l_sqlerrm := SUBSTR(SQLERRM,1,255);
   END IF;
   INSERT INTO uterror(client_id, applic, who, logdate, api_name, error_msg)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP,
                     'ScDateNumber' , l_sqlerrm );
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END ScDateNumber;

---------------------------------------------------------------------------------
FUNCTION ScSamplingDate
(a_gk   IN     VARCHAR2)                                  /* VC20_TYPE */
/* transforms sampling_date into a YYMMDD entry */
RETURN NUMBER IS

l_row           INTEGER;
l_found         BOOLEAN;
l_sub_row       INTEGER;
l_single_valued CHAR(1);
l_touched       BOOLEAN;
l_new_value     VARCHAR2(40);
l_ie            VARCHAR2(20);
l_gk_version    VARCHAR2(20);

l_svgk_sc              UNAPIGEN.VC20_TABLE_TYPE;
l_svgk_gk              UNAPIGEN.VC20_TABLE_TYPE;
l_svgk_value           UNAPIGEN.VC40_TABLE_TYPE;
l_svgk_description     UNAPIGEN.VC40_TABLE_TYPE;
l_svgk_is_protected    UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_value_unique    UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_single_valued   UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_new_val_allowed UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_mandatory       UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_value_list_tp   UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_dsp_rows        UNAPIGEN.NUM_TABLE_TYPE;
l_nr_of_rows           INTEGER;
l_svgk_where_clause    VARCHAR2(511);

CURSOR l_cursor_start_date (a_sc IN VARCHAR2) IS
      SELECT TO_CHAR(sampling_date,'YYMMDD')
      FROM utsc
      WHERE sc = UNAPIEV.P_SC;

BEGIN

   ---------------------------------------------------------------------------------------------
   -- !!!
   -- It is a good practice to check if the event matches '%GroupKeyUpdated' when an action will
   -- be used in an event rule. It enables us to avoid loops in event rules.
   -- !!!
   ---------------------------------------------------------------------------------------------
   IF UNAPIEV.P_EV_REC.ev_tp LIKE '%GroupKeyUpdated' THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;

   /* Assumption : Group key is single-valued             */
   /* This makes the code more readable than ScDateNumber */
   /*-----------------------------------------------------*/
   l_ie := 'SamplingDate';
   l_nr_of_rows:= 0;
   l_touched := FALSE;

   l_found := TRUE;
   OPEN l_cursor_start_date(UNAPIEV.P_SC);
   FETCH l_cursor_start_date
   INTO l_new_value;
   IF l_cursor_start_date%NOTFOUND THEN
      l_found := FALSE;
   END IF;
   CLOSE l_cursor_start_date;

   IF l_found THEN
      IF UNAPIEV.P_EV_REC.ev_tp = 'InfoFieldCreated' AND
         UNAPIEV.P_II = l_ie THEN

         l_touched := TRUE;
         l_svgk_value(1) := l_new_value;
         l_nr_of_rows := 1;

      ELSIF UNAPIEV.P_EV_REC.ev_tp = 'InfoFieldValueChanged' AND
         UNAPIEV.P_II = l_ie THEN

         l_touched := TRUE;

         l_svgk_value(1) := l_new_value;
         l_nr_of_rows := 1;

      ELSIF UNAPIEV.P_EV_REC.ev_tp = 'InfoFieldDeleted' AND
         UNAPIEV.P_II = l_ie THEN

         l_touched := TRUE;
         l_nr_of_rows := 0;

      ELSIF UNAPIEV.P_EV_REC.ev_tp = 'SampleCreated' THEN

         l_touched := TRUE;

         l_svgk_value(1) := l_new_value;
         l_nr_of_rows := 1;

      ELSIF UNAPIEV.P_EV_REC.ev_tp = 'SampleUpdated' THEN

         l_touched := TRUE;

         l_svgk_value(1) := l_new_value;
         l_nr_of_rows := 1;

      END IF;

      IF l_touched THEN
         /* Argument gk_version is left empty */
         l_ret_code := UNAPISCP.Save1ScGroupKey(UNAPIEV.P_SC, a_gk, l_gk_version,
                                       l_svgk_value, l_nr_of_rows, NULL);
            IF UNAPIEV.P_EV_OUTPUT_ON THEN
               UNTRACE.LOG(
                  'Save1ScGroupKey#return=' || TO_CHAR(l_ret_code) ||
                  '#sc=' || UNAPIEV.P_SC ||
                  '#gk=' || a_gk ||
                  '#nr_of_rows=' || TO_CHAR(l_nr_of_rows));
            END IF;
         IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS AND
            l_ret_code <> UNAPIGEN.DBERR_UNIQUEGK THEN
            l_sqlerrm :=
             'Save1ScGroupKey#return=' || TO_CHAR(l_ret_code) ||
             '#sc=' || UNAPIEV.P_SC ||
             '#gk=' || a_gk ||
             '#nr_of_rows=' || TO_CHAR(l_nr_of_rows);
            RAISE StpError;
         END IF;
      END IF;
   END IF;
   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF sqlcode <> 1 THEN
      l_sqlerrm := SUBSTR(SQLERRM,1,255);
   END IF;
   INSERT INTO uterror(client_id, applic, who, logdate, api_name, error_msg)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP,
                     'ScSamplingDate' , l_sqlerrm );
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END ScSamplingDate;



---------------------------------------------------------------------------------
/*--------------------------------------------------*/
/* Custom WorksheetCode related groupkey assignment */
/*--------------------------------------------------*/

FUNCTION WsCreationDate
(a_gk   IN     VARCHAR2)                                  /* VC20_TYPE */
/* transforms creation_date into a YYMMDD entry */
RETURN NUMBER IS

l_row           INTEGER;
l_found         BOOLEAN;
l_sub_row       INTEGER;
l_single_valued CHAR(1);
l_touched       BOOLEAN;
l_new_value     VARCHAR2(40);
l_ie            VARCHAR2(20);
l_gk_version    VARCHAR2(20);

l_svgk_ws              UNAPIGEN.VC20_TABLE_TYPE;
l_svgk_gk              UNAPIGEN.VC20_TABLE_TYPE;
l_svgk_value           UNAPIGEN.VC40_TABLE_TYPE;
l_svgk_description     UNAPIGEN.VC40_TABLE_TYPE;
l_svgk_is_protected    UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_value_unique    UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_single_valued   UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_new_val_allowed UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_mandatory       UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_value_list_tp   UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_dsp_rows        UNAPIGEN.NUM_TABLE_TYPE;
l_nr_of_rows           INTEGER;
l_svgk_where_clause    VARCHAR2(511);

CURSOR l_cursor_creation_date (a_ws IN VARCHAR2) IS
      SELECT TO_CHAR(creation_date,'YYMMDD')
      FROM utws
      WHERE ws = UNAPIEV.P_WS;

BEGIN

   ---------------------------------------------------------------------------------------------
   -- !!!
   -- It is a good practice to check if the event matches '%GroupKeyUpdated' when an action will
   -- be used in an event rule. It enables us to avoid loops in event rules.
   -- !!!
   ---------------------------------------------------------------------------------------------
   IF UNAPIEV.P_EV_REC.ev_tp LIKE '%GroupKeyUpdated' THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;

   /* Assumption : Group key is single-valued             */
   /*-----------------------------------------------------*/
   l_ie := 'CreationDate';
   l_nr_of_rows:= 0;
   l_touched := FALSE;

   l_found := TRUE;
   OPEN l_cursor_creation_date(UNAPIEV.P_WS);
   FETCH l_cursor_creation_date
   INTO l_new_value;
   IF l_cursor_creation_date%NOTFOUND THEN
      l_found := FALSE;
   END IF;
   CLOSE l_cursor_creation_date;

   IF l_found THEN
      IF UNAPIEV.P_EV_REC.ev_tp = 'InfoFieldCreated' AND
         UNAPIEV.P_II = l_ie THEN

         l_touched := TRUE;
         l_svgk_value(1) := l_new_value;
         l_nr_of_rows := 1;

      ELSIF UNAPIEV.P_EV_REC.ev_tp = 'InfoFieldValueChanged' AND
         UNAPIEV.P_II = l_ie THEN

         l_touched := TRUE;

         l_svgk_value(1) := l_new_value;
         l_nr_of_rows := 1;

      ELSIF UNAPIEV.P_EV_REC.ev_tp = 'InfoFieldDeleted' AND
         UNAPIEV.P_II = l_ie THEN

         l_touched := TRUE;
         l_nr_of_rows := 0;

      ELSIF UNAPIEV.P_EV_REC.ev_tp = 'WorksheetCreated' THEN

         l_touched := TRUE;

         l_svgk_value(1) := l_new_value;
         l_nr_of_rows := 1;

      ELSIF UNAPIEV.P_EV_REC.ev_tp = 'WorksheetUpdated' THEN

         l_touched := TRUE;

         l_svgk_value(1) := l_new_value;
         l_nr_of_rows := 1;

      END IF;

      IF l_touched THEN
         /* Argument gk_version is left empty */
         l_ret_code := UNAPIWSP.Save1WsGroupKey(UNAPIEV.P_WS, a_gk, l_gk_version,
                                       l_svgk_value, l_nr_of_rows, NULL);
            IF UNAPIEV.P_EV_OUTPUT_ON THEN
               UNTRACE.LOG(
                  'Save1WsGroupKey#return=' || TO_CHAR(l_ret_code) ||
                  '#ws=' || UNAPIEV.P_WS ||
                  '#gk=' || a_gk ||
                  '#nr_of_rows=' || TO_CHAR(l_nr_of_rows));
            END IF;
         IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS AND
            l_ret_code <> UNAPIGEN.DBERR_UNIQUEGK THEN
            l_sqlerrm :=
             'Save1WsGroupKey#return=' || TO_CHAR(l_ret_code) ||
             '#ws=' || UNAPIEV.P_WS ||
             '#gk=' || a_gk ||
             '#nr_of_rows=' || TO_CHAR(l_nr_of_rows);
            RAISE StpError;
         END IF;
      END IF;
   END IF;
   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF sqlcode <> 1 THEN
      l_sqlerrm := SUBSTR(SQLERRM,1,255);
   END IF;
   INSERT INTO uterror(client_id, applic, who, logdate, api_name, error_msg)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP,
                     'WsCreationDate' , l_sqlerrm );
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END WsCreationDate;



---------------------------------------------------------------------------------
/*-------------------------------------------*/
/* Custom Method related groupkey assignment */
/*-------------------------------------------*/

FUNCTION MeAssignSection              /* INTERNAL */
(a_gk   IN     VARCHAR2)              /* VC20_TYPE */
RETURN NUMBER
IS

l_svgk_value           UNAPIGEN.VC40_TABLE_TYPE;
l_nr_of_rows           INTEGER;
l_touched              BOOLEAN;
l_gk_version           VARCHAR2(20);

BEGIN
   ---------------------------------------------------------------------------------------------
   -- !!!
   -- It is a good practice to check if the event matches '%GroupKeyUpdated' when an action will
   -- be used in an event rule. It enables us to avoid loops in event rules.
   -- !!!
   ---------------------------------------------------------------------------------------------
   IF UNAPIEV.P_EV_REC.ev_tp LIKE '%GroupKeyUpdated' THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;

   l_touched := FALSE;
   IF UNAPIEV.P_EV_REC.ev_tp = 'MethodCreated' THEN

      l_touched := TRUE;
      l_svgk_value(1) := UNAPIEV.P_PG;
      l_nr_of_rows := 1;

   ELSIF UNAPIEV.P_EV_REC.ev_tp = 'MethodDeleted' THEN

      l_touched := TRUE;
      l_nr_of_rows := 0;
   END IF;

   IF l_touched THEN
      /* Argument gk_version is left empty */
      l_ret_code := UNAPIMEP.Save1ScMeGroupKey(UNAPIEV.P_SC,
                                     UNAPIEV.P_PG,UNAPIEV.P_PGNODE,
                                     UNAPIEV.P_PA,UNAPIEV.P_PANODE,
                                     UNAPIEV.P_ME,UNAPIEV.P_MENODE,
                                     a_gk, l_gk_version,
                                     l_svgk_value, l_nr_of_rows, NULL);
      IF UNAPIEV.P_EV_OUTPUT_ON THEN
         UNTRACE.LOG(
          'Save1ScMeGroupKey#return=' || TO_CHAR(l_ret_code) ||
          '#sc=' || UNAPIEV.P_SC ||
          '#pg=' || UNAPIEV.P_PG || '#pgnode=' || TO_CHAR(UNAPIEV.P_PGNODE) ||
          '#pa=' || UNAPIEV.P_PA || '#panode=' || TO_CHAR(UNAPIEV.P_PANODE) ||
          '#me=' || UNAPIEV.P_ME || '#menode=' || TO_CHAR(UNAPIEV.P_MENODE) ||
          '#gk=' || a_gk ||
          '#nr_of_rows=' || TO_CHAR(l_nr_of_rows));
      END IF;
      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS AND
         l_ret_code <> UNAPIGEN.DBERR_UNIQUEGK THEN
         l_sqlerrm :=
          'Save1ScMeGroupKey#return=' || TO_CHAR(l_ret_code) ||
          '#sc=' || UNAPIEV.P_SC ||
          '#pg=' || UNAPIEV.P_PG || '#pgnode=' || TO_CHAR(UNAPIEV.P_PGNODE) ||
          '#pa=' || UNAPIEV.P_PA || '#panode=' || TO_CHAR(UNAPIEV.P_PANODE) ||
          '#me=' || UNAPIEV.P_ME || '#menode=' || TO_CHAR(UNAPIEV.P_MENODE) ||
          '#gk=' || a_gk ||
          '#nr_of_rows=' || TO_CHAR(l_nr_of_rows);
         RAISE StpError;
      END IF;
   END IF;
   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF sqlcode <> 1 THEN
      l_sqlerrm := SUBSTR(SQLERRM,1,255);
   END IF;
   INSERT INTO uterror(client_id, applic, who, logdate, api_name, error_msg)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP,
                     'MeAssignSection' , l_sqlerrm );
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END MeAssignSection;

---------------------------------------------------------------------------------
FUNCTION MeAssignResponsible
(a_gk   IN     VARCHAR2)                                  /* VC20_TYPE */
RETURN NUMBER IS

/* Important assumption : this group-key is single-valued */

l_value                VARCHAR2(40);
l_svgk_value           UNAPIGEN.VC40_TABLE_TYPE;
l_nr_of_rows           INTEGER;
l_touched              BOOLEAN;
l_gk_version           VARCHAR2(20);

BEGIN
   ---------------------------------------------------------------------------------------------
   -- !!!
   -- It is a good practice to check if the event matches '%GroupKeyUpdated' when an action will
   -- be used in an event rule. It enables us to avoid loops in event rules.
   -- !!!
   ---------------------------------------------------------------------------------------------
   IF UNAPIEV.P_EV_REC.ev_tp LIKE '%GroupKeyUpdated' THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;

   l_touched := FALSE;
   IF UNAPIEV.P_EV_REC.object_tp = 'me' AND
      UNAPIEV.P_EV_REC.ev_tp <> 'MethodDeleted' THEN

      l_touched := TRUE;
      BEGIN
         SELECT MAX(value)  --necessary since an attribute can have multiple values
         INTO l_value
         FROM utscmeau
         WHERE sc = UNAPIEV.P_SC
           AND pg = UNAPIEV.P_PG
           AND pgnode = UNAPIEV.P_PGNODE
           AND pa = UNAPIEV.P_PA
           AND panode = UNAPIEV.P_PANODE
           AND me = UNAPIEV.P_ME
           AND menode = UNAPIEV.P_MENODE ;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         l_value := NULL;
      END;

      l_svgk_value(1) := l_value;
      l_nr_of_rows := 1;

   ELSIF UNAPIEV.P_EV_REC.object_tp = 'me' AND
      UNAPIEV.P_EV_REC.ev_tp <> 'MethodDeleted' THEN

      l_touched := TRUE;
      l_nr_of_rows := 0;
   END IF;

   IF l_touched THEN
      /* Argument gk_version is left empty */
      l_ret_code := UNAPIMEP.Save1ScMeGroupKey(UNAPIEV.P_SC,
                                     UNAPIEV.P_PG,UNAPIEV.P_PGNODE,
                                     UNAPIEV.P_PA,UNAPIEV.P_PANODE,
                                     UNAPIEV.P_ME,UNAPIEV.P_MENODE,
                                     a_gk, l_gk_version,
                                     l_svgk_value, l_nr_of_rows, NULL);
      IF UNAPIEV.P_EV_OUTPUT_ON THEN
         UNTRACE.LOG(
          'Save1ScMeGroupKey#return=' || TO_CHAR(l_ret_code) ||
          '#sc=' || UNAPIEV.P_SC ||
          '#pg=' || UNAPIEV.P_PG || '#pgnode=' || TO_CHAR(UNAPIEV.P_PGNODE) ||
          '#pa=' || UNAPIEV.P_PA || '#panode=' || TO_CHAR(UNAPIEV.P_PANODE) ||
          '#me=' || UNAPIEV.P_ME || '#menode=' || TO_CHAR(UNAPIEV.P_MENODE) ||
          '#gk=' || a_gk ||
          '#nr_of_rows=' || TO_CHAR(l_nr_of_rows));
      END IF;
      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS AND
         l_ret_code <> UNAPIGEN.DBERR_UNIQUEGK THEN
         l_sqlerrm :=
          'Save1ScMeGroupKey#return=' || TO_CHAR(l_ret_code) ||
          '#sc=' || UNAPIEV.P_SC ||
          '#pg=' || UNAPIEV.P_PG || '#pgnode=' || TO_CHAR(UNAPIEV.P_PGNODE) ||
          '#pa=' || UNAPIEV.P_PA || '#panode=' || TO_CHAR(UNAPIEV.P_PANODE) ||
          '#me=' || UNAPIEV.P_ME || '#menode=' || TO_CHAR(UNAPIEV.P_MENODE) ||
          '#gk=' || a_gk ||
          '#nr_of_rows=' || TO_CHAR(l_nr_of_rows);
         RAISE StpError;
      END IF;
   END IF;
   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF sqlcode <> 1 THEN
      l_sqlerrm := SUBSTR(SQLERRM,1,255);
   END IF;
   INSERT INTO uterror(client_id, applic, who, logdate, api_name, error_msg)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP,
                     'MeAssignResponsible' , l_sqlerrm );
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END MeAssignResponsible;


---------------------------------------------------------------------------------
/*--------------------------------------------*/
/* Custom Request related groupkey assignment */
/*--------------------------------------------*/

FUNCTION RqDayNumber
(a_gk   IN     VARCHAR2)                                  /* VC20_TYPE */
/* transforms CURRENT_TIMESTAMP into YYYYMMDD-DAY groupkey value */
RETURN NUMBER IS
l_row           INTEGER;
l_found         BOOLEAN;
l_sub_row       INTEGER;
l_single_valued CHAR(1);
l_touched       BOOLEAN;
l_new_value     VARCHAR2(40);
l_gk_version    VARCHAR2(20);

l_svgk_sc              UNAPIGEN.VC20_TABLE_TYPE;
l_svgk_gk              UNAPIGEN.VC20_TABLE_TYPE;
l_svgk_value           UNAPIGEN.VC40_TABLE_TYPE;
l_svgk_description     UNAPIGEN.VC40_TABLE_TYPE;
l_svgk_is_protected    UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_value_unique    UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_single_valued   UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_new_val_allowed UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_mandatory       UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_value_list_tp   UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_dsp_rows        UNAPIGEN.NUM_TABLE_TYPE;
l_nr_of_rows           INTEGER;
l_svgk_where_clause    VARCHAR2(511);

BEGIN

   ---------------------------------------------------------------------------------------------
   -- !!!
   -- It is a good practice to check if the event matches '%GroupKeyUpdated' when an action will
   -- be used in an event rule. It enables us to avoid loops in event rules.
   -- !!!
   ---------------------------------------------------------------------------------------------
   IF UNAPIEV.P_EV_REC.ev_tp LIKE '%GroupKeyUpdated' THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;

   l_svgk_value(1) := TO_CHAR(CURRENT_TIMESTAMP,'YYYYMMDD-DAY');
   l_nr_of_rows := 1;
   IF UNAPIEV.P_EV_REC.object_tp= 'rq' THEN
      /* Argument gk_version is left empty */
      l_ret_code := UNAPIRQP.Save1RqGroupKey(UNAPIEV.P_RQ, a_gk, l_gk_version,
                                    l_svgk_value, l_nr_of_rows, NULL);
         IF UNAPIEV.P_EV_OUTPUT_ON THEN
            UNTRACE.LOG(
               'Save1RqGroupKey#return=' || TO_CHAR(l_ret_code) ||
               '#rq=' || UNAPIEV.P_RQ ||
               '#gk=' || a_gk ||
               '#nr_of_rows=' || TO_CHAR(l_nr_of_rows));
            END IF;
      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS AND
         l_ret_code <> UNAPIGEN.DBERR_UNIQUEGK THEN
         l_sqlerrm :=
         'Save1RqGroupKey#return=' || TO_CHAR(l_ret_code) ||
         '#rq=' || UNAPIEV.P_RQ ||
         '#gk=' || a_gk ||
         '#nr_of_rows=' || TO_CHAR(l_nr_of_rows);
         RAISE StpError;
      END IF;
   ELSIF UNAPIEV.P_EV_REC.object_tp= 'rt' THEN
      /* Argument gk_version is left empty */
      l_ret_code := UNAPIRT.Save1RtGroupKey(UNAPIEV.P_EV_REC.object_id, UNAPIEV.P_VERSION,
                                            a_gk, l_gk_version,
                                            l_svgk_value, l_nr_of_rows, NULL);
         IF UNAPIEV.P_EV_OUTPUT_ON THEN
            UNTRACE.LOG(
               'Save1RtGroupKey#return=' || TO_CHAR(l_ret_code) ||
               '#rt=' || UNAPIEV.P_EV_REC.object_id ||
               '#version=' || UNAPIEV.P_VERSION ||
               '#gk=' || a_gk ||
               '#nr_of_rows=' || TO_CHAR(l_nr_of_rows));
            END IF;
      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS AND
         l_ret_code <> UNAPIGEN.DBERR_UNIQUEGK THEN
         l_sqlerrm :=
         'Save1RtGroupKey#return=' || TO_CHAR(l_ret_code) ||
         '#rt=' || UNAPIEV.P_EV_REC.object_id ||
         '#version=' || UNAPIEV.P_VERSION ||
         '#gk=' || a_gk ||
         '#nr_of_rows=' || TO_CHAR(l_nr_of_rows);
         RAISE StpError;
      END IF;
   END IF;
   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF sqlcode <> 1 THEN
      l_sqlerrm := SUBSTR(SQLERRM,1,255);
   END IF;
   INSERT INTO uterror(client_id, applic, who, logdate, api_name, error_msg)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP,
                     'RqDayNumber' , l_sqlerrm );

   RETURN(UNAPIGEN.DBERR_GENFAIL);
END RqDayNumber;

---------------------------------------------------------------------------------
FUNCTION RqWebUser
(a_gk   IN     VARCHAR2)                                  /* VC20_TYPE */
/* will set the gkvalue to the connected user when the request is created by a web user */
RETURN NUMBER IS
l_row           INTEGER;
l_found         BOOLEAN;
l_sub_row       INTEGER;
l_single_valued CHAR(1);
l_touched       BOOLEAN;
l_new_value     VARCHAR2(40);
l_gk_version    VARCHAR2(20);

l_svgk_sc              UNAPIGEN.VC20_TABLE_TYPE;
l_svgk_gk              UNAPIGEN.VC20_TABLE_TYPE;
l_svgk_value           UNAPIGEN.VC40_TABLE_TYPE;
l_svgk_description     UNAPIGEN.VC40_TABLE_TYPE;
l_svgk_is_protected    UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_value_unique    UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_single_valued   UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_new_val_allowed UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_mandatory       UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_value_list_tp   UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_dsp_rows        UNAPIGEN.NUM_TABLE_TYPE;
l_nr_of_rows           INTEGER;
l_svgk_where_clause    VARCHAR2(511);

BEGIN

   ---------------------------------------------------------------------------------------------
   -- !!!
   -- It is a good practice to check if the event matches '%GroupKeyUpdated' when an action will
   -- be used in an event rule. It enables us to avoid loops in event rules.
   -- !!!
   ---------------------------------------------------------------------------------------------
   IF UNAPIEV.P_EV_REC.ev_tp LIKE '%GroupKeyUpdated' THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;

   --this group key may only be created when the request has been created by the web application
   --detected through the application name
   IF UNAPIEV.P_EV_REC.applic <> 'u4iweb' THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;

   l_svgk_value(1) := UNAPIGEN.P_USER;
   l_nr_of_rows := 1;
   IF UNAPIEV.P_EV_REC.object_tp= 'rq' THEN
      /* Argument gk_version is left empty */
      l_ret_code := UNAPIRQP.Save1RqGroupKey(UNAPIEV.P_RQ, a_gk, l_gk_version,
                                    l_svgk_value, l_nr_of_rows, NULL);
         IF UNAPIEV.P_EV_OUTPUT_ON THEN
            UNTRACE.LOG(
               'Save1RqGroupKey#return=' || TO_CHAR(l_ret_code) ||
               '#rq=' || UNAPIEV.P_RQ ||
               '#gk=' || a_gk ||
               '#nr_of_rows=' || TO_CHAR(l_nr_of_rows));
            END IF;
      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS AND
         l_ret_code <> UNAPIGEN.DBERR_UNIQUEGK THEN
         l_sqlerrm :=
         'Save1RqGroupKey#return=' || TO_CHAR(l_ret_code) ||
         '#rq=' || UNAPIEV.P_RQ ||
         '#gk=' || a_gk ||
         '#nr_of_rows=' || TO_CHAR(l_nr_of_rows);
         RAISE StpError;
      END IF;
   END IF;
   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF sqlcode <> 1 THEN
      l_sqlerrm := SUBSTR(SQLERRM,1,255);
   END IF;
   INSERT INTO uterror(client_id, applic, who, logdate, api_name, error_msg)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP,
                     'RqWebUser' , l_sqlerrm );

   RETURN(UNAPIGEN.DBERR_GENFAIL);
END RqWebUser;



---------------------------------------------------------------------
/* u4Easy */
---------------------------------------------------------------------

FUNCTION ScOperational              /* INTERNAL */
(a_gk   IN     VARCHAR2)            /* VC20_TYPE */
RETURN NUMBER
IS

l_svgk_value           UNAPIGEN.VC40_TABLE_TYPE;
l_nr_of_rows           INTEGER;
l_touched              BOOLEAN;
l_gk_version           VARCHAR2(20);

BEGIN
   ---------------------------------------------------------------------------------------------
   -- !!!
   -- It is a good practice to check if the event matches '%GroupKeyUpdated' when an action will
   -- be used in an event rule. It enables us to avoid loops in event rules.
   -- !!!
   ---------------------------------------------------------------------------------------------
   IF UNAPIEV.P_EV_REC.ev_tp LIKE '%GroupKeyUpdated' THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;

   l_touched := FALSE;
   IF UNAPIEV.P_EV_REC.ev_tp = 'SampleCreated' THEN

      l_touched := TRUE;
      l_svgk_value(1) := 'Yes';
      l_nr_of_rows := 1;

   END IF;

   IF l_touched THEN
      /* Argument gk_version is left empty */
      l_ret_code :=UNAPISCP.Save1ScGroupKey(UNAPIEV.P_SC, a_gk, l_gk_version,
                                            l_svgk_value, l_nr_of_rows, NULL);
      IF UNAPIEV.P_EV_OUTPUT_ON THEN
         UNTRACE.LOG(
          'Save1ScGroupKey#return=' || TO_CHAR(l_ret_code) ||
          '#sc=' || UNAPIEV.P_SC ||
          '#gk=' || a_gk ||
          '#nr_of_rows=' || TO_CHAR(l_nr_of_rows));
      END IF;
      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS AND
         l_ret_code <> UNAPIGEN.DBERR_UNIQUEGK THEN
         l_sqlerrm :=
          'Save1ScGroupKey#return=' || TO_CHAR(l_ret_code) ||
          '#sc=' || UNAPIEV.P_SC ||
          '#gk=' || a_gk ||
          '#nr_of_rows=' || TO_CHAR(l_nr_of_rows);
         RAISE StpError;
      END IF;
   END IF;
   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF sqlcode <> 1 THEN
      l_sqlerrm := SUBSTR(SQLERRM,1,255);
   END IF;
   INSERT INTO uterror(client_id, applic, who, logdate, api_name, error_msg)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP,
                     'ScOperational' , l_sqlerrm );
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END ScOperational;

---------------------------------------------------------------------------------
FUNCTION ScReleased              /* INTERNAL */
(a_gk   IN     VARCHAR2)         /* VC20_TYPE */
RETURN NUMBER
IS

l_svgk_value           UNAPIGEN.VC40_TABLE_TYPE;
l_nr_of_rows           INTEGER;
l_touched              BOOLEAN;
l_gk_version           VARCHAR2(20);

BEGIN
   ---------------------------------------------------------------------------------------------
   -- !!!
   -- It is a good practice to check if the event matches '%GroupKeyUpdated' when an action will
   -- be used in an event rule. It enables us to avoid loops in event rules.
   -- !!!
   ---------------------------------------------------------------------------------------------
   IF UNAPIEV.P_EV_REC.ev_tp LIKE '%GroupKeyUpdated' THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;

   l_touched := FALSE;
   IF UNAPIEV.P_EV_REC.ev_tp = 'ScStatusChanged'
   AND UNAPIEV.P_EV_REC.object_ss = 'RL' THEN

      l_touched := TRUE;
      l_svgk_value(1) := 'Yes';
      l_nr_of_rows := 1;

   END IF;

   IF l_touched THEN
      /* Argument gk_version is left empty */
      l_ret_code :=UNAPISCP.Save1ScGroupKey(UNAPIEV.P_SC,
                                            a_gk, l_gk_version,
                                            l_svgk_value, l_nr_of_rows, NULL);
      IF UNAPIEV.P_EV_OUTPUT_ON THEN
         UNTRACE.LOG(
          'Save1ScGroupKey#return=' || TO_CHAR(l_ret_code) ||
          '#sc=' || UNAPIEV.P_SC ||
          '#gk=' || a_gk ||
          '#nr_of_rows=' || TO_CHAR(l_nr_of_rows));
      END IF;
      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS AND
         l_ret_code <> UNAPIGEN.DBERR_UNIQUEGK THEN
         l_sqlerrm :=
          'Save1ScGroupKey#return=' || TO_CHAR(l_ret_code) ||
          '#sc=' || UNAPIEV.P_SC ||
          '#gk=' || a_gk ||
          '#nr_of_rows=' || TO_CHAR(l_nr_of_rows);
         RAISE StpError;
      END IF;
   END IF;
   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF sqlcode <> 1 THEN
      l_sqlerrm := SUBSTR(SQLERRM,1,255);
   END IF;
   INSERT INTO uterror(client_id, applic, who, logdate, api_name, error_msg)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP,
                     'ScReleased' , l_sqlerrm );
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END ScReleased;

---------------------------------------------------------------------------------
FUNCTION ScDepartment       /* INTERNAL */
(a_gk   IN     VARCHAR2)    /* VC20_TYPE */
RETURN NUMBER
IS

l_row           INTEGER;
l_found         BOOLEAN;
l_single_valued CHAR(1);
l_new_value     VARCHAR2(40);
l_gk_version    VARCHAR2(20);

l_svgk_sc              UNAPIGEN.VC20_TABLE_TYPE;
l_svgk_gk              UNAPIGEN.VC20_TABLE_TYPE;
l_svgk_gk_version      UNAPIGEN.VC20_TABLE_TYPE;
l_svgk_value           UNAPIGEN.VC40_TABLE_TYPE;
l_svgk_description     UNAPIGEN.VC40_TABLE_TYPE;
l_svgk_is_protected    UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_value_unique    UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_single_valued   UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_new_val_allowed UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_mandatory       UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_value_list_tp   UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_dsp_rows        UNAPIGEN.NUM_TABLE_TYPE;
l_svgk_where_clause    VARCHAR2(511);

l_nr_of_rows           INTEGER;
l_nr                   INTEGER;
l_touched              BOOLEAN;
--l_debug                NUMBER;
--l_message              VARCHAR2(255);
--l_planned_executor     VARCHAR2(40);

CURSOR l_scme_cursor (a_sc VARCHAR2) IS
SELECT DISTINCT planned_executor
FROM utscme
WHERE sc = a_sc
AND ss <> '@C';

   PROCEDURE AddNewValue IS
   BEGIN
      -- Add l_new_value if not already in l_svgk_value
      l_found := FALSE;
      FOR l_row IN 1..l_nr_of_rows LOOP
         IF l_svgk_value(l_row) = l_new_value OR
            (l_svgk_value(l_row) IS NULL AND l_new_value IS NULL) THEN
            l_found := TRUE;
            EXIT;
         END IF;
      END LOOP;
      IF NOT l_found THEN
         l_nr_of_rows:= l_nr_of_rows+ 1;
         l_svgk_sc    ( l_nr_of_rows) := UNAPIEV.P_SC;
         l_svgk_gk    ( l_nr_of_rows) := a_gk;
         l_svgk_value ( l_nr_of_rows) := l_new_value;
      END IF;
   END AddNewValue;

BEGIN
   ---------------------------------------------------------------------------------------------
   -- !!!
   -- It is a good practice to check if the event matches '%GroupKeyUpdated' when an action will
   -- be used in an event rule. It enables us to avoid loops in event rules.
   -- !!!
   ---------------------------------------------------------------------------------------------
   IF UNAPIEV.P_EV_REC.ev_tp LIKE '%GroupKeyUpdated' THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;

   l_touched := FALSE;
   l_nr := 0;

   l_ret_code := UNAPISCP.GetScGroupKey (l_svgk_sc, l_svgk_gk, l_svgk_gk_version, l_svgk_value,
                       l_svgk_description,
                       l_svgk_is_protected, l_svgk_value_unique, l_svgk_single_valued,
                       l_svgk_new_val_allowed, l_svgk_mandatory, l_svgk_value_list_tp,
                       l_svgk_dsp_rows, l_nr_of_rows,
                       'WHERE sc = ''' || UNAPIEV.P_SC || ''' AND gk=''' || a_gk || '''' );
   IF UNAPIEV.P_EV_OUTPUT_ON THEN
      UNTRACE.LOG(
          'GetScGroupKey#return=' || TO_CHAR(l_ret_code) ||
          '#nr_of_rows=' || TO_CHAR(l_nr_of_rows) ||
          '#where_clause=' || 'WHERE sc = ''' || UNAPIEV.P_SC || ''' AND gk=''' || a_gk || '''');
   END IF;
   IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
      IF l_ret_code = UNAPIGEN.DBERR_NORECORDS THEN
         l_nr_of_rows:= 0;
      ELSE
         l_sqlerrm :=
          'GetScGroupKey#return=' || TO_CHAR(l_ret_code) ||
          '#nr_of_rows=' || TO_CHAR(l_nr_of_rows) ||
          '#where_clause=' || 'WHERE sc = ''' || UNAPIEV.P_SC || ''' AND gk=''' || a_gk || '''' ;
         RAISE StpError;
      END IF;
   END IF;

   IF l_nr_of_rows> 0 THEN
      l_single_valued := l_svgk_single_valued(1);
   ELSE
      SELECT single_valued
      INTO l_single_valued
      FROM utgksc
      WHERE gk = a_gk;
   END IF;

   BEGIN
      FOR l_scme_rec IN l_scme_cursor(UNAPIEV.P_SC) LOOP
          EXIT WHEN l_scme_cursor%NOTFOUND;
          l_new_value := l_scme_rec.planned_executor;
          AddNewValue;
       END LOOP;
    EXCEPTION
    WHEN OTHERS THEN
      l_new_value := NULL;
    END;

   IF UNAPIEV.P_EV_REC.ev_tp IN ('MethodCreated', 'MethodUpdated') THEN
         l_touched := TRUE;

   END IF;
   /* select distinct planned_executor from all assigned methods on the sample, ss <> @C */

   IF l_touched THEN
      /* Argument gk_version is left empty */
      l_ret_code := UNAPISCP.Save1ScGroupKey(UNAPIEV.P_SC, a_gk, l_gk_version,
                                             l_svgk_value, l_nr_of_rows, NULL);
      IF UNAPIEV.P_EV_OUTPUT_ON THEN
         UNTRACE.LOG(
                    'Save1ScGroupKey#return=' || TO_CHAR(l_ret_code) ||
                    '#sc=' || UNAPIEV.P_SC ||
                    '#gk=' || a_gk ||
                    '#nr_of_rows=' || TO_CHAR(l_nr_of_rows));
                END IF;
                IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS AND
                   l_ret_code <> UNAPIGEN.DBERR_UNIQUEGK THEN
                   l_sqlerrm :=
                    'Save1ScGroupKey#return=' || TO_CHAR(l_ret_code) ||
                    '#sc=' || UNAPIEV.P_SC ||
                    '#gk=' || a_gk ||
                    '#nr_of_rows=' || TO_CHAR(l_nr_of_rows);
            RAISE StpError;
         END IF;
      END IF;
   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF sqlcode <> 1 THEN
      l_sqlerrm := SUBSTR(SQLERRM,1,255);
   END IF;
   IF l_scme_cursor%ISOPEN THEN
     CLOSE l_scme_cursor;
   END IF;
   INSERT INTO uterror(client_id, applic, who, logdate, api_name, error_msg)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP,
                     'ScDepartment' , l_sqlerrm );
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END ScDepartment;

---------------------------------------------------------------------------------
FUNCTION ScValidation       /* INTERNAL */
(a_gk   IN     VARCHAR2)    /* VC20_TYPE */
RETURN NUMBER
IS

l_svgk_value           UNAPIGEN.VC40_TABLE_TYPE;
l_nr_of_rows           INTEGER;
l_seq_no               INTEGER;
l_touched              BOOLEAN;
l_count_pa             INTEGER;
l_planned_executor     VARCHAR2(40);
l_gk_version           VARCHAR2(20);

CURSOR l_scpa_cursor (a_sc VARCHAR2, a_pg VARCHAR2, a_pgnode NUMBER, a_pa VARCHAR2, a_panode NUMBER) IS
SELECT  DISTINCT b.planned_executor
FROM utscpa a, utscme b
WHERE a.sc = a_sc
AND a.pg = UNAPIEV.P_PG
AND a.pgnode = UNAPIEV.P_PGNODE
AND a.pa = UNAPIEV.P_PA
AND a.panode = UNAPIEV.P_PANODE
AND a.ss IN ('@C', 'CO', 'OS', 'V2')
AND a.sc = b.sc
GROUP BY  b.planned_executor;

CURSOR l_scpa_count_cursor(a_sc VARCHAR2) IS
SELECT NVL(COUNT(pa), 0)
FROM utscpa
WHERE sc = a_sc
AND ss IN ('CO','OS');

BEGIN
   ---------------------------------------------------------------------------------------------
   -- !!!
   -- It is a good practice to check if the event matches '%GroupKeyUpdated' when an action will
   -- be used in an event rule. It enables us to avoid loops in event rules.
   -- !!!
   ---------------------------------------------------------------------------------------------
   IF UNAPIEV.P_EV_REC.ev_tp LIKE '%GroupKeyUpdated' THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;

 --  l_touched := FALSE;

   l_nr_of_rows := 0;

 --  IF UNAPIEV.P_EV_REC.ev_tp IN ('PaResultUpdated') THEN
 --        l_touched := TRUE;
 --
 --  ELSE
 --     IF  UNAPIEV.P_EV_REC.ev_tp IN ('WsStatusChanged') AND UNAPIEV.P_EV_REC.object_ss = 'WV' THEN
 --        l_touched := TRUE;
 --     END IF;
 --  END IF  ;

 --  IF l_touched THEN

      OPEN l_scpa_count_cursor(UNAPIEV.P_SC);
      FETCH l_scpa_count_cursor INTO l_count_pa;
      CLOSE l_scpa_count_cursor;

      IF l_count_pa > 0 THEN
        -- OPEN l_scpa_cursor(UNAPIEV.P_SC,UNAPIEV.P_PG,UNAPIEV.P_PGNODE,
         --                            UNAPIEV.P_PA,UNAPIEV.P_PANODE);

          --  FOR l_seq_no IN 1..l_count_pa LOOP
          FOR l_scpa_rec IN l_scpa_cursor (UNAPIEV.P_SC,UNAPIEV.P_PG,UNAPIEV.P_PGNODE,
                                           UNAPIEV.P_PA,UNAPIEV.P_PANODE)    LOOP
           --    FETCH l_scpa_cursor INTO l_planned_executor;
               IF l_scpa_cursor%ROWCOUNT = 1 THEN
                  --issue a savepoint after first fetch to avoid fetch of sequence on ROLLBACK TO SAVEPOINT;
                  SAVEPOINT UNILAB4;
               END IF;
               EXIT WHEN l_scpa_cursor%NOTFOUND ;

              l_nr_of_rows := l_nr_of_rows + 1;
              l_svgk_value(l_nr_of_rows) := l_scpa_rec.planned_executor;

              /* Argument gk_version is left empty */
              l_ret_code :=UNAPISCP.Save1ScGroupKey(UNAPIEV.P_SC, a_gk, l_gk_version,
                                                    l_svgk_value, l_nr_of_rows, NULL);
                IF UNAPIEV.P_EV_OUTPUT_ON THEN
                     UNTRACE.LOG(
                      'Save1ScGroupKey#return=' || TO_CHAR(l_ret_code) ||
                      '#sc=' || UNAPIEV.P_SC ||
                      '#gk=' || a_gk ||
                      '#nr_of_rows=' || TO_CHAR(l_nr_of_rows));
                END IF;
                IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS AND
                   l_ret_code <> UNAPIGEN.DBERR_UNIQUEGK THEN
                   l_sqlerrm :=
                   'Save1ScGroupKey#return=' || TO_CHAR(l_ret_code) ||
                   '#sc=' || UNAPIEV.P_SC ||
                   '#gk=' || a_gk ||
                   '#nr_of_rows=' || TO_CHAR(l_nr_of_rows);
                   RAISE StpError;
                END IF;
            END LOOP;
      END IF;
 --  END IF;
   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF sqlcode <> 1 THEN
      l_sqlerrm := SUBSTR(SQLERRM,1,255);
   END IF;
   IF l_scpa_cursor%ISOPEN THEN
      CLOSE l_scpa_cursor;
   END IF;
   IF l_scpa_count_cursor%ISOPEN THEN
         CLOSE l_scpa_cursor;
   END IF;

   INSERT INTO uterror(client_id, applic, who, logdate, api_name, error_msg)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP,
                     'ScValidation' , l_sqlerrm );
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END ScValidation;

---------------------------------------------------------------------------------
FUNCTION RqOperational              /* INTERNAL */
(a_gk   IN     VARCHAR2)            /* VC20_TYPE */
RETURN NUMBER
IS

l_svgk_value           UNAPIGEN.VC40_TABLE_TYPE;
l_nr_of_rows           INTEGER;
l_touched              BOOLEAN;
l_gk_version           VARCHAR2(20);

BEGIN
   ---------------------------------------------------------------------------------------------
   -- !!!
   -- It is a good practice to check if the event matches '%GroupKeyUpdated' when an action will
   -- be used in an event rule. It enables us to avoid loops in event rules.
   -- !!!
   ---------------------------------------------------------------------------------------------
   IF UNAPIEV.P_EV_REC.ev_tp LIKE '%GroupKeyUpdated' THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;

   l_touched := FALSE;
   IF UNAPIEV.P_EV_REC.ev_tp = 'RequestCreated' THEN

      l_touched := TRUE;
      l_svgk_value(1) := 'Yes';
      l_nr_of_rows := 1;

   END IF;

   IF l_touched THEN
      /* Argument gk_version is left empty */
      l_ret_code := UNAPIRQP.Save1RqGroupKey(UNAPIEV.P_RQ, a_gk, l_gk_version,
                                             l_svgk_value, l_nr_of_rows, NULL);
      IF UNAPIEV.P_EV_OUTPUT_ON THEN
         UNTRACE.LOG(
          'Save1RqGroupKey#return=' || TO_CHAR(l_ret_code) ||
          '#rq=' || UNAPIEV.P_RQ ||
          '#gk=' || a_gk ||
          '#nr_of_rows=' || TO_CHAR(l_nr_of_rows));
      END IF;
      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS AND
         l_ret_code <> UNAPIGEN.DBERR_UNIQUEGK THEN
         l_sqlerrm :=
          'Save1RqGroupKey#return=' || TO_CHAR(l_ret_code) ||
          '#rq=' || UNAPIEV.P_RQ ||
          '#gk=' || a_gk ||
          '#nr_of_rows=' || TO_CHAR(l_nr_of_rows);
         RAISE StpError;
      END IF;
   END IF;
   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF sqlcode <> 1 THEN
      l_sqlerrm := SUBSTR(SQLERRM,1,255);
   END IF;
   INSERT INTO uterror(client_id, applic, who, logdate, api_name, error_msg)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP,
                     'RqOperational' , l_sqlerrm );
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END RqOperational;

---------------------------------------------------------------------------------
FUNCTION MeDepartment       /* INTERNAL */
(a_gk   IN     VARCHAR2)    /* VC20_TYPE */
RETURN NUMBER
IS

l_svgk_value           UNAPIGEN.VC40_TABLE_TYPE;
l_nr_of_rows           INTEGER;
l_touched              BOOLEAN;
--l_debug                NUMBER;
--l_message              VARCHAR2(255);
l_planned_executor     VARCHAR2(40);
l_gk_version           VARCHAR2(20);

CURSOR l_scme_cursor (a_sc VARCHAR2, a_pg VARCHAR2, a_pgnode NUMBER, a_pa VARCHAR2, a_panode NUMBER,
                      a_me VARCHAR2, a_menode NUMBER) IS
SELECT planned_executor
FROM utscme
WHERE sc = a_sc
AND pg = UNAPIEV.P_PG
AND pgnode = UNAPIEV.P_PGNODE
AND pa = UNAPIEV.P_PA
AND panode = UNAPIEV.P_PANODE
AND me = UNAPIEV.P_ME
AND menode = UNAPIEV.P_MENODE;

BEGIN
   ---------------------------------------------------------------------------------------------
   -- !!!
   -- It is a good practice to check if the event matches '%GroupKeyUpdated' when an action will
   -- be used in an event rule. It enables us to avoid loops in event rules.
   -- !!!
   ---------------------------------------------------------------------------------------------
   IF UNAPIEV.P_EV_REC.ev_tp LIKE '%GroupKeyUpdated' THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;

   l_touched := FALSE;

   IF UNAPIEV.P_EV_REC.ev_tp IN ('MethodCreated', 'MethodUpdated') THEN
         l_touched := TRUE;
         l_nr_of_rows := 1;
   END IF;


   OPEN l_scme_cursor (UNAPIEV.P_SC,
                       UNAPIEV.P_PG,UNAPIEV.P_PGNODE,
                       UNAPIEV.P_PA,UNAPIEV.P_PANODE,
                       UNAPIEV.P_ME,UNAPIEV.P_MENODE);
   FETCH l_scme_cursor INTO l_planned_executor;
   CLOSE l_scme_cursor;
      l_svgk_value(1) := l_planned_executor;


   IF l_touched THEN
      /* Argument gk_version is left empty */
      l_ret_code := UNAPIMEP.Save1ScMeGroupKey(UNAPIEV.P_SC,
                                               UNAPIEV.P_PG,UNAPIEV.P_PGNODE,
                                               UNAPIEV.P_PA,UNAPIEV.P_PANODE,
                                               UNAPIEV.P_ME,UNAPIEV.P_MENODE,
                                               a_gk, l_gk_version,
                                               l_svgk_value, l_nr_of_rows, NULL);
      IF UNAPIEV.P_EV_OUTPUT_ON THEN
         UNTRACE.LOG(
                    'Save1ScMeGroupKey#return=' || TO_CHAR(l_ret_code) ||
                    '#sc=' || UNAPIEV.P_SC ||
                    '#pg=' || UNAPIEV.P_PG || '#pgnode=' || TO_CHAR(UNAPIEV.P_PGNODE) ||
                    '#pa=' || UNAPIEV.P_PA || '#panode=' || TO_CHAR(UNAPIEV.P_PANODE) ||
                    '#me=' || UNAPIEV.P_ME || '#menode=' || TO_CHAR(UNAPIEV.P_MENODE) ||
                    '#gk=' || a_gk ||
                    '#nr_of_rows=' || TO_CHAR(l_nr_of_rows));
                END IF;
                IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS AND
                   l_ret_code <> UNAPIGEN.DBERR_UNIQUEGK THEN
                   l_sqlerrm :=
                    'Save1ScMeGroupKey#return=' || TO_CHAR(l_ret_code) ||
                    '#sc=' || UNAPIEV.P_SC ||
                    '#pg=' || UNAPIEV.P_PG || '#pgnode=' || TO_CHAR(UNAPIEV.P_PGNODE) ||
                    '#pa=' || UNAPIEV.P_PA || '#panode=' || TO_CHAR(UNAPIEV.P_PANODE) ||
                    '#me=' || UNAPIEV.P_ME || '#menode=' || TO_CHAR(UNAPIEV.P_MENODE) ||
                    '#gk=' || a_gk ||
                    '#nr_of_rows=' || TO_CHAR(l_nr_of_rows);
            RAISE StpError;
         END IF;
      END IF;
   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF sqlcode <> 1 THEN
      l_sqlerrm := SUBSTR(SQLERRM,1,255);
   END IF;
   IF l_scme_cursor%ISOPEN THEN
     CLOSE l_scme_cursor;
   END IF;
   INSERT INTO uterror(client_id, applic, who, logdate, api_name, error_msg)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP,
                     'MeDepartment' , l_sqlerrm );
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END MeDepartment;

---------------------------------------------------
/* EASY specific assign functions                */
/* cf_type = scgkassign in utcf                  */
---------------------------------------------------
FUNCTION ScMonthCreationDate
(a_gk   IN     VARCHAR2)                                  /* VC20_TYPE */
/* transforms creation_date into a YYMM entry */
RETURN NUMBER IS

l_row           INTEGER;
l_found         BOOLEAN;
l_sub_row       INTEGER;
l_single_valued CHAR(1);
l_touched       BOOLEAN;
l_new_value     VARCHAR2(40);
l_gk_version    VARCHAR2(20);

l_svgk_sc              UNAPIGEN.VC20_TABLE_TYPE;
l_svgk_gk              UNAPIGEN.VC20_TABLE_TYPE;
l_svgk_value           UNAPIGEN.VC40_TABLE_TYPE;
l_svgk_description     UNAPIGEN.VC40_TABLE_TYPE;
l_svgk_is_protected    UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_value_unique    UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_single_valued   UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_new_val_allowed UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_mandatory       UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_value_list_tp   UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_dsp_rows        UNAPIGEN.NUM_TABLE_TYPE;
l_nr_of_rows           INTEGER;
l_svgk_where_clause    VARCHAR2(511);

CURSOR l_cursor_start_date (a_sc IN VARCHAR2) IS
      SELECT TO_CHAR(creation_date,'MM')
      FROM UTSC
      WHERE sc = UNAPIEV.P_SC;

BEGIN

   ---------------------------------------------------------------------------------------------
   -- !!!
   -- It is a good practice to check if the event matches '%GroupKeyUpdated' when an action will
   -- be used in an event rule. It enables us to avoid loops in event rules.
   -- !!!
   ---------------------------------------------------------------------------------------------
   IF UNAPIEV.P_EV_REC.ev_tp LIKE '%GroupKeyUpdated' THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;

   l_nr_of_rows:= 0;
   l_touched := FALSE;

   l_found := TRUE;
   OPEN l_cursor_start_date(UNAPIEV.P_SC);
   FETCH l_cursor_start_date
   INTO l_new_value;
   IF l_cursor_start_date%NOTFOUND THEN
      l_found := FALSE;
   END IF;
   CLOSE l_cursor_start_date;

   IF l_found THEN
      IF UNAPIEV.P_EV_REC.ev_tp = 'SampleCreated' THEN
         l_touched := TRUE;

         l_svgk_value(1) := l_new_value;
         l_nr_of_rows := 1;
      END IF;

      IF l_touched THEN
         /* Argument gk_version is left empty */
         l_ret_code := Unapiscp.Save1ScGroupKey(UNAPIEV.P_SC, a_gk, l_gk_version,
                                                l_svgk_value, l_nr_of_rows, NULL);
            IF UNAPIEV.P_EV_OUTPUT_ON THEN
               Untrace.LOG(
                  'Save1ScGroupKey#return=' || TO_CHAR(l_ret_code) ||
                  '#sc=' || UNAPIEV.P_SC ||
                  '#gk=' || a_gk ||
                  '#nr_of_rows=' || TO_CHAR(l_nr_of_rows));
            END IF;
         IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS AND
            l_ret_code <> UNAPIGEN.DBERR_UNIQUEGK THEN
            l_sqlerrm :=
             'Save1ScGroupKey#return=' || TO_CHAR(l_ret_code) ||
             '#sc=' || UNAPIEV.P_SC ||
             '#gk=' || a_gk ||
             '#nr_of_rows=' || TO_CHAR(l_nr_of_rows);
            RAISE StpError;
         END IF;
      END IF;
   END IF;
   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      l_sqlerrm := SUBSTR(SQLERRM,1,255);
   END IF;
   INSERT INTO uterror(client_id, applic, who, logdate, api_name, error_msg)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP,
                     'ScMonthCreationDate' , l_sqlerrm );

   RETURN(UNAPIGEN.DBERR_GENFAIL);
END ScMonthCreationDate;

---------------------------------------------------------------------------------
FUNCTION ScWeekCreationDate
(a_gk   IN     VARCHAR2)                                  /* VC20_TYPE */
/* transforms creation_date into a YYWW entry */
RETURN NUMBER IS

l_row           INTEGER;
l_found         BOOLEAN;
l_sub_row       INTEGER;
l_single_valued CHAR(1);
l_touched       BOOLEAN;
l_new_value     VARCHAR2(40);
l_gk_version    VARCHAR2(20);

l_svgk_sc              UNAPIGEN.VC20_TABLE_TYPE;
l_svgk_gk              UNAPIGEN.VC20_TABLE_TYPE;
l_svgk_value           UNAPIGEN.VC40_TABLE_TYPE;
l_svgk_description     UNAPIGEN.VC40_TABLE_TYPE;
l_svgk_is_protected    UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_value_unique    UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_single_valued   UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_new_val_allowed UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_mandatory       UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_value_list_tp   UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_dsp_rows        UNAPIGEN.NUM_TABLE_TYPE;
l_nr_of_rows           INTEGER;
l_svgk_where_clause    VARCHAR2(511);

CURSOR l_cursor_start_date (a_sc IN VARCHAR2) IS
      SELECT TO_CHAR(creation_date,'YYWW')
      FROM UTSC
      WHERE sc = UNAPIEV.P_SC;

BEGIN

   ---------------------------------------------------------------------------------------------
   -- !!!
   -- It is a good practice to check if the event matches '%GroupKeyUpdated' when an action will
   -- be used in an event rule. It enables us to avoid loops in event rules.
   -- !!!
   ---------------------------------------------------------------------------------------------
   IF UNAPIEV.P_EV_REC.ev_tp LIKE '%GroupKeyUpdated' THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;

   l_nr_of_rows:= 0;
   l_touched := FALSE;

   l_found := TRUE;
   OPEN l_cursor_start_date(UNAPIEV.P_SC);
   FETCH l_cursor_start_date
   INTO l_new_value;
   IF l_cursor_start_date%NOTFOUND THEN
      l_found := FALSE;
   END IF;
   CLOSE l_cursor_start_date;

   IF l_found THEN
      IF UNAPIEV.P_EV_REC.ev_tp = 'SampleCreated' THEN
         l_touched := TRUE;

         l_svgk_value(1) := l_new_value;
         l_nr_of_rows := 1;
      END IF;

      IF l_touched THEN
         /* Argument gk_version is left empty */
         l_ret_code := Unapiscp.Save1ScGroupKey(UNAPIEV.P_SC, a_gk, l_gk_version,
                                       l_svgk_value, l_nr_of_rows, NULL);
            IF UNAPIEV.P_EV_OUTPUT_ON THEN
               Untrace.LOG(
                  'Save1ScGroupKey#return=' || TO_CHAR(l_ret_code) ||
                  '#sc=' || UNAPIEV.P_SC ||
                  '#gk=' || a_gk ||
                  '#nr_of_rows=' || TO_CHAR(l_nr_of_rows));
            END IF;
         IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS AND
            l_ret_code <> UNAPIGEN.DBERR_UNIQUEGK THEN
            l_sqlerrm :=
             'Save1ScGroupKey#return=' || TO_CHAR(l_ret_code) ||
             '#sc=' || UNAPIEV.P_SC ||
             '#gk=' || a_gk ||
             '#nr_of_rows=' || TO_CHAR(l_nr_of_rows);
            RAISE StpError;
         END IF;
      END IF;
   END IF;
   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      l_sqlerrm := SUBSTR(SQLERRM,1,255);
   END IF;
   INSERT INTO uterror(client_id, applic, who, logdate, api_name, error_msg)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP,
                     'ScWeekCreationDate' , l_sqlerrm );

   RETURN(UNAPIGEN.DBERR_GENFAIL);
END ScWeekCreationDate;

---------------------------------------------------------------------------------
FUNCTION ScYearCreationDate
(a_gk   IN     VARCHAR2)                                  /* VC20_TYPE */
/* transforms creation_date into a YY entry */
RETURN NUMBER IS

l_row           INTEGER;
l_found         BOOLEAN;
l_sub_row       INTEGER;
l_single_valued CHAR(1);
l_touched       BOOLEAN;
l_new_value     VARCHAR2(40);
l_gk_version    VARCHAR2(20);

l_svgk_sc              UNAPIGEN.VC20_TABLE_TYPE;
l_svgk_gk              UNAPIGEN.VC20_TABLE_TYPE;
l_svgk_value           UNAPIGEN.VC40_TABLE_TYPE;
l_svgk_description     UNAPIGEN.VC40_TABLE_TYPE;
l_svgk_is_protected    UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_value_unique    UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_single_valued   UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_new_val_allowed UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_mandatory       UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_value_list_tp   UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_dsp_rows        UNAPIGEN.NUM_TABLE_TYPE;
l_nr_of_rows           INTEGER;
l_svgk_where_clause    VARCHAR2(511);

CURSOR l_cursor_start_date (a_sc IN VARCHAR2) IS
      SELECT TO_CHAR(creation_date,'YY')
      FROM UTSC
      WHERE sc = UNAPIEV.P_SC;

BEGIN

   ---------------------------------------------------------------------------------------------
   -- !!!
   -- It is a good practice to check if the event matches '%GroupKeyUpdated' when an action will
   -- be used in an event rule. It enables us to avoid loops in event rules.
   -- !!!
   ---------------------------------------------------------------------------------------------
   IF UNAPIEV.P_EV_REC.ev_tp LIKE '%GroupKeyUpdated' THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;

   l_nr_of_rows:= 0;
   l_touched := FALSE;

   l_found := TRUE;
   OPEN l_cursor_start_date(UNAPIEV.P_SC);
   FETCH l_cursor_start_date
   INTO l_new_value;
   IF l_cursor_start_date%NOTFOUND THEN
      l_found := FALSE;
   END IF;
   CLOSE l_cursor_start_date;

   IF l_found THEN
      IF UNAPIEV.P_EV_REC.ev_tp = 'SampleCreated' THEN
         l_touched := TRUE;

         l_svgk_value(1) := l_new_value;
         l_nr_of_rows := 1;
      END IF;

      IF l_touched THEN
         /* Argument gk_version is left empty */
         l_ret_code := Unapiscp.Save1ScGroupKey(UNAPIEV.P_SC, a_gk, l_gk_version,
                                                l_svgk_value, l_nr_of_rows, NULL);
            IF UNAPIEV.P_EV_OUTPUT_ON THEN
               Untrace.LOG(
                  'Save1ScGroupKey#return=' || TO_CHAR(l_ret_code) ||
                  '#sc=' || UNAPIEV.P_SC ||
                  '#gk=' || a_gk ||
                  '#nr_of_rows=' || TO_CHAR(l_nr_of_rows));
            END IF;
         IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS AND
            l_ret_code <> UNAPIGEN.DBERR_UNIQUEGK THEN
            l_sqlerrm :=
             'Save1ScGroupKey#return=' || TO_CHAR(l_ret_code) ||
             '#sc=' || UNAPIEV.P_SC ||
             '#gk=' || a_gk ||
             '#nr_of_rows=' || TO_CHAR(l_nr_of_rows);
            RAISE StpError;
         END IF;
      END IF;
   END IF;
   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      l_sqlerrm := SUBSTR(SQLERRM,1,255);
   END IF;
   INSERT INTO uterror(client_id, applic, who, logdate, api_name, error_msg)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP,
                     'ScYearCreationDate' , l_sqlerrm );

   RETURN(UNAPIGEN.DBERR_GENFAIL);
END ScYearCreationDate;

---------------------------------------------------------------------------------
FUNCTION ScDayCreationDate
(a_gk   IN     VARCHAR2)                                  /* VC20_TYPE */
/* transforms creation_date into a DD entry */
RETURN NUMBER IS

l_row           INTEGER;
l_found         BOOLEAN;
l_sub_row       INTEGER;
l_single_valued CHAR(1);
l_touched       BOOLEAN;
l_new_value     VARCHAR2(40);
l_gk_version    VARCHAR2(20);

l_svgk_sc              UNAPIGEN.VC20_TABLE_TYPE;
l_svgk_gk              UNAPIGEN.VC20_TABLE_TYPE;
l_svgk_value           UNAPIGEN.VC40_TABLE_TYPE;
l_svgk_description     UNAPIGEN.VC40_TABLE_TYPE;
l_svgk_is_protected    UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_value_unique    UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_single_valued   UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_new_val_allowed UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_mandatory       UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_value_list_tp   UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_dsp_rows        UNAPIGEN.NUM_TABLE_TYPE;
l_nr_of_rows           INTEGER;
l_svgk_where_clause    VARCHAR2(511);

CURSOR l_cursor_start_date (a_sc IN VARCHAR2) IS
      SELECT TO_CHAR(creation_date,'DD')
      FROM UTSC
      WHERE sc = UNAPIEV.P_SC;

BEGIN

   ---------------------------------------------------------------------------------------------
   -- !!!
   -- It is a good practice to check if the event matches '%GroupKeyUpdated' when an action will
   -- be used in an event rule. It enables us to avoid loops in event rules.
   -- !!!
   ---------------------------------------------------------------------------------------------
   IF UNAPIEV.P_EV_REC.ev_tp LIKE '%GroupKeyUpdated' THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;

   l_nr_of_rows:= 0;
   l_touched := FALSE;

   l_found := TRUE;
   OPEN l_cursor_start_date(UNAPIEV.P_SC);
   FETCH l_cursor_start_date
   INTO l_new_value;
   IF l_cursor_start_date%NOTFOUND THEN
      l_found := FALSE;
   END IF;
   CLOSE l_cursor_start_date;

   IF l_found THEN
      IF UNAPIEV.P_EV_REC.ev_tp = 'SampleCreated' THEN
         l_touched := TRUE;

         l_svgk_value(1) := l_new_value;
         l_nr_of_rows := 1;
      END IF;

      IF l_touched THEN
         /* Argument gk_version is left empty */
         l_ret_code := Unapiscp.Save1ScGroupKey(UNAPIEV.P_SC, a_gk, l_gk_version,
                                                l_svgk_value, l_nr_of_rows, NULL);
            IF UNAPIEV.P_EV_OUTPUT_ON THEN
               Untrace.LOG(
                  'Save1ScGroupKey#return=' || TO_CHAR(l_ret_code) ||
                  '#sc=' || UNAPIEV.P_SC ||
                  '#gk=' || a_gk ||
                  '#nr_of_rows=' || TO_CHAR(l_nr_of_rows));
            END IF;
         IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS AND
            l_ret_code <> UNAPIGEN.DBERR_UNIQUEGK THEN
            l_sqlerrm :=
             'Save1ScGroupKey#return=' || TO_CHAR(l_ret_code) ||
             '#sc=' || UNAPIEV.P_SC ||
             '#gk=' || a_gk ||
             '#nr_of_rows=' || TO_CHAR(l_nr_of_rows);
            RAISE StpError;
         END IF;
      END IF;
   END IF;
   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      l_sqlerrm := SUBSTR(SQLERRM,1,255);
   END IF;
   INSERT INTO uterror(client_id, applic, who, logdate, api_name, error_msg)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP,
                     'ScDayCreationDate' , l_sqlerrm );

   RETURN(UNAPIGEN.DBERR_GENFAIL);
END ScDayCreationDate;

---------------------------------------------------------------------------------
FUNCTION MeAssignWorkDay
(a_gk   IN     VARCHAR2)                                  /* VC20_TYPE */
/* transforms assign_date into a YYMMDD entry */
RETURN NUMBER IS

l_row           INTEGER;
l_found         BOOLEAN;
l_sub_row       INTEGER;
l_single_valued CHAR(1);
l_touched       BOOLEAN;
l_new_value     VARCHAR2(40);
l_gk_version    VARCHAR2(20);

l_svgk_sc              UNAPIGEN.VC20_TABLE_TYPE;
l_svgk_gk              UNAPIGEN.VC20_TABLE_TYPE;
l_svgk_value           UNAPIGEN.VC40_TABLE_TYPE;
l_svgk_description     UNAPIGEN.VC40_TABLE_TYPE;
l_svgk_is_protected    UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_value_unique    UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_single_valued   UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_new_val_allowed UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_mandatory       UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_value_list_tp   UNAPIGEN.CHAR1_TABLE_TYPE;
l_svgk_dsp_rows        UNAPIGEN.NUM_TABLE_TYPE;
l_nr_of_rows           INTEGER;
l_svgk_where_clause    VARCHAR2(511);

CURSOR l_cursor_start_date (a_sc IN VARCHAR2, a_pg IN VARCHAR2, a_pgnode IN NUMBER, a_pa IN VARCHAR2,
                            a_panode IN NUMBER, a_me IN VARCHAR2, a_menode IN NUMBER) IS
      SELECT TO_CHAR(assign_date,'YYYYMMDD')
      FROM UTSCME
      WHERE sc = UNAPIEV.P_SC
     AND pg = UNAPIEV.P_PG
  AND pgnode = UNAPIEV.P_PGNODE
  AND pa = UNAPIEV.P_PA
  AND panode = UNAPIEV.P_PANODE
  AND me = UNAPIEV.P_ME
  AND menode = UNAPIEV.P_MENODE;

BEGIN

   ---------------------------------------------------------------------------------------------
   -- !!!
   -- It is a good practice to check if the event matches '%GroupKeyUpdated' when an action will
   -- be used in an event rule. It enables us to avoid loops in event rules.
   -- !!!
   ---------------------------------------------------------------------------------------------
   IF UNAPIEV.P_EV_REC.ev_tp LIKE '%GroupKeyUpdated' THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;

   l_nr_of_rows:= 0;
   l_touched := FALSE;

   l_found := TRUE;
   OPEN l_cursor_start_date(UNAPIEV.P_SC,UNAPIEV.P_PG, UNAPIEV.P_PGNODE , UNAPIEV.P_PA, UNAPIEV.P_PANODE,
                            UNAPIEV.P_ME, UNAPIEV.P_MENODE);
   FETCH l_cursor_start_date
   INTO l_new_value;
   IF l_cursor_start_date%NOTFOUND THEN
      l_found := FALSE;
   END IF;
   CLOSE l_cursor_start_date;

   IF l_found THEN
      IF UNAPIEV.P_EV_REC.ev_tp = 'MethodCreated' THEN

         l_touched := TRUE;

         l_svgk_value(1) := l_new_value;
         l_nr_of_rows := 1;

      END IF;

      IF l_touched THEN
         /* Argument gk_version is left empty */
         l_ret_code := Unapimep.Save1ScMeGroupKey(UNAPIEV.P_SC,UNAPIEV.P_PG, UNAPIEV.P_PGNODE ,
                                                  UNAPIEV.P_PA, UNAPIEV.P_PANODE,
                                                  UNAPIEV.P_ME, UNAPIEV.P_MENODE,
                                                  a_gk, l_gk_version,
                                                  l_svgk_value, l_nr_of_rows, NULL);
            IF UNAPIEV.P_EV_OUTPUT_ON THEN
               Untrace.LOG(
                  'Save1ScMeGroupKey#return=' || TO_CHAR(l_ret_code) ||
                  '#sc=' || UNAPIEV.P_SC ||
                  '#pg=' || UNAPIEV.P_PG ||
                  '#pgnode=' || UNAPIEV.P_PGNODE ||
                  '#pa=' || UNAPIEV.P_PA ||
                  '#panode=' || UNAPIEV.P_PANODE ||
                  '#me=' || UNAPIEV.P_ME ||
                  '#menode=' || UNAPIEV.P_MENODE ||
                  '#gk=' || a_gk ||
                  '#nr_of_rows=' || TO_CHAR(l_nr_of_rows));
            END IF;
         IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS AND
            l_ret_code <> UNAPIGEN.DBERR_UNIQUEGK THEN
            l_sqlerrm :=
             'Save1ScMeGroupKey#return=' || TO_CHAR(l_ret_code) ||
             '#sc=' || UNAPIEV.P_SC ||
             '#pg=' || UNAPIEV.P_PG ||
             '#pgnode=' || UNAPIEV.P_PGNODE ||
             '#pa=' || UNAPIEV.P_PA ||
             '#panode=' || UNAPIEV.P_PANODE ||
             '#me=' || UNAPIEV.P_ME ||
             '#menode=' || UNAPIEV.P_MENODE ||
             '#gk=' || a_gk ||
             '#nr_of_rows=' || TO_CHAR(l_nr_of_rows);
            RAISE StpError;
         END IF;
      END IF;
   END IF;
   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      l_sqlerrm := SUBSTR(SQLERRM,1,255);
   END IF;
   INSERT INTO uterror(client_id, applic, who, logdate, api_name, error_msg)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP,
                     'MeAssignWorkDay' , l_sqlerrm );
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END MeAssignWorkDay;

FUNCTION SdAssignScGroupKeys
RETURN NUMBER IS
l_sd            VARCHAR2(20);
l_sc            VARCHAR2(20);
l_cs            VARCHAR2(20);
l_gk            VARCHAR2(20);
l_gk_version    VARCHAR2(20);
l_csnode        NUMBER;
l_value_tab     UNAPIGEN.VC40_TABLE_TYPE;
l_nr_of_rows    NUMBER;
l_modify_reason VARCHAR2(255);

CURSOR l_sdcscn_cursor(c_sd VARCHAR2, c_csnode NUMBER) IS
    SELECT cn, value, cs
    FROM utsdcscn
    WHERE sd = c_sd
      AND csnode =c_csnode
      AND cn IN (SELECT gk FROM utgksc);

BEGIN

l_sd :=  UNAPIEV.P_SD;
l_sc :=  UNAPIEV.P_SC;
l_csnode:=  UNAPIEV.P_CSNODE;
FOR l_sdcscn_rec IN  l_sdcscn_cursor(l_sd, l_csnode) LOOP
   IF l_sdcscn_cursor%ROWCOUNT = 1 THEN
      --issue a savepoint after first fetch to avoid fetch of sequence on ROLLBACK TO SAVEPOINT;
      SAVEPOINT UNILAB4;
   END IF;
   l_gk := l_sdcscn_rec.cn;
   l_gk_version := NULL;
   IF UNAPIEV.P_EV_REC.ev_tp = 'SdCellSampleAdded' THEN
      l_value_tab(1) :=  l_sdcscn_rec.value;
      l_nr_of_rows := 1;
      l_modify_reason := 'Groupkey is added or modified since the sample is added in study "'||
                         l_sd||'" on the row with condition set "'|| l_sdcscn_rec.cs ||'".';
   ELSE
      l_nr_of_rows := 0;
      l_modify_reason := 'Groupkey is deleted since the sample is removed from study "'||
                         l_sd||'" on the row with condition set "'|| l_sdcscn_rec.cs ||'".';
   END IF;
   l_ret_code:= UNAPISCP.Save1ScGroupKey
                   (l_sc,
                    l_gk,
                    l_gk_version,
                    l_value_tab,
                    l_nr_of_rows,
                    l_modify_reason);
END LOOP;

RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
    IF sqlcode <> 1 THEN
       UNAPIGEN.LogError('SdAssignScGroupKeys', sqlerrm);
    ELSIF l_sqlerrm IS NOT NULL THEN
       UNAPIGEN.LogError('SdAssignScGroupKeys', l_sqlerrm);
    END IF;
    RETURN(UNAPIGEN.DBERR_GENFAIL);
END SdAssignScGroupKeys;

FUNCTION ScCreateCnGroupKeys
RETURN NUMBER IS

l_cs            VARCHAR2(20);
l_nr_of_rows    NUMBER;
l_modify_reason VARCHAR2(255);

/* Arguments for UNAPIGK.SaveGroupKeySc */
l_gk                  VARCHAR2(20);
l_description         VARCHAR2(40);
l_is_protected        CHAR(1);
l_value_unique        CHAR(1);
l_single_valued       CHAR(1);
l_new_val_allowed     CHAR(1);
l_mandatory           CHAR(1);
l_struct_created      CHAR(1);
l_inherit_gk          CHAR(1);
l_value_list_tp       CHAR(1);
l_default_value       VARCHAR2(40);
l_dsp_rows            NUMBER;
l_val_length          NUMBER;
l_val_start           NUMBER;
l_assign_tp           CHAR(1);
l_assign_id           VARCHAR2(20);
l_q_tp                CHAR(1);
l_q_id                VARCHAR2(20);
l_q_check_au          CHAR(1);
l_q_au                VARCHAR2(20);
l_value               UNAPIGEN.VC40_TABLE_TYPE;
l_sqltext             UNAPIGEN.VC255_TABLE_TYPE;


CURSOR l_cscn_cursor(c_cs VARCHAR2) IS
    SELECT cn
    FROM utcscn
    WHERE cs = c_cs
    AND cn NOT IN (SELECT gk FROM utgksc);

   --Internal function checking the Oracle naming conventions
   /*-------------------------------------------------------------------------*/
   /* naming conventions for user should be followed                          */
   /* group key should only contain alphanumeric characters and underscore(s) */
   /*-------------------------------------------------------------------------*/
   FUNCTION NameIsOkForOracle
   (a_name2check IN VARCHAR2)
   RETURN BOOLEAN IS
   l_pos                   INTEGER;
   l_char                  CHAR(1);
   l_ascii                 INTEGER;
   BEGIN
      FOR l_pos IN 1..LENGTH(a_name2check) LOOP
         l_char := UPPER(SUBSTR(a_name2check, l_pos, 1));
         l_ascii := ASCII(l_char);
         IF (l_ascii  >=65 and l_ascii <=90) OR -- A->Z
            (l_ascii  >=48 and l_ascii <=57) OR -- 0->9
             l_ascii = 95 THEN                  -- underscore
             NULL;
          ELSE
             RETURN(FALSE);
          END IF;
      END LOOP;
      RETURN(TRUE);
   END NameIsOkForOracle;

BEGIN

l_cs :=  UNAPIEV.P_EV_REC.object_id;
FOR l_cscn_rec IN  l_cscn_cursor(l_cs) LOOP
   IF l_cscn_cursor%ROWCOUNT = 1 THEN
      --issue a savepoint after first fetch to avoid fetch of sequence on ROLLBACK TO SAVEPOINT;
      SAVEPOINT UNILAB4;
   END IF;
   l_gk := l_cscn_rec.cn;

   IF NameIsOkForOracle(l_gk) = FALSE THEN
      UNAPIGEN.LogError('ScCreateCnGroupKeys', 'Condition Name '||l_gk||'is not compliant with Oracle. No sample group key created!' );
   ELSE
      /*-------------------------------------------------------------*/
      /*--------------------- Arguments -----------------------------*/
      /*-------------------------------------------------------------*/
      l_nr_of_rows :=  0;
      l_description := l_cscn_rec.cn;
      l_is_protected := '1';
      l_value_unique := '0';
      l_single_valued := '1';
      l_new_val_allowed := '0';
      l_mandatory := '1';
      l_struct_created := '0';
      l_inherit_gk := '0';
      l_value_list_tp := 'F';
      l_default_value := '';
      l_dsp_rows := 8;
      l_val_length := 10;
      l_val_start := 6;
      l_assign_tp := '';
      l_assign_id := '';
      l_q_tp := '';
      l_q_id := '';
      l_q_check_au := '';
      l_q_au := '';
      l_value( 1) := '';
      l_sqltext( 1) := '';
      l_modify_reason := 'Condition set condition created as sample group key';

      /*-------------------------------------------------------------*/
      /*------------------- Function Call ---------------------------*/
      /*-------------------------------------------------------------*/
      l_ret_code := UNAPIGK.SaveGroupKeySc(
                       l_gk,
                       l_description,
                       l_is_protected,
                       l_value_unique,
                       l_single_valued,
                       l_new_val_allowed,
                       l_mandatory,
                       l_struct_created,
                       l_inherit_gk,
                       l_value_list_tp,
                       l_default_value,
                       l_dsp_rows,
                       l_val_length,
                       l_val_start,
                       l_assign_tp,
                       l_assign_id,
                       l_q_tp,
                       l_q_id,
                       l_q_check_au,
                       l_q_au,
                       l_value,
                       l_sqltext,
                       l_nr_of_rows,
                       l_modify_reason);

      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.LogError('ScCreateCnGroupKeys',
                           'SaveGroupKeySc#ret_code='||l_ret_code||'gk='||l_gk);
      ELSE
         --create the group key structures
         l_ret_code := UNAPIGK.CreateGroupKeyScStructures(l_gk, NULL, NULL, NULL, NULL, NULL, NULL);
         IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
            UNAPIGEN.LogError('ScCreateCnGroupKeys',
                              'CreateGroupKeyScStructures#ret_code='||l_ret_code||'gk='||l_gk);
         END IF;
      END IF;
   END IF;
END LOOP;

RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
    IF sqlcode <> 1 THEN
       UNAPIGEN.LogError('ScCreateCnGroupKeys', sqlerrm);
    ELSIF l_sqlerrm IS NOT NULL THEN
       UNAPIGEN.LogError('ScCreateCnGroupKeys', l_sqlerrm);
    END IF;
    RETURN(UNAPIGEN.DBERR_GENFAIL);
END ScCreateCnGroupKeys;


---------------------------------------------------------------------------------
FUNCTION AssignRoles              /* INTERNAL */
(a_gk   IN     VARCHAR2)              /* VC20_TYPE */
RETURN NUMBER
IS

   lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := 'UNGKASSIGN.AssignRoles';
   lvb_touched                BOOLEAN;
   lvi_step                   INTEGER;
   lvi_nr_of_rows             INTEGER := 0;
   lvi_ret_code               INTEGER;
   lvs_gk_version             UTGKME.version%TYPE;
   lvt_value_tab              UNAPIGEN.VC40_TABLE_TYPE;


BEGIN
   ---------------------------------------------------------------------------------------------
   -- !!!
   -- It is a good practice to check if the event matches '%GroupKeyUpdated' when an action will
   -- be used in an event rule. It enables us to avoid loops in event rules.
   -- !!!
   ---------------------------------------------------------------------------------------------
   IF UNAPIEV.P_EV_REC.ev_tp LIKE '%GroupKeyUpdated' THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;

   lvb_touched := FALSE;
   IF UNAPIEV.P_EV_REC.ev_tp = 'MethodCreated' THEN

      lvb_touched := TRUE;
      FOR r IN (SELECT executor AS role
                FROM utmt
                WHERE mt = UNAPIEV.P_ME
                  AND version_is_current = 1
                UNION
                SELECT value AS role
                FROM utadau
                WHERE au = 'parent_role'
                  AND ad IN (SELECT executor AS role
                             FROM utmt
                             WHERE mt = UNAPIEV.P_ME
                               AND version_is_current = 1)) LOOP
         lvi_nr_of_rows := lvi_nr_of_rows + 1;
         lvt_value_tab (lvi_nr_of_rows) := r.role;
      END LOOP;

   ELSIF UNAPIEV.P_EV_REC.ev_tp = 'MethodDeleted' THEN

      lvb_touched := TRUE;
      lvi_nr_of_rows := 0;
   END IF;

   IF lvb_touched THEN
      /* Argument gk_version is left empty */
      l_ret_code := UNAPIMEP.Save1ScMeGroupKey (UNAPIEV.P_SC,
                                                UNAPIEV.P_PG,UNAPIEV.P_PGNODE,
                                                UNAPIEV.P_PA,UNAPIEV.P_PANODE,
                                                UNAPIEV.P_ME,UNAPIEV.P_MENODE,
                                                a_gk, lvs_gk_version,
                                                lvt_value_tab, lvi_nr_of_rows, NULL);
      IF UNAPIEV.P_EV_OUTPUT_ON THEN
         UNTRACE.LOG(
          'Save1ScMeGroupKey#return=' || TO_CHAR(l_ret_code) ||
          '#sc=' || UNAPIEV.P_SC ||
          '#pg=' || UNAPIEV.P_PG || '#pgnode=' || TO_CHAR(UNAPIEV.P_PGNODE) ||
          '#pa=' || UNAPIEV.P_PA || '#panode=' || TO_CHAR(UNAPIEV.P_PANODE) ||
          '#me=' || UNAPIEV.P_ME || '#menode=' || TO_CHAR(UNAPIEV.P_MENODE) ||
          '#gk=' || a_gk ||
          '#nr_of_rows=' || TO_CHAR(lvi_nr_of_rows));
      END IF;
      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS AND
         l_ret_code <> UNAPIGEN.DBERR_UNIQUEGK THEN
         l_sqlerrm :=
          'Save1ScMeGroupKey#return=' || TO_CHAR(l_ret_code) ||
          '#sc=' || UNAPIEV.P_SC ||
          '#pg=' || UNAPIEV.P_PG || '#pgnode=' || TO_CHAR(UNAPIEV.P_PGNODE) ||
          '#pa=' || UNAPIEV.P_PA || '#panode=' || TO_CHAR(UNAPIEV.P_PANODE) ||
          '#me=' || UNAPIEV.P_ME || '#menode=' || TO_CHAR(UNAPIEV.P_MENODE) ||
          '#gk=' || a_gk ||
          '#nr_of_rows=' || TO_CHAR(lvi_nr_of_rows);
         RAISE StpError;
      END IF;
   END IF;
   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF sqlcode <> 1 THEN
      l_sqlerrm := SUBSTR(SQLERRM,1,255);
   END IF;
   INSERT INTO uterror(client_id, applic, who, logdate, api_name, error_msg)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP,
                     lcs_function_name, l_sqlerrm );
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END AssignRoles;

---------------------------------------------------------------------------------
--Customisation code ERULG011A
--Change log: CR1 06/07/2016. Changed from "role" to "User_group" by HvB
--FUNCTION AssignRoles
------
----           /* INTERNAL */
FUNCTION AssignMeGkUserGroup          /* CR1 INTERNAL */
(a_gk   IN     VARCHAR2)              /* VC20_TYPE */
RETURN NUMBER
IS

--CR1 lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := 'UNGKASSIGN.AssignRoles';
   lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := 'UNGKASSIGN.AssignMeGkUserGroup';
   lvb_touched                BOOLEAN;
   lvi_step                   INTEGER;
   lvi_nr_of_rows             INTEGER := 0;
   lvi_ret_code               INTEGER;
   lvs_gk_version             UTGKME.version%TYPE;
   lvt_value_tab              UNAPIGEN.VC40_TABLE_TYPE;


BEGIN
   ---------------------------------------------------------------------------------------------
   -- !!!
   -- It is a good practice to check if the event matches '%GroupKeyUpdated' when an action will
   -- be used in an event rule. It enables us to avoid loops in event rules.
   -- !!!
   ---------------------------------------------------------------------------------------------
   IF UNAPIEV.P_EV_REC.ev_tp LIKE '%GroupKeyUpdated' THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;

   lvb_touched := FALSE;
   IF UNAPIEV.P_EV_REC.ev_tp = 'MethodCreated' THEN

      lvb_touched := TRUE;
      FOR r IN (SELECT executor AS user_group /*CR1 role*/
                FROM utmt
                WHERE mt = UNAPIEV.P_ME
                  AND version_is_current = 1
                UNION
                SELECT value AS user_group /*CR1 role*/
                FROM utadau
                WHERE au = 'parent_group' /*CR1 'parent_role' role*/
                  AND ad IN (SELECT executor AS user_group /*CR1 role*/
                             FROM utmt
                             WHERE mt = UNAPIEV.P_ME
                               AND version_is_current = 1)) LOOP
         lvi_nr_of_rows := lvi_nr_of_rows + 1;
         lvt_value_tab (lvi_nr_of_rows) := r.user_group; /*CR1 r.role*/
      END LOOP;

   ELSIF UNAPIEV.P_EV_REC.ev_tp = 'MethodDeleted' THEN

      lvb_touched := TRUE;
      lvi_nr_of_rows := 0;
   END IF;

   IF lvb_touched THEN
      /* Argument gk_version is left empty */
      l_ret_code := UNAPIMEP.Save1ScMeGroupKey (UNAPIEV.P_SC,
                                                UNAPIEV.P_PG,UNAPIEV.P_PGNODE,
                                                UNAPIEV.P_PA,UNAPIEV.P_PANODE,
                                                UNAPIEV.P_ME,UNAPIEV.P_MENODE,
                                                a_gk, lvs_gk_version,
                                                lvt_value_tab, lvi_nr_of_rows, NULL);
      IF UNAPIEV.P_EV_OUTPUT_ON THEN
         UNTRACE.LOG(
          'Save1ScMeGroupKey#return=' || TO_CHAR(l_ret_code) ||
          '#sc=' || UNAPIEV.P_SC ||
          '#pg=' || UNAPIEV.P_PG || '#pgnode=' || TO_CHAR(UNAPIEV.P_PGNODE) ||
          '#pa=' || UNAPIEV.P_PA || '#panode=' || TO_CHAR(UNAPIEV.P_PANODE) ||
          '#me=' || UNAPIEV.P_ME || '#menode=' || TO_CHAR(UNAPIEV.P_MENODE) ||
          '#gk=' || a_gk ||
          '#nr_of_rows=' || TO_CHAR(lvi_nr_of_rows));
      END IF;
      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS AND
         l_ret_code <> UNAPIGEN.DBERR_UNIQUEGK THEN
         l_sqlerrm :=
          'Save1ScMeGroupKey#return=' || TO_CHAR(l_ret_code) ||
          '#sc=' || UNAPIEV.P_SC ||
          '#pg=' || UNAPIEV.P_PG || '#pgnode=' || TO_CHAR(UNAPIEV.P_PGNODE) ||
          '#pa=' || UNAPIEV.P_PA || '#panode=' || TO_CHAR(UNAPIEV.P_PANODE) ||
          '#me=' || UNAPIEV.P_ME || '#menode=' || TO_CHAR(UNAPIEV.P_MENODE) ||
          '#gk=' || a_gk ||
          '#nr_of_rows=' || TO_CHAR(lvi_nr_of_rows);
         RAISE StpError;
      END IF;
   END IF;
   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF sqlcode <> 1 THEN
      l_sqlerrm := SUBSTR(SQLERRM,1,255);
   END IF;
   INSERT INTO uterror(client_id, applic, who, logdate, api_name, error_msg)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP,
                     lcs_function_name, l_sqlerrm );
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END AssignMeGkUserGroup;

FUNCTION scPriority                    /* INTERNAL */
(a_ss_to           IN VARCHAR2)        /* VC2_TYPE */
RETURN NUMBER IS

l_found                BOOLEAN := TRUE;
l_nr_of_rows           INTEGER := 1;
l_value_list           UNAPIGEN.VC40_TABLE_TYPE;
l_gk_version           VARCHAR2(20);
BEGIN

   ---------------------------------------------------------------------------------------------
   -- !!!
   -- It is a good practice to check if the event matches '%GroupKeyUpdated' when an action will
   -- be used in an event rule. It enables us to avoid loops in event rules.
   -- !!!
   ---------------------------------------------------------------------------------------------
   IF UNAPIEV.P_EV_REC.ev_tp LIKE '%GroupKeyUpdated' THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;

   SELECT NVL (TO_CHAR (priority), '9')
     INTO l_value_list(1)
     FROM utsc
    WHERE sc = UNAPIEV.P_SC;

   l_ret_code := UNAPIGEN.DBERR_SUCCESS;

   IF l_found THEN
      /* Argument gk_version is left empty */
      l_ret_code := UNAPIMEP.Save1ScMeGroupKey(UNAPIEV.P_SC,
                                    UNAPIEV.P_PG,UNAPIEV.P_PGNODE,
                                    UNAPIEV.P_PA,UNAPIEV.P_PANODE,
                                    UNAPIEV.P_ME,UNAPIEV.P_MENODE,
                                    'scPriority', l_gk_version,
                                    l_value_list, l_nr_of_rows, NULL);
      IF UNAPIEV.P_EV_OUTPUT_ON THEN
         DBMS_OUTPUT.PUT_LINE(
         'Save1ScMeGroupKey#return=' || TO_CHAR(l_ret_code) ||
         '#sc=' || UNAPIEV.P_SC ||
         '#pg=' || UNAPIEV.P_PG || '#pgnode=' || TO_CHAR(UNAPIEV.P_PGNODE) ||
         '#pa=' || UNAPIEV.P_PA || '#panode=' || TO_CHAR(UNAPIEV.P_PANODE) ||
         '#me=' || UNAPIEV.P_ME || '#menode=' || TO_CHAR(UNAPIEV.P_MENODE) ||
         '#gk=' || 'scPriority' ||
         '#nr_of_rows=' || TO_CHAR(l_nr_of_rows));
      END IF;
      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         l_sqlerrm :=
         'Save1ScMeGroupKey#return=' || TO_CHAR(l_ret_code) ||
         '#sc=' || UNAPIEV.P_SC ||
         '#pg=' || UNAPIEV.P_PG || '#pgnode=' || TO_CHAR(UNAPIEV.P_PGNODE) ||
         '#pa=' || UNAPIEV.P_PA || '#panode=' || TO_CHAR(UNAPIEV.P_PANODE) ||
         '#me=' || UNAPIEV.P_ME || '#menode=' || TO_CHAR(UNAPIEV.P_MENODE) ||
         '#gk=' || 'scPriority' ||
         '#nr_of_rows=' || TO_CHAR(l_nr_of_rows);
         RAISE StpError;
      END IF;
   END IF;
   RETURN( l_ret_code);

EXCEPTION
WHEN OTHERS THEN
   IF sqlcode <> 1 THEN
      l_sqlerrm := SUBSTR (SQLERRM, 1, 255);
   END IF;
   UNAPIGEN.LogError ('scPriority', l_sqlerrm);
   RETURN UNAPIGEN.DBERR_GENFAIL;

END scPriority;

--------------------------------------------------------------------------------
FUNCTION scDate1                       /* INTERNAL */
(a_ss_to           IN VARCHAR2)        /* VC2_TYPE */
RETURN NUMBER IS

   l_found                BOOLEAN := TRUE;
   l_nr_of_rows           INTEGER := 1;
   l_value_list           UNAPIGEN.VC40_TABLE_TYPE;
   l_gk_version           VARCHAR2(20);

BEGIN

   ---------------------------------------------------------------------------------------------
   -- !!!
   -- It is a good practice to check if the event matches '%GroupKeyUpdated' when an action will
   -- be used in an event rule. It enables us to avoid loops in event rules.
   -- !!!
   ---------------------------------------------------------------------------------------------
   IF UNAPIEV.P_EV_REC.ev_tp LIKE '%GroupKeyUpdated' THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;

   SELECT NVL (TO_CHAR (date1, 'YYYY/MM/DD HH24:MI:SS'), '9999/99/99 99:99:99') -- A format fit for sorting.
     INTO l_value_list(1)
     FROM utsc
    WHERE sc = UNAPIEV.P_SC;

   l_ret_code := UNAPIGEN.DBERR_SUCCESS;

   IF l_found THEN
      /* Argument gk_version is left empty */
      l_ret_code := UNAPIMEP.Save1ScMeGroupKey(UNAPIEV.P_SC,
                                    UNAPIEV.P_PG,UNAPIEV.P_PGNODE,
                                    UNAPIEV.P_PA,UNAPIEV.P_PANODE,
                                    UNAPIEV.P_ME,UNAPIEV.P_MENODE,
                                    'scDate1', l_gk_version,
                                    l_value_list, l_nr_of_rows, NULL);
      IF UNAPIEV.P_EV_OUTPUT_ON THEN
         DBMS_OUTPUT.PUT_LINE(
         'Save1ScMeGroupKey#return=' || TO_CHAR(l_ret_code) ||
         '#sc=' || UNAPIEV.P_SC ||
         '#pg=' || UNAPIEV.P_PG || '#pgnode=' || TO_CHAR(UNAPIEV.P_PGNODE) ||
         '#pa=' || UNAPIEV.P_PA || '#panode=' || TO_CHAR(UNAPIEV.P_PANODE) ||
         '#me=' || UNAPIEV.P_ME || '#menode=' || TO_CHAR(UNAPIEV.P_MENODE) ||
         '#gk=' || 'scDate1' ||
         '#nr_of_rows=' || TO_CHAR(l_nr_of_rows));
      END IF;
      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         l_sqlerrm :=
         'Save1ScMeGroupKey#return=' || TO_CHAR(l_ret_code) ||
         '#sc=' || UNAPIEV.P_SC ||
         '#pg=' || UNAPIEV.P_PG || '#pgnode=' || TO_CHAR(UNAPIEV.P_PGNODE) ||
         '#pa=' || UNAPIEV.P_PA || '#panode=' || TO_CHAR(UNAPIEV.P_PANODE) ||
         '#me=' || UNAPIEV.P_ME || '#menode=' || TO_CHAR(UNAPIEV.P_MENODE) ||
         '#gk=' || 'scDate1' ||
         '#nr_of_rows=' || TO_CHAR(l_nr_of_rows);
         RAISE StpError;
      END IF;
   END IF;
   RETURN( l_ret_code);

EXCEPTION
WHEN OTHERS THEN
   IF sqlcode <> 1 THEN
      l_sqlerrm := SUBSTR (SQLERRM, 1, 255);
   END IF;
   UNAPIGEN.LogError ('scDate1', l_sqlerrm);
   RETURN UNAPIGEN.DBERR_GENFAIL;

END scDate1;

--------------------------------------------------------------------------------
FUNCTION scDate2                       /* INTERNAL */
(a_ss_to           IN VARCHAR2)        /* VC2_TYPE */
RETURN NUMBER IS

   l_found                BOOLEAN := TRUE;
   l_nr_of_rows           INTEGER := 1;
   l_value_list           UNAPIGEN.VC40_TABLE_TYPE;
   l_gk_version           VARCHAR2(20);

BEGIN

   ---------------------------------------------------------------------------------------------
   -- !!!
   -- It is a good practice to check if the event matches '%GroupKeyUpdated' when an action will
   -- be used in an event rule. It enables us to avoid loops in event rules.
   -- !!!
   ---------------------------------------------------------------------------------------------
   IF UNAPIEV.P_EV_REC.ev_tp LIKE '%GroupKeyUpdated' THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;

   SELECT NVL (TO_CHAR (date2, 'YYYY/MM/DD HH24:MI:SS'), '9999/99/99 99:99:99') -- A format fit for sorting.
     INTO l_value_list(1)
     FROM utsc
    WHERE sc = UNAPIEV.P_SC;

   l_ret_code := UNAPIGEN.DBERR_SUCCESS;

   IF l_found THEN
      /* Argument gk_version is left empty */
      l_ret_code := UNAPIMEP.Save1ScMeGroupKey(UNAPIEV.P_SC,
                                    UNAPIEV.P_PG,UNAPIEV.P_PGNODE,
                                    UNAPIEV.P_PA,UNAPIEV.P_PANODE,
                                    UNAPIEV.P_ME,UNAPIEV.P_MENODE,
                                    'scDate2', l_gk_version,
                                    l_value_list, l_nr_of_rows, NULL);
      IF UNAPIEV.P_EV_OUTPUT_ON THEN
         DBMS_OUTPUT.PUT_LINE(
         'Save1ScMeGroupKey#return=' || TO_CHAR(l_ret_code) ||
         '#sc=' || UNAPIEV.P_SC ||
         '#pg=' || UNAPIEV.P_PG || '#pgnode=' || TO_CHAR(UNAPIEV.P_PGNODE) ||
         '#pa=' || UNAPIEV.P_PA || '#panode=' || TO_CHAR(UNAPIEV.P_PANODE) ||
         '#me=' || UNAPIEV.P_ME || '#menode=' || TO_CHAR(UNAPIEV.P_MENODE) ||
         '#gk=' || 'scDate2' ||
         '#nr_of_rows=' || TO_CHAR(l_nr_of_rows));
      END IF;
      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         l_sqlerrm :=
         'Save1ScMeGroupKey#return=' || TO_CHAR(l_ret_code) ||
         '#sc=' || UNAPIEV.P_SC ||
         '#pg=' || UNAPIEV.P_PG || '#pgnode=' || TO_CHAR(UNAPIEV.P_PGNODE) ||
         '#pa=' || UNAPIEV.P_PA || '#panode=' || TO_CHAR(UNAPIEV.P_PANODE) ||
         '#me=' || UNAPIEV.P_ME || '#menode=' || TO_CHAR(UNAPIEV.P_MENODE) ||
         '#gk=' || 'scDate2' ||
         '#nr_of_rows=' || TO_CHAR(l_nr_of_rows);
         RAISE StpError;
      END IF;
   END IF;
   RETURN( l_ret_code);

EXCEPTION
WHEN OTHERS THEN
   IF sqlcode <> 1 THEN
      l_sqlerrm := SUBSTR (SQLERRM, 1, 255);
   END IF;
   UNAPIGEN.LogError ('scDate2', l_sqlerrm);
   RETURN UNAPIGEN.DBERR_GENFAIL;

END scDate2;

--------------------------------------------------------------------------------
FUNCTION scDate3                       /* INTERNAL */
(a_ss_to           IN VARCHAR2)        /* VC2_TYPE */
RETURN NUMBER IS

   l_found                BOOLEAN := TRUE;
   l_nr_of_rows           INTEGER := 1;
   l_value_list           UNAPIGEN.VC40_TABLE_TYPE;
   l_gk_version           VARCHAR2(20);

BEGIN

   ---------------------------------------------------------------------------------------------
   -- !!!
   -- It is a good practice to check if the event matches '%GroupKeyUpdated' when an action will
   -- be used in an event rule. It enables us to avoid loops in event rules.
   -- !!!
   ---------------------------------------------------------------------------------------------
   IF UNAPIEV.P_EV_REC.ev_tp LIKE '%GroupKeyUpdated' THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;

   SELECT NVL (TO_CHAR (date3, 'YYYY/MM/DD HH24:MI:SS'), '9999/99/99 99:99:99') -- A format fit for sorting.
     INTO l_value_list(1)
     FROM utsc
    WHERE sc = UNAPIEV.P_SC;

   l_ret_code := UNAPIGEN.DBERR_SUCCESS;

   IF l_found THEN
      /* Argument gk_version is left empty */
      l_ret_code := UNAPIMEP.Save1ScMeGroupKey(UNAPIEV.P_SC,
                                    UNAPIEV.P_PG,UNAPIEV.P_PGNODE,
                                    UNAPIEV.P_PA,UNAPIEV.P_PANODE,
                                    UNAPIEV.P_ME,UNAPIEV.P_MENODE,
                                    'scDate3', l_gk_version,
                                    l_value_list, l_nr_of_rows, NULL);
      IF UNAPIEV.P_EV_OUTPUT_ON THEN
         DBMS_OUTPUT.PUT_LINE(
         'Save1ScMeGroupKey#return=' || TO_CHAR(l_ret_code) ||
         '#sc=' || UNAPIEV.P_SC ||
         '#pg=' || UNAPIEV.P_PG || '#pgnode=' || TO_CHAR(UNAPIEV.P_PGNODE) ||
         '#pa=' || UNAPIEV.P_PA || '#panode=' || TO_CHAR(UNAPIEV.P_PANODE) ||
         '#me=' || UNAPIEV.P_ME || '#menode=' || TO_CHAR(UNAPIEV.P_MENODE) ||
         '#gk=' || 'scDate3' ||
         '#nr_of_rows=' || TO_CHAR(l_nr_of_rows));
      END IF;
      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         l_sqlerrm :=
         'Save1ScMeGroupKey#return=' || TO_CHAR(l_ret_code) ||
         '#sc=' || UNAPIEV.P_SC ||
         '#pg=' || UNAPIEV.P_PG || '#pgnode=' || TO_CHAR(UNAPIEV.P_PGNODE) ||
         '#pa=' || UNAPIEV.P_PA || '#panode=' || TO_CHAR(UNAPIEV.P_PANODE) ||
         '#me=' || UNAPIEV.P_ME || '#menode=' || TO_CHAR(UNAPIEV.P_MENODE) ||
         '#gk=' || 'scDate3' ||
         '#nr_of_rows=' || TO_CHAR(l_nr_of_rows);
         RAISE StpError;
      END IF;
   END IF;
   RETURN( l_ret_code);

EXCEPTION
WHEN OTHERS THEN
   IF sqlcode <> 1 THEN
      l_sqlerrm := SUBSTR (SQLERRM, 1, 255);
   END IF;
   UNAPIGEN.LogError ('scDate3', l_sqlerrm);
   RETURN UNAPIGEN.DBERR_GENFAIL;

END scDate3;

--------------------------------------------------------------------------------
FUNCTION scDate4                       /* INTERNAL */
(a_ss_to           IN VARCHAR2)        /* VC2_TYPE */
RETURN NUMBER IS

   l_found                BOOLEAN := TRUE;
   l_nr_of_rows           INTEGER := 1;
   l_value_list           UNAPIGEN.VC40_TABLE_TYPE;
   l_gk_version           VARCHAR2(20);

BEGIN

   ---------------------------------------------------------------------------------------------
   -- !!!
   -- It is a good practice to check if the event matches '%GroupKeyUpdated' when an action will
   -- be used in an event rule. It enables us to avoid loops in event rules.
   -- !!!
   ---------------------------------------------------------------------------------------------
   IF UNAPIEV.P_EV_REC.ev_tp LIKE '%GroupKeyUpdated' THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;

   SELECT NVL (TO_CHAR (date4, 'YYYY/MM/DD HH24:MI:SS'), '9999/99/99 99:99:99') -- A format fit for sorting.
     INTO l_value_list(1)
     FROM utsc
    WHERE sc = UNAPIEV.P_SC;

   l_ret_code := UNAPIGEN.DBERR_SUCCESS;

   IF l_found THEN
      /* Argument gk_version is left empty */
      l_ret_code := UNAPIMEP.Save1ScMeGroupKey(UNAPIEV.P_SC,
                                    UNAPIEV.P_PG,UNAPIEV.P_PGNODE,
                                    UNAPIEV.P_PA,UNAPIEV.P_PANODE,
                                    UNAPIEV.P_ME,UNAPIEV.P_MENODE,
                                    'scDate4', l_gk_version,
                                    l_value_list, l_nr_of_rows, NULL);
      IF UNAPIEV.P_EV_OUTPUT_ON THEN
         DBMS_OUTPUT.PUT_LINE(
         'Save1ScMeGroupKey#return=' || TO_CHAR(l_ret_code) ||
         '#sc=' || UNAPIEV.P_SC ||
         '#pg=' || UNAPIEV.P_PG || '#pgnode=' || TO_CHAR(UNAPIEV.P_PGNODE) ||
         '#pa=' || UNAPIEV.P_PA || '#panode=' || TO_CHAR(UNAPIEV.P_PANODE) ||
         '#me=' || UNAPIEV.P_ME || '#menode=' || TO_CHAR(UNAPIEV.P_MENODE) ||
         '#gk=' || 'scDate4' ||
         '#nr_of_rows=' || TO_CHAR(l_nr_of_rows));
      END IF;
      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         l_sqlerrm :=
         'Save1ScMeGroupKey#return=' || TO_CHAR(l_ret_code) ||
         '#sc=' || UNAPIEV.P_SC ||
         '#pg=' || UNAPIEV.P_PG || '#pgnode=' || TO_CHAR(UNAPIEV.P_PGNODE) ||
         '#pa=' || UNAPIEV.P_PA || '#panode=' || TO_CHAR(UNAPIEV.P_PANODE) ||
         '#me=' || UNAPIEV.P_ME || '#menode=' || TO_CHAR(UNAPIEV.P_MENODE) ||
         '#gk=' || 'scDate4' ||
         '#nr_of_rows=' || TO_CHAR(l_nr_of_rows);
         RAISE StpError;
      END IF;
   END IF;
   RETURN( l_ret_code);

EXCEPTION
WHEN OTHERS THEN
   IF sqlcode <> 1 THEN
      l_sqlerrm := SUBSTR (SQLERRM, 1, 255);
   END IF;
   UNAPIGEN.LogError ('scDate4', l_sqlerrm);
   RETURN UNAPIGEN.DBERR_GENFAIL;

END scDate4;

--------------------------------------------------------------------------------
FUNCTION scDate5                       /* INTERNAL */
(a_ss_to           IN VARCHAR2)        /* VC2_TYPE */
RETURN NUMBER IS

   l_found                BOOLEAN := TRUE;
   l_nr_of_rows           INTEGER := 1;
   l_value_list           UNAPIGEN.VC40_TABLE_TYPE;
   l_gk_version           VARCHAR2(20);

BEGIN

   ---------------------------------------------------------------------------------------------
   -- !!!
   -- It is a good practice to check if the event matches '%GroupKeyUpdated' when an action will
   -- be used in an event rule. It enables us to avoid loops in event rules.
   -- !!!
   ---------------------------------------------------------------------------------------------
   IF UNAPIEV.P_EV_REC.ev_tp LIKE '%GroupKeyUpdated' THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;

   SELECT NVL (TO_CHAR (date5, 'YYYY/MM/DD HH24:MI:SS'), '9999/99/99 99:99:99') -- A format fit for sorting.
     INTO l_value_list(1)
     FROM utsc
    WHERE sc = UNAPIEV.P_SC;

   l_ret_code := UNAPIGEN.DBERR_SUCCESS;

   IF l_found THEN
      /* Argument gk_version is left empty */
      l_ret_code := UNAPIMEP.Save1ScMeGroupKey(UNAPIEV.P_SC,
                                    UNAPIEV.P_PG,UNAPIEV.P_PGNODE,
                                    UNAPIEV.P_PA,UNAPIEV.P_PANODE,
                                    UNAPIEV.P_ME,UNAPIEV.P_MENODE,
                                    'scDate5', l_gk_version,
                                    l_value_list, l_nr_of_rows, NULL);
      IF UNAPIEV.P_EV_OUTPUT_ON THEN
         DBMS_OUTPUT.PUT_LINE(
         'Save1ScMeGroupKey#return=' || TO_CHAR(l_ret_code) ||
         '#sc=' || UNAPIEV.P_SC ||
         '#pg=' || UNAPIEV.P_PG || '#pgnode=' || TO_CHAR(UNAPIEV.P_PGNODE) ||
         '#pa=' || UNAPIEV.P_PA || '#panode=' || TO_CHAR(UNAPIEV.P_PANODE) ||
         '#me=' || UNAPIEV.P_ME || '#menode=' || TO_CHAR(UNAPIEV.P_MENODE) ||
         '#gk=' || 'scDate5' ||
         '#nr_of_rows=' || TO_CHAR(l_nr_of_rows));
      END IF;
      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         l_sqlerrm :=
         'Save1ScMeGroupKey#return=' || TO_CHAR(l_ret_code) ||
         '#sc=' || UNAPIEV.P_SC ||
         '#pg=' || UNAPIEV.P_PG || '#pgnode=' || TO_CHAR(UNAPIEV.P_PGNODE) ||
         '#pa=' || UNAPIEV.P_PA || '#panode=' || TO_CHAR(UNAPIEV.P_PANODE) ||
         '#me=' || UNAPIEV.P_ME || '#menode=' || TO_CHAR(UNAPIEV.P_MENODE) ||
         '#gk=' || 'scDate5' ||
         '#nr_of_rows=' || TO_CHAR(l_nr_of_rows);
         RAISE StpError;
      END IF;
   END IF;
   RETURN( l_ret_code);

EXCEPTION
WHEN OTHERS THEN
   IF sqlcode <> 1 THEN
      l_sqlerrm := SUBSTR (SQLERRM, 1, 255);
   END IF;
   UNAPIGEN.LogError ('scDate5', l_sqlerrm);
   RETURN UNAPIGEN.DBERR_GENFAIL;

END scDate5;

FUNCTION GetVersion
  RETURN VARCHAR2
IS
BEGIN
  RETURN('06.07.00.00_13.00');
EXCEPTION
  WHEN OTHERS THEN
	 RETURN (NULL);
END GetVersion;


END ungkassign;
create or replace PACKAGE BODY        unwlassign AS
--------------------------------------------------------------------------------
--  PROJECT : Vredestein Enschede
-------------------------------------------------------------------------------
--  PACKAGE : UNWLASSIGN
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
-- 25/06/2008 | RS        | Added MePriority
-- 23/06/2009 | RS        | Added MeAssignGkDefault
-- 03/03/2011 | RS        | Upgrade V6.3
--                        | Changed SYSDATE INTO CURRENT_TIMESTAMP
--                        | Changed DATE; INTO TIMESTAMP WITH TIME ZONE;
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
FUNCTION MePriority                    /* INTERNAL */
(a_ss_to           IN VARCHAR2)             /* VC2_TYPE */
RETURN NUMBER IS

l_found                BOOLEAN;
l_nr_of_rows           INTEGER;
l_value_list           UNAPIGEN.VC40_TABLE_TYPE;
l_gk_version           VARCHAR2(20);
l_rq_priority          VARCHAR2(40);
l_sc_priority          VARCHAR2(40);
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

   BEGIN
      SELECT NVL(TO_CHAR(a.priority), '-') rqpriority, NVL(TO_CHAR(b.priority), '-') scpriority
        INTO l_rq_priority, l_sc_priority
        FROM utrq a, utsc b
       WHERE b.sc = UNAPIEV.P_SC
         AND a.rq(+) = b.rq;

   EXCEPTION
   WHEN NO_DATA_FOUND THEN
      l_found := FALSE;
      RETURN UNAPIGEN.DBERR_GENFAIL;
   END ;

   l_ret_code := UNAPIGEN.DBERR_SUCCESS;

   IF l_rq_priority != '-' THEN
      l_value_list(1) := l_rq_priority;
      l_found := TRUE;
      l_nr_of_rows := 1;
   ELSIF l_sc_priority != '-' THEN
      l_value_list(1) := l_sc_priority;
      l_found := TRUE;
      l_nr_of_rows := 1;
   ELSE
      l_found := FALSE;
      l_nr_of_rows := 0;
   END IF;

   IF l_found THEN
      /* Argument gk_version is left empty */
      l_ret_code := UNAPIMEP.Save1ScMeGroupKey(UNAPIEV.P_SC,
                                    UNAPIEV.P_PG,UNAPIEV.P_PGNODE,
                                    UNAPIEV.P_PA,UNAPIEV.P_PANODE,
                                    UNAPIEV.P_ME,UNAPIEV.P_MENODE,
                                    'avMePriority', l_gk_version,
                                    l_value_list, l_nr_of_rows, NULL);
      IF UNAPIEV.P_EV_OUTPUT_ON THEN
         DBMS_OUTPUT.PUT_LINE(
         'Save1ScMeGroupKey#return=' || TO_CHAR(l_ret_code) ||
         '#sc=' || UNAPIEV.P_SC ||
         '#pg=' || UNAPIEV.P_PG || '#pgnode=' || TO_CHAR(UNAPIEV.P_PGNODE) ||
         '#pa=' || UNAPIEV.P_PA || '#panode=' || TO_CHAR(UNAPIEV.P_PANODE) ||
         '#me=' || UNAPIEV.P_ME || '#menode=' || TO_CHAR(UNAPIEV.P_MENODE) ||
         '#gk=' || 'avMePriority' ||
         '#nr_of_rows=' || TO_CHAR(l_nr_of_rows));
      END IF;
      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         l_sqlerrm :=
         'Save1ScMeGroupKey#return=' || TO_CHAR(l_ret_code) ||
         '#sc=' || UNAPIEV.P_SC ||
         '#pg=' || UNAPIEV.P_PG || '#pgnode=' || TO_CHAR(UNAPIEV.P_PGNODE) ||
         '#pa=' || UNAPIEV.P_PA || '#panode=' || TO_CHAR(UNAPIEV.P_PANODE) ||
         '#me=' || UNAPIEV.P_ME || '#menode=' || TO_CHAR(UNAPIEV.P_MENODE) ||
         '#gk=' || 'avMePriority' ||
         '#nr_of_rows=' || TO_CHAR(l_nr_of_rows);
         RAISE StpError;
      END IF;
   END IF;
   RETURN( l_ret_code);

EXCEPTION
WHEN OTHERS THEN
   IF sqlcode <> 1 THEN
      l_sqlerrm := SUBSTR(SQLERRM,1,255);
   END IF;
   INSERT INTO uterror(client_id, applic, who, logdate, api_name, error_msg)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP,
                     'MePriority' , l_sqlerrm );
   RETURN(UNAPIGEN.DBERR_GENFAIL);

END MePriority;


FUNCTION MeStartAndEndDate                    /* INTERNAL */
(a_ss_to           IN VARCHAR2)             /* VC2_TYPE */
RETURN NUMBER IS

l_exec_start_date      TIMESTAMP WITH TIME ZONE;
l_exec_end_date        TIMESTAMP WITH TIME ZONE;
l_found                BOOLEAN;
l_nr_of_rows           INTEGER;
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

   BEGIN
      SELECT exec_start_date, exec_end_date
      INTO   l_exec_start_date, l_exec_end_date
      FROM   utscme
      WHERE sc = UNAPIEV.P_SC
        AND pg = UNAPIEV.P_PG
        AND pgnode = UNAPIEV.P_PGNODE
        AND pa = UNAPIEV.P_PA
        AND panode = UNAPIEV.P_PANODE
        AND me = UNAPIEV.P_ME
        AND menode = UNAPIEV.P_MENODE;
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
      l_exec_start_date := NULL;
   END ;

   l_found := FALSE;
   l_ret_code := UNAPIGEN.DBERR_SUCCESS;
   IF l_exec_start_date IS NULL THEN
      NULL;
      /* Do nothing */
   ELSE
      IF l_exec_end_date IS NULL THEN
         l_value_list(1) := l_exec_start_date;
         l_nr_of_rows := 1;
      ELSE
         /* DELETE from the worklist */
         l_nr_of_rows := 0;
      END IF;
      l_found := TRUE;
   END IF;

   IF l_found THEN
      /* Argument gk_version is left empty */
      l_ret_code := UNAPIMEP.Save1ScMeGroupKey(UNAPIEV.P_SC,
                                    UNAPIEV.P_PG,UNAPIEV.P_PGNODE,
                                    UNAPIEV.P_PA,UNAPIEV.P_PANODE,
                                    UNAPIEV.P_ME,UNAPIEV.P_MENODE,
                                    'dayoftheweek', l_gk_version,
                                    l_value_list, l_nr_of_rows, NULL);
      IF UNAPIEV.P_EV_OUTPUT_ON THEN
         DBMS_OUTPUT.PUT_LINE(
         'Save1ScMeGroupKey#return=' || TO_CHAR(l_ret_code) ||
         '#sc=' || UNAPIEV.P_SC ||
         '#pg=' || UNAPIEV.P_PG || '#pgnode=' || TO_CHAR(UNAPIEV.P_PGNODE) ||
         '#pa=' || UNAPIEV.P_PA || '#panode=' || TO_CHAR(UNAPIEV.P_PANODE) ||
         '#me=' || UNAPIEV.P_ME || '#menode=' || TO_CHAR(UNAPIEV.P_MENODE) ||
         '#gk=' || 'dayoftheweek' ||
         '#nr_of_rows=' || TO_CHAR(l_nr_of_rows));
      END IF;
      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         l_sqlerrm :=
         'Save1ScMeGroupKey#return=' || TO_CHAR(l_ret_code) ||
         '#sc=' || UNAPIEV.P_SC ||
         '#pg=' || UNAPIEV.P_PG || '#pgnode=' || TO_CHAR(UNAPIEV.P_PGNODE) ||
         '#pa=' || UNAPIEV.P_PA || '#panode=' || TO_CHAR(UNAPIEV.P_PANODE) ||
         '#me=' || UNAPIEV.P_ME || '#menode=' || TO_CHAR(UNAPIEV.P_MENODE) ||
         '#gk=' || 'dayoftheweek' ||
         '#nr_of_rows=' || TO_CHAR(l_nr_of_rows);
         RAISE StpError;
      END IF;
   END IF;
   RETURN( l_ret_code);

EXCEPTION
WHEN OTHERS THEN
   IF sqlcode <> 1 THEN
      l_sqlerrm := SUBSTR(SQLERRM,1,255);
   END IF;
   INSERT INTO uterror(client_id, applic, who, logdate, logdate_tz, api_name, error_msg)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                     'MeStartAndEndDate' , l_sqlerrm );
   RETURN(UNAPIGEN.DBERR_GENFAIL);

END MeStartAndEndDate;

FUNCTION MePreferredExecutors                /* INTERNAL */
(a_ss_to           IN VARCHAR2)             /* VC2_TYPE */
RETURN NUMBER IS

l_row                         INTEGER;
l_found                       BOOLEAN;
l_nr_of_rows                  INTEGER;
l_value_list                  UNAPIGEN.VC40_TABLE_TYPE;
l_modify_reason               VARCHAR2(255);
l_value_tab                   UNAPIGEN.VC40_TABLE_TYPE;
l_gk_version                  VARCHAR2(20);

CURSOR l_prmtau_cursor (a_pr VARCHAR2, a_mt VARCHAR2) IS
SELECT value
FROM utprmtau
WHERE pr = a_pr
AND mt = a_mt
AND au = 'PreferredExecutor';
l_prmtau_rec      l_prmtau_cursor%ROWTYPE;

CURSOR l_mtau_cursor (a_mt VARCHAR2) IS
SELECT value
FROM utmtau
WHERE mt = a_mt
AND au = 'PreferredExecutor';
l_mtau_rec        l_mtau_cursor%ROWTYPE;

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

   l_ret_code := UNAPIGEN.DBERR_SUCCESS; --will be reurned when nothing found

   /*--------------------------------------------------------------*/
   /* PreferredExecutor is an attribute defined at prmt or         */
   /* at mt level => when a method is created : the method         */
   /* will appear in the worklist of these technicians             */
   /*--------------------------------------------------------------*/
   /* Rules followed : 1) prmt attributes overrules mtau           */
   /*                  2) PreferredExecutor attribute              */
   /*                     allows multiple values                   */
   /* Assumptions 1) attribute PreferredExecutor defined           */
   /*             2) Excutor method group key defined              */
   /*--------------------------------------------------------------*/

   -- GetFunctions are not used since these are based on views

   --Fetch prmt attributes
   l_nr_of_rows := 0;
   OPEN l_prmtau_cursor(UNAPIEV.P_PA, UNAPIEV.P_ME);

   FETCH l_prmtau_cursor
   INTO l_prmtau_rec;

   WHILE l_prmtau_cursor%FOUND LOOP
      l_nr_of_rows := l_nr_of_rows + 1;
      l_value_tab(l_nr_of_rows) := l_prmtau_rec.value;
      FETCH l_prmtau_cursor
      INTO l_prmtau_rec;
   END LOOP;
   CLOSE l_prmtau_cursor;

   --Fetch mt attributes when not found
   --at prmt level
   IF l_nr_of_rows = 0 THEN
      OPEN l_mtau_cursor(UNAPIEV.P_ME);

      FETCH l_mtau_cursor
      INTO l_mtau_rec;

      WHILE l_mtau_cursor%FOUND LOOP
         l_nr_of_rows := l_nr_of_rows + 1;
         l_value_tab(l_nr_of_rows) := l_mtau_rec.value;
         FETCH l_mtau_cursor
         INTO l_mtau_rec;
      END LOOP;
      CLOSE l_mtau_cursor;
   END IF;

   --Save attributes as method group key values
   IF l_nr_of_rows > 0 THEN
      /* Argument gk_version is left empty */
      l_ret_code :=UNAPIMEP.Save1ScMeGroupKey(UNAPIEV.P_SC,
                                    UNAPIEV.P_PG,UNAPIEV.P_PGNODE,
                                    UNAPIEV.P_PA,UNAPIEV.P_PANODE,
                                    UNAPIEV.P_ME,UNAPIEV.P_MENODE,
                                    'Executor', l_gk_version,
                                    l_value_tab, l_nr_of_rows, NULL);
      IF UNAPIEV.P_EV_OUTPUT_ON THEN
         DBMS_OUTPUT.PUT_LINE(
         'Save1ScMeGroupKey#return=' || TO_CHAR(l_ret_code) ||
         '#sc=' || UNAPIEV.P_SC ||
         '#pg=' || UNAPIEV.P_PG || '#pgnode=' || TO_CHAR(UNAPIEV.P_PGNODE) ||
         '#pa=' || UNAPIEV.P_PA || '#panode=' || TO_CHAR(UNAPIEV.P_PANODE) ||
         '#me=' || UNAPIEV.P_ME || '#menode=' || TO_CHAR(UNAPIEV.P_MENODE) ||
         '#gk=' || 'Executor' ||
         '#nr_of_rows=' || TO_CHAR(l_nr_of_rows));
      END IF;
      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         l_sqlerrm :=
         'Save1ScMeGroupKey#return=' || TO_CHAR(l_ret_code) ||
         '#sc=' || UNAPIEV.P_SC ||
         '#pg=' || UNAPIEV.P_PG || '#pgnode=' || TO_CHAR(UNAPIEV.P_PGNODE) ||
         '#pa=' || UNAPIEV.P_PA || '#panode=' || TO_CHAR(UNAPIEV.P_PANODE) ||
         '#me=' || UNAPIEV.P_ME || '#menode=' || TO_CHAR(UNAPIEV.P_MENODE) ||
         '#gk=' || 'Executor' ||
         '#nr_of_rows=' || TO_CHAR(l_nr_of_rows);
         RAISE StpError;
      END IF;
   END IF;
   RETURN( l_ret_code);

EXCEPTION
WHEN OTHERS THEN
   IF sqlcode <> 1 THEN
      l_sqlerrm := SUBSTR(SQLERRM,1,255);
   END IF;
   INSERT INTO uterror(client_id, applic, who, logdate, api_name, error_msg)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP,
                     'MePreferredExecutor' , l_sqlerrm );
   RETURN(UNAPIGEN.DBERR_GENFAIL);

END MePreferredExecutors;

FUNCTION MeOperational                      /* INTERNAL */
(a_ss_to           IN VARCHAR2)             /* VC2_TYPE */
RETURN NUMBER
IS

l_svgk_value           UNAPIGEN.VC40_TABLE_TYPE;
l_nr_of_rows           INTEGER;
l_result               NUMBER;
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

   l_svgk_value(1) := 'Yes';
   l_nr_of_rows := 1;

   l_result := UNAPIAUT.DisableAllowModifyCheck('1');
   /* Argument gk_version is left empty */
   l_ret_code := UNAPIMEP.Save1ScMeGroupKey(UNAPIEV.P_SC,
                                  UNAPIEV.P_PG,UNAPIEV.P_PGNODE,
                                  UNAPIEV.P_PA,UNAPIEV.P_PANODE,
                                  UNAPIEV.P_ME,UNAPIEV.P_MENODE,
                                  'Operational', l_gk_version,
                                  l_svgk_value, l_nr_of_rows, NULL);
   l_result := UNAPIAUT.DisableAllowModifyCheck('0');
   IF UNAPIEV.P_EV_OUTPUT_ON THEN
      UNTRACE.LOG(
       'Save1ScMeGroupKey#return=' || TO_CHAR(l_ret_code) ||
       '#sc=' || UNAPIEV.P_SC ||
       '#pg=' || UNAPIEV.P_PG || '#pgnode=' || TO_CHAR(UNAPIEV.P_PGNODE) ||
       '#pa=' || UNAPIEV.P_PA || '#panode=' || TO_CHAR(UNAPIEV.P_PANODE) ||
       '#me=' || UNAPIEV.P_ME || '#menode=' || TO_CHAR(UNAPIEV.P_MENODE) ||
       '#gk=' || 'Operational' ||
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
       '#gk=' || 'Operational'||
       '#nr_of_rows=' || TO_CHAR(l_nr_of_rows);
      RAISE StpError;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF sqlcode <> 1 THEN
      l_sqlerrm := SUBSTR(SQLERRM,1,255);
   END IF;
   INSERT INTO uterror(client_id, applic, who, logdate, api_name, error_msg)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP,
                     'MeOperational' , l_sqlerrm );
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END MeOperational;

FUNCTION MeReleased                         /* INTERNAL */
(a_ss_to           IN VARCHAR2)             /* VC2_TYPE */
RETURN NUMBER
IS

l_svgk_value           UNAPIGEN.VC40_TABLE_TYPE;
l_nr_of_rows           INTEGER;
l_result               NUMBER;
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

   l_svgk_value(1) := 'Yes';
   l_nr_of_rows := 1;

   l_result := UNAPIAUT.DisableAllowModifyCheck('1');
   /* Argument gk_version is left empty */
   l_ret_code := UNAPIMEP.Save1ScMeGroupKey(UNAPIEV.P_SC,
                                  UNAPIEV.P_PG,UNAPIEV.P_PGNODE,
                                  UNAPIEV.P_PA,UNAPIEV.P_PANODE,
                                  UNAPIEV.P_ME,UNAPIEV.P_MENODE,
                                  'Released', l_gk_version,
                                  l_svgk_value, l_nr_of_rows, NULL);
   l_result := UNAPIAUT.DisableAllowModifyCheck('0');
   IF UNAPIEV.P_EV_OUTPUT_ON THEN
      UNTRACE.LOG(
       'Save1ScMeGroupKey#return=' || TO_CHAR(l_ret_code) ||
       '#sc=' || UNAPIEV.P_SC ||
       '#pg=' || UNAPIEV.P_PG || '#pgnode=' || TO_CHAR(UNAPIEV.P_PGNODE) ||
       '#pa=' || UNAPIEV.P_PA || '#panode=' || TO_CHAR(UNAPIEV.P_PANODE) ||
       '#me=' || UNAPIEV.P_ME || '#menode=' || TO_CHAR(UNAPIEV.P_MENODE) ||
       '#gk=' || 'Released' ||
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
       '#gk=' || 'Released' ||
       '#nr_of_rows=' || TO_CHAR(l_nr_of_rows);
      RAISE StpError;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF sqlcode <> 1 THEN
      l_sqlerrm := SUBSTR(SQLERRM,1,255);
   END IF;
   INSERT INTO uterror(client_id, applic, who, logdate, api_name, error_msg)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP,
                     'MeReleased' , l_sqlerrm );
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END MeReleased;

FUNCTION MePlannedEqType                    /* INTERNAL */
(a_ss_to           IN VARCHAR2)             /* VC2_TYPE */
RETURN NUMBER IS

l_svgk_value           UNAPIGEN.VC40_TABLE_TYPE;
l_nr_of_rows           INTEGER;
l_result               NUMBER;
l_gk_version           VARCHAR2(20);
l_planned_eq_type      VARCHAR2(20);

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

   BEGIN
      SELECT eq_tp
      INTO l_planned_eq_type
      FROM utmt
      WHERE (mt, version) = (SELECT me, mt_version
                             FROM utscme
                             WHERE sc = UNAPIEV.P_SC
                               AND pg = UNAPIEV.P_PG
                               AND pgnode = UNAPIEV.P_PGNODE
                               AND pa = UNAPIEV.P_PA
                               AND panode = UNAPIEV.P_PANODE
                               AND me = UNAPIEV.P_ME
                               AND menode = UNAPIEV.P_MENODE);
      l_svgk_value(1) := l_planned_eq_type;
      l_nr_of_rows := 1;
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
      l_nr_of_rows := 0;
   END;

   IF l_nr_of_rows > 0 THEN
      l_result := UNAPIAUT.DisableAllowModifyCheck('1');
      /* Argument gk_version is left empty */
      l_ret_code := UNAPIMEP.Save1ScMeGroupKey(UNAPIEV.P_SC,
                                     UNAPIEV.P_PG,UNAPIEV.P_PGNODE,
                                     UNAPIEV.P_PA,UNAPIEV.P_PANODE,
                                     UNAPIEV.P_ME,UNAPIEV.P_MENODE,
                                     'PlannedEqType', l_gk_version,
                                     l_svgk_value, l_nr_of_rows, NULL);
      l_result := UNAPIAUT.DisableAllowModifyCheck('0');
      IF UNAPIEV.P_EV_OUTPUT_ON THEN
         UNTRACE.LOG(
          'Save1ScMeGroupKey#return=' || TO_CHAR(l_ret_code) ||
          '#sc=' || UNAPIEV.P_SC ||
          '#pg=' || UNAPIEV.P_PG || '#pgnode=' || TO_CHAR(UNAPIEV.P_PGNODE) ||
          '#pa=' || UNAPIEV.P_PA || '#panode=' || TO_CHAR(UNAPIEV.P_PANODE) ||
          '#me=' || UNAPIEV.P_ME || '#menode=' || TO_CHAR(UNAPIEV.P_MENODE) ||
          '#gk=' || 'PlannedEqType' ||
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
          '#gk=' || 'PlannedEqType' ||
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
                     'MePlannedEqType' , l_sqlerrm );
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END MePlannedEqType;

FUNCTION MeAssignGkDefault                  /* INTERNAL */
(a_ss_to           IN VARCHAR2)             /* VC2_TYPE */
RETURN NUMBER IS

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name || '.MeAssignGkDefault';
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------
CURSOR lvq_gk IS
SELECT gk_entry
  FROM utsswl
 WHERE ss = a_ss_to
   AND entry_action = 'I'
   AND entry_tp = 'cf'
   AND use_value = 'MeAssignGkDefault';
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
l_found                BOOLEAN;
l_nr_of_rows           INTEGER;
l_value_list           UNAPIGEN.VC40_TABLE_TYPE;
l_gk_version           VARCHAR2(20);
l_rq_priority          VARCHAR2(40);
l_sc_priority          VARCHAR2(40);

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

   ---------------------------------------------------------------------------------------------
   -- Loop through all worklist assignment groupkeys with:
   -- status      = a_ss_to
   -- in          = 1
   -- type        = custom
   -- use_value   = MeAssignGkDefault
   ---------------------------------------------------------------------------------------------
   FOR lvr_gk IN lvq_gk LOOP
      ---------------------------------------------------------------------------------------------
      -- Retrieve default value of groupkey
      ---------------------------------------------------------------------------------------------
      SELECT NVL(default_value, '<< not found >>')
        INTO l_value_list(1)
        FROM utgkme
       WHERE gk = lvr_gk.gk_entry;
      ---------------------------------------------------------------------------------------------
      -- If not found, set it to null
      ---------------------------------------------------------------------------------------------
      IF l_value_list(1) = '<< not found >>' THEN
         l_value_list(1) := NULL;
      END IF;
      ---------------------------------------------------------------------------------------------
      -- Assign the groupkey
      ---------------------------------------------------------------------------------------------
      l_nr_of_rows := 1;
      /* Argument gk_version is left empty */
      l_ret_code := UNAPIMEP.Save1ScMeGroupKey( UNAPIEV.P_SC,
                                                UNAPIEV.P_PG,UNAPIEV.P_PGNODE,
                                                UNAPIEV.P_PA,UNAPIEV.P_PANODE,
                                                UNAPIEV.P_ME,UNAPIEV.P_MENODE,
                                                lvr_gk.gk_entry, l_gk_version,
                                                l_value_list, l_nr_of_rows, NULL);
      IF UNAPIEV.P_EV_OUTPUT_ON THEN
         DBMS_OUTPUT.PUT_LINE(
         'Save1ScMeGroupKey#return=' || TO_CHAR(l_ret_code) ||
         '#sc=' || UNAPIEV.P_SC ||
         '#pg=' || UNAPIEV.P_PG || '#pgnode=' || TO_CHAR(UNAPIEV.P_PGNODE) ||
         '#pa=' || UNAPIEV.P_PA || '#panode=' || TO_CHAR(UNAPIEV.P_PANODE) ||
         '#me=' || UNAPIEV.P_ME || '#menode=' || TO_CHAR(UNAPIEV.P_MENODE) ||
         '#gk=' || 'avMePriority' ||
         '#nr_of_rows=' || TO_CHAR(l_nr_of_rows));
      END IF;
      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         l_sqlerrm :=
         'Save1ScMeGroupKey#return=' || TO_CHAR(l_ret_code) ||
         '#sc=' || UNAPIEV.P_SC ||
         '#pg=' || UNAPIEV.P_PG || '#pgnode=' || TO_CHAR(UNAPIEV.P_PGNODE) ||
         '#pa=' || UNAPIEV.P_PA || '#panode=' || TO_CHAR(UNAPIEV.P_PANODE) ||
         '#me=' || UNAPIEV.P_ME || '#menode=' || TO_CHAR(UNAPIEV.P_MENODE) ||
         '#gk=' || 'avMePriority' ||
         '#nr_of_rows=' || TO_CHAR(l_nr_of_rows);
         RAISE StpError;
      END IF;
   END LOOP;

   RETURN( l_ret_code);

EXCEPTION
WHEN OTHERS THEN
   IF sqlcode <> 1 THEN
      l_sqlerrm := SUBSTR(SQLERRM,1,255);
   END IF;
   INSERT INTO uterror(client_id, applic, who, logdate, api_name, error_msg)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP,
                     'MePriority' , l_sqlerrm );
   RETURN(UNAPIGEN.DBERR_GENFAIL);

END MeAssignGkDefault;

FUNCTION GetVersion
  RETURN VARCHAR2
IS
BEGIN
  RETURN('06.07.00.00_13.00');
EXCEPTION
  WHEN OTHERS THEN
	 RETURN (NULL);
END GetVersion;

END unwlassign;
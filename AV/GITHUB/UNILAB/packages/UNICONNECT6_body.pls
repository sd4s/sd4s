create or replace PACKAGE BODY
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
uniconnect6 AS

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

P_CONV_FACTORS_LOADED     BOOLEAN;
P_CONV_FACTOR_less        VARCHAR2(40);
P_CONV_FACTOR_lessless    VARCHAR2(40);
P_CONV_FACTOR_high        VARCHAR2(40);
P_CONV_FACTOR_highhigh    VARCHAR2(40);
P_CONV_FACTOR_tilde       VARCHAR2(40);

FUNCTION GetVersion
   RETURN VARCHAR2
IS
BEGIN
   RETURN('06.07.00.00_00.13');
EXCEPTION
   WHEN OTHERS THEN
      RETURN (NULL);
END GetVersion;

FUNCTION InsertPg               /* INTERNAL */
(a_sc         IN    VARCHAR2,   /* VC20_TYPE */
 a_pg         IN    VARCHAR2,   /* VC20_TYPE */
 a_firstpos   IN    BOOLEAN,    /* BOOLEAN_TYPE */
 a_pgnode     OUT   NUMBER)     /* NUM_TYPE */
RETURN NUMBER IS

--local variables for SaveScPg
l_svscpg_sc                       UNAPIGEN.VC20_TABLE_TYPE;
l_svscpg_pg                       UNAPIGEN.VC20_TABLE_TYPE;
l_svscpg_pgnode                   UNAPIGEN.LONG_TABLE_TYPE;
l_svscpg_pp_version               UNAPIGEN.VC20_TABLE_TYPE;
l_svscpg_pp_key1                  UNAPIGEN.VC20_TABLE_TYPE;
l_svscpg_pp_key2                  UNAPIGEN.VC20_TABLE_TYPE;
l_svscpg_pp_key3                  UNAPIGEN.VC20_TABLE_TYPE;
l_svscpg_pp_key4                  UNAPIGEN.VC20_TABLE_TYPE;
l_svscpg_pp_key5                  UNAPIGEN.VC20_TABLE_TYPE;
l_svscpg_description              UNAPIGEN.VC40_TABLE_TYPE;
l_svscpg_value_f                  UNAPIGEN.FLOAT_TABLE_TYPE;
l_svscpg_value_s                  UNAPIGEN.VC40_TABLE_TYPE;
l_svscpg_unit                     UNAPIGEN.VC20_TABLE_TYPE;
l_svscpg_exec_start_date          UNAPIGEN.DATE_TABLE_TYPE;
l_svscpg_exec_end_date            UNAPIGEN.DATE_TABLE_TYPE;
l_svscpg_executor                 UNAPIGEN.VC20_TABLE_TYPE;
l_svscpg_planned_executor         UNAPIGEN.VC20_TABLE_TYPE;
l_svscpg_manually_entered         UNAPIGEN.CHAR1_TABLE_TYPE;
l_svscpg_assign_date              UNAPIGEN.DATE_TABLE_TYPE;
l_svscpg_assigned_by              UNAPIGEN.VC20_TABLE_TYPE;
l_svscpg_manually_added           UNAPIGEN.CHAR1_TABLE_TYPE;
l_svscpg_format                   UNAPIGEN.VC40_TABLE_TYPE;
l_svscpg_confirm_assign           UNAPIGEN.CHAR1_TABLE_TYPE;
l_svscpg_allow_any_pr             UNAPIGEN.CHAR1_TABLE_TYPE;
l_svscpg_never_create_methods     UNAPIGEN.CHAR1_TABLE_TYPE;
l_svscpg_delay                    UNAPIGEN.NUM_TABLE_TYPE;
l_svscpg_delay_unit               UNAPIGEN.VC20_TABLE_TYPE;
l_svscpg_pg_class                 UNAPIGEN.VC2_TABLE_TYPE;
l_svscpg_log_hs                   UNAPIGEN.CHAR1_TABLE_TYPE;
l_svscpg_log_hs_details           UNAPIGEN.CHAR1_TABLE_TYPE;
l_svscpg_lc                       UNAPIGEN.VC2_TABLE_TYPE;
l_svscpg_lc_version               UNAPIGEN.VC20_TABLE_TYPE;
l_svscpg_modify_flag              UNAPIGEN.NUM_TABLE_TYPE;
l_svscpg_nr_of_rows               NUMBER;
l_svscpg_reanalysis               UNAPIGEN.NUM_TABLE_TYPE;

--local variables for InitScPg
l_initscpg_sc                     UNAPIGEN.VC20_TABLE_TYPE;
l_initscpg_pg                     UNAPIGEN.VC20_TABLE_TYPE;
l_initscpg_pgnode                 UNAPIGEN.LONG_TABLE_TYPE;
l_initscpg_pp_version             UNAPIGEN.VC20_TABLE_TYPE;
l_initscpg_description            UNAPIGEN.VC40_TABLE_TYPE;
l_initscpg_value_f                UNAPIGEN.FLOAT_TABLE_TYPE;
l_initscpg_value_s                UNAPIGEN.VC40_TABLE_TYPE;
l_initscpg_unit                   UNAPIGEN.VC20_TABLE_TYPE;
l_initscpg_exec_start_date        UNAPIGEN.DATE_TABLE_TYPE;
l_initscpg_exec_end_date          UNAPIGEN.DATE_TABLE_TYPE;
l_initscpg_executor               UNAPIGEN.VC20_TABLE_TYPE;
l_initscpg_planned_executor       UNAPIGEN.VC20_TABLE_TYPE;
l_initscpg_manually_entered       UNAPIGEN.CHAR1_TABLE_TYPE;
l_initscpg_assign_date            UNAPIGEN.DATE_TABLE_TYPE;
l_initscpg_assigned_by            UNAPIGEN.VC20_TABLE_TYPE;
l_initscpg_manually_added         UNAPIGEN.CHAR1_TABLE_TYPE;
l_initscpg_format                 UNAPIGEN.VC40_TABLE_TYPE;
l_initscpg_confirm_assign         UNAPIGEN.CHAR1_TABLE_TYPE;
l_initscpg_allow_any_pr           UNAPIGEN.CHAR1_TABLE_TYPE;
l_initscpg_never_create_me        UNAPIGEN.CHAR1_TABLE_TYPE;   -- 'l_initscpg_never_create_me'
                                                               -- instead of
                                                               -- 'l_initscpg_never_create_methods'
                                                               -- because max. length = 30 characters
l_initscpg_delay                  UNAPIGEN.NUM_TABLE_TYPE;
l_initscpg_delay_unit             UNAPIGEN.VC20_TABLE_TYPE;
l_initscpg_pg_class               UNAPIGEN.VC2_TABLE_TYPE;
l_initscpg_log_hs                 UNAPIGEN.CHAR1_TABLE_TYPE;
l_initscpg_log_hs_details         UNAPIGEN.CHAR1_TABLE_TYPE;
l_initscpg_lc                     UNAPIGEN.VC2_TABLE_TYPE;
l_initscpg_lc_version             UNAPIGEN.VC20_TABLE_TYPE;
l_initscpg_modify_flag            UNAPIGEN.NUM_TABLE_TYPE;
l_initscpg_nr_of_rows             NUMBER;
l_initscpg_reanalysis             UNAPIGEN.NUM_TABLE_TYPE;


CURSOR l_firstpg_cursor (a_sc VARCHAR2) IS
   SELECT pg, pgnode
   FROM utscpg
   WHERE sc = a_sc
   ORDER BY pgnode ASC;
l_firstpg_rec   l_firstpg_cursor%ROWTYPE;


   /* Auxiliary functions for parameter groups creation */
   /*---------------------------------------------------*/
   PROCEDURE AddFirstPgAfter IS
   BEGIN

      --This row is always added even when it is not required
      --This will not interfere with node calcualtions

      OPEN l_firstpg_cursor(a_sc);
      FETCH l_firstpg_cursor
      INTO l_firstpg_rec;
      IF l_firstpg_cursor%FOUND THEN
         l_svscpg_nr_of_rows := l_svscpg_nr_of_rows + 1;
         l_svscpg_sc(l_svscpg_nr_of_rows) := a_sc;
         l_svscpg_pg(l_svscpg_nr_of_rows) :=  l_firstpg_rec.pg ;
         l_svscpg_pgnode(l_svscpg_nr_of_rows) :=  l_firstpg_rec.pgnode ;
         l_svscpg_modify_flag(l_svscpg_nr_of_rows) := UNAPIGEN.DBERR_SUCCESS;
      END IF;
      CLOSE l_firstpg_cursor;

   END AddFirstPgAfter;

   PROCEDURE SaveScParameterGroups IS

      l_pgnode_found BOOLEAN;

   BEGIN
      IF a_firstpos THEN
         AddFirstPgAfter;
      END IF;

      l_ret_code := UNAPIPG.SaveScParameterGroup(l_svscpg_sc, l_svscpg_pg,
                                      l_svscpg_pgnode, l_svscpg_pp_version,
                                      l_svscpg_pp_key1, l_svscpg_pp_key2, l_svscpg_pp_key3,
                                      l_svscpg_pp_key4, l_svscpg_pp_key5, l_svscpg_description,
                                      l_svscpg_value_f, l_svscpg_value_s, l_svscpg_unit,
                                      l_svscpg_exec_start_date, l_svscpg_exec_end_date,
                                      l_svscpg_executor, l_svscpg_planned_executor,
                                      l_svscpg_manually_entered,
                                      l_svscpg_assign_date, l_svscpg_assigned_by,
                                      l_svscpg_manually_added, l_svscpg_format,
                                      l_svscpg_confirm_assign, l_svscpg_allow_any_pr,
                                      l_svscpg_never_create_methods,
                                      l_svscpg_delay, l_svscpg_delay_unit,
                                      l_svscpg_pg_class, l_svscpg_log_hs, l_svscpg_log_hs_details,
                                      l_svscpg_lc, l_svscpg_lc_version, l_svscpg_modify_flag,
                                      l_svscpg_nr_of_rows, 'Handling method output');

      IF l_ret_code = UNAPIGEN.DBERR_PARTIALSAVE THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_SUCCESS; --will be ignored
      ELSIF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.P_TXN_ERROR := l_ret_code;
         RAISE StpError;
      END IF;

      a_pgnode := l_svscpg_pgnode(1);

   END SaveScParameterGroups;

   PROCEDURE InternalInitScParameterGroup IS
   BEGIN
      -- The following 2 functions must be consistent: - uniconnect6.InternalInitScParameterGroup
      --                                               - unapime5.InternalInitScParameterGroup

      l_initscpg_nr_of_rows := NULL;
      l_ret_code := UNAPIPG.InitScParameterGroup(a_pg, NULL,
                                      ' ', ' ', ' ', ' ', ' ',
                                      NULL, a_sc,
                                      l_initscpg_pp_version, l_initscpg_description,
                                      l_initscpg_value_f, l_initscpg_value_s, l_initscpg_unit,
                                      l_initscpg_exec_start_date, l_initscpg_exec_end_date,
                                      l_initscpg_executor, l_initscpg_planned_executor,
                                      l_initscpg_manually_entered,
                                      l_initscpg_assign_date, l_initscpg_assigned_by,
                                      l_initscpg_manually_added, l_initscpg_format,
                                      l_initscpg_confirm_assign, l_initscpg_allow_any_pr,
                                      l_initscpg_never_create_me,
                                      l_initscpg_delay, l_initscpg_delay_unit,
                                      l_initscpg_reanalysis, l_initscpg_pg_class,
                                      l_initscpg_log_hs, l_initscpg_log_hs_details,
                                      l_initscpg_lc, l_initscpg_lc_version, l_initscpg_nr_of_rows);

      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         IF l_ret_code <> UNAPIGEN.DBERR_NOOBJECT THEN
            UNAPIGEN.P_TXN_ERROR  := l_ret_code;
            RAISE StpError;
         ELSE
            /* parameter group has to be created, even if not existing in config */
            l_initscpg_pp_version(1) := UNVERSION.P_NO_VERSION;
            l_initscpg_description(1) := a_pg;
            l_initscpg_value_f(1) := NULL;
            l_initscpg_value_s(1) := NULL;
            l_initscpg_unit(1) := NULL;
            l_initscpg_exec_start_date(1) := NULL;
            l_initscpg_exec_end_date(1) := NULL;
            l_initscpg_executor(1) := NULL;
            l_initscpg_planned_executor(1) := NULL;
            l_initscpg_manually_entered(1) := '0';
            l_initscpg_assign_date(1) := CURRENT_TIMESTAMP;
            l_initscpg_assigned_by(1) := UNAPIGEN.P_USER;
            l_initscpg_manually_added(1) := '0';
            l_initscpg_format(1) := NULL;
            l_initscpg_confirm_assign(1) := '0';
            l_initscpg_allow_any_pr(1) := '1';
            l_initscpg_never_create_me(1) := '0';
            l_initscpg_delay(1) := 0;
            l_initscpg_delay_unit(1) := 'DD';
            l_initscpg_reanalysis(1) := 0;
            l_initscpg_pg_class(1) := NULL;
            l_initscpg_log_hs(1) := '0';
            l_initscpg_log_hs_details(1) := '0';
            l_initscpg_lc(1) := NULL;
            l_initscpg_lc_version(1) := NULL;
            l_initscpg_nr_of_rows := 1;
         END IF;
      END IF;

      /*-------------------------------------------------------------------------------------*/
      /* The number of rows returned by InitScParameterGroup will be forced to 1             */
      /* This is necessary since the node are unique for the same object_id in this function */
      /* The configured number of measurements will be strictly ignored                      */
      /*-------------------------------------------------------------------------------------*/
      IF l_initscpg_nr_of_rows > 1 THEN
         l_initscpg_nr_of_rows := 1;
      END IF;

      --Add the row to l_svscpg arrays
      l_svscpg_nr_of_rows := l_svscpg_nr_of_rows + 1;

      l_svscpg_sc(l_svscpg_nr_of_rows) := a_sc;
      l_svscpg_pg(l_svscpg_nr_of_rows) := a_pg;
      l_svscpg_pgnode(l_svscpg_nr_of_rows) := NULL;
      l_svscpg_modify_flag(l_svscpg_nr_of_rows) := UNAPIGEN.MOD_FLAG_INSERT;
      l_svscpg_value_f(l_svscpg_nr_of_rows) := NULL;
      l_svscpg_value_s(l_svscpg_nr_of_rows) := NULL;
      l_svscpg_pp_version(l_svscpg_nr_of_rows) := l_initscpg_pp_version(1) ;
      l_svscpg_pp_key1(l_svscpg_nr_of_rows) := ' ';
      l_svscpg_pp_key2(l_svscpg_nr_of_rows) := ' ';
      l_svscpg_pp_key3(l_svscpg_nr_of_rows) := ' ';
      l_svscpg_pp_key4(l_svscpg_nr_of_rows) := ' ';
      l_svscpg_pp_key5(l_svscpg_nr_of_rows) := ' ';
      l_svscpg_description(l_svscpg_nr_of_rows) := l_initscpg_description(1) ;
      l_svscpg_unit(l_svscpg_nr_of_rows) := l_initscpg_unit(1) ;
      l_svscpg_exec_start_date(l_svscpg_nr_of_rows) := l_initscpg_exec_start_date(1) ;
      l_svscpg_exec_end_date(l_svscpg_nr_of_rows) := l_initscpg_exec_end_date(1) ;
      l_svscpg_executor(l_svscpg_nr_of_rows) := l_initscpg_executor(1) ;
      l_svscpg_planned_executor(l_svscpg_nr_of_rows) := l_initscpg_planned_executor(1) ;
      l_svscpg_manually_entered(l_svscpg_nr_of_rows) := l_initscpg_manually_entered(1) ;
      l_svscpg_assign_date(l_svscpg_nr_of_rows) := l_initscpg_assign_date(1) ;
      l_svscpg_assigned_by(l_svscpg_nr_of_rows) := l_initscpg_assigned_by(1) ;
      l_svscpg_manually_added(l_svscpg_nr_of_rows) := l_initscpg_manually_added(1) ;
      l_svscpg_format(l_svscpg_nr_of_rows) := l_initscpg_format(1) ;
      l_svscpg_confirm_assign(l_svscpg_nr_of_rows) := l_initscpg_confirm_assign(1) ;
      l_svscpg_allow_any_pr(l_svscpg_nr_of_rows) := l_initscpg_allow_any_pr(1) ;
      l_svscpg_never_create_methods(l_svscpg_nr_of_rows) := l_initscpg_never_create_me(1) ;
      l_svscpg_delay(l_svscpg_nr_of_rows) := l_initscpg_delay(1) ;
      l_svscpg_delay_unit(l_svscpg_nr_of_rows) := l_initscpg_delay_unit(1) ;
      l_svscpg_pg_class(l_svscpg_nr_of_rows) := l_initscpg_pg_class(1) ;
      l_svscpg_log_hs(l_svscpg_nr_of_rows) := l_initscpg_log_hs(1) ;
      l_svscpg_log_hs_details(l_svscpg_nr_of_rows) := l_initscpg_log_hs_details(1) ;
      l_svscpg_lc(l_svscpg_nr_of_rows) := l_initscpg_lc(1) ;
      l_svscpg_lc_version(l_svscpg_nr_of_rows) := l_initscpg_lc_version(1) ;

   END InternalInitScParameterGroup;

BEGIN

   l_svscpg_nr_of_rows := 0;
   InternalInitScParameterGroup;
   SaveScParameterGroups;
   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   RETURN(UNAPIGEN.P_TXN_ERROR);
END InsertPg;

FUNCTION InsertPa             /* INTERNAL */
(a_sc         IN    VARCHAR2,   /* VC20_TYPE */
 a_pg         IN    VARCHAR2,   /* VC20_TYPE */
 a_pgnode     IN    NUMBER,     /* NUM_TYPE */
 a_pa         IN    VARCHAR2,   /* VC20_TYPE */
 a_firstpos   IN    BOOLEAN,    /* BOOLEAN_TYPE */
 a_panode     OUT   NUMBER)     /* NUM_TYPE */
RETURN NUMBER IS

--local variables for SaveScPa
l_svscpa_sc                   UNAPIGEN.VC20_TABLE_TYPE;
l_svscpa_pg                   UNAPIGEN.VC20_TABLE_TYPE;
l_svscpa_pgnode               UNAPIGEN.LONG_TABLE_TYPE;
l_svscpa_pa                   UNAPIGEN.VC20_TABLE_TYPE;
l_svscpa_panode               UNAPIGEN.LONG_TABLE_TYPE;
l_svscpa_pr_version           UNAPIGEN.VC20_TABLE_TYPE;
l_svscpa_description          UNAPIGEN.VC40_TABLE_TYPE;
l_svscpa_value_f              UNAPIGEN.FLOAT_TABLE_TYPE;
l_svscpa_value_s              UNAPIGEN.VC40_TABLE_TYPE;
l_svscpa_unit                 UNAPIGEN.VC20_TABLE_TYPE;
l_svscpa_exec_start_date      UNAPIGEN.DATE_TABLE_TYPE;
l_svscpa_exec_end_date        UNAPIGEN.DATE_TABLE_TYPE;
l_svscpa_executor             UNAPIGEN.VC20_TABLE_TYPE;
l_svscpa_planned_executor     UNAPIGEN.VC20_TABLE_TYPE;
l_svscpa_manually_entered     UNAPIGEN.CHAR1_TABLE_TYPE;
l_svscpa_assign_date          UNAPIGEN.DATE_TABLE_TYPE;
l_svscpa_assigned_by          UNAPIGEN.VC20_TABLE_TYPE;
l_svscpa_manually_added       UNAPIGEN.CHAR1_TABLE_TYPE;
l_svscpa_format               UNAPIGEN.VC40_TABLE_TYPE;
l_svscpa_td_info              UNAPIGEN.NUM_TABLE_TYPE;
l_svscpa_td_info_unit         UNAPIGEN.VC20_TABLE_TYPE;
l_svscpa_confirm_uid          UNAPIGEN.CHAR1_TABLE_TYPE;
l_svscpa_allow_any_me         UNAPIGEN.CHAR1_TABLE_TYPE;
l_svscpa_delay                UNAPIGEN.NUM_TABLE_TYPE;
l_svscpa_delay_unit           UNAPIGEN.VC20_TABLE_TYPE;
l_svscpa_min_nr_results       UNAPIGEN.NUM_TABLE_TYPE;
l_svscpa_calc_method          UNAPIGEN.CHAR1_TABLE_TYPE;
l_svscpa_calc_cf              UNAPIGEN.VC20_TABLE_TYPE;
l_svscpa_alarm_order          UNAPIGEN.VC3_TABLE_TYPE;
l_svscpa_valid_specsa         UNAPIGEN.CHAR1_TABLE_TYPE;
l_svscpa_valid_specsb         UNAPIGEN.CHAR1_TABLE_TYPE;
l_svscpa_valid_specsc         UNAPIGEN.CHAR1_TABLE_TYPE;
l_svscpa_valid_limitsa        UNAPIGEN.CHAR1_TABLE_TYPE;
l_svscpa_valid_limitsb        UNAPIGEN.CHAR1_TABLE_TYPE;
l_svscpa_valid_limitsc        UNAPIGEN.CHAR1_TABLE_TYPE;
l_svscpa_valid_targeta        UNAPIGEN.CHAR1_TABLE_TYPE;
l_svscpa_valid_targetb        UNAPIGEN.CHAR1_TABLE_TYPE;
l_svscpa_valid_targetc        UNAPIGEN.CHAR1_TABLE_TYPE;
l_svscpa_mt                   UNAPIGEN.VC20_TABLE_TYPE;
l_svscpa_mt_version           UNAPIGEN.VC20_TABLE_TYPE;
l_svscpa_mt_nr_measur         UNAPIGEN.NUM_TABLE_TYPE;
l_svscpa_log_exceptions       UNAPIGEN.CHAR1_TABLE_TYPE;
l_svscpa_pa_class             UNAPIGEN.VC2_TABLE_TYPE;
l_svscpa_log_hs               UNAPIGEN.CHAR1_TABLE_TYPE;
l_svscpa_log_hs_details       UNAPIGEN.CHAR1_TABLE_TYPE;
l_svscpa_lc                   UNAPIGEN.VC2_TABLE_TYPE;
l_svscpa_lc_version           UNAPIGEN.VC20_TABLE_TYPE;
l_svscpa_reanalysis           UNAPIGEN.NUM_TABLE_TYPE;
l_svscpa_modify_flag          UNAPIGEN.NUM_TABLE_TYPE;
l_svscpa_nr_of_rows           NUMBER;

--local variables for InitScPa
l_initscpa_sc                 UNAPIGEN.VC20_TABLE_TYPE;
l_initscpa_pg                 UNAPIGEN.VC20_TABLE_TYPE;
l_initscpa_pgnode             UNAPIGEN.LONG_TABLE_TYPE;
l_initscpa_pa                 UNAPIGEN.VC20_TABLE_TYPE;
l_initscpa_panode             UNAPIGEN.LONG_TABLE_TYPE;
l_initscpa_pr_version         UNAPIGEN.VC20_TABLE_TYPE;
l_initscpa_description        UNAPIGEN.VC40_TABLE_TYPE;
l_initscpa_value_f            UNAPIGEN.FLOAT_TABLE_TYPE;
l_initscpa_value_s            UNAPIGEN.VC40_TABLE_TYPE;
l_initscpa_unit               UNAPIGEN.VC20_TABLE_TYPE;
l_initscpa_exec_start_date    UNAPIGEN.DATE_TABLE_TYPE;
l_initscpa_exec_end_date      UNAPIGEN.DATE_TABLE_TYPE;
l_initscpa_executor           UNAPIGEN.VC20_TABLE_TYPE;
l_initscpa_planned_executor   UNAPIGEN.VC20_TABLE_TYPE;
l_initscpa_manually_entered   UNAPIGEN.CHAR1_TABLE_TYPE;
l_initscpa_assign_date        UNAPIGEN.DATE_TABLE_TYPE;
l_initscpa_assigned_by        UNAPIGEN.VC20_TABLE_TYPE;
l_initscpa_manually_added     UNAPIGEN.CHAR1_TABLE_TYPE;
l_initscpa_format             UNAPIGEN.VC40_TABLE_TYPE;
l_initscpa_td_info            UNAPIGEN.NUM_TABLE_TYPE;
l_initscpa_td_info_unit       UNAPIGEN.VC20_TABLE_TYPE;
l_initscpa_confirm_uid        UNAPIGEN.CHAR1_TABLE_TYPE;
l_initscpa_allow_any_me       UNAPIGEN.CHAR1_TABLE_TYPE;
l_initscpa_delay              UNAPIGEN.NUM_TABLE_TYPE;
l_initscpa_delay_unit         UNAPIGEN.VC20_TABLE_TYPE;
l_initscpa_min_nr_results     UNAPIGEN.NUM_TABLE_TYPE;
l_initscpa_calc_method        UNAPIGEN.CHAR1_TABLE_TYPE;
l_initscpa_calc_cf            UNAPIGEN.VC20_TABLE_TYPE;
l_initscpa_alarm_order        UNAPIGEN.VC3_TABLE_TYPE;
l_initscpa_valid_specsa       UNAPIGEN.CHAR1_TABLE_TYPE;
l_initscpa_valid_specsb       UNAPIGEN.CHAR1_TABLE_TYPE;
l_initscpa_valid_specsc       UNAPIGEN.CHAR1_TABLE_TYPE;
l_initscpa_valid_limitsa      UNAPIGEN.CHAR1_TABLE_TYPE;
l_initscpa_valid_limitsb      UNAPIGEN.CHAR1_TABLE_TYPE;
l_initscpa_valid_limitsc      UNAPIGEN.CHAR1_TABLE_TYPE;
l_initscpa_valid_targeta      UNAPIGEN.CHAR1_TABLE_TYPE;
l_initscpa_valid_targetb      UNAPIGEN.CHAR1_TABLE_TYPE;
l_initscpa_valid_targetc      UNAPIGEN.CHAR1_TABLE_TYPE;
l_initscpa_mt                 UNAPIGEN.VC20_TABLE_TYPE;
l_initscpa_mt_version         UNAPIGEN.VC20_TABLE_TYPE;
l_initscpa_mt_nr_measur       UNAPIGEN.NUM_TABLE_TYPE;
l_initscpa_log_exceptions     UNAPIGEN.CHAR1_TABLE_TYPE;
l_initscpa_pa_class           UNAPIGEN.VC2_TABLE_TYPE;
l_initscpa_log_hs             UNAPIGEN.CHAR1_TABLE_TYPE;
l_initscpa_log_hs_details     UNAPIGEN.CHAR1_TABLE_TYPE;
l_initscpa_lc                 UNAPIGEN.VC2_TABLE_TYPE;
l_initscpa_lc_version         UNAPIGEN.VC20_TABLE_TYPE;
l_initscpa_reanalysis         UNAPIGEN.NUM_TABLE_TYPE;
l_initscpa_modify_flag        UNAPIGEN.NUM_TABLE_TYPE;
l_initscpa_nr_of_rows         NUMBER;


CURSOR l_firstpa_cursor (a_sc VARCHAR2, a_pg VARCHAR2, a_pgnode NUMBER) IS
   SELECT pa, panode
   FROM utscpa
   WHERE sc = a_sc
     AND pg = a_pg
     AND pgnode = a_pgnode
   ORDER BY panode ASC;
l_firstpa_rec  l_firstpa_cursor%ROWTYPE;

   /* Auxiliary functions for parameter creation */
   /*--------------------------------------------*/
   PROCEDURE AddFirstPaAfter IS
   BEGIN

      OPEN l_firstpa_cursor(a_sc, a_pg, a_pgnode);
      FETCH l_firstpa_cursor
      INTO l_firstpa_rec;
      IF l_firstpa_cursor%FOUND THEN
         l_svscpa_nr_of_rows := l_svscpa_nr_of_rows + 1;
         l_svscpa_sc(l_svscpa_nr_of_rows) := a_sc;
         l_svscpa_pg(l_svscpa_nr_of_rows) :=  a_pg ;
         l_svscpa_pgnode(l_svscpa_nr_of_rows) :=  a_pgnode ;
         l_svscpa_pa(l_svscpa_nr_of_rows) :=  l_firstpa_rec.pa ;
         l_svscpa_panode(l_svscpa_nr_of_rows) :=  l_firstpa_rec.panode ;
         l_svscpa_modify_flag(l_svscpa_nr_of_rows) := UNAPIGEN.DBERR_SUCCESS;
      END IF;
      CLOSE l_firstpa_cursor;
   END AddFirstPaAfter;

   PROCEDURE SaveScParameters IS

      l_panode_found BOOLEAN;

   BEGIN
      IF a_firstpos THEN
         AddFirstPaAfter;
      END IF;

      l_ret_code := UNAPIPA.SaveScParameter(UNAPIGEN.ALARMS_NOT_HANDLED, l_svscpa_sc,
                                 l_svscpa_pg, l_svscpa_pgnode, l_svscpa_pa,
                                 l_svscpa_panode, l_svscpa_pr_version, l_svscpa_description,
                                 l_svscpa_value_f, l_svscpa_value_s,
                                 l_svscpa_unit, l_svscpa_exec_start_date,
                                 l_svscpa_exec_end_date, l_svscpa_executor,
                                 l_svscpa_planned_executor,
                                 l_svscpa_manually_entered,
                                 l_svscpa_assign_date, l_svscpa_assigned_by,
                                 l_svscpa_manually_added, l_svscpa_format,
                                 l_svscpa_td_info, l_svscpa_td_info_unit,
                                 l_svscpa_confirm_uid, l_svscpa_allow_any_me,
                                 l_svscpa_delay, l_svscpa_delay_unit,
                                 l_svscpa_min_nr_results, l_svscpa_calc_method,
                                 l_svscpa_calc_cf, l_svscpa_alarm_order,
                                 l_svscpa_valid_specsa, l_svscpa_valid_specsb,
                                 l_svscpa_valid_specsc, l_svscpa_valid_limitsa,
                                 l_svscpa_valid_limitsb, l_svscpa_valid_limitsc,
                                 l_svscpa_valid_targeta, l_svscpa_valid_targetb,
                                 l_svscpa_valid_targetc, l_svscpa_mt, l_svscpa_mt_version,
                                 l_svscpa_mt_nr_measur, l_svscpa_log_exceptions,
                                 l_svscpa_pa_class, l_svscpa_log_hs, l_svscpa_log_hs_details,
                                 l_svscpa_lc, l_svscpa_lc_version, l_svscpa_modify_flag,
                                 l_svscpa_nr_of_rows, 'Handling method output');
      IF l_ret_code IN (UNAPIGEN.DBERR_PARTIALSAVE, UNAPIGEN.DBERR_PARTIALCHARTSAVE) THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_SUCCESS; --will be ignored
      ELSIF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.P_TXN_ERROR := l_ret_code;
         RAISE StpError;
      END IF;

      a_panode := l_svscpa_panode(1);

   END SaveScParameters;

   PROCEDURE InternalInitScParameter IS
   l_pp_version VARCHAR2(20);
   BEGIN
      -- The following 2 functions must be consistent: - uniconnect6.InternalInitScParameter
      --                                               - unapime5.InternalInitScParameter

      l_initscpa_nr_of_rows := NULL;
      l_pp_version := NULL;
      --pp_key[1-5] left empty since pgnode is known
      l_ret_code := UNAPIPA.InitScParameter(a_pa, NULL, NULL, a_sc, a_pg,
                                 a_pgnode, l_pp_version, ' ', ' ', ' ', ' ', ' ',
                                 l_initscpa_pr_version, l_initscpa_description,
                                 l_initscpa_value_f, l_initscpa_value_s,
                                 l_initscpa_unit, l_initscpa_exec_start_date,
                                 l_initscpa_exec_end_date, l_initscpa_executor,
                                 l_initscpa_planned_executor,
                                 l_initscpa_manually_entered,
                                 l_initscpa_assign_date, l_initscpa_assigned_by,
                                 l_initscpa_manually_added, l_initscpa_format,
                                 l_initscpa_td_info, l_initscpa_td_info_unit,
                                 l_initscpa_confirm_uid, l_initscpa_allow_any_me,
                                 l_initscpa_delay, l_initscpa_delay_unit,
                                 l_initscpa_min_nr_results, l_initscpa_calc_method,
                                 l_initscpa_calc_cf, l_initscpa_alarm_order,
                                 l_initscpa_valid_specsa, l_initscpa_valid_specsb,
                                 l_initscpa_valid_specsc, l_initscpa_valid_limitsa,
                                 l_initscpa_valid_limitsb, l_initscpa_valid_limitsc,
                                 l_initscpa_valid_targeta, l_initscpa_valid_targetb,
                                 l_initscpa_valid_targetc, l_initscpa_mt, l_initscpa_mt_version,
                                 l_initscpa_mt_nr_measur, l_initscpa_log_exceptions,
                                 l_initscpa_reanalysis, l_initscpa_pa_class,
                                 l_initscpa_log_hs, l_initscpa_log_hs_details,
                                 l_initscpa_lc, l_initscpa_lc_version,
                                 l_initscpa_nr_of_rows);

      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         IF l_ret_code <> UNAPIGEN.DBERR_NOOBJECT THEN
            UNAPIGEN.P_TXN_ERROR  := l_ret_code;
            RAISE StpError;
         ELSE
            /* parameter has to be create, even if not existing in config */
            l_initscpa_pr_version(1) := UNVERSION.P_NO_VERSION;
            l_initscpa_description(1) := a_pa;
            l_initscpa_unit(1) := NULL;
            l_initscpa_exec_start_date(1) := NULL;
            l_initscpa_exec_end_date(1) := NULL;
            l_initscpa_executor(1) := NULL;
            l_initscpa_planned_executor(1) := NULL;
            l_initscpa_manually_entered(1) := '0';
            l_initscpa_assign_date(1) := CURRENT_TIMESTAMP;
            l_initscpa_assigned_by(1) := UNAPIGEN.P_USER;
            l_initscpa_manually_added(1) := '0';
            l_initscpa_format(1) := NULL;
            l_initscpa_td_info(1) := 0;
            l_initscpa_td_info_unit(1) := 'DD';
            l_initscpa_confirm_uid(1) := '0';
            l_initscpa_allow_any_me(1) := '0';
            l_initscpa_delay(1) := 0;
            l_initscpa_delay_unit(1) := 'DD';
            l_initscpa_min_nr_results(1) := 1;
            l_initscpa_calc_method(1) := 'N';
            l_initscpa_calc_cf(1) := NULL;
            l_initscpa_alarm_order(1) := NULL;
            l_initscpa_valid_specsa(1) := NULL;
            l_initscpa_valid_specsb(1) := NULL;
            l_initscpa_valid_specsc(1) := NULL;
            l_initscpa_valid_limitsa(1) := NULL;
            l_initscpa_valid_limitsb(1) := NULL;
            l_initscpa_valid_limitsc(1) := NULL;
            l_initscpa_valid_targeta(1) := NULL;
            l_initscpa_valid_targetb(1) := NULL;
            l_initscpa_valid_targetc(1) := NULL;
            l_initscpa_mt(1) := NULL;
            l_initscpa_mt_version(1) := NULL;
            l_initscpa_mt_nr_measur(1) := NULL;
            l_initscpa_log_exceptions(1) := '0';
            l_initscpa_pa_class(1) := NULL;
            l_initscpa_log_hs(1) := '0';
            l_initscpa_log_hs_details(1) := '0';
            l_initscpa_lc(1) := NULL;
            l_initscpa_lc_version(1) := NULL;
            l_initscpa_nr_of_rows := 1;
         END IF;
      END IF;

      /*-------------------------------------------------------------------------------------*/
      /* The number of rows returned by InitScParameter will be forced to 1                  */
      /* This is necessary since the node are unique for the same object_id in this function */
      /* The configured number of measurements will be strictly ignored                      */
      /*-------------------------------------------------------------------------------------*/
      IF l_initscpa_nr_of_rows > 1 THEN
         l_initscpa_nr_of_rows := 1;
      END IF;

      --Add the row to l_svscpa arrays
      l_svscpa_nr_of_rows := l_svscpa_nr_of_rows + 1;

      l_svscpa_sc(l_svscpa_nr_of_rows) := a_sc;
      l_svscpa_pg(l_svscpa_nr_of_rows) := a_pg;
      l_svscpa_pgnode(l_svscpa_nr_of_rows) := a_pgnode;
      l_svscpa_pa(l_svscpa_nr_of_rows) := a_pa;
      l_svscpa_panode(l_svscpa_nr_of_rows) := NULL;
      l_svscpa_modify_flag(l_svscpa_nr_of_rows) := UNAPIGEN.MOD_FLAG_INSERT;
      l_svscpa_value_f(l_svscpa_nr_of_rows) := NULL;
      l_svscpa_value_s(l_svscpa_nr_of_rows) := NULL;
      l_svscpa_pr_version(l_svscpa_nr_of_rows) := l_initscpa_pr_version(1) ;
      l_svscpa_description(l_svscpa_nr_of_rows) := l_initscpa_description(1) ;
      l_svscpa_unit(l_svscpa_nr_of_rows) := l_initscpa_unit(1) ;
      l_svscpa_exec_start_date(l_svscpa_nr_of_rows) := l_initscpa_exec_start_date(1) ;
      l_svscpa_exec_end_date(l_svscpa_nr_of_rows) := l_initscpa_exec_end_date(1) ;
      l_svscpa_executor(l_svscpa_nr_of_rows) := l_initscpa_executor(1) ;
      l_svscpa_planned_executor(l_svscpa_nr_of_rows) := l_initscpa_planned_executor(1) ;
      l_svscpa_manually_entered(l_svscpa_nr_of_rows) := l_initscpa_manually_entered(1) ;
      l_svscpa_assign_date(l_svscpa_nr_of_rows) := l_initscpa_assign_date(1) ;
      l_svscpa_assigned_by(l_svscpa_nr_of_rows) := l_initscpa_assigned_by(1) ;
      l_svscpa_manually_added(l_svscpa_nr_of_rows) := l_initscpa_manually_added(1) ;
      l_svscpa_format(l_svscpa_nr_of_rows) := l_initscpa_format(1) ;
      l_svscpa_td_info(l_svscpa_nr_of_rows) := l_initscpa_td_info(1) ;
      l_svscpa_td_info_unit(l_svscpa_nr_of_rows) := l_initscpa_td_info_unit(1) ;
      l_svscpa_confirm_uid(l_svscpa_nr_of_rows) := l_initscpa_confirm_uid(1) ;
      l_svscpa_allow_any_me(l_svscpa_nr_of_rows) := l_initscpa_allow_any_me(1) ;
      l_svscpa_delay(l_svscpa_nr_of_rows) := l_initscpa_delay(1) ;
      l_svscpa_delay_unit(l_svscpa_nr_of_rows) := l_initscpa_delay_unit(1) ;
      l_svscpa_min_nr_results(l_svscpa_nr_of_rows) := l_initscpa_min_nr_results(1) ;
      l_svscpa_calc_method(l_svscpa_nr_of_rows) := l_initscpa_calc_method(1) ;
      l_svscpa_calc_cf(l_svscpa_nr_of_rows) := l_initscpa_calc_cf(1) ;
      l_svscpa_alarm_order(l_svscpa_nr_of_rows) := l_initscpa_alarm_order(1) ;
      l_svscpa_valid_specsa(l_svscpa_nr_of_rows) := l_initscpa_valid_specsa(1) ;
      l_svscpa_valid_specsb(l_svscpa_nr_of_rows) := l_initscpa_valid_specsb(1) ;
      l_svscpa_valid_specsc(l_svscpa_nr_of_rows) := l_initscpa_valid_specsc(1) ;
      l_svscpa_valid_limitsa(l_svscpa_nr_of_rows) := l_initscpa_valid_limitsa(1) ;
      l_svscpa_valid_limitsb(l_svscpa_nr_of_rows) := l_initscpa_valid_limitsb(1) ;
      l_svscpa_valid_limitsc(l_svscpa_nr_of_rows) := l_initscpa_valid_limitsc(1) ;
      l_svscpa_valid_targeta(l_svscpa_nr_of_rows) := l_initscpa_valid_targeta(1) ;
      l_svscpa_valid_targetb(l_svscpa_nr_of_rows) := l_initscpa_valid_targetb(1) ;
      l_svscpa_valid_targetc(l_svscpa_nr_of_rows) := l_initscpa_valid_targetc(1) ;
      l_svscpa_mt(l_svscpa_nr_of_rows) := l_initscpa_mt(1) ;
      l_svscpa_mt_version(l_svscpa_nr_of_rows) := l_initscpa_mt_version(1) ;
      l_svscpa_mt_nr_measur(l_svscpa_nr_of_rows) := l_initscpa_mt_nr_measur(1) ;
      l_svscpa_log_exceptions(l_svscpa_nr_of_rows) := l_initscpa_log_exceptions(1) ;
      l_svscpa_pa_class(l_svscpa_nr_of_rows) := l_initscpa_pa_class(1) ;
      l_svscpa_log_hs(l_svscpa_nr_of_rows) := l_initscpa_log_hs(1) ;
      l_svscpa_log_hs_details(l_svscpa_nr_of_rows) := l_initscpa_log_hs_details(1) ;
      l_svscpa_lc(l_svscpa_nr_of_rows) := l_initscpa_lc(1) ;
      l_svscpa_lc_version(l_svscpa_nr_of_rows) := l_initscpa_lc_version(1) ;

   END InternalInitScParameter;

   /* Local procedure to init and save a parameter */
BEGIN

   l_svscpa_nr_of_rows := 0;
   InternalInitScParameter;
   SaveScParameters;
   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   RETURN(UNAPIGEN.P_TXN_ERROR);
END InsertPa;

FUNCTION SpecialRulesForValues     /* INTERNAL */
(a_value_s_mod    IN     BOOLEAN,  /* BOOLEAN_TYPE */
 a_value_s        IN OUT VARCHAR2, /* VC40_TYPE */
 a_value_f_mod    IN     BOOLEAN,  /* BOOLEAN_TYPE */
 a_value_f        IN     NUMBER,   /* FLOAT_TYPE */
 a_format         IN     VARCHAR2, /* VC40_TYPE */
 a_alt_value_s    IN OUT VARCHAR2, /* VC40_TYPE */
 a_alt_value_f    IN OUT NUMBER)   /* FLOAT_TYPE */
RETURN NUMBER IS

BEGIN
   IF a_value_f_mod THEN
      IF a_value_s_mod THEN
         NULL;
      ELSE
         a_alt_value_s := NULL;
      END IF;
   ELSIF a_value_s_mod THEN
      --apply conversion factor
      a_alt_value_f := NULL;
      l_ret_code := UNICONNECT6.ApplyConversionFactor(a_value_s,
                                                      a_format,
                                                      a_alt_value_f);
      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_HIGH,
                                   'ret_code='||TO_CHAR(l_ret_code)||
                                   ' returned by UNICONNECT6.ApplyConversionFactor#value_s='||
                                   a_value_s ||
                                   '#format='||a_format);
         RETURN(UNAPIGEN.DBERR_GENFAIL);
      END IF;
      --Only in the case of a lookup format, try conversion to float
      IF a_alt_value_f IS NULL AND SUBSTR(a_format,1,1) = 'L' THEN
         l_ret_code := UNAPIGEN.FormatResult(a_alt_value_f, a_format, a_value_s);
         IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
            UNICONNECT.UCONWriteToLog(UNAPIUL.UL_TRACE_HIGH,
                                      'ret_code='||TO_CHAR(l_ret_code)||
                                      ' returned by UNAPIGEN.FormatResult#value_s='||
                                      a_value_s ||
                                      '#format='||a_format);
            RETURN(UNAPIGEN.DBERR_GENFAIL);
         END IF;
      END IF;
   END IF;
   RETURN(UNAPIGEN.DBERR_SUCCESS);
END SpecialRulesForValues;

FUNCTION ApplyConversionFactor   /* INTERNAL */
(a_value_s  IN OUT   VARCHAR2,   /* VC40_TYPE */
 a_format   IN       VARCHAR2,   /* VC40_TYPE */
 a_value_f  OUT      NUMBER)     /* NUM_TYPE */
RETURN NUMBER IS

CURSOR l_conv_factors_cursor IS
   SELECT setting_name conv_factor_name, setting_value conv_factor_operation
   FROM utsystem
   WHERE setting_name IN ('CONV_FACTOR_<','CONV_FACTOR_<<',
                          'CONV_FACTOR_>','CONV_FACTOR_>>','CONV_FACTOR_~');

l_orig_value_s           VARCHAR2(40);
l_new_value_s            VARCHAR2(40);
l_operator               VARCHAR2(40);
l_pos_less               INTEGER;
l_pos_high               INTEGER;
l_pos_lessless           INTEGER;
l_pos_highhigh           INTEGER;
l_pos_tilde              INTEGER;
l_value_f                NUMBER;
l_dyn_cursor             INTEGER;
l_orig_value_f           NUMBER;

BEGIN

   --do nothing when a_format = C or a_value_s is empty (NULL or full of space)
   IF a_format = 'C' OR
      LTRIM(a_value_s) IS NULL THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;

   --Load the conversion factors when not yet loaded
   IF NOT P_CONV_FACTORS_LOADED THEN
      FOR l_conv_factors_rec IN l_conv_factors_cursor LOOP
         IF l_conv_factors_rec.conv_factor_name = 'CONV_FACTOR_<' THEN
            P_CONV_FACTOR_less := l_conv_factors_rec.conv_factor_operation;
         ELSIF l_conv_factors_rec.conv_factor_name = 'CONV_FACTOR_<<' THEN
            P_CONV_FACTOR_lessless := l_conv_factors_rec.conv_factor_operation;
         ELSIF l_conv_factors_rec.conv_factor_name = 'CONV_FACTOR_>' THEN
            P_CONV_FACTOR_high := l_conv_factors_rec.conv_factor_operation;
         ELSIF l_conv_factors_rec.conv_factor_name = 'CONV_FACTOR_>>' THEN
            P_CONV_FACTOR_highhigh := l_conv_factors_rec.conv_factor_operation;
         ELSIF l_conv_factors_rec.conv_factor_name = 'CONV_FACTOR_~' THEN
            P_CONV_FACTOR_tilde := l_conv_factors_rec.conv_factor_operation;
         END IF;
      END LOOP;

      P_CONV_FACTORS_LOADED := TRUE;

   END IF;

   --IF input: value_s is containing a leading sign
   --   Extract the numeric value
   --   Apply the corresponding conversion factor to the numeric value
   --   --Format the original float value (without a conversion operation applied)
   --   Replace the original string but leave any leading signs in place
   --ELSE
   --   do nothing
   --END IF
   l_orig_value_s := LTRIM(a_value_s);
   l_value_f := NULL;
   l_pos_less := INSTR(l_orig_value_s, '<');
   l_pos_lessless := INSTR(l_orig_value_s, '<<');
   l_pos_high := INSTR(l_orig_value_s, '>');
   l_pos_highhigh := INSTR(l_orig_value_s, '>>');
   l_pos_tilde := INSTR(l_orig_value_s, '~');

   IF l_pos_less = 1 OR
      l_pos_lessless = 1 OR
      l_pos_high = 1 OR
      l_pos_highhigh = 1 OR
      l_pos_tilde = 1 THEN

      --Extract the numeric value
      l_new_value_s := l_orig_value_s;
      l_new_value_s := REPLACE(l_new_value_s, ' ', '');
      l_new_value_s := REPLACE(l_new_value_s, '<', '');
      l_new_value_s := REPLACE(l_new_value_s, '>', '');
      l_new_value_s := REPLACE(l_new_value_s, '=', '');
      l_new_value_s := REPLACE(l_new_value_s, UNISTR('\00B1'), '');
      l_new_value_s := REPLACE(l_new_value_s, '~', '');

      BEGIN
         l_value_f := l_new_value_s;

      EXCEPTION
      WHEN VALUE_ERROR THEN
         --do nothing
         RETURN(UNAPIGEN.DBERR_SUCCESS);
      END;

      l_orig_value_f := l_value_f;

      --Apply the corresponding conversion factor to the numeric value
      IF l_pos_lessless = 1 THEN
         l_operator := P_CONV_FACTOR_lessless;
      ELSIF l_pos_less = 1 THEN
         l_operator := P_CONV_FACTOR_less;
      ELSIF l_pos_highhigh = 1 THEN
         l_operator := P_CONV_FACTOR_highhigh;
      ELSIF l_pos_high = 1 THEN
         l_operator := P_CONV_FACTOR_high;
      ELSIF l_pos_tilde = 1 THEN
         l_operator := P_CONV_FACTOR_tilde;
      END IF;

      --Bug in Oracle
      --The decimal separator used in dynamic sql is apparently always a dot
      --NLS settings have no influence on this feature
      --The same happens on the unilab client
      --The floats used in the operations specified in the system settings
      --must be specified with dots
      l_dyn_cursor := DBMS_SQL.OPEN_CURSOR;
      l_sql_string := 'BEGIN :l_value_f := :l_value_f '||l_operator||'; END;';

      DBMS_SQL.PARSE(l_dyn_cursor, l_sql_string, DBMS_SQL.V7); -- NO single quote handling required
      DBMS_SQL.BIND_VARIABLE(l_dyn_cursor, ':l_value_f', l_value_f);
      l_result := DBMS_SQL.EXECUTE(l_dyn_cursor);
      DBMS_SQL.VARIABLE_VALUE(l_dyn_cursor, ':l_value_f', l_value_f);

      DBMS_SQL.CLOSE_CURSOR(l_dyn_cursor);

      --Format the original float value (without a conversion operation applied)
      l_new_value_s := NULL;
      l_ret_code := UNAPIGEN.FormatResult(l_orig_value_f, a_format, l_new_value_s);
      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         RETURN(l_ret_code);
      END IF;

      --Replace the original string but leave any leading signs in place
      IF l_pos_lessless = 1 THEN
         l_new_value_s := '<<'||l_new_value_s;
      ELSIF l_pos_less = 1 THEN
         l_new_value_s := '<' ||l_new_value_s;
      ELSIF l_pos_highhigh = 1 THEN
         l_new_value_s := '>>'||l_new_value_s;
      ELSIF l_pos_high = 1 THEN
         l_new_value_s := '>' ||l_new_value_s;
      ELSIF l_pos_tilde = 1 THEN
         l_new_value_s := '~' ||l_new_value_s;
      END IF;
      a_value_s := l_new_value_s;
      a_value_f := l_value_f;

   ELSE
      NULL;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);
END ApplyConversionFactor;


BEGIN

P_CONV_FACTORS_LOADED := FALSE;

END uniconnect6;
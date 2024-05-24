create or replace PACKAGE BODY
-- SIMATIC IT UNILAB package
-- $Revision: 6.4.0 (V06.04.00.00_24.01) $
-- $Date: 2009-04-20T16:24:00 $
unapiplan AS

l_sql_string      VARCHAR2(2000);
l_ret_code        NUMBER;
l_sqlerrm         VARCHAR2(255);
StpError          EXCEPTION;

CURSOR c_system (c_setting_name VARCHAR2) IS
   SELECT setting_value
   FROM utsystem
   WHERE setting_name = c_setting_name;

CURSOR l_jobs_cursor (c_search VARCHAR2) IS
   SELECT job_name, enabled, job_action
   FROM sys.dba_scheduler_jobs
   WHERE INSTR(UPPER(job_action), c_search) <> 0;

PROCEDURE SamplePlanner
(a_start_date       IN  DATE,
 a_end_date         IN  DATE,
 a_incr             IN  NUMBER) IS

-- Local variables
l_curr_date             TIMESTAMP WITH TIME ZONE;
l_start_date            TIMESTAMP WITH TIME ZONE;
l_end_date              TIMESTAMP WITH TIME ZONE;
l_incr                  NUMBER;
l_plan_new              BOOLEAN;
l_one_planned           BOOLEAN;
l_eval                  BOOLEAN;
l_dyn_cursor            INTEGER;
l_result                NUMBER;
l_sc                    VARCHAR2(20);
l_sqlerrm2              VARCHAR2(255);

-- Variables for frequency evaluation
l_ref_date           TIMESTAMP WITH TIME ZONE;
l_freq_tp            CHAR(1);
l_freq_val           NUMBER;
l_freq_unit          VARCHAR2(20);
l_invert_freq        CHAR(1);
l_last_sched         TIMESTAMP WITH TIME ZONE;
l_last_cnt           NUMBER(5);
l_last_val           VARCHAR2(40);
l_orig_last_sched    TIMESTAMP WITH TIME ZONE;
l_sccreatepg         VARCHAR2(40);
l_sccreateic         VARCHAR2(40);

-- Get all st with planning freq not yet handled
CURSOR l_st_cursor IS
   SELECT *
   FROM utst
   WHERE freq_tp NOT IN ('A', 'N')
     AND VERSION_IS_CURRENT = 1; -- RS20121128 : Explicit only plan current st
   --AND active='1'
   --AND version = UNAPIGEN.UseVersion('st', st, '*'); --use current or highest

--Specific local variables for SetConnection
l_numeric_characters          VARCHAR2(2);
l_dateformat                  VARCHAR2(255);
l_up                          NUMBER(5);
l_user_profile                VARCHAR2(40);
l_language                    VARCHAR2(20);
l_tk                          VARCHAR2(20);
l_dba_name                    VARCHAR2(40);

--Specific local variables for PlanSample
l_fieldtype_tab        UNAPIGEN.VC20_TABLE_TYPE;
l_fieldnames_tab       UNAPIGEN.VC20_TABLE_TYPE;
l_fieldvalues_tab      UNAPIGEN.VC40_TABLE_TYPE;
l_fieldnr_of_rows      NUMBER;

--deadlock control variables
l_deadlock_counter     INTEGER;
l_deadlock_raised      BOOLEAN;
l_timezone             VARCHAR2(40);

BEGIN

----------------
-- SetConnection
----------------
OPEN c_system ('DBA_NAME');
FETCH c_system INTO l_dba_name;
IF c_system%NOTFOUND THEN
   CLOSE c_system;
   RAISE StpError;
END IF;
CLOSE c_system;

l_dateformat := 'DD/MM/RR HH24:MI:SS';
OPEN c_system ('JOBS_DATE_FORMAT');
FETCH c_system INTO l_dateformat;
CLOSE c_system;
l_numeric_characters := 'DB';
l_timezone := 'SERVER';

l_ret_code := UNAPIGEN.SetConnection('SamplePlanner',
                                     l_dba_name,
                                     '',
                                     'scplan',
                                     l_numeric_characters,
                                     l_dateformat,
                                     l_timezone,
                                     l_up,
                                     l_user_profile,
                                     l_language,
                                     l_tk);
IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
   IF P_TRACING_ON THEN
      DBMS_OUTPUT.PUT_LINE('SetConnection failed:'|| l_ret_code);
   END IF;
   IF l_ret_code = UNAPIGEN.DBERR_NOTAUTHORISED THEN
      l_sqlerrm2 := UNAPIAUT.P_NOT_AUTHORISED;
      IF P_TRACING_ON THEN
         DBMS_OUTPUT.PUT_LINE(UNAPIAUT.P_NOT_AUTHORISED);
      END IF;
   END IF;
   RAISE StpError;
END IF;

--------------------------------------------------
-- Check the input arguments, default to next week
--------------------------------------------------
l_start_date := NVL(a_start_date, TRUNC(CURRENT_TIMESTAMP, 'HH'));
l_end_date := NVL(a_end_date, TRUNC(CURRENT_TIMESTAMP, 'HH') + 7);
l_incr := NVL(a_incr, 1);

IF P_SIMULATE_ONLY THEN
   DBMS_OUTPUT.PUT_LINE('Only simulating sample planning, no samples will be created!');
END IF;

--------------------------------------
-- Fetch default sample creation flags
--------------------------------------
OPEN c_system ('SCPLAN_SCCREATEPG');
FETCH c_system INTO l_sccreatepg;
CLOSE c_system;
OPEN c_system ('SCPLAN_SCCREATEIC');
FETCH c_system INTO l_sccreateic;
CLOSE c_system;

----------------------------------
-- Loop through all st to plan for
----------------------------------
FOR l_st_rec IN l_st_cursor LOOP

   l_deadlock_counter := 0;
   LOOP
      l_deadlock_raised := FALSE;
      l_ret_code := UNAPIGEN.BeginTransaction;
      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         IF P_TRACING_ON THEN
            DBMS_OUTPUT.PUT_LINE('BeginTransaction failed:' || l_ret_code);
         END IF;
         RAISE StpError;
      END IF;

      l_one_planned := FALSE;

      ---------------------------------------
      -- Loop from l_start_date to l_end_date
      ---------------------------------------
      l_freq_tp := l_st_rec.freq_tp;
      l_freq_val := l_st_rec.freq_val;
      l_freq_unit := l_st_rec.freq_unit;
      l_invert_freq := l_st_rec.invert_freq;
      l_last_sched := l_st_rec.last_sched;
      l_last_cnt := l_st_rec.last_cnt;
      l_last_val := l_st_rec.last_val;
      IF P_TRACING_ON THEN
         DBMS_OUTPUT.PUT_LINE(l_st_rec.st || ' - ' || l_st_rec.version || ': ' || l_freq_tp || ', ' ||
                              l_freq_val || l_freq_unit || '#' ||
                              l_last_sched);
      END IF;

      -- Start either from a_start_date or from the last scheduled date
      IF l_start_date < l_last_sched THEN
         l_curr_date := l_last_sched;
      ELSE
         l_curr_date := l_start_date;
      END IF;
      l_orig_last_sched := l_st_rec.last_sched;

      -- Loop till the end of the period
      WHILE (l_curr_date <= a_end_date) LOOP
         l_plan_new := FALSE;
         IF l_freq_tp = 'C' THEN
            ------------------------
            -- Custom frequency type
            ------------------------
            l_sql_string := 'BEGIN :l_ret_code := UNFREQ.'|| l_freq_unit ||
                            '(:a_st, :a_st_version, :a_freq_val, :a_invert_freq, :a_ref_date,' ||
                            ':a_last_sched, :a_last_cnt, :a_last_val); END;';
            l_dyn_cursor := DBMS_SQL.OPEN_CURSOR;
            DBMS_SQL.PARSE(l_dyn_cursor, l_sql_string, DBMS_SQL.V7); -- NO single quote handling required
            DBMS_SQL.BIND_VARIABLE(l_dyn_cursor, ':l_ret_code', l_ret_code);
            DBMS_SQL.BIND_VARIABLE(l_dyn_cursor, ':a_st', l_st_rec.st, 20);
            DBMS_SQL.BIND_VARIABLE(l_dyn_cursor, ':a_st_version', l_st_rec.version, 20);
            DBMS_SQL.BIND_VARIABLE(l_dyn_cursor, ':a_freq_val', l_freq_val);
            DBMS_SQL.BIND_VARIABLE_CHAR(l_dyn_cursor, ':a_invert_freq', l_invert_freq, 1);
            DBMS_SQL.BIND_VARIABLE(l_dyn_cursor, ':a_ref_date', l_curr_date);
            DBMS_SQL.BIND_VARIABLE(l_dyn_cursor, ':a_last_sched', l_last_sched);
            DBMS_SQL.BIND_VARIABLE(l_dyn_cursor, ':a_last_cnt', l_last_cnt);
            DBMS_SQL.BIND_VARIABLE(l_dyn_cursor, ':a_last_val', l_last_val, 40);
            l_result := DBMS_SQL.EXECUTE(l_dyn_cursor);
            DBMS_SQL.VARIABLE_VALUE(l_dyn_cursor, ':l_ret_code', l_ret_code);
            DBMS_SQL.VARIABLE_VALUE(l_dyn_cursor, ':a_last_sched', l_last_sched);
            DBMS_SQL.VARIABLE_VALUE(l_dyn_cursor, ':a_last_cnt', l_last_cnt);
            DBMS_SQL.VARIABLE_VALUE(l_dyn_cursor, ':a_last_val', l_last_val);
            DBMS_SQL.CLOSE_CURSOR(l_dyn_cursor);


            IF P_TRACING_ON THEN
               DBMS_OUTPUT.PUT_LINE('Try date:' || l_curr_date ||
                                    ';new sched date:' || l_last_sched ||
                                    '#ret=' || l_ret_code);
            END IF;

            -- Check also if new last_sched is in required period
            IF l_ret_code = UNAPIGEN.DBERR_SUCCESS AND
               l_last_sched >= a_start_date AND
               l_last_sched <= a_end_date THEN
               l_plan_new := TRUE;
            END IF;
         ELSE
            -----------------------
            -- Time based frequency
            -----------------------
            l_eval := UNAPIAUT.EvalAssignmentFreq('st', l_st_rec.st, l_st_rec.version, '', '', '',
                                                  l_freq_tp, l_freq_val,
                                                  l_freq_unit, l_invert_freq,
                                                  l_curr_date, l_last_sched,
                                                  l_last_cnt, l_last_val);
            IF l_eval AND
               l_last_sched >= a_start_date AND
               l_last_sched <= a_end_date THEN
               l_plan_new := TRUE;

               IF P_TRACING_ON THEN
                  DBMS_OUTPUT.PUT_LINE('Try date:' || l_curr_date ||
                                       ';new sched date:' || l_last_sched ||
                                       '#eval=TRUE');
               END IF;
            ELSIF l_eval AND
                  l_last_sched < a_start_date AND
                  l_orig_last_sched IS NULL THEN
               -- The original last sched date was NULL, so the new scheduling date can arrive before
               -- the actual interval. This means scheduling never took place before.
               -- In this case we EXCEPTIONALLY want to schedule something outside the planning period
               -- Keep the l_last_sched to the date out of the sampling period !!!
               l_plan_new := TRUE;
               IF P_TRACING_ON THEN
                  DBMS_OUTPUT.PUT_LINE('Try date:' || l_curr_date ||
                                       ';new sched date:' || l_last_sched ||
                                       '#eval=TRUE');
               END IF;
            ELSIF P_TRACING_ON THEN
                  DBMS_OUTPUT.PUT_LINE('Try date:' || l_curr_date ||
                                       ';new sched date:' || l_last_sched ||
                                       '#eval=FALSE');
            END IF;
         END IF;
         --------------------------
         -- Plan sample if required
         --------------------------
         IF l_plan_new THEN
            l_one_planned := TRUE;
            IF P_SIMULATE_ONLY THEN
               DBMS_OUTPUT.PUT_LINE('Sample will be planned for st <' || l_st_rec.st ||
                                    ' - ' || l_st_rec.version ||
                                    '> at reference date ' || l_last_sched);
            ELSE
               FOR l_sc_row IN 1..NVL(l_st_rec.nr_planned_sc,0) LOOP
                  l_sc := NULL;
                  --multi-plant context can be passed eventually in input arrays:
                  --l_fieldtype_tab, l_fieldnames_tab, l_fieldvalues_tab
                  l_fieldnr_of_rows := 0;
                  l_ret_code := UNAPISC.PlanSample(l_st_rec.st, l_st_rec.version, l_sc, l_last_sched,
                                                   l_sccreateic, l_sccreatepg, NULL,
                                                   l_fieldtype_tab, l_fieldnames_tab,
                                                   l_fieldvalues_tab, l_fieldnr_of_rows,
                                                   'Created by SamplePlanner');
                  IF l_ret_code = UNAPIGEN.DBERR_DEADLOCKDETECTED THEN
                     IF l_deadlock_raised = FALSE THEN
                        l_deadlock_counter := l_deadlock_counter + 1;
                     END IF;
                     l_deadlock_raised := TRUE;
                     l_one_planned := FALSE;
                     EXIT;
                  END IF;
                  IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
                     INSERT INTO uterror(client_id, applic, who, logdate, logdate_tz, api_name, error_msg)
                     VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                            'SamplePlanner', 'PlanSample returned:' || l_ret_code || ' for st=' || l_st_rec.st);
                     IF P_TRACING_ON THEN
                        DBMS_OUTPUT.PUT_LINE('PlanSample returned:' || l_ret_code);
                     END IF;
                  ELSIF P_TRACING_ON THEN
                     DBMS_OUTPUT.PUT_LINE('Sample created:' || l_sc);
                  END IF;

               END LOOP;
            END IF;
         END IF;

         --Further sample creation attempts are postponed when a deadlock has been detected
         EXIT when l_deadlock_raised;
         -- Increment the current date
         l_curr_date := l_curr_date + l_incr/24;

         -- Upon the next loop, reuse the (new) last_sched data
      END LOOP;

      -- We're done for this st, save the last_sched data if needed
      IF NOT P_SIMULATE_ONLY AND
         l_one_planned THEN
         UPDATE utst
         SET last_sched = l_last_sched,
             last_sched_tz = DECODE(l_last_sched, last_sched_tz, last_sched_tz, l_last_sched) ,
             last_cnt = l_last_cnt,
             last_val = l_last_val
         WHERE st = l_st_rec.st
           AND version = l_st_rec.version;
      END IF;

      l_ret_code := UNAPIGEN.EndTransaction;
      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         IF P_TRACING_ON THEN
            DBMS_OUTPUT.PUT_LINE('EndTransaction failed:' || l_ret_code);
         END IF;
         RAISE StpError;
      END IF;
      --deadlock control (MUST ALWAYS happen on transaction level)
      --                 (when a deadlock the current transaction must be restarted)
      --                 (Not just the statement that returned the deadlock error code)
      EXIT WHEN l_deadlock_raised = FALSE;
      IF l_deadlock_counter > 1 THEN
         INSERT INTO uterror(client_id, applic, who, logdate, logdate_tz, api_name, error_msg)
         VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                'SamplePlanner', 'Deadlock detected, maximum number of retries reached for st=' || l_st_rec.st);
         IF P_TRACING_ON THEN
            DBMS_OUTPUT.PUT_LINE('Deadlock detected, maximum number of retries reached for st=' || l_st_rec.st);
         END IF;
         EXIT;
      END IF;
      EXIT WHEN l_deadlock_counter >  1; --max 1 attempt when a deadlock is detected: may be increased
      INSERT INTO uterror(client_id, applic, who, logdate, logdate_tz, api_name, error_msg)
      VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
             'SamplePlanner', 'Deadlock detected, will retry to create sample for st=' || l_st_rec.st);
      IF P_TRACING_ON THEN
         DBMS_OUTPUT.PUT_LINE('Deadlock detected, will retry to create sample for st=' || l_st_rec.st);
         DBMS_OUTPUT.PUT_LINE('Planner will sleep for 10 seconds before retrying.');
      END IF;
      DBMS_LOCK.SLEEP(10); --wait at least 3 seconds before retrying in case of deadlock detection
   END LOOP;
END LOOP;

EXCEPTION
WHEN OTHERS THEN
   IF DBMS_SQL.IS_OPEN(l_dyn_cursor) THEN
      DBMS_SQL.CLOSE_CURSOR(l_dyn_cursor);
   END IF;
   IF sqlcode <> 1 THEN
      UNAPIGEN.LogError('SamplePlanner', sqlerrm);
   END IF;
   IF l_sqlerrm2 IS NOT NULL THEN
      UNAPIGEN.LogError('SamplePlanner', l_sqlerrm2);
   END IF;
END SamplePlanner;

FUNCTION StartSamplePlanner
(a_first_run        IN VARCHAR2,
 a_next_run         IN VARCHAR2,
 a_start_date       IN VARCHAR2,
 a_end_date         IN VARCHAR2,
 a_incr             IN NUMBER)
RETURN NUMBER IS

-- Start the Sample Planner
l_job            VARCHAR2(30); -- In schedule the identifier is a string while in jobs is a number
l_enabled         VARCHAR2(5);
l_action         VARCHAR2(4000);
l_interval       NUMBER;
l_setting_value  VARCHAR2(40);
l_found          BOOLEAN;
l_leave_loop     BOOLEAN;
l_attempts       INTEGER;
l_date_cursor    INTEGER;
l_first_run      TIMESTAMP WITH TIME ZONE;
l_result         NUMBER;
l_start_date     VARCHAR2(255);
l_end_date       VARCHAR2(255);
l_next_run       VARCHAR2(255);
l_IsDBAUser      INTEGER;
l_session_timezone   VARCHAR2(64);

BEGIN
   /*---------------------------------------------------------------------------*/
   /* Check if job exists                                                       */
   /* No functions provided to check if a job is existing in DBMS_JOB package   */
   /* ALL_JOBS and USER_JOBS views could not be used since they are referencing */
   /* the USER session as creator of the job !                                  */
   /*---------------------------------------------------------------------------*/
   OPEN l_jobs_cursor('UNAPIPLAN.SAMPLEPLANNER');
   FETCH l_jobs_cursor
   INTO l_job,l_enabled,l_action ;
   l_found := l_jobs_cursor%FOUND;
   CLOSE l_jobs_cursor;

   l_IsDBAUser := UNAPIGEN.IsExternalDBAUser();

   /* When action required : check if authorised */
   /*--------------------------------------------*/
   IF (UNAPIGEN.IsUserAuthorised(UNAPIGEN.P_CURRENT_UP, UNAPIGEN.P_USER, 'database', 'startstopjobs') <> UNAPIGEN.DBERR_SUCCESS) AND
      l_IsDBAUser <> UNAPIGEN.DBERR_SUCCESS THEN
      RETURN(UNAPIGEN.DBERR_EVMGRSTARTNOTAUTHORISED);
   END IF;
   -- set dbtimezone for jobs
      SELECT SESSIONTIMEZONE
        INTO l_session_timezone
        FROM DUAL;
      EXECUTE IMMEDIATE 'ALTER SESSION SET time_zone = DBTIMEZONE';

   IF l_found THEN
      IF UPPER(l_enabled) = 'FALSE' THEN
         /*-----------------*/
         /* Try to relaunch */
         /*-----------------*/
        DBMS_SCHEDULER.ENABLE(l_job);
      END IF;
   ELSE
      /*------------------------------------------*/
      /* The job has to be created                */
      /*------------------------------------------*/

      -- Find the first date to run the job
      IF a_first_run IS NOT NULL THEN
         l_date_cursor := DBMS_SQL.OPEN_CURSOR;
         l_sql_string := 'BEGIN :l_date := ' || a_first_run || '; END;';

         DBMS_SQL.PARSE(l_date_cursor, l_sql_string, DBMS_SQL.V7); -- NO single quote handling required
         DBMS_SQL.BIND_VARIABLE(l_date_cursor, ':l_date', l_first_run);
         l_result := DBMS_SQL.EXECUTE(l_date_cursor);
         DBMS_SQL.VARIABLE_VALUE(l_date_cursor, ':l_date', l_first_run);
         DBMS_SQL.CLOSE_CURSOR(l_date_cursor);
      ELSE
         l_first_run := CURRENT_TIMESTAMP;
      END IF;

      --l_next_run := NVL(a_next_run, 'TRUNC(CURRENT_TIMESTAMP, ''HH'') + 7'); WEEKLY
      l_start_date := NVL(a_start_date, 'TRUNC(CURRENT_TIMESTAMP, ''HH'')');
      l_end_date := NVL(a_end_date, 'TRUNC(CURRENT_TIMESTAMP, ''HH'') + 7');

    l_job := 'UNI_J_SamplePlanner';
         DBMS_SCHEDULER.CREATE_JOB(
             job_name          =>  '"' ||UNAPIGEN.P_DBA_NAME||'".'||l_job,
             job_class         => 'UNI_JC_OTHER_JOBS',
             job_type          =>  'PLSQL_BLOCK',
             job_action        => 'UNAPIPLAN.SamplePlanner(' || l_start_date || ',' || l_end_date || ',' || a_incr || ');',
             start_date        =>    l_first_run,
             repeat_interval   =>  'FREQ = WEEKLY; INTERVAL = 1' ,
             enabled              => TRUE
        );
      DBMS_SCHEDULER.SET_ATTRIBUTE (
                    name           => l_job,
                    attribute      => 'restartable',
                    value          => TRUE);
   END IF;
   UNAPIGEN.U4COMMIT;

   /*----------------------------------------------------------------------*/
   /* Leave this function when Job effectively inserted into the job queue */
   /* or removed from the job queue                                        */
   /* To avoid double starts or double stops                               */
   /*----------------------------------------------------------------------*/
   l_leave_loop := FALSE;
   l_attempts := 0;
   WHILE NOT l_leave_loop LOOP
      l_attempts := l_attempts + 1;
      OPEN l_jobs_cursor('UNAPIPLAN.SAMPLEPLANNER');
      FETCH l_jobs_cursor INTO l_job,l_enabled,l_action ;
      l_found := l_jobs_cursor%FOUND;
      CLOSE l_jobs_cursor;
      IF l_found THEN
         l_leave_loop := TRUE;
      ELSE
         IF l_attempts >= 30 THEN
            l_sqlerrm := 'SamplePlanner not stopped ! (timeout after 60 seconds)';
            Raise StpError;
         ELSE
            DBMS_LOCK.SLEEP(2);
         END IF;
      END IF;
   END LOOP;
         -- set the original session timezone
         EXECUTE IMMEDIATE 'ALTER SESSION SET time_zone = ''' || l_session_timezone || '''';
   RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
WHEN OTHERS THEN
         -- set the original session timezone
         EXECUTE IMMEDIATE 'ALTER SESSION SET time_zone = ''' || l_session_timezone || '''';
   IF SQLCODE <> 1 THEN
      l_sqlerrm := SQLERRM;
   END IF;
   INSERT INTO uterror(client_id, applic, who, logdate, logdate_tz, api_name, error_msg)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
          'StartSamplePlanner', l_sqlerrm );
   UNAPIGEN.U4COMMIT;
   IF l_jobs_cursor%ISOPEN THEN
      CLOSE l_jobs_cursor;
   END IF;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END StartSamplePlanner;

FUNCTION StopSamplePlanner
RETURN NUMBER IS

-- Stop the Sample Planner
l_job            VARCHAR2(30); -- In schedule the identifier is a string while in jobs is a number;
l_enabled         VARCHAR2(5);
l_action         VARCHAR2(4000);
l_interval       NUMBER;
l_setting_value  VARCHAR2(40);
l_found          BOOLEAN;
l_leave_loop     BOOLEAN;
l_attempts       INTEGER;
l_IsDBAUser      INTEGER;
l_session_timezone   VARCHAR2(64);
BEGIN
   /*---------------------------------------------------------------------------*/
   /* Check if job exists                                                       */
   /* No functions provided to check if a job is existing in DBMS_JOB package   */
   /* ALL_JOBS and USER_JOBS views could not be used since they are referencing */
   /* the USER session as creator of the job !                                  */
   /*---------------------------------------------------------------------------*/
   OPEN l_jobs_cursor('UNAPIPLAN.SAMPLEPLANNER');
   FETCH l_jobs_cursor INTO l_job,l_enabled,l_action ;
   l_found := l_jobs_cursor%FOUND;
   CLOSE l_jobs_cursor;

   l_IsDBAUser := UNAPIGEN.IsExternalDBAUser();

   /* When action required : check if authorised */
   /*--------------------------------------------*/
   IF (UNAPIGEN.IsUserAuthorised(UNAPIGEN.P_CURRENT_UP, UNAPIGEN.P_USER, 'database', 'startstopjobs') <> UNAPIGEN.DBERR_SUCCESS) AND
      l_IsDBAUser <> UNAPIGEN.DBERR_SUCCESS THEN
      RETURN(UNAPIGEN.DBERR_EVMGRSTARTNOTAUTHORISED);
   END IF;
      -- set dbtimezone for jobs
      SELECT SESSIONTIMEZONE
        INTO l_session_timezone
        FROM DUAL;
      EXECUTE IMMEDIATE 'ALTER SESSION SET time_zone = DBTIMEZONE';
   IF l_found THEN
      /*-----------------------*/
      /* Try to remove the job */
      /*-----------------------*/
      DBMS_SCHEDULER.DROP_JOB(l_job);
   END IF;
   UNAPIGEN.U4COMMIT;
   /*----------------------------------------------------------------------*/
   /* Leave this function when Job effectively inserted into the job queue */
   /* or removed from the job queue                                        */
   /* To avoid double starts or double stops                               */
   /*----------------------------------------------------------------------*/
   l_leave_loop := FALSE;
   l_attempts := 0;
   WHILE NOT l_leave_loop LOOP
      l_attempts := l_attempts + 1;
      OPEN l_jobs_cursor('UNAPIPLAN.SAMPLEPLANNER');
      FETCH l_jobs_cursor INTO l_job,l_enabled,l_action ;
      l_found := l_jobs_cursor%FOUND;
      CLOSE l_jobs_cursor;
      IF NOT l_found THEN
         l_leave_loop := TRUE;
      ELSE
         IF l_attempts >= 30 THEN
            l_sqlerrm := 'Sample Planner not stopped ! (timeout after 60 seconds)';
            Raise StpError;
         ELSE
            DBMS_LOCK.SLEEP(2);
         END IF;
      END IF;
   END LOOP;
         -- set the original session timezone
         EXECUTE IMMEDIATE 'ALTER SESSION SET time_zone = ''' || l_session_timezone || '''';
   RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
WHEN OTHERS THEN
         -- set the original session timezone
         EXECUTE IMMEDIATE 'ALTER SESSION SET time_zone = ''' || l_session_timezone || '''';
   IF SQLCODE <> 1 THEN
      l_sqlerrm := SQLERRM;
   END IF;
   INSERT INTO uterror(client_id, applic, who, logdate, logdate_tz, api_name, error_msg)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                     'StopSamplePlanner' , l_sqlerrm );
   UNAPIGEN.U4COMMIT;
   IF l_jobs_cursor%ISOPEN THEN
      CLOSE l_jobs_cursor;
   END IF;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END StopSamplePlanner;

FUNCTION GetVersion
  RETURN VARCHAR2
IS
BEGIN
  RETURN('06.07.00.00_13.00');
EXCEPTION
  WHEN OTHERS THEN
	 RETURN (NULL);
END GetVersion;


BEGIN
   -- Switch tracing off by default
   P_TRACING_ON := FALSE;

   -- Do the real thing by default
   P_SIMULATE_ONLY := FALSE;
END unapiplan;
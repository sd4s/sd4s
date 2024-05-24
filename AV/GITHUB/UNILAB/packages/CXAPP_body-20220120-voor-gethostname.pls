create or replace PACKAGE BODY        Cxapp
AS
--------------------------------------------------------------------------------
--  PROJECT : Vredestein Enschede
-------------------------------------------------------------------------------
--  PACKAGE : CXAPP
-- ABSTRACT :
--   WRITER : Rody Sparenberg
--     DATE : 25/10/2005
--   TARGET : Oracle 10.2.0 / Unilab 6.4
--  VERSION : av3.0 $Revision: 2 $
--------------------------------------------------------------------------------
--  REMARKS :
--------------------------------------------------------------------------------
--  CHANGES :
--
--  When      | Who       | What
--============|===========|=====================================================
-- 25/10/2005 |           | Created
-- 03/03/2011 | RS        | Upgrade V6.3
--                        | Changed SYSDATE INTO CURRENT_TIMESTAMP
-- 04/03/2011 | RS        | Upgrade V6.4
-- 12/05/2011 | RS        | Changed start of sampleplanner (really every monday)
-- 13/03/2013 | RS        | Added dedicated event managers
-- 04/02/2014 | JR        | Changed dedicated event managers (2 -> 1)
-- 10/03/2014 | JR        | Added StartAPAOFEA;
-- 06/03/2019 | DH        | Added apao_outdoor.startoutdooreventmgr
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
ics_package_name                 CONSTANT VARCHAR2(20) := 'CXAPP';
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- functions- and/or procedures-declarations
--------------------------------------------------------------------------------
   PROCEDURE startalldbjobs
   IS
      l_ret_code                    INTEGER;
      l_return                      INTEGER;
      l_job                         VARCHAR2(30); -- In schedule the identifier is a string while in jobs is a number;
      l_sqlerrm                     VARCHAR2 (255);
      l_count                       NUMBER;
      l_job_cursor                  INTEGER;
      l_sql_string                  VARCHAR2 (1014);

      l_first_run                   VARCHAR2(255);
      l_next_run                    VARCHAR2(255);
      l_start_date                  VARCHAR2(255);
      l_end_date                    VARCHAR2(255);
      l_incr                        NUMBER;
      l_sap_worklistrq_interval_s   VARCHAR2(255);
      l_sap_worklistrq_interval     NUMBER;
      l_sap_interf_used             VARCHAR2(255);
      l_found                       BOOLEAN;
      l_session_timezone            VARCHAR2(64);
      l_first_time_in_loop          BOOLEAN;
      l_entered_in_loop             BOOLEAN;

      CURSOR jobs_crs
      IS
         SELECT job_action
           FROM dba_scheduler_jobs
      WHERE UPPER (job_name) LIKE 'UNI_J%'
          ORDER BY job_action;

      CURSOR l_check_jobs_cursor (a_search VARCHAR2)
      IS
         SELECT job_name
         FROM sys.dba_scheduler_jobs
         WHERE INSTR(job_action, a_search)<>0;
   BEGIN
      SELECT SESSIONTIMEZONE
        INTO l_session_timezone
        FROM DUAL;
      EXECUTE IMMEDIATE 'ALTER SESSION SET time_zone = DBTIMEZONE';
      -- Synchronize the session NLS settings to be set
      -- equal to the database instance NLS settings.
      -- Note that this requires the database to be started
      -- with the correct NLS settings.

      Cxdba.syncnls;
      SELECT NVL (COUNT (*), 0)
        INTO l_ret_code
        FROM dba_scheduler_jobs
       WHERE job_name like 'UNI_J_%';
      DBMS_OUTPUT.put_line ('  ' || l_ret_code || ' jobs already scheduled');

      DBMS_SESSION.set_nls ('NLS_DATE_FORMAT', '''DD/MM/YYYY HH24:MI:SS''');
      DBMS_SESSION.set_nls ('NLS_TIMESTAMP_FORMAT', '''DD/MM/YYYY HH24:MI:SS''');
      DBMS_SESSION.set_nls ('NLS_TIMESTAMP_TZ_FORMAT', '''DD/MM/YYYY HH24:MI:SS''');
      DBMS_SESSION.set_nls ('NLS_TIME_FORMAT', '''HH24:MI:SS''');
      DBMS_SESSION.set_nls ('NLS_TIME_TZ_FORMAT', '''HH24:MI:SS''');

/* ----------------------------------------------------------------------- */
/****** check if services with the right names are existing and running  (must be running) */
/* ----------------------------------------------------------------------- */
    --check if the right names are used for the services
    --the following cursor is verifying that the services with the right names
    --have been created
    -- there must be a service having the service name and the network name exactly
    --
    --1.check that there is a service created having exactly the same name as the instance
    l_first_time_in_loop := TRUE;
    l_entered_in_loop := FALSE;
    FOR l_rec IN (SELECT *
                  FROM gv$instance
                  WHERE UPPER(instance_name) NOT IN
                     (SELECT UPPER(name) FROM sys.dba_services)) LOOP  --Note: gv$services can not be trusted in this query
        l_entered_in_loop := TRUE;
        IF l_first_time_in_loop THEN
           DBMS_OUTPUT.PUT_LINE('WARNING-WARNING-WARNING-WARNING-WARNING-WARNING-WARNING-WARNING-WARNING');
           DBMS_OUTPUT.PUT_LINE('***********************************************************************');
           DBMS_OUTPUT.PUT_LINE('WARNING:There is no service with a service name (and network name) = instance name');
           DBMS_OUTPUT.PUT_LINE('This mandatory for the type of jobs used by Unilab');
           l_first_time_in_loop := FALSE;
        END IF;
        DBMS_OUTPUT.PUT_LINE(' instance name: '||l_rec.instance_name||'.You should perform a:');
        DBMS_OUTPUT.PUT_LINE(' BEGIN DBMS_SERVICE.CREATE_SERVICE('''||l_rec.instance_name||''','''||l_rec.instance_name||'''); COMMIT; END;');
        DBMS_OUTPUT.PUT_LINE(' /');
        DBMS_OUTPUT.PUT_LINE(' BEGIN DBMS_SERVICE.START_SERVICE('''||l_rec.instance_name||''','''||l_rec.instance_name||'''); COMMIT; END;');
        DBMS_OUTPUT.PUT_LINE(' /');
    END LOOP;

    --2.check that there is a service created having exactly the same name as the instance
    --  and that instance_name = service_name = network name
    IF l_entered_in_loop = FALSE THEN
       l_first_time_in_loop := TRUE;
       FOR l_rec IN (SELECT *
                     FROM gv$instance a
                     WHERE UPPER(instance_name) NOT IN
                        (SELECT UPPER(network_name)
                         FROM sys.dba_services --Note: gv$services can not be trusted in this query
                         WHERE UPPER(name)=UPPER(a.instance_name)
                         AND UPPER(name)=UPPER(network_name))) LOOP
           l_entered_in_loop := TRUE;
           IF l_first_time_in_loop THEN
              DBMS_OUTPUT.PUT_LINE('WARNING-WARNING-WARNING-WARNING-WARNING-WARNING-WARNING-WARNING-WARNING');
              DBMS_OUTPUT.PUT_LINE('***********************************************************************');
              DBMS_OUTPUT.PUT_LINE('WARNING:There is no service with a service name (and network name) = instance name');
              DBMS_OUTPUT.PUT_LINE('This mandatory for the type of jobs used by Unilab');
              l_first_time_in_loop := FALSE;
           END IF;
           DBMS_OUTPUT.PUT_LINE(' instance name: '||l_rec.instance_name||'.You should perform a:');
           DBMS_OUTPUT.PUT_LINE(' BEGIN DBMS_SERVICE.CREATE_SERVICE('''||l_rec.instance_name||''','''||l_rec.instance_name||'''); COMMIT; END;');
           DBMS_OUTPUT.PUT_LINE(' /');
           DBMS_OUTPUT.PUT_LINE(' BEGIN DBMS_SERVICE.START_SERVICE('''||l_rec.instance_name||''','''||l_rec.instance_name||'''); COMMIT; END;');
          DBMS_OUTPUT.PUT_LINE(' /');
       END LOOP;
    END IF;

    --3.check that if these services are runing for every instance
    IF l_entered_in_loop = FALSE THEN
       l_first_time_in_loop := TRUE;
       FOR l_rec IN (SELECT *
                     FROM gv$instance a
                     WHERE UPPER(instance_name) NOT IN
                        (SELECT UPPER(b.name)
                         FROM gv$active_services b
                         WHERE UPPER(b.name)=UPPER(a.instance_name)
                         AND UPPER(b.name)=UPPER(b.network_name))) LOOP
           l_entered_in_loop := TRUE;
           IF l_first_time_in_loop THEN
              DBMS_OUTPUT.PUT_LINE('WARNING-WARNING-WARNING-WARNING-WARNING-WARNING-WARNING-WARNING-WARNING');
              DBMS_OUTPUT.PUT_LINE('***********************************************************************');
              DBMS_OUTPUT.PUT_LINE('WARNING:Some services necessary for runing the jobs are not runing');
              DBMS_OUTPUT.PUT_LINE('This mandatory for the type of jobs used by Unilab');
              l_first_time_in_loop := FALSE;
           END IF;
           DBMS_OUTPUT.PUT_LINE(' instance name: '||l_rec.instance_name||' (You should perform a:');
           DBMS_OUTPUT.PUT_LINE(' BEGIN DBMS_SERVICE.START_SERVICE('''||l_rec.instance_name||''','''||l_rec.instance_name||'''); COMMIT; END;');
       END LOOP;
    END IF;

    --4.check that if these services are runing on the correct instance
    --  Oracle doesn't start systematically the the services that have a name
    --  corresponding to one instance name on a specific instance
    IF l_entered_in_loop = FALSE THEN
       l_first_time_in_loop := TRUE;
       FOR l_rec IN (SELECT a.instance_name, c.instance_name wrong_instance
                     FROM gv$instance c, gv$instance a, gv$active_services b
                     WHERE b.inst_id<>a.inst_id
                     AND UPPER(a.instance_name)=UPPER(b.name)
                     AND b.inst_id=c.inst_id) LOOP
           l_entered_in_loop := TRUE;
           IF l_first_time_in_loop THEN
              DBMS_OUTPUT.PUT_LINE('WARNING-WARNING-WARNING-WARNING-WARNING-WARNING-WARNING-WARNING-WARNING');
              DBMS_OUTPUT.PUT_LINE('***********************************************************************');
              DBMS_OUTPUT.PUT_LINE('WARNING:Some services necessary for runing the jobs are runing but on the wrong instance');
              DBMS_OUTPUT.PUT_LINE('These should be stopped and restarted specifying the correct instance');
              l_first_time_in_loop := FALSE;
           END IF;
           DBMS_OUTPUT.PUT_LINE(' instance name: '||l_rec.instance_name||' (You should perform a:');
           DBMS_OUTPUT.PUT_LINE(' BEGIN DBMS_SERVICE.STOP_SERVICE('''||l_rec.instance_name||''','''||l_rec.wrong_instance||'''); COMMIT; END;');
           DBMS_OUTPUT.PUT_LINE(' BEGIN DBMS_SERVICE.START_SERVICE('''||l_rec.instance_name||''','''||l_rec.instance_name||'''); COMMIT; END;');
       END LOOP;
    END IF;

/* ----------------------------------------------------------------------- */
/****** Standard jobs (must be running)                                    */
/* ----------------------------------------------------------------------- */
      --Dynamic SQL is intentionaly used to avoid package dependencies
      -- Start Unilab 4 standard jobs
      BEGIN
         l_job_cursor := DBMS_SQL.open_cursor;
         l_sql_string := 'BEGIN :l_return := UNAPIEV.StartAllMgrs; END ;';
         DBMS_SQL.parse (l_job_cursor, l_sql_string, DBMS_SQL.v7); -- NO single quote handling required
         DBMS_SQL.bind_variable (l_job_cursor, ':l_return', l_return);
         l_ret_code := DBMS_SQL.execute (l_job_cursor);
         DBMS_SQL.VARIABLE_VALUE(l_job_cursor, ':l_return', l_return);

         IF l_return <> 0
         THEN
            DBMS_OUTPUT.put_line ('StartAllMgrs failed: ' || l_return);
         ELSE
            DBMS_OUTPUT.put_line ('StartAllMgrs successful');
         END IF;

         DBMS_SQL.close_cursor (l_job_cursor);
      EXCEPTION
         WHEN OTHERS
         THEN
            l_sqlerrm := SUBSTR (SQLERRM, 1, 255);
            DBMS_OUTPUT.put_line ('StartAllMgrs failed: ');
            DBMS_OUTPUT.put_line (l_sqlerrm);
            DBMS_SQL.close_cursor (l_job_cursor);
      END;

      BEGIN
         l_return := UNAPIEV.StartEventmgr('DEDICEVMGR', 1, 200);
         IF l_return <> 0 THEN
            DBMS_OUTPUT.PUT_LINE('StartDedMgrs returned '||l_return);
         ELSE
            DBMS_OUTPUT.PUT_LINE('StartDedMgrs OK ');
         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            l_sqlerrm := SUBSTR (SQLERRM, 1, 255);
            DBMS_OUTPUT.put_line ('StartDedMgrs failed: ');
            DBMS_OUTPUT.put_line (l_sqlerrm);
      END;
/* ----------------------------------------------------------------------- */
/****** Optional jobs are commented out (only when necessary)              */
/* Uncomment symetrically in the startalldbjobs and                        */
/* stopalldbjobs and adapt                                                 */
/* ----------------------------------------------------------------------- */

      -- Start Unilab 4 sample planner job TJR 2010-03-17
      BEGIN
         --l_first_run :=  'TRUNC(CURRENT_TIMESTAMP + 7, ''DAY'')+1'; -- start volgende maandag 0:00
         --l_next_run :=   'TRUNC(CURRENT_TIMESTAMP + 7, ''DAY'')+1'; -- start na de 1e run

         l_first_run :=  'TRUNC(next_day(CURRENT_TIMESTAMP, ''MONDAY''))'; -- start volgende maandag 0:00
         l_next_run :=   'TRUNC(next_day(CURRENT_TIMESTAMP, ''MONDAY''))'; -- start na de 1e run

         l_start_date := 'TRUNC(CURRENT_TIMESTAMP, ''DD'')'; -- plan alles van de huidige week
         l_end_date :=   'TRUNC(CURRENT_TIMESTAMP, ''DD'') + 7 - 1/86400'; -- plan alles tot 1 seconde voor volgende run
         l_incr := 24;

         l_job_cursor := DBMS_SQL.open_cursor;
         l_sql_string := 'BEGIN :l_return := UNAPIPLAN.StartSamplePlanner(:l_first_run, :l_next_run, :l_start_date, '||
                                       ' :l_end_date, :l_incr); END ;';
         DBMS_SQL.parse (l_job_cursor, l_sql_string, DBMS_SQL.v7); -- NO single quote handling required
         DBMS_SQL.bind_variable (l_job_cursor, ':l_return', l_return);
         DBMS_SQL.bind_variable (l_job_cursor, ':l_first_run', l_first_run);
         DBMS_SQL.bind_variable (l_job_cursor, ':l_next_run', l_next_run);
         DBMS_SQL.bind_variable (l_job_cursor, ':l_start_date', l_start_date);
         DBMS_SQL.bind_variable (l_job_cursor, ':l_end_date', l_end_date);
         DBMS_SQL.bind_variable (l_job_cursor, ':l_incr', l_incr);
         l_ret_code := DBMS_SQL.execute (l_job_cursor);
         DBMS_SQL.VARIABLE_VALUE(l_job_cursor, ':l_return', l_return);

         IF l_return <> 0
         THEN
            DBMS_OUTPUT.put_line ('StartSamplePlanner failed: ' || l_return);
         ELSE
            DBMS_OUTPUT.put_line ('StartSamplePlanner successful');
         END IF;

         DBMS_SQL.close_cursor (l_job_cursor);
      EXCEPTION
         WHEN OTHERS
         THEN
            l_sqlerrm := SUBSTR (SQLERRM, 1, 255);
            DBMS_OUTPUT.put_line ('StartSamplePlanner failed: ');
            DBMS_OUTPUT.put_line (l_sqlerrm);
            DBMS_SQL.close_cursor (l_job_cursor);
      END;
      -- Start the speCX jobs that must be running on the Unilab 4 database
      -- when using the speCX-Unilab interface
      BEGIN
         l_job_cursor := DBMS_SQL.open_cursor;
         l_sql_string := 'BEGIN :l_return := pa_SpecxInterface.f_StartInterface; END ;';
         DBMS_SQL.parse (l_job_cursor, l_sql_string, DBMS_SQL.v7); -- NO single quote handling required
         DBMS_SQL.bind_variable (l_job_cursor, ':l_return', l_return);
         l_ret_code := DBMS_SQL.execute (l_job_cursor);
         DBMS_SQL.VARIABLE_VALUE(l_job_cursor, ':l_return', l_return);

         IF l_return <> 0 THEN
            DBMS_OUTPUT.put_line ('pa_SpecxInterface.f_StartInterface failed: ' || l_return);
         ELSE
            DBMS_OUTPUT.put_line ('pa_SpecxInterface.f_StartInterface successful');
         END IF;

         DBMS_SQL.close_cursor (l_job_cursor);
      EXCEPTION
         WHEN OTHERS
         THEN
            l_sqlerrm := SUBSTR (SQLERRM, 1, 255);
            DBMS_OUTPUT.put_line ('pa_SpecxInterface.f_StartInterface failed: ');
            DBMS_OUTPUT.put_line (l_sqlerrm);
            DBMS_SQL.close_cursor (l_job_cursor);
      END;

      -- You could find the time zone region in v$timezone_names
      -- Start the Unilink job
      -- 05/02/2014 | JR | Change Unilink to level 3 and trace_on 1 (old was: 0 ,0)
      -- 31/03/2016 | JP | Change Unilink to level 0 and trace_on 1 (old was: 0 ,0)
      BEGIN
         l_job_cursor := DBMS_SQL.open_cursor;
         l_sql_string := 'BEGIN :l_return := UNAPIUL.StartUnilink(''UNICONNECT'',''1'',''OS'',''\'', 3, ''1'', ''''); END ;';
         DBMS_SQL.parse (l_job_cursor, l_sql_string, DBMS_SQL.v7); -- NO single quote handling required
         DBMS_SQL.bind_variable (l_job_cursor, ':l_return', l_return);
         l_ret_code := DBMS_SQL.execute (l_job_cursor);
         DBMS_SQL.VARIABLE_VALUE(l_job_cursor, ':l_return', l_return);

         IF l_return <> 0 THEN
            DBMS_OUTPUT.put_line ('UNAPIUL.StartUnilink failed: ' || l_return);
         ELSE
            DBMS_OUTPUT.put_line ('UNAPIUL.StartUnilink successful');
         END IF;

         DBMS_SQL.close_cursor (l_job_cursor);
      EXCEPTION
         WHEN OTHERS
         THEN
            l_sqlerrm := SUBSTR (SQLERRM, 1, 255);
            DBMS_OUTPUT.put_line ('UNAPIUL.StartUnilink failed: ');
            DBMS_OUTPUT.put_line (l_sqlerrm);
            DBMS_SQL.close_cursor (l_job_cursor);
      END;

      BEGIN
         l_job_cursor := DBMS_SQL.open_cursor;
         l_sql_string := 'begin  apao_outdoor.startoutdooreventmgr; :l_return:=0; end;';
         DBMS_SQL.parse (l_job_cursor, l_sql_string, DBMS_SQL.v7); -- NO single quote handling required
         DBMS_SQL.bind_variable (l_job_cursor, ':l_return', l_return);
         l_ret_code := DBMS_SQL.execute (l_job_cursor);
         DBMS_SQL.VARIABLE_VALUE(l_job_cursor, ':l_return', l_return);

         IF l_return <> 0 THEN
            DBMS_OUTPUT.put_line ('apao_outdoor.startoutdooreventmgr failed: ' || l_return);
         ELSE
            DBMS_OUTPUT.put_line ('apao_outdoor.startoutdooreventmgr successful');
         END IF;

         DBMS_SQL.close_cursor (l_job_cursor);
      EXCEPTION
         WHEN OTHERS
         THEN
            l_sqlerrm := SUBSTR (SQLERRM, 1, 255);
            DBMS_OUTPUT.put_line ('apao_outdoor.startoutdooreventmgr failed: ');
            DBMS_OUTPUT.put_line (l_sqlerrm);
            DBMS_SQL.close_cursor (l_job_cursor);
      END;
      
      /*
      -- Start the SAP job
      BEGIN
        --Only start when not already started
         OPEN l_check_jobs_cursor('GetWorklistFromSAP');
         FETCH l_check_jobs_cursor INTO l_job;
         l_found := l_check_jobs_cursor%FOUND;
         CLOSE l_check_jobs_cursor;

         IF l_found THEN
            DBMS_OUTPUT.put_line ('SAP Interface job is already runing, not started back');
       ELSE
            SELECT MAX(DECODE(setting_name, 'SAP_INTERF_USED', setting_value, NULL)) sap_interf_used,
                   MAX(DECODE(setting_name, 'SAP_WORKLISTINTERVAL', setting_value, NULL))  sap_worklistrq_interval_s
            INTO l_sap_interf_used, l_sap_worklistrq_interval_s
            FROM utsystem
            WHERE setting_name IN ('SAP_INTERF_USED', 'SAP_WORKLISTINTERVAL');

            IF l_sap_interf_used = 'YES' THEN
               IF l_sap_worklistrq_interval_s IS NULL THEN
                   l_sap_worklistrq_interval  := 12*60;
           ELSE
               BEGIN
                 EXECUTE IMMEDIATE 'DECLARE l_sap_job_interval NUMBER; BEGIN :l_sap_job_interval := '||l_sap_worklistrq_interval_s||'; END;' USING OUT  l_sap_worklistrq_interval;
                 EXCEPTION
             WHEN OTHERS THEN
                 l_sap_worklistrq_interval := 12*60;
              END;
               END IF;
             l_job := 'UNI_J_SAPIF';
                DBMS_SCHEDULER.CREATE_JOB(
                        job_name             =>  l_job,
                        job_class            => 'UNI_JC_OTHER_JOBS',
                        job_type             =>  'PLSQL_BLOCK',
                        job_action           =>   'DECLARE l_ret INTEGER; BEGIN   l_ret := UNACTION.GetWorklistFromSAP; '||
                                                        'IF l_ret <> UNAPIGEN.DBERR_SUCCESS THEN '||
                                                        'UNAPIGEN.LogError(''SAP job'', ''GetWorklistFromSAP returned =''||l_ret);  END IF; END;',
                        start_date           =>   CURRENT_TIMESTAMP,
                        --repeat_interval   =>  'FREQ = MINUTELY; INTERVAL = ' || l_sap_worklistrq_interval,
                        --was leading to an exception with an interval > 999
                        repeat_interval      =>  UNAPIEV.SQLTranslatedJobInterval(l_sap_worklistrq_interval, 'minutes'),
                        enabled              => TRUE
                );
                DBMS_SCHEDULER.SET_ATTRIBUTE (
                        name           => l_job,
                        attribute      => 'restartable',
                        value          => TRUE);
               Unapigen.U4COMMIT;
               DBMS_OUTPUT.put_line ('Scheduling SAP JOB successful');
            END IF;
        END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            l_sqlerrm := SUBSTR (SQLERRM, 1, 255);
            DBMS_OUTPUT.put_line ('Scheduling SAP JOB failed:');
            DBMS_OUTPUT.put_line (l_sqlerrm);

      END;
      */
      StartClearUterror;
      StartClearATEVLOG;
      SyncStStatusWithIS;
      StartMeRemGkIsRel;
      RegularRelease;
      StartAPAOFEA;
      StartWatsonInterface;
/* ----------------------------------------------------------------------- */
/******Custom jobs                                                         */
/* ----------------------------------------------------------------------- */
      -- Add here code for starting/scheduling add-on jobs. Calling a procedure

/*
            BEGIN
                DBMS_SCHEDULER.CREATE_JOB(
                        job_name          =>  l_job,
                        job_class            => 'UNI_JC_OTHER_JOBS',
                        job_type          =>  'PLSQL_BLOCK',
                        job_action        =>  ADDONJOB,
                        start_date        =>   CURRENT_TIMESTAMP,
                        --repeat_interval   =>  'FREQ = MINUTELY; INTERVAL = 1',
                        --was leading to an exception with an interval > 999
                        repeat_interval      =>  UNAPIEV.SQLTranslatedJobInterval(1, 'minutes'),
                        enabled              => TRUE
                );
                DBMS_SCHEDULER.SET_ATTRIBUTE (
                        name           => l_job,
                        attribute      => 'restartable',
                        value          => TRUE);
               UNAPIGEN.U4COMMIT;
               DBMS_OUTPUT.put_line ('Scheduling ADDONJOB successful');

            EXCEPTION
               WHEN OTHERS
               THEN
                  l_sqlerrm := SUBSTR (SQLERRM, 1, 255);
                  DBMS_OUTPUT.put_line ('Scheduling ADDONJOB failed:');
                  DBMS_OUTPUT.put_line (l_sqlerrm);

            END;
*/

      /*
            BEGIN
               l_job_cursor := DBMS_SQL.open_cursor;
               l_sql_string := 'BEGIN :l_return := <addon startup procedure>; END ;';
               DBMS_SQL.parse (l_job_cursor, l_sql_string, DBMS_SQL.v7); -- NO single quote handling required
               DBMS_SQL.bind_variable (l_job_cursor, ':l_return', l_return);
               l_ret_code := DBMS_SQL.execute (l_job_cursor);
               DBMS_SQL.VARIABLE_VALUE(l_job_cursor, ':l_return', l_return);

               IF l_return <> 0
               THEN
                  DBMS_OUTPUT.put_line ('<addon procedure> failed: ' || l_return);
               ELSE
                  DBMS_OUTPUT.put_line ('<addon procedure> successful');
               END IF;

               DBMS_SQL.close_cursor (l_job_cursor);
            EXCEPTION
               WHEN OTHERS
               THEN
                  l_sqlerrm := SUBSTR (SQLERRM, 1, 255);
                  DBMS_OUTPUT.put_line ('StartAllMgrs failed: ');
                  DBMS_OUTPUT.put_line (l_sqlerrm);
                  DBMS_SQL.close_cursor (l_job_cursor);
            END;
      */

      FOR l_rec IN jobs_crs
      LOOP
         DBMS_OUTPUT.put_line ('  . ' || l_rec.job_action);
      END LOOP;

      -- set the original session timezone
      EXECUTE IMMEDIATE 'ALTER SESSION SET time_zone = ''' || l_session_timezone || '''';

      SELECT NVL (COUNT (*), 0)
        INTO l_ret_code
        FROM dba_scheduler_jobs
   WHERE job_name like 'UNI_J_%';
      DBMS_OUTPUT.put_line ('  ' || l_ret_code || ' jobs scheduled');
      DBMS_OUTPUT.put_line ('StartAllDbJobs successful');
      UNAPIGEN.U4COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         -- set the original session timezone
         EXECUTE IMMEDIATE 'ALTER SESSION SET time_zone = ''' || l_session_timezone || '''';
         l_sqlerrm := SUBSTR (SQLERRM, 1, 255);
         DBMS_OUTPUT.put_line ('StartAllDbJobs failed:');
         DBMS_OUTPUT.put_line (l_sqlerrm);
   END startalldbjobs;

   PROCEDURE stopalldbjobs
   IS
      l_ret_code     INTEGER;
      l_return       INTEGER;
      l_job           VARCHAR2(30);
      l_action         VARCHAR2(4000);
      l_sqlerrm      VARCHAR2 (255);
      l_count        NUMBER;
      l_job_cursor   INTEGER;
      l_sql_string   VARCHAR2 (1014);
      l_job_name     VARCHAR2(100);
      l_found        BOOLEAN;
      l_leave_loop   BOOLEAN;
      l_attempts     INTEGER;
      l_session_timezone   VARCHAR2(64);

      CURSOR jobs_crs
      IS
         SELECT job_action
           FROM dba_scheduler_jobs
      WHERE UPPER (job_name) LIKE 'UNI_J%'
          ORDER BY job_action;

      CURSOR l_addon_job_cursor
      IS
         SELECT job_name, job_action
           FROM dba_scheduler_jobs
          WHERE UPPER (job_action) NOT LIKE '%EVENTMANAGERJOB%'
            AND UPPER (job_action) NOT LIKE '%TIMEDEVENTMGR%'
            AND UPPER (job_action) NOT LIKE '%EQUIPMENTMANAGERJOB%'
            AND UPPER (job_action) NOT LIKE '%UNILINK%'
       AND UPPER (job_name) LIKE 'UNI_J%';

      CURSOR l_check_jobs_cursor (a_search VARCHAR2)
      IS
         SELECT job_name
         FROM sys.dba_scheduler_jobs
         WHERE INSTR(job_action, a_search)<>0;
   BEGIN
      -- Synchronize the session NLS settings to be set
      -- equal to the database instance NLS settings.
      -- Note that this requires the database to be started
      -- with the correct NLS settings.
      SELECT SESSIONTIMEZONE
        INTO l_session_timezone
        FROM DUAL;
      EXECUTE IMMEDIATE 'ALTER SESSION SET time_zone = DBTIMEZONE';


      Cxdba.syncnls;
      SELECT NVL (COUNT (*), 0)
        INTO l_ret_code
        FROM dba_scheduler_jobs
   WHERE job_name like 'UNI_J_%';
      DBMS_OUTPUT.put_line ('  ' || l_ret_code || ' jobs scheduled');


      --attempt to stop the event manager jobs if not in status running
      --without using the official startalljobs
      --This has been added for RAC support
      --since someone might forget to start the necessary services
      --for the UNILAB jobs on a RAC db.
      --The effect is that the jobs are scheduled but not runing
      --The standatd StopAllMggrs works only for the runing one
      --and do not try to force the stop
      --
      FOR l_evjob_rec IN (SELECT *
                          FROM sys.dba_scheduler_jobs
                          WHERE job_class LIKE 'UNI_JC_EVENTMGR_%'
                          AND state <> 'RUNNING') LOOP
          DBMS_SCHEDULER.DROP_JOB(job_name =>l_evjob_rec.job_name,
                                  force=> TRUE);
      END LOOP;

/* ----------------------------------------------------------------------- */
/******Custom jobs                                                         */
/* ----------------------------------------------------------------------- */
      -- Stop Addon Jobs, calling Dynamic Sql
/*
      BEGIN
         l_job_cursor := DBMS_SQL.open_cursor;
         l_sql_string := 'BEGIN :l_return := <Addon Stop Procedure>; END ;';
         DBMS_SQL.parse (l_job_cursor, l_sql_string, DBMS_SQL.v7); -- NO single quote handling required
         DBMS_SQL.bind_variable (l_job_cursor, ':l_return', l_return);
         l_ret_code := DBMS_SQL.execute (l_job_cursor);
         DBMS_SQL.VARIABLE_VALUE(l_job_cursor, ':l_return', l_return);

         IF l_return <> 0
         THEN
            DBMS_OUTPUT.put_line ('<Name Addon job> failed: ' || l_return);
         ELSE
            DBMS_OUTPUT.put_line ('<Name Addon job> successful');
         END IF;

         DBMS_SQL.close_cursor (l_job_cursor);
      EXCEPTION
         WHEN OTHERS
         THEN
            l_sqlerrm := SUBSTR (SQLERRM, 1, 255);
            DBMS_OUTPUT.put_line ('<Name Addon job> failed: ');
            DBMS_OUTPUT.put_line (l_sqlerrm);
            DBMS_SQL.close_cursor (l_job_cursor);
      END;
*/

/* ----------------------------------------------------------------------- */
/****** Optional jobs are commented out (only when necessary)              */
/* Uncomment symetrically in the startalldbjobs and                        */
/* stopalldbjobs and adapt                                                 */
/* ----------------------------------------------------------------------- */

      BEGIN
      -- Stop 
         l_job_cursor := DBMS_SQL.open_cursor;
         l_sql_string := 'begin  apao_outdoor.stopoutdooreventmgr; :l_return:=0; end;';
         DBMS_SQL.parse (l_job_cursor, l_sql_string, DBMS_SQL.v7); -- NO single quote handling required
         DBMS_SQL.bind_variable (l_job_cursor, ':l_return', l_return);
         l_ret_code := DBMS_SQL.execute (l_job_cursor);
         DBMS_SQL.VARIABLE_VALUE(l_job_cursor, ':l_return', l_return);

         IF l_return <> 0 THEN
            DBMS_OUTPUT.put_line ('apao_outdoor.stopoutdooreventmgr failed: ' || l_return);
         ELSE
            DBMS_OUTPUT.put_line ('apao_outdoor.stopoutdooreventmgr successful');
         END IF;

         DBMS_SQL.close_cursor (l_job_cursor);
      EXCEPTION
         WHEN OTHERS
         THEN
            l_sqlerrm := SUBSTR (SQLERRM, 1, 255);
            DBMS_OUTPUT.put_line ('apao_outdoor.stopoutdooreventmgr failed: ');
            DBMS_OUTPUT.put_line (l_sqlerrm);
            DBMS_SQL.close_cursor (l_job_cursor);
      END;
      -- Stop the SAP job
      BEGIN

         /*---------------------------------------------------------------------------*/
         /* Check if job exists                                                       */
         /*---------------------------------------------------------------------------*/
         OPEN l_check_jobs_cursor('GetWorklistFromSAP');
         FETCH l_check_jobs_cursor INTO l_job;
         l_found := l_check_jobs_cursor%FOUND;
         CLOSE l_check_jobs_cursor;

         IF l_found THEN
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
            OPEN l_check_jobs_cursor('GetWorklistFromSAP');
            FETCH l_check_jobs_cursor INTO l_job;
            l_found := l_check_jobs_cursor%FOUND;
            CLOSE l_check_jobs_cursor;
            IF NOT l_found THEN
               l_leave_loop := TRUE;
            ELSE
               IF l_attempts >= 10 THEN
                  DBMS_OUTPUT.put_line ('Stop of SAP job failed ! (timeout after 20 seconds)');
               ELSE
                  DBMS_LOCK.SLEEP(2);
               END IF;
            END IF;
         END LOOP;

      EXCEPTION
         WHEN OTHERS
         THEN
            l_sqlerrm := SUBSTR (SQLERRM, 1, 255);
            DBMS_OUTPUT.put_line ('Stop of SAP job failed: ');
            DBMS_OUTPUT.put_line (l_sqlerrm);
      END;

      -- Stop the Unilink job
      BEGIN
         l_job_cursor := DBMS_SQL.open_cursor;
         l_sql_string := 'BEGIN :l_return := UNAPIUL.StopUnilink(''UNICONNECT''); END ;';
         DBMS_SQL.parse (l_job_cursor, l_sql_string, DBMS_SQL.v7); -- NO single quote handling required
         DBMS_SQL.bind_variable (l_job_cursor, ':l_return', l_return);
         l_ret_code := DBMS_SQL.execute (l_job_cursor);
         DBMS_SQL.VARIABLE_VALUE(l_job_cursor, ':l_return', l_return);

         IF l_return <> 0 THEN
            DBMS_OUTPUT.put_line ('UNAPIUL.StopUnilink failed: ' || l_return);
         ELSE
            DBMS_OUTPUT.put_line ('UNAPIUL.StopUnilink successful');
         END IF;

         DBMS_SQL.close_cursor (l_job_cursor);
      EXCEPTION
         WHEN OTHERS
         THEN
            l_sqlerrm := SUBSTR (SQLERRM, 1, 255);
            DBMS_OUTPUT.put_line ('UNAPIUL.StopUnilink failed: ');
            DBMS_OUTPUT.put_line (l_sqlerrm);
            DBMS_SQL.close_cursor (l_job_cursor);
      END;

      -- Stop the speCX jobs that must be running on the Unilab 4 database
      -- when using the speCX-Unilab interface
      BEGIN
         l_job_cursor := DBMS_SQL.open_cursor;
         l_sql_string := 'BEGIN :l_return := pa_SpecxInterface.f_StopInterface; END ;';
         DBMS_SQL.parse (l_job_cursor, l_sql_string, DBMS_SQL.v7); -- NO single quote handling required
         DBMS_SQL.bind_variable (l_job_cursor, ':l_return', l_return);
         l_ret_code := DBMS_SQL.execute (l_job_cursor);
         DBMS_SQL.VARIABLE_VALUE(l_job_cursor, ':l_return', l_return);

         IF l_return <> 0
         THEN
            DBMS_OUTPUT.put_line ('pa_SpecxInterface.f_StopInterface failed: ' || l_return);
         ELSE
            DBMS_OUTPUT.put_line ('pa_SpecxInterface.f_StopInterface successful');
         END IF;

         DBMS_SQL.close_cursor (l_job_cursor);
      EXCEPTION
         WHEN OTHERS
         THEN
            l_sqlerrm := SUBSTR (SQLERRM, 1, 255);
            DBMS_OUTPUT.put_line ('pa_SpecxInterface.f_StopInterface failed: ');
            DBMS_OUTPUT.put_line (l_sqlerrm);
            DBMS_SQL.close_cursor (l_job_cursor);
      END;

      -- Stop the sample planner
      BEGIN
         l_job_cursor := DBMS_SQL.open_cursor;
         l_sql_string := 'BEGIN :l_return := UNAPIPLAN.StopSamplePlanner; END ;';
         DBMS_SQL.parse (l_job_cursor, l_sql_string, DBMS_SQL.v7); -- NO single quote handling required
         DBMS_SQL.bind_variable (l_job_cursor, ':l_return', l_return);
         l_ret_code := DBMS_SQL.execute (l_job_cursor);
         DBMS_SQL.VARIABLE_VALUE(l_job_cursor, ':l_return', l_return);

         IF l_return <> 0
         THEN
            DBMS_OUTPUT.put_line ('UNAPIPLAN.StopSamplePlanner failed: ' || l_return);
         ELSE
            DBMS_OUTPUT.put_line ('UNAPIPLAN.StopSamplePlanner successful');
         END IF;

         DBMS_SQL.close_cursor (l_job_cursor);
      EXCEPTION
         WHEN OTHERS
         THEN
            l_sqlerrm := SUBSTR (SQLERRM, 1, 255);
            DBMS_OUTPUT.put_line ('UNAPIPLAN.StopSamplePlanner failed: ');
            DBMS_OUTPUT.put_line (l_sqlerrm);
            DBMS_SQL.close_cursor (l_job_cursor);
      END;

      -- Stop pending Database Jobs (not standard jobs)
      BEGIN
         OPEN l_addon_job_cursor;

         LOOP
            FETCH l_addon_job_cursor INTO l_job, l_action ;
            EXIT WHEN l_addon_job_cursor%NOTFOUND;
            DBMS_SCHEDULER.DROP_JOB(l_job);
            DBMS_OUTPUT.put_line ( 'Stop <' || l_action || '> successful');
         END LOOP;

         CLOSE l_addon_job_cursor;
         UNAPIGEN.U4COMMIT;
         DBMS_OUTPUT.put_line ('Unscheduling ADDONJOBs successful');
      EXCEPTION
         WHEN OTHERS
         THEN
            l_sqlerrm := SUBSTR (SQLERRM, 1, 255);
            DBMS_OUTPUT.put_line ('Unscheduling ADDONJOBs failed:');
            DBMS_OUTPUT.put_line (l_sqlerrm);
      END;

      BEGIN
         l_return := UNAPIEV.StopEventmgr('DEDICEVMGR');
         IF l_return <> 0 THEN
            DBMS_OUTPUT.PUT_LINE('StopDedMgrs returned '||l_return);
         ELSE
            DBMS_OUTPUT.PUT_LINE('StopDedMgrs OK ');
         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            l_sqlerrm := SUBSTR (SQLERRM, 1, 255);
            DBMS_OUTPUT.put_line ('StopDedMgrs failed: ');
            DBMS_OUTPUT.put_line (l_sqlerrm);
      END;
/* ----------------------------------------------------------------------- */
/****** Standard jobs (Good practice: stopped as last)                     */
/* ----------------------------------------------------------------------- */
      -- Stop Unilab 4 standard jobs
      BEGIN
         l_job_cursor := DBMS_SQL.open_cursor;
         l_sql_string := 'BEGIN :l_return := UNAPIEV.StopAllMgrs; END ;';
         DBMS_SQL.parse (l_job_cursor, l_sql_string, DBMS_SQL.v7); -- NO single quote handling required
         DBMS_SQL.bind_variable (l_job_cursor, ':l_return', l_return);
         l_ret_code := DBMS_SQL.execute (l_job_cursor);
         DBMS_SQL.VARIABLE_VALUE(l_job_cursor, ':l_return', l_return);

         IF l_return <> 0
         THEN
            DBMS_OUTPUT.put_line ('StopAllMgrs failed: ' || l_return);
         ELSE
            DBMS_OUTPUT.put_line ('StopAllMgrs successful');
         END IF;

         DBMS_SQL.close_cursor (l_job_cursor);
      EXCEPTION
         WHEN OTHERS
         THEN
            l_sqlerrm := SUBSTR (SQLERRM, 1, 255);
            DBMS_OUTPUT.put_line ('StopAllMgrs failed: ');
            DBMS_OUTPUT.put_line (l_sqlerrm);
            DBMS_SQL.close_cursor (l_job_cursor);
      END;

      FOR l_rec IN jobs_crs
      LOOP
         DBMS_OUTPUT.put_line ('  . ' || l_rec.job_action);
      END LOOP;
      -- set the original session timezone
      EXECUTE IMMEDIATE 'ALTER SESSION SET time_zone = ''' || l_session_timezone || '''';

      SELECT NVL (COUNT (*), 0)
        INTO l_ret_code
        FROM dba_scheduler_jobs
   WHERE job_name like 'UNI_J_%';
      DBMS_OUTPUT.put_line ('  ' || l_ret_code || ' jobs still scheduled');
      DBMS_OUTPUT.put_line ('StopAllDbJobs successful');
      UNAPIGEN.U4COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         -- set the original session timezone
         EXECUTE IMMEDIATE 'ALTER SESSION SET time_zone = ''' || l_session_timezone || '''';
         l_sqlerrm := SUBSTR (SQLERRM, 1, 255);
         DBMS_OUTPUT.put_line ('StopAllDbJobs failed:');
         DBMS_OUTPUT.put_line (l_sqlerrm);
   END stopalldbjobs;
--
procedure restartalldbjabs
is
begin
  stopalldbjobs;
  --
  startalldbjobs;
end;

END Cxapp;
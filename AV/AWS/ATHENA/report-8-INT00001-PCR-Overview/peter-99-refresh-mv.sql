--FULL-REFRESH OF ALL MATERIALIZED VIEWS

/*
IIRC, refreshing a materialized view drops the existing data and create a new "table" with the current data.
What this does for your indexes is re-index the entire subset of data, which based on your indexes send like a significant workload.
*/

--interspec:
--base MV STEP1:
REFRESH MATERIALIZED VIEW sc_lims_dal.mv_bom_header_property;
REFRESH MATERIALIZED VIEW sc_lims_dal.mv_bom_item_property;
REFRESH MATERIALIZED VIEW sc_lims_dal.mv_specification_status;
REFRESH MATERIALIZED VIEW sc_lims_dal.mv_specification_keyword;

--create function bom-explode...

--base MV STEP2:
REFRESH MATERIALIZED VIEW sc_lims_dal.mv_bom_path_current ;
REFRESH MATERIALIZED VIEW sc_lims_dal.mv_frame_property_matrix;
REFRESH MATERIALIZED VIEW sc_lims_dal.mv_specification_property;     
REFRESH MATERIALIZED VIEW sc_lims_dal.mv_specification;
REFRESH MATERIALIZED VIEW sc_lims_dal.mv_specification_section;
REFRESH MATERIALIZED VIEW sc_lims_dal.mv_specification_property_matrix;

--TOP-MV
--interspec:
REFRESH MATERIALIZED VIEW sc_lims_dal.mv_pcr_overview;
REFRESH MATERIALIZED VIEW sc_lims_dal.mv_pcr_general_information;
REFRESH MATERIALIZED VIEW sc_lims_dal.mv_pcr_1st_stage_components;
REFRESH MATERIALIZED VIEW sc_lims_dal.mv_pcr_2nd_stage_components;


--En eventueel:
--unilab
REFRESH MATERIALIZED VIEW sc_lims_dal.mv_avtestmethod;




/*
Pg_Cron Setup
There are some preliminary steps before this scheduler can be used. First, pg_cron needs to be added to the parameter, shared_preload_libraries. 
Then, administrator should restart the database instance. 
From a database account with superuser privilege, create the extension: 	CREATE EXTENSION pg_cron. 
All of the pg_cron objects run in the database called postgres. 
Users who need to use pg_cron can be granted privilege using command, 		GRANT USER ON SCHEMA cron to user;  
(That user also needs to have permission on the underlying tables.)

Scheduling the MV Refresh
Use the function, cron.schedule to inititate a job in the default postgres database. The return value is the job_id. The syntax is:

cron.schedule (job_name, schedule, command);
The schedule entry uses the same cron syntax as normally used in Unix. Note that job_name is optional. 

The cron entry uses the format:  	Minute Hour Day Month Day-of-Week
Thus, the following command schedules a refresh of our MV “ABC” at noon every day:

SELECT cron.schedule ('REFRESHMV',0 12 * * *, 'REFRESH MATERIALIZED VIEW ABC');

Removing a scheduled job uses the function:					 CRON.UNSCHEDULE().
The status of run jobs can be found in the table:			 CRON.JOB_RUN_DETAILS.

The following are key Parameters related to pg_cron:
cron.host: 					The hostname to connect to PostgreSQL. 
cron.log_run: 				Log each job in job_run_details. 
cron.log_statement: 		Log all cron statements 
cron.max_running_jobs: 		Maximum number of concurrent jobs.
cron.use_background_workers Use background workers instead of client sessions. 

Display current settings of above parameters using:				SELECT name, setting, short_desc FROM pg_settings WHERE name LIKE 'cron.%';

*/




SELECT cron.schedule ('REFRESHMV',0 12 * * *, 'REFRESH MATERIALIZED VIEW ABC');













--*************************************************

WITH pgdata AS (
SELECT setting AS path
FROM  pg_settings
WHERE name = 'data_directory'
)
,path AS (
SELECT CASE
       WHEN pgdata.separator = '/' THEN '/'    -- UNIX
       ELSE '\'                                -- WINDOWS'
       END AS separator
FROM  (SELECT SUBSTR(path, 1, 1) AS separator FROM pgdata) AS pgdata  
)
SELECT  ns.nspname||'.'||c.relname AS mview
,       (pg_stat_file(pgdata.path||path.separator||pg_relation_filepath(ns.nspname||'.'||c.relname))).modification AS refresh
FROM pgdata
,    path
,    pg_class c JOIN pg_namespace ns ON c.relnamespace=ns.oid
WHERE c.relkind='m'
;

--SQL Error [42501]: ERROR: permission denied for function pg_stat_file

SELECT owner, mview_name, last_refresh_date
  FROM all_mviews

 WHERE owner = <<user that owns the materialized view>>
   AND mview_name = <<name of the materialized view>>


select relfilenode from pg_class where relname = 'mv_bom_item_property';








--end script



conn system/moonflower @repm

--INIT-parameters:
STATISTICS_LEVEL		TYPICAL		(indien BASIC dan geen AWR)
TIMED_OS_STATISTICS		0
TIMED_STATISTICS		TRUE
--
CONTROL_MANAGEMENT_PACK_ACCESS	NONE
alter system set control_management_pack_access='DIAGNOSTIC+TUNING' scope=both;

--geen statistics-section available of the AWR-report: "No data exists for this section of the report"
alter system set "_object_statistics"=TRUE scope=both;




--Welke snapshots bestaan er:
set linesize 200
set pages 999
column begin_interval_time format "dd-mm-yyyy hh24:mi:ss";
column end_interval_time format "dd-mm-yyyy hh24:mi:ss";
--
select snap_id, dbid, instance_number, begin_interval_time, end_interval_time
from dba_hist_snapshot
order by snap_id
;

/*
 55926 2889296125               1 28-AUG-20 06.00.05.542 AM                                           28-AUG-20 07.00.07.701 AM
 55927 2889296125               1 28-AUG-20 07.00.07.701 AM                                           28-AUG-20 08.00.09.769 AM
 55928 2889296125               1 28-AUG-20 08.00.09.769 AM                                           28-AUG-20 09.00.11.874 AM
 55929 2889296125               1 28-AUG-20 09.00.11.874 AM                                           28-AUG-20 10.00.14.008 AM
 55930 2889296125               1 28-AUG-20 10.00.14.008 AM                                           28-AUG-20 11.00.16.130 AM
 55931 2889296125               1 28-AUG-20 11.00.16.130 AM                                           28-AUG-20 12.00.18.424 PM
 55932 2889296125               1 28-AUG-20 12.00.18.424 PM                                           28-AUG-20 01.00.21.284 PM
 55933 2889296125               1 28-AUG-20 01.00.21.284 PM                                           28-AUG-20 02.00.24.295 PM
 55934 2889296125               1 28-AUG-20 02.00.24.295 PM                                           28-AUG-20 03.00.28.436 PM
*/

--run awrrpt.sql
sqlplus system/moonflower@is61  
@C:\oracle\product\11.2.0\dbhome_1\RDBMS\ADMIN\awrrpt.sql
--roept automatisch script aan (dbid,db_name,inst_num,inst_name) vanuit zelfde connectie
/*      DBID DB_NAME     INST_NUM INST_NAME
---------- --------- ---------- ----------------
2889296125 REPM               1 repm
*/

--Opgeven parameters:
/*
Enter value for report_type (html / text): html
--
Entering the number of days (n) will result in the most recent (n) days of snapshots being listed.
Pressing <return> without specifying a number, list all completed snapshots:   2
(er wordt nu een overzicht van snapshots van laatste 2 dagen getoond...)
--
Specify the Begin and End Snapshot IDs. 
Enter value for begin_snap:            57000   (17-sept 09:00 uur)
Enter value for end_snap:              57008   (17-sept 17:00 uur)
--
The default report-file-name is awrrpt_1_57000_57008.html. to use this name, pres <return> to continue, otherwise enter an alternative.
Enter value for report_name:  E:\DBA\beheer\AWR\awrrpt_17Sept_57000_57008.html
--
Report-wordt-aangemaakt...
--
*/

--Optionally, set the snapshots for the report in script awrrpti.sql.  
--If you do not set them, you will be prompted for the values.
sqlplus system/moonflower@is61  
@C:\oracle\product\11.2.0\dbhome_1\RDBMS\ADMIN\awrrpti.sql

--report written to awrrpt_1_55900_55933.html





--repository-views:
v$active_session_history
v$metric
v$metricname
v$metric_history
v$metricgroup
DBA_HIST_ACTIVE_SESS_HISTORY
DBA_HIST_BASELINE
DBA_HIST_DATABASE_INSTANCE
DBA_HIST_SNAPSHOT
DBA_HIST_SQL_PLAN
DBA_HIST_WR_CONTROL

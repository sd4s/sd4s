--Reporting Database Schema: Example 
--This example, which requires a recovery catalog, reports the names of all datafiles and tablespaces one week ago
REPORT SCHEMA AT TIME 'SYSDATE-7';
/*
RMAN-00571: ===========================================================
RMAN-00569: =============== ERROR MESSAGE STACK FOLLOWS ===============
RMAN-00571: ===========================================================
RMAN-03002: failure of report command at 12/22/2020 18:22:38
RMAN-06137: must have recovery catalog for REPORT SCHEMA AT TIME
*/

--Reporting Datafiles Needing Incremental Backups: Example 
--This example reports all datafiles in the database that require the application of five or more incremental backups to be recovered to their current state:
REPORT NEED BACKUP INCREMENTAL 5 DATABASE;
/*
Report of files that need more than 5 incrementals during recovery
File Incrementals Name
---- ------------ ----------------------------------------------
*/
--Reporting Datafiles Needing Backups: Example 
--The following example reports all datafiles from tablespace SYSTEM that will need more than two days of archived redo logs to be applied 
--during recovery after being restored from the most recent backup:
REPORT NEED BACKUP DAYS 2 TABLESPACE SYSTEM; 
/*
Report of files whose recovery needs more than 2 days of archived logs
File Days  Name
---- ----- -----------------------------------------------------
*/
--Reporting Unrecoverable Datafiles: Example 
--The following example reports all datafiles that cannot be recovered from existing backups because redo may be missing:
REPORT UNRECOVERABLE;
/*
Report of files that need backup due to unrecoverable operations
File Type of Backup Required Name
---- ----------------------- -----------------------------------
*/

--Reporting Obsolete Backups and Copies: Example 
--The following example reports obsolete backups and copies with a redundancy of 1:
REPORT OBSOLETE;
/*
RMAN retention policy will be applied to the command
RMAN retention policy is set to redundancy 1
no obsolete backups found
*/


prompt einde script









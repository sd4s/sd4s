--USER: AWSDWH / "AVawsDWH_2021"   (BESTAAT ALLEEN NOG MAAR OP DE INTERSPEC-TEST-OMGEVING  !!!!!
--USER: AWSDWH / "AVawsDWH_2021P"   (INTERSPEC-PROD-OMGEVING  !!!!!

************************************************************************************************************
-- 1: User account privileges required on a self-managed Oracle source for AWS DMS
************************************************************************************************************
----
--SYS-grant the following privileges to the Oracle user specified in the Oracle endpoint connection settings.
--
GRANT CREATE SESSION TO AWSDWH;
GRANT SELECT ANY TRANSACTION TO AWSDWH;
GRANT SELECT ON V_$ARCHIVED_LOG TO AWSDWH;
GRANT SELECT ON V_$LOG TO AWSDWH;
GRANT SELECT ON V_$LOGFILE TO AWSDWH;
GRANT SELECT ON V_$LOGMNR_LOGS TO AWSDWH;
GRANT SELECT ON V_$LOGMNR_CONTENTS TO AWSDWH;
GRANT SELECT ON V_$DATABASE TO AWSDWH;
GRANT SELECT ON V_$THREAD TO AWSDWH;
GRANT SELECT ON V_$PARAMETER TO AWSDWH;
GRANT SELECT ON V_$NLS_PARAMETERS TO AWSDWH;
GRANT SELECT ON V_$TIMEZONE_NAMES TO AWSDWH;
GRANT SELECT ON V_$TRANSACTION TO AWSDWH;
--GRANT SELECT ON V_$CONTAINERS TO AWSDWH;                    --table or view does not exist in oracle11...
GRANT SELECT ON ALL_INDEXES TO AWSDWH;
GRANT SELECT ON ALL_OBJECTS TO AWSDWH;
GRANT SELECT ON ALL_TABLES TO AWSDWH;
GRANT SELECT ON ALL_USERS TO AWSDWH;
GRANT SELECT ON ALL_CATALOG TO AWSDWH;
GRANT SELECT ON ALL_CONSTRAINTS TO AWSDWH;
GRANT SELECT ON ALL_CONS_COLUMNS TO AWSDWH;
GRANT SELECT ON ALL_TAB_COLS TO AWSDWH;
GRANT SELECT ON ALL_IND_COLUMNS TO AWSDWH;
GRANT SELECT ON ALL_ENCRYPTED_COLUMNS TO AWSDWH;
GRANT SELECT ON ALL_LOG_GROUPS TO AWSDWH;
GRANT SELECT ON ALL_TAB_PARTITIONS TO AWSDWH;
GRANT SELECT ON SYS.DBA_REGISTRY TO AWSDWH;
GRANT SELECT ON SYS.OBJ$ TO AWSDWH;
GRANT SELECT ON DBA_TABLESPACES TO AWSDWH;
-– Required if the Oracle version is earlier than 11.2.0.3.
GRANT SELECT ON DBA_OBJECTS TO AWSDWH; 
-– Required if transparent data encryption (TDE) is enabled. For more information on using Oracle TDE with AWS DMS, see .
GRANT SELECT ON SYS.ENC$ TO AWSDWH; 
--
--UNILAB-Grant the additional following privilege for each replicated table when you are using a specific table list.
--
--GRANT SELECT on any-replicated-table to AWSDWH;
--conn UNILAB/UNILAB@U611
--conn INTERSPC/INTERSPC@IS61
set serveroutput on
declare
cursor c1 is select table_name from user_tables;
cmd varchar2(200);
begin
dbms_output.enable(1000000);
for c in c1 
loop
  cmd := 'GRANT SELECT ON '||c.table_name|| ' TO AWSDWH' ;
  DBMS_OUTPUT.PUT_LINE(cmd);
  execute immediate cmd;
end loop;
end;
/



--
--Grant the additional following privilege to expose views.
--
GRANT SELECT on ALL_VIEWS to AWSDWH;
--conn UNILAB/UNILAB@U611
/*
set serveroutput on
declare
cursor c1 is select view_name from user_views;
cmd varchar2(200);
begin
dbms_output.enable(1000000);
for c in c1 
loop
  cmd := 'GRANT SELECT ON '||c.view_name|| ' TO AWSDWH' ;
  DBMS_OUTPUT.PUT_LINE(cmd);
  --execute immediate cmd;
end loop;
end;
/
*/

--SYS-Account privileges required when using Oracle LogMiner to access the redo logs
--To access the redo logs using the Oracle LogMiner, grant the following privileges to the Oracle user specified in the 
--Oracle endpoint connection settings.
GRANT EXECUTE on DBMS_LOGMNR to AWSDWH;
GRANT SELECT on V_$LOGMNR_LOGS to AWSDWH;
GRANT SELECT on V_$LOGMNR_CONTENTS to AWSDWH;
GRANT SELECT on V$LOGMNR_LOGS to AWSDWH;
GRANT SELECT on V$LOGMNR_CONTENTS to AWSDWH;
-– Required only if the Oracle version is 12c or later
--GRANT LOGMINING to AWSDWH; 

GRANT EXECUTE on DBMS_LOGMNR to SYSTEM, UNILAB;
GRANT SELECT on V_$LOGMNR_LOGS to SYSTEM, UNILAB;
GRANT SELECT on V_$LOGMNR_CONTENTS to SYSTEM, UNILAB;
GRANT SELECT on V$LOGMNR_LOGS to SYSTEM, UNILAB;
GRANT SELECT on V$LOGMNR_CONTENTS to SYSTEM, UNILAB;



--************************************************************************************************************
--2: Preparing an Oracle self-managed source database for CDC using AWS DMS
************************************************************************************************************
--
--Run a query like the following to verify that the current version of the Oracle source database is supported by AWS DMS.
--Verifying that AWS DMS supports the source database version
SELECT name, value, description FROM v$parameter WHERE name = 'compatible';
--Here, name, value, and description are columns somewhere in the database that are being queried based on the value of name. 
--If this query runs without error, AWS DMS supports the current version of the database and you can continue with the migration. 
--If the query raises an error, AWS DMS doesn't support the current version of the database. 
--To proceed with migration, first convert the Oracle database to an version supported by AWS DMS.

--Making sure that ARCHIVELOG mode is on
--ALTER database ARCHIVELOG;

--Setting up supplemental logging
--Run the following query to verify if supplemental logging is already enabled for the database.
SELECT supplemental_log_data_min FROM v$database;
--If not, enable with user SYS the supplemental logging for the database by running the following command.
ALTER DATABASE ADD SUPPLEMENTAL LOG DATA;
alter system switch logfile; 

--controle achteraf:
SELECT SUPPLEMENTAL_LOG_DATA_MIN 
,SUPPLEMENTAL_LOG_DATA_ALL 
,SUPPLEMENTAL_LOG_DATA_PK 
,SUPPLEMENTAL_LOG_DATA_UI
,SUPPLEMENTAL_LOG_DATA_FK
FROM V$DATABASE;
/*
SUPPLEME SUP SUP SUP SUP
-------- --- --- --- ---
YES      NO  NO  NO  NO
*/




--IF PRIMARY-KEYS AVAILABLE ON A TABLE:
--ALTER TABLE <Tablename> ADD SUPPLEMENTAL LOG DATA (PRIMARY KEY) COLUMNS;
--ADD supplemental-pk-data
ALTER DATABASE ADD SUPPLEMENTAL LOG DATA (PRIMARY KEY) COLUMNS;

--IF NO PRIMARY-KEY, but an UNIQUE-INDEX
--If no primary key exists and the table has a single unique index, add all of the unique index columns to the supplemental log.
ALTER TABLE <TableName> ADD SUPPLEMENTAL LOG GROUP LogGroupName (UniqueIndexColumn1[, UniqueIndexColumn2] ...) ALWAYS;

--If no primary key exists and there is no unique index, add supplemental logging on all columns.
ALTER TABLE <TableName> ADD SUPPLEMENTAL LOG DATA (ALL) COLUMNS;


--To set up supplemental logging on primary key or unique index columns and other columns that are filtered or transformed, 
--you can set up USER_LOG_GROUP supplemental logging. Add this logging on both the primary key or unique index columns 
--and any other specific columns that are filtered or transformed.
--For example, to replicate a table named TEST.LOGGING with primary key ID and a filter by the column NAME, you can run a command 
--similar to the following to create the log group supplemental logging.
ALTER TABLE TEST.LOGGING ADD SUPPLEMENTAL LOG GROUP TEST_LOG_GROUP (ID, NAME) ALWAYS;

--test
SELECT SQL_REDO FROM V$LOGMNR_CONTENTS WHERE SEG_OWNER='UNILAB' and SEG_NAME='UTEQ'

--
--einde script
--


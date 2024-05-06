--------------------------------------------------------
--  File created - dinsdag-september-08-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for View WF_SPECIFICATION_HEADER
--------------------------------------------------------

CREATE USER AWSDWH
  IDENTIFIED BY "AVawsDWH_2021"
  DEFAULT TABLESPACE USERS
  TEMPORARY TABLESPACE TEMP
  QUOTA UNLIMITED ON USERS
  PROFILE INTERSPEC
  ACCOUNT UNLOCK;

--test-omgeving
ALTER USER AWSDWH IDENTIFIED BY "AVawsDWH_2021" ;

--productie-omgeving
ALTER USER AWSDWH IDENTIFIED BY "AVawsDWH_2021P" ;


-- 2 Roles for AWSDWH
GRANT CONNECT TO AWSDWH;
--GRANT DEV_MGR TO AWSDWH;
--GRANT LIMITED TO AWSDWH;
GRANT CREATE SESSION TO AWSDWH;
GRANT SELECT ANY TABLE TO AWSDWH;
GRANT SELECT ANY DICTIONARY TO AWSDWH;


--GRANT GRANT ANY PRIVILEGE TO INTERSPC;
--GRANT SELECT ANY DICTIONARY TO INTERSPC;
--GRANT UNLIMITED TABLESPACE TO INTERSPC;

--conn system
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
--GRANT SELECT ON V_$CONTAINERS TO AWSDWH;        --table doesn't exist !!! =ORACLE19.PDB             
GRANT SELECT ON ALL_INDEXES TO AWSDWH;
GRANT SELECT ON ALL_OBJECTS TO AWSDWH;
GRANT SELECT ON ALL_TABLES TO AWSDWH;
GRANT SELECT ON ALL_USERS TO AWSDWH;
GRANT SELECT ON ALL_CATALOG TO AWSDWH;
GRANT SELECT ON ALL_CONSTRAINTS TO AWSDWH;
GRANT SELECT ON ALL_CONS_COLUMNS TO AWSDWH;
GRANT SELECT ON ALL_TAB_COLS TO AWSDWH;
GRANT SELECT ON ALL_IND_COLUMNS TO AWSDWH;
GRANT SELECT ON ALL_LOG_GROUPS TO AWSDWH;
GRANT SELECT ON ALL_TAB_PARTITIONS TO AWSDWH;

--CONN SYS
GRANT SELECT ON ALL_ENCRYPTED_COLUMNS TO AWSDWH;    --ORA-01031: insufficient privileges
GRANT SELECT ON SYS.DBA_REGISTRY TO AWSDWH;         --ORA-01031. 00000 -  "insufficient privileges"
GRANT SELECT ON SYS.OBJ$ TO AWSDWH;                 --ORA-01031: insufficient privileges
GRANT SELECT ON DBA_TABLESPACES TO AWSDWH;          --01031. 00000 -  "insufficient privileges"

/*
GRANT SELECT ON DBA_OBJECTS TO AWSDWH;   -– Required if the Oracle version is earlier than 11.2.0.3.
GRANT SELECT ON SYS.ENC$ TO AWSDWH; -– Required if transparent data encryption (TDE) is enabled. For more information on using Oracle TDE with AWS DMS, see Supported encryption methods for using Oracle as a source for AWS DMS.
GRANT SELECT ON GV_$TRANSACTION TO AWSDWH; -– Required if the source database is Oracle RAC in AWS DMS versions 3.4.6 and higher.
GRANT SELECT ON V_$DATAGUARD_STATS TO AWSDWH ; -- Required if the source database is Oracle Data Guard and Oracle Standby is used in the latest release of DMS version 3.4.6, version 3.4.7, and higher.
*/


--Grant the additional following privilege for each replicated table when you are using a specific table list.
--GRANT SELECT on any-replicated-table to db_user;
--let op: DIT DOEN WE PAS ZODRA DE JUISTE TABELLEN IN HULPTABEL SUPPLEMENTAL-LOGGING ZIJN TOEGEVOEGD....

/*
--UITDELEN VAN SPECIFIEKE GRANTS OP TABELLEN...
LOOP   EXECUTE IMMEDIATE 'GRANT SELECT ON ' || x.table_name || ' TO <<someone>>'; END LOOP;  FOR x IN (SELECT * FROM user_tables)
--or
declare
cursor c1 is select table_name from user_tables;
cmd varchar2(200);
begin
for c in c1 loop
cmd := 'GRANT SELECT ON '||c.table_name|| <<TO YOURUSERNAME>>;
execute immediate cmd;
end loop;
end;
*/




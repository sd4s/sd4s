--create materialized-view

--INSERT RECORD DBA_AWS_SUPPLEMENTAL_LOG
/*
ASL_ID
ASL_SCHEMA_OWNER
ASL_TABLE_NAME
ASL_PK_EXISTS_JN
ASL_SUPPL_LOG_TYPE
ASL_IND_ACTIVE_JN
ASL_ACTIVATION_DATE
ASL_OPMERKING
*/

select * from DBA_AWS_SUPPLEMENTAL_LOG where asl_table_name='MV_SPECDATA';


--initial-insert (fields ASL_ACTIVATION_DATE is filled by supplement-proc.
INSERT INTO DBA_AWS_SUPPLEMENTAL_LOG (ASL_ID, ASL_SCHEMA_OWNER, ASL_TABLE_NAME, ASL_PK_EXISTS_JN, ASL_SUPPL_LOG_TYPE, ASL_IND_ACTIVE_JN, ASL_ACTIVATION_DATE, ASL_OPMERKING) 
VALUES (1, 'INTERSPC' ,'MV_SPECDATA', 'J', 'ALL','N' , to_date(null), 'replacement for SPECDATA with a PK' );


--Hoeveel records in tabel:
select count(*) from specdata;
72.968.376

--WELKE INDEXEN OP SPECDATA AANWEZIG:
SELECT * from all_indexes where table_name = 'SPECDATA';
INTERSPC	IDX_UOM					NONUNIQUE	VALID	NORMAL	N	NO		NO	UOM_ID, UOM_REV
INTERSPC	IDX_PROP				NONUNIQUE	VALID	NORMAL	N	NO		NO	PROPERTY, PROPERTY_REV
INTERSPC	IDX_VALUE				NONUNIQUE	VALID	NORMAL	N	NO		NO	VALUE_S
INTERSPC	AI_SPECTRAC				NONUNIQUE	VALID	NORMAL	N	NO		NO	PART_NO, REVISION, SECTION_ID, SUB_SECTION_ID, PROPERTY_GROUP, PROPERTY, HEADER_ID, LANG_ID
INTERSPC	IDX_SPECDATA			NONUNIQUE	VALID	NORMAL	N	NO		NO	PART_NO, REVISION, SECTION_ID, SUB_SECTION_ID, TYPE, REF_ID
INTERSPC	IDX_ATTRIBUTE			NONUNIQUE	VALID	NORMAL	N	NO		NO	ATTRIBUTE, ATTRIBUTE_REV
INTERSPC	XIEV1SPECDATA			NONUNIQUE	VALID	NORMAL	N	NO		NO	PROPERTY, HEADER_ID, VALUE, PART_NO, REVISION
INTERSPC	IDX_SECTION_ID			NONUNIQUE	VALID	NORMAL	N	NO		NO	SECTION_ID, SECTION_REV
INTERSPC	IDX_TEST_METHOD			NONUNIQUE	VALID	NORMAL	N	NO		NO	TEST_METHOD, TEST_METHOD_REV
INTERSPC	IDX_SPECDATA_PG_P		NONUNIQUE	VALID	NORMAL	N	NO		NO	PROPERTY_GROUP, PROPERTY
INTERSPC	IDX_PROPERTY_GROUP		NONUNIQUE	VALID	NORMAL	N	NO		NO	PROPERTY_GROUP, PROPERTY_GROUP_REV
INTERSPC	IDX_SUB_SECTION_ID		NONUNIQUE	VALID	NORMAL	N	NO		NO	SUB_SECTION_ID, SUB_SECTION_REV
INTERSPC	IDX_CHARACTERISTIC_SD	NONUNIQUE	VALID	NORMAL	N	NO		NO	CHARACTERISTIC, CHARACTERISTIC_REV

--index AI_SPECTRAC lijkt wel erg op een PK?  


--waar is nog ruimte in tablespace?
select table_name, NUM_ROWS, LAST_ANALYZED from all_tables where tablespace_name = 'SPECDATA';
AT_SESSIONS					121683		06-10-2020 22:01:16
SPECIFICATION_TO_APPROVE	0			10-08-2018 14:42:24
FRAMEDATA					190813		26-08-2022 22:00:18
SPECDATA_CHECK				0			10-08-2018 14:42:23
SPECDATA_PROCESS			5			22-08-2019 22:00:06
SPECDATA_SERVER				0			14-03-2023 22:00:07
ATVREDESTEIN_TOBEREMOVED	3			10-08-2018 14:41:37
FRAMEDATA_SERVER			0			03-09-2022 06:00:08
SPECDATA					76587076	13-04-2020 22:04:57


--grant
GRANT CREATE MATERIALIZED VIEW TO INTERSPC;


/*
Basic Syntax
The full syntax description for the CREATE MATERIALIZED VIEW command is available in the documentation. 
Here we will only concern ourselves with the basics.

-- Normal
CREATE MATERIALIZED VIEW view-name
BUILD [IMMEDIATE | DEFERRED]
REFRESH [FAST | COMPLETE | FORCE ]
ON [COMMIT | DEMAND ]
[[ENABLE | DISABLE] QUERY REWRITE]
AS
SELECT ...;

-- Pre-Built
CREATE MATERIALIZED VIEW view-name
ON PREBUILT TABLE
REFRESH [FAST | COMPLETE | FORCE ]
ON [COMMIT | DEMAND ]
[[ENABLE | DISABLE] QUERY REWRITE]
AS
SELECT ...;

The BUILD clause options are shown below.
IMMEDIATE : The materialized view is populated immediately.
DEFERRED  : The materialized view is populated on the first requested refresh.

The following refresh types are available.
FAST 	 : A fast refresh is attempted. If materialized view logs are not present against the source tables in advance, the creation fails.
COMPLETE : The table segment supporting the materialized view is truncated and repopulated completely using the associated query.
FORCE    : A fast refresh is attempted. If one is not possible a complete refresh is performed.

A refresh can be triggered in one of two ways.
ON COMMIT : The refresh is triggered by a committed data change in one of the dependent tables.
ON DEMAND : The refresh is initiated by a manual request or a scheduled task.

The QUERY REWRITE clause tells the optimizer if the materialized view should be consider for query rewrite operations. An example of the query rewrite functionality is shown below.
The ON PREBUILT TABLE clause tells the database to use an existing table segment, which must have the same name as the materialized view and support the same column structure as the query.

WITH ROWID Clause
Specify WITH ROWID to create a rowid materialized view. Rowid materialized views are useful if the materialized view 
does not include all primary key columns of the master tables. Rowid materialized views must be based on a single table 
and cannot contain any of the following:
-Distinct or aggregate functions
-GROUP BY or CONNECT BY clauses
-Subqueries
-Joins
-Set operations
The WITH ROWID clause has no effect if there are multiple master tables in the defining query.
*/

--MELDING BIJ AANMAKEN VAN MV:
/*
ORA-00439: feature not enabled: Materialized view rewrite
00439. 00000 -  "feature not enabled: %s"
*Cause:    The specified feature is not enabled.
*Action:   Do not attempt to use this feature. 
--
--DUS DISABLE QUERY REWRITE ipv ENABLE QUERY REWRITE...
*/

/*
ORA-23413: table "INTERSPC"."SPECDATA" does not have a materialized view log
23413. 00000 -  "table \"%s\".\"%s\" does not have a materialized view log"
*Cause:    The fast refresh can not be performed because the master table
           does not contain a materialized view log.
*Action:   Use the CREATE MATERIALIZED VIEW LOG command to create a materialized view log on the master table.
--
--DUS EERST MV-LOG-TABLE AANMAKEN...
*/		   

CREATE MATERIALIZED VIEW LOG 
ON SPECDATA 
PCTFREE 5
TABLESPACE USERS
WITH ROWID
--PRIMARY KEY, ROWID
; 

/*
Error report -
ORA-12014: table 'SPECDATA' does not contain a primary key constraint
12014. 00000 -  "table '%s' does not contain a primary key constraint"
*Cause:    The CREATE MATERIALIZED VIEW LOG command was issued with the
           WITH PRIMARY KEY option and the master table did not contain
           a primary key constraint or the constraint was disabled.
*Action:   Reissue the command using only the WITH ROWID option, create a
           primary key constraint on the master table, or enable an existing
           primary key constraint.
*/		  

ALTER TABLESPACE SPECD
 ADD DATAFILE 'D:\DATABASE\IS61\DATA\IS61_SPECD2.DBF'
 SIZE 100M
 AUTOEXTEND ON NEXT 204800K MAXSIZE 33554416K
 

--
CREATE MATERIALIZED VIEW MV_SPECDATA
TABLESPACE SPECD
PCTFREE 5
PARALLEL 4
BUILD IMMEDIATE
REFRESH FAST
ON COMMIT WITH ROWID
DISABLE QUERY REWRITE 
AS SELECT PART_NO
,REVISION         
,SECTION_ID       
,SUB_SECTION_ID   
,SEQUENCE_NO      
,TYPE             
,REF_ID           
,REF_VER          
,PROPERTY_GROUP   
,PROPERTY         
,ATTRIBUTE        
,HEADER_ID        
,VALUE            
,VALUE_S          
,UOM_ID           
,TEST_METHOD      
,CHARACTERISTIC   
,ASSOCIATION      
,REF_INFO         
,INTL             
,VALUE_TYPE       
,VALUE_DT         
,SECTION_REV      
,SUB_SECTION_REV  
,PROPERTY_GROUP_REV
,PROPERTY_REV      
,ATTRIBUTE_REV     
,UOM_REV           
,TEST_METHOD_REV   
,CHARACTERISTIC_REV
,ASSOCIATION_REV   
,HEADER_REV        
,REF_OWNER         
,LANG_ID           
from specdata
;

--wel zo'n 15 GB aan storage !!!!


--conn interspc@interspec_tst
BEGIN
  DBMS_STATS.gather_table_stats(ownname => 'INTERSPC'
                               ,tabname => 'MV_SPECDATA');
END;
/


--add supplemental log
alter system switch logfile; 
--l_pk_statement        varchar2(1000) := ' ADD SUPPLEMENTAL LOG DATA (PRIMARY KEY) COLUMNS';
--l_all_statement       varchar2(1000) := ' ADD SUPPLEMENTAL LOG DATA (ALL) COLUMNS';
ALTER TABLE MV_SPECDATA ADD SUPPLEMENTAL LOG DATA (PRIMARY KEY) COLUMNS;
ALTER TABLE MV_SPECDATA ADD SUPPLEMENTAL LOG DATA (ALL) COLUMNS;
--
/*
--EVT later droppen van supplemental-log...
alter table MV_SPECDATA drop supplemental log data (all) columns;
alter system switch logfile; 
*/

--************************************************************************
--************************************************************************
-- UITDELEN GRANTS
--************************************************************************
--************************************************************************
drop public synonym MV_SPECDATA;
Create OR replace public synonym MV_SPECDATA for interspc.mv_specdata;
--
grant select on mv_specdata to awsdwh;



--***********************************************************************
--***********************************************************************
--TESTEN om te zien of er ook gewoon een PK op gezet kan worden:
--***********************************************************************
--***********************************************************************

--ALTER MATERIALIZED VIEW MV_SPECDATE DROP CONSTRAINT MV_SPECDATA_PK;
--ALTER MATERIALIZED VIEW MV_SPECDATE DISABLE CONSTRAINT MV_SPECDATA_PK;


/*
ALTER MATERIALIZED VIEW MV_SPECDATA 
ADD CONSTRAINT MV_SPECDATA_PK 
PRIMARY KEY (PART_NO, REVISION, SECTION_ID, SUB_SECTION_ID, PROPERTY_GROUP, PROPERTY, HEADER_ID, LANG_ID)
;
*/
/*
Error report -
ORA-01449: column contains NULL values; cannot alter to NOT NULL
01449. 00000 -  "column contains NULL values; cannot alter to NOT NULL"
*Cause:    
*Action:
*/

SELECT PART_NO, REVISION, SECTION_ID, SUB_SECTION_ID, SEQUENCE_NO, COUNT(*)
FROM SPECDATA SP
GROUP BY PART_NO, REVISION, SECTION_ID, SUB_SECTION_ID, SEQUENCE_NO
HAVING COUNT(*) > 1
;
--NO-ROWS-SELECTED...


ALTER MATERIALIZED VIEW MV_SPECDATA 
ADD CONSTRAINT MV_SPECDATA_PK 
PRIMARY KEY (PART_NO, REVISION, SECTION_ID, SUB_SECTION_ID, SEQUENCE_NO)
USING INDEX TABLESPACE SPECI
;

BEGIN
  DBMS_STATS.gather_table_stats(ownname => 'INTERSPC'
                               ,tabname => 'MV_SPECDATA'
							   ,cascade => TRUE );
END;
/
--of:
BEGIN
  DBMS_STATS.gather_INDEX_stats(ownname => 'INTERSPC'
                               ,indname => 'MV_SPECDATA_PK');
END;
/

/*
DROP INDEX MV_SPECDATA_UK;
PURGE RECYCLEBIN;
--
CREATE UNIQUE INDEX MV_SPECDATA_UK ON MV_SPECDATA (PART_NO, REVISION, SECTION_ID, SUB_SECTION_ID, PROPERTY_GROUP, PROPERTY, HEADER_ID, LANG_ID)
;
--INDEX wordt wel gewoon in tablespace=USERS aangemaakt !!!!!!!
--Grootte zo'n 4 GB !!!

CREATE UNIQUE INDEX MV_SPECDATA_UK ON MV_SPECDATA (PART_NO, REVISION, SECTION_ID, SUB_SECTION_ID, PROPERTY_GROUP, PROPERTY, CHARACTERISTIC, LANG_ID)
;

SELECT PART_NO, REVISION, SECTION_ID, SUB_SECTION_ID, PROPERTY_GROUP, PROPERTY, CHARACTERISTIC, LANG_ID, COUNT(*)
FROM SPECDATA SP
GROUP BY PART_NO, REVISION, SECTION_ID, SUB_SECTION_ID, PROPERTY_GROUP, PROPERTY, CHARACTERISTIC, LANG_ID
HAVING COUNT(*) > 1
;
*/

/*
TEF_205/55R16SN4	3	700835	0	703636	707088	-1	1	5
XM_B08-141	1	700584	0	701297	706348	-1	1	7
EF_H195/45R16A4AX	11	700835	0	701565	710367	-1	1	4
EF_H195/45R16A4AX	11	700835	0	701560	1054	-1	1	5
ES_R56Z	2	700755	0	0	705429	900440	1	2
ES_L63Z	3	700755	0	0	705429	900440	1	2
INT-2354018USAXY	5	701115	0	704036	713631	900484	1	9
EF_H195/45R16A4AX	11	700835	0	184	1023	-1	1	5
EF_H195/45R16A4AX	11	701115	0	704036	713025	-1	1	9
PF_H165/60R14SP5	2	700835	0	221	1404	-1	1	5
EF_H205/55R16QT3	5	700835	0	221	712364	-1	1	5
EF_H205/55R16QT3	5	700835	0	701556	703514	-1	1	4
EF_H205/55R16QT3	5	700584	0	702066	711650	-1	1	8
GF_2555518QPRXW	7	701115	0	704036	714343	-1	1	9
EF_H185/60R16SN5	8	701095	0	700696	712395	900485	1	3
GV_2753518AXPXY	3	701058	700542	701836	705176	900720	1	4
...
*/

/*
select * from specdata
where PART_NO = 'EF_H185/60R16SN5'  
AND REVISION=8
AND SECTION_ID=701095
AND SUB_SECTION_ID=0
AND PROPERTY_GROUP=700696
AND PROPERTY=712395
AND CHARACTERISTIC=900485
AND LANG_ID=1
ORDER BY PART_NO, REVISION, SECTION_ID, SUB_SECTION_ID, SEQUENCE_NO
;

*/


--EINDE SCRIPT.






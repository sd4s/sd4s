/*
TABLE: ATAVPROJECTS
PROJECT			VARCHAR2(10 CHAR)	No		1	
DESCRIPTION		VARCHAR2(40 CHAR)	Yes		2	
*/

There are a few things to consider when using flashback query.
Flashback query is based on UNDO. As a result, the amount of time you can flashback is dependent on how long undo information is retained, as specified by the UNDO_RETENTION parameter.
The flashback operation is performed by winding back the data using the undo information, like a consistent get. The time it takes to wind back the data depends on the number of changes that have happened, so flashback queries of volatile data that go back a long time can be slow.
Flashback Data Archive (FDA) was introduced in Oracle 11g to allow you to protect UNDO information, allowing guaranteed flashback queries.
Each table in a query can reference a different point in time. The AS OF clause can be included in DML and DDL statements.

select  current_scn, to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS') from  v$database; 
/*
CURRENT_SCN TO_CHAR(SYSTIMESTAM
----------- -------------------
 8766034282 2023-07-24 14:08:53
*/

--INDIEN nodig:
alter table  ATAVPROJECTS enable  row movement;

flashback table  ATAVPROJECTS  to  timestamp to_timestamp('17-07-2023 06:00:00','dd-mm-yyyy hh24:mi:ss');
--OPTIE IS NIET BEKEND !!!!

--****************************
--USING AS OF constructie :
--****************************
select  count(*) from ATAVPROJECTS   as of timestamp (systimestamp -interval '15' minute);
SELECT COUNT(*) FROM ATAVPROJECTS  as of SCN 8766034282;
--
select  count(*) from ATAVPROJECTS   as of timestamp to_timestamp('21-07-2023 06:00:00','dd-mm-yyyy hh24:mi:ss');
--0

select  count(*) from ATAVPROJECTS   as of timestamp to_timestamp('20-07-2023 06:00:00','dd-mm-yyyy hh24:mi:ss');
/*
                      *
ERROR at line 1:
ORA-01555: snapshot too old: rollback segment number 10 with name
"_SYSSMU10_4004036201$" too small
*/

select scn_to_timestamp(460141) ddate
,      timestamp_to_scn(to_timestamp('20-07-2023 06:00:00','dd-mm-yyyyhh24:mi:ss')) scn 
from dual;

show parameter retention
--MIN-values in seconds !! 
/*
NAME                                 TYPE        VALUE
------------------------------------ ----------- --------------------
db_flashback_retention_target        integer     1440
undo_retention                       integer     900
*/


--RAADPLEGEN V$SQL
select   sqla.sql_text
from v$sqlarea                sqla
where  sqla.sql_text like '%ATAVPROJECT%'
;
/*
SELECT column_name, nullable, data_type, data_length, data_precision, data_scale, char_length FROM user_tab_columns WHERE table_name = 'ATAVPROJECTS' ORDER BY column_id
"SELECT      PROJECT || ':' || DESCRIPTION FROM   ATAVPROJECTS   WHERE   LOWER(DESCRIPTION) LIKE   LOWER( '%ULRR%' )    ORDER BY PROJECT"
SELECT  DECODE( versions_operation          , 'I', 'Insert'          , 'U', 'Update'          , 'D', 'Delete'               , 'Original'              ) "Operation" ,             versions_xid ,      versions_startscn ,      versions_endscn      ,rowid row_id        ,TIMESTAMP_TO_SCN(systimestamp) now_scn , 'UNILAB' OBJECT_OWNER , 'ATAVPROJECTS' OBJECT_NAME FROM   "UNILAB"."ATAVPROJECTS" /*ignore ORA-30051*/ VERSIONS BETWEEN SCN MINVALUE AND MAXVALUE
select   sqla.sql_text from v$sqlarea                sqla where  sqla.sql_text like '%ATAVPROJECT%'
SELECT /*+all_rows*/ VALUE(KU$), 0 FROM SYS.KU$_OBJGRANT_VIEW KU$ WHERE NOT BITAND(KU$.BASE_OBJ.FLAGS,128)!=0 AND   KU$.BASE_OBJ.NAME='ATAVPROJECTS' AND   KU$.BASE_OBJ.OWNER_NAME='UNILAB'
select * from "UNILAB"."ATAVPROJECTS"       as of scn nvl(:VERSIONS_STARTSCN,TIMESTAMP_TO_SCN(systimestamp)) /*ignore ORA-29913*/      where rowid = :ROW_ID
select /*+ no_parallel(sub1) */  * from ( SELECT ROWID "ROWID", ORA_ROWSCN "ORA_ROWSCN", PROJECT PROJECT, DESCRIPTION DESCRIPTION FROM "UNILAB"."ATAVPROJECTS"  ) sub1 order by 3 asc
select  count(*) from ATAVPROJECTS   as of timestamp to_timestamp('20-07-2023 06:00:00','dd-mm-yyyy hh24:mi:ss')
"SELECT      PROJECT || ':' || DESCRIPTION FROM   ATAVPROJECTS   WHERE   LOWER(DESCRIPTION) LIKE   LOWER( '%%' )    ORDER BY PROJECT"
select   ash.user_id ,        u.username ,        sqla.sql_text from v$active_session_history ash ,    v$sqlarea                sqla ,    dba_users                u where  ash.sample_time > sysdate-1 and    ash.sql_id = sqla.sql_id and    ash.user_id = u.user_id --and    u.username in ('ATTIC','ADM') and    sqla.sql_text like '%ATAVPROJECT%'
SELECT b.column_name FROM user_cons_columns b, user_constraints a WHERE a.table_name = b.table_name AND a.constraint_name = b.constraint_name AND a.owner = b.owner AND a.constraint_type = 'P' AND a.table_name = 'ATAVPROJECTS' AND a.owner = 'UNILAB' ORDER BY b.position
select /*+ no_parallel(sub1) */  * from ( select  * from ( SELECT ROWID "ROWID", ORA_ROWSCN "ORA_ROWSCN", CLIENT_ID CLIENT_ID, APPLIC APPLIC, WHO WHO, LOGDATE LOGDATE, LOGDATE_TZ LOGDATE_TZ, API_NAME API_NAME, ERROR_MSG ERROR_MSG, ERR_SEQ ERR_SEQ FROM "UNILAB"."UTERROR"  )  WHERE error_msg like '%ATAVPROJECT%'  ) sub1 order by 10 desc
"SELECT      PROJECT || ':' || DESCRIPTION FROM   ATAVPROJECTS   WHERE   LOWER(DESCRIPTION) LIKE   LOWER( '%Hungary%' )    ORDER BY PROJECT"
SELECT /*+ no_parallel("ATAVPROJECTS") */  ROWID "ROWID", ORA_ROWSCN "ORA_ROWSCN", PROJECT PROJECT, DESCRIPTION DESCRIPTION FROM "UNILAB"."ATAVPROJECTS"
select   NULLIF((select count(1) from all_external_tables where owner = 'UNILAB' and table_name = 'ATAVPROJECTS'),0)from dual
*/

--conclusie: geen DELETE / TRUNCATE statements meer in v$sqlarea of v$sql !!!. Het verwijderen is dus al een hele poos geleden...


--end script


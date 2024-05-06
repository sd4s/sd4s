--Unilab table UTBLOB is failing after inserting 82100 rows
--
--Oracle error code is '1555' ORA-01555: snapshot too old: rollback segment number 10 with name "_SYSSMU10_4004036201$" too small
--
--[09:10] Shailender Gupta
--no, that will not work with BLOB
--example - in a usual job, it starts immediately and row transfer rate is 10000 almost per sec
--in this case job takes around 1 hour to collect data and do the first insert

--UTBLOB
/*
ID			VARCHAR2(20 CHAR)	No		1	
DESCRIPTION	VARCHAR2(40 CHAR)	Yes		2	
OBJECT_LINK	VARCHAR2(255 CHAR)	Yes		3	
KEY1		VARCHAR2(20 CHAR)	Yes		4	
KEY2		VARCHAR2(20 CHAR)	Yes		5	
KEY3		VARCHAR2(20 CHAR)	Yes		6	
KEY4		VARCHAR2(20 CHAR)	Yes		7	
KEY5		VARCHAR2(20 CHAR)	Yes		8	
URL			VARCHAR2(255 CHAR)	Yes		9	
DATA		BLOB				Yes		10	

  CREATE TABLE "UNILAB"."UTBLOB" 
   (	"ID" VARCHAR2(20 CHAR), 
	"DESCRIPTION" VARCHAR2(40 CHAR), 
	"OBJECT_LINK" VARCHAR2(255 CHAR), 
	"KEY1" VARCHAR2(20 CHAR), 
	"KEY2" VARCHAR2(20 CHAR), 
	"KEY3" VARCHAR2(20 CHAR), 
	"KEY4" VARCHAR2(20 CHAR), 
	"KEY5" VARCHAR2(20 CHAR), 
	"URL" VARCHAR2(255 CHAR), 
	"DATA" BLOB, 
	 CONSTRAINT "UKBLOB" PRIMARY KEY ("ID")
  USING INDEX PCTFREE 0 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "UNI_INDEXO"  ENABLE, 
	 SUPPLEMENTAL LOG DATA (ALL) COLUMNS
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 0 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "UNI_LOB" 
 LOB ("DATA") STORE AS BASICFILE (
  TABLESPACE "UNI_LOB" ENABLE STORAGE IN ROW CHUNK 8192 PCTVERSION 10
  NOCACHE LOGGING 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)) ;

CONCLUSIE: Table + LOB zitten in tablespace UNI_LOB  !!!!!!!!
           Index zit in tablespace UNI_INDEX0 !!!!
		   
UNI_LOB-datafiles:
ID	FILE
14	D:\DATABASE\U611\DATA\U611_DATLOB_01.DBF 
18	D:\DATABASE\U611\DATA\U611_DATLOB_02.DBF
26	D:\DATABASE\U611\DATA\U611_DATLOB_03.DBF
35	D:\DATABASE\U611\DATA\U611_DATLOB_04.DBF
		   
*/
--
select count(*) from utblob;
--134921




--FULL-LOAD RESTARTED...
--USER: AWSDWH
Program	Logon_Time	Machine	OSUser	Server	SID	SerialNum	Status	Terminal	Type	SPID	SQL_ID
AWSDWH	05/12/2023 09:17:26	ip-172-23-2-67	rdsdb	DEDICATED	95	6347	INACTIVE		USER	2172	
00007FF8D43019B8	93	2172	SYSTEM	37	ORACLEPROD	ORACLE.EXE (SHAD)		C:\ORACLE\diag\rdbms\u611\u611\trace\u611_ora_2172.trc				2106480	3304976	983040	19230224

AWSDWH	05/12/2023 09:17:30	ip-172-23-2-67	rdsdb	DEDICATED	100	34145	INACTIVE		USER	9328	
00007FF8E6245FA0	94	9328	SYSTEM	51	ORACLEPROD	ORACLE.EXE (SHAD)		C:\ORACLE\diag\rdbms\u611\u611\trace\u611_ora_9328.trc				1589120	2584080	786432	10907152

AWSDWH	05/12/2023 09:17:38	ip-172-23-2-67	rdsdb	DEDICATED	117	61075	INACTIVE		USER	14276	
00007FF8D022FDB0	96	14276	SYSTEM	121	ORACLEPROD	ORACLE.EXE (SHAD)		C:\ORACLE\diag\rdbms\u611\u611\trace\u611_ora_14276.trc				1210592	1863184	458752	1863184

AWSDWH	05/12/2023 09:18:20	ip-172-23-2-67	rdsdb	DEDICATED	254	3307	INACTIVE		USER	7648	6g2yp9mvv00xp
00007FF8CE22B028	76	7648	SYSTEM	25	ORACLEPROD	ORACLE.EXE (SHAD)		C:\ORACLE\diag\rdbms\u611\u611\trace\u611_ora_7648.trc				1386392	2584080	1048576	54291984


dd 2023-12-05 09:22
SYSAUX		95	2360	109		2251	5	32768	7	ONLINE	PERMANENT
SYSTEM		100	23350	40		23310	0	32768	71	ONLINE	PERMANENT
UNI_BO		1	100		99		1		99	32768	0	ONLINE	PERMANENT
UNI_DATAC	95	7725	371		7355	5	32768	22	ONLINE	PERMANENT
UNI_DATAO	91	491518	42462	449056	9	491520	91	ONLINE	PERMANENT
UNI_INDEXC	96	23900	1060	22840	4	32768	70	ONLINE	PERMANENT
UNI_INDEXO	90	327680	32891	294789	10	327680	90	ONLINE	PERMANENT
UNI_LOB		95	99260	5259	94001	5	131072	72	ONLINE	PERMANENT
UNI_TEMP	0	30720	30599	121		100	30720	0	ONLINE	TEMPORARY
UNI_UNDO	4	10440	9993	447		96	32768	1	ONLINE	UNDO

dd 2023-12-05 10:07
SYSAUX		95	2360	109		2251	5	32768	7	ONLINE	PERMANENT
SYSTEM		100	23350	40		23310	0	32768	71	ONLINE	PERMANENT
UNI_BO		1	100		99		1		99	32768	0	ONLINE	PERMANENT
UNI_DATAC	95	7725	371		7355	5	32768	22	ONLINE	PERMANENT
UNI_DATAO	91	491518	42398	449120	9	491520	91	ONLINE	PERMANENT
UNI_INDEXC	96	23900	1060	22840	4	32768	70	ONLINE	PERMANENT
UNI_INDEXO	90	327680	32883	294797	10	327680	90	ONLINE	PERMANENT
UNI_LOB		95	99260	5259	94001	5	131072	72	ONLINE	PERMANENT
UNI_TEMP	0	30720	30615	105		100	30720	0	ONLINE	TEMPORARY
UNI_UNDO	4	10440	9983	457		96	32768	1	ONLINE	UNDO

dd 2023-12-05 11:02
SYSAUX		95	2360	109		2251	5	32768	7	ONLINE	PERMANENT
SYSTEM		100	23350	40		23310	0	32768	71	ONLINE	PERMANENT
UNI_BO		1	100		99		1		99	32768	0	ONLINE	PERMANENT
UNI_DATAC	95	7725	371		7355	5	32768	22	ONLINE	PERMANENT
UNI_DATAO	91	491518	42398	449120	9	491520	91	ONLINE	PERMANENT
UNI_INDEXC	96	23900	1060	22840	4	32768	70	ONLINE	PERMANENT
UNI_INDEXO	90	327680	32883	294797	10	327680	90	ONLINE	PERMANENT
UNI_LOB		95	99260	5259	94001	5	131072	72	ONLINE	PERMANENT
UNI_TEMP	0	30720	30591	129		100	30720	0	ONLINE	TEMPORARY
UNI_UNDO	5	10440	9968	472		95	32768	1	ONLINE	UNDO


/* Formatted on 05/12/2023 09:28:29 (QP5 v5.396) 
SELECT NVL (owner, ' ')
           OWNER,
       NVL (table_name, ' ')
           NAME,
       NVL (NUM_ROWS, 0),
       NVL (PARTITIONED, ' '),
       NVL (IOT_TYPE, ' '),
       NVL (compression, ' '),
       NVL (compress_for, ' '),
       NVL (
           (SELECT NVL (object_id, 0)
              FROM all_objects
             WHERE     all_tables.table_name = object_name
                   AND all_tables.owner = owner
                   AND object_type = 'TABLE'),
           0),
       NVL (
           (SELECT NVL (data_object_id, 0)
              FROM all_objects
             WHERE     all_tables.table_name = object_name
                   AND all_tables.owner = owner
                   AND object_type = 'TABLE'),
           0),
       NVL (
           (SELECT NVL (encrypted, ' ')
              FROM dba_tablespaces
             WHERE dba_tablespaces.tablespace_name =
                   all_tables.tablespace_name),
           ' '),
       NVL (cluster_name, ' '),
       NVL (nested, ' '),
       'T'
  FROM all_tables
 WHERE     (   (    ((owner LIKE 'UNILAB' AND table_name LIKE 'UTBLOB'))
                AND NOT (   (    owner LIKE '%'
                             AND table_name LIKE 'awsdms_changes%')
                         OR (    owner LIKE '%'
                             AND table_name LIKE 'awsdms_apply%')
                         OR (    owner LIKE '%'
                             AND table_name LIKE 'awsdms_truncation%')
                         OR (    owner LIKE '%'
                             AND table_name LIKE 'awsdms_audit_table')
                         OR (    owner LIKE '%'
                             AND table_name LIKE 'awsdms_status')
                         OR (    owner LIKE '%'
                             AND table_name LIKE 'awsdms_suspended_tables')
                         OR (    owner LIKE '%'
                             AND table_name LIKE 'awsdms_history')
                         OR (    owner LIKE '%'
                             AND table_name LIKE 'awsdms_validation_failure')
                         OR (    owner LIKE '%'
                             AND table_name LIKE
                                     'awsdms_cdc_%awsdms_full_load_exceptions%')))
            OR (1 <> 1))
       AND 1 = 1
       AND owner NOT IN ('SYS',
                         'MDSYS',
                         'OLAPSYS',
                         'WKSYS',
                         'CTXSYS',
                         'XDB',
                         'WMSYS',
                         'EXFSYS',
                         'ORDSYS',
                         'DMSYS',
                         'WK_TEST')
       AND table_name NOT LIKE 'BIN$%'
       AND table_name NOT LIKE 'DR$%'
       AND duration IS NULL
UNION
SELECT NVL (owner, ' ')
           OWNER,
       NVL (view_name, ' ')
           NAME,
       0,
       ' ',
       ' ',
       ' ',
       ' ',
       NVL (
           (SELECT NVL (object_id, 0)
              FROM all_objects
             WHERE     all_views.view_name = object_name
                   AND all_views.owner = owner
                   AND object_type = 'VIEW'),
           0),
       0,
       ' ',
       ' ',
       ' ',
       'V'
  FROM all_views
 WHERE     (   (    (1 <> 1)
                AND NOT (   (    owner LIKE '%'
                             AND view_name LIKE 'awsdms_changes%')
                         OR (    owner LIKE '%'
                             AND view_name LIKE 'awsdms_apply%')
                         OR (    owner LIKE '%'
                             AND view_name LIKE 'awsdms_truncation%')
                         OR (    owner LIKE '%'
                             AND view_name LIKE 'awsdms_audit_table')
                         OR (    owner LIKE '%'
                             AND view_name LIKE 'awsdms_status')
                         OR (    owner LIKE '%'
                             AND view_name LIKE 'awsdms_suspended_tables')
                         OR (    owner LIKE '%'
                             AND view_name LIKE 'awsdms_history')
                         OR (    owner LIKE '%'
                             AND view_name LIKE 'awsdms_validation_failure')
                         OR (    owner LIKE '%'
                             AND view_name LIKE
                                     'awsdms_cdc_%awsdms_full_load_exceptions%')))
            OR (1 <> 1))
       AND 1 = 1
       AND owner NOT IN ('SYS',
                         'MDSYS',
                         'OLAPSYS',
                         'WKSYS',
                         'CTXSYS',
                         'XDB',
                         'WMSYS',
                         'EXFSYS',
                         'ORDSYS',
                         'DMSYS',
                         'WK_TEST')
       AND view_name NOT LIKE 'BIN$%'
       AND view_name NOT LIKE 'DR$%'
ORDER BY OWNER, NAME
*/

/*
SELECT operation,
       NVL (sql_undo, ' '),
       xidusn,
       xidslt,
       xidsqn,
       NVL (seg_name, ' '),
       SCN,
       RBASQN,
       RBABLK,
       RBABYTE,
       NVL (seg_owner, ' '),
       NVL (sql_redo, ' '),
       CSF,
       rollback,
       NVL (row_id, ' '),
       timestamp,
       NVL (username, ' ')
  FROM v$logmnr_contents
 WHERE     SCN >= :startScn
       AND 
	   (   (    operation IN ('INSERT',
                                  'DELETE',
                                  'UPDATE',
                                  'DIRECT INSERT')
                AND (seg_name IN ('OBJ# 18',
                                  'OBJ# 262150',
                                  'OBJ# 262152',
                                  'OBJ# 262162',
                                  'OBJ# 262168',
                                  'OBJ# 262169',
                                  'OBJ# 262174',
                                  'OBJ# 262207',
                                  'OBJ# 262208',
                                  'OBJ# 262214',
                                  'OBJ# 262215',
                                  'OBJ# 262218',
                                  'OBJ# 262225',
                                  'OBJ# 262240',
                                  'OBJ# 262250',
                                  'OBJ# 262255',
                                  'OBJ# 262260',
                                  'OBJ# 262270',
                                  'OBJ# 262276',
                                  'OBJ# 262278',
                                  'OBJ# 262279',
                                  'OBJ# 262282',
                                  'OBJ# 262285',
                                  'OBJ# 262289',
                                  'OBJ# 262295',
                                  'OBJ# 262297',
                                  'OBJ# 262298',
                                  'OBJ# 262307',
                                  'OBJ# 262309',
                                  'OBJ# 262310',
                                  'OBJ# 262311',
                                  'OBJ# 262312',
                                  'OBJ# 262314',
                                  'OBJ# 262322',
                                  'OBJ# 262323',
                                  'OBJ# 262326',
                                  'OBJ# 262327',
                                  'OBJ# 262331',
                                  'OBJ# 262332',
                                  'OBJ# 262339',
                                  'OBJ# 262340',
                                  'OBJ# 262357',
                                  'OBJ# 262358',
                                  'OBJ# 262359',
                                  'OBJ# 262360',
                                  'OBJ# 262361',
                                  'OBJ# 262363',
                                  'OBJ# 262364',
                                  'OBJ# 262365',
                                  'OBJ# 262366',
                                  'OBJ# 262367',
                                  'OBJ# 262368',
                                  'OBJ# 262369',
                                  'OBJ# 262370',
                                  'OBJ# 262376',
                                  'OBJ# 262380',
                                  'OBJ# 262384',
                                  'OBJ# 262385',
                                  'OBJ# 262387',
                                  'OBJ# 262390',
                                  'OBJ# 262392',
                                  'OBJ# 262396',
                                  'OBJ# 262398',
                                  'OBJ# 262399',
                                  'OBJ# 262402',
                                  'OBJ# 262405',
                                  'OBJ# 262409',
                                  'OBJ# 262422',
                                  'OBJ# 262423',
                                  'OBJ# 262424',
                                  'OBJ# 262426',
                                  'OBJ# 262431',
                                  'OBJ# 262435',
                                  'OBJ# 262436',
                                  'OBJ# 262439',
                                  'OBJ# 262441',
                                  'OBJ# 262442',
                                  'OBJ# 262444',
                                  'OBJ# 262445',
                                  'OBJ# 262446',
                                  'OBJ# 262448',
                                  'OBJ# 262456',
                                  'OBJ# 262457',
                                  'OBJ# 262458',
                                  'OBJ# 262460',
                                  'OBJ# 262464',
                                  'OBJ# 262465',
                                  'OBJ# 262466',
                                  'OBJ# 262467',
                                  'OBJ# 262469',
                                  'OBJ# 262472',
                                  'OBJ# 262473',
                                  'OBJ# 262474',
                                  'OBJ# 262476',
                                  'OBJ# 262477',
                                  'OBJ# 262478',
                                  'OBJ# 262479',
                                  'OBJ# 262480',
                                  'OBJ# 262483',
                                  'OBJ# 262484',
                                  'OBJ# 262485',
                                  'OBJ# 262486',
                                  'OBJ# 262488',
                                  'OBJ# 262490',
                                  'OBJ# 262491',
                                  'OBJ# 262492',
                                  'OBJ# 262493',
                                  'OBJ# 262496',
                                  'OBJ# 262501',
                                  'OBJ# 262502',
                                  'OBJ# 262522',
                                  'OBJ# 262524',
                                  'OBJ# 262525',
                                  'OBJ# 262530',
                                  'OBJ# 262534',
                                  'OBJ# 262543',
                                  'OBJ# 262550',
                                  'OBJ# 262561',
                                  'OBJ# 262586',
                                  'OBJ# 262587',
                                  'OBJ# 262591',
                                  'OBJ# 262594',
                                  'OBJ# 262599',
                                  'OBJ# 262605',
                                  'OBJ# 262606',
                                  'OBJ# 262607',
                                  'OBJ# 262613',
                                  'OBJ# 262614',
                                  'OBJ# 262631',
                                  'OBJ# 262666',
                                  'OBJ# 262668',
                                  'OBJ# 262669',
                                  'OBJ# 262670',
                                  'OBJ# 262671',
                                  'OBJ# 262672',
                                  'OBJ# 262673',
                                  'OBJ# 262674',
                                  'OBJ# 262675',
                                  'OBJ# 262676',
                                  'OBJ# 262677',
                                  'OBJ# 262678',
                                  'OBJ# 262679',
                                  'OBJ# 262680',
                                  'OBJ# 262681',
                                  'OBJ# 262682',
                                  'OBJ# 262683',
                                  'OBJ# 262684',
                                  'OBJ# 262685',
                                  'OBJ# 262687',
                                  'OBJ# 262688',
                                  'OBJ# 262689',
                                  'OBJ# 262690',
                                  'OBJ# 262691',
                                  'OBJ# 269387',
                                  'OBJ# 275002',
                                  'OBJ# 275260',
                                  'OBJ# 362603',
                                  'OBJ# 364695',
                                  'OBJ# 365499',
                                  'OBJ# 439142',
                                  'OBJ# 441463',
                                  'OBJ# 767179')))
            OR operation IN ('START',
                             'COMMIT',
                             'ROLLBACK',
                             'DDL',
                             'DPI SAVEPOINT',
                             'DPI ROLLBACK SAVEPOINT'))
*/

/*
/* Formatted on 05/12/2023 11:15:55 (QP5 v5.396) 
SELECT name,
       first_change#,
       sequence#,
       status
  FROM v$archived_log
 WHERE     first_time IS NOT NULL
       AND name IS NOT NULL
       AND resetlogs_change# = (SELECT resetlogs_change# FROM v$database)
       AND resetlogs_time = (SELECT resetlogs_time FROM v$database)
       AND thread# = :thread
       AND next_change# >= :startScn
       AND dest_id IN (1)
UNION
SELECT lf.MEMBER,
       first_change#,
       sequence#,
       'A'
  FROM v$logfile lf, V$LOG l
 WHERE     l.group# = lf.group#
       AND l.first_time IS NOT NULL
       AND l.status = 'CURRENT'
       AND thread# = :thread
ORDER BY first_change# DESC
*/

--when loading:
/* Formatted on 05/12/2023 11:04:41 (QP5 v5.396) */
SELECT "ID",
       "DESCRIPTION",
       "OBJECT_LINK",
       "KEY1",
       "KEY2",
       "KEY3",
       "KEY4",
       "KEY5",
       "URL",
       CASE WHEN "DATA" IS NULL THEN NULL ELSE 1 END
  FROM "UNILAB"."UTBLOB"
  
--proces: 00007FF8E6248170	108	8080	SYSTEM	59	ORACLEPROD	ORACLE.EXE (SHAD)		C:\ORACLE\diag\rdbms\u611\u611\trace\u611_ora_8080.trc				1422928	2584080	196608	19361296
  
  
/*
--dd 11-12-2023: Tweede proces is ook weer afgebroken
[Thursday 10:50] Shailender Gupta
No, it stopped around 62000 this time
[Thursday 10:50] Shailender Gupta
have restarted the job
[Thursday 11:39] Peter Schepens
same error?
[Friday 08:30] Shailender Gupta
yes, Interspec BLOB worked fine and is running fine since I started the job a week back
DB-settings retention-period are as follows:
db_flashback_retention_target integer 1440  
undo_retention                integer 900
But i don't think that is the issue. The undo-tablespace is not used much (max only 1%) because of the fact you are only reading from Interspec. I will try to find meaningfull messages/causes from the oracle alert/log-files.

We are maintaing all archivel-logs from the last 14 days before deleting, that should be enough. 
But you are doing a full-load, so only reading from the database itself.
Since when do you need the archive-logs for a full-load? If you want to retrieve all data of this table from the archive-logs you need all archive logs of the last 15 years. That is impossible.

[10:15] Shailender Gupta
but is it possible that the row is updated by the time we are reading the full load data
[10:19] Shailender Gupta
2023-12-09T07:16:45:851275 [SOURCE_CAPTURE  ]I:  Set corrupted redo log data block error as fatal error    (oracle_endpoint_imp.c:1086)
[10:19] Shailender Gupta
2023-12-09T07:16:49:332273 [SOURCE_CAPTURE  ]W:  Oracle error code is '6550' ORA-06550: line 1, column 7: PL/SQL: Statement ignored   (oracle_endpoint_utils.c:3245)
*/

/*
DESCR V$ARCHIVED_LOGS

Name                  Null? Type          
--------------------- ----- ------------- 
RECID                       NUMBER        
STAMP                       NUMBER        
NAME                        VARCHAR2(513) 
DEST_ID                     NUMBER        
THREAD#                     NUMBER        
SEQUENCE#                   NUMBER        
RESETLOGS_CHANGE#           NUMBER        
RESETLOGS_TIME              DATE          
RESETLOGS_ID                NUMBER        
FIRST_CHANGE#               NUMBER        
FIRST_TIME                  DATE          
NEXT_CHANGE#                NUMBER        
NEXT_TIME                   DATE          
BLOCKS                      NUMBER        
BLOCK_SIZE                  NUMBER        
CREATOR                     VARCHAR2(7)   
REGISTRAR                   VARCHAR2(7)   
STANDBY_DEST                VARCHAR2(3)   
ARCHIVED                    VARCHAR2(3)   
APPLIED                     VARCHAR2(9)   
DELETED                     VARCHAR2(3)   
STATUS                      VARCHAR2(1)   
COMPLETION_TIME             DATE          
DICTIONARY_BEGIN            VARCHAR2(3)   
DICTIONARY_END              VARCHAR2(3)   
END_OF_REDO                 VARCHAR2(3)   
BACKUP_COUNT                NUMBER        
ARCHIVAL_THREAD#            NUMBER        
ACTIVATION#                 NUMBER        
IS_RECOVERY_DEST_FILE       VARCHAR2(3)   
COMPRESSED                  VARCHAR2(3)   
FAL                         VARCHAR2(3)   
END_OF_REDO_TYPE            VARCHAR2(10)  
BACKED_BY_VSS               VARCHAR2(3)  
*/

select name, dest_id, thread#, sequence#, archived, applied, deleted, 
status, first_time, next_time, completion_time  from v$archived_log 
order by sequence#

/*
name	dest_id	thread# sequence# archived	applied deleted status	first_time
		1		1		643748		YES		NO		YES		D		24-11-2023 19:22:04	24-11-2023 19:22:22	01-12-2023 19:55:44
		1		1		643749		YES		NO		YES		D		24-11-2023 19:22:22	24-11-2023 19:36:20	24-11-2023 19:36:20
		1		1		643749		YES		NO		YES		D		24-11-2023 19:22:22	24-11-2023 19:36:20	24-11-2023 19:52:02
		1		1		643749		YES		NO		YES		D		24-11-2023 19:22:22	24-11-2023 19:36:20	01-12-2023 19:55:44
		1		1		643750		YES		NO		YES		D		24-11-2023 19:36:20	24-11-2023 19:50:17	24-11-2023 19:50:17
		1		1		643750		YES		NO		YES		D		24-11-2023 19:36:20	24-11-2023 19:50:17	01-12-2023 19:55:44
		1		1		643751		YES		NO		YES		D		24-11-2023 19:50:17	24-11-2023 20:10:12	24-11-2023 20:10:12
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_11_24\O1_MF_1_643751_LP1X8N6Y_.ARC	1	1	643751	YES	NO	NO	A	24-11-2023 19:50:17	24-11-2023 20:10:12	08-12-2023 20:02:52
	1	1	643751	YES	NO	YES	D	24-11-2023 19:50:17	24-11-2023 20:10:12	01-12-2023 19:55:44
	1	1	643752	YES	NO	YES	D	24-11-2023 20:10:12	24-11-2023 20:23:54	24-11-2023 20:23:54
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_11_24\O1_MF_1_643752_LP1Y2BJY_.ARC	1	1	643752	YES	NO	NO	A	24-11-2023 20:10:12	24-11-2023 20:23:54	08-12-2023 20:02:52
	1	1	643752	YES	NO	YES	D	24-11-2023 20:10:12	24-11-2023 20:23:54	01-12-2023 19:55:44
	1	1	643753	YES	NO	YES	D	24-11-2023 20:23:54	24-11-2023 20:45:37	24-11-2023 20:45:37
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_11_24\O1_MF_1_643753_LP1ZC146_.ARC	1	1	643753	YES	NO	NO	A	24-11-2023 20:23:54	24-11-2023 20:45:37	08-12-2023 20:02:52
	1	1	643753	YES	NO	YES	D	24-11-2023 20:23:54	24-11-2023 20:45:37	01-12-2023 19:55:44
	1	1	643754	YES	NO	YES	D	24-11-2023 20:45:37	24-11-2023 21:01:52	24-11-2023 21:01:53
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_11_24\O1_MF_1_643754_LP209KFG_.ARC	1	1	643754	YES	NO	NO	A	24-11-2023 20:45:37	24-11-2023 21:01:52	08-12-2023 20:02:52
	1	1	643754	YES	NO	YES	D	24-11-2023 20:45:37	24-11-2023 21:01:52	01-12-2023 19:55:44
	1	1	643755	YES	NO	YES	D	24-11-2023 21:01:52	24-11-2023 21:23:08	24-11-2023 21:23:08
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_11_24\O1_MF_1_643755_LP21KDJ4_.ARC	1	1	643755	YES	NO	NO	A	24-11-2023 21:01:52	24-11-2023 21:23:08	08-12-2023 20:02:52
	1	1	643755	YES	NO	YES	D	24-11-2023 21:01:52	24-11-2023 21:23:08	01-12-2023 19:55:44
	1	1	643756	YES	NO	YES	D	24-11-2023 21:23:08	24-11-2023 21:34:06	24-11-2023 21:34:07
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_11_24\O1_MF_1_643756_LP225Z4G_.ARC	1	1	643756	YES	NO	NO	A	24-11-2023 21:23:08	24-11-2023 21:34:06	08-12-2023 20:02:52
	1	1	643756	YES	NO	YES	D	24-11-2023 21:23:08	24-11-2023 21:34:06	01-12-2023 19:55:44
	1	1	643757	YES	NO	YES	D	24-11-2023 21:34:06	24-11-2023 21:48:46	24-11-2023 21:48:46
	1	1	643757	YES	NO	YES	D	24-11-2023 21:34:06	24-11-2023 21:48:46	01-12-2023 19:55:44
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_11_24\O1_MF_1_643757_LP231GLM_.ARC	1	1	643757	YES	NO	NO	A	24-11-2023 21:34:06	24-11-2023 21:48:46	08-12-2023 20:02:52
	1	1	643758	YES	NO	YES	D	24-11-2023 21:48:46	24-11-2023 22:00:13	24-11-2023 22:00:14
	1	1	643758	YES	NO	YES	D	24-11-2023 21:48:46	24-11-2023 22:00:13	01-12-2023 19:55:44
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_11_24\O1_MF_1_643758_LP23PXTL_.ARC	1	1	643758	YES	NO	NO	A	24-11-2023 21:48:46	24-11-2023 22:00:13	08-12-2023 20:02:52
	1	1	643759	YES	NO	YES	D	24-11-2023 22:00:13	24-11-2023 22:00:28	24-11-2023 22:00:28
	1	1	643759	YES	NO	YES	D	24-11-2023 22:00:13	24-11-2023 22:00:28	01-12-2023 19:55:44
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_11_24\O1_MF_1_643759_LP23QDV3_.ARC	1	1	643759	YES	NO	NO	A	24-11-2023 22:00:13	24-11-2023 22:00:28	08-12-2023 20:02:52
	1	1	643760	YES	NO	YES	D	24-11-2023 22:00:28	24-11-2023 22:07:11	24-11-2023 22:07:11
	1	1	643760	YES	NO	YES	D	24-11-2023 22:00:28	24-11-2023 22:07:11	01-12-2023 19:55:44
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_11_24\O1_MF_1_643760_LP243Z3J_.ARC	1	1	643760	YES	NO	NO	A	24-11-2023 22:00:28	24-11-2023 22:07:11	08-12-2023 20:02:52
	1	1	643761	YES	NO	YES	D	24-11-2023 22:07:11	24-11-2023 22:26:11	24-11-2023 22:26:11
	1	1	643761	YES	NO	YES	D	24-11-2023 22:07:11	24-11-2023 22:26:11	01-12-2023 19:55:44
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_11_24\O1_MF_1_643761_LP257MMV_.ARC	1	1	643761	YES	NO	NO	A	24-11-2023 22:07:11	24-11-2023 22:26:11	08-12-2023 20:02:52
	1	1	643762	YES	NO	YES	D	24-11-2023 22:26:11	24-11-2023 22:49:12	24-11-2023 22:49:12
	1	1	643762	YES	NO	YES	D	24-11-2023 22:26:11	24-11-2023 22:49:12	01-12-2023 19:55:44
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_11_24\O1_MF_1_643762_LP26LR40_.ARC	1	1	643762	YES	NO	NO	A	24-11-2023 22:26:11	24-11-2023 22:49:12	08-12-2023 20:02:52
	1	1	643763	YES	NO	YES	D	24-11-2023 22:49:12	24-11-2023 23:28:40	24-11-2023 23:28:40
	1	1	643763	YES	NO	YES	D	24-11-2023 22:49:12	24-11-2023 23:28:40	01-12-2023 19:55:44
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_11_24\O1_MF_1_643763_LP28WR2Y_.ARC	1	1	643763	YES	NO	NO	A	24-11-2023 22:49:12	24-11-2023 23:28:40	08-12-2023 20:02:52
	1	1	643764	YES	NO	YES	D	24-11-2023 23:28:40	25-11-2023 00:01:16	25-11-2023 00:01:17
	1	1	643764	YES	NO	YES	D	24-11-2023 23:28:40	25-11-2023 00:01:16	01-12-2023 19:55:44
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_11_25\O1_MF_1_643764_LP2BSX14_.ARC	1	1	643764	YES	NO	NO	A	24-11-2023 23:28:40	25-11-2023 00:01:16	08-12-2023 20:02:53
	1	1	643765	YES	NO	YES	D	25-11-2023 00:01:16	25-11-2023 00:01:20	25-11-2023 00:01:20
	1	1	643765	YES	NO	YES	D	25-11-2023 00:01:16	25-11-2023 00:01:20	01-12-2023 19:55:44
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_11_25\O1_MF_1_643765_LP2BT033_.ARC	1	1	643765	YES	NO	NO	A	25-11-2023 00:01:16	25-11-2023 00:01:20	08-12-2023 20:02:53
	1	1	643766	YES	NO	YES	D	25-11-2023 00:01:20	25-11-2023 00:01:29	25-11-2023 00:01:29
	1	1	643766	YES	NO	YES	D	25-11-2023 00:01:20	25-11-2023 00:01:29	01-12-2023 19:55:44
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_11_25\O1_MF_1_643766_LP2BT95M_.ARC	1	1	643766	YES	NO	NO	A	25-11-2023 00:01:20	25-11-2023 00:01:29	08-12-2023 20:02:53
	1	1	643767	YES	NO	YES	D	25-11-2023 00:01:29	25-11-2023 00:15:26	25-11-2023 00:15:26
	1	1	643767	YES	NO	YES	D	25-11-2023 00:01:29	25-11-2023 00:15:26	01-12-2023 19:55:44
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_11_25\O1_MF_1_643767_LP2CNGK4_.ARC	1	1	643767	YES	NO	NO	A	25-11-2023 00:01:29	25-11-2023 00:15:26	08-12-2023 20:02:53
	1	1	643768	YES	NO	YES	D	25-11-2023 00:15:26	25-11-2023 01:02:15	25-11-2023 01:02:15
	1	1	643768	YES	NO	YES	D	25-11-2023 00:15:26	25-11-2023 01:02:15	01-12-2023 19:55:45
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_11_25\O1_MF_1_643768_LP2GD7O3_.ARC	1	1	643768	YES	NO	NO	A	25-11-2023 00:15:26	25-11-2023 01:02:15	08-12-2023 20:02:53
	1	1	643769	YES	NO	YES	D	25-11-2023 01:02:15	25-11-2023 01:41:01	25-11-2023 01:41:01
	1	1	643769	YES	NO	YES	D	25-11-2023 01:02:15	25-11-2023 01:41:01	01-12-2023 19:55:45
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_11_25\O1_MF_1_643769_LP2JNXRN_.ARC	1	1	643769	YES	NO	NO	A	25-11-2023 01:02:15	25-11-2023 01:41:01	08-12-2023 20:02:53
	1	1	643770	YES	NO	YES	D	25-11-2023 01:41:01	25-11-2023 02:07:11	25-11-2023 02:07:11
	1	1	643770	YES	NO	YES	D	25-11-2023 01:41:01	25-11-2023 02:07:11	01-12-2023 19:55:45
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_11_25\O1_MF_1_643770_LP2L5ZCG_.ARC	1	1	643770	YES	NO	NO	A	25-11-2023 01:41:01	25-11-2023 02:07:11	08-12-2023 20:02:53
	1	1	643771	YES	NO	YES	D	25-11-2023 02:07:11	25-11-2023 02:15:47	25-11-2023 02:15:47
	1	1	643771	YES	NO	YES	D	25-11-2023 02:07:11	25-11-2023 02:15:47	01-12-2023 19:55:45
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_11_25\O1_MF_1_643771_LP2LP3MP_.ARC	1	1	643771	YES	NO	NO	A	25-11-2023 02:07:11	25-11-2023 02:15:47	08-12-2023 20:02:53
	1	1	643772	YES	NO	YES	D	25-11-2023 02:15:47	25-11-2023 02:16:05	25-11-2023 02:16:05
	1	1	643772	YES	NO	YES	D	25-11-2023 02:15:47	25-11-2023 02:16:05	01-12-2023 19:55:45
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_11_25\O1_MF_1_643772_LP2LPOO7_.ARC	1	1	643772	YES	NO	NO	A	25-11-2023 02:15:47	25-11-2023 02:16:05	08-12-2023 20:02:53
...
...
...
	1	1	646334	YES	NO	YES	D	08-12-2023 19:30:48	08-12-2023 19:36:37	08-12-2023 19:36:37
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_08\O1_MF_1_646334_LQ6RKOD2_.ARC	1	1	646334	YES	NO	NO	A	08-12-2023 19:30:48	08-12-2023 19:36:37	08-12-2023 20:05:23
	1	1	646335	YES	NO	YES	D	08-12-2023 19:36:37	08-12-2023 19:43:16	08-12-2023 19:43:17
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_08\O1_MF_1_646335_LQ6RY556_.ARC	1	1	646335	YES	NO	NO	A	08-12-2023 19:36:37	08-12-2023 19:43:16	08-12-2023 20:05:23
	1	1	646336	YES	NO	YES	D	08-12-2023 19:43:16	08-12-2023 19:57:14	08-12-2023 19:57:15
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_08\O1_MF_1_646336_LQ6SRC7P_.ARC	1	1	646336	YES	NO	NO	A	08-12-2023 19:43:16	08-12-2023 19:57:14	08-12-2023 20:05:23
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_08\O1_MF_1_646337_LQ6T7D2G_.ARC	1	1	646337	YES	NO	NO	A	08-12-2023 19:57:14	08-12-2023 20:05:15	08-12-2023 20:05:16
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_08\O1_MF_1_646338_LQ6TNJGG_.ARC	1	1	646338	YES	NO	NO	A	08-12-2023 20:05:15	08-12-2023 20:12:16	08-12-2023 20:12:16
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_08\O1_MF_1_646339_LQ6V0MRB_.ARC	1	1	646339	YES	NO	NO	A	08-12-2023 20:12:16	08-12-2023 20:18:43	08-12-2023 20:18:43
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_08\O1_MF_1_646340_LQ6VC13J_.ARC	1	1	646340	YES	NO	NO	A	08-12-2023 20:18:43	08-12-2023 20:24:17	08-12-2023 20:24:17
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_08\O1_MF_1_646341_LQ6VQ7J1_.ARC	1	1	646341	YES	NO	NO	A	08-12-2023 20:24:17	08-12-2023 20:30:47	08-12-2023 20:30:47
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_08\O1_MF_1_646342_LQ6VYNR4_.ARC	1	1	646342	YES	NO	NO	A	08-12-2023 20:30:47	08-12-2023 20:34:44	08-12-2023 20:34:44
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_08\O1_MF_1_646343_LQ6WDQ6F_.ARC	1	1	646343	YES	NO	NO	A	08-12-2023 20:34:44	08-12-2023 20:42:15	08-12-2023 20:42:15
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_08\O1_MF_1_646344_LQ6WQ1L0_.ARC	1	1	646344	YES	NO	NO	A	08-12-2023 20:42:15	08-12-2023 20:47:45	08-12-2023 20:47:45
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_08\O1_MF_1_646345_LQ6X5458_.ARC	1	1	646345	YES	NO	NO	A	08-12-2023 20:47:45	08-12-2023 20:55:16	08-12-2023 20:55:16
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_08\O1_MF_1_646346_LQ6XHOSG_.ARC	1	1	646346	YES	NO	NO	A	08-12-2023 20:55:16	08-12-2023 21:00:52	08-12-2023 21:00:54
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_08\O1_MF_1_646347_LQ6Y19PQ_.ARC	1	1	646347	YES	NO	NO	A	08-12-2023 21:00:52	08-12-2023 21:10:17	08-12-2023 21:10:17
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_08\O1_MF_1_646348_LQ6YG862_.ARC	1	1	646348	YES	NO	NO	A	08-12-2023 21:10:17	08-12-2023 21:17:12	08-12-2023 21:17:12
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_08\O1_MF_1_646349_LQ6YPWK5_.ARC	1	1	646349	YES	NO	NO	A	08-12-2023 21:17:12	08-12-2023 21:21:48	08-12-2023 21:21:48
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_08\O1_MF_1_646350_LQ6Z16VO_.ARC	1	1	646350	YES	NO	NO	A	08-12-2023 21:21:48	08-12-2023 21:27:18	08-12-2023 21:27:18
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_08\O1_MF_1_646351_LQ6ZOSBS_.ARC	1	1	646351	YES	NO	NO	A	08-12-2023 21:27:18	08-12-2023 21:38:16	08-12-2023 21:38:17
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_08\O1_MF_1_646352_LQ708Y7P_.ARC	1	1	646352	YES	NO	NO	A	08-12-2023 21:38:16	08-12-2023 21:48:29	08-12-2023 21:48:30
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_08\O1_MF_1_646353_LQ70LS46_.ARC	1	1	646353	YES	NO	NO	A	08-12-2023 21:48:29	08-12-2023 21:53:45	08-12-2023 21:53:45
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_08\O1_MF_1_646354_LQ70YZHP_.ARC	1	1	646354	YES	NO	NO	A	08-12-2023 21:53:45	08-12-2023 22:00:15	08-12-2023 22:00:15
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_08\O1_MF_1_646355_LQ70ZQMC_.ARC	1	1	646355	YES	NO	NO	A	08-12-2023 22:00:15	08-12-2023 22:00:39	08-12-2023 22:00:39
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_08\O1_MF_1_646356_LQ7147RM_.ARC	1	1	646356	YES	NO	NO	A	08-12-2023 22:00:39	08-12-2023 22:03:03	08-12-2023 22:03:03
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_08\O1_MF_1_646357_LQ71DM6Q_.ARC	1	1	646357	YES	NO	NO	A	08-12-2023 22:03:03	08-12-2023 22:07:31	08-12-2023 22:07:31
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_08\O1_MF_1_646358_LQ71Q9NC_.ARC	1	1	646358	YES	NO	NO	A	08-12-2023 22:07:31	08-12-2023 22:13:13	08-12-2023 22:13:13
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_08\O1_MF_1_646359_LQ72MKOP_.ARC	1	1	646359	YES	NO	NO	A	08-12-2023 22:13:13	08-12-2023 22:28:17	08-12-2023 22:28:17
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_08\O1_MF_1_646360_LQ74P0BR_.ARC	1	1	646360	YES	NO	NO	A	08-12-2023 22:28:17	08-12-2023 23:03:44	08-12-2023 23:03:44
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_08\O1_MF_1_646361_LQ75L8H7_.ARC	1	1	646361	YES	NO	NO	A	08-12-2023 23:03:44	08-12-2023 23:18:48	08-12-2023 23:18:48
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_08\O1_MF_1_646362_LQ76RL28_.ARC	1	1	646362	YES	NO	NO	A	08-12-2023 23:18:48	08-12-2023 23:39:14	08-12-2023 23:39:14
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_09\O1_MF_1_646363_LQ782C0R_.ARC	1	1	646363	YES	NO	NO	A	08-12-2023 23:39:14	09-12-2023 00:01:30	09-12-2023 00:01:31
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_09\O1_MF_1_646364_LQ782K5O_.ARC	1	1	646364	YES	NO	NO	A	09-12-2023 00:01:30	09-12-2023 00:01:37	09-12-2023 00:01:37
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_09\O1_MF_1_646365_LQ782TB3_.ARC	1	1	646365	YES	NO	NO	A	09-12-2023 00:01:37	09-12-2023 00:01:46	09-12-2023 00:01:46
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_09\O1_MF_1_646366_LQ79P4B3_.ARC	1	1	646366	YES	NO	NO	A	09-12-2023 00:01:46	09-12-2023 00:29:08	09-12-2023 00:29:08
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_09\O1_MF_1_646367_LQ7CTGX1_.ARC	1	1	646367	YES	NO	NO	A	09-12-2023 00:29:08	09-12-2023 01:05:34	09-12-2023 01:05:35
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_09\O1_MF_1_646368_LQ7FGXYO_.ARC	1	1	646368	YES	NO	NO	A	09-12-2023 01:05:34	09-12-2023 01:33:33	09-12-2023 01:33:34
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_09\O1_MF_1_646369_LQ7HQVW9_.ARC	1	1	646369	YES	NO	NO	A	09-12-2023 01:33:33	09-12-2023 02:12:27	09-12-2023 02:12:28
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_09\O1_MF_1_646370_LQ7KL5BW_.ARC	1	1	646370	YES	NO	NO	A	09-12-2023 02:12:27	09-12-2023 02:43:33	09-12-2023 02:43:33
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_09\O1_MF_1_646371_LQ7LK7JP_.ARC	1	1	646371	YES	NO	NO	A	09-12-2023 02:43:33	09-12-2023 03:00:07	09-12-2023 03:00:07
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_09\O1_MF_1_646372_LQ7M108M_.ARC	1	1	646372	YES	NO	NO	A	09-12-2023 03:00:07	09-12-2023 03:08:32	09-12-2023 03:08:32
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_09\O1_MF_1_646373_LQ7N9NYX_.ARC	1	1	646373	YES	NO	NO	A	09-12-2023 03:08:32	09-12-2023 03:30:12	09-12-2023 03:30:13
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_09\O1_MF_1_646374_LQ7O118K_.ARC	1	1	646374	YES	NO	NO	A	09-12-2023 03:30:12	09-12-2023 03:42:41	09-12-2023 03:42:41
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_09\O1_MF_1_646375_LQ7Q4KBG_.ARC	1	1	646375	YES	NO	NO	A	09-12-2023 03:42:41	09-12-2023 04:18:41	09-12-2023 04:18:41
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_09\O1_MF_1_646376_LQ7SL8WS_.ARC	1	1	646376	YES	NO	NO	A	09-12-2023 04:18:41	09-12-2023 05:00:08	09-12-2023 05:00:09
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_09\O1_MF_1_646377_LQ7V16TT_.ARC	1	1	646377	YES	NO	NO	A	09-12-2023 05:00:08	09-12-2023 05:25:10	09-12-2023 05:25:10
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_09\O1_MF_1_646378_LQ7VNTWP_.ARC	1	1	646378	YES	NO	NO	A	09-12-2023 05:25:10	09-12-2023 05:35:38	09-12-2023 05:35:39
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_09\O1_MF_1_646379_LQ7W1MLX_.ARC	1	1	646379	YES	NO	NO	A	09-12-2023 05:35:38	09-12-2023 05:42:27	09-12-2023 05:42:27
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_09\O1_MF_1_646380_LQ7WX9NV_.ARC	1	1	646380	YES	NO	NO	A	09-12-2023 05:42:27	09-12-2023 05:57:13	09-12-2023 05:57:13
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_09\O1_MF_1_646381_LQ7X2XWK_.ARC	1	1	646381	YES	NO	NO	A	09-12-2023 05:57:13	09-12-2023 06:00:13	09-12-2023 06:00:14
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_09\O1_MF_1_646382_LQ7Z94V6_.ARC	1	1	646382	YES	NO	NO	A	09-12-2023 06:00:13	09-12-2023 06:37:40	09-12-2023 06:37:40
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_09\O1_MF_1_646383_LQ7ZV8JY_.ARC	1	1	646383	YES	NO	NO	A	09-12-2023 06:37:40	09-12-2023 06:47:20	09-12-2023 06:47:20
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_09\O1_MF_1_646384_LQ7ZVXKR_.ARC	1	1	646384	YES	NO	NO	A	09-12-2023 06:47:20	09-12-2023 06:47:41	09-12-2023 06:47:41
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_09\O1_MF_1_646385_LQ82L99P_.ARC	1	1	646385	YES	NO	NO	A	09-12-2023 06:47:41	09-12-2023 07:33:45	09-12-2023 07:33:45
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_09\O1_MF_1_646386_LQ847S95_.ARC	1	1	646386	YES	NO	NO	A	09-12-2023 07:33:45	09-12-2023 08:02:17	09-12-2023 08:02:17
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_09\O1_MF_1_646387_LQ84YB37_.ARC	1	1	646387	YES	NO	NO	A	09-12-2023 08:02:17	09-12-2023 08:14:18	09-12-2023 08:14:18
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_09\O1_MF_1_646388_LQ879C12_.ARC	1	1	646388	YES	NO	NO	A	09-12-2023 08:14:18	09-12-2023 08:54:19	09-12-2023 08:54:19
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_09\O1_MF_1_646389_LQ89V1V9_.ARC	1	1	646389	YES	NO	NO	A	09-12-2023 08:54:19	09-12-2023 09:37:53	09-12-2023 09:37:53
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_09\O1_MF_1_646390_LQ8CHH3M_.ARC	1	1	646390	YES	NO	NO	A	09-12-2023 09:37:53	09-12-2023 10:05:51	09-12-2023 10:05:51
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_09\O1_MF_1_646391_LQ8G1GJ7_.ARC	1	1	646391	YES	NO	NO	A	09-12-2023 10:05:51	09-12-2023 10:49:34	09-12-2023 10:49:34
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_09\O1_MF_1_646392_LQ8HOOBH_.ARC	1	1	646392	YES	NO	NO	A	09-12-2023 10:49:34	09-12-2023 11:17:25	09-12-2023 11:17:25
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_09\O1_MF_1_646393_LQ8K3RVY_.ARC	1	1	646393	YES	NO	NO	A	09-12-2023 11:17:25	09-12-2023 11:42:00	09-12-2023 11:42:00
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_09\O1_MF_1_646394_LQ8KK3P2_.ARC	1	1	646394	YES	NO	NO	A	09-12-2023 11:42:00	09-12-2023 11:49:07	09-12-2023 11:49:07
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_09\O1_MF_1_646395_LQ8LXT0Q_.ARC	1	1	646395	YES	NO	NO	A	09-12-2023 11:49:07	09-12-2023 12:12:57	09-12-2023 12:12:58
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_09\O1_MF_1_646396_LQ8N939C_.ARC	1	1	646396	YES	NO	NO	A	09-12-2023 12:12:57	09-12-2023 12:36:03	09-12-2023 12:36:03
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_09\O1_MF_1_646397_LQ8Q3C0W_.ARC	1	1	646397	YES	NO	NO	A	09-12-2023 12:36:03	09-12-2023 13:24:10	09-12-2023 13:24:11
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_09\O1_MF_1_646398_LQ8SLHXG_.ARC	1	1	646398	YES	NO	NO	A	09-12-2023 13:24:10	09-12-2023 14:06:23	09-12-2023 14:06:24
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_09\O1_MF_1_646399_LQ8TSH26_.ARC	1	1	646399	YES	NO	NO	A	09-12-2023 14:06:23	09-12-2023 14:27:11	09-12-2023 14:27:11
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_09\O1_MF_1_646400_LQ8WV2SG_.ARC	1	1	646400	YES	NO	NO	A	09-12-2023 14:27:11	09-12-2023 15:02:10	09-12-2023 15:02:10
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_09\O1_MF_1_646401_LQ8ZMPDM_.ARC	1	1	646401	YES	NO	NO	A	09-12-2023 15:02:10	09-12-2023 15:49:26	09-12-2023 15:49:26
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_09\O1_MF_1_646402_LQ928TL7_.ARC	1	1	646402	YES	NO	NO	A	09-12-2023 15:49:26	09-12-2023 16:34:50	09-12-2023 16:34:50
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_09\O1_MF_1_646403_LQ95DSLJ_.ARC	1	1	646403	YES	NO	NO	A	09-12-2023 16:34:50	09-12-2023 17:28:09	09-12-2023 17:28:09
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_09\O1_MF_1_646404_LQ97OCJ7_.ARC	1	1	646404	YES	NO	NO	A	09-12-2023 17:28:09	09-12-2023 18:06:51	09-12-2023 18:06:51
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_09\O1_MF_1_646405_LQ9BBDVZ_.ARC	1	1	646405	YES	NO	NO	A	09-12-2023 18:06:51	09-12-2023 18:52:12	09-12-2023 18:52:12
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_09\O1_MF_1_646406_LQ9F068S_.ARC	1	1	646406	YES	NO	NO	A	09-12-2023 18:52:12	09-12-2023 19:37:58	09-12-2023 19:37:58
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_09\O1_MF_1_646407_LQ9G9Z1Y_.ARC	1	1	646407	YES	NO	NO	A	09-12-2023 19:37:58	09-12-2023 20:00:15	09-12-2023 20:00:15
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_09\O1_MF_1_646408_LQ9JF8VQ_.ARC	1	1	646408	YES	NO	NO	A	09-12-2023 20:00:15	09-12-2023 20:36:08	09-12-2023 20:36:08
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_09\O1_MF_1_646409_LQ9LZS59_.ARC	1	1	646409	YES	NO	NO	A	09-12-2023 20:36:08	09-12-2023 21:20:09	09-12-2023 21:20:09
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_09\O1_MF_1_646410_LQ9OQX7W_.ARC	1	1	646410	YES	NO	NO	A	09-12-2023 21:20:09	09-12-2023 22:07:09	09-12-2023 22:07:09
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_09\O1_MF_1_646411_LQ9Q32XM_.ARC	1	1	646411	YES	NO	NO	A	09-12-2023 22:07:09	09-12-2023 22:30:10	09-12-2023 22:30:11
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_09\O1_MF_1_646412_LQ9RY4CV_.ARC	1	1	646412	YES	NO	NO	A	09-12-2023 22:30:10	09-12-2023 23:01:40	09-12-2023 23:01:40
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_09\O1_MF_1_646413_LQ9VT14H_.ARC	1	1	646413	YES	NO	NO	A	09-12-2023 23:01:40	09-12-2023 23:50:41	09-12-2023 23:50:41
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_10\O1_MF_1_646414_LQ9WOG1T_.ARC	1	1	646414	YES	NO	NO	A	09-12-2023 23:50:41	10-12-2023 00:05:18	10-12-2023 00:05:18
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_10\O1_MF_1_646415_LQ9Y34M4_.ARC	1	1	646415	YES	NO	NO	A	10-12-2023 00:05:18	10-12-2023 00:29:40	10-12-2023 00:29:40
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_10\O1_MF_1_646416_LQB0XJS9_.ARC	1	1	646416	YES	NO	NO	A	10-12-2023 00:29:40	10-12-2023 01:17:52	10-12-2023 01:17:52
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_10\O1_MF_1_646417_LQB3TQ99_.ARC	1	1	646417	YES	NO	NO	A	10-12-2023 01:17:52	10-12-2023 02:07:35	10-12-2023 02:07:35
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_10\O1_MF_1_646418_LQB621T9_.ARC	1	1	646418	YES	NO	NO	A	10-12-2023 02:07:35	10-12-2023 02:45:37	10-12-2023 02:45:37
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_10\O1_MF_1_646419_LQB6X5YD_.ARC	1	1	646419	YES	NO	NO	A	10-12-2023 02:45:37	10-12-2023 03:00:05	10-12-2023 03:00:06
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_10\O1_MF_1_646420_LQB82TFC_.ARC	1	1	646420	YES	NO	NO	A	10-12-2023 03:00:05	10-12-2023 03:20:10	10-12-2023 03:20:10
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_10\O1_MF_1_646421_LQBC508Y_.ARC	1	1	646421	YES	NO	NO	A	10-12-2023 03:20:10	10-12-2023 04:12:32	10-12-2023 04:12:32
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_10\O1_MF_1_646422_LQBFLMZ7_.ARC	1	1	646422	YES	NO	NO	A	10-12-2023 04:12:32	10-12-2023 04:53:55	10-12-2023 04:53:56
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_10\O1_MF_1_646423_LQBHZVYR_.ARC	1	1	646423	YES	NO	NO	A	10-12-2023 04:53:55	10-12-2023 05:35:07	10-12-2023 05:35:08
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_10\O1_MF_1_646424_LQBKGPWC_.ARC	1	1	646424	YES	NO	NO	A	10-12-2023 05:35:07	10-12-2023 06:00:06	10-12-2023 06:00:07
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_10\O1_MF_1_646425_LQBMPZNF_.ARC	1	1	646425	YES	NO	NO	A	10-12-2023 06:00:06	10-12-2023 06:38:39	10-12-2023 06:38:39
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_10\O1_MF_1_646426_LQBNZGJR_.ARC	1	1	646426	YES	NO	NO	A	10-12-2023 06:38:39	10-12-2023 07:00:14	10-12-2023 07:00:14
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_10\O1_MF_1_646427_LQBQG0W2_.ARC	1	1	646427	YES	NO	NO	A	10-12-2023 07:00:14	10-12-2023 07:42:08	10-12-2023 07:42:08
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_10\O1_MF_1_646428_LQBT1R6C_.ARC	1	1	646428	YES	NO	NO	A	10-12-2023 07:42:08	10-12-2023 08:26:48	10-12-2023 08:26:48
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_10\O1_MF_1_646429_LQBWMZMS_.ARC	1	1	646429	YES	NO	NO	A	10-12-2023 08:26:48	10-12-2023 09:10:39	10-12-2023 09:10:39
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_10\O1_MF_1_646430_LQBZ4MTY_.ARC	1	1	646430	YES	NO	NO	A	10-12-2023 09:10:39	10-12-2023 09:53:39	10-12-2023 09:53:39
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_10\O1_MF_1_646431_LQC00S6P_.ARC	1	1	646431	YES	NO	NO	A	10-12-2023 09:53:39	10-12-2023 10:08:41	10-12-2023 10:08:41
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_10\O1_MF_1_646432_LQC28Z8N_.ARC	1	1	646432	YES	NO	NO	A	10-12-2023 10:08:41	10-12-2023 10:47:11	10-12-2023 10:47:11
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_10\O1_MF_1_646433_LQC3NG0Z_.ARC	1	1	646433	YES	NO	NO	A	10-12-2023 10:47:11	10-12-2023 11:10:21	10-12-2023 11:10:22
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_10\O1_MF_1_646434_LQC3TKDG_.ARC	1	1	646434	YES	NO	NO	A	10-12-2023 11:10:21	10-12-2023 11:13:37	10-12-2023 11:13:37
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_10\O1_MF_1_646435_LQC41VOW_.ARC	1	1	646435	YES	NO	NO	A	10-12-2023 11:13:37	10-12-2023 11:17:31	10-12-2023 11:17:31
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_10\O1_MF_1_646436_LQC5WXBN_.ARC	1	1	646436	YES	NO	NO	A	10-12-2023 11:17:31	10-12-2023 11:49:01	10-12-2023 11:49:01
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_10\O1_MF_1_646437_LQC886PL_.ARC	1	1	646437	YES	NO	NO	A	10-12-2023 11:49:01	10-12-2023 12:29:10	10-12-2023 12:29:10
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_10\O1_MF_1_646438_LQC8HN45_.ARC	1	1	646438	YES	NO	NO	A	10-12-2023 12:29:10	10-12-2023 12:33:08	10-12-2023 12:33:08
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_10\O1_MF_1_646439_LQC926PS_.ARC	1	1	646439	YES	NO	NO	A	10-12-2023 12:33:08	10-12-2023 12:43:02	10-12-2023 12:43:02
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_10\O1_MF_1_646440_LQC9CB54_.ARC	1	1	646440	YES	NO	NO	A	10-12-2023 12:43:02	10-12-2023 12:47:54	10-12-2023 12:47:54
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_10\O1_MF_1_646441_LQC9MRL0_.ARC	1	1	646441	YES	NO	NO	A	10-12-2023 12:47:54	10-12-2023 12:52:24	10-12-2023 12:52:24
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_10\O1_MF_1_646442_LQCDJSLK_.ARC	1	1	646442	YES	NO	NO	A	10-12-2023 12:52:24	10-12-2023 13:42:01	10-12-2023 13:42:01
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_10\O1_MF_1_646443_LQCDXV2T_.ARC	1	1	646443	YES	NO	NO	A	10-12-2023 13:42:01	10-12-2023 13:48:59	10-12-2023 13:48:59
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_10\O1_MF_1_646444_LQCG3OL4_.ARC	1	1	646444	YES	NO	NO	A	10-12-2023 13:48:59	10-12-2023 14:09:09	10-12-2023 14:09:09
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_10\O1_MF_1_646445_LQCJKW15_.ARC	1	1	646445	YES	NO	NO	A	10-12-2023 14:09:09	10-12-2023 14:50:52	10-12-2023 14:50:52
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_10\O1_MF_1_646446_LQCLRY8X_.ARC	1	1	646446	YES	NO	NO	A	10-12-2023 14:50:52	10-12-2023 15:28:46	10-12-2023 15:28:46
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_10\O1_MF_1_646447_LQCOOF4Z_.ARC	1	1	646447	YES	NO	NO	A	10-12-2023 15:28:46	10-12-2023 16:18:05	10-12-2023 16:18:05
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_10\O1_MF_1_646448_LQCQW65J_.ARC	1	1	646448	YES	NO	NO	A	10-12-2023 16:18:05	10-12-2023 16:55:50	10-12-2023 16:55:50
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_10\O1_MF_1_646449_LQCT79QM_.ARC	1	1	646449	YES	NO	NO	A	10-12-2023 16:55:50	10-12-2023 17:35:53	10-12-2023 17:35:53
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_10\O1_MF_1_646450_LQCW6LL8_.ARC	1	1	646450	YES	NO	NO	A	10-12-2023 17:35:53	10-12-2023 18:09:38	10-12-2023 18:09:38
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_10\O1_MF_1_646451_LQCYPCXF_.ARC	1	1	646451	YES	NO	NO	A	10-12-2023 18:09:38	10-12-2023 18:52:11	10-12-2023 18:52:12
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_10\O1_MF_1_646452_LQD0N7HM_.ARC	1	1	646452	YES	NO	NO	A	10-12-2023 18:52:11	10-12-2023 19:25:11	10-12-2023 19:25:11
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_10\O1_MF_1_646453_LQD32C1L_.ARC	1	1	646453	YES	NO	NO	A	10-12-2023 19:25:11	10-12-2023 20:06:51	10-12-2023 20:06:51
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_10\O1_MF_1_646454_LQD5WQMS_.ARC	1	1	646454	YES	NO	NO	A	10-12-2023 20:06:51	10-12-2023 20:55:03	10-12-2023 20:55:03
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_10\O1_MF_1_646455_LQD8KBS6_.ARC	1	1	646455	YES	NO	NO	A	10-12-2023 20:55:03	10-12-2023 21:40:09	10-12-2023 21:40:11
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_10\O1_MF_1_646456_LQDB9C0B_.ARC	1	1	646456	YES	NO	NO	A	10-12-2023 21:40:09	10-12-2023 22:10:02	10-12-2023 22:10:03
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_10\O1_MF_1_646457_LQDDGPV0_.ARC	1	1	646457	YES	NO	NO	A	10-12-2023 22:10:02	10-12-2023 22:47:02	10-12-2023 22:47:02
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_10\O1_MF_1_646458_LQDGZPYO_.ARC	1	1	646458	YES	NO	NO	A	10-12-2023 22:47:02	10-12-2023 23:30:14	10-12-2023 23:30:15
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646459_LQDJQVST_.ARC	1	1	646459	YES	NO	NO	A	10-12-2023 23:30:14	11-12-2023 00:00:11	11-12-2023 00:00:12
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646460_LQDJYFTJ_.ARC	1	1	646460	YES	NO	NO	A	11-12-2023 00:00:11	11-12-2023 00:03:41	11-12-2023 00:03:41
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646461_LQDLJ4V8_.ARC	1	1	646461	YES	NO	NO	A	11-12-2023 00:03:41	11-12-2023 00:30:12	11-12-2023 00:30:13
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646462_LQDO86HO_.ARC	1	1	646462	YES	NO	NO	A	11-12-2023 00:30:12	11-12-2023 01:17:10	11-12-2023 01:17:10
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646463_LQDQSF27_.ARC	1	1	646463	YES	NO	NO	A	11-12-2023 01:17:10	11-12-2023 02:00:29	11-12-2023 02:00:29
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646464_LQDTPG3C_.ARC	1	1	646464	YES	NO	NO	A	11-12-2023 02:00:29	11-12-2023 02:50:06	11-12-2023 02:50:06
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646465_LQDV99XD_.ARC	1	1	646465	YES	NO	NO	A	11-12-2023 02:50:06	11-12-2023 03:00:09	11-12-2023 03:00:10
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646466_LQDYDPX7_.ARC	1	1	646466	YES	NO	NO	A	11-12-2023 03:00:09	11-12-2023 03:53:10	11-12-2023 03:53:11
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646467_LQF0OY1V_.ARC	1	1	646467	YES	NO	NO	A	11-12-2023 03:53:10	11-12-2023 04:32:14	11-12-2023 04:32:14
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646468_LQF3Q9OZ_.ARC	1	1	646468	YES	NO	NO	A	11-12-2023 04:32:14	11-12-2023 05:24:09	11-12-2023 05:24:09
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646469_LQF65Q3X_.ARC	1	1	646469	YES	NO	NO	A	11-12-2023 05:24:09	11-12-2023 06:05:59	11-12-2023 06:05:59
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646470_LQF6YFJC_.ARC	1	1	646470	YES	NO	NO	A	11-12-2023 06:05:59	11-12-2023 06:19:09	11-12-2023 06:19:09
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646471_LQF70DOV_.ARC	1	1	646471	YES	NO	NO	A	11-12-2023 06:19:09	11-12-2023 06:20:12	11-12-2023 06:20:12
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646472_LQF7O1XW_.ARC	1	1	646472	YES	NO	NO	A	11-12-2023 06:20:12	11-12-2023 06:31:13	11-12-2023 06:31:14
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646473_LQF7TP9W_.ARC	1	1	646473	YES	NO	NO	A	11-12-2023 06:31:13	11-12-2023 06:34:14	11-12-2023 06:34:14
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646474_LQF85YY7_.ARC	1	1	646474	YES	NO	NO	A	11-12-2023 06:34:14	11-12-2023 06:40:14	11-12-2023 06:40:15
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646475_LQF9O0SD_.ARC	1	1	646475	YES	NO	NO	A	11-12-2023 06:40:14	11-12-2023 07:05:20	11-12-2023 07:05:20
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646476_LQF9YMC4_.ARC	1	1	646476	YES	NO	NO	A	11-12-2023 07:05:20	11-12-2023 07:10:27	11-12-2023 07:10:27
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646477_LQFBBG6G_.ARC	1	1	646477	YES	NO	NO	A	11-12-2023 07:10:27	11-12-2023 07:16:46	11-12-2023 07:16:46
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646478_LQFBTB7Y_.ARC	1	1	646478	YES	NO	NO	A	11-12-2023 07:16:46	11-12-2023 07:25:14	11-12-2023 07:25:14
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646479_LQFBW7DK_.ARC	1	1	646479	YES	NO	NO	A	11-12-2023 07:25:14	11-12-2023 07:26:15	11-12-2023 07:26:15
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646480_LQFBWFFW_.ARC	1	1	646480	YES	NO	NO	A	11-12-2023 07:26:15	11-12-2023 07:26:21	11-12-2023 07:26:21
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646481_LQFC7J3T_.ARC	1	1	646481	YES	NO	NO	A	11-12-2023 07:26:21	11-12-2023 07:32:16	11-12-2023 07:32:16
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646482_LQFC906H_.ARC	1	1	646482	YES	NO	NO	A	11-12-2023 07:32:16	11-12-2023 07:33:04	11-12-2023 07:33:04
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646483_LQFCGCHH_.ARC	1	1	646483	YES	NO	NO	A	11-12-2023 07:33:04	11-12-2023 07:35:55	11-12-2023 07:35:55
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646484_LQFCT60R_.ARC	1	1	646484	YES	NO	NO	A	11-12-2023 07:35:55	11-12-2023 07:42:13	11-12-2023 07:42:14
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646485_LQFD0LDV_.ARC	1	1	646485	YES	NO	NO	A	11-12-2023 07:42:13	11-12-2023 07:45:38	11-12-2023 07:45:38
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646486_LQFD1JFZ_.ARC	1	1	646486	YES	NO	NO	A	11-12-2023 07:45:38	11-12-2023 07:46:08	11-12-2023 07:46:08
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646487_LQFD33JF_.ARC	1	1	646487	YES	NO	NO	A	11-12-2023 07:46:08	11-12-2023 07:46:59	11-12-2023 07:46:59
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646488_LQFDGL1Y_.ARC	1	1	646488	YES	NO	NO	A	11-12-2023 07:46:59	11-12-2023 07:53:06	11-12-2023 07:53:06
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646489_LQFDH74N_.ARC	1	1	646489	YES	NO	NO	A	11-12-2023 07:53:06	11-12-2023 07:53:27	11-12-2023 07:53:27
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646490_LQFDJK5S_.ARC	1	1	646490	YES	NO	NO	A	11-12-2023 07:53:27	11-12-2023 07:54:09	11-12-2023 07:54:09
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646491_LQFDMK9S_.ARC	1	1	646491	YES	NO	NO	A	11-12-2023 07:54:09	11-12-2023 07:55:45	11-12-2023 07:55:45
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646492_LQFDT3NK_.ARC	1	1	646492	YES	NO	NO	A	11-12-2023 07:55:45	11-12-2023 07:59:15	11-12-2023 07:59:15
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646493_LQFFC3NM_.ARC	1	1	646493	YES	NO	NO	A	11-12-2023 07:59:15	11-12-2023 08:08:19	11-12-2023 08:08:19
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646494_LQFFQZGH_.ARC	1	1	646494	YES	NO	NO	A	11-12-2023 08:08:19	11-12-2023 08:15:11	11-12-2023 08:15:11
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646495_LQFG543D_.ARC	1	1	646495	YES	NO	NO	A	11-12-2023 08:15:11	11-12-2023 08:22:12	11-12-2023 08:22:12
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646496_LQFGKPOY_.ARC	1	1	646496	YES	NO	NO	A	11-12-2023 08:22:12	11-12-2023 08:28:54	11-12-2023 08:28:54
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646497_LQFGX87G_.ARC	1	1	646497	YES	NO	NO	A	11-12-2023 08:28:54	11-12-2023 08:35:04	11-12-2023 08:35:04
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646498_LQFHH77K_.ARC	1	1	646498	YES	NO	NO	A	11-12-2023 08:35:04	11-12-2023 08:44:39	11-12-2023 08:44:39
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646499_LQFHQOR6_.ARC	1	1	646499	YES	NO	NO	A	11-12-2023 08:44:39	11-12-2023 08:49:09	11-12-2023 08:49:09
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646500_LQFJ6SOR_.ARC	1	1	646500	YES	NO	NO	A	11-12-2023 08:49:09	11-12-2023 08:57:13	11-12-2023 08:57:13
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646501_LQFJP6J6_.ARC	1	1	646501	YES	NO	NO	A	11-12-2023 08:57:13	11-12-2023 09:05:26	11-12-2023 09:05:26
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646502_LQFJWFC5_.ARC	1	1	646502	YES	NO	NO	A	11-12-2023 09:05:26	11-12-2023 09:08:44	11-12-2023 09:08:45
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646503_LQFJXG3W_.ARC	1	1	646503	YES	NO	NO	A	11-12-2023 09:08:44	11-12-2023 09:09:18	11-12-2023 09:09:18
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646504_LQFJZ76W_.ARC	1	1	646504	YES	NO	NO	A	11-12-2023 09:09:18	11-12-2023 09:10:15	11-12-2023 09:10:15
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646505_LQFK4RKK_.ARC	1	1	646505	YES	NO	NO	A	11-12-2023 09:10:15	11-12-2023 09:13:12	11-12-2023 09:13:12
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646506_LQFK5MMX_.ARC	1	1	646506	YES	NO	NO	A	11-12-2023 09:13:12	11-12-2023 09:13:39	11-12-2023 09:13:39
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646507_LQFKBVVT_.ARC	1	1	646507	YES	NO	NO	A	11-12-2023 09:13:39	11-12-2023 09:16:27	11-12-2023 09:16:27
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646508_LQFKFPM2_.ARC	1	1	646508	YES	NO	NO	A	11-12-2023 09:16:27	11-12-2023 09:17:58	11-12-2023 09:17:58
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646509_LQFKQQSR_.ARC	1	1	646509	YES	NO	NO	A	11-12-2023 09:17:58	11-12-2023 09:23:19	11-12-2023 09:23:19
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646510_LQFKRRVX_.ARC	1	1	646510	YES	NO	NO	A	11-12-2023 09:23:19	11-12-2023 09:23:52	11-12-2023 09:23:53
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646511_LQFKSJXZ_.ARC	1	1	646511	YES	NO	NO	A	11-12-2023 09:23:52	11-12-2023 09:24:16	11-12-2023 09:24:17
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646512_LQFKSZZ0_.ARC	1	1	646512	YES	NO	NO	A	11-12-2023 09:24:16	11-12-2023 09:24:31	11-12-2023 09:24:32
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646513_LQFKTR26_.ARC	1	1	646513	YES	NO	NO	A	11-12-2023 09:24:31	11-12-2023 09:24:56	11-12-2023 09:24:56
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646514_LQFKWN5R_.ARC	1	1	646514	YES	NO	NO	A	11-12-2023 09:24:56	11-12-2023 09:25:56	11-12-2023 09:25:56
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646515_LQFKXO6X_.ARC	1	1	646515	YES	NO	NO	A	11-12-2023 09:25:56	11-12-2023 09:26:29	11-12-2023 09:26:29
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646516_LQFLG5XY_.ARC	1	1	646516	YES	NO	NO	A	11-12-2023 09:26:29	11-12-2023 09:35:17	11-12-2023 09:35:18
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646517_LQFLQHBX_.ARC	1	1	646517	YES	NO	NO	A	11-12-2023 09:35:17	11-12-2023 09:40:15	11-12-2023 09:40:15
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646518_LQFM2CRN_.ARC	1	1	646518	YES	NO	NO	A	11-12-2023 09:40:15	11-12-2023 09:46:03	11-12-2023 09:46:03
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646519_LQFML4CR_.ARC	1	1	646519	YES	NO	NO	A	11-12-2023 09:46:03	11-12-2023 09:54:28	11-12-2023 09:54:28
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646520_LQFMYT0W_.ARC	1	1	646520	YES	NO	NO	A	11-12-2023 09:54:28	11-12-2023 10:01:13	11-12-2023 10:01:14
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646521_LQFNPY31_.ARC	1	1	646521	YES	NO	NO	A	11-12-2023 10:01:13	11-12-2023 10:14:06	11-12-2023 10:14:06
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646522_LQFO9K2B_.ARC	1	1	646522	YES	NO	NO	A	11-12-2023 10:14:06	11-12-2023 10:24:01	11-12-2023 10:24:01
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646523_LQFOG17G_.ARC	1	1	646523	YES	NO	NO	A	11-12-2023 10:24:01	11-12-2023 10:26:25	11-12-2023 10:26:25
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646524_LQFOH5C0_.ARC	1	1	646524	YES	NO	NO	A	11-12-2023 10:26:25	11-12-2023 10:27:01	11-12-2023 10:27:01
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646525_LQFOL9NF_.ARC	1	1	646525	YES	NO	NO	A	11-12-2023 10:27:01	11-12-2023 10:28:41	11-12-2023 10:28:41
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646526_LQFOOHVR_.ARC	1	1	646526	YES	NO	NO	A	11-12-2023 10:28:41	11-12-2023 10:30:23	11-12-2023 10:30:23
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646527_LQFOPVNT_.ARC	1	1	646527	YES	NO	NO	A	11-12-2023 10:30:23	11-12-2023 10:31:07	11-12-2023 10:31:07
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646528_LQFOTMTB_.ARC	1	1	646528	YES	NO	NO	A	11-12-2023 10:31:07	11-12-2023 10:33:07	11-12-2023 10:33:07
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646529_LQFOVTVN_.ARC	1	1	646529	YES	NO	NO	A	11-12-2023 10:33:07	11-12-2023 10:33:46	11-12-2023 10:33:46
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646530_LQFOZF2V_.ARC	1	1	646530	YES	NO	NO	A	11-12-2023 10:33:46	11-12-2023 10:35:41	11-12-2023 10:35:41
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646531_LQFP329D_.ARC	1	1	646531	YES	NO	NO	A	11-12-2023 10:35:41	11-12-2023 10:37:38	11-12-2023 10:37:38
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646532_LQFP5JF3_.ARC	1	1	646532	YES	NO	NO	A	11-12-2023 10:37:38	11-12-2023 10:38:56	11-12-2023 10:38:56
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646533_LQFP7YMG_.ARC	1	1	646533	YES	NO	NO	A	11-12-2023 10:38:56	11-12-2023 10:40:14	11-12-2023 10:40:14
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646534_LQFP9NPB_.ARC	1	1	646534	YES	NO	NO	A	11-12-2023 10:40:14	11-12-2023 10:41:08	11-12-2023 10:41:08
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646535_LQFPKG2D_.ARC	1	1	646535	YES	NO	NO	A	11-12-2023 10:41:08	11-12-2023 10:45:18	11-12-2023 10:45:18
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646536_LQFPMN8N_.ARC	1	1	646536	YES	NO	NO	A	11-12-2023 10:45:18	11-12-2023 10:46:28	11-12-2023 10:46:28
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646537_LQFQ05RV_.ARC	1	1	646537	YES	NO	NO	A	11-12-2023 10:46:28	11-12-2023 10:53:09	11-12-2023 10:53:09
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646538_LQFQFFK4_.ARC	1	1	646538	YES	NO	NO	A	11-12-2023 10:53:09	11-12-2023 11:00:13	11-12-2023 11:00:13
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646539_LQFQQ01W_.ARC	1	1	646539	YES	NO	NO	A	11-12-2023 11:00:13	11-12-2023 11:05:20	11-12-2023 11:05:20
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646540_LQFQRS6N_.ARC	1	1	646540	YES	NO	NO	A	11-12-2023 11:05:20	11-12-2023 11:06:17	11-12-2023 11:06:17
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646541_LQFQWNGM_.ARC	1	1	646541	YES	NO	NO	A	11-12-2023 11:06:17	11-12-2023 11:08:20	11-12-2023 11:08:20
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646542_LQFQZKMN_.ARC	1	1	646542	YES	NO	NO	A	11-12-2023 11:08:20	11-12-2023 11:09:53	11-12-2023 11:09:53
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646543_LQFR14PB_.ARC	1	1	646543	YES	NO	NO	A	11-12-2023 11:09:53	11-12-2023 11:10:44	11-12-2023 11:10:44
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646544_LQFR2KRL_.ARC	1	1	646544	YES	NO	NO	A	11-12-2023 11:10:44	11-12-2023 11:11:29	11-12-2023 11:11:29
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646545_LQFR3YTD_.ARC	1	1	646545	YES	NO	NO	A	11-12-2023 11:11:29	11-12-2023 11:12:14	11-12-2023 11:12:14
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646546_LQFR4WW5_.ARC	1	1	646546	YES	NO	NO	A	11-12-2023 11:12:14	11-12-2023 11:12:44	11-12-2023 11:12:44
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646547_LQFR6Z03_.ARC	1	1	646547	YES	NO	NO	A	11-12-2023 11:12:44	11-12-2023 11:13:50	11-12-2023 11:13:51
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646548_LQFR8332_.ARC	1	1	646548	YES	NO	NO	A	11-12-2023 11:13:50	11-12-2023 11:14:27	11-12-2023 11:14:27
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646549_LQFR8V5X_.ARC	1	1	646549	YES	NO	NO	A	11-12-2023 11:14:27	11-12-2023 11:14:51	11-12-2023 11:14:51
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646550_LQFRFQCQ_.ARC	1	1	646550	YES	NO	NO	A	11-12-2023 11:14:51	11-12-2023 11:17:27	11-12-2023 11:17:27
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646551_LQFRHSFH_.ARC	1	1	646551	YES	NO	NO	A	11-12-2023 11:17:27	11-12-2023 11:18:33	11-12-2023 11:18:33
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646552_LQFRJQHX_.ARC	1	1	646552	YES	NO	NO	A	11-12-2023 11:18:33	11-12-2023 11:19:03	11-12-2023 11:19:03
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646553_LQFRKYLJ_.ARC	1	1	646553	YES	NO	NO	A	11-12-2023 11:19:03	11-12-2023 11:19:42	11-12-2023 11:19:42
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646554_LQFRM5NY_.ARC	1	1	646554	YES	NO	NO	A	11-12-2023 11:19:42	11-12-2023 11:20:21	11-12-2023 11:20:21
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646555_LQFROPW1_.ARC	1	1	646555	YES	NO	NO	A	11-12-2023 11:20:21	11-12-2023 11:21:42	11-12-2023 11:21:42
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646556_LQFS4TOO_.ARC	1	1	646556	YES	NO	NO	A	11-12-2023 11:21:42	11-12-2023 11:29:46	11-12-2023 11:29:46
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646557_LQFS8LVZ_.ARC	1	1	646557	YES	NO	NO	A	11-12-2023 11:29:46	11-12-2023 11:31:46	11-12-2023 11:31:47
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646558_LQFS8VX8_.ARC	1	1	646558	YES	NO	NO	A	11-12-2023 11:31:46	11-12-2023 11:31:55	11-12-2023 11:31:56
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646559_LQFSNSH5_.ARC	1	1	646559	YES	NO	NO	A	11-12-2023 11:31:55	11-12-2023 11:38:17	11-12-2023 11:38:17
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646560_LQFSY8XL_.ARC	1	1	646560	YES	NO	NO	A	11-12-2023 11:38:17	11-12-2023 11:43:20	11-12-2023 11:43:21
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646561_LQFTD5JM_.ARC	1	1	646561	YES	NO	NO	A	11-12-2023 11:43:20	11-12-2023 11:50:45	11-12-2023 11:50:45
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646562_LQFTKZTC_.ARC	1	1	646562	YES	NO	NO	A	11-12-2023 11:50:45	11-12-2023 11:53:51	11-12-2023 11:53:51
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646563_LQFTR954_.ARC	1	1	646563	YES	NO	NO	A	11-12-2023 11:53:51	11-12-2023 11:57:13	11-12-2023 11:57:13
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646564_LQFTS16Z_.ARC	1	1	646564	YES	NO	NO	A	11-12-2023 11:57:13	11-12-2023 11:57:37	11-12-2023 11:57:37
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646565_LQFV4YPO_.ARC	1	1	646565	YES	NO	NO	A	11-12-2023 11:57:37	11-12-2023 12:03:58	11-12-2023 12:03:58
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646566_LQFVMMG3_.ARC	1	1	646566	YES	NO	NO	A	11-12-2023 12:03:58	11-12-2023 12:11:47	11-12-2023 12:11:47
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646567_LQFVQCM4_.ARC	1	1	646567	YES	NO	NO	A	11-12-2023 12:11:47	11-12-2023 12:13:47	11-12-2023 12:13:47
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646568_LQFVSJQN_.ARC	1	1	646568	YES	NO	NO	A	11-12-2023 12:13:47	11-12-2023 12:14:56	11-12-2023 12:14:56
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646569_LQFVVYW1_.ARC	1	1	646569	YES	NO	NO	A	11-12-2023 12:14:56	11-12-2023 12:16:14	11-12-2023 12:16:15
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646570_LQFVYS10_.ARC	1	1	646570	YES	NO	NO	A	11-12-2023 12:16:14	11-12-2023 12:17:44	11-12-2023 12:17:45
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646571_LQFW0Y35_.ARC	1	1	646571	YES	NO	NO	A	11-12-2023 12:17:44	11-12-2023 12:18:54	11-12-2023 12:18:54
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646572_LQFW3D7M_.ARC	1	1	646572	YES	NO	NO	A	11-12-2023 12:18:54	11-12-2023 12:20:12	11-12-2023 12:20:12
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646573_LQFW58CL_.ARC	1	1	646573	YES	NO	NO	A	11-12-2023 12:20:12	11-12-2023 12:21:12	11-12-2023 12:21:12
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646574_LQFW71F9_.ARC	1	1	646574	YES	NO	NO	A	11-12-2023 12:21:12	11-12-2023 12:22:09	11-12-2023 12:22:09
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646575_LQFW7SGZ_.ARC	1	1	646575	YES	NO	NO	A	11-12-2023 12:22:09	11-12-2023 12:22:33	11-12-2023 12:22:33
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646576_LQFW8CL0_.ARC	1	1	646576	YES	NO	NO	A	11-12-2023 12:22:33	11-12-2023 12:22:51	11-12-2023 12:22:51
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646577_LQFW90NK_.ARC	1	1	646577	YES	NO	NO	A	11-12-2023 12:22:51	11-12-2023 12:23:12	11-12-2023 12:23:12
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646578_LQFW9OPL_.ARC	1	1	646578	YES	NO	NO	A	11-12-2023 12:23:12	11-12-2023 12:23:33	11-12-2023 12:23:33
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646579_LQFWBBRN_.ARC	1	1	646579	YES	NO	NO	A	11-12-2023 12:23:33	11-12-2023 12:23:54	11-12-2023 12:23:54
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646580_LQFWBZTP_.ARC	1	1	646580	YES	NO	NO	A	11-12-2023 12:23:54	11-12-2023 12:24:15	11-12-2023 12:24:15
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646581_LQFWD0WB_.ARC	1	1	646581	YES	NO	NO	A	11-12-2023 12:24:15	11-12-2023 12:24:48	11-12-2023 12:24:48
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646582_LQFWHM2T_.ARC	1	1	646582	YES	NO	NO	A	11-12-2023 12:24:48	11-12-2023 12:26:43	11-12-2023 12:26:43
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646583_LQFWSKHT_.ARC	1	1	646583	YES	NO	NO	A	11-12-2023 12:26:43	11-12-2023 12:32:01	11-12-2023 12:32:01
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646584_LQFX9B47_.ARC	1	1	646584	YES	NO	NO	A	11-12-2023 12:32:01	11-12-2023 12:40:26	11-12-2023 12:40:26
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646585_LQFXOZJW_.ARC	1	1	646585	YES	NO	NO	A	11-12-2023 12:40:26	11-12-2023 12:47:11	11-12-2023 12:47:11
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646586_LQFY290G_.ARC	1	1	646586	YES	NO	NO	A	11-12-2023 12:47:11	11-12-2023 12:53:44	11-12-2023 12:53:45
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646587_LQFYO4P8_.ARC	1	1	646587	YES	NO	NO	A	11-12-2023 12:53:44	11-12-2023 13:03:48	11-12-2023 13:03:48
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646588_LQFYXHYM_.ARC	1	1	646588	YES	NO	NO	A	11-12-2023 13:03:48	11-12-2023 13:08:15	11-12-2023 13:08:16
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646589_LQFZ3ZBL_.ARC	1	1	646589	YES	NO	NO	A	11-12-2023 13:08:15	11-12-2023 13:11:43	11-12-2023 13:11:43
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646590_LQFZHBV2_.ARC	1	1	646590	YES	NO	NO	A	11-12-2023 13:11:43	11-12-2023 13:17:46	11-12-2023 13:17:46
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646591_LQFZOQ5D_.ARC	1	1	646591	YES	NO	NO	A	11-12-2023 13:17:46	11-12-2023 13:21:11	11-12-2023 13:21:11
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646592_LQG02YN4_.ARC	1	1	646592	YES	NO	NO	A	11-12-2023 13:21:11	11-12-2023 13:28:14	11-12-2023 13:28:14
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646593_LQG0DC5M_.ARC	1	1	646593	YES	NO	NO	A	11-12-2023 13:28:14	11-12-2023 13:33:15	11-12-2023 13:33:15
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646594_LQG0L2DC_.ARC	1	1	646594	YES	NO	NO	A	11-12-2023 13:33:15	11-12-2023 13:36:18	11-12-2023 13:36:18
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646595_LQG0VCT2_.ARC	1	1	646595	YES	NO	NO	A	11-12-2023 13:36:18	11-12-2023 13:41:15	11-12-2023 13:41:15
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646596_LQG11D1H_.ARC	1	1	646596	YES	NO	NO	A	11-12-2023 13:41:15	11-12-2023 13:44:28	11-12-2023 13:44:28
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646597_LQG14O6H_.ARC	1	1	646597	YES	NO	NO	A	11-12-2023 13:44:28	11-12-2023 13:46:13	11-12-2023 13:46:13
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646598_LQG1FOLN_.ARC	1	1	646598	YES	NO	NO	A	11-12-2023 13:46:13	11-12-2023 13:51:01	11-12-2023 13:51:01
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646599_LQG1LXV9_.ARC	1	1	646599	YES	NO	NO	A	11-12-2023 13:51:01	11-12-2023 13:53:49	11-12-2023 13:53:49
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646600_LQG1SB6N_.ARC	1	1	646600	YES	NO	NO	A	11-12-2023 13:53:49	11-12-2023 13:57:14	11-12-2023 13:57:14
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646601_LQG24VQT_.ARC	1	1	646601	YES	NO	NO	A	11-12-2023 13:57:14	11-12-2023 14:03:23	11-12-2023 14:03:23
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646602_LQG281T9_.ARC	1	1	646602	YES	NO	NO	A	11-12-2023 14:03:23	11-12-2023 14:05:05	11-12-2023 14:05:05
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646603_LQG2C1Y1_.ARC	1	1	646603	YES	NO	NO	A	11-12-2023 14:05:05	11-12-2023 14:06:41	11-12-2023 14:06:42
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646604_LQG2D0XT_.ARC	1	1	646604	YES	NO	NO	A	11-12-2023 14:06:41	11-12-2023 14:07:12	11-12-2023 14:07:13
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646605_LQG2D62J_.ARC	1	1	646605	YES	NO	NO	A	11-12-2023 14:07:12	11-12-2023 14:07:18	11-12-2023 14:07:18
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646606_LQG2T5MD_.ARC	1	1	646606	YES	NO	NO	A	11-12-2023 14:07:18	11-12-2023 14:14:45	11-12-2023 14:14:45
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646607_LQG2XTRC_.ARC	1	1	646607	YES	NO	NO	A	11-12-2023 14:14:45	11-12-2023 14:16:42	11-12-2023 14:16:42
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646608_LQG30TXO_.ARC	1	1	646608	YES	NO	NO	A	11-12-2023 14:16:42	11-12-2023 14:18:18	11-12-2023 14:18:19
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646609_LQG3J1KT_.ARC	1	1	646609	YES	NO	NO	A	11-12-2023 14:18:18	11-12-2023 14:26:25	11-12-2023 14:26:25
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646610_LQG3YS18_.ARC	1	1	646610	YES	NO	NO	A	11-12-2023 14:26:25	11-12-2023 14:34:17	11-12-2023 14:34:17
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646611_LQG49VDC_.ARC	1	1	646611	YES	NO	NO	A	11-12-2023 14:34:17	11-12-2023 14:40:11	11-12-2023 14:40:11
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646612_LQG4OHWJ_.ARC	1	1	646612	YES	NO	NO	A	11-12-2023 14:40:11	11-12-2023 14:46:23	11-12-2023 14:46:24
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646613_LQG4YF7C_.ARC	1	1	646613	YES	NO	NO	A	11-12-2023 14:46:23	11-12-2023 14:51:09	11-12-2023 14:51:09
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646614_LQG4ZQBM_.ARC	1	1	646614	YES	NO	NO	A	11-12-2023 14:51:09	11-12-2023 14:51:51	11-12-2023 14:51:51
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646615_LQG563PV_.ARC	1	1	646615	YES	NO	NO	A	11-12-2023 14:51:51	11-12-2023 14:55:15	11-12-2023 14:55:15
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646616_LQG5FX1J_.ARC	1	1	646616	YES	NO	NO	A	11-12-2023 14:55:15	11-12-2023 14:59:25	11-12-2023 14:59:25
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646617_LQG5JG4W_.ARC	1	1	646617	YES	NO	NO	A	11-12-2023 14:59:25	11-12-2023 15:00:46	11-12-2023 15:00:46
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646618_LQG5NDCS_.ARC	1	1	646618	YES	NO	NO	A	11-12-2023 15:00:46	11-12-2023 15:02:52	11-12-2023 15:02:52
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646619_LQG5RWM8_.ARC	1	1	646619	YES	NO	NO	A	11-12-2023 15:02:52	11-12-2023 15:05:16	11-12-2023 15:05:16
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646620_LQG5V7QX_.ARC	1	1	646620	YES	NO	NO	A	11-12-2023 15:05:16	11-12-2023 15:06:31	11-12-2023 15:06:31
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646621_LQG5YT0Z_.ARC	1	1	646621	YES	NO	NO	A	11-12-2023 15:06:31	11-12-2023 15:08:25	11-12-2023 15:08:26
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646622_LQG5ZH3J_.ARC	1	1	646622	YES	NO	NO	A	11-12-2023 15:08:25	11-12-2023 15:08:47	11-12-2023 15:08:47
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646623_LQG6046K_.ARC	1	1	646623	YES	NO	NO	A	11-12-2023 15:08:47	11-12-2023 15:09:08	11-12-2023 15:09:08
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646624_LQG6129M_.ARC	1	1	646624	YES	NO	NO	A	11-12-2023 15:09:08	11-12-2023 15:09:38	11-12-2023 15:09:38
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646625_LQG63PDK_.ARC	1	1	646625	YES	NO	NO	A	11-12-2023 15:09:38	11-12-2023 15:11:02	11-12-2023 15:11:02
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646626_LQG64GG3_.ARC	1	1	646626	YES	NO	NO	A	11-12-2023 15:11:02	11-12-2023 15:11:26	11-12-2023 15:11:26
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646627_LQG653K4_.ARC	1	1	646627	YES	NO	NO	A	11-12-2023 15:11:26	11-12-2023 15:11:47	11-12-2023 15:11:47
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_11\O1_MF_1_646628_LQG66ZN1_.ARC	1	1	646628	YES	NO	NO	A	11-12-2023 15:11:47	11-12-2023 15:12:47	11-12-2023 15:12:47

--
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_08\O1_MF_1_646336_LQ6SRC7P_.ARC	1	1	646336	YES	NO	NO	A	08-12-2023 19:43:16	08-12-2023 19:57:14	08-12-2023 20:05:23
	1	1	646336	YES	NO	YES	D	08-12-2023 19:43:16	08-12-2023 19:57:14	08-12-2023 19:57:15
E:\FLASHRECOVERY\U611\ARCHIVELOG\U611\ARCHIVELOG\2023_12_08\O1_MF_1_646335_LQ6RY556_.ARC	1	1	646335	YES	NO	NO	A	08-12-2023 19:36:37	08-12-2023 19:43:16	08-12-2023 20:05:23
--
CONCLUSION: de archive-logging from the last week are still there. Per sequence only 1 row
            But for the archive-log-files from the week before we have 3 of them ...
--			

*/
  
--
select dest_name, status, destination from v$archive_dest;
LOG_ARCHIVE_DEST_1	VALID	USE_DB_RECOVERY_FILE_DEST
LOG_ARCHIVE_DEST_2	INACTIVE	
LOG_ARCHIVE_DEST_3	INACTIVE	

show parameter db_recovery_file_dest;
db_recovery_file_dest      string      E:\FlashRecovery\U611\ARCHIVELOG 
db_recovery_file_dest_size big integer 200G   

  
SHOW ALL
RMAN> show all
2> ;

RMAN configuration parameters for database with db_unique_name U611 are:
CONFIGURE RETENTION POLICY TO REDUNDANCY 1; # default
CONFIGURE BACKUP OPTIMIZATION OFF; # default
CONFIGURE DEFAULT DEVICE TYPE TO DISK; # default
CONFIGURE CONTROLFILE AUTOBACKUP OFF; # default
CONFIGURE CONTROLFILE AUTOBACKUP FORMAT FOR DEVICE TYPE DISK TO '%F'; # default
CONFIGURE DEVICE TYPE DISK PARALLELISM 1 BACKUP TYPE TO BACKUPSET; # default
CONFIGURE DATAFILE BACKUP COPIES FOR DEVICE TYPE DISK TO 1; # default
CONFIGURE ARCHIVELOG BACKUP COPIES FOR DEVICE TYPE DISK TO 1; # default
CONFIGURE CHANNEL DEVICE TYPE DISK FORMAT   'E:\BACKUP\U611\BCK_%t_%s_%p.BAK';
CONFIGURE MAXSETSIZE TO UNLIMITED; # default
CONFIGURE ENCRYPTION FOR DATABASE OFF; # default
CONFIGURE ENCRYPTION ALGORITHM 'AES128'; # default
CONFIGURE COMPRESSION ALGORITHM 'BASIC' AS OF RELEASE 'DEFAULT' OPTIMIZE FOR LOAD TRUE ; # default
CONFIGURE ARCHIVELOG DELETION POLICY TO BACKED UP 3 TIMES TO DISK;
CONFIGURE SNAPSHOT CONTROLFILE NAME TO 'C:\ORACLE\PRODUCT\11.2.0\DBHOME_1\DATABASE\SNCFU611.ORA'; # default

--full-backup-weekly
backup incremental level 0 database;
change archivelog from time 'sysdate-14' uncatalog;
delete noprompt obsolete;
catalog recovery area noprompt;
 
--CUMULATIEVE incremental-backup-daily
backup incremental level 1 database tag 'INCR LEVEL 1';


SELECT FILE#, INCREMENTAL_LEVEL, COMPLETION_TIME, BLOCKS, DATAFILE_BLOCKS 
FROM V$BACKUP_DATAFILE 
WHERE file# in (14,18, 26, 35)
--WHERE INCREMENTAL_LEVEL > 0 
--AND BLOCKS / DATAFILE_BLOCKS > .5 
ORDER BY file#, COMPLETION_TIME;
  
/*
file# incremental_level	completion_time		blocks	datafile_blocks
14		0				01-12-2023 19:52:05	4188686	4188800
14		1				02-12-2023 21:48:33	3		4188800
14		0				08-12-2023 19:59:13	4188686	4188800
14		1				08-12-2023 21:49:14	1		4188800
14		1				09-12-2023 21:48:30	2		4188800
14		1				10-12-2023 21:48:29	1		4188800
14		1				11-12-2023 21:49:31	5		4188800
--
18		0				01-12-2023 19:15:11	4189440	4194302
18		1				02-12-2023 21:39:42	7		4194302
18		0				08-12-2023 19:20:15	4189440	4194302
18		1				08-12-2023 21:39:57	1		4194302
18		1				09-12-2023 21:39:40	1		4194302
18		1				10-12-2023 21:39:41	5		4194302
18		1				11-12-2023 21:40:11	29		4194302
--
26		0				01-12-2023 19:52:05	3524227	4194176
26		1				02-12-2023 21:48:33	35		4194176
26		0				08-12-2023 19:59:14	3531128	4194176
26		1				08-12-2023 21:49:14	1		4194176
26		1				09-12-2023 21:48:30	1		4194176
26		1				10-12-2023 21:48:29	100		4194176
26		1				11-12-2023 21:49:32	1839	4194176
--
35		0				01-12-2023 19:44:20	123008	128000
35		1				02-12-2023 21:46:23	1		128000
35		0				08-12-2023 19:51:40	123008	128000
35		1				08-12-2023 21:46:54	1		128000
35		1				09-12-2023 21:46:20	1		128000
35		1				10-12-2023 21:46:20	1		128000
35		1				11-12-2023 21:47:12	1		128000

*/
 
--A recovery window is a period of time that begins with the current time and extends backward in time to the point of recoverability. 
--The point of recoverability is the earliest time for a hypothetical point-in-time recovery, that is, the earliest point to which you 
--can recover following a media failure. For example, if you implement a recovery window of one week, then this window of time must extend 
--back exactly seven days from the present so that you can restore a backup and recover it to this point. You implement this retention policy as follows:
CONFIGURE RETENTION POLICY TO RECOVERY WINDOW OF 7 DAYS;
--You can also run the following command to disable the retention policy altogether 
CONFIGURE RETENTION POLICY TO NONE;
/*
logging:
new RMAN configuration parameters:
CONFIGURE RETENTION POLICY TO NONE;
new RMAN configuration parameters are successfully stored
*/
 
 
/* 
Relationship Between Retention Policy and Flash Recovery Area Rules
The RMAN status OBSOLETE is always determined in reference to a retention policy. For example, if a database backup is OBSOLETE in the RMAN repository, 
it is because it is either not needed for recovery to a point within the recovery window, or it is redundant.
If you configure a flash recovery area, then the database uses an internal algorithm to select files in the flash recovery area that are no longer 
needed to meet the configured retention policy. These backups have status OBSOLETE, and are eligible for deletion to satisfy the disk quota rules.

There is one important difference between the flash recovery area criteria for OBSOLETE status and the disk quota rules for deletion eligibility. 
Assume that archived logs 1000 through 2000, which are on disk, are needed for the currently enabled recovery window and so are not obsolete. 
If you back up these logs to tape, then the retention policy still considers the disk logs as required, that is, not obsolete. 

Nevertheless, the flash recovery area disk quota algorithm considers the logs on disk as eligible for deletion because they have already been backed up to tape. 
The logs on disk do not have OBSOLETE status in the repository, but they are eligible for deletion by the flash recovery area. Note, though, 
that the retention policy is never violated when determining which files to delete from the flash recovery area to satisfy the disk quota rules.
*/  
  
  
select count(*) from utblob;
--50670

--***********************************************
--set logging aan !!!
RMAN> SPOOL LOG TO peter-rman-log-20231212.txt
RMAN> SPOOL LOG OFF;
--***********************************************

--***********************************************
--geef commando's
To crosscheck all backups use:
RMAN> CROSSCHECK BACKUP;

To list any expired backups detected by the CROSSCHECK command use (let op geef dit NADAT CROSSCHECK-commando is gegeven vanuit ZELFDE SESSIE !!):
RMAN> LIST EXPIRED BACKUP;

To delete any expired backups detected by the CROSSCHECK command use (let op geef dit NADAT CROSSCHECK-commando is gegeven vanuit ZELFDE SESSIE !!):
RMAN> DELETE EXPIRED BACKUP;


--***********************************************
To crosscheck all archive logs use:
RMAN> CROSSCHECK ARCHIVELOG ALL;

To list all expired archive logs detected by the CROSSCHECK command use:
RMAN> LIST EXPIRED ARCHIVELOG ALL;

To delete all expired archive logs detected by the CROSSCHECK command use:
RMAN> DELETE EXPIRED ARCHIVELOG ALL;


--***********************************************
To crosscheck all datafile image copies use:
RMAN> CROSSCHECK DATAFILECOPY ALL;

To list expired datafile copies use:
RMAN> LIST EXPIRED DATAFILECOPY ALL;

To delete expired datafile copies use:
RMAN> DELETE EXPIRED DATAFILECOPY ALL;

To crosscheck all backups of the USERS tablespace use:
RMAN> CROSSCHECK BACKUP OF TABLESPACE USERS;

To list expired backups of the USERS tablespace:
RMAN> LIST EXPIRED BACKUP OF TABLESPACE USERS;

To delete expired backups of the USERS tablespace:
RMAN> DELETE EXPIRED BACKUP OF TABLESPACE USERS;
  
  
--try to delete FULL-BCK-file from ORACLEPROD_TEST:
--Error "file is in use by process "bpbkar32.exe" ???
--Via TASK-MANAGER de processen verwijderd...
--Nieuwe FULL-backup gestart...






--start the LOGMINER
SYS AS SYSDBA@u611 >SHOW PARAMETER utl
/*
NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
utl_file_dir                         string      D:\unilink\in,D:\unilink\out,D:\unilink\err,D:\unilink\log,D:\database\U611\unarchive
*/

SYS AS SYSDBA@u611 >show parameter pfile
/*
NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
spfile                               string      C:\ORACLE\PRODUCT\11.2.0\DBHOME_1\DATABASE\SPFILEU611.ORA
*/

--welke LOGFILES in gebruik
SELECT distinct member LOGFILENAME FROM V$LOGFILE;
/*
LOGFILENAME
-------------------------------------------------------------
D:\DATABASE\U611\CTL1\U611\ONLINELOG\O1_MF_2_9JDRJW1H_.LOG
D:\DATABASE\U611\CTL2\U611\ONLINELOG\O1_MF_2_9JDRJW1Z_.LOG
D:\DATABASE\U611\CTL1\U611\ONLINELOG\O1_MF_3_9JDRJW2Y_.LOG
D:\DATABASE\U611\CTL2\U611\ONLINELOG\O1_MF_3_9JDRJW3G_.LOG
D:\DATABASE\U611\CTL1\U611\ONLINELOG\O1_MF_1_9JDRJW01_.LOG
D:\DATABASE\U611\CTL2\U611\ONLINELOG\O1_MF_1_9JDRJW0J_.LOG
*/

--One additional comment from metalink note 202159.1
--if you want to specift multiple directories in an alter system command the syntax is: ALTER SYSTEM SET UTL_FILE_DIR='directory1','directory2' scope=spfile;
SYS AS SYSDBA@u611 > alter system set utl_file_dir='D:\unilink','D:\database' scope=spfile;
SYS AS SYSDBA@u611 > alter system set utl_file_dir='D:\unilink\in','D:\unilink\out','D:\unilink\err','D:\unilink\log','D:\database\U611','D:\database\IS61' scope=spfile;
--*.utl_file_dir='D:\unilink,D:\database'
--ONLINE PARAMETER geeft nog oude waarde op!!, maar de SPFILE bevat wel de JUISTE waarde !!!!!!!
--restart DB
shutdown IMMEDIATE
startup

show parameter utl
--NU wel de juiste waarde !!!

--DBMS_LOGMNR_D.BUILD (dictionary_filename IN VARCHAR2, dictionary_location IN VARCHAR2, options IN NUMBER);
--extract logminer to redo-log-files:
--EXECUTE dbms_logmnr_d.build( options => dbms_logmnr_d.store_in_redo_logs);
--extract logminer dictionary to flat file:
exec dbms_logmnr_d.build (dictionary_filename=>'logminerU611.dat',dictionary_location=>'D:\database',options=>dbms_logmnr_d.store_in_flat_file  );
--
ALTER SYSTEM SWITCH LOGFILE;

--
execute DBMS_LOGMNR.ADD_LOGFILE ('D:\DATABASE\U611\CTL1\U611\ONLINELOG\O1_MF_1_9JDRJW01_.LOG');
execute DBMS_LOGMNR.ADD_LOGFILE ('D:\DATABASE\U611\CTL1\U611\ONLINELOG\O1_MF_2_9JDRJW1H_.LOG');
execute DBMS_LOGMNR.ADD_LOGFILE ('D:\DATABASE\U611\CTL1\U611\ONLINELOG\O1_MF_3_9JDRJW2Y_.LOG');
--Now, tell LogMiner to start. LogMiner takes the data in the operating system file logminerU611.dat and loads it into the dynamic performance views 
--used by LogMiner. One of these views is v$logmnr_contents.
--use the online data dictionairy:
EXEC DBMS_LOGMNR.START_LOGMNR ( options=>dbms_logmnr.dict_from_online_catalog);
--use flat-FILE:
--EXEC dbms_logmnr.start_logmnr ( dictFileName=>'D:\database\logminerU611.dat' );

select min(start_timestamp) from SYS.v_$logmnr_contents 
;
--CONCLUSIE: geef je geen STARTTIME mee met START_LOGMGR-commando dan krijgt deze SYSDATE !!!. Je vindt dan geen OUDE MUTATIES MEER !!!
--MAAR, MET OPTIONS=DICTIONARY, KRIJGEN WE WEL DE JUISTE TABEL/KOLOM-NAMEN IN DE LOG-TABEL TE ZIEN !!!! 
--DIT HEEFT AWS WAARSCHIJNLIJK OOK NODIG, ANDERS KAN HIJ MUTATIES VAN SPECIFIEKE TABEL NIET VINDEN !!!!!


--automatic determination of Redo-log-files
ALTER SESSION SET NLS_DATE_FORMAT='DD-MON-YYYY HH24:MI:SS';
EXECUTE DBMS_LOGMNR.START_LOGMNR( STARTTIME=>'30-Aug-2021 15:00:00', ENDTIME => '30-Aug-2021 20:00:00', options=>DBMS_LOGMNR.DICT_FROM_ONLINE_CATALOG + DBMS_LOGMNR.COMMITTED_DATA_ONLY + DBMS_LOGMNR.CONTINUOUS_MINE);
ALTER SYSTEM SWITCH LOGFILE;

--starting logminer results in the population of a view: v$logmnr_contents:
select xid, start_scn, operation, table_name, sql_undo
from SYS.v$logmnr_contents 
--where start_timestamp>=sysdate-1 
WHERE username='UNILAB' and table_name='ATDEBUG';

select count(*), username, table_name, operation
from sys.v_$logmnr_contents
group by username, table_name, operation
order by username, table_name, operation
;


SELECT sql_redo, sql_undo
FROM SYS.v_$logmnr_contents
WHERE username IN ('AWSDWH') ;

/*
Objects in LogMiner Configuration Files
DataMiner Configuration files have four objects: the source database, the mining database, the LogMiner dictionary, and the redo log files containing the data of interest.
* The source database is the database that produces all the redo log files that you want LogMiner to analyze.
* The mining database is the database that LogMiner uses when it performs the analysis.
* The LogMiner dictionary enables LogMiner to provide table and column names, instead of internal object IDs, when it presents the redo log data that you request.
    LogMiner uses the dictionary to translate internal object identifiers and data types to object names and external data formats. Without a dictionary, LogMiner returns internal object IDs, and presents data as binary data.
* The redo log files contain the changes made to the database, or to the database dictionary.

--
insert into "UNKNOWN"."OBJ# 384"("COL 1","COL 2","COL 3","COL 4","COL 5","COL 6","COL 7","COL 8","COL 9","COL 10","COL 11","COL 12","COL 13","COL 14","COL 15","COL 16","COL 17","COL 18","COL 19","COL
20","COL 21","COL 22","COL 23","COL 24","COL 25","COL 26","COL 27","COL 28","COL 29","COL 30","COL 31","COL 32","COL 33","COL 34","COL 35","COL 36","COL 37","COL 38","COL 39","COL 40","COL 41","COL 42
") values (HEXTORAW('c50213404d61'),HEXTORAW('c102'),HEXTORAW('c102'),NULL,HEXTORAW('415753445748'),HEXTORAW('69702d3137322d32332d312d313333'),NULL,HEXTORAW('c202'),HEXTORAW('80'),NULL,NULL,NULL,NULL,
NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,HEXTORAW('41757468656e746963617465642062793a2044415441424153453b20436c69656e7420616464726573733a2028414444524553533d2850524f544f434f4c3d7463702928484f53543
d31302e3130322e312e38372928504f52543d34343132302929'),NULL,HEXTORAW('7264736462'),NULL,NULL,NULL,HEXTORAW('c106'),NULL,HEXTORAW('7879081f123c24119557c0'),NULL,NULL,HEXTORAW('80'),HEXTORAW('323934303a3
6303732'),HEXTORAW('0000000000000000'),NULL,NULL,HEXTORAW('c51109203b54'),HEXTORAW(''),HEXTORAW(''),NULL);
delete from "UNKNOWN"."OBJ# 384" where "COL 1" = HEXTORAW('c50213404d61') and "COL 2" = HEXTORAW('c102') and "COL 3" = HEXTORAW('c102') and "COL 4" IS NULL and "COL 5" = HEXTORAW('415753445748') and "
COL 6" = HEXTORAW('69702d3137322d32332d312d313333') and "COL 7" IS NULL and "COL 8" = HEXTORAW('c202') and "COL 9" = HEXTORAW('80') and "COL 10" IS NULL and "COL 11" IS NULL and "COL 12" IS NULL and "
COL 13" IS NULL and "COL 14" IS NULL and "COL 15" IS NULL and "COL 16" IS NULL and "COL 17" IS NULL and "COL 18" IS NULL and "COL 19" IS NULL and "COL 20" IS NULL and "COL 21" IS NULL and "COL 22" IS
NULL and "COL 23" = HEXTORAW('41757468656e746963617465642062793a2044415441424153453b20436c69656e7420616464726573733a2028414444524553533d2850524f544f434f4c3d7463702928484f53543d31302e3130322e312e383729
28504f52543d34343132302929') and "COL 24" IS NULL and "COL 25" = HEXTORAW('7264736462') and "COL 26" IS NULL and "COL 27" IS NULL and "COL 28" IS NULL and "COL 29" = HEXTORAW('c106') and "COL 30" IS N
ULL and "COL 31" = HEXTORAW('7879081f123c24119557c0') and "COL 32" IS NULL and "COL 33" IS NULL and "COL 34" = HEXTORAW('80') and "COL 35" = HEXTORAW('323934303a36303732') and "COL 36" = HEXTORAW('000
0000000000000') and "COL 37" IS NULL and "COL 38" IS NULL and "COL 39" = HEXTORAW('c51109203b54') and "COL 40" = HEXTORAW('') and "COL 41" = HEXTORAW('') and "COL 42" IS NULL and ROWID = 'AAAAAAAAAAAA
AAAAAA';

update "UNKNOWN"."OBJ# 384" set "COL 40" = NULL, "COL 41" = NULL where "COL 1" = HEXTORAW('c50213404d61') and "COL 2" = HEXTORAW('c102') and "COL 3" = HEXTORAW('c102') and "COL 4" IS NULL and "COL 5"
= HEXTORAW('415753445748') and "COL 6" = HEXTORAW('69702d3137322d32332d312d313333') and "COL 7" IS NULL and "COL 8" = HEXTORAW('c202') and "COL 9" = HEXTORAW('80') and "COL 10" IS NULL and "COL 11" IS
 NULL and "COL 12" IS NULL and "COL 13" IS NULL and "COL 14" IS NULL and "COL 15" IS NULL and "COL 16" IS NULL and "COL 17" IS NULL and "COL 18" IS NULL and "COL 19" IS NULL and "COL 20" IS NULL and "
COL 21" IS NULL and "COL 22" IS NULL and "COL 23" = HEXTORAW('41757468656e746963617465642062793a2044415441424153453b20436c69656e7420616464726573733a2028414444524553533d2850524f544f434f4c3d746370292848
4f53543d31302e3130322e312e38372928504f52543d34343132302929') and "COL 24" IS NULL and "COL 25" = HEXTORAW('7264736462') and "COL 26" IS NULL and "COL 27" IS NULL and "COL 28" IS NULL and "COL 29" = HE
XTORAW('c106') and "COL 30" IS NULL and "COL 31" = HEXTORAW('7879081f123c24119557c0') and "COL 32" IS NULL and "COL 33" IS NULL and "COL 34" = HEXTORAW('80') and "COL 35" = HEXTORAW('323934303a3630373
2') and "COL 36" = HEXTORAW('0000000000000000') and "COL 37" IS NULL and "COL 38" IS NULL and "COL 39" = HEXTORAW('c51109203b54') and ROWID = 'AAAAGAAABAAGaYoAAb';
update "UNKNOWN"."OBJ# 384" set "COL 40" = NULL, "COL 41" = NULL where "COL 1" = HEXTORAW('c50213404d61') and "COL 2" = HEXTORAW('c102') and "COL 3" = HEXTORAW('c102') and "COL 4" IS NULL and "COL 5"
= HEXTORAW('415753445748') and "COL 6" = HEXTORAW('69702d3137322d32332d312d313333') and "COL 7" IS NULL and "COL 8" = HEXTORAW('c202') and "COL 9" = HEXTORAW('80') and "COL 10" IS NULL and "COL 11" IS
 NULL and "COL 12" IS NULL and "COL 13" IS NULL and "COL 14" IS NULL and "COL 15" IS NULL and "COL 16" IS NULL and "COL 17" IS NULL and "COL 18" IS NULL and "COL 19" IS NULL and "COL 20" IS NULL and "
COL 21" IS NULL and "COL 22" IS NULL and "COL 23" = HEXTORAW('41757468656e746963617465642062793a2044415441424153453b20436c69656e7420616464726573733a2028414444524553533d2850524f544f434f4c3d746370292848
4f53543d31302e3130322e312e38372928504f52543d34343132302929') and "COL 24" IS NULL and "COL 25" = HEXTORAW('7264736462') and "COL 26" IS NULL and "COL 27" IS NULL and "COL 28" IS NULL and "COL 29" = HE
XTORAW('c106') and "COL 30" IS NULL and "COL 31" = HEXTORAW('7879081f123c24119557c0') and "COL 32" IS NULL and "COL 33" IS NULL and "COL 34" = HEXTORAW('80') and "COL 35" = HEXTORAW('323934303a3630373
2') and "COL 36" = HEXTORAW('0000000000000000') and "COL 37" IS NULL and "COL 38" IS NULL and "COL 39" = HEXTORAW('c51109203b54') and ROWID = 'AAAAGAAABAAGaYoAAb';

commit;
*/




--remove redo-log-file
--Removes a redo log file from an existing list of redo log files for LogMiner to process
exec dbms_logmnr.remove_logfile(LogFileName=>'D:\DATABASE\U611\CTL1\U611\ONLINELOG\O1_MF_1_9JDRJW01_.LOG');
exec dbms_logmnr.remove_logfile(LogFileName=>'D:\DATABASE\U611\CTL1\U611\ONLINELOG\O1_MF_2_9JDRJW1H_.LOG');
exec dbms_logmnr.remove_logfile(LogFileName=>'D:\DATABASE\U611\CTL1\U611\ONLINELOG\O1_MF_3_9JDRJW2Y_.LOG');


--stop logminer
exec dbms_logmnr.end_logmnr;


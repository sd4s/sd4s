--descr-commando duurt erg lang...
descr all_objects;

--select distinct object_type  from sys.all_objects  where UPPER(object_name) =UPPER('all_objects')and OBJECT_TYPE ='SYNONYM'
--select table_owner ,table_name, db_link from all_synonyms where  synonym_name = UPPER('all_objects') and (UPPER(owner)= UPPER(sys_context('USERENV', 'CURRENT_USER')) )
--select table_owner ,table_name, db_link from all_synonyms where  synonym_name = UPPER('all_objects') and ( owner = 'PUBLIC')

EXEC DBMS_STATS.GATHER_SCHEMA_STATS ('SYS');
exec DBMS_STATS.GATHER_DATABASE_STATS (gather_sys=>TRUE);
EXEC DBMS_STATS.GATHER_DICTIONARY_STATS;
--Gather_fixed_objects_stats also gathers statistics for dynamic tables, e.g. the X$ tables which loaded in SGA during the startup. 
--Gathering statistics for fixed objects would normally be recommended if poor performance is encountered while querying dynamic views ,
--e.g. V$ views. Since fixed objects record current database activity, statistics gathering should be done when database has a 
--representative load so that the statistics reflect the normal database activity.
exec DBMS_STATS.GATHER_FIXED_OBJECTS_STATS;
--
select OWNER, TABLE_NAME, LAST_ANALYZED from dba_tab_statistics where table_name='X$KEWRATTRNEW';


exec DBMS_STATS.GATHER_TABLE_STATS ('SYS', 'X$KZSPR') ;
exec DBMS_STATS.GATHER_TABLE_STATS ('SYS', 'X$KZSRO') ;


alter session set nls_date_format='YYYY-Mon-DD';
col last_analyzed for a13
set termout off
set trimspool off
set feedback off

spool dictionary_statistics

prompt 'Statistics for SYS tables'
SELECT NVL(TO_CHAR(last_analyzed, 'YYYY-Mon-DD'), 'NO STATS') last_analyzed, COUNT(*) dictionary_tables
FROM dba_tables
WHERE owner = 'SYS'
GROUP BY TO_CHAR(last_analyzed, 'YYYY-Mon-DD')
ORDER BY 1 DESC;

prompt 'Statistics for Fixed Objects'
select NVL(TO_CHAR(last_analyzed, 'YYYY-Mon-DD'), 'NO STATS') last_analyzed, COUNT(*) fixed_objects
FROM dba_tab_statistics
WHERE object_type = 'FIXED TABLE'
GROUP BY TO_CHAR(last_analyzed, 'YYYY-Mon-DD')
ORDER BY 1 DESC;

spool off





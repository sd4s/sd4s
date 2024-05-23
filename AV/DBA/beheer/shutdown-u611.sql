PROMPT SCRIPT SHUTDOWN-U611 UITVOEREN ALS USER SYS !!!!

spool E:\DBA\log-dba-db-shutdown-U611.log
alter session set nls_date_format="dd-mm-yyyy hh24:mi:ss";
select user, sysdate from dual;

prompt
prompt Stopzetten van de UNILAB.JOBS
prompt

ALTER SESSION SET CURRENT_SCHEMA=UNILAB;
--
select 'VOOR stopzetten jobs: '|| to_char(systimestamp,'dd-mm-yyyy hh24:mi:ss.FF') as ts from dual;
exec UNILAB.CXAPP.stopalldbjobs;
select 'NA stopzetten jobs: '|| to_char(systimestamp,'dd-mm-yyyy hh24:mi:ss.FF') as ts from dual;

--controle jobs ALS scheduled-jobs
--let op: DE UNILAB-jobs WEL scheduled-jobs (in tegenstelling tot INTERSPEC-jobs dat zijn DBMS_JOBS !!
set pages 999
set linesize 300
--
prompt
prompt overzicht AANWEZIGE-JOBS:
prompt
SELECT JOB_NAME, STATE, ENABLED, NEXT_RUN_DATE 
FROM USER_SCHEDULER_JOBS 
;

ALTER SESSION SET CURRENT_SCHEMA=SYS;

prompt
prompt Shutdown database
prompt 

select 'VOOR shutdown DB-U611: '|| to_char(systimestamp,'dd-mm-yyyy hh24:mi:ss.FF') as ts from dual;
SHUTDOWN IMMEDIATE;

prompt 
prompt einde script shutdown-u611
prompt

spool off;

exit;



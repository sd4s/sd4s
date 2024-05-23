PROMPT SCRIPT SHUTDOWN-U611 UITVOEREN ALS USER SYS !!!!

spool E:\DBA\log-dba-db-shutdown-IS61.log
alter session set nls_date_format="dd-mm-yyyy hh24:mi:ss";
select user, sysdate from dual;


prompt
prompt Stopzetten van de INTERSPC.JOBS
prompt

ALTER SESSION SET CURRENT_SCHEMA=INTERSPC;

select 'VOOR stopzetten jobs: '|| to_char(systimestamp,'dd-mm-yyyy hh24:mi:ss.FF') as ts from dual;
exec INTERSPC.AAPIUTILS.stopalldbjobs;
select 'NA stopzetten jobs: '|| to_char(systimestamp,'dd-mm-yyyy hh24:mi:ss.FF') as ts from dual;

--controle jobs ALS scheduled-jobs
--let op: DE INTERSPEC-jobs zijn (in tegenstelling tot UNILAB-jobs) GEEN scheduled-jobs, maar zijn DBMS_JOBS !!
set pages 999
set linesize 300
column what format a50
column log_user format a10
column priv_user format a10
column schema_user format a10
column last_date format a20
column next_date format a20
--select job, what, log_user, priv_user, schema_user, to_char(last_date,'dd-mm-yyyy hh24:mi:ss') , to_char(next_date,'dd-mm-yyyy hh24:mi:ss'), broken, failures, nls_env, instance
prompt
prompt overzicht NOG-AANWEZIGE-JOBS:
prompt
select job, what, log_user, priv_user, schema_user, to_char(last_date,'dd-mm-yyyy hh24:mi:ss') last_date, to_char(next_date,'dd-mm-yyyy hh24:mi:ss') next_date, broken, failures, instance
from user_jobs
order by job
;

ALTER SESSION SET CURRENT_SCHEMA=SYS;


prompt
prompt Shutdown database
prompt 

select 'VOOR shutdown DB-IS61: '|| to_char(systimestamp,'dd-mm-yyyy hh24:mi:ss.FF') as ts from dual;
SHUTDOWN IMMEDIATE;


prompt 
prompt einde script shutdown-is61
prompt

spool off;

exit;



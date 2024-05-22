--conn interspc/moonflower@is61
PROMPT SCRIPT JOBS-INTERSPEC-START UITVOEREN ALS USER SYS !!!!

spool E:\DBA\jobs\log_jobs_interspec_start.log
alter session set nls_date_format="dd-mm-yyyy hh24:mi:ss";
select user, sysdate from dual;

prompt
prompt Starten van de INTERSPC.JOBS
prompt

--ALTER SESSION SET CURRENT_SCHEMA=INTERSPC;
set serveroutput on
select 'VOOR starten jobs: '|| to_char(systimestamp,'dd-mm-yyyy hh24:mi:ss.FF') as ts from dual;
exec INTERSPC.AAPIUTILS.startalldbjobs;
exec INTERSPC.SET_JOBS;
select 'NA starten jobs: '|| to_char(systimestamp,'dd-mm-yyyy hh24:mi:ss.FF') as ts from dual;

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
prompt overzicht AANWEZIGE-JOBS na START alle INTERSPEC-JOBS:
prompt
select job, what, log_user, priv_user, schema_user, to_char(last_date,'dd-mm-yyyy hh24:mi:ss') last_date, to_char(next_date,'dd-mm-yyyy hh24:mi:ss') next_date, broken, failures, instance
from user_jobs
order by job
;

prompt 
prompt einde script start-jobs-interspec
prompt

spool off;

exit;





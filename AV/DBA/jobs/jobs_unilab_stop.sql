--conn unilab/moonflower@u611

PROMPT SCRIPT JOBS-UNILAB-STOP UITVOEREN ALS USER SYS !!!!

spool E:\DBA\jobs\log_jobs_unilab_stop.log
alter session set nls_date_format="dd-mm-yyyy hh24:mi:ss";
select user, sysdate from dual;

prompt
prompt Stoppen van de UNILAB.JOBS
prompt

--ALTER SESSION SET CURRENT_SCHEMA=UNILAB;

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


prompt 
prompt einde script stop-jobs-UNILAB
prompt

spool off;

exit;



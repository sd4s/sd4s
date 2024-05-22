--cxapp.startalldbjobs 

spool E:\DBA\jobs\log_jobs_unilab_apaofea_start.log
alter session set nls_date_format="dd-mm-yyyy hh24:mi:ss";
select user, sysdate from dual;

set serveroutput on

--
BEGIN 
  StartAPAOFEA;
END;
/


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
prompt overzicht AANWEZIGE-JOBS na STOPPEN van 2x PA-LIMSinterface-JOBS:
prompt
SELECT JOB_NAME, STATE, ENABLED, NEXT_RUN_DATE 
FROM USER_SCHEDULER_JOBS 
;

prompt einde script

spool off;


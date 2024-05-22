--AAPIUTILS.startalldbjobs :
--
--pa_LimsInterface.f_StartInterface()
--roept aan:
--   pa_limsinterface.p_transfercfgandspc;
--   pa_limsspc.f_transferallhistobs;

--aanzetten weer via: pa_LimsInterface.f_StartInterface()

--conn interspc/moonflower@is61
PROMPT SCRIPT JOBS-PALIMSINTERSPEC-START UITVOEREN ALS USER INTERSPC !!!!

spool E:\DBA\jobs\log_jobs_interspec_palimsinterface_start.log
alter session set nls_date_format="dd-mm-yyyy hh24:mi:ss";
select user, sysdate from dual;


set serveroutput on
--
declare
l_result number;
begin
  l_result := pa_LimsInterface.f_StartInterface();
 --dbms_output.put_line('result: '||l_result);
 dbms_output.put_line('pa_LimsInterface result: '||l_result||':'|| NVL(NULLIF(TO_CHAR(l_result), 1), 'Success'));
end;
/

--controle jobs na STARTEN van LIMS-jobs:
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
prompt overzicht AANWEZIGE-JOBS na STARTEN van 2x PA-LIMSinterface-JOBS:
prompt
select job, what, log_user, priv_user, schema_user, to_char(last_date,'dd-mm-yyyy hh24:mi:ss') last_date, to_char(next_date,'dd-mm-yyyy hh24:mi:ss') next_date, broken, failures, instance
from user_jobs
order by job
;


prompt einde script

spool off;

exit;






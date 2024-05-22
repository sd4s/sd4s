--PA_LIMSINTERFACE

--conn interspc/moonflower@is61
PROMPT SCRIPT JOBS-INTERSPEC-PALIMSINTERFACE-RESTART UITVOEREN ALS USER interspc !!!!

spool E:\DBA\jobs\log_jobs_interspec_palimsinterface_restart.log
alter session set nls_date_format="dd-mm-yyyy hh24:mi:ss";
select user, sysdate from dual;

set serveroutput on
--
declare
l_result number;
begin
  l_result := pa_LimsInterface.f_StopInterface();
 --dbms_output.put_line('result: '||l_result);
 dbms_output.put_line('pa_LimsInterface result: '||l_result||':'|| NVL(NULLIF(TO_CHAR(l_result), 1), 'Success'));
end;
/

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
prompt overzicht AANWEZIGE-JOBS na STOPPEN van de 2x PA-LIMSinterface-JOBS:
prompt
select job, what, log_user, priv_user, schema_user, to_char(last_date,'dd-mm-yyyy hh24:mi:ss') last_date, to_char(next_date,'dd-mm-yyyy hh24:mi:ss') next_date, broken, failures, instance
from user_jobs
order by job
;


--START-PA-LIMSinterface-jobs
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

--controle jobs na HERSTART:
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
prompt overzicht AANWEZIGE-JOBS na HERSTART :
prompt
select job, what, log_user, priv_user, schema_user, to_char(last_date,'dd-mm-yyyy hh24:mi:ss') last_date, to_char(next_date,'dd-mm-yyyy hh24:mi:ss') next_date, broken, failures, instance
from user_jobs
order by job
;


prompt einde script

spool off;

exit;






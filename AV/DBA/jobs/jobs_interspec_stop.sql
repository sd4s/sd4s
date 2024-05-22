--conn interspc/moonflower@is61
PROMPT SCRIPT JOBS-INTERSPEC-STOP UITVOEREN ALS USER SYS !!!!

spool E:\DBA\jobs\log_jobs_interspec_stop.log

alter session set nls_date_format="dd-mm-yyyy hh24:mi:ss";
select user, sysdate from dual;

prompt
prompt Stoppen van de INTERSPC.JOBS
prompt

select 'VOOR stoppen jobs: '|| to_char(systimestamp,'dd-mm-yyyy hh24:mi:ss.FF') as ts from dual;
exec INTERSPC.AAPIUTILS.stopalldbjobs;
exec INTERSPC.DBA_REMOVE_SET_JOBS;
select 'NA stoppen jobs: '|| to_char(systimestamp,'dd-mm-yyyy hh24:mi:ss.FF') as ts from dual;


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
--
prompt
prompt INTERSPEC-JOBS nadat ALLE JOBS gestopped zijn:
prompt
select job, what, log_user, priv_user, schema_user, to_char(last_date,'dd-mm-yyyy hh24:mi:ss') last_date, to_char(next_date,'dd-mm-yyyy hh24:mi:ss') next_date, broken, failures, instance
from user_jobs
order by job
;

--not ok
/* 
Er zijn 4 jobs die gewoon blijven lopen...Zitten dus NIET in de stopalljobs!!!!

  JOB WHAT
----- -----------------------------------------------
 1254 iapiDeletion.RemoveObsoleteData;
 1256 sp_approve_blocked_spec;                   --> Deze had failures !! Handmatig gestopped!!!
 1257 iapiCheckProcessing.CheckProcessing(1);
 1273 aapiJob.ProcessJobQueue;
*/
/*
  JOB WHAT                                               LOG_USER   PRIV_USER  SCHEMA_USE LAST_DATE            NEXT_DATE            B   FAILURES
----- -------------------------------------------------- ---------- ---------- ---------- -------------------- -------------------- - ----------
 1254 iapiDeletion.RemoveObsoleteData;                   INTERSPC   INTERSPC   INTERSPC   25-10-2020 00:00:03  26-10-2020 00:00:00  N          0
 1256 sp_approve_blocked_spec;                           INTERSPC   INTERSPC   INTERSPC                01-01-4000 00:00:00  Y         17
 1257 iapiCheckProcessing.CheckProcessing(1);            INTERSPC   INTERSPC   INTERSPC   25-10-2020 00:00:03  26-10-2020 00:00:00  N          0
 1273 aapiJob.ProcessJobQueue;                           INTERSPC   INTERSPC   INTERSPC   25-10-2020 12:07:14  25-10-2020 12:08:14  N          0
 1769 DECLARE lnRetVal iapiType.ErrorNum_Type; BEGIN lnR INTERSPC   INTERSPC   INTERSPC                25-10-2020 12:07:14  N
      etVal := iapiEmail.SendEmails; END;

 1770 iapiSpecDataServer.RunSpecServer('SPEC_SERVER' ) ; INTERSPC   INTERSPC   INTERSPC   25-10-2020 12:07:24  25-10-2020 12:07:34  N          0
 1771 iapiQueue.ExecuteQueue;                            INTERSPC   INTERSPC   INTERSPC                25-10-2020 12:07:14  N
 1772 pa_limsinterface.p_transfercfgandspc;              INTERSPC   INTERSPC   INTERSPC                25-10-2020 12:07:14  N
 1773 pa_limsspc.f_transferallhistobs;                   INTERSPC   INTERSPC   INTERSPC   25-10-2020 12:07:14  26-10-2020 04:00:00  N          0
 */
 
 

prompt 
prompt einde script stop-jobs-interspec
prompt

spool off;

exit;




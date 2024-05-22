--cxapp.stopalldbjobs
set serveroutput on
--
declare
l_result number;
begin
 l_result := UNAPIEV.StopAllMgrs;
 dbms_output.put_line('result: '||l_result);
end;
/


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


--cxapp.startalldbjobs 
set serveroutput on
--
declare
l_result number;
begin
 l_result := UNAPIEV.StartAllMgrs;
 dbms_output.put_line('result: '||l_result);
end;
/

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




prompt einde script







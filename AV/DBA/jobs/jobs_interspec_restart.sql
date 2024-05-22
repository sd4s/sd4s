--conn interspc/moonflower@is61
spool E:\DBA\jobs\log-dba-restart-jobs-interspec.log

ALTER SESSION SET CURRENT_SCHEMA=INTERSPC;
select user, sysdate from dual;
--
prompt voor restart-interspec-jobs
--restart voert normaal een stopalljobs/startalljobs uit.
exec INTERSPC.AAPIUTILS.restartalldbjobs;
--set-jobs removed de jobs en submit ze direct erna weer 
exec INTERSPC.SET_JOBS;
prompt na restart-interspec-jobs
exit;

spool off;
/*
--
-- of:
--
exec INTERSPC.AAPIUTILS.stopalldbjobs;
exec INTERSPC.AAPIUTILS.startalldbjobs;
exec INTERSPC.SET_JOBS;
*/

prompt 
prompt einde script
prompt

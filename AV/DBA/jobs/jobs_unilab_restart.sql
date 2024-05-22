--conn unilab/moonflower@u611
spool E:\DBA\jobs\log-dba-restart-jobs-unilab.log
--
ALTER SESSION SET CURRENT_SCHEMA=UNILAB;
select user, sysdate from dual;
--
prompt voor restart-unilab-jobs
exec UNILAB.CXAPP.restartalldbjobs;
prompt na restart-unilab-jobs
exit;

spool off;

/*
--
-- of handmatig:
--
exec UNILAB.CXAPP.stopalldbjobs;
exec UNILAB.CXAPP.startalldbjobs;
*/

prompt 
prompt einde script
prompt

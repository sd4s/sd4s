PROMPT SCRIPT STARTUP-REPM UITVOEREN ALS USER SYS !!!!

spool E:\DBA\log-dba-db-startup-REPM.log
--alter session set nls_date_format="dd-mm-yyyy hh24:mi:ss";
--select user, sysdate from dual;

prompt
prompt STARTUP database
prompt 

STARTUP;
select 'NA startup DB-REPM: ' || to_char(systimestamp,'dd-mm-yyyy hh24:mi:ss.FF') as ts from dual;

prompt 
prompt einde script shutdown-repm
prompt

spool off;

exit;


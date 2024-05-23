PROMPT SCRIPT STARTUP-U611 UITVOEREN ALS USER SYS !!!!

spool E:\DBA\log-dba-db-startup-U611.log
--alter session set nls_date_format="dd-mm-yyyy hh24:mi:ss";
--select user, sysdate from dual;

prompt
prompt STARTUP database
prompt 

STARTUP;
select 'NA start DB-U611: ' || to_char(systimestamp,'dd-mm-yyyy hh24:mi:ss.FF') as ts from dual;

prompt 
prompt einde script startup-U611
prompt

spool off;

exit;


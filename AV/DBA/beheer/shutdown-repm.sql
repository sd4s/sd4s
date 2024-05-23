PROMPT SCRIPT SHUTDOWN-REPM UITVOEREN ALS USER SYS !!!!

spool E:\DBA\log-dba-db-shutdown-REPM.log
alter session set nls_date_format="dd-mm-yyyy hh24:mi:ss";
select user, sysdate from dual;

prompt
prompt Shutdown database
prompt 

select 'VOOR shutdown DB-REPM: '|| to_char(systimestamp,'dd-mm-yyyy hh24:mi:ss.FF') as ts from dual;
SHUTDOWN IMMEDIATE;

prompt 
prompt einde script shutdown-repm
prompt


spool off;

exit;


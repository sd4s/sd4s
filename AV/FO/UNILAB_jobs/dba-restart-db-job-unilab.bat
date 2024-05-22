prompt Restart JOBS
prompt Dit script wordt gebruikt als SERVICE om alle UNILAB-jobs te HERSTARTEN 
prompt nadat de database down geweest is, en opnieuw gestart is.
prompt

PROMPT restart-jobs-unilab
sqlplus sys/moonflower@U611 as sysdba @restart_jobs_unilab.sql
pause


rem
rem einde script
rem


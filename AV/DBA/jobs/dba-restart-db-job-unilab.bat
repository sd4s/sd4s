REM Restart JOBS
REM Dit script wordt gebruikt als SERVICE om alle UNILAB-jobs te HERSTARTEN 
REM nadat de database down geweest is, en opnieuw gestart is.

REM restart-jobs-unilab
REM sqlplus sys/moonflower@U611 as sysdba @E:\DBA\restart_jobs_unilab.sql
sqlplus UNILAB/moonflower@U611 @E:\DBA\restart_jobs_unilab.sql
pause

rem
rem einde script
rem


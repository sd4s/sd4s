REM Restart JOBS
REM Dit script wordt gebruikt als SERVICE om alle UNILAB-jobs te HERSTARTEN 
REM nadat de database down geweest is, en opnieuw gestart is.


REM  *************************************
REM  STOPPEN VAN JOBS
REM  *************************************

REM  stop-jobs-interspec
sqlplus interspc/moonflower@U611 @E:\DBA\jobs\jobs_interspec_stop.sql
rem pause

REM  stop-jobs-unilab
sqlplus UNILAB/moonflower@U611 @E:\DBA\jobs\jobs_unilab_stop.sql
rem pause



REM  *************************************
REM  seletie VAN resterende JOBS
REM  *************************************

REM  start jobs unilab
sqlplus UNILAB/moonflower@U611 @E:\DBA\jobs\jobs_unilab_select.sql
REM pause

REM  start jobs interspec
sqlplus INTERSPC/moonflower@U611 @E:\DBA\jobs\jobs_interspec_select.sql
REM pause


rem einde script
rem


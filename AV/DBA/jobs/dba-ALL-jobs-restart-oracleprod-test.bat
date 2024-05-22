REM Restart JOBS
REM Dit script wordt gebruikt als SERVICE om alle UNILAB-jobs te HERSTARTEN 
REM nadat de database down geweest is, en opnieuw gestart is.


REM  *************************************
REM  STOPPEN VAN JOBS
REM  *************************************

REM  stop-jobs-interspec
sqlplus interspc/stardust2021av@U611 @E:\DBA\jobs\jobs_interspec_stop.sql
rem pause

REM  stop-jobs-unilab
sqlplus UNILAB/stardust2021av@U611 @E:\DBA\jobs\jobs_unilab_stop.sql
rem pause



REM  *************************************
REM  STARTEN VAN JOBS
REM  *************************************

REM  start jobs unilab
sqlplus UNILAB/stardust2021av@U611 @E:\DBA\jobs\jobs_unilab_start.sql
REM pause

REM  start jobs interspec
sqlplus interspc/stardust2021av@U611 @E:\DBA\jobs\jobs_interspec_start.sql
REM pause


rem einde script
rem


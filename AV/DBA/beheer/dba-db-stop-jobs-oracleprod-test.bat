rem Script om de 3-oracle-databases te stoppen

rem Windows-services oracle:
rem 1) OracleServiceIS61
rem 2) OracleServiceREPM
rem 3) OracleServiceU611


REM 1) STOP DB-JOBS (STOP eerst INTERSPEC en daarna pas UNILAB !!!)

REM stop-jobs-interspc 
rem sqlplus INTERSPC/stardust2021@IS61 @E:\DBA\jobs\jobs_interspec_stop.sql
sqlplus INTERSPC/stardust2021av@IS61 @E:\DBA\jobs\jobs_interspec_stop.sql
pause
REM stop-jobs-unilab
rem sqlplus UNILAB/stardust2021@U611 @E:\DBA\jobs\jobs_unilab_stop.sql
sqlplus UNILAB/stardust2021av@U611 @E:\DBA\jobs\jobs_unilab_stop.sql
pause

REM stop-jobs-repm
rem geen repm-jobs aanwezig


REM  einde script
 

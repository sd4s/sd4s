rem Script om de 3-oracle-databases te stoppen

rem Windows-services oracle:
rem 1) OracleServiceIS61
rem 2) OracleServiceREPM
rem 3) OracleServiceU611


REM 1) STOP DB-JOBS  (STOP eerst INTERSPEC-jobs, en daarna pas UNILAB-jobs)

REM stop-jobs-interspc 
sqlplus INTERSPC/moonflower@IS61 @E:\DBA\jobs\jobs_interspec_stop.sql
pause
REM stop-jobs-unilab
sqlplus UNILAB/moonflower@U611 @E:\DBA\jobs\jobs_unilab_stop.sql
pause

REM stop-jobs-repm
rem geen repm-jobs aanwezig


REM  einde script
 

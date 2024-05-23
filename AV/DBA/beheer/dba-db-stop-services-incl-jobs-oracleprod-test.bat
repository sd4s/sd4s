rem Script om de 3-oracle-databases te stoppen

rem Windows-services oracle:
rem 1) OracleServiceIS61
rem 2) OracleServiceREPM
rem 3) OracleServiceU611


REM 1) STOP DB-JOBS  (STOP eerst INTERSPEC en daarna pas UNILAB !!!)

REM stop-jobs-interspc 
sqlplus INTERSPC/stardust2021av@IS61 @E:\DBA\jobs\jobs_interspec_stop.sql
rem sqlplus INTERSPC/moonflower@IS61 @E:\DBA\jobs\jobs_interspec_stop.sql
pause
REM stop-jobs-unilab
sqlplus UNILAB/stardust2021av@U611 @E:\DBA\jobs\jobs_unilab_stop.sql
rem sqlplus UNILAB/moonflower@U611 @E:\DBA\jobs\jobs_unilab_stop.sql
pause


REM 2) SHUTDOWN DB
REM (eerst INTERSPC en dan UNILAB, omdat de db-link vanuit INTERSPEC naar UNILAB gaat.)

REM stop database REPM-REPM
sqlplus sys/moonflower@REPM as sysdba @E:\DBA\shutdown-repm.sql
pause
REM stop database INTERPC-IS61
sqlplus sys/moonflower@IS61 as sysdba @E:\DBA\shutdown-is61.sql
pause
REM stop database UNLIAB-U611
sqlplus sys/moonflower@U611 as sysdba @E:\DBA\shutdown-u611.sql
pause


REM  einde script
 

rem Script om de 3-oracle-databases te starten 
rem (evt. na reboot van server mocht blijken dat deze niet automatisch gestart worden...)

rem Windows-services oracle:
rem 1) OracleServiceIS61
rem 2) OracleServiceREPM
rem 3) OracleServiceU611


REM WE GAAN ER VAN UIT DAT DB-JOBS NETJES VOOR DE SHUTDOWN ZIJN GESTOPT, 
REM ZODAT WE ZONDER PROBLEMEN DE DATABASES KUNNEN STARTEN


REM  start database UNLIAB-U611
REM (let op: Eerst UNILAB en daarna pas INTERSPEC, omdat er dynamische DB-link vanuit INTERSPEC naar UNILAB loopt)
sqlplus sys/moonflower@U611 as sysdba @E:\DBA\startup-u611.sql
pause
REM  start database INTERPC-IS61
sqlplus sys/moonflower@IS61 as sysdba @E:\DBA\startup-is61.sql
pause
REM  start database REPM-REPM
sqlplus sys/moonflower@REPM as sysdba @E:\DBA\startup-repm.sql
pause


REM start JOBS (START eerst UNILAB-jobs en daarna pas INTERSPEC-jobs)

REM start-jobs-unilab
sqlplus UNILAB/moonflower@U611 @E:\DBA\jobs\jobs_unilab_start.sql
pause

REM start-jobs-interspc
sqlplus INTERSPC/moonflower@IS61 @E:\DBA\jobs\jobs_interspec_start.sql
pause

REM restart-jobs-repm
REM no repm-jobs to start...


REM einde script



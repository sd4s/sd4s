rem Script om de 3-oracle-databases te starten 
rem (evt. na reboot van server mocht blijken dat deze niet automatisch gestart worden...)
rem

rem Windows-services oracle:
rem 1) OracleServiceIS61
rem 2) OracleServiceREPM
rem 3) OracleServiceU611


REM WE GAAN ER VAN UIT DAT DB-JOBS NETJES (evt. VOOR EEN SHUTDOWN) ZIJN GESTOPT, 
REM ZODAT WE ZONDER PROBLEMEN DE DATABASES KUNNEN STARTEN
REM
REM BIJ STARTEN VAN DE SERVER KOMEN DE DATABASES AUTOMATISCH WEER OP MBV WINDOWS-SERVICES.
REM DE JOBS MOETEN DAN HANDMATIG NOG WORDEN GESTART...

REM Restart JOBS

REM restart-jobs-interspc
sqlplus INTERSPC/moonflower@IS61 @E:\DBA\jobs\jobs_interspec_start.sql
pause
REM restart-jobs-unilab
sqlplus UNILAB/moonflower@U611 @E:\DBA\jobs\jobs_unilab_start.sql
pause

REM restart-jobs-repm
REM no repm-jobs to start...


REM einde script



rem Script om de 3-oracle-databases te starten 
rem (evt. na reboot van server mocht blijken dat deze niet automatisch gestart worden...)
rem Windows-services oracle:
rem 1) OracleServiceIS61
rem 2) OracleServiceREPM
rem 3) OracleServiceU611


rem REstart database INTERPC-IS61
C:\oracle\product\11.2.0\dbhome_1\BIN\sqlplus sys/moonflower@IS61 as sysdba @E:\DBA\shutdown-is61.sql
C:\oracle\product\11.2.0\dbhome_1\BIN\sqlplus sys/moonflower@IS61 as sysdba @E:\DBA\startup-is61.sql

rem REstart database REPM
C:\oracle\product\11.2.0\dbhome_1\BIN\sqlplus sys/moonflower@IS61 as sysdba @E:\DBA\shutdown-repm.sql
C:\oracle\product\11.2.0\dbhome_1\BIN\sqlplus sys/moonflower@IS61 as sysdba @E:\DBA\startup-repm.sql

rem REstart database UNLIAB-U611
C:\oracle\product\11.2.0\dbhome_1\BIN\sqlplus sys/moonflower@U611 as sysdba @E:\DBA\shutdown-u611.sql
C:\oracle\product\11.2.0\dbhome_1\BIN\sqlplus sys/moonflower@U611 as sysdba @E:\DBA\startup-u611.sql


rem
rem Restart JOBS
rem
rem restart-jobs-interspec
C:\oracle\product\11.2.0\dbhome_1\BIN\sqlplus INTERSPC/moonflower@IS61 @E:\DBA\restart_jobs_interspec.sql
rem restart-jobs-unilab
C:\oracle\product\11.2.0\dbhome_1\BIN\sqlplus UNILAB/moonflower@U611 @E:\DBA\restart_jobs_unilab.sql
pause



rem
rem einde script
rem


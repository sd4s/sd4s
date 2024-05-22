--create NIEUWE pfiles obv SPFILE
--LET op: we gaan ervan uit dat DATABASES met SPFILE zijn opgestart, en dat we SPFILES kunnen overschrijven met nieuwe versie.

--log in als ADMINISTRATOR
--Open COMMAND-prompt
--Ga naar directory C:\oracle\product\11.2.0\dbhome_1\database\


--*****************************
--IS61:
--*****************************
sqlplus sys/moonflower@is61 as sysdba
startup nomount
create pfile='initIS61_20201123.ora' FROM SPFILE='SPFILEIS61.ORA';

--*****************************
--U611:
--*****************************
sqlplus sys/moonflower@u611 as sysdba
startup nomount
create pfile='initU611_20201123.ora' FROM SPFILE='SPFILEU611.ORA';

--*****************************
--REPM:
--*****************************
sqlplus sys/moonflower@repm as sysdba
startup nomount
create pfile='initREPM.ora' FROM SPFILE='SPFILEREPM.ORA';


--********************************
--Kopieer de nieuwe PFILE-bestanden
--********************************
copy initIS61.ora c:\oracle\admin\IS61\pfile\initIS61_20200903.ora
copy initU611.ora c:\oracle\admin\IS61\pfile\initU611_20200903.ora
copy initREPM.ora c:\oracle\admin\IS61\pfile\initREPM_20200903.ora


--einde script



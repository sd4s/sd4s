--Script om DPDUMP-DIR aan te maken voor imports/exports DATAPUMP
--Draai script vanaf de ORACLEPROD_TEST/ORACLEPROD

--SELECT OWNER, DIRECTORY_NAME, DIRECTORY_PATH from all_directories;
--ORACLEPROD_TEST:
--interspec:
--SYS                            	IMPORT 			E:\DUMP				--directory bestaat niet meer !!
--SYS                            	EXPORT_DIR		E:\Export\IS61
--SYS                            	DATA_PUMP_DIR	C:\oracle/admin/is61/dpdump/
create or replace directory IMPORT_DIR as 'D:\Import\IS61';
drop directory IMPORT;
create or replace directory EXPORT_DIR as 'D:\Export\IS61';
grant read,write on directory DATA_PUMP_DIR to INTERSPC;
grant read,write on directory IMPORT_DIR to INTERSPC;
grant read,write on directory EXPORT_DIR to INTERSPC;
grant datapump_exp_full_database, DATAPUMP_IMP_FULL_DATABASE to INTERSPC;
--
--UNILAB:
--SYS                            	IMPORT			E:\DUMP				--directory bestaat niet meer !!
--SYS                            	DATA_PUMP_DIR	C:\oracle/admin/u611/dpdump/
create or replace directory IMPORT_DIR as 'D:\Import\U611';
drop directory IMPORT;
create or replace directory EXPORT_DIR as 'D:\Export\U611';
grant read,write on directory DATA_PUMP_DIR to UNILAB;
grant read,write on directory IMPORT_DIR to UNILAB;
grant read,write on directory EXPORT_DIR to UNILAB;
grant datapump_exp_full_database, DATAPUMP_IMP_FULL_DATABASE to UNILAB;


--ORACLEPROD:
--Interspec:
--SYS                            DATA_PUMP_DIR	C:\Oracle\product\11.2.0\dbhome_1/rdbms/log/
--SYS                            EXPORT_DIR		E:\Export\IS61
--SYS                            IMPORT			E:\DUMP
create or replace directory IMPORT_DIR as 'D:\Import\IS61';
drop directory IMPORT;
create or replace directory EXPORT_DIR as 'D:\Export\IS61';
create OR REPLACE directory DATA_PUMP_DIR as 'C:\oracle/admin/IS61/dpdump/';
grant read,write on directory DATA_PUMP_DIR to INTERSPC;
grant read,write on directory IMPORT_DIR to INTERSPC;
grant read,write on directory EXPORT_DIR to INTERSPC;
grant datapump_exp_full_database, DATAPUMP_IMP_FULL_DATABASE to INTERSPC;

--
--UNILAB:
--SYS                            DATA_PUMP_DIR	C:\Oracle\product\11.2.0\dbhome_1/rdbms/log/
--SYS                            EXPORT_DIR		E:\Export\IS61
--SYS                            IMPORT			E:\DUMP
create or replace directory IMPORT_DIR as 'D:\Import\U611';
drop directory IMPORT;
create or replace directory EXPORT_DIR as 'D:\Export\U611';
create OR REPLACE directory DATA_PUMP_DIR as 'C:\oracle/admin/U611/dpdump/';
grant read,write on directory DATA_PUMP_DIR to UNILAB;
grant read,write on directory IMPORT_DIR to UNILAB;
grant read,write on directory EXPORT_DIR to UNILAB;
grant datapump_exp_full_database, DATAPUMP_IMP_FULL_DATABASE to UNILAB;





prompt
prompt einde script
prompt

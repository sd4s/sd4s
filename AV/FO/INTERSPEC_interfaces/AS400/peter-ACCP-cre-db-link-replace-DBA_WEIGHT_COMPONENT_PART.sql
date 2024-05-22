--db-link voor switch-test AS400-UPDWEIGHTS

SELECT * FROM ALL_DB_LINKS;
/*
PUBLIC
DBAAS_IS61_TST_PRD_DBL.REGRESS.RDBMS.DEV.US.ORACLE.COM
INTERSPEC
INTERSPEC_PROD
03-AUG-23
*/


--Starting in 11g release 2, the syntax has been enhanced to remove the need to epscify a TNS service_name:
/*
--go to oracleprod_test
drop public database link  DBAAS_IS61_TST_PRD_DBL; 
create public database link DBAAS_IS61_TST_PRD_DBL connect to "INTERSPC" identified by "moonflower" using 'INTERSPEC_PROD';
--created !!!!
*/

--test: 
select count(*) from DBA_WEIGHT_COMPONENT_PART@DBAAS_IS61_TST_PRD_DBL ; 
--working !!!




--Nu overhalen van data...
alter table DBA_WEIGHT_COMPONENT_PART DISABLE all triggers;
--
select count(*) from DBA_WEIGHT_COMPONENT_PART;
--151908
SELECT count(*) FROM DBA_WEIGHT_COMPONENT_PART@DBAAS_IS61_TST_PRD_DBL ;
--506026
truncate table DBA_WEIGHT_COMPONENT_PART;
--
insert into DBA_WEIGHT_COMPONENT_PART SELECT * FROM DBA_WEIGHT_COMPONENT_PART@DBAAS_IS61_TST_PRD_DBL ;
--

select count(*) from DBA_WEIGHT_COMPONENT_PART;
--33599
COMMIT;
--
alter table DBA_WEIGHT_COMPONENT_PART ENABLE all triggers;

purge recyclebin;


--
-- CHANGE VIEW DBA_VW_CRRENT_WEIGHT_SAP to show WEIGHT with 3-digits-accurrecy 
--






--einde script







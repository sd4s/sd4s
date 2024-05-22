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

create public database link
  mylink
connect to
  remote_username
identified by
  mypassword
using 'myserver:1521/MYSID';

--go to oracleprod_test
drop public database link  DBAAS_IS61_TST_PRD_DBL; 
create public database link DBAAS_IS61_TST_PRD_DBL connect to "INTERSPC" identified by "moonflower" using 'INTERSPEC_PROD';
--created !!!!

--test: 
select count(*) from avspecification_weight@DBAAS_IS61_TST_PRD_DBL ; 
--working !!!




--Nu overhalen van data...
alter table AVSPECIFICATION_WEIGHT DISABLE all triggers;
--
select count(*) from avspecification_weight;
select count(*) from avspecification_weight_MUTLOG;

truncate table AVSPECIFICATION_WEIGHT;
truncate table AVSPECIFICATION_WEIGHT_MUTLOG;
--
insert into AVSPECIFICATION_WEIGHT SELECT * FROM AVSPECIFICATION_WEIGHT@DBAAS_IS61_TST_PRD_DBL ;
--

select count(*) from avspecification_weight;
--33599
select count(*) from avspecification_weight_MUTLOG;
--0

COMMIT;
--
alter table AVSPECIFICATION_WEIGHT ENABLE all triggers;

purge recyclebin;








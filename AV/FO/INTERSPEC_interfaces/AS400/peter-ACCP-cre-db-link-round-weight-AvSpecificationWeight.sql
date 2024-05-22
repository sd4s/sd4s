--db-link voor switch-test AS400-UPDWEIGHTS

SELECT * FROM ALL_DB_LINKS;
/*
PUBLIC
DBAAS_IS61_TST_PRD_DBL.REGRESS.RDBMS.DEV.US.ORACLE.COM
INTERSPEC
INTERSPEC_PROD
03-AUG-23
*/

/*
--go to oracleprod_test
drop public database link  DBAAS_IS61_TST_PRD_DBL; 
create public database link DBAAS_IS61_TST_PRD_DBL connect to "INTERSPC" identified by "moonflower" using 'INTERSPEC_PROD';
--created !!!!
*/

--test: 
select count(*) from avspecification_weight@DBAAS_IS61_TST_PRD_DBL ; 
--working !!!




--Nu overhalen van data...
alter table AVSPECIFICATION_WEIGHT DISABLE all triggers;
--
select count(*) from avspecification_weight;
--33600
select count(*) from avspecification_weight_MUTLOG;
--33600
SELECT count(*) FROM AVSPECIFICATION_WEIGHT@DBAAS_IS61_TST_PRD_DBL ;
--33649

truncate table AVSPECIFICATION_WEIGHT;
truncate table AVSPECIFICATION_WEIGHT_MUTLOG;
--
insert into AVSPECIFICATION_WEIGHT SELECT * FROM AVSPECIFICATION_WEIGHT@DBAAS_IS61_TST_PRD_DBL ;
--
insert into AVSPECIFICATION_WEIGHT_MUTLOG 
SELECT PLANT    
,PART_NO         
,REVISION        
,BASE_UOM        
,STATUS_TYPE     
,KMGKOD          
,ARTKOD          
,SAP_ARTICLE     
,WEIGHT          
,UOM             
,STATUS          
,DA_ARTICLE      
,sysdate        --TECH_INSERT_DATUM    
,to_date(null)  --TECH_UPDATE_DATUM       
,user           --USER_LAATSTE_WIJZ       
,'sqlplus'      --TECH_PROGRAM            
,''             --TECH_UPDATE_ATTR 
FROM AVSPECIFICATION_WEIGHT 
;
--
select count(*) from avspecification_weight;
--33649
select count(*) from avspecification_weight_MUTLOG;
--33649
COMMIT;
--
alter table AVSPECIFICATION_WEIGHT ENABLE all triggers;
--
purge recyclebin;


--einde script







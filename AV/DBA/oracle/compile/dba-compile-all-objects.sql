--DBMS_UTILITY.compile_schema
--The COMPILE_SCHEMA procedure in the DBMS_UTILITY package compiles all procedures, functions, packages, and triggers in the specified schema. 

--run als system:
EXEC DBMS_UTILITY.compile_schema(schema => 'UNILAB');

descr  all_objects;
/*
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 OWNER                                     NOT NULL VARCHAR2(30)
 OBJECT_NAME                               NOT NULL VARCHAR2(30)
 SUBOBJECT_NAME                                     VARCHAR2(30)
 OBJECT_ID                                 NOT NULL NUMBER
 DATA_OBJECT_ID                                     NUMBER
 OBJECT_TYPE                                        VARCHAR2(19)
 CREATED                                   NOT NULL DATE
 LAST_DDL_TIME                             NOT NULL DATE
 TIMESTAMP                                          VARCHAR2(19)
 STATUS                                             VARCHAR2(7)
 TEMPORARY                                          VARCHAR2(1)
 GENERATED                                          VARCHAR2(1)
 SECONDARY                                          VARCHAR2(1)
 NAMESPACE                                 NOT NULL NUMBER
 EDITION_NAME                                       VARCHAR2(30)
*/

select count(*), object_type, status
from all_objects 
where status='INVALID'
group by object_type, status
order by  object_type, status
;
/*
 COUNT(*) OBJECT_TYPE         STATUS
--------- ------------------- -------
     4059 SYNONYM             INVALID
       48 VIEW                INVALID
*/	   

select count(*), owner, object_type, status
from all_objects 
where status='INVALID'
group by owner, object_type, status
order by owner, object_type, status
;

select owner, object_name
from all_objects
where status='INVALID'
and   object_type ='VIEW'
order by owner, object_name
;

--DROPPEN VAN INVALID-VIEWS
SELECT 'DROP '||object_type||' '||owner||'.'||OBJECT_NAME||';'
from all_objects
where object_type='VIEW'
and   status='INVALID'
order by object_name;

/*
DROP VIEW DD1.UVWSGKTESTSETPOSITION1;
DROP VIEW DD1.UVWSGKTESTSETPOSITION_;
DROP VIEW DD1.UVWSGKTESTSETWRONG;
DROP VIEW DD10.UVWSGKTESTSETPOSITION1;
DROP VIEW DD10.UVWSGKTESTSETPOSITION_;
DROP VIEW DD10.UVWSGKTESTSETWRONG;
DROP VIEW DD11.UVWSGKTESTSETPOSITION1;
DROP VIEW DD11.UVWSGKTESTSETPOSITION_;
DROP VIEW DD11.UVWSGKTESTSETWRONG;
DROP VIEW DD12.UVWSGKTESTSETPOSITION1;
DROP VIEW DD12.UVWSGKTESTSETPOSITION_;
DROP VIEW DD12.UVWSGKTESTSETWRONG;
DROP VIEW DD13.UVWSGKTESTSETPOSITION1;
DROP VIEW DD13.UVWSGKTESTSETPOSITION_;
DROP VIEW DD13.UVWSGKTESTSETWRONG;
DROP VIEW DD14.UVWSGKTESTSETPOSITION1;
DROP VIEW DD14.UVWSGKTESTSETPOSITION_;
DROP VIEW DD14.UVWSGKTESTSETWRONG;
DROP VIEW DD15.UVWSGKTESTSETPOSITION1;
DROP VIEW DD15.UVWSGKTESTSETPOSITION_;
DROP VIEW DD15.UVWSGKTESTSETWRONG;
DROP VIEW DD16.UVWSGKTESTSETPOSITION1;
DROP VIEW DD16.UVWSGKTESTSETPOSITION_;
DROP VIEW DD16.UVWSGKTESTSETWRONG;
DROP VIEW DD2.UVWSGKTESTSETPOSITION1;
DROP VIEW DD2.UVWSGKTESTSETPOSITION_;
DROP VIEW DD2.UVWSGKTESTSETWRONG;
DROP VIEW DD3.UVWSGKTESTSETPOSITION1;
DROP VIEW DD3.UVWSGKTESTSETPOSITION_;
DROP VIEW DD3.UVWSGKTESTSETWRONG;
DROP VIEW DD4.UVWSGKTESTSETPOSITION1;
DROP VIEW DD4.UVWSGKTESTSETPOSITION_;
DROP VIEW DD4.UVWSGKTESTSETWRONG;
DROP VIEW DD5.UVWSGKTESTSETPOSITION1;
DROP VIEW DD5.UVWSGKTESTSETPOSITION_;
DROP VIEW DD5.UVWSGKTESTSETWRONG;
DROP VIEW DD6.UVWSGKTESTSETPOSITION1;
DROP VIEW DD6.UVWSGKTESTSETPOSITION_;
DROP VIEW DD6.UVWSGKTESTSETWRONG;
DROP VIEW DD7.UVWSGKTESTSETPOSITION1;
DROP VIEW DD7.UVWSGKTESTSETPOSITION_;
DROP VIEW DD7.UVWSGKTESTSETWRONG;
DROP VIEW DD8.UVWSGKTESTSETPOSITION1;
DROP VIEW DD8.UVWSGKTESTSETPOSITION_;
DROP VIEW DD8.UVWSGKTESTSETWRONG;
DROP VIEW DD9.UVWSGKTESTSETPOSITION1;
DROP VIEW DD9.UVWSGKTESTSETPOSITION_;
DROP VIEW DD9.UVWSGKTESTSETWRONG;
*/

select owner, object_name
from all_objects
where status='INVALID'
and   object_type ='SYNONYM'
--and   OWNER='PSC'
order by owner, object_name
;
/*
AAF	APPLYTEMPLATE
AAF	GETACTUALLICENSEUSAGE
AAF	MINILINK
AAF	RFU_GETSPECIFICATIONFORMAT
AAF	UNIUPG62 
AAF	UVWSGKTESTSETPOSITION1
AAF	UVWSGKTESTSETPOSITION_
AAF	UVWSGKTESTSETWRONG

--LET OP: dit zijn geen echte INVALID-objecten, zodra je als gebruiker een DESCR <OBJECT>  uitvoert, wordt er automatisch een compile uitgevoerd
--        en is SYNONYM weer VALID !!!
*/

select syn.owner, syn.table_owner, synonym_name
from all_synonyms syn
where syn.owner = 'helpdesk'
and syn.synonym_name in (select obj.object_name from all_objects obj where obj.owner = syn.owner and obj.object_name = syn.synonym_name and obj.status='INVALID')
order by syn.owner, syn.table_owner, syn.synonym_name
;

--waar komen mijn eigen synonyms vandaan?
select syn.owner, syn.table_owner, count(*)
from all_synonyms syn
where syn.owner = 'PSC'
group by syn.owner, syn.table_owner
order by syn.owner, syn.table_owner
;
/*
OWNER                          TABLE_OWNER                      COUNT(*)
------------------------------ ------------------------------ ----------
PSC                            DD1                                   408
PSC                            UNILAB                                258
*/
select syn.owner, syn.table_owner, substr(synonym_name,1,2), count(*)
from all_synonyms syn
where syn.owner = 'PSC'
group by syn.owner, syn.table_owner, substr(synonym_name,1,2)
order by syn.owner, syn.table_owner, substr(synonym_name,1,2)
;
/*
OWNER                          TABLE_OWNER                    SUBSTR(S   	COUNT(*)
------------------------------ ------------------------------ --------		----------
PSC                            DD1                            UV	       408
PSC                            UNILAB                         AA         1
PSC                            UNILAB                         AD         1
PSC                            UNILAB                         AN         1
PSC                            UNILAB                         AO         2
PSC                            UNILAB                         AP        16
PSC                            UNILAB                         AT         1
PSC                            UNILAB                         CH         1
PSC                            UNILAB                         CL         2
PSC                            UNILAB                         CX         3
PSC                            UNILAB                         DE         2
PSC                            UNILAB                         DR         4
PSC                            UNILAB                         DS         1
PSC                            UNILAB                         FO         1
PSC                            UNILAB                         GE         3
PSC                            UNILAB                         ME         2
PSC                            UNILAB                         MI         1
PSC                            UNILAB                         PA         2
PSC                            UNILAB                         PB        29
PSC                            UNILAB                         RE         4
PSC                            UNILAB                         RF         6
PSC                            UNILAB                         RM         2
PSC                            UNILAB                         RP         4
PSC                            UNILAB                         SA         1
PSC                            UNILAB                         SQ         1
PSC                            UNILAB                         ST         5
PSC                            UNILAB                         SY         1
PSC                            UNILAB                         TM         1
PSC                            UNILAB                         TO         1
PSC                            UNILAB                         TR         1
PSC                            UNILAB                         UL         2
PSC                            UNILAB                         UN       155
PSC                            UNILAB                         UP         1
--
--conclusie: ALLE RECHTEN OP DE VIEWS komen via een DD-USER (DD1 in mijn geval)!!!!. 
--           Verder alle UN/PB-INTERFACE/PACKAGEs en eigen AP-PACKAGES EN ALLE FUNCTIONS/PROCEDURES komen direct vanuit UNILAB !!!
--           Gebruiker heeft geen RECHTEN rechtstreeks op de UNILAB-TABELLEN !!!!!!
*/		 
select syn.owner, syn.table_owner, synonym_name
from all_synonyms syn
where syn.owner = 'PSC'
and   syn.table_owner='DD1'
order by syn.owner, syn.table_owner, synonym_name
;

--Indien onderliggende TABEL/VIEW niet meer bestaat, kan synonym verwijderd worden:
select 'DROP SYNONYM "'||OWNER||'".'||object_name||';'
from all_objects
where status='INVALID'
and   object_type ='SYNONYM'
and   Object_name like 'UVWSGKTESTSET%'
order by owner, object_name
;
/*
DROP SYNONYM "%".UVWSGKTESTSETPOSITION1;
DROP SYNONYM "%".UVWSGKTESTSETPOSITION_;
DROP SYNONYM "%".UVWSGKTESTSETWRONG;
DROP SYNONYM "AND".UVWSGKTESTSETPOSITION1;
DROP SYNONYM "AND".UVWSGKTESTSETPOSITION_;
DROP SYNONYM "AND".UVWSGKTESTSETWRONG;
DROP SYNONYM "BAM mgt".UVWSGKTESTSETPOSITION_;
DROP SYNONYM "BAM mgt".UVWSGKTESTSETWRONG;
DROP SYNONYM "Certificate control".UVWSGKTESTSETPOSITION1;
DROP SYNONYM "Certificate control".UVWSGKTESTSETPOSITION_;
DROP SYNONYM "Certificate control".UVWSGKTESTSETWRONG;
DROP SYNONYM "Chemical lab".UVWSGKTESTSETPOSITION1;
DROP SYNONYM "Chemical lab".UVWSGKTESTSETPOSITION_;
DROP SYNONYM "Chemical lab".UVWSGKTESTSETWRONG;
DROP SYNONYM "Compounding".UVWSGKTESTSETPOSITION1;
DROP SYNONYM "Compounding".UVWSGKTESTSETPOSITION_;
DROP SYNONYM "Compounding".UVWSGKTESTSETWRONG;
DROP SYNONYM "Construction AT".UVWSGKTESTSETPOSITION1;
DROP SYNONYM "Construction AT".UVWSGKTESTSETPOSITION_;
DROP SYNONYM "Construction AT".UVWSGKTESTSETWRONG;
DROP SYNONYM "Construction PCT".UVWSGKTESTSETPOSITION1;
DROP SYNONYM "Construction PCT".UVWSGKTESTSETPOSITION_;
DROP SYNONYM "Construction PCT".UVWSGKTESTSETWRONG;
DROP SYNONYM "Construction SM".UVWSGKTESTSETPOSITION1;
DROP SYNONYM "Construction SM".UVWSGKTESTSETPOSITION_;
DROP SYNONYM "Construction SM".UVWSGKTESTSETWRONG;
DROP SYNONYM "Eplexor".UVWSGKTESTSETPOSITION1;
DROP SYNONYM "Eplexor".UVWSGKTESTSETPOSITION_;
DROP SYNONYM "Eplexor".UVWSGKTESTSETWRONG;
DROP SYNONYM "FEA mgt".UVWSGKTESTSETPOSITION1;
DROP SYNONYM "FEA mgt".UVWSGKTESTSETPOSITION_;
DROP SYNONYM "FEA mgt".UVWSGKTESTSETWRONG;
DROP SYNONYM "Indoor testing".UVWSGKTESTSETPOSITION1;
DROP SYNONYM "Indoor testing".UVWSGKTESTSETPOSITION_;
DROP SYNONYM "Indoor testing".UVWSGKTESTSETWRONG;
DROP SYNONYM "Lab mgt".UVWSGKTESTSETPOSITION1;
DROP SYNONYM "Lab mgt".UVWSGKTESTSETPOSITION_;
DROP SYNONYM "Lab mgt".UVWSGKTESTSETWRONG;
DROP SYNONYM "LimsAdministrator".UVWSGKTESTSETPOSITION1;
DROP SYNONYM "LimsAdministrator".UVWSGKTESTSETPOSITION_;
DROP SYNONYM "LimsAdministrator".UVWSGKTESTSETWRONG;
DROP SYNONYM "Material lab".UVWSGKTESTSETPOSITION1;
DROP SYNONYM "Material lab".UVWSGKTESTSETPOSITION_;
DROP SYNONYM "Material lab".UVWSGKTESTSETWRONG;
DROP SYNONYM "Material lab mgt".UVWSGKTESTSETPOSITION1;
DROP SYNONYM "Material lab mgt".UVWSGKTESTSETPOSITION_;
DROP SYNONYM "Material lab mgt".UVWSGKTESTSETWRONG;
DROP SYNONYM "Mooney2000E".UVWSGKTESTSETPOSITION1;
DROP SYNONYM "Mooney2000E".UVWSGKTESTSETPOSITION_;
DROP SYNONYM "Mooney2000E".UVWSGKTESTSETWRONG;
DROP SYNONYM "Outdoor testing".UVWSGKTESTSETPOSITION1;
DROP SYNONYM "Outdoor testing".UVWSGKTESTSETPOSITION_;
DROP SYNONYM "Outdoor testing".UVWSGKTESTSETWRONG;
DROP SYNONYM "Physical lab".UVWSGKTESTSETPOSITION1;
DROP SYNONYM "Physical lab".UVWSGKTESTSETPOSITION_;
DROP SYNONYM "Physical lab".UVWSGKTESTSETWRONG;
DROP SYNONYM "Preparation lab".UVWSGKTESTSETPOSITION1;
DROP SYNONYM "Preparation lab".UVWSGKTESTSETPOSITION_;
DROP SYNONYM "Preparation lab".UVWSGKTESTSETWRONG;
DROP SYNONYM "Process tech. B&V".UVWSGKTESTSETPOSITION1;
DROP SYNONYM "Process tech. B&V".UVWSGKTESTSETPOSITION_;
DROP SYNONYM "Process tech. B&V".UVWSGKTESTSETWRONG;
DROP SYNONYM "Process tech. BV".UVWSGKTESTSETPOSITION1;
DROP SYNONYM "Process tech. BV".UVWSGKTESTSETPOSITION_;
DROP SYNONYM "Process tech. BV".UVWSGKTESTSETWRONG;
DROP SYNONYM "Process tech. VF".UVWSGKTESTSETPOSITION1;
DROP SYNONYM "Process tech. VF".UVWSGKTESTSETPOSITION_;
DROP SYNONYM "Process tech. VF".UVWSGKTESTSETWRONG;
DROP SYNONYM "Proto AT".UVWSGKTESTSETPOSITION1;
DROP SYNONYM "Proto AT".UVWSGKTESTSETPOSITION_;
DROP SYNONYM "Proto AT".UVWSGKTESTSETWRONG;
DROP SYNONYM "Proto Calander".UVWSGKTESTSETPOSITION1;
DROP SYNONYM "Proto Calander".UVWSGKTESTSETPOSITION_;
DROP SYNONYM "Proto Calander".UVWSGKTESTSETWRONG;
DROP SYNONYM "Proto Extrusion".UVWSGKTESTSETPOSITION1;
DROP SYNONYM "Proto Extrusion".UVWSGKTESTSETPOSITION_;
DROP SYNONYM "Proto Extrusion".UVWSGKTESTSETWRONG;
DROP SYNONYM "Proto Mixing".UVWSGKTESTSETPOSITION1;
DROP SYNONYM "Proto Mixing".UVWSGKTESTSETPOSITION_;
DROP SYNONYM "Proto Mixing".UVWSGKTESTSETWRONG;
DROP SYNONYM "Proto PCT".UVWSGKTESTSETPOSITION1;
DROP SYNONYM "Proto PCT".UVWSGKTESTSETPOSITION_;
DROP SYNONYM "Proto PCT".UVWSGKTESTSETWRONG;
DROP SYNONYM "Proto Tread".UVWSGKTESTSETPOSITION1;
DROP SYNONYM "Proto Tread".UVWSGKTESTSETPOSITION_;
DROP SYNONYM "Proto Tread".UVWSGKTESTSETWRONG;
DROP SYNONYM "Purchasing".UVWSGKTESTSETPOSITION1;
DROP SYNONYM "Purchasing".UVWSGKTESTSETPOSITION_;
DROP SYNONYM "Purchasing".UVWSGKTESTSETWRONG;
DROP SYNONYM "Reinforcement".UVWSGKTESTSETPOSITION1;
DROP SYNONYM "Reinforcement".UVWSGKTESTSETPOSITION_;
DROP SYNONYM "Reinforcement".UVWSGKTESTSETWRONG;
DROP SYNONYM "Research".UVWSGKTESTSETPOSITION1;
DROP SYNONYM "Research".UVWSGKTESTSETPOSITION_;
DROP SYNONYM "Research".UVWSGKTESTSETWRONG;
DROP SYNONYM "TTE_Athena".UVWSGKTESTSETPOSITION1;
DROP SYNONYM "TTE_Athena".UVWSGKTESTSETPOSITION_;
DROP SYNONYM "TTE_Athena".UVWSGKTESTSETWRONG;
DROP SYNONYM "Tyre Order".UVWSGKTESTSETPOSITION1;
DROP SYNONYM "Tyre Order".UVWSGKTESTSETPOSITION_;
DROP SYNONYM "Tyre Order".UVWSGKTESTSETWRONG;
DROP SYNONYM "Tyre testing".UVWSGKTESTSETPOSITION1;
DROP SYNONYM "Tyre testing".UVWSGKTESTSETPOSITION_;
DROP SYNONYM "Tyre testing".UVWSGKTESTSETWRONG;
DROP SYNONYM "Tyre testing adv mgt".UVWSGKTESTSETPOSITION1;
DROP SYNONYM "Tyre testing adv mgt".UVWSGKTESTSETPOSITION_;
DROP SYNONYM "Tyre testing adv mgt".UVWSGKTESTSETWRONG;
DROP SYNONYM "Tyre testing adv.".UVWSGKTESTSETPOSITION1;
DROP SYNONYM "Tyre testing adv.".UVWSGKTESTSETPOSITION_;
DROP SYNONYM "Tyre testing adv.".UVWSGKTESTSETWRONG;
DROP SYNONYM "Tyre testing std".UVWSGKTESTSETPOSITION1;
DROP SYNONYM "Tyre testing std".UVWSGKTESTSETPOSITION_;
DROP SYNONYM "Tyre testing std".UVWSGKTESTSETWRONG;
DROP SYNONYM "Tyre testing std ENS".UVWSGKTESTSETPOSITION1;
DROP SYNONYM "Tyre testing std ENS".UVWSGKTESTSETPOSITION_;
DROP SYNONYM "Tyre testing std ENS".UVWSGKTESTSETWRONG;
DROP SYNONYM "Tyre testing std mgt".UVWSGKTESTSETPOSITION1;
DROP SYNONYM "Tyre testing std mgt".UVWSGKTESTSETPOSITION_;
DROP SYNONYM "Tyre testing std mgt".UVWSGKTESTSETWRONG;
DROP SYNONYM "Tyres test standard".UVWSGKTESTSETPOSITION1;
DROP SYNONYM "Tyres test standard".UVWSGKTESTSETPOSITION_;
DROP SYNONYM "Tyres test standard".UVWSGKTESTSETWRONG;
DROP SYNONYM "helpdesk".UVWSGKTESTSETPOSITION1;
DROP SYNONYM "helpdesk".UVWSGKTESTSETPOSITION_;
DROP SYNONYM "helpdesk".UVWSGKTESTSETWRONG;
*/

--en anders met een RECOMPILE oplossen:
--ALTER SYNONYM "helpdesk".APPLYTEMPLATE compile;

spool 'c:\TEMP\peter_gen_compile_synonyms.sql'

set serveroutput on
--
begin
for i in (select object_name,owner 
         from all_objects
         where owner like '&1.%'
         and object_type = 'SYNONYM'
         and status = 'INVALID')
LOOP
  begin
    execute immediate 'alter synonym "' || i.owner || '".' || i.object_name || ' compile ';
  exception when others then
    dbms_output.put_line ( 'unable to recompile '||i.owner||'.'||i.object_name||' '||' -ERROR- '||SQLERRM);
  end;
end loop;
end;
/

SPOOL OFF.

--controle na compile
select obj.owner, obj.object_name , obj.object_type
from all_objects obj 
where obj.status='INVALID'
--and  obj.owner = 'helpdesk'
order by obj.owner, obj.object_name
;


  
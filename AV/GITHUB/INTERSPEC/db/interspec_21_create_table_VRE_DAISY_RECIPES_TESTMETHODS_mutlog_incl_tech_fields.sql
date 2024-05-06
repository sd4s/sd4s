--Script om een aantal TECH-attributes aan tabel = VRE.TESTLIMITS + VRE.TESTVARIABLES toe te voegen
--om vanuit beheer beter te kunnen zien wat er gebeurt op deze tabel...

--dd. 08-12-2022 15:50 UUR: Wijziging uitgerold naar TEST + PROD !!!!

descr VRE.DAISY_RECIPES;
/*
Name      Null?    Type              
--------- -------- ----------------- 
RECIPE		VARCHAR2(12 CHAR)	Not null
U_RECIPE	VARCHAR2(20 CHAR)	Not null
U_VERSION	NUMBER(5,0)			null
*/

descr VRE.TESTMETHODS
/*
Name            Null?    Type              
--------------- -------- ----------------- 
AV_METHOD		VARCHAR2(40 CHAR)	Not null
CMP_TESTMETHOD	VARCHAR2(8 CHAR)	null
AGING			VARCHAR2(5 CHAR)	null
PREPARATION		VARCHAR2(5 CHAR)	null
PARAMETERGROUP	VARCHAR2(20 CHAR)	null
MACHINE_ID		NUMBER(38,0)	    null
*/




/*
--test
delete from avspecification_weight where part_no='peter';
commit;
insert into avspecification_weight (part_no) values ('peter');
select * from avspecification_weight where part_no='peter';
	peter											08-12-2022 15:30:15		INTERSPC
commit;
update avspecification_weight set weight=50 where part_no='peter';
select * from avspecification_weight where part_no='peter';
commit;
--ok
*/

 
--backup COPY-TABEL AANMAKEN VOOR AVSPECIFICATION_WEIGHT 

create table vre.daisy_recipes_mutlog as select * from vre.daisy_recipes;
CREATE INDEX vre.DAISY_RECIPES_MUTLOG_IX    ON VRE.DAISY_RECIPES_MUTLOG ( RECIPE, U_RECIPE ) TABLESPACE  SPECD ;
--
create table vre.testmethods_mutlog as select * from vre.testmethods;
CREATE INDEX VRE.TESTMETHODS_MUTLOG_IX ON VRE.TESTMETHODS_MUTLOG ( AV_METHOD  ) TABLESPACE  SPECD;
--
--connect VRE/VRE@IS61
grant select,insert,update,delete on vre.daisy_recipes_mutlog to interspc with grant option;
grant select,insert,update,delete on vre.testmethods_mutlog to interspc with grant option;
--
grant select,insert,update,delete on vre.daisy_recipes    to interspc with grant option;
grant select,insert,update,delete on vre.testmethods to interspc with grant option;




--VOEG TECH-ATTRIBUTES AAN MUTLOG-TABELLEN TOE...
--
alter table vre.daisy_recipes_mutlog add tech_insert_datum date;
alter table vre.daisy_recipes_mutlog add tech_update_datum date;
alter table vre.daisy_recipes_mutlog add user_laatste_wijz varchar2(100);
alter table vre.daisy_recipes_mutlog add tech_program     varchar2(4000);
alter table vre.daisy_recipes_mutlog add tech_update_attr varchar2(4000);
--
alter table vre.testmethods_mutlog add tech_insert_datum date;
alter table vre.testmethods_mutlog add tech_update_datum date;
alter table vre.testmethods_mutlog add user_laatste_wijz varchar2(100);
alter table vre.testmethods_mutlog add tech_program     varchar2(4000);
alter table vre.testmethods_mutlog add tech_update_attr varchar2(4000);



select count(*) from vre.daisy_recipes;
select count(*) from vre.daisy_recipes_mutlog;

select count(*) from vre.testmethods;
select count(*) from vre.testmethods_mutlog;

/*
--*************************************************************************
--*************************************************************************
--SCENARIO-1: verwijder TECH-COLUMNS + TRIGGER van oude TABEL
--*************************************************************************
--*************************************************************************
--drop TRIGGER AVSPEC_WEIGHT_BRIU;
--
alter table vre.testlimits_mutlog drop column tech_insert_datum ;
alter table vre.testlimits_mutlog drop column  tech_update_datum ;
alter table vre.testlimits_mutlog drop column user_laatste_wijz ;
alter table vre.testlimits_mutlog drop column  tech_program ;
alter table vre.testlimits_mutlog drop column tech_update_attr ;
--
alter table vre.testvariables_mutlog drop column tech_insert_datum ;
alter table vre.testvariables_mutlog drop column  tech_update_datum ;
alter table vre.testvariables_mutlog drop column user_laatste_wijz ;
alter table vre.testvariables_mutlog drop column  tech_program ;
alter table vre.testvariables_mutlog drop column tech_update_attr ;
*/

--SCENARIO-1B: VOEG NIEUWE TRIGGERS TOE OP OUDE-TABEL OM COPY-TABEL (MET TECH-COLUMNS) TE VULLEN...
--             EN VOEG NIEUWE TRIGGER OP NIEUWE COPY-TABEL TOE OM TECH-COLUMNS TE VULLEN...
--

conn interspc@IS61

--De trigger blijft wel op de BASIS-TABEL ZITTEN, en van daaruit worden mutaties naar kopie-mutatie-log-tabel 
--overgezet!!. 
CREATE OR REPLACE TRIGGER interspc.DAISY_RECIPES_BRIU
BEFORE INSERT OR UPDATE ON VRE.DAISY_RECIPES
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
declare
l_sessionid   number;
l_program     varchar2(4000);
l_update_attr varchar2(4000);
l_tech_insert_datum date;
l_tech_update_datum date;
l_user_laatste_wijz varchar2(100);
l_tech_program      varchar2(4000);
l_tech_update_attr  varchar2(4000);
BEGIN
  l_user_laatste_wijz := user;
  begin
    SELECT SYS_CONTEXT ('USERENV', 'SESSIONID') into l_sessionid FROM DUAL;
	--
	select machine||':'||module||':'||program 
	into l_tech_program 
	from v$session 
	where audsid=l_sessionid;
	--
  exception
    when others then null;  
  end;
  if INSERTING
  then 
    l_tech_insert_datum := sysdate;
    --
	begin
	  insert into vre.DAISY_RECIPES_MUTLOG
	   ( RECIPE	
       ,U_RECIPE
       ,U_VERSION
	   ,TECH_INSERT_DATUM
	   ,TECH_UPDATE_DATUM
	   ,USER_LAATSTE_WIJZ
	   ,TECH_PROGRAM
	   ,TECH_UPDATE_ATTR ) values (:new.RECIPE
	                        ,:new.U_RECIPE
							,:new.U_VERSION
							,l_tech_insert_datum
							,to_date(null)
							,l_user_laatste_wijz
							,l_tech_program
							,l_tech_update_attr);
    exception
      when others then null;
    end;	  
  end if;
  --
  if UPDATING
  then l_tech_update_datum := sysdate;
  end if;
  if UPDATING
  then --PLANT
	   --PART_NO
	   l_update_attr := to_char(l_tech_update_datum,'dd-mm-yyyy hh24:mi:ss');
	   --
	   if (updating('RECIPE')) 
	   then l_update_attr := l_update_attr||'(RECIPE:'||:old.RECIPE||' to '||:new.RECIPE||');';
	   end if;
	   if (updating('U_RECIPE')) 
	   then l_update_attr := l_update_attr||'(U_RECIPE:'||:old.U_RECIPE||' to '||:new.U_RECIPE||');';
	   end if;
	   if (updating('U_VERSION')) 
	   then l_update_attr := l_update_attr||'(U_VERSION:'||:old.U_VERSION||' to '||:new.U_VERSION||');';
	   end if;
	   --
       l_tech_update_attr := substr(l_update_attr,1,4000);       
	   --
	   begin
	   update VRE.DAISY_RECIPES_MUTLOG
	      set RECIPE            = :new.RECIPE
		  ,   U_RECIPE          = :new.U_RECIPE
	      ,   U_VERSION         = :new.U_VERSION
          ,   TECH_UPDATE_DATUM = l_tech_update_datum
          ,   USER_LAATSTE_WIJZ = l_user_laatste_wijz
          ,   TECH_PROGRAM      = l_tech_program
          ,   TECH_UPDATE_ATTR  = TECH_UPDATE_ATTR||'@'||l_tech_update_attr
          WHERE RECIPE  = :old.RECIPE
		  ;
    exception
      when others then null;
    end;	  
  end if;
  --
EXCEPTION
  when others 
  then null;  
END;
/


/*
--test
delete from vre.DAISY_RECIPES_MUTLOG   where recipe='peter';
delete from vre.DAISY_RECIPES_MUTLOG where  recipe='peter';
--
insert into vre.DAISY_RECIPES (recipe, u_recipe, u_version ) values ('peter' , 'peter' ,'-1' );
select * from vre.DAISY_RECIPES where recipe='peter';
select * from vre.DAISY_RECIPES_MUTLOG where recipe='peter';
commit;
--
update vre.DAISY_RECIPES set u_version=-2 where recipe='peter';
select * from vre.DAISY_RECIPES where recipe='peter';
select * from vre.DAISY_RECIPES_MUTLOG where recipe='peter';
commit;
--ok
*/

conn INTERSPC@IS61

CREATE OR REPLACE TRIGGER interspc.TESTMETHODS_BRIU
BEFORE INSERT OR UPDATE ON VRE.TESTMETHODS
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
declare
l_sessionid   number;
l_program     varchar2(4000);
l_update_attr varchar2(4000);
l_tech_insert_datum date;
l_tech_update_datum date;
l_user_laatste_wijz varchar2(100);
l_tech_program      varchar2(4000);
l_tech_update_attr  varchar2(4000);
BEGIN
  l_user_laatste_wijz := user;
  begin
    SELECT SYS_CONTEXT ('USERENV', 'SESSIONID') into l_sessionid FROM DUAL;
	--
	select machine||':'||module||':'||program 
	into l_tech_program 
	from v$session 
	where audsid=l_sessionid;
	--
  exception
    when others then null;  
  end;
  if INSERTING
  then 
    l_tech_insert_datum := sysdate;
    --
	begin
	  insert into vre.TESTMETHODS_MUTLOG
	   (AV_METHOD		
       ,CMP_TESTMETHOD	
       ,AGING			
       ,PREPARATION		
       ,PARAMETERGROUP	
       ,MACHINE_ID		
	   ,TECH_INSERT_DATUM
	   ,TECH_UPDATE_DATUM
	   ,USER_LAATSTE_WIJZ
	   ,TECH_PROGRAM
	   ,TECH_UPDATE_ATTR ) values (:new.AV_METHOD
	                        ,:new.CMP_TESTMETHOD	
							,:new.AGING			
							,:new.PREPARATION		
							,:new.PARAMETERGROUP	
							,:new.MACHINE_ID		
							,l_tech_insert_datum
							,to_date(null)
							,l_user_laatste_wijz
							,l_tech_program
							,l_tech_update_attr);
    exception
      when others then null;
    end;	  
  end if;
  --
  if UPDATING
  then l_tech_update_datum := sysdate;
  end if;
  if UPDATING
  then --PLANT
	   --PART_NO
	   l_update_attr := to_char(l_tech_update_datum,'dd-mm-yyyy hh24:mi:ss');
	   --
	   if (updating('AV_METHOD')) 
	   then l_update_attr := l_update_attr||'(AV_METHOD:'||:old.AV_METHOD||' to '||:new.AV_METHOD||');';
	   end if;
	   if (updating('CMP_TESTMETHOD')) 
	   then l_update_attr := l_update_attr||'(CMP_TESTMETHOD:'||:old.CMP_TESTMETHOD||' to '||:new.CMP_TESTMETHOD||');';
	   end if;
	   if (updating('AGING')) 
	   then l_update_attr := l_update_attr||'(AGING:'||:old.AGING||' to '||:new.AGING||');';
	   end if;
	   if (updating('PREPARATION')) 
	   then l_update_attr := l_update_attr||'(PREPARATION:'||:old.PREPARATION||' to '||:new.PREPARATION||');';
	   end if;
  	   if (updating('PARAMETERGROUP')) 
	   then l_update_attr := l_update_attr||'(PARAMETERGROUP:'||:old.PARAMETERGROUP||' to '||:new.PARAMETERGROUP||');';
	   end if;
  	   if (updating('MACHINE_ID')) 
	   then l_update_attr := l_update_attr||'(MACHINE_ID:'||:old.MACHINE_ID||' to '||:new.MACHINE_ID||');';
	   end if;
	   --
       l_tech_update_attr := substr(l_tech_update_attr||'#'||l_update_attr,1,4000);       
	   --
	   begin
	   update VRE.TESTMETHODS_MUTLOG
	      set AV_METHOD         = :new.AV_METHOD
	      ,   CMP_TESTMETHOD    = :new.CMP_TESTMETHOD
          ,   AGING             = :new.AGING
          ,   PREPARATION       = :new.PREPARATION
          ,   PARAMETERGROUP    = :new.PARAMETERGROUP
          ,   MACHINE_ID        = :new.MACHINE_ID
          ,   TECH_UPDATE_DATUM = l_tech_update_datum
          ,   USER_LAATSTE_WIJZ = l_user_laatste_wijz
          ,   TECH_PROGRAM      = l_tech_program
          ,   TECH_UPDATE_ATTR  = TECH_UPDATE_ATTR||'#'||l_tech_update_attr
          WHERE AV_METHOD = :old.AV_METHOD
		  ;
    exception
      when others then null;
    end;	  
  end if;
  --
EXCEPTION
  when others 
  then null;  
END;
/



/*
--test
--test
delete from vre.TESTMETHODS   where av_method='peter';
delete from vre.TESTMETHODS_MUTLOG where av_method='peter';
--
insert into vre.TESTMETHODS (av_method ) values ('peter' );
select * from vre.TESTMETHODS where av_method='peter';
select * from vre.TESTMETHODS_MUTLOG where av_method='peter';
commit;
--
update vre.TESTMETHODS set aging=-1 where av_method='peter';
select * from vre.TESTMETHODS where av_method='peter';
select * from vre.TESTMETHODS_MUTLOG where av_method='peter';
commit;
--ok

*/











--EINDE SCRIPT
		  
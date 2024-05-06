--Script om een aantal TECH-attributes aan tabel = VRE.TESTLIMITS + VRE.TESTVARIABLES toe te voegen
--om vanuit beheer beter te kunnen zien wat er gebeurt op deze tabel...

--dd. 08-12-2022 15:50 UUR: Wijziging uitgerold naar TEST + PROD !!!!

descr VRE.TESTLIMITS;
/*
Name      Null?    Type              
--------- -------- ----------------- 
U_RECIPE  NOT NULL VARCHAR2(15 CHAR) 
U_VERSION NOT NULL VARCHAR2(3 CHAR)  
AV_METHOD NOT NULL VARCHAR2(10 CHAR) 
TAG       NOT NULL NUMBER(5)         
TARGET             FLOAT(63)         
LSL                FLOAT(63)         
LWL                FLOAT(63)         
UWL                FLOAT(63)         
USL                FLOAT(63)    
*/

descr VRE.TESTVARIABLES
/*
Name            Null?    Type              
--------------- -------- ----------------- 
AV_METHOD       NOT NULL VARCHAR2(40 CHAR) 
PROPERTY                 NUMBER            
DAISY_NR        NOT NULL NUMBER            
UN_METHOD                VARCHAR2(20 CHAR) 
METHOD_CELL              VARCHAR2(20 CHAR) 
PROPERTYNAME             VARCHAR2(40 CHAR) 
PARAMETER                VARCHAR2(20 CHAR) 
ARRAYNAME                VARCHAR2(20 CHAR) 
MONTECH_TAGNR            NUMBER            
MONTECH_TAGNAME          VARCHAR2(30 CHAR) 
MONTECH_UOM              VARCHAR2(10 CHAR) 
MONTECH_FACTOR           FLOAT(63)   
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

create table vre.testlimits_mutlog as select * from vre.testlimits;
CREATE INDEX vre.TESTLIMITS_MUTLOG_IX    ON VRE.TESTLIMITS_MUTLOG (U_RECIPE, U_VERSION, AV_METHOD, TAG) TABLESPACE  SPECD ;
--
create table vre.testvariables_mutlog as select * from vre.testvariables;
CREATE INDEX VRE.TESTVARIABLES_MUTLOG_IX ON VRE.TESTVARIABLES_MUTLOG (DAISY_NR, AV_METHOD) TABLESPACE  SPECD;
--
--connect VRE/VRE@IS61
grant select,insert,update,delete on vre.testlimits_mutlog to interspc with grant option;
grant select,insert,update,delete on vre.testvariables_mutlog to interspc with grant option;
--
grant select,insert,update,delete on vre.testlimits    to interspc with grant option;
grant select,insert,update,delete on vre.testvariables to interspc with grant option;


--VOEG TECH-ATTRIBUTES AAN MUTLOG-TABELLEN TOE...
--
alter table vre.testlimits_mutlog add tech_insert_datum date;
alter table vre.testlimits_mutlog add tech_update_datum date;
alter table vre.testlimits_mutlog add user_laatste_wijz varchar2(100);
alter table vre.testlimits_mutlog add tech_program     varchar2(4000);
alter table vre.testlimits_mutlog add tech_update_attr varchar2(4000);
--
alter table vre.testvariables_mutlog add tech_insert_datum date;
alter table vre.testvariables_mutlog add tech_update_datum date;
alter table vre.testvariables_mutlog add user_laatste_wijz varchar2(100);
alter table vre.testvariables_mutlog add tech_program     varchar2(4000);
alter table vre.testvariables_mutlog add tech_update_attr varchar2(4000);



select count(*) from vre.testlimits;
select count(*) from vre.testlimits_mutlog;

select count(*) from vre.testvariables;
select count(*) from vre.testvariables_mutlog;

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

--De trigger blijft wel op de BASIS-TABEL ZITTEN, en van daaruit worden mutaties naar kopie-mutatie-log-tabel 
--overgezet!!. 
CREATE OR REPLACE TRIGGER interspc.TESTLIMITS_BRIU
BEFORE INSERT OR UPDATE ON VRE.TESTLIMITS
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
	  insert into vre.TESTLIMITS_MUTLOG
	   (U_RECIPE
       ,U_VERSION
       ,AV_METHOD
       ,TAG
       ,TARGET
       ,LSL
       ,LWL
       ,UWL
       ,USL
	   ,TECH_INSERT_DATUM
	   ,TECH_UPDATE_DATUM
	   ,USER_LAATSTE_WIJZ
	   ,TECH_PROGRAM
	   ,TECH_UPDATE_ATTR ) values (:new.U_RECIPE
	                        ,:new.U_VERSION
							,:new.AV_METHOD
							,:new.TAG
							,:new.TARGET
							,:new.LSL
							,:new.LWL
							,:new.UWL
							,:new.USL
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
	   if (updating('U_RECIPE')) 
	   then l_update_attr := l_update_attr||'(U_RECIPE:'||:old.U_RECIPE||' to '||:new.U_RECIPE||');';
	   end if;
	   if (updating('U_VERSION')) 
	   then l_update_attr := l_update_attr||'(U_VERSION:'||:old.U_VERSION||' to '||:new.U_VERSION||');';
	   end if;
	   if (updating('AV_METHOD')) 
	   then l_update_attr := l_update_attr||'(AV_METHOD:'||:old.AV_METHOD||' to '||:new.AV_METHOD||');';
	   end if;
	   if (updating('TAG')) 
	   then l_update_attr := l_update_attr||'(TAG:'||:old.TAG||' to '||:new.TAG||');';
	   end if;
  	   if (updating('TARGET')) 
	   then l_update_attr := l_update_attr||'(TARGET:'||:old.TARGET||' to '||:new.TARGET||');';
	   end if;
  	   if (updating('LSL')) 
	   then l_update_attr := l_update_attr||'(LSL:'||:old.LSL||' to '||:new.LSL||');';
	   end if;
  	   if (updating('LWL')) 
	   then l_update_attr := l_update_attr||'(LWL:'||:old.LWL||' to '||:new.LWL||');';
	   end if;
  	   if (updating('UWL')) 
	   then l_update_attr := l_update_attr||'(UWL:'||:old.UWL||' to '||:new.UWL||');';
	   end if;
  	   if (updating('USL')) 
	   then l_update_attr := l_update_attr||'(USL:'||:old.USL||' to '||:new.USL||');';
	   end if;
	   --
       l_tech_update_attr := substr(l_tech_update_attr||'#'||l_update_attr,1,4000);       
	   --
	   begin
	   update VRE.TESTLIMITS_MUTLOG
	      set U_RECIPE       = :new.U_RECIPE
	      ,   U_VERSION     = :new.U_VERSION
          ,   AV_METHOD    = :new.AV_METHOD
          ,   TAG    = :new.TAG
          ,   TARGET = :new.TARGET
          ,   LSL      = :new.LSL
          ,   LWL      = :new.LWL
          ,   UWL      = :new.UWL
          ,   USL      = :new.USL
          ,   TECH_UPDATE_DATUM = l_tech_update_datum
          ,   USER_LAATSTE_WIJZ = l_user_laatste_wijz
          ,   TECH_PROGRAM      = l_tech_program
          ,   TECH_UPDATE_ATTR  = l_tech_update_attr
          WHERE U_RECIPE  = :old.U_RECIPE
		  and   U_VERSION = :old.U_VERSION
		  and   AV_METHOD = :old.AV_METHOD
		  and   TAG       = :old.tag
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
delete from vre.testlimits_mutlog   where u_recipe='peter';
delete from vre.testlimits_mutlog where u_recipe='peter';
--
insert into vre.testlimits (u_recipe, u_version, av_method, tag ) values ('peter' ,'001', 'peter' ,'-1' );
select * from vre.testlimits where u_recipe='peter';
select * from vre.testlimits_mutlog where u_recipe='peter';
commit;
--
update vre.testlimits set target=-1 where u_recipe='peter';
select * from vre.testlimits where u_recipe='peter';
select * from vre.testlimits_mutlog where u_recipe='peter';
commit;
--ok
*/



CREATE OR REPLACE TRIGGER interspc.TESTVARIABLES_BRIU
BEFORE INSERT OR UPDATE ON VRE.TESTVARIABLES
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
	  insert into vre.TESTVARIABLES_MUTLOG
	   (AV_METHOD
       ,PROPERTY
       ,DAISY_NR
       ,UN_METHOD
       ,METHOD_CELL
       ,PROPERTYNAME
       ,PARAMETER 
       ,ARRAYNAME 
       ,MONTECH_TAGNR
       ,MONTECH_TAGNAME
       ,MONTECH_UOM
       ,MONTECH_FACTOR 
	   ,TECH_INSERT_DATUM
	   ,TECH_UPDATE_DATUM
	   ,USER_LAATSTE_WIJZ
	   ,TECH_PROGRAM
	   ,TECH_UPDATE_ATTR ) values (:new.AV_METHOD
	                        ,:new.PROPERTY
							,:new.DAISY_NR
							,:new.UN_METHOD
							,:new.METHOD_CELL
							,:new.PROPERTYNAME
							,:new.PARAMETER
							,:new.ARRAYNAME
							,:new.MONTECH_TAGNR
							,:new.MONTECH_TAGNAME
							,:new.MONTECH_UOM
							,:new.MONTECH_FACTOR
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
	   if (updating('PROPERTY')) 
	   then l_update_attr := l_update_attr||'(PROPERTY:'||:old.PROPERTY||' to '||:new.PROPERTY||');';
	   end if;
	   if (updating('DAISY_NR')) 
	   then l_update_attr := l_update_attr||'(DAISY_NR:'||:old.DAISY_NR||' to '||:new.DAISY_NR||');';
	   end if;
	   if (updating('UN_METHOD')) 
	   then l_update_attr := l_update_attr||'(UN_METHOD:'||:old.UN_METHOD||' to '||:new.UN_METHOD||');';
	   end if;
  	   if (updating('METHOD_CELL')) 
	   then l_update_attr := l_update_attr||'(METHOD_CELL:'||:old.METHOD_CELL||' to '||:new.METHOD_CELL||');';
	   end if;
  	   if (updating('PROPERTYNAME')) 
	   then l_update_attr := l_update_attr||'(PROPERTYNAME:'||:old.PROPERTYNAME||' to '||:new.PROPERTYNAME||');';
	   end if;
  	   if (updating('PARAMETER')) 
	   then l_update_attr := l_update_attr||'(PARAMETER:'||:old.PARAMETER||' to '||:new.PARAMETER||');';
	   end if;
  	   if (updating('ARRAYNAME')) 
	   then l_update_attr := l_update_attr||'(ARRAYNAME:'||:old.ARRAYNAME||' to '||:new.ARRAYNAME||');';
	   end if;
  	   if (updating('MONTECH_TAGNR')) 
	   then l_update_attr := l_update_attr||'(MONTECH_TAGNR:'||:old.MONTECH_TAGNR||' to '||:new.MONTECH_TAGNR||');';
	   end if;
  	   if (updating('MONTECH_TAGNAME')) 
	   then l_update_attr := l_update_attr||'(MONTECH_TAGNAME:'||:old.MONTECH_TAGNAME||' to '||:new.MONTECH_TAGNAME||');';
	   end if;
  	   if (updating('MONTECH_UOM')) 
	   then l_update_attr := l_update_attr||'(MONTECH_UOM:'||:old.MONTECH_UOM||' to '||:new.MONTECH_UOM||');';
	   end if;
  	   if (updating('MONTECH_FACTOR')) 
	   then l_update_attr := l_update_attr||'(MONTECH_FACTOR:'||:old.MONTECH_FACTOR||' to '||:new.MONTECH_FACTOR||');';
	   end if;
	   --
       l_tech_update_attr := substr(l_tech_update_attr||'#'||l_update_attr,1,4000);       
	   --
	   begin
	   update VRE.TESTVARIABLES_MUTLOG
	      set AV_METHOD       = :new.AV_METHOD
	      ,   PROPERTY        = :new.PROPERTY
          ,   DAISY_NR       = :new.DAISY_NR
          ,   UN_METHOD           = :new.UN_METHOD
          ,   METHOD_CELL       = :new.METHOD_CELL
          ,   PROPERTYNAME      = :new.PROPERTYNAME
          ,   PARAMETER      = :new.PARAMETER
          ,   ARRAYNAME      = :new.ARRAYNAME
          ,   MONTECH_TAGNR      = :new.MONTECH_TAGNR
          ,   MONTECH_TAGNAME      = :new.MONTECH_TAGNAME
          ,   MONTECH_UOM      = :new.MONTECH_UOM
          ,   MONTECH_FACTOR      = :new.MONTECH_FACTOR
          ,   TECH_UPDATE_DATUM = l_tech_update_datum
          ,   USER_LAATSTE_WIJZ = l_user_laatste_wijz
          ,   TECH_PROGRAM      = l_tech_program
          ,   TECH_UPDATE_ATTR  = l_tech_update_attr
          WHERE DAISY_NR  = :old.DAISY_NR
		  and   AV_METHOD = :old.AV_METHOD
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
delete from vre.testvariables   where av_method='peter';
delete from vre.testvariables_mutlog where av_method='peter';
--
insert into vre.testvariables (av_method, daisy_nr ) values ('peter' ,'-1');
select * from vre.testvariables where av_method='peter';
select * from vre.testvariables_mutlog where av_method='peter';
commit;
--
update vre.testvariables set parameter=-1 where av_method='peter';
select * from vre.testvariables where av_method='peter';
select * from vre.testvariables_mutlog where av_method='peter';
commit;
--ok

--ok
*/











--EINDE SCRIPT
		  
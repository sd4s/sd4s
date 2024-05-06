--Script om een aantal TECH-attributes aan tabel = UNILAB.ATAVPROJECTS
--om vanuit beheer beter te kunnen zien wat er gebeurt op deze tabel...

--dd. 08-12-2022 15:50 UUR: Wijziging uitgerold naar TEST + PROD !!!!

descr UNILAB.ATAVPROJECTS;
/*
Name      Null?    Type              
--------- -------- ----------------- 
PROJECT		VARCHAR2(10 CHAR)	No		1	
DESCRIPTION	VARCHAR2(40 CHAR)	Yes		2	 
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

 
--backup COPY-TABEL AANMAKEN VOOR ATAVPROJECTS

create table unilab.atavprojects_mutlog as select * from unilab.atavprojects;
CREATE INDEX unilab.atavprojects_mutlog_ix  ON unilab.ATAVPROJECTS_MUTLOG (PROJECT) TABLESPACE UNI_INDEXO;
--
--connect unilab/moonflower@U611
grant select,insert,update,delete on unilab.atavprojects_mutlog to unilab with grant option;

--VOEG TECH-ATTRIBUTES AAN MUTLOG-TABELLEN TOE...
alter table unilab.atavprojects_mutlog add tech_insert_datum date;
alter table unilab.atavprojects_mutlog add tech_update_datum date;
alter table unilab.atavprojects_mutlog add user_laatste_wijz varchar2(100);
alter table unilab.atavprojects_mutlog add tech_program     varchar2(4000);
alter table unilab.atavprojects_mutlog add tech_update_attr varchar2(4000);

select count(*) from unilab.atavprojects;
select count(*) from unilab.atavprojects_mutlog;

/*
--*************************************************************************
--*************************************************************************
--SCENARIO-1: VOEG ALLEEN TRIGGER AAN BESTAANDE TABEL TOE...
--*************************************************************************
--*************************************************************************
--drop TRIGGER ATAVPROJECTS_BRIU;
--

--SCENARIO-1B: VOEG NIEUWE TRIGGERS TOE OP HUIDIGE-TABEL OM COPY-TABEL (MET TECH-COLUMNS) TE VULLEN...
--             EN VOEG NIEUWE TRIGGER OP NIEUWE COPY-TABEL TOE OM TECH-COLUMNS TE VULLEN...
--
*/

--De trigger blijft wel op de BASIS-TABEL ZITTEN, en van daaruit worden mutaties naar kopie-mutatie-log-tabel 
--overgezet!!. 
CREATE OR REPLACE TRIGGER unilab.ATAVPROJECTS_BRIU
BEFORE INSERT OR UPDATE ON UNILAB.ATAVPROJECTS
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
	  insert into unilab.ATAVPROJECTS_MUTLOG
	   (PROJECT
	   ,DESCRIPTION
	   ,TECH_INSERT_DATUM
	   ,TECH_UPDATE_DATUM
	   ,USER_LAATSTE_WIJZ
	   ,TECH_PROGRAM
	   ,TECH_UPDATE_ATTR ) 
	   values (:new.PROJECT
              ,:new.DESCRIPTION
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
  then --project
       l_update_attr := to_char(l_tech_update_datum,'dd-mm-yyyy hh24:mi:ss');
	   --
	   if (updating('PROJECT')) 
	   then l_update_attr := l_update_attr||'(PROJECT:'||:old.PROJECT||' to '||:new.PROJECT||');';
	   end if;
	   if (updating('DESCRIPTION')) 
	   then l_update_attr := l_update_attr||'(DESCRIPTION:'||:old.DESCRIPTION||' to '||:new.DESCRIPTION||');';
	   end if;
	   --
       l_tech_update_attr := substr(l_tech_update_attr||'#'||l_update_attr,1,4000);       
	   --
	   begin
	   update unilab.ATAVPROJECTS_MUTLOG
	      set PROJECT       = :new.PROJECT
	      ,   DESCRIPTION   = :new.DESCRIPTION
          ,   TECH_UPDATE_DATUM = l_tech_update_datum
          ,   USER_LAATSTE_WIJZ = l_user_laatste_wijz
          ,   TECH_PROGRAM      = l_tech_program
          ,   TECH_UPDATE_ATTR  = l_tech_update_attr
          WHERE PROJECT  = :old.PROJECT
		  AND   DESCRIPTION = :old.DESCRIPTION
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

CREATE OR REPLACE TRIGGER unilab.ATAVPROJECTS_BRD
BEFORE DELETE ON UNILAB.ATAVPROJECTS
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
declare
l_sessionid   number;
l_program     varchar2(4000);
l_tech_delete_datum date;
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
  if DELETING
  then 
    l_tech_delete_datum := sysdate;
	l_tech_update_attr := substr(' (PROJECT:'||:new.PROJECT||'=DELETED )',1,4000);      
    --
	begin
	  insert into unilab.ATAVPROJECTS_MUTLOG
	   (PROJECT
	   ,DESCRIPTION
	   ,TECH_INSERT_DATUM
	   ,TECH_UPDATE_DATUM
	   ,USER_LAATSTE_WIJZ
	   ,TECH_PROGRAM
	   ,TECH_UPDATE_ATTR ) 
	   values (:old.PROJECT
              ,:old.DESCRIPTION
			  ,l_tech_delete_datum
			  ,to_date(null)
			  ,l_user_laatste_wijz
			  ,l_tech_program
			  ,l_tech_update_attr);
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
--
insert into unilab.atavprojects (project, description ) values ('peter' ,'peter-descr');

select * from unilab.atavprojects        where project='peter';
select * from unilab.atavprojects_mutlog where project='peter';
commit;
--
update unilab.atavprojects set description = 'peter-descr-upd' where project='peter';
select * from unilab.atavprojects        where project='peter';
select * from unilab.atavprojects_mutlog where project='peter';
commit;
--
delete from unilab.atavprojects where project='peter';
select * from unilab.atavprojects        where project='peter';
select * from unilab.atavprojects_mutlog where project='peter';


--ok
*/











--EINDE SCRIPT
		  
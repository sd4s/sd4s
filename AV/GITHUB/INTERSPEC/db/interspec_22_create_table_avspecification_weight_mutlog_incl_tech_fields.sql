--Script om een aantal TECH-attributes aan tabel = AVSPECIFICATION_WEIGHT toe te voegen
--om vanuit beheer beter te kunnen zien wat er gebeurt op deze tabel...

--dd. 08-12-2022 15:50 UUR: Wijziging uitgerold naar TEST + PROD !!!!

descr avspecification_weight;
/*
Name        Null?    Type              
----------- -------- ----------------- 
PLANT                VARCHAR2(4 CHAR)  
PART_NO     NOT NULL VARCHAR2(18 CHAR) 
REVISION             NUMBER(5)         
BASE_UOM             VARCHAR2(5 CHAR)  
STATUS_TYPE          VARCHAR2(20 CHAR) 
KMGKOD               VARCHAR2(2 CHAR)  
ARTKOD               VARCHAR2(15 CHAR) 
SAP_ARTICLE          VARCHAR2(18 CHAR) 
WEIGHT               NUMBER(20,8)      
UOM                  VARCHAR2(5 CHAR)  
STATUS               NUMBER(5)         
DA_ARTICLE           VARCHAR2(18 CHAR) 
*/

/*
--IK HAD EERST TECH-ATTRIBUTES AAN TABEL ZELF TOEGEVOEGD....
--DAT HAD MOGELIJK BIJWERKINGEN VANUIT DE INTERSPEC-SAP-WEIGHT-INTERFACE.
--DEZE TABEL WORDEN LATER WEER VERWIJDERD.
--
alter table avspecification_weight add tech_insert_datum date;
alter table avspecification_weight add tech_update_datum date;
alter table avspecification_weight add user_laatste_wijz varchar2(100);
alter table avspecification_weight add tech_program     varchar2(4000);
alter table avspecification_weight add tech_update_attr varchar2(4000);
*/

--OPTIE: alleen vanaf oracle12c, dus hebben we nu niets aan...:
--ALTER TABLE avspecification_weight MODIFY user_laatste_wijz INVISIBLE;

/*
--Oorspronkelijke trigger waar TECH-ATTRIBUTES aan de basis-tabel zijn toegevoegd.
--Is vanaf 15-12-2022 vervangen door constructie met AVSPECIFICATION-WEIGHT-MUTLOG-tabel...
--
CREATE OR REPLACE TRIGGER "INTERSPC"."AVSPEC_WEIGHT_BRIU" 
BEFORE INSERT OR UPDATE ON INTERSPC.AVSPECIFICATION_WEIGHT
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
	  insert into AVSPECIFICATION_WEIGHT_MUTLOG
	   (PLANT      
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
	   ,TECH_INSERT_DATUM
	   ,TECH_UPDATE_DATUM
	   ,USER_LAATSTE_WIJZ
	   ,TECH_PROGRAM
	   ,TECH_UPDATE_ATTR ) values (:new.plant
	                        ,:new.part_no
							,:new.revision
							,:new.base_uom
							,:new.status_type
							,:new.kmgkod
							,:new.artkod
							,:new.sap_article
							,:new.weight
							,:new.uom
							,:new.status
							,:new.da_article
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
	   if (updating('PLANT')) 
	   then l_update_attr := l_update_attr||'(PLANT:'||:old.plant||' to '||:new.plant||');';
	   end if;
	   if (updating('PART_NO')) 
	   then l_update_attr := l_update_attr||'(PART_NO:'||:old.part_no||' to '||:new.part_no||');';
	   end if;
	   if (updating('REVISION')) 
	   then l_update_attr := l_update_attr||'(REVISION:'||:old.revision||' to '||:new.revision||');';
	   end if;
	   if (updating('BASE_UOM')) 
	   then l_update_attr := l_update_attr||'(BASE_UOM:'||:old.base_uom||' to '||:new.base_uom||');';
	   end if;
  	   if (updating('STATUS_TYPE')) 
	   then l_update_attr := l_update_attr||'(STATUS_TYPE:'||:old.STATUS_TYPE||' to '||:new.STATUS_TYPE||');';
	   end if;
  	   if (updating('KMGKOD')) 
	   then l_update_attr := l_update_attr||'(KMGKOD:'||:old.KMGKOD||' to '||:new.KMGKOD||');';
	   end if;
  	   if (updating('ARTKOD')) 
	   then l_update_attr := l_update_attr||'(ARTKOD:'||:old.ARTKOD||' to '||:new.ARTKOD||');';
	   end if;
  	   if (updating('SAP_ARTICLE')) 
	   then l_update_attr := l_update_attr||'(SAP_ARTICLE:'||:old.SAP_ARTICLE||' to '||:new.SAP_ARTICLE||');';
	   end if;
  	   if (updating('WEIGHT')) 
	   then l_update_attr := l_update_attr||'(WEIGHT:'||:old.WEIGHT||' to '||:new.WEIGHT||');';
	   end if;
  	   if (updating('UOM')) 
	   then l_update_attr := l_update_attr||'(UOM:'||:old.UOM||' to '||:new.UOM||');';
	   end if;
  	   if (updating('STATUS')) 
	   then l_update_attr := l_update_attr||'(STATUS:'||:old.STATUS||' to '||:new.STATUS||');';
	   end if;
       --DA_ARTICLE    
       l_tech_update_attr := substr(l_tech_update_attr||'#'||l_update_attr,1,4000);       
	   --
	   begin
	   update AVSPECIFICATION_WEIGHT_MUTLOG
	      set PLANT       = :new.plant
	      ,   PART_NO     = :new.part_no
          ,   REVISION    = :new.revision
          ,   BASE_UOM    = :new.base_uom
          ,   STATUS_TYPE = :new.status_type
          ,   KMGKOD      = :new.kmgkod
          ,   ARTKOD      = :new.artkod
          ,   SAP_ARTICLE = :new.sap_article
          ,   WEIGHT      = :new.weight
          ,   UOM         = :new.uom
          ,   STATUS      = :new.status
          ,   DA_ARTICLE  = :new.da_article
          ,   TECH_UPDATE_DATUM = l_tech_update_datum
          ,   USER_LAATSTE_WIJZ = l_user_laatste_wijz
          ,   TECH_PROGRAM      = l_tech_program
          ,   TECH_UPDATE_ATTR  = l_tech_update_attr
          WHERE part_no = :old.part_no
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

*/



/*
CREATE OR REPLACE TRIGGER AVSPEC_WEIGHT_BRIU
BEFORE INSERT OR UPDATE ON INTERSPC.AVSPECIFICATION_WEIGHT
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
declare
l_sessionid   number;
l_program     varchar2(4000);
l_update_attr varchar2(4000);
BEGIN
  :new.user_laatste_wijz := user;
  begin
    SELECT SYS_CONTEXT ('USERENV', 'SESSIONID') into l_sessionid FROM DUAL;
	--
	select machine||':'||module||':'||program 
	into l_program 
	from v$session 
	where audsid=l_sessionid;
	--
	:new.tech_program := l_program;
	--
  exception
    when others then null;  
  end;
  if INSERTING
  then if :new.tech_insert_datum is null
       then :new.tech_insert_datum := sysdate;
	   end if;
  end if;
  --
  if UPDATING
  then if :new.tech_update_datum is null
       then :new.tech_update_datum := sysdate;
	   end if;
  end if;
  if UPDATING
  then --PLANT
	   --PART_NO
	   l_update_attr := to_char(:new.tech_update_datum,'dd-mm-yyyy hh24:mi:ss');
	   --
	   if (updating('PLANT')) 
	   then l_update_attr := l_update_attr||'(PLANT:'||:old.plant||' to '||:new.plant||');';
	   end if;
	   if (updating('PART_NO')) 
	   then l_update_attr := l_update_attr||'(PART_NO:'||:old.part_no||' to '||:new.part_no||');';
	   end if;
	   if (updating('REVISION')) 
	   then l_update_attr := l_update_attr||'(REVISION:'||:old.revision||' to '||:new.revision||');';
	   end if;
	   if (updating('BASE_UOM')) 
	   then l_update_attr := l_update_attr||'(BASE_UOM:'||:old.base_uom||' to '||:new.base_uom||');';
	   end if;
  	   if (updating('STATUS_TYPE')) 
	   then l_update_attr := l_update_attr||'(STATUS_TYPE:'||:old.STATUS_TYPE||' to '||:new.STATUS_TYPE||');';
	   end if;
  	   if (updating('KMGKOD')) 
	   then l_update_attr := l_update_attr||'(KMGKOD:'||:old.KMGKOD||' to '||:new.KMGKOD||');';
	   end if;
  	   if (updating('ARTKOD')) 
	   then l_update_attr := l_update_attr||'(ARTKOD:'||:old.ARTKOD||' to '||:new.ARTKOD||');';
	   end if;
  	   if (updating('SAP_ARTICLE')) 
	   then l_update_attr := l_update_attr||'(SAP_ARTICLE:'||:old.SAP_ARTICLE||' to '||:new.SAP_ARTICLE||');';
	   end if;
  	   if (updating('WEIGHT')) 
	   then l_update_attr := l_update_attr||'(WEIGHT:'||:old.WEIGHT||' to '||:new.WEIGHT||');';
	   end if;
  	   if (updating('UOM')) 
	   then l_update_attr := l_update_attr||'(UOM:'||:old.UOM||' to '||:new.UOM||');';
	   end if;
       --STATUS
  	   if (updating('STATUS')) 
	   then l_update_attr := l_update_attr||'(STATUS:'||:old.STATUS||' to '||:new.STATUS||');';
	   end if;
       --DA_ARTICLE    
	   --
       :new.tech_update_attr := substr(:old.tech_update_attr||'#'||l_update_attr,1,4000);       
	   --
  end if;
  --
EXCEPTION
  when others 
  then :new.tech_update_attr := substr(:old.tech_update_attr||'#'||substr(sqlerrm,1,2000),1,4000) ;  
END;
/
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

--CONCLUSIE: De TABEL AVSPECIFICATION_WEIGHT wordt ook GEREPLICEERD naar AWS-REDSHIFT. 
--           Dat betekent dat ook ATHENA hier rechtstreeks data/gewichten uit haalt (weet alleen niet voor welk report, zit nl. geen alternatives in )!!!
--
--ONDERZOEK: AWS-TEST bevat wel deze tabel AVSPECIFICATION_WEIGHT, ECHTER zonder de NIEUWE attributen !!!!
--           AWS-PROD bevat HELEMAAL NIET de tabel AVSPECIFICATION_WEIGHT !!!!!!!!!!! Deze is er dus blijkbaar ergens tussendoor geslipped...



 
--backup COPY-TABEL AANMAKEN VOOR AVSPECIFICATION_WEIGHT 

create table avspecification_weight_tmp as select * from AVSPECIFICATION_WEIGHT;
create table avspecification_weight_mutlog as select * from AVSPECIFICATION_WEIGHT;
--
CREATE INDEX INTERSPC.AVSPEC_WEIGHT_MUTLOG_PARTNO_IX ON INTERSPC.AVSPECIFICATION_WEIGHT_MUTLOG (PART_NO) TABLESPACE  SPECD ;
CREATE INDEX INTERSPC.AVSPEC_WEIGHT_MUTLOG_SAPART_IX ON INTERSPC.AVSPECIFICATION_WEIGHT_MUTLOG (SAP_ARTICLE) TABLESPACE  SPECD;
--
select count(*) from avspecification_weight;
select count(*) from avspecification_weight_tmp;
select count(*) from avspecification_weight_mutlog;

descr avspecification_weight;
/*
Name        Null?    Type              
----------- -------- ----------------- 
PLANT                VARCHAR2(4 CHAR)  
PART_NO     NOT NULL VARCHAR2(18 CHAR) 
REVISION             NUMBER(5)         
BASE_UOM             VARCHAR2(5 CHAR)  
STATUS_TYPE          VARCHAR2(20 CHAR) 
KMGKOD               VARCHAR2(2 CHAR)  
ARTKOD               VARCHAR2(15 CHAR) 
SAP_ARTICLE          VARCHAR2(18 CHAR) 
WEIGHT               NUMBER(20,8)      
UOM                  VARCHAR2(5 CHAR)  
STATUS               NUMBER(5)         
DA_ARTICLE           VARCHAR2(18 CHAR) 
*/

--*************************************************************************
--*************************************************************************
--SCENARIO-1: verwijder TECH-COLUMNS + TRIGGER van oude TABEL
--*************************************************************************
--*************************************************************************
--drop TRIGGER AVSPEC_WEIGHT_BRIU;
--
alter table avspecification_weight drop column tech_insert_datum ;
alter table avspecification_weight drop column  tech_update_datum ;
alter table avspecification_weight drop column user_laatste_wijz ;
alter table avspecification_weight drop column  tech_program ;
alter table avspecification_weight drop column tech_update_attr ;
--
--alter table avspecification_weight_tmp2 drop column tech_insert_datum ;
--alter table avspecification_weight_tmp2 drop column  tech_update_datum ;
--alter table avspecification_weight_tmp2 drop column user_laatste_wijz ;
--alter table avspecification_weight_tmp2 drop column  tech_program ;
--alter table avspecification_weight_tmp2 drop column tech_update_attr ;


--SCENARIO-1B: VOEG NIEUWE TRIGGERS TOE OP OUDE-TABEL OM COPY-TABEL (MET TECH-COLUMNS) TE VULLEN...
--             EN VOEG NIEUWE TRIGGER OP NIEUWE COPY-TABEL TOE OM TECH-COLUMNS TE VULLEN...
--

--De trigger blijft wel op de BASIS-TABEL ZITTEN, en van daaruit worden mutaties naar kopie-mutatie-log-tabel 
--overgezet!!. 
CREATE OR REPLACE TRIGGER AVSPEC_WEIGHT_BRIU
BEFORE INSERT OR UPDATE ON INTERSPC.AVSPECIFICATION_WEIGHT
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
	  insert into AVSPECIFICATION_WEIGHT_MUTLOG
	   (PLANT      
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
	   ,TECH_INSERT_DATUM
	   ,TECH_UPDATE_DATUM
	   ,USER_LAATSTE_WIJZ
	   ,TECH_PROGRAM
	   ,TECH_UPDATE_ATTR ) values (:new.plant
	                        ,:new.part_no
							,:new.revision
							,:new.base_uom
							,:new.status_type
							,:new.kmgkod
							,:new.artkod
							,:new.sap_article
							,:new.weight
							,:new.uom
							,:new.status
							,:new.da_article
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
	   if (updating('PLANT')) 
	   then l_update_attr := l_update_attr||'(PLANT:'||:old.plant||' to '||:new.plant||');';
	   end if;
	   if (updating('PART_NO')) 
	   then l_update_attr := l_update_attr||'(PART_NO:'||:old.part_no||' to '||:new.part_no||');';
	   end if;
	   if (updating('REVISION')) 
	   then l_update_attr := l_update_attr||'(REVISION:'||:old.revision||' to '||:new.revision||');';
	   end if;
	   if (updating('BASE_UOM')) 
	   then l_update_attr := l_update_attr||'(BASE_UOM:'||:old.base_uom||' to '||:new.base_uom||');';
	   end if;
  	   if (updating('STATUS_TYPE')) 
	   then l_update_attr := l_update_attr||'(STATUS_TYPE:'||:old.STATUS_TYPE||' to '||:new.STATUS_TYPE||');';
	   end if;
  	   if (updating('KMGKOD')) 
	   then l_update_attr := l_update_attr||'(KMGKOD:'||:old.KMGKOD||' to '||:new.KMGKOD||');';
	   end if;
  	   if (updating('ARTKOD')) 
	   then l_update_attr := l_update_attr||'(ARTKOD:'||:old.ARTKOD||' to '||:new.ARTKOD||');';
	   end if;
  	   if (updating('SAP_ARTICLE')) 
	   then l_update_attr := l_update_attr||'(SAP_ARTICLE:'||:old.SAP_ARTICLE||' to '||:new.SAP_ARTICLE||');';
	   end if;
  	   if (updating('WEIGHT')) 
	   then l_update_attr := l_update_attr||'(WEIGHT:'||:old.WEIGHT||' to '||:new.WEIGHT||');';
	   end if;
  	   if (updating('UOM')) 
	   then l_update_attr := l_update_attr||'(UOM:'||:old.UOM||' to '||:new.UOM||');';
	   end if;
       --STATUS
       --DA_ARTICLE    
       l_tech_update_attr := substr(l_tech_update_attr||'#'||l_update_attr,1,4000);       
	   --
	   begin
	   update AVSPECIFICATION_WEIGHT_MUTLOG
	      set PLANT       = :new.plant
	      ,   PART_NO     = :new.part_no
          ,   REVISION    = :new.revision
          ,   BASE_UOM    = :new.base_uom
          ,   STATUS_TYPE = :new.status_type
          ,   KMGKOD      = :new.kmgkod
          ,   ARTKOD      = :new.artkod
          ,   SAP_ARTICLE = :new.sap_article
          ,   WEIGHT      = :new.weight
          ,   UOM         = :new.uom
          ,   STATUS      = :new.status
          ,   DA_ARTICLE  = :new.da_article
          ,   TECH_UPDATE_DATUM = l_tech_update_datum
          ,   USER_LAATSTE_WIJZ = l_user_laatste_wijz
          ,   TECH_PROGRAM      = l_tech_program
          ,   TECH_UPDATE_ATTR  = TECH_UPDATE_ATTR||'@'||l_tech_update_attr
          WHERE part_no = :old.part_no
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
delete from avspecification_weight        where part_no='peter';
delete from avspecification_weight_mutlog where part_no='peter';
commit;
insert into avspecification_weight (plant, part_no) values ('1234' ,'peter');
select * from avspecification_weight where part_no='peter';
	peter											08-12-2022 15:30:15		INTERSPC
select * from avspecification_weight_mutlog where part_no='peter';

commit;
update avspecification_weight set revision=1, weight=50 where part_no='peter';
select * from avspecification_weight        where part_no='peter';
select * from avspecification_weight_mutlog where part_no='peter';
commit;
--ok
*/











--SCENARIO-2: RENAME OLD-TABLE, AND CREATE VIEW WITH SAME NAME ON TOP OF TABLE WITH TECH-FIELDS...
--            
RENAME TABLE AVSPECIFICATION_WEIGHT TO AVSPECIFICATION_WEIGHT_TAB

descr avspecification_weight;
/*
Name        Null?    Type              
----------- -------- ----------------- 
PLANT                VARCHAR2(4 CHAR)  
PART_NO     NOT NULL VARCHAR2(18 CHAR) 
REVISION             NUMBER(5)         
BASE_UOM             VARCHAR2(5 CHAR)  
STATUS_TYPE          VARCHAR2(20 CHAR) 
KMGKOD               VARCHAR2(2 CHAR)  
ARTKOD               VARCHAR2(15 CHAR) 
SAP_ARTICLE          VARCHAR2(18 CHAR) 
WEIGHT               NUMBER(20,8)      
UOM                  VARCHAR2(5 CHAR)  
STATUS               NUMBER(5)         
DA_ARTICLE           VARCHAR2(18 CHAR) 
*/
/*
create or replace view AVSPECIFICATION_WEIGHT 
(PLANT      
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
,DA_ARTICLE )
AS select PLANT      
,         PART_NO    
,         REVISION   
,         BASE_UOM   
,         STATUS_TYPE
,         KMGKOD     
,         ARTKOD     
,         SAP_ARTICLE
,         WEIGHT     
,         UOM        
,         STATUS     
,         DA_ARTICLE 
FROM AVSPECIFICATION_WEIGHT_TAB
;
*/



--*************************************************************************************************************
--INITEEL vullen van mutlog met data uit AVSPECIFICATION_WEIGHT, ANDERS GAAN UPDATE-STATEMENTS NIET GOED !!!!
--*************************************************************************************************************
insert into AVSPECIFICATION_WEIGHT_MUTLOG
	   (PLANT      
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
	   ,TECH_INSERT_DATUM
	   ,TECH_UPDATE_DATUM
	   ,USER_LAATSTE_WIJZ
	   ,TECH_PROGRAM
	   ,TECH_UPDATE_ATTR 
       ) 
select n.plant
,n.part_no
,n.revision
,n.base_uom
,n.status_type
,n.kmgkod
,n.artkod
,n.sap_article
,n.weight
,n.uom
,n.status
,n.da_article
,sysdate
,to_date(null)
,user
,''
,''
from avspecification_weight  n
;
COMMIT;


--end 
							
		  
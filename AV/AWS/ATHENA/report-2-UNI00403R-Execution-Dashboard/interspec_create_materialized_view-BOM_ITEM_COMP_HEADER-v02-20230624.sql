--Maak een materialized-view van BOM_ITEM !!!

select listagg(status,',') within group (order by status) from status where status_type='CURRENT' ;
--4,98,99,124,125,126,127,128,154,314,315
select listagg(status,',') within group (order by status) from status where status_type='HISTORIC' ;
--5

--**********************************************
--aanmaken MV-LOG-tables...ORACLEPROD_TEST
--**********************************************
CREATE MATERIALIZED VIEW LOG 
ON SPECIFICATION_HEADER 
PCTFREE 5
TABLESPACE USERS
WITH  PRIMARY KEY, ROWID
;                                         
CREATE MATERIALIZED VIEW LOG 
ON BOM_HEADER 
PCTFREE 5
TABLESPACE USERS
WITH  PRIMARY KEY, ROWID
;                                         
CREATE MATERIALIZED VIEW LOG 
ON BOM_ITEM 
PCTFREE 5
TABLESPACE USERS
WITH  PRIMARY KEY, ROWID
;          

--WELKE TABELLEN AANGEMAAKT:
select table_name from all_tables where table_name like 'MLOG%' ;
/*
MLOG$_BOM_HEADER
MLOG$_BOM_ITEM
MLOG$_SPECDATA
MLOG$_SPECIFICATION_HEADER
*/

select count(*) from MLOG$_BOM_HEADER;
--dd. 27-03-2023: 63797
select count(*) from MLOG$_BOM_ITEM;
--dd. 27-03-2023: 1277
select count(*) from MLOG$_SPECIFICATION_HEADER;
--dd. 27-03-2023: 74822

--**********************************************
--aanmaken MV-LOG-tables...ORACLEPROD
--**********************************************
CREATE MATERIALIZED VIEW LOG 
ON SPECIFICATION_HEADER 
PCTFREE 5
TABLESPACE SPECD
WITH  PRIMARY KEY, ROWID
;                                         
CREATE MATERIALIZED VIEW LOG 
ON BOM_HEADER 
PCTFREE 5
TABLESPACE SPECD
WITH  PRIMARY KEY, ROWID
;                                         
CREATE MATERIALIZED VIEW LOG 
ON BOM_ITEM 
PCTFREE 5
TABLESPACE SPECD
WITH  PRIMARY KEY, ROWID
;          
--WELKE TABELLEN AANGEMAAKT:
select table_name from all_tables where table_name like 'MLOG%' ;
MLOG$_BOM_HEADER
MLOG$_BOM_ITEM
MLOG$_SPECIFICATION_HEADER

select count(*) from MLOG$_BOM_HEADER;
--dd. 27-03-2023: 0
select count(*) from MLOG$_BOM_ITEM;
--dd. 27-03-2023: 0
select count(*) from MLOG$_SPECIFICATION_HEADER;
--dd. 27-03-2023: 0



/*
--create LEGE mv-group (mv worden later toegevoegd)
BEGIN
DBMS_REPCAT.CREATE_MVIEW_REPGROUP (
      gname => 'mv_full_bom_item_grp',
      master => 'is61',
      propagation_mode => 'ASYNCHRONOUS');
END;
/
--add mv to mv-group
BEGIN
DBMS_REPCAT.CREATE_MVIEW_REPOBJECT (
      gname => 'mv_full_bom_item_grp',
      sname => 'interspc',
      oname => 'MV_BOM_ITEM_COMP_HEADER',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/

--create REFRESH-GROUP voor alle mv binnen MV-group.
BEGIN
DBMS_REFRESH.MAKE (
      name => 'interspc.bi_refrgrp',
      list => '', 
      next_date => SYSDATE, 
      interval => 'SYSDATE + 1/24',
      implicit_destroy => FALSE, 
      rollback_seg => '',
      push_deferred_rpc => TRUE, 
      refresh_after_errors => FALSE);
END;
/
--add objects to refresh-group
--All of the materialized view group objects that you add to the refresh group are refreshed at the same time to preserve referential integrity between related materialized views.
BEGIN
DBMS_REFRESH.ADD (
      name => 'interspc.bi_refrgrp',
      list => 'interspc.MV_BOM_ITEM_COMP_HEADER',
      lax => TRUE);
END;
/
*/


--**********************************************
--AANMAKEN MV 
--**********************************************
DROP MATERIALIZED VIEW  "INTERSPC"."MV_BOM_ITEM_COMP_HEADER" ;
PURGE RECYCLEBIN;
/*
CREATE MATERIALIZED VIEW "INTERSPC"."MV_BOM_ITEM_COMP_HEADER" 
("PART_NO"
, "REVISION"
, "PLANT"
, "ALTERNATIVE"
, "PREFERRED"
, "BASE_QUANTITY"
, "STATUS"
, "ISSUED_DATE"
, "FRAME_ID"
, "ITEM_NUMBER"
, "COMPONENT_PART"
, "COMP_REVISION"
, "COMP_PLANT"
, "COMP_ALTERNATIVE"
, "COMP_PREFERRED"
, "COMP_BASE_QUANTITY"
, "COMP_STATUS"
, "COMP_ISSUED_DATE"
, "COMP_FRAME_ID"
, "QUANTITY"
, "UOM"
, "CHARACTERISTIC")
 ORGANIZATION HEAP PCTFREE 5 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  --TABLESPACE "USERS" 
  TABLESPACE "SPECD" 
  PARALLEL 4 
  BUILD IMMEDIATE
  USING INDEX 
  REFRESH FORCE ON DEMAND
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS DISABLE QUERY REWRITE
  AS SELECT bi.PART_NO           
,      bi.REVISION          
,      bi.PLANT             
,      bi.ALTERNATIVE
,      bh.preferred    
,      bh.base_quantity    
,      sh.status
,      sh.issued_date
,      sh.frame_id
,      bi.ITEM_NUMBER       
,      bi.COMPONENT_PART    
,      bhc.revision        COMP_REVISION
,      bi.COMPONENT_PLANT  COMP_PLANT
,      bhc.alternative     COMP_ALTERNATIVE
,      bhc.preferred       COMP_PREFERRED
,      bhc.base_quantity   comp_base_quantity   
,      shc.status          COMP_STATUS
,      shc.issued_date     COMP_ISSUED_DATE
,      shc.frame_id        COMP_FRAME_ID
,      bi.QUANTITY        
,      bi.UOM  
,      bi.ch_1             CHARACTERISTIC 
from bom_item   bi
join bom_header bh            on bh.part_no = bi.part_no and bh.revision = bi.revision and bh.alternative = bi.alternative
join specification_header sh  on sh.part_no  = bh.part_no and sh.revision = bh.revision and sh.status in (5, 4,98,99,124,125,126,127,128,154,314,315)
LEFT join bom_header bhc           on bhc.part_no = bi.component_part
LEFT join specification_header shc on shc.part_no = bhc.part_no and shc.revision = bhc.revision and shc.status in (5, 4,98,99,124,125,126,127,128,154,314,315)
where bi.revision  = (select max(bh3.revision)
                      from bom_header bh3
                      join specification_header sh3 on sh3.part_no = bh3.part_no and sh3.revision = bh3.revision and sh3.status in (5, 4,98,99,124,125,126,127,128,154,314,315)
					  where bh3.part_no = bi.part_no
					 )
and   (   bhc.revision = (select max(bh2.revision)
                          from bom_header bh2
                          join specification_header sh2 on sh2.part_no = bh2.part_no and sh2.revision = bh2.revision and sh2.status in (5, 4,98,99,124,125,126,127,128,154,314,315)
     					  where bi.component_part = bhc.part_no
					 )
      or not exists (select '' from bom_header bh4 where bh4.part_no = bi.component_part)                    
      )
;
*/
DROP MATERIALIZED VIEW  "INTERSPC"."MV_BOM_ITEM_COMP_HEADER" ;
PURGE RECYCLEBIN;

CREATE MATERIALIZED VIEW "INTERSPC"."MV_BOM_ITEM_COMP_HEADER" 
("PART_NO"
, "REVISION"
, "PLANT"
, "ALTERNATIVE"
, "PREFERRED"
, "BASE_QUANTITY"
, "STATUS"
, "ISSUED_DATE"
, "FRAME_ID"
, "ITEM_NUMBER"
, "COMPONENT_PART"
, "COMP_REVISION"
, "COMP_PLANT"
, "COMP_ALTERNATIVE"
, "COMP_PREFERRED"
, "COMP_BASE_QUANTITY"
, "COMP_STATUS"
, "COMP_ISSUED_DATE"
, "COMP_FRAME_ID"
, "QUANTITY"
, "UOM"
, "CHARACTERISTIC"
, "PHR_NUM_5")
 ORGANIZATION HEAP PCTFREE 5 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  --TABLESPACE "USERS" 
  TABLESPACE "SPECD" 
  PARALLEL 4 
  BUILD IMMEDIATE
  USING INDEX 
  REFRESH FORCE ON DEMAND
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS DISABLE QUERY REWRITE
  AS SELECT bi.PART_NO           
,      bi.REVISION          
,      bi.PLANT             
,      bi.ALTERNATIVE
,      bh.preferred    
,      bh.base_quantity    
,      sh.status
,      sh.issued_date
,      sh.frame_id
,      bi.ITEM_NUMBER       
,      bi.COMPONENT_PART    
,      bhc.revision        COMP_REVISION
,      bi.COMPONENT_PLANT  COMP_PLANT
,      bhc.alternative     COMP_ALTERNATIVE
,      bhc.preferred       COMP_PREFERRED
,      bhc.base_quantity   comp_base_quantity   
,      shc.status          COMP_STATUS
,      shc.issued_date     COMP_ISSUED_DATE
,      shc.frame_id        COMP_FRAME_ID
,      bi.QUANTITY        
,      bi.UOM  
,      bi.ch_1             CHARACTERISTIC 
,      bi.num_5
from bom_item   bi
join bom_header bh            on bh.part_no = bi.part_no and bh.revision = bi.revision and bh.plant = bi.plant and bh.alternative = bi.alternative
join specification_header sh  on sh.part_no  = bh.part_no and sh.revision = bh.revision and sh.status in (5, 4,98,99,124,125,126,127,128,154,314,315)
join bom_header bhc           on bhc.part_no = bi.component_part
join specification_header shc on shc.part_no = bhc.part_no and shc.revision = bhc.revision and shc.status in (5, 4,98,99,124,125,126,127,128,154,314,315)
where bi.revision  = (select max(bh3.revision)
                      from bom_header bh3
                      join specification_header sh3 on sh3.part_no = bh3.part_no and sh3.revision = bh3.revision and sh3.status in (5, 4,98,99,124,125,126,127,128,154,314,315)
					  where bh3.part_no = bi.part_no
					 )
and   bhc.revision = (select max(bh2.revision)
                      from bom_header bh2
                      join specification_header sh2 on sh2.part_no = bh2.part_no and sh2.revision = bh2.revision and sh2.status in (5, 4,98,99,124,125,126,127,128,154,314,315)
                      where bh2.part_no = bi.component_part 
                     )
UNION ALL
SELECT bi.PART_NO           
,      bi.REVISION          
,      bi.PLANT             
,      bi.ALTERNATIVE
,      bh.preferred    
,      bh.base_quantity    
,      sh.status
,      sh.issued_date
,      sh.frame_id
,      bi.ITEM_NUMBER       
,      bi.COMPONENT_PART    
,      -1     COMP_REVISION
,      '-1'     COMP_PLANT
,      -1     COMP_ALTERNATIVE
,      -1     COMP_PREFERRED
,      -1     comp_base_quantity   
,      -1     COMP_STATUS
,      to_date('01-01-1900','dd-mm-yyyy')  COMP_ISSUED_DATE
,      '-1'     COMP_FRAME_ID
,      bi.QUANTITY        
,      bi.UOM  
,      bi.ch_1             CHARACTERISTIC 
,      bi.num_5
from bom_item   bi
join bom_header bh            on bh.part_no = bi.part_no and bh.revision = bi.revision and bh.plant = bi.plant and bh.alternative = bi.alternative
join specification_header sh  on sh.part_no  = bh.part_no and sh.revision = bh.revision and sh.status in (5, 4,98,99,124,125,126,127,128,154,314,315)
where bi.revision  = (select max(bh3.revision)
                      from bom_header bh3
                      join specification_header sh3 on sh3.part_no = bh3.part_no and sh3.revision = bh3.revision and sh3.status in (5, 4,98,99,124,125,126,127,128,154,314,315)
					  where bh3.part_no = bi.part_no
					 )
and not exists (select '' from bom_header bh4 where bh4.part_no = bi.component_part)    
;


/*
--optimized-version 1e GEDEELTE:
drop materialized view MV_SUB_BOM_ITEM_COMP_HEADER;
purge recyclebin;
CREATE MATERIALIZED VIEW "INTERSPC"."MV_SUB_BOM_ITEM_COMP_HEADER" 
("PART_NO"
, "REVISION"
, "PLANT"
, "ALTERNATIVE"
, "PREFERRED"
, "BASE_QUANTITY"
, "STATUS"
, "ISSUED_DATE"
, "FRAME_ID"
, "ITEM_NUMBER"
, "COMPONENT_PART"
, "COMP_REVISION"
, "COMP_PLANT"
, "COMP_ALTERNATIVE"
, "COMP_PREFERRED"
, "COMP_BASE_QUANTITY"
, "COMP_STATUS"
, "COMP_ISSUED_DATE"
, "COMP_FRAME_ID"
, "QUANTITY"
, "UOM"
, "CHARACTERISTIC")
 ORGANIZATION HEAP PCTFREE 5 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  --TABLESPACE "USERS" 
  TABLESPACE "SPECD" 
  PARALLEL 4 
  BUILD IMMEDIATE
  USING INDEX 
  REFRESH FORCE ON DEMAND
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS DISABLE QUERY REWRITE
  AS SELECT bi.PART_NO           
,      bi.REVISION          
,      bi.PLANT             
,      bi.ALTERNATIVE
,      bh.preferred    
,      bh.base_quantity    
,      sh.status
,      sh.issued_date
,      sh.frame_id
,      bi.ITEM_NUMBER       
,      bi.COMPONENT_PART    
,      bhc.revision        COMP_REVISION
,      bi.COMPONENT_PLANT  COMP_PLANT
,      bhc.alternative     COMP_ALTERNATIVE
,      bhc.preferred       COMP_PREFERRED
,      bhc.base_quantity   comp_base_quantity   
,      shc.status          COMP_STATUS
,      shc.issued_date     COMP_ISSUED_DATE
,      shc.frame_id        COMP_FRAME_ID
,      bi.QUANTITY        
,      bi.UOM  
,      bi.ch_1             CHARACTERISTIC 
from bom_item   bi
join bom_header bh            on bh.part_no = bi.part_no and bh.revision = bi.revision and bi.plant = bh.plant and bh.alternative = bi.alternative
join specification_header sh  on sh.part_no  = bh.part_no and sh.revision = bh.revision and sh.status in (5, 4,98,99,124,125,126,127,128,154,314,315)
join bom_header bhc           on bhc.part_no = bi.component_part
join specification_header shc on shc.part_no = bhc.part_no and shc.revision = bhc.revision and shc.status in (5, 4,98,99,124,125,126,127,128,154,314,315)
where bi.revision  = (select max(bh3.revision)
                      from bom_header bh3
                      join specification_header sh3 on sh3.part_no = bh3.part_no and sh3.revision = bh3.revision and sh3.status in (5, 4,98,99,124,125,126,127,128,154,314,315)
					  where bh3.part_no = bi.part_no
					  --and   bh3.plant    = bi.plant
					  --and   bh3.alternative = bi.alternative
					 )
and   bhc.revision = (select max(bh2.revision)
                      from bom_header bh2
                      join specification_header sh2 on sh2.part_no = bh2.part_no and sh2.revision = bh2.revision and sh2.status in (5, 4,98,99,124,125,126,127,128,154,314,315)
                      where bh2.part_no  = bi.component_part
                     )
;

--met extra attr in revision-sub-query:       960597
--zonder extra attr in revision-sub-query:    375083
--zonder extra attr = revision in sub-query:  378553
--
*/

/*
--controle waar dit verschil vandaan komt...
SELECT bi.PART_NO           
,      bi.REVISION          
,      bi.PLANT             
,      bi.ALTERNATIVE
,      bi.ITEM_NUMBER       
,      bi.COMPONENT_PART    
,      bhc.revision        COMP_REVISION
,      bi.COMPONENT_PLANT  COMP_PLANT
,      bhc.alternative     COMP_ALTERNATIVE
from bom_item   bi
join bom_header bh            on bh.part_no = bi.part_no and bh.revision = bi.revision and bi.plant = bh.plant and bh.alternative = bi.alternative
join specification_header sh  on sh.part_no  = bh.part_no and sh.revision = bh.revision and sh.status in (5, 4,98,99,124,125,126,127,128,154,314,315)
join bom_header bhc           on bhc.part_no = bi.component_part
join specification_header shc on shc.part_no = bhc.part_no and shc.revision = bhc.revision and shc.status in (5, 4,98,99,124,125,126,127,128,154,314,315)
where bi.revision  = (select max(bh3.revision)
                      from bom_header bh3
                      join specification_header sh3 on sh3.part_no = bh3.part_no and sh3.revision = bh3.revision and sh3.status in (5, 4,98,99,124,125,126,127,128,154,314,315)
					  where bh3.part_no = bi.part_no
					  --and   bh3.revision = bi.revision
					  --and   bh3.plant    = bi.plant
					  --and   bh3.alternative = bi.alternative
					 )
and   bhc.revision = (select max(bh2.revision)
                      from bom_header bh2
                      join specification_header sh2 on sh2.part_no = bh2.part_no and sh2.revision = bh2.revision and sh2.status in (5, 4,98,99,124,125,126,127,128,154,314,315)
                      where bh2.part_no  = bi.component_part
                     )
order by part_no, revision, alternative, component_part, comp_revision , comp_alternative                    
;
--part-no: 2 + part_no: EB_21SM  (alt 1+2, comp-alt 1,2,3)

*/

/*
--optimized-version 2e GEDEELTE:
drop materialized view MV_SUB_BOM_MATERIAL_HEADER;
purge recyclebin;
--
CREATE MATERIALIZED VIEW "INTERSPC"."MV_SUB_BOM_MATERIAL_HEADER" 
("PART_NO"
, "REVISION"
, "PLANT"
, "ALTERNATIVE"
, "PREFERRED"
, "BASE_QUANTITY"
, "STATUS"
, "ISSUED_DATE"
, "FRAME_ID"
, "ITEM_NUMBER"
, "COMPONENT_PART"
, "COMP_REVISION"
, "COMP_PLANT"
, "COMP_ALTERNATIVE"
, "COMP_PREFERRED"
, "COMP_BASE_QUANTITY"
, "COMP_STATUS"
, "COMP_ISSUED_DATE"
, "COMP_FRAME_ID"
, "QUANTITY"
, "UOM"
, "CHARACTERISTIC")
 ORGANIZATION HEAP PCTFREE 5 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  --TABLESPACE "USERS" 
  TABLESPACE "SPECD" 
  PARALLEL 4 
  BUILD IMMEDIATE
  USING INDEX 
  REFRESH FORCE ON DEMAND
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS DISABLE QUERY REWRITE
  AS 
SELECT bi.PART_NO           
,      bi.REVISION          
,      bi.PLANT             
,      bi.ALTERNATIVE
,      bh.preferred    
,      bh.base_quantity    
,      sh.status
,      sh.issued_date
,      sh.frame_id
,      bi.ITEM_NUMBER       
,      bi.COMPONENT_PART    
,      -1     COMP_REVISION
,      -1     COMP_PLANT
,      -1     COMP_ALTERNATIVE
,      -1     COMP_PREFERRED
,      -1     comp_base_quantity   
,      -1     COMP_STATUS
,      to_date('01-01-1900','dd-mm-yyyy')  COMP_ISSUED_DATE
,      -1     COMP_FRAME_ID
,      bi.QUANTITY        
,      bi.UOM  
,      bi.ch_1             CHARACTERISTIC 
from bom_item   bi
join bom_header bh            on bh.part_no = bi.part_no and bh.revision = bi.revision and bh.plant = bi.plant and bh.alternative = bi.alternative
join specification_header sh  on sh.part_no  = bh.part_no and sh.revision = bh.revision and sh.status in (5, 4,98,99,124,125,126,127,128,154,314,315)
where bi.revision  = (select max(bh3.revision)
                      from bom_header bh3
                      join specification_header sh3 on sh3.part_no = bh3.part_no and sh3.revision = bh3.revision and sh3.status in (5, 4,98,99,124,125,126,127,128,154,314,315)
					  where bh3.part_no = bi.part_no
					 )
and not exists (select '' from bom_header bh4 where bh4.part_no = bi.component_part)                    
;

--and bi.component_part not in (select bI2.part_no from bom_item bi2 where bi2.part_no = bi.component_part)
--and not exists (select '' from bom_header bh4 where bh4.part_no = bi.component_part)                    
--#rows: 498989  (met een count = 498989) (met extra conditie op bom-header: 498777 == deze hanteren !!!)



--and bi.part_no = 'EM_747' 
--and bi.component_part like 'GR_4121'                       
*/

--CONTROLE UNIQUE KEY / INDEX
select PART_NO, REVISION, PLANT, ALTERNATIVE, PREFERRED, ITEM_NUMBER, COMPONENT_PART, COMP_REVISION, COMP_PLANT, COMP_ALTERNATIVE, COMP_PREFERRED, COMP_BASE_QUANTITY , count(*)               --, CHARACTERISTIC
from MV_BOM_ITEM_COMP_HEADER
group by PART_NO, REVISION, PLANT, ALTERNATIVE, PREFERRED, ITEM_NUMBER, COMPONENT_PART, COMP_REVISION, COMP_PLANT, COMP_ALTERNATIVE, COMP_PREFERRED, COMP_BASE_QUANTITY                        --, CHARACTERISTIC
having count(*) > 1
;
--
SELECT * FROM BOM_HEADER WHERE PART_NO='XET_PB10-226D';
UPDATE BOM_HEADER SET PREFERRED=0 WHERE PART_NO='XEM_B18-1928XN5' AND PREFERRED=1 AND BASE_QUANTITY=1 AND PLANT='DEV';
UPDATE BOM_HEADER SET PREFERRED=0 WHERE PART_NO='XET_PB10-226D' AND PREFERRED=1 AND BASE_QUANTITY=1 and plant='ENS';
UPDATE BOM_HEADER SET PREFERRED=0 WHERE PART_NO='XEC_P1398' AND PREFERRED=1 AND BASE_QUANTITY=1 AND PLANT='DEV';
--
--REFRESH MATERIALIZED-VIEW
EXEC dbms_mview.refresh('MV_BOM_ITEM_COMP_HEADER');

--CREATE UNIQUE KEY / INDEX
drop index INTERSPC.UK_MV_BOM_ITEM_PART_REV;
--add column , COMP_PREFERRED + COMP_BASE_QUANTITY voor de zekerheid omdat we niet zeker weten of dit nog vaker voor kan komen...!!
--create UNIQUE index INTERSPC.UK_MV_BOM_ITEM_PART_REV  ON INTERSPC.MV_BOM_ITEM_COMP_HEADER (PART_NO, REVISION, PLANT, ALTERNATIVE, ITEM_NUMBER, COMPONENT_PART, COMP_REVISION, COMP_PLANT, COMP_ALTERNATIVE, COMP_PREFERRED, COMP_BASE_QUANTITY, CHARACTERISTIC  ) TABLESPACE SPECI;

ALTER TABLE INTERSPC.MV_BOM_ITEM_COMP_HEADER ADD CONSTRAINT PK_MV_BOM_ITEM_PART_REV PRIMARY KEY (PART_NO, REVISION, PLANT, ALTERNATIVE, PREFERRED, ITEM_NUMBER, COMPONENT_PART, COMP_REVISION, COMP_PLANT, COMP_ALTERNATIVE, COMP_PREFERRED, COMP_BASE_QUANTITY )
USING INDEX
TABLESPACE SPECI ;


					 
--CREATE INDEXES
drop index INTERSPC.IX_MV_BOM_ITEM_PART_REV;
create index INTERSPC.IX_MV_BOM_ITEM_PART_REV  ON INTERSPC.MV_BOM_ITEM_COMP_HEADER (PART_NO, REVISION, ALTERNATIVE ) TABLESPACE SPECI
;

drop index INTERSPC.IX_MV_BOM_ITEM_COMP_REV;
create index INTERSPC.IX_MV_BOM_ITEM_COMP_REV  ON INTERSPC.MV_BOM_ITEM_COMP_HEADER (COMPONENT_PART, COMP_REVISION, COMP_ALTERNATIVE ) TABLESPACE SPECI
;


--refresh MV
BEGIN
  dbms_mview.refresh('MV_BOM_ITEM_COMP_HEADER');
END;
/
--of:
--start: 10.42 uur
begin
  aapiweight_calc.refresh_mv_bom_item_header ;
end;
/  
--end: 10:50  

--check aantal rijen
select count(*) from MV_BOM_ITEM_COMP_HEADER;
28-03-2023: 873880	(
select count(*) from MV_BOM_ITEM_COMP_HEADER where comp_revision=-1;
28-03-2023: 498777 !!! = OK 
03-04-2023: 499588 

--check issued-date
select max(issued_date) from MV_BOM_ITEM_COMP_HEADER;
28-03-2023 16:02:55
--Na refresh:
03-04-2023 09:50:26 



--***********************************************************************
--***********************************************************************
-- controle juistheid van MV
--***********************************************************************
--***********************************************************************


/*
CREATE MATERIALIZED VIEW MV_BOM_ITEM_COMP_HEADER
TABLESPACE USERS
PCTFREE 5
PARALLEL 4
BUILD IMMEDIATE
REFRESH FORCE
ON DEMAND  
DISABLE QUERY REWRITE 
AS 
SELECT bi.PART_NO           
,      bi.REVISION          
,      bi.PLANT             
,      bi.ALTERNATIVE       
,      bi.ITEM_NUMBER       
,      bi.COMPONENT_PART    
,      bhc.revision    COMP_REVISION
,      bhc.alternative COMP_ALTERNATIVE
,      shc.frame_id    COMP_FRAME_ID
,      bi.COMPONENT_PLANT 
,      bi.QUANTITY        
,      bi.UOM  
,      bi.ch_1  CHARACTERISTIC         
from bom_item   bi
join bom_header bhc           on bi.component_part = bhc.part_no 
join specification_header shc on bhc.part_no = shc.part_no and bhc.revision = shc.revision and shc.status in (5, 4,98,99,124,125,126,127,128,154,314,315)
where bi.revision  = (select max(bh.revision)
                      from bom_header bh
                      join specification_header sh on sh.part_no = bh.part_no and sh.revision = bh.revision and sh.status in (5, 4,98,99,124,125,126,127,128,154,314,315)
					  where bh.part_no = bi.part_no
					 )
--and   bi.component_part = 'EM_464'  --'GV_2254517USANY' 
and   bi.part_no not like 'XEM%'
and   bi.component_part not like 'XEM%' 					 
and   bhc.revision = (select max(bh.revision)
                      from bom_header bh
                      join specification_header sh on sh.part_no = bh.part_no and sh.revision = bh.revision and sh.status in (5, 4,98,99,124,125,126,127,128,154,314,315)
					  where bh.part_no = bhc.part_no
					 )
*/

/*
Error report -
ORA-12054: cannot set the ON COMMIT refresh attribute for the materialized view
12054. 00000 -  "cannot set the ON COMMIT refresh attribute for the materialized view"
*Cause:    The materialized view did not satisfy conditions for refresh at
           commit time.
*Action:   Specify only valid options.
--
--use ON DEMAND instead of ON COMMIT !!!!
*/
                               
/*
Error report -
ORA-12015: cannot create a fast refresh materialized view from a complex query
12015. 00000 -  "cannot create a fast refresh materialized view from a complex query"
*Cause:    Neither ROWIDs and nor primary key constraints are supported for
           complex queries.
*Action:   Reissue the command with the REFRESH FORCE or REFRESH COMPLETE
           option or create a simple materialized view.
--
--Fast-refresh niet mogelijk met complex-query !!!
--


ORA-12054: cannot set the ON COMMIT refresh attribute for the materialized view
12054. 00000 -  "cannot set the ON COMMIT refresh attribute for the materialized view"
*Cause:    The materialized view did not satisfy conditions for refresh at
           commit time.
*Action:   Specify only valid options.
*/




--uittesten werking...
SELECT COUNT(*)              
FROM  mv_bom_item_comp_header mv
START WITH mv.COMPONENT_PART = 'EM_574'     
CONNECT BY NOCYCLE prior mv.part_no = mv.component_part 
               and prior mv.revision = mv.comp_revision 
               and prior mv.alternative = mv.comp_alternative
order siblings by mv.component_part

--uittesten resultaten
SELECT bi.part_no
,      bi.revision     
,      bi.plant     
,      bi.alternative     
,      bi.component_part
,      bi.comp_revision
,      bi.comp_alternative
,      bi.comp_frame_id	 
,      sys_connect_by_path( bi.component_part || ',' || bi.part_no ,'|')              path
FROM  mv_bom_item_comp_header bi
START WITH bi.COMPONENT_PART = 'EM_574'     
CONNECT BY NOCYCLE prior bi.part_no = bi.component_part 
               and prior bi.revision = bi.comp_revision 
               and prior bi.alternative = bi.comp_alternative
order siblings by bi.component_part			   
;

--**********************************
--uittesten RELATED-TYRES vanuit component/material
--**********************************
SELECT DISTINCT bi2.part_no     mainpart
        ,      bi2.revision             mainrevision
        ,      bi2.plant                mainplant
        ,      bi2.alternative          mainalternative
        ,      BI2.STATUS               MAINSTATUS
		,      BI2.FRAME_ID             MAINFRAMEID
        ,      bi2.path
FROM		
(SELECT PART_NO
, REVISION
, PLANT
, ALTERNATIVE
, PREFERRED
, BASE_QUANTITY
, STATUS
, ISSUED_DATE
, FRAME_ID
, ITEM_NUMBER
, COMPONENT_PART
, COMP_REVISION
, COMP_PLANT
, COMP_ALTERNATIVE
, COMP_PREFERRED
, COMP_BASE_QUANTITY
, COMP_STATUS
, COMP_ISSUED_DATE
, COMP_FRAME_ID
, QUANTITY
, UOM
, CHARACTERISTIC
,      sys_connect_by_path( bi.component_part || ',' || bi.part_no ,'|')              path
FROM  mv_bom_item_comp_header bi
where bi.preferred = 1
and   bi.comp_preferred = 1
START WITH bi.COMPONENT_PART = 'EM_574'     
CONNECT BY NOCYCLE prior bi.part_no = bi.component_part 
               and prior bi.revision = bi.comp_revision 
               and prior bi.alternative = bi.comp_alternative
order siblings by bi.component_part		
) bi2
where NOT EXISTS (select ''  from bom_item bi3 where bi3.component_part = bi2.part_no )  
and bi2.status in (select s.status 
                     from status s 
                     where s.status      = bi2.status
                     and   s.status_type in ('CURRENT') ) 
		    and (   ( bi2.frame_id   LIKE ('A_PCR%')      --vooralsnog zonder TRIAL/XE-banden Enschede, wel XG-hongarije !!
                and (  bi2.part_no LIKE ('EF%') OR  bi2.part_no LIKE ('GF%') OR  bi2.PART_NO LIKE ('XGF%') )
                )
            OR  ( bi2.frame_id   LIKE ('A_TBR%')      --Truck-banden alleen Hongarije
                and (   bi2.part_no LIKE ('GF%') OR  BI2.PART_NO LIKE ('XGF%') )
                )
            OR  ( bi2.frame_id in ('E_PCR_VULC')      --C-alternative VulcTyre
                AND bi2.part_no like ('EV_C%')
                )
            OR  ( bi2.frame_id in ('E_SM')            --SpaceMaster Tyre
                AND bi2.part_no like ('EF%')
                )
            OR  ( bi2.frame_id in ('E_SF_Wheelset')   --SpaceMaster Wheelset (LET OP: IS GEEN FINISHED-PRODUCT !!)
	              and  (  bi2.part_no like ('EF%') or bi2.part_no like ('SW%') )
                )
            OR  ( bi2.frame_id in ('E_SF_BoxedWheels')   --SpaceMaster WheelsetBox (Bevat aantal Wheelsets)
	              and  (  bi2.part_no like ('EF%') or bi2.part_no like ('SE%') )
                )
            OR  ( bi2.frame_id in ('E_BBQ')           --Spoiler	
                and bi2.part_no like ('EQ%')
                )
            OR  ( bi2.frame_id in ('E_AT')            --Produced Agriculture Tyre (no trial/XEF)
                AND bi2.part_no like ('EF%')
                )
            )				   

--185 rijen...
--(incl. EF_Y245/45R18UVPX !!)



--check issued-date
select max(issued_date) from MV_BOM_ITEM_COMP_HEADER;
27/03/2023 15:35:02

--****************************************
--UITTESTEN BOM-ITEMS vanuit TYRE/FINISHED-PRODUCT/COMPONENT... 
--bijv. EF_Y245/45R18UVPX
--****************************************
SELECT DISTINCT bi2.lvl
        ,      bi2.level_tree
        ,      bi2.part_no     
        ,      bi2.revision      
        ,      bi2.plant         
        ,      bi2.alternative   
        ,      BI2.STATUS        
		,      BI2.FRAME_ID      
		,      bi2.component_part      
		,      bi2.comp_revision
		,      bi2.comp_alternative
		,      bi2.comp_frame_id
        ,      bi2.path
        ,      bi2.quantity_path
FROM		
(SELECT LEVEL   LVL
,      RPAD('.', (level-1)*2, '.') || LEVEL AS level_tree
,      PART_NO
, REVISION
, PLANT
, ALTERNATIVE
, PREFERRED
, BASE_QUANTITY
, STATUS
, ISSUED_DATE
, FRAME_ID
, ITEM_NUMBER
, COMPONENT_PART
, COMP_REVISION
, COMP_PLANT
, COMP_ALTERNATIVE
, COMP_PREFERRED
, COMP_BASE_QUANTITY
, COMP_STATUS
, COMP_ISSUED_DATE
, COMP_FRAME_ID
, QUANTITY
, UOM
, CHARACTERISTIC
,      sys_connect_by_path( bi.part_no||decode(bi.characteristic,null,'','-'||bi.characteristic) || ',' || bi.component_part ,'|')  path    
,      sys_connect_by_path( '('||bi.quantity||'/'||bi.base_quantity||')', '*')  quantity_path
FROM  (select * 
       from mv_bom_item_comp_header b
       where b.preferred      = 1
       and   b.comp_preferred in (1,-1)
	  ) bi
START WITH bi.PART_NO = 'EF_Y245/45R18UVPX' and bi.REVISION=16     
CONNECT BY NOCYCLE prior bi.component_part    = bi.part_no
               and prior bi.comp_revision     = bi.revision 
               and prior bi.comp_alternative  = bi.alternative
order siblings by bi.part_no
) bi2

--WAS: 371 comp/materialen...
--PER 27-03-2023: 650 COMP/MATERIALEN...

--waar is material direct onder de tyre ?
select * from mv_bom_item_comp_header where part_no='EF_Y245/45R18UVPX';
EF_Y245/45R18UVPX	16	ENS	1	1	1	127	16-03-2023 16:25:23	A_PCR	10	EV_BY245/45R18UVPX	1
EF_Y245/45R18UVPX	16	ENS	1	1	1	127	16-03-2023 16:25:23	A_PCR	20	GR_9786	-1
--Hier zit hij wel in !!!!!

--sommige materials zitten er dubbel in...
--bijv. EM_442  -  ED_442-8-33

select * from mv_bom_item_comp_header where part_no='EM_442';
EM_442	29	ENS	1	1	1.1593092	128	12-05-2022 09:02:43	E_XNP	60	GR_4321	-1	-1	-1	-1	-1	-1	01-01-1900 00:00:00	-1	0.0169597	kg	
EM_442	29	ENS	1	1	1.1593092	128	12-05-2022 09:02:43	E_XNP	20	GR_1411	-1	-1	-1	-1	-1	-1	01-01-1900 00:00:00	-1	0.2854886	kg	
EM_442	29	ENS	1	1	1.1593092	128	12-05-2022 09:02:43	E_XNP	80	GR_4651	-1	-1	-1	-1	-1	-1	01-01-1900 00:00:00	-1	0.0056532	kg	
EM_442	29	ENS	1	1	1.1593092	128	12-05-2022 09:02:43	E_XNP	100	GR_5215	-1	-1	-1	-1	-1	-1	01-01-1900 00:00:00	-1	0.0104585	kg	
EM_442	29	ENS	1	1	1.1593092	128	12-05-2022 09:02:43	E_XNP	10	GR_1151	-1	-1	-1	-1	-1	-1	01-01-1900 00:00:00	-1	0.2798354	kg	
EM_442	29	ENS	1	1	1.1593092	128	12-05-2022 09:02:43	E_XNP	40	GR_3511	-1	-1	-1	-1	-1	-1	01-01-1900 00:00:00	-1	0.0678389	kg	
EM_442	29	ENS	1	1	1.1593092	128	12-05-2022 09:02:43	E_XNP	90	GR_5111	-1	-1	-1	-1	-1	-1	01-01-1900 00:00:00	-1	0.0169597	kg	
EM_442	29	ENS	1	1	1.1593092	128	12-05-2022 09:02:43	E_XNP	120	GR_5214	-1	-1	-1	-1	-1	-1	01-01-1900 00:00:00	-1	0.000848	kg	
EM_442	29	ENS	1	1	1.1593092	128	12-05-2022 09:02:43	E_XNP	50	GR_4312	-1	-1	-1	-1	-1	-1	01-01-1900 00:00:00	-1	0.0282662	kg	
EM_442	29	ENS	1	1	1.1593092	128	12-05-2022 09:02:43	E_XNP	110	GR_5212	-1	-1	-1	-1	-1	-1	01-01-1900 00:00:00	-1	0.0117022	kg	
EM_442	29	ENS	1	1	1.1593092	128	12-05-2022 09:02:43	E_XNP	70	GR_4611	-1	-1	-1	-1	-1	-1	01-01-1900 00:00:00	-1	0.0113065	kg	
EM_442	29	ENS	1	1	1.1593092	128	12-05-2022 09:02:43	E_XNP	30	GR_2132	-1	-1	-1	-1	-1	-1	01-01-1900 00:00:00	-1	0.423993	kg	
--
EM_442	29	ENS	2	0	330	128	12-05-2022 09:02:43	E_XNP	120	ED_442-6-33	3	ENS	1	1	1	125	23-06-2021 10:11:15	E_SCW	1	pcs	
EM_442	29	ENS	2	0	330	128	12-05-2022 09:02:43	E_XNP	110	ED_442-6-32	3	ENS	1	1	1	125	23-06-2021 10:11:11	E_SCW	1	pcs	
EM_442	29	ENS	2	0	330	128	12-05-2022 09:02:43	E_XNP	100	ED_442-6-31	3	ENS	1	1	1	125	23-06-2021 10:11:07	E_SCW	1	pcs	
EM_442	29	ENS	2	0	330	128	12-05-2022 09:02:43	E_XNP	20	GR_1411	-1	-1	-1	-1	-1	-1	01-01-1900 00:00:00	-1	81.2649792	kg	
EM_442	29	ENS	2	0	330	128	12-05-2022 09:02:43	E_XNP	60	GR_4321	-1	-1	-1	-1	-1	-1	01-01-1900 00:00:00	-1	4.8276172	kg	
EM_442	29	ENS	2	0	330	128	12-05-2022 09:02:43	E_XNP	80	GR_4651	-1	-1	-1	-1	-1	-1	01-01-1900 00:00:00	-1	1.6091962	kg	
EM_442	29	ENS	2	0	330	128	12-05-2022 09:02:43	E_XNP	10	GR_1151	-1	-1	-1	-1	-1	-1	01-01-1900 00:00:00	-1	79.6557829	kg	
EM_442	29	ENS	2	0	330	128	12-05-2022 09:02:43	E_XNP	40	GR_3511	-1	-1	-1	-1	-1	-1	01-01-1900 00:00:00	-1	19.3104971	kg	
EM_442	29	ENS	2	0	330	128	12-05-2022 09:02:43	E_XNP	30	GR_2132	-1	-1	-1	-1	-1	-1	01-01-1900 00:00:00	-1	120.6905716	kg	
EM_442	29	ENS	2	0	330	128	12-05-2022 09:02:43	E_XNP	50	GR_4312	-1	-1	-1	-1	-1	-1	01-01-1900 00:00:00	-1	8.0460381	kg	
EM_442	29	ENS	2	0	330	128	12-05-2022 09:02:43	E_XNP	70	GR_4611	-1	-1	-1	-1	-1	-1	01-01-1900 00:00:00	-1	3.2184209	kg	
EM_442	29	ENS	2	0	330	128	12-05-2022 09:02:43	E_XNP	90	GR_5111	-1	-1	-1	-1	-1	-1	01-01-1900 00:00:00	-1	4.8276172	kg	
--
EM_442	29	ENS	3	0	225	128	12-05-2022 09:02:43	E_XNP	110	ED_442-8-31	1	ENS	1	1	1	125	05-05-2022 08:31:48	E_SCW	1	pcs	
EM_442	29	ENS	3	0	225	128	12-05-2022 09:02:43	E_XNP	120	ED_442-8-32	1	ENS	1	1	1	125	05-05-2022 08:31:51	E_SCW	1	pcs	
EM_442	29	ENS	3	0	225	128	12-05-2022 09:02:43	E_XNP	130	ED_442-8-33	1	ENS	1	1	1	125	05-05-2022 08:31:55	E_SCW	1	pcs	
EM_442	29	ENS	3	0	225	128	12-05-2022 09:02:43	E_XNP	50	GR_4312	-1	-1	-1	-1	-1	-1	01-01-1900 00:00:00	-1	5.5673858	kg	
EM_442	29	ENS	3	0	225	128	12-05-2022 09:02:43	E_XNP	20	GR_1411	-1	-1	-1	-1	-1	-1	01-01-1900 00:00:00	-1	56.230497	kg	
EM_442	29	ENS	3	0	225	128	12-05-2022 09:02:43	E_XNP	10	GR_1151	-1	-1	-1	-1	-1	-1	01-01-1900 00:00:00	-1	55.1170238	kg	
EM_442	29	ENS	3	0	225	128	12-05-2022 09:02:43	E_XNP	100	GR_5215	-1	-1	-1	-1	-1	-1	01-01-1900 00:00:00	-1	2.0599372	kg	
EM_442	29	ENS	3	0	225	128	12-05-2022 09:02:43	E_XNP	40	GR_3511	-1	-1	-1	-1	-1	-1	01-01-1900 00:00:00	-1	13.3616986	kg	
EM_442	29	ENS	3	0	225	128	12-05-2022 09:02:43	E_XNP	80	GR_4651	-1	-1	-1	-1	-1	-1	01-01-1900 00:00:00	-1	1.1134733	kg	
EM_442	29	ENS	3	0	225	128	12-05-2022 09:02:43	E_XNP	70	GR_4611	-1	-1	-1	-1	-1	-1	01-01-1900 00:00:00	-1	2.2269465	kg	
EM_442	29	ENS	3	0	225	128	12-05-2022 09:02:43	E_XNP	60	GR_4321	-1	-1	-1	-1	-1	-1	01-01-1900 00:00:00	-1	3.3404198	kg	
EM_442	29	ENS	3	0	225	128	12-05-2022 09:02:43	E_XNP	30	GR_2134	-1	-1	-1	-1	-1	-1	01-01-1900 00:00:00	-1	80.1702111	kg	

select distinct PART_NO, revision, alternative, preferred from mv_bom_item_comp_header where component_part='EM_422' and preferred=1;
XEM_B21-1937XN5_01	2	1	1
XEM_B21-1939XN5_01	2	1	1
XEM_B21-1943XN5_01	2	1	1
XEM_B21-1942XN5_01	2	1	1
XEM_B21-1941XN5_01	2	1	1
XEM_522_022			1	1	1
XEM_B21-1940XN5_01	2	1	1
XEM_522_032			1	1	1
XEM_522_049			2	1	1
EM_522				19	1	1
XEM_522_033			1	1	1
XEM_B21-1938XN5_01	2	1	1
XEM_B21-1936XN5_01	2	1	1

select * from mv_bom_item_comp_header where part_no='ED_442-8-33';
ED_442-8-33	1	ENS	1	1	1	125	05-05-2022 08:31:55	E_SCW	20	GR_8613	-1	-1	-1	-1	-1	-1	01-01-1900 00:00:00	-1	1	pcs	
ED_442-8-33	1	ENS	1	1	1	125	05-05-2022 08:31:55	E_SCW	10	GR_5111	-1	-1	-1	-1	-1	-1	01-01-1900 00:00:00	-1	3.34	kg	


SELECT DISTINCT bi2.lvl
        ,      bi2.level_tree
        ,      bi2.part_no     
        ,      bi2.revision      
        ,      bi2.plant         
        ,      bi2.alternative   
        ,      bi2.preferred
        ,      BI2.STATUS        
		,      BI2.FRAME_ID      
		,      bi2.component_part      
		,      bi2.comp_revision
		,      bi2.comp_alternative
        ,      bi2.comp_preferred
		,      bi2.comp_frame_id
        ,      bi2.path
        ,      bi2.quantity_path
FROM		
(SELECT LEVEL   LVL
,      RPAD('.', (level-1)*2, '.') || LEVEL AS level_tree
,      PART_NO
, REVISION
, PLANT
, ALTERNATIVE
, PREFERRED
, BASE_QUANTITY
, STATUS
, ISSUED_DATE
, FRAME_ID
, ITEM_NUMBER
, COMPONENT_PART
, COMP_REVISION
, COMP_PLANT
, COMP_ALTERNATIVE
, COMP_PREFERRED
, COMP_BASE_QUANTITY
, COMP_STATUS
, COMP_ISSUED_DATE
, COMP_FRAME_ID
, QUANTITY
, UOM
, CHARACTERISTIC
,      sys_connect_by_path( bi.part_no||decode(bi.characteristic,null,'','-'||bi.characteristic) || ',' || bi.component_part ,'|')  path    
,      sys_connect_by_path( '('||bi.quantity||'/'||bi.base_quantity||')', '*')  quantity_path
FROM  mv_bom_item_comp_header bi
where bi.preferred      = 1
and   bi.comp_preferred in (1,-1)
START WITH bi.PART_NO = 'EM_442' and bi.REVISION=29     
CONNECT BY NOCYCLE prior bi.component_part    = bi.part_no
               and prior bi.comp_revision     = bi.revision 
               and prior bi.comp_alternative  = bi.alternative
			   and prior bi.comp_preferred    = bi.preferred
order siblings by bi.part_no
) bi2

1	1	EM_442	29	ENS	1	1	128	E_XNP	GR_1151	-1	-1	-1	-1	|EM_442,GR_1151	*(.2798354/1.1593092)
1	1	EM_442	29	ENS	1	1	128	E_XNP	GR_3511	-1	-1	-1	-1	|EM_442,GR_3511	*(.0678389/1.1593092)
1	1	EM_442	29	ENS	1	1	128	E_XNP	GR_2132	-1	-1	-1	-1	|EM_442,GR_2132	*(.423993/1.1593092)
1	1	EM_442	29	ENS	1	1	128	E_XNP	GR_5212	-1	-1	-1	-1	|EM_442,GR_5212	*(.0117022/1.1593092)
1	1	EM_442	29	ENS	1	1	128	E_XNP	GR_1411	-1	-1	-1	-1	|EM_442,GR_1411	*(.2854886/1.1593092)
1	1	EM_442	29	ENS	1	1	128	E_XNP	GR_5214	-1	-1	-1	-1	|EM_442,GR_5214	*(.000848/1.1593092)
1	1	EM_442	29	ENS	1	1	128	E_XNP	GR_5215	-1	-1	-1	-1	|EM_442,GR_5215	*(.0104585/1.1593092)
1	1	EM_442	29	ENS	1	1	128	E_XNP	GR_4651	-1	-1	-1	-1	|EM_442,GR_4651	*(.0056532/1.1593092)
1	1	EM_442	29	ENS	1	1	128	E_XNP	GR_5111	-1	-1	-1	-1	|EM_442,GR_5111	*(.0169597/1.1593092)
1	1	EM_442	29	ENS	1	1	128	E_XNP	GR_4321	-1	-1	-1	-1	|EM_442,GR_4321	*(.0169597/1.1593092)
1	1	EM_442	29	ENS	1	1	128	E_XNP	GR_4312	-1	-1	-1	-1	|EM_442,GR_4312	*(.0282662/1.1593092)
1	1	EM_442	29	ENS	1	1	128	E_XNP	GR_4611	-1	-1	-1	-1	|EM_442,GR_4611	*(.0113065/1.1593092)

2	..2	ED_442-6-32	3	ENS	1	1	125	E_SCW	GR_5215	-1	-1	-1	-1	|EM_442,ED_442-6-32|ED_442-6-32,GR_5215	*(1/330)*(2.977/1)
2	..2	ED_442-6-31	3	ENS	1	1	125	E_SCW	GR_5212	-1	-1	-1	-1	|EM_442,ED_442-6-31|ED_442-6-31,GR_5212	*(1/330)*(3.331/1)
2	..2	ED_442-8-32	1	ENS	1	1	125	E_SCW	GR_8613	-1	-1	-1	-1	|EM_442,ED_442-8-32|ED_442-8-32,GR_8613	*(1/225)*(1/1)
2	..2	ED_442-8-31	1	ENS	1	1	125	E_SCW	GR_5212	-1	-1	-1	-1	|EM_442,ED_442-8-31|ED_442-8-31,GR_5212	*(1/225)*(2.305/1)
2	..2	ED_442-6-32	3	ENS	1	1	125	E_SCW	GR_8613	-1	-1	-1	-1	|EM_442,ED_442-6-32|ED_442-6-32,GR_8613	*(1/330)*(1/1)
2	..2	ED_442-8-33	1	ENS	1	1	125	E_SCW	GR_8613	-1	-1	-1	-1	|EM_442,ED_442-8-33|ED_442-8-33,GR_8613	*(1/225)*(1/1)
2	..2	ED_442-6-31	3	ENS	1	1	125	E_SCW	GR_8612	-1	-1	-1	-1	|EM_442,ED_442-6-31|ED_442-6-31,GR_8612	*(1/330)*(1/1)
2	..2	ED_442-6-33	3	ENS	1	1	125	E_SCW	GR_5214	-1	-1	-1	-1	|EM_442,ED_442-6-33|ED_442-6-33,GR_5214	*(1/330)*(.241/1)
2	..2	ED_442-8-32	1	ENS	1	1	125	E_SCW	GR_5214	-1	-1	-1	-1	|EM_442,ED_442-8-32|ED_442-8-32,GR_5214	*(1/225)*(.167/1)
2	..2	ED_442-8-31	1	ENS	1	1	125	E_SCW	GR_8612	-1	-1	-1	-1	|EM_442,ED_442-8-31|ED_442-8-31,GR_8612	*(1/225)*(1/1)
2	..2	ED_442-6-33	3	ENS	1	1	125	E_SCW	GR_8613	-1	-1	-1	-1	|EM_442,ED_442-6-33|ED_442-6-33,GR_8613	*(1/330)*(1/1)
2	..2	ED_442-8-33	1	ENS	1	1	125	E_SCW	GR_5111	-1	-1	-1	-1	|EM_442,ED_442-8-33|ED_442-8-33,GR_5111	*(1/225)*(3.34/1)


SELECT DISTINCT bi2.lvl
        ,      bi2.level_tree
        ,      bi2.part_no     
        ,      bi2.revision      
        ,      bi2.plant         
        ,      bi2.alternative   
        ,      bi2.preferred
        ,      BI2.STATUS        
		,      BI2.FRAME_ID      
		,      bi2.component_part      
		,      bi2.comp_revision
		,      bi2.comp_alternative
        ,      bi2.comp_preferred
		,      bi2.comp_frame_id
        ,      bi2.path
        ,      bi2.quantity_path
FROM		
(SELECT LEVEL   LVL
,      RPAD('.', (level-1)*2, '.') || LEVEL AS level_tree
,      PART_NO
, REVISION
, PLANT
, ALTERNATIVE
, PREFERRED
, BASE_QUANTITY
, STATUS
, ISSUED_DATE
, FRAME_ID
, ITEM_NUMBER
, COMPONENT_PART
, COMP_REVISION
, COMP_PLANT
, COMP_ALTERNATIVE
, COMP_PREFERRED
, COMP_BASE_QUANTITY
, COMP_STATUS
, COMP_ISSUED_DATE
, COMP_FRAME_ID
, QUANTITY
, UOM
, CHARACTERISTIC
,      sys_connect_by_path( bi.part_no||decode(bi.characteristic,null,'','-'||bi.characteristic) || ',' || bi.component_part ,'|')  path    
,      sys_connect_by_path( '('||bi.quantity||'/'||bi.base_quantity||')', '*')  quantity_path
FROM  mv_bom_item_comp_header bi
where bi.preferred      = 1
and   bi.comp_preferred in (1, -1)
START WITH bi.PART_NO = 'EM_442' and preferred = 1
CONNECT BY NOCYCLE  bi.part_no = prior bi.component_part   
               and bi.revision  = prior bi.comp_revision   
               and bi.alternative = prior bi.comp_alternative
			   and  bi.preferred = prior bi.comp_preferred  
order siblings by bi.component_part
) bi2

1	1	EM_442	29	ENS	1	1	128	E_XNP	GR_1151	-1	-1	-1	-1	|EM_442,GR_1151	*(.2798354/1.1593092)
1	1	EM_442	29	ENS	1	1	128	E_XNP	GR_4611	-1	-1	-1	-1	|EM_442,GR_4611	*(.0113065/1.1593092)
1	1	EM_442	29	ENS	1	1	128	E_XNP	GR_4312	-1	-1	-1	-1	|EM_442,GR_4312	*(.0282662/1.1593092)
1	1	EM_442	29	ENS	1	1	128	E_XNP	GR_4321	-1	-1	-1	-1	|EM_442,GR_4321	*(.0169597/1.1593092)
1	1	EM_442	29	ENS	1	1	128	E_XNP	GR_5111	-1	-1	-1	-1	|EM_442,GR_5111	*(.0169597/1.1593092)
1	1	EM_442	29	ENS	1	1	128	E_XNP	GR_4651	-1	-1	-1	-1	|EM_442,GR_4651	*(.0056532/1.1593092)
1	1	EM_442	29	ENS	1	1	128	E_XNP	GR_5215	-1	-1	-1	-1	|EM_442,GR_5215	*(.0104585/1.1593092)
1	1	EM_442	29	ENS	1	1	128	E_XNP	GR_5214	-1	-1	-1	-1	|EM_442,GR_5214	*(.000848/1.1593092)
1	1	EM_442	29	ENS	1	1	128	E_XNP	GR_1411	-1	-1	-1	-1	|EM_442,GR_1411	*(.2854886/1.1593092)
1	1	EM_442	29	ENS	1	1	128	E_XNP	GR_5212	-1	-1	-1	-1	|EM_442,GR_5212	*(.0117022/1.1593092)
1	1	EM_442	29	ENS	1	1	128	E_XNP	GR_2132	-1	-1	-1	-1	|EM_442,GR_2132	*(.423993/1.1593092)
1	1	EM_442	29	ENS	1	1	128	E_XNP	GR_3511	-1	-1	-1	-1	|EM_442,GR_3511	*(.0678389/1.1593092)


SELECT DISTINCT bi2.lvl
        ,      bi2.level_tree
        ,      bi2.part_no     
        ,      bi2.revision      
        ,      bi2.plant         
        ,      bi2.alternative   
        ,      bi2.preferred
        ,      BI2.STATUS        
		,      BI2.FRAME_ID      
		,      bi2.component_part      
		,      bi2.comp_revision
		,      bi2.comp_alternative
        ,      bi2.comp_preferred
		,      bi2.comp_frame_id
        ,      bi2.path
        ,      bi2.quantity_path
FROM		
(SELECT LEVEL   LVL
,      RPAD('.', (level-1)*2, '.') || LEVEL AS level_tree
,      PART_NO
, REVISION
, PLANT
, ALTERNATIVE
, PREFERRED
, BASE_QUANTITY
, STATUS
, ISSUED_DATE
, FRAME_ID
, ITEM_NUMBER
, COMPONENT_PART
, COMP_REVISION
, COMP_PLANT
, COMP_ALTERNATIVE
, COMP_PREFERRED
, COMP_BASE_QUANTITY
, COMP_STATUS
, COMP_ISSUED_DATE
, COMP_FRAME_ID
, QUANTITY
, UOM
, CHARACTERISTIC
,      sys_connect_by_path( bi.part_no||decode(bi.characteristic,null,'','-'||bi.characteristic) || ',' || bi.component_part ,'|')  path    
,      sys_connect_by_path( '('||bi.quantity||'/'||bi.base_quantity||')', '*')  quantity_path
FROM  mv_bom_item_comp_header bi
where bi.preferred      = 1
and   bi.comp_preferred in (1)
START WITH bi.PART_NO = 'EM_522' and preferred = 1
CONNECT BY NOCYCLE  bi.part_no = prior bi.component_part   
               and bi.revision  = prior bi.comp_revision   
               and bi.alternative = prior bi.comp_alternative
			   and  bi.preferred = prior bi.comp_preferred  
order siblings by bi.component_part
) bi2

1	1	EM_522	19	ENS	1	1	127	E_XNP	EM_422	26	1	1	E_XNP	|EM_522,EM_422	*(1.1229619/1.122962)
2	..2	EM_422	26	ENS	1	1	127	E_XNP	GR_3511	-1	-1	-1	-1	|EM_522,EM_422|EM_422,GR_3511	*(1.1229619/1.122962)*(.0167711/1.1243316)
2	..2	EM_422	26	ENS	1	1	127	E_XNP	GR_5214	-1	-1	-1	-1	|EM_522,EM_422|EM_422,GR_5214	*(1.1229619/1.122962)*(.0020125/1.1243316)
2	..2	EM_422	26	ENS	1	1	127	E_XNP	GR_5112	-1	-1	-1	-1	|EM_522,EM_422|EM_422,GR_5112	*(1.1229619/1.122962)*(.0201253/1.1243316)
2	..2	EM_422	26	ENS	1	1	127	E_XNP	GR_4711	-1	-1	-1	-1	|EM_522,EM_422|EM_422,GR_4711	*(1.1229619/1.122962)*(.0067084/1.1243316)
2	..2	EM_422	26	ENS	1	1	127	E_XNP	GR_2212	-1	-1	-1	-1	|EM_522,EM_422|EM_422,GR_2212	*(1.1229619/1.122962)*(.0335421/1.1243316)
2	..2	EM_422	26	ENS	1	1	127	E_XNP	GR_4651	-1	-1	-1	-1	|EM_522,EM_422|EM_422,GR_4651	*(1.1229619/1.122962)*(.0053667/1.1243316)
2	..2	EM_422	26	ENS	1	1	127	E_XNP	GR_4611	-1	-1	-1	-1	|EM_522,EM_422|EM_422,GR_4611	*(1.1229619/1.122962)*(.0134168/1.1243316)
2	..2	EM_422	26	ENS	1	1	127	E_XNP	GR_2134	-1	-1	-1	-1	|EM_522,EM_422|EM_422,GR_2134	*(1.1229619/1.122962)*(.3152957/1.1243316)
2	..2	EM_422	26	ENS	1	1	127	E_XNP	GR_1151	-1	-1	-1	-1	|EM_522,EM_422|EM_422,GR_1151	*(1.1229619/1.122962)*(.670842/1.1243316)
2	..2	EM_422	26	ENS	1	1	127	E_XNP	GR_4312	-1	-1	-1	-1	|EM_522,EM_422|EM_422,GR_4312	*(1.1229619/1.122962)*(.0268337/1.1243316)
2	..2	EM_422	26	ENS	1	1	127	E_XNP	GR_4321	-1	-1	-1	-1	|EM_522,EM_422|EM_422,GR_4321	*(1.1229619/1.122962)*(.0134168/1.1243316)
3	....3	ED_422-6-11	1	ENS	1	1	125	E_SCW	GR_8613	-1	-1	-1	-1	|EM_522,EM_422|EM_422,ED_422-6-11|ED_422-6-11,GR_8613	*(1.1229619/1.122962)*(1/308)*(1/1)
3	....3	ED_422-6-11	1	ENS	1	1	125	E_SCW	GR_5214	-1	-1	-1	-1	|EM_522,EM_422|EM_422,ED_422-6-11|ED_422-6-11,GR_5214	*(1.1229619/1.122962)*(1/308)*(.551/1)

--DIT IS FOUT. DE ED_422-6-11 hoor er niet in...
--En vreemd genoeg: hoe komen part-nr ED_422-6-11 aan alternative=1 ???????????? Is toch echt ALT=2 !!!!

SELECT DISTINCT bi2.lvl
        ,      bi2.level_tree
        ,      bi2.part_no     
        ,      bi2.revision      
        ,      bi2.plant         
        ,      bi2.alternative   
        ,      bi2.preferred
        ,      BI2.STATUS        
		,      BI2.FRAME_ID      
		,      bi2.component_part      
		,      bi2.comp_revision
		,      bi2.comp_alternative
        ,      bi2.comp_preferred
		,      bi2.comp_frame_id
        ,      bi2.path
        ,      bi2.quantity_path
FROM		
(SELECT LEVEL   LVL
,      RPAD('.', (level-1)*2, '.') || LEVEL AS level_tree
,      PART_NO
, REVISION
, PLANT
, ALTERNATIVE
, PREFERRED
, BASE_QUANTITY
, STATUS
, ISSUED_DATE
, FRAME_ID
, ITEM_NUMBER
, COMPONENT_PART
, COMP_REVISION
, COMP_PLANT
, COMP_ALTERNATIVE
, COMP_PREFERRED
, COMP_BASE_QUANTITY
, COMP_STATUS
, COMP_ISSUED_DATE
, COMP_FRAME_ID
, QUANTITY
, UOM
, CHARACTERISTIC
,      sys_connect_by_path( bi.part_no||decode(bi.characteristic,null,'','-'||bi.characteristic) || ',' || bi.component_part ,'|')  path    
,      sys_connect_by_path( '('||bi.quantity||'/'||bi.base_quantity||')', '*')  quantity_path
FROM  (select * 
       from mv_bom_item_comp_header b
       where b.preferred      = 1
       and   b.comp_preferred in (1,-1) 
      ) bi
START WITH bi.PART_NO = 'EM_522' and preferred = 1
CONNECT BY NOCYCLE  bi.part_no = prior bi.component_part   
               and bi.revision  = prior bi.comp_revision   
               and bi.alternative = prior bi.comp_alternative
			   and  bi.preferred = prior bi.comp_preferred  
order siblings by bi.component_part
) bi2

1	1	EM_522	19	ENS	1	1	127	E_XNP	EM_422	26	1	1	E_XNP	|EM_522,EM_422	*(1.1229619/1.122962)
2	..2	EM_422	26	ENS	1	1	127	E_XNP	GR_3511	-1	-1	-1	-1	|EM_522,EM_422|EM_422,GR_3511	*(1.1229619/1.122962)*(.0167711/1.1243316)
2	..2	EM_422	26	ENS	1	1	127	E_XNP	GR_5214	-1	-1	-1	-1	|EM_522,EM_422|EM_422,GR_5214	*(1.1229619/1.122962)*(.0020125/1.1243316)
2	..2	EM_422	26	ENS	1	1	127	E_XNP	GR_2212	-1	-1	-1	-1	|EM_522,EM_422|EM_422,GR_2212	*(1.1229619/1.122962)*(.0335421/1.1243316)
2	..2	EM_422	26	ENS	1	1	127	E_XNP	GR_4651	-1	-1	-1	-1	|EM_522,EM_422|EM_422,GR_4651	*(1.1229619/1.122962)*(.0053667/1.1243316)
2	..2	EM_422	26	ENS	1	1	127	E_XNP	GR_4611	-1	-1	-1	-1	|EM_522,EM_422|EM_422,GR_4611	*(1.1229619/1.122962)*(.0134168/1.1243316)
2	..2	EM_422	26	ENS	1	1	127	E_XNP	GR_2134	-1	-1	-1	-1	|EM_522,EM_422|EM_422,GR_2134	*(1.1229619/1.122962)*(.3152957/1.1243316)
2	..2	EM_422	26	ENS	1	1	127	E_XNP	GR_1151	-1	-1	-1	-1	|EM_522,EM_422|EM_422,GR_1151	*(1.1229619/1.122962)*(.670842/1.1243316)
2	..2	EM_422	26	ENS	1	1	127	E_XNP	GR_4312	-1	-1	-1	-1	|EM_522,EM_422|EM_422,GR_4312	*(1.1229619/1.122962)*(.0268337/1.1243316)
2	..2	EM_422	26	ENS	1	1	127	E_XNP	GR_4321	-1	-1	-1	-1	|EM_522,EM_422|EM_422,GR_4321	*(1.1229619/1.122962)*(.0134168/1.1243316)
2	..2	EM_422	26	ENS	1	1	127	E_XNP	GR_4711	-1	-1	-1	-1	|EM_522,EM_422|EM_422,GR_4711	*(1.1229619/1.122962)*(.0067084/1.1243316)
2	..2	EM_422	26	ENS	1	1	127	E_XNP	GR_5112	-1	-1	-1	-1	|EM_522,EM_422|EM_422,GR_5112	*(1.1229619/1.122962)*(.0201253/1.1243316)

--Nu wel de juiste resultaten...!!!!!!!!!!!!!!!!


--CONTROLE OP JUISTE COMPONENTEN/MATERIALS BIJ TYRE obv NIEUWE MV:
--EF_Y245/45R18UVPX
SELECT DISTINCT bi2.lvl
        ,      bi2.level_tree
        ,      bi2.part_no     
        ,      bi2.revision      
        ,      bi2.plant         
        ,      bi2.alternative   
        ,      bi2.preferred
        ,      BI2.STATUS        
		,      BI2.FRAME_ID      
		,      bi2.component_part      
		,      bi2.comp_revision
		,      bi2.comp_alternative
        ,      bi2.comp_preferred
		,      bi2.comp_frame_id
        ,      bi2.path
        ,      bi2.quantity_path
FROM		
(SELECT LEVEL   LVL
,      RPAD('.', (level-1)*2, '.') || LEVEL AS level_tree
,      PART_NO
, REVISION
, PLANT
, ALTERNATIVE
, PREFERRED
, BASE_QUANTITY
, STATUS
, ISSUED_DATE
, FRAME_ID
, ITEM_NUMBER
, COMPONENT_PART
, COMP_REVISION
, COMP_PLANT
, COMP_ALTERNATIVE
, COMP_PREFERRED
, COMP_BASE_QUANTITY
, COMP_STATUS
, COMP_ISSUED_DATE
, COMP_FRAME_ID
, QUANTITY
, UOM
, CHARACTERISTIC
,      sys_connect_by_path( bi.part_no||decode(bi.characteristic,null,'','-'||bi.characteristic) || ',' || bi.component_part ,'|')  path    
,      sys_connect_by_path( '('||bi.quantity||'/'||bi.base_quantity||')', '*')  quantity_path
FROM  (select * 
       from mv_bom_item_comp_header b
       where b.preferred      = 1
       and   b.comp_preferred in (1,-1) 
      ) bi
START WITH bi.PART_NO = 'EF_Y245/45R18UVPX' and preferred = 1
CONNECT BY NOCYCLE  bi.part_no = prior bi.component_part   
               and bi.revision  = prior bi.comp_revision   
               and bi.alternative = prior bi.comp_alternative
			   and  bi.preferred = prior bi.comp_preferred  
order siblings by bi.part_no
) bi2

--369 rijen !!!!!!!




--Huidige PROCEDURE IN FNC_BEPAAL_HEADER_GEWICHT:
select mainpart
,      sum(decode(uom,'kg',quantity_kg,0))      gewicht
,      sum(decode(uom,'kg',bom_quantity_kg,0))  header_bom_gewicht_som_items
FROM
(
SELECT bi2.LVL
        ,      bi2.level_tree
        ,      bi2.mainpart
        ,      bi2.mainrevision
        ,      bi2.mainplant
        ,      bi2.mainalternative
        ,      bi2.mainbasequantity
        ,      bi2.mainminqty
        ,      bi2.mainmaxqty
        ,      bi2.mainsumitemsquantity
        ,      bi2.mainstatus
        ,      bi2.mainframeid
        ,      bi2.mainpartdescription
        ,      bi2.mainpartbaseuom
        ,      bi2.part_no
        ,      bi2.revision
        ,      bi2.plant
        ,      bi2.alternative
        ,      bi2.item_number
        ,      bi2.component_part
        ,      bi2.componentdescription
        ,      bi2.item_header_base_quantity
        ,      bi2.quantity
        ,      bi2.uom
        ,      bi2.uom_org
        ,      bi2.quantity_kg
        ,      bi2.status
        ,      bi2.characteristic_id 
        ,      bi2.functiecode
        ,      bi2.path
        ,      bi2.quantity_path
        ,      DBA_BEPAAL_QUANTITY_KG(bi2.quantity_path)  bom_quantity_kg
        from
        (
        with sel_bom_header as 
        (select bh.part_no
         ,      bh.revision
         ,      bh.plant
         ,      bh.alternative
         ,      bh.preferred
         ,      bh.base_quantity
         ,      bh.min_qty
         ,      bh.max_qty
         ,      (select sum(case 
                            when b.uom = 'g' 
                            then (b.quantity/1000) 
                            when b.uom = 'kg'
                            then b.quantity
                            else 0 end) 
                 from bom_item b 
                 where b.part_no = bh.part_no 
                 and b.revision = bh.revision 
                 and b.alternative = bh.alternative)      sum_items_quantity
         ,      s.sort_desc
         ,      sh.frame_id
         ,      p.description
         ,      p.base_uom      
         from status               s  
         ,    part                 p
         ,    specification_header sh
         ,    bom_header           bh 
         where  bh.part_no     = 'EG_H620/50R22-154G'   --pl_header_part_no  --'EM_764' --'EG_H620/50R22-154G'  --l_header_part_no
         and    bh.revision    = 12 --pl_header_revision --(select max(sh1.revision) from status s1, specification_header sh1 where sh1.part_no = bh.part_no and sh1.status = s1.status and s1.status_type in ('CURRENT','HISTORIC'))
         and    bh.alternative = 1 --pl_header_alternative  --default alternative bij preferred=1, maar kan ook expliciet preferred=0
         and    bh.part_no    = p.part_no
         and    bh.part_no    = sh.part_no
         and    bh.revision   = sh.revision
         and    sh.status     = s.status         
         --and    s.status_type in ('CURRENT','HISTORIC')
         --welk alternative we gebruiken is afhankelijk van PREFERRED-ind.
         --and    bh.preferred = 1         
         and    rownum = 1
        ) 
        select LEVEL   LVL
        ,      RPAD('.', (level-1)*2, '.') || LEVEL AS level_tree
        ,      bh.part_no             mainpart
        ,      bh.revision            mainrevision
        ,      bh.plant               mainplant
        ,      bh.alternative         mainalternative
        ,      bh.base_quantity       mainbasequantity
          ,      bh.min_qty             mainminqty
        ,      bh.max_qty             mainmaxqty
        ,      bh.sum_items_quantity  mainsumitemsquantity
        ,      bh.sort_desc           mainstatus
        ,      bh.frame_id            mainframeid
        ,      bh.description         mainpartdescription
        ,      bh.base_uom            mainpartbaseuom
        ,      b.part_no
        ,      b.revision
        ,      b.plant
        ,      b.alternative
        ,      b.item_number
        ,      b.component_part
        ,      (select pi.description from part pi where pi.part_no = b.component_part)  componentdescription
        ,      b.item_header_base_quantity
        ,      b.quantity
        ,      b.uom
        ,      b.uom   uom_org
        ,      b.quantity_kg
        ,      b.status
        ,      b.characteristic_id       --FUNCTIECODE
        ,      b.functiecode             --functiecode-descr
        ,      sys_connect_by_path( b.part_no||decode(b.characteristic_id,null,'','-'||b.characteristic_id) || ',' || b.component_part ,'|')  path
        ,      sys_connect_by_path( '('||b.quantity_kg||'/'||b.item_header_base_quantity||')', '*')  quantity_path
        FROM ( SELECT bi.part_no
             ,      bi.revision
             ,      bi.plant
             ,      bi.alternative
             ,      bi.item_number
             ,      bi.component_part
             --,      (select bh.base_quantity from bom_header bh where bh.part_no = bi.part_no and bh.revision = bi.revision and bh.alternative= bi.alternative )   item_header_base_quantity
             ,      h.base_quantity   item_header_base_quantity
             ,      bi.quantity
             ,      case when bi.uom in ('pcs','ST') or bi.uom like ('%m%') --m/m2/km    
                         then (--indien een material met uom=pcs dan weight uit property halen, en uom aanpassen naar "kg"
                              SELECT 'kg'
                              FROM specification_prop sp
                              WHERE sp.part_no        = bi.component_part   --'GR_9787'
                              AND NOT exists (select '' from bom_item bi3 where bi3.part_no = bi.component_part )  
                              --PS: gebruik component-item/header-spec-header-revision
                              --PS: gebruik component-item/spec-header-revision, MATERIALS hebben alleen SPECIFICATION-header, geen bom-header !!!
                              AND   sp.revision = (select max(sh1.revision) 
                                                   from status s1, specification_header sh1
                                                   where   sh1.part_no    = sp.part_no             --is component-part-no
                                                   and     sh1.status     = s1.status 
                                                   and     s1.status_type in ('CURRENT','HISTORIC')
                                                  )
                              AND   sp.section_id     = 700755 --  SAP information
                              --AND   sp.sub_section_id = 701502 -- A        --alle SAP-WEIGHT-properties meenemen in berekening
                              AND   sp.property_group = 0 -- (none)
                              AND   sp.property       = 703262 -- Weight
                              and   rownum = 1
                              UNION
                              --indien component-part met uom=pcs dan aantal meenemen in de berekening
                              select bi.uom
                              from dual
                              where exists (select '' from bom_item bi3 where bi3.part_no = bi.component_part )   --revision = header-revision, geen comp-revision, dus kunnen hier niet expliciet op checken...
                             )
                         else bi.uom 
                    end   uom
             ,      bi.uom     uom_org
             ,      case when bi.uom = 'g' 
                         then (bi.quantity/1000) 
                         when bi.uom = 'kg'
                         then bi.quantity
                         when bi.uom in ('pcs','ST') or bi.uom like ('%m%')    --m/m2/km
                         then (--indien een material met uom=pcs dan weight uit property halen
                              SELECT (sp.num_1 * bi.quantity)
                              FROM specification_prop sp
                              WHERE sp.part_no        = bi.component_part   --'GR_9787'
                              AND NOT exists (select '' from bom_item bi3 where bi3.part_no = bi.component_part ) 
                              --PS: gebruik component-item/spec-header-revision, MATERIALS hebben alleen SPECIFICATION-header, geen bom-header !!!
                              AND   sp.revision = (select max(sh1.revision) 
                                                   from status s1, specification_header sh1
                                                   where   sh1.part_no    = sp.part_no        --is component-part-no
                                                   and     sh1.status     = s1.status 
                                                   and     s1.status_type in ('CURRENT','HISTORIC')
                                                  )
                              AND   sp.section_id     = 700755 --  SAP information
                              --AND   sp.sub_section_id = 701502 -- A    --alle SAP-WEIGHT-properties meenemen in berekening
                              AND   sp.property_group = 0 -- (none)
                              AND   sp.property       = 703262 -- Weight
                              and   rownum = 1
                              UNION
                              --indien component-part met uom=pcs dan aantal meenemen in de berekening
                              select bi.quantity 
                              from dual
                              where exists (select '' from bom_item bi3 where bi3.part_no = bi.component_part )   --revision = header-revision, geen comp-revision, dus kunnen hier niet expliciet op checken...
                              )
                          else bi.quantity 
                    end   quantity_kg
             ,      s.sort_desc     status
             ,      bi.ch_1         characteristic_id       --FUNCTIECODE
             ,      c.description   functiecode             --functiecode-descr
             FROM status               s
             ,    specification_header sh
             ,    bom_header           h
             ,    characteristic       c
             ,    bom_item             bi   
             WHERE h.part_no      = bi.part_no
             and   h.revision     = bi.revision
             --zoek hoogste specification-revision waar nog een bom-header bij voorkomt
             and   h.revision   =  (select max(sh1.revision) 
                                    from status s1, specification_header sh1, bom_header h2 
                                    where   h2.part_no  = h.part_no 
                                    and    sh1.part_no  = h2.part_no 
                                    AND    sh1.revision = h2.revision 
                                    and    sh1.status   = s1.status 
                                    and    s1.status_type in ('CURRENT','HISTORIC')
                                   )
             --and   h.preferred    = 1
             and   h.preferred    = decode(h.part_no, 'EG_H620/50R22-154G', 1, 1)     --indien 1e Keer dan uitgaan van meegegeven alternative, verder weer uitgaan met preferred.
             and   h.alternative  = decode(h.part_no, 'EG_H620/50R22-154G', 12, h.alternative)
             and   h.alternative  = bi.alternative
             and   h.part_no      = sh.part_no
             and   h.revision     = sh.revision
             and   sh.status      = s.status  
             --and   s.status_type  = 'CURRENT' 
             and   bi.ch_1        = c.characteristic_id(+)
             ) b
        ,      sel_bom_header bh     
        START WITH b.part_no = bh.part_no 
        CONNECT BY NOCYCLE PRIOR b.component_part = b.part_no --and b.component_revision = b.revision
        order siblings by b.part_no
        )  bi2
        --select alleen gewicht van materialen...
        where bi2.component_part NOT IN (select bi3.part_no from bom_item bi3 where bi3.part_no = bi2.component_part)
)
GROUP BY MAINPART
;

--NU: 369 rijen !!!
--'EG_H620/50R22-154G': 





--*******************************************
--query INCL. gewicht ter vervanging van oorspronkelijke query , NU MET GEBRUIK VAN MV
--*******************************************
select mainpart
,      sum(decode(uom,'kg',quantity_kg,0))      gewicht
,      sum(decode(uom,'kg',bom_quantity_kg,0))  header_bom_gewicht_som_items
from (
SELECT bi2.LVL
        ,      bi2.level_tree
        ,      bi2.mainpart
        ,      bi2.mainrevision
        ,      bi2.mainplant
        ,      bi2.mainalternative
        ,      bi2.mainbasequantity
        --,      bi2.mainminqty
        --,      bi2.mainmaxqty
        --,      bi2.mainsumitemsquantity
        ,      bi2.mainstatus
        ,      bi2.mainframeid
        ,      bi2.mainpartdescription
        ,      bi2.mainpartbaseuom
        ,      bi2.part_no
        ,      bi2.revision
        ,      bi2.plant
        ,      bi2.alternative
		,      bi2.preferred
		,      bi2.part_status
        ,      bi2.item_number
        ,      bi2.component_part
        ,      bi2.componentdescription
		,      bi2.comp_revision
		,      bi2.comp_alternative
		,      bi2.comp_preferred
        ,      bi2.comp_status
        ,      bi2.item_header_base_quantity
        ,      bi2.quantity
        ,      bi2.uom
        ,      bi2.uom_org
        ,      bi2.quantity_kg
        ,      bi2.characteristic_id 
        ,      bi2.functiecode
        ,      bi2.path
        ,      bi2.quantity_path
        ,      DBA_BEPAAL_QUANTITY_KG(bi2.quantity_path)  bom_quantity_kg
        from
        (
        with sel_bom_header as 
			(select DISTINCT bih.part_no
			,      bih.revision
			,      bih.plant
			,      bih.alternative
			,      bih.preferred
			,      bih.base_quantity
			--,      bih.min_qty
			--,      bih.max_qty
			--,      case when bih.uom = 'g' 
			--			then (bih.quantity/1000) 
			--			when bih.uom = 'kg'
			--			then bih.quantity
			--			else 0 end         sum_items_quantity
			,      bih.status     			--pas later de sort-desc erbijhalen...
			,      bih.frame_id
			--,      p.description
			--,      p.base_uom      
			--from part                    p
            from  mv_bom_item_comp_header bih
            where  bih.part_no     = 'EG_H620/50R22-154G' --pl_header_part_no  --'EM_764' --'EG_H620/50R22-154G'  --l_header_part_no
			--and    bih.revision    = pl_header_revision --(select max(sh1.revision) from status s1, specification_header sh1 where sh1.part_no = bh.part_no and sh1.status = s1.status and s1.status_type in ('CURRENT','HISTORIC'))
			and    bih.alternative = 1 --pl_header_alternative  --default alternative bij preferred=1, maar kan ook expliciet preferred=0
			AND    bih.preferred   = 1
			--and    bih.part_no     = p.part_no
			--and    rownum = 1
			) 	
        select LEVEL   LVL
        ,      RPAD('.', (level-1)*2, '.') || LEVEL AS level_tree
        ,      bh.part_no             mainpart
        ,      bh.revision            mainrevision
        ,      bh.plant               mainplant
        ,      bh.alternative         mainalternative
		,      bh.preferred           mainpreferred
        ,      bh.base_quantity       mainbasequantity
        ,      (select s.sort_desc from status s where s.status = bh.status )     mainstatus
        ,      bh.frame_id            mainframeid
        ,      (select pi.description from part pi where pi.part_no = bh.part_no)  mainpartdescription
        ,      (select pi.base_uom    from part pi where pi.part_no = bh.part_no)  mainpartbaseuom
        ,      b.part_no
        ,      b.revision
        ,      b.plant
        ,      b.alternative
		,      b.issued_date                                                    headerissueddate
		,      b.preferred
		,      (select s.sort_desc from status s where s.status = b.status)     headerstatus
        ,      b.item_number
        ,      b.component_part
        ,      (select pi.description from part pi where pi.part_no = b.component_part)  componentdescription
		,      b.comp_revision              componentrevision
		,      b.comp_alternative           componentalternative
		,      b.comp_issued_date           componentissueddate
		,      b.comp_preferred
        ,      (select s.sort_desc from status s where s.status = b.comp_status)  componentstatus
        ,      b.item_header_base_quantity
        ,      b.quantity
        ,      b.uom
        ,      b.quantity_kg
        ,      b.characteristic_id       --FUNCTIECODE
        ,      b.functiecode             --functiecode-descr
        ,      sys_connect_by_path( b.part_no||decode(b.characteristic_id,null,'','-'||b.characteristic_id) || ',' || b.component_part ,'|')  path
        ,      sys_connect_by_path( '('||b.quantity_kg||'/'||b.item_header_base_quantity||')', '*')  quantity_path
        FROM ( SELECT bi.part_no
             ,      bi.revision
             ,      bi.plant
             ,      bi.alternative
			 ,      bi.preferred
			 ,      bi.issued_date
			 ,      bi.status
             ,      bi.item_number
             ,      bi.component_part
			 ,      bi.comp_revision
			 ,      bi.comp_alternative
			 ,      bi.comp_preferred
			 ,      bi.comp_status
             ,      bi.base_quantity   item_header_base_quantity
             ,      bi.quantity
             ,      case when bi.uom in ('pcs','ST') or bi.uom like ('%m%') --m/m2/km    
                         then (--indien een material met uom=pcs dan weight uit property halen, en uom aanpassen naar "kg"
                              SELECT 'kg'
                              FROM specification_prop sp
                              WHERE sp.part_no        = bi.component_part   --'GR_9787'
                              AND NOT exists (select '' from bom_item bi3 where bi3.part_no = bi.component_part )  
                              --PS: gebruik component-item/header-spec-header-revision
                              --PS: gebruik component-item/spec-header-revision, MATERIALS hebben alleen SPECIFICATION-header, geen bom-header !!!
                              AND   sp.revision = (select max(sh1.revision) 
                                                   from status s1, specification_header sh1
                                                   where   sh1.part_no    = sp.part_no             --is component-part-no
                                                   and     sh1.status     = s1.status 
                                                   and     s1.status_type in ('CURRENT','HISTORIC')
                                                  )
                              AND   sp.section_id     = 700755 --  SAP information
                              --AND   sp.sub_section_id = 701502 -- A        --alle SAP-WEIGHT-properties meenemen in berekening
                              AND   sp.property_group = 0 -- (none)
                              AND   sp.property       = 703262 -- Weight
                              and   rownum = 1
                              UNION
                              --indien component-part met uom=pcs dan aantal meenemen in de berekening
                              select bi.uom
                              from dual
                              where exists (select '' from bom_item bi3 where bi3.part_no = bi.component_part )   --revision = header-revision, geen comp-revision, dus kunnen hier niet expliciet op checken...
                             )
                         else bi.uom 
                    end   uom
             ,      case when bi.uom = 'g' 
                         then (bi.quantity/1000) 
                         when bi.uom = 'kg'
                         then bi.quantity
                         when bi.uom in ('pcs','ST') or bi.uom like ('%m%')    --m/m2/km
                         then (--indien een material met uom=pcs dan weight uit property halen
                              SELECT (sp.num_1 * bi.quantity)
                              FROM specification_prop sp
                              WHERE sp.part_no        = bi.component_part   --'GR_9787'
                              AND NOT exists (select '' from bom_item bi3 where bi3.part_no = bi.component_part ) 
                              --PS: gebruik component-item/spec-header-revision, MATERIALS hebben alleen SPECIFICATION-header, geen bom-header !!!
                              AND   sp.revision = (select max(sh1.revision) 
                                                   from status s1, specification_header sh1
                                                   where   sh1.part_no    = sp.part_no        --is component-part-no
                                                   and     sh1.status     = s1.status 
                                                   and     s1.status_type in ('CURRENT','HISTORIC')
                                                  )
                              AND   sp.section_id     = 700755 --  SAP information
                              --AND   sp.sub_section_id = 701502 -- A    --alle SAP-WEIGHT-properties meenemen in berekening
                              AND   sp.property_group = 0 -- (none)
                              AND   sp.property       = 703262 -- Weight
                              and   rownum = 1
                              UNION
                              --indien component-part met uom=pcs dan aantal meenemen in de berekening
                              select bi.quantity 
                              from dual
                              where exists (select '' from bom_item bi3 where bi3.part_no = bi.component_part )   --revision = header-revision, geen comp-revision, dus kunnen hier niet expliciet op checken...
                              )
                          else bi.quantity 
                    end   quantity_kg
             ,      bi.characteristic  characteristic_id       
             ,      (select c.description from characteristic c where c.characteristic_id = bi.characteristic)  functiecode
             FROM  mv_bom_item_comp_header bi
             WHERE (   bi.preferred = 1 
			       and bi.comp_preferred IN (1, -1) 
				   )
             ) b
        ,      sel_bom_header bh     
        START WITH b.part_no = bh.part_no and b.preferred = bh.preferred
        CONNECT BY NOCYCLE       PRIOR b.component_part   = b.part_no 
							and  prior b.comp_revision    = b.revision
							and  prior b.comp_alternative = b.alternative
							and  prior b.comp_preferred   = 1
        order siblings by b.part_no
        )  bi2
        --select alleen gewicht van materialen...
        where bi2.component_part NOT IN (select bi3.part_no from bom_item bi3 where bi3.part_no = bi2.component_part)
)
group by mainpart    
;

--EG_H620/50R22-154G	12	ENS	1	1	1	128	E_AT_GREENTYRE
--942 regels... (zonder PRIOR b.comp_preferred = 1) 
--220 regels... (met preferred=1)
--
--TOTAAL GEWICHT: EG_H620/50R22-154G	19.4396332	94.22812942243044070753856459621674374585


/*
Connecting to the database oracleprod-db-IS61-Interspc.
**************************************************************************************************************
COMP-PART-GEWICHT-MAINPART: EG_H620/50R22-154G
**************************************************************************************************************
l_LVL;l_mainpart;l_mainrevision;l_mainplant;l_mainalternative;l_mainframeid;l_part_no;l_revision;l_plant;l_alternative;l_header_issued_date;l_header_status;l_component_part;l_componentdescription;l_componentrevision;l_componentalternative;l_componentissueddate;l_componentstatus;l_characteristic_id;l_functiecode;l_path;l_quantity_path;l_bom_quantity_kg
**************************************************************************************************************
1;EG_H620/50R22-154G;12;ENS;1;E_AT_GREENTYRE;EG_H620/50R22-154G;12;ENS;1;12-01-2022 00:00:05;CRRNT QR5;EK_H620/50R22-154K;KARKAS (70);30;1;24-02-2022 12:38:31;CRRNT QR5;766;Carcass;|EG_H620/50R22-154G-766,EK_H620/50R22-154K;*(1/1);1
MAINPART-HEADER-TYRE: DBA_FNC_BEPAAL_HEADER_GEWICHT(PARTNO=MAINPART:EG_H620/50R22-154G SAP-code: ) HEADER-KG:94.2281294224
COMP-PART-GEWICHT: DBA_FNC_BEPAAL_HEADER_GEWICHT (COMP-PART: EG_H620/50R22-154G COMP: EK_H620/50R22-154K) HEADER-KG:41.5162753046
**************************************************************************************************************
2;EG_H620/50R22-154G;12;ENS;1;E_AT_GREENTYRE;EK_H620/50R22-154K;30;ENS;1;24-02-2022 12:38:31;CRRNT QR5;EB_18030E64E;HIEL  DR=64  VS=16 X 23  FL=110;11;1;22-03-2023 14:25:49;CRRNT QR5;903365;Bead;|EG_H620/50R22-154G-766,EK_H620/50R22-154K|EK_H620/50R22-154K-903365,EB_18030E64E;*(1/1)*(2/1);2
COMP-PART-GEWICHT: DBA_FNC_BEPAAL_HEADER_GEWICHT (COMP-PART: EK_H620/50R22-154K COMP: EB_18030E64E) HEADER-KG:2.2037258543
**************************************************************************************************************
3;EG_H620/50R22-154G;12;ENS;1;E_AT_GREENTYRE;EB_18030E64E;11;ENS;1;22-03-2023 14:25:49;CRRNT QR5;EB_V18030E64E;HIEL  DR=64;6;1;22-03-2023 14:12:14;CRRNT QR5;760;Bead bundle;|EG_H620/50R22-154G-766,EK_H620/50R22-154K|EK_H620/50R22-154K-903365,EB_18030E64E|EB_18030E64E-760,EB_V18030E64E;*(1/1)*(2/1)*(1/1);2
COMP-PART-GEWICHT: DBA_FNC_BEPAAL_HEADER_GEWICHT (COMP-PART: EB_18030E64E COMP: EB_V18030E64E) HEADER-KG:1.4049997705
**************************************************************************************************************
4;EG_H620/50R22-154G;12;ENS;1;E_AT_GREENTYRE;EB_V18030E64E;6;ENS;1;22-03-2023 14:12:14;CRRNT QR5;EM_700;FM Bead ;82;1;29-03-2023 08:42:59;CRRNT QR5;903367;Bead compound;|EG_H620/50R22-154G-766,EK_H620/50R22-154K|EK_H620/50R22-154K-903365,EB_18030E64E|EB_18030E64E-760,EB_V18030E64E|EB_V18030E64E-903367,EM_700;*(1/1)*(2/1)*(1/1)*(.213/1);.426
COMP-PART-GEWICHT: DBA_FNC_BEPAAL_HEADER_GEWICHT (COMP-PART: EB_V18030E64E COMP: EM_700) HEADER-KG:.9999989227
**************************************************************************************************************
5;EG_H620/50R22-154G;12;ENS;1;E_AT_GREENTYRE;EM_700;82;ENS;1;29-03-2023 08:42:59;CRRNT QR5;EM_400;MB Bead ;27;1;21-03-2023 14:32:59;CRRNT QR5;;;|EG_H620/50R22-154G-766,EK_H620/50R22-154K|EK_H620/50R22-154K-903365,EB_18030E64E|EB_18030E64E-760,EB_V18030E64E|EB_V18030E64E-903367,EM_700|EM_700,EM_400;*(1/1)*(2/1)*(1/1)*(.213/1)*(1.183308/1.226261);.411078235383821225660768792288101798883
COMP-PART-GEWICHT: DBA_FNC_BEPAAL_HEADER_GEWICHT (COMP-PART: EM_700 COMP: EM_400) HEADER-KG:1.0000005738
**************************************************************************************************************
3;EG_H620/50R22-154G;12;ENS;1;E_AT_GREENTYRE;EB_18030E64E;11;ENS;1;22-03-2023 14:25:49;CRRNT QR5;EM_747;FM Apex PCR;36;1;26-11-2021 09:08:26;CRRNT QR4;903368;Apex compound;|EG_H620/50R22-154G-766,EK_H620/50R22-154K|EK_H620/50R22-154K-903365,EB_18030E64E|EB_18030E64E-903368,EM_747;*(1/1)*(2/1)*(.52/1);1.04
COMP-PART-GEWICHT: DBA_FNC_BEPAAL_HEADER_GEWICHT (COMP-PART: EB_18030E64E COMP: EM_747) HEADER-KG:.9999997889
**************************************************************************************************************
4;EG_H620/50R22-154G;12;ENS;1;E_AT_GREENTYRE;EM_747;36;ENS;1;26-11-2021 09:08:26;CRRNT QR4;EM_447;MB Apex;16;1;16-06-2022 08:42:53;CRRNT QR4;;;|EG_H620/50R22-154G-766,EK_H620/50R22-154K|EK_H620/50R22-154K-903365,EB_18030E64E|EB_18030E64E-903368,EM_747|EM_747,EM_447;*(1/1)*(2/1)*(.52/1)*(1.073594/1.144467);.975596290675047860707211304476232167463
COMP-PART-GEWICHT: DBA_FNC_BEPAAL_HEADER_GEWICHT (COMP-PART: EM_747 COMP: EM_447) HEADER-KG:1.0000007065
**************************************************************************************************************
3;EG_H620/50R22-154G;12;ENS;1;E_AT_GREENTYRE;EB_18030E64E;11;ENS;1;22-03-2023 14:25:49;CRRNT QR5;ER_NE03-60-0110;FLIPPER GE/GE;5;1;07-07-2021 11:18:16;CRRNT QR5;901341;Flipper;|EG_H620/50R22-154G-766,EK_H620/50R22-154K|EK_H620/50R22-154K-903365,EB_18030E64E|EB_18030E64E-901341,ER_NE03-60-0110;*(1/1)*(2/1)*(1.9/1);3.8
COMP-PART-GEWICHT: DBA_FNC_BEPAAL_HEADER_GEWICHT (COMP-PART: EB_18030E64E COMP: ER_NE03-60-0110) HEADER-KG:.1466979966
**************************************************************************************************************
4;EG_H620/50R22-154G;12;ENS;1;E_AT_GREENTYRE;ER_NE03-60-0110;5;ENS;1;07-07-2021 11:18:16;CRRNT QR5;ER_NE03-60-0770;FLIPPERMATERIAAL;10;1;17-08-2021 00:00:02;CRRNT QR5;771;Parent roll;|EG_H620/50R22-154G-766,EK_H620/50R22-154K|EK_H620/50R22-154K-903365,EB_18030E64E|EB_18030E64E-901341,ER_NE03-60-0110|ER_NE03-60-0110-771,ER_NE03-60-0770;*(1/1)*(2/1)*(1.9/1)*(.143/1);.5434
COMP-PART-GEWICHT: DBA_FNC_BEPAAL_HEADER_GEWICHT (COMP-PART: ER_NE03-60-0110 COMP: ER_NE03-60-0770) HEADER-KG:1.0258601159
**************************************************************************************************************
5;EG_H620/50R22-154G;12;ENS;1;E_AT_GREENTYRE;ER_NE03-60-0770;10;ENS;1;17-08-2021 00:00:02;CRRNT QR5;EC_NE03;REKNUMMER NE03 GEEL/GEEL;10;1;12-03-2020 13:23:38;CRRNT QR5;771;Parent roll;|EG_H620/50R22-154G-766,EK_H620/50R22-154K|EK_H620/50R22-154K-903365,EB_18030E64E|EB_18030E64E-901341,ER_NE03-60-0110|ER_NE03-60-0110-771,ER_NE03-60-0770|ER_NE03-60-0770-771,EC_NE03;*(1/1)*(2/1)*(1.9/1)*(.143/1)*(.77/1);.418418
COMP-PART-GEWICHT: DBA_FNC_BEPAAL_HEADER_GEWICHT (COMP-PART: ER_NE03-60-0770 COMP: EC_NE03) HEADER-KG:1.2180001505
**************************************************************************************************************
6;EG_H620/50R22-154G;12;ENS;1;E_AT_GREENTYRE;EC_NE03;10;ENS;1;12-03-2020 13:23:38;CRRNT QR5;EM_766;FM carcass PCR, Belt SM/Agriculture;77;1;10-08-2022 08:36:14;CRRNT QR5;;;|EG_H620/50R22-154G-766,EK_H620/50R22-154K|EK_H620/50R22-154K-903365,EB_18030E64E|EB_18030E64E-901341,ER_NE03-60-0110|ER_NE03-60-0110-771,ER_NE03-60-0770|ER_NE03-60-0770-771,EC_NE03|EC_NE03,EM_766;*(1/1)*(2/1)*(1.9/1)*(.143/1)*(.77/1)*(.869/1);.363605242
COMP-PART-GEWICHT: DBA_FNC_BEPAAL_HEADER_GEWICHT (COMP-PART: EC_NE03 COMP: EM_766) HEADER-KG:1.0000001732
**************************************************************************************************************
7;EG_H620/50R22-154G;12;ENS;1;E_AT_GREENTYRE;EM_766;77;ENS;1;10-08-2022 08:36:14;CRRNT QR5;EM_466;MB carcass PCR , Belt SM / Agriculture;45;1;16-08-2022 08:36:16;CRRNT QR5;;;|EG_H620/50R22-154G-766,EK_H620/50R22-154K|EK_H620/50R22-154K-903365,EB_18030E64E|EB_18030E64E-901341,ER_NE03-60-0110|ER_NE03-60-0110-771,ER_NE03-60-0770|ER_NE03-60-0770-771,EC_NE03|EC_NE03,EM_766|EM_766,EM_466;*(1/1)*(2/1)*(1.9/1)*(.143/1)*(.77/1)*(.869/1)*(1.109595/1.135871);.355193995178140827611586174838515993454
COMP-PART-GEWICHT: DBA_FNC_BEPAAL_HEADER_GEWICHT (COMP-PART: EM_766 COMP: EM_466) HEADER-KG:1.0000001773
**************************************************************************************************************
2;EG_H620/50R22-154G;12;ENS;1;E_AT_GREENTYRE;EK_H620/50R22-154K;30;ENS;1;24-02-2022 12:38:31;CRRNT QR5;EI_C1100;VOERING 728  2.00X1100;7;1;24-01-2014 07:47:27;CRRNT QR5;903304;Innerliner;|EG_H620/50R22-154G-766,EK_H620/50R22-154K|EK_H620/50R22-154K-903304,EI_C1100;*(1/1)*(1.969/1);1.969
COMP-PART-GEWICHT: DBA_FNC_BEPAAL_HEADER_GEWICHT (COMP-PART: EK_H620/50R22-154K COMP: EI_C1100) HEADER-KG:2.7080019927
**************************************************************************************************************
3;EG_H620/50R22-154G;12;ENS;1;E_AT_GREENTYRE;EI_C1100;7;ENS;1;24-01-2014 07:47:27;CRRNT QR5;EM_728;FM Innerliner agriculture;74;1;12-01-2023 11:20:42;CRRNT QR5;903349;Innerliner compound;|EG_H620/50R22-154G-766,EK_H620/50R22-154K|EK_H620/50R22-154K-903304,EI_C1100|EI_C1100-903349,EM_728;*(1/1)*(1.969/1)*(2.708/1);5.332052
COMP-PART-GEWICHT: DBA_FNC_BEPAAL_HEADER_GEWICHT (COMP-PART: EI_C1100 COMP: EM_728) HEADER-KG:1.0000007359
**************************************************************************************************************
4;EG_H620/50R22-154G;12;ENS;1;E_AT_GREENTYRE;EM_728;74;ENS;1;12-01-2023 11:20:42;CRRNT QR5;EM_428;MB Innerliner agriculture;39;1;16-08-2022 00:00:02;CRRNT QR5;;;|EG_H620/50R22-154G-766,EK_H620/50R22-154K|EK_H620/50R22-154K-903304,EI_C1100|EI_C1100-903349,EM_728|EM_728,EM_428;*(1/1)*(1.969/1)*(2.708/1)*(1.2010087/1.2230407);5.23599978386034087009532879813402775558
COMP-PART-GEWICHT: DBA_FNC_BEPAAL_HEADER_GEWICHT (COMP-PART: EM_728 COMP: EM_428) HEADER-KG:1
**************************************************************************************************************
2;EG_H620/50R22-154G;12;ENS;1;E_AT_GREENTYRE;EK_H620/50R22-154K;30;ENS;1;24-02-2022 12:38:31;CRRNT QR5;ER_HE01-105;SCHAAFSTROOK NYLON;1;1;03-11-2014 11:56:32;CRRNT QR5;903358;Chafer;|EG_H620/50R22-154G-766,EK_H620/50R22-154K|EK_H620/50R22-154K-903358,ER_HE01-105;*(1/1)*(3.959/1);3.959
COMP-PART-GEWICHT: DBA_FNC_BEPAAL_HEADER_GEWICHT (COMP-PART: EK_H620/50R22-154K COMP: ER_HE01-105) HEADER-KG:.1339485413
**************************************************************************************************************
3;EG_H620/50R22-154G;12;ENS;1;E_AT_GREENTYRE;ER_HE01-105;1;ENS;1;03-11-2014 11:56:32;CRRNT QR5;ER_HE01-45-0775;SCHAAFSTROOK MATERIAAL;2;1;29-08-2018 13:17:29;CRRNT QR5;771;Parent roll;|EG_H620/50R22-154G-766,EK_H620/50R22-154K|EK_H620/50R22-154K-903358,ER_HE01-105|ER_HE01-105-771,ER_HE01-45-0775;*(1/1)*(3.959/1)*(.1355/1);.5364445
COMP-PART-GEWICHT: DBA_FNC_BEPAAL_HEADER_GEWICHT (COMP-PART: ER_HE01-105 COMP: ER_HE01-45-0775) HEADER-KG:.9885501207
**************************************************************************************************************
4;EG_H620/50R22-154G;12;ENS;1;E_AT_GREENTYRE;ER_HE01-45-0775;2;ENS;1;29-08-2018 13:17:29;CRRNT QR5;EC_HE1P;REKNUMMER HE01 (IN PLASTIC);8;1;12-03-2020 13:23:31;CRRNT QR5;771;Parent roll;|EG_H620/50R22-154G-766,EK_H620/50R22-154K|EK_H620/50R22-154K-903358,ER_HE01-105|ER_HE01-105-771,ER_HE01-45-0775|ER_HE01-45-0775-771,EC_HE1P;*(1/1)*(3.959/1)*(.1355/1)*(.775/1);.4157444875
COMP-PART-GEWICHT: DBA_FNC_BEPAAL_HEADER_GEWICHT (COMP-PART: ER_HE01-45-0775 COMP: EC_HE1P) HEADER-KG:1.1620001557
**************************************************************************************************************
5;EG_H620/50R22-154G;12;ENS;1;E_AT_GREENTYRE;EC_HE1P;8;ENS;1;12-03-2020 13:23:31;CRRNT QR5;EM_766;FM carcass PCR, Belt SM/Agriculture;77;1;10-08-2022 08:36:14;CRRNT QR5;;;|EG_H620/50R22-154G-766,EK_H620/50R22-154K|EK_H620/50R22-154K-903358,ER_HE01-105|ER_HE01-105-771,ER_HE01-45-0775|ER_HE01-45-0775-771,EC_HE1P|EC_HE1P,EM_766;*(1/1)*(3.959/1)*(.1355/1)*(.775/1)*(.899/1);.3737542942625
COMP-PART-GEWICHT: DBA_FNC_BEPAAL_HEADER_GEWICHT (COMP-PART: EC_HE1P COMP: EM_766) HEADER-KG:1.0000001732
**************************************************************************************************************
6;EG_H620/50R22-154G;12;ENS;1;E_AT_GREENTYRE;EM_766;77;ENS;1;10-08-2022 08:36:14;CRRNT QR5;EM_466;MB carcass PCR , Belt SM / Agriculture;45;1;16-08-2022 08:36:16;CRRNT QR5;;;|EG_H620/50R22-154G-766,EK_H620/50R22-154K|EK_H620/50R22-154K-903358,ER_HE01-105|ER_HE01-105-771,ER_HE01-45-0775|ER_HE01-45-0775-771,EC_HE1P|EC_HE1P,EM_766|EM_766,EM_466;*(1/1)*(3.959/1)*(.1355/1)*(.775/1)*(.899/1)*(1.109595/1.135871);.365108270342493722878742392401954095139
COMP-PART-GEWICHT: DBA_FNC_BEPAAL_HEADER_GEWICHT (COMP-PART: EM_766 COMP: EM_466) HEADER-KG:1.0000001773
**************************************************************************************************************
2;EG_H620/50R22-154G;12;ENS;1;E_AT_GREENTYRE;EK_H620/50R22-154K;30;ENS;1;24-02-2022 12:38:31;CRRNT QR5;ER_SE06-85-1060;PLY WI/BL;1;1;07-02-2018 11:47:47;CRRNT QR5;764;Ply 3;|EG_H620/50R22-154G-766,EK_H620/50R22-154K|EK_H620/50R22-154K-764,ER_SE06-85-1060;*(1/1)*(1.987/1);1.987
COMP-PART-GEWICHT: DBA_FNC_BEPAAL_HEADER_GEWICHT (COMP-PART: EK_H620/50R22-154K COMP: ER_SE06-85-1060) HEADER-KG:1.6748010836
**************************************************************************************************************
3;EG_H620/50R22-154G;12;ENS;1;E_AT_GREENTYRE;ER_SE06-85-1060;1;ENS;1;07-02-2018 11:47:47;CRRNT QR5;EC_SE06;REKNUMMER SE-06 WIT/BLAUW;19;1;28-03-2023 15:56:18;CRRNT QR5;771;Parent roll;|EG_H620/50R22-154G-766,EK_H620/50R22-154K|EK_H620/50R22-154K-764,ER_SE06-85-1060|ER_SE06-85-1060-771,EC_SE06;*(1/1)*(1.987/1)*(1.06/1);2.10622
COMP-PART-GEWICHT: DBA_FNC_BEPAAL_HEADER_GEWICHT (COMP-PART: ER_SE06-85-1060 COMP: EC_SE06) HEADER-KG:1.5800010222
**************************************************************************************************************
4;EG_H620/50R22-154G;12;ENS;1;E_AT_GREENTYRE;EC_SE06;19;ENS;1;28-03-2023 15:56:18;CRRNT QR5;EM_761;FM Carcass agriculture;64;1;17-03-2023 08:19:13;CRRNT QR5;;;|EG_H620/50R22-154G-766,EK_H620/50R22-154K|EK_H620/50R22-154K-764,ER_SE06-85-1060|ER_SE06-85-1060-771,EC_SE06|EC_SE06,EM_761;*(1/1)*(1.987/1)*(1.06/1)*(1.138/1);2.39687836
COMP-PART-GEWICHT: DBA_FNC_BEPAAL_HEADER_GEWICHT (COMP-PART: EC_SE06 COMP: EM_761) HEADER-KG:1.0000008983
**************************************************************************************************************
5;EG_H620/50R22-154G;12;ENS;1;E_AT_GREENTYRE;EM_761;64;ENS;1;17-03-2023 08:19:13;CRRNT QR5;EM_461;MB Carcas Agriculture;33;1;01-06-2021 13:58:55;CRRNT QR5;;;|EG_H620/50R22-154G-766,EK_H620/50R22-154K|EK_H620/50R22-154K-764,ER_SE06-85-1060|ER_SE06-85-1060-771,EC_SE06|EC_SE06,EM_761|EM_761,EM_461;*(1/1)*(1.987/1)*(1.06/1)*(1.138/1)*(1.069185/1.113249);2.30200645977368944414052920775136559745
COMP-PART-GEWICHT: DBA_FNC_BEPAAL_HEADER_GEWICHT (COMP-PART: EM_761 COMP: EM_461) HEADER-KG:1
**************************************************************************************************************
2;EG_H620/50R22-154G;12;ENS;1;E_AT_GREENTYRE;EK_H620/50R22-154K;30;ENS;1;24-02-2022 12:38:31;CRRNT QR5;ER_SE06-85-1300;PLY WI/BL;6;1;19-02-2014 09:55:26;CRRNT QR5;903320;Ply 1;|EG_H620/50R22-154G-766,EK_H620/50R22-154K|EK_H620/50R22-154K-903320,ER_SE06-85-1300;*(1/1)*(1.975/1);1.975
COMP-PART-GEWICHT: DBA_FNC_BEPAAL_HEADER_GEWICHT (COMP-PART: EK_H620/50R22-154K COMP: ER_SE06-85-1300) HEADER-KG:2.0540013289
**************************************************************************************************************
3;EG_H620/50R22-154G;12;ENS;1;E_AT_GREENTYRE;ER_SE06-85-1300;6;ENS;1;19-02-2014 09:55:26;CRRNT QR5;EC_SE06;REKNUMMER SE-06 WIT/BLAUW;19;1;28-03-2023 15:56:18;CRRNT QR5;771;Parent roll;|EG_H620/50R22-154G-766,EK_H620/50R22-154K|EK_H620/50R22-154K-903320,ER_SE06-85-1300|ER_SE06-85-1300-771,EC_SE06;*(1/1)*(1.975/1)*(1.3/1);2.5675
COMP-PART-GEWICHT: DBA_FNC_BEPAAL_HEADER_GEWICHT (COMP-PART: ER_SE06-85-1300 COMP: EC_SE06) HEADER-KG:1.5800010222
**************************************************************************************************************
4;EG_H620/50R22-154G;12;ENS;1;E_AT_GREENTYRE;EC_SE06;19;ENS;1;28-03-2023 15:56:18;CRRNT QR5;EM_761;FM Carcass agriculture;64;1;17-03-2023 08:19:13;CRRNT QR5;;;|EG_H620/50R22-154G-766,EK_H620/50R22-154K|EK_H620/50R22-154K-903320,ER_SE06-85-1300|ER_SE06-85-1300-771,EC_SE06|EC_SE06,EM_761;*(1/1)*(1.975/1)*(1.3/1)*(1.138/1);2.921815
COMP-PART-GEWICHT: DBA_FNC_BEPAAL_HEADER_GEWICHT (COMP-PART: EC_SE06 COMP: EM_761) HEADER-KG:1.0000008983
**************************************************************************************************************
5;EG_H620/50R22-154G;12;ENS;1;E_AT_GREENTYRE;EM_761;64;ENS;1;17-03-2023 08:19:13;CRRNT QR5;EM_461;MB Carcas Agriculture;33;1;01-06-2021 13:58:55;CRRNT QR5;;;|EG_H620/50R22-154G-766,EK_H620/50R22-154K|EK_H620/50R22-154K-903320,ER_SE06-85-1300|ER_SE06-85-1300-771,EC_SE06|EC_SE06,EM_761|EM_761,EM_461;*(1/1)*(1.975/1)*(1.3/1)*(1.138/1)*(1.069185/1.113249);2.80616535094574529148465437651414912567
COMP-PART-GEWICHT: DBA_FNC_BEPAAL_HEADER_GEWICHT (COMP-PART: EM_761 COMP: EM_461) HEADER-KG:1
**************************************************************************************************************
2;EG_H620/50R22-154G;12;ENS;1;E_AT_GREENTYRE;EK_H620/50R22-154K;30;ENS;1;24-02-2022 12:38:31;CRRNT QR5;ER_SE06-85-1340;PLY WI/BL;7;1;19-02-2014 09:55:26;CRRNT QR5;903321;Ply 2;|EG_H620/50R22-154G-766,EK_H620/50R22-154K|EK_H620/50R22-154K-903321,ER_SE06-85-1340;*(1/1)*(1.981/1);1.981
COMP-PART-GEWICHT: DBA_FNC_BEPAAL_HEADER_GEWICHT (COMP-PART: EK_H620/50R22-154K COMP: ER_SE06-85-1340) HEADER-KG:2.1172013698
**************************************************************************************************************
3;EG_H620/50R22-154G;12;ENS;1;E_AT_GREENTYRE;ER_SE06-85-1340;7;ENS;1;19-02-2014 09:55:26;CRRNT QR5;EC_SE06;REKNUMMER SE-06 WIT/BLAUW;19;1;28-03-2023 15:56:18;CRRNT QR5;771;Parent roll;|EG_H620/50R22-154G-766,EK_H620/50R22-154K|EK_H620/50R22-154K-903321,ER_SE06-85-1340|ER_SE06-85-1340-771,EC_SE06;*(1/1)*(1.981/1)*(1.34/1);2.65454
COMP-PART-GEWICHT: DBA_FNC_BEPAAL_HEADER_GEWICHT (COMP-PART: ER_SE06-85-1340 COMP: EC_SE06) HEADER-KG:1.5800010222
**************************************************************************************************************
4;EG_H620/50R22-154G;12;ENS;1;E_AT_GREENTYRE;EC_SE06;19;ENS;1;28-03-2023 15:56:18;CRRNT QR5;EM_761;FM Carcass agriculture;64;1;17-03-2023 08:19:13;CRRNT QR5;;;|EG_H620/50R22-154G-766,EK_H620/50R22-154K|EK_H620/50R22-154K-903321,ER_SE06-85-1340|ER_SE06-85-1340-771,EC_SE06|EC_SE06,EM_761;*(1/1)*(1.981/1)*(1.34/1)*(1.138/1);3.02086652
COMP-PART-GEWICHT: DBA_FNC_BEPAAL_HEADER_GEWICHT (COMP-PART: EC_SE06 COMP: EM_761) HEADER-KG:1.0000008983
**************************************************************************************************************
5;EG_H620/50R22-154G;12;ENS;1;E_AT_GREENTYRE;EM_761;64;ENS;1;17-03-2023 08:19:13;CRRNT QR5;EM_461;MB Carcas Agriculture;33;1;01-06-2021 13:58:55;CRRNT QR5;;;|EG_H620/50R22-154G-766,EK_H620/50R22-154K|EK_H620/50R22-154K-903321,ER_SE06-85-1340|ER_SE06-85-1340-771,EC_SE06|EC_SE06,EM_761|EM_761,EM_461;*(1/1)*(1.981/1)*(1.34/1)*(1.138/1)*(1.069185/1.113249);2.90129626901636561092801340939897543137
COMP-PART-GEWICHT: DBA_FNC_BEPAAL_HEADER_GEWICHT (COMP-PART: EM_761 COMP: EM_461) HEADER-KG:1
**************************************************************************************************************
2;EG_H620/50R22-154G;12;ENS;1;E_AT_GREENTYRE;EK_H620/50R22-154K;30;ENS;1;24-02-2022 12:38:31;CRRNT QR5;ES_H620/50R22-154A;ZIJKANT  B=310 P=40 L=2040 G=9,23;8;1;12-11-2021 09:51:26;CRRNT QR5;903394;Sidewall L/R;|EG_H620/50R22-154G-766,EK_H620/50R22-154K|EK_H620/50R22-154K-903394,ES_H620/50R22-154A;*(1/1)*(2/1);2
COMP-PART-GEWICHT: DBA_FNC_BEPAAL_HEADER_GEWICHT (COMP-PART: EK_H620/50R22-154K COMP: ES_H620/50R22-154A) HEADER-KG:9.2300033088
**************************************************************************************************************
3;EG_H620/50R22-154G;12;ENS;1;E_AT_GREENTYRE;ES_H620/50R22-154A;8;ENS;1;12-11-2021 09:51:26;CRRNT QR5;EM_723;FM Sidewall Agriculture;91;1;30-12-2022 09:24:16;CRRNT QR5;903346;Sidewall compound;|EG_H620/50R22-154G-766,EK_H620/50R22-154K|EK_H620/50R22-154K-903394,ES_H620/50R22-154A|ES_H620/50R22-154A-903346,EM_723;*(1/1)*(2/1)*(9.23/1);18.46
COMP-PART-GEWICHT: DBA_FNC_BEPAAL_HEADER_GEWICHT (COMP-PART: ES_H620/50R22-154A COMP: EM_723) HEADER-KG:1.0000003585
**************************************************************************************************************
4;EG_H620/50R22-154G;12;ENS;1;E_AT_GREENTYRE;EM_723;91;ENS;1;30-12-2022 09:24:16;CRRNT QR5;EM_423;MB Sidewall Agriculture;34;1;16-08-2022 00:00:02;CRRNT QR5;;;|EG_H620/50R22-154G-766,EK_H620/50R22-154K|EK_H620/50R22-154K-903394,ES_H620/50R22-154A|ES_H620/50R22-154A-903346,EM_723|EM_723,EM_423;*(1/1)*(2/1)*(9.23/1)*(1.1079791/1.127504);18.1403296006045211369538378577814358087
COMP-PART-GEWICHT: DBA_FNC_BEPAAL_HEADER_GEWICHT (COMP-PART: EM_723 COMP: EM_423) HEADER-KG:.999999733
**************************************************************************************************************
2;EG_H620/50R22-154G;12;ENS;1;E_AT_GREENTYRE;EK_H620/50R22-154K;30;ENS;1;24-02-2022 12:38:31;CRRNT QR5;ES_RC16-90H;VELGRUBBER  742;15;1;31-03-2023 08:50:56;CRRNT QR5;900921;Rim cushion;|EG_H620/50R22-154G-766,EK_H620/50R22-154K|EK_H620/50R22-154K-900921,ES_RC16-90H;*(1/1)*(3.66/1);3.66
COMP-PART-GEWICHT: DBA_FNC_BEPAAL_HEADER_GEWICHT (COMP-PART: EK_H620/50R22-154K COMP: ES_RC16-90H) HEADER-KG:.3300001334
**************************************************************************************************************
3;EG_H620/50R22-154G;12;ENS;1;E_AT_GREENTYRE;ES_RC16-90H;15;ENS;1;31-03-2023 08:50:56;CRRNT QR5;EM_742;FM rimcushion;88;1;10-08-2022 08:35:49;CRRNT QR5;903347;Rim cushion compound;|EG_H620/50R22-154G-766,EK_H620/50R22-154K|EK_H620/50R22-154K-900921,ES_RC16-90H|ES_RC16-90H-903347,EM_742;*(1/1)*(3.66/1)*(.33/1);1.2078
COMP-PART-GEWICHT: DBA_FNC_BEPAAL_HEADER_GEWICHT (COMP-PART: ES_RC16-90H COMP: EM_742) HEADER-KG:1.0000004043
**************************************************************************************************************
4;EG_H620/50R22-154G;12;ENS;1;E_AT_GREENTYRE;EM_742;88;ENS;1;10-08-2022 08:35:49;CRRNT QR5;EM_542;Remill Rimcushion;22;1;23-06-2021 13:56:03;CRRNT QR5;;;|EG_H620/50R22-154G-766,EK_H620/50R22-154K|EK_H620/50R22-154K-900921,ES_RC16-90H|ES_RC16-90H-903347,EM_742|EM_742,EM_542;*(1/1)*(3.66/1)*(.33/1)*(1.1355198/1.1655325);1.1766989032395064058702781775711959984
COMP-PART-GEWICHT: DBA_FNC_BEPAAL_HEADER_GEWICHT (COMP-PART: EM_742 COMP: EM_542) HEADER-KG:1.0000012076
**************************************************************************************************************
5;EG_H620/50R22-154G;12;ENS;1;E_AT_GREENTYRE;EM_542;22;ENS;1;23-06-2021 13:56:03;CRRNT QR5;EM_442;MB Rimcushion;29;1;12-05-2022 09:02:43;CRRNT QR5;;;|EG_H620/50R22-154G-766,EK_H620/50R22-154K|EK_H620/50R22-154K-900921,ES_RC16-90H|ES_RC16-90H-903347,EM_742|EM_742,EM_542|EM_542,EM_442;*(1/1)*(3.66/1)*(.33/1)*(1.1355198/1.1655325)*(1.1593099/1.1593092);1.17669961373954579799662730789356754504
COMP-PART-GEWICHT: DBA_FNC_BEPAAL_HEADER_GEWICHT (COMP-PART: EM_542 COMP: EM_442) HEADER-KG:1.0000006038
**************************************************************************************************************
1;EG_H620/50R22-154G;12;ENS;1;E_AT_GREENTYRE;EG_H620/50R22-154G;12;ENS;1;12-01-2022 00:00:05;CRRNT QR5;EM_716;FM Tread agri;78;1;28-03-2023 06:55:55;CRRNT QR4;903348;Tread compound;|EG_H620/50R22-154G-903348,EM_716;*(42.46/1);42.46
MAINPART-HEADER-TYRE: DBA_FNC_BEPAAL_HEADER_GEWICHT(PARTNO=MAINPART:EG_H620/50R22-154G SAP-code: ) HEADER-KG:94.2281294224
COMP-PART-GEWICHT: DBA_FNC_BEPAAL_HEADER_GEWICHT (COMP-PART: EG_H620/50R22-154G COMP: EM_716) HEADER-KG:.9999989575
**************************************************************************************************************
2;EG_H620/50R22-154G;12;ENS;1;E_AT_GREENTYRE;EM_716;77;ENS;1;28-03-2023 06:55:55;CRRNT QR4;EM_416;MB tread agri;58;1;24-03-2023 09:36:50;CRRNT QR4;;;|EG_H620/50R22-154G-903348,EM_716|EM_716,EM_416;*(42.46/1)*(1.1239682/1.1445607);41.6960758586241865547192036210923544728
COMP-PART-GEWICHT: DBA_FNC_BEPAAL_HEADER_GEWICHT (COMP-PART: EM_716 COMP: EM_416) HEADER-KG:.9999995612
**************************************************************************************************************
1;EG_H620/50R22-154G;12;ENS;1;E_AT_GREENTYRE;EG_H620/50R22-154G;12;ENS;1;12-01-2022 00:00:05;CRRNT QR5;ER_FE07-30-0570A;GORDEL RO/RO A-gordel;2;1;06-01-2022 07:42:35;CRRNT QR5;770;Belt;|EG_H620/50R22-154G-770,ER_FE07-30-0570A;*(6.387/1);6.387
MAINPART-HEADER-TYRE: DBA_FNC_BEPAAL_HEADER_GEWICHT(PARTNO=MAINPART:EG_H620/50R22-154G SAP-code: ) HEADER-KG:94.2281294224
COMP-PART-GEWICHT: DBA_FNC_BEPAAL_HEADER_GEWICHT (COMP-PART: EG_H620/50R22-154G COMP: ER_FE07-30-0570A) HEADER-KG:.8025597606
**************************************************************************************************************
2;EG_H620/50R22-154G;12;ENS;1;E_AT_GREENTYRE;ER_FE07-30-0570A;2;ENS;1;06-01-2022 07:42:35;CRRNT QR5;EC_FE07;REKNUMMER FE07 ROOD/ROOD;5;1;03-07-2020 10:00:31;CRRNT QR5;771;Parent roll;|EG_H620/50R22-154G-770,ER_FE07-30-0570A|ER_FE07-30-0570A-771,EC_FE07;*(6.387/1)*(.57/1);3.64059
COMP-PART-GEWICHT: DBA_FNC_BEPAAL_HEADER_GEWICHT (COMP-PART: ER_FE07-30-0570A COMP: EC_FE07) HEADER-KG:1.4079995799
**************************************************************************************************************
3;EG_H620/50R22-154G;12;ENS;1;E_AT_GREENTYRE;EC_FE07;5;ENS;1;03-07-2020 10:00:31;CRRNT QR5;EM_763;FM Agri Belt compound;46;1;18-10-2022 06:19:27;CRRNT QR5;;;|EG_H620/50R22-154G-770,ER_FE07-30-0570A|ER_FE07-30-0570A-771,EC_FE07|EC_FE07,EM_763;*(6.387/1)*(.57/1)*(.982/1);3.57505938
COMP-PART-GEWICHT: DBA_FNC_BEPAAL_HEADER_GEWICHT (COMP-PART: EC_FE07 COMP: EM_763) HEADER-KG:.9999995722
**************************************************************************************************************
4;EG_H620/50R22-154G;12;ENS;1;E_AT_GREENTYRE;EM_763;46;ENS;1;18-10-2022 06:19:27;CRRNT QR5;EM_463;MB Agri Belt compound;29;1;04-05-2022 15:15:28;CRRNT QR4;;;|EG_H620/50R22-154G-770,ER_FE07-30-0570A|ER_FE07-30-0570A-771,EC_FE07|EC_FE07,EM_763|EM_763,EM_463;*(6.387/1)*(.57/1)*(.982/1)*(1.116584/1.149221);3.47353041996093005609887045224547758873
COMP-PART-GEWICHT: DBA_FNC_BEPAAL_HEADER_GEWICHT (COMP-PART: EM_763 COMP: EM_463) HEADER-KG:.9999995597
**************************************************************************************************************

1;EG_H620/50R22-154G;12;ENS;1;E_AT_GREENTYRE;EG_H620/50R22-154G;12;ENS;1;12-01-2022 00:00:05;CRRNT QR5;ER_FE07-30-0570B;GORDEL RO/RO B-gordel;2;1;06-01-2022 07:42:35;CRRNT QR5;770;Belt;|EG_H620/50R22-154G-770,ER_FE07-30-0570B;*(6.387/1);6.387
MAINPART-HEADER-TYRE: DBA_FNC_BEPAAL_HEADER_GEWICHT(PARTNO=MAINPART:EG_H620/50R22-154G SAP-code: ) HEADER-KG:94.2281294224
COMP-PART-GEWICHT: DBA_FNC_BEPAAL_HEADER_GEWICHT (COMP-PART: EG_H620/50R22-154G COMP: ER_FE07-30-0570B) HEADER-KG:.8025597606
**************************************************************************************************************
2;EG_H620/50R22-154G;12;ENS;1;E_AT_GREENTYRE;ER_FE07-30-0570B;2;ENS;1;06-01-2022 07:42:35;CRRNT QR5;EC_FE07;REKNUMMER FE07 ROOD/ROOD;5;1;03-07-2020 10:00:31;CRRNT QR5;771;Parent roll;|EG_H620/50R22-154G-770,ER_FE07-30-0570B|ER_FE07-30-0570B-771,EC_FE07;*(6.387/1)*(.57/1);3.64059
COMP-PART-GEWICHT: DBA_FNC_BEPAAL_HEADER_GEWICHT (COMP-PART: ER_FE07-30-0570B COMP: EC_FE07) HEADER-KG:1.4079995799
**************************************************************************************************************
3;EG_H620/50R22-154G;12;ENS;1;E_AT_GREENTYRE;EC_FE07;5;ENS;1;03-07-2020 10:00:31;CRRNT QR5;EM_763;FM Agri Belt compound;46;1;18-10-2022 06:19:27;CRRNT QR5;;;|EG_H620/50R22-154G-770,ER_FE07-30-0570B|ER_FE07-30-0570B-771,EC_FE07|EC_FE07,EM_763;*(6.387/1)*(.57/1)*(.982/1);3.57505938
COMP-PART-GEWICHT: DBA_FNC_BEPAAL_HEADER_GEWICHT (COMP-PART: EC_FE07 COMP: EM_763) HEADER-KG:.9999995722
**************************************************************************************************************
4;EG_H620/50R22-154G;12;ENS;1;E_AT_GREENTYRE;EM_763;46;ENS;1;18-10-2022 06:19:27;CRRNT QR5;EM_463;MB Agri Belt compound;29;1;04-05-2022 15:15:28;CRRNT QR4;;;|EG_H620/50R22-154G-770,ER_FE07-30-0570B|ER_FE07-30-0570B-771,EC_FE07|EC_FE07,EM_763|EM_763,EM_463;*(6.387/1)*(.57/1)*(.982/1)*(1.116584/1.149221);3.47353041996093005609887045224547758873
COMP-PART-GEWICHT: DBA_FNC_BEPAAL_HEADER_GEWICHT (COMP-PART: EM_763 COMP: EM_463) HEADER-KG:.9999995597
COMP-PART-GEWICHT EINDE BEREKEN TOTAALGEWICHT VAN HEADER: EG_H620/50R22-154G REVISION: 12 WEIGHT: 94.2281294224 COMP-PART-WEIGHT: .9999995597
**************************************************************************************************************
Process exited.
Disconnecting from the database oracleprod-db-IS61-Interspc.

*/



--ONDERZOEK: kijken of nieuwe proc gelijk gewichten berekend als de oude...

--reeds berekende gewichten met oude procedure haal ik uit stuurtabel DBA_WEIGHT_COMPONENT_PART:

select mainpart, mainrevision, mainalternative, comp_part_eenheid_kg
from dba_weight_component_part 
where component_part_no is null;


dba_weight_component_part                           NIEUW-FNC-MV-BEPAAL_HEADER_WEIGHT
EF_H165/80R15CLS	11	1	8.0545188175			13   1 	8.0533982656
EF_H165/80R14CLS	13	1	7.634625441				15   1 	7.6335613678
EF_H165/80R15CLSM	8	1	8.0545188175
EF_H175/70R15CLS	9	1	7.9971140406
EF_H175/80R14CLS	15	1	8.2091667135

select mainpart, mainrevision, mainalternative, comp_part_eenheid_kg
from dba_weight_component_part w
where w.component_part_no is null
and   w.mainrevision = (select max(d.mainrevision) from dba_weight_component_part d where d.mainpart = w.mainpart)
;
													 NIEUW-FNC-MV-BEPAAL_HEADER_WEIGHT
EF_195/80-17-SM		24	1	9.482130067 				24		9.4820629571    (met oude procedure: 9.4820629571 !!!)
EF_195/80-17-SM		24	1	9.482130067
EF_195/80-17-SM		24	1	9.482130067
EF_540/65R28TRO154	4	1	136.9042665839				4		136.9042665839   
EF_540/65R30TRO158	7	1	147.77402018
EF_540/65R30TRO158	7	1	147.7739716195

--resultaten lijken allemaal OK !!!!!!!



--ONDERZOEK DBA_BEPAAL_COMP_PART_GEWICHT !!!!!!!
--DEZE HAALT ALLEEN BOM-STRUCTUUR OP VAN PART !!!

				SELECT bi2.LVL
				,      bi2.level_tree
				,      rownum
				,      bi2.mainpart
				,      bi2.mainrevision
				,      bi2.mainplant
				,      bi2.mainalternative
				,      bi2.mainframeid
				,      bi2.part_no
				,      bi2.revision
				,      bi2.plant
				,      bi2.alternative
				,      bi2.headerissueddate
				,      bi2.headerstatus
				,      bi2.item_number
				,      bi2.component_part
				,      bi2.componentdescription
				,      bi2.componentrevision
				,      bi2.componentalternative
				,      bi2.componentissueddate
				,      bi2.componentstatus
				,      bi2.characteristic_id 
				,      bi2.functiecode
				,      bi2.path
				,      bi2.quantity_path
				,      DBA_BEPAAL_QUANTITY_KG(bi2.quantity_path)  bom_quantity_kg
				from
				(
				with sel_bom_header as 
				(select bh.part_no
				 ,      bh.revision
				 ,      bh.plant
				 ,      bh.alternative
				 ,      sh.frame_id
				 from status               s  
				 ,    specification_header sh
				 ,    bom_header           bh 
				 where  bh.part_no    = pl_header_part_no  --'EF_Q165/80R15SCS'  --'EM_764' --'EG_H620/50R22-154G'  --pl_header_part_no
				and    bh.revision   = pl_header_revision  --(select max(sh1.revision) from status s1, specification_header sh1 where sh1.part_no = bh.part_no and sh1.status = s1.status and s1.status_type in ('CURRENT','HISTORIC'))
				 and    bh.part_no    = sh.part_no
				and    bh.revision   = sh.revision
				and    sh.status     = s.status		
				--Er komt maar 1x CRRNT voor, de rest is HISTORIC/DEV, en dus is altijd max(revision)		  
				 --and    s.status_type in ('CURRENT','HISTORIC')
				 --welk alternative we moeten gebruiken is afhankelijk van PREFERRED-ind.
				and    bh.preferred  = 1
				 --and    rownum = 1
				) 
				select LEVEL   LVL
				,      RPAD('.', (level-1)*2, '.') || LEVEL AS level_tree
				,      h.part_no             mainpart
				,      h.revision            mainrevision
				,      h.plant               mainplant
				,      h.alternative         mainalternative
				,      h.frame_id            mainframeid
				,      b.part_no
				,      b.revision
				,      b.plant
				,      b.alternative
				,      b.headerissueddate
				,      b.headerstatus
				,      b.item_number        --PS new 20221115
				,      b.component_part
				,      (select pi.description from part pi where pi.part_no = b.component_part)           componentdescription
				,      (select max(bi2.revision) from bom_item bi2 where bi2.part_no = b.component_part)  componentrevision
				--,      b.alternative                                                                      componentalternative
				,      (select DISTINCT bi3.alternative from bom_item bi3 
						where bi3.part_no = b.component_part 
				        and   bi3.revision = (select max(bi4.revision) from bom_item bi4 
											where bi4.part_no = bi3.part_no) 
											and   bi3.alternative = (select bh.alternative from bom_header bh 
																	where bh.part_no = bi3.part_no 
																	and bh.preferred=1 
																	and bh.revision = (select max(bh2.revision) from bom_header bh2 where bh2.part_no = bh.part_no
																						) 
																	)
											  )   componentalternative 
				,      (select to_char(sh2.issued_date,'dd-mm-yyyy hh24:mi:ss') 
				        from   specification_header sh2
     					where  sh2.part_no     = b.component_part 
						and    sh2.revision = (select max(sh1.revision)  
												from status s1, specification_header sh1
     						                    where   sh1.part_no   = sh2.part_no      --is component-part-no   
												and     sh1.status   = s1.status 
												and     s1.status_type in ('CURRENT','HISTORIC')
												)
                       )	                                                                               componentissueddate
				,      (select s3.sort_desc
				        from   status s3, specification_header sh3
   						where  sh3.part_no     = b.component_part 
						and    sh3.revision = (select max(sh1.revision)  
                                       from status s1, specification_header sh1
		   		                       where   sh1.part_no   = sh3.part_no        --is component-part-no
                                       and     sh1.status   = s1.status 
                                       and     s1.status_type in ('CURRENT','HISTORIC')
                                       )
                and    s3.status  = sh3.status 
                )	                                                                               componentstatus
				,      b.item_header_base_quantity
				,      b.quantity
				,      b.uom
				,      b.quantity_kg
				,      b.characteristic_id       --FUNCTIECODE
				,      b.functiecode             --functiecode-descr
				,      sys_connect_by_path( b.part_no||decode(b.characteristic_id,null,'','-'||b.characteristic_id) || ',' || b.component_part ,'|')  path
				,      sys_connect_by_path( '('||b.quantity_kg||'/'||b.item_header_base_quantity||')', '*')  quantity_path
				FROM ( SELECT bi.part_no
				     ,      bi.revision
    				 ,      bi.plant
		    		 ,      bi.alternative
				     ,      TO_CHAR(sh.issued_date,'dd-mm-yyyy hh24:mi:ss')  headerissueddate
    				 ,      s.sort_desc                                      headerstatus
                       ,      bi.item_number      --PS new 20221115
		    		 ,      bi.component_part
				     ,      bh.base_quantity   item_header_base_quantity
						 ,      bi.quantity
						 ,      bi.uom 
						 ,      case when bi.uom = 'g' then (bi.quantity/1000) else bi.quantity end  quantity_kg   --hier moeten we de overige UOMs zoals pcs/m nog wel meenemen anders wordt later de factor in quantity-path=0
				     ,      bi.ch_1         characteristic_id       --FUNCTIECODE
				     ,      c.description   functiecode             --functiecode-descr
  				   FROM status               s
						 ,    specification_header sh
						 ,    bom_header           bh
		         ,    characteristic       c
  	              ,    bom_item             bi	 
						 WHERE bh.part_no      = bi.part_no
						 and   bh.revision     = bi.revision
						 and   bh.preferred    = 1
						 and   bh.alternative  = bi.alternative
                         --zoek hoogste specification-revision waar nog een bom-header bij voorkomt
						 and  bi.revision = (select max(sh1.revision) 
						                     from status s1, specification_header sh1, bom_header h2 
        	 											 where h2.part_no  = bi.part_no 
        												 and  sh1.part_no  = h2.part_no 
        												 AND  sh1.revision = h2.revision 
        												 and  sh1.status   = s1.status 
        												 and   s1.status_type in ('CURRENT','HISTORIC'))
						 and   bi.part_no     = sh.part_no
                         and   bi.revision    = sh.revision
						 and   sh.status      = s.status	
						 --and   s.status_type  in ('CURRENT','HISTORIC')
  	                      and   bi.ch_1        = c.characteristic_id(+)
					   ) b
				,      sel_bom_header h	   
				START WITH b.part_no = h.part_no 
				CONNECT BY NOCYCLE PRIOR b.component_part = b.part_no --and b.component_revision = b.revision
				order siblings by b.part_no
				)  bi2
        where bi2.component_part IN (select bi3.part_no from bom_item bi3 where bi3.part_no = bi2.component_part)   --NU itt DBA_BEPAAL_BOM_HEADER_GEWICHT: NIET de selectie voor material-codes, DIE gaan we niet de gewichten berekenen...
		 	;
			
--oplossing DBA_BEPAAL_COMP_PART_GEWICHT OBV MV !!!!

				SELECT bi2.LVL
				,      bi2.level_tree
				,      rownum
				,      bi2.mainpart
				,      bi2.mainrevision
				,      bi2.mainplant
				,      bi2.mainalternative
				,      bi2.mainframeid
				,      bi2.part_no
				,      bi2.revision
				,      bi2.plant
				,      bi2.alternative
				,      bi2.headerissueddate
				,      bi2.headerstatus
				,      bi2.item_number
				,      bi2.component_part
				,      bi2.componentdescription
				,      bi2.componentrevision
				,      bi2.componentalternative
				,      bi2.componentissueddate
				,      bi2.componentstatus
				,      bi2.characteristic_id 
				,      bi2.functiecode
				,      bi2.path
				,      bi2.quantity_path
				,      DBA_BEPAAL_QUANTITY_KG(bi2.quantity_path)  bom_quantity_kg
				from
				(
				with sel_bom_header as 
				(select DISTINCT bih.part_no
		         ,      bih.revision
			     ,      bih.plant
			     ,      bih.alternative
			     ,      bih.preferred
			     ,      bih.base_quantity
			     ,      bih.status     			--pas later de sort-desc erbijhalen...
			     ,      bih.frame_id
                 from  mv_bom_item_comp_header bih
                 where  bih.part_no     = 'EG_H620/50R22-154G' --pl_header_part_no  --'EM_764' --'EG_H620/50R22-154G'  --l_header_part_no
			     --and    bih.revision    = pl_header_revision --(select max(sh1.revision) from status s1, specification_header sh1 where sh1.part_no = bh.part_no and sh1.status = s1.status and s1.status_type in ('CURRENT','HISTORIC'))
			     and    bih.alternative = 1 --pl_header_alternative  --default alternative bij preferred=1, maar kan ook expliciet preferred=0
			     AND    bih.preferred   = 1
				) 
				select LEVEL   LVL
				,      RPAD('.', (level-1)*2, '.') || LEVEL AS level_tree
				,      h.part_no             mainpart
				,      h.revision            mainrevision
				,      h.plant               mainplant
				,      h.alternative         mainalternative
				,      h.frame_id            mainframeid
				,      b.part_no
				,      b.revision
				,      b.plant
				,      b.alternative
				,      b.headerissueddate
				,      b.headerstatus
				,      b.item_number        --PS new 20221115
				,      b.component_part
				,      (select pi.description from part pi where pi.part_no = b.component_part)           componentdescription
				,      (select max(bi2.revision) from bom_item bi2 where bi2.part_no = b.component_part)  componentrevision
				--,      b.alternative                                                                      componentalternative
				,      (select DISTINCT bi3.alternative from bom_item bi3 
						where bi3.part_no = b.component_part 
				        and   bi3.revision = (select max(bi4.revision) from bom_item bi4 
											where bi4.part_no = bi3.part_no) 
											and   bi3.alternative = (select bh.alternative from bom_header bh 
																	where bh.part_no = bi3.part_no 
																	and bh.preferred=1 
																	and bh.revision = (select max(bh2.revision) from bom_header bh2 where bh2.part_no = bh.part_no
																						) 
																	)
											  )   componentalternative 
				,      (select to_char(sh2.issued_date,'dd-mm-yyyy hh24:mi:ss') 
				        from   specification_header sh2
     					where  sh2.part_no     = b.component_part 
						and    sh2.revision = (select max(sh1.revision)  
												from status s1, specification_header sh1
     						                    where   sh1.part_no   = sh2.part_no      --is component-part-no   
												and     sh1.status   = s1.status 
												and     s1.status_type in ('CURRENT','HISTORIC')
												)
                       )	                                                                               componentissueddate
				,      (select s3.sort_desc
				        from   status s3, specification_header sh3
   						where  sh3.part_no     = b.component_part 
						and    sh3.revision = (select max(sh1.revision)  
                                               from status s1, specification_header sh1
		   		                               where   sh1.part_no   = sh3.part_no        --is component-part-no
                                               and     sh1.status   = s1.status 
                                               and     s1.status_type in ('CURRENT','HISTORIC')
                                              )
                         and    s3.status  = sh3.status 
                         )	                                                                               componentstatus
				,      b.item_header_base_quantity
				,      b.quantity
				,      b.uom
				,      b.quantity_kg
				,      b.characteristic_id       --FUNCTIECODE
				,      b.functiecode             --functiecode-descr
				,      sys_connect_by_path( b.part_no||decode(b.characteristic_id,null,'','-'||b.characteristic_id) || ',' || b.component_part ,'|')  path
				,      sys_connect_by_path( '('||b.quantity_kg||'/'||b.item_header_base_quantity||')', '*')  quantity_path
				FROM ( SELECT bi.part_no
				     ,      bi.revision
    				 ,      bi.plant
		    		 ,      bi.alternative
				     ,      TO_CHAR(sh.issued_date,'dd-mm-yyyy hh24:mi:ss')  headerissueddate
    				 ,      s.sort_desc                                      headerstatus
                     ,      bi.item_number      --PS new 20221115
		    		 ,      bi.component_part
				     ,      bh.base_quantity   item_header_base_quantity
					 ,      bi.quantity
					 ,      bi.uom 
					 ,      case when bi.uom = 'g' then (bi.quantity/1000) else bi.quantity end  quantity_kg   --hier moeten we de overige UOMs zoals pcs/m nog wel meenemen anders wordt later de factor in quantity-path=0
				     ,      bi.ch_1         characteristic_id       --FUNCTIECODE
				     ,      c.description   functiecode             --functiecode-descr
  				     FROM status               s
					 ,    specification_header sh
					 ,    bom_header           bh
		             ,    characteristic       c
  	                 ,    bom_item             bi	 
						 WHERE bh.part_no      = bi.part_no
						 and   bh.revision     = bi.revision
						 and   bh.preferred    = 1
						 and   bh.alternative  = bi.alternative
                         --zoek hoogste specification-revision waar nog een bom-header bij voorkomt
						 and  bi.revision = (select max(sh1.revision) 
						                     from status s1, specification_header sh1, bom_header h2 
        	 											 where h2.part_no  = bi.part_no 
        												 and  sh1.part_no  = h2.part_no 
        												 AND  sh1.revision = h2.revision 
        												 and  sh1.status   = s1.status 
        												 and   s1.status_type in ('CURRENT','HISTORIC'))
						 and   bi.part_no     = sh.part_no
                         and   bi.revision    = sh.revision
						 and   sh.status      = s.status	
						 --and   s.status_type  in ('CURRENT','HISTORIC')
  	                      and   bi.ch_1        = c.characteristic_id(+)
					   ) b
				,      sel_bom_header h	   
				START WITH b.part_no = h.part_no 
				CONNECT BY NOCYCLE PRIOR b.component_part = b.part_no --and b.component_revision = b.revision
				order siblings by b.part_no
				)  bi2
        where bi2.component_part IN (select bi3.part_no from bom_item bi3 where bi3.part_no = bi2.component_part)   --NU itt DBA_BEPAAL_BOM_HEADER_GEWICHT: NIET de selectie voor material-codes, DIE gaan we niet de gewichten berekenen...
		 	;			


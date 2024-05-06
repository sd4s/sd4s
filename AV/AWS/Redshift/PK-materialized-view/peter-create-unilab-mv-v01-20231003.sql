--create materialized-view
--TABLES without A PK needs to be replaced by a MV incl. PK !!!!
/*
410	UNILAB	ATAOACTIONS		23-10-2021 10:43:25	71	
411	UNILAB	ATAOCONDITIONS	23-10-2021 10:43:25	100	
237	UNILAB	ATICTRHS		23-10-2021 09:34:35	0	
238	UNILAB	ATMETRHS		23-10-2021 09:35:04	11727424	
239	UNILAB	ATPATRHS		23-10-2021 09:37:30	66565994	
240	UNILAB	ATRQTRHS		23-10-2021 09:37:46	6222915	
241	UNILAB	ATSCTRHS		23-10-2021 09:38:02	7553086	
281	UNILAB	UTLCHS			23-10-2021 09:55:04	3011	
285	UNILAB	UTMTHS			23-10-2021 09:55:06	120861	
291	UNILAB	UTPRHS			23-10-2021 09:56:14	217244	
309	UNILAB	UTRQHS			23-10-2021 09:56:29	10383407	
338	UNILAB	UTSCHS			23-10-2021 10:05:22	137199564	
250	UNILAB	UTSCMEHS		23-10-2021 09:48:44	160134513	
409	UNILAB	UTSCMEHSDETAILS	23-10-2021 10:43:25	338980250	
359	UNILAB	UTSCPAHS		23-10-2021 10:18:33	169218999	
369	UNILAB	UTSTHS			23-10-2021 10:19:44	1672140	
404	UNILAB	UTWSHS			23-10-2021 10:19:48	1127761	
405	UNILAB	UTWSII			23-10-2021 10:19:48	48568	
406	UNILAB	UTWSME			23-10-2021 10:19:48	9773	
*/

select * from DBA_AWS_SUPPLEMENTAL_LOG WHERE ASL_TABLE_NAME NOT in (SELECT con.TABLE_NAME FROM ALL_CONSTRAINTS con WHERE OWNER='UNILAB' AND  CONSTRAINT_TYPE='P') order by asl_table_name;
--UPDATE DBA_AWS_SUPPLEMENTAL_LOG SET ASL_PK_EXISTS_JN = 'N' WHERE ASL_TABLE_NAME NOT in (SELECT con.TABLE_NAME FROM ALL_CONSTRAINTS con WHERE OWNER='INTERSPC' AND  CONSTRAINT_TYPE='P') AND ASL_PK_EXISTS_JN IS NULL;
225	UNILAB	ATAOACTIONS		N	ALL	J	23-10-2021 09:25:27	
226	UNILAB	ATAOCONDITIONS	N	ALL	J	23-10-2021 09:25:27	
3	UNILAB	ATICTRHS		N	ALL	J	23-10-2021 09:25:27	
4	UNILAB	ATMETRHS		N	ALL	J	23-10-2021 09:25:27	
5	UNILAB	ATPATRHS		N	ALL	J	23-10-2021 09:25:27	
6	UNILAB	ATRQTRHS		N	ALL	J	23-10-2021 09:25:27	
7	UNILAB	ATSCTRHS		N	ALL	J	23-10-2021 09:25:27	
55	UNILAB	UTLCHS			N	ALL	J	23-10-2021 09:25:27	
63	UNILAB	UTMTHS			N	ALL	J	23-10-2021 09:25:27	
70	UNILAB	UTPRHS			N	ALL	J	23-10-2021 09:25:27	
88	UNILAB	UTRQHS			N	ALL	J	23-10-2021 09:25:27	
120	UNILAB	UTSCHS			N	ALL	J	23-10-2021 09:25:27	
17	UNILAB	UTSCMEHS		N	ALL	J	23-10-2021 09:25:27	
206	UNILAB	UTSCMEHSDETAILS	N	ALL	J	23-10-2021 09:25:27	
146	UNILAB	UTSCPAHS		N	ALL	J	23-10-2021 09:25:27	
158	UNILAB	UTSTHS			N	ALL	J	23-10-2021 09:25:27	
193	UNILAB	UTWSHS			N	ALL	J	23-10-2021 09:25:27	
194	UNILAB	UTWSII			N	ALL	J	23-10-2021 09:25:27	
195	UNILAB	UTWSME			N	ALL	J	23-10-2021 09:25:27	

--INSERT RECORD DBA_AWS_SUPPLEMENTAL_LOG
/*
ASL_ID
ASL_SCHEMA_OWNER
ASL_TABLE_NAME
ASL_PK_EXISTS_JN
ASL_SUPPL_LOG_TYPE
ASL_IND_ACTIVE_JN
ASL_ACTIVATION_DATE
ASL_OPMERKING
*/

/*
--we create a PK without a MATERIALIZED-VIEW, BUT do ENABLE SUPPLEMENTAL-LOGGING for BASE-TABLE, THERE IS ALREADY A ROW IN DBA_AWS_SUPPLEMENTAL-LOG:
--INSERT INTO DBA_AWS_SUPPLEMENTAL_LOG (ASL_ID, ASL_SCHEMA_OWNER, ASL_TABLE_NAME, ASL_PK_EXISTS_JN, ASL_SUPPL_LOG_TYPE, ASL_IND_ACTIVE_JN, ASL_ACTIVATION_DATE, ASL_OPMERKING) 
--VALUES (1, 'INTERSPC' ,'MV_ITBOMLYSOURCE', 'J', 'ALL','N' , to_date(null), 'replacement for ITBOMLYSOURCE with a PK' );
UPDATE DBA_AWS_SUPPLEMENTAL_LOG set ASL_PK_EXISTS_JN='J', ASL_IND_ACTIVE_JN='J', ASL_ACTIVATION_DATE=to_date(NULL), asl_opmerking=ASL_OPMERKING||' PK-added 02-10-2023'  where asl_table_name = 'ITBOMLYSOURCE' ;
COMMIT;

--we don't create a MATERIALIZED-VIEW: Table is EMPTY !!!
--INSERT INTO DBA_AWS_SUPPLEMENTAL_LOG (ASL_ID, ASL_SCHEMA_OWNER, ASL_TABLE_NAME, ASL_PK_EXISTS_JN, ASL_SUPPL_LOG_TYPE, ASL_IND_ACTIVE_JN, ASL_ACTIVATION_DATE, ASL_OPMERKING) 
--VALUES (1, 'INTERSPC' ,'MV_ITUP', 'J', 'ALL','N' , to_date(null), 'replacement for ITUP with a PK' );
UPDATE DBA_AWS_SUPPLEMENTAL_LOG set ASL_PK_EXISTS_JN='N', ASL_IND_ACTIVE_JN='N' , ASL_ACTIVATION_DATE=to_date(NULL) , ASL_OPMERKING=ASL_OPMERKING||' Table is empty, no replication' where asl_table_name = 'ITUP' ;
--
COMMIT;
*/


--***************************************************
--grant to UNILAB !!!
--***************************************************
GRANT CREATE MATERIALIZED VIEW TO UNILAB;




--************************************
-- UNILAB.ATAOACTIONS
--************************************
--Hoeveel records in tabel:
select count(*) from ATAOACTIONS;
71

--WELKE INDEXEN OP ATAOACTIONS AANWEZIG:
SELECT * from all_indexes where table_name = 'ATAOACTIONS';
--no-rows-selected




/*
Basic Syntax
The full syntax description for the CREATE MATERIALIZED VIEW command is available in the documentation. 
Here we will only concern ourselves with the basics.

-- Normal
CREATE MATERIALIZED VIEW view-name
BUILD [IMMEDIATE | DEFERRED]
REFRESH [FAST | COMPLETE | FORCE ]
ON [COMMIT | DEMAND ]
[[ENABLE | DISABLE] QUERY REWRITE]
AS
SELECT ...;

-- Pre-Built
CREATE MATERIALIZED VIEW view-name
ON PREBUILT TABLE
REFRESH [FAST | COMPLETE | FORCE ]
ON [COMMIT | DEMAND ]
[[ENABLE | DISABLE] QUERY REWRITE]
AS
SELECT ...;

The BUILD clause options are shown below.
IMMEDIATE : The materialized view is populated immediately.
DEFERRED  : The materialized view is populated on the first requested refresh.

The following refresh types are available.
FAST 	 : A fast refresh is attempted. If materialized view logs are not present against the source tables in advance, the creation fails.
COMPLETE : The table segment supporting the materialized view is truncated and repopulated completely using the associated query.
FORCE    : A fast refresh is attempted. If one is not possible a complete refresh is performed.

A refresh can be triggered in one of two ways.
ON COMMIT : The refresh is triggered by a committed data change in one of the dependent tables.
ON DEMAND : The refresh is initiated by a manual request or a scheduled task.

The QUERY REWRITE clause tells the optimizer if the materialized view should be consider for query rewrite operations. An example of the query rewrite functionality is shown below.
The ON PREBUILT TABLE clause tells the database to use an existing table segment, which must have the same name as the materialized view and support the same column structure as the query.

WITH ROWID Clause
Specify WITH ROWID to create a rowid materialized view. Rowid materialized views are useful if the materialized view 
does not include all primary key columns of the master tables. Rowid materialized views must be based on a single table 
and cannot contain any of the following:
-Distinct or aggregate functions
-GROUP BY or CONNECT BY clauses
-Subqueries
-Joins
-Set operations
The WITH ROWID clause has no effect if there are multiple master tables in the defining query.
*/

/*
ALTER MATERIALIZED VIEW MV_SPECDATA 
ADD CONSTRAINT MV_SPECDATA_PK 
PRIMARY KEY (PART_NO, REVISION, SECTION_ID, SUB_SECTION_ID, PROPERTY_GROUP, PROPERTY, HEADER_ID, LANG_ID)
;
*/
/*
Error report -
ORA-01449: column contains NULL values; cannot alter to NOT NULL
01449. 00000 -  "column contains NULL values; cannot alter to NOT NULL"
*Cause:    
*Action:
*/


--CONTROLE PK-DATA 

SELECT a.action, COUNT(*)
FROM ATAOACTIONS a
GROUP BY a.action
HAVING COUNT(*) > 1
;
--RQ_A08	2
--
--RQ_A08	Set PA state to available
--RQ_A08	Cancel worksheet(s)

--Wat komt er in LC voor?
--R1	Request trials	@@	Default	@C	Cancelled	OnlyManual	RQ_A08


--CONCLUSIE: ZOU WEL UNIEK MOETEN KUNNEN ZIJN, WAARDOOR GEEN MV NODIG IS. MAAR DATA IS NIET GOED !!!!!!!

--initial-insert (BASE-TABLE WILL NOT BE REPLICATED so active=N + ASL_ACTIVATION_DATE left EMPTY
UPDATE DBA_AWS_SUPPLEMENTAL_LOG set ASL_IND_ACTIVE_JN='J', ASL_ACTIVATION_DATE=TO_DATE(NULL) , ASL_OPMERKING=ASL_OPMERKING||' PK added manually on base-table' where ASL_table_name = 'ATAOACTIONS' ;
--PK = ASL_ID will be filled by insert-trigger, ASL_ACTIVATION_DATE is filled by supplement-proc)
--INSERT INTO DBA_AWS_SUPPLEMENTAL_LOG (ASL_SCHEMA_OWNER, ASL_TABLE_NAME, ASL_PK_EXISTS_JN, ASL_SUPPL_LOG_TYPE, ASL_IND_ACTIVE_JN, ASL_ACTIVATION_DATE, ASL_OPMERKING) 
--VALUES ('INTERSPC' ,'MV_ATAOACTIONS', 'J', 'ALL','J' , NULL, ' Replacement for ATAOACTIONS with a PK' );
--COMMIT;



--create index on BASE-TABLE
ALTER TABLE  ATAOACTIONS
ADD CONSTRAINT ATAOACTIONS_PK PRIMARY KEY (ACTION) 
USING INDEX TABLESPACE SPECI 
;


--MELDING BIJ AANMAKEN VAN MV:
/*
ORA-00439: feature not enabled: Materialized view rewrite
00439. 00000 -  "feature not enabled: %s"
*Cause:    The specified feature is not enabled.
*Action:   Do not attempt to use this feature. 
--
--DUS DISABLE QUERY REWRITE ipv ENABLE QUERY REWRITE...
*/

/*
ORA-23413: table "INTERSPC"."SPECDATA" does not have a materialized view log
23413. 00000 -  "table \"%s\".\"%s\" does not have a materialized view log"
*Cause:    The fast refresh can not be performed because the master table
           does not contain a materialized view log.
*Action:   Use the CREATE MATERIALIZED VIEW LOG command to create a materialized view log on the master table.
--
--DUS EERST MV-LOG-TABLE AANMAKEN...
*/		   

CREATE MATERIALIZED VIEW LOG 
ON ATAOACTIONS 
PCTFREE 5
TABLESPACE USERS
WITH ROWID
--PRIMARY KEY, ROWID
; 


/*
Error report -
ORA-12014: table 'SPECDATA' does not contain a primary key constraint
12014. 00000 -  "table '%s' does not contain a primary key constraint"
*Cause:    The CREATE MATERIALIZED VIEW LOG command was issued with the
           WITH PRIMARY KEY option and the master table did not contain
           a primary key constraint or the constraint was disabled.
*Action:   Reissue the command using only the WITH ROWID option, create a
           primary key constraint on the master table, or enable an existing
           primary key constraint.
*/		   

--
CREATE MATERIALIZED VIEW MV_ATAOACTIONS
TABLESPACE USERS
PCTFREE 5
PARALLEL 4
BUILD IMMEDIATE
REFRESH FAST
ON COMMIT WITH ROWID
DISABLE QUERY REWRITE 
AS SELECT ACTION
,         DESCRIPTION    
from ATAOACTIONS
;

--wel zo'n 15 GB aan storage !!!!
ALTER MATERIALIZED VIEW MV_ATAOACTIONS 
ADD CONSTRAINT MV_ATAOACTIONS_PK 
PRIMARY KEY (ACTION)
;




--************************************
-- UNILAB.ATAOCONDITIONS
--************************************
--Hoeveel records in tabel:
select count(*) from ATAOCONDITIONS;
100

--WELKE INDEXEN OP SPECDATA AANWEZIG:
SELECT * from all_indexes where table_name = 'ATAOCONDITIONS';
--no-rows-selected


--CONTROLE PK-DATA 

SELECT a.condition, COUNT(*)
FROM ATAOCONDITIONS a
GROUP BY a.condition
HAVING COUNT(*) > 1
;
--no-rows-selected

--CONCLUSIE: WE KUNNEN EEN PK op de BASE-TABLE AANMAKEN, GEEN MATERIALIZED-VIEW NODIG !!!

--initial-insert (BASE-TABLE WILL NOT BE REPLICATED so active=N + ASL_ACTIVATION_DATE left EMPTY
UPDATE DBA_AWS_SUPPLEMENTAL_LOG set ASL_IND_ACTIVE_JN='J', ASL_ACTIVATION_DATE=TO_DATE(NULL) , ASL_OPMERKING=ASL_OPMERKING||' PK added manually on base-table' where ASL_table_name = 'ATAOACTIONS' ;
--PK = ASL_ID will be filled by insert-trigger, ASL_ACTIVATION_DATE is filled by supplement-proc)
--INSERT INTO DBA_AWS_SUPPLEMENTAL_LOG (ASL_SCHEMA_OWNER, ASL_TABLE_NAME, ASL_PK_EXISTS_JN, ASL_SUPPL_LOG_TYPE, ASL_IND_ACTIVE_JN, ASL_ACTIVATION_DATE, ASL_OPMERKING) 
--VALUES ('INTERSPC' ,'MV_ATAOACTIONS', 'J', 'ALL','J' , NULL, ' Replacement for ATAOACTIONS with a PK' );
--COMMIT;




--CREATE INDEX
ALTER TABLE  ATAOCONDITIONS
ADD CONSTRAINT ATAOCONDITIONS_PK PRIMARY KEY (CONDITION) 
USING INDEX TABLESPACE UNI_INDEXO 
;

/*
--We hoeven hier geen MATERIALIZED-VIEW van te maken !!!!

CREATE MATERIALIZED VIEW LOG 
ON ATAOCONDITIONS 
PCTFREE 5
TABLESPACE USERS
WITH ROWID
; 

CREATE MATERIALIZED VIEW MV_ATAOCONDITIONS
TABLESPACE USERS
PCTFREE 5
PARALLEL 4
BUILD IMMEDIATE
REFRESH FAST
ON COMMIT WITH ROWID
DISABLE QUERY REWRITE 
AS SELECT CONDITION
,         DESCRIPTION
from ATAOCONDITIONS
;

ALTER MATERIALIZED VIEW MV_ATAOCONDITIONS
ADD CONSTRAINT MV_ATAOCONDITIONS_PK 
PRIMARY KEY (CONDITION)
;
*/



--************************************
-- UNILAB.ATICTRHS    (auto-filled by UNACTION.LOG_TRANSACTION by the EVENT-MANAGER? )
--************************************
--Hoeveel records in tabel:
select count(*) from ATICTRHS;
0

/*
SC			VARCHAR2(20 CHAR)	No
IC			VARCHAR2(20 CHAR)	No
ICNODE		NUMBER	No
SS_FROM		VARCHAR2(2 CHAR)	Yes
SS_TO		VARCHAR2(2 CHAR)	Yes
TR_ON		TIMESTAMP(4) WITH LOCAL TIME ZONE	No
TR_ON_TZ	TIMESTAMP(4) WITH TIME ZONE	No
TR_SEQ		NUMBER	Yes
EV_SEQ		NUMBER	Yes
*/

--CONCLUSIE: TABEL IS LEEG. WE GAAN DEZE NIET REPLICEREN NAAR REDSHIFT ....

/*
CREATE INDEX "UNILAB"."AIICTRHS_OBJECT" ON "UNILAB"."ATICTRHS" ("SC", "IC", "ICNODE", "SS_TO", "TR_ON" DESC) 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "UNI_INDEXO" ;
*/


/*
CREATE MATERIALIZED VIEW LOG 
ON ATICTRHS
PCTFREE 5
TABLESPACE USERS
WITH ROWID
; 

CREATE MATERIALIZED VIEW MV_ATICTRHS
TABLESPACE USERS
PCTFREE 5
PARALLEL 4
BUILD IMMEDIATE
REFRESH FAST
ON COMMIT WITH ROWID
DISABLE QUERY REWRITE 
AS SELECT SC		
,         IC		
,         ICNODE	
,         SS_FROM	
,         SS_TO	
,         TR_ON	
,          TR_ON_TZ
,          TR_SEQ	
,          EV_SEQ	
from ATICTRHS
;

ALTER MATERIALIZED VIEW MV_ATICTRHS
ADD CONSTRAINT MV_ATICTRHS_PK 
PRIMARY KEY (sc, ic, tr_on, tr_seq, ev_seq )
;
*/



--************************************
-- UNILAB.ATMETRHS     (auto-filled by UNACTION.LOG_TRANSACTION by the EVENT-MANAGER? )
--************************************
--Hoeveel records in tabel:
select count(*) from ATMETRHS;
13812072

/*
SC			VARCHAR2(20 CHAR)	No
PG			VARCHAR2(20 CHAR)	No
PGNODE		NUMBER	No
PA			VARCHAR2(20 CHAR)	No
PANODE		NUMBER	No
ME			VARCHAR2(20 CHAR)	No
MENODE		NUMBER	No
SS_FROM		VARCHAR2(2 CHAR)	Yes
SS_TO		VARCHAR2(2 CHAR)	Yes
TR_ON		TIMESTAMP(4) WITH LOCAL TIME ZONE	No
TR_ON_TZ	TIMESTAMP(4) WITH TIME ZONE	No
TR_SEQ		NUMBER	Yes
EV_SEQ		NUMBER	Yes
*/

/*
ALTER TABLE  ATMETRHS
ADD CONSTRAINT ATMETRHS_PK PRIMARY KEY ( ROWID ) 
USING INDEX TABLESPACE SPECI 
;

CREATE UNIQUE INDEX AIMETRHS_ROWID_IX ON ATMETRHS (ROWID )
TABLESPACE UNI_INDEXO ;
*/

select sc, pg, pgnode, pa, panode, me, menode, ss_to, tr_on, count(*) 
from ATMETRHS
group by sc, pg, pgnode, pa, panode, me, menode, ss_to, tr_on
having count(*) > 1
;
/*
--CONCLUSIE:  ER IS GEEN UNIEKE COMBINATIE VAN ATTRIBUTEN VOORHANDEN OM EEN PK MEE TE MAKEN !!!!!
--            HOE NU VERDER?


/*
CREATE MATERIALIZED VIEW LOG 
ON ATMETRHS
PCTFREE 5
TABLESPACE USERS
WITH ROWID
; 

CREATE MATERIALIZED VIEW MV_ATMETRHS
TABLESPACE USERS
PCTFREE 5
PARALLEL 4
BUILD IMMEDIATE
REFRESH FAST
ON COMMIT WITH ROWID
DISABLE QUERY REWRITE 
AS 
SELECT DISTINCT SC		
,         PG		
,         PGNODE	
,         PA		
,         PANODE	
,         ME		
,         MENODE	
,         SS_FROM	
,         SS_TO	
,          TR_ON	
,          TR_ON_TZ
,          TR_SEQ	
,          EV_SEQ	
from ATMETRHS
;

ALTER MATERIALIZED VIEW MV_ATMETRHS
ADD CONSTRAINT MV_ATMETRHS_PK 
PRIMARY KEY (ROWID )
;
*/




--************************************
-- UNILAB.ATPATRHS   (auto-filled by UNACTION.LOG_TRANSACTION by the EVENT-MANAGER? )
--************************************
--Hoeveel records in tabel:
select count(*) from ATPATRHS;
73413629

/*
SC			VARCHAR2(20 CHAR)	No
PG			VARCHAR2(20 CHAR)	No
PGNODE		NUMBER				No
PA			VARCHAR2(20 CHAR)	No
PANODE		NUMBER				No
SS_FROM		VARCHAR2(2 CHAR)	Yes
SS_TO		VARCHAR2(2 CHAR)	Yes
TR_ON		TIMESTAMP(4) WITH LOCAL TIME ZONE	No
TR_ON_TZ	TIMESTAMP(4) WITH TIME ZONE			No
TR_SEQ		NUMBER			Yes
EV_SEQ		NUMBER			Yes
*/


select sc, pg, pgnode, pa, panode, ss_to, tr_on, count(*) 
from ATPATRHS
group by sc, pg, pgnode, pa, panode, ss_to, tr_on
having count(*) > 1
;
/*
--CONCLUSIE:  ER IS GEEN UNIEKE COMBINATIE VAN ATTRIBUTEN VOORHANDEN OM EEN PK MEE TE MAKEN !!!!!
--            HOE NU VERDER?


/*
CREATE MATERIALIZED VIEW LOG 
ON ATPATRHS
PCTFREE 5
TABLESPACE USERS
WITH ROWID
; 

CREATE MATERIALIZED VIEW MV_ATPATRHS
TABLESPACE USERS
PCTFREE 5
PARALLEL 4
BUILD IMMEDIATE
REFRESH FAST
ON COMMIT WITH ROWID
DISABLE QUERY REWRITE 
AS 
SELECT DISTINCT SC		
,         PG		
,         PGNODE	
,         PA		
,         PANODE	
,         ME		
,         MENODE	
,         SS_FROM	
,         SS_TO	
,          TR_ON	
,          TR_ON_TZ
,          TR_SEQ	
,          EV_SEQ	
from ATPATRHS
;

ALTER MATERIALIZED VIEW MV_ATPATRHS
ADD CONSTRAINT MV_ATPATRHS_PK 
PRIMARY KEY ( ROWID )
;
*/



--************************************
-- UNILAB.ATRQTRHS   (auto-filled by UNACTION.LOG_TRANSACTION by the EVENT-MANAGER? )
--************************************
--Hoeveel records in tabel:
select count(*) from ATRQTRHS;
6387695

/*
RQ			VARCHAR2(20 CHAR)	No
SS_FROM		VARCHAR2(2 CHAR)	Yes
SS_TO		VARCHAR2(2 CHAR)	Yes
TR_ON		TIMESTAMP(4) WITH LOCAL TIME ZONE	No
TR_ON_TZ	TIMESTAMP(4) WITH TIME ZONE			No
TR_SEQ		NUMBER				Yes
EV_SEQ		NUMBER				Yes
*/


select RQ, ss_to, tr_on, count(*) 
from ATRQTRHS
group by RQ, ss_to, tr_on
having count(*) > 1
;
/*
--CONCLUSIE:  ER IS GEEN UNIEKE COMBINATIE VAN ATTRIBUTEN VOORHANDEN OM EEN PK MEE TE MAKEN !!!!!
--            HOE NU VERDER?


/*
CREATE MATERIALIZED VIEW LOG 
ON ATRQTRHS
PCTFREE 5
TABLESPACE USERS
WITH ROWID
; 

CREATE MATERIALIZED VIEW MV_ATRQTRHS
TABLESPACE USERS
PCTFREE 5
PARALLEL 4
BUILD IMMEDIATE
REFRESH FAST
ON COMMIT WITH ROWID
DISABLE QUERY REWRITE 
AS 
SELECT DISTINCT   RQ		
, SS_FROM	
, SS_TO	
, TR_ON	
, TR_ON_TZ
, TR_SEQ	
, EV_SEQ	
from ATRQTRHS
;

ALTER MATERIALIZED VIEW MV_ATRQTRHS
ADD CONSTRAINT MV_ATRQTRHS_PK 
PRIMARY KEY ( ROWID )
;
*/

--************************************
-- UNILAB.ATSCTRHS   (auto-filled by UNACTION.LOG_TRANSACTION by the EVENT-MANAGER? )
--************************************
--Hoeveel records in tabel:
select count(*) from ATSCTRHS;
8207696

/*
SC			VARCHAR2(20 CHAR)	No
SS_FROM		VARCHAR2(2 CHAR)	Yes
SS_TO		VARCHAR2(2 CHAR)	Yes
TR_ON		TIMESTAMP(4) WITH LOCAL TIME ZONE	No
TR_ON_TZ	TIMESTAMP(4) WITH TIME ZONE			No
TR_SEQ		NUMBER				Yes
EV_SEQ		NUMBER				Yes
*/


select SC, ss_to, tr_on, count(*) 
from ATSCTRHS
group by SC, ss_to, tr_on
having count(*) > 1
;
/*
--CONCLUSIE:  ER IS GEEN UNIEKE COMBINATIE VAN ATTRIBUTEN VOORHANDEN OM EEN PK MEE TE MAKEN !!!!!
--            HOE NU VERDER?


/*
CREATE MATERIALIZED VIEW LOG 
ON ATSCTRHS
PCTFREE 5
TABLESPACE USERS
WITH ROWID
; 

CREATE MATERIALIZED VIEW MV_ATSCTRHS
TABLESPACE USERS
PCTFREE 5
PARALLEL 4
BUILD IMMEDIATE
REFRESH FAST
ON COMMIT WITH ROWID
DISABLE QUERY REWRITE 
AS 
SELECT DISTINCT   SC		
, SS_FROM	
, SS_TO	
, TR_ON	
, TR_ON_TZ
, TR_SEQ	
,  EV_SEQ	
from ATSCTRHS
;

ALTER MATERIALIZED VIEW MV_ATSCTRHS
ADD CONSTRAINT MV_ATSCTRHS_PK 
PRIMARY KEY ( ROWID )
;
*/


--************************************
-- UNILAB.UTLCHS   
--************************************
--Hoeveel records in tabel:
select count(*) from UTLCHS;
3097

/*
LC					VARCHAR2(2 CHAR)	No
VERSION				VARCHAR2(20 CHAR)	No
WHO					VARCHAR2(20 CHAR)	No
WHO_DESCRIPTION		VARCHAR2(40 CHAR)	No
WHAT				VARCHAR2(60 CHAR)	No
WHAT_DESCRIPTION	VARCHAR2(255 CHAR)	No
LOGDATE				TIMESTAMP(0) WITH LOCAL TIME ZONE	No
WHY					VARCHAR2(255 CHAR)	Yes
TR_SEQ				NUMBER				No
EV_SEQ				NUMBER				No
LOGDATE_TZ			TIMESTAMP(0) WITH TIME ZONE	Yes
*/


select lc, version, who, what, logdate, tr_seq, ev_seq, count(*) 
from UTLCHS
group by lc, version, who, what, logdate, tr_seq, ev_seq
having count(*) > 1
;

/*
--CONCLUSIE:  ER IS EINDELIJK EEN UNIEKE COMBINATIE VAN ATTRIBUTEN VOORHANDEN OM EEN PK MEE TE MAKEN !!!!!
*/

ALTER TABLE  UTLCHS
ADD CONSTRAINT UTLCHS_PK PRIMARY KEY ( lc, version, who, what, logdate, tr_seq, ev_seq ) 
USING INDEX TABLESPACE SPECI 
;



/*
CREATE MATERIALIZED VIEW LOG 
ON UTLCHS
PCTFREE 5
TABLESPACE UNI_DATAC
WITH ROWID
; 

DROP MATERIALIZED VIEW LOG on UTLCHS;
PURGE RECYCLEBIN;


CREATE MATERIALIZED VIEW MV_UTLCHS
TABLESPACE UNI_DATAC
PCTFREE 5
PARALLEL 4
BUILD IMMEDIATE
REFRESH FAST
ON COMMIT WITH ROWID
DISABLE QUERY REWRITE 
AS 
SELECT LC				
, VERSION			
, WHO				
, WHO_DESCRIPTION	
, WHAT			
, WHAT_DESCRIPTION
,  LOGDATE			
,  WHY				
,  TR_SEQ			
,  EV_SEQ			
, LOGDATE_TZ		
from UTLCHS
;

DROP MATERIALIZED VIEW MV_UTLCHS;
PURGE RECYCLEBIN;

/*
--using SELECT DISTINCT LC doesn't work !!!
Error report -
ORA-12054: cannot set the ON COMMIT refresh attribute for the materialized view
12054. 00000 -  "cannot set the ON COMMIT refresh attribute for the materialized view"
*Cause:    The materialized view did not satisfy conditions for refresh at
           commit time.
*Action:   Specify only valid options.


--using SELECT ROWID doensn't work either !!!
Error report -
ORA-00904: "ROWID": invalid identifier
00904. 00000 -  "%s: invalid identifier"
*Cause:    
*Action:

*/

/*
ALTER MATERIALIZED VIEW MV_UTLCHS
ADD CONSTRAINT MV_UTLCHS_PK 
PRIMARY KEY ( lc, version, who, what, logdate, tr_seq, ev_seq )
;
*/


--************************************
-- UNILAB.UTMTHS   
--************************************
--Hoeveel records in tabel:
select count(*) from UTMTHS;
130177

/*
MT					VARCHAR2(20 CHAR)	No
VERSION				VARCHAR2(20 CHAR)	No
WHO					VARCHAR2(20 CHAR)	No
WHO_DESCRIPTION		VARCHAR2(40 CHAR)	No
WHAT				VARCHAR2(60 CHAR)	No
WHAT_DESCRIPTION	VARCHAR2(255 CHAR)	No
LOGDATE				TIMESTAMP(0) WITH LOCAL TIME ZONE	No
WHY					VARCHAR2(255 CHAR)	Yes
TR_SEQ				NUMBER	No
EV_SEQ				NUMBER	No
LOGDATE_TZ			TIMESTAMP(0) WITH TIME ZONE	Yes
*/


select mt, version, who, what, logdate, tr_seq, ev_seq, count(*) 
from UTMTHS
group by lc, version, who, what, logdate, tr_seq, ev_seq
having count(*) > 1
;

/*
--CONCLUSIE:  ER IS EINDELIJK EEN UNIEKE COMBINATIE VAN ATTRIBUTEN VOORHANDEN OM EEN PK MEE TE MAKEN !!!!!
*/

ALTER TABLE  UTMTHS
ADD CONSTRAINT UTMTHS_PK PRIMARY KEY ( mt, version, who, what, logdate, tr_seq, ev_seq ) 
USING INDEX TABLESPACE SPECI 
;


/*
CREATE MATERIALIZED VIEW LOG 
ON UTMTHS
PCTFREE 5
TABLESPACE UNI_DATAC
WITH ROWID
; 

DROP MATERIALIZED VIEW LOG on UTMTHS;
PURGE RECYCLEBIN;


CREATE MATERIALIZED VIEW MV_UTMTHS
TABLESPACE UNI_DATAC
PCTFREE 5
PARALLEL 4
BUILD IMMEDIATE
REFRESH FAST
ON COMMIT WITH ROWID
DISABLE QUERY REWRITE 
AS 
SELECT MT				
, VERSION			
, WHO				
, WHO_DESCRIPTION	
, WHAT			
, WHAT_DESCRIPTION
,  LOGDATE			
,  WHY				
,  TR_SEQ			
,  EV_SEQ			
, LOGDATE_TZ		
from UTLCHS
;

DROP MATERIALIZED VIEW MV_UTMTHS ;
PURGE RECYCLEBIN;


/*
ALTER MATERIALIZED VIEW MV_UTMTHS
ADD CONSTRAINT MV_UTMTHS_PK 
PRIMARY KEY ( mt, version, who, what, logdate, tr_seq, ev_seq )
;
*/


--************************************
-- UNILAB.UTPRHS   
--************************************
--Hoeveel records in tabel:
select count(*) from UTPRHS;
232653

/*
PR					VARCHAR2(20 CHAR)	No
VERSION				VARCHAR2(20 CHAR)	No
WHO					VARCHAR2(20 CHAR)	No
WHO_DESCRIPTION		VARCHAR2(40 CHAR)	No
WHAT				VARCHAR2(60 CHAR)	No
WHAT_DESCRIPTION	VARCHAR2(255 CHAR)	No
LOGDATE				TIMESTAMP(0) WITH LOCAL TIME ZONE	No
WHY					VARCHAR2(255 CHAR)	Yes
TR_SEQ				NUMBER	No
EV_SEQ				NUMBER	No
LOGDATE_TZ			TIMESTAMP(0) WITH TIME ZONE	Yes
*/


select pr, version, who, what, logdate, tr_seq, ev_seq, count(*) 
from UTPRHS
group by pr, version, who, what, logdate, tr_seq, ev_seq
having count(*) > 1
;

/*
--CONCLUSIE:  ER IS EINDELIJK EEN UNIEKE COMBINATIE VAN ATTRIBUTEN VOORHANDEN OM EEN PK MEE TE MAKEN !!!!!
*/

ALTER TABLE  UTPRHS
ADD CONSTRAINT UTPRHS_PK PRIMARY KEY ( pr, version, who, what, logdate, tr_seq, ev_seq ) 
USING INDEX TABLESPACE SPECI 
;


/*
CREATE MATERIALIZED VIEW LOG 
ON UTPRHS
PCTFREE 5
TABLESPACE UNI_DATAC
WITH ROWID
; 

DROP MATERIALIZED VIEW LOG on UTPRHS;
PURGE RECYCLEBIN;


CREATE MATERIALIZED VIEW MV_UTPRHS
TABLESPACE UNI_DATAC
PCTFREE 5
PARALLEL 4
BUILD IMMEDIATE
REFRESH FAST
ON COMMIT WITH ROWID
DISABLE QUERY REWRITE 
AS 
SELECT PR				
, VERSION			
, WHO				
, WHO_DESCRIPTION	
, WHAT			
, WHAT_DESCRIPTION
,  LOGDATE			
,  WHY				
,  TR_SEQ			
,  EV_SEQ			
, LOGDATE_TZ		
from UTPRHS
;

DROP MATERIALIZED VIEW MV_UTPRHS ;
PURGE RECYCLEBIN;


/*
ALTER MATERIALIZED VIEW MV_UTPRHS
ADD CONSTRAINT MV_UTPRHS_PK 
PRIMARY KEY ( pr, version, who, what, logdate, tr_seq, ev_seq )
;
*/


--************************************
-- UNILAB.UTRQHS   
--************************************
--Hoeveel records in tabel:
select count(*) from UTRQHS;
10785946

/*
RQ					VARCHAR2(20 CHAR)	No
WHO					VARCHAR2(20 CHAR)	No
WHO_DESCRIPTION		VARCHAR2(40 CHAR)	No
WHAT				VARCHAR2(60 CHAR)	No
WHAT_DESCRIPTION	VARCHAR2(255 CHAR)	No
LOGDATE				TIMESTAMP(0) WITH LOCAL TIME ZONE	No
WHY					VARCHAR2(255 CHAR)	Yes
TR_SEQ				NUMBER	No
EV_SEQ				NUMBER	No
LOGDATE_TZ			TIMESTAMP(0) WITH TIME ZONE	Yes
*/


select rq, who, what, why, logdate, tr_seq, ev_seq, count(*) 
from UTRQHS
group by rq, who, what, why, logdate, tr_seq, ev_seq
having count(*) > 1
;


/*
--CONCLUSIE:  ER IS EINDELIJK EEN UNIEKE COMBINATIE VAN ATTRIBUTEN VOORHANDEN OM EEN PK MEE TE MAKEN !!!!!
*/

ALTER TABLE  UTRQHS
ADD CONSTRAINT UTRQHS_PK PRIMARY KEY ( rq, who, what, why, logdate, tr_seq, ev_seq ) 
USING INDEX TABLESPACE SPECI 
;


/*
CREATE MATERIALIZED VIEW LOG 
ON UTRQHS
PCTFREE 5
TABLESPACE UNI_DATAC
WITH ROWID
; 

DROP MATERIALIZED VIEW LOG on UTRQHS;
PURGE RECYCLEBIN;


CREATE MATERIALIZED VIEW MV_UTRQHS
TABLESPACE UNI_DATAC
PCTFREE 5
PARALLEL 4
BUILD IMMEDIATE
REFRESH FAST
ON COMMIT WITH ROWID
DISABLE QUERY REWRITE 
AS 
SELECT ROWNUM
, RQ				
, WHO				
, WHO_DESCRIPTION	
, WHAT			
, WHAT_DESCRIPTION
, LOGDATE			
, WHY				
, TR_SEQ			
, EV_SEQ			
, LOGDATE_TZ		
from UTRQHS
;

--Try to create MV including the ROWID/ROWNUM-column, results in following error:
--Error report -
--ORA-00904: "ROWID": invalid identifier
--00904. 00000 -  "%s: invalid identifier"
--*Cause:    
--*Action:


DROP MATERIALIZED VIEW MV_UTRQHS ;
PURGE RECYCLEBIN;


/*
ALTER MATERIALIZED VIEW MV_UTRQHS
ADD CONSTRAINT MV_UTRQHS_PK 
PRIMARY KEY ( rq, version, who, what, why, logdate, tr_seq, ev_seq )
;
*/



--************************************
-- UNILAB.UTSCHS   
--************************************
--Hoeveel records in tabel:
select count(*) from UTSCHS;
144402253

/*
SC					VARCHAR2(20 CHAR)	No
WHO					VARCHAR2(20 CHAR)	No
WHO_DESCRIPTION		VARCHAR2(40 CHAR)	No
WHAT				VARCHAR2(60 CHAR)	No
WHAT_DESCRIPTION	VARCHAR2(255 CHAR)	No
LOGDATE				TIMESTAMP(0) WITH LOCAL TIME ZONE	No
WHY					VARCHAR2(255 CHAR)	Yes
TR_SEQ				NUMBER	No
EV_SEQ				NUMBER	No
LOGDATE_TZ			TIMESTAMP(0) WITH TIME ZONE	Yes
*/


select sc, who, what, why, logdate, tr_seq, ev_seq, count(*) 
from UTSCHS
group by sc, who, what, why, logdate, tr_seq, ev_seq
having count(*) > 1
;


/*
--CONCLUSIE:  ER IS EINDELIJK EEN UNIEKE COMBINATIE VAN ATTRIBUTEN VOORHANDEN OM EEN PK MEE TE MAKEN !!!!!
*/

ALTER TABLE  UTSCHS
ADD CONSTRAINT UTSCHS_PK PRIMARY KEY ( sc, who, what, why, logdate, tr_seq, ev_seq ) 
USING INDEX TABLESPACE SPECI 
;


/*
CREATE MATERIALIZED VIEW LOG 
ON UTSCHS
PCTFREE 5
TABLESPACE UNI_DATAC
WITH ROWID
; 

DROP MATERIALIZED VIEW LOG on UTSCHS;
PURGE RECYCLEBIN;


CREATE MATERIALIZED VIEW MV_UTSCHS
TABLESPACE UNI_DATAC
PCTFREE 5
PARALLEL 4
BUILD IMMEDIATE
REFRESH FAST
ON COMMIT WITH ROWID
DISABLE QUERY REWRITE 
AS 
SELECT SC				
, WHO				
, WHO_DESCRIPTION	
, WHAT			
, WHAT_DESCRIPTION
, LOGDATE			
, WHY				
, TR_SEQ			
, EV_SEQ			
, LOGDATE_TZ		
from UTRQHS
;

DROP MATERIALIZED VIEW MV_UTSCHS ;
PURGE RECYCLEBIN;


/*
ALTER MATERIALIZED VIEW MV_UTSCHS
ADD CONSTRAINT MV_UTSCHS_PK 
PRIMARY KEY ( SC, version, who, what, why, logdate, tr_seq, ev_seq )
;
*/


--UTSCMEHS
--************************************
-- UNILAB.UTSCMEHS   
--************************************
--Hoeveel records in tabel:
select count(*) from UTSCMEHS;
201196171

/*
SC				VARCHAR2(20 CHAR)	No
PG				VARCHAR2(20 CHAR)	No
PGNODE			NUMBER(9,0)	No
PA				VARCHAR2(20 CHAR)	No
PANODE			NUMBER(9,0)	No
ME				VARCHAR2(20 CHAR)	No
MENODE			NUMBER(9,0)	No
WHO				VARCHAR2(20 CHAR)	No
WHO_DESCRIPTION	VARCHAR2(40 CHAR)	No
WHAT			VARCHAR2(60 CHAR)	No
WHAT_DESCRIPTION	VARCHAR2(255 CHAR)	No
LOGDATE			TIMESTAMP(0) WITH LOCAL TIME ZONE	No
WHY				VARCHAR2(255 CHAR)	Yes
TR_SEQ			NUMBER	No
EV_SEQ			NUMBER	No
LOGDATE_TZ		TIMESTAMP(0) WITH TIME ZONE	Yes
*/


select sc, PG, pgnode, pa, panode, me, menode, who, what, why, logdate, tr_seq, ev_seq, count(*) 
from UTSCMEHS
group by sc, PG, pgnode, pa, panode, me, menode, who, what, why, logdate, tr_seq, ev_seq
having count(*) > 1
;

/*
MUT2249061T01	Simulations FT	1000000	ST330AA	1000000	SX100A	2000000	MUT	MeDetailsDeleted		14-12-2022 10.33.51.000000000 AM	683255	45871	2
YGR2245047T02	Indoor testing	500000	TT220AA	666664	CT008D	2000000	BOV	MeDetailsDeleted		05-01-2023 10.56.23.000000000 AM	115803	179317	2
BTA2250164T09	Indoor testing	500000	TT746XX	1000000	TT746B	3000000	JNA	MeDetailsDeleted		18-01-2023 01.09.52.000000000 PM	400885	798905	2
TTA2306121T01.F.FL	Mounting	1000000	Mounting	1000000	TP800A1	1000000	WIH	MeGroupKeyUpdated		01-03-2023 08.09.26.000000000 AM	370636	809299	2
23.131.TTA03.Y1.FL	Mounting	1000000	Mounting	1000000	TP800A1	1000000	MLU	MeGroupKeyUpdated		03-04-2023 11.26.31.000000000 AM	112665	168687	2
2317000214	Properties FM	1000000	Hardness (median)	1000000	TP001A	3000000	THA	MeDetailsDeleted		01-05-2023 02.38.53.000000000 PM	739433	955775	2
BSB2329090T02	Simulations FT	1000000	ST520AX	1000000	SX100A	2000000	MUT	MeDetailsDeleted		21-07-2023 05.18.02.000000000 PM	571958	245032	2
...
*/

/*
--CONCLUSIE:  ER IS GEEN UNIEKE COMBINATIE VAN ATTRIBUTEN VOORHANDEN OM EEN PK MEE TE MAKEN !!!!!
--            WAT NU TE DOEN ???????????
*/

/*
ALTER TABLE  UTSCMEHS
ADD CONSTRAINT UTSCMEHS_PK PRIMARY KEY ( sc, PG, pgnode, pa, panode, me, menode, who, what, why, logdate, tr_seq, ev_seq ) 
USING INDEX TABLESPACE SPECI 
;
*/

/*
CREATE MATERIALIZED VIEW LOG 
ON UTSCMEHS
PCTFREE 5
TABLESPACE UNI_DATAC
WITH ROWID
; 

DROP MATERIALIZED VIEW LOG on UTSCMEHS;
PURGE RECYCLEBIN;


CREATE MATERIALIZED VIEW MV_UTSCMEHS
TABLESPACE UNI_DATAC
PCTFREE 5
PARALLEL 4
BUILD IMMEDIATE
REFRESH FAST
ON COMMIT WITH ROWID
DISABLE QUERY REWRITE 
AS 
SELECT SC				
, PG				
, PGNODE			
, PA				
, PANODE			
, ME				
, MENODE			
, WHO				
, WHO_DESCRIPTION	
,  WHAT			
,  WHAT_DESCRIPTION
,  LOGDATE			
,  WHY				
,  TR_SEQ			
,  EV_SEQ			
,  LOGDATE_TZ		
from UTRQHS
;

DROP MATERIALIZED VIEW MV_UTSCMEHS ;
PURGE RECYCLEBIN;


/*
ALTER MATERIALIZED VIEW MV_UTSCMEHS
ADD CONSTRAINT MV_UTSCMEHS_PK 
PRIMARY KEY ( sc, PG, pgnode, pa, panode, me, menode, who, what, why, logdate, tr_seq, ev_seq )
;
*/


--UTSCMEHSDETAILS
--************************************
-- UNILAB.UTSCMEHSDETAILS   
--************************************
--Hoeveel records in tabel:
select count(*) from UTSCMEHSDETAILS;
421.960.843

/*
SC		VARCHAR2(20 CHAR)	No
PG		VARCHAR2(20 CHAR)	No
PGNODE	NUMBER(9,0)			No
PA		VARCHAR2(20 CHAR)	No
PANODE	NUMBER(9,0)			No
ME		VARCHAR2(20 CHAR)	No
MENODE	NUMBER(9,0)			No
TR_SEQ	NUMBER				No
EV_SEQ	NUMBER				No
SEQ		NUMBER				No
DETAILS	VARCHAR2(2000 CHAR)	Yes
*/


select sc, PG, pgnode, pa, panode, me, menode, tr_seq, ev_seq, seq, count(*) 
from UTSCMEHSDETAILS
group by sc, PG, pgnode, pa, panode, me, menode, tr_seq, ev_seq, seq
having count(*) > 1
;


/*
--CONCLUSIE:  TABEL IS VEEL TE GROOT OM IETS NORMAALS MEE TE KUNNEN UITVOEREN.
ORA-01652: unable to extend temp segment by 128 in tablespace UNI_TEMP
01652. 00000 -  "unable to extend temp segment by %s in tablespace %s"
*Cause:    Failed to allocate an extent of the required number of blocks for
           a temporary segment in the tablespace indicated.
*Action:   Use ALTER TABLESPACE ADD DATAFILE statement to add one or more
           files to the tablespace indicated.
		   

--            ER IS GEEN UNIEKE COMBINATIE VAN ATTRIBUTEN VOORHANDEN OM EEN PK MEE TE MAKEN !!!!!
*/

--ALTER TABLE  UTSCMEHSDETAILS
--ADD CONSTRAINT UTSCMEHSDETAILS_PK PRIMARY KEY ( sc, PG, pgnode, pa, panode, me, menode, tr_seq, ev_seq, seq ) 
--USING INDEX TABLESPACE SPECI 
--;


/*
CREATE MATERIALIZED VIEW LOG 
ON UTSCMEHSDETAILS
PCTFREE 5
TABLESPACE UNI_DATAC
WITH ROWID
; 

DROP MATERIALIZED VIEW LOG on UTSCMEHSDETAILS;
PURGE RECYCLEBIN;


CREATE MATERIALIZED VIEW MV_UTSCMEHSDETAILS
TABLESPACE UNI_DATAC
PCTFREE 5
PARALLEL 4
BUILD IMMEDIATE
REFRESH FAST
ON COMMIT WITH ROWID
DISABLE QUERY REWRITE 
AS 
SELECT SC		
, PG		
, PGNODE	
, PA		
, PANODE	
, ME		
, MENODE	
, TR_SEQ		
, EV_SEQ	
, SEQ		 
from UTSCMEHSDETAILS
;

DROP MATERIALIZED VIEW MV_UTSCMEHSDETAILS ;
PURGE RECYCLEBIN;


/*
ALTER MATERIALIZED VIEW MV_UTSCMEHSDETAILS
ADD CONSTRAINT MV_UTSCMEHSDETAILS_PK 
PRIMARY KEY ( sc, PG, pgnode, pa, panode, me, menode, tr_seq, ev_seq, seq )
;
*/



--
--************************************
-- UNILAB.UTSCPAHS   
--************************************
--Hoeveel records in tabel:
select count(*) from UTSCPAHS;
--188.043.266

/*
SC					VARCHAR2(20 CHAR)	No
PG					VARCHAR2(20 CHAR)	No
PGNODE				NUMBER(9,0)			No
PA					VARCHAR2(20 CHAR)	No
PANODE				NUMBER(9,0)			No
WHO					VARCHAR2(20 CHAR)	No
WHO_DESCRIPTION		VARCHAR2(40 CHAR)	No
WHAT				VARCHAR2(60 CHAR)	No
WHAT_DESCRIPTION	VARCHAR2(255 CHAR)	No
LOGDATE				TIMESTAMP(0) WITH LOCAL TIME ZONE	No
WHY					VARCHAR2(255 CHAR)	Yes
TR_SEQ				NUMBER				No
EV_SEQ				NUMBER				No
LOGDATE_TZ			TIMESTAMP(0) WITH TIME ZONE	Yes
*/


select sc, PG, pgnode, pa, panode, who, what, logdate, why, tr_seq, ev_seq, count(*) 
from UTSCPAHS
group by sc, PG, pgnode, pa, panode, who, what, logdate, why, tr_seq, ev_seq
having count(*) > 1
;


/*
--CONCLUSIE:  ER IS GEEN UNIEKE COMBINATIE VAN ATTRIBUTEN VOORHANDEN OM EEN PK MEE TE MAKEN !!!!!
*/

--ALTER TABLE  UTSCPAHS
--ADD CONSTRAINT UTSCPAHS_PK PRIMARY KEY ( sc, PG, pgnode, pa, panode, who, what, logdate, why, tr_seq, ev_seq ) 
--USING INDEX TABLESPACE SPECI 
--;





/*
CREATE MATERIALIZED VIEW LOG 
ON UTSCPAHS
PCTFREE 5
TABLESPACE UNI_DATAC
WITH ROWID
; 

DROP MATERIALIZED VIEW LOG on UTSCPAHS;
PURGE RECYCLEBIN;


CREATE MATERIALIZED VIEW MV_UTSCPAHS
TABLESPACE UNI_DATAC
PCTFREE 5
PARALLEL 4
BUILD IMMEDIATE
REFRESH FAST
ON COMMIT WITH ROWID
DISABLE QUERY REWRITE 
AS 
SELECT SC		
, SC				
, PG				
, PGNODE			
, PA				
, PANODE			
, WHO				
, WHO_DESCRIPTION	
, WHAT			
, WHAT_DESCRIPTION		
,  LOGDATE			
,  WHY				
,  TR_SEQ			
,  EV_SEQ			
,  LOGDATE_TZ		
from UTSCPAHS
;

DROP MATERIALIZED VIEW MV_UTSCPAHS ;
PURGE RECYCLEBIN;


/*
ALTER MATERIALIZED VIEW MV_UTSCPAHS
ADD CONSTRAINT MV_UTSCPAHS_PK 
PRIMARY KEY ( sc, PG, pgnode, pa, panode, who, what, logdate, why, tr_seq, ev_seq )
;
*/



--
--************************************
-- UNILAB.UTSTHS   
--************************************
--Hoeveel records in tabel:
select count(*) from UTSTHS;
--2066926

/*
ST					VARCHAR2(20 CHAR)	No
VERSION				VARCHAR2(20 CHAR)	No
WHO					VARCHAR2(20 CHAR)	No
WHO_DESCRIPTION		VARCHAR2(40 CHAR)	No
WHAT				VARCHAR2(60 CHAR)	No
WHAT_DESCRIPTION	VARCHAR2(255 CHAR)	No
LOGDATE				TIMESTAMP(0) WITH LOCAL TIME ZONE	No
WHY					VARCHAR2(255 CHAR)	Yes
TR_SEQ				NUMBER				No
EV_SEQ				NUMBER				No
LOGDATE_TZ			TIMESTAMP(0) WITH TIME ZONE	Yes
*/


select st, version, who, what, logdate, why, tr_seq, ev_seq, count(*) 
from UTSTHS
group by st, version, who, what, logdate, why, tr_seq, ev_seq
having count(*) > 1
;


/*
--CONCLUSIE:  ER IS WEL EEN UNIEKE COMBINATIE VAN ATTRIBUTEN VOORHANDEN OM EEN PK MEE TE MAKEN !!!!!
*/

ALTER TABLE  UTSTHS
ADD CONSTRAINT UTSTHS_PK PRIMARY KEY ( st, version, who, what, logdate, why, tr_seq, ev_seq ) 
USING INDEX TABLESPACE SPECI 
;





/*
CREATE MATERIALIZED VIEW LOG 
ON UTSTHS
PCTFREE 5
TABLESPACE UNI_DATAC
WITH ROWID
; 

DROP MATERIALIZED VIEW LOG on UTSTHS;
PURGE RECYCLEBIN;


CREATE MATERIALIZED VIEW MV_UTSTHS
TABLESPACE UNI_DATAC
PCTFREE 5
PARALLEL 4
BUILD IMMEDIATE
REFRESH FAST
ON COMMIT WITH ROWID
DISABLE QUERY REWRITE 
AS 
SELECT SC		
, ST				
, VERSION			
, WHO				
, WHO_DESCRIPTION	
, WHAT			
, WHAT_DESCRIPTION
, LOGDATE			
, WHY				
, TR_SEQ				
, EV_SEQ			
, LOGDATE_TZ		
from UTSTHS
;

DROP MATERIALIZED VIEW MV_UTSTHS ;
PURGE RECYCLEBIN;


/*
ALTER MATERIALIZED VIEW MV_UTSTHS
ADD CONSTRAINT MV_UTSTHS_PK 
PRIMARY KEY ( sc, PG, pgnode, pa, panode, who, what, logdate, why, tr_seq, ev_seq )
;
*/


--
--************************************
-- UNILAB.UTWSHS   
--************************************
--Hoeveel records in tabel:
select count(*) from UTWSHS;
--1.549.051

/*
WS					VARCHAR2(20 CHAR)	No
WHO					VARCHAR2(20 CHAR)	No
WHO_DESCRIPTION		VARCHAR2(40 CHAR)	No
WHAT				VARCHAR2(60 CHAR)	No
WHAT_DESCRIPTION	VARCHAR2(255 CHAR)	No
LOGDATE				TIMESTAMP(0) WITH LOCAL TIME ZONE	No
WHY					VARCHAR2(255 CHAR)	Yes
TR_SEQ				NUMBER				No
EV_SEQ				NUMBER				No
LOGDATE_TZ			TIMESTAMP(0) WITH TIME ZONE	Yes
*/


select WS, who, what, logdate, why, tr_seq, ev_seq, count(*) 
from UTWSHS
group by WS, who, what, logdate, why, tr_seq, ev_seq
having count(*) > 1
;


/*
--CONCLUSIE:  ER IS WEL GEEN UNIEKE COMBINATIE VAN ATTRIBUTEN VOORHANDEN OM EEN PK MEE TE MAKEN !!!!!
--            HET VALT HIER OP DAT IN TEGENSTELLING TOT ALLE ANDERE TABELLEN HIER MEER DAN 10/20x ZEFLDE RECORD VOORKOMT !!!!
*/

--ALTER TABLE  UTWSHS
--ADD CONSTRAINT UTWSHS_PK PRIMARY KEY ( st, version, who, what, logdate, why, tr_seq, ev_seq ) 
--USING INDEX TABLESPACE SPECI 
--;




/*
CREATE MATERIALIZED VIEW LOG 
ON UTWSHS
PCTFREE 5
TABLESPACE UNI_DATAC
WITH ROWID
; 

DROP MATERIALIZED VIEW LOG on UTWSHS;
PURGE RECYCLEBIN;


CREATE MATERIALIZED VIEW MV_UTWSHS
TABLESPACE UNI_DATAC
PCTFREE 5
PARALLEL 4
BUILD IMMEDIATE
REFRESH FAST
ON COMMIT WITH ROWID
DISABLE QUERY REWRITE 
AS 
SELECT SC		
, ST				
, VERSION			
, WHO				
, WHO_DESCRIPTION	
, WHAT			
, WHAT_DESCRIPTION
, LOGDATE			
, WHY				
, TR_SEQ				
, EV_SEQ			
, LOGDATE_TZ		
from UTWSHS
;

DROP MATERIALIZED VIEW MV_UTWSHS ;
PURGE RECYCLEBIN;


/*
ALTER MATERIALIZED VIEW MV_UTWSHS
ADD CONSTRAINT MV_UTWSHS_PK 
PRIMARY KEY ( sc, PG, pgnode, pa, panode, who, what, logdate, why, tr_seq, ev_seq )
;
*/


--
--************************************
-- UNILAB.UTWSII     (LET OP: IS GEEN HS-AUDIT-LOG-TABEL !!!!!!!!)
--************************************
--Hoeveel records in tabel:
select count(*) from UTWSII;
--60.777

/*
WS		VARCHAR2(20 CHAR)	Yes
ROWNR	NUMBER(4,0)			Yes
SC		VARCHAR2(20 CHAR)	Yes
IC		VARCHAR2(20 CHAR)	Yes
ICNODE	NUMBER(9,0)			Yes
II		VARCHAR2(20 CHAR)	Yes
IINODE	NUMBER(9,0)			Yes
*/


select WS, ROWNR, SC, IC, II, count(*) 
from UTWSII
group by WS, ROWNR, SC, IC, II
having count(*) > 1
;

select WS, ROWNR, count(*) 
from UTWSII
group by WS, ROWNR
having count(*) > 1
;


/*
--CONCLUSIE:  ER IS WEL EEN UNIEKE COMBINATIE VAN ATTRIBUTEN VOORHANDEN OM EEN PK MEE TE MAKEN !!!!!
*/

--ER BESTAAT AL EEN VIEW DIE WE ZOUDEN KUNNEN VERVANGEN DOOR EEN PK ????????
/*
CREATE INDEX "UNILAB"."UIWSIIROWS" ON "UNILAB"."UTWSII" ("WS", "ROWNR", "II") 
  PCTFREE 0 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "UNI_INDEXO" ;
*/

--voegen alleen nieuwe PK toe...
ALTER TABLE  UTWSII
ADD CONSTRAINT UTWSII_PK PRIMARY KEY ( WS, ROWNR ) 
USING INDEX TABLESPACE SPECI 
;




/*
CREATE MATERIALIZED VIEW LOG 
ON UTWSII
PCTFREE 5
TABLESPACE UNI_DATAC
WITH ROWID
; 

DROP MATERIALIZED VIEW LOG on UTWSII;
PURGE RECYCLEBIN;


CREATE MATERIALIZED VIEW MV_UTWSII
TABLESPACE UNI_DATAC
PCTFREE 5
PARALLEL 4
BUILD IMMEDIATE
REFRESH FAST
ON COMMIT WITH ROWID
DISABLE QUERY REWRITE 
AS 
SELECT SC		
, WS		
, ROWNR	
, SC		
, IC		
, ICNODE	
, II		
, IINODE	
from UTWSII
;

DROP MATERIALIZED VIEW MV_UTWSII ;
PURGE RECYCLEBIN;


/*
ALTER MATERIALIZED VIEW MV_UTWSII
ADD CONSTRAINT MV_UTWSII_PK 
PRIMARY KEY ( WS, ROWNR )
;
*/



--
--************************************
-- UNILAB.UTWSME     (LET OP: IS GEEN HS-AUDIT-LOG-TABEL !!!!!!!!)
--************************************
--Hoeveel records in tabel:
select count(*) from UTWSME;
--34584

/*
WS			VARCHAR2(20 CHAR)	Yes
ROWNR		NUMBER(4,0)	Yes
SC			VARCHAR2(20 CHAR)	Yes
PG			VARCHAR2(20 CHAR)	Yes
PGNODE		NUMBER(9,0)	Yes
PA			VARCHAR2(20 CHAR)	Yes
PANODE		NUMBER(9,0)	Yes
ME			VARCHAR2(20 CHAR)	Yes
MENODE		NUMBER(9,0)	Yes
REANALYSIS	NUMBER(3,0)	Yes
*/


select WS, ROWNR, SC, PG, PGNODE, PA, PANODE, ME, MENODE, REANALYSIS, count(*) 
from UTWSME
group by WS, ROWNR, SC, PG, PGNODE, PA, PANODE, ME, MENODE, REANALYSIS
having count(*) > 1
;

select WS, ROWNR, SC, count(*) 
from UTWSME
group by WS, ROWNR, sc
having count(*) > 1
;


/*
--CONCLUSIE:  ER IS WEL EEN UNIEKE COMBINATIE VAN ATTRIBUTEN VOORHANDEN OM EEN PK MEE TE MAKEN !!!!!
*/

--ER BESTAAT AL EEN VIEW DIE WE ZOUDEN KUNNEN VERVANGEN DOOR EEN PK ????????
/*
CREATE INDEX "UNILAB"."UIWSMEROWS" ON "UNILAB"."UTWSME" ("WS", "ROWNR", "ME") 
  PCTFREE 0 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "UNI_INDEXO" ;
*/

--voegen alleen nieuwe PK toe...
ALTER TABLE  UTWSME
ADD CONSTRAINT UTWSME_PK PRIMARY KEY ( WS, ROWNR, SC ) 
USING INDEX TABLESPACE SPECI 
;




/*
CREATE MATERIALIZED VIEW LOG 
ON UTWSME
PCTFREE 5
TABLESPACE UNI_DATAC
WITH ROWID
; 

DROP MATERIALIZED VIEW LOG on UTWSME;
PURGE RECYCLEBIN;


CREATE MATERIALIZED VIEW MV_UTWSME
TABLESPACE UNI_DATAC
PCTFREE 5
PARALLEL 4
BUILD IMMEDIATE
REFRESH FAST
ON COMMIT WITH ROWID
DISABLE QUERY REWRITE 
AS 
SELECT SC		
, WS			
, ROWNR		
, SC			
, PG			
, PGNODE		
, PA			
, PANODE		
,  ME			
,  MENODE		
,  REANALYSIS
from UTWSME
;

DROP MATERIALIZED VIEW MV_UTWSME ;
PURGE RECYCLEBIN;


/*
ALTER MATERIALIZED VIEW MV_UTWSME
ADD CONSTRAINT MV_UTWSME_PK 
PRIMARY KEY ( WS, ROWNR, SC )
;
*/





--**************************************************************************
--**************************************************************************
-- AANMAKEN STATISTICS...OP ALLE NIEUWE TABLE-INDEXES + MATERIALIZED-VIEWS !!
--**************************************************************************
--**************************************************************************

--conn interspc@interspec_tst
BEGIN
  DBMS_STATS.gather_table_stats(ownname => 'UNILAB'
                               ,tabname => 'MV_%%');
END;
/

--GATHER STATS OF ORIGINAL-TABLE WITH NEW PK !!!
BEGIN
  DBMS_STATS.gather_table_stats(ownname => 'UNILAB'
                               ,tabname => 'UT%%');
END;
/








--************************************************************************
--************************************************************************
--add supplemental log
--************************************************************************
--************************************************************************
alter system switch logfile; 
--l_pk_statement        varchar2(1000) := ' ADD SUPPLEMENTAL LOG DATA (PRIMARY KEY) COLUMNS';
--l_all_statement       varchar2(1000) := ' ADD SUPPLEMENTAL LOG DATA (ALL) COLUMNS';
--ALTER TABLE MV_SPECDATA ADD SUPPLEMENTAL LOG DATA (PRIMARY KEY) COLUMNS;
--ALTER TABLE MV_SPECDATA ADD SUPPLEMENTAL LOG DATA (ALL) COLUMNS;
--ALTER TABLE ITBOMLYSOURCE ADD SUPPLEMENTAL LOG DATA (ALL) COLUMNS;
SET SERVEROUTPUT ON

--RANDVOORWAARDE VOOR DBA_AWS_SUPPLEMENTAL_LOG !!!!!!!!
select ASL_id, ASL_schema_owner, ASL_table_name, ASL_pk_exists_jn, ASL_suppl_log_type, ASL_ind_active_jn, ASL_activation_date 
from dba_aws_supplemental_log 
where ASL_ind_active_jn='J' 
and ASL_table_name='ITBOMLYSOURCE';


--INCL DEBUG, GEEN COMMIT...
BEGIN DBA_AWS_ADD_SUPPLEMENTAL_LOG (p_table_name=>'MV_SPECDATA', p_debug=>'J'); END;
/
BEGIN DBA_AWS_ADD_SUPPLEMENTAL_LOG (p_table_name=>'ITBOMLYSOURCE', p_debug=>'J'); END;
/
--BEGIN DBA_AWS_ADD_SUPPLEMENTAL_LOG (p_table_name=>'MV_ITUP', p_debug=>'J'); END;

--DAADWERKELIJK AANZETTEN...
BEGIN DBA_AWS_ADD_SUPPLEMENTAL_LOG (p_table_name=>'MV_SPECDATA', p_debug=>'N'); END;
/
BEGIN DBA_AWS_ADD_SUPPLEMENTAL_LOG (p_table_name=>'ITBOMLYSOURCE', p_debug=>'N'); END;
/
--BEGIN DBA_AWS_ADD_SUPPLEMENTAL_LOG (p_table_name=>'MV_ITUP', p_debug=>'N'); END;
--/
COMMIT;


alter system switch logfile; 


--

/*
--EVT later droppen van supplemental-log...
alter table MV_SPECDATA drop supplemental log data (all) columns;
alter system switch logfile; 
*/
SET LINESIZE 300
select * from DBA_AWS_SUPPLEMENTAL_LOG WHERE ASL_TABLE_NAME IN ('SPECDATA', 'MV_SPECDATA', 'ITBOMLYSOURCE', 'ITUP' );




--************************************************************************
--************************************************************************
-- UITDELEN SYNONYMS + GRANTS op nieuwe MATERIALIZED-VIEWS ONLY !!!!!!!
--************************************************************************
--************************************************************************
drop public synonym MV_SPECDATA;
--drop public synonym MV_ITBOMLYSOURCE;
--drop public synonym MV_ITUP;
Create OR replace public synonym MV_SPECDATA for interspc.mv_specdata;
--Create OR replace public synonym MV_ITBOMLYSOURCE for interspc.MV_ITBOMLYSOURCE;
--Create OR replace public synonym MV_ITUP for interspc.MV_ITUP;

--
grant select on mv_specdata to awsdwh;
--grant select on MV_ITBOMLYSOURCE to awsdwh;
--grant select on MV_ITUP to awsdwh;










--EINDE SCRIPT.






--tables of Unilab are now synched with Redshift. You can check the tables and data in Redshift schema “sc_unilab_ens” of database “db_dev_lims”.
--I skipped 1 tables having BLOB or CLOB columns. 
--Can someone put details on what is the dependency on these tables? Do we need them for any AI/ML or simple reporting?
--UTBLOB      DATA          BLOB

--set all tables with a CLOB/BLOB-column on INACTIVE.
/*
Name                Null?    Type           
------------------- -------- -------------- 
ASL_ID              NOT NULL NUMBER(10)     
ASL_SCHEMA_OWNER             VARCHAR2(100)  
ASL_TABLE_NAME               VARCHAR2(100)  
ASL_PK_EXISTS_JN             VARCHAR2(1)    
ASL_SUPPL_LOG_TYPE           VARCHAR2(3)    
ASL_IND_ACTIVE_JN            VARCHAR2(1)    
ASL_ACTIVATION_DATE          DATE           
ASL_OPMERKING                VARCHAR2(1000) 
*/

SELECT COUNT(*), ASL_IND_ACTIVE_JN FROM DBA_AWS_SUPPLEMENTAL_LOG GROUP BY ASL_IND_ACTIVE_JN;

UPDATE DBA_AWS_SUPPLEMENTAL_LOG SET ASL_IND_ACTIVE_JN = 'N', ASL_OPMERKING=ASL_OPMERKING||' COLUMN=DATA=BLOB' WHERE ASL_SCHEMA_OWNER = 'UNILAB' AND  ASL_TABLE_NAME = 'UTBLOB';


COMMIT;


PROMPT
PROMPT EINDE SCRIPT
PROMPT 


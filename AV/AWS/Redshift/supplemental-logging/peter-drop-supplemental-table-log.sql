--DISABLE SUPPLEMENTAL-LOGGING
--Give command:

alter table HEADER drop supplemental log data (all) columns;
alter system switch logfile;

--VERIFY:
select * from ALL_LOG_GROUPS 
where  OWNER='UNILAB' ;


--let op: ACTIVE_JN moet op "J", staan, maar ASL_ACTIVATION_DATE moet nog leeg zijn !!!!!
--AND to keep registration consistant: update status in table DBA_AWS_SUPPLEMENTAL_LOG
--Via:
1) UPDATE DBA_AWS_SUPPLEMENTAL_LOG SET ASL_IND_ACTIVE_JN='N', ASL_ACTIVATION_DATE=NULL WHERE ASL_TABLE_NAME LIKE 'XXXXXX'   
   SELECT * FROM DBA_AWS_SUPPLEMENTAL_LOG WHERE ASL_TABLE_NAME LIKE 'XXXXXX';
   COMMIT;
Or:
2) Delete from DBA_AWS_SUPPLEMENTAL_LOG where ASL_TABLE_NAME LIKE ‘XXXXXX’;
   COMMIT;
   
   
--eindselect * from ALL_LOG_GROUPS 
where  OWNER='UNILAB' ;


--script om een PK aan te maken op de tabel UTERROR tbv REPLICATIE naar AWS-REDSHIFT 
--op basis waarvan nieuwe REPORTS gemaakt kunnen worden.

ALTER TABLE UNILAB.UTERROR ADD CONSTRAINT PK_UTERROR_SEQ PRIMARY KEY (ERR_SEQ)
USING INDEX
TABLESPACE UNI_INDEXC 
;

--bijwerken van SUPPLEMENTAL-LOG in stuurtabel:
select * from DBA_AWS_SUPPLEMENTAL_LOG where ASL_TABLE_NAME='UTERROR';
--503	UNILAB	UTERROR	N	ALL	J	14-09-2021 15:38:47	
--werk stuur-info bij !
Update dba_aws_supplemental_log SET ASL_PK_EXISTS_JN='J' where ASL_TABLE_NAME = 'UTERROR';
commit;


--CONTROLE LOGGING
select * from ALL_LOG_GROUPS where  OWNER='UNILAB' and table_name='UTERROR'; 

--*****************************************************
--INDIEN LOGGING UITSTAAT DAN OPNIEUW AANZETTEN !!!
--*****************************************************
--switch logfile
alter system switch logfile; 
--zet supplemental-logging weer aan voor de tabel = UTERROR !!
SET SERVEROUTPUT ON
--zet active-ind=N
update DBA_AWS_SUPPLEMENTAL_LOG set ASL_IND_ACTIVE_JN='N' where ASL_TABLE_NAME='UTERROR';
commit;

--indien INCL DEBUG, GEEN COMMIT...
--Indien tabel.attribuut ASL_IND_ACTIVE_JN='J' dan kan logging niet opnieuw worden uitgedeeld...
--
BEGIN DBA_AWS_ADD_SUPPLEMENTAL_LOG (p_table_name=>'UTERROR', p_debug=>'N'); END;

--CONTROLE LOGGING
select * from ALL_LOG_GROUPS where  OWNER='UNILAB' and table_name='UTERROR'; 


--werk stuur-info bij !
Update dba_aws_supplemental_log SET ASL_PK_EXISTS_JN='J' , ASL_IND_ACTIVE_JN='J' where ASL_TABLE_NAME = 'UTERROR';
commit;

--switch logfile
alter system switch logfile; 


--end script


--UNILAB-UNIVERSE
--REDSHIFT: https://docs.aws.amazon.com/redshift/latest/dg/c_SQL_commands.html
--
--To view comments, query the PG_DESCRIPTION system catalog. 
--Relname:      request    (let op: KLEINE LETTERS)
--Namespace:	sc_lims_dal, sc_unilab_ens, sc_interspec_ens   (let op: KLEINE LETTERS)
-- 
select oid, relname, relnamespace from pg_class where relname='request';
--1326662	request	  1230816

--RETRIEVE TABLE/VIEW-COMMENT
select descr.objoid        --table-id
,      cla.relname         --table-name
,      descr.objsubid
,      descr.description
from pg_catalog.pg_class       cla
,    pg_catalog.pg_description descr
where cla.oid        = descr.objoid 
and   descr.objsubid = 0
and   cla.relname    = 'request' 
and   cla.relnamespace = (select oid from pg_catalog.pg_namespace where nspname = 'sc_lims_dal') 
;

--RETRIEVE TABLE/VIEW-COLUMNS-COMMENT
select descr.objoid        --table-id
,      cla.relname         --table-name
,      descr.objsubid
,      att.attname
,      descr.description
from pg_catalog.pg_attribute   att
,    pg_catalog.pg_class       cla
,    pg_catalog.pg_description descr
where cla.oid      = descr.objoid 
and   att.attrelid = descr.objoid 
and   att.attnum   = descr.objsubid
and   cla.relname = 'request' 
and   cla.relnamespace = (select oid from pg_catalog.pg_namespace where nspname = 'sc_lims_dal') 
;


--************************************************************************************************************
--****   OPERATIONAL 
--************************************************************************************************************
--1.1.REQUEST
--1.2.REQUEST_DATA_TIME_INFO
--1.3.REQUEST_INFO_CARD
--1.4.REQUEST_INFO_CARD_HISTORY      (couldn't be created, isn't fully replicated) 
--1.5.REQUEST_INFO_CARD_HIST_DETAILS (couldn't be created, isn't fully replicated) 
--1.6.REQUEST_INFO_FIELD
--1.7.REQUEST_ANALYSIS_DETAILS       (couldn't be created, isn't fully replicated) 
--1.8.REQUEST_ATTRIBUTES
--1.9.REQUEST_HISTORY
--1.10.REQUEST_HIST_DETAILS          (couldn't be created, isn't fully replicated) 
--1.11.REQUEST_GROUP_KEY
--
--2.1.SAMPLE
--2.2.SAMPLE_GROUP_KEY
--2.3.SAMPLE_DATA_TIME_INFO
--2.4.SAMPLE_ATTRIBUTES
--2.5.SAMPLE_HISTORY
--2.6.SAMPLE_HIST_DETAILS            (couldn't be created, isn't fully replicated) 
--2.7.SAMPLE_INFO_CARD 
--2.8.SAMPLE_INFO_CARD_HISTORY       (couldn't be created, isn't fully replicated) 
--2.9.SAMPLE_INFO_CARD_HIST_DETAILS  (couldn't be created, isn't fully replicated) 
--2.10.SAMPLE_INFO_FIELD
--2.11.SAMPLE_PART_NO_INFO_CARD
--2.12.SAMPLE_PART_NO_GROUPKEY
--
--3.1.PARAMETER_GROUP
--3.2.PARAMETER_GROUP_DATA_TIME_INFO
--3.3.PARAMETER_GROUP_REANALYSIS      (is replicated, but table is empty) 
--3.4.PARAMETER_GROUP_ATTRIBUTES      
--3.5.PARAMETER_GROUP_HISTORY         (couldn't be created, isn't fully replicated) 
--3.6.PARAMETER_GROUP_HIST_DETAILS    (couldn't be created, isn't fully replicated) 
--   
--4.1.PARAMETER
--4.2.PARAMETER_DATA_TIME_INFO
--4.3.PARAMETER_SPECIFICATIONS
--4.4.PARAMETER_ATTRIBUTES
--4.5.PARAMETER_HISTORY
--4.6.PARAMETER_HIST_DETAILS           (couldn't be created, isn't fully replicated) 
--4.7.PARAMETER_REANALYSIS      
--
--5.1.METHOD
--5.2.METHOD_DATA_TIME_INFO
--5.3.METHOD_GROUP_KEY
--5.4.METHOD_ATTRIBUTES
--5.5.METHOD_HISTORY
--5.6.METHOD_HIST_DETAILS              (couldn't be created, isn't fully replicated) 
--5.7.METHOD_REANALYSIS      
--


--************************************************************************************************************
--1. requests
--************************************************************************************************************

--********************************************
--1.1.request
--********************************************
create or replace view sc_lims_dal.REQUEST
(request_code           
,sop                    
,responsible            
,label_format           
,priority               
,allow_new_samples      
,allow_any_sample_type  
,created_by             
,last_comment           
,description            
,version_description    
,version                
,request_type           
,life_cycle             
,life_cycle_description 
,status                 
,status_description     
)
as
select rq.rq
,      rq.descr_doc     
,      rq.responsible
,      rq.label_format
,      rq.priority
,      rq.allow_new_sc
,      rq.allow_any_st
,      rq.created_by
,      rq.last_comment
,      rq.description
,      rq.rt_version    
,      rq.rt_version
,      rq.rt
,      rq.lc
,      lc.description
,      rq.ss
,      ss.name
from sc_unilab_ens.utrq  rq
,    sc_unilab_ens.utss  ss
,    sc_unilab_ens.utlc  lc
where rq.ss = ss.ss
and   rq.lc = lc.lc
;

/*
create or replace view REQUEST
(request_code             --request-code
,sop                      --Standard Operational Procedure for request
,responsible              --Person responsible for the request
,label_format             --Label format used for printing request code
,priority                 --Priority of request
,allow_new_samples        --Flag indicating indicating whether it is allowed to add new samples to the request
,allow_any_sample_type    --Flag indicating indicating whether it is allowed to add other sample types than those assigned to the requesst type
,created_by               --Person who created the request
,last_comment             --Last comment of the Requests
,description              --Request description
,version_description      --Version Description of the Requests
,version                  --Version of the Requests
,request_type             --Request type
,life_cycle               --Life cycle that determines the request's status changes
,life_cycle_description              --life cycle description
,status                   --Status the request has reached in its life cycle
,status_description       --Status the request has reached in its life cycle (description)
)
select rq.rq
,      rq.descr_doc     --UNAPIGEN.sqlResultValue(UVRQ.DESCR_DOC,'')
,      rq.responsible
,      rq.label_format
,      rq.priority
,      rq.allow_new_sc
,      rq.allow_any_st
,      rq.created_by
,      rq.last_comment
,      rq.description
,      rq.rt_version    --DECODE( UNAPIGEN.IsSystem21CFR11Compliant ,'0',@Select(General Settings\Translation for Version)||UVRQ.RT_VERSION,'')
,      rq.rt_version
,      rq.rt
,      rq.lc
,      lc.description
,      rq.ss
,      ss.name
from utrq  rq
,    utss  ss
,    utlc  lc
where rq.ss = ss.ss
and   rq.lc = lc.lc
;
*/


--table-comment:
comment on VIEW sc_lims_dal.REQUEST is 'Contains all UNILAB-requests, with current revision only';

--column-comment:
comment on COLUMN sc_lims_dal.request.request_code            is 'request-code';
comment on COLUMN sc_lims_dal.request.sop                     is 'Standard Operational Procedure for request';
comment on COLUMN sc_lims_dal.request.responsible             is 'Person responsible for the request';
comment on COLUMN sc_lims_dal.request.label_format            is 'Label format used for printing request code';
comment on COLUMN sc_lims_dal.request.priority                is 'Priority of request';
comment on COLUMN sc_lims_dal.request.allow_new_samples       is 'Flag indicating indicating whether it is allowed to add new samples to the request';
comment on COLUMN sc_lims_dal.request.allow_any_sample_type   is 'Flag indicating indicating whether it is allowed to add other sample types than those assigned to the requesst type';
comment on COLUMN sc_lims_dal.request.created_by              is 'Person who created the request';
comment on COLUMN sc_lims_dal.request.last_comment            is 'Last comment of the Requests';
comment on COLUMN sc_lims_dal.request.description             is 'Request description';
comment on COLUMN sc_lims_dal.request.version_description     is 'Version Description of the Requests';
comment on COLUMN sc_lims_dal.request.version                 is 'Version of the Requests';
comment on COLUMN sc_lims_dal.request.request_type            is 'Request type';
comment on COLUMN sc_lims_dal.request.life_cycle              is 'Life cycle that determines the requests status changes';
comment on COLUMN sc_lims_dal.request.life_cycle_description  is 'life cycle description';
comment on COLUMN sc_lims_dal.request.status                  is 'Status the request has reached in its life cycle';
comment on COLUMN sc_lims_dal.request.status_description      is 'Status the request has reached in its life cycle (description)';



--************************************
--1.2.REQUEST_DATA_TIME_INFO
--************************************

create or replace view sc_lims_dal.REQUEST_DATA_TIME_INFO
(request_code                        --request-code
,sampling_date_in_local_tz           --Date on which the request (samples of the request) has been sampled, local-timezone
,sampling_date_in_original_tz        --Date on which the request (samples of the request) has been sampled, original-timezone
,creation_date_in_local_tz           --Date when the request was created, local-timezone
,creation_date_in_original_tz        --Date when the request was created, original-timezone
,exec_start_date_in_local_tz         --Date on which the analyses on the request started, local-timezone
,exec_start_date_in_original_tz      --Date on which the analyses on the request started, original-timezone
,exec_end_date_in_local_tz           --Date on which the analyses on the request finished, local-timezone
,exec_end_date_in_original_tz        --Date on which the analyses on the request finished, original-timezone
,due_date_in_local_tz                --Date on which the request should be finished, local-timezone
,due_date_in_original_tz             --Date on which the request should be finished, original-timezone
,date1_in_local_tz                   --date1, local-timezone
,date1_in_original_tz                --date1, original-timezone
,date2_in_local_tz                   --date2, local-timezone
,date2_in_original_tz                --date2, original-timezone
,date3_in_local_tz                   --date3, local-timezone
,date3_in_original_tz                --date3, original-timezone
,date4_in_local_tz                   --date4, local-timezone
,date4_in_original_tz                --date4, original-timezone
,date5_in_local_tz                   --date5, local-timezone
,date5_in_original_tz                --date5, original-timezone
)
as
SELECT rq.rq
,      rq.sampling_date
,      rq.sampling_date_tz           --to_char(@Select(Request Date & time info\rq.Sampling date in Original TZ),'tzr')
,      rq.creation_date
,      rq.creation_date_tz           --to_char(@Select(Request Date & time info\rq.Creation date in Original TZ),'tzr')
,      rq.exec_start_date
,      rq.exec_start_date_tz         --to_char(@Select(Request Date & time info\rq.Exec start date in Original TZ),'tzr')
,      rq.exec_end_date
,      rq.exec_end_date_tz           --to_char(@Select(Request Date & time info\rq.Exec end date in Original TZ),'tzr')
,      rq.due_date
,      rq.due_date_tz                --to_char(@Select(Request Date & time info\rq.Due date in Original TZ),'tzr')
,      rq.date1
,      rq.date1_tz                   --to_char(@Select(Request Date & time info\rq.Date1 in Original TZ),'tzr')
,      rq.date2
,      rq.date2_tz                   --to_char(@Select(Request Date & time info\rq.Date2 in Original TZ),'tzr')
,      rq.date3
,      rq.date3_tz                   --to_char(@Select(Request Date & time info\rq.Date3 in Original TZ),'tzr')
,      rq.date4
,      rq.date4_tz                   --to_char(@Select(Request Date & time info\rq.Date4 in Original TZ),'tzr')
,      rq.date5
,      rq.date5_tz                   --to_char(@Select(Request Date & time info\rq.Date5 in Original TZ),'tzr')
FROM sc_unilab_ens.UTRQ rq
;

--table-comment:
comment on VIEW sc_lims_dal.REQUEST_DATA_TIME_INFO is 'Contains all UNILAB-request-data-info-fields, with current revision only';

--column-comment:
comment on COLUMN sc_lims_dal.request_data_time_info.request_code                    is 'request-code';
comment on COLUMN sc_lims_dal.request_data_time_info.sampling_date_in_local_tz       is 'Date on which the request (samples of the request) has been sampled, local-timezone';
comment on COLUMN sc_lims_dal.request_data_time_info.sampling_date_in_original_tz    is 'Date on which the request (samples of the request) has been sampled, original-timezone';
comment on COLUMN sc_lims_dal.request_data_time_info.creation_date_in_local_tz       is 'Date when the request was created, local-timezone';
comment on COLUMN sc_lims_dal.request_data_time_info.creation_date_in_original_tz    is 'Date when the request was created, original-timezone';
comment on COLUMN sc_lims_dal.request_data_time_info.exec_start_date_in_local_tz     is 'Date on which the analyses on the request started, local-timezone';
comment on COLUMN sc_lims_dal.request_data_time_info.exec_start_date_in_original_tz  is 'Date on which the analyses on the request started, original-timezone';
comment on COLUMN sc_lims_dal.request_data_time_info.exec_end_date_in_local_tz       is 'Date on which the analyses on the request finished, local-timezone';
comment on COLUMN sc_lims_dal.request_data_time_info.exec_end_date_in_original_tz    is 'Date on which the analyses on the request finished, original-timezone';
comment on COLUMN sc_lims_dal.request_data_time_info.due_date_in_local_tz            is 'Date on which the request should be finished, local-timezone';
comment on COLUMN sc_lims_dal.request_data_time_info.due_date_in_original_tz         is 'Date on which the request should be finished, original-timezone';
comment on COLUMN sc_lims_dal.request_data_time_info.date1_in_local_tz               is 'date1, local-timezone';
comment on COLUMN sc_lims_dal.request_data_time_info.date1_in_original_tz            is 'date1, original-timezone';
comment on COLUMN sc_lims_dal.request_data_time_info.date2_in_local_tz               is 'date2, local-timezone';
comment on COLUMN sc_lims_dal.request_data_time_info.date2_in_original_tz            is 'date2, original-timezone';
comment on COLUMN sc_lims_dal.request_data_time_info.date3_in_local_tz               is 'date3, local-timezone';
comment on COLUMN sc_lims_dal.request_data_time_info.date3_in_original_tz            is 'date3, original-timezone';
comment on COLUMN sc_lims_dal.request_data_time_info.date4_in_local_tz               is 'date4, local-timezone';
comment on COLUMN sc_lims_dal.request_data_time_info.date4_in_original_tz            is 'date4, original-timezone';
comment on COLUMN sc_lims_dal.request_data_time_info.date5_in_local_tz               is 'date5, local-timezone';
comment on COLUMN sc_lims_dal.request_data_time_info.date5_in_original_tz            is 'date5, original-timezone';



--************************************
--1.3.REQUEST_INFO_CARD
--************************************

create or replace view sc_lims_dal.REQUEST_INFO_CARD
(request_code                        --request-code
,info_card                           --Requests info card
,info_card_node                      --Node of the request's info card (specifying the order of the request's info cards within the request)
,protected                           --Flag indicating whether the request's info card is read-only for the user
,hidden                              --Flag indicating whether the request's info card is visible to the user
,manually_added                      --Flag indicating whether the request's info card has been added manually to the request or by the system (assign. frequencies)
,description                         --Description of request's info card
,life_cycle                          --Life cycle that determines the request's info card's status changes
,life_cycle_description              --life cycle description
,status                              --Status the request's info card has reached in its life cycle
,status_description                  --Status the request's info card has reached in its life cycle (description)
)
as
select ic.rq
,      ic.ic
,      ic.icnode
,      ic.is_protected
,      ic.hidden
,      ic.manually_added
,      ic.description
,      ic.lc
,      lc.description
,      ic.ss
,      ss.name
from sc_unilab_ens.utrqic  ic
,    sc_unilab_ens.utss    ss
,    sc_unilab_ens.utlc    lc
where ic.ss = ss.ss
and   ic.lc = lc.lc
;

--table-comment:
comment on VIEW sc_lims_dal.REQUEST_INFO_CARD is 'Contains all UNILAB-request info-card fields, with current revision only';

--column-comment:
comment on COLUMN sc_lims_dal.request_info_card.request_code                    is 'request-code';
comment on COLUMN sc_lims_dal.request_info_card.info_card                       is 'Requests info card';
comment on COLUMN sc_lims_dal.request_info_card.info_card_node                  is 'Node of the requests info card (specifying the order of the requests info cards within the request)';
comment on COLUMN sc_lims_dal.request_info_card.protected                       is 'Flag indicating whether the request info card is read-only for the user';
comment on COLUMN sc_lims_dal.request_info_card.hidden                          is 'Flag indicating whether the request info card is visible to the user';
comment on COLUMN sc_lims_dal.request_info_card.manually_added                  is 'Flag indicating whether the request info card has been added manually to the request or by the system (assign. frequencies)';
comment on COLUMN sc_lims_dal.request_info_card.description                     is 'Description of requests info card';
comment on COLUMN sc_lims_dal.request_info_card.life_cycle                      is 'Life cycle that determines the requests info cards status changes';
comment on COLUMN sc_lims_dal.request_info_card.life_cycle_description          is 'life cycle description';
comment on COLUMN sc_lims_dal.request_info_card.status                          is 'Status the requests info card has reached in its life cycle';
comment on COLUMN sc_lims_dal.request_info_card.status_description              is 'Status the requests info card has reached in its life cycle (description)';

/*
--************************************
--1.4.REQUEST_INFO_CARD_HISTORY (kon niet worden aangemaakt)
--************************************
--TABEL UTRQICHS WORDT NIET GESYNCHRONISEERD NAAR AWS DD. 10-05-2022 !!!!!!!

create or replace view sc_lims_dal.REQUEST_INFO_CARD_HISTORY
(request_code                        --request-code
,info_card                           --Requests info card
,info_card_node                      --Node of the request's info card (specifying the order of the request's info cards within the request)
,what                                --What of the Request Info Card History
,why                                 --Why of the Request Info Card History
,who                                 --Who of the Request Info Card History
,logdate_in_local_tz                 --Logdate of the Request Info Card History
,logdate_in_original_tz              --Logdate of the Request Info Card History
,transaction                         --Transaction of the Request Info Card History Details
,event                               --Event of the Request Info Card History Details
)
as
select ichs.rq
,      ichs.ic
,      ichs.icnode
,      ichs.what_description
,      ichs.why
,      ichs.who_description
,      ichs.logdate
,      ichs.logdate_tz                 --to_char(@Select(Request Info Card History\rqichs.Logdate in Original TZ),'tzr')
,      ichs.tr_seq
,      ichs.ev_seq
from sc_unilab_ens.utrqichs  ichs
;

--table-comment:
comment on VIEW sc_lims_dal.request_info_card_history is 'Contains all UNILAB-request history from info-card fields';

--column-comment:
comment on COLUMN sc_lims_dal.request_info_card_history.request_code                    is 'request-code';
comment on COLUMN sc_lims_dal.request_info_card_history.info_card                       is 'Requests info card';
comment on COLUMN sc_lims_dal.request_info_card_history.info_card_node                  is 'Node of the requests info card (specifying the order of the requests info cards within the request)';
comment on COLUMN sc_lims_dal.request_info_card_history.what                            is 'What of the Request Info Card History';
comment on COLUMN sc_lims_dal.request_info_card_history.why                             is 'Why of the Request Info Card History';
comment on COLUMN sc_lims_dal.request_info_card_history.who                             is 'Who of the Request Info Card History';
comment on COLUMN sc_lims_dal.request_info_card_history.logdate_in_local_tz             is 'Logdate of the Request Info Card History';
comment on COLUMN sc_lims_dal.request_info_card_history.logdate_in_original_tz          is 'Logdate of the Request Info Card History';
comment on COLUMN sc_lims_dal.request_info_card_history.transaction                     is 'Transaction of the Request Info Card History Details';
comment on COLUMN sc_lims_dal.request_info_card_history.event                           is 'Event of the Request Info Card History Details';
*/


/*
--************************************
--1.5.REQUEST_INFO_CARD_HIST_DETAILS (kon niet worden aangemaakt)
--************************************
--TABEL UTRQICHSDETAILS WORDT NIET GESYNCHRONISEERD NAAR AWS DD. 10-05-2022 !!!!!!!

create or replace view sc_lims_dal.REQUEST_INFO_CARD_HIST_DETAILS
(request_code                        --request-code
,info_card                           --Requests info card
,info_card_node                      --Node of the request's info card (specifying the order of the request's info cards within the request)
,transaction                         --Transaction of the Request Info Card History Details
,event                               --Event of the Request Info Card History Details
,sequence                            --
,details                             --Details of the Request Info Card History Details
)
as
select ichsd.rq
,      ichsd.ic
,      ichsd.icnode
,      ichsd.tr_seq
,      ichsd.ev_seq
,      ichsd.seq
,      ichsd.details
from sc_unilab_ens.utrqichsdetails  ichsd
;
--table-comment:
comment on VIEW sc_lims_dal.request_info_card_hist_details is 'Contains all UNILAB-request history-details from info-card fields';

--column-comment:
comment on COLUMN sc_lims_dal.request_info_card_hist_details.request_code                    is 'request-code';
comment on COLUMN sc_lims_dal.request_info_card_hist_details.info_card                       is 'Requests info card';
comment on COLUMN sc_lims_dal.request_info_card_hist_details.info_card_node                  is 'Node of the requests info card (specifying the order of the requests info cards within the request)';
comment on COLUMN sc_lims_dal.request_info_card_hist_details.transaction                     is 'Transaction of the Request Info Card History Details';
comment on COLUMN sc_lims_dal.request_info_card_hist_details.event                           is 'Event of the Request Info Card History Details';
comment on COLUMN sc_lims_dal.request_info_card_hist_details.sequence                        is 'sequence-nummer';
comment on COLUMN sc_lims_dal.request_info_card_hist_details.details                         is 'Details of the Request Info Card History Details';
*/


--************************************
--1.6.REQUEST_INFO_FIELD
--
-- 30-10-2023: OUTER-JOIN Ingebouwd omdat er vanuit INFO-FIELD status + lifecycle null kunnen zijn !!!
--************************************

create or replace view sc_lims_dal.REQUEST_INFO_FIELD
(request_code                        --request-code
,info_card                           --Requests info card
,info_card_node                      --Node of the request's info card (specifying the order of the request's info cards within the request)
,info_field                          --Requests info field
,info_field_node                     --Node of the request's info field (specifying the order of the request's info field within the request's info card)
,position_x                          --X position of the request's info field within the request's info card
,postition_y                         --Y position of the request's info field within the request's info card
,protected                           --Flag indicating whether the request's info field is read-only for the user
,hidden                              --Flag indicating whether the request's info field is visible to the user
,display_type                        --Specification of the type of the request's info field (input field, text box,  combo box, drop down list box, check box, document link)
,mandatory                           --Flag indicating whether the request's info field is mandatory to be filled in
,title                               --Request's info field title
,value                               --Value of the request's info field
,result_value                        --
,life_cycle                          --Life cycle that determines the request's info field status changes
,life_cycle_description              --life cycle description
,status                              --Status the request's info field has reached in its life cycle
,status_description                  --Status the request's info field has reached in its life cycle (description)
)
as
select ii.rq
,      ii.ic
,      ii.icnode
,      ii.ii
,      ii.iinode
,      ii.pos_x
,      ii.pos_y
,      ii.is_protected
,      ii.hidden
,      ii.dsp_tp
,      ii.mandatory
,      ii.dsp_title
,      ii.iivalue
,      ii.iivalue                     --UNAPIGEN.sqlResultValue(UVRQII.IIVALUE,'')
,      ii.lc
,      lc.description
,      ii.ss
,      ss.name
from sc_unilab_ens.utrqii  ii
LEFT OUTER JOIN  sc_unilab_ens.utss  ss  on ss.ss = ii.ss
LEFT OUTER JOIN  sc_unilab_ens.utlc  lc  on lc.lc = ii.lc
;

--table-comment:
comment on VIEW sc_lims_dal.request_info_field is 'Contains all UNILAB-request info-fields';

--column-comment:
comment on COLUMN sc_lims_dal.request_info_field.request_code                    is 'request-code';
comment on COLUMN sc_lims_dal.request_info_field.info_card                       is 'Requests info card';
comment on COLUMN sc_lims_dal.request_info_field.info_card_node                  is 'Node of the requests info card (specifying the order of the requests info cards within the request)';
comment on COLUMN sc_lims_dal.request_info_field.info_field                      is 'Requests info field';
comment on COLUMN sc_lims_dal.request_info_field.info_field_node                 is 'Node of the requests info field (specifying the order of the requests info field within the requests info card)';
comment on COLUMN sc_lims_dal.request_info_field.position_x                      is 'X position of the requests info field within the requests info card';
comment on COLUMN sc_lims_dal.request_info_field.postition_y                     is 'Y position of the requests info field within the requests info card';
comment on COLUMN sc_lims_dal.request_info_field.protected                       is 'Flag indicating whether the requests info field is read-only for the user';
comment on COLUMN sc_lims_dal.request_info_field.hidden                          is 'Flag indicating whether the requests info field is visible to the user';
comment on COLUMN sc_lims_dal.request_info_field.display_type                    is 'Specification of the type of the requests info field (input field, text box,  combo box, drop down list box, check box, document link)';
comment on COLUMN sc_lims_dal.request_info_field.mandatory                       is 'Flag indicating whether the requests info field is mandatory to be filled in';
comment on COLUMN sc_lims_dal.request_info_field.title                           is 'Requests info field title';
comment on COLUMN sc_lims_dal.request_info_field.value                           is 'Value of the requests info field';
comment on COLUMN sc_lims_dal.request_info_field.result_value                    is 'Result';
comment on COLUMN sc_lims_dal.request_info_field.life_cycle                      is 'Life cycle that determines the requests info field status changes';
comment on COLUMN sc_lims_dal.request_info_field.life_cycle_description          is 'life cycle description';
comment on COLUMN sc_lims_dal.request_info_field.status                          is 'Status the requests info field has reached in its life cycle';
comment on COLUMN sc_lims_dal.request_info_field.status_description              is 'Status the requests info field has reached in its life cycle (description)';


/*
--************************************
--1.7.REQUEST_ANALYSIS_DETAILS (kon niet worden aangemaakt)
--************************************
--TABEL UTRQSC WORDT NIET GESYNCHRONISEERD NAAR AWS DD. 10-05-2022 !!!!!!!

create or replace view sc_lims_dal.REQUEST_ANALYSIS_DETAILS
(request_code                        --request-code
,sample_type                         --sample_type
,samplecode                          --Sample code of the sample within the request
,node                                --Node of the sample (specifying the order of the sample within the request)
,assigned_by                         --Person who assigned the sample to the request
,assign_date_in_local_tz             --Date on which the sample has been assigned to the request
,assign_date_in_original_tz          --Date on which the sample has been assigned to the request
)
as
SELECT rqsc.rq
,      sc.description         -->dit is niet sample-type, maar sample-description !!!
,      rqsc.sc
,      rqsc.seq
,      rqsc.assigned_by
,      rqsc.assign_date
,      rqsc.assign_date_tz           --to_char(@Select(Request analysis details\rqsc.Assign date in Original TZ),'tzr')
from sc_unilab_ens.utrqsc rqsc
,    sc_unilab_ens.utsc   sc
where sc.sc = rqsc.sc
;

--table-comment:
comment on VIEW sc_lims_dal.request_analysis_details is 'Contains all UNILAB-request, current-version only, with all related Request-samples, all statusses';

--column-comment:
comment on COLUMN sc_lims_dal.request_analysis_details.request_code                    is 'request-code';
comment on COLUMN sc_lims_dal.request_analysis_details.sample_type                     is 'sample_type';
comment on COLUMN sc_lims_dal.request_analysis_details.samplecode                      is 'Sample code of the sample within the request';
comment on COLUMN sc_lims_dal.request_analysis_details.node                            is 'Node of the sample (specifying the order of the sample within the request)';
comment on COLUMN sc_lims_dal.request_analysis_details.assigned_by                     is 'Person who assigned the sample to the request';
comment on COLUMN sc_lims_dal.request_analysis_details.assign_date_in_local_tz         is 'Date on which the sample has been assigned to the request';
comment on COLUMN sc_lims_dal.request_analysis_details.assign_date_in_original_tz      is 'Date on which the sample has been assigned to the request';

*/


--************************************
--1.8.REQUEST_ATTRIBUTES
--************************************

create or replace view sc_lims_dal.REQUEST_ATTRIBUTES
(request_code                        --request-code
,attribute                           --Attribute of the Request attributes
,attribute_value                     --Attribute value of the Request attributes
)
as
select rqau.rq
,      rqau.au
,      rqau.value
from sc_unilab_ens.utrqau rqau
;

--table-comment:
comment on VIEW sc_lims_dal.request_attributes is 'Contains all UNILAB-request-attributes';

--column-comment:
comment on COLUMN sc_lims_dal.request_attributes.request_code                    is 'request-code';
comment on COLUMN sc_lims_dal.request_attributes.attribute                       is 'Attribute of the Request attributes';
comment on COLUMN sc_lims_dal.request_attributes.attribute_value                 is 'Attribute value of the Request attributes';


--************************************
--1.9.REQUEST_HISTORY
--************************************

create or replace view sc_lims_dal.REQUEST_HISTORY
(request_code                        --request-code
,what                                --What of the Request history
,why                                 --Why of the Request History
,who                                 --Who of the Request History
,logdate_in_local_tz                 --Logdate of the Request History
,logdate_in_original_tz              --Logdate of the Request History
,transaction                         --Transaction of the Request History Details
,event                               --Event of the Request History Details
)
as
select rqhs.rq
,      rqhs.what_description
,      rqhs.why
,      rqhs.who_description
,      rqhs.logdate
,      rqhs.logdate_tz                 --to_char(@Select(Request History\rqhs.Logdate in Original TZ),'tzr')
,      rqhs.tr_seq
,      rqhs.ev_seq
from sc_unilab_ens.utrqhs  rqhs
;

--table-comment:
comment on VIEW sc_lims_dal.request_history is 'Contains all UNILAB-request-history';

--column-comment:
comment on COLUMN sc_lims_dal.request_history.request_code                    is 'request-code';
comment on COLUMN sc_lims_dal.request_history.what                            is 'What of the Request history';
comment on COLUMN sc_lims_dal.request_history.why                             is 'Why of the Request History';
comment on COLUMN sc_lims_dal.request_history.who                             is 'Who of the Request History';
comment on COLUMN sc_lims_dal.request_history.logdate_in_local_tz             is 'Logdate of the Request History';
comment on COLUMN sc_lims_dal.request_history.logdate_in_original_tz          is 'Logdate of the Request History';
comment on COLUMN sc_lims_dal.request_history.transaction                     is 'Transaction of the Request History Details';
comment on COLUMN sc_lims_dal.request_history.event                           is 'Event of the Request History Details';


/*
--************************************
--1.10.REQUEST_HIST_DETAILS (kan niet worden aangemaakt.
--************************************
--TABEL utrqhsdetails WORDT NIET GESYNCHRONISEERD NAAR AWS DD. 10-05-2022 !!!!!!!

create or replace view sc_lims_dal.REQUEST_HIST_DETAILS
(request_code                        --request-code
,transaction                         --Transaction of the Request History Details
,event                               --Event of the Request History Details
,sequence                            --
,details                             --Details of the Request History Details
)
as
select rqhsd.rq
,      rqhsd.ic
,      rqhsd.icnode
,      rqhsd.tr_seq
,      rqhsd.ev_seq
,      rqhsd.seq
,      rqhsd.details
from sc_unilab_ens.utrqhsdetails  rqhsd
;
--table-comment:
comment on VIEW sc_lims_dal.request_hist_details is 'Contains all UNILAB-request-history-details';

--column-comment:
comment on COLUMN sc_lims_dal.request_hist_details.request_code                    is 'request-code';
comment on COLUMN sc_lims_dal.request_hist_details.transaction                     is 'Transaction of the Request History Details';
comment on COLUMN sc_lims_dal.request_hist_details.event                           is 'Event of the Request History Details';
comment on COLUMN sc_lims_dal.request_hist_details.sequence                        is 'sequence-number';
comment on COLUMN sc_lims_dal.request_hist_details.details                         is 'Details of the Request History Details';
*/

--************************************
--1.11.REQUEST_GROUP_KEY
--************************************

create or replace view sc_lims_dal.REQUEST_GROUP_KEY
(request_code                        --request-code
,group_key                           --group-keys
,value                               --group-key value
)
as
select rqgk.rq
,      rqgk.gk
,      rqgk.value
from sc_unilab_ens.utrqgk rqgk
;

--table-comment:
comment on VIEW sc_lims_dal.request_group_key is 'Contains all UNILAB-request-group-keys';

--column-comment:
comment on COLUMN sc_lims_dal.request_group_key.request_code                    is 'request-code';
comment on COLUMN sc_lims_dal.request_group_key.group_key                       is 'group-keys';
comment on COLUMN sc_lims_dal.request_group_key.value                           is 'group-key value';




--***********************************************************************************************************
--****   2.SAMPLES
--***********************************************************************************************************


--**********************************
--2.1.SAMPLE
--**********************************

create or replace view sc_lims_dal.SAMPLE
(sample_code              --sample-code
,request_code             --Request-code of the Samples
,allow_modify             --allow modify
,sop                      --Standard Operational Procedure for SAMPLE
,label_format             --Label format used for printing samples
,priority                 --Priority of sample
,last_comment             --Last comment of the sample
,description              --Sample code description
,created_by               --Person who created the sample
,version_description      --Version Description of the samples
,version                  --Version of the samples
,sample_type              --Sample type
,shelf_life_unit          --Shelf life unit of the Samples
,shell_life_value         --Shelf life value of the Samples
,life_cycle               --Life cycle that determines the request's status changes
,life_cycle_description   --life cycle description
,status                   --Status the sample has reached in its life cycle
,status_description       --Status the sample has reached in its life cycle (description)
)
as
select sc.sc
,      sc.rq
,      sc.allow_modify
,      sc.descr_doc     --UNAPIGEN.sqlResultValue(UVSC.DESCR_DOC,'')
,      sc.label_format
,      sc.priority
,      sc.last_comment
,      sc.description
,      sc.created_by 
,      sc.st_version    --DECODE( UNAPIGEN.IsSystem21CFR11Compliant ,'0',@Select(General Settings\Translation for Version)||UVSC.ST_VERSION,'')
,      sc.st_version
,      sc.st
,      sc.shelf_life_unit
,      sc.shelf_life_val
,      sc.lc
,      lc.description
,      sc.ss
,      ss.name
from sc_unilab_ens.utsc  sc
,    sc_unilab_ens.utss  ss
,    sc_unilab_ens.utlc  lc
where sc.ss = ss.ss
and   sc.lc = lc.lc
;

--table-comment:
comment on VIEW sc_lims_dal.sample is 'Contains all UNILAB-SAMPLE, current revision only, all statusses';

--column-comment:
comment on COLUMN sc_lims_dal.sample.sample_code            is 'sample-code';
comment on COLUMN sc_lims_dal.sample.request_code           is 'Request-code of the Samples';
comment on COLUMN sc_lims_dal.sample.allow_modify           is 'allow modify';
comment on COLUMN sc_lims_dal.sample.sop                    is 'Standard Operational Procedure for SAMPLE';
comment on COLUMN sc_lims_dal.sample.label_format           is 'Label format used for printing samples';
comment on COLUMN sc_lims_dal.sample.priority               is 'Priority of sample';
comment on COLUMN sc_lims_dal.sample.last_comment           is 'Last comment of the sample';
comment on COLUMN sc_lims_dal.sample.description            is 'Sample code description';
comment on COLUMN sc_lims_dal.sample.created_by             is 'Person who created the sample';
comment on COLUMN sc_lims_dal.sample.version_description    is 'Version Description of the samples';
comment on COLUMN sc_lims_dal.sample.version                is 'Version of the samples';
comment on COLUMN sc_lims_dal.sample.sample_type            is 'Sample type';
comment on COLUMN sc_lims_dal.sample.shelf_life_unit        is 'Shelf life unit of the Samples';
comment on COLUMN sc_lims_dal.sample.shell_life_value       is 'Shelf life value of the Samples';
comment on COLUMN sc_lims_dal.sample.life_cycle             is 'Life cycle that determines the requests status changes';
comment on COLUMN sc_lims_dal.sample.life_cycle_description is 'life cycle description';
comment on COLUMN sc_lims_dal.sample.status                 is 'Status the sample has reached in its life cycle';
comment on COLUMN sc_lims_dal.sample.status_description     is 'Status the sample has reached in its life cycle (description)';


--**********************************
--2.2.SAMPLE_GROUP_KEY
--**********************************

create or replace view sc_lims_dal.SAMPLE_GROUP_KEY
(sample_code                         --sample-code
,group_key                           --group-keys
,group_key_sequence                  --group-key-sequence 
,value                               --group-key value
)
as
select scgk.sc
,      scgk.gk
,      scgk.gkseq
,      scgk.value
from sc_unilab_ens.utscgk scgk
;

--table-comment:
comment on VIEW sc_lims_dal.sample_group_key is 'Contains all UNILAB-SAMPLE group-keys';

--column-comment:
comment on COLUMN sc_lims_dal.sample_group_key.sample_code            is 'sample-code';
comment on COLUMN sc_lims_dal.sample_group_key.group_key              is 'group-keys';
comment on COLUMN sc_lims_dal.sample_group_key.group_key_sequence     is 'group-key-sequence';
comment on COLUMN sc_lims_dal.sample_group_key.value                  is 'group-key value';



--**********************************
--2.3.SAMPLE_DATA_TIME_INFO
--**********************************

create or replace view sc_lims_dal.SAMPLE_DATA_TIME_INFO
(sample_code                         --sample-code
,sampling_date_in_local_tz           --Sampling date of the Date & time info, local-timezone
,sampling_date_in_original_tz        --Sampling date of the Date & time info, original-timezone
,creation_date_in_local_tz           --Date when the sample was created, local-timezone
,creation_date_in_original_tz        --Date when the sample was created, original-timezone
,exec_start_date_in_local_tz         --Date on which the analyses on the sample started, local-timezone
,exec_start_date_in_original_tz      --Date on which the analyses on the sample started, original-timezone
,exec_end_date_in_local_tz           --Date on which the analyses on the sample finished, local-timezone
,exec_end_date_in_original_tz        --Date on which the analyses on the sample finished, original-timezone
,date1_in_local_tz                   --date1, local-timezone
,date1_in_original_tz                --date1, original-timezone
,date2_in_local_tz                   --date2, local-timezone
,date2_in_original_tz                --date2, original-timezone
,date3_in_local_tz                   --date3, local-timezone
,date3_in_original_tz                --date3, original-timezone
,date4_in_local_tz                   --date4, local-timezone
,date4_in_original_tz                --date4, original-timezone
,date5_in_local_tz                   --date5, local-timezone
,date5_in_original_tz                --date5, original-timezone
,duration_exec_start_creation        --Time difference of the Exec Start Date - Creation Date
,duration_exec_end_start             --Time difference of the Exec End Date - Exec Start Date
,duration_exec_end_creation          --Time difference of the Exec End Date - Creation Date
)
as
SELECT sc.sc
,      sc.sampling_date
,      sc.sampling_date_tz           --to_char(@Select(Date & time info\rq.Sampling date in Original TZ),'tzr')
,      sc.creation_date
,      sc.creation_date_tz           --to_char(@Select(Date & time info\rq.Creation date in Original TZ),'tzr')
,      sc.exec_start_date
,      sc.exec_start_date_tz         --to_char(@Select(Date & time info\rq.Exec start date in Original TZ),'tzr')
,      sc.exec_end_date
,      sc.exec_end_date_tz           --to_char(@Select(Date & time info\rq.Exec end date in Original TZ),'tzr')
,      sc.date1
,      sc.date1_tz                   --to_char(@Select(Date & time info\rq.Date1 in Original TZ),'tzr')
,      sc.date2
,      sc.date2_tz                   --to_char(@Select(Date & time info\rq.Date2 in Original TZ),'tzr')
,      sc.date3
,      sc.date3_tz                   --to_char(@Select(Date & time info\rq.Date3 in Original TZ),'tzr')
,      sc.date4
,      sc.date4_tz                   --to_char(@Select(Date & time info\rq.Date4 in Original TZ),'tzr')
,      sc.date5
,      sc.date5_tz                   --to_char(@Select(Date & time info\rq.Date5 in Original TZ),'tzr')
,      (sc.exec_start_date - sc.creation_date) 
,      (sc.exec_end_date - sc.exec_start_date) 
,      (sc.exec_end_date - sc.creation_date) 
FROM sc_unilab_ens.UTSC sc
;

--table-comment:
comment on VIEW sc_lims_dal.sample_data_time_info is 'Contains all UNILAB-SAMPLE related DATE-info, current revision only, all statusses';

--column-comment:
comment on COLUMN sc_lims_dal.sample_data_time_info.sample_code     is 'sample-code';
comment on COLUMN sc_lims_dal.sample_data_time_info.sampling_date_in_local_tz        is 'Sampling date of the Date & time info, local-timezone';
comment on COLUMN sc_lims_dal.sample_data_time_info.sampling_date_in_original_tz     is 'Sampling date of the Date & time info, original-timezone';
comment on COLUMN sc_lims_dal.sample_data_time_info.creation_date_in_local_tz        is 'Date when the sample was created, local-timezone';
comment on COLUMN sc_lims_dal.sample_data_time_info.creation_date_in_original_tz     is 'Date when the sample was created, original-timezone';
comment on COLUMN sc_lims_dal.sample_data_time_info.exec_start_date_in_local_tz      is 'Date on which the analyses on the sample started, local-timezone';
comment on COLUMN sc_lims_dal.sample_data_time_info.exec_start_date_in_original_tz   is 'Date on which the analyses on the sample started, original-timezone';
comment on COLUMN sc_lims_dal.sample_data_time_info.exec_end_date_in_local_tz        is 'Date on which the analyses on the sample finished, local-timezone';
comment on COLUMN sc_lims_dal.sample_data_time_info.exec_end_date_in_original_tz     is 'Date on which the analyses on the sample finished, original-timezone';
comment on COLUMN sc_lims_dal.sample_data_time_info.date1_in_local_tz                is 'date1, local-timezone';
comment on COLUMN sc_lims_dal.sample_data_time_info.date1_in_original_tz             is 'date1, original-timezone';
comment on COLUMN sc_lims_dal.sample_data_time_info.date2_in_local_tz                is 'date2, local-timezone';
comment on COLUMN sc_lims_dal.sample_data_time_info.date2_in_original_tz             is 'date2, original-timezone';
comment on COLUMN sc_lims_dal.sample_data_time_info.date3_in_local_tz                is 'date3, local-timezone';
comment on COLUMN sc_lims_dal.sample_data_time_info.date3_in_original_tz             is 'date3, original-timezone';
comment on COLUMN sc_lims_dal.sample_data_time_info.date4_in_local_tz                is 'date4, local-timezone';
comment on COLUMN sc_lims_dal.sample_data_time_info.date4_in_original_tz             is 'date4, original-timezone';
comment on COLUMN sc_lims_dal.sample_data_time_info.date5_in_local_tz                is 'date5, local-timezone';
comment on COLUMN sc_lims_dal.sample_data_time_info.date5_in_original_tz             is 'date5, original-timezone';
comment on COLUMN sc_lims_dal.sample_data_time_info.duration_exec_start_creation     is 'Time difference of the Exec Start Date - Creation Date';
comment on COLUMN sc_lims_dal.sample_data_time_info.duration_exec_end_start          is 'Time difference of the Exec End Date - Exec Start Date';
comment on COLUMN sc_lims_dal.sample_data_time_info.duration_exec_end_creation       is 'Time difference of the Exec End Date - Creation Date';


--**********************************
--2.4.SAMPLE_ATTRIBUTES
--**********************************

create or replace view sc_lims_dal.SAMPLE_ATTRIBUTES
(sample_code                         --sample-code
,attribute                           --Attribute of the sample attributes
,sequence                            --/Sequence of the Sample attributes
,attribute_value                     --Attribute value of the sample attributes
)
as
select scau.sc
,      scau.au
,      scau.auseq
,      scau.value
from sc_unilab_ens.utscau scau
;

--table-comment:
comment on VIEW sc_lims_dal.sample_attributes is 'Contains all UNILAB-SAMPLE related attributes, current revision only, all statusses';

--column-comment:
comment on COLUMN sc_lims_dal.sample_attributes.sample_code     is 'sample-code';
comment on COLUMN sc_lims_dal.sample_attributes.attribute       is 'Attribute of the sample attributes';
comment on COLUMN sc_lims_dal.sample_attributes.sequence        is 'Sequence of the Sample attributes';
comment on COLUMN sc_lims_dal.sample_attributes.attribute_value is 'Attribute value of the sample attributes';


--**********************************
--2.5.SAMPLE_HISTORY
--**********************************

create or replace view sc_lims_dal.SAMPLE_HISTORY
(sample_code                         --sample-code
,what                                --What of the sample history
,why                                 --Why of the sample History
,who                                 --Who of the sample History
,logdate_in_local_tz                 --Logdate of the sample History
,logdate_in_original_tz              --Logdate of the sample History
,transaction                         --Transaction of the sample History Details
,event                               --Event of the sample History Details
)
as
select schs.sc
,      schs.what_description
,      schs.why
,      schs.who_description
,      schs.logdate
,      schs.logdate_tz                 --to_char(@Select(Request History\rqhs.Logdate in Original TZ),'tzr')
,      schs.tr_seq
,      schs.ev_seq
from sc_unilab_ens.utschs  schs
;

--table-comment:
comment on VIEW sc_lims_dal.sample_history is 'Contains all UNILAB-SAMPLE mutation history logging';

--column-comment:
comment on COLUMN sc_lims_dal.sample_history.sample_code             is 'sample-code';
comment on COLUMN sc_lims_dal.sample_history.what                    is 'What of the sample history';
comment on COLUMN sc_lims_dal.sample_history.why                     is 'Why of the sample History';
comment on COLUMN sc_lims_dal.sample_history.who                     is 'Who of the sample History';
comment on COLUMN sc_lims_dal.sample_history.logdate_in_local_tz     is 'Logdate of the sample History';
comment on COLUMN sc_lims_dal.sample_history.logdate_in_original_tz  is 'Logdate of the sample History';
comment on COLUMN sc_lims_dal.sample_history.transaction             is 'Transaction of the sample History Details';
comment on COLUMN sc_lims_dal.sample_history.event                   is 'Event of the sample History Details';

/*
--**********************************
--2.6.SAMPLE_HIST_DETAILS (kan niet worden aangemaakt)
--**********************************
--TABEL utschsdetails WORDT NIET GESYNCHRONISEERD NAAR AWS DD. 10-05-2022 !!!!!!!

create or replace view sc_lims_dal.SAMPLE_HIST_DETAILS
(sample_code                         --sample-code
,transaction                         --Transaction of the sample History Details
,event                               --Event of the sample History Details
,sequence                            --sequence-number
,details                             --Details of the SAMPLE History Details
)
as
select schsd.sc
,      schsd.tr_seq
,      schsd.ev_seq
,      schsd.seq
,      schsd.details
from sc_unilab_ens.utschsdetails  schsd
;
--table-comment:
comment on VIEW sc_lims_dal.SAMPLE_HIST_DETAILS is 'Contains all UNILAB-SAMPLE mutation history logging details';

--column-comment:
comment on COLUMN sc_lims_dal.SAMPLE_HIST_DETAILS.sample_code             is 'sample-code';
comment on COLUMN sc_lims_dal.SAMPLE_HIST_DETAILS.transaction             is 'Transaction of the sample History Details';
comment on COLUMN sc_lims_dal.SAMPLE_HIST_DETAILS.event                   is 'Event of the sample History Details';
comment on COLUMN sc_lims_dal.SAMPLE_HIST_DETAILS.sequence                is 'sequence-number';
comment on COLUMN sc_lims_dal.SAMPLE_HIST_DETAILS.details                 is 'Details of the SAMPLE History Details';
*/

--**********************************
--2.7.SAMPLE_INFO_CARD 
--**********************************

create or replace view sc_lims_dal.SAMPLE_INFO_CARD
(sample_code                         --SAMPle-code
,info_card                           --sample info card
,info_card_node                      --Node of the sample's info card (specifying the order of the sample's info cards within the request)
,protected                           --Flag indicating whether the sample's info card is read-only for the user
,hidden                              --Flag indicating whether the sample's info card is visible to the user
,manually_added                      --Flag indicating whether the sample's info card has been added manually to the sample or by the system (assign. frequencies)
,last_comment                        --Last comment of the Info cards
,description                         --Description of sample's info card
,version_description                 --Version Description of the Info cards
,version                             --/Version of the Info cards
,life_cycle                          --Life cycle that determines the sample's info card's status changes
,life_cycle_description              --life cycle description
,status                              --Status the sample's info card has reached in its life cycle
,status_description                  --Status the sample's info card has reached in its life cycle (description)
)
as
select ic.sc
,      ic.ic
,      ic.icnode
,      ic.is_protected
,      ic.hidden
,      ic.manually_added
,      ic.last_comment
,      ic.description
,      ic.ip_version                 --DECODE( UNAPIGEN.IsSystem21CFR11Compliant ,'0',@Select(General Settings\Translation for Version)||UVSCIC.IP_VERSION,'')
,      ic.ip_version 
,      ic.lc
,      lc.description
,      ic.ss
,      ss.name
from sc_unilab_ens.utscic  ic
,    sc_unilab_ens.utss    ss
,    sc_unilab_ens.utlc    lc
where ic.ss = ss.ss
and   ic.lc = lc.lc
;
--table-comment:
comment on VIEW sc_lims_dal.SAMPLE_INFO_CARD is 'Contains all UNILAB-SAMPLE Info Card info';

--column-comment:
comment on COLUMN sc_lims_dal.SAMPLE_INFO_CARD.sample_code             is 'sample-code';
comment on COLUMN sc_lims_dal.SAMPLE_INFO_CARD.info_card               is 'sample info card';
comment on COLUMN sc_lims_dal.SAMPLE_INFO_CARD.info_card_node          is 'Node of the samples info card (specifying the order of the samples info cards within the request)';
comment on COLUMN sc_lims_dal.SAMPLE_INFO_CARD.protected               is 'Flag indicating whether the samples info card is read-only for the user';
comment on COLUMN sc_lims_dal.SAMPLE_INFO_CARD.hidden                  is 'Flag indicating whether the samples info card is visible to the user';
comment on COLUMN sc_lims_dal.SAMPLE_INFO_CARD.manually_added          is 'Flag indicating whether the samples info card has been added manually to the sample or by the system (assign. frequencies)';
comment on COLUMN sc_lims_dal.SAMPLE_INFO_CARD.last_comment            is 'Last comment of the Info cards';
comment on COLUMN sc_lims_dal.SAMPLE_INFO_CARD.description             is 'Description of samples info card';
comment on COLUMN sc_lims_dal.SAMPLE_INFO_CARD.version_description     is 'Version Description of the Info cards';
comment on COLUMN sc_lims_dal.SAMPLE_INFO_CARD.version                 is 'Version of the Info cards';
comment on COLUMN sc_lims_dal.SAMPLE_INFO_CARD.life_cycle              is 'Life cycle that determines the samples info cards status changes';
comment on COLUMN sc_lims_dal.SAMPLE_INFO_CARD.life_cycle_description  is 'life cycle description';
comment on COLUMN sc_lims_dal.SAMPLE_INFO_CARD.status                  is 'Status the samples info card has reached in its life cycle';
comment on COLUMN sc_lims_dal.SAMPLE_INFO_CARD.status_description      is 'Status the samples info card has reached in its life cycle (description)';


/*
--**********************************
--2.8.SAMPLE_INFO_CARD_HISTORY  (kan niet worden aangemaakt)
--**********************************
--TABEL utscichs WORDT NIET GESYNCHRONISEERD NAAR AWS DD. 10-05-2022 !!!!!!!

create or replace view sc_lims_dal.SAMPLE_INFO_CARD_HISTORY
(sample_code                         --SAMPLE-code
,info_card                           --sample info card
,info_card_node                      --Node of the sample's info card (specifying the order of the sample's info cards within the sample)
,what                                --What of the sample Info Card History
,why                                 --Why of the sample Info Card History
,who                                 --Who of the sample Info Card History
,logdate_in_local_tz                 --Logdate of the sample Info Card History
,logdate_in_original_tz              --Logdate of the sample Info Card History
,transaction                         --Transaction of the sample Info Card History Details
,event                               --Event of the sample Info Card History Details
)
as
select ichs.sc
,      ichs.ic
,      ichs.icnode
,      ichs.what_description
,      ichs.why
,      ichs.who_description
,      ichs.logdate
,      ichs.logdate_tz                 --to_char(@Select(sample Info Card History\rqichs.Logdate in Original TZ),'tzr')
,      ichs.tr_seq
,      ichs.ev_seq
from sc_unilab_ens.utscichs  ichs
;
--table-comment:
comment on VIEW sc_lims_dal.SAMPLE_INFO_CARD_HISTORY is 'Contains all UNILAB-SAMPLE Info Card info history';

--column-comment:
comment on COLUMN sc_lims_dal.SAMPLE_INFO_CARD_HISTORY.sample_code             is 'sample-code';
comment on COLUMN sc_lims_dal.SAMPLE_INFO_CARD_HISTORY.info_card               is 'sample info card';
comment on COLUMN sc_lims_dal.SAMPLE_INFO_CARD_HISTORY.info_card_node          is 'Node of the samples info card (specifying the order of the samples info cards within the sample)';
comment on COLUMN sc_lims_dal.SAMPLE_INFO_CARD_HISTORY.what                    is 'What of the sample Info Card History';
comment on COLUMN sc_lims_dal.SAMPLE_INFO_CARD_HISTORY.why                     is 'Why of the sample Info Card History';
comment on COLUMN sc_lims_dal.SAMPLE_INFO_CARD_HISTORY.who                     is 'Who of the sample Info Card History';
comment on COLUMN sc_lims_dal.SAMPLE_INFO_CARD_HISTORY.logdate_in_local_tz     is 'Logdate of the sample Info Card History';
comment on COLUMN sc_lims_dal.SAMPLE_INFO_CARD_HISTORY.logdate_in_original_tz  is 'Logdate of the sample Info Card History';
comment on COLUMN sc_lims_dal.SAMPLE_INFO_CARD_HISTORY.transaction             is 'Transaction of the sample Info Card History Details';
comment on COLUMN sc_lims_dal.SAMPLE_INFO_CARD_HISTORY.event                   is 'Event of the sample Info Card History Details';
*/

/*
--**********************************
--2.9.SAMPLE_INFO_CARD_HIST_DETAILS  (kan niet worden aangemaakt)
--**********************************
--TABEL utscichsdetails WORDT NIET GESYNCHRONISEERD NAAR AWS DD. 10-05-2022 !!!!!!!

create or replace view sc_lims_dal.SAMPLE_INFO_CARD_HIST_DETAILS
(sample_code                         --SAMPLE-code
,info_card                           --sample info card
,info_card_node                      --Node of the sample's info card (specifying the order of the sample's info cards within the sample)
,transaction                         --Transaction of the sample Info Card History Details
,event                               --Event of the sample Info Card History Details
,sequence                            --
,details                             --Details of the sample Info Card History Details
)
as
select ichsd.sc
,      ichsd.ic
,      ichsd.icnode
,      ichsd.tr_seq
,      ichsd.ev_seq
,      ichsd.seq
,      ichsd.details
from sc_unilab_ens.utscichsdetails  ichsd
;

--table-comment:
comment on VIEW sc_lims_dal.SAMPLE_INFO_CARD_HIST_DETAILS is 'Contains all UNILAB-SAMPLE Info Card info history';

--column-comment:
comment on COLUMN sc_lims_dal.SAMPLE_INFO_CARD_HIST_DETAILS.sample_code       is 'sample-code';
comment on COLUMN sc_lims_dal.SAMPLE_INFO_CARD_HIST_DETAILS.info_card         is 'sample info card';
comment on COLUMN sc_lims_dal.SAMPLE_INFO_CARD_HIST_DETAILS.info_card_node    is 'Node of the samples info card (specifying the order of the samples info cards within the sample)';
comment on COLUMN sc_lims_dal.SAMPLE_INFO_CARD_HIST_DETAILS.transaction       is 'Transaction of the sample Info Card History Details';
comment on COLUMN sc_lims_dal.SAMPLE_INFO_CARD_HIST_DETAILS.event             is 'Event of the sample Info Card History Details';
comment on COLUMN sc_lims_dal.SAMPLE_INFO_CARD_HIST_DETAILS.sequence          is 'sequence number';
comment on COLUMN sc_lims_dal.SAMPLE_INFO_CARD_HIST_DETAILS.details           is 'Details of the sample Info Card History Details';
*/

--**********************************
--2.10.SAMPLE_INFO_FIELD
--
-- 30-10-2023: OUTER-JOIN Ingebouwd omdat er vanuit INFO-FIELD status + lifecycle null kunnen zijn !!!
--**********************************

create or replace view sc_lims_dal.SAMPLE_INFO_FIELD
(sample_code                         --SAMPle-code
,info_card                           --sample info card
,info_card_node                      --Node of the sample's info card (specifying the order of the sample's info cards within the request)
,info_field                          --Info field
,info_field_node                     --Info field-node
,position_x                          --Position-x
,position_y                          --Position-y
,protected                           --Flag indicating whether the sample's info card is read-only for the user
,hidden                              --Flag indicating whether the sample's info card is visible to the user
,display_type                        --Specifies how the info field appears to the user
,mandatory                           --Specifies if the info field is mandatory
,display_title                       --Info field title
,result_value                        --Value of the info field
,version_description                 --Version Description of the Info Fields
,version                             --/Version of the Info fields
,life_cycle                          --Life cycle that determines the sample's info card's status changes
,life_cycle_description              --life cycle description
,status                              --Status the sample's info card has reached in its life cycle
,status_description                  --Status the sample's info card has reached in its life cycle (description)
)
as
select ii.sc
,      ii.ic
,      ii.icnode
,      ii.ii
,      ii.iinode
,      ii.pos_x
,      ii.pos_y
,      ii.is_protected
,      ii.hidden
,      ii.dsp_tp
,      ii.mandatory
,      ii.dsp_title
,      ii.iivalue
,      ii.ie_version                 --DECODE( UNAPIGEN.IsSystem21CFR11Compliant ,'0',@Select(General Settings\Translation for Version)||UVSCIC.IP_VERSION,'')
,      ii.ie_version 
,      ii.lc
,      lc.description
,      ii.ss
,      ss.name
from sc_unilab_ens.utscii  ii
LEFT OUTER JOIN sc_unilab_ens.utss ss on  ss.ss = ii.ss
LEFT OUTER JOIN sc_unilab_ens.utlc lc on  lc.lc = ii.lc
;
--table-comment:
comment on VIEW sc_lims_dal.SAMPLE_INFO_FIELD is 'Contains all UNILAB-SAMPLE Info Fields';

--column-comment:
comment on COLUMN sc_lims_dal.SAMPLE_INFO_FIELD.sample_code            is 'sample-code';
comment on COLUMN sc_lims_dal.SAMPLE_INFO_FIELD.info_card              is 'sample info card';
comment on COLUMN sc_lims_dal.SAMPLE_INFO_FIELD.info_card_node         is 'Node of the samples info card (specifying the order of the samples info cards within the request)';
comment on COLUMN sc_lims_dal.SAMPLE_INFO_FIELD.info_field             is 'Info field';
comment on COLUMN sc_lims_dal.SAMPLE_INFO_FIELD.info_field_node        is 'Info field-node';
comment on COLUMN sc_lims_dal.SAMPLE_INFO_FIELD.position_x             is 'Position-x';
comment on COLUMN sc_lims_dal.SAMPLE_INFO_FIELD.position_y             is 'Position-y';
comment on COLUMN sc_lims_dal.SAMPLE_INFO_FIELD.protected              is 'Flag indicating whether the samples info card is read-only for the user';
comment on COLUMN sc_lims_dal.SAMPLE_INFO_FIELD.hidden                 is 'Flag indicating whether the samples info card is visible to the user';
comment on COLUMN sc_lims_dal.SAMPLE_INFO_FIELD.display_type           is 'Specifies how the info field appears to the user';
comment on COLUMN sc_lims_dal.SAMPLE_INFO_FIELD.mandatory              is 'Specifies if the info field is mandatory';
comment on COLUMN sc_lims_dal.SAMPLE_INFO_FIELD.display_title          is 'Info field title';
comment on COLUMN sc_lims_dal.SAMPLE_INFO_FIELD.result_value           is 'Value of the info field';
comment on COLUMN sc_lims_dal.SAMPLE_INFO_FIELD.version_description    is 'Version Description of the Info Fields';
comment on COLUMN sc_lims_dal.SAMPLE_INFO_FIELD.version                is 'Version of the Info fields';
comment on COLUMN sc_lims_dal.SAMPLE_INFO_FIELD.life_cycle             is 'Life cycle that determines the samples info cards status changes';
comment on COLUMN sc_lims_dal.SAMPLE_INFO_FIELD.life_cycle_description is 'life cycle description';
comment on COLUMN sc_lims_dal.SAMPLE_INFO_FIELD.status                 is 'Status the samples info card has reached in its life cycle';
comment on COLUMN sc_lims_dal.SAMPLE_INFO_FIELD.status_description     is 'Status the samples info card has reached in its life cycle (description)';



--**********************************
--2.11.SAMPLE_PART_NO_INFO_CARD
--**********************************
--Bij outdoor-testing kunnen we kiezen voor request-type test "normal (4x zelfde band), combined (front+rear), en mixed (4xverschillende band)"
--Deze kunnen we bij SAMPLE opgeven, en komen dan ook op de INFO-CARD te staan !!
--De info-card geeft aan op welke POSITIE de band zit (bijv. avScReqPctFL, FR, RL, RR)

create or replace view sc_lims_dal.SAMPLE_PART_NO_INFO_CARD
(sample_code                         --SAMPle-code
,info_card                           --sample info card
,info_card_node                      --Node of the sample's info card (specifying the order of the sample's info cards within the request)
,info_field                          --Info field
,info_field_node                     --Info field-node
,display_title                       --Info field title
,result_value                        --Value of the info field
,version                             --Version of the Info fields
,life_cycle                          --Life cycle that determines the sample's info card's status changes
,life_cycle_description              --life cycle description
,status                              --Status the sample's info card has reached in its life cycle
,status_description                  --Status the sample's info card has reached in its life cycle (description)
)
as
select ii.sc
,      ii.ic
,      ii.icnode
,      ii.ii
,      ii.iinode
,      ii.dsp_title
,      ii.iivalue
,      ii.ie_version 
,      ii.lc
,      lc.description
,      ii.ss
,      ss.name
from sc_unilab_ens.utscii  ii
,    sc_unilab_ens.utss    ss
,    sc_unilab_ens.utlc    lc
where ii.ii like 'avPartNo%'
and   ii.ss = ss.ss(+)
and   ii.lc = lc.lc(+)
;
--table-comment:
comment on VIEW sc_lims_dal.SAMPLE_PART_NO_INFO_CARD is 'Contains all UNILAB-SAMPLE Info Fields with PART_NO. This includes PARTNO + PARTNODESCRIPTION';

--column-comment:
comment on COLUMN sc_lims_dal.SAMPLE_PART_NO_INFO_CARD.sample_code            is 'sample-code';
comment on COLUMN sc_lims_dal.SAMPLE_PART_NO_INFO_CARD.info_card              is 'sample info card';
comment on COLUMN sc_lims_dal.SAMPLE_PART_NO_INFO_CARD.info_card_node         is 'Node of the samples info card (specifying the order of the samples info cards within the request)';
comment on COLUMN sc_lims_dal.SAMPLE_PART_NO_INFO_CARD.info_field             is 'Info field';
comment on COLUMN sc_lims_dal.SAMPLE_PART_NO_INFO_CARD.info_field_node        is 'Info field-node';
comment on COLUMN sc_lims_dal.SAMPLE_PART_NO_INFO_CARD.display_title          is 'Info field title';
comment on COLUMN sc_lims_dal.SAMPLE_PART_NO_INFO_CARD.result_value           is 'Value of the info field';
comment on COLUMN sc_lims_dal.SAMPLE_PART_NO_INFO_CARD.version                is 'Version of the Info fields';
comment on COLUMN sc_lims_dal.SAMPLE_PART_NO_INFO_CARD.life_cycle             is 'Life cycle that determines the samples info cards status changes';
comment on COLUMN sc_lims_dal.SAMPLE_PART_NO_INFO_CARD.life_cycle_description is 'life cycle description';
comment on COLUMN sc_lims_dal.SAMPLE_PART_NO_INFO_CARD.status                 is 'Status the samples info card has reached in its life cycle';
comment on COLUMN sc_lims_dal.SAMPLE_PART_NO_INFO_CARD.status_description     is 'Status the samples info card has reached in its life cycle (description)';

--**********************************
--2.12.SAMPLE_PART_NO_GROUPKEY
--**********************************
--Bij outdoor-testing kunnen we kiezen voor request-type test "normal (4x zelfde band), combined (front+rear), en mixed (4xverschillende band)"
--Deze kunnen we bij SAMPLE opgeven, en komen dan ook op de INFO-CARD te staan !!
--De info-card geeft aan op welke POSITIE de band zit (bijv. avScReqPctFL, FR, RL, RR)




create or replace view sc_lims_dal.SAMPLE_PART_NO_GROUPKEY
(sample_code                         --sample-code
,group_key                           --group-keys
,group_key_sequence                  --group-key-sequence 
,value                               --group-key value
)
as
select scgk.sc
,      scgk.gk
,      scgk.gkseq
,      scgk.value
from sc_unilab_ens.utscgk scgk
where gk like '%PART_NO%'
;

--table-comment:
comment on VIEW sc_lims_dal.sample_group_key is 'Contains all UNILAB-SAMPLE GROUPKEYS with PART_NO from . Not for outdoor-testing.';

--column-comment:
comment on COLUMN sc_lims_dal.sample_group_key.sample_code            is 'sample-code';
comment on COLUMN sc_lims_dal.sample_group_key.value                  is 'part_no group-key value';






--************************************************************************************************************
--****   3.PARAMETER-GROUP
--************************************************************************************************************

--**********************************
--3.1.PARAMETER_GROUP
--**********************************

create or replace view sc_lims_dal.PARAMETER_GROUP
(sample_code              --Sc of the Parameter groups
,parameter_group          --Parameter group
,parameter_group_node     --Parameter group node
,manually_added           --Indicates whether the parameter group was assigned manually to the sample
,reanalysis               --The number of times the parameter group has been reanalysed for this sample
,manually_entered         --Manually entered of the Parameter groups
,allow_any_parameter      --Indicates if the user is allowed to assign other parameters to this parameter group
,last_comment             --Last comment of the parameter-group
,description              --Parameter group description
,version_description      --Version Description of the Parameter Groups
,version                  --Version of the Parameter Groups
,delay_value              --Amount of time between the sampling date and the moment the parameter group was assigned to the sample (value)
,delay_unit               --Amount of time between the sampling date and the moment the parameter group was assigned to the sample (unit)
,planned_executor         --Name of the person who was supposed to execute the parameter group for the sample
,executor                 --Name of the person who actually executed the parameter group for the sample
,assigned_by              --ID of the user who assigned the parameter group to the sample
,result_unit              --unit
,result_value_f           --result-value
,result_value_s           --result-value-string
,result_format            --format result
,life_cycle               --Life cycle that determines the request's status changes
,life_cycle_description   --life cycle description
,status                   --Status the sample has reached in its life cycle
,status_description       --Status the sample has reached in its life cycle (description)
)
as
select scpg.sc
,      scpg.pg
,      scpg.pgnode 
,      scpg.manually_added
,      scpg.reanalysis
,      scpg.manually_entered
,      scpg.allow_any_pr
,      scpg.last_comment
,      scpg.description
,      scpg.pp_version    --DECODE( UNAPIGEN.IsSystem21CFR11Compliant ,'0',@Select(General Settings\Translation for Version)||UVSCPG.PP_VERSION,'')
,      scpg.pp_version
,      scpg.delay
,      scpg.delay_unit
,      scpg.planned_executor
,      scpg.executor
,      scpg.assigned_by
,      scpg.unit
,      scpg.value_f
,      scpg.value_s
,      scpg.format
,      scpg.lc
,      lc.description
,      scpg.ss
,      ss.name
from sc_unilab_ens.utscpg  scpg
,    sc_unilab_ens.utss    ss
,    sc_unilab_ens.utlc    lc
where scpg.ss = ss.ss
and   scpg.lc = lc.lc
;
--table-comment:
comment on VIEW sc_lims_dal.PARAMETER_GROUP is 'Contains all UNILAB-SAMPLE Parameter Groups, all statusses, current and previous group-nodes. ';

--column-comment:
comment on COLUMN sc_lims_dal.PARAMETER_GROUP.sample_code            is 'sample-code';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP.parameter_group        is 'Parameter group';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP.parameter_group_node   is 'Parameter group node';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP.manually_added         is 'Indicates whether the parameter group was assigned manually to the sample';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP.reanalysis             is 'The number of times the parameter group has been reanalysed for this sample';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP.manually_entered       is 'Manually entered of the Parameter groups';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP.allow_any_parameter    is 'Indicates if the user is allowed to assign other parameters to this parameter group';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP.last_comment           is 'Last comment of the parameter-group';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP.description            is 'Parameter group description';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP.version_description    is 'Version Description of the Parameter Groups';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP.version                is 'Version of the Parameter Groups';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP.delay_value            is 'Amount of time between the sampling date and the moment the parameter group was assigned to the sample (value)';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP.delay_unit             is 'Amount of time between the sampling date and the moment the parameter group was assigned to the sample (unit)';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP.planned_executor       is 'Name of the person who was supposed to execute the parameter group for the sample';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP.executor               is 'Name of the person who actually executed the parameter group for the sample';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP.assigned_by            is 'ID of the user who assigned the parameter group to the sample';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP.result_unit            is 'unit';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP.result_value_f         is 'result-value';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP.result_value_s         is 'result-value-string';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP.result_format          is 'format result';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP.life_cycle             is 'Life cycle that determines the requests status changes';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP.life_cycle_description is 'life cycle description';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP.status                 is 'Status the sample has reached in its life cycle';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP.status_description     is 'Status the sample has reached in its life cycle (description)';


--**********************************
--3.1.PARAMETER_GROUP_DATA_TIME_INFO
--**********************************

create or replace view sc_lims_dal.PARAMETER_GROUP_DATA_TIME_INFO
(sample_code                         --sample-code
,parameter_group                     --parameter-group
,parameter_group_node                --Parameter group node
,assign_date_in_local_tz             --Date & time the parameter group was assigned to the sample, local timezone
,assign_date_in_original_tz          --Date & time the parameter group was assigned to the sample, original timezone
,exec_start_date_in_local_tz         --Date on which the analyses on the sample started, local timezone
,exec_start_date_in_original_tz      --Date on which the analyses on the sample started, original timezone
,exec_end_date_in_local_tz           --Date on which the analyses on the sample finished, local timezone
,exec_end_date_in_original_tz        --Date on which the analyses on the sample finished, original timezone
)
as
SELECT scpg.sc
,      scpg.pg
,      scpg.pgnode
,      scpg.assign_date
,      scpg.assign_date_tz             --to_char(@Select(Parameter group assignment\pg.Assign date in Original TZ),'tzr')
,      scpg.exec_start_date
,      scpg.exec_start_date_tz         --to_char(@Select(Date & time info\rq.Exec start date in Original TZ),'tzr')
,      scpg.exec_end_date
,      scpg.exec_end_date_tz           --to_char(@Select(Date & time info\rq.Exec end date in Original TZ),'tzr')
FROM sc_unilab_ens.UTSCPG scpg
;
--table-comment:
comment on VIEW sc_lims_dal.PARAMETER_GROUP_DATA_TIME_INFO is 'Contains all UNILAB-SAMPLE Parameter Groups Date-Fields';

--column-comment:
comment on COLUMN sc_lims_dal.PARAMETER_GROUP_DATA_TIME_INFO.sample_code                     is 'sample-code';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP_DATA_TIME_INFO.parameter_group                 is 'parameter-group';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP_DATA_TIME_INFO.parameter_group_node            is 'Parameter group node';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP_DATA_TIME_INFO.assign_date_in_local_tz         is 'Date and time the parameter group was assigned to the sample, local timezone';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP_DATA_TIME_INFO.assign_date_in_original_tz      is 'Date and time the parameter group was assigned to the sample, original timezone';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP_DATA_TIME_INFO.exec_start_date_in_local_tz     is 'Date on which the analyses on the sample started, local timezone';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP_DATA_TIME_INFO.exec_start_date_in_original_tz  is 'Date on which the analyses on the sample started, original timezone';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP_DATA_TIME_INFO.exec_end_date_in_local_tz       is 'Date on which the analyses on the sample finished, local timezone';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP_DATA_TIME_INFO.exec_end_date_in_original_tz    is 'Date on which the analyses on the sample finished, original timezone';



/*
--**********************************
--3.3.PARAMETER_GROUP_REANALYSIS      (tabel niet aangemaakt, is leeg)
--**********************************
--TABEL IS LEEG !!!!!!!!!!

create or replace view PARAMETER_GROUP_REANALYSIS
(sample_code                         --sample-code
,parameter_group                     --parameter-group
,parameter_group_node                --Parameter group node
,description                         --Description of the Parameter group reanalysis
,reanalysis                          --Reanalysis of the Parameter group reanalysis
,planned_executor                    --Name of the person who was supposed to execute the parameter group reanalysis
,executor                            --Name of the person who actually executed the parameter group reanalysis
,assigned_by                         --ID of the user who assigned the parameter group reanalysis
,assign_date_in_local_tz             --Date & time the parameter group was assigned to the sample
,assign_date_in_original_tz          --Date & time the parameter group was assigned to the sample
,exec_start_date_in_local_tz         --Date on which the analyses on the sample started
,exec_start_date_in_original_tz      --Date on which the analyses on the sample started
,exec_end_date_in_local_tz           --Date on which the analyses on the sample finished
,exec_end_date_in_original_tz        --Date on which the analyses on the sample finished
)
SELECT rscpg.sc
,      rscpg.pg
,      rscpg.pgnode
,      rscpg.description
,      rscpg.reanalysis
,      rscpg.planned_executor
,      rscpg.executor
,      rscpg.assigned_by
,      rscpg.assign_date
,      rscpg.assign_date_tz             --to_char(@Select(Parameter group assignment\pg.Assign date in Original TZ),'tzr')
,      rscpg.exec_start_date
,      rscpg.exec_start_date_tz         --to_char(@Select(Date & time info\rq.Exec start date in Original TZ),'tzr')
,      rscpg.exec_end_date
,      rscpg.exec_end_date_tz           --to_char(@Select(Date & time info\rq.Exec end date in Original TZ),'tzr')
FROM UTRSCPG rscpg
;
--table-comment:
comment on VIEW sc_lims_dal.PARAMETER_GROUP_REANALYSIS is 'Contains all UNILAB-SAMPLE Parameter Groups after reanalysis';

--column-comment:
comment on COLUMN sc_lims_dal.PARAMETER_GROUP_REANALYSIS.sample_code                     is 'sample-code';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP_REANALYSIS.parameter_group                 is 'parameter-group';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP_REANALYSIS.parameter_group_node            is 'Parameter group node';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP_REANALYSIS.description                     is 'Description of the Parameter group reanalysis';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP_REANALYSIS.reanalysis                      is 'Reanalysis of the Parameter group reanalysis';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP_REANALYSIS.planned_executor                is 'Name of the person who was supposed to execute the parameter group reanalysis';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP_REANALYSIS.executor                        is 'Name of the person who actually executed the parameter group reanalysis';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP_REANALYSIS.assigned_by                     is 'ID of the user who assigned the parameter group reanalysis';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP_REANALYSIS.assign_date_in_local_tz         is 'Date & time the parameter group was assigned to the sample, local timezone';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP_REANALYSIS.assign_date_in_original_tz      is 'Date & time the parameter group was assigned to the sample, original timezone';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP_REANALYSIS.exec_start_date_in_local_tz     is 'Date on which the analyses on the sample started, local timezone';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP_REANALYSIS.exec_start_date_in_original_tz  is 'Date on which the analyses on the sample started, original timezone';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP_REANALYSIS.exec_end_date_in_local_tz       is 'Date on which the analyses on the sample finished, local timezone';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP_REANALYSIS.exec_end_date_in_original_tz    is 'Date on which the analyses on the sample finished, original timezone';
*/

--**********************************
--3.4.PARAMETER_GROUP_ATTRIBUTES      
--**********************************

create or replace view sc_lims_dal.PARAMETER_GROUP_ATTRIBUTES
(sample_code                         --sample-code
,parameter_group                     --Parameter-group
,parameter_group_node                --Parameter-group-node
,attribute                           --Attribute of the  Parametergroup attributes
,sequence                            --/Sequence of the  Parametergroup attributes
,attribute_value                     --Attribute value of the  Parametergroup attributes
)
as
select scpgau.sc
,      scpgau.pg
,      scpgau.pgnode
,      scpgau.au
,      scpgau.auseq
,      scpgau.value
from sc_unilab_ens.utscpgau scpgau
;
--table-comment:
comment on VIEW sc_lims_dal.PARAMETER_GROUP_ATTRIBUTES is 'Contains all UNILAB-SAMPLE Parameter Groups attributes';

--column-comment:
comment on COLUMN sc_lims_dal.PARAMETER_GROUP_ATTRIBUTES.sample_code                     is 'sample-code';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP_ATTRIBUTES.parameter_group                 is 'Parameter-group';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP_ATTRIBUTES.parameter_group_node            is 'Parameter-group-node';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP_ATTRIBUTES.attribute                       is 'Attribute of the  Parametergroup attributes';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP_ATTRIBUTES.sequence                        is 'Sequence of the  Parametergroup attributes';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP_ATTRIBUTES.attribute_value                 is 'Attribute value of the  Parametergroup attributes';

/*
--**********************************
--3.5.PARAMETER_GROUP_HISTORY      (kan niet worden aangemaakt) 
--**********************************
--TABEL utscpghs WORDT NIET GESYNCHRONISEERD NAAR AWS DD. 10-05-2022 !!!!!!!

create or replace view sc_lims_dal.PARAMETER_GROUP_HISTORY
(sample_code                         --sample-code
,parameter_group                     --Parameter-group
,parameter_group_node                --Parameter-group-node
,what                                --What of the Parametergroup history
,why                                 --Why of the Parametergroup History
,who                                 --Who of the Parametergroup History
,logdate_in_local_tz                 --Logdate of the Parametergroup History
,logdate_in_original_tz              --Logdate of the Parametergroup History
,transaction                         --Transaction of the Parametergroup History Details
,event                               --Event of the Parametergroup History Details
)
as
select scpghs.sc
,      scpghs.pg
,      scpghs.pgnode
,      scpghs.what_description
,      scpghs.why
,      scpghs.who_description
,      scpghs.logdate
,      scpghs.logdate_tz                 --to_char(@Select(Request History\rqhs.Logdate in Original TZ),'tzr')
,      scpghs.tr_seq
,      scpghs.ev_seq
from sc_unilab_ens.utscpghs  scpghs
;
--table-comment:
comment on VIEW sc_lims_dal.PARAMETER_GROUP_HISTORY is 'Contains all UNILAB-SAMPLE Parameter Groups mutation-log-history';

--column-comment:
comment on COLUMN sc_lims_dal.PARAMETER_GROUP_HISTORY.sample_code               is 'sample-code';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP_HISTORY.parameter_group           is 'Parameter-group';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP_HISTORY.parameter_group_node      is 'Parameter-group-node';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP_HISTORY.what                      is 'What of the Parametergroup history';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP_HISTORY.why                       is 'Why of the Parametergroup History';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP_HISTORY.who                       is 'Who of the Parametergroup History';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP_HISTORY.logdate_in_local_tz       is 'Logdate of the Parametergroup History';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP_HISTORY.logdate_in_original_tz    is 'Logdate of the Parametergroup History';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP_HISTORY.transaction               is 'Transaction of the Parametergroup History Details';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP_HISTORY.event                     is 'Event of the Parametergroup History Details';
*/

/*
--**********************************
--3.6.PARAMETER_GROUP_HIST_DETAILS      (kan niet worden aangemaakt) 
--**********************************
--TABEL utpghsdetails WORDT NIET GESYNCHRONISEERD NAAR AWS DD. 10-05-2022 !!!!!!!

create or replace view sc_lims_dal.PARAMETER_GROUP_HIST_DETAILS
(sample_code                         --sample-code
,parameter_group                     --parameter-group
,parameter_group_node                --parameter-group-node
,transaction                         --Transaction of the sample History Details
,event                               --Event of the sample History Details
,sequence                            --sequence number
,details                             --Details of the SAMPLE History Details
)
as
select pghsd.rq
,      pghsd.pg
,      pghsd.pgnode
,      pghsd.tr_seq
,      pghsd.ev_seq
,      pghsd.seq
,      pghsd.details
from sc_unilab_ens.utpghsdetails  pghsd
;
--table-comment:
comment on VIEW sc_lims_dal.PARAMETER_GROUP_HIST_DETAILS is 'Contains all UNILAB-SAMPLE Parameter Groups mutation-log-history-details';

--column-comment:
comment on COLUMN sc_lims_dal.PARAMETER_GROUP_HIST_DETAILS.sample_code               is 'sample-code';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP_HIST_DETAILS.parameter_group           is 'parameter-group';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP_HIST_DETAILS.parameter_group_node      is 'parameter-group-node';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP_HIST_DETAILS.transaction               is 'Transaction of the sample History Details';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP_HIST_DETAILS.event                     is 'Event of the sample History Details';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP_HIST_DETAILS.sequence                  is 'sequence number';
comment on COLUMN sc_lims_dal.PARAMETER_GROUP_HIST_DETAILS.details                   is 'Details of the SAMPLE History Details';
*/


--************************************************************************************************************
--****   4.PARAMETER
--************************************************************************************************************

--**********************************
--4.1.PARAMETER
--**********************************

create or replace view sc_lims_dal.PARAMETER
(sample_code              --Sample-code of the Parameter groups
,parameter_group          --Parameter group
,parameter_group_node     --Parameter group node
,parameter                --Parameter
,parameter_node           --Parameter-node
,log_exceptions           --log-exceptions
,user_must_be_confirmed   --Specifies if the password must be asked to any user entering results for the parameter
,manually_added           --Indicates whether the parameter was assigned manually to the sample
,allow_any_method         --Indicates if the user is allowed to assign other METHODS to this parameter 
,manually_entered         --Manually entered of the Parameters
,minimum_nr_results       --Minimum number of method results needed to enable calculation of the parameter result
,reanalysis               --The number of times the parameter has been reanalysed for this sample
,last_comment             --Last comment of the parameter-group
,description              --Parameter group description
,version_description      --Version Description of the Parameter 
,version                  --Version of the Parameter 
,delay_value              --Amount of time between the sampling date and the moment the parameter was assigned to the sample (value)
,delay_unit               --Amount of time between the sampling date and the moment the parameter was assigned to the sample (unit)
,trending_duration_unit   --Trending duration unit of the Parameters
,trending_duration_value  --Trending duration value of the Parameters
,result_unit              --unit
,result_value_f           --result-value
,result_value_s           --result-value-string
,result_format            --result format
,calculation_method       --Calculation method of the Parameter calculation
,calculation_function     --Calculation function of the Parameter calculation
,planned_executor         --Name of the person who was supposed to execute the parameter  for the sample
,executor                 --Name of the person who actually executed the parameter  for the sample
,assigned_by              --ID of the user who assigned the parameter  to the sample
,alarm_order              --Order of the alarm handling for validation
,life_cycle               --Life cycle that determines the request's status changes
,life_cycle_description   --life cycle description
,status                   --Status the sample has reached in its life cycle
,status_description       --Status the sample has reached in its life cycle (description)
)
as
select scpa.sc
,      scpa.pg
,      scpa.pgnode 
,      scpa.pa
,      scpa.panode
,      scpa.log_exceptions
,      scpa.confirm_uid
,      scpa.manually_added
,      scpa.allow_any_me
,      scpa.manually_entered
,      scpa.min_nr_results
,      scpa.reanalysis
,      scpa.last_comment
,      scpa.description
,      scpa.pr_version    --DECODE( UNAPIGEN.IsSystem21CFR11Compliant ,'0',@Select(General Settings\Translation for Version)||UVSCPA.PR_VERSION,'')
,      scpa.pr_version
,      scpa.delay
,      scpa.delay_unit
,      scpa.td_info_unit
,      scpa.td_info
,      scpa.unit
,      scpa.value_f
,      scpa.value_s
,      scpa.format
,      scpa.calc_method
,      scpa.calc_cf
,      scpa.planned_executor
,      scpa.executor
,      scpa.assigned_by
,      scpa.alarm_order
,      scpa.lc
,      lc.description
,      scpa.ss
,      ss.name
from sc_unilab_ens.utscpa  scpa
,    sc_unilab_ens.utss    ss
,    sc_unilab_ens.utlc    lc
where scpa.ss = ss.ss
and   scpa.lc = lc.lc
;
--table-comment:
comment on VIEW sc_lims_dal.PARAMETER is 'Contains all UNILAB-SAMPLE Parameters, all statusses, current and previous versions';

--column-comment:
comment on COLUMN sc_lims_dal.PARAMETER.sample_code               is 'sample-code';
comment on COLUMN sc_lims_dal.PARAMETER.parameter_group           is 'Parameter group';
comment on COLUMN sc_lims_dal.PARAMETER.parameter_group_node      is 'Parameter group node';
comment on COLUMN sc_lims_dal.PARAMETER.parameter                 is 'Parameter';
comment on COLUMN sc_lims_dal.PARAMETER.parameter_node            is 'Parameter-node';
comment on COLUMN sc_lims_dal.PARAMETER.log_exceptions            is 'log-exceptions';
comment on COLUMN sc_lims_dal.PARAMETER.user_must_be_confirmed    is 'Specifies if the password must be asked to any user entering results for the parameter';
comment on COLUMN sc_lims_dal.PARAMETER.manually_added            is 'Indicates whether the parameter was assigned manually to the sample';
comment on COLUMN sc_lims_dal.PARAMETER.allow_any_method          is 'Indicates if the user is allowed to assign other METHODS to this parameter ';
comment on COLUMN sc_lims_dal.PARAMETER.manually_entered          is 'Manually entered of the Parameters';
comment on COLUMN sc_lims_dal.PARAMETER.minimum_nr_results        is 'Minimum number of method results needed to enable calculation of the parameter result';
comment on COLUMN sc_lims_dal.PARAMETER.reanalysis                is 'The number of times the parameter has been reanalysed for this sample';
comment on COLUMN sc_lims_dal.PARAMETER.last_comment              is 'Last comment of the parameter-group';
comment on COLUMN sc_lims_dal.PARAMETER.description               is 'Parameter group description';
comment on COLUMN sc_lims_dal.PARAMETER.version_description       is 'Version Description of the Parameter ';
comment on COLUMN sc_lims_dal.PARAMETER.version                   is 'Version of the Parameter ';
comment on COLUMN sc_lims_dal.PARAMETER.delay_value               is 'Amount of time between the sampling date and the moment the parameter was assigned to the sample (value)';
comment on COLUMN sc_lims_dal.PARAMETER.delay_unit                is 'Amount of time between the sampling date and the moment the parameter was assigned to the sample (unit)';
comment on COLUMN sc_lims_dal.PARAMETER.trending_duration_unit    is 'Trending duration unit of the Parameters';
comment on COLUMN sc_lims_dal.PARAMETER.trending_duration_value   is 'Trending duration value of the Parameters';
comment on COLUMN sc_lims_dal.PARAMETER.result_unit               is 'unit';
comment on COLUMN sc_lims_dal.PARAMETER.result_value_f            is 'result-value';
comment on COLUMN sc_lims_dal.PARAMETER.result_value_s            is 'result-value-string';
comment on COLUMN sc_lims_dal.PARAMETER.result_format             is 'result format';
comment on COLUMN sc_lims_dal.PARAMETER.calculation_method        is 'Calculation method of the Parameter calculation';
comment on COLUMN sc_lims_dal.PARAMETER.calculation_function      is 'Calculation function of the Parameter calculation';
comment on COLUMN sc_lims_dal.PARAMETER.planned_executor          is 'Name of the person who was supposed to execute the parameter  for the sample';
comment on COLUMN sc_lims_dal.PARAMETER.executor                  is 'Name of the person who actually executed the parameter  for the sample';
comment on COLUMN sc_lims_dal.PARAMETER.assigned_by               is 'ID of the user who assigned the parameter  to the sample';
comment on COLUMN sc_lims_dal.PARAMETER.alarm_order               is 'Order of the alarm handling for validation';
comment on COLUMN sc_lims_dal.PARAMETER.life_cycle                is 'Life cycle that determines the requests status changes';
comment on COLUMN sc_lims_dal.PARAMETER.life_cycle_description    is 'life cycle description';
comment on COLUMN sc_lims_dal.PARAMETER.status                    is 'Status the sample has reached in its life cycle';
comment on COLUMN sc_lims_dal.PARAMETER.status_description        is 'Status the sample has reached in its life cycle (description)';


--**********************************
--4.2.PARAMETER_DATA_TIME_INFO
--**********************************

create or replace view sc_lims_dal.PARAMETER_DATA_TIME_INFO
(sample_code                         --sample-code
,parameter_group                     --parameter-group
,parameter_group_node                --Parameter group node
,parameter                           --parameter
,parameter_node                      --parameter-node
,assign_date_in_local_tz             --Date & time the parameter group was assigned to the sample
,assign_date_in_original_tz          --Date & time the parameter group was assigned to the sample
,exec_start_date_in_local_tz         --Date on which the analyses on the sample started
,exec_start_date_in_original_tz      --Date on which the analyses on the sample started
,exec_end_date_in_local_tz           --Date on which the analyses on the sample finished
,exec_end_date_in_original_tz        --Date on which the analyses on the sample finished
)
as
SELECT scpa.sc
,      scpa.pg
,      scpa.pgnode
,      scpa.pa
,      scpa.panode
,      scpa.assign_date
,      scpa.assign_date_tz             --to_char(@Select(Parameter group assignment\pg.Assign date in Original TZ),'tzr')
,      scpa.exec_start_date
,      scpa.exec_start_date_tz         --to_char(@Select(Date & time info\rq.Exec start date in Original TZ),'tzr')
,      scpa.exec_end_date
,      scpa.exec_end_date_tz           --to_char(@Select(Date & time info\rq.Exec end date in Original TZ),'tzr')
FROM sc_unilab_ens.UTSCPA scpa
;
--table-comment:
comment on VIEW sc_lims_dal.PARAMETER_DATA_TIME_INFO is 'Contains all UNILAB-SAMPLE PARAMETER date info';

--column-comment:
comment on COLUMN sc_lims_dal.PARAMETER_DATA_TIME_INFO.sample_code                    is 'sample-code';
comment on COLUMN sc_lims_dal.PARAMETER_DATA_TIME_INFO.parameter_group                is 'parameter-group';
comment on COLUMN sc_lims_dal.PARAMETER_DATA_TIME_INFO.parameter_group_node           is 'Parameter group node';
comment on COLUMN sc_lims_dal.PARAMETER_DATA_TIME_INFO.parameter                      is 'parameter';
comment on COLUMN sc_lims_dal.PARAMETER_DATA_TIME_INFO.parameter_node                 is 'parameter-node';
comment on COLUMN sc_lims_dal.PARAMETER_DATA_TIME_INFO.assign_date_in_local_tz        is 'Date & time the parameter group was assigned to the sample, local timezone';
comment on COLUMN sc_lims_dal.PARAMETER_DATA_TIME_INFO.assign_date_in_original_tz     is 'Date & time the parameter group was assigned to the sample, original timezone';
comment on COLUMN sc_lims_dal.PARAMETER_DATA_TIME_INFO.exec_start_date_in_local_tz    is 'Date on which the analyses on the sample started, local timezone';
comment on COLUMN sc_lims_dal.PARAMETER_DATA_TIME_INFO.exec_start_date_in_original_tz is 'Date on which the analyses on the sample started, original timezone';
comment on COLUMN sc_lims_dal.PARAMETER_DATA_TIME_INFO.exec_end_date_in_local_tz      is 'Date on which the analyses on the sample finished, local timezone';
comment on COLUMN sc_lims_dal.PARAMETER_DATA_TIME_INFO.exec_end_date_in_original_tz   is 'Date on which the analyses on the sample finished, original timezone';


--**********************************
--4.3.PARAMETER_SPECIFICATIONS
--**********************************

create or replace view sc_lims_dal.PARAMETER_SPECIFICATIONS
(sample_code                         --sample-code
,parameter_group                     --parameter-group
,parameter_group_node                --Parameter group node
,parameter                           --parameter
,parameter_node                      --parameter-node
,high_target_dev                     --high target deviation (set a) : procentual or not
,low_target_dev                      --low target deviation (set a) : procentual or not
,high_dev                            --High target dev (set a)Formatted of the Par. spec. (set a)
,low_dev                             --Low target dev (set a)Formatted of the Par. spec. (set a)
,high_spec                           --High spec (set a) (Formatted) of the Par. spec. (set a)
,high_limit                          --High limit (set a) (Formatted) of the Par. spec. (set a)
,target                              --Target (set a) Formatted of the Par. spec. (set a)
,low_limit                           --Low limit (set a) Formatted of the Par. spec. (set a)
,low_spec                            --Low spec (set a) Formatted of the Par. spec. (set a)
) 
as
SELECT spa.sc
,      spa.pg
,      spa.pgnode
,      spa.pa
,      spa.panode
,      spa.rel_high_dev
,      spa.rel_low_dev
,      spa.high_dev                    --UNAPIGEN.SQLFORMATRESULT(UVSCPASPA.HIGH_DEV, RFU_GetDeviationFormat(UVSCPASPA.SC,UVSCPASPA.PG,UVSCPASPA.PGNODE,UVSCPASPA.PA,UVSCPASPA.PANODE,'high',UVSCPA.FORMAT))
,      spa.low_dev                     --UNAPIGEN.SQLFORMATRESULT(UVSCPASPA.HIGH_DEV, RFU_GetDeviationFormat(UVSCPASPA.SC,UVSCPASPA.PG,UVSCPASPA.PGNODE,UVSCPASPA.PA,UVSCPASPA.PANODE,'high',UVSCPA.FORMAT))
,      spa.high_spec                   --UNAPIGEN.SQLFORMATRESULT(UVSCPASPA.HIGH_SPEC, UVSCPA.FORMAT)
,      spa.high_limit                  --UNAPIGEN.SQLFORMATRESULT(UVSCPASPA.HIGH_LIMIT, UVSCPA.FORMAT)
,      spa.target                      --UNAPIGEN.SQLFORMATRESULT(UVSCPASPA.TARGET, UVSCPA.FORMAT)
,      spa.low_limit                   --UNAPIGEN.SQLFORMATRESULT(UVSCPASPA.LOW_LIMIT, UVSCPA.FORMAT)
,      spa.low_spec                    --UNAPIGEN.SQLFORMATRESULT(UVSCPASPA.LOW_SPEC, UVSCPA.FORMAT)
FROM sc_unilab_ens.UTSCPASPA spa 
;
--table-comment:
comment on VIEW sc_lims_dal.PARAMETER_SPECIFICATIONS is 'Contains all UNILAB-SAMPLE PARAMETER specifications ';

--column-comment:
comment on COLUMN sc_lims_dal.PARAMETER_SPECIFICATIONS.sample_code                    is 'sample-code';
comment on COLUMN sc_lims_dal.PARAMETER_SPECIFICATIONS.parameter_group                is 'parameter-group';
comment on COLUMN sc_lims_dal.PARAMETER_SPECIFICATIONS.parameter_group_node           is 'Parameter group node';
comment on COLUMN sc_lims_dal.PARAMETER_SPECIFICATIONS.parameter                      is 'parameter';
comment on COLUMN sc_lims_dal.PARAMETER_SPECIFICATIONS.parameter_node                 is 'parameter-node';
comment on COLUMN sc_lims_dal.PARAMETER_SPECIFICATIONS.high_target_dev                is 'high target deviation (set a) : procentual or not';
comment on COLUMN sc_lims_dal.PARAMETER_SPECIFICATIONS.low_target_dev                 is 'low target deviation (set a) : procentual or not';
comment on COLUMN sc_lims_dal.PARAMETER_SPECIFICATIONS.high_dev                       is 'High target dev (set a)Formatted of the Par. spec. (set a)';
comment on COLUMN sc_lims_dal.PARAMETER_SPECIFICATIONS.low_dev                        is 'Low target dev (set a)Formatted of the Par. spec. (set a)';
comment on COLUMN sc_lims_dal.PARAMETER_SPECIFICATIONS.high_spec                      is 'High spec (set a) (Formatted) of the Par. spec. (set a)';
comment on COLUMN sc_lims_dal.PARAMETER_SPECIFICATIONS.high_limit                     is 'High limit (set a) (Formatted) of the Par. spec. (set a)';
comment on COLUMN sc_lims_dal.PARAMETER_SPECIFICATIONS.target                         is 'Target (set a) Formatted of the Par. spec. (set a)';
comment on COLUMN sc_lims_dal.PARAMETER_SPECIFICATIONS.low_limit                      is 'Low limit (set a) Formatted of the Par. spec. (set a)';
comment on COLUMN sc_lims_dal.PARAMETER_SPECIFICATIONS.low_spec                       is 'Low spec (set a) Formatted of the Par. spec. (set a)';


--**********************************
--4.4.PARAMETER_ATTRIBUTES
--**********************************

create or replace view sc_lims_dal.PARAMETER_ATTRIBUTES
(sample_code                         --sample-code
,parameter_group                     --Parameter-group
,parameter_group_node                --Parameter-group-node
,parameter                           --parameter
,parameter_node                      --parameter-node
,attribute                           --Attribute of the  Parametergroup attributes
,sequence                            --/Sequence of the  Parametergroup attributes
,attribute_value                     --Attribute value of the  Parametergroup attributes
)
as
select scpaau.sc
,      scpaau.pg
,      scpaau.pgnode
,      scpaau.pa
,      scpaau.panode
,      scpaau.au
,      scpaau.auseq
,      scpaau.value
from sc_unilab_ens.utscpaau scpaau
;
--table-comment:
comment on VIEW sc_lims_dal.PARAMETER_ATTRIBUTES is 'Contains all UNILAB-SAMPLE PARAMETER attributes';

--column-comment:
comment on COLUMN sc_lims_dal.PARAMETER_ATTRIBUTES.sample_code                    is 'sample-code';
comment on COLUMN sc_lims_dal.PARAMETER_ATTRIBUTES.parameter_group                is 'Parameter-group';
comment on COLUMN sc_lims_dal.PARAMETER_ATTRIBUTES.parameter_group_node           is 'Parameter-group-node';
comment on COLUMN sc_lims_dal.PARAMETER_ATTRIBUTES.parameter                      is 'parameter';
comment on COLUMN sc_lims_dal.PARAMETER_ATTRIBUTES.parameter_node                 is 'parameter-node';
comment on COLUMN sc_lims_dal.PARAMETER_ATTRIBUTES.attribute                      is 'Attribute of the  Parametergroup attributes';
comment on COLUMN sc_lims_dal.PARAMETER_ATTRIBUTES.sequence                       is 'Sequence of the  Parametergroup attributes';
comment on COLUMN sc_lims_dal.PARAMETER_ATTRIBUTES.attribute_value                is 'Attribute value of the  Parametergroup attributes';


--**********************************
--4.5.PARAMETER_HISTORY
--**********************************

create or replace view sc_lims_dal.PARAMETER_HISTORY
(sample_code                         --sample-code
,parameter_group                     --Parameter-group
,parameter_group_node                --Parameter-group-node
,parameter                           --parameter
,parameter_node                      --parameter-node
,what                                --What of the Parameter history
,why                                 --Why of the Parameter History
,who                                 --Who of the Parameter History
,logdate_in_local_tz                 --Logdate of the Parameter History
,logdate_in_original_tz              --Logdate of the Parameter History
,transaction                         --Transaction of the Parameter History Details
,event                               --Event of the Parameter History Details
)
as
select scpahs.sc
,      scpahs.pg
,      scpahs.pgnode
,      scpahs.pa
,      scpahs.panode
,      scpahs.what_description
,      scpahs.why
,      scpahs.who_description
,      scpahs.logdate
,      scpahs.logdate_tz                 --to_char(@Select(Request History\rqhs.Logdate in Original TZ),'tzr')
,      scpahs.tr_seq
,      scpahs.ev_seq
from sc_unilab_ens.utscpahs  scpahs
;
--table-comment:
comment on VIEW sc_lims_dal.PARAMETER_HISTORY is 'Contains all UNILAB-SAMPLE PARAMETER mutation-log-history';

--column-comment:
comment on COLUMN sc_lims_dal.PARAMETER_HISTORY.sample_code                    is 'sample-code';
comment on COLUMN sc_lims_dal.PARAMETER_HISTORY.parameter_group                is 'Parameter-group';
comment on COLUMN sc_lims_dal.PARAMETER_HISTORY.parameter_group_node           is 'Parameter-group-node';
comment on COLUMN sc_lims_dal.PARAMETER_HISTORY.parameter                      is 'parameter';
comment on COLUMN sc_lims_dal.PARAMETER_HISTORY.parameter_node                 is 'parameter-node';
comment on COLUMN sc_lims_dal.PARAMETER_HISTORY.what                           is 'What of the Parameter history';
comment on COLUMN sc_lims_dal.PARAMETER_HISTORY.why                            is 'Why of the Parameter History';
comment on COLUMN sc_lims_dal.PARAMETER_HISTORY.who                            is 'Who of the Parameter History';
comment on COLUMN sc_lims_dal.PARAMETER_HISTORY.logdate_in_local_tz            is 'Logdate of the Parameter History, local timezone';
comment on COLUMN sc_lims_dal.PARAMETER_HISTORY.logdate_in_original_tz         is 'Logdate of the Parameter History, original timezone';
comment on COLUMN sc_lims_dal.PARAMETER_HISTORY.transaction                    is 'Transaction of the Parameter History Details';
comment on COLUMN sc_lims_dal.PARAMETER_HISTORY.event                          is 'Event of the Parameter History Details';

/*
--**********************************
--4.6.PARAMETER_HIST_DETAILS      (kan niet worden aangemaakt) 
--**********************************
--TABEL utpahsdetails WORDT NIET GESYNCHRONISEERD NAAR AWS DD. 10-05-2022 !!!!!!!

create or replace view sc_lims_dal.PARAMETER_HIST_DETAILS
(sample_code                         --sample-code
,parameter_group                     --parameter-group
,parameter_group_node                --parameter-group-node
,parameter                           --parameter
,parameter_node                      --parameter-node
,transaction                         --Transaction of the sample History Details
,event                               --Event of the sample History Details
,sequence                            --Sequence-number
,details                             --Details of the SAMPLE History Details
)
as
select pahsd.rq
,      pahsd.pg
,      pahsd.pgnode
,      pahsd.pa
,      pahsd.panode
,      pahsd.tr_seq
,      pahsd.ev_seq
,      pahsd.seq
,      pahsd.details
from sc_unilab_ens.utpahsdetails  pahsd
;
--table-comment:
comment on VIEW sc_lims_dal.PARAMETER_HIST_DETAILS is 'Contains all UNILAB-SAMPLE PARAMETER mutation-log-history-details';

--column-comment:
comment on COLUMN sc_lims_dal.PARAMETER_HIST_DETAILS.sample_code                    is 'sample-code';
comment on COLUMN sc_lims_dal.PARAMETER_HIST_DETAILS.parameter_group                is 'parameter-group';
comment on COLUMN sc_lims_dal.PARAMETER_HIST_DETAILS.parameter_group_node           is 'parameter-group-node';
comment on COLUMN sc_lims_dal.PARAMETER_HIST_DETAILS.parameter                      is 'parameter';
comment on COLUMN sc_lims_dal.PARAMETER_HIST_DETAILS.parameter_node                 is 'parameter-node';
comment on COLUMN sc_lims_dal.PARAMETER_HIST_DETAILS.transaction                    is 'Transaction of the sample History Details';
comment on COLUMN sc_lims_dal.PARAMETER_HIST_DETAILS.event                          is 'Event of the sample History Details';
comment on COLUMN sc_lims_dal.PARAMETER_HIST_DETAILS.sequence                       is 'Sequence-number';
comment on COLUMN sc_lims_dal.PARAMETER_HIST_DETAILS.details                        is 'Details of the SAMPLE History Details';
*/


--**********************************
--4.7.PARAMETER_REANALYSIS      
--**********************************

create or replace view sc_lims_dal.PARAMETER_REANALYSIS
(sample_code                         --sample-code
,parameter_group                     --parameter-group
,parameter_group_node                --Parameter group node
,parameter                           --parameter
,parameter_node                      --parameter-node
,description                         --Description of the Parameter reanalysis
,reanalysis                          --Reanalysis of the Parameter reanalysis
,result_value                        --Value of the Parameter reanalysis results
,result_value_string                 --String value of the Parameter reanalysis results
,result_unit                         --Unit of the Parameter reanalysis results
,alarm_order                         --Alarm order of the Parameter reanalysis validation
,planned_executor                    --Name of the person who was supposed to execute the parameter group reanalysis
,executor                            --Name of the person who actually executed the parameter group reanalysis
,assigned_by                         --ID of the user who assigned the parameter group reanalysis
,assign_date_in_local_tz             --Date & time the parameter group was assigned to the sample, local timezone
,assign_date_in_original_tz          --Date & time the parameter group was assigned to the sample, original timezone
,exec_start_date_in_local_tz         --Date on which the analyses on the sample started, local timezone
,exec_start_date_in_original_tz      --Date on which the analyses on the sample started, original timezone
,exec_end_date_in_local_tz           --Date on which the analyses on the sample finished, local timezone
,exec_end_date_in_original_tz        --Date on which the analyses on the sample finished, original timezone
)
as
SELECT rscpa.sc
,      rscpa.pg
,      rscpa.pgnode
,      rscpa.pa
,      rscpa.panode
,      rscpa.description
,      rscpa.reanalysis
,      rscpa.value_f
,      rscpa.value_s
,      rscpa.unit
,      rscpa.alarm_order
,      rscpa.planned_executor
,      rscpa.executor
,      rscpa.assigned_by
,      rscpa.assign_date
,      rscpa.assign_date_tz             --to_char(@Select(Parameter group assignment\pg.Assign date in Original TZ),'tzr')
,      rscpa.exec_start_date
,      rscpa.exec_start_date_tz         --to_char(@Select(Date & time info\rq.Exec start date in Original TZ),'tzr')
,      rscpa.exec_end_date
,      rscpa.exec_end_date_tz           --to_char(@Select(Date & time info\rq.Exec end date in Original TZ),'tzr')
FROM sc_unilab_ens.UTRSCPA rscpa
;
--table-comment:
comment on VIEW sc_lims_dal.PARAMETER_REANALYSIS is 'Contains all UNILAB-SAMPLE PARAMETER re-analysis-results';

--column-comment:
comment on COLUMN sc_lims_dal.PARAMETER_REANALYSIS.sample_code                    is 'sample-code';
comment on COLUMN sc_lims_dal.PARAMETER_REANALYSIS.parameter_group                is 'parameter-group';
comment on COLUMN sc_lims_dal.PARAMETER_REANALYSIS.parameter_group_node           is 'Parameter group node';
comment on COLUMN sc_lims_dal.PARAMETER_REANALYSIS.parameter                      is 'parameter';
comment on COLUMN sc_lims_dal.PARAMETER_REANALYSIS.parameter_node                 is 'parameter-node';
comment on COLUMN sc_lims_dal.PARAMETER_REANALYSIS.description                    is 'Description of the Parameter reanalysis';
comment on COLUMN sc_lims_dal.PARAMETER_REANALYSIS.reanalysis                     is 'Reanalysis of the Parameter reanalysis';
comment on COLUMN sc_lims_dal.PARAMETER_REANALYSIS.result_value                   is 'Value of the Parameter reanalysis results';
comment on COLUMN sc_lims_dal.PARAMETER_REANALYSIS.result_value_string            is 'String value of the Parameter reanalysis results';
comment on COLUMN sc_lims_dal.PARAMETER_REANALYSIS.result_unit                    is 'Unit of the Parameter reanalysis results';
comment on COLUMN sc_lims_dal.PARAMETER_REANALYSIS.alarm_order                    is 'Alarm order of the Parameter reanalysis validation';
comment on COLUMN sc_lims_dal.PARAMETER_REANALYSIS.planned_executor               is 'Name of the person who was supposed to execute the parameter group reanalysis';
comment on COLUMN sc_lims_dal.PARAMETER_REANALYSIS.executor                       is 'Name of the person who actually executed the parameter group reanalysis';
comment on COLUMN sc_lims_dal.PARAMETER_REANALYSIS.assigned_by                    is 'ID of the user who assigned the parameter group reanalysis';
comment on COLUMN sc_lims_dal.PARAMETER_REANALYSIS.assign_date_in_local_tz        is 'Date & time the parameter group was assigned to the sample, local timezone';
comment on COLUMN sc_lims_dal.PARAMETER_REANALYSIS.assign_date_in_original_tz     is 'Date & time the parameter group was assigned to the sample, original timezone';
comment on COLUMN sc_lims_dal.PARAMETER_REANALYSIS.exec_start_date_in_local_tz    is 'Date on which the analyses on the sample started, local timezone';
comment on COLUMN sc_lims_dal.PARAMETER_REANALYSIS.exec_start_date_in_original_tz is 'Date on which the analyses on the sample started, original timezone';
comment on COLUMN sc_lims_dal.PARAMETER_REANALYSIS.exec_end_date_in_local_tz      is 'Date on which the analyses on the sample finished, local timezone';
comment on COLUMN sc_lims_dal.PARAMETER_REANALYSIS.exec_end_date_in_original_tz   is 'Date on which the analyses on the sample finished, original timezone';




--************************************************************************************************************
--****   5.METHOD
--************************************************************************************************************

--**********************************
--5.1.METHOD
--**********************************

create or replace view sc_lims_dal.METHOD
(sample_code              --Sample-code of the Parameter groups
,parameter_group          --Parameter group
,parameter_group_node     --Parameter group node
,parameter                --Parameter
,parameter_node           --Parameter-node
,method                   --method
,method_node              --method-node
,autorecalculation        --auto-recalculation
,confirm_complete         --Confirm complete
,reanalysis               --The number of times the parameter has been reanalysed for this sample
,sop                      --/SOP of the Methods
,manually_added           --/Manually added of the Methods
,manually_entered         --Manually entered of the Methods
,allow_additional_measure --Allow additional measurement of the Methods
,last_comment             --Last comment of the parameter-group
,description              --Parameter group description
,version_description      --Version Description of the Parameter 
,version                  --Version of the Parameter 
,delay_value              --Amount of time between the sampling date and the moment the parameter was assigned to the sample (value)
,delay_unit               --Amount of time between the sampling date and the moment the parameter was assigned to the sample (unit)
,result_unit              --unit
,result_value_f           --result-value
,result_value_s           --result-value-string
,result_format            --result format
,planned_executor         --Name of the person who was supposed to execute the parameter  for the sample
,executor                 --Name of the person who actually executed the parameter  for the sample
,assigned_by              --ID of the user who assigned the parameter  to the sample
,lab                      --Laboratorium
,planned_equipment        --Equipment supposed to be used for the method
,equipment                --Equipment used for the method
,real_cost                --Real cost of executing this method
,real_time                --Real time needed for executing this method
,life_cycle               --Life cycle that determines the request's status changes
,life_cycle_description   --life cycle description
,status                   --Status the sample has reached in its life cycle
,status_description       --Status the sample has reached in its life cycle (description)
)
as
select scme.sc
,      scme.pg
,      scme.pgnode 
,      scme.pa
,      scme.panode
,      scme.me
,      scme.menode
,      scme.autorecalc
,      scme.confirm_complete
,      scme.reanalysis
,      scme.sop                  --UNAPIGEN.sqlResultValue(UVSCME.SOP,'')
,      scme.manually_added
,      scme.manually_entered
,      scme.allow_add
,      scme.last_comment
,      scme.description
,      scme.mt_version    --DECODE( UNAPIGEN.IsSystem21CFR11Compliant ,'0',@Select(General Settings\Translation for Version)||UVSCME.MT_VERSION,'')
,      scme.mt_version
,      scme.delay
,      scme.delay_unit
,      scme.unit
,      scme.value_f
,      scme.value_s
,      scme.format
,      scme.planned_executor
,      scme.executor
,      scme.assigned_by
,      scme.lab
,      scme.planned_eq
,      scme.eq
,      scme.real_cost
,      scme.real_time
,      scme.lc
,      lc.description
,      scme.ss
,      ss.name
from sc_unilab_ens.utscme  scme
,    sc_unilab_ens.utss    ss
,    sc_unilab_ens.utlc    lc
where scme.ss = ss.ss
and   scme.lc = lc.lc
;
--table-comment:
comment on VIEW sc_lims_dal.METHOD is 'Contains all UNILAB-SAMPLE METHOD, all statusses, ';

--column-comment:
comment on COLUMN sc_lims_dal.METHOD.sample_code              is 'sample-code';
comment on COLUMN sc_lims_dal.METHOD.parameter_group          is 'Parameter group';
comment on COLUMN sc_lims_dal.METHOD.parameter_group_node     is 'Parameter group node';
comment on COLUMN sc_lims_dal.METHOD.parameter                is 'Parameter';
comment on COLUMN sc_lims_dal.METHOD.parameter_node           is 'Parameter-node';
comment on COLUMN sc_lims_dal.METHOD.method                   is 'method';
comment on COLUMN sc_lims_dal.METHOD.method_node              is 'method-node';
comment on COLUMN sc_lims_dal.METHOD.autorecalculation        is 'auto-recalculation';
comment on COLUMN sc_lims_dal.METHOD.confirm_complete         is 'Confirm complete';
comment on COLUMN sc_lims_dal.METHOD.reanalysis               is 'The number of times the parameter has been reanalysed for this sample';
comment on COLUMN sc_lims_dal.METHOD.sop                      is 'SOP of the Methods';
comment on COLUMN sc_lims_dal.METHOD.manually_added           is 'Manually added of the Methods';
comment on COLUMN sc_lims_dal.METHOD.manually_entered         is 'Manually entered of the Methods';
comment on COLUMN sc_lims_dal.METHOD.allow_additional_measure is 'Allow additional measurement of the Methods';
comment on COLUMN sc_lims_dal.METHOD.last_comment             is 'Last comment of the parameter-group';
comment on COLUMN sc_lims_dal.METHOD.description              is 'Parameter group description';
comment on COLUMN sc_lims_dal.METHOD.version_description      is 'Version Description of the Parameter ';
comment on COLUMN sc_lims_dal.METHOD.version                  is 'Version of the Parameter ';
comment on COLUMN sc_lims_dal.METHOD.delay_value              is 'Amount of time between the sampling date and the moment the parameter was assigned to the sample (value)';
comment on COLUMN sc_lims_dal.METHOD.delay_unit               is 'Amount of time between the sampling date and the moment the parameter was assigned to the sample (unit)';
comment on COLUMN sc_lims_dal.METHOD.result_unit              is 'unit';
comment on COLUMN sc_lims_dal.METHOD.result_value_f           is 'result-value';
comment on COLUMN sc_lims_dal.METHOD.result_value_s           is 'result-value-string';
comment on COLUMN sc_lims_dal.METHOD.result_format            is 'result format';
comment on COLUMN sc_lims_dal.METHOD.planned_executor         is 'Name of the person who was supposed to execute the parameter  for the sample';
comment on COLUMN sc_lims_dal.METHOD.executor                 is 'Name of the person who actually executed the parameter  for the sample';
comment on COLUMN sc_lims_dal.METHOD.assigned_by              is 'ID of the user who assigned the parameter  to the sample';
comment on COLUMN sc_lims_dal.METHOD.lab                      is 'Laboratorium';
comment on COLUMN sc_lims_dal.METHOD.planned_equipment        is 'Equipment supposed to be used for the method';
comment on COLUMN sc_lims_dal.METHOD.equipment                is 'Equipment used for the method';
comment on COLUMN sc_lims_dal.METHOD.real_cost                is 'Real cost of executing this method';
comment on COLUMN sc_lims_dal.METHOD.real_time                is 'Real time needed for executing this method';
comment on COLUMN sc_lims_dal.METHOD.life_cycle               is 'Life cycle that determines the requests status changes';
comment on COLUMN sc_lims_dal.METHOD.life_cycle_description   is 'life cycle description';
comment on COLUMN sc_lims_dal.METHOD.status                   is 'Status the sample has reached in its life cycle';
comment on COLUMN sc_lims_dal.METHOD.status_description       is 'Status the sample has reached in its life cycle (description)';



--**********************************
--5.2.METHOD_DATA_TIME_INFO
--**********************************

create or replace view sc_lims_dal.METHOD_DATA_TIME_INFO
(sample_code                         --sample-code
,parameter_group                     --parameter-group
,parameter_group_node                --Parameter group node
,parameter                           --parameter
,parameter_node                      --parameter-node
,method                              --method
,method_node                         --method-node
,assign_date_in_local_tz             --Date & time the parameter group was assigned to the sample, local timezone
,assign_date_in_original_tz          --Date & time the parameter group was assigned to the sample, original timezone
,exec_start_date_in_local_tz         --Date on which the analyses on the sample started, local timezone
,exec_start_date_in_original_tz      --Date on which the analyses on the sample started, original timezone
,exec_end_date_in_local_tz           --Date on which the analyses on the sample finished, local timezone
,exec_end_date_in_original_tz        --Date on which the analyses on the sample finished, original timezone
)
as
SELECT scme.sc
,      scme.pg
,      scme.pgnode
,      scme.pa
,      scme.panode
,      scme.me
,      scme.menode
,      scme.assign_date
,      scme.assign_date_tz             --to_char(@Select(Parameter group assignment\pg.Assign date in Original TZ),'tzr')
,      scme.exec_start_date
,      scme.exec_start_date_tz         --to_char(@Select(Date & time info\rq.Exec start date in Original TZ),'tzr')
,      scme.exec_end_date
,      scme.exec_end_date_tz           --to_char(@Select(Date & time info\rq.Exec end date in Original TZ),'tzr')
FROM sc_unilab_ens.UTSCME scme
;
--table-comment:
comment on VIEW sc_lims_dal.METHOD_DATA_TIME_INFO is 'Contains all UNILAB-SAMPLE METHOD date-fields';

--column-comment:
comment on COLUMN sc_lims_dal.METHOD_DATA_TIME_INFO.sample_code                      is 'sample-code';
comment on COLUMN sc_lims_dal.METHOD_DATA_TIME_INFO.parameter_group                  is 'parameter-group';
comment on COLUMN sc_lims_dal.METHOD_DATA_TIME_INFO.parameter_group_node             is 'Parameter group node';
comment on COLUMN sc_lims_dal.METHOD_DATA_TIME_INFO.parameter                        is 'parameter';
comment on COLUMN sc_lims_dal.METHOD_DATA_TIME_INFO.parameter_node                   is 'parameter-node';
comment on COLUMN sc_lims_dal.METHOD_DATA_TIME_INFO.method                           is 'method';
comment on COLUMN sc_lims_dal.METHOD_DATA_TIME_INFO.method_node                      is 'method-node';
comment on COLUMN sc_lims_dal.METHOD_DATA_TIME_INFO.assign_date_in_local_tz          is 'Date & time the parameter group was assigned to the sample, local timezone';
comment on COLUMN sc_lims_dal.METHOD_DATA_TIME_INFO.assign_date_in_original_tz       is 'Date & time the parameter group was assigned to the sample, original timezone';
comment on COLUMN sc_lims_dal.METHOD_DATA_TIME_INFO.exec_start_date_in_local_tz      is 'Date on which the analyses on the sample started, local timezone';
comment on COLUMN sc_lims_dal.METHOD_DATA_TIME_INFO.exec_start_date_in_original_tz   is 'Date on which the analyses on the sample started, original timezone';
comment on COLUMN sc_lims_dal.METHOD_DATA_TIME_INFO.exec_end_date_in_local_tz        is 'Date on which the analyses on the sample finished, local timezone';
comment on COLUMN sc_lims_dal.METHOD_DATA_TIME_INFO.exec_end_date_in_original_tz     is 'Date on which the analyses on the sample finished, original timezone';



--**********************************
--5.3.METHOD_GROUP_KEY
--**********************************

create or replace view sc_lims_dal.METHOD_GROUP_KEY
(sample_code                         --sample-code
,parameter_group                     --parameter-group
,parameter_group_node                --Parameter group node
,parameter                           --parameter
,parameter_node                      --parameter-node
,method                              --method
,method_node                         --method-node
,group_key                           --group-keys
,group_key_sequence                  --group-key-sequence 
,value                               --group-key value
)
as
select scmegk.sc
,      scmegk.pg
,      scmegk.pgnode
,      scmegk.pa
,      scmegk.panode
,      scmegk.me
,      scmegk.menode
,      scmegk.gk
,      scmegk.gkseq
,      scmegk.value
from sc_unilab_ens.utscmegk scmegk
;
--table-comment:
comment on VIEW sc_lims_dal.METHOD_GROUP_KEY is 'Contains all UNILAB-SAMPLE METHOD group-keys';

--column-comment:
comment on COLUMN sc_lims_dal.METHOD_GROUP_KEY.sample_code                      is 'sample-code';
comment on COLUMN sc_lims_dal.METHOD_GROUP_KEY.parameter_group                  is 'parameter-group';
comment on COLUMN sc_lims_dal.METHOD_GROUP_KEY.parameter_group_node             is 'Parameter group node';
comment on COLUMN sc_lims_dal.METHOD_GROUP_KEY.parameter                        is 'parameter';
comment on COLUMN sc_lims_dal.METHOD_GROUP_KEY.parameter_node                   is 'parameter-node';
comment on COLUMN sc_lims_dal.METHOD_GROUP_KEY.method                           is 'method';
comment on COLUMN sc_lims_dal.METHOD_GROUP_KEY.method_node                      is 'method-node';
comment on COLUMN sc_lims_dal.METHOD_GROUP_KEY.group_key                        is 'group-keys';
comment on COLUMN sc_lims_dal.METHOD_GROUP_KEY.group_key_sequence               is 'group-key-sequence';
comment on COLUMN sc_lims_dal.METHOD_GROUP_KEY.value                            is 'group-key value';



--**********************************
--5.4.METHOD_ATTRIBUTES
--**********************************

create or replace view sc_lims_dal.METHOD_ATTRIBUTES
(sample_code                         --sample-code
,parameter_group                     --Parameter-group
,parameter_group_node                --Parameter-group-node
,parameter                           --parameter
,parameter_node                      --parameter-node
,method                              --method
,method_node                         --method-node
,attribute                           --Attribute of the  Parametergroup attributes
,sequence                            --/Sequence of the  Parametergroup attributes
,attribute_value                     --Attribute value of the  Parametergroup attributes
)
as
select scmeau.sc
,      scmeau.pg
,      scmeau.pgnode
,      scmeau.pa
,      scmeau.panode
,      scmeau.me
,      scmeau.menode
,      scmeau.au
,      scmeau.auseq
,      scmeau.value
from sc_unilab_ens.utscmeau scmeau
;
--table-comment:
comment on VIEW sc_lims_dal.METHOD_ATTRIBUTES is 'Contains all UNILAB-SAMPLE METHOD attributes';

--column-comment:
comment on COLUMN sc_lims_dal.METHOD_ATTRIBUTES.sample_code                      is 'sample-code';
comment on COLUMN sc_lims_dal.METHOD_ATTRIBUTES.parameter_group                  is 'Parameter-group';
comment on COLUMN sc_lims_dal.METHOD_ATTRIBUTES.parameter_group_node             is 'Parameter-group-node';
comment on COLUMN sc_lims_dal.METHOD_ATTRIBUTES.parameter                        is 'parameter';
comment on COLUMN sc_lims_dal.METHOD_ATTRIBUTES.parameter_node                   is 'parameter-node';
comment on COLUMN sc_lims_dal.METHOD_ATTRIBUTES.method                           is 'method';
comment on COLUMN sc_lims_dal.METHOD_ATTRIBUTES.method_node                      is 'method-node';
comment on COLUMN sc_lims_dal.METHOD_ATTRIBUTES.attribute                        is 'Attribute of the  Parametergroup attributes';
comment on COLUMN sc_lims_dal.METHOD_ATTRIBUTES.sequence                         is 'Sequence of the  Parametergroup attributes';
comment on COLUMN sc_lims_dal.METHOD_ATTRIBUTES.attribute_value                  is 'Attribute value of the  Parametergroup attributes';



--**********************************
--5.5.METHOD_HISTORY
--**********************************

create or replace view sc_lims_dal.METHOD_HISTORY
(sample_code                         --sample-code
,parameter_group                     --Parameter-group
,parameter_group_node                --Parameter-group-node
,parameter                           --parameter
,parameter_node                      --parameter-node
,method                              --method
,method_node                         --method-node
,what                                --What of the method history
,why                                 --Why of the method History
,who                                 --Who of the method History
,logdate_in_local_tz                 --Logdate of the method History
,logdate_in_original_tz              --Logdate of the method History
,transaction                         --Transaction of the method History Details
,event                               --Event of the method History Details
)
as
select scmehs.sc
,      scmehs.pg
,      scmehs.pgnode
,      scmehs.pa
,      scmehs.panode
,      scmehs.me
,      scmehs.menode
,      scmehs.what_description
,      scmehs.why
,      scmehs.who_description
,      scmehs.logdate
,      scmehs.logdate_tz                 --to_char(@Select(Request History\rqhs.Logdate in Original TZ),'tzr')
,      scmehs.tr_seq
,      scmehs.ev_seq
from sc_unilab_ens.utscmehs  scmehs
;
--table-comment:
comment on VIEW sc_lims_dal.METHOD_HISTORY is 'Contains all UNILAB-SAMPLE METHOD mutation-log-history';

--column-comment:
comment on COLUMN sc_lims_dal.METHOD_HISTORY.sample_code                      is 'sample-code';
comment on COLUMN sc_lims_dal.METHOD_HISTORY.parameter_group                  is 'Parameter-group';
comment on COLUMN sc_lims_dal.METHOD_HISTORY.parameter_group_node             is 'Parameter-group-node';
comment on COLUMN sc_lims_dal.METHOD_HISTORY.parameter                        is 'parameter';
comment on COLUMN sc_lims_dal.METHOD_HISTORY.parameter_node                   is 'parameter-node';
comment on COLUMN sc_lims_dal.METHOD_HISTORY.method                           is 'method';
comment on COLUMN sc_lims_dal.METHOD_HISTORY.method_node                      is 'method-node';
comment on COLUMN sc_lims_dal.METHOD_HISTORY.what                             is 'What of the method history';
comment on COLUMN sc_lims_dal.METHOD_HISTORY.why                              is 'Why of the method History';
comment on COLUMN sc_lims_dal.METHOD_HISTORY.who                              is 'Who of the method History';
comment on COLUMN sc_lims_dal.METHOD_HISTORY.logdate_in_local_tz              is 'Logdate of the method History, local timezone';
comment on COLUMN sc_lims_dal.METHOD_HISTORY.logdate_in_original_tz           is 'Logdate of the method History, original timezone';
comment on COLUMN sc_lims_dal.METHOD_HISTORY.transaction                      is 'Transaction of the method History Details';
comment on COLUMN sc_lims_dal.METHOD_HISTORY.event                            is 'Event of the method History Details';

/*
--**********************************
--5.6.METHOD_HIST_DETAILS      (kan niet worden aangemaakt) 
--**********************************
--TABEL utmehsdetails WORDT NIET GESYNCHRONISEERD NAAR AWS DD. 10-05-2022 !!!!!!!

create or replace view sc_lims_dal.METHOD_HIST_DETAILS
(sample_code                         --sample-code
,parameter_group                     --parameter-group
,parameter_group_node                --parameter-group-node
,parameter                           --parameter
,parameter_node                      --parameter-node
,method                              --method
,method_node                         --method-node
,transaction                         --Transaction of the sample History Details
,event                               --Event of the sample History Details
,sequence                            --sequence-number
,details                             --Details of the SAMPLE History Details
)
as
select mehsd.rq
,      mehsd.pg
,      mehsd.pgnode
,      mehsd.pa
,      mehsd.panode
,      mehsd.me
,      mehsd.menode
,      mehsd.tr_seq
,      mehsd.ev_seq
,      mehsd.seq
,      mehsd.details
from sc_unilab_ens.utmehsdetails  mehsd
;
--table-comment:
comment on VIEW sc_lims_dal.METHOD_HIST_DETAILS is 'Contains all UNILAB-SAMPLE METHOD mutation-log-history-details';

--column-comment:
comment on COLUMN sc_lims_dal.METHOD_HIST_DETAILS.sample_code                      is 'sample-code';
comment on COLUMN sc_lims_dal.METHOD_HIST_DETAILS.parameter_group                  is 'parameter-group';
comment on COLUMN sc_lims_dal.METHOD_HIST_DETAILS.parameter_group_node             is 'parameter-group-node';
comment on COLUMN sc_lims_dal.METHOD_HIST_DETAILS.parameter                        is 'parameter';
comment on COLUMN sc_lims_dal.METHOD_HIST_DETAILS.parameter_node                   is 'parameter-node';
comment on COLUMN sc_lims_dal.METHOD_HIST_DETAILS.method                           is 'method';
comment on COLUMN sc_lims_dal.METHOD_HIST_DETAILS.method_node                      is 'method-node';
comment on COLUMN sc_lims_dal.METHOD_HIST_DETAILS.transaction                      is 'Transaction of the sample History Details';
comment on COLUMN sc_lims_dal.METHOD_HIST_DETAILS.event                            is 'Event of the sample History Details';
comment on COLUMN sc_lims_dal.METHOD_HIST_DETAILS.sequence                         is 'sequence-number';
comment on COLUMN sc_lims_dal.METHOD_HIST_DETAILS.details                          is 'Details of the SAMPLE History Details';
*/

--**********************************
--5.7.METHOD_REANALYSIS      
--**********************************

create or replace view sc_lims_dal.METHOD_REANALYSIS
(sample_code                         --sample-code
,parameter_group                     --parameter-group
,parameter_group_node                --Parameter group node
,parameter                           --parameter
,parameter_node                      --parameter-node
,method                              --method
,method_node                         --method-node
,description                         --Description of the Parameter reanalysis
,reanalysis                          --Reanalysis of the Parameter reanalysis
,result_value                        --Value of the Parameter reanalysis results
,result_value_string                 --String value of the Parameter reanalysis results
,result_unit                         --Unit of the Parameter reanalysis results
,planned_executor                    --Name of the person who was supposed to execute the parameter group reanalysis
,executor                            --Name of the person who actually executed the parameter group reanalysis
,assigned_by                         --ID of the user who assigned the parameter group reanalysis
,assign_date_in_local_tz             --Date & time the parameter group was assigned to the sample
,assign_date_in_original_tz          --Date & time the parameter group was assigned to the sample
,exec_start_date_in_local_tz         --Date on which the analyses on the sample started
,exec_start_date_in_original_tz      --Date on which the analyses on the sample started
,exec_end_date_in_local_tz           --Date on which the analyses on the sample finished
,exec_end_date_in_original_tz        --Date on which the analyses on the sample finished
,planned_equipment                   --Planned equipment of the Method reanalysis equipment
,equipment                           --Equipment of the Method reanalysis equipment
,real_cost                           --Real cost of the Method reanalysis cost & time
,real_time                           --Real time of the Method reanalysis cost & time
)
as
SELECT rscme.sc
,      rscme.pg
,      rscme.pgnode
,      rscme.pa
,      rscme.panode
,      rscme.me
,      rscme.menode
,      rscme.description
,      rscme.reanalysis
,      rscme.value_f
,      rscme.value_s
,      rscme.unit
,      rscme.planned_executor
,      rscme.executor
,      rscme.assigned_by
,      rscme.assign_date
,      rscme.assign_date_tz             --to_char(@Select(Parameter group assignment\pg.Assign date in Original TZ),'tzr')
,      rscme.exec_start_date
,      rscme.exec_start_date_tz         --to_char(@Select(Date & time info\rq.Exec start date in Original TZ),'tzr')
,      rscme.exec_end_date
,      rscme.exec_end_date_tz           --to_char(@Select(Date & time info\rq.Exec end date in Original TZ),'tzr')
,      rscme.planned_eq
,      rscme.eq
,      rscme.real_cost
,      rscme.real_time
FROM sc_unilab_ens.UTRSCME rscme
;
--table-comment:
comment on VIEW sc_lims_dal.METHOD_REANALYSIS is 'Contains all UNILAB-SAMPLE METHOD reanalysis-results';

--column-comment:
comment on COLUMN sc_lims_dal.METHOD_REANALYSIS.sample_code                      is 'sample-code';
comment on COLUMN sc_lims_dal.METHOD_REANALYSIS.parameter_group                  is 'parameter-group';
comment on COLUMN sc_lims_dal.METHOD_REANALYSIS.parameter_group_node             is 'Parameter group node';
comment on COLUMN sc_lims_dal.METHOD_REANALYSIS.parameter                        is 'parameter';
comment on COLUMN sc_lims_dal.METHOD_REANALYSIS.parameter_node                   is 'parameter-node';
comment on COLUMN sc_lims_dal.METHOD_REANALYSIS.method                           is 'method';
comment on COLUMN sc_lims_dal.METHOD_REANALYSIS.method_node                      is 'method-node';
comment on COLUMN sc_lims_dal.METHOD_REANALYSIS.description                      is 'Description of the Parameter reanalysis';
comment on COLUMN sc_lims_dal.METHOD_REANALYSIS.reanalysis                       is 'Reanalysis of the Parameter reanalysis';
comment on COLUMN sc_lims_dal.METHOD_REANALYSIS.result_value                     is 'Value of the Parameter reanalysis results';
comment on COLUMN sc_lims_dal.METHOD_REANALYSIS.result_value_string              is 'String value of the Parameter reanalysis results';
comment on COLUMN sc_lims_dal.METHOD_REANALYSIS.result_unit                      is 'Unit of the Parameter reanalysis results';
comment on COLUMN sc_lims_dal.METHOD_REANALYSIS.planned_executor                 is 'Name of the person who was supposed to execute the parameter group reanalysis';
comment on COLUMN sc_lims_dal.METHOD_REANALYSIS.executor                         is 'Name of the person who actually executed the parameter group reanalysis';
comment on COLUMN sc_lims_dal.METHOD_REANALYSIS.assigned_by                      is 'ID of the user who assigned the parameter group reanalysis';
comment on COLUMN sc_lims_dal.METHOD_REANALYSIS.assign_date_in_local_tz          is 'Date & time the parameter group was assigned to the sample';
comment on COLUMN sc_lims_dal.METHOD_REANALYSIS.assign_date_in_original_tz       is 'Date & time the parameter group was assigned to the sample';
comment on COLUMN sc_lims_dal.METHOD_REANALYSIS.exec_start_date_in_local_tz      is 'Date on which the analyses on the sample started';
comment on COLUMN sc_lims_dal.METHOD_REANALYSIS.exec_start_date_in_original_tz   is 'Date on which the analyses on the sample started';
comment on COLUMN sc_lims_dal.METHOD_REANALYSIS.exec_end_date_in_local_tz        is 'Date on which the analyses on the sample finished';
comment on COLUMN sc_lims_dal.METHOD_REANALYSIS.exec_end_date_in_original_tz     is 'Date on which the analyses on the sample finished';
comment on COLUMN sc_lims_dal.METHOD_REANALYSIS.planned_equipment                is 'Planned equipment of the Method reanalysis equipment';
comment on COLUMN sc_lims_dal.METHOD_REANALYSIS.equipment                        is 'Equipment of the Method reanalysis equipment';
comment on COLUMN sc_lims_dal.METHOD_REANALYSIS.real_cost                        is 'Real cost of the Method reanalysis cost & time';
comment on COLUMN sc_lims_dal.METHOD_REANALYSIS.real_time                        is 'Real time of the Method reanalysis cost & time';



--************************************************************************************************************
--****   6.METHOD-CELL
--************************************************************************************************************

--**********************************
--6.1.METHOD_CELL 
--**********************************

create or replace view sc_lims_dal.METHOD_CELL
(sample_code              --Sc of the Parameter groups
,parameter_group          --Parameter group
,parameter_group_node     --Parameter group node
,parameter                --Parameter
,parameter_node           --Parameter-node
,method                   --method
,method_node              --method-node
,cell                     --cell
,cell_node                --cell-node
,multi_select             --Multi select of the Method cells
,calculation_formula      --Calculation formula
,calculation_type         --Calculation type
,equipment                --Equipment used for the method
,alignment                --Alignment (alignment of text in cell)
,cell_type                --Cell type
,pos_x                    --Pos X (X position of cell in methodsheet)
,pos_y                    --Pos Y (Y position of cell in method sheet)
,valid_cf                 --Valid cf of the Method cells
,display_title            --Description of cells in method sheet
,result_unit              --unit
,result_value_f           --result-value
,result_value_s           --result-value-string
,result_format            --result format
)
as
select scme.sc
,      scme.pg
,      scme.pgnode 
,      scme.pa
,      scme.panode
,      scme.me
,      scme.menode
,      scme.cell
,      scme.cellnode
,      scme.multi_select
,      scme.calc_formula
,      scme.calc_tp
,      scme.eq
,      scme.align
,      scme.cell_tp
,      scme.pos_x
,      scme.pos_y
,      scme.valid_cf
,      scme.dsp_title
,      scme.unit
,      scme.value_f
,      scme.value_s
,      scme.format
from sc_unilab_ens.utscmecell  scme
;
--table-comment:
comment on VIEW sc_lims_dal.METHOD_CELL is 'Contains all UNILAB-SAMPLE METHOD cell results';

--column-comment:
comment on COLUMN sc_lims_dal.METHOD_CELL.sample_code              is 'sample-code';
comment on COLUMN sc_lims_dal.METHOD_CELL.parameter_group          is 'Parameter group';
comment on COLUMN sc_lims_dal.METHOD_CELL.parameter_group_node     is 'Parameter group node';
comment on COLUMN sc_lims_dal.METHOD_CELL.parameter                is 'Parameter';
comment on COLUMN sc_lims_dal.METHOD_CELL.parameter_node           is 'Parameter-node';
comment on COLUMN sc_lims_dal.METHOD_CELL.method                   is 'method';
comment on COLUMN sc_lims_dal.METHOD_CELL.method_node              is 'method-node';
comment on COLUMN sc_lims_dal.METHOD_CELL.cell                     is 'cell';
comment on COLUMN sc_lims_dal.METHOD_CELL.cell_node                is 'cell-node';
comment on COLUMN sc_lims_dal.METHOD_CELL.multi_select             is 'Multi select of the Method cells';
comment on COLUMN sc_lims_dal.METHOD_CELL.calculation_formula      is 'Calculation formula';
comment on COLUMN sc_lims_dal.METHOD_CELL.calculation_type         is 'Calculation type';
comment on COLUMN sc_lims_dal.METHOD_CELL.equipment                is 'Equipment used for the method';
comment on COLUMN sc_lims_dal.METHOD_CELL.alignment                is 'Alignment (alignment of text in cell)';
comment on COLUMN sc_lims_dal.METHOD_CELL.cell_type                is 'Cell type';
comment on COLUMN sc_lims_dal.METHOD_CELL.pos_x                    is 'Pos X (X position of cell in methodsheet)';
comment on COLUMN sc_lims_dal.METHOD_CELL.pos_y                    is 'Pos Y (Y position of cell in method sheet)';
comment on COLUMN sc_lims_dal.METHOD_CELL.valid_cf                 is 'Valid cf of the Method cells';
comment on COLUMN sc_lims_dal.METHOD_CELL.display_title            is 'Description of cells in method sheet';
comment on COLUMN sc_lims_dal.METHOD_CELL.result_unit              is 'unit';
comment on COLUMN sc_lims_dal.METHOD_CELL.result_value_f           is 'result-value';
comment on COLUMN sc_lims_dal.METHOD_CELL.result_value_s           is 'result-value-string';
comment on COLUMN sc_lims_dal.METHOD_CELL.result_format            is 'result format';





--einde script



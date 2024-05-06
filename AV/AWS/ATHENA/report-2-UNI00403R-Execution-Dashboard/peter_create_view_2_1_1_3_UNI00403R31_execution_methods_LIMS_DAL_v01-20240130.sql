--*******************************************************************************
--REPORT:  UNI00403R-execution-dashboard
--*******************************************************************************
--tbv 
DROP VIEW sc_lims_dal.av_execution_db_methods;
--
CREATE OR REPLACE VIEW sc_lims_dal.av_execution_db_methods
(equipment_type                     --USED FOR HIGHEST GROUPING in report
,methodclass_description             --USED FOR SECOND GROUPING in report
,request_code
, request_description
, request_priority
, request_status
, request_status_name
, request_executionweek
, request_required_ready_date
, request_days_till_due
, sample_code
, sample_description
, sample_start_date
, sample_target_end_date
, context
, method_code
, method_menode
, method_description
, method_status
, method_status_name
, me_is_relevant
, user_group
, sample_priority
, part_no
, methodcell
, methodcell_tm_position
, importid
)
as
select eq.equipment_type          --USED FOR HIGHEST GROUPING in report
,      at.description             --USED FOR SECOND GROUPING in report
,      rq.rq	            as request_code
,      rq.description       as request_description
,      rq.priority          as request_priority
,      rq.ss                as request_status
,      rqss.name            as request_status_name
,      rqwk.rqexecutionweek as request_executionweek
,      rq.date1             as request_required_ready_date
,      cast( (trunc(rq.date1) - trunc(sysdate)) as decimal )   as request_days_till_due
,      sc.sc                as sample_code
,      sc.description       as sample_description
,      sc.date5             as sample_start_date
,      sc.date2             as sample_target_end_date
,      con.context          as context
,      me.me                as method_code
,      me.menode            as method_menode
,      me.description       as method_description
,      me.ss                as method_status
,      mess.name            as method_status_name
,      megk.me_is_relevant
,      ugrp.user_group
,      mepr.scpriority      as sample_priority
,      mepa.part_no         as part_no
,      mepos.dsp_title      as methodcell
,      mepos.value_s        as methodcell_tm_position
,      imp.importid         as importid
from  utsc  sc
left outer join utrq        rq   on rq.rq = sc.rq
left outer join utss        rqss on rqss.ss = rq.ss
left outer join utrqgkrqexecutionweek rqwk   on rqwk.rq = rq.rq  --and rqwk.rq = 'RqExecutionWeek' 
inner join utscgkcontext   con   on con.sc = sc.sc
inner join utscme           me   on me.sc = sc.sc
inner join atavmethodclass  at   on ( at.mtpos1 = substring(me.me, 1,1) and at.show = '1')
inner join utss           mess   on mess.ss = me.ss 
inner Join utscmegkme_is_relevant megk  on (    megk.sc = me.sc
                                           and  megk.pg = me.pg
  				                           and  megk.pgnode = me.pgnode
					                       and  megk.pa     = me.pa
					                       and  megk.panode = me.panode
					                       and  megk.me     = me.me
					                       and  megk.menode = me.menode
					                       )
left outer join  utscmegkequipment_type eq on ( eq.sc = me.sc
                                           and  eq.pg = me.pg
  				                           and  eq.pgnode = me.pgnode
					                       and  eq.pa     = me.pa
					                       and  eq.panode = me.panode
					                       and  eq.me     = me.me
					                       and  eq.menode = me.menode
					                       ) 
left outer join  utscmegkuser_group	 ugrp on (  ugrp.sc = me.sc
                                           and  ugrp.pg = me.pg
  				                           and  ugrp.pgnode = me.pgnode
					                       and  ugrp.pa     = me.pa
					                       and  ugrp.panode = me.panode
					                       and  ugrp.me     = me.me
					                       and  ugrp.menode = me.menode
					                       ) 									   
left outer join utscmegkscpriority	 mepr  on (  mepr.sc = me.sc
                                           and  mepr.pg = me.pg
  				                           and  mepr.pgnode = me.pgnode
					                       and  mepr.pa     = me.pa
					                       and  mepr.panode = me.panode
					                       and  mepr.me     = me.me
					                       and  mepr.menode = me.menode
					                       )	
left outer join utscmegkpart_no      mepa on (	mepa.sc = me.sc
                                           and  mepa.pg = me.pg
  				                           and  mepa.pgnode = me.pgnode
					                       and  mepa.pa     = me.pa
					                       and  mepa.panode = me.panode
					                       and  mepa.me     = me.me
					                       and  mepa.menode = me.menode
					                       )	
left outer join utscmegkimportid     imp  on (	imp.sc = me.sc
                                           and  imp.pg = me.pg
  				                           and  imp.pgnode = me.pgnode
					                       and  imp.pa     = me.pa
					                       and  imp.panode = me.panode
					                       and  imp.me     = me.me
					                       and  imp.menode = me.menode
					                       )	
left outer join utscmecell         mepos  on (   mepos.sc   = me.sc
                                           and  mepos.pg     = me.pg
  				                           and  mepos.pgnode = me.pgnode
					                       and  mepos.pa     = me.pa
					                       and  mepos.panode = me.panode
					                       and  mepos.me     = me.me
					                       and  mepos.menode = me.menode
                                           and  mepos.CELL   = 'TM_position'
                                           )										   
--inner join utmt                      mt on ( mt.mt = me.me and mt.version = me.mt_version and mt.version_is_current = '1' )
where sc.sc not in (select itsc.sc from utscgkistest  itsc  where itsc.sc = sc.sc and itsc.istest = '1' )
and   rq.rq not in (select itrq.rq from utrqgkistest  itrq  where itrq.rq = rq.rq and itrq.istest = '1' )
and   rq.ss in ( 'AV', '@P', 'SU')
and   me.ss in ( 'AV', '@P', 'IE', 'OS', 'OW', 'WA', 'ER')
--and   sc.rq           like 'AMM2350082T'  
--and   ugrp.user_group    = 'Physical lab'   --'Chemical lab' 
;						 


--
grant all on  sc_lims_dal.av_execution_db_methods   to usr_rna_readonly1;


--TEST-QUERY
select * 
from av_execution_db_methods m
where m.user_group = 'Physical lab'  




--**************************************************
--vervolg-query for EQUIPMENT
select user_group
,      context
,      method_status
,      equipment_type 
,      sum(method_code)
from av_execution_db_methods
WHERE user_group                  = 'Physical lab'
--and   methodclass_description     = 'PV RnD'
and   method_status    = '@P'
and   context          = 'Production' 
group by user_group
,      methodclass_description 
,      context
,      method_status
,      equipment_type 
;




--END script



--*******************************************************************************
--REPORT:  UNI00403R-execution-dashboard
--     2.3.1	UNI00403R3_methods
--*******************************************************************************
--also  used from REPORT [REQUEST OVERVIEW AND RESULTS] for indoor-testing:
-- 

DROP VIEW  sc_lims_dal.av_exec_db_pending_methods;
--
CREATE OR REPLACE VIEW sc_lims_dal.av_exec_db_pending_methods
(user_profile
, user_profile_descr
, user_group
, user_group_value
, user_class_au
, user_class_value
, user_prof_lab
, equipment_type
, methodclass_description
, request_code
, request_description
, request_priority
, request_status
, request_status_name
, request_executionweek
, request_required_ready_date
, request_days_till_due
, request_weeks_till_due
, request_overdue
, rq_prio1_lt_1wk_due
, rq_prio2_lt_1wk_due
, rq_prio3_lt_1wk_due
, sample_code
, sample_description
, sample_start_date
, sample_target_end_date
, sample_status
, sample_status_name
, context
, avtest_method
, avtest_method_description
, method_parameter_group
, method_parameter
, method_code
, method_menode
, method_description
, method_status
, method_status_name
, method_equipment
, method_is_relevant
, method_user_group
, sample_priority
, part_no
, methodcell
, methodcell_tm_position
, method_importid
)
as
select DISTINCT prof.up        AS USER_PROFILE
,      prof.description        as user_profile_descr
,      ug.au                   as user_group
,      ug.value                as user_group_value
,      uc.au                   as user_class_au
,      uc.value                as user_class_value
,      me.lab               as user_prof_lab
,      eq.equipment_type    as equipment_type              --USED FOR HIGHEST GROUPING in report
,      at.description       as methodclass_description      --USED FOR SECOND GROUPING in report
,      rq.rq	            as request_code
,      rq.description       as request_description
,      rq.priority          as request_priority
,      rq.ss                as request_status
,      rqss.name            as request_status_name
,      rqwk.rqexecutionweek as request_executionweek
,      rq.date1             as request_required_ready_date
,      cast( (trunc(rq.date1) - trunc(sysdate)) as decimal )                      as request_days_till_due
,      cast(  mod( cast( trunc( cast(trunc(rq.date1)-trunc(sysdate) as integer) / 7) as integer), 7 ) as decimal )    as request_weeks_till_due
,	   CASE WHEN rq.date1 IS NOT NULL AND rq.date1 < TRUNC(SYSDATE)                                                             THEN rq.rq ELSE NULL END AS rq_overdue
,	   CASE WHEN rq.priority in (1) and (rq.date1 IS NOT NULL AND rq.date1 >= TRUNC(SYSDATE) AND rq.date1 < TRUNC(SYSDATE) + 7) THEN rq.rq ELSE NULL END AS rq_prio1_lt_1wk_due
,	   CASE WHEN rq.priority in (2) and (rq.date1 IS NOT NULL AND rq.date1 >= TRUNC(SYSDATE) AND rq.date1 < TRUNC(SYSDATE) + 7) THEN rq.rq ELSE NULL END AS rq_prio2_lt_1wk_due
,	   CASE WHEN rq.priority in (3) and (rq.date1 IS NOT NULL AND rq.date1 >= TRUNC(SYSDATE) AND rq.date1 < TRUNC(SYSDATE) + 7) THEN rq.rq ELSE NULL END AS rq_prio3_lt_1wk_due
,      sc.sc                as sample_code
,      sc.description       as sample_description
,      sc.date5             as sample_start_date
,      sc.date2             as sample_target_end_date
,      sc.ss                as sample_status
,      scss.name            as sample_status_name
,      con.context          as context
,      pau.value            as avtest_method
,      pau2.value           as avtest_method_description
,      me.pg                as method_parameter_group
,      me.pa                as method_parameter
,      me.me                as method_code
,      me.menode            as method_menode
,      me.description       as method_description
,      me.ss                as method_status
,      mess.name            as method_status_name
,      e.equipement         as method_equipment
,      megk.me_is_relevant  as method_is_relevant
,      meug.user_group      as method_user_group
,      mepr.scpriority      as sample_priority
,      mepa.part_no         as part_no
,      mepos.dsp_title      as methodcell
,      mepos.value_s        as methodcell_tm_position
,      imp.importid         as method_importid
from        utup              prof
--INNER JOIN  utupus              us on ( us.up   = prof.up)
INNER JOIN  utupau              ug ON ( ug.up = prof.up    and ug.au = 'user_group')
INNER JOIN  utupau              uc ON ( uc.up = ug.up      AND uc.version = ug.version     AND uc.au = 'avUpClass' AND uc.value = 'Execution' )
--LEFT OUTER JOIN utupuspref    pref ON ( pref.up = prof.up  AND pref.version = prof.version AND pref.pref_name = 'lab' )
--LEFT OUTER JOIN utuppref      dprf ON ( dprf.up = prof.up  AND dprf.version = prof.version AND dprf.pref_name = 'lab' )
INNER JOIN utscmegkuser_group meug ON (meug.user_group = ug.value )  
INNER JOIN utscme  me  ON (	  me.SC     = meug.SC
					      AND me.PG     = meug.PG
					      AND me.PGNODE = meug.PGNODE
					      AND me.PA     = meug.PA
					      AND me.PANODE = meug.PANODE
					      AND me.ME     = meug.ME
					      AND me.MENODE = meug.MENODE
					      --AND (	    (pref.pref_value IS NOT NULL AND pref.pref_value = me.lab)
 						  --       OR (dprf.pref_value IS NOT NULL AND dprf.pref_value = me.lab)
 						  --       OR (pref.pref_value IS NULL     AND dprf.pref_value IS NULL       AND NULLIF(me.lab, '-') IS NULL)
   						  --    )
					      )
inner join atavmethodclass      at  on ( at.mtpos1 = substring(me.me, 1, 1) and at.show = '1')
inner join utss               mess  on ( mess.ss  = me.ss )
INNER JOIN      utsc            sc  ON (sc.sc     = me.sc)
INNER JOIN      utss           scss  ON (sc.ss    = scss.ss)
LEFT OUTER JOIN utrq             rq ON (sc.rq     = rq.rq   AND  rq.ss in ( 'AV', '@P', 'SU') )
LEFT OUTER JOIN utss           rqss ON (rq.ss     = rqss.ss) 
left outer join utrqgkrqexecutionweek  rqwk on rqwk.rq = rq.rq  --and rqwk.rq = 'RqExecutionWeek' 
LEFT OUTER JOIN utscgkcontext          con  ON (con.sc = sc.sc )
JOIN            utscpaau pau  on (pau.sc  = me.sc and pau.pg  = me.pg and pau.pgnode  = me.pgnode and pau.pa  = me.pa and pau.panode = me.panode  and pau.au = 'avTestMethod' )
LEFT OUTER JOIN utscpaau pau2 on (pau2.sc = sc.sc and pau2.pg = me.pg and pau2.pgnode = me.pgnode and pau2.pa = me.pa and pau2.pgnode = me.pgnode and pau2.au = 'avTestMethodDesc' )
inner Join utscmegkme_is_relevant     megk  on (    megk.sc = me.sc
                                           and  megk.pg     = me.pg
  				                           and  megk.pgnode = me.pgnode
					                       and  megk.pa     = me.pa
					                       and  megk.panode = me.panode
					                       and  megk.me     = me.me
					                       and  megk.menode = me.menode
					                       )
left outer join  utscmegkequipment_type eq on ( eq.sc     = me.sc
                                           and  eq.pg     = me.pg
  				                           and  eq.pgnode = me.pgnode
					                       and  eq.pa     = me.pa
					                       and  eq.panode = me.panode
					                       and  eq.me     = me.me
					                       and  eq.menode = me.menode
					                       ) 
left outer join  utscmegkequipement      e on ( e.sc     = me.sc
                                           and  e.pg     = me.pg
  				                           and  e.pgnode = me.pgnode
					                       and  e.pa     = me.pa
					                       and  e.panode = me.panode
					                       and  e.me     = me.me
					                       and  e.menode = me.menode
					                       ) 
left outer join utscmegkscpriority	 mepr  on (  mepr.sc    = me.sc
                                           and  mepr.pg     = me.pg
  				                           and  mepr.pgnode = me.pgnode
					                       and  mepr.pa     = me.pa
					                       and  mepr.panode = me.panode
					                       and  mepr.me     = me.me
					                       and  mepr.menode = me.menode
					                       )	
left outer join utscmegkpart_no      mepa on (	mepa.sc     = me.sc
                                           and  mepa.pg     = me.pg
  				                           and  mepa.pgnode = me.pgnode
					                       and  mepa.pa     = me.pa
					                       and  mepa.panode = me.panode
					                       and  mepa.me     = me.me
					                       and  mepa.menode = me.menode
					                       )	
left outer join utscmegkimportid     imp  on (	imp.sc     = me.sc
                                           and  imp.pg     = me.pg
  				                           and  imp.pgnode = me.pgnode
					                       and  imp.pa     = me.pa
					                       and  imp.panode = me.panode
					                       and  imp.me     = me.me
					                       and  imp.menode = me.menode
					                       )	
left outer join utscmecell         mepos  on (   mepos.sc    = me.sc
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
--and   rq.ss in ( 'AV', '@P', 'SU')
and   me.ss in ( 'AV', '@P', 'IE', 'OS', 'OW', 'WA', 'ER')
;
--and   sc.rq           like 'AMM2350082T'  
--AND   sc.sc = '2405002471'
--and   meug.user_group    = 'Physical lab'   --'Chemical lab' 
--and   me.lab      = 'PV RnD'
--and   con.context = 'Production'
--and   me.ss = '@P'
						 
grant all on  sc_lims_dal.av_exec_db_pending_methods   to usr_rna_readonly1;



--TEST-QUERY
--LETOP: DOOR DUBBELING VAN PROFILE KOMEN ALLE REQUEST/SAMPLE/METHOD-COMBINATIONS DUBBEL VOOR !!!
--DUS ALTIJD SELECT DISITNCT GEBRUIKEN, EN PROFILE UIT QUERY WEGLATEN !!!!!!!!!!

select user_group_value
,      user_prof_lab
,      equipment_type 
,      context
,      x_label
,       count(*)   as y_label
FROM (
select 'Overdue'         as x_label
,      user_group_value
,      user_prof_lab
,      equipment_type 
,      context
,      request_priority
,      method_status
from av_exec_db_pending_methods m
where m.request_overdue is not null
UNION all
select 'Prio-' || request_priority   x_label
,      user_group_value
,      user_prof_lab
,      equipment_type 
,      context
,      request_priority
,      method_status
from av_exec_db_pending_methods m
where m.request_overdue is null
AND   m.request_days_till_due <= 7
UNION ALL
select 'Wk +'||m.request_weeks_till_due||'/pr-'||m.request_priority   as x_label
,      user_group_value
,      user_prof_lab
,      equipment_type 
,      context
,      request_priority
,      method_status
from av_exec_db_pending_methods m
where m.request_overdue is null
and   m.request_priority = 3
AND   m.request_days_till_due > 7
AND   m.request_weeks_till_due is not null
)
where user_group_value = 'Chemical lab'
and   user_prof_lab    = 'PV RnD'
and   context          = 'Trials' 
and   equipment_type   = 'RnD GC/MS'
group by user_group_value
,      user_prof_lab
,      equipment_type 
,      context
,      x_label
;


/*
Prio-3	    3
Overdue  	6
Wk +2/pr-3	9
*/





--TEST-QUERY INDOOR-TESTING:
--LETOP: DOOR DUBBELING VAN PROFILE KOMEN ALLE REQUEST/SAMPLE/METHOD-COMBINATIONS DUBBEL VOOR !!!
--DUS ALTIJD SELECT DISITNCT GEBRUIKEN, EN PROFILE UIT QUERY WEGLATEN !!!!!!!!!!
select * 
from av_exec_db_pending_methods m
where user_group_value = 'Indoor testing'            --INCLUDING PROFILE: "Tyre testing std" + "Tyre mounting std"
--and   user_prof_lab    = 'Chennai'                   --Chennai, Enschede, Gyongyos, PV RnD, Unspecified
--and   equipment_type = 'Burst pressure'            --PCT drum testing, PCT High speed, Tyre mounting, Tyre dimensions
--and   context          = 'Production'                --Production, Trials
--and   method_status    = '@P'




--**************************************************
--vervolg-query for REQUEST-CODE
select user_group_value
,      user_prof_lab
,      equipment_type 
,      context
,      request_status
,      method_status
,      request_priority
,      COUNT(method_code)
from av_exec_db_pending_methods
where user_group_value = 'Chemical lab'
and   user_prof_lab    = 'PV RnD'
and   context          = 'Trials' 
and   equipment_type   = 'RnD GC/MS'
GROUP BY user_group_value
,      user_prof_lab
,      equipment_type 
,      context
,      request_status
,      method_status
,      request_priority
;


/*
Chemical lab	PV RnD	RnD GC/MS	Trials	AV	AV	3	44
Chemical lab	PV RnD	RnD GC/MS	Trials	@P	@P	3	129
Chemical lab	PV RnD	RnD GC/MS	Trials		@P		67
*/




--END script



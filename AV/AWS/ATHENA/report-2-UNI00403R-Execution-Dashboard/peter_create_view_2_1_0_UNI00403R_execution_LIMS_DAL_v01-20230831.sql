--*******************************************************************************
--REPORT:  UNI00403R-execution-dashboard
--*******************************************************************************

--*****************************************************************
--Filter labs
--*****************************************************************
DROP VIEW sc_lims_dal.av_execution_dashboard_labs;
--
--Filter all Execution-labs (via user-/userprofile-prefs)
CREATE OR REPLACE VIEW sc_lims_dal.av_execution_dashboard_labs
(pref_name
,lab_description
,user_profile
,user_profile_description
,user_id
,user_name
,user_email
)
as
SELECT pref.pref_name
,      pref.pref_value
,      prof.up
,      prof.description
,      uprof.us
,      ad.person
,      ad.email
FROM UTUP  prof
INNER JOIN UTUPUS uprof  ON uprof.up = prof.up
INNER JOIN UTAD      ad  on ad.ad    = uprof.us
INNER JOIN UTUPAU usrgrp on ( usrgrp.up = uprof.up and usrgrp.version = uprof.version )
LEFT OUTER JOIN UTUPUSPREF pref on (   pref.up = uprof.up
                                   and pref.version    = uprof.version
								   and pref.us         = uprof.us
								   and pref.us_version = uprof.us_version
								   and pref.pref_name  = 'lab' 
								   )
LEFT OUTER JOIN UTUPPREF dprf on (   dprf.up = uprof.up
                                 and dprf.version = uprof.version
                                 and dprf.pref_name = 'lab' 								 
								 )
where prof.version_is_current = 1
and   usrgrp.VALUE = 'Execution' 
--and   uprof.us = 'PGO' 
--and   pref.pref_value='PV RnD' 
ORDER BY prof.up
;

--
grant all on  sc_lims_dal.av_execution_dashboard   to usr_rna_readonly1;

select l.pref_name
,      l.lab_description
,      l.user_profile
,      l.user_profile_description
from av_execution_dashboard_labs l
where l.user_name like '%Schepens%'
;


--*****************************************************************
--query results execution-dashboard
--*****************************************************************
--tbv 
DROP VIEW sc_lims_dal.av_execution_dashboard;
--
CREATE OR REPLACE VIEW sc_lims_dal.av_execution_dashboard
(user_profile
,user_profile_descr
,user_group
,user_group_value
,user_class_au
,user_class_value
,user_name
,user_prof_lab
,default_prof_lab
,method_status
,method_status_name
,sample_status
,sample_status_name
,sample_priority
,sample_code_prio_lessthan_4
,sample_code_prio_lessthan_3
,sample_code_prio_equal_1
,sample_context
,sample_code
,request_status
,request_status_name
,request_priority
,request_code_required_ready
,request_code_overdue
,request_code_due_1wk
,request_code_due_2wk
,request_code_due_greatthan_2wk
,request_code_prio_lessthan_4
,request_code_prio_lessthan_3
,request_code_prio_equal_1
,request_exec_week
,this_week
,request_code
,method_count
)
as
SELECT prof.up
,      prof.description
,      user_group.au      user_group_au
,      user_group.value   user_group_value
,      user_class.au      user_class_au
,      user_class.value   user_class_value
,      us.us              user_name
,	COALESCE(pref.pref_value, dprf.pref_value,'-' )   AS prof_lab
,	COALESCE(pref.pref_value, dprf.pref_value, '-')   AS prof_lab2
,	utscme.ss     AS me_ss
,   ss_me.name    AS me_ss_name
,	utsc.ss       AS sc_ss
,   ss_sc.name    AS sc_ss_name
,   utsc.priority AS sc_priority
,	CASE WHEN utsc.priority = 3 THEN utsc.sc ELSE NULL END AS sc_prio_lt_4
,	CASE WHEN utsc.priority = 2 THEN utsc.sc ELSE NULL END AS sc_prio_lt_3
,	CASE WHEN utsc.priority = 1 THEN utsc.sc ELSE NULL END AS sc_prio_eq_1
,	sccontext.context        AS sc_context
,	utsc.sc                  AS sample_code
,	utrq.ss                  AS rq_ss
,   ss_rq.name               AS rq_ss_name
,   utrq.priority            AS rq_priority
,	CAST(utrq.date1 AS date) AS rq_reqd_ready
,	CASE WHEN utrq.date1 IS NOT NULL AND utrq.date1 < TRUNC(SYSDATE)                                           THEN utrq.rq ELSE NULL END AS rq_overdue
,	CASE WHEN utrq.date1 IS NOT NULL AND utrq.date1 >= TRUNC(SYSDATE) AND utrq.date1 < TRUNC(SYSDATE) + 7      THEN utrq.rq ELSE NULL END AS rq_due_1wk
,	CASE WHEN utrq.date1 IS NOT NULL AND utrq.date1 >= TRUNC(SYSDATE) + 7 AND utrq.date1 < TRUNC(SYSDATE) + 14 THEN utrq.rq ELSE NULL END AS rq_due_2wk           
,	CASE WHEN utrq.date1 IS NOT NULL AND utrq.date1 >= TRUNC(SYSDATE) + 14                                     THEN utrq.rq ELSE NULL END AS rq_due_greaterthan_2wk               --++LATE_D = 14
,	CASE WHEN utrq.priority = 3 THEN utrq.rq ELSE NULL END AS rq_prio_lt_4
,	CASE WHEN utrq.priority = 2 THEN utrq.rq ELSE NULL END AS rq_prio_lt_3
,	CASE WHEN utrq.priority = 1 THEN utrq.rq ELSE NULL END AS rq_prio_eq_1
,	rqexecwk.RqExecutionWeek          AS rq_exec_week
,	CAST( to_char( SYSDATE, 'IW') AS DECIMAL ) AS this_week
,	utrq.rq
,	COUNT(DISTINCT utscme.me)         AS me_count
FROM  utup   prof
INNER JOIN  utupus us          on (us.up   = prof.up)
INNER JOIN  utupau user_group  ON (user_group.up = prof.up  and user_group.au = 'user_group')
INNER JOIN  utupau user_class ON (	user_class.up      = user_group.up
								AND user_class.version = user_group.version
								AND user_class.au      = 'avUpClass'
								AND user_class.value   = 'Execution'                    --> komt alleen bij "Chemical lab" + "Physical lab" voor, niet bij application-management !!!
								)
LEFT OUTER JOIN utupuspref pref ON (	pref.up = prof.up
									AND pref.version = prof.version
									AND pref.pref_name = 'lab'
									--AND pref.us = 'PGO'  --'PSC'    --'++USER_ID'
									)
LEFT OUTER JOIN utuppref dprf ON (	dprf.up	= prof.up
								AND dprf.version = prof.version
								AND dprf.pref_name = 'lab'
								)
INNER JOIN utscmegkuser_group   me_user_group   ON (me_user_group.user_group = user_group.value )  
INNER JOIN utscme ON (	utscme.SC     = me_user_group.SC
					AND utscme.PG     = me_user_group.PG
					AND utscme.PGNODE = me_user_group.PGNODE
					AND utscme.PA     = me_user_group.PA
					AND utscme.PANODE = me_user_group.PANODE
					AND utscme.ME     = me_user_group.ME
					AND utscme.MENODE = me_user_group.MENODE
					AND (	(pref.pref_value IS NOT NULL AND pref.pref_value = utscme.lab)
						OR	(dprf.pref_value IS NOT NULL AND dprf.pref_value = utscme.lab)
						OR	(pref.pref_value IS NULL     AND dprf.pref_value IS NULL       AND NULLIF(utscme.lab, '-') IS NULL)
						)
					)
INNER JOIN      utss ss_me ON (utscme.ss = ss_me.ss)
INNER JOIN      utsc       ON (utscme.sc = utsc.sc)
INNER JOIN      utss ss_sc ON (utsc.ss   = ss_sc.ss)
LEFT OUTER JOIN utrq       ON (utsc.rq = utrq.rq)
LEFT OUTER JOIN utss ss_rq ON (utrq.ss = ss_rq.ss) 
LEFT OUTER JOIN utscgkcontext         sccontext ON (sccontext.sc = utsc.sc )
LEFT OUTER JOIN utrqgkRqExecutionWeek rqexecwk  ON (rqexecwk.rq  = utrq.rq  AND rqexecwk.RqExecutionWeek = to_char(SYSDATE, 'FMIW') )
where prof.version_is_current = '1' 
--and user_group.au = 'user_group'
--AND user_group.value = 'Chemical lab'  -- '++USER_GROUP'
AND (	utscme.ss IN ('AV', '@P', 'IE', 'OS', 'OW', 'WA', 'ER')
	OR	(   utscme.ss = 'CM' 
	    AND utsc.ss IN ('OS', 'OW')
		)
    )
AND (  utrq.ss IN ('AV', '@P', 'SU') 
    OR utsc.rq IS NULL
	)
AND NOT EXISTS (SELECT 1
				FROM utrqgkistest rqistest
				WHERE rqistest.rq = utrq.rq
				AND rqistest.istest = '1'
				)
AND NOT EXISTS (SELECT 1
				FROM utscgkistest scistest
				WHERE scistest.sc = utsc.sc
				AND scistest.istest = '1'
				)
AND NOT EXISTS (SELECT 1
				FROM utscmegkme_is_relevant merelv
				WHERE utscme.sc		= merelv.sc
				AND utscme.pg		= merelv.pg
				AND utscme.pgnode	= merelv.pgnode
				AND utscme.pa		= merelv.pa
				AND utscme.panode	= merelv.panode
				AND utscme.me		= merelv.me
				AND utscme.menode	= merelv.menode
				AND merelv.me_is_relevant	= '0'
				)	
GROUP BY prof.up
,        prof.description
,      user_group.au
,      user_group.value
,      user_class.au   
,      user_class.value
--     pref.us
,     us.us
--,	COALESCE(NULLIF(pref.pref_value, '-'), NULLIF(dprf.pref_value, '-')) 
--,	COALESCE(NULLIF(pref.pref_value, '-'), NULLIF(dprf.pref_value, '-'), 'NULL') 
,	COALESCE(pref.pref_value, dprf.pref_value,'-' )   
,	COALESCE(pref.pref_value, dprf.pref_value, '-')   
,	utscme.ss     
,   ss_me.name    
,	utsc.ss       
,   ss_sc.name    
,   utsc.priority 
,	CASE WHEN utsc.priority = 3 THEN utsc.sc ELSE NULL END 
,	CASE WHEN utsc.priority = 2 THEN utsc.sc ELSE NULL END 
,	CASE WHEN utsc.priority = 1 THEN utsc.sc ELSE NULL END 
,	sccontext.context        
,	utsc.sc
,	utrq.ss                  
,   ss_rq.name               
,   utrq.priority            
,	CAST(utrq.date1 AS date) 
,	CASE WHEN utrq.date1 IS NOT NULL AND utrq.date1  < TRUNC(SYSDATE)                                          THEN utrq.rq ELSE NULL END                                                
,	CASE WHEN utrq.date1 IS NOT NULL AND utrq.date1 >= TRUNC(SYSDATE) AND utrq.date1 < TRUNC(SYSDATE) + 7      THEN utrq.rq ELSE NULL END           
,	CASE WHEN utrq.date1 IS NOT NULL AND utrq.date1 >= TRUNC(SYSDATE) + 7 AND utrq.date1 < TRUNC(SYSDATE) + 14 THEN utrq.rq ELSE NULL END     --++LATE_D = 14
,	CASE WHEN utrq.date1 IS NOT NULL AND utrq.date1 >= TRUNC(SYSDATE) + 14                                     THEN utrq.rq ELSE NULL END     --++LATE_D = 14
,	CASE WHEN utrq.priority = 3 THEN utrq.rq ELSE NULL END 
,	CASE WHEN utrq.priority = 2 THEN utrq.rq ELSE NULL END 
,	CASE WHEN utrq.priority = 1 THEN utrq.rq ELSE NULL END 
,	rqexecwk.RqExecutionWeek          
,   CAST( to_char( SYSDATE, 'IW') AS DECIMAL ) 
,	utrq.rq
ORDER BY utrq.rq
,        sccontext.context
,        utsc.sc
,        utscme.ss
;

--
grant all on  sc_lims_dal.av_execution_dashboard   to usr_rna_readonly1;


/*
--query for requests...
select * from utupus where US = 'PSC'
26	0	PSC	0
5	0	PSC	0
1	0	PSC	0
7	0	PSC	0

select * from utuppref where up in (1,5,7,26)  and pref_name='lab' ;
5	0	lab	1	PV RnD	0
7	0	lab	1	PV RnD	0
26	0	lab	1	Chennai	0

select * from utupuspref where up in (1,5,7,26) and us = 'PSC';
1	0	PSC	0	lab	1	PV RnD	0
26	0	PSC	0	lab	1	PV RnD	0

select * from UTUpAU where up in (1,26)
26	0	avUpClass		1	Development
26	0	user_group		2	Construction PCT
1	0	avUpClass		1	Application management
1	0	user_group		2	Application management



--**************************************************
--overall query voor REQUESTS...
select this_week
,      user_name
,      user_group_value
,      count(distinct request_code_prio_equal_1)       AS rq_prio_1
,      count(distinct request_code_prio_lessthan_3)    as rq_prio_lt3
,      count(distinct request_code_prio_lessthan_4)    as rq_prio_lt4
,      count(distinct request_code_overdue)			  as rq_overdue
,      count(distinct request_code_due_1wk)			  as rq_due1
,      count(distinct request_code_due_2wk)			  as rq_due2
,      count(distinct request_code_due_greatthan_2wk)  as rq_due_gt2
from av_execution_dashboard
WHERE user_name        = 'PSC' 
and   user_group_value = 'Chemical lab'
and  request_code is not null
group by this_week
,        user_name
,        user_group_value
;

select this_week
,      user_name
,      user_group_value
,      count(distinct request_code_prio_equal_1)                                                                                                AS rq_prio_1
,      count(distinct request_code_prio_lessthan_3)    as rq_prio_lt3
,      count(distinct request_code_prio_equal_1) + count(distinct request_code_prio_lessthan_3)                                                 as rq_total_prio_lt3
,      count(distinct request_code_prio_lessthan_4)    as rq_prio_lt4
,      count(distinct request_code_prio_equal_1) + count(distinct request_code_prio_lessthan_3) + count(distinct request_code_prio_lessthan_4)  as rq_total_prio_lt4
,      count(distinct request_code_overdue)			  as rq_overdue
,      count(distinct request_code_due_1wk)			  as rq_due1
,      count(distinct request_code_due_2wk)			  as rq_due2
,      count(distinct request_code_due_greatthan_2wk)  as rq_due_gt2
from av_execution_dashboard
WHERE user_name        = 'PSC' 
and   user_group_value = 'Chemical lab'
and  request_code is not null
group by this_week
,        user_name
,        user_group_value
;



--6	PSC	Chemical lab	1	0	44	4	2	1	8
--6	PSC	Physical lab	4	14	144	1	4	9	49


--**************************************************
--overall query voor SAMPLES
select this_week
,      user_name
,      user_group_value
,      sample_context
,      sample_status_name
,   count(distinct sample_code_prio_equal_1)                                                                                             as sc_prio_eq_1
,   count(distinct sample_code_prio_lessthan_3)   as sc_prio_lt3
,   count(distinct sample_code_prio_equal_1) + count(distinct sample_code_prio_lessthan_3)                                               as sc_total_prio_lt3
,   count(distinct sample_code_prio_lessthan_4)   as sc_prio_lt4
,   count(distinct sample_code_prio_equal_1) + count(distinct sample_code_prio_lessthan_3) + count(distinct sample_code_prio_lessthan_4)  as sc_total_prio_lt4
from av_execution_dashboard
WHERE user_name        = 'PSC' 
and   user_group_value = 'Chemical lab'
and   sample_code is not null
group by this_week
,        user_name
,        user_group_value
,        sample_context
,        sample_status_name
;


--**************************************************
--overall query voor METHODS
select this_week
,      user_name
,      user_group_value
,      sample_context
,      method_status_name
,      sum(method_count)
from av_execution_dashboard
WHERE user_name        = 'PSC' 
and   user_group_value = 'Chemical lab'
and   user_prof_lab    = 'PV RnD'
group by this_week
,        user_name
,        user_group_value
,        sample_context
,        method_status_name
;




















--**************************************************
--overall query for LAB
select distinct user_prof_lab, user_group_value
from av_execution_dashboard
where user_name        = 'PSC' 
;

*/


/*
SELECT distinct request_code
from av_execution_dashboard
--where request_code_prio_lessthan_4 = 'VKR2341015T'
where   user_profile_descr = 'Chemical lab'   -- 
and   user_name = 'KAU'
and   user_prof_lab = 'PV RnD'
and request_code is not null
;

*/




--END script



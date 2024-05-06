--*******************************************************************************
--REPORT:  UNI00403R1_REQUESTS	    (tbv execution-dashboard)
--*******************************************************************************
--tbv 
DROP VIEW sc_lims_dal.av_exec_db_requests;
--
/*
CREATE OR REPLACE VIEW  sc_lims_dal.av_exec_db_requests
( user_group
, request_code
, request_description
, request_ii_avrqdescription
, request_priority
, request_type
, request_status
, request_status_name
, request_executionweek
, request_required_ready_date
, request_days_till_due
, count_methods
)
as
select ugrp.user_group
,      rq.rq	            as request_code
,      rq.description       as request_description
,      rqdesc.iivalue       as request_ii_avrqdescription
,      rq.priority          as request_priority
,      rq.rt                as request_type
,      rq.ss                as request_status
,      rqss.name            as request_status_name
,      rqwk.rqexecutionweek as request_executionweek
,      rq.date1             as request_required_ready_date
,      cast( (trunc(rq.date1) - trunc(sysdate)) as decimal )   as request_days_till_due
,      COUNT( me.me )
from  utsc  sc
left outer join utrq        rq   on rq.rq = sc.rq
left outer join utss        rqss on rqss.ss = rq.ss
left outer join UTRQII    rqdesc on rqdesc.rq = rq.rq and rqdesc.II = 'avRqDescription'
left outer join utrqgkrqexecutionweek rqwk   on rqwk.rq = rq.rq  --and rqwk.rq = 'RqExecutionWeek' 
inner join utscme           me   on me.sc = sc.sc
left outer join  utscmegkuser_group	 ugrp on (  ugrp.sc = me.sc
                                           and  ugrp.pg = me.pg
  				                           and  ugrp.pgnode = me.pgnode
					                       and  ugrp.pa     = me.pa
					                       and  ugrp.panode = me.panode
					                       and  ugrp.me     = me.me
					                       and  ugrp.menode = me.menode
					                       ) 									   
where sc.sc not in (select itsc.sc from utscgkistest  itsc  where itsc.sc = sc.sc and itsc.istest = '1' )
and   rq.rq not in (select itrq.rq from utrqgkistest  itrq  where itrq.rq = rq.rq and itrq.istest = '1' )
and   rq.ss in ( 'AV', '@P', 'SU')
and   me.ss in ( 'AV', '@P', 'IE', 'OS', 'OW', 'WA', 'ER')
and   ugrp.user_group    = 'Physical lab'  --'Chemical lab' 
and   rq.ss = me.ss 
group by ugrp.user_group
,      rq.rq	            
,      rq.description   
,      rqdesc.iivalue      
,      rq.priority          
,      rq.rt                
,      rq.ss                
,      rqss.name            
,      rqwk.rqexecutionweek 
,      rq.date1             
,     cast( (trunc(rq.date1) - trunc(sysdate)) as decimal ) 
;


--
grant all on  sc_lims_dal.av_exec_db_requests   to usr_rna_readonly1;

*/

--functional-specifications:
--1)Report-column = "this week":  This is related TO total number of request where column "request_exec_week" is not null.
--                                Don't use the VIEW-column = "this_week" for the report-column "this_week". Qua naming may be not smart chosen, but leave it this way for the mmoent.
--                                The view-attribute "this week" is only indicating the CURRENT-wk-number. But has no direct relation with the report-column "this week".
--                                In practise we find that there are NO request with a GK=RqExecutionWeek is FILLED !!!!!! That explains why the number in the number is always = ZERO.
--                                However, the execution-dashboard-QUERY is build in such a way that the selection of REQUESTS is NOT made on the COLUMN REQUEST-EXEC-WEEK", but is made using the RQ.DATE1 !!!!!
--                                


DROP VIEW sc_lims_dal.av_exec_db_requests;
--
CREATE OR REPLACE VIEW sc_lims_dal.av_exec_db_requests
(user_profile
,user_profile_descr
,user_group
,user_group_value
,user_class_au
,user_class_value
--,user_name
--,user_prof_lab
--,default_prof_lab
,equipment_type                     --USED FOR HIGHEST GROUPING in report
,methodclass_description             --USED FOR SECOND GROUPING in report
,sample_status
,sample_status_name
,sample_priority
,sample_code_prio_lessthan_4
,sample_code_prio_lessthan_3
,sample_code_prio_equal_1
,sample_context
,sample_code
,part_no
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
,request_description
,request_type
--,avtest_method
--,avtest_method_description
,avtest_method_status
,method_parameter_group
,method_parameter
,method_code
,method_menode
,method_description
,method_status
,method_status_name
)
as
SELECT DISTINCT prof.up
,      prof.description
,      ug.au      user_group_au
,      ug.value   user_group_value
,      uc.au      user_class_au
,      uc.value   user_class_value
--,      us.us              user_name
--,	COALESCE(pref.pref_value, dprf.pref_value,'-' )   AS prof_lab
--,	COALESCE(pref.pref_value, dprf.pref_value, '-')   AS prof_lab2
,   eq.equipment_type          
,   at.description            AS methodclass_description    
,	utsc.ss                   AS sample_status
,   ss_sc.name                AS sample_status_name
,   utsc.priority             AS sample_priority
,	CASE WHEN utsc.priority = 3 THEN utsc.sc ELSE NULL END AS sc_prio_lt_4
,	CASE WHEN utsc.priority = 2 THEN utsc.sc ELSE NULL END AS sc_prio_lt_3
,	CASE WHEN utsc.priority = 1 THEN utsc.sc ELSE NULL END AS sc_prio_eq_1
,	sccontext.context        AS sc_context
,	utsc.sc                  AS sample_code
,   mepa.part_no             as part_no
,	utrq.ss                  AS rq_status
,   ss_rq.name               AS rq_status_name
,   utrq.priority            AS rq_priority
,	CAST(utrq.date1 AS date) AS rq_reqd_ready
,	CASE WHEN utrq.date1 IS NOT NULL AND utrq.date1 < TRUNC(SYSDATE)                                           THEN utrq.rq ELSE NULL END AS rq_overdue
,	CASE WHEN utrq.date1 IS NOT NULL AND utrq.date1 >= TRUNC(SYSDATE) AND utrq.date1 < TRUNC(SYSDATE) + 7      THEN utrq.rq ELSE NULL END AS rq_due_1wk
,	CASE WHEN utrq.date1 IS NOT NULL AND utrq.date1 >= TRUNC(SYSDATE) + 7 AND utrq.date1 < TRUNC(SYSDATE) + 14 THEN utrq.rq ELSE NULL END AS rq_due_2wk           
,	CASE WHEN utrq.date1 IS NOT NULL AND utrq.date1 >= TRUNC(SYSDATE) + 14                                     THEN utrq.rq ELSE NULL END AS rq_due_greaterthan_2wk               --++LATE_D = 14
,	CASE WHEN utrq.priority = 3 THEN utrq.rq ELSE NULL END AS rq_prio_lt_4
,	CASE WHEN utrq.priority = 2 THEN utrq.rq ELSE NULL END AS rq_prio_lt_3
,	CASE WHEN utrq.priority = 1 THEN utrq.rq ELSE NULL END AS rq_prio_eq_1
,	rqexecwk.RqExecutionWeek                   AS rq_exec_week
,	CAST( to_char( SYSDATE, 'IW') AS DECIMAL ) AS this_week
,	utrq.rq
,   utrq.description
,   utrq.rt
--,      pau.value                as avtest_method
--,      pau2.value               as avtest_method_description
,      pa.ss                    as avtest_method_status
,      utscme.pg                as method_parameter_group
,      utscme.pa                as method_parameter
,      utscme.me                as method_code
,      utscme.menode            as method_menode
,      utscme.description       as method_description
,      utscme.ss                as method_status
,      ss_me.name               as method_status_name
FROM        utup   prof
--INNER JOIN  utupus us          on (us.up   = prof.up)
INNER JOIN  utupau ug ON (ug.up = prof.up  and ug.au = 'user_group')
INNER JOIN  utupau uc ON (	uc.up       = ug.up AND uc.version = ug.version AND uc.au      = 'avUpClass' AND uc.value   = 'Execution' )
--LEFT OUTER JOIN utupuspref pref ON (	pref.up = prof.up AND pref.version = prof.version AND pref.pref_name = 'lab' AND pref.us = 'PGO'  --'PSC'    --'++USER_ID')
--LEFT OUTER JOIN utuppref dprf ON (	dprf.up	= prof.up AND dprf.version = prof.version AND dprf.pref_name = 'lab' )
INNER JOIN utscmegkuser_group   me_user_group   ON (me_user_group.user_group = ug.value )  
INNER JOIN utscme ON (	utscme.SC     = me_user_group.SC
					AND utscme.PG     = me_user_group.PG
					AND utscme.PGNODE = me_user_group.PGNODE
					AND utscme.PA     = me_user_group.PA
					AND utscme.PANODE = me_user_group.PANODE
					AND utscme.ME     = me_user_group.ME
					AND utscme.MENODE = me_user_group.MENODE
					--AND (	(pref.pref_value IS NOT NULL AND pref.pref_value = utscme.lab)
					--	OR	(dprf.pref_value IS NOT NULL AND dprf.pref_value = utscme.lab)
					--	OR	(pref.pref_value IS NULL     AND dprf.pref_value IS NULL       AND NULLIF(utscme.lab, '-') IS NULL)
					--	)
					)
inner join atavmethodclass at on ( at.mtpos1 = substring(utscme.me, 1, 1) and at.show = '1')
INNER JOIN      utss    ss_me ON (utscme.ss = ss_me.ss)
INNER JOIN      utsc          ON (utscme.sc = utsc.sc)
INNER JOIN      utss    ss_sc ON (utsc.ss   = ss_sc.ss)
LEFT OUTER JOIN utrq          ON (utsc.rq   = utrq.rq AND  utrq.ss IN ('AV', '@P', 'SU')  )
LEFT OUTER JOIN utss    ss_rq ON (utrq.ss = ss_rq.ss) 
LEFT OUTER JOIN utscgkcontext         sccontext ON (sccontext.sc = utsc.sc )
LEFT OUTER JOIN utrqgkRqExecutionWeek rqexecwk  ON (rqexecwk.rq  = utrq.rq  AND rqexecwk.RqExecutionWeek = to_char(SYSDATE, 'FMIW') )
INNER JOIN      utscpa   pa on (pa.sc  = utscme.sc and pa.pg = utscme.pg and pa.pgnode = utscme.pgnode and pa.pa = utscme.pa and pa.panode = utscme.panode)
INNER JOIN      utss   ss_pa on (ss_pa.ss = pa.ss)
--JOIN            utscpaau pau  on (pau.sc  = pa.sc and pau.pg  = pa.pg and pau.pgnode  = pa.pgnode and pau.pa  = pa.pa and pau.panode = pa.panode  and pau.au = 'avTestMethod' )
--LEFT OUTER JOIN utscpaau pau2 on (pau2.sc = pa.sc and pau2.pg = pa.pg and pau2.pgnode = pa.pgnode and pau2.pa = pa.pa and pau2.panode = pa.panode and pau2.au = 'avTestMethodDesc' )
left outer join utscmegkpart_no      mepa on (	mepa.sc     = utscme.sc
                                           and  mepa.pg     = utscme.pg
  				                           and  mepa.pgnode = utscme.pgnode
					                       and  mepa.pa     = utscme.pa
					                       and  mepa.panode = utscme.panode
					                       and  mepa.me     = utscme.me
					                       and  mepa.menode = utscme.menode
					                       )
left outer join  utscmegkequipment_type eq on ( eq.sc     = utscme.sc
                                           and  eq.pg     = utscme.pg
  				                           and  eq.pgnode = utscme.pgnode
					                       and  eq.pa     = utscme.pa
					                       and  eq.panode = utscme.panode
					                       and  eq.me     = utscme.me
					                       and  eq.menode = utscme.menode
					                       ) 										   
where prof.version_is_current = '1' 
AND (	utscme.ss IN ('AV', '@P', 'IE', 'OS', 'OW', 'WA', 'ER')
	OR	(   utscme.ss = 'CM' 
	    AND utsc.ss IN ('OS', 'OW')
		)
    )
--AND (  utrq.ss IN ('AV', '@P', 'SU')  OR utsc.rq IS NULL)
AND NOT EXISTS (SELECT 1 FROM utrqgkistest rqistest WHERE rqistest.rq = utrq.rq AND rqistest.istest = '1' )
AND NOT EXISTS (SELECT 1 FROM utscgkistest scistest WHERE scistest.sc = utsc.sc AND scistest.istest = '1' )
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
--AND ug.value = 'Physical lab'  --'Chemical lab'  -- '++USER_GROUP'
--AND (CASE WHEN utrq.date1 IS NOT NULL AND utrq.date1 >= TRUNC(SYSDATE) AND utrq.date1 < TRUNC(SYSDATE) + 7      THEN utrq.rq ELSE NULL END)  IS NOT NULL 
;
				
grant all on  sc_lims_dal.av_exec_db_requests   to usr_rna_readonly1;


--AND user_group.value = 'Physical lab'  --'Chemical lab'  -- '++USER_GROUP'
--AND pref.pref_value  = 'PV RnD'
--AND utrq.ss          = 'SU' 
--and utrq.rq          is not null   --= 'RJO2336024T' 
--and utrq.rq          ='ERE2405091T'
--AND us.us            = 'PSC' 
--



--REQUEST-TOTAL-NUMBERS
/*
SELECT  user_group
,       user_prof_lab
,       request_status
,       request_code
,       request_description
,       request_priority
,       request_type
,       request_status_name
,       request_code_required_ready
,       (trunc(request_code_required_ready) - trunc(sysdate) )  as request_days_till_due
,       count(method_code )
from av_exec_db_requests
where user_group    = 'Physical lab'  --'Chemical lab'  -- '++USER_GROUP'
--AND   user_prof_lab = 'PV RnD'
--AND   request_status = 'SU' 
and request_code_due_1wk is not null
and   request_code  is not null   --= 'RJO2336024T' 
AND   user_name     = 'PSC' 
GROUP BY user_group
,       user_prof_lab
,       request_status
,       request_code
,       request_description
,       request_priority
,       request_type
,       request_status_name
,       request_code_required_ready
,       (trunc(request_code_required_ready) - trunc(sysdate) ) 
;

--and   utrq.rq          ='ERE2405091T'

*/




--REQUEST-DETAIL-SCHERM
/*
SELECT *
from av_exec_db_requests
where user_group    = 'Physical lab'  --'Chemical lab'  -- '++USER_GROUP'
AND   prof_lab      = 'PV RnD'
AND   request_status = 'SU' 
and   request_code  is not null   --= 'RJO2336024T' 
AND   user_name     = 'PSC' 
;

--and   utrq.rq          ='ERE2405091T'

*/


/*
ATHENA-REPORT:
Physical lab / PV RnD		--STATUS=submit

User group	:	Physical lab / (none)		PDF	
View schedule
Status	:	SU	


EGT2402036F	trial E23523	2	M-F: FM	Submit	 	0	120
STS2351070F	[FM] TL3 Sidewall w/ Trigonox	2	M-F: FM	Submit	 	0	54
ANM2405097T	Tread allseason & winter compound from GYO for QPro and OEM wk 04/05Feb 2024	3	T-P: FM	Submit	2024/03/01	28	156
ERE2405090T	GYO summer tread	3	T-P: FM	Submit	2024/03/01	28	85
ERE2405091T	GYO summer tread, +strian sweep	3	T-P: FM	Submit	2024/03/01	28	50
AMM2405117T	Quatrac5 _ ST430_ST518_ Chennai mixed_Nov 23	3	T-P: FM	Submit	 	0	28
RJO2336024T	Adh. Peel test @R&D DE04 Kordsa vs Textilcord	3	T-P: Composites	Submit	 	0	8
RJO2404096T	CP 741, Prod. ref. 741 (MB M6) and trail 741 (MB M8) #2	3	T-P: FM	Submit	 	0	12
RJO2405093T	CP 741-Blend, Prod. ref. 741 (MB M6) and trail 741 (MB M8) #2	3	T-P: FM blend	Submit	 	0	6
*/


--END script



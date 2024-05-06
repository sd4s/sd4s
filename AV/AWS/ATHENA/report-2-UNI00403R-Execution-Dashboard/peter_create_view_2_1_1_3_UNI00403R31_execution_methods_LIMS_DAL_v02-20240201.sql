--*******************************************************************************
--REPORT:  UNI00403R-execution-dashboard
--     2.3.1	UNI00403R3_methods
--*******************************************************************************
--also  used from REPORT [REQUEST OVERVIEW AND RESULTS] for indoor-testing:
-- 

 

CREATE OR REPLACE VIEW sc_lims_dal.av_execution_db_methods
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
, request_prio_lt_3
, request_status
, request_status_name
, request_executionweek
, request_required_ready_date
, request_days_till_due
, request_overdue
, request_due_1wk
, request_due_2wk
, request_due_greaterthan_2wk
, sample_code
, sample_description
, sample_start_date
, sample_target_end_date
, sample_status
, sample_status_name
, sample_prio_lt_3
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
, me_is_relevant
, me_user_group
, sample_priority
, part_no
, methodcell
, methodcell_tm_position
, method_importid
)
as
select DISTINCT prof.up
,      prof.description
,      ug.au      user_group_au
,      ug.value   user_group_value
,      uc.au      user_class_au
,      uc.value   user_class_value
,      me.lab               as prof_lab
,      eq.equipment_type    as equipment_type              --USED FOR HIGHEST GROUPING in report
,      at.description       as methodclass_description      --USED FOR SECOND GROUPING in report
,      rq.rq	            as request_code
,      rq.description       as request_description
,      rq.priority          as request_priority
,	   CASE WHEN rq.priority in (1,2) THEN rq.rq ELSE NULL END         AS rq_prio_lt_3
,      rq.ss                as request_status
,      rqss.name            as request_status_name
,      rqwk.rqexecutionweek as request_executionweek
,      rq.date1             as request_required_ready_date
,      cast( (trunc(rq.date1) - trunc(sysdate)) as decimal )               as request_days_till_due
,	   CASE WHEN rq.date1 IS NOT NULL AND rq.date1 < TRUNC(SYSDATE)                                           THEN rq.rq ELSE NULL END AS rq_overdue
,	   CASE WHEN rq.date1 IS NOT NULL AND rq.date1 >= TRUNC(SYSDATE)     AND rq.date1 < TRUNC(SYSDATE) + 7    THEN rq.rq ELSE NULL END AS rq_due_1wk
,	   CASE WHEN rq.date1 IS NOT NULL AND rq.date1 >= TRUNC(SYSDATE) + 7 AND rq.date1 < TRUNC(SYSDATE) + 14   THEN rq.rq ELSE NULL END AS rq_due_2wk           
,	   CASE WHEN rq.date1 IS NOT NULL AND rq.date1 >= TRUNC(SYSDATE) + 14                                     THEN rq.rq ELSE NULL END AS rq_due_greaterthan_2wk               --++LATE_D = 14
,      sc.sc                as sample_code
,      sc.description       as sample_description
,      sc.date5             as sample_start_date
,      sc.date2             as sample_target_end_date
,      sc.ss                as sample_status
,      scss.name            as sample_status_name
,	   CASE WHEN sc.priority in (1,2) THEN sc.sc ELSE NULL END         AS sc_prio_lt_3
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
,      megk.me_is_relevant
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
						 
grant all on  sc_lims_dal.av_execution_db_methods   to usr_rna_readonly1;

/*
5	Physical lab	user_group	Physical lab	avUpClass	Execution	PV RnD	Miscellaneous		Conditioning														2405000064	N 134 Carbon Black			@P	Planned		Production	TP002AE	Tensile test recipe CB, 30' at 145°C	Physical (Intern)	TP002AE	CP001E	3000000	Cond. SLA 16h	@P	Planned		1	Physical lab	3	GR_2111_ORI_RAV			
5	Physical lab	user_group	Physical lab	avUpClass	Execution	PV RnD	Miscellaneous		Conditioning														2405002896	PET 2200*2 dtex 86 epdm dipped fabric			@P	Planned		Production	TP110C	Heat shrinkage 4' at 177°C	Cord data dipped	Heat shrink 4m 177C	CP001H	1000000	Cond. SLA 12h	@P	Planned		1	Physical lab	3	GR_8411_KOR_IZM			
5	Physical lab	user_group	Physical lab	avUpClass	Execution	PV RnD	RnD tensile tester	Test														2405002896	PET 2200*2 dtex 86 epdm dipped fabric			@P	Planned		Production	TP112A	Stiffness of textile cords (ASTM)	Cord data dipped	Stiffness cord	TP112A	2000000	Stiffness of cord (ASTM)	@P	Planned		1	Physical lab	3	GR_8411_KOR_IZM			
5	Physical lab	user_group	Physical lab	avUpClass	Execution	PV RnD	RnD shrinkage tester	Test														2405002896	PET 2200*2 dtex 86 epdm dipped fabric			@P	Planned		Production	TP110C	Heat shrinkage 4' at 177°C	Cord data dipped	Heat shrink 4m 177C	TP110C	2000000	Heat shrinkage of textile (4', 177°C)	@P	Planned		1	Physical lab	3	GR_8411_KOR_IZM			
5	Physical lab	user_group	Physical lab	avUpClass	Execution	PV RnD	Miscellaneous		Conditioning														2404002377	N 339 Carbon Black			@P	Planned		Production	TP002AE	Tensile test recipe CB, 30' at 145°C	Physical (Intern)	TP002AE	CP001E	2000000	Cond. SLA 16h	@P	Planned		1	Physical lab	3	GR_2134_COL_TIS			
5	Physical lab	user_group	Physical lab	avUpClass	Execution	PV RnD	Miscellaneous		Conditioning														2405002893	N 660 Carbon Black			@P	Planned		Production	TP002AE	Tensile test recipe CB, 30' at 145°C	Physical (Intern)	TP002AE	CP001E	3000000	Cond. SLA 16h	@P	Planned		1	Physical lab	3	GR_2161_COL_TIS			
5	Physical lab	user_group	Physical lab	avUpClass	Execution	PV RnD	Miscellaneous		Conditioning														2405000052	N 660 Carbon Black			@P	Planned		Production	TP002AE	Tensile test recipe CB, 30' at 145°C	Physical (Intern)	TP002AE	CP001E	3000000	Cond. SLA 16h	@P	Planned		1	Physical lab	3	GR_2161_COL_TIS			
5	Physical lab	user_group	Physical lab	avUpClass	Execution	PV RnD	Miscellaneous		Conditioning														2405002896	PET 2200*2 dtex 86 epdm dipped fabric			@P	Planned		Production	TP112A	Stiffness of textile cords (ASTM)	Cord data dipped	Stiffness cord	CP001H	1000000	Cond. SLA 12h	@P	Planned		1	Physical lab	3	GR_8411_KOR_IZM			
5	Physical lab	user_group	Physical lab	avUpClass	Execution	PV RnD	Miscellaneous		Conditioning														2406000027	N 330 Carbon Black			@P	Planned		Production	TP002AE	Tensile test recipe CB, 30' at 145°C	Physical (Intern)	TP002AE	CP001E	3000000	Cond. SLA 16h	@P	Planned		1	Physical lab	3	GR_2132_COL_MAR			
*/

--
grant all on  sc_lims_dal.av_execution_db_methods   to usr_rna_readonly1;


--TEST-QUERY
--LETOP: DOOR DUBBELING VAN PROFILE KOMEN ALLE REQUEST/SAMPLE/METHOD-COMBINATIONS DUBBEL VOOR !!!
--DUS ALTIJD SELECT DISITNCT GEBRUIKEN, EN PROFILE UIT QUERY WEGLATEN !!!!!!!!!!
select * 
from av_execution_db_methods m
where user_group_value = 'Physical lab'
and   user_prof_lab    = 'PV RnD'
and   context          = 'Production' 
and   method_status    = '@P'

--50 rows instead of 18 IN ATHENA....!!!!!!!!!!!! 
--No explantion, I think 

--en komen te kort: bijv. sample = 2405002896 + test-method=TP112A

select * 
from av_execution_db_methods m
where user_group_value = 'Physical lab'
and   user_prof_lab    = 'PV RnD'
and   context          is null



--TEST-QUERY INDOOR-TESTING:
--LETOP: DOOR DUBBELING VAN PROFILE KOMEN ALLE REQUEST/SAMPLE/METHOD-COMBINATIONS DUBBEL VOOR !!!
--DUS ALTIJD SELECT DISITNCT GEBRUIKEN, EN PROFILE UIT QUERY WEGLATEN !!!!!!!!!!
select * 
from av_execution_db_methods m
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
,      methodclass_description
,      context
,      method_status
from av_execution_db_methods
WHERE user_group_value = 'Physical lab'
and   user_prof_lab    = 'PV RnD'
and   request_code     = 'EGT2347104M'
and   method_status    = 'AV'
;

/*
Physical lab	PV RnD	Tensile tester	Test	Trials	AV
Physical lab	PV RnD	Tensile tester	Test	Trials	AV
Physical lab	PV RnD	Tensile tester	Test	Trials	AV
Physical lab	PV RnD	Tensile tester	Test	Trials	AV
Physical lab	PV RnD	Tensile tester	Test	Trials	AV
Physical lab	PV RnD	Tensile tester	Test	Trials	AV
Physical lab	PV RnD	Tensile tester	Test	Trials	AV
Physical lab	PV RnD	Tensile tester	Test	Trials	AV
Physical lab	PV RnD	Tensile tester	Test	Trials	AV
Physical lab	PV RnD	Tensile tester	Test	Trials	AV
Physical lab	PV RnD	Tensile tester	Test	Trials	AV
Physical lab	PV RnD	Tensile tester	Test	Trials	AV
*/

--**************************************************
--vervolg-query for EQUIPMENT
select user_group_value
,      user_prof_lab
,      equipment_type 
,      context
,      method_status
,      count(method_code)
from av_execution_db_methods
WHERE user_group_value = 'Physical lab'
and   user_prof_lab    = 'PV RnD'
and   context          = 'Production' 
and   method_status    = '@P'
group by user_group_value
,      user_prof_lab
,      equipment_type 
,      context
,      method_status
;
/*
Physical lab	PV RnD	RnD shrinkage tester	Production	@P	1
Physical lab	PV RnD	Miscellaneous			Production	@P	6
Physical lab	PV RnD	RnD tensile tester		Production	@P	1
*/


--**************************************************
--vervolg-query for TEST-METHOD 
select methodclass_description
,      method_code
,      method_description
,      count(method_code)
from av_execution_db_methods
WHERE user_group_value = 'Physical lab'
and   user_prof_lab    = 'PV RnD'
and   context          = 'Production' 
and   method_status    = '@P'
group by methodclass_description
,        method_code
,        method_description
;

/*
Conditioning	CP001E	Cond. SLA 16h	4
Test			TP112A	Stiffness of cord (ASTM)	1
Conditioning	CP001H	Cond. SLA 12h	2
Test			TP110C	Heat shrinkage of textile (4, 177°C)	1
*/

/*
SQL Error [XX000]: ERROR: Invalid exponent, Value 'E', Pos 6, Type: Decimal 
  Detail: 
  -----------------------------------------------
  error:  Invalid exponent, Value 'E', Pos 6, Type: Decimal 
  code:      1207
  context:   CP001E
  query:     829308018
  location:  :0
  process:   query0_108_829308018 [pid=0]

--CAUSE: I USED A SUM INSTEAD OF A COUNT IN MY SQL-STATEMENT. USING A COUNT SOLVED THE PROBLEM !!!!!
*/ 
 


select user_group_value
,      user_prof_lab
,      context
,      method_status
,      method_code
,      method_description
,      sum(method_code)
from av_execution_db_methods
WHERE user_group_value = 'Physical lab'
and   user_prof_lab    = 'PV RnD'
and   context          = 'Production' 
and   method_status    = '@P'
group by user_group_value
,      user_prof_lab
,      context
,      method_status
,      method_code
,      method_description
;


select user_group_value
,      user_prof_lab
,      equipment_type 
,      context
,      method_status
,      count(method_code)
from av_execution_db_methods
WHERE user_group_value = 'Indoor testing'
--and   user_prof_lab    = 'PV RnD'
--and   context          = 'Production' 
--and   method_status    = '@P'
group by user_group_value
,      user_prof_lab
,      equipment_type 
,      context
,      method_status
;



--ONDERZOEK NAAR SAMPLE-METHODS ZONDER CONTEXT !!!!!
select DISTINCT prof.up
,      prof.description
,      ug.au      user_group_au
,      ug.value   user_group_value
,      uc.au      user_class_au
,      uc.value   user_class_value
,      me.lab               as prof_lab
,      eq.equipment_type    as equipment_type              --USED FOR HIGHEST GROUPING in report
,      at.description       as methodclass_description      --USED FOR SECOND GROUPING in report
,      rq.rq	            as request_code
,      rq.description       as request_description
,      rq.priority          as request_priority
,	   CASE WHEN rq.priority in (1,2) THEN rq.rq ELSE NULL END         AS rq_prio_lt_3
,      rq.ss                as request_status
,      rqss.name            as request_status_name
,      rqwk.rqexecutionweek as request_executionweek
,      rq.date1             as request_required_ready_date
,      cast( (trunc(rq.date1) - trunc(sysdate)) as decimal )               as request_days_till_due
,	   CASE WHEN rq.date1 IS NOT NULL AND rq.date1 < TRUNC(SYSDATE)                                           THEN rq.rq ELSE NULL END AS rq_overdue
,	   CASE WHEN rq.date1 IS NOT NULL AND rq.date1 >= TRUNC(SYSDATE)     AND rq.date1 < TRUNC(SYSDATE) + 7    THEN rq.rq ELSE NULL END AS rq_due_1wk
,	   CASE WHEN rq.date1 IS NOT NULL AND rq.date1 >= TRUNC(SYSDATE) + 7 AND rq.date1 < TRUNC(SYSDATE) + 14   THEN rq.rq ELSE NULL END AS rq_due_2wk           
,	   CASE WHEN rq.date1 IS NOT NULL AND rq.date1 >= TRUNC(SYSDATE) + 14                                     THEN rq.rq ELSE NULL END AS rq_due_greaterthan_2wk               --++LATE_D = 14
,      sc.sc                as sample_code
,      sc.description       as sample_description
,      sc.date5             as sample_start_date
,      sc.date2             as sample_target_end_date
,      sc.ss                as sample_status
,      scss.name            as sample_status_name
,	   CASE WHEN sc.priority in (1,2) THEN sc.sc ELSE NULL END         AS sc_prio_lt_3
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
,      me.lab               as method_lab
,      e.equipement         as method_equipment
,      megk.me_is_relevant
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
left outer Join utscmegkme_is_relevant     megk  on (    megk.sc = me.sc
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
--where sc.sc not in (select itsc.sc from utscgkistest  itsc  where itsc.sc = sc.sc and itsc.istest = '1' )
--and   rq.rq not in (select itrq.rq from utrqgkistest  itrq  where itrq.rq = rq.rq and itrq.istest = '1' )
--and   rq.ss in ( 'AV', '@P', 'SU')
where   me.ss in ( 'AV', '@P', 'IE', 'OS', 'OW', 'WA', 'ER')
and   sc.sc = '2335000017'
;





--END script



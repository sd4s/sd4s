--*******************************************************************************
--REPORT:  UNI00403R-execution-dashboard
--*******************************************************************************
--tbv 
/*
DROP VIEW sc_lims_dal.av_exec_db_samples;
--
CREATE OR REPLACE VIEW sc_lims_dal.av_exec_db_samples
( user_group
, context
, request_code
, request_description
, request_priority
, request_status
, request_status_name
, request_required_ready_date
, request_days_till_due
, sample_code
, sample_description
, sample_start_date
, sample_target_end_date
, sample_status
, sample_status_name
, sample_priority
, method_status
, count_method
)
as
select ugrp.user_group
,      con.context          as context
,      rq.rq	            as request_code
,      rq.description       as request_description
,      rq.priority          as request_priority
,      rq.ss                as request_status
,      rqss.name            as request_status_name
,      rq.date1             as request_required_ready_date
,      cast( (trunc(rq.date1) - trunc(sysdate)) as decimal )  as request_days_till_due
,      sc.sc                as sample_code
,      sc.description       as sample_description
,      sc.date5             as sample_start_date
,      sc.date2             as sample_target_end_date
,      sc.ss                as sample_status
,      scss.name            as sample_status_name
,      sc.priority          as sample_priority
,      me.ss                as method_status
,      count( me.me)
from  utsc                  sc
join  utss                scss   on scss.ss = sc.ss
left outer join utrq        rq   on rq.rq = sc.rq
left outer join utss        rqss on rqss.ss = rq.ss
left outer join utscgkcontext   con   on con.sc = sc.sc
inner join utscme           me   on me.sc = sc.sc
inner join atavmethodclass  at   on ( at.mtpos1 = substr(me.me, 1,1) and at.show = '1')
inner join utss           mess   on mess.ss = me.ss 
left outer join  utscmegkuser_group	 ugrp on (  ugrp.sc = me.sc
                                           and  ugrp.pg = me.pg
  				                           and  ugrp.pgnode = me.pgnode
					                       and  ugrp.pa     = me.pa
					                       and  ugrp.panode = me.panode
					                       and  ugrp.me     = me.me
					                       and  ugrp.menode = me.menode
					                       ) 	
where   sc.sc not in (select itsc.sc from utscgkistest  itsc  where itsc.sc = sc.sc and itsc.istest = '1' )
and     rq.rq not in (select itrq.rq from utrqgkistest  itrq  where itrq.rq = rq.rq and itrq.istest = '1' )
and     sc.ss in ( 'AV', '@P', 'SU')
and     me.ss in ( 'AV', '@P', 'IE', 'OS', 'OW', 'WA', 'ER')
--and     sc.sc           like '2405000007'  
--and     sc.ss = 'AV'
--and     ugrp.user_group    = 'Physical lab'  --'Chemical lab' 
--and     con.context  = 'Trials'
GROUP BY ugrp.user_group
,      con.context          
,      rq.rq	            
,      rq.description       
,      rq.priority          
,      rq.ss                
,      rqss.name            
,      rq.date1             
,      cast( (trunc(rq.date1) - trunc(sysdate)) as decimal ) 
,      sc.sc                
,      sc.description       
,      sc.date5             
,      sc.date2             
,      sc.ss                
,      scss.name            
,      sc.priority 
,      me.ss
;						 

--
grant all on  sc_lims_dal.av_exec_db_samples   to usr_rna_readonly1;
*/





/*
/*
SELECT *
from av_exec_db_samples
where user_group    = 'Physical lab'   --'Chemical lab' 
and   sample_status = 'AV'
and   context = 'Trials'   --is null
;


AMM2350082T02	LT 265/70 R17 121Q Goodyear Wrangler Dur			AV	Available	3	12	7	14	0
AMM2350082T06	LT 265/70 R17 121Q COOPER DISCOVERER S/T			AV	Available	3	12	7	14	0
AMM2350082T07	LT 265/70 R17 121/118Q Yokhohama Geoland			AV	Available	3	12	7	14	0
--totaal aantal ME < #WA + AV

*/



DROP VIEW sc_lims_dal.av_exec_db_samples;
--
CREATE OR REPLACE VIEW sc_lims_dal.av_exec_db_samples
( user_profile
, user_profile_descr
, user_group
, user_group_value                  --USED FOR USERPROFILE
, user_class_au
, user_class_value
--, equipment_type                     --USED FOR HIGHEST GROUPING in report
--, methodclass_description    
, context
, request_code
, request_description
, request_priority
, request_status
, request_status_name
, request_required_ready_date
, request_days_till_due
, sample_code
, sample_description
, sample_start_date
, sample_target_end_date
, sample_code_prio_lessthan_4
, sample_code_prio_lessthan_3
, sample_code_prio_equal_1
, sample_status
, sample_status_name
, sample_priority
, method_status
, method_status_name
, method_lab
, count_method
)
as
SELECT DISTINCT prof.up
,      prof.description
,      ug.au      AS user_group_au
,      ug.value   AS user_group_value
,      uc.au      AS user_class_au
,      uc.value   AS user_class_value
--,      us.us              user_name
--,	COALESCE(pref.pref_value, dprf.pref_value,'-' )   AS prof_lab
--,	COALESCE(pref.pref_value, dprf.pref_value, '-')   AS prof_lab2
--,   eq.equipment_type         AS equipment_type 
--,   at.description            AS methodclass_description    
--,      ugrp.user_group      as user_group
,      con.context          as context
,      rq.rq	            as request_code
,      rq.description       as request_description
,      rq.priority          as request_priority
,      rq.ss                as request_status
,      ss_rq.name            as request_status_name
,      rq.date1             as request_required_ready_date
,      cast( (trunc(rq.date1) - trunc(sysdate)) as decimal )  as request_days_till_due
,      sc.sc                as sample_code
,      sc.description       as sample_description
,      sc.date5             as sample_start_date
,      sc.date2             as sample_target_end_date
,	   CASE WHEN sc.priority = 3 THEN sc.sc ELSE NULL END AS sc_prio_lt_4
,      CASE WHEN sc.priority = 2 THEN sc.sc ELSE NULL END AS sc_prio_lt_3
,	   CASE WHEN sc.priority = 1 THEN sc.sc ELSE NULL END AS sc_prio_eq_1
,      sc.ss                      as sample_status
,      ss_sc.name                 as sample_status_name
,      sc.priority                as sample_priority
,      me.ss                as method_status
,      ss_me.name           as method_status_name
,      me.lab               as method_lab
,      count( me.me)
FROM        utup   prof
--INNER JOIN  utupus us          on (us.up   = prof.up)
INNER JOIN  utupau ug ON (ug.up = prof.up  and ug.au = 'user_group')
INNER JOIN  utupau uc ON (	uc.up       = ug.up AND uc.version = ug.version AND uc.au      = 'avUpClass' AND uc.value   = 'Execution' )
--LEFT OUTER JOIN utupuspref pref ON (	pref.up = prof.up AND pref.version = prof.version AND pref.pref_name = 'lab' AND pref.us = 'PGO'  --'PSC'    --'++USER_ID')
--LEFT OUTER JOIN utuppref dprf ON (	dprf.up	= prof.up AND dprf.version = prof.version AND dprf.pref_name = 'lab' ) 
INNER JOIN utscmegkuser_group   me_user_group ON (me_user_group.user_group = ug.value )  
INNER JOIN utscme                          me ON (	 me.SC     = me_user_group.SC
					                             AND me.PG     = me_user_group.PG
					                             AND me.PGNODE = me_user_group.PGNODE
					                             AND me.PA     = me_user_group.PA
					                             AND me.PANODE = me_user_group.PANODE
					                             AND me.ME     = me_user_group.ME
					                             AND me.MENODE = me_user_group.MENODE
					                            --AND (	(pref.pref_value IS NOT NULL AND pref.pref_value = utscme.lab)
					                            --	OR	(dprf.pref_value IS NOT NULL AND dprf.pref_value = utscme.lab)
					                            --	OR	(pref.pref_value IS NULL     AND dprf.pref_value IS NULL       AND NULLIF(utscme.lab, '-') IS NULL)
					                            --	)
					                            )
--inner join atavmethodclass     at   on (at.mtpos1 = substr(me.me, 1,1) and at.show = '1')
inner join utss             ss_me   on (ss_me.ss = me.ss )
INNER JOIN      utsc           sc   ON (me.sc = sc.sc)
INNER JOIN      utss        ss_sc   ON (sc.ss   = ss_sc.ss)
LEFT OUTER JOIN utrq           rq   ON (sc.rq   = rq.rq AND  rq.ss IN ('AV', '@P', 'SU')  )
LEFT OUTER JOIN utss        ss_rq   ON (rq.ss = ss_rq.ss) 
LEFT OUTER JOIN utscgkcontext con   ON (con.sc = sc.sc )
where   sc.sc not in (select itsc.sc from utscgkistest  itsc  where itsc.sc = sc.sc and itsc.istest = '1' )
and     rq.rq not in (select itrq.rq from utrqgkistest  itrq  where itrq.rq = rq.rq and itrq.istest = '1' )
and     sc.ss in ( 'AV', '@P', 'SU'   ,'OS','OW','WA')
and     (   me.ss in ( 'AV', '@P', 'IE', 'OS', 'OW', 'WA', 'ER')    
        OR	(   me.ss = 'CM' 
		    AND sc.ss IN ('OS', 'OW') )            --Alleen indien sc.ss = OS/OW dan is me.ss=CM
        )
--and     sc.sc           like '2405000007'  
--and     sc.ss = 'AV'
--and     ug.value    = 'Chemical lab'   --'Physical lab'
--and     con.context  = 'Trials'
GROUP BY prof.up
,      prof.description
,      ug.au      
,      ug.value   
,      uc.au      
,      uc.value   
--,      eq.equipment_type          
--,      at.description   
--,      ugrp.user_group
,      con.context          
,      rq.rq	            
,      rq.description       
,      rq.priority          
,      rq.ss                
,      ss_rq.name            
,      rq.date1             
,      cast( (trunc(rq.date1) - trunc(sysdate)) as decimal ) 
,      sc.sc                
,      sc.description       
,      sc.date5             
,      sc.date2    
,	   CASE WHEN sc.priority = 3 THEN sc.sc ELSE NULL END 
,      CASE WHEN sc.priority = 2 THEN sc.sc ELSE NULL END 
,	   CASE WHEN sc.priority = 1 THEN sc.sc ELSE NULL END 
,      sc.ss                
,      ss_sc.name            
,      sc.priority 
,      me.ss
,      ss_me.name 
,      me.lab
;						 
--
grant all on  sc_lims_dal.av_exec_db_samples   to usr_rna_readonly1;


--TEST-QUERY:
SELECT *
from av_exec_db_samples
where user_group_value    = 'Physical lab'   --'Physical lab'  'Chemical lab' 
and   method_lab = 'PV RnD'
--and   sample_status = 'AV'
and ( sample_code_prio_lessthan_4 is not null
    or  sample_code_prio_lessthan_3 is not null
    or  sample_code_prio_equal_1    is not null
    )
and   context = 'Production'   --is null
;


SELECT *
from av_exec_db_samples
where user_group_value    = 'Physical lab'   --'Physical lab'  'Chemical lab' 
and   method_lab = 'PV RnD'
--and   sample_status = 'AV'
and ( sample_code_prio_lessthan_4 is not null
    or  sample_code_prio_lessthan_3 is not null
    or  sample_code_prio_equal_1    is not null
    )
and   context = 'Production'   --is null
and   sample_status = 'AV' 
;
/*
5	Physical lab	user_group	Physical lab	avUpClass	Execution	Production								2408000277	REKNUMMER RE01 BLAUW/GEEL/GEEL		2024-02-19 00:00:00.000	2408000277			AV	Available	3	AV	Available	PV RnD	2
5	Physical lab	user_group	Physical lab	avUpClass	Execution	Production								2408001709	Rubberized beadwire 1.30		2024-02-20 00:00:00.000	2408001709			AV	Available	3	IE	In Execution	PV RnD	1
5	Physical lab	user_group	Physical lab	avUpClass	Execution	Production								2408001708	Rubberized beadwire 0.89		2024-02-20 00:00:00.000	2408001708			AV	Available	3	IE	In Execution	PV RnD	1
5	Physical lab	user_group	Physical lab	avUpClass	Execution	Production								2408001707	Reference bead material 0.89		2023-02-02 00:00:00.000	2408001707			AV	Available	3	IE	In Execution	PV RnD	1
5	Physical lab	user_group	Physical lab	avUpClass	Execution	Production								2408001710	Rubberized beadwire 1.30		2024-02-20 00:00:00.000	2408001710			AV	Available	3	IE	In Execution	PV RnD	1
5	Physical lab	user_group	Physical lab	avUpClass	Execution	Production								2407000790	REKNUMMER FE05 BLAUW/ORANJE		2024-02-13 00:00:00.000	2407000790			AV	Available	3	AV	Available	PV RnD	2
5	Physical lab	user_group	Physical lab	avUpClass	Execution	Production								2408000274	REKNUMMER FE05 BLAUW/ORANJE		2024-02-19 00:00:00.000	2408000274			AV	Available	3	AV	Available	PV RnD	2
5	Physical lab	user_group	Physical lab	avUpClass	Execution	Production								2401000023	AR 1100 + NY 940, 102 epdm			2401000023			AV	Available	3	AV	Available	PV RnD	2
5	Physical lab	user_group	Physical lab	avUpClass	Execution	Production								2401002287	AR 1100 + NY 940, 102 epdm		2023-12-21 00:00:00.000	2401002287			AV	Available	3	AV	Available	PV RnD	2
5	Physical lab	user_group	Physical lab	avUpClass	Execution	Production								2408000999	FM Tread winter HP (-4phr Oil)		2024-02-21 00:00:00.000	2408000999			AV	Available	3	IE	In Execution	PV RnD	4
5	Physical lab	user_group	Physical lab	avUpClass	Execution	Production								2408000273	REKNUMMER DE04		2024-02-19 00:00:00.000	2408000273			AV	Available	3	AV	Available	PV RnD	2
5	Physical lab	user_group	Physical lab	avUpClass	Execution	Production								2407000792	REKNUMMER ME03 with 768 BLAUW/GROEN		2024-02-12 00:00:00.000	2407000792			AV	Available	3	AV	Available	PV RnD	2
5	Physical lab	user_group	Physical lab	avUpClass	Execution	Production								2407000102	REKNUMMER ME01 GROEN/GEEL		2024-02-12 00:00:00.000	2407000102			AV	Available	3	AV	Available	PV RnD	2
5	Physical lab	user_group	Physical lab	avUpClass	Execution	Production								2408000276	REKNUMMER ME03 with 768 BLAUW/GROEN		2024-02-19 00:00:00.000	2408000276			AV	Available	3	AV	Available	PV RnD	2
5	Physical lab	user_group	Physical lab	avUpClass	Execution	Production								2408000278	REKNUMMER SE-06 WIT/BLAUW		2024-02-19 00:00:00.000	2408000278			AV	Available	3	AV	Available	PV RnD	2
5	Physical lab	user_group	Physical lab	avUpClass	Execution	Production								2408001012	FM Tread winter HP (-4phr Oil)		2024-02-21 00:00:00.000	2408001012			AV	Available	3	IE	In Execution	PV RnD	4
5	Physical lab	user_group	Physical lab	avUpClass	Execution	Production								2401000021	AR 1100 + NY 940, 102 epdm			2401000021			AV	Available	3	AV	Available	PV RnD	2
5	Physical lab	user_group	Physical lab	avUpClass	Execution	Production								2408001395	FM Base PCR		2024-02-21 00:00:00.000	2408001395			AV	Available	3	IE	In Execution	PV RnD	2
--
--Dit aantal klopt prcecies met ATHENA-SAMPLES !!!!
--
--let op: OOK DEZE SAMPLES HEBBEN GEEN GERELATEERDE REQUEST-CODE, EN WORDEN TOCH GESELECTEERD !!!
--        DIT BETEKEND DAT DE OUTER-JOIN IN DE QUERY WEL GEWOON WERKT !!!
*/


/*
Where to find SAMPLE-AVAILABLE-DATE ???
--
SELECT * FROM UTSCHS ;
--
2405002236	UNILAB	Unilab 4 Supervisor	ScGroupKeyUpdated	sample "2405002236" group key "week" is created/updated.														01-02-2024 04.54.06.000000000 AM		346250	276651	01-02-2024 04.54.06.000000000 AM CET
2405002236	UNILAB	Unilab 4 Supervisor	ScGroupKeyUpdated	sample "2405002236" group key "day" is created/updated.															01-02-2024 04.54.06.000000000 AM		346250	276652	01-02-2024 04.54.06.000000000 AM CET
2405002236	UNILAB	Unilab 4 Supervisor	ScGroupKeyUpdated	sample "2405002236" group key "month" is created/updated.														01-02-2024 04.54.06.000000000 AM		346250	276653	01-02-2024 04.54.06.000000000 AM CET
2405002236	UNILAB	Unilab 4 Supervisor	ScGroupKeyUpdated	sample "2405002236" group key "year" is created/updated.														01-02-2024 04.54.06.000000000 AM		346250	276654	01-02-2024 04.54.06.000000000 AM CET
2405002236	UNILAB	Unilab 4 Supervisor	ScInfoCreated		Info cards for sample "2405002236" are created																	01-02-2024 04.54.06.000000000 AM	Job	346247	276579	01-02-2024 04.54.06.000000000 AM CET
2405002236	UNILAB	Unilab 4 Supervisor	SampleCreated		sample "2405002236" is created																					01-02-2024 04.54.06.000000000 AM	Job	346247	276580	01-02-2024 04.54.06.000000000 AM CET
2405002236	UNILAB	Unilab 4 Supervisor	CustomComment		Custom comment added by APAOFUNCTIONS.AddScComment																01-02-2024 04.54.06.000000000 AM	Changed status to '@P' by APAOREGULARRELEASE.AssignCOA	346247	276581	
2405002236	TRI	Ton Rijsman	InfoFieldValueChanged			sample "2405002236" is updated.																					01-02-2024 09.48.02.000000000 AM		352349	311028	01-02-2024 09.48.02.000000000 AM CET
2405002236	TRI	Ton Rijsman	ScStatusChanged					status of sample "2405002236" is changed from "Planned" [@P] to "Available" [AV].								01-02-2024 09.48.06.000000000 AM	@P => AV : 	352365	311072	01-02-2024 09.48.06.000000000 AM CET
2405002236	TRI	Ton Rijsman	EvMgrStatusChanged				status of sample code "2405002236" is automatically changed from "Available" [AV] to "Out of warning" [OW].		02-02-2024 11.35.23.000000000 AM		381243	514339	02-02-2024 11.35.23.000000000 AM CET
2405002236	UNILAB	Unilab 4 Supervisor	EvMgrStatusChanged	status of sample code "2405002236" is automatically changed from "Out of warning" [OW] to "Out of spec" [OS].	05-02-2024 08.43.07.000000000 AM		429138	709165	05-02-2024 08.43.07.000000000 AM CET
2405002236	THA	Tom Hammer	InfoFieldValueChanged			sample "2405002236" is updated.																					05-02-2024 01.50.34.000000000 PM		438027	772869	05-02-2024 01.50.34.000000000 PM CET
2405002236	THA	Tom Hammer	EvMgrStatusChanged				status of sample code "2405002236" is automatically changed from "Out of spec" [OS] to "Out of warning" [OW].	05-02-2024 01.50.50.000000000 PM		438042	772932	05-02-2024 01.50.50.000000000 PM CET
2405002236	THA	Tom Hammer	EvMgrStatusChanged				status of sample code "2405002236" is automatically changed from "Out of warning" [OW] to "Available" [AV].		05-02-2024 02.12.42.000000000 PM		438884	779737	05-02-2024 02.12.42.000000000 PM CET
2405002236	UNILAB	Unilab 4 Supervisor	EvMgrStatusChanged	status of sample code "2405002236" is automatically changed from "Available" [AV] to "Out of spec" [OS].		06-02-2024 03.53.08.000000000 PM		464364	940971	06-02-2024 03.53.08.000000000 PM CET

CONCLUSION: IT'S THE LOGDATE OF THE 2ND STATUS-CHANGE TO AVAILABLE. 
            FIRST ONE IS STATUS-CHANGE FROM 
*/





--END script



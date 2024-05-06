--report: UNI00403R31		EXECUTION-DASHBOARD: METHOD-DETAILS

/*
ATAVMETHODCLASS
T	Test			1
C	Conditioning	1
S	Simulation		1
P	Preparation		1
A	Ageing			1
D	Definition		0
M	Manufacturing	1
E	Calibration		1
*/


select eq.equipment_type          --USED FOR HIGHEST GROUPING in report
,      at.description             --USED FOR SECOND GROUPING in report
,      rq.rq	            as request_code
,      rq.description       as request_description
,      rq.priority          as request_priority
,      rq.ss                as request_status
,      rqss.name            as request_status_name
,      rqwk.rqexecutionweek as request_executionweek
,      rq.date1             as request_required_ready_date
,      to_number( trunc(rq.date1) -    trunc(sysdate) )  as request_days_till_due
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
inner join atavmethodclass  at   on ( at.mtpos1 = substr(me.me, 1,1) and at.show = '1')
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
where sc.rq           like 'VKR2341015T'  
and   ugrp.user_group    = 'Chemical lab' 
and   sc.sc not in (select itsc.sc from utscgkistest  itsc  where itsc.sc = sc.sc and itsc.istest = '1' )
and   rq.rq not in (select itrq.rq from utrqgkistest  itrq  where itrq.rq = rq.rq and itrq.istest = '1' )
and   rq.ss in ( 'AV', '@P', 'SU')
and   me.ss in ( 'AV', '@P', 'IE', 'OS', 'OW', 'WA', 'ER')
;						 



/*
JOIN SS IN UVSCME TAG method TO SS IN UVSS TAG ss_me AS J0
JOIN
 FILE UVSCME AT MENODE TO UNIQUE
 FILE UVSCMEGK AT MENODE TAG merelv AS J1
 
 WHERE merelv.SC		EQ method.SC;
 WHERE merelv.PG		EQ method.PG;
 WHERE merelv.PGNODE	EQ method.PGNODE;
 WHERE merelv.PA		EQ method.PA;
 WHERE merelv.PANODE	EQ method.PANODE;
 WHERE merelv.ME		EQ method.ME;
 WHERE merelv.MENODE	EQ method.MENODE;
 WHERE merelv.GK		EQ 'ME_IS_RELEVANT';
END
JOIN LEFT_OUTER
	SC AND PG AND PGNODE AND PA AND PANODE AND ME AND MENODE IN UVSCME TO UNIQUE
	SC AND PG AND PGNODE AND PA AND PANODE AND ME AND MENODE IN UVSCMEGKEQUIPMENT_TYPE TAG eq AS J2
END
JOIN LEFT_OUTER
	SC AND PG AND PGNODE AND PA AND PANODE AND ME AND MENODE IN UVSCME TO UNIQUE
	SC AND PG AND PGNODE AND PA AND PANODE AND ME AND MENODE IN UVSCMEGKUSER_GROUP TAG group AS J3
END
JOIN LEFT_OUTER
	SC AND PG AND PGNODE AND PA AND PANODE AND ME AND MENODE IN UVSCME TO UNIQUE
	SC AND PG AND PGNODE AND PA AND PANODE AND ME AND MENODE IN UVSCMEGKSCPRIORITY TAG mePrio AS J4
END
 
JOIN SC IN UVSCME TO SC IN UVSC TAG sample AS J5
JOIN sample.SS IN UVSCME TO SS IN UVSS TAG ss_sc AS J6
 
JOIN
 FILE UVSCME AT ME TO UNIQUE
 FILE UVMT AT MT TAG methdCfg AS J7
 
 WHERE methdCfg.MT EQ method.ME;
 WHERE methdCfg.VERSION_IS_CURRENT EQ '1';
END
 
JOIN LEFT_OUTER
	method.SC AND method.PG AND method.PGNODE AND method.PA AND method.PANODE AND method.ME AND method.MENODE AND method.SS IN UVSCME TO
	SC AND PG AND PGNODE AND PA AND PANODE AND ME AND MENODE AND SS_TO IN ATMETRHS TAG meHist AS J8
END
 
JOIN LEFT_OUTER
 FILE UVSCME AT method.SC TO UNIQUE
 FILE UVSCGK AT SC TAG context AS J9
 
 WHERE method.SC EQ context.SC;
 WHERE context.GK EQ 'Context';
END
JOIN LEFT_OUTER
 FILE UVSCME AT sample.SC TO UNIQUE
 FILE UVSCGK AT SC TAG scistest AS J10
 
 WHERE scistest.SC EQ sample.SC;
 WHERE scistest.GK EQ 'isTest';
 WHERE scistest.VALUE EQ '1';
END
JOIN LEFT_OUTER
 RQ IN UVSCME TO
 RQ IN UVRQ TAG request AS J11
END
JOIN LEFT_OUTER
 request.SS IN UVSCME TO UNIQUE
 SS IN UVSS TAG reqStat AS J12
END
JOIN LEFT_OUTER
 FILE UVSCME AT request.RQ TO UNIQUE
 FILE UVRQGK AT RQ TAG rqistest AS J13
 
 WHERE request.RQ EQ rqistest.RQ;
 WHERE rqistest.GK EQ 'isTest';
 WHERE rqistest.VALUE EQ '1';
END
 
JOIN LEFT_OUTER
 FILE UVSCME AT MENODE TO UNIQUE
 FILE UVSCMEGK AT MENODE TAG avmthd AS J14
 
 WHERE avmthd.SC		EQ method.SC;
 WHERE avmthd.PG		EQ method.PG;
 WHERE avmthd.PGNODE	EQ method.PGNODE;
 WHERE avmthd.PA		EQ method.PA;
 WHERE avmthd.PANODE	EQ method.PANODE;
 WHERE avmthd.ME		EQ method.ME;
 WHERE avmthd.MENODE	EQ method.MENODE;
 WHERE avmthd.GK		EQ 'avTestMethodDesc';
END
JOIN LEFT_OUTER
 FILE UVSCME AT MENODE TO UNIQUE
 FILE UVSCMEGK AT MENODE TAG importId AS J15
 
 WHERE importId.SC		EQ method.SC;
 WHERE importId.PG		EQ method.PG;
 WHERE importId.PGNODE	EQ method.PGNODE;
 WHERE importId.PA		EQ method.PA;
 WHERE importId.PANODE	EQ method.PANODE;
 WHERE importId.ME		EQ method.ME;
 WHERE importId.MENODE	EQ method.MENODE;
 WHERE importId.GK EQ 'ImportId';
END
JOIN LEFT_OUTER
 FILE UVSCME AT ME TO UNIQUE
 FILE ATAVMETHODCLASS AT MTPOS1 TAG sheet AS J16
 
 WHERE sheet.MTPOS1 EQ SUBSTRING(ME, 1, 1);
 WHERE sheet.SHOW EQ '1';
END
JOIN LEFT_OUTER
 FILE UVSCME AT sample.SC TO UNIQUE
 FILE UVSCGK AT SC TAG part AS J17
 
 WHERE sample.SC EQ part.SC;
 WHERE part.GK EQ 'PART_NO';
END
JOIN LEFT_OUTER
 FILE UVSCME AT request.RQ TO UNIQUE
 FILE UVRQGK AT RQ TAG execwk AS J18
 
 WHERE request.RQ EQ execwk.RQ;
 WHERE execwk.GK EQ 'RqExecutionWeek';
END
JOIN LEFT_OUTER
 FILE UVSCME AT MT TO UNIQUE
 FILE UVMTAU AT MT TAG report AS J19
 
 WHERE report.MT EQ methdCfg.MT;
 WHERE report.VERSION EQ methdCfg.VERSION;
 WHERE report.AU EQ 'avCustAthena';
END
 
JOIN LEFT_OUTER
 FILE UVSCME AT ME TO UNIQUE
 FILE UVSCMECELL AT ME TAG tmPosition AS J20
 
 WHERE tmPosition.SC EQ method.SC;
 WHERE tmPosition.PG EQ method.PG;
 WHERE tmPosition.PGNODE EQ method.PGNODE;
 WHERE tmPosition.PA EQ method.PA;
 WHERE tmPosition.PANODE EQ method.PANODE;
 WHERE tmPosition.ME EQ method.ME;
 WHERE tmPosition.MENODE EQ method.MENODE;
 WHERE tmPosition.CELL EQ 'TM_position';
END
 
DEFINE FILE UVSCME
	REQRDY_SORT/I2					= IF request.DATE1 EQ MISSING THEN 9 ELSE 1;
	REQRDY/HYYMD MISSING ON SOME	= request.DATE1;
	RQ_PRIOSORT/P6					= IF RQ EQ '' THEN 999 ELSE request.PRIORITY;
	SC_PRIOSORT/P6					= sample.PRIORITY;
	NOW/HYYMDS						= HGETC(8, NOW);
 
-*	NULL's last
	STARTDATE/HYYMD					= sample.DATE5;
	STARTDATE_SORT/I2				= IF sample.DATE5 IS NOT MISSING THEN 1 ELSE 2;
	TRG_ENDDATE/HYYMD				= sample.DATE1;
	PRODDATE/HYYMDS					= IF sample.DATE3 IS NOT MISSING THEN sample.DATE3
										ELSE IF method.EXEC_START_DATE IS NOT MISSING THEN method.EXEC_START_DATE
										ELSE IF request.DATE1 IS NOT MISSING THEN request.DATE1
										ELSE NOW;
	SC_PRODDATE/A10					= HCNVRT(PRODDATE, '(HYYMD)', 10, 'A10');
 
-*	REQRDY_DIFF/I6					= HDIFF(REQRDY, NOW, 'DAY', REQRDY_DIFF);
END
TABLE FILE UVSCME
SUM
	MIN.request.PRIORITY 	AS PHASE_PRIO
	MAX.method.DESCRIPTION	AS ME_DESCRIPTION
	MAX.ss_me.SS			AS ME_SS
	MAX.ss_me.NAME			AS ME_STATUS
	MAX.report.VALUE		AS REPORTTYPE
 
	MAX.SC_PRODDATE
	MAX.STARTDATE_SORT
	MAX.STARTDATE
	MAX.TRG_ENDDATE
 
	MAX.meHist.TR_ON		AS STATUSDATE
	MAX.method.EQ			AS EQUIPMENT
	MAX.tmPosition.VALUE_S	AS TM_POSITION
 
-*	MAX.REQRDY_DIFF
 
 
-*BY PLANNED_EQ
BY eq.EQUIPMENT_TYPE
BY sheet.DESCRIPTION	AS SHEET
 
BY RQ_PRIOSORT
BY request.PRIORITY		AS RQ_PRIORITY
BY REQRDY_SORT
BY REQRDY
BY RQ
BY request.SS			AS RQ_SS
BY reqStat.NAME			AS RQ_STATUS
BY execwk.VALUE			AS EXECWK
 
BY SC_PRIOSORT
BY mePrio.SCPRIORITY	AS SC_PRIORITY
BY SC
BY part.VALUE			AS PART_NO
BY avmthd.VALUE			AS AVTESTMETHOD
 
BY ME
BY MENODE
 
BY PG
BY PGNODE
BY PA
BY PANODE
 
BY importId.VALUE		AS IMPORTID
 
WHERE RQ EQ '&REQUEST';
WHERE SC EQ '&SAMPLE';
WHERE ME EQ '&METHOD';
WHERE eq.EQUIPMENT_TYPE EQ '&EQUIPMENT';
WHERE group.USER_GROUP EQ '&USER_GROUP';
 
-IF &REQUEST NE FOC_NONE THEN GOTO :RQ1;
WHERE (request.RQ IS MISSING) OR (request.SS EQ 'AV' OR '@P' OR 'SU');
WHERE request.PRIORITY &RQ_PRIO.EVAL;
WHERE '&DUE_L' NE '' AND request.DATE1 GE DT('&DUEDATE_L') AND request.DATE1 IS NOT MISSING;
WHERE '&DUE_H' NE '' AND request.DATE1 LT DT('&DUEDATE_H') AND request.DATE1 IS NOT MISSING;
WHERE rqistest.RQ IS MISSING;
-:RQ1
 
-IF &SAMPLE NE FOC_NONE THEN GOTO :SC1;
WHERE sample.PRIORITY &SC_PRIO.EVAL;
WHERE scistest.SC IS MISSING;
WHERE context.VALUE EQ '&CONTEXT';
-:SC1
 
WHERE method.SS EQ '&STATUS';
-IF &STATUS NE FOC_NONE THEN GOTO :ME1;
WHERE method.SS EQ 'AV' OR '@P' OR 'IE' OR 'OS' OR 'OW' OR 'WA' OR 'ER';
-:ME1
 
-IF &METHOD NE FOC_NONE THEN GOTO :ME2;
-SET &EXPR = IF &METHODCLASS EQ '.' 	THEN	'WHERE sheet.MTPOS1 IS MISSING;'
-	ELSE IF &METHODCLASS EQ FOC_NONE	THEN ''
-	ELSE		'WHERE sheet.MTPOS1 EQ ''' || &METHODCLASS | ''';'
-;
-*-TYPE EXPR: &METHODCLASS >> &EXPR
&EXPR
 
-:ME2
-*WHERE method.PLANNED_EXECUTOR EQ '&HROLE';
WHERE ((method.LAB IS MISSING OR method.LAB EQ '-') AND '&LAB' EQ ' ' OR 'NULL') OR (method.LAB EQ '&LAB');
WHERE merelv.VALUE EQ '1';
 
ON TABLE HOLD AS UNI00403H31
END
-RUN
-*-EXIT
 
 
 
-*
-* Get part-no descriptions
-*
TABLE FILE UNI00403H31
SUM COMPUTE PN/A18 = PART_NO;
BY PART_NO NOPRINT
ON TABLE HOLD AS UNI00403H31_PART_NO FORMAT ALPHA
END
-RUN
 
TABLE FILE PART
PRINT
	COMPUTE PN/A40V = PART_NO;	AS PART_NO
	DESCRIPTION					AS PART_DESCRIPTION
 
BY PART_NO	NOPRINT
WHERE PART_NO IN FILE UNI00403H31_PART_NO;
ON TABLE HOLD AS UNI00403H31_PARTS FORMAT FOCUS INDEX PN
END
-RUN
-*-EXIT
 
 
 
 
 
-*-INCLUDE GEN00213_traceTime
-*-SET &ECHO = ALL;
 
-* HTML operators
-DEFAULTH &LT = '&lt;';
-DEFAULTH &LE = '&lt;=';
-DEFAULTH &GT = '&gt;';
-DEFAULTH &GE = '&gt;=';
-DEFAULTH &EQ = '=';
 
JOIN CLEAR *
JOIN PART_NO IN UNI00403H31 TO PART_NO IN UNI00403H31_PARTS AS J0
DEFINE FILE UNI00403H31
	NOW/HYYMD				= HMIDNT(HGETC(8, NOW), 8, NOW);
	DUE/D12	MISSING ON SOME	= HDIFF(REQRDY, NOW, 'day', DUE);
	LIFETIME/D12SC MISSING ON SOME = HDIFF(NOW, STATUSDATE, 'day', LIFETIME);
-*	SC_PRIO/I3SC			= SC_PRIORITY;
 
	ME_DISPERSION/A1		= IF ME LIKE 'TP005%' THEN 'Y' ELSE 'N';
	ME_CALANDER/A1			= IF ME EQ 'MF203A' THEN 'Y' ELSE 'N';
 
	ME_EQUIPMENT/A20 MISSING ON SOME = IF ME_SS EQ 'IE' THEN EQUIPMENT ELSE MISSING;
	MEC_TMPOSITION/A40 MISSING ON SOME = IF ME_SS EQ 'IE' THEN TM_POSITION ELSE MISSING;
END
TABLE FILE UNI00403H31
SUM
	COMPUTE EQ_PRIO/P4 = MIN.PHASE_PRIO;		NOPRINT
 
BY TOTAL EQ_PRIO		NOPRINT
BY EQUIPMENT_TYPE		NOPRINT
 
SUM
	MIN.PHASE_PRIO		NOPRINT
 
BY TOTAL EQ_PRIO		NOPRINT
BY EQUIPMENT_TYPE		NOPRINT
BY TOTAL PHASE_PRIO		NOPRINT
BY SHEET				NOPRINT
 
SUM
	ME_DESCRIPTION		AS 'Method,description'
	ME_STATUS			AS 'Method,status'				&PDF_NOPR
	SC_PRODDATE			NOPRINT
 
	REPORTTYPE			NOPRINT
 
	ME_EQUIPMENT		AS 'Eq.-,ment'					&PDF_NOPR
	TM_POSITION			AS 'Pos.'						&PDF_NOPR
	COMPUTE ME_CNT/I10 = IF LAST SC NE SC OR LAST ME NE ME THEN 1 ELSE 0; AS '# Methods' NOPRINT
 
	IMPORTID			AS 'Import-Id'
 
	COMPUTE BARCODE/A15 MISSING ON SOME =
		IF IMPORTID GT ''
		THEN '*' || IMPORTID || '*'
		ELSE MISSING;
						AS 'Import-ID,Barcode'			&PDF_PR
 
 
BY TOTAL EQ_PRIO		NOPRINT
BY EQUIPMENT_TYPE		NOPRINT
BY TOTAL PHASE_PRIO		NOPRINT
BY SHEET				NOPRINT
 
BY RQ_PRIOSORT			NOPRINT
BY REQRDY_SORT			NOPRINT
BY REQRDY				NOPRINT
 
BY RQ					AS 'Request,code'				&PDF_NOPR
BY RQ_PRIORITY			AS 'Request,priority'			&PDF_NOPR
BY RQ_STATUS			AS 'Request,status'				&PDF_NOPR
BY EXECWK				AS 'Request,execution,week'		NOPRINT
 
BY DUE					AS 'Days,till,due'				&PDF_NOPR
BY LIFETIME				AS 'Days,in,status,(sample)'	&PDF_NOPR
BY REQRDY				AS 'Required,ready'				&PDF_NOPR
-*BY REQRDY_DIFF
 
BY SC_PRIOSORT			NOPRINT
BY STARTDATE_SORT		NOPRINT
BY STARTDATE			NOPRINT
BY SC					AS 'Sample,code'
BY SC_PRIORITY			AS 'Sample,priority'
BY PART_NO				AS 'Part-no.'
BY PART_DESCRIPTION		AS 'Part,Description'			&PDF_NOPR
BY STARTDATE			AS 'Start date'					&PDF_NOPR
BY TRG_ENDDATE			AS 'Target,End date'			&PDF_NOPR
BY AVTESTMETHOD			AS 'AV-Method'					&PDF_PR
 
BY ME					AS 'Method,code'
BY MENODE				NOPRINT
 
BY PG					NOPRINT
BY PGNODE				NOPRINT
BY PA					NOPRINT
BY PANODE				NOPRINT
 
BY IMPORTID				NOPRINT
 
ON TABLE RECAP 'Total # Methods'/I10 = ME_CNT;
 
ON TABLE SUBHEAD
"Method details"
 
ON EQUIPMENT_TYPE SUBHEAD
"<EQUIPMENT_TYPE"
 
ON SHEET SUBHEAD
"<SHEET"
 
HEADING
"User profile<+0>:<+0>&USER_GROUP / &HLAB2 &PDF_LNK"
"Request code<+0>:<+0>&REQUEST"
"Sample code<+0>:<+0>&SAMPLE"
"Method<+0>:<+0>&METHOD"
"Method-sheet<+0>:<+0>&METHODCLASS"
"Equipment<+0>:<+0>&EQUIPMENT"
"Status<+0>:<+0>&STATUS"
"Request prio<+0>:<+0>&RQ_PRIO.EVAL"
"Sample prio<+0>:<+0>&SC_PRIO.EVAL"
"Due in<+0>:<+0><0X
&|ge; &DUE_L <0X
&|lt; &DUE_H <0X
 weeks"
 
 
-*-SET &FORMAT = EXL2K;
-*-SET &X = &WFFMT;
-*-SET &FORMAT = HTML;
 
-INCLUDE GEN00005_rtvFooting
 
-*-SET &WFFMT = &X;
 
 
-*&PDF_EV.EVAL TYPE=REPORT, COLUMN=IMPORTID, SIZE=4,$
-*&PDF_EV.EVAL TYPE=TITLE, COLUMN=IMPORTID, SIZE=4, CLASS=TITLE,$
-*&PDF_EV.EVAL TYPE=DATA, COLUMN=IMPORTID, SIZE=4, CLASS=DATA,$
 
 
TYPE=HEADING, ITEM=1, CLASS=HEADING, WIDTH=3.2,$
TYPE=HEADING, ITEM=2, CLASS=HEADING, WIDTH=0.3,$
TYPE=HEADING, ITEM=3, CLASS=HEADING, WIDTH=3,$
 
-IF &WFFMT EQ 'PDF' OR 'XLSX' THEN GOTO :PDFLNKSKP1;
TYPE=HEADING, LINE=1, ITEM=4, CLASS=HEADING COLON,$
TYPE=HEADING, LINE=1, ITEM=5, CLASS=HEADING,
	TARGET=_blank,
	FOCEXEC=&FOCFEXNAME(
		USER_GROUP=&USER_GROUP.QUOTEDSTRING
		LAB=&LAB.QUOTEDSTRING
		REQUEST=&REQUEST.QUOTEDSTRING
		SAMPLE=&SAMPLE.QUOTEDSTRING
		METHOD=&METHOD.QUOTEDSTRING
		METHODCLASS=&METHODCLASS.QUOTEDSTRING
		EQUIPMENT=&EQUIPMENT.QUOTEDSTRING
		STATUS=&STATUS.QUOTEDSTRING
		RQ_PRIO=&RQ_PRIO.QUOTEDSTRING
		SC_PRIO=&SC_PRIO.QUOTEDSTRING
		DUE_L=&DUE_L.QUOTEDSTRING
		DUE_H=&DUE_H.QUOTEDSTRING
		CONTEXT=&CONTEXT.QUOTEDSTRING
		WFFMT='PDF'
	),
$
 
TYPE=HEADING, LINE=1, ITEM=6, CLASS=HEADING COLON,$
TYPE=HEADING, LINE=1, ITEM=7, CLASS=HEADING,
	TARGET=_blank,
	FOCEXEC=&FOCFEXNAME(
		USER_GROUP=&USER_GROUP.QUOTEDSTRING
		LAB=&LAB.QUOTEDSTRING
		REQUEST=&REQUEST.QUOTEDSTRING
		SAMPLE=&SAMPLE.QUOTEDSTRING
		METHOD=&METHOD.QUOTEDSTRING
		METHODCLASS=&METHODCLASS.QUOTEDSTRING
		EQUIPMENT=&EQUIPMENT.QUOTEDSTRING
		STATUS=&STATUS.QUOTEDSTRING
		RQ_PRIO=&RQ_PRIO.QUOTEDSTRING
		SC_PRIO=&SC_PRIO.QUOTEDSTRING
		DUE_L=&DUE_L.QUOTEDSTRING
		DUE_H=&DUE_H.QUOTEDSTRING
		CONTEXT=&CONTEXT.QUOTEDSTRING
		WFFMT='XLSX'
	),
$
-:PDFLNKSKP1
 
TYPE=SUBHEAD, BY=EQUIPMENT_TYPE, CLASS=SUBHEAD emph,$
 
TYPE=DATA, COLUMN=RQ_PRIORITY, CLASS=DATA, WHEN=RQ_PRIOSORT EQ 0,$
TYPE=DATA, COLUMN=RQ_PRIORITY, CLASS=DATA orange, WHEN=RQ_PRIOSORT LT 2,$
TYPE=DATA, COLUMN=RQ_PRIORITY, CLASS=DATA yellow, WHEN=RQ_PRIOSORT EQ 2,$
 
TYPE=DATA, COLUMN=SC_PRIORITY, CLASS=DATA, WHEN=SC_PRIOSORT EQ 0,$
TYPE=DATA, COLUMN=SC_PRIORITY, CLASS=DATA orange, WHEN=SC_PRIOSORT LT 2,$
TYPE=DATA, COLUMN=SC_PRIORITY, CLASS=DATA yellow, WHEN=SC_PRIOSORT EQ 2,$
 
TYPE=DATA, COLUMN=DUE, CLASS=DATA,$
TYPE=DATA, COLUMN=DUE, CLASS=DATA error, WHEN=DUE LT 0,$
 
TYPE=DATA, COLUMN=BARCODE, FONT=BARCODE, STYLE=NORMAL, BACKCOLOR=WHITE,
 SIZE=24,
$
 
-IF &WFFMT EQ 'PDF' OR 'XLSX' THEN GOTO :PDFLNKSKP2;
TYPE=DATA, COLUMN=RQ, CLASS=DATA,
	TARGET=_blank,
 
	DRILLMENUITEM='Request Overview & Results',
	FOCEXEC=UNI00020R_resultsMain(REQUEST=RQ),
 
	DRILLMENUITEM='PDF',
	FOCEXEC=&FOCFEXNAME(
		USER_GROUP=&USER_GROUP.QUOTEDSTRING
		LAB=&LAB.QUOTEDSTRING
		REQUEST=RQ
		SAMPLE=&SAMPLE.QUOTEDSTRING
		METHOD=&METHOD.QUOTEDSTRING
		METHODCLASS=&METHODCLASS.QUOTEDSTRING
		EQUIPMENT=&EQUIPMENT.QUOTEDSTRING
		STATUS=&STATUS.QUOTEDSTRING
		RQ_PRIO=&RQ_PRIO.QUOTEDSTRING
		SC_PRIO=&SC_PRIO.QUOTEDSTRING
		DUE_L=&DUE_L.QUOTEDSTRING
		DUE_H=&DUE_H.QUOTEDSTRING
		CONTEXT=&CONTEXT.QUOTEDSTRING
		WFFMT='PDF'
	),
 
$
TYPE=DATA, COLUMN=SC, CLASS=DATA,
	ALT='Sample Overview (& Results)',
	TARGET=_blank,
	FOCEXEC=UNI00020R_resultsMainSamples(SC=SC),
$
 
-* Dispersion report
TYPE=DATA, COLUMN=IMPORTID(2), CLASS=DATA,
	ALT='Filler dispersion',
	TARGET=_blank,
	WHEN=REPORTTYPE EQ 'UNI00036',
	FOCEXEC=UNI00036R_dispersion(
		PART_NO=PART_NO
		EXPLOSION_DATE=SC_PRODDATE
		IMPORT_ID=IMPORTID
		REQUEST=RQ
		BOM_TYPE='DISPERSION'
	),
$
 
-* Calander report
TYPE=DATA, COLUMN=IMPORTID(2), CLASS=DATA,
	ALT='Calander test results',
	TARGET=_blank,
	WHEN=REPORTTYPE EQ 'UNI00037',
	FOCEXEC=UNI00037R_KalanderProefNL(
		IMPORT_ID=IMPORTID
	),
$
 
-* Send FEA report
TYPE=DATA, COLUMN=IMPORTID(2), CLASS=DATA,
	ALT='Send FEA file',
	TARGET=_blank,
	WHEN=REPORTTYPE EQ 'UNI00022',
	FOCEXEC=UNI00022R_FEA(
		IMPORTID=IMPORTID
	),
$
 
-* Tyre Mounting
TYPE=DATA, COLUMN=ME, CLASS=DATA,
	ALT='Tyre Mounting',
	TARGET=_blank,
	WHEN=REPORTTYPE EQ 'UNI00046',
	FOCEXEC=UNI00046R_TyreMounting(
		SC=SC
		PG=PG
		PGNODE=PGNODE
		PA=PA
		PANODE=PANODE
		ME=ME
		MENODE=MENODE
	),
$
 
-* Bonus
TYPE=DATA, COLUMN=PART_NO, CLASS=DATA,
	TARGET=_blank,
	FOCEXEC=UNI00036R_dispersion(
		_PART_NO=PART_NO
		_EXPLOSION_DATE=SC_PRODDATE
		IMPORT_ID=IMPORTID
		BOM_TYPE='STANDARD'
	),
$
 
-GOTO :HTMLSKP;
 
-:PDFLNKSKP2
 
-SET &WRAPGAP = ON;
 
TYPE=REPORT, COLUMN=SC, WRAP=2.5, WRAPGAP=&WRAPGAP,				$	 2.5
TYPE=REPORT, COLUMN=SC_PRIORITY, WRAP=1.5, WRAPGAP=&WRAPGAP,	$	 4
TYPE=REPORT, COLUMN=PART_NO, WRAP=3.5, WRAPGAP=&WRAPGAP,		$	 7.5
TYPE=REPORT, COLUMN=AVTESTMETHOD, WRAP=4.5, WRAPGAP=&WRAPGAP,	$	11.5
TYPE=REPORT, COLUMN=ME, WRAP=1.5, WRAPGAP=&WRAPGAP,				$	13
TYPE=REPORT, COLUMN=ME_DESCRIPTION, WRAP=4.5, WRAPGAP=&WRAPGAP,	$	17
TYPE=REPORT, COLUMN=IMPORTID(2), WRAP=1.5, WRAPGAP=&WRAPGAP,	$	18.5
TYPE=REPORT, COLUMN=BARCODE, WRAP=3.5, WRAPGAP=&WRAPGAP,		$	22
 
-:HTMLSKP
 
ENDSTYLE
END
-RUN
*/
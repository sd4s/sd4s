--Een groupkey waarvan ik zie dat die gewijzigd wordt is uvwsgktestweek.

descr utwsgktestweek
/*
TESTWEEK  	VARCHAR2(40)
WS			VARCHAR2(40)
*/

--utwshs.what_description
--worksheet "PBR1313038T-001" group key "TestWeek" is created/updated.
select count(*), utwshs.ws
from utwshs
where what_description like 'worksheet%TestWeek%'
group by utwshs.ws
having count>1
;
/*
2	13.001.RAG-001
6	13.002.RAG-001
6	13.002.RAG-002
7	13.002.RAG-003
7	13.002.RAG-004
7	13.002.RAG-005
5	13.002.RAG-Y
7	13.003.RAG-001
7	13.003.RAG-002
2	13.003.RAG-W
*/

select * from utwshsdetails where ws = '13.002.RAG-001' and details like '%TestWeek%'  order by tr_seq, seq
/*
13.002.RAG-001	29117	790328	2	Groupkey "TestWeek" with value "" is removed from worksheet "13.002.RAG-001".
13.002.RAG-001	29117	790328	3	Groupkey "TestWeek" is added to worksheet "13.002.RAG-001", value is "2013-16".
13.002.RAG-001	109035	60029	2	Groupkey "TestWeek" with value "2013-16" is removed from worksheet "13.002.RAG-001".
13.002.RAG-001	109035	60029	3	Groupkey "TestWeek" is added to worksheet "13.002.RAG-001", value is "2013-17".
13.002.RAG-001	428553	361498	1	worksheet "13.002.RAG-001" group key "TestWeek" is created/updated.
13.002.RAG-001	428553	361498	1	worksheet "13.002.RAG-001" group key "TestWeek" is created/updated.
13.002.RAG-001	428553	361498	1	worksheet "13.002.RAG-001" group key "TestWeek" is created/updated.
13.002.RAG-001	428553	361498	1	worksheet "13.002.RAG-001" group key "TestWeek" is created/updated.
13.002.RAG-001	428553	361498	1	worksheet "13.002.RAG-001" group key "TestWeek" is created/updated.
13.002.RAG-001	428553	361498	1	worksheet "13.002.RAG-001" group key "TestWeek" is created/updated.
13.002.RAG-001	428553	361498	2	Groupkey "TestWeek" is added to worksheet "13.002.RAG-001", value is "".


--conclusie: TESTWEEK is gewijigd van 2013-06 naar 2013-07. Op SAMPLE-nivaue HEBBEN we nog steeds een YEAR/MONTH = 2013-06.
--           Wat is dit nog voor een datum ? Had deze niet in SYNC moeten blijven met de TEST-WEEK op WS-level?
--
*/


--uitvragen nieuwe WS
--utws
--utwssc
--utwsgk 
--utwsgktestweek
--utwsau

select * from utwsgk where ws = '13.002.RAG-001'
/*
WS				GK					GKSEQ	VALUE
13.002.RAG-001	NumberOfRefs		500		1
13.002.RAG-001	NumberOfVariants	500		6
13.002.RAG-001	RefSetDesc			500	
13.002.RAG-001	RequestCode			500		13.002.RAG
13.002.RAG-001	RimETfront			503		50
13.002.RAG-001	RimETrear			502		50
13.002.RAG-001	RimWidthFront		505		6.5
13.002.RAG-001	RimWidthRear		504		6.5
13.002.RAG-001	SubProgramID		500		Y
13.002.RAG-001	TestLocation		500		ATP
13.002.RAG-001	TestPrio			500	
13.002.RAG-001	TestSetSize			500		4
13.002.RAG-001	TestVehicleType		500		VW Golf VI
13.002.RAG-001	TestWeek			506		2013-17          -- TESTWEEK !!!!!!!
13.002.RAG-001	avBrakeInMilage		500	
13.002.RAG-001	avTestMethod		500		TT800A
13.002.RAG-001	avTestMethodDesc	500		Dry braking ABS
13.002.RAG-001	opensheets			500		13.002.RAG-001
13.002.RAG-001	p_infl_front		500		2.00
13.002.RAG-001	p_infl_rear			500		2.00

conclusie: we hebben dus een GK=TEST-WEEK op WS-level, en niet op SC-level !!!
           
*/

select ws.*
from utws    ws
where ws.ws = '13.002.RAG-001'
/*
13.002.RAG-001	PCTOutdoorTesting	0001.00	PCT outdoor testing	17-04-2013 01.30.14.000000000 PM
*/

select * from utwsau where ws = '13.002.RAG-001'
/*
WS				AUDIT			AUSEQ	VALUE
13.002.RAG-001	NumberOfRefs		1	1
*/

select * from utwssc where ws='13.002.RAG-001'
/*
13.002.RAG-001	1	13.002.RAG01
13.002.RAG-001	2	13.002.RAG03
13.002.RAG-001	3	13.002.RAG04
13.002.RAG-001	4	13.002.RAG05
13.002.RAG-001	5	13.002.RAG06
13.002.RAG-001	6	13.002.RAG07

CONCLUSIE: onder deze WS hangen 6x SC. Krijgen dus allemaal een TEST-WEEK=2013-07
*/

SELECT * FROM UTSCAU where SC = '13.002.RAG01' ;
/*
13.002.RAG01	avCustScManual2AV		5	1
*/
SELECT * FROM UTSCGK where SC = '13.002.RAG01' ;
/*
13.002.RAG01	Context			505	Trials
13.002.RAG01	PART_NO			500	T-T: PCT normal set
13.002.RAG01	Project			500	RDNP1201:Glowintheda
13.002.RAG01	RequestCode		516	13.002.RAG
13.002.RAG01	SPEC_TYPE		504	PCT
13.002.RAG01	Workorder		500	RDNP1201
13.002.RAG01	day				500	15
13.002.RAG01	isTest			515	0
13.002.RAG01	month			500	04
13.002.RAG01	partGroup		502	Personal Car Tyres
13.002.RAG01	partGroup		503	VR-produced
13.002.RAG01	rqStatus		500	Completed
13.002.RAG01	rqStatusType	500	Relevant
13.002.RAG01	scCreateUp		508	Construction PCT
13.002.RAG01	scCreateUp		510	Tyre testing adv.
13.002.RAG01	scCreateUp		513	Tyre testing adv mgt
13.002.RAG01	scListUp		507	Construction PCT
13.002.RAG01	scListUp		509	Tyre testing adv.
13.002.RAG01	scListUp		514	Tyre testing adv mgt
13.002.RAG01	scReceiverUp	511	Tyre testing adv mgt
13.002.RAG01	scReceiverUp	512	Tyre testing adv.
13.002.RAG01	week			500	16
13.002.RAG01	year			500	2013

CONCLUSIE: komen op SC-level GEEN TEST-WEEK tegen !!! Wel een YEAR/MONTH, heeft dat relatie met elkaar?
*/

select * from UTWSII where ws='13.002.RAG-001'
/*
no-rows-selected
*/

select * from utrqgk where rq=' 13.002.RAG' 
/*
13.002.RAG	RequestCode		500	13.002.RAG
13.002.RAG	RqDay			500	15
13.002.RAG	RqExecutionWeek	500	
13.002.RAG	RqMonth			500	04
13.002.RAG	RqWeek			500	16
13.002.RAG	RqYear			500	2013
13.002.RAG	Workorder		500	RDNP1201
13.002.RAG	isRelevant		500	1
13.002.RAG	isTest			513	0
13.002.RAG	rqStatusType	500	Relevant
*/

select * from utrqau where rq='13.002.RAG' 
/*
no-rows-selected
*/

select * from utrq where rq='13.002.RAG' 
/*
13.002.RAG	T-T: PCT Outdoor	0001.02	Testing PCT outdoor 
*/




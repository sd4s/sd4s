--ISSUE: we zien bij EXECUTION-DASHBOARD SAMPLE wel een LEGE-CONTEXT, maar bij METHODS niet.
--       Hoe kan dat???

select sc.sc from utsc sc where not exists (select gk.sc from utscgkcontext gk where gk.sc = sc.sc);

/*
2342000322
2342002279
2344000231
2345000136
2346000175
2346000306
2347000474
2348000188
2349000242
2349002979
2401000019
2401000020
2401000687
2402001335
2403002418
2404002131
2406000033
2407000045
2407002345
2408000354
ANP1836033M03
ASR1724050T03
BGR1118036T01
BGR1739076T01
BGR1743025T01
EWE1718082T05
HAR1725073T01
HAR1744059T01
HAR1749086T02
HKW1818046T01
HKW1820085T02
HKW1824037T01
IBO2134000T01
JSI1731030T01
JTL2137006M01
JTL2137006M03
JTL2137006M04
JTL2137006M05
JTL2137006M06
JTL2137006M07
JTL2137009M01
JTL2137009M02
LRM1706043T10
RTW1711034T13
RTW1713043T01
RTW1723022T15
RTW1723022T16
TSC1702057T02
--
65756 rijen !!!! zonder context !!!!!!!!
*/

select * from utsc where sc='2407002345';
2407002345	RM_5712	0001.02	Reference steel-cord 3*0.30	0	DD	16-02-2024 11.28.29.000000000 AM	16-02-2024 11.28.36.000000000 AM	THA	16-02-2024 11.30.40.000000000 AM	19-02-2024 11.56.22.000000000 AM	3											0			1	1	1	1	S1	0	CM	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	16-02-2024 11.28.29.000000000 AM CET	16-02-2024 11.28.36.000000000 AM CET	16-02-2024 11.30.40.237000000 AM CET						
--RQ=NULL, status = CM

select * from utsc where sc='2408000354';
2408000354	RM_5712	0001.02	Reference steel-cord 3*0.30	0	DD	20-02-2024 01.36.58.000000000 PM	20-02-2024 01.37.06.000000000 PM	THA	20-02-2024 01.38.42.000000000 PM	21-02-2024 01.34.24.000000000 PM	3											0			1	1	1	1	S1	0	CM	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	20-02-2024 01.36.58.000000000 PM CET	20-02-2024 01.37.06.000000000 PM CET	20-02-2024 01.38.41.729000000 PM CET						
--RQ=NULL, status = CM

select sc.sc, sc.ss from utsc sc where SC.RQ is not null AND not exists (select gk.sc from utscgkcontext gk where gk.sc = sc.sc);
/*
BGR1739076T01	CM
HKW1820085T02	CM
ANP1836033M03	@C
LRM1706043T10	@C
JTL2137006M05	@C
TSC1702057T02	CM
1				@C
RTW1723022T16	CM
092503887		@C
RTW1723022T15	CM
JSI1731030T01	CM
092503888		@C
EWE1718082T05	CM
JTL2137009M01	@P
BGR1118036T01	@C
JTL2137006M07	@P
ASR1724050T03	CM
JTL2137009M02	@P
BGR1743025T01	CM
JTL2137006M01	@C
JTL2137006M03	@C
JTL2137006M06	@P
HAR1744059T01	CM
HKW1818046T01	CM
HAR1725073T01	CM
JTL2137006M04	@C
RTW1711034T13	CM
RTW1713043T01	CM
HAR1749086T02	CM
HKW1824037T01	CM
*/

SELECT *
from av_exec_db_samples
where user_group_value    = 'Physical lab'   
and   method_lab = 'PV RnD'
and   context is null
;

5	Physical lab	user_group	Physical lab	avUpClass	Execution									2335000017	911Turbo-S   Spoiler with actuator    (B			2335000017			OS	Out of spec	3	CM	Completed	PV RnD	1
5	Physical lab	user_group	Physical lab	avUpClass	Execution									1950005066	Temp. and Humidity Conditioning Room			1950005066			OS	Out of spec	3	CM	Completed	PV RnD	1

--waarom zitten deze niet in de METHOD-LIST?
sc.sc not in (select itsc.sc from utscgkistest  itsc  where itsc.sc = sc.sc and itsc.istest = '1' )
and   rq.rq not in (select itrq.rq from utrqgkistest  itrq  where itrq.rq = rq.rq and itrq.istest = '1' )

SELECT * FROM utscgkistest WHERE SC = '2335000017'
--0

select * from utscmegkme_is_relevant where sc= '2335000017'
--null
select * from utscmegkme_is_relevant where sc= '1950005066'
--null

--DE TWEE SAMPLES die geen CONTEXT hebben, komen niet voor in de tabel = UTSCMEGKME_IS_RELEVANT.


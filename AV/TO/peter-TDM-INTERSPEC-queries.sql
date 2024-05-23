--prompt VIEWS om INTERSPEC-data te selecteren

--specification-type / CLASS3
select * from class3 order by sort_desc;
/*
700634	 	trial spec AT greentire	1	OTHER	0
700301	ADDIT	Additives	1	ING	0
700302	ASSEM	Assemblies	1	OTHER	0
700303	AT	Agricultural tyres	1	OTHER	0
700455	AT_Carcass	Carcass Agricultural Tyres	1	OTHER	0
700454	AT_GT	Greentire  Agricultural Tyres	1	OTHER	0
700994	Athena	Athena reporting spec	1	OTHER	0
700574	AT_source	Agriculture source	1	OTHER	0
700315	AUXMAT	Auxilary materials	1	ING	0
700754	BBQ	BBQ specifications	1	OTHER	0
700755	BBQ_Comp	BBQ components	1	OTHER	0
700756	BBQ_RM	BBQ raw materials	1	OTHER	0
700474	BEADWIRE	Beadwire (reinforcement)	1	ING	0
700834	BUDG_T	budget future tyres	1	OTHER	0
700734	CALIB	Calibration specs	1	OTHER	0
701134	CERT	Certificate	1	OTHER	0
700476	CHAFER	Chafer (reinforcement)	1	ING	0
700314	CHEMICAL	Other chemicals	1	ING	0
700374	CONTROL	Controlplan	1	OTHER	0
700316	CURING	Curing agents	1	ING	0
142	Delete	Trial of Athena testing specs	0	OTHER	0
700304	EXTR	Extrudates	1	OTHER	0
700478	FABRIC	Fabric (reinforcement)	1	ING	0
700494	FABRICUD	Fabric undipped	1	ING	0
700305	FILL	Fillers	1	ING	0
700894	FILLWHITE	Fillers White	1	ING	0
700306	FM	Final mix	1	OTHER	0
700534	FM_bought	bought compound	1	OTHER	0
700594	FM_sold	Final mix sold	1	OTHER	0
700854	G_COMP	Global compounds R&D PV	1	OTHER	0
700307	INDUS	Industrial tyres	1	OTHER	0
701114	MCT	Motor Cycle tyres 	1	OTHER	0
701074	OEM_SUB	OEM submission	1	OTHER	0
700654	PA	Pre assembly	1	OTHER	0
700714	PA_AT	Pre-assembly SM	1	OTHER	0
700554	PCR_GT	Passenger Car Radial greentire	1	OTHER	0
700774	PCR_source	PCR tyres source	1	OTHER	0
700674	PCR_VULC	Passenger car radial vulcanized tyre	1	OTHER	0
700309	PCT	Passenger Car Tyres	1	OTHER	0
700311	POLYM	Polymers	1	ING	0
700954	PROCESS	Process setting	1	OTHER	0
701056	RAW MAT	Raw materials	1	ING	0
700855	R&D_COMP	Trial Global compounds	1	OTHER	0
700917	RECYCL MAT	Recycled materials	1	ING	0
700312	REINF	Reinforcement materials	1	ING	0
700914	RESINS	Resins	1	ING	0
701034	RNDREF	R&D reference specifications	1	OTHER	0
700876	RUB CHEM	Rubber Chemicals	1	ING	0
700916	SILANES	Raw materials silanes	1	ING	0
700394	SM	Space master tyres	1	OTHER	0
701014	SM_BXWHEEL	Spacemaster boxed wheels	1	OTHER	0
700694	SM_GT	Space master Greentire	1	OTHER	0
700874	SOFTENER	Softeners	1	ING	0
700313	STEELCOMP	 Steelcord composites	1	OTHER	0
700481	STEELCORD	Steelcord (reinforcement)	1	ING	0
700934	TBR	TBR tyres	1	OTHER	0
700935	TBR_GT	TBR greentyres	1	OTHER	0
701057	TBR_VULC	TBR vulcanized tyre	1	OTHER	0
700354	TCE_ADDIT	Trial Additives	1	ING	0
700355	TCE_ASSEM	Trial Assemblies	1	OTHER	0
700356	TCE_AT	Trial Agricultural tyres	1	OTHER	0
701055	TCE_Athena	Trial version of Athena spec	1	OTHER	0
700357	TCE_AUXMAT	Trial Auxilary materials	1	ING	0
700614	TCE_BBQ	Trial BBQ	1	OTHER	0
700475	TCE_BEADW	Trial beadwires	1	ING	0
700477	TCE_CHAFER	Trial chafers (reinforcement)	1	ING	0
700358	TCE_CHEM	Trial Other chemicals	1	ING	0
700359	TCE_CURING	Trial Curing agents	1	ING	0
700360	TCE_EXTR	Trial Extrudates	1	OTHER	0
700365	TCE_FABCOM	Trial Fabric composites	1	OTHER	0
700479	TCE_FABRIC	Trial fabric (reinforcement)	1	ING	0
700361	TCE_FILL	Trial Fillers	1	ING	0
700362	TCE_FM	TCE Final mix	1	OTHER	0
700363	TCE_INDUS	Trial Industrial tyres	1	OTHER	0
700514	TCE_MOD_CO	Trial Model compound	1	OTHER	0
700515	TCE_MOD_PL	Trial Model Ply	1	OTHER	0
700516	TCE_MOD_TY	Trial Model tyre	1	OTHER	0
700814	TCE_PCR	Trial Passenger Car Tyres	1	OTHER	0
700555	TCE_PCR_GT	Trial Passenger Car Radial greentires	1	OTHER	0
700815	TCE_PCR_VU	Trial Passenger Car Tyres Vulcanized tyre	1	OTHER	0
700364	TCE_PCT	Trial Passenger Car Tyres	1	OTHER	0
700366	TCE_POLYM	Trial Polymers	1	ING	0
700367	TCE_REINF	Trial Reinforcement materials	1	ING	0
701094	TCE_RESINS	Trial resins	1	ING	0
700414	TCE_SM	Trial Space master tyres	1	OTHER	0
700974	TCE_SM_GT	Trial Spacemaster Greentyre	1	OTHER	0
700480	TCE_STEEL	Trial steelcord (reinforcement)	1	ING	0
700369	TCE_STEELC	Trial  Steelcord composites	1	OTHER	0
700368	TCE_XNP	TCE XNP compound	1	OTHER	0
700310	TEXTCOMP	Textile composites	1	OTHER	0
700794	TWT	Two Wheel Tyre	1	OTHER	0
700875	VAR RM	Various Raw materials	1	ING	0
82	verwijdern	Fillers carbon black	0	OTHER	0
700915	VULC AGENT	Raw materials Vulcanizing agents	1	ING	0
700877	WHITE FILL	White Fillers	1	ING	0
700334	XNP	XNP compound	1	OTHER	0
*/

--status
SELECT * from STATUS;
/*
-1	<PED>	<Planned Effective Date>	<N/A>	N	Use interspc_cfg to define the title	0	0	0	0
1	DEV	In Development	DEVELOPMENT	N	Specification created in Development	0	0	0	0
2	SUBMIT	Submit for Approval	SUBMIT	N	Specification Submitted for Approval	1	1	0	0
3	APPROVED	Approved	APPROVED	N	Specification Approved	0	0	0	0
4	CURRENT	Current	CURRENT	N	Specification has become Current	0	0	0	0
5	HISTORIC	Historic	HISTORIC	N	Specification has become Historic	0	0	0	0
6	REJECTED	Rejected	REJECT	N	Specification has been Rejected	0	0	0	0
7	OBSOLETE	Obsolete	OBSOLETE	N	Specification has been made Obsolete	0	0	0	0
*/

--plant
select * from PLANT;
/*
APR	Andhra Pradesh	I-S
AUR	Aurangabad	I-S
BHI	Bhiwadi	I-S
CHE	Chennai	I-S
CHO	Chopanki	I-S
CNB	CNB Camac	I-S
DEL	Deli tyre	I-S
DEV	Development Plant	I-S
ENS	Enschede Plant	I-S
GYO	Gyöngyöshalász	I-S
KAL	Kalamassery	I-S
KIR	Kirov Plant	I-S
LAD	Ladysmith plant	I-S
LIM	Limda	I-S
MOS	Moscow plant	I-S
PER	Perambra	I-S
PUN	Pune	I-S
VOR	Voronezh Plant	I-S
YAZ	Yazd Plant	I-S
0	default plant	I-S
*/


--specification met CURRENT-STATUS
select phe.part_no
,      par.description   part_descr
,      phe.revision
,      phe.status
,      sta.description   status_descr
,      phe.description   phe_descr
from SPECIFICATION_HEADER  phe
inner join PART   par on (phe.part_no = par.part_no)
inner join STATUS sta on (phe.status = sta.status)
WHERE phe.status=4
and rownum < 3
;

--vind part-nr van eindproduct
select count(*), boi.item_number from bom_item boi 
where boi.part_no NOT IN (select boi2.component_part from bom_item boi2)
group by boi.item_number order by boi.item_number;
--
select boi.part_no
,      boi.revision
,      boi.plant
,      boi.item_number
,      boi.component_part
from bom_item
where part_no NOT IN (select boi2.component_part from bom_item )
;





--specifications
select phe.part_no
,      par.description   part_descr
,      par.base_uom      part_base_uom
,      phe.revision
,      phe.status
,      sta.description   status_descr
,      phe.description   phe_descr
,      phe.frame_id      --fk?
,      phe.frame_rev
,      phe.access_group      --fk
,      phe.workflow_group_id  --fk
,      phe.class3_id         --fk
,      cla.sort_desc
from SPECIFICATION_HEADER  phe
inner join PART   par on (phe.part_no = par.part_no)
inner join STATUS sta on (phe.status = sta.status)
inner join FRAME_HEADER fra  on (phe.frame_id = fra.frame_no)
inner join CLASS3 cla        on (phe.class3_id = cla.class)
where phe.part_no  = 'EF_R225/70R15C2W'
and   phe.revision = 2
;

/*
part-no				part-descr                                      part-base-uom  	revision	status	phe-descr												frame-id		frame-rev	access-group	workflow-group-id	class3_iD   sort-desc
EF_R225/70R15C2W	225/ 70 R 15  112R Comtrac 2 Winter (NEW 2017)	pcs				2			4		Current	225/ 70 R 15  112R Comtrac 2 Winter (NEW 2017)	E_Budget_tyres	7			1445			230					700834		BUDG_T
*/

--uitvragen van FRAME-info
select * from FRAME_HEADER where frame_no = 'E_Budget_tyres';
/*
E_Budget_tyres	9	1	3	Frame budget future tyres	18/9/2019 11:56:13	PGO	2/1/2019 14:09:39	PGO	2/1/2019 14:14:27	0	700834	230	1445			0
*/
--uitvragen van frame-text
SELECT * FROM FRAME_TEXT where frame_no='E_Budget_tyres' 
--no-rows-selected

--uitvragen frame-properties
SELECT frame_no
,      revision
,      owner
,      section_id
,      section_rev
,      sub_section_id
,      sub_section_rev
,      property_group
,      property_group_rev
,      property
,      property_rev
,      uom_id
,      uom_rev
,      test_method
,      test_method_rev
,      sequence_no
,      characteristic
,      characteristic_rev
,      association
,      association_rev
FROM FRAME_PROP 
where frame_no='E_Budget_tyres' 
and revision=7
ORDER by sequence_no
;
/*
frame_no		  		section_id  sub-section_id	property-group	property	attr		uom	test_method	seq-no
E_Budget_tyres	9	1	700579	100	0	100			701563	100		1011	100	0	100		0	0				1300																								42	0	Y	0	200		0		0		0		0		0
E_Budget_tyres	9	1	700579	100	0	100			701563	100		1057	100	0	100		0	0				1200																								44	0	Y	0	100		0		0		0		0		0
E_Budget_tyres	9	1	700579	100	0	100			701563	100		1122	100	0	100		0	0				1400																								62	0	Y	0	100		0		0		0		0		0
E_Budget_tyres	9	1	700579	100	0	100			701563	100		703418	301	0	100		0		0			400																								900144	0	Y	0	100		0		0		0		0		0
E_Budget_tyres	9	1	700579	100	0	100			701563	100		703422	301	0	100		0		0			300																								900143	0	Y	0	100		0		0		0		0		0
E_Budget_tyres	9	1	700579	100	0	100			701563	100		703455	501	0	100		0		0			100																								900142	0	Y	0	100		0		0		0		0		0
E_Budget_tyres	9	1	700579	100	0	100			701563	100		703544	401	0	100		0		0			500																								900166	0	Y	0	100		0		0		0		0		0
E_Budget_tyres	9	1	700579	100	0	100			701563	100		705045	201	0	100		0		0			600																								900141	0	Y	0	100		0		0		0		0		0
E_Budget_tyres	9	1	700579	100	0	100			701563	100		705088	400	0	100		0		0			700																								900167	0	Y	0	100		0		0		0		0		0
E_Budget_tyres	9	1	700579	100	0	100			701563	100		707328	201	0	100		0		0			800																								900141	0	Y	0	100		0		0		0		0		0
E_Budget_tyres	9	1	700579	100	0	100			701563	100		709308	100	0	100		0	0				900																								900141	0	Y	0	100		0		0		0		0		0
E_Budget_tyres	9	1	700579	100	0	100			701563	100		709309	100	0	100		0	0				1000																								900141	0	Y	0	100		0		0		0		0		0
E_Budget_tyres	9	1	700579	100	0	100			701563	100		710308	100	0	100		0	0				1100																								900206	0	Y	0	100		0		0		0		0		0
E_Budget_tyres	9	1	700579	100	0	100			701563	100		711128	100	0	100		0	0				1500																								900220	0	Y	0	100		0		0		0		0		0
E_Budget_tyres	9	1	700579	100	0	100			701563	100		711748	100	0	100		0	0				200																								900239	0	Y	0	100		0		0		0		0		0
E_Budget_tyres	9	1	700584	100	0	100			702066	300		708608	200	0	100	701449	100	701368	100	100																									0	Y	0	0		0		0		0		0		0
E_Budget_tyres	9	1	700584	100	0	100			702656	100		708628	200	0	100	701450	100	701389	100	100																									0	Y	0	0		0		0		0		0		0
E_Budget_tyres	9	1	700584	100	0	100			702656	100		708629	200	0	100	700569	100	701390	100	200																									0	Y	0	0		0		0		0		0		0
E_Budget_tyres	9	1	700755	200	0	100			0	0			705428	100	0	100		0		0			100																								900245	0	Y	0	100		0		0		0		0		0
E_Budget_tyres	9	1	700755	200	0	100			0	0			705429	100	0	100		0		0			100																								900137	0	Y	0	101		0		0		0		0		0
E_Budget_tyres	9	1	700755	200	0	100			0	0			709030	200	0	100		0		0			100																							900484	900141	0	Y	100	100		0		0		0		0		0
E_Budget_tyres	9	1	700755	200	0	100			0	0			710531	200	0	100		0		0			100																							900974	900211	0	Y	100	100		0		0		0		0		0
E_Budget_tyres	9	1	700755	200	0	100			704056	100		713824	200	0	100		0	0				100																									0	N	0	0		0		0		0		0		0
E_Budget_tyres	9	1	700755	200	0	100			704056	100		713825	200	0	100		0	0				200																									0	N	0	0		0		0		0		0		0
*/


--uitvragen van property
select * from PROPERTY where property=1011;
/*
1011	Ply construction	1	0
*/

select * from ATTRIBUTE_PROPERTY where property=1011;
--no-rows-selected

--Echte data komt voor in SPECIFICATION_PROP-tabel
SELECT PART_NO, revision, property, property_rev, num_1, num_2, num_3, char_1, char_2, char_3, characteristic, association
from SPECIFICATION_PROP  spr
where spr.part_no  = 'EF_R225/70R15C2W'
and   spr.revision = 2
--and   spr.property = 1011
;
/*
EF_R225/70R15C2W	2	1011	100							345		42
EF_R225/70R15C2W	2	1057	100							485		44
EF_R225/70R15C2W	2	1122	100							361		62
EF_R225/70R15C2W	2	703418	301							900531	900144
EF_R225/70R15C2W	2	703422	301							903234	900143
EF_R225/70R15C2W	2	703455	501							900486	900142
EF_R225/70R15C2W	2	703544	401							900613	900166
EF_R225/70R15C2W	2	705045	201							900485	900141
EF_R225/70R15C2W	2	705088	400							903196	900167
EF_R225/70R15C2W	2	707328	201							900485	900141
EF_R225/70R15C2W	2	709308	100							900485	900141
EF_R225/70R15C2W	2	709309	100							900485	900141
EF_R225/70R15C2W	2	710308	100							900934	900206
EF_R225/70R15C2W	2	711128	100							901099	900220
EF_R225/70R15C2W	2	711748	100							901323	900239
EF_R225/70R15C2W	2	708608	100				C				
EF_R225/70R15C2W	2	708628	100	71	72	71	2				
EF_R225/70R15C2W	2	708629	100				B				
EF_R225/70R15C2W	2	705428	100							900360	900245
EF_R225/70R15C2W	2	705429	100	14						900419	900137
EF_R225/70R15C2W	2	709030	200							901013	900141
EF_R225/70R15C2W	2	710531	200							900974	900211
*/

--wat is property 708628 met meerdere NUM-waardes en CHAR-waarde?
select * from PROPERTY where property=708628;
--708628	ECE Noise labeling	1	0




--tbv RAPPORTAGES:
--uitvragen van SPECDATA:
select * from SPECDATA where part_no='EF_R225/70R15C2W' and property=1011;
/*
En hier kom ik dus de ECHTE-DATA pas tegen 
EF_R225/70R15C2W	2	700579	0	14	1	701563	100	701563	1011	0	700511	345	1 Up 1 Down	-1	-1	345	42	-1	0	0		100	100	100	100	100	0	0	0	200	101	0	1
*/
select * from FRAMEDATA where frame_no='E_Budget_tyres'  and property=1011;
/*
E_Budget_tyres	9	1	700579	0	40	1	701563	100	701563	1011	0	700511			-1	0	-1	42	-1	0	0		100	100	100	100	100	0	-1	0	200	101	0
*/


--association
select * from ASSOCIATION where association=42;
42	Ply construction	C	1	0

--characteristic
select ass.association  
,      ass.description   ass_desc
,      cha.characteristic_id 
,      cha.description   cha_desc
from  CHARACTERISTIC_ASSOCIATION cas
INNER JOIN ASSOCIATION  ass  ON (cas.association = ass.association)
INNER JOIN CHARACTERISTIC cha ON (cas.characteristic = cha.characteristic_id)
where ass.association=42
;
/*
42	Ply construction	341	1 Up
42	Ply construction	345	1 Up 1 Down
42	Ply construction	346	2 Up
42	Ply construction	350	Envelope
42	Ply construction	481	1 Up 1 Inside
42	Ply construction	642	2 Up 1 Down
42	Ply construction	641	3 Up
*/


--Wat zit er dan in PROPERTY-ASSOCIATION
SELECT property from property_association where association=42;
--alleen property: 1011
--dat is op zich wel logisch. Alleen bij deze property komt deze LOV voor. De andere attributen zijn gerelateerd aan andere ASSOCIATIONS.
--het is op zich wel vreemd dat er uberhaupt maar 1 x property is die gelinked is. Dat zou betekenen dat deze property bij meerdere specifications terugkomt.

--tellen bij hoeveel specifications deze property voorkomt.
select part_no, revision, property_group, property, attribute, section_id, sub_section_id  from SPECIFICATION_PROP where property=1011 GROUP BY part_no, revision, property_group, property, attribute, section_id, sub_section_id;
select DISTINCT property_group, property, attribute, section_id, sub_section_id  from SPECIFICATION_PROP where property=1011 ;
--701563	1011	0	700579	0














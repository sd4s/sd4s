--Find INTERSPEC.SPECIFICATION-PROPERTIES:
In interspec : D-Spec – Construction type – cap strip layup						    
section_id=700835 and sub_section_id=0 and property_group=702056 and property=965

In interspec : D spec – parent segment – M.B.W										
section_id=700835 and sub_section_id=0 and property_group=186    and property=705212

In interspec : D-Spec – Construction type – number of plies							
section_id=700835 and sub_section_id=0 and property_group=702056 and property=712615

In interspec : D-spec – master drawing general – overall diameter 					
section_id=700835 and sub_section_id=0 and property_group=185    and property=705300

In interspec : D spec – Child Segment – Section Width								
section_id=700835 and sub_section_id=0 and property_group=182    and property=703424

In interspec : General Information – ETRTO Properties – ETRTO rimwidth – target		
section_id=700579 and sub_section_id=0 and property_group=701562 and property=705195

--sections
select section_id, description 
from section 
where description in ('D-spec'
                     ,'General information'
                     )
order by section_id;
/*				 
700579	General information
700835	D-spec
*/

select sub_section_id, description 
from sub_section 
where description in (''
                     )
order by sub_section_id;

--INTERSPEC-PROPERTY-GROUPS:
select property_group, description 
from property_group 
where description in ('Construction type'
                     ,'Parent segment'
					 ,'Master drawing general'
					 ,'Child segment'
					 ,'ETRTO properties'
                     )
order by property_group;
/*
182		Child segment
185		Master drawing general
186		Parent segment
701562	ETRTO properties
702056	Construction type
*/

--Interspec-properties:
select property, description 
from property 
where description in ('Cap-strip layup'
                     ,'M.B.W.'
					 ,'Number of plies'
					 ,'Overall diameter'
					 ,'Section width'
					 ,'ETRTO rimwidth'
                     ) 
order by property;

/*
965		Cap-strip layup
703424	Section width
705195	ETRTO rimwidth
705212	M.B.W.
705300	Overall diameter
712615	Number of plies
*/

--Body ply type, Type Spiral, Belt Material and Angle, Apex Height
--In interspec: Supposedly in Bill of Material



--select section-id/sub-section-id/property-group
select DISTINCT sd.section_id, sd.sub_section_id, sd.property_group, sd.property, p.description
from specdata sd
,    property p
where description in ('Cap-strip layup'
                     ,'M.B.W.'
					 ,'Number of plies'
					 ,'Overall diameter'
					 ,'Section width'
					 ,'ETRTO rimwidth'
                     ) 
and  p.property = sd.property					 
;
	
/*	
section sub-sec propgrp prop    prop-description
------- ------- ------- ------  ----------------
700835	0		701565	705212	M.B.W.
701058	702946	702896	703424	Section width
701058	702946	702896	705300	Overall diameter
700835	0		186		703424	Section width
700835	0		702056	712615	Number of plies
700579	700542	701569	703424	Section width
700835	0		701561	703424	Section width
700579	0		701562	705195	ETRTO rimwidth
700579	0		701569	703424	Section width
700835	0		701561	705300	Overall diameter
701058	702603	702896	703424	Section width
700584	0		701561	703424	Section width
701058	702603	702896	705300	Overall diameter
700935	701522	703096	705212	M.B.W.
701058	700542	702896	705300	Overall diameter
700835	0		186		705212	M.B.W.
700835	0		182		705212	M.B.W.
700835	0		185		705300	Overall diameter
701058	702602	702896	705300	Overall diameter
700584	0		701561	705300	Overall diameter
700835	0		702056	965		Cap-strip layup
700835	0		182		703424	Section width
701058	702602	702896	703424	Section width
701058	700542	702896	703424	Section width
700835	0		701565	703424	Section width
700584	0		701562	705195	ETRTO rimwidth
*/

--It should have the  
--Rim protector (707328)
--and Rim protector radius (715087)
--properties in the ai_specification_data table.

--select section-id/sub-section-id/property-group
select DISTINCT sd.section_id, sd.sub_section_id, sd.property_group, sd.property, p.description
from specdata sd
,    property p
where description in ('Rim protector'
                     ,'Rim protector radius'
                     ) 
and  p.property = sd.property					 
;

700835	0	185		707328	Rim protector
700835	0	701565	715440	Rim protector radius
700579	0	701563	707328	Rim protector

select DISTINCT sd.section_id, s.description, sd.sub_section_id, su.description, sd.property_group, pg.description, sd.property, p.description
from section s
,    sub_section su
,    property_group pg
,    specdata sd
,    property p
where p.description in ('Rim protector'
                     ,'Rim protector radius'
                     ) 
and  p.property = sd.property					 
AND  sd.section_id = s.section_id
and  sd.sub_section_id = su.sub_section_id
and  sd.property_group = pg.property_group
;
/*
700579	General information	0	(none)	701563	General tyre characteristics	707328	Rim protector
700835	D-spec				0	(none)	701565	Master drawing					715440	Rim protector radius
*/

select DISTINCT sh.frame_id, sd.section_id, s.description, sd.sub_section_id, su.description, sd.property_group, pg.description, sd.property, p.description
from section        s 
,    sub_section    su
,    property_group pg
,    specdata       sd
,    property       p
,    status         st
,    specification_header sh
where p.description in ('Rim protector'
                     ,'Rim protector radius'
                     ) 
and  p.property = sd.property					 
AND  sd.section_id = s.section_id
and  sd.sub_section_id = su.sub_section_id
and  sd.property_group = pg.property_group
and  sd.part_no = sh.part_no
and  sd.revision = sh.revision
and  sh.status   = st.status
and  st.status_type = 'CURRENT' 
;
/*
let op: RIM-PROTECTOR-RADIUS property-id WIJKT IN TEST af van PRODUKTIE !!!!!!!!!!!!
--
Trial L_PCT		700579	General information	0	(none)	701563	General tyre characteristics	707328	Rim protector
E_PCR_source	700579	General information	0	(none)	701563	General tyre characteristics	707328	Rim protector
T_PCR_INT		700579	General information	0	(none)	701563	General tyre characteristics	707328	Rim protector
B_AT			700579	General information	0	(none)	701563	General tyre characteristics	707328	Rim protector
A_PCR_v1		700579	General information	0	(none)	701563	General tyre characteristics	707328	Rim protector
E_Budget_tyres	700579	General information	0	(none)	701563	General tyre characteristics	707328	Rim protector
A_PCR_v2		700579	General information	0	(none)	701563	General tyre characteristics	707328	Rim protector
E_AT			700579	General information	0	(none)	701563	General tyre characteristics	707328	Rim protector
Trial E_AT		700579	General information	0	(none)	701563	General tyre characteristics	707328	Rim protector
TE_Model tyre	700579	General information	0	(none)	701563	General tyre characteristics	707328	Rim protector
E_PCR			700579	General information	0	(none)	701563	General tyre characteristics	707328	Rim protector
Trial B_AT		700579	General information	0	(none)	701563	General tyre characteristics	707328	Rim protector
A_TBR_v1		700579	General information	0	(none)	701563	General tyre characteristics	707328	Rim protector
A_PCR			700835	D-spec	0	(none)	701565	Master drawing	715087	Rim protector radius
A_TBR			700579	General information	0	(none)	701563	General tyre characteristics	707328	Rim protector
L_PCT			700579	General information	0	(none)	701563	General tyre characteristics	707328	Rim protector
Trial E_PCT		700579	General information	0	(none)	701563	General tyre characteristics	707328	Rim protector
E_PCT			700579	General information	0	(none)	701563	General tyre characteristics	707328	Rim protector
A_PCR_PG2		700579	General information	0	(none)	701563	General tyre characteristics	707328	Rim protector
A_PCR			700579	General information	0	(none)	701563	General tyre characteristics	707328	Rim protector
*/

--700835	D-spec	0	182		Child segment	1033	Sidewall type
--700835	D-spec	0	186		Parent segment	1033	Sidewall type
--700835	D-spec	0	701565	Master drawing	715089	c_Ba


select DISTINCT sh.frame_id, sd.section_id, s.description, sd.sub_section_id, su.description, sd.property_group, pg.description, sd.property, p.description
from section        s 
,    sub_section    su
,    property_group pg
,    specdata       sd
,    property       p
,    status         st
,    specification_header sh
where p.description in ('Sidewall type'
                     ,'c_Ba'
                     ) 
and  p.property = sd.property					 
AND  sd.section_id = s.section_id
and  sd.sub_section_id = su.sub_section_id
and  sd.property_group = pg.property_group
and  sd.part_no = sh.part_no
and  sd.revision = sh.revision
and  sh.status   = st.status
and  st.status_type = 'CURRENT' 
;
/*
A_PCR		700835	D-spec	0	(none)	186		Parent segment	1033	Sidewall type
E_PCR		700835	D-spec	0	(none)	186		Parent segment	1033	Sidewall type
A_PCR_v1	700835	D-spec	0	(none)	182		Child segment	1033	Sidewall type
A_PCR		700835	D-spec	0	(none)	182		Child segment	1033	Sidewall type
A_PCR_v1	700835	D-spec	0	(none)	186		Parent segment	1033	Sidewall type
A_PCR_v2	700835	D-spec	0	(none)	186		Parent segment	1033	Sidewall type
A_PCR		700835	D-spec	0	(none)	701565	Master drawing	715089	c_Ba
E_PCR		700835	D-spec	0	(none)	182		Child segment	1033	Sidewall type
A_PCR_v2	700835	D-spec	0	(none)	182		Child segment	1033	Sidewall type
A_PCR_PG2	700835	D-spec	0	(none)	182		Child segment	1033	Sidewall type
A_PCR_PG2	700835	D-spec	0	(none)	186		Parent segment	1033	Sidewall type
*/




--********************************************************************************************
-- BEAD-properties
--********************************************************************************************
--select section-id/sub-section-id/property-group
select DISTINCT sd.section_id, s.description, sd.sub_section_id, su.description, sd.property_group, pg.description, sd.property, p.description
from section s
,    sub_section su
,    property_group pg
,    specdata sd
,    property p
where p.description in ('Bead width'
                     ) 
and  p.property = sd.property					 
AND  sd.section_id = s.section_id
and  sd.sub_section_id = su.sub_section_id
and  sd.property_group = pg.property_group
;

/*
700835	D-spec	0	(none)	701560	D-Spec (section)	704651	Bead width
700835	D-spec	0	(none)	701559	D-Spec (reinforcements)	704651	Bead width
700584	Properties	0	(none)	701560	D-Spec (section)	704651	Bead width
700584	Properties	0	(none)	701796	Bead properties	704651	Bead width
*/


--********************************************************************************************
-- VULCANIZED-TYRE-properties
--********************************************************************************************
--select section-id/sub-section-id/property-group
select DISTINCT sd.section_id, s.description, sd.sub_section_id, su.description, sd.property_group, pg.description, sd.property, p.description
from section s
,    sub_section su
,    property_group pg
,    specdata sd
,    property p
where p.description in ('PCI pressure'
                     ) 
and  p.property = sd.property					 
AND  sd.section_id = s.section_id
and  sd.sub_section_id = su.sub_section_id
and  sd.property_group = pg.property_group
;
/*
701058	Processing Gyongyoshalasz	702943	702916	PCI	709538	PCI pressure
700583	Processing					700542	702916	PCI	709538	PCI pressure
701058	Processing Gyongyoshalasz	702944	702916	PCI	709538	PCI pressure
701058	Processing Gyongyoshalasz	700542	702916	PCI	709538	PCI pressure
*/


--********************************************************************************************
-- <??>-properties
--********************************************************************************************
--select section-id/sub-section-id/property-group
select DISTINCT sd.section_id, s.description, sd.sub_section_id, su.description, sd.property_group, pg.description, sd.property, p.description
from section s
,    sub_section su
,    property_group pg
,    specdata sd
,    property p
where p.description LIKE ('%pressure%'
                     ) 
and  p.property = sd.property					 
AND  sd.section_id = s.section_id
and  sd.sub_section_id = su.sub_section_id
and  sd.property_group = pg.property_group
;
/*
701115	PAC				0	(none)					704036	PAC indoor testing			715328	Apollo pop-up pressure
700579	General information		0	(none)					701976	Test settings				712028	Burst pressure E-keur
701058	Processing Gyongyoshalasz	702585	TRHL: TBR ROLLER HEAD LINE GROUP	703982	Process parameters squeegee calender	713403	Extruder head pressure
700579	General information		0	(none)					703980	Slugs / inserts			714733	SLUG S40 TEST INFLATION PRESSURE
700584	Properties			701123	SM testing VR				702066	Indoor testing				703523	Apollo Burst pressure
701058	Processing Gyongyoshalasz	702944	P52PCI: PCR 52 inch press PCI		703958	Curing press parameters		714364	Open shaping pressure
700579	General information		701122	Client specific information		702357	Client 2				707810	Client specific pressure
701058	Processing Gyongyoshalasz	702450	PCURING: PCRCuring machine group	703958	Curing press parameters		709475	Squeeze pressure
701057	Processing Chennai		702524	TBM01					703934	General greentyre			713977	Bead lock low pressure
701058	Processing Gyongyoshalasz	702365	MMXMB2: MASTER MIXER BM440N		703976	Process parameters mixer		713578	Pressure ram build up time
700583	Processing			701269	SPBM1: 51 Farrel			702476	Instructions				708086	Bottom rollers (low pressure)
700583	Processing			701270	SPBM2: 53 VMI				702476	Instructions				708086	Bottom rollers (low pressure)
700583	Processing			702322	AF2CI					701570	Tooling					714277	SLUG S21 MAX LOAD / PRESSURE
700584	Properties			0	(none)					702066	Indoor testing				703523	Apollo Burst pressure
701115	PAC				0	(none)					704036	PAC indoor testing			713025	FMVSS Endurance low pressure 
701058	Processing Gyongyoshalasz	700542	General					701836	Curing settings (nitrogen)		711848	3rd shaping pressure
700995	Marketing characteristics	0	(none)					703699	General specifcations			705669	Max. pressure
700578	Controlplan			0	(none)					703296	Controlplan BBQ			711010	Max. pressure L, M, R actuator
701058	Processing Gyongyoshalasz	700542	General					701574	Curing settings (steam)		711848	3rd shaping pressure
700583	Processing			701266	C1519					702476	Instructions				708086	Bottom rollers (low pressure)
701058	Processing Gyongyoshalasz	700542	General					703916	Final Finish Testing Parameters	713715	Inflation pressure (Force variation)
701058	Processing Gyongyoshalasz	702446	PRHL: PCR dual roller head line group703982	Process parameters squeegee calender	713403	Extruder head pressure
701058	Processing Gyongyoshalasz	702943	P46PCI: PCR 46 inch press PCI		703958	Curing press parameters		709475	Squeeze pressure
701058	Processing Gyongyoshalasz	702451	PCUR52: PCR Curing 52 COLL machine group	703958	Curing press parameters	709475	Squeeze pressure
701058	Processing Gyongyoshalasz	702445	CSTC: Steel and calender group	703918	Creel and calender information	714447	Gap between pressure roll & calender roll no. 3
700583	Processing			702703	SPOE					701570	Tooling					714277	SLUG S21 MAX LOAD / PRESSURE
701058	Processing Gyongyoshalasz	0	(none)					703929	Process parameter Apexing		713412	Pressure Head (start)
700584	Properties			0	(none)					702066	Indoor testing				713039	CCC High Speed (pressure check)
701058	Processing Gyongyoshalasz	702583	TEXTT: TBR EXTRUDER FOR TREAD GROUP	703940	Process Extrusion			714703	Head pressure for cushion calendar
700579	General information		701122	Client specific information		702356	Client 1				707810	Client specific pressure
701057	Processing Chennai		702524	TBM01					703934	General greentyre			713446	Carcass inflation pressure Tread stitching
701115	PAC				0	(none)					704036	PAC indoor testing			713788	CCC Endurance (pressure check)
700578	Controlplan			702342	Gyongyoshalasz				703196	COP Tyre testing PCR (general)	703523	Apollo Burst pressure
701058	Processing Gyongyoshalasz	702603	TCUR67: TBR CURING 67 COLL MACHINE GROUP	702896	Curing				716758	Nitrogen pressure
700583	Processing			700987	HFNSP					701570	Tooling					714277	SLUG S21 MAX LOAD / PRESSURE
701058	Processing Gyongyoshalasz	702446	PRHL: PCR dual roller head line group703944	Process parameters innerliner calender713403	Extruder head pressure
701058	Processing Gyongyoshalasz	0	(none)					703982	Process parameters squeegee calender	713613	Pressure serration roller
701058	Processing Gyongyoshalasz	0	(none)					703989	Pre-Calender				713645	Pressure accumulator (Pre calender)
701058	Processing Gyongyoshalasz	702944	P52PCI: PCR 52 inch press PCI		703958	Curing press parameters		709475	Squeeze pressure
700579	General information		701122	Client specific information		702358	Client 3				707810	Client specific pressure
700583	Processing			702703	SPOE					701570	Tooling					714732	SLUG S39 MAX LOAD / PRESSURE
701115	PAC				0	(none)					704036	PAC indoor testing			713777	SNI Endurance low pressure (failures)
700579	General information		0	(none)					701569	Size					708808	LLV pressure
700583	Processing			700986	KNRC3					701570	Tooling					714277	SLUG S21 MAX LOAD / PRESSURE
700583	Processing			700984	AFRSV					701570	Tooling					714277	SLUG S21 MAX LOAD / PRESSURE
701058	Processing Gyongyoshalasz	702946	TCURNI: TBR CURING NITROGEN MACHINE GROUP	702896	Curing				716758	Nitrogen pressure
701058	Processing Gyongyoshalasz	702945	PSMART: PCR SMART Curing		703958	Curing press parameters		714364	Open shaping pressure
701115	PAC				0	(none)					704036	PAC indoor testing			713036	GSO High Speed Performance (pressure check)
700583	Processing			702122	NSP45					701570	Tooling					714733	SLUG S40 TEST INFLATION PRESSURE
701058	Processing Gyongyoshalasz	700542	General					701574	Curing settings (steam)		709471	2nd shaping pressure
701058	Processing Gyongyoshalasz	702445	CSTC: Steel and calender group	703992	Calender				713662	Pressure blister knife (pneumatic)
700584	Properties			0	(none)					702066	Indoor testing				708087	Burst pressure AT
701058	Processing Gyongyoshalasz	702585	TRHL: TBR ROLLER HEAD LINE GROUP	703982	Process parameters squeegee calender	713613	Pressure serration roller
700584	Properties			0	(none)					702066	Indoor testing				713027	FMVSS Endurance low pressure (pressure check)
700579	General information		0	(none)					701568	Sidewall designation			711512	Max. pressure (bar)
701058	Processing Gyongyoshalasz	702602	TCURING: TBR CURING MACHINE GROUP	702896	Curing					713312	Shaping pressure
700584	Properties			0	(none)					702066	Indoor testing				713789	CCC Endurance low pressure
700579	General information		0	(none)					701562	ETRTO properties			705192	ETRTO infl pressure
701058	Processing Gyongyoshalasz	0	(none)					703992	Calender				713659	Pressure roll 4 (hydraulic)
700583	Processing			700542	General					0	default property group			707728	Third shaping pressure
701058	Processing Gyongyoshalasz	700542	General					703916	Final Finish Testing Parameters	713724	Pressure pre-Inflation
700579	General information		0	(none)					701569	Size					708810	HLV pressure
701058	Processing Gyongyoshalasz	702585	TRHL: TBR ROLLER HEAD LINE GROUP	703982	Process parameters squeegee calender	713615	Pressure sponge roller
701058	Processing Gyongyoshalasz	700542	General					702896	Curing					713312	Shaping pressure
700583	Processing			701269	SPBM1: 51 Farrel			702476	Instructions				708143	Folding stitchers (pressure)
700583	Processing			701269	SPBM1: 51 Farrel			702476	Instructions				708085	Bottom rollers (high pressure)
701058	Processing Gyongyoshalasz	0	(none)					703982	Process parameters squeegee calender	713614	Pressure doubling sponge roller
701058	Processing Gyongyoshalasz	702443	MMXFB2: BM305N - Final Mixer		703976	Process parameters mixer		713578	Pressure ram build up time
700583	Processing			109	SPBM3: 55 Mesnac			702476	Instructions				708190	Stitcher arm (medium pressure)
701115	PAC				0	(none)					704036	PAC indoor testing			713790	CCC Endurance low pressure (failures)
701058	Processing Gyongyoshalasz	702452	PAPX: PCR Bead apexing machine group	703927	Bead Apex information			713388	Application Roll pressure
701058	Processing Gyongyoshalasz	702445	CSTC: Steel and calender group	701570	Tooling					714441	Pressure roll identification no.
700579	General information		0	(none)					701568	Sidewall designation			711511	Max. pressure (psi)
700579	General information		0	(none)					701976	Test settings				708200	Tyre pressure test
700579	General information		0	(none)					703980	Slugs / inserts			714732	SLUG S39 MAX LOAD / PRESSURE
700583	Processing			701002	KRPRS					701570	Tooling					714733	SLUG S40 TEST INFLATION PRESSURE
700583	Processing			702082	KN2D					701570	Tooling					714733	SLUG S40 TEST INFLATION PRESSURE
700583	Processing			700982	AF2D					701570	Tooling					714277	SLUG S21 MAX LOAD / PRESSURE
701057	Processing Chennai		700542	General					702896	Curing					713312	Shaping pressure
700583	Processing			702122	NSP45					701570	Tooling					714732	SLUG S39 MAX LOAD / PRESSURE
701058	Processing Gyongyoshalasz	0	(none)					703929	Process parameter Apexing		713403	Extruder head pressure
701058	Processing Gyongyoshalasz	0	(none)					703989	Pre-Calender				713647	Pressure push roll
700584	Properties			0	(none)					702066	Indoor testing				713036	GSO High Speed Performance (pressure check)
701058	Processing Gyongyoshalasz	702585	TRHL: TBR ROLLER HEAD LINE GROUP	703982	Process parameters squeegee calender	713618	Pressure prickling roll
701057	Processing Chennai		702524	TBM01					703932	Shaping parameters			713445	Carcass inflation pressure Pre shaping
700584	Properties			0	(none)					702066	Indoor testing				713024	FMVSS Endurance (pressure check)
701058	Processing Gyongyoshalasz	0	(none)					703929	Process parameter Apexing		713415	Pressure Festooner
701057	Processing Chennai		702524	TBM01					703934	General greentyre			713976	Bead lock high pressure
700578	Controlplan			0	(none)					704480	COP Tyre testing PCR (Indoor)		703523	Apollo Burst pressure
700579	General information		0	(none)					703980	Slugs / inserts			713597	Max. pressure / load
700584	Properties			0	(none)					702066	Indoor testing				713790	CCC Endurance low pressure (failures)
701058	Processing Gyongyoshalasz	702442	MMXMB1: MASTER MIXER BM440N		703976	Process parameters mixer		713578	Pressure ram build up time
701058	Processing Gyongyoshalasz	0	(none)					703928	Proces Parameters bead winding	713403	Extruder head pressure
700583	Processing			701002	KRPRS					701570	Tooling					714732	SLUG S39 MAX LOAD / PRESSURE
700584	Properties			0	(none)					702066	Indoor testing				713028	Apollo Burst pressures
700583	Processing			701270	SPBM2: 53 VMI				702476	Instructions				708189	Stitcher arm (low pressure)
700583	Processing			700542	General					702476	Instructions				709471	2nd shaping pressure
701058	Processing Gyongyoshalasz	700542	General					703916	Final Finish Testing Parameters	713716	Inflation pressure (Geometry)
701058	Processing Gyongyoshalasz	0	(none)					703929	Process parameter Apexing		713413	Pressure Head (stop)
700583	Processing			702122	NSP45					701570	Tooling					714277	SLUG S21 MAX LOAD / PRESSURE
701058	Processing Gyongyoshalasz	700542	General					701836	Curing settings (nitrogen)		709471	2nd shaping pressure
700583	Processing			700984	AFRSV					701570	Tooling					714733	SLUG S40 TEST INFLATION PRESSURE
701058	Processing Gyongyoshalasz	0	(none)					703989	Pre-Calender				713642	Pressure inlet steam (heating drum)
701115	PAC				0	(none)					704036	PAC indoor testing			713039	CCC High Speed (pressure check)
700583	Processing			109	SPBM3: 55 Mesnac			702476	Instructions				708086	Bottom rollers (low pressure)
700579	General information		700542	General					701568	Sidewall designation			705669	Max. pressure
701058	Processing Gyongyoshalasz	700542	General					701574	Curing settings (steam)		709476	1st shaping pressure
700577	Chemical and physical properties	0(none)					700783	Properties vulcanising agents		703523	Apollo Burst pressure
701058	Processing Gyongyoshalasz	702602	TCURING: TBR CURING MACHINE GROUP	702896	Curing					716759	Steam pressure
700578	Controlplan			0	(none)					703196	COP Tyre testing PCR (general)	703523	Apollo Burst pressure
701057	Processing Chennai		702524	TBM01					703934	General greentyre			713975	Machine air line pressure
700583	Processing			700542	General					702476	Instructions				711848	3rd shaping pressure
701058	Processing Gyongyoshalasz	702943	P46PCI: PCR 46 inch press PCI		702916	PCI					709538	PCI pressure
700579	General information		0	(none)					703316	Dimensions (PR information)		711088	Inflation pressure (nom.)
701057	Processing Chennai		702524	TBM01					703934	General greentyre			713448	Carcass inflation pressure Sidewall stitching
701115	PAC				0	(none)					704036	PAC indoor testing			713786	GSO Endurance (pressure check)
700583	Processing			700987	HFNSP					701570	Tooling					714733	SLUG S40 TEST INFLATION PRESSURE
700583	Processing			701042	KNRC4					701570	Tooling					714732	SLUG S39 MAX LOAD / PRESSURE
701057	Processing Chennai		702524	TBM01					703934	General greentyre			713447	Carcass inflation pressure Roll over
701058	Processing Gyongyoshalasz	702367	MMXMB4: Tandem mixer IM320 (Upper mixer)	703976	Process parameters mixer	713578	Pressure ram build up time
700583	Processing			700986	KNRC3					701570	Tooling					714733	SLUG S40 TEST INFLATION PRESSURE
701058	Processing Gyongyoshalasz	702586	TSMC: TBR SMALL COMPONENT EXTRUDER GROUP	703940	Process Extrusion		713403	Extruder head pressure
701058	Processing Gyongyoshalasz	702591	TAPX: TBR BEAD APEXING MACHINE GROUP	703927	Bead Apex information			713388	Application Roll pressure
701058	Processing Gyongyoshalasz	0	(none)					703929	Process parameter Apexing		713414	Pressure water
701058	Processing Gyongyoshalasz	0	(none)					703992	Calender				713660	Pressure cross axis (hydraulic)
701058	Processing Gyongyoshalasz	702946	TCURNI: TBR CURING NITROGEN MACHINE GROUP	702896	Curing				713312	Shaping pressure
701115	PAC				0	(none)					704036	PAC indoor testing			713024	FMVSS Endurance (pressure check)
701058	Processing Gyongyoshal	asz	702385	MMXFB1: BM305N - Final Mixer		703976	Process parameters mixer		713578	Pressure ram build up time
701175	Release plan			0	(none)					704468	Extended indoor testing		703523	Apollo Burst pressure
700584	Properties			0	(none)					702066	Indoor testing				713777	SNI Endurance low pressure (failures)
701058	Processing Gyongyoshalasz	702943	P46PCI: PCR 46 inch press PCI		703958	Curing press parameters		714364	Open shaping pressure
701058	Processing Gyongyoshalasz	0	(none)					703929	Process parameter Apexing		713390	Pressure Roll; Pressure
700583	Processing			702082	KN2D					701570	Tooling					714732	SLUG S39 MAX LOAD / PRESSURE
700579	General information		0	(none)					701568	Sidewall designation			705669	Max. pressure
700583	Processing			701270	SPBM2: 53 VMI				702476	Instructions				708085	Bottom rollers (high pressure)
700583	Processing			700987	HFNSP					701570	Tooling					714732	SLUG S39 MAX LOAD / PRESSURE
701115	PAC				0	(none)					704036	PAC indoor testing			713789	CCC Endurance low pressure
700583	Processing			109	SPBM3: 55 Mesnac			702476	Instructions				708085	Bottom rollers (high pressure)
700583	Processing			700984	AFRSV					701570	Tooling					714732	SLUG S39 MAX LOAD / PRESSURE
700995	Marketing characteristics	0	(none)					703699	General specifcations			711513	Min. pressure
701058	Processing Gyongyoshalasz	0	(none)					703992	Calender				713661	Pressure pre loading
700583	Processing			700982	AF2D					701570	Tooling					714732	SLUG S39 MAX LOAD / PRESSURE
701115	PAC				0	(none)					704036	PAC indoor testing			713027	FMVSS Endurance low pressure (pressure check)
700583	Processing			702703	SPOE					701570	Tooling					714733	SLUG S40 TEST INFLATION PRESSURE
701058	Processing Gyongyoshalasz	0	(none)					703992	Calender				713657	Pressure roll 1 (hydraulic)
701058	Processing Gyongyoshalasz	0	(none)					703992	Calender				713658	Pressure roll 2 (hydraulic)
700583	Processing			701002	KRPRS					701570	Tooling					714277	SLUG S21 MAX LOAD / PRESSURE
700583	Processing			700542	General					701836	Curing settings (nitrogen)		707928	Pressure Nitrogen
701058	Processing Gyongyoshalasz	700542	General					701574	Curing settings (steam)		713540	Bladder pressure (steam)
701058	Processing Gyongyoshalasz	702602	TCURING: TBR CURING MACHINE GROUP	702896	Curing					716758	Nitrogen pressure
700584	Properties			0	(none)					701561	D-Spec (tyre measurements)		711088	Inflation pressure (nom.)
700579	General information		701122	Client specific information		702360	Client 5				707810	Client specific pressure
700583	Processing			109	SPBM3: 55 Mesnac			702476	Instructions				708189	Stitcher arm (low pressure)
701115	PAC				0	(none)					704036	PAC indoor testing			713791	CCC Endurance low pressure (pressure check)
700584	Properties			0	(none)					704036	PAC indoor testing			703523	Apollo Burst pressure
700583	Processing			701270	SPBM2: 53 VMI				702476	Instructions				708190	Stitcher arm (medium pressure)
700584	Properties			0	(none)					702066	Indoor testing				713791	CCC Endurance low pressure (pressure check)
701058	Processing Gyongyoshalasz	700542	General					703916	Final Finish Testing Parameters	713717	Inflation pressure (Unbalance)
700583	Processing			702322	AF2CI					701570	Tooling					714733	SLUG S40 TEST INFLATION PRESSURE
701058	Processing Gyongyoshalasz	700542	General					701836	Curing settings (nitrogen)		713540	Bladder pressure (steam)
700583	Processing			701268	ORBIT: Orbitread			702476	Instructions				708169	Pressure inside
701058	Processing Gyongyoshalasz	702445	CSTC: Steel and calender group	703918	Creel and calender information	714444	Pressure roll EPDM
701058	Processing Gyongyoshalasz	0	(none)					703923	Process parameters Pork chop extruder713370	Pressure inlet water
701115	PAC				0	(none)					704036	PAC indoor testing			713026	FMVSS Endurance low pressure (failures)
701058	Processing Gyongyoshalasz	702450	PCURING: PCRCuring machine group	703958	Curing press parameters		714364	Open shaping pressure
700583	Processing			700982	AF2D					701570	Tooling					714733	SLUG S40 TEST INFLATION PRESSURE
701058	Processing Gyongyoshalasz	0	(none)					703982	Process parameters squeegee calender	713618	Pressure prickling roll
701057	Processing Chennai		702524	TBM01					703932	Shaping parameters			713444	Carcass inflation pressure Shaping
700584	Properties			0	(none)					702066	Indoor testing				713026	FMVSS Endurance low pressure (failures)
701058	Processing Gyongyoshalasz	702451	PCUR52: PCR Curing 52 COLL machine group	703958	Curing press parameters	714364	Open shaping pressure
701057	Processing Chennai		700542	General					703916	Final Finish Testing Parameters	713717	Inflation pressure (Unbalance)
701057	Processing Chennai		700542	General					703916	Final Finish Testing Parameters	713715	Inflation pressure (Force variation)
701058	Processing Gyongyoshalasz	702585	TRHL: TBR ROLLER HEAD LINE GROUP	703982	Process parameters squeegee calender	713614	Pressure doubling sponge roller
700584	Properties			0	(none)					702066	Indoor testing				713782	FMVSS High Speed (pressure check)
700578	Controlplan			700542	General					703196	COP Tyre testing PCR (general)	703523	Apollo Burst pressure
700584	Properties			0	(none)					702066	Indoor testing				713775	SNI Endurance low pressure
701115	PAC				0	(none)					704036	PAC indoor testing			713782	FMVSS High Speed (pressure check)
700583	Processing			700542	General					702476	Instructions				709476	1st shaping pressure
700583	Processing			701042	KNRC4					701570	Tooling					714277	SLUG S21 MAX LOAD / PRESSURE
700584	Properties			0	(none)					701976	Test settings				708200	Tyre pressure test
701058	Processing Gyongyoshalasz	702944	P52PCI: PCR 52 inch press PCI		702916	PCI					709538	PCI pressure
700579	General information		701122	Client specific information		702359	Client 4				707810	Client specific pressure
701058	Processing Gyongyoshalasz	702444	MMXFB3: BM305N - Final Mixer		703976	Process parameters mixer		713578	Pressure ram build up time
701058	Processing Gyongyoshalasz	702452	PAPX: PCR Bead apexing machine group	703927	Bead Apex information			713390	Pressure Roll; Pressure
701058	Processing Gyongyoshalasz	0	(none)					703982	Process parameters squeegee calender	713615	Pressure sponge roller
700579	General information		0	(none)					701569	Size					705669	Max. pressure
700584	Properties			0	(none)					702066	Indoor testing				713788	CCC Endurance (pressure check)
700583	Processing			700986	KNRC3					701570	Tooling					714732	SLUG S39 MAX LOAD / PRESSURE
700583	Processing			702322	AF2CI					701570	Tooling					714732	SLUG S39 MAX LOAD / PRESSURE
701058	Processing Gyongyoshalasz	700542	General					701836	Curing settings (nitrogen)		709476	1st shaping pressure
700584	Properties			0	(none)					702066	Indoor testing				713032	BIS Load/Speed performance test (pressure check)
700583	Processing			701266	C1519					702476	Instructions				708085	Bottom rollers (high pressure)
701058	Processing Gyongyoshalasz	702603	TCUR67: TBR CURING 67 COLL MACHINE GROUP	702896	Curing				713312	Shaping pressure
700584	Properties			0	(none)					701562	ETRTO properties			705192	ETRTO infl pressure
700583	Processing			701873	SPMO1					704098	Studding Recipe			713909	Pressure
701058	Processing Gyongyoshalasz	702945	PSMART: PCR SMART Curing		703958	Curing press parameters		709475	Squeeze pressure
700579	General information		0	(none)					703980	Slugs / inserts			714277	SLUG S21 MAX LOAD / PRESSURE
700584	Properties			0	(none)					702066	Indoor testing				714536	Burst pressure TBR
701058	Processing Gyongyoshalasz	702946	TCURNI: TBR CURING NITROGEN MACHINE GROUP	702896	Curing				716759	Steam pressure
701058	Processing Gyongyoshalasz	702603	TCUR67: TBR CURING 67 COLL MACHINE GROUP	702896	Curing				716759	Steam pressure
701115	PAC				0	(none)					704036	PAC indoor testing			703523	Apollo Burst pressure
701058	Processing Gyongyoshalasz	700542	General					702916	PCI					709538	PCI pressure
701058	Processing Gyongyoshalasz	702591	TAPX: TBR BEAD APEXING MACHINE GROUP	703927	Bead Apex information			713390	Pressure Roll; Pressure
700584	Properties			0	(none)					702066	Indoor testing				713025	FMVSS Endurance low pressure 
700583	Processing			700542	General					702916	PCI					709538	PCI pressure
701058	Processing Gyongyoshalasz	700542	General					701836	Curing settings (nitrogen)		713541	Bladder pressure (Nitrogen)
700584	Properties			0	(none)					702066	Indoor testing				713786	GSO Endurance (pressure check)
700583	Processing			701042	KNRC4					701570	Tooling					714733	SLUG S40 TEST INFLATION PRESSURE
701058	Processing Gyongyoshalasz	0	(none)					703976	Process parameters mixer		713578	Pressure ram build up time
701115	PAC				0	(none)					704036	PAC indoor testing			713775	SNI Endurance low pressure
700583	Processing			702082	KN2D					701570	Tooling					714277	SLUG S21 MAX LOAD / PRESSURE
700579	General information		0	(none)					701568	Sidewall designation			711513	Min. pressure
701058	Processing Gyongyoshalasz	0	(none)					703929	Process parameter Apexing		713428	Pressure Applicator roll


*/


--UNilab-METHOD-cells:
--
DESCR utscmecell 

select cell, dsp_title from utscmecell where cell='w_max' ;
select pg, pa, me, cell,count(*) from utscmecell where cell='w_max' group by pg,pa,me,cell;


select cell, dsp_title from utscmecell where cell='circumference' ;

w_max
circumference
layout_spiral
mold_based_width
no_of_body_ply
overall_mold_diameter
section_width_mold
measured_rim
cp_belt_material
cp_belt_angle
cp_type_spiral
cp_body_ply_type


--BEAD-COMPONENT
select SH.frame_id, SUBSTR(SH.PART_NO,1,3), SH.status, count(*) from status s, specification_header sh where sh.status = s.status and s.status_type='CURRENT'  
AND (   sh.part_no like '_EB%' 
    or  sh.part_no like '_GB%' 
    or  sh.part_no like 'EB%' 
    or  sh.part_no like 'GB%' 
    )
GROUP BY sh.frame_id, SUBSTR(SH.PART_NO,1,3), sh.status ORDER BY sh.frame_id, SUBSTR(SH.PART_NO,1,3), sh.status;

/*
A_Bead v1	GB_	125	37
A_Bead v1	GB_	127	12
A_Bead v1	GB_	128	152
A_Bead v1	XGB	125	61
A_RM_Aux	EB3	4	1
A_RM_Aux	EB4	4	1
A_RM_Aux	EB8	4	1
A_RM_Aux	XEB	4	1
A_RM_Aux_Liners	EB2	4	1
B_AT_GT_source	XEB	125	1
E_Bead	EB_	126	25
E_Bead	EB_	127	3
E_Bead	EB_	128	141
E_Bead	XEB	125	2
E_Bead	XEB	154	3
E_Bead_AT	EB_	125	1
E_Bead_AT	EB_	127	5
E_Bead_AT	EB_	128	52
E_Bead_AT	XEB	125	15
E_Bead_Bare_AT	EB_	125	1
E_Bead_Bare_AT	EB_	127	1
E_Bead_Bare_AT	EB_	128	56
E_Bead_Bare_AT	XEB	125	9
Trial E_Bead	XEB	125	1
Trial E_Bead	XEB	154	2
*/

select SH.frame_id, count(*) 
from status s, specification_header sh where sh.status = s.status and s.status_type='CURRENT'  
AND UPPER(frame_id) like '%BEAD%' 
GROUP BY sh.frame_id ORDER BY sh.frame_id
;

/*
AV_Man_Beadwire		10
A_Bead v1			270
A_Global_Beadwire	3
A_Man_RM_bead wire	13
A_RM_Rectbead v1	1
A_RM_bead wire v1	12
E_Bead				175
E_Bead_AT			73
E_Bead_Bare_AT		67
L_Bead				3
Trial E_Bead		8
Trial_Beadwire		16
*/

select SH.frame_id, count(*) 
from status s, specification_header sh where sh.status = s.status and s.status_type='CURRENT'  
AND UPPER(frame_id) like '%BEAD%' 
AND (   sh.part_no like '_EB%' 
    or  sh.part_no like '_GB%' 
    or  sh.part_no like 'EB%' 
    or  sh.part_no like 'GB%' 
    )
GROUP BY sh.frame_id ORDER BY sh.frame_id
;
/*
A_Bead v1		262
E_Bead			174
E_Bead_AT		73
E_Bead_Bare_AT	67
Trial E_Bead	3
*/



--property PCI-PRESSURE SEEMS TO HAVE A RELATION WITH A VULCANIZED-TYRE:
select SH.frame_id, SUBSTR(SH.PART_NO,1,3), SH.status, count(*) 
from status s, specification_header sh 
where sh.status = s.status and s.status_type='CURRENT'  
AND (   sh.part_no like '_EV%' 
    or  sh.part_no like '_GV%' 
    or  sh.part_no like 'EV%' 
    or  sh.part_no like 'GV%' 
    )
GROUP BY sh.frame_id, SUBSTR(SH.PART_NO,1,3), sh.status ORDER BY sh.frame_id, SUBSTR(SH.PART_NO,1,3), sh.status;

/*
A_PCR_VULC v1	GV_	125	24
A_PCR_VULC v1	GV_	126	8
A_PCR_VULC v1	GV_	127	103
A_PCR_VULC v1	GV_	128	558
A_PCR_VULC v1	XGV	124	2
A_PCR_VULC v1	XGV	125	2419
A_PCR_VULC v1	XGV	127	30
A_TBR_VULC		GV_	127	32
A_TBR_VULC		XGV	124	1
A_TBR_VULC		XGV	125	115
A_TBR_VULC		XGV	315	1
E_PCR_VULC		EV_	125	3
E_PCR_VULC		EV_	126	36
E_PCR_VULC		EV_	127	263
E_PCR_VULC		EV_	128	240
E_PCR_VULC		EV_	154	7
E_PCR_VULC		TEV	154	1
E_PCR_VULC		XEV	125	20
E_PCR_VULC		XEV	154	107
E_SM			EV_	126	2
E_SM			EV_	127	4
E_SM			EV_	128	19
*/

select SH.frame_id, count(*) 
from status s, specification_header sh where sh.status = s.status and s.status_type='CURRENT'  
AND UPPER(frame_id) like '%VULC%' 
GROUP BY sh.frame_id ORDER BY sh.frame_id
;
/*
AV_GlobalVulcAgent	2
AV_Man_VulcAgent	25
A_GlobalVulcAgent	15
A_Man_RM_Vulc v1	2
A_PCR_VULC v1	3148
A_RM_Vulcagents v1	13
A_TBR_VULC	157
E_PCR_VULC	682
T_PCR_VULC	1
Trial Vulc. Agent	69
*/

select SH.frame_id, count(*) 
from status s, specification_header sh where sh.status = s.status and s.status_type='CURRENT'  
AND UPPER(frame_id) like '%VULC%' 
AND (   sh.part_no like '_EV%' 
    or  sh.part_no like '_GV%' 
    or  sh.part_no like 'EV%' 
    or  sh.part_no like 'GV%' 
    )
GROUP BY sh.frame_id ORDER BY sh.frame_id
;
/*
A_PCR_VULC v1	3144
A_TBR_VULC	149
E_PCR_VULC	677
*/




--ONDERZOEK PG/PA/ME voor w_max:
/*
Indoor testing	TT525AA-TT719AA	TT526A3	w_max	1052
Indoor testing	TT525AA-TT729CA	TT526A1	w_max	539
Indoor testing	TT750XB	TT540A	w_max	10
Indoor testing	TT750AB	TT540A	w_max	791
Indoor testing	TT525BA	TT525B	w_max	239
Indoor testing	TT525BA-TT719AA	TT526A3	w_max	16
Simulations vehicleF	ST520AS	ST100	w_max	536
T-T: PCT Indoor adv.	TT660ZZ	TT660Z	w_max	1129
...
etc
*/


--ONDERZOEK naar methode-cellen:

select *
from utscme scme 
WHERE  scme.parameter LIKE '%TT520AX%' 
and    scme.method    like '%TT520%' 
;

/*
w_max
circumference
layout_spiral
mold_based_width
no_of_body_ply
overall_mold_diameter
section_width_mold
measured_rim
cp_belt_material
cp_belt_angle
cp_type_spiral
cp_body_ply_type
*/


select cell, dsp_title, count(*) 
from utscmecell scme 
WHERE  scme.pa LIKE '%TT520AX%' 
and    scme.me like '%TT520%' 
group by pa, me,cell, dsp_title
order by pa, me,cell, dsp_title
;
/*
cell            dsp_title               			count(*)
--------------- ----------------------- 			----------
C_NSD_M_1		Tread depth near TWI 1				73
C_NSD_M_2		Tread depth near TWI 2				73
C_NSD_TWI_1		Tread depth on TWI 1				73
C_NSD_TWI_2		Tread depth on TWI 2				73
Cell24			MEASURE TWI NEAR THE CENTERGROOVE	416
Circumference	Circumference						22950                --ok
D				D									1862
HH1				HH1									20567
HH2				HH2									20567
HH3				HH3									20567
HH_mean			HH_mean								20567
Result			Result								22950
TWI_1			TWI 1								4512
TWI_1			TWI height 1						343
TWI_2			TWI 2								4512
TWI_2			TWI height 2						343
TWI_3			TWI 3								4439
TWI_4			TWI 4								4439
TWI_5			TWI 5								4439
TWI_6			TWI 6								4439
TWI_HIGH		TWI HIGH							4855
TWI_LOW			TWI LOW								4439
TWI_Low			TWI LOW								416
Tyrediameter	Tyre diameter						12173              --ok
avTestMethod	AV-method							22950
avTestMethodDesc									22950
avTyreWidth		Width								74
nextMt			nextMt								22950
nextMtDesc											22950
p_infl			p_inflation							22937              --ok
p_infl_PSI		p_inflation							22937              --ok
w_1				w_1									21014
w_2				w_2									21014
w_3				w_3									21014
w_4				w_4									21014
w_5				w_5									21014
w_6				w_6									21014
w_max			w_max								19748              --ok
w_mean			w_mean								9581              
*/



--select pg, pa, me, cell,count(*) from utscmecell where cell='w_max' group by pg,pa,me,cell;








unilab SAMPLES:
select sc.ss, s.name, s.description, count(*) from utsc sc, utss s where sc.ss = s.ss group by sc.ss , s.description order by ss;
select sc.ss, s.name, s.description, count(*) from utsc sc, utss s where sc.ss = s.ss group by sc.ss , S.NAME, s.description order by ss;

If I look in current production-environment I see the following number of sample-status:

ss  name                    description             count(*)
--- ----------------------- ----------------------- ----------
@C	Cancelled										99658
@P	Planned											5620
AV	Available				Available				7419
CM	Completed				Completed				3053786
IR	Irrelevant				Irrelevant				247877
OR	Ordered					Ordered					59
OS	Out of spec				Out of spec				30
OW	Out of warning			Out of warning			4
RJ	Rejected				Rejected				16
SC	Out of Spec Conf.		Out of Spec Conf.		147921
SU	Submit					Submit					244
WA	Wait					Wait					1
WC	Out of Warning Conf.	Out of Warning Conf.	264547
WH	Warehouse				Warehouse				67

select count(sc.sc),  count(distinct sc.sc) from utsc sc ;
3828506		3828506

An additional-question about unilab-samples/methods. 
We now select all the samples/methods related to tyres (A_PRC/A_TBR/A_OHT), independent of the status of it.
I think we can exclude a lot of samples/methodes with status = cancelled/rejected etc.
In what statusses are you interested in? Only the final CM=Completed status (or may be out-of-spec/warning-statusses)
, or also samples/methods being currently tested (submit/planned/available/ordered/warehouse/wait?

--COMPLETED-STATUSES = CM, OS, OW, SC, WC


select scme.ss, s.name, s.description, count(*) 
from utscme scme, utss s 
where scme.ss = s.ss 
and    scme.pa LIKE '%TT520AX%' 
and    scme.me like '%TT520%' 
group by scme.ss , S.NAME, s.description 
order by scme.ss
;
/*
@C	Cancelled		4621
@P	Planned		216
AV	Available	Available	11
CM	Completed	Completed	22292
WA	Wait	Wait	59
*/


--COMBINATIE SAMPLE-SAMPLETYPE with SCME (to see if there is a relation with the INTERSPEC-FRAME-ID...)

select sc.st , count(*)
from utsc sc
where sc.sc in 
(select scme.sc
 from utscme scme 
 WHERE  scme.pa LIKE '%TT520AX%' 
 and    scme.me like '%TT520%' 
 )
group by sc.st
order by sc.st
;
/*
GF_2255517QPRXY	1
GF_2355517AXPXV	1
GF_2355517QPRXY	1
GF_2454518QPRXY	1
PF_H165/60R14SP5	3
T-T: PCT Indoor adv.	825
T-T: SM indoor std 1	7
T-TG: PCT Endurance	12
T-TG: PCT High speed	1628
T-TG: PCT Indoor adv	17
T-TG: PCT Runflat	1
T-TG: PCT indoor s1	706
T-TG: PCT indoor s2	114
T: PCT Endurance	128
T: PCT High speed	9037
T: PCT indoor std	15
T: PCT indoor std 1	520
T: PCT indoor std 2	61
Z: PCT High speed	3
testkoppeling	1
*/

select sc.sc, sc.st 
from utsc sc
where sc.sc in 
(select scme.sc
 from utscme scme 
 WHERE  scme.pa LIKE '%TT520AX%' 
 and    scme.me like '%TT520%' 
 )
order by sc.st, sc.sc
;




INTERSPEC-FRAME-IDS
select frame_id, count(distinct part_no) 
from specification_header 
where (   frame_id like '%PCR%'
      OR frame_id like '%TBR%'
	  or frame_id like '%OHT%' )
group by frame_id ORDER BY frame_id;




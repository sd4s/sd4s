--REPORT:  INT00055R-Specifications overview
------------------------------------------------
--[Product & Process development ]
--    - [Specifications ]
--      - [ Specifications Overview ]
--

DROP VIEW sc_lims_dal.av_spec_overview_plant_frame_id;
--
CREATE OR REPLACE VIEW sc_lims_dal.av_spec_overview_plant_frame_id
(frame_id
,frame_revision
,frame_description
--,part_number
,template_part_no
,template_description
,template_plant
,part_plant
,part_plant_description
)
as
select DISTINCT sh.frame_id
,      sh.frame_rev         as frame_revision
,      fh.description       as frame_description
--,      sh.part_no           as part_number
,      template.part_no     as template_part_no
,      template.description as template_description
,      tpp.plant            as template_plant
,      p.plant              as part_plant 
,      p.description        as part_plant_description
--,      kw.kw_id
--,      kw.kw_value
from frame_header                      fh
join specification_header              sh on (sh.frame_id = fh.frame_no and sh.frame_rev  = fh.revision)
join status                             s on (s.status    = sh.status   and s.status_type = 'CURRENT')
join part_plant                        pp on (pp.part_no  = sh.part_no)
join plant                              p on (p.plant     = pp.plant)
left outer join specification_kw       kw on (kw.KW_value = sh.frame_id and kw.kw_id = 700686 )
left outer join part             template on (template.part_no  = kw.part_no)
left outer join part_plant            tpp on (tpp.part_no       = template.part_no and tpp.plant = p.plant)
where fh.status = 2
--and   sh.frame_id = 'A_Man_RM_Aux'
--and   p.plant     in ( 'GYO', 'ENS' )
AND   sh.revision = (select max(sh3.revision) from specification_header sh3 where sh3.part_no = sh.part_no)
;

grant all on  sc_lims_dal.av_spec_overview_plant_frame_id   to usr_rna_readonly1;

/*
A_Man_RM_Aux	4				GYO	Gyöngyöshalász
A_Man_RM_Aux	4				DEV	Development Plant
A_Man_RM_Aux	4				LIM	Limda
A_Man_RM_Aux	4				CHE	Chennai
A_Man_RM_Aux	4				ENS	Enschede Plant
*/
/*
A_PCR	91	Mask_PCR_INT00064	Layout specification		APR	Andhra Pradesh
A_PCR	91	Mask_PCR_INT00064	Layout specification		CHE	Chennai
A_PCR	91	Mask_PCR_INT00064	Layout specification		ENS	Enschede Plant
A_PCR	91	Mask_PCR_INT00064	Layout specification	GYO	GYO	Gyöngyöshalász
A_PCR	91	Mask_PCR_INT00064	Layout specification		LIM	Limda
A_PCR	91	Mask_PCR_INT00065	D-Spec and General		APR	Andhra Pradesh
A_PCR	91	Mask_PCR_INT00065	D-Spec and General		CHE	Chennai
A_PCR	91	Mask_PCR_INT00065	D-Spec and General		ENS	Enschede Plant
A_PCR	91	Mask_PCR_INT00065	D-Spec and General	GYO	GYO	Gyöngyöshalász
A_PCR	91	Mask_PCR_INT00065	D-Spec and General		LIM	Limda
A_PCR	91	Mask_PCR_INT00066	Cavity parameters		APR	Andhra Pradesh
A_PCR	91	Mask_PCR_INT00066	Cavity parameters		CHE	Chennai
A_PCR	91	Mask_PCR_INT00066	Cavity parameters		ENS	Enschede Plant
A_PCR	91	Mask_PCR_INT00066	Cavity parameters	GYO	GYO	Gyöngyöshalász
A_PCR	91	Mask_PCR_INT00066	Cavity parameters		LIM	Limda
A_PCR	91	Mask_PCR_INT00067	PAC						APR	Andhra Pradesh
A_PCR	91	Mask_PCR_INT00067	PAC						CHE	Chennai
A_PCR	91	Mask_PCR_INT00067	PAC						ENS	Enschede Plant
A_PCR	91	Mask_PCR_INT00067	PAC					GYO	GYO	Gyöngyöshalász
A_PCR	91	Mask_PCR_INT00067	PAC						LIM	Limda
A_PCR	91	Mask_Section		Section D-spec			APR	Andhra Pradesh
A_PCR	91	Mask_Section		Section D-spec			CHE	Chennai
A_PCR	91	Mask_Section		Section D-spec		ENS	ENS	Enschede Plant
A_PCR	91	Mask_Section		Section D-spec			GYO	Gyöngyöshalász
A_PCR	91	Mask_Section		Section D-spec			LIM	Limda
A_PCR	91	ZG_PCRO1_PCT		Template for PCR overview		APR	Andhra Pradesh
A_PCR	91	ZG_PCRO1_PCT		Template for PCR overview		CHE	Chennai
A_PCR	91	ZG_PCRO1_PCT		Template for PCR overview		ENS	Enschede Plant
A_PCR	91	ZG_PCRO1_PCT		Template for PCR overview	GYO	GYO	Gyöngyöshalász
A_PCR	91	ZG_PCRO1_PCT		Template for PCR overview		LIM	Limda
A_PCR	91	ZZ_Labels PCR		Overview label values PCR tyres Apollo		APR	Andhra Pradesh
A_PCR	91	ZZ_Labels PCR		Overview label values PCR tyres Apollo		CHE	Chennai
A_PCR	91	ZZ_Labels PCR		Overview label values PCR tyres Apollo		ENS	Enschede Plant
A_PCR	91	ZZ_Labels PCR		Overview label values PCR tyres Apollo		GYO	Gyöngyöshalász
A_PCR	91	ZZ_Labels PCR		Overview label values PCR tyres Apollo		LIM	Limda
A_PCR	91	ZZ_PCR_RnD_FEA		Template for FEA DOE check		APR	Andhra Pradesh
A_PCR	91	ZZ_PCR_RnD_FEA		Template for FEA DOE check		CHE	Chennai
A_PCR	91	ZZ_PCR_RnD_FEA		Template for FEA DOE check	ENS	ENS	Enschede Plant
A_PCR	91	ZZ_PCR_RnD_FEA		Template for FEA DOE check		GYO	Gyöngyöshalász
A_PCR	91	ZZ_PCR_RnD_FEA		Template for FEA DOE check		LIM	Limda
*/

grant all on  sc_lims_dal.av_spec_overview_plant_frame_id   to usr_rna_readonly1;



--TEST QUERY   PLANTS
SELECT distinct part_plant_description  
FROM  sc_lims_dal.av_spec_overview_plant_frame_id a
order by part_plant_description
;

--TEST QUERY   FRAME_ID'S
SELECT distinct a.frame_id ||' - '|| a.frame_description
FROM  sc_lims_dal.av_spec_overview_plant_frame_id a
WHERE a.part_plant = ('ENS')
order by a.frame_id ||' - '|| a.frame_description
;


--TEST-QUERY   TEMPLATES
--If TEMPLATE_PLANT is <null>, AND part_plant is <null> then select ALL properties from FRAME_ID-PART-NO's !!!!
--if TEMPLATE_PLANT IS <NULL> THEN ONLY BOM but no property-selection related to FRAME-ID-PLANT-partno  !!!!!
--if TEMPLATE_PLANT IS <NOT NULL>, THEN USE TEMPLATE to filter on properties related to FRAME-ID-PLANT-part-no !!!!!
SELECT distinct template_description, template_plant, PART_PLANT
FROM  sc_lims_dal.av_spec_overview_plant_frame_id a
WHERE a.part_plant = ('ENS') 
and   a.frame_id   = ('A_PCR') 
UNION
SELECT 'No template', null, null
order by 1
;


/*
Section D-spec							ENS	ENS
Template for FEA DOE check				ENS	ENS
Overview label values PCR tyres Apollo		ENS
D-Spec and General							ENS
PAC											ENS
Template for PCR overview					ENS
Cavity parameters							ENS
Layout specification						ENS
No template                          <null> <null>
*/


--******************************************************************

--**************************************************************
--DIT IS EEN VIEW BASED ON INTERSPEC  BOM-EXPLOSION-QUERY !!!!!!!!!!
--QUERY IS SOME KIND OF DETAIL-QUERY OF MASTER = sc_lims_dal.av_reqov_requestresultsrelated
--**************************************************************
--
DROP VIEW sc_lims_dal.av_spec_overview_bomresultsrelated;
--
CREATE OR REPLACE VIEW sc_lims_dal.av_spec_overview_bomresultsrelated
(part_number
,part_revision
,frame_id
,part_description
,part_plant
,component_part
,component_characteristic_id
,component_function
)
as
select bi.part_no            AS PART_NUMBER
,      bi.revision           as part_revision
,      sh.frame_id           as frame_id
,      sh.description        AS part_description
,      pp.plant              as part_plant
,      bi.component_part     as component_part
,      bi.ch_1               as component_characteristic_id
,      ch1.description       as component_function
from sc_interspec_ens.bom_item             bi
JOIN sc_interspec_ens.bom_header           bh on (bh.part_no = bi.part_no and bh.revision = bi.revision and bh.preferred = 1 )
JOIN sc_interspec_ens.specification_header sh on (sh.part_no = bh.part_no and sh.revision = bh.revision and bh.alternative = bi.alternative )
JOIN sc_interspec_ens.status                s on (sh.status  = s.status   and s.status_type = 'CURRENT' )
JOIN sc_interspec_ens.characteristic      ch1 on (bi.ch_1    = ch1.characteristic_id )
JOIN sc_interspec_ens.part_plant           pp on (pp.part_no = sh.part_no)
--WHERE sh.revision = (select max(sh3.revision) from specification_header sh3 where sh3.part_no = sh.part_no)
--and bi.part_no in ('ER_KE21-25-110STR')
;

grant all on  sc_lims_dal.av_spec_overview_bomresultsrelated   to usr_rna_readonly1;



/*
ER_KE21-25-110STR	2	E_Belt	GORDELMATERIAAL WIT + stroken 755 0.75x20 (2x)	EX_Y40		903370	Belt gum
ER_KE21-25-110STR	2	E_Belt	GORDELMATERIAAL WIT + stroken 755 0.75x20 (2x)	EC_KE21		903361	Composite
*/

--TEST-QUERY
select distinct t.part_number
,      t.part_revision
,      t.frame_id
,      t.part_description
,      t.part_plant
from av_spec_overview_bomresultsrelated t
where  t.part_plant='ENS' 
and    t.frame_id  ='E_Belt' 
order by t.part_number
;



--ADD SELECTIE-CRITERIA BASED ON PART-NO SELECTED IN PREVIOUS-QUERY-REQUESTSRESULTSRELATED !!!!!!!!!!!!
--
--ER_KE21-25-110STR
SELECT t.part_number 
,      t.component_function 
,      t.component_part
from av_spec_overview_bomresultsrelated t
where t.part_number in ('ER_KE21-25-110STR')
;
/*
ER_KE21-25-110STR	2	GORDELMATERIAAL WIT + stroken 755 0.75x20 (2x)	EX_Y40  
ER_KE21-25-110STR	2	GORDELMATERIAAL WIT + stroken 755 0.75x20 (2x)	EC_KE21 
*/




--******************************************************************************
--******************************************************************************
--******************************************************************************

--show REQUEST-RELATED-PART-NO:
DROP VIEW sc_lims_dal.av_spec_overview_specpropsection;
--
CREATE OR REPLACE VIEW sc_lims_dal.av_spec_overview_specpropsection
(part_no
,part_no_descr
,revision
,section_id
,section_descr
,sub_section_id
,sub_section_descr
,property_group
,property_group_descr
)
as
SELECT DISTINCT sp.part_no
,    pt.description    as part_no_descr
,    sh.revision       as revision
,    sp.section_id
,    s.description     as section_descr
,    sp.sub_section_id
,    ss.description    as sub_section_descr
,    sp.property_group as property_group
,    pg.description    as property_group_descr
,    sp.property       
,    p.description     as property_description
FROM sc_interspec_ens.part                 pt
JOIN sc_interspec_ens.specification_prop   sp on sp.part_no = pt.part_no
JOIN sc_interspec_ens.specification_header sh ON (SH.part_no = Sp.part_no and sh.revision = sp.revision)
JOIN sc_interspec_ens.status               st on (st.status = sh.status)
join sc_interspec_ens.property_group       pg on (pg.property_group = sp.property_group)
join sc_interspec_ens.property             p  on (p.property = sp.property)
join sc_interspec_ens.section              s  on (s.section_id = sp.section_id)
join sc_interspec_ens.sub_section          ss on (ss.sub_section_id = sp.sub_section_id)
WHERE st.status_type = 'CURRENT'
--AND  sh.part_no = 'ER_KE21-25-110STR'         --'XEF_Bi20S21A1'
--and sh.revision = 1
order by sp.part_no
,         s.description
,         ss.description
,         pg.description
,         p.description
;

grant all on  sc_lims_dal.av_spec_overview_specpropsection   to usr_rna_readonly1;


/*
ER_KE21-25-110STR	GORDELMATERIAAL WIT + stroken 755 0.75x20 (2x)	2	700583	Processing	701723	SCCUT: STAALKOORD CUTTER	0	default property group	710528	volgnummer
ER_KE21-25-110STR	GORDELMATERIAAL WIT + stroken 755 0.75x20 (2x)	2	700584	Properties	0	(none)	701817	Dimensions SFP	704688	Angle
ER_KE21-25-110STR	GORDELMATERIAAL WIT + stroken 755 0.75x20 (2x)	2	700584	Properties	0	(none)	701817	Dimensions SFP	703268	Width
ER_KE21-25-110STR	GORDELMATERIAAL WIT + stroken 755 0.75x20 (2x)	2	700584	Properties	0	(none)	702337	STRAM	703209	Gauge
ER_KE21-25-110STR	GORDELMATERIAAL WIT + stroken 755 0.75x20 (2x)	2	700584	Properties	0	(none)	702337	STRAM	703268	Width
ER_KE21-25-110STR	GORDELMATERIAAL WIT + stroken 755 0.75x20 (2x)	2	700755	SAP information	0	(none)	703176	Aging SAP	710530	Aging (Maximal)
ER_KE21-25-110STR	GORDELMATERIAAL WIT + stroken 755 0.75x20 (2x)	2	700755	SAP information	0	(none)	703176	Aging SAP	710529	Aging (minimal)
ER_KE21-25-110STR	GORDELMATERIAAL WIT + stroken 755 0.75x20 (2x)	2	700755	SAP information	0	(none)	0	default property group	705428	Article group PG
ER_KE21-25-110STR	GORDELMATERIAAL WIT + stroken 755 0.75x20 (2x)	2	700755	SAP information	0	(none)	0	default property group	710531	Article type
ER_KE21-25-110STR	GORDELMATERIAAL WIT + stroken 755 0.75x20 (2x)	2	700755	SAP information	0	(none)	0	default property group	705429	Packaging PG
ER_KE21-25-110STR	GORDELMATERIAAL WIT + stroken 755 0.75x20 (2x)	2	700755	SAP information	0	(none)	0	default property group	709030	Physical in product
ER_KE21-25-110STR	GORDELMATERIAAL WIT + stroken 755 0.75x20 (2x)	2	700755	SAP information	0	(none)	0	default property group	717751	SAP material group
ER_KE21-25-110STR	GORDELMATERIAAL WIT + stroken 755 0.75x20 (2x)	2	700755	SAP information	0	(none)	0	default property group	703262	Weight
*/

--We missen nu alleen de VALUES nog over de verschillende attributen met hun betekenis !!!!!!!!
select * from  sc_lims_dal.AV_REQOV_BASE_SELECT_SPECPROP  where part_no = 'ER_KE21-25-110STR' ;
select * from av_reqov_req_specpropdetails where part_no = 'ER_KE21-25-110STR' ;
--OF:
select * from  sc_lims_dal.AV_REQOV_BASE_SELECT_SPECPROP_NW  where part_no = 'ER_KE21-25-110STR' ;

--uitvragen TEMPLATE-PART-NO:
select * from sc_lims_dal.AV_REQOV_BASE_SELECT_SPECPROP_NW  where part_no = 'ZZ_RnD_PCR_GTX' ;


--Vervolgen op property-values vergelijken van SPEC met TEMPLATE en alleen deze properties / values in export opnemen !!!!!!!!!








--end script


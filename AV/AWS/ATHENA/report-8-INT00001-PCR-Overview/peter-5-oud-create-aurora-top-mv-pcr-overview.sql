--*************************************************************************
--*************************************************************************
--TOP-LEVEL-MATERIALIZED-VIEWS USED IN REPORTING
--*************************************************************************
--*************************************************************************
--POSTGRES-SCHEMA DM_LIMS  MIGREREN NAAR SC_LIMS_DAL !!!!!!
--dm_lims.PCR overview              migreren naar    sc_lims_dal.mv_pcr_overview
--dm_lims.PCR General information   migreren naar    sc_lims_dal.mv_pcr_general_information
--

--***************************************************************************
--MV USED IN OLD-ATHENA-REPORT !!!!!
--1.sc_lims_dal.mv_pcr_overview
											 , jsonb_build_object('function_path_query'
											                     , '{*.Bead|Bead_apex|Belt*|Capply|Capstrip|Greentyre|Innerliner|Innerliner_assembly|Pre_Assembly|Ply*|Rubberstrip|Sidewall*|Tread|Tyre|Vulcanized_tyre|Tyre_vulcanized
                                                                     , *.Tread.Compound|Tread_compound, *.Capstrip.Capply, *.Ply*|Belt*.Racknumber|Composite }'
--###############################################################################
--MV TBV NEW-ATHENA-REPORT !!!!!!!
--2.sc_lims_dal.mv_pcr_general_information
											 , jsonb_build_object('function_path_query'
											                     , '{ *.Greentyre|Tyre|Vulcanized_tyre|Tyre_vulcanized }'

--3.sc_lims_dal.mv_pcr_1st_stage_components
											 , jsonb_build_object('function_path_query'
											                     , ARRAY['*.Tyre'::text
																       , '*.Tyre.Vulcanized_tyre|Tyre_vulcanized'::text
																	   , '*.Tyre.Vulcanized_tyre|Tyre_vulcanized.Greentyre'::text
																	   , '*.Greentyre.Bead_apex|Innerliner_assembly|Ply*|Sidewall|Sidewall_L|Sidewall_L_R|Tread'::text
																	   , '*.Greentyre.Bead|Innerliner|Ply*|Pre_Assembly|Sidewall|Sidewall_L|Sidewall_L_R|Tread'::text
																	   , '*.Greentyre.Bead_apex|Innerliner_assembly|Sidewall|Sidewall_L|Sidewall_L_R|Tread.*{1}'::text
																	   , '*.Greentyre.Pre_Assembly.*{1,2}'::text
																	   , '*.Greentyre.Bead_apex.Bead.*{1}'::text
																	   , '*.Greentyre.Bead|Innerliner|Racknumber|Sidewall|Sidewall_L|Sidewall_L_R|Tread.*{1}'::text
																	   , '*.Greentyre.Innerliner.Rubberstrip.Rubberstrip'::text
																	   , '*.Greentyre.Ply*.Composite|Racknumber'::text
																	   , '*.Greentyre.Ply*.Composite.Compound|Composite_compound'::text
																	   , '*.Greentyre.Ply*.Racknumber.Compound|Fabric'::text
																	   , '*.Squeegee'::text]

--4.sc_lims_dal.mv_pcr_2nd_stage_components
											 , jsonb_build_object('function_path_query'
											                     , ARRAY[ '*.Belt_1|Belt_2|Capply|Capstrip|Greentyre|Tread|Vulcanized_tyre|Tyre_vulcanized'::text
																        , '*.Belt_1|Belt_2.Composite|Racknumber|Steelcord'::text
																		, '*.Belt_1|Belt_2.Racknumber.Compound|Steelcord'::text
																		, '*.Belt_1|Belt_2.Composite.Composite_compound|Reinforcement'::text
																		, '*.Belt_1.Belt_gum'::text
																		, '*.Belt_1.Belt_gum.*{1}'::text
																		, '*.Belt_1.Belt_gum.*.Belt_gum_compound'::text
																		, '*.Belt_1.Rubberstrip'::text
																		, '*.Belt_1.Rubberstrip.*{1}'::text
																		, '*.Belt_1.Rubberstrip.*.!Compound.Compound'::text
																		, '*.Tread.*{1}'::text]


--****************************************************************************
--TIP: table in util_interspec-schema are materialized-views !!!!!!!!!
--     table in rd_interspec_webfocus are source-tables interspec !!!!!!!!!!
--

grant all on  sc_lims_dal.mv_pcr_overview              to usr_rna_readonly1;
grant all on  sc_lims_dal.mv_pcr_general_information   to usr_rna_readonly1;
grant all on  sc_lims_dal.mv_pcr_1st_stage_components   to usr_rna_readonly1;
grant all on  sc_lims_dal.mv_pcr_2nd_stage_components   to usr_rna_readonly1;



--*******************************************
--*******************************************
--IMPLEMENTATION IN AWS-AURORA-DATABASE !!!!!!!!
--*******************************************
--*******************************************


--*******************************************
--1.sc_lims_dal.mv_pcr_overview
--Selecteer vooral van algemene tyre-info like weight, noise, etc (Tyre, Greentyre, Vulcanized tyre)
--         en Dimensions (Innerliner, Ply, Belt, Bead, Sidewall)
--         en Coordinates tbv thickness van Tread + Sidewall 
--
--*******************************************
CREATE MATERIALIZED VIEW sc_lims_dal.mv_pcr_overview
TABLESPACE pg_default
AS WITH bom_properties AS (
SELECT ss.part_no
,      ss.revision
,      bh.plant
,      jsonb_build_object('Top', s_1.properties) || jsonb_object_agg(
                CASE
                    WHEN t_1.bom_function  = 'Compound'::text THEN COALESCE(NULLIF(t_1.keywords #>> '{"Compound application",0}'::text[], '<Any>'::text), subpath(t_1.function_path, '-2'::integer, 1)::text) || ' compound'::text
                    WHEN t_1.spec_function = 'Racknumber'::text THEN (subpath(t_1.function_path, '-2'::integer)::text || '.'::text) || c.sort_desc::text
                    WHEN t_1.spec_function = 'Sidewall'::text THEN t_1.spec_function
                    ELSE t_1.bom_function
                END, jsonb_build_object('part_no', t_1.component_part_no, 'revision', t_1.component_revision, 'alternative', t_1.alternative, 'preferred', t_1.preferred) || comp_s.properties) AS bom
FROM sc_lims_dal.mv_specification_status ss
JOIN sc_lims_dal.mv_specification       s_1 USING (part_no, revision)
JOIN sc_interspec_ens.bom_header         bh USING (part_no, revision)
CROSS JOIN LATERAL sc_lims_dal.fnc_bom_explode(ss.part_no::text
                                             , ss.revision
											 , bh.alternative
											 , bh.plant::text
											 , jsonb_build_object('function_path_query'
											                     , '{*.Bead|Bead_apex|Belt*|Capply|Capstrip|Greentyre|Innerliner|Innerliner_assembly|Pre_Assembly|Ply*|Rubberstrip|Sidewall*|Tread|Tyre|Vulcanized_tyre|Tyre_vulcanized
                                                                     , *.Tread.Compound|Tread_compound, *.Capstrip.Capply, *.Ply*|Belt*.Racknumber|Composite }'
																 )
											) t_1(part_no, revision, component_part_no, component_revision, class3_id, plant, alternative, preferred, keywords, spec_function, level, item_number, bom_function, properties, hierarchy, part_path, function_path, contains_cycle, quantity, total_quantity)
JOIN sc_lims_dal.mv_specification    comp_s ON ( comp_s.part_no::text = t_1.component_part_no AND comp_s.revision = t_1.component_revision )
JOIN sc_interspec_ens.class3              c ON c.class = t_1.class3_id
WHERE ss.status_type::text = 'CURRENT'::text 
AND (ss.status_code::text <> ALL (ARRAY['TEMP CRRNT'::character varying, 'CRRNT QR1'::character varying, 'CRRNT QR2'::character varying]::text[])) 
AND ss.frame_id::text = 'A_PCR'::text 
AND NOT ss.is_trial 
AND bh.preferred = 1::numeric 
AND (   t_1.function_path ? '{*.!Racknumber}'::lquery[] 
    OR  (  t_1.function_path @ 'Racknumber'::ltxtquery 
        AND (c.sort_desc::text = ANY (ARRAY['TEXTCOMP'::character varying, 'STEELCOMP'::character varying]::text[])   )
		)
    )
GROUP BY ss.part_no
,        ss.revision
,       s_1.functionkw
,       s_1.properties
,        bh.plant
)
SELECT  bom_properties.part_no  AS "Part no."
 ,      bom_properties.revision AS "Rev."
 ,      bom_properties.plant    AS "Plant"
 ,  (((((bom_properties.bom -> 'Top'::text) -> 'General information'::text) -> '(none)'::text) -> 'Size'::text) -> 'Building method'::text) ->> 'Value'::text AS "Building method",
    (((((bom_properties.bom -> 'Top'::text) -> 'General information'::text) -> '(none)'::text) -> 'Size'::text) -> 'Speed index'::text) ->> 'Value'::text AS "Speed index",
    (((((bom_properties.bom -> 'Top'::text) -> 'General information'::text) -> '(none)'::text) -> 'Size'::text) -> 'Section width'::text) ->> 'Value'::text AS "Section width",
    (((((bom_properties.bom -> 'Top'::text) -> 'General information'::text) -> '(none)'::text) -> 'Size'::text) -> 'Aspect ratio'::text) ->> 'Value'::text AS "Aspect ratio",
    (((((bom_properties.bom -> 'Top'::text) -> 'General information'::text) -> '(none)'::text) -> 'Size'::text) -> 'Rimcode'::text) ->> 'Value'::text AS "Rim code",
    (((((bom_properties.bom -> 'Top'::text) -> 'General information'::text) -> '(none)'::text) -> 'Size'::text) -> 'Productlinecode'::text) ->> 'Value'::text AS "Product- line code",
    (((((bom_properties.bom -> 'Top'::text) -> 'General information'::text) -> '(none)'::text) -> 'Size'::text) -> 'Load index'::text) ->> 'Value'::text AS "Load index",
    (((((bom_properties.bom -> 'Top'::text) -> 'General information'::text) -> '(none)'::text) -> 'General tyre characteristics'::text) -> 'Load index class'::text) ->> 'Value'::text AS "Load index class",
    (((((bom_properties.bom -> 'Top'::text) -> 'General information'::text) -> '(none)'::text) -> 'General tyre characteristics'::text) -> 'Productline'::text) ->> 'Value'::text AS "Product- line",
    (((((bom_properties.bom -> 'Top'::text) -> 'General information'::text) -> '(none)'::text) -> 'General tyre characteristics'::text) -> 'Category'::text) ->> 'Value'::text AS "Category",
    (((((bom_properties.bom -> 'Top'::text) -> 'Labels and certification'::text) -> '(none)'::text) -> 'Labels Rolling resistance'::text) -> 'Europe'::text) ->> 'Label'::text AS "Rolling resistance",
    (((((bom_properties.bom -> 'Top'::text) -> 'Labels and certification'::text) -> '(none)'::text) -> 'Labels Noise'::text) -> 'Europe'::text) ->> 'Sound waves'::text AS "Tyre noise label",
    (((((bom_properties.bom -> 'Top'::text) -> 'Labels and certification'::text) -> '(none)'::text) -> 'Labels Noise'::text) -> 'Europe'::text) ->> 'Noise (dB)'::text AS "Tyre noise",
    (((((bom_properties.bom -> 'Top'::text) -> 'Labels and certification'::text) -> '(none)'::text) -> 'Labels Wet grip'::text) -> 'Europe'::text) ->> 'Label'::text AS "Wet grip index",
    ((((((bom_properties.bom -> 'Top'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Indoor testing'::text) -> 'Tyre weight'::text) ->> 'Target'::text)::double precision AS "Tyre weight",
    ((((((bom_properties.bom -> 'Top'::text) -> 'D-spec'::text) -> '(none)'::text) -> 'Master drawing general'::text) -> 'Overall diameter'::text) ->> 'Value'::text)::double precision AS "Overall dia",
    ((((((bom_properties.bom -> 'Top'::text) -> 'D-spec'::text) -> '(none)'::text) -> 'Master drawing'::text) -> 'Y contour drawing'::text) ->> 'Target'::text)::double precision AS "Y",
    ((((((bom_properties.bom -> 'Top'::text) -> 'D-spec'::text) -> '(none)'::text) -> 'Master drawing'::text) -> 'R3 contour drawing'::text) ->> 'Target'::text)::double precision AS "R3",
    ((((((bom_properties.bom -> 'Top'::text) -> 'D-spec'::text) -> '(none)'::text) -> 'Master drawing'::text) -> 'Tread depth mould'::text) ->> 'Target'::text)::double precision AS "Tread depth mould",
    (((((bom_properties.bom -> 'Top'::text) -> 'SAP information'::text) -> '(none)'::text) -> 'SAP articlecode'::text) -> 'Commercial article code'::text) ->> 'Value'::text AS "SAP Article code",
    COALESCE((((((bom_properties.bom -> 'Top'::text) -> 'D-spec'::text) -> '(none)'::text) -> 'D-Spec (section)'::text) -> 'Base CL'::text) ->> 'Target'::text, 
	         (((((bom_properties.bom -> 'Top'::text) -> 'D-spec'::text) -> '(none)'::text) -> 'D-Spec (section)'::text) -> 'Base CL'::text) ->> 'Design Target'::text)::double precision AS "Tread base thickness",
    (((((bom_properties.bom -> 'Vulcanized tyre'::text) -> 'Processing'::text) -> 'General'::text) -> 'default property group'::text) -> 'Curing critical point'::text) ->> 'Value'::text AS "Curing critical point",
    ((((((bom_properties.bom -> 'Vulcanized tyre'::text) -> 'Processing'::text) -> 'General'::text) -> 'Curing settings (steam)'::text) -> 'Curing time (total)'::text) ->> 'Target'::text)::double precision AS "Curing time (steam)",
    ((((((bom_properties.bom -> 'Vulcanized tyre'::text) -> 'Processing'::text) -> 'General'::text) -> 'Curing settings (nitrogen)'::text) -> 'Curing time (total)'::text) ->> 'Target'::text)::double precision AS "Curing time (nitrogen)",
    (bom_properties.bom -> 'Label'::text) ->> 'part_no'::text AS "Label",
    (((((bom_properties.bom -> 'Greentyre'::text) -> 'Processing'::text) -> 'General'::text) -> 'Building machine settings'::text) -> 'Lift belt package'::text) ->> 'Target'::text AS "Lift belt package",
    ((((((bom_properties.bom -> 'Greentyre'::text) -> 'Processing'::text) -> 'General'::text) -> 'Building machine settings'::text) -> 'Bead distance'::text) ->> 'Target'::text)::double precision AS "Bead distance",
    ((((((bom_properties.bom -> 'Greentyre'::text) -> 'Processing'::text) -> 'General'::text) -> 'Building machine settings'::text) -> 'Stretching distance'::text) ->> 'Target'::text)::double precision AS "Stretching distance",
    ((((((bom_properties.bom -> 'Greentyre'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Greentyre properties'::text) -> 'Number of capply layers'::text) ->> 'Target'::text)::double precision AS "No. capply layers",
    ((((((bom_properties.bom -> 'Pre Assembly'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Pre-Assembly properties'::text) -> 'PA width'::text) ->> 'Target'::text)::double precision AS "Pre- assembly width",
    (((((COALESCE(bom_properties.bom -> 'Innerliner assembly'::text, bom_properties.bom -> 'Innerliner'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Dimensions SFP'::text) -> 'Width'::text) ->> 'Target'::text)::double precision AS "Innerliner width",
    (((((COALESCE(bom_properties.bom -> 'Innerliner assembly'::text, bom_properties.bom -> 'Innerliner'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Dimensions SFP'::text) -> 'Gauge'::text) ->> 'Target'::text)::double precision AS "Innerliner gauge",
    "substring"((bom_properties.bom -> 'Ply 1'::text) ->> 'part_no'::text, 4, 4) AS "Ply1 type",
    ((((((bom_properties.bom -> 'Ply 1'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Dimensions SFP'::text) -> 'Angle'::text) ->> 'Target'::text)::double precision AS "Ply1 angle",
    ((((((bom_properties.bom -> 'Ply 1'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Dimensions SFP'::text) -> 'Width'::text) ->> 'Target'::text)::double precision AS "Ply1 width",
    (((((COALESCE(bom_properties.bom -> 'Ply_1.Racknumber.TEXTCOMP'::text, bom_properties.bom -> 'Ply_1.Composite.TEXTCOMP'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Properties textile composites'::text) -> 'Calendered material thickness'::text) ->> 'Target'::text)::double precision AS "Gauge rack-no. Ply 1",
    ((((((bom_properties.bom -> 'Ply 2'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Dimensions SFP'::text) -> 'Width'::text) ->> 'Target'::text)::double precision AS "Ply2 width",
    (((((COALESCE(bom_properties.bom -> 'Ply_2.Racknumber.TEXTCOMP'::text, bom_properties.bom -> 'Ply_2.Composite.TEXTCOMP'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Properties textile composites'::text) -> 'Calendered material thickness'::text) ->> 'Target'::text)::double precision AS "Gauge rack-no. Ply 2",
    "substring"((bom_properties.bom -> 'Belt 1'::text) ->> 'part_no'::text, 4, 5) AS "Belt1 type",
    ((((((bom_properties.bom -> 'Belt 1'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Dimensions SFP'::text) -> 'Width'::text) ->> 'Target'::text)::double precision AS "Belt1 width",
    ((((((bom_properties.bom -> 'Belt 1'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Dimensions SFP'::text) -> 'Angle'::text) ->> 'Target'::text)::double precision AS "Belt1 angle",
    (((((COALESCE(bom_properties.bom -> 'Belt_1.Composite.STEELCOMP'::text, bom_properties.bom -> 'Belt_1.Racknumber.STEELCOMP'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Properties steelcord composites'::text) -> 'Calendered material thickness'::text) ->> 'Target'::text)::double precision AS "Gauge rack-no. Belt 1",
    ((((((bom_properties.bom -> 'Rubberstrip'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Dimensions SFP'::text) -> 'Gauge'::text) ->> 'Target'::text)::double precision AS "Rubber- strip gauge",
    ((((((bom_properties.bom -> 'Rubberstrip'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Dimensions SFP'::text) -> 'Width'::text) ->> 'Target'::text)::double precision AS "Rubber- strip width",
    "substring"((bom_properties.bom -> 'Capply'::text) ->> 'part_no'::text, 4, 4) AS "Capply type",
    ((((((bom_properties.bom -> 'Capstrip'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Dimensions SFP'::text) -> 'Width'::text) ->> 'Target'::text)::double precision AS "Cap- strip width",
    (bom_properties.bom -> 'Bead'::text) ->> 'part_no'::text AS "Bead code",
    ((((((bom_properties.bom -> 'Bead'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Bead properties'::text) -> 'Turns'::text) ->> 'Target'::text)::double precision AS "Bead turns",
    ((((((bom_properties.bom -> 'Bead'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Bead properties'::text) -> 'Wires'::text) ->> 'Target'::text)::double precision AS "Bead wires",
    ((((((bom_properties.bom -> 'Bead'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Bead apex combination'::text) -> 'Bead apex height (total)'::text) ->> 'Target'::text)::double precision AS "Bead height",
    (bom_properties.bom -> 'Tread'::text) ->> 'part_no'::text AS "Tread code",
    (((((bom_properties.bom -> 'Tread'::text) -> 'Processing'::text) -> 'TRIPL'::text) -> 'Tooling'::text) -> 'Die'::text) ->> 'Value'::text AS "Tread die (Tplex)",
    (((((bom_properties.bom -> 'Tread'::text) -> 'Processing'::text) -> 'QUADR'::text) -> 'Tooling'::text) -> 'Die'::text) ->> 'Value'::text AS "Tread die (Qplex)",
    t.y_c1 AS "Tread thickness",
    t.y_c2 AS "Undertread thickness",
    t.y_c4 AS "Base thickness",
    COALESCE(bom_properties.bom -> 'Tread compound'::text, bom_properties.bom -> 'Base compound'::text) ->> 'part_no'::text AS "Tread mixture",
    (bom_properties.bom -> 'Sidewall'::text) ->> 'part_no'::text AS "Sidewall",
    ((((((bom_properties.bom -> 'Sidewall'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Main extrudate dimensions'::text) -> 'Total width'::text) ->> 'Target'::text)::double precision AS "Sidewall total width",
    ((((((bom_properties.bom -> 'Sidewall'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Main extrudate dimensions'::text) -> 'Transition sidewall - rimcushion'::text) ->> 'Target'::text)::double precision AS "Sidewall width",
    ((((((bom_properties.bom -> 'Sidewall'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Main extrudate dimensions'::text) -> 'Rimcushion width'::text) ->> 'Target'::text)::double precision AS "Rim- cushion width",
    s.y_tot AS "Sidewall thickness",
    (((((COALESCE(bom_properties.bom -> 'Bead'::text, bom_properties.bom -> 'Bead apex'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Bead properties'::text) -> 'Layer width'::text) ->> 'Target'::text)::double precision AS "Layer width",
    (((((COALESCE(bom_properties.bom -> 'Bead apex'::text, bom_properties.bom -> 'Bead'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Bead apex combination'::text) -> 'Bead apex height (total)'::text) ->> 'Target'::text)::double precision AS "Apex height (total)"
FROM bom_properties
CROSS JOIN LATERAL ( WITH sppl(coordinates) AS (SELECT (((bom_properties.bom -> 'Tread'::text) -> 'SPPL'::text) -> '(none)'::text) -> 'Coordinates'::text AS "?column?"  )
                     SELECT max(((sppl.coordinates -> c.coordinate) ->> 'y_C1'::text)::double precision) AS y_c1
					 ,      max(((sppl.coordinates -> c.coordinate) ->> 'y_C2'::text)::double precision) AS y_c2
					 ,      max(((sppl.coordinates -> c.coordinate) ->> 'y_C4'::text)::double precision) AS y_c4
                     FROM sppl
                     CROSS JOIN LATERAL jsonb_object_keys(sppl.coordinates) c(coordinate)
                   ) t
CROSS JOIN LATERAL ( SELECT max(((((((bom_properties.bom -> 'Sidewall'::text) -> 'SPPL'::text) -> '(none)'::text) -> 'Coordinates'::text) -> s_1.coordinate) ->> 'y_Tot.'::text)::double precision) AS y_tot
                     FROM jsonb_object_keys((((bom_properties.bom -> 'Sidewall'::text) -> 'SPPL'::text) -> '(none)'::text) -> 'Coordinates'::text) s_1(coordinate)) s
WITH DATA
;

-- View indexes:
CREATE UNIQUE INDEX sc_lims_dal.pcr_overview_part_no_uq       ON sc_lims_dal.mv_pcr_overview  USING btree ("Part no.");
CREATE UNIQUE INDEX sc_lims_dal.pcr_overview_plant_part_no_uq ON sc_lims_dal.mv_pcr_overview  USING btree ("Plant", "Part no.");


--TEST-QUERY
select * 
from sc_lims_dal.mv_pcr_overview mv
where mv.plant = 'ENS'
;




--***********************************************
--2.sc_lims_dal.mv_pcr_general_information
--
--Selectie van mn. Tooling, Machine-settings, SAP-info  (Tyre, Greentyre, Vulcanized-tyre)
--
--***********************************************
CREATE MATERIALIZED VIEW sc_lims_dal.mv_pcr_general_information
TABLESPACE pg_default
AS WITH bom_properties AS (
SELECT ss.part_no
,      ss.revision
,      bh.plant
,      jsonb_build_object('Top', s.properties) || jsonb_object_agg(
                CASE
                    WHEN t.spec_function = 'Racknumber'::text THEN (subpath(t.function_path, '-2'::integer)::text || '.'::text) || c.sort_desc::text
                    WHEN t.spec_function = 'Sidewall'::text THEN t.spec_function
                    ELSE t.bom_function
                END, jsonb_build_object('part_no', t.component_part_no, 'revision', t.component_revision, 'alternative', t.alternative, 'preferred', t.preferred) || comp_s.properties) AS bom
FROM sc_lims_dal.mv_specification_status ss
JOIN sc_lims_dal.mv_specification         s USING (part_no, revision)
JOIN sc_interspec_ens.bom_header         bh USING (part_no, revision)
CROSS JOIN LATERAL sc_lims_dal.fnc_bom_explode(ss.part_no::text
                                             , ss.revision
											 , bh.alternative
											 , bh.plant::text
											 , jsonb_build_object('function_path_query'
											                     , '{ *.Greentyre|Tyre|Vulcanized_tyre|Tyre_vulcanized }'
																 )
											) t(part_no, revision, component_part_no, component_revision, class3_id, plant, alternative, preferred, keywords, spec_function, level, item_number, bom_function, properties, hierarchy, part_path, function_path, contains_cycle, quantity, total_quantity)
JOIN sc_lims_dal.mv_specification comp_s ON comp_s.part_no::text = t.component_part_no AND comp_s.revision = t.component_revision
JOIN sc_interspec_ens.class3           c ON c.class = t.class3_id
WHERE ss.status_type::text = 'CURRENT'::text 
AND (ss.status_code::text <> ALL (ARRAY['TEMP CRRNT'::character varying, 'CRRNT QR1'::character varying, 'CRRNT QR2'::character varying]::text[])) 
AND ss.frame_id::text = 'A_PCR'::text 
AND NOT ss.is_trial 
AND bh.preferred = 1::numeric
GROUP BY ss.part_no
, ss.revision
, s.functionkw
, s.properties
, bh.plant
)
SELECT bom_properties.part_no AS "Part no"
,      bom_properties.revision AS "Rev"
,      bom_properties.plant AS "Plant"
,   (((((bom_properties.bom -> 'Top'::text) -> 'General information'::text) -> '(none)'::text) -> 'Size'::text) -> 'Building method'::text) ->> 'Value'::text AS "Building method",
    (((((bom_properties.bom -> 'Top'::text) -> 'General information'::text) -> '(none)'::text) -> 'Size'::text) -> 'Speed index'::text) ->> 'Value'::text AS "Speed index",
    (((((bom_properties.bom -> 'Top'::text) -> 'General information'::text) -> '(none)'::text) -> 'Size'::text) -> 'Section width'::text) ->> 'Value'::text AS "Section width",
    (((((bom_properties.bom -> 'Top'::text) -> 'General information'::text) -> '(none)'::text) -> 'Size'::text) -> 'Aspect ratio'::text) ->> 'Value'::text AS "Aspect ratio",
    (((((bom_properties.bom -> 'Top'::text) -> 'General information'::text) -> '(none)'::text) -> 'Size'::text) -> 'Rimcode'::text) ->> 'Value'::text AS "Rim code",
    (((((bom_properties.bom -> 'Top'::text) -> 'General information'::text) -> '(none)'::text) -> 'Size'::text) -> 'Productlinecode'::text) ->> 'Value'::text AS "Product-line code",
    (((((bom_properties.bom -> 'Top'::text) -> 'General information'::text) -> '(none)'::text) -> 'Size'::text) -> 'Load index'::text) ->> 'Value'::text AS "Load index",
    (((((bom_properties.bom -> 'Top'::text) -> 'General information'::text) -> '(none)'::text) -> 'General tyre characteristics'::text) -> 'Load index class'::text) ->> 'Value'::text AS "Load index class",
    (((((bom_properties.bom -> 'Top'::text) -> 'General information'::text) -> '(none)'::text) -> 'General tyre characteristics'::text) -> 'Productline'::text) ->> 'Value'::text AS "Product-line",
    (((((bom_properties.bom -> 'Top'::text) -> 'General information'::text) -> '(none)'::text) -> 'General tyre characteristics'::text) -> 'Category'::text) ->> 'Value'::text AS "Category",
    NULL::text AS "Client",
    (bom_properties.bom -> 'Greentyre'::text) ->> 'part_no'::text AS "Greentyre code",
    (((((bom_properties.bom -> 'Top'::text) -> 'SAP information'::text) -> '(none)'::text) -> 'SAP articlecode'::text) -> 'Commercial article code'::text) ->> 'Value'::text AS "SAP tyre code",
    (((((bom_properties.bom -> 'Top'::text) -> 'SAP information'::text) -> '(none)'::text) -> 'SAP information'::text) -> 'QR phase'::text) ->> 'Value'::text AS "QR release status",
    (((((bom_properties.bom -> 'Top'::text) -> 'D-spec'::text) -> '(none)'::text) -> 'Master drawing general'::text) -> 'Segment'::text) ->> 'Value'::text AS "Mould number",
    ((((((bom_properties.bom -> 'Greentyre'::text) -> 'Processing'::text) -> 'General'::text) -> 'Building machine settings'::text) -> 'Bead distance'::text) ->> 'Target'::text)::double precision AS "Bead distance",
    (((((bom_properties.bom -> 'Greentyre'::text) -> 'Processing Gyongyoshalasz'::text) -> 'PTBM:PCT Tyre building machine group'::text) -> 'Tooling'::text) -> 'Bead Lock Type'::text) ->> 'Value'::text AS "Bead lock type",
    (((((bom_properties.bom -> 'Greentyre'::text) -> 'Processing Gyongyoshalasz'::text) -> 'PTBM:PCT Tyre building machine group'::text) -> 'Tooling'::text) -> 'Centerdeck'::text) ->> 'Value'::text AS "Centerdeck",
    (((((bom_properties.bom -> 'Greentyre'::text) -> 'Processing Gyongyoshalasz'::text) -> 'PTBM:PCT Tyre building machine group'::text) -> 'Tooling'::text) -> 'Side ring (SR)'::text) ->> 'Value'::text AS "Side Ring",
    (((((bom_properties.bom -> 'Greentyre'::text) -> 'Processing Gyongyoshalasz'::text) -> 'PTBM:PCT Tyre building machine group'::text) -> 'Tooling'::text) -> 'Bead holder rings (BRH)'::text) ->> 'Value'::text AS "Bead holder rings",
    (((((bom_properties.bom -> 'Top'::text) -> 'General information'::text) -> '(none)'::text) -> 'General tyre characteristics'::text) -> 'Tyre construction'::text) ->> 'Value'::text AS "Construction",
    (((((bom_properties.bom -> 'Top'::text) -> 'D-spec'::text) -> '(none)'::text) -> 'Construction parameters'::text) -> 'Sidewall over tread'::text) ->> 'Value'::text AS "SW over TD",
    ((((((bom_properties.bom -> 'Greentyre'::text) -> 'Processing'::text) -> 'General'::text) -> 'Building machine settings'::text) -> 'Stretching distance'::text) ->> 'Target'::text)::double precision AS "Stretching distance",
    COALESCE((((((bom_properties.bom -> 'Greentyre'::text) -> 'Processing Gyongyoshalasz'::text) -> 'PTBM:PCT Tyre building machine group'::text) -> 'Building machine settings'::text) -> 'Circumference B&T drum'::text) ->> 'Target'::text, (((((bom_properties.bom -> 'Greentyre'::text) -> 'Processing'::text) -> 'General'::text) -> 'Building machine settings'::text) -> 'Circumference B&T drum'::text) ->> 'Target'::text)::double precision AS "Circumference B&T drum",
    ((((((bom_properties.bom -> 'Greentyre'::text) -> 'Processing Gyongyoshalasz'::text) -> 'PTBM:PCT Tyre building machine group'::text) -> 'Building machine settings'::text) -> 'Circumference carcass drum'::text) ->> '-tol'::text)::double precision AS "Circumference carcass drum, lower tolerance",
    ((((((bom_properties.bom -> 'Top'::text) -> 'D-spec'::text) -> '(none)'::text) -> 'D-Spec (reinforcements)'::text) -> 'Development length bead to bead'::text) ->> 'Target'::text)::double precision AS "Development length bead to bead",
    ((((((bom_properties.bom -> 'Top'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Indoor testing'::text) -> 'Tyre weight'::text) ->> 'Target'::text)::double precision AS "Tyre weight",
    ((((((bom_properties.bom -> 'Vulcanized tyre'::text) -> 'Processing'::text) -> 'General'::text) -> 'Curing settings (steam)'::text) -> 'Curing time (total)'::text) ->> 'Target'::text)::double precision AS "Curing time (steam)",
    ((((((bom_properties.bom -> 'Vulcanized tyre'::text) -> 'Processing'::text) -> 'General'::text) -> 'Curing settings (nitrogen)'::text) -> 'Curing time (total)'::text) ->> 'Target'::text)::double precision AS "Curing time (nitrogen)",
    ((((((bom_properties.bom -> 'Top'::text) -> 'D-spec'::text) -> '(none)'::text) -> 'Master drawing general'::text) -> 'Overall diameter'::text) ->> 'Value'::text)::double precision AS "Overall dia mould",
    ((((((bom_properties.bom -> 'Top'::text) -> 'D-spec'::text) -> '(none)'::text) -> 'Parent segment'::text) -> 'N-dia'::text) ->> 'Value'::text)::double precision AS "N-dia mould",
    ((((((bom_properties.bom -> 'Top'::text) -> 'D-spec'::text) -> '(none)'::text) -> 'Parent segment'::text) -> 'D-dia'::text) ->> 'Value'::text)::double precision AS "D-dia mould",
    ((((((bom_properties.bom -> 'Top'::text) -> 'D-spec'::text) -> '(none)'::text) -> 'Master drawing general'::text) -> 'S-dia'::text) ->> 'Value'::text)::double precision AS "S-dia mould",
    ((((((bom_properties.bom -> 'Top'::text) -> 'D-spec'::text) -> '(none)'::text) -> 'Master drawing'::text) -> 'HAS'::text) ->> 'Target'::text)::double precision AS "HAS value mould",
    ((((((bom_properties.bom -> 'Top'::text) -> 'D-spec'::text) -> '(none)'::text) -> 'Parent segment'::text) -> 'Section width'::text) ->> 'Value'::text)::double precision AS "Mould section width",
    ((((((bom_properties.bom -> 'Top'::text) -> 'D-spec'::text) -> '(none)'::text) -> 'Master drawing'::text) -> 'Y contour drawing'::text) ->> 'Target'::text)::double precision AS "Y",
    ((((((bom_properties.bom -> 'Top'::text) -> 'D-spec'::text) -> '(none)'::text) -> 'Master drawing'::text) -> 'R3 contour drawing'::text) ->> 'Target'::text)::double precision AS "R3",
    ((((((bom_properties.bom -> 'Top'::text) -> 'D-spec'::text) -> '(none)'::text) -> 'Parent segment'::text) -> 'M.B.W.'::text) ->> 'Value'::text)::double precision AS "Mould Base Width (MBW)",
    (((((bom_properties.bom -> 'Top'::text) -> 'D-spec'::text) -> '(none)'::text) -> 'Parent segment'::text) -> 'Cavity type'::text) ->> 'Value'::text AS "Cavity type",
    ((((((bom_properties.bom -> 'Top'::text) -> 'D-spec'::text) -> '(none)'::text) -> 'Master drawing'::text) -> 'F'::text) ->> 'Target'::text)::double precision AS "Tread depth mould",
    ((((((bom_properties.bom -> 'Greentyre'::text) -> 'Processing'::text) -> 'General'::text) -> 'Building machine settings'::text) -> 'Lift belt package'::text) ->> 'Target'::text)::double precision AS "Lift belt package center",
    (((((bom_properties.bom -> 'Top'::text) -> 'D-spec'::text) -> '(none)'::text) -> 'D-Spec (reinforcements)'::text) -> 'Lift percentage shoulder'::text) ->> 'Design Target'::text AS "Lift belt package shoulder"
FROM bom_properties
WITH DATA
;

-- View indexes:
CREATE UNIQUE INDEX sc_lims_dal.pcr_general_part_no_uq       ON sc_lims_dal.mv_pcr_general_information USING btree ("Part no");
CREATE UNIQUE INDEX sc_lims_dal.pcr_general_plant_part_no_uq ON sc_lims_dal.mv_pcr_general_information USING btree ("Plant", "Part no");

--TEST-QUERY
select * 
from sc_lims_dal.mv_pcr_general_information mv
where mv.plant = 'ENS'
;






--***********************************************
--3.sc_lims_dal.mv_pcr_1st_stage_components
--
--Selectie: Tyre, Vulcanized-tyre, Greentyre, Bead.Tread, PreAssembly, Innerliner, Greentyre.ply*.racknumber, 
--
--***********************************************
CREATE MATERIALIZED VIEW sc_lims_dal.mv_pcr_1st_stage_components
TABLESPACE pg_default
AS WITH bom_properties AS (
SELECT ss.part_no
,      ss.revision
,      bh.plant
,      jsonb_build_object('Top', s.properties) || jsonb_object_agg(
                CASE
                    WHEN t.function_path ? '{*.Greentyre}'::lquery[]                          THEN 'Greentyre'::text
                    WHEN t.function_path ? '{*.Pre_Assembly}'::lquery[]                       THEN 'Pre_Assembly'::text
                    WHEN t.function_path ? '{*.Vulcanized_tyre}'::lquery[]                    THEN 'Vulcanized_tyre'::text
                    WHEN t.function_path ? '{*.Bead_apex.Bead.*}'::lquery[]                   THEN 'Bead_apex.Bead'::text
                    WHEN t.function_path ? '{*.Bead_apex|Bead.*}'::lquery[]                   THEN 'Bead_apex'::text
                    WHEN t.function_path ? '{*.Innerliner_assembly|Innerliner.*}'::lquery[]   THEN 'Innerliner_assembly'::text
                    WHEN t.function_path ? '{*.Tyre_vulcanized.*}'::lquery[]                  THEN 'Vulcanized_tyre'::text
                    WHEN t.function_path ? '{*.Sidewall_L|Sidewall|Sidewall_L_R.*}'::lquery[] THEN 'Sidewall_L'::text
                    WHEN t.function_path ? '{*.Belt_1.*}'::lquery[]                           THEN 'Belt_1'::text
                    WHEN t.function_path ? '{*.Belt_2.*}'::lquery[]                           THEN 'Belt_2'::text
                    WHEN t.function_path ? '{*.Ply_1.*}'::lquery[]                            THEN 'Ply_1'::text
                    WHEN t.function_path ? '{*.Ply_2.*}'::lquery[]                            THEN 'Ply_2'::text
                    WHEN t.function_path ? '{*.Tread.*}'::lquery[]                            THEN 'Tread'::text
                    ELSE ''::text
                END ||
                CASE
                    WHEN t.function_path ? '{*.Bead|Bead_apex|Belt_*|Greentyre|Innerliner|Innerliner_assembly|Ply_*|Pre_Assembly|Sidewall|Sidewall_L|Sidewall_L_R|Tread|Vulcanized_tyre|Tyre_vulcanized}'::lquery[] THEN ''::text
                    ELSE '.'::text ||
                    CASE
                        WHEN t.function_path ? '{*.Bead|Belt*|Innerliner|Innerliner_assembly|Ply*|Sidewall*|Tread.*.Compound}'::lquery[] THEN COALESCE(NULLIF((t.keywords #>> '{"Compound application",0}'::text[]) || ' compound'::text, '<Any>'::text), 'Compound'::text)
                        WHEN t.function_path ? '{*.Ply*.*.Fabric}'::lquery[] THEN 'Reinforcement'::text
                        ELSE t.bom_function
                    END
                END
,   (jsonb_build_object('part_no', t.component_part_no, 'revision', t.component_revision, 'alternative', t.alternative, 'preferred', t.preferred) || t.properties) || comp_s.properties)    AS bom
FROM sc_lims_dal.mv_specification_status ss
JOIN sc_lims_dal.mv_specification         s USING (part_no, revision)
JOIN sc_interspec_ens.bom_header         bh USING (part_no, revision)
CROSS JOIN LATERAL sc_lims_dal.fnc_bom_explode(ss.part_no::text
                                             , ss.revision
											 , bh.alternative
											 , bh.plant::text
											 , jsonb_build_object('function_path_query'
											                     , ARRAY['*.Tyre'::text
																       , '*.Tyre.Vulcanized_tyre|Tyre_vulcanized'::text
																	   , '*.Tyre.Vulcanized_tyre|Tyre_vulcanized.Greentyre'::text
																	   , '*.Greentyre.Bead_apex|Innerliner_assembly|Ply*|Sidewall|Sidewall_L|Sidewall_L_R|Tread'::text
																	   , '*.Greentyre.Bead|Innerliner|Ply*|Pre_Assembly|Sidewall|Sidewall_L|Sidewall_L_R|Tread'::text
																	   , '*.Greentyre.Bead_apex|Innerliner_assembly|Sidewall|Sidewall_L|Sidewall_L_R|Tread.*{1}'::text
																	   , '*.Greentyre.Pre_Assembly.*{1,2}'::text
																	   , '*.Greentyre.Bead_apex.Bead.*{1}'::text
																	   , '*.Greentyre.Bead|Innerliner|Racknumber|Sidewall|Sidewall_L|Sidewall_L_R|Tread.*{1}'::text
																	   , '*.Greentyre.Innerliner.Rubberstrip.Rubberstrip'::text
																	   , '*.Greentyre.Ply*.Composite|Racknumber'::text
																	   , '*.Greentyre.Ply*.Composite.Compound|Composite_compound'::text
																	   , '*.Greentyre.Ply*.Racknumber.Compound|Fabric'::text
																	   , '*.Squeegee'::text]
																)
												) t(part_no, revision, component_part_no, component_revision, class3_id, plant, alternative, preferred, keywords, spec_function, level, item_number, bom_function, properties, hierarchy, part_path, function_path, contains_cycle, quantity, total_quantity)
JOIN sc_lims_dal.mv_specification     comp_s ON ( comp_s.part_no::text = t.component_part_no AND comp_s.revision = t.component_revision )
JOIN sc_interspec_ens.class3               c ON c.class = t.class3_id
WHERE ss.status_type::text = 'CURRENT'::text 
AND (ss.status_code::text <> ALL (ARRAY['TEMP CRRNT'::character varying, 'CRRNT QR1'::character varying, 'CRRNT QR2'::character varying]::text[])) 
AND ss.frame_id::text = 'A_PCR'::text 
AND NOT ss.is_trial 
AND bh.preferred = 1::numeric 
AND (  t.function_path ? '{*.!Racknumber}'::lquery[] 
    OR (   t.function_path @ 'Racknumber'::ltxtquery 
       AND (c.sort_desc::text = ANY (ARRAY['TEXTCOMP'::character varying, 'STEELCOMP'::character varying]::text[]))
	   )
    )
GROUP BY ss.part_no
,        ss.revision
,         s.functionkw
,         s.properties
,         bh.plant
)
SELECT bom_properties.part_no AS "Part no"
,      bom_properties.revision AS "Rev"
,      bom_properties.plant AS "Plant"
,   (bom_properties.bom -> 'Innerliner_assembly'::text) ->> 'part_no'::text AS "Innerliner Material"
,   (bom_properties.bom -> 'Innerliner_assembly.Innerliner compound'::text) ->> 'part_no'::text AS "Innerliner Compound"
,   ((((((bom_properties.bom -> 'Innerliner_assembly'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Dimensions SFP'::text) -> 'Width'::text) ->> 'Target'::text)::double precision AS "Innerliner Width"
,   ((((((bom_properties.bom -> 'Innerliner_assembly'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Dimensions SFP'::text) -> 'Gauge'::text) ->> 'Target'::text)::double precision AS "Innerliner Gauge"
,   ((bom_properties.bom -> 'Innerliner_assembly'::text) ->> 'Quantity'::text)::double precision AS "Innerliner Length"
,   ((((((bom_properties.bom -> 'Innerliner_assembly'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Dimensions SFP'::text) -> 'Width technical layer'::text) ->> 'Target'::text)::double precision AS "Technical layer Width"
,   ((((((bom_properties.bom -> 'Innerliner_assembly'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Dimensions SFP'::text) -> 'Gauge technical layer'::text) ->> 'Target'::text)::double precision AS "Technical layer Gauge"
,   ((bom_properties.bom -> 'Innerliner_assembly'::text) ->> 'Quantity'::text)::double precision AS "Technical Layer Length"
,   '- TODO -'::text AS "Squeegee compound"
,   ((((((bom_properties.bom -> 'Innerliner_assembly'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Dimensions SFP'::text) -> 'Width squeegee'::text) ->> 'Target'::text)::double precision AS "Squeegee Width"
,   ((((((bom_properties.bom -> 'Innerliner_assembly'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Dimensions SFP'::text) -> 'Gauge squeegee'::text) ->> 'Target'::text)::double precision AS "Squeegee Gauge"
,   ((((((bom_properties.bom -> 'Innerliner_assembly'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Dimensions SFP'::text) -> 'Squeegee position from centre to outside strip'::text) ->> 'Target'::text)::double precision AS "Squeegee position from centre to outside strip"
,   (bom_properties.bom -> 'Sidewall_L'::text) ->> 'part_no'::text AS "Sidewall"
,   (bom_properties.bom -> 'Sidewall_L.Sidewall compound'::text) ->> 'part_no'::text AS "Sidewall Compound"
,   (bom_properties.bom -> 'Sidewall_L.Rim cushion compound'::text) ->> 'part_no'::text AS "Rim cushion Compound"
,   ((p.extruder -> 'Sidewall_L'::text) -> 0) ->> 'machine'::text AS "SW Extruder 1"
,   (((((p.extruder -> 'Sidewall_L'::text) -> 0) -> 'properties'::text) -> 'Tooling'::text) -> 'Die'::text) ->> 'Value'::text AS "SW Die 1"
,   (((((p.extruder -> 'Sidewall_L'::text) -> 0) -> 'properties'::text) -> 'Tooling'::text) -> 'Preformer'::text) ->> 'Value'::text AS "SW Preformer 1"
,   ((p.extruder -> 'Sidewall_L'::text) -> 1) ->> 'machine'::text AS "SW Extruder 2"
,   (((((p.extruder -> 'Sidewall_L'::text) -> 1) -> 'properties'::text) -> 'Tooling'::text) -> 'Die'::text) ->> 'Value'::text AS "SW Die 2"
,   (((((p.extruder -> 'Sidewall_L'::text) -> 1) -> 'properties'::text) -> 'Tooling'::text) -> 'Preformer'::text) ->> 'Value'::text AS "SW Preformer 2"
,   ((((((bom_properties.bom -> 'Sidewall_L'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Main extrudate dimensions'::text) -> 'Total width'::text) ->> 'Target'::text)::double precision AS "SW Width"
,   ((((((bom_properties.bom -> 'Top'::text) -> 'D-spec'::text) -> '(none)'::text) -> 'D-Spec (Gauges)'::text) -> 'Total gauge @ location G'::text) ->> 'Design Target'::text)::double precision AS "SW gauge at G"
,   ((bom_properties.bom -> 'Sidewall_L'::text) ->> 'Quantity'::text)::double precision AS "SW Length"
,   ((((((bom_properties.bom -> 'Top'::text) -> 'D-spec'::text) -> '(none)'::text) -> 'D-Spec (section)'::text) -> 'Rim cushion lower height from D-Dia'::text) ->> 'Design Target'::text)::double precision AS "Rim cushion transition starting point"
,   ((((((bom_properties.bom -> 'Top'::text) -> 'D-spec'::text) -> '(none)'::text) -> 'D-Spec (section)'::text) -> 'Rim cushion height from D-Dia'::text) ->> 'Design Target'::text)::double precision AS "Rim cushion transition ending point"
,   ((((((bom_properties.bom -> 'Pre_Assembly'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Pre-Assembly properties'::text) -> 'PA width'::text) ->> 'Target'::text)::double precision AS "Pre-Assembly Width"
,   ((((((bom_properties.bom -> 'Pre_Assembly'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Pre-Assembly properties'::text) -> 'PA overlap (sidewall / innerliner)'::text) ->> 'Target'::text)::double precision AS "PA Overlap (SW/IL)"
,   (bom_properties.bom -> 'Ply_1'::text) ->> 'part_no'::text AS "Ply 1 Material"
,   COALESCE(bom_properties.bom -> 'Ply_1.Reinforcement'::text, bom_properties.bom -> 'Ply_1.Composite.Reinforcement'::text) ->> 'part_no'::text AS "Ply 1 Fabric"
,   COALESCE(bom_properties.bom -> 'Ply_1.Carcass compound'::text, bom_properties.bom -> 'Ply_1.Composite.Composite_compound'::text) ->> 'part_no'::text AS "Ply 1 Compound"
,   ((((((bom_properties.bom -> 'Ply_1'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Dimensions SFP'::text) -> 'Angle'::text) ->> 'Target'::text)::double precision AS "Ply 1 Angle"
,   ((((((bom_properties.bom -> 'Ply_1'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Dimensions SFP'::text) -> 'Width'::text) ->> 'Target'::text)::double precision AS "Ply 1 Width"
,   COALESCE((((((bom_properties.bom -> 'Top'::text) -> 'D-spec'::text) -> '(none)'::text) -> 'D-Spec (section)'::text) -> 'Carcass turnup height'::text) ->> 'Design Target'::text, (((((bom_properties.bom -> 'Top'::text) -> 'D-spec'::text) -> '(none)'::text) -> 'D-Spec (section)'::text) -> 'Carcass turnup height'::text) ->> 'Target'::text)::double precision AS "Ply 1 Turn up"
,   (((((COALESCE(bom_properties.bom -> 'Ply_1.Racknumber'::text, bom_properties.bom -> 'Ply_1.Composite'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Properties textile composites'::text) -> 'Calendered material thickness'::text) ->> 'Target'::text)::double precision AS "Ply 1 Gauge"
,   ((bom_properties.bom -> 'Ply_1'::text) ->> 'Quantity'::text)::double precision AS "Ply 1 Length"
,   (bom_properties.bom -> 'Ply_2'::text) ->> 'part_no'::text AS "Ply 2 Material"
,   COALESCE(bom_properties.bom -> 'Ply_2.Reinforcement'::text, bom_properties.bom -> 'Ply_2.Composite.Reinforcement'::text) ->> 'part_no'::text AS "Ply 2 Fabric"
,   COALESCE(bom_properties.bom -> 'Ply_2.Carcass compound'::text, bom_properties.bom -> 'Ply_2.Composite.Composite_compound'::text) ->> 'part_no'::text AS "Ply 2 Compound"
,   ((((((bom_properties.bom -> 'Ply_2'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Dimensions SFP'::text) -> 'Angle'::text) ->> 'Target'::text)::double precision AS "Ply2 Angle"
,   ((((((bom_properties.bom -> 'Ply_2'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Dimensions SFP'::text) -> 'Width'::text) ->> 'Target'::text)::double precision AS "Ply2 Width"
,   COALESCE((((((bom_properties.bom -> 'Top'::text) -> 'D-spec'::text) -> '(none)'::text) -> 'D-Spec (section)'::text) -> 'Carcass 2 turnup height'::text) ->> 'Design Target'::text, (((((bom_properties.bom -> 'Top'::text) -> 'D-spec'::text) -> '(none)'::text) -> 'D-Spec (section)'::text) -> 'Carcass 2 turnup height'::text) ->> 'Target'::text)::double precision AS "Ply 2 Turn up"
,   (((((COALESCE(bom_properties.bom -> 'Ply_2.Racknumber'::text, bom_properties.bom -> 'Ply_2.Composite'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Properties textile composites'::text) -> 'Calendered material thickness'::text) ->> 'Target'::text)::double precision AS "Ply 2 Gauge"
,   ((bom_properties.bom -> 'Ply_2'::text) ->> 'Quantity'::text)::double precision AS "Ply 2 Length"
,   COALESCE(bom_properties.bom -> 'Bead_apex.Bead.Beadwire'::text, bom_properties.bom -> 'Bead_apex.Beadwire'::text) ->> 'part_no'::text AS "Bead wire material"
,   (((((bom_properties.bom -> 'Top'::text) -> 'D-spec'::text) -> '(none)'::text) -> 'Construction type'::text) -> 'Bead bundle production method'::text) ->> 'Value'::text AS "Bead construction"
,   (bom_properties.bom -> 'Bead_apex'::text) ->> 'part_no'::text AS "Bead Code"
,   (bom_properties.bom -> 'Bead_apex.Bead compound'::text) ->> 'part_no'::text AS "Bead Compound"
,   ((((((bom_properties.bom -> 'Bead_apex'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Bead properties'::text) -> 'Turns'::text) ->> 'Target'::text)::integer AS "Bead Turns"
,   ((((((bom_properties.bom -> 'Bead_apex'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Bead properties'::text) -> 'Wires'::text) ->> 'Target'::text)::integer AS "Bead Wires"
,   ((((((bom_properties.bom -> 'Bead_apex'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Bead properties'::text) -> 'Bead inside circumference'::text) ->> 'Target'::text)::double precision AS "Bead Inside Circumference"
,   ((((((bom_properties.bom -> 'Bead_apex'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Bead properties'::text) -> 'Layer thickness'::text) ->> 'Target'::text)::double precision AS "Bead Layer Thickness"
,   '- TODO -'::text AS "Bead development"
,   ((p.extruder -> 'Bead_apex'::text) -> 0) ->> 'machine'::text AS "BD Extruder 1"
,   (((((p.extruder -> 'Bead_apex'::text) -> 0) -> 'properties'::text) -> 'Tooling'::text) -> 'Die'::text) ->> 'Value'::text AS "BD Die 1"
,   (((((p.extruder -> 'Bead_apex'::text) -> 0) -> 'properties'::text) -> 'Bead Apex information'::text) -> 'Bead filler die'::text) ->> 'Value'::text AS "BD Filler Die 1"
,   (((((p.extruder -> 'Bead_apex.Bead'::text) -> 0) -> 'properties'::text) -> 'Bead information'::text) -> 'Forming wheel'::text) ->> 'Value'::text AS "BD Forming wheel 1"
,   ((p.extruder -> 'Bead_apex'::text) -> 1) ->> 'machine'::text AS "BD Extruder 2"
,   (((((p.extruder -> 'Bead_apex'::text) -> 1) -> 'properties'::text) -> 'Tooling'::text) -> 'Die'::text) ->> 'Value'::text AS "BD Die 2"
,   (((((p.extruder -> 'Bead_apex'::text) -> 1) -> 'properties'::text) -> 'Bead Apex information'::text) -> 'Bead filler die'::text) ->> 'Value'::text AS "BD Filler Die 2"
,   (((((p.extruder -> 'Bead_apex.Bead'::text) -> 1) -> 'properties'::text) -> 'Bead information'::text) -> 'Forming wheel'::text) ->> 'Value'::text AS "BD Forming wheel 2"
,   (bom_properties.bom -> 'Bead_apex.Apex compound'::text) ->> 'part_no'::text AS "Apex Compound"
,   ((((((bom_properties.bom -> 'Bead_apex'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Bead apex combination'::text) -> 'Bead apex height (total)'::text) ->> 'Target'::text)::double precision AS "Apex height"
,   ((((((bom_properties.bom -> 'Top'::text) -> 'D-spec'::text) -> '(none)'::text) -> 'D-Spec (reinforcements)'::text) -> 'Filler height from DD'::text) ->> 'Design Target'::text)::double precision AS "Apex Height from DD"
FROM bom_properties
CROSS JOIN LATERAL ( SELECT jsonb_object_agg(x.function, x.properties) AS extruder
                     FROM ( SELECT b.function
                            ,      jsonb_agg(jsonb_build_object('machine', p_1.machine, 'properties', ((bom_properties.bom -> b.function) -> s.key) -> p_1.machine) ORDER BY p_1.machine) AS properties
                            FROM jsonb_object_keys(bom_properties.bom) b(function)
                            JOIN LATERAL jsonb_object_keys(bom_properties.bom -> b.function) s(key) ON s.key ~~* 'processing%'::text
                            CROSS JOIN LATERAL jsonb_object_keys((bom_properties.bom -> b.function) -> s.key) p_1(machine)
                            WHERE b.function = ANY (ARRAY['Sidewall_L'::text, 'Bead_apex'::text, 'Bead_apex.Bead'::text])
                            GROUP BY b.function) x
				    ) p
WITH DATA
;


-- View indexes:
CREATE UNIQUE INDEX sc_lims_dal.pcr_1st_stage_part_no_uq       ON sc_lims_dal.mv_pcr_1st_stage_components USING btree ("Part no");
CREATE UNIQUE INDEX sc_lims_dal.pcr_1st_stage_plant_part_no_uq ON sc_lims_dal.mv_pcr_1st_stage_components USING btree ("Plant", "Part no");

--TEST-QUERY
select * 
from sc_lims_dal.mv_pcr_1st_stage_components mv
where mv.plant = 'ENS'
;






--***********************************************
--4.sc_lims_dal.mv_pcr_2nd_stage_components
--
--Selectie van dimensions, D-spec, tooling  (Only *.Belt_1 + *.Tread)
--
--***********************************************
CREATE MATERIALIZED VIEW sc_lims_dal.mv_pcr_2nd_stage_components
TABLESPACE pg_default
AS WITH bom_properties AS (
SELECT ss.part_no
,      ss.revision
,      bh.plant
,      jsonb_build_object('Top', s.properties) || jsonb_object_agg(((
                CASE
                    WHEN t.function_path ? ARRAY['*.Belt_1.*.Belt_gum.Belt_gum.*'::lquery, '*.Belt_1.*.Rubberstrip.Rubberstrip.*'::lquery] THEN ('Belt_1'::ltree || subpath(t.function_path, GREATEST(index(t.function_path, 'Belt_gum'::ltree), index(t.function_path, 'Rubberstrip'::ltree)) + 1))::text
                    WHEN t.function_path ? ARRAY['*.Belt_1|Belt_2'::lquery, '*.Belt_1|Belt_2.*.Belt_gum|Composite|Racknumber|Rubberstrip'::lquery, '*.Belt_1|Belt_2.*.Belt_gum|Composite|Racknumber|Rubberstrip.Belt_gum_compound|Compound|Steelcord'::lquery, '*.Belt_1|Belt_2.*.Composite|Racknumber.Reinforcement|Composite_compound'::lquery] THEN subpath(t.function_path, GREATEST(index(t.function_path, 'Belt_1'::ltree), index(t.function_path, 'Belt_2'::ltree)))::text
                    WHEN t.function_path ? ARRAY['*.Tread'::lquery, '*.Tread.*'::lquery] THEN subpath(t.function_path, index(t.function_path, 'Tread'::ltree))::text
                    ELSE t.bom_function
                END || '.'::text) || COALESCE(NULLIF(t.keywords #>> '{"Compound application",0}'::text[], '<Any>'::text) || '.'::text, ''::text)) || c.sort_desc::text, (jsonb_build_object('part_no', t.component_part_no, 'revision', t.component_revision, 'alternative', t.alternative, 'preferred', t.preferred) || t.properties) || comp_s.properties) AS bom
FROM sc_lims_dal.mv_specification_status ss
JOIN sc_lims_dal.mv_specification         s USING (part_no, revision)
JOIN sc_interspec_ens.bom_header         bh USING (part_no, revision)
CROSS JOIN LATERAL sc_lims_dal.fnc_bom_explode(ss.part_no::text
                                             , ss.revision
											 , bh.alternative
											 , bh.plant::text
											 , jsonb_build_object('function_path_query'
											                     , ARRAY[ '*.Belt_1|Belt_2|Capply|Capstrip|Greentyre|Tread|Vulcanized_tyre|Tyre_vulcanized'::text
																        , '*.Belt_1|Belt_2.Composite|Racknumber|Steelcord'::text
																		, '*.Belt_1|Belt_2.Racknumber.Compound|Steelcord'::text
																		, '*.Belt_1|Belt_2.Composite.Composite_compound|Reinforcement'::text
																		, '*.Belt_1.Belt_gum'::text
																		, '*.Belt_1.Belt_gum.*{1}'::text
																		, '*.Belt_1.Belt_gum.*.Belt_gum_compound'::text
																		, '*.Belt_1.Rubberstrip'::text
																		, '*.Belt_1.Rubberstrip.*{1}'::text
																		, '*.Belt_1.Rubberstrip.*.!Compound.Compound'::text
																		, '*.Tread.*{1}'::text]
																	)
												) t(part_no, revision, component_part_no, component_revision, class3_id, plant, alternative, preferred, keywords, spec_function, level, item_number, bom_function, properties, hierarchy, part_path, function_path, contains_cycle, quantity, total_quantity)
JOIN sc_lims_dal.mv_specification    comp_s ON comp_s.part_no::text = t.component_part_no AND comp_s.revision = t.component_revision
JOIN sc_interspec_ens.class3              c ON c.class = t.class3_id
WHERE ss.status_type::text = 'CURRENT'::text 
AND (ss.status_code::text <> ALL (ARRAY['TEMP CRRNT'::character varying, 'CRRNT QR1'::character varying, 'CRRNT QR2'::character varying]::text[])) 
AND ss.frame_id::text = 'A_PCR'::text 
AND NOT ss.is_trial 
AND bh.preferred = 1::numeric 
AND (     t.function_path ? '{*.!Racknumber}'::lquery[] 
    OR (   t.function_path @ 'Racknumber'::ltxtquery 
       AND (c.sort_desc::text = ANY (ARRAY['TEXTCOMP'::character varying, 'STEELCOMP'::character varying]::text[]))
	   )
	)
GROUP BY ss.part_no
,        ss.revision
,        s.functionkw
,        s.properties
,        bh.plant
)
SELECT bom_properties.part_no AS "Part no"
,      bom_properties.revision AS "Rev"
,      bom_properties.plant AS "Plant"
,     (bom_properties.bom -> 'Belt_1.ASSEM'::text) ->> 'part_no'::text AS "Belt 1 Material"
,   COALESCE(bom_properties.bom -> 'Belt_1.Composite.Reinforcement.STEELCORD'::text, bom_properties.bom -> 'Belt_1.Racknumber.Steelcord.STEELCORD'::text) ->> 'part_no'::text AS "Belt 1 Wire"
,   ( ( ( ( ( COALESCE(bom_properties.bom -> 'Belt_1.Composite.STEELCOMP'::text, bom_properties.bom -> 'Belt_1.Racknumber.STEELCOMP'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Properties steelcord composites'::text) -> 'Endcount'::text) ->> 'Target'::text)::double precision AS "Belt 1 End Count"
,   COALESCE(bom_properties.bom -> 'Belt_1.Composite.Composite_compound.Steelcord.FM'::text, bom_properties.bom -> 'Belt_1.Racknumber.Compound.Steelcord.FM'::text) ->> 'part_no'::text AS "Belt 1 Compound"
,   ((((((bom_properties.bom -> 'Belt_1.ASSEM'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Dimensions SFP'::text) -> 'Angle'::text) ->> 'Target'::text)::double precision AS "Belt 1 Angle",
    ((((((bom_properties.bom -> 'Belt_1.ASSEM'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Dimensions SFP'::text) -> 'Width'::text) ->> 'Target'::text)::double precision AS "Belt 1 Width",
    (COALESCE(((((bom_properties.bom -> 'Belt_1.Racknumber.STEELCOMP'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Properties steelcord composites'::text) -> 'Calendered material thickness'::text, ((((bom_properties.bom -> 'Belt_1.ASSEM'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Dimensions SFP'::text) -> 'Gauge'::text) ->> 'Target'::text)::double precision AS "Belt 1 Gauge",
    ((bom_properties.bom -> 'Belt_1.ASSEM'::text) ->> 'Quantity'::text)::double precision AS "Belt 1 Length",
    COALESCE(bom_properties.bom -> 'Belt_1.Belt_gum.ASSEM'::text, bom_properties.bom -> 'Belt_1.Rubberstrip.ASSEM'::text) ->> 'part_no'::text AS "Belt Strip type",
    COALESCE(bom_properties.bom -> 'Belt_1.Belt_gum.Belt_gum_compound.Steelcord.FM'::text, bom_properties.bom -> 'Belt_1.Rubberstrip.Compound.Steelcord.FM'::text) ->> 'part_no'::text AS "Belt strip Compound",
    (((((COALESCE(bom_properties.bom -> 'Belt_1.Belt_gum.ASSEM'::text, bom_properties.bom -> 'Belt_1.Rubberstrip.ASSEM'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Dimensions SFP'::text) -> 'Width'::text) ->> 'Target'::text)::double precision AS "Rubber-strip Width",
    ((((((bom_properties.bom -> 'Top'::text) -> 'D-spec'::text) -> '(none)'::text) -> 'D-Spec (reinforcements)'::text) -> 'Location of U-Wrap bottom'::text) ->> 'Target'::text)::double precision AS "Width of U-Wrap Bottom",
    (((((COALESCE(bom_properties.bom -> 'Belt_1.Belt_gum.ASSEM'::text, bom_properties.bom -> 'Belt_1.Rubberstrip.ASSEM'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Dimensions SFP'::text) -> 'Gauge'::text) ->> 'Target'::text)::double precision AS "Rubber-strip Gauge",
    (bom_properties.bom -> 'Belt_2.ASSEM'::text) ->> 'part_no'::text AS "Belt 2 Material",
    COALESCE(bom_properties.bom -> 'Belt_2.Composite.Reinforcement.STEELCORD'::text, bom_properties.bom -> 'Belt_2.Racknumber.Steelcord.STEELCORD'::text) ->> 'part_no'::text AS "Belt 2 Wire",
    (((((COALESCE(bom_properties.bom -> 'Belt_2.Composite.STEELCOMP'::text, bom_properties.bom -> 'Belt_2.Racknumber.STEELCOMP'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Properties steelcord composites'::text) -> 'Endcount'::text) ->> 'Target'::text)::double precision AS "Belt 2 End Count",
    COALESCE(bom_properties.bom -> 'Belt_2.Composite.Composite_compound.Steelcord.FM'::text, bom_properties.bom -> 'Belt_2.Racknumber.Compound.Steelcord.FM'::text) ->> 'part_no'::text AS "Belt 2 Compound",
    ((((((bom_properties.bom -> 'Belt_2.ASSEM'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Dimensions SFP'::text) -> 'Angle'::text) ->> 'Target'::text)::double precision AS "Belt 2 Angle",
    ((((((bom_properties.bom -> 'Belt_2.ASSEM'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Dimensions SFP'::text) -> 'Width'::text) ->> 'Target'::text)::double precision AS "Belt 2 Width",
    (COALESCE(((((bom_properties.bom -> 'Belt_2.Racknumber.STEELCOMP'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Properties steelcord composites'::text) -> 'Calendered material thickness'::text, ((((bom_properties.bom -> 'Belt_2.ASSEM'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Dimensions SFP'::text) -> 'Gauge'::text) ->> 'Target'::text)::double precision AS "Belt 2 Gauge",
    ((bom_properties.bom -> 'Belt_2.ASSEM'::text) ->> 'Quantity'::text)::double precision AS "Belt 2 Length",
    (bom_properties.bom -> 'Capstrip.ASSEM'::text) ->> 'part_no'::text AS "Capply Material",
    (((((bom_properties.bom -> 'Top'::text) -> 'D-spec'::text) -> '(none)'::text) -> 'Construction type'::text) -> 'Cap-strip layup'::text) ->> 'Value'::text AS "No of Capply Layers",
    ((((((bom_properties.bom -> 'Greentyre.PCR_GT'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Greentyre properties'::text) -> 'Total width capstrip'::text) ->> 'Target'::text)::double precision AS "Cap-strip Width",
    ((((((bom_properties.bom -> 'Top'::text) -> 'D-spec'::text) -> '(none)'::text) -> 'D-Spec (reinforcements)'::text) -> 'Width cap-strip overlap 2'::text) ->> 'Value'::text)::double precision AS "Total Width Capply Layer 2",
    ((((((bom_properties.bom -> 'Top'::text) -> 'D-spec'::text) -> '(none)'::text) -> 'D-Spec (reinforcements)'::text) -> 'Width cap-strip overlap 3'::text) ->> 'Value'::text)::double precision AS "Total Width Capply Layer 3",
    COALESCE(bom_properties.bom -> 'Tread.Tread_compound.Tread.FM'::text, bom_properties.bom -> 'Tread.Compound.Tread.FM'::text, bom_properties.bom -> 'Tread.Tread_compound.Apex.FM'::text) ->> 'part_no'::text AS "Tread Cap Compound",
    COALESCE(bom_properties.bom -> 'Tread.Base_1_compound.FM'::text, bom_properties.bom -> 'Tread.Base_1_compound.Base.FM'::text) ->> 'part_no'::text AS "Tread Base1 Compound",
    COALESCE(bom_properties.bom -> 'Tread.Base_2_compound.FM'::text, bom_properties.bom -> 'Tread.Base_2_compound.Base.FM'::text) ->> 'part_no'::text AS "Tread Base2 Compound",
    COALESCE(bom_properties.bom -> 'Tread.Wingtip_compound.Wingtip.FM'::text, bom_properties.bom -> 'Tread.Compound.Wingtip.FM'::text) ->> 'part_no'::text AS "Tread Wing-tip Compound",
    (bom_properties.bom -> 'Tread.EXTR'::text) ->> 'part_no'::text AS "Tread Code",
    ((p.extruder -> 'Tread.EXTR'::text) -> 0) ->> 'machine'::text AS "Tread Extruder 1",
    (((((p.extruder -> 'Tread.EXTR'::text) -> 0) -> 'properties'::text) -> 'Tooling'::text) -> 'Die'::text) ->> 'Value'::text AS "Tread Die 1",
    (((((p.extruder -> 'Tread.EXTR'::text) -> 0) -> 'properties'::text) -> 'Tooling'::text) -> 'Preformer'::text) ->> 'Value'::text AS "Tread Preformer 1",
    ((p.extruder -> 'Tread.EXTR'::text) -> 1) ->> 'machine'::text AS "Tread Extruder 2",
    (((((p.extruder -> 'Tread.EXTR'::text) -> 1) -> 'properties'::text) -> 'Tooling'::text) -> 'Die'::text) ->> 'Value'::text AS "Tread Die 2",
    (((((p.extruder -> 'Tread.EXTR'::text) -> 1) -> 'properties'::text) -> 'Tooling'::text) -> 'Preformer'::text) ->> 'Value'::text AS "Tread Preformer 2",
    tread.maxwidth AS "Tread Width",
    ((((((bom_properties.bom -> 'Tread.EXTR'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Main extrudate dimensions'::text) -> 'Shoulder width'::text) ->> 'Target'::text)::double precision AS "Tread Shoulder Width",
    ((bom_properties.bom -> 'Tread.EXTR'::text) ->> 'Quantity'::text)::double precision AS "Tread Length",
    COALESCE((((((bom_properties.bom -> 'Top'::text) -> 'D-spec'::text) -> '(none)'::text) -> 'D-Spec (section)'::text) -> 'Under tread @ groove 1 SS/NSS'::text) ->> 'Design Target'::text, (((((bom_properties.bom -> 'Top'::text) -> 'D-spec'::text) -> '(none)'::text) -> 'D-Spec (section)'::text) -> 'Under tread @ groove 1 SS/NSS'::text) ->> 'Target'::text)::double precision AS "Under-tread Gauge",
    COALESCE((((((bom_properties.bom -> 'Top'::text) -> 'D-spec'::text) -> '(none)'::text) -> 'D-Spec (section)'::text) -> 'Under tread @ M'::text) ->> 'Design Target'::text, (((((bom_properties.bom -> 'Top'::text) -> 'D-spec'::text) -> '(none)'::text) -> 'D-Spec (section)'::text) -> 'Under tread @ M'::text) ->> 'Target'::text)::double precision AS "Under-tread Gauge @ M",
    COALESCE((((((bom_properties.bom -> 'Top'::text) -> 'D-spec'::text) -> '(none)'::text) -> 'D-Spec (section)'::text) -> 'Base CL'::text) ->> 'Design Target'::text, (((((bom_properties.bom -> 'Top'::text) -> 'D-spec'::text) -> '(none)'::text) -> 'D-Spec (section)'::text) -> 'Undertread (CL) design'::text) ->> 'Target'::text, (((((bom_properties.bom -> 'Top'::text) -> 'D-spec'::text) -> '(none)'::text) -> 'D-Spec (section)'::text) -> 'Base CL'::text) ->> 'Target'::text)::double precision AS "Under-tread Gauge @ CL"
FROM bom_properties
CROSS JOIN LATERAL ( SELECT max(((((((bom_properties.bom -> 'Tread.EXTR'::text) -> 'SPPL'::text) -> '(none)'::text) -> 'Coordinates'::text) -> sppl.coord) ->> 'x'::text)::double precision) AS maxwidth
                     FROM jsonb_object_keys((((bom_properties.bom -> 'Tread.EXTR'::text) -> 'SPPL'::text) -> '(none)'::text) -> 'Coordinates'::text) sppl(coord)) tread
CROSS JOIN LATERAL ( SELECT jsonb_build_object('Tread.EXTR', jsonb_agg(jsonb_build_object('machine', p_1.machine, 'properties', ((bom_properties.bom -> 'Tread.EXTR'::text) -> s.key) -> p_1.machine) ORDER BY p_1.machine)) AS extruder
                     FROM jsonb_object_keys(bom_properties.bom -> 'Tread.EXTR'::text) s(key)
                     CROSS JOIN LATERAL jsonb_object_keys((bom_properties.bom -> 'Tread.EXTR'::text) -> s.key) p_1(machine)
                     WHERE s.key ~~* 'processing%'::text AND p_1.machine <> 'General'::text
				   ) p
WITH DATA
;

-- View indexes:
CREATE UNIQUE INDEX sc_lims_dal.pcr_2nd_stage_part_no_uq       ON sc_lims_dal.mv_pcr_2nd_stage_components USING btree ("Part no");
CREATE UNIQUE INDEX sc_lims_dal.pcr_2nd_stage_plant_part_no_uq ON sc_lims_dal.mv_pcr_2nd_stage_components USING btree ("Plant", "Part no");


--TEST-QUERY
select * 
from sc_lims_dal.mv_pcr_2nd_stage_components mv
where mv.plant = 'ENS'
;




--einde script




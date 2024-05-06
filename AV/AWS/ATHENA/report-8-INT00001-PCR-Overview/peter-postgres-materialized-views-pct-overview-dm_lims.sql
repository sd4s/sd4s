--POSTGRES-PCR-OVERVIEW MATERIALIZED-VIEWS
--lateral-views: https://oracle-base.com/articles/12c/lateral-inline-views-cross-apply-and-outer-apply-joins-12cr1#lateral-inline-views
--


--REQUEST-CODE: KST2240053T  / 23.673.KST

--*************************************************************************
--*************************************************************************
--TOP-LEVEL-MATERIALIZED-VIEWS USED IN REPORTING
--*************************************************************************
--*************************************************************************
--TIP: table in util_interspec-schema are materialized-views !!!!!!!!!
--     table in rd_interspec_webfocus are source-tables interspec !!!!!!!!!!
--

CREATE MATERIALIZED VIEW dm_lims."PCR Overview"
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
FROM util_interspec.specification_status ss
JOIN util_interspec.specification       s_1 USING (part_no, revision)
JOIN rd_interspec_webfocus.bom_header    bh USING (part_no, revision)
CROSS JOIN LATERAL util_interspec.bom_explode(ss.part_no::text, ss.revision, bh.alternative, bh.plant::text, jsonb_build_object('function_path_query', '{
			*.Bead|Bead_apex|Belt*|Capply|Capstrip|Greentyre|Innerliner|Innerliner_assembly|Pre_Assembly|Ply*|Rubberstrip|Sidewall*|Tread|Tyre|Vulcanized_tyre|Tyre_vulcanized
		  ,	*.Tread.Compound|Tread_compound
		  ,	*.Capstrip.Capply
		  , *.Ply*|Belt*.Racknumber|Composite
		  }')) t_1(part_no, revision, component_part_no, component_revision, class3_id, plant, alternative, preferred, keywords, spec_function, level, item_number, bom_function, properties, hierarchy, part_path, function_path, contains_cycle, quantity, total_quantity)
JOIN util_interspec.specification    comp_s ON comp_s.part_no::text = t_1.component_part_no AND comp_s.revision = t_1.component_revision
JOIN rd_interspec_webfocus.class3         c ON c.class = t_1.class3_id
WHERE ss.status_type::text = 'CURRENT'::text 
AND (ss.status_code::text <> ALL (ARRAY['TEMP CRRNT'::character varying, 'CRRNT QR1'::character varying, 'CRRNT QR2'::character varying]::text[])) 
AND ss.frame_id::text = 'A_PCR'::text 
AND NOT ss.is_trial 
AND bh.preferred = 1::numeric 
AND (   t_1.function_path ? '{*.!Racknumber}'::lquery[] 
    OR  t_1.function_path @ 'Racknumber'::ltxtquery 
	AND (c.sort_desc::text = ANY (ARRAY['TEXTCOMP'::character varying, 'STEELCOMP'::character varying]::text[])   )
    )
GROUP BY ss.part_no, ss.revision, s_1.functionkw, s_1.properties, bh.plant
)
SELECT bom_properties.part_no  AS "Part no."
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
    COALESCE((((((bom_properties.bom -> 'Top'::text) -> 'D-spec'::text) -> '(none)'::text) -> 'D-Spec (section)'::text) -> 'Base CL'::text) ->> 'Target'::text, (((((bom_properties.bom -> 'Top'::text) -> 'D-spec'::text) -> '(none)'::text) -> 'D-Spec (section)'::text) -> 'Base CL'::text) ->> 'Design Target'::text)::double precision AS "Tread base thickness",
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
CREATE UNIQUE INDEX pcr_overview_part_no_uq ON dm_lims."PCR Overview" USING btree ("Part no.");
CREATE UNIQUE INDEX pcr_overview_plant_part_no_uq ON dm_lims."PCR Overview" USING btree ("Plant", "Part no.");




CREATE MATERIALIZED VIEW dm_lims."PCR General information"
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
FROM util_interspec.specification_status ss
JOIN util_interspec.specification s USING (part_no, revision)
JOIN rd_interspec_webfocus.bom_header bh USING (part_no, revision)
CROSS JOIN LATERAL util_interspec.bom_explode(ss.part_no::text, ss.revision, bh.alternative, bh.plant::text, jsonb_build_object('function_path_query', '{
			*.Greentyre|Tyre|Vulcanized_tyre|Tyre_vulcanized
		  }')) t(part_no, revision, component_part_no, component_revision, class3_id, plant, alternative, preferred, keywords, spec_function, level, item_number, bom_function, properties, hierarchy, part_path, function_path, contains_cycle, quantity, total_quantity)
JOIN util_interspec.specification comp_s ON comp_s.part_no::text = t.component_part_no AND comp_s.revision = t.component_revision
JOIN rd_interspec_webfocus.class3 c ON c.class = t.class3_id
WHERE ss.status_type::text = 'CURRENT'::text AND (ss.status_code::text <> ALL (ARRAY['TEMP CRRNT'::character varying, 'CRRNT QR1'::character varying, 'CRRNT QR2'::character varying]::text[])) AND ss.frame_id::text = 'A_PCR'::text AND NOT ss.is_trial AND bh.preferred = 1::numeric
GROUP BY ss.part_no, ss.revision, s.functionkw, s.properties, bh.plant
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
CREATE UNIQUE INDEX pcr_general_part_no_uq ON dm_lims."PCR General information" USING btree ("Part no");
CREATE UNIQUE INDEX pcr_general_plant_part_no_uq ON dm_lims."PCR General information" USING btree ("Plant", "Part no");



CREATE MATERIALIZED VIEW dm_lims."PCR 1st stage components"
TABLESPACE pg_default
AS WITH bom_properties AS (
SELECT ss.part_no
,      ss.revision
,      bh.plant
,      jsonb_build_object('Top', s.properties) || jsonb_object_agg(
                CASE
                    WHEN t.function_path ? '{*.Greentyre}'::lquery[] THEN 'Greentyre'::text
                    WHEN t.function_path ? '{*.Pre_Assembly}'::lquery[] THEN 'Pre_Assembly'::text
                    WHEN t.function_path ? '{*.Vulcanized_tyre}'::lquery[] THEN 'Vulcanized_tyre'::text
                    WHEN t.function_path ? '{*.Bead_apex.Bead.*}'::lquery[] THEN 'Bead_apex.Bead'::text
                    WHEN t.function_path ? '{*.Bead_apex|Bead.*}'::lquery[] THEN 'Bead_apex'::text
                    WHEN t.function_path ? '{*.Innerliner_assembly|Innerliner.*}'::lquery[] THEN 'Innerliner_assembly'::text
                    WHEN t.function_path ? '{*.Tyre_vulcanized.*}'::lquery[] THEN 'Vulcanized_tyre'::text
                    WHEN t.function_path ? '{*.Sidewall_L|Sidewall|Sidewall_L_R.*}'::lquery[] THEN 'Sidewall_L'::text
                    WHEN t.function_path ? '{*.Belt_1.*}'::lquery[] THEN 'Belt_1'::text
                    WHEN t.function_path ? '{*.Belt_2.*}'::lquery[] THEN 'Belt_2'::text
                    WHEN t.function_path ? '{*.Ply_1.*}'::lquery[] THEN 'Ply_1'::text
                    WHEN t.function_path ? '{*.Ply_2.*}'::lquery[] THEN 'Ply_2'::text
                    WHEN t.function_path ? '{*.Tread.*}'::lquery[] THEN 'Tread'::text
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
,   (jsonb_build_object('part_no', t.component_part_no, 'revision', t.component_revision, 'alternative', t.alternative, 'preferred', t.preferred) || t.properties) || comp_s.properties) AS bom
FROM util_interspec.specification_status ss
JOIN util_interspec.specification         s USING (part_no, revision)
JOIN rd_interspec_webfocus.bom_header    bh USING (part_no, revision)
CROSS JOIN LATERAL util_interspec.bom_explode(ss.part_no::text, ss.revision, bh.alternative, bh.plant::text, jsonb_build_object('function_path_query', ARRAY['*.Tyre'::text, '*.Tyre.Vulcanized_tyre|Tyre_vulcanized'::text, '*.Tyre.Vulcanized_tyre|Tyre_vulcanized.Greentyre'::text, '*.Greentyre.Bead_apex|Innerliner_assembly|Ply*|Sidewall|Sidewall_L|Sidewall_L_R|Tread'::text, '*.Greentyre.Bead|Innerliner|Ply*|Pre_Assembly|Sidewall|Sidewall_L|Sidewall_L_R|Tread'::text, '*.Greentyre.Bead_apex|Innerliner_assembly|Sidewall|Sidewall_L|Sidewall_L_R|Tread.*{1}'::text, '*.Greentyre.Pre_Assembly.*{1,2}'::text, '*.Greentyre.Bead_apex.Bead.*{1}'::text, '*.Greentyre.Bead|Innerliner|Racknumber|Sidewall|Sidewall_L|Sidewall_L_R|Tread.*{1}'::text, '*.Greentyre.Innerliner.Rubberstrip.Rubberstrip'::text, '*.Greentyre.Ply*.Composite|Racknumber'::text, '*.Greentyre.Ply*.Composite.Compound|Composite_compound'::text, '*.Greentyre.Ply*.Racknumber.Compound|Fabric'::text, '*.Squeegee'::text])) t(part_no, revision, component_part_no, component_revision, class3_id, plant, alternative, preferred, keywords, spec_function, level, item_number, bom_function, properties, hierarchy, part_path, function_path, contains_cycle, quantity, total_quantity)
JOIN util_interspec.specification     comp_s ON ( comp_s.part_no::text = t.component_part_no AND comp_s.revision = t.component_revision )
JOIN rd_interspec_webfocus.class3          c ON c.class = t.class3_id
WHERE ss.status_type::text = 'CURRENT'::text 
AND (ss.status_code::text <> ALL (ARRAY['TEMP CRRNT'::character varying, 'CRRNT QR1'::character varying, 'CRRNT QR2'::character varying]::text[])) 
AND ss.frame_id::text = 'A_PCR'::text 
AND NOT ss.is_trial 
AND bh.preferred = 1::numeric 
AND (  t.function_path ? '{*.!Racknumber}'::lquery[] 
    OR t.function_path @ 'Racknumber'::ltxtquery 
    AND (c.sort_desc::text = ANY (ARRAY['TEXTCOMP'::character varying, 'STEELCOMP'::character varying]::text[]))
    )
GROUP BY ss.part_no, ss.revision, s.functionkw, s.properties, bh.plant
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
CREATE UNIQUE INDEX pcr_1st_stage_part_no_uq ON dm_lims."PCR 1st stage components" USING btree ("Part no");
CREATE UNIQUE INDEX pcr_1st_stage_plant_part_no_uq ON dm_lims."PCR 1st stage components" USING btree ("Plant", "Part no");





CREATE MATERIALIZED VIEW dm_lims."PCR 2nd stage components"
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
FROM util_interspec.specification_status ss
JOIN util_interspec.specification s USING (part_no, revision)
JOIN rd_interspec_webfocus.bom_header bh USING (part_no, revision)
CROSS JOIN LATERAL util_interspec.bom_explode(ss.part_no::text, ss.revision, bh.alternative, bh.plant::text, jsonb_build_object('function_path_query', ARRAY['*.Belt_1|Belt_2|Capply|Capstrip|Greentyre|Tread|Vulcanized_tyre|Tyre_vulcanized'::text, '*.Belt_1|Belt_2.Composite|Racknumber|Steelcord'::text, '*.Belt_1|Belt_2.Racknumber.Compound|Steelcord'::text, '*.Belt_1|Belt_2.Composite.Composite_compound|Reinforcement'::text, '*.Belt_1.Belt_gum'::text, '*.Belt_1.Belt_gum.*{1}'::text, '*.Belt_1.Belt_gum.*.Belt_gum_compound'::text, '*.Belt_1.Rubberstrip'::text, '*.Belt_1.Rubberstrip.*{1}'::text, '*.Belt_1.Rubberstrip.*.!Compound.Compound'::text, '*.Tread.*{1}'::text])) t(part_no, revision, component_part_no, component_revision, class3_id, plant, alternative, preferred, keywords, spec_function, level, item_number, bom_function, properties, hierarchy, part_path, function_path, contains_cycle, quantity, total_quantity)
JOIN util_interspec.specification comp_s ON comp_s.part_no::text = t.component_part_no AND comp_s.revision = t.component_revision
JOIN rd_interspec_webfocus.class3 c ON c.class = t.class3_id
WHERE ss.status_type::text = 'CURRENT'::text AND (ss.status_code::text <> ALL (ARRAY['TEMP CRRNT'::character varying, 'CRRNT QR1'::character varying, 'CRRNT QR2'::character varying]::text[])) AND ss.frame_id::text = 'A_PCR'::text AND NOT ss.is_trial AND bh.preferred = 1::numeric AND (t.function_path ? '{*.!Racknumber}'::lquery[] OR t.function_path @ 'Racknumber'::ltxtquery AND (c.sort_desc::text = ANY (ARRAY['TEXTCOMP'::character varying, 'STEELCOMP'::character varying]::text[])))
GROUP BY ss.part_no, ss.revision, s.functionkw, s.properties, bh.plant
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
CREATE UNIQUE INDEX pcr_2nd_stage_part_no_uq ON dm_lims."PCR 2nd stage components" USING btree ("Part no");
CREATE UNIQUE INDEX pcr_2nd_stage_plant_part_no_uq ON dm_lims."PCR 2nd stage components" USING btree ("Plant", "Part no");


/*
EF_H165/80R14CLS	19	ENS
{"Top": {"PAC": {"(none)": {"PAC indoor testing": {"Tyre weight": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "kg", "- tol": null, "Legal": null, "Result": null, "Target": 7.54100000000000037, "Apollo test code": "TT520AX", "Approval based upon": null}
                                                 , "BIS Endurance": {"LSL": 34, "LWL": null, "USL": null, "UWL": null, "UoM": "hours", "- tol": null, "Legal": 34, "Result": null, "Target": null, "Apollo test code": "TT741XX", "Approval based upon": null}
												 , "CCC Endurance": {"LSL": 34, "LWL": null, "USL": null, "UWL": null, "UoM": "hours", "- tol": null, "Legal": 34, "Result": null, "Target": null, "Apollo test code": "TT743XX", "Approval based upon": null}
												 , "GSO Endurance": {"LSL": 34, "LWL": null, "USL": null, "UWL": null, "UoM": "hours", "- tol": null, "Legal": 34, "Result": null, "Target": null, "Apollo test code": "TT742XX", "Approval based upon": null}
												 , "SNI Endurance": {"LSL": 34, "LWL": null, "USL": null, "UWL": null, "UoM": "hours", "- tol": null, "Legal": 34, "Result": null, "Target": null, "Apollo test code": "TT744XX", "Approval based upon": null}
												 , "Tyre diameter": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "- tol": null, "Legal": null, "Result": null, "Target": null, "Apollo test code": "TT520AX", "Approval based upon": null}
												 , "CCC High Speed": {"LSL": 60, "LWL": null, "USL": null, "UWL": null, "UoM": "min", "- tol": null, "Legal": 60, "Result": null, "Target": null, "Apollo test code": "TT735IX", "Approval based upon": null}
												 , "SNI High Speed": {"LSL": 60, "LWL": null, "USL": null, "UWL": null, "UoM": "min", "- tol": null, "Legal": 60, "Result": null, "Target": null, "Apollo test code": "TT735KX", "Approval based upon": null}
												 , "FMVSS Endurance": {"LSL": 34, "LWL": null, "USL": null, "UWL": null, "UoM": "hours", "- tol": null, "Legal": 34, "Result": null, "Target": 34, "Apollo test code": "TT746XX", "Approval based upon": null}
												 , "FMVSS High Speed": {"LSL": 390, "LWL": null, "USL": null, "UWL": null, "UoM": "min", "- tol": null, "Legal": 330, "Result": null, "Target": 330, "Apollo test code": "TT780XX", "Approval based upon": null}
												 , "Tyre width (max)": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "- tol": null, "Legal": null, "Result": null, "Target": null, "Apollo test code": "TT520AX", "Approval based upon": null}
												 , "BIS Tyre Strength": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "Ncm", "- tol": null, "Legal": null, "Result": null, "Target": null, "Apollo test code": "TT763AA", "Approval based upon": null}
												 , "CCC Tyre Strength": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "Ncm", "- tol": null, "Legal": null, "Result": null, "Target": null, "Apollo test code": "TT762XX", "Approval based upon": null}
												 , "SNI Tyre Strength": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "Ncm", "- tol": null, "Legal": null, "Result": null, "Target": null, "Apollo test code": "TT764XX", "Approval based upon": null}
												 , "BIS Bead Unseating": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "N", "- tol": null, "Legal": null, "Result": null, "Target": null, "Apollo test code": "TT711AC", "Approval based upon": null}
												 , "CCC Bead Unseating": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "N", "- tol": null, "Legal": null, "Result": null, "Target": null, "Apollo test code": "TT711AE", "Approval based upon": null}
												 , "GSO Bead Unseating": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "N", "- tol": null, "Legal": null, "Result": null, "Target": null, "Apollo test code": "TT711AD", "Approval based upon": null}
												 , "SNI Bead Unseating": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "N", "- tol": null, "Legal": null, "Result": null, "Target": null, "Apollo test code": "TT711AE", "Approval based upon": null}
												 , "FMVSS Tyre Strength": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "Ncm", "- tol": null, "Legal": null, "Result": null, "Target": null, "Apollo test code": "TT761AX", "Approval based upon": null}
												 , "Cut section analysis": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": null, "- tol": null, "Legal": null, "Result": null, "Target": null, "Apollo test code": "TT501XX", "Approval based upon": null}
												 , "FMVSS Bead Unseating": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "N", "- tol": null, "Legal": null, "Result": null, "Target": null, "Apollo test code": "TT711AX", "Approval based upon": null}
												 , "Tyre width (average)": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "- tol": null, "Legal": null, "Result": null, "Target": null, "Apollo test code": "TT520AX", "Approval based upon": null}
												 , "Apollo Burst pressure": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "bar", "- tol": null, "Legal": null, "Result": null, "Target": null, "Apollo test code": "TT455AB", "Approval based upon": null}
												 , "BIS Tyre Strength max": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "Ncm", "- tol": null, "Legal": null, "Result": null, "Target": null, "Apollo test code": "TT763AA", "Approval based upon": null}
												 , "CCC Tyre Strength max": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "Ncm", "- tol": null, "Legal": null, "Result": null, "Target": null, "Apollo test code": "TT762XX", "Approval based upon": null}
												 , "SNI Tyre Strength max": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "Ncm", "- tol": null, "Legal": null, "Result": null, "Target": null, "Apollo test code": "TT764XX", "Approval based upon": null}
												 , "FMVSS Tyre Strength max": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "Ncm", "- tol": null, "Legal": null, "Result": null, "Target": null, "Apollo test code": "TT761AX", "Approval based upon": null}
												 , "GSO Tyre Strength (PET)": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "Ncm", "- tol": null, "Legal": null, "Result": null, "Target": null, "Apollo test code": "TT762XX", "Approval based upon": null}
												 , "BIS Endurance (failures)": {"LSL": null, "LWL": null, "USL": 0, "UWL": null, "UoM": "pcs", "- tol": null, "Legal": 0, "Result": null, "Target": null, "Apollo test code": "TT741XX", "Approval based upon": null}
												 , "CCC Endurance (failures)": {"LSL": null, "LWL": null, "USL": 0, "UWL": null, "UoM": "pcs", "- tol": null, "Legal": 0, "Result": null, "Target": null, "Apollo test code": "TT743XX", "Approval based upon": null}
												 , "GSO Endurance (failures)": {"LSL": null, "LWL": null, "USL": 0, "UWL": null, "UoM": "pcs", "- tol": null, "Legal": 0, "Result": null, "Target": null, "Apollo test code": "TT742XX", "Approval based upon": null}
												 , "SNI Endurance (failures)": {"LSL": null, "LWL": null, "USL": 0, "UWL": null, "UoM": "pcs", "- tol": null, "Legal": 0, "Result": null, "Target": null, "Apollo test code": "TT744XX", "Approval based upon": null}
												 , "CCC High Speed (failures)": {"LSL": null, "LWL": null, "USL": 0, "UWL": null, "UoM": "pcs", "- tol": null, "Legal": 0, "Result": null, "Target": null, "Apollo test code": "TT735IX", "Approval based upon": null}
												 , "GSO Tyre Strength (Rayon)": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "Ncm", "- tol": null, "Legal": null, "Result": null, "Target": null, "Apollo test code": "TT762XX", "Approval based upon": null}
												 , "SNI High Speed (failures)": {"LSL": null, "LWL": null, "USL": 0, "UWL": null, "UoM": "pcs", "- tol": null, "Legal": 0, "Result": null, "Target": null, "Apollo test code": "TT735KX", "Approval based upon": null}
												 , "CCC Endurance low pressure": {"LSL": 1.5, "LWL": null, "USL": null, "UWL": null, "UoM": "hours", "- tol": null, "Legal": 1.5, "Result": null, "Target": null, "Apollo test code": "TT743XX", "Approval based upon": null}
												 , "FMVSS Endurance (failures)": {"LSL": null, "LWL": null, "USL": 0, "UWL": null, "UoM": "pcs", "- tol": null, "Legal": 0, "Result": null, "Target": 0, "Apollo test code": "TT746XX", "Approval based upon": null}
												 , "GSO High Speed Performance": {"LSL": 60, "LWL": null, "USL": null, "UWL": null, "UoM": "min", "- tol": null, "Legal": 60, "Result": null, "Target": null, "Apollo test code": "TT735FX", "Approval based upon": null}
												 , "SNI Endurance low pressure": {"LSL": 1.5, "LWL": null, "USL": null, "UWL": null, "UoM": "hours", "- tol": null, "Legal": 1.5, "Result": null, "Target": null, "Apollo test code": "TT744XX", "Approval based upon": null}
												 , "Tread Wear Indicator (TWI)": {"LSL": 1.60000000000000009, "LWL": null, "USL": 2.10000000000000009, "UWL": null, "UoM": "mm", "- tol": null, "Legal": 1.60000000000000009, "Result": null, "Target": null, "Apollo test code": "TT520AX", "Approval based upon": null}
												 , "FMVSS High Speed (failures)": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "pcs", "- tol": null, "Legal": 0, "Result": null, "Target": 0, "Apollo test code": "TT780XX", "Approval based upon": null}
												 , "GSO Tyre Strength max (PET)": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "Ncm", "- tol": null, "Legal": null, "Result": null, "Target": null, "Apollo test code": "TT762XX", "Approval based upon": null}
												 , "Apollo Electrical Resistance": {"LSL": null, "LWL": null, "USL": 10000, "UWL": null, "UoM": "MOhm", "- tol": null, "Legal": null, "Result": null, "Target": 100, "Apollo test code": "TT360AA", "Approval based upon": null}
												 , "FMVSS Endurance low pressure ": {"LSL": 3, "LWL": null, "USL": null, "UWL": null, "UoM": "hours", "- tol": null, "Legal": 1.5, "Result": null, "Target": 1.5, "Apollo test code": "TT746XX", "Approval based upon": null}
												 , "GSO Tyre Strength max (Rayon)": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "Ncm", "- tol": null, "Legal": null, "Result": null, "Target": null, "Apollo test code": "TT762XX", "Approval based upon": null}
												 , "CCC Endurance (pressure check)": {"LSL": 95, "LWL": null, "USL": null, "UWL": null, "UoM": "%", "- tol": null, "Legal": 95, "Result": null, "Target": null, "Apollo test code": "TT743XX", "Approval based upon": null}
												 , "GSO Endurance (pressure check)": {"LSL": 100, "LWL": null, "USL": null, "UWL": null, "UoM": "%", "- tol": null, "Legal": 100, "Result": null, "Target": null, "Apollo test code": "TT742XX", "Approval based upon": null}
												 , "BIS Load/Speed performance test": {"LSL": 60, "LWL": null, "USL": null, "UWL": null, "UoM": "min", "- tol": null, "Legal": 60, "Result": null, "Target": null, "Apollo test code": "TT520AX", "Approval based upon": null}
												 , "CCC High Speed (pressure check)": {"LSL": 95, "LWL": null, "USL": null, "UWL": null, "UoM": "%", "- tol": null, "Legal": 95, "Result": null, "Target": null, "Apollo test code": "TT735IX", "Approval based upon": null}
												 , "ECE Rolling resistance Labeling": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "kg/ton", "- tol": null, "Legal": null, "Result": null, "Target": null, "Apollo test code": "TT351AA", "Approval based upon": null}
												 , "Apollo Long term endurance (PCR)": {"LSL": 16800, "LWL": null, "USL": null, "UWL": null, "UoM": "km", "- tol": null, "Legal": null, "Result": null, "Target": null, "Apollo test code": "TT749AX", "Approval based upon": null}
												 , "FMVSS Endurance (pressure check)": {"LSL": 100, "LWL": null, "USL": null, "UWL": null, "UoM": "%", "- tol": null, "Legal": 95, "Result": null, "Target": null, "Apollo test code": "TT746XX", "Approval based upon": null}
												 , "FMVSS High Speed (pressure check)": {"LSL": 100, "LWL": null, "USL": null, "UWL": null, "UoM": "%", "- tol": null, "Legal": 95, "Result": null, "Target": null, "Apollo test code": "TT780XX", "Approval based upon": null}
												 , "Apollo Bead comp, minimum at +0.38": {"LSL": 230, "LWL": null, "USL": 550, "UWL": null, "UoM": "daN", "- tol": null, "Legal": null, "Result": null, "Target": null, "Apollo test code": "TT457A", "Approval based upon": null}
												 , "Apollo Bead comp, minimum at -0.29": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "daN", "- tol": null, "Legal": null, "Result": null, "Target": null, "Apollo test code": "TT457A", "Approval based upon": null}
												 , "Apollo High speed 2 degrees Camber": {"LSL": 75, "LWL": null, "USL": null, "UWL": null, "UoM": "min", "- tol": null, "Legal": 75, "Result": null, "Target": 80, "Apollo test code": "TT731XX", "Approval based upon": null}
												 , "Apollo Long term endurance C2 (Belt)": {"LSL": 71, "LWL": null, "USL": null, "UWL": null, "UoM": "hours", "- tol": null, "Legal": null, "Result": null, "Target": null, "Apollo test code": "TT772XX", "Approval based upon": null}
												 , "BIS Endurance (diameter differences)": {"LSL": null, "LWL": null, "USL": 3.5, "UWL": null, "UoM": "%", "- tol": null, "Legal": 3.5, "Result": null, "Target": null, "Apollo test code": "TT741XX", "Approval based upon": null}
												 , "SNI High Speed (diameter difference)": {"LSL": null, "LWL": null, "USL": 3.5, "UWL": null, "UoM": "%", "- tol": null, "Legal": 3.5, "Result": null, "Target": null, "Apollo test code": "TT735KX", "Approval based upon": null}
												 , "Apollo Long term endurance (failures)": {"LSL": null, "LWL": null, "USL": 0, "UWL": null, "UoM": null, "- tol": null, "Legal": null, "Result": null, "Target": null, "Apollo test code": "TT749AX", "Approval based upon": null}
												 , "CCC Endurance low pressure (failures)": {"LSL": null, "LWL": null, "USL": 0, "UWL": null, "UoM": "pcs", "- tol": null, "Legal": 0, "Result": null, "Target": null, "Apollo test code": "TT743XX", "Approval based upon": null}
												 , "GSO High Speed Performance (failures)": {"LSL": null, "LWL": null, "USL": 0, "UWL": null, "UoM": "pcs", "- tol": null, "Legal": 0, "Result": null, "Target": null, "Apollo test code": "TT735FX", "Approval based upon": null}
												 , "SNI Endurance low pressure (failures)": {"LSL": null, "LWL": null, "USL": 0, "UWL": null, "UoM": "pcs", "- tol": null, "Legal": 0, "Result": null, "Target": null, "Apollo test code": "TT744XX", "Approval based upon": null}
												 , "UTQG High Speed Temperature Resistance": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "min", "- tol": null, "Legal": 510, "Result": null, "Target": 510, "Apollo test code": "TT781XX", "Approval based upon": null}
												 , "FMVSS Endurance low pressure (failures)": {"LSL": null, "LWL": null, "USL": 0, "UWL": null, "UoM": "pcs", "- tol": null, "Legal": 0, "Result": null, "Target": 0, "Apollo test code": "TT746XX", "Approval based upon": null}
												 , "Apollo Long term endurance C2 (failures)": {"LSL": null, "LWL": null, "USL": 0, "UWL": null, "UoM": null, "- tol": null, "Legal": null, "Result": null, "Target": null, "Apollo test code": "TT772XX", "Approval based upon": null}
												 , "ECE / Inmetro Load speed performance test": {"LSL": 60, "LWL": null, "USL": null, "UWL": null, "UoM": "min", "- tol": null, "Legal": 60, "Result": null, "Target": null, "Apollo test code": "TT735XX", "Approval based upon": null}
												 , "BIS Load/Speed performance test (failures)": {"LSL": null, "LWL": null, "USL": 0, "UWL": null, "UoM": "pcs", "- tol": null, "Legal": 0, "Result": null, "Target": null, "Apollo test code": "TT520AX", "Approval based upon": null}
												 , "CCC Endurance low pressure (pressure check)": {"LSL": 95, "LWL": null, "USL": null, "UWL": null, "UoM": "%", "- tol": null, "Legal": 95, "Result": null, "Target": null, "Apollo test code": "TT743XX", "Approval based upon": null}
												 , "GSO High Speed Performance (pressure check)": {"LSL": 100, "LWL": null, "USL": null, "UWL": null, "UoM": "%", "- tol": null, "Legal": 100, "Result": null, "Target": null, "Apollo test code": "TT735FX", "Approval based upon": null}
												 , "FMVSS Endurance low pressure (pressure check)": {"LSL": 100, "LWL": null, "USL": null, "UWL": null, "UoM": "%", "- tol": null, "Legal": 95, "Result": null, "Target": null, "Apollo test code": "TT746XX", "Approval based upon": null}
												 , "Apollo High Speed (extended version of ECE R30)": {"LSL": 80, "LWL": null, "USL": null, "UWL": null, "UoM": "min", "- tol": null, "Legal": 60, "Result": "90", "Target": 85, "Apollo test code": "TT729XX", "Approval based upon": "EWE2044060T"}
												 , "ECE / Inmetro Load speed performance test (failures)": {"LSL": null, "LWL": null, "USL": 0, "UWL": null, "UoM": null, "- tol": null, "Legal": 0, "Result": null, "Target": null, "Apollo test code": "TT735XX", "Approval based upon": null}
												 , "BIS Load/Speed performance test (diameter differences)": {"LSL": null, "LWL": null, "USL": 3.5, "UWL": null, "UoM": "%", "- tol": null, "Legal": 3.5, "Result": null, "Target": null, "Apollo test code": "TT520AX", "Approval based upon": null}
												 , "ECE / Inmetro Load speed performance test (Diameter diff.)": {"LSL": null, "LWL": null, "USL": 3.5, "UWL": null, "UoM": "%", "- tol": null, "Legal": 3.5, "Result": null, "Target": null, "Apollo test code": "TT735XX", "Approval based upon": null}}
						, "PAC outdoor testing": {"ECE Noise labeling": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "dB(A)", "- tol": null, "Result": null, "Target": null, "SL treshold": null, "Apollo test code": "TT872AA", "Approval based upon": null}
						                         , "ECE Wet Grip labeling (trailer)": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "%", "- tol": null, "Result": null, "Target": null, "SL treshold": null, "Apollo test code": "TT813AA", "Approval based upon": null}
												 , "ECE Wet Grip labeling (vehicle)": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "%", "- tol": null, "Result": null, "Target": null, "SL treshold": null, "Apollo test code": "TT814AA", "Approval based upon": null}}}
				}
				, "Config": {"(none)": {"default property group": {"Base UoM": {"Value": "pcs"}}}}
				, "D-spec": {"(none)": {"Child segment": {"E": {"Value": null}, "Size": {"Value": null}, "A-dia": {"Value": null}, "D-dia": {"Value": "353.9"}, "N-dia": {"Value": "394.96"}, "M.B.W.": {"Value": "139.7"}, "Bead type": {"Value": "B3"}, "Tread type": {"Value": "T1"}, "Cavity type": {"Value": "T1S0B3"}, "E(Percentage)": {"Value": null}, "Section width": {"Value": null}, "Sidewall type": {"Value": "S0"}}
				                                         , "Tread grooves": {"Groove amount": {"UoM": null, "Value": null}, "Groove 1 depth": {"UoM": "mm", "Value": null}, "Groove 1 width": {"UoM": "mm", "Value": null}, "Groove 2 depth": {"UoM": "mm", "Value": null}, "Groove 2 width": {"UoM": "mm", "Value": null}, "Groove 3 depth": {"UoM": "mm", "Value": null}, "Groove 3 width": {"UoM": "mm", "Value": null}, "Groove 4 depth": {"UoM": "mm", "Value": null}, "Groove 4 width": {"UoM": "mm", "Value": null}, "Groove 5 depth": {"UoM": "mm", "Value": null}, "Groove 5 width": {"UoM": "mm", "Value": null}, "Groove 1 position": {"UoM": "mm", "Value": null}, "Groove 2 position": {"UoM": "mm", "Value": null}, "Groove 3 position": {"UoM": "mm", "Value": null}, "Groove 4 position": {"UoM": "mm", "Value": null}, "Groove 5 position": {"UoM": "mm", "Value": null}, "Groove 1 angle inner side": {"UoM": "°", "Value": null}, "Groove 1 angle outer side": {"UoM": "°", "Value": null}, "Groove 2 angle inner side": {"UoM": "°", "Value": null}, "Groove 2 angle outer side": {"UoM": "°", "Value": null}, "Groove 3 angle inner side": {"UoM": "°", "Value": null}, "Groove 3 angle outer side": {"UoM": "°", "Value": null}, "Groove 4 angle inner side": {"UoM": "°", "Value": null}, "Groove 4 angle outer side": {"UoM": "°", "Value": null}, "Groove 5 angle inner side": {"UoM": "°", "Value": null}, "Groove 5 angle outer side": {"UoM": "°", "Value": null}, "Groove 1 rad/cham inner side": {"UoM": "mm", "Value": null}, "Groove 1 rad/cham outer side": {"UoM": "mm", "Value": null}, "Groove 2 rad/cham inner side": {"UoM": "mm", "Value": null}, "Groove 2 rad/cham outer side": {"UoM": "mm", "Value": null}, "Groove 3 rad/cham inner side": {"UoM": "mm", "Value": null}, "Groove 3 rad/cham outer side": {"UoM": "mm", "Value": null}, "Groove 4 rad/cham inner side": {"UoM": "mm", "Value": null}, "Groove 4 rad/cham outer side": {"UoM": "mm", "Value": null}, "Groove 5 rad/cham inner side": {"UoM": "mm", "Value": null}, "Groove 5 rad/cham outer side": {"UoM": "mm", "Value": null}}
														 , "Master drawing": {"F": {"UoM": "mm", "Value": 8.5}, "P": {"UoM": "mm", "Value": null}, "Q": {"UoM": "mm", "Value": null}, "R": {"UoM": "mm", "Value": null}, "T": {"UoM": "mm", "Value": 113.5}, "R1": {"UoM": "mm", "Value": 335854.119999999995}, "R2": {"UoM": "mm", "Value": null}, "R4": {"UoM": "mm", "Value": 29}, "R5": {"UoM": "mm", "Value": 56.5560000000000045}, "R6": {"UoM": "mm", "Value": 101.059000000000012}, "R7": {"UoM": "mm", "Value": null}, "R8": {"UoM": "mm", "Value": null}, "R9": {"UoM": "mm", "Value": null}, "Rd": {"UoM": "mm", "Value": null}, "HAS": {"UoM": "mm", "Value": null}, "R10": {"UoM": "mm", "Value": null}, "R11": {"UoM": "mm", "Value": null}, "R12": {"UoM": "mm", "Value": null}, "R13": {"UoM": "mm", "Value": null}, "R14": {"UoM": null, "Value": null}, "c_L": {"UoM": "mm", "Value": null}, "c_m": {"UoM": "mm", "Value": null}, "c_Ba": {"UoM": "mm", "Value": null}, "c_Bb": {"UoM": null, "Value": null}, "c_Bt": {"UoM": "mm", "Value": null}, "c_L1": {"UoM": "mm", "Value": null}, "c_Re": {"UoM": "mm", "Value": null}, "c_Rf": {"UoM": "mm", "Value": null}, "c_Rg": {"UoM": "mm", "Value": null}, "c_Rh": {"UoM": "mm", "Value": null}, "A-dia": {"UoM": "mm", "Value": null}, "Alpha": {"UoM": "mm", "Value": null}, "B-dia": {"UoM": "mm", "Value": null}, "C-dia": {"UoM": "mm", "Value": null}, "Gamma": {"UoM": null, "Value": null}, "c_m_d": {"UoM": "mm", "Value": null}, "c_rRf": {"UoM": "mm", "Value": null}, "eInside": {"UoM": "mm", "Value": null}, "g angle": {"UoM": "°", "Value": null}, "h angle": {"UoM": "°", "Value": null}, "eOutside": {"UoM": "mm", "Value": null}, "Drop value": {"UoM": null, "Value": null}, "SD periphery": {"UoM": null, "Value": null}, "Cavity periphery": {"UoM": "mm", "Value": null}, "D contour drawing": {"UoM": "mm", "Value": null}, "X contour drawing": {"UoM": "mm", "Value": null}, "Y contour drawing": {"UoM": "mm", "Value": 84.5}, "Z contour drawing": {"UoM": "mm", "Value": null}, "R3 contour drawing": {"UoM": "mm", "Value": 29}, "Straight line angle": {"UoM": "°", "Value": null}, "Rim protector radius": {"UoM": "mm", "Value": null}, "Tread width periphery": {"UoM": null, "Value": null}}
														 , "Parent segment": {"E": {"Value": null}, "Size": {"Value": null}, "A-dia": {"Value": null}, "D-dia": {"Value": "353.9"}, "N-dia": {"Value": "394.96"}, "M.B.W.": {"Value": "139.7"}, "Bead type": {"Value": "B3"}, "Tread type": {"Value": "T1"}, "Cavity type": {"Value": "T1S0B3"}, "E(Percentage)": {"Value": null}, "Section width": {"Value": null}, "Sidewall type": {"Value": "S0"}}
														 , "D-Spec (Gauges)": {"Tolerance": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "TOL", "Target": null, "Apollo test code": null}, "Chimney width": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "W_CH", "Target": null, "Apollo test code": "TT511XX"}, "Total gauge @ R": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "TG_R", "Target": null, "Apollo test code": "TT511XX"}, "Chimney position": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "L_CH", "Target": null, "Apollo test code": "TT511XX"}, "Rubber gauge @ R": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_R", "Target": null, "Apollo test code": "TT511XX"}, "Total gauge @ S1": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "TG_S1", "Target": null, "Apollo test code": "TT511XX"}, "Total gauge @ S2": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "TG_S2", "Target": null, "Apollo test code": "TT511XX"}, "Total gauge @ S3": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "TG_S3", "Target": null, "Apollo test code": "TT511XX"}, "Total gauge @ S4": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "TG_S4", "Target": null, "Apollo test code": "TT511XX"}, "Total gauge @ S5": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "TG_S5", "Target": null, "Apollo test code": "TT511XX"}, "Total gauge @ S6": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "TG_S6", "Target": null, "Apollo test code": "TT511XX"}, "Total gauge @ S7": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "TG_S7", "Target": null, "Apollo test code": "TT511XX"}, "Rubber gauge @ S1": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_S1", "Target": null, "Apollo test code": "TT511XX"}, "Rubber gauge @ S2": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_S2", "Target": null, "Apollo test code": "TT511XX"}, "Rubber gauge @ S3": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_S3", "Target": null, "Apollo test code": "TT511XX"}, "Rubber gauge @ S4": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_S4", "Target": null, "Apollo test code": "TT511XX"}, "Rubber gauge @ S5": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_S5", "Target": null, "Apollo test code": "TT511XX"}, "Rubber gauge @ S6": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_S6", "Target": null, "Apollo test code": "TT511XX"}, "Rubber gauge @ S7": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_S7", "Target": null, "Apollo test code": "TT511XX"}, "Location of G point": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "LC_SW", "Target": null, "Apollo test code": null}, "Location of M point": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "LC_M", "Target": 56.75, "Apollo test code": null}, "Location of R point": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "LC_R", "Target": null, "Apollo test code": null}, "Total gauge @ S-Dia": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "TG_SD", "Target": null, "Apollo test code": "TT511XX"}, "Location of Rb point": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "LC_Rb", "Target": null, "Apollo test code": null}, "Location of Rt point": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "LC_Rt", "Target": null, "Apollo test code": null}, "Location of T0 point": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "LC_T0", "Target": 14.1875, "Apollo test code": null}, "Location of T1 point": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "LC_T1", "Target": 28.375, "Apollo test code": null}, "Location of T2 point": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "LC_T2", "Target": 42.5625, "Apollo test code": null}, "Location of TS point": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "LC_TS", "Target": 45, "Apollo test code": null}, "Rubber gauge @ S-Dia": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_SD", "Target": null, "Apollo test code": "TT511XX"}, "Total gauge @ Min SW": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "TG_SW", "Target": null, "Apollo test code": "TT511XX"}, "Total gauge @ location G": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_SW", "Target": null, "Apollo test code": "TT511XX"}, "Distance between S-points": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "ic_dSx", "Target": null, "Apollo test code": null}, "Total gauge 15 mm above R": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "TG_Rt", "Target": null, "Apollo test code": "TT511XX"}, "Rubber gauge 15 mm above R": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_Rt", "Target": null, "Apollo test code": "TT511XX"}, "Total gauge at 10mm below R": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "TG_Rb", "Target": null, "Apollo test code": "TT511XX"}, "Min. distance between points": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "ic_dPxMin", "Target": null, "Apollo test code": null}, "Rubber gauge at 10mm below R": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_Rb", "Target": null, "Apollo test code": "TT511XX"}, "Sidewall rubber gauge @ Location G": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_SG", "Target": null, "Apollo test code": "TT511XX"}}
														 , "Catia finetuning": {"Exit angle belt 1": {"UoM": null, "Value": null}, "Bead ring radius inside": {"UoM": null, "Value": null}, "Spline tension 1 belt 1": {"UoM": null, "Value": null}, "Spline tension 2 belt 1": {"UoM": null, "Value": null}, "Bead ring radius outside": {"UoM": null, "Value": null}, "Spline tension 1 strip 1": {"UoM": null, "Value": null}, "Spline tension 1 strip 2": {"UoM": null, "Value": null}, "Spline tension 1 wingtip": {"UoM": null, "Value": null}, "Spline tension 2 strip 1": {"UoM": null, "Value": null}, "Spline tension 2 strip 2": {"UoM": null, "Value": null}, "Spline tension 2 wingtip": {"UoM": null, "Value": null}, "Spline tension 1 sidewall": {"UoM": null, "Value": null}, "Spline tension 2 sidewall": {"UoM": null, "Value": null}, "Spline tension 1 rimcushion": {"UoM": null, "Value": null}, "Spline tension 2 rimcushion": {"UoM": null, "Value": null}, "Bead ring rotation angle vertical": {"UoM": null, "Value": null}, "Bead ring rotation angle horizontal": {"UoM": null, "Value": null}}
														 , "D-Spec (section)": {"Bead width": {"LSL": null, "LWL": 1, "USL": null, "UWL": 1, "UoM": "mm", "Rem.": "W_BD", "Target": 14.3000000000000007, "Apollo test code": "TT511XX"}, "Ply 1 gauge": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_P1", "Target": null, "Apollo test code": "TT511XX"}, "Ply 2 gauge": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_P2", "Target": null, "Apollo test code": "TT511XX"}, "Ply 3 gauge": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_P3", "Target": null, "Apollo test code": "TT511XX"}, "Gauge 1 Apex": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_AF_1", "Target": null, "Apollo test code": null}, "Gauge 2 Apex": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_AF_2", "Target": null, "Apollo test code": null}, "Gauge 3 Apex": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_AF_3", "Target": null, "Apollo test code": null}, "Gauge 4 Apex": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_AF_4", "Target": null, "Apollo test code": null}, "Gauge 5 Apex": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_AF_5", "Target": null, "Apollo test code": null}, "Chipper angle": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "A_CH1", "Target": null, "Apollo test code": "TT511XX"}, "Chipper gauge": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_CH", "Target": null, "Apollo test code": "TT511XX"}, "Bead tip width": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "W_BT", "Target": null, "Apollo test code": "TT511XX"}, "Chipper height": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "H_CH", "Target": null, "Apollo test code": "TT511XX"}, "Gauge 1 Apex 2": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_AF2_1", "Target": null, "Apollo test code": null}, "Gauge 2 Apex 2": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_AF2_2", "Target": null, "Apollo test code": null}, "Gauge 3 Apex 2": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_AF2_3", "Target": null, "Apollo test code": null}, "Gauge 4 Apex 2": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_AF2_4", "Target": null, "Apollo test code": null}, "Gauge 5 Apex 2": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_AF2_5", "Target": null, "Apollo test code": null}, "Crown thickness": {"LSL": null, "LWL": 0.599999999999999978, "USL": null, "UWL": 0.599999999999999978, "UoM": "mm", "Rem.": "TG_TR", "Target": 14.4000000000000004, "Apollo test code": "TT511XX"}, "Rim compression": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": null, "Rem.": null, "Target": 32.8999999999999986, "Apollo test code": null}, "Under tread @ M": {"LSL": 1.5, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_UTM", "Target": 1.5, "Apollo test code": "TT511XX"}, "Bead bundle width": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "W_BDR", "Target": 7.20000000000000018, "Apollo test code": "TT511XX"}, "Mould compression": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": null, "Rem.": null, "Target": 6.5, "Apollo test code": null}, "Bead bundle height": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "H_BDR", "Target": 7.20000000000000018, "Apollo test code": "TT511XX"}, "Tread width factor": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": null, "Target": null, "Apollo test code": "TT511XX"}, "Fabric chafer gauge": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_FC", "Target": null, "Apollo test code": "TT511XX"}, "Filler inside gauge": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_CH_P1", "Target": null, "Apollo test code": "TT511XX"}, "Ply gum strip gauge": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": null, "Rem.": "G_PS", "Target": null, "Apollo test code": null}, "Ply gum strip width": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": null, "Rem.": null, "Target": null, "Apollo test code": null}, "Bead layer thickness": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "T_BDRL", "Target": 1.19999999999999996, "Apollo test code": "TT511XX"}, "Chipper inside angle": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "A_CH2", "Target": null, "Apollo test code": "TT511XX"}, "Chipper inside gauge": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_CH_P2", "Target": null, "Apollo test code": "TT511XX"}, "Ending from tread CL": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": null, "Target": null, "Apollo test code": "TT511XX"}, "FIller inside height": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "CH_H1", "Target": null, "Apollo test code": "TT511XX"}, "FIller inside length": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "CH_D1", "Target": null, "Apollo test code": "TT511XX"}, "Filler outside gauge": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_CH_P3", "Target": null, "Apollo test code": "TT511XX"}, "Folded Chipper angle": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "A_CH4", "Target": null, "Apollo test code": "TT511XX"}, "Folded Chipper gauge": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_CH_P4", "Target": null, "Apollo test code": "TT511XX"}, "Ply 1 ending from CL": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": null, "Target": null, "Apollo test code": "TT511XX"}, "SOT Wingtip Activity": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": null, "Rem.": "SWA", "Target": null, "Apollo test code": "TT511XX"}, "Tread thickness (CL)": {"LSL": null, "LWL": 0.299999999999999989, "USL": null, "UWL": 0.299999999999999989, "UoM": "mm", "Rem.": "G_TR", "Target": 9.84999999999999964, "Apollo test code": "TT511XX"}, "Carcass turnup height": {"LSL": null, "LWL": 5, "USL": null, "UWL": 5, "UoM": "mm", "Rem.": "H_P1", "Target": 69, "Apollo test code": "TT511XX"}, "Chipper inside height": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "CH_H2", "Target": null, "Apollo test code": "TT511XX"}, "Gauge 1 white sidewall": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_WSW_1", "Target": null, "Apollo test code": null}, "Gauge 2 white sidewall": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_WSW_2", "Target": null, "Apollo test code": null}, "Gauge 3 white sidewall": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_WSW_3", "Target": null, "Apollo test code": null}, "Gauge 4 white sidewall": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_WSW_4", "Target": null, "Apollo test code": null}, "Gauge 5 white sidewall": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_WSW_5", "Target": null, "Apollo test code": null}, "Undertread (CL) design": {"LSL": 2, "LWL": 0.299999999999999989, "USL": null, "UWL": 0.299999999999999989, "UoM": "mm", "Rem.": "G_UT", "Target": 2, "Apollo test code": "TT511XX"}, "Carcass 2 turnup height": {"LSL": null, "LWL": 5, "USL": null, "UWL": 5, "UoM": "mm", "Rem.": "H_P2", "Target": null, "Apollo test code": "TT511XX"}, "Gauge of Runflat @ RF11": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_RF11", "Target": null, "Apollo test code": "TT511XX"}, "Gauge of Runflat @ RF12": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_RF12", "Target": null, "Apollo test code": "TT511XX"}, "Gauge of Runflat @ RF13": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_RF13", "Target": null, "Apollo test code": "TT511XX"}, "Gauge of Runflat @ RF14": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_RF14", "Target": null, "Apollo test code": "TT511XX"}, "Gauge of Runflat @ RF15": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_RF15", "Target": null, "Apollo test code": "TT511XX"}, "Gauge of Runflat @ RF16": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_RF16", "Target": null, "Apollo test code": "TT511XX"}, "Gauge of Runflat @ RF21": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_RF21", "Target": null, "Apollo test code": "TT511XX"}, "Gauge of Runflat @ RF22": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_RF22", "Target": null, "Apollo test code": "TT511XX"}, "Gauge of Runflat @ RF23": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_RF23", "Target": null, "Apollo test code": "TT511XX"}, "Gauge of Runflat @ RF24": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_RF24", "Target": null, "Apollo test code": "TT511XX"}, "Gauge of Runflat @ RF25": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_RF25", "Target": null, "Apollo test code": "TT511XX"}, "Gauge of Runflat @ RF26": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_RF26", "Target": null, "Apollo test code": "TT511XX"}, "Gauge of tread base @ M": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_TBM", "Target": null, "Apollo test code": "TT511XX"}, "Innerliner gauge @ bead": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_IL3", "Target": null, "Apollo test code": "TT511XX"}, "Non skid depth tyre @ M": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "NSD_M", "Target": null, "Apollo test code": "TT511XX"}, "Material under bead wire": {"LSL": null, "LWL": 0.5, "USL": null, "UWL": 0.5, "UoM": "mm", "Rem.": "G_UB", "Target": 3, "Apollo test code": "TT511XX"}, "Non skid depth tyre @ CL": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "NSD_CL", "Target": null, "Apollo test code": "TT511XX"}, "Shoulder gum strip gauge": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": null, "Rem.": "G_SGS", "Target": null, "Apollo test code": null}, "Shoulder gum strip width": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": null, "Rem.": "W_SGS", "Target": null, "Apollo test code": null}, "Top point white sidewall": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "H_WSW", "Target": null, "Apollo test code": null}, "Total gauge of tread @ M": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "TG_M", "Target": 13.8000000000000007, "Apollo test code": "TT511XX"}, "Gauge of Runflat @ E Line": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_RFG", "Target": null, "Apollo test code": "TT511XX"}, "Innerliner gauge @ center": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_IL0", "Target": null, "Apollo test code": "TT511XX"}, "Ply 3 turn up/down height": {"LSL": null, "LWL": 5, "USL": null, "UWL": 5, "UoM": "mm", "Rem.": "H_P3", "Target": null, "Apollo test code": "TT511XX"}, "Rubber gauge of tread @ M": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_M", "Target": null, "Apollo test code": "TT511XX"}, "Total gauge of tread @ T0": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "TG_T0", "Target": null, "Apollo test code": "TT511XX"}, "Total gauge of tread @ T1": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "TG_T1", "Target": null, "Apollo test code": "TT511XX"}, "Total gauge of tread @ T2": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "TG_T2", "Target": null, "Apollo test code": "TT511XX"}, "Total gauge of tread @ TS": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "TG_TS", "Target": null, "Apollo test code": "TT511XX"}, "Gauge of tread base 1 @ CL": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_TB1", "Target": null, "Apollo test code": "TT511XX"}, "Gauge of tread base 2 @ CL": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_TB2", "Target": null, "Apollo test code": "TT511XX"}, "Material outside bead wire": {"LSL": null, "LWL": 1, "USL": null, "UWL": 1, "UoM": "mm", "Rem.": "G_OB", "Target": 6.29999999999999982, "Apollo test code": "TT511XX"}, "Ply gum strip lower ending": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": null, "Rem.": "E_PSL", "Target": null, "Apollo test code": null}, "Ply gum strip upper ending": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": null, "Rem.": "E_PSU", "Target": null, "Apollo test code": null}, "Rubber gauge of tread @ T1": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_T1", "Target": null, "Apollo test code": "TT511XX"}, "Rubber gauge of tread @ TS": {"LSL": null, "LWL": 0.299999999999999989, "USL": null, "UWL": 0.299999999999999989, "UoM": "mm", "Rem.": "SL", "Target": 9.5, "Apollo test code": "TT511XX"}, "Bottom point white sidewall": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "D_WSW", "Target": null, "Apollo test code": null}, "Chipper inside lower height": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "CH_D2", "Target": null, "Apollo test code": "TT511XX"}, "Fabric chafer height inside": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "H_FCI", "Target": null, "Apollo test code": "TT511XX"}, "Filler outside lower height": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "CH_D3", "Target": null, "Apollo test code": "TT511XX"}, "Filler outside upper height": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "CH_H3", "Target": null, "Apollo test code": "TT511XX"}, "Innerliner gauge @ shoulder": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_IL1", "Target": null, "Apollo test code": "TT511XX"}, "Innerliner gauge @ sidewall": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_IL2", "Target": null, "Apollo test code": "TT511XX"}, "Rim cushion height - inside": {"LSL": null, "LWL": 2, "USL": null, "UWL": 5, "UoM": "mm", "Rem.": "H_RCI", "Target": null, "Apollo test code": "TT511XX"}, "Fabric chafer height outside": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "H_FC", "Target": null, "Apollo test code": "TT511XX"}, "Folded Chipper inside height": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "CH_H4", "Target": null, "Apollo test code": "TT511XX"}, "Ply 1 envelop ending from CL": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "E_P1", "Target": null, "Apollo test code": "TT511XX"}, "Ply gum strip ending from CL": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": null, "Rem.": null, "Target": null, "Apollo test code": null}, "Tread cap ending top from CL": {"LSL": null, "LWL": 2, "USL": null, "UWL": 2, "UoM": "mm", "Rem.": "E_TCT", "Target": 78, "Apollo test code": "TT511XX"}, "Folded Chipper outside height": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "CH_D4", "Target": null, "Apollo test code": "TT511XX"}, "Ply 2 ending from Bead Center": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "LC_P2", "Target": null, "Apollo test code": "TT511XX"}, "Ply 3 ending from Bead Center": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "LC_P3", "Target": null, "Apollo test code": "TT511XX"}, "Rim cushion height from D-Dia": {"LSL": null, "LWL": 5, "USL": null, "UWL": 5, "UoM": "mm", "Rem.": "H_RC", "Target": 72, "Apollo test code": "TT511XX"}, "Under tread @ groove 1 SS/NSS": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_UT1", "Target": 1.40000000000000013, "Apollo test code": "TT511XX"}, "Under tread @ groove 2 SS/NSS": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_UT2", "Target": 1.80000000000000004, "Apollo test code": "TT511XX"}, "Thickness @ max gauge location": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": null, "Target": null, "Apollo test code": "TT511XX"}, "Ply gum strip overlap with apex": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": null, "Rem.": null, "Target": null, "Apollo test code": null}, "Top point Height from DD Apex 2": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "H_AF2", "Target": null, "Apollo test code": null}, "Tread cap ending bottom from CL": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "E_TCB", "Target": null, "Apollo test code": "TT511XX"}, "Height from referencepoint/D-dia": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": null, "Target": null, "Apollo test code": "TT511XX"}, "Ply gum strip overlap with ply 1": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": null, "Rem.": null, "Target": null, "Apollo test code": null}, "Rim cushion / Innerliner overlap": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "H_RII", "Target": null, "Apollo test code": null}, "Rim cushion ending from bead toe": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "H_RCT", "Target": null, "Apollo test code": null}, "Runflat starting height from BRP": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "H_RF2", "Target": null, "Apollo test code": "TT511XX"}, "Non skid depth tyre shrink factor": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "NSD_SFA", "Target": null, "Apollo test code": null}, "Shoulder gum strip ending from CL": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": null, "Rem.": "E_SGS", "Target": null, "Apollo test code": null}, "Bottom point Height from DD Apex 2": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "H_AFDD2", "Target": null, "Apollo test code": null}, "Chipper lower height from bead heel": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "H_CHL", "Target": null, "Apollo test code": "TT511XX"}, "Rim cushion lower height from D-Dia": {"LSL": null, "LWL": 5, "USL": null, "UWL": 5, "UoM": "mm", "Rem.": "H_RCL", "Target": 27, "Apollo test code": "TT511XX"}, "Reference Distance Between RF Points": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "LC_Ref", "Target": 0, "Apollo test code": null}, "Innerliner gauge @ overlap with rim cushion": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_IL4", "Target": null, "Apollo test code": null}}
														 , "Construction type": {"Flexible Apex": {"Value": null}, "Chimney mirror": {"Value": null}, "Belt strip type": {"Value": "Top"}, "Cap-strip layup": {"Value": "1-1-1"}, "Chipper variant": {"Value": null}, "Number of plies": {"Value": "1"}, "Chimney activity": {"Value": null}, "Cap-Strip/Ply type": {"Value": "Strip"}, "Amount of layers (Hexa)": {"Value": "3"}, "Hexa bead configuration": {"Value": null}, "Number of capply layers": {"Value": "1"}, "Bead wires (turns x wires)": {"Value": "5x6"}, "Shoulder gum strip location": {"Value": null}, "Innerliner production method": {"Value": null}, "Bead bundle production method": {"Value": null}, "No. of wires top layer (Hexa)": {"Value": null}, "No. of wires widest layer (Hexa)": {"Value": null}}
														 , "General Catia settings": {"Timestamp": {"Value": null}, "Date created": {"Value": null}, "Generate DWG": {"Value": null}, "Generate DXF": {"Value": null}, "Generate IGS": {"Value": null}, "Generate JPG": {"Value": null}, "Generate PDF": {"Value": null}, "Generate STP": {"Value": null}, "Catia template": {"Value": null}, "Cavity JPG zoom": {"Value": null}, "Generate 3D XML": {"Value": null}, "Groove 1 mirror": {"Value": null}, "Groove 2 mirror": {"Value": null}, "Groove 3 mirror": {"Value": null}, "Groove 4 mirror": {"Value": null}, "Groove 5 mirror": {"Value": null}, "Layout JPG zoom": {"Value": null}, "Mould attribute": {"Value": null}, "FEA CATPart name": {"Value": null}, "Gauge list apex 2": {"Value": null}, "Catia drawing type": {"Value": null}, "Generate Catia part": {"Value": null}, "Catia version number": {"Value": null}, "Cavity drawing scale": {"Value": null}, "Layout drawing scale": {"Value": null}, "Cavity JPG resolution": {"Value": null}, "Layout JPG resolution": {"Value": null}, "Catia template version": {"Value": null}, "Generate Catia drawing": {"Value": null}, "Cavity drawing font size": {"Value": null}, "Groove 1 edge inner side": {"Value": null}, "Groove 1 edge outer side": {"Value": null}, "Groove 2 edge inner side": {"Value": null}, "Groove 2 edge outer side": {"Value": null}, "Groove 3 edge inner side": {"Value": null}, "Groove 3 edge outer side": {"Value": null}, "Groove 4 edge inner side": {"Value": null}, "Groove 4 edge outer side": {"Value": null}, "Groove 5 edge inner side": {"Value": null}, "Groove 5 edge outer side": {"Value": null}, "Layout drawing font size": {"Value": null}, "Groove 1 chamfer inner side": {"Value": null}, "Groove 1 chamfer outer side": {"Value": null}, "Groove 2 chamfer inner side": {"Value": null}, "Groove 2 chamfer outer side": {"Value": null}, "Groove 3 chamfer inner side": {"Value": null}, "Groove 3 chamfer outer side": {"Value": null}, "Groove 4 chamfer inner side": {"Value": null}, "Groove 4 chamfer outer side": {"Value": null}, "Groove 5 chamfer inner side": {"Value": null}, "Groove 5 chamfer outer side": {"Value": null}, "Cavity drawing dimension style": {"Value": null}, "Layout drawing dimension style": {"Value": null}}
														 , "Master drawing general": {"S-dia": {"Value": "557.6"}, "Family": {"Value": null}, "Segment": {"Value": "6084"}, "Sideplate": {"Value": null}, "Cavity designer": {"Value": null}, "Layout designer": {"Value": null}, "Overall diameter": {"Value": "619.6"}, "Cavity checked by": {"Value": null}, "Inside/Outside R9": {"Value": null}, "Layout checked by": {"Value": null}, "Cavity approved by": {"Value": null}, "Layout approved by": {"Value": null}, "Cavity drawing number": {"Value": null}, "Layout drawing number": {"Value": null}, "Height sidewall plates": {"Value": null}, "Tread master drawing number": {"Value": null}, "Cavity master drawing number": {"Value": null}}
														 , "Construction parameters": {"2 ply": {"Value": "N"}, "Endless capply": {"Value": "Y"}, "Sidewall over tread": {"Value": "N"}, "Straight line option": {"Value": "N"}, "Rimcushion under bead": {"Value": "Y"}}
														 , "D-Spec (reinforcements)": {"CB2": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "CB2", "Target": null, "Apollo test code": "TT511XX"}, "BCID": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "Bead_BCID", "Target": null, "Apollo test code": null}, "Lift belt": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "%", "Rem.": "belt_lift", "Target": 2.20000000000000018, "Apollo test code": null}, "Gauge belt": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_B1", "Target": 1.20942464802484007, "Apollo test code": "TT511XX"}, "Gauge belt 3": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_B3", "Target": null, "Apollo test code": "TT511XX"}, "Gauge capply": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_CP", "Target": 0.841338885582501028, "Apollo test code": "TT511XX"}, "Lift carcass": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "%", "Rem.": null, "Target": 74, "Apollo test code": null}, "U-Wrap width": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "W_UW", "Target": null, "Apollo test code": "TT511XX"}, "Width capply": {"LSL": null, "LWL": 2, "USL": null, "UWL": 2, "UoM": "mm", "Rem.": "W_CP1", "Target": 131, "Apollo test code": "TT511XX"}, "Filler height": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "H_AF", "Target": 50, "Apollo test code": "TT511XX"}, "Gauge carcass": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_P1", "Target": null, "Apollo test code": "TT511XX"}, "Gauge squeegee": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_SQ", "Target": null, "Apollo test code": "TT511XX"}, "Width squeegee": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "W_SQ", "Target": null, "Apollo test code": "TT511XX"}, "Cap-strip pitch": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "P_CA", "Target": null, "Apollo test code": "TT511XX"}, "Endcount capply": {"LSL": null, "LWL": 2, "USL": null, "UWL": 2, "UoM": "cpdm", "Rem.": "N_CP", "Target": 140, "Apollo test code": "PT111XX"}, "Endcount chipper": {"LSL": null, "LWL": 2, "USL": null, "UWL": 2, "UoM": "cpdm", "Rem.": "N_CH", "Target": null, "Apollo test code": null}, "Ply lift @ S-dia": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "%", "Rem.": "Ply_Sd", "Target": null, "Apollo test code": null}, "Innerliner height": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "H_ILI", "Target": null, "Apollo test code": "TT511XX"}, "Ply lift @ center": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "%", "Rem.": "Ply_C", "Target": null, "Apollo test code": null}, "Width cap-strip 2": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "W_CP2", "Target": null, "Apollo test code": "TT511XX"}, "Gauge belt strip 1": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_BS1", "Target": null, "Apollo test code": "TT511XX"}, "Gauge belt strip 2": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_BS2", "Target": null, "Apollo test code": "TT511XX"}, "Gauge steel chafer": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_SC", "Target": null, "Apollo test code": "TT511XX"}, "Ply lift @ E-point": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "%", "Rem.": "Ply_Ep", "Target": null, "Apollo test code": null}, "Width belt layer 1": {"LSL": null, "LWL": 2, "USL": null, "UWL": 2, "UoM": "mm", "Rem.": "W_B1", "Target": 124, "Apollo test code": "TT511XX"}, "Width belt layer 2": {"LSL": null, "LWL": 2, "USL": null, "UWL": 2, "UoM": "mm", "Rem.": "W_B2", "Target": 114, "Apollo test code": "TT511XX"}, "Width belt layer 3": {"LSL": null, "LWL": 2, "USL": null, "UWL": 2, "UoM": "mm", "Rem.": "W_B3", "Target": null, "Apollo test code": "TT511XX"}, "Width belt strip 1": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "W_BS1", "Target": null, "Apollo test code": "TT511XX"}, "Width steel chafer": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "W_SC", "Target": null, "Apollo test code": "TT511XX"}, "Tread overall ending": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "E_TR", "Target": null, "Apollo test code": "TT511XX"}, "Capply/Belt 1 Stepoff": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "X_CPB1", "Target": null, "Apollo test code": "TT511XX"}, "Endcount belt layer 1": {"LSL": null, "LWL": 2, "USL": null, "UWL": 2, "UoM": "cpdm", "Rem.": "N_B1", "Target": 102.722429896310004, "Apollo test code": "PT111XX"}, "Endcount belt layer 2": {"LSL": null, "LWL": 2, "USL": null, "UWL": 2, "UoM": "cpdm", "Rem.": "N_B2", "Target": 102.722429896310004, "Apollo test code": "PT111XX"}, "Endcount belt layer 3": {"LSL": null, "LWL": 2, "USL": null, "UWL": 2, "UoM": "cpdm", "Rem.": "N_B3", "Target": null, "Apollo test code": "PT111XX"}, "Endcount steel chafer": {"LSL": null, "LWL": 2, "USL": null, "UWL": 2, "UoM": "cpdm", "Rem.": "N_SC", "Target": null, "Apollo test code": "PT111XX"}, "Filler height from DD": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "H_AFDD", "Target": 55, "Apollo test code": "TT511XX"}, "Gauge Inside Body Ply": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_IBP", "Target": null, "Apollo test code": "TT511XX"}, "Sidewall ending at CL": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "E_SW", "Target": null, "Apollo test code": "TT511XX"}, "Cord angle belt layer 1": {"LSL": null, "LWL": 2, "USL": null, "UWL": 2, "UoM": "°", "Rem.": "A_B", "Target": 23.4946698544590014, "Apollo test code": "PT111XX"}, "Cord angle belt layer 3": {"LSL": null, "LWL": 2, "USL": null, "UWL": 2, "UoM": "°", "Rem.": "A_B3", "Target": null, "Apollo test code": "PT111XX"}, "Cord angle steel chafer": {"LSL": null, "LWL": 2, "USL": null, "UWL": 2, "UoM": "°", "Rem.": "A_SC", "Target": null, "Apollo test code": "PT111XX"}, "Squeegee ending from CL": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "E_SQ", "Target": null, "Apollo test code": "TT511XX"}, "Capstrip tension phase 1": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "N", "Rem.": null, "Target": null, "Apollo test code": "TT511XX"}, "Capstrip tension phase 2": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "N", "Rem.": null, "Target": null, "Apollo test code": "TT511XX"}, "Capstrip tension phase 3": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "N", "Rem.": null, "Target": null, "Apollo test code": "TT511XX"}, "Capstrip tension phase 4": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "N", "Rem.": null, "Target": null, "Apollo test code": "TT511XX"}, "Capstrip tension phase 5": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "N", "Rem.": null, "Target": null, "Apollo test code": "TT511XX"}, "Capstrip tension phase 6": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "N", "Rem.": null, "Target": null, "Apollo test code": "TT511XX"}, "Capstrip tension phase 7": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "N", "Rem.": null, "Target": null, "Apollo test code": "TT511XX"}, "Effective section height": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "ESH", "Target": null, "Apollo test code": "TT511XX"}, "Endcount carcass layer 1": {"LSL": null, "LWL": 2, "USL": null, "UWL": 2, "UoM": "cpdm", "Rem.": "N_P1", "Target": 62.4277456647398949, "Apollo test code": "PT111XX"}, "Endcount carcass layer 2": {"LSL": null, "LWL": 2, "USL": null, "UWL": 2, "UoM": "cpdm", "Rem.": "N_P2", "Target": null, "Apollo test code": "PT111XX"}, "Endcount carcass layer 3": {"LSL": null, "LWL": 2, "USL": null, "UWL": 2, "UoM": "cpdm", "Rem.": "N_P3", "Target": null, "Apollo test code": "PT111XX"}, "Gauge Bead Filler Insert": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_BFI", "Target": null, "Apollo test code": "TT511XX"}, "Lift percentage shoulder": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "%", "Rem.": null, "Target": null, "Apollo test code": null}, "Width Bead Filler Insert": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "W_BFI", "Target": null, "Apollo test code": "TT511XX"}, "Capstrip tension constant": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "N", "Rem.": null, "Target": 30, "Apollo test code": "TT511XX"}, "Gauge Sidewall Protection": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_SWP", "Target": null, "Apollo test code": "TT511XX"}, "Height Bead Filler Insert": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "H_BFI", "Target": null, "Apollo test code": "TT511XX"}, "Innerliner height outside": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "H_ILO", "Target": null, "Apollo test code": "TT511XX"}, "Location of U-Wrap bottom": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "LC_UW", "Target": null, "Apollo test code": "TT511XX"}, "Rubber gauge below belt 1": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "G_B1E", "Target": null, "Apollo test code": "TT511XX"}, "Tot. width capply layer 2": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "W_CP2", "Target": null, "Apollo test code": "TT511XX"}, "Tot. width capply layer 3": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "W_CP3", "Target": null, "Apollo test code": "TT511XX"}, "Width cap-strip overlap 1": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "W_CPS1", "Target": null, "Apollo test code": "TT511XX"}, "Width cap-strip overlap 2": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "W_CPS", "Target": null, "Apollo test code": "TT511XX"}, "Width cap-strip overlap 3": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "W_CPS3", "Target": null, "Apollo test code": "TT511XX"}, "Cord angle carcass layer 1": {"LSL": null, "LWL": 2, "USL": null, "UWL": 2, "UoM": "°", "Rem.": "A_P1", "Target": 90, "Apollo test code": "PT111XX"}, "Cord angle carcass layer 2": {"LSL": null, "LWL": 2, "USL": null, "UWL": 2, "UoM": "°", "Rem.": "A_P2", "Target": null, "Apollo test code": "PT111XX"}, "Cord angle carcass layer 3": {"LSL": null, "LWL": 2, "USL": null, "UWL": 2, "UoM": "°", "Rem.": "A_P3", "Target": null, "Apollo test code": "PT111XX"}, "Top height Inside Body Ply": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "H_IBP1", "Target": null, "Apollo test code": "TT511XX"}, "Belt 1 Offcentring/Step off": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "X_B1", "Target": null, "Apollo test code": "TT511XX"}, "Belt 2 Offcentring/Step off": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "X_B2", "Target": null, "Apollo test code": "TT511XX"}, "Diameter Sidewall Protection": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "D_SWP", "Target": null, "Apollo test code": "TT511XX"}, "Bottom height Inside Body Ply": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "H_IBP2", "Target": null, "Apollo test code": "TT511XX"}, "Innerliner deviation position": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "H_ILD", "Target": null, "Apollo test code": null}, "Development length bead to bead": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "DL_B2B", "Target": null, "Apollo test code": null}, "Innerliner ending from bead toe": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "H_ILT", "Target": null, "Apollo test code": null}, "Inside tyre periphery (toe to toe)": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "DL_T2T", "Target": 0, "Apollo test code": null}, "Radius on bottom Sidewall Protection": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Rem.": "R_SWP", "Target": null, "Apollo test code": "TT511XX"}}
														 , "Materials and compounds": {"Ply": {"Code": "EC_ME01", "Custom compound": null, "Calculated width": null, "Material/Compound": "Ply", "Custom reinforcement": null, "Proposed green width": null, "Proposed green angle / gauge": 90}, "Belt": {"Code": "EC_KE21", "Custom compound": null, "Calculated width": null, "Material/Compound": "Belt", "Custom reinforcement": null, "Proposed green width": null, "Proposed green angle / gauge": null}, "Ply 2": {"Code": null, "Custom compound": null, "Calculated width": null, "Material/Compound": "Ply 2", "Custom reinforcement": null, "Proposed green width": null, "Proposed green angle / gauge": null}, "Belt 2": {"Code": null, "Custom compound": null, "Calculated width": null, "Material/Compound": "Belt 2", "Custom reinforcement": null, "Proposed green width": null, "Proposed green angle / gauge": null}, "Belt 3": {"Code": null, "Custom compound": null, "Calculated width": null, "Material/Compound": "Belt 3", "Custom reinforcement": null, "Proposed green width": null, "Proposed green angle / gauge": null}, "Capply": {"Code": "EC_DE04", "Custom compound": null, "Calculated width": null, "Material/Compound": "Capply", "Custom reinforcement": null, "Proposed green width": null, "Proposed green angle / gauge": null}, "Chafer": {"Code": null, "Custom compound": null, "Calculated width": null, "Material/Compound": "Chafer", "Custom reinforcement": null, "Proposed green width": null, "Proposed green angle / gauge": null}, "Filler": {"Code": "EM_747", "Custom compound": null, "Calculated width": null, "Material/Compound": "Filler", "Custom reinforcement": null, "Proposed green width": null, "Proposed green angle / gauge": null}, "2n Apex": {"Code": null, "Custom compound": null, "Calculated width": null, "Material/Compound": "2n Apex", "Custom reinforcement": null, "Proposed green width": null, "Proposed green angle / gauge": null}, "Chipper": {"Code": null, "Custom compound": null, "Calculated width": null, "Material/Compound": "Chipper", "Custom reinforcement": null, "Proposed green width": null, "Proposed green angle / gauge": null}, "Filler 2": {"Code": null, "Custom compound": null, "Calculated width": null, "Material/Compound": "Filler 2", "Custom reinforcement": null, "Proposed green width": null, "Proposed green angle / gauge": null}, "Sidewall": {"Code": "EM_721", "Custom compound": null, "Calculated width": null, "Material/Compound": "Sidewall", "Custom reinforcement": null, "Proposed green width": null, "Proposed green angle / gauge": null}, "Squeegee": {"Code": null, "Custom compound": null, "Calculated width": null, "Material/Compound": "Squeegee", "Custom reinforcement": null, "Proposed green width": null, "Proposed green angle / gauge": null}, "Bead wire": {"Code": "GR_5511", "Custom compound": null, "Calculated width": null, "Material/Compound": "Bead wire", "Custom reinforcement": null, "Proposed green width": null, "Proposed green angle / gauge": null}, "Beltstrip": {"Code": null, "Custom compound": null, "Calculated width": null, "Material/Compound": "Beltstrip", "Custom reinforcement": null, "Proposed green width": null, "Proposed green angle / gauge": null}, "Tread cap": {"Code": "EM_775", "Custom compound": null, "Calculated width": null, "Material/Compound": "Tread cap", "Custom reinforcement": null, "Proposed green width": null, "Proposed green angle / gauge": null}, "Innerliner": {"Code": "EM_732", "Custom compound": null, "Calculated width": null, "Material/Compound": "Innerliner", "Custom reinforcement": null, "Proposed green width": 370, "Proposed green angle / gauge": null}, "Rimcushion": {"Code": "EM_741", "Custom compound": null, "Calculated width": null, "Material/Compound": "Rimcushion", "Custom reinforcement": null, "Proposed green width": null, "Proposed green angle / gauge": null}, "Tread cap 2": {"Code": null, "Custom compound": null, "Calculated width": null, "Material/Compound": "Tread cap 2", "Custom reinforcement": null, "Proposed green width": null, "Proposed green angle / gauge": null}, "Tread base 1": {"Code": "EM_722", "Custom compound": null, "Calculated width": null, "Material/Compound": "Tread base 1", "Custom reinforcement": null, "Proposed green width": null, "Proposed green angle / gauge": null}, "Tread base 2": {"Code": "EM_722", "Custom compound": null, "Calculated width": null, "Material/Compound": "Tread base 2", "Custom reinforcement": null, "Proposed green width": null, "Proposed green angle / gauge": null}, "Ply gum strip": {"Code": null, "Custom compound": null, "Calculated width": null, "Material/Compound": "Ply gum strip", "Custom reinforcement": null, "Proposed green width": null, "Proposed green angle / gauge": null}, "Tread wingtip": {"Code": "EM_726", "Custom compound": null, "Calculated width": null, "Material/Compound": "Tread wingtip", "Custom reinforcement": null, "Proposed green width": null, "Proposed green angle / gauge": null}, "Runflat insert": {"Code": null, "Custom compound": null, "Calculated width": null, "Material/Compound": "Runflat insert", "Custom reinforcement": null, "Proposed green width": null, "Proposed green angle / gauge": null}, "White sidewall": {"Code": null, "Custom compound": null, "Calculated width": null, "Material/Compound": "White sidewall", "Custom reinforcement": null, "Proposed green width": null, "Proposed green angle / gauge": null}, "Bead wire compound": {"Code": "EM_700", "Custom compound": null, "Calculated width": null, "Material/Compound": "Bead wire compound", "Custom reinforcement": null, "Proposed green width": null, "Proposed green angle / gauge": null}, "Shoulder gum strip": {"Code": null, "Custom compound": null, "Calculated width": null, "Material/Compound": "Shoulder gum strip", "Custom reinforcement": null, "Proposed green width": null, "Proposed green angle / gauge": null}, "Innerliner technical layer": {"Code": null, "Custom compound": null, "Calculated width": null, "Material/Compound": "Innerliner technical layer", "Custom reinforcement": null, "Proposed green width": null, "Proposed green angle / gauge": null}}
														 , "Building machine settings": {"Bead distance": {"UoM": "mm", "Target": 380}, "Stretching distance": {"UoM": "mm", "Target": null}, "Circumference B&T drum": {"UoM": "mm", "Target": 1821}}
														  }}
	            , "Processing": {"RONTC: BEIDE RONTGENBOX": {"default property group": {"volgnummer": {"Value": 10, "Alternative": null}}}, "UNIFH: UNIFORMITY MACHINE 1,5,6 en 7": {"default property group": {"volgnummer": {"Value": 20, "Alternative": null}}}}
				, "Properties": {"(none)": {"Indoor testing": {"Tyre weight": {"LSL": null, "LWL": 7.39000000000000057, "USL": null, "UWL": 7.69000000000000039, "UoM": "kg", "Legal": null, "Target": 7.54100000000000037, "Apollo test code": "TT520AX", "Approval based upon": null}, "BIS Endurance": {"LSL": 34, "LWL": null, "USL": null, "UWL": null, "UoM": "hours", "Legal": 34, "Target": null, "Apollo test code": "TT741XX", "Approval based upon": null}, "CCC Endurance": {"LSL": 34, "LWL": null, "USL": null, "UWL": null, "UoM": "hours", "Legal": 34, "Target": null, "Apollo test code": "TT743XX", "Approval based upon": null}, "GSO Endurance": {"LSL": 34, "LWL": null, "USL": null, "UWL": null, "UoM": "hours", "Legal": 34, "Target": null, "Apollo test code": "TT742XX", "Approval based upon": null}, "SNI Endurance": {"LSL": 34, "LWL": null, "USL": null, "UWL": null, "UoM": "hours", "Legal": 34, "Target": null, "Apollo test code": "TT744XX", "Approval based upon": null}, "Tyre diameter": {"LSL": 612, "LWL": null, "USL": 628, "UWL": null, "UoM": "mm", "Legal": 628, "Target": 619, "Apollo test code": "TT520AX", "Approval based upon": null}, "CCC High Speed": {"LSL": 60, "LWL": null, "USL": null, "UWL": null, "UoM": "min", "Legal": 60, "Target": null, "Apollo test code": "TT520AX", "Approval based upon": null}, "SNI High Speed": {"LSL": 60, "LWL": null, "USL": null, "UWL": null, "UoM": "min", "Legal": 60, "Target": null, "Apollo test code": "TT735KX", "Approval based upon": null}, "FMVSS Endurance": {"LSL": 34, "LWL": null, "USL": null, "UWL": null, "UoM": "hours", "Legal": 34, "Target": null, "Apollo test code": "TT748XX", "Approval based upon": null}, "FMVSS High Speed": {"LSL": 330, "LWL": null, "USL": null, "UWL": null, "UoM": "min", "Legal": 330, "Target": 330, "Apollo test code": "TT780XX", "Approval based upon": null}, "Tyre width (max)": {"LSL": null, "LWL": null, "USL": 172, "UWL": null, "UoM": "mm", "Legal": 172, "Target": 167, "Apollo test code": "TT520AX", "Approval based upon": null}, "BIS Tyre Strength": {"LSL": 29500, "LWL": null, "USL": null, "UWL": null, "UoM": "Ncm", "Legal": 29500, "Target": 33925, "Apollo test code": "TT763AA", "Approval based upon": null}, "CCC Tyre Strength": {"LSL": 29500, "LWL": null, "USL": null, "UWL": null, "UoM": "Ncm", "Legal": 29500, "Target": 33925, "Apollo test code": "TT762XX", "Approval based upon": null}, "SNI Tyre Strength": {"LSL": 29400, "LWL": null, "USL": null, "UWL": null, "UoM": "Ncm", "Legal": 29400, "Target": 33810, "Apollo test code": "TT764XX", "Approval based upon": null}, "BIS Bead Unseating": {"LSL": 8890, "LWL": null, "USL": null, "UWL": null, "UoM": "N", "Legal": 8890, "Target": 10670, "Apollo test code": "TT711AC", "Approval based upon": null}, "CCC Bead Unseating": {"LSL": 8890, "LWL": null, "USL": null, "UWL": null, "UoM": "N", "Legal": 8890, "Target": 10670, "Apollo test code": "TT711AE", "Approval based upon": null}, "GSO Bead Unseating": {"LSL": 9100, "LWL": null, "USL": null, "UWL": null, "UoM": "N", "Legal": 9100, "Target": 10920, "Apollo test code": "TT711AD", "Approval based upon": null}, "SNI Bead Unseating": {"LSL": 9100, "LWL": null, "USL": null, "UWL": null, "UoM": "N", "Legal": 9100, "Target": 10920, "Apollo test code": "TT711AE", "Approval based upon": null}, "FMVSS Tyre Strength": {"LSL": 29400, "LWL": null, "USL": null, "UWL": null, "UoM": "Ncm", "Legal": 29400, "Target": 33810, "Apollo test code": "TT761AX", "Approval based upon": null}, "Cut section analysis": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": null, "Legal": null, "Target": null, "Apollo test code": "TT501XX", "Approval based upon": null}, "FMVSS Bead Unseating": {"LSL": 8890, "LWL": null, "USL": null, "UWL": null, "UoM": "N", "Legal": 8890, "Target": 10670, "Apollo test code": "TT711AX", "Approval based upon": null}, "Apollo Burst pressure": {"LSL": 14, "LWL": null, "USL": null, "UWL": null, "UoM": "bar", "Legal": null, "Target": null, "Apollo test code": "TT455AA", "Approval based upon": null}, "BIS Endurance (failures)": {"LSL": null, "LWL": null, "USL": 0, "UWL": null, "UoM": "pcs", "Legal": 0, "Target": null, "Apollo test code": "TT741XX", "Approval based upon": null}, "CCC Endurance (failures)": {"LSL": null, "LWL": null, "USL": 0, "UWL": null, "UoM": "pcs", "Legal": 0, "Target": null, "Apollo test code": "TT743XX", "Approval based upon": null}, "GSO Endurance (failures)": {"LSL": null, "LWL": null, "USL": 0, "UWL": null, "UoM": "pcs", "Legal": 0, "Target": null, "Apollo test code": "TT742XX", "Approval based upon": null}, "SNI Endurance (failures)": {"LSL": null, "LWL": null, "USL": 0, "UWL": null, "UoM": "pcs", "Legal": 0, "Target": null, "Apollo test code": "TT744XX", "Approval based upon": null}, "CCC High Speed (failures)": {"LSL": null, "LWL": null, "USL": 0, "UWL": null, "UoM": "pcs", "Legal": 0, "Target": null, "Apollo test code": "TT520AX", "Approval based upon": null}, "GSO Tyre Strength (Rayon)": {"LSL": 18600, "LWL": null, "USL": null, "UWL": null, "UoM": "Ncm", "Legal": 18600, "Target": 21390, "Apollo test code": "TT762XX", "Approval based upon": null}, "SNI High Speed (failures)": {"LSL": null, "LWL": null, "USL": 0, "UWL": null, "UoM": "pcs", "Legal": 0, "Target": null, "Apollo test code": "TT735KX", "Approval based upon": null}, "CCC Endurance low pressure": {"LSL": 1.5, "LWL": null, "USL": null, "UWL": null, "UoM": "hours", "Legal": 1.5, "Target": null, "Apollo test code": "TT743XX", "Approval based upon": null}, "FMVSS Endurance (failures)": {"LSL": null, "LWL": null, "USL": 0, "UWL": null, "UoM": "pcs", "Legal": 0, "Target": null, "Apollo test code": "TT748XX", "Approval based upon": null}, "GSO High Speed Performance": {"LSL": 60, "LWL": null, "USL": null, "UWL": null, "UoM": "min", "Legal": 60, "Target": null, "Apollo test code": "TT735FX", "Approval based upon": null}, "SNI Endurance low pressure": {"LSL": 1.5, "LWL": null, "USL": null, "UWL": null, "UoM": "hours", "Legal": 1.5, "Target": null, "Apollo test code": "TT744XX", "Approval based upon": null}, "Tread Wear Indicator (TWI)": {"LSL": 1.60000000000000009, "LWL": null, "USL": 2.10000000000000009, "UWL": 2.10000000000000009, "UoM": "mm", "Legal": 1.60000000000000009, "Target": null, "Apollo test code": "TT520AX", "Approval based upon": null}, "FMVSS High Speed (failures)": {"LSL": null, "LWL": null, "USL": 0, "UWL": null, "UoM": "pcs", "Legal": 0, "Target": 0, "Apollo test code": "TT780XX", "Approval based upon": null}, "Apollo Electrical Resistance": {"LSL": null, "LWL": null, "USL": 10000, "UWL": null, "UoM": "MOhm", "Legal": null, "Target": 100, "Apollo test code": "TT360AA", "Approval based upon": null}, "FMVSS Endurance low pressure ": {"LSL": 1.5, "LWL": 3, "USL": null, "UWL": null, "UoM": "hours", "Legal": null, "Target": 1.5, "Apollo test code": "TT748XX", "Approval based upon": null}, "CCC Endurance (pressure check)": {"LSL": 95, "LWL": null, "USL": null, "UWL": null, "UoM": "%", "Legal": 95, "Target": null, "Apollo test code": "TT743XX", "Approval based upon": null}, "GSO Endurance (pressure check)": {"LSL": 100, "LWL": null, "USL": null, "UWL": null, "UoM": "%", "Legal": 100, "Target": null, "Apollo test code": "TT742XX", "Approval based upon": null}, "BIS Load/Speed performance test": {"LSL": 60, "LWL": null, "USL": null, "UWL": null, "UoM": "min", "Legal": 60, "Target": null, "Apollo test code": "TT520AX", "Approval based upon": null}, "CCC High Speed (pressure check)": {"LSL": 95, "LWL": null, "USL": null, "UWL": null, "UoM": "%", "Legal": 95, "Target": null, "Apollo test code": "TT520AX", "Approval based upon": null}, "ECE Rolling resistance Labeling": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "kg/ton", "Legal": null, "Target": null, "Apollo test code": "TT351AA", "Approval based upon": null}, "FMVSS Endurance (pressure check)": {"LSL": 100, "LWL": null, "USL": null, "UWL": null, "UoM": "%", "Legal": 100, "Target": null, "Apollo test code": "TT748XX", "Approval based upon": null}, "FMVSS High Speed (pressure check)": {"LSL": 100, "LWL": null, "USL": null, "UWL": null, "UoM": "%", "Legal": 100, "Target": null, "Apollo test code": "TT780XX", "Approval based upon": null}, "Apollo Bead comp, minimum at +0.38": {"LSL": 230, "LWL": 250, "USL": 550, "UWL": 480, "UoM": "daN", "Legal": null, "Target": null, "Apollo test code": "TT457A", "Approval based upon": null}, "Apollo Bead comp, minimum at -0.29": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "daN", "Legal": null, "Target": null, "Apollo test code": "TT457A", "Approval based upon": null}, "Apollo High speed 2 degrees Camber": {"LSL": 75, "LWL": 80, "USL": null, "UWL": null, "UoM": "min", "Legal": 75, "Target": null, "Apollo test code": "TT731XX", "Approval based upon": null}, "BIS Endurance (diameter differences)": {"LSL": null, "LWL": null, "USL": 3.5, "UWL": null, "UoM": "%", "Legal": 3.5, "Target": null, "Apollo test code": "TT741XX", "Approval based upon": null}, "SNI High Speed (diameter difference)": {"LSL": null, "LWL": null, "USL": 3.5, "UWL": null, "UoM": "%", "Legal": 3.5, "Target": null, "Apollo test code": "TT735KX", "Approval based upon": null}, "CCC Endurance low pressure (failures)": {"LSL": null, "LWL": null, "USL": 0, "UWL": null, "UoM": "pcs", "Legal": 0, "Target": null, "Apollo test code": "TT743XX", "Approval based upon": null}, "GSO High Speed Performance (failures)": {"LSL": null, "LWL": null, "USL": 0, "UWL": null, "UoM": "pcs", "Legal": 0, "Target": null, "Apollo test code": "TT520AX", "Approval based upon": null}, "SNI Endurance low pressure (failures)": {"LSL": null, "LWL": null, "USL": 0, "UWL": null, "UoM": "pcs", "Legal": 0, "Target": null, "Apollo test code": "TT744XX", "Approval based upon": null}, "UTQG High Speed Temperature Resistance": {"LSL": 510, "LWL": null, "USL": null, "UWL": null, "UoM": "min", "Legal": 510, "Target": 510, "Apollo test code": "TT781XX", "Approval based upon": null}, "FMVSS Endurance low pressure (failures)": {"LSL": null, "LWL": null, "USL": 0, "UWL": 0, "UoM": "pcs", "Legal": 0, "Target": null, "Apollo test code": "TT748XX", "Approval based upon": null}, "ECE / Inmetro Load speed performance test": {"LSL": 60, "LWL": null, "USL": null, "UWL": null, "UoM": "min", "Legal": 60, "Target": null, "Apollo test code": "TT735XX", "Approval based upon": null}, "BIS Load/Speed performance test (failures)": {"LSL": null, "LWL": null, "USL": 0, "UWL": null, "UoM": "pcs", "Legal": 0, "Target": null, "Apollo test code": "TT520AX", "Approval based upon": null}, "CCC Endurance low pressure (pressure check)": {"LSL": 95, "LWL": null, "USL": null, "UWL": null, "UoM": "%", "Legal": 95, "Target": null, "Apollo test code": "TT743XX", "Approval based upon": null}, "GSO High Speed Performance (pressure check)": {"LSL": 100, "LWL": null, "USL": null, "UWL": null, "UoM": "%", "Legal": 100, "Target": null, "Apollo test code": "TT520AX", "Approval based upon": null}, "FMVSS Endurance low pressure (pressure check)": {"LSL": 100, "LWL": 95, "USL": null, "UWL": null, "UoM": "%", "Legal": 95, "Target": null, "Apollo test code": "TT748XX", "Approval based upon": null}, "Apollo High Speed (extended version of ECE R30)": {"LSL": 65, "LWL": 75, "USL": null, "UWL": null, "UoM": "min", "Legal": 60, "Target": 90, "Apollo test code": "TT729XX", "Approval based upon": "EWE2044060T"}, "ECE / Inmetro Load speed performance test (failures)": {"LSL": null, "LWL": null, "USL": 0, "UWL": null, "UoM": null, "Legal": 0, "Target": null, "Apollo test code": "TT735XX", "Approval based upon": null}, "BIS Load/Speed performance test (diameter differences)": {"LSL": null, "LWL": null, "USL": 3.5, "UWL": null, "UoM": "%", "Legal": 3.5, "Target": null, "Apollo test code": "TT520AX", "Approval based upon": null}, "ECE / Inmetro Load speed performance test (Diameter diff.)": {"LSL": null, "LWL": null, "USL": 3.5, "UWL": null, "UoM": "%", "Legal": 3.5, "Target": null, "Apollo test code": "TT735XX", "Approval based upon": null}}
				                           , "Outdoor testing": {"ECE Noise labeling": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "dB(A)", "Target": null, "SL treshold": null, "Apollo test code": "TT972AA", "Approval based upon": null}, "ECE Snowflake R117": {"LSL": 1.07000000000000006, "LWL": 110, "USL": null, "UWL": null, "UoM": "%", "Target": null, "SL treshold": 107, "Apollo test code": "TT821AA", "Approval based upon": null}, "ECE Wet Grip labeling (trailer)": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "%", "Target": null, "SL treshold": null, "Apollo test code": "TT812AA", "Approval based upon": null}, "ECE Wet Grip labeling (vehicle)": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "%", "Target": null, "SL treshold": null, "Apollo test code": "TT814AA", "Approval based upon": null}}
								           }}
				, "SAP information": {"(none)": {"SAP articlecode": {"Commercial article code": {"Value": "AP16580014HSPCA00"}, "Commercial DA article code": {"Value": null}, "Date of new SAP article code": {"Value": null}}
				                     , "SAP information": {"QR phase": {"Value": "QR4: Pre-launch"}, "Article group PG": {"Value": "TF: BAND   SPRINT+/CLS/GRIP+/SNOW+"}}
									 , "default property group": {"Weight": {"UoM": null, "Value": 1}, "Use for OE": {"Value": "No"}, "Article type": {"Value": "E: Eindprodukten volgordelijk"}, "Packaging PG": {"Amount": 30, "Packaging": "EMPBD"}, "Visual check": {"Value": "Yes"}, "Physical in product": {"Value": "Ja"}}}}
				, "Industrialization": {"(none)": {"default property group": {"QR3 release based upon trial": {"Spec. Ref.": "XEF_E20B365A"}}}}, "General information": {"(none)": {"Size": {"Rimcode": {"Value": "14"}, "Load index": {"Value": "84"}, "Ply rating": {"Value": "No"}, "Speed index": {"Value": "H"}, "Aspect ratio": {"Value": "80"}, "Section width": {"Value": "165"}, "Building method": {"Value": "B"}, "Productlinecode": {"Value": "CLS"}, "Load index (dual)": {"Value": null}}, "Certification": {"ECE R117": {"Description": null, "Approval code": null, "Current certificate validity": null, "Sidewall plates engraved since": null}, "CCC mandatory": {"Description": null, "Approval code": null, "Current certificate validity": null, "Sidewall plates engraved since": null}, "ECE R30 / R54": {"Description": null, "Approval code": null, "Current certificate validity": null, "Sidewall plates engraved since": null}, "GSO certified": {"Description": null, "Approval code": null, "Current certificate validity": null, "Sidewall plates engraved since": null}, "CCC A068723 engraved": {"Description": null, "Approval code": "A068723", "Current certificate validity": null, "Sidewall plates engraved since": null}, "Inmetro 200 engraved": {"Description": null, "Approval code": null, "Current certificate validity": null, "Sidewall plates engraved since": null}, "ISI  CM/L-4034946 engraved": {"Description": null, "Approval code": "CM/L-4034946", "Current certificate validity": null, "Sidewall plates engraved since": null}}, "Test settings": {"h_sidewall": {"UoM": "mm", "Value": 132}, "A dimension": {"UoM": "mm", "Value": 267}, "p_max testing": {"UoM": "kPa", "Value": 350}, "Rimwidth testing": {"UoM": "\"", "Value": 4.5}}, "ETRTO properties": {"ETRTO diameter": {"LSL": null, "USL": null, "UoM": "mm", "Target": 620}, "ETRTO rimwidth": {"LSL": 4, "USL": 5.5, "UoM": "\"", "Target": 4.5}, "ETRTO infl pressure": {"LSL": null, "USL": null, "UoM": "kPa", "Target": 240}, "ETRTO load capacity": {"LSL": null, "USL": null, "UoM": "kg", "Target": 515}, "ETRTO max load axle": {"LSL": null, "USL": null, "UoM": "kg", "Target": 1030}, "ETRTO section width": {"LSL": null, "USL": null, "UoM": "mm", "Target": 165}}, "Sidewall designation": {"Made in ": {"UoM": null, "Value": "THE NETHERLANDS"}, "Max. load": {"UoM": null, "Value": "500 kg (1103 lbs)"}, "Plies tread": {"UoM": null, "Value": "1RAYON + 2STEEL +1NYLON"}, "OEM approval": {"UoM": null, "Value": "No"}, "Max. pressure": {"UoM": "kPa", "Value": "350"}, "DOT Plant Code": {"UoM": null, "Value": "1DV"}, "Plies sidewall": {"UoM": null, "Value": "1RAYON"}, "E-approval code": {"UoM": null, "Value": "E4 0240098"}, "Quality grading": {"UoM": null, "Value": "220 A B"}, "Max. load (dual)": {"UoM": null, "Value": null}, "Size designation": {"UoM": null, "Value": "165/80 R 14 84H"}, "E-appr. code (S/W/R)": {"UoM": null, "Value": " 000411 S"}, "DOT Manufacturers Code": {"UoM": null, "Value": "J1H625"}}, "VR approved rimwidth": {"ETRTO LSL -0.5": {"Value": "N"}, "ETRTO USL +0.5": {"Value": "N"}}, "General tyre characteristics": {"LT": {"Value": null}, "Ply": {"Value": "Rayon"}, "SUV": {"Value": null}, "Brand": {"Value": "Vredestein"}, "Runflat": {"Value": "No"}, "Category": {"Value": "Summer"}, "Structure": {"Value": "Radial"}, "Asymmetric": {"Value": "No"}, "Tyre class": {"Value": "C1"}, "DOT marking": {"Value": "Yes"}, "Directional": {"Value": "No"}, "Productline": {"Value": "Sprint Classic"}, "Machine type": {"Value": "VMI"}, "Re-groovable": {"Value": "No"}, "Rim protector": {"Value": "No"}, "Tyre standard": {"Value": "ETRTO"}, "Vmax Y (km/h)": {"Value": "NA"}, "Safety warning": {"Value": "Yes"}, "ET (Extra tread)": {"Value": "No"}, "Load index class": {"Value": "Normal"}, "Ply construction": {"Value": "1 Up"}, "Traction marking": {"Value": null}, "Tubetype/tubeless": {"Value": null}, "Tyre construction": {"Value": "1R+2S+1N"}, "Winter indication": {"Value": "None"}, "Manufacture date code": {"Value": "Yes"}, "Mold reference number": {"Value": "Yes"}, "ML (Mining and Logging)": {"Value": "No"}, "Inside / outside marking": {"Value": "No"}, "MPT (Multi purpose truck)": {"Value": "No"}, "Tread Wear Indicator (TWI)": {"Value": "Yes"}, "POR (Professional off road)": {"Value": "No"}}}}, "Labels and certification": {"(none)": {"Labels Noise": {"Brasil": {"Noise (dB)": null, "Sound label": null, "Sound waves": null}, "Europe": {"Noise (dB)": null, "Sound label": null, "Sound waves": null}}, "Certification": {"ECE R117": {"Remarks": null, "Certificate": "e4-000411", "Tyre sticker": "No", "Sidewall marking": "e4 000411 S", "Week code validity": "NA", "Current certificate validity": "12/31/2099", "Sidewall plates engraved since": "SOP"}, "ECE R30 / R54": {"Remarks": null, "Certificate": "E4-30R-0240098", "Tyre sticker": "No", "Sidewall marking": "E4 0240098", "Week code validity": "NA", "Current certificate validity": "12/31/2099", "Sidewall plates engraved since": "SOP"}, "LATU (Uruguay)": {"Remarks": null, "Certificate": "LATU Audit Report", "Tyre sticker": "No", "Sidewall marking": "NA", "Week code validity": "NA", "Current certificate validity": "08/31/2021", "Sidewall plates engraved since": "NA"}}, "Labels Wet grip": {"GSO": {"Label": null}, "SASO": {"Label": null}, "Korea": {"Label": null}, "Brasil": {"Label": null}, "Europe": {"Label": null}}, "Quality grading UTQG": {"Traction": {"Label": "A"}, "Tread wear": {"Label": "220"}, "Temperature": {"Label": "B"}}, "Labels Rolling resistance": {"GSO": {"Label": null}, "SASO": {"Label": null}, "Korea": {"Label": null}, "Brasil": {"Label": null}, "Europe": {"Label": null}}}}, "Marketing characteristics": {"(none)": {"Invoice description": {"Invoice description proposal": {"Value": null}}}}}, "Tread.EXTR": {"UoM": "m", "Rev.": null, "SPPL": {"(none)": {"Coordinates": {"Coordinate 00": {"x": 0, "UoM": "mm", "y_C1": 0, "y_C2": 0, "y_C3": 0, "y_C4": 0, "Value": "Coordinate 00", "y_Tot.": 0}, "Coordinate 01": {"x": 0, "UoM": "mm", "y_C1": 0, "y_C2": 0, "y_C3": 0.5, "y_C4": 0, "Value": "Coordinate 01", "y_Tot.": 0.5}, "Coordinate 02": {"x": 5, "UoM": "mm", "y_C1": 0, "y_C2": 0, "y_C3": 2.52380952380952017, "y_C4": 0, "Value": "Coordinate 02", "y_Tot.": 2.52380952380952017}, "Coordinate 03": {"x": 10, "UoM": "mm", "y_C1": 0, "y_C2": 0, "y_C3": 4.5, "y_C4": 0, "Value": "Coordinate 03", "y_Tot.": 4.5}, "Coordinate 04": {"x": 10.5773502707850984, "UoM": "mm", "y_C1": 0, "y_C2": 1, "y_C3": 3.77605678934943967, "y_C4": 0, "Value": "Coordinate 04", "y_Tot.": 4.77605678934943967}, "Coordinate 05": {"x": 11.7320508123552987, "UoM": "mm", "y_C1": 0, "y_C2": 1, "y_C3": 2.32817036804833011, "y_C4": 2, "Value": "Coordinate 05", "y_Tot.": 5.32817036804832966}, "Coordinate 06": {"x": 13, "UoM": "mm", "y_C1": 0.60626278277043999, "y_C2": 1, "y_C3": 2.32817036804833011, "y_C4": 2, "Value": "Coordinate 06", "y_Tot.": 5.93443315081876932}, "Coordinate 07": {"x": 21, "UoM": "mm", "y_C1": 6, "y_C2": 1, "y_C3": 0, "y_C4": 2, "Value": "Coordinate 07", "y_Tot.": 9}, "Coordinate 08": {"x": 35, "UoM": "mm", "y_C1": 6, "y_C2": 1, "y_C3": 0, "y_C4": 2, "Value": "Coordinate 08", "y_Tot.": 9}, "Coordinate 09": {"x": 48, "UoM": "mm", "y_C1": 4.79999999999999982, "y_C2": 1, "y_C3": 0, "y_C4": 2, "Value": "Coordinate 09", "y_Tot.": 7.79999999999999982}, "Coordinate 10": {"x": 68, "UoM": "mm", "y_C1": 4, "y_C2": 1, "y_C3": 0, "y_C4": 2, "Value": "Coordinate 10", "y_Tot.": 7}, "Coordinate 11": {"x": 83, "UoM": "mm", "y_C1": 4, "y_C2": 1, "y_C3": 0, "y_C4": 2, "Value": "Coordinate 11", "y_Tot.": 7}, "Coordinate 12": {"x": 98, "UoM": "mm", "y_C1": 4, "y_C2": 1, "y_C3": 0, "y_C4": 2, "Value": "Coordinate 12", "y_Tot.": 7}, "Coordinate 13": {"x": 118, "UoM": "mm", "y_C1": 4.79999999999999982, "y_C2": 1, "y_C3": 0, "y_C4": 2, "Value": "Coordinate 13", "y_Tot.": 7.79999999999999982}, "Coordinate 14": {"x": 131, "UoM": "mm", "y_C1": 6, "y_C2": 1, "y_C3": 0, "y_C4": 2, "Value": "Coordinate 14", "y_Tot.": 9}, "Coordinate 15": {"x": 145, "UoM": "mm", "y_C1": 6, "y_C2": 1, "y_C3": 0, "y_C4": 2, "Value": "Coordinate 15", "y_Tot.": 9}, "Coordinate 16": {"x": 153, "UoM": "mm", "y_C1": 0.60626278277043999, "y_C2": 1, "y_C3": 2.32817036804833011, "y_C4": 2, "Value": "Coordinate 16", "y_Tot.": 5.93443315081876932}, "Coordinate 17": {"x": 154.200000000000017, "UoM": "mm", "y_C1": 0, "y_C2": 1, "y_C3": 2.32817036804833011, "y_C4": 2, "Value": "Coordinate 17", "y_Tot.": 5.32817036804832966}, "Coordinate 18": {"x": 155.400000000000006, "UoM": "mm", "y_C1": 0, "y_C2": 1, "y_C3": 3.77605678934943967, "y_C4": 0, "Value": "Coordinate 18", "y_Tot.": 4.77605678934943967}, "Coordinate 19": {"x": 156, "UoM": "mm", "y_C1": 0, "y_C2": 0, "y_C3": 4.5, "y_C4": 0, "Value": "Coordinate 19", "y_Tot.": 4.5}, "Coordinate 20": {"x": 161, "UoM": "mm", "y_C1": 0, "y_C2": 0, "y_C3": 2.52380952380952017, "y_C4": 0, "Value": "Coordinate 20", "y_Tot.": 2.52380952380952017}, "Coordinate 21": {"x": 166, "UoM": "mm", "y_C1": 0, "y_C2": 0, "y_C3": 0.5, "y_C4": 0, "Value": "Coordinate 21", "y_Tot.": 0.5}, "Coordinate 22": {"x": 166, "UoM": "mm", "y_C1": 0, "y_C2": 0, "y_C3": 0, "y_C4": 0, "Value": "Coordinate 22", "y_Tot.": 0}}, "Tread characteristics": {"Triplex angle ß": {"UoM": "°", "Value": 60}, "Position centerline": {"UoM": "mm", "Value": 83}, "Thickness centerline": {"UoM": "mm", "Value": 7}}, "default property group": {"Symmetric extrudate": {"Value": "Y"}, "Extrudate construction": {"Value": "Quadruplex tread"}}, "Extrudate characteristics": {"Area": {"x": null, "C1": 657.998215133281974, "C2": 145.411324864607025, "C3": 86.6679866986878977, "C4": 287.290598916860006, "C5": null, "UoM": "mm²", "Total": 1177.36812561344004, "Value": "Area"}}}}, "Config": {"(none)": {"default property group": {"Base UoM": {"Value": "m"}}}}, "Part No": "ET_LV172", "part_no": "ET_LV172", "Quantity": 1.840119, "revision": 35, "Packaging": null, "preferred": 1, "Processing": {"QUADR": {"Tooling": {"Die": {"Value": "DQ158"}, "Preformer": {"Value": "PQ134"}}, "default property group": {"volgnummer": {"Value": 10}, "BOM alternative": {"Plant": "Ens", "Usage": null, "Alternative": null}}}, "General": {"default property group": {"Work away tread": {"Description": null}}}}, "Properties": {"(none)": {"Typical weight": {"Typical weight": {"UoM": "kg", "Target": 1.31706589428273002, "Cr. par.": "N", "+ tol [%]": 7, "- tol [%]": -7, "Apollo test code": null}}, "default property group": {"maatcode: stempelen uit center tussen": {"Low": 5, "UoM": "mm", "High": 34}}, "Main extrudate dimensions": {"Total width": {"UoM": "mm", "+ tol": 3.5, "- tol": -3.5, "Target": 166, "Cr. par.": "N", "Apollo test code": null}, "Shoulder width": {"UoM": "mm", "+ tol": 3, "- tol": -3, "Target": 124, "Cr. par.": "N", "Apollo test code": null}}}}, "Description": "GREENTYRE  SPRINT CLASSIC", "Item Number": 130, "alternative": 1, "FUNCTIONCODE": "Tread", "SAP information": {"(none)": {"Aging SAP": {"Aging (Maximal)": {"UoM": "day", "Value": 21}, "Aging (minimal)": {"UoM": "hours", "Value": 4}}, "default property group": {"Weight": {"UoM": null, "Value": 1}, "Use for OE": {"Value": "No"}, "Article type": {"Value": "H: Halffabrikaten Volgordelijk"}, "Packaging PG": {"Amount": 75, "Packaging": "HSP75"}, "Article group PG": {"Value": "L7: PB LOOPVLAKKEN KLEINE SERIES  "}, "Physical in product": {"Value": "Yes"}}}}, "Aging min. (hrs)": null, "Aging max. (days)": null, "Position in machine": null}, "Belt_1.ASSEM": {"UoM": "m", "Rev.": null, "Part No": "ER_KE21-25-130STR", "part_no": "ER_KE21-25-130STR", "Quantity": 1.824000, "revision": 1, "Packaging": null, "preferred": 1, "Processing": {"SCCUT: STAALKOORD CUTTER": {"default property group": {"volgnummer": {"Value": 10, "Alternative": null}}}}, "Properties": {"(none)": {"STRAM": {"Gauge": {"UoM": null, "+ tol": 0.119999999999999996, "- tol": -0.119999999999999996, "Target": 0.75, "Cr. par.": "N", "Apollo test code": null}, "Width": {"UoM": null, "+ tol": 4, "- tol": -4, "Target": 20, "Cr. par.": "N", "Apollo test code": null}}, "Dimensions SFP": {"Angle": {"UoM": "°", "+ tol": 0.5, "- tol": -0.5, "Target": 25, "Cr. par.": "N", "Apollo test code": null}, "Width": {"UoM": "mm", "+ tol": 1.5, "- tol": -1.5, "Target": 130, "Cr. par.": "N", "Apollo test code": null}}}}, "Description": "GREENTYRE  SPRINT CLASSIC", "Item Number": 100, "alternative": 1, "FUNCTIONCODE": "Belt 1", "SAP information": {"(none)": {"Aging SAP": {"Aging (Maximal)": {"UoM": "day", "Value": 30}, "Aging (minimal)": {"UoM": "hours", "Value": 0}}, "default property group": {"Weight": {"UoM": null, "Value": 1}, "Article type": {"Value": "H: Halffabrikaten Volgordelijk"}, "Packaging PG": {"Amount": 150, "Packaging": "LN250: LN250"}, "Article group PG": {"Value": "LZ: STAALKOORD (GESNEDEN) +STROKEN"}, "Physical in product": {"Value": "Yes"}}}}, "Aging min. (hrs)": null, "Aging max. (days)": null, "Position in machine": null}, "Belt_2.ASSEM": {"UoM": "m", "Rev.": null, "Part No": "ER_KE21-25-120", "part_no": "ER_KE21-25-120", "Quantity": 1.831000, "revision": 8, "Packaging": null, "preferred": 1, "Processing": {"FCUTR: FISCHER-CUTTER": {"default property group": {"volgnummer": {"Value": 20, "Alternative": null}}}, "SCCUT: STAALKOORD CUTTER": {"default property group": {"volgnummer": {"Value": 10, "Alternative": null}}}}, "Properties": {"(none)": {"Dimensions SFP": {"Angle": {"UoM": "°", "+ tol": 0.5, "- tol": -0.5, "Target": 25, "Cr. par.": "N", "Apollo test code": null}, "Width": {"UoM": "mm", "+ tol": 1.5, "- tol": -1.5, "Target": 120, "Cr. par.": "N", "Apollo test code": null}}}}, "Description": "GREENTYRE  SPRINT CLASSIC", "Item Number": 110, "alternative": 1, "FUNCTIONCODE": "Belt 2", "SAP information": {"(none)": {"Aging SAP": {"Aging (Maximal)": {"UoM": "day", "Value": 30}, "Aging (minimal)": {"UoM": "hours", "Value": 0}}, "default property group": {"Weight": {"UoM": null, "Value": 1}, "Article type": {"Value": "I: Halffabrikaten Alternatief"}, "Packaging PG": {"Amount": 150, "Packaging": "LN250: LN250"}, "Article group PG": {"Value": "L6: GESNEDEN STAALKOORD           "}, "Physical in product": {"Value": "Yes"}}}}, "Aging min. (hrs)": null, "Aging max. (days)": null, "Position in machine": null}, "Capstrip.ASSEM": {"UoM": "m", "Rev.": null, "Part No": "ER_DE04-00-0012", "part_no": "ER_DE04-00-0012", "Quantity": 22.030000, "revision": 15, "Packaging": null, "preferred": 1, "Processing": {"MSLIT: Minislitter": {"default property group": {"volgnummer": {"Value": 10}}}}, "Properties": {"(none)": {"Dimensions SFP": {"Angle": {"UoM": "°", "+ tol": null, "- tol": null, "Target": 0, "Cr. par.": "N", "Apollo test code": null}, "Width": {"UoM": "mm", "+ tol": 1, "- tol": -1, "Target": 12, "Cr. par.": "N", "Apollo test code": null}}}}, "Description": "GREENTYRE  SPRINT CLASSIC", "Item Number": 120, "alternative": 1, "FUNCTIONCODE": "Capstrip", "SAP information": {"(none)": {"Aging SAP": {"Aging (Maximal)": {"UoM": "day", "Value": 14}, "Aging (minimal)": {"UoM": "hours", "Value": 0}}, "default property group": {"Article type": {"Value": "H: Halffabrikaten Volgordelijk"}, "Packaging PG": {"Amount": 2800, "Packaging": "KLOS"}, "Article group PG": {"Value": "L9: NOH EN GORDEL-STRIPS          "}, "Physical in product": {"Value": "Yes"}}}}, "Aging min. (hrs)": null, "Aging max. (days)": null, "Position in machine": null}, "Greentyre.PCR_GT": {"UoM": "pcs", "Rev.": null, "Config": {"(none)": {"default property group": {"Base UoM": {"Value": "pcs"}}}}, "Part No": "EG_BH168014CLS-G", "part_no": "EG_BH168014CLS-G", "Quantity": 1.000000, "revision": 5, "Packaging": null, "preferred": 1, "Processing": {"General": {"Process capstrip": {"Phase 1": {"Width [mm]": 0, "Degrees [°]": 346, "Pre-stress [N]": 30, "Pitch [mm/rev.]": 0.100000000000000006}, "Phase 2": {"Width [mm]": 0, "Degrees [°]": 1814, "Pre-stress [N]": 30, "Pitch [mm/rev.]": 12.5}}, "Remarks processing": {"Stempel opties": {"Value": null}, "Ring / centerdeck options": {"Value": "20\\125"}}, "default property group": {"Recipe no.": {"Value": "019"}}, "Building machine settings": {"PA width": {"UoM": null, "+ tol": null, "- tol": null, "Target": 686, "Cr. par.": "N", "Apollo test code": null}, "Bead distance": {"UoM": "mm", "+ tol": null, "- tol": null, "Target": 380, "Cr. par.": "N", "Apollo test code": null}, "Lift belt package": {"UoM": "%", "+ tol": null, "- tol": null, "Target": 2.18000000000000016, "Cr. par.": "N", "Apollo test code": null}, "Circumference B&T drum": {"UoM": "mm", "+ tol": null, "- tol": null, "Target": 1821, "Cr. par.": "N", "Apollo test code": null}, "Circumference carcass drum": {"UoM": "mm", "+ tol": null, "- tol": null, "Target": 1052, "Cr. par.": "N", "Apollo test code": null}, "PA overlap (sidewall / innerliner)": {"UoM": null, "+ tol": null, "- tol": null, "Target": 9.5, "Cr. par.": "N", "Apollo test code": null}}}, "HPBMG: HALFAUTOMAAT  92": {"Tooling": {"Ringwidth": {"Value": "LR14-20"}, "B&T spacer": {"Value": "ABWKK-24.50"}, "B&T stamps": {"Value": "550-650"}, "Centerdeck": {"Value": "MS14-095"}, "Building drum": {"Value": "BTS14"}, "Roll over can": {"Value": "OSR500"}, "Bead transfer ring": {"Value": "HAR14  TYPE2"}, "Spacer PA applicator": {"Value": "ABDRUM 14\""}}, "default property group": {"volgnummer": {"Value": 20}}, "Building machine settings": {"Shaping distance": {"UoM": "mm", "+ tol": null, "- tol": null, "Target": 254, "Cr. par.": "N", "Apollo test code": null}, "Turn-up distance": {"UoM": "mm", "+ tol": null, "- tol": null, "Target": 324, "Cr. par.": "N", "Apollo test code": null}, "Preshaping distance": {"UoM": "mm", "+ tol": null, "- tol": null, "Target": 312, "Cr. par.": "N", "Apollo test code": null}}}, "HPBMA: HALFAUTOMATEN 82,84,86,88": {"Tooling": {"Ringwidth": {"Value": "LR14-20"}, "B&T spacer": {"Value": "ABWKK-24.50"}, "B&T stamps": {"Value": "545-645"}, "Centerdeck": {"Value": "MS14-095"}, "Building drum": {"Value": "BTS14"}, "Roll over can": {"Value": "OSR500"}, "Bead transfer ring": {"Value": "HAR14  TYPE1"}, "Spacer PA applicator": {"Value": "ABDRUM 14\""}}, "default property group": {"volgnummer": {"Value": 10}}, "Building machine settings": {"Shaping distance": {"UoM": "mm", "+ tol": null, "- tol": null, "Target": 254, "Cr. par.": "N", "Apollo test code": null}, "Turn-up distance": {"UoM": "mm", "+ tol": null, "- tol": null, "Target": 324, "Cr. par.": "N", "Apollo test code": null}, "Tread table height": {"UoM": "mm", "+ tol": null, "- tol": null, "Target": 583, "Cr. par.": "N", "Apollo test code": null}, "Preshaping distance": {"UoM": "mm", "+ tol": null, "- tol": null, "Target": 312, "Cr. par.": "N", "Apollo test code": null}}}}, "Properties": {"(none)": {"Greentyre properties": {"Overlap capply": {"UoM": "mm", "+ tol": null, "- tol": null, "Target": null, "Cr. par.": "N", "Apollo test code": null}, "Total width capstrip": {"UoM": "mm", "+ tol": null, "- tol": null, "Target": 138, "Cr. par.": "N", "Apollo test code": null}, "Circumference greentyre": {"UoM": "mm", "+ tol": null, "- tol": null, "Target": 1888, "Cr. par.": "N", "Apollo test code": null}, "Number of capply layers": {"UoM": null, "+ tol": null, "- tol": null, "Target": 1, "Cr. par.": "N", "Apollo test code": null}, "Circumference shape to tread": {"UoM": "mm", "+ tol": null, "- tol": null, "Target": 1884, "Cr. par.": "N", "Apollo test code": null}, "Sidewall distance (in turnup pos.)": {"UoM": "mm", "+ tol": null, "- tol": null, "Target": 100, "Cr. par.": "N", "Apollo test code": null}}, "Construction parameters": {"2 ply": {"Value": "N"}, "BEC strip": {"Value": "N"}, "Endless capply": {"Value": "Y"}, "88 degrees plies": {"Value": "N"}, "Sidewall over tread": {"Value": "N"}, "Rimcushion under bead": {"Value": "Y"}, "extra pressing of carcass splice": {"Value": "N"}}}}, "Description": "   165 HR 14  84H SPRINT CLASSIC", "Item Number": 10, "alternative": 1, "FUNCTIONCODE": "Greentyre", "SAP information": {"(none)": {"Aging SAP": {"Aging (Maximal)": {"UoM": null, "Value": 31}}, "default property group": {"Weight": {"UoM": null, "Value": 1}, "Use for OE": {"Value": null}, "Article type": {"Value": "G: Greentyres Alternatief"}, "Packaging PG": {"Amount": 30, "Packaging": "PLR5: Rek 5"}, "Article group PG": {"Value": "NU: GREENTYRE CLASSIC/SPRINT      "}, "Physical in product": {"Value": "Yes"}}}}, "Aging min. (hrs)": null, "Aging max. (days)": null, "Position in machine": null}, "Belt_1.Belt_gum.ASSEM": {"UoM": "m", "Rev.": null, "Part No": "EX_Y40", "part_no": "EX_Y40", "Quantity": 1.000000, "revision": 6, "Packaging": null, "preferred": 1, "Processing": {"ORION": {"default property group": {"volgnummer": {"Value": 10}}}}, "Properties": {"(none)": {"Dimensions SFP": {"Gauge": {"UoM": "mm", "+ tol": 0.119999999999999996, "- tol": -0.119999999999999996, "Target": 0.75, "Cr. par.": "N", "Apollo test code": null}, "Width": {"UoM": "mm", "+ tol": 1, "- tol": -1, "Target": 40, "Cr. par.": "N", "Apollo test code": null}}}}, "Description": "GORDELMATERIAAL WIT + stroken 755 0.75x20 (2x)", "Item Number": 20, "alternative": 1, "FUNCTIONCODE": "Belt gum", "SAP information": {"(none)": {"default property group": {"Weight": {"UoM": null, "Value": 1}, "Article type": {"Value": "H: Halffabrikaten Volgordelijk"}, "Packaging PG": {"Amount": 200, "Packaging": "LNPVC"}, "Article group PG": {"Value": "L2: VOERING EN RUBBERSTROOKJES (P)"}, "Physical in product": {"Value": "Yes"}}}}, "Aging min. (hrs)": null, "Aging max. (days)": null, "Position in machine": null}, "Vulcanized tyre.PCR_VULC": {"UoM": "pcs", "Rev.": null, "Config": {"(none)": {"default property group": {"Base UoM": {"Value": "pcs"}}}}, "Part No": "EV_BH165/80R14CLS", "part_no": "EV_BH165/80R14CLS", "Quantity": 1.000000, "revision": 4, "Packaging": null, "preferred": 1, "Processing": {"NSPSM": {"Tooling": {"Bladder": {"Value": null}, "Segment": {"Value": "RSV6084-A"}, "Container": {"Value": null}, "SLUG S37 LT": {"Value": null}, "SLUG S13 CCC": {"Value": null}, "SLUG S17 SNI": {"Value": null}, "SLUG S18 ISI": {"Value": null}, "SLUG S28 M+S": {"Value": null}, "SLUG S38 BPS": {"Value": null}, "Beadring Krupp": {"Value": "K44B-SP-S"}, "SLUG S46 ALPINE": {"Value": null}, "SLUG S14 INMETRO": {"Value": null}, "SLUG S32 MADE IN": {"Value": null}, "SLUG S33 DOT PLANT": {"Value": null}, "SLUG S36 PR RATING": {"Value": null}, "Bajonet adaptor ring": {"Value": null}, "SLUG S47 Week number": {"Value": null}, "SLUG S01 Press number": {"Value": null}, "SLUG S22 CONSTRUCTION": {"Value": null}, "SLUG S3 E4-30R number": {"Value": null}, "Bladder clamping rings": {"Value": null}, "SLUG S24 RADIAL TUBELESS": {"Value": null}, "SLUG S25 RADIAL TUBETYPE": {"Value": null}, "SLUG S34 DOT MANUFACTURER": {"Value": null}, "SLUG S21 MAX LOAD / PRESSURE": {"Value": null}, "SLUG S39 MAX LOAD / PRESSURE": {"Value": null}, "SLUG S20 SPEED INDEX LOAD INDEX": {"Value": null}, "SLUG S40 TEST INFLATION PRESSURE": {"Value": null}, "SLUG S35 DOT PLANT & MANUFACTURER": {"Value": null}, "SLUG S23 RADIAL TUBELESS EXTRA LOAD": {"Value": null}}, "Vulcanisation Recipe": {"Recipe No. (steam)": {"Value": null}, "Recipe No. (nitrogen)": {"Value": "H168014CLS"}}, "default property group": {"TPM": {"Description": "999"}, "volgnummer": {"Value": 40}}}, "General": {"default property group": {"Curing critical point": {"Value": null}, "Third shaping pressure": {"Value": "N"}}, "Curing settings (nitrogen)": {"Curing time (steam)": {"UoM": "min", "+ tol": null, "- tol": null, "Target": 3, "Cr. par.": "N", "Apollo test code": null}, "Curing time (total)": {"UoM": "min", "+ tol": null, "- tol": null, "Target": 10, "Cr. par.": "N", "Apollo test code": null}, "Mould temperature (steam)": {"UoM": "°C", "+ tol": 4, "- tol": 4, "Target": 177, "Cr. par.": "N", "Apollo test code": null}, "Bladder temperature (steam)": {"UoM": "°C", "+ tol": 4, "- tol": 4, "Target": 198, "Cr. par.": "N", "Apollo test code": null}, "Mould temperature (nitrogen)": {"UoM": "°C", "+ tol": 4, "- tol": 4, "Target": 177, "Cr. par.": "N", "Apollo test code": null}, "Bladder temperature (nitrogen)": {"UoM": "°C", "+ tol": null, "- tol": null, "Target": 170, "Cr. par.": "N", "Apollo test code": null}}}}, "Description": "    165 HR 14  84H Sprint Classic", "Item Number": 10, "alternative": 1, "FUNCTIONCODE": "Vulcanized tyre", "SAP information": {"(none)": {"default property group": {"Weight": {"UoM": null, "Value": 1}, "Use for OE": {"Value": "No"}, "Article type": {"Value": "V: Vulkanisatie output Alternatief"}, "Packaging PG": {"Amount": 30, "Info 1": "(4X7+2)", "Packaging": "EMPBD"}, "Article group PG": {"Value": "PF: VULK   SPRINT+/CLS/GRIP+/SNOW+"}, "Physical in product": {"Value": "Yes"}}}}, "Aging min. (hrs)": null, "Aging max. (days)": null, "Position in machine": null}, "Belt_1.Composite.STEELCOMP": {"UoM": "m²", "Rev.": null, "Part No": "EC_KE21", "part_no": "EC_KE21", "Quantity": 0.130000, "revision": 16, "Packaging": null, "preferred": 1, "Processing": {"KAL04: Calander 4": {"Processing Calender 4": {"Liner": {"Value": "BB GG"}, "Prickling": {"Value": "Nee"}, "Steelcord comb": {"Value": "KS-95-B (ART.610.1941)"}, "Ventilation yarn": {"Value": "Nee"}, "Identification yarn": {"Value": "2/2 Wi"}}, "default property group": {"volgnummer": {"Value": 10}}}}, "Properties": {"(none)": {"default property group": {"Main application": {"Value": "Belt PCT >= 175  & 185/70"}}, "Properties steelcord composites": {"Endcount": {"LSL": 93, "LWL": null, "USL": 97, "UWL": null, "UoM": "ends/dm", "Target": 95, "Cr. par.": "Y", "Apollo test code": null}, "K-factor": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": null, "Target": null, "Cr. par.": "N", "Apollo test code": null}, "Insulation top": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Target": 0.275000000000000022, "Cr. par.": "N", "Apollo test code": null}, "Calandered width": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "m", "Target": 121.299999999999997, "Cr. par.": "N", "Apollo test code": null}, "Density rack no.": {"LSL": 1.91000000000000014, "LWL": null, "USL": 2.06000000000000005, "UWL": null, "UoM": "g/cm³", "Target": 1.97999999999999998, "Cr. par.": "N", "Apollo test code": null}, "Insulation bottom": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Target": 0.275000000000000022, "Cr. par.": "N", "Apollo test code": null}, "Calendered material thickness": {"LSL": 1.07000000000000006, "LWL": null, "USL": 1.22999999999999998, "UWL": null, "UoM": "mm", "Target": 1.15000000000000013, "Cr. par.": "Y", "Apollo test code": null}, "Calendered material weight per m2": {"LSL": 2191, "LWL": null, "USL": 2371, "UWL": null, "UoM": "g/m²", "Target": 2281, "Cr. par.": "N", "Apollo test code": null}}, "Adhesion testing steelcord composites": {"Adhesion Pull out force 20' at 160°C to RM752": {"LSL": null, "LWL": 345, "USL": null, "UWL": null, "UoM": "N", "Target": 385, "Cr. par.": "Y", "Apollo test code": "TP102AA"}}}}, "Controlplan": {"(none)": {"Controlplan steelcord composites": {"Endcount": {"Report": null, "Sample size": 1, "Interval type": "Supplier", "Reaction plan": null, "Responsibility": "production", "Apollo test code": null, "Sampling interval": 1}, "Density rack no.": {"Report": null, "Sample size": 1, "Interval type": "Roll", "Reaction plan": null, "Responsibility": "production", "Apollo test code": null, "Sampling interval": 2}, "Insulation top/bottom": {"Report": null, "Sample size": 1, "Interval type": "Roll", "Reaction plan": null, "Responsibility": "production", "Apollo test code": null, "Sampling interval": 10}, "Adh. T-test 20' at 160°C": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP102AA", "Sampling interval": 1}, "Calendered material thickness": {"Report": null, "Sample size": 1, "Interval type": "Roll", "Reaction plan": null, "Responsibility": "production", "Apollo test code": null, "Sampling interval": 2}, "Calendered material weight per m2": {"Report": null, "Sample size": 1, "Interval type": "Roll", "Reaction plan": null, "Responsibility": "production", "Apollo test code": null, "Sampling interval": 2}}}}, "Description": "GORDELMATERIAAL WIT + stroken 755 0.75x20 (2x)", "Item Number": 10, "alternative": 1, "FUNCTIONCODE": "Composite", "SAP information": {"(none)": {"Aging SAP": {"Aging (Maximal)": {"UoM": null, "Value": 30}, "Aging (minimal)": {"UoM": null, "Value": 4}}, "default property group": {"Weight": {"UoM": null, "Value": 1}, "Article type": {"Value": "H: Halffabrikaten Volgordelijk"}, "Packaging PG": {"Amount": 345, "Packaging": "SS300"}, "Article group PG": {"Value": "LC: STAALKOORD (GEKALANDERD)      "}, "Physical in product": {"Value": "Yes"}}}}, "Aging min. (hrs)": null, "Aging max. (days)": null, "Position in machine": null}, "Belt_2.Composite.STEELCOMP": {"UoM": "m²", "Rev.": null, "Part No": "EC_KE21", "part_no": "EC_KE21", "Quantity": 0.120000, "revision": 16, "Packaging": null, "preferred": 1, "Processing": {"KAL04: Calander 4": {"Processing Calender 4": {"Liner": {"Value": "BB GG"}, "Prickling": {"Value": "Nee"}, "Steelcord comb": {"Value": "KS-95-B (ART.610.1941)"}, "Ventilation yarn": {"Value": "Nee"}, "Identification yarn": {"Value": "2/2 Wi"}}, "default property group": {"volgnummer": {"Value": 10}}}}, "Properties": {"(none)": {"default property group": {"Main application": {"Value": "Belt PCT >= 175  & 185/70"}}, "Properties steelcord composites": {"Endcount": {"LSL": 93, "LWL": null, "USL": 97, "UWL": null, "UoM": "ends/dm", "Target": 95, "Cr. par.": "Y", "Apollo test code": null}, "K-factor": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": null, "Target": null, "Cr. par.": "N", "Apollo test code": null}, "Insulation top": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Target": 0.275000000000000022, "Cr. par.": "N", "Apollo test code": null}, "Calandered width": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "m", "Target": 121.299999999999997, "Cr. par.": "N", "Apollo test code": null}, "Density rack no.": {"LSL": 1.91000000000000014, "LWL": null, "USL": 2.06000000000000005, "UWL": null, "UoM": "g/cm³", "Target": 1.97999999999999998, "Cr. par.": "N", "Apollo test code": null}, "Insulation bottom": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "mm", "Target": 0.275000000000000022, "Cr. par.": "N", "Apollo test code": null}, "Calendered material thickness": {"LSL": 1.07000000000000006, "LWL": null, "USL": 1.22999999999999998, "UWL": null, "UoM": "mm", "Target": 1.15000000000000013, "Cr. par.": "Y", "Apollo test code": null}, "Calendered material weight per m2": {"LSL": 2191, "LWL": null, "USL": 2371, "UWL": null, "UoM": "g/m²", "Target": 2281, "Cr. par.": "N", "Apollo test code": null}}, "Adhesion testing steelcord composites": {"Adhesion Pull out force 20' at 160°C to RM752": {"LSL": null, "LWL": 345, "USL": null, "UWL": null, "UoM": "N", "Target": 385, "Cr. par.": "Y", "Apollo test code": "TP102AA"}}}}, "Controlplan": {"(none)": {"Controlplan steelcord composites": {"Endcount": {"Report": null, "Sample size": 1, "Interval type": "Supplier", "Reaction plan": null, "Responsibility": "production", "Apollo test code": null, "Sampling interval": 1}, "Density rack no.": {"Report": null, "Sample size": 1, "Interval type": "Roll", "Reaction plan": null, "Responsibility": "production", "Apollo test code": null, "Sampling interval": 2}, "Insulation top/bottom": {"Report": null, "Sample size": 1, "Interval type": "Roll", "Reaction plan": null, "Responsibility": "production", "Apollo test code": null, "Sampling interval": 10}, "Adh. T-test 20' at 160°C": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP102AA", "Sampling interval": 1}, "Calendered material thickness": {"Report": null, "Sample size": 1, "Interval type": "Roll", "Reaction plan": null, "Responsibility": "production", "Apollo test code": null, "Sampling interval": 2}, "Calendered material weight per m2": {"Report": null, "Sample size": 1, "Interval type": "Roll", "Reaction plan": null, "Responsibility": "production", "Apollo test code": null, "Sampling interval": 2}}}}, "Description": "GORDELMATERIAAL WIT", "Item Number": 10, "alternative": 1, "FUNCTIONCODE": "Composite", "SAP information": {"(none)": {"Aging SAP": {"Aging (Maximal)": {"UoM": null, "Value": 30}, "Aging (minimal)": {"UoM": null, "Value": 4}}, "default property group": {"Weight": {"UoM": null, "Value": 1}, "Article type": {"Value": "H: Halffabrikaten Volgordelijk"}, "Packaging PG": {"Amount": 345, "Packaging": "SS300"}, "Article group PG": {"Value": "LC: STAALKOORD (GEKALANDERD)      "}, "Physical in product": {"Value": "Yes"}}}}, "Aging min. (hrs)": null, "Aging max. (days)": null, "Position in machine": null}, "Tread.Base_1_compound.Base.FM": {"UoM": "kg", "Rev.": null, "Part No": "EM_722", "part_no": "EM_722", "Quantity": 0.158498, "revision": 67, "Packaging": null, "preferred": 1, "Processing": {"General": {"Shelf life": {"Shelf life max. (after production)": {"LSL": null, "USL": 4, "UoM": "week"}, "Shelf life min. (after production)": {"LSL": 4, "USL": null, "UoM": "hours"}}, "Extruded densities": {"Extruded density OHT": {"UoM": "g/cm³", "Value": 1.09000000000000008}, "Extruded density Triplex": {"UoM": "g/cm³", "Value": 1.09000000000000008}, "Extruded density Quadruplex": {"UoM": "g/cm³", "Value": 1.09000000000000008}}}, "MNG04: Mixer 4": {"Slittered": {"Batches per pallet": {"Value": 4}, "Number of strips slittered": {"Value": 2}}, "Mixer recipe": {"Mixer recipe 1": {"Value": "722048"}}, "Mixerproperties": {"Load factor": {"UoM": "%", "Calc": "N", "Target": 71.73520112920977}, "Mixervolume": {"UoM": "l", "Calc": "N", "Target": 242}, "Total batch volume": {"UoM": "l", "Calc": "N", "Target": 173.599186732688025}, "Total batch weight": {"UoM": "kg", "Calc": "N", "Target": 195.997818213182001}, "First component weight": {"UoM": "kg", "Calc": "Y", "Target": 190.319999999999993}}, "Slab dimensions": {"slab width": {"Set": 58, "UoM": "cm", "+ tol": 7, "- tol": 3, "Target": 59}, "slab thickness": {"Set": 6.29999999999999982, "UoM": "mm", "+ tol": 2, "- tol": 2, "Target": 8}}, "default property group": {"volgnummer": {"Value": 10}, "BOM alternative": {"Plant": "Ens", "Usage": null, "Alternative": "2"}}}, "MNG05: Mixer 5": {"Slittered": {"Batches per pallet": {"Value": 2}, "Number of strips slittered": {"Value": 2}}, "Mixer recipe": {"Mixer recipe 1": {"Value": "722048"}}, "Mixerproperties": {"Load factor": {"UoM": "%", "Calc": "N", "Target": 71.73520112920977}, "Mixervolume": {"UoM": "l", "Calc": "N", "Target": 242}, "Total batch volume": {"UoM": "l", "Calc": "N", "Target": 173.599186732688025}, "Total batch weight": {"UoM": "kg", "Calc": "N", "Target": 195.997818213182001}, "First component weight": {"UoM": "kg", "Calc": "Y", "Target": 190.319999999999993}}, "Slab dimensions": {"slab width": {"Set": 58, "UoM": "cm", "+ tol": 7, "- tol": 3, "Target": 59}, "slab thickness": {"Set": 6.29999999999999982, "UoM": "mm", "+ tol": 2, "- tol": 2, "Target": 8}}, "default property group": {"volgnummer": {"Value": 20}, "BOM alternative": {"Plant": "Ens", "Usage": null, "Alternative": "2"}}}}, "Properties": {"(none)": {"Properties FM": {"M300%": {"LSL": 17.5, "LWL": 18, "USL": 21.5, "UWL": 21, "UoM": "MPa", "Target": 19.5, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP002AN"}, "Ash (TGA)": {"LSL": 3.80000000000000027, "LWL": 4.29999999999999982, "USL": 6.79999999999999982, "UWL": 6.29999999999999982, "UoM": "%", "Target": 5.29999999999999982, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TC001AA"}, "Polymer (TGA)": {"LSL": 52, "LWL": 53, "USL": 58, "UWL": 57, "UoM": "%", "Target": 55, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TC001AA"}, "Volatile (TGA)": {"LSL": 10, "LWL": 10.5, "USL": 13, "UWL": 12.5, "UoM": "%", "Target": 11.5, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TC001AA"}, "Rebound (70°C)": {"LSL": 62, "LWL": 63, "USL": null, "UWL": null, "UoM": "%", "Target": 68, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP019AA"}, "Tensile strength": {"LSL": 19.4499999999999993, "LWL": 19.9499999999999993, "USL": 23.6500000000000021, "UWL": 23.1500000000000021, "UoM": "MPa", "Target": 21.5500000000000007, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP002AN"}, "Hardness (median)": {"LSL": 59.6000000000000014, "LWL": 60.6000000000000014, "USL": 67.5999999999999943, "UWL": 66.5999999999999943, "UoM": "°Shore A", "Target": 63.6000000000000014, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP001AA"}, "Carbon black (TGA)": {"LSL": 25.7300000000000004, "LWL": 26.2300000000000004, "USL": 30.129999999999999, "UWL": 29.629999999999999, "UoM": "%", "Target": 27.9299999999999997, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TC001AA"}, "Elongation at break": {"LSL": 290, "LWL": 300, "USL": null, "UWL": null, "UoM": "%", "Target": 345, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP002AN"}, "Tear strength (delft)": {"LSL": 7.5, "LWL": 8.5, "USL": null, "UWL": null, "UoM": "MPa", "Target": 12, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP004AB"}, "Filler Dispersion (DG)": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "%", "Target": 87, "Cr. par.": "N", "Int. method": null, "Apollo test code": null}, "Tack compound 0d at RT": {"LSL": 18.5, "LWL": 20.5, "USL": null, "UWL": null, "UoM": "N", "Target": 25.5, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP010AA"}, "Filler dispersion FM (dk)": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "%", "Target": 95, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP005AA"}, "Apollo Electrical Resistance": {"LSL": null, "LWL": null, "USL": null, "UWL": 0.0500000000000000028, "UoM": "MOhm", "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP021BA"}}, "Calculation properties": {"Density": {"UoM": "kg/l", "Value": 1.12902497933348012}, "Rubber content": {"UoM": "%", "Value": 57.9374275782155195}}, "Rheological properties": {"Mv (135°C)": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "M.U.", "Target": 37.6000000000000014, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP012B"}, "t5 (135°C)": {"LSL": 9.40000000000000036, "LWL": 10, "USL": 13, "UWL": 12.4000000000000004, "UoM": "min", "Target": 11.2000000000000011, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP012B"}, "G'100 (100°C)": {"LSL": 0.0299999999999999989, "LWL": 0.0400000000000000008, "USL": 0.0700000000000000067, "UWL": 0.0599999999999999978, "UoM": "MPa", "Target": 0.0500000000000000028, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP014A"}, "n''5% (100°C)": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "Pa.s", "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP015A"}, "G'0.56 (100°C)": {"LSL": 0.179999999999999993, "LWL": 0.209999999999999992, "USL": 0.340000000000000024, "UWL": 0.309999999999999998, "UoM": "MPa", "Target": 0.260000000000000009, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP014A"}, "Mooney ML(1+4) 100°C": {"LSL": 43, "LWL": 44, "USL": 55, "UWL": 54, "UoM": "M.U.", "Target": 49, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP011A"}, "Mooney ML(1+1.5) 135°C": {"LSL": null, "LWL": 37.3999999999999986, "USL": null, "UWL": 47.3999999999999986, "UoM": "M.U.", "Target": 42.3999999999999986, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP012B"}}, "default property group": {"Test time MDR 190°C": {"UoM": "min", "Value": null, "Apollo test code": "TP013B"}}, "MDR vulcanisation properties, 190°C": {"MH 190°C": {"LSL": 14.0400000000000009, "LWL": 14.3599999999999994, "USL": 17.879999999999999, "UWL": 17.5599999999999987, "UoM": "dNm", "Target": 15.9600000000000009, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013B"}, "ML 190°C": {"LSL": 1.18999999999999995, "LWL": 1.27000000000000002, "USL": 1.79000000000000004, "UWL": 1.70999999999999996, "UoM": "dNm", "Target": 1.48999999999999999, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013B"}, "ts1 190°C": {"LSL": 0.425000000000000044, "LWL": 0.440000000000000002, "USL": 0.575000000000000067, "UWL": 0.560000000000000053, "UoM": "min", "Target": 0.5, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013B"}, "t50%  190°C": {"LSL": 0.589999999999999969, "LWL": 0.60299999999999998, "USL": 0.75, "UWL": 0.736999999999999988, "UoM": "min", "Target": 0.67000000000000004, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013B"}, "t90%  190°C": {"LSL": 0.845000000000000084, "LWL": 0.86399999999999999, "USL": 1.07499999999999996, "UWL": 1.05600000000000005, "UoM": "min", "Target": 0.959999999999999964, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013B"}}, "RPA vulcanisation properties, 160°C": {"MH 160°C": {"LSL": 18.6000000000000014, "LWL": 18.9000000000000021, "USL": 21.1999999999999993, "UWL": 20.9000000000000021, "UoM": "dNm", "Target": 19.9000000000000021, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013A"}, "ML 160°C": {"LSL": 1.19999999999999996, "LWL": 1.30000000000000004, "USL": 2, "UWL": 1.90000000000000013, "UoM": "dNm", "Target": 1.60000000000000009, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013A"}, "t95 160°C": {"LSL": 4.5, "LWL": 5.10000000000000053, "USL": 7.90000000000000036, "UWL": 7.5, "UoM": "min", "Target": 6.29999999999999982, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013A"}, "ts1 160°C": {"LSL": 1.33000000000000007, "LWL": 1.42999999999999994, "USL": 2.53000000000000025, "UWL": 2.43000000000000016, "UoM": "min", "Target": 1.92999999999999994, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013A"}, "ts2 160°C": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "min", "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013P"}, "Tan ¿ 60°C (RPA)": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": null, "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013P"}}}}, "Controlplan": {"(none)": {"Controlplan FM": {"RPA payne effect": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP014A", "Sampling interval": 80}, "Mooney ML(1+4) 100°C": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP011A", "Sampling interval": 80}, "Tear strength (delft)": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP004AB", "Sampling interval": 400}, "Filler Dispersion (DG)": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP005CA", "Sampling interval": 160}, "Tack compound 0d at RT": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP010AA", "Sampling interval": 400}, "RPA viscosity measurement": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP015A", "Sampling interval": 160}, "Durometer hardness shore A": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP001AA", "Sampling interval": 160}, "Mooney Scorch t5 at 135°C": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP012B", "Sampling interval": 80}, "Apollo Electrical Resistance": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP021BA", "Sampling interval": 160}, "Rebound measurement at 70°C": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP019AA", "Sampling interval": 80}, "TGA of rubbers, 9' at 170°C": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TC001AA", "Sampling interval": 400}, "Tensile strength rubber (rc)": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP002AN", "Sampling interval": 400}, "Temperature sweep DMA (25-80 °C)": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP046BA", "Sampling interval": 720}, "Temperature sweep DMA (-80-25 °C)": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP046AA", "Sampling interval": 720}, "RPA vulcanisation properties, 160°C": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP013A", "Sampling interval": 80}}}}, "Description": "LOOPVLAK SPRINT CLASSIC B166 SB124", "Item Number": 30, "alternative": 2, "FUNCTIONCODE": "Base 1 compound", "SAP information": {"(none)": {"Aging SAP": {"Aging (Maximal)": {"UoM": "day", "Value": 30}, "Aging (minimal)": {"UoM": "hours", "Value": 4}}, "default property group": {"Weight": {"UoM": null, "Value": 1}, "Article type": {"Value": "I: Halffabrikaten Alternatief"}, "Packaging PG": {"Amount": 196, "Packaging": "PALL"}, "Article group PG": {"Value": "JD: EINDMENGSEL                   "}, "SAP material group": {"Value": "3C002: Final Batches Radial"}, "Physical in product": {"Value": "Yes"}}}}, "Aging min. (hrs)": null, "Aging max. (days)": null, "Position in machine": null}, "Tread.Base_2_compound.Base.FM": {"UoM": "kg", "Rev.": null, "Part No": "EM_722", "part_no": "EM_722", "Quantity": 0.313147, "revision": 67, "Packaging": null, "preferred": 1, "Processing": {"General": {"Shelf life": {"Shelf life max. (after production)": {"LSL": null, "USL": 4, "UoM": "week"}, "Shelf life min. (after production)": {"LSL": 4, "USL": null, "UoM": "hours"}}, "Extruded densities": {"Extruded density OHT": {"UoM": "g/cm³", "Value": 1.09000000000000008}, "Extruded density Triplex": {"UoM": "g/cm³", "Value": 1.09000000000000008}, "Extruded density Quadruplex": {"UoM": "g/cm³", "Value": 1.09000000000000008}}}, "MNG04: Mixer 4": {"Slittered": {"Batches per pallet": {"Value": 4}, "Number of strips slittered": {"Value": 2}}, "Mixer recipe": {"Mixer recipe 1": {"Value": "722048"}}, "Mixerproperties": {"Load factor": {"UoM": "%", "Calc": "N", "Target": 71.73520112920977}, "Mixervolume": {"UoM": "l", "Calc": "N", "Target": 242}, "Total batch volume": {"UoM": "l", "Calc": "N", "Target": 173.599186732688025}, "Total batch weight": {"UoM": "kg", "Calc": "N", "Target": 195.997818213182001}, "First component weight": {"UoM": "kg", "Calc": "Y", "Target": 190.319999999999993}}, "Slab dimensions": {"slab width": {"Set": 58, "UoM": "cm", "+ tol": 7, "- tol": 3, "Target": 59}, "slab thickness": {"Set": 6.29999999999999982, "UoM": "mm", "+ tol": 2, "- tol": 2, "Target": 8}}, "default property group": {"volgnummer": {"Value": 10}, "BOM alternative": {"Plant": "Ens", "Usage": null, "Alternative": "2"}}}, "MNG05: Mixer 5": {"Slittered": {"Batches per pallet": {"Value": 2}, "Number of strips slittered": {"Value": 2}}, "Mixer recipe": {"Mixer recipe 1": {"Value": "722048"}}, "Mixerproperties": {"Load factor": {"UoM": "%", "Calc": "N", "Target": 71.73520112920977}, "Mixervolume": {"UoM": "l", "Calc": "N", "Target": 242}, "Total batch volume": {"UoM": "l", "Calc": "N", "Target": 173.599186732688025}, "Total batch weight": {"UoM": "kg", "Calc": "N", "Target": 195.997818213182001}, "First component weight": {"UoM": "kg", "Calc": "Y", "Target": 190.319999999999993}}, "Slab dimensions": {"slab width": {"Set": 58, "UoM": "cm", "+ tol": 7, "- tol": 3, "Target": 59}, "slab thickness": {"Set": 6.29999999999999982, "UoM": "mm", "+ tol": 2, "- tol": 2, "Target": 8}}, "default property group": {"volgnummer": {"Value": 20}, "BOM alternative": {"Plant": "Ens", "Usage": null, "Alternative": "2"}}}}, "Properties": {"(none)": {"Properties FM": {"M300%": {"LSL": 17.5, "LWL": 18, "USL": 21.5, "UWL": 21, "UoM": "MPa", "Target": 19.5, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP002AN"}, "Ash (TGA)": {"LSL": 3.80000000000000027, "LWL": 4.29999999999999982, "USL": 6.79999999999999982, "UWL": 6.29999999999999982, "UoM": "%", "Target": 5.29999999999999982, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TC001AA"}, "Polymer (TGA)": {"LSL": 52, "LWL": 53, "USL": 58, "UWL": 57, "UoM": "%", "Target": 55, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TC001AA"}, "Volatile (TGA)": {"LSL": 10, "LWL": 10.5, "USL": 13, "UWL": 12.5, "UoM": "%", "Target": 11.5, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TC001AA"}, "Rebound (70°C)": {"LSL": 62, "LWL": 63, "USL": null, "UWL": null, "UoM": "%", "Target": 68, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP019AA"}, "Tensile strength": {"LSL": 19.4499999999999993, "LWL": 19.9499999999999993, "USL": 23.6500000000000021, "UWL": 23.1500000000000021, "UoM": "MPa", "Target": 21.5500000000000007, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP002AN"}, "Hardness (median)": {"LSL": 59.6000000000000014, "LWL": 60.6000000000000014, "USL": 67.5999999999999943, "UWL": 66.5999999999999943, "UoM": "°Shore A", "Target": 63.6000000000000014, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP001AA"}, "Carbon black (TGA)": {"LSL": 25.7300000000000004, "LWL": 26.2300000000000004, "USL": 30.129999999999999, "UWL": 29.629999999999999, "UoM": "%", "Target": 27.9299999999999997, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TC001AA"}, "Elongation at break": {"LSL": 290, "LWL": 300, "USL": null, "UWL": null, "UoM": "%", "Target": 345, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP002AN"}, "Tear strength (delft)": {"LSL": 7.5, "LWL": 8.5, "USL": null, "UWL": null, "UoM": "MPa", "Target": 12, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP004AB"}, "Filler Dispersion (DG)": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "%", "Target": 87, "Cr. par.": "N", "Int. method": null, "Apollo test code": null}, "Tack compound 0d at RT": {"LSL": 18.5, "LWL": 20.5, "USL": null, "UWL": null, "UoM": "N", "Target": 25.5, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP010AA"}, "Filler dispersion FM (dk)": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "%", "Target": 95, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP005AA"}, "Apollo Electrical Resistance": {"LSL": null, "LWL": null, "USL": null, "UWL": 0.0500000000000000028, "UoM": "MOhm", "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP021BA"}}, "Calculation properties": {"Density": {"UoM": "kg/l", "Value": 1.12902497933348012}, "Rubber content": {"UoM": "%", "Value": 57.9374275782155195}}, "Rheological properties": {"Mv (135°C)": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "M.U.", "Target": 37.6000000000000014, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP012B"}, "t5 (135°C)": {"LSL": 9.40000000000000036, "LWL": 10, "USL": 13, "UWL": 12.4000000000000004, "UoM": "min", "Target": 11.2000000000000011, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP012B"}, "G'100 (100°C)": {"LSL": 0.0299999999999999989, "LWL": 0.0400000000000000008, "USL": 0.0700000000000000067, "UWL": 0.0599999999999999978, "UoM": "MPa", "Target": 0.0500000000000000028, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP014A"}, "n''5% (100°C)": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "Pa.s", "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP015A"}, "G'0.56 (100°C)": {"LSL": 0.179999999999999993, "LWL": 0.209999999999999992, "USL": 0.340000000000000024, "UWL": 0.309999999999999998, "UoM": "MPa", "Target": 0.260000000000000009, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP014A"}, "Mooney ML(1+4) 100°C": {"LSL": 43, "LWL": 44, "USL": 55, "UWL": 54, "UoM": "M.U.", "Target": 49, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP011A"}, "Mooney ML(1+1.5) 135°C": {"LSL": null, "LWL": 37.3999999999999986, "USL": null, "UWL": 47.3999999999999986, "UoM": "M.U.", "Target": 42.3999999999999986, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP012B"}}, "default property group": {"Test time MDR 190°C": {"UoM": "min", "Value": null, "Apollo test code": "TP013B"}}, "MDR vulcanisation properties, 190°C": {"MH 190°C": {"LSL": 14.0400000000000009, "LWL": 14.3599999999999994, "USL": 17.879999999999999, "UWL": 17.5599999999999987, "UoM": "dNm", "Target": 15.9600000000000009, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013B"}, "ML 190°C": {"LSL": 1.18999999999999995, "LWL": 1.27000000000000002, "USL": 1.79000000000000004, "UWL": 1.70999999999999996, "UoM": "dNm", "Target": 1.48999999999999999, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013B"}, "ts1 190°C": {"LSL": 0.425000000000000044, "LWL": 0.440000000000000002, "USL": 0.575000000000000067, "UWL": 0.560000000000000053, "UoM": "min", "Target": 0.5, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013B"}, "t50%  190°C": {"LSL": 0.589999999999999969, "LWL": 0.60299999999999998, "USL": 0.75, "UWL": 0.736999999999999988, "UoM": "min", "Target": 0.67000000000000004, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013B"}, "t90%  190°C": {"LSL": 0.845000000000000084, "LWL": 0.86399999999999999, "USL": 1.07499999999999996, "UWL": 1.05600000000000005, "UoM": "min", "Target": 0.959999999999999964, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013B"}}, "RPA vulcanisation properties, 160°C": {"MH 160°C": {"LSL": 18.6000000000000014, "LWL": 18.9000000000000021, "USL": 21.1999999999999993, "UWL": 20.9000000000000021, "UoM": "dNm", "Target": 19.9000000000000021, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013A"}, "ML 160°C": {"LSL": 1.19999999999999996, "LWL": 1.30000000000000004, "USL": 2, "UWL": 1.90000000000000013, "UoM": "dNm", "Target": 1.60000000000000009, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013A"}, "t95 160°C": {"LSL": 4.5, "LWL": 5.10000000000000053, "USL": 7.90000000000000036, "UWL": 7.5, "UoM": "min", "Target": 6.29999999999999982, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013A"}, "ts1 160°C": {"LSL": 1.33000000000000007, "LWL": 1.42999999999999994, "USL": 2.53000000000000025, "UWL": 2.43000000000000016, "UoM": "min", "Target": 1.92999999999999994, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013A"}, "ts2 160°C": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "min", "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013P"}, "Tan ¿ 60°C (RPA)": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": null, "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013P"}}}}, "Controlplan": {"(none)": {"Controlplan FM": {"RPA payne effect": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP014A", "Sampling interval": 80}, "Mooney ML(1+4) 100°C": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP011A", "Sampling interval": 80}, "Tear strength (delft)": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP004AB", "Sampling interval": 400}, "Filler Dispersion (DG)": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP005CA", "Sampling interval": 160}, "Tack compound 0d at RT": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP010AA", "Sampling interval": 400}, "RPA viscosity measurement": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP015A", "Sampling interval": 160}, "Durometer hardness shore A": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP001AA", "Sampling interval": 160}, "Mooney Scorch t5 at 135°C": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP012B", "Sampling interval": 80}, "Apollo Electrical Resistance": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP021BA", "Sampling interval": 160}, "Rebound measurement at 70°C": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP019AA", "Sampling interval": 80}, "TGA of rubbers, 9' at 170°C": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TC001AA", "Sampling interval": 400}, "Tensile strength rubber (rc)": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP002AN", "Sampling interval": 400}, "Temperature sweep DMA (25-80 °C)": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP046BA", "Sampling interval": 720}, "Temperature sweep DMA (-80-25 °C)": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP046AA", "Sampling interval": 720}, "RPA vulcanisation properties, 160°C": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP013A", "Sampling interval": 80}}}}, "Description": "LOOPVLAK SPRINT CLASSIC B166 SB124", "Item Number": 50, "alternative": 2, "FUNCTIONCODE": "Base 2 compound", "SAP information": {"(none)": {"Aging SAP": {"Aging (Maximal)": {"UoM": "day", "Value": 30}, "Aging (minimal)": {"UoM": "hours", "Value": 4}}, "default property group": {"Weight": {"UoM": null, "Value": 1}, "Article type": {"Value": "I: Halffabrikaten Alternatief"}, "Packaging PG": {"Amount": 196, "Packaging": "PALL"}, "Article group PG": {"Value": "JD: EINDMENGSEL                   "}, "SAP material group": {"Value": "3C002: Final Batches Radial"}, "Physical in product": {"Value": "Yes"}}}}, "Aging min. (hrs)": null, "Aging max. (days)": null, "Position in machine": null}, "Tread.Tread_compound.Tread.FM": {"UoM": "kg", "Rev.": null, "Part No": "EM_775", "part_no": "EM_775", "Quantity": 0.747486, "revision": 46, "Packaging": null, "preferred": 1, "Processing": {"General": {"Shelf life": {"Shelf life max. (after production)": {"LSL": null, "USL": 4, "UoM": "week"}, "Shelf life min. (after production)": {"LSL": 8, "USL": null, "UoM": "hours"}}, "work away methods": {"Work away compound": {"Value": null}}, "Extruded densities": {"Extruded density Triplex": {"UoM": "g/cm³", "Value": 1.13600000000000012}, "Extruded density Quadruplex": {"UoM": "g/cm³", "Value": 1.13600000000000012}}}, "MNG04: Mixer 4": {"Slittered": {"Batches per pallet": {"Value": 3}, "Number of strips slittered": {"Value": 0}}, "Mixer recipe": {"Mixer recipe 1": {"Value": "775 045"}}, "Mixerproperties": {"Load factor": {"UoM": "%", "Calc": "N", "Target": 74.0824027130714313}, "Mixervolume": {"UoM": "l", "Calc": "N", "Target": 242}, "Total batch volume": {"UoM": "l", "Calc": "N", "Target": 179.279414565633004}, "Total batch weight": {"UoM": "kg", "Calc": "N", "Target": 214.374540183448005}, "First component weight": {"UoM": "kg", "Calc": "Y", "Target": 210}}, "Slab dimensions": {"slab width": {"Set": 61, "UoM": "cm", "+ tol": 8, "- tol": 3, "Target": 66}, "slab thickness": {"Set": 6, "UoM": "mm", "+ tol": 2, "- tol": 2, "Target": 9}}, "default property group": {"volgnummer": {"Value": 10}, "BOM alternative": {"Plant": "Ens", "Usage": "Prod", "Alternative": null}}}, "MNG05: Mixer 5": {"Slittered": {"Batches per pallet": {"Value": 3}, "Number of strips slittered": {"Value": 0}}, "Mixer recipe": {"Mixer recipe 1": {"Value": "775 045"}}, "Mixerproperties": {"Load factor": {"UoM": "%", "Calc": "N", "Target": 74.0824027130714313}, "Mixervolume": {"UoM": "l", "Calc": "N", "Target": 242}, "Total batch volume": {"UoM": "l", "Calc": "N", "Target": 179.279414565633004}, "Total batch weight": {"UoM": "kg", "Calc": "N", "Target": 214.374540183448005}, "First component weight": {"UoM": "kg", "Calc": "Y", "Target": 210}}, "Slab dimensions": {"slab width": {"Set": 61, "UoM": "cm", "+ tol": 8, "- tol": 3, "Target": 66}, "slab thickness": {"Set": 6, "UoM": "mm", "+ tol": 2, "- tol": 2, "Target": 9}}, "default property group": {"volgnummer": {"Value": 99}, "BOM alternative": {"Plant": null, "Usage": null, "Alternative": "3"}}}}, "Properties": {"(none)": {"Properties FM": {"M300%": {"LSL": 9.80000000000000071, "LWL": 10.5, "USL": 15.2000000000000011, "UWL": 14.5, "UoM": "MPa", "Target": 12.5, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP002AN"}, "Ash (TGA)": {"LSL": 29.5, "LWL": 29.9000000000000021, "USL": 32.7000000000000028, "UWL": 32.2999999999999972, "UoM": "%", "Target": 31.1000000000000014, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TC001AA"}, "Polymer (TGA)": {"LSL": 50.3999999999999986, "LWL": 50.8000000000000043, "USL": 53.6000000000000014, "UWL": 53.2000000000000028, "UoM": "%", "Target": 52, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TC001AA"}, "Volatile (TGA)": {"LSL": 9.70000000000000107, "LWL": 10.0999999999999996, "USL": 13.3000000000000007, "UWL": 12.9000000000000004, "UoM": "%", "Target": 11.5, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TC001AA"}, "Rebound (70°C)": {"LSL": 49, "LWL": 50, "USL": null, "UWL": null, "UoM": "%", "Target": 53, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP019AA"}, "Tensile strength": {"LSL": 18, "LWL": 18.5, "USL": 23, "UWL": 22.5, "UoM": "MPa", "Target": 20.5, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP002AN"}, "Hardness (median)": {"LSL": 58.3999999999999986, "LWL": 59, "USL": 63.2000000000000028, "UWL": 62.6000000000000014, "UoM": "°Shore A", "Target": 60.8000000000000043, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP001AA"}, "Carbon black (TGA)": {"LSL": 5.40000000000000036, "LWL": 5.60000000000000053, "USL": 7, "UWL": 6.79999999999999982, "UoM": "%", "Target": 6.20000000000000018, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TC001AA"}, "Elongation at break": {"LSL": 400, "LWL": 415, "USL": null, "UWL": null, "UoM": "%", "Target": 450, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP002AN"}, "Tear strength (delft)": {"LSL": 8, "LWL": 8.5, "USL": null, "UWL": null, "UoM": "MPa", "Target": 10.5999999999999996, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP004AB"}, "Filler Dispersion (DG)": {"LSL": 87, "LWL": 90, "USL": null, "UWL": null, "UoM": "%", "Target": 95, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP005DA"}}, "Calculation properties": {"Density": {"UoM": "kg/l", "Value": 1.19575658311270994}, "Rubber content": {"UoM": "%", "Value": 41.5610323760442171}}, "Greenstrength at 23°C": {"E-modulus at 23°C": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "MPa", "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP003AA"}, "Yield stress at 23°C": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "MPa", "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP003AA"}, "Yield elongation at 23°C": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "%", "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP003AA"}}, "Greenstrength at 40°C": {"E-modulus at 40°C": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "MPa", "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP003BA"}, "Yield stress at 40°C": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "MPa", "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP003BA"}, "Yield elongation at 40°C": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "%", "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP003BA"}}, "Rheological properties": {"Mv (135°C)": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "M.U.", "Target": 47.6000000000000014, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP012B"}, "t5 (135°C)": {"LSL": 8.19999999999999929, "LWL": 9, "USL": 14.8000000000000007, "UWL": 14, "UoM": "min", "Target": 11.5, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP012B"}, "G'100 (100°C)": {"LSL": null, "LWL": null, "USL": 0.0870000000000000079, "UWL": 0.0820000000000000034, "UoM": "MPa", "Target": 0.0720000000000000084, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP014A"}, "n''5% (100°C)": {"LSL": null, "LWL": 10000, "USL": null, "UWL": 12000, "UoM": "Pa.s", "Target": 11000, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP015A"}, "G'0.56 (100°C)": {"LSL": null, "LWL": null, "USL": 0.380000000000000004, "UWL": 0.350000000000000033, "UoM": "MPa", "Target": 0.299999999999999989, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP014A"}, "Mooney ML(1+4) 100°C": {"LSL": 61, "LWL": 63, "USL": 75, "UWL": 73, "UoM": "M.U.", "Target": 68, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP011A"}, "Mooney ML(1+1.5) 135°C": {"LSL": null, "LWL": 46.5, "USL": null, "UWL": 56.5, "UoM": "M.U.", "Target": 51.5, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP012B"}}, "default property group": {"Test time MDR 190°C": {"UoM": "min", "Value": 4, "Apollo test code": "TP013B"}}, "Ozon-cracking - static (ISO)": {"Cracklevel 24h (static)": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": null, "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP009AA"}, "Cracklevel 48h (static)": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": null, "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP009AA"}, "Cracklevel 72h (static)": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": null, "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP009AA"}}, "MDR vulcanisation properties, 190°C": {"MH 190°C": {"LSL": 13.0400000000000009, "LWL": 13.3399999999999999, "USL": 16.6000000000000014, "UWL": 16.3000000000000007, "UoM": "dNm", "Target": 14.8200000000000003, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013B"}, "ML 190°C": {"LSL": 1.41999999999999993, "LWL": 1.44999999999999996, "USL": 1.8600000000000001, "UWL": 1.83000000000000007, "UoM": "dNm", "Target": 1.64000000000000012, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013B"}, "ts1 190°C": {"LSL": 0.560000000000000053, "LWL": 0.57999999999999996, "USL": 0.719999999999999973, "UWL": 0.700000000000000067, "UoM": "min", "Target": 0.640000000000000013, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013B"}, "t50%  190°C": {"LSL": 0.880000000000000004, "LWL": 0.900000000000000022, "USL": 1.12000000000000011, "UWL": 1.10000000000000009, "UoM": "min", "Target": 1, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013B"}, "t90%  190°C": {"LSL": 1.60000000000000009, "LWL": 1.69999999999999996, "USL": 2.39999999999999991, "UWL": 2.30000000000000027, "UoM": "min", "Target": 2, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013B"}}, "RPA vulcanisation properties, 160°C": {"MH 160°C": {"LSL": 14, "LWL": 14.5, "USL": 18, "UWL": 17.5, "UoM": "dNm", "Target": 16, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013A"}, "ML 160°C": {"LSL": 1.19999999999999996, "LWL": 1.30000000000000004, "USL": 2, "UWL": 1.90000000000000013, "UoM": "dNm", "Target": 1.60000000000000009, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013A"}, "t95 160°C": {"LSL": 10.4000000000000004, "LWL": 10.8000000000000007, "USL": 13.5999999999999996, "UWL": 13.2000000000000011, "UoM": "min", "Target": 12, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013A"}, "ts1 160°C": {"LSL": 1.80000000000000004, "LWL": 1.94999999999999996, "USL": 3, "UWL": 2.85000000000000009, "UoM": "min", "Target": 2.39999999999999991, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013A"}, "ts2 160°C": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "min", "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013P"}, "Tan ¿ 60°C (RPA)": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": null, "Target": 0.149999999999999994, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013P"}}}}, "Controlplan": {"(none)": {"Controlplan FM": {"RPA payne effect": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP014A", "Sampling interval": 30}, "Mooney ML(1+4) 100°C": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP011A", "Sampling interval": 30}, "Tear strength (delft)": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP004AB", "Sampling interval": 150}, "Filler Dispersion (DG)": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP005DA", "Sampling interval": 60}, "RPA viscosity measurement": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP015A", "Sampling interval": 60}, "Durometer hardness shore A": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP001AA", "Sampling interval": 60}, "Mooney Scorch t5 at 135°C": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP012B", "Sampling interval": 30}, "Rebound measurement at 70°C": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP019AA", "Sampling interval": 30}, "TGA of rubbers, 9' at 170°C": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TC001AA", "Sampling interval": 150}, "Tensile strength rubber (rc)": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP002AN", "Sampling interval": 150}, "Temperature sweep DMA (25-80 °C)": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP044DA", "Sampling interval": 300}, "Temperature sweep DMA (-80-25 °C)": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP044CA", "Sampling interval": 300}, "RPA vulcanisation properties, 160°C": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP013P", "Sampling interval": 30}}}}, "Description": "LOOPVLAK SPRINT CLASSIC B166 SB124", "Item Number": 20, "alternative": 2, "FUNCTIONCODE": "Tread compound", "SAP information": {"(none)": {"Aging SAP": {"Aging (Maximal)": {"UoM": "day", "Value": 30}, "Aging (minimal)": {"UoM": "hours", "Value": 8}}, "default property group": {"Weight": {"UoM": null, "Value": 1}, "Article type": {"Value": "I: Halffabrikaten Alternatief"}, "Packaging PG": {"Amount": 227, "Packaging": "PALL"}, "Article group PG": {"Value": "JD: EINDMENGSEL                   "}, "SAP material group": {"Value": "3C002: Final Batches Radial"}, "Physical in product": {"Value": "Yes"}}}}, "Aging min. (hrs)": null, "Aging max. (days)": null, "Position in machine": null}, "Belt_1.Belt_gum.Composite.ASSEM": {"UoM": "m", "Rev.": null, "Part No": "EX_Y798", "part_no": "EX_Y798", "Quantity": 0.055600, "revision": 5, "Packaging": null, "preferred": 1, "Processing": {"KAL03: Calender 3": {"default property group": {"volgnummer": {"Value": 10}}}}, "Properties": {"(none)": {"Dimensions SFP": {"Gauge": {"UoM": "mm", "+ tol": 0.119999999999999996, "- tol": -0.119999999999999996, "Target": 0.75, "Cr. par.": "N", "Apollo test code": null}, "Width": {"UoM": "mm", "+ tol": 5, "- tol": -5, "Target": 798, "Cr. par.": "N", "Apollo test code": null}}}}, "Description": "GORDELRANDSTROOK  755 0.75X40  (STRAM)", "Item Number": 10, "alternative": 1, "FUNCTIONCODE": "Composite", "SAP information": {"(none)": {"default property group": {"Weight": {"UoM": null, "Value": 1}, "Article type": {"Value": "H: Halffabrikaten Volgordelijk"}, "Packaging PG": {"Amount": 200, "Packaging": "LNPVC"}, "Article group PG": {"Value": "LE: GORDELRANDSTROOK / SQUEEGEE"}, "Physical in product": {"Value": "Yes"}}}}, "Aging min. (hrs)": null, "Aging max. (days)": null, "Position in machine": null}, "Tread.Wingtip_compound.Wingtip.FM": {"UoM": "kg", "Rev.": null, "Part No": "EM_726", "part_no": "EM_726", "Quantity": 0.097935, "revision": 84, "Packaging": null, "preferred": 1, "Processing": {"General": {"Extruded densities": {"Extruded density Triplex": {"UoM": "g/cm³", "Value": 1.13000000000000012}, "Extruded density Quadruplex": {"UoM": "g/cm³", "Value": 1.13000000000000012}}}, "MNG04: Mixer 4": {"Slittered": {"Batches per pallet": {"Value": 4}, "Number of strips slittered": {"Value": 2}}, "Mixer recipe": {"Mixer recipe 1": {"Value": "726083"}}, "Mixerproperties": {"Load factor": {"UoM": "%", "Calc": "N", "Target": 80.8614213572770382}, "Mixervolume": {"UoM": "l", "Calc": "N", "Target": 242}, "Total batch volume": {"UoM": "l", "Calc": "N", "Target": 195.684639684610005}, "Total batch weight": {"UoM": "kg", "Calc": "N", "Target": 220.843843815043016}, "First component weight": {"UoM": "kg", "Calc": "Y", "Target": 217}}, "Slab dimensions": {"slab width": {"Set": 70, "UoM": "cm", "+ tol": 7, "- tol": 3, "Target": 70}, "slab thickness": {"Set": 6.60000000000000053, "UoM": "mm", "+ tol": 2, "- tol": 2, "Target": 9}}, "default property group": {"volgnummer": {"Value": 10}, "BOM alternative": {"Plant": null, "Usage": null, "Alternative": "2"}}}, "MNG05: Mixer 5": {"Slittered": {"Batches per pallet": {"Value": 3}, "Number of strips slittered": {"Value": 2}}, "Mixer recipe": {"Mixer recipe 1": {"Value": "726083"}}, "Mixerproperties": {"Load factor": {"UoM": "%", "Calc": "N", "Target": 80.8614213572770382}, "Mixervolume": {"UoM": "l", "Calc": "N", "Target": 242}, "Total batch volume": {"UoM": "l", "Calc": "N", "Target": 195.684639684610005}, "Total batch weight": {"UoM": "kg", "Calc": "N", "Target": 220.843843815043016}, "First component weight": {"UoM": "kg", "Calc": "Y", "Target": 217}}, "Slab dimensions": {"slab width": {"Set": 70, "UoM": "cm", "+ tol": 7, "- tol": 3, "Target": 70}, "slab thickness": {"Set": 6.60000000000000053, "UoM": "mm", "+ tol": 2, "- tol": 2, "Target": 9}}, "default property group": {"volgnummer": {"Value": 99}, "BOM alternative": {"Plant": null, "Usage": null, "Alternative": "2"}}}}, "Properties": {"(none)": {"Properties FM": {"M300%": {"LSL": 7.20000000000000018, "LWL": 7.5, "USL": 10, "UWL": 9.70000000000000107, "UoM": "MPa", "Target": 8.59999999999999964, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP002AN"}, "Ash (TGA)": {"LSL": 1.80000000000000004, "LWL": 2.10000000000000009, "USL": 4.20000000000000018, "UWL": 3.89999999999999991, "UoM": "%", "Target": 3, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TC001AA"}, "Polymer (TGA)": {"LSL": 53.7000000000000028, "LWL": 54.3999999999999986, "USL": 59.1000000000000014, "UWL": 58.3999999999999986, "UoM": "%", "Target": 56.3999999999999986, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TC001AA"}, "Volatile (TGA)": {"LSL": 7.40000000000000036, "LWL": 7.90000000000000036, "USL": 11.4000000000000004, "UWL": 10.9000000000000004, "UoM": "%", "Target": 9.40000000000000036, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TC001AA"}, "Rebound (70°C)": {"LSL": 43, "LWL": 45, "USL": null, "UWL": null, "UoM": "%", "Target": 48, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP019AA"}, "Tensile strength": {"LSL": 13.3000000000000007, "LWL": 14, "USL": 18.6999999999999993, "UWL": 18, "UoM": "MPa", "Target": 16, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP002AN"}, "Hardness (median)": {"LSL": 53.3000000000000043, "LWL": 54, "USL": 58.7000000000000028, "UWL": 58, "UoM": "°Shore A", "Target": 56, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP001AA"}, "Carbon black (TGA)": {"LSL": 30.5, "LWL": 30.8000000000000007, "USL": 32.8999999999999986, "UWL": 32.6000000000000014, "UoM": "%", "Target": 31.6999999999999993, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TC001AA"}, "Elongation at break": {"LSL": 390, "LWL": 415, "USL": null, "UWL": null, "UoM": "%", "Target": 530, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP002AN"}, "Tear strength (delft)": {"LSL": 11, "LWL": 11.5, "USL": null, "UWL": null, "UoM": "MPa", "Target": 13.5, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP004AB"}, "Filler Dispersion (DG)": {"LSL": 75, "LWL": 80, "USL": null, "UWL": null, "UoM": "%", "Target": 90, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP005CA"}, "Tack compound 0d at RT": {"LSL": 18, "LWL": 20, "USL": null, "UWL": null, "UoM": "N", "Target": 26, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP010AA"}, "Apollo Electrical Resistance": {"LSL": null, "LWL": null, "USL": 0.149999999999999994, "UWL": 0.100000000000000006, "UoM": "MOhm", "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP021BA"}}, "Calculation properties": {"Density": {"UoM": "kg/l", "Value": 1.12857015333948985}, "Rubber content": {"UoM": "%", "Value": 51.0438466642846151}}, "Greenstrength at 23°C": {"E-modulus at 23°C": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "MPa", "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP003AA"}, "Yield stress at 23°C": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "MPa", "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP003AA"}, "Yield elongation at 23°C": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "%", "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP003AA"}}, "Greenstrength at 40°C": {"E-modulus at 40°C": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "MPa", "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP003BA"}, "Yield stress at 40°C": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "MPa", "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP003BA"}, "Yield elongation at 40°C": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "%", "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP003BA"}}, "Rheological properties": {"Mv (135°C)": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "M.U.", "Target": 33.7000000000000028, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP012B"}, "t5 (135°C)": {"LSL": 15.5, "LWL": 16, "USL": 19.3000000000000007, "UWL": 18.8000000000000007, "UoM": "min", "Target": 17.4000000000000021, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP012B"}, "G'100 (100°C)": {"LSL": null, "LWL": 0.0299999999999999989, "USL": null, "UWL": 0.0500000000000000028, "UoM": "MPa", "Target": 0.0400000000000000008, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP014A"}, "n''5% (100°C)": {"LSL": null, "LWL": 7700, "USL": null, "UWL": 9700, "UoM": "Pa.s", "Target": 8700, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP015A"}, "G'0.56 (100°C)": {"LSL": null, "LWL": 0.299999999999999989, "USL": 0.419999999999999984, "UWL": 0.400000000000000022, "UoM": "MPa", "Target": 0.359999999999999987, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP014A"}, "Mooney ML(1+4) 100°C": {"LSL": 35.5, "LWL": 38.5, "USL": 50.5, "UWL": 48.5, "UoM": "M.U.", "Target": 43.5, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP011A"}, "Mooney ML(1+1.5) 135°C": {"LSL": null, "LWL": 32, "USL": null, "UWL": 42, "UoM": "M.U.", "Target": 37, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP012B"}}, "default property group": {"Test time MDR 190°C": {"UoM": "min", "Value": 2.75, "Apollo test code": "TP013B"}}, "Ozon-cracking - static (ISO)": {"Cracklevel 24h (static)": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": null, "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP009AA"}, "Cracklevel 48h (static)": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": null, "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP009AA"}, "Cracklevel 72h (static)": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": null, "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP009AA"}}, "Ozon-cracking - dynamic (ISO)": {"Cracklevel 24h (dynamic)": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": null, "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP009CA"}, "Cracklevel 48h (dynamic)": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": null, "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP009CA"}, "Cracklevel 72h (dynamic)": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": null, "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP009CA"}}, "MDR vulcanisation properties, 190°C": {"MH 190°C": {"LSL": 9.85999999999999943, "LWL": 10.0800000000000001, "USL": 12.5400000000000009, "UWL": 12.3200000000000003, "UoM": "dNm", "Target": 11.2000000000000011, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013B"}, "ML 190°C": {"LSL": 1.20999999999999996, "LWL": 1.25, "USL": 1.63000000000000012, "UWL": 1.59000000000000008, "UoM": "dNm", "Target": 1.41999999999999993, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013B"}, "ts1 190°C": {"LSL": 0.560000000000000053, "LWL": 0.57999999999999996, "USL": 0.719999999999999973, "UWL": 0.700000000000000067, "UoM": "min", "Target": 0.640000000000000013, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013B"}, "t50%  190°C": {"LSL": 0.935000000000000053, "LWL": 0.968000000000000083, "USL": 1.26500000000000012, "UWL": 1.23199999999999998, "UoM": "min", "Target": 1.10000000000000009, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013B"}, "t90%  190°C": {"LSL": 1.43400000000000016, "LWL": 1.46700000000000008, "USL": 1.82600000000000007, "UWL": 1.79300000000000015, "UoM": "min", "Target": 1.63000000000000012, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013B"}}, "RPA vulcanisation properties, 160°C": {"MH 160°C": {"LSL": 11.8000000000000007, "LWL": 12.2000000000000011, "USL": 15, "UWL": 14.5999999999999996, "UoM": "dNm", "Target": 13.4000000000000004, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013P"}, "ML 160°C": {"LSL": 1.19999999999999996, "LWL": 1.30000000000000004, "USL": 2, "UWL": 1.90000000000000013, "UoM": "dNm", "Target": 1.60000000000000009, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013P"}, "t95 160°C": {"LSL": 8.30000000000000071, "LWL": 8.80000000000000071, "USL": 12.3000000000000007, "UWL": 11.8000000000000007, "UoM": "min", "Target": 10.3000000000000007, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013P"}, "ts1 160°C": {"LSL": 2.10000000000000009, "LWL": 2.39999999999999991, "USL": 4.5, "UWL": 4.20000000000000018, "UoM": "min", "Target": 3.30000000000000027, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013P"}, "ts2 160°C": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "min", "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013P"}, "Tan ¿ 60°C (RPA)": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": null, "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013P"}}}}, "Controlplan": {"(none)": {"Controlplan FM": {"RPA payne effect": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP014A", "Sampling interval": 20}, "Mooney ML(1+4) 100°C": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP011A", "Sampling interval": 20}, "Tear strength (delft)": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP004AB", "Sampling interval": 60}, "Filler Dispersion (DG)": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP005CA", "Sampling interval": 20}, "Tack compound 0d at RT": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP010AA", "Sampling interval": 60}, "RPA viscosity measurement": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP015A", "Sampling interval": 20}, "Durometer hardness shore A": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP001AA", "Sampling interval": 20}, "Mooney Scorch t5 at 135°C": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP012B", "Sampling interval": 20}, "Apollo Electrical Resistance": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP021BA", "Sampling interval": 20}, "Rebound measurement at 70°C": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP019AA", "Sampling interval": 20}, "TGA of rubbers, 9' at 170°C": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TC001AA", "Sampling interval": 60}, "Tensile strength rubber (rc)": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP002AN", "Sampling interval": 60}, "RPA vulcanisation properties, 160°C": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP013P", "Sampling interval": 20}}}}, "Description": "LOOPVLAK SPRINT CLASSIC B166 SB124", "Item Number": 40, "alternative": 2, "FUNCTIONCODE": "Wingtip compound", "SAP information": {"(none)": {"Aging SAP": {"Aging (Maximal)": {"UoM": "day", "Value": 30}, "Aging (minimal)": {"UoM": "hours", "Value": 4}}, "default property group": {"Weight": {"UoM": null, "Value": 1}, "Article type": {"Value": "I: Halffabrikaten Alternatief"}, "Packaging PG": {"Amount": 230.730000000000018, "Packaging": "PALL"}, "Article group PG": {"Value": "JD: EINDMENGSEL                   "}, "SAP material group": {"Value": "3C002: Final Batches Radial"}, "Physical in product": {"Value": "Yes"}}}}, "Aging min. (hrs)": null, "Aging max. (days)": null, "Position in machine": null}, "Belt_1.Composite.Reinforcement.STEELCORD": {"UoM": "kg", "Rev.": null, "Part No": "GR_5711", "part_no": "GR_5711", "Quantity": 1.064000, "revision": 9, "Packaging": "A", "preferred": 1, "Description": "STAALKOORD KE21 WIT", "Item Number": 10, "alternative": 1, "FUNCTIONCODE": "Reinforcement", "SAP information": {"A": {"default property group": {"Weight": {"UoM": "kg", "Value": 1}, "Packaging PG": {"Amount": null, "Packaging": null}, "Article group PG": {"Value": "56: STEEL CORD                    "}, "Physical in product": {"Value": "Yes"}}}}, "Aging min. (hrs)": null, "Aging max. (days)": null, "Position in machine": null, "Chemical and physical properties": {"(none)": {"Various properties steelcords": {"Construction": {"CoA": "N", "Rem.": null, "Value": "2*0.30 HT"}}, "Calculation properties cord/wire": {"Density": {"UoM": "kg/m³", "Value": 7800, "Apollo test code": null}, "Lase 1%": {"UoM": "N", "Value": 0, "Apollo test code": null}, "Lase 3%": {"UoM": "N", "Value": 0, "Apollo test code": null}, "Lase 5%": {"UoM": "N", "Value": 0, "Apollo test code": null}, "Lase 7%": {"UoM": "N", "Value": 0, "Apollo test code": null}, "Diameter": {"UoM": "mm", "Value": 0.599999999999999978, "Apollo test code": null}, "Breaking force": {"UoM": "N", "Value": 445, "Apollo test code": null}, "Mass per linear meter": {"UoM": "g", "Value": 1.12000000000000011, "Apollo test code": null}}}}}, "Belt_2.Composite.Reinforcement.STEELCORD": {"UoM": "kg", "Rev.": null, "Part No": "GR_5711", "part_no": "GR_5711", "Quantity": 1.064000, "revision": 9, "Packaging": "A", "preferred": 1, "Description": "STAALKOORD KE21 WIT", "Item Number": 10, "alternative": 1, "FUNCTIONCODE": "Reinforcement", "SAP information": {"A": {"default property group": {"Weight": {"UoM": "kg", "Value": 1}, "Packaging PG": {"Amount": null, "Packaging": null}, "Article group PG": {"Value": "56: STEEL CORD                    "}, "Physical in product": {"Value": "Yes"}}}}, "Aging min. (hrs)": null, "Aging max. (days)": null, "Position in machine": null, "Chemical and physical properties": {"(none)": {"Various properties steelcords": {"Construction": {"CoA": "N", "Rem.": null, "Value": "2*0.30 HT"}}, "Calculation properties cord/wire": {"Density": {"UoM": "kg/m³", "Value": 7800, "Apollo test code": null}, "Lase 1%": {"UoM": "N", "Value": 0, "Apollo test code": null}, "Lase 3%": {"UoM": "N", "Value": 0, "Apollo test code": null}, "Lase 5%": {"UoM": "N", "Value": 0, "Apollo test code": null}, "Lase 7%": {"UoM": "N", "Value": 0, "Apollo test code": null}, "Diameter": {"UoM": "mm", "Value": 0.599999999999999978, "Apollo test code": null}, "Breaking force": {"UoM": "N", "Value": 445, "Apollo test code": null}, "Mass per linear meter": {"UoM": "g", "Value": 1.12000000000000011, "Apollo test code": null}}}}}, "Belt_1.Composite.Composite_compound.Steelcord.FM": {"UoM": "kg", "Rev.": null, "Part No": "EM_753", "part_no": "EM_753", "Quantity": 1.217000, "revision": 70, "Packaging": null, "preferred": 1, "Processing": {"MNG04: Mixer 4": {"Slittered": {"Batches per pallet": {"Value": 3}, "Number of strips slittered": {"Value": 2}}, "Mixer recipe": {"Mixer recipe 1": {"Value": "753063"}}, "Mixerproperties": {"Load factor": {"UoM": "%", "Calc": "N", "Target": 76.4595476790021849}, "Mixervolume": {"UoM": "l", "Calc": "N", "Target": 242}, "Total batch volume": {"UoM": "l", "Calc": "N", "Target": 185.032105383185012}, "Total batch weight": {"UoM": "kg", "Calc": "N", "Target": 220.826147111901008}, "First component weight": {"UoM": "kg", "Calc": "Y", "Target": 200}}, "Slab dimensions": {"slab width": {"Set": 65, "UoM": "cm", "+ tol": 7, "- tol": 3, "Target": 68}, "slab thickness": {"Set": 5.5, "UoM": "mm", "+ tol": 2, "- tol": 2, "Target": 7.5}}, "default property group": {"volgnummer": {"Value": 20}, "BOM alternative": {"Plant": null, "Usage": null, "Alternative": "2"}}}, "MNG05: Mixer 5": {"Slittered": {"Batches per pallet": {"Value": 3}, "Number of strips slittered": {"Value": 2}}, "Mixer recipe": {"Mixer recipe 1": {"Value": "753063"}}, "Mixerproperties": {"Load factor": {"UoM": "%", "Calc": "N", "Target": 76.4595476790021849}, "Mixervolume": {"UoM": "l", "Calc": "N", "Target": 242}, "Total batch volume": {"UoM": "l", "Calc": "N", "Target": 185.032105383185012}, "Total batch weight": {"UoM": "kg", "Calc": "N", "Target": 220.826147111901008}, "First component weight": {"UoM": "kg", "Calc": "Y", "Target": 200}}, "Slab dimensions": {"slab width": {"Set": 65, "UoM": "cm", "+ tol": 7, "- tol": 3, "Target": 68}, "slab thickness": {"Set": 5.5, "UoM": "mm", "+ tol": 2, "- tol": 2, "Target": 7.5}}, "default property group": {"volgnummer": {"Value": 10}, "BOM alternative": {"Plant": null, "Usage": null, "Alternative": "2"}}}}, "Properties": {"(none)": {"Properties FM": {"M300%": {"LSL": 12.0999999999999996, "LWL": 12.8000000000000007, "USL": 17.5, "UWL": 16.8000000000000007, "UoM": "MPa", "Target": 14.8000000000000007, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP002AN"}, "Ash (TGA)": {"LSL": 11.3000000000000007, "LWL": 11.5999999999999996, "USL": 13.9000000000000004, "UWL": 13.5999999999999996, "UoM": "%", "Target": 12.5999999999999996, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TC001AA"}, "Polymer (TGA)": {"LSL": 47.6000000000000014, "LWL": 48.3999999999999986, "USL": 54.2000000000000028, "UWL": 53.3999999999999986, "UoM": "%", "Target": 50.8999999999999986, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TC001AA"}, "Volatile (TGA)": {"LSL": 7.90000000000000036, "LWL": 8.40000000000000036, "USL": 11.9000000000000004, "UWL": 11.4000000000000004, "UoM": "%", "Target": 9.90000000000000036, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TC001AA"}, "Rebound (70°C)": {"LSL": 47, "LWL": 48, "USL": null, "UWL": null, "UoM": "%", "Target": 51.5, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP019AA"}, "Tensile strength": {"LSL": 14.5, "LWL": 15.0999999999999996, "USL": 19.5, "UWL": 18.9000000000000021, "UoM": "MPa", "Target": 17, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP002AN"}, "Hardness (median)": {"LSL": 75.7999999999999972, "LWL": 76.7999999999999972, "USL": 83.7999999999999972, "UWL": 82.7999999999999972, "UoM": "°Shore A", "Target": 79.7999999999999972, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP001AA"}, "Carbon black (TGA)": {"LSL": 24.3000000000000007, "LWL": 25, "USL": 29.6999999999999993, "UWL": 29, "UoM": "%", "Target": 27, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TC001AA"}, "Elongation at break": {"LSL": 320, "LWL": 330, "USL": null, "UWL": null, "UoM": "%", "Target": 350, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP002AN"}, "Tear strength (delft)": {"LSL": 8.5, "LWL": 9.20000000000000107, "USL": null, "UWL": null, "UoM": "MPa", "Target": 11.4000000000000004, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP004AB"}, "Filler Dispersion (DG)": {"LSL": 70, "LWL": 73, "USL": null, "UWL": null, "UoM": "%", "Target": 80, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP005CA"}, "Tack compound 0d at RT": {"LSL": 18, "LWL": 20, "USL": null, "UWL": null, "UoM": "N", "Target": 30, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP010AA"}}, "Calculation properties": {"Density": {"UoM": "kg/l", "Value": 1.19344773521648984}, "Rubber content": {"UoM": "%", "Value": 50.2184502586250048}}, "Greenstrength at 23°C": {"E-modulus at 23°C": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "MPa", "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP003AA"}, "Yield stress at 23°C": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "MPa", "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP003AA"}, "Yield elongation at 23°C": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "%", "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP003AA"}}, "Greenstrength at 40°C": {"E-modulus at 40°C": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "MPa", "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP003BA"}, "Yield stress at 40°C": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "MPa", "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP003BA"}, "Yield elongation at 40°C": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "%", "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP003BA"}}, "Rheological properties": {"Mv (135°C)": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "M.U.", "Target": 56, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP012B"}, "t5 (135°C)": {"LSL": 6.60000000000000053, "LWL": 7.29999999999999982, "USL": 12, "UWL": 11.3000000000000007, "UoM": "min", "Target": 9.30000000000000071, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP012B"}, "G'100 (100°C)": {"LSL": 0.0599999999999999978, "LWL": 0.0650000000000000022, "USL": 0.0899999999999999967, "UWL": 0.0850000000000000061, "UoM": "MPa", "Target": 0.0749999999999999972, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP014A"}, "n''5% (100°C)": {"LSL": null, "LWL": 10000, "USL": null, "UWL": 13000, "UoM": "Pa.s", "Target": 11500, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP015A"}, "G'0.56 (100°C)": {"LSL": null, "LWL": null, "USL": 0.450000000000000011, "UWL": 0.429999999999999993, "UoM": "MPa", "Target": 0.369999999999999996, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP014A"}, "Mooney ML(1+4) 100°C": {"LSL": 60.5, "LWL": 61.5, "USL": 72.5, "UWL": 71.5, "UoM": "M.U.", "Target": 66.5, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP011A"}, "Mooney ML(1+1.5) 135°C": {"LSL": null, "LWL": 51, "USL": null, "UWL": 63, "UoM": "M.U.", "Target": 57, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP012B"}}, "default property group": {"Test time MDR 190°C": {"UoM": "min", "Value": 2.75, "Apollo test code": "TP013B"}}, "Ozon-cracking - static (ISO)": {"Cracklevel 24h (static)": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": null, "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP009AA"}, "Cracklevel 48h (static)": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": null, "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP009AA"}, "Cracklevel 72h (static)": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": null, "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP009AA"}}, "Ozon-cracking - dynamic (ISO)": {"Cracklevel 24h (dynamic)": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": null, "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP009CA"}, "Cracklevel 48h (dynamic)": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": null, "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP009CA"}, "Cracklevel 72h (dynamic)": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": null, "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP009CA"}}, "MDR vulcanisation properties, 190°C": {"MH 190°C": {"LSL": 23.2300000000000004, "LWL": 23.7600000000000016, "USL": 29.5700000000000003, "UWL": 29.0399999999999991, "UoM": "dNm", "Target": 26.4000000000000021, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013B"}, "ML 190°C": {"LSL": 1.6100000000000001, "LWL": 1.71999999999999997, "USL": 2.41999999999999993, "UWL": 2.31999999999999984, "UoM": "dNm", "Target": 2.02000000000000002, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013B"}, "ts1 190°C": {"LSL": 0.424000000000000044, "LWL": 0.433999999999999997, "USL": 0.540000000000000036, "UWL": 0.530000000000000027, "UoM": "min", "Target": 0.48200000000000004, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013B"}, "t50%  190°C": {"LSL": 0.747999999999999998, "LWL": 0.765000000000000013, "USL": 0.952000000000000068, "UWL": 0.935000000000000053, "UoM": "min", "Target": 0.849999999999999978, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013B"}, "t90%  190°C": {"LSL": 1.26700000000000013, "LWL": 1.23799999999999999, "USL": 1.61299999999999999, "UWL": 1.58400000000000007, "UoM": "min", "Target": 1.43999999999999995, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013B"}}, "RPA vulcanisation properties, 160°C": {"MH 160°C": {"LSL": 28.6999999999999993, "LWL": 29.6999999999999993, "USL": 36.7000000000000028, "UWL": 35.7000000000000028, "UoM": "dNm", "Target": 32.7000000000000028, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013P"}, "ML 160°C": {"LSL": 1.60000000000000009, "LWL": 1.80000000000000004, "USL": 2.80000000000000027, "UWL": 2.60000000000000009, "UoM": "dNm", "Target": 2.20000000000000018, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013P"}, "t95 160°C": {"LSL": 9.20000000000000107, "LWL": 9.70000000000000107, "USL": 13.2000000000000011, "UWL": 12.7000000000000011, "UoM": "min", "Target": 11.2000000000000011, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013P"}, "ts1 160°C": {"LSL": 1, "LWL": 1.15000000000000013, "USL": 2.20000000000000018, "UWL": 2.04999999999999982, "UoM": "min", "Target": 1.60000000000000009, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013P"}, "ts2 160°C": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "min", "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013P"}, "Tan ¿ 60°C (RPA)": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": null, "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013P"}}}}, "Controlplan": {"(none)": {"Controlplan FM": {"RPA payne effect": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP014A", "Sampling interval": 50}, "Mooney ML(1+4) 100°C": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP011A", "Sampling interval": 50}, "Tear strength (delft)": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP004AB", "Sampling interval": 200}, "Filler Dispersion (DG)": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP005CA", "Sampling interval": 100}, "Tack compound 0d at RT": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP010AA", "Sampling interval": 200}, "RPA viscosity measurement": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP015A", "Sampling interval": 100}, "Durometer hardness shore A": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP001AA", "Sampling interval": 100}, "Mooney Scorch t5 at 135°C": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP012B", "Sampling interval": 50}, "Rebound measurement at 70°C": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP019AA", "Sampling interval": 50}, "TGA of rubbers, 9' at 170°C": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TC001AA", "Sampling interval": 200}, "Tensile strength rubber (rc)": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP002AN", "Sampling interval": 200}, "RPA vulcanisation properties, 160°C": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP013P", "Sampling interval": 50}}}}, "Description": "STAALKOORD KE21 WIT", "Item Number": 20, "alternative": 1, "FUNCTIONCODE": "Composite compound", "SAP information": {"(none)": {"Aging SAP": {"Aging (Maximal)": {"UoM": "day", "Value": 30}, "Aging (minimal)": {"UoM": "hours", "Value": 0}}, "default property group": {"Weight": {"UoM": null, "Value": 1}, "Article type": {"Value": "I: Halffabrikaten Alternatief"}, "Packaging PG": {"Amount": 221, "Packaging": "PALL"}, "Article group PG": {"Value": "JD: EINDMENGSEL                   "}, "Physical in product": {"Value": "Yes"}}}}, "Aging min. (hrs)": null, "Aging max. (days)": null, "Position in machine": null}, "Belt_2.Composite.Composite_compound.Steelcord.FM": {"UoM": "kg", "Rev.": null, "Part No": "EM_753", "part_no": "EM_753", "Quantity": 1.217000, "revision": 70, "Packaging": null, "preferred": 1, "Processing": {"MNG04: Mixer 4": {"Slittered": {"Batches per pallet": {"Value": 3}, "Number of strips slittered": {"Value": 2}}, "Mixer recipe": {"Mixer recipe 1": {"Value": "753063"}}, "Mixerproperties": {"Load factor": {"UoM": "%", "Calc": "N", "Target": 76.4595476790021849}, "Mixervolume": {"UoM": "l", "Calc": "N", "Target": 242}, "Total batch volume": {"UoM": "l", "Calc": "N", "Target": 185.032105383185012}, "Total batch weight": {"UoM": "kg", "Calc": "N", "Target": 220.826147111901008}, "First component weight": {"UoM": "kg", "Calc": "Y", "Target": 200}}, "Slab dimensions": {"slab width": {"Set": 65, "UoM": "cm", "+ tol": 7, "- tol": 3, "Target": 68}, "slab thickness": {"Set": 5.5, "UoM": "mm", "+ tol": 2, "- tol": 2, "Target": 7.5}}, "default property group": {"volgnummer": {"Value": 20}, "BOM alternative": {"Plant": null, "Usage": null, "Alternative": "2"}}}, "MNG05: Mixer 5": {"Slittered": {"Batches per pallet": {"Value": 3}, "Number of strips slittered": {"Value": 2}}, "Mixer recipe": {"Mixer recipe 1": {"Value": "753063"}}, "Mixerproperties": {"Load factor": {"UoM": "%", "Calc": "N", "Target": 76.4595476790021849}, "Mixervolume": {"UoM": "l", "Calc": "N", "Target": 242}, "Total batch volume": {"UoM": "l", "Calc": "N", "Target": 185.032105383185012}, "Total batch weight": {"UoM": "kg", "Calc": "N", "Target": 220.826147111901008}, "First component weight": {"UoM": "kg", "Calc": "Y", "Target": 200}}, "Slab dimensions": {"slab width": {"Set": 65, "UoM": "cm", "+ tol": 7, "- tol": 3, "Target": 68}, "slab thickness": {"Set": 5.5, "UoM": "mm", "+ tol": 2, "- tol": 2, "Target": 7.5}}, "default property group": {"volgnummer": {"Value": 10}, "BOM alternative": {"Plant": null, "Usage": null, "Alternative": "2"}}}}, "Properties": {"(none)": {"Properties FM": {"M300%": {"LSL": 12.0999999999999996, "LWL": 12.8000000000000007, "USL": 17.5, "UWL": 16.8000000000000007, "UoM": "MPa", "Target": 14.8000000000000007, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP002AN"}, "Ash (TGA)": {"LSL": 11.3000000000000007, "LWL": 11.5999999999999996, "USL": 13.9000000000000004, "UWL": 13.5999999999999996, "UoM": "%", "Target": 12.5999999999999996, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TC001AA"}, "Polymer (TGA)": {"LSL": 47.6000000000000014, "LWL": 48.3999999999999986, "USL": 54.2000000000000028, "UWL": 53.3999999999999986, "UoM": "%", "Target": 50.8999999999999986, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TC001AA"}, "Volatile (TGA)": {"LSL": 7.90000000000000036, "LWL": 8.40000000000000036, "USL": 11.9000000000000004, "UWL": 11.4000000000000004, "UoM": "%", "Target": 9.90000000000000036, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TC001AA"}, "Rebound (70°C)": {"LSL": 47, "LWL": 48, "USL": null, "UWL": null, "UoM": "%", "Target": 51.5, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP019AA"}, "Tensile strength": {"LSL": 14.5, "LWL": 15.0999999999999996, "USL": 19.5, "UWL": 18.9000000000000021, "UoM": "MPa", "Target": 17, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP002AN"}, "Hardness (median)": {"LSL": 75.7999999999999972, "LWL": 76.7999999999999972, "USL": 83.7999999999999972, "UWL": 82.7999999999999972, "UoM": "°Shore A", "Target": 79.7999999999999972, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP001AA"}, "Carbon black (TGA)": {"LSL": 24.3000000000000007, "LWL": 25, "USL": 29.6999999999999993, "UWL": 29, "UoM": "%", "Target": 27, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TC001AA"}, "Elongation at break": {"LSL": 320, "LWL": 330, "USL": null, "UWL": null, "UoM": "%", "Target": 350, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP002AN"}, "Tear strength (delft)": {"LSL": 8.5, "LWL": 9.20000000000000107, "USL": null, "UWL": null, "UoM": "MPa", "Target": 11.4000000000000004, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP004AB"}, "Filler Dispersion (DG)": {"LSL": 70, "LWL": 73, "USL": null, "UWL": null, "UoM": "%", "Target": 80, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP005CA"}, "Tack compound 0d at RT": {"LSL": 18, "LWL": 20, "USL": null, "UWL": null, "UoM": "N", "Target": 30, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP010AA"}}, "Calculation properties": {"Density": {"UoM": "kg/l", "Value": 1.19344773521648984}, "Rubber content": {"UoM": "%", "Value": 50.2184502586250048}}, "Greenstrength at 23°C": {"E-modulus at 23°C": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "MPa", "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP003AA"}, "Yield stress at 23°C": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "MPa", "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP003AA"}, "Yield elongation at 23°C": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "%", "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP003AA"}}, "Greenstrength at 40°C": {"E-modulus at 40°C": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "MPa", "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP003BA"}, "Yield stress at 40°C": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "MPa", "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP003BA"}, "Yield elongation at 40°C": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "%", "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP003BA"}}, "Rheological properties": {"Mv (135°C)": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "M.U.", "Target": 56, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP012B"}, "t5 (135°C)": {"LSL": 6.60000000000000053, "LWL": 7.29999999999999982, "USL": 12, "UWL": 11.3000000000000007, "UoM": "min", "Target": 9.30000000000000071, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP012B"}, "G'100 (100°C)": {"LSL": 0.0599999999999999978, "LWL": 0.0650000000000000022, "USL": 0.0899999999999999967, "UWL": 0.0850000000000000061, "UoM": "MPa", "Target": 0.0749999999999999972, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP014A"}, "n''5% (100°C)": {"LSL": null, "LWL": 10000, "USL": null, "UWL": 13000, "UoM": "Pa.s", "Target": 11500, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP015A"}, "G'0.56 (100°C)": {"LSL": null, "LWL": null, "USL": 0.450000000000000011, "UWL": 0.429999999999999993, "UoM": "MPa", "Target": 0.369999999999999996, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP014A"}, "Mooney ML(1+4) 100°C": {"LSL": 60.5, "LWL": 61.5, "USL": 72.5, "UWL": 71.5, "UoM": "M.U.", "Target": 66.5, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP011A"}, "Mooney ML(1+1.5) 135°C": {"LSL": null, "LWL": 51, "USL": null, "UWL": 63, "UoM": "M.U.", "Target": 57, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP012B"}}, "default property group": {"Test time MDR 190°C": {"UoM": "min", "Value": 2.75, "Apollo test code": "TP013B"}}, "Ozon-cracking - static (ISO)": {"Cracklevel 24h (static)": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": null, "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP009AA"}, "Cracklevel 48h (static)": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": null, "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP009AA"}, "Cracklevel 72h (static)": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": null, "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP009AA"}}, "Ozon-cracking - dynamic (ISO)": {"Cracklevel 24h (dynamic)": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": null, "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP009CA"}, "Cracklevel 48h (dynamic)": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": null, "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP009CA"}, "Cracklevel 72h (dynamic)": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": null, "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP009CA"}}, "MDR vulcanisation properties, 190°C": {"MH 190°C": {"LSL": 23.2300000000000004, "LWL": 23.7600000000000016, "USL": 29.5700000000000003, "UWL": 29.0399999999999991, "UoM": "dNm", "Target": 26.4000000000000021, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013B"}, "ML 190°C": {"LSL": 1.6100000000000001, "LWL": 1.71999999999999997, "USL": 2.41999999999999993, "UWL": 2.31999999999999984, "UoM": "dNm", "Target": 2.02000000000000002, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013B"}, "ts1 190°C": {"LSL": 0.424000000000000044, "LWL": 0.433999999999999997, "USL": 0.540000000000000036, "UWL": 0.530000000000000027, "UoM": "min", "Target": 0.48200000000000004, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013B"}, "t50%  190°C": {"LSL": 0.747999999999999998, "LWL": 0.765000000000000013, "USL": 0.952000000000000068, "UWL": 0.935000000000000053, "UoM": "min", "Target": 0.849999999999999978, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013B"}, "t90%  190°C": {"LSL": 1.26700000000000013, "LWL": 1.23799999999999999, "USL": 1.61299999999999999, "UWL": 1.58400000000000007, "UoM": "min", "Target": 1.43999999999999995, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013B"}}, "RPA vulcanisation properties, 160°C": {"MH 160°C": {"LSL": 28.6999999999999993, "LWL": 29.6999999999999993, "USL": 36.7000000000000028, "UWL": 35.7000000000000028, "UoM": "dNm", "Target": 32.7000000000000028, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013P"}, "ML 160°C": {"LSL": 1.60000000000000009, "LWL": 1.80000000000000004, "USL": 2.80000000000000027, "UWL": 2.60000000000000009, "UoM": "dNm", "Target": 2.20000000000000018, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013P"}, "t95 160°C": {"LSL": 9.20000000000000107, "LWL": 9.70000000000000107, "USL": 13.2000000000000011, "UWL": 12.7000000000000011, "UoM": "min", "Target": 11.2000000000000011, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013P"}, "ts1 160°C": {"LSL": 1, "LWL": 1.15000000000000013, "USL": 2.20000000000000018, "UWL": 2.04999999999999982, "UoM": "min", "Target": 1.60000000000000009, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013P"}, "ts2 160°C": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": "min", "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013P"}, "Tan ¿ 60°C (RPA)": {"LSL": null, "LWL": null, "USL": null, "UWL": null, "UoM": null, "Target": null, "Cr. par.": "N", "Int. method": null, "Apollo test code": "TP013P"}}}}, "Controlplan": {"(none)": {"Controlplan FM": {"RPA payne effect": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP014A", "Sampling interval": 50}, "Mooney ML(1+4) 100°C": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP011A", "Sampling interval": 50}, "Tear strength (delft)": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP004AB", "Sampling interval": 200}, "Filler Dispersion (DG)": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP005CA", "Sampling interval": 100}, "Tack compound 0d at RT": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP010AA", "Sampling interval": 200}, "RPA viscosity measurement": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP015A", "Sampling interval": 100}, "Durometer hardness shore A": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP001AA", "Sampling interval": 100}, "Mooney Scorch t5 at 135°C": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP012B", "Sampling interval": 50}, "Rebound measurement at 70°C": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP019AA", "Sampling interval": 50}, "TGA of rubbers, 9' at 170°C": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TC001AA", "Sampling interval": 200}, "Tensile strength rubber (rc)": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP002AN", "Sampling interval": 200}, "RPA vulcanisation properties, 160°C": {"Report": null, "Sample size": 1, "Interval type": "Batch", "Reaction plan": null, "Responsibility": "laboratory", "Apollo test code": "TP013P", "Sampling interval": 50}}}}, "Description": "STAALKOORD KE21 WIT", "Item Number": 20, "alternative": 1, "FUNCTIONCODE": "Composite compound", "SAP information": {"(none)": {"Aging SAP": {"Aging (Maximal)": {"UoM": "day", "Value": 30}, "Aging (minimal)": {"UoM": "hours", "Value": 0}}, "default property group": {"Weight": {"UoM": null, "Value": 1}, "Article type": {"Value": "I: Halffabrikaten Alternatief"}, "Packaging PG": {"Amount": 221, "Packaging": "PALL"}, "Article group PG": {"Value": "JD: EINDMENGSEL                   "}, "Physical in product": {"Value": "Yes"}}}}, "Aging min. (hrs)": null, "Aging max. (days)": null, "Position in machine": null}}
*/



--***********************************************************************************
--***********************************************************************************
--***********************************************************************************
--***********************************************************************************
--*************************************************************************
-- util_interspec - MATERIALZED VIEWS !!!!!!!
--***********************************************************************************
--***********************************************************************************
--***********************************************************************************
--***********************************************************************************
--
--1.util_interspec.bom_header_property			
--2.util_interspec.bom_item_property
--3.util_interspec.bom_path_current
--4.util_interspec.frame_property_matrix
--5.util_interspec.specification
--6.util_interspec.specification_keyword
--7.util_interspec.specification_property
--8.util_interspec.specification_property_matrix 
--9.util_interspec.specification_section
--10.util_interspec.specification_status 
--
--100.util_unilab.avtestmethod


--1,util_interspec.bom_header_property source
CREATE MATERIALIZED VIEW util_interspec.bom_header_property
TABLESPACE pg_default
AS SELECT bh.part_no,
    bh.revision,
    bh.plant,
    bh.alternative,
    bh.preferred,
    bh.bom_usage,
    bh.base_quantity,
    bh.description,
    bh.yield,
    bh.conv_factor,
    bh.to_unit,
    ls.layout_id,
    ls.preferred AS layout_preferred,
    jsonb_object_agg(h.description,
        CASE li.field_id
            WHEN 1 THEN to_jsonb(bh.plant)
            WHEN 3 THEN to_jsonb(bh.alternative)
            WHEN 6 THEN to_jsonb(bh.base_quantity)
            WHEN 5 THEN to_jsonb(bh.description)
            WHEN 12 THEN to_jsonb(bh.max_qty)
            WHEN 13 THEN to_jsonb(bh.plant_effective_date)
            ELSE NULL::jsonb
        END) AS properties
   FROM rd_interspec_webfocus.bom_header bh
     JOIN rd_interspec_webfocus.part p ON p.part_no::text = bh.part_no::text
     JOIN rd_interspec_webfocus.itbomlysource ls ON ls.source::text = p.part_source::text
     JOIN rd_interspec_webfocus.itbomlyitem li ON li.layout_id::double precision = ls.layout_id AND li.revision::double precision = ls.layout_rev
     JOIN rd_interspec_webfocus.header h USING (header_id)
     JOIN util_interspec.bom_layout_type lt ON lt.type::double precision = ls.layout_type
  WHERE lt.table_name::text = 'bom_header'::text AND ls.preferred = 1::numeric
  GROUP BY bh.part_no, bh.revision, bh.plant, bh.alternative, bh.bom_usage, bh.base_quantity, bh.description, bh.yield, bh.conv_factor, bh.to_unit, ls.layout_id, ls.preferred
WITH DATA;

-- View indexes:
CREATE UNIQUE INDEX bom_header_property_part_alt_uq ON util_interspec.bom_header_property USING btree (part_no, revision, alternative, plant, bom_usage);
CREATE UNIQUE INDEX bom_header_property_pk ON util_interspec.bom_header_property USING btree (part_no, revision, plant, alternative, bom_usage);
CREATE INDEX bom_header_property_properties_idx ON util_interspec.bom_header_property USING gin (properties);



--2.util_interspec.bom_item_property
CREATE MATERIALIZED VIEW util_interspec.bom_item_property
TABLESPACE pg_default
AS SELECT bi.part_no,
    bi.revision,
    bi.plant,
    bi.alternative,
    bi.bom_usage,
    bi.item_number,
    bi.component_part,
    bi.component_revision,
    bi.component_plant,
    bi.quantity,
    bi.uom,
    bi.conv_factor,
    bi.to_unit,
    bi.yield,
    bi.item_category,
    bi.issue_location,
    bi.alt_group,
    bi.alt_priority,
    bi.make_up,
    bi.intl_equivalent,
    bi.component_scrap_sync,
    ls.layout_id,
    ls.preferred AS layout_preferred,
    jsonb_object_agg(h.description,
        CASE bf.name
            WHEN 'component_part'::text THEN to_jsonb(bi.component_part)
            WHEN 'description'::text THEN to_jsonb(p.description)
            WHEN 'component_plant'::text THEN to_jsonb(bi.component_plant)
            WHEN 'quantity'::text THEN to_jsonb(bi.quantity)
            WHEN 'uom'::text THEN to_jsonb(bi.uom)
            WHEN 'to_unit'::text THEN to_jsonb(bi.to_unit)
            WHEN 'conv_factor'::text THEN to_jsonb(bi.conv_factor)
            WHEN 'yield'::text THEN to_jsonb(bi.yield)
            WHEN 'assembly_scrap'::text THEN to_jsonb(bi.assembly_scrap)
            WHEN 'component_scrap'::text THEN to_jsonb(bi.component_scrap)
            WHEN 'lead_time_offset'::text THEN to_jsonb(bi.lead_time_offset)
            WHEN 'relevancy_to_costing'::text THEN to_jsonb(bi.relevency_to_costing)
            WHEN 'bulk_material'::text THEN to_jsonb(bi.bulk_material)
            WHEN 'item_category'::text THEN to_jsonb(bi.item_category)
            WHEN 'issue_location'::text THEN to_jsonb(bi.issue_location)
            WHEN 'calc_flag'::text THEN to_jsonb(bi.calc_flag)
            WHEN 'bom_item_type'::text THEN to_jsonb(bi.bom_item_type)
            WHEN 'operational_step'::text THEN to_jsonb(bi.operational_step)
            WHEN 'min_qty'::text THEN to_jsonb(bi.min_qty)
            WHEN 'max_qty'::text THEN to_jsonb(bi.max_qty)
            WHEN 'fixed_qty'::text THEN to_jsonb(bi.fixed_qty)
            WHEN 'component_revision'::text THEN to_jsonb(bi.component_revision)
            WHEN 'item_number'::text THEN to_jsonb(bi.item_number)
            WHEN 'char_1'::text THEN to_jsonb(bi.char_1)
            WHEN 'char_2'::text THEN to_jsonb(bi.char_2)
            WHEN 'code'::text THEN to_jsonb(bi.code)
            WHEN 'num_1'::text THEN to_jsonb(bi.num_1)
            WHEN 'num_2'::text THEN to_jsonb(bi.num_2)
            WHEN 'num_3'::text THEN to_jsonb(bi.num_3)
            WHEN 'num_4'::text THEN to_jsonb(bi.num_4)
            WHEN 'num_5'::text THEN to_jsonb(bi.num_5)
            WHEN 'char_3'::text THEN to_jsonb(bi.char_3)
            WHEN 'char_4'::text THEN to_jsonb(bi.char_4)
            WHEN 'char_5'::text THEN to_jsonb(bi.char_5)
            WHEN 'boolean_1'::text THEN to_jsonb(bi.boolean_1)
            WHEN 'boolean_2'::text THEN to_jsonb(bi.boolean_2)
            WHEN 'boolean_3'::text THEN to_jsonb(bi.boolean_3)
            WHEN 'boolean_4'::text THEN to_jsonb(bi.boolean_4)
            WHEN 'date_1'::text THEN to_jsonb(bi.date_1)
            WHEN 'date_2'::text THEN to_jsonb(bi.date_2)
            WHEN 'characteristic_1'::text THEN ( SELECT to_jsonb(characteristic.description) AS to_jsonb
               FROM rd_interspec_webfocus.characteristic
              WHERE characteristic.characteristic_id = bi.ch_1)
            WHEN 'characteristic_2'::text THEN ( SELECT to_jsonb(characteristic.description) AS to_jsonb
               FROM rd_interspec_webfocus.characteristic
              WHERE characteristic.characteristic_id = bi.ch_2)
            WHEN 'characteristic_2'::text THEN ( SELECT to_jsonb(characteristic.description) AS to_jsonb
               FROM rd_interspec_webfocus.characteristic
              WHERE characteristic.characteristic_id = bi.ch_3)
            ELSE NULL::jsonb
        END) AS properties
   FROM rd_interspec_webfocus.bom_item bi
     JOIN rd_interspec_webfocus.part p ON p.part_no::text = bi.part_no::text
     JOIN rd_interspec_webfocus.itbomlysource ls ON ls.source::text = p.part_source::text
     JOIN rd_interspec_webfocus.itbomlyitem li ON li.layout_id::double precision = ls.layout_id AND li.revision::double precision = ls.layout_rev
     JOIN rd_interspec_webfocus.header h USING (header_id)
     JOIN util_interspec.bom_field bf USING (field_id)
     JOIN util_interspec.bom_layout_type lt ON lt.type::double precision = ls.layout_type
  WHERE lt.table_name::text = 'bom_item'::text AND ls.preferred = 1::numeric
  GROUP BY bi.part_no, bi.revision, bi.plant, bi.alternative, bi.bom_usage, bi.item_number, bi.component_part, bi.component_revision, bi.component_plant, bi.quantity, bi.uom, bi.conv_factor, bi.to_unit, bi.yield, bi.item_category, bi.issue_location, bi.alt_group, bi.alt_priority, bi.make_up, bi.intl_equivalent, bi.component_scrap_sync, ls.layout_id, ls.preferred
WITH DATA;

-- View indexes:
CREATE INDEX bom_item_property_component_idx ON util_interspec.bom_item_property USING btree (component_part, alternative, part_no, revision, plant);
CREATE UNIQUE INDEX bom_item_property_part_component_alt_uq ON util_interspec.bom_item_property USING btree (part_no, revision, component_part, alternative, plant, item_number, bom_usage);
CREATE UNIQUE INDEX bom_item_property_pk ON util_interspec.bom_item_property USING btree (part_no, revision, plant, alternative, bom_usage, item_number);
CREATE INDEX bom_item_property_properties_idx ON util_interspec.bom_item_property USING gin (properties);
CREATE UNIQUE INDEX bom_item_property_text_pk ON util_interspec.bom_item_property USING btree (((part_no)::text), revision, ((plant)::text), alternative, bom_usage, item_number);



--3.util_interspec.bom_path_current
CREATE MATERIALIZED VIEW util_interspec.bom_path_current
TABLESPACE pg_default
AS SELECT source.part_no::text AS source_part_no,
    source.revision::integer AS source_revision,
    tree.component_part_no AS destination_part_no,
    tree.component_revision::integer AS destination_revision,
    tree.part_path,
    tree.function_path,
    tree.hierarchy
   FROM util_interspec.specification_status source
     JOIN rd_interspec_webfocus.bom_header sbh USING (part_no, revision)
     CROSS JOIN LATERAL util_interspec.bom_explode(sbh.part_no::text, sbh.revision, sbh.alternative, sbh.plant::text) tree(part_no, revision, component_part_no, component_revision, class3_id, plant, alternative, preferred, keywords, spec_function, level, item_number, bom_function, properties, hierarchy, part_path, function_path, contains_cycle, quantity, total_quantity)
  WHERE source.frame_id::text = 'A_PCR'::text AND source.status_type::text = 'CURRENT'::text AND source.status_code::text <> 'TEMP CRRNT'::text AND NOT (EXISTS ( SELECT 1
           FROM rd_interspec_webfocus.bom_item
          WHERE bom_item.part_no::text = tree.component_part_no))
WITH DATA;

-- View indexes:
CREATE INDEX bom_path_current_destination_part_idx ON util_interspec.bom_path_current USING btree (destination_part_no);
CREATE INDEX bom_path_current_function_path_idx ON util_interspec.bom_path_current USING gist (function_path);
CREATE INDEX bom_path_current_part_path_idx ON util_interspec.bom_path_current USING gist (part_path);
CREATE UNIQUE INDEX bom_path_current_uq ON util_interspec.bom_path_current USING btree (source_part_no, source_revision, hierarchy);



--4.util_interspec.frame_property_matrix
CREATE MATERIALIZED VIEW util_interspec.frame_property_matrix
TABLESPACE pg_default
AS SELECT fp.frame_no,
    fp.revision,
    fp.section_id,
    fp.sub_section_id,
    fp.property_group,
    fp.property,
    fp.sequence_no,
    fp.attribute,
    fp.attribute_rev,
    fp.uom_id,
    fp.uom_rev,
    fp.uom_alt_id,
    fp.uom_alt_rev,
    fp.test_method,
    fp.test_method_rev,
    fp.intl,
    fs.display_format,
    fs.display_format_rev,
    fs.type,
    fs.section_sequence_no,
    h.description AS cell,
    pl.start_pos AS cell_seq,
    upf.name AS cell_field
   FROM rd_interspec_webfocus.frame_prop fp
     JOIN rd_interspec_webfocus.frame_section fs USING (frame_no, revision, section_id, sub_section_id)
     JOIN rd_interspec_webfocus.property_layout pl(id, dt_created, dt_updated, md5_hash, original, layout_id, header_id, field_id, included, start_pos, length, alignment, format_id, header, color, bold, underline, intl, revision_1, header_rev, def, url, attached_spec) ON pl.layout_id = fs.display_format AND pl.revision_1 = fs.display_format_rev
     JOIN util_interspec.property_field upf USING (field_id)
     JOIN rd_interspec_webfocus.header h USING (header_id)
  WHERE fs.type = 1::numeric AND fs.ref_id = fp.property_group OR fs.type = 4::numeric AND fs.ref_id = fp.property
WITH DATA;

-- View indexes:
CREATE UNIQUE INDEX frame_property_matrix_frame_no_uq ON util_interspec.frame_property_matrix USING btree (frame_no, revision, section_id, sub_section_id, property_group, property, type, cell_field, section_sequence_no, display_format, attribute);
CREATE INDEX frame_property_matrix_section_cell_idx ON util_interspec.frame_property_matrix USING btree (section_id, sub_section_id, frame_no, revision, property_group, property, cell, display_format, sequence_no, section_sequence_no) INCLUDE (cell_field, cell_seq);
CREATE INDEX frame_property_matrix_section_field_idx ON util_interspec.frame_property_matrix USING btree (section_id, frame_no, revision, property_group, property, cell_field, display_format, sequence_no, section_sequence_no) INCLUDE (cell, cell_seq);



--5.util_interspec.specification
CREATE MATERIALIZED VIEW util_interspec.specification
TABLESPACE pg_default
AS SELECT subsec.part_no,
    subsec.revision,
    sh.status,
    sh.frame_id,
    sh.class3_id,
    sh.issued_date,
    sh.obsolescence_date,
    sk.functionkw,
    jsonb_object_agg(s.description, subsec.properties) AS properties,
    sk.keywords
   FROM ( SELECT propgrp.part_no,
            propgrp.revision,
            propgrp.section_id,
            jsonb_object_agg(ss.description, propgrp.properties) AS properties
           FROM ( SELECT prop.part_no,
                    prop.revision,
                    prop.section_id,
                    prop.sub_section_id,
                    jsonb_object_agg(pg.description, prop.properties) AS properties
                   FROM ( SELECT sp.part_no,
                            sp.revision,
                            sp.section_id,
                            sp.sub_section_id,
                            sp.property_group,
                            jsonb_object_agg(p.description, sp.cells - 'Property'::text) AS properties
                           FROM util_interspec.specification_property sp
                             JOIN rd_interspec_webfocus.property p USING (property)
                          GROUP BY sp.part_no, sp.revision, sp.section_id, sp.sub_section_id, sp.property_group) prop
                     JOIN rd_interspec_webfocus.property_group pg USING (property_group)
                  GROUP BY prop.part_no, prop.revision, prop.section_id, prop.sub_section_id) propgrp
             JOIN rd_interspec_webfocus.sub_section ss USING (sub_section_id)
          GROUP BY propgrp.part_no, propgrp.revision, propgrp.section_id) subsec
     JOIN rd_interspec_webfocus.section s USING (section_id)
     JOIN rd_interspec_webfocus.specification_header sh USING (part_no, revision)
     LEFT JOIN util_interspec.specification_keyword sk USING (part_no)
  GROUP BY subsec.part_no, subsec.revision, sh.status, sh.frame_id, sh.class3_id, sh.issued_date, sh.obsolescence_date, sk.functionkw, sk.keywords
WITH DATA;

-- View indexes:
CREATE INDEX specification_class_idx ON util_interspec.specification USING btree (class3_id, part_no, revision);
CREATE INDEX specification_frame_function_status_idx ON util_interspec.specification USING btree (frame_id, functionkw, status, part_no, revision);
CREATE INDEX specification_function_idx ON util_interspec.specification USING btree (functionkw, part_no, revision);
CREATE INDEX specification_keywords_idx ON util_interspec.specification USING gin (keywords);
CREATE INDEX specification_properties_idx ON util_interspec.specification USING gin (properties);
CREATE INDEX specification_qrphase_phase_idx ON util_interspec.specification USING btree (jsonb_object_field_text(jsonb_object_field(jsonb_object_field(jsonb_object_field(jsonb_object_field(properties, 'SAP information'::text), '(none)'::text), 'SAP information'::text), 'QR phase'::text), 'Value'::text), part_no, revision);
CREATE INDEX specification_qrphase_phase_pidx ON util_interspec.specification USING btree (jsonb_object_field_text(jsonb_object_field(jsonb_object_field(jsonb_object_field(jsonb_object_field(properties, 'SAP information'::text), '(none)'::text), 'SAP information'::text), 'QR phase'::text), 'Value'::text), part_no, revision) WHERE (jsonb_object_field_text(jsonb_object_field(jsonb_object_field(jsonb_object_field(jsonb_object_field(properties, 'SAP information'::text), '(none)'::text), 'SAP information'::text), 'QR phase'::text), 'Value'::text) IS NOT NULL);
CREATE UNIQUE INDEX specification_uq ON util_interspec.specification USING btree (part_no, revision);



--6.util_interspec.specification_keyword
CREATE MATERIALIZED VIEW util_interspec.specification_keyword
TABLESPACE pg_default
AS SELECT k.part_no,
    max(k.elem) FILTER (WHERE k.key::text = 'Function'::text) AS functionkw,
    jsonb_object_agg(k.key, k.value) AS keywords
   FROM ( SELECT sk.part_no,
            k_1.description AS key,
            json_agg(sk.kw_value ORDER BY k_1.description, sk.kw_value) AS value,
            array_agg(sk.kw_value ORDER BY sk.kw_value) AS elem
           FROM rd_interspec_webfocus.specification_kw sk
             JOIN rd_interspec_webfocus.itkw k_1 USING (kw_id)
          WHERE sk.kw_value::text <> '<Any>'::text
          GROUP BY sk.part_no, k_1.description) k
  GROUP BY k.part_no
WITH DATA;

-- View indexes:
CREATE INDEX specification_keyword_function_idx ON util_interspec.specification_keyword USING gin (functionkw);
CREATE INDEX specification_keyword_keywords_idx ON util_interspec.specification_keyword USING gin (keywords);
CREATE UNIQUE INDEX specification_keyword_uq ON util_interspec.specification_keyword USING btree (part_no);



--7.util_interspec.specification_property
CREATE MATERIALIZED VIEW util_interspec.specification_property
TABLESPACE pg_default
AS SELECT sp.part_no,
    sp.revision,
    sp.section_id,
    sp.sub_section_id,
    sp.property_group,
    sp.property,
    sp.sequence_no,
    sp.attribute,
    sp.attribute_rev,
    sp.uom_id,
    sp.uom_rev,
    sp.uom_alt_id,
    sp.uom_alt_rev,
    sp.test_method,
    sp.test_method_rev,
    sp.intl,
    sp.info,
    ss.display_format,
    ss.display_format_rev,
    ss.section_sequence_no,
    jsonb_object_agg(h.description,
        CASE upf.name
            WHEN 'num_1'::text THEN to_jsonb(sp.num_1)
            WHEN 'num_2'::text THEN to_jsonb(sp.num_2)
            WHEN 'num_3'::text THEN to_jsonb(sp.num_3)
            WHEN 'num_4'::text THEN to_jsonb(sp.num_4)
            WHEN 'num_5'::text THEN to_jsonb(sp.num_5)
            WHEN 'num_6'::text THEN to_jsonb(sp.num_6)
            WHEN 'num_7'::text THEN to_jsonb(sp.num_7)
            WHEN 'num_8'::text THEN to_jsonb(sp.num_8)
            WHEN 'num_9'::text THEN to_jsonb(sp.num_9)
            WHEN 'num_10'::text THEN to_jsonb(sp.num_10)
            WHEN 'char_1'::text THEN to_jsonb(sp.char_1)
            WHEN 'char_2'::text THEN to_jsonb(sp.char_2)
            WHEN 'char_3'::text THEN to_jsonb(sp.char_3)
            WHEN 'char_4'::text THEN to_jsonb(sp.char_4)
            WHEN 'char_5'::text THEN to_jsonb(sp.char_5)
            WHEN 'char_6'::text THEN to_jsonb(sp.char_6)
            WHEN 'uom'::text THEN to_jsonb(sp.uom)
            WHEN 'test_method_1'::text THEN to_jsonb(sp.test_method_1)
            WHEN 'property_1'::text THEN to_jsonb(sp.property_1)
            WHEN 'info'::text THEN to_jsonb(sp.info)
            WHEN 'attribute'::text THEN to_jsonb(sp.attribute)
            WHEN 'boolean_1'::text THEN to_jsonb(sp.boolean_1)
            WHEN 'boolean_2'::text THEN to_jsonb(sp.boolean_2)
            WHEN 'boolean_3'::text THEN to_jsonb(sp.boolean_3)
            WHEN 'boolean_4'::text THEN to_jsonb(sp.boolean_4)
            WHEN 'tm_det_1'::text THEN to_jsonb(sp.tm_det_1)
            WHEN 'tm_det_2'::text THEN to_jsonb(sp.tm_det_2)
            WHEN 'tm_det_3'::text THEN to_jsonb(sp.tm_det_3)
            WHEN 'tm_det_4'::text THEN to_jsonb(sp.tm_det_4)
            WHEN 'date_1'::text THEN to_jsonb(sp.date_1)
            WHEN 'date_2'::text THEN to_jsonb(sp.date_2)
            WHEN 'characteristic_1'::text THEN to_jsonb(sp.characteristic_1)
            WHEN 'characteristic_2'::text THEN to_jsonb(sp.characteristic_2)
            WHEN 'characteristic_3'::text THEN to_jsonb(sp.characteristic_3)
            ELSE NULL::jsonb
        END) AS cells,
    jsonb_object_agg(h.description, pl.start_pos) AS cell_seq,
    jsonb_object_agg(h.description, upf.name) AS cell_field
   FROM util_interspec.v_specification_prop sp
     JOIN rd_interspec_webfocus.specification_section ss USING (part_no, revision, section_id, sub_section_id)
     JOIN rd_interspec_webfocus.property_layout pl(id, dt_created, dt_updated, md5_hash, original, layout_id, header_id, field_id, included, start_pos, length, alignment, format_id, header, color, bold, underline, intl, revision_1, header_rev, def, url, attached_spec) ON pl.layout_id = ss.display_format AND pl.revision_1 = ss.display_format_rev
     JOIN util_interspec.property_field upf USING (field_id)
     JOIN rd_interspec_webfocus.header h USING (header_id)
  WHERE ss.type = 1::numeric AND ss.ref_id = sp.property_group OR ss.type = 4::numeric AND ss.ref_id = sp.property
  GROUP BY ss.display_format, ss.display_format_rev, ss.section_sequence_no, sp.part_no, sp.revision, sp.section_id, sp.sub_section_id, sp.property_group, sp.property, sp.sequence_no, sp.attribute, sp.attribute_rev, sp.uom_id, sp.uom_rev, sp.uom_alt_id, sp.uom_alt_rev, sp.test_method, sp.test_method_rev, sp.intl, sp.info
WITH DATA;

-- View indexes:
CREATE INDEX specification_property_cell_seq_idx ON util_interspec.specification_property USING gin (cell_seq);
CREATE INDEX specification_property_cells_idx ON util_interspec.specification_property USING gin (cells);
CREATE UNIQUE INDEX specification_property_part_no_uq ON util_interspec.specification_property USING btree (part_no, revision, section_id, sub_section_id, property_group, property, section_sequence_no, display_format, attribute);
CREATE INDEX specification_property_section_idx ON util_interspec.specification_property USING btree (section_id, part_no, revision, property_group, property, display_format, sequence_no, section_sequence_no, attribute);




--8.util_interspec.specification_property_matrix 
CREATE MATERIALIZED VIEW util_interspec.specification_property_matrix
TABLESPACE pg_default
AS SELECT sp.part_no,
    sp.revision,
    sp.section_id,
    sp.sub_section_id,
    sp.property_group,
    sp.property,
    sp.sequence_no,
    sp.attribute,
    sp.attribute_rev,
    sp.uom_id,
    sp.uom_rev,
    sp.uom_alt_id,
    sp.uom_alt_rev,
    sp.test_method,
    sp.test_method_rev,
    sp.intl,
    sp.info,
    ss.display_format,
    ss.display_format_rev,
    ss.type,
    ss.section_sequence_no,
    h.description AS cell,
    pl.start_pos AS cell_seq,
    upf.name AS cell_field,
        CASE upf.name
            WHEN 'num_1'::text THEN to_jsonb(sp.num_1)
            WHEN 'num_2'::text THEN to_jsonb(sp.num_2)
            WHEN 'num_3'::text THEN to_jsonb(sp.num_3)
            WHEN 'num_4'::text THEN to_jsonb(sp.num_4)
            WHEN 'num_5'::text THEN to_jsonb(sp.num_5)
            WHEN 'num_6'::text THEN to_jsonb(sp.num_6)
            WHEN 'num_7'::text THEN to_jsonb(sp.num_7)
            WHEN 'num_8'::text THEN to_jsonb(sp.num_8)
            WHEN 'num_9'::text THEN to_jsonb(sp.num_9)
            WHEN 'num_10'::text THEN to_jsonb(sp.num_10)
            WHEN 'char_1'::text THEN to_jsonb(sp.char_1)
            WHEN 'char_2'::text THEN to_jsonb(sp.char_2)
            WHEN 'char_3'::text THEN to_jsonb(sp.char_3)
            WHEN 'char_4'::text THEN to_jsonb(sp.char_4)
            WHEN 'char_5'::text THEN to_jsonb(sp.char_5)
            WHEN 'char_6'::text THEN to_jsonb(sp.char_6)
            WHEN 'uom'::text THEN to_jsonb(sp.uom)
            WHEN 'test_method_1'::text THEN to_jsonb(sp.test_method_1)
            WHEN 'property_1'::text THEN to_jsonb(sp.property_1)
            WHEN 'info'::text THEN to_jsonb(sp.info)
            WHEN 'attribute'::text THEN to_jsonb(sp.attribute)
            WHEN 'boolean_1'::text THEN to_jsonb(sp.boolean_1)
            WHEN 'boolean_2'::text THEN to_jsonb(sp.boolean_2)
            WHEN 'boolean_3'::text THEN to_jsonb(sp.boolean_3)
            WHEN 'boolean_4'::text THEN to_jsonb(sp.boolean_4)
            WHEN 'tm_det_1'::text THEN to_jsonb(sp.tm_det_1)
            WHEN 'tm_det_2'::text THEN to_jsonb(sp.tm_det_2)
            WHEN 'tm_det_3'::text THEN to_jsonb(sp.tm_det_3)
            WHEN 'tm_det_4'::text THEN to_jsonb(sp.tm_det_4)
            WHEN 'date_1'::text THEN to_jsonb(sp.date_1)
            WHEN 'date_2'::text THEN to_jsonb(sp.date_2)
            WHEN 'characteristic_1'::text THEN to_jsonb(sp.characteristic_1)
            WHEN 'characteristic_2'::text THEN to_jsonb(sp.characteristic_2)
            WHEN 'characteristic_3'::text THEN to_jsonb(sp.characteristic_3)
            ELSE NULL::jsonb
        END AS cell_value
   FROM util_interspec.v_specification_prop2 sp
     JOIN util_interspec.specification_section ss USING (part_no, revision, section_id, sub_section_id)
     JOIN rd_interspec_webfocus.property_layout pl(id, dt_created, dt_updated, md5_hash, original, layout_id, header_id, field_id, included, start_pos, length, alignment, format_id, header, color, bold, underline, intl, revision_1, header_rev, def, url, attached_spec) ON pl.layout_id = ss.display_format AND pl.revision_1 = ss.display_format_rev
     JOIN util_interspec.property_field upf USING (field_id)
     JOIN rd_interspec_webfocus.header h USING (header_id)
  WHERE ss.type = 1::numeric AND ss.ref_id = sp.property_group OR ss.type = 4::numeric AND ss.ref_id = sp.property
WITH DATA;

-- View indexes:
CREATE INDEX specification_matrix_part_section_sub_group_property_idx ON util_interspec.specification_property_matrix USING btree (part_no, revision, section_id, sub_section_id, property_group, property);
CREATE UNIQUE INDEX specification_property_matrix_part_no_uq ON util_interspec.specification_property_matrix USING btree (part_no, revision, section_id, sub_section_id, property_group, property, type, cell_field, section_sequence_no, display_format, attribute);
CREATE INDEX specification_property_matrix_section_cell_idx ON util_interspec.specification_property_matrix USING btree (section_id, sub_section_id, part_no, revision, property_group, property, cell, display_format, sequence_no, section_sequence_no) INCLUDE (cell_field, cell_seq);
CREATE INDEX specification_property_matrix_section_field_idx ON util_interspec.specification_property_matrix USING btree (section_id, part_no, revision, property_group, property, cell_field, display_format, sequence_no, section_sequence_no) INCLUDE (cell, cell_seq);



--9.util_interspec.specification_section
CREATE MATERIALIZED VIEW util_interspec.specification_section
TABLESPACE pg_default
AS SELECT DISTINCT ON (specification_section.part_no, specification_section.revision, specification_section.section_id, specification_section.sub_section_id, specification_section.type, specification_section.ref_id) specification_section.id,
    specification_section.dt_created,
    specification_section.dt_updated,
    specification_section.md5_hash,
    specification_section.original,
    specification_section.part_no,
    specification_section.revision,
    specification_section.section_id,
    specification_section.sub_section_id,
    specification_section.type,
    specification_section.ref_id,
    specification_section.section_sequence_no,
    specification_section.ref_ver,
    specification_section.ref_info,
    specification_section.sequence_no,
    specification_section.header,
    specification_section.mandatory,
    specification_section.display_format,
    specification_section.association,
    specification_section.intl,
    specification_section.section_rev,
    specification_section.sub_section_rev,
    specification_section.display_format_rev,
    specification_section.ref_owner,
    specification_section.locked
   FROM rd_interspec_webfocus.specification_section
  ORDER BY specification_section.part_no, specification_section.revision, specification_section.section_id, specification_section.sub_section_id, specification_section.type, specification_section.ref_id, specification_section.dt_created DESC
WITH DATA;

-- View indexes:
CREATE INDEX specification_section_display_format_display_format_rev_type_id ON util_interspec.specification_section USING btree (display_format, display_format_rev) INCLUDE (type);
CREATE INDEX specification_section_part_no_revision_idx ON util_interspec.specification_section USING btree (part_no, revision) INCLUDE (type, ref_id);
CREATE INDEX specification_section_section_id_part_no_rev_idx ON util_interspec.specification_section USING btree (section_id, part_no, revision);
CREATE UNIQUE INDEX specification_section_uq ON util_interspec.specification_section USING btree (part_no, revision, section_id, sub_section_id, type, ref_id);




--10.util_interspec.specification_status 
CREATE MATERIALIZED VIEW util_interspec.specification_status
TABLESPACE pg_default
AS SELECT h.part_no,
    h.revision,
    h.status,
    h.description,
    h.planned_effective_date,
    h.issued_date,
    h.obsolescence_date,
    h.status_change_date,
    h.phase_in_tolerance,
    h.created_by,
    h.created_on,
    h.last_modified_by,
    h.last_modified_on,
    h.frame_id,
    h.frame_rev,
    h.access_group,
    h.workflow_group_id,
    h.class3_id,
    h.owner,
    h.int_frame_no,
    h.int_frame_rev,
    h.int_part_no,
    h.int_part_rev,
    h.frame_owner,
    h.intl,
    h.multilang,
    h.uom_type,
    h.mask_id,
    h.ped_in_sync,
    h.locked,
    h.validity_range,
    h.is_trial,
    s.status_type,
    s.sort_desc AS status_code
   FROM rd_interspec_webfocus.v_specification_header h
     JOIN rd_interspec_webfocus.status s USING (status)
WITH DATA;

-- View indexes:
CREATE UNIQUE INDEX specification_status_current_uq ON util_interspec.specification_status USING btree (part_no, revision) WHERE (((status_type)::text = 'CURRENT'::text) AND ((status_code)::text <> 'TEMP CRRNT'::text));
CREATE INDEX specification_status_part_rev_type_issued_uq ON util_interspec.specification_status USING btree (part_no, revision, status_type, issued_date, planned_effective_date, obsolescence_date);
CREATE UNIQUE INDEX specification_status_part_uq ON util_interspec.specification_status USING btree (part_no, revision, status);
CREATE UNIQUE INDEX specification_status_status_uq ON util_interspec.specification_status USING btree (status, part_no, revision);
CREATE UNIQUE INDEX specification_status_uq ON util_interspec.specification_status USING btree (part_no, revision);




--100.util_unilab.avtestmethod
CREATE MATERIALIZED VIEW util_unilab.avtestmethod
TABLESPACE pg_default
AS SELECT av1.value AS testmethod,
    av2.value AS testmethoddesc,
    starts_with(av1.pa::text, av1.value::text) AS issummary,
    av1.sc,
    av1.pg,
    av1.pgnode,
    av1.pa,
    av1.panode,
    av1.tm_seq
   FROM ( SELECT uvscpaau.sc,
            uvscpaau.pg,
            uvscpaau.pgnode,
            uvscpaau.pa,
            uvscpaau.panode,
            uvscpaau.value,
            row_number() OVER (PARTITION BY uvscpaau.sc, uvscpaau.pg, uvscpaau.pgnode, uvscpaau.pa, uvscpaau.panode, uvscpaau.au ORDER BY uvscpaau.auseq) AS tm_seq
           FROM rd_unilab_webfocus.uvscpaau
          WHERE uvscpaau.au::text = 'avTestMethod'::text AND uvscpaau.value IS NOT NULL) av1
     LEFT JOIN ( SELECT uvscpaau.sc,
            uvscpaau.pg,
            uvscpaau.pgnode,
            uvscpaau.pa,
            uvscpaau.panode,
            uvscpaau.value,
            row_number() OVER (PARTITION BY uvscpaau.sc, uvscpaau.pg, uvscpaau.pgnode, uvscpaau.pa, uvscpaau.panode, uvscpaau.au ORDER BY uvscpaau.auseq) AS tm_seq
           FROM rd_unilab_webfocus.uvscpaau
          WHERE uvscpaau.au::text = 'avTestMethodDesc'::text AND uvscpaau.value IS NOT NULL) av2 ON av2.sc::text = av1.sc::text AND av2.pg::text = av1.pg::text AND av2.pgnode = av1.pgnode AND av2.pa::text = av1.pa::text AND av2.panode = av1.panode AND av2.tm_seq = av1.tm_seq
WITH DATA;

-- View indexes:
CREATE UNIQUE INDEX avtestmethod_pk ON util_unilab.avtestmethod USING btree (sc, pg, pgnode, pa, panode, tm_seq);
CREATE UNIQUE INDEX avtestmethod_testmethod_idx ON util_unilab.avtestmethod USING btree (testmethod, sc, pg, pgnode, pa, panode, tm_seq);









--***********************************************************************************
--***********************************************************************************
--***********************************************************************************
--***********************************************************************************
--UTIL_INTERSPEC - VIEWS
--***********************************************************************************
--***********************************************************************************
--***********************************************************************************
--***********************************************************************************
--***********************************************************************************
--
--1.util_interspec.v_bom_prop_field
--2.util_interspec.v_specification_prop 
--3.util_interspec.v_specification_prop2 
--4.util_interspec.v_specification_prop_field
--5.util_interspec.v_specification_prop_field2



--1.util_interspec.v_bom_prop_field
CREATE OR REPLACE VIEW util_interspec.v_bom_prop_field
AS SELECT bi.part_no,
    bi.revision,
    bi.plant,
    bi.alternative,
    bi.item_number,
    bi.component_part,
    bi.bom_usage,
    bi.quantity,
    bi.uom,
    bi.yield,
    bli.field_id,
    bli.header_id,
    bli.start_pos,
    ublf.name AS field_name,
    ublf.type AS field_type,
        CASE ublf.type
            WHEN 'double precision'::text THEN
            CASE ublf.name
                WHEN 'num_1'::text THEN bi.num_1
                WHEN 'num_2'::text THEN bi.num_2
                WHEN 'num_3'::text THEN bi.num_3
                WHEN 'num_4'::text THEN bi.num_4
                WHEN 'num_5'::text THEN bi.num_5
                ELSE NULL::double precision
            END
            ELSE NULL::double precision
        END AS float_val,
        CASE ublf.type
            WHEN 'varchar'::text THEN
            CASE ublf.name
                WHEN 'component_part'::text THEN bi.component_part
                WHEN 'description'::text THEN bh.description
                WHEN 'component_plant'::text THEN bi.component_plant
                WHEN 'uom'::text THEN bi.uom
                WHEN 'to_unit'::text THEN bi.to_unit
                WHEN 'item_category'::text THEN bi.item_category
                WHEN 'issue_location'::text THEN bi.issue_location
                WHEN 'bom_item_type'::text THEN bi.bom_item_type
                WHEN 'char_1'::text THEN bi.char_1
                WHEN 'char_2'::text THEN bi.char_2
                WHEN 'char_3'::text THEN bi.char_3
                WHEN 'char_4'::text THEN bi.char_4
                WHEN 'char_5'::text THEN bi.char_5
                WHEN 'characteristic_1'::text THEN bi.characteristic_1
                WHEN 'characteristic_2'::text THEN bi.characteristic_2
                WHEN 'characteristic_3'::text THEN bi.characteristic_3
                ELSE NULL::character varying
            END
            ELSE NULL::character varying
        END AS char_val,
        CASE ublf.type
            WHEN 'boolean'::text THEN
            CASE ublf.name
                WHEN 'relevancy_to_costing'::text THEN bi.relevency_to_costing
                WHEN 'bulk_material'::text THEN bi.bulk_material
                WHEN 'fixed_qty'::text THEN bi.fixed_qty
                WHEN 'boolean_1'::text THEN bi.boolean_1
                WHEN 'boolean_2'::text THEN bi.boolean_2
                WHEN 'boolean_3'::text THEN bi.boolean_3
                WHEN 'boolean_4'::text THEN bi.boolean_4
                ELSE NULL::numeric
            END
            ELSE NULL::numeric
        END AS boolean_val,
        CASE ublf.type
            WHEN 'timestamp'::text THEN
            CASE ublf.name
                WHEN 'date_1'::text THEN bi.date_1
                WHEN 'date_2'::text THEN bi.date_2
                ELSE NULL::timestamp without time zone
            END
            ELSE NULL::timestamp without time zone
        END AS date_val,
        CASE ublf.type
            WHEN 'numeric'::text THEN
            CASE ublf.name
                WHEN 'quantity'::text THEN bi.quantity::double precision
                WHEN 'conv_factor'::text THEN bi.conv_factor
                WHEN 'yield'::text THEN bi.yield::double precision
                WHEN 'assembly_scrap'::text THEN bi.assembly_scrap::double precision
                WHEN 'component_scrap'::text THEN bi.component_scrap::double precision
                WHEN 'lead_time_offset'::text THEN bi.lead_time_offset::double precision
                WHEN 'operational_step'::text THEN bi.operational_step::double precision
                WHEN 'min_qty'::text THEN bi.min_qty::double precision
                WHEN 'max_qty'::text THEN bi.max_qty::double precision
                WHEN 'component_revision'::text THEN bi.component_revision::double precision
                WHEN 'item_number'::text THEN bi.item_number::double precision
                ELSE NULL::double precision
            END
            ELSE NULL::double precision
        END AS num_val
     FROM rd_interspec_webfocus.v_bom_item bi
     JOIN rd_interspec_webfocus.bom_header bh USING (part_no, revision)
     JOIN rd_interspec_webfocus.part p USING (part_no)
     JOIN rd_interspec_webfocus.itbomlysource bls ON bls.source::text = p.part_source::text
     JOIN rd_interspec_webfocus.itbomlyitem bli(id, dt_created, dt_updated, md5_hash, original, layout_id, header_id, field_id, included, start_pos, length, alignment, format_id, header, color, bold, underline, intl, revision_1, header_rev, def, field_type, editable, phase_mrp, planning_mrp, production_mrp, association, characteristic) ON bli.layout_id::double precision = bls.layout_id AND bli.revision_1::double precision = bls.layout_rev
     JOIN util_interspec.bom_field ublf USING (field_id)
     JOIN util_interspec.bom_layout_type ublt ON ublt.type::double precision = bls.layout_type
  WHERE ublt.table_name::text = 'bom_item'::text AND bls.preferred = 1::numeric;
  
  
--2.util_interspec.v_specification_prop 
CREATE OR REPLACE VIEW util_interspec.v_specification_prop
AS SELECT sp.id,
    sp.dt_created,
    sp.dt_updated,
    sp.md5_hash,
    sp.original,
    sp.part_no,
    sp.revision,
    sp.property_group,
    sp.property,
    sp.attribute,
    sp.section_id,
    sp.sub_section_id,
    sp.section_rev,
    sp.sub_section_rev,
    sp.property_group_rev,
    sp.property_rev,
    sp.attribute_rev,
    sp.uom_id,
    sp.uom_rev,
    sp.test_method,
    sp.test_method_rev,
    sp.sequence_no,
    sp.num_1,
    sp.num_2,
    sp.num_3,
    sp.num_4,
    sp.num_5,
    sp.num_6,
    sp.num_7,
    sp.num_8,
    sp.num_9,
    sp.num_10,
    sp.char_1,
    sp.char_2,
    sp.char_3,
    sp.char_4,
    sp.char_5,
    sp.char_6,
    sp.boolean_1,
    sp.boolean_2,
    sp.boolean_3,
    sp.boolean_4,
    sp.date_1,
    sp.date_2,
    sp.characteristic,
    sp.characteristic_rev,
    sp.association,
    sp.association_rev,
    sp.intl,
    sp.info,
    sp.uom_alt_id,
    sp.uom_alt_rev,
    sp.tm_det_1,
    sp.tm_det_2,
    sp.tm_det_3,
    sp.tm_det_4,
    sp.tm_set_no,
    sp.ch_2,
    sp.ch_rev_2,
    sp.ch_3,
    sp.ch_rev_3,
    sp.as_2,
    sp.as_rev_2,
    sp.as_3,
    sp.as_rev_3,
    p.description AS property_1,
    u.description AS uom,
    tm.description AS test_method_1,
        CASE c.characteristic_id
            WHEN sp.characteristic THEN c.description
            ELSE NULL::character varying
        END AS characteristic_1,
        CASE c.characteristic_id
            WHEN sp.ch_2 THEN c.description
            ELSE NULL::character varying
        END AS characteristic_2,
        CASE c.characteristic_id
            WHEN sp.ch_3 THEN c.description
            ELSE NULL::character varying
        END AS characteristic_3
   FROM rd_interspec_webfocus.specification_prop sp
     JOIN rd_interspec_webfocus.property p USING (property)
     LEFT JOIN rd_interspec_webfocus.uom u USING (uom_id)
     LEFT JOIN rd_interspec_webfocus.test_method tm USING (test_method)
     LEFT JOIN rd_interspec_webfocus.characteristic c ON c.characteristic_id = ANY (ARRAY[sp.characteristic, sp.ch_2, sp.ch_3]);


--3.util_interspec.v_specification_prop2 
CREATE OR REPLACE VIEW util_interspec.v_specification_prop2
AS SELECT p.part_no,
    p.revision,
    p.section_id,
    p.sub_section_id,
    p.section_rev,
    p.sub_section_rev,
    p.property_group,
    p.property,
    p.property_group_rev,
    p.property_rev,
    p.attribute,
    p.attribute_rev,
    p.uom_id,
    p.uom_rev,
    p.test_method,
    p.test_method_rev,
    p.sequence_no,
    p.num_1,
    p.num_2,
    p.num_3,
    p.num_4,
    p.num_5,
    p.num_6,
    p.num_7,
    p.num_8,
    p.num_9,
    p.num_10,
    p.char_1,
    p.char_2,
    p.char_3,
    p.char_4,
    p.char_5,
    p.char_6,
    p.boolean_1,
    p.boolean_2,
    p.boolean_3,
    p.boolean_4,
    p.date_1,
    p.date_2,
    p.characteristic,
    p.characteristic_rev,
    p.association,
    p.association_rev,
    p.intl,
    p.info,
    p.uom_alt_id,
    p.uom_alt_rev,
    p.tm_det_1,
    p.tm_det_2,
    p.tm_det_3,
    p.tm_det_4,
    p.tm_set_no,
    p.ch_2,
    p.ch_rev_2,
    p.ch_3,
    p.ch_rev_3,
    p.as_2,
    p.as_rev_2,
    p.as_3,
    p.as_rev_3,
    ( SELECT uom.description
           FROM rd_interspec_webfocus.uom
          WHERE uom.uom_id = p.uom_id) AS uom,
    ( SELECT test_method.description
           FROM rd_interspec_webfocus.test_method
          WHERE test_method.test_method = p.test_method) AS test_method_1,
    ( SELECT characteristic.description
           FROM rd_interspec_webfocus.characteristic
          WHERE characteristic.characteristic_id = p.characteristic) AS characteristic_1,
    ( SELECT property.description
           FROM rd_interspec_webfocus.property
          WHERE property.property = p.property) AS property_1,
    ( SELECT characteristic.description
           FROM rd_interspec_webfocus.characteristic
          WHERE characteristic.characteristic_id = p.ch_2) AS characteristic_2,
    ( SELECT characteristic.description
           FROM rd_interspec_webfocus.characteristic
          WHERE characteristic.characteristic_id = p.ch_3) AS characteristic_3
   FROM rd_interspec_webfocus.specification_prop p;


--4.util_interspec.v_specification_prop_field
CREATE OR REPLACE VIEW util_interspec.v_specification_prop_field
AS SELECT sp.part_no,
    sp.revision,
    sp.section_id,
    sp.section_rev,
    sp.sub_section_id,
    sp.sub_section_rev,
    sp.property_group,
    sp.property_group_rev,
    sp.property,
    sp.property_rev,
    sp.intl,
    sp.functionkw,
    ss.section_sequence_no,
    ss.sequence_no,
    pl.field_id,
    pl.header_id,
    pl.start_pos,
    upf.name AS field_name,
    upf.type_1 AS field_type,
        CASE upf.type_1
            WHEN 'double precision'::text THEN
            CASE upf.name
                WHEN 'num_1'::text THEN sp.num_1
                WHEN 'num_2'::text THEN sp.num_2
                WHEN 'num_3'::text THEN sp.num_3
                WHEN 'num_4'::text THEN sp.num_4
                WHEN 'num_5'::text THEN sp.num_5
                WHEN 'num_6'::text THEN sp.num_6
                WHEN 'num_7'::text THEN sp.num_7
                WHEN 'num_8'::text THEN sp.num_8
                WHEN 'num_9'::text THEN sp.num_9
                WHEN 'num_10'::text THEN sp.num_10
                ELSE NULL::double precision
            END
            ELSE NULL::double precision
        END AS float_val,
        CASE upf.type_1
            WHEN 'varchar'::text THEN
            CASE upf.name
                WHEN 'char_1'::text THEN sp.char_1
                WHEN 'char_2'::text THEN sp.char_2
                WHEN 'char_3'::text THEN sp.char_3
                WHEN 'char_4'::text THEN sp.char_4
                WHEN 'char_5'::text THEN sp.char_5
                WHEN 'char_6'::text THEN sp.char_6
                WHEN 'uom'::text THEN sp.uom
                WHEN 'test_method_1'::text THEN sp.test_method_1
                WHEN 'characteristic_1'::text THEN sp.characteristic_1
                WHEN 'property_1'::text THEN sp.property_1
                WHEN 'characteristic_2'::text THEN sp.characteristic_2
                WHEN 'characteristic_3'::text THEN sp.characteristic_3
                WHEN 'info'::text THEN sp.info
                ELSE NULL::character varying
            END
            ELSE NULL::character varying
        END AS char_val,
        CASE upf.type_1
            WHEN 'char'::text THEN
            CASE upf.name
                WHEN 'boolean_1'::text THEN sp.boolean_1
                WHEN 'boolean_2'::text THEN sp.boolean_2
                WHEN 'boolean_3'::text THEN sp.boolean_3
                WHEN 'boolean_4'::text THEN sp.boolean_4
                WHEN 'tm_det_2'::text THEN sp.tm_det_2
                WHEN 'tm_det_1'::text THEN sp.tm_det_1
                WHEN 'tm_det_3'::text THEN sp.tm_det_3
                WHEN 'tm_det_4'::text THEN sp.tm_det_4
                ELSE NULL::character varying
            END
            ELSE NULL::character varying
        END AS boolean_val,
        CASE upf.type_1
            WHEN 'timestamp'::text THEN
            CASE upf.name
                WHEN 'date_1'::text THEN sp.date_1
                WHEN 'date_2'::text THEN sp.date_2
                ELSE NULL::timestamp without time zone
            END
            ELSE NULL::timestamp without time zone
        END AS date_val,
        CASE upf.type_1
            WHEN 'numeric'::text THEN
            CASE upf.name
                WHEN 'attribute'::text THEN sp.attribute::double precision
                ELSE NULL::double precision
            END
            ELSE NULL::double precision
        END AS num_val,
        CASE upf.type_1
            WHEN 'double precision'::text THEN
            CASE upf.name
                WHEN 'num_1'::text THEN quote_literal(sp.num_1)
                WHEN 'num_2'::text THEN quote_literal(sp.num_2)
                WHEN 'num_3'::text THEN quote_literal(sp.num_3)
                WHEN 'num_4'::text THEN quote_literal(sp.num_4)
                WHEN 'num_5'::text THEN quote_literal(sp.num_5)
                WHEN 'num_6'::text THEN quote_literal(sp.num_6)
                WHEN 'num_7'::text THEN quote_literal(sp.num_7)
                WHEN 'num_8'::text THEN quote_literal(sp.num_8)
                WHEN 'num_9'::text THEN quote_literal(sp.num_9)
                WHEN 'num_10'::text THEN quote_literal(sp.num_10)
                ELSE NULL::text
            END
            WHEN 'varchar'::text THEN
            CASE upf.name
                WHEN 'char_1'::text THEN sp.char_1
                WHEN 'char_2'::text THEN sp.char_2
                WHEN 'char_3'::text THEN sp.char_3
                WHEN 'char_4'::text THEN sp.char_4
                WHEN 'char_5'::text THEN sp.char_5
                WHEN 'char_6'::text THEN sp.char_6
                WHEN 'uom'::text THEN sp.uom
                WHEN 'test_method_1'::text THEN sp.test_method_1
                WHEN 'characteristic_1'::text THEN sp.characteristic_1
                WHEN 'property_1'::text THEN sp.property_1
                WHEN 'characteristic_2'::text THEN sp.characteristic_2
                WHEN 'characteristic_3'::text THEN sp.characteristic_3
                WHEN 'info'::text THEN sp.info
                ELSE NULL::character varying
            END::text
            WHEN 'char'::text THEN
            CASE upf.name
                WHEN 'boolean_1'::text THEN sp.boolean_1
                WHEN 'boolean_2'::text THEN sp.boolean_2
                WHEN 'boolean_3'::text THEN sp.boolean_3
                WHEN 'boolean_4'::text THEN sp.boolean_4
                WHEN 'tm_det_2'::text THEN sp.tm_det_2
                WHEN 'tm_det_1'::text THEN sp.tm_det_1
                WHEN 'tm_det_3'::text THEN sp.tm_det_3
                WHEN 'tm_det_4'::text THEN sp.tm_det_4
                ELSE NULL::character varying
            END::text
            WHEN 'timestamp'::text THEN
            CASE upf.name
                WHEN 'date_1'::text THEN quote_literal(sp.date_1)
                WHEN 'date_2'::text THEN quote_literal(sp.date_2)
                ELSE NULL::text
            END
            WHEN 'numeric'::text THEN
            CASE upf.name
                WHEN 'attribute'::text THEN quote_literal(sp.attribute::double precision)
                ELSE NULL::text
            END
            ELSE NULL::text
        END AS value_literal
   FROM rd_interspec_webfocus.v_specification_prop sp
     JOIN rd_interspec_webfocus.specification_section ss USING (part_no, revision, section_id, sub_section_id)
     JOIN util_interspec.section_type ust USING (type)
     JOIN rd_interspec_webfocus.property_layout pl(id, dt_created, dt_updated, md5_hash, original, layout_id, header_id, field_id, included, start_pos, length, alignment, format_id, header, color, bold, underline, intl, revision_1, header_rev, def, url, attached_spec) ON pl.layout_id = ss.display_format AND pl.revision_1 = ss.display_format_rev
     JOIN util_interspec.property_field upf(field_id, name, type_1) USING (field_id)
  WHERE ust.table_name::text = 'property_group'::text AND ss.ref_id = sp.property_group OR ust.table_name::text = 'property'::text AND ss.ref_id = sp.property;
  
  
  
--5.util_interspec.v_specification_prop_field2
CREATE OR REPLACE VIEW util_interspec.v_specification_prop_field2
AS SELECT sp.part_no,
    sp.revision,
    sp.section_id,
    sp.section_rev,
    sp.sub_section_id,
    sp.sub_section_rev,
    sp.property_group,
    sp.property_group_rev,
    sp.property,
    sp.property_rev,
    sp.intl,
    ss.section_sequence_no,
    ss.sequence_no,
    pl.field_id,
    pl.header_id,
    upf.name,
    upf.type_1 AS type,
        CASE upf.type_1
            WHEN 'double precision'::text THEN
            CASE upf.name
                WHEN 'num_1'::text THEN sp.num_1
                WHEN 'num_2'::text THEN sp.num_2
                WHEN 'num_3'::text THEN sp.num_3
                WHEN 'num_4'::text THEN sp.num_4
                WHEN 'num_5'::text THEN sp.num_5
                WHEN 'num_6'::text THEN sp.num_6
                WHEN 'num_7'::text THEN sp.num_7
                WHEN 'num_8'::text THEN sp.num_8
                WHEN 'num_9'::text THEN sp.num_9
                WHEN 'num_10'::text THEN sp.num_10
                WHEN 'attribute'::text THEN sp.attribute::double precision
                ELSE NULL::double precision
            END
            ELSE NULL::double precision
        END AS num_val,
        CASE upf.type_1
            WHEN 'varchar'::text THEN
            CASE upf.name
                WHEN 'char_1'::text THEN sp.char_1
                WHEN 'char_2'::text THEN sp.char_2
                WHEN 'char_3'::text THEN sp.char_3
                WHEN 'char_4'::text THEN sp.char_4
                WHEN 'char_5'::text THEN sp.char_5
                WHEN 'char_6'::text THEN sp.char_6
                WHEN 'uom'::text THEN sp.uom
                WHEN 'test_method_1'::text THEN sp.test_method_1
                WHEN 'characteristic_1'::text THEN sp.characteristic_1
                WHEN 'property_1'::text THEN sp.property_1
                WHEN 'characteristic_2'::text THEN sp.characteristic_2
                WHEN 'characteristic_3'::text THEN sp.characteristic_3
                WHEN 'info'::text THEN sp.info
                ELSE NULL::character varying
            END
            ELSE NULL::character varying
        END AS char_val,
        CASE upf.type_1
            WHEN 'char'::text THEN
            CASE upf.name
                WHEN 'boolean_1'::text THEN sp.boolean_1
                WHEN 'boolean_2'::text THEN sp.boolean_2
                WHEN 'boolean_3'::text THEN sp.boolean_3
                WHEN 'boolean_4'::text THEN sp.boolean_4
                WHEN 'tm_det_2'::text THEN sp.tm_det_2
                WHEN 'tm_det_1'::text THEN sp.tm_det_1
                WHEN 'tm_det_3'::text THEN sp.tm_det_3
                WHEN 'tm_det_4'::text THEN sp.tm_det_4
                ELSE NULL::character varying
            END
            ELSE NULL::character varying
        END AS boolean_val,
        CASE upf.type_1
            WHEN 'timestamp'::text THEN
            CASE upf.name
                WHEN 'date_1'::text THEN sp.date_1
                WHEN 'date_2'::text THEN sp.date_2
                ELSE NULL::timestamp without time zone
            END
            ELSE NULL::timestamp without time zone
        END AS date_val
   FROM util_interspec.v_specification_prop sp
     JOIN rd_interspec_webfocus.specification_section ss USING (part_no, revision, section_id, sub_section_id)
     JOIN util_interspec.section_type ust USING (type)
     JOIN rd_interspec_webfocus.property_layout pl(id, dt_created, dt_updated, md5_hash, original, layout_id, header_id, field_id, included, start_pos, length, alignment, format_id, header, color, bold, underline, intl, revision_1, header_rev, def, url, attached_spec) ON pl.layout_id = ss.display_format AND pl.revision_1 = ss.display_format_rev
     JOIN util_interspec.property_field upf(field_id, name, type_1) USING (field_id)
  WHERE ust.table_name::text = 'property_group'::text AND ss.ref_id = sp.property_group OR ust.table_name::text = 'property'::text AND ss.ref_id = sp.property;
   



--************************************************************
--WEBFOCUS-VIEWS
--************************************************************
--1.rd_interspec_webfocus.v_bom_item
--2.rd_interspec_webfocus.v_specification_header 
--3.rd_interspec_webfocus.v_specification_prop 

--1.rd_interspec_webfocus.v_bom_item
CREATE OR REPLACE VIEW rd_interspec_webfocus.v_bom_item
AS SELECT bi.id,
    bi.dt_created,
    bi.dt_updated,
    bi.md5_hash,
    bi.original,
    bi.part_no,
    bi.revision,
    bi.plant,
    bi.alternative,
    bi.bom_usage,
    bi.item_number,
    bi.component_part,
    bi.component_revision,
    bi.component_plant,
    bi.quantity,
    bi.uom,
    bi.conv_factor,
    bi.to_unit,
    bi.yield,
    bi.assembly_scrap,
    bi.component_scrap,
    bi.lead_time_offset,
    bi.item_category,
    bi.issue_location,
    bi.calc_flag,
    bi.bom_item_type,
    bi.operational_step,
    bi.min_qty,
    bi.max_qty,
    bi.char_1,
    bi.char_2,
    bi.code,
    bi.alt_group,
    bi.alt_priority,
    bi.num_1,
    bi.num_2,
    bi.num_3,
    bi.num_4,
    bi.num_5,
    bi.char_3,
    bi.char_4,
    bi.char_5,
    bi.date_1,
    bi.date_2,
    bi.ch_1,
    bi.ch_rev_1,
    bi.ch_2,
    bi.ch_rev_2,
    bi.ch_3,
    bi.ch_rev_3,
    bi.relevency_to_costing,
    bi.bulk_material,
    bi.fixed_qty,
    bi.boolean_1,
    bi.boolean_2,
    bi.boolean_3,
    bi.boolean_4,
    bi.make_up,
    bi.intl_equivalent,
    bi.component_scrap_sync,
    ( SELECT characteristic.description
           FROM rd_interspec_webfocus.characteristic
          WHERE characteristic.characteristic_id = bi.ch_1) AS characteristic_1,
    ( SELECT characteristic.description
           FROM rd_interspec_webfocus.characteristic
          WHERE characteristic.characteristic_id = bi.ch_2) AS characteristic_2,
    ( SELECT characteristic.description
           FROM rd_interspec_webfocus.characteristic
          WHERE characteristic.characteristic_id = bi.ch_3) AS characteristic_3
   FROM rd_interspec_webfocus.bom_item bi;
   
   
--2.rd_interspec_webfocus.v_specification_header 
CREATE OR REPLACE VIEW rd_interspec_webfocus.v_specification_header
AS SELECT h.part_no,
    h.revision,
    h.status,
    h.description,
    h.planned_effective_date,
    h.issued_date,
    h.obsolescence_date,
    h.status_change_date,
    h.phase_in_tolerance,
    h.created_by,
    h.created_on,
    h.last_modified_by,
    h.last_modified_on,
    h.frame_id,
    h.frame_rev,
    h.access_group,
    h.workflow_group_id,
    h.class3_id,
    h.owner,
    h.int_frame_no,
    h.int_frame_rev,
    h.int_part_no,
    h.int_part_rev,
    h.frame_owner,
    h.intl,
    h.multilang,
    h.uom_type,
    h.mask_id,
    h.ped_in_sync,
    h.locked,
        CASE
            WHEN h.issued_date IS NULL AND h.obsolescence_date IS NULL THEN NULL::tsrange
            WHEN h.issued_date IS NULL THEN tsrange('-infinity'::timestamp without time zone, h.obsolescence_date)
            WHEN h.obsolescence_date IS NULL THEN tsrange(h.issued_date, 'infinity'::timestamp without time zone)
            WHEN h.obsolescence_date < h.issued_date THEN tsrange(h.issued_date, h.issued_date)
            ELSE tsrange(h.issued_date, h.obsolescence_date)
        END AS validity_range,
    h.part_no::text ~~ 'X%'::text AS is_trial
   FROM rd_interspec_webfocus.specification_header h;


--3.rd_interspec_webfocus.v_specification_prop 
CREATE OR REPLACE VIEW rd_interspec_webfocus.v_specification_prop
AS SELECT p.part_no,
    p.revision,
    p.section_id,
    p.sub_section_id,
    p.section_rev,
    p.sub_section_rev,
    p.property_group,
    p.property,
    p.property_group_rev,
    p.property_rev,
    p.attribute,
    p.attribute_rev,
    p.uom_id,
    p.uom_rev,
    p.test_method,
    p.test_method_rev,
    p.sequence_no,
    p.num_1,
    p.num_2,
    p.num_3,
    p.num_4,
    p.num_5,
    p.num_6,
    p.num_7,
    p.num_8,
    p.num_9,
    p.num_10,
    p.char_1,
    p.char_2,
    p.char_3,
    p.char_4,
    p.char_5,
    p.char_6,
    p.boolean_1,
    p.boolean_2,
    p.boolean_3,
    p.boolean_4,
    p.date_1,
    p.date_2,
    p.characteristic,
    p.characteristic_rev,
    p.association,
    p.association_rev,
    p.intl,
    p.info,
    p.uom_alt_id,
    p.uom_alt_rev,
    p.tm_det_1,
    p.tm_det_2,
    p.tm_det_3,
    p.tm_det_4,
    p.tm_set_no,
    p.ch_2,
    p.ch_rev_2,
    p.ch_3,
    p.ch_rev_3,
    p.as_2,
    p.as_rev_2,
    p.as_3,
    p.as_rev_3,
    ( SELECT uom.description
           FROM rd_interspec_webfocus.uom
          WHERE uom.uom_id = p.uom_id) AS uom,
    ( SELECT test_method.description
           FROM rd_interspec_webfocus.test_method
          WHERE test_method.test_method = p.test_method) AS test_method_1,
    ( SELECT characteristic.description
           FROM rd_interspec_webfocus.characteristic
          WHERE characteristic.characteristic_id = p.characteristic) AS characteristic_1,
    ( SELECT property.description
           FROM rd_interspec_webfocus.property
          WHERE property.property = p.property) AS property_1,
    ( SELECT characteristic.description
           FROM rd_interspec_webfocus.characteristic
          WHERE characteristic.characteristic_id = p.ch_2) AS characteristic_2,
    ( SELECT characteristic.description
           FROM rd_interspec_webfocus.characteristic
          WHERE characteristic.characteristic_id = p.ch_3) AS characteristic_3,
    sk.kw_value AS functionkw
   FROM rd_interspec_webfocus.specification_prop p
     LEFT JOIN rd_interspec_webfocus.specification_kw sk ON sk.part_no::text = p.part_no::text AND sk.kw_id = 700386::numeric
;




--einde script


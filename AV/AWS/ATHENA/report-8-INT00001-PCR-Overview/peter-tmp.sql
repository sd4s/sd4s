--POSTGRES-DB
-- dm_lims.bom_explosion source

CREATE OR REPLACE VIEW dm_lims.bom_explosion
AS SELECT h.part_no,
    h.revision,
    h.alternative,
    h.preferred,
    x.level,
    x.item_number,
    x.component_part_no,
    x.component_revision,
    x.spec_function,
    x.bom_function,
    (x.properties ->> 'PHR'::text)::numeric AS "PHR",
    x.quantity AS "Quantity",
    x.total_quantity AS "Total Quantity",
    x.properties ->> 'UoM'::text AS "UoM",
    x.properties ->> 'Packaging'::text AS "Packaging",
    x.properties ->> 'Description'::text AS "Description",
    x.properties ->> 'Aging min. (hrs)'::text AS "Aging min. (hrs)",
    x.properties ->> 'Aging max. (days)'::text AS "Aging max. (days)",
    x.properties ->> 'Position in machine'::text AS "Position in machine",
    x.hierarchy::text AS hierarchy,
    x.function_path::text AS function_path,
    x.part_path::text AS part_path
   FROM rd_interspec_webfocus.bom_header h
     CROSS JOIN LATERAL util_interspec.bom_explode(h.part_no::text, h.revision, h.alternative, h.plant::text) x(part_no, revision, component_part_no, component_revision, class3_id, plant, alternative, preferred, keywords, spec_function, level, item_number, bom_function, properties, hierarchy, part_path, function_path, contains_cycle, quantity, total_quantity);
	 
	 
--postgres-JSON-structures

--2ND STAGE BOM-ITEMS  util_interspec

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
FROM UVSS                     ss
JOIN specification             s USING (part_no, revision)
JOIN specification_bom_header bh USING (part_no, revision)
CROSS JOIN LATERAL util_interspec.bom_explode(ss.part_no::text, ss.revision, bh.alternative, bh.plant::text, jsonb_build_object('function_path_query', ARRAY['*.Belt_1|Belt_2|Capply|Capstrip|Greentyre|Tread|Vulcanized_tyre|Tyre_vulcanized'::text, '*.Belt_1|Belt_2.Composite|Racknumber|Steelcord'::text, '*.Belt_1|Belt_2.Racknumber.Compound|Steelcord'::text, '*.Belt_1|Belt_2.Composite.Composite_compound|Reinforcement'::text, '*.Belt_1.Belt_gum'::text, '*.Belt_1.Belt_gum.*{1}'::text, '*.Belt_1.Belt_gum.*.Belt_gum_compound'::text, '*.Belt_1.Rubberstrip'::text, '*.Belt_1.Rubberstrip.*{1}'::text, '*.Belt_1.Rubberstrip.*.!Compound.Compound'::text, '*.Tread.*{1}'::text])) t(part_no, revision, component_part_no, component_revision, class3_id, plant, alternative, preferred, keywords, spec_function, level, item_number, bom_function, properties, hierarchy, part_path, function_path, contains_cycle, quantity, total_quantity)
JOIN specification        comp_s ON comp_s.part_no::text = t.component_part_no AND comp_s.revision = t.component_revision
JOIN rd_interspec_webfocus.class3 c ON c.class = t.class3_id
WHERE ss.status_type::text = 'CURRENT'::text AND (ss.status_code::text <> ALL (ARRAY['TEMP CRRNT'::character varying, 'CRRNT QR1'::character varying, 'CRRNT QR2'::character varying]::text[])) AND ss.frame_id::text = 'A_PCR'::text AND NOT ss.is_trial AND bh.preferred = 1::numeric AND (t.function_path ? '{*.!Racknumber}'::lquery[] OR t.function_path @ 'Racknumber'::ltxtquery AND (c.sort_desc::text = ANY (ARRAY['TEXTCOMP'::character varying, 'STEELCOMP'::character varying]::text[])))
GROUP BY ss.part_no, ss.revision, s.functionkw, s.properties, bh.plant
)
	 
--***********************************************************************************
--***********************************************************************************
--***********************************************************************************
--***********************************************************************************
--*************************************************************************
-- AUTORA: SC_LIMS_DAL -PCR-OVERVIEW- MATERIALZED VIEWS !!!!!!!
--***********************************************************************************
--***********************************************************************************
--***********************************************************************************
--***********************************************************************************
-- POSTGRES.UTIL_INTERSPEC-MATERIALIZED VIEWS MIGRATED TO AUTORA.SC_LIMS_DAL-mv 
--***********************************************************************************
--postgres.util_interspec-tables migrated to SC_LIMS_DAL.pcr-tables !!!!
--1.util_interspec.bom_field           -->  sc_lims_dal.pcr_bom_field         
--2.util_interspec.bom_layout_type     -->  sc_lims_dal.pcr_bom_layout_type
--3.util_interspec.bom_scenario        -->  sc_lims_dal.pcr_bom_scenario 
--4.util_interspec.function_conversion -->  sc_lims_dal.pcr_function_conversion 
--5.util_interspec.internal_status     -->  sc_lims_dal.pcr_internal_status 
--6.util_interspec.property_field      -->  sc_lims_dal.pcr_property_field 
--7.util_interspec.section_type        -->  sc_lims_dal.pcr_section_type 
--
--BASE-TABLES pointing to base-replication-schema:
--postgres: rd_interspec_webfocus-tables --> aurora: sc_interspec_ens-tables
--postgres: rd_unilab_webfocus-tables    --> aurora: sc_unilab_ens-tables
--
--***********************************************************************************
--BASE-MATERIALIZED-VIEWS:
--/*
--STEP1:
-- 1.sc_lims_dal.mv_bom_header_property			
-- 2.sc_lims_dal.mv_bom_item_property
--10.sc_lims_dal.mv_specification_status 
-- 6.sc_lims_dal.mv_specification_keyword
--*/
--
--STEP2:
-- 3.sc_lims_dal.mv_bom_path_current
-- 4.sc_lims_dal.mv_frame_property_matrix
-- 7.sc_lims_dal.mv_specification_property
-- 5.sc_lims_dal.mv_specification
-- 8.sc_lims_dal.mv_specification_property_matrix 
-- 9.sc_lims_dal.mv_specification_section
--
--100.sc_lims_dal.mv_avtestmethod


/*
STEP1-MV:

--*********************************************
--1,sc_lims_dal.mv_bom_header_property source
CREATE MATERIALIZED VIEW  sc_lims_dal.mv_bom_header_property
TABLESPACE pg_default
AS 
SELECT bh.part_no
,   bh.revision
,   bh.plant
,   bh.alternative
,   bh.preferred
,   bh.bom_usage
,   bh.base_quantity
,   bh.description
,   bh.yield
,   bh.conv_factor
,   bh.to_unit
,   ls.layout_id
,   ls.preferred AS layout_preferred
,   jsonb_object_agg(h.description
                    ,CASE li.field_id
                          WHEN 1  THEN to_jsonb(bh.plant)
                          WHEN 3  THEN to_jsonb(bh.alternative)
                          WHEN 6  THEN to_jsonb(bh.base_quantity)
                          WHEN 5  THEN to_jsonb(bh.description)
                          WHEN 12 THEN to_jsonb(bh.max_qty)
                          WHEN 13 THEN to_jsonb(bh.plant_effective_date)
                          ELSE NULL::jsonb
                     END)                      AS properties
FROM sc_interspec_ens.bom_header      bh
JOIN sc_interspec_ens.part             p ON p.part_no::text = bh.part_no::text
JOIN sc_interspec_ens.itbomlysource   ls ON ls.source::text = p.part_source::text
JOIN sc_interspec_ens.itbomlyitem     li ON li.layout_id::double precision = ls.layout_id AND li.revision::double precision = ls.layout_rev
JOIN sc_interspec_ens.header           h USING (header_id)
JOIN sc_lims_dal.pcr_bom_layout_type  lt ON lt.type::double precision = ls.layout_type
WHERE lt.table_name::text = 'bom_header'::text 
AND ls.preferred = 1::numeric
GROUP BY bh.part_no
,        bh.revision
,        bh.plant
,        bh.alternative
,        bh.bom_usage
,        bh.base_quantity
,        bh.description
,        bh.yield
,        bh.conv_factor
,        bh.to_unit
,        ls.layout_id
,        ls.preferred
WITH DATA
;

grant all on  sc_lims_dal.v_bom_item  to usr_rna_readonly1;


-- Materialized-View indexes:
CREATE UNIQUE INDEX sc_lims_dal.bom_header_property_part_alt_uq    ON sc_lims_dal.mv_bom_header_property USING btree (part_no, revision, alternative, plant, bom_usage);
CREATE UNIQUE INDEX sc_lims_dal.bom_header_property_pk             ON sc_lims_dal.mv_bom_header_property USING btree (part_no, revision, plant, alternative, bom_usage);
CREATE INDEX        sc_lims_dal.bom_header_property_properties_idx ON sc_lims_dal.mv_bom_header_property USING gin (properties);


--*********************************************
--2.sc_lims_dal.mv_bom_item_property
CREATE MATERIALIZED VIEW sc_lims_dal.mv_bom_item_property
TABLESPACE pg_default
AS 
SELECT bi.part_no
,   bi.revision
,   bi.plant
,   bi.alternative
,   bi.bom_usage
,   bi.item_number
,   bi.component_part
,   bi.component_revision
,   bi.component_plant
,   bi.quantity
,   bi.uom
,   bi.conv_factor
,   bi.to_unit
,   bi.yield
,   bi.item_category
,   bi.issue_location
,   bi.alt_group
,   bi.alt_priority
,   bi.make_up
,   bi.intl_equivalent
,   bi.component_scrap_sync
,   ls.layout_id
,   ls.preferred AS layout_preferred
,   jsonb_object_agg(h.description
                    ,CASE bf.name
            WHEN 'component_part'::text   THEN to_jsonb(bi.component_part)
            WHEN 'description'::text      THEN to_jsonb(p.description)
            WHEN 'component_plant'::text  THEN to_jsonb(bi.component_plant)
            WHEN 'quantity'::text         THEN to_jsonb(bi.quantity)
            WHEN 'uom'::text              THEN to_jsonb(bi.uom)
            WHEN 'to_unit'::text          THEN to_jsonb(bi.to_unit)
            WHEN 'conv_factor'::text      THEN to_jsonb(bi.conv_factor)
            WHEN 'yield'::text            THEN to_jsonb(bi.yield)
            WHEN 'assembly_scrap'::text   THEN to_jsonb(bi.assembly_scrap)
            WHEN 'component_scrap'::text  THEN to_jsonb(bi.component_scrap)
            WHEN 'lead_time_offset'::text THEN to_jsonb(bi.lead_time_offset)
            WHEN 'relevancy_to_costing'::text THEN to_jsonb(bi.relevency_to_costing)
            WHEN 'bulk_material'::text    THEN to_jsonb(bi.bulk_material)
            WHEN 'item_category'::text    THEN to_jsonb(bi.item_category)
            WHEN 'issue_location'::text   THEN to_jsonb(bi.issue_location)
            WHEN 'calc_flag'::text        THEN to_jsonb(bi.calc_flag)
            WHEN 'bom_item_type'::text    THEN to_jsonb(bi.bom_item_type)
            WHEN 'operational_step'::text THEN to_jsonb(bi.operational_step)
            WHEN 'min_qty'::text          THEN to_jsonb(bi.min_qty)
            WHEN 'max_qty'::text          THEN to_jsonb(bi.max_qty)
            WHEN 'fixed_qty'::text        THEN to_jsonb(bi.fixed_qty)
            WHEN 'component_revision'::text THEN to_jsonb(bi.component_revision)
            WHEN 'item_number'::text      THEN to_jsonb(bi.item_number)
            WHEN 'char_1'::text           THEN to_jsonb(bi.char_1)
            WHEN 'char_2'::text           THEN to_jsonb(bi.char_2)
            WHEN 'code'::text             THEN to_jsonb(bi.code)
            WHEN 'num_1'::text            THEN to_jsonb(bi.num_1)
            WHEN 'num_2'::text            THEN to_jsonb(bi.num_2)
            WHEN 'num_3'::text            THEN to_jsonb(bi.num_3)
            WHEN 'num_4'::text            THEN to_jsonb(bi.num_4)
            WHEN 'num_5'::text            THEN to_jsonb(bi.num_5)
            WHEN 'char_3'::text           THEN to_jsonb(bi.char_3)
            WHEN 'char_4'::text           THEN to_jsonb(bi.char_4)
            WHEN 'char_5'::text           THEN to_jsonb(bi.char_5)
            WHEN 'boolean_1'::text        THEN to_jsonb(bi.boolean_1)
            WHEN 'boolean_2'::text        THEN to_jsonb(bi.boolean_2)
            WHEN 'boolean_3'::text        THEN to_jsonb(bi.boolean_3)
            WHEN 'boolean_4'::text        THEN to_jsonb(bi.boolean_4)
            WHEN 'date_1'::text           THEN to_jsonb(bi.date_1)
            WHEN 'date_2'::text           THEN to_jsonb(bi.date_2)
            WHEN 'characteristic_1'::text THEN ( SELECT to_jsonb(characteristic.description) AS to_jsonb
                                                 FROM sc_interspec_ens.characteristic
                                                 WHERE characteristic.characteristic_id = bi.ch_1
											   )
            WHEN 'characteristic_2'::text THEN ( SELECT to_jsonb(characteristic.description) AS to_jsonb
                                                 FROM sc_interspec_ens.characteristic
                                                 WHERE characteristic.characteristic_id = bi.ch_2
											   )
            WHEN 'characteristic_2'::text THEN ( SELECT to_jsonb(characteristic.description) AS to_jsonb
                                                 FROM sc_interspec_ens.characteristic
                                                 WHERE characteristic.characteristic_id = bi.ch_3
											   )
            ELSE NULL::jsonb
        END)                                            AS properties
FROM sc_interspec_ens.bom_item       bi
JOIN sc_interspec_ens.part            p ON p.part_no::text = bi.part_no::text
JOIN sc_interspec_ens.itbomlysource  ls ON ls.source::text = p.part_source::text
JOIN sc_interspec_ens.itbomlyitem    li ON li.layout_id::double precision = ls.layout_id AND li.revision::double precision = ls.layout_rev
JOIN sc_interspec_ens.header          h USING (header_id)
JOIN sc_lims_dal.pcr_bom_field       bf USING (field_id)
JOIN sc_lims_dal.pcr_bom_layout_type lt ON lt.type::double precision = ls.layout_type
WHERE lt.table_name::text = 'bom_item'::text 
AND   ls.preferred = 1::numeric
GROUP BY bi.part_no
, bi.revision
, bi.plant
, bi.alternative
, bi.bom_usage
, bi.item_number
, bi.component_part
, bi.component_revision
, bi.component_plant
, bi.quantity
, bi.uom
, bi.conv_factor
, bi.to_unit
, bi.yield
, bi.item_category
, bi.issue_location
, bi.alt_group
, bi.alt_priority
, bi.make_up
, bi.intl_equivalent
, bi.component_scrap_sync
, ls.layout_id
, ls.preferred
WITH DATA
;
grant all on  sc_lims_dal.mv_bom_item_property  to usr_rna_readonly1;


-- Materialized-View indexes:
CREATE INDEX        sc_lims_dal.bom_item_property_component_idx         ON sc_lims_dal.mv_bom_item_property USING btree (component_part, alternative, part_no, revision, plant);
CREATE UNIQUE INDEX sc_lims_dal.bom_item_property_part_component_alt_uq ON sc_lims_dal.mv_bom_item_property USING btree (part_no, revision, component_part, alternative, plant, item_number, bom_usage);
CREATE UNIQUE INDEX sc_lims_dal.bom_item_property_pk                    ON sc_lims_dal.mv_bom_item_property USING btree (part_no, revision, plant, alternative, bom_usage, item_number);
CREATE INDEX        sc_lims_dal.bom_item_property_properties_idx        ON sc_lims_dal.mv_bom_item_property USING gin (properties);
CREATE UNIQUE INDEX sc_lims_dal.bom_item_property_text_pk               ON sc_lims_dal.mv_bom_item_property USING btree (((part_no)::text), revision, ((plant)::text), alternative, bom_usage, item_number);



--****************************************************************
--10.sc_lims_dal.mv_specification_status 
--
--AFHANKELIJKHEDEN: sc_lims_dal.v_specification_header   
--
CREATE MATERIALIZED VIEW sc_lims_dal.mv_specification_status
TABLESPACE pg_default
AS SELECT h.part_no
,    h.revision
,    h.status
,    h.description
,    h.planned_effective_date
,    h.issued_date
,    h.obsolescence_date
,    h.status_change_date
,    h.phase_in_tolerance
,    h.created_by
,    h.created_on
,    h.last_modified_by
,    h.last_modified_on
,    h.frame_id
,    h.frame_rev
,    h.access_group
,    h.workflow_group_id
,    h.class3_id
,    h.owner
,    h.int_frame_no
,    h.int_frame_rev
,    h.int_part_no
,    h.int_part_rev
,    h.frame_owner
,    h.intl
,    h.multilang
,    h.uom_type
,    h.mask_id
,    h.ped_in_sync
,    h.locked
,    h.validity_range
,    h.is_trial
,    s.status_type
,    s.sort_desc AS status_code
FROM sc_lims_dal.v_specification_header h
JOIN sc_interspec_ens.status            s USING (status)
WITH DATA
;
grant all on  sc_lims_dal.mv_specification_status  to usr_rna_readonly1;


-- View indexes:
CREATE UNIQUE INDEX specification_status_current_uq              ON sc_lims_dal.mv_specification_status USING btree (part_no, revision) WHERE (((status_type)::text = 'CURRENT'::text) AND ((status_code)::text <> 'TEMP CRRNT'::text));
CREATE INDEX        specification_status_part_rev_type_issued_uq ON sc_lims_dal.mv_specification_status USING btree (part_no, revision, status_type, issued_date, planned_effective_date, obsolescence_date);
CREATE UNIQUE INDEX specification_status_part_uq                 ON sc_lims_dal.mv_specification_status USING btree (part_no, revision, status);
CREATE UNIQUE INDEX specification_status_status_uq               ON sc_lims_dal.mv_specification_status USING btree (status, part_no, revision);
CREATE UNIQUE INDEX specification_status_uq                      ON sc_lims_dal.mv_specification_status USING btree (part_no, revision);


--****************************************************************************
--6.sc_lims_dal.mv_specification_keyword
CREATE MATERIALIZED VIEW sc_lims_dal.mv_specification_keyword
TABLESPACE pg_default
AS 
SELECT k.part_no
,      max(k.elem) FILTER (WHERE k.key::text = 'Function'::text) AS functionkw
,      jsonb_object_agg(k.key, k.value)                          AS keywords
FROM ( SELECT sk.part_no
       ,      k_1.description AS key
	   ,      json_agg(sk.kw_value ORDER BY k_1.description, sk.kw_value) AS value
	   ,      array_agg(sk.kw_value ORDER BY sk.kw_value)                 AS elem
       FROM sc_interspec_ens.specification_kw sk
       JOIN sc_interspec_ens.itkw            k_1 USING (kw_id)
       WHERE sk.kw_value::text <> '<Any>'::text
       GROUP BY sk.part_no
	   ,       k_1.description
	 ) k
GROUP BY k.part_no
WITH DATA
;
grant all on  sc_lims_dal.mv_specification_keyword  to usr_rna_readonly1;


-- View indexes:
CREATE INDEX        sc_lims_dal.specification_keyword_function_idx ON sc_lims_dal.mv_specification_keyword USING gin (functionkw);
CREATE INDEX        sc_lims_dal.specification_keyword_keywords_idx ON sc_lims_dal.mv_specification_keyword USING gin (keywords);
CREATE UNIQUE INDEX sc_lims_dal.specification_keyword_uq           ON sc_lims_dal.mv_specification_keyword USING btree (part_no);

*/



--STEP2-MV:

--************************************************
--3.sc_lims_dal.mv_bom_path_current
--
--AFHANKELIJKHEDEN: MV_SPECIFICATION_STATUS 
--                  FNC_BOM_EXPLODE 
--
CREATE MATERIALIZED VIEW sc_lims_dal.mv_bom_path_current
TABLESPACE pg_default
AS SELECT source.part_no::text       AS source_part_no
,   source.revision::integer         AS source_revision
,   tree.component_part_no           AS destination_part_no
,   tree.component_revision::integer AS destination_revision
,   tree.part_path
,   tree.function_path
,   tree.hierarchy
FROM sc_lims_dal.mv_specification_status  source
JOIN sc_interspec_ens.bom_header             sbh USING (part_no, revision)
CROSS JOIN LATERAL sc_lims_dal.fnc_bom_explode(sbh.part_no::text, sbh.revision, sbh.alternative, sbh.plant::text) tree(part_no, revision, component_part_no, component_revision, class3_id, plant, alternative, preferred, keywords, spec_function, level, item_number, bom_function, properties, hierarchy, part_path, function_path, contains_cycle, quantity, total_quantity)
WHERE source.frame_id::text     = 'A_PCR'::text 
AND   source.status_type::text  = 'CURRENT'::text 
AND   source.status_code::text <> 'TEMP CRRNT'::text 
AND NOT (EXISTS ( SELECT 1
                  FROM sc_interspec_ens.bom_item
                  WHERE bom_item.part_no::text = tree.component_part_no)
				)
WITH DATA
;
grant all on  sc_lims_dal.mv_bom_path_current  to usr_rna_readonly1;


-- MaterializedView indexes:
CREATE INDEX        bom_path_current_destination_part_idx ON sc_lims_dal.mv_bom_path_current USING btree (destination_part_no);
CREATE INDEX        bom_path_current_function_path_idx    ON sc_lims_dal.mv_bom_path_current USING gist (function_path);
CREATE INDEX        bom_path_current_part_path_idx        ON sc_lims_dal.mv_bom_path_current USING gist (part_path);
CREATE UNIQUE INDEX bom_path_current_uq                   ON sc_lims_dal.mv_bom_path_current USING btree (source_part_no, source_revision, hierarchy);




--************************************************************
--4.sc_lims_dal.mv_frame_property_matrix
--
--LET OP: In join met tabel property_layout zijn weer 5 tech-velden verwijderd...
--
CREATE MATERIALIZED VIEW sc_lims_dal.mv_frame_property_matrix
TABLESPACE pg_default
AS SELECT fp.frame_no
,    fp.revision
,    fp.section_id
,    fp.sub_section_id
,    fp.property_group
,    fp.property
,    fp.sequence_no
,    fp.attribute
,    fp.attribute_rev
,    fp.uom_id
,    fp.uom_rev
,    fp.uom_alt_id
,    fp.uom_alt_rev
,    fp.test_method
,    fp.test_method_rev
,    fp.intl
,    fs.display_format
,    fs.display_format_rev
,    fs.type
,    fs.section_sequence_no
,    h.description AS cell
,    pl.start_pos AS cell_seq
,    upf.name AS cell_field
FROM sc_interspec_ens.frame_prop      fp
JOIN sc_interspec_ens.frame_section   fs USING (frame_no, revision, section_id, sub_section_id)
--JOIN sc_interspec_ens.property_layout pl(id, dt_created, dt_updated, md5_hash, original, layout_id, header_id, field_id, included, start_pos, length, alignment, format_id, header, color, bold, underline, intl, revision_1, header_rev, def, url, attached_spec) ON pl.layout_id = fs.display_format AND pl.revision_1 = fs.display_format_rev
JOIN sc_interspec_ens.property_layout pl(layout_id, header_id, field_id, included, start_pos, length, alignment, format_id, header, color, bold, underline, intl, revision_1, header_rev, def, url, attached_spec) ON pl.layout_id = fs.display_format AND pl.revision_1 = fs.display_format_rev
JOIN sc_lims_dal.pcr_property_field  upf USING (field_id)
JOIN sc_interspec_ens.header           h USING (header_id)
WHERE (   (  fs.type = 1::numeric 
          AND fs.ref_id = fp.property_group )
      OR  (   fs.type = 4::numeric 
          AND fs.ref_id = fp.property
          )
      )
WITH DATA
;
grant all on  sc_lims_dal.mv_frame_property_matrix  to usr_rna_readonly1;

-- View indexes:
CREATE UNIQUE INDEX frame_property_matrix_frame_no_uq       ON sc_lims_dal.mv_frame_property_matrix USING btree (frame_no, revision, section_id, sub_section_id, property_group, property, type, cell_field, section_sequence_no, display_format, attribute);
CREATE INDEX        frame_property_matrix_section_cell_idx  ON sc_lims_dal.mv_frame_property_matrix USING btree (section_id, sub_section_id, frame_no, revision, property_group, property, cell, display_format, sequence_no, section_sequence_no) INCLUDE (cell_field, cell_seq);
CREATE INDEX        frame_property_matrix_section_field_idx ON sc_lims_dal.mv_frame_property_matrix USING btree (section_id, frame_no, revision, property_group, property, cell_field, display_format, sequence_no, section_sequence_no) INCLUDE (cell, cell_seq);



--***********************************************************************
--7.sc_lims_dal.mv_specification_property
--
--LET OP: In join met tabel property_layout zijn weer 5 tech-velden verwijderd...
--
CREATE MATERIALIZED VIEW sc_lims_dal.mv_specification_property
TABLESPACE pg_default
AS 
SELECT sp.part_no
,    sp.revision
,    sp.section_id
,    sp.sub_section_id
,    sp.property_group
,    sp.property
,    sp.sequence_no
,    sp.attribute
,    sp.attribute_rev
,    sp.uom_id
,    sp.uom_rev
,    sp.uom_alt_id
,    sp.uom_alt_rev
,    sp.test_method
,    sp.test_method_rev
,    sp.intl
,    sp.info
,    ss.display_format
,    ss.display_format_rev
,    ss.section_sequence_no
,    jsonb_object_agg(h.description,
        CASE upf.name
            WHEN 'num_1'::text         THEN to_jsonb(sp.num_1)
            WHEN 'num_2'::text         THEN to_jsonb(sp.num_2)
            WHEN 'num_3'::text         THEN to_jsonb(sp.num_3)
            WHEN 'num_4'::text         THEN to_jsonb(sp.num_4)
            WHEN 'num_5'::text         THEN to_jsonb(sp.num_5)
            WHEN 'num_6'::text         THEN to_jsonb(sp.num_6)
            WHEN 'num_7'::text         THEN to_jsonb(sp.num_7)
            WHEN 'num_8'::text         THEN to_jsonb(sp.num_8)
            WHEN 'num_9'::text         THEN to_jsonb(sp.num_9)
            WHEN 'num_10'::text        THEN to_jsonb(sp.num_10)
            WHEN 'char_1'::text        THEN to_jsonb(sp.char_1)
            WHEN 'char_2'::text        THEN to_jsonb(sp.char_2)
            WHEN 'char_3'::text        THEN to_jsonb(sp.char_3)
            WHEN 'char_4'::text        THEN to_jsonb(sp.char_4)
            WHEN 'char_5'::text        THEN to_jsonb(sp.char_5)
            WHEN 'char_6'::text        THEN to_jsonb(sp.char_6)
            WHEN 'uom'::text           THEN to_jsonb(sp.uom)
            WHEN 'test_method_1'::text THEN to_jsonb(sp.test_method_1)
            WHEN 'property_1'::text    THEN to_jsonb(sp.property_1)
            WHEN 'info'::text          THEN to_jsonb(sp.info)
            WHEN 'attribute'::text     THEN to_jsonb(sp.attribute)
            WHEN 'boolean_1'::text     THEN to_jsonb(sp.boolean_1)
            WHEN 'boolean_2'::text     THEN to_jsonb(sp.boolean_2)
            WHEN 'boolean_3'::text     THEN to_jsonb(sp.boolean_3)
            WHEN 'boolean_4'::text     THEN to_jsonb(sp.boolean_4)
            WHEN 'tm_det_1'::text      THEN to_jsonb(sp.tm_det_1)
            WHEN 'tm_det_2'::text      THEN to_jsonb(sp.tm_det_2)
            WHEN 'tm_det_3'::text      THEN to_jsonb(sp.tm_det_3)
            WHEN 'tm_det_4'::text      THEN to_jsonb(sp.tm_det_4)
            WHEN 'date_1'::text        THEN to_jsonb(sp.date_1)
            WHEN 'date_2'::text        THEN to_jsonb(sp.date_2)
            WHEN 'characteristic_1'::text THEN to_jsonb(sp.characteristic_1)
            WHEN 'characteristic_2'::text THEN to_jsonb(sp.characteristic_2)
            WHEN 'characteristic_3'::text THEN to_jsonb(sp.characteristic_3)
            ELSE NULL::jsonb
        END) AS cells
,    jsonb_object_agg(h.description, pl.start_pos)   AS cell_seq
,    jsonb_object_agg(h.description, upf.name)       AS cell_field
FROM sc_lims_dal.v_specification_prop       sp        --was util_interspec
JOIN sc_interspec_ens.specification_section ss USING (part_no, revision, section_id, sub_section_id)
--JOIN sc_interspec_ens.property_layout       pl(id, dt_created, dt_updated, md5_hash, original, layout_id, header_id, field_id, included, start_pos, length, alignment, format_id, header, color, bold, underline, intl, revision_1, header_rev, def, url, attached_spec) ON pl.layout_id = ss.display_format AND pl.revision_1 = ss.display_format_rev
JOIN sc_interspec_ens.property_layout       pl(layout_id, header_id, field_id, included, start_pos, length, alignment, format_id, header, color, bold, underline, intl, revision_1, header_rev, def, url, attached_spec) ON pl.layout_id = ss.display_format AND pl.revision_1 = ss.display_format_rev
JOIN sc_lims_dal.pcr_property_field        upf USING (field_id)
JOIN sc_interspec_ens.header                 h USING (header_id)
WHERE (   (   ss.type = 1::numeric 
          AND ss.ref_id = sp.property_group 
		  )
      OR (   ss.type = 4::numeric 
         AND ss.ref_id = sp.property
		 )
      )
GROUP BY ss.display_format, ss.display_format_rev, ss.section_sequence_no, sp.part_no, sp.revision, sp.section_id, sp.sub_section_id, sp.property_group, sp.property, sp.sequence_no, sp.attribute, sp.attribute_rev, sp.uom_id, sp.uom_rev, sp.uom_alt_id, sp.uom_alt_rev, sp.test_method, sp.test_method_rev, sp.intl, sp.info
WITH DATA
;
grant all on  sc_lims_dal.mv_specification_property  to usr_rna_readonly1;


-- View indexes:
CREATE INDEX        specification_property_cell_seq_idx ON sc_lims_dal.mv_specification_property USING gin (cell_seq);
CREATE INDEX        specification_property_cells_idx    ON sc_lims_dal.mv_specification_property USING gin (cells);
CREATE UNIQUE INDEX specification_property_part_no_uq   ON sc_lims_dal.mv_specification_property USING btree (part_no, revision, section_id, sub_section_id, property_group, property, section_sequence_no, display_format, attribute);
CREATE INDEX        specification_property_section_idx  ON sc_lims_dal.mv_specification_property USING btree (section_id, part_no, revision, property_group, property, display_format, sequence_no, section_sequence_no, attribute);






--********************************************************
--5.sc_lims_dal.mv_specification
--
--AFHANKELIJKEDEN:  MV_SPECIFICATION_PROPERTY
--                  MV_SPECIFICATION_KEYWORD
--
CREATE MATERIALIZED VIEW sc_lims_dal.mv_specification
TABLESPACE pg_default
AS 
SELECT subsec.part_no
,    subsec.revision
,    sh.status
,    sh.frame_id
,    sh.class3_id
,    sh.issued_date
,    sh.obsolescence_date
,    sk.functionkw
,    jsonb_object_agg(s.description, subsec.properties) AS properties
,    sk.keywords
FROM ( SELECT propgrp.part_no
       ,      propgrp.revision
	   ,      propgrp.section_id
	   ,      jsonb_object_agg(ss.description, propgrp.properties) AS properties
       FROM ( SELECT prop.part_no
	          ,      prop.revision
			  ,      prop.section_id
			  ,      prop.sub_section_id
			  ,      jsonb_object_agg(pg.description, prop.properties) AS properties
              FROM ( SELECT sp.part_no
			         ,      sp.revision
					 ,      sp.section_id
					 ,      sp.sub_section_id
					 ,      sp.property_group
					 ,      jsonb_object_agg(p.description, sp.cells - 'Property'::text) AS properties
                     FROM sc_lims_dal.mv_specification_property sp
                     JOIN sc_interspec_ens.property              p USING (property)
                     GROUP BY sp.part_no
					 ,        sp.revision
					 ,        sp.section_id
					 ,        sp.sub_section_id
					 ,        sp.property_group  
					) prop
              JOIN sc_interspec_ens.property_group  pg USING (property_group)
              GROUP BY prop.part_no
			  ,        prop.revision
			  ,        prop.section_id
			  ,        prop.sub_section_id
			) propgrp
       JOIN sc_interspec_ens.sub_section ss USING (sub_section_id)
       GROUP BY propgrp.part_no
	   ,        propgrp.revision
	   ,        propgrp.section_id
	 ) subsec
JOIN      sc_interspec_ens.section               s USING (section_id)
JOIN      sc_interspec_ens.specification_header sh USING (part_no, revision)
LEFT JOIN sc_lims_dal.mv_specification_keyword  sk USING (part_no)
GROUP BY subsec.part_no
,    subsec.revision
,    sh.status
,    sh.frame_id
,    sh.class3_id
,    sh.issued_date
,    sh.obsolescence_date
,    sk.functionkw
,    sk.keywords
WITH DATA
;
grant all on  sc_lims_dal.mv_specification  to usr_rna_readonly1;

-- View indexes:
CREATE INDEX        specification_class_idx                 ON sc_lims_dal.mv_specification USING btree (class3_id, part_no, revision);
CREATE INDEX        specification_frame_function_status_idx ON sc_lims_dal.mv_specification USING btree (frame_id, functionkw, status, part_no, revision);
CREATE INDEX        specification_function_idx              ON sc_lims_dal.mv_specification USING btree (functionkw, part_no, revision);
CREATE INDEX        specification_keywords_idx              ON sc_lims_dal.mv_specification USING gin (keywords);
CREATE INDEX        specification_properties_idx            ON sc_lims_dal.mv_specification USING gin (properties);
CREATE INDEX        specification_qrphase_phase_idx         ON sc_lims_dal.mv_specification USING btree (jsonb_object_field_text(jsonb_object_field(jsonb_object_field(jsonb_object_field(jsonb_object_field(properties, 'SAP information'::text), '(none)'::text), 'SAP information'::text), 'QR phase'::text), 'Value'::text), part_no, revision);
CREATE INDEX        specification_qrphase_phase_pidx        ON sc_lims_dal.mv_specification USING btree (jsonb_object_field_text(jsonb_object_field(jsonb_object_field(jsonb_object_field(jsonb_object_field(properties, 'SAP information'::text), '(none)'::text), 'SAP information'::text), 'QR phase'::text), 'Value'::text), part_no, revision) WHERE (jsonb_object_field_text(jsonb_object_field(jsonb_object_field(jsonb_object_field(jsonb_object_field(properties, 'SAP information'::text), '(none)'::text), 'SAP information'::text), 'QR phase'::text), 'Value'::text) IS NOT NULL);
CREATE UNIQUE INDEX specification_uq                        ON sc_lims_dal.mv_specification USING btree (part_no, revision);


--****************************************************************
--9.sc_lims_dal.mv_specification_section
CREATE MATERIALIZED VIEW sc_lims_dal.mv_specification_section
TABLESPACE pg_default
AS 
SELECT DISTINCT ON ( sps.part_no
                   , sps.revision
                   , sps.section_id
                   , sps.sub_section_id
                   , sps.type
                   , sps.ref_id
				   ) 
     sps.part_no
,    sps.revision
,    sps.section_id
,    sps.sub_section_id
,    sps.type
,    sps.ref_id
,    sps.section_sequence_no
,    sps.ref_ver
,    sps.ref_info
,    sps.sequence_no
,    sps.header
,    sps.mandatory
,    sps.display_format
,    sps.association
,    sps.intl
,    sps.section_rev
,    sps.sub_section_rev
,    sps.display_format_rev
,    sps.ref_owner
,    sps.locked
FROM sc_interspec_ens.specification_section sps
ORDER BY sps.part_no
, sps.revision
, sps.section_id
, sps.sub_section_id
, sps.type
, sps.ref_id
, sps.dt_created DESC
WITH DATA
;
grant all on  sc_lims_dal.mv_specification_section  to usr_rna_readonly1;

-- View indexes:
CREATE INDEX        specification_section_display_format_display_format_rev_type_id ON sc_lims_dal.mv_specification_section USING btree (display_format, display_format_rev) INCLUDE (type);
CREATE INDEX        specification_section_part_no_revision_idx                      ON sc_lims_dal.mv_specification_section USING btree (part_no, revision) INCLUDE (type, ref_id);
CREATE INDEX        specification_section_section_id_part_no_rev_idx                ON sc_lims_dal.mv_specification_section USING btree (section_id, part_no, revision);
CREATE UNIQUE INDEX specification_section_uq                                        ON sc_lims_dal.mv_specification_section USING btree (part_no, revision, section_id, sub_section_id, type, ref_id);







--****************************************************************************
--8.sc_lims_dal.mv_specification_property_matrix 
--
--AFHANKELIJKHEDEN:  MV_SPECIFICATION_SECTION
--
CREATE MATERIALIZED VIEW sc_lims_dal.mv_specification_property_matrix
TABLESPACE pg_default
AS 
SELECT sp.part_no
,    sp.revision
,    sp.section_id
,    sp.sub_section_id
,    sp.property_group
,    sp.property
,    sp.sequence_no
,    sp.attribute
,    sp.attribute_rev
,    sp.uom_id
,    sp.uom_rev
,    sp.uom_alt_id
,    sp.uom_alt_rev
,    sp.test_method
,    sp.test_method_rev
,    sp.intl
,    sp.info
,    ss.display_format
,    ss.display_format_rev
,    ss.type
,    ss.section_sequence_no
,    h.description              AS cell
,    pl.start_pos               AS cell_seq
,    upf.name                   AS cell_field
,    CASE upf.name
            WHEN 'num_1'::text     THEN to_jsonb(sp.num_1)
            WHEN 'num_2'::text     THEN to_jsonb(sp.num_2)
            WHEN 'num_3'::text     THEN to_jsonb(sp.num_3)
            WHEN 'num_4'::text     THEN to_jsonb(sp.num_4)
            WHEN 'num_5'::text     THEN to_jsonb(sp.num_5)
            WHEN 'num_6'::text     THEN to_jsonb(sp.num_6)
            WHEN 'num_7'::text     THEN to_jsonb(sp.num_7)
            WHEN 'num_8'::text     THEN to_jsonb(sp.num_8)
            WHEN 'num_9'::text     THEN to_jsonb(sp.num_9)
            WHEN 'num_10'::text    THEN to_jsonb(sp.num_10)
            WHEN 'char_1'::text    THEN to_jsonb(sp.char_1)
            WHEN 'char_2'::text    THEN to_jsonb(sp.char_2)
            WHEN 'char_3'::text    THEN to_jsonb(sp.char_3)
            WHEN 'char_4'::text    THEN to_jsonb(sp.char_4)
            WHEN 'char_5'::text    THEN to_jsonb(sp.char_5)
            WHEN 'char_6'::text    THEN to_jsonb(sp.char_6)
            WHEN 'uom'::text       THEN to_jsonb(sp.uom)
            WHEN 'test_method_1'::text THEN to_jsonb(sp.test_method_1)
            WHEN 'property_1'::text THEN to_jsonb(sp.property_1)
            WHEN 'info'::text       THEN to_jsonb(sp.info)
            WHEN 'attribute'::text  THEN to_jsonb(sp.attribute)
            WHEN 'boolean_1'::text  THEN to_jsonb(sp.boolean_1)
            WHEN 'boolean_2'::text  THEN to_jsonb(sp.boolean_2)
            WHEN 'boolean_3'::text  THEN to_jsonb(sp.boolean_3)
            WHEN 'boolean_4'::text  THEN to_jsonb(sp.boolean_4)
            WHEN 'tm_det_1'::text   THEN to_jsonb(sp.tm_det_1)
            WHEN 'tm_det_2'::text   THEN to_jsonb(sp.tm_det_2)
            WHEN 'tm_det_3'::text   THEN to_jsonb(sp.tm_det_3)
            WHEN 'tm_det_4'::text   THEN to_jsonb(sp.tm_det_4)
            WHEN 'date_1'::text     THEN to_jsonb(sp.date_1)
            WHEN 'date_2'::text     THEN to_jsonb(sp.date_2)
            WHEN 'characteristic_1'::text THEN to_jsonb(sp.characteristic_1)
            WHEN 'characteristic_2'::text THEN to_jsonb(sp.characteristic_2)
            WHEN 'characteristic_3'::text THEN to_jsonb(sp.characteristic_3)
            ELSE NULL::jsonb
    END AS cell_value
FROM sc_lims_dal.v_specification_prop2    sp
JOIN sc_lims_dal.mv_specification_section ss USING (part_no, revision, section_id, sub_section_id)
JOIN sc_interspec_ens.property_layout     pl(id, dt_created, dt_updated, md5_hash, original, layout_id, header_id, field_id, included, start_pos, length, alignment, format_id, header, color, bold, underline, intl, revision_1, header_rev, def, url, attached_spec) ON pl.layout_id = ss.display_format AND pl.revision_1 = ss.display_format_rev
JOIN sc_lims_dal.pcr_property_field      upf USING (field_id)
JOIN sc_interspec_ens.header               h USING (header_id)
WHERE (  (   ss.type = 1::numeric 
         AND ss.ref_id = sp.property_group 
		 )
	  OR (   ss.type = 4::numeric 
	     AND ss.ref_id = sp.property
		 )
	  )
WITH DATA
;

-- View indexes:
CREATE INDEX        sc_lims_dal.specification_matrix_part_section_sub_group_property_idx ON sc_lims_dal.mv_specification_property_matrix USING btree (part_no, revision, section_id, sub_section_id, property_group, property);
CREATE UNIQUE INDEX sc_lims_dal.specification_property_matrix_part_no_uq                 ON sc_lims_dal.mv_specification_property_matrix USING btree (part_no, revision, section_id, sub_section_id, property_group, property, type, cell_field, section_sequence_no, display_format, attribute);
CREATE INDEX        sc_lims_dal.specification_property_matrix_section_cell_idx           ON sc_lims_dal.mv_specification_property_matrix USING btree (section_id, sub_section_id, part_no, revision, property_group, property, cell, display_format, sequence_no, section_sequence_no) INCLUDE (cell_field, cell_seq);
CREATE INDEX        sc_lims_dal.specification_property_matrix_section_field_idx          ON sc_lims_dal.mv_specification_property_matrix USING btree (section_id, part_no, revision, property_group, property, cell_field, display_format, sequence_no, section_sequence_no) INCLUDE (cell, cell_seq);





--******************************************************
--UNILAB !!!!!!!!!!!
--******************************************************
--100.sc_lims_dal.mv_avtestmethod
CREATE MATERIALIZED VIEW sc_lims_dal.mv_avtestmethod
TABLESPACE pg_default
AS 
SELECT av1.value                                 AS testmethod
,    av2.value                                   AS testmethoddesc
,    starts_with(av1.pa::text, av1.value::text)  AS issummary
,    av1.sc
,    av1.pg 
,    av1.pgnode
,    av1.pa
,    av1.panode
,    av1.tm_seq
FROM ( SELECT au.sc
       ,      au.pg
	   ,      au.pgnode
	   ,      au.pa
	   ,      au.panode
	   ,      au.value
	   ,      row_number() OVER (PARTITION BY au.sc, au.pg, au.pgnode, au.pa, au.panode, au.au ORDER BY au.auseq) AS tm_seq
       FROM sc_unilab_ens.uvscpaau  au
       WHERE au.au::text = 'avTestMethod'::text 
	   AND au.value IS NOT NULL
	  ) av1
LEFT JOIN ( SELECT aud.sc
            ,      aud.pg
			,      aud.pgnode
			,      aud.pa
			,      aud.panode
			,      aud.value
			,      row_number() OVER (PARTITION BY aud.sc, aud.pg, aud.pgnode, aud.pa, aud.panode, aud.au ORDER BY aud.auseq) AS tm_seq
            FROM sc_unilab_ens.uvscpaau  aud
            WHERE aud.au::text = 'avTestMethodDesc'::text 
			AND   aud.value IS NOT NULL
	      ) av2 ON ( av2.sc::text = av1.sc::text AND av2.pg::text = av1.pg::text AND av2.pgnode = av1.pgnode AND av2.pa::text = av1.pa::text AND av2.panode = av1.panode AND av2.tm_seq = av1.tm_seq )
WITH DATA
;

-- View indexes:
CREATE UNIQUE INDEX sc_lims_dal.avtestmethod_pk             ON sc_lims_dal.mv_avtestmethod USING btree (sc, pg, pgnode, pa, panode, tm_seq);
CREATE UNIQUE INDEX sc_lims_dal.avtestmethod_testmethod_idx ON sc_lims_dal.mv_avtestmethod USING btree (testmethod, sc, pg, pgnode, pa, panode, tm_seq);









--einde script



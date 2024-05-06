--***********************************************************************************
--***********************************************************************************
--***********************************************************************************
--***********************************************************************************
--AURORA BASE-INTERSPEC - VIEWS
--***********************************************************************************
--***********************************************************************************
--***********************************************************************************
--***********************************************************************************
--***********************************************************************************
--postgres-base-views from rd_interspec_webfocus   migrated  to sc_lims_dal-views !!
--
--1.rd_interspec_webfocus.v_bom_item               --> sc_lims_dal.v_bom_item
--2.rd_interspec_webfocus.v_specification_header   --> sc_lims_dal.v_specification_header
--3.rd_interspec_webfocus.v_specification_prop     --> sc_lims_dal.v_specification_FUNC_prop        -->CONTROLE OP SYNTAX MET UTIL-INTERSPEC-VW WAS ZELFDE NAAM  v_specification_prop !!!!!!!!

--postgres-base-views from util_interspec   migrated    to sc_lims_dal.views !!!
--
--1.util_interspec.v_bom_prop_field				--> sc_lims_dal.v_bom_prop_field
--2.util_interspec.v_specification_prop         --> sc_lims_dal.v_specification_prop           -->CONTROLE MET VW VANUIT RD_INTERSPEC_WEBFOCUS MET ZELFDE NAAM !!!!!!!!!
--3.util_interspec.v_specification_prop2        --> sc_lims_dal.v_specification_prop2
--4.util_interspec.v_specification_prop_field   --> sc_lims_dal.v_specification_prop_field
--5.util_interspec.v_specification_prop_field2  --> sc_lims_dal.v_specification_prop_field2
--***********************************************************************************


--************************************************************
--MIGRATION SC_INTERSPEC_WEBFOCUS-VIEWS
--************************************************************
--1.sc_lims_dal.v_bom_item
/*
--PS: leave these attributes, they are not in base-source-table...
AS SELECT bi.id
,    bi.dt_created
,    bi.dt_updated
,    bi.md5_hash
,    bi.original
*/


CREATE OR REPLACE VIEW sc_lims_dal.v_bom_item
AS SELECT 
     bi.part_no
,    bi.revision
,    bi.plant
,    bi.alternative
,    bi.bom_usage
,    bi.item_number
,    bi.component_part
,    bi.component_revision
,    bi.component_plant
,    bi.quantity
,    bi.uom
,    bi.conv_factor
,    bi.to_unit
,    bi.yield
,    bi.assembly_scrap
,    bi.component_scrap
,    bi.lead_time_offset
,    bi.item_category
,    bi.issue_location
,    bi.calc_flag
,    bi.bom_item_type
,    bi.operational_step
,    bi.min_qty
,    bi.max_qty
,    bi.char_1
,    bi.char_2
,    bi.code
,    bi.alt_group
,    bi.alt_priority
,    bi.num_1
,    bi.num_2
,    bi.num_3
,    bi.num_4
,    bi.num_5
,    bi.char_3
,    bi.char_4
,    bi.char_5
,    bi.date_1
,    bi.date_2
,    bi.ch_1
,    bi.ch_rev_1
,    bi.ch_2
,    bi.ch_rev_2
,    bi.ch_3
,    bi.ch_rev_3
,    bi.relevency_to_costing
,    bi.bulk_material
,    bi.fixed_qty
,    bi.boolean_1
,    bi.boolean_2
,    bi.boolean_3
,    bi.boolean_4
,    bi.make_up
,    bi.intl_equivalent
,    bi.component_scrap_sync
,    ( SELECT ch1.description   FROM sc_interspec_ens.characteristic ch1 WHERE ch1.characteristic_id = bi.ch_1) AS characteristic_1
,    ( SELECT ch2.description   FROM sc_interspec_ens.characteristic ch2 WHERE ch2.characteristic_id = bi.ch_2) AS characteristic_2
,    ( SELECT ch3.description   FROM sc_interspec_ens.characteristic ch3 WHERE ch3.characteristic_id = bi.ch_3) AS characteristic_3
FROM sc_interspec_ens.bom_item bi
;

grant all on  sc_lims_dal.v_bom_item  to usr_rna_readonly1;

   
--******************************************************************   
--2.sc_lims_dal.v_specification_header 
CREATE OR REPLACE VIEW sc_lims_dal.v_specification_header
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
,    CASE   WHEN h.issued_date IS NULL AND h.obsolescence_date IS NULL THEN NULL::tsrange
            WHEN h.issued_date IS NULL                                 THEN tsrange('-infinity'::timestamp without time zone, h.obsolescence_date)
            WHEN h.obsolescence_date IS NULL                           THEN tsrange(h.issued_date, 'infinity'::timestamp without time zone)
            WHEN h.obsolescence_date < h.issued_date                   THEN tsrange(h.issued_date, h.issued_date)
            ELSE tsrange(h.issued_date, h.obsolescence_date)
     END                                                             AS validity_range
,   h.part_no::text ~~ 'X%'::text                                    AS is_trial
FROM sc_interspec_ens.specification_header h
;
grant all on  sc_lims_dal.v_specification_header  to usr_rna_readonly1;


--******************************************************************
--3.sc_lims_dal.v_specification_prop 
--
--LET OP: WAS VIEW: RD_INTERSPEC_WEBFOCUS.v_specification_prop    wordt nu SC_LIMS_DAL.v_specification_func_prop !!!!!!!!!!!!!!!!!!
--        KOMT QUA NAAMGEVING OVEREEN MET UTIL_INTERSPEC.V_SPECIFICATION_PROP MAAR INHOUDELIJK HETZELFDE ALS UTIL_INTERSPEC.V_SPECIFICATION_PROP2 !!!!!
--******************************************************************
CREATE OR REPLACE VIEW sc_lims_dal.v_specification_func_prop
AS 
SELECT p.part_no
,    p.revision
,    p.section_id
,    p.sub_section_id
,    p.section_rev
,    p.sub_section_rev
,    p.property_group
,    p.property
,    p.property_group_rev
,    p.property_rev
,    p.attribute
,    p.attribute_rev
,    p.uom_id
,    p.uom_rev
,    p.test_method
,    p.test_method_rev
,    p.sequence_no
,    p.num_1
,    p.num_2
,    p.num_3
,    p.num_4
,    p.num_5
,    p.num_6
,    p.num_7
,    p.num_8
,    p.num_9
,    p.num_10
,    p.char_1
,    p.char_2
,    p.char_3
,    p.char_4
,    p.char_5
,    p.char_6
,    p.boolean_1
,    p.boolean_2
,    p.boolean_3
,    p.boolean_4
,    p.date_1
,    p.date_2
,    p.characteristic
,    p.characteristic_rev
,    p.association
,    p.association_rev
,    p.intl
,    p.info
,    p.uom_alt_id
,    p.uom_alt_rev
,    p.tm_det_1
,    p.tm_det_2
,    p.tm_det_3
,    p.tm_det_4
,    p.tm_set_no
,    p.ch_2
,    p.ch_rev_2
,    p.ch_3
,    p.ch_rev_3
,    p.as_2
,    p.as_rev_2
,    p.as_3
,    p.as_rev_3
,    ( SELECT uom.description FROM sc_interspec_ens.uom            uom WHERE uom.uom_id            = p.uom_id)         AS uom
,    ( SELECT tm.description  FROM sc_interspec_ens.test_method    tm  WHERE tm.test_method        = p.test_method)    AS test_method_1
,    ( SELECT ch1.description FROM sc_interspec_ens.characteristic ch1 WHERE ch1.characteristic_id = p.characteristic) AS characteristic_1
,    ( SELECT pr.description  FROM sc_interspec_ens.property       pr  WHERE pr.property           = p.property)       AS property_1
,    ( SELECT ch2.description FROM sc_interspec_ens.characteristic ch2 WHERE ch2.characteristic_id = p.ch_2)           AS characteristic_2
,    ( SELECT ch3.description FROM sc_interspec_ens.characteristic ch3 WHERE ch3.characteristic_id = p.ch_3)           AS characteristic_3
,    sk.kw_value                                                                                                            AS functionkw
FROM      sc_interspec_ens.specification_prop p
LEFT JOIN sc_interspec_ens.specification_kw   sk ON ( sk.part_no::text = p.part_no::text AND sk.kw_id = 700386::numeric )
;
grant all on  sc_lims_dal.v_specification_func_prop  to usr_rna_readonly1;




/*
--kw_id = 700386 
700386	Belt
700386	Sidewall L/R
700386	Cement
700386	Chafer
700386	Carcass
700386	Compound
700386	Pre-Assembly
700386	Capply
700386	Steel_chafer
700386	Bead cushion
700386	Band
700386	Sidewall
700386	Innerliner assembly
700386	Beadwire
700386	Flipper
700386	Chipper
700386	Fabric
700386	Innerliner
700386	Technical layer
700386	Label
700386	Rim cushion
700386	Greentyre
700386	Tread
700386	AT Belt
700386	Insert_runflat
700386	Spike tyre
700386	<Any>
700386	Ply
700386	Racknumber
700386	Tyre vulcanized
700386	Steelcord
700386	Colour marking
700386	Bead
700386	Tyre
700386	Apex TBR
700386	Rubberstrip
*/



--*******************************************************
--migration UTIL-INTERSPEC-views
--*******************************************************
--
--*************************************
--1.sc_lims_dal.v_bom_prop_field
--
--AFHANKELIJK VAN: V_BOM_ITEM-view   (zie hiervoor in script, is al aangemaakt)
--
--LET OP: OOK HIER HEB IK 5 TECH-ATTRIBUTEN UIT DE JOIN MET BOMLYITEM WEG MOETEN HALEN !!!!!!!!!!!!!!
--
CREATE OR REPLACE VIEW sc_lims_dal.v_bom_prop_field
AS SELECT bi.part_no
,    bi.revision
,    bi.plant
,    bi.alternative
,    bi.item_number
,    bi.component_part
,    bi.bom_usage
,    bi.quantity
,    bi.uom
,    bi.yield
,    bli.field_id
,    bli.header_id
,    bli.start_pos
,    ublf.name AS field_name
,    ublf.type AS field_type
,    CASE ublf.type
            WHEN 'double precision'::text 
			THEN CASE ublf.name
                      WHEN 'num_1'::text THEN bi.num_1
                      WHEN 'num_2'::text THEN bi.num_2
                      WHEN 'num_3'::text THEN bi.num_3
                      WHEN 'num_4'::text THEN bi.num_4
                      WHEN 'num_5'::text THEN bi.num_5
                      ELSE NULL::double precision
                 END
            ELSE NULL::double precision
     END AS float_val
,    CASE ublf.type
            WHEN 'varchar'::text THEN
                CASE ublf.name
                WHEN 'component_part'::text   THEN bi.component_part
                WHEN 'description'::text      THEN bh.description
                WHEN 'component_plant'::text  THEN bi.component_plant
                WHEN 'uom'::text              THEN bi.uom
                WHEN 'to_unit'::text          THEN bi.to_unit
                WHEN 'item_category'::text    THEN bi.item_category
                WHEN 'issue_location'::text   THEN bi.issue_location
                WHEN 'bom_item_type'::text    THEN bi.bom_item_type
                WHEN 'char_1'::text           THEN bi.char_1
                WHEN 'char_2'::text           THEN bi.char_2
                WHEN 'char_3'::text           THEN bi.char_3
                WHEN 'char_4'::text           THEN bi.char_4
                WHEN 'char_5'::text           THEN bi.char_5
                WHEN 'characteristic_1'::text THEN bi.characteristic_1
                WHEN 'characteristic_2'::text THEN bi.characteristic_2
                WHEN 'characteristic_3'::text THEN bi.characteristic_3
                ELSE NULL::character varying
                END
            ELSE NULL::character varying
        END AS char_val
,   CASE ublf.type
            WHEN 'boolean'::text THEN
            CASE ublf.name
                WHEN 'relevancy_to_costing'::text THEN bi.relevency_to_costing
                WHEN 'bulk_material'::text        THEN bi.bulk_material
                WHEN 'fixed_qty'::text            THEN bi.fixed_qty
                WHEN 'boolean_1'::text            THEN bi.boolean_1
                WHEN 'boolean_2'::text            THEN bi.boolean_2
                WHEN 'boolean_3'::text            THEN bi.boolean_3
                WHEN 'boolean_4'::text            THEN bi.boolean_4
                ELSE NULL::numeric
            END
            ELSE NULL::numeric
    END AS boolean_val
,   CASE ublf.type
            WHEN 'timestamp'::text THEN
            CASE ublf.name
                WHEN 'date_1'::text THEN bi.date_1
                WHEN 'date_2'::text THEN bi.date_2
                ELSE NULL::timestamp without time zone
            END
            ELSE NULL::timestamp without time zone
    END AS date_val
,   CASE ublf.type
            WHEN 'numeric'::text THEN
            CASE ublf.name
                WHEN 'quantity'::text           THEN bi.quantity::double precision
                WHEN 'conv_factor'::text        THEN bi.conv_factor
                WHEN 'yield'::text              THEN bi.yield::double precision
                WHEN 'assembly_scrap'::text     THEN bi.assembly_scrap::double precision
                WHEN 'component_scrap'::text    THEN bi.component_scrap::double precision
                WHEN 'lead_time_offset'::text   THEN bi.lead_time_offset::double precision
                WHEN 'operational_step'::text   THEN bi.operational_step::double precision
                WHEN 'min_qty'::text            THEN bi.min_qty::double precision
                WHEN 'max_qty'::text            THEN bi.max_qty::double precision
                WHEN 'component_revision'::text THEN bi.component_revision::double precision
                WHEN 'item_number'::text        THEN bi.item_number::double precision
                ELSE NULL::double precision
            END
            ELSE NULL::double precision
    END AS num_val
FROM sc_lims_dal.v_bom_item          bi
JOIN sc_interspec_ens.bom_header     bh USING (part_no, revision)
JOIN sc_interspec_ens.part            p USING (part_no)
JOIN sc_interspec_ens.itbomlysource bls ON bls.source::text = p.part_source::text
--JOIN sc_interspec_ens.itbomlyitem   bli(id, dt_created, dt_updated, md5_hash, original, layout_id, header_id, field_id, included, start_pos, length, alignment, format_id, header, color, bold, underline, intl, revision_1, header_rev, def, field_type, editable, phase_mrp, planning_mrp, production_mrp, association, characteristic) ON bli.layout_id::double precision = bls.layout_id AND bli.revision_1::double precision = bls.layout_rev
JOIN sc_interspec_ens.itbomlyitem   bli(layout_id, header_id, field_id, included, start_pos, length, alignment, format_id, header, color, bold, underline, intl, revision_1, header_rev, def, field_type, editable, phase_mrp, planning_mrp, production_mrp, association, characteristic) ON bli.layout_id::double precision = bls.layout_id AND bli.revision_1::double precision = bls.layout_rev
JOIN sc_lims_dal.pcr_bom_field       ublf USING (field_id)
JOIN sc_lims_dal.pcr_bom_layout_type ublt ON ublt.type::double precision = bls.layout_type
WHERE ublt.table_name::text = 'bom_item'::text 
AND    bls.preferred        = 1::numeric
;
grant all on  sc_lims_dal.v_bom_prop_field  to usr_rna_readonly1;



  
--*************************************************************  
--2.util_interspec.v_specification_prop 
--
/*
--TECH-ATTRIBUTEN weg moeten halen voor juiste werking !!!!!
AS SELECT sp.id
,    sp.dt_created
,    sp.dt_updated
,    sp.md5_hash
,    sp.original
*/

CREATE OR REPLACE VIEW sc_lims_dal.v_specification_prop
as SELECT sp.part_no
,    sp.revision
,    sp.property_group
,    sp.property
,    sp.attribute
,    sp.section_id
,    sp.sub_section_id
,    sp.section_rev
,    sp.sub_section_rev
,    sp.property_group_rev
,    sp.property_rev
,    sp.attribute_rev
,    sp.uom_id
,    sp.uom_rev
,    sp.test_method
,    sp.test_method_rev
,    sp.sequence_no
,    sp.num_1
,    sp.num_2
,    sp.num_3
,    sp.num_4
,    sp.num_5
,    sp.num_6
,    sp.num_7
,    sp.num_8
,    sp.num_9
,    sp.num_10
,    sp.char_1
,    sp.char_2
,    sp.char_3
,    sp.char_4
,    sp.char_5
,    sp.char_6
,    sp.boolean_1
,    sp.boolean_2
,    sp.boolean_3
,    sp.boolean_4
,    sp.date_1
,    sp.date_2
,    sp.characteristic
,    sp.characteristic_rev
,    sp.association
,    sp.association_rev
,    sp.intl
,    sp.info
,    sp.uom_alt_id
,    sp.uom_alt_rev
,    sp.tm_det_1
,    sp.tm_det_2
,    sp.tm_det_3
,    sp.tm_det_4
,    sp.tm_set_no
,    sp.ch_2
,    sp.ch_rev_2
,    sp.ch_3
,    sp.ch_rev_3
,    sp.as_2
,    sp.as_rev_2
,    sp.as_3
,    sp.as_rev_3
,    p.description    AS property_1
,    u.description    AS uom
,    tm.description   AS test_method_1
,   CASE c.characteristic_id WHEN sp.characteristic THEN c.description  ELSE NULL::character varying  END AS characteristic_1
,   CASE c.characteristic_id WHEN sp.ch_2           THEN c.description  ELSE NULL::character varying  END AS characteristic_2
,   CASE c.characteristic_id WHEN sp.ch_3           THEN c.description  ELSE NULL::character varying  END AS characteristic_3
FROM      sc_interspec_ens.specification_prop  sp
JOIN      sc_interspec_ens.property             p USING (property)
LEFT JOIN sc_interspec_ens.uom                  u USING (uom_id)
LEFT JOIN sc_interspec_ens.test_method         tm USING (test_method)
LEFT JOIN sc_interspec_ens.characteristic       c ON  c.characteristic_id = ANY (ARRAY[sp.characteristic, sp.ch_2, sp.ch_3])
;
grant all on  sc_lims_dal.v_specification_prop  to usr_rna_readonly1;



--************************************************
--3.sc_lims_dal.v_specification_prop2 
CREATE OR REPLACE VIEW sc_lims_dal.v_specification_prop2
AS SELECT p.part_no
,    p.revision
,    p.section_id
,    p.sub_section_id
,    p.section_rev
,    p.sub_section_rev
,    p.property_group
,    p.property
,    p.property_group_rev
,    p.property_rev
,    p.attribute
,    p.attribute_rev
,    p.uom_id
,    p.uom_rev
,    p.test_method
,    p.test_method_rev
,    p.sequence_no
,    p.num_1
,    p.num_2
,    p.num_3
,    p.num_4
,    p.num_5
,    p.num_6
,    p.num_7
,    p.num_8
,    p.num_9
,    p.num_10
,    p.char_1
,    p.char_2
,    p.char_3
,    p.char_4
,    p.char_5
,    p.char_6
,    p.boolean_1
,    p.boolean_2
,    p.boolean_3
,    p.boolean_4
,    p.date_1
,    p.date_2
,    p.characteristic
,    p.characteristic_rev
,    p.association
,    p.association_rev
,    p.intl
,    p.info
,    p.uom_alt_id
,    p.uom_alt_rev
,    p.tm_det_1
,    p.tm_det_2
,    p.tm_det_3
,    p.tm_det_4
,    p.tm_set_no
,    p.ch_2
,    p.ch_rev_2
,    p.ch_3
,    p.ch_rev_3
,    p.as_2
,    p.as_rev_2
,    p.as_3
,    p.as_rev_3
,    ( SELECT uom.description             FROM sc_interspec_ens.uom            WHERE uom.uom_id = p.uom_id)                               AS uom
,    ( SELECT test_method.description     FROM sc_interspec_ens.test_method    WHERE test_method.test_method = p.test_method)             AS test_method_1
,    ( SELECT characteristic.description  FROM sc_interspec_ens.characteristic WHERE characteristic.characteristic_id = p.characteristic) AS characteristic_1
,    ( SELECT property.description        FROM sc_interspec_ens.property       WHERE property.property = p.property)                      AS property_1
,    ( SELECT characteristic.description  FROM sc_interspec_ens.characteristic WHERE characteristic.characteristic_id = p.ch_2)           AS characteristic_2
,    ( SELECT characteristic.description  FROM sc_interspec_ens.characteristic WHERE characteristic.characteristic_id = p.ch_3)           AS characteristic_3
FROM sc_interspec_ens.specification_prop p
;
grant all on  sc_lims_dal.v_specification_prop2  to usr_rna_readonly1;



--*****************************************************************
--4.sc_lims_dal.v_specification_prop_field
--
--LETOP: Ook hier bij JOIN met property_layout weer 5 tech-attributen weg moeten halen !!
--
CREATE OR REPLACE VIEW sc_lims_dal.v_specification_prop_field
AS SELECT sp.part_no
,    sp.revision
,    sp.section_id
,    sp.section_rev
,    sp.sub_section_id
,    sp.sub_section_rev
,    sp.property_group
,    sp.property_group_rev
,    sp.property
,    sp.property_rev
,    sp.intl
,    sp.functionkw
,    ss.section_sequence_no
,    ss.sequence_no
,    pl.field_id
,    pl.header_id
,    pl.start_pos
,    upf.name         AS field_name
,    upf.type_1       AS field_type
,    CASE upf.type_1
        WHEN 'double precision'::text THEN
            CASE upf.name
                WHEN 'num_1'::text  THEN sp.num_1
                WHEN 'num_2'::text  THEN sp.num_2
                WHEN 'num_3'::text  THEN sp.num_3
                WHEN 'num_4'::text  THEN sp.num_4
                WHEN 'num_5'::text  THEN sp.num_5
                WHEN 'num_6'::text  THEN sp.num_6
                WHEN 'num_7'::text  THEN sp.num_7
                WHEN 'num_8'::text  THEN sp.num_8
                WHEN 'num_9'::text  THEN sp.num_9
                WHEN 'num_10'::text THEN sp.num_10
                ELSE NULL::double precision
            END
        ELSE NULL::double precision
    END AS float_val
,   CASE upf.type_1
        WHEN 'varchar'::text THEN
            CASE upf.name
                WHEN 'char_1'::text           THEN sp.char_1
                WHEN 'char_2'::text           THEN sp.char_2
                WHEN 'char_3'::text           THEN sp.char_3
                WHEN 'char_4'::text           THEN sp.char_4
                WHEN 'char_5'::text           THEN sp.char_5
                WHEN 'char_6'::text           THEN sp.char_6
                WHEN 'uom'::text              THEN sp.uom
                WHEN 'test_method_1'::text    THEN sp.test_method_1
                WHEN 'characteristic_1'::text THEN sp.characteristic_1
                WHEN 'property_1'::text       THEN sp.property_1
                WHEN 'characteristic_2'::text THEN sp.characteristic_2
                WHEN 'characteristic_3'::text THEN sp.characteristic_3
                WHEN 'info'::text             THEN sp.info
                ELSE NULL::character varying
            END
        ELSE NULL::character varying
    END AS char_val
,   CASE upf.type_1
        WHEN 'char'::text THEN
            CASE upf.name
                WHEN 'boolean_1'::text THEN sp.boolean_1
                WHEN 'boolean_2'::text THEN sp.boolean_2
                WHEN 'boolean_3'::text THEN sp.boolean_3
                WHEN 'boolean_4'::text THEN sp.boolean_4
                WHEN 'tm_det_2'::text  THEN sp.tm_det_2
                WHEN 'tm_det_1'::text  THEN sp.tm_det_1
                WHEN 'tm_det_3'::text  THEN sp.tm_det_3
                WHEN 'tm_det_4'::text  THEN sp.tm_det_4
                ELSE NULL::character varying
            END
        ELSE NULL::character varying
    END AS boolean_val
,   CASE upf.type_1
        WHEN 'timestamp'::text THEN
            CASE upf.name
                WHEN 'date_1'::text THEN sp.date_1
                WHEN 'date_2'::text THEN sp.date_2
                ELSE NULL::timestamp without time zone
            END
        ELSE NULL::timestamp without time zone
    END AS date_val
,   CASE upf.type_1
        WHEN 'numeric'::text THEN
            CASE upf.name
                WHEN 'attribute'::text THEN sp.attribute::double precision
                ELSE NULL::double precision
            END
        ELSE NULL::double precision
    END AS num_val
,   CASE upf.type_1
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
                WHEN 'char_1'::text           THEN sp.char_1
                WHEN 'char_2'::text           THEN sp.char_2
                WHEN 'char_3'::text           THEN sp.char_3
                WHEN 'char_4'::text           THEN sp.char_4
                WHEN 'char_5'::text           THEN sp.char_5
                WHEN 'char_6'::text           THEN sp.char_6
                WHEN 'uom'::text              THEN sp.uom
                WHEN 'test_method_1'::text    THEN sp.test_method_1
                WHEN 'characteristic_1'::text THEN sp.characteristic_1
                WHEN 'property_1'::text       THEN sp.property_1
                WHEN 'characteristic_2'::text THEN sp.characteristic_2
                WHEN 'characteristic_3'::text THEN sp.characteristic_3
                WHEN 'info'::text             THEN sp.info
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
        END                                       AS value_literal
FROM sc_lims_dal.v_specification_func_prop   sp
JOIN sc_interspec_ens.specification_section  ss USING (part_no, revision, section_id, sub_section_id)
JOIN sc_lims_dal.pcr_section_type           ust USING (type)
--JOIN sc_interspec_ens.property_layout        pl(id, dt_created, dt_updated, md5_hash, original, layout_id, header_id, field_id, included, start_pos, length, alignment, format_id, header, color, bold, underline, intl, revision_1, header_rev, def, url, attached_spec) ON pl.layout_id = ss.display_format AND pl.revision_1 = ss.display_format_rev
JOIN sc_interspec_ens.property_layout        pl(layout_id, header_id, field_id, included, start_pos, length, alignment, format_id, header, color, bold, underline, intl, revision_1, header_rev, def, url, attached_spec) ON pl.layout_id = ss.display_format AND pl.revision_1 = ss.display_format_rev
JOIN sc_lims_dal.pcr_property_field         upf(field_id, name, type_1) USING (field_id)
WHERE (  (   ust.table_name::text = 'property_group'::text 
         AND ss.ref_id = sp.property_group 
		 )
      OR (   ust.table_name::text = 'property'::text 
         AND ss.ref_id = sp.property
		 )
      )
;

grant all on  sc_lims_dal.v_specification_prop_field  to usr_rna_readonly1;

  
  
--*******************************************************  
--5.util_interspec.v_specification_prop_field2
--
--LETOP: OOK HIER BIJ DE JOIN MET TABLE PROPERTY-LAYOUT WEER 5 TECH-ATTRIB MOETEN VERWIJDEREN...
--
CREATE OR REPLACE VIEW sc_lims_dal.v_specification_prop_field2
AS SELECT sp.part_no
,    sp.revision
,    sp.section_id
,    sp.section_rev
,    sp.sub_section_id
,    sp.sub_section_rev
,    sp.property_group
,    sp.property_group_rev
,    sp.property
,    sp.property_rev
,    sp.intl
,    ss.section_sequence_no
,    ss.sequence_no
,    pl.field_id
,    pl.header_id
,    upf.name
,    upf.type_1 AS type
,    CASE upf.type_1
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
    END AS num_val
,   CASE upf.type_1
        WHEN 'varchar'::text THEN
            CASE upf.name
                WHEN 'char_1'::text          THEN sp.char_1
                WHEN 'char_2'::text          THEN sp.char_2
                WHEN 'char_3'::text          THEN sp.char_3
                WHEN 'char_4'::text          THEN sp.char_4
                WHEN 'char_5'::text          THEN sp.char_5
                WHEN 'char_6'::text          THEN sp.char_6
                WHEN 'uom'::text             THEN sp.uom
                WHEN 'test_method_1'::text   THEN sp.test_method_1
                WHEN 'characteristic_1'::text THEN sp.characteristic_1
                WHEN 'property_1'::text       THEN sp.property_1
                WHEN 'characteristic_2'::text THEN sp.characteristic_2
                WHEN 'characteristic_3'::text THEN sp.characteristic_3
                WHEN 'info'::text             THEN sp.info
                ELSE NULL::character varying
            END
        ELSE NULL::character varying
    END AS char_val
,   CASE upf.type_1
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
    END AS boolean_val
,   CASE upf.type_1
        WHEN 'timestamp'::text THEN
            CASE upf.name
                WHEN 'date_1'::text THEN sp.date_1
                WHEN 'date_2'::text THEN sp.date_2
                ELSE NULL::timestamp without time zone
            END
        ELSE NULL::timestamp without time zone
    END AS date_val
FROM sc_lims_dal.v_specification_prop       sp
JOIN sc_interspec_ens.specification_section ss  USING (part_no, revision, section_id, sub_section_id)
JOIN sc_lims_dal.pcr_section_type           ust USING (type)
--JOIN sc_interspec_ens.property_layout        pl(id, dt_created, dt_updated, md5_hash, original, layout_id, header_id, field_id, included, start_pos, length, alignment, format_id, header, color, bold, underline, intl, revision_1, header_rev, def, url, attached_spec) ON pl.layout_id = ss.display_format AND pl.revision_1 = ss.display_format_rev
JOIN sc_interspec_ens.property_layout        pl(layout_id, header_id, field_id, included, start_pos, length, alignment, format_id, header, color, bold, underline, intl, revision_1, header_rev, def, url, attached_spec) ON pl.layout_id = ss.display_format AND pl.revision_1 = ss.display_format_rev
JOIN sc_lims_dal.pcr_property_field          upf(field_id, name, type_1) USING (field_id)
WHERE (  (  ust.table_name::text = 'property_group'::text 
         AND    ss.ref_id = sp.property_group 
         )
     OR (   ust.table_name::text = 'property'::text 
        AND ss.ref_id = sp.property
		)
      )
;
grant all on  sc_lims_dal.v_specification_prop_field2  to usr_rna_readonly1;

		
   



--einde script



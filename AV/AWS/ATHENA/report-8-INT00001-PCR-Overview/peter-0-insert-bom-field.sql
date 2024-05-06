INSERT INTO sc_lims_dal.pcr_bom_field (field_id, "name", "type") VALUES(1, 'component_part', 'varchar');
INSERT INTO sc_lims_dal.pcr_bom_field (field_id, "name", "type") VALUES(2, 'description', 'varchar');
INSERT INTO sc_lims_dal.pcr_bom_field (field_id, "name", "type") VALUES(3, 'component_plant', 'varchar');
INSERT INTO sc_lims_dal.pcr_bom_field (field_id, "name", "type") VALUES(4, 'quantity', 'numeric');
INSERT INTO sc_lims_dal.pcr_bom_field (field_id, "name", "type") VALUES(5, 'uom', 'varchar');
INSERT INTO sc_lims_dal.pcr_bom_field (field_id, "name", "type") VALUES(6, 'to_unit', 'varchar');
INSERT INTO sc_lims_dal.pcr_bom_field (field_id, "name", "type") VALUES(7, 'conv_factor', 'numeric');
INSERT INTO sc_lims_dal.pcr_bom_field (field_id, "name", "type") VALUES(8, 'yield', 'numeric');
INSERT INTO sc_lims_dal.pcr_bom_field (field_id, "name", "type") VALUES(9, 'assembly_scrap', 'numeric');
INSERT INTO sc_lims_dal.pcr_bom_field (field_id, "name", "type") VALUES(10, 'component_scrap', 'numeric');
INSERT INTO sc_lims_dal.pcr_bom_field (field_id, "name", "type") VALUES(11, 'lead_time_offset', 'numeric');
INSERT INTO sc_lims_dal.pcr_bom_field (field_id, "name", "type") VALUES(12, 'relevancy_to_costing', 'boolean');
INSERT INTO sc_lims_dal.pcr_bom_field (field_id, "name", "type") VALUES(13, 'bulk_material', 'boolean');
INSERT INTO sc_lims_dal.pcr_bom_field (field_id, "name", "type") VALUES(14, 'item_category', 'varchar');
INSERT INTO sc_lims_dal.pcr_bom_field (field_id, "name", "type") VALUES(15, 'issue_location', 'varchar');
INSERT INTO sc_lims_dal.pcr_bom_field (field_id, "name", "type") VALUES(16, 'calc_flag', 'char');
INSERT INTO sc_lims_dal.pcr_bom_field (field_id, "name", "type") VALUES(17, 'bom_item_type', 'varchar');
INSERT INTO sc_lims_dal.pcr_bom_field (field_id, "name", "type") VALUES(18, 'operational_step', 'numeric');
INSERT INTO sc_lims_dal.pcr_bom_field (field_id, "name", "type") VALUES(19, 'min_qty', 'numeric');
INSERT INTO sc_lims_dal.pcr_bom_field (field_id, "name", "type") VALUES(20, 'max_qty', 'numeric');
INSERT INTO sc_lims_dal.pcr_bom_field (field_id, "name", "type") VALUES(21, 'fixed_qty', 'boolean');
INSERT INTO sc_lims_dal.pcr_bom_field (field_id, "name", "type") VALUES(22, 'component_revision', 'numeric');
INSERT INTO sc_lims_dal.pcr_bom_field (field_id, "name", "type") VALUES(23, 'item_number', 'numeric');
INSERT INTO sc_lims_dal.pcr_bom_field (field_id, "name", "type") VALUES(25, 'char_1', 'varchar');
INSERT INTO sc_lims_dal.pcr_bom_field (field_id, "name", "type") VALUES(26, 'char_2', 'varchar');
INSERT INTO sc_lims_dal.pcr_bom_field (field_id, "name", "type") VALUES(27, 'code', 'varchar');
INSERT INTO sc_lims_dal.pcr_bom_field (field_id, "name", "type") VALUES(30, 'num_1', 'double precision');
INSERT INTO sc_lims_dal.pcr_bom_field (field_id, "name", "type") VALUES(31, 'num_2', 'double precision');
INSERT INTO sc_lims_dal.pcr_bom_field (field_id, "name", "type") VALUES(32, 'num_3', 'double precision');
INSERT INTO sc_lims_dal.pcr_bom_field (field_id, "name", "type") VALUES(33, 'num_4', 'double precision');
INSERT INTO sc_lims_dal.pcr_bom_field (field_id, "name", "type") VALUES(34, 'num_5', 'double precision');
INSERT INTO sc_lims_dal.pcr_bom_field (field_id, "name", "type") VALUES(40, 'char_3', 'varchar');
INSERT INTO sc_lims_dal.pcr_bom_field (field_id, "name", "type") VALUES(41, 'char_4', 'varchar');
INSERT INTO sc_lims_dal.pcr_bom_field (field_id, "name", "type") VALUES(42, 'char_5', 'varchar');
INSERT INTO sc_lims_dal.pcr_bom_field (field_id, "name", "type") VALUES(50, 'boolean_1', 'boolean');
INSERT INTO sc_lims_dal.pcr_bom_field (field_id, "name", "type") VALUES(51, 'boolean_2', 'boolean');
INSERT INTO sc_lims_dal.pcr_bom_field (field_id, "name", "type") VALUES(52, 'boolean_3', 'boolean');
INSERT INTO sc_lims_dal.pcr_bom_field (field_id, "name", "type") VALUES(53, 'boolean_4', 'boolean');
INSERT INTO sc_lims_dal.pcr_bom_field (field_id, "name", "type") VALUES(60, 'date_1', 'timestamp');
INSERT INTO sc_lims_dal.pcr_bom_field (field_id, "name", "type") VALUES(61, 'date_2', 'timestamp');
INSERT INTO sc_lims_dal.pcr_bom_field (field_id, "name", "type") VALUES(70, 'characteristic_1', 'varchar');
INSERT INTO sc_lims_dal.pcr_bom_field (field_id, "name", "type") VALUES(71, 'characteristic_2', 'varchar');
INSERT INTO sc_lims_dal.pcr_bom_field (field_id, "name", "type") VALUES(72, 'characteristic_3', 'varchar');

COMMIT;

select count(*) from sc_lims_dal.pcr_bom_field;

--einde script


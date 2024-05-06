INSERT INTO sc_lims_dal.pcr_property_field (field_id, "name", "type") VALUES(1, 'num_1', 'double precision');
INSERT INTO sc_lims_dal.pcr_property_field (field_id, "name", "type") VALUES(2, 'num_2', 'double precision');
INSERT INTO sc_lims_dal.pcr_property_field (field_id, "name", "type") VALUES(3, 'num_3', 'double precision');
INSERT INTO sc_lims_dal.pcr_property_field (field_id, "name", "type") VALUES(4, 'num_4', 'double precision');
INSERT INTO sc_lims_dal.pcr_property_field (field_id, "name", "type") VALUES(5, 'num_5', 'double precision');
INSERT INTO sc_lims_dal.pcr_property_field (field_id, "name", "type") VALUES(6, 'num_6', 'double precision');
INSERT INTO sc_lims_dal.pcr_property_field (field_id, "name", "type") VALUES(7, 'num_7', 'double precision');
INSERT INTO sc_lims_dal.pcr_property_field (field_id, "name", "type") VALUES(8, 'num_8', 'double precision');
INSERT INTO sc_lims_dal.pcr_property_field (field_id, "name", "type") VALUES(9, 'num_9', 'double precision');
INSERT INTO sc_lims_dal.pcr_property_field (field_id, "name", "type") VALUES(10, 'num_10', 'double precision');
INSERT INTO sc_lims_dal.pcr_property_field (field_id, "name", "type") VALUES(17, 'boolean_1', 'char');
INSERT INTO sc_lims_dal.pcr_property_field (field_id, "name", "type") VALUES(18, 'boolean_2', 'char');
INSERT INTO sc_lims_dal.pcr_property_field (field_id, "name", "type") VALUES(19, 'boolean_3', 'char');
INSERT INTO sc_lims_dal.pcr_property_field (field_id, "name", "type") VALUES(20, 'boolean_4', 'char');
INSERT INTO sc_lims_dal.pcr_property_field (field_id, "name", "type") VALUES(21, 'date_1', 'timestamp');
INSERT INTO sc_lims_dal.pcr_property_field (field_id, "name", "type") VALUES(22, 'date_2', 'timestamp');
INSERT INTO sc_lims_dal.pcr_property_field (field_id, "name", "type") VALUES(32, 'tm_det_1', 'char');
INSERT INTO sc_lims_dal.pcr_property_field (field_id, "name", "type") VALUES(33, 'tm_det_2', 'char');
INSERT INTO sc_lims_dal.pcr_property_field (field_id, "name", "type") VALUES(34, 'tm_det_3', 'char');
INSERT INTO sc_lims_dal.pcr_property_field (field_id, "name", "type") VALUES(35, 'tm_det_4', 'char');
INSERT INTO sc_lims_dal.pcr_property_field (field_id, "name", "type") VALUES(11, 'char_1', 'varchar');
INSERT INTO sc_lims_dal.pcr_property_field (field_id, "name", "type") VALUES(12, 'char_2', 'varchar');
INSERT INTO sc_lims_dal.pcr_property_field (field_id, "name", "type") VALUES(13, 'char_3', 'varchar');
INSERT INTO sc_lims_dal.pcr_property_field (field_id, "name", "type") VALUES(14, 'char_4', 'varchar');
INSERT INTO sc_lims_dal.pcr_property_field (field_id, "name", "type") VALUES(15, 'char_5', 'varchar');
INSERT INTO sc_lims_dal.pcr_property_field (field_id, "name", "type") VALUES(16, 'char_6', 'varchar');
INSERT INTO sc_lims_dal.pcr_property_field (field_id, "name", "type") VALUES(23, 'uom', 'varchar');
INSERT INTO sc_lims_dal.pcr_property_field (field_id, "name", "type") VALUES(24, 'attribute', 'numeric');
INSERT INTO sc_lims_dal.pcr_property_field (field_id, "name", "type") VALUES(25, 'test_method_1', 'varchar');
INSERT INTO sc_lims_dal.pcr_property_field (field_id, "name", "type") VALUES(26, 'characteristic_1', 'varchar');
INSERT INTO sc_lims_dal.pcr_property_field (field_id, "name", "type") VALUES(27, 'property_1', 'varchar');
INSERT INTO sc_lims_dal.pcr_property_field (field_id, "name", "type") VALUES(30, 'characteristic_2', 'varchar');
INSERT INTO sc_lims_dal.pcr_property_field (field_id, "name", "type") VALUES(31, 'characteristic_3', 'varchar');
INSERT INTO sc_lims_dal.pcr_property_field (field_id, "name", "type") VALUES(40, 'info', 'varchar');

commit;

select count(*) from sc_lims_dal.pcr_property_field;

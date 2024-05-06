INSERT INTO sc_lims_dal.pcr_section_type ("type", table_name, ref_id, ref_ver) VALUES(1, 'property_group', 'property_group', NULL);
INSERT INTO sc_lims_dal.pcr_section_type ("type", table_name, ref_id, ref_ver) VALUES(3, 'bom_header', NULL, NULL);
INSERT INTO sc_lims_dal.pcr_section_type ("type", table_name, ref_id, ref_ver) VALUES(4, 'property', 'property', NULL);
INSERT INTO sc_lims_dal.pcr_section_type ("type", table_name, ref_id, ref_ver) VALUES(8, 'attached_specification', 'ref_id', NULL);
INSERT INTO sc_lims_dal.pcr_section_type ("type", table_name, ref_id, ref_ver) VALUES(6, 'itoid', 'ref_id', NULL);

commit;

select count(*) from sc_lims_dal.pcr_section_type;


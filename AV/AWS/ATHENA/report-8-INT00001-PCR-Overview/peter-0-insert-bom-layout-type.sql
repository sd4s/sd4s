INSERT INTO sc_lims_dal.pcr_bom_layout_type ("type", table_name) VALUES(2, 'bom_item');
INSERT INTO sc_lims_dal.pcr_bom_layout_type ("type", table_name) VALUES(3, 'bom_header');

commit;

select count(*) from sc_lims_dal.pcr_bom_layout_type;

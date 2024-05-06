INSERT INTO sc_lims_dal.pcr_function_conversion ("function", bom_function) VALUES('Tyre vulcanized', 'Vulcanized tyre');

commit;

select count(*) from sc_lims_dal.pcr_function_conversion;

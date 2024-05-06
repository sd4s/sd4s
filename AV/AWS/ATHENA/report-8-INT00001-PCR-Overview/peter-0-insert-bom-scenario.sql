INSERT INTO sc_lims_dal.pcr_bom_scenario (scenario, description) VALUES('CURRENT', 'Explode on CURRENT revision of all components.');
INSERT INTO sc_lims_dal.pcr_bom_scenario (scenario, description) VALUES('HIGHEST', 'Explode on HIGHEST revision of all components.');
INSERT INTO sc_lims_dal.pcr_bom_scenario (scenario, description) VALUES('REFDATE', 'Explode on revision valid at a given date.');


commit;

select count(*) from sc_lims_dal.pcr_bom_scenario;

INSERT INTO sc_lims_dal.pcr_internal_status (status, code) VALUES(1, 'DEVELOPMENT');
INSERT INTO sc_lims_dal.pcr_internal_status (status, code) VALUES(2, 'SUBMIT');
INSERT INTO sc_lims_dal.pcr_internal_status (status, code) VALUES(3, 'APPROVED');
INSERT INTO sc_lims_dal.pcr_internal_status (status, code) VALUES(4, 'CURRENT');
INSERT INTO sc_lims_dal.pcr_internal_status (status, code) VALUES(5, 'HISTORIC');
INSERT INTO sc_lims_dal.pcr_internal_status (status, code) VALUES(6, 'OBSOLETE');
INSERT INTO sc_lims_dal.pcr_internal_status (status, code) VALUES(7, 'REJECTED');

commit;

select count(*) from sc_lims_dal.pcr_internal_status;

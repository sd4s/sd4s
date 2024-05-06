--My own ADMIN-user:  usr_eu_lims_dl_admin   (PROD-environment)
--                    lims_dev_user          (TEST-environment)

--grant hele schema:
grant all on schema sc_lims_dal to usr_peter_s;
grant all on schema sc_lims_dal to usr_rna_readonly1;

--of 1 view/tabel:
--peter:
grant all on av_reqovtest_partno_properties to usr_peter_s;
--power-BI-team:
grant all on av_reqovtest_partno_properties to usr_rna_readonly1;
grant all on av_requestoverviewresults_set  to usr_rna_readonly1;


--einde screipt

--find all users in DB

select * from pg_user
;


/*
usename	usesysid		usecreatedb	usesuper	usecatupd	passwd	valuntil	useconfig
atl_dl_prd_admin		100	true	true	false	********	[NULL]	NULL
atl_dl_prd_admin_backup	110	false	true	false	********	[NULL]	NULL
rdsdb					1	true	true	true	********	2038-01-19 03:14:04.0	NULL
usr_abullais_b			149	false	false	false	********	[NULL]	NULL
usr_aesha_meghani		167	false	false	false	********	[NULL]	NULL
usr_akash_deep			150	false	false	false	********	[NULL]	NULL
usr_ames_etl_admin		127	false	false	false	********	[NULL]	NULL
usr_andre_louis			183	false	false	false	********	[NULL]	NULL
usr_attila_krizsan		161	false	false	false	********	[NULL]	NULL
usr_attila_solymosi		128	false	false	false	********	[NULL]	NULL
usr_attila_tamas		170	false	false	false	********	[NULL]	NULL
usr_aurelija_norbutiene	172	false	false	false	********	[NULL]	NULL
usr_cfa_admin			124	false	false	false	********	[NULL]	NULL
usr_charles_bors		173	false	false	false	********	[NULL]	NULL
usr_che_mixer_readonly	112	false	false	false	********	[NULL]	NULL
usr_dbdevcimtbr			105	false	false	false	********	[NULL]	NULL
usr_dbdevmix			101	false	false	false	********	[NULL]	NULL
usr_dbview				102	false	false	false	********	[NULL]	NULL
usr_deniz_toz			147	false	false	false	********	[NULL]	NULL
usr_edo_belva			122	false	false	false	********	[NULL]	NULL
usr_eelco_verhulp		179	false	false	false	********	[NULL]	NULL
usr_ens_readonly		157	false	false	false	********	[NULL]	NULL
usr_etl_admin			107	false	false	false	********	[NULL]	NULL
usr_eu_attila_tamas		141	false	false	false	********	[NULL]	NULL
usr_eu_lims_dl_admin	119	false	false	false	********	[NULL]	{"search_path=sc_lims_dal_ai, sc_lims_dal, sc_interspec_ens, sc_unilab_ens, \"$user\", public"}
usr_eu_mkt_nicolas		139	false	false	false	********	[NULL]	NULL
usr_eu_rnd_student1		180	false	false	false	********	[NULL]	NULL
usr_eu_roland_farkas	143	false	false	false	********	[NULL]	NULL
usr_eu_yashkumar_patel	142	false	false	false	********	[NULL]	NULL
usr_fea_simulation		171	false	false	false	********	[NULL]	NULL
usr_gerald_voorpostel	176	false	false	false	********	[NULL]	NULL
usr_harika_chedudhup	154	false	false	false	********	[NULL]	NULL
usr_iot_mfg_db_admin	113	false	false	false	********	[NULL]	NULL
usr_iotdbview			103	false	false	false	********	[NULL]	NULL
usr_iotpbiview			106	false	false	false	********	[NULL]	NULL
usr_izaak_boot			166	false	false	false	********	[NULL]	NULL
usr_kavya_pitchika		155	false	false	false	********	[NULL]	NULL
usr_lakshminarasimhan_s	152	false	false	false	********	[NULL]	NULL
usr_lim_readonly		116	false	false	false	********	[NULL]	NULL
usr_liniker_desousa		175	false	false	false	********	[NULL]	NULL
usr_maarten_grooteschaarsberg	178	false	false	false	********	[NULL]	NULL
usr_manikandan_rathinavel	132	false	false	false	********	[NULL]	NULL
usr_martijn_haar		165	false	false	false	********	[NULL]	NULL
usr_martin_csaki		160	false	false	false	********	[NULL]	NULL
usr_mfg_advds1			162	false	false	false	********	[NULL]	NULL
usr_mfg_m_maheswaran	137	false	false	false	********	[NULL]	NULL
usr_mfg_thiyagarajan_r	136	false	false	false	********	[NULL]	NULL
usr_ml_andre			118	false	false	false	********	[NULL]	NULL
usr_ml_maksim			138	false	false	false	********	[NULL]	NULL
usr_ml_mithun			114	false	false	false	********	[NULL]	NULL
usr_ml_sofia			126	false	false	false	********	[NULL]	NULL
usr_patrick_g			120	false	false	false	********	[NULL]	NULL
usr_per_readonly		159	false	false	false	********	[NULL]	NULL
usr_peter_imre			145	false	false	false	********	[NULL]	NULL
usr_peter_s				121	false	false	false	********	[NULL]	NULL
usr_phanirajt_k			153	false	false	false	********	[NULL]	NULL
usr_plant_gyo_reader	108	false	false	false	********	[NULL]	NULL
usr_pranjali_pandya		168	false	false	false	********	[NULL]	NULL
usr_r_vinoth			144	false	false	false	********	[NULL]	NULL
usr_rick_hobert			182	false	false	false	********	[NULL]	NULL
usr_rna_power_user		163	false	false	false	********	[NULL]	NULL
usr_rna_readonly1		135	false	false	false	********	[NULL]	NULL
usr_rrc_readonly		125	false	false	false	********	[NULL]	NULL
usr_rutger_damink		177	false	false	false	********	[NULL]	NULL
usr_sabbavarapu_madhu	146	false	false	false	********	[NULL]	NULL
usr_sami_sahin			174	false	false	false	********	[NULL]	NULL
usr_saravanan_nagarajan	130	false	false	false	********	[NULL]	NULL
usr_saravanan_paramasivam	131	false	false	false	********	[NULL]	NULL
usr_scm_admin			104	false	false	false	********	[NULL]	NULL
usr_scm_readonly		117	false	false	false	********	[NULL]	NULL
usr_shibu_george		133	false	false	false	********	[NULL]	NULL
usr_shivani_dogne		169	false	false	false	********	[NULL]	NULL
usr_shivshankar_biswas	148	false	false	false	********	[NULL]	NULL
usr_shruti_bansal		156	false	false	false	********	[NULL]	NULL
usr_svetlana_stefanovic	181	false	false	false	********	[NULL]	NULL
usr_ures_readonly		115	false	false	false	********	[NULL]	NULL
usr_us_eu_pricing_readonly	129	false	false	false	********	[NULL]	NULL
usr_us_eu_pricing_scrapping	134	false	false	false	********	[NULL]	NULL
*/
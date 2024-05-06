--******************************************************************
--TOTAL-IMPLEMENTATION GRANT/ROLES FOR REDSHIFT-DB DB_DEV_LIMS
--******************************************************************

select current_user;
--redshif-DEV:
set session authorization awsuser;
--redshift-PROD:
set session authorization usr_etl_admin;
--
RESET SESSION AUTHORIZATION;
SHOW search_path; 
set search_path to 'sc_lims_dal_ai','sc_lims_dal','sc_interspec_ens','sc_unilab_ens','pg_catalog','information_schema','$user','public' ;
alter user awsuser set search_path to 'sc_lims_dal_ai', 'sc_lims_dal', 'sc_interspec_ens', 'sc_unilab_ens', 'pg_catalog','information_schema','$user','public';
alter user usr_etl_admin set search_path to 'sc_lims_dal_ai', 'sc_lims_dal', 'sc_interspec_ens', 'sc_unilab_ens', 'pg_catalog','information_schema','$user','public';

SHOW search_path; 

--grant privileges to LIMS_DEV_USER
--Only a superuser can specify default privileges for other users
--redshift-DEV
grant all on all tables in schema sc_interspec_ens to lims_dev_user with grant option;
grant all on all tables in schema sc_unilab_ens to lims_dev_user with grant option;
--redshift-PROD
grant all on all tables in schema sc_interspec_ens to usr_eu_lims_dl_admin with grant option;
grant all on all tables in schema sc_unilab_ens to usr_eu_lims_dl_admin with grant option;


select groname, grosysid, grolist from pg_group;
/*
grp_university_students	1447560	{"110","111","112"}
grp_ai_readonly			2052566	
grp_lims_readonly		2052567	
*/
--
--superuser AWSUSER create GROUPS
--
--redshift-DEV
create group grp_dal_ai_readonly;
create group grp_dal_readonly;
create group grp_lims_readonly;
create group grp_university_students;
--redshift-PROD
create group grp_dal_ai_readonly;
create group grp_dal_readonly;
create group grp_lims_readonly;


--ADD users to groups
--redshift-DEV
alter group grp_dal_ai_readonly add user usr_edo_belva;
alter group grp_dal_ai_readonly add user usr_peter_s;
alter group grp_dal_readonly add user usr_peter_s;
alter group grp_lims_readonly add user usr_peter_s;
alter group grp_university_students add user usr_stu_kaiqi, usr_stu_jesus, usr_stu_edo;
--redshift-PROD
alter group grp_dal_ai_readonly add user usr_edo_belva;
alter group grp_dal_ai_readonly add user usr_peter_s,usr_patrick_g;
alter group grp_dal_readonly add user usr_peter_s,usr_patrick_g;
alter group grp_lims_readonly add user usr_peter_s,usr_patrick_g;




/*
--
--superuser AWSUSER create ROLES
--
create role rol_ai_readonly ;
create role rol_dal_readonly ;
create role rol_lims_readonly ;
--AWSUSER grant role to LIMS_DEV_USER first !!!!
--grant rolE r_read_sc_lims_dal_ai to aidevusers;
conn awsuser/
grant role rol_ai_readonly to lims_dev_user WITH ADMIN option;
grant role rol_dal_readonly to lims_dev_user WITH ADMIN option;
grant role rol_lims_readonly to lims_dev_user WITH ADMIN option;

#--grant usage to ROLES
conn lims_dev_user/
grant usage on SCHEMA sc_lims_dal_ai,sc_lims_dal,sc_interspec_ens,sc_unilab_ens to ROLE rol_ai_readonly;
grant usage on SCHEMA sc_lims_dal_ai,sc_lims_dal,sc_interspec_ens,sc_unilab_ens to ROLE rol_dal_readonly;
grant usage on SCHEMA sc_lims_dal_ai,sc_lims_dal,sc_interspec_ens,sc_unilab_ens to ROLE rol_lims_readonly;
*/





--ERROR: permission denied for relation
--ALTER DEFAULT PRIVILEGES FOR USER schema_owning_user IN SCHEMA my_schema_name GRANT SELECT ON TABLES TO my_looker_user;
--ALTER DEFAULT PRIVILEGES FOR USER awsuser IN SCHEMA pg_catalog GRANT SELECT ON TABLES TO awsuser;


--Rest of grants of table-privileges done by user LIMS_DEV_USER !!!

--grant roles to USERS using the LIMS_DEV_USER:
--and grant roles to USER-GROUPS 
--
--grant TABLE privileges to ROLES
--grant SELECT-PRIVILEGE to role ROL_LIMS_READONLY;
--grant SELECT-PRIVILEGE to ROLE ROL_DAL_READONLY;
--grant SELECT-PRIVILEGE to ROLE ROL_AI_READONLY;



--end-of-script

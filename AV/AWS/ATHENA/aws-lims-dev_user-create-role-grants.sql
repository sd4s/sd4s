--******************************************************************
--TOTAL-IMPLEMENTATION GRANT/ROLES FOR REDSHIFT-DB DB_DEV_LIMS
--******************************************************************
select current_user;
set session authorization lims_dev_user;
SHOW search_path; 
set search_path to 'sc_lims_dal_ai','sc_lims_dal','sc_interspec_ens','sc_unilab_ens','pg_catalog','information_schema','$user','public' ;
alter user lims_dev_user set search_path to 'sc_lims_dal_ai', 'sc_lims_dal', 'sc_interspec_ens', 'sc_unilab_ens', 'public';
alter user usr_eu_lims_dl_admin set search_path to 'sc_lims_dal_ai', 'sc_lims_dal', 'sc_interspec_ens', 'sc_unilab_ens', '$user', 'public';

--
set search_path to 'sc_lims_dal_ai','sc_lims_dal','sc_interspec_ens','sc_unilab_ens','pg_catalog','information_schema','$user','public' ;
alter user usr_peter_s set search_path to 'sc_lims_dal_ai','sc_lims_dal','sc_interspec_ens','sc_unilab_ens','pg_catalog','information_schema','$user','public' ;

SHOW search_path; 

--******************************************************************
--grant SCHEMA-USAGE to GROUPS
--******************************************************************
select u.usename
,      s.schemaname
,      has_schema_privilege(u.usename,s.schemaname,'usage') as user_usage_permission
,      has_schema_privilege(u.usename,s.schemaname,'create') as user_create_permission
from pg_user u
cross join (select distinct schemaname from pg_tables) s 
WHERE s.schemaname like 'sc_%'
--AND u.usename = 'usr_peter_s' 
;
conn lims_dev_user/
grant usage on SCHEMA sc_lims_dal_ai,sc_lims_dal,sc_interspec_ens,sc_unilab_ens to GROUP grp_dal_ai_readonly;
grant usage on SCHEMA sc_lims_dal_ai,sc_lims_dal,sc_interspec_ens,sc_unilab_ens to GROUP grp_dal_readonly;
grant usage on SCHEMA sc_lims_dal_ai,sc_lims_dal,sc_interspec_ens,sc_unilab_ens to GROUP grp_lims_readonly;
grant usage on SCHEMA sc_lims_dal_ai,sc_lims_dal,sc_interspec_ens,sc_unilab_ens to GROUP grp_university_students;




--*************************************************************************
--REQUEST table-privileges for NORMAL USERS/GROUPS
--*************************************************************************
WITH tabledef as (
    SELECT schemaname,'t' AS typename,tablename AS objectname, tableowner as owner, schemaname + '.' + tablename AS fullname
    FROM pg_tables
    UNION 
    SELECT schemaname,'v' AS typename, viewname AS objectname, viewowner as owner,  schemaname + '.' + viewname AS fullname
    FROM pg_views
),
res AS (
    SELECT t.*,
    CASE HAS_TABLE_PRIVILEGE(u.usename, t.fullname, 'select')
    WHEN true THEN u.usename
    ELSE NULL END AS sel,
    CASE HAS_TABLE_PRIVILEGE(u.usename, t.fullname, 'insert')
    WHEN true THEN u.usename
    ELSE NULL END AS ins,
    CASE HAS_TABLE_PRIVILEGE(u.usename, t.fullname, 'update')
    WHEN true THEN u.usename
    ELSE NULL END AS upd,
    CASE HAS_TABLE_PRIVILEGE(u.usename, t.fullname, 'delete')
    WHEN true THEN u.usename
    ELSE NULL END AS del,
    CASE HAS_TABLE_PRIVILEGE(u.usename, t.fullname, 'references')
    WHEN true THEN u.usename
    ELSE NULL END AS ref
    FROM tabledef AS t
    JOIN pg_user AS u
    ON     HAS_TABLE_PRIVILEGE(u.usename, t.fullname, 'select') = true
        OR HAS_TABLE_PRIVILEGE(u.usename, t.fullname, 'insert') = true
        OR HAS_TABLE_PRIVILEGE(u.usename, t.fullname, 'update') = true
        OR HAS_TABLE_PRIVILEGE(u.usename, t.fullname, 'delete') = true
        OR HAS_TABLE_PRIVILEGE(u.usename, t.fullname, 'references') = true
        OR t.owner = u.usename
    WHERE t.schemaname IN ('sc_lims_dal_ai','sc_lims_dal','sc_interspec_ens','sc_unilab_ens')
)
SELECT schemaname, objectname, owner, sel, ins, upd, del, ref FROM res
WHERE sel not in ('rdsdb', 'awsuser' ,'usr_eu_container_track_app','lims_dev_user'  )
ORDER BY schemaname, objectname
;


CONN lims_dev_user/
GRANT SELECT ON ALL TABLES IN SCHEMA sc_interspec_ens,sc_unilab_ens to GROUP grp_lims_readonly ;
GRANT SELECT ON ALL TABLES IN SCHEMA sc_lims_dal to GROUP grp_dal_readonly ;
GRANT SELECT ON ALL TABLES IN SCHEMA sc_lims_dal_ai to GROUP grp_dal_ai_readonly ;
--GRANT SELECT ON ALL TABLES IN SCHEMA <???> to GROUP grp_university_students ;
GRANT SELECT ON ALL TABLES IN SCHEMA sc_lims_dal_self_service to GROUP grp_ens_lims_self_service_users ;



--grant TABLE privileges to GROUPS
--grant SELECT-PRIVILEGE to GROUP GRP_LIMS_READONLY;
--a GRANT SELECT to a group, results in a direct-grant-SELECT to a user in PG_USER/TABLEDEF, 
--and not to the GROUP itself !!!!
CONN lims_dev_user/
GRANT SELECT ON ALL TABLES IN SCHEMA sc_interspec_ens,sc_unilab_ens to GROUP grp_lims_readonly ;

--grant SELECT-PRIVILEGE to GROUP GRP_DAL_READONLY;
GRANT SELECT ON ALL TABLES IN SCHEMA sc_lims_dal to GROUP grp_dal_readonly ;
--OR seperate:
grant select on sc_lims_dal.frame to GROUP grp_dal_readonly;   
grant select on sc_lims_dal.frame_keyword to GROUP grp_dal_readonly;   
grant select on sc_lims_dal.method to GROUP grp_dal_readonly;   
grant select on sc_lims_dal.method_attributes to GROUP grp_dal_readonly;   
grant select on sc_lims_dal.method_cell to GROUP grp_dal_readonly;   
grant select on sc_lims_dal.method_data_time_info to GROUP grp_dal_readonly;   
grant select on sc_lims_dal.method_group_key to GROUP grp_dal_readonly;   
grant select on sc_lims_dal.method_history to GROUP grp_dal_readonly;   
grant select on sc_lims_dal.method_reanalysis to GROUP grp_dal_readonly;   
grant select on sc_lims_dal.parameter to GROUP grp_dal_readonly;   
grant select on sc_lims_dal.parameter_attributes to GROUP grp_dal_readonly;   
grant select on sc_lims_dal.parameter_data_time_info to GROUP grp_dal_readonly;   
grant select on sc_lims_dal.parameter_group to GROUP grp_dal_readonly;   
grant select on sc_lims_dal.parameter_group_attributes to GROUP grp_dal_readonly;   
grant select on sc_lims_dal.parameter_group_data_time_info to GROUP grp_dal_readonly;   
grant select on sc_lims_dal.parameter_history to GROUP grp_dal_readonly;   
grant select on sc_lims_dal.parameter_reanalysis to GROUP grp_dal_readonly;   
grant select on sc_lims_dal.parameter_specifications to GROUP grp_dal_readonly;   
grant select on sc_lims_dal.request to GROUP grp_dal_readonly;   
grant select on sc_lims_dal.request_attributes to GROUP grp_dal_readonly;   
grant select on sc_lims_dal.request_data_time_info to GROUP grp_dal_readonly;   
grant select on sc_lims_dal.request_group_key to GROUP grp_dal_readonly;
grant select on sc_lims_dal.request_history to GROUP grp_dal_readonly;
grant select on sc_lims_dal.request_info_card to GROUP grp_dal_readonly;
grant select on sc_lims_dal.request_info_field to GROUP grp_dal_readonly;
grant select on sc_lims_dal.sample to GROUP grp_dal_readonly;
grant select on sc_lims_dal.sample_attributes to GROUP grp_dal_readonly;
grant select on sc_lims_dal.sample_data_time_info to GROUP grp_dal_readonly;
grant select on sc_lims_dal.sample_group_key to GROUP grp_dal_readonly;
grant select on sc_lims_dal.sample_history to GROUP grp_dal_readonly;
grant select on sc_lims_dal.sample_info_card to GROUP grp_dal_readonly;
grant select on sc_lims_dal.sample_info_field to GROUP grp_dal_readonly;
grant select on sc_lims_dal.sample_part_no_groupkey to GROUP grp_dal_readonly;
grant select on sc_lims_dal.sample_part_no_info_card to GROUP grp_dal_readonly;
grant select on sc_lims_dal.spec_bom_item_current_tree to GROUP grp_dal_readonly;
grant select on sc_lims_dal.spec_part_manufacturer to GROUP grp_dal_readonly;
grant select on sc_lims_dal.spec_part_plant to GROUP grp_dal_readonly;
grant select on sc_lims_dal.specification to GROUP grp_dal_readonly;
grant select on sc_lims_dal.specification_bom_header to GROUP grp_dal_readonly;
grant select on sc_lims_dal.specification_bom_item to GROUP grp_dal_readonly;
grant select on sc_lims_dal.specification_bom_item_full to GROUP grp_dal_readonly;
grant select on sc_lims_dal.specification_classification to GROUP grp_dal_readonly;
grant select on sc_lims_dal.specification_data to GROUP grp_dal_readonly;
grant select on sc_lims_dal.specification_keyword to GROUP grp_dal_readonly;
grant select on sc_lims_dal.specification_part to GROUP grp_dal_readonly;
grant select on sc_lims_dal.specification_property to GROUP grp_dal_readonly;
grant select on sc_lims_dal.specification_section to GROUP grp_dal_readonly;

--grant SELECT-PRIVILEGE to  GROUP  GRP_DAL_AI_READONLY;
GRANT SELECT ON ALL TABLES IN SCHEMA sc_lims_dal_ai to GROUP grp_dal_ai_readonly ;
--
grant SELECT on sc_lims_dal_ai.ai_method to GROUP GRP_DAL_AI_READONLY;
grant SELECT on sc_lims_dal_ai.ai_method_cell to GROUP GRP_DAL_AI_READONLY;
grant SELECT on sc_lims_dal_ai.ai_sample to GROUP GRP_DAL_AI_READONLY;
grant SELECT on sc_lims_dal_ai.ai_sample_part_no_groupkey to GROUP GRP_DAL_AI_READONLY;
grant SELECT on sc_lims_dal_ai.ai_spec_bom_item_current_tree to GROUP GRP_DAL_AI_READONLY;
grant SELECT on sc_lims_dal_ai.ai_specification to GROUP GRP_DAL_AI_READONLY;
grant SELECT on sc_lims_dal_ai.ai_specification_bom_header to GROUP GRP_DAL_AI_READONLY;
grant SELECT on sc_lims_dal_ai.ai_specification_bom_item to GROUP GRP_DAL_AI_READONLY;
grant SELECT on sc_lims_dal_ai.ai_specification_bom_item_full to GROUP GRP_DAL_AI_READONLY;
grant SELECT on sc_lims_dal_ai.ai_specification_data to GROUP GRP_DAL_AI_READONLY;
grant SELECT on sc_lims_dal_ai.ai_specification_property to GROUP GRP_DAL_AI_READONLY;

--end-of-script







/*
--grant ROLES TO USERS by using LIMS_DEV_USER
--TIP: THIS ISN'T WORKING IN REDSHIFT IN A CORRECT WAY !!!! SO YOU GROUPS INSTEAD !!!!!!
--
conn lims_dev_user/
GRANT ROLE rol_ai_readonly   TO usr_edo_belva;
GRANT ROLE rol_ai_readonly   TO usr_peter_s;
GRANT ROLE rol_dal_readonly  TO usr_peter_s;
GRANT ROLE rol_lims_readonly TO usr_peter_s;
--evt. grant rollen aan USER-GROUPS 
GRANT ROLE rol_ai_readonly   TO GROUP grp_university_students;

--
--grant TABLE privileges to ROLES
--grant SELECT-PRIVILEGE to role ROL_LIMS_READONLY;
CONN lims_dev_user/
GRANT SELECT ON ALL TABLES IN SCHEMA sc_interspec_ens,sc_unilab_ens to ROLE rol_lims_readonly ;

--grant SELECT-PRIVILEGE to ROLE ROL_DAL_READONLY;
grant select on sc_lims_dal.frame to ROLE rol_dal_readonly;   
grant select on sc_lims_dal.frame_keyword to ROLE rol_dal_readonly;   
grant select on sc_lims_dal.method to ROLE rol_dal_readonly;   
grant select on sc_lims_dal.method_attributes to ROLE rol_dal_readonly;   
grant select on sc_lims_dal.method_cell to ROLE rol_dal_readonly;   
grant select on sc_lims_dal.method_data_time_info to ROLE rol_dal_readonly;   
grant select on sc_lims_dal.method_group_key to ROLE rol_dal_readonly;   
grant select on sc_lims_dal.method_history to ROLE rol_dal_readonly;   
grant select on sc_lims_dal.method_reanalysis to ROLE rol_dal_readonly;   
grant select on sc_lims_dal.parameter to ROLE rol_dal_readonly;   
grant select on sc_lims_dal.parameter_attributes to ROLE rol_dal_readonly;   
grant select on sc_lims_dal.parameter_data_time_info to ROLE rol_dal_readonly;   
grant select on sc_lims_dal.parameter_group to ROLE rol_dal_readonly;   
grant select on sc_lims_dal.parameter_group_attributes to ROLE rol_dal_readonly;   
grant select on sc_lims_dal.parameter_group_data_time_info to ROLE rol_dal_readonly;   
grant select on sc_lims_dal.parameter_history to ROLE rol_dal_readonly;   
grant select on sc_lims_dal.parameter_reanalysis to ROLE rol_dal_readonly;   
grant select on sc_lims_dal.parameter_specifications to ROLE rol_dal_readonly;   
grant select on sc_lims_dal.request to ROLE rol_dal_readonly;   
grant select on sc_lims_dal.request_attributes to ROLE rol_dal_readonly;   
grant select on sc_lims_dal.request_data_time_info to ROLE rol_dal_readonly;   
grant select on sc_lims_dal.request_group_key to ROLE rol_dal_readonly;
grant select on sc_lims_dal.request_history to ROLE rol_dal_readonly;
grant select on sc_lims_dal.request_info_card to ROLE rol_dal_readonly;
grant select on sc_lims_dal.request_info_field to ROLE rol_dal_readonly;
grant select on sc_lims_dal.sample to ROLE rol_dal_readonly;
grant select on sc_lims_dal.sample_attributes to ROLE rol_dal_readonly;
grant select on sc_lims_dal.sample_data_time_info to ROLE rol_dal_readonly;
grant select on sc_lims_dal.sample_group_key to ROLE rol_dal_readonly;
grant select on sc_lims_dal.sample_history to ROLE rol_dal_readonly;
grant select on sc_lims_dal.sample_info_card to ROLE rol_dal_readonly;
grant select on sc_lims_dal.sample_info_field to ROLE rol_dal_readonly;
grant select on sc_lims_dal.sample_part_no_groupkey to ROLE rol_dal_readonly;
grant select on sc_lims_dal.sample_part_no_info_card to ROLE rol_dal_readonly;
grant select on sc_lims_dal.spec_bom_item_current_tree to ROLE rol_dal_readonly;
grant select on sc_lims_dal.spec_part_manufacturer to ROLE rol_dal_readonly;
grant select on sc_lims_dal.spec_part_plant to ROLE rol_dal_readonly;
grant select on sc_lims_dal.specification to ROLE rol_dal_readonly;
grant select on sc_lims_dal.specification_bom_header to ROLE rol_dal_readonly;
grant select on sc_lims_dal.specification_bom_item to ROLE rol_dal_readonly;
grant select on sc_lims_dal.specification_bom_item_full to ROLE rol_dal_readonly;
grant select on sc_lims_dal.specification_classification to ROLE rol_dal_readonly;
grant select on sc_lims_dal.specification_data to ROLE rol_dal_readonly;
grant select on sc_lims_dal.specification_keyword to ROLE rol_dal_readonly;
grant select on sc_lims_dal.specification_part to ROLE rol_dal_readonly;
grant select on sc_lims_dal.specification_property to ROLE rol_dal_readonly;
grant select on sc_lims_dal.specification_section to ROLE rol_dal_readonly;

--grant SELECT-PRIVILEGE to ROLE ROL_AI_READONLY;
grant SELECT on sc_lims_dal_ai.ai_method to ROLE rol_ai_readonly;
grant SELECT on sc_lims_dal_ai.ai_method_cell to ROLE rol_ai_readonly;
grant SELECT on sc_lims_dal_ai.ai_sample to ROLE rol_ai_readonly;
grant SELECT on sc_lims_dal_ai.ai_sample_part_no_groupkey to ROLE rol_ai_readonly;
grant SELECT on sc_lims_dal_ai.ai_spec_bom_item_current_tree to ROLE rol_ai_readonly;
grant SELECT on sc_lims_dal_ai.ai_specification to ROLE rol_ai_readonly;
grant SELECT on sc_lims_dal_ai.ai_specification_bom_header to ROLE rol_ai_readonly;
grant SELECT on sc_lims_dal_ai.ai_specification_bom_item to ROLE rol_ai_readonly;
grant SELECT on sc_lims_dal_ai.ai_specification_bom_item_full to ROLE rol_ai_readonly;
grant SELECT on sc_lims_dal_ai.ai_specification_data to ROLE rol_ai_readonly;
grant SELECT on sc_lims_dal_ai.ai_specification_property to ROLE rol_ai_readonly;
*/


--*************************************************************
--*************************************************************
-- grant view access to USERS
--*************************************************************
--*************************************************************
/*
grant select on sc_lims_dal.av_reqov_req_specheader to usr_rna_readonly1;
grant select on sc_lims_dal.av_reqov_request_history_trail to usr_rna_readonly1;

*


--end-of-script

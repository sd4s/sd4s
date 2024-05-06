--find users / groups granted for a specific TABLE/VIEW

--STILL UNDER CONSTRUCTION... THIS SCRIPT IS ONLY TEMPORARILY SETUP... IS NOT COMPLETE
--NOT ABLE TO FIND ALL USERS/ROLES FOR A VIEW/TABLE.......



--CATALOG-views
select schemaname, viewname
FROM pg_views
WHERE VIEWName LIKE '%grant%'
;
information_schema	role_column_grants
information_schema	role_routine_grants
information_schema	role_table_grants
information_schema	role_usage_grants
pg_catalog	svv_role_grants
pg_catalog	svv_user_grants



--
select schemaname, viewname
FROM pg_views 
where viewname like 'specification_section' ;
--sc_lims_dal	specification_section	usr_eu_lims_dl_admin



SELECT u.usename
,      gr.groname 
FROM pg_user u
,    pg_group gr
WHERE u.usesysid = ANY(gr.grolist)
AND gr.groname in (SELECT DISTINCT gr2.groname from pg_group gr2 where gr2.groname = 'grp_ens_lims_self_service_users' )
ORDER by u.usename
,        gr.groname;

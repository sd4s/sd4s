--find table-owner from table

select schemaname, tablename, tableowner From pg_tables ;

select schemaname, viewname, viewowner from pg_views;
select schemaname,  viewname, viewowner From pg_views where viewname like 'av_mlts_templates' ;
--sc_lims_dal	av_mlts_templates	atl_dl_prd_admin


select schemaname,  viewname, viewowner From pg_views where schemaname like 'sc_lims_dal' ;

select schemaname,  viewowner, count(*)  From pg_views group by schemaname, viewowner;
schemaname			viewowner					count
sc_lims_dal			usr_eu_lims_dl_admin		110
sc_lims_dal_ai		usr_eu_lims_dl_admin		19	
pg_catalog			rdsdb						722
pg_automv			rdsdb						6
sc_lims_dal			atl_dl_prd_admin			4
information_schema	rdsdb						34


select schemaname,  viewname, viewowner From pg_views where schemaname like 'sc_lims_dal' and viewowner like 'atl%';
sc_lims_dal	av_reqovtest_parameterresults	atl_dl_prd_admin
sc_lims_dal	av_reqovtest_resultsmethod		atl_dl_prd_admin
sc_lims_dal	av_requestoverviewresults		atl_dl_prd_admin
sc_lims_dal	av_mlts_templates				atl_dl_prd_admin

--CHANGE THE VIEW-OWNER:
ALTER VIEW sc_lims_dal.av_mlts_templates             owner TO usr_eu_lims_dl_admin;
ALTER VIEW sc_lims_dal.av_reqovtest_parameterresults owner TO usr_eu_lims_dl_admin;
ALTER VIEW sc_lims_dal.av_reqovtest_resultsmethod    owner TO usr_eu_lims_dl_admin;
ALTER VIEW sc_lims_dal.av_requestoverviewresults     owner TO usr_eu_lims_dl_admin;


--
SELECT n.nspname AS schema_name
 , pg_get_userbyid(c.relowner) AS table_owner
 , c.relname AS table_name
 , CASE WHEN c.relkind = 'v' THEN 'view' ELSE 'table' END 
   AS table_type
 , d.description AS table_description
 FROM pg_class As c
 LEFT JOIN pg_namespace n ON n.oid = c.relnamespace
 LEFT JOIN pg_tablespace t ON t.oid = c.reltablespace
 LEFT JOIN pg_description As d 
      ON (d.objoid = c.oid AND d.objsubid = 0)
 WHERE c.relkind IN('r', 'v') 
ORDER BY n.nspname, c.relname ;


--einde script

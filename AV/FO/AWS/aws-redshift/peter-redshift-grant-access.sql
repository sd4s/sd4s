--https://aws.amazon.com/premiumsupport/knowledge-center/redshift-grant-permissions-new-objects/
--
--How can I grant permissions to newly created objects in Amazon Redshift?
--Last updated: 2022-10-13
--My user received a permission denied error for a newly created object. How do I grant the user the required permissions to access newly created objects in the schema?
--Short description
--For a user to access newly created objects in the schema, privileges must be granted to the objects by a superuser.
--When a user isn’t able to access newly created objects in the schema, they might receive the following error:
--ERROR: permission denied for relation “objectname”.
--This error happens when access is granted for only the current objects present in a schema when the access was granted. By default, access isn’t automatically granted on future objects that are created under the schema.
--
--USAGE
--Grants USAGE privilege on a specific schema, which makes objects in that schema accessible to users. 
--Specific actions on these objects must be granted separately (for example, SELECT or UPDATE privileges on tables). 
--By default, all users have CREATE and USAGE privileges on the PUBLIC schema.
--
--To resolve this issue, grant access privileges to the user using the ALTER DEFAULT PRIVILEGES command.
--Resolution
--To grant permissions for the current and future tables in the schema, do the following as a superuser:
--1.    To grant usage access on the schema and SELECT access on all tables currently present under the schema, run the following commands:
--      Note: Replace newtestschema with the name of your schema and newtestuser with the name of the user.
--grant usage on schema newtestschema to newtestuser;
--grant select on all tables in schema newtestschema to newtestuser;



show table pg_catalog.pg_user;
/*
CREATE TABLE pg_catalog.pg_user (
    usename name ENCODE raw,
    usesysid integer ENCODE raw,
    usecreatedb boolean ENCODE raw,
    usesuper boolean ENCODE raw,
    usecatupd boolean ENCODE raw,
    passwd character varying(8) ENCODE raw,
    valuntil abstime ENCODE raw,
    useconfig text[] ENCODE raw
)
DISTSTYLE EVEN;
*/
show table pg_catalog.pg_tables;
/*
CREATE TABLE pg_catalog.pg_tables (
    schemaname name ENCODE raw,
    tablename name ENCODE raw,
    tableowner name ENCODE raw,
    tablespace name ENCODE raw,
    hasindexes boolean ENCODE raw,
    hasrules boolean ENCODE raw,
    hastriggers boolean ENCODE raw
)
DISTSTYLE EVEN;
*/
show table pg_catalog.pg_permissions;
/*
CREATE TABLE pg_catalog.pg_permission (
    permid oid NOT NULL ENCODE raw,
    dbid oid NOT NULL ENCODE raw,
    objtype oid NOT NULL ENCODE raw,
    objid oid NOT NULL ENCODE raw,
    objsubid integer NOT NULL ENCODE az64,
    privtype smallint NOT NULL ENCODE az64,
    privid oid NOT NULL ENCODE raw
)
DISTSTYLE EVEN;
*/

select has_schema_privilege('usr_peter_s', 'sc_lims_dal_ai', 'usage');
select has_table_privilege('usr_peter_s', 'sc_lims_dal_ai.ai_method', 'select');
--true


--USERS mogen wel USAGE maar geen SELECT-RECHTEN OP SCHEMA krijgen.
--Deze rechten krijgen ze via afzonderlijke SELECT-grants via ROLE...
select u.usename
,      s.schemaname
,      has_schema_privilege(u.usename,s.schemaname,'usage') as user_usage_permission
,      has_schema_privilege(u.usename,s.schemaname,'create') as user_create_permission
from pg_user u
cross join (select distinct schemaname from pg_tables) s 
WHERE u.usename = 'usr_peter_s' and s.schemaname like 'sc%'
;
/*
--prod
usr_peter_s	sc_interspec_ens	false
usr_peter_s	sc_unilab_ens		false
usr_peter_s	sc_lims_dal			true
usr_peter_s	sc_unilab_ens		false
*/
select u.usename
,      s.schemaname
,      has_schema_privilege(u.usename,s.schemaname,'usage') as user_usage_permission
,      has_schema_privilege(u.usename,s.schemaname,'create') as user_create_permission
from pg_user u
cross join (select distinct schemaname from pg_tables) s 
WHERE u.usename = 'lims_dev_user' and s.schemaname like 'sc%'
;

--
Similarly, to view the permissions of a specific user on a specific table, simply change the bold user name and table name to the user and table of interest on the following code. For a full list of every user - table permission status, simply delete the entire WHERE clause.

SELECT DISTINCT u.usename
,      t.schemaname||'.'||t.tablename
,      has_table_privilege(u.usename,t.tablename,'select') AS user_has_select_permission
,      has_table_privilege(u.usename,t.tablename,'insert') AS user_has_insert_permission
,      has_table_privilege(u.usename,t.tablename,'update') AS user_has_update_permission
,      has_table_privilege(u.usename,t.tablename,'delete') AS user_has_delete_permission
,      has_table_privilege(u.usename,t.tablename,'references') AS user_has_references_permission
FROM pg_user u
CROSS JOIN pg_tables t
WHERE u.usename = 'usr_peter_s'
--AND   t.tablename = 'frame'
and   t.schemaname like 'sc%'
;

/*
select * from pg_user;
usename			usesysid	usecreatedb	usesuper	usecatupd 	passwd		valuntil	useconfig
lims_dev_user	101			false		false		false		********				{"search_path=sc_lims_dal_ai, sc_lims_dal, sc_interspec_ens, sc_unilab_ens, public"}
usr_peter_s	    117			false		false		false		********				{"search_path=sc_lims_dal_ai, sc_lims_dal, sc_interspec_ens, sc_unilab_ens, public"}
*/

/*
SELECT * FROM PG_NAMESPACE;
nspname				nspowner	nspad
--sc_lims_dal_ai	101			{"lims_dev_user=U*C*/lims_dev_user","usr_edo_belva=U/lims_dev_user","usr_peter_s=U/lims_dev_user"}  
--sc_interspec_ens	100			{"awsuser=UC/awsuser","lims_dev_user=U*C*/awsuser","lims_report_user=U/awsuser","usr_edo_belva=U/awsuser","usr_peter_s=U/lims_dev_user"}
--sc_unilab_ens		100			{"awsuser=UC/awsuser","lims_dev_user=U*C*/awsuser","lims_report_user=U/awsuser","usr_edo_belva=U/awsuser","usr_ml_andre=U/awsuser","usr_peter_s=U/lims_dev_user"}
--sc_lims_dal		101			{"lims_dev_user=U*C*/lims_dev_user"}
--"
*/

DROP VIEW sc_lims_dal.view_all_grants ;
CREATE OR REPLACE VIEW sc_lims_dal.view_all_grants 
AS 
SELECT use.usename as subject
,      nsp.nspname as namespace
,      c.relowner
,      c.relname as item
,      c.relkind as type
,      use2.usename as owner
,      c.relacl 
-- , (use2.usename != use.usename and c.relacl::text !~ ('({|,)' || use.usename || '=')) as public
FROM  pg_user use 
cross join pg_class c 
left join pg_namespace nsp on (c.relnamespace = nsp.oid) 
left join pg_user use2 on (c.relowner = use2.usesysid)
WHERE c.relowner = use.usesysid 
-- or c.relacl::text ~ ('({|,)(|' || use.usename || ')=') 
ORDER BY subject
,        namespace
,        item 
;

select current_schema();
select * from sc_lims_dal.view_all_grants where namespace='sc_lims_dal_ai';
select * from sc_lims_dal.view_all_grants where subject='usr_peter_s';

/*
lims_dev_user	sc_lims_dal_ai	ai_method						v	lims_dev_user	{"lims_dev_user=arwdRxtD/lims_dev_user","usr_edo_belva=r/lims_dev_user","usr_peter_s=r/lims_dev_user"}
lims_dev_user	sc_lims_dal_ai	ai_method_cell					v	lims_dev_user	{"lims_dev_user=arwdRxtD/lims_dev_user","usr_edo_belva=r/lims_dev_user","usr_peter_s=r/lims_dev_user"}
lims_dev_user	sc_lims_dal_ai	ai_sample						v	lims_dev_user	{"lims_dev_user=arwdRxtD/lims_dev_user","usr_edo_belva=r/lims_dev_user","usr_peter_s=r/lims_dev_user"}
lims_dev_user	sc_lims_dal_ai	ai_sample_part_no_groupkey		v	lims_dev_user	{"lims_dev_user=arwdRxtD/lims_dev_user","usr_edo_belva=r/lims_dev_user","usr_peter_s=r/lims_dev_user"}
lims_dev_user	sc_lims_dal_ai	ai_spec_bom_item_current_tree	v	lims_dev_user	{"lims_dev_user=arwdRxtD/lims_dev_user","usr_edo_belva=r/lims_dev_user","usr_peter_s=r/lims_dev_user"}
lims_dev_user	sc_lims_dal_ai	ai_specification				v	lims_dev_user	{"lims_dev_user=arwdRxtD/lims_dev_user","usr_edo_belva=r/lims_dev_user","usr_peter_s=r/lims_dev_user"}
lims_dev_user	sc_lims_dal_ai	ai_specification_bom_header		v	lims_dev_user	{"lims_dev_user=arwdRxtD/lims_dev_user","usr_edo_belva=r/lims_dev_user","usr_peter_s=r/lims_dev_user"}
lims_dev_user	sc_lims_dal_ai	ai_specification_bom_item		v	lims_dev_user	{"lims_dev_user=arwdRxtD/lims_dev_user","usr_edo_belva=r/lims_dev_user","usr_peter_s=r/lims_dev_user"}
lims_dev_user	sc_lims_dal_ai	ai_specification_bom_item_full	v	lims_dev_user	{"lims_dev_user=arwdRxtD/lims_dev_user","usr_edo_belva=r/lims_dev_user","usr_peter_s=r/lims_dev_user"}
lims_dev_user	sc_lims_dal_ai	ai_specification_data			v	lims_dev_user	{"lims_dev_user=arwdRxtD/lims_dev_user","usr_edo_belva=r/lims_dev_user","usr_peter_s=r/lims_dev_user"}
lims_dev_user	sc_lims_dal_ai	ai_specification_property		v	lims_dev_user	{"lims_dev_user=arwdRxtD/lims_dev_user","usr_edo_belva=r/lims_dev_user","usr_peter_s=r/lims_dev_user"}
*/

--***********************************************************************
--DETAIL OVERZICHT van USER-PRIVILEGES !!!!!!!!!!!
--***********************************************************************
SELECT * 
FROM 
    (
    SELECT 
        schemaname
        ,usename
        ,HAS_SCHEMA_PRIVILEGE(usrs.usename, schemaname, 'usage') AS usg
        ,HAS_SCHEMA_PRIVILEGE(usrs.usename, schemaname, 'create') AS crt
    FROM
        (
        SELECT distinct(schemaname) FROM pg_tables
        WHERE schemaname not in ('pg_internal')
        UNION
        SELECT distinct(schemaname) FROM pg_views
        WHERE schemaname not in ('pg_internal')
        ) AS objs
        ,(SELECT * FROM pg_user) AS usrs
    ORDER BY schemaname
    )
--WHERE (usg = true or crt = true)
WHERE schemaname in ('sc_lims_dal_ai','sc_lims_dal','sc_unilab_ens','sc_interspec_ens')
and usename in ('lims_dev_user', 'usr_peter_s','usr_edo_belva','usr_stu_edo','usr_stu_jesus','usr_stu_kaiqi')
;
/*
schemaname		usename						usg		crt
sc_lims_dal_ai	awsuser						true	true
sc_lims_dal_ai	rdsdb						true	true
sc_lims_dal_ai	usr_edo_belva				true	false
sc_lims_dal_ai	usr_eu_container_track_app	true	true
sc_lims_dal_ai	lims_dev_user				true	true
sc_lims_dal_ai	usr_peter_s					true	false
*/

--****************************************************************************
--****************************************************************************
-- overzicht alle PRIVILEGES 
--****************************************************************************
--****************************************************************************

WITH tabledef as (
    SELECT schemaname,
        't' AS typename,
        tablename AS objectname,
        tableowner as owner,
        schemaname + '.' + tablename AS fullname
    FROM pg_tables
    UNION 
    SELECT schemaname,
        'v' AS typename,
        viewname AS objectname,
        viewowner as owner,
        schemaname + '.' + viewname AS fullname
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
    ON HAS_TABLE_PRIVILEGE(u.usename, t.fullname, 'select') = true
        OR HAS_TABLE_PRIVILEGE(u.usename, t.fullname, 'insert') = true
        OR HAS_TABLE_PRIVILEGE(u.usename, t.fullname, 'update') = true
        OR HAS_TABLE_PRIVILEGE(u.usename, t.fullname, 'delete') = true
        OR HAS_TABLE_PRIVILEGE(u.usename, t.fullname, 'references') = true
        OR t.owner = u.usename
    WHERE t.schemaname in ('sc_lims_dal','sc_lims_dal_ai')
)
SELECT schemaname, objectname, owner, sel, ins, upd, del, ref FROM res
WHERE sel not in ('rdsdb', '<superuser>')
ORDER BY schemaname, objectname;


--*******************************************************************************
--GENEREREN VAN GRANT-STATEMENTS... MBV een GROUP !!!!!!
--zie ook: https://stackoverflow.com/questions/18741334/how-do-i-view-grants-on-redshift
--*******************************************************************************
--vulling van relacl:	GROUP: 	group grp_university_students=
--                      ROLE:	role  rol_ai_readonly=
--                      USER:	lims_dev_user=
--*******************************************************************************
--select u.usename, u.usesysid, c.relacl from pg_user u cross join pg_class c 
--*******************************************************************************
select namespace||'.'||item as tablename 
,      'grant ' || substring(
                case when charindex('r',split_part(split_part(array_to_string(relacl, '|'),'lims_dev_user=',2 ) ,'/',1)) > 0 then ',select ' else '' end 
              ||case when charindex('w',split_part(split_part(array_to_string(relacl, '|'),'lims_dev_user=',2 ) ,'/',1)) > 0 then ',update ' else '' end 
              ||case when charindex('a',split_part(split_part(array_to_string(relacl, '|'),'lims_dev_user=',2 ) ,'/',1)) > 0 then ',insert ' else '' end 
              ||case when charindex('d',split_part(split_part(array_to_string(relacl, '|'),'lims_dev_user=',2 ) ,'/',1)) > 0 then ',delete ' else '' end 
              ||case when charindex('R',split_part(split_part(array_to_string(relacl, '|'),'lims_dev_user=',2 ) ,'/',1)) > 0 then ',rule ' else '' end 
              ||case when charindex('x',split_part(split_part(array_to_string(relacl, '|'),'lims_dev_user=',2 ) ,'/',1)) > 0 then ',references ' else '' end 
              ||case when charindex('t',split_part(split_part(array_to_string(relacl, '|'),'lims_dev_user=',2 ) ,'/',1)) > 0 then ',trigger ' else '' end 
              ||case when charindex('X',split_part(split_part(array_to_string(relacl, '|'),'lims_dev_user=',2 ) ,'/',1)) > 0 then ',execute ' else '' end 
              ||case when charindex('U',split_part(split_part(array_to_string(relacl, '|'),'lims_dev_user=',2 ) ,'/',1)) > 0 then ',usage ' else '' end 
              ||case when charindex('C',split_part(split_part(array_to_string(relacl, '|'),'lims_dev_user=',2 ) ,'/',1)) > 0 then ',create ' else '' end 
              ||case when charindex('T',split_part(split_part(array_to_string(relacl, '|'),'lims_dev_user=',2 ) ,'/',1)) > 0 then ',temporary ' else '' end 
              , 2,10000)
              || ' on '||namespace||'.'||item ||' to ROLE rol_dal_readonly;' as grantsql
from (SELECT use.usename as subject
     ,       nsp.nspname as namespace
	 ,       c.relname as item
	 ,       c.relkind as type
	 ,       use2.usename as owner
	 ,       c.relacl 
     FROM pg_user use 
     cross join pg_class c 
     left join pg_namespace nsp on (c.relnamespace = nsp.oid) 
     left join pg_user use2 on (c.relowner = use2.usesysid)
     WHERE c.relowner = use.usesysid  
     and  nsp.nspname NOT IN ('pg_catalog', 'pg_toast', 'information_schema')
	 and  nsp.nspname IN ('sc_lims_dal')
     ORDER BY subject
     ,        namespace
     ,        item 
     ) 
where relacl is not null
;
/*
sc_lims_dal.frame							grant select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.frame to ROLE rol_dal_readonly;
sc_lims_dal.frame_keyword					grant select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.frame_keyword to ROLE rol_dal_readonly;
sc_lims_dal.method							grant select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.method to ROLE rol_dal_readonly;
sc_lims_dal.method_attributes				grant select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.method_attributes to ROLE rol_dal_readonly;
sc_lims_dal.method_cell						grant select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.method_cell to ROLE rol_dal_readonly;
sc_lims_dal.method_data_time_info			grant select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.method_data_time_info to ROLE rol_dal_readonly;
sc_lims_dal.method_group_key				grant select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.method_group_key to ROLE rol_dal_readonly;
sc_lims_dal.method_history					grant select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.method_history to ROLE rol_dal_readonly;
sc_lims_dal.method_reanalysis				grant select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.method_reanalysis to ROLE rol_dal_readonly;
sc_lims_dal.parameter						grant select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.parameter to ROLE rol_dal_readonly;
sc_lims_dal.parameter_attributes			grant select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.parameter_attributes to ROLE rol_dal_readonly;
sc_lims_dal.parameter_data_time_info		grant select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.parameter_data_time_info to ROLE rol_dal_readonly;
sc_lims_dal.parameter_group					grant select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.parameter_group to ROLE rol_dal_readonly;
sc_lims_dal.parameter_group_attributes		grant select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.parameter_group_attributes to ROLE rol_dal_readonly;
sc_lims_dal.parameter_group_data_time_info	grant select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.parameter_group_data_time_info to ROLE rol_dal_readonly;
sc_lims_dal.parameter_history				grant select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.parameter_history to ROLE rol_dal_readonly;
sc_lims_dal.parameter_reanalysis			grant select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.parameter_reanalysis to ROLE rol_dal_readonly;
sc_lims_dal.parameter_specifications		grant select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.parameter_specifications to ROLE rol_dal_readonly;
sc_lims_dal.request							grant select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.request to ROLE rol_dal_readonly;
sc_lims_dal.request_attributes				grant select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.request_attributes to ROLE rol_dal_readonly;
sc_lims_dal.request_data_time_info			grant select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.request_data_time_info to ROLE rol_dal_readonly;
sc_lims_dal.request_group_key				grant select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.request_group_key to ROLE rol_dal_readonly;
sc_lims_dal.request_history					grant select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.request_history to ROLE rol_dal_readonly;
sc_lims_dal.request_info_card				grant select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.request_info_card to ROLE rol_dal_readonly;
sc_lims_dal.request_info_field				grant select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.request_info_field to ROLE rol_dal_readonly;
sc_lims_dal.sample							grant select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.sample to ROLE rol_dal_readonly;
sc_lims_dal.sample_attributes				grant select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.sample_attributes to ROLE rol_dal_readonly;
sc_lims_dal.sample_data_time_info			grant select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.sample_data_time_info to ROLE rol_dal_readonly;
sc_lims_dal.sample_group_key				grant select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.sample_group_key to ROLE rol_dal_readonly;
sc_lims_dal.sample_history					grant select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.sample_history to ROLE rol_dal_readonly;
sc_lims_dal.sample_info_card				grant select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.sample_info_card to ROLE rol_dal_readonly;
sc_lims_dal.sample_info_field				grant select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.sample_info_field to ROLE rol_dal_readonly;
sc_lims_dal.sample_part_no_groupkey			grant select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.sample_part_no_groupkey to ROLE rol_dal_readonly;
sc_lims_dal.sample_part_no_info_card		grant select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.sample_part_no_info_card to ROLE rol_dal_readonly;
sc_lims_dal.spec_bom_item_current_tree		grant select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.spec_bom_item_current_tree to ROLE rol_dal_readonly;
sc_lims_dal.spec_part_manufacturer			grant select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.spec_part_manufacturer to ROLE rol_dal_readonly;
sc_lims_dal.spec_part_plant					grant select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.spec_part_plant to ROLE rol_dal_readonly;
sc_lims_dal.specification					grant select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.specification to ROLE rol_dal_readonly;
sc_lims_dal.specification_bom_header		grant select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.specification_bom_header to ROLE rol_dal_readonly;
sc_lims_dal.specification_bom_item			grant select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.specification_bom_item to ROLE rol_dal_readonly;
sc_lims_dal.specification_bom_item_full		grant select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.specification_bom_item_full to ROLE rol_dal_readonly;
sc_lims_dal.specification_classification	grant select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.specification_classification to ROLE rol_dal_readonly;
sc_lims_dal.specification_data				grant select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.specification_data to ROLE rol_dal_readonly;
sc_lims_dal.specification_keyword			grant select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.specification_keyword to ROLE rol_dal_readonly;
sc_lims_dal.specification_part				grant select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.specification_part to ROLE rol_dal_readonly;
sc_lims_dal.specification_property			grant select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.specification_property to ROLE rol_dal_readonly;
sc_lims_dal.specification_section			grant select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.specification_section to ROLE rol_dal_readonly;
--
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

*/
select namespace||'.'||item as tablename 
,      'grant ' || substring(
                case when charindex('r',split_part(split_part(array_to_string(relacl, '|'),'group grp_university_students=',2 ) ,'/',1)) > 0 then ',select ' else '' end 
              ||case when charindex('w',split_part(split_part(array_to_string(relacl, '|'),'group grp_university_students=',2 ) ,'/',1)) > 0 then ',update ' else '' end 
              ||case when charindex('a',split_part(split_part(array_to_string(relacl, '|'),'group grp_university_students=',2 ) ,'/',1)) > 0 then ',insert ' else '' end 
              ||case when charindex('d',split_part(split_part(array_to_string(relacl, '|'),'group grp_university_students=',2 ) ,'/',1)) > 0 then ',delete ' else '' end 
              ||case when charindex('R',split_part(split_part(array_to_string(relacl, '|'),'group grp_university_students=',2 ) ,'/',1)) > 0 then ',rule ' else '' end 
              ||case when charindex('x',split_part(split_part(array_to_string(relacl, '|'),'group grp_university_students=',2 ) ,'/',1)) > 0 then ',references ' else '' end 
              ||case when charindex('t',split_part(split_part(array_to_string(relacl, '|'),'group grp_university_students=',2 ) ,'/',1)) > 0 then ',trigger ' else '' end 
              ||case when charindex('X',split_part(split_part(array_to_string(relacl, '|'),'group grp_university_students=',2 ) ,'/',1)) > 0 then ',execute ' else '' end 
              ||case when charindex('U',split_part(split_part(array_to_string(relacl, '|'),'group grp_university_students=',2 ) ,'/',1)) > 0 then ',usage ' else '' end 
              ||case when charindex('C',split_part(split_part(array_to_string(relacl, '|'),'group grp_university_students=',2 ) ,'/',1)) > 0 then ',create ' else '' end 
              ||case when charindex('T',split_part(split_part(array_to_string(relacl, '|'),'group grp_university_students=',2 ) ,'/',1)) > 0 then ',temporary ' else '' end 
              , 2,10000)
              || ' on '||namespace||'.'||item ||' to ROLE rol_ai_readonly;' as grantsql
from (SELECT use.usename as subject
     ,       nsp.nspname as namespace
	 ,       c.relname as item
	 ,       c.relkind as type
	 ,       use2.usename as owner
	 ,       c.relacl 
     FROM pg_user use 
     cross join pg_class c 
     left join pg_namespace nsp on (c.relnamespace = nsp.oid) 
     left join pg_user use2 on (c.relowner = use2.usesysid)
     WHERE c.relowner = use.usesysid  
     and  nsp.nspname NOT IN ('pg_catalog', 'pg_toast', 'information_schema')
	 and  nsp.nspname IN ('sc_lims_dal_ai')
     ORDER BY subject
     ,        namespace
     ,        item 
     ) 
where relacl is not null
;
/*
sc_lims_dal_ai.ai_method	   					grant select on sc_lims_dal_ai.ai_method 						to ROLE rol_ai_readonly;
sc_lims_dal_ai.ai_method_cell					grant SELECT on sc_lims_dal_ai.ai_method_cell 					to ROLE rol_ai_readonly;
sc_lims_dal_ai.ai_sample						grant SELECT on sc_lims_dal_ai.ai_sample 						to ROLE rol_ai_readonly;
sc_lims_dal_ai.ai_sample_part_no_groupkey		grant SELECT on sc_lims_dal_ai.ai_sample_part_no_groupkey 		to ROLE rol_ai_readonly;
sc_lims_dal_ai.ai_spec_bom_item_current_tree	grant SELECT on sc_lims_dal_ai.ai_spec_bom_item_current_tree 	to ROLE rol_ai_readonly;
sc_lims_dal_ai.ai_specification					grant SELECT on sc_lims_dal_ai.ai_specification 				to ROLE rol_ai_readonly;
sc_lims_dal_ai.ai_specification_bom_header		grant SELECT on sc_lims_dal_ai.ai_specification_bom_header 		to ROLE rol_ai_readonly;
sc_lims_dal_ai.ai_specification_bom_item		grant SELECT on sc_lims_dal_ai.ai_specification_bom_item 		to ROLE rol_ai_readonly;
sc_lims_dal_ai.ai_specification_bom_item_full	grant SELECT on sc_lims_dal_ai.ai_specification_bom_item_full 	to ROLE rol_ai_readonly;
sc_lims_dal_ai.ai_specification_data			grant SELECT on sc_lims_dal_ai.ai_specification_data 			to ROLE rol_ai_readonly;
sc_lims_dal_ai.ai_specification_property		grant SELECT on sc_lims_dal_ai.ai_specification_property 		to ROLE rol_ai_readonly;

REVOKE SELECT on sc_lims_dal_ai.ai_method FROM ROLE rol_ai_readonly;
REVOKE SELECT on sc_lims_dal_ai.ai_method_cell FROM ROLE rol_ai_readonly;
REVOKE SELECT on sc_lims_dal_ai.ai_sample FROM ROLE rol_ai_readonly;
REVOKE SELECT on sc_lims_dal_ai.ai_sample_part_no_groupkey FROM ROLE rol_ai_readonly;
REVOKE SELECT on sc_lims_dal_ai.ai_spec_bom_item_current_tree FROM ROLE rol_ai_readonly;
REVOKE SELECT on sc_lims_dal_ai.ai_specification FROM ROLE rol_ai_readonly;
REVOKE SELECT on sc_lims_dal_ai.ai_specification_bom_header FROM ROLE rol_ai_readonly;
REVOKE SELECT on sc_lims_dal_ai.ai_specification_bom_item FROM ROLE rol_ai_readonly;
REVOKE SELECT on sc_lims_dal_ai.ai_specification_bom_item_full FROM ROLE rol_ai_readonly;
REVOKE SELECT on sc_lims_dal_ai.ai_specification_data FROM ROLE rol_ai_readonly;
REVOKE SELECT on sc_lims_dal_ai.ai_specification_property FROM ROLE rol_ai_readonly;

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


select namespace||'.'||item as tablename 
,      'grant ' || substring(
                case when charindex('r',split_part(split_part(array_to_string(relacl, '|'),'group grp_university_students=',2 ) ,'/',1)) > 0 then ',select ' else '' end 
              ||case when charindex('w',split_part(split_part(array_to_string(relacl, '|'),'group grp_university_students=',2 ) ,'/',1)) > 0 then ',update ' else '' end 
              ||case when charindex('a',split_part(split_part(array_to_string(relacl, '|'),'group grp_university_students=',2 ) ,'/',1)) > 0 then ',insert ' else '' end 
              ||case when charindex('d',split_part(split_part(array_to_string(relacl, '|'),'group grp_university_students=',2 ) ,'/',1)) > 0 then ',delete ' else '' end 
              ||case when charindex('R',split_part(split_part(array_to_string(relacl, '|'),'group grp_university_students=',2 ) ,'/',1)) > 0 then ',rule ' else '' end 
              ||case when charindex('x',split_part(split_part(array_to_string(relacl, '|'),'group grp_university_students=',2 ) ,'/',1)) > 0 then ',references ' else '' end 
              ||case when charindex('t',split_part(split_part(array_to_string(relacl, '|'),'group grp_university_students=',2 ) ,'/',1)) > 0 then ',trigger ' else '' end 
              ||case when charindex('X',split_part(split_part(array_to_string(relacl, '|'),'group grp_university_students=',2 ) ,'/',1)) > 0 then ',execute ' else '' end 
              ||case when charindex('U',split_part(split_part(array_to_string(relacl, '|'),'group grp_university_students=',2 ) ,'/',1)) > 0 then ',usage ' else '' end 
              ||case when charindex('C',split_part(split_part(array_to_string(relacl, '|'),'group grp_university_students=',2 ) ,'/',1)) > 0 then ',create ' else '' end 
              ||case when charindex('T',split_part(split_part(array_to_string(relacl, '|'),'group grp_university_students=',2 ) ,'/',1)) > 0 then ',temporary ' else '' end 
              , 2,10000)
              || ' on '||namespace||'.'||item ||' to GROUP grp_university_students;' as grantsql
from (SELECT use.usename as subject
     ,       nsp.nspname as namespace
	 ,       c.relname as item
	 ,       c.relkind as type
	 ,       use2.usename as owner
	 ,       c.relacl 
     FROM pg_user use 
     cross join pg_class c 
     left join pg_namespace nsp on (c.relnamespace = nsp.oid) 
     left join pg_user use2 on (c.relowner = use2.usesysid)
     WHERE c.relowner = use.usesysid  
     and  nsp.nspname NOT IN ('pg_catalog', 'pg_toast', 'information_schema')
	 and  nsp.nspname IN ('sc_interspec_ens', 'sc_unilab_ens', 'sc_lims_dal', 'sc_lims_dal_ai')
     ORDER BY subject
     ,        namespace
     ,        item 
     ) 
where relacl is not null
;


--
--grant USAGE to seperate USERS
--
grant usage on schema sc_lims_dal to lims_dev_user;
grant usage on schema sc_lims_dal_AI to lims_dev_user;
grant select on all tables in schema sc_lims_dal to lims_dev_user;
grant select on all tables in schema sc_lims_dal_AI to lims_dev_user;
--
revoke usage on schema sc_interspec_ens,sc_unilab_ens,sc_lims_dal,sc_lims_dal_AI  from  usr_peter_s;
grant  usage on schema sc_interspec_ens,sc_unilab_ens,sc_lims_dal,sc_lims_dal_AI  to usr_peter_s;

--
/*
revoke usage on schema sc_interspec_ens from usr_peter_s;
revoke usage on schema sc_unilab_ens    from usr_peter_s;
revoke usage on schema sc_lims_dal      from usr_peter_s;
revoke usage on schema sc_lims_dal_ai   from usr_peter_s;
--
grant usage on schema sc_interspec_ens to usr_peter_s;
grant usage on schema sc_unilab_ens    to usr_peter_s;
grant usage on schema sc_lims_dal      to usr_peter_s;
grant usage on schema sc_lims_dal_AI   to usr_peter_s;
*/

--
--grant USAGE to ROLES 
--conn LIMS_DEV_USER
revoke usage on schema sc_lims_dal_ai from ROLE rol_ai_readonly, rol_dal_readonly, rol_lims_readonly;
--
revoke usage on schema sc_interspec_ens,sc_unilab_ens,sc_lims_dal,sc_lims_dal_AI  from ROLE rol_ai_readonly;
revoke usage on schema sc_interspec_ens,sc_unilab_ens,sc_lims_dal,sc_lims_dal_AI  from ROLE rol_lims_readonly;
revoke usage on schema sc_interspec_ens,sc_unilab_ens,sc_lims_dal,sc_lims_dal_AI  from ROLE rol_dal_readonly;
--
grant  usage on schema sc_interspec_ens,sc_unilab_ens,sc_lims_dal,sc_lims_dal_AI  to ROLE rol_ai_readonly;
grant  usage on schema sc_interspec_ens,sc_unilab_ens,sc_lims_dal,sc_lims_dal_AI  to ROLE rol_lims_readonly;
grant  usage on schema sc_interspec_ens,sc_unilab_ens,sc_lims_dal,sc_lims_dal_AI  to ROLE rol_dal_readonly;
--
/*
grant usage on schema sc_lims_dal_ai,    to rol_ai_readonly;
grant usage on schema sc_lims_dal      to rol_ai_readonly;
grant usage on schema sc_unilab_ens    to rol_ai_readonly;
grant usage on schema sc_interspec_ens to rol_ai_readonly;
--
grant usage on schema sc_lims_dal_ai   to rol_lims_readonly;
grant usage on schema sc_lims_dal      to rol_lims_readonly;
grant usage on schema sc_unilab_ens    to rol_lims_readonly;
grant usage on schema sc_interspec_ens to rol_lims_readonly;
*/


--grant all on schema sc_lims_dal    to group dbdevusers;



--
--GRANT SELECT ALL TABLES to separate USERS
--
/*
revoke select on all tables in schema sc_interspec_ens from usr_peter_s;
revoke select on all tables in schema sc_unilab_ens from usr_peter_s;
revoke select on all tables in schema sc_lims_dal from usr_peter_s;
revoke select on all tables in schema sc_lims_dal_AI from usr_peter_s;
--
grant select on all tables in schema sc_interspec_ens to usr_peter_s;
grant select on all tables in schema sc_unilab_ens to usr_peter_s;
grant select on all tables in schema sc_lims_dal to usr_peter_s;
grant select on all tables in schema sc_lims_dal_AI to usr_peter_s;
*/

--2.    To grant SELECT access to the user for future tables created under the schema, run the following command: Note: Replace awsuser with the username that is used to create future objects under the schema, newtestschema with the schema name, and newtestuser with the username that needs access to future objects.

alter default privileges for user awsuser in schema newtestschema grant select on tables to newtestuser;
--Note: Default privileges apply only to new objects. Running ALTER DEFAULT PRIVILEGES doesn’t change privileges on existing objects.

--3.    To verify default privileges have been granted to the user, run the following query as a superuser:
select pg_get_userbyid(d.defacluser) as user
,      n.nspname as schema
,      case d.defaclobjtype when 'r' then 'tables' when 'f' then 'functions' end as object_type
,      array_to_string(d.defaclacl, ' + ')  as default_privileges 
from pg_catalog.pg_default_acl d 
left join pg_catalog.pg_namespace n on n.oid = d.defaclnamespace;

--If access is present, then you will see an entry for the user under the column default_privileges.
--Now, when the superuser creates a new object under the schema, the user will have SELECT access over the table.
--Example
--The following example starts with this configuration:
--A user named newtestuser who isn’t a superuser.
--A schema named newtestschema and one table named newtesttable1 under the schema with a few records.
--The superuser named awsuser, grants access to newtestuser on newtestschema schema and all the tables currently present under the schema, using the following example command:

grant usage on schema newtestschema to newtestuser;
grant select on all tables in schema newtestschema to newtestuser;

--The preceding command grants newtestuser with SELECT access on the current tables present under the newtestschema. 
--Currently, only the newtesttable1 table is present under the newtestschema. The newtesttable1 table is accessible to newtestuser.
--Next, awsuser creates another table named newtesttable2 under the newtestschema. If newtestuser runs a SELECT query on the table newtestschema.newtesttable2, they see the following error:
--ERROR: permission denied for relation newtesttable2.
--To resolve the error, the awsuser does the following:
--1.    Grants access to the table, newtesttable2, by running the following example command:

grant select on table newtestschema.newtesttable2 to newtestuser;

--2.    Grants access to newtestuser, on any future tables created by awsuser under the newtestschema, by running the following example command:

alter default privileges for user awsuser in schema newtestschema grant select on tables to newtestuser;

--Now, when awsuser creates another new table named newtesttable3, under the newtestschema, the newtestuser will have SELECT access on newtesttable3.

--3.    To verify default privileges have been granted to the newtestuser, the awsuser runs the following query:
select pg_get_userbyid(d.defacluser) as user, 
n.nspname as schema, 
case d.defaclobjtype when 'r' then 'tables' when 'f' then 'functions' end 
as object_type, 
array_to_string(d.defaclacl, ' + ')  as default_privileges 
from pg_catalog.pg_default_acl d 
left join pg_catalog.pg_namespace n on n.oid = d.defaclnamespace;

--The output of the preceding query is similar to the following:
--user    | schema    | object_type    | default_privileges
--awsuser | newtestschema    | tables    | newtestuser=r/awsuser
--The output shows that awsuser grants SELECT privileges to newtestuser for all new tables created by awsuser in the newtestschema.


--voorstel APOLLO OBV DATASHARES...
CREATE DATASHARE salesshare;
ALTER DATASHARE salesshare ADD TABLE public.tickit_sales_redshift; 
GRANT USAGE ON DATASHARE salesshare TO NAMESPACE '13b8833d-17c6-4f16-8fe4-1a018f5ed00d';
--
--The following example grants permissions to access a shared table at the database level and schema level.
GRANT USAGE ON DATABASE sales_db TO Bob;
GRANT USAGE ON SCHEMA sales_schema TO GROUP Analyst_group;
--To further restrict access, you can create views on top of shared objects, exposing only the necessary data. 
--You can then use these views to give access to the users and groups.

--DUS UITZOEKEN WAT JE KUNT ALS JE ALLEEN GRANT-USAGE HEBT GEKREGEN !!!
--OM DAAR VERVOLGENS JE EIGEN VIEWS OP TE BOUWEN !!!
--DUS EVT. MATERIALIZED-VIEWS OP SC_LIMS_DAL, VIA EEN DATASHARE ONTSLUITEN, EN DAAR DAN VERVOLGENS VIA VIEWS RECHTEN UITDELEN AAN GEBRUIKERS
--MISSCHIEN NIET AUTORISEREN OP EEN SCHEMA, MAAR TOCH GEWOON VIA EEN ROLE ?
--DAT ZOU VOOR WAT MIJ BETREFT NOG DE VOORKEUR HEBBEN BOVEN HET BASEREN VAN VIEWS OP TECHNISCHE BASIS-SCHEMA'S VAN INTERSPEC/UNILAB.


--To look up grants of column-level privileges, use the PG_ATTRIBUTE_INFO view.

--WERKEND SCENARIO

select u.usename
from pg_user u
;

--*********************************************************************
--revoke alles van USER
--*********************************************************************
revoke usage on schema sc_interspec_ens, sc_unilab_ens, sc_lims_dal, sc_lims_dal_ai  from usr_peter_s;

--revoke select on all tables in schema granted to roles;
revoke select on all tables in schema sc_interspec_ens, sc_unilab_ens, sc_lims_dal, sc_lims_dal_AI from ROLE rol_lims_readonly;
revoke select on all tables in schema sc_interspec_ens, sc_unilab_ens, sc_lims_dal, sc_lims_dal_AI from ROLE rol_dal_readonly;
revoke select on all tables in schema sc_interspec_ens, sc_unilab_ens, sc_lims_dal, sc_lims_dal_AI from ROLE rol_ai_readonly;

--revoke select on all tables in schema sc_interspec_ens from usr_peter_s;
revoke select on all tables in schema sc_interspec_ens, sc_unilab_ens from usr_peter_s;
revoke select on all tables in schema sc_lims_dal from usr_peter_s;
revoke select on all tables in schema sc_lims_dal_AI from usr_peter_s;



--OF voor losse tabellen:
revoke select on table sc_lims_dal.frame from usr_peter_s;
revoke select on table sc_lims_dal.request from usr_peter_s;








--*********************************
--nieuwe TOTAAL-IMPLEMENTATION
--*********************************
--create group dbdevusers;
--alter group dbdevusers add user usr_peter_s;

--AWSUSER grant role to LIMS_DEV_USER first !!!!
--grant rolE r_read_sc_lims_dal_ai to aidevusers;
conn awsuser/
grant role rol_ai_readonly to lims_dev_user WITH ADMIN option;
grant role rol_dal_readonly to lims_dev_user WITH ADMIN option;
grant role rol_lims_readonly to lims_dev_user WITH ADMIN option;

--grant usage to ROLES
conn lims_dev_user/
grant usage on SCHEMA sc_lims_dal_ai, sc_lims_dal,sc_interspec_ens, sc_unilab_ens to ROLE rol_ai_readonly;
grant usage on SCHEMA sc_lims_dal_ai, sc_lims_dal,sc_interspec_ens, sc_unilab_ens to ROLE rol_dal_readonly;
grant usage on SCHEMA sc_lims_dal_ai, sc_lims_dal,sc_interspec_ens, sc_unilab_ens to ROLE rol_lims_readonly;

--EVT. create groups
create group grp_university_students;
--ADD users to groups
alter group grp_university_students add user usr_stu_kaiqi, usr_stu_jesus, usr_stu_edo;


--grant rollen aan USERS mbv LIMS_DEV_USER:
conn lims_dev_user/
GRANT ROLE rol_ai_readonly                                      TO usr_edo_belva;
GRANT ROLE rol_ai_readonly, rol_dal_readonly, rol_lims_readonly TO usr_peter_s;
--evt. grant rollen aan USER-GROUPS 
GRANT ROLE rol_ai_readonly                                      TO GROUP grp_university_students;

--
--grant TABLE privileges to ROLES
--grant SELECT-PRIVILEGE to role ROL_LIMS_READONLY;
CONN lims_dev_user/
GRANT SELECT ON ALL TABLES IN SCHEMA sc_interspec_ens, sc_unilab_ens to ROLE rol_lims_readonly ;

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





--einde script

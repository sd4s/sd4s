//Redshift-resources:   https://aws.amazon.com/redshift/resources/?nc=sn&loc=5&dn=1
//overview ADMIN-VIEWS: https://github.com/awslabs/amazon-redshift-utils/tree/master/src/AdminViews

//select current user
select current_user;
select current_schema();


//set search path 
//The SEARCH_PATH specifies the schema search order for database objects, such as tables and
//functions, when the object is referenced by a simple name with no schema specified
SHOW search_path; 
set search_path to '$user', 'public', 'pg_catalog','sc_interspec_ens','sc_unilab_ens','sc_lims_dal','sc_lims_dal_ai';
set search_path to 'sc_lims_dal_ai','sc_lims_dal','sc_interspec_ens','sc_unilab_ens';
SHOW search_path; 

//set search-path for user (you wont have to set it each time you connect...)
alter user lims_dev_user set search_path to 'sc_lims_dal_ai', 'sc_lims_dal', 'sc_interspec_ens', 'sc_unilab_ens', 'pg_catalog', 'public';
alter user usr_peter_s set search_path to 'sc_lims_dal_ai', 'sc_lims_dal', 'sc_interspec_ens', 'sc_unilab_ens', 'public';
SHOW search_path; 

//users
SELECT * FROM pg_user; 
//select users without intern superuser
SELECT * FROM pg_user WHERE usesysid > 1;  
awsuser				100	true	true	false	********		
lims_dev_user			101	false	false	false	********		{"search_path=sc_lims_dal_ai, sc_lims_dal, sc_interspec_ens, sc_unilab_ens, public"}
usr_stu_kaiqi			110	false	false	false	********		
usr_stu_jesus			111	false	false	false	********		
usr_stu_edo			112	false	false	false	********		
lims_report_user		113	false	false	false	********		
usr_edo_belva			114	false	false	false	********		
usr_peter_s			117	false	false	false	********		

//change session-user
select current_user;
set session authorization lims_dev_user;
set session authorization usr_peter_s;
select current_user;
//reset authorization
RESET SESSION AUTHORIZATION;



//groups
select * from pg_group;
grp_university_students	1447560	{110,111,112}

//create groups
create group dbdevusers;
create group aidevusers;

//add a user to a group
alter group dbdevusers add user usr_peter_s;
alter group aidevusers add user usr_edo_belva;


//select running queries
SELECT pid, trim(user_name), starttime, substring(query,1,20) FROM stv_recents WHERE status='Running';

//cancel query with PID (see previous statement), not the transaction
CANCEL 610;

//to stop or rollback a transaction use the abort/rollback-statement
ABORT;
ROLLBACK;

//change from query-queue when your own query-queue is full
SET query_group TO 'superuser';
CANCEL 610;
RESET query_group;

//create a schema in a database
create schema sc_lims_dal;
create schema sc_lims_dal_ai;

//grant usage on a schema
//Unless they are granted the USAGE permission by the object owner, users cannot access any objects in schemas they do not own
grant usage on schema sc_lims_dal to group dbdevusers;
grant usage on schema sc_lims_dal to group aidevusers;
//grant all permissions on a schema
grant all on schema sc_lims_dal_ai to group dbdevusers;
grant all on schema sc_lims_dal    to group dbdevusers;


//select all schemas in a database
select * from pg_namespace;
sc_unilab_ens		100	{awsuser=UC/awsuser,lims_dev_user=UC/awsuser,lims_report_user=U/awsuser,usr_edo_belva=U/awsuser}
sc_interspec_ens	100	{awsuser=UC/awsuser,lims_dev_user=UC/awsuser,lims_report_user=U/awsuser,usr_edo_belva=U/awsuser}
sc_lims_dal			101	{lims_dev_user=U*C*/lims_dev_user,usr_peter_s=U/lims_dev_user}
sc_lims_dal_ai		101	{lims_dev_user=U*C*/lims_dev_user,usr_edo_belva=U/lims_dev_user}

//query tables within a schema
select distinct(tablename) from pg_table_def where schemaname = 'pg_catalog';
select distinct(tablename) from pg_table_def where schemaname = 'sc_lims_dal_ai';
select distinct(tablename) from pg_table_def where schemaname = 'sc_lims_dal';
select distinct(tablename) from pg_table_def where schemaname = 'sc_interspec_ens';
select distinct(tablename) from pg_table_def where schemaname = 'sc_unilab_ens';


//system-roles:
sys:monitor	  -This role has the permission to access catalog or system tables
sys:operator  -This role has the permissions to access catalog or system tables, analyze, vacuum, or cancel queries.
sys:dba		  -This role has the permissions to create schemas, create tables, drop schemas, drop tables, and truncate tables. 
               It has the permissions to create or replace stored procedures, drop procedures, create or replace functions, create or replace external functions, create views, 
               and drop views. Also, this role inherits all the permissions from the sys:operator role.
sys:superuser -This role has the same permissions as the Amazon Redshift superuser.
sys:secadmin  -This role has the permissions to create users, alter users, drop users, create roles, drop roles, and grant roles. 
               This role can have access to user tables only when the permission is explicitly granted to the role. 
//grant system-rollen
GRANT ROLE sys:dba     TO lims_dev_user;
GRANT ROLE sys:monitor TO lims_dev_user;



--CREATE roles by AWSUSER
CREATE ROLE rol_ai_readonly;
CREATE ROLE rol_dal_readonly;
CREATE ROLE rol_lims_readonly;  --sc_interspec_ens + sc_unilab_ens

--grant role to our admin LIMS_DEV_USER 
grant role rol_ai_readonly to lims_dev_user WITH ADMIN option;
grant role rol_dal_readonly to lims_dev_user WITH ADMIN option;
grant role rol_lims_readonly to lims_dev_user WITH ADMIN option;


//grant usage/select on all tables to user/role/group
grant usage on SCHEMA sc_lims_dal_ai to ROLE r_read_sc_lims_dal_ai;
grant select on ALL tables in schema sc_lims_dal_ai to ROLE r_read_sc_lims_dal_ai;

//grant with-grant-option
//Indicates that the user receiving the privileges can in turn grant the same privileges to others. WITH GRANT OPTION cant be granted to a group or to PUBLIC.
grant select on all tables in schema sc_lims_dal_ai to usr_peter_s with grant option; 

//grant select on table/view-columns
grant select(cust_name, cust_phone) on cust_profile to user1;

//refresh materialized-view
REFRESH MATERIALIZED VIEW tickets_mv;











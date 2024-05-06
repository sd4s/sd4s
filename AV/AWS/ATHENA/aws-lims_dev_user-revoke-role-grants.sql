--*********************************************************************
--revoke all privileges from USER / ROLE / GROUP
--*********************************************************************

--************************************************************************************
--REMOVE COMPLETE GROUP (CAN ONLY BE DONE BY A SUPERUSER AWSUSER) !!!
select current_user;
set session authorization awsuser;
SHOW search_path
--
select groname, grosysid, grolist from pg_group;
--
drop group grp_dal_ai_readonly;
drop group grp_dal_readonly;
drop group grp_lims_readonly;
drop group grp_university_students;
--remove user from group
alter group grp_dal_ai_readonly drop user usr_edo_belva, usr_peter_s;
alter group grp_dal_readonly drop user usr_peter_s;
alter group grp_lims_readonly drop user usr_peter_s;
alter group grp_university_students drop user usr_stu_kaiqi, usr_stu_jesus, usr_stu_edo;



--************************************************************************************
--REMOVE USER/GROUP-PRIVILEGES DONE BY ADMIN LIMS_DEV_USER.
select current_user;
set session authorization lims_dev_user;
SHOW search_path; 
set search_path to 'sc_lims_dal_ai','sc_lims_dal','sc_interspec_ens','sc_unilab_ens','pg_catalog','information_schema','$user','public' ;
alter user lims_dev_user set search_path to 'sc_lims_dal_ai', 'sc_lims_dal', 'sc_interspec_ens', 'sc_unilab_ens', 'public';


--revoke SCHEMA-USAGE from GROUPS
revoke usage on schema sc_interspec_ens,sc_unilab_ens,sc_lims_dal,sc_lims_dal_ai  from GROUP grp_dal_ai_readonly;
revoke usage on schema sc_interspec_ens,sc_unilab_ens,sc_lims_dal,sc_lims_dal_ai  from GROUP grp_dal_readonly;
revoke usage on schema sc_interspec_ens,sc_unilab_ens,sc_lims_dal,sc_lims_dal_ai  from GROUP grp_lims_readonly;
revoke usage on schema sc_interspec_ens,sc_unilab_ens,sc_lims_dal,sc_lims_dal_ai  from GROUP grp_university_students;
--REVOKE SCHEMA-USAGE from USER
revoke usage on schema sc_interspec_ens,sc_unilab_ens,sc_lims_dal,sc_lims_dal_AI  from  usr_peter_s;
revoke usage on schema sc_interspec_ens,sc_unilab_ens,sc_lims_dal,sc_lims_dal_AI  from  usr_edo_belva;
--OR revoke LEFT-OVER-usage-grants from users (REVOKE ONLY 1 SCHEMA AT A TIME, FOR SEVERAL USERS !!!)
revoke usage on schema sc_interspec_ens  from usr_peter_s,usr_edo_belva,usr_stu_kaiqi,usr_stu_jesus,usr_stu_edo;
revoke usage on schema sc_unilab_ens  from usr_peter_s,usr_edo_belva,usr_stu_kaiqi,usr_stu_jesus,usr_stu_edo;
revoke usage on schema sc_lims_dal   from usr_peter_s,usr_edo_belva,usr_stu_kaiqi,usr_stu_jesus,usr_stu_edo;
revoke usage on schema sc_lims_dal_ai  from usr_peter_s,usr_edo_belva,usr_stu_kaiqi,usr_stu_jesus,usr_stu_edo;
--


--revoke DIRECT-GRANT-SELECT on all tables in schema sc_interspec_ens to GROUPS
revoke select on all tables in schema sc_interspec_ens,sc_unilab_ens,sc_lims_dal,sc_lims_dal_ai from GROUP grp_dal_ai_readonly;
revoke select on all tables in schema sc_interspec_ens,sc_unilab_ens,sc_lims_dal,sc_lims_dal_ai from GROUP grp_dal_readonly;
revoke select on all tables in schema sc_interspec_ens,sc_unilab_ens,sc_lims_dal,sc_lims_dal_ai from GROUP grp_lims_readonly;
revoke select on all tables in schema sc_interspec_ens,sc_unilab_ens,sc_lims_dal,sc_lims_dal_ai from GROUP grp_university_students;




/*
--REVOKE ALLE rollen van USERS mbv LIMS_DEV_USER to be sure we see all direct-USER-grants 
conn lims_dev_user/
REVOKE ROLE rol_ai_readonly   FROM usr_edo_belva;
REVOKE ROLE rol_dal_readonly  FROM usr_edo_belva;
REVOKE ROLE rol_lims_readonly FROM usr_edo_belva;
--
REVOKE ROLE rol_ai_readonly   FROM usr_peter_s;
REVOKE ROLE rol_dal_readonly  FROM usr_peter_s;
REVOKE ROLE rol_lims_readonly FROM usr_peter_s;
--evt. REVOKE rollen Van USER-GROUPS IS NOT SUPPORTED !!!
--REVOKE ROLE rol_ai_readonly   FROM GROUP grp_university_students;

--SELECT SCHEMA-USAGES from users 
--(tip: the USAGES ARE ALL shown in same way, granted via a ROLE of direct to USER !!!!)
SELECT * 
FROM (SELECT schemaname,usename,HAS_SCHEMA_PRIVILEGE(usrs.usename, schemaname, 'usage') AS usg
                               ,HAS_SCHEMA_PRIVILEGE(usrs.usename, schemaname, 'create') AS crt
      FROM ( SELECT distinct(schemaname) FROM pg_tables
             WHERE schemaname not in ('pg_internal')
             UNION
             SELECT distinct(schemaname) FROM pg_views
             WHERE schemaname not in ('pg_internal')
           ) AS objs
      ,    (SELECT * FROM pg_user) AS usrs
      ORDER BY schemaname
     )
--WHERE (usg = true or crt = true)
WHERE schemaname in ('sc_lims_dal_ai','sc_lims_dal','sc_unilab_ens','sc_interspec_ens')
and usename in ('lims_dev_user', 'usr_peter_s','usr_edo_belva','usr_stu_edo','usr_stu_jesus','usr_stu_kaiqi')
;
/*
sc_interspec_ens	usr_stu_kaiqi	false	false
sc_interspec_ens	usr_stu_jesus	false	false
sc_interspec_ens	usr_stu_edo		false	false
sc_interspec_ens	usr_edo_belva	true	false
sc_interspec_ens	usr_peter_s		true	false
sc_interspec_ens	lims_dev_user	true	true
sc_lims_dal			usr_stu_kaiqi	false	false
sc_lims_dal			usr_stu_jesus	false	false
sc_lims_dal			usr_stu_edo		false	false
sc_lims_dal			usr_edo_belva	true	false
sc_lims_dal			usr_peter_s		true	false
sc_lims_dal			lims_dev_user	true	true
sc_lims_dal_ai		usr_stu_kaiqi	false	false
sc_lims_dal_ai		usr_stu_jesus	false	false
sc_lims_dal_ai		usr_stu_edo		false	false
sc_lims_dal_ai		usr_edo_belva	true	false
sc_lims_dal_ai		usr_peter_s		true	false
sc_lims_dal_ai		lims_dev_user	true	true
sc_unilab_ens		usr_stu_kaiqi	false	false
sc_unilab_ens		usr_stu_jesus	false	false
sc_unilab_ens		usr_stu_edo		false	false
sc_unilab_ens		usr_edo_belva	true	false
sc_unilab_ens		usr_peter_s		true	false
sc_unilab_ens		lims_dev_user	true	true
*/
revoke usage on schema sc_interspec_ens,sc_unilab_ens,sc_lims_dal,sc_lims_dal_AI  from  usr_peter_s;
revoke usage on schema sc_interspec_ens,sc_unilab_ens,sc_lims_dal,sc_lims_dal_AI  from  usr_edo_belva;

--revoke LEFT-OVER-usage-grants from users (REVOKE ONLY 1 SCHEMA AT A TIME, FOR SEVERAL USERS !!!)
revoke usage on schema sc_interspec_ens  from usr_peter_s, usr_edo_belva, usr_stu_kaiqi, usr_stu_jesus, usr_stu_edo;
revoke usage on schema sc_unilab_ens  from usr_peter_s, usr_edo_belva, usr_stu_kaiqi, usr_stu_jesus, usr_stu_edo;
revoke usage on schema sc_lims_dal   from usr_peter_s, usr_edo_belva, usr_stu_kaiqi, usr_stu_jesus, usr_stu_edo;
revoke usage on schema sc_lims_dal_ai  from usr_peter_s, usr_edo_belva, usr_stu_kaiqi, usr_stu_jesus, usr_stu_edo;
--
--revoke usage from ROLES
revoke usage on schema sc_interspec_ens,sc_unilab_ens,sc_lims_dal,sc_lims_dal_ai  from ROLE rol_lims_readonly;
revoke usage on schema sc_interspec_ens,sc_unilab_ens,sc_lims_dal,sc_lims_dal_ai  from ROLE rol_ai_readonly;
revoke usage on schema sc_interspec_ens,sc_unilab_ens,sc_lims_dal,sc_lims_dal_ai  from ROLE rol_dal_readonly;

--REVOKE all on all schemas to ROLES / users
revoke all on schema sc_lims_dal_ai from ROLE rol_ai_readonly;
revoke all on schema sc_lims_dal    from ROLE rol_dal_readonly;

--revoke select on all tables in schema granted to roles;
revoke select on all tables in schema sc_interspec_ens,sc_unilab_ens,sc_lims_dal,sc_lims_dal_AI from ROLE rol_lims_readonly;
revoke select on all tables in schema sc_interspec_ens,sc_unilab_ens,sc_lims_dal,sc_lims_dal_AI from ROLE rol_dal_readonly;
revoke select on all tables in schema sc_interspec_ens,sc_unilab_ens,sc_lims_dal,sc_lims_dal_AI from ROLE rol_ai_readonly;

--revoke DIRECT-select on all tables in schema sc_interspec_ens to USERS
revoke select on all tables in schema sc_interspec_ens,sc_unilab_ens from usr_peter_s;
revoke select on all tables in schema sc_lims_dal from usr_peter_s;
revoke select on all tables in schema sc_lims_dal_AI from usr_peter_s,usr_edo_belva,usr_ml_andre;
revoke select on all tables in schema sc_interspec_ens,sc_unilab_ens,sc_lims_dal,sc_lims_dal_ai from usr_ml_andre;
--only on dev
revoke select on all tables in schema sc_interspec_ens,sc_unilab_ens,sc_lims_dal,sc_lims_dal_ai from lims_report_user;






--
select 'REVOKE ' || substring(
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
              || ' on '||namespace||'.'||item ||' FROM GROUP grp_university_students;' as grantsql
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
/*
REVOKE select on sc_interspec_ens.access_group FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.approval_history FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.association FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.atfuncbom FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.atfuncbomdata FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.atfuncbomworkarea FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.attached_specification FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.attribute FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.avarticleprices FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.avspecification_weight FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.bom_header FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.bom_item FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.characteristic FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.characteristic_association FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.class3 FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.frame_header FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.frame_kw FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.frame_prop FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.frame_section FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.header FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.header_h FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.itbomly FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.itbomlyitem FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.itbomlysource FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.itclat FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.itcld FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.itcltv FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.itfrmdel FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.itkw FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.itkwas FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.itkwch FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.itlang FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.itlimsconfly FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.itlimsjob FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.itlimstmp FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.itmfc FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.itmfcmpl FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.itmpl FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.itoid FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.itoih FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.itplgrp FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.itplgrplist FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.itpp_del FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.itprcl FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.itprmfc FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.itshdel FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.itshq FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.itup FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.itus FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.layout FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.material_class FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.part FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.part_plant FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.plant FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.property FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.property_display FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.property_group FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.property_group_display FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.property_group_h FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.property_group_list FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.property_h FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.property_layout FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.property_test_method FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.reason FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.ref_text_type FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.reference_text FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.section FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.section_h FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.specdata FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.specification_header FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.specification_kw FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.specification_prop FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.specification_section FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.specification_text FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.status FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.status_history FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.sub_section FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.sub_section_h FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.test_method FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.text_type FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.uom FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.user_group FROM GROUP grp_university_students;
REVOKE select on sc_interspec_ens.user_group_list FROM GROUP grp_university_students;
--
REVOKE select on sc_unilab_ens.ataoactions FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.ataoconditions FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.atavmethodclass FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.atavprojects FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.atictrhs FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.atmetrhs FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.atpatrhs FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.atrqtrhs FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.atsctrhs FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utad FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utadau FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utau FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utblob FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utdd FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utdecode FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.uteq FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.uteqau FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.uteqcd FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.uteqtype FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.uterror FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utgkmelist FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utgkrqlist FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utgkrtlist FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utgksclist FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utgkstlist FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utgkwslist FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utie FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utieau FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utielist FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utip FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utipie FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utlab FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utlc FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utlcaf FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utlchs FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utlctr FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utlongtext FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utly FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utmt FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utmtau FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utmtcell FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utmtcelllist FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utmths FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utpp FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utppau FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utpppr FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utppprau FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utpr FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utprau FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utprhs FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utprmt FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utprmtau FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utrq FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utrqau FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utrqgk FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utrqgkisrelevant FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utrqgkistest FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utrqgkrequestcode FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utrqgkrqday FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utrqgkrqexecutionweek FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utrqgkrqmonth FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utrqgkrqstatus FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utrqgkrqweek FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utrqgkrqyear FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utrqgksite FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utrqgktestlocation FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utrqgktesttype FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utrqgkworkorder FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utrqhs FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utrqic FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utrqii FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utrscme FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utrscmecell FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utrscmecelllist FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utrscpa FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utrscpaspa FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utrscpg FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utrt FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utrtau FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utrtgkrequesterup FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utrtgkspec_type FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utrtip FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utsc FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utscau FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utscgk FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utscgkcontext FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utscgkistest FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utscgkpart_no FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utscgkpartgroup FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utscgkproject FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utscgkrequestcode FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utscgkrimcode FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utscgksccreateup FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utscgksclistup FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utscgkscreceiverup FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utscgksite FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utscgkspec_type FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utscgkweek FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utscgkworkorder FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utscgkyear FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utschs FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utscic FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utscii FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utscme FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utscmeau FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utscmecell FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utscmecelllist FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utscmegk FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utscmegkavtestmethod FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utscmegkavtestmethoddesc FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utscmegkequipement FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utscmegkequipment_type FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utscmegkimportid FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utscmegkkindofsample FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utscmegklab FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utscmegkme_is_relevant FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utscmegkpart_no FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utscmegkrequestcode FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utscmegkscpriority FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utscmegktm_position FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utscmegkuser_group FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utscmegkweek FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utscmegkyear FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utscmehs FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utscmehsdetails FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utscpa FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utscpaau FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utscpahs FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utscpaspa FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utscpg FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utscpgau FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utss FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utst FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utstau FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utstgk FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utstgkcontext FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utstgkistest FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utstgkproduct_range FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utstgkspec_type FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utsths FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utstpp FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utup FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utupau FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utuppref FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utupus FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utupuspref FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utws FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utwsau FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utwsgk FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utwsgkavtestmethod FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utwsgkavtestmethoddesc FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utwsgknumberofrefs FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utwsgknumberofsets FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utwsgknumberofvariants FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utwsgkoutsource FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utwsgkp_infl_front FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utwsgkp_infl_rear FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utwsgkrefsetdesc FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utwsgkrequestcode FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utwsgkrim FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utwsgkrimetfront FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utwsgkrimetrear FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utwsgkrimwidthfront FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utwsgkrimwidthrear FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utwsgkspec_type FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utwsgksubprogramid FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utwsgktestlocation FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utwsgktestprio FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utwsgktestsetsize FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utwsgktestvehicletype FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utwsgktestweek FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utwsgkwsprio FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utwsgkwstestlocation FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utwsgkwsvehicle FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utwshs FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utwsii FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utwsme FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utwssc FROM GROUP grp_university_students;
REVOKE select on sc_unilab_ens.utwt FROM GROUP grp_university_students;
--
REVOKE select on sc_lims_dal.frame FROM GROUP grp_university_students;
REVOKE select on sc_lims_dal.frame_keyword FROM GROUP grp_university_students;
REVOKE select on sc_lims_dal.method FROM GROUP grp_university_students;
REVOKE select on sc_lims_dal.method_attributes FROM GROUP grp_university_students;
REVOKE select on sc_lims_dal.method_cell FROM GROUP grp_university_students;
REVOKE select on sc_lims_dal.method_data_time_info FROM GROUP grp_university_students;
REVOKE select on sc_lims_dal.method_group_key FROM GROUP grp_university_students;
REVOKE select on sc_lims_dal.method_history FROM GROUP grp_university_students;
REVOKE select on sc_lims_dal.method_reanalysis FROM GROUP grp_university_students;
REVOKE select on sc_lims_dal.parameter FROM GROUP grp_university_students;
REVOKE select on sc_lims_dal.parameter_attributes FROM GROUP grp_university_students;
REVOKE select on sc_lims_dal.parameter_data_time_info FROM GROUP grp_university_students;
REVOKE select on sc_lims_dal.parameter_group FROM GROUP grp_university_students;
REVOKE select on sc_lims_dal.parameter_group_attributes FROM GROUP grp_university_students;
REVOKE select on sc_lims_dal.parameter_group_data_time_info FROM GROUP grp_university_students;
REVOKE select on sc_lims_dal.parameter_history FROM GROUP grp_university_students;
REVOKE select on sc_lims_dal.parameter_reanalysis FROM GROUP grp_university_students;
REVOKE select on sc_lims_dal.parameter_specifications FROM GROUP grp_university_students;
REVOKE select on sc_lims_dal.request FROM GROUP grp_university_students;
REVOKE select on sc_lims_dal.request_attributes FROM GROUP grp_university_students;
REVOKE select on sc_lims_dal.request_data_time_info FROM GROUP grp_university_students;
REVOKE select on sc_lims_dal.request_group_key FROM GROUP grp_university_students;
REVOKE select on sc_lims_dal.request_history FROM GROUP grp_university_students;
REVOKE select on sc_lims_dal.request_info_card FROM GROUP grp_university_students;
REVOKE select on sc_lims_dal.request_info_field FROM GROUP grp_university_students;
REVOKE select on sc_lims_dal.sample FROM GROUP grp_university_students;
REVOKE select on sc_lims_dal.sample_attributes FROM GROUP grp_university_students;
REVOKE select on sc_lims_dal.sample_data_time_info FROM GROUP grp_university_students;
REVOKE select on sc_lims_dal.sample_group_key FROM GROUP grp_university_students;
REVOKE select on sc_lims_dal.sample_history FROM GROUP grp_university_students;
REVOKE select on sc_lims_dal.sample_info_card FROM GROUP grp_university_students;
REVOKE select on sc_lims_dal.sample_info_field FROM GROUP grp_university_students;
REVOKE select on sc_lims_dal.sample_part_no_groupkey FROM GROUP grp_university_students;
REVOKE select on sc_lims_dal.sample_part_no_info_card FROM GROUP grp_university_students;
REVOKE select on sc_lims_dal.spec_bom_item_current_tree FROM GROUP grp_university_students;
REVOKE select on sc_lims_dal.spec_part_manufacturer FROM GROUP grp_university_students;
REVOKE select on sc_lims_dal.spec_part_plant FROM GROUP grp_university_students;
REVOKE select on sc_lims_dal.specification FROM GROUP grp_university_students;
REVOKE select on sc_lims_dal.specification_bom_header FROM GROUP grp_university_students;
REVOKE select on sc_lims_dal.specification_bom_item FROM GROUP grp_university_students;
REVOKE select on sc_lims_dal.specification_bom_item_full FROM GROUP grp_university_students;
REVOKE select on sc_lims_dal.specification_classification FROM GROUP grp_university_students;
REVOKE select on sc_lims_dal.specification_data FROM GROUP grp_university_students;
REVOKE select on sc_lims_dal.specification_keyword FROM GROUP grp_university_students;
REVOKE select on sc_lims_dal.specification_part FROM GROUP grp_university_students;
REVOKE select on sc_lims_dal.specification_property FROM GROUP grp_university_students;
REVOKE select on sc_lims_dal.specification_section FROM GROUP grp_university_students;
--
REVOKE select on sc_lims_dal_ai.ai_method FROM GROUP grp_university_students;
REVOKE select on sc_lims_dal_ai.ai_method_cell FROM GROUP grp_university_students;
REVOKE select on sc_lims_dal_ai.ai_sample FROM GROUP grp_university_students;
REVOKE select on sc_lims_dal_ai.ai_sample_part_no_groupkey FROM GROUP grp_university_students;
REVOKE select on sc_lims_dal_ai.ai_spec_bom_item_current_tree FROM GROUP grp_university_students;
REVOKE select on sc_lims_dal_ai.ai_specification FROM GROUP grp_university_students;
REVOKE select on sc_lims_dal_ai.ai_specification_bom_header FROM GROUP grp_university_students;
REVOKE select on sc_lims_dal_ai.ai_specification_bom_item FROM GROUP grp_university_students;
REVOKE select on sc_lims_dal_ai.ai_specification_bom_item_full FROM GROUP grp_university_students;
REVOKE select on sc_lims_dal_ai.ai_specification_data FROM GROUP grp_university_students;
REVOKE select on sc_lims_dal_ai.ai_specification_property FROM GROUP grp_university_students;
*/


select 'REVOKE ' || substring(
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
              || ' on '||namespace||'.'||item ||' FROM lims_dev_user;' as grantsql
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

/*
REVOKE select  on sc_interspec_ens.access_group FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.approval_history FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.association FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.atfuncbom FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.atfuncbomdata FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.atfuncbomworkarea FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.attached_specification FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.attribute FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.avarticleprices FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_interspec_ens.avspecification_weight FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.bom_header FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.bom_item FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.characteristic FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.characteristic_association FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.class3 FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.frame_header FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.frame_kw FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.frame_prop FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.frame_section FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.header FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.header_h FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.itbomly FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.itbomlyitem FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.itbomlysource FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.itclat FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.itcld FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.itcltv FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.itfrmdel FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.itkw FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.itkwas FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.itkwch FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.itlang FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.itlimsconfly FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.itlimsjob FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.itlimstmp FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.itmfc FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.itmfcmpl FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.itmpl FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.itoid FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.itoih FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.itplgrp FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.itplgrplist FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.itpp_del FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.itprcl FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.itprmfc FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.itshdel FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.itshq FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.itup FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.itus FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.layout FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.material_class FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.part FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.part_plant FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.plant FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.property FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.property_display FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.property_group FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.property_group_display FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.property_group_h FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.property_group_list FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.property_h FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.property_layout FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.property_test_method FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.reason FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.ref_text_type FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_interspec_ens.reference_text FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.section FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.section_h FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.specdata FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.specification_header FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.specification_kw FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.specification_prop FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.specification_section FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_interspec_ens.specification_text FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.status FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.status_history FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.sub_section FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.sub_section_h FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.test_method FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.text_type FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.uom FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.user_group FROM lims_dev_user;
REVOKE select  on sc_interspec_ens.user_group_list FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.ataoactions FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.ataoconditions FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.atavmethodclass FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.atavprojects FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.atictrhs FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.atmetrhs FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.atpatrhs FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.atrqtrhs FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.atsctrhs FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utad FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utadau FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utau FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utblob FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utdd FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utdecode FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.uteq FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.uteqau FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.uteqcd FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.uteqtype FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.uterror FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utgkmelist FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utgkrqlist FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utgkrtlist FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utgksclist FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utgkstlist FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utgkwslist FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utie FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utieau FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utielist FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utip FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utipie FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utlab FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utlc FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utlcaf FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utlchs FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utlctr FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utlongtext FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utly FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utmt FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utmtau FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utmtcell FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utmtcelllist FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utmths FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utpp FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utppau FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utpppr FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utppprau FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utpr FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utprau FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utprhs FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utprmt FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utprmtau FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utrq FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utrqau FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utrqgk FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utrqgkisrelevant FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utrqgkistest FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utrqgkrequestcode FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utrqgkrqday FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utrqgkrqexecutionweek FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utrqgkrqmonth FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utrqgkrqstatus FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utrqgkrqweek FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utrqgkrqyear FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utrqgksite FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utrqgktestlocation FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utrqgktesttype FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utrqgkworkorder FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utrqhs FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utrqic FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utrqii FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utrscme FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utrscmecell FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utrscmecelllist FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utrscpa FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utrscpaspa FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utrscpg FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utrt FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utrtau FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utrtgkrequesterup FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utrtgkspec_type FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utrtip FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utsc FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utscau FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utscgk FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utscgkcontext FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utscgkistest FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utscgkpart_no FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utscgkpartgroup FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utscgkproject FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utscgkrequestcode FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utscgkrimcode FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utscgksccreateup FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utscgksclistup FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utscgkscreceiverup FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utscgksite FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utscgkspec_type FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utscgkweek FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utscgkworkorder FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utscgkyear FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utschs FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utscic FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utscii FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utscme FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utscmeau FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utscmecell FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utscmecelllist FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utscmegk FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utscmegkavtestmethod FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utscmegkavtestmethoddesc FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utscmegkequipement FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utscmegkequipment_type FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utscmegkimportid FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utscmegkkindofsample FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utscmegklab FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utscmegkme_is_relevant FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utscmegkpart_no FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utscmegkrequestcode FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utscmegkscpriority FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utscmegktm_position FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utscmegkuser_group FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utscmegkweek FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utscmegkyear FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utscmehs FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utscmehsdetails FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utscpa FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utscpaau FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utscpahs FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utscpaspa FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utscpg FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utscpgau FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utss FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utst FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utstau FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utstgk FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utstgkcontext FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utstgkistest FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utstgkproduct_range FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utstgkspec_type FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utsths FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utstpp FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utup FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utupau FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utuppref FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utupus FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utupuspref FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utws FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utwsau FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utwsgk FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utwsgkavtestmethod FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utwsgkavtestmethoddesc FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utwsgknumberofrefs FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utwsgknumberofsets FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utwsgknumberofvariants FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utwsgkoutsource FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utwsgkp_infl_front FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utwsgkp_infl_rear FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utwsgkrefsetdesc FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utwsgkrequestcode FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utwsgkrim FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utwsgkrimetfront FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utwsgkrimetrear FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utwsgkrimwidthfront FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utwsgkrimwidthrear FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utwsgkspec_type FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utwsgksubprogramid FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utwsgktestlocation FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utwsgktestprio FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utwsgktestsetsize FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utwsgktestvehicletype FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utwsgktestweek FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utwsgkwsprio FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utwsgkwstestlocation FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utwsgkwsvehicle FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utwshs FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utwsii FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utwsme FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utwssc FROM lims_dev_user;
REVOKE select  on sc_unilab_ens.utwt FROM lims_dev_user;
--
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.frame FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.frame_keyword FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.method FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.method_attributes FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.method_cell FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.method_data_time_info FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.method_group_key FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.method_history FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.method_reanalysis FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.parameter FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.parameter_attributes FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.parameter_data_time_info FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.parameter_group FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.parameter_group_attributes FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.parameter_group_data_time_info FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.parameter_history FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.parameter_reanalysis FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.parameter_specifications FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.request FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.request_attributes FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.request_data_time_info FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.request_group_key FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.request_history FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.request_info_card FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.request_info_field FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.sample FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.sample_attributes FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.sample_data_time_info FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.sample_group_key FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.sample_history FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.sample_info_card FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.sample_info_field FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.sample_part_no_groupkey FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.sample_part_no_info_card FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.spec_bom_item_current_tree FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.spec_part_manufacturer FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.spec_part_plant FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.specification FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.specification_bom_header FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.specification_bom_item FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.specification_bom_item_full FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.specification_classification FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.specification_data FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.specification_keyword FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.specification_part FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.specification_property FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal.specification_section FROM lims_dev_user;
--
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal_ai.ai_method FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal_ai.ai_method_cell FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal_ai.ai_sample FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal_ai.ai_sample_part_no_groupkey FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal_ai.ai_spec_bom_item_current_tree FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal_ai.ai_specification FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal_ai.ai_specification_bom_header FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal_ai.ai_specification_bom_item FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal_ai.ai_specification_bom_item_full FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal_ai.ai_specification_data FROM lims_dev_user;
REVOKE select ,update ,insert ,delete ,rule ,references ,trigger  on sc_lims_dal_ai.ai_specification_property FROM lims_dev_user;
*/

--OR revoke DIRECT-SELECT on tables for seperate tables to USERS:
revoke select on table sc_lims_dal.frame from usr_peter_s;
revoke select on table sc_lims_dal.request from usr_peter_s;

select 'REVOKE ' || substring(
                case when charindex('r',split_part(split_part(array_to_string(relacl, '|'),'usr_peter_s=',2 ) ,'/',1)) > 0 then ',select ' else '' end 
              ||case when charindex('w',split_part(split_part(array_to_string(relacl, '|'),'usr_peter_s=',2 ) ,'/',1)) > 0 then ',update ' else '' end 
              ||case when charindex('a',split_part(split_part(array_to_string(relacl, '|'),'usr_peter_s=',2 ) ,'/',1)) > 0 then ',insert ' else '' end 
              ||case when charindex('d',split_part(split_part(array_to_string(relacl, '|'),'usr_peter_s=',2 ) ,'/',1)) > 0 then ',delete ' else '' end 
              ||case when charindex('R',split_part(split_part(array_to_string(relacl, '|'),'usr_peter_s=',2 ) ,'/',1)) > 0 then ',rule ' else '' end 
              ||case when charindex('x',split_part(split_part(array_to_string(relacl, '|'),'usr_peter_s=',2 ) ,'/',1)) > 0 then ',references ' else '' end 
              ||case when charindex('t',split_part(split_part(array_to_string(relacl, '|'),'usr_peter_s=',2 ) ,'/',1)) > 0 then ',trigger ' else '' end 
              ||case when charindex('X',split_part(split_part(array_to_string(relacl, '|'),'usr_peter_s=',2 ) ,'/',1)) > 0 then ',execute ' else '' end 
              ||case when charindex('U',split_part(split_part(array_to_string(relacl, '|'),'usr_peter_s=',2 ) ,'/',1)) > 0 then ',usage ' else '' end 
              ||case when charindex('C',split_part(split_part(array_to_string(relacl, '|'),'usr_peter_s=',2 ) ,'/',1)) > 0 then ',create ' else '' end 
              ||case when charindex('T',split_part(split_part(array_to_string(relacl, '|'),'usr_peter_s=',2 ) ,'/',1)) > 0 then ',temporary ' else '' end 
              , 2,10000)
              || ' on '||namespace||'.'||item ||' FROM usr_peter_s;' as grantsql
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
/*
REVOKE select  on sc_lims_dal_ai.ai_method FROM usr_peter_s;
REVOKE select  on sc_lims_dal_ai.ai_method_cell FROM usr_peter_s;
REVOKE select  on sc_lims_dal_ai.ai_sample FROM usr_peter_s;
REVOKE select  on sc_lims_dal_ai.ai_sample_part_no_groupkey FROM usr_peter_s;
REVOKE select  on sc_lims_dal_ai.ai_spec_bom_item_current_tree FROM usr_peter_s;
REVOKE select  on sc_lims_dal_ai.ai_specification FROM usr_peter_s;
REVOKE select  on sc_lims_dal_ai.ai_specification_bom_header FROM usr_peter_s;
REVOKE select  on sc_lims_dal_ai.ai_specification_bom_item FROM usr_peter_s;
REVOKE select  on sc_lims_dal_ai.ai_specification_bom_item_full FROM usr_peter_s;
REVOKE select  on sc_lims_dal_ai.ai_specification_data FROM usr_peter_s;
REVOKE select  on sc_lims_dal_ai.ai_specification_property FROM usr_peter_s;
*/



--end-of-script

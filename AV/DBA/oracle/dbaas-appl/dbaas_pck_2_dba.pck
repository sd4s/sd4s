CREATE OR REPLACE  PACKAGE "DBAAS"."DBAAS_DBA" 
as
 -- TYPE vartable IS TABLE OF VARCHAR2(4000) INDEX BY VARCHAR2(30);
type file_array is table of varchar2(2048);
--Geef de versie weer van dit package.
function  version return varchar2;
--
--log. logging via dbms_output naar sysout;
procedure log (p_msg in varchar2);
--
function get_host return varchar2;
--*********************************************************************************************************************
--*********************************************************************************************************************
--*********************************************************************************************************************

--** Aanmaken van een database gebruiker.<br />
-- *
-- * Het betreft hier een generieke procedure. Naamgeving wordt afgedwongen via publieke package "DBAAS".<br />
-- * @param  P_NAME     Naam van de gebruiker.<br />
-- * @param  P_PASSWORD Wachtwoord voor deze gebruiker. Kan met gen_password geforceerd worden.<br />
-- * @param  P_DEF_TBS  Default tablespace.  <br />
-- * @param  P_TMP_TBS  Temporary tablespace <br />
-- * @param  P_PWD_EXP  Password expired? . Default true.<br />
-- * @param  P_UNLOCK   Account unlock? Default true.<br />
-- * @throws user_exists Gebruiker bestaat. Geen raise exceptie.
--
  procedure create_user     (p_name             in varchar2
                            ,p_password         in varchar2
                            ,p_def_tbs          in varchar2  default null
                            ,p_tmp_tbs          in varchar2  default null
                            ,p_pwd_exp          in boolean   default false
                            ,p_unlock           in boolean   default true
                            );

--** Aanpassen een database gebruiker.  <br />
-- * Het betreft hier een generieke procedure. Naamgeving wordt afgedwongen via publieke package "DBAAS".<br />
-- *
-- * @param  P_USER     Naam van de gebruiker.<br />
-- * @param  P_ACCOUNT     Account ?.<br />
-- * @param  P_DEFAULT_ROLE     Default role.<br />
-- * @param  P_EXCEPT_ROLE     Except role.<br />
-- * @param  P_QUOTA     Quota toegekend op P_TABLEPSACE.<br />
-- * @param  P_TABLESPACE     Naam van de tablespace.<br />
-- * @param  P_PASSWORD     Wachtwoord voor deze gebruiker.<br />
-- * @param  P_PROFILE      profile voor de gebruiker.
-- * @throws invalid_account Gebruiker bestaat niet. Geen raise exceptie.
-- * @see <a href="DBAAS_DBA.html#gen_password">DBAAS_DBA.GEN_PASSWORD</a>
-- *
  procedure alter_user      (p_name             in varchar2
                            ,p_account          in varchar2  default null
                            ,p_default_role     in varchar2  default null
                            ,p_except_role      in varchar2  default null
                            ,p_quota            in varchar2  default null
                            ,p_tablespace       in varchar2  default null
                            ,p_password         in varchar2  default null
                            ,p_profile          in varchar2  default null
                            ,p_connect_through  in varchar2  default null
                            );
 
--** Verwijder (cascading) een database gebruiker.  <br />
-- * Het betreft hier een generieke procedure. Naamgeving wordt afgedwongen via publieke package "DBAAS".<br />
-- *
-- * @param  p_user     Naam van de gebruiker.<br />
-- * @throws user_doesnot_exists Gebruiker bestaat. Geen raise exceptie.
-- *
  procedure drop_user        (p_user in varchar2);

--** Lock de user.
-- *
-- * @param  p_user         Naam van de database user.<br />
-- *
  procedure lock_user_otap    (p_user in varchar2);

--** Unlock de user. In de ontwikkelomgeving (O) wordt de lock
-- *
-- * @param  p_user         Naam van de database user.<br />
-- *
  procedure unlock_user_otap    (p_user in varchar2);

--** Genereer een random wachtwoord voor een gebruiker. Length = 8.
-- * @return wachtwoord.
-- *
  function gen_password  return varchar2;


--*********************************************************************************************************************
--*********************************************************************************************************************
--*********************************************************************************************************************


--** Aanpassen een database service. Formaat: <OTAP-letter>.<APP_NAME> <br />
-- * Het betreft hier om een genrieke routine. Naamgeving komt via package DBAAS.
-- *
-- * @param  P_SERVICE     Naam van de Service.<br />
-- * @throws service_existst Service bestaat reeds. Geen raise exceptie.
-- *
 procedure create_service(p_service in varchar2, p_standby boolean default NULL);

--** Start een database service. Formaat: <OTAP-letter>.<APP_NAME> <br />
-- * Het betreft hier om een genrieke routine. Naamgeving komt via package DBAAS.
-- *
-- * @param  P_SERVICE     Naam van de Service.<br />
-- * @throws service_doesnot_existst Service bestaat niet. Geen raise exceptie.
-- * @throws service_is_running  Service is reeds gestart. Geen raise exceptie.
-- *
 procedure start_service(p_service in varchar2);

--** Stop een database service. Formaat: <OTAP-letter>.<APP_NAME> <br />
-- * Het betreft hier om een genrieke routine. Naamgeving komt via package DBAAS.
-- *
-- * @param  P_SERVICE     Naam van de Service.<br />
-- * @throws service_doesnot_existst Service bestaat niet. Geen raise exceptie.
-- * @throws service_is_not_running  Service is reeds gestopt. Geen raise exceptie.
-- *
 procedure stop_service(p_service in varchar2);

--** Verwijder een database service. Formaat: <OTAP-letter>.<APP_NAME> <br />
-- * Het betreft hier om een genrieke routine. Naamgeving komt via package DBAAS.
-- *
-- * @param  P_SERVICE     Naam van de Service.<br />
-- * @throws service_doesnot_exists Service bestaat niet. Geen raise exceptie.
-- *
 procedure delete_service(p_service in varchar2);

--** Disconnect sessie(s) van  een database service. Formaat: <OTAP-letter>.<APP_NAME> <br />
-- * Het betreft hier om een genrieke routine. Naamgeving komt via package DBAAS.
-- * 
-- * @param  P_SERVICE     Naam van de Service.<br />
-- * @throws service_existst Service bestaat reeds. Geen raise exceptie.
-- *
 procedure disconnect_from_service(p_service in varchar2);

--*********************************************************************************************************************
--*********************************************************************************************************************
--*********************************************************************************************************************

--** Aanmaken van een database rol.<br />
-- * Het betreft hier een generieke procedure. Naamgeving wordt afgedwongen via publieke package "DBAAS".<br />
-- *
-- * @param  P_NAME     Naam van de role.<br />
-- * @throws role_exists Rol bestaat reeds. Geen raise exceptie.
-- *
  procedure create_role(p_name in varchar2);

--** Verwijder van een database rol.<br />
-- * Het betreft hier een generieke procedure. Naamgeving wordt afgedwongen via publieke package "DBAAS".<br />
-- * 
-- * @param  P_NAME     Naam van de role.<br />
-- * @throws role_doesnot_exists Rol bestaat niet. Geen raise exceptie.
-- *
  procedure drop_role(p_name in varchar2);

--** Ken een database rol toe aan een database gebruiker/rol.<br />
-- * Het betreft hier een generieke procedure. Naamgeving wordt afgedwongen via publieke package "DBAAS".<br />
-- * 
-- * @param  P_ROLE     Naam van de role.<br />
-- * @param  P_GRANTEE  Naam van de gebruiker/rol.<br />
-- * @throws role_doesnot_exists Rol bestaat niet. Geen raise exceptie.
-- * @throws user_doesnot_exists Gebruiker bestaat niet. Geen raise exceptie.
-- *
  procedure grant_role      (p_role             in varchar2
                            ,p_grantee          in varchar2
                            ,p_with_admin       in boolean default false
                            );

--** Ontneemt een database rol van een database gebruiker/rol.<br />
-- * Het betreft hier een generieke procedure. Naamgeving wordt afgedwongen via publieke package "DBAAS".<br />
-- *
-- * @param  P_ROLE     Naam van de role.<br />
-- * @param  P_GRANTEE  Naam van de gebruiker/rol.<br />
-- * @throws role_doesnot_exists Rol bestaat niet. Geen raise exceptie.
-- * @throws user_doesnot_exists Gebruiker bestaat niet. Geen raise exceptie.
-- *
  procedure revoke_role      (p_role             in varchar2
                             ,p_grantee          in varchar2
                             );

--**
-- * Ken een systeem-privilege toe aan een gebruiker/rol.<br />
-- * Het betreft hier een generieke procedure. Naamgeving wordt afgedwongen via publieke package "DBAAS".<br />
-- * 
-- * @param  P_PRIVILEGE Naam van het systeem privilege.<br />
-- * @param  P_GRANTEE   Naam van de gebruiker/rol.<br />
-- * @throws priv_doesnot_exists Privilege bestaat niet. Geen raise exceptie.
-- * @throws user_doesnot_exists Gebruiker bestaat niet. Geen raise exceptie.
-- *
  procedure grant_sys_priv  (p_privilege        in varchar2
                            ,p_grantee          in varchar2
                            ,p_with_admin       in boolean default false
                            );

--** Ontneemt een systeem-privilege toe van een gebruiker/rol.<br />
-- * Het betreft hier een generieke procedure. Naamgeving wordt afgedwongen via publieke package "DBAAS".<br />
-- * 
-- * @param  P_PRIVILEGE Naam van het systeem privilege.<br />
-- * @param  P_GRANTEE   Naam van de gebruiker/rol.<br />
-- * @throws user_doesnot_exists Gebruiker bestaat niet. Geen raise exceptie.
-- *
  procedure revoke_sys_priv  (p_privilege        in varchar2
                              ,p_grantee          in varchar2
                            );
                            
--** Ken een object-privilege toe aan een gebruiker/rol.<br />
-- * Het betreft hier een generieke procedure. Naamgeving wordt afgedwongen via publieke package "DBAAS".<br />
-- *
-- * @param  P_PRIVILEGE  Naam van het object privilege.<br />
-- * @param  P_OWNER      Naam van de object eigenaar.<br />
-- * @param  P_OBJECT     Naam van het object.<br />
-- * @param  P_WITH_GRANT met grant optie. Default is false.<br />
-- * @throws priv_doesnot_exists Privilege bestaat niet. Geen raise exceptie.
-- * @throws user_doesnot_exists Gebruiker bestaat niet. Geen raise exceptie.
-- *
  procedure grant_obj_priv   (p_privilege        in varchar2
                            ,p_owner            in varchar2
                            ,p_object           in varchar2
                            ,p_grantee          in varchar2
                            ,p_with_grant       in boolean default false
                            );                            
--** Ontneem een object-privilege van een gebruiker/rol.<br />
-- * Het betreft hier een generieke procedure. Naamgeving wordt afgedwongen via publieke package "DBAAS".<br />
-- *
-- * @param  P_PRIVILEGE  Naam van het object privilege.<br />
-- * @param  P_OWNER      Naam van de object eigenaar.<br />
-- * @param  P_OBJECT     Naam van het object.<br />
-- * @throws priv_doesnot_exists Privilege bestaat niet. Geen raise exceptie.
-- * @throws user_doesnot_exists Gebruiker bestaat niet. Geen raise exceptie.
-- *
  procedure revoke_obj_priv   (p_privilege        in varchar2
                              ,p_owner            in varchar2
                              ,p_object           in varchar2
                              ,p_grantee          in varchar2
                              );
  --
  procedure create_direct_grants(p_owner varchar2, p_role varchar2, p_admin boolean default FALSE);
  --
  procedure restore_grants(p_schema varchar2 default NULL);
  procedure create_grants(p_schema varchar2 default NULL);


--*********************************************************************************************************************
--*********************************************************************************************************************
--*********************************************************************************************************************

--** Kill sessie gerelateerde aan aan user.<br />
-- * 
-- * @param  P_USER  Volledige naam van de database user.<br />
-- * @throws Application_schema_doesnot_exists - Applciatie schema bestaat niet. Geen raise exceptie.
-- *
 procedure kill_session    (p_user in varchar2);

--** Kill applicatie-owner gerelateerde sessies.<br />
-- *
-- * @param  P_APP  Applicatie prefix letters.<br />
-- * @throws Application_schema_doesnot_exists - Applciatie schema bestaat niet. Geen raise exceptie.
-- *
  procedure kill_app_sessions(p_app in varchar2);

--*********************************************************************************************************************
--*********************************************************************************************************************
--*********************************************************************************************************************

--** Grant tablespace quota aan een bepaalde bepaalde user.<br />
-- *
-- * @param  p_user   De gebruiker die het quota moet krijgen <br />
-- * @param  p_tbs    De gebruiker die het quota moet krijgen <br />
-- * @param  p_quota  De gebruiker die het quota moet krijgen <br />
-- * @throws Application_schema_doesnot_exists - Applciatie schema bestaat niet. Geen raise exceptie.
-- *
  procedure grant_tbs_quota (p_user in varchar2, p_tbs in varchar2, p_quota in varchar2);


--** Verwijder een tablespace(s) voor 1 applicatie obv prefix.<br />
-- *
-- * @param  P_APP  Applicatie prefix.<br />
-- *
  procedure drop_app_tbs    (p_app     in varchar2);

--*********************************************************************************************************************
--*********************************************************************************************************************
--*********************************************************************************************************************


--**  Maak lokale procedure aan voor het uitvoeren van SQL.<br />
--*  Nodig voor o.a het aanmaken van een schema-specifieke database link.
--* 
--* @param p_schema	Het schema waar de procedure aangemaakt moet worden.
--*
  procedure create_prc_execsql   (p_schema in varchar2);

--** Verwijder lokale procedure aan voor het uitvoeren van SQL.<br />
--* @param p_schema	Het schema waar de procedure verwijderd moet worden.
--*
  procedure drop_prc_execsql     (p_schema in varchar2);

--*********************************************************************************************************************
--*********************************************************************************************************************
--*********************************************************************************************************************

  
--** Maak een oracle directory aan. <br />
-- *
-- * @param p_oracle_directory	Naam voor de oracle directory.
-- * @param p_physical_directory	Naam van de physieke directory.
-- * @param p_schema		Naam van granted schema.          
-- *
  procedure create_oracle_directory   (p_oracle_dir   in varchar2
                                      ,p_physical_dir in varchar2
                                      ,p_schema       in varchar2);
  
--*********************************************************************************************************************
--*********************************************************************************************************************
--*********************************************************************************************************************
  

--** Pas het wachtwoord aan voor credential DBAAS_OS_CRED.<br />
-- *
-- * @param p_password	Het wachtwoord voor de credential.
-- *
  procedure set_os_cred_password   (p_password in varchar2);

--** set_os_cred_password - Pas het wachtwoord aan voor credential DBAAS_OS_CRED.<br />
-- *
-- * @param p_password	Het wachtwoord voor de credential.
-- *
  procedure set_db_cred_password   (p_password in varchar2);

--** Bepaal schema stats. <br />
-- *
-- * @param p_schema             Naam voor de oracle directory.
-- * @param p_estimate_percent	Naam van de physieke directory.
-- * @param p_block_sample	Naam van granted schema.          
-- * @param p_method_opt  	Naam van granted schema.          
-- * @param p_degree		Naam van granted schema.          
-- * @param p_granularity	Naam van granted schema.          
-- * @param p_cascade		Naam van granted schema.          
-- * @param p_stattab		Naam van granted schema.          
-- * @param p_statid		Naam van granted schema.          
-- * @param p_options		Naam van granted schema.          
-- * @param p_statown		Naam van granted schema.          
-- * @param p_no_invalidate	Naam van granted schema.          
-- * @param p_force		Naam van granted schema.          
-- *
  procedure gather_schema_stats  
            (p_schema           varchar2
            ,p_estimate_percent number   default null
            ,p_block_sample     boolean  default false
            ,p_method_opt       varchar2 default 'FOR ALL COLUMNS SIZE 1'
            ,p_degree           number   default null
            ,p_granularity      varchar2 default 'DEFAULT'
            ,p_cascade          boolean  default false
            ,p_stattab           varchar2 default null
            ,p_statid           varchar2 default null
            ,p_options          varchar2 default 'GATHER'
            ,p_statown          varchar2 default null
            ,p_no_invalidate    boolean  default false
            ,p_force            boolean  default false
            );
            
--*********************************************************************************************************************
--*********************************************************************************************************************
--*********************************************************************************************************************
 


--** Pas de tablespace van een spatial index door een rebuild te doen voor bepaald schema
-- *
-- * @param p_schema	De naam van het schema waar de spatial indexes omgezet moeten worden.
-- * @param p_tbs_orig	De naam van het originele tablespace dat aangepast moet worden.
-- * @param p_tbs_new      De naam van het nieuwe tablespace waar de spatial indexen komen te staan.
-- *
  procedure remap_spatial_index_tbs(p_schema in varchar2, p_tbs_orig varchar2, p_tbs_new varchar2);


--*********************************************************************************************************************
--*********************************************************************************************************************
--*********************************************************************************************************************


--** Enable de constraints voor een schema.
-- * 
-- * @param p_schema 	De naam van het schema waarvoor de constraints aangezet moeten worden.
-- *
  procedure enable_constraints(p_schema varchar2, p_table varchar2 default null);

--** Disable de constraints voor een schema.
-- * 
-- * @param p_schema 	De naam van het schema waarvoor de constraints uitgezet moeten worden.
-- *
  procedure disable_constraints(p_schema varchar2, p_table varchar2 default null);

--** Enable de triggers voor een schema.
-- *
-- * @param p_schema	De naam van het schema waarvoor de triggers aangezet moeten worden.
-- *
  procedure enable_triggers(p_schema varchar2, p_table varchar2 default null);

--** Disable de triggers voor een schema.
-- *
-- * @param p_schema	De naam van het schema waarvoor de triggers uitgezet moeten worden.
-- *
  procedure disable_triggers(p_schema varchar2, p_table varchar2 default null);

--*********************************************************************************************************************
--*********************************************************************************************************************
--*********************************************************************************************************************

  procedure create_synoniemen(p_schema varchar2 default null);
  --
  procedure reset_synoniemen(p_schema varchar2);
  --
  procedure restore_synoniemen(p_schema varchar2);
  --
  --fix_synoniemen: alle invalid synoniemen opzoeken en een keer gebruiken(zodat ze weer valid worden?)
  procedure fix_synoniemen;
  
--** Creeer public synonyms voor een schema, alleen naar DBMS_OUTPUT en wordt dus niet uitgevoerd.
-- *
-- * @param p_schema 	De naam van het schema waarvoor we public synoniemen cretae statements genereren.
-- *
  procedure create_public_synonyms(p_schema varchar2);

--*********************************************************************************************************************
--*********************************************************************************************************************
--*********************************************************************************************************************

--** Reset de trace_directories voor een schema of voor de hele database. 
-- *
-- * @param p_schema	De naam van het schema of PUBLIC, dat is dan de hele database
-- *
  procedure reset_trace_directories(p_schema varchar2);


--*********************************************************************************************************************
--*********************************************************************************************************************
--*********************************************************************************************************************
  
  procedure enable_job(p_schema varchar2, p_jobname varchar2);
  procedure disable_job(p_schema varchar2, p_jobname varchar2);
  
--*********************************************************************************************************************
--*********************************************************************************************************************
--*********************************************************************************************************************

  --function list_files(p_dir varchar2, p_filter in varchar2 default NULL) return file_array pipelined;
  --function list_files2(p_dir varchar2) return file_array pipelined;
  --function list_files3(p_dir varchar2, p_filename varCHAR2) return file_array pipelined;
  
--*********************************************************************************************************************
--*********************************************************************************************************************
--*********************************************************************************************************************


--*********************************************************************************************************************
--*********************************************************************************************************************
--*********************************************************************************************************************
--** Aanmaken van een database link naar een specifieke gebruiker (niet perse '_OWN'). Gebruikt om databaselinks in 'classic' stijl aan te maken, 
-- * zolang de applicaties niet aangepast zijn.
-- *
-- * @param  p_dump_file 	De naam van de dumpfile. Mag alleen de naam van de dumpfile zijn en moet eindigen op .dmp en mag geen pad bevatten.
-- * @param  p_link_name   De naam van de databaselink.
-- * @param  p_owner       Het schema wat eigenaar is van de link.
-- * @param  p_user        Het schema in de doel database.
-- * @param  p_password    Het wachtwoord van de gebruiker in de doel database.
-- * @param  p_host        De host waar de service draait, of standaard de cloud-db naam (host onafhankelijk).
-- * @param  p_port        De poort waarop de service te bereiken is (standaard 1521).
-- * @param  p_service     De service waar de databaselink naar toe wordt gelegd.
-- *
  procedure create_classic_dblink ( p_link_name in varchar2
                                  , p_owner     in varchar2
                                  , p_user      in varchar2
                                  , p_password  in varchar2
                                  , p_host      in varchar2 default 'cloud-db'
                                  , p_port      in varchar2 default 1521
                                  , p_service   in varchar2
                                  );
--** Controleer of een object in database VALID of INVALID is. Als het object niet bestaat wordt ook INVALID terug gegeven.
-- *
-- * @param  p_object  	De naam van het object dat gecontroleerd moet worden.
-- * @param  p_type        Het type object dat wordt gecontroleerd, bijv TABLE, PACKAGE BODY, SYNONYM, etc.
-- * @return De status van het object, VALID of INVALID.
-- *
  function object_valid(p_object varchar2, p_type varchar2 default 'PACKAGE BODY') return varchar2;
  --                                  
  procedure purge_recyclebin(p_schema varchar2);
  --						
  procedure flush_buffer_cache;
  --
  procedure switch_log_file;

  
end dbaas_dba;
/


CREATE OR REPLACE PACKAGE BODY "DBAAS"."DBAAS_DBA" 
as
  -- ============================================================================
  -- variables
  -- ============================================================================
  g_routine     varchar2(50)    := '-';
  g_otap        varchar2(1)     := '-';
  c_version     varchar2(128)   := 'Id: dbaas_dba.pkb 2018-04-16 14:52 schepensp';

  -- ============================================================================
  -- local routines
  -- ============================================================================

  procedure log (p_msg in varchar2) is
    l_date date default sysdate;
  begin
    dbms_output.put_line(to_char(l_date,'YYYYMMDDHH24MI') ||' '||g_routine||': '||p_msg);
  end;

  procedure log_logger (p_owner in varchar2, p_msg in varchar2) is
    l_stmnt varchar2(4000);
  begin
    l_stmnt := 'begin '|| p_owner || '.logger.log('''||g_routine||'; '|| p_msg ||'''); end;';
    begin
      execute immediate l_stmnt;
    exception
      when others then
         log ('fout in wegschrijven logging naar '||p_owner||' logtable;'|| sqlerrm );
    end;
  end;

  function version
  return varchar2
  is
  begin
    return c_version;
  end version;

  function get_host
  return varchar2
  is
  begin
    return (sys_context('USERENV','SERVER_HOST'));  
  end;


  -- ============================================================================
  -- public routines
  -- ============================================================================
  -- == CREATE_USER ============================================================
  --
  procedure create_user     (p_name             in varchar2
                            ,p_password         in varchar2
                            ,p_def_tbs          in varchar2  default null
                            ,p_tmp_tbs          in varchar2  default null
                            ,p_pwd_exp          in boolean   default false
                            ,p_unlock           in boolean   default true
                            )
  is
    l_stmt      varchar2(4000)  :='';
    l_def_tbs   varchar2(100)   :='';
    l_tmp_tbs   varchar2(100)   :='';
    l_pwd_exp   varchar2(100)   :='';
    l_unlock    varchar2(100)   :='';

    user_exists exception;
    pragma exception_init(user_exists, -1920);
  begin
    g_routine := 'create_user';
    log('start -->');
    if p_def_tbs is not null then
       l_def_tbs := 'default tablespace '||p_def_tbs;
    end if;
    if p_tmp_tbs is not null then
       l_tmp_tbs := 'temporary tablespace '||p_tmp_tbs;
    end if;
    if p_pwd_exp then
       l_pwd_exp := 'password expire';
    end if;
    if p_unlock then
       l_unlock := 'account unlock';
    else
       l_unlock := 'account lock';
    end if;

    l_stmt := 'create user '||p_name||' '||
              'identified by '||p_password||' '||
              l_def_tbs||' '||l_tmp_tbs||' '||
              l_pwd_exp||' '||l_unlock;
    log('l_stmt='||l_stmt);
    execute immediate l_stmt;
    alter_user(p_name => p_name, p_profile => 'KADASTER_APP_PROFILE');
    log('<-- end');
  exception
    when user_exists then
      log('User "'||p_name||'" already exists.');
  end create_user;
  --
  -- == ALTER_USER =============================================================
  --
  procedure alter_user      (p_name             in varchar2
                            ,p_account          in varchar2  default null
                            ,p_default_role     in varchar2  default null
                            ,p_except_role      in varchar2  default null
                            ,p_quota            in varchar2  default null
                            ,p_tablespace       in varchar2  default null
                            ,p_password         in varchar2  default null
                            ,p_profile          in varchar2  default null
                            ,p_connect_through  in varchar2  default null
							)
  is
    l_stmt              varchar2(4000);
    l_account           varchar2(100);
    l_quota             varchar2(100);
    l_default_role      varchar2(100);
    l_password          varchar2(100);
    l_profile           varchar2(100);
	l_connect           varchar2(100);
    invalid_account     exception;
  begin
--   ALTER user "WOZ_MUT" GRANT CONNECT THROUGH "DBAAS_LIQUIBASE"
    g_routine := 'alter user';
    log('start -->');
    if p_account is not null then
       if upper(p_account) not in ('LOCK','UNLOCK') then
          raise invalid_account;
       end if;
       l_account := 'account '||lower(p_account);
    end if;
    if (p_quota is not null or p_tablespace is not null ) then
       l_quota := 'quota '||p_quota||' on '||p_tablespace;
    end if;
    if p_default_role is not null then
       l_default_role := 'default role '||p_default_role;
    end if;
    if p_password is not null then
       l_password := ' identified by '||p_password;
    end if;
    if p_profile is not null then
       l_profile  := ' profile '||p_profile;
    end if;
	if p_connect_through is not null then 
	   l_connect := 'grant connect through '||p_connect_through;
	end if;
    l_stmt := 'alter user '||p_name||' '||l_account||' '||l_default_role||' ' ||l_password||' '||l_quota||' '||l_profile||' '||l_connect;
    log('l_stmt='||l_stmt);
    execute immediate l_stmt;
    log('<-- end');
  exception
    when invalid_account then
       log('ALERT: invalid account parameter value "'||p_account||'".');
  end alter_user;
  --
  -- == DROP_USER ==============================================================
  --
  procedure drop_user(p_user in varchar2)
  is
    l_stmt      varchar2(4000);
    user_doesnot_exists exception;
    pragma exception_init(user_doesnot_exists, -1918);
    dml_recyclebin exception;
    pragma exception_init(dml_recyclebin, -38301);
  begin
    g_routine := 'drop_user';
    log('start -->');
    l_stmt := 'drop user '||p_user||' cascade';
    log('l_stmt='||l_stmt);
    execute immediate l_stmt;
    log('<-- end');
    exception 
    when user_doesnot_exists then
       log('User '||p_user||' doesnot exists');
    when dml_recyclebin then
      log ('Fout bij DML op recyclebin'); 
      create_prc_execsql(p_user);
      l_stmt := 'purge recyclebin';
      execute immediate 'begin '||p_user||'.dbaas_execsql(:1); end;' using l_stmt;
      l_stmt := 'drop user '||p_user||' cascade';
      log('l_stmt='||l_stmt);
      execute immediate l_stmt;

  end drop_user;
  --
  -- == LOCK_USER OTAP =========================================================
  --
  procedure lock_user_otap(p_user in varchar2) is
  begin
    g_routine := 'lock_user_otap';
    log('start -->');
    log('alter user  '||p_user||' account lock');
    execute immediate 'alter user '||p_user||' account lock';
    log('<-- end');
  end lock_user_otap;
  --
  -- == UNLOCK_USER_OTAP =======================================================
  --
  procedure unlock_user_otap(p_user in varchar2) is
  begin
    g_routine := 'unlock_user_otap';
    log('start -->');
    log('alter user  '||p_user||' account unlock');
    execute immediate 'alter user '||p_user||' account unlock';
    log('<-- end');
  end unlock_user_otap;
  --
  -- ==GEN_PASSWORD ============================================================
  --
  function gen_password
  return    varchar2
  is
    l_password  varchar2(10);
  begin
    return dbms_random.string('u',8);
  end gen_password;
 
  --
  -- == CREATE_SERVICE =========================================================
  --
  procedure create_service(p_service in varchar2, p_standby boolean)
  is
    service_exists      exception;
    pragma exception_init(service_exists, -44303);
    l_service       varchar2(1024);
  begin

/* PS: ZOLANG DBAAS GEEN RECHTEN HEEFT VAN SYS OP DBMS-SERVICE deze aanroepen nog even uitsterren...  
    if p_standby 
    then
      l_service := p_service||'_INFORMATIE';
      begin
         dbms_service.create_service(service_name=>l_service, network_name=>l_service);
      exception when service_exists then
         log('Service "'||l_service ||'" already exists.' );
      end;
      l_service := p_service||'_QUERY';
      begin
         dbms_service.create_service(service_name=>l_service, network_name=>l_service);
      exception when service_exists then
         log('Service "'||l_service ||'" already exists.' );
      end;
      l_service := p_service||'_MUTATIE';
      begin
         dbms_service.create_service(service_name=>l_service, network_name=>l_service);
      exception when service_exists then
         log('Service "'||l_service ||'" already exists.' );
      end;
      l_service := p_service||'_LOAD';
      begin
         dbms_service.create_service(service_name=>l_service, network_name=>l_service);
      exception when service_exists then
         log('Service "'||l_service ||'" already exists.' );
      end;
    end if;
    g_routine := 'create_service';
    dbms_service.create_service(service_name=>p_service, network_name=>p_service);
*/    
    log('Service : '||p_service ||' created');
    log('<-- end');
  exception
    when service_exists then
         log('Service "'||p_service ||'" already exists.' );
  end create_service;
  --
  -- == START_SERVICE ==========================================================
  --
  procedure start_service(p_service in varchar2)
  is
    service_doesnot_exists      exception;
    service_is_running          exception;
    pragma exception_init(service_doesnot_exists, -44304);
    pragma exception_init(service_is_running, -44305);
  begin
    g_routine := 'start_service';
    log('start -->');
/* PS: ZOLANG DBAAS GEEN RECHTEN HEEFT VAN SYS OP DBMS-SERVICE deze aanroepen nog even uitsterren...  
    dbms_service.start_service(service_name=>p_service);
*/
    log('start service : "'||p_service||'".' );
    log('<-- end');
  exception
    when service_doesnot_exists then
         log('Service "'||p_service ||'" does not exists.' );
    when service_is_running then
         log('Service "'||p_service ||'" is already running.' );
  end start_service;
  --
  -- == STOP_SERVICE ==========================================================
  --
  procedure stop_service(p_service in varchar2)
  is
    service_doesnot_exists      exception;
    service_is_not_running      exception;
    pragma exception_init(service_doesnot_exists, -44304);
    pragma exception_init(service_is_not_running, -44311);
  begin
    g_routine := 'stop_service';
    log('start -->');
/* PS: ZOLANG DBAAS GEEN RECHTEN HEEFT VAN SYS OP DBMS-SERVICE deze aanroepen nog even uitsterren...  
    dbms_service.stop_service(service_name=>p_service);
*/
    log('stop service : "'||p_service||'"' );
    log('<-- end');
  exception
    when service_doesnot_exists then
         log('Service "'||p_service ||'" does not exists.' );
    when service_is_not_running then
         log('Service "'||p_service ||'" is not running.' );
  end stop_service;
  --
  -- == DELETE_SERVICE ==========================================================
  --
  procedure delete_service(p_service in varchar2)
  is
    service_doesnot_exists      exception;
    pragma exception_init(service_doesnot_exists, -44304);
  begin
    g_routine := 'delete_service';
    log('start -->');
/* PS: ZOLANG DBAAS GEEN RECHTEN HEEFT VAN SYS OP DBMS-SERVICE deze aanroepen nog even uitsterren...  
    dbms_service.delete_service(service_name=>p_service);
*/    
    log('delete service : "'||p_service||'"' );
    log('<-- end');
  exception
    when service_doesnot_exists then
         log('Service "'||lower(p_service) ||'" does not exists.' );
  end delete_service;
  --
  -- == DISCONNECT_FROM_SERVICE ==========================================================
  --
  procedure disconnect_from_service(p_service in varchar2)
  is
    service_doesnot_exists      exception;
    pragma exception_init(service_doesnot_exists, -44304);
  begin
    g_routine := 'disconnect_from_service';
    log('start -->');
/* PS: ZOLANG DBAAS GEEN RECHTEN HEEFT VAN SYS OP DBMS-SERVICE deze aanroepen nog even uitsterren...  
    dbms_service.disconnect_session(service_name=>p_service);
*/
    log('disconnect service : "'||p_service||'"' );
    log('<-- end');
  exception
    when service_doesnot_exists then
         log('Service "'||lower(p_service) ||'" does not exists.' );
  end disconnect_from_service;
  --
--*********************************************************************************************************************
--*********************************************************************************************************************
--*********************************************************************************************************************
  --
  -- == CREATE_ROLE ============================================================
  --
  procedure create_role(p_name in varchar2)
  is
    l_stmt      varchar2(4000);
    role_exists exception;
    pragma exception_init(role_exists, -1921);
  begin
    g_routine := 'create_role';
    log('start -->');
    l_stmt := 'create role '||p_name;
    execute immediate l_stmt;
    log('create role '||p_name);
    log('<-- end');
  exception
    when role_exists then
       log('Role "'||upper(p_name) ||'" already exists.' );
  end create_role;
  --
  -- == DROP_ROLE ==============================================================
  --
  procedure drop_role(p_name in varchar2)
  is
    l_stmt      varchar2(4000);
    role_doesnot_exists exception;
    -- pragma exception_init(role_doesnot_exists, -1924);
    pragma exception_init(role_doesnot_exists, -1919);
  begin
   begin
    g_routine := 'drop_role';
    log('start -->');
    l_stmt := 'drop role '||p_name;
    execute immediate l_stmt;
    log('drop role '||p_name);
    log('<-- end');
   exception
    when role_doesnot_exists then
       log('Role "'||upper(p_name) ||'" doesnot exists.' );
   end;
  end drop_role;
  --
  -- == GRANT_ROLE =============================================================
  --
  procedure grant_role      (p_role             in varchar2
                            ,p_grantee          in varchar2
                            ,p_with_admin       in boolean default false
                            )
  is
     l_stmt     varchar2(4000);
     role_doesnot_exists     exception;
     user_doesnot_exists     exception;
     pragma exception_init(role_doesnot_exists,-1919);
     pragma exception_init(user_doesnot_exists,-1917);
  begin
    g_routine := 'grant_role';
    log('start -->');
    if p_with_admin then
       l_stmt := 'grant '||p_role||' to '||p_grantee||' with admin option';
    else
       l_stmt := 'grant '||p_role||' to '||p_grantee;
    end if;
    log('l_stmt='||l_stmt);
    execute immediate l_stmt;
    log('<-- end');
  exception
    when user_doesnot_exists then
        log('ALERT: user/role "'||p_grantee||'" doesnot exists.');
    when role_doesnot_exists then
        log('ALERT: role "'||p_role||'" doesnot exists.');
    when others then
      raise_application_error(-20000,sqlerrm);
  end grant_role;
  --
  -- == REVOKE_ROLE =============================================================
  --
  procedure revoke_role      (p_role             in varchar2
                             ,p_grantee          in varchar2
                             )
  is
     l_stmt     varchar2(4000);
     role_doesnot_exists     exception;
     user_doesnot_exists     exception;
     pragma exception_init(role_doesnot_exists,-1919);
     pragma exception_init(user_doesnot_exists,-1917);
  begin
    g_routine := 'revoke_role';
    log('start -->');
    l_stmt := 'revoke '||p_role||' from '||p_grantee;
    log('l_stmt='||l_stmt);
    execute immediate l_stmt;
    log('<-- end');
  exception
    when user_doesnot_exists then
        log('ALERT: user/role "'||p_grantee||'" doesnot exists.');
    when role_doesnot_exists then
        log('ALERT: role "'||p_role||'" doesnot exists.');
    when others then
      raise_application_error(-20000,sqlerrm);
  end revoke_role;
  --
  -- == GRANT_SYS_PRIV =========================================================
  --
  procedure grant_sys_priv  (p_privilege        in varchar2
                            ,p_grantee          in varchar2
                            ,p_with_admin       in boolean default false
                            )
  is
     l_stmt     varchar2(4000);
     priv_doesnot_exists     exception;
     user_doesnot_exists     exception;
     pragma exception_init(priv_doesnot_exists,-1919); -- nummer klopt nog niet
     pragma exception_init(user_doesnot_exists,-1917); -- nummer klopt nog niet
  begin
    g_routine := 'grant_sys_priv';
    log('start -->');
    if p_with_admin then
       l_stmt := 'grant '||p_privilege||' to '||p_grantee||' with admin option';
    else
       l_stmt := 'grant '||p_privilege||' to '||p_grantee;
    end if;
    log('l_stmt='||l_stmt);
    execute immediate l_stmt;
    log('<-- end');
  exception
    when user_doesnot_exists then
        log('ALERT: user/role "'||p_grantee||'" doesnot exists.');
    when priv_doesnot_exists then
        log('ALERT: privilege "'||p_privilege||'" doesnot exists.');
    when others then
      raise_application_error(-20000,sqlerrm);
  end grant_sys_priv;
  --
  -- == REVOKE_SYS_PRIV =========================================================
  --
  procedure revoke_sys_priv  (p_privilege        in varchar2
                             ,p_grantee          in varchar2
                             )
  is
     l_stmt     varchar2(4000);
     priv_doesnot_exists     exception;
     user_doesnot_exists     exception;
     pragma exception_init(priv_doesnot_exists,-1919); -- nummer klopt nog niet
     pragma exception_init(user_doesnot_exists,-1917); -- nummer klopt nog niet
  begin
    g_routine := 'revoke_sys_priv';
    log('start -->');
    l_stmt := 'revoke '||p_privilege||' from '||p_grantee;
    log('l_stmt='||l_stmt);
    execute immediate l_stmt;
    log('<-- end');
  exception
    when user_doesnot_exists then
        log('ALERT: user/role "'||p_grantee||'" doesnot exists.');
    when priv_doesnot_exists then
        log('ALERT: privilege "'||p_privilege||'" doesnot exists.');
    when others then
      raise_application_error(-20000,sqlerrm);
  end revoke_sys_priv;
  --
  -- == GRANT_OBJ_PRIV =========================================================
  --
  procedure grant_obj_priv  (p_privilege        in varchar2
                            ,p_owner            in varchar2
                            ,p_object           in varchar2
                            ,p_grantee          in varchar2
                            ,p_with_grant       in boolean default false
                            )
  is
     l_stmt     varchar2(4000);
     priv_doesnot_exists     exception;
     user_doesnot_exists     exception;
     pragma exception_init(priv_doesnot_exists,-1919);
     pragma exception_init(user_doesnot_exists,-1917);
  begin
    g_routine := 'grant_objpriv';
    log('start -->');
    if p_with_grant then
       l_stmt := 'grant '||p_privilege||' on '||p_owner||'.'||p_object||' to '||p_grantee||' with grant option';
    else
       l_stmt := 'grant '||p_privilege||' on '||p_owner||'.'||p_object||' to '||p_grantee;
    end if;
    log('l_stmt='||l_stmt);
    if upper(p_owner) = 'SYS'
    then
      execute immediate 'begin dbaas_syssql(:1); end;' using l_stmt;
    else 
      execute immediate l_stmt;
    end if;
    log('<-- end');
  exception
    when user_doesnot_exists then
        log('ALERT: user/role "'||p_grantee||'" doesnot exists.');
    when priv_doesnot_exists then
        log('ALERT: privilege "'||p_privilege||'" doesnot exists.');
    when others then
      raise_application_error(-20000,sqlerrm);
  end grant_obj_priv;
  --
  -- == REVOKE_OBJ_PRIV =========================================================
  --
  procedure revoke_obj_priv  (p_privilege        in varchar2
                             ,p_owner            in varchar2
                             ,p_object           in varchar2
                             ,p_grantee          in varchar2
                             )
  is
     l_stmt     varchar2(4000);
     priv_doesnot_exists     exception;
     user_doesnot_exists     exception;
     pragma exception_init(priv_doesnot_exists,-1919);
     pragma exception_init(user_doesnot_exists,-1917);
  begin
    g_routine := 'revoke_obj_priv';
    log('start -->');
    l_stmt := 'revoke '||p_privilege||' on '||p_owner||'.'||p_object||' from '||p_grantee;
    log('l_stmt='||l_stmt);
    if upper(p_owner) = 'SYS'
    then
      execute immediate 'begin dbaas_syssql(:1); end;' using l_stmt;
    else 
      execute immediate l_stmt;
    end if;
    log('<-- end');
  exception
    when user_doesnot_exists then
        log('ALERT: user/role "'||p_grantee||'" doesnot exists.');
    when priv_doesnot_exists then
        log('ALERT: privilege "'||p_privilege||'" doesnot exists.');
    when others then
      raise_application_error(-20000,sqlerrm);
  end revoke_obj_priv;
  --
  --
  -- CREATE_DIRECT_GRANTS 
  --
  procedure create_direct_grants(p_owner varchar2, p_role varchar2, p_admin boolean)
  is
    cursor c1 (b_grantee in varchar2) is
    select owner, table_name , privilege
      from dba_tab_privs p
     where grantee  = upper(b_grantee);
    l_stmt     varchar2(4000);
    l_user varchar2(30);
    user_doesnot_exists     exception;
    pragma exception_init(user_doesnot_exists,-1917);
  begin
    g_routine := 'create_direct_grant';
    log('start -->');
    for r1 in c1(p_role) 
    loop
      l_stmt := 'grant '||r1.privilege||' on '||r1.owner||'.'||r1.table_name||' to '||p_owner;
      if p_admin
      then
         l_stmt := l_stmt ||' with admin option';
      end if;
      log('l_stmt='||l_stmt);
      execute immediate l_stmt;
    end loop;
    log('<-- end');
  exception
    when user_doesnot_exists then
        log('ALERT: user/role "'||p_role||'" doesnot exists.');
    when others then
      raise_application_error(-20000,sqlerrm);
  end create_direct_grants;
  --
  procedure restore_grants(p_schema varchar2 default NULL)
  is
    l_sql varchar2(4000);
    l_schema varchar2(32);
  begin
    if p_schema is NOT null
    then
      l_schema := p_schema;
      create_prc_execsql(l_schema);
      l_sql := 'begin dbaas_schema_utils.restore_grants('''||l_schema||'''); end;';
      dbms_output.put_line(l_sql);
      execute immediate 'begin '||l_schema||'.dbaas_execsql(:1); end;' using l_sql;
      drop_prc_execsql(l_schema);
    end if;
  end restore_grants;

  procedure create_grants(p_schema varchar2 default NULL)
  is
    l_sql varchar2(4000);
    l_schema varchar2(32);
  begin

   if p_schema is NOT null
    then
      l_schema := p_schema;
      dbms_output.put_line('Grants voor owner schema: '||l_schema);
      create_prc_execsql(l_schema);
      l_sql := 'begin dbaas_schema_utils.create_grants('''||p_schema||'''); end;';
      dbms_output.put_line(l_sql);
      execute immediate 'begin '||l_schema||'.dbaas_execsql(:1); end;' using l_sql;
      drop_prc_execsql(l_schema);
    end if;
  end create_grants;
  --
  procedure compare_roles(p_schema1 varchar2, p_schema2 varchar2, p_dblink varchar2)
  is 
    l_sql varchar2(1000);
  begin
    l_sql := q'[select lpad(' ', 2*level) || granted_role "User, his roles and privileges"
                  from ( /* THE USERS */
                         select null     grantee, username granted_role
                           from dba_users
                          where username like upper(']'||p_schema1||q'[')
                         /* THE ROLES TO ROLES RELATIONS */
                          union
                         select grantee, granted_role
                           from dba_role_privs
                         /* THE ROLES TO PRIVILEGE RELATIONS */
                          union
                         select grantee, privilege
                           from dba_sys_privs
                        )
             start with grantee is null
            connect by grantee = prior granted_role]';
   end  compare_roles;
  --
--*********************************************************************************************************************
--*********************************************************************************************************************
--*********************************************************************************************************************
  --
  -- == KILL_SESSION ===========================================================
  --
  procedure kill_session(p_user in varchar2)
  is
    cursor c1 (b_user in varchar2) is
    select username, sid, serial#
    from   v$session
    where  username = upper(b_user);
    l_stmt varchar2(4000);
  begin
    g_routine := 'kill_session';
    log('start -->');
    for r1 in c1 (p_user) loop
      l_stmt := 'alter system kill session '''||to_char(r1.sid)||','||to_char(r1.serial#)||''' ' ;
      execute immediate 'begin dbaas_syssql(:1); end;' using l_stmt;
      log('Session killed: '||r1.username||'('||to_char(r1.sid)||','||to_char(r1.serial#)||')');
    end loop;
    log('<-- end');
  end kill_session;
  --
  -- == KILL_APP_SESSION =======================================================
  --
  procedure kill_app_sessions(p_app in varchar2)
  is
    cursor c1 (b_app in varchar2) is
    select username, sid, serial#
    from    v$session
    where   (username like upper( b_app||'%'||'OWN')
            and length(username) = 8
            )
    or username like upper( b_app||'_LEES')
    or username like upper( b_app||'_MUT')
    or username like upper( b_app||'_USR')
    or username like upper( b_app||'_ADM')
    or username like upper( b_app||'\_'||'%') escape '\' ;
    l_stmt varchar2(4000);
  begin
    g_routine := 'kill_app_session';
    log('start -->');
    for r1 in c1 (p_app) loop
        l_stmt := 'alter system kill session '''||to_char(r1.sid)||','||to_char(r1.serial#)||''' ' ;
        execute immediate 'begin dbaas_syssql(:1); end;' using l_stmt;
        log( 'Session killed: '||r1.username||'('||to_char(r1.sid)||','||to_char(r1.serial#)||')');
    end loop;
    log('<-- end');
  end kill_app_sessions;
  --
--*********************************************************************************************************************
--*********************************************************************************************************************
--*********************************************************************************************************************
  --
  -- == GRANT_TBS_QUOTA ========================================================
  --
  procedure grant_tbs_quota (p_user in varchar2, p_tbs in varchar2, p_quota in varchar2) is
  begin
    g_routine := 'grant_tbs_quota';
    log('start -->');
    alter_user      (p_user, p_quota => p_quota, p_tablespace => p_tbs);
    log('alter user '||p_user||' quota unlimited on'||p_tbs);
    log('<-- end');
  end grant_tbs_quota;
  --
  -- == DROP_APP_TBS ============================================================
  --
  procedure drop_app_tbs    (p_app     in varchar2)
  is
    l_stmt      varchar2(4000);
    cursor c1 is
    select  tablespace_name
    from    dba_tablespaces
    where   tablespace_name like upper(p_app)||'\_%' escape '\'
            or
            tablespace_name = upper(p_app)||'01';   -- backwards compatible
  begin
    g_routine := 'drop_app_tbs';
    log('start -->');
    for r1 in c1 loop
      l_stmt := 'drop tablespace  '||r1.tablespace_name||' including contents';
      log(l_stmt);
      execute immediate l_stmt;
    end loop;
    log('<-- end');
  end drop_app_tbs;
  --
--*********************************************************************************************************************
--*********************************************************************************************************************
--*********************************************************************************************************************
  --
  -- == CREATE_PRC_EXECSQL =====================================================
  --
  procedure create_prc_execsql   (p_schema in varchar2)
  is
    l_stmt  varchar2(4000);
    crlf    varchar2(2) := chr(13)||chr(10);
  begin
    dbms_output.put_line('create dbaas_execsql -> start');    
    l_stmt := 'create or replace procedure '||upper(p_schema)||'.'||'dbaas_execsql'||crlf||
              '(p_sql in clob) is '||crlf||
              'begin'||crlf||
              '  execute immediate p_sql;'||crlf||
              'exception'||crlf||
              '  when others then '||crlf||
              '   raise_application_error(-20010,''Error in dbaas_execsel - ''||sqlerrm||''.'');'||crlf||
              'end;'||crlf;

    execute immediate l_stmt;
    dbms_output.put_line('create dbaas_execsql -> end');    
  end create_prc_execsql;
  --
  -- == DROP_PRC_EXECSQL =====================================================
  --
  procedure drop_prc_execsql   (p_schema in varchar2)
  is
    l_stmt varchar2(4000);
  begin
    l_stmt := 'drop procedure '||p_schema||'.dbaas_execsql';
    execute immediate l_stmt;
--  exception
--    when others then null;
  end drop_prc_execsql;

--*********************************************************************************************************************
--*********************************************************************************************************************
--*********************************************************************************************************************
  --
  -- == CREATE_ORACLE_DIRECTORY ================================================
  --
  procedure create_oracle_directory   (p_oracle_dir   in varchar2
                                      ,p_physical_dir in varchar2
                                      ,p_schema       in varchar2)
  is
    l_stmt varchar2(4000);
  begin
    g_routine := 'create_oracle_directory';
    log('start -->');
    l_stmt := 'create or replace directory '||p_oracle_dir||' as '''||p_physical_dir||'''';
    log(l_stmt); 
    execute immediate l_stmt;
    l_stmt := 'grant read,write on directory '||p_oracle_dir||' to '||p_schema;
    log(l_stmt); 
    execute immediate l_stmt;
    log('<-- end');
  end create_oracle_directory;

--*********************************************************************************************************************
--*********************************************************************************************************************
--*********************************************************************************************************************

  --
  -- == SET_OS_CRED_PASSWORD ============================================
  --
  procedure set_os_cred_password   (p_password in varchar2)
  is
  begin
    g_routine := 'set_os_cred_password';
    log('start -->');
    dbms_scheduler.set_attribute(name=>'DBAAS_OS_CRED',attribute=>'password',value=>p_password);
    log('Password for credential DBAAS_OS_CRED modified.');
    log('<-- end');
  end set_os_cred_password;
  --
  -- == SET_DB_CRED_PASSWORD ============================================
  --
  procedure set_db_cred_password   (p_password in varchar2)
  is
  begin
    g_routine := 'set_db_cred_password';
    log('start -->');
    dbms_scheduler.set_attribute(name=>'DBAAS_DB_CRED',attribute=>'password',value=>p_password);
    log('Password for credential DBAAS_DB_CRED modified.');
    log('<-- end');
  end set_db_cred_password;

  --
  -- == gather_sche_stats =============================================
  --
  procedure gather_schema_stats  
            (p_schema           varchar2
            ,p_estimate_percent number   default null
            ,p_block_sample     boolean  default false
            ,p_method_opt       varchar2 default 'FOR ALL COLUMNS SIZE 1'
            ,p_degree           number   default null
            ,p_granularity      varchar2 default 'DEFAULT'
            ,p_cascade          boolean  default false
            ,p_stattab           varchar2 default null
            ,p_statid           varchar2 default null
            ,p_options          varchar2 default 'GATHER'
            ,p_statown          varchar2 default null
            ,p_no_invalidate    boolean  default false
            ,p_force            boolean  default false
            )
  is
  begin
    g_routine := 'gather_schema_stats';
    log('start -->');
    dbms_stats.gather_schema_stats(ownname=>p_schema
              ,estimate_percent=>p_estimate_percent
              ,block_sample=>p_block_sample
              ,method_opt=>p_method_opt
              ,degree=>p_degree
              ,granularity=>p_granularity
              ,cascade=>p_cascade
              ,stattab=>p_stattab
              ,statid=>p_statid
              ,options=>p_options
              ,statown=>p_statown
              ,no_invalidate=>p_no_invalidate
              ,force=>p_force
              );
    log('Gather statistics for schema : '||p_schema);
    log('<-- end');
  end gather_schema_stats;


--*********************************************************************************************************************
--*********************************************************************************************************************
--*********************************************************************************************************************


--*********************************************************************************************************************
--*********************************************************************************************************************
--*********************************************************************************************************************

  procedure remap_spatial_index_tbs(p_schema in varchar2, p_tbs_orig varchar2, p_tbs_new varchar2)
  is
    l_sql varchar2(2000);
  begin
    create_prc_execsql(p_schema);

    l_sql := 'begin dbaas_schema_utils.remap_spatial_index_tbs('''||p_schema||''','''||p_tbs_orig||''','''||p_tbs_new||'''); end;';
    begin
      execute immediate 'begin '||p_schema||'.dbaas_execsql(:1); end;' using l_sql;
    exception when others then
      dbms_output.put_line('FAILED (' || SUBSTR(SQLERRM,1,240) || ')');
    end;
    drop_prc_execsql(p_schema);
  end remap_spatial_index_tbs;


--*********************************************************************************************************************
--*********************************************************************************************************************
--*********************************************************************************************************************
    procedure enable_constraints(p_schema varchar2, p_table varchar2 default null)
  is
    l_sql varchar2(2000);
    l_schema_in varchar2(4000) := p_schema;
    l_schema varchar2(40);
  begin
    for i in 1 .. regexp_count (l_schema_in, ':') + 1
    loop
      l_schema := regexp_substr (l_schema_in, '[^:]+', 1);
      l_schema_in := substr (l_schema_in, length(l_schema)+2);
      create_prc_execsql(l_schema);
      if p_table is null
      then
        l_sql := 'begin dbaas_schema_utils.enable_constraints('''||l_schema||'''); end;';
      else
        l_sql := 'begin dbaas_schema_utils.enable_constraints('''||l_schema||''', '''||p_table||'''); end;';
      end if;
      dbms_output.put_line('enable_constraint: '||l_sql);
      execute immediate 'begin '||l_schema||'.dbaas_execsql(:1); end;' using l_sql;

      drop_prc_execsql(l_schema);
    end loop; 
  end enable_constraints;

  procedure disable_constraints(p_schema varchar2, p_table varchar2 default null)
  is
    l_sql varchar2(2000);
    l_schema_in varchar2(4000) := p_schema;
    l_schema varchar2(40);
  begin
    for i in 1 .. regexp_count (l_schema_in, ':') + 1
    loop
      l_schema := regexp_substr (l_schema_in, '[^:]+', 1);
      l_schema_in := substr (l_schema_in, length(l_schema)+2);
      create_prc_execsql(l_schema);
      if p_table is null
      then
        l_sql := 'begin dbaas_schema_utils.disable_constraints('''||l_schema||'''); end;';
      else
        l_sql := 'begin dbaas_schema_utils.disable_constraints('''||l_schema||''','''||p_table||'''); end;';
      end if;
      dbms_output.put_line('disable_constraint: '||l_sql);
      execute immediate 'begin '||l_schema||'.dbaas_execsql(:1); end;' using l_sql;
      drop_prc_execsql(l_schema);
    end loop; 
  end disable_constraints;

  procedure enable_triggers(p_schema varchar2, p_table varchar2 default null)
  is
    l_sql varchar2(2000);
    l_schema_in varchar2(4000) := p_schema;
    l_schema varchar2(40);
  begin
    for i in 1 .. regexp_count (l_schema_in, ':') + 1
    loop
      l_schema := regexp_substr (l_schema_in, '[^:]+', 1);
      l_schema_in := substr (l_schema_in, length(l_schema)+2);
      create_prc_execsql(l_schema);
      if p_table is null
      then
        l_sql := 'begin dbaas_schema_utils.enable_triggers('''||l_schema||'''); end;';
      else
        l_sql := 'begin dbaas_schema_utils.enable_triggers('''||l_schema||''','''||p_table||'''); end;';
      end if;

      execute immediate 'begin '||l_schema||'.dbaas_execsql(:1); end;' using l_sql;

      drop_prc_execsql(l_schema);
    end loop; 
  end enable_triggers;

  procedure disable_triggers(p_schema varchar2, p_table varchar2 default null)
  is
    l_sql varchar2(2000);
    l_schema_in varchar2(4000) := p_schema;
    l_schema varchar2(40);
  begin
    for i in 1 .. regexp_count (l_schema_in, ':') + 1
    loop
      l_schema := regexp_substr (l_schema_in, '[^:]+', 1);
      l_schema_in := substr (l_schema_in, length(l_schema)+2);
      create_prc_execsql(l_schema);
      if p_table is null
      then
        l_sql := 'begin dbaas_schema_utils.disable_triggers('''||l_schema||'''); end;';
      else
        l_sql := 'begin dbaas_schema_utils.disable_triggers('''||l_schema||''', '''||p_table||'''); end;';
      end if;

      execute immediate 'begin '||l_schema||'.dbaas_execsql(:1); end;' using l_sql;

      drop_prc_execsql(l_schema);
    end loop; 
  end disable_triggers;

--*********************************************************************************************************************
--*********************************************************************************************************************
--*********************************************************************************************************************

  --
  -- == CREATE_TMP_SHELL =========================================
  --
  procedure create_tmp_shell (p_script_name in varchar2, p_script_txt in varchar2)
  is
    l_file	utl_file.file_type;
    l_stmt	varchar2(4000);
    l_exists    boolean;
    l_file_length   number;
    l_blocksize     number;
	PRAGMA AUTONOMOUS_TRANSACTION;
  begin
    l_stmt := 'create or replace directory DBAAS_TMP as ''/tmp/''';
	dbms_output.put_line(l_stmt);
    execute immediate l_stmt;
	dbms_output.put_line('Maken file '||p_script_name);
    utl_file.fgetattr('DBAAS_TMP', p_script_name, l_exists, l_file_length, l_blocksize);

    if l_exists = false
    then
       dbms_output.put_line('De file: '||p_script_name||' bestaat niet.');
       l_file := utl_file.fopen('DBAAS_TMP', p_script_name, 'W');
       utl_file.put_line(l_file,p_script_txt);
       utl_file.fclose(l_file);
    end if;
  end create_tmp_shell;

  procedure create_tmp_shell2(p_script_name in varchar2, p_lines dbms_sql.varchar2_table)
  is
    l_file	utl_file.file_type;
    l_stmt	varchar2(4000);
    l_exists    boolean;
    l_file_length   number;
    l_blocksize     number;
  begin
    l_stmt := 'create or replace directory DBAAS_TMP as ''/tmp/''';
    execute immediate l_stmt;
    utl_file.fgetattr('DBAAS_TMP', p_script_name, l_exists, l_file_length, l_blocksize);
    if l_exists = false
    then
       dbms_output.put_line('De file: '||p_script_name||' bestaat niet.');
       l_file := utl_file.fopen('DBAAS_TMP', p_script_name, 'W');
       for i in p_lines.first .. p_lines.last
       loop
          dbms_output.put_line(p_lines(i));
          utl_file.put_line(l_file,p_lines(i));
       end loop;
       utl_file.fclose(l_file);
    end if;
  end create_tmp_shell2;


  procedure remove_tmp_file(p_tmp_file varchar2)
  is
    l_exists boolean;
    l_file_length number;
    l_blocksize number;
    l_routine varchar2(30);

  -- Extra checks nog nodig:
  -- 1) dump file moet eindigen op .dmp
  -- 2) het pad van DBAAS_TMP moet wijzen naar /tmp achtig iets
  -- 3) het pad mag niet beginnen met - (zodat we geen -r achtige dingen kunnen doen)
  begin
    l_routine := 'remove_tmp_file';
    log('start --> '|| l_routine);

    if instr(p_tmp_file, '/') > 0
    then
      raise_application_error(-20002,'Er mogen geen OS directory verwijzingen in de dump file naam staan.');
    end if;

    utl_file.fgetattr('DBAAS_TMP', p_tmp_file, l_exists, l_file_length, l_blocksize);

    if l_exists
    then
       utl_file.fremove('DBAAS_TMP', p_tmp_file);
       log('De file: '||p_tmp_file||' is weggegooid.');
    else
       log('De file: '||p_tmp_file||' bestaat niet.');
    end if;
    log('einde --> '|| l_routine );
  exception
   when others then
     raise_application_error(-20000,'Error: '||sqlerrm);
  end remove_tmp_file;




--*********************************************************************************************************************
--*********************************************************************************************************************
--*********************************************************************************************************************

  procedure create_synoniemen(p_schema varchar2 default NULL)
  is
    l_sql varchar2(4000);
    l_schema varchar2(32);
  begin
   if p_schema is NOT null
    then
      l_schema := p_schema;
      dbms_output.put_line('synoniemen voor owner schema: '||l_schema);
      create_prc_execsql(l_schema);
      l_sql := 'begin dbaas_schema_utils.create_synoniemen('''||p_schema||'''); end;';
      dbms_output.put_line(l_sql);
      execute immediate 'begin '||l_schema||'.dbaas_execsql(:1); end;' using l_sql;
      drop_prc_execsql(l_schema);
    end if;
  end create_synoniemen;

  procedure reset_synoniemen(p_schema varchar2)
  is
    l_sql varchar2(2000);
  begin
    create_prc_execsql(p_schema);
    l_sql := 'begin dbaas_schema_utils.reset_synoniemen('''||p_schema||'''); end;';
    execute immediate 'begin '||p_schema||'.dbaas_execsql(:1); end;' using l_sql;
    drop_prc_execsql(p_schema);
  end reset_synoniemen;

  procedure restore_synoniemen(p_schema varchar2)
  is
  begin
      create_synoniemen(p_schema);
  end restore_synoniemen;
  
    procedure fix_synoniemen
  is
  begin 
     for i in (select owner, object_name, status, object_type 
	            from dba_objects 
			   where status != 'VALID'
                 and object_type = 'SYNONYM' 
				 and owner != 'PUBLIC')
  loop
    dbms_output.put_line(i.owner||'.'||i.object_name);
    begin
       dbms_output.put_line(i.owner||'.'||i.object_name); 
       execute immediate 'select * from '||i.owner||'.'||i.object_name||' where rownum < 1';
    exception when others then dbms_output.put_line(SQLERRM);
	end; 
  end loop;    
  end fix_synoniemen;

  procedure create_public_synonyms(p_schema varchar2)
  is
    l_sql varchar2(1000);
  begin
    create_prc_execsql(p_schema);
    l_sql := 'begin dbaas_schema_utils.create_public_synonyms('''||p_schema||'''); end;';
    dbms_output.put_line('create public synonyms: '||l_sql);
    execute immediate 'begin '||p_schema||'.dbaas_execsql(:1); end;' using l_sql;
    drop_prc_execsql(p_schema);
  end create_public_synonyms;


--*********************************************************************************************************************
--*********************************************************************************************************************
--*********************************************************************************************************************
  
  procedure reset_trace_directories(p_schema varchar2)
  is
    l_trace  varchar2(1024);
    l_alert  varchar2(1024);
  begin
   select value
     into l_trace
     from v$parameter
    where name = 'user_dump_dest';
   select value
     into l_alert
     from v$parameter
    where name = 'background_dump_dest';
   create_oracle_directory('DB_TRACE_DIR',l_trace,p_schema);
   create_oracle_directory('DB_ALERT_DIR',l_alert,p_schema);
  end reset_trace_directories;





--*********************************************************************************************************************
--*********************************************************************************************************************
--*********************************************************************************************************************

  procedure enable_job(p_schema varchar2, p_jobname varchar2)
  is
    l_sql varchar2(4000);
    l_schema varchar2(32);
  begin
    if p_schema is not null
    then
      l_schema := p_schema;
      create_prc_execsql(l_schema);
      l_sql := 'begin dbaas_schema_utils.enable_job('''||p_jobname||'''); end;';
      dbms_output.put_line(l_sql);
      execute immediate 'begin '||l_schema||'.dbaas_execsql(:1); end;' using l_sql;
      drop_prc_execsql(l_schema);
    end if;
  end enable_JOB;

  procedure disable_job(p_schema varchar2, p_jobname varchar2)
  is
    l_sql varchar2(4000);
    l_schema varchar2(32);
  begin
    if p_schema is not null
    then
      l_schema := p_schema;
      create_prc_execsql(l_schema);
      l_sql := 'begin dbaas_schema_utils.disable_job('''||p_jobname||'''); end;';
      dbms_output.put_line(l_sql);
      execute immediate 'begin '||l_schema||'.dbaas_execsql(:1); end;' using l_sql;
      drop_prc_execsql(l_schema);
    end if;
  end disable_JOB;

--*********************************************************************************************************************
--*********************************************************************************************************************
--*********************************************************************************************************************
  procedure create_classic_dblink ( p_link_name in varchar2
                                  , p_owner     in varchar2
                                  , p_user      in varchar2
                                  , p_password  in varchar2
                                  , p_host      in varchar2
                                  , p_port      in varchar2
                                  , p_service   in varchar2
                                  )
  -- create database link  p_link_name = QARTO_DBAAS_DBL
  -- host-NDB/SDB: (HOST = 145.45.12.171)(PORT = 1526), SERVICE-NAME="NDB.RWS.NL" )
  is
    l_stmt      varchar2(4000);
  begin
-- log functie er nog in !!
    create_prc_execsql(p_owner);
    -- set current schema, before create dblink
    begin   -- drop dblink, ignore doesnot_exists
      l_stmt := 'drop database link ' || p_link_name;
      log(l_stmt);
      execute immediate 'begin '||p_owner||'.dbaas_execsql(:1); end;' using l_stmt;
    exception
      when others then null;
    end;    -- drop database link

    l_stmt := 'create database link ' || p_link_name ||
              ' connect to ' || p_user ||
              ' identified by ' || p_password ||
              ' using ''' || p_host || ':' || p_port || '/' || p_service || '''';
    log(l_stmt);
    log('aanroep:'|| upper(p_owner) ||'.dbaas_execsql('''||l_stmt||''')' );
    execute immediate 'begin '||p_owner||'.dbaas_execsql(:1); end;' using l_stmt;
    log('dbaas_execsql gedaan');
    drop_prc_execsql(p_owner);
    log('drop dbaas_execsql gedaan');

  exception
    when others then
     log(sqlerrm);
      raise_application_error(-20000, sqlerrm);
  end create_classic_dblink ;
 --
  function object_valid(p_object varchar2, p_type varchar2 default 'PACKAGE BODY') return varchar2
  is
    l_status varchar2(128) := 'NOT FOUND';
  begin
    select status
      into l_status
      from dba_objects
     where object_name = upper(p_object)
       and object_type = upper(p_type);
   return l_status; 
  end object_valid;
  --
  procedure purge_recyclebin(p_schema varchar2)
  is
    l_sql varchar2(4000);
  begin
    create_prc_execsql(p_schema);
    l_sql := 'purge recyclebin';
    dbms_output.put_line(l_sql);
    execute immediate 'begin '||p_schema||'.dbaas_execsql(:1); end;' using l_sql;
    drop_prc_execsql(p_schema);
  end purge_recyclebin;
  --
  procedure flush_buffer_cache
  is
  begin
     null;
     --dbaas_syssql('alter system flush buffer_cache');
  end flush_buffer_cache;
  --
  procedure switch_log_file
  is
  begin
     null;
     --dbaas_syssql('alter system switch logfile');
  end switch_log_file;
  --
end dbaas_dba;
/

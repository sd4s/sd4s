create or replace package dbaas_schema_utils authid current_user
is
  procedure log (p_msg in varchar2);
  function filter_synoniem(p_object_type varchar2, p_object_name varchar2) return boolean;
  --
  function filter_object(p_schema varchar2, p_object varchar2) return boolean;
  --
  procedure grant_queue_privilege(p_privilege varchar2, p_queue varchar2, p_grantee varchar2, p_grant_option boolean);
  procedure enable_triggers(p_schema varchar2, p_table varchar2 default null);
  --
  procedure disable_triggers(p_schema varchar2, p_table varchar2 default null);
  --
  procedure enable_constraints(p_schema varchar2, p_table varchar2 default null);
  --
  procedure disable_constraints(p_schema varchar2, p_table varchar2 default null);
  --
  procedure Reset_Seq(p_schema varchar2, p_seq_name in varchar2, p_val in number default 0);
  --
  procedure reset_sequences(p_schema varchar2);
  --
  procedure reset_grants(p_schema varchar2);
  --
  procedure reset_synoniemen(p_schema varchar2);
  --
  procedure reset_logger_sequence(p_schema varchar2, p_app varchar2);
  --
  procedure enable_queues(p_schema varchar2);
  --
  procedure remap_spatial_index_tbs(p_schema in varchar2, p_tbs_orig varchar2, p_tbs_new varchar2);
  --
  procedure create_public_synonyms(p_schema varchar2);
  --
  procedure compare_users (p_source_user varchar2, p_target_user varchar2 default null, p_host varchar2 default 'rws', p_service varchar2 default 'ndb',p_portnr number default '1526', p_dbaas_pw varchar2); 
  --
  procedure list_user_privileges (p_user varchar2, p_host varchar2 default 'rws', p_service varchar2 default 'ndb', p_portnr number default '1526', p_dbaas_pw varchar2);
  --
  procedure create_dbaas_framework(p_app varchar2, p_env varchar2);
  --* Strip de owner uit de SQL
  procedure strip_owner(p_schema varchar2, p_owner varchar2, p_type varchar2);
  --
  procedure create_appl_geom_metadata(p_schema varchar2);
  --
  procedure revoke_grants(p_schema in varchar2);  
  --
  procedure create_grants(p_schema in varchar2);
  --
  procedure create_synoniemen(p_schema in varchar2);
  --
  procedure purge_recyclebin;  
  --
  --* Rebuild spatial indexes 'semi' online; table wordt hiervoor tijdelijk in read only mode gezet!
  procedure rebuild_spatial_indexes(p_status in out number, p_message in out varchar2);  
  --* Rebuild normal indexes offline.
  procedure rebuild_normal_indexes(p_status in out number, p_message in out varchar2);  
  --* Gather schema statistics.
  procedure gather_schema_statistics(p_status in out number, p_message in out varchar2);  
  --
  procedure alter_queue(p_queue in varchar2, p_max_retries in number default null, 
                        p_retry_delay in number default null, 
                        p_retention_time in number default null, 
                        p_comment in varchar2 default null);

end;
/



create or replace package body dbaas_schema_utils
is
  -- ============================================================================
  -- variables
  -- ============================================================================
  g_routine     varchar2(50)    := '-';
  g_otap        varchar2(1)     := '-';
  c_version     varchar2(128)   := '$Id: dbaas_schema_utils.pkb 31289 2015-07-06 20:57:03Z SCHEPENSP $';
  g_text        varchar2(400);
  g_sql         varchar2(500);

  -- ============================================================================
  -- local routines
  -- ============================================================================
  
  procedure log (p_msg in varchar2) is
    l_date date default sysdate;
  begin
    dbms_output.put_line(to_char(l_date,'YYYYMMDDHH24MI') || ' ' ||g_routine|| ': ' ||p_msg);
  end;

  -- ============================================================================
  -- global routines
  -- ============================================================================

  procedure dosql(p_schema in varchar2, p_sql in varchar2) is
     l_sql varchar2(4000);
  begin
     begin
     l_sql := 'begin dbaas_execsql('''||p_sql||'''); end;';
     log('DO: '||l_sql);
     execute immediate l_sql;
     exception when others then
       log('DO: '||sqlerrm);
     end;
  end;

  FUNCTION doe_query ( query_in IN VARCHAR2) RETURN SYS_REFCURSOR
  IS
     l_return   SYS_REFCURSOR;
  BEGIN
 --    log(query_in);
     OPEN l_return FOR query_in;

     RETURN l_return;
  END doe_query;
    
  procedure disable_triggers(p_schema varchar2, p_table varchar2)
  is
   cursor c1 is SELECT trigger_name 
                  FROM user_triggers 
                 where trigger_name not like 'BIN$%'
                   and (p_table is null or (p_table is not null and table_name = upper(p_table)));
   l_sql varchar2(2000);
  BEGIN
    log ('Disable triggers for schema: ' || p_schema); 
    for r1 in c1
    loop
      l_sql :=  'ALTER TRIGGER "' || r1.trigger_name || '" DISABLE';
    begin
      EXECUTE IMMEDIATE l_sql;
    exception when others then
      log(l_sql||': '||l_sql);
    end;
    END LOOP;
    
  end disable_triggers;

  procedure enable_triggers(p_schema varchar2, p_table varchar2)
  is
   cursor c1 is SELECT trigger_name      
                  FROM user_triggers
                 WHERE (p_table is null  or (p_table is not null and table_name = upper(p_table)));
  BEGIN
    log ('Enable triggers for schema: ' || p_schema); 
    for r1 in c1
    loop
      EXECUTE IMMEDIATE 'ALTER TRIGGER "' || r1.trigger_name || '" ENABLE';
    END LOOP;
  end enable_triggers;

  procedure disable_constraints(p_schema varchar2, p_table varchar2)
  is
   cursor c1 is select c.table_name, constraint_name
                  from user_constraints c
                 where constraint_type = 'R'
                   and status = 'ENABLED'
                   and table_name not like 'BIN$%';
   cursor c2 is select c.table_name, constraint_name
                  from user_constraints c
                 where status = 'ENABLED'
                   and constraint_type != 'O'
                   and constraint_type != 'F'
                   and table_name not like 'BIN$%';
   cursor fk(c_tablename varchar2)
             is SELECT FK.TABLE_NAME AS CHILD_TABLE
                     , SRC.TABLE_NAME AS PARENT_TABLE
                     , FK.CONSTRAINT_NAME AS FK_CONSTRAINT
                     , SRC.CONSTRAINT_NAME AS REFERENCED_CONSTRAINT
                 FROM USER_CONSTRAINTS FK
                 JOIN user_CONSTRAINTS SRC ON FK.R_CONSTRAINT_NAME = SRC.CONSTRAINT_NAME
                WHERE FK.CONSTRAINT_TYPE = 'R'
                  AND SRC.TABLE_NAME = upper(c_tablename);

   v_statement varchar2(255);
   v_nc number(10);
   v_nt number(10);
  begin
    log ('Disable constraints for schema: ' || p_schema); 
    if p_table is null
    then
       for r1 in c1
       loop
         v_statement := 'ALTER TABLE '|| r1.table_name ||' DISABLE CONSTRAINT '||r1.constraint_name;
         begin
            execute immediate v_statement;
         exception when others then
            log(r1.table_name||': '||SQLERRM);
         end;
       end loop;
    else
       for r1 in fk(p_table)
       loop
         v_statement := 'ALTER TABLE '|| r1.child_table ||' DISABLE CONSTRAINT '||r1.fk_constraint;
         begin
            execute immediate v_statement;
         exception when others then
            log(r1.child_table||': '||SQLERRM);
         end;
       end loop;
    end if;

    for r1 in c2
    loop
      v_statement := 'ALTER TABLE '|| r1.table_name ||' DISABLE CONSTRAINT '||r1.constraint_name;
      begin
         execute immediate v_statement;
      exception when others then
         log(r1.table_name||': '||SQLERRM);
      end;
    end loop;
  end;

  procedure enable_constraints(p_schema varchar2, p_table varchar2)
  is
     cursor c1 is select table_name, constraint_name
               from user_constraints
               where constraint_type != 'O'
		 and status = 'DISABLED'
                 and table_name not like 'BIN$%'
                 and (p_table  is null or (p_table is not null and table_name = upper(p_table)))
           order by (case when constraint_type='P' then 1
                          when constraint_type='U' then 2
                          else 3
                     end);
   v_statement varchar2(255);
   v_nc number(10);
   v_nt number(10);
   begin
     log ('Enable constraints for schema: ' || p_schema); 
     execute immediate 'alter session force parallel ddl parallel 8';
     for r1 in c1
     loop
       v_statement := 'ALTER TABLE '||r1.table_name ||' modify CONSTRAINT '||r1.constraint_name || ' validate';
       begin
          execute immediate 'ALTER TABLE '||r1.table_name ||' ENABLE novalidate CONSTRAINT '||r1.constraint_name;
          -- execute immediate 'alter table '||r1.table_name||' parallel 8';
          -- execute immediate v_statement;
          -- execute immediate 'alter table '||r1.table_name||' noparallel';
       exception when others  then
          execute immediate 'alter table '||r1.table_name||' noparallel';
          log(r1.table_name||': '||SQLERRM);
       end;
       execute immediate 'alter session disable parallel ddl';
     end loop;
  end;

  procedure Reset_Seq(p_schema varchar2, p_seq_name in varchar2, p_val in number default 0)
  is
    l_cache_size number := 0;
    l_current number    := 0;
    l_difference number := 0;
    l_minvalue number   := 0;
    l_sql      varchar2(4000);
  begin
    log(p_schema||'.'||p_seq_name||'='||p_val);
    begin
      select min_value
        into l_minvalue
        from all_sequences
       where sequence_name = upper(p_seq_name)
         and sequence_owner = upper(p_schema);

      select cache_size
        into l_cache_size
        from all_sequences
       where sequence_name = upper(p_seq_name)
         and sequence_owner = upper(p_schema);

    exception when others then
      -- log( 'De sequence '||p_seq_name||' bestaat niet voor '||p_schema||': '||SQLERRM);
      raise_application_error(-20001, 'De sequence '||p_seq_name||' bestaat niet voor '||p_schema||': '||SQLERRM);
    end;

  execute immediate 'select '||p_seq_name || '.nextval from dual' INTO l_current;

  if p_Val < l_minvalue then
    l_difference := l_minvalue - l_current;
  else
    l_difference := p_Val - l_current;
  end if;

  if l_difference = 0 then
    return;
  end if;

  l_sql := 'alter sequence ' || p_seq_name || ' increment by ' || l_difference ||  ' minvalue ' || l_minvalue || ' nocache';

  execute immediate l_sql;

  execute immediate 'select '||p_seq_name || '.nextval from dual' INTO l_difference;
  
  if l_cache_size = 0 then
    l_sql :=  'alter sequence ' || p_seq_name || ' increment by 1 minvalue ' || l_minvalue ;
  else
    l_sql :=  'alter sequence ' || p_seq_name || ' increment by 1 minvalue ' || l_minvalue || ' cache ' || l_cache_size;
  end if;

  execute immediate l_sql;
end Reset_Seq;

function bepaal_max_value(p_schema varchar2, p_column_name varchar2, p_table_name varchar2) return number
is
  l_column_name varchar2(4000);
  l_column_list varchar2(4000);
  l_sql         varchar2(4000);
  l_maxvalue    number := -1;
  l_tab_in      varchar2(4000);
  l_col_in      varchar2(4000);

  l_tab_nr      number;
  l_col_nr      number;
  l_start_pos_t number;
  l_start_pos_c number;
  l_komma_pos_t number;
  l_komma_pos_c number;

begin
  l_tab_nr := regexp_count(p_table_name, ',');
  l_col_nr := regexp_count(p_column_name, ',');
  if l_tab_nr = l_col_nr
  then
    l_start_pos_t := 1;
    l_start_pos_c := 1;
    l_sql := 'select max(nvl(val,0)) from (';
    for l_tab_nr in 1 .. regexp_count(p_table_name, ',') + 1
    loop
      l_komma_pos_t := instr(p_table_name, ',', 1, l_tab_nr);
      l_komma_pos_c := instr(p_column_name, ',', 1, l_tab_nr);
      if l_komma_pos_t = 0
      then
        l_komma_pos_t := length (p_table_name) + 1;
      end if;
      if l_komma_pos_c = 0
      then
	l_komma_pos_c := length (p_column_name) + 1;
      end if;
      l_tab_in := substr(p_table_name, l_start_pos_t, l_komma_pos_t - l_start_pos_t);
      l_col_in := substr(p_column_name, l_start_pos_c, l_komma_pos_c - l_start_pos_c);
      if l_tab_nr = 1
      then
        l_sql := l_sql || 'select max(nvl(' || l_col_in || ', 0)) val from ' || l_tab_in;
      else
        l_sql := l_sql || ' UNION select max(nvl(' || l_col_in || ', 0)) val from ' || l_tab_in;
      end if;
      l_start_pos_t := l_komma_pos_t + 1;
      l_start_pos_c := l_komma_pos_c + 1;
    end loop;
  else
    log ('Aantal kolommen (' ||l_col_nr|| ') komt niet overeen met aantal tabellen (' || l_tab_nr || ')');
  end if;

 l_sql := l_sql || ')';
 log('SQL: '||l_sql);
 execute immediate l_sql into l_maxvalue;
 log(p_column_name||' '||l_maxvalue);
 return l_maxvalue;
 exception when others then
   log('bepaal_maxvalue: '||SQLERRM);
   return null;
end bepaal_max_value;

procedure reset_sequences(p_schema varchar2)
is
  l_cursor        sys_refcursor;
  l_sql           varchar2(4000);
  l_sequence_name varchar2(40);
  l_table_name    varchar2(4000);
  l_column_name   varchar2(4000);
  l_column_list   varchar2(4000);
  appl_sequence_bestaat_niet exception;
  pragma exception_init (appl_sequence_bestaat_niet, -942);
  l_maxvalue      number;
begin

   begin
     l_sql := 'select upper(sequence_name), upper(table_name), upper(column_name) from appl_sequence';
     open l_cursor for l_sql;
     loop
        fetch l_cursor into l_sequence_name, l_table_name, l_column_name;
        exit when l_cursor%notfound;
        l_maxvalue :=  bepaal_max_value(p_schema, l_column_name, l_table_name);
        if l_maxvalue is not null
        then
          reset_seq(p_schema, l_sequence_name, l_maxvalue);
        else
          log('Niet gevonden: '||p_schema||'.'||l_table_name||'.'||l_column_name);
        end if;
     end loop;
     commit;
   exception when appl_sequence_bestaat_niet then
     log('Voor het schema '||p_schema||' bestaat de tabel APPL_SEQUENCE niet.');
   end;
end reset_sequences;

procedure reset_logger_sequence(p_schema varchar2, p_app varchar2)
is
  l_maxval  number;
  l_seq     varchar2(32);
  l_tab     varchar2(32);
  l_col     varchar2(32);

begin
  l_seq   := p_app||'_LOGGER_LOGS_SEQ';
  l_col   := 'ID';
  l_tab   := p_app||'_LOGGER_LOGS';

  l_maxval := bepaal_max_value(p_schema, l_col, l_tab);
  Reset_Seq(p_schema, l_seq, l_maxval);
end reset_logger_sequence;

procedure enable_queues(p_schema varchar2)
is
begin

   for i in (select name  , queue_type from user_queues)
   loop
     log(i.name);
     if (i.queue_type != 'EXCEPTION_QUEUE')
     then
        null;
        --dbms_aqadm.start_queue(queue_name => p_schema||'.'||i.name);
     else
        null;
        --dbms_aqadm.start_queue(queue_name => p_schema||'.'||i.name, enqueue => FALSE, dequeue => TRUE);
     end if;
   end loop;
end enable_queues;

  procedure remap_spatial_index_tbs(p_schema in varchar2, p_tbs_orig varchar2, p_tbs_new varchar2)
  is
    l_sql     varchar2(4000);
    cursor c_indexes is
      select uic.table_name, uic.index_name, uic.column_name, ui.parameters
        from user_indexes ui,
             user_ind_columns uic
       where ui.index_type      = 'DOMAIN'
         and ui.domidx_opstatus = 'FAILED'
         and (INSTR(UPPER(ui.parameters),'TABLESPACE') > 0 and INSTR(UPPER(ui.parameters),UPPER(p_tbs_orig)) > 0)
         and uic.index_name     = ui.index_name
         and uic.table_name     = ui.table_name
         and exists (select 1
                       from user_sdo_index_metadata sim
                      where sim.sdo_index_name = ui.index_name);
  begin
    log('REMAP tbs: '||p_tbs_orig||' -> '|| p_tbs_new);
    for rec in c_indexes
    loop
      begin
         l_sql := 'alter index ' || rec.index_name || ' rebuild PARAMETERS(''' || REPLACE(rec.parameters,p_tbs_orig,p_tbs_new) ||''')';
         dbms_output.put(l_sql || ' - ');
         execute immediate l_sql;
         log(' ');
      exception when others then
         log('FAILED (' || SUBSTR(SQLERRM,1,240) || ')');
      end;
    end loop;
  end remap_spatial_index_tbs;

  procedure reset_grants(p_schema varchar2)
  is
  begin
    null;
  end reset_grants;

  procedure reset_synoniemen(p_schema varchar2)
  is
  begin
    null;
  end reset_synoniemen;



  procedure create_dbaas_framework(p_app varchar2, p_env varchar2)
  is
     l_owner varchar2(1024);
     l_app varchar2(1024);
  begin
     --
     -- Creer de volgende tabellen in het schema:
     --  APPL_SEQUENCE
     --  APPL_SYNONIEMEN
     --  APPL_GRANTS
     --  APPL_SERVICES

     dosql(l_owner, 'begin dbaas_installer.install(''''APPL_SEQ'''','''''||l_owner||''''','''''||l_app||'''''); end;' );
     dosql(l_owner, 'begin dbaas_installer.install(''''APPL_SYN'''','''''||l_owner||''''','''''||l_app||'''''); end;' );
     dosql(l_owner, 'begin dbaas_installer.install(''''APPL_GRA'''','''''||l_owner||''''','''''||l_app||'''''); end;' );
     dosql(l_owner, 'begin dbaas_installer.install(''''APPL_SER'''','''''||l_owner||''''','''''||l_app||'''''); end;' );

  end create_dbaas_framework;


  procedure create_public_synonyms(p_schema varchar2)
  is
   cursor c_synonyms is
     SELECT 'create public synonym '||rtrim(OBJECT_NAME)||' for '||rtrim(OBJECT_NAME)||';' stmt
       FROM user_objects
      WHERE object_type IN ('TABLE','PACKAGE','PROCEDURE','FUNCTION','VIEW','SEQUENCE');

  begin
    for i in c_synonyms
    loop
      begin
        execute immediate i.stmt;
      exception when others then
        log('FOUT: '||i.stmt||': '||SQLERRM);
      end;
    end loop;
  end create_public_synonyms;
  --
procedure verwijder_dblink(p_dblink varchar2)
  is
   l_sql   VARCHAR2(4000);
  begin
      L_SQL := 'drop database link '||p_dblink;
      dbms_output.put_line(l_sql);
      BEGIN
         execute immediate l_sql;
       exception when others then
         dbms_output.put_line('Fout bij het verwijderen van DBLINK: '||p_dblink|| ': '||SQLERRM);
      END;
      return;
  end;
  --
  function maak_db_link(p_host varchar2 default 'ndb', p_service varchar2 default 'ndb', p_portnr number default '1526', p_dbaas_pw varchar2) return varchar2
  as
   l_dbl_source varchar2(30);
   l_sql   varchar2(4000);
   dblink_dubbel exception;
   pragma exception_init (dblink_dubbel, -2011);
   l_dummy varchar2(128);
  begin
      --
      -- Maak een database link naar de source database, naam is tijd afhankelijk
      l_dbl_source := 'QARTO_DBAAS_'||TO_CHAR(sysdate,'SSSSS')||'.DBL';
      --
      l_sql := 'create database link '||l_dbl_source||' CONNECT TO dbaas IDENTIFIED BY '''||p_dbaas_pw||''' using '''||p_host||':'||p_portnr||chr(47)||p_service||'''';
      dbms_output.put_line(l_sql);
      begin
         execute immediate l_sql;
         execute immediate 'select host_name from v$instance@'||l_dbl_source into l_dummy;
         dbms_output.put_line('Query v$instance via database link: ' || l_dummy);
         return l_dbl_source;
       exception 
         when dblink_dubbel 
           then return l_dbl_source;
         when others 
           then
             verwijder_dblink(l_dbl_source);
             dbms_output.put_line('Fout bij het maken van DBLINK2 naar '||p_host||': '||p_service||': '||sqlerrm);
             return null;
      end;
  end maak_db_link; 
  -- 
  procedure compare_users (p_source_user varchar2, p_target_user varchar2 default null, p_host varchar2 default 'rws', p_service varchar2 default 'ndb',p_portnr number default '1526', p_dbaas_pw varchar2 )
  is
  --  p_source_user varchar2(40) := 'PUBLIC';
  --  p_target_user varchar2(40) := 'PUBLIC';
  --  p_host        varchar2(40) := 'sou105.so.kadaster.nl';
  --  p_service     varchar2(40)   := 'OCTNM01P.so.kadaster.nl';
    
    l_statement   varchar2(1024);
    l_source_db   varchar2(40);
    l_db_link     varchar2(128);
    
    l_host        varchar2(40);
    l_service     varchar2(40);
    
    l_privs       sys_refcursor;
    type t_role_privs is record ( granted_role varchar2(30) 
                                , admin_option varchar2(3)  
                                , default_role varchar2(3)  
                                );
                                
    l_role_privs  t_role_privs;
    
    type t_sys_privs is record ( privilege    varchar2(40) 
                               , admin_option varchar2(3)  
                               );
    l_sys_privs   t_sys_privs;
    type t_tab_privs is record ( owner       varchar2(30) 
                               , table_name  varchar2(64) 
                               , grantor     varchar2(30) 
                               , privilege   varchar2(40) 
                               , grantable   varchar2(3)  
                               , hierarchy   varchar2(3)
                               );
    l_tab_privs   t_tab_privs;
    l_target_user varchar2(40);
  
  begin
  
    if p_service is null
    then
      l_source_db := '';
    else 
      l_db_link := maak_db_link (p_host => p_host, p_service => p_service, p_portnr=>p_portnr, p_dbaas_pw=>p_dbaas_pw);
      l_source_db := '@' || l_db_link;
    end if;
    
    l_target_user := nvl(p_target_user, p_source_user);
    
    -- Missende role privileges    
    l_statement := q'[select granted_role, admin_option, default_role from DBA_ROLE_PRIVS]' || l_source_db || q'[ where grantee = upper(']' || p_source_user || q'[') minus select granted_role, admin_option, default_role from DBA_ROLE_PRIVS where grantee = upper(']' || l_target_user || q'[')]' ;
    log ('Role privileges missend bij ' || l_target_user);
    l_privs := doe_query (l_statement);
      LOOP
        FETCH l_privs INTO l_role_privs;
        EXIT WHEN l_privs%NOTFOUND;
        log(' role: ' ||  l_role_privs.granted_role || ' admin: ' ||  l_role_privs.admin_option|| ' default: ' ||  l_role_privs.default_role);
      END LOOP;
      CLOSE l_privs;
    
    -- extra role privileges
    l_statement := q'[select granted_role, admin_option, default_role from DBA_ROLE_PRIVS where grantee = upper(']' || l_target_user || q'[') minus select granted_role, admin_option, default_role from DBA_ROLE_PRIVS]' || l_source_db || q'[ where grantee = upper(']' || p_source_user || q'[')]' ;
    log ('Extra Role privileges t.o.v. ' || p_source_user || ' in "bron" database');
    l_privs := doe_query (l_statement);
      LOOP
        FETCH l_privs INTO l_role_privs;
        EXIT WHEN l_privs%NOTFOUND;
        log(' role: ' ||  l_role_privs.granted_role || ' admin: ' ||  l_role_privs.admin_option|| ' default: ' ||  l_role_privs.default_role);
      END LOOP;
      CLOSE l_privs;
    
    -- missende sys privileges
    l_statement := q'[select privilege, admin_option from DBA_SYS_PRIVS]' || l_source_db || q'[ where grantee = upper(']' || p_source_user || q'[') minus select privilege, admin_option from DBA_SYS_PRIVS where grantee = upper(']' || l_target_user || q'[')]' ;
    log ('Sys privileges missend bij ' || l_target_user);
    l_privs := doe_query (l_statement);
      LOOP
        FETCH l_privs INTO l_sys_privs;
        EXIT WHEN l_privs%NOTFOUND;
        log(' privilege   : ' || l_sys_privs.privilege    || ' admin_option: ' || l_sys_privs.admin_option);
      END LOOP;
      CLOSE l_privs;
      
    -- extra sys privileges
    l_statement := q'[select privilege, admin_option from DBA_SYS_PRIVS where grantee = upper(']' || l_target_user || q'[') minus select privilege, admin_option from DBA_SYS_PRIVS]' || l_source_db || q'[ where grantee = upper(']' || p_source_user || q'[')]' ;
    log ('Extra Sys privileges t.o.v. ' || p_source_user || ' in "bron" database');
    l_privs := doe_query (l_statement);
      LOOP
        FETCH l_privs INTO l_sys_privs;
        EXIT WHEN l_privs%NOTFOUND;
        log(' privilege   : ' || l_sys_privs.privilege    || ' admin_option: ' || l_sys_privs.admin_option);
      END LOOP;
      CLOSE l_privs;
      
    -- missende tab privileges
    l_statement := q'[select owner, table_name, grantor, privilege,grantable, hierarchy from DBA_TAB_PRIVS]' || l_source_db || q'[ where grantee = upper(']' || p_source_user || q'[') and table_name not like '%/%' minus select owner, table_name, grantor, privilege,grantable, hierarchy from DBA_TAB_PRIVS where grantee = upper(']' || l_target_user || q'[') and table_name not like '%/%' ]' ;
    log ('Tab privileges missend bij ' || l_target_user);
    l_privs := doe_query (l_statement);
      LOOP
        FETCH l_privs INTO l_tab_privs;
        EXIT WHEN l_privs%NOTFOUND;
        log(' owner     : ' || l_tab_privs.owner      || ' table_name: ' || l_tab_privs.table_name || ' grantor   : ' || l_tab_privs.grantor    || ' privilege : ' || l_tab_privs.privilege  || ' grantable : ' || l_tab_privs.grantable  || ' hierarchy : ' || l_tab_privs.hierarchy);
      END LOOP;
      CLOSE l_privs;
    
    -- extra tab privileges
    l_statement := q'[select owner, table_name, grantor, privilege,grantable, hierarchy from DBA_TAB_PRIVS where grantee = upper(']' || l_target_user || q'[') and table_name not like '%/%' minus select owner, table_name, grantor, privilege,grantable, hierarchy from DBA_TAB_PRIVS]' || l_source_db || q'[ where grantee = upper(']' || p_source_user || q'[') and table_name not like '%/%' ]' ;
    log ('Extra Tab privileges t.o.v. ' || p_source_user || ' in "bron" database');
    l_privs := doe_query (l_statement);
      LOOP
        FETCH l_privs INTO l_tab_privs;
        EXIT WHEN l_privs%NOTFOUND;
        log(' owner     : ' || l_tab_privs.owner      || ' table_name: ' || l_tab_privs.table_name || ' grantor   : ' || l_tab_privs.grantor    || ' privilege : ' || l_tab_privs.privilege  || ' grantable : ' || l_tab_privs.grantable  || ' hierarchy : ' || l_tab_privs.hierarchy);
      END LOOP;
      CLOSE l_privs;
    
    if l_db_link is not null
    then
      verwijder_dblink (l_db_link);
    end if;
  end compare_users;

  procedure list_user_privileges (p_user varchar2, p_host varchar2 default 'rws', p_service varchar2 default 'ndb', p_portnr number default '1526', p_dbaas_pw varchar2 )
  is
    l_statement   varchar2(1024);
    l_source_db   varchar2(40);
    l_db_link     varchar2(128);
    
    l_host        varchar2(40);
    l_service     varchar2(40);
    
    l_privs       sys_refcursor;
    type t_role_privs is record ( granted_role varchar2(30) 
                                , admin_option varchar2(3)  
                                , default_role varchar2(3)  
                                );
                                
    l_role_privs  t_role_privs;
    
    type t_sys_privs is record ( privilege    varchar2(40) 
                               , admin_option varchar2(3)  
                               );
    l_sys_privs   t_sys_privs;
    type t_tab_privs is record ( owner       varchar2(30) 
                               , table_name  varchar2(30) 
                               , grantor     varchar2(30) 
                               , privilege   varchar2(40) 
                               , grantable   varchar2(3)  
                               , hierarchy   varchar2(3)
                               );
    l_tab_privs   t_tab_privs;
    l_target_user varchar2(40);
  
  begin
  
    if p_service is null
    then
      l_source_db := '';
    else 
      l_db_link := maak_db_link (p_host => p_host, p_service => p_service, p_portnr=>p_portnr, p_dbaas_pw=>p_dbaas_pw);
      l_source_db := '@' || l_db_link;
    end if;
   
    log ('User privileges voor schema ' || p_user );
 
    -- role privileges
    l_statement := q'[select granted_role, admin_option, default_role from DBA_ROLE_PRIVS]' || l_source_db || q'[ where grantee = upper(']' || p_user || q'[')]' ;
    log ('Role privileges: ');
    log ('#################################################################################################');
    l_privs := doe_query (l_statement);
      LOOP
        FETCH l_privs INTO l_role_privs;
        EXIT WHEN l_privs%NOTFOUND;
        log(' role: ' ||  l_role_privs.granted_role || ' admin: ' ||  l_role_privs.admin_option|| ' default: ' ||  l_role_privs.default_role);
      END LOOP;
      CLOSE l_privs;

    -- sys privileges
    l_statement := q'[select privilege, admin_option from DBA_SYS_PRIVS]' || l_source_db || q'[ where grantee = upper(']' || p_user || q'[')]' ;
    log ('Sys privileges: ');
    log ('#################################################################################################');
    l_privs := doe_query (l_statement);
      LOOP
        FETCH l_privs INTO l_sys_privs;
        EXIT WHEN l_privs%NOTFOUND;
        log(' privilege   : ' || l_sys_privs.privilege    || ' admin_option: ' || l_sys_privs.admin_option);
      END LOOP;
      CLOSE l_privs;
      
    -- tab privileges
    l_statement := q'[select owner, table_name, grantor, privilege,grantable, hierarchy from DBA_TAB_PRIVS]' || l_source_db || q'[ where grantee = upper(']' || p_user || q'[') and table_name not like '%/%' ]' ;
    log ('Tab privileges: ');
    log ('#################################################################################################');
    l_privs := doe_query (l_statement);
      LOOP
        FETCH l_privs INTO l_tab_privs;
        EXIT WHEN l_privs%NOTFOUND;
        log(' owner     : ' || l_tab_privs.owner      || ' table_name: ' || l_tab_privs.table_name || ' grantor   : ' || l_tab_privs.grantor    || ' privilege : ' || l_tab_privs.privilege  || ' grantable : ' || l_tab_privs.grantable  || ' hierarchy : ' || l_tab_privs.hierarchy);
      END LOOP;
      CLOSE l_privs;
    
    if l_db_link is not null
    then
      verwijder_dblink (l_db_link);
    end if;
  end list_user_privileges;

  procedure strip_owner(p_schema varchar2, p_owner varchar2, p_type varchar2)
  is
     l_sql clob;
  begin
     dbms_metadata.set_transform_param(dbms_metadata.session_transform,'PRETTY',true);
     dbms_metadata.set_transform_param(dbms_metadata.session_transform,'SQLTERMINATOR',false);

     for t in (select object_name from dba_objects where owner  = upper(p_schema) and object_type = upper(p_type))
     loop
        select regexp_replace(dbms_metadata.get_ddl(upper(p_type),t.object_name, p_schema) , '('||p_owner||'\.)', '')  
          into l_sql
          from dual;

        log(substr(l_sql, 1, 2000));
        begin
          execute immediate l_sql;
        exception when others then 
          log(SQLERRM);
        end;
     end loop;
  end strip_owner;

  procedure create_appl_geom_metadata(p_schema varchar2)
  as
    l_owner            varchar2(30);
    l_schema_prefix    varchar2(30);
    l_cnt_mapinfo      number(15);
    l_cnt_appl         number(15);
    l_cnt              number(15);
    l_stmnt            varchar2(4000);
    l_upd_stmnt        varchar2(4000);
    l_ins_stmnt        varchar2(4000);
    l_ins_mapinfo      varchar2(4000);
    l_del_mapinfo      varchar2(4000);
    
    
    rc_geom            sys_refcursor;
    l_sdo_owner        varchar2(30);
    l_table_name       varchar2(30);
    l_column_name      varchar2(1024);
    l_diminfo          sdo_dim_array;
    l_srid             number;

    tname        varchar2(30);


  begin
   /*
   ** Vullen systeem metadata tabellen(sdo en evt. mapinfo)
   */
    l_schema_prefix := upper(p_schema);
    l_owner         := l_schema_prefix;
    --
    l_upd_stmnt := q'[update user_sdo_geom_metadata
                         set diminfo =  :l_diminfo
                           , srid    =  :l_srid
                       where table_name = :l_table_name 
                         and column_name = :l_column_name ]';
                         
    l_ins_stmnt := q'[insert into user_sdo_geom_metadata 
                           values (:l_table_name, :l_column_name, :l_diminfo, :l_srid) ]';   
    
    -- log ('Current schema: '|| sys_context('userenv','current_schema'));
    log ('Current user: '|| sys_context('userenv','current_user'));
    execute immediate 'SELECT user FROM dual' into tname;
    log ('Select user from dual geeft: '|| tname);
    -- 
    -- De sdo meta data vullen
    begin
      open rc_geom for 'select table_name, column_name, srid from appl_sdo_geom_metadata ';
        -- Fetch rows from result set one at a time:
      loop
        fetch rc_geom into l_table_name, l_column_name, l_srid;
        exit when rc_geom%NOTFOUND;  -- Exit the loop when we've run out of data
        --
        case 
        when l_srid = 262150 then
          l_diminfo :=  mdsys.sdo_dim_array(mdsys.sdo_dim_element('X',-25000000,325000000,0.5) , mdsys.sdo_dim_element('Y',275000000,650000000,0.5));
        when l_srid in ( 28992, 90112) then
          l_diminfo := mdsys.sdo_dim_array(mdsys.sdo_dim_element('X',-25000 ,325000,0.0005) , mdsys.sdo_dim_element('Y',275000,650000,0.0005));
        end case;
        --
        log('Spatial metadata voor: '||l_table_name||' '||l_column_name||' '||to_char(l_srid));
        --
        select count(*) into l_cnt 
          from user_sdo_geom_metadata 
         where table_name = upper(l_table_name) 
           and column_name = upper(l_column_name);
        -- 
        if tname = l_owner and tname =  sys_context('userenv','current_user') 
        then
          -- nu kan de user view gebruikt worden. de triggers daarop gaan dan goed.
          --
          if l_cnt = 1 then
            log(l_upd_stmnt ||'; tabel: '|| l_table_name ||'; kolom: '|| l_column_name);
            execute immediate l_upd_stmnt using l_diminfo, l_srid, upper(l_table_name), upper(l_column_name); 
            -- dbaas_dba.upd_mdsys_sdo_geom_metadata(l_owner, l_table_name, l_column_name,l_diminfo, l_srid );
          else
            log(l_ins_stmnt ||'tabel: '|| l_table_name ||'; kolom: '|| l_column_name ||' niet in user_geom_metadata: Toevoegen dus!');
            execute immediate l_ins_stmnt using l_table_name, l_column_name, l_diminfo, l_srid;
            -- dbaas_dba.ins_mdsys_sdo_geom_metadata(l_owner, l_table_name, l_column_name,l_diminfo, l_srid );         
          end if;
        else
          log('User, owner en current_user zijn niet gelijk, geen sdo_meta data aangepast!!!!');
        end if;
        --  
      end loop;
      -- Close cursor:
      commit;
      close rc_geom;
    exception 
      when others 
        then
          log('Fout bij opvoeren van spatial meta data: '||sqlerrm);
          if rc_geom%isopen
          then close rc_geom;
          end if;
          rollback;
    end;
    --
  exception
  when others then
    log('Fout in restore_appl_metadata : '||sqlerrm);
  end create_appl_geom_metadata;
    
   function filter_synoniem(p_object_type varchar2, p_object_name varchar2) return boolean
  as
    l_ret boolean := false;
  begin
    --
    -- sommige objecten uitzonderen voor het maken van synoniemen
    -- 
    if p_object_type = 'TABLE' and substr(p_object_name, -2, 2) in ('_1', '_2', '_A', '_B') 
    then
      log ('Melding: '||p_object_name ||'; Voor dit object: ( _1, _2, _A of _B) geen synoniem!');
      l_ret := true;
    end if;
    --
    return l_ret;
  end filter_synoniem;


  function filter_object(p_schema varchar2, p_object varchar2) return boolean
  as
    l_ret boolean := false;
    l_app varchar2(30);
    l_object varchar2(64);
  begin
    l_app := upper(p_schema);
    l_object := upper(p_object);
    case
    when l_object like 'APPL_%' then l_ret := true;
    when l_object like 'MDRT%$%' then l_ret := true;
    when l_object like 'MDRS%$%' then l_ret := true;    
    when l_object like 'MDXT%$%' then l_ret := true;    
    else
     l_ret := false;
    end case;
    
    return l_ret;
  end filter_object;

  procedure revoke_grants (p_schema varchar2)
  is
    l_owner            varchar2(30);
    l_schema_prefix    varchar2(30);

  begin
   /*
   ** Hieronder worden de rechten een voor een op alle objecten van deze owner verwijderd .
   */
    l_schema_prefix := upper(p_schema);
    l_owner         := l_schema_prefix;
    --
    for g in (select * from dba_tab_privs where grantor = l_owner)
    loop
      --
      if not filter_object(l_schema_prefix, g.table_name)
      then 
        -- weghalen maarrrrr
        dbaas_dba.revoke_obj_priv  (p_privilege => g.privilege
                                   ,p_owner     => l_owner
                                   ,p_object    => g.table_name
                                   ,p_grantee   => g.grantee
                                    );      
      end if;
      --
    end loop;  
    --
  exception when others then
    log('Fout in revoke_grants: '||sqlerrm);
  end revoke_grants;
  
  procedure grant_queue_privilege(p_privilege varchar2, p_queue varchar2, p_grantee varchar2, p_grant_option boolean)
  as
  begin
     null;
     --dbms_aqadm.grant_queue_privilege(privilege=>p_privilege
	    --                              ,queue_name=>p_queue
		  --							 ,grantee=>p_grantee
		  --							 ,grant_option=>p_grant_option); 
  end grant_queue_privilege;

  procedure create_grants (p_schema varchar2)
  is
    -- ---
--    type r_grants is record    -- conform het appl_grants record
--      ( GRNT_SCHEMA_PREFIX  VARCHAR2(12),
--        GRNT_OBJECT_NAME    VARCHAR2(30),
--        GRNT_GRANT_TO       VARCHAR2(30),
--        GRNT_PERMISSIONS    VARCHAR2(128));
--    g r_grants;

    rc_grants sys_refcursor;
    
    lr_grnt_schema_prefix  varchar2(1024);
    lr_grnt_object_name    varchar2(1024);
    lr_grnt_grant_to       varchar2(1024);
    lr_grnt_permissions    varchar2(1024);

    
    l_owner         varchar2(30);
    l_grantee          varchar2(30);
    l_grnt_grant_to    varchar2(64);
    l_grnt_object_name varchar2(64);
    l_schema_prefix varchar2(12);
    l_object_type   varchar2(60);
    l_choice        varchar2(10) := 'NOK';

    l_permission        varchar2(128);
    l_grnt_permissions  varchar2(128);
    l_with_grant    boolean := FALSE;

  begin
     -- select sys_context('userenv','current_schema') into l_owner from dual ;
    g_routine       := 'dbaas_schema_utils.create_grants';
    l_schema_prefix := upper(p_schema);
    l_owner         := l_schema_prefix;
    --
    ------  Uitgangspunten  -------
    --                    de grants tabel is gevuld door inserts vanuit de kit. Daar mogen spaties in de kolom inhoud zitten. 
    --                    en lege regels en commentaar zoals -- en #  
    -- Kolom 
    -- grnt_object_name : leeg, #, -- of rem ? dan wordt niks gedaan. 
    --                    Verder, dan mag dit een wildcard bevatten, evt bestaande '*' wordt vervangen door '%'. Bv. 'G%' of '%'; komt een object niet voor, wordt geen grant uitgevoerd.
    -- grnt_grant_to    : bevat altijd een deels expliciete string: een role of een user, (bv _ADM) 
    --                    bij _OWN of vreemde schema-rollen, móet ook de APP zijn aangegeven(bv CID_OWN)).
    --                    voor owner users wordt de omgeving letter <otap> toegevoegd, 
    --                    voor de 'eigen' <p_app> roles wordt de environment <env> toegevoegd(bv R_CP1<APP>_DML), álle anderen worden (nog)letterlijk overgenomen(CP1 bv wordt niet gecheckd)
    -- grnt_permissions : is niet verplicht, maar wanneer gevuld altijd expliciet. (select, update, insert, delete, execute) check wordt uitgevoerd voor table en view.
    --                    indien niet gevuld wordt de grant afhankelijk van het soort object en de role gemaakt(SEL krijgt select, DML krijgt sidu)
    ------
    --
    
    open rc_grants for 'select grnt_schema_prefix, grnt_object_name, grnt_grant_to, grnt_permissions from appl_grants';
      -- Fetch rows from result set one at a time:
    loop
      fetch rc_grants into lr_grnt_schema_prefix, lr_grnt_object_name, lr_grnt_grant_to, lr_grnt_permissions;
      exit when rc_grants%NOTFOUND;  -- Exit the loop when we've run out of data

--    for g in (select * from appl_grants) 
--    loop
      -- lege regels overslaan('2e kolom leeg of met spaties gevuld')
      if lr_grnt_object_name is null                                          -- gewoon leeg 
         or regexp_replace(lr_grnt_object_name,' ',null) is null              -- alleen spaties
         or substr(regexp_replace(lr_grnt_object_name,' ',null),1,1) = '#'    -- commentaar regel
         or substr(regexp_replace(lr_grnt_object_name,' ',null),1,2) = '--'   -- commentaar regel
         or substr(regexp_replace(lr_grnt_object_name,' ',null),1,3) = 'rem'  -- commentaar regel
      then
        continue;
      end if;
      
      -- spaties verwijderen en * naar % converteren, daarna UPPER maken
      -- l_grnt_object_name := lr_grnt_object_name;

      l_grnt_object_name := upper(regexp_replace(regexp_replace(lr_grnt_object_name,' ',null),'\*','%')); -- wildcards toegestaan, let op de escape \ voor de asterisk
      l_grnt_grant_to    := upper(lr_grnt_grant_to); -- geen wildcards toegestaan, moet gevuld zijn
      l_grnt_permissions := upper(lr_grnt_permissions); -- geen wildcards toegestaan en kan leeg zijn
      -- Grant to whom? 
      -- It starts with a:....
      -- log('Grant to whom: '||l_grnt_grant_to);
      l_grantee := l_grnt_grant_to;
      --
      -- if owner then add admin option and add otap letter to grantee
      if l_grantee in ('ADM' ,'ATTIC', 'WDI_EIGENAAR'  )
      then  l_with_grant := TRUE;
      else  l_with_grant := FALSE;
      end if;
      --
      --log('Grant to whom, na bepaling: '||l_grantee);
      -- grantee is specific now, on to the objects
            
      --log ('like upper('|| l_grnt_object_name);
      
      for i in (select object_name, object_type 
                  from user_objects 
                 where object_type in ('TABLE', 'VIEW', 'PACKAGE', 'PROCEDURE', 'FUNCTION', 'TYPE', 'SEQUENCE') 
                   and object_name like upper(l_grnt_object_name)
                   -- no grants for external tables
                   and object_name not in (
                          select table_name 
                            from user_external_tables 
                           where table_name like upper(l_grnt_object_name))
                           )
      loop
        -- log ('Gevonden object: '|| i.object_name) ;
        if filter_object(p_schema, i.object_name)
        then 
          -- some specific user objects excluded
          continue;
        end if;
        --
        l_object_type := i.object_type ;
        --
        log('grant debug record: '||lr_grnt_permissions ||', '|| i.object_name||', '|| l_grantee);
        --
        case 
          when l_object_type in ('TABLE', 'VIEW') 
          then
            -- If needed, add and check standard permissions for roles
            if l_grnt_permissions is null 
            then
              l_permission := 'insert,update,delete,select';
              l_choice := 'OK';              
            else
              -- check grnt_permissions
              if (instr(lower(lr_grnt_permissions),'select') > 0 or
                  instr(lower(lr_grnt_permissions),'insert') > 0 or
                  instr(lower(lr_grnt_permissions),'delete') > 0 or
                  instr(lower(lr_grnt_permissions),'update') > 0 )
              then
                l_permission := l_grnt_permissions;
                l_choice := 'OK';
              else
                l_choice := 'NOK';
              end if;            
            end if;
          when l_object_type in ('PACKAGE', 'PROCEDURE', 'FUNCTION', 'TYPE') 
          then
            l_permission := 'execute';
            l_choice := 'OK';
          when l_object_type in ('SEQUENCE') 
          then
            l_permission := 'select';
            l_choice := 'OK';
          else
            l_choice := 'NOK';
        end case;
        --
        -- Do it!
        --
        if l_choice = 'OK' then
                   
          begin
            dbaas_dba.grant_obj_priv(p_privilege   => l_permission
                                     ,p_owner      => l_owner
                                     ,p_object     => i.object_name
                                     ,p_grantee    => l_grantee
                                     ,p_with_grant => l_with_grant);
          exception
            when others then
              log('ORA-FOUT: '||i.object_name||': '||sqlerrm);
          end;
          --               
        else
          log('grant privilege to choice (nok): ' || l_object_type);
        end if;        
      end loop;
    end loop;
      -- Close cursor:
    close rc_grants;
  
  exception 
    when others then
      log('Fout bij in create_grants: '||sqlerrm);
      if rc_grants%isopen
      then
        close rc_grants;
      end if;
  end create_grants;   
  --
  PROCEDURE create_synoniemen( p_schema varchar2)
  as
    -- 
    l_owner            varchar2(30);
    l_schema_prefix    varchar2(30);
    l_object_name      varchar2(64);
    l_syn_owner        varchar2(30);
    l_syn_name         varchar2(64);
    l_cnt              number;
    l_sql              varchar2(4000);
    l_syn_owner_exists boolean := TRUE;
    l_object_exists    boolean := TRUE;
    --
    rc_syns  sys_refcursor;
    -- synoniemen record kolommen
    lr_synm_schema_prefix  varchar2(1024);
    lr_synm_object_name    varchar2(1024);
    lr_synm_synonym_owner  varchar2(1024);
    lr_synm_synonym_name   varchar2(1024);

    
  begin
  
    l_schema_prefix := upper(p_schema);
    l_owner         := l_schema_prefix;
    --
    -- De synoniemen tabel doorlopen...
    --
    open rc_syns for ('select synm_schema_prefix,synm_object_name,synm_synonym_owner, synm_synonym_name from appl_synoniemen');

    -- for s in (select * from appl_synoniemen)
    loop
      fetch rc_syns into lr_synm_schema_prefix, lr_synm_object_name,lr_synm_synonym_owner, lr_synm_synonym_name;
      exit when rc_syns%NOTFOUND;  -- Exit the loop when we've run out of data
      -- l_schema_prefix   := upper(lr_synm_schema_prefix);
      l_object_name     := upper(lr_synm_object_name);
      l_syn_owner       := upper(lr_synm_synonym_owner);
      lr_synm_synonym_name        := upper(lr_synm_synonym_name);
      --
      log(' SYM_NAME: '||lr_synm_synonym_name||' SYN_OWNER: '||l_syn_owner||' -> '||l_owner||' OBJECT: '||lr_synm_object_name ||' -> '||l_object_name);
      --
      -- Wanneer object-name % dan mag syn-name niet, of alleen met dezelfde waarde, zijn gevuld
      --
      -- Het object mag gevuld zijn met %, dan moet synonymnaam leeg zijn of ook die % bevatten. 
      -- Er mag slechts één % in object staan. Wanneer het object naast die % ook andere characters bevat, 
      -- dan moet die % het laatste character zijn. De synonymnaam mag dan leeg zijn, is die wél gevuld dan 
      -- moet dat overeenkomen voor zover die % staat. (voorbeeld: obj �`TT%¿ syn �`T%¿ of zelfs TT% vs TT% is goed, maar TT% en TTT% is niet toegestaan!

      if instr(l_object_name, '%') <> 0 then
        -- een wildcard!, we gaan ervanuit dat er 1 voorkomen in zit
        if lr_synm_synonym_name is not null  -- dan is er iets te controleren
        then 
          if instr(lr_synm_synonym_name, '%') = 0 -- Mag niet! in object wildcard, dan ook in synonym wild card
            or instr(lr_synm_synonym_name, '%') > instr(l_object_name, '%') -- Mag ook niet  (obj 'T%' syn 'TT%) 
            or substr(l_object_name,1,instr(lr_synm_synonym_name, '%')-1) <>  substr(lr_synm_synonym_name,1,instr(lr_synm_synonym_name, '%')-1) -- Mag ook niet  (obj 'TT%' syn 'A%)
          then
            log ('Fout: Inconsistentie bij vulling van record voor object '|| l_object_name ||' v.lr_ synoniem: '|| lr_synm_synonym_name);
            continue; -- volgende record van appl-synoniemen
          end if;
        end if;
      end if;
      --
      -- De aangegeven synonym owner moet wel aanwezig zijn
      -- NB: Nog te implementeren? Mag de owner ook alleen % bevatten, dan alle syns aanmaken voor de standaard users(MUT, LEES en ADM(en evt CTL))?
      --
      /*
      SYNM_SCHEMA_PREFIX    SYNM_OBJECT_NAME    SYNM_SYNONYM_OWNER    SYNM_SYNONYM_NAME
      KLC    adba_s01_klc    klc_adm    adba_s01_klc
      KLC    adba_s01_klc    klc_lees    adba_s01_klc
      */ 
      l_syn_owner_exists := TRUE;
      --
      if (substr(l_syn_owner,1,(instr(l_syn_owner,'_'))-1)) = '%'
      then
        -- Dan moet de synonymowner eentje van de standaard users(mut|lees|adm of ctl) zijn
        if l_syn_owner in ('ADM', 'ATTIC', 'WDI_EIGENAAR') or l_syn_owner = 'PUBLIC'
        then  
          log ('=> '||upper(l_syn_owner));
          select count(*) into l_cnt from dba_users where username like upper(l_syn_owner);
          case 
          when l_cnt = 0 then
            log('=> FOUT2; kan geen synoniem(en) voor '|| l_syn_owner ||' maken, dat schema is niet aanwezig!');
            l_syn_owner_exists := FALSE;          
          when l_cnt > 1 then
            log('=> FOUT4; kan geen synoniem(en) voor '|| l_syn_owner ||' maken, er zijn meerdere van aanwezig!');
            l_syn_owner_exists := FALSE;
          else
            -- de gevonden username ophalen
            select username into l_syn_owner from dba_users where username like upper(l_syn_owner);
          end case;
        else
          log('=> FOUT3; kan geen synoniem(en) voor '|| l_syn_owner ||' maken, dat schema is geen standaardschema[PUBLIC]!');
          l_syn_owner_exists := FALSE;
        end if;
      end if;    
      --
      -- Wanneer de syn_owner aanwezig is, kan er begonnen worden met synonymen te maken voor de aangegeven objecten.
      --
      if l_syn_owner_exists 
      then
        --       
        if instr(l_object_name, '@') > 0  -- is het een databaselink?
        then
          --
          -- bij een dblink moet de syn-name zijn gevuld, anders wordt de @ door _ vervangen(check op #characters)
          -- 
          if upper(lr_synm_synonym_name) is null or upper(lr_synm_synonym_name) = '%' 
          then
            l_syn_name := replace(l_object_name,'@', '_');
          else 
            l_syn_name := upper(lr_synm_synonym_name);
          end if;
          --
          -- Dan kun je niet checken of dat doel-object bestaat, dus 'plat' aanmaken maar
          --
          if upper(l_syn_owner) = 'PUBLIC'
          then
            l_sql := 'create or replace public synonym '|| l_syn_name||' for '|| l_owner ||'.'||l_object_name;
          else
            l_sql := 'create or replace synonym '||l_syn_owner||'.'|| l_syn_name ||' for '|| l_owner ||'.'|| l_object_name;
          end if;
          begin
            log(l_sql);
            execute immediate l_sql;         
          exception when others then
            log(l_sql||': '||SQLERRM);
          end;
          
        else  
          -- alle andere objecten moeten bestaan ten tijde van aanmaken synoniemen
          l_object_exists := FALSE;
          
          for i in (select object_name , object_type
                 from user_objects
                where object_name like upper(l_object_name)
                  and object_type in ('SYNONYM', 'TABLE', 'VIEW', 'SEQUENCE', 'PACKAGE', 'PROCEDURE', 'FUNCTION', 'TYPE')
                 )
          loop
          
            if filter_object(p_schema, i.object_name) or filter_synoniem(i.object_type,i.object_name) -- sommigen nog extra uitfilteren
            then 
              continue;
            end if;      
            
            l_object_exists := TRUE;
            
            begin
              if upper(lr_synm_synonym_name) is null or instr(lr_synm_synonym_name, '%') > 0
              then
                l_syn_name := i.object_name;
              else 
                l_syn_name := upper(lr_synm_synonym_name);
              end if ;

              if upper(l_syn_owner) = 'PUBLIC'
              then
                l_sql := 'create or replace public synonym '|| l_syn_name||' for '|| l_owner ||'.'|| i.object_name;
              else
                l_sql := 'create or replace synonym '||l_syn_owner||'.'|| l_syn_name||' for '|| l_owner ||'.'|| i.object_name;
              end if;

              log(l_sql);
              execute immediate l_sql;
         
            exception when others then
              log(l_sql||': '||sqlerrm);
            end;
          end loop;
          
          -- Was er wel een object gevonden voor dit record? Zo niet dan aangeven, want dat record is wellicht niet nodig?
          if not l_object_exists then
             log ( ' Geen synonym gemaakt; Voor in dit record aangegeven object(en): '|| l_object_name || ' is geen enkel voorkomen gevonden: '|| l_owner ); 
          end if;
           
        end if;
        
      end if;
    end loop;
    -- Close cursor:
    close rc_syns;
    
  exception 
    when others then
      log('Fout bij opvoeren SYNONIEMEN: '||sqlerrm);
      if rc_syns%isopen
      then
        close rc_syns;
      end if;
  end create_synoniemen; 

  procedure enable_job(p_jobname varchar2)
  is
  begin
    dbms_scheduler.enable(p_jobname);
  end enable_job;

  procedure disable_job(p_jobname varchar2)
  is
  begin
    dbms_scheduler.disable(p_jobname);
  end disable_job;

  procedure rebuild_spatial_indexes(p_status in out number, p_message in out varchar2) 
  is
  --
  -- created: bijste 03/02/15
  -- todo: - return p_status waarden (0, 1, 2, 3)?
  --       - volledige rebuild online mogelijk in versie 11.2.0.4?
  --
      cursor c1
      is
         select index_name,
            table_name,
            PARAMETERS
         from user_indexes
         where index_type = 'DOMAIN'
      order by index_name;
      --
      l_sql varchar2(200) ;
      --
   begin 
      p_status := 0;
      begin
      --
      g_text := 'Start rebuild_spatial_indexes.' ;
      log(g_text) ;
      --
      for i in c1
      loop
         begin
            g_text := 'Rebuilden index ' || i.index_name || ' op tabel '|| i.table_name || '...' ;
            log( g_text) ;
            --
            l_sql := 'alter table ' ||  i.table_name || ' read only' ;
            execute immediate l_sql;
            --
            l_sql := 'alter index ' ||  i.index_name || ' rebuild online parameters ('||''''||I.PARAMETERS||' index_status=cleanup'')' ;
            execute immediate l_sql;
            --
            l_sql := 'alter index ' ||  i.index_name || ' rebuild' ;
            execute immediate l_sql;
            --
            l_sql := 'alter table ' ||  i.table_name || ' read write' ;
            execute immediate l_sql;
            --
            p_status := 0;
            --
         exception
         when others then
            p_status := 1;
            p_message := 'Fout bij rebuild ' || i.index_name || ': ' || sqlerrm ;
            log( p_message) ;
            begin
               l_sql := 'alter table ' ||  i.table_name || ' read write' ;
               execute immediate l_sql;
            exception when others then
               p_status := 2;
               p_message := 'Fout bij reset to read-write ' || i.index_name || ': ' || sqlerrm ;
               log( p_message) ;
            end;
            continue;
            --
         end;
         --
      end loop;
      --
      g_text := 'Einde rebuild_spatial_indexes.' ;
      log( g_text);
      --
      exception when others then
       p_status := 3;
       p_message := SQLERRM;
       log( p_message);
      end;
  end rebuild_spatial_indexes;

  procedure rebuild_normal_indexes(p_status in out number, p_message in out varchar2)
  is
  --
  -- created: bijste 03/02/15
  -- todo: - return p_status waarden (0, 1, 2, 3)?
  --       - rebuild online mogelijk?
  --       - rebuild initrans 10? compute statistics?
  --
  cursor c1 
  is
     select index_name 
     from user_indexes
     where index_type = 'NORMAL' 
     and temporary = 'N'
     order by index_name; 
 --
 l_sql varchar2(200);
 --
 begin
  --
  p_status := 0;
  g_text := 'Start rebuild normal indexes. ' ;
  log( g_text);
  --
  begin
  for i in c1 
     loop
      l_sql := 'alter index ' ||  i.index_name || ' rebuild initrans 10';
      g_text := 'Rebuild index ' || i.index_name || ' gereed.' ;
      log( g_text);
      --
      begin
        --
        execute immediate l_sql;
        --
      exception when others then 
        p_message := 'Fout bij uitvoeren van ALTER INDEX ' ||  i.index_name || ': '||sqlerrm ;
        log( p_message);
      end;
      --
     end loop;
  --
  g_text := 'Einde rebuild normal indexes.' ;
  log( g_text);
  --
  exception when others then
     p_status := 3;
     p_message := sqlerrm;
     log( p_message);
  end;
  --
  end rebuild_normal_indexes;

  procedure gather_schema_statistics(p_status in out number, p_message in out varchar2)
  is
  --
  l_schema varchar2(32);
  --
  begin
    --
    p_status := 0;
    SELECT sys_context('USERENV', 'CURRENT_SCHEMA') into l_schema FROM DUAL;
    g_text := 'Aanroep gather_schema_statistics (' || l_schema || ').' ;
    log( g_text);
    --
    begin
       --
       dbms_STATS.GATHER_schema_STATS(ownname => l_schema, estimate_percent => 30, no_invalidate => false);
       --
    exception when others then
     p_status := 3;
     p_message := SQLERRM;
     log( g_text);
    end;
    -- 
    g_text := 'Einde gather_schema_statistics.' ;
    log( g_text);
  end gather_schema_statistics;

  procedure alter_queue(p_queue in varchar2, p_max_retries number, p_retry_delay number, p_retention_time number, p_comment varchar2)
  is
  begin
    null;
    --dbms_aqadm.alter_queue(p_queue, p_max_retries, p_retry_delay, p_retention_time, TRUE, p_comment);
  end alter_queue;

  procedure purge_recyclebin
  is
  begin
     execute immediate 'purge recyclebin';
  end purge_recyclebin;

end dbaas_schema_utils;
/


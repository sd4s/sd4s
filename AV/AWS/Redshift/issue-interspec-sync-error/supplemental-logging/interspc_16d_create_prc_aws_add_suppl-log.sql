--
-- Create ADD-SUPPLEMENTAL-LOGGING PROCEDURE
--
--drop procedure dba_aws_add_supplemental_log;
--
create or replace procedure dba_aws_add_supplemental_log (p_table_name IN varchar2 default null
                                                        , p_debug      IN varchar2 default 'J' )
is
--*****************************************************************************************************************
--Procedure om voor alle tabellen in stuurtabel DBA_AWS_SUPPLEMENTAL_LOG
--de supplemental-log aan te zetten.
--ASL_ID              NUMBER(10)
--ASL_SCHEMA_OWNER    varchar2(100)   
--ASL_TABLE_NAME      varchar2(100)  
--ASL_PK_EXISTS_JN    varchar2(1)
--ASL_SUPPL_LOG_TYPE  varchar2(3)
--ASL_IND_ACTIVE_JN   varchar2(1)  
--ASL_ACTIVATION_DATE DATE
--ASL_OPMERKING       varchar2(1000)
--
--LET OP: De database moet hiervoor al geschikt zijn gemaakt. Dit is gedaan met commando:
--        ALTER DATABASE ADD SUPPLEMENTAL LOG DATA;
--        alter system switch logfile; 
--
--LET OP: Indien in DEBUG-MODE=J dan vantevoren in sessie ook SET SERVEROUTPUT ON meegeven 
--        om dbms_output te krijgen.
--
--Parameters:
--p_table_name    : Indien leeg <null> dan worden alle tabellen uit de stuurtabel van supplemental-log voorzien.
--                  Indien gevuld met naam van een tabel dan wordt alleen die tabel aangepast.
--p_debug         : Indien <null>/'J' dan wordt er alleen een test-run gedraaid om te zien wat het resultaat IS
--                  Indien 'N' dan worden alle tabellen uit stuurtabel/parameter-tabel van supplemental-logging voorzien.
--
--Op basis van stuurtabel-attribuut ASL_SUPPL_LOG_TYPE ("PK","ALL") wordt de juist supplemental-logging aangezet.
--*****************************************************************************************************************
g_procedure           varchar2(100)  := 'dba_aws_supplemental_log';
pl_table_name         varchar2(100);
pl_debug              varchar2(1);
--
rc_suppl_log          sys_refcursor;
lr_ASL_id             number;
lr_schema_owner       varchar2(100);
lr_table_name         varchar2(100);
lr_pk_exists_jn       varchar2(1);
lr_suppl_log_type     varchar2(3);
lr_ind_active_jn      varchar2(1);
lr_activation_date    date;
-- 
l_ASL_id               number;  
l_schema_owner         varchar2(100);
l_table_name           varchar2(100);
l_pk_exists_jn         varchar2(1);
l_suppl_log_type       varchar2(3);
l_ind_active_jn        varchar2(1);
l_activation_date      date;
--
l_message             varchar2(1000);
l_add_statement       varchar2(1000) ;
l_pk_statement        varchar2(1000) := ' ADD SUPPLEMENTAL LOG DATA (PRIMARY KEY) COLUMNS';
l_all_statement       varchar2(1000) := ' ADD SUPPLEMENTAL LOG DATA (ALL) COLUMNS';
begin
  -- select sys_context('userenv','current_schema') into l_owner from dual ;
  pl_table_name    := upper(p_table_name);
  pl_debug         := upper(nvl(p_debug,'J'));
  --
  ------  Uitgangspunten  -------
  -- De tabel DBA_AWS_SUPPLEMENTAL_LOG is gevuld door inserts door DBA. 
  -- Kolom 
  -- schema_owner : Owner van de tabel waar supplemental-log op aangezet moet worden
  -- table_name   : Table-name, moet expliciet worden opgegeven
  -- pk_exists_jn : Indicator of er op de tabel wel/niet een PK aanwezig is.
  --                Indien "J" dan: ALTER TABLE <Tablename> ADD SUPPLEMENTAL LOG DATA (PRIMARY KEY) COLUMNS;
  --                Indien "N" dan: ALTER TABLE <TableName> ADD SUPPLEMENTAL LOG DATA (ALL) COLUMNS;
  -- ind_active_jn: Indicator om als beheerder de mogelijkheid te hebben om mechanisme voor een specifieke tabel uit te zetten.
  --
  --
  if pl_table_name is NULL
  then
    --WE SELECTEREN VOORALSNOG ALLEEN DE REGELS ACTIVE=J 
    open rc_suppl_log for 'select ASL_id, ASL_schema_owner, ASL_table_name, ASL_pk_exists_jn, ASL_suppl_log_type, ASL_ind_active_jn, ASL_activation_date from dba_aws_supplemental_log where ASL_ind_active_jn=''J'' ';
  ELSE
    --WE SELECTEREN VOORALSNOG ALLEEN DE REGELS ACTIVE=J 
    open rc_suppl_log for 'select ASL_id, ASL_schema_owner, ASL_table_name, ASL_pk_exists_jn, ASL_suppl_log_type, ASL_ind_active_jn, ASL_activation_date from dba_aws_supplemental_log where ASL_ind_active_jn=''J'' and ASL_table_name='||''''||pl_table_name||'''';
  end if;
  -- Fetch rows from result set one at a time:
  loop
    --INIT
	l_message       := null;
	l_add_statement := null;
	--
    fetch rc_suppl_log into lr_ASL_id, lr_schema_owner, lr_table_name, lr_pk_exists_jn, lr_suppl_log_type, lr_ind_active_jn, lr_activation_date;
    exit when rc_suppl_log%NOTFOUND;  -- Exit the loop when we've run out of data
    -- lege regels overslaan('2e kolom leeg of met spaties gevuld')
    if lr_table_name is null                                          -- gewoon leeg 
    or regexp_replace(lr_table_name,' ',null) is null              -- alleen spaties
    then
      continue;
    end if;
    -- spaties verwijderen en daarna UPPER maken
	l_ASL_id          := lr_ASL_id;
	l_schema_owner    := upper(lr_schema_owner);
    l_table_name      := upper(regexp_replace(lr_table_name,' ',null)); 
    l_pk_exists_jn    := upper(lr_pk_exists_jn); 
	l_suppl_log_type  := trim(upper(lr_suppl_log_type));
	l_ind_active_jn   := upper(lr_ind_active_jn);
	l_activation_date := lr_activation_date;
    --
	--eventeel nog controle op een bestaande tabel-waardes...
    for i in (select object_name, object_type 
              from all_objects 
              where object_type in ('TABLE') 
			  and owner like upper(l_schema_owner)
              and object_name like upper(l_table_name)
			  )
    loop
      --
      case 
        when l_suppl_log_type in ('ALL') 
        then
            -- supplemental-log via PK-columns laten lopen
            l_add_statement :=  'ALTER TABLE '||i.object_name|| l_all_statement;
	    when l_suppl_log_type in ('PK')
		then
            l_add_statement :=  'ALTER TABLE '||i.object_name|| l_pk_statement;
        else
            l_add_statement := null;
      end case;
	  --
	  --Indien TABEL al reeds ACTIVATED IS dan hoeven we dit niet opnieuw te doen !!!
	  IF  L_IND_ACTIVE_JN = 'J' 
	  AND L_ACTIVATION_DATE IS NULL 
	  THEN
        --
        -- Do it!
        --
        if nvl(pl_debug,'J') = 'J'   
        then
          if l_add_statement is not NULL
          then
            begin
              dbms_output.put_line( l_add_statement ); 
            exception
              when others 
              then l_message := 'ORA-FOUT: '||i.object_name||': '||sqlerrm;
                   dbms_output.put_line(l_message);
            end;
            --               
          else
            l_message := 'add-statement is null (nok): ' || i.object_name;  
            dbms_output.put_line(l_message);
          end if;    --if add_statement is not null    
          --
        elsif nvl(pl_debug,'J') = 'N'
        then
          if l_add_statement is not NULL
          then
            begin 
              update dba_aws_supplemental_log set ASL_activation_date = sysdate where ASL_id = l_ASL_id;
              EXECUTE IMMEDIATE l_add_statement; 
            exception
              when others 
              then l_message := 'ORA-FOUT: '||i.object_name||': '||sqlerrm;
                   dbms_output.put_line(l_message);
            end;
            --               
          else
            l_message := 'add-statement is null (nok): ' || i.object_name;
            dbms_output.put_line(l_message);
          end if;    --if add_statement is not null    
        end if;    --if l_debug
      ELSE
        l_message := 'TABLE IS ALREADY ACTIVE! '||l_table_name;
        dbms_output.put_line(l_message);
      end if;  --active-J
    --
    end loop;  -- i.object_name
    --
	--
  end loop; --RC_SUPPL_LOG
  -- Close cursor:
  close rc_suppl_log;
  --
exception 
  when others 
  then
    l_message := 'Fout bij in dba_aws_add_supplemental_log: '||sqlerrm;
	dbms_output.put_line(l_message);
    if rc_suppl_log%isopen
    then close rc_suppl_log;
    end if;
	--
	raise;
end dba_aws_add_supplemental_log;  
/
show err



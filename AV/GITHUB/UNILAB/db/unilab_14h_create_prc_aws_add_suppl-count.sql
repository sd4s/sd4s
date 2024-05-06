--
-- Create ADD-SUPPLEMENTAL-COUNT PROCEDURE
--
--drop procedure dba_aws_add_supplemental_count;
--
create or replace procedure dba_aws_add_supplemental_count (p_table_name IN varchar2 default null
                                                          , p_debug      IN varchar2 default 'J' )
is
--*****************************************************************************************************************
--Procedure om voor alle tabellen in stuurtabel DBA_AWS_SUPPLEMENTAL_COUNT
--de supplemental-log aan te zetten.
--ASC_ID              NUMBER(10)
--ASC_SCHEMA_OWNER    varchar2(100)   
--ASC_TABLE_NAME      varchar2(100)  
--ASC_CHECK_DATE      DATE
--ASC_COUNT           NUMBER
--ASC_OPMERKING       varchar2(1000)
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
g_procedure           varchar2(100)  := 'dba_aws_supplemental_count';
pl_table_name         varchar2(100);
pl_debug              varchar2(1);
--
rc_suppl_log          sys_refcursor;
lr_ASL_id             number;
lr_schema_owner       varchar2(100);
lr_table_name         varchar2(100);
-- 
l_ASL_id               number;  
l_schema_owner         varchar2(100);
l_table_name           varchar2(100);
L_ASC_COUNT            number;
--
l_message             varchar2(1000);
l_count_statement       varchar2(1000) ;
begin
  -- select sys_context('userenv','current_schema') into l_owner from dual ;
  pl_table_name    := upper(p_table_name);
  pl_debug         := upper(nvl(p_debug,'J'));
  --
  ------  Uitgangspunten  -------
  -- De tabel DBA_AWS_SUPPLEMENTAL_COUNT is gevuld door inserts door DBA. 
  -- Kolom 
  -- schema_owner : Owner van de tabel waar supplemental-log op aangezet moet worden
  -- table_name   : Table-name, moet expliciet worden opgegeven
  -- ind_active_jn: Indicator om als beheerder de mogelijkheid te hebben om mechanisme voor een specifieke tabel uit te zetten.
  --
  if pl_table_name is NULL
  then
    --WE SELECTEREN VOORALSNOG ALLEEN DE REGELS ACTIVE=J 
    open rc_suppl_log for 'select ASL_id, ASL_schema_owner, ASL_table_name from dba_aws_supplemental_log where ASL_ind_active_jn=''J'' ';
  ELSE
    --WE SELECTEREN VOORALSNOG ALLEEN DE REGELS ACTIVE=J 
    open rc_suppl_log for 'select ASL_id, ASL_schema_owner, ASL_table_name from dba_aws_supplemental_log where ASL_ind_active_jn=''J'' and ASL_table_name='||''''||pl_table_name||'''';
  end if;
  -- Fetch rows from result set one at a time:
  loop
    --INIT
	l_message       := null;
	l_count_statement := null;
	--
    fetch rc_suppl_log into lr_ASL_id, lr_schema_owner, lr_table_name;
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
	  l_asc_count := 0;
      --
      -- supplemental-count
      l_count_statement :=  'SELECT COUNT(*) FROM '||l_schema_owner||'.'||l_table_name;
      begin 
          EXECUTE IMMEDIATE l_count_statement INTO l_asc_count;
          if nvl(pl_debug,'J') = 'J'   
          then
		    l_message := 'table: '||i.object_name||' count: '||l_asc_count;
            dbms_output.put_line(l_message);       
          end if;
          --		  
          insert into dba_aws_supplemental_count (ASC_schema_owner, ASC_table_name, ASC_check_date, asc_count) 
		  values (l_schema_owner, l_table_name, sysdate, l_asc_count);
		  --
		  commit;
		  --
      exception
        when others 
        then l_message := 'ORA-FOUT: '||i.object_name||': '||sqlerrm;
             dbms_output.put_line(l_message);
      end;
      --
    end loop;  -- i.object_name
    --
  end loop; --RC_SUPPL_LOG
  -- Close cursor:
  close rc_suppl_log;
  --
exception 
  when others 
  then
    l_message := 'Fout bij in dba_aws_add_supplemental_count: '||sqlerrm;
	dbms_output.put_line(l_message);
    if rc_suppl_log%isopen
    then close rc_suppl_log;
    end if;
	--
	raise;
end dba_aws_add_supplemental_count;  
/
show err



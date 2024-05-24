--------------------------------------------------------
--  File created - Monday-October-26-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure ADD_DEBUG
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "INTERSPC"."ADD_DEBUG" 
  (p_table in varchar2 default null
  ,p_message in varchar2 default null)
as
  l_message clob;
  l_type varchar2(3);
  --
  procedure add
    (p_description in varchar2
    ,p_msg in clob)
  is
  begin
    if p_msg is not null
    then
      l_message := l_message||p_description||chr(10)||p_msg||chr(10);
    end if;
  end;
  --
  procedure ins
  is
    pragma autonomous_transaction;
  begin
    if l_message is not null
    then
      if p_table = 'ITERROR'
      then
        l_type := 'ERR';
      else
        l_type := 'INF';
      end if;
      --
      insert into it_debug
        (dbg_message, dbg_type, dbg_table)
      values
        (l_message, l_type, p_table);
      --
      commit;
    end if;
  end;
begin
  if user in ('JBR', 'PGO', 'MVL')
  or iapigeneral.session.applicationuser.userid in ('JBR', 'PGO', 'MVL', 'INTERSPC')
  then
    add('CALL STACK:', dbms_utility.format_call_stack());
    add('ERROR STACK:', dbms_utility.format_error_stack());
    add('ERROR BACKTRACE:', dbms_utility.format_error_backtrace());
    add('ERROR MESSAGE:', p_message||' COUNT: '||iapispecificationaccess.ar_cache.count);
    --add('COUNT:', iapispecificationaccess.ar_cache.count);
    --
    ins;
  end if;
exception
  when others
  then
    l_message := sqlerrm;
    --
    ins;
end;

/

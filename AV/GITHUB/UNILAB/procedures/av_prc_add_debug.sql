--------------------------------------------------------
--  File created - dinsdag-oktober-27-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure ADD_DEBUG
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UNILAB"."ADD_DEBUG" 
  (p_table in varchar2 default null
  ,p_message in varchar2 default null
  ,p_sc in varchar2 default null
  ,p_pg in varchar2 default null
  ,p_pgnode in number default null
  ,p_pa in varchar2 default null
  ,p_panode in number default null
  ,p_me in varchar2 default null
  ,p_menode in number default null
  ,p_ss_from in varchar2 default null
  ,p_ss_to in varchar2 default null)
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
begin
  add('CALL STACK:', dbms_utility.format_call_stack());
  add('ERROR STACK:', dbms_utility.format_error_stack());
  add('ERROR BACKTRACE:', dbms_utility.format_error_backtrace());
  add('ERROR MESSAGE:', p_message);
  --
  if l_message is not null
  then
    if p_table = 'UTERROR'
    then
      l_type := 'ERR';
    else
      l_type := 'INF';
    end if;
    --
    insert into atdebug
      (dbg_message, dbg_type, dbg_table, sc, pg, pgnode, pa, panode, me, menode, ss_from, ss_to)
    values
      (l_message, l_type, p_table, p_sc, p_pg, p_pgnode, p_pa, p_panode, p_me, p_menode, p_ss_from, p_ss_to);
  end if;
exception
  when others
  then
    l_message := sqlerrm;
    --
    insert into atdebug
      (dbg_message, dbg_type, dbg_table, sc, pg, pgnode, pa, panode, me, menode, ss_from, ss_to)
    values
      (l_message, 'ERR', p_table, p_sc, p_pg, p_pgnode, p_pa, p_panode, p_me, p_menode, p_ss_from, p_ss_to);
end;

/

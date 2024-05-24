create or replace PACKAGE BODY        unsession
as
--
--select   /*+ RULE */
--         ses.ses_from
--,        ses.ses_to
--,        count(0) ses_count
--from    (select
--         distinct *
--         from    (select   /*+ RULE */
--                           ses.ses_min + ses.ses_from ses_from
--                  ,        ses.ses_min + ses.ses_to ses_to
--                  ,        usr.ses_dbuser
--                  from    (select  (level - 1) / 24 ses_from
--                           ,        level / 24 ses_to
--                           ,        ses.ses_min
--                           from    (select  (trunc (max (ses.ses_logon_date) + 1 / 24, 'hh24') -
--                                             trunc (min (ses.ses_logon_date) + 1 / 24, 'hh24')) * 24 ses_hours
--                                    ,        trunc (min (ses.ses_logon_date), 'hh24') ses_min
--                                    from     at_sessions ses) ses
--                           connect by level <= ses.ses_hours) ses
--                  ,        at_sessions usr
--                  where    length(usr.ses_dbuser) < 5
--                  and      usr.ses_logon_date < ses.ses_min + ses.ses_to
--                  and      ses.ses_min + ses.ses_from <= usr.ses_logoff_date) ses) ses
--group by ses.ses_from
--,        ses.ses_to
--
procedure logon
  (p_sid in number
  ,p_osuser in varchar2
  ,p_machine in varchar2
  ,p_terminal in varchar2
  ,p_program in varchar2
  ,p_logon_date in date)
as
  r_ses at_sessions%rowtype;
begin
  select at_session_seq.nextval
  into   r_ses.ses_seq_no
  from   dual;
  --
  select count(0) + 1
  into   r_ses.ses_count
  from   ctlicusercnt;
  --
  r_ses.ses_sid := p_sid;
  r_ses.ses_logon_date := p_logon_date;
  r_ses.ses_dbuser := user;
  r_ses.ses_osuser := p_osuser;
  r_ses.ses_machine := p_machine;
  r_ses.ses_terminal := p_terminal;
  r_ses.ses_program := upper(p_program);
  --
  insert into at_sessions
  values r_ses;
  --
  begin
    update at_sessions ses1
    set    ses1.ses_logoff_date = sysdate
    where  ses1.ses_logoff_date is null
    and    not exists (select 1
                       from   v$session ses2
                       where  ses2.sid = ses1.ses_sid
                       and    ses2.logon_time = ses1.ses_logon_date);
  exception
    when others
    then
      null;
  end;
  --
  commit;
exception
  when others
  then
    null;
end;
--
function enabled
  return boolean
is
  l_users varchar2(32767);
begin
  select setting_value
  into   l_users
  from   utsystem
  where  setting_name = 'APPLICATION_USERS';
  --
  if l_users is not null
  then
    return instr(l_users, ','||user||',') > 0;
  end if;
  --
  return true;
exception
  when others
  then
    return true;
end;
--
end unsession;
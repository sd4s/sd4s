create or replace PACKAGE BODY aapisession
as
--
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
  aapiTrace.Enter();
  aapiTrace.Param('p_sid', p_sid);
  aapiTrace.Param('p_osuser', p_osuser);
  aapiTrace.Param('p_machine', p_machine);
  aapiTrace.Param('p_terminal', p_terminal);
  aapiTrace.Param('p_program', p_program);
  aapiTrace.Param('p_logon_date', p_logon_date);
  
  select it_session_seq.nextval
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
  
  aapiTrace.Exit();
exception
  when others
  then
    null;
end;
--
end aapisession;
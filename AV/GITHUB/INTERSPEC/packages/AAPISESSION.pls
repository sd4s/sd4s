create or replace PACKAGE        aapisession
as
--
procedure logon
  (p_sid in number
  ,p_osuser in varchar2
  ,p_machine in varchar2
  ,p_terminal in varchar2
  ,p_program in varchar2
  ,p_logon_date in date);
--
end aapisession; 
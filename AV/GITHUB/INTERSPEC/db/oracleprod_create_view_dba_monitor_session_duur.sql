--view om aantallen log-switches te kunnen bekijken.
--Indien aantallen te groot zijn dan is er een onderliggend probleem wat opgelost moet worden.

--conn sys as sysdba

/*
select COUNT(*) from at_sessions where sysdate between ses_logon_date and nvl(ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy'));
select COUNT(*), ses_program from at_sessions where sysdate between ses_logon_date and nvl(ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) group by ses_program;
--
select ses_sid, ses_program, ses_logon_date, ses_logoff_date, trunc((decode(ses_logoff_date,null,sysdate,ses_logoff_date)-ses_logon_date)*60*24) duur from at_sessions where (sysdate-1/24) between ses_logon_date and nvl(ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ;
--
select sid, serial#,program, username,logon_time from v$session where lower(program) in ('scmgt.exe','stdef.exe');
--
*/

--create synonym at_sessions for unilab.at_sessions;
create synonym at_sessions for interspc.at_sessions;
--
--grant select on at_sessions to sys with grant option;


--AV_DBA_MONITOR_CONNECT_DUUR
--AV_DBA_MONITOR_CONNECT_USER

CREATE OR REPLACE VIEW AV_DBA_MONITOR_CONNECT_DUUR
(ses_sid, ses_dbuser, ses_osuser, ses_program, ses_logon_date, ses_logoff_date, duur_minuten)
as
select at.ses_sid, at.ses_dbuser, at.ses_osuser, at.ses_program, at.ses_logon_date, at.ses_logoff_date, trunc((decode(at.ses_logoff_date,null,sysdate,at.ses_logoff_date)-ses_logon_date)*60*24) duur_minuten 
from at_sessions at
where (sysdate-1/24) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) 
and exists (select '' from v$session ses where ses.sid =at.ses_sid ) 
order by duur_minuten
;



--AV_DBA_MONITOR_CONNECT_DUUR
--AV_DBA_MONITOR_CONNECT_USER


--grants + synonyms
grant select on AV_DBA_MONITOR_CONNECT_DUUR to system   with grant option;
grant select on AV_DBA_MONITOR_CONNECT_DUUR to interspc with grant option;
grant select on AV_DBA_MONITOR_CONNECT_DUUR to unilab   with grant option;


prompt
prompt create INTERSPC/UNILAB-VIEW
prompt

--INTERSPEC

CREATE OR REPLACE VIEW INTERSPC.AV_DBA_MONITOR_CONNECT_DUUR
AS
SELECT * FROM SYS.AV_DBA_MONITOR_CONNECT_DUUR
;

--CREATE OR REPLACE VIEW INTERSPC.AV_DBA_MONITOR_CONNECT_USER
--AS
--SELECT * FROM SYS.AV_DBA_MONITOR_CONNECT_USER
--;


--UNILAB

CREATE OR REPLACE VIEW UNILAB.AV_DBA_MONITOR_CONNECT_DUUR
AS
SELECT * FROM SYS.AV_DBA_MONITOR_CONNECT_DUUR
;

--CREATE OR REPLACE VIEW UNILAB.AV_DBA_MONITOR_CONNECT_USER
--AS
--SELECT * FROM SYS.AV_DBA_MONITOR_CONNECT_USER
--;


--einde script

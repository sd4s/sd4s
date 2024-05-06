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

create synonym at_sessions for unilab.at_sessions;
create synonym at_sessions for interspc.at_sessions;
--
--grant select on at_sessions to sys with grant option;


--AV_DBA_MONITOR_CONNECT_DUUR
--AV_DBA_MONITOR_CONNECT_USER


CREATE OR REPLACE VIEW AV_DBA_MONITOR_CONNECT_USER
("day","00","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23")
as
SELECT to_char(trunc(sysdate),'yyyymmdd') day 
, sum( CASE when (trunc(sysdate)+(1/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "00"
, sum( CASE when (trunc(sysdate)+(3/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "01"
, sum( CASE when (trunc(sysdate)+(5/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "02"
, sum( CASE when (trunc(sysdate)+(7/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "03"
, sum( CASE when (trunc(sysdate)+(9/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "04"
, sum( CASE when (trunc(sysdate)+(11/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "05"
, sum( CASE when (trunc(sysdate)+(13/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "06"
, sum( CASE when (trunc(sysdate)+(15/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "07"
, sum( CASE when (trunc(sysdate)+(17/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "08"
, sum( CASE when (trunc(sysdate)+(19/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "09"
, sum( CASE when (trunc(sysdate)+(21/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "10"
, sum( CASE when (trunc(sysdate)+(23/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "11"
, sum( CASE when (trunc(sysdate)+(25/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "12"
, sum( CASE when (trunc(sysdate)+(27/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "13"
, sum( CASE when (trunc(sysdate)+(29/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "14"
, sum( CASE when (trunc(sysdate)+(31/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "15"
, sum( CASE when (trunc(sysdate)+(33/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "16"
, sum( CASE when (trunc(sysdate)+(35/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "17"
, sum( CASE when (trunc(sysdate)+(37/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "18"
, sum( CASE when (trunc(sysdate)+(39/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "19"
, sum( CASE when (trunc(sysdate)+(41/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "20"
, sum( CASE when (trunc(sysdate)+(43/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "21"
, sum( CASE when (trunc(sysdate)+(45/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "22"
, sum( CASE when (trunc(sysdate)+(47/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "23"
from  at_sessions at
where (trunc(sysdate)+(1/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate)+(3/48)  between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate)+(5/48)  between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate)+(7/48)  between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate)+(9/48)  between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate)+(11/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate)+(13/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate)+(15/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate)+(17/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate)+(19/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate)+(21/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate)+(23/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate)+(25/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate)+(27/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate)+(29/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate)+(31/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate)+(33/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate)+(35/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate)+(37/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate)+(39/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate)+(41/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate)+(43/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate)+(45/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate)+(47/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
UNION 
SELECT to_char(trunc(sysdate-1),'yyyymmdd') day 
, sum( CASE when (trunc(sysdate-1)+(1/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "00"
, sum( CASE when (trunc(sysdate-1)+(3/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "01"
, sum( CASE when (trunc(sysdate-1)+(5/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "02"
, sum( CASE when (trunc(sysdate-1)+(7/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "03"
, sum( CASE when (trunc(sysdate-1)+(9/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "04"
, sum( CASE when (trunc(sysdate-1)+(11/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "05"
, sum( CASE when (trunc(sysdate-1)+(13/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "06"
, sum( CASE when (trunc(sysdate-1)+(15/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "07"
, sum( CASE when (trunc(sysdate-1)+(17/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "08"
, sum( CASE when (trunc(sysdate-1)+(19/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "09"
, sum( CASE when (trunc(sysdate-1)+(21/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "10"
, sum( CASE when (trunc(sysdate-1)+(23/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "11"
, sum( CASE when (trunc(sysdate-1)+(25/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "12"
, sum( CASE when (trunc(sysdate-1)+(27/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "13"
, sum( CASE when (trunc(sysdate-1)+(29/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "14"
, sum( CASE when (trunc(sysdate-1)+(31/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "15"
, sum( CASE when (trunc(sysdate-1)+(33/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "16"
, sum( CASE when (trunc(sysdate-1)+(35/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "17"
, sum( CASE when (trunc(sysdate-1)+(37/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "18"
, sum( CASE when (trunc(sysdate-1)+(39/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "19"
, sum( CASE when (trunc(sysdate-1)+(41/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "20"
, sum( CASE when (trunc(sysdate-1)+(43/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "21"
, sum( CASE when (trunc(sysdate-1)+(45/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "22"
, sum( CASE when (trunc(sysdate-1)+(47/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "23"
from  at_sessions at
where (trunc(sysdate-1)+(1/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-1)+(3/48)  between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-1)+(5/48)  between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-1)+(7/48)  between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-1)+(9/48)  between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-1)+(11/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-1)+(13/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-1)+(15/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-1)+(17/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-1)+(19/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-1)+(21/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-1)+(23/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-1)+(25/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-1)+(27/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-1)+(29/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-1)+(31/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-1)+(33/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-1)+(35/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-1)+(37/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-1)+(39/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-1)+(41/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-1)+(43/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-1)+(45/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-1)+(47/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
UNION 
SELECT to_char(trunc(sysdate-2),'yyyymmdd') day 
, sum( CASE when (trunc(sysdate-2)+(1/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "00"
, sum( CASE when (trunc(sysdate-2)+(3/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "01"
, sum( CASE when (trunc(sysdate-2)+(5/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "02"
, sum( CASE when (trunc(sysdate-2)+(7/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "03"
, sum( CASE when (trunc(sysdate-2)+(9/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "04"
, sum( CASE when (trunc(sysdate-2)+(11/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "05"
, sum( CASE when (trunc(sysdate-2)+(13/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "06"
, sum( CASE when (trunc(sysdate-2)+(15/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "07"
, sum( CASE when (trunc(sysdate-2)+(17/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "08"
, sum( CASE when (trunc(sysdate-2)+(19/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "09"
, sum( CASE when (trunc(sysdate-2)+(21/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "10"
, sum( CASE when (trunc(sysdate-2)+(23/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "11"
, sum( CASE when (trunc(sysdate-2)+(25/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "12"
, sum( CASE when (trunc(sysdate-2)+(27/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "13"
, sum( CASE when (trunc(sysdate-2)+(29/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "14"
, sum( CASE when (trunc(sysdate-2)+(31/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "15"
, sum( CASE when (trunc(sysdate-2)+(33/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "16"
, sum( CASE when (trunc(sysdate-2)+(35/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "17"
, sum( CASE when (trunc(sysdate-2)+(37/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "18"
, sum( CASE when (trunc(sysdate-2)+(39/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "19"
, sum( CASE when (trunc(sysdate-2)+(41/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "20"
, sum( CASE when (trunc(sysdate-2)+(43/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "21"
, sum( CASE when (trunc(sysdate-2)+(45/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "22"
, sum( CASE when (trunc(sysdate-2)+(47/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "23"
from  at_sessions at
where (trunc(sysdate-2)+(1/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-2)+(3/48)  between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-2)+(5/48)  between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-2)+(7/48)  between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-2)+(9/48)  between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-2)+(11/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-2)+(13/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-2)+(15/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-2)+(17/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-2)+(19/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-2)+(21/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-2)+(23/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-2)+(25/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-2)+(27/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-2)+(29/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-2)+(31/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-2)+(33/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-2)+(35/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-2)+(37/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-2)+(39/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-2)+(41/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-2)+(43/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-2)+(45/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-2)+(47/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
UNION 
SELECT to_char(trunc(sysdate-3),'yyyymmdd') day 
, sum( CASE when (trunc(sysdate-3)+(1/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "00"
, sum( CASE when (trunc(sysdate-3)+(3/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "01"
, sum( CASE when (trunc(sysdate-3)+(5/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "02"
, sum( CASE when (trunc(sysdate-3)+(7/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "03"
, sum( CASE when (trunc(sysdate-3)+(9/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "04"
, sum( CASE when (trunc(sysdate-3)+(11/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "05"
, sum( CASE when (trunc(sysdate-3)+(13/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "06"
, sum( CASE when (trunc(sysdate-3)+(15/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "07"
, sum( CASE when (trunc(sysdate-3)+(17/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "08"
, sum( CASE when (trunc(sysdate-3)+(19/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "09"
, sum( CASE when (trunc(sysdate-3)+(21/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "10"
, sum( CASE when (trunc(sysdate-3)+(23/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "11"
, sum( CASE when (trunc(sysdate-3)+(25/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "12"
, sum( CASE when (trunc(sysdate-3)+(27/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "13"
, sum( CASE when (trunc(sysdate-3)+(29/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "14"
, sum( CASE when (trunc(sysdate-3)+(31/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "15"
, sum( CASE when (trunc(sysdate-3)+(33/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "16"
, sum( CASE when (trunc(sysdate-3)+(35/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "17"
, sum( CASE when (trunc(sysdate-3)+(37/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "18"
, sum( CASE when (trunc(sysdate-3)+(39/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "19"
, sum( CASE when (trunc(sysdate-3)+(41/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "20"
, sum( CASE when (trunc(sysdate-3)+(43/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "21"
, sum( CASE when (trunc(sysdate-3)+(45/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "22"
, sum( CASE when (trunc(sysdate-3)+(47/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "23"
from  at_sessions at
where (trunc(sysdate-3)+(1/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-3)+(3/48)  between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-3)+(5/48)  between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-3)+(7/48)  between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-3)+(9/48)  between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-3)+(11/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-3)+(13/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-3)+(15/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-3)+(17/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-3)+(19/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-3)+(21/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-3)+(23/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-3)+(25/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-3)+(27/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-3)+(29/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-3)+(31/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-3)+(33/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-3)+(35/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-3)+(37/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-3)+(39/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-3)+(41/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-3)+(43/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-3)+(45/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-3)+(47/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
UNION 
SELECT to_char(trunc(sysdate-4),'yyyymmdd') day 
, sum( CASE when (trunc(sysdate-4)+(1/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "00"
, sum( CASE when (trunc(sysdate-4)+(3/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "01"
, sum( CASE when (trunc(sysdate-4)+(5/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "02"
, sum( CASE when (trunc(sysdate-4)+(7/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "03"
, sum( CASE when (trunc(sysdate-4)+(9/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "04"
, sum( CASE when (trunc(sysdate-4)+(11/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "05"
, sum( CASE when (trunc(sysdate-4)+(13/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "06"
, sum( CASE when (trunc(sysdate-4)+(15/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "07"
, sum( CASE when (trunc(sysdate-4)+(17/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "08"
, sum( CASE when (trunc(sysdate-4)+(19/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "09"
, sum( CASE when (trunc(sysdate-4)+(21/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "10"
, sum( CASE when (trunc(sysdate-4)+(23/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "11"
, sum( CASE when (trunc(sysdate-4)+(25/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "12"
, sum( CASE when (trunc(sysdate-4)+(27/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "13"
, sum( CASE when (trunc(sysdate-4)+(29/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "14"
, sum( CASE when (trunc(sysdate-4)+(31/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "15"
, sum( CASE when (trunc(sysdate-4)+(33/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "16"
, sum( CASE when (trunc(sysdate-4)+(35/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "17"
, sum( CASE when (trunc(sysdate-4)+(37/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "18"
, sum( CASE when (trunc(sysdate-4)+(39/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "19"
, sum( CASE when (trunc(sysdate-4)+(41/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "20"
, sum( CASE when (trunc(sysdate-4)+(43/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "21"
, sum( CASE when (trunc(sysdate-4)+(45/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "22"
, sum( CASE when (trunc(sysdate-4)+(47/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "23"
from  at_sessions at
where (trunc(sysdate-4)+(1/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-4)+(3/48)  between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-4)+(5/48)  between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-4)+(7/48)  between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-4)+(9/48)  between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-4)+(11/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-4)+(13/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-4)+(15/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-4)+(17/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-4)+(19/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-4)+(21/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-4)+(23/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-4)+(25/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-4)+(27/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-4)+(29/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-4)+(31/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-4)+(33/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-4)+(35/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-4)+(37/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-4)+(39/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-4)+(41/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-4)+(43/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-4)+(45/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-4)+(47/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
UNION 
SELECT to_char(trunc(sysdate-5),'yyyymmdd') day 
, sum( CASE when (trunc(sysdate-5)+(1/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "00"
, sum( CASE when (trunc(sysdate-5)+(3/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "01"
, sum( CASE when (trunc(sysdate-5)+(5/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "02"
, sum( CASE when (trunc(sysdate-5)+(7/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "03"
, sum( CASE when (trunc(sysdate-5)+(9/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "04"
, sum( CASE when (trunc(sysdate-5)+(11/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "05"
, sum( CASE when (trunc(sysdate-5)+(13/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "06"
, sum( CASE when (trunc(sysdate-5)+(15/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "07"
, sum( CASE when (trunc(sysdate-5)+(17/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "08"
, sum( CASE when (trunc(sysdate-5)+(19/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "09"
, sum( CASE when (trunc(sysdate-5)+(21/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "10"
, sum( CASE when (trunc(sysdate-5)+(23/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "11"
, sum( CASE when (trunc(sysdate-5)+(25/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "12"
, sum( CASE when (trunc(sysdate-5)+(27/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "13"
, sum( CASE when (trunc(sysdate-5)+(29/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "14"
, sum( CASE when (trunc(sysdate-5)+(31/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "15"
, sum( CASE when (trunc(sysdate-5)+(33/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "16"
, sum( CASE when (trunc(sysdate-5)+(35/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "17"
, sum( CASE when (trunc(sysdate-5)+(37/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "18"
, sum( CASE when (trunc(sysdate-5)+(39/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "19"
, sum( CASE when (trunc(sysdate-5)+(41/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "20"
, sum( CASE when (trunc(sysdate-5)+(43/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "21"
, sum( CASE when (trunc(sysdate-5)+(45/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "22"
, sum( CASE when (trunc(sysdate-5)+(47/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "23"
from  at_sessions at
where (trunc(sysdate-5)+(1/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-5)+(3/48)  between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-5)+(5/48)  between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-5)+(7/48)  between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-5)+(9/48)  between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-5)+(11/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-5)+(13/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-5)+(15/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-5)+(17/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-5)+(19/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-5)+(21/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-5)+(23/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-5)+(25/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-5)+(27/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-5)+(29/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-5)+(31/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-5)+(33/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-5)+(35/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-5)+(37/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-5)+(39/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-5)+(41/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-5)+(43/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-5)+(45/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-5)+(47/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
UNION 
SELECT to_char(trunc(sysdate-6),'yyyymmdd') day 
, sum( CASE when (trunc(sysdate-6)+(1/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "00"
, sum( CASE when (trunc(sysdate-6)+(3/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "01"
, sum( CASE when (trunc(sysdate-6)+(5/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "02"
, sum( CASE when (trunc(sysdate-6)+(7/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "03"
, sum( CASE when (trunc(sysdate-6)+(9/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "04"
, sum( CASE when (trunc(sysdate-6)+(11/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "05"
, sum( CASE when (trunc(sysdate-6)+(13/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "06"
, sum( CASE when (trunc(sysdate-6)+(15/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "07"
, sum( CASE when (trunc(sysdate-6)+(17/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "08"
, sum( CASE when (trunc(sysdate-6)+(19/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "09"
, sum( CASE when (trunc(sysdate-6)+(21/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "10"
, sum( CASE when (trunc(sysdate-6)+(23/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "11"
, sum( CASE when (trunc(sysdate-6)+(25/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "12"
, sum( CASE when (trunc(sysdate-6)+(27/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "13"
, sum( CASE when (trunc(sysdate-6)+(29/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "14"
, sum( CASE when (trunc(sysdate-6)+(31/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "15"
, sum( CASE when (trunc(sysdate-6)+(33/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "16"
, sum( CASE when (trunc(sysdate-6)+(35/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "17"
, sum( CASE when (trunc(sysdate-6)+(37/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "18"
, sum( CASE when (trunc(sysdate-6)+(39/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "19"
, sum( CASE when (trunc(sysdate-6)+(41/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "20"
, sum( CASE when (trunc(sysdate-6)+(43/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "21"
, sum( CASE when (trunc(sysdate-6)+(45/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "22"
, sum( CASE when (trunc(sysdate-6)+(47/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "23"
from  at_sessions at
where (trunc(sysdate-6)+(1/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-6)+(3/48)  between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-6)+(5/48)  between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-6)+(7/48)  between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-6)+(9/48)  between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-6)+(11/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-6)+(13/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-6)+(15/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-6)+(17/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-6)+(19/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-6)+(21/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-6)+(23/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-6)+(25/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-6)+(27/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-6)+(29/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-6)+(31/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-6)+(33/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-6)+(35/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-6)+(37/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-6)+(39/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-6)+(41/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-6)+(43/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-6)+(45/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-6)+(47/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
UNION 
SELECT to_char(trunc(sysdate-7),'yyyymmdd') day 
, sum( CASE when (trunc(sysdate-7)+(1/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "00"
, sum( CASE when (trunc(sysdate-7)+(3/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "01"
, sum( CASE when (trunc(sysdate-7)+(5/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "02"
, sum( CASE when (trunc(sysdate-7)+(7/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "03"
, sum( CASE when (trunc(sysdate-7)+(9/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "04"
, sum( CASE when (trunc(sysdate-7)+(11/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "05"
, sum( CASE when (trunc(sysdate-7)+(13/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "06"
, sum( CASE when (trunc(sysdate-7)+(15/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "07"
, sum( CASE when (trunc(sysdate-7)+(17/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "08"
, sum( CASE when (trunc(sysdate-7)+(19/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "09"
, sum( CASE when (trunc(sysdate-7)+(21/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "10"
, sum( CASE when (trunc(sysdate-7)+(23/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "11"
, sum( CASE when (trunc(sysdate-7)+(25/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "12"
, sum( CASE when (trunc(sysdate-7)+(27/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "13"
, sum( CASE when (trunc(sysdate-7)+(29/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "14"
, sum( CASE when (trunc(sysdate-7)+(31/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "15"
, sum( CASE when (trunc(sysdate-7)+(33/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "16"
, sum( CASE when (trunc(sysdate-7)+(35/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "17"
, sum( CASE when (trunc(sysdate-7)+(37/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "18"
, sum( CASE when (trunc(sysdate-7)+(39/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "19"
, sum( CASE when (trunc(sysdate-7)+(41/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "20"
, sum( CASE when (trunc(sysdate-7)+(43/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "21"
, sum( CASE when (trunc(sysdate-7)+(45/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "22"
, sum( CASE when (trunc(sysdate-7)+(47/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "23"
from  at_sessions at
where (trunc(sysdate-7)+(1/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-7)+(3/48)  between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-7)+(5/48)  between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-7)+(7/48)  between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-7)+(9/48)  between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-7)+(11/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-7)+(13/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-7)+(15/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-7)+(17/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-7)+(19/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-7)+(21/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-7)+(23/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-7)+(25/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-7)+(27/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-7)+(29/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-7)+(31/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-7)+(33/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-7)+(35/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-7)+(37/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-7)+(39/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-7)+(41/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-7)+(43/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-7)+(45/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-7)+(47/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
UNION 
SELECT to_char(trunc(sysdate-8),'yyyymmdd') day 
, sum( CASE when (trunc(sysdate-8)+(1/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "00"
, sum( CASE when (trunc(sysdate-8)+(3/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "01"
, sum( CASE when (trunc(sysdate-8)+(5/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "02"
, sum( CASE when (trunc(sysdate-8)+(7/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "03"
, sum( CASE when (trunc(sysdate-8)+(9/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "04"
, sum( CASE when (trunc(sysdate-8)+(11/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "05"
, sum( CASE when (trunc(sysdate-8)+(13/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "06"
, sum( CASE when (trunc(sysdate-8)+(15/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "07"
, sum( CASE when (trunc(sysdate-8)+(17/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "08"
, sum( CASE when (trunc(sysdate-8)+(19/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "09"
, sum( CASE when (trunc(sysdate-8)+(21/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "10"
, sum( CASE when (trunc(sysdate-8)+(23/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "11"
, sum( CASE when (trunc(sysdate-8)+(25/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "12"
, sum( CASE when (trunc(sysdate-8)+(27/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "13"
, sum( CASE when (trunc(sysdate-8)+(29/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "14"
, sum( CASE when (trunc(sysdate-8)+(31/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "15"
, sum( CASE when (trunc(sysdate-8)+(33/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "16"
, sum( CASE when (trunc(sysdate-8)+(35/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "17"
, sum( CASE when (trunc(sysdate-8)+(37/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "18"
, sum( CASE when (trunc(sysdate-8)+(39/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "19"
, sum( CASE when (trunc(sysdate-8)+(41/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "20"
, sum( CASE when (trunc(sysdate-8)+(43/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "21"
, sum( CASE when (trunc(sysdate-8)+(45/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "22"
, sum( CASE when (trunc(sysdate-8)+(47/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "23"
from  at_sessions at
where (trunc(sysdate-8)+(1/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-8)+(3/48)  between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-8)+(5/48)  between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-8)+(7/48)  between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-8)+(9/48)  between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-8)+(11/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-8)+(13/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-8)+(15/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-8)+(17/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-8)+(19/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-8)+(21/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-8)+(23/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-8)+(25/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-8)+(27/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-8)+(29/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-8)+(31/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-8)+(33/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-8)+(35/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-8)+(37/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-8)+(39/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-8)+(41/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-8)+(43/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-8)+(45/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-8)+(47/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
UNION 
SELECT to_char(trunc(sysdate-9),'yyyymmdd') day 
, sum( CASE when (trunc(sysdate-9)+(1/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "00"
, sum( CASE when (trunc(sysdate-9)+(3/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "01"
, sum( CASE when (trunc(sysdate-9)+(5/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "02"
, sum( CASE when (trunc(sysdate-9)+(7/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "03"
, sum( CASE when (trunc(sysdate-9)+(9/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "04"
, sum( CASE when (trunc(sysdate-9)+(11/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "05"
, sum( CASE when (trunc(sysdate-9)+(13/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "06"
, sum( CASE when (trunc(sysdate-9)+(15/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "07"
, sum( CASE when (trunc(sysdate-9)+(17/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "08"
, sum( CASE when (trunc(sysdate-9)+(19/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "09"
, sum( CASE when (trunc(sysdate-9)+(21/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "10"
, sum( CASE when (trunc(sysdate-9)+(23/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "11"
, sum( CASE when (trunc(sysdate-9)+(25/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "12"
, sum( CASE when (trunc(sysdate-9)+(27/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "13"
, sum( CASE when (trunc(sysdate-9)+(29/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "14"
, sum( CASE when (trunc(sysdate-9)+(31/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "15"
, sum( CASE when (trunc(sysdate-9)+(33/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "16"
, sum( CASE when (trunc(sysdate-9)+(35/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "17"
, sum( CASE when (trunc(sysdate-9)+(37/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "18"
, sum( CASE when (trunc(sysdate-9)+(39/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "19"
, sum( CASE when (trunc(sysdate-9)+(41/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "20"
, sum( CASE when (trunc(sysdate-9)+(43/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "21"
, sum( CASE when (trunc(sysdate-9)+(45/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "22"
, sum( CASE when (trunc(sysdate-9)+(47/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "23"
from  at_sessions at
where (trunc(sysdate-9)+(1/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-9)+(3/48)  between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-9)+(5/48)  between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-9)+(7/48)  between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-9)+(9/48)  between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-9)+(11/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-9)+(13/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-9)+(15/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-9)+(17/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-9)+(19/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-9)+(21/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-9)+(23/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-9)+(25/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-9)+(27/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-9)+(29/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-9)+(31/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-9)+(33/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-9)+(35/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-9)+(37/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-9)+(39/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-9)+(41/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-9)+(43/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-9)+(45/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate-9)+(47/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
group by 1
order by 1
;



/*
CREATE OR REPLACE VIEW AV_DBA_MONITOR_CONC_USERS
AS
SELECT count(*), to_char(trunc(sysdate),'yyyymmdd') day ,to_char( (trunc(sysdate)+(1/48)),'HH24') "00"
from  at_sessions at
where trunc(sysdate)+(1/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) 
UNION
SELECT count(*), to_char(trunc(sysdate),'yyyymmdd') day ,to_char( (trunc(sysdate)+(3/48)),'HH24') "01"
from  at_sessions at
where trunc(sysdate)+(3/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) 
UNION
SELECT count(*), to_char(trunc(sysdate),'yyyymmdd') day ,to_char( (trunc(sysdate)+(5/48)),'HH24') "01"
from  at_sessions at
where trunc(sysdate)+(5/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) 
UNION
SELECT count(*), to_char(trunc(sysdate),'yyyymmdd') day ,to_char( (trunc(sysdate)+(7/48)),'HH24') "01"
from  at_sessions at
where trunc(sysdate)+(7/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) 
UNION
SELECT count(*), to_char(trunc(sysdate),'yyyymmdd') day ,to_char( (trunc(sysdate)+(9/48)),'HH24') "01"
from  at_sessions at
where trunc(sysdate)+(9/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) 
UNION
SELECT count(*), to_char(trunc(sysdate),'yyyymmdd') day ,to_char( (trunc(sysdate)+(11/48)),'HH24') "01"
from  at_sessions at
where trunc(sysdate)+(11/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) 
UNION
SELECT count(*), to_char(trunc(sysdate),'yyyymmdd') day ,to_char( (trunc(sysdate)+(13/48)),'HH24') "01"
from  at_sessions at
where trunc(sysdate)+(13/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) 
UNION
SELECT count(*), to_char(trunc(sysdate),'yyyymmdd') day ,to_char( (trunc(sysdate)+(15/48)),'HH24') "01"
from  at_sessions at
where trunc(sysdate)+(15/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) 
UNION
SELECT count(*), to_char(trunc(sysdate),'yyyymmdd') day ,to_char( (trunc(sysdate)+(17/48)),'HH24') "01"
from  at_sessions at
where trunc(sysdate)+(17/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) 
UNION
SELECT count(*), to_char(trunc(sysdate),'yyyymmdd') day ,to_char( (trunc(sysdate)+(19/48)),'HH24') "01"
from  at_sessions at
where trunc(sysdate)+(19/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) 
UNION
SELECT count(*), to_char(trunc(sysdate),'yyyymmdd') day ,to_char( (trunc(sysdate)+(21/48)),'HH24') "01"
from  at_sessions at
where trunc(sysdate)+(21/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) 
UNION
SELECT count(*), to_char(trunc(sysdate),'yyyymmdd') day ,to_char( (trunc(sysdate)+(23/48)),'HH24') "01"
from  at_sessions at
where trunc(sysdate)+(23/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) 
UNION
SELECT count(*), to_char(trunc(sysdate),'yyyymmdd') day ,to_char( (trunc(sysdate)+(25/48)),'HH24') "01"
from  at_sessions at
where trunc(sysdate)+(25/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) 
UNION
SELECT count(*), to_char(trunc(sysdate),'yyyymmdd') day ,to_char( (trunc(sysdate)+(27/48)),'HH24') "01"
from  at_sessions at
where trunc(sysdate)+(27/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) 
UNION
SELECT count(*), to_char(trunc(sysdate),'yyyymmdd') day ,to_char( (trunc(sysdate)+(29/48)),'HH24') "01"
from  at_sessions at
where trunc(sysdate)+(29/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) 
UNION
SELECT count(*), to_char(trunc(sysdate),'yyyymmdd') day ,to_char( (trunc(sysdate)+(31/48)),'HH24') "01"
from  at_sessions at
where trunc(sysdate)+(31/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) 
UNION
SELECT count(*), to_char(trunc(sysdate),'yyyymmdd') day ,to_char( (trunc(sysdate)+(33/48)),'HH24') "01"
from  at_sessions at
where trunc(sysdate)+(33/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) 
UNION
SELECT count(*), to_char(trunc(sysdate),'yyyymmdd') day ,to_char( (trunc(sysdate)+(35/48)),'HH24') "01"
from  at_sessions at
where trunc(sysdate)+(35/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) 
UNION
SELECT count(*), to_char(trunc(sysdate),'yyyymmdd') day ,to_char( (trunc(sysdate)+(37/48)),'HH24') "01"
from  at_sessions at
where trunc(sysdate)+(37/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) 
UNION
SELECT count(*), to_char(trunc(sysdate),'yyyymmdd') day ,to_char( (trunc(sysdate)+(39/48)),'HH24') "01"
from  at_sessions at
where trunc(sysdate)+(39/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) 
UNION
SELECT count(*), to_char(trunc(sysdate),'yyyymmdd') day ,to_char( (trunc(sysdate)+(41/48)),'HH24') "01"
from  at_sessions at
where trunc(sysdate)+(41/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) 
UNION
SELECT count(*), to_char(trunc(sysdate),'yyyymmdd') day ,to_char( (trunc(sysdate)+(43/48)),'HH24') "01"
from  at_sessions at
where trunc(sysdate)+(43/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) 
UNION
SELECT count(*), to_char(trunc(sysdate),'yyyymmdd') day ,to_char( (trunc(sysdate)+(45/48)),'HH24') "01"
from  at_sessions at
where trunc(sysdate)+(45/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) 
UNION
SELECT count(*), to_char(trunc(sysdate),'yyyymmdd') day ,to_char( (trunc(sysdate)+(47/48)),'HH24') "01"
from  at_sessions at
where trunc(sysdate)+(47/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) 
group by 2,3



SELECT to_char(trunc(sysdate),'yyyymmdd') day 
, sum( CASE when (trunc(sysdate)+(1/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "00"
, sum( CASE when (trunc(sysdate)+(3/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "01"
, sum( CASE when (trunc(sysdate)+(5/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "02"
, sum( CASE when (trunc(sysdate)+(7/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "03"
, sum( CASE when (trunc(sysdate)+(9/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "04"
, sum( CASE when (trunc(sysdate)+(11/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "05"
, sum( CASE when (trunc(sysdate)+(13/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "06"
, sum( CASE when (trunc(sysdate)+(15/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "07"
, sum( CASE when (trunc(sysdate)+(17/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "08"
, sum( CASE when (trunc(sysdate)+(19/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "09"
, sum( CASE when (trunc(sysdate)+(21/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "10"
, sum( CASE when (trunc(sysdate)+(23/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "11"
, sum( CASE when (trunc(sysdate)+(25/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "12"
, sum( CASE when (trunc(sysdate)+(27/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "13"
, sum( CASE when (trunc(sysdate)+(29/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "14"
, sum( CASE when (trunc(sysdate)+(31/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "15"
, sum( CASE when (trunc(sysdate)+(33/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "16"
, sum( CASE when (trunc(sysdate)+(35/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "17"
, sum( CASE when (trunc(sysdate)+(37/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "18"
, sum( CASE when (trunc(sysdate)+(39/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "19"
, sum( CASE when (trunc(sysdate)+(41/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "20"
, sum( CASE when (trunc(sysdate)+(43/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "21"
, sum( CASE when (trunc(sysdate)+(45/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "22"
, sum( CASE when (trunc(sysdate)+(47/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) ) THEN 1 ELSE 0 END ) "23"
from  at_sessions at
where (trunc(sysdate)+(1/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate)+(3/48)  between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate)+(5/48)  between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate)+(7/48)  between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate)+(9/48)  between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate)+(11/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate)+(13/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate)+(15/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate)+(17/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate)+(19/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate)+(21/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate)+(23/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate)+(25/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate)+(27/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate)+(29/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate)+(31/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate)+(33/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate)+(35/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate)+(37/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate)+(39/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate)+(41/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate)+(43/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate)+(45/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
or (trunc(sysdate)+(47/48) between at.ses_logon_date and nvl(at.ses_logoff_date,to_date('31-12-2299','dd-mm-yyyy')) )
group by 1
*/


--AV_DBA_MONITOR_CONNECT_DUUR
--AV_DBA_MONITOR_CONNECT_USER


--grants + synonyms
grant select on AV_DBA_MONITOR_CONNECT_USER to system   with grant option;
grant select on AV_DBA_MONITOR_CONNECT_USER to interspc with grant option;
grant select on AV_DBA_MONITOR_CONNECT_USER to unilab   with grant option;


prompt
prompt create INTERSPC/UNILAB-VIEW
prompt

--INTERSPEC

--CREATE OR REPLACE VIEW INTERSPC.AV_DBA_MONITOR_CONNECT_DUUR
--AS
--SELECT * FROM SYS.AV_DBA_MONITOR_CONNECT_DUUR
--;

CREATE OR REPLACE VIEW INTERSPC.AV_DBA_MONITOR_CONNECT_USER
AS
SELECT * FROM SYS.AV_DBA_MONITOR_CONNECT_USER
;


--UNILAB

--CREATE OR REPLACE VIEW UNILAB.AV_DBA_MONITOR_CONNECT_DUUR
--AS
--SELECT * FROM SYS.AV_DBA_MONITOR_CONNECT_DUUR
--;

CREATE OR REPLACE VIEW UNILAB.AV_DBA_MONITOR_CONNECT_USER
AS
SELECT * FROM SYS.AV_DBA_MONITOR_CONNECT_USER
;


--einde script

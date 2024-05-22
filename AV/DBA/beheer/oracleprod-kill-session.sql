--ORACLE-JOBS krijgen we niet terug te zien onder TOAD-MONITOR-SESSIONS. 
--Ga hiervoor naar de TOP-SESSION-FINDER.

--vraag SID + SERIAL# op
SELECT sid, serial#, status, server, redosize, cpuusedbythissession
from v$session
where username = 'INTERSPC'
and   OSUSER = 'SYSTEM'
--and program like 'ORACLE%J00%'
;
--sid: 8, serial#: 14211




--kill session
ALTER SYSTEM KILL SESSION '8,14211';



--einde script


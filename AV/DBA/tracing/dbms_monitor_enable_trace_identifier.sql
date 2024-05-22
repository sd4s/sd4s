--trigger aanmaken als user: UNILAB !!!
--This parameter can only be used to change the name of the foreground process' trace file; 
--the background processes continue to have their trace files named in the regular format. 
--For foreground processes, the TRACEID column of the V$PROCESS view contains the current value of the TRACEFILE_IDENTIFIER parameter. 
--When this parameter value is set, the trace file name has the following format:

@conn sys/moonflower

grant select any dictionary to UNILAB, PSC;
grant execute on dbms_monitor to UNILAB, PSC;


--controle-query
/*
select   SID
  ,      SERIAL#
  ,      replace(replace(replace(replace(program,' ','_'),'.','_'),'(',''),')','')  program
  ,      replace(machine, '\', '_') machine
  ,      terminal
  from   v$session
  where  sid = sys_context('USERENV','SID')
  and    type = 'USER'
  and    username = user
  ;
*/

--aanmaken DB-TRIGGER
drop trigger UNILAB_TRACE_ALL_LOGINS;

create or replace trigger UNILAB_TRACE_ALL_LOGINS
AFTER LOGON ON DATABASE
--after logon on UNILAB.schema
disable
declare
  l_sid        number;
  l_serial_num number;
  l_osuser     varchar2(100);
  l_program  varchar2(200);
  l_machine  varchar2(200);
  l_terminal varchar2(200);
  l_stmnt    varchar2(2000);
begin
  --alleen voor normale USER + DB-JOBS (NIET VOOR BACKGROUND-JOBS-ORACLE):
  select sid
  ,      serial#
  ,      osuser
  ,      replace(replace(replace(replace(program,' ','-'),'.','-'),'(',''),')','')  program
  ,      replace(machine,'\', '-') machine
  ,      replace(terminal,'_','-') terminal
  into   l_sid
  ,      l_serial_num
  ,      l_osuser
  ,      l_program
  ,      l_machine
  ,      l_terminal
  from   v$session
  where  sid      = sys_context('USERENV','SID')
  and    username = user
  and    type     = 'USER'
  ;
  -- 
  --DBMS_SESSION.set_sql_trace (TRUE);
  sys.dbms_SESSION.SESSION_TRACE_ENABLE(waits=>TRUE,binds=>TRUE,plan_stat=>'ALL_EXECUTIONS');
  --l_stmnt := 'alter session set tracefile_identifier = '||'-'||l_terminal||'-'||l_program||'-'||USER;
  l_stmnt := 'alter session set tracefile_identifier = '''||USER||'-'||l_program||'''' ;
  --dbms_output.put_line('stmnt '||l_stmnt);
  execute immediate l_stmnt;
  --
  --EXECUTE IMMEDIATE 'alter session set tracefile_identifier=''' || l_osuser || '''';
  --
  /*
  if l_program like 'ORACLE%EXE%(J%' 
  then
    l_stmnt := 'alter session set tracefile_identifier = '||'_'||l_terminal||'_'||l_program||'_'||USER;
	dbms_output.put_line('stmnt '||l_stmnt);
    execute immediate l_stmnt;
    sys.dbms_monitor.SESSION_TRACE_ENABLE(session_id=>l_sid,serial_num=>l_serial_num,waits=>TRUE,binds=>TRUE,plan_stat=>'ALL_EXECUTIONS');
  else
    l_stmnt := 'alter session set tracefile_identifier = '||'_'||l_program||'_'||USER;
	dbms_output.put_line('stmnt: '||l_stmnt);
    execute immediate l_stmnt;
    sys.dbms_monitor.SESSION_TRACE_ENABLE(session_id=>l_sid,serial_num=>l_serial_num,waits=>TRUE,binds=>TRUE,plan_stat=>'ALL_EXECUTIONS');
  end if;
  --
  EXECUTE IMMEDIATE 'alter session set tracefile_identifier=''' || l_sid || '''';
  dbms_output.put_line('EIND-tracefile-identifier');
  */
--
-- if i dont manage to set the trace, i will allow the login anyway
--
exception
  when others 
  then null;
end;
/
--enable de logon-trigger
alter trigger UNILAB_TRACE_ALL_LOGINS enable;

/*
CREATE OR REPLACE TRIGGER sys.session_trace_on
— to be created by sys user
AFTER LOGON ON database
DECLARE
v_machinename VARCHAR2(64);
v_ora_username VARCHAR2(30) DEFAULT NULL;
v_os_username VARCHAR2(30);
v_sid NUMBER;
v_serial NUMBER;
v_program VARCHAR2(48);
v_numuser NUMBER;
CURSOR c1 IS
SELECT sid, serial#, osuser, machine, program
FROM v$session
WHERE sid = userenv('sid')
and username = 'SCOTT';
BEGIN
OPEN c1;
FETCH c1 INTO v_sid, v_serial, v_os_username, v_machinename, v_program;
IF c1%FOUND 
THEN
  — DBMS_SESSION.set_sql_trace (TRUE);
  v_machinename := replace(replace(v_machinename, '\', '_'), '/', '_');
  v_os_username := replace(replace(v_os_username, '\', '_'), '/', '_');
  EXECUTE IMMEDIATE 'alter session set tracefile_identifier=''' || trim(v_os_username) || '''';
  EXECUTE IMMEDIATE 'alter session set events ''10046 trace name context forever, level 12''';
END IF;
CLOSE c1;
END;
/
*/




/*
SET SERVEROUTPUT ON
declare
  l_program  varchar2(200);
  l_machine  varchar2(200);
  l_terminal varchar2(200);
  l_stmnt    varchar2(2000);
begin
  --alleen voor normale USER + DB-JOBS:
  select replace(replace(replace(replace(program,' ','_'),'.','_'),'(',''),')','')  program
  ,      machine
  ,      terminal
  into   l_program
  ,      l_machine
  ,      l_terminal
  from   v$session
  where  sid = sys_context('USERENV','SID')
  and    type = 'USER'
  ;
  --  
  if l_program like 'ORACLE%EXE%(J%' 
  then
    l_stmnt := 'alter session set tracefile_identifier = '||l_terminal||'_'||l_program||'_'||USER;
	dbms_output.put_line('stmnt '||l_stmnt);
    execute immediate l_stmnt;
    dbms_monitor.SESSION_TRACE_ENABLE(waits=>TRUE,binds=>TRUE,plan_stat=>'ALL_EXECUTIONS');
  else
    l_stmnt := 'alter session set tracefile_identifier = '||l_program||'_'||USER;
	dbms_output.put_line('stmnt: '||l_stmnt);
    execute immediate l_stmnt;
    dbms_monitor.SESSION_TRACE_ENABLE(waits=>TRUE,binds=>TRUE,plan_stat=>'ALL_EXECUTIONS');
  end if;
  --
  -- if i dont manage to set the trace, i'll allow the login anyway
  --
exception
  when others then null;
end;
/

*/

select sid, serial#, CLIENT_IDENTIFIER, Paddr, sql_trace, sql_trace_waits, sql_trace_binds, SQL_TRACE_PLAN_STATS 
from v$session 
where username='PSC';


SELECT ADDR, tracefile 
from v$process 
where tracefile is not null
;

SELECT S.USERNAME, S.SID, S.SERIAL#, S.PADDR, P.tracefile 
from v$session  s
,    v$process  p
where  s.Paddr = p.addr
and    s.username = 'PSC'
--and   tracefile is not null
;



--Het weer UITZETTEN VAN DE SESSION-TRACE !!
--enable de logon-trigger
alter trigger UNILAB_TRACE_ALL_LOGINS disable;
--VOOR SESSIES DIE EEN CONTINUE-CONNECTIE HEBBEN (JOBS/USERS)
begin
  for i in ( select sid, serial#
             from v$session
             where username = USER
             ) loop
         dbms_monitor.SESSION_TRACE_DISABLE(i.sid, i.serial#);
  end loop;
end;
/


--EINDE SCRIPT




--cxapp.stopalldbjobs
set serveroutput on
--
declare
l_result number;
begin
 l_result := UNAPIEV.StopAllMgrs;
 dbms_output.put_line('result: '||l_result);
end;
/


--cxapp.startalldbjobs 
set serveroutput on
--
declare
l_result number;
begin
 l_result := UNAPIEV.StartAllMgrs;
 dbms_output.put_line('result: '||l_result);
end;
/

prompt einde script







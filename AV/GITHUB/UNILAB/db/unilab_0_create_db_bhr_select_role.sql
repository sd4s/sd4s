--Create a DB-SELECT-role

CREATE ROLE UNILAB_BHR_SELECT ;

--UITDELEN VAN SPECIFIEKE GRANTS OP TABELLEN...
begin
FOR x IN (SELECT * FROM all_tables where owner='UNILAB' )
LOOP   
  EXECUTE IMMEDIATE 'GRANT SELECT ON ' || x.table_name || ' TO UNILAB_BHR_SELECT'; 
END LOOP;  
end;
/

/*
--or
declare
cursor c1 is select table_name from user_tables;
cmd varchar2(200);
begin
for c in c1 loop
cmd := 'GRANT SELECT ON '||c.table_name|| <<TO YOURUSERNAME>>;
execute immediate cmd;
end loop;
end;
*/

GRANT  UNILAB_BHR_SELECT to PSC;
GRANT SELECT ANY DICTIONARY TO PSC;

GRANT  UNILAB_BHR_SELECT to IBO;
GRANT SELECT ANY DICTIONARY TO IBO;


prompt
prompt einde script
prompt




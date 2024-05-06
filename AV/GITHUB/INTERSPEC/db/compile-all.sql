--SCRIPT DRAAIEN ALS SYSTEM (OF ALS GERELATEERDE SCHEMA-OWNER)
DECLARE
asschemaname  varchar2(100) := 'INTERSPC';
BEGIN
  DBMS_UTILITY.compile_schema (asschemaname, FALSE);    
END;
/


--exec DBMS_UTILITY.compile_schema (schema=>'INTERSPC', compile_all=>TRUE);    



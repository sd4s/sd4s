--------------------------------------------------------
--  File created - dinsdag-oktober-27-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Function CHR_TO_NUM
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UNILAB"."CHR_TO_NUM" (p_value in varchar2) 
return float deterministic is
begin
    return to_number(replace(p_value, '.', ','), '999999999D9999999');
exception
  when others
  then
    return null; 
end;

/

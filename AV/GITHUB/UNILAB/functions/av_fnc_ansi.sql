--------------------------------------------------------
--  File created - dinsdag-oktober-27-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Function ANSI
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UNILAB"."ANSI" (a_text IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   -- This function escapes quotation marks in a text.
   -- It was implemented because a series of quotation marks throws off
   -- UNAPIGEN.TildeSubstitution and causes it to fail substituting.
   RETURN REPLACE (a_text, '''', '''''');
END ANSI;

/

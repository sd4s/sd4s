--------------------------------------------------------
--  File created - dinsdag-oktober-27-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure CLEARUTERROR
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UNILAB"."CLEARUTERROR" IS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := 'ClearUterror';

BEGIN
    /*
    DELETE
      FROM uterror
     WHERE error_msg LIKE 'Warning#%';
    
    DELETE
      FROM uterror
     WHERE api_name = 'UnExecDml1';
    */
    
    DELETE FROM atinfo WHERE logdate < ADD_MONTHS(SYSDATE, -3);
     
    COMMIT;
    
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;

END ClearUterror;

/

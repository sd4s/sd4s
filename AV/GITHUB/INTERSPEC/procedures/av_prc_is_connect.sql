--------------------------------------------------------
--  File created - Monday-October-26-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure IS_CONNECT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "INTERSPC"."IS_CONNECT" IS
      lnRetVal            iapiType.ErrorNum_Type;
   BEGIN
      lnRetVal := aapiSpectrac.SetApplic('INTERFACE');
      --Initialize Interspec session
      lnRetVal := iapiGeneral.SetConnection(asUserId => USER, asModuleName => 'INTERFACE');
   COMMIT; 
END;
 

/

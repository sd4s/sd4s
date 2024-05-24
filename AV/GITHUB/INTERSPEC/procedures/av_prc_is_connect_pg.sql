--------------------------------------------------------
--  File created - Monday-October-26-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure IS_CONNECT_PG
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "INTERSPC"."IS_CONNECT_PG" IS
      lnRetVal            iapiType.ErrorNum_Type;
   BEGIN
      lnRetVal := aapiSpectrac.SetApplic('PG_INTERFACE');
      -- dbms_output.put_line('Setapplic: '|| lnRetval || '  ' ||  iapiGeneral.GetLastErrorText);
      --Initialize Interspec session
      lnRetVal := iapiGeneral.SetConnection(asUserId => 'TJR', asModuleName => 'PG_INTERFACE');
      -- dbms_output.put_line('SetConnection: '|| lnRetval || '  ' ||  iapiGeneral.GetLastErrorText);   COMMIT; 
END;

/

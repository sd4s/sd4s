CREATE OR REPLACE PROCEDURE SP_DEL_SPEC_ACCESS IS
















 BEGIN
    DELETE SPEC_ACCESS WHERE USER_ID = USER;
    EXCEPTION
      WHEN OTHERS THEN
                 RAISE_APPLICATION_ERROR(-20001,SQLERRM);
 END SP_DEL_SPEC_ACCESS;
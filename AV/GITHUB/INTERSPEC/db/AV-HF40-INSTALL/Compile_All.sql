---------------------------------------------------------------------------
-- $Workfile: Compile_All.sql $
--     Type:  Tools
----------------------------------------------------------------------------
--   $Author: Be324309 $
--            Siemens A&D AS MES
-- $Revision: 2 $
--  $Modtime: 19/07/06 16:08 $
--  $Modtime2: 04/01/2010 13:18 $
--   Project: speCX development
----------------------------------------------------------------------------
--  Abstract: 
----------------------------------------------------------------------------

--AP00925576 Start 2011.08.09

--orig Start
--DECLARE
--   lnRetVal                      iapiType.ErrorNum_Type;
--BEGIN
--   AP00925576
--   EXECUTE IMMEDIATE ('ALTER PACKAGE iapiDatabase COMPILE PACKAGE');
--   
--   lnRetVal := iapiDatabase.CompileInvalidAll;   
--END;
--/
--orig End


DECLARE
    --asschemaname      iapiType.databaseschemaname_type;
    asschemaname      SYS.dba_users.username%TYPE;
BEGIN

    BEGIN
        SELECT owner
            INTO asschemaname
        FROM dba_objects
        WHERE object_name = 'IAPIDATABASE'
            AND object_type = 'PACKAGE';
            
        DBMS_UTILITY.compile_schema (asschemaname, FALSE);    
    EXCEPTION        
        WHEN OTHERS
        THEN
            --iapiConstantDbError.DBERR_SCHEMANAMENOTFOUND
            DBMS_OUTPUT.PUT_LINE('Problem has occurred: ' || 'Schemaname not found.');
    END;    
   
EXCEPTION
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('Exception has occurred: ' || SQLERRM);   
END;
/

--AP00925576 End 2011.08.09
create or replace PACKAGE BODY          APAO_BLOB AS
--------------------------------------------------------------------------------
--  PROJECT : Vredestein Enschede
-------------------------------------------------------------------------------
--  PACKAGE : APAO_BLOB
-- ABSTRACT :
--   WRITER : Rody Sparenberg
--     DATE : 02/04/2009
--   TARGET : Oracle 10.2.0 / Interspec 6.1 sp1
--  VERSION : av2.0
--------------------------------------------------------------------------------
--  REMARKS :
--------------------------------------------------------------------------------
--  CHANGES :
--
--  When      | Who       | What
--============|===========|=====================================================
-- 07/05/2009 | RS        | Created
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
ics_package_name                 CONSTANT VARCHAR2(20) := 'APAO_BLOB';
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- functions- and/or procedures-declarations
--------------------------------------------------------------------------------
FUNCTION WRITEBLOB(avs_ID            VARCHAR2)
RETURN VARCHAR2 IS

   l_description  VARCHAR2(2000);
   l_blob         BLOB;
BEGIN

   BEGIN
      --------------------------------------------------------------------------------
      -- Get LOB locator
      --------------------------------------------------------------------------------
      SELECT a.DESKTOP_OBJECT, 'D:\\Images\\bo_temp\\' || b.FILE_NAME
        INTO l_blob, l_description
        FROM ITOIRAW a, ITOID b
       WHERE a.object_id = b.object_id
         AND a.object_id = avs_ID
         AND a.REVISION = b.REVISION
         AND a.owner = b.owner
         AND b.status = 2; -- only current objects 
            
      --dbms_java.grant_permission(USER, 'SYS:java.io.FilePermission','D:\Images\bo_temp\1.bmp', 'write');
      --COMMIT;
      
      AOPA_BLOB.WRITEBLOB ( l_blob, l_description );
      
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE;
   END;

   RETURN l_description;
   
EXCEPTION
  WHEN OTHERS THEN
    RETURN SQLERRM;
    
END WRITEBLOB;

END APAO_BLOB; 
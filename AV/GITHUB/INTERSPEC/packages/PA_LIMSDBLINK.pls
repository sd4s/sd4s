create or replace PACKAGE
----------------------------------------------------------------------------
-- $Revision: 1 $
--  $Modtime: 23/04/10 16:06 $
----------------------------------------------------------------------------
 PA_LIMSDBLink IS

   FUNCTION f_CreateDatabaseLink(
   a_link_name              IN     VARCHAR2,
   a_connection_string      IN     VARCHAR2,
   a_username               OUT    VARCHAR2,
   a_create_dblink_string   OUT    VARCHAR2
   )
   RETURN BOOLEAN;

END PA_LIMSDBLink;
 
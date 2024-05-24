create or replace PACKAGE        Cxapp
AS
-- Unilab 4.0 Package
-- $Revision: 2 $
-- $Date: 11/01/01 8:51a $
procedure startalldbjobs;
--
procedure stopalldbjobs;
--   
procedure restartalldbjobs;
--
function get_host_name  return varchar2;
--   
END Cxapp;
/
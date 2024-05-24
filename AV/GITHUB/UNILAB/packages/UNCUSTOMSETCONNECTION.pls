create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
uncustomsetconnection AS

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION SetCustomConnectionParameter
(a_CustomconnectionParameter         IN VARCHAR2)    /* VC2000_TYPE */
RETURN NUMBER;

END uncustomsetconnection;
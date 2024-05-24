create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapiev4 AS

--This cursor is used to determine on which worksheets
--the method events must be cascaded
--This cursor is public to make performance tuning possible in each project
--(a method sheet can be used in many worksheets in some projects)
--Note : reanalysis can be NULL when a method is deleted => NVL used
CURSOR l_wsme_cursor IS
   SELECT ws
   FROM utwsme
   WHERE sc = UNAPIEV.P_SC
     AND pg = UNAPIEV.P_PG
     AND pgnode = UNAPIEV.P_PGNODE
     AND pa = UNAPIEV.P_PA
     AND panode = UNAPIEV.P_PANODE
     AND me = UNAPIEV.P_ME
     AND menode = UNAPIEV.P_MENODE
     AND reanalysis = NVL(UNAPIEV.P_REANALYSIS, reanalysis);

FUNCTION GetVersion
RETURN VARCHAR2;

PROCEDURE HandleScPgEvents;

PROCEDURE HandleScPaEvents;

PROCEDURE HandleScMeEvents;


END unapiev4;
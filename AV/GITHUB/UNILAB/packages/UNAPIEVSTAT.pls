create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapievstat AS

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION CollectStat4LcTransitions /* READY */
RETURN NUMBER;

FUNCTION CollectStat4EvRuleExecution /* READY */
RETURN NUMBER;

FUNCTION ResetStat /* TO DO */
RETURN NUMBER;

FUNCTION ArchiveStat /* TO DO */
RETURN NUMBER;

END unapievstat;
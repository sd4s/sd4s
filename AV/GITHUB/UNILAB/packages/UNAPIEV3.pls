create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapiev3 AS

FUNCTION GetVersion
RETURN VARCHAR2;

PROCEDURE HandleObjectEvents;

PROCEDURE UpdateScAllDates
(a_update_start_date IN BOOLEAN,
 a_update_end_date IN BOOLEAN);

PROCEDURE UpdateRqAllDates
(a_update_start_date IN BOOLEAN,
 a_update_end_date IN BOOLEAN);

PROCEDURE UpdateScPgAllDates
(a_update_start_date IN BOOLEAN,
 a_update_end_date IN BOOLEAN);

PROCEDURE UpdateScPaAllDates
(a_update_start_date IN BOOLEAN,
 a_update_end_date IN BOOLEAN);

PROCEDURE UpdateWsAllDates
(a_update_start_date IN BOOLEAN,
 a_update_end_date IN BOOLEAN);

PROCEDURE UpdateSdAllDates
(a_update_start_date IN BOOLEAN,
 a_update_end_date IN BOOLEAN);

PROCEDURE CascadeOnSdLevel;

PROCEDURE HandleRqEvents;

PROCEDURE HandleScEvents;

PROCEDURE HandleScIcEvents;

PROCEDURE HandleScIiEvents;

PROCEDURE HandleRqIcEvents;

PROCEDURE HandleRqIiEvents;

PROCEDURE HandleSpecialEvents;

PROCEDURE HandleEqEvents;

PROCEDURE HandleWsEvents;

PROCEDURE HandleChEvents;

PROCEDURE HandleSdEvents;

PROCEDURE HandleSdIcEvents;

PROCEDURE HandleSdIiEvents;

PROCEDURE Check4HandleScMeCellOutput;

END unapiev3;
CREATE OR REPLACE PACKAGE UNILAB.APAO_OUTDOOR AS
--------------------------------------------------------------------------------
--  PROJECT : Vredestein Enschede
-------------------------------------------------------------------------------
--  PACKAGE : APAO_OUTDOOR
-- ABSTRACT :
--   WRITER : Rody Sparenberg
--     DATE : 13/02/2013
--   TARGET : Oracle 10.2.0 / Unilab 6.4
--  VERSION :
--------------------------------------------------------------------------------
--  REMARKS :
--------------------------------------------------------------------------------
--  CHANGES :
--
--  When      | Who       | What
--============|===========|=====================================================
-- 13/02/2013 | RS        | Created
-- 18/01/2019 | DH        | Add CreateSubSamples
-- 19/02/2020 | TW        | Add LogError
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
ics_package_name                 CONSTANT VARCHAR2(40) := 'APAO_OUTDOOR';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
FUNCTION CopySc(avs_sc_from       IN VARCHAR2,
                avs_st_to         IN VARCHAR2,
                avs_sc_to         IN OUT VARCHAR2,
                avs_modify_reason IN VARCHAR2)
RETURN INTEGER;

FUNCTION CreateWs4Rq(avs_rq            IN VARCHAR2,
                     avs_modify_reason IN VARCHAR2)
RETURN INTEGER;

FUNCTION CreateSubSamples(avs_ws            IN VARCHAR2,
                         avs_modify_reason IN VARCHAR2)
RETURN INTEGER;


FUNCTION NotifyRequester(avs_ws            IN VARCHAR2,
                         avs_modify_reason IN VARCHAR2)
RETURN INTEGER;

FUNCTION CreateWsPrepOutdoor(avs_ws            IN VARCHAR2,
                             avs_modify_reason IN VARCHAR2)
RETURN INTEGER;

FUNCTION CreateScTesting(avs_ws            IN VARCHAR2,
                         avs_modify_reason IN VARCHAR2)
RETURN INTEGER;

FUNCTION CopyWtAu2WsGk(avs_ws            IN VARCHAR2,
                       avs_modify_reason IN VARCHAR2)
RETURN INTEGER;

PROCEDURE OutdoorEventMgr;

FUNCTION InsertWorksheetEvent(avs_obj_id IN VARCHAR2, avs_modify_reason VARCHAR2)
RETURN NUMBER;

FUNCTION StartJob
(a_name             IN VARCHAR2,
 a_first_run        IN VARCHAR2,
 a_interval         IN VARCHAR2,
 a_prc_name         IN VARCHAR2)
RETURN NUMBER;

FUNCTION StopJob(a_prc_name IN VARCHAR2)
RETURN NUMBER;

FUNCTION HandleCreateSubSamples(avs_ws            IN VARCHAR2,
                                avs_modify_reason IN VARCHAR2)
RETURN INTEGER;


PROCEDURE StartOutdoorEventMgr;

PROCEDURE StopOutdoorEventMgr;

--LogError adds sequence numbers to logmessages and logmessages can be switched on and off via UTSYSTEM
PROCEDURE LogError(avs_func_name IN VARCHAR2,
                    avs_msg IN VARCHAR2,
                    avn_lvl IN INTEGER default 4); --0=no_logging, 1=error, 2=warning, 3=info, 4=debug

END APAO_OUTDOOR;
/

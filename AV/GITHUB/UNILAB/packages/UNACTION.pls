create or replace PACKAGE        UNACTION AS
--------------------------------------------------------------------------------
--  PROJECT : Vredestein Enschede
-------------------------------------------------------------------------------
--  PACKAGE : UNACTION
-- ABSTRACT :
--   WRITER : Rody Sparenberg
--     DATE : 14/02/2007
--   TARGET : Oracle 10.2.0
--  VERSION : av2.2.C01 en av2.2.C02
--------------------------------------------------------------------------------
--  REMARKS :
--------------------------------------------------------------------------------
--  CHANGES :
--
--  When      | Who       | What
--============|===========|=====================================================
-- 14/02/2007 | RS        | Created
-- 07/03/2007 | RS        | Added ME_A01
-- 07/03/2007 | RS        | Added PG_A02
-- 07/03/2007 | RS        | Added PG_A03
-- 10/04/2007 | RS        | Added ClearPaResultRenanal
-- 10/04/2007 | RS        | Added ME_A02
-- 29/05/2007 | RS        | Added ME_A03
-- 19/07/2007 | AF        | Added PG_A04
-- 21/11/2007 | RS        | Added SC_A02
-- 21/11/2007 | RS        | Added ME_A04
-- 18/12/2007 | RS        | Added ME_A05
-- 11/01/2008 | RS        | Added MTCELLLIST
-- 25/01/2008 | RS        | Added CreateMeCells (av1.2.C07)
-- 01/02/2008 | RS        | Added ME_A06 (av1.2.C09)
-- 06/02/2008 | RS        | Added RQ_A01 (av2.0.C05)
-- 14/02/2008 | RS        | Added ME_A07 (av1.2.C12)
-- 15/02/2008 | RS        | Added PA_A03 (av1.2.C04)
--                        | Added RQ_A02 (av2.0.C05)
-- 06/03/2008 | RS        | Added ME_A08 (av1.2.C09)
--                        | Added PA_A04
-- 02/04/2007 | RS        | Added ME_A09
-- 17/04/2008 | RS        | Added RQ_A03 (av2.0.C03)
--                        | Added ME_A10 (av2.0.C07)
-- 03/06/2008 | RS        | Renamed ClearPaResultReanal into ReanalysePa
--                        | Added PG_A05
--                        | Added ME_A11
-- 10/06/2008 | RS        | Added RQ_A04
--                        | Added RQ_A05
-- 06/08/2008 | RS        | Added SYS_A01
--                        | Added II_A01
-- 26/09/2008 | RS        | Added ST_A01
--                        | Added ST_A02
--                        | Added ST_A03
--                        | Added ST_A04
--                        | Added ST_A09
--                        | Added ST_A10
--                        | Added PP_A01
--                        | Added PP_A02
--                        | Added PP_A03
--                        | Added PP_A04
--                        | Added PP_A05
-- 01/10/2008 | RS        | Added PR_A01
--                        | Added PR_A02
-- 26/11/2008 | RS        | Added ST_A08
-- 21/01/2009 | RS        | Added ME_A13 (av2.2.C01)
--                        | Added DeleteMeCells
--                        | Added ME_A14 (av2.2.C02)
-- 11/02/2009 | RS        | Added ME_A15
-- 11/03/2009 | RS        | Removed ME_A14 (av2.2.C03)
--                        | Removed ME_A13
-- 25/03/2009 | RS        | Added RQ_A06
--                        | Added SC_A03
-- 17/03/2010 | RS        | Removed MTCELLLIST
-- 12/05/2011 | RS        | Added IC_A01
-- 13/02/2013 | RS        | Added RQ_A07
--                        | Added RQ_A08
--                        | Added WS_A01
--                        | Added WS_A02
--                        | Added WS_A03
--                        | Added WS_A04
--                        | Added WS_A05
--                        | Added RQ_A09
--                        | Removed PG_A03_2
--                        | Removed RR_TEST
-- 28/01/2016  | JR       | Changed LogTransition, and added ME_A16
-- 29/03/2016  | AF       | Added function PP_A10
-- 23/06/2016  | JR       | Added function SC_A04 and SC_A05 (ERULG101C)
-- 23/06/2016  | JP/JR    | Added function ME_A17 (ERULG001D)
-- 23/06/2016  | JP/JR    | Added functions CO_A01, CO_A02 (ERULG202)
-- 30/06/2016  | JR       | Added function RQ_A10 (ERULG013C)
-- 30/06/2016  | JR       | Added function SC_A06 (ERULG013C)
-- 09/02/2017  | JR       | Added function PG_A06 (I1612-371)
-- 20/07/2017  | JR       | Added function PA_A08, RQ_A11 (I1705-020 Extra request status)
--                        | Added function SC_A07, WS_A06 (I1705-020 Extra request status)
-- 18/01/2019  | DH       | Added function WS_A07 (create sub samples)
-- 12/02/2019  | DH       | Added function WS_A08 (send mail to requester)
-- 27/02/2020  | TW       | Added function WS_A09 (Change Preparation worksheet status)
-- 31/05/2021  | PS       | Added function SC_A08 (fill SC/II-PI-start-date tbv Indoor-testing KPI-tijden)
-- 05-07-2021  | PS       | Added function ME_A19 (find FEA-simulation-errors and mail to users) 
-- 13-11-2023  | PS       | Added function SC_A09 (send FEA-email after sample-ss=cm)
--
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- functions- and/or procedures-declarations
--------------------------------------------------------------------------------

FUNCTION GenerateNextCodemask (avs_code_mask IN  VARCHAR2)
RETURN VARCHAR2;

FUNCTION GetVersion 
RETURN VARCHAR2; 

--************************************************************

FUNCTION RQ_A01
RETURN APAOGEN.RETURN_TYPE;

FUNCTION RQ_A02
RETURN APAOGEN.RETURN_TYPE;

FUNCTION RQ_A03
RETURN APAOGEN.RETURN_TYPE;

FUNCTION RQ_A04
RETURN APAOGEN.RETURN_TYPE;

FUNCTION RQ_A05
RETURN APAOGEN.RETURN_TYPE;

FUNCTION RQ_A06
RETURN APAOGEN.RETURN_TYPE;

FUNCTION RQ_A07
RETURN APAOGEN.RETURN_TYPE;

FUNCTION RQ_A08
RETURN APAOGEN.RETURN_TYPE;

FUNCTION RQ_A09
RETURN APAOGEN.RETURN_TYPE;

FUNCTION RQ_A10
RETURN APAOGEN.RETURN_TYPE;

FUNCTION RQ_A11
RETURN APAOGEN.RETURN_TYPE;

--************************************************************

FUNCTION SC_A01
RETURN APAOGEN.RETURN_TYPE;

FUNCTION SC_A02
RETURN APAOGEN.RETURN_TYPE;

FUNCTION SC_A03
RETURN APAOGEN.RETURN_TYPE;

FUNCTION SC_A04
RETURN APAOGEN.RETURN_TYPE;

FUNCTION SC_A05
RETURN APAOGEN.RETURN_TYPE;

FUNCTION SC_A06
RETURN APAOGEN.RETURN_TYPE;

FUNCTION SC_A07
RETURN APAOGEN.RETURN_TYPE;

--fill SC/II-PI-start-date na wijziging SS=ORDERED
FUNCTION SC_A08
RETURN APAOGEN.RETURN_TYPE;

--Send FEA-email na wijziging sample.SS = CM
FUNCTION SC_A09
RETURN APAOGEN.RETURN_TYPE;

--************************************************************

FUNCTION PG_A01
RETURN APAOGEN.RETURN_TYPE;

FUNCTION PG_A02
RETURN APAOGEN.RETURN_TYPE;

FUNCTION PG_A03
RETURN APAOGEN.RETURN_TYPE;

FUNCTION PG_A04
RETURN APAOGEN.RETURN_TYPE;

FUNCTION PG_A05
RETURN APAOGEN.RETURN_TYPE;

FUNCTION PG_A06
RETURN APAOGEN.RETURN_TYPE;

--************************************************************

FUNCTION PA_A01
RETURN APAOGEN.RETURN_TYPE;

FUNCTION PA_A02
RETURN APAOGEN.RETURN_TYPE;

FUNCTION PA_A03
RETURN APAOGEN.RETURN_TYPE;

FUNCTION PA_A04
RETURN APAOGEN.RETURN_TYPE;

FUNCTION PA_A05
RETURN APAOGEN.RETURN_TYPE;

FUNCTION PA_A08
RETURN APAOGEN.RETURN_TYPE;

--************************************************************

FUNCTION ME_A01
RETURN APAOGEN.RETURN_TYPE;

FUNCTION ME_A02
RETURN APAOGEN.RETURN_TYPE;

FUNCTION ME_A03
RETURN APAOGEN.RETURN_TYPE;

FUNCTION ME_A04
RETURN APAOGEN.RETURN_TYPE;

FUNCTION ME_A05
RETURN APAOGEN.RETURN_TYPE;

FUNCTION ME_A06
RETURN APAOGEN.RETURN_TYPE;

FUNCTION ME_A07
RETURN APAOGEN.RETURN_TYPE;

FUNCTION ME_A08
RETURN APAOGEN.RETURN_TYPE;

FUNCTION ME_A09
RETURN APAOGEN.RETURN_TYPE;

FUNCTION ME_A10
RETURN APAOGEN.RETURN_TYPE;

FUNCTION ME_A11
RETURN APAOGEN.RETURN_TYPE;

FUNCTION ME_A15
RETURN APAOGEN.RETURN_TYPE;

FUNCTION ME_A16
RETURN APAOGEN.RETURN_TYPE;

FUNCTION ME_A17
RETURN APAOGEN.RETURN_TYPE;

FUNCTION ME_A18
RETURN APAOGEN.RETURN_TYPE;

---- 05-07-2021  find FEA-simulation-errors and mail to users
FUNCTION ME_A19
RETURN APAOGEN.RETURN_TYPE;

--************************************************************
FUNCTION ReanalysePa
RETURN APAOGEN.RETURN_TYPE;

FUNCTION CreateMeCells
RETURN APAOGEN.RETURN_TYPE;

FUNCTION DeleteMeCells
RETURN APAOGEN.RETURN_TYPE;

--************************************************************

FUNCTION SYS_A01
RETURN APAOGEN.RETURN_TYPE;

--************************************************************

FUNCTION II_A01
RETURN APAOGEN.RETURN_TYPE;

--************************************************************

FUNCTION ST_A01
RETURN APAOGEN.RETURN_TYPE;

FUNCTION ST_A02
RETURN APAOGEN.RETURN_TYPE;

FUNCTION ST_A03
RETURN APAOGEN.RETURN_TYPE;

FUNCTION ST_A04
RETURN APAOGEN.RETURN_TYPE;

FUNCTION ST_A08
RETURN APAOGEN.RETURN_TYPE;

FUNCTION ST_A09
RETURN APAOGEN.RETURN_TYPE;

FUNCTION ST_A10
RETURN APAOGEN.RETURN_TYPE;

--************************************************************

FUNCTION PP_A01
RETURN APAOGEN.RETURN_TYPE;

FUNCTION PP_A02
RETURN APAOGEN.RETURN_TYPE;

FUNCTION PP_A03
RETURN APAOGEN.RETURN_TYPE;

FUNCTION PP_A04
RETURN APAOGEN.RETURN_TYPE;

FUNCTION PP_A05
RETURN APAOGEN.RETURN_TYPE;

FUNCTION PP_A10
RETURN APAOGEN.RETURN_TYPE;

--************************************************************

FUNCTION PR_A01
RETURN APAOGEN.RETURN_TYPE;

FUNCTION PR_A02
RETURN APAOGEN.RETURN_TYPE;

--************************************************************

FUNCTION IC_A01
RETURN APAOGEN.RETURN_TYPE;

--************************************************************

FUNCTION WS_A01
RETURN APAOGEN.RETURN_TYPE;

FUNCTION WS_A02
RETURN APAOGEN.RETURN_TYPE;

FUNCTION WS_A03
RETURN APAOGEN.RETURN_TYPE;

FUNCTION WS_A04
RETURN APAOGEN.RETURN_TYPE;

FUNCTION WS_A05
RETURN APAOGEN.RETURN_TYPE;

FUNCTION WS_A06
RETURN APAOGEN.RETURN_TYPE;

FUNCTION WS_A07
RETURN APAOGEN.RETURN_TYPE;

FUNCTION WS_A08
RETURN APAOGEN.RETURN_TYPE;

--FUNCTION WS_A09
--RETURN APAOGEN.RETURN_TYPE;


--------------------------------------------------------------------------------
-- END OF CUSTOMIZATION
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- SynchronizeAll
--------------------------------------------------------------------------------
FUNCTION SynchronizeAll
RETURN NUMBER;

----------------------------------------------------------------------------------------------
----                        Multiplant actions on configuration                           ----
----------------------------------------------------------------------------------------------
FUNCTION StGkPpKeysOnStPpAss
RETURN NUMBER;

--------------------------------------------------------------------------------
-- SendMail
--------------------------------------------------------------------------------
FUNCTION SendMail
(a_recipient        IN   VARCHAR2,                     /* VC40_TYPE */
 a_subject          IN   VARCHAR2,                     /* VC255_TYPE */
 a_text_tab         IN   UNAPIGEN.VC255_TABLE_TYPE,    /* VC255_TABLE_TYPE */
 a_nr_of_rows       IN   NUMBER)                       /* NUM_TYPE */
RETURN NUMBER;

----------------------------------------------------------------------------------------------
----                        ASSIGNMENT RULES FOR GROUPKEYS                                ----
----------------------------------------------------------------------------------------------
FUNCTION SaveObjectGroupKey
(a_gk_tp           IN     VARCHAR2,                  /* VC4_TYPE */
 a_gk              IN     VARCHAR2,                  /* VC20_TYPE */
 a_value           IN     VARCHAR2,                  /* VC40_TYPE */
 a_modify_flag     IN     NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION SaveObjectGroupKey
(a_gk_tp           IN     VARCHAR2,                  /* VC4_TYPE */
 a_gk              IN     VARCHAR2,                  /* VC20_TYPE */
 a_value_tab       IN     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TAB_TYPE */
 a_nr_of_rows      IN     NUMBER,                    /* NUM_TYPE */
 a_modify_flag     IN     NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION AssignGroupKey
(a_gk_tp           IN     VARCHAR2,                  /* VC4_TYPE */
 a_gk              IN     VARCHAR2,                  /* VC20_TYPE */
 a_value           IN     VARCHAR2)                  /* VC40_TYPE */
RETURN NUMBER;

FUNCTION AssignGroupKey
(a_gk_tp           IN     VARCHAR2,                  /* VC4_TYPE */
 a_gk              IN     VARCHAR2,                  /* VC20_TYPE */
 a_value           IN     VARCHAR2,                  /* VC40_TYPE */
 a_start_pos       IN     NUMBER,                    /* NUM_TYPE */
 a_length          IN     NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION DeAssignGroupKey
(a_gk_tp           IN     VARCHAR2,                  /* VC4_TYPE */
 a_gk              IN     VARCHAR2)                  /* VC20_TYPE */
RETURN NUMBER;

FUNCTION InitGroupKeyFromAttribute
(a_gk_tp           IN     VARCHAR2,                  /* VC4_TYPE */
 a_gk              IN     VARCHAR2,                  /* VC20_TYPE */
 a_object_tp       IN     VARCHAR2,                  /* VC4_TYPE */
 a_object_id       IN     VARCHAR2,                  /* VC20_TYPE */
 a_object_version  IN     VARCHAR2,                  /* VC20_TYPE */
 a_au              IN     VARCHAR2)                  /* VC20_TYPE */
RETURN NUMBER;

FUNCTION LogTransition
RETURN NUMBER;

FUNCTION SetExecEndDate
(a_value           IN     TIMESTAMP DEFAULT SYSTIMESTAMP)
RETURN NUMBER;

FUNCTION CO_A01
RETURN APAOGEN.RETURN_TYPE;

FUNCTION CO_A02
RETURN APAOGEN.RETURN_TYPE;

END UNACTION;
/

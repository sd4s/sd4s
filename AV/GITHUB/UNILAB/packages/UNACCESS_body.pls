create or replace PACKAGE BODY        UNACCESS AS
--------------------------------------------------------------------------------
--  PROJECT : Vredestein Enschede
-------------------------------------------------------------------------------
--  PACKAGE : UNACCESS
-- ABSTRACT :
--------------------------------------------------------------------------------
--   WRITER : Rody Sparenberg
--     DATE : 01/02/2007
--   TARGET : Oracle 10.2.0
--  VERSION : 6.1.1 $Revision: 1 $
--------------------------------------------------------------------------------
--  REMARKS : Requires table ATAODD
--------------------------------------------------------------------------------
--  CHANGES :
--
--  When      | Who       | What
--============|===========|=====================================================
-- 01/02/2007 | RS        | Created
-- 01/02/2007 | RS        | Changed OldInitObjectAccessRights : default = N
-- 01/02/2007 | RS        | Changed InitObjectAccessRights    : default = N
-- 14/02/2007 | RS        | Changed InitObjectAccessRights    : use ATAODD
-- 14/02/2007 | RS        | Changed OldInitObjectAccessRights : use ATAODD
-- 10/06/2008 | RS        | Changed TransitionAuthorised : MtGroupOnly
-- 06/08/2008 | RS        | Changed MtGroupOnly into AllowDuplo
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
ics_package_name CONSTANT VARCHAR2(20) := 'UNACCESS';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------
CURSOR lvq_dd IS
	SELECT dd,ar
	  FROM ataodd
	 ORDER BY dd;

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
l_sql_string       VARCHAR2(2000);
l_result           NUMBER;
P_TrueFalseToggle  BOOLEAN;
P_LAST_PA_CANCELED VARCHAR2(255);

--------------------------------------------------------------------------------
-- functions and/or procedures
--------------------------------------------------------------------------------

/* Old InitObjectAccessRights  */
/* Why old ? - All our users are instinctively assuming that the configuration access rights   */
/*             are systematically inherited from the corresponding configutaion objects        */
/*             This is completely wrong but since it is what they want, the original           */
/*             function (now called OldInitObjectAccessRights) has been replaced by a function */
/*             perfroming the inheritance. The old function is left to show to developers that */
/*             there are altrenatives to that inheritance when necessary                       */
FUNCTION OldInitObjectAccessRights               /* INTERNAL */
(a_object_tp     IN   VARCHAR2,                  /* VC4_TYPE */
 a_object_id     IN   VARCHAR2,                  /* VC20_TYPE */
 a_ar            OUT  UNAPIGEN.CHAR1_TABLE_TYPE) /* CHAR1_TABLE_TYPE */
RETURN NUMBER IS

l_ar             CHAR(1);
l_default_ar     CHAR(1);

BEGIN

   -- This is the default access right for non-used user profiles
   l_default_ar := 'N';

   a_ar(1)    := l_default_ar;          a_ar(2)    := l_default_ar;          a_ar(3)    := l_default_ar;          a_ar(4)    := l_default_ar;
   a_ar(5)    := l_default_ar;          a_ar(6)    := l_default_ar;          a_ar(7)    := l_default_ar;          a_ar(8)    := l_default_ar;
   a_ar(9)    := l_default_ar;          a_ar(10)   := l_default_ar;          a_ar(11)   := l_default_ar;          a_ar(12)   := l_default_ar;
   a_ar(13)   := l_default_ar;          a_ar(14)   := l_default_ar;          a_ar(15)   := l_default_ar;          a_ar(16)   := l_default_ar;
   a_ar(17)   := l_default_ar;          a_ar(18)   := l_default_ar;          a_ar(19)   := l_default_ar;          a_ar(20)   := l_default_ar;
   a_ar(21)   := l_default_ar;          a_ar(22)   := l_default_ar;          a_ar(23)   := l_default_ar;          a_ar(24)   := l_default_ar;
   a_ar(25)   := l_default_ar;          a_ar(26)   := l_default_ar;          a_ar(27)   := l_default_ar;          a_ar(28)   := l_default_ar;
   a_ar(29)   := l_default_ar;          a_ar(30)   := l_default_ar;          a_ar(31)   := l_default_ar;          a_ar(32)   := l_default_ar;
   a_ar(33)   := l_default_ar;          a_ar(34)   := l_default_ar;          a_ar(35)   := l_default_ar;          a_ar(36)   := l_default_ar;
   a_ar(37)   := l_default_ar;          a_ar(38)   := l_default_ar;          a_ar(39)   := l_default_ar;          a_ar(40)   := l_default_ar;
   a_ar(41)   := l_default_ar;          a_ar(42)   := l_default_ar;          a_ar(43)   := l_default_ar;          a_ar(44)   := l_default_ar;
   a_ar(45)   := l_default_ar;          a_ar(46)   := l_default_ar;          a_ar(47)   := l_default_ar;          a_ar(48)   := l_default_ar;
   a_ar(49)   := l_default_ar;          a_ar(50)   := l_default_ar;          a_ar(51)   := l_default_ar;          a_ar(52)   := l_default_ar;
   a_ar(53)   := l_default_ar;          a_ar(54)   := l_default_ar;          a_ar(55)   := l_default_ar;          a_ar(56)   := l_default_ar;
   a_ar(57)   := l_default_ar;          a_ar(58)   := l_default_ar;          a_ar(59)   := l_default_ar;          a_ar(60)   := l_default_ar;
   a_ar(61)   := l_default_ar;          a_ar(62)   := l_default_ar;          a_ar(63)   := l_default_ar;          a_ar(64)   := l_default_ar;
   a_ar(65)   := l_default_ar;          a_ar(66)   := l_default_ar;          a_ar(67)   := l_default_ar;          a_ar(68)   := l_default_ar;
   a_ar(69)   := l_default_ar;          a_ar(70)   := l_default_ar;          a_ar(71)   := l_default_ar;          a_ar(72)   := l_default_ar;
   a_ar(73)   := l_default_ar;          a_ar(74)   := l_default_ar;          a_ar(75)   := l_default_ar;          a_ar(76)   := l_default_ar;
   a_ar(77)   := l_default_ar;          a_ar(78)   := l_default_ar;          a_ar(79)   := l_default_ar;          a_ar(80)   := l_default_ar;
   a_ar(81)   := l_default_ar;          a_ar(82)   := l_default_ar;          a_ar(83)   := l_default_ar;          a_ar(84)   := l_default_ar;
   a_ar(85)   := l_default_ar;          a_ar(86)   := l_default_ar;          a_ar(87)   := l_default_ar;          a_ar(88)   := l_default_ar;
   a_ar(89)   := l_default_ar;          a_ar(90)   := l_default_ar;          a_ar(91)   := l_default_ar;          a_ar(92)   := l_default_ar;
   a_ar(93)   := l_default_ar;          a_ar(94)   := l_default_ar;          a_ar(95)   := l_default_ar;          a_ar(96)   := l_default_ar;
   a_ar(97)   := l_default_ar;          a_ar(98)   := l_default_ar;          a_ar(99)   := l_default_ar;          a_ar(100)  := l_default_ar;
   a_ar(101)  := l_default_ar;          a_ar(102)  := l_default_ar;          a_ar(103)  := l_default_ar;          a_ar(104)  := l_default_ar;
   a_ar(105)  := l_default_ar;          a_ar(106)  := l_default_ar;          a_ar(107)  := l_default_ar;          a_ar(108)  := l_default_ar;
   a_ar(109)  := l_default_ar;          a_ar(110)  := l_default_ar;          a_ar(111)  := l_default_ar;          a_ar(112)  := l_default_ar;
   a_ar(113)  := l_default_ar;          a_ar(114)  := l_default_ar;          a_ar(115)  := l_default_ar;          a_ar(116)  := l_default_ar;
   a_ar(117)  := l_default_ar;          a_ar(118)  := l_default_ar;          a_ar(119)  := l_default_ar;          a_ar(120)  := l_default_ar;
   a_ar(121)  := l_default_ar;          a_ar(122)  := l_default_ar;          a_ar(123)  := l_default_ar;          a_ar(124)  := l_default_ar;
   a_ar(125)  := l_default_ar;          a_ar(126)  := l_default_ar;          a_ar(127)  := l_default_ar;          a_ar(128)  := l_default_ar;

	FOR lvr_dd IN lvq_dd LOOP
		a_ar(lvr_dd.dd) := lvr_dd.ar;
	END LOOP;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

END OldInitObjectAccessRights;

FUNCTION UpdateAccessRights                           /* INTERNAL */
RETURN NUMBER IS

BEGIN
   -- This function allows you to dynamically update the access rights
   -- columns in function of the life cycle, status and object type
   -- The event record is at your disposal.
   -- UNAPIEV.P_EV_REC contains the new lc and/or status given
   -- to that object
   RETURN(UNAPIGEN.DBERR_SUCCESS);

   --ex : When a sc is in approved status, access rights
   --     have to be set to read-only for user profile 2 .
   -- IF UNAPIEV.P_EV_REC.object_tp = 'sc' AND
   --    UNAPIEV.P_EV_REC.object_ss = '@A' THEN
   --    UPDATE utsc SET ar2 = 'R'
   --    WHERE sc = UNAPIEV.P_EV_REC.object_id;
   -- END IF;

END UpdateAccessRights;

FUNCTION InitObjectAccessRights                  /* INTERNAL */
(a_object_tp     IN   VARCHAR2,                  /* VC4_TYPE */
 a_object_id     IN   VARCHAR2,                  /* VC20_TYPE */
 a_ar            OUT  UNAPIGEN.CHAR1_TABLE_TYPE) /* CHAR1_TABLE_TYPE */
RETURN NUMBER IS

l_ar                     CHAR(1);
l_default_ar             CHAR(1);
l_found                  BOOLEAN;
l_ar_event_found         BOOLEAN;

l_st_rec                 udst%ROWTYPE;
l_ip_rec                 udip%ROWTYPE;
l_ie_rec                 udie%ROWTYPE;
l_pp_rec                 udpp%ROWTYPE;
l_pr_rec                 udpr%ROWTYPE;
l_mt_rec                 udmt%ROWTYPE;
l_rt_rec                 udrt%ROWTYPE;
l_pt_rec                 udpt%ROWTYPE;
l_wt_rec                 udwt%ROWTYPE;
l_cy_rec                 udcy%ROWTYPE;

CURSOR l_inherit_star (a_sc IN VARCHAR2) IS
   SELECT *
   FROM udst
   WHERE (st, version) = (SELECT b.st, b.st_version FROM utsc b WHERE b.sc=a_sc);

CURSOR l_inherit_ipar (a_ic IN VARCHAR2, a_ip_version IN VARCHAR2) IS
   SELECT *
   FROM udip
   WHERE ip = a_ic
   AND version = a_ip_version;

CURSOR l_inherit_iear (a_ii IN VARCHAR2, a_ie_version IN VARCHAR2) IS
   SELECT *
   FROM udie
   WHERE ie = a_ii
   AND version = a_ie_version;

CURSOR l_inherit_ppar (a_sc IN VARCHAR2,
                       a_pg IN VARCHAR2,
                       a_pgnode IN NUMBER,
                       a_pp_version IN VARCHAR2) IS
   SELECT *
   FROM udpp
   WHERE pp = a_pg
   AND version = a_pp_version
   AND (pp_key1, pp_key2, pp_key3, pp_key4, pp_key5) =
          (SELECT pp_key1, pp_key2, pp_key3, pp_key4, pp_key5
           FROM utscpg
           WHERE sc     = a_sc
             AND pg     = a_pg
             AND pgnode = a_pgnode);

CURSOR l_inherit_prar (a_pa IN VARCHAR2, a_pr_version IN VARCHAR2) IS
   SELECT *
   FROM udpr
   WHERE pr = a_pa
   AND version = a_pr_version;

CURSOR l_inherit_mtar (a_mt IN VARCHAR2, a_mt_version IN VARCHAR2) IS
   SELECT *
   FROM udmt
   WHERE mt = a_mt
   AND version = a_mt_version;

CURSOR l_inherit_rtar (a_rq IN VARCHAR2) IS
   SELECT *
   FROM udrt
   WHERE (rt, version) = (SELECT b.rt, b.rt_version FROM utrq b WHERE b.rq=a_rq);

CURSOR l_inherit_ptar (a_sd IN VARCHAR2) IS
   SELECT *
   FROM udpt
   WHERE (pt, version) = (SELECT b.pt, b.pt_version FROM utsd b WHERE b.sd=a_sd);

CURSOR l_inherit_wtar (a_ws IN VARCHAR2) IS
   SELECT *
   FROM udwt
   WHERE (wt, version) = (SELECT b.wt, b.wt_version FROM utws b WHERE b.ws=a_ws);

CURSOR l_inherit_cyar (a_ch IN VARCHAR2) IS
   SELECT *
   FROM udcy
   WHERE (cy, version) = (SELECT b.cy, b.cy_version FROM utch b WHERE b.ch=a_ch);

CURSOR c_utobjects(a_object_tp VARCHAR2) IS
   SELECT ar
   FROM utobjects
   WHERE object = a_object_tp;
l_utobjects_rec   c_utobjects%ROWTYPE;

CURSOR l_ar_event_cursor IS
   SELECT *
   FROM utev
   WHERE tr_seq = UNAPIEV.P_EV_REC.tr_seq
   AND object_tp = UNAPIEV.P_EV_REC.object_tp
   AND object_id = UNAPIEV.P_EV_REC.object_id
   AND INSTR(ev_details, 'version='||UNAPIEV.P_VERSION) <> 0
   AND ev_tp = 'AccessRightsUpdated';

CURSOR l_pp_ar_event_cursor IS
   SELECT *
   FROM utev
   WHERE tr_seq = UNAPIEV.P_EV_REC.tr_seq
   AND object_tp = UNAPIEV.P_EV_REC.object_tp
   AND object_id = UNAPIEV.P_EV_REC.object_id
   AND INSTR(ev_details, 'version='||UNAPIEV.P_VERSION) <> 0
   AND INSTR(ev_details, 'pp_key1='||UNAPIEV.P_PP_KEY1) <> 0
   AND INSTR(ev_details, 'pp_key2='||UNAPIEV.P_PP_KEY2) <> 0
   AND INSTR(ev_details, 'pp_key3='||UNAPIEV.P_PP_KEY3) <> 0
   AND INSTR(ev_details, 'pp_key4='||UNAPIEV.P_PP_KEY4) <> 0
   AND INSTR(ev_details, 'pp_key5='||UNAPIEV.P_PP_KEY5) <> 0
   AND ev_tp = 'AccessRightsUpdated';

CURSOR l_eq_ar_event_cursor IS
   SELECT *
   FROM utev
   WHERE tr_seq = UNAPIEV.P_EV_REC.tr_seq
   AND object_tp = UNAPIEV.P_EV_REC.object_tp
   AND object_id = UNAPIEV.P_EV_REC.object_id
   AND INSTR(ev_details, 'version='||UNAPIEV.P_VERSION) <> 0
   AND INSTR(ev_details, 'lab='||UNAPIEV.P_LAB) <> 0
   AND ev_tp = 'AccessRightsUpdated';
BEGIN

   --Dynamic SQL hqs not been used for performance reason
   --avoiding too much parses.

   --This function is an alternative for InitObjectAccessRights.
   --It inherits access rights from configuration.
   --Just change the name of this function to
   --InitObjectAccessRights to set it in function
   --and comment out the original one.

   -- This is the default access right for non-used user profiles
   l_default_ar := 'N';
   l_found := FALSE;

   IF (a_object_tp = 'sc') THEN
      OPEN l_inherit_star (a_object_id);
      FETCH l_inherit_star
      INTO l_st_rec;
      l_found := l_inherit_star%FOUND;
      CLOSE l_inherit_star;

      IF l_found THEN
         a_ar(1)   := NVL(l_st_rec.ar1,   l_default_ar);          a_ar(2)   := NVL(l_st_rec.ar2,   l_default_ar);          a_ar(3)   := NVL(l_st_rec.ar3,   l_default_ar);          a_ar(4)   := NVL(l_st_rec.ar4,   l_default_ar);
         a_ar(5)   := NVL(l_st_rec.ar5,   l_default_ar);          a_ar(6)   := NVL(l_st_rec.ar6,   l_default_ar);          a_ar(7)   := NVL(l_st_rec.ar7,   l_default_ar);          a_ar(8)   := NVL(l_st_rec.ar8,   l_default_ar);
         a_ar(9)   := NVL(l_st_rec.ar9,   l_default_ar);          a_ar(10)  := NVL(l_st_rec.ar10,  l_default_ar);          a_ar(11)  := NVL(l_st_rec.ar11,  l_default_ar);          a_ar(12)  := NVL(l_st_rec.ar12,  l_default_ar);
         a_ar(13)  := NVL(l_st_rec.ar13,  l_default_ar);          a_ar(14)  := NVL(l_st_rec.ar14,  l_default_ar);          a_ar(15)  := NVL(l_st_rec.ar15,  l_default_ar);          a_ar(16)  := NVL(l_st_rec.ar16,  l_default_ar);
         a_ar(17)  := NVL(l_st_rec.ar17,  l_default_ar);          a_ar(18)  := NVL(l_st_rec.ar18,  l_default_ar);          a_ar(19)  := NVL(l_st_rec.ar19,  l_default_ar);          a_ar(20)  := NVL(l_st_rec.ar20,  l_default_ar);
         a_ar(21)  := NVL(l_st_rec.ar21,  l_default_ar);          a_ar(22)  := NVL(l_st_rec.ar22,  l_default_ar);          a_ar(23)  := NVL(l_st_rec.ar23,  l_default_ar);          a_ar(24)  := NVL(l_st_rec.ar24,  l_default_ar);
         a_ar(25)  := NVL(l_st_rec.ar25,  l_default_ar);          a_ar(26)  := NVL(l_st_rec.ar26,  l_default_ar);          a_ar(27)  := NVL(l_st_rec.ar27,  l_default_ar);          a_ar(28)  := NVL(l_st_rec.ar28,  l_default_ar);
         a_ar(29)  := NVL(l_st_rec.ar29,  l_default_ar);          a_ar(30)  := NVL(l_st_rec.ar30,  l_default_ar);          a_ar(31)  := NVL(l_st_rec.ar31,  l_default_ar);          a_ar(32)  := NVL(l_st_rec.ar32,  l_default_ar);
         a_ar(33)  := NVL(l_st_rec.ar33,  l_default_ar);          a_ar(34)  := NVL(l_st_rec.ar34,  l_default_ar);          a_ar(35)  := NVL(l_st_rec.ar35,  l_default_ar);          a_ar(36)  := NVL(l_st_rec.ar36,  l_default_ar);
         a_ar(37)  := NVL(l_st_rec.ar37,  l_default_ar);          a_ar(38)  := NVL(l_st_rec.ar38,  l_default_ar);          a_ar(39)  := NVL(l_st_rec.ar39,  l_default_ar);          a_ar(40)  := NVL(l_st_rec.ar40,  l_default_ar);
         a_ar(41)  := NVL(l_st_rec.ar41,  l_default_ar);          a_ar(42)  := NVL(l_st_rec.ar42,  l_default_ar);          a_ar(43)  := NVL(l_st_rec.ar43,  l_default_ar);          a_ar(44)  := NVL(l_st_rec.ar44,  l_default_ar);
         a_ar(45)  := NVL(l_st_rec.ar45,  l_default_ar);          a_ar(46)  := NVL(l_st_rec.ar46,  l_default_ar);          a_ar(47)  := NVL(l_st_rec.ar47,  l_default_ar);          a_ar(48)  := NVL(l_st_rec.ar48,  l_default_ar);
         a_ar(49)  := NVL(l_st_rec.ar49,  l_default_ar);          a_ar(50)  := NVL(l_st_rec.ar50,  l_default_ar);          a_ar(51)  := NVL(l_st_rec.ar51,  l_default_ar);          a_ar(52)  := NVL(l_st_rec.ar52,  l_default_ar);
         a_ar(53)  := NVL(l_st_rec.ar53,  l_default_ar);          a_ar(54)  := NVL(l_st_rec.ar54,  l_default_ar);          a_ar(55)  := NVL(l_st_rec.ar55,  l_default_ar);          a_ar(56)  := NVL(l_st_rec.ar56,  l_default_ar);
         a_ar(57)  := NVL(l_st_rec.ar57,  l_default_ar);          a_ar(58)  := NVL(l_st_rec.ar58,  l_default_ar);          a_ar(59)  := NVL(l_st_rec.ar59,  l_default_ar);          a_ar(60)  := NVL(l_st_rec.ar60,  l_default_ar);
         a_ar(61)  := NVL(l_st_rec.ar61,  l_default_ar);          a_ar(62)  := NVL(l_st_rec.ar62,  l_default_ar);          a_ar(63)  := NVL(l_st_rec.ar63,  l_default_ar);          a_ar(64)  := NVL(l_st_rec.ar64,  l_default_ar);
         a_ar(65)  := NVL(l_st_rec.ar65,  l_default_ar);          a_ar(66)  := NVL(l_st_rec.ar66,  l_default_ar);          a_ar(67)  := NVL(l_st_rec.ar67,  l_default_ar);          a_ar(68)  := NVL(l_st_rec.ar68,  l_default_ar);
         a_ar(69)  := NVL(l_st_rec.ar69,  l_default_ar);          a_ar(70)  := NVL(l_st_rec.ar70,  l_default_ar);          a_ar(71)  := NVL(l_st_rec.ar71,  l_default_ar);          a_ar(72)  := NVL(l_st_rec.ar72,  l_default_ar);
         a_ar(73)  := NVL(l_st_rec.ar73,  l_default_ar);          a_ar(74)  := NVL(l_st_rec.ar74,  l_default_ar);          a_ar(75)  := NVL(l_st_rec.ar75,  l_default_ar);          a_ar(76)  := NVL(l_st_rec.ar76,  l_default_ar);
         a_ar(77)  := NVL(l_st_rec.ar77,  l_default_ar);          a_ar(78)  := NVL(l_st_rec.ar78,  l_default_ar);          a_ar(79)  := NVL(l_st_rec.ar79,  l_default_ar);          a_ar(80)  := NVL(l_st_rec.ar80,  l_default_ar);
         a_ar(81)  := NVL(l_st_rec.ar81,  l_default_ar);          a_ar(82)  := NVL(l_st_rec.ar82,  l_default_ar);          a_ar(83)  := NVL(l_st_rec.ar83,  l_default_ar);          a_ar(84)  := NVL(l_st_rec.ar84,  l_default_ar);
         a_ar(85)  := NVL(l_st_rec.ar85,  l_default_ar);          a_ar(86)  := NVL(l_st_rec.ar86,  l_default_ar);          a_ar(87)  := NVL(l_st_rec.ar87,  l_default_ar);          a_ar(88)  := NVL(l_st_rec.ar88,  l_default_ar);
         a_ar(89)  := NVL(l_st_rec.ar89,  l_default_ar);          a_ar(90)  := NVL(l_st_rec.ar90,  l_default_ar);          a_ar(91)  := NVL(l_st_rec.ar91,  l_default_ar);          a_ar(92)  := NVL(l_st_rec.ar92,  l_default_ar);
         a_ar(93)  := NVL(l_st_rec.ar93,  l_default_ar);          a_ar(94)  := NVL(l_st_rec.ar94,  l_default_ar);          a_ar(95)  := NVL(l_st_rec.ar95,  l_default_ar);          a_ar(96)  := NVL(l_st_rec.ar96,  l_default_ar);
         a_ar(97)  := NVL(l_st_rec.ar97,  l_default_ar);          a_ar(98)  := NVL(l_st_rec.ar98,  l_default_ar);          a_ar(99)  := NVL(l_st_rec.ar99,  l_default_ar);          a_ar(100) := NVL(l_st_rec.ar100, l_default_ar);
         a_ar(101) := NVL(l_st_rec.ar101, l_default_ar);          a_ar(102) := NVL(l_st_rec.ar102, l_default_ar);          a_ar(103) := NVL(l_st_rec.ar103, l_default_ar);          a_ar(104) := NVL(l_st_rec.ar104, l_default_ar);
         a_ar(105) := NVL(l_st_rec.ar105, l_default_ar);          a_ar(106) := NVL(l_st_rec.ar106, l_default_ar);          a_ar(107) := NVL(l_st_rec.ar107, l_default_ar);          a_ar(108) := NVL(l_st_rec.ar108, l_default_ar);
         a_ar(109) := NVL(l_st_rec.ar109, l_default_ar);          a_ar(110) := NVL(l_st_rec.ar110, l_default_ar);          a_ar(111) := NVL(l_st_rec.ar111, l_default_ar);          a_ar(112) := NVL(l_st_rec.ar112, l_default_ar);
         a_ar(113) := NVL(l_st_rec.ar113, l_default_ar);          a_ar(114) := NVL(l_st_rec.ar114, l_default_ar);          a_ar(115) := NVL(l_st_rec.ar115, l_default_ar);          a_ar(116) := NVL(l_st_rec.ar116, l_default_ar);
         a_ar(117) := NVL(l_st_rec.ar117, l_default_ar);          a_ar(118) := NVL(l_st_rec.ar118, l_default_ar);          a_ar(119) := NVL(l_st_rec.ar119, l_default_ar);          a_ar(120) := NVL(l_st_rec.ar120, l_default_ar);
         a_ar(121) := NVL(l_st_rec.ar121, l_default_ar);          a_ar(122) := NVL(l_st_rec.ar122, l_default_ar);          a_ar(123) := NVL(l_st_rec.ar123, l_default_ar);          a_ar(124) := NVL(l_st_rec.ar124, l_default_ar);
         a_ar(125) := NVL(l_st_rec.ar125, l_default_ar);          a_ar(126) := NVL(l_st_rec.ar126, l_default_ar);          a_ar(127) := NVL(l_st_rec.ar127, l_default_ar);          a_ar(128) := NVL(l_st_rec.ar128, l_default_ar);
         RETURN(Unapigen.DBERR_SUCCESS);
      END IF;
   ELSIF a_object_tp IN ( 'ic', 'rqic', 'sdic' ) THEN
      OPEN l_inherit_ipar (a_object_id, UNAPIEV.P_IP_VERSION);
      FETCH l_inherit_ipar
      INTO l_ip_rec;
      l_found := l_inherit_ipar%FOUND;
      CLOSE l_inherit_ipar;

      IF l_found THEN
         a_ar(1)   := NVL(l_ip_rec.ar1,   l_default_ar);          a_ar(2)   := NVL(l_ip_rec.ar2,   l_default_ar);          a_ar(3)   := NVL(l_ip_rec.ar3,   l_default_ar);          a_ar(4)   := NVL(l_ip_rec.ar4,   l_default_ar);
         a_ar(5)   := NVL(l_ip_rec.ar5,   l_default_ar);          a_ar(6)   := NVL(l_ip_rec.ar6,   l_default_ar);          a_ar(7)   := NVL(l_ip_rec.ar7,   l_default_ar);          a_ar(8)   := NVL(l_ip_rec.ar8,   l_default_ar);
         a_ar(9)   := NVL(l_ip_rec.ar9,   l_default_ar);          a_ar(10)  := NVL(l_ip_rec.ar10,  l_default_ar);          a_ar(11)  := NVL(l_ip_rec.ar11,  l_default_ar);          a_ar(12)  := NVL(l_ip_rec.ar12,  l_default_ar);
         a_ar(13)  := NVL(l_ip_rec.ar13,  l_default_ar);          a_ar(14)  := NVL(l_ip_rec.ar14,  l_default_ar);          a_ar(15)  := NVL(l_ip_rec.ar15,  l_default_ar);          a_ar(16)  := NVL(l_ip_rec.ar16,  l_default_ar);
         a_ar(17)  := NVL(l_ip_rec.ar17,  l_default_ar);          a_ar(18)  := NVL(l_ip_rec.ar18,  l_default_ar);          a_ar(19)  := NVL(l_ip_rec.ar19,  l_default_ar);          a_ar(20)  := NVL(l_ip_rec.ar20,  l_default_ar);
         a_ar(21)  := NVL(l_ip_rec.ar21,  l_default_ar);          a_ar(22)  := NVL(l_ip_rec.ar22,  l_default_ar);          a_ar(23)  := NVL(l_ip_rec.ar23,  l_default_ar);          a_ar(24)  := NVL(l_ip_rec.ar24,  l_default_ar);
         a_ar(25)  := NVL(l_ip_rec.ar25,  l_default_ar);          a_ar(26)  := NVL(l_ip_rec.ar26,  l_default_ar);          a_ar(27)  := NVL(l_ip_rec.ar27,  l_default_ar);          a_ar(28)  := NVL(l_ip_rec.ar28,  l_default_ar);
         a_ar(29)  := NVL(l_ip_rec.ar29,  l_default_ar);          a_ar(30)  := NVL(l_ip_rec.ar30,  l_default_ar);          a_ar(31)  := NVL(l_ip_rec.ar31,  l_default_ar);          a_ar(32)  := NVL(l_ip_rec.ar32,  l_default_ar);
         a_ar(33)  := NVL(l_ip_rec.ar33,  l_default_ar);          a_ar(34)  := NVL(l_ip_rec.ar34,  l_default_ar);          a_ar(35)  := NVL(l_ip_rec.ar35,  l_default_ar);          a_ar(36)  := NVL(l_ip_rec.ar36,  l_default_ar);
         a_ar(37)  := NVL(l_ip_rec.ar37,  l_default_ar);          a_ar(38)  := NVL(l_ip_rec.ar38,  l_default_ar);          a_ar(39)  := NVL(l_ip_rec.ar39,  l_default_ar);          a_ar(40)  := NVL(l_ip_rec.ar40,  l_default_ar);
         a_ar(41)  := NVL(l_ip_rec.ar41,  l_default_ar);          a_ar(42)  := NVL(l_ip_rec.ar42,  l_default_ar);          a_ar(43)  := NVL(l_ip_rec.ar43,  l_default_ar);          a_ar(44)  := NVL(l_ip_rec.ar44,  l_default_ar);
         a_ar(45)  := NVL(l_ip_rec.ar45,  l_default_ar);          a_ar(46)  := NVL(l_ip_rec.ar46,  l_default_ar);          a_ar(47)  := NVL(l_ip_rec.ar47,  l_default_ar);          a_ar(48)  := NVL(l_ip_rec.ar48,  l_default_ar);
         a_ar(49)  := NVL(l_ip_rec.ar49,  l_default_ar);          a_ar(50)  := NVL(l_ip_rec.ar50,  l_default_ar);          a_ar(51)  := NVL(l_ip_rec.ar51,  l_default_ar);          a_ar(52)  := NVL(l_ip_rec.ar52,  l_default_ar);
         a_ar(53)  := NVL(l_ip_rec.ar53,  l_default_ar);          a_ar(54)  := NVL(l_ip_rec.ar54,  l_default_ar);          a_ar(55)  := NVL(l_ip_rec.ar55,  l_default_ar);          a_ar(56)  := NVL(l_ip_rec.ar56,  l_default_ar);
         a_ar(57)  := NVL(l_ip_rec.ar57,  l_default_ar);          a_ar(58)  := NVL(l_ip_rec.ar58,  l_default_ar);          a_ar(59)  := NVL(l_ip_rec.ar59,  l_default_ar);          a_ar(60)  := NVL(l_ip_rec.ar60,  l_default_ar);
         a_ar(61)  := NVL(l_ip_rec.ar61,  l_default_ar);          a_ar(62)  := NVL(l_ip_rec.ar62,  l_default_ar);          a_ar(63)  := NVL(l_ip_rec.ar63,  l_default_ar);          a_ar(64)  := NVL(l_ip_rec.ar64,  l_default_ar);
         a_ar(65)  := NVL(l_ip_rec.ar65,  l_default_ar);          a_ar(66)  := NVL(l_ip_rec.ar66,  l_default_ar);          a_ar(67)  := NVL(l_ip_rec.ar67,  l_default_ar);          a_ar(68)  := NVL(l_ip_rec.ar68,  l_default_ar);
         a_ar(69)  := NVL(l_ip_rec.ar69,  l_default_ar);          a_ar(70)  := NVL(l_ip_rec.ar70,  l_default_ar);          a_ar(71)  := NVL(l_ip_rec.ar71,  l_default_ar);          a_ar(72)  := NVL(l_ip_rec.ar72,  l_default_ar);
         a_ar(73)  := NVL(l_ip_rec.ar73,  l_default_ar);          a_ar(74)  := NVL(l_ip_rec.ar74,  l_default_ar);          a_ar(75)  := NVL(l_ip_rec.ar75,  l_default_ar);          a_ar(76)  := NVL(l_ip_rec.ar76,  l_default_ar);
         a_ar(77)  := NVL(l_ip_rec.ar77,  l_default_ar);          a_ar(78)  := NVL(l_ip_rec.ar78,  l_default_ar);          a_ar(79)  := NVL(l_ip_rec.ar79,  l_default_ar);          a_ar(80)  := NVL(l_ip_rec.ar80,  l_default_ar);
         a_ar(81)  := NVL(l_ip_rec.ar81,  l_default_ar);          a_ar(82)  := NVL(l_ip_rec.ar82,  l_default_ar);          a_ar(83)  := NVL(l_ip_rec.ar83,  l_default_ar);          a_ar(84)  := NVL(l_ip_rec.ar84,  l_default_ar);
         a_ar(85)  := NVL(l_ip_rec.ar85,  l_default_ar);          a_ar(86)  := NVL(l_ip_rec.ar86,  l_default_ar);          a_ar(87)  := NVL(l_ip_rec.ar87,  l_default_ar);          a_ar(88)  := NVL(l_ip_rec.ar88,  l_default_ar);
         a_ar(89)  := NVL(l_ip_rec.ar89,  l_default_ar);          a_ar(90)  := NVL(l_ip_rec.ar90,  l_default_ar);          a_ar(91)  := NVL(l_ip_rec.ar91,  l_default_ar);          a_ar(92)  := NVL(l_ip_rec.ar92,  l_default_ar);
         a_ar(93)  := NVL(l_ip_rec.ar93,  l_default_ar);          a_ar(94)  := NVL(l_ip_rec.ar94,  l_default_ar);          a_ar(95)  := NVL(l_ip_rec.ar95,  l_default_ar);          a_ar(96)  := NVL(l_ip_rec.ar96,  l_default_ar);
         a_ar(97)  := NVL(l_ip_rec.ar97,  l_default_ar);          a_ar(98)  := NVL(l_ip_rec.ar98,  l_default_ar);          a_ar(99)  := NVL(l_ip_rec.ar99,  l_default_ar);          a_ar(100) := NVL(l_ip_rec.ar100, l_default_ar);
         a_ar(101) := NVL(l_ip_rec.ar101, l_default_ar);          a_ar(102) := NVL(l_ip_rec.ar102, l_default_ar);          a_ar(103) := NVL(l_ip_rec.ar103, l_default_ar);          a_ar(104) := NVL(l_ip_rec.ar104, l_default_ar);
         a_ar(105) := NVL(l_ip_rec.ar105, l_default_ar);          a_ar(106) := NVL(l_ip_rec.ar106, l_default_ar);          a_ar(107) := NVL(l_ip_rec.ar107, l_default_ar);          a_ar(108) := NVL(l_ip_rec.ar108, l_default_ar);
         a_ar(109) := NVL(l_ip_rec.ar109, l_default_ar);          a_ar(110) := NVL(l_ip_rec.ar110, l_default_ar);          a_ar(111) := NVL(l_ip_rec.ar111, l_default_ar);          a_ar(112) := NVL(l_ip_rec.ar112, l_default_ar);
         a_ar(113) := NVL(l_ip_rec.ar113, l_default_ar);          a_ar(114) := NVL(l_ip_rec.ar114, l_default_ar);          a_ar(115) := NVL(l_ip_rec.ar115, l_default_ar);          a_ar(116) := NVL(l_ip_rec.ar116, l_default_ar);
         a_ar(117) := NVL(l_ip_rec.ar117, l_default_ar);          a_ar(118) := NVL(l_ip_rec.ar118, l_default_ar);          a_ar(119) := NVL(l_ip_rec.ar119, l_default_ar);          a_ar(120) := NVL(l_ip_rec.ar120, l_default_ar);
         a_ar(121) := NVL(l_ip_rec.ar121, l_default_ar);          a_ar(122) := NVL(l_ip_rec.ar122, l_default_ar);          a_ar(123) := NVL(l_ip_rec.ar123, l_default_ar);          a_ar(124) := NVL(l_ip_rec.ar124, l_default_ar);
         a_ar(125) := NVL(l_ip_rec.ar125, l_default_ar);          a_ar(126) := NVL(l_ip_rec.ar126, l_default_ar);          a_ar(127) := NVL(l_ip_rec.ar127, l_default_ar);          a_ar(128) := NVL(l_ip_rec.ar128, l_default_ar);
         RETURN(Unapigen.DBERR_SUCCESS);
      END IF;
   ELSIF a_object_tp IN ( 'ii', 'rqii', 'sdii' ) THEN
      OPEN l_inherit_iear (a_object_id, UNAPIEV.P_IE_VERSION);
      FETCH l_inherit_iear
      INTO l_ie_rec;
      l_found := l_inherit_iear%FOUND;
      CLOSE l_inherit_iear;

      IF l_found THEN
         a_ar(1)   := NVL(l_ie_rec.ar1,   l_default_ar);          a_ar(2)   := NVL(l_ie_rec.ar2,   l_default_ar);          a_ar(3)   := NVL(l_ie_rec.ar3,   l_default_ar);          a_ar(4)   := NVL(l_ie_rec.ar4,   l_default_ar);
         a_ar(5)   := NVL(l_ie_rec.ar5,   l_default_ar);          a_ar(6)   := NVL(l_ie_rec.ar6,   l_default_ar);          a_ar(7)   := NVL(l_ie_rec.ar7,   l_default_ar);          a_ar(8)   := NVL(l_ie_rec.ar8,   l_default_ar);
         a_ar(9)   := NVL(l_ie_rec.ar9,   l_default_ar);          a_ar(10)  := NVL(l_ie_rec.ar10,  l_default_ar);          a_ar(11)  := NVL(l_ie_rec.ar11,  l_default_ar);          a_ar(12)  := NVL(l_ie_rec.ar12,  l_default_ar);
         a_ar(13)  := NVL(l_ie_rec.ar13,  l_default_ar);          a_ar(14)  := NVL(l_ie_rec.ar14,  l_default_ar);          a_ar(15)  := NVL(l_ie_rec.ar15,  l_default_ar);          a_ar(16)  := NVL(l_ie_rec.ar16,  l_default_ar);
         a_ar(17)  := NVL(l_ie_rec.ar17,  l_default_ar);          a_ar(18)  := NVL(l_ie_rec.ar18,  l_default_ar);          a_ar(19)  := NVL(l_ie_rec.ar19,  l_default_ar);          a_ar(20)  := NVL(l_ie_rec.ar20,  l_default_ar);
         a_ar(21)  := NVL(l_ie_rec.ar21,  l_default_ar);          a_ar(22)  := NVL(l_ie_rec.ar22,  l_default_ar);          a_ar(23)  := NVL(l_ie_rec.ar23,  l_default_ar);          a_ar(24)  := NVL(l_ie_rec.ar24,  l_default_ar);
         a_ar(25)  := NVL(l_ie_rec.ar25,  l_default_ar);          a_ar(26)  := NVL(l_ie_rec.ar26,  l_default_ar);          a_ar(27)  := NVL(l_ie_rec.ar27,  l_default_ar);          a_ar(28)  := NVL(l_ie_rec.ar28,  l_default_ar);
         a_ar(29)  := NVL(l_ie_rec.ar29,  l_default_ar);          a_ar(30)  := NVL(l_ie_rec.ar30,  l_default_ar);          a_ar(31)  := NVL(l_ie_rec.ar31,  l_default_ar);          a_ar(32)  := NVL(l_ie_rec.ar32,  l_default_ar);
         a_ar(33)  := NVL(l_ie_rec.ar33,  l_default_ar);          a_ar(34)  := NVL(l_ie_rec.ar34,  l_default_ar);          a_ar(35)  := NVL(l_ie_rec.ar35,  l_default_ar);          a_ar(36)  := NVL(l_ie_rec.ar36,  l_default_ar);
         a_ar(37)  := NVL(l_ie_rec.ar37,  l_default_ar);          a_ar(38)  := NVL(l_ie_rec.ar38,  l_default_ar);          a_ar(39)  := NVL(l_ie_rec.ar39,  l_default_ar);          a_ar(40)  := NVL(l_ie_rec.ar40,  l_default_ar);
         a_ar(41)  := NVL(l_ie_rec.ar41,  l_default_ar);          a_ar(42)  := NVL(l_ie_rec.ar42,  l_default_ar);          a_ar(43)  := NVL(l_ie_rec.ar43,  l_default_ar);          a_ar(44)  := NVL(l_ie_rec.ar44,  l_default_ar);
         a_ar(45)  := NVL(l_ie_rec.ar45,  l_default_ar);          a_ar(46)  := NVL(l_ie_rec.ar46,  l_default_ar);          a_ar(47)  := NVL(l_ie_rec.ar47,  l_default_ar);          a_ar(48)  := NVL(l_ie_rec.ar48,  l_default_ar);
         a_ar(49)  := NVL(l_ie_rec.ar49,  l_default_ar);          a_ar(50)  := NVL(l_ie_rec.ar50,  l_default_ar);          a_ar(51)  := NVL(l_ie_rec.ar51,  l_default_ar);          a_ar(52)  := NVL(l_ie_rec.ar52,  l_default_ar);
         a_ar(53)  := NVL(l_ie_rec.ar53,  l_default_ar);          a_ar(54)  := NVL(l_ie_rec.ar54,  l_default_ar);          a_ar(55)  := NVL(l_ie_rec.ar55,  l_default_ar);          a_ar(56)  := NVL(l_ie_rec.ar56,  l_default_ar);
         a_ar(57)  := NVL(l_ie_rec.ar57,  l_default_ar);          a_ar(58)  := NVL(l_ie_rec.ar58,  l_default_ar);          a_ar(59)  := NVL(l_ie_rec.ar59,  l_default_ar);          a_ar(60)  := NVL(l_ie_rec.ar60,  l_default_ar);
         a_ar(61)  := NVL(l_ie_rec.ar61,  l_default_ar);          a_ar(62)  := NVL(l_ie_rec.ar62,  l_default_ar);          a_ar(63)  := NVL(l_ie_rec.ar63,  l_default_ar);          a_ar(64)  := NVL(l_ie_rec.ar64,  l_default_ar);
         a_ar(65)  := NVL(l_ie_rec.ar65,  l_default_ar);          a_ar(66)  := NVL(l_ie_rec.ar66,  l_default_ar);          a_ar(67)  := NVL(l_ie_rec.ar67,  l_default_ar);          a_ar(68)  := NVL(l_ie_rec.ar68,  l_default_ar);
         a_ar(69)  := NVL(l_ie_rec.ar69,  l_default_ar);          a_ar(70)  := NVL(l_ie_rec.ar70,  l_default_ar);          a_ar(71)  := NVL(l_ie_rec.ar71,  l_default_ar);          a_ar(72)  := NVL(l_ie_rec.ar72,  l_default_ar);
         a_ar(73)  := NVL(l_ie_rec.ar73,  l_default_ar);          a_ar(74)  := NVL(l_ie_rec.ar74,  l_default_ar);          a_ar(75)  := NVL(l_ie_rec.ar75,  l_default_ar);          a_ar(76)  := NVL(l_ie_rec.ar76,  l_default_ar);
         a_ar(77)  := NVL(l_ie_rec.ar77,  l_default_ar);          a_ar(78)  := NVL(l_ie_rec.ar78,  l_default_ar);          a_ar(79)  := NVL(l_ie_rec.ar79,  l_default_ar);          a_ar(80)  := NVL(l_ie_rec.ar80,  l_default_ar);
         a_ar(81)  := NVL(l_ie_rec.ar81,  l_default_ar);          a_ar(82)  := NVL(l_ie_rec.ar82,  l_default_ar);          a_ar(83)  := NVL(l_ie_rec.ar83,  l_default_ar);          a_ar(84)  := NVL(l_ie_rec.ar84,  l_default_ar);
         a_ar(85)  := NVL(l_ie_rec.ar85,  l_default_ar);          a_ar(86)  := NVL(l_ie_rec.ar86,  l_default_ar);          a_ar(87)  := NVL(l_ie_rec.ar87,  l_default_ar);          a_ar(88)  := NVL(l_ie_rec.ar88,  l_default_ar);
         a_ar(89)  := NVL(l_ie_rec.ar89,  l_default_ar);          a_ar(90)  := NVL(l_ie_rec.ar90,  l_default_ar);          a_ar(91)  := NVL(l_ie_rec.ar91,  l_default_ar);          a_ar(92)  := NVL(l_ie_rec.ar92,  l_default_ar);
         a_ar(93)  := NVL(l_ie_rec.ar93,  l_default_ar);          a_ar(94)  := NVL(l_ie_rec.ar94,  l_default_ar);          a_ar(95)  := NVL(l_ie_rec.ar95,  l_default_ar);          a_ar(96)  := NVL(l_ie_rec.ar96,  l_default_ar);
         a_ar(97)  := NVL(l_ie_rec.ar97,  l_default_ar);          a_ar(98)  := NVL(l_ie_rec.ar98,  l_default_ar);          a_ar(99)  := NVL(l_ie_rec.ar99,  l_default_ar);          a_ar(100) := NVL(l_ie_rec.ar100, l_default_ar);
         a_ar(101) := NVL(l_ie_rec.ar101, l_default_ar);          a_ar(102) := NVL(l_ie_rec.ar102, l_default_ar);          a_ar(103) := NVL(l_ie_rec.ar103, l_default_ar);          a_ar(104) := NVL(l_ie_rec.ar104, l_default_ar);
         a_ar(105) := NVL(l_ie_rec.ar105, l_default_ar);          a_ar(106) := NVL(l_ie_rec.ar106, l_default_ar);          a_ar(107) := NVL(l_ie_rec.ar107, l_default_ar);          a_ar(108) := NVL(l_ie_rec.ar108, l_default_ar);
         a_ar(109) := NVL(l_ie_rec.ar109, l_default_ar);          a_ar(110) := NVL(l_ie_rec.ar110, l_default_ar);          a_ar(111) := NVL(l_ie_rec.ar111, l_default_ar);          a_ar(112) := NVL(l_ie_rec.ar112, l_default_ar);
         a_ar(113) := NVL(l_ie_rec.ar113, l_default_ar);          a_ar(114) := NVL(l_ie_rec.ar114, l_default_ar);          a_ar(115) := NVL(l_ie_rec.ar115, l_default_ar);          a_ar(116) := NVL(l_ie_rec.ar116, l_default_ar);
         a_ar(117) := NVL(l_ie_rec.ar117, l_default_ar);          a_ar(118) := NVL(l_ie_rec.ar118, l_default_ar);          a_ar(119) := NVL(l_ie_rec.ar119, l_default_ar);          a_ar(120) := NVL(l_ie_rec.ar120, l_default_ar);
         a_ar(121) := NVL(l_ie_rec.ar121, l_default_ar);          a_ar(122) := NVL(l_ie_rec.ar122, l_default_ar);          a_ar(123) := NVL(l_ie_rec.ar123, l_default_ar);          a_ar(124) := NVL(l_ie_rec.ar124, l_default_ar);
         a_ar(125) := NVL(l_ie_rec.ar125, l_default_ar);          a_ar(126) := NVL(l_ie_rec.ar126, l_default_ar);          a_ar(127) := NVL(l_ie_rec.ar127, l_default_ar);          a_ar(128) := NVL(l_ie_rec.ar128, l_default_ar);
         RETURN(Unapigen.DBERR_SUCCESS);
      END IF;
   ELSIF (a_object_tp = 'pg') THEN
      OPEN l_inherit_ppar (UNAPIEV.P_SC,
                           a_object_id,
                           UNAPIEV.P_PGNODE,
                           UNAPIEV.P_PP_VERSION);
      FETCH l_inherit_ppar
      INTO l_pp_rec;
      l_found := l_inherit_ppar%FOUND;
      CLOSE l_inherit_ppar;

      IF l_found THEN
         a_ar(1)   := NVL(l_pp_rec.ar1,   l_default_ar);          a_ar(2)   := NVL(l_pp_rec.ar2,   l_default_ar);          a_ar(3)   := NVL(l_pp_rec.ar3,   l_default_ar);          a_ar(4)   := NVL(l_pp_rec.ar4,   l_default_ar);
         a_ar(5)   := NVL(l_pp_rec.ar5,   l_default_ar);          a_ar(6)   := NVL(l_pp_rec.ar6,   l_default_ar);          a_ar(7)   := NVL(l_pp_rec.ar7,   l_default_ar);          a_ar(8)   := NVL(l_pp_rec.ar8,   l_default_ar);
         a_ar(9)   := NVL(l_pp_rec.ar9,   l_default_ar);          a_ar(10)  := NVL(l_pp_rec.ar10,  l_default_ar);          a_ar(11)  := NVL(l_pp_rec.ar11,  l_default_ar);          a_ar(12)  := NVL(l_pp_rec.ar12,  l_default_ar);
         a_ar(13)  := NVL(l_pp_rec.ar13,  l_default_ar);          a_ar(14)  := NVL(l_pp_rec.ar14,  l_default_ar);          a_ar(15)  := NVL(l_pp_rec.ar15,  l_default_ar);          a_ar(16)  := NVL(l_pp_rec.ar16,  l_default_ar);
         a_ar(17)  := NVL(l_pp_rec.ar17,  l_default_ar);          a_ar(18)  := NVL(l_pp_rec.ar18,  l_default_ar);          a_ar(19)  := NVL(l_pp_rec.ar19,  l_default_ar);          a_ar(20)  := NVL(l_pp_rec.ar20,  l_default_ar);
         a_ar(21)  := NVL(l_pp_rec.ar21,  l_default_ar);          a_ar(22)  := NVL(l_pp_rec.ar22,  l_default_ar);          a_ar(23)  := NVL(l_pp_rec.ar23,  l_default_ar);          a_ar(24)  := NVL(l_pp_rec.ar24,  l_default_ar);
         a_ar(25)  := NVL(l_pp_rec.ar25,  l_default_ar);          a_ar(26)  := NVL(l_pp_rec.ar26,  l_default_ar);          a_ar(27)  := NVL(l_pp_rec.ar27,  l_default_ar);          a_ar(28)  := NVL(l_pp_rec.ar28,  l_default_ar);
         a_ar(29)  := NVL(l_pp_rec.ar29,  l_default_ar);          a_ar(30)  := NVL(l_pp_rec.ar30,  l_default_ar);          a_ar(31)  := NVL(l_pp_rec.ar31,  l_default_ar);          a_ar(32)  := NVL(l_pp_rec.ar32,  l_default_ar);
         a_ar(33)  := NVL(l_pp_rec.ar33,  l_default_ar);          a_ar(34)  := NVL(l_pp_rec.ar34,  l_default_ar);          a_ar(35)  := NVL(l_pp_rec.ar35,  l_default_ar);          a_ar(36)  := NVL(l_pp_rec.ar36,  l_default_ar);
         a_ar(37)  := NVL(l_pp_rec.ar37,  l_default_ar);          a_ar(38)  := NVL(l_pp_rec.ar38,  l_default_ar);          a_ar(39)  := NVL(l_pp_rec.ar39,  l_default_ar);          a_ar(40)  := NVL(l_pp_rec.ar40,  l_default_ar);
         a_ar(41)  := NVL(l_pp_rec.ar41,  l_default_ar);          a_ar(42)  := NVL(l_pp_rec.ar42,  l_default_ar);          a_ar(43)  := NVL(l_pp_rec.ar43,  l_default_ar);          a_ar(44)  := NVL(l_pp_rec.ar44,  l_default_ar);
         a_ar(45)  := NVL(l_pp_rec.ar45,  l_default_ar);          a_ar(46)  := NVL(l_pp_rec.ar46,  l_default_ar);          a_ar(47)  := NVL(l_pp_rec.ar47,  l_default_ar);          a_ar(48)  := NVL(l_pp_rec.ar48,  l_default_ar);
         a_ar(49)  := NVL(l_pp_rec.ar49,  l_default_ar);          a_ar(50)  := NVL(l_pp_rec.ar50,  l_default_ar);          a_ar(51)  := NVL(l_pp_rec.ar51,  l_default_ar);          a_ar(52)  := NVL(l_pp_rec.ar52,  l_default_ar);
         a_ar(53)  := NVL(l_pp_rec.ar53,  l_default_ar);          a_ar(54)  := NVL(l_pp_rec.ar54,  l_default_ar);          a_ar(55)  := NVL(l_pp_rec.ar55,  l_default_ar);          a_ar(56)  := NVL(l_pp_rec.ar56,  l_default_ar);
         a_ar(57)  := NVL(l_pp_rec.ar57,  l_default_ar);          a_ar(58)  := NVL(l_pp_rec.ar58,  l_default_ar);          a_ar(59)  := NVL(l_pp_rec.ar59,  l_default_ar);          a_ar(60)  := NVL(l_pp_rec.ar60,  l_default_ar);
         a_ar(61)  := NVL(l_pp_rec.ar61,  l_default_ar);          a_ar(62)  := NVL(l_pp_rec.ar62,  l_default_ar);          a_ar(63)  := NVL(l_pp_rec.ar63,  l_default_ar);          a_ar(64)  := NVL(l_pp_rec.ar64,  l_default_ar);
         a_ar(65)  := NVL(l_pp_rec.ar65,  l_default_ar);          a_ar(66)  := NVL(l_pp_rec.ar66,  l_default_ar);          a_ar(67)  := NVL(l_pp_rec.ar67,  l_default_ar);          a_ar(68)  := NVL(l_pp_rec.ar68,  l_default_ar);
         a_ar(69)  := NVL(l_pp_rec.ar69,  l_default_ar);          a_ar(70)  := NVL(l_pp_rec.ar70,  l_default_ar);          a_ar(71)  := NVL(l_pp_rec.ar71,  l_default_ar);          a_ar(72)  := NVL(l_pp_rec.ar72,  l_default_ar);
         a_ar(73)  := NVL(l_pp_rec.ar73,  l_default_ar);          a_ar(74)  := NVL(l_pp_rec.ar74,  l_default_ar);          a_ar(75)  := NVL(l_pp_rec.ar75,  l_default_ar);          a_ar(76)  := NVL(l_pp_rec.ar76,  l_default_ar);
         a_ar(77)  := NVL(l_pp_rec.ar77,  l_default_ar);          a_ar(78)  := NVL(l_pp_rec.ar78,  l_default_ar);          a_ar(79)  := NVL(l_pp_rec.ar79,  l_default_ar);          a_ar(80)  := NVL(l_pp_rec.ar80,  l_default_ar);
         a_ar(81)  := NVL(l_pp_rec.ar81,  l_default_ar);          a_ar(82)  := NVL(l_pp_rec.ar82,  l_default_ar);          a_ar(83)  := NVL(l_pp_rec.ar83,  l_default_ar);          a_ar(84)  := NVL(l_pp_rec.ar84,  l_default_ar);
         a_ar(85)  := NVL(l_pp_rec.ar85,  l_default_ar);          a_ar(86)  := NVL(l_pp_rec.ar86,  l_default_ar);          a_ar(87)  := NVL(l_pp_rec.ar87,  l_default_ar);          a_ar(88)  := NVL(l_pp_rec.ar88,  l_default_ar);
         a_ar(89)  := NVL(l_pp_rec.ar89,  l_default_ar);          a_ar(90)  := NVL(l_pp_rec.ar90,  l_default_ar);          a_ar(91)  := NVL(l_pp_rec.ar91,  l_default_ar);          a_ar(92)  := NVL(l_pp_rec.ar92,  l_default_ar);
         a_ar(93)  := NVL(l_pp_rec.ar93,  l_default_ar);          a_ar(94)  := NVL(l_pp_rec.ar94,  l_default_ar);          a_ar(95)  := NVL(l_pp_rec.ar95,  l_default_ar);          a_ar(96)  := NVL(l_pp_rec.ar96,  l_default_ar);
         a_ar(97)  := NVL(l_pp_rec.ar97,  l_default_ar);          a_ar(98)  := NVL(l_pp_rec.ar98,  l_default_ar);          a_ar(99)  := NVL(l_pp_rec.ar99,  l_default_ar);          a_ar(100) := NVL(l_pp_rec.ar100, l_default_ar);
         a_ar(101) := NVL(l_pp_rec.ar101, l_default_ar);          a_ar(102) := NVL(l_pp_rec.ar102, l_default_ar);          a_ar(103) := NVL(l_pp_rec.ar103, l_default_ar);          a_ar(104) := NVL(l_pp_rec.ar104, l_default_ar);
         a_ar(105) := NVL(l_pp_rec.ar105, l_default_ar);          a_ar(106) := NVL(l_pp_rec.ar106, l_default_ar);          a_ar(107) := NVL(l_pp_rec.ar107, l_default_ar);          a_ar(108) := NVL(l_pp_rec.ar108, l_default_ar);
         a_ar(109) := NVL(l_pp_rec.ar109, l_default_ar);          a_ar(110) := NVL(l_pp_rec.ar110, l_default_ar);          a_ar(111) := NVL(l_pp_rec.ar111, l_default_ar);          a_ar(112) := NVL(l_pp_rec.ar112, l_default_ar);
         a_ar(113) := NVL(l_pp_rec.ar113, l_default_ar);          a_ar(114) := NVL(l_pp_rec.ar114, l_default_ar);          a_ar(115) := NVL(l_pp_rec.ar115, l_default_ar);          a_ar(116) := NVL(l_pp_rec.ar116, l_default_ar);
         a_ar(117) := NVL(l_pp_rec.ar117, l_default_ar);          a_ar(118) := NVL(l_pp_rec.ar118, l_default_ar);          a_ar(119) := NVL(l_pp_rec.ar119, l_default_ar);          a_ar(120) := NVL(l_pp_rec.ar120, l_default_ar);
         a_ar(121) := NVL(l_pp_rec.ar121, l_default_ar);          a_ar(122) := NVL(l_pp_rec.ar122, l_default_ar);          a_ar(123) := NVL(l_pp_rec.ar123, l_default_ar);          a_ar(124) := NVL(l_pp_rec.ar124, l_default_ar);
         a_ar(125) := NVL(l_pp_rec.ar125, l_default_ar);          a_ar(126) := NVL(l_pp_rec.ar126, l_default_ar);          a_ar(127) := NVL(l_pp_rec.ar127, l_default_ar);          a_ar(128) := NVL(l_pp_rec.ar128, l_default_ar);
         RETURN(Unapigen.DBERR_SUCCESS);
      END IF;
   ELSIF (a_object_tp = 'pa') THEN
      OPEN l_inherit_prar (a_object_id, UNAPIEV.P_PR_VERSION);
      FETCH l_inherit_prar
      INTO l_pr_rec;
      l_found := l_inherit_prar%FOUND;
      CLOSE l_inherit_prar;

      IF l_found THEN
         a_ar(1)   := NVL(l_pr_rec.ar1,   l_default_ar);          a_ar(2)   := NVL(l_pr_rec.ar2,   l_default_ar);          a_ar(3)   := NVL(l_pr_rec.ar3,   l_default_ar);          a_ar(4)   := NVL(l_pr_rec.ar4,   l_default_ar);
         a_ar(5)   := NVL(l_pr_rec.ar5,   l_default_ar);          a_ar(6)   := NVL(l_pr_rec.ar6,   l_default_ar);          a_ar(7)   := NVL(l_pr_rec.ar7,   l_default_ar);          a_ar(8)   := NVL(l_pr_rec.ar8,   l_default_ar);
         a_ar(9)   := NVL(l_pr_rec.ar9,   l_default_ar);          a_ar(10)  := NVL(l_pr_rec.ar10,  l_default_ar);          a_ar(11)  := NVL(l_pr_rec.ar11,  l_default_ar);          a_ar(12)  := NVL(l_pr_rec.ar12,  l_default_ar);
         a_ar(13)  := NVL(l_pr_rec.ar13,  l_default_ar);          a_ar(14)  := NVL(l_pr_rec.ar14,  l_default_ar);          a_ar(15)  := NVL(l_pr_rec.ar15,  l_default_ar);          a_ar(16)  := NVL(l_pr_rec.ar16,  l_default_ar);
         a_ar(17)  := NVL(l_pr_rec.ar17,  l_default_ar);          a_ar(18)  := NVL(l_pr_rec.ar18,  l_default_ar);          a_ar(19)  := NVL(l_pr_rec.ar19,  l_default_ar);          a_ar(20)  := NVL(l_pr_rec.ar20,  l_default_ar);
         a_ar(21)  := NVL(l_pr_rec.ar21,  l_default_ar);          a_ar(22)  := NVL(l_pr_rec.ar22,  l_default_ar);          a_ar(23)  := NVL(l_pr_rec.ar23,  l_default_ar);          a_ar(24)  := NVL(l_pr_rec.ar24,  l_default_ar);
         a_ar(25)  := NVL(l_pr_rec.ar25,  l_default_ar);          a_ar(26)  := NVL(l_pr_rec.ar26,  l_default_ar);          a_ar(27)  := NVL(l_pr_rec.ar27,  l_default_ar);          a_ar(28)  := NVL(l_pr_rec.ar28,  l_default_ar);
         a_ar(29)  := NVL(l_pr_rec.ar29,  l_default_ar);          a_ar(30)  := NVL(l_pr_rec.ar30,  l_default_ar);          a_ar(31)  := NVL(l_pr_rec.ar31,  l_default_ar);          a_ar(32)  := NVL(l_pr_rec.ar32,  l_default_ar);
         a_ar(33)  := NVL(l_pr_rec.ar33,  l_default_ar);          a_ar(34)  := NVL(l_pr_rec.ar34,  l_default_ar);          a_ar(35)  := NVL(l_pr_rec.ar35,  l_default_ar);          a_ar(36)  := NVL(l_pr_rec.ar36,  l_default_ar);
         a_ar(37)  := NVL(l_pr_rec.ar37,  l_default_ar);          a_ar(38)  := NVL(l_pr_rec.ar38,  l_default_ar);          a_ar(39)  := NVL(l_pr_rec.ar39,  l_default_ar);          a_ar(40)  := NVL(l_pr_rec.ar40,  l_default_ar);
         a_ar(41)  := NVL(l_pr_rec.ar41,  l_default_ar);          a_ar(42)  := NVL(l_pr_rec.ar42,  l_default_ar);          a_ar(43)  := NVL(l_pr_rec.ar43,  l_default_ar);          a_ar(44)  := NVL(l_pr_rec.ar44,  l_default_ar);
         a_ar(45)  := NVL(l_pr_rec.ar45,  l_default_ar);          a_ar(46)  := NVL(l_pr_rec.ar46,  l_default_ar);          a_ar(47)  := NVL(l_pr_rec.ar47,  l_default_ar);          a_ar(48)  := NVL(l_pr_rec.ar48,  l_default_ar);
         a_ar(49)  := NVL(l_pr_rec.ar49,  l_default_ar);          a_ar(50)  := NVL(l_pr_rec.ar50,  l_default_ar);          a_ar(51)  := NVL(l_pr_rec.ar51,  l_default_ar);          a_ar(52)  := NVL(l_pr_rec.ar52,  l_default_ar);
         a_ar(53)  := NVL(l_pr_rec.ar53,  l_default_ar);          a_ar(54)  := NVL(l_pr_rec.ar54,  l_default_ar);          a_ar(55)  := NVL(l_pr_rec.ar55,  l_default_ar);          a_ar(56)  := NVL(l_pr_rec.ar56,  l_default_ar);
         a_ar(57)  := NVL(l_pr_rec.ar57,  l_default_ar);          a_ar(58)  := NVL(l_pr_rec.ar58,  l_default_ar);          a_ar(59)  := NVL(l_pr_rec.ar59,  l_default_ar);          a_ar(60)  := NVL(l_pr_rec.ar60,  l_default_ar);
         a_ar(61)  := NVL(l_pr_rec.ar61,  l_default_ar);          a_ar(62)  := NVL(l_pr_rec.ar62,  l_default_ar);          a_ar(63)  := NVL(l_pr_rec.ar63,  l_default_ar);          a_ar(64)  := NVL(l_pr_rec.ar64,  l_default_ar);
         a_ar(65)  := NVL(l_pr_rec.ar65,  l_default_ar);          a_ar(66)  := NVL(l_pr_rec.ar66,  l_default_ar);          a_ar(67)  := NVL(l_pr_rec.ar67,  l_default_ar);          a_ar(68)  := NVL(l_pr_rec.ar68,  l_default_ar);
         a_ar(69)  := NVL(l_pr_rec.ar69,  l_default_ar);          a_ar(70)  := NVL(l_pr_rec.ar70,  l_default_ar);          a_ar(71)  := NVL(l_pr_rec.ar71,  l_default_ar);          a_ar(72)  := NVL(l_pr_rec.ar72,  l_default_ar);
         a_ar(73)  := NVL(l_pr_rec.ar73,  l_default_ar);          a_ar(74)  := NVL(l_pr_rec.ar74,  l_default_ar);          a_ar(75)  := NVL(l_pr_rec.ar75,  l_default_ar);          a_ar(76)  := NVL(l_pr_rec.ar76,  l_default_ar);
         a_ar(77)  := NVL(l_pr_rec.ar77,  l_default_ar);          a_ar(78)  := NVL(l_pr_rec.ar78,  l_default_ar);          a_ar(79)  := NVL(l_pr_rec.ar79,  l_default_ar);          a_ar(80)  := NVL(l_pr_rec.ar80,  l_default_ar);
         a_ar(81)  := NVL(l_pr_rec.ar81,  l_default_ar);          a_ar(82)  := NVL(l_pr_rec.ar82,  l_default_ar);          a_ar(83)  := NVL(l_pr_rec.ar83,  l_default_ar);          a_ar(84)  := NVL(l_pr_rec.ar84,  l_default_ar);
         a_ar(85)  := NVL(l_pr_rec.ar85,  l_default_ar);          a_ar(86)  := NVL(l_pr_rec.ar86,  l_default_ar);          a_ar(87)  := NVL(l_pr_rec.ar87,  l_default_ar);          a_ar(88)  := NVL(l_pr_rec.ar88,  l_default_ar);
         a_ar(89)  := NVL(l_pr_rec.ar89,  l_default_ar);          a_ar(90)  := NVL(l_pr_rec.ar90,  l_default_ar);          a_ar(91)  := NVL(l_pr_rec.ar91,  l_default_ar);          a_ar(92)  := NVL(l_pr_rec.ar92,  l_default_ar);
         a_ar(93)  := NVL(l_pr_rec.ar93,  l_default_ar);          a_ar(94)  := NVL(l_pr_rec.ar94,  l_default_ar);          a_ar(95)  := NVL(l_pr_rec.ar95,  l_default_ar);          a_ar(96)  := NVL(l_pr_rec.ar96,  l_default_ar);
         a_ar(97)  := NVL(l_pr_rec.ar97,  l_default_ar);          a_ar(98)  := NVL(l_pr_rec.ar98,  l_default_ar);          a_ar(99)  := NVL(l_pr_rec.ar99,  l_default_ar);          a_ar(100) := NVL(l_pr_rec.ar100, l_default_ar);
         a_ar(101) := NVL(l_pr_rec.ar101, l_default_ar);          a_ar(102) := NVL(l_pr_rec.ar102, l_default_ar);          a_ar(103) := NVL(l_pr_rec.ar103, l_default_ar);          a_ar(104) := NVL(l_pr_rec.ar104, l_default_ar);
         a_ar(105) := NVL(l_pr_rec.ar105, l_default_ar);          a_ar(106) := NVL(l_pr_rec.ar106, l_default_ar);          a_ar(107) := NVL(l_pr_rec.ar107, l_default_ar);          a_ar(108) := NVL(l_pr_rec.ar108, l_default_ar);
         a_ar(109) := NVL(l_pr_rec.ar109, l_default_ar);          a_ar(110) := NVL(l_pr_rec.ar110, l_default_ar);          a_ar(111) := NVL(l_pr_rec.ar111, l_default_ar);          a_ar(112) := NVL(l_pr_rec.ar112, l_default_ar);
         a_ar(113) := NVL(l_pr_rec.ar113, l_default_ar);          a_ar(114) := NVL(l_pr_rec.ar114, l_default_ar);          a_ar(115) := NVL(l_pr_rec.ar115, l_default_ar);          a_ar(116) := NVL(l_pr_rec.ar116, l_default_ar);
         a_ar(117) := NVL(l_pr_rec.ar117, l_default_ar);          a_ar(118) := NVL(l_pr_rec.ar118, l_default_ar);          a_ar(119) := NVL(l_pr_rec.ar119, l_default_ar);          a_ar(120) := NVL(l_pr_rec.ar120, l_default_ar);
         a_ar(121) := NVL(l_pr_rec.ar121, l_default_ar);          a_ar(122) := NVL(l_pr_rec.ar122, l_default_ar);          a_ar(123) := NVL(l_pr_rec.ar123, l_default_ar);          a_ar(124) := NVL(l_pr_rec.ar124, l_default_ar);
         a_ar(125) := NVL(l_pr_rec.ar125, l_default_ar);          a_ar(126) := NVL(l_pr_rec.ar126, l_default_ar);          a_ar(127) := NVL(l_pr_rec.ar127, l_default_ar);          a_ar(128) := NVL(l_pr_rec.ar128, l_default_ar);
         RETURN(Unapigen.DBERR_SUCCESS);
      END IF;
   ELSIF (a_object_tp = 'me') THEN
      OPEN l_inherit_mtar (a_object_id, UNAPIEV.P_MT_VERSION);
      FETCH l_inherit_mtar
      INTO l_mt_rec;
      l_found := l_inherit_mtar%FOUND;
      CLOSE l_inherit_mtar;

      IF l_found THEN
         a_ar(1)   := NVL(l_mt_rec.ar1,   l_default_ar);          a_ar(2)   := NVL(l_mt_rec.ar2,   l_default_ar);          a_ar(3)   := NVL(l_mt_rec.ar3,   l_default_ar);          a_ar(4)   := NVL(l_mt_rec.ar4,   l_default_ar);
         a_ar(5)   := NVL(l_mt_rec.ar5,   l_default_ar);          a_ar(6)   := NVL(l_mt_rec.ar6,   l_default_ar);          a_ar(7)   := NVL(l_mt_rec.ar7,   l_default_ar);          a_ar(8)   := NVL(l_mt_rec.ar8,   l_default_ar);
         a_ar(9)   := NVL(l_mt_rec.ar9,   l_default_ar);          a_ar(10)  := NVL(l_mt_rec.ar10,  l_default_ar);          a_ar(11)  := NVL(l_mt_rec.ar11,  l_default_ar);          a_ar(12)  := NVL(l_mt_rec.ar12,  l_default_ar);
         a_ar(13)  := NVL(l_mt_rec.ar13,  l_default_ar);          a_ar(14)  := NVL(l_mt_rec.ar14,  l_default_ar);          a_ar(15)  := NVL(l_mt_rec.ar15,  l_default_ar);          a_ar(16)  := NVL(l_mt_rec.ar16,  l_default_ar);
         a_ar(17)  := NVL(l_mt_rec.ar17,  l_default_ar);          a_ar(18)  := NVL(l_mt_rec.ar18,  l_default_ar);          a_ar(19)  := NVL(l_mt_rec.ar19,  l_default_ar);          a_ar(20)  := NVL(l_mt_rec.ar20,  l_default_ar);
         a_ar(21)  := NVL(l_mt_rec.ar21,  l_default_ar);          a_ar(22)  := NVL(l_mt_rec.ar22,  l_default_ar);          a_ar(23)  := NVL(l_mt_rec.ar23,  l_default_ar);          a_ar(24)  := NVL(l_mt_rec.ar24,  l_default_ar);
         a_ar(25)  := NVL(l_mt_rec.ar25,  l_default_ar);          a_ar(26)  := NVL(l_mt_rec.ar26,  l_default_ar);          a_ar(27)  := NVL(l_mt_rec.ar27,  l_default_ar);          a_ar(28)  := NVL(l_mt_rec.ar28,  l_default_ar);
         a_ar(29)  := NVL(l_mt_rec.ar29,  l_default_ar);          a_ar(30)  := NVL(l_mt_rec.ar30,  l_default_ar);          a_ar(31)  := NVL(l_mt_rec.ar31,  l_default_ar);          a_ar(32)  := NVL(l_mt_rec.ar32,  l_default_ar);
         a_ar(33)  := NVL(l_mt_rec.ar33,  l_default_ar);          a_ar(34)  := NVL(l_mt_rec.ar34,  l_default_ar);          a_ar(35)  := NVL(l_mt_rec.ar35,  l_default_ar);          a_ar(36)  := NVL(l_mt_rec.ar36,  l_default_ar);
         a_ar(37)  := NVL(l_mt_rec.ar37,  l_default_ar);          a_ar(38)  := NVL(l_mt_rec.ar38,  l_default_ar);          a_ar(39)  := NVL(l_mt_rec.ar39,  l_default_ar);          a_ar(40)  := NVL(l_mt_rec.ar40,  l_default_ar);
         a_ar(41)  := NVL(l_mt_rec.ar41,  l_default_ar);          a_ar(42)  := NVL(l_mt_rec.ar42,  l_default_ar);          a_ar(43)  := NVL(l_mt_rec.ar43,  l_default_ar);          a_ar(44)  := NVL(l_mt_rec.ar44,  l_default_ar);
         a_ar(45)  := NVL(l_mt_rec.ar45,  l_default_ar);          a_ar(46)  := NVL(l_mt_rec.ar46,  l_default_ar);          a_ar(47)  := NVL(l_mt_rec.ar47,  l_default_ar);          a_ar(48)  := NVL(l_mt_rec.ar48,  l_default_ar);
         a_ar(49)  := NVL(l_mt_rec.ar49,  l_default_ar);          a_ar(50)  := NVL(l_mt_rec.ar50,  l_default_ar);          a_ar(51)  := NVL(l_mt_rec.ar51,  l_default_ar);          a_ar(52)  := NVL(l_mt_rec.ar52,  l_default_ar);
         a_ar(53)  := NVL(l_mt_rec.ar53,  l_default_ar);          a_ar(54)  := NVL(l_mt_rec.ar54,  l_default_ar);          a_ar(55)  := NVL(l_mt_rec.ar55,  l_default_ar);          a_ar(56)  := NVL(l_mt_rec.ar56,  l_default_ar);
         a_ar(57)  := NVL(l_mt_rec.ar57,  l_default_ar);          a_ar(58)  := NVL(l_mt_rec.ar58,  l_default_ar);          a_ar(59)  := NVL(l_mt_rec.ar59,  l_default_ar);          a_ar(60)  := NVL(l_mt_rec.ar60,  l_default_ar);
         a_ar(61)  := NVL(l_mt_rec.ar61,  l_default_ar);          a_ar(62)  := NVL(l_mt_rec.ar62,  l_default_ar);          a_ar(63)  := NVL(l_mt_rec.ar63,  l_default_ar);          a_ar(64)  := NVL(l_mt_rec.ar64,  l_default_ar);
         a_ar(65)  := NVL(l_mt_rec.ar65,  l_default_ar);          a_ar(66)  := NVL(l_mt_rec.ar66,  l_default_ar);          a_ar(67)  := NVL(l_mt_rec.ar67,  l_default_ar);          a_ar(68)  := NVL(l_mt_rec.ar68,  l_default_ar);
         a_ar(69)  := NVL(l_mt_rec.ar69,  l_default_ar);          a_ar(70)  := NVL(l_mt_rec.ar70,  l_default_ar);          a_ar(71)  := NVL(l_mt_rec.ar71,  l_default_ar);          a_ar(72)  := NVL(l_mt_rec.ar72,  l_default_ar);
         a_ar(73)  := NVL(l_mt_rec.ar73,  l_default_ar);          a_ar(74)  := NVL(l_mt_rec.ar74,  l_default_ar);          a_ar(75)  := NVL(l_mt_rec.ar75,  l_default_ar);          a_ar(76)  := NVL(l_mt_rec.ar76,  l_default_ar);
         a_ar(77)  := NVL(l_mt_rec.ar77,  l_default_ar);          a_ar(78)  := NVL(l_mt_rec.ar78,  l_default_ar);          a_ar(79)  := NVL(l_mt_rec.ar79,  l_default_ar);          a_ar(80)  := NVL(l_mt_rec.ar80,  l_default_ar);
         a_ar(81)  := NVL(l_mt_rec.ar81,  l_default_ar);          a_ar(82)  := NVL(l_mt_rec.ar82,  l_default_ar);          a_ar(83)  := NVL(l_mt_rec.ar83,  l_default_ar);          a_ar(84)  := NVL(l_mt_rec.ar84,  l_default_ar);
         a_ar(85)  := NVL(l_mt_rec.ar85,  l_default_ar);          a_ar(86)  := NVL(l_mt_rec.ar86,  l_default_ar);          a_ar(87)  := NVL(l_mt_rec.ar87,  l_default_ar);          a_ar(88)  := NVL(l_mt_rec.ar88,  l_default_ar);
         a_ar(89)  := NVL(l_mt_rec.ar89,  l_default_ar);          a_ar(90)  := NVL(l_mt_rec.ar90,  l_default_ar);          a_ar(91)  := NVL(l_mt_rec.ar91,  l_default_ar);          a_ar(92)  := NVL(l_mt_rec.ar92,  l_default_ar);
         a_ar(93)  := NVL(l_mt_rec.ar93,  l_default_ar);          a_ar(94)  := NVL(l_mt_rec.ar94,  l_default_ar);          a_ar(95)  := NVL(l_mt_rec.ar95,  l_default_ar);          a_ar(96)  := NVL(l_mt_rec.ar96,  l_default_ar);
         a_ar(97)  := NVL(l_mt_rec.ar97,  l_default_ar);          a_ar(98)  := NVL(l_mt_rec.ar98,  l_default_ar);          a_ar(99)  := NVL(l_mt_rec.ar99,  l_default_ar);          a_ar(100) := NVL(l_mt_rec.ar100, l_default_ar);
         a_ar(101) := NVL(l_mt_rec.ar101, l_default_ar);          a_ar(102) := NVL(l_mt_rec.ar102, l_default_ar);          a_ar(103) := NVL(l_mt_rec.ar103, l_default_ar);          a_ar(104) := NVL(l_mt_rec.ar104, l_default_ar);
         a_ar(105) := NVL(l_mt_rec.ar105, l_default_ar);          a_ar(106) := NVL(l_mt_rec.ar106, l_default_ar);          a_ar(107) := NVL(l_mt_rec.ar107, l_default_ar);          a_ar(108) := NVL(l_mt_rec.ar108, l_default_ar);
         a_ar(109) := NVL(l_mt_rec.ar109, l_default_ar);          a_ar(110) := NVL(l_mt_rec.ar110, l_default_ar);          a_ar(111) := NVL(l_mt_rec.ar111, l_default_ar);          a_ar(112) := NVL(l_mt_rec.ar112, l_default_ar);
         a_ar(113) := NVL(l_mt_rec.ar113, l_default_ar);          a_ar(114) := NVL(l_mt_rec.ar114, l_default_ar);          a_ar(115) := NVL(l_mt_rec.ar115, l_default_ar);          a_ar(116) := NVL(l_mt_rec.ar116, l_default_ar);
         a_ar(117) := NVL(l_mt_rec.ar117, l_default_ar);          a_ar(118) := NVL(l_mt_rec.ar118, l_default_ar);          a_ar(119) := NVL(l_mt_rec.ar119, l_default_ar);          a_ar(120) := NVL(l_mt_rec.ar120, l_default_ar);
         a_ar(121) := NVL(l_mt_rec.ar121, l_default_ar);          a_ar(122) := NVL(l_mt_rec.ar122, l_default_ar);          a_ar(123) := NVL(l_mt_rec.ar123, l_default_ar);          a_ar(124) := NVL(l_mt_rec.ar124, l_default_ar);
         a_ar(125) := NVL(l_mt_rec.ar125, l_default_ar);          a_ar(126) := NVL(l_mt_rec.ar126, l_default_ar);          a_ar(127) := NVL(l_mt_rec.ar127, l_default_ar);          a_ar(128) := NVL(l_mt_rec.ar128, l_default_ar);
         RETURN(Unapigen.DBERR_SUCCESS);
      END IF;
   ELSIF (a_object_tp = 'rq') THEN
      OPEN l_inherit_rtar (a_object_id);
      FETCH l_inherit_rtar
      INTO l_rt_rec;
      l_found := l_inherit_rtar%FOUND;
      CLOSE l_inherit_rtar;

      IF l_found THEN
         a_ar(1)   := NVL(l_rt_rec.ar1,   l_default_ar);          a_ar(2)   := NVL(l_rt_rec.ar2,   l_default_ar);          a_ar(3)   := NVL(l_rt_rec.ar3,   l_default_ar);          a_ar(4)   := NVL(l_rt_rec.ar4,   l_default_ar);
         a_ar(5)   := NVL(l_rt_rec.ar5,   l_default_ar);          a_ar(6)   := NVL(l_rt_rec.ar6,   l_default_ar);          a_ar(7)   := NVL(l_rt_rec.ar7,   l_default_ar);          a_ar(8)   := NVL(l_rt_rec.ar8,   l_default_ar);
         a_ar(9)   := NVL(l_rt_rec.ar9,   l_default_ar);          a_ar(10)  := NVL(l_rt_rec.ar10,  l_default_ar);          a_ar(11)  := NVL(l_rt_rec.ar11,  l_default_ar);          a_ar(12)  := NVL(l_rt_rec.ar12,  l_default_ar);
         a_ar(13)  := NVL(l_rt_rec.ar13,  l_default_ar);          a_ar(14)  := NVL(l_rt_rec.ar14,  l_default_ar);          a_ar(15)  := NVL(l_rt_rec.ar15,  l_default_ar);          a_ar(16)  := NVL(l_rt_rec.ar16,  l_default_ar);
         a_ar(17)  := NVL(l_rt_rec.ar17,  l_default_ar);          a_ar(18)  := NVL(l_rt_rec.ar18,  l_default_ar);          a_ar(19)  := NVL(l_rt_rec.ar19,  l_default_ar);          a_ar(20)  := NVL(l_rt_rec.ar20,  l_default_ar);
         a_ar(21)  := NVL(l_rt_rec.ar21,  l_default_ar);          a_ar(22)  := NVL(l_rt_rec.ar22,  l_default_ar);          a_ar(23)  := NVL(l_rt_rec.ar23,  l_default_ar);          a_ar(24)  := NVL(l_rt_rec.ar24,  l_default_ar);
         a_ar(25)  := NVL(l_rt_rec.ar25,  l_default_ar);          a_ar(26)  := NVL(l_rt_rec.ar26,  l_default_ar);          a_ar(27)  := NVL(l_rt_rec.ar27,  l_default_ar);          a_ar(28)  := NVL(l_rt_rec.ar28,  l_default_ar);
         a_ar(29)  := NVL(l_rt_rec.ar29,  l_default_ar);          a_ar(30)  := NVL(l_rt_rec.ar30,  l_default_ar);          a_ar(31)  := NVL(l_rt_rec.ar31,  l_default_ar);          a_ar(32)  := NVL(l_rt_rec.ar32,  l_default_ar);
         a_ar(33)  := NVL(l_rt_rec.ar33,  l_default_ar);          a_ar(34)  := NVL(l_rt_rec.ar34,  l_default_ar);          a_ar(35)  := NVL(l_rt_rec.ar35,  l_default_ar);          a_ar(36)  := NVL(l_rt_rec.ar36,  l_default_ar);
         a_ar(37)  := NVL(l_rt_rec.ar37,  l_default_ar);          a_ar(38)  := NVL(l_rt_rec.ar38,  l_default_ar);          a_ar(39)  := NVL(l_rt_rec.ar39,  l_default_ar);          a_ar(40)  := NVL(l_rt_rec.ar40,  l_default_ar);
         a_ar(41)  := NVL(l_rt_rec.ar41,  l_default_ar);          a_ar(42)  := NVL(l_rt_rec.ar42,  l_default_ar);          a_ar(43)  := NVL(l_rt_rec.ar43,  l_default_ar);          a_ar(44)  := NVL(l_rt_rec.ar44,  l_default_ar);
         a_ar(45)  := NVL(l_rt_rec.ar45,  l_default_ar);          a_ar(46)  := NVL(l_rt_rec.ar46,  l_default_ar);          a_ar(47)  := NVL(l_rt_rec.ar47,  l_default_ar);          a_ar(48)  := NVL(l_rt_rec.ar48,  l_default_ar);
         a_ar(49)  := NVL(l_rt_rec.ar49,  l_default_ar);          a_ar(50)  := NVL(l_rt_rec.ar50,  l_default_ar);          a_ar(51)  := NVL(l_rt_rec.ar51,  l_default_ar);          a_ar(52)  := NVL(l_rt_rec.ar52,  l_default_ar);
         a_ar(53)  := NVL(l_rt_rec.ar53,  l_default_ar);          a_ar(54)  := NVL(l_rt_rec.ar54,  l_default_ar);          a_ar(55)  := NVL(l_rt_rec.ar55,  l_default_ar);          a_ar(56)  := NVL(l_rt_rec.ar56,  l_default_ar);
         a_ar(57)  := NVL(l_rt_rec.ar57,  l_default_ar);          a_ar(58)  := NVL(l_rt_rec.ar58,  l_default_ar);          a_ar(59)  := NVL(l_rt_rec.ar59,  l_default_ar);          a_ar(60)  := NVL(l_rt_rec.ar60,  l_default_ar);
         a_ar(61)  := NVL(l_rt_rec.ar61,  l_default_ar);          a_ar(62)  := NVL(l_rt_rec.ar62,  l_default_ar);          a_ar(63)  := NVL(l_rt_rec.ar63,  l_default_ar);          a_ar(64)  := NVL(l_rt_rec.ar64,  l_default_ar);
         a_ar(65)  := NVL(l_rt_rec.ar65,  l_default_ar);          a_ar(66)  := NVL(l_rt_rec.ar66,  l_default_ar);          a_ar(67)  := NVL(l_rt_rec.ar67,  l_default_ar);          a_ar(68)  := NVL(l_rt_rec.ar68,  l_default_ar);
         a_ar(69)  := NVL(l_rt_rec.ar69,  l_default_ar);          a_ar(70)  := NVL(l_rt_rec.ar70,  l_default_ar);          a_ar(71)  := NVL(l_rt_rec.ar71,  l_default_ar);          a_ar(72)  := NVL(l_rt_rec.ar72,  l_default_ar);
         a_ar(73)  := NVL(l_rt_rec.ar73,  l_default_ar);          a_ar(74)  := NVL(l_rt_rec.ar74,  l_default_ar);          a_ar(75)  := NVL(l_rt_rec.ar75,  l_default_ar);          a_ar(76)  := NVL(l_rt_rec.ar76,  l_default_ar);
         a_ar(77)  := NVL(l_rt_rec.ar77,  l_default_ar);          a_ar(78)  := NVL(l_rt_rec.ar78,  l_default_ar);          a_ar(79)  := NVL(l_rt_rec.ar79,  l_default_ar);          a_ar(80)  := NVL(l_rt_rec.ar80,  l_default_ar);
         a_ar(81)  := NVL(l_rt_rec.ar81,  l_default_ar);          a_ar(82)  := NVL(l_rt_rec.ar82,  l_default_ar);          a_ar(83)  := NVL(l_rt_rec.ar83,  l_default_ar);          a_ar(84)  := NVL(l_rt_rec.ar84,  l_default_ar);
         a_ar(85)  := NVL(l_rt_rec.ar85,  l_default_ar);          a_ar(86)  := NVL(l_rt_rec.ar86,  l_default_ar);          a_ar(87)  := NVL(l_rt_rec.ar87,  l_default_ar);          a_ar(88)  := NVL(l_rt_rec.ar88,  l_default_ar);
         a_ar(89)  := NVL(l_rt_rec.ar89,  l_default_ar);          a_ar(90)  := NVL(l_rt_rec.ar90,  l_default_ar);          a_ar(91)  := NVL(l_rt_rec.ar91,  l_default_ar);          a_ar(92)  := NVL(l_rt_rec.ar92,  l_default_ar);
         a_ar(93)  := NVL(l_rt_rec.ar93,  l_default_ar);          a_ar(94)  := NVL(l_rt_rec.ar94,  l_default_ar);          a_ar(95)  := NVL(l_rt_rec.ar95,  l_default_ar);          a_ar(96)  := NVL(l_rt_rec.ar96,  l_default_ar);
         a_ar(97)  := NVL(l_rt_rec.ar97,  l_default_ar);          a_ar(98)  := NVL(l_rt_rec.ar98,  l_default_ar);          a_ar(99)  := NVL(l_rt_rec.ar99,  l_default_ar);          a_ar(100) := NVL(l_rt_rec.ar100, l_default_ar);
         a_ar(101) := NVL(l_rt_rec.ar101, l_default_ar);          a_ar(102) := NVL(l_rt_rec.ar102, l_default_ar);          a_ar(103) := NVL(l_rt_rec.ar103, l_default_ar);          a_ar(104) := NVL(l_rt_rec.ar104, l_default_ar);
         a_ar(105) := NVL(l_rt_rec.ar105, l_default_ar);          a_ar(106) := NVL(l_rt_rec.ar106, l_default_ar);          a_ar(107) := NVL(l_rt_rec.ar107, l_default_ar);          a_ar(108) := NVL(l_rt_rec.ar108, l_default_ar);
         a_ar(109) := NVL(l_rt_rec.ar109, l_default_ar);          a_ar(110) := NVL(l_rt_rec.ar110, l_default_ar);          a_ar(111) := NVL(l_rt_rec.ar111, l_default_ar);          a_ar(112) := NVL(l_rt_rec.ar112, l_default_ar);
         a_ar(113) := NVL(l_rt_rec.ar113, l_default_ar);          a_ar(114) := NVL(l_rt_rec.ar114, l_default_ar);          a_ar(115) := NVL(l_rt_rec.ar115, l_default_ar);          a_ar(116) := NVL(l_rt_rec.ar116, l_default_ar);
         a_ar(117) := NVL(l_rt_rec.ar117, l_default_ar);          a_ar(118) := NVL(l_rt_rec.ar118, l_default_ar);          a_ar(119) := NVL(l_rt_rec.ar119, l_default_ar);          a_ar(120) := NVL(l_rt_rec.ar120, l_default_ar);
         a_ar(121) := NVL(l_rt_rec.ar121, l_default_ar);          a_ar(122) := NVL(l_rt_rec.ar122, l_default_ar);          a_ar(123) := NVL(l_rt_rec.ar123, l_default_ar);          a_ar(124) := NVL(l_rt_rec.ar124, l_default_ar);
         a_ar(125) := NVL(l_rt_rec.ar125, l_default_ar);          a_ar(126) := NVL(l_rt_rec.ar126, l_default_ar);          a_ar(127) := NVL(l_rt_rec.ar127, l_default_ar);          a_ar(128) := NVL(l_rt_rec.ar128, l_default_ar);
         RETURN(Unapigen.DBERR_SUCCESS);
      END IF;
   ELSIF (a_object_tp = 'sd') THEN
      OPEN l_inherit_ptar (a_object_id);
      FETCH l_inherit_ptar
      INTO l_pt_rec;
      l_found := l_inherit_ptar%FOUND;
      CLOSE l_inherit_ptar;

      IF l_found THEN
         a_ar(1)   := NVL(l_pt_rec.ar1,   l_default_ar);          a_ar(2)   := NVL(l_pt_rec.ar2,   l_default_ar);          a_ar(3)   := NVL(l_pt_rec.ar3,   l_default_ar);          a_ar(4)   := NVL(l_pt_rec.ar4,   l_default_ar);
         a_ar(5)   := NVL(l_pt_rec.ar5,   l_default_ar);          a_ar(6)   := NVL(l_pt_rec.ar6,   l_default_ar);          a_ar(7)   := NVL(l_pt_rec.ar7,   l_default_ar);          a_ar(8)   := NVL(l_pt_rec.ar8,   l_default_ar);
         a_ar(9)   := NVL(l_pt_rec.ar9,   l_default_ar);          a_ar(10)  := NVL(l_pt_rec.ar10,  l_default_ar);          a_ar(11)  := NVL(l_pt_rec.ar11,  l_default_ar);          a_ar(12)  := NVL(l_pt_rec.ar12,  l_default_ar);
         a_ar(13)  := NVL(l_pt_rec.ar13,  l_default_ar);          a_ar(14)  := NVL(l_pt_rec.ar14,  l_default_ar);          a_ar(15)  := NVL(l_pt_rec.ar15,  l_default_ar);          a_ar(16)  := NVL(l_pt_rec.ar16,  l_default_ar);
         a_ar(17)  := NVL(l_pt_rec.ar17,  l_default_ar);          a_ar(18)  := NVL(l_pt_rec.ar18,  l_default_ar);          a_ar(19)  := NVL(l_pt_rec.ar19,  l_default_ar);          a_ar(20)  := NVL(l_pt_rec.ar20,  l_default_ar);
         a_ar(21)  := NVL(l_pt_rec.ar21,  l_default_ar);          a_ar(22)  := NVL(l_pt_rec.ar22,  l_default_ar);          a_ar(23)  := NVL(l_pt_rec.ar23,  l_default_ar);          a_ar(24)  := NVL(l_pt_rec.ar24,  l_default_ar);
         a_ar(25)  := NVL(l_pt_rec.ar25,  l_default_ar);          a_ar(26)  := NVL(l_pt_rec.ar26,  l_default_ar);          a_ar(27)  := NVL(l_pt_rec.ar27,  l_default_ar);          a_ar(28)  := NVL(l_pt_rec.ar28,  l_default_ar);
         a_ar(29)  := NVL(l_pt_rec.ar29,  l_default_ar);          a_ar(30)  := NVL(l_pt_rec.ar30,  l_default_ar);          a_ar(31)  := NVL(l_pt_rec.ar31,  l_default_ar);          a_ar(32)  := NVL(l_pt_rec.ar32,  l_default_ar);
         a_ar(33)  := NVL(l_pt_rec.ar33,  l_default_ar);          a_ar(34)  := NVL(l_pt_rec.ar34,  l_default_ar);          a_ar(35)  := NVL(l_pt_rec.ar35,  l_default_ar);          a_ar(36)  := NVL(l_pt_rec.ar36,  l_default_ar);
         a_ar(37)  := NVL(l_pt_rec.ar37,  l_default_ar);          a_ar(38)  := NVL(l_pt_rec.ar38,  l_default_ar);          a_ar(39)  := NVL(l_pt_rec.ar39,  l_default_ar);          a_ar(40)  := NVL(l_pt_rec.ar40,  l_default_ar);
         a_ar(41)  := NVL(l_pt_rec.ar41,  l_default_ar);          a_ar(42)  := NVL(l_pt_rec.ar42,  l_default_ar);          a_ar(43)  := NVL(l_pt_rec.ar43,  l_default_ar);          a_ar(44)  := NVL(l_pt_rec.ar44,  l_default_ar);
         a_ar(45)  := NVL(l_pt_rec.ar45,  l_default_ar);          a_ar(46)  := NVL(l_pt_rec.ar46,  l_default_ar);          a_ar(47)  := NVL(l_pt_rec.ar47,  l_default_ar);          a_ar(48)  := NVL(l_pt_rec.ar48,  l_default_ar);
         a_ar(49)  := NVL(l_pt_rec.ar49,  l_default_ar);          a_ar(50)  := NVL(l_pt_rec.ar50,  l_default_ar);          a_ar(51)  := NVL(l_pt_rec.ar51,  l_default_ar);          a_ar(52)  := NVL(l_pt_rec.ar52,  l_default_ar);
         a_ar(53)  := NVL(l_pt_rec.ar53,  l_default_ar);          a_ar(54)  := NVL(l_pt_rec.ar54,  l_default_ar);          a_ar(55)  := NVL(l_pt_rec.ar55,  l_default_ar);          a_ar(56)  := NVL(l_pt_rec.ar56,  l_default_ar);
         a_ar(57)  := NVL(l_pt_rec.ar57,  l_default_ar);          a_ar(58)  := NVL(l_pt_rec.ar58,  l_default_ar);          a_ar(59)  := NVL(l_pt_rec.ar59,  l_default_ar);          a_ar(60)  := NVL(l_pt_rec.ar60,  l_default_ar);
         a_ar(61)  := NVL(l_pt_rec.ar61,  l_default_ar);          a_ar(62)  := NVL(l_pt_rec.ar62,  l_default_ar);          a_ar(63)  := NVL(l_pt_rec.ar63,  l_default_ar);          a_ar(64)  := NVL(l_pt_rec.ar64,  l_default_ar);
         a_ar(65)  := NVL(l_pt_rec.ar65,  l_default_ar);          a_ar(66)  := NVL(l_pt_rec.ar66,  l_default_ar);          a_ar(67)  := NVL(l_pt_rec.ar67,  l_default_ar);          a_ar(68)  := NVL(l_pt_rec.ar68,  l_default_ar);
         a_ar(69)  := NVL(l_pt_rec.ar69,  l_default_ar);          a_ar(70)  := NVL(l_pt_rec.ar70,  l_default_ar);          a_ar(71)  := NVL(l_pt_rec.ar71,  l_default_ar);          a_ar(72)  := NVL(l_pt_rec.ar72,  l_default_ar);
         a_ar(73)  := NVL(l_pt_rec.ar73,  l_default_ar);          a_ar(74)  := NVL(l_pt_rec.ar74,  l_default_ar);          a_ar(75)  := NVL(l_pt_rec.ar75,  l_default_ar);          a_ar(76)  := NVL(l_pt_rec.ar76,  l_default_ar);
         a_ar(77)  := NVL(l_pt_rec.ar77,  l_default_ar);          a_ar(78)  := NVL(l_pt_rec.ar78,  l_default_ar);          a_ar(79)  := NVL(l_pt_rec.ar79,  l_default_ar);          a_ar(80)  := NVL(l_pt_rec.ar80,  l_default_ar);
         a_ar(81)  := NVL(l_pt_rec.ar81,  l_default_ar);          a_ar(82)  := NVL(l_pt_rec.ar82,  l_default_ar);          a_ar(83)  := NVL(l_pt_rec.ar83,  l_default_ar);          a_ar(84)  := NVL(l_pt_rec.ar84,  l_default_ar);
         a_ar(85)  := NVL(l_pt_rec.ar85,  l_default_ar);          a_ar(86)  := NVL(l_pt_rec.ar86,  l_default_ar);          a_ar(87)  := NVL(l_pt_rec.ar87,  l_default_ar);          a_ar(88)  := NVL(l_pt_rec.ar88,  l_default_ar);
         a_ar(89)  := NVL(l_pt_rec.ar89,  l_default_ar);          a_ar(90)  := NVL(l_pt_rec.ar90,  l_default_ar);          a_ar(91)  := NVL(l_pt_rec.ar91,  l_default_ar);          a_ar(92)  := NVL(l_pt_rec.ar92,  l_default_ar);
         a_ar(93)  := NVL(l_pt_rec.ar93,  l_default_ar);          a_ar(94)  := NVL(l_pt_rec.ar94,  l_default_ar);          a_ar(95)  := NVL(l_pt_rec.ar95,  l_default_ar);          a_ar(96)  := NVL(l_pt_rec.ar96,  l_default_ar);
         a_ar(97)  := NVL(l_pt_rec.ar97,  l_default_ar);          a_ar(98)  := NVL(l_pt_rec.ar98,  l_default_ar);          a_ar(99)  := NVL(l_pt_rec.ar99,  l_default_ar);          a_ar(100) := NVL(l_pt_rec.ar100, l_default_ar);
         a_ar(101) := NVL(l_pt_rec.ar101, l_default_ar);          a_ar(102) := NVL(l_pt_rec.ar102, l_default_ar);          a_ar(103) := NVL(l_pt_rec.ar103, l_default_ar);          a_ar(104) := NVL(l_pt_rec.ar104, l_default_ar);
         a_ar(105) := NVL(l_pt_rec.ar105, l_default_ar);          a_ar(106) := NVL(l_pt_rec.ar106, l_default_ar);          a_ar(107) := NVL(l_pt_rec.ar107, l_default_ar);          a_ar(108) := NVL(l_pt_rec.ar108, l_default_ar);
         a_ar(109) := NVL(l_pt_rec.ar109, l_default_ar);          a_ar(110) := NVL(l_pt_rec.ar110, l_default_ar);          a_ar(111) := NVL(l_pt_rec.ar111, l_default_ar);          a_ar(112) := NVL(l_pt_rec.ar112, l_default_ar);
         a_ar(113) := NVL(l_pt_rec.ar113, l_default_ar);          a_ar(114) := NVL(l_pt_rec.ar114, l_default_ar);          a_ar(115) := NVL(l_pt_rec.ar115, l_default_ar);          a_ar(116) := NVL(l_pt_rec.ar116, l_default_ar);
         a_ar(117) := NVL(l_pt_rec.ar117, l_default_ar);          a_ar(118) := NVL(l_pt_rec.ar118, l_default_ar);          a_ar(119) := NVL(l_pt_rec.ar119, l_default_ar);          a_ar(120) := NVL(l_pt_rec.ar120, l_default_ar);
         a_ar(121) := NVL(l_pt_rec.ar121, l_default_ar);          a_ar(122) := NVL(l_pt_rec.ar122, l_default_ar);          a_ar(123) := NVL(l_pt_rec.ar123, l_default_ar);          a_ar(124) := NVL(l_pt_rec.ar124, l_default_ar);
         a_ar(125) := NVL(l_pt_rec.ar125, l_default_ar);          a_ar(126) := NVL(l_pt_rec.ar126, l_default_ar);          a_ar(127) := NVL(l_pt_rec.ar127, l_default_ar);          a_ar(128) := NVL(l_pt_rec.ar128, l_default_ar);
         RETURN(Unapigen.DBERR_SUCCESS);
      END IF;
   ELSIF (a_object_tp = 'ws') THEN
      OPEN l_inherit_wtar (a_object_id);
      FETCH l_inherit_wtar
      INTO l_wt_rec;
      l_found := l_inherit_wtar%FOUND;
      CLOSE l_inherit_wtar;

      IF l_found THEN
         a_ar(1)   := NVL(l_wt_rec.ar1,   l_default_ar);          a_ar(2)   := NVL(l_wt_rec.ar2,   l_default_ar);          a_ar(3)   := NVL(l_wt_rec.ar3,   l_default_ar);          a_ar(4)   := NVL(l_wt_rec.ar4,   l_default_ar);
         a_ar(5)   := NVL(l_wt_rec.ar5,   l_default_ar);          a_ar(6)   := NVL(l_wt_rec.ar6,   l_default_ar);          a_ar(7)   := NVL(l_wt_rec.ar7,   l_default_ar);          a_ar(8)   := NVL(l_wt_rec.ar8,   l_default_ar);
         a_ar(9)   := NVL(l_wt_rec.ar9,   l_default_ar);          a_ar(10)  := NVL(l_wt_rec.ar10,  l_default_ar);          a_ar(11)  := NVL(l_wt_rec.ar11,  l_default_ar);          a_ar(12)  := NVL(l_wt_rec.ar12,  l_default_ar);
         a_ar(13)  := NVL(l_wt_rec.ar13,  l_default_ar);          a_ar(14)  := NVL(l_wt_rec.ar14,  l_default_ar);          a_ar(15)  := NVL(l_wt_rec.ar15,  l_default_ar);          a_ar(16)  := NVL(l_wt_rec.ar16,  l_default_ar);
         a_ar(17)  := NVL(l_wt_rec.ar17,  l_default_ar);          a_ar(18)  := NVL(l_wt_rec.ar18,  l_default_ar);          a_ar(19)  := NVL(l_wt_rec.ar19,  l_default_ar);          a_ar(20)  := NVL(l_wt_rec.ar20,  l_default_ar);
         a_ar(21)  := NVL(l_wt_rec.ar21,  l_default_ar);          a_ar(22)  := NVL(l_wt_rec.ar22,  l_default_ar);          a_ar(23)  := NVL(l_wt_rec.ar23,  l_default_ar);          a_ar(24)  := NVL(l_wt_rec.ar24,  l_default_ar);
         a_ar(25)  := NVL(l_wt_rec.ar25,  l_default_ar);          a_ar(26)  := NVL(l_wt_rec.ar26,  l_default_ar);          a_ar(27)  := NVL(l_wt_rec.ar27,  l_default_ar);          a_ar(28)  := NVL(l_wt_rec.ar28,  l_default_ar);
         a_ar(29)  := NVL(l_wt_rec.ar29,  l_default_ar);          a_ar(30)  := NVL(l_wt_rec.ar30,  l_default_ar);          a_ar(31)  := NVL(l_wt_rec.ar31,  l_default_ar);          a_ar(32)  := NVL(l_wt_rec.ar32,  l_default_ar);
         a_ar(33)  := NVL(l_wt_rec.ar33,  l_default_ar);          a_ar(34)  := NVL(l_wt_rec.ar34,  l_default_ar);          a_ar(35)  := NVL(l_wt_rec.ar35,  l_default_ar);          a_ar(36)  := NVL(l_wt_rec.ar36,  l_default_ar);
         a_ar(37)  := NVL(l_wt_rec.ar37,  l_default_ar);          a_ar(38)  := NVL(l_wt_rec.ar38,  l_default_ar);          a_ar(39)  := NVL(l_wt_rec.ar39,  l_default_ar);          a_ar(40)  := NVL(l_wt_rec.ar40,  l_default_ar);
         a_ar(41)  := NVL(l_wt_rec.ar41,  l_default_ar);          a_ar(42)  := NVL(l_wt_rec.ar42,  l_default_ar);          a_ar(43)  := NVL(l_wt_rec.ar43,  l_default_ar);          a_ar(44)  := NVL(l_wt_rec.ar44,  l_default_ar);
         a_ar(45)  := NVL(l_wt_rec.ar45,  l_default_ar);          a_ar(46)  := NVL(l_wt_rec.ar46,  l_default_ar);          a_ar(47)  := NVL(l_wt_rec.ar47,  l_default_ar);          a_ar(48)  := NVL(l_wt_rec.ar48,  l_default_ar);
         a_ar(49)  := NVL(l_wt_rec.ar49,  l_default_ar);          a_ar(50)  := NVL(l_wt_rec.ar50,  l_default_ar);          a_ar(51)  := NVL(l_wt_rec.ar51,  l_default_ar);          a_ar(52)  := NVL(l_wt_rec.ar52,  l_default_ar);
         a_ar(53)  := NVL(l_wt_rec.ar53,  l_default_ar);          a_ar(54)  := NVL(l_wt_rec.ar54,  l_default_ar);          a_ar(55)  := NVL(l_wt_rec.ar55,  l_default_ar);          a_ar(56)  := NVL(l_wt_rec.ar56,  l_default_ar);
         a_ar(57)  := NVL(l_wt_rec.ar57,  l_default_ar);          a_ar(58)  := NVL(l_wt_rec.ar58,  l_default_ar);          a_ar(59)  := NVL(l_wt_rec.ar59,  l_default_ar);          a_ar(60)  := NVL(l_wt_rec.ar60,  l_default_ar);
         a_ar(61)  := NVL(l_wt_rec.ar61,  l_default_ar);          a_ar(62)  := NVL(l_wt_rec.ar62,  l_default_ar);          a_ar(63)  := NVL(l_wt_rec.ar63,  l_default_ar);          a_ar(64)  := NVL(l_wt_rec.ar64,  l_default_ar);
         a_ar(65)  := NVL(l_wt_rec.ar65,  l_default_ar);          a_ar(66)  := NVL(l_wt_rec.ar66,  l_default_ar);          a_ar(67)  := NVL(l_wt_rec.ar67,  l_default_ar);          a_ar(68)  := NVL(l_wt_rec.ar68,  l_default_ar);
         a_ar(69)  := NVL(l_wt_rec.ar69,  l_default_ar);          a_ar(70)  := NVL(l_wt_rec.ar70,  l_default_ar);          a_ar(71)  := NVL(l_wt_rec.ar71,  l_default_ar);          a_ar(72)  := NVL(l_wt_rec.ar72,  l_default_ar);
         a_ar(73)  := NVL(l_wt_rec.ar73,  l_default_ar);          a_ar(74)  := NVL(l_wt_rec.ar74,  l_default_ar);          a_ar(75)  := NVL(l_wt_rec.ar75,  l_default_ar);          a_ar(76)  := NVL(l_wt_rec.ar76,  l_default_ar);
         a_ar(77)  := NVL(l_wt_rec.ar77,  l_default_ar);          a_ar(78)  := NVL(l_wt_rec.ar78,  l_default_ar);          a_ar(79)  := NVL(l_wt_rec.ar79,  l_default_ar);          a_ar(80)  := NVL(l_wt_rec.ar80,  l_default_ar);
         a_ar(81)  := NVL(l_wt_rec.ar81,  l_default_ar);          a_ar(82)  := NVL(l_wt_rec.ar82,  l_default_ar);          a_ar(83)  := NVL(l_wt_rec.ar83,  l_default_ar);          a_ar(84)  := NVL(l_wt_rec.ar84,  l_default_ar);
         a_ar(85)  := NVL(l_wt_rec.ar85,  l_default_ar);          a_ar(86)  := NVL(l_wt_rec.ar86,  l_default_ar);          a_ar(87)  := NVL(l_wt_rec.ar87,  l_default_ar);          a_ar(88)  := NVL(l_wt_rec.ar88,  l_default_ar);
         a_ar(89)  := NVL(l_wt_rec.ar89,  l_default_ar);          a_ar(90)  := NVL(l_wt_rec.ar90,  l_default_ar);          a_ar(91)  := NVL(l_wt_rec.ar91,  l_default_ar);          a_ar(92)  := NVL(l_wt_rec.ar92,  l_default_ar);
         a_ar(93)  := NVL(l_wt_rec.ar93,  l_default_ar);          a_ar(94)  := NVL(l_wt_rec.ar94,  l_default_ar);          a_ar(95)  := NVL(l_wt_rec.ar95,  l_default_ar);          a_ar(96)  := NVL(l_wt_rec.ar96,  l_default_ar);
         a_ar(97)  := NVL(l_wt_rec.ar97,  l_default_ar);          a_ar(98)  := NVL(l_wt_rec.ar98,  l_default_ar);          a_ar(99)  := NVL(l_wt_rec.ar99,  l_default_ar);          a_ar(100) := NVL(l_wt_rec.ar100, l_default_ar);
         a_ar(101) := NVL(l_wt_rec.ar101, l_default_ar);          a_ar(102) := NVL(l_wt_rec.ar102, l_default_ar);          a_ar(103) := NVL(l_wt_rec.ar103, l_default_ar);          a_ar(104) := NVL(l_wt_rec.ar104, l_default_ar);
         a_ar(105) := NVL(l_wt_rec.ar105, l_default_ar);          a_ar(106) := NVL(l_wt_rec.ar106, l_default_ar);          a_ar(107) := NVL(l_wt_rec.ar107, l_default_ar);          a_ar(108) := NVL(l_wt_rec.ar108, l_default_ar);
         a_ar(109) := NVL(l_wt_rec.ar109, l_default_ar);          a_ar(110) := NVL(l_wt_rec.ar110, l_default_ar);          a_ar(111) := NVL(l_wt_rec.ar111, l_default_ar);          a_ar(112) := NVL(l_wt_rec.ar112, l_default_ar);
         a_ar(113) := NVL(l_wt_rec.ar113, l_default_ar);          a_ar(114) := NVL(l_wt_rec.ar114, l_default_ar);          a_ar(115) := NVL(l_wt_rec.ar115, l_default_ar);          a_ar(116) := NVL(l_wt_rec.ar116, l_default_ar);
         a_ar(117) := NVL(l_wt_rec.ar117, l_default_ar);          a_ar(118) := NVL(l_wt_rec.ar118, l_default_ar);          a_ar(119) := NVL(l_wt_rec.ar119, l_default_ar);          a_ar(120) := NVL(l_wt_rec.ar120, l_default_ar);
         a_ar(121) := NVL(l_wt_rec.ar121, l_default_ar);          a_ar(122) := NVL(l_wt_rec.ar122, l_default_ar);          a_ar(123) := NVL(l_wt_rec.ar123, l_default_ar);          a_ar(124) := NVL(l_wt_rec.ar124, l_default_ar);
         a_ar(125) := NVL(l_wt_rec.ar125, l_default_ar);          a_ar(126) := NVL(l_wt_rec.ar126, l_default_ar);          a_ar(127) := NVL(l_wt_rec.ar127, l_default_ar);          a_ar(128) := NVL(l_wt_rec.ar128, l_default_ar);
         RETURN(Unapigen.DBERR_SUCCESS);
      END IF;
   ELSIF (a_object_tp = 'ch') THEN
      OPEN l_inherit_cyar (a_object_id);
      FETCH l_inherit_cyar
      INTO l_cy_rec;
      l_found := l_inherit_cyar%FOUND;
      CLOSE l_inherit_cyar;

      IF l_found THEN
         a_ar(1)   := NVL(l_cy_rec.ar1,   l_default_ar);          a_ar(2)   := NVL(l_cy_rec.ar2,   l_default_ar);          a_ar(3)   := NVL(l_cy_rec.ar3,   l_default_ar);          a_ar(4)   := NVL(l_cy_rec.ar4,   l_default_ar);
         a_ar(5)   := NVL(l_cy_rec.ar5,   l_default_ar);          a_ar(6)   := NVL(l_cy_rec.ar6,   l_default_ar);          a_ar(7)   := NVL(l_cy_rec.ar7,   l_default_ar);          a_ar(8)   := NVL(l_cy_rec.ar8,   l_default_ar);
         a_ar(9)   := NVL(l_cy_rec.ar9,   l_default_ar);          a_ar(10)  := NVL(l_cy_rec.ar10,  l_default_ar);          a_ar(11)  := NVL(l_cy_rec.ar11,  l_default_ar);          a_ar(12)  := NVL(l_cy_rec.ar12,  l_default_ar);
         a_ar(13)  := NVL(l_cy_rec.ar13,  l_default_ar);          a_ar(14)  := NVL(l_cy_rec.ar14,  l_default_ar);          a_ar(15)  := NVL(l_cy_rec.ar15,  l_default_ar);          a_ar(16)  := NVL(l_cy_rec.ar16,  l_default_ar);
         a_ar(17)  := NVL(l_cy_rec.ar17,  l_default_ar);          a_ar(18)  := NVL(l_cy_rec.ar18,  l_default_ar);          a_ar(19)  := NVL(l_cy_rec.ar19,  l_default_ar);          a_ar(20)  := NVL(l_cy_rec.ar20,  l_default_ar);
         a_ar(21)  := NVL(l_cy_rec.ar21,  l_default_ar);          a_ar(22)  := NVL(l_cy_rec.ar22,  l_default_ar);          a_ar(23)  := NVL(l_cy_rec.ar23,  l_default_ar);          a_ar(24)  := NVL(l_cy_rec.ar24,  l_default_ar);
         a_ar(25)  := NVL(l_cy_rec.ar25,  l_default_ar);          a_ar(26)  := NVL(l_cy_rec.ar26,  l_default_ar);          a_ar(27)  := NVL(l_cy_rec.ar27,  l_default_ar);          a_ar(28)  := NVL(l_cy_rec.ar28,  l_default_ar);
         a_ar(29)  := NVL(l_cy_rec.ar29,  l_default_ar);          a_ar(30)  := NVL(l_cy_rec.ar30,  l_default_ar);          a_ar(31)  := NVL(l_cy_rec.ar31,  l_default_ar);          a_ar(32)  := NVL(l_cy_rec.ar32,  l_default_ar);
         a_ar(33)  := NVL(l_cy_rec.ar33,  l_default_ar);          a_ar(34)  := NVL(l_cy_rec.ar34,  l_default_ar);          a_ar(35)  := NVL(l_cy_rec.ar35,  l_default_ar);          a_ar(36)  := NVL(l_cy_rec.ar36,  l_default_ar);
         a_ar(37)  := NVL(l_cy_rec.ar37,  l_default_ar);          a_ar(38)  := NVL(l_cy_rec.ar38,  l_default_ar);          a_ar(39)  := NVL(l_cy_rec.ar39,  l_default_ar);          a_ar(40)  := NVL(l_cy_rec.ar40,  l_default_ar);
         a_ar(41)  := NVL(l_cy_rec.ar41,  l_default_ar);          a_ar(42)  := NVL(l_cy_rec.ar42,  l_default_ar);          a_ar(43)  := NVL(l_cy_rec.ar43,  l_default_ar);          a_ar(44)  := NVL(l_cy_rec.ar44,  l_default_ar);
         a_ar(45)  := NVL(l_cy_rec.ar45,  l_default_ar);          a_ar(46)  := NVL(l_cy_rec.ar46,  l_default_ar);          a_ar(47)  := NVL(l_cy_rec.ar47,  l_default_ar);          a_ar(48)  := NVL(l_cy_rec.ar48,  l_default_ar);
         a_ar(49)  := NVL(l_cy_rec.ar49,  l_default_ar);          a_ar(50)  := NVL(l_cy_rec.ar50,  l_default_ar);          a_ar(51)  := NVL(l_cy_rec.ar51,  l_default_ar);          a_ar(52)  := NVL(l_cy_rec.ar52,  l_default_ar);
         a_ar(53)  := NVL(l_cy_rec.ar53,  l_default_ar);          a_ar(54)  := NVL(l_cy_rec.ar54,  l_default_ar);          a_ar(55)  := NVL(l_cy_rec.ar55,  l_default_ar);          a_ar(56)  := NVL(l_cy_rec.ar56,  l_default_ar);
         a_ar(57)  := NVL(l_cy_rec.ar57,  l_default_ar);          a_ar(58)  := NVL(l_cy_rec.ar58,  l_default_ar);          a_ar(59)  := NVL(l_cy_rec.ar59,  l_default_ar);          a_ar(60)  := NVL(l_cy_rec.ar60,  l_default_ar);
         a_ar(61)  := NVL(l_cy_rec.ar61,  l_default_ar);          a_ar(62)  := NVL(l_cy_rec.ar62,  l_default_ar);          a_ar(63)  := NVL(l_cy_rec.ar63,  l_default_ar);          a_ar(64)  := NVL(l_cy_rec.ar64,  l_default_ar);
         a_ar(65)  := NVL(l_cy_rec.ar65,  l_default_ar);          a_ar(66)  := NVL(l_cy_rec.ar66,  l_default_ar);          a_ar(67)  := NVL(l_cy_rec.ar67,  l_default_ar);          a_ar(68)  := NVL(l_cy_rec.ar68,  l_default_ar);
         a_ar(69)  := NVL(l_cy_rec.ar69,  l_default_ar);          a_ar(70)  := NVL(l_cy_rec.ar70,  l_default_ar);          a_ar(71)  := NVL(l_cy_rec.ar71,  l_default_ar);          a_ar(72)  := NVL(l_cy_rec.ar72,  l_default_ar);
         a_ar(73)  := NVL(l_cy_rec.ar73,  l_default_ar);          a_ar(74)  := NVL(l_cy_rec.ar74,  l_default_ar);          a_ar(75)  := NVL(l_cy_rec.ar75,  l_default_ar);          a_ar(76)  := NVL(l_cy_rec.ar76,  l_default_ar);
         a_ar(77)  := NVL(l_cy_rec.ar77,  l_default_ar);          a_ar(78)  := NVL(l_cy_rec.ar78,  l_default_ar);          a_ar(79)  := NVL(l_cy_rec.ar79,  l_default_ar);          a_ar(80)  := NVL(l_cy_rec.ar80,  l_default_ar);
         a_ar(81)  := NVL(l_cy_rec.ar81,  l_default_ar);          a_ar(82)  := NVL(l_cy_rec.ar82,  l_default_ar);          a_ar(83)  := NVL(l_cy_rec.ar83,  l_default_ar);          a_ar(84)  := NVL(l_cy_rec.ar84,  l_default_ar);
         a_ar(85)  := NVL(l_cy_rec.ar85,  l_default_ar);          a_ar(86)  := NVL(l_cy_rec.ar86,  l_default_ar);          a_ar(87)  := NVL(l_cy_rec.ar87,  l_default_ar);          a_ar(88)  := NVL(l_cy_rec.ar88,  l_default_ar);
         a_ar(89)  := NVL(l_cy_rec.ar89,  l_default_ar);          a_ar(90)  := NVL(l_cy_rec.ar90,  l_default_ar);          a_ar(91)  := NVL(l_cy_rec.ar91,  l_default_ar);          a_ar(92)  := NVL(l_cy_rec.ar92,  l_default_ar);
         a_ar(93)  := NVL(l_cy_rec.ar93,  l_default_ar);          a_ar(94)  := NVL(l_cy_rec.ar94,  l_default_ar);          a_ar(95)  := NVL(l_cy_rec.ar95,  l_default_ar);          a_ar(96)  := NVL(l_cy_rec.ar96,  l_default_ar);
         a_ar(97)  := NVL(l_cy_rec.ar97,  l_default_ar);          a_ar(98)  := NVL(l_cy_rec.ar98,  l_default_ar);          a_ar(99)  := NVL(l_cy_rec.ar99,  l_default_ar);          a_ar(100) := NVL(l_cy_rec.ar100, l_default_ar);
         a_ar(101) := NVL(l_cy_rec.ar101, l_default_ar);          a_ar(102) := NVL(l_cy_rec.ar102, l_default_ar);          a_ar(103) := NVL(l_cy_rec.ar103, l_default_ar);          a_ar(104) := NVL(l_cy_rec.ar104, l_default_ar);
         a_ar(105) := NVL(l_cy_rec.ar105, l_default_ar);          a_ar(106) := NVL(l_cy_rec.ar106, l_default_ar);          a_ar(107) := NVL(l_cy_rec.ar107, l_default_ar);          a_ar(108) := NVL(l_cy_rec.ar108, l_default_ar);
         a_ar(109) := NVL(l_cy_rec.ar109, l_default_ar);          a_ar(110) := NVL(l_cy_rec.ar110, l_default_ar);          a_ar(111) := NVL(l_cy_rec.ar111, l_default_ar);          a_ar(112) := NVL(l_cy_rec.ar112, l_default_ar);
         a_ar(113) := NVL(l_cy_rec.ar113, l_default_ar);          a_ar(114) := NVL(l_cy_rec.ar114, l_default_ar);          a_ar(115) := NVL(l_cy_rec.ar115, l_default_ar);          a_ar(116) := NVL(l_cy_rec.ar116, l_default_ar);
         a_ar(117) := NVL(l_cy_rec.ar117, l_default_ar);          a_ar(118) := NVL(l_cy_rec.ar118, l_default_ar);          a_ar(119) := NVL(l_cy_rec.ar119, l_default_ar);          a_ar(120) := NVL(l_cy_rec.ar120, l_default_ar);
         a_ar(121) := NVL(l_cy_rec.ar121, l_default_ar);          a_ar(122) := NVL(l_cy_rec.ar122, l_default_ar);          a_ar(123) := NVL(l_cy_rec.ar123, l_default_ar);          a_ar(124) := NVL(l_cy_rec.ar124, l_default_ar);
         a_ar(125) := NVL(l_cy_rec.ar125, l_default_ar);          a_ar(126) := NVL(l_cy_rec.ar126, l_default_ar);          a_ar(127) := NVL(l_cy_rec.ar127, l_default_ar);          a_ar(128) := NVL(l_cy_rec.ar128, l_default_ar);
         RETURN(Unapigen.DBERR_SUCCESS);
      END IF;
   END IF;

   /* In all other cases */
   IF NOT l_found THEN
      -- When creating a new config object via new version or create from template (NOT via
      -- api CopyXx), the ar are also copied, but afterwards overwritten by this api.
      -- To avoid this overwriting, a check is done whether the object is created from blank
      -- or not. The overwriting will only be executed when created from blank.
      l_ar_event_found := FALSE;
      IF (a_object_tp = 'pp') THEN
         FOR l_rec IN l_pp_ar_event_cursor LOOP
            l_ar_event_found := TRUE;
            EXIT;
         END LOOP;
      ELSIF (a_object_tp = 'eq') THEN
         FOR l_rec IN l_eq_ar_event_cursor LOOP
            l_ar_event_found := TRUE;
            EXIT;
         END LOOP;
      ELSE
         FOR l_rec IN l_ar_event_cursor LOOP
            l_ar_event_found := TRUE;
            EXIT;
         END LOOP;
      END IF;

      IF l_ar_event_found = FALSE THEN
         --Check if there are some access rights for this object type
         --It is important to return something different of SUCCESS when
         --there are no access rights for an object type
         OPEN c_utobjects(a_object_tp);
         FETCH c_utobjects
         INTO l_utobjects_rec;
         IF c_utobjects%FOUND THEN
            IF l_utobjects_rec.ar='1' THEN
					a_ar(1)    := l_default_ar;          a_ar(2)    := l_default_ar;          a_ar(3)    := l_default_ar;          a_ar(4)    := l_default_ar;
               a_ar(5)    := l_default_ar;          a_ar(6)    := l_default_ar;          a_ar(7)    := l_default_ar;          a_ar(8)    := l_default_ar;
               a_ar(9)    := l_default_ar;          a_ar(10)   := l_default_ar;          a_ar(11)   := l_default_ar;          a_ar(12)   := l_default_ar;
               a_ar(13)   := l_default_ar;          a_ar(14)   := l_default_ar;          a_ar(15)   := l_default_ar;          a_ar(16)   := l_default_ar;
               a_ar(17)   := l_default_ar;          a_ar(18)   := l_default_ar;          a_ar(19)   := l_default_ar;          a_ar(20)   := l_default_ar;
               a_ar(21)   := l_default_ar;          a_ar(22)   := l_default_ar;          a_ar(23)   := l_default_ar;          a_ar(24)   := l_default_ar;
               a_ar(25)   := l_default_ar;          a_ar(26)   := l_default_ar;          a_ar(27)   := l_default_ar;          a_ar(28)   := l_default_ar;
               a_ar(29)   := l_default_ar;          a_ar(30)   := l_default_ar;          a_ar(31)   := l_default_ar;          a_ar(32)   := l_default_ar;
               a_ar(33)   := l_default_ar;          a_ar(34)   := l_default_ar;          a_ar(35)   := l_default_ar;          a_ar(36)   := l_default_ar;
               a_ar(37)   := l_default_ar;          a_ar(38)   := l_default_ar;          a_ar(39)   := l_default_ar;          a_ar(40)   := l_default_ar;
               a_ar(41)   := l_default_ar;          a_ar(42)   := l_default_ar;          a_ar(43)   := l_default_ar;          a_ar(44)   := l_default_ar;
               a_ar(45)   := l_default_ar;          a_ar(46)   := l_default_ar;          a_ar(47)   := l_default_ar;          a_ar(48)   := l_default_ar;
               a_ar(49)   := l_default_ar;          a_ar(50)   := l_default_ar;          a_ar(51)   := l_default_ar;          a_ar(52)   := l_default_ar;
               a_ar(53)   := l_default_ar;          a_ar(54)   := l_default_ar;          a_ar(55)   := l_default_ar;          a_ar(56)   := l_default_ar;
               a_ar(57)   := l_default_ar;          a_ar(58)   := l_default_ar;          a_ar(59)   := l_default_ar;          a_ar(60)   := l_default_ar;
               a_ar(61)   := l_default_ar;          a_ar(62)   := l_default_ar;          a_ar(63)   := l_default_ar;          a_ar(64)   := l_default_ar;
               a_ar(65)   := l_default_ar;          a_ar(66)   := l_default_ar;          a_ar(67)   := l_default_ar;          a_ar(68)   := l_default_ar;
               a_ar(69)   := l_default_ar;          a_ar(70)   := l_default_ar;          a_ar(71)   := l_default_ar;          a_ar(72)   := l_default_ar;
               a_ar(73)   := l_default_ar;          a_ar(74)   := l_default_ar;          a_ar(75)   := l_default_ar;          a_ar(76)   := l_default_ar;
               a_ar(77)   := l_default_ar;          a_ar(78)   := l_default_ar;          a_ar(79)   := l_default_ar;          a_ar(80)   := l_default_ar;
               a_ar(81)   := l_default_ar;          a_ar(82)   := l_default_ar;          a_ar(83)   := l_default_ar;          a_ar(84)   := l_default_ar;
               a_ar(85)   := l_default_ar;          a_ar(86)   := l_default_ar;          a_ar(87)   := l_default_ar;          a_ar(88)   := l_default_ar;
               a_ar(89)   := l_default_ar;          a_ar(90)   := l_default_ar;          a_ar(91)   := l_default_ar;          a_ar(92)   := l_default_ar;
               a_ar(93)   := l_default_ar;          a_ar(94)   := l_default_ar;          a_ar(95)   := l_default_ar;          a_ar(96)   := l_default_ar;
               a_ar(97)   := l_default_ar;          a_ar(98)   := l_default_ar;          a_ar(99)   := l_default_ar;          a_ar(100)  := l_default_ar;
               a_ar(101)  := l_default_ar;          a_ar(102)  := l_default_ar;          a_ar(103)  := l_default_ar;          a_ar(104)  := l_default_ar;
               a_ar(105)  := l_default_ar;          a_ar(106)  := l_default_ar;          a_ar(107)  := l_default_ar;          a_ar(108)  := l_default_ar;
               a_ar(109)  := l_default_ar;          a_ar(110)  := l_default_ar;          a_ar(111)  := l_default_ar;          a_ar(112)  := l_default_ar;
               a_ar(113)  := l_default_ar;          a_ar(114)  := l_default_ar;          a_ar(115)  := l_default_ar;          a_ar(116)  := l_default_ar;
               a_ar(117)  := l_default_ar;          a_ar(118)  := l_default_ar;          a_ar(119)  := l_default_ar;          a_ar(120)  := l_default_ar;
               a_ar(121)  := l_default_ar;          a_ar(122)  := l_default_ar;          a_ar(123)  := l_default_ar;          a_ar(124)  := l_default_ar;
               a_ar(125)  := l_default_ar;          a_ar(126)  := l_default_ar;          a_ar(127)  := l_default_ar;          a_ar(128)  := l_default_ar;

				 	FOR lvr_dd IN lvq_dd LOOP
						a_ar(lvr_dd.dd) := lvr_dd.ar;
					END LOOP;

               CLOSE c_utobjects;
               RETURN(Unapigen.DBERR_SUCCESS);
            END IF;
         END IF;
         CLOSE c_utobjects;
      END IF;

      RETURN(Unapigen.DBERR_NORECORDS);
   END IF;

END InitObjectAccessRights;

FUNCTION TransitionAuthorised                            /* INTERNAL */

RETURN BOOLEAN IS

CURSOR l_DBA_up IS
   SELECT utad.def_up FROM utad, utsystem
   WHERE utad.ad = utsystem.setting_value
     AND utsystem.SETTING_NAME = 'DBA_NAME';

l_up                   NUMBER;
l_version_implemented  BOOLEAN;
l_index                INTEGER;

CURSOR l_check_utrscpa_cursor IS
   SELECT sc, pg, pgnode, pa, panode, reanalysis
   FROM utscpa
   WHERE sc = UNAPIAUT.P_SC
     AND pg = UNAPIAUT.P_PG
     AND pgnode = UNAPIAUT.P_PGNODE
     AND pa = UNAPIAUT.P_PA
     AND panode = UNAPIAUT.P_PANODE
   INTERSECT
   SELECT sc, pg, pgnode, pa, panode, reanalysis
   FROM utrscpa
   WHERE sc = UNAPIAUT.P_SC
     AND pg = UNAPIAUT.P_PG
     AND pgnode = UNAPIAUT.P_PGNODE
     AND pa = UNAPIAUT.P_PA
     AND panode = UNAPIAUT.P_PANODE;
l_check_utrscpa_rec        l_check_utrscpa_cursor%ROWTYPE;
l_pa_reanalysis_busy       BOOLEAN;
l_pa_cancel_busy           BOOLEAN;
l_count_save_on_current    INTEGER;

CURSOR lvq_cells IS
SELECT a.sc,
       a.pg, a.pgnode,
       a.pa, a.panode,
       a.me, a.menode,
       a.cell,
       a.panode + a.menode/1000 + a.cellnode/10000 save_panode
  FROM utscmecell a, utscmecelloutput b
 WHERE a.sc = UNAPIAUT.P_SC
   AND a.pg = UNAPIAUT.P_PG AND a.pgnode = UNAPIAUT.P_PGNODE
   AND a.pa = UNAPIAUT.P_PA AND a.panode = UNAPIAUT.P_PANODE
   AND a.me = UNAPIAUT.P_ME AND a.menode = UNAPIAUT.P_MENODE
   AND a.sc = b.sc
   AND a.pg = b.pg AND a.pgnode = b.pgnode
   AND a.pa = b.pa AND a.panode = b.panode
   AND a.me = b.me AND a.menode = b.menode
   AND a.cell = b.cell
   --AND b.save_pg != b.pgnode -- do not clear the current pgnode
   --AND b.save_pa != b.panode -- do not clear the current panode
   AND b.save_me IS NULL;    -- do not clear if a method is defined

lvi_count NUMBER;

BEGIN

   -- check if version control is implemented for a_object_tp
   l_version_implemented := FALSE;
   l_index := 1;
   LOOP
      EXIT WHEN (l_version_implemented = TRUE) OR (l_index > UNAPIGEN.l_nr_of_types);

      IF UNAPIAUT.P_OBJECT_TP = UNAPIGEN.l_object_types(l_index) THEN
         l_version_implemented := TRUE;
      END IF;
      l_index := l_index + 1;
   END LOOP;

   --Transition from InEditing to Approved is not authorised in the system life cycle
   --when the system is supporting 21CFR11
   IF l_version_implemented THEN
      IF UNAPIAUT.P_LC='@L' AND
         UNAPIAUT.P_SS_FROM  IN ('@A','@O') AND
         UNAPIAUT.P_SS_TO = '@E' THEN
         l_result := UNAPIGEN.IsSystem21CFR11Compliant;
         IF l_result = UNAPIGEN.DBERR_SUCCESS THEN
            RETURN(FALSE);
         END IF;
      END IF;
   END IF;

   --------------------------------------------------------------------------------
   -- if method will be cancelled,
   -- reset the values of utscmecelloutput altered by AllowDuplo
   --------------------------------------------------------------------------------
   IF UNAPIAUT.P_OBJECT_TP = 'me' THEN
      IF UNAPIAUT.P_SS_TO = '@C' THEN
          --------------------------------------------------------------------------------
          -- Reset the panode of not created pa's to null to prevent a crash
          -- This panode has been set by APAOEVRULES.AllowDuplo
          --------------------------------------------------------------------------------
          FOR lvr_cells IN lvq_cells LOOP

            SELECT count(*)
              INTO lvi_count
              FROM utscpa
             WHERE sc = lvr_cells.sc
               AND pg = lvr_cells.pg AND pgnode = lvr_cells.pgnode
               AND panode = lvr_cells.save_panode
               AND value_s IS NOT NULL;

            IF lvi_count = 0 THEN
               UPDATE utscmecelloutput
                  SET save_panode = NULL
                WHERE sc = lvr_cells.sc
                  AND pg = lvr_cells.pg AND pgnode = lvr_cells.pgnode
                  AND pa = lvr_cells.pa AND panode = lvr_cells.panode
                  AND me = lvr_cells.me AND menode = lvr_cells.menode
                  AND cell = lvr_cells.cell;
            END IF;
          END LOOP;

      END IF;
   END IF;
   --Do not cascade down the reanalysis/cancel of a parameter down when that parameter is the result of a a cell output
   --on the underlying method
   IF UNAPIAUT.P_OBJECT_TP = 'pa' THEN
   --store the last authorisation request when a cancel is perfomred to detect the trickle down
      --when the authorisation is performed on method level
      IF UNAPIAUT.P_SS_TO = '@C' THEN
         P_LAST_PA_CANCELED := UNAPIAUT.P_SC||UNAPIAUT.P_PG||UNAPIAUT.P_PGNODE||UNAPIAUT.P_PA||UNAPIAUT.P_PANODE||
                               UNAPIGEN.P_TR_SEQ;
      ELSE
         P_LAST_PA_CANCELED := NULL;
      END IF;
   ELSIF UNAPIAUT.P_OBJECT_TP = 'me' THEN
      --the fact that a reanalysis of the parameter is busy can be detected
      --at this point can be detected by the fact that there is a record
      --in utrscpa and utscpa for the parameter
      OPEN l_check_utrscpa_cursor;
      FETCH l_check_utrscpa_cursor
      INTO l_check_utrscpa_rec;
      l_pa_reanalysis_busy := l_check_utrscpa_cursor%FOUND;
      CLOSE l_check_utrscpa_cursor;

      IF l_pa_reanalysis_busy = FALSE THEN
         IF UNAPIAUT.P_SS_TO = '@C' AND
            P_LAST_PA_CANCELED = UNAPIAUT.P_SC||UNAPIAUT.P_PG||UNAPIAUT.P_PGNODE||
                                 UNAPIAUT.P_PA||UNAPIAUT.P_PANODE||UNAPIGEN.P_TR_SEQ THEN
            l_pa_cancel_busy := TRUE;
         END IF;
      END IF;

      IF l_pa_reanalysis_busy OR l_pa_cancel_busy THEN
         --check if the method has some method cell saved as the current parameter or the current method
         SELECT count(pa)
         INTO l_count_save_on_current
         FROM utscmecelloutput out
         WHERE out.sc = UNAPIAUT.P_SC
         AND out.pg = UNAPIAUT.P_PG
         AND out.pgnode = UNAPIAUT.P_PGNODE
         AND out.pa = UNAPIAUT.P_PA
         AND out.panode = UNAPIAUT.P_PANODE
         AND out.me = UNAPIAUT.P_ME
         AND out.menode = UNAPIAUT.P_MENODE
         AND out.save_pg = UNAPIAUT.P_PG
         AND out.save_pgnode = UNAPIAUT.P_PGNODE
         AND out.save_pa = UNAPIAUT.P_PA
         AND out.save_panode = UNAPIAUT.P_PANODE
         AND out.save_tp IN ('pr', 'mt')
         AND NVL(out.save_me, ' ') = DECODE(out.save_tp, 'mt', UNAPIAUT.P_ME, NVL(out.save_me, ' '))
         AND NVL(out.save_menode, -1) = DECODE(out.save_tp, 'mt', UNAPIAUT.P_MENODE, NVL(out.save_menode, -1));

         IF l_count_save_on_current > 0 THEN
            RETURN(FALSE);
         END IF;
      END IF;
   END IF;


   RETURN(TRUE);

END TransitionAuthorised;

FUNCTION GetVersion
  RETURN VARCHAR2
IS
BEGIN
  RETURN('06.07.00.00_13.00');
EXCEPTION
  WHEN OTHERS THEN
	 RETURN (NULL);
END GetVersion;


END Unaccess;
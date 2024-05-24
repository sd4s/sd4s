create or replace PACKAGE BODY
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
pbapiup AS

l_ret_code        NUMBER;

FUNCTION GetVersion
   RETURN VARCHAR2
IS
BEGIN
   RETURN('06.07.00.00_00.13');
EXCEPTION
   WHEN OTHERS THEN
      RETURN (NULL);
END GetVersion;

FUNCTION GetUserProfile
(a_up                OUT    UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_description       OUT    UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_dd                OUT    UNAPIGEN.VC3_TABLE_TYPE,   /* VC3_TABLE_TYPE */
 a_descr_doc         OUT    UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_chg_pwd           OUT    PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_define_menu       OUT    PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_confirm_chg_ss    OUT    PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_language          OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_up_class          OUT    UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_log_hs            OUT    PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_allow_modify      OUT    PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_active            OUT    PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_lc                OUT    UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_ss                OUT    UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_nr_of_rows        IN OUT NUMBER,                    /* NUM_TYPE */
 a_where_clause      IN     VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER IS
l_row                 NUMBER;
l_chg_pwd             UNAPIGEN.CHAR1_TABLE_TYPE ;
l_define_menu         UNAPIGEN.CHAR1_TABLE_TYPE ;
l_confirm_chg_ss      UNAPIGEN.CHAR1_TABLE_TYPE ;
l_log_hs              UNAPIGEN.CHAR1_TABLE_TYPE ;
l_allow_modify        UNAPIGEN.CHAR1_TABLE_TYPE ;
l_active              UNAPIGEN.CHAR1_TABLE_TYPE ;
BEGIN
l_ret_code := UNAPIUP.GetUserProfile
(a_up,
 a_description,
 a_dd,
 a_descr_doc,
 l_chg_pwd, /* CHAR1_TABLE_TYPE */
 l_define_menu, /* CHAR1_TABLE_TYPE */
 l_confirm_chg_ss, /* CHAR1_TABLE_TYPE */
 a_language,
 a_up_class,
 l_log_hs, /* CHAR1_TABLE_TYPE */
 l_allow_modify, /* CHAR1_TABLE_TYPE */
 l_active, /* CHAR1_TABLE_TYPE */
 a_lc,
 a_ss,
 a_nr_of_rows,
 a_where_clause);
IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
 FOR l_row IN 1..a_nr_of_rows LOOP
   a_chg_pwd(l_row) := l_chg_pwd(l_row);
   a_define_menu(l_row) := l_define_menu(l_row);
   a_confirm_chg_ss(l_row) := l_confirm_chg_ss(l_row);
   a_log_hs(l_row) := l_log_hs(l_row);
   a_allow_modify(l_row) := l_allow_modify(l_row);
   a_active(l_row) := l_active(l_row);
 END LOOP;
END IF;
RETURN (l_ret_code);
END GetUserProfile;



FUNCTION GetUpUser
(a_up              OUT      UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_us              OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_person          OUT      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_is_default      OUT      PBAPIGEN.VC1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_nr_of_rows      IN OUT   NUMBER,                    /* NUM_TYPE */
 a_where_clause    IN       VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER IS
l_row                 NUMBER;
l_is_default              UNAPIGEN.CHAR1_TABLE_TYPE ;
BEGIN
   l_ret_code := UNAPIUP.GetUpUser
   (  a_up,
      a_us,
      a_person,
      l_is_default,
      a_nr_of_rows,
      a_where_Clause);
IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
 FOR l_row IN 1..a_nr_of_rows LOOP
   a_is_default(l_row) := l_is_default(l_row);
 END LOOP;
END IF;
RETURN (l_ret_code);

END GetUpUser;
END pbapiup;
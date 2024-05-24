create or replace PACKAGE
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
pbapiup AS

FUNCTION GetVersion
RETURN VARCHAR2;

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
RETURN NUMBER;

FUNCTION GetUpUser
(a_up              OUT      UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_us              OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_person          OUT      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_is_default      OUT      PBAPIGEN.VC1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_nr_of_rows      IN OUT   NUMBER,                    /* NUM_TYPE */
 a_where_clause    IN       VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;


END pbapiup;
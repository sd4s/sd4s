create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapiup AS

P_ENT_USER_SS_APPROVED   CONSTANT VARCHAR2(2) := '@A';

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION GetUserProfile
(a_up                OUT    UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_description       OUT    UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_dd                OUT    UNAPIGEN.VC3_TABLE_TYPE,   /* VC3_TABLE_TYPE */
 a_descr_doc         OUT    UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_chg_pwd           OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_define_menu       OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_confirm_chg_ss    OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_language          OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_up_class          OUT    UNAPIGEN.VC2_TABLE_TYPE,  /* VC2_TABLE_TYPE */
 a_log_hs            OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_allow_modify      OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_active            OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_lc                OUT    UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_ss                OUT    UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_nr_of_rows        IN OUT NUMBER,                    /* NUM_TYPE */
 a_where_clause      IN     VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetUpUser
(a_up              OUT      UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_us              OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_person          OUT      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_is_default      OUT      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_nr_of_rows      IN OUT   NUMBER,                    /* NUM_TYPE */
 a_where_clause    IN       VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetUserProfileList
(a_up                  OUT      UNAPIGEN.LONG_TABLE_TYPE,/* LONG_TABLE_TYPE */
 a_description         OUT      UNAPIGEN.VC40_TABLE_TYPE,/* VC40_TABLE_TYPE */
 a_ss                  OUT      UNAPIGEN.VC2_TABLE_TYPE, /* VC2_TABLE_TYPE */
 a_nr_of_rows          IN OUT   NUMBER,                  /* NUM_TYPE */
 a_where_clause        IN       VARCHAR2,                /* VC511_TYPE */
 a_next_rows           IN       NUMBER)                  /* NUM_TYPE */
RETURN NUMBER;

FUNCTION SaveUserProfile
(a_up                     IN     NUMBER,             /* LONG_TYPE */
 a_description            IN     VARCHAR2,           /* VC40_TYPE */
 a_dd                     IN     VARCHAR2,           /* VC3_TYPE */
 a_descr_doc              IN     VARCHAR2,           /* VC40_TYPE */
 a_chg_pwd                IN     CHAR,               /* CHAR1_TYPE */
 a_define_menu            IN     CHAR,               /* CHAR1_TYPE */
 a_confirm_chg_ss         IN     CHAR,               /* CHAR1_TYPE */
 a_language               IN     VARCHAR2,           /* VC20_TYPE */
 a_up_class               IN     VARCHAR2,           /* VC2_TYPE */
 a_log_hs                 IN     CHAR,               /* CHAR1_TYPE */
 a_lc                     IN     VARCHAR2,           /* VC2_TYPE */
 a_modify_reason          IN     VARCHAR2)           /* VC255_TYPE */
RETURN NUMBER;

FUNCTION DeleteUserProfile
(a_up                    IN  NUMBER,                  /* LONG_TYPE */
 a_modify_reason         IN  VARCHAR2)                /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SaveUpUser
(a_up                 IN     NUMBER,                    /* LONG_TYPE */
 a_us                 IN     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_nr_of_rows         IN     NUMBER,                    /* NUM_TYPE */
 a_modify_reason      IN     VARCHAR2)                  /* VC255_TYPE */
RETURN NUMBER;

FUNCTION AddOneEnterpriseUser
(a_up               IN      NUMBER,                     /* LONG_TYPE */
 a_us               IN      VARCHAR2,                   /* VC20_TYPE */
 a_description      IN      VARCHAR2)                   /* VC40_TYPE */
RETURN NUMBER;

FUNCTION ChangeDefUp4EnterpriseUser
(a_old_up           IN      NUMBER,                     /* LONG_TYPE */
 a_new_up           IN      NUMBER,                     /* LONG_TYPE */
 a_us               IN      VARCHAR2)                   /* VC20_TYPE */
RETURN NUMBER;

FUNCTION GetSystemDefault
(a_setting_name     OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_setting_value    OUT     UNAPIGEN.VC255_TABLE_TYPE,  /* VC255_TABLE_TYPE */
 a_nr_of_rows       IN OUT  NUMBER,                     /* NUM_TYPE */
 a_where_clause     IN      VARCHAR2)                   /* VC511_TYPE */
RETURN NUMBER;

FUNCTION SaveSystemDefault
(a_setting_name     IN    UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_setting_value    IN    UNAPIGEN.VC255_TABLE_TYPE,    /* VC255_TABLE_TYPE */
 a_nr_of_rows  IN   NUMBER,                             /* NUM_TYPE */
 a_modify_reason    IN    VARCHAR2)                     /* VC255_TYPE */
RETURN NUMBER;

END unapiup;
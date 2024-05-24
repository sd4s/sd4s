create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapiuc AS

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION GetUniqueCodeMaskList
(a_uc               OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_description      OUT      UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_ss               OUT      UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_nr_of_rows       IN OUT   NUMBER,                     /* NUM_TYPE */
 a_where_clause     IN       VARCHAR2,                   /* VC511_TYPE */
 a_next_rows        IN       NUMBER)                     /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetUniqueCodeMask
(a_uc               OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_description      OUT    UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_uc_structure     OUT    UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_curr_val         OUT    UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_def_mask_for     OUT    UNAPIGEN.CHAR2_TABLE_TYPE, /* CHAR2_TABLE_TYPE */
 a_edit_allowed     OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_valid_cf         OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_log_hs           OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_allow_modify     OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_active           OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_lc               OUT    UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_ss               OUT    UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_nr_of_rows       IN OUT NUMBER,                    /* NUM_TYPE */
 a_where_clause     IN     VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION DeleteUniqueCodeMask
(a_uc                  IN       VARCHAR2,                 /* VC20_TYPE */
 a_modify_reason       IN       VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SaveUniqueCodeMask
(a_uc                  IN       VARCHAR2,                 /* VC20_TYPE */
 a_description         IN       VARCHAR2,                 /* VC40_TYPE */
 a_uc_structure        IN       VARCHAR2,                 /* VC255_TYPE */
 a_def_mask_for        IN       CHAR,                     /* CHAR2_TYPE */
 a_edit_allowed        IN       CHAR,                     /* CHAR1_TYPE */
 a_valid_cf            IN       VARCHAR2,                 /* VC20_TYPE */
 a_log_hs              IN       CHAR,                     /* CHAR1_TYPE */
 a_lc                  IN       VARCHAR2,                 /* VC2_TYPE */
 a_modify_reason       IN       VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GetCounterList
(a_counter          OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_nr_of_rows       IN OUT   NUMBER,                     /* NUM_TYPE */
 a_where_clause     IN       VARCHAR2,                   /* VC511_TYPE */
 a_next_rows        IN       NUMBER)                     /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetCounter
(a_counter          OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_curr_cnt         OUT      UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_low_cnt          OUT      UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_high_cnt         OUT      UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_incr_cnt         OUT      UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_fixed_length     OUT      UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_circular         OUT      UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_nr_of_rows       IN OUT   NUMBER,                     /* NUM_TYPE */
 a_where_clause     IN       VARCHAR2)                   /* VC511_TYPE */
RETURN NUMBER;

FUNCTION DeleteCounter
(a_counter          IN       VARCHAR2,                   /* VC20_TYPE */
 a_modify_reason    IN       VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SaveCounter
(a_counter             IN       VARCHAR2,   /* VC20_TYPE */
 a_low_cnt             IN       INTEGER,    /* NUM_TYPE */
 a_high_cnt            IN       INTEGER,    /* NUM_TYPE */
 a_incr_cnt            IN       INTEGER ,   /* NUM_TYPE */
 a_fixed_length        IN       CHAR,       /* CHAR1_TYPE */
 a_circular            IN       CHAR)       /* CHAR1_TYPE */
RETURN NUMBER;

FUNCTION SaveCounter
(a_counter             IN       VARCHAR2,   /* VC20_TYPE */
 a_curr_cnt            IN       INTEGER,    /* NUM_TYPE */
 a_low_cnt             IN       INTEGER,    /* NUM_TYPE */
 a_high_cnt            IN       INTEGER,    /* NUM_TYPE */
 a_incr_cnt            IN       INTEGER ,   /* NUM_TYPE */
 a_fixed_length        IN       CHAR,       /* CHAR1_TYPE */
 a_circular            IN       CHAR)       /* CHAR1_TYPE */
RETURN NUMBER;

FUNCTION ResetCounter
(a_counter             IN      VARCHAR2)    /* VC20_TYPE */
RETURN NUMBER;

FUNCTION CreateNextUniqueCodeValue
(a_uc                  IN       VARCHAR2,                  /* VC20_TYPE */
 a_st                  IN       VARCHAR2,                  /* VC20_TYPE */
 a_st_version          IN       VARCHAR2,                  /* VC20_TYPE */
 a_rt                  IN       VARCHAR2,                  /* VC20_TYPE */
 a_rt_version          IN       VARCHAR2,                  /* VC20_TYPE */
 a_rq                  IN       VARCHAR2,                  /* VC20_TYPE */
 a_ref_date            IN       DATE,                      /* DATE_TYPE */
 a_next_val            OUT      VARCHAR2,                  /* VC255_TYPE */
 a_edit_allowed        OUT      CHAR,                      /* CHAR1_TYPE */
 a_valid_cf            OUT      VARCHAR2)                  /* VC20_TYPE */
RETURN NUMBER;

FUNCTION CreateNextUniqueCodeValue                           /* INTERNAL */
(a_uc                  IN       VARCHAR2,                    /* VC20_TYPE */
 a_fieldtype_tab       IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_fieldnames_tab      IN       UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TAB_TYPE */
 a_fieldvalues_tab     IN       UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TAB_TYPE */
 a_nr_of_rows          IN       NUMBER,                      /* NUM_TYPE */
 a_ref_date            IN       DATE,                        /* DATE_TYPE */
 a_next_val            OUT      VARCHAR2,                    /* VC255_TYPE */
 a_edit_allowed        OUT      CHAR,                        /* CHAR1_TYPE */
 a_valid_cf            OUT      VARCHAR2)                    /* VC20_TYPE */
RETURN NUMBER;

FUNCTION CreateNextCounterValue
(a_counter          IN       VARCHAR2,                   /* VC20_TYPE */
 a_next_cnt         OUT      VARCHAR2)                   /* VC20_TYPE */
RETURN NUMBER;

END unapiuc;
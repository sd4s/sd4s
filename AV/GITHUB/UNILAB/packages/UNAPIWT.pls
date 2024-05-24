create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapiwt AS

P_SELECTION_CLAUSE VARCHAR2(2000);

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION GetWorksheetTypeList
(a_wt                      OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_version                 OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_version_is_current      OUT      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_effective_from          OUT      UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_effective_till          OUT      UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_description             OUT      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_ss                      OUT      UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_nr_of_rows              IN OUT   NUMBER,                    /* NUM_TYPE */
 a_where_clause            IN       VARCHAR2,                  /* VC511_TYPE */
 a_next_rows               IN       NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetWorksheetType
(a_wt                      OUT     UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_version                 OUT     UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_version_is_current      OUT     UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_effective_from          OUT     UNAPIGEN.DATE_TABLE_TYPE,     /* DATE_TABLE_TYPE */
 a_effective_till          OUT     UNAPIGEN.DATE_TABLE_TYPE,     /* DATE_TABLE_TYPE */
 a_description             OUT     UNAPIGEN.VC40_TABLE_TYPE,     /* VC40_TABLE_TYPE */
 a_description2            OUT     UNAPIGEN.VC40_TABLE_TYPE,     /* VC40_TABLE_TYPE */
 a_min_rows                OUT     UNAPIGEN.NUM_TABLE_TYPE,      /* NUM_TABLE_TYPE */
 a_max_rows                OUT     UNAPIGEN.NUM_TABLE_TYPE,      /* NUM_TABLE_TYPE */
 a_valid_cf                OUT     UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_descr_doc               OUT     UNAPIGEN.VC40_TABLE_TYPE,     /* VC40_TABLE_TYPE */
 a_descr_doc_version       OUT     UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_ws_ly                   OUT     UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_ws_uc                   OUT     UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_ws_uc_version           OUT     UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_ws_lc                   OUT     UNAPIGEN.VC2_TABLE_TYPE,      /* VC2_TABLE_TYPE */
 a_ws_lc_version           OUT     UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_inherit_au              OUT     UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_wt_class                OUT     UNAPIGEN.VC2_TABLE_TYPE,      /* VC2_TABLE_TYPE */
 a_log_hs                  OUT     UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_allow_modify            OUT     UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_active                  OUT     UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_lc                      OUT     UNAPIGEN.VC2_TABLE_TYPE,      /* VC2_TABLE_TYPE */
 a_lc_version              OUT     UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_ss                      OUT     UNAPIGEN.VC2_TABLE_TYPE,      /* VC2_TABLE_TYPE */
 a_nr_of_rows              IN OUT  NUMBER,                       /* NUM_TYPE */
 a_where_clause            IN      VARCHAR2)                     /* VC511_TYPE */
RETURN NUMBER;

FUNCTION SelectWorksheetType
(a_col_id                  IN       UNAPIGEN.VC40_TABLE_TYPE,     /* VC40_TABLE_TYPE */
 a_col_tp                  IN       UNAPIGEN.VC40_TABLE_TYPE,     /* VC40_TABLE_TYPE */
 a_col_value               IN       UNAPIGEN.VC40_TABLE_TYPE,     /* VC40_TABLE_TYPE */
 a_col_nr_of_rows          IN       NUMBER,                       /* NUM_TYPE */
 a_wt                      OUT      UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_version                 OUT      UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_version_is_current      OUT      UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_effective_from          OUT      UNAPIGEN.DATE_TABLE_TYPE,     /* DATE_TABLE_TYPE */
 a_effective_till          OUT      UNAPIGEN.DATE_TABLE_TYPE,     /* DATE_TABLE_TYPE */
 a_description             OUT      UNAPIGEN.VC40_TABLE_TYPE,     /* VC40_TABLE_TYPE */
 a_description2            OUT      UNAPIGEN.VC40_TABLE_TYPE,     /* VC40_TABLE_TYPE */
 a_min_rows                OUT      UNAPIGEN.NUM_TABLE_TYPE,      /* NUM_TABLE_TYPE */
 a_max_rows                OUT      UNAPIGEN.NUM_TABLE_TYPE,      /* NUM_TABLE_TYPE */
 a_valid_cf                OUT      UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_descr_doc               OUT      UNAPIGEN.VC40_TABLE_TYPE,     /* VC40_TABLE_TYPE */
 a_descr_doc_version       OUT      UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_ws_ly                   OUT      UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_ws_uc                   OUT      UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_ws_uc_version           OUT      UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_ws_lc                   OUT      UNAPIGEN.VC2_TABLE_TYPE,      /* VC2_TABLE_TYPE */
 a_ws_lc_version           OUT      UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_inherit_au              OUT      UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_wt_class                OUT      UNAPIGEN.VC2_TABLE_TYPE,      /* VC2_TABLE_TYPE */
 a_log_hs                  OUT      UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_allow_modify            OUT      UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_active                  OUT      UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_lc                      OUT      UNAPIGEN.VC2_TABLE_TYPE,      /* VC2_TABLE_TYPE */
 a_lc_version              OUT      UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_ss                      OUT      UNAPIGEN.VC2_TABLE_TYPE,      /* VC2_TABLE_TYPE */
 a_nr_of_rows              IN OUT   NUMBER,                       /* NUM_TYPE */
 a_order_by_clause         IN       VARCHAR2,                     /* VC255_TYPE */
 a_next_rows               IN       NUMBER)                       /* NUM_TYPE */
RETURN NUMBER;

FUNCTION SelectWorksheetType
(a_col_id                  IN       UNAPIGEN.VC40_TABLE_TYPE,     /* VC40_TABLE_TYPE */
 a_col_tp                  IN       UNAPIGEN.VC40_TABLE_TYPE,     /* VC40_TABLE_TYPE */
 a_col_value               IN       UNAPIGEN.VC40_TABLE_TYPE,     /* VC40_TABLE_TYPE */
 a_col_operator            IN       UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_col_andor               IN       UNAPIGEN.VC3_TABLE_TYPE,      /* VC3_TABLE_TYPE */
 a_col_nr_of_rows          IN       NUMBER,                       /* NUM_TYPE */
 a_wt                      OUT      UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_version                 OUT      UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_version_is_current      OUT      UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_effective_from          OUT      UNAPIGEN.DATE_TABLE_TYPE,     /* DATE_TABLE_TYPE */
 a_effective_till          OUT      UNAPIGEN.DATE_TABLE_TYPE,     /* DATE_TABLE_TYPE */
 a_description             OUT      UNAPIGEN.VC40_TABLE_TYPE,     /* VC40_TABLE_TYPE */
 a_description2            OUT      UNAPIGEN.VC40_TABLE_TYPE,     /* VC40_TABLE_TYPE */
 a_min_rows                OUT      UNAPIGEN.NUM_TABLE_TYPE,      /* NUM_TABLE_TYPE */
 a_max_rows                OUT      UNAPIGEN.NUM_TABLE_TYPE,      /* NUM_TABLE_TYPE */
 a_valid_cf                OUT      UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_descr_doc               OUT      UNAPIGEN.VC40_TABLE_TYPE,     /* VC40_TABLE_TYPE */
 a_descr_doc_version       OUT      UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_ws_ly                   OUT      UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_ws_uc                   OUT      UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_ws_uc_version           OUT      UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_ws_lc                   OUT      UNAPIGEN.VC2_TABLE_TYPE,      /* VC2_TABLE_TYPE */
 a_ws_lc_version           OUT      UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_inherit_au              OUT      UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_wt_class                OUT      UNAPIGEN.VC2_TABLE_TYPE,      /* VC2_TABLE_TYPE */
 a_log_hs                  OUT      UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_allow_modify            OUT      UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_active                  OUT      UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_lc                      OUT      UNAPIGEN.VC2_TABLE_TYPE,      /* VC2_TABLE_TYPE */
 a_lc_version              OUT      UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_ss                      OUT      UNAPIGEN.VC2_TABLE_TYPE,      /* VC2_TABLE_TYPE */
 a_nr_of_rows              IN OUT   NUMBER,                       /* NUM_TYPE */
 a_order_by_clause         IN       VARCHAR2,                     /* VC255_TYPE */
 a_next_rows               IN       NUMBER)                       /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetWtRows
(a_wt               OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_version          OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_rownr            OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_st               OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_st_version       OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_sc               OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_sc_create        OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_nr_of_rows       IN OUT NUMBER,                      /* NUM_TYPE */
 a_where_clause     IN     VARCHAR2,                    /* VC511_TYPE */
 a_next_rows        IN     NUMBER)                      /* NUM_TYPE */
RETURN NUMBER;

FUNCTION SaveWorksheetType
(a_wt                 IN  VARCHAR2,                       /* VC20_TYPE */
 a_version            IN  VARCHAR2,                       /* VC20_TYPE */
 a_version_is_current IN  CHAR,                           /* CHAR1_TYPE */
 a_effective_from     IN  DATE,                           /* DATE_TYPE */
 a_effective_till     IN  DATE,                           /* DATE_TYPE */
 a_description        IN  VARCHAR2,                       /* VC40_TYPE */
 a_description2       IN  VARCHAR2,                       /* VC40_TYPE */
 a_min_rows           IN  NUMBER,                         /* NUM_TYPE */
 a_max_rows           IN  NUMBER,                         /* NUM_TYPE */
 a_valid_cf           IN  VARCHAR2,                       /* VC20_TYPE */
 a_descr_doc          IN  VARCHAR2,                       /* VC40_TYPE */
 a_descr_doc_version  IN  VARCHAR2,                       /* VC20_TYPE */
 a_ws_ly              IN  VARCHAR2,                       /* VC20_TYPE */
 a_ws_uc              IN  VARCHAR2,                       /* VC20_TYPE */
 a_ws_uc_version      IN  VARCHAR2,                       /* VC20_TYPE */
 a_ws_lc              IN  VARCHAR2,                       /* VC2_TYPE */
 a_ws_lc_version      IN  VARCHAR2,                       /* VC20_TYPE */
 a_inherit_au         IN  CHAR,                           /* CHAR1_TYPE */
 a_wt_class           IN  VARCHAR2,                       /* VC2_TYPE */
 a_log_hs             IN  CHAR,                           /* CHAR1_TYPE */
 a_lc                 IN  VARCHAR2,                       /* VC2_TYPE */
 a_lc_version         IN  VARCHAR2,                       /* VC20_TYPE */
 a_modify_reason      IN  VARCHAR2)                       /* VC255_TYPE */
RETURN NUMBER;

FUNCTION DeleteWorksheetType
(a_wt            IN  VARCHAR2,                          /* VC20_TYPE */
 a_version       IN  VARCHAR2,                          /* VC20_TYPE */
 a_modify_reason IN  VARCHAR2)                          /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SaveWtRows
(a_wt               IN    VARCHAR2,                   /* VC20_TYPE */
 a_version          IN    VARCHAR2,                   /* VC20_TYPE */
 a_rownr            IN    UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_st               IN    UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_st_version       IN    UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_sc               IN    UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_sc_create        IN    UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_nr_of_rows       IN    NUMBER,                     /* NUM_TYPE */
 a_next_rows        IN    NUMBER,                     /* NUM_TYPE */
 a_modify_reason    IN    VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

END unapiwt;
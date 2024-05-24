create or replace PACKAGE
-- Unilab 6.7 Package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapidc AS

/* SelectDocument FROM and WHERE clause variable, used in GetDcGroupKey and GetDcAttribute */
P_SELECTION_CLAUSE               VARCHAR2(4000);
P_SELECTION_VAL_TAB              VC40_NESTEDTABLE_TYPE := VC40_NESTEDTABLE_TYPE();

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION GetDocumentList
(a_dc                      OUT      UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_version                 OUT      UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_description             OUT      UNAPIGEN.VC80_TABLE_TYPE, /* VC80_TABLE_TYPE */
 a_ss                      OUT      UNAPIGEN.VC2_TABLE_TYPE,  /* VC2_TABLE_TYPE */
 a_nr_of_rows              IN OUT   NUMBER,                   /* NUM_TYPE */
 a_where_clause            IN       VARCHAR2,                 /* VC511_TYPE */
 a_next_rows               IN       NUMBER)                   /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetDocument
(a_dc                      IN   VARCHAR2,     /* VC40_TYPE */
 a_version                 IN OUT  VARCHAR2,     /* VC20_TYPE */
 a_version_is_current      OUT  CHAR,         /* CHAR1_TYPE */
 a_effective_from          OUT  DATE,         /* DATE_TYPE */
 a_effective_till          OUT  DATE,         /* DATE_TYPE */
 a_description             OUT  VARCHAR2,     /* VC80_TYPE */
 a_creation_date           OUT  DATE,         /* DATE_TYPE */
 a_created_by              OUT  VARCHAR2,     /* VC20_TYPE */
 a_tooltip                 OUT  VARCHAR2,     /* VC255_TYPE */
 a_url                     OUT  VARCHAR2,     /* VC512_TYPE */
 a_data                    OUT  BLOB,         /* BLOB_TYPE */
 a_last_checkout_by        OUT  VARCHAR2,     /* VC20_TYPE */
 a_last_checkout_url       OUT  VARCHAR2,     /* VC512_TYPE */
 a_checked_out             OUT  CHAR,         /* CHAR1_TYPE */
 a_dc_class                OUT  VARCHAR2,     /* VC2_TYPE */
 a_log_hs                  OUT  CHAR,         /* CHAR1_TYPE */
 a_allow_modify            OUT  CHAR,         /* CHAR1_TYPE */
 a_active                  OUT  CHAR,         /* CHAR1_TYPE */
 a_lc                      OUT  VARCHAR2,     /* VC2_TYPE */
 a_lc_version              OUT  VARCHAR2,     /* VC20_TYPE */
 a_ss                      OUT  VARCHAR2)     /* VC2_TYPE */
RETURN NUMBER;

FUNCTION GetDocument
(a_dc                      OUT  UNAPIGEN.VC40_TABLE_TYPE,     /* VC40_TABLE_TYPE */
 a_version                 OUT  UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_version_is_current      OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_effective_from          OUT  UNAPIGEN.DATE_TABLE_TYPE,     /* DATE_TABLE_TYPE */
 a_effective_till          OUT  UNAPIGEN.DATE_TABLE_TYPE,     /* DATE_TABLE_TYPE */
 a_description             OUT  UNAPIGEN.VC80_TABLE_TYPE,     /* VC80_TABLE_TYPE */
 a_creation_date           OUT  UNAPIGEN.DATE_TABLE_TYPE,     /* DATE_TABLE_TYPE */
 a_created_by              OUT  UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_tooltip                 OUT  UNAPIGEN.VC255_TABLE_TYPE,    /* VC255_TABLE_TYPE */
 a_url                     OUT  UNAPIGEN.VC512_TABLE_TYPE,    /* VC512_TABLE_TYPE */
 a_last_checkout_by        OUT  UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_last_checkout_url       OUT  UNAPIGEN.VC512_TABLE_TYPE,    /* VC512_TABLE_TYPE */
 a_checked_out             OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_dc_class                OUT  UNAPIGEN.VC2_TABLE_TYPE,      /* VC2_TABLE_TYPE */
 a_log_hs                  OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_allow_modify            OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_active                  OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_lc                      OUT  UNAPIGEN.VC2_TABLE_TYPE,      /* VC2_TABLE_TYPE */
 a_lc_version              OUT  UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_ss                      OUT  UNAPIGEN.VC2_TABLE_TYPE,      /* VC2_TABLE_TYPE */
 a_nr_of_rows              IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause            IN   VARCHAR2)                     /* VC511_TYPE */
RETURN NUMBER;

FUNCTION SelectDocument
(a_col_id                  IN   UNAPIGEN.VC40_TABLE_TYPE,     /* VC40_TABLE_TYPE */
 a_col_tp                  IN   UNAPIGEN.VC40_TABLE_TYPE,     /* VC40_TABLE_TYPE */
 a_col_value               IN   UNAPIGEN.VC40_TABLE_TYPE,     /* VC40_TABLE_TYPE */
 a_col_nr_of_rows          IN      NUMBER,                    /* NUM_TYPE */
 a_dc                      OUT  UNAPIGEN.VC40_TABLE_TYPE,     /* VC40_TABLE_TYPE */
 a_version                 OUT  UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_version_is_current      OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_effective_from          OUT  UNAPIGEN.DATE_TABLE_TYPE,     /* DATE_TABLE_TYPE */
 a_effective_till          OUT  UNAPIGEN.DATE_TABLE_TYPE,     /* DATE_TABLE_TYPE */
 a_description             OUT  UNAPIGEN.VC80_TABLE_TYPE,     /* VC80_TABLE_TYPE */
 a_creation_date           OUT  UNAPIGEN.DATE_TABLE_TYPE,     /* DATE_TABLE_TYPE */
 a_created_by              OUT  UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_tooltip                 OUT  UNAPIGEN.VC255_TABLE_TYPE,    /* VC255_TABLE_TYPE */
 a_url                     OUT  UNAPIGEN.VC512_TABLE_TYPE,    /* VC512_TABLE_TYPE */
 a_last_checkout_by        OUT  UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_last_checkout_url       OUT  UNAPIGEN.VC512_TABLE_TYPE,    /* VC512_TABLE_TYPE */
 a_checked_out             OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_dc_class                OUT  UNAPIGEN.VC2_TABLE_TYPE,      /* VC2_TABLE_TYPE */
 a_log_hs                  OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_allow_modify            OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_active                  OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_lc                      OUT  UNAPIGEN.VC2_TABLE_TYPE,      /* VC2_TABLE_TYPE */
 a_lc_version              OUT  UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_ss                      OUT  UNAPIGEN.VC2_TABLE_TYPE,      /* VC2_TABLE_TYPE */
 a_nr_of_rows              IN OUT  NUMBER,                    /* NUM_TYPE */
 a_order_by_clause         IN   VARCHAR2,                     /* VC255_TYPE */
 a_next_rows               IN   NUMBER)                       /* NUM_TYPE */
RETURN NUMBER;

FUNCTION SelectDocument
(a_col_id                  IN   UNAPIGEN.VC40_TABLE_TYPE,     /* VC40_TABLE_TYPE */
 a_col_tp                  IN   UNAPIGEN.VC40_TABLE_TYPE,     /* VC40_TABLE_TYPE */
 a_col_value               IN   UNAPIGEN.VC40_TABLE_TYPE,     /* VC40_TABLE_TYPE */
 a_col_operator            IN   UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_col_andor               IN   UNAPIGEN.VC3_TABLE_TYPE,      /* VC3_TABLE_TYPE */
 a_col_nr_of_rows          IN      NUMBER,                    /* NUM_TYPE */
 a_dc                      OUT  UNAPIGEN.VC40_TABLE_TYPE,     /* VC40_TABLE_TYPE */
 a_version                 OUT  UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_version_is_current      OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_effective_from          OUT  UNAPIGEN.DATE_TABLE_TYPE,     /* DATE_TABLE_TYPE */
 a_effective_till          OUT  UNAPIGEN.DATE_TABLE_TYPE,     /* DATE_TABLE_TYPE */
 a_description             OUT  UNAPIGEN.VC80_TABLE_TYPE,     /* VC80_TABLE_TYPE */
 a_creation_date           OUT  UNAPIGEN.DATE_TABLE_TYPE,     /* DATE_TABLE_TYPE */
 a_created_by              OUT  UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_tooltip                 OUT  UNAPIGEN.VC255_TABLE_TYPE,    /* VC255_TABLE_TYPE */
 a_url                     OUT  UNAPIGEN.VC512_TABLE_TYPE,    /* VC512_TABLE_TYPE */
 a_last_checkout_by        OUT  UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_last_checkout_url       OUT  UNAPIGEN.VC512_TABLE_TYPE,    /* VC512_TABLE_TYPE */
 a_checked_out             OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_dc_class                OUT  UNAPIGEN.VC2_TABLE_TYPE,      /* VC2_TABLE_TYPE */
 a_log_hs                  OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_allow_modify            OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_active                  OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_lc                      OUT  UNAPIGEN.VC2_TABLE_TYPE,      /* VC2_TABLE_TYPE */
 a_lc_version              OUT  UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_ss                      OUT  UNAPIGEN.VC2_TABLE_TYPE,      /* VC2_TABLE_TYPE */
 a_nr_of_rows              IN OUT  NUMBER,                    /* NUM_TYPE */
 a_order_by_clause         IN   VARCHAR2,                     /* VC255_TYPE */
 a_next_rows               IN   NUMBER)                       /* NUM_TYPE */
RETURN NUMBER;

FUNCTION SelectDcGkValues
(a_col_id           IN      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_col_tp           IN      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_col_value        IN      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_col_nr_of_rows   IN      NUMBER,                    /* NUM_TYPE */
 a_gk               IN      VARCHAR2,                  /* VC20_TYPE */
 a_value            OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_nr_of_rows       IN OUT  NUMBER,                    /* NUM_TYPE */
 a_order_by_clause  IN      VARCHAR2,                  /* VC255_TYPE */
 a_next_rows        IN      NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION SelectDcGkValues
(a_col_id           IN      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_col_tp           IN      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_col_value        IN      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_col_operator     IN      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_col_andor        IN      UNAPIGEN.VC3_TABLE_TYPE,   /* VC3_TABLE_TYPE */
 a_col_nr_of_rows   IN      NUMBER,                    /* NUM_TYPE */
 a_gk               IN      VARCHAR2,                  /* VC20_TYPE */
 a_value            OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_nr_of_rows       IN OUT  NUMBER,                    /* NUM_TYPE */
 a_order_by_clause  IN      VARCHAR2,                  /* VC255_TYPE */
 a_next_rows        IN      NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION SelectDcPropValues
(a_col_id           IN      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_col_tp           IN      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_col_value        IN      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_col_nr_of_rows   IN      NUMBER,                    /* NUM_TYPE */
 a_prop             IN      VARCHAR2,                  /* VC20_TYPE */
 a_value            OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_nr_of_rows       IN OUT  NUMBER,                    /* NUM_TYPE */
 a_order_by_clause  IN      VARCHAR2,                  /* VC255_TYPE */
 a_next_rows        IN      NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION SelectDcPropValues
(a_col_id           IN      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_col_tp           IN      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_col_value        IN      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_col_operator     IN      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_col_andor        IN      UNAPIGEN.VC3_TABLE_TYPE,   /* VC3_TABLE_TYPE */
 a_col_nr_of_rows   IN      NUMBER,                    /* NUM_TYPE */
 a_prop             IN      VARCHAR2,                  /* VC20_TYPE */
 a_value            OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_nr_of_rows       IN OUT  NUMBER,                    /* NUM_TYPE */
 a_order_by_clause  IN      VARCHAR2,                  /* VC255_TYPE */
 a_next_rows        IN      NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION SaveDocument
(a_dc                 IN  VARCHAR2,                  /* VC40_TYPE */
 a_version            IN  VARCHAR2,                  /* VC20_TYPE */
 a_version_is_current IN  CHAR,                      /* CHAR1_TYPE */
 a_effective_from     IN  DATE,                      /* DATE_TYPE */
 a_effective_till     IN  DATE,                      /* DATE_TYPE */
 a_description        IN  VARCHAR2,                  /* VC80_TYPE */
 a_creation_date      IN  VARCHAR2,                  /* DATE_TYPE */
 a_created_by         IN  VARCHAR2,                  /* VC20_TYPE */
 a_tooltip            IN  VARCHAR2,                  /* VC255_TYPE */
 a_url                IN  VARCHAR2,                  /* VC512_TYPE */
 a_data               IN  BLOB,                      /* BLOB_TYPE */
 a_last_checkout_by   IN  VARCHAR2,                  /* VC20_TYPE */
 a_last_checkout_url  IN  VARCHAR2,                  /* VC512_TYPE */
 a_checked_out        IN  VARCHAR2,                  /* CHAR1_TYPE */
 a_dc_class           IN  VARCHAR2,                  /* VC2_TYPE */
 a_log_hs             IN OUT CHAR,                      /* CHAR1_TYPE */
 a_lc                 IN OUT  VARCHAR2,                  /* VC2_TYPE */
 a_lc_version         IN OUT VARCHAR2,                  /* VC20_TYPE */
 a_modify_reason      IN  VARCHAR2)                  /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SaveDocument
(a_dc                 IN  VARCHAR2,                  /* VC40_TYPE */
 a_version            IN  VARCHAR2,                  /* VC20_TYPE */
 a_version_is_current IN  CHAR,                      /* CHAR1_TYPE */
 a_effective_from     IN  DATE,                      /* DATE_TYPE */
 a_effective_till     IN  DATE,                      /* DATE_TYPE */
 a_description        IN  VARCHAR2,                  /* VC80_TYPE */
 a_creation_date      IN  VARCHAR2,                  /* DATE_TYPE */
 a_created_by         IN  VARCHAR2,                  /* VC20_TYPE */
 a_tooltip            IN  VARCHAR2,                  /* VC255_TYPE */
 a_url                IN  VARCHAR2,                  /* VC512_TYPE */
 a_last_checkout_by   IN  VARCHAR2,                  /* VC20_TYPE */
 a_last_checkout_url  IN  VARCHAR2,                  /* VC512_TYPE */
 a_checked_out        IN  VARCHAR2,                  /* CHAR1_TYPE */
 a_dc_class           IN  VARCHAR2,                  /* VC2_TYPE */
 a_log_hs             IN OUT CHAR,                      /* CHAR1_TYPE */
 a_lc                 IN OUT VARCHAR2,                  /* VC2_TYPE */
 a_lc_version         IN OUT VARCHAR2,                  /* VC20_TYPE */
 a_modify_reason      IN  VARCHAR2)                  /* VC255_TYPE */
RETURN NUMBER;

FUNCTION CreateNewDocumentVersion
(a_dc                 IN  VARCHAR2,                  /* VC40_TYPE */
 a_ref_version        IN  VARCHAR2,                  /* VC20_TYPE */
 a_new_version        IN  VARCHAR2,                  /* VC20_TYPE */
 a_effective_from     IN  DATE,                      /* DATE_TYPE */
 a_creation_date      IN  VARCHAR2,                  /* DATE_TYPE */
 a_created_by         IN  VARCHAR2,                  /* VC20_TYPE */
 a_modify_reason      IN  VARCHAR2)                  /* VC255_TYPE */
RETURN NUMBER;

FUNCTION DeleteDocument
(a_dc            IN  VARCHAR2,          /* VC40_TYPE */
 a_version       IN  VARCHAR2,          /* VC20_TYPE */
 a_modify_reason IN  VARCHAR2)          /* VC255_TYPE */
RETURN NUMBER;


END unapidc;
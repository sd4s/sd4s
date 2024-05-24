create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapiau AS

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION GetAttributeList
(a_au                  OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_version             OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_version_is_current  OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_effective_from      OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_effective_till      OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_description         OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_ss                  OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_nr_of_rows          IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause        IN      VARCHAR2,                  /* VC511_TYPE */
 a_next_rows           IN      NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetAttribute
(a_au                 OUT   UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_version            OUT   UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_version_is_current OUT   UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_effective_from     OUT   UNAPIGEN.DATE_TABLE_TYPE,   /* DATE_TABLE_TYPE */
 a_effective_till     OUT   UNAPIGEN.DATE_TABLE_TYPE,   /* DATE_TABLE_TYPE */
 a_description        OUT   UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_description2       OUT   UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_is_protected       OUT   UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_single_valued      OUT   UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_new_val_allowed    OUT   UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_store_db           OUT   UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_inherit_au         OUT   UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_shortcut           OUT   UNAPIGEN.RAW8_TABLE_TYPE,   /* RAW8_TABLE_TYPE */
 a_value_list_tp      OUT   UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_default_value      OUT   UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_run_mode           OUT   UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_service            OUT   UNAPIGEN.VC255_TABLE_TYPE,  /* VC255_TABLE_TYPE */
 a_cf_value           OUT   UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_au_class           OUT   UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_log_hs             OUT   UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_allow_modify       OUT   UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_active             OUT   UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_lc                 OUT   UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_lc_version         OUT   UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_ss                 OUT   UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_nr_of_rows         IN OUT  NUMBER,                   /* NUM_TYPE */
 a_where_clause       IN      VARCHAR2)                 /* VC511_TYPE */
RETURN NUMBER;

-- C++ working with OO4O has difficulties to handle RAW-values => RAW becomes VARCHAR2.
FUNCTION GetAttribute
(a_au                 OUT   UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_version            OUT   UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_version_is_current OUT   UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_effective_from     OUT   UNAPIGEN.DATE_TABLE_TYPE,   /* DATE_TABLE_TYPE */
 a_effective_till     OUT   UNAPIGEN.DATE_TABLE_TYPE,   /* DATE_TABLE_TYPE */
 a_description        OUT   UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_description2       OUT   UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_is_protected       OUT   UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_single_valued      OUT   UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_new_val_allowed    OUT   UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_store_db           OUT   UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_inherit_au         OUT   UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_alt                OUT   UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_ctrl               OUT   UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_shift              OUT   UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_key_name           OUT   UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_value_list_tp      OUT   UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_default_value      OUT   UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_run_mode           OUT   UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_service            OUT   UNAPIGEN.VC255_TABLE_TYPE,  /* VC255_TABLE_TYPE */
 a_cf_value           OUT   UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_au_class           OUT   UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_log_hs             OUT   UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_allow_modify       OUT   UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_active             OUT   UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_lc                 OUT   UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_lc_version         OUT   UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_ss                 OUT   UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_nr_of_rows         IN OUT  NUMBER,                   /* NUM_TYPE */
 a_where_clause       IN      VARCHAR2)                 /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetAttributeSql
(a_au            OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_version       OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_sqltext       OUT     UNAPIGEN.VC255_TABLE_TYPE,  /* VC255_TABLE_TYPE */
 a_nr_of_rows    IN OUT  NUMBER,                     /* NUM_TYPE */
 a_where_clause  IN      VARCHAR2)                   /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetAttributeValue
(a_au               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_version          OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_value            OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_nr_of_rows       IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause     IN      VARCHAR2)                  /* VC511_TYPE */
 RETURN NUMBER;

FUNCTION GetAttributeValues
(a_object_tp       IN     VARCHAR2,                   /* VC4_TYPE */
 a_object_id       IN     VARCHAR2,                   /* VC20_TYPE */
 a_au              IN     VARCHAR2,                   /* VC20_TYPE */
 a_value           OUT    UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_nr_of_rows      IN OUT NUMBER)                     /* NUM_TYPE */
RETURN NUMBER;

FUNCTION DeleteAttribute
(a_au               IN     VARCHAR2,                   /* VC20_TYPE */
 a_version          IN     VARCHAR2,                   /* VC20_TYPE */
 a_modify_reason    IN     VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SaveAttribute
(a_au                   IN   VARCHAR2,                    /* VC20_TYPE */
 a_version              IN   VARCHAR2,                    /* VC20_TYPE */
 a_version_is_current   IN   CHAR,                        /* CHAR1_TYPE */
 a_effective_from       IN   DATE,                        /* DATE_TYPE */
 a_effective_till       IN   DATE,                        /* DATE_TYPE */
 a_description          IN   VARCHAR2,                    /* VC40_TYPE */
 a_description2         IN   VARCHAR2,                    /* VC40_TYPE */
 a_is_protected         IN   CHAR,                        /* CHAR1_TYPE */
 a_single_valued        IN   CHAR,                        /* CHAR1_TYPE */
 a_new_val_allowed      IN   CHAR,                        /* CHAR1_TYPE */
 a_store_db             IN   CHAR,                        /* CHAR1_TYPE */
 a_inherit_au           IN   CHAR,                        /* CHAR1_TYPE */
 a_shortcut             IN   RAW,                         /* RAW8_TYPE */
 a_value_list_tp        IN   CHAR,                        /* CHAR1_TYPE */
 a_default_value        IN   VARCHAR2,                    /* VC40_TYPE */
 a_run_mode             IN   CHAR,                        /* CHAR1_TYPE */
 a_service              IN   VARCHAR2,                    /* VC255_TYPE */
 a_cf_value             IN   VARCHAR2,                    /* VC20_TYPE */
 a_au_class             IN   VARCHAR2,                    /* VC2_TYPE */
 a_log_hs               IN   CHAR,                        /* CHAR1_TYPE */
 a_lc                   IN   VARCHAR2,                    /* VC2_TYPE */
 a_lc_version           IN   VARCHAR2,                    /* VC20_TYPE */
 a_modify_reason        IN   VARCHAR2)                    /* VC255_TYPE */
 RETURN NUMBER;

-- C++ working with OO4O has difficulties to handle RAW-values => RAW becomes VARCHAR2.
FUNCTION SaveAttribute
(a_au                   IN   VARCHAR2,                    /* VC20_TYPE */
 a_version              IN   VARCHAR2,                    /* VC20_TYPE */
 a_version_is_current   IN   CHAR,                        /* CHAR1_TYPE */
 a_effective_from       IN   DATE,                        /* DATE_TYPE */
 a_effective_till       IN   DATE,                        /* DATE_TYPE */
 a_description          IN   VARCHAR2,                    /* VC40_TYPE */
 a_description2         IN   VARCHAR2,                    /* VC40_TYPE */
 a_is_protected         IN   CHAR,                        /* CHAR1_TYPE */
 a_single_valued        IN   CHAR,                        /* CHAR1_TYPE */
 a_new_val_allowed      IN   CHAR,                        /* CHAR1_TYPE */
 a_store_db             IN   CHAR,                        /* CHAR1_TYPE */
 a_inherit_au           IN   CHAR,                        /* CHAR1_TYPE */
 a_alt                  IN   CHAR,                        /* CHAR1_TYPE */
 a_ctrl                 IN   CHAR,                        /* CHAR1_TYPE */
 a_shift                IN   CHAR,                        /* CHAR1_TYPE */
 a_key_name             IN   VARCHAR2,                    /* VC20_TYPE */
 a_value_list_tp        IN   CHAR,                        /* CHAR1_TYPE */
 a_default_value        IN   VARCHAR2,                    /* VC40_TYPE */
 a_run_mode             IN   CHAR,                        /* CHAR1_TYPE */
 a_service              IN   VARCHAR2,                    /* VC255_TYPE */
 a_cf_value             IN   VARCHAR2,                    /* VC20_TYPE */
 a_au_class             IN   VARCHAR2,                    /* VC2_TYPE */
 a_log_hs               IN   CHAR,                        /* CHAR1_TYPE */
 a_lc                   IN   VARCHAR2,                    /* VC2_TYPE */
 a_lc_version           IN   VARCHAR2,                    /* VC20_TYPE */
 a_modify_reason        IN   VARCHAR2)                    /* VC255_TYPE */
 RETURN NUMBER;

FUNCTION SaveAttributeSql
(a_au               IN   VARCHAR2,                    /* VC20_TYPE */
 a_version          IN   VARCHAR2,                    /* VC20_TYPE */
 a_sqltext          IN   UNAPIGEN.VC255_TABLE_TYPE,   /* VC255_TABLE_TYPE */
 a_nr_of_rows       IN   NUMBER,                      /* NUM_TYPE */
 a_modify_reason    IN   VARCHAR2)                    /* VC255_TYPE */
 RETURN NUMBER;

FUNCTION SaveAttributeValue
(a_au               IN   VARCHAR2,                    /* VC20_TYPE */
 a_version          IN   VARCHAR2,                    /* VC20_TYPE */
 a_value            IN   UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_nr_of_rows       IN   NUMBER,                      /* NUM_TYPE */
 a_modify_reason    IN   VARCHAR2)                    /* VC255_TYPE */
 RETURN NUMBER;

END unapiau;
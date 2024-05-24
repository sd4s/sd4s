create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
pbapitk AS

TYPE BOOLEAN_TABLE_TYPE IS TABLE OF BOOLEAN INDEX BY BINARY_INTEGER;

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION GetTask
(a_tk_tp            IN      VARCHAR2,                    /* VC20_TYPE */
 a_tk               IN      VARCHAR2,                    /* VC20_TYPE */
 a_description      OUT     VARCHAR2,                    /* VC40_TYPE */
 a_col_id           OUT     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_col_tp           OUT     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_disp_title       OUT     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_def_val          OUT     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_hidden           OUT     PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_is_protected     OUT     PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_mandatory        OUT     PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_auto_refresh     OUT     PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_col_asc          OUT     PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_value_list_tp    OUT     PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_dsp_len          OUT     UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE + INDICATOR */
 a_nr_of_rows       IN OUT  NUMBER)                      /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetTask
(a_tk_tp            IN      VARCHAR2,                    /* VC20_TYPE */
 a_tk               IN      VARCHAR2,                    /* VC20_TYPE */
 a_description      OUT     VARCHAR2,                    /* VC40_TYPE */
 a_col_id           OUT     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_col_tp           OUT     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_disp_title       OUT     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_operator         OUT     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_def_val          OUT     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_andor            OUT     UNAPIGEN.VC3_TABLE_TYPE,     /* VC3_TABLE_TYPE */
 a_hidden           OUT     PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_is_protected     OUT     PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_mandatory        OUT     PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_auto_refresh     OUT     PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_col_asc          OUT     PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_value_list_tp    OUT     PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_operator_protect OUT     PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_andor_protect    OUT     PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_dsp_len          OUT     UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE + INDICATOR */
 a_nr_of_rows       IN OUT  NUMBER)                      /* NUM_TYPE */
RETURN NUMBER;

FUNCTION SaveTask
(a_tk_tp          IN     VARCHAR2,                    /* VC20_TYPE */
 a_tk             IN     VARCHAR2,                    /* VC20_TYPE */
 a_description    IN     VARCHAR2,                    /* VC40_TYPE */
 a_col_id         IN     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_col_tp         IN     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_def_val        IN     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_hidden         IN     PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_is_protected   IN     PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_mandatory      IN     PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_auto_refresh   IN     PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_col_asc        IN     PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_value_list_tp  IN     PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_dsp_len        IN     UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE + INDICATOR */
 a_nr_of_rows     IN     NUMBER,                      /* NUM_TYPE */
 a_modify_reason  IN     VARCHAR2)                    /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SaveTask
(a_tk_tp             IN     VARCHAR2,                    /* VC20_TYPE */
 a_tk                IN     VARCHAR2,                    /* VC20_TYPE */
 a_description       IN     VARCHAR2,                    /* VC40_TYPE */
 a_col_id            IN     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_col_tp            IN     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_disp_title        IN     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_operator          IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_def_val           IN     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_andor             IN     UNAPIGEN.VC3_TABLE_TYPE,     /* VC3_TABLE_TYPE */
 a_hidden            IN     PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_is_protected      IN     PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_mandatory         IN     PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_auto_refresh      IN     PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_col_asc           IN     PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_value_list_tp     IN     PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_operator_protect  IN     PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_andor_protect     IN     PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_dsp_len           IN     UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE + INDICATOR */
 a_nr_of_rows        IN     NUMBER,                      /* NUM_TYPE */
 a_modify_reason     IN     VARCHAR2)                    /* VC255_TYPE */
RETURN NUMBER;

END pbapitk;
create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapitk AS

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION GetUiComponent
(a_component_tp    OUT    UNAPIGEN.VC4_TABLE_TYPE,  /* VC4_TABLE_TYPE */
 a_component_id    OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_col_tp          OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_disp_title      OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_nr_of_rows      IN OUT NUMBER,                   /* NUM_TYPE */
 a_where_clause    IN     VARCHAR2)                 /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetOtDetails
(a_col_tp          OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_col_id          OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_col_len         OUT    UNAPIGEN.NUM_TABLE_TYPE,  /* NUM_TABLE_TYPE */
 a_disp_tp         OUT    UNAPIGEN.NUM_TABLE_TYPE,  /* NUM_TABLE_TYPE */
 a_disp_title      OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_disp_style      OUT    UNAPIGEN.NUM_TABLE_TYPE,  /* NUM_TABLE_TYPE */
 a_disp_width      OUT    UNAPIGEN.NUM_TABLE_TYPE,  /* NUM_TABLE_TYPE */
 a_disp_format     OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_nr_of_rows      IN OUT NUMBER,                   /* NUM_TYPE */
 a_where_clause    IN     VARCHAR2)                 /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetTaskList
(a_tk_tp        IN     VARCHAR2,                   /* VC20_TYPE */
 a_tk           OUT    UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_description  OUT    UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_nr_of_rows   IN OUT NUMBER,                     /* NUM_TYPE */
 a_next_rows    IN     NUMBER)                     /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetTask
(a_tk_tp            IN      VARCHAR2,                    /* VC20_TYPE */
 a_tk               IN      VARCHAR2,                    /* VC20_TYPE */
 a_description      OUT     VARCHAR2,                    /* VC40_TYPE */
 a_col_id           OUT     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_col_tp           OUT     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_disp_title       OUT     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_def_val          OUT     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_hidden           OUT     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_is_protected     OUT     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_mandatory        OUT     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_auto_refresh     OUT     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_col_asc          OUT     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_value_list_tp    OUT     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
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
 a_hidden         IN     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_is_protected   IN     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_mandatory      IN     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_auto_refresh   IN     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_col_asc        IN     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_value_list_tp  IN     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_dsp_len        IN     UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE + INDICATOR */
 a_nr_of_rows     IN     NUMBER,                      /* NUM_TYPE */
 a_modify_reason  IN     VARCHAR2)                    /* VC255_TYPE */
RETURN NUMBER;

FUNCTION DeleteTask
(a_tk_tp         IN  VARCHAR2,                       /* VC20_TYPE */
 a_tk            IN  VARCHAR2,                       /* VC20_TYPE */
 a_modify_reason IN  VARCHAR2)                       /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GetTkPref
(a_tk_tp            OUT    UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_tk               OUT    UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_pref_name        OUT    UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_pref_value       OUT    UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_applicable_obj   OUT    UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_category         OUT    UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_description      OUT    UNAPIGEN.VC255_TABLE_TYPE,  /* VC255_TABLE_TYPE */
 a_nr_of_rows       IN OUT NUMBER,                     /* NUM_TYPE */
 a_where_clause     IN     VARCHAR2)                   /* VC511_TYPE */
RETURN NUMBER;

FUNCTION SaveTkPref
(a_tk_tp          IN   VARCHAR2,                     /* VC20_TYPE */
 a_tk             IN   VARCHAR2,                     /* VC20_TYPE */
 a_pref_name      IN   UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_pref_value     IN   UNAPIGEN.VC40_TABLE_TYPE,     /* VC40_TABLE_TYPE */
 a_nr_of_rows     IN   NUMBER,                       /* NUM_TYPE */
 a_modify_reason  IN   VARCHAR2)                     /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GetPrefValue
(a_pref_tp          OUT    UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_pref_name        OUT    UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_pref_value       OUT    UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_nr_of_rows       IN OUT NUMBER,                     /* NUM_TYPE */
 a_where_clause     IN     VARCHAR2)                   /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetTaskSql
(a_tk_tp          IN     VARCHAR2,                    /* VC20_TYPE */
 a_tk             IN     VARCHAR2,                    /* VC20_TYPE */
 a_col_id         IN     VARCHAR2,                    /* VC40_TYPE */
 a_col_tp         IN     VARCHAR2,                    /* VC40_TYPE */
 a_sqltext        OUT    UNAPIGEN.VC255_TABLE_TYPE,   /* VC255_TABLE_TYPE */
 a_nr_of_rows     IN OUT NUMBER)                      /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SaveTaskSql
(a_tk_tp          IN     VARCHAR2,                    /* VC20_TYPE */
 a_tk             IN     VARCHAR2,                    /* VC20_TYPE */
 a_col_id         IN     VARCHAR2,                    /* VC40_TYPE */
 a_col_tp         IN     VARCHAR2,                    /* VC40_TYPE */
 a_sqltext        IN     UNAPIGEN.VC255_TABLE_TYPE,   /* VC255_TABLE_TYPE */
 a_nr_of_rows     IN     NUMBER,                       /* NUM_TYPE */
 a_modify_reason  IN     VARCHAR2)                      /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SelectCustomSQLValues
(a_tk_tp            IN      VARCHAR2,                    /* VC20_TYPE */
 a_tk               IN      VARCHAR2,                    /* VC20_TYPE */
 a_col_id           IN      UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_col_tp           IN      UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_col_value        IN      UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_col_nr_of_rows   IN      NUMBER,       /* NUM_TYPE */
 a_col_id4customsql IN      VARCHAR2,                    /* VC40_TYPE */
 a_col_tp4customsql IN      VARCHAR2,                    /* VC40_TYPE */
 a_value   OUT  UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_nr_of_rows       IN OUT  NUMBER,                      /* NUM_TYPE */
 a_order_by_clause  IN      VARCHAR2,                    /* VC255_TYPE */
 a_next_rows        IN      NUMBER)                      /* NUM_TYPE */
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
 a_hidden           OUT     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_is_protected     OUT     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_mandatory        OUT     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_auto_refresh     OUT     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_col_asc          OUT     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_value_list_tp    OUT     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_operator_protect OUT     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_andor_protect    OUT     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_dsp_len          OUT     UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE + INDICATOR */
 a_nr_of_rows       IN OUT  NUMBER)                      /* NUM_TYPE */
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
 a_andor             IN     UNAPIGEN.VC3_TABLE_TYPE,      /* VC3_TABLE_TYPE */
 a_hidden            IN     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_is_protected      IN     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_mandatory         IN     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_auto_refresh      IN     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_col_asc           IN     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_value_list_tp     IN     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_operator_protect  IN     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_andor_protect     IN     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_dsp_len           IN     UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE + INDICATOR */
 a_nr_of_rows        IN     NUMBER,                      /* NUM_TYPE */
 a_modify_reason     IN     VARCHAR2)                    /* VC255_TYPE */
RETURN NUMBER;

END unapitk;
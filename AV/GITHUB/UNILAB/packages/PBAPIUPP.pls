create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
pbapiupp AS

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION GetQualification                              /* INTERNAL */
(a_qualification    OUT    UNAPIGEN.VC1_TABLE_TYPE,    /* VC1_TABLE_TYPE */
 a_description      OUT    UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_nr_of_rows       IN OUT NUMBER,                     /* NUM_TYPE */
 a_where_clause     IN     VARCHAR2)                   /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetFuncAccess
(a_applic            OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_description       OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_topic             OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_topic_description OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_fa                OUT    UNAPIGEN.VC1_TABLE_TYPE,    /* VC1_TABLE_TYPE */
 a_nr_of_rows        IN OUT NUMBER,                   /* NUM_TYPE */
 a_where_clause      IN     VARCHAR2)                 /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetUpFuncList
(a_up_in             IN     NUMBER,                   /* LONG_TYPE */
 a_up                OUT    UNAPIGEN.LONG_TABLE_TYPE, /* LONG_TABLE_TYPE */
 a_applic            OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_description       OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_fa                OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_inherit_fa        OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_nr_of_rows        IN OUT NUMBER)                   /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetUpFuncDetails
(a_up_in             IN     NUMBER,                   /* LONG_TYPE */
 a_applic_in         IN     VARCHAR2,                 /* VC20_TYPE */
 a_up                OUT    UNAPIGEN.LONG_TABLE_TYPE, /* LONG_TABLE_TYPE */
 a_applic            OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_description       OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_topic             OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_topic_description OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_fa                OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_inherit_fa        OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_nr_of_rows        IN OUT NUMBER)                   /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetUpUsFuncList
(a_up_in             IN     NUMBER,                   /* LONG_TYPE */
 a_us_in             IN     VARCHAR2,                 /* VC20_TYPE */
 a_up                OUT    UNAPIGEN.LONG_TABLE_TYPE, /* LONG_TABLE_TYPE */
 a_us                OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_applic            OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_description       OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_fa                OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_inherit_fa        OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_nr_of_rows        IN OUT NUMBER)                   /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetUpUsFuncDetails
(a_up_in             IN     NUMBER,                   /* LONG_TYPE */
 a_us_in             IN     VARCHAR2,                 /* VC20_TYPE */
 a_applic_in         IN     VARCHAR2,                 /* VC20_TYPE */
 a_up                OUT    UNAPIGEN.LONG_TABLE_TYPE, /* LONG_TABLE_TYPE */
 a_us                OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_applic            OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_description       OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_topic             OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_topic_description OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_fa                OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_inherit_fa        OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_nr_of_rows        IN OUT NUMBER)                   /* NUM_TYPE */
RETURN NUMBER;

FUNCTION SaveUpFuncList
(a_up                IN     NUMBER,                   /* LONG_TYPE */
 a_applic            IN     UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_fa                IN     UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_inherit_fa        IN     UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_nr_of_rows        IN OUT NUMBER,                   /* NUM_TYPE */
 a_modify_reason     IN     VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SaveUpFuncDetails
(a_up                IN     NUMBER,                   /* LONG_TYPE */
 a_applic            IN     VARCHAR2,                 /* VC20_TYPE */
 a_topic             IN     UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_fa                IN     UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_inherit_fa        IN     UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_nr_of_rows        IN OUT NUMBER,                   /* NUM_TYPE */
 a_modify_reason     IN     VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SaveUpUsFuncList
(a_up                IN     NUMBER,                   /* LONG_TYPE */
 a_us                IN     VARCHAR2,                 /* VC20_TYPE */
 a_applic            IN     UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_fa                IN     UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_inherit_fa        IN     UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_nr_of_rows        IN OUT NUMBER,                   /* NUM_TYPE */
 a_modify_reason     IN     VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SaveUpUsFuncDetails
(a_up                IN     NUMBER,                   /* LONG_TYPE */
 a_us                IN     VARCHAR2,                 /* VC20_TYPE */
 a_applic            IN     VARCHAR2,                 /* VC20_TYPE */
 a_topic             IN     UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_fa                IN     UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_inherit_fa        IN     UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_nr_of_rows        IN OUT NUMBER,                   /* NUM_TYPE */
 a_modify_reason     IN     VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GetUpPref
(a_up_in            IN     NUMBER,                     /* LONG_TYPE */
 a_pref_name_in     IN     VARCHAR2,                   /* VC20_TYPE */
 a_up               OUT    UNAPIGEN.LONG_TABLE_TYPE,   /* LONG_TABLE_TYPE */
 a_pref_name        OUT    UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_pref_value       OUT    UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_inherit_pref     OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_applicable_obj   OUT    UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_category         OUT    UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_description      OUT    UNAPIGEN.VC255_TABLE_TYPE,  /* VC255_TABLE_TYPE */
 a_nr_of_rows       IN OUT NUMBER)                     /* NUM_TYPE */
RETURN NUMBER;

FUNCTION SaveUpPref
(a_up             IN   NUMBER,                       /* LONG_TYPE */
 a_pref_name      IN   UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_pref_value     IN   UNAPIGEN.VC40_TABLE_TYPE,     /* VC40_TABLE_TYPE */
 a_inherit_pref   IN   UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_nr_of_rows     IN   NUMBER,                       /* NUM_TYPE */
 a_modify_reason  IN   VARCHAR2)                     /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GetUpUsPref
(a_up_in            IN     NUMBER,                     /* LONG_TYPE */
 a_us_in            IN     VARCHAR2,                   /* VC20_TYPE */
 a_pref_name_in     IN     VARCHAR2,                   /* VC20_TYPE */
 a_up               OUT    UNAPIGEN.LONG_TABLE_TYPE,   /* LONG_TABLE_TYPE */
 a_us               OUT    UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_pref_name        OUT    UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_pref_value       OUT    UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_inherit_pref     OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_nr_of_rows       IN OUT NUMBER)                     /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetUpUsPref
(a_up_in            IN     NUMBER,                     /* LONG_TYPE */
 a_us_in            IN     VARCHAR2,                   /* VC20_TYPE */
 a_pref_name_in     IN     VARCHAR2,                   /* VC20_TYPE */
 a_up               OUT    UNAPIGEN.LONG_TABLE_TYPE,   /* LONG_TABLE_TYPE */
 a_us               OUT    UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_pref_name        OUT    UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_pref_value       OUT    UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_inherit_pref     OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_applicable_obj   OUT    UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_category         OUT    UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_description      OUT    UNAPIGEN.VC255_TABLE_TYPE,  /* VC255_TABLE_TYPE */
 a_nr_of_rows       IN OUT NUMBER)                     /* NUM_TYPE */
RETURN NUMBER;

FUNCTION SaveUpUsPref
(a_up             IN   NUMBER,                       /* LONG_TYPE */
 a_us             IN   VARCHAR2,                     /* VC20_TYPE */
 a_pref_name      IN   UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_pref_value     IN   UNAPIGEN.VC40_TABLE_TYPE,     /* VC40_TABLE_TYPE */
 a_inherit_pref   IN   UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_nr_of_rows     IN   NUMBER,                       /* NUM_TYPE */
 a_modify_reason  IN   VARCHAR2)                     /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GetUpTaskList
(a_up_in             IN     NUMBER,                   /* LONG_TYPE */
 a_tk_tp_in          IN     VARCHAR2,                 /* VC20_TYPE */
 a_up                OUT    UNAPIGEN.LONG_TABLE_TYPE, /* LONG_TABLE_TYPE */
 a_tk_tp             OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_tk                OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_description       OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_is_enabled        OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_nr_of_rows        IN OUT NUMBER)                   /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetUpTaskDetails
(a_up_in             IN     NUMBER,                   /* LONG_TYPE */
 a_tk_tp_in          IN     VARCHAR2,                 /* VC20_TYPE */
 a_tk_in             IN     VARCHAR2,                 /* VC20_TYPE */
 a_up                OUT    UNAPIGEN.LONG_TABLE_TYPE, /* LONG_TABLE_TYPE */
 a_tk_tp             OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_tk                OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_col_id            OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_col_tp            OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_disp_title        OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_def_val           OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_hidden            OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_is_protected      OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_mandatory         OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_auto_refresh      OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_col_asc           OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_value_list_tp     OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_dsp_len           OUT    UNAPIGEN.NUM_TABLE_TYPE,  /* NUM_TABLE_TYPE + INDICATOR */
 a_inherit_tk        OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_nr_of_rows        IN OUT NUMBER)                   /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetUpTaskDetails
(a_up_in             IN     NUMBER,                      /* LONG_TYPE */
 a_tk_tp_in          IN     VARCHAR2,                    /* VC20_TYPE */
 a_tk_in             IN     VARCHAR2,                    /* VC20_TYPE */
 a_up                OUT    UNAPIGEN.LONG_TABLE_TYPE,    /* LONG_TABLE_TYPE */
 a_tk_tp             OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_tk                OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_col_id            OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_col_tp            OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_disp_title        OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_operator          OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_def_val           OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_andor             OUT    UNAPIGEN.VC3_TABLE_TYPE,     /* VC3_TABLE_TYPE */
 a_hidden            OUT    UNAPIGEN.VC1_TABLE_TYPE,     /* VC1_TABLE_TYPE */
 a_is_protected      OUT    UNAPIGEN.VC1_TABLE_TYPE,     /* VC1_TABLE_TYPE */
 a_mandatory         OUT    UNAPIGEN.VC1_TABLE_TYPE,     /* VC1_TABLE_TYPE */
 a_auto_refresh      OUT    UNAPIGEN.VC1_TABLE_TYPE,     /* VC1_TABLE_TYPE */
 a_col_asc           OUT    UNAPIGEN.VC1_TABLE_TYPE,     /* VC1_TABLE_TYPE */
 a_value_list_tp     OUT    UNAPIGEN.VC1_TABLE_TYPE,     /* VC1_TABLE_TYPE */
 a_operator_protect  OUT    UNAPIGEN.VC1_TABLE_TYPE,     /* VC1_TABLE_TYPE */
 a_andor_protect     OUT    UNAPIGEN.VC1_TABLE_TYPE,     /* VC1_TABLE_TYPE */
 a_dsp_len           OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE + INDICATOR */
 a_inherit_tk        OUT    UNAPIGEN.VC1_TABLE_TYPE,     /* VC1_TABLE_TYPE */
 a_nr_of_rows        IN OUT NUMBER)                      /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetUpUsTaskList
(a_up_in             IN     NUMBER,                   /* LONG_TYPE */
 a_us_in             IN     VARCHAR2,                 /* VC20_TYPE */
 a_tk_tp_in          IN     VARCHAR2,                 /* VC20_TYPE */
 a_up                OUT    UNAPIGEN.LONG_TABLE_TYPE, /* LONG_TABLE_TYPE */
 a_us                OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_tk_tp             OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_tk                OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_description       OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_is_enabled        OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_nr_of_rows        IN OUT NUMBER)                   /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetUpUsTaskDetailsDefinition
(a_up_in             IN     NUMBER,                   /* LONG_TYPE */
 a_us_in             IN     VARCHAR2,                 /* VC20_TYPE */
 a_tk_tp_in          IN     VARCHAR2,                 /* VC20_TYPE */
 a_tk_in             IN     VARCHAR2,                 /* VC20_TYPE */
 a_up                OUT    UNAPIGEN.LONG_TABLE_TYPE, /* LONG_TABLE_TYPE */
 a_us                OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_tk_tp             OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_tk                OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_col_id            OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_col_tp            OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_disp_title        OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_def_val           OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_hidden            OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_is_protected      OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_mandatory         OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_auto_refresh      OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_col_asc           OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_dsp_len           OUT    UNAPIGEN.NUM_TABLE_TYPE,  /* NUM_TABLE_TYPE + INDICATOR */
 a_inherit_tk        OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_nr_of_rows        IN OUT NUMBER)                   /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetUpUsTaskDetailsDefinition
(a_up_in             IN     NUMBER,                   /* LONG_TYPE */
 a_us_in             IN     VARCHAR2,                 /* VC20_TYPE */
 a_tk_tp_in          IN     VARCHAR2,                 /* VC20_TYPE */
 a_tk_in             IN     VARCHAR2,                 /* VC20_TYPE */
 a_up                OUT    UNAPIGEN.LONG_TABLE_TYPE, /* LONG_TABLE_TYPE */
 a_us                OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_tk_tp             OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_tk                OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_description       OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_col_id            OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_col_tp            OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_disp_title        OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_operator          OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_def_val           OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_andor             OUT    UNAPIGEN.VC3_TABLE_TYPE,  /* VC3_TABLE_TYPE */
 a_hidden            OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_is_protected      OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_mandatory         OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_auto_refresh      OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_col_asc           OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_value_list_tp     OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_operator_protect  OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_andor_protect     OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_dsp_len           OUT    UNAPIGEN.NUM_TABLE_TYPE,  /* NUM_TABLE_TYPE + INDICATOR */
 a_inherit_tk        OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_nr_of_rows        IN OUT NUMBER)                   /* NUM_TYPE */
RETURN NUMBER;

FUNCTION SaveUpTaskList
(a_up                IN     NUMBER,                   /* LONG_TYPE */
 a_tk_tp             IN     UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_tk                IN     UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_is_enabled        IN     UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_nr_of_rows        IN     NUMBER,                   /* NUM_TYPE */
 a_modify_reason     IN     VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SaveUpTaskDetails
(a_up                IN     NUMBER,                   /* LONG_TYPE */
 a_tk_tp             IN     VARCHAR2,                 /* VC20_TYPE */
 a_tk                IN     VARCHAR2,                 /* VC20_TYPE */
 a_col_id            IN     UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_col_tp            IN     UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_def_val           IN     UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_hidden            IN     UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_is_protected      IN     UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_mandatory         IN     UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_auto_refresh      IN     UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_col_asc           IN     UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_dsp_len           IN     UNAPIGEN.NUM_TABLE_TYPE,  /* NUM_TABLE_TYPE + INDICATOR */
 a_inherit_tk        IN     UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_nr_of_rows        IN     NUMBER,                   /* NUM_TYPE */
 a_modify_reason     IN     VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SaveUpUsTaskList
(a_up                IN     NUMBER,                   /* LONG_TYPE */
 a_us                IN     VARCHAR2,                 /* VC20_TYPE */
 a_tk_tp             IN     UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_tk                IN     UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_is_enabled        IN     UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_nr_of_rows        IN     NUMBER,                   /* NUM_TYPE */
 a_modify_reason     IN     VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SaveUpUsTaskDetails
(a_up                IN     NUMBER,                   /* LONG_TYPE */
 a_us                IN     VARCHAR2,                 /* VC20_TYPE */
 a_tk_tp             IN     VARCHAR2,                 /* VC20_TYPE */
 a_tk                IN     VARCHAR2,                 /* VC20_TYPE */
 a_col_id            IN     UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_col_tp            IN     UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_def_val           IN     UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_hidden            IN     UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_is_protected      IN     UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_mandatory         IN     UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_auto_refresh      IN     UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_col_asc           IN     UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_dsp_len           IN     UNAPIGEN.NUM_TABLE_TYPE,  /* NUM_TABLE_TYPE + INDICATOR */
 a_inherit_tk        IN     UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_nr_of_rows        IN     NUMBER,                   /* NUM_TYPE */
 a_modify_reason     IN     VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER;


END pbapiupp;
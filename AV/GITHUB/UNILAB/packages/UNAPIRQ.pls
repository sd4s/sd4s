create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapirq AS

/* SelectRequest FROM and WHERE clause variable, used in GetRqGroupKey and GetRqAttribute */
P_SELECTION_CLAUSE               VARCHAR2(4000);
P_SELECTION_VAL_TAB              VC40_NESTEDTABLE_TYPE := VC40_NESTEDTABLE_TYPE();

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION SaveRequest
(a_rq                    IN     VARCHAR2,       /* VC20_TYPE */
 a_rt                    IN     VARCHAR2,       /* VC20_TYPE */
 a_rt_version            IN     VARCHAR2,       /* VC20_TYPE */
 a_description           IN     VARCHAR2,       /* VC40_TYPE */
 a_descr_doc             IN     VARCHAR2,       /* VC40_TYPE */
 a_descr_doc_version     IN     VARCHAR2,       /* VC20_TYPE */
 a_sampling_date         IN     DATE,           /* DATE_TYPE */
 a_creation_date         IN     DATE,           /* DATE_TYPE */
 a_created_by            IN     VARCHAR2,       /* VC20_TYPE */
 a_exec_start_date       IN     DATE,           /* DATE_TYPE */
 a_exec_end_date         IN     DATE,           /* DATE_TYPE */
 a_due_date              IN     DATE,           /* DATE_TYPE */
 a_priority              IN     NUMBER,         /* NUM_TYPE + INDICATOR */
 a_label_format          IN     VARCHAR2,       /* VC20_TYPE */
 a_date1                 IN     DATE,           /* DATE_TYPE */
 a_date2                 IN     DATE,           /* DATE_TYPE */
 a_date3                 IN     DATE,           /* DATE_TYPE */
 a_date4                 IN     DATE,           /* DATE_TYPE */
 a_date5                 IN     DATE,           /* DATE_TYPE */
 a_allow_any_st          IN     CHAR,           /* CHAR1_TYPE */
 a_allow_new_sc          IN     CHAR,           /* CHAR1_TYPE */
 a_responsible           IN     VARCHAR2,       /* VC20_TYPE */
 a_sc_counter            IN     NUMBER,         /* NUM_TYPE + INDICATOR */
 a_rq_class              IN     VARCHAR2,       /* VC2_TYPE */
 a_log_hs                IN     CHAR,           /* CHAR1_TYPE */
 a_log_hs_details        IN     CHAR,           /* CHAR1_TYPE */
 a_lc                    IN     VARCHAR2,       /* VC2_TYPE */
 a_lc_version            IN     VARCHAR2,       /* VC20_TYPE */
 a_modify_reason         IN     VARCHAR2)       /* VC255_TYPE */
RETURN NUMBER;

FUNCTION UpdateLinkedRqii                  /* INTERNAL */
(a_rq                    IN     VARCHAR2,       /* VC20_TYPE */
 a_rq_std_property       IN     VARCHAR2,       /* VC40_TYPE */
 a_rq_creation           IN     CHAR,           /* CHAR1_TYPE */
 a_rt                    IN     VARCHAR2,       /* VC20_TYPE */
 a_rt_version            IN     VARCHAR2,       /* VC20_TYPE */
 a_description           IN     VARCHAR2,       /* VC40_TYPE */
 a_descr_doc             IN     VARCHAR2,       /* VC20_TYPE */
 a_descr_doc_version     IN     VARCHAR2,       /* VC20_TYPE */
 a_sampling_date         IN     DATE,           /* DATE_TYPE */
 a_creation_date         IN     DATE,           /* DATE_TYPE */
 a_created_by            IN     VARCHAR2,       /* VC20_TYPE */
 a_exec_start_date       IN     DATE,           /* DATE_TYPE */
 a_exec_end_date         IN     DATE,           /* DATE_TYPE */
 a_due_date              IN     DATE,           /* DATE_TYPE */
 a_priority              IN     NUMBER,         /* NUM_TYPE + INDICATOR */
 a_label_format          IN     VARCHAR2,       /* VC20_TYPE */
 a_date1                 IN     DATE,           /* DATE_TYPE */
 a_date2                 IN     DATE,           /* DATE_TYPE */
 a_date3                 IN     DATE,           /* DATE_TYPE */
 a_date4                 IN     DATE,           /* DATE_TYPE */
 a_date5                 IN     DATE,           /* DATE_TYPE */
 a_allow_any_st          IN     CHAR,           /* CHAR1_TYPE */
 a_allow_new_sc          IN     CHAR,           /* CHAR1_TYPE */
 a_responsible           IN     VARCHAR2,       /* VC20_TYPE */
 a_rq_class              IN     VARCHAR2)       /* VC2_TYPE */
RETURN NUMBER;

FUNCTION GetRequest
(a_rq                    OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_rt                    OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_rt_version            OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_description           OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_descr_doc             OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_descr_doc_version     OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_sampling_date         OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_creation_date         OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_created_by            OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_exec_start_date       OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_exec_end_date         OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_due_date              OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_priority              OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE + INDICATOR */
 a_label_format          OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_date1                 OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_date2                 OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_date3                 OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_date4                 OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_date5                 OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_allow_any_st          OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_allow_new_sc          OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_responsible           OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_sc_counter            OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE + INDICATOR */
 a_rq_class              OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_log_hs                OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_log_hs_details        OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_allow_modify          OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_ar                    OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_active                OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_lc                    OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_lc_version            OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_ss                    OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_nr_of_rows            IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause          IN      VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION SelectRequest
(a_col_id                IN      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_col_tp                IN      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_col_value             IN      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_col_nr_of_rows        IN      NUMBER,                    /* NUM_TYPE */
 a_rq                    OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_rt                    OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_rt_version            OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_description           OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_descr_doc             OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_descr_doc_version     OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_sampling_date         OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_creation_date         OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_created_by            OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_exec_start_date       OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_exec_end_date         OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_due_date              OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_priority              OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE + INDICATOR */
 a_label_format          OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_date1                 OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_date2                 OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_date3                 OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_date4                 OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_date5                 OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_allow_any_st          OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_allow_new_sc          OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_responsible           OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_sc_counter            OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE + INDICATOR */
 a_rq_class              OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_log_hs                OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_log_hs_details        OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_allow_modify          OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_ar                    OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_active                OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_lc                    OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_lc_version            OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_ss                    OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_nr_of_rows            IN OUT  NUMBER,                    /* NUM_TYPE */
 a_order_by_clause       IN      VARCHAR2,                  /* VC255_TYPE */
 a_next_rows             IN      NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION SelectRequest
(a_col_id                IN      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_col_tp                IN      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_col_value             IN      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_col_operator          IN      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_col_andor             IN      UNAPIGEN.VC3_TABLE_TYPE,   /* VC3_TABLE_TYPE */
 a_col_nr_of_rows        IN      NUMBER,                    /* NUM_TYPE */
 a_rq                    OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_rt                    OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_rt_version            OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_description           OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_descr_doc             OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_descr_doc_version     OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_sampling_date         OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_creation_date         OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_created_by            OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_exec_start_date       OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_exec_end_date         OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_due_date              OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_priority              OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE + INDICATOR */
 a_label_format          OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_date1                 OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_date2                 OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_date3                 OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_date4                 OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_date5                 OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_allow_any_st          OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_allow_new_sc          OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_responsible           OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_sc_counter            OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE + INDICATOR */
 a_rq_class              OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_log_hs                OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_log_hs_details        OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_allow_modify          OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_ar                    OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_active                OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_lc                    OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_lc_version            OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_ss                    OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_nr_of_rows            IN OUT  NUMBER,                    /* NUM_TYPE */
 a_order_by_clause       IN      VARCHAR2,                  /* VC255_TYPE */
 a_next_rows             IN      NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION SelectRqGkValues
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

FUNCTION SelectRqGkValues
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

FUNCTION SelectRqPropValues
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

FUNCTION SelectRqPropValues
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

FUNCTION DeleteRequest
(a_rq            IN  VARCHAR2,          /* VC20_TYPE */
 a_modify_reason IN  VARCHAR2)          /* VC255_TYPE */
RETURN NUMBER;

FUNCTION InitRqAnalysesDetails
(a_rt               IN      VARCHAR2,                  /* VC20_TYPE */
 a_rt_version       IN OUT  VARCHAR2,                  /* VC20_TYPE */
 a_rq               IN      VARCHAR2,                  /* VC20_TYPE */
 a_filter_freq      IN      CHAR,                      /* CHAR1_TYPE */
 a_ref_date         IN      DATE,                      /* DATE_TYPE */
 a_add_stpp         IN      CHAR,                      /* CHAR1_TYPE */
 a_pp               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_version       OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_key1          OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_key2          OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_key3          OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_key4          OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_key5          OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_delay            OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_delay_unit       OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_inherit_au       OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_nr_of_rows       IN OUT  NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION InitRqSamplingDetails
(a_rt               IN      VARCHAR2,                  /* VC20_TYPE */
 a_rt_version       IN OUT  VARCHAR2,                  /* VC20_TYPE */
 a_rq               IN      VARCHAR2,                  /* VC20_TYPE */
 a_filter_freq      IN      CHAR,                      /* CHAR1_TYPE */
 a_ref_date         IN      DATE,                      /* DATE_TYPE */
 a_st               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_st_version       OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_delay            OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_delay_unit       OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_inherit_au       OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_nr_planned_sc    OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_nr_of_rows       IN OUT  NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION CreateRqSamplingDetails
(a_rt               IN      VARCHAR2,                   /* VC20_TYPE */
 a_rt_version       IN OUT  VARCHAR2,                   /* VC20_TYPE */
 a_rq               IN      VARCHAR2,                   /* VC20_TYPE */
 a_filter_freq      IN      CHAR,                       /* CHAR1_TYPE */
 a_ref_date         IN      DATE,                       /* DATE_TYPE */
 a_add_stpp         IN      CHAR,                       /* CHAR1_TYPE */
 a_userid           IN      VARCHAR2,                   /* VC40_TYPE */
 a_fieldtype_tab    IN      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_fieldnames_tab   IN      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_fieldvalues_tab  IN      UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_nr_of_rows       IN      NUMBER,                     /* NUM_TYPE */
 a_modify_reason    IN      VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION CreateRequest
(a_rt               IN     VARCHAR2,                  /* VC20_TYPE */
 a_rt_version       IN OUT VARCHAR2,                  /* VC20_TYPE */
 a_rq               IN OUT VARCHAR2,                  /* VC20_TYPE */
 a_ref_date         IN     DATE,                      /* DATE_TYPE */
 a_create_ic        IN     VARCHAR2,                  /* VC40_TYPE */
 a_create_sc        IN     VARCHAR2,                  /* VC40_TYPE */
 a_userid           IN     VARCHAR2,                  /* VC40_TYPE */
 a_fieldtype_tab    IN     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_fieldnames_tab   IN     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_fieldvalues_tab  IN     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_nr_of_rows       IN     NUMBER,                    /* NUM_TYPE */
 a_modify_reason    IN     VARCHAR2)                  /* VC255_TYPE */
RETURN NUMBER;

FUNCTION PlanRequest
(a_rt               IN     VARCHAR2,                  /* VC20_TYPE */
 a_rt_version       IN OUT VARCHAR2,                  /* VC20_TYPE */
 a_rq               IN OUT VARCHAR2,                  /* VC20_TYPE */
 a_ref_date         IN     DATE,                      /* DATE_TYPE */
 a_create_ic        IN     VARCHAR2,                  /* VC40_TYPE */
 a_create_sc        IN     VARCHAR2,                  /* VC40_TYPE */
 a_userid           IN     VARCHAR2,                  /* VC40_TYPE */
 a_fieldtype_tab    IN     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_fieldnames_tab   IN     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_fieldvalues_tab  IN     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_nr_of_rows       IN     NUMBER,                    /* NUM_TYPE */
 a_modify_reason    IN     VARCHAR2)                  /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GenerateRqSampleCode
(a_rt               IN     VARCHAR2,                  /* VC20_TYPE */
 a_rt_version       IN OUT VARCHAR2,                  /* VC20_TYPE */
 a_ref_date         IN     DATE,                      /* DATE_TYPE */
 a_rq               IN     VARCHAR2,                  /* VC20_TYPE */
 a_st               IN     VARCHAR2,                  /* VC20_TYPE */
 a_st_version       IN OUT VARCHAR2,                  /* VC20_TYPE */
 a_fieldtype_tab    IN     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_fieldnames_tab   IN     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_fieldvalues_tab  IN     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_nr_of_rows       IN     NUMBER,                    /* NUM_TYPE */
 a_sc               OUT    VARCHAR2,                  /* VC20_TYPE */
 a_edit_allowed     OUT    CHAR,                      /* CHAR1_TYPE */
 a_valid_cf         OUT    VARCHAR2)                  /* VC20_TYPE */
RETURN NUMBER;

FUNCTION GenerateRequestCode
(a_rt               IN     VARCHAR2,                  /* VC20_TYPE */
 a_rt_version       IN OUT VARCHAR2,                  /* VC20_TYPE */
 a_ref_date         IN     DATE,                      /* DATE_TYPE */
 a_fieldtype_tab    IN     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_fieldnames_tab   IN     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_fieldvalues_tab  IN     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_nr_of_rows       IN     NUMBER,                    /* NUM_TYPE */
 a_rq               OUT    VARCHAR2,                  /* VC20_TYPE */
 a_edit_allowed     OUT    CHAR,                      /* CHAR1_TYPE */
 a_valid_cf         OUT    VARCHAR2)                  /* VC20_TYPE */
RETURN NUMBER;

FUNCTION CreateRqSample
(a_rt               IN     VARCHAR2,                    /* VC20_TYPE */
 a_rt_version       IN OUT VARCHAR2,                    /* VC20_TYPE */
 a_rq               IN     VARCHAR2,                    /* VC20_TYPE */
 a_st               IN     VARCHAR2,                    /* VC20_TYPE */
 a_st_version       IN OUT VARCHAR2,                    /* VC20_TYPE */
 a_sc               IN OUT VARCHAR2,                    /* VC20_TYPE */
 a_ref_date         IN     DATE,                        /* DATE_TYPE */
 a_create_ic        IN     VARCHAR2,                    /* VC40_TYPE */
 a_userid           IN     VARCHAR2,                    /* VC40_TYPE */
 a_fieldtype_tab    IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_fieldnames_tab   IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_fieldvalues_tab  IN     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_fieldnr_of_rows  IN     NUMBER,                      /* NUM_TYPE */
 a_pp               IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pp_version       IN OUT UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pp_key1          IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pp_key2          IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pp_key3          IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pp_key4          IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pp_key5          IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_nr_of_rows       IN     NUMBER,                      /* NUM_TYPE */
 a_modify_reason    IN     VARCHAR2)                    /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GetRqSample
(a_rq               OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_sc               OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_st               OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_st_version       OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_description      OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_assign_date      OUT    UNAPIGEN.DATE_TABLE_TYPE,    /* DATE_TABLE_TYPE */
 a_assigned_by      OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_nr_of_rows       IN OUT NUMBER,                      /* NUM_TYPE */
 a_where_clause     IN     VARCHAR2)                    /* VC511_TYPE */
RETURN NUMBER;

FUNCTION SaveRqSample
(a_rq               IN     VARCHAR2,                    /* VC20_TYPE */
 a_sc               IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_assign_date      IN     UNAPIGEN.DATE_TABLE_TYPE,    /* DATE_TABLE_TYPE */
 a_assigned_by      IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_nr_of_rows       IN     NUMBER,                      /* NUM_TYPE */
 a_modify_reason    IN     VARCHAR2)                    /* VC255_TYPE */
RETURN NUMBER;

FUNCTION Save1RqSample
(a_rq               IN     VARCHAR2,                    /* VC20_TYPE */
 a_sc               IN     VARCHAR2,                    /* VC20_TYPE */
 a_assign_date      IN     DATE,                        /* DATE_TYPE */
 a_assigned_by      IN     VARCHAR2,                    /* VC20_TYPE */
 a_modify_reason    IN     VARCHAR2)                    /* VC255_TYPE */
RETURN NUMBER;

FUNCTION RemoveRqSample
(a_rq               IN     VARCHAR2,                    /* VC20_TYPE */
 a_sc               IN     VARCHAR2,                    /* VC20_TYPE */
 a_modify_reason    IN     VARCHAR2)                    /* VC255_TYPE */
RETURN NUMBER;

FUNCTION InitAndSaveRqScAttributes
(a_rq               IN      VARCHAR2,                  /* VC20_TYPE */
 a_sc               IN      VARCHAR2,                  /* VC20_TYPE */
 a_rt               IN      VARCHAR2,                  /* VC20_TYPE */
 a_rt_version       IN      VARCHAR2,                  /* VC20_TYPE */
 a_st               IN      VARCHAR2,                  /* VC20_TYPE */
 a_st_version       IN      VARCHAR2)                  /* VC20_TYPE */
RETURN NUMBER;

FUNCTION SaveRqParameterProfile
(a_rq               IN     VARCHAR2,                    /* VC20_TYPE */
 a_pp               IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pp_version       IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pp_key1          IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pp_key2          IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pp_key3          IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pp_key4          IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pp_key5          IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_delay            IN     UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_delay_unit       IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_freq_tp          IN     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_freq_val         IN     UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_freq_unit        IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_invert_freq      IN     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_last_sched       IN     UNAPIGEN.DATE_TABLE_TYPE,    /* DATE_TABLE_TYPE */
 a_last_cnt         IN     UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_last_val         IN     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_inherit_au       IN     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_nr_of_rows       IN     NUMBER,                      /* NUM_TYPE */
 a_modify_reason    IN     VARCHAR2)                    /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GetRqParameterProfile
(a_rq               OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pp               OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pp_version       OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pp_key1          OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pp_key2          OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pp_key3          OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pp_key4          OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pp_key5          OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_description      OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_delay            OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_delay_unit       OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_freq_tp          OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_freq_val         OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_freq_unit        OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_invert_freq      OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_last_sched       OUT    UNAPIGEN.DATE_TABLE_TYPE,    /* DATE_TABLE_TYPE */
 a_last_cnt         OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_last_val         OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_inherit_au       OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_nr_of_rows       IN OUT NUMBER,                      /* NUM_TYPE */
 a_where_clause     IN     VARCHAR2)                    /* VC511_TYPE */
RETURN NUMBER;

FUNCTION SaveRqPpAttribute
(a_rq             IN        VARCHAR2,                 /* VC20_TYPE */
 a_pp             IN        VARCHAR2,                 /* VC20_TYPE */
 a_pp_version     IN        VARCHAR2,                 /* VC20_TYPE */
 a_au             IN        UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_au_version     IN        UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_value          IN        UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_nr_of_rows     IN        NUMBER,                   /* NUM_TYPE */
 a_modify_reason  IN        VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GetRqPpAttribute
(a_rq                 OUT   UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp                 OUT   UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_version         OUT   UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_au                 OUT   UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_au_version         OUT   UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_value              OUT   UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_description        OUT   UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_is_protected       OUT   UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_single_valued      OUT   UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_new_val_allowed    OUT   UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_store_db           OUT   UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_value_list_tp      OUT   UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_run_mode           OUT   UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_service            OUT   UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_cf_value           OUT   UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_nr_of_rows         IN OUT NUMBER,                   /* NUM_TYPE */
 a_where_clause       IN     VARCHAR2)                 /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetRqInfoCard
(a_rq             OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_ic             OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_icnode         OUT      UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_ip_version     OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_description    OUT      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_winsize_x      OUT      UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_winsize_y      OUT      UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_is_protected   OUT      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_hidden         OUT      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_manually_added OUT      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_next_ii        OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_ic_class       OUT      UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_log_hs         OUT      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_log_hs_details OUT      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_allow_modify   OUT      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_ar             OUT      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_active         OUT      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_lc             OUT      UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_lc_version     OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_ss             OUT      UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_nr_of_rows     IN OUT   NUMBER,                    /* NUM_TYPE */
 a_where_clause   IN       VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetRqInfoField
(a_rq               OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_ic               OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_icnode           OUT    UNAPIGEN.LONG_TABLE_TYPE,    /* LONG_TABLE_TYPE */
 a_ii               OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_iinode           OUT    UNAPIGEN.LONG_TABLE_TYPE,    /* LONG_TABLE_TYPE */
 a_ie_version       OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_iivalue          OUT    UNAPIGEN.VC2000_TABLE_TYPE,  /* VC2000_TABLE_TYPE */
 a_pos_x            OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_pos_y            OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_is_protected     OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_mandatory        OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_hidden           OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_dsp_title        OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_dsp_len          OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_dsp_tp           OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_dsp_rows         OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_ii_class         OUT    UNAPIGEN.VC2_TABLE_TYPE,     /* VC2_TABLE_TYPE */
 a_log_hs           OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_log_hs_details   OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_allow_modify     OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_ar               OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_active           OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_lc               OUT    UNAPIGEN.VC2_TABLE_TYPE,     /* VC2_TABLE_TYPE */
 a_lc_version       OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_ss               OUT    UNAPIGEN.VC2_TABLE_TYPE,     /* VC2_TABLE_TYPE */
 a_nr_of_rows       IN OUT NUMBER,                      /* NUM_TYPE */
 a_where_clause     IN     VARCHAR2,                    /* VC511_TYPE */
 a_next_rows        IN     NUMBER)                      /* NUM_TYPE */
RETURN NUMBER;

FUNCTION SaveRqInfoCard
(a_rq             IN      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_ic             IN      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_icnode         IN OUT  UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_ip_version     IN      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_description    IN      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_winsize_x      IN      UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_winsize_y      IN      UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_is_protected   IN      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_hidden         IN      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_manually_added IN      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_next_ii        IN      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_ic_class       IN      UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_log_hs         IN      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_log_hs_details IN      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_lc             IN      UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_lc_version     IN      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_modify_flag    IN OUT  UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_nr_of_rows     IN      NUMBER,                    /* NUM_TYPE */
 a_modify_reason  IN      VARCHAR2)                  /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SaveRqInfoField
(a_rq               IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_ic               IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_icnode           IN OUT   UNAPIGEN.LONG_TABLE_TYPE,    /* LONG_TABLE_TYPE */
 a_ii               IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_iinode           IN OUT   UNAPIGEN.LONG_TABLE_TYPE,    /* LONG_TABLE_TYPE */
 a_ie_version       IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_iivalue          IN       UNAPIGEN.VC2000_TABLE_TYPE,  /* VC2000_TABLE_TYPE */
 a_pos_x            IN       UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_pos_y            IN       UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_is_protected     IN       UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_mandatory        IN       UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_hidden           IN       UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_dsp_title        IN       UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_dsp_len          IN       UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_dsp_tp           IN       UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_dsp_rows         IN       UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_ii_class         IN       UNAPIGEN.VC2_TABLE_TYPE,     /* VC2_TABLE_TYPE */
 a_log_hs           IN       UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_log_hs_details   IN       UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_lc               IN       UNAPIGEN.VC2_TABLE_TYPE,     /* VC2_TABLE_TYPE */
 a_lc_version       IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_modify_flag      IN OUT   UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_nr_of_rows       IN       NUMBER,                      /* NUM_TYPE */
 a_modify_reason    IN       VARCHAR2)                    /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SaveRqIiValue
(a_rq               IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_ic               IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_icnode           IN OUT   UNAPIGEN.LONG_TABLE_TYPE,    /* LONG_TABLE_TYPE */
 a_ii               IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_iinode           IN OUT   UNAPIGEN.LONG_TABLE_TYPE,    /* LONG_TABLE_TYPE */
 a_iivalue          IN       UNAPIGEN.VC2000_TABLE_TYPE,  /* VC2000_TABLE_TYPE */
 a_modify_flag      IN OUT   UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_nr_of_rows       IN       NUMBER,                      /* NUM_TYPE */
 a_modify_reason    IN       VARCHAR2)                    /* VC255_TYPE */
RETURN NUMBER;

FUNCTION CreateRqInfoDetails
(a_rt             IN        VARCHAR2,                 /* VC20_TYPE */
 a_rt_version     IN OUT    VARCHAR2,                 /* VC20_TYPE */
 a_rq             IN        VARCHAR2,                 /* VC20_TYPE */
 a_filter_freq    IN        CHAR,                     /* CHAR1_TYPE */
 a_ref_date       IN        DATE,                     /* DATE_TYPE */
 a_modify_reason  IN        VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER;

FUNCTION AddRqInfoDetails
(a_rt             IN        VARCHAR2,                 /* VC20_TYPE */
 a_rt_version     IN        VARCHAR2,                 /* VC20_TYPE */
 a_rq             IN        VARCHAR2,                 /* VC20_TYPE */
 a_ip             IN        VARCHAR2,                 /* VC20_TYPE */
 a_ip_version     IN        VARCHAR2,                 /* VC20_TYPE */
 a_seq            IN        NUMBER,                   /* NUM_TYPE */
 a_modify_reason  IN        VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER;

FUNCTION CreateRqIcDetails
(a_rt             IN        VARCHAR2,                 /* VC20_TYPE */
 a_rt_version     IN OUT    VARCHAR2,                 /* VC20_TYPE */
 a_ip             IN        VARCHAR2,                 /* VC20_TYPE */
 a_ip_version     IN OUT    VARCHAR2,                 /* VC20_TYPE */
 a_seq            IN        NUMBER,                   /* NUM_TYPE */
 a_rq             IN        VARCHAR2,                 /* VC20_TYPE */
 a_icnode         IN        NUMBER,                   /* LONG_TYPE */
 a_modify_reason  IN        VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER;

FUNCTION AddRqIcDetails
(a_rt             IN        VARCHAR2,                 /* VC20_TYPE */
 a_rt_version     IN        VARCHAR2,                 /* VC20_TYPE */
 a_rq             IN        VARCHAR2,                 /* VC20_TYPE */
 a_ic             IN        VARCHAR2,                 /* VC20_TYPE */
 a_icnode         IN        NUMBER,                   /* LONG_TYPE */
 a_ie             IN        VARCHAR2,                 /* VC20_TYPE */
 a_ie_version     IN        VARCHAR2,                 /* VC20_TYPE */
 a_seq            IN        NUMBER,                   /* NUM_TYPE */
 a_modify_reason  IN        VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER;

FUNCTION InitRqInfoCard
(a_ip              IN     VARCHAR2,                  /* VC20_TYPE */
 a_ip_version_in   IN     VARCHAR2,                  /* VC20_TYPE */
 a_seq             IN     NUMBER,                    /* NUM_TYPE */
 a_rt              IN     VARCHAR2,                  /* VC20_TYPE */
 a_rt_version      IN     VARCHAR2,                  /* VC20_TYPE */
 a_rq              IN     VARCHAR2,                  /* VC20_TYPE */
 a_ip_version      OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_description     OUT    UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_winsize_x       OUT    UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_winsize_y       OUT    UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_is_protected    OUT    UNAPIGEN.CHAR1_TABLE_TYPE ,/* CHAR1_TABLE_TYPE */
 a_hidden          OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_manually_added  OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_next_ii         OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_ic_class        OUT    UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_log_hs          OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_log_hs_details  OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_lc              OUT    UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_lc_version      OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_nr_of_rows      IN OUT NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION InitRqIcAttribute
(a_rq               IN     VARCHAR2,                  /* VC20_TYPE */
 a_rt               IN     VARCHAR2,                  /* VC20_TYPE */
 a_rt_version       IN     VARCHAR2,                  /* VC20_TYPE */
 a_ip               IN     VARCHAR2,                  /* VC20_TYPE */
 a_ip_version       IN     VARCHAR2,                  /* VC20_TYPE */
 a_au               OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_au_version       OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_value            OUT    UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_description      OUT    UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_is_protected     OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_single_valued    OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_new_val_allowed  OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_store_db         OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_value_list_tp    OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_run_mode         OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_service          OUT    UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_cf_value         OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_nr_of_rows       IN OUT NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION InitRqIcDetails
(a_ip              IN     VARCHAR2,                   /* VC20_TYPE */
 a_ip_version      IN OUT VARCHAR2,                   /* VC20_TYPE */
 a_rq              IN     VARCHAR2,                   /* VC20_TYPE */
 a_ii              OUT    UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_ie_version      OUT    UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_iivalue         OUT    UNAPIGEN.VC2000_TABLE_TYPE, /* VC2000_TABLE_TYPE */
 a_pos_x           OUT    UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_pos_y           OUT    UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_is_protected    OUT    UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_mandatory       OUT    UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_hidden          OUT    UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_dsp_title       OUT    UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_dsp_len         OUT    UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_dsp_tp          OUT    UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_dsp_rows        OUT    UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_ii_class        OUT    UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_log_hs          OUT    UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_log_hs_details  OUT    UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_lc              OUT    UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_lc_version      OUT    UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_nr_of_rows      IN OUT NUMBER,                     /* NUM_TYPE */
 a_next_rows       IN     NUMBER)                     /* NUM_TYPE */
RETURN NUMBER;

FUNCTION InitRqInfoDetails
(a_rt             IN        VARCHAR2,                  /* VC20_TYPE */
 a_rt_version     IN OUT    VARCHAR2,                 /* VC20_TYPE */
 a_rq             IN        VARCHAR2,                  /* VC20_TYPE */
 a_filter_freq    IN        CHAR,                      /* CHAR1_TYPE */
 a_ref_date       IN        DATE,                      /* DATE_TYPE */
 a_ic             OUT       UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_ip_version     OUT       UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_description    OUT       UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_winsize_x      OUT       UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_winsize_y      OUT       UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_is_protected   OUT       UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_hidden         OUT       UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_manually_added OUT       UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_next_ii        OUT       UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_ic_class       OUT       UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_log_hs         OUT       UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_log_hs_details OUT       UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_lc             OUT       UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_lc_version     OUT       UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_nr_of_rows     IN OUT    NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetRqIcAttribute
(a_rq                 OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_ic                 OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_icnode             OUT    UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_au                 OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_au_version         OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_value              OUT    UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_description        OUT    UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_is_protected       OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_single_valued      OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_new_val_allowed    OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_store_db           OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_value_list_tp      OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_run_mode           OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_service            OUT    UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_cf_value           OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_nr_of_rows         IN OUT NUMBER,                    /* NUM_TYPE */
 a_where_clause       IN     VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION SaveRqIcAttribute
(a_rq             IN        VARCHAR2,                 /* VC20_TYPE */
 a_ic             IN        VARCHAR2,                 /* VC20_TYPE */
 a_icnode         IN        NUMBER,                   /* LONG_TYPE */
 a_au             IN        UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_au_version     IN OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_value          IN        UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_nr_of_rows     IN        NUMBER,                   /* NUM_TYPE */
 a_modify_reason  IN        VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER;

FUNCTION Save1RqIcAttribute
(a_rq             IN        VARCHAR2,                 /* VC20_TYPE */
 a_ic             IN        VARCHAR2,                 /* VC20_TYPE */
 a_icnode         IN        NUMBER,                   /* LONG_TYPE */
 a_au             IN        VARCHAR2,                 /* VC20_TYPE */
 a_au_version     IN OUT    VARCHAR2,                 /* VC20_TYPE */
 a_value          IN        UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_nr_of_rows     IN        NUMBER,                   /* NUM_TYPE */
 a_modify_reason  IN        VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SaveRqIcHistory
(a_rq                IN        VARCHAR2,                  /* VC20_TYPE */
 a_ic                IN        VARCHAR2,                  /* VC20_TYPE */
 a_icnode            IN        NUMBER,                    /* LONG_TYPE */
 a_who               IN        UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_who_description   IN        UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_what              IN        UNAPIGEN.VC60_TABLE_TYPE,   /* VC60_TABLE_TYPE */
 a_what_description  IN        UNAPIGEN.VC255_TABLE_TYPE,  /* VC255_TABLE_TYPE */
 a_logdate           IN        UNAPIGEN.DATE_TABLE_TYPE,   /* DATE_TABLE_TYPE */
 a_why               IN        UNAPIGEN.VC255_TABLE_TYPE,  /* VC255_TABLE_TYPE */
 a_tr_seq            IN        UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_ev_seq            IN        UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_nr_of_rows        IN        NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetRqIcHistory
(a_rq               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_ic               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_icnode           OUT     UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_who               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_who_description   OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_what              OUT     UNAPIGEN.VC60_TABLE_TYPE,  /* VC60_TABLE_TYPE */
 a_what_description  OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_logdate           OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_why               OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_tr_seq            OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_ev_seq            OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_nr_of_rows       IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause     IN      VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetRqIcHistory
(a_rq                OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_ic                OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_icnode            OUT     UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_who               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_who_description   OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_what              OUT     UNAPIGEN.VC60_TABLE_TYPE,  /* VC60_TABLE_TYPE */
 a_what_description  OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_logdate           OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_why               OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_tr_seq            OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_ev_seq            OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_nr_of_rows        IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause      IN      VARCHAR2,                  /* VC511_TYPE */
 a_next_rows         IN      NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetRqIcHistoryDetails
(a_rq                OUT     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_ic                OUT     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_icnode            OUT     UNAPIGEN.LONG_TABLE_TYPE,    /* LONG_TABLE_TYPE */
 a_tr_seq            OUT     UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_ev_seq            OUT     UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_seq               OUT     UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_details           OUT     UNAPIGEN.VC4000_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_nr_of_rows        IN OUT  NUMBER,                      /* NUM_TYPE */
 a_where_clause      IN      VARCHAR2,                    /* VC511_TYPE */
 a_next_rows         IN      NUMBER)                      /* NUM_TYPE */
RETURN NUMBER;

FUNCTION AddRqIcComment
(a_rq           IN  VARCHAR2, /* VC20_TYPE */
 a_ic           IN  VARCHAR2, /* VC20_TYPE */
 a_icnode       IN  NUMBER,   /* LONG_TYPE */
 a_comment      IN  VARCHAR2) /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GetRqIcComment
(a_rq               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_ic               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_icnode           OUT     UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_last_comment     OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_nr_of_rows       IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause     IN      VARCHAR2,                  /* VC511_TYPE */
 a_next_rows        IN      NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION SaveRqIcAccess
(a_rq                IN      VARCHAR2,                  /* VC20_TYPE */
 a_ic                IN      VARCHAR2,                  /* VC20_TYPE */
 a_icnode            IN      NUMBER,                    /* LONG_TYPE */
 a_dd                IN      UNAPIGEN.VC3_TABLE_TYPE,   /* VC3_TABLE_TYPE */
 a_access_rights     IN      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_nr_of_rows        IN      NUMBER,                    /* NUM_TYPE */
 a_modify_reason     IN      VARCHAR2)                  /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GetRqIcAccess
(a_rq                OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_ic                OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_icnode            OUT     UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_dd                OUT     UNAPIGEN.VC3_TABLE_TYPE,   /* VC3_TABLE_TYPE */
 a_data_domain       OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_access_rights     OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_nr_of_rows        IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause      IN      VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION ChangeRqIcStatus
(a_rq                IN      VARCHAR2,     /* VC20_TYPE */
 a_ic                IN      VARCHAR2,     /* VC20_TYPE */
 a_icnode            IN      NUMBER,       /* LONG_TYPE */
 a_old_ss            IN      VARCHAR2,     /* VC2_TYPE */
 a_new_ss            IN      VARCHAR2,     /* VC2_TYPE */
 a_lc                IN      VARCHAR2,     /* VC2_TYPE */
 a_lc_version        IN      VARCHAR2,     /* VC20_TYPE */
 a_modify_reason     IN      VARCHAR2)     /* VC255_TYPE */
RETURN NUMBER;

FUNCTION InternalChangeRqIcStatus          /* INTERNAL */
(a_rq                IN      VARCHAR2,     /* VC20_TYPE */
 a_ic                IN      VARCHAR2,     /* VC20_TYPE */
 a_icnode            IN      NUMBER,       /* LONG_TYPE */
 a_new_ss            IN      VARCHAR2,     /* VC2_TYPE */
 a_modify_reason     IN      VARCHAR2)     /* VC255_TYPE */
RETURN NUMBER;

FUNCTION CancelRqIc
(a_rq                IN      VARCHAR2,     /* VC20_TYPE */
 a_ic                IN      VARCHAR2,     /* VC20_TYPE */
 a_icnode            IN      NUMBER,       /* LONG_TYPE */
 a_modify_reason     IN      VARCHAR2)     /* VC255_TYPE */
RETURN NUMBER;

FUNCTION ChangeRqIcLifeCycle
(a_rq                IN      VARCHAR2,     /* VC20_TYPE */
 a_ic                IN      VARCHAR2,     /* VC20_TYPE */
 a_icnode            IN      NUMBER,       /* LONG_TYPE */
 a_old_lc            IN      VARCHAR2,     /* VC2_TYPE */
 a_old_lc_version    IN      VARCHAR2,     /* VC20_TYPE */
 a_new_lc            IN      VARCHAR2,     /* VC2_TYPE */
 a_new_lc_version    IN      VARCHAR2,     /* VC20_TYPE */
 a_modify_reason     IN      VARCHAR2)     /* VC255_TYPE */
RETURN NUMBER;

FUNCTION RqIcElectronicSignature
(a_rq                IN      VARCHAR2,     /* VC20_TYPE */
 a_ic                IN      VARCHAR2,     /* VC20_TYPE */
 a_icnode            IN      NUMBER,       /* LONG_TYPE */
 a_authorised_by     IN      VARCHAR2,     /* VC20_TYPE */
 a_modify_reason     IN      VARCHAR2)     /* VC255_TYPE */
RETURN NUMBER;

FUNCTION CopyRqSamplingDetails
(a_rq_from             IN        VARCHAR2,             /* VC20_TYPE */
 a_rt_to               IN        VARCHAR2,             /* VC20_TYPE */
 a_rt_to_version       IN OUT    VARCHAR2,             /* VC20_TYPE */
 a_rq_to               IN        VARCHAR2,             /* VC20_TYPE */
 a_ref_date            IN        DATE,                 /* DATE_TYPE */
 a_copy_scic           IN        VARCHAR2,             /* VC40_TYPE */
 a_copy_scpg           IN        VARCHAR2,             /* VC40_TYPE */
 a_userid              IN        VARCHAR2,             /* VC40_TYPE */
 a_modify_reason       IN        VARCHAR2)             /* VC255_TYPE */
RETURN NUMBER;

FUNCTION CopyRequest
(a_rq_from         IN     VARCHAR2,  /* VC20_TYPE */
 a_rt_to           IN     VARCHAR2,  /* VC20_TYPE */
 a_rt_to_version   IN OUT VARCHAR2,  /* VC20_TYPE */
 a_rq_to           IN OUT VARCHAR2,  /* VC20_TYPE */
 a_ref_date        IN     DATE,      /* DATE_TYPE */
 a_copy_ic         IN     VARCHAR2,  /* VC40_TYPE */
 a_copy_sc         IN     VARCHAR2,  /* VC40_TYPE */
 a_copy_scic       IN     VARCHAR2,  /* VC40_TYPE */
 a_copy_scpg       IN     VARCHAR2,  /* VC40_TYPE */
 a_userid          IN     VARCHAR2,  /* VC40_TYPE */
 a_modify_reason   IN     VARCHAR2)  /* VC255_TYPE */
RETURN NUMBER;

FUNCTION CopyRqInfoDetails
(a_rq_from        IN        VARCHAR2,                 /* VC20_TYPE */
 a_rt_to          IN        VARCHAR2,                 /* VC20_TYPE */
 a_rt_to_version  IN        VARCHAR2,                 /* VC20_TYPE */
 a_rq_to          IN        VARCHAR2,                 /* VC20_TYPE */
 a_modify_reason  IN        VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER;

FUNCTION CopyRqIcDetails
(a_rq_from        IN        VARCHAR2,                 /* VC20_TYPE */
 a_ic_from        IN        VARCHAR2,                 /* VC20_TYPE */
 a_icnode_from    IN        NUMBER,                   /* LONG_TYPE */
 a_rt_to          IN        VARCHAR2,                 /* VC20_TYPE */
 a_rt_to_version  IN        VARCHAR2,                 /* VC20_TYPE */
 a_rq_to          IN        VARCHAR2,                 /* VC20_TYPE */
 a_ic_to          IN        VARCHAR2,                 /* VC20_TYPE */
 a_icnode_to      IN        NUMBER,                   /* LONG_TYPE */
 a_modify_reason  IN        VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER;

FUNCTION CopyRqInfoValues
(a_rq_from        IN        VARCHAR2,                 /* VC20_TYPE */
 a_ic_from        IN        VARCHAR2,                 /* VC20_TYPE */
 a_icnode_from    IN        NUMBER,                   /* LONG_TYPE */
 a_rt_to          IN        VARCHAR2,                 /* VC20_TYPE */
 a_rt_to_version  IN        VARCHAR2,                 /* VC20_TYPE */
 a_rq_to          IN        VARCHAR2,                 /* VC20_TYPE */
 a_ic_to          IN        VARCHAR2,                 /* VC20_TYPE */
 a_icnode_to      IN        NUMBER,                   /* LONG_TYPE */
 a_modify_reason  IN        VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER;

END unapirq;
create or replace PACKAGE
-- Unilab 6.7 Package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapisd AS

/* SelectStudy FROM and WHERE clause variable, used in GetsdGroupKey and GetsdAttribute */
P_SELECTION_CLAUSE               VARCHAR2(4000);
P_SELECTION_VAL_TAB              VC40_NESTEDTABLE_TYPE := VC40_NESTEDTABLE_TYPE();

/* Date format used to format the date for the sample event TpReachedSet */
TP_REACHED_DATE_FORMAT   CONSTANT VARCHAR2(40) := 'DD/MM/YYYY HH24:MI:SS';

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION SaveStudy
(a_sd                  IN     VARCHAR2 ,    /* VC20_TYPE */
 a_pt                  IN     VARCHAR2 ,    /* VC20_TYPE */
 a_pt_version          IN     VARCHAR2 ,    /* VC20_TYPE */
 a_description         IN     VARCHAR2 ,    /* VC40_TYPE */
 a_descr_doc           IN     VARCHAR2 ,    /* VC40_TYPE */
 a_descr_doc_version   IN     VARCHAR2 ,    /* VC20_TYPE */
 a_responsible         IN     VARCHAR2 ,    /* VC20_TYPE */
 a_label_format        IN     VARCHAR2 ,    /* VC20_TYPE */
 a_creation_date       IN     DATE     ,    /* DATE_TYPE */
 a_created_by          IN     VARCHAR2 ,    /* VC20_TYPE */
 a_exec_start_date     IN     DATE     ,    /* DATE_TYPE */
 a_exec_end_date       IN     DATE     ,    /* DATE_TYPE */
 a_t0_date             IN     DATE     ,    /* DATE_TYPE */
 a_nr_sc_current       IN     NUMBER   ,    /* NUM_TYPE + INDICATOR */
 a_sd_class            IN     VARCHAR2 ,    /* VC2_TYPE */
 a_log_hs              IN     CHAR     ,    /* CHAR1_TYPE */
 a_log_hs_details      IN     CHAR     ,    /* CHAR1_TYPE */
 a_lc                  IN     VARCHAR2 ,    /* VC2_TYPE */
 a_lc_version          IN     VARCHAR2 ,    /* VC20_TYPE */
 a_modify_reason       IN     VARCHAR2)     /* VC255_TYPE */
RETURN NUMBER;

FUNCTION UpdateLinkedSdii                   /* INTERNAL */
(a_sd                  IN     VARCHAR2,     /* VC20_TYPE */
 a_sd_std_property     IN     VARCHAR2,     /* VC40_TYPE */
 a_sd_creation         IN     CHAR,         /* CHAR1_TYPE */
 a_pt                  IN     VARCHAR2 ,    /* VC20_TYPE */
 a_pt_version          IN     VARCHAR2 ,    /* VC20_TYPE */
 a_description         IN     VARCHAR2 ,    /* VC40_TYPE */
 a_descr_doc           IN     VARCHAR2 ,    /* VC40_TYPE */
 a_descr_doc_version   IN     VARCHAR2 ,    /* VC20_TYPE */
 a_responsible         IN     VARCHAR2 ,    /* VC20_TYPE */
 a_label_format        IN     VARCHAR2 ,    /* VC20_TYPE */
 a_creation_date       IN     DATE     ,    /* DATE_TYPE */
 a_created_by          IN     VARCHAR2 ,    /* VC20_TYPE */
 a_exec_start_date     IN     DATE     ,    /* DATE_TYPE */
 a_exec_end_date       IN     DATE     ,    /* DATE_TYPE */
 a_t0_date             IN     DATE     ,    /* VC20_TYPE */
 a_nr_sc_current       IN     NUMBER   )    /* NUM_TYPE + INDICATOR */
RETURN NUMBER;

FUNCTION GetStudy
(a_sd                    OUT     UNAPIGEN.VC20_TABLE_TYPE  ,  /* VC20_TABLE_TYPE */
 a_pt                    OUT     UNAPIGEN.VC20_TABLE_TYPE  ,  /* VC20_TABLE_TYPE */
 a_pt_version            OUT     UNAPIGEN.VC20_TABLE_TYPE  ,  /* VC20_TABLE_TYPE */
 a_description           OUT     UNAPIGEN.VC40_TABLE_TYPE  ,  /* VC40_TABLE_TYPE */
 a_descr_doc             OUT     UNAPIGEN.VC40_TABLE_TYPE  ,  /* VC40_TABLE_TYPE */
 a_descr_doc_version     OUT     UNAPIGEN.VC20_TABLE_TYPE  ,  /* VC20_TABLE_TYPE */
 a_responsible           OUT     UNAPIGEN.VC20_TABLE_TYPE  ,  /* VC20_TABLE_TYPE */
 a_label_format          OUT     UNAPIGEN.VC20_TABLE_TYPE  ,  /* VC20_TABLE_TYPE */
 a_creation_date         OUT     UNAPIGEN.DATE_TABLE_TYPE  ,  /* DATE_TABLE_TYPE */
 a_created_by            OUT     UNAPIGEN.VC20_TABLE_TYPE  ,  /* VC20_TABLE_TYPE */
 a_exec_start_date       OUT     UNAPIGEN.DATE_TABLE_TYPE  ,  /* DATE_TABLE_TYPE */
 a_exec_end_date         OUT     UNAPIGEN.DATE_TABLE_TYPE  ,  /* DATE_TABLE_TYPE */
 a_t0_date               OUT     UNAPIGEN.DATE_TABLE_TYPE  ,  /* DATE_TABLE_TYPE */
 a_nr_sc_current         OUT     UNAPIGEN.NUM_TABLE_TYPE   ,  /* NUM_TABLE_TYPE   + INDICATOR */
 a_sd_class              OUT     UNAPIGEN.VC2_TABLE_TYPE,     /* VC2_TABLE_TYPE */
 a_log_hs                OUT     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_log_hs_details        OUT     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_allow_modify          OUT     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_ar                    OUT     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_active                OUT     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_lc                    OUT     UNAPIGEN.VC2_TABLE_TYPE,     /* VC2_TABLE_TYPE */
 a_lc_version            OUT     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_ss                    OUT     UNAPIGEN.VC2_TABLE_TYPE,     /* VC2_TABLE_TYPE */
 a_nr_of_rows            IN OUT  NUMBER,                      /* NUM_TYPE */
 a_where_clause          IN      VARCHAR2)                    /* VC511_TYPE */
RETURN NUMBER;

FUNCTION SelectStudy
(a_col_id                IN      UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_col_tp                IN      UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_col_value             IN      UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_col_nr_of_rows        IN      NUMBER,                      /* NUM_TYPE */
 a_sd                    OUT     UNAPIGEN.VC20_TABLE_TYPE  ,  /* VC20_TABLE_TYPE */
 a_pt                    OUT     UNAPIGEN.VC20_TABLE_TYPE  ,  /* VC20_TABLE_TYPE */
 a_pt_version            OUT     UNAPIGEN.VC20_TABLE_TYPE  ,  /* VC20_TABLE_TYPE */
 a_description           OUT     UNAPIGEN.VC40_TABLE_TYPE  ,  /* VC40_TABLE_TYPE */
 a_descr_doc             OUT     UNAPIGEN.VC40_TABLE_TYPE  ,  /* VC40_TABLE_TYPE */
 a_descr_doc_version     OUT     UNAPIGEN.VC20_TABLE_TYPE  ,  /* VC20_TABLE_TYPE */
 a_responsible           OUT     UNAPIGEN.VC20_TABLE_TYPE  ,  /* VC20_TABLE_TYPE */
 a_label_format          OUT     UNAPIGEN.VC20_TABLE_TYPE  ,  /* VC20_TABLE_TYPE */
 a_creation_date         OUT     UNAPIGEN.DATE_TABLE_TYPE  ,  /* DATE_TABLE_TYPE */
 a_created_by            OUT     UNAPIGEN.VC20_TABLE_TYPE  ,  /* VC20_TABLE_TYPE */
 a_exec_start_date       OUT     UNAPIGEN.DATE_TABLE_TYPE  ,  /* DATE_TABLE_TYPE */
 a_exec_end_date         OUT     UNAPIGEN.DATE_TABLE_TYPE  ,  /* DATE_TABLE_TYPE */
 a_t0_date               OUT     UNAPIGEN.DATE_TABLE_TYPE  ,  /* DATE_TABLE_TYPE */
 a_nr_sc_current         OUT     UNAPIGEN.NUM_TABLE_TYPE   ,  /* NUM_TABLE_TYPE   + INDICATOR */
 a_sd_class              OUT     UNAPIGEN.VC2_TABLE_TYPE,     /* VC2_TABLE_TYPE */
 a_log_hs                OUT     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_log_hs_details        OUT     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_allow_modify          OUT     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_ar                    OUT     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_active                OUT     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_lc                    OUT     UNAPIGEN.VC2_TABLE_TYPE,     /* VC2_TABLE_TYPE */
 a_lc_version            OUT     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_ss                    OUT     UNAPIGEN.VC2_TABLE_TYPE,     /* VC2_TABLE_TYPE */
 a_nr_of_rows            IN OUT  NUMBER,                      /* NUM_TYPE */
 a_order_by_clause       IN      VARCHAR2,                    /* VC255_TYPE */
 a_next_rows             IN      NUMBER)                      /* NUM_TYPE */
RETURN NUMBER;

FUNCTION SelectStudy
(a_col_id                IN      UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_col_tp                IN      UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_col_value             IN      UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_col_operator          IN      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_col_andor             IN      UNAPIGEN.VC3_TABLE_TYPE,     /* VC3_TABLE_TYPE */
 a_col_nr_of_rows        IN      NUMBER,                      /* NUM_TYPE */
 a_sd                    OUT     UNAPIGEN.VC20_TABLE_TYPE  ,  /* VC20_TABLE_TYPE */
 a_pt                    OUT     UNAPIGEN.VC20_TABLE_TYPE  ,  /* VC20_TABLE_TYPE */
 a_pt_version            OUT     UNAPIGEN.VC20_TABLE_TYPE  ,  /* VC20_TABLE_TYPE */
 a_description           OUT     UNAPIGEN.VC40_TABLE_TYPE  ,  /* VC40_TABLE_TYPE */
 a_descr_doc             OUT     UNAPIGEN.VC40_TABLE_TYPE  ,  /* VC40_TABLE_TYPE */
 a_descr_doc_version     OUT     UNAPIGEN.VC20_TABLE_TYPE  ,  /* VC20_TABLE_TYPE */
 a_responsible           OUT     UNAPIGEN.VC20_TABLE_TYPE  ,  /* VC20_TABLE_TYPE */
 a_label_format          OUT     UNAPIGEN.VC20_TABLE_TYPE  ,  /* VC20_TABLE_TYPE */
 a_creation_date         OUT     UNAPIGEN.DATE_TABLE_TYPE  ,  /* DATE_TABLE_TYPE */
 a_created_by            OUT     UNAPIGEN.VC20_TABLE_TYPE  ,  /* VC20_TABLE_TYPE */
 a_exec_start_date       OUT     UNAPIGEN.DATE_TABLE_TYPE  ,  /* DATE_TABLE_TYPE */
 a_exec_end_date         OUT     UNAPIGEN.DATE_TABLE_TYPE  ,  /* DATE_TABLE_TYPE */
 a_t0_date               OUT     UNAPIGEN.DATE_TABLE_TYPE  ,  /* DATE_TABLE_TYPE */
 a_nr_sc_current         OUT     UNAPIGEN.NUM_TABLE_TYPE   ,  /* NUM_TABLE_TYPE   + INDICATOR */
 a_sd_class              OUT     UNAPIGEN.VC2_TABLE_TYPE,     /* VC2_TABLE_TYPE */
 a_log_hs                OUT     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_log_hs_details        OUT     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_allow_modify          OUT     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_ar                    OUT     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_active                OUT     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_lc                    OUT     UNAPIGEN.VC2_TABLE_TYPE,     /* VC2_TABLE_TYPE */
 a_lc_version            OUT     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_ss                    OUT     UNAPIGEN.VC2_TABLE_TYPE,     /* VC2_TABLE_TYPE */
 a_nr_of_rows            IN OUT  NUMBER,                      /* NUM_TYPE */
 a_order_by_clause       IN      VARCHAR2,                    /* VC255_TYPE */
 a_next_rows             IN      NUMBER)                      /* NUM_TYPE */
RETURN NUMBER;

FUNCTION SelectSdGkValues
(a_col_id           IN      UNAPIGEN.VC40_TABLE_TYPE,         /* VC40_TABLE_TYPE */
 a_col_tp           IN      UNAPIGEN.VC40_TABLE_TYPE,         /* VC40_TABLE_TYPE */
 a_col_value        IN      UNAPIGEN.VC40_TABLE_TYPE,         /* VC40_TABLE_TYPE */
 a_col_nr_of_rows   IN      NUMBER,                           /* NUM_TYPE */
 a_gk               IN      VARCHAR2,                         /* VC20_TYPE */
 a_value            OUT     UNAPIGEN.VC40_TABLE_TYPE,         /* VC40_TABLE_TYPE */
 a_nr_of_rows       IN OUT  NUMBER,                           /* NUM_TYPE */
 a_order_by_clause  IN      VARCHAR2,                         /* VC255_TYPE */
 a_next_rows        IN      NUMBER)                           /* NUM_TYPE */
RETURN NUMBER;

FUNCTION SelectSdGkValues
(a_col_id           IN      UNAPIGEN.VC40_TABLE_TYPE,         /* VC40_TABLE_TYPE */
 a_col_tp           IN      UNAPIGEN.VC40_TABLE_TYPE,         /* VC40_TABLE_TYPE */
 a_col_value        IN      UNAPIGEN.VC40_TABLE_TYPE,         /* VC40_TABLE_TYPE */
 a_col_operator     IN      UNAPIGEN.VC20_TABLE_TYPE,         /* VC20_TABLE_TYPE */
 a_col_andor        IN      UNAPIGEN.VC3_TABLE_TYPE,          /* VC3_TABLE_TYPE */
 a_col_nr_of_rows   IN      NUMBER,                           /* NUM_TYPE */
 a_gk               IN      VARCHAR2,                         /* VC20_TYPE */
 a_value            OUT     UNAPIGEN.VC40_TABLE_TYPE,         /* VC40_TABLE_TYPE */
 a_nr_of_rows       IN OUT  NUMBER,                           /* NUM_TYPE */
 a_order_by_clause  IN      VARCHAR2,                         /* VC255_TYPE */
 a_next_rows        IN      NUMBER)                           /* NUM_TYPE */
RETURN NUMBER;

FUNCTION SelectSdPropValues
(a_col_id           IN      UNAPIGEN.VC40_TABLE_TYPE,         /* VC40_TABLE_TYPE */
 a_col_tp           IN      UNAPIGEN.VC40_TABLE_TYPE,         /* VC40_TABLE_TYPE */
 a_col_value        IN      UNAPIGEN.VC40_TABLE_TYPE,         /* VC40_TABLE_TYPE */
 a_col_nr_of_rows   IN      NUMBER,                           /* NUM_TYPE */
 a_prop             IN      VARCHAR2,                         /* VC20_TYPE */
 a_value            OUT     UNAPIGEN.VC40_TABLE_TYPE,         /* VC40_TABLE_TYPE */
 a_nr_of_rows       IN OUT  NUMBER,                           /* NUM_TYPE */
 a_order_by_clause  IN      VARCHAR2,                         /* VC255_TYPE */
 a_next_rows        IN      NUMBER)                           /* NUM_TYPE */
RETURN NUMBER;

FUNCTION SelectSdPropValues
(a_col_id           IN      UNAPIGEN.VC40_TABLE_TYPE,         /* VC40_TABLE_TYPE */
 a_col_tp           IN      UNAPIGEN.VC40_TABLE_TYPE,         /* VC40_TABLE_TYPE */
 a_col_value        IN      UNAPIGEN.VC40_TABLE_TYPE,         /* VC40_TABLE_TYPE */
 a_col_operator     IN      UNAPIGEN.VC20_TABLE_TYPE,         /* VC20_TABLE_TYPE */
 a_col_andor        IN      UNAPIGEN.VC3_TABLE_TYPE,          /* VC3_TABLE_TYPE */
 a_col_nr_of_rows   IN      NUMBER,                           /* NUM_TYPE */
 a_prop             IN      VARCHAR2,                         /* VC20_TYPE */
 a_value            OUT     UNAPIGEN.VC40_TABLE_TYPE,         /* VC40_TABLE_TYPE */
 a_nr_of_rows       IN OUT  NUMBER,                           /* NUM_TYPE */
 a_order_by_clause  IN      VARCHAR2,                         /* VC255_TYPE */
 a_next_rows        IN      NUMBER)                           /* NUM_TYPE */
RETURN NUMBER;

FUNCTION DeleteStudy
(a_sd            IN  VARCHAR2,                                /* VC20_TYPE */
 a_modify_reason IN  VARCHAR2)                                /* VC255_TYPE */
RETURN NUMBER;

FUNCTION InitSdSamplingDetails
(a_pt               IN      VARCHAR2,                         /* VC20_TYPE */
 a_pt_version       IN OUT  VARCHAR2,                         /* VC20_TYPE */
 a_sd               IN      VARCHAR2,                         /* VC20_TYPE */
 a_filter_freq      IN      CHAR,                             /* CHAR1_TYPE */
 a_ref_date         IN      DATE,                             /* DATE_TYPE */
 a_st               OUT     UNAPIGEN.VC20_TABLE_TYPE,         /* VC20_TABLE_TYPE */
 a_st_version       OUT     UNAPIGEN.VC20_TABLE_TYPE,         /* VC20_TABLE_TYPE */
 a_delay            OUT     UNAPIGEN.NUM_TABLE_TYPE,          /* NUM_TABLE_TYPE */
 a_delay_unit       OUT     UNAPIGEN.VC20_TABLE_TYPE,         /* VC20_TABLE_TYPE */
 a_inherit_au       OUT     UNAPIGEN.CHAR1_TABLE_TYPE,        /* CHAR1_TABLE_TYPE */
 a_nr_planned_sc    OUT     UNAPIGEN.NUM_TABLE_TYPE,          /* NUM_TABLE_TYPE */
 a_nr_of_rows       IN OUT  NUMBER)                           /* NUM_TYPE */
RETURN NUMBER;

FUNCTION CreateSdSamplingDetails
(a_pt               IN      VARCHAR2,                   /* VC20_TYPE */
 a_pt_version       IN OUT  VARCHAR2,                   /* VC20_TYPE */
 a_sd               IN      VARCHAR2,                   /* VC20_TYPE */
 a_filter_freq      IN      CHAR,                       /* CHAR1_TYPE */
 a_ref_date         IN      DATE,                       /* DATE_TYPE */
 a_userid           IN      VARCHAR2,                   /* VC40_TYPE */
 a_fieldtype_tab    IN      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_fieldnames_tab   IN      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_fieldvalues_tab  IN      UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_nr_of_rows       IN      NUMBER,                     /* NUM_TYPE */
 a_modify_reason    IN      VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION CreateStudy
(a_pt               IN     VARCHAR2,                    /* VC20_TYPE */
 a_pt_version       IN OUT VARCHAR2,                    /* VC20_TYPE */
 a_sd               IN OUT VARCHAR2,                    /* VC20_TYPE */
 a_ref_date         IN     DATE,                        /* DATE_TYPE */
 a_create_ic        IN     VARCHAR2,                    /* VC40_TYPE */
 a_create_sc        IN     VARCHAR2,                    /* VC40_TYPE */
 a_userid           IN     VARCHAR2,                    /* VC40_TYPE */
 a_fieldtype_tab    IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_fieldnames_tab   IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_fieldvalues_tab  IN     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_nr_of_rows       IN     NUMBER,                      /* NUM_TYPE */
 a_modify_reason    IN     VARCHAR2)                    /* VC255_TYPE */
RETURN NUMBER;

FUNCTION PlanStudy
(a_pt               IN     VARCHAR2,                    /* VC20_TYPE */
 a_pt_version       IN OUT VARCHAR2,                    /* VC20_TYPE */
 a_sd               IN OUT VARCHAR2,                    /* VC20_TYPE */
 a_ref_date         IN     DATE,                        /* DATE_TYPE */
 a_create_ic        IN     VARCHAR2,                    /* VC40_TYPE */
 a_create_sc        IN     VARCHAR2,                    /* VC40_TYPE */
 a_userid           IN     VARCHAR2,                    /* VC40_TYPE */
 a_fieldtype_tab    IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_fieldnames_tab   IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_fieldvalues_tab  IN     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_nr_of_rows       IN     NUMBER,                      /* NUM_TYPE */
 a_modify_reason    IN     VARCHAR2)                    /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GenerateSdSampleCode
(a_pt               IN     VARCHAR2,                    /* VC20_TYPE */
 a_pt_version       IN OUT VARCHAR2,                    /* VC20_TYPE */
 a_ref_date         IN     DATE,                        /* DATE_TYPE */
 a_sd               IN     VARCHAR2,                    /* VC20_TYPE */
 a_csnode           IN     NUMBER,                      /* NUM_TYPE */
 a_tpnode           IN     NUMBER,                      /* NUM_TYPE */
 a_seq              IN     NUMBER,                      /* NUM_TYPE */
 a_st               IN     VARCHAR2,                    /* VC20_TYPE */
 a_st_version       IN OUT VARCHAR2,                    /* VC20_TYPE */
 a_fieldtype_tab    IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_fieldnames_tab   IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_fieldvalues_tab  IN     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_nr_of_rows       IN     NUMBER,                      /* NUM_TYPE */
 a_sc               OUT    VARCHAR2,                    /* VC20_TYPE */
 a_edit_allowed     OUT    CHAR,                        /* CHAR1_TYPE */
 a_valid_cf         OUT    VARCHAR2)                    /* VC20_TYPE */
RETURN NUMBER;

FUNCTION GenerateStudyCode
(a_pt               IN     VARCHAR2,                    /* VC20_TYPE */
 a_pt_version       IN OUT VARCHAR2,                    /* VC20_TYPE */
 a_ref_date         IN     DATE,                        /* DATE_TYPE */
 a_fieldtype_tab    IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_fieldnames_tab   IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_fieldvalues_tab  IN     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_nr_of_rows       IN     NUMBER,                      /* NUM_TYPE */
 a_sd               OUT    VARCHAR2,                    /* VC20_TYPE */
 a_edit_allowed     OUT    CHAR,                        /* CHAR1_TYPE */
 a_valid_cf         OUT    VARCHAR2)                    /* VC20_TYPE */
RETURN NUMBER;

FUNCTION CreateSdSample
(a_pt               IN     VARCHAR2,                    /* VC20_TYPE */
 a_pt_version       IN OUT VARCHAR2,                    /* VC20_TYPE */
 a_sd               IN     VARCHAR2,                    /* VC20_TYPE */
 a_csnode           IN     NUMBER,                      /* NUM_TYPE */
 a_tpnode           IN     NUMBER,                      /* NUM_TYPE */
 a_seq              IN     NUMBER,                      /* NUM_TYPE */
 a_st               IN     VARCHAR2,                    /* VC20_TYPE */
 a_st_version       IN OUT VARCHAR2,                    /* VC20_TYPE */
 a_sc               IN OUT VARCHAR2,                    /* VC20_TYPE */
 a_ref_date         IN     DATE,                        /* DATE_TYPE */
 a_delay            IN     NUMBER,                      /* NUM_TYPE */
 a_delay_unit       IN     VARCHAR2,                    /* VC20_TYPE */
 a_userid           IN     VARCHAR2,                    /* VC40_TYPE */
 a_add_stpp         IN     CHAR,                        /* CHAR1_TYPE */
 a_add_stip         IN     CHAR,                        /* CHAR1_TYPE */
 a_pp               IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pp_version       IN OUT UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pp_key1          IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pp_key2          IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pp_key3          IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pp_key4          IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pp_key5          IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pp_nr_of_rows    IN     NUMBER,                      /* NUM_TYPE */
 a_ip               IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_ip_version       IN OUT UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_ip_nr_of_rows    IN     NUMBER,                      /* NUM_TYPE */
 a_fieldtype_tab    IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_fieldnames_tab   IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_fieldvalues_tab  IN     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_fieldnr_of_rows  IN     NUMBER,                      /* NUM_TYPE */
 a_modify_reason    IN     VARCHAR2)                    /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GetSdSample
(a_sd                  OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_sc                  OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_st                  OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_st_version          OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_description         OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_assign_date         OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_assigned_by         OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_shelf_life_val      OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE + INDICATOR */
 a_shelf_life_unit     OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_sampling_date       OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_creation_date       OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_created_by          OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_exec_start_date     OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_exec_end_date       OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_priority            OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE + INDICATOR */
 a_label_format        OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_descr_doc           OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_descr_doc_version   OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_rq                  OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_date1               OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_date2               OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_date3               OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_date4               OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_date5               OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_allow_any_pp        OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_sc_class            OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_log_hs              OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_log_hs_details      OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_allow_modify        OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_ar                  OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_active              OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_lc                  OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_lc_version          OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_ss                  OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_nr_of_rows          IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause        IN      VARCHAR2,                  /* VC511_TYPE */
 a_next_rows           IN      NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION SaveSdSample
(a_sd               IN     VARCHAR2,                    /* VC20_TYPE */
 a_sc               IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_assign_date      IN     UNAPIGEN.DATE_TABLE_TYPE,    /* DATE_TABLE_TYPE */
 a_assigned_by      IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_nr_of_rows       IN     NUMBER,                      /* NUM_TYPE */
 a_modify_reason    IN     VARCHAR2)                    /* VC255_TYPE */
RETURN NUMBER;

FUNCTION Save1SdSample
(a_sd               IN     VARCHAR2,                    /* VC20_TYPE */
 a_sc               IN     VARCHAR2,                    /* VC20_TYPE */
 a_modify_reason    IN     VARCHAR2)                    /* VC255_TYPE */
RETURN NUMBER;

FUNCTION RemoveSdSample
(a_sd               IN     VARCHAR2,                    /* VC20_TYPE */
 a_sc               IN     VARCHAR2,                    /* VC20_TYPE */
 a_modify_reason    IN     VARCHAR2)                    /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GetSdInfoCard
(a_sd             OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_ic             OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_icnode         OUT      UNAPIGEN.LONG_TABLE_TYPE,    /* LONG_TABLE_TYPE */
 a_ip_version     OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_description    OUT      UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_winsize_x      OUT      UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_winsize_y      OUT      UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_is_protected   OUT      UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_hidden         OUT      UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_manually_added OUT      UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_next_ii        OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_ic_class       OUT      UNAPIGEN.VC2_TABLE_TYPE,     /* VC2_TABLE_TYPE */
 a_log_hs         OUT      UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_log_hs_details OUT      UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_allow_modify   OUT      UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_ar             OUT      UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_active         OUT      UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_lc             OUT      UNAPIGEN.VC2_TABLE_TYPE,     /* VC2_TABLE_TYPE */
 a_lc_version     OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_ss             OUT      UNAPIGEN.VC2_TABLE_TYPE,     /* VC2_TABLE_TYPE */
 a_nr_of_rows     IN OUT   NUMBER,                      /* NUM_TYPE */
 a_where_clause   IN       VARCHAR2)                    /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetSdInfoField
(a_sd               OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
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

FUNCTION SaveSdInfoCard
(a_sd             IN      UNAPIGEN.VC20_TABLE_TYPE,       /* VC20_TABLE_TYPE */
 a_ic             IN      UNAPIGEN.VC20_TABLE_TYPE,       /* VC20_TABLE_TYPE */
 a_icnode         IN OUT  UNAPIGEN.LONG_TABLE_TYPE,       /* LONG_TABLE_TYPE */
 a_ip_version     IN      UNAPIGEN.VC20_TABLE_TYPE,       /* VC20_TABLE_TYPE */
 a_description    IN      UNAPIGEN.VC40_TABLE_TYPE,       /* VC40_TABLE_TYPE */
 a_winsize_x      IN      UNAPIGEN.NUM_TABLE_TYPE,        /* NUM_TABLE_TYPE */
 a_winsize_y      IN      UNAPIGEN.NUM_TABLE_TYPE,        /* NUM_TABLE_TYPE */
 a_is_protected   IN      UNAPIGEN.CHAR1_TABLE_TYPE,      /* CHAR1_TABLE_TYPE */
 a_hidden         IN      UNAPIGEN.CHAR1_TABLE_TYPE,      /* CHAR1_TABLE_TYPE */
 a_manually_added IN      UNAPIGEN.CHAR1_TABLE_TYPE,      /* CHAR1_TABLE_TYPE */
 a_next_ii        IN      UNAPIGEN.VC20_TABLE_TYPE,       /* VC20_TABLE_TYPE */
 a_ic_class       IN      UNAPIGEN.VC2_TABLE_TYPE,        /* VC2_TABLE_TYPE */
 a_log_hs         IN      UNAPIGEN.CHAR1_TABLE_TYPE,      /* CHAR1_TABLE_TYPE */
 a_log_hs_details IN      UNAPIGEN.CHAR1_TABLE_TYPE,      /* CHAR1_TABLE_TYPE */
 a_lc             IN      UNAPIGEN.VC2_TABLE_TYPE,        /* VC2_TABLE_TYPE */
 a_lc_version     IN      UNAPIGEN.VC20_TABLE_TYPE,       /* VC20_TABLE_TYPE */
 a_modify_flag    IN OUT  UNAPIGEN.NUM_TABLE_TYPE,        /* NUM_TABLE_TYPE */
 a_nr_of_rows     IN      NUMBER,                         /* NUM_TYPE */
 a_modify_reason  IN      VARCHAR2)                       /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SaveSdInfoField
(a_sd               IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
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

FUNCTION SaveSdIiValue
(a_sd               IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_ic               IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_icnode           IN OUT   UNAPIGEN.LONG_TABLE_TYPE,    /* LONG_TABLE_TYPE */
 a_ii               IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_iinode           IN OUT   UNAPIGEN.LONG_TABLE_TYPE,    /* LONG_TABLE_TYPE */
 a_iivalue          IN       UNAPIGEN.VC2000_TABLE_TYPE,  /* VC2000_TABLE_TYPE */
 a_modify_flag      IN OUT   UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_nr_of_rows       IN       NUMBER,                      /* NUM_TYPE */
 a_modify_reason    IN       VARCHAR2)                    /* VC255_TYPE */
RETURN NUMBER;

FUNCTION CreateSdInfoDetails
(a_pt             IN        VARCHAR2,                 /* VC20_TYPE */
 a_pt_version     IN OUT    VARCHAR2,                 /* VC20_TYPE */
 a_sd             IN        VARCHAR2,                 /* VC20_TYPE */
 a_filter_freq    IN        CHAR,                     /* CHAR1_TYPE */
 a_ref_date       IN        DATE,                     /* DATE_TYPE */
 a_modify_reason  IN        VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER;

FUNCTION AddSdInfoDetails
(a_pt             IN        VARCHAR2,                 /* VC20_TYPE */
 a_pt_version     IN        VARCHAR2,                 /* VC20_TYPE */
 a_sd             IN        VARCHAR2,                 /* VC20_TYPE */
 a_ip             IN        VARCHAR2,                 /* VC20_TYPE */
 a_ip_version     IN        VARCHAR2,                 /* VC20_TYPE */
 a_seq            IN        NUMBER,                   /* NUM_TYPE */
 a_modify_reason  IN        VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER;

FUNCTION CreateSdIcDetails
(a_pt             IN        VARCHAR2,                 /* VC20_TYPE */
 a_pt_version     IN OUT    VARCHAR2,                 /* VC20_TYPE */
 a_ip             IN        VARCHAR2,                 /* VC20_TYPE */
 a_ip_version     IN OUT    VARCHAR2,                 /* VC20_TYPE */
 a_seq            IN        NUMBER,                   /* NUM_TYPE */
 a_sd             IN        VARCHAR2,                 /* VC20_TYPE */
 a_icnode         IN        NUMBER,                   /* LONG_TYPE */
 a_modify_reason  IN        VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER;

FUNCTION AddSdIcDetails
(a_pt             IN        VARCHAR2,                 /* VC20_TYPE */
 a_pt_version     IN        VARCHAR2,                 /* VC20_TYPE */
 a_sd             IN        VARCHAR2,                 /* VC20_TYPE */
 a_ic             IN        VARCHAR2,                 /* VC20_TYPE */
 a_icnode         IN        NUMBER,                   /* LONG_TYPE */
 a_ie             IN        VARCHAR2,                 /* VC20_TYPE */
 a_ie_version     IN        VARCHAR2,                 /* VC20_TYPE */
 a_seq            IN        NUMBER,                   /* NUM_TYPE */
 a_modify_reason  IN        VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER;

FUNCTION InitSdInfoCard
(a_ip              IN     VARCHAR2,                  /* VC20_TYPE */
 a_ip_version_in   IN     VARCHAR2,                  /* VC20_TYPE */
 a_seq             IN     NUMBER,                    /* NUM_TYPE */
 a_pt              IN     VARCHAR2,                  /* VC20_TYPE */
 a_pt_version      IN     VARCHAR2,                  /* VC20_TYPE */
 a_sd              IN     VARCHAR2,                  /* VC20_TYPE */
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

FUNCTION InitSdIcAttribute
(a_sd               IN     VARCHAR2,                  /* VC20_TYPE */
 a_pt               IN     VARCHAR2,                  /* VC20_TYPE */
 a_pt_version       IN     VARCHAR2,                  /* VC20_TYPE */
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

FUNCTION InitSdIcDetails
(a_ip              IN     VARCHAR2,                   /* VC20_TYPE */
 a_ip_version      IN OUT VARCHAR2,                   /* VC20_TYPE */
 a_sd              IN     VARCHAR2,                   /* VC20_TYPE */
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

FUNCTION InitSdInfoDetails
(a_pt             IN        VARCHAR2,                  /* VC20_TYPE */
 a_pt_version     IN OUT    VARCHAR2,                  /* VC20_TYPE */
 a_sd             IN        VARCHAR2,                  /* VC20_TYPE */
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

FUNCTION GetSdIcAttribute
(a_sd                 OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
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

FUNCTION SaveSdIcAttribute
(a_sd             IN        VARCHAR2,                 /* VC20_TYPE */
 a_ic             IN        VARCHAR2,                 /* VC20_TYPE */
 a_icnode         IN        NUMBER,                   /* LONG_TYPE */
 a_au             IN        UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_au_version     IN OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_value          IN        UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_nr_of_rows     IN        NUMBER,                   /* NUM_TYPE */
 a_modify_reason  IN        VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER;

FUNCTION Save1SdIcAttribute
(a_sd             IN        VARCHAR2,                 /* VC20_TYPE */
 a_ic             IN        VARCHAR2,                 /* VC20_TYPE */
 a_icnode         IN        NUMBER,                   /* LONG_TYPE */
 a_au             IN        VARCHAR2,                 /* VC20_TYPE */
 a_au_version     IN OUT    VARCHAR2,                 /* VC20_TYPE */
 a_value          IN        UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_nr_of_rows     IN        NUMBER,                   /* NUM_TYPE */
 a_modify_reason  IN        VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SaveSdIcHistory
(a_sd                IN        VARCHAR2,                  /* VC20_TYPE */
 a_ic                IN        VARCHAR2,                  /* VC20_TYPE */
 a_icnode            IN        NUMBER,                    /* LONG_TYPE */
 a_who               IN        UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_who_description   IN        UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_what              IN        UNAPIGEN.VC60_TABLE_TYPE,  /* VC60_TABLE_TYPE */
 a_what_description  IN        UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_logdate           IN        UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_why               IN        UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_tr_seq            IN        UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_ev_seq            IN        UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_nr_of_rows        IN        NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetSdIcHistory
(a_sd               OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_ic               OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_icnode           OUT     UNAPIGEN.LONG_TABLE_TYPE,   /* LONG_TABLE_TYPE */
 a_who               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_who_description   OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_what              OUT     UNAPIGEN.VC60_TABLE_TYPE,  /* VC60_TABLE_TYPE */
 a_what_description  OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_logdate           OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_why               OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_tr_seq            OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_ev_seq            OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_nr_of_rows       IN OUT  NUMBER,                     /* NUM_TYPE */
 a_where_clause     IN      VARCHAR2)                   /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetSdIcHistory
(a_sd                OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
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

FUNCTION GetSdIcHistoryDetails
(a_sd                OUT     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
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

FUNCTION AddSdIcComment
(a_sd           IN  VARCHAR2, /* VC20_TYPE */
 a_ic           IN  VARCHAR2, /* VC20_TYPE */
 a_icnode       IN  NUMBER,   /* LONG_TYPE */
 a_comment      IN  VARCHAR2) /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GetSdIcComment
(a_sd               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_ic               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_icnode           OUT     UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_last_comment     OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_nr_of_rows       IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause     IN      VARCHAR2,                  /* VC511_TYPE */
 a_next_rows        IN      NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION SaveSdIcAccess
(a_sd                IN      VARCHAR2,                  /* VC20_TYPE */
 a_ic                IN      VARCHAR2,                  /* VC20_TYPE */
 a_icnode            IN      NUMBER,                    /* LONG_TYPE */
 a_dd                IN      UNAPIGEN.VC3_TABLE_TYPE,   /* VC3_TABLE_TYPE */
 a_access_rights     IN      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_nr_of_rows        IN      NUMBER,                    /* NUM_TYPE */
 a_modify_reason     IN      VARCHAR2)                  /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GetSdIcAccess
(a_sd                OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_ic                OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_icnode            OUT     UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_dd                OUT     UNAPIGEN.VC3_TABLE_TYPE,   /* VC3_TABLE_TYPE */
 a_data_domain       OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_access_rights     OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_nr_of_rows        IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause      IN      VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION ChangeSdIcStatus
(a_sd                IN      VARCHAR2,     /* VC20_TYPE */
 a_ic                IN      VARCHAR2,     /* VC20_TYPE */
 a_icnode            IN      NUMBER,       /* LONG_TYPE */
 a_old_ss            IN      VARCHAR2,     /* VC2_TYPE */
 a_new_ss            IN      VARCHAR2,     /* VC2_TYPE */
 a_lc                IN      VARCHAR2,     /* VC2_TYPE */
 a_lc_version        IN      VARCHAR2,     /* VC20_TYPE */
 a_modify_reason     IN      VARCHAR2)     /* VC255_TYPE */
RETURN NUMBER;

FUNCTION InternalChangeSdIcStatus          /* INTERNAL */
(a_sd                IN      VARCHAR2,     /* VC20_TYPE */
 a_ic                IN      VARCHAR2,     /* VC20_TYPE */
 a_icnode            IN      NUMBER,       /* LONG_TYPE */
 a_new_ss            IN      VARCHAR2,     /* VC2_TYPE */
 a_modify_reason     IN      VARCHAR2)     /* VC255_TYPE */
RETURN NUMBER;

FUNCTION CancelSdIc
(a_sd                IN      VARCHAR2,     /* VC20_TYPE */
 a_ic                IN      VARCHAR2,     /* VC20_TYPE */
 a_icnode            IN      NUMBER,       /* LONG_TYPE */
 a_modify_reason     IN      VARCHAR2)     /* VC255_TYPE */
RETURN NUMBER;

FUNCTION ChangeSdIcLifeCycle
(a_sd                IN      VARCHAR2,     /* VC20_TYPE */
 a_ic                IN      VARCHAR2,     /* VC20_TYPE */
 a_icnode            IN      NUMBER,       /* LONG_TYPE */
 a_old_lc            IN      VARCHAR2,     /* VC2_TYPE */
 a_old_lc_version    IN      VARCHAR2,     /* VC20_TYPE */
 a_new_lc            IN      VARCHAR2,     /* VC2_TYPE */
 a_new_lc_version    IN      VARCHAR2,     /* VC20_TYPE */
 a_modify_reason     IN      VARCHAR2)     /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SdIcElectronicSignature
(a_sd                IN      VARCHAR2,     /* VC20_TYPE */
 a_ic                IN      VARCHAR2,     /* VC20_TYPE */
 a_icnode            IN      NUMBER,       /* LONG_TYPE */
 a_authorised_by     IN      VARCHAR2,     /* VC20_TYPE */
 a_modify_reason     IN      VARCHAR2)     /* VC255_TYPE */
RETURN NUMBER;

FUNCTION InitAndSaveSdCellScAttributes                /* INTERNAL */
(a_sd               IN     VARCHAR2,                 /* VC20_TYPE */
 a_csnode            IN     NUMBER,                  /* NUM_TYPE */
 a_tpnode        IN     NUMBER,                      /* NUM_TYPE */
 a_seq              IN     NUMBER,                   /* NUM_TYPE */
 a_sc               IN     VARCHAR2)                 /* VC20_TYPE */
RETURN NUMBER;

FUNCTION GetSdConditionSet
(a_sd             OUT     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_csnode         OUT     UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_cs             OUT     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_description    OUT     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_t0_date        OUT     UNAPIGEN.DATE_TABLE_TYPE,    /* DATE_TABLE_TYPE */
 a_nr_of_rows     IN OUT  NUMBER,                      /* NUM_TYPE */
 a_where_clause   IN      VARCHAR2)                    /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetSdTimePoint
(a_sd             OUT   UNAPIGEN.VC20_TABLE_TYPE,      /* VC20_TABLE_TYPE */
 a_tpnode            OUT   UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_tp             OUT   UNAPIGEN.NUM_TABLE_TYPE,       /* NUM_TABLE_TYPE */
 a_tp_unit             OUT   UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_allow_upfront       OUT   UNAPIGEN.NUM_TABLE_TYPE,  /* NUM_TABLE_TYPE */
 a_allow_upfront_unit  OUT   UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_allow_overdue       OUT   UNAPIGEN.NUM_TABLE_TYPE,  /* NUM_TABLE_TYPE */
 a_allow_overdue_unit  OUT   UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_nr_of_rows       IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause     IN    VARCHAR2)                    /* VC511_TYPE */
RETURN NUMBER;

FUNCTION SaveSdConditionSet
(a_sd             IN    VARCHAR2,                  /* VC20_TYPE */
 a_csnode         IN OUT UNAPIGEN.NUM_TABLE_TYPE,  /* NUM_TABLE_TYPE */
 a_cs             IN    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_t0_date        IN    UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_modify_flag   IN OUT UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_nr_of_rows     IN    NUMBER,                    /* NUM_TYPE */
 a_modify_reason  IN    VARCHAR2)                  /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SaveSdTimePoint
(a_sd             IN   VARCHAR2,                       /* VC20_TYPE */
 a_tpnode             IN OUT UNAPIGEN.NUM_TABLE_TYPE,  /* NUM_TABLE_TYPE */
 a_tp             IN   UNAPIGEN.NUM_TABLE_TYPE,        /* NUM_TABLE_TYPE */
 a_tp_unit             IN   UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_allow_upfront       IN   UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_allow_upfront_unit  IN   UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_allow_overdue       IN   UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_allow_overdue_unit  IN   UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_modify_flag        IN OUT UNAPIGEN.NUM_TABLE_TYPE,  /* NUM_TABLE_TYPE */
 a_nr_of_rows       IN   NUMBER,                       /* NUM_TYPE */
 a_modify_reason    IN   VARCHAR2)                     /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GetSdCellSample
(a_sd             OUT   UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_csnode         OUT   UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_tpnode         OUT   UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_sc             OUT   UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_lo             OUT   UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_lo_description OUT   UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_lo_start_date  OUT   UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_lo_end_date    OUT   UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_nr_of_rows      IN OUT  NUMBER,                 /* NUM_TYPE */
 a_where_clause    IN    VARCHAR2)                 /* VC511_TYPE */
RETURN NUMBER;

FUNCTION SaveSdCellSample
(a_sd               IN   VARCHAR2,                 /* VC20_TYPE */
 a_csnode           IN   UNAPIGEN.NUM_TABLE_TYPE,  /* NUM_TABLE_TYPE */
 a_tpnode           IN   UNAPIGEN.NUM_TABLE_TYPE,  /* NUM_TABLE_TYPE */
 a_sc               IN   UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_lo               IN   UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_lo_description   IN   UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_lo_start_date    IN   UNAPIGEN.DATE_TABLE_TYPE, /* DATE_TABLE_TYPE */
 a_lo_end_date      IN   UNAPIGEN.DATE_TABLE_TYPE, /* DATE_TABLE_TYPE */
 a_nr_of_rows       IN   NUMBER,                   /* NUM_TYPE */
 a_modify_reason    IN   VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER;

FUNCTION EvaluateSdCsTimePoints                       /* INTERNAL */
(a_sd                       IN        VARCHAR2,       /* VC20_TYPE */
 a_csnode                   IN        VARCHAR2)       /* LONG_TYPE */
RETURN NUMBER;

FUNCTION GetSdCsCondition
(a_sd             OUT     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_csnode         OUT     UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_cs             OUT     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_cn             OUT     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_value          OUT     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_nr_of_rows     IN OUT  NUMBER,                      /* NUM_TYPE */
 a_where_clause   IN      VARCHAR2)                    /* VC511_TYPE */
RETURN NUMBER;

FUNCTION SaveSdCsCondition
(a_sd               IN    VARCHAR2,                    /* VC20_TYPE */
 a_csnode           IN    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_cs               IN    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_cn               IN    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_value            IN    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_modify_flag   IN OUT UNAPIGEN.NUM_TABLE_TYPE,       /* NUM_TABLE_TYPE */
 a_nr_of_rows     IN    NUMBER,                        /* NUM_TYPE */
 a_modify_reason  IN    VARCHAR2)                      /* VC255_TYPE */
RETURN NUMBER;

END unapisd;
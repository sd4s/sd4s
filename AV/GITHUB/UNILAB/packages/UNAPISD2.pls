create or replace PACKAGE
-- Unilab 6.7 Package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapisd2 AS

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION DeleteStudy                  /* INTERNAL */
(a_sd            IN  VARCHAR2,          /* VC20_TYPE */
 a_modify_reason IN  VARCHAR2)          /* VC255_TYPE */
RETURN NUMBER;

FUNCTION InitSdSamplingDetails                         /* INTERNAL */
(a_pt               IN      VARCHAR2,                  /* VC20_TYPE */
 a_pt_version       IN OUT  VARCHAR2,                  /* VC20_TYPE */
 a_sd               IN      VARCHAR2,                  /* VC20_TYPE */
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

FUNCTION CreateSdSamplingDetails                        /* INTERNAL */
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

FUNCTION CreateSdSample
(a_pt               IN     VARCHAR2,                    /* VC20_TYPE */
 a_pt_version       IN OUT VARCHAR2,                    /* VC20_TYPE */
 a_sd               IN     VARCHAR2,                    /* VC20_TYPE */
 a_csnode            IN     NUMBER,                      /* NUM_TYPE */
 a_tpnode         IN     NUMBER,                      /* NUM_TYPE */
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
(a_sd                  OUT    UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_sc                  OUT    UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_st                  OUT    UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_st_version          OUT    UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_description         OUT    UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_assign_date         OUT    UNAPIGEN.DATE_TABLE_TYPE,   /* DATE_TABLE_TYPE */
 a_assigned_by         OUT    UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
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

FUNCTION Save1SdSample                                  /* INTERNAL */
(a_sd               IN     VARCHAR2,                    /* VC20_TYPE */
 a_sc               IN     VARCHAR2,                    /* VC20_TYPE */
 a_modify_reason    IN     VARCHAR2)                    /* VC255_TYPE */
RETURN NUMBER;

FUNCTION RemoveSdSample                                 /* INTERNAL */
(a_sd               IN     VARCHAR2,                    /* VC20_TYPE */
 a_sc               IN     VARCHAR2,                    /* VC20_TYPE */
 a_modify_reason    IN     VARCHAR2)                    /* VC255_TYPE */
RETURN NUMBER;

FUNCTION InitAndSaveSdCellScAttributes                  /* INTERNAL */
(a_sd               IN     VARCHAR2,                    /* VC20_TYPE */
 a_csnode            IN     NUMBER,                      /* NUM_TYPE */
 a_tpnode         IN     NUMBER,                      /* NUM_TYPE */
 a_seq              IN     NUMBER,                      /* NUM_TYPE */
 a_sc               IN     VARCHAR2)                    /* VC20_TYPE */
RETURN NUMBER;


END unapisd2;
create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapirq2 AS

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION DeleteRequest                  /* INTERNAL */
(a_rq            IN  VARCHAR2,          /* VC20_TYPE */
 a_modify_reason IN  VARCHAR2)          /* VC255_TYPE */
RETURN NUMBER;

FUNCTION InitRqAnalysesDetails                         /* INTERNAL */
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

FUNCTION InitRqSamplingDetails                         /* INTERNAL */
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

FUNCTION CreateRqSamplingDetails                        /* INTERNAL */
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
 a_nr_of_rows       IN      NUMBER,
 a_modify_reason    IN      VARCHAR2)                   /* VC255_TYPE */
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

FUNCTION CreateRqSample2                                /* INTERNAL */
(a_rt               IN     VARCHAR2,                    /* VC20_TYPE */
 a_rt_version       IN OUT VARCHAR2,                    /* VC20_TYPE */
 a_rq               IN     VARCHAR2,                    /* VC20_TYPE */
 a_st               IN     VARCHAR2,                    /* VC20_TYPE */
 a_st_version       IN OUT VARCHAR2,                    /* VC20_TYPE */
 a_sc               IN OUT VARCHAR2,                    /* VC20_TYPE */
 a_ref_date         IN     DATE,                        /* DATE_TYPE */
 a_delay            IN     NUMBER,                      /* NUM_TYPE */
 a_delay_unit       IN     VARCHAR2,                    /* VC20_TYPE */
 a_create_ic        IN     VARCHAR2,                    /* VC40_TYPE */
 a_userid           IN     VARCHAR2,                    /* VC40_TYPE */
 a_pp               IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pp_version       IN OUT UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pp_key1          IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pp_key2          IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pp_key3          IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pp_key4          IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pp_key5          IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_nr_of_rows       IN     NUMBER,                      /* NUM_TYPE */
 a_fieldtype_tab    IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_fieldnames_tab   IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_fieldvalues_tab  IN     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_fieldnr_of_rows  IN     NUMBER,                      /* NUM_TYPE */
 a_modify_reason    IN     VARCHAR2)                    /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GetRqSample                                    /* INTERNAL */
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

FUNCTION SaveRqSample                                   /* INTERNAL */
(a_rq               IN     VARCHAR2,                    /* VC20_TYPE */
 a_sc               IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_assign_date      IN     UNAPIGEN.DATE_TABLE_TYPE,    /* DATE_TABLE_TYPE */
 a_assigned_by      IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_nr_of_rows       IN     NUMBER,                      /* NUM_TYPE */
 a_modify_reason    IN     VARCHAR2)                    /* VC255_TYPE */
RETURN NUMBER;

FUNCTION Save1RqSample                                  /* INTERNAL */
(a_rq               IN     VARCHAR2,                    /* VC20_TYPE */
 a_sc               IN     VARCHAR2,                    /* VC20_TYPE */
 a_assign_date      IN     DATE,                        /* DATE_TYPE */
 a_assigned_by      IN     VARCHAR2,                    /* VC20_TYPE */
 a_modify_reason    IN     VARCHAR2)                    /* VC255_TYPE */
RETURN NUMBER;

FUNCTION RemoveRqSample                                 /* INTERNAL */
(a_rq               IN     VARCHAR2,                    /* VC20_TYPE */
 a_sc               IN     VARCHAR2,                    /* VC20_TYPE */
 a_modify_reason    IN     VARCHAR2)                    /* VC255_TYPE */
RETURN NUMBER;

FUNCTION InitAndSaveRqScAttributes                     /* INTERNAL */
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

FUNCTION SaveRqPpAttribute                            /* INTERNAL */
(a_rq             IN        VARCHAR2,                 /* VC20_TYPE */
 a_pp             IN        VARCHAR2,                 /* VC20_TYPE */
 a_pp_version     IN        VARCHAR2,                 /* VC20_TYPE */
 a_au             IN        UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_au_version     IN        UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_value          IN        UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_nr_of_rows     IN        NUMBER,                   /* NUM_TYPE */
 a_modify_reason  IN        VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GetRqPpAttribute                              /* INTERNAL */
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

FUNCTION CopyRqSamplingDetails                         /* INTERNAL */
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

FUNCTION CopyRequest                 /* INTERNAL */
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

END unapirq2;
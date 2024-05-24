create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapirqic AS

FUNCTION GetVersion
RETURN VARCHAR2;

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

FUNCTION FillRqIiDefaultValue               /* INTERNAL */
(a_rq                 IN      VARCHAR2,     /* VC20_TYPE */
 a_def_val_tp         IN      CHAR,         /* CHAR1_TYPE */
 a_ievalue            IN      VARCHAR2,     /* VC2000_TYPE */
 a_def_au_level       IN      VARCHAR2,     /* VC4_TYPE */
 a_data_tp            IN      CHAR,         /* CHAR1_TYPE */
 a_format             IN      VARCHAR2,     /* VC40_TYPE */
 a_iivalue            OUT     VARCHAR2)     /* VC2000_TYPE */
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

END unapirqic;
create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapime2 AS

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION Substitute_tildes                           /* INTERNAL */
(a_sc             IN     VARCHAR2,                   /* VC20_TYPE */
 a_pg             IN     VARCHAR2,                   /* VC20_TYPE */
 a_pa             IN     VARCHAR2,                   /* VC20_TYPE */
 a_me             IN     VARCHAR2,                   /* VC20_TYPE */
 a_cell           IN     VARCHAR2,                   /* VC20_TYPE */
 a_str            IN OUT VARCHAR2,                   /* VC20_TYPE */
 a_str_tp         IN     VARCHAR2)                   /* VC20_TYPE */
RETURN NUMBER;

FUNCTION SQLSubstituteTildes                         /* INTERNAL */
(a_sc             IN     VARCHAR2,                   /* VC20_TYPE */
 a_pg             IN     VARCHAR2,                   /* VC20_TYPE */
 a_pa             IN     VARCHAR2,                   /* VC20_TYPE */
 a_me             IN     VARCHAR2,                   /* VC20_TYPE */
 a_cell           IN     VARCHAR2,                   /* VC20_TYPE */
 a_str            IN     VARCHAR2,                   /* VC20_TYPE */
 a_str_tp         IN     VARCHAR2)                   /* VC20_TYPE */
RETURN VARCHAR2;

PRAGMA RESTRICT_REFERENCES (SQLSubstituteTildes, WNDS, WNPS);
/* Can be used as SQL function PURITY LEVEL is OK */

FUNCTION EvaluateMeCellInput          /* INTERNAL */
(a_sc                   IN     VARCHAR2,    /* VC20_TYPE */
 a_pg                   IN     VARCHAR2,    /* VC20_TYPE */
 a_pgnode               IN     NUMBER,      /* VC20_TYPE */
 a_pa                   IN     VARCHAR2,    /* VC20_TYPE */
 a_panode               IN     NUMBER,      /* LONG_TYPE */
 a_me                   IN     VARCHAR2,    /* VC20_TYPE */
 a_menode               IN     NUMBER,      /* LONG_TYPE */
 a_reanalysis           IN     NUMBER,      /* NUM_TYPE */
 a_cell                 IN     VARCHAR2,    /* VC20_TYPE */
 a_format               IN     VARCHAR2,    /* VC20_TYPE */
 a_input_tp             IN     VARCHAR2,    /* VC4_TYPE */
 a_input_source         IN     VARCHAR2,    /* VC20_TYPE */
 a_input_version        IN     VARCHAR2,    /* VC20_TYPE */
 a_input_pp             IN OUT VARCHAR2,    /* VC20_TYPE */
 a_input_pgnode         IN OUT NUMBER,      /* LONG_TYPE */
 a_input_pp_version     IN OUT VARCHAR2,    /* VC20_TYPE */
 a_input_pr             IN OUT VARCHAR2,    /* VC20_TYPE */
 a_input_panode         IN OUT NUMBER,      /* LONG_TYPE */
 a_input_pr_version     IN OUT VARCHAR2,    /* VC20_TYPE */
 a_input_mt             IN OUT VARCHAR2,    /* VC20_TYPE */
 a_input_menode         IN OUT NUMBER,      /* LONG_TYPE */
 a_input_mt_version     IN OUT VARCHAR2,    /* VC20_TYPE */
 a_input_reanalysis     IN OUT NUMBER)      /* NUM_TYPE */
 RETURN NUMBER;

FUNCTION CreateScMeDetails                                           /* INTERNAL */
(a_sc                            IN        VARCHAR2,                 /* VC20_TYPE */
 a_pg                            IN        VARCHAR2,                 /* VC20_TYPE */
 a_pgnode                        IN        NUMBER,                   /* LONG_TYPE */
 a_pa                            IN        VARCHAR2,                 /* VC20_TYPE */
 a_panode                        IN        NUMBER,                   /* LONG_TYPE */
 a_me                            IN        VARCHAR2,                 /* VC20_TYPE */
 a_menode                        IN        NUMBER,                   /* LONG_TYPE */
 a_reanalysis                    IN        NUMBER,                   /* NUM_TYPE */
 a_rollback_on_detailsexist      IN        CHAR)                     /* CHAR1_TYPE */
RETURN NUMBER;

FUNCTION CreateScMeDetails                            /* INTERNAL */
(a_sc             IN        VARCHAR2,                 /* VC20_TYPE */
 a_pg             IN        VARCHAR2,                 /* VC20_TYPE */
 a_pgnode         IN        NUMBER,                   /* LONG_TYPE */
 a_pa             IN        VARCHAR2,                 /* VC20_TYPE */
 a_panode         IN        NUMBER,                   /* LONG_TYPE */
 a_me             IN        VARCHAR2,                 /* VC20_TYPE */
 a_menode         IN        NUMBER,                   /* LONG_TYPE */
 a_reanalysis     IN        NUMBER)                   /* NUM_TYPE */
RETURN NUMBER;

FUNCTION UpdateLinkedScMeCell                         /* INTERNAL */
(a_sc                          IN     VARCHAR2,       /* VC20_TYPE */
 a_pg                          IN     VARCHAR2,       /* VC20_TYPE */
 a_pgnode                      IN     NUMBER,         /* LONG_TYPE */
 a_pa                          IN     VARCHAR2,       /* VC20_TYPE */
 a_panode                      IN     NUMBER,         /* LONG_TYPE */
 a_me                          IN     VARCHAR2,       /* VC20_TYPE */
 a_menode                      IN     NUMBER,         /* LONG_TYPE */
 a_me_std_property             IN     VARCHAR2,       /* VC40_TYPE */
 a_mt_version                  IN     VARCHAR2,       /* VC20_TYPE */
 a_description                 IN     VARCHAR2,       /* VC40_TYPE */
 a_unit                        IN     VARCHAR2,       /* VC20_TYPE */
 a_exec_start_date             IN     DATE,           /* DATE_TYPE */
 a_exec_end_date               IN     DATE,           /* DATE_TYPE */
 a_executor                    IN     VARCHAR2,       /* VC20_TYPE */
 a_lab                         IN     VARCHAR2,       /* VC20_TYPE */
 a_eq                          IN     VARCHAR2,       /* VC20_TYPE */
 a_eq_version                  IN     VARCHAR2,       /* VC20_TYPE */
 a_planned_executor            IN     VARCHAR2,       /* VC20_TYPE */
 a_planned_eq                  IN     VARCHAR2,       /* VC20_TYPE */
 a_planned_eq_version          IN     VARCHAR2,       /* VC20_TYPE */
 a_delay                       IN     NUMBER,         /* NUM_TYPE */
 a_delay_unit                  IN     VARCHAR2,       /* VC20_TYPE */
 a_format                      IN     VARCHAR2,       /* VC40_TYPE */
 a_accuracy                    IN     FLOAT,          /* FLOAT_TYPE + INDICATOR */
 a_real_cost                   IN     VARCHAR2,       /* VC40_TYPE */
 a_real_time                   IN     VARCHAR2,       /* VC40_TYPE */
 a_sop                         IN     VARCHAR2,       /* VC40_TYPE */
 a_sop_version                 IN     VARCHAR2,       /* VC20_TYPE */
 a_plaus_low                   IN     FLOAT,          /* FLOAT_TYPE + INDICATOR */
 a_plaus_high                  IN     FLOAT,          /* FLOAT_TYPE + INDICATOR */
 a_me_class                    IN     VARCHAR2)       /* VC2_TYPE */
RETURN NUMBER;

FUNCTION GetScMeDefaultResult                            /* INTERNAL */
(a_sc               IN      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pg               IN OUT  UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pgnode           IN OUT  UNAPIGEN.LONG_TABLE_TYPE,    /* LONG_TABLE_TYPE */
 a_pa               IN OUT  UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_panode           IN OUT  UNAPIGEN.LONG_TABLE_TYPE,    /* LONG_TABLE_TYPE */
 a_me               IN OUT  UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_menode           IN OUT  UNAPIGEN.LONG_TABLE_TYPE,    /* LONG_TABLE_TYPE */
 a_value_f          OUT     UNAPIGEN.FLOAT_TABLE_TYPE,   /* FLOAT_TABLE_TYPE + INDICATOR */
 a_value_s          OUT     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_nr_of_rows       IN      NUMBER)                      /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetScReMethod                                     /* INTERNAL */
(a_sc                   OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pg                   OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pgnode               OUT     UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_pa                   OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_panode               OUT     UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_me                   OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_menode               OUT     UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_reanalysis           OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_mt_version           OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_description          OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_value_f              OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_value_s              OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_unit                 OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_exec_start_date      OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_exec_end_date        OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_executor             OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_lab                  OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_eq                   OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_eq_version           OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_planned_executor     OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_planned_eq           OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_planned_eq_version   OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_manually_entered     OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_allow_add            OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_assign_date          OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_assigned_by          OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_manually_added       OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_delay                OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE  */
 a_delay_unit           OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_format               OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_accuracy             OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_real_cost            OUT     UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_real_time            OUT     UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_calibration          OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_confirm_complete     OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_autorecalc           OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_me_result_editable   OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_next_cell            OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_sop                  OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_sop_version          OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_plaus_low            OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_plaus_high           OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_winsize_x            OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_winsize_y            OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_me_class             OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_log_hs               OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_log_hs_details       OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_allow_modify         OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_active               OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_lc                   OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_lc_version           OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_ss                   OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_reanalysedresult     OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_nr_of_rows           IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause         IN      VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

END unapime2;
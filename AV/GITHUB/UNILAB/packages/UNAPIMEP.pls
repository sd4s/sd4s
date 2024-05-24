create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapimep AS

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION GetScMeGroupKey
(a_sc              OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pg              OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pgnode          OUT    UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_pa              OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_panode          OUT    UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_me              OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_menode          OUT    UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_gk              OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_gk_version      OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_value           OUT    UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_description     OUT    UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_is_protected    OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_value_unique    OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_single_valued   OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_new_val_allowed OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_mandatory       OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_value_list_tp   OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_dsp_rows        OUT    UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_nr_of_rows      IN OUT NUMBER,                    /* NUM_TYPE */
 a_where_clause    IN     VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION InitScMeAttribute
(a_sc               IN     VARCHAR2,                  /* VC20_TYPE */
 a_pr               IN     VARCHAR2,                  /* VC20_TYPE */
 a_pr_version       IN     VARCHAR2,                  /* VC20_TYPE */
 a_mt               IN     VARCHAR2,                  /* VC20_TYPE */
 a_mt_version       IN     VARCHAR2,                  /* VC20_TYPE */
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

FUNCTION SaveScMeGroupKey
(a_sc              IN     VARCHAR2,                   /* VC20_TYPE */
 a_pg              IN     VARCHAR2,                   /* VC20_TYPE */
 a_pgnode          IN     NUMBER,                     /* LONG_TYPE */
 a_pa              IN     VARCHAR2,                   /* VC20_TYPE */
 a_panode          IN     NUMBER,                     /* LONG_TYPE */
 a_me              IN     VARCHAR2,                   /* VC20_TYPE */
 a_menode          IN     NUMBER,                     /* LONG_TYPE */
 a_gk              IN     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_gk_version      IN OUT UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_value           IN     UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_nr_of_rows      IN     NUMBER,                     /* NUM_TYPE */
 a_modify_reason   IN     VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION Save1ScMeGroupKey
(a_sc              IN     VARCHAR2,                   /* VC20_TYPE */
 a_pg              IN     VARCHAR2,                   /* VC20_TYPE */
 a_pgnode          IN     NUMBER,                     /* LONG_TYPE */
 a_pa              IN     VARCHAR2,                   /* VC20_TYPE */
 a_panode          IN     NUMBER,                     /* LONG_TYPE */
 a_me              IN     VARCHAR2,                   /* VC20_TYPE */
 a_menode          IN     NUMBER,                     /* LONG_TYPE */
 a_gk              IN     VARCHAR2,                   /* VC20_TYPE */
 a_gk_version      IN OUT VARCHAR2,                   /* VC20_TYPE */
 a_value           IN     UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_nr_of_rows      IN     NUMBER,                     /* NUM_TYPE */
 a_modify_reason   IN     VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GetScMeAttribute
(a_sc                 OUT   UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pg                 OUT   UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pgnode             OUT   UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_pa                 OUT   UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_panode             OUT   UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_me                 OUT   UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_menode             OUT   UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
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

FUNCTION SaveScMeAttribute
(a_sc             IN        VARCHAR2,                 /* VC20_TYPE */
 a_pg             IN        VARCHAR2,                 /* VC20_TYPE */
 a_pgnode         IN        NUMBER,                   /* LONG_TYPE */
 a_pa             IN        VARCHAR2,                 /* VC20_TYPE */
 a_panode         IN        NUMBER,                   /* LONG_TYPE */
 a_me             IN        VARCHAR2,                 /* VC20_TYPE */
 a_menode         IN        NUMBER,                   /* LONG_TYPE */
 a_au             IN        UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_au_version     IN OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_value          IN        UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_nr_of_rows     IN        NUMBER,                   /* NUM_TYPE */
 a_modify_reason  IN        VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER;

FUNCTION Save1ScMeAttribute
(a_sc             IN        VARCHAR2,                 /* VC20_TYPE */
 a_pg             IN        VARCHAR2,                 /* VC20_TYPE */
 a_pgnode         IN        NUMBER,                   /* LONG_TYPE */
 a_pa             IN        VARCHAR2,                 /* VC20_TYPE */
 a_panode         IN        NUMBER,                   /* LONG_TYPE */
 a_me             IN        VARCHAR2,                 /* VC20_TYPE */
 a_menode         IN        NUMBER,                   /* LONG_TYPE */
 a_au             IN        VARCHAR2,                 /* VC20_TYPE */
 a_au_version     IN OUT    VARCHAR2,                 /* VC20_TYPE */
 a_value          IN        UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_nr_of_rows     IN        NUMBER,                   /* NUM_TYPE */
 a_modify_reason  IN        VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER;

FUNCTION InitAndSaveScMeAttributes
(a_sc               IN      VARCHAR2,                  /* VC20_TYPE */
 a_pg               IN      VARCHAR2,                  /* VC20_TYPE */
 a_pgnode           IN      NUMBER,                    /* NUM_TYPE */
 a_pa               IN      VARCHAR2,                  /* VC20_TYPE */
 a_panode           IN      NUMBER,                    /* NUM_TYPE */
 a_me               IN      VARCHAR2,                  /* VC20_TYPE */
 a_menode           IN      NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetScMeHistory
(a_sc                OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pg                OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pgnode            OUT     UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_pa                OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_panode            OUT     UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_me                OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_menode            OUT     UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_who               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_who_description   OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_what              OUT     UNAPIGEN.VC60_TABLE_TYPE,  /* VC60_TABLE_TYPE */
 a_what_description  OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_logdate           OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_why               OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_tr_seq            OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_ev_seq            OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_nr_of_rows        IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause      IN      VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetScMeHistory
(a_sc                OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pg                OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pgnode            OUT     UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_pa                OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_panode            OUT     UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_me                OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_menode            OUT     UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
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

FUNCTION GetScMeHistoryDetails
(a_sc                OUT     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pg                OUT     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pgnode            OUT     UNAPIGEN.LONG_TABLE_TYPE,    /* LONG_TABLE_TYPE */
 a_pa                OUT     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_panode            OUT     UNAPIGEN.LONG_TABLE_TYPE,    /* LONG_TABLE_TYPE */
 a_me                OUT     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_menode            OUT     UNAPIGEN.LONG_TABLE_TYPE,    /* LONG_TABLE_TYPE */
 a_tr_seq            OUT     UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_ev_seq            OUT     UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_seq               OUT     UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_details           OUT     UNAPIGEN.VC4000_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_nr_of_rows        IN OUT  NUMBER,                      /* NUM_TYPE */
 a_where_clause      IN      VARCHAR2,                    /* VC511_TYPE */
 a_next_rows         IN      NUMBER)                      /* NUM_TYPE */
RETURN NUMBER;

FUNCTION SaveScMeHistory
(a_sc                IN        VARCHAR2,                  /* VC20_TYPE */
 a_pg                IN        VARCHAR2,                  /* VC20_TYPE */
 a_pgnode            IN        NUMBER,                    /* LONG_TYPE */
 a_pa                IN        VARCHAR2,                  /* VC20_TYPE */
 a_panode            IN        NUMBER,                    /* LONG_TYPE */
 a_me                IN        VARCHAR2,                  /* VC20_TYPE */
 a_menode            IN        NUMBER,                    /* LONG_TYPE */
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

FUNCTION AddScMeComment
(a_sc           IN  VARCHAR2,                 /* VC20_TYPE */
 a_pg           IN  VARCHAR2,                 /* VC20_TYPE */
 a_pgnode       IN  NUMBER,                   /* LONG_TYPE */
 a_pa           IN  VARCHAR2,                 /* VC20_TYPE */
 a_panode       IN  NUMBER,                   /* LONG_TYPE */
 a_me           IN  VARCHAR2,                 /* VC20_TYPE */
 a_menode       IN  NUMBER,                   /* LONG_TYPE */
 a_comment      IN  VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GetScMeComment
(a_sc               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pg               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pgnode           OUT     UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_pa               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_panode           OUT     UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_me               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_menode           OUT     UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_last_comment     OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_nr_of_rows       IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause     IN      VARCHAR2,                  /* VC511_TYPE */
 a_next_rows        IN      NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION ScMeTransitionAuthorised          /* INTERNAL */
(a_sc                IN      VARCHAR2,     /* VC20_TYPE */
 a_pg                IN      VARCHAR2,     /* VC20_TYPE */
 a_pgnode            IN      NUMBER,       /* LONG_TYPE */
 a_pa                IN      VARCHAR2,     /* VC20_TYPE */
 a_panode            IN      NUMBER,       /* LONG_TYPE */
 a_me                IN      VARCHAR2,     /* VC20_TYPE */
 a_menode            IN      NUMBER,       /* LONG_TYPE */
 a_reanalysis        IN      NUMBER,       /* NUM_TYPE */
 a_lc                IN OUT  VARCHAR2,     /* VC2_TYPE */
 a_lc_version        IN OUT  VARCHAR2,     /* VC20_TYPE */
 a_old_ss            IN OUT  VARCHAR2,     /* VC2_TYPE */
 a_new_ss            IN      VARCHAR2,     /* VC2_TYPE */
 a_authorised_by     IN      VARCHAR2,     /* VC20_TYPE */
 a_lc_ss_from        OUT     VARCHAR2,     /* VC2_TYPE */
 a_tr_no             OUT     NUMBER,       /* NUM_TYPE */
 a_allow_modify      OUT     CHAR,         /* CHAR1_TYPE */
 a_active            OUT     CHAR,         /* CHAR1_TYPE */
 a_log_hs            OUT     CHAR,         /* CHAR1_TYPE */
 a_log_hs_details    OUT     CHAR)         /* CHAR1_TYPE */
RETURN NUMBER;

FUNCTION ChangeScMeStatus
(a_sc                IN      VARCHAR2,     /* VC20_TYPE */
 a_pg                IN      VARCHAR2,     /* VC20_TYPE */
 a_pgnode            IN      NUMBER,       /* LONG_TYPE */
 a_pa                IN      VARCHAR2,     /* VC20_TYPE */
 a_panode            IN      NUMBER,       /* LONG_TYPE */
 a_me                IN      VARCHAR2,     /* VC20_TYPE */
 a_menode            IN      NUMBER,       /* LONG_TYPE */
 a_reanalysis        IN      NUMBER,       /* NUM_TYPE */
 a_old_ss            IN      VARCHAR2,     /* VC2_TYPE */
 a_new_ss            IN      VARCHAR2,     /* VC2_TYPE */
 a_lc                IN      VARCHAR2,     /* VC2_TYPE */
 a_lc_version        IN      VARCHAR2,     /* VC20_TYPE */
 a_modify_reason     IN      VARCHAR2)     /* VC255_TYPE */
RETURN NUMBER;

FUNCTION InternalChangeScMeStatus          /* INTERNAL */
(a_sc                IN      VARCHAR2,     /* VC20_TYPE */
 a_pg                IN      VARCHAR2,     /* VC20_TYPE */
 a_pgnode            IN      NUMBER,       /* LONG_TYPE */
 a_pa                IN      VARCHAR2,     /* VC20_TYPE */
 a_panode            IN      NUMBER,       /* LONG_TYPE */
 a_me                IN      VARCHAR2,     /* VC20_TYPE */
 a_menode            IN      NUMBER,       /* LONG_TYPE */
 a_reanalysis        IN      NUMBER,       /* NUM_TYPE */
 a_new_ss            IN      VARCHAR2,     /* VC2_TYPE */
 a_modify_reason     IN      VARCHAR2)     /* VC255_TYPE */
RETURN NUMBER;

FUNCTION CancelScMe
(a_sc                IN      VARCHAR2,     /* VC20_TYPE */
 a_pg                IN      VARCHAR2,     /* VC20_TYPE */
 a_pgnode            IN      NUMBER,       /* LONG_TYPE */
 a_pa                IN      VARCHAR2,     /* VC20_TYPE */
 a_panode            IN      NUMBER,       /* LONG_TYPE */
 a_me                IN      VARCHAR2,     /* VC20_TYPE */
 a_menode            IN      NUMBER,       /* LONG_TYPE */
 a_reanalysis        IN      NUMBER,       /* NUM_TYPE */
 a_modify_reason     IN      VARCHAR2)     /* VC255_TYPE */
RETURN NUMBER;

FUNCTION ChangeScMeLifeCycle
(a_sc                IN      VARCHAR2,     /* VC20_TYPE */
 a_pg                IN      VARCHAR2,     /* VC20_TYPE */
 a_pgnode            IN      NUMBER,       /* LONG_TYPE */
 a_pa                IN      VARCHAR2,     /* VC20_TYPE */
 a_panode            IN      NUMBER,       /* LONG_TYPE */
 a_me                IN      VARCHAR2,     /* VC20_TYPE */
 a_menode            IN      NUMBER,       /* LONG_TYPE */
 a_reanalysis        IN      NUMBER,       /* NUM_TYPE */
 a_old_lc            IN      VARCHAR2,     /* VC2_TYPE */
 a_old_lc_version    IN      VARCHAR2,     /* VC20_TYPE */
 a_new_lc            IN      VARCHAR2,     /* VC2_TYPE */
 a_new_lc_version    IN      VARCHAR2,     /* VC20_TYPE */
 a_modify_reason     IN      VARCHAR2)     /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SelectScMeGkValues
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

FUNCTION SelectScMeGkValues
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

FUNCTION SelectScMePropValues
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

FUNCTION SelectScMePropValues
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

FUNCTION ReanalScMeFromDetails                      /* INTERNAL */
(a_sc               IN        VARCHAR2,                 /* VC20_TYPE */
 a_pg               IN        VARCHAR2,                 /* VC20_TYPE */
 a_pgnode           IN        NUMBER,                   /* LONG_TYPE */
 a_pa               IN        VARCHAR2,                 /* VC20_TYPE */
 a_panode           IN        NUMBER,                   /* LONG_TYPE */
 a_me               IN        VARCHAR2,                 /* VC20_TYPE */
 a_menode           IN        NUMBER,                   /* LONG_TYPE */
 a_reanalysis       IN OUT    NUMBER,                   /* NUM_TYPE */
 a_modify_reason    IN        VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER;

FUNCTION ReanalScPaFromDetails                      /* INTERNAL */
(a_sc               IN    VARCHAR2,                 /* VC20_TYPE */
 a_pg               IN    VARCHAR2,                 /* VC20_TYPE */
 a_pgnode           IN    NUMBER,                   /* LONG_TYPE */
 a_pa               IN    VARCHAR2,                 /* VC20_TYPE */
 a_panode           IN    NUMBER,                   /* LONG_TYPE */
 a_reanalysis       OUT   NUMBER,                   /* NUM_TYPE */
 a_modify_reason    IN    VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER;

FUNCTION ReanalScMethod
(a_sc             IN        VARCHAR2,                 /* VC20_TYPE */
 a_pg             IN        VARCHAR2,                 /* VC20_TYPE */
 a_pgnode         IN        NUMBER,                   /* LONG_TYPE */
 a_pa             IN        VARCHAR2,                 /* VC20_TYPE */
 a_panode         IN        NUMBER,                   /* LONG_TYPE */
 a_me             IN        VARCHAR2,                 /* VC20_TYPE */
 a_menode         IN        NUMBER,                   /* LONG_TYPE */
 a_reanalysis     IN OUT    NUMBER,                   /* NUM_TYPE */
 a_modify_reason  IN        VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER;

FUNCTION FillMeDefaultValue              /* INTERNAL */
(a_sc               IN      VARCHAR2,    /* VC20_TYPE */
 a_pg               IN OUT  VARCHAR2,    /* VC20_TYPE */
 a_pgnode           IN OUT  NUMBER,      /* LONG_TYPE */
 a_pa               IN OUT  VARCHAR2,    /* VC20_TYPE */
 a_panode           IN OUT  NUMBER,      /* LONG_TYPE */
 a_me               IN OUT  VARCHAR2,    /* VC20_TYPE */
 a_menode           IN OUT  NUMBER,      /* LONG_TYPE */
 a_def_val_tp       IN CHAR,             /* CHAR1_TYPE */
 a_def_val          IN VARCHAR2,         /* VC40_TYPE */
 a_def_au_level     IN VARCHAR2,         /* VC4_TYPE */
 a_format           IN VARCHAR2,         /* VC40_TYPE*/
 a_value_f          OUT     FLOAT,       /* FLOAT_TYPE + INDICATOR */
 a_value_s          OUT     VARCHAR2)    /* VC40_TYPE */
RETURN NUMBER;

FUNCTION GetScMeAccess
(a_sc             OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pg             OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pgnode         OUT     UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_pa             OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_panode         OUT     UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_me             OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_menode         OUT     UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_dd             OUT     UNAPIGEN.VC3_TABLE_TYPE,   /* VC3_TABLE_TYPE */
 a_data_domain    OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_access_rights  OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_nr_of_rows     IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause   IN      VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION SaveScMeAccess
(a_sc             IN      VARCHAR2,                  /* VC20_TYPE */
 a_pg             IN      VARCHAR2,                  /* VC20_TYPE */
 a_pgnode         IN      NUMBER,                    /* LONG_TYPE */
 a_pa             IN      VARCHAR2,                  /* VC20_TYPE */
 a_panode         IN      NUMBER,                    /* LONG_TYPE */
 a_me             IN      VARCHAR2,                  /* VC20_TYPE */
 a_menode         IN      NUMBER,                    /* LONG_TYPE */
 a_dd             IN      UNAPIGEN.VC3_TABLE_TYPE,   /* VC3_TABLE_TYPE */
 a_access_rights  IN      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_nr_of_rows     IN      NUMBER,                    /* NUM_TYPE */
 a_modify_reason  IN      VARCHAR2)                  /* VC255_TYPE */
RETURN NUMBER;

FUNCTION ScMeElectronicSignature
(a_sc                IN      VARCHAR2,     /* VC20_TYPE */
 a_pg                IN      VARCHAR2,     /* VC20_TYPE */
 a_pgnode            IN      NUMBER,       /* LONG_TYPE */
 a_pa                IN      VARCHAR2,     /* VC20_TYPE */
 a_panode            IN      NUMBER,       /* LONG_TYPE */
 a_me                IN      VARCHAR2,     /* VC20_TYPE */
 a_menode            IN      NUMBER,       /* LONG_TYPE */
 a_reanalysis        IN      NUMBER,       /* NUM_TYPE */
 a_authorised_by     IN      VARCHAR2,     /* VC20_TYPE */
 a_modify_reason     IN      VARCHAR2)     /* VC255_TYPE */
RETURN NUMBER;

FUNCTION DeleteScMeDetails                            /* INTERNAL */
(a_sc             IN        VARCHAR2,                 /* VC20_TYPE */
 a_pg             IN        VARCHAR2,                 /* VC20_TYPE */
 a_pgnode         IN        NUMBER,                   /* LONG_TYPE */
 a_pa             IN        VARCHAR2,                 /* VC20_TYPE */
 a_panode         IN        NUMBER,                   /* LONG_TYPE */
 a_me             IN        VARCHAR2,                 /* VC20_TYPE */
 a_menode         IN        NUMBER,                   /* LONG_TYPE */
 a_reanalysis     IN        NUMBER)                   /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetScMeLsCommonLcAndStatus
(a_sc            IN     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pg            IN     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pgnode        IN     UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_pa            IN     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_panode        IN     UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_me            IN     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_menode        IN     UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_reanalysis    IN     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_lc            OUT    VARCHAR2,                  /* VC2_TYPE */
 a_lc_version    OUT    VARCHAR2,                  /* VC20_TYPE */
 a_ss            OUT    VARCHAR2,                  /* VC2_TYPE */
 a_nr_of_rows    IN     NUMBER,                    /* NUM_TYPE */
 a_next_rows     IN     NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION ChangeScMeLsStatus
(a_old_ss        IN     VARCHAR2,                  /* VC2_TYPE */
 a_new_ss        IN     VARCHAR2,                  /* VC2_TYPE */
 a_lc            IN     VARCHAR2,                  /* VC2_TYPE */
 a_lc_version    IN     VARCHAR2,                  /* VC20_TYPE */
 a_sc            IN     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pg            IN     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pgnode        IN     UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_pa            IN     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_panode        IN     UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_me            IN     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_menode        IN     UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_reanalysis    IN     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_modify_flag   OUT    UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_nr_of_rows    IN     NUMBER,                    /* NUM_TYPE */
 a_next_rows     IN     NUMBER,                    /* NUM_TYPE */
 a_modify_reason IN     VARCHAR2)                  /* VC255_TYPE */
RETURN NUMBER;

FUNCTION CancelScMeLs
(a_sc            IN     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pg            IN     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pgnode        IN     UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_pa            IN     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_panode        IN     UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_me            IN     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_menode        IN     UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_reanalysis    IN     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_modify_flag   OUT    UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_nr_of_rows    IN     NUMBER,                    /* NUM_TYPE */
 a_next_rows     IN     NUMBER,                    /* NUM_TYPE */
 a_modify_reason IN     VARCHAR2)                  /* VC255_TYPE */
RETURN NUMBER;

FUNCTION ScMeLsElectronicSignature
(a_sc            IN     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pg            IN     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pgnode        IN     UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_pa            IN     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_panode        IN     UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_me            IN     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_menode        IN     UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_reanalysis    IN     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_authorised_by IN     VARCHAR2,                  /* VC20_TYPE */
 a_modify_flag   OUT    UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_nr_of_rows    IN     NUMBER,                    /* NUM_TYPE */
 a_next_rows     IN     NUMBER,                    /* NUM_TYPE */
 a_modify_reason IN     VARCHAR2)                  /* VC255_TYPE */
RETURN NUMBER;

END unapimep;
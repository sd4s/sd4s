create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapiicp AS

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION GetScIcAttribute
(a_sc                 OUT   UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_ic                 OUT   UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_icnode             OUT   UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
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

FUNCTION SaveScIcAttribute
(a_sc             IN        VARCHAR2,                 /* VC20_TYPE */
 a_ic             IN        VARCHAR2,                 /* VC20_TYPE */
 a_icnode         IN        NUMBER,                   /* LONG_TYPE */
 a_au             IN        UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_au_version     IN OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_value          IN        UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_nr_of_rows     IN        NUMBER,                   /* NUM_TYPE */
 a_modify_reason  IN        VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER;

FUNCTION Save1ScIcAttribute
(a_sc             IN        VARCHAR2,                 /* VC20_TYPE */
 a_ic             IN        VARCHAR2,                 /* VC20_TYPE */
 a_icnode         IN        NUMBER,                   /* LONG_TYPE */
 a_au             IN        VARCHAR2,                 /* VC20_TYPE */
 a_au_version     IN OUT    VARCHAR2,                 /* VC20_TYPE */
 a_value          IN        UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_nr_of_rows     IN        NUMBER,                   /* NUM_TYPE */
 a_modify_reason  IN        VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER;

FUNCTION InitAndSaveScIcAttributes                     /* INTERNAL */
(a_sc               IN      VARCHAR2,                  /* VC20_TYPE */
 a_ic               IN      VARCHAR2,                  /* VC20_TYPE */
 a_icnode           IN      NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetScIcHistory
(a_sc                OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
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
 a_where_clause      IN      VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetScIcHistory
(a_sc                OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
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

FUNCTION GetScIcHistoryDetails
(a_sc                OUT     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
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

FUNCTION SaveScIcHistory
(a_sc                IN        VARCHAR2,                  /* VC20_TYPE */
 a_ic                IN        VARCHAR2,                  /* VC20_TYPE */
 a_icnode            IN        NUMBER,                    /* LONG_TYPE */
 a_who               IN     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_who_description   IN     UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_what              IN     UNAPIGEN.VC60_TABLE_TYPE,   /* VC60_TABLE_TYPE */
 a_what_description  IN     UNAPIGEN.VC255_TABLE_TYPE,  /* VC255_TABLE_TYPE */
 a_logdate           IN     UNAPIGEN.DATE_TABLE_TYPE,   /* DATE_TABLE_TYPE */
 a_why               IN     UNAPIGEN.VC255_TABLE_TYPE,  /* VC255_TABLE_TYPE */
 a_tr_seq            IN     UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_ev_seq            IN     UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_nr_of_rows        IN        NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION AddScIcComment
(a_sc           IN  VARCHAR2, /* VC20_TYPE */
 a_ic           IN  VARCHAR2, /* VC20_TYPE */
 a_icnode       IN  NUMBER,   /* LONG_TYPE */
 a_comment      IN  VARCHAR2) /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GetScIcComment
(a_sc               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_ic               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_icnode           OUT     UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_last_comment     OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_nr_of_rows       IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause     IN      VARCHAR2,                  /* VC511_TYPE */
 a_next_rows        IN      NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetScIcAccess
(a_sc                OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_ic                OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_icnode            OUT     UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_dd                OUT     UNAPIGEN.VC3_TABLE_TYPE,   /* VC3_TABLE_TYPE */
 a_data_domain       OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_access_rights     OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_nr_of_rows        IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause      IN      VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION SaveScIcAccess
(a_sc                IN      VARCHAR2,                  /* VC20_TYPE */
 a_ic                IN      VARCHAR2,                  /* VC20_TYPE */
 a_icnode            IN      NUMBER,                    /* LONG_TYPE */
 a_dd                IN      UNAPIGEN.VC3_TABLE_TYPE,   /* VC3_TABLE_TYPE */
 a_access_rights     IN      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_nr_of_rows        IN      NUMBER,                    /* NUM_TYPE */
 a_modify_reason     IN      VARCHAR2)                  /* VC255_TYPE */
RETURN NUMBER;

FUNCTION ScIcTransitionAuthorised          /* INTERNAL */
(a_sc                IN      VARCHAR2,     /* VC20_TYPE */
 a_ic                IN      VARCHAR2,     /* VC20_TYPE */
 a_icnode            IN      NUMBER,       /* LONG_TYPE */
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

FUNCTION ChangeScIcStatus
(a_sc                IN      VARCHAR2,     /* VC20_TYPE */
 a_ic                IN      VARCHAR2,     /* VC20_TYPE */
 a_icnode            IN      NUMBER,       /* LONG_TYPE */
 a_old_ss            IN      VARCHAR2,     /* VC2_TYPE */
 a_new_ss            IN      VARCHAR2,     /* VC2_TYPE */
 a_lc                IN      VARCHAR2,     /* VC2_TYPE */
 a_lc_version        IN      VARCHAR2,     /* VC20_TYPE */
 a_modify_reason     IN      VARCHAR2)     /* VC255_TYPE */
RETURN NUMBER;

FUNCTION InternalChangeScIcStatus          /* INTERNAL */
(a_sc                IN      VARCHAR2,     /* VC20_TYPE */
 a_ic                IN      VARCHAR2,     /* VC20_TYPE */
 a_icnode            IN      NUMBER,       /* LONG_TYPE */
 a_new_ss            IN      VARCHAR2,     /* VC2_TYPE */
 a_modify_reason     IN      VARCHAR2)     /* VC255_TYPE */
RETURN NUMBER;

FUNCTION CancelScIc
(a_sc                IN      VARCHAR2,     /* VC20_TYPE */
 a_ic                IN      VARCHAR2,     /* VC20_TYPE */
 a_icnode            IN      NUMBER,       /* LONG_TYPE */
 a_modify_reason     IN      VARCHAR2)     /* VC255_TYPE */
RETURN NUMBER;

FUNCTION ChangeScIcLifeCycle
(a_sc                IN      VARCHAR2,     /* VC20_TYPE */
 a_ic                IN      VARCHAR2,     /* VC20_TYPE */
 a_icnode            IN      NUMBER,       /* LONG_TYPE */
 a_old_lc            IN      VARCHAR2,     /* VC2_TYPE */
 a_old_lc_version    IN      VARCHAR2,     /* VC20_TYPE */
 a_new_lc            IN      VARCHAR2,     /* VC2_TYPE */
 a_new_lc_version    IN      VARCHAR2,     /* VC20_TYPE */
 a_modify_reason     IN      VARCHAR2)     /* VC255_TYPE */
RETURN NUMBER;

FUNCTION ScIcElectronicSignature
(a_sc                IN      VARCHAR2,     /* VC20_TYPE */
 a_ic                IN      VARCHAR2,     /* VC20_TYPE */
 a_icnode            IN      NUMBER,       /* LONG_TYPE */
 a_authorised_by     IN      VARCHAR2,     /* VC20_TYPE */
 a_modify_reason     IN      VARCHAR2)     /* VC255_TYPE */
RETURN NUMBER;

END unapiicp;
create or replace PACKAGE
-- Unilab 6.7 Package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapidcp AS

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION GetDcAttribute
(a_dc                     OUT   UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_version                OUT   UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_au                     OUT   UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_au_version             OUT   UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_value                  OUT   UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_description            OUT   UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_is_protected           OUT   UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_single_valued          OUT   UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_new_val_allowed        OUT   UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_store_db               OUT   UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_value_list_tp          OUT   UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_run_mode               OUT   UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_service                OUT   UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_cf_value               OUT   UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_nr_of_rows             IN OUT NUMBER,                   /* NUM_TYPE */
 a_where_clause           IN     VARCHAR2)                 /* VC511_TYPE */
RETURN NUMBER;

FUNCTION SaveDcAttribute
(a_dc                       IN        VARCHAR2,                 /* VC40_TYPE */
 a_version                  IN        VARCHAR2,                 /* VC20_TYPE */
 a_au                       IN        UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_au_version               IN OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_value                    IN        UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_nr_of_rows               IN        NUMBER,                   /* NUM_TYPE */
 a_modify_reason            IN        VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER;

FUNCTION Save1DcAttribute
(a_dc                       IN        VARCHAR2,                 /* VC40_TYPE */
 a_version                  IN        VARCHAR2,                 /* VC20_TYPE */
 a_au                       IN        VARCHAR2,                 /* VC20_TYPE */
 a_au_version               IN OUT    VARCHAR2,                 /* VC20_TYPE */
 a_value                    IN        UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_nr_of_rows               IN        NUMBER,                   /* NUM_TYPE */
 a_modify_reason            IN        VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GetDcHistory
(a_dc               OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_version          OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_who              OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_who_description  OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_what             OUT     UNAPIGEN.VC60_TABLE_TYPE,  /* VC60_TABLE_TYPE */
 a_what_description OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_logdate          OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_why              OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_tr_seq           OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_ev_seq           OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_nr_of_rows       IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause     IN      VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetDcHistory
(a_dc               OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_version          OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_who              OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_who_description  OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_what             OUT     UNAPIGEN.VC60_TABLE_TYPE,  /* VC60_TABLE_TYPE */
 a_what_description OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_logdate          OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_why              OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_tr_seq           OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_ev_seq           OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_nr_of_rows       IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause     IN      VARCHAR2,                  /* VC511_TYPE */
 a_next_rows        IN      NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION SaveDcHistory
(a_dc                IN        VARCHAR2,                   /* VC40_TYPE */
 a_version           IN        VARCHAR2,                   /* VC20_TYPE */
 a_who               IN        UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_who_description   IN        UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_what              IN        UNAPIGEN.VC60_TABLE_TYPE,   /* VC60_TABLE_TYPE */
 a_what_description  IN        UNAPIGEN.VC255_TABLE_TYPE,  /* VC255_TABLE_TYPE */
 a_logdate           IN        UNAPIGEN.DATE_TABLE_TYPE,   /* DATE_TABLE_TYPE */
 a_why               IN        UNAPIGEN.VC255_TABLE_TYPE,  /* VC255_TABLE_TYPE */
 a_tr_seq            IN        UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_ev_seq            IN        UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_nr_of_rows        IN        NUMBER)                     /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetDcAccess
(a_dc                IN      VARCHAR2,                  /* VC40_TYPE */
 a_version           IN      VARCHAR2,                  /* VC20_TYPE */
 a_dd                OUT     UNAPIGEN.VC3_TABLE_TYPE,   /* VC3_TABLE_TYPE */
 a_data_domain       OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_access_rights     OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_nr_of_rows       IN OUT  NUMBER)                     /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetDcAccess
(a_dc             OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_version        OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_dd             OUT     UNAPIGEN.VC3_TABLE_TYPE,   /* VC3_TABLE_TYPE */
 a_data_domain    OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_access_rights  OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_nr_of_rows     IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause   IN      VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION SaveDcAccess
(a_dc                 IN     VARCHAR2,                  /* VC40_TYPE */
 a_version            IN     VARCHAR2,                  /* VC20_TYPE */
 a_dd                 IN     UNAPIGEN.VC3_TABLE_TYPE,   /* VC3_TABLE_TYPE */
 a_access_rights      IN     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_nr_of_rows         IN     NUMBER,                    /* NUM_TYPE */
 a_modify_reason      IN     VARCHAR2)                  /* VC255_TYPE */
RETURN NUMBER;

FUNCTION DcTransitionAuthorised
(a_dc                 IN        VARCHAR2,     /* VC40_TYPE */
 a_version            IN        VARCHAR2,     /* VC20_TYPE */
 a_lc                 IN OUT    VARCHAR2,     /* VC2_TYPE */
 a_old_ss             IN OUT    VARCHAR2,     /* VC2_TYPE */
 a_new_ss             IN        VARCHAR2,     /* VC2_TYPE */
 a_authorised_by      IN        VARCHAR2,     /* VC20_TYPE */
 a_lc_ss_from         OUT       VARCHAR2,     /* VC2_TYPE */
 a_tr_no              OUT       NUMBER,       /* NUM_TYPE */
 a_allow_modify       OUT       CHAR,         /* CHAR1_TYPE */
 a_active             OUT       CHAR,         /* CHAR1_TYPE */
 a_log_hs             OUT       CHAR)         /* CHAR1_TYPE */
RETURN NUMBER;

FUNCTION ChangeDcStatus
(a_dc                 IN        VARCHAR2, /* VC40_TYPE */
 a_version            IN        VARCHAR2, /* VC20_TYPE */
 a_old_ss             IN        VARCHAR2, /* VC2_TYPE */
 a_new_ss             IN        VARCHAR2, /* VC2_TYPE */
 a_object_lc          IN        VARCHAR2, /* VC2_TYPE */
 a_object_lc_version  IN        VARCHAR2, /* VC20_TYPE */
 a_modify_reason      IN        VARCHAR2) /* VC255_TYPE */
RETURN NUMBER;

FUNCTION InternalChangeDcStatus       /* INTERNAL */
(a_dc                 IN        VARCHAR2, /* VC40_TYPE */
 a_version            IN        VARCHAR2, /* VC20_TYPE */
 a_new_ss             IN        VARCHAR2, /* VC2_TYPE */
 a_modify_reason      IN        VARCHAR2) /* VC255_TYPE */
RETURN NUMBER;

FUNCTION CancelDc
(a_dc                 IN        VARCHAR2, /* VC40_TYPE */
 a_version            IN        VARCHAR2, /* VC20_TYPE */
 a_modify_reason      IN        VARCHAR2) /* VC255_TYPE */
RETURN NUMBER;

FUNCTION CheckinDc
(a_dc                IN       VARCHAR2, /* VC40_TYPE */
 a_version           IN OUT   VARCHAR2, /* VC20_TYPE */
 a_new_minor_version IN       CHAR,     /* VC20_TYPE */
 a_modify_reason     IN       VARCHAR2) /* VC255_TYPE */
RETURN NUMBER;

FUNCTION CheckoutDc
(a_dc                 IN        VARCHAR2, /* VC40_TYPE */
 a_version            IN        VARCHAR2, /* VC20_TYPE */
 a_url                IN        VARCHAR2, /* VC512_TYPE */
 a_modify_reason      IN        VARCHAR2) /* VC255_TYPE */
RETURN NUMBER;

FUNCTION ChangeDcLifeCycle
(a_dc                 IN        VARCHAR2, /* VC40_TYPE */
 a_version            IN        VARCHAR2, /* VC20_TYPE */
 a_old_lc             IN        VARCHAR2, /* VC2_TYPE */
 a_old_lc_version     IN        VARCHAR2, /* VC20_TYPE */
 a_new_lc             IN        VARCHAR2, /* VC2_TYPE */
 a_new_lc_version     IN        VARCHAR2, /* VC20_TYPE */
 a_modify_reason      IN        VARCHAR2) /* VC255_TYPE */
RETURN NUMBER;

FUNCTION DcElectronicSignature
(a_dc                 IN        VARCHAR2, /* VC40_TYPE */
 a_version            IN        VARCHAR2, /* VC20_TYPE */
 a_authorised_by      IN        VARCHAR2, /* VC20_TYPE */
 a_modify_reason      IN        VARCHAR2) /* VC255_TYPE */
RETURN NUMBER;

FUNCTION UpdateDcWhatDescription
(a_dc                IN        VARCHAR2,                   /* VC40_TYPE */
 a_version           IN        VARCHAR2,                   /* VC20_TYPE */
 a_what              IN        VARCHAR2,                   /* VC60_TYPE */
 a_what_description  IN        VARCHAR2,                   /* VC255_TYPE */
 a_tr_seq            IN        NUMBER,                     /* NUM_TYPE */
 a_ev_seq            IN        NUMBER)                     /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetDcGroupKey
(a_dc                 OUT    UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_version            OUT    UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_gk                 OUT    UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_gk_version         OUT    UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_value              OUT    UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_description        OUT    UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_is_protected       OUT    UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_value_unique       OUT    UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_single_valued      OUT    UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_new_val_allowed    OUT    UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_mandatory          OUT    UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_value_list_tp      OUT    UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_dsp_rows           OUT    UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_nr_of_rows         IN OUT NUMBER,                     /* NUM_TYPE */
 a_where_clause       IN     VARCHAR2)                   /* VC511_TYPE */
RETURN NUMBER;

FUNCTION SaveDcGroupKey
(a_dc                 IN       VARCHAR2,                   /* VC40_TYPE */
 a_version            IN       VARCHAR2,                   /* VC20_TYPE */
 a_gk                 IN       UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_gk_version         IN OUT   UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_value              IN       UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_nr_of_rows         IN       NUMBER,                     /* NUM_TYPE */
 a_modify_reason      IN       VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION Save1DcGroupKey
(a_dc                 IN       VARCHAR2,                   /* VC40_TYPE */
 a_version            IN       VARCHAR2,                   /* VC20_TYPE */
 a_gk                 IN       VARCHAR2,                   /* VC20_TYPE */
 a_gk_version         IN OUT   VARCHAR2,                   /* VC20_TYPE */
 a_value              IN       UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_nr_of_rows         IN       NUMBER,                     /* NUM_TYPE */
 a_modify_reason      IN       VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION CheckinDc
(a_dc                 IN       VARCHAR2,                  /* VC40_TYPE */
 a_version            OUT      VARCHAR2,                  /* VC20_TYPE */
 a_version_is_current IN       CHAR,                      /* CHAR1_TYPE */
 a_effective_from     IN       DATE,                      /* DATE_TYPE */
 a_effective_till     IN       DATE,                      /* DATE_TYPE */
 a_description        IN       VARCHAR2,                  /* VC80_TYPE */
 a_creation_date      IN       VARCHAR2,                  /* DATE_TYPE */
 a_created_by         IN       VARCHAR2,                  /* VC20_TYPE */
 a_tooltip            IN       VARCHAR2,                  /* VC255_TYPE */
 a_url                IN       VARCHAR2,                  /* VC512_TYPE */
 a_data               IN       BLOB,                      /* BLOB_TYPE */
 a_last_checkout_by   IN       VARCHAR2,                  /* VC20_TYPE */
 a_last_checkout_url  IN       VARCHAR2,                  /* VC512_TYPE */
 a_checked_out        OUT      VARCHAR2,                  /* CHAR1_TYPE */
 a_dc_class           IN       VARCHAR2,                  /* VC2_TYPE */
 a_log_hs             IN OUT   CHAR,                      /* CHAR1_TYPE */
 a_lc                 IN OUT   VARCHAR2,                  /* VC2_TYPE */
 a_lc_version         IN OUT   VARCHAR2,                  /* VC20_TYPE */
 a_new_minor_version  IN       CHAR,                      /* VC20_TYPE */
 a_modify_reason      IN       VARCHAR2)                  /* VC255_TYPE */
RETURN NUMBER;

FUNCTION UndoCheckOutDc
(a_dc                   IN    VARCHAR2) /* VC40_TYPE */
RETURN NUMBER;

FUNCTION CheckoutDc
(a_dc                      IN   VARCHAR2,     /* VC40_TYPE */
 a_version                 OUT  VARCHAR2,     /* VC20_TYPE */
 a_version_is_current      OUT  CHAR,         /* CHAR1_TYPE */
 a_effective_from          OUT  DATE,         /* DATE_TYPE */
 a_effective_till          OUT  DATE,         /* DATE_TYPE */
 a_description             OUT  VARCHAR2,     /* VC80_TYPE */
 a_creation_date           OUT  DATE,         /* DATE_TYPE */
 a_created_by              OUT  VARCHAR2,     /* VC20_TYPE */
 a_tooltip                 OUT  VARCHAR2,     /* VC255_TYPE */
 a_url                     OUT  VARCHAR2,     /* VC512_TYPE */
 a_data                    OUT  BLOB,         /* BLOB_TYPE */
 a_last_checkout_by        OUT  VARCHAR2,     /* VC20_TYPE */
 a_last_checkout_url       IN   VARCHAR2,     /* VC512_TYPE */
 a_checked_out             OUT  CHAR,         /* CHAR1_TYPE */
 a_dc_class                OUT  VARCHAR2,     /* VC2_TYPE */
 a_log_hs                  OUT  CHAR,         /* CHAR1_TYPE */
 a_allow_modify            OUT  CHAR,         /* CHAR1_TYPE */
 a_active                  OUT  CHAR,         /* CHAR1_TYPE */
 a_lc                      OUT  VARCHAR2,     /* VC2_TYPE */
 a_lc_version              OUT  VARCHAR2,     /* VC20_TYPE */
 a_ss                      OUT  VARCHAR2,     /* VC2_TYPE */
 a_modify_reason           IN   VARCHAR2)     /* VC255_TYPE */
RETURN NUMBER;

FUNCTION CheckoutDc
(a_dc                      IN   VARCHAR2,     /* VC40_TYPE */
 a_version                 OUT  VARCHAR2,     /* VC20_TYPE */
 a_version_is_current      OUT  CHAR,         /* CHAR1_TYPE */
 a_effective_from          OUT  DATE,         /* DATE_TYPE */
 a_effective_till          OUT  DATE,         /* DATE_TYPE */
 a_description             OUT  VARCHAR2,     /* VC80_TYPE */
 a_creation_date           OUT  DATE,         /* DATE_TYPE */
 a_created_by              OUT  VARCHAR2,     /* VC20_TYPE */
 a_tooltip                 OUT  VARCHAR2,     /* VC255_TYPE */
 a_url                     OUT  VARCHAR2,     /* VC512_TYPE */
 a_last_checkout_by        OUT  VARCHAR2,     /* VC20_TYPE */
 a_last_checkout_url       IN   VARCHAR2,     /* VC512_TYPE */
 a_checked_out             OUT  CHAR,         /* CHAR1_TYPE */
 a_dc_class                OUT  VARCHAR2,     /* VC2_TYPE */
 a_log_hs                  OUT  CHAR,         /* CHAR1_TYPE */
 a_allow_modify            OUT  CHAR,         /* CHAR1_TYPE */
 a_active                  OUT  CHAR,         /* CHAR1_TYPE */
 a_lc                      OUT  VARCHAR2,     /* VC2_TYPE */
 a_lc_version              OUT  VARCHAR2,     /* VC20_TYPE */
 a_ss                      OUT  VARCHAR2,     /* VC2_TYPE */
 a_modify_reason           IN   VARCHAR2)     /* VC255_TYPE */
RETURN NUMBER;

END unapidcp;
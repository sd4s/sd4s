create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
pbapiprp AS

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION GetObjectAttribute
(a_object_tp          IN    VARCHAR2,                  /* VC4_TYPE */
 a_object_id          OUT   UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_au                 OUT   UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_value              OUT   UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_description        OUT   UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_is_protected       OUT   PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_single_valued      OUT   PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_new_val_allowed    OUT   PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_store_db           OUT   PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_value_list_tp      OUT   PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_run_mode           OUT   PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_service            OUT   UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_cf_value           OUT   UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_nr_of_rows         IN OUT NUMBER,                   /* NUM_TYPE */
 a_where_clause       IN     VARCHAR2)                 /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetUsedObjectAttribute
(a_object_tp              IN     VARCHAR2,                  /* VC4_TYPE */
 a_used_object_tp         IN     VARCHAR2,                  /* VC4_TYPE */
 a_object_id              IN     VARCHAR2,                  /* VC20_TYPE */
 a_used_object_id         OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_au                     OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_value                  OUT    UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_description            OUT    UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_is_protected           OUT    PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_single_valued          OUT    PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_new_val_allowed        OUT    PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_store_db               OUT    PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_value_list_tp          OUT    PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_run_mode               OUT    PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_service                OUT    UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_cf_value               OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_nr_of_rows             IN OUT NUMBER,                    /* NUM_TYPE */
 a_where_clause           IN     VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION SaveObjectAttribute
(a_object_tp                IN        VARCHAR2,                 /* VC4_TYPE */
 a_object_id                IN        VARCHAR2,                 /* VC20_TYPE */
 a_au                       IN        UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_value                    IN        UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_nr_of_rows               IN        NUMBER,                   /* NUM_TYPE */
 a_modify_reason            IN        VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SaveUsedObjectAttribute
(a_object_tp                IN        VARCHAR2,                 /* VC4_TYPE */
 a_used_object_tp           IN        VARCHAR2,                 /* VC4_TYPE */
 a_object_id                IN        VARCHAR2,                 /* VC20_TYPE */
 a_used_object_id           IN        VARCHAR2,                 /* VC20_TYPE */
 a_au                       IN        UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_value                    IN        UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_nr_of_rows               IN        NUMBER,                   /* NUM_TYPE */
 a_modify_reason            IN        VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GetObjectHistory
(a_object_tp        IN      VARCHAR2,                  /* VC4_TYPE */
 a_object_id        OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
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

FUNCTION SaveObjectHistory
(a_object_tp         IN        VARCHAR2,                   /* VC4_TYPE */
 a_object_id         IN        VARCHAR2,                   /* VC20_TYPE */
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

FUNCTION GetObjectAccess
(a_object_tp         IN      VARCHAR2,                  /* VC4_TYPE */
 a_object_id         IN      VARCHAR2,                  /* VC20_TYPE */
 a_dd                OUT     UNAPIGEN.VC3_TABLE_TYPE,   /* VC3_TABLE_TYPE */
 a_data_domain       OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_access_rights     OUT     PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_nr_of_rows        IN OUT  NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION SaveObjectAccess
(a_object_tp          IN     VARCHAR2,                  /* VC4_TYPE */
 a_object_id          IN     VARCHAR2,                  /* VC20_TYPE */
 a_dd                 IN     UNAPIGEN.VC3_TABLE_TYPE,   /* VC3_TABLE_TYPE */
 a_access_rights      IN     PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_nr_of_rows         IN     NUMBER,                    /* NUM_TYPE */
 a_modify_reason      IN     VARCHAR2)                  /* VC255_TYPE */
RETURN NUMBER;

FUNCTION ObjectTransitionAuthorised
(a_object_tp          IN        VARCHAR2,     /* VC4_TYPE */
 a_object_id          IN        VARCHAR2,     /* VC20_TYPE */
 a_lc                 IN OUT    VARCHAR2,     /* VC2_TYPE */
 a_old_ss             IN OUT    VARCHAR2,     /* VC2_TYPE */
 a_new_ss             IN        VARCHAR2,     /* VC2_TYPE */
 a_authorised_by      IN        VARCHAR2,     /* VC20_TYPE */
 a_lc_ss_from         OUT       VARCHAR2,     /* VC2_TYPE */
 a_tr_no              OUT       NUMBER,       /* NUM_TYPE */
 a_allow_modify       OUT       VARCHAR2,     /* CHAR1_TYPE */
 a_active             OUT       VARCHAR2,     /* CHAR1_TYPE */
 a_log_hs             OUT       VARCHAR2)     /* CHAR1_TYPE */
RETURN NUMBER;

FUNCTION ChangeObjectStatus
(a_object_tp          IN        VARCHAR2, /* VC4_TYPE */
 a_object_id          IN        VARCHAR2, /* VC20_TYPE */
 a_old_ss             IN        VARCHAR2, /* VC2_TYPE */
 a_new_ss             IN        VARCHAR2, /* VC2_TYPE */
 a_object_lc          IN        VARCHAR2, /* VC2_TYPE */
 a_modify_reason      IN        VARCHAR2) /* VC255_TYPE */
RETURN NUMBER;

FUNCTION CancelObject
(a_object_tp          IN        VARCHAR2, /* VC4_TYPE */
 a_object_id          IN        VARCHAR2, /* VC20_TYPE */
 a_modify_reason      IN        VARCHAR2) /* VC255_TYPE */
RETURN NUMBER;

FUNCTION ChangeObjectLifeCycle
(a_object_tp          IN        VARCHAR2, /* VC4_TYPE */
 a_object_id          IN        VARCHAR2, /* VC20_TYPE */
 a_old_lc             IN        VARCHAR2, /* VC2_TYPE */
 a_new_lc             IN        VARCHAR2, /* VC2_TYPE */
 a_modify_reason      IN        VARCHAR2) /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GetUsedObject     /* INTERNAL */
(a_object_tp                  IN     VARCHAR2,                  /* VC4_TYPE */
 a_used_object_tp             IN     VARCHAR2,                  /* VC4_TYPE */
 a_object_id                  IN     VARCHAR2,                  /* VC20_TYPE */
 a_used_object_id             OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_description                OUT    UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_nr_of_rows                 IN OUT NUMBER,                    /* NUM_TYPE */
 a_where_clause               IN     VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION ObjectElectronicSignature
(a_object_tp          IN        VARCHAR2, /* VC4_TYPE */
 a_object_id          IN        VARCHAR2, /* VC20_TYPE */
 a_authorised_by      IN        VARCHAR2, /* VC20_TYPE */
 a_modify_reason      IN        VARCHAR2) /* VC255_TYPE */
RETURN NUMBER;

END pbapiprp;
create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapimep2 AS

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION GetScMeAccess                               /* INTERNAL */
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

FUNCTION SaveScMeAccess                             /* INTERNAL */
(a_sc             IN      VARCHAR2,                 /* VC20_TYPE */
 a_pg             IN      VARCHAR2,                 /* VC20_TYPE */
 a_pgnode         IN      NUMBER,                   /* LONG_TYPE */
 a_pa             IN      VARCHAR2,                 /* VC20_TYPE */
 a_panode         IN      NUMBER,                   /* LONG_TYPE */
 a_me             IN      VARCHAR2,                 /* VC20_TYPE */
 a_menode         IN      NUMBER,                   /* LONG_TYPE */
 a_dd             IN      UNAPIGEN.VC3_TABLE_TYPE,   /* VC3_TABLE_TYPE */
 a_access_rights  IN      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_nr_of_rows     IN      NUMBER,                    /* NUM_TYPE */
 a_modify_reason  IN      VARCHAR2)                  /* VC255_TYPE */
RETURN NUMBER;

FUNCTION InitAndSaveScMeAttributes                     /* INTERNAL */
(a_sc               IN      VARCHAR2,                  /* VC20_TYPE */
 a_pg               IN      VARCHAR2,                  /* VC20_TYPE */
 a_pgnode           IN      NUMBER,                    /* NUM_TYPE */
 a_pa               IN      VARCHAR2,                  /* VC20_TYPE */
 a_panode           IN      NUMBER,                    /* NUM_TYPE */
 a_me               IN      VARCHAR2,                  /* VC20_TYPE */
 a_menode           IN      NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetScMeComment                                /* INTERNAL */
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

FUNCTION ClearWhereUsedInMeDetails                  /* INTERNAL */
(a_object_tp        IN    VARCHAR2,                 /* VC4_TYPE */
 a_sc               IN    VARCHAR2,                 /* VC20_TYPE */
 a_pg               IN    VARCHAR2,                 /* VC20_TYPE */
 a_pgnode           IN    NUMBER,                   /* LONG_TYPE */
 a_pa               IN    VARCHAR2,                 /* VC20_TYPE */
 a_panode           IN    NUMBER,                   /* LONG_TYPE */
 a_me               IN    VARCHAR2,                 /* VC20_TYPE */
 a_menode           IN    NUMBER,                   /* LONG_TYPE */
 a_old_reanalysis   IN    NUMBER,                   /* NUM_TYPE */
 a_new_reanalysis   IN    NUMBER,                   /* NUM_TYPE */
 a_modify_reason    IN    VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER;

END unapimep2;
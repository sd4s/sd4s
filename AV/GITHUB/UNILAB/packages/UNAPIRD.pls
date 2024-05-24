create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapird AS

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION GetScRawData
(a_sc               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pg               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pgnode           OUT     UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_pa               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_panode           OUT     UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_me               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_menode           OUT     UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_rd               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_rdnode           OUT     UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_value_f          OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_value_s          OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_reanalysis       OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_nr_of_rows       IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause     IN      VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION SaveScRawData
(a_sc               IN     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pg               IN     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pgnode           IN     UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_pa               IN     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_panode           IN     UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_me               IN     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_menode           IN     UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_rd               IN     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_rdnode           IN OUT UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_value_f          IN     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_value_s          IN     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_modify_flag      IN OUT UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_nr_of_rows       IN     NUMBER,                    /* NUM_TYPE */
 a_modify_reason    IN     VARCHAR)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GetScReRawData
(a_sc               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pg               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pgnode           OUT     UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_pa               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_panode           OUT     UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_me               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_menode           OUT     UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_rd               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_rdnode           OUT     UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_value_f          OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_value_s          OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_reanalysis       OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_nr_of_rows       IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause     IN      VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION ReanalScRawData
(a_sc               IN    VARCHAR2,                 /* VC20_TYPE */
 a_pg               IN    VARCHAR2,                 /* VC20_TYPE */
 a_pgnode           IN    NUMBER,                   /* LONG_TYPE */
 a_pa               IN    VARCHAR2,                 /* VC20_TYPE */
 a_panode           IN    NUMBER,                   /* LONG_TYPE */
 a_me               IN    VARCHAR2,                 /* VC20_TYPE */
 a_menode           IN    NUMBER,                   /* LONG_TYPE */
 a_rd               IN    VARCHAR2,                 /* VC20_TYPE */
 a_rdnode           IN    NUMBER,                   /* LONG_TYPE */
 a_reanalysis       OUT   NUMBER,                   /* NUM_TYPE */
 a_modify_reason    IN    VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER;

END unapird;
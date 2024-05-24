create or replace PACKAGE
-- Unilab 6.7 Package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapics AS

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION GetConditionSet
(a_cs               OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_description      OUT    UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_description2     OUT    UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_nr_of_rows       IN OUT NUMBER,                    /* NUM_TYPE */
 a_where_clause     IN     VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION SaveConditionSet
(a_cs               IN    VARCHAR2,                   /* VC20_TYPE */
 a_description      IN    VARCHAR2,                   /* VC40_TYPE */
 a_description2     IN    VARCHAR2,                   /* VC40_TYPE */
 a_modify_reason    IN    VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION DeleteConditionSet
(a_cs            IN  VARCHAR2,                        /* VC20_TYPE */
 a_modify_reason IN  VARCHAR2)                        /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GetCsCondition
(a_cs             OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_cn             OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_value          OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_nr_of_rows     IN OUT NUMBER,                      /* NUM_TYPE */
 a_where_clause   IN     VARCHAR2)                    /* VC511_TYPE */
RETURN NUMBER;

FUNCTION SaveCsCondition
(a_cs            IN    VARCHAR2,                      /* VC20_TYPE */
 a_cn            IN    UNAPIGEN.VC20_TABLE_TYPE,      /* VC20_TABLE_TYPE */
 a_value         IN    UNAPIGEN.VC40_TABLE_TYPE,      /* VC40_TABLE_TYPE */
 a_nr_of_rows    IN    NUMBER,                        /* NUM_TYPE */
 a_modify_reason IN    VARCHAR2)                      /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GetCsAttribute
(a_cs                     OUT   UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
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

FUNCTION SaveCsAttribute
(a_cs                       IN        VARCHAR2,                 /* VC20_TYPE */
 a_au                       IN        UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_au_version               IN OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_value                    IN        UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_nr_of_rows               IN        NUMBER,                   /* NUM_TYPE */
 a_modify_reason            IN        VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER;

END unapics;
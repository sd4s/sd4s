create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapipg2 AS

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION GetFullTestPlan                                    /* INTERNAL */
(a_object_tp             IN      VARCHAR2,                  /* VC4_TYPE */
 a_object_id             IN      VARCHAR2,                  /* VC20_TYPE */
 a_object_version        IN      VARCHAR2,                  /* VC20_TYPE */
 a_tst_tp                OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_tst_id                OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_tst_id_version        OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_seq                OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_pr_seq                OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_mt_seq                OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_pp_key1               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_key2               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_key3               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_key4               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_key5               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_tst_description       OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_tst_nr_measur         OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_tst_already_assigned  OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_nr_of_rows            IN OUT  NUMBER,                    /* NUM_TYPE */
 a_next_rows             IN      NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION SaveFullTestPlan                                   /* INTERNAL */
(a_sc                    IN      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_sc_nr_of_rows         IN      NUMBER,                    /* NUM_TYPE */
 a_tst_tp                IN OUT  UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_tst_id                IN OUT  UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_tst_id_version        IN OUT  UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_seq                IN OUT  UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_pr_seq                IN OUT  UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_mt_seq                IN OUT  UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_pp_key1               IN OUT  UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_key2               IN OUT  UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_key3               IN OUT  UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_key4               IN OUT  UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_key5               IN OUT  UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_tst_nr_measur         IN OUT  UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_modify_flag           IN OUT  UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_nr_of_rows            IN OUT  NUMBER,                    /* NUM_TYPE */
 a_next_rows             IN      NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

END unapipg2;
create or replace PACKAGE
-- Unilab 6.7 Package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapicustomer AS

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION CompareCustomer
(a_sc                  IN VARCHAR2,                       /* VC20_TYPE */
 a_customer            OUT UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_limit_a_compliant   OUT UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_spec_a_compliant    OUT UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_target_a_compliant  OUT UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_limit_b_compliant   OUT UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_spec_b_compliant    OUT UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_target_b_compliant  OUT UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_limit_c_compliant   OUT UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_spec_c_compliant    OUT UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_target_c_compliant  OUT UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_all_compliant       OUT UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_nr_of_rows          IN OUT  NUMBER )                   /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetCustomerDetails
(a_sc                   IN VARCHAR2,                    /* VC20_TYPE */
 a_customer             IN VARCHAR2,                    /* VC20_TYPE */
 a_pp                   OUT UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_pp_version           OUT UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_pp_key1              OUT UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_pp_key2              OUT UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_pp_key3              OUT UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_pp_key4              OUT UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_pp_key5              OUT UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_pp_description       OUT UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_pp_seq               OUT UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_pr                   OUT UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_pr_version           OUT UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_pr_description       OUT UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_pr_seq               OUT UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_value_f              OUT UNAPIGEN.FLOAT_TABLE_TYPE,  /* FLOAT_TABLE_TYPE + INDICATOR */
 a_unit                 OUT UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_low_limit_a          OUT UNAPIGEN.FLOAT_TABLE_TYPE,  /* FLOAT_TABLE_TYPE + INDICATOR */
 a_high_limit_a         OUT UNAPIGEN.FLOAT_TABLE_TYPE,  /* FLOAT_TABLE_TYPE + INDICATOR */
 a_low_spec_a           OUT UNAPIGEN.FLOAT_TABLE_TYPE,  /* FLOAT_TABLE_TYPE + INDICATOR */
 a_high_spec_a          OUT UNAPIGEN.FLOAT_TABLE_TYPE,  /* FLOAT_TABLE_TYPE + INDICATOR */
 a_low_dev_a            OUT UNAPIGEN.FLOAT_TABLE_TYPE,  /* FLOAT_TABLE_TYPE + INDICATOR */
 a_rel_low_dev_a        OUT UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_target_a             OUT UNAPIGEN.FLOAT_TABLE_TYPE,  /* FLOAT_TABLE_TYPE + INDICATOR */
 a_high_dev_a           OUT UNAPIGEN.FLOAT_TABLE_TYPE,  /* FLOAT_TABLE_TYPE + INDICATOR */
 a_rel_high_dev_a       OUT UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_low_limit_b          OUT UNAPIGEN.FLOAT_TABLE_TYPE,  /* FLOAT_TABLE_TYPE + INDICATOR */
 a_high_limit_b         OUT UNAPIGEN.FLOAT_TABLE_TYPE,  /* FLOAT_TABLE_TYPE + INDICATOR */
 a_low_spec_b           OUT UNAPIGEN.FLOAT_TABLE_TYPE,  /* FLOAT_TABLE_TYPE + INDICATOR */
 a_high_spec_b          OUT UNAPIGEN.FLOAT_TABLE_TYPE,  /* FLOAT_TABLE_TYPE + INDICATOR */
 a_low_dev_b            OUT UNAPIGEN.FLOAT_TABLE_TYPE,  /* FLOAT_TABLE_TYPE + INDICATOR */
 a_rel_low_dev_b        OUT UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_target_b             OUT UNAPIGEN.FLOAT_TABLE_TYPE,  /* FLOAT_TABLE_TYPE + INDICATOR */
 a_high_dev_b           OUT UNAPIGEN.FLOAT_TABLE_TYPE,  /* FLOAT_TABLE_TYPE + INDICATOR */
 a_rel_high_dev_b       OUT UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_low_limit_c          OUT UNAPIGEN.FLOAT_TABLE_TYPE,  /* FLOAT_TABLE_TYPE + INDICATOR */
 a_high_limit_c         OUT UNAPIGEN.FLOAT_TABLE_TYPE,  /* FLOAT_TABLE_TYPE + INDICATOR */
 a_low_spec_c           OUT UNAPIGEN.FLOAT_TABLE_TYPE,  /* FLOAT_TABLE_TYPE + INDICATOR */
 a_high_spec_c          OUT UNAPIGEN.FLOAT_TABLE_TYPE,  /* FLOAT_TABLE_TYPE + INDICATOR */
 a_low_dev_c            OUT UNAPIGEN.FLOAT_TABLE_TYPE,  /* FLOAT_TABLE_TYPE + INDICATOR */
 a_rel_low_dev_c        OUT UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_target_c             OUT UNAPIGEN.FLOAT_TABLE_TYPE,  /* FLOAT_TABLE_TYPE + INDICATOR */
 a_high_dev_c           OUT UNAPIGEN.FLOAT_TABLE_TYPE,  /* FLOAT_TABLE_TYPE + INDICATOR */
 a_rel_high_dev_c       OUT UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_limit_a_compliant    OUT UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_spec_a_compliant     OUT UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_target_a_compliant   OUT UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_limit_b_compliant    OUT UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_spec_b_compliant     OUT UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_target_b_compliant   OUT UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_limit_c_compliant    OUT UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_spec_c_compliant     OUT UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_target_c_compliant   OUT UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_all_compliant        OUT UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_nr_of_rows           IN OUT  NUMBER )                /* NUM_TYPE */
RETURN NUMBER;

FUNCTION CreateCustomerDetails
(a_sc                  IN VARCHAR2,                    /* VC20_TYPE */
 a_customer            IN UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_nr_of_rows          IN NUMBER )                     /* NUM_TYPE */
RETURN NUMBER;

END unapicustomer;
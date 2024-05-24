create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_13.00) $
-- $Date: 2014-10-03T12:10:00 $
pbapiad AS

TYPE VC1_TABLE_TYPE   IS TABLE OF VARCHAR2(1)        INDEX BY BINARY_INTEGER;

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION GetAddress
(a_ad                  OUT     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_is_template         OUT     VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_is_user             OUT     vc1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_struct_created      OUT     vc1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_ad_tp               OUT     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_person              OUT     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_title               OUT     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_function_name       OUT     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_def_up              OUT     UNAPIGEN.LONG_TABLE_TYPE,    /* LONG_TABLE_TYPE */
 a_company             OUT     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_street              OUT     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_city                OUT     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_state               OUT     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_country             OUT     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_ad_nr               OUT     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_po_box              OUT     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_zip_code            OUT     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_phone_nr            OUT     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_ext_nr              OUT     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_fax_nr              OUT     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_email               OUT     UNAPIGEN.VC255_TABLE_TYPE,   /* VC255_TABLE_TYPE */
 a_ad_class            OUT     UNAPIGEN.VC2_TABLE_TYPE,     /* VC2_TABLE_TYPE */
 a_log_hs              OUT     vc1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_allow_modify        OUT     vc1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_active              OUT     vc1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_lc                  OUT     UNAPIGEN.VC2_TABLE_TYPE,     /* VC2_TABLE_TYPE */
 a_ss                  OUT     UNAPIGEN.VC2_TABLE_TYPE,     /* VC2_TABLE_TYPE */
 a_nr_of_rows          IN OUT  NUMBER,                      /* NUM_TYPE */
 a_where_clause        IN      VARCHAR2)                    /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetAddress
(a_ad                      OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_is_template             OUT     UNAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_is_user                 OUT     UNAPIGEN.vc1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_identification_type     OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_identified_by_string    OUT     UNAPIGEN.VC511_TABLE_TYPE, /* VC511_TABLE_TYPE */
 a_struct_created          OUT     UNAPIGEN.vc1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_ad_tp                   OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_person                  OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE  */
 a_title                   OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_function_name           OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_def_up                  OUT     UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_company                 OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_street                  OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_city                    OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_state                   OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_country                 OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_ad_nr                   OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_po_box                  OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_zip_code                OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_phone_nr                OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_ext_nr                  OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_fax_nr                  OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_email                   OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_ad_class                OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_log_hs                  OUT     UNAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_allow_modify            OUT     UNAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_active                  OUT     UNAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_lc                      OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_ss                      OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_nr_of_rows              IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause            IN      VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

END pbapiad;
create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapisc2 AS

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION CopySample                  /* INTERNAL */
(a_sc_from         IN     VARCHAR2,  /* VC20_TYPE */
 a_st_to           IN     VARCHAR2,  /* VC20_TYPE */
 a_st_to_version   IN OUT VARCHAR2,  /* VC20_TYPE */
 a_sc_to           IN OUT VARCHAR2,  /* VC20_TYPE */
 a_ref_date        IN     DATE,      /* DATE_TYPE */
 a_copy_ic         IN     VARCHAR2,  /* VC40_TYPE */
 a_copy_pg         IN     VARCHAR2,  /* VC40_TYPE */
 a_userid          IN     VARCHAR2,  /* VC40_TYPE */
 a_modify_reason   IN     VARCHAR2)  /* VC255_TYPE */
RETURN NUMBER;

FUNCTION CopyScAnalysesDetails                         /* INTERNAL */
(a_sc_from             IN        VARCHAR2,             /* VC20_TYPE */
 a_st_to               IN        VARCHAR2,             /* VC20_TYPE */
 a_st_to_version       IN OUT    VARCHAR2,             /* VC20_TYPE */
 a_sc_to               IN        VARCHAR2,             /* VC20_TYPE */
 a_copy_parameters     IN        CHAR,                 /* CHAR1_TYPE */
 a_copy_methods        IN        CHAR,                 /* CHAR1_TYPE */
 a_modify_reason       IN        VARCHAR2)             /* VC255_TYPE */
RETURN NUMBER;

FUNCTION ChangeScSampleType                            /* INTERNAL */
(a_sc               IN     VARCHAR2,                   /* VC20_TYPE */
 a_st               IN     VARCHAR2,                   /* VC20_TYPE */
 a_st_version       IN OUT VARCHAR2,                   /* VC20_TYPE */
 a_modify_reason    IN     VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION UpdateLinkedScii                     /* INTERNAL */
(a_sc                  IN     VARCHAR2,       /* VC20_TYPE */
 a_sc_std_property     IN     VARCHAR2,       /* VC40_TYPE */
 a_sc_creation         IN     CHAR,           /* CHAR1_TYPE */
 a_st                  IN     VARCHAR2,       /* VC20_TYPE */
 a_st_version          IN     VARCHAR2,       /* VC20_TYPE */
 a_description         IN     VARCHAR2,       /* VC40_TYPE */
 a_shelf_life_val      IN     NUMBER,         /* NUM_TYPE + INDICATOR */
 a_shelf_life_unit     IN     VARCHAR2,       /* VC20_TYPE */
 a_sampling_date       IN     DATE,           /* DATE_TYPE */
 a_creation_date       IN     DATE,           /* DATE_TYPE */
 a_created_by          IN     VARCHAR2,       /* VC20_TYPE */
 a_exec_start_date     IN     DATE,           /* DATE_TYPE */
 a_exec_end_date       IN     DATE,           /* DATE_TYPE */
 a_priority            IN     NUMBER,         /* NUM_TYPE + INDICATOR */
 a_label_format        IN     VARCHAR2,       /* VC20_TYPE */
 a_descr_doc           IN     VARCHAR2,       /* VC40_TYPE */
 a_descr_doc_version   IN     VARCHAR2,       /* VC20_TYPE */
 a_rq                  IN     VARCHAR2,       /* VC20_TYPE */
 a_sd                  IN     VARCHAR2,       /* VC20_TYPE */
 a_date1               IN     DATE,           /* DATE_TYPE */
 a_date2               IN     DATE,           /* DATE_TYPE */
 a_date3               IN     DATE,           /* DATE_TYPE */
 a_date4               IN     DATE,           /* DATE_TYPE */
 a_date5               IN     DATE,           /* DATE_TYPE */
 a_allow_any_pp        IN     CHAR,           /* CHAR1_TYPE */
 a_sc_class            IN     VARCHAR2)       /* VC2_TYPE */
RETURN NUMBER;

FUNCTION GetSample                                        /* INTERNAL */
(a_sc                  OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_st                  OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_st_version          OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_description         OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_shelf_life_val      OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE + INDICATOR */
 a_shelf_life_unit     OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_sampling_date       OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_creation_date       OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_created_by          OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_exec_start_date     OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_exec_end_date       OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_priority            OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE + INDICATOR */
 a_label_format        OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_descr_doc           OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_descr_doc_version   OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_rq                  OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_sd                  OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_date1               OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_date2               OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_date3               OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_date4               OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_date5               OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_allow_any_pp        OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_sc_class            OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_log_hs              OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_log_hs_details      OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_allow_modify        OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_ar                  OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_active              OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_lc                  OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_lc_version          OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_ss                  OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_nr_of_rows          IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause        IN      VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION SQLGetScBestMatchingPpLs                            /* INTERNAL */
(a_sc                     IN      VARCHAR2,                  /* VC20_TYPE */
 a_st                     IN      VARCHAR2,                  /* VC20_TYPE */
 a_st_version             IN      VARCHAR2,                  /* VC20_TYPE */
 a_fieldtype_tab          IN      VC20_NESTEDTABLE_TYPE,     /* VC20_NESTEDTABLE_TYPE */
 a_fieldnames_tab         IN      VC20_NESTEDTABLE_TYPE,     /* VC20_NESTEDTABLE_TYPE */
 a_fieldvalues_tab        IN      VC40_NESTEDTABLE_TYPE,     /* VC40_NESTEDTABLE_TYPE */
 a_fieldnr_of_rows        IN      NUMBER)                    /* NUM_TYPE */
RETURN uostppkeylist;

END unapisc2;
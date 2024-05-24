create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapiip AS

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION GetInfoProfileList
(a_ip                  OUT      UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_version             OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_version_is_current  OUT      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_effective_from      OUT      UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_effective_till      OUT      UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_description         OUT      UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_ss                  OUT      UNAPIGEN.VC2_TABLE_TYPE,  /* VC2_TABLE_TYPE */
 a_nr_of_rows          IN OUT   NUMBER,                   /* NUM_TYPE */
 a_where_clause        IN       VARCHAR2,                 /* VC511_TYPE */
 a_next_rows           IN       NUMBER)                   /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetInfoProfile
(a_ip                      OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_version                 OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_version_is_current      OUT      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_effective_from          OUT      UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_effective_till          OUT      UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_description             OUT      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_description2            OUT      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_winsize_x               OUT      UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_winsize_y               OUT      UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_is_protected            OUT      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_hidden                  OUT      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_is_template             OUT      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_sc_lc                   OUT      UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_sc_lc_version           OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_inherit_au              OUT      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_ip_class                OUT      UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_log_hs                  OUT      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_allow_modify            OUT      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_active                  OUT      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_lc                      OUT      UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_lc_version              OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_ss                      OUT      UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_nr_of_rows              IN OUT   NUMBER,                    /* NUM_TYPE */
 a_where_clause            IN       VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetIpInfoField
(a_ip            OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_version       OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_ie            OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_ie_version    OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_description   OUT      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_dsp_len       OUT      UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_dsp_tp        OUT      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_dsp_rows      OUT      UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_pos_x         OUT      UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_pos_y         OUT      UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_is_protected  OUT      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_mandatory     OUT      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_hidden        OUT      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_def_val_tp    OUT      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_def_au_level  OUT      UNAPIGEN.VC4_TABLE_TYPE,   /* VC4_TABLE_TYPE */
 a_ievalue       OUT      UNAPIGEN.VC2000_TABLE_TYPE,/* VC2000_TABLE_TYPE */
 a_nr_of_rows    IN OUT   NUMBER,                    /* NUM_TYPE */
 a_where_clause  IN       VARCHAR2,                  /* VC511_TYPE */
 a_next_rows     IN       NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetIpInfoField
(a_ip            OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_version       OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_ie            OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_ie_version    OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_description   OUT      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_description_use_ie OUT UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_dsp_len       OUT      UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_dsp_len_use_ie     OUT UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_dsp_tp        OUT      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_dsp_tp_use_ie      OUT UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_dsp_rows      OUT      UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_dsp_rows_use_ie    OUT UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_pos_x         OUT      UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_pos_y         OUT      UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_is_protected  OUT      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_mandatory     OUT      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_hidden        OUT      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_def_val_tp    OUT      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_def_au_level  OUT      UNAPIGEN.VC4_TABLE_TYPE,   /* VC4_TABLE_TYPE */
 a_ievalue       OUT      UNAPIGEN.VC2000_TABLE_TYPE,/* VC2000_TABLE_TYPE */
 a_nr_of_rows    IN OUT   NUMBER,                    /* NUM_TYPE */
 a_where_clause  IN       VARCHAR2,                  /* VC511_TYPE */
 a_next_rows     IN       NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION DeleteInfoProfile
(a_ip                  IN       VARCHAR2,          /* VC20_TYPE */
 a_version             IN       VARCHAR2,          /* VC20_TYPE */
 a_modify_reason       IN       VARCHAR2)          /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SaveInfoProfile
(a_ip                      IN       VARCHAR2,          /* VC20_TYPE */
 a_version                 IN       VARCHAR2,          /* VC20_TYPE */
 a_version_is_current      IN       CHAR,              /* CHAR1_TYPE */
 a_effective_from          IN       DATE,              /* DATE_TYPE */
 a_effective_till          IN       DATE,              /* DATE_TYPE */
 a_description             IN       VARCHAR2,          /* VC40_TYPE */
 a_description2            IN       VARCHAR2,          /* VC40_TYPE */
 a_winsize_x               IN       NUMBER,            /* NUM_TYPE */
 a_winsize_y               IN       NUMBER,            /* NUM_TYPE */
 a_is_protected            IN       CHAR,              /* CHAR1_TYPE */
 a_hidden                  IN       CHAR,              /* CHAR1_TYPE */
 a_is_template             IN       CHAR,              /* CHAR1_TYPE */
 a_sc_lc                   IN       VARCHAR2,          /* VC2_TYPE */
 a_sc_lc_version           IN       VARCHAR2,          /* VC20_TYPE */
 a_inherit_au              IN       CHAR,              /* CHAR1_TYPE */
 a_ip_class                IN       VARCHAR2,          /* VC2_TYPE */
 a_log_hs                  IN       CHAR,              /* CHAR1_TYPE */
 a_lc                      IN       VARCHAR2,          /* VC2_TYPE */
 a_lc_version              IN       VARCHAR2,          /* VC20_TYPE */
 a_modify_reason           IN       VARCHAR2)          /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SaveIpInfoField
(a_ip            IN       VARCHAR2,                  /* VC20_TYPE */
 a_version       IN       VARCHAR2,                  /* VC20_TYPE */
 a_ie            IN       UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_ie_version    IN       UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pos_x         IN       UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_pos_y         IN       UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_is_protected  IN       UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_mandatory     IN       UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_hidden        IN       UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_def_val_tp    IN       UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_def_au_level  IN       UNAPIGEN.VC4_TABLE_TYPE,   /* VC4_TABLE_TYPE */
 a_ievalue       IN       UNAPIGEN.VC2000_TABLE_TYPE,/* VC2000_TABLE_TYPE */
 a_nr_of_rows    IN       NUMBER,                    /* NUM_TYPE */
 a_next_rows     IN       NUMBER,                    /* NUM_TYPE */
 a_modify_reason IN       VARCHAR2)                  /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SaveIpInfoField
(a_ip            IN       VARCHAR2,                  /* VC20_TYPE */
 a_version       IN       VARCHAR2,                  /* VC20_TYPE */
 a_ie            IN       UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_ie_version    IN       UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pos_x         IN       UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_pos_y         IN       UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_is_protected  IN       UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_mandatory     IN       UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_hidden        IN       UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_dsp_title     IN       UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_dsp_len       IN       UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_dsp_rows      IN       UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_dsp_tp        IN       UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_def_val_tp    IN       UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_def_au_level  IN       UNAPIGEN.VC4_TABLE_TYPE,   /* VC4_TABLE_TYPE */
 a_ievalue       IN       UNAPIGEN.VC2000_TABLE_TYPE,/* VC2000_TABLE_TYPE */
 a_nr_of_rows    IN       NUMBER,                    /* NUM_TYPE */
 a_next_rows     IN       NUMBER,                    /* NUM_TYPE */
 a_modify_reason IN       VARCHAR2)                  /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SaveIpInfoField
(a_ip            IN       VARCHAR2,                  /* VC20_TYPE */
 a_version       IN       VARCHAR2,                  /* VC20_TYPE */
 a_ie            IN       UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_ie_version    IN       UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pos_x         IN       UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_pos_y         IN       UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_is_protected  IN       UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_mandatory     IN       UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_hidden        IN       UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_dsp_title     IN       UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_dsp_title_use_ie IN    UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_dsp_len       IN       UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_dsp_len_use_ie   IN    UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_dsp_rows      IN       UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_dsp_rows_use_ie  IN    UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_dsp_tp        IN       UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_dsp_tp_use_ie    IN    UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_def_val_tp    IN       UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_def_au_level  IN       UNAPIGEN.VC4_TABLE_TYPE,   /* VC4_TABLE_TYPE */
 a_ievalue       IN       UNAPIGEN.VC2000_TABLE_TYPE,/* VC2000_TABLE_TYPE */
 a_nr_of_rows    IN       NUMBER,                    /* NUM_TYPE */
 a_next_rows     IN       NUMBER,                    /* NUM_TYPE */
 a_modify_reason IN       VARCHAR2)                  /* VC255_TYPE */
RETURN NUMBER;

END unapiip;
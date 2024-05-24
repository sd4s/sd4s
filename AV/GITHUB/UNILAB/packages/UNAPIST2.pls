create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapist2 AS

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION GetStCommonIpList                                      /* INTERNAL */
(a_st                      IN       UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_version                 IN       UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_st_nr_rows              IN       NUMBER,                     /* NUM_TYPE */
 a_ip                      OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_ip_version              OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_description             OUT      UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_ip_cnt                  OUT      UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_freq_tp                 OUT      UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_freq_val                OUT      UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_freq_unit               OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_invert_freq             OUT      UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_last_sched              OUT      UNAPIGEN.DATE_TABLE_TYPE,   /* DATE_TABLE_TYPE */
 a_last_cnt                OUT      UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_last_val                OUT      UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_nr_of_rows              IN OUT   NUMBER,                     /* NUM_TYPE */
 a_next_rows               IN       NUMBER)                     /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetStCommonPpList                                      /* INTERNAL */
(a_st                      IN     UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_version                 IN     UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_st_nr_rows              IN     NUMBER,                       /* NUM_TYPE */
 a_pp                      OUT    UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_pp_version              OUT    UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_pp_key1                 OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pp_key2                 OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pp_key3                 OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pp_key4                 OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pp_key5                 OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_description             OUT    UNAPIGEN.VC40_TABLE_TYPE,     /* VC40_TABLE_TYPE */
 a_pp_cnt                  OUT    UNAPIGEN.NUM_TABLE_TYPE,      /* NUM_TABLE_TYPE */
 a_freq_tp                 OUT    UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_freq_val                OUT    UNAPIGEN.NUM_TABLE_TYPE,      /* NUM_TABLE_TYPE */
 a_freq_unit               OUT    UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_invert_freq             OUT    UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_last_sched              OUT    UNAPIGEN.DATE_TABLE_TYPE,     /* DATE_TABLE_TYPE */
 a_last_cnt                OUT    UNAPIGEN.NUM_TABLE_TYPE,      /* NUM_TABLE_TYPE */
 a_last_val                OUT    UNAPIGEN.VC40_TABLE_TYPE,     /* VC40_TABLE_TYPE */
 a_inherit_au              OUT    UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_nr_of_rows              IN OUT NUMBER,                       /* NUM_TYPE */
 a_next_rows               IN     NUMBER)                       /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetStCommonGkList                              /* INTERNAL */
(a_st              IN       UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_version         IN       UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_st_nr_rows      IN       NUMBER,                     /* NUM_TYPE */
 a_gk              OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_gk_version      OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_value           OUT      UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_description     OUT      UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_gk_cnt          OUT      UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_is_protected    OUT      UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_value_unique    OUT      UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_single_valued   OUT      UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_new_val_allowed OUT      UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_mandatory       OUT      UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_value_list_tp   OUT      UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_dsp_rows        OUT      UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_nr_of_rows      IN OUT   NUMBER,                     /* NUM_TYPE */
 a_next_rows       IN       NUMBER)                     /* NUM_TYPE */
RETURN NUMBER;

FUNCTION SaveStCommonIpList                                  /* INTERNAL */
(a_st                    IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_version               IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_st_nr_rows            IN     NUMBER,                      /* NUM_TYPE */
 a_ip                    IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_ip_version            IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_ip_flag               IN     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_is_protected          IN     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_hidden                IN     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_freq_tp               IN     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_freq_val              IN     UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_freq_unit             IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_invert_freq           IN     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_last_sched            IN     UNAPIGEN.DATE_TABLE_TYPE,    /* DATE_TABLE_TYPE */
 a_last_cnt              IN     UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_last_val              IN     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_inherit_au            IN     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_nr_of_rows            IN     NUMBER,                      /* NUM_TYPE */
 a_modify_reason         IN     VARCHAR2)                    /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SaveStCommonPpList                                  /* INTERNAL */
(a_st                    IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_version               IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_st_nr_rows            IN     NUMBER,                      /* NUM_TYPE */
 a_pp                    IN     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_pp_version            IN     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_pp_key1               IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pp_key2               IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pp_key3               IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pp_key4               IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pp_key5               IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pp_flag               IN     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_freq_tp               IN     UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_freq_val              IN     UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_freq_unit             IN     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_invert_freq           IN     UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_last_sched            IN     UNAPIGEN.DATE_TABLE_TYPE,   /* DATE_TABLE_TYPE */
 a_last_cnt              IN     UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_last_val              IN     UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_inherit_au            IN     UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_nr_of_rows            IN     NUMBER,                      /* NUM_TYPE */
 a_modify_reason         IN     VARCHAR2)                    /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SaveStCommonGkList                          /* INTERNAL */
(a_st              IN  UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE  */
 a_version         IN  UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_st_nr_rows      IN  NUMBER,                       /* NUM_TYPE   */
 a_gk              IN  UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE  */
 a_gk_version      IN  UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE  */
 a_value           IN  UNAPIGEN.VC40_TABLE_TYPE,     /* VC40_TABLE_TYPE */
 a_gk_flag         IN  UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_nr_of_rows      IN  NUMBER,                       /* NUM_TYPE         */
 a_modify_reason   IN  VARCHAR2)                     /* VC255_TYPE       */
RETURN NUMBER;

FUNCTION GetStPrFrequency                                /* INTERNAL */
(a_st                IN     VARCHAR2,                    /* VC20_TYPE */
 a_version           IN     VARCHAR2,                    /* VC20_TYPE */
 a_pp                IN     VARCHAR2,                    /* VC20_TYPE */
 a_pp_version        IN     VARCHAR2,                    /* VC20_TYPE */
 a_pp_key1           IN     VARCHAR2,                    /* VC20_TYPE */
 a_pp_key2           IN     VARCHAR2,                    /* VC20_TYPE */
 a_pp_key3           IN     VARCHAR2,                    /* VC20_TYPE */
 a_pp_key4           IN     VARCHAR2,                    /* VC20_TYPE */
 a_pp_key5           IN     VARCHAR2,                    /* VC20_TYPE */
 a_pr                OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pr_version        OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_freq_tp           OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_freq_val          OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_freq_unit         OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_invert_freq       OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_last_sched        OUT    UNAPIGEN.DATE_TABLE_TYPE,    /* DATE_TABLE_TYPE */
 a_last_cnt          OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_last_val          OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_def_freq_tp       OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_def_freq_val      OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_def_freq_unit     OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_def_invert_freq   OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_def_st_based_freq OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_def_last_sched    OUT    UNAPIGEN.DATE_TABLE_TYPE,    /* DATE_TABLE_TYPE */
 a_def_last_cnt      OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_def_last_val      OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_nr_of_rows        IN OUT NUMBER)                      /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetStMtFrequency                                /* INTERNAL */
(a_st                IN     VARCHAR2,                    /* VC20_TYPE */
 a_version           IN     VARCHAR2,                    /* VC20_TYPE */
 a_pr                IN     VARCHAR2,                    /* VC20_TYPE */
 a_pr_version        IN     VARCHAR2,                    /* VC20_TYPE */
 a_mt                OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_mt_version        OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_freq_tp           OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_freq_val          OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_freq_unit         OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_invert_freq       OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_last_sched        OUT    UNAPIGEN.DATE_TABLE_TYPE,    /* DATE_TABLE_TYPE */
 a_last_cnt          OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_last_val          OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_def_freq_tp       OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_def_freq_val      OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_def_freq_unit     OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_def_invert_freq   OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_def_st_based_freq OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_def_last_sched    OUT    UNAPIGEN.DATE_TABLE_TYPE,    /* DATE_TABLE_TYPE */
 a_def_last_cnt      OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_def_last_val      OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_nr_of_rows        IN OUT NUMBER)                      /* NUM_TYPE */
RETURN NUMBER;

FUNCTION SaveStPrFrequency                               /* INTERNAL */
(a_st                IN     VARCHAR2,                    /* VC20_TYPE */
 a_version           IN     VARCHAR2,                    /* VC20_TYPE */
 a_pp                IN     VARCHAR2,                    /* VC20_TYPE */
 a_pp_version        IN     VARCHAR2,                    /* VC20_TYPE */
 a_pp_key1           IN     VARCHAR2,                    /* VC20_TYPE */
 a_pp_key2           IN     VARCHAR2,                    /* VC20_TYPE */
 a_pp_key3           IN     VARCHAR2,                    /* VC20_TYPE */
 a_pp_key4           IN     VARCHAR2,                    /* VC20_TYPE */
 a_pp_key5           IN     VARCHAR2,                    /* VC20_TYPE */
 a_pr                IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pr_version        IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_freq_tp           IN     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_freq_val          IN     UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_freq_unit         IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_invert_freq       IN     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_last_sched        IN     UNAPIGEN.DATE_TABLE_TYPE,    /* DATE_TABLE_TYPE */
 a_last_cnt          IN     UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_last_val          IN     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_nr_of_rows        IN     NUMBER,                      /* NUM_TYPE */
 a_modify_reason     IN     VARCHAR2)                    /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SaveStMtFrequency                               /* INTERNAL */
(a_st                IN     VARCHAR2,                    /* VC20_TYPE */
 a_version           IN     VARCHAR2,                    /* VC20_TYPE */
 a_pr                IN     VARCHAR2,                    /* VC20_TYPE */
 a_pr_version        IN     VARCHAR2,                    /* VC20_TYPE */
 a_mt                IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_mt_version        IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_freq_tp           IN     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_freq_val          IN     UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_freq_unit         IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_invert_freq       IN     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_last_sched        IN     UNAPIGEN.DATE_TABLE_TYPE,    /* DATE_TABLE_TYPE */
 a_last_cnt          IN     UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_last_val          IN     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_nr_of_rows        IN     NUMBER,                      /* NUM_TYPE */
 a_modify_reason     IN     VARCHAR2)                    /* VC255_TYPE */
RETURN NUMBER;

END unapist2;
create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapiaut AS

P_AUT_OUTPUT_ON        BOOLEAN;
P_NOT_AUTHORISED       VARCHAR2(255);

P_LCTRUS_REC           utlcus%ROWTYPE;
P_OBJECT_ID            VARCHAR2(20);
P_OBJECT_VERSION       VARCHAR2(20);
P_OBJECT_TP            VARCHAR2(4);
P_LC                   VARCHAR2(2);
P_SS_FROM              VARCHAR2(2);
P_LC_SS_FROM           VARCHAR2(2);
P_SS_TO                VARCHAR2(2);
P_TR_NO                NUMBER;
P_RQ                   VARCHAR2(20);
P_CH                   VARCHAR2(20);
P_SD                   VARCHAR2(20);
P_SC                   VARCHAR2(20);
P_WS                   VARCHAR2(20);
P_PG                   VARCHAR2(20);
P_PGNODE               NUMBER(9);
P_PA                   VARCHAR2(20);
P_PANODE               NUMBER(9);
P_ME                   VARCHAR2(20);
P_MENODE               NUMBER(9);
P_IC                   VARCHAR2(20);
P_ICNODE               NUMBER(9);
P_II                   VARCHAR2(20);
P_IINODE               NUMBER(9);
P_PP_KEY1              VARCHAR2(20);
P_PP_KEY2              VARCHAR2(20);
P_PP_KEY3              VARCHAR2(20);
P_PP_KEY4              VARCHAR2(20);
P_PP_KEY5              VARCHAR2(20);
P_LAB                  VARCHAR2(20);
P_OPTIMIZER_MODE       VARCHAR2(20);
P_CASCADE_READONLY     VARCHAR2(20);

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION GetRqAuthorisation                 /* INTERNAL */
(a_rq             IN        VARCHAR2,       /* VC20_TYPE */
 a_rt_version     IN  OUT   VARCHAR2,       /* VC20_TYPE */
 a_lc             OUT       VARCHAR2,       /* VC2_TYPE */
 a_lc_version     OUT       VARCHAR2,       /* VC20_TYPE */
 a_ss             OUT       VARCHAR2,       /* VC2_TYPE */
 a_allow_modify   OUT       CHAR,           /* CHAR1_TYPE */
 a_active         OUT       CHAR,           /* CHAR1_TYPE */
 a_log_hs         OUT       CHAR,           /* CHAR1_TYPE */
 a_log_hs_details OUT       CHAR)           /* CHAR1_TYPE */
RETURN NUMBER;

FUNCTION GetScAuthorisation                 /* INTERNAL */
(a_sc             IN        VARCHAR2,       /* VC20_TYPE */
 a_st_version     IN  OUT   VARCHAR2,       /* VC20_TYPE */
 a_lc             OUT       VARCHAR2,       /* VC2_TYPE */
 a_lc_version     OUT       VARCHAR2,       /* VC20_TYPE */
 a_ss             OUT       VARCHAR2,       /* VC2_TYPE */
 a_allow_modify   OUT       CHAR,           /* CHAR1_TYPE */
 a_active         OUT       CHAR,           /* CHAR1_TYPE */
 a_log_hs         OUT       CHAR,           /* CHAR1_TYPE */
 a_log_hs_details OUT       CHAR)           /* CHAR1_TYPE */
RETURN NUMBER;

FUNCTION GetWsAuthorisation                 /* INTERNAL */
(a_ws             IN        VARCHAR2,       /* VC20_TYPE */
 a_wt_version     IN  OUT   VARCHAR2,       /* VC20_TYPE */
 a_lc             OUT       VARCHAR2,       /* VC2_TYPE */
 a_lc_version     OUT       VARCHAR2,       /* VC20_TYPE */
 a_ss             OUT       VARCHAR2,       /* VC2_TYPE */
 a_allow_modify   OUT       CHAR,           /* CHAR1_TYPE */
 a_active         OUT       CHAR,           /* CHAR1_TYPE */
 a_log_hs         OUT       CHAR,           /* CHAR1_TYPE */
 a_log_hs_details OUT       CHAR)           /* CHAR1_TYPE */
RETURN NUMBER;

FUNCTION GetChAuthorisation              /* INTERNAL */
(a_ch             IN        VARCHAR2,       /* VC20_TYPE */
 a_cy_version     IN  OUT   VARCHAR2,       /* VC20_TYPE */
 a_lc             OUT       VARCHAR2,       /* VC2_TYPE */
 a_lc_version     OUT       VARCHAR2,       /* VC20_TYPE */
 a_ss             OUT       VARCHAR2,       /* VC2_TYPE */
 a_allow_modify   OUT       CHAR,           /* CHAR1_TYPE */
 a_active         OUT       CHAR,           /* CHAR1_TYPE */
 a_log_hs         OUT       CHAR,           /* CHAR1_TYPE */
 a_log_hs_details OUT       CHAR)           /* CHAR1_TYPE */
RETURN NUMBER;

FUNCTION GetSdAuthorisation              /* INTERNAL */
(a_sd             IN        VARCHAR2,       /* VC20_TYPE */
 a_pt_version     IN  OUT   VARCHAR2,       /* VC20_TYPE */
 a_lc             OUT       VARCHAR2,       /* VC2_TYPE */
 a_lc_version     OUT       VARCHAR2,       /* VC20_TYPE */
 a_ss             OUT       VARCHAR2,       /* VC2_TYPE */
 a_allow_modify   OUT       CHAR,           /* CHAR1_TYPE */
 a_active         OUT       CHAR,           /* CHAR1_TYPE */
 a_log_hs         OUT       CHAR,           /* CHAR1_TYPE */
 a_log_hs_details OUT       CHAR)           /* CHAR1_TYPE */
RETURN NUMBER;

FUNCTION GetScIcAuthorisation               /* INTERNAL */
(a_sc             IN        VARCHAR2,       /* VC20_TYPE */
 a_ic             IN        VARCHAR2,       /* VC20_TYPE */
 a_icnode         IN        NUMBER,         /* LONG_TYPE */
 a_ip_version     IN  OUT   VARCHAR2,       /* VC20_TYPE */
 a_lc             OUT       VARCHAR2,       /* VC2_TYPE */
 a_lc_version     OUT       VARCHAR2,       /* VC20_TYPE */
 a_ss             OUT       VARCHAR2,       /* VC2_TYPE */
 a_allow_modify   OUT       CHAR,           /* CHAR1_TYPE */
 a_active         OUT       CHAR,           /* CHAR1_TYPE */
 a_log_hs         OUT       CHAR,           /* CHAR1_TYPE */
 a_log_hs_details OUT       CHAR)           /* CHAR1_TYPE */
RETURN NUMBER;

FUNCTION GetRqIcAuthorisation               /* INTERNAL */
(a_rq             IN        VARCHAR2,       /* VC20_TYPE */
 a_ic             IN        VARCHAR2,       /* VC20_TYPE */
 a_icnode         IN        NUMBER,         /* LONG_TYPE */
 a_ip_version     IN  OUT   VARCHAR2,       /* VC20_TYPE */
 a_lc             OUT       VARCHAR2,       /* VC2_TYPE */
 a_lc_version     OUT       VARCHAR2,       /* VC20_TYPE */
 a_ss             OUT       VARCHAR2,       /* VC2_TYPE */
 a_allow_modify   OUT       CHAR,           /* CHAR1_TYPE */
 a_active         OUT       CHAR,           /* CHAR1_TYPE */
 a_log_hs         OUT       CHAR,           /* CHAR1_TYPE */
 a_log_hs_details OUT       CHAR)           /* CHAR1_TYPE */
RETURN NUMBER;

FUNCTION GetSdIcAuthorisation               /* INTERNAL */
(a_sd             IN        VARCHAR2,       /* VC20_TYPE */
 a_ic             IN        VARCHAR2,       /* VC20_TYPE */
 a_icnode         IN        NUMBER,         /* LONG_TYPE */
 a_ip_version     IN  OUT   VARCHAR2,       /* VC20_TYPE */
 a_lc             OUT       VARCHAR2,       /* VC2_TYPE */
 a_lc_version     OUT       VARCHAR2,       /* VC20_TYPE */
 a_ss             OUT       VARCHAR2,       /* VC2_TYPE */
 a_allow_modify   OUT       CHAR,           /* CHAR1_TYPE */
 a_active         OUT       CHAR,           /* CHAR1_TYPE */
 a_log_hs         OUT       CHAR,           /* CHAR1_TYPE */
 a_log_hs_details OUT       CHAR)           /* CHAR1_TYPE */
RETURN NUMBER;

FUNCTION GetScIiAuthorisation               /* INTERNAL */
(a_sc             IN        VARCHAR2,       /* VC20_TYPE */
 a_ic             IN        VARCHAR2,       /* VC20_TYPE */
 a_icnode         IN        NUMBER,         /* LONG_TYPE */
 a_ii             IN        VARCHAR2,       /* VC20_TYPE */
 a_iinode         IN        NUMBER,         /* LONG_TYPE */
 a_ie_version     IN  OUT   VARCHAR2,       /* VC20_TYPE */
 a_lc             OUT       VARCHAR2,       /* VC2_TYPE */
 a_lc_version     OUT       VARCHAR2,       /* VC20_TYPE */
 a_ss             OUT       VARCHAR2,       /* VC2_TYPE */
 a_allow_modify   OUT       CHAR,           /* CHAR1_TYPE */
 a_active         OUT       CHAR,           /* CHAR1_TYPE */
 a_log_hs         OUT       CHAR,           /* CHAR1_TYPE */
 a_log_hs_details OUT       CHAR)           /* CHAR1_TYPE */
RETURN NUMBER;

FUNCTION GetRqIiAuthorisation               /* INTERNAL */
(a_rq             IN        VARCHAR2,       /* VC20_TYPE */
 a_ic             IN        VARCHAR2,       /* VC20_TYPE */
 a_icnode         IN        NUMBER,         /* LONG_TYPE */
 a_ii             IN        VARCHAR2,       /* VC20_TYPE */
 a_iinode         IN        NUMBER,         /* LONG_TYPE */
 a_ie_version     IN  OUT   VARCHAR2,       /* VC20_TYPE */
 a_lc             OUT       VARCHAR2,       /* VC2_TYPE */
 a_lc_version     OUT       VARCHAR2,       /* VC20_TYPE */
 a_ss             OUT       VARCHAR2,       /* VC2_TYPE */
 a_allow_modify   OUT       CHAR,           /* CHAR1_TYPE */
 a_active         OUT       CHAR,           /* CHAR1_TYPE */
 a_log_hs         OUT       CHAR,           /* CHAR1_TYPE */
 a_log_hs_details OUT       CHAR)           /* CHAR1_TYPE */
RETURN NUMBER;

FUNCTION GetSdIiAuthorisation               /* INTERNAL */
(a_sd             IN        VARCHAR2,       /* VC20_TYPE */
 a_ic             IN        VARCHAR2,       /* VC20_TYPE */
 a_icnode         IN        NUMBER,         /* LONG_TYPE */
 a_ii             IN        VARCHAR2,       /* VC20_TYPE */
 a_iinode         IN        NUMBER,         /* LONG_TYPE */
 a_ie_version     IN  OUT   VARCHAR2,       /* VC20_TYPE */
 a_lc             OUT       VARCHAR2,       /* VC2_TYPE */
 a_lc_version     OUT       VARCHAR2,       /* VC20_TYPE */
 a_ss             OUT       VARCHAR2,       /* VC2_TYPE */
 a_allow_modify   OUT       CHAR,           /* CHAR1_TYPE */
 a_active         OUT       CHAR,           /* CHAR1_TYPE */
 a_log_hs         OUT       CHAR,           /* CHAR1_TYPE */
 a_log_hs_details OUT       CHAR)           /* CHAR1_TYPE */
RETURN NUMBER;

FUNCTION GetScPgAuthorisation               /* INTERNAL */
(a_sc             IN        VARCHAR2,       /* VC20_TYPE */
 a_pg             IN        VARCHAR2,       /* VC20_TYPE */
 a_pgnode         IN        NUMBER,         /* LONG_TYPE */
 a_pp_version     IN  OUT   VARCHAR2,       /* VC20_TYPE */
 a_lc             OUT       VARCHAR2,       /* VC2_TYPE */
 a_lc_version     OUT       VARCHAR2,       /* VC20_TYPE */
 a_ss             OUT       VARCHAR2,       /* VC2_TYPE */
 a_allow_modify   OUT       CHAR,           /* CHAR1_TYPE */
 a_active         OUT       CHAR,           /* CHAR1_TYPE */
 a_log_hs         OUT       CHAR,           /* CHAR1_TYPE */
 a_log_hs_details OUT       CHAR)           /* CHAR1_TYPE */
RETURN NUMBER;

FUNCTION GetScPaAuthorisation               /* INTERNAL */
(a_sc             IN        VARCHAR2,       /* VC20_TYPE */
 a_pg             IN        VARCHAR2,       /* VC20_TYPE */
 a_pgnode         IN        NUMBER,         /* LONG_TYPE */
 a_pa             IN        VARCHAR2,       /* VC20_TYPE */
 a_panode         IN        NUMBER,         /* LONG_TYPE */
 a_pr_version     IN  OUT   VARCHAR2,       /* VC20_TYPE */
 a_lc             OUT       VARCHAR2,       /* VC2_TYPE */
 a_lc_version     OUT       VARCHAR2,       /* VC20_TYPE */
 a_ss             OUT       VARCHAR2,       /* VC2_TYPE */
 a_allow_modify   OUT       CHAR,           /* CHAR1_TYPE */
 a_active         OUT       CHAR,           /* CHAR1_TYPE */
 a_log_hs         OUT       CHAR,           /* CHAR1_TYPE */
 a_log_hs_details OUT       CHAR)           /* CHAR1_TYPE */
RETURN NUMBER;

FUNCTION GetScMeAuthorisation               /* INTERNAL */
(a_sc             IN        VARCHAR2,       /* VC20_TYPE */
 a_pg             IN        VARCHAR2,       /* VC20_TYPE */
 a_pgnode         IN        NUMBER,         /* LONG_TYPE */
 a_pa             IN        VARCHAR2,       /* VC20_TYPE */
 a_panode         IN        NUMBER,         /* LONG_TYPE */
 a_me             IN        VARCHAR2,       /* VC20_TYPE */
 a_menode         IN        NUMBER,         /* LONG_TYPE */
 a_reanalysis     IN        NUMBER,         /* LONG_TYPE */
 a_mt_version     IN  OUT   VARCHAR2,       /* VC20_TYPE */
 a_lc             OUT       VARCHAR2,       /* VC2_TYPE */
 a_lc_version     OUT       VARCHAR2,       /* VC20_TYPE */
 a_ss             OUT       VARCHAR2,       /* VC2_TYPE */
 a_allow_modify   OUT       CHAR,           /* CHAR1_TYPE */
 a_active         OUT       CHAR,           /* CHAR1_TYPE */
 a_log_hs         OUT       CHAR,           /* CHAR1_TYPE */
 a_log_hs_details OUT       CHAR)           /* CHAR1_TYPE */
RETURN NUMBER;

FUNCTION DisableAllowModifyCheck            /* INTERNAL */
(a_flag          IN        CHAR)            /* CHAR1_TYPE */
RETURN NUMBER;

FUNCTION GetAllowModifyCheckMode            /* INTERNAL */
(a_flag          OUT       CHAR)            /* CHAR1_TYPE */
RETURN NUMBER;

FUNCTION GetARCheckMode                     /* INTERNAL */
(a_flag          OUT       CHAR)            /* CHAR1_TYPE */
RETURN NUMBER;

FUNCTION DisableARCheck                     /* INTERNAL */
(a_flag          IN        CHAR)            /* CHAR1_TYPE */
RETURN NUMBER;

FUNCTION EvalAssignmentFreq
(a_main_object_tp             IN VARCHAR2,     /* VC2_TYPE */
 a_main_object_id             IN VARCHAR2,     /* VC20_TYPE */
 a_main_object_version        IN VARCHAR2,     /* VC20_TYPE */
 a_object_tp                  IN VARCHAR2,     /* VC4_TYPE */
 a_object_id                  IN VARCHAR2,     /* VC20_TYPE */
 a_object_version             IN VARCHAR2,     /* VC20_TYPE */
 a_freq_tp                    IN CHAR,         /* CHAR1_TYPE */
 a_freq_val                   IN NUMBER,       /* NUM_TYPE */
 a_freq_unit                  IN VARCHAR2,     /* VC20_TYPE */
 a_invert_freq                IN CHAR,         /* CHAR1_TYPE */
 a_ref_date                   IN DATE,         /* DATE_TYPE */
 a_last_sched                 IN OUT DATE,     /* DATE_TYPE */
 a_last_cnt                   IN OUT NUMBER,   /* NUM_TYPE */
 a_last_val                   IN OUT VARCHAR2) /* VC40_TYPE */
RETURN BOOLEAN;

FUNCTION SQLCalculateDelay
(a_delay        IN NUMBER,     /* NUM_TYPE */
 a_delay_unit   IN VARCHAR2,   /* VC20_TYPE */
 a_ref_date     IN DATE)       /* DATE_TYPE */
RETURN DATE;

FUNCTION CalculateDelay
(a_delay        IN NUMBER,     /* NUM_TYPE */
 a_delay_unit   IN VARCHAR2,   /* VC20_TYPE */
 a_ref_date     IN DATE,       /* DATE_TYPE */
 a_delayed_till OUT DATE)      /* DATE_TYPE */
RETURN NUMBER;

FUNCTION CalculateDelay       /* INTERNAL */
(a_delay        IN NUMBER,
 a_delay_unit   IN VARCHAR2,
 a_ref_date     IN DATE,
 a_delayed_till OUT DATE,
 a_delay_value  OUT NUMBER)
RETURN NUMBER;

PROCEDURE UpdateAuthorisationBuffer        /* INTERNAL */
(a_object_tp          IN        VARCHAR2,  /* VC4_TYPE */
 a_object_id          IN        VARCHAR2,  /* VC255_TYPE */
 a_object_version     IN        VARCHAR2,  /* VC20_TYPE */
 a_new_ss             IN        VARCHAR2); /* VC2_TYPE */

PROCEDURE UpdateLcInAuthorisationBuffer    /* INTERNAL */
(a_object_tp              IN        VARCHAR2,  /* VC4_TYPE */
 a_object_id              IN        VARCHAR2,  /* VC255_TYPE */
 a_object_version         IN        VARCHAR2,  /* VC20_TYPE */
 a_new_object_lc          IN        VARCHAR2,  /* VC2_TYPE */
 a_new_object_lc_version  IN        VARCHAR2); /* VC20_TYPE */

FUNCTION SQLGetScMeAllowModify              /* INTERNAL */
(a_sc             IN        VARCHAR2,       /* VC20_TYPE */
 a_pg             IN        VARCHAR2,       /* VC20_TYPE */
 a_pgnode         IN        NUMBER,         /* LONG_TYPE */
 a_pa             IN        VARCHAR2,       /* VC20_TYPE */
 a_panode         IN        NUMBER,         /* LONG_TYPE */
 a_me             IN        VARCHAR2,       /* VC20_TYPE */
 a_menode         IN        NUMBER,         /* LONG_TYPE */
 a_reanalysis     IN        NUMBER)         /* LONG_TYPE */
RETURN CHAR;

FUNCTION SQLGetScPaAllowModify              /* INTERNAL */
(a_sc             IN        VARCHAR2,       /* VC20_TYPE */
 a_pg             IN        VARCHAR2,       /* VC20_TYPE */
 a_pgnode         IN        NUMBER,         /* LONG_TYPE */
 a_pa             IN        VARCHAR2,       /* VC20_TYPE */
 a_panode         IN        NUMBER)         /* LONG_TYPE */
RETURN CHAR;

FUNCTION SQLGetChAllowModify                /* INTERNAL */
(a_ch             IN        VARCHAR2)       /* VC20_TYPE */
RETURN CHAR;

FUNCTION SQLGetObjectAllowModify            /* INTERNAL */
(a_object_tp           IN        VARCHAR2,  /* VC4_TYPE */
 a_object_id           IN        VARCHAR2,  /* VC20_TYPE */
 a_object_version      IN        VARCHAR2)  /* VC20_TYPE */
RETURN CHAR;
PROCEDURE AddOracleCBOHint
(a_sql_string          IN OUT    VARCHAR2) ; /* VC2000_TYPE */

FUNCTION InitRtStBuffer
(a_rt                      IN         VARCHAR2,                  /* VC20_TYPE */
 a_rt_version              IN         VARCHAR2)
RETURN NUMBER ;

FUNCTION InitStPpBuffer
(a_st                      IN         VARCHAR2,                  /* VC20_TYPE */
 a_st_version              IN         VARCHAR2)
RETURN NUMBER ;

FUNCTION InitStPrFreqBuffer
(a_st                      IN         VARCHAR2,                  /* VC20_TYPE */
 a_st_version              IN         VARCHAR2,                  /* VC20_TYPE */
 a_pp                      IN         VARCHAR2,
 a_pp_version              IN         VARCHAR2,
 a_pp_key1                 IN         VARCHAR2,
 a_pp_key2                 IN         VARCHAR2,
 a_pp_key3                 IN         VARCHAR2,
 a_pp_key4                 IN         VARCHAR2,
 a_pp_key5                 IN         VARCHAR2,
 a_pr                      IN         VARCHAR2,                  /* VC20_TYPE */
 a_pr_version              IN         VARCHAR2)
RETURN NUMBER ;

FUNCTION InitStPrPpInPpFreqBuffer
(a_st                      IN         VARCHAR2,                  /* VC20_TYPE */
 a_st_version              IN         VARCHAR2,                  /* VC20_TYPE */
 a_pp                      IN         VARCHAR2,
 a_pp_version              IN         VARCHAR2,
 a_pp_key1                 IN         VARCHAR2,
 a_pp_key2                 IN         VARCHAR2,
 a_pp_key3                 IN         VARCHAR2,
 a_pp_key4                 IN         VARCHAR2,
 a_pp_key5                 IN         VARCHAR2,
 a_pr                      IN         VARCHAR2,                  /* VC20_TYPE */
 a_pr_version              IN         VARCHAR2)
RETURN NUMBER ;

FUNCTION InitStMtFreqBuffer
(a_st                      IN         VARCHAR2,                  /* VC20_TYPE */
 a_st_version              IN         VARCHAR2,                  /* VC20_TYPE */
 a_pr                      IN         VARCHAR2,                  /* VC20_TYPE */
 a_pr_version              IN         VARCHAR2,                  /* VC20_TYPE */
 a_mt                      IN         VARCHAR2,
 a_mt_version              IN         VARCHAR2)
RETURN NUMBER ;

FUNCTION InitPpPrBuffer
(a_pp                      IN         VARCHAR2,
 a_pp_version               IN         VARCHAR2,
 a_pp_key1                  IN         VARCHAR2,
 a_pp_key2                  IN         VARCHAR2,
 a_pp_key3                  IN         VARCHAR2,
 a_pp_key4                  IN         VARCHAR2,
 a_pp_key5                  IN         VARCHAR2)
RETURN NUMBER ;

FUNCTION InitPpInPpBuffer
(a_pp                      IN         VARCHAR2,
 a_pp_version               IN         VARCHAR2,
 a_pp_key1                  IN         VARCHAR2,
 a_pp_key2                  IN         VARCHAR2,
 a_pp_key3                  IN         VARCHAR2,
 a_pp_key4                  IN         VARCHAR2,
 a_pp_key5                  IN         VARCHAR2)
RETURN NUMBER ;

FUNCTION InitPrMtBuffer
(a_pr         IN VARCHAR2,
 a_version    IN VARCHAR2)
RETURN NUMBER ;

FUNCTION InitStIpBuffer
(a_st         IN VARCHAR2,
 a_version    IN VARCHAR2)
RETURN NUMBER ;

FUNCTION EvalFreqBuffer
RETURN NUMBER ;

END unapiaut;
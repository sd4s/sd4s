create or replace PACKAGE        UNFREQ AS
--------------------------------------------------------------------------------
--  PROJECT : Vredestein Enschede
-------------------------------------------------------------------------------
--  PACKAGE : UNFREQ
-- ABSTRACT :
--   WRITER : Rody Sparenberg
--     DATE : 16/03/2007
--   TARGET : Oracle 10.2.0
--  VERSION : av1.3
--------------------------------------------------------------------------------
--  REMARKS : The general rules for cf_type in utcf can be found
--				  in the document: customizing the system
-- 			  Minimal information can also be found in the header
--				  of the unaction package
--
--
/* freq_unit specifies which function should be called within  */
/* this package. The parameters will be the same for all these */
/* functions                                                   */
/* The parameters are different for each level                 */
--
--------------------------------------------------------------------------------
--  CHANGES :
--
--  When      | Who       | What
--============|===========|=====================================================
-- 16/03/2007 | RS        | Created
-- 18/12/2007 | RS        | Added UAbased
-- 06/08/2008 | RS        | Added OncePerSampleTrials
-- 01/10/2008 | RS        | Added UAbasedSc
--                        | Rename UAbased into UAbasedSt
--                        | Added UAbased
-- 26/11/2008 | RS        | Added ScPgInterspec
--                        | Added ScPaInterspec
-- 08/04/2008 | RS        | Changed ScPaInterspec
-- 13/02/2013 | RS        | Added WsCreate
--                        | Added WsCreateInSubProgram
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- functions- and/or procedures-declarations
--------------------------------------------------------------------------------
FUNCTION GetVersion
RETURN VARCHAR2;

/*  rtst level */
FUNCTION ScMax3TimesByMonth                     /* INTERNAL */
(a_rq                         IN VARCHAR2,      /* VC20_TYPE */
 a_st                         IN VARCHAR2,      /* VC20_TYPE */
 a_st_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_freq_val                   IN NUMBER,        /* NUM_TYPE */
 a_invert_freq                IN CHAR,          /* CHAR1_TYPE */
 a_ref_date                   IN DATE,          /* DATE_TYPE */
 a_last_sched                 IN OUT DATE,      /* DATE_TYPE */
 a_last_cnt                   IN OUT NUMBER,    /* NUM_TYPE */
 a_last_val                   IN OUT VARCHAR2)  /* VC40_TYPE */
RETURN NUMBER;

FUNCTION ScOnlyOnWorkDay                        /* INTERNAL */
(a_rq                         IN VARCHAR2,      /* VC20_TYPE */
 a_st                         IN VARCHAR2,      /* VC20_TYPE */
 a_st_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_freq_val                   IN NUMBER,        /* NUM_TYPE */
 a_invert_freq                IN CHAR,          /* CHAR1_TYPE */
 a_ref_date                   IN DATE,          /* DATE_TYPE */
 a_last_sched                 IN OUT DATE,      /* DATE_TYPE */
 a_last_cnt                   IN OUT NUMBER,    /* NUM_TYPE */
 a_last_val                   IN OUT VARCHAR2)  /* VC40_TYPE */
RETURN NUMBER;

--

FUNCTION ScOnlyOnFriday                         /* INTERNAL */
(a_rq                         IN VARCHAR2,      /* VC20_TYPE */
 a_st                         IN VARCHAR2,      /* VC20_TYPE */
 a_st_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_freq_val                   IN NUMBER,        /* NUM_TYPE */
 a_invert_freq                IN CHAR,          /* CHAR1_TYPE */
 a_ref_date                   IN DATE,          /* DATE_TYPE */
 a_last_sched                 IN OUT DATE,      /* DATE_TYPE */
 a_last_cnt                   IN OUT NUMBER,    /* NUM_TYPE */
 a_last_val                   IN OUT VARCHAR2)  /* VC40_TYPE */
RETURN NUMBER;

/* stip */
FUNCTION ScIcSupplier_Grade                     /* INTERNAL */
(a_sc                         IN VARCHAR2,      /* VC20_TYPE */
 a_st                         IN VARCHAR2,      /* VC20_TYPE */
 a_st_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_ip                         IN VARCHAR2,      /* VC20_TYPE */
 a_ip_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_freq_val                   IN NUMBER,        /* NUM_TYPE */
 a_invert_freq                IN CHAR,          /* CHAR1_TYPE */
 a_ref_date                   IN DATE,          /* DATE_TYPE */
 a_last_sched                 IN OUT DATE,      /* DATE_TYPE */
 a_last_cnt                   IN OUT NUMBER,    /* NUM_TYPE */
 a_last_val                   IN OUT VARCHAR2)  /* VC40_TYPE */
RETURN NUMBER;

/* rtip */
FUNCTION RqIcSupplier_Grade                     /* INTERNAL */
(a_rq                         IN VARCHAR2,      /* VC20_TYPE */
 a_rt                         IN VARCHAR2,      /* VC20_TYPE */
 a_rt_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_ip                         IN VARCHAR2,      /* VC20_TYPE */
 a_ip_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_freq_val                   IN NUMBER,        /* NUM_TYPE */
 a_invert_freq                IN CHAR,          /* CHAR1_TYPE */
 a_ref_date                   IN DATE,          /* DATE_TYPE */
 a_last_sched                 IN OUT DATE,      /* DATE_TYPE */
 a_last_cnt                   IN OUT NUMBER,    /* NUM_TYPE */
 a_last_val                   IN OUT VARCHAR2)  /* VC40_TYPE */
RETURN NUMBER;

/* stpp level */
FUNCTION ScPgMax3TimesByMonth                     /* INTERNAL */
(a_sc_or_rq                   IN VARCHAR2,      /* VC20_TYPE */
 a_st_or_rt                   IN VARCHAR2,      /* VC20_TYPE */
 a_st_or_rt_version           IN VARCHAR2,      /* VC20_TYPE */
 a_pp                         IN VARCHAR2,      /* VC20_TYPE */
 a_pp_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key1                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key2                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key3                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key4                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key5                    IN VARCHAR2,      /* VC20_TYPE */
 a_freq_val                   IN NUMBER,        /* NUM_TYPE */
 a_invert_freq                IN CHAR,          /* CHAR1_TYPE */
 a_ref_date                   IN DATE,          /* DATE_TYPE */
 a_last_sched                 IN OUT DATE,      /* DATE_TYPE */
 a_last_cnt                   IN OUT NUMBER,    /* NUM_TYPE */
 a_last_val                   IN OUT VARCHAR2)  /* VC40_TYPE */
RETURN NUMBER;

FUNCTION ScPgOnlyOnWorkDay                        /* INTERNAL */
(a_sc_or_rq                   IN VARCHAR2,      /* VC20_TYPE */
 a_st_or_rt                   IN VARCHAR2,      /* VC20_TYPE */
 a_st_or_rt_version           IN VARCHAR2,      /* VC20_TYPE */
 a_pp                         IN VARCHAR2,      /* VC20_TYPE */
 a_pp_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key1                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key2                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key3                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key4                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key5                    IN VARCHAR2,      /* VC20_TYPE */
 a_freq_val                   IN NUMBER,        /* NUM_TYPE */
 a_invert_freq                IN CHAR,          /* CHAR1_TYPE */
 a_ref_date                   IN DATE,          /* DATE_TYPE */
 a_last_sched                 IN OUT DATE,      /* DATE_TYPE */
 a_last_cnt                   IN OUT NUMBER,    /* NUM_TYPE */
 a_last_val                   IN OUT VARCHAR2)  /* VC40_TYPE */
RETURN NUMBER;

FUNCTION ScPgOnlyOnFriday                         /* INTERNAL */
(a_sc_or_rq                   IN VARCHAR2,      /* VC20_TYPE */
 a_st_or_rt                   IN VARCHAR2,      /* VC20_TYPE */
 a_st_or_rt_version           IN VARCHAR2,      /* VC20_TYPE */
 a_pp                         IN VARCHAR2,      /* VC20_TYPE */
 a_pp_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key1                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key2                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key3                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key4                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key5                    IN VARCHAR2,      /* VC20_TYPE */
 a_freq_val                   IN NUMBER,        /* NUM_TYPE */
 a_invert_freq                IN CHAR,          /* CHAR1_TYPE */
 a_ref_date                   IN DATE,          /* DATE_TYPE */
 a_last_sched                 IN OUT DATE,      /* DATE_TYPE */
 a_last_cnt                   IN OUT NUMBER,    /* NUM_TYPE */
 a_last_val                   IN OUT VARCHAR2)  /* VC40_TYPE */
RETURN NUMBER;

FUNCTION ScPgOnlyWhenRqIsOdd                    /* INTERNAL */
(a_sc_or_rq                   IN VARCHAR2,      /* VC20_TYPE */
 a_st_or_rt                   IN VARCHAR2,      /* VC20_TYPE */
 a_st_or_rt_version           IN VARCHAR2,      /* VC20_TYPE */
 a_pp                         IN VARCHAR2,      /* VC20_TYPE */
 a_pp_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key1                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key2                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key3                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key4                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key5                    IN VARCHAR2,      /* VC20_TYPE */
 a_freq_val                   IN NUMBER,        /* NUM_TYPE */
 a_invert_freq                IN CHAR,          /* CHAR1_TYPE */
 a_ref_date                   IN DATE,          /* DATE_TYPE */
 a_last_sched                 IN OUT DATE,      /* DATE_TYPE */
 a_last_cnt                   IN OUT NUMBER,    /* NUM_TYPE */
 a_last_val                   IN OUT VARCHAR2)  /* VC40_TYPE */
RETURN NUMBER;

/* rtst - rtip level */
FUNCTION RqScMax3TimesByMonth                   /* INTERNAL */
(a_sc_or_rq                   IN VARCHAR2,      /* VC20_TYPE */
 a_st_or_rt                   IN VARCHAR2,      /* VC20_TYPE */
 a_st_or_rt_version           IN VARCHAR2,      /* VC20_TYPE */
 a_ip_or_st                   IN VARCHAR2,      /* VC20_TYPE */
 a_ip_or_st_version           IN VARCHAR2,      /* VC20_TYPE */
 a_freq_val                   IN NUMBER,        /* NUM_TYPE */
 a_invert_freq                IN CHAR,          /* CHAR1_TYPE */
 a_ref_date                   IN DATE,          /* DATE_TYPE */
 a_last_sched                 IN OUT DATE,      /* DATE_TYPE */
 a_last_cnt                   IN OUT NUMBER,    /* NUM_TYPE */
 a_last_val                   IN OUT VARCHAR2)  /* VC40_TYPE */
RETURN NUMBER;

FUNCTION RqScOnlyOnWorkDay                      /* INTERNAL */
(a_sc_or_rq                   IN VARCHAR2,      /* VC20_TYPE */
 a_st_or_rt                   IN VARCHAR2,      /* VC20_TYPE */
 a_st_or_rt_version           IN VARCHAR2,      /* VC20_TYPE */
 a_ip_or_st                   IN VARCHAR2,      /* VC20_TYPE */
 a_ip_or_st_version           IN VARCHAR2,      /* VC20_TYPE */
 a_freq_val                   IN NUMBER,        /* NUM_TYPE */
 a_invert_freq                IN CHAR,          /* CHAR1_TYPE */
 a_ref_date                   IN DATE,          /* DATE_TYPE */
 a_last_sched                 IN OUT DATE,      /* DATE_TYPE */
 a_last_cnt                   IN OUT NUMBER,    /* NUM_TYPE */
 a_last_val                   IN OUT VARCHAR2)  /* VC40_TYPE */
RETURN NUMBER;

FUNCTION RqScOnlyOnFriday                       /* INTERNAL */
(a_sc_or_rq                   IN VARCHAR2,      /* VC20_TYPE */
 a_st_or_rt                   IN VARCHAR2,      /* VC20_TYPE */
 a_st_or_rt_version           IN VARCHAR2,      /* VC20_TYPE */
 a_ip_or_st                   IN VARCHAR2,      /* VC20_TYPE */
 a_ip_or_st_version           IN VARCHAR2,      /* VC20_TYPE */
 a_freq_val                   IN NUMBER,        /* NUM_TYPE */
 a_invert_freq                IN CHAR,          /* CHAR1_TYPE */
 a_ref_date                   IN DATE,          /* DATE_TYPE */
 a_last_sched                 IN OUT DATE,      /* DATE_TYPE */
 a_last_cnt                   IN OUT NUMBER,    /* NUM_TYPE */
 a_last_val                   IN OUT VARCHAR2)  /* VC40_TYPE */
RETURN NUMBER;

/* rtpp level */
FUNCTION RqPgMax3TimesByMonth                   /* INTERNAL */
(a_sc_or_rq                   IN VARCHAR2,      /* VC20_TYPE */
 a_st_or_rt                   IN VARCHAR2,      /* VC20_TYPE */
 a_st_or_rt_version           IN VARCHAR2,      /* VC20_TYPE */
 a_pp                         IN VARCHAR2,      /* VC20_TYPE */
 a_pp_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key1                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key2                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key3                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key4                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key5                    IN VARCHAR2,      /* VC20_TYPE */
 a_freq_val                   IN NUMBER,        /* NUM_TYPE */
 a_invert_freq                IN CHAR,          /* CHAR1_TYPE */
 a_ref_date                   IN DATE,          /* DATE_TYPE */
 a_last_sched                 IN OUT DATE,      /* DATE_TYPE */
 a_last_cnt                   IN OUT NUMBER,    /* NUM_TYPE */
 a_last_val                   IN OUT VARCHAR2)  /* VC40_TYPE */
RETURN NUMBER;

FUNCTION RqPgOnlyOnWorkDay                      /* INTERNAL */
(a_sc_or_rq                   IN VARCHAR2,      /* VC20_TYPE */
 a_st_or_rt                   IN VARCHAR2,      /* VC20_TYPE */
 a_st_or_rt_version           IN VARCHAR2,      /* VC20_TYPE */
 a_pp                         IN VARCHAR2,      /* VC20_TYPE */
 a_pp_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key1                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key2                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key3                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key4                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key5                    IN VARCHAR2,      /* VC20_TYPE */
 a_freq_val                   IN NUMBER,        /* NUM_TYPE */
 a_invert_freq                IN CHAR,          /* CHAR1_TYPE */
 a_ref_date                   IN DATE,          /* DATE_TYPE */
 a_last_sched                 IN OUT DATE,      /* DATE_TYPE */
 a_last_cnt                   IN OUT NUMBER,    /* NUM_TYPE */
 a_last_val                   IN OUT VARCHAR2)  /* VC40_TYPE */
RETURN NUMBER;

FUNCTION RqPgOnlyOnFriday                       /* INTERNAL */
(a_sc_or_rq                   IN VARCHAR2,      /* VC20_TYPE */
 a_st_or_rt                   IN VARCHAR2,      /* VC20_TYPE */
 a_st_or_rt_version           IN VARCHAR2,      /* VC20_TYPE */
 a_pp                         IN VARCHAR2,      /* VC20_TYPE */
 a_pp_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key1                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key2                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key3                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key4                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key5                    IN VARCHAR2,      /* VC20_TYPE */
 a_freq_val                   IN NUMBER,        /* NUM_TYPE */
 a_invert_freq                IN CHAR,          /* CHAR1_TYPE */
 a_ref_date                   IN DATE,          /* DATE_TYPE */
 a_last_sched                 IN OUT DATE,      /* DATE_TYPE */
 a_last_cnt                   IN OUT NUMBER,    /* NUM_TYPE */
 a_last_val                   IN OUT VARCHAR2)  /* VC40_TYPE */
RETURN NUMBER;

/* pppr level */
FUNCTION ScPaMax3TimesByMonth                     /* INTERNAL */
(a_sc                         IN VARCHAR2,      /* VC20_TYPE */
 a_st                         IN VARCHAR2,      /* VC20_TYPE */
 a_st_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_pp                         IN VARCHAR2,      /* VC20_TYPE */
 a_pp_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key1                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key2                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key3                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key4                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key5                    IN VARCHAR2,      /* VC20_TYPE */
 a_pr                         IN VARCHAR2,      /* VC20_TYPE */
 a_pr_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_freq_val                   IN NUMBER,        /* NUM_TYPE */
 a_invert_freq                IN CHAR,          /* CHAR1_TYPE */
 a_ref_date                   IN DATE,          /* DATE_TYPE */
 a_last_sched                 IN OUT DATE,      /* DATE_TYPE */
 a_last_cnt                   IN OUT NUMBER,    /* NUM_TYPE */
 a_last_val                   IN OUT VARCHAR2)  /* VC40_TYPE */
RETURN NUMBER;

FUNCTION ScPaOnlyOnWorkDay                        /* INTERNAL */
(a_sc                         IN VARCHAR2,      /* VC20_TYPE */
 a_st                         IN VARCHAR2,      /* VC20_TYPE */
 a_st_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_pp                         IN VARCHAR2,      /* VC20_TYPE */
 a_pp_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key1                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key2                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key3                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key4                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key5                    IN VARCHAR2,      /* VC20_TYPE */
 a_pr                         IN VARCHAR2,      /* VC20_TYPE */
 a_pr_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_freq_val                   IN NUMBER,        /* NUM_TYPE */
 a_invert_freq                IN CHAR,          /* CHAR1_TYPE */
 a_ref_date                   IN DATE,          /* DATE_TYPE */
 a_last_sched                 IN OUT DATE,      /* DATE_TYPE */
 a_last_cnt                   IN OUT NUMBER,    /* NUM_TYPE */
 a_last_val                   IN OUT VARCHAR2)  /* VC40_TYPE */
RETURN NUMBER;

FUNCTION ScPaOnlyOnFriday                         /* INTERNAL */
(a_sc                         IN VARCHAR2,      /* VC20_TYPE */
 a_st                         IN VARCHAR2,      /* VC20_TYPE */
 a_st_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_pp                         IN VARCHAR2,      /* VC20_TYPE */
 a_pp_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key1                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key2                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key3                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key4                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key5                    IN VARCHAR2,      /* VC20_TYPE */
 a_pr                         IN VARCHAR2,      /* VC20_TYPE */
 a_pr_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_freq_val                   IN NUMBER,        /* NUM_TYPE */
 a_invert_freq                IN CHAR,          /* CHAR1_TYPE */
 a_ref_date                   IN DATE,          /* DATE_TYPE */
 a_last_sched                 IN OUT DATE,      /* DATE_TYPE */
 a_last_cnt                   IN OUT NUMBER,    /* NUM_TYPE */
 a_last_val                   IN OUT VARCHAR2)  /* VC40_TYPE */
RETURN NUMBER;

FUNCTION ScPaNotYetInAnyPg                        /* INTERNAL */
(a_sc                         IN VARCHAR2,      /* VC20_TYPE */
 a_st                         IN VARCHAR2,      /* VC20_TYPE */
 a_st_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_pp                         IN VARCHAR2,      /* VC20_TYPE */
 a_pp_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key1                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key2                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key3                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key4                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key5                    IN VARCHAR2,      /* VC20_TYPE */
 a_pr                         IN VARCHAR2,      /* VC20_TYPE */
 a_pr_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_freq_val                   IN NUMBER,        /* NUM_TYPE */
 a_invert_freq                IN CHAR,          /* CHAR1_TYPE */
 a_ref_date                   IN DATE,          /* DATE_TYPE */
 a_last_sched                 IN OUT DATE,      /* DATE_TYPE */
 a_last_cnt                   IN OUT NUMBER,    /* NUM_TYPE */
 a_last_val                   IN OUT VARCHAR2)  /* VC40_TYPE */
RETURN NUMBER;

FUNCTION ScPaNotYetInSamePg                       /* INTERNAL */
(a_sc                         IN VARCHAR2,      /* VC20_TYPE */
 a_st                         IN VARCHAR2,      /* VC20_TYPE */
 a_st_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_pp                         IN VARCHAR2,      /* VC20_TYPE */
 a_pp_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key1                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key2                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key3                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key4                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key5                    IN VARCHAR2,      /* VC20_TYPE */
 a_pr                         IN VARCHAR2,      /* VC20_TYPE */
 a_pr_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_freq_val                   IN NUMBER,        /* NUM_TYPE */
 a_invert_freq                IN CHAR,          /* CHAR1_TYPE */
 a_ref_date                   IN DATE,          /* DATE_TYPE */
 a_last_sched                 IN OUT DATE,      /* DATE_TYPE */
 a_last_cnt                   IN OUT NUMBER,    /* NUM_TYPE */
 a_last_val                   IN OUT VARCHAR2)  /* VC40_TYPE */
RETURN NUMBER;

FUNCTION ScPaOnlyWhenSdIsOdd                    /* INTERNAL */
(a_sc                         IN VARCHAR2,      /* VC20_TYPE */
 a_st                         IN VARCHAR2,      /* VC20_TYPE */
 a_st_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_pp                         IN VARCHAR2,      /* VC20_TYPE */
 a_pp_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key1                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key2                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key3                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key4                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key5                    IN VARCHAR2,      /* VC20_TYPE */
 a_pr                         IN VARCHAR2,      /* VC20_TYPE */
 a_pr_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_freq_val                   IN NUMBER,        /* NUM_TYPE */
 a_invert_freq                IN CHAR,          /* CHAR1_TYPE */
 a_ref_date                   IN DATE,          /* DATE_TYPE */
 a_last_sched                 IN OUT DATE,      /* DATE_TYPE */
 a_last_cnt                   IN OUT NUMBER,    /* NUM_TYPE */
 a_last_val                   IN OUT VARCHAR2)  /* VC40_TYPE */
RETURN NUMBER;

/* prmt level */
FUNCTION ScMeMax3TimesByMonth                     /* INTERNAL */
(a_sc                         IN VARCHAR2,      /* VC20_TYPE */
 a_st                         IN VARCHAR2,      /* VC20_TYPE */
 a_st_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_pp                         IN VARCHAR2,      /* VC20_TYPE */
 a_pp_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key1                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key2                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key3                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key4                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key5                    IN VARCHAR2,      /* VC20_TYPE */
 a_pr                         IN VARCHAR2,      /* VC20_TYPE */
 a_pr_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_mt                         IN VARCHAR2,      /* VC20_TYPE */
 a_mt_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_freq_val                   IN NUMBER,        /* NUM_TYPE */
 a_invert_freq                IN CHAR,          /* CHAR1_TYPE */
 a_ref_date                   IN DATE,          /* DATE_TYPE */
 a_last_sched                 IN OUT DATE,      /* DATE_TYPE */
 a_last_cnt                   IN OUT NUMBER,    /* NUM_TYPE */
 a_last_val                   IN OUT VARCHAR2)  /* VC40_TYPE */
RETURN NUMBER;

FUNCTION ScMeOnlyOnWorkDay                        /* INTERNAL */
(a_sc                         IN VARCHAR2,      /* VC20_TYPE */
 a_st                         IN VARCHAR2,      /* VC20_TYPE */
 a_st_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_pp                         IN VARCHAR2,      /* VC20_TYPE */
 a_pp_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key1                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key2                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key3                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key4                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key5                    IN VARCHAR2,      /* VC20_TYPE */
 a_pr                         IN VARCHAR2,      /* VC20_TYPE */
 a_pr_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_mt                         IN VARCHAR2,      /* VC20_TYPE */
 a_mt_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_freq_val                   IN NUMBER,        /* NUM_TYPE */
 a_invert_freq                IN CHAR,          /* CHAR1_TYPE */
 a_ref_date                   IN DATE,          /* DATE_TYPE */
 a_last_sched                 IN OUT DATE,      /* DATE_TYPE */
 a_last_cnt                   IN OUT NUMBER,    /* NUM_TYPE */
 a_last_val                   IN OUT VARCHAR2)  /* VC40_TYPE */
RETURN NUMBER;

FUNCTION ScMeOnlyOnFriday                         /* INTERNAL */
(a_sc                         IN VARCHAR2,      /* VC20_TYPE */
 a_st                         IN VARCHAR2,      /* VC20_TYPE */
 a_st_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_pp                         IN VARCHAR2,      /* VC20_TYPE */
 a_pp_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key1                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key2                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key3                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key4                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key5                    IN VARCHAR2,      /* VC20_TYPE */
 a_pr                         IN VARCHAR2,      /* VC20_TYPE */
 a_pr_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_mt                         IN VARCHAR2,      /* VC20_TYPE */
 a_mt_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_freq_val                   IN NUMBER,        /* NUM_TYPE */
 a_invert_freq                IN CHAR,          /* CHAR1_TYPE */
 a_ref_date                   IN DATE,          /* DATE_TYPE */
 a_last_sched                 IN OUT DATE,      /* DATE_TYPE */
 a_last_cnt                   IN OUT NUMBER,    /* NUM_TYPE */
 a_last_val                   IN OUT VARCHAR2)  /* VC40_TYPE */
RETURN NUMBER;

FUNCTION ScMeNotYetInAnyPg                        /* INTERNAL */
(a_sc                         IN VARCHAR2,      /* VC20_TYPE */
 a_st                         IN VARCHAR2,      /* VC20_TYPE */
 a_st_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_pp                         IN VARCHAR2,      /* VC20_TYPE */
 a_pp_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key1                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key2                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key3                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key4                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key5                    IN VARCHAR2,      /* VC20_TYPE */
 a_pr                         IN VARCHAR2,      /* VC20_TYPE */
 a_pr_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_mt                         IN VARCHAR2,      /* VC20_TYPE */
 a_mt_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_freq_val                   IN NUMBER,        /* NUM_TYPE */
 a_invert_freq                IN CHAR,          /* CHAR1_TYPE */
 a_ref_date                   IN DATE,          /* DATE_TYPE */
 a_last_sched                 IN OUT DATE,      /* DATE_TYPE */
 a_last_cnt                   IN OUT NUMBER,    /* NUM_TYPE */
 a_last_val                   IN OUT VARCHAR2)  /* VC40_TYPE */
RETURN NUMBER;

FUNCTION ScMeNotYetInSamePg                       /* INTERNAL */
(a_sc                         IN VARCHAR2,      /* VC20_TYPE */
 a_st                         IN VARCHAR2,      /* VC20_TYPE */
 a_st_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_pp                         IN VARCHAR2,      /* VC20_TYPE */
 a_pp_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key1                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key2                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key3                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key4                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key5                    IN VARCHAR2,      /* VC20_TYPE */
 a_pr                         IN VARCHAR2,      /* VC20_TYPE */
 a_pr_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_mt                         IN VARCHAR2,      /* VC20_TYPE */
 a_mt_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_freq_val                   IN NUMBER,        /* NUM_TYPE */
 a_invert_freq                IN CHAR,          /* CHAR1_TYPE */
 a_ref_date                   IN DATE,          /* DATE_TYPE */
 a_last_sched                 IN OUT DATE,      /* DATE_TYPE */
 a_last_cnt                   IN OUT NUMBER,    /* NUM_TYPE */
 a_last_val                   IN OUT VARCHAR2)  /* VC40_TYPE */
RETURN NUMBER;

FUNCTION ScMeOnlyWhenRqIsOdd                    /* INTERNAL */
(a_sc                         IN VARCHAR2,      /* VC20_TYPE */
 a_st                         IN VARCHAR2,      /* VC20_TYPE */
 a_st_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_pp                         IN VARCHAR2,      /* VC20_TYPE */
 a_pp_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key1                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key2                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key3                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key4                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key5                    IN VARCHAR2,      /* VC20_TYPE */
 a_pr                         IN VARCHAR2,      /* VC20_TYPE */
 a_pr_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_mt                         IN VARCHAR2,      /* VC20_TYPE */
 a_mt_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_freq_val                   IN NUMBER,        /* NUM_TYPE */
 a_invert_freq                IN CHAR,          /* CHAR1_TYPE */
 a_ref_date                   IN DATE,          /* DATE_TYPE */
 a_last_sched                 IN OUT DATE,      /* DATE_TYPE */
 a_last_cnt                   IN OUT NUMBER,    /* NUM_TYPE */
 a_last_val                   IN OUT VARCHAR2)  /* VC40_TYPE */
RETURN NUMBER;

FUNCTION UAbased                                /* INTERNAL */
(a_sc                         IN VARCHAR2,      /* VC20_TYPE */
 a_st                         IN VARCHAR2,      /* VC20_TYPE */
 a_st_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_pp                         IN VARCHAR2,      /* VC20_TYPE */
 a_pp_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key1                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key2                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key3                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key4                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key5                    IN VARCHAR2,      /* VC20_TYPE */
 a_pr                         IN VARCHAR2,      /* VC20_TYPE */
 a_pr_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_mt                         IN VARCHAR2,      /* VC20_TYPE */
 a_mt_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_freq_val                   IN NUMBER,        /* NUM_TYPE */
 a_invert_freq                IN CHAR,          /* CHAR1_TYPE */
 a_ref_date                   IN DATE,          /* DATE_TYPE */
 a_last_sched                 IN OUT DATE,      /* DATE_TYPE */
 a_last_cnt                   IN OUT NUMBER,    /* NUM_TYPE */
 a_last_val                   IN OUT VARCHAR2)  /* VC40_TYPE */
RETURN NUMBER;

FUNCTION UAbasedSt                                /* INTERNAL */
(a_sc                         IN VARCHAR2,      /* VC20_TYPE */
 a_st                         IN VARCHAR2,      /* VC20_TYPE */
 a_st_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_pp                         IN VARCHAR2,      /* VC20_TYPE */
 a_pp_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key1                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key2                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key3                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key4                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key5                    IN VARCHAR2,      /* VC20_TYPE */
 a_pr                         IN VARCHAR2,      /* VC20_TYPE */
 a_pr_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_mt                         IN VARCHAR2,      /* VC20_TYPE */
 a_mt_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_freq_val                   IN NUMBER,        /* NUM_TYPE */
 a_invert_freq                IN CHAR,          /* CHAR1_TYPE */
 a_ref_date                   IN DATE,          /* DATE_TYPE */
 a_last_sched                 IN OUT DATE,      /* DATE_TYPE */
 a_last_cnt                   IN OUT NUMBER,    /* NUM_TYPE */
 a_last_val                   IN OUT VARCHAR2)  /* VC40_TYPE */
RETURN NUMBER;

FUNCTION UAbasedSc                              /* INTERNAL */
(a_sc                         IN VARCHAR2,      /* VC20_TYPE */
 a_st                         IN VARCHAR2,      /* VC20_TYPE */
 a_st_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_pp                         IN VARCHAR2,      /* VC20_TYPE */
 a_pp_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key1                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key2                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key3                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key4                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key5                    IN VARCHAR2,      /* VC20_TYPE */
 a_pr                         IN VARCHAR2,      /* VC20_TYPE */
 a_pr_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_mt                         IN VARCHAR2,      /* VC20_TYPE */
 a_mt_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_freq_val                   IN NUMBER,        /* NUM_TYPE */
 a_invert_freq                IN CHAR,          /* CHAR1_TYPE */
 a_ref_date                   IN DATE,          /* DATE_TYPE */
 a_last_sched                 IN OUT DATE,      /* DATE_TYPE */
 a_last_cnt                   IN OUT NUMBER,    /* NUM_TYPE */
 a_last_val                   IN OUT VARCHAR2)  /* VC40_TYPE */
RETURN NUMBER;

/* custom frequency for equipment intervention  */
FUNCTION EqCaRuleXMeasures                      /* INTERNAL */
(a_eq                         IN VARCHAR2,      /* VC20_TYPE */
 a_lab                        IN VARCHAR2,      /* VC20_TYPE */
 a_eq_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_ca                         IN VARCHAR2,      /* VC20_TYPE */
 a_freq_val                   IN NUMBER,        /* NUM_TYPE */
 a_warning_upfront            IN CHAR,          /* CHAR1_TYPE */
 a_ref_date                   IN DATE,          /* DATE_TYPE */
 a_last_sched                 IN OUT DATE,      /* DATE_TYPE */
 a_last_cnt                   IN OUT NUMBER,    /* NUM_TYPE */
 a_last_val                   IN OUT VARCHAR2,  /* VC40_TYPE */
 a_old_ca_warn_level          IN CHAR,          /* CHAR1_TYPE */
 a_grace_val                  IN NUMBER,        /* NUM_TYPE */
 a_grace_unit                 IN VARCHAR2,      /* VC20_TYPE */
 a_suspend                    IN CHAR,          /* CHAR1_TYPE */
 a_new_ca_warn_level          OUT CHAR)         /* CHAR1_TYPE */
RETURN NUMBER;

/* sample planner custom assignment frequencies */
FUNCTION StPlanMax3TimesByMon                   /* INTERNAL */
(a_st_or_rt                   IN VARCHAR2,      /* VC20_TYPE */
 a_st_or_rt_version           IN VARCHAR2,      /* VC20_TYPE */
 a_freq_val                   IN NUMBER,        /* NUM_TYPE */
 a_invert_freq                IN CHAR,          /* CHAR1_TYPE */
 a_ref_date                   IN DATE,          /* DATE_TYPE */
 a_last_sched                 IN OUT DATE,      /* DATE_TYPE */
 a_last_cnt                   IN OUT NUMBER,    /* NUM_TYPE */
 a_last_val                   IN OUT VARCHAR2)  /* VC40_TYPE */
RETURN NUMBER;

FUNCTION StPlanOnlyOnWorkDay                      /* INTERNAL */
(a_st_or_rt                   IN VARCHAR2,      /* VC20_TYPE */
 a_st_or_rt_version           IN VARCHAR2,      /* VC20_TYPE */
 a_freq_val                   IN NUMBER,        /* NUM_TYPE */
 a_invert_freq                IN CHAR,          /* CHAR1_TYPE */
 a_ref_date                   IN DATE,          /* DATE_TYPE */
 a_last_sched                 IN OUT DATE,      /* DATE_TYPE */
 a_last_cnt                   IN OUT NUMBER,    /* NUM_TYPE */
 a_last_val                   IN OUT VARCHAR2)  /* VC40_TYPE */
RETURN NUMBER;

FUNCTION StPlanOnlyOnFriday                       /* INTERNAL */
(a_st_or_rt                   IN VARCHAR2,      /* VC20_TYPE */
 a_st_or_rt_version           IN VARCHAR2,      /* VC20_TYPE */
 a_freq_val                   IN NUMBER,        /* NUM_TYPE */
 a_invert_freq                IN CHAR,          /* CHAR1_TYPE */
 a_ref_date                   IN DATE,          /* DATE_TYPE */
 a_last_sched                 IN OUT DATE,      /* DATE_TYPE */
 a_last_cnt                   IN OUT NUMBER,    /* NUM_TYPE */
 a_last_val                   IN OUT VARCHAR2)  /* VC40_TYPE */
RETURN NUMBER;

/* request planner custom assignment frequencies */
FUNCTION RtPlanMax3TimesByMon                   /* INTERNAL */
(a_st_or_rt                   IN VARCHAR2,      /* VC20_TYPE */
 a_st_or_rt_version           IN VARCHAR2,      /* VC20_TYPE */
 a_freq_val                   IN NUMBER,        /* NUM_TYPE */
 a_invert_freq                IN CHAR,          /* CHAR1_TYPE */
 a_ref_date                   IN DATE,          /* DATE_TYPE */
 a_last_sched                 IN OUT DATE,      /* DATE_TYPE */
 a_last_cnt                   IN OUT NUMBER,    /* NUM_TYPE */
 a_last_val                   IN OUT VARCHAR2)  /* VC40_TYPE */
RETURN NUMBER;

FUNCTION RtPlanOnlyOnWorkDay                      /* INTERNAL */
(a_st_or_rt                   IN VARCHAR2,      /* VC20_TYPE */
 a_st_or_rt_version           IN VARCHAR2,      /* VC20_TYPE */
 a_freq_val                   IN NUMBER,        /* NUM_TYPE */
 a_invert_freq                IN CHAR,          /* CHAR1_TYPE */
 a_ref_date                   IN DATE,          /* DATE_TYPE */
 a_last_sched                 IN OUT DATE,      /* DATE_TYPE */
 a_last_cnt                   IN OUT NUMBER,    /* NUM_TYPE */
 a_last_val                   IN OUT VARCHAR2)  /* VC40_TYPE */
RETURN NUMBER;

FUNCTION RtPlanOnlyOnFriday                       /* INTERNAL */
(a_st_or_rt                   IN VARCHAR2,      /* VC20_TYPE */
 a_st_or_rt_version           IN VARCHAR2,      /* VC20_TYPE */
 a_freq_val                   IN NUMBER,        /* NUM_TYPE */
 a_invert_freq                IN CHAR,          /* CHAR1_TYPE */
 a_ref_date                   IN DATE,          /* DATE_TYPE */
 a_last_sched                 IN OUT DATE,      /* DATE_TYPE */
 a_last_cnt                   IN OUT NUMBER,    /* NUM_TYPE */
 a_last_val                   IN OUT VARCHAR2)  /* VC40_TYPE */
RETURN NUMBER;

--------------------------------------------------------------------------------
-- Customization Vredestein
--------------------------------------------------------------------------------
FUNCTION OncePerSample                          /* INTERNAL */
(avs_sc                         IN VARCHAR2,      /* VC20_TYPE */
 avs_st                         IN VARCHAR2,      /* VC20_TYPE */
 avs_st_version                 IN VARCHAR2,      /* VC20_TYPE */
 avs_pp                         IN VARCHAR2,      /* VC20_TYPE */
 avs_pp_version                 IN VARCHAR2,      /* VC20_TYPE */
 avs_pp_key1                    IN VARCHAR2,      /* VC20_TYPE */
 avs_pp_key2                    IN VARCHAR2,      /* VC20_TYPE */
 avs_pp_key3                    IN VARCHAR2,      /* VC20_TYPE */
 avs_pp_key4                    IN VARCHAR2,      /* VC20_TYPE */
 avs_pp_key5                    IN VARCHAR2,      /* VC20_TYPE */
 avs_pr                         IN VARCHAR2,      /* VC20_TYPE */
 avs_pr_version                 IN VARCHAR2,      /* VC20_TYPE */
 avs_mt                         IN VARCHAR2,      /* VC20_TYPE */
 avs_mt_version                 IN VARCHAR2,      /* VC20_TYPE */
 avi_freq_val                   IN NUMBER,        /* NUM_TYPE */
 avc_invert_freq                IN CHAR,          /* CHAR1_TYPE */
 avd_ref_date                   IN DATE,          /* DATE_TYPE */
 avd_last_sched                 IN OUT DATE,      /* DATE_TYPE */
 avi_last_cnt                   IN OUT NUMBER,    /* NUM_TYPE */
 avs_last_val                   IN OUT VARCHAR2)  /* VC40_TYPE */
RETURN NUMBER;

FUNCTION OncePerSampleTrials                          /* INTERNAL */
(avs_sc                         IN VARCHAR2,      /* VC20_TYPE */
 avs_st                         IN VARCHAR2,      /* VC20_TYPE */
 avs_st_version                 IN VARCHAR2,      /* VC20_TYPE */
 avs_pp                         IN VARCHAR2,      /* VC20_TYPE */
 avs_pp_version                 IN VARCHAR2,      /* VC20_TYPE */
 avs_pp_key1                    IN VARCHAR2,      /* VC20_TYPE */
 avs_pp_key2                    IN VARCHAR2,      /* VC20_TYPE */
 avs_pp_key3                    IN VARCHAR2,      /* VC20_TYPE */
 avs_pp_key4                    IN VARCHAR2,      /* VC20_TYPE */
 avs_pp_key5                    IN VARCHAR2,      /* VC20_TYPE */
 avs_pr                         IN VARCHAR2,      /* VC20_TYPE */
 avs_pr_version                 IN VARCHAR2,      /* VC20_TYPE */
 avs_mt                         IN VARCHAR2,      /* VC20_TYPE */
 avs_mt_version                 IN VARCHAR2,      /* VC20_TYPE */
 avi_freq_val                   IN NUMBER,        /* NUM_TYPE */
 avc_invert_freq                IN CHAR,          /* CHAR1_TYPE */
 avd_ref_date                   IN DATE,          /* DATE_TYPE */
 avd_last_sched                 IN OUT DATE,      /* DATE_TYPE */
 avi_last_cnt                   IN OUT NUMBER,    /* NUM_TYPE */
 avs_last_val                   IN OUT VARCHAR2)  /* VC40_TYPE */
RETURN NUMBER;

FUNCTION ScPgInterspec                          /* INTERNAL */
(a_sc_or_rq                   IN VARCHAR2,      /* VC20_TYPE */
 a_st_or_rt                   IN VARCHAR2,      /* VC20_TYPE */
 a_st_or_rt_version           IN VARCHAR2,      /* VC20_TYPE */
 a_pp                         IN VARCHAR2,      /* VC20_TYPE */
 a_pp_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key1                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key2                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key3                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key4                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key5                    IN VARCHAR2,      /* VC20_TYPE */
 a_freq_val                   IN NUMBER,        /* NUM_TYPE */
 a_invert_freq                IN CHAR,          /* CHAR1_TYPE */
 a_ref_date                   IN DATE,          /* DATE_TYPE */
 a_last_sched                 IN OUT DATE,      /* DATE_TYPE */
 a_last_cnt                   IN OUT NUMBER,    /* NUM_TYPE */
 a_last_val                   IN OUT VARCHAR2)  /* VC40_TYPE */
RETURN NUMBER;

FUNCTION ScPaInterspec                          /* INTERNAL */
(a_sc                         IN VARCHAR2,      /* VC20_TYPE */
 a_st                         IN VARCHAR2,      /* VC20_TYPE */
 a_st_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_pp                         IN VARCHAR2,      /* VC20_TYPE */
 a_pp_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key1                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key2                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key3                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key4                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key5                    IN VARCHAR2,      /* VC20_TYPE */
 a_pr                         IN VARCHAR2,      /* VC20_TYPE */
 a_pr_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_freq_val                   IN NUMBER,        /* NUM_TYPE */
 a_invert_freq                IN CHAR,          /* CHAR1_TYPE */
 a_ref_date                   IN DATE,          /* DATE_TYPE */
 a_last_sched                 IN OUT DATE,      /* DATE_TYPE */
 a_last_cnt                   IN OUT NUMBER,    /* NUM_TYPE */
 a_last_val                   IN OUT VARCHAR2)  /* VC40_TYPE */
RETURN NUMBER;

FUNCTION WsCreate                               /* INTERNAL */
(a_sc                         IN VARCHAR2,      /* VC20_TYPE */
 a_st                         IN VARCHAR2,      /* VC20_TYPE */
 a_st_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_pp                         IN VARCHAR2,      /* VC20_TYPE */
 a_pp_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key1                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key2                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key3                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key4                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key5                    IN VARCHAR2,      /* VC20_TYPE */
 a_pr                         IN VARCHAR2,      /* VC20_TYPE */
 a_pr_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_mt                         IN VARCHAR2,      /* VC20_TYPE */
 a_mt_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_freq_val                   IN NUMBER,        /* NUM_TYPE */
 a_invert_freq                IN CHAR,          /* CHAR1_TYPE */
 a_ref_date                   IN DATE,          /* DATE_TYPE */
 a_last_sched                 IN OUT DATE,      /* DATE_TYPE */
 a_last_cnt                   IN OUT NUMBER,    /* NUM_TYPE */
 a_last_val                   IN OUT VARCHAR2)  /* VC40_TYPE */
RETURN NUMBER;

FUNCTION WsCreateInSubProgram                   /* INTERNAL */
(a_sc                         IN VARCHAR2,      /* VC20_TYPE */
 a_st                         IN VARCHAR2,      /* VC20_TYPE */
 a_st_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_pp                         IN VARCHAR2,      /* VC20_TYPE */
 a_pp_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key1                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key2                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key3                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key4                    IN VARCHAR2,      /* VC20_TYPE */
 a_pp_key5                    IN VARCHAR2,      /* VC20_TYPE */
 a_pr                         IN VARCHAR2,      /* VC20_TYPE */
 a_pr_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_mt                         IN VARCHAR2,      /* VC20_TYPE */
 a_mt_version                 IN VARCHAR2,      /* VC20_TYPE */
 a_freq_val                   IN NUMBER,        /* NUM_TYPE */
 a_invert_freq                IN CHAR,          /* CHAR1_TYPE */
 a_ref_date                   IN DATE,          /* DATE_TYPE */
 a_last_sched                 IN OUT DATE,      /* DATE_TYPE */
 a_last_cnt                   IN OUT NUMBER,    /* NUM_TYPE */
 a_last_val                   IN OUT VARCHAR2)  /* VC40_TYPE */
RETURN NUMBER;

END UNFREQ;

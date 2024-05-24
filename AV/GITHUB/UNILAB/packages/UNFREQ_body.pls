create or replace PACKAGE BODY        UNFREQ AS
--------------------------------------------------------------------------------
--  PROJECT : Vredestein Enschede
-------------------------------------------------------------------------------
--  PACKAGE : UNFREQ
-- ABSTRACT :
--   WRITER : Rody Sparenberg
--     DATE : 16/03/2007
--   TARGET : Oracle 10.2.0 / Unilab 6.3
--  VERSION : av3.0
--------------------------------------------------------------------------------
--  REMARKS : The general rules for cf_type in utcf can be found
--                  in the document: customizing the system
--               Minimal information can also be found in the header
--                  of the unaction package
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
-- 28/05/2008 | RS        | Altered logging UABased
--                        | Added missing link for pr-mt
-- 06/08/2008 | RS        | Added OncePerSampleTrials
-- 01/10/2008 | RS        | Added UAbasedSc
--                        | Rename UAbased into UAbasedSt
--                        | Added UAbased
-- 26/11/2008 | RS        | Added ScPgInterspec
--                        | Added ScPaInterspec
-- 08/04/2008 | RS        | Changed ScPaInterspec
-- 21/04/2010 | HVB       | Bugfixes in UAbased Marker HVB2.
-- 29/04/2010 | HVB       | Changed comments (All trace-errorcalls) mark HVB3
--                          | Performance updates
-- 03/03/2011 | RS        | Upgrade V6.3
--                        | Changed SYSDATE INTO CURRENT_TIMESTAMP
-- 13/02/2013 | RS        | Added WsCreate
--                        | Added WsCreateInSubProgram
-- 08/06/2015 | JP        | Expanded error logging in UAbasedSt, UAbasedSc
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
ics_package_name                 CONSTANT APAOGEN.API_NAME_TYPE := 'UNFREQ';
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
l_sql_string      VARCHAR2(2000);
l_result          NUMBER;
l_sqlerrm         VARCHAR2(255);

--------------------------------------------------------------------------------
-- internal function for tracing/logging in autonomous transaction
--------------------------------------------------------------------------------
PROCEDURE TraceError
(a_api_name     IN        VARCHAR2,    /* VC40_TYPE */
 a_log_error    IN        VARCHAR2,    /* HVB3*/
 a_key          IN        VARCHAR2,    /* HVB3*/
 a_seq          IN OUT    NUMBER,
 a_error_msg    IN        VARCHAR2    /* VC255_TYPE */
)  /* HVB3*/
IS
PRAGMA AUTONOMOUS_TRANSACTION;
lvi_error_msg VARCHAR2(255);
BEGIN

--HVB3   IF APAOGEN.GetSystemSetting('LOG','NO') = 'YES' THEN
   IF a_log_error= 'YES' THEN     --HVB3
      lvi_error_msg := a_key || TO_CHAR(a_seq) || ':' ||a_error_msg;
      --autonomous transaction used here
      --UNAPIGEN.LogError is also an autonomous transaction but may rollback the current transaction
      INSERT INTO uterror(client_id, applic, who, logdate, api_name, error_msg)
      VALUES (UNAPIGEN.P_CLIENT_ID, SUBSTR(UNAPIGEN.P_APPLIC_NAME,1,8), NVL(UNAPIGEN.P_USER,USER), CURRENT_TIMESTAMP,
              SUBSTR(a_api_name,1,40), SUBSTR(lvi_error_msg,1,255));
      COMMIT;
      a_seq := a_seq + 1; --HVB3
   END IF;
END TraceError;

--------------------------------------------------------------------------------
-- functions- and/or procedures-declarations
--------------------------------------------------------------------------------
FUNCTION Maximum3TimesByMonth                   /* INTERNAL */
(a_ref_date                   IN DATE,          /* DATE_TYPE */
 a_last_sched                 IN OUT DATE,      /* DATE_TYPE */
 a_last_cnt                   IN OUT NUMBER,    /* NUM_TYPE */
 a_last_val                   IN OUT VARCHAR2)  /* VC40_TYPE */
RETURN NUMBER IS

l_current_month       INTEGER;
l_last_sched_month    INTEGER;

BEGIN

   /* a_last_val contains the month string YYYYMM    */
   /* a_last_cnt is the counter (always incremented) */
   /* a_last_sched is set when success returned      */

   l_current_month     := TO_NUMBER(TO_CHAR(a_ref_date,   'YYYYMM'));
   BEGIN
      l_last_sched_month  := NVL(a_last_val,0);
   EXCEPTION
   WHEN OTHERS THEN
      --necessary since last_val can be edited by user
      l_last_sched_month  :=0;
   END;

   /* Compare new and old */
   IF l_last_sched_month <> l_current_month THEN
      a_last_cnt := 1;
      a_last_val := l_current_month;
      a_last_sched := a_ref_date;
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   ELSE
      IF a_last_cnt >= 3 THEN
         a_last_cnt := a_last_cnt + 1;
         RETURN(UNAPIGEN.DBERR_GENFAIL);
      ELSE
         a_last_cnt := a_last_cnt + 1;
         a_last_sched := a_ref_date;
         RETURN(UNAPIGEN.DBERR_SUCCESS);
      END IF;
   END IF;

EXCEPTION
WHEN OTHERS THEN
   l_sqlerrm := SUBSTR(SQLERRM,1,255);
   INSERT INTO uterror(client_id, applic, who, logdate, api_name, error_msg)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP,
          'Maximum3TimesByMonth', l_sqlerrm);
   INSERT INTO uterror(client_id, applic, who, logdate, api_name, error_msg)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP,
          'Maximum3TimesByMonth',
          TO_CHAR(a_ref_date)||'#'||TO_CHAR(a_last_sched)||
          '#'||TO_CHAR(a_last_cnt)||'#'||a_last_val);
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END Maximum3TimesByMonth;

FUNCTION OnlyOnWorkDay                          /* INTERNAL */
(a_ref_date                   IN DATE,          /* DATE_TYPE */
 a_last_sched                 IN OUT DATE,      /* DATE_TYPE */
 a_last_cnt                   IN OUT NUMBER,    /* NUM_TYPE */
 a_last_val                   IN OUT VARCHAR2)  /* VC40_TYPE */
RETURN NUMBER IS
l_day_string         VARCHAR2(20);
BEGIN
   --The 3rd argument is used to set the language to American
   --This is important the strings MON,TUE,WED,THU,FRI  would not be returned on a server using another language than American
   l_day_string := TO_CHAR(a_ref_date, 'DY', 'NLS_DATE_LANGUAGE=American');
   IF UPPER(l_day_string) IN ('MON', 'TUE', 'WED', 'THU', 'FRI') THEN
      a_last_sched := a_ref_date;
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   ELSE
        RETURN(UNAPIGEN.DBERR_GENFAIL);
   END IF;
END OnlyOnWorkDay;

FUNCTION OnlyOnFriday                          /* INTERNAL */
(a_ref_date                   IN DATE,          /* DATE_TYPE */
 a_last_sched                 IN OUT DATE,      /* DATE_TYPE */
 a_last_cnt                   IN OUT NUMBER,    /* NUM_TYPE */
 a_last_val                   IN OUT VARCHAR2)  /* VC40_TYPE */
RETURN NUMBER IS
l_day_string         VARCHAR2(20);
BEGIN
   --The 3rd argument is used to set the language to American
   --This is important the FRI would not be returned on a server using another language than American
   l_day_string := TO_CHAR(a_ref_date, 'DY','NLS_DATE_LANGUAGE=American');
   IF UPPER(l_day_string) = 'FRI' THEN
      a_last_sched := a_ref_date;
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   ELSE
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   END IF;
END OnlyOnFriday;

FUNCTION IsOdd                                  /* INTERNAL */
(a_last_digit                 IN CHAR,          /* CHAR_TYPE */
 a_ref_date                   IN DATE,          /* DATE_TYPE */
 a_last_sched                 IN OUT DATE,      /* DATE_TYPE */
 a_last_cnt                   IN OUT NUMBER,    /* NUM_TYPE */
 a_last_val                   IN OUT VARCHAR2)  /* VC40_TYPE */
RETURN NUMBER IS
l_day_string         VARCHAR2(20);
BEGIN
   IF a_last_digit IN ('1', '3', '5', '7', '9') THEN
      a_last_sched := a_ref_date;
      a_last_val := a_last_digit;
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   ELSE
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   END IF;
END IsOdd;

/*------------------*/
/* Public functions */
/*------------------*/
/*------------*/
/* rqst level */
/*------------*/

/* Example of custom assignment frequency evaluated for rt's used st's */
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
RETURN NUMBER IS

BEGIN
   RETURN(Maximum3TimesByMonth(a_ref_date, a_last_sched, a_last_cnt, a_last_val));
END ScMax3TimesByMonth;

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
RETURN NUMBER IS

BEGIN
   RETURN(OnlyOnWorkDay(a_ref_date, a_last_sched, a_last_cnt, a_last_val));
END ScOnlyOnWorkDay;

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
RETURN NUMBER IS

BEGIN
   RETURN(OnlyOnFriday(a_ref_date, a_last_sched, a_last_cnt, a_last_val));
END ScOnlyOnFriday;

/*------------*/
/* stip level */
/*------------*/
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
RETURN NUMBER IS
l_grade       VARCHAR2(40);
BEGIN

BEGIN
SELECT iivalue
INTO l_grade
FROM UTSCII
WHERE II='grade'
AND SC=a_sc;

EXCEPTION
WHEN NO_DATA_FOUND THEN
RETURN(UNAPIGEN.DBERR_GENFAIL);
END;

IF UPPER(a_ip) LIKE UPPER(l_grade)||'%' THEN
   RETURN(UNAPIGEN.DBERR_SUCCESS);
ELSE
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END IF;
EXCEPTION
WHEN OTHERS THEN
   l_sqlerrm := SUBSTR(SQLERRM,1,255);
   INSERT INTO uterror(client_id, applic, who, logdate, api_name, error_msg)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP,
          'UNFREQ.SCICSUPPLIER_GRADE', l_sqlerrm);
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END ScIcSupplier_Grade;

/*------------*/
/* rtip level */
/*------------*/

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
RETURN NUMBER IS
l_grade       VARCHAR2(40);
BEGIN

BEGIN
SELECT iivalue
INTO l_grade
FROM utrqii
WHERE II='grade'
AND rq=a_rq;

EXCEPTION
WHEN NO_DATA_FOUND THEN
RETURN(UNAPIGEN.DBERR_GENFAIL);
END;

IF UPPER(a_ip) LIKE UPPER(l_grade)||'%' THEN
   RETURN(UNAPIGEN.DBERR_SUCCESS);
ELSE
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END IF;
EXCEPTION
WHEN OTHERS THEN
   l_sqlerrm := SUBSTR(SQLERRM,1,255);
   INSERT INTO uterror(client_id, applic, who, logdate, api_name, error_msg)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP,
          'UNFREQ.RQICSUPPLIER_GRADE', l_sqlerrm);
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END RqIcSupplier_Grade;

/*------------*/
/* rtpp level */
/*------------*/
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
RETURN NUMBER IS

BEGIN
   RETURN(Maximum3TimesByMonth(a_ref_date, a_last_sched, a_last_cnt, a_last_val));
END RqPgMax3TimesByMonth;

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
RETURN NUMBER  IS

BEGIN
   RETURN(OnlyOnWorkDay(a_ref_date, a_last_sched, a_last_cnt, a_last_val));
END RqPgOnlyOnWorkDay;

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
RETURN NUMBER  IS

BEGIN
   RETURN(OnlyOnFriday(a_ref_date, a_last_sched, a_last_cnt, a_last_val));
END RqPgOnlyOnFriday;

/*------------*/
/* rtst level */
/*------------*/
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
RETURN NUMBER IS

BEGIN
   RETURN(Maximum3TimesByMonth(a_ref_date, a_last_sched, a_last_cnt, a_last_val));
END RqScMax3TimesByMonth;

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
RETURN NUMBER  IS

BEGIN
   RETURN(OnlyOnWorkDay(a_ref_date, a_last_sched, a_last_cnt, a_last_val));
END RqScOnlyOnWorkDay;

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
RETURN NUMBER  IS

BEGIN
   RETURN(OnlyOnFriday(a_ref_date, a_last_sched, a_last_cnt, a_last_val));
END RqScOnlyOnFriday;

/*------------*/
/* stpp level */
/*------------*/

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
RETURN NUMBER IS

BEGIN
--TraceError('ScPgMax3TimesByMonth', 'pp_key1='||a_pp_key1);
--TraceError('ScPgMax3TimesByMonth', 'pp_key2='||a_pp_key2);
--TraceError('ScPgMax3TimesByMonth', 'pp_key3='||a_pp_key3);
--TraceError('ScPgMax3TimesByMonth', 'pp_key4='||a_pp_key4);
--TraceError('ScPgMax3TimesByMonth', 'pp_key5='||a_pp_key5);

   RETURN(Maximum3TimesByMonth(a_ref_date, a_last_sched, a_last_cnt, a_last_val));
END ScPgMax3TimesByMonth;

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
RETURN NUMBER IS

BEGIN
   RETURN(OnlyOnWorkDay(a_ref_date, a_last_sched, a_last_cnt, a_last_val));
END ScPgOnlyOnWorkDay;

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
RETURN NUMBER IS

BEGIN
   RETURN(OnlyOnFriday(a_ref_date, a_last_sched, a_last_cnt, a_last_val));
END ScPgOnlyOnFriday;

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
RETURN NUMBER IS
l_rq        VARCHAR2(20);
BEGIN
   --This function is illustrating how to find the request information
   --in assignment frequency functions (same principle also valid on pa and me level)
   BEGIN
      SELECT rq
      INTO l_rq
      FROM utrq
      WHERE rq = a_sc_or_rq;
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
      BEGIN
      SELECT rq
      INTO l_rq
      FROM utsc
      WHERE sc = a_sc_or_rq;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         NULL;
      END;
   END;

   IF l_rq IS NOT NULL THEN
      RETURN(IsOdd(SUBSTR(l_rq,-1), a_ref_date, a_last_sched, a_last_cnt, a_last_val));
   ELSE
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   END IF;
END ScPgOnlyWhenRqIsOdd;


/*------------*/
/* pppr level */
/*------------*/
/* Example of custom assignment frequency evaluated for pp's used pr's */
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
RETURN NUMBER IS

BEGIN
--TraceError('ScPgMax3TimesByMonth', 'pp_key1='||a_pp_key1);
--TraceError('ScPgMax3TimesByMonth', 'pp_key2='||a_pp_key2);
--TraceError('ScPgMax3TimesByMonth', 'pp_key3='||a_pp_key3);
--TraceError('ScPgMax3TimesByMonth', 'pp_key4='||a_pp_key4);
--TraceError('ScPgMax3TimesByMonth', 'pp_key5='||a_pp_key5);

   RETURN(Maximum3TimesByMonth(a_ref_date, a_last_sched, a_last_cnt, a_last_val));
END ScPaMax3TimesByMonth;

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
RETURN NUMBER IS

BEGIN
   RETURN(OnlyOnWorkDay(a_ref_date, a_last_sched, a_last_cnt, a_last_val));
END ScPaOnlyOnWorkDay;

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
RETURN NUMBER IS

BEGIN
   RETURN(OnlyOnFriday(a_ref_date, a_last_sched, a_last_cnt, a_last_val));
END ScPaOnlyOnFriday;

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
RETURN NUMBER IS

CURSOR l_verifyifpapresentinsc_cursor IS
   --canceled parameters are ignored
   SELECT COUNT(*)
   FROM utscpa
   WHERE sc = a_sc
   AND pa = a_pr
   AND NVL(ss, '@~') <> '@C';
l_count          INTEGER;

BEGIN
   OPEN l_verifyifpapresentinsc_cursor;
   FETCH l_verifyifpapresentinsc_cursor
   INTO l_count;
   CLOSE l_verifyifpapresentinsc_cursor;
   IF l_count > 0 THEN
      --already present => may not be assigned => return UNAPIGEN.DBERR_GENFAIL
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   ELSE
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;
END ScPaNotYetInAnyPg;

FUNCTION ScPaNotYetInSamePg                          /* INTERNAL */
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
RETURN NUMBER IS

CURSOR l_verifyifpapresentinpg_cursor IS
   --canceled methods are ignored
   SELECT COUNT(*)
   FROM utscpa
   WHERE sc = a_sc
   AND pg = a_pp
   AND pa = a_pr
   AND NVL(ss, '@~') <> '@C';
l_count          INTEGER;

BEGIN
   OPEN l_verifyifpapresentinpg_cursor;
   FETCH l_verifyifpapresentinpg_cursor
   INTO l_count;
   CLOSE l_verifyifpapresentinpg_cursor;
   IF l_count > 0 THEN
      --already present => may not be assigned => return UNAPIGEN.DBERR_GENFAIL
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   ELSE
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;
END ScPaNotYetInSamePg;

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
RETURN NUMBER IS
l_sd        VARCHAR2(20);
BEGIN
   --This function is illustrating how to find the study information
   --in assignment frequency functions (same principle also valid on pa and me level)
   BEGIN
      SELECT sd
      INTO l_sd
      FROM utsc
      WHERE sc = a_sc;
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
      NULL;
   END;

   IF l_sd IS NOT NULL THEN
      RETURN(IsOdd(SUBSTR(l_sd,-1), a_ref_date, a_last_sched, a_last_cnt, a_last_val));
   ELSE
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   END IF;
END ScPaOnlyWhenSdIsOdd;

/*------------*/
/* prmt level */
/*------------*/
/* Example of custom assignment frequency evaluated for mt used in a pr */
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
RETURN NUMBER IS

BEGIN
--TraceError('ScPgMax3TimesByMonth', 'pp_key1='||a_pp_key1);
--TraceError('ScPgMax3TimesByMonth', 'pp_key2='||a_pp_key2);
--TraceError('ScPgMax3TimesByMonth', 'pp_key3='||a_pp_key3);
--TraceError('ScPgMax3TimesByMonth', 'pp_key4='||a_pp_key4);
--TraceError('ScPgMax3TimesByMonth', 'pp_key5='||a_pp_key5);

   RETURN(Maximum3TimesByMonth(a_ref_date, a_last_sched, a_last_cnt, a_last_val));
END ScMeMax3TimesByMonth;

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
RETURN NUMBER IS

BEGIN
   RETURN(OnlyOnWorkDay(a_ref_date, a_last_sched, a_last_cnt, a_last_val));
END ScMeOnlyOnWorkDay;

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
RETURN NUMBER IS

BEGIN
   RETURN(OnlyOnFriday(a_ref_date, a_last_sched, a_last_cnt, a_last_val));
END ScMeOnlyOnFriday;

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
RETURN NUMBER IS

CURSOR l_verifyifmepresentinsc_cursor IS
   --canceled methods are ignored
   SELECT COUNT(*)
   FROM utscme
   WHERE sc = a_sc
   AND me = a_mt
   AND NVL(ss, '@~') <> '@C';
l_count          INTEGER;

BEGIN
   OPEN l_verifyifmepresentinsc_cursor;
   FETCH l_verifyifmepresentinsc_cursor
   INTO l_count;
   CLOSE l_verifyifmepresentinsc_cursor;
   IF l_count > 0 THEN
      --already present => may not be assigned => return UNAPIGEN.DBERR_GENFAIL
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   ELSE
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;
END ScMeNotYetInAnyPg;

FUNCTION ScMeNotYetInSamePg                          /* INTERNAL */
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
RETURN NUMBER IS

CURSOR l_verifyifmepresentinpg_cursor IS
   --canceled methods are ignored
   SELECT COUNT(*)
   FROM utscme
   WHERE sc = a_sc
   AND pg = a_pp
   AND me = a_mt
   AND NVL(ss, '@~') <> '@C';
l_count          INTEGER;

BEGIN
   OPEN l_verifyifmepresentinpg_cursor;
   FETCH l_verifyifmepresentinpg_cursor
   INTO l_count;
   CLOSE l_verifyifmepresentinpg_cursor;
   IF l_count > 0 THEN
      --already present => may not be assigned => return UNAPIGEN.DBERR_GENFAIL
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   ELSE
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;
END ScMeNotYetInSamePg;

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
RETURN NUMBER IS
l_rq        VARCHAR2(20);
BEGIN
   --This function is illustrating how to find the request information
   --in assignment frequency functions (same principle also valid on pa and me level)
   BEGIN
      SELECT rq
      INTO l_rq
      FROM utsc
      WHERE sc = a_sc;
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
      NULL;
   END;

   IF l_rq IS NOT NULL THEN
      RETURN(IsOdd(SUBSTR(l_rq,-1), a_ref_date, a_last_sched, a_last_cnt, a_last_val));
   ELSE
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   END IF;
END ScMeOnlyWhenRqIsOdd;

/*----------------------------------------------*/
/* custom frequency for equipment interventions */
/*----------------------------------------------*/
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
RETURN NUMBER IS

l_intervention   INTEGER;

BEGIN
   --The intervention has to take place once by month
   --or every X measures (specified in freq_val)

   --no intervention by default
   l_intervention := UNAPIGEN.DBERR_NOOBJECT;

   a_last_cnt := a_last_cnt+1;
   IF a_old_ca_warn_level NOT IN ('3', '4') THEN
      IF a_old_ca_warn_level = '2' THEN
         --intervention busy (equipment is in grace period)
         --check if warning level has to set to 3
         IF a_last_cnt >= a_grace_val THEN
            a_new_ca_warn_level := '3';
         END IF;
      ELSE
         IF a_last_cnt >= a_freq_val OR
            CURRENT_TIMESTAMP > ADD_MONTHS(a_last_sched,1) THEN
            l_intervention := UNAPIGEN.DBERR_SUCCESS;
            a_last_cnt := 0;
            a_last_sched := CURRENT_TIMESTAMP;

            IF a_suspend = '0' THEN
               a_new_ca_warn_level := '3';
            ELSE
               IF a_last_cnt >= a_grace_val THEN
                  a_new_ca_warn_level := '3';
               ELSE
                  a_new_ca_warn_level := '2';
               END IF;
            END IF;
         ELSIF a_warning_upfront = '1' AND
               a_last_cnt >= a_freq_val-a_grace_val THEN
            a_new_ca_warn_level := '1';
         END IF;
      END IF;
   END IF;
   RETURN(l_intervention);

END EqCaRuleXMeasures;

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
RETURN NUMBER IS

BEGIN
   RETURN(Maximum3TimesByMonth(a_ref_date, a_last_sched, a_last_cnt, a_last_val));
END StPlanMax3TimesByMon;

FUNCTION StPlanOnlyOnWorkDay                      /* INTERNAL */
(a_st_or_rt                   IN VARCHAR2,      /* VC20_TYPE */
 a_st_or_rt_version           IN VARCHAR2,      /* VC20_TYPE */
 a_freq_val                   IN NUMBER,        /* NUM_TYPE */
 a_invert_freq                IN CHAR,          /* CHAR1_TYPE */
 a_ref_date                   IN DATE,          /* DATE_TYPE */
 a_last_sched                 IN OUT DATE,      /* DATE_TYPE */
 a_last_cnt                   IN OUT NUMBER,    /* NUM_TYPE */
 a_last_val                   IN OUT VARCHAR2)  /* VC40_TYPE */
RETURN NUMBER  IS

BEGIN
   RETURN(OnlyOnWorkDay(a_ref_date, a_last_sched, a_last_cnt, a_last_val));
END StPlanOnlyOnWorkDay;

FUNCTION StPlanOnlyOnFriday                       /* INTERNAL */
(a_st_or_rt                   IN VARCHAR2,      /* VC20_TYPE */
 a_st_or_rt_version           IN VARCHAR2,      /* VC20_TYPE */
 a_freq_val                   IN NUMBER,        /* NUM_TYPE */
 a_invert_freq                IN CHAR,          /* CHAR1_TYPE */
 a_ref_date                   IN DATE,          /* DATE_TYPE */
 a_last_sched                 IN OUT DATE,      /* DATE_TYPE */
 a_last_cnt                   IN OUT NUMBER,    /* NUM_TYPE */
 a_last_val                   IN OUT VARCHAR2)  /* VC40_TYPE */
RETURN NUMBER  IS

BEGIN
   RETURN(OnlyOnFriday(a_ref_date, a_last_sched, a_last_cnt, a_last_val));
END StPlanOnlyOnFriday;

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
RETURN NUMBER IS

BEGIN
   RETURN(Maximum3TimesByMonth(a_ref_date, a_last_sched, a_last_cnt, a_last_val));
END RtPlanMax3TimesByMon;

FUNCTION RtPlanOnlyOnWorkDay                      /* INTERNAL */
(a_st_or_rt                   IN VARCHAR2,      /* VC20_TYPE */
 a_st_or_rt_version           IN VARCHAR2,      /* VC20_TYPE */
 a_freq_val                   IN NUMBER,        /* NUM_TYPE */
 a_invert_freq                IN CHAR,          /* CHAR1_TYPE */
 a_ref_date                   IN DATE,          /* DATE_TYPE */
 a_last_sched                 IN OUT DATE,      /* DATE_TYPE */
 a_last_cnt                   IN OUT NUMBER,    /* NUM_TYPE */
 a_last_val                   IN OUT VARCHAR2)  /* VC40_TYPE */
RETURN NUMBER  IS

BEGIN
   RETURN(OnlyOnWorkDay(a_ref_date, a_last_sched, a_last_cnt, a_last_val));
END RtPlanOnlyOnWorkDay;

FUNCTION RtPlanOnlyOnFriday                       /* INTERNAL */
(a_st_or_rt                   IN VARCHAR2,      /* VC20_TYPE */
 a_st_or_rt_version           IN VARCHAR2,      /* VC20_TYPE */
 a_freq_val                   IN NUMBER,        /* NUM_TYPE */
 a_invert_freq                IN CHAR,          /* CHAR1_TYPE */
 a_ref_date                   IN DATE,          /* DATE_TYPE */
 a_last_sched                 IN OUT DATE,      /* DATE_TYPE */
 a_last_cnt                   IN OUT NUMBER,    /* NUM_TYPE */
 a_last_val                   IN OUT VARCHAR2)  /* VC40_TYPE */
RETURN NUMBER  IS

BEGIN
   RETURN(OnlyOnFriday(a_ref_date, a_last_sched, a_last_cnt, a_last_val));
END RtPlanOnlyOnFriday;

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
RETURN NUMBER IS

CURSOR lvq_verifyifmepresentinsc IS
   --canceled methods are ignored
   SELECT COUNT(*)
     FROM utscme
    WHERE sc = avs_sc
      AND me = avs_mt
      AND NVL(ss, '@~') <> '@C';

lvi_count          INTEGER;

BEGIN
    OPEN lvq_verifyifmepresentinsc;
   FETCH lvq_verifyifmepresentinsc
    INTO lvi_count;
   CLOSE lvq_verifyifmepresentinsc;

   IF lvi_count > 0 THEN
      --already present => may not be assigned => return UNAPIGEN.DBERR_GENFAIL
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   ELSE
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;

END OncePerSample;

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
RETURN NUMBER IS
--------------------------------------------------------------------------------
-- Constant
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'UAbased';
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvi_ret_code     NUMBER := UNAPIGEN.DBERR_NOOBJECT;
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------
BEGIN

   lvi_ret_code := UNFREQ.UABASEDSc( a_sc,
                                     a_st,
                                     a_st_version,
                                     a_pp,
                                     a_pp_version,
                                     a_pp_key1,
                                     a_pp_key2,
                                     a_pp_key3,
                                     a_pp_key4,
                                     a_pp_key5,
                                     a_pr,
                                     a_pr_version,
                                     a_mt,
                                     a_mt_version,
                                     a_freq_val,
                                     a_invert_freq,
                                     a_ref_date,
                                     a_last_sched,
                                     a_last_cnt,
                                     a_last_val);

---HVB3   IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
   IF lvi_ret_code = UNAPIGEN.DBERR_NOOBJECT THEN --HVB3
      lvi_ret_code := UNFREQ.UABASEDSt( a_sc,
                                        a_st,
                                        a_st_version,
                                        a_pp,
                                        a_pp_version,
                                        a_pp_key1,
                                        a_pp_key2,
                                        a_pp_key3,
                                        a_pp_key4,
                                        a_pp_key5,
                                        a_pr,
                                        a_pr_version,
                                        a_mt,
                                        a_mt_version,
                                        a_freq_val,
                                        a_invert_freq,
                                        a_ref_date,
                                        a_last_sched,
                                        a_last_cnt,
                                        a_last_val);

   END IF;

   RETURN lvi_ret_code;

END UAbased;

FUNCTION UAbasedSt                              /* INTERNAL */
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
RETURN NUMBER IS
--------------------------------------------------------------------------------
-- Constant
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'UAbasedSt';
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvi_ret_code     NUMBER := UNAPIGEN.DBERR_NOOBJECT;
lvi_count            NUMBER;
lvi_key          VARCHAR2(80);
lvi_log_count    NUMBER:=100;
lvi_log_error    VARCHAR2(10) := APAOGEN.GetSystemSetting('LOG','NO');
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------
---HVB2 Define a new cursor to loop over AU's
---HVB3 Define a new fast cursor to loop over AU's
CURSOR lvq_au_name IS
SELECT DISTINCT a.au
     FROM utprmtau a, utau b
    WHERE a.mt = a_mt
      AND a.pr = a_pr
      AND a.version = a_pr_version
      AND a.mt_version = a_mt_version
      AND a.au = b.au
      AND b.version_is_current = '1'
      AND b.service = 'UAbased';

--HVB2 Define a new cursor to loop over AU's
--HVB3 CURSOR lvq_au_name IS
--HVB3 SELECT DISTINCT MTAU
--HVB3   FROM AVAO_FREQ_UABASED
--HVB3  WHERE st = a_st
--HVB3    AND st_version = a_st_version
--HVB3    AND pr = a_pr AND pr_version = a_pr_version
--HVB3    AND mt = a_mt;

--HVB2 CURSOR lvq_au1 IS
CURSOR lvq_au1(lvi_au_name in varchar2) IS /*HVB2*/
SELECT *
  FROM AVAO_FREQ_UABASED
 WHERE st = a_st
   AND st_version = a_st_version
   AND pr = a_pr AND pr_version = a_pr_version
   AND mt = a_mt
   AND mtau = lvi_au_name            /* HVB2 */
   AND operator = '=';

CURSOR lvq_au2 IS
SELECT *
  FROM AVAO_FREQ_UABASED
 WHERE st = a_st
   AND st_version = a_st_version
   AND pr = a_pr AND pr_version = a_pr_version
   AND mt = a_mt
   AND operator != '=';


BEGIN
   lvi_log_error := APAOGEN.GetSystemSetting('LOG','NO');                        --HVB3
   lvi_key       := ('st=' || a_st || ';pr=' || a_pr || ';mt=' || a_mt || ':');  --HVB3
   TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, 'a_pr_version=' || a_pr_version || ';a_mt_version=' || a_mt_version);
   --------------------------------------------------------------------------------
   -- Retrieve number of prmtau which have not been configured as stau
   --------------------------------------------------------------------------------
--HVB3   SELECT COUNT(b.au)
--HVB3         INTO lvi_count
--HVB3     FROM utprmtau b, utmt c, utau d, utprmt e
--HVB3    WHERE b.mt = c.mt
--HVB3      AND b.mt = e.mt AND b.version = e.version
--HVB3      AND c.mt = a_mt
--HVB3      AND a_mt_version = b.mt_version      /*HVB2*/
--HVB3      AND b.mt_version = e.mt_version      /*HVB2*/
--HVB3      AND b.au = d.au AND d.version_is_current = '1' AND service = 'UAbased'
--HVB3      AND c.version_is_current = '1'
--HVB3      AND b.au NOT IN (SELECT au
--HVB3                                           FROM utstau
--HVB3                                           WHERE st = a_st
--HVB3                                            AND version = a_st_version);

--HVB3 Replaced query above by the (faster and now correct) query below
   SELECT COUNT(a.au)
         INTO lvi_count
     FROM utprmtau a, utau b
    WHERE a.mt = a_mt
      AND a.pr = a_pr
      AND a.version = a_pr_version
      AND a.mt_version = a_mt_version
      AND a.au = b.au AND b.version_is_current = '1' AND b.service = 'UAbased'
      AND b.au NOT IN (SELECT au FROM utstau
                         WHERE st = a_st AND version = a_st_version);

   --------------------------------------------------------------------------------
   -- Each prmtau must be configured as stau, otherwise no assignment
   --------------------------------------------------------------------------------
   IF lvi_count > 0 THEN
         TraceError(lcs_function_name, 'YES', lvi_key, lvi_log_count, ' ==> No Match : sc '||a_sc||', pr '||a_pr||': '||lvi_count||' prmtau don''t occur as stau');
           RETURN(UNAPIGEN.DBERR_GENFAIL);
   END IF;


   FOR lvr_au_name IN lvq_au_name LOOP          /*HVB2*/
       lvi_ret_code := UNAPIGEN.DBERR_NOOBJECT; /*HVB2*/

--HVB2 FOR lvr_au IN lvq_au1 LOOP
--HVB3      FOR lvr_au IN lvq_au1(lvr_au_name.mtau) LOOP /*HVB2*/
      FOR lvr_au IN lvq_au1(lvr_au_name.au) LOOP ---HVB3
      --------------------------------------------------------------------------------
      -- ST-value = PRMT-value
      --------------------------------------------------------------------------------
        IF lvr_au.operator = '=' THEN
           TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, ' Checking on ' || lvr_au.operator || '.');
            IF lvr_au.st_value = lvr_au.mt_value THEN
               TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, ' ==> Matched ' || lvr_au.st_value || ' (ST) ' || lvr_au.operator || ' ' || lvr_au.mt_value || ' (PRMT)');
               lvi_ret_code := UNAPIGEN.DBERR_SUCCESS;
            ELSE
               TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, ' ==> No match ' || lvr_au.st_value || ' (ST) ' || lvr_au.operator || ' ' || lvr_au.mt_value || ' (PRMT)');
--HVB2         IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
               IF lvi_ret_code = UNAPIGEN.DBERR_NOOBJECT THEN /*HVB2*/
                   lvi_ret_code := UNAPIGEN.DBERR_GENFAIL;
               END IF;
            END IF;
         END IF;
     END LOOP;
     IF lvi_ret_code = UNAPIGEN.DBERR_GENFAIL THEN    --HVB2
           TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, '==> No match'); ---HVB3
           RETURN(UNAPIGEN.DBERR_GENFAIL);            --HVB2
     END IF;                                          --HVB2
  END LOOP; /*HVB2*/


   FOR lvr_au IN lvq_au2 LOOP
       TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, ' Checking on ' || lvr_au.operator || '.');

       IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS AND lvi_ret_code != UNAPIGEN.DBERR_NOOBJECT THEN
          TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, ' ==> No match for checking on =');
          TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, '==> No match'); ---HVB3
          RETURN(UNAPIGEN.DBERR_GENFAIL);
       END IF;
       --------------------------------------------------------------------------------
       -- ST-value <> PRMT-value
       --------------------------------------------------------------------------------
       IF lvr_au.operator = '<>' THEN
            TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, ' Checking on = for ' || lvr_au.st_value || ' (ST) ' || lvr_au.operator || ' ' || lvr_au.mt_value || ' (PRMT)');
            IF lvr_au.st_value != lvr_au.mt_value THEN
             TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, ' ==> Matched ' || lvr_au.st_value || ' (ST) ' || lvr_au.operator || ' ' || lvr_au.mt_value || ' (PRMT)');
             lvi_ret_code := UNAPIGEN.DBERR_SUCCESS;
          ELSE
             TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, ' ==> No match ' || lvr_au.st_value || ' (ST) ' || lvr_au.operator || ' ' || lvr_au.mt_value || ' (PRMT)');
             TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, '==> No match'); ---HVB3
             RETURN(UNAPIGEN.DBERR_GENFAIL);
          END IF;
       --------------------------------------------------------------------------------
       -- ST-value > PRMT-value
       --------------------------------------------------------------------------------
       ELSIF lvr_au.operator = '>' THEN
          IF lvr_au.st_value > lvr_au.mt_value THEN
             TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, ' ==> Matched ' || lvr_au.st_value || ' (ST) ' || lvr_au.operator || ' ' || lvr_au.mt_value || ' (PRMT)');
             lvi_ret_code := UNAPIGEN.DBERR_SUCCESS;
          ELSE
             TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, ' ==> No match ' || lvr_au.st_value || ' (ST) ' || lvr_au.operator || ' ' || lvr_au.mt_value || ' (PRMT)');
             TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, '==> No match'); ---HVB3
             RETURN(UNAPIGEN.DBERR_GENFAIL);
          END IF;
       --------------------------------------------------------------------------------
       -- ST-value > PRMT-value
       --------------------------------------------------------------------------------
       ELSIF lvr_au.operator = '>' THEN
          IF lvr_au.st_value > lvr_au.mt_value THEN
             TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, ' ==> Matched ' || lvr_au.st_value || ' (ST) ' || lvr_au.operator || ' ' || lvr_au.mt_value || ' (PRMT)');
             lvi_ret_code := UNAPIGEN.DBERR_SUCCESS;
          ELSE
             TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, ' ==> No match ' || lvr_au.st_value || ' (ST) ' || lvr_au.operator || ' ' || lvr_au.mt_value || ' (PRMT)');
             TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, '==> No match'); ---HVB3
             RETURN(UNAPIGEN.DBERR_GENFAIL);
          END IF;
       --------------------------------------------------------------------------------
       -- ST-value >= PRMT-value
       --------------------------------------------------------------------------------
       ELSIF lvr_au.operator = '>=' THEN
          IF lvr_au.st_value >= lvr_au.mt_value THEN
             TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, ' ==> Matched ' || lvr_au.st_value || ' (ST) ' || lvr_au.operator || ' ' || lvr_au.mt_value || ' (PRMT)');
             lvi_ret_code := UNAPIGEN.DBERR_SUCCESS;
          ELSE
             TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, ' ==> No match ' || lvr_au.st_value || ' (ST) ' || lvr_au.operator || ' ' || lvr_au.mt_value || ' (PRMT)');
             TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, '==> No match'); ---HVB3
             RETURN(UNAPIGEN.DBERR_GENFAIL);
          END IF;
       --------------------------------------------------------------------------------
       -- ST-value < PRMT-value
       --------------------------------------------------------------------------------
       ELSIF lvr_au.operator = '<' THEN
          IF lvr_au.st_value < lvr_au.mt_value THEN
             TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, ' ==> Matched ' || lvr_au.st_value || ' (ST) ' || lvr_au.operator || ' ' || lvr_au.mt_value || ' (PRMT)');
             lvi_ret_code := UNAPIGEN.DBERR_SUCCESS;
          ELSE
             TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, ' ==> No match ' || lvr_au.st_value || ' (ST) ' || lvr_au.operator || ' ' || lvr_au.mt_value || ' (PRMT)');
             TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, '==> No match'); ---HVB3
             RETURN(UNAPIGEN.DBERR_GENFAIL);
          END IF;
       --------------------------------------------------------------------------------
       -- ST-value <= PRMT-value
       --------------------------------------------------------------------------------
       ELSIF lvr_au.operator = '<=' THEN
          IF lvr_au.st_value <= lvr_au.mt_value THEN
             TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, ' ==> Matched ' || lvr_au.st_value || ' (ST) ' || lvr_au.operator || ' ' || lvr_au.mt_value || ' (PRMT)');
             lvi_ret_code := UNAPIGEN.DBERR_SUCCESS;
          ELSE
             TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, ' ==> No match ' || lvr_au.st_value || ' (ST) ' || lvr_au.operator || ' ' || lvr_au.mt_value || ' (PRMT)');
             TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, '==> No match'); ---HVB3
             RETURN(UNAPIGEN.DBERR_GENFAIL);
          END IF;
       END IF;
   END LOOP;

   IF (lvi_ret_code = UNAPIGEN.DBERR_SUCCESS) THEN
        TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, '==> Match');
   ELSE
        TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, '==> No match');
   END IF;

   RETURN lvi_ret_code;

END UAbasedSt;

FUNCTION UAbasedSc                                /* INTERNAL */
--changed by HVB: replaced st_value by sc_value
--changed by HVB: replaced (ST) by (SC)
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
RETURN NUMBER IS
--------------------------------------------------------------------------------
-- Constant
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'UAbasedSc';
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvi_ret_code      NUMBER := UNAPIGEN.DBERR_NOOBJECT;
lvi_count        NUMBER;
lvi_key          VARCHAR2(80);
lvi_log_count    NUMBER:=100;
lvi_log_error    VARCHAR2(10);
--------------------------------------------------------------------------------
-- Cursors
-------------------------------------------------------------------------------
---HVB2 Define a new cursor to loop over AU's
---HVB3 Define a new fast cursor to loop over AU's
CURSOR lvq_au_name IS
SELECT DISTINCT a.au
     FROM utprmtau a, utau b
    WHERE a.mt = a_mt
      AND a.pr = a_pr
      AND a.version = a_pr_version
      AND a.mt_version = a_mt_version
      AND a.au = b.au
      AND b.version_is_current = '1'
      AND b.service = 'UAbased';

---HVB2 Define a new cursor to loop over AU's
--HVB3 CURSOR lvq_au_name IS
--HVB3 SELECT DISTINCT MTAU
--HVB3  FROM AVAO_FREQ_UABASED_SC
--HVB3 WHERE sc = a_sc
--HVB3   AND pr = a_pr AND pr_version = a_pr_version
--HVB3   AND mt = a_mt;

--HVB2 CURSOR lvq_au1 IS
CURSOR lvq_au1(lvi_au_name in varchar2) IS /*HVB2*/
SELECT *
  FROM AVAO_FREQ_UABASED_SC
 WHERE sc = a_sc
   AND pr = a_pr AND pr_version = a_pr_version
   AND mt = a_mt
   AND mtau = lvi_au_name            /* HVB2 */
   AND operator = '=';

CURSOR lvq_au2 IS
SELECT *
  FROM AVAO_FREQ_UABASED_SC
 WHERE sc = a_sc
   AND pr = a_pr AND pr_version = a_pr_version
   AND mt = a_mt
   AND operator != '=';

BEGIN
   lvi_log_error := APAOGEN.GetSystemSetting('LOG','NO');                        --HVB3
   lvi_key := ('sc=' || a_sc || ';pr=' || a_pr || ';mt=' || a_mt || ':');         --HVB3
   TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, 'a_pr_version=' || a_pr_version || ';a_mt_version=' || a_mt_version);
   --------------------------------------------------------------------------------
   -- Retrieve number of prmtau which have not been configured as scau. This
   -- is a configuration if there are any
   --------------------------------------------------------------------------------
--HVB3   SELECT COUNT(b.au)
--HVB3         INTO lvi_count
--HVB3     FROM utprmtau b, utmt c, utau d, utprmt e
--HVB3    WHERE b.mt = c.mt
--HVB3      AND b.mt = e.mt
--HVB3      AND b.version = e.version
--HVB3      AND c.mt = a_mt
--HVB3      AND a_mt_version = b.mt_version      /*HVB2*/
--HVB3      AND b.mt_version = e.mt_version      /*HVB2*/
--HVB3      AND b.au = d.au AND d.version_is_current = '1' AND service = 'UAbased'
--HVB3      AND c.version_is_current = '1'
--HVB3      AND b.au NOT IN (SELECT au
--HVB3                         FROM utscau
--HVB3                        WHERE sc = a_sc);

--HVB3 Replaced query above by the (faster and now correct) query below
   SELECT COUNT(a.au)
         INTO lvi_count
     FROM utprmtau a, utau b
    WHERE a.mt = a_mt
      AND a.pr = a_pr
      AND a.version = a_pr_version
      AND a.mt_version = a_mt_version
      AND a.au = b.au AND b.version_is_current = '1' AND b.service = 'UAbased'
      AND b.au NOT IN (SELECT au
                         FROM utscau
                        WHERE sc = a_sc);

   --------------------------------------------------------------------------------
   -- Each prmtau must be configured as stau, otherwise no assignment: configuration error
   --------------------------------------------------------------------------------
   IF lvi_count > 0 THEN
      TraceError(lcs_function_name, 'YES', lvi_key, lvi_log_count, ' ==> No Match : sc '||a_sc||', pr '||a_pr||': '||lvi_count||' prmtau don''t occur as scau');
            RETURN(UNAPIGEN.DBERR_NOOBJECT); --HVB3
--HVB3      RETURN(UNAPIGEN.DBERR_GENFAIL);
   END IF;

   --------------------------------------------------------------------------------
   -- HVB2: The algoritm has to be performed user attribute per user attribute
   --       Only the "=" sign per user attribute is an OR. The rest of the
   --       Conditions is and AND. Therefore loop over all "=" conditions
   --       If there is at least one entry and "FALSE" per user attribute, the
   --       complete assignment cannot be TRUE anymore, and "FAIL" is returned to the function
   --------------------------------------------------------------------------------
   FOR lvr_au_name IN lvq_au_name LOOP          /*HVB2*/
       lvi_ret_code := UNAPIGEN.DBERR_NOOBJECT; /*HVB2*/
--HVB2 FOR lvr_au IN lvq_au1 LOOP
--HVB3      FOR lvr_au IN lvq_au1(lvr_au_name.mtau) LOOP /*HVB2*/
      FOR lvr_au IN lvq_au1(lvr_au_name.au) LOOP --HVB3
          --------------------------------------------------------------------------------
          -- SC-value = PRMT-value
          --------------------------------------------------------------------------------
          IF lvr_au.operator = '=' THEN
             TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, ' Checking on ' || lvr_au.operator || '.');
             IF lvr_au.sc_value = lvr_au.mt_value THEN
                TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, ' ==> Matched ' || lvr_au.sc_value || ' (SC) ' || lvr_au.operator || ' ' || lvr_au.mt_value || ' (PRMT)');
                lvi_ret_code := UNAPIGEN.DBERR_SUCCESS;
             ELSE
                TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, ' ==> No match ' || lvr_au.sc_value || ' (SC) ' || lvr_au.operator || ' ' || lvr_au.mt_value || ' (PRMT)');
--HVB2             IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
                   IF lvi_ret_code = UNAPIGEN.DBERR_NOOBJECT THEN /*HVB2*/
                      lvi_ret_code := UNAPIGEN.DBERR_GENFAIL;
                   END IF;
             END IF;
          END IF;
      END LOOP;

      IF lvi_ret_code = UNAPIGEN.DBERR_GENFAIL THEN    --HVB2
             TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, '==> No match'); ---HVB3
             RETURN(UNAPIGEN.DBERR_GENFAIL);           --HVB2
      END IF;                                          --HVB2
   END LOOP;  /* HVB2 loop over AU_name*/

   FOR lvr_au IN lvq_au2 LOOP
       TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, ' Checking on ' || lvr_au.operator || '.');
---HVB3       IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS AND lvi_ret_code != UNAPIGEN.DBERR_NOOBJECT THEN
---HVB3          TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, ' ==> No match for checking on =');
---HVB3          TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, '==> No match'); ---HVB3
---HVB3          RETURN(UNAPIGEN.DBERR_GENFAIL);
---HVB3       END IF;
       --------------------------------------------------------------------------------
       -- SC-value<> PRMT-value
       --------------------------------------------------------------------------------
       IF lvr_au.operator = '<>' THEN
            TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, ' Checking on = for ' || lvr_au.sc_value || ' (SC) ' || lvr_au.operator || ' ' || lvr_au.mt_value || ' (PRMT)');
            IF lvr_au.sc_value != lvr_au.mt_value THEN
             TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, ' ==> Matched ' || lvr_au.sc_value || ' (SC) ' || lvr_au.operator || ' ' || lvr_au.mt_value || ' (PRMT)');
             lvi_ret_code := UNAPIGEN.DBERR_SUCCESS;
            ELSE
             TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, ' ==> No match ' || lvr_au.sc_value || ' (SC) ' || lvr_au.operator || ' ' || lvr_au.mt_value || ' (PRMT)');
             TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, '==> No match'); ---HVB3
             RETURN(UNAPIGEN.DBERR_GENFAIL);
            END IF;
       --------------------------------------------------------------------------------
       -- SC-value> PRMT-value
       --------------------------------------------------------------------------------
       ELSIF lvr_au.operator = '>' THEN
          IF lvr_au.sc_value > lvr_au.mt_value THEN
             TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, ' ==> Matched ' || lvr_au.sc_value || ' (SC) ' || lvr_au.operator || ' ' || lvr_au.mt_value || ' (PRMT)');
          lvi_ret_code := UNAPIGEN.DBERR_SUCCESS;
          ELSE
             TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, ' ==> No match ' || lvr_au.sc_value || ' (SC) ' || lvr_au.operator || ' ' || lvr_au.mt_value || ' (PRMT)');
             TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, '==> No match'); ---HVB3
             RETURN(UNAPIGEN.DBERR_GENFAIL);
          END IF;
       --------------------------------------------------------------------------------
       -- SC-value> PRMT-value
       --------------------------------------------------------------------------------
       ELSIF lvr_au.operator = '>' THEN
          IF lvr_au.sc_value > lvr_au.mt_value THEN
             TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, ' ==> Matched ' || lvr_au.sc_value || ' (SC) ' || lvr_au.operator || ' ' || lvr_au.mt_value || ' (PRMT)');
             lvi_ret_code := UNAPIGEN.DBERR_SUCCESS;
          ELSE
             TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, ' ==> No match ' || lvr_au.sc_value || ' (SC) ' || lvr_au.operator || ' ' || lvr_au.mt_value || ' (PRMT)');
             TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, '==> No match'); ---HVB3
             RETURN(UNAPIGEN.DBERR_GENFAIL);
          END IF;
       --------------------------------------------------------------------------------
       -- SC-value>= PRMT-value
       --------------------------------------------------------------------------------
       ELSIF lvr_au.operator = '>=' THEN
          IF lvr_au.sc_value >= lvr_au.mt_value THEN
             TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, ' ==> Matched ' || lvr_au.sc_value || ' (SC) ' || lvr_au.operator || ' ' || lvr_au.mt_value || ' (PRMT)');
             lvi_ret_code := UNAPIGEN.DBERR_SUCCESS;
          ELSE
             TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, ' ==> No match ' || lvr_au.sc_value || ' (SC) ' || lvr_au.operator || ' ' || lvr_au.mt_value || ' (PRMT)');
             TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, '==> No match'); ---HVB3
             RETURN(UNAPIGEN.DBERR_GENFAIL);
          END IF;
       --------------------------------------------------------------------------------
       -- SC-value< PRMT-value
       --------------------------------------------------------------------------------
       ELSIF lvr_au.operator = '<' THEN
          IF lvr_au.sc_value < lvr_au.mt_value THEN
             TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, ' ==> Matched ' || lvr_au.sc_value || ' (SC) ' || lvr_au.operator || ' ' || lvr_au.mt_value || ' (PRMT)');
             lvi_ret_code := UNAPIGEN.DBERR_SUCCESS;
          ELSE
             TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, ' ==> No match ' || lvr_au.sc_value || ' (SC) ' || lvr_au.operator || ' ' || lvr_au.mt_value || ' (PRMT)');
             TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, '==> No match'); ---HVB3
             RETURN(UNAPIGEN.DBERR_GENFAIL);
          END IF;
       --------------------------------------------------------------------------------
       -- SC-value<= PRMT-value
       --------------------------------------------------------------------------------
       ELSIF lvr_au.operator = '<=' THEN
          IF lvr_au.sc_value <= lvr_au.mt_value THEN
             TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, ' ==> Matched ' || lvr_au.sc_value || ' (SC) ' || lvr_au.operator || ' ' || lvr_au.mt_value || ' (PRMT)');
             lvi_ret_code := UNAPIGEN.DBERR_SUCCESS;
          ELSE
             TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, ' ==> No match ' || lvr_au.sc_value || ' (SC) ' || lvr_au.operator || ' ' || lvr_au.mt_value || ' (PRMT)');
             TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, '==> No match'); ---HVB3
             RETURN(UNAPIGEN.DBERR_GENFAIL);
          END IF;
       END IF;
   END LOOP;

   IF (lvi_ret_code = UNAPIGEN.DBERR_SUCCESS) THEN
        TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, '==> Match');
   ELSE
        TraceError(lcs_function_name, lvi_log_error, lvi_key, lvi_log_count, '==> No match');
   END IF;

   RETURN lvi_ret_code;

END UAbasedSc;

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
RETURN NUMBER IS

CURSOR lvq_verifyifmepresentinsc IS
   --canceled methods are ignored
   SELECT COUNT(*)
     FROM utscme
    WHERE sc = avs_sc
      AND me = avs_mt
      AND NVL(ss, '@~') <> '@C';

lvi_count_me          INTEGER;
lvi_count_gk_context  INTEGER;

BEGIN
    OPEN lvq_verifyifmepresentinsc;
   FETCH lvq_verifyifmepresentinsc
    INTO lvi_count_me;
   CLOSE lvq_verifyifmepresentinsc;

  SELECT COUNT(*)
    INTO lvi_count_gk_context
    FROM utstgkcontext
   WHERE st = avs_st AND version = avs_st_version
     AND context = 'Trials';


   IF lvi_count_me > 0 OR lvi_count_gk_context = 0 THEN
      --already present => may not be assigned => return UNAPIGEN.DBERR_GENFAIL
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   ELSE
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;

END OncePerSampleTrials;

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
RETURN NUMBER IS
--------------------------------------------------------------------------------
-- Constant
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ScPgInterspec';
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvi_ret_code     NUMBER := UNAPIGEN.DBERR_NOOBJECT;
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------
BEGIN

   RETURN lvi_ret_code;

END ScPgInterspec;

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
RETURN NUMBER IS
--------------------------------------------------------------------------------
-- Constant
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ScPaInterspec';
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvi_ret_code     NUMBER := UNAPIGEN.DBERR_NOOBJECT;
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------
BEGIN

   RETURN lvi_ret_code;

END ScPaInterspec;

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
RETURN NUMBER IS
--------------------------------------------------------------------------------
-- Constant
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'WsCreate';
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvi_ret_code     NUMBER := UNAPIGEN.DBERR_NOOBJECT;
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------
CURSOR lvq_ws IS
 SELECT b.testsetsize, c.requestcode, d.subprogramid
   FROM utwssc a ,
        utwsgktestsetsize b,
        utwsgkrequestcode c,
        utwsgksubprogramid d
  WHERE a.sc = a_sc
    AND a.ws = b.ws
    AND a.ws = c.ws
    AND a.ws = d.ws;

CURSOR lvq_avmethod (avs_rq            IN VARCHAR2,
                     avs_subprogramid  IN VARCHAR2) IS
 SELECT e.mt
   FROM utwsgkrequestcode a,
        utwsgksubprogramid b,
        utwssc c,
        utscpa d,
        utprmt e
  WHERE a.ws = b.ws
    AND a.requestcode = avs_rq
    AND b.subprogramid = avs_subprogramid
    AND a.ws = c.ws
    AND c.sc = d.sc
    AND d.pa = e.pr AND d.pr_version = e.version
    AND e.mt = a_mt;

BEGIN

   FOR lvr_ws IN lvq_ws LOOP
      --------------------------------------------------------------------------------
      -- Is the last digit of the method to assign <= testsetsize ?
      --------------------------------------------------------------------------------
      IF TO_NUMBER(SUBSTR(a_mt, -1)) <= TO_NUMBER(lvr_ws.testsetsize) THEN
         FOR lvr_avmethod in lvq_avmethod(lvr_ws.requestcode, lvr_ws.subprogramid) LOOP
           RETURN UNAPIGEN.DBERR_SUCCESS;
         END LOOP;
      END IF;
   END LOOP;

   RETURN lvi_ret_code;

END WsCreate;

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
RETURN NUMBER IS
--------------------------------------------------------------------------------
-- Constant
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'WsCreateInSubProgram';
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvi_ret_code     NUMBER := UNAPIGEN.DBERR_NOOBJECT;
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------
CURSOR lvq_ws IS
 SELECT b.testsetsize, c.requestcode, d.subprogramid
   FROM utwssc a ,
        utwsgktestsetsize b,
        utwsgkrequestcode c,
        utwsgksubprogramid d
  WHERE a.sc = a_sc
    AND a.ws = b.ws
    AND a.ws = c.ws
    AND a.ws = d.ws;

CURSOR lvq_avmethod (avs_rq            IN VARCHAR2,
                     avs_subprogramid  IN VARCHAR2) IS
 SELECT e.mt
   FROM utwsgkrequestcode a,
        utwsgksubprogramid b,
        utwssc c,
        utscpa d,
        utprmt e
  WHERE a.ws = b.ws
    AND a.requestcode = avs_rq
    AND b.subprogramid = avs_subprogramid
    AND a.ws = c.ws
    AND c.sc = d.sc
    AND d.pa = e.pr AND d.pr_version = e.version
    AND e.mt = a_mt;

BEGIN

   FOR lvr_ws IN lvq_ws LOOP
      --------------------------------------------------------------------------------
      -- Is the last digit of the method to assign <= testsetsize ?
      --------------------------------------------------------------------------------
      IF TO_NUMBER(SUBSTR(a_mt, -1)) <= TO_NUMBER(lvr_ws.testsetsize) THEN
         FOR lvr_avmethod in lvq_avmethod(lvr_ws.requestcode, lvr_ws.subprogramid) LOOP
           RETURN UNAPIGEN.DBERR_SUCCESS;
         END LOOP;
      END IF;
   END LOOP;

   RETURN lvi_ret_code;

END WsCreateInSubProgram;

FUNCTION GetVersion
  RETURN VARCHAR2
IS
BEGIN
  RETURN('06.07.00.00_13.00');
EXCEPTION
  WHEN OTHERS THEN
	 RETURN (NULL);
END GetVersion;


END UNFREQ;
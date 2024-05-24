create or replace PACKAGE BODY
-- SIMATIC IT UNILAB package
-- $Revision: 6.3.0 $
-- $Date: 2007-02-22T14:44:00 $
unalarm AS

-- The general rules for cf_type in utcf can be found in the document: customizing the system
-- Minimal information can also be found in the header of the unaction package
--

l_sql_string    VARCHAR2(2000);
l_result        NUMBER;

FUNCTION EvalAlarm
(a_sc               IN    VARCHAR2,                 /* VC20_TYPE */
 a_pg               IN    VARCHAR2,                 /* VC20_TYPE */
 a_pgnode           IN    NUMBER,                   /* LONG_TYPE */
 a_pa               IN    VARCHAR2,                 /* VC20_TYPE */
 a_panode           IN    NUMBER,                   /* LONG_TYPE */
 a_valid_specsa     IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_specsb     IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_specsc     IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_limitsa    IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_limitsb    IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_limitsc    IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_targeta    IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_targetb    IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_targetc    IN    CHAR)                     /* CHAR1_TYPE */
RETURN NUMBER IS
BEGIN

   RETURN(UNAPIGEN.DBERR_SUCCESS);

END EvalAlarm;

FUNCTION AddMicroPP
(a_sc               IN    VARCHAR2,                 /* VC20_TYPE */
 a_pg               IN    VARCHAR2,                 /* VC20_TYPE */
 a_pgnode           IN    NUMBER,                   /* LONG_TYPE */
 a_pa               IN    VARCHAR2,                 /* VC20_TYPE */
 a_panode           IN    NUMBER,                   /* LONG_TYPE */
 a_valid_specsa     IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_specsb     IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_specsc     IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_limitsa    IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_limitsb    IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_limitsc    IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_targeta    IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_targetb    IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_targetc    IN    CHAR)                     /* CHAR1_TYPE */
RETURN NUMBER IS

-- Add the parametergroep 'micro'

l_sqlerrm               INTEGER;
l_ret_code              INTEGER;
l_st                          VARCHAR2(20);
l_st_version                  VARCHAR2(20);
a_st                          VARCHAR2(20);
a_st_version                  VARCHAR2(20);
a_pp                          VARCHAR2(20);
a_pp_version                  VARCHAR2(20);
l_pp_key1                     VARCHAR2(20);
l_pp_key2                     VARCHAR2(20);
l_pp_key3                     VARCHAR2(20);
l_pp_key4                     VARCHAR2(20);
l_pp_key5                     VARCHAR2(20);
a_seq                         NUMBER;
a_filter_freq                 CHAR(1);
a_ref_date                    TIMESTAMP WITH TIME ZONE;
a_modify_reason               VARCHAR2(255);

BEGIN

SELECT st, st_version
INTO l_st, l_st_version
FROM utsc
WHERE sc = a_sc;

SELECT seq, pp_version, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5
INTO a_seq, a_pp_version, l_pp_key1, l_pp_key2, l_pp_key3, l_pp_key4, l_pp_key5
FROM utstpp
WHERE st = l_st
AND version = l_st_version
AND pp = 'micro'
ORDER BY seq;

a_st := l_st;
a_st_version := l_st_version;
a_pp := 'micro';
a_modify_reason := 'DB API example';

l_ret_code := UNAPISC.AddScAnalysesDetails
                (a_sc,
                 a_st,
                 a_st_version,
                 a_pp,
                 a_pp_version,
                 l_pp_key1,
                 l_pp_key2,
                 l_pp_key3,
                 l_pp_key4,
                 l_pp_key5,
                 a_seq,
                 a_modify_reason);

IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
   INSERT INTO uterror(client_id, applic, who, logdate, logdate_tz, api_name, error_msg)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
          'UNALARM.AddMicroPP','ADDSCANALYSESDETAILS returned#'|| l_ret_code||'#for#sc'||a_sc||'#pp#'||a_pp);
        UNAPIGEN.U4COMMIT;
ELSE
  RETURN(UNAPIGEN.DBERR_SUCCESS);
END IF;

RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   l_sqlerrm := SUBSTR(SQLERRM, 1, 255);
   INSERT INTO uterror(client_id, applic, who, logdate, logdate_tz, api_name, error_msg)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
          'UNALARM.AddMicroPP',  l_sqlerrm);
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END AddMicroPP;

FUNCTION AddExtraParameters
(a_sc               IN    VARCHAR2,                 /* VC20_TYPE */
 a_pg               IN    VARCHAR2,                 /* VC20_TYPE */
 a_pgnode           IN    NUMBER,                   /* LONG_TYPE */
 a_pa               IN    VARCHAR2,                 /* VC20_TYPE */
 a_panode           IN    NUMBER,                   /* LONG_TYPE */
 a_valid_specsa     IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_specsb     IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_specsc     IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_limitsa    IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_limitsb    IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_limitsc    IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_targeta    IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_targetb    IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_targetc    IN    CHAR)                     /* CHAR1_TYPE */
RETURN NUMBER IS

-- If the parameter result is out of spec, add all extra parameters
-- as defined in the attribute 'alarm_pa' values assigned to the pr

l_sqlerrm               INTEGER;
l_ret_code              INTEGER;
l_st           VARCHAR2(20);
l_st_version   VARCHAR2(20);
l_pr_version   VARCHAR2(20);
a_pr_seq                NUMBER;

CURSOR l_pa_cursor IS
   SELECT pr_version
   FROM utscpa
   WHERE sc = a_sc
     AND pg = a_pg
     AND pgnode = a_pgnode
     AND pa = a_pa
     AND panode = a_panode;

CURSOR l_extra_pr_cursor IS
   SELECT value
   FROM utprau
   WHERE pr = a_pa
     AND version = l_pr_version
     AND au = 'alarm_pr'
   ORDER BY auseq;
l_extra_pr_rec  l_extra_pr_cursor%ROWTYPE;

BEGIN

SELECT st, st_version
INTO l_st, l_st_version
FROM utsc
WHERE sc = a_sc;

OPEN l_pa_cursor;
FETCH l_pa_cursor INTO l_pr_version;
IF l_pa_cursor%NOTFOUND THEN
   CLOSE l_pa_cursor;
   RETURN(UNAPIGEN.DBERR_NOOBJECT);
END IF;
CLOSE l_pa_cursor;

FOR l_extra_pr_rec IN l_extra_pr_cursor LOOP

   l_ret_code := UNAPIPG.AddScPgDetails
                   (a_sc, l_st, l_st_version, a_pg, a_pgnode,
                    l_extra_pr_rec.value, NULL,
                    a_pr_seq, 'Out-of-spec of '||a_pa);
   IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
      RETURN(l_ret_code);
   END IF;

END LOOP;

RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   l_sqlerrm := SUBSTR(SQLERRM, 1, 255);
   INSERT INTO uterror(client_id, applic, who, logdate, logdate_tz, api_name, error_msg)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
          'UNALARM.AddExtraParameters', l_sqlerrm);
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END AddExtraParameters;



FUNCTION AddOtherParameters
(a_sc               IN    VARCHAR2,                 /* VC20_TYPE */
 a_pg               IN    VARCHAR2,                 /* VC20_TYPE */
 a_pgnode           IN    NUMBER,                   /* LONG_TYPE */
 a_pa               IN    VARCHAR2,                 /* VC20_TYPE */
 a_panode           IN    NUMBER,                   /* LONG_TYPE */
 a_valid_specsa     IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_specsb     IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_specsc     IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_limitsa    IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_limitsb    IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_limitsc    IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_targeta    IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_targetb    IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_targetc    IN    CHAR)                     /* CHAR1_TYPE */
RETURN NUMBER IS

--Add the other pa's which had freq =Never

l_sqlerrm               INTEGER;
l_ret_code              INTEGER;
l_st                    VARCHAR2(20);
l_st_version            VARCHAR2(20);
l_pp_version            VARCHAR2(20);
l_pp_key1               VARCHAR2(20);
l_pp_key2               VARCHAR2(20);
l_pp_key3               VARCHAR2(20);
l_pp_key4               VARCHAR2(20);
l_pp_key5               VARCHAR2(20);
a_pr_seq                NUMBER;

CURSOR l_pg_cursor IS
   SELECT pp_version, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5
   FROM utscpg
   WHERE sc = a_sc
     AND pg = a_pg
     AND pgnode = a_pgnode;

CURSOR l_extra_pr_cursor IS
   SELECT pr
   FROM utpppr
   WHERE pp = a_pg
     AND version = l_pp_version
     AND pp_key1 = l_pp_key1
     AND pp_key2 = l_pp_key2
     AND pp_key3 = l_pp_key3
     AND pp_key4 = l_pp_key4
     AND pp_key5 = l_pp_key5
     AND freq_tp='N';

l_extra_pr_rec  l_extra_pr_cursor%ROWTYPE;

BEGIN

SELECT st, st_version
INTO l_st, l_st_version
FROM utsc
WHERE sc = a_sc;

OPEN l_pg_cursor;
FETCH l_pg_cursor INTO l_pp_version, l_pp_key1, l_pp_key2, l_pp_key3, l_pp_key4, l_pp_key5;
IF l_pg_cursor%NOTFOUND THEN
   CLOSE l_pg_cursor;
   RETURN(UNAPIGEN.DBERR_NOOBJECT);
END IF;
CLOSE l_pg_cursor;

FOR l_extra_pr_rec IN l_extra_pr_cursor LOOP

   l_ret_code := UNAPIPG.AddScPgDetails
                   (a_sc, l_st, l_st_version, a_pg, a_pgnode,
                    l_extra_pr_rec.pr, NULL, a_pr_seq,
                    'Extra Parameter');
   IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
      RETURN(l_ret_code);
   END IF;

END LOOP;

RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   l_sqlerrm := SUBSTR(SQLERRM, 1, 255);
   INSERT INTO uterror(client_id, applic, who, logdate, logdate_tz, api_name, error_msg)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
          'UNALARM.AddOtherParameters', l_sqlerrm);
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END AddOtherParameters;

FUNCTION GetVersion
  RETURN VARCHAR2
IS
BEGIN
  RETURN('06.07.00.00_13.00');
EXCEPTION
  WHEN OTHERS THEN
	 RETURN (NULL);
END GetVersion;

END unalarm;
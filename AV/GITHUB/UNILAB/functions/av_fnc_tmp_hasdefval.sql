--------------------------------------------------------
--  File created - dinsdag-oktober-27-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Function TMP_HASDEFVAL
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UNILAB"."TMP_HASDEFVAL" (
    a_tp         IN VARCHAR2,
    a_st         IN VARCHAR2,
    a_st_version IN VARCHAR2,
    a_pp         IN VARCHAR2,
    a_pp_version IN VARCHAR2,
    a_pp_key1    IN VARCHAR2,
    a_pp_key2    IN VARCHAR2,
    a_pp_key3    IN VARCHAR2,
    a_pp_key4    IN VARCHAR2,
    a_pp_key5    IN VARCHAR2,
    a_pr         IN VARCHAR2,
    a_pr_version IN VARCHAR2,
    a_mt         IN VARCHAR2,
    a_mt_version IN VARCHAR2
) RETURN NUMBER IS
    l_tmp NUMBER;
BEGIN
    CASE a_tp
        WHEN 'st' THEN
            SELECT COUNT(*) INTO l_tmp FROM utstau WHERE st = a_st AND version = a_st_version;
        WHEN 'pr' THEN
            SELECT COUNT(*) INTO l_tmp FROM utprau WHERE pr = a_pr AND version = a_pr_version;
        WHEN 'mt' THEN
            SELECT COUNT(*) INTO l_tmp FROM utmtau WHERE mt = a_mt AND version = a_mt_version;
        ELSE l_tmp := 1;
    END CASE;
    IF l_tmp > 0 THEN l_tmp := 1; END IF;
    RETURN l_tmp;
END;

/

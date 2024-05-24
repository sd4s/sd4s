create or replace PACKAGE BODY
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
pbapipp AS

l_ret_code NUMBER;

FUNCTION GetVersion
   RETURN VARCHAR2
IS
BEGIN
   RETURN('06.07.00.00_00.13');
EXCEPTION
   WHEN OTHERS THEN
      RETURN (NULL);
END GetVersion;

FUNCTION GetPpParameterSpecs
(a_pp           OUT     UNAPIGEN.VC20_TABLE_TYPE,
 a_pr           OUT     UNAPIGEN.VC20_TABLE_TYPE,
 a_low_limit    OUT     UNAPIGEN.FLOAT_TABLE_TYPE,
 a_high_limit   OUT     UNAPIGEN.FLOAT_TABLE_TYPE,
 a_low_spec     OUT     UNAPIGEN.FLOAT_TABLE_TYPE,
 a_high_spec    OUT     UNAPIGEN.FLOAT_TABLE_TYPE,
 a_low_dev      OUT     UNAPIGEN.FLOAT_TABLE_TYPE,
 a_rel_low_dev  OUT     PBAPIGEN.VC1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_target       OUT     UNAPIGEN.FLOAT_TABLE_TYPE,
 a_high_dev     OUT     UNAPIGEN.FLOAT_TABLE_TYPE,
 a_rel_high_dev OUT     PBAPIGEN.VC1_TABLE_TYPE,/* CHAR1_TABLE_TYPE */
 a_spec_set     IN      CHAR,
 a_nr_of_rows   IN OUT NUMBER,
 a_where_clause IN     VARCHAR2)
RETURN NUMBER IS

l_row               NUMBER;
l_rel_low_dev       UNAPIGEN.CHAR1_TABLE_TYPE ;
l_rel_high_dev      UNAPIGEN.CHAR1_TABLE_TYPE ;
a_version           UNAPIGEN.VC20_TABLE_TYPE;
a_pr_version        UNAPIGEN.VC20_TABLE_TYPE;
a_pp_key1           UNAPIGEN.VC20_TABLE_TYPE;
a_pp_key2           UNAPIGEN.VC20_TABLE_TYPE;
a_pp_key3           UNAPIGEN.VC20_TABLE_TYPE;
a_pp_key4           UNAPIGEN.VC20_TABLE_TYPE;
a_pp_key5           UNAPIGEN.VC20_TABLE_TYPE;

BEGIN
l_ret_code := UNAPIPP.GETPPPARAMETERSPECS
                (a_pp,
                 a_version,
                 a_pp_key1,
                 a_pp_key2,
                 a_pp_key3,
                 a_pp_key4,
                 a_pp_key5,
                 a_pr,
                 a_pr_version,
                 a_low_limit,
                 a_high_limit,
                 a_low_spec,
                 a_high_spec,
                 a_low_dev,
                 l_rel_low_dev,
                 a_target,
                 a_high_dev,
                 l_rel_high_dev,
                 a_spec_set,
                 a_nr_of_rows,
                 a_where_clause);

IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
 FOR l_row IN 1..a_nr_of_rows LOOP
  a_rel_low_dev(l_row)  := l_rel_low_dev(l_row);
  a_rel_high_dev(l_row) := l_rel_high_dev(l_row);
    END LOOP ;
END IF ;
RETURN (l_ret_code);
END GetPpParameterSpecs ;

FUNCTION GetParameterProfileList
(a_pp                      OUT     UNAPIGEN.VC20_TABLE_TYPE,
 a_version                 OUT     UNAPIGEN.VC20_TABLE_TYPE,
 a_pp_key1                 OUT     UNAPIGEN.VC20_TABLE_TYPE,
 a_pp_key2                 OUT     UNAPIGEN.VC20_TABLE_TYPE,
 a_pp_key3                 OUT     UNAPIGEN.VC20_TABLE_TYPE,
 a_pp_key4                 OUT     UNAPIGEN.VC20_TABLE_TYPE,
 a_pp_key5                 OUT     UNAPIGEN.VC20_TABLE_TYPE,
 a_description             OUT     UNAPIGEN.VC40_TABLE_TYPE,
 a_ss                      OUT     UNAPIGEN.VC2_TABLE_TYPE,
 a_nr_of_rows              IN OUT  NUMBER,
 a_where_clause            IN      VARCHAR2,
 a_next_rows               IN      NUMBER)
RETURN NUMBER IS
l_row               NUMBER;
l_version_is_current       UNAPIGEN.CHAR1_TABLE_TYPE ;
l_effective_from        UNAPIGEN.DATE_TABLE_TYPE;
l_effective_till        UNAPIGEN.DATE_TABLE_TYPE;

BEGIN
l_ret_code := UNAPIPP.GetParameterProfileList
                (a_pp                  ,
                 a_version             ,
                 a_pp_key1             ,
                 a_pp_key2             ,
                 a_pp_key3             ,
                 a_pp_key4             ,
                 a_pp_key5             ,
                 l_version_is_current  ,
                 l_effective_from      ,
                 l_effective_till      ,
                 a_description         ,
                 a_ss                  ,
                 a_nr_of_rows          ,
                 a_where_clause        ,
                 a_next_rows);

RETURN (l_ret_code);
END GetParameterProfileList ;

END pbapipp ;
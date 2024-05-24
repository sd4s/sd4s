create or replace PACKAGE BODY
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
pbapimt AS

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

FUNCTION GetMethodList
(a_mt                      OUT      UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_version                 OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_version_is_current      OUT      PBAPIGEN.VC1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_effective_from          OUT      UNAPIGEN.DATE_TABLE_TYPE,   /* DATE_TABLE_TYPE */
 a_effective_till          OUT      UNAPIGEN.DATE_TABLE_TYPE,   /* DATE_TABLE_TYPE */
 a_description             OUT      UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_ss                      OUT      UNAPIGEN.VC2_TABLE_TYPE,  /* VC2_TABLE_TYPE */
 a_nr_of_rows              IN OUT   NUMBER,                   /* NUM_TYPE */
 a_where_clause            IN       VARCHAR2,                 /* VC511_TYPE */
 a_next_rows               IN       NUMBER)                   /* NUM_TYPE */
RETURN NUMBER IS


l_version_is_current  UNAPIGEN.CHAR1_TABLE_TYPE  ;

BEGIN

l_ret_code := UNAPIMT.GetMethodList
                (a_mt,
                 a_version,
                 l_version_is_current ,
      a_effective_from,
      a_effective_till,
      a_description ,
      a_ss,
      a_nr_of_rows ,
      a_where_clause ,
      a_next_rows
      );

IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
 FOR l_row IN 1..a_nr_of_rows LOOP
  a_version_is_current(l_row)  := l_version_is_current(l_row);
 END LOOP ;
END IF ;
RETURN (l_ret_code);
END GetMethodList;

END pbapimt ;
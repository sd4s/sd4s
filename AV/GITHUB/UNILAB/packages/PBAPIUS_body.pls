create or replace PACKAGE BODY
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
pbapius AS

l_ret_code        NUMBER;
StpError          EXCEPTION;

FUNCTION GetVersion
   RETURN VARCHAR2
IS
BEGIN
   RETURN('06.07.00.00_00.13');
EXCEPTION
   WHEN OTHERS THEN
      RETURN (NULL);
END GetVersion;

FUNCTION GetUpUsExperienceLevel
(a_up                             OUT      UNAPIGEN.LONG_TABLE_TYPE,   /* LONG_TABLE_TYPE */
 a_us                             OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_el                             OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_is_enabled                     OUT      PBAPIGEN.VC1_TABLE_TYPE,    /* VC1_TABLE_TYPE */
 a_nr_of_rows                     IN OUT   NUMBER,                     /* NUM_TYPE         */
 a_where_clause                   IN       VARCHAR2)                   /* VC511_TYPE */
RETURN NUMBER IS
l_row               NUMBER;
l_is_enabled        UNAPIGEN.CHAR1_TABLE_TYPE;

BEGIN
   l_ret_code := UNAPIUS.GetUpUsExperienceLevel
                          (a_up  ,
                           a_us ,
                           a_el  ,
                           l_is_enabled ,
                           a_nr_of_rows ,
                           a_where_clause );
   IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
      FOR l_row IN 1..a_nr_of_rows LOOP
         a_is_enabled(l_row) := l_is_enabled(l_row);
      END LOOP;
   END IF;
   RETURN (l_ret_code);
END GetUpUsExperienceLevel;

FUNCTION SaveUpUsExperienceLevel
(a_up                      IN       NUMBER,                      /* LONG_TYPE        */
 a_us                      IN       VARCHAR2,                    /* VC20_TYPE        */
 a_el                      IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_is_enabled              IN       PBAPIGEN.VC1_TABLE_TYPE,     /* VC1_TABLE_TYPE */
 a_nr_of_rows              IN       NUMBER,                      /* NUM_TYPE         */
 a_modify_reason           IN       VARCHAR2)                    /* VC255_TYPE       */
RETURN NUMBER IS
l_row               NUMBER;
l_is_enabled        UNAPIGEN.CHAR1_TABLE_TYPE;

BEGIN
   FOR l_row IN 1..a_nr_of_rows LOOP
      l_is_enabled(l_row) := a_is_enabled(l_row);
   END LOOP;

   l_ret_code := UNAPIUS.SaveUpUsExperienceLevel
                          (a_up  ,
                           a_us ,
                           a_el  ,
                           l_is_enabled ,
                           a_nr_of_rows ,
                           a_modify_reason );

   RETURN (l_ret_code);

END SaveUpUsExperienceLevel;


END pbapius;
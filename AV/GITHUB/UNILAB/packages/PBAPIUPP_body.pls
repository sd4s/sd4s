create or replace PACKAGE BODY
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
pbapiupp AS

l_ret_code  NUMBER;

FUNCTION GetVersion
   RETURN VARCHAR2
IS
BEGIN
   RETURN('06.07.00.00_00.13');
EXCEPTION
   WHEN OTHERS THEN
      RETURN (NULL);
END GetVersion;

FUNCTION GetQualification                              /* INTERNAL */
(a_qualification    OUT    UNAPIGEN.VC1_TABLE_TYPE,    /* VC1_TABLE_TYPE */
 a_description      OUT    UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_nr_of_rows       IN OUT NUMBER,                     /* NUM_TYPE */
 a_where_clause     IN     VARCHAR2)                   /* VC511_TYPE */
RETURN NUMBER IS

l_qualification      UNAPIGEN.CHAR1_TABLE_TYPE;

BEGIN
l_ret_code := UNAPIUPP.GetQualification
(l_qualification,
 a_description,
 a_nr_of_rows,
 a_where_clause);

IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
   FOR l_row IN 1..a_nr_of_rows LOOP
      a_qualification   (l_row)   := l_qualification   (l_row);
   END LOOP ;
END IF ;
RETURN (l_ret_code);
END GetQualification;


FUNCTION GetFuncAccess
(a_applic               OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_description          OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_topic                OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_topic_description    OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_fa                   OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_nr_of_rows           IN OUT NUMBER,                   /* NUM_TYPE */
 a_where_clause         IN     VARCHAR2)                 /* VC511_TYPE */
RETURN NUMBER IS
l_fa      UNAPIGEN.CHAR1_TABLE_TYPE;
BEGIN
l_ret_code := UNAPIUPP.GetFuncAccess
(a_applic ,
 a_description ,
 a_topic      ,
 a_topic_description ,
 l_fa       ,
 a_nr_of_rows  ,
 a_where_clause );

IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
   FOR l_row IN 1..a_nr_of_rows LOOP
      a_fa (l_row)   := l_fa  (l_row);
   END LOOP ;
END IF ;

RETURN (l_ret_code);
END GetFuncAccess;

FUNCTION GetUpFuncList
(a_up_in                      IN     NUMBER,                   /* LONG_TYPE */
 a_up                         OUT    UNAPIGEN.LONG_TABLE_TYPE, /* LONG_TABLE_TYPE */
 a_applic                     OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_description                OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_fa                         OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_inherit_fa                 OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_nr_of_rows                 IN OUT NUMBER)                   /* NUM_TYPE */
RETURN NUMBER IS
l_fa      UNAPIGEN.CHAR1_TABLE_TYPE;
l_inherit_fa      UNAPIGEN.CHAR1_TABLE_TYPE;
BEGIN
l_ret_code := UNAPIUPP.GetUpFuncList
(a_up_in  ,
 a_up     ,
 a_applic  ,
 a_description  ,
 l_fa           ,
 l_inherit_fa    ,
 a_nr_of_rows );

IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
   FOR l_row IN 1..a_nr_of_rows LOOP
      a_fa (l_row)   := l_fa  (l_row);
      a_inherit_fa (l_row)   := l_inherit_fa  (l_row);
   END LOOP ;
END IF ;
RETURN (l_ret_code);
END GetUpFuncList;

FUNCTION GetUpFuncDetails
(a_up_in                   IN     NUMBER,                   /* LONG_TYPE */
 a_applic_in               IN     VARCHAR2,                 /* VC20_TYPE */
 a_up                      OUT    UNAPIGEN.LONG_TABLE_TYPE, /* LONG_TABLE_TYPE */
 a_applic                  OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_description             OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_topic                   OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_topic_description       OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_fa                      OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_inherit_fa              OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_nr_of_rows              IN OUT NUMBER)                   /* NUM_TYPE */
RETURN NUMBER IS
l_fa              UNAPIGEN.CHAR1_TABLE_TYPE;
l_inherit_fa      UNAPIGEN.CHAR1_TABLE_TYPE;
BEGIN

l_ret_code := UNAPIUPP.GetUpFuncDetails
(a_up_in ,
 a_applic_in ,
 a_up        ,
 a_applic      ,
 a_description   ,
 a_topic         ,
 a_topic_description ,
 l_fa         ,
 l_inherit_fa  ,
 a_nr_of_rows);

IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
   FOR l_row IN 1..a_nr_of_rows LOOP
      a_fa (l_row)   := l_fa  (l_row);
      a_inherit_fa (l_row)   := l_inherit_fa  (l_row);
   END LOOP ;
END IF ;

RETURN (l_ret_code);
END GetUpFuncDetails;

FUNCTION GetUpUsFuncList
(a_up_in                   IN     NUMBER,                   /* LONG_TYPE */
 a_us_in                   IN     VARCHAR2,                 /* VC20_TYPE */
 a_up                      OUT    UNAPIGEN.LONG_TABLE_TYPE, /* LONG_TABLE_TYPE */
 a_us                      OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_applic                  OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_description             OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_fa                      OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_inherit_fa              OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_nr_of_rows              IN OUT NUMBER)                   /* NUM_TYPE */
RETURN NUMBER IS

l_fa      UNAPIGEN.CHAR1_TABLE_TYPE;
l_inherit_fa      UNAPIGEN.CHAR1_TABLE_TYPE;

BEGIN

l_ret_code := UNAPIUPP.GetUpUsFuncList
(a_up_in ,
 a_us_in,
 a_up   ,
 a_us   ,
 a_applic ,
 a_description ,
l_fa         ,
l_inherit_fa  ,
a_nr_of_rows);

 IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
    FOR l_row IN 1..a_nr_of_rows LOOP
       a_fa (l_row)   := l_fa  (l_row);
       a_inherit_fa (l_row)   := l_inherit_fa  (l_row);
    END LOOP ;
 END IF ;
RETURN (l_ret_code);
END GetUpUsFuncList;

FUNCTION GetUpUsFuncDetails
(a_up_in                      IN     NUMBER,                   /* LONG_TYPE */
 a_us_in                      IN     VARCHAR2,                 /* VC20_TYPE */
 a_applic_in                  IN     VARCHAR2,                 /* VC20_TYPE */
 a_up                         OUT    UNAPIGEN.LONG_TABLE_TYPE, /* LONG_TABLE_TYPE */
 a_us                         OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_applic                     OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_description                OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_topic                      OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_topic_description          OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_fa                         OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_inherit_fa                 OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_nr_of_rows                 IN OUT NUMBER)                   /* NUM_TYPE */
RETURN NUMBER IS

l_fa      UNAPIGEN.CHAR1_TABLE_TYPE;
l_inherit_fa      UNAPIGEN.CHAR1_TABLE_TYPE;

BEGIN

l_ret_code := UNAPIUPP.GetUpUsFuncDetails
(a_up_in             ,
 a_us_in             ,
 a_applic_in         ,
 a_up                ,
 a_us                ,
 a_applic            ,
 a_description       ,
 a_topic             ,
 a_topic_description   ,
 l_fa         ,
 l_inherit_fa  ,
 a_nr_of_rows);

  IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
     FOR l_row IN 1..a_nr_of_rows LOOP
        a_fa (l_row)   := l_fa  (l_row);
        a_inherit_fa (l_row)   := l_inherit_fa  (l_row);
     END LOOP ;
  END IF ;

RETURN (l_ret_code);
END GetUpUsFuncDetails;

FUNCTION SaveUpFuncList
(a_up                      IN     NUMBER,                   /* LONG_TYPE */
 a_applic                  IN     UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_fa                      IN     UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_inherit_fa              IN     UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_nr_of_rows              IN OUT NUMBER,                   /* NUM_TYPE */
 a_modify_reason           IN     VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER IS

l_fa      UNAPIGEN.CHAR1_TABLE_TYPE;
l_inherit_fa      UNAPIGEN.CHAR1_TABLE_TYPE;

BEGIN
 FOR l_row IN 1..a_nr_of_rows LOOP
    l_fa (l_row)   := a_fa  (l_row);
    l_inherit_fa (l_row)   := a_inherit_fa  (l_row);
 END LOOP ;
l_ret_code := UNAPIUPP.SaveUpFuncList
(a_up                   ,
 a_applic               ,
 l_fa                    ,
 l_inherit_fa            ,
 a_nr_of_rows            ,
 a_modify_reason);

RETURN (l_ret_code);
END SaveUpFuncList;

FUNCTION SaveUpFuncDetails
(a_up                      IN     NUMBER,                   /* LONG_TYPE */
 a_applic                  IN     VARCHAR2,                 /* VC20_TYPE */
 a_topic                   IN     UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_fa                      IN     UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_inherit_fa              IN     UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_nr_of_rows              IN OUT NUMBER,                   /* NUM_TYPE */
 a_modify_reason           IN     VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER IS

l_fa      UNAPIGEN.CHAR1_TABLE_TYPE;
l_inherit_fa      UNAPIGEN.CHAR1_TABLE_TYPE;

BEGIN
FOR l_row IN 1..a_nr_of_rows LOOP
     l_fa (l_row)   := a_fa  (l_row);
     l_inherit_fa (l_row)   := a_inherit_fa  (l_row);
END LOOP ;

l_ret_code := UNAPIUPP.SaveUpFuncDetails
(a_up                 ,
 a_applic              ,
 a_topic                ,
 l_fa                    ,
 l_inherit_fa             ,
 a_nr_of_rows              ,
 a_modify_reason);


RETURN (l_ret_code);
END SaveUpFuncDetails;

FUNCTION SaveUpUsFuncList
(a_up                      IN     NUMBER,                   /* LONG_TYPE */
 a_us                      IN     VARCHAR2,                 /* VC20_TYPE */
 a_applic                  IN     UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_fa                      IN     UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_inherit_fa              IN     UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_nr_of_rows              IN OUT NUMBER,                   /* NUM_TYPE */
 a_modify_reason           IN     VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER IS

l_fa      UNAPIGEN.CHAR1_TABLE_TYPE;
l_inherit_fa      UNAPIGEN.CHAR1_TABLE_TYPE;

BEGIN

 FOR l_row IN 1..a_nr_of_rows LOOP
     l_fa (l_row)   := a_fa  (l_row);
     l_inherit_fa (l_row)   := a_inherit_fa  (l_row);
  END LOOP ;

l_ret_code := UNAPIUPP.SaveUpUsFuncList
 (a_up                ,
  a_us                ,
  a_applic            ,
  l_fa                ,
  l_inherit_fa        ,
  a_nr_of_rows        ,
  a_modify_reason );


RETURN (l_ret_code);
END SaveUpUsFuncList;

FUNCTION SaveUpUsFuncDetails
(a_up                         IN     NUMBER,                   /* LONG_TYPE */
 a_us                         IN     VARCHAR2,                 /* VC20_TYPE */
 a_applic                     IN     VARCHAR2,                 /* VC20_TYPE */
 a_topic                      IN     UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_fa                         IN     UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_inherit_fa                 IN     UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_nr_of_rows                 IN OUT NUMBER,                   /* NUM_TYPE */
 a_modify_reason              IN     VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER IS

l_fa      UNAPIGEN.CHAR1_TABLE_TYPE;
l_inherit_fa      UNAPIGEN.CHAR1_TABLE_TYPE;

BEGIN
 FOR l_row IN 1..a_nr_of_rows LOOP
     l_fa (l_row)   := a_fa  (l_row);
     l_inherit_fa (l_row)   := a_inherit_fa  (l_row);
  END LOOP ;

l_ret_code := UNAPIUPP.SaveUpUsFuncDetails
(a_up                 ,
 a_us                 ,
 a_applic             ,
 a_topic               ,
 l_fa                ,
 l_inherit_fa        ,
 a_nr_of_rows        ,
 a_modify_reason );

RETURN (l_ret_code);
END SaveUpUsFuncDetails;

FUNCTION GetUpPref
(a_up_in            IN     NUMBER,                     /* LONG_TYPE */
 a_pref_name_in     IN     VARCHAR2,                   /* VC20_TYPE */
 a_up               OUT    UNAPIGEN.LONG_TABLE_TYPE,   /* LONG_TABLE_TYPE */
 a_pref_name        OUT    UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_pref_value       OUT    UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_inherit_pref     OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_applicable_obj   OUT    UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_category         OUT    UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_description      OUT    UNAPIGEN.VC255_TABLE_TYPE,  /* VC255_TABLE_TYPE */
 a_nr_of_rows       IN OUT NUMBER)                     /* NUM_TYPE */
RETURN NUMBER IS

l_inherit_pref     UNAPIGEN.CHAR1_TABLE_TYPE;
BEGIN
l_ret_code := UNAPIUPP.GetUpPref
 (a_up_in            ,
  a_pref_name_in     ,
  a_up               ,
  a_pref_name        ,
  a_pref_value       ,
  l_inherit_pref     ,
  a_applicable_obj   ,
  a_category         ,
  a_description      ,
  a_nr_of_rows  );
 IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
   FOR l_row IN 1..a_nr_of_rows LOOP
      a_inherit_pref (l_row)   := l_inherit_pref (l_row);
   END LOOP ;
 END IF ;

RETURN (l_ret_code);
END GetUpPref;

FUNCTION SaveUpPref
(a_up                   IN   NUMBER,                       /* LONG_TYPE */
 a_pref_name            IN   UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_pref_value           IN   UNAPIGEN.VC40_TABLE_TYPE,     /* VC40_TABLE_TYPE */
 a_inherit_pref         IN   UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_nr_of_rows           IN   NUMBER,                       /* NUM_TYPE */
 a_modify_reason        IN   VARCHAR2)                     /* VC255_TYPE */
RETURN NUMBER IS

l_inherit_pref     UNAPIGEN.CHAR1_TABLE_TYPE;

BEGIN

FOR l_row IN 1..a_nr_of_rows LOOP
      l_inherit_pref (l_row)   := a_inherit_pref (l_row);
   END LOOP ;

l_ret_code := UNAPIUPP.SaveUpPref
 (a_up             ,
  a_pref_name      ,
  a_pref_value     ,
  l_inherit_pref   ,
  a_nr_of_rows     ,
  a_modify_reason  );

RETURN (l_ret_code);
END SaveUpPref;

FUNCTION GetUpUsPref
(a_up_in                IN     NUMBER,                     /* LONG_TYPE */
 a_us_in                IN     VARCHAR2,                   /* VC20_TYPE */
 a_pref_name_in         IN     VARCHAR2,                   /* VC20_TYPE */
 a_up                   OUT    UNAPIGEN.LONG_TABLE_TYPE,   /* LONG_TABLE_TYPE */
 a_us                   OUT    UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_pref_name            OUT    UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_pref_value           OUT    UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_inherit_pref         OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_nr_of_rows           IN OUT NUMBER)                     /* NUM_TYPE */
RETURN NUMBER IS

l_inherit_pref     UNAPIGEN.CHAR1_TABLE_TYPE;

BEGIN
l_ret_code := UNAPIUPP.GetUpUsPref
  (a_up_in             ,
   a_us_in             ,
   a_pref_name_in      ,
   a_up                ,
   a_us                ,
   a_pref_name         ,
   a_pref_value        ,
   l_inherit_pref      ,
   a_nr_of_rows  );

 IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
   FOR l_row IN 1..a_nr_of_rows LOOP
      a_inherit_pref (l_row)   := l_inherit_pref (l_row);
   END LOOP ;
 END IF ;

RETURN (l_ret_code);
END GetUpUsPref;

FUNCTION GetUpUsPref
(a_up_in                IN     NUMBER,                     /* LONG_TYPE */
 a_us_in                IN     VARCHAR2,                   /* VC20_TYPE */
 a_pref_name_in         IN     VARCHAR2,                   /* VC20_TYPE */
 a_up                   OUT    UNAPIGEN.LONG_TABLE_TYPE,   /* LONG_TABLE_TYPE */
 a_us                   OUT    UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_pref_name            OUT    UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_pref_value           OUT    UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_inherit_pref         OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_applicable_obj       OUT    UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_category             OUT    UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_description          OUT    UNAPIGEN.VC255_TABLE_TYPE,  /* VC255_TABLE_TYPE */
 a_nr_of_rows           IN OUT NUMBER)                     /* NUM_TYPE */
RETURN NUMBER IS

l_inherit_pref     UNAPIGEN.CHAR1_TABLE_TYPE;

BEGIN
l_ret_code := UNAPIUPP.GetUpUsPref
  (a_up_in             ,
   a_us_in             ,
   a_pref_name_in      ,
   a_up                ,
   a_us                ,
   a_pref_name         ,
   a_pref_value        ,
   l_inherit_pref      ,
   a_applicable_obj    ,
   a_category          ,
   a_description       ,
   a_nr_of_rows  );

 IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
   FOR l_row IN 1..a_nr_of_rows LOOP
      a_inherit_pref (l_row)   := l_inherit_pref (l_row);
   END LOOP ;
 END IF ;

RETURN (l_ret_code);
END GetUpUsPref;

FUNCTION SaveUpUsPref
(a_up                   IN   NUMBER,                       /* LONG_TYPE */
 a_us                   IN   VARCHAR2,                     /* VC20_TYPE */
 a_pref_name            IN   UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_pref_value           IN   UNAPIGEN.VC40_TABLE_TYPE,     /* VC40_TABLE_TYPE */
 a_inherit_pref         IN   UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_nr_of_rows           IN   NUMBER,                       /* NUM_TYPE */
 a_modify_reason        IN   VARCHAR2)                     /* VC255_TYPE */
RETURN NUMBER IS

l_inherit_pref     UNAPIGEN.CHAR1_TABLE_TYPE;

BEGIN

FOR l_row IN 1..a_nr_of_rows LOOP
      l_inherit_pref (l_row)   := a_inherit_pref (l_row);
   END LOOP ;

l_ret_code := UNAPIUPP.SaveUpUsPref
(a_up                          ,
 a_us                          ,
 a_pref_name                   ,
 a_pref_value                  ,
 l_inherit_pref                ,
 a_nr_of_rows                  ,
 a_modify_reason   );


RETURN (l_ret_code);
END SaveUpUsPref;

FUNCTION GetUpTaskList
(a_up_in                IN     NUMBER,                   /* LONG_TYPE */
 a_tk_tp_in             IN     VARCHAR2,                 /* VC20_TYPE */
 a_up                   OUT    UNAPIGEN.LONG_TABLE_TYPE, /* LONG_TABLE_TYPE */
 a_tk_tp                OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_tk                   OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_description          OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_is_enabled           OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_nr_of_rows           IN OUT NUMBER)                   /* NUM_TYPE */
RETURN NUMBER IS

l_is_enabled     UNAPIGEN.CHAR1_TABLE_TYPE;

BEGIN
l_ret_code := UNAPIUPP.GetUpTaskList
  (a_up_in                    ,
   a_tk_tp_in                 ,
   a_up                       ,
   a_tk_tp                    ,
   a_tk                       ,
   a_description              ,
   l_is_enabled               ,
   a_nr_of_rows  );

 IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
   FOR l_row IN 1..a_nr_of_rows LOOP
      a_is_enabled (l_row)   := l_is_enabled (l_row);
   END LOOP ;
 END IF ;

RETURN (l_ret_code);
END GetUpTaskList;

FUNCTION GetUpTaskDetails
(a_up_in                   IN     NUMBER,                   /* LONG_TYPE */
 a_tk_tp_in                IN     VARCHAR2,                 /* VC20_TYPE */
 a_tk_in                   IN     VARCHAR2,                 /* VC20_TYPE */
 a_up                      OUT    UNAPIGEN.LONG_TABLE_TYPE, /* LONG_TABLE_TYPE */
 a_tk_tp                   OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_tk                      OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_col_id                  OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_col_tp                  OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_disp_title              OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_def_val                 OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_hidden                  OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_is_protected            OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_mandatory               OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_auto_refresh            OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_col_asc                 OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_value_list_tp           OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_dsp_len                 OUT    UNAPIGEN.NUM_TABLE_TYPE,  /* NUM_TABLE_TYPE + INDICATOR */
 a_inherit_tk              OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_nr_of_rows              IN OUT NUMBER)                   /* NUM_TYPE */
RETURN NUMBER IS

l_hidden          UNAPIGEN.CHAR1_TABLE_TYPE;
l_is_protected    UNAPIGEN.CHAR1_TABLE_TYPE;
l_mandatory       UNAPIGEN.CHAR1_TABLE_TYPE;
l_auto_refresh    UNAPIGEN.CHAR1_TABLE_TYPE;
l_col_asc         UNAPIGEN.CHAR1_TABLE_TYPE;
l_value_list_tp   UNAPIGEN.CHAR1_TABLE_TYPE;
l_inherit_tk       UNAPIGEN.CHAR1_TABLE_TYPE;

BEGIN
l_ret_code := UNAPIUPP.GetUpTaskDetails
 (a_up_in                    ,
  a_tk_tp_in                 ,
  a_tk_in                    ,
  a_up                       ,
  a_tk_tp                    ,
  a_tk                       ,
  a_col_id                   ,
  a_col_tp                   ,
  a_disp_title               ,
  a_def_val                  ,
  l_hidden                   ,
  l_is_protected             ,
  l_mandatory                ,
  l_auto_refresh             ,
  l_col_asc                  ,
  l_value_list_tp            ,
  a_dsp_len                  ,
  l_inherit_tk               ,
  a_nr_of_rows   );

 IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
   FOR l_row IN 1..a_nr_of_rows LOOP
      a_hidden (l_row)           := l_hidden (l_row);
      a_is_protected (l_row)     := l_is_protected (l_row);
      a_mandatory (l_row)        := l_mandatory (l_row);
      a_auto_refresh (l_row)     := l_auto_refresh (l_row);
      a_col_asc (l_row)          := l_col_asc (l_row);
      a_value_list_tp (l_row)    := l_value_list_tp (l_row);
      a_inherit_tk (l_row)       := l_inherit_tk (l_row);
   END LOOP ;
 END IF ;

RETURN (l_ret_code);
END GetUpTaskDetails;

FUNCTION GetUpTaskDetails
(a_up_in             IN     NUMBER,                      /* LONG_TYPE */
 a_tk_tp_in          IN     VARCHAR2,                    /* VC20_TYPE */
 a_tk_in             IN     VARCHAR2,                    /* VC20_TYPE */
 a_up                OUT    UNAPIGEN.LONG_TABLE_TYPE,    /* LONG_TABLE_TYPE */
 a_tk_tp             OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_tk                OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_col_id            OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_col_tp            OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_disp_title        OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_operator          OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_def_val           OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_andor             OUT    UNAPIGEN.VC3_TABLE_TYPE,     /* VC3_TABLE_TYPE */
 a_hidden            OUT    UNAPIGEN.VC1_TABLE_TYPE,     /* VC1_TABLE_TYPE */
 a_is_protected      OUT    UNAPIGEN.VC1_TABLE_TYPE,     /* VC1_TABLE_TYPE */
 a_mandatory         OUT    UNAPIGEN.VC1_TABLE_TYPE,     /* VC1_TABLE_TYPE */
 a_auto_refresh      OUT    UNAPIGEN.VC1_TABLE_TYPE,     /* VC1_TABLE_TYPE */
 a_col_asc           OUT    UNAPIGEN.VC1_TABLE_TYPE,     /* VC1_TABLE_TYPE */
 a_value_list_tp     OUT    UNAPIGEN.VC1_TABLE_TYPE,     /* VC1_TABLE_TYPE */
 a_operator_protect  OUT    UNAPIGEN.VC1_TABLE_TYPE,     /* VC1_TABLE_TYPE */
 a_andor_protect     OUT    UNAPIGEN.VC1_TABLE_TYPE,     /* VC1_TABLE_TYPE */
 a_dsp_len           OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE + INDICATOR */
 a_inherit_tk        OUT    UNAPIGEN.VC1_TABLE_TYPE,     /* VC1_TABLE_TYPE */
 a_nr_of_rows        IN OUT NUMBER)                      /* NUM_TYPE */
RETURN NUMBER  IS

l_hidden             UNAPIGEN.CHAR1_TABLE_TYPE;
l_is_protected       UNAPIGEN.CHAR1_TABLE_TYPE;
l_mandatory          UNAPIGEN.CHAR1_TABLE_TYPE;
l_auto_refresh       UNAPIGEN.CHAR1_TABLE_TYPE;
l_col_asc            UNAPIGEN.CHAR1_TABLE_TYPE;
l_value_list_tp      UNAPIGEN.CHAR1_TABLE_TYPE;
l_inherit_tk         UNAPIGEN.CHAR1_TABLE_TYPE;
l_operator_protect   UNAPIGEN.CHAR1_TABLE_TYPE;
l_andor_protect      UNAPIGEN.CHAR1_TABLE_TYPE;

BEGIN
l_ret_code := UNAPIUPP.GetUpTaskDetails
 (a_up_in                    ,
  a_tk_tp_in                 ,
  a_tk_in                    ,
  a_up                       ,
  a_tk_tp                    ,
  a_tk                       ,
  a_col_id                   ,
  a_col_tp                   ,
  a_disp_title               ,
  a_operator                 ,
  a_def_val                  ,
  a_andor                    ,
  l_hidden                   ,
  l_is_protected             ,
  l_mandatory                ,
  l_auto_refresh             ,
  l_col_asc                  ,
  l_value_list_tp            ,
  l_operator_protect         ,
  l_andor_protect            ,
  a_dsp_len                  ,
  l_inherit_tk               ,
  a_nr_of_rows   );

 IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
   FOR l_row IN 1..a_nr_of_rows LOOP
      a_hidden (l_row)           := l_hidden (l_row);
      a_is_protected (l_row)     := l_is_protected (l_row);
      a_mandatory (l_row)        := l_mandatory (l_row);
      a_auto_refresh (l_row)     := l_auto_refresh (l_row);
      a_col_asc (l_row)          := l_col_asc (l_row);
      a_value_list_tp (l_row)    := l_value_list_tp (l_row);
      a_operator_protect(l_row)  := l_operator_protect (l_row);
      a_andor_protect(l_row)     := l_andor_protect (l_row);
      a_inherit_tk (l_row)       := l_inherit_tk (l_row);
   END LOOP ;
 END IF ;

RETURN (l_ret_code);
END GetUpTaskDetails;

FUNCTION GetUpUsTaskList
(a_up_in                   IN     NUMBER,                   /* LONG_TYPE */
 a_us_in                   IN     VARCHAR2,                 /* VC20_TYPE */
 a_tk_tp_in                IN     VARCHAR2,                 /* VC20_TYPE */
 a_up                      OUT    UNAPIGEN.LONG_TABLE_TYPE, /* LONG_TABLE_TYPE */
 a_us                      OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_tk_tp                   OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_tk                      OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_description             OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_is_enabled              OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_nr_of_rows              IN OUT NUMBER)                   /* NUM_TYPE */
RETURN NUMBER IS

l_is_enabled     UNAPIGEN.CHAR1_TABLE_TYPE;

BEGIN
l_ret_code := UNAPIUPP.GetUpUsTaskList
(a_up_in                    ,
 a_us_in                    ,
 a_tk_tp_in                 ,
 a_up                       ,
 a_us                       ,
 a_tk_tp                    ,
 a_tk                       ,
 a_description              ,
 l_is_enabled               ,
 a_nr_of_rows  );

 IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
   FOR l_row IN 1..a_nr_of_rows LOOP
      a_is_enabled (l_row)   := l_is_enabled (l_row);
   END LOOP ;
 END IF ;
RETURN (l_ret_code);
END GetUpUsTaskList;

FUNCTION GetUpUsTaskDetailsDefinition
(a_up_in                               IN     NUMBER,                   /* LONG_TYPE */
 a_us_in                               IN     VARCHAR2,                 /* VC20_TYPE */
 a_tk_tp_in                            IN     VARCHAR2,                 /* VC20_TYPE */
 a_tk_in                               IN     VARCHAR2,                 /* VC20_TYPE */
 a_up                                  OUT    UNAPIGEN.LONG_TABLE_TYPE, /* LONG_TABLE_TYPE */
 a_us                                  OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_tk_tp                               OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_tk                                  OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_col_id                              OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_col_tp                              OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_disp_title                          OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_def_val                             OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_hidden                              OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_is_protected                        OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_mandatory                           OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_auto_refresh                        OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_col_asc                             OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_dsp_len                             OUT    UNAPIGEN.NUM_TABLE_TYPE,  /* NUM_TABLE_TYPE + INDICATOR */
 a_inherit_tk                          OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_nr_of_rows                          IN OUT NUMBER)                   /* NUM_TYPE */
RETURN NUMBER IS
l_hidden       UNAPIGEN.CHAR1_TABLE_TYPE;
l_is_protected UNAPIGEN.CHAR1_TABLE_TYPE;
l_mandatory    UNAPIGEN.CHAR1_TABLE_TYPE;
l_auto_refresh UNAPIGEN.CHAR1_TABLE_TYPE;
l_col_asc      UNAPIGEN.CHAR1_TABLE_TYPE;
l_inherit_tk   UNAPIGEN.CHAR1_TABLE_TYPE;
BEGIN
l_ret_code := UNAPIUPP.GetUpUsTaskDetailsDefinition
 (a_up_in                  ,
  a_us_in                  ,
  a_tk_tp_in               ,
  a_tk_in                  ,
  a_up                     ,
  a_us                     ,
  a_tk_tp                  ,
  a_tk                     ,
  a_col_id                 ,
  a_col_tp                 ,
  a_disp_title             ,
  a_def_val                ,
  l_hidden                 ,
  l_is_protected           ,
  l_mandatory              ,
  l_auto_refresh           ,
  l_col_asc                ,
  a_dsp_len                ,
  l_inherit_tk             ,
  a_nr_of_rows   );

 IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
   FOR l_row IN 1..a_nr_of_rows LOOP
      a_hidden (l_row)           := l_hidden (l_row);
      a_is_protected (l_row)     := l_is_protected (l_row);
      a_mandatory (l_row)        := l_mandatory (l_row);
      a_auto_refresh (l_row)     := l_auto_refresh (l_row);
      a_col_asc (l_row)          := l_col_asc (l_row);
      a_inherit_tk (l_row)       := l_inherit_tk (l_row);
   END LOOP ;
 END IF ;

RETURN (l_ret_code);
END GetUpUsTaskDetailsDefinition;

FUNCTION GetUpUsTaskDetailsDefinition
(a_up_in             IN     NUMBER,                   /* LONG_TYPE */
 a_us_in             IN     VARCHAR2,                 /* VC20_TYPE */
 a_tk_tp_in          IN     VARCHAR2,                 /* VC20_TYPE */
 a_tk_in             IN     VARCHAR2,                 /* VC20_TYPE */
 a_up                OUT    UNAPIGEN.LONG_TABLE_TYPE, /* LONG_TABLE_TYPE */
 a_us                OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_tk_tp             OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_tk                OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_description       OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_col_id            OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_col_tp            OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_disp_title        OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_operator          OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_def_val           OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_andor             OUT    UNAPIGEN.VC3_TABLE_TYPE,  /* VC3_TABLE_TYPE */
 a_hidden            OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_is_protected      OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_mandatory         OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_auto_refresh      OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_col_asc           OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_value_list_tp     OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_operator_protect  OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_andor_protect     OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_dsp_len           OUT    UNAPIGEN.NUM_TABLE_TYPE,  /* NUM_TABLE_TYPE + INDICATOR */
 a_inherit_tk        OUT    UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_nr_of_rows        IN OUT NUMBER)                   /* NUM_TYPE */
RETURN NUMBER IS
l_hidden                UNAPIGEN.CHAR1_TABLE_TYPE;
l_is_protected          UNAPIGEN.CHAR1_TABLE_TYPE;
l_mandatory             UNAPIGEN.CHAR1_TABLE_TYPE;
l_auto_refresh          UNAPIGEN.CHAR1_TABLE_TYPE;
l_col_asc               UNAPIGEN.CHAR1_TABLE_TYPE;
l_value_list_tp         UNAPIGEN.CHAR1_TABLE_TYPE;
l_operator_protect      UNAPIGEN.CHAR1_TABLE_TYPE;
l_andor_protect         UNAPIGEN.CHAR1_TABLE_TYPE;
l_inherit_tk            UNAPIGEN.CHAR1_TABLE_TYPE;

BEGIN

l_ret_code := UNAPIUPP.GetUpUsTaskDetailsDefinition
 (a_up_in                  ,
  a_us_in                  ,
  a_tk_tp_in               ,
  a_tk_in                  ,
  a_up                     ,
  a_us                     ,
  a_tk_tp                  ,
  a_tk                     ,
  a_description            ,
  a_col_id                 ,
  a_col_tp                 ,
  a_disp_title             ,
  a_operator               ,
  a_def_val                ,
  a_andor                  ,
  l_hidden                 ,
  l_is_protected           ,
  l_mandatory              ,
  l_auto_refresh           ,
  l_col_asc                ,
  l_value_list_tp          ,
  l_operator_protect       ,
  l_andor_protect          ,
  a_dsp_len                ,
  l_inherit_tk             ,
  a_nr_of_rows   );

 IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
   FOR l_row IN 1..a_nr_of_rows LOOP
      a_hidden (l_row)           := l_hidden (l_row);
      a_is_protected (l_row)     := l_is_protected (l_row);
      a_mandatory (l_row)        := l_mandatory (l_row);
      a_auto_refresh (l_row)     := l_auto_refresh (l_row);
      a_col_asc (l_row)          := l_col_asc (l_row);
      a_value_list_tp (l_row)    := l_value_list_tp(l_row);
      a_operator_protect (l_row) := l_operator_protect(l_row);
      a_andor_protect (l_row)    := l_andor_protect(l_row);
      a_inherit_tk (l_row)       := l_inherit_tk (l_row);
   END LOOP ;
 END IF ;

RETURN (l_ret_code);
END GetUpUsTaskDetailsDefinition;

FUNCTION SaveUpTaskList
(a_up                   IN     NUMBER,                   /* LONG_TYPE */
 a_tk_tp                IN     UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_tk                   IN     UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_is_enabled           IN     UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_nr_of_rows           IN     NUMBER,                   /* NUM_TYPE */
 a_modify_reason        IN     VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER IS
l_is_enabled  UNAPIGEN.CHAR1_TABLE_TYPE;
BEGIN
 FOR l_row IN 1..a_nr_of_rows LOOP
      l_is_enabled (l_row)   := a_is_enabled (l_row);
   END LOOP ;


l_ret_code := UNAPIUPP.SaveUpTaskList
 (a_up                    ,
  a_tk_tp                 ,
  a_tk                    ,
  l_is_enabled            ,
  a_nr_of_rows            ,
  a_modify_reason   );

RETURN (l_ret_code);
END SaveUpTaskList;

FUNCTION SaveUpTaskDetails
(a_up                      IN     NUMBER,                   /* LONG_TYPE */
 a_tk_tp                   IN     VARCHAR2,                 /* VC20_TYPE */
 a_tk                      IN     VARCHAR2,                 /* VC20_TYPE */
 a_col_id                  IN     UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_col_tp                  IN     UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_def_val                 IN     UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_hidden                  IN     UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_is_protected            IN     UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_mandatory               IN     UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_auto_refresh            IN     UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_col_asc                 IN     UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_dsp_len                 IN     UNAPIGEN.NUM_TABLE_TYPE,  /* NUM_TABLE_TYPE + INDICATOR */
 a_inherit_tk              IN     UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_nr_of_rows              IN     NUMBER,                   /* NUM_TYPE */
 a_modify_reason           IN     VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER IS
l_hidden       UNAPIGEN.CHAR1_TABLE_TYPE;
l_is_protected UNAPIGEN.CHAR1_TABLE_TYPE;
l_mandatory    UNAPIGEN.CHAR1_TABLE_TYPE;
l_auto_refresh UNAPIGEN.CHAR1_TABLE_TYPE;
l_col_asc      UNAPIGEN.CHAR1_TABLE_TYPE;
l_inherit_tk   UNAPIGEN.CHAR1_TABLE_TYPE;
BEGIN
FOR l_row IN 1..a_nr_of_rows LOOP
      l_hidden (l_row)           := a_hidden (l_row);
      l_is_protected (l_row)     := a_is_protected (l_row);
      l_mandatory (l_row)        := a_mandatory (l_row);
      l_auto_refresh (l_row)     := a_auto_refresh (l_row);
      l_col_asc (l_row)          := a_col_asc (l_row);
      l_inherit_tk (l_row)       := a_inherit_tk (l_row);
   END LOOP ;

l_ret_code := UNAPIUPP. SaveUpTaskDetails
 (a_up                   ,
  a_tk_tp                ,
  a_tk                   ,
  a_col_id               ,
  a_col_tp               ,
  a_def_val              ,
  l_hidden               ,
  l_is_protected         ,
  l_mandatory            ,
  l_auto_refresh         ,
  l_col_asc              ,
  a_dsp_len              ,
  l_inherit_tk           ,
  a_nr_of_rows           ,
  a_modify_reason   );

RETURN (l_ret_code);
END SaveUpTaskDetails;

FUNCTION SaveUpUsTaskList
(a_up                      IN     NUMBER,                   /* LONG_TYPE */
 a_us                      IN     VARCHAR2,                 /* VC20_TYPE */
 a_tk_tp                   IN     UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_tk                      IN     UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_is_enabled              IN     UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_nr_of_rows              IN     NUMBER,                   /* NUM_TYPE */
 a_modify_reason           IN     VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER IS
l_is_enabled  UNAPIGEN.CHAR1_TABLE_TYPE;
BEGIN

FOR l_row IN 1..a_nr_of_rows LOOP
  l_is_enabled (l_row)   := a_is_enabled (l_row);
END LOOP ;

l_ret_code := UNAPIUPP.SaveUpUsTaskList
(a_up                   ,
 a_us                   ,
 a_tk_tp                ,
 a_tk                   ,
 l_is_enabled           ,
 a_nr_of_rows           ,
 a_modify_reason   );

RETURN (l_ret_code);
END SaveUpUsTaskList;

FUNCTION SaveUpUsTaskDetails
(a_up                         IN     NUMBER,                   /* LONG_TYPE */
 a_us                         IN     VARCHAR2,                 /* VC20_TYPE */
 a_tk_tp                      IN     VARCHAR2,                 /* VC20_TYPE */
 a_tk                         IN     VARCHAR2,                 /* VC20_TYPE */
 a_col_id                     IN     UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_col_tp                     IN     UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_def_val                    IN     UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_hidden                     IN     UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_is_protected               IN     UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_mandatory                  IN     UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_auto_refresh               IN     UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_col_asc                    IN     UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_dsp_len                    IN     UNAPIGEN.NUM_TABLE_TYPE,  /* NUM_TABLE_TYPE + INDICATOR */
 a_inherit_tk                 IN     UNAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_nr_of_rows                 IN     NUMBER,                   /* NUM_TYPE */
 a_modify_reason              IN     VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER IS
l_hidden       UNAPIGEN.CHAR1_TABLE_TYPE;
l_is_protected UNAPIGEN.CHAR1_TABLE_TYPE;
l_mandatory    UNAPIGEN.CHAR1_TABLE_TYPE;
l_auto_refresh UNAPIGEN.CHAR1_TABLE_TYPE;
l_col_asc      UNAPIGEN.CHAR1_TABLE_TYPE;
l_inherit_tk   UNAPIGEN.CHAR1_TABLE_TYPE;
BEGIN
FOR l_row IN 1..a_nr_of_rows LOOP
      l_hidden (l_row)           := a_hidden (l_row);
      l_is_protected (l_row)     := a_is_protected (l_row);
      l_mandatory (l_row)        := a_mandatory (l_row);
      l_auto_refresh (l_row)     := a_auto_refresh (l_row);
      l_col_asc (l_row)          := a_col_asc (l_row);
      l_inherit_tk (l_row)       := a_inherit_tk (l_row);
END LOOP ;

l_ret_code := UNAPIUPP.SaveUpUsTaskDetails
(a_up                  ,
 a_us                  ,
 a_tk_tp               ,
 a_tk                  ,
 a_col_id              ,
 a_col_tp              ,
 a_def_val             ,
 l_hidden              ,
 l_is_protected        ,
 l_mandatory           ,
 l_auto_refresh       ,
 l_col_asc           ,
 a_dsp_len          ,
 l_inherit_tk      ,
 a_nr_of_rows     ,
 a_modify_reason   );

RETURN (l_ret_code);
END SaveUpUsTaskDetails;


END pbapiupp;
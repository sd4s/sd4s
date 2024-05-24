create or replace PACKAGE BODY
-- Unilab 4.0 Package
-- $Revision: 2 $
-- $Date: 12/12/02 14:14 $
Uncalc AS

l_sql_string    VARCHAR2(2000);
l_result        NUMBER;

-- The general rules for cf_type in utcf can be found in the document: customizing the system
-- Minimal information can also be found in the header of the unaction package
--

FUNCTION CalcMethod
(a_sc               IN    VARCHAR2,    /* VC20_TYPE */
 a_pg               IN    VARCHAR2,    /* VC20_TYPE */
 a_pgnode           IN    NUMBER,      /* LONG_TYPE */
 a_pa               IN    VARCHAR2,    /* VC20_TYPE */
 a_panode           IN    NUMBER,      /* LONG_TYPE */
 a_value_f          OUT   FLOAT,       /* FLOAT_TYPE */
 a_value_s          OUT   VARCHAR2)    /* VC40_TYPE */
RETURN NUMBER IS

BEGIN

   /*-----------------------------*/
   /* Set Some values for testing */
   /*-----------------------------*/
   a_value_f := 200;
   a_value_s := 'Two hundred (UNCALC)';

   RETURN(Unapigen.DBERR_SUCCESS);
END CalcMethod;

FUNCTION Average
(a_sc               IN    VARCHAR2,    /* VC20_TYPE */
 a_pg               IN    VARCHAR2,    /* VC20_TYPE */
 a_pgnode           IN    NUMBER,      /* LONG_TYPE */
 a_pa               IN    VARCHAR2,    /* VC20_TYPE */
 a_panode           IN    NUMBER,      /* LONG_TYPE */
 a_value_f          OUT   FLOAT,       /* FLOAT_TYPE */
 a_value_s          OUT   VARCHAR2)    /* VC40_TYPE */
RETURN NUMBER IS

CURSOR l_scme_avg_first_me_cursor(c_sc VARCHAR2, c_pg VARCHAR2, c_pgnode NUMBER,
                                  c_pa VARCHAR2, c_panode NUMBER) IS
   SELECT unit, format
   FROM utscme
   WHERE sc = c_sc
      AND pg = c_pg
      AND pgnode = c_pgnode
      AND pa = c_pa
      AND panode = c_panode
      AND active = '1'
      AND NVL(ss, '@~') <> '@C'
      AND value_f IS NOT NULL
      AND exec_end_date IS NOT NULL
   ORDER BY menode;

-- The result of the methods will first be converted to the unit of the first method
-- (= the given c_me_unit) before the average takes place.
CURSOR l_scme_avg_cursor(c_sc VARCHAR2, c_pg VARCHAR2, c_pgnode NUMBER,
                         c_pa VARCHAR2, c_panode NUMBER, c_me_unit VARCHAR2) IS
   SELECT AVG(value_f * UNAPIGEN.SQLUnitConversionFactor(unit, c_me_unit)),
          COUNT(sc),
          COUNT(DECODE(SUBSTR(value_s,1,1),'<',1,NULL)),
          COUNT(DECODE(SUBSTR(value_s,1,1),'>',1,NULL))
   FROM utscme
   WHERE sc     = c_sc
     AND pg     = c_pg
     AND pgnode = c_pgnode
     AND pa     = c_pa
     AND panode = c_panode
     AND active = '1'
     AND NVL(ss, '@~') <> '@C'
     AND value_f IS NOT NULL
     AND exec_end_date IS NOT NULL;

CURSOR c_system (a_setting_name VARCHAR2) IS
   SELECT setting_value
   FROM utsystem
   WHERE setting_name = a_setting_name;

l_ret_code           NUMBER(3);
l_nr_open            NUMBER(3);
l_lt_cnt             NUMBER(3);
l_gt_cnt             NUMBER(3);

l_pa_unit            VARCHAR2(20);
l_pa_format          VARCHAR2(40);
l_me_value_f         FLOAT;
l_me_value_s         VARCHAR2(40);
l_me_unit            VARCHAR2(20);
l_me_format          VARCHAR2(40);

BEGIN

   /* get unit and format of the first method of the parameter */
   OPEN l_scme_avg_first_me_cursor(a_sc, a_pg, a_pgnode, a_pa, a_panode);
   FETCH l_scme_avg_first_me_cursor
   INTO l_me_unit, l_me_format;
   IF l_scme_avg_first_me_cursor%NOTFOUND THEN
      CLOSE l_scme_avg_first_me_cursor;
      RETURN(UNAPIGEN.DBERR_NOOBJECT);
   END IF;
   CLOSE l_scme_avg_first_me_cursor;

   /* if no format found on me-level, get the default format */
   IF l_me_format IS NULL THEN
      OPEN c_system ('DEFAULT_FORMAT');
      FETCH c_system INTO l_me_format;
      IF c_system%NOTFOUND THEN
         CLOSE c_system;
         RETURN (UNAPIGEN.DBERR_SYSDEFAULTS);
      END IF;
      CLOSE c_system;
   END IF;

   /* get unit and format of the parameter */
   SELECT unit, format
   INTO l_pa_unit, l_pa_format
   FROM utscpa
   WHERE sc     = a_sc
     AND pg     = a_pg
     AND pgnode = a_pgnode
     AND pa     = a_pa
     AND panode = a_panode;

   /*----------------------------------------------------------------------------------------------*/
   /* Calculate the average method result, but copy any '<' or '>' signs from me-level to pa-level */
   /* this illustrates how full control over the value_s contents can be enforced                  */
   /* Note: if value_s = NULL the standard formatting rules will be applied automatically!         */
   /*----------------------------------------------------------------------------------------------*/
   OPEN l_scme_avg_cursor(a_sc, a_pg, a_pgnode, a_pa, a_panode, l_me_unit);
   FETCH l_scme_avg_cursor INTO l_me_value_f, l_nr_open, l_lt_cnt, l_gt_cnt;
   IF NVL(l_nr_open, 0) = 0 THEN
      CLOSE l_scme_avg_cursor;
      RETURN(UNAPIGEN.DBERR_NOOBJECT);
   END IF;
   CLOSE l_scme_avg_cursor;

   /* format the value_s */
   l_ret_code := UNAPIGEN.FormatResult(l_me_value_f, l_me_format, l_me_value_s);
   IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
      RETURN(l_ret_code);
   END IF;

   /*-------------------*/
   /* Format the result */
   /*-------------------*/
   l_ret_code := UNAPIGEN.TransformResult(l_me_value_s,
                                          l_me_value_f,
                                          l_me_unit,
                                          l_me_format,
                                          a_value_s,
                                          a_value_f,
                                          l_pa_unit,
                                          l_pa_format);
   IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
      RETURN(l_ret_code);
   END IF;

   /* and then check for any special cases */
   IF    ( l_lt_cnt = 0 ) AND ( l_gt_cnt = 0 ) THEN
      /* nothing special */
      NULL;
   ELSIF ( l_lt_cnt > 0 ) AND ( l_gt_cnt = 0 ) THEN
      /* insert '< ' in front of string result */
      a_value_s := '< ' || a_value_s;
   ELSIF ( l_lt_cnt = 0 ) AND ( l_gt_cnt > 0 ) THEN
      /* insert '> ' in front of string result */
      a_value_s := '> ' || a_value_s;
   ELSIF ( l_lt_cnt > 0 ) AND ( l_gt_cnt > 0 ) THEN
      /* insert '~ ' in front of string result */
      a_value_s := '~ ' || a_value_s;
   END IF;
   RETURN(Unapigen.DBERR_SUCCESS);
END Average;

END Uncalc;
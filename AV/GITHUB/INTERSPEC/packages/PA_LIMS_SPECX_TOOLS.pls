create or replace PACKAGE
----------------------------------------------------------------------------
-- $Revision: 2 $
--  $Modtime: 27/05/10 12:54 $
----------------------------------------------------------------------------
PA_LIMS_SPECX_TOOLS IS

  FUNCTION COMPARE_STRING(
     vc2_string_1 VARCHAR2,
     vc2_string_2 VARCHAR2
  )
     RETURN NUMBER;
--Pragma impossible since interspec 63
--  PRAGMA RESTRICT_REFERENCES(COMPARE_STRING, WNDS, WNPS, RNDS, RNPS);

  FUNCTION COMPARE_FLOAT(
     fl_float_1 FLOAT,
     fl_float_2 FLOAT
  )
     RETURN NUMBER;
--Pragma impossible since interspec 63
--  PRAGMA RESTRICT_REFERENCES(COMPARE_FLOAT, WNDS, WNPS, RNDS, RNPS);

  FUNCTION COMPARE_NUMBER(
     n_number_1 NUMBER,
     n_number_2 NUMBER
  )
     RETURN NUMBER;
--Pragma impossible since interspec 63
--  PRAGMA RESTRICT_REFERENCES(COMPARE_NUMBER, WNDS, WNPS, RNDS, RNPS);

  FUNCTION COMPARE_DATE(
     dt_date_1 DATE,
     dt_date_2 DATE
  )
     RETURN NUMBER;
--Pragma impossible since interspec 63
--  PRAGMA RESTRICT_REFERENCES(COMPARE_DATE, WNDS, WNPS, RNDS, RNPS);

END PA_LIMS_SPECX_TOOLS;
 
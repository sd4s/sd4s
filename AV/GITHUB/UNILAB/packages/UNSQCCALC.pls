create or replace PACKAGE
unsqccalc AS
-- SIMATIC IT UNILAB package
-- $Revision: 6.3.1 (06.03.01.00_10.01) $
-- $Date: 2007-10-04T16:42:00 $
l_obj_cursor               INTEGER;

FUNCTION SQCCalc
(
   a_ch                   IN       VARCHAR2, /* VC20_TYPE  */
   a_datapoint_seq        IN       NUMBER,   /* NUM_TYPE */
   a_measure_seq          IN       NUMBER    /* NUM_TYPE */
)  RETURN NUMBER;

FUNCTION WesternElectricRules
(
 a_ch                  IN       VARCHAR2, /* VC20_TYPE  */
 a_datapoint_seq       IN       NUMBER,   /* NUM_TYPE */
 a_measure_seq         IN       NUMBER,   /* NUM_TYPE */
 a_rule1_violated      OUT      CHAR,     /* CHAR1_TYPE */
 a_rule2_violated      OUT      CHAR,     /* CHAR1_TYPE */
 a_rule3_violated      OUT      CHAR,     /* CHAR1_TYPE */
 a_rule4_violated      OUT      CHAR,     /* CHAR1_TYPE */
 a_rule5_violated      OUT      CHAR,     /* CHAR1_TYPE */
 a_rule6_violated      OUT      CHAR,     /* CHAR1_TYPE */
 a_rule7_violated      OUT      CHAR,     /* CHAR1_TYPE */
 a_rule8_violated      OUT      CHAR      /* CHAR1_TYPE */
) RETURN NUMBER ;

FUNCTION SQCCalcChart
(
 a_ch                  IN       VARCHAR2 /* VC20_TYPE  */
)  RETURN NUMBER ;

FUNCTION InitSQCChart
(
 a_ch                  IN       VARCHAR2, /* VC20_TYPE  */
 a_sqc_avg             IN       NUMBER,   /* NUM_TYPE */
 a_sqc_std_dev         IN       NUMBER,   /* NUM_TYPE */
 a_sqc_avg_range       IN       NUMBER,   /* NUM_TYPE */
 a_sqc_std_dev_range   IN       NUMBER   /* NUM_TYPE */
)  RETURN NUMBER ;

FUNCTION TREND_CHART
(
   a_ch                IN       VARCHAR2, /* VC20_TYPE  */
   a_datapoint_seq     IN       NUMBER,   /* NUM_TYPE */
   a_measure_seq       IN       NUMBER    /* NUM_TYPE */
)  RETURN NUMBER;

FUNCTION CONTROL_CHART
(
   a_ch                IN       VARCHAR2, /* VC20_TYPE  */
   a_datapoint_seq     IN       NUMBER,   /* NUM_TYPE */
   a_measure_seq       IN       NUMBER    /* NUM_TYPE */
)  RETURN NUMBER;

FUNCTION CONTROL_CHART_ADV
(
 a_ch                   IN       VARCHAR2, /* VC20_TYPE  */
 a_datapoint_seq        IN       NUMBER,   /* NUM_TYPE */
 a_measure_seq          IN       NUMBER    /* NUM_TYPE */
)  RETURN NUMBER;

FUNCTION AVG_STD_DEV_new_point
(
 a_ch                   IN       VARCHAR2, /* VC20_TYPE  */
 a_datapoint_seq        IN       NUMBER,   /* NUM_TYPE */
 a_measure_seq          IN       NUMBER    /* NUM_TYPE */
)  RETURN NUMBER;
FUNCTION AVG_STD_DEV_first_point
(
 a_ch                   IN       VARCHAR2, /* VC20_TYPE  */
 a_datapoint_seq        IN       NUMBER,   /* NUM_TYPE */
 a_measure_seq          IN       NUMBER    /* NUM_TYPE */
)  RETURN NUMBER;

END unsqccalc;
 
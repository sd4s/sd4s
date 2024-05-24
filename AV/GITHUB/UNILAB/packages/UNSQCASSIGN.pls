create or replace PACKAGE
unsqcassign AS
-- Unilab 5.0 Package
-- $Revision: 2 $
-- $Date: 1/03/05 16:25 $
l_obj_cursor               INTEGER;

FUNCTION SQCAssign
(
   a_cy                  IN           VARCHAR2, /* VC20_TYPE */
   a_ch_context_key      IN OUT       VARCHAR2, /* VC255_TYPE */
   a_data_point_link     IN           VARCHAR2, /* VC255_TYPE */
   a_ch                  OUT          VARCHAR2, /* VC20_TYPE */
   a_datapoint_seq       OUT          NUMBER  , /* NUM_TYPE */
   a_measure_seq         OUT          NUMBER    /* NUM_TYPE */
)  RETURN NUMBER;

FUNCTION SQCDeAssign
(a_cy                  IN           VARCHAR2, /* VC20_TYPE  */
 a_ch_context_key      IN OUT       VARCHAR2, /* VC255_TYPE */
 a_data_point_link     IN           VARCHAR2, /* VC255_TYPE */
 a_ch                  OUT          VARCHAR2, /* VC20_TYPE */
 a_datapoint_seq       OUT          NUMBER  , /* NUM_TYPE */
 a_measure_seq         OUT          NUMBER  ) /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GenerateChartID
(
   a_cy                  IN           VARCHAR2,  /* VC20_TYPE  */
   a_ch_context_key      IN           VARCHAR2,  /* VC255_TYPE */
   a_ch                  OUT          VARCHAR2   /* VC20_TYPE  */
)
RETURN NUMBER;

FUNCTION CONTROL_CHART
(
   a_cy                  IN           VARCHAR2, /* VC20_TYPE */
   a_ch_context_key      IN OUT       VARCHAR2, /* VC255_TYPE */
   a_data_point_link     IN           VARCHAR2, /* VC255_TYPE */
   a_ch                  OUT          VARCHAR2, /* VC20_TYPE */
   a_datapoint_seq       OUT          NUMBER  , /* NUM_TYPE */
   a_measure_seq         OUT          NUMBER    /* NUM_TYPE */
)  RETURN NUMBER;

FUNCTION TREND_CHART
(
   a_cy                  IN           VARCHAR2, /* VC20_TYPE */
   a_ch_context_key      IN OUT       VARCHAR2, /* VC255_TYPE */
   a_data_point_link     IN           VARCHAR2, /* VC255_TYPE */
   a_ch                  OUT          VARCHAR2, /* VC20_TYPE */
   a_datapoint_seq       OUT          NUMBER  , /* NUM_TYPE */
   a_measure_seq         OUT          NUMBER    /* NUM_TYPE */
)  RETURN NUMBER;


FUNCTION DEASSIGN_CONTROL_CHART
(a_cy                  IN           VARCHAR2, /* VC20_TYPE */
 a_ch_context_key      IN OUT       VARCHAR2, /* VC255_TYPE */
 a_data_point_link     IN           VARCHAR2, /* VC255_TYPE */
 a_ch                  OUT          VARCHAR2, /* VC20_TYPE */
 a_datapoint_seq       OUT          NUMBER  , /* NUM_TYPE */
 a_measure_seq         OUT          NUMBER  ) /* NUM_TYPE */
RETURN NUMBER;

FUNCTION DEASSIGN_TREND_CHART
(a_cy                  IN           VARCHAR2, /* VC20_TYPE */
 a_ch_context_key      IN OUT       VARCHAR2, /* VC255_TYPE */
 a_data_point_link     IN           VARCHAR2, /* VC255_TYPE */
 a_ch                  OUT          VARCHAR2, /* VC20_TYPE */
 a_datapoint_seq       OUT          NUMBER  , /* NUM_TYPE */
 a_measure_seq         OUT          NUMBER  ) /* NUM_TYPE */
RETURN NUMBER;

FUNCTION AdjustContextKey
(a_cy                  IN           VARCHAR2, /* VC20_TYPE */
 a_ch_context_key      IN OUT       VARCHAR2, /* VC255_TYPE */
 a_data_point_link     IN           VARCHAR2) /* VC255_TYPE */
RETURN NUMBER;

END unsqcassign;
 
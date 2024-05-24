create or replace PACKAGE
-- Unilab 6.7 Package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapicy AS

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION SaveChartType
(a_cy                      IN    VARCHAR2,                    /* VC20_TYPE */
 a_version                 IN    VARCHAR2,                    /* VC20_TYPE */
 a_version_is_current      IN    CHAR,                        /* CHAR1_TYPE */
 a_effective_from          IN    DATE,                        /* DATE_TYPE */
 a_effective_till          IN    DATE,                        /* DATE_TYPE */
 a_description             IN    VARCHAR2,                     /* VC40_TYPE */
 a_description2            IN    VARCHAR2,                     /* VC40_TYPE */
 a_is_template             IN    CHAR,                         /* CHAR1_TYPE */
 a_chart_title             IN    VARCHAR2,                     /* VC255_TYPE */
 a_x_axis_title            IN    VARCHAR2,                     /* VC255_TYPE */
 a_y_axis_title            IN    VARCHAR2,                     /* VC255_TYPE */
 a_y_axis_unit             IN    VARCHAR2,                     /* VC20_TYPE */
 a_x_label                 IN    VARCHAR2,                     /* VC60_TYPE */
 a_datapoint_cnt           IN    NUMBER,                       /* NUM_TYPE */
 a_datapoint_unit          IN    VARCHAR2,                     /* VC20_TYPE */
 a_xr_measurements         IN    NUMBER,                       /* NUM_TYPE */
 a_xr_max_charts           IN    NUMBER,                       /* NUM_TYPE */
 a_assign_cf               IN    VARCHAR2,                     /* VC255_TYPE */
 a_cy_calc_cf              IN    VARCHAR2,                     /* VC255_TYPE */
 a_visual_cf               IN    VARCHAR2,                     /* VC255_TYPE */
 a_ch_lc                   IN    VARCHAR2,                     /* VC2_TYPE */
 a_ch_lc_version           IN    VARCHAR2,                     /* VC20_TYPE */
 a_inherit_au              IN    CHAR,                         /* CHAR1_TYPE */
 a_cy_class                IN    VARCHAR2,                     /* VC2_TYPE */
 a_log_hs                  IN    CHAR,                         /* CHAR1_TYPE */
 a_lc                      IN    VARCHAR2,                     /* VC2_TYPE */
 a_lc_version              IN    VARCHAR2,                     /* VC20_TYPE */
 a_modify_reason           IN    VARCHAR2)                     /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SaveChartType
(a_cy                      IN    VARCHAR2,                    /* VC20_TYPE */
 a_version                 IN    VARCHAR2,                    /* VC20_TYPE */
 a_version_is_current      IN    CHAR,                        /* CHAR1_TYPE */
 a_effective_from          IN    DATE,                        /* DATE_TYPE */
 a_effective_till          IN    DATE,                        /* DATE_TYPE */
 a_description             IN    VARCHAR2,                     /* VC40_TYPE */
 a_description2            IN    VARCHAR2,                     /* VC40_TYPE */
 a_is_template             IN    CHAR,                         /* CHAR1_TYPE */
 a_chart_title             IN    VARCHAR2,                     /* VC255_TYPE */
 a_x_axis_title            IN    VARCHAR2,                     /* VC255_TYPE */
 a_y_axis_title            IN    VARCHAR2,                     /* VC255_TYPE */
 a_y_axis_unit             IN    VARCHAR2,                     /* VC20_TYPE */
 a_x_label                 IN    VARCHAR2,                     /* VC60_TYPE */
 a_datapoint_cnt           IN    NUMBER,                       /* NUM_TYPE */
 a_datapoint_unit          IN    VARCHAR2,                     /* VC20_TYPE */
 a_xr_measurements         IN    NUMBER,                       /* NUM_TYPE */
 a_xr_max_charts           IN    NUMBER,                       /* NUM_TYPE */
 a_assign_cf               IN    VARCHAR2,                     /* VC255_TYPE */
 a_cy_calc_cf              IN    VARCHAR2,                     /* VC255_TYPE */
 a_visual_cf               IN    VARCHAR2,                     /* VC255_TYPE */
 a_valid_sqc_rule1         IN    VARCHAR2,                     /* VC255_TYPE */
 a_valid_sqc_rule2         IN    VARCHAR2,                     /* VC255_TYPE */
 a_valid_sqc_rule3         IN    VARCHAR2,                     /* VC255_TYPE */
 a_valid_sqc_rule4         IN    VARCHAR2,                     /* VC255_TYPE */
 a_valid_sqc_rule5         IN    VARCHAR2,                     /* VC255_TYPE */
 a_valid_sqc_rule6         IN    VARCHAR2,                     /* VC255_TYPE */
 a_valid_sqc_rule7         IN    VARCHAR2,                     /* VC255_TYPE */
 a_ch_lc                   IN    VARCHAR2,                     /* VC2_TYPE */
 a_ch_lc_version           IN    VARCHAR2,                     /* VC20_TYPE */
 a_inherit_au              IN    CHAR,                         /* CHAR1_TYPE */
 a_cy_class                IN    VARCHAR2,                     /* VC2_TYPE */
 a_log_hs                  IN    CHAR,                         /* CHAR1_TYPE */
 a_lc                      IN    VARCHAR2,                     /* VC2_TYPE */
 a_lc_version              IN    VARCHAR2,                     /* VC20_TYPE */
 a_modify_reason           IN    VARCHAR2)                     /* VC255_TYPE */
RETURN NUMBER;

FUNCTION DeleteChartType
(a_cy                  IN       VARCHAR2,    /* VC20_TYPE */
 a_version             IN       VARCHAR2,    /* VC20_TYPE */
 a_modify_reason       IN       VARCHAR2)    /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GetChartType
(a_cy                      OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_version                 OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_version_is_current      OUT      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_effective_from          OUT      UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_effective_till          OUT      UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_description             OUT      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_description2            OUT      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_is_template             OUT      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_chart_title             OUT      UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_x_axis_title            OUT      UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_y_axis_title            OUT      UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_y_axis_unit             OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_x_label                 OUT      UNAPIGEN.VC60_TABLE_TYPE,  /* VC60_TABLE_TYPE */
 a_datapoint_cnt           OUT      UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_datapoint_unit          OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_xr_measurements         OUT      UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_xr_max_charts           OUT      UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_assign_cf               OUT      UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_cy_calc_cf              OUT      UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_visual_cf               OUT      UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_ch_lc                   OUT      UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_ch_lc_version           OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_inherit_au              OUT      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_cy_class                OUT      UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_log_hs                  OUT      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_allow_modify            OUT      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_active                  OUT      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_lc                      OUT      UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_lc_version              OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_ss                      OUT      UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_nr_of_rows              IN OUT   NUMBER,                    /* NUM_TYPE */
 a_where_clause            IN       VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetChartType
(a_cy                      OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_version                 OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_version_is_current      OUT      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_effective_from          OUT      UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_effective_till          OUT      UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_description             OUT      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_description2            OUT      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_is_template             OUT      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_chart_title             OUT      UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_x_axis_title            OUT      UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_y_axis_title            OUT      UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_y_axis_unit             OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_x_label                 OUT      UNAPIGEN.VC60_TABLE_TYPE,  /* VC60_TABLE_TYPE */
 a_datapoint_cnt           OUT      UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_datapoint_unit          OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_xr_measurements         OUT      UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_xr_max_charts           OUT      UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_assign_cf               OUT      UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_cy_calc_cf              OUT      UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_visual_cf               OUT      UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_valid_sqc_rule1         OUT      UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_valid_sqc_rule2         OUT      UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_valid_sqc_rule3         OUT      UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_valid_sqc_rule4         OUT      UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_valid_sqc_rule5         OUT      UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_valid_sqc_rule6         OUT      UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_valid_sqc_rule7         OUT      UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_ch_lc                   OUT      UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_ch_lc_version           OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_inherit_au              OUT      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_cy_class                OUT      UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_log_hs                  OUT      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_allow_modify            OUT      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_active                  OUT      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_lc                      OUT      UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_lc_version              OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_ss                      OUT      UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_nr_of_rows              IN OUT   NUMBER,                    /* NUM_TYPE */
 a_where_clause            IN       VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetChartTypeList
(a_cy                      OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_version                 OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_version_is_current      OUT      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_effective_from          OUT      UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_effective_till          OUT      UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_description             OUT      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_ss                      OUT      UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_nr_of_rows              IN OUT   NUMBER,                    /* NUM_TYPE */
 a_where_clause            IN       VARCHAR2,                  /* VC511_TYPE */
 a_next_rows               IN       NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetCyStyle
(a_visual_cf             OUT      UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_cy                    OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_version               OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_prop_name             OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_prop_value            OUT      UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_nr_of_rows            IN OUT   NUMBER,                    /* NUM_TYPE */
 a_where_clause          IN       VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION SaveCyStyle
(a_visual_cf              IN    VARCHAR2,                     /* VC255_TYPE */
 a_cy                     IN    VARCHAR2,                     /* VC20_TYPE */
 a_version                IN    VARCHAR2,                     /* VC20_TYPE */
 a_prop_name              IN    UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_prop_value             IN    UNAPIGEN.VC255_TABLE_TYPE,    /* VC255_TABLE_TYPE */
 a_nr_of_rows             IN    NUMBER,                       /* NUM_TYPE */
 a_modify_reason          IN    VARCHAR2)                     /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GetCyStyleList
(a_visual_cf             OUT      UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_cy                    OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_version               OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_prop_name             OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_prop_value            OUT      UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_nr_of_rows            IN OUT   NUMBER,                    /* NUM_TYPE */
 a_where_clause          IN       VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION SaveCyStyleList
(a_visual_cf              IN    VARCHAR2,                     /* VC255_TYPE */
 a_cy                     IN    VARCHAR2,                     /* VC20_TYPE */
 a_version                IN    VARCHAR2,                     /* VC20_TYPE */
 a_prop_name              IN    UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_prop_value             IN    UNAPIGEN.VC255_TABLE_TYPE,    /* VC255_TABLE_TYPE */
 a_nr_of_rows             IN    NUMBER,                       /* NUM_TYPE */
 a_modify_reason          IN    VARCHAR2)                     /* VC255_TYPE */
RETURN NUMBER;

END unapicy;
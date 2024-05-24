create or replace PACKAGE BODY
unsqccalc AS
-- SIMATIC IT UNILAB package
-- $Revision: 6.3.1 (06.03.01.00_10.01) $
-- $Date: 2007-10-04T16:42:00 $
-- 23/08/2016 | JP | Added object ID quoting in CONTROL_CHART, CONTROL_CHART_ADV, TREND_CHART
l_sqlerrm         VARCHAR2(255);
l_sql_string      VARCHAR2(10000);
l_where_clause    VARCHAR2(10000);
l_order_by_clause VARCHAR2(1000);
l_event_tp        utev.ev_tp%TYPE;
l_ret_code        NUMBER;
l_result          NUMBER;
l_fetched_rows    NUMBER;
l_ev_seq_nr       NUMBER;
l_ev_details      VARCHAR2(255);
StpError          EXCEPTION;

/*
+---------------------------------------------------------------------------------------------
| The function SQCCalc does the necessary data manipulations needed after the saving of a datapoint
| This includes: -> setting the sqc values of the new datapoint (which might include checking if the western Electric rules are not violated)
|                -> deleting old datapoints in a trend,
|                -> closing old control charts
|
| The name of this function (nor the arguments) can ever be changed or modified
| because this function is the "hook" between the standard packages and the actual custom calculation functions
| Although the contents of this function might/could be modified to meet specific project requirements,
| this is strongly discouraged (because it is assumed that any project requirement can be completely handled
| inside the custom calculation function (without the altering the SQCCalc function).
+---------------------------------------------------------------------------------------------
*/

FUNCTION SQCCalc
(
 a_ch                   IN       VARCHAR2, /* VC20_TYPE  */
 a_datapoint_seq        IN       NUMBER,   /* NUM_TYPE */
 a_measure_seq          IN       NUMBER    /* NUM_TYPE */
)  RETURN NUMBER IS

l_datapoint_cnt      NUMBER;
l_datapoint_unit     VARCHAR2(20);
l_cy_calc_cf            VARCHAR2(255);
l_assign_cf          VARCHAR2(255);
l_sqc_avg            NUMBER;
l_sqc_std_dev        NUMBER;
l_sqc_avg_range      NUMBER;
l_sqc_std_dev_range  NUMBER;
l_ch_context_key     VARCHAR2(255);
l_cy                 VARCHAR2(20);
l_ref_date           TIMESTAMP WITH TIME ZONE;
l_time_based         BOOLEAN;
l_nr_datapoints      NUMBER;
l_creation_date      TIMESTAMP WITH TIME ZONE;
l_sql_string         VARCHAR2(1000);
l_ret_code           NUMBER;
l_pos                NUMBER;
l_pos2               NUMBER;
l_arguments          VARCHAR2(255);

l_rule1_violated     CHAR(1);
l_rule2_violated     CHAR(1);
l_rule3_violated     CHAR(1);
l_rule4_violated     CHAR(1);
l_rule5_violated     CHAR(1);
l_rule6_violated     CHAR(1);
l_rule7_violated     CHAR(1);
l_rule8_violated     CHAR(1);
l_datapoint_marker   VARCHAR2(20);
l_datapoint_colour   VARCHAR2(20);
l_error              EXCEPTION;

CURSOR c_ch(lc_ch VARCHAR2) IS
SELECT sqc_avg, sqc_std_dev, sqc_avg_range, sqc_std_dev_range, ch_context_key,
       cy, datapoint_cnt, datapoint_unit, creation_date, cy_calc_cf, assign_cf from utch
   WHERE ch = lc_ch;

CURSOR c_nr_datapoints(lc_ch VARCHAR2) IS
   SELECT count(distinct datapoint_seq) from utchdp
      WHERE ch = lc_ch;

BEGIN
   IF NVL(a_ch, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE  l_error;
   END IF;

   IF UNAPIGEN.BeginTxn(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE l_error;
   END IF;

   -- set the sqc values for the datapoint
   OPEN c_ch (a_ch );
   FETCH c_ch INTO
      l_sqc_avg, l_sqc_std_dev, l_sqc_avg_range, l_sqc_std_dev_range,
      l_ch_context_key, l_cy, l_datapoint_cnt, l_datapoint_unit, l_creation_date, l_cy_calc_cf, l_assign_cf;
   CLOSE c_ch;

   IF NVL(l_cy_calc_cf, ' ') =' ' THEN
      l_cy_calc_cf := 'TREND_CHART';
   END IF;

   IF InStr(l_cy_calc_cf, '(' ) = 0 THEN  -- add arguments to the function call
      l_cy_calc_cf := l_cy_calc_cf || '( :l_ch, :l_datapoint_seq, :l_measure_seq)';
   ELSE --always append the three arguments before the closing ")"
      l_pos := InStr(l_cy_calc_cf, '(' );
      l_pos2 := InStr(l_cy_calc_cf, ')' );
      --find the last ")"
      WHILE InStr(l_cy_calc_cf, ')', l_pos2 +1  ) > 0 LOOP
         l_pos2 := InStr(l_cy_calc_cf, ')', l_pos2 +1  );
      END LOOP;
      l_arguments := SUBSTR(l_cy_calc_cf, l_pos + 1, l_pos2 - l_pos - 1);
      IF LTRIM(l_arguments) <> '' THEN
         l_cy_calc_cf := SUBSTR(l_cy_calc_cf, 1, l_pos2 - 1) ||  ', :l_ch, :l_datapoint_seq, :l_measure_seq)';
      ELSE
         l_cy_calc_cf := SUBSTR(l_cy_calc_cf, 1, l_pos - 1) || '( :l_ch, :l_datapoint_seq, :l_measure_seq)';
      END IF;
   END IF;

   l_sql_string := 'BEGIN :l_retcode := UNSQCCALC.' || l_cy_calc_cf || -- NO single quote handling required
                   '; END;';
   BEGIN
      EXECUTE IMMEDIATE l_sql_string
       USING OUT l_ret_code, a_ch, a_datapoint_seq, a_measure_seq ;
   EXCEPTION
   WHEN OTHERS THEN
      l_sqlerrm := SUBSTR(SQLERRM,1,255);
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
      RAISE l_error;
   END;

   IF UNAPIGEN.EndTxn <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE l_error;
   END IF;

   RETURN (UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF sqlcode <> 1 THEN
      UNAPIGEN.LogError('SQCCalc',sqlerrm);
   ELSIF l_sqlerrm IS NOT NULL THEN
      UNAPIGEN.LogError('SQCCalc',l_sqlerrm);
   END IF ;
   RETURN(UNAPIGEN.AbortTxn(UNAPIGEN.P_TXN_ERROR,'SQCCalc'));
END SQCCalc;

/*
+---------------------------------------------------------------------------------------------
| The function WesternElectricRules checks wether one or more Western Electric Rules are violated:
|
| Rule 1: any point beyond the 3 std_dev limit
| Rule 2: 2 Out of the Last 3 Points higher    than (avg + 2*std_dev) OR  lower  than (avg - 2*std_dev)
| Rule 3: 4 Out of the Last 5 Points higher    than (avg +   std_dev) OR  lower  than (avg -   std_dev)
| Rule 4: 8 Consecutive Points higher or lower than  avg
| Rule 5: 15 or more points in a row lower     than (avg +   std_dev) AND higher than (avg -   std_dev)
| Rule 6: 8 points in a row          higher    than (avg +   std_dev) AND lower  than (avg -   std_dev)
| -------
| Rule 7: Systematic or cyclic patterns --------- (not implemented)
| -------
| Rule 8: 6 in a row trending up or down (NOTE: equal values do NOT break the trend)
|
| NOTE: the function also considers datapoints from a previous chart to verify a rule!
| ~~~~~
|
+---------------------------------------------------------------------------------------------
|
| IN arguments: - a_ch            : chart ID
|               - a_datapoint_seq : datapoint sequence
|               - a_measure_seq   : measurement sequence
|
| OUT arguments - a_rule1_violated  [ 0 | 1 ]
|               - ...
|               - a_rule5_violated  [ 0 | 1 ]
|
+---------------------------------------------------------------------------------------------
| Although this function could be customised, it is strongly discouraged to do so.
| These rules have been carefully tested to meet the standard definition. If one needs, for whatever reason,
| some alternative version(s) of these rules, the proper/preferred aproach is to copy this function and use
| an alternative name to clearly indicate that this a slightly different version of the rules.
|
| NOTE: This function can never be called directly from within "SQCCalc" because it is not a calculation function
| ~~~~~ (it is just an auxiliary function to make the code more readible)
+---------------------------------------------------------------------------------------------
*/

FUNCTION WesternElectricRules
(
 a_ch                   IN       VARCHAR2, /* VC20_TYPE  */
 a_datapoint_seq        IN       NUMBER,   /* NUM_TYPE */
 a_measure_seq          IN       NUMBER,   /* NUM_TYPE */
 a_rule1_violated       OUT      CHAR,     /* CHAR1_TYPE */
 a_rule2_violated       OUT      CHAR,     /* CHAR1_TYPE */
 a_rule3_violated       OUT      CHAR,     /* CHAR1_TYPE */
 a_rule4_violated       OUT      CHAR,     /* CHAR1_TYPE */
 a_rule5_violated       OUT      CHAR,     /* CHAR1_TYPE */
 a_rule6_violated       OUT      CHAR,     /* CHAR1_TYPE */
 a_rule7_violated       OUT      CHAR,     /* CHAR1_TYPE */
 a_rule8_violated       OUT      CHAR      /* CHAR1_TYPE */
) RETURN NUMBER IS

l_rule1_violated     CHAR(1);
l_rule2_violated     CHAR(1);
l_rule3_violated     CHAR(1);
l_rule4_violated     CHAR(1);
l_rule5_violated     CHAR(1);
l_rule6_violated     CHAR(1);
l_rule7_violated     CHAR(1);
l_rule8_violated     CHAR(1);

l_cy                 VARCHAR2(20);
l_ch_context_key     VARCHAR2(255);
l_sqc_avg            NUMBER;
l_sqc_std_dev        NUMBER;
l_sqc_avg_range      NUMBER;
l_sqc_std_dev_range  NUMBER;
l_ch                 VARCHAR2(20);
l_ch_creation_date   TIMESTAMP WITH TIME ZONE;
l_datapoint_value_f  NUMBER;
l_datapoint_range    NUMBER;

l_nr_3_std_dev       NUMBER;
l_nr_above_2_std_dev NUMBER;
l_nr_below_2_std_dev NUMBER;
l_nr_above_1_std_dev NUMBER;
l_nr_below_1_std_dev NUMBER;
l_nr_above_avg       NUMBER;
l_nr_below_avg       NUMBER;
l_nr_trending_up     NUMBER;
l_nr_trending_down   NUMBER;
l_nr_rule5           NUMBER;
l_nr_rule6           NUMBER;
l_datapoint_seq      NUMBER;
l_measure_seq        NUMBER;
l_last_value         NUMBER;
l_count              NUMBER;

CURSOR c_ch(lc_ch IN VARCHAR2) IS
SELECT  cy, ch_context_key, sqc_avg, sqc_std_dev, sqc_avg_range, sqc_std_dev_range, creation_date
   from utch where
    ch = lc_ch;

/* a.measure_seq must be removed from the result-set of this cursor! */

CURSOR c_last_datapoints (c_ch VARCHAR2, c_datapoint_seq NUMBER) IS
SELECT   datapoint_value_f, datapoint_range, sqc_avg, sqc_std_dev, datapoint_seq
   FROM utchdp WHERE
   ch = c_ch and
   measure_seq = 0 and
   datapoint_seq < (c_datapoint_seq +1) AND
   active = '1'
   order by  datapoint_seq desc;

CURSOR c_previous_chart_in_serie (l_cy VARCHAR2, l_ch_context_key VARCHAR2, l_ch VARCHAR2, l_ch_creation_date DATE) IS
SELECT ch, creation_date from utch
   where cy = l_cy
      and ch_context_key = l_ch_context_key
      and creation_date =
      (SELECT MAX(creation_date) from utch
         where cy = l_cy
         and ch_context_key = l_ch_context_key
         and creation_date < l_ch_creation_date );

BEGIN
   OPEN c_ch (a_ch );
   FETCH c_ch INTO l_cy, l_ch_context_key, l_sqc_avg, l_sqc_std_dev, l_sqc_avg_range,
           l_sqc_std_dev_range, l_ch_creation_date;
   CLOSE c_ch;

   l_ch := a_ch;

   OPEN c_last_datapoints (l_ch, a_datapoint_seq);
   FETCH c_last_datapoints INTO l_datapoint_value_f, l_datapoint_range, l_sqc_avg, l_sqc_std_dev, l_datapoint_seq;

   l_nr_3_std_dev       :=  0;
   l_nr_above_2_std_dev :=  0;
   l_nr_below_2_std_dev :=  0;
   l_nr_above_1_std_dev :=  0;
   l_nr_below_1_std_dev :=  0;
   l_nr_above_avg       :=  0;
   l_nr_below_avg       :=  0;
   l_nr_trending_up     :=  0;
   l_nr_trending_down   :=  0;
   l_nr_rule5           :=  0;
   l_nr_rule6           :=  0;

   l_rule1_violated     :=  '0';
   l_rule2_violated     :=  '0';
   l_rule3_violated     :=  '0';
   l_rule4_violated     :=  '0';
   l_rule5_violated     :=  '0';
   l_rule6_violated     :=  '0';
   l_rule7_violated     :=  '0';
   l_rule8_violated     :=  '0';

   --look in which range the current datapoint is.
   IF (l_datapoint_value_f < l_sqc_avg ) THEN
      l_nr_below_avg := l_nr_below_avg + 1;
      IF (l_datapoint_value_f < (l_sqc_avg -  l_sqc_std_dev))  THEN
         l_nr_below_1_std_dev := l_nr_below_1_std_dev  + 1;
         l_nr_rule6 := l_nr_rule6 + 1;
         IF (l_datapoint_value_f < (l_sqc_avg - 2 * l_sqc_std_dev))  THEN
            l_nr_below_2_std_dev := l_nr_below_2_std_dev  + 1;
            IF (l_datapoint_value_f <  (l_sqc_avg -  3 * l_sqc_std_dev))  THEN
               l_nr_3_std_dev := l_nr_3_std_dev  + 1;
            END IF;
         END IF;
      ELSE
         l_nr_rule5 := l_nr_rule5 + 1;
      END IF;
   ELSIF (l_datapoint_value_f > l_sqc_avg ) THEN
      l_nr_above_avg := l_nr_above_avg + 1;
      IF (l_datapoint_value_f > (l_sqc_avg +  l_sqc_std_dev))  THEN
         l_nr_above_1_std_dev := l_nr_above_1_std_dev  + 1;
         IF (l_datapoint_value_f >  (l_sqc_avg +  2 * l_sqc_std_dev))  THEN
            l_nr_above_2_std_dev := l_nr_above_2_std_dev  + 1;
            l_nr_rule6 := l_nr_rule6 + 1;
            IF (l_datapoint_value_f > (l_sqc_avg +  3 * l_sqc_std_dev))  THEN
               l_nr_3_std_dev := l_nr_3_std_dev  + 1;
            END IF;
         END IF;
      ELSE
         l_nr_rule5 := l_nr_rule5 + 1;
      END IF;
   END IF;

   l_last_value := l_datapoint_value_f;

   l_count := 0;
   FETCH c_last_datapoints into l_datapoint_value_f, l_datapoint_range, l_sqc_avg, l_sqc_std_dev, l_datapoint_seq;
   LOOP
      IF c_last_datapoints%NOTFOUND THEN
         -- look in the previous chart
         OPEN c_previous_chart_in_serie (l_cy, l_ch_context_key, l_ch , l_ch_creation_date);
         FETCH c_previous_chart_in_serie INTO l_ch, l_ch_creation_date;
         EXIT WHEN c_previous_chart_in_serie%NOTFOUND;
         CLOSE c_previous_chart_in_serie;
         -- fetch info about the previous chart
         OPEN c_ch (l_ch );
         FETCH c_ch INTO l_cy, l_ch_context_key, l_sqc_avg, l_sqc_std_dev, l_sqc_avg_range,
                 l_sqc_std_dev_range, l_ch_creation_date;
         CLOSE c_ch;
         -- fetch the last datapoint of that chart
         CLOSE c_last_datapoints;
         OPEN c_last_datapoints (l_ch, 9999);
         FETCH c_last_datapoints INTO l_datapoint_value_f, l_datapoint_range, l_sqc_avg, l_sqc_std_dev, l_datapoint_seq;
      END IF;

      EXIT WHEN c_last_datapoints%NOTFOUND; -- we have done our best

      IF (l_datapoint_value_f IS NOT NULL) THEN
            l_count := l_count + 1;
            IF (l_datapoint_value_f < l_sqc_avg )   THEN  -- Below average
               IF ( l_count < 8 ) THEN -- rule 4
                  l_nr_below_avg := l_nr_below_avg + 1;
               END IF;
               IF (l_datapoint_value_f < (l_sqc_avg -  l_sqc_std_dev))  THEN
                  IF ( l_count < 5 ) THEN
                     l_nr_below_1_std_dev := l_nr_below_1_std_dev  + 1;
                  END IF;
                  IF ( l_count < 8 ) THEN
                     l_nr_rule6 := l_nr_rule6  + 1;
                  END IF;
                  IF (l_datapoint_value_f < (l_sqc_avg - 2 * l_sqc_std_dev))  THEN
                     IF ( l_count < 3 ) THEN
                        l_nr_below_2_std_dev := l_nr_below_2_std_dev  + 1;
                     END IF;
                  END IF;
               ELSE
                  l_nr_rule5 := l_nr_rule5 + 1;
               END IF;
            ELSIF (l_datapoint_value_f > l_sqc_avg )   THEN -- above average
               IF ( l_count < 8 ) THEN -- rule 4
                  l_nr_above_avg := l_nr_above_avg + 1;
               END IF;
               IF (l_datapoint_value_f > (l_sqc_avg +  l_sqc_std_dev))  THEN
                  IF ( l_count < 5 ) THEN
                     l_nr_above_1_std_dev := l_nr_above_1_std_dev  + 1;
                  END IF;
                  IF ( l_count < 8 ) THEN
                     l_nr_rule6 := l_nr_rule6  + 1;
                  END IF;
                  IF ( l_count < 3 ) THEN
                     IF (l_datapoint_value_f >  (l_sqc_avg +  2 * l_sqc_std_dev))  THEN
                        l_nr_above_2_std_dev := l_nr_above_2_std_dev  + 1;
                     END IF;
                  END IF;
               ELSE
                  l_nr_rule5 := l_nr_rule5 + 1;
               END IF;
            END IF;
            IF (l_count < 7) THEN
               IF (l_datapoint_value_f <= l_last_value) THEN
                  l_nr_trending_up := l_nr_trending_up + 1;
               ELSIF (l_datapoint_value_f >= l_last_value) THEN
                  l_nr_trending_down := l_nr_trending_down + 1;
               END IF;
            END IF;
         END IF;
      EXIT WHEN (l_count  = 14);
      l_last_value := l_datapoint_value_f;
      FETCH c_last_datapoints into l_datapoint_value_f, l_datapoint_range, l_sqc_avg, l_sqc_std_dev, l_datapoint_seq;
   END LOOP;
   CLOSE c_last_datapoints;

   IF l_nr_3_std_dev > 0 THEN
      l_rule1_violated := '1';
   END IF;
   IF (l_nr_below_2_std_dev > 1) or (l_nr_above_2_std_dev > 1) THEN
      l_rule2_violated := '1';
   END IF;
   IF (l_nr_below_1_std_dev > 3) or (l_nr_above_1_std_dev > 3) THEN
      l_rule3_violated := '1';
   END IF;
   IF (l_nr_below_avg > 7) or (l_nr_above_avg > 7) THEN
      l_rule4_violated := '1';
   END IF;
   IF l_nr_rule5 > 14 THEN
      l_rule5_violated := '1';
   END IF;
   IF l_nr_rule6 > 7 THEN
      l_rule6_violated := '1';
   END IF;
   IF (l_nr_trending_down > 5) or (l_nr_trending_up > 5) THEN
      l_rule8_violated := '1';
   END IF;

   a_rule1_violated    :=  l_rule1_violated  ;
   a_rule2_violated    :=  l_rule2_violated  ;
   a_rule3_violated    :=  l_rule3_violated  ;
   a_rule4_violated    :=  l_rule4_violated  ;
   a_rule5_violated    :=  l_rule5_violated  ;
   a_rule6_violated    :=  l_rule6_violated  ;
   a_rule7_violated    :=  l_rule7_violated  ;
   a_rule8_violated    :=  l_rule8_violated  ;

   RETURN (UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF sqlcode <> 1 THEN
      UNAPIGEN.LogError('WesternElectricRules',sqlerrm);
   END IF ;
   IF c_last_datapoints%ISOPEN THEN
      CLOSE c_last_datapoints;
   END IF;
   RETURN(UNAPIGEN.AbortTxn(UNAPIGEN.P_TXN_ERROR,'WesternElectricRules'));
END WesternElectricRules;


/* The function ApplyChartUnit is used when the unit of the chart is changed */
FUNCTION ApplyChartUnit
(
   a_ch IN VARCHAR2
)
RETURN NUMBER IS

CURSOR c_ch IS
SELECT y_axis_unit FROM utch
where ch = a_ch;

CURSOR c_datapoint IS
SELECT datapoint_seq, measure_seq, datapoint_value_s, datapoint_value_f, datapoint_link,
       spec1, spec2, spec3, spec4, spec5, spec6, spec7, spec8, spec9, spec10, spec11,
       spec12, spec13, spec14, spec15
FROM utchdp WHERE
ch = a_ch;

CURSOR c_parameter
      (lc_sc VARCHAR2, lc_pg VARCHAR2, lc_pgnode NUMBER, lc_pa VARCHAR2, lc_panode NUMBER, lc_reanalysis NUMBER) IS
   SELECT value_s, value_f, unit, format
     FROM utscpa
    WHERE sc       = lc_sc
      AND pg       = lc_pg
      AND pgnode   = lc_pgnode
      AND pa       = lc_pa
      AND panode   = lc_panode
      AND reanalysis= lc_reanalysis;

l_conv_factor NUMBER;
l_i           NUMBER;
l_ch_unit     VARCHAR2(20);
l_pa_unit     VARCHAR2(20);
l_pa_format   VARCHAR2(20);
l_pa_value_f     NUMBER;
l_pa_value_s     VARCHAR2(40);
l_chdp_value_f     NUMBER;
l_chdp_value_s     VARCHAR2(40);
l_datapoint_link  VARCHAR2(255);
l_sc                        VARCHAR2(20);
l_pg                        VARCHAR2(20);
l_pgnode                    NUMBER;
l_pa                        VARCHAR2(20);
l_panode                    NUMBER;
l_reanalysis                NUMBER;
l_Y_axis_unit               VARCHAR2(20);
l_Y_axis_format               VARCHAR2(40);

BEGIN
OPEN c_ch;
FETCH c_ch INTO l_Y_axis_unit;
CLOSE c_ch;

FOR l_chdp_rec in c_datapoint LOOP
   l_datapoint_link := l_chdp_rec.datapoint_link;
   IF INSTR( l_datapoint_link, '#', 1,5) > 0 THEN          -- pa result
       l_sc := SUBSTR(l_datapoint_link, 1,   INSTR( l_datapoint_link, '#', 1, 1) - 1);
       l_pg := SUBSTR(l_datapoint_link, INSTR( l_datapoint_link, '#', 1, 1) +1 ,   INSTR( l_datapoint_link, '#', 1, 2) - INSTR( l_datapoint_link, '#', 1, 1) - 1);
       l_pgnode := TO_NUMBER(SUBSTR(l_datapoint_link, INSTR( l_datapoint_link, '#', 1, 2) +1 ,   INSTR( l_datapoint_link, '#', 1, 3) - INSTR( l_datapoint_link, '#', 1, 2) - 1));
       l_pa := SUBSTR(l_datapoint_link, INSTR( l_datapoint_link, '#', 1, 3) +1 ,   INSTR( l_datapoint_link, '#', 1, 4) - INSTR( l_datapoint_link, '#', 1, 3) - 1);
       l_panode := TO_NUMBER(SUBSTR(l_datapoint_link, INSTR( l_datapoint_link, '#', 1,4) +1 ,   INSTR( l_datapoint_link, '#', 1, 5) - INSTR( l_datapoint_link, '#', 1, 4) - 1));
       l_reanalysis:= TO_NUMBER(SUBSTR(l_datapoint_link, INSTR( l_datapoint_link, '#', 1,5) +1));
       OPEN c_parameter(l_sc, l_pg, l_pgnode, l_pa, l_panode, l_reanalysis);
       FETCH c_parameter INTO l_pa_value_s ,l_pa_value_f ,l_pa_unit, l_pa_format;
       CLOSE c_parameter;
       l_ret_code := UNAPIGEN.TransformResult(l_pa_value_s,
                l_pa_value_f,
                l_pa_unit,
                l_pa_format,
                l_chdp_value_s,
                l_chdp_value_f,
                l_Y_axis_unit,
                l_Y_axis_format);
       IF (l_chdp_rec.datapoint_value_s <> l_chdp_value_s ) THEN --unit conversion
          l_conv_factor := l_chdp_value_f / l_chdp_rec.datapoint_value_f;
          UPDATE utchdp
          SET
            datapoint_value_s = l_chdp_value_s,
            datapoint_value_f = l_chdp_value_f,
            spec1 = spec1 * l_conv_factor,
            spec2 = spec2 * l_conv_factor,
            spec3 = spec3 * l_conv_factor
          WHERE ch = a_ch and
            datapoint_seq = l_chdp_rec.datapoint_seq and
            measure_seq = l_chdp_rec.measure_seq;
       END IF;
    END IF;
END LOOP;

RETURN (UNAPIGEN.DBERR_SUCCESS);

END ApplyChartUnit;
/*
+-----------------------------------------------------------------------------------
| The function InitSQCChart initiates sqc values for charts and calls Sqccalc for
| each active datapoint in the chart.
+-----------------------------------------------------------------------------------
*/
FUNCTION InitSQCChart
(
 a_ch                  IN       VARCHAR2, /* VC20_TYPE  */
 a_sqc_avg             IN       NUMBER,   /* NUM_TYPE */
 a_sqc_std_dev         IN       NUMBER,   /* NUM_TYPE */
 a_sqc_avg_range       IN       NUMBER,   /* NUM_TYPE */
 a_sqc_std_dev_range   IN       NUMBER   /* NUM_TYPE */
)  RETURN NUMBER IS
l_ch                      VARCHAR2(20);
l_ch_context_key          VARCHAR2(255);
l_cy                      VARCHAR2(20);
l_no_ch                   BOOLEAN;
l_ret                     NUMBER;
l_sqc_avg                 NUMBER;
l_sqc_std_dev             NUMBER;
l_sqc_avg_range           NUMBER ;
l_sqc_std_dev_range       NUMBER ;
l_sqc_since_date          TIMESTAMP WITH TIME ZONE;
l_sqc_since_ch            VARCHAR2(20);
l_error                   EXCEPTION;

CURSOR c_datapoints IS
SELECT datapoint_seq, measure_seq from utchdp where
ch = a_ch and
active ='1';

CURSOR c_ch IS
   SELECT  cy, ch_context_key
   FROM utch
    WHERE ch = a_ch;

BEGIN
   -- begin transaction
   IF UNAPIGEN.BeginTxn(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE l_error;
   END IF;

   IF NVL(a_ch, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE  l_error;
   END IF;

   l_no_ch := FALSE;
   OPEN c_ch;
   FETCH c_ch INTO l_cy, l_ch_context_key;
   IF c_ch%NOTFOUND THEN
      l_no_ch := TRUE;
   END IF;
   CLOSE c_ch;

   IF l_no_ch = TRUE THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      RAISE StpError;
   END IF;

   l_sqc_avg           := a_sqc_avg;
   l_sqc_std_dev       := a_sqc_std_dev;
   l_sqc_avg_range     := a_sqc_avg_range;
   l_sqc_std_dev_range := a_sqc_std_dev_range;

   UPDATE utch
   SET
      sqc_avg           = l_sqc_avg,
      sqc_std_dev       = l_sqc_std_dev,
      sqc_avg_range     = l_sqc_avg_range,
      sqc_std_dev_range = l_sqc_std_dev_range
   WHERE
      ch = a_ch;


   FOR l_dp_rec IN c_datapoints LOOP
      l_ret := UNSQCCALC.SQCCALC(a_ch, l_dp_rec.datapoint_seq, l_dp_rec.measure_seq);
   END LOOP;

   IF UNAPIGEN.EndTxn <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE l_error;
   END IF;

   RETURN (UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF sqlcode <> 1 THEN
      UNAPIGEN.LogError('InitSQCChart',sqlerrm);
   END IF ;
   RETURN(UNAPIGEN.AbortTxn(UNAPIGEN.P_TXN_ERROR,'InitSQCChart'));

END InitSQCChart;


/*
+-----------------------------------------------------------------------------------
| The function SQCCalcChart calculates the sqc values for new charts.
|
+-----------------------------------------------------------------------------------
The SQC values are taken from the previous chart
*/
FUNCTION SQCCalcChart
(
 a_ch                   IN       VARCHAR2 /* VC20_TYPE  */
)  RETURN NUMBER IS
l_ch                      VARCHAR2(20);
l_ch_context_key          VARCHAR2(255);
l_cy                      VARCHAR2(20);
l_xr_serie_seq            NUMBER;
l_no_ch                   BOOLEAN;
l_no_previous_ch          BOOLEAN;
l_ret                     NUMBER;
l_sqc_avg                 NUMBER;
l_sqc_std_dev             NUMBER;
l_sqc_avg_range           NUMBER ;
l_sqc_std_dev_range       NUMBER ;
l_sqc_since_date          TIMESTAMP WITH TIME ZONE;
l_sqc_since_ch            VARCHAR2(20);
l_Y_axis_unit             VARCHAR2(20);
l_old_Y_axis_unit             VARCHAR2(20);
l_error                   EXCEPTION;

CURSOR c_ch(l_ch IN VARCHAR2) IS
   SELECT  cy, ch_context_key, Y_axis_unit
     FROM utch
    WHERE ch = l_ch;

CURSOR c_previous_chart_sqc (c_cy VARCHAR2, c_ch_context_key VARCHAR2, c_current_ch VARCHAR2) IS
   SELECT  sqc_avg, sqc_std_dev, sqc_avg_range, sqc_std_dev_range, Y_axis_unit
     FROM utch
    WHERE cy = c_cy
      AND ch_context_key = c_ch_context_key
      AND ch <> c_current_ch
 ORDER BY NVL(creation_date, TO_DATE('1/1/0001', 'DD/MM/YYYY')) DESC;

BEGIN
   -- begin transaction
   IF UNAPIGEN.BeginTxn(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE l_error;
   END IF;

   IF NVL(a_ch, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE  l_error;
   END IF;

   l_no_ch := FALSE;
   OPEN c_ch (a_ch);
   FETCH c_ch INTO l_cy, l_ch_context_key, l_old_Y_axis_unit;
   IF c_ch%NOTFOUND THEN
      l_no_ch := TRUE;
   END IF;
   CLOSE c_ch;

   IF l_no_ch = TRUE THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      RAISE StpError;
   END IF;
   l_no_previous_ch := FALSE;
   OPEN c_previous_chart_sqc (l_cy, l_ch_context_key, a_ch);
   FETCH c_previous_chart_sqc INTO l_sqc_avg, l_sqc_std_dev, l_sqc_avg_range, l_sqc_std_dev_range, l_Y_axis_unit ;
   IF c_previous_chart_sqc%NOTFOUND THEN
      l_no_previous_ch := TRUE;
   END IF;
   CLOSE c_previous_chart_sqc;

   IF l_no_previous_ch = FALSE THEN
    UPDATE utch
    SET
       sqc_avg           = l_sqc_avg,
       sqc_std_dev       = l_sqc_std_dev,
       sqc_avg_range     = l_sqc_avg_range,
       sqc_std_dev_range = l_sqc_std_dev_range,
       Y_axis_unit       = l_Y_axis_unit
    WHERE
       ch = a_ch;

    IF NVL(l_old_Y_axis_unit, ' ') <> NVL(l_Y_axis_unit, ' ') THEN
    --apply unit conversions
       l_ret_code := ApplyChartUnit(a_ch);
    END IF;
   END IF;

   IF UNAPIGEN.EndTxn <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE l_error;
   END IF;

   RETURN (UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF sqlcode <> 1 THEN
      UNAPIGEN.LogError('SQCCalcChart',sqlerrm);
   END IF ;
   RETURN(UNAPIGEN.AbortTxn(UNAPIGEN.P_TXN_ERROR,'SQCCalcChart'));

END SQCCalcChart;


/*
The function SQCCalcChartPreviousCharts calculates the sqc values for new charts.
For charts which are the first chart in serie (xr_serie_seq = 1)  these values are calculated
from the datapoint of the previous chart with the same cy and ch_context_key.
For other charts, these values are calculated from the datapoints from the
charts which are in the same serie as the current ch.
This function is not used in standard unilab


FUNCTION SQCCalcChartPreviousCharts
(
 a_ch                  IN       VARCHAR2,
 a_sqc_avg             OUT      NUMBER,
 a_sqc_std_dev         OUT      NUMBER,
 a_sqc_avg_range       OUT      NUMBER,
 a_sqc_std_dev_range   OUT      NUMBER
)  RETURN NUMBER IS
l_ch               VARCHAR2(20);
l_ch_context_key   VARCHAR2(255);
l_cy               VARCHAR2(20);
l_xr_serie_seq     NUMBER;
l_no_ch            BOOLEAN;
l_ret              NUMBER;
l_sqc_avg          NUMBER;
l_sqc_std_dev        NUMBER;
l_sqc_avg_range    NUMBER ;
l_sqc_std_dev_range  NUMBER ;
l_sqc_since_date   TIMESTAMP WITH TIME ZONE;
l_sqc_since_ch     VARCHAR2(20);
l_error        EXCEPTION;

CURSOR c_ch(l_ch IN VARCHAR2) IS
SELECT  cy, ch_context_key, xr_serie_seq
   from utch where
    ch = l_ch;

CURSOR c_sqc_since(l_cy VARCHAR2, l_ch_context_key VARCHAR2, l_date_since DATE) is
SELECT AVG(datapoint_value_f), STDDEV(datapoint_value_f), AVG(datapoint_range), STDDEV(datapoint_range) from utchdp
   where ch in
   (SELECT ch from utch
      where cy = l_cy and
            ch_context_key = l_ch_context_key and
            creation_date >= l_date_since);

CURSOR c_last_serie_creation_date (l_cy VARCHAR2, l_ch_context_key VARCHAR2) IS
SELECT ch, creation_date from utch
   where cy = l_cy and
      ch_context_key = l_ch_context_key and
      xr_serie_seq = 1
    order by NVL(creation_date, TO_DATE('1/1/0001', 'DD/MM/YYYY')) desc;

CURSOR c_previous_chart_creation_date (l_cy VARCHAR2, l_ch_context_key VARCHAR2, l_current_ch VARCHAR2) IS
SELECT ch, creation_date from utch
   where cy = l_cy and
      ch_context_key = l_ch_context_key and
      ch <> l_current_ch
    order by NVL(creation_date, TO_DATE('1/1/0001', 'DD/MM/YYYY')) desc;

BEGIN
   IF UNAPIGEN.BeginTxn(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE l_error;
   END IF;

   IF NVL(a_ch, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE  l_error;
   END IF;

   l_no_ch := FALSE;
   OPEN c_ch (a_ch);
   FETCH c_ch INTO l_cy, l_ch_context_key, l_xr_serie_seq;
   IF c_ch%NOTFOUND THEN
        l_no_ch := TRUE;
   END IF;
   CLOSE c_ch;

   IF l_no_ch = TRUE THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      RAISE StpError;
   END IF;

   IF l_xr_serie_seq <> 1 THEN
      OPEN c_last_serie_creation_date (l_cy, l_ch_context_key);
      FETCH c_last_serie_creation_date INTO l_sqc_since_ch, l_sqc_since_date;
      CLOSE c_last_serie_creation_date;
   ELSE
      OPEN c_previous_chart_creation_date (l_cy, l_ch_context_key, a_ch);
      FETCH c_previous_chart_creation_date INTO l_sqc_since_ch, l_sqc_since_date;
      CLOSE c_previous_chart_creation_date;
   END IF;

   OPEN c_sqc_since (l_cy, l_ch_context_key, l_sqc_since_date );
   FETCH c_sqc_since INTO l_sqc_avg, l_sqc_std_dev, l_sqc_avg_range, l_sqc_std_dev_range;
   CLOSE c_sqc_since;

   a_sqc_avg         := l_sqc_avg   ;
   a_sqc_std_dev       := l_sqc_std_dev       ;
   a_sqc_avg_range   := l_sqc_avg_range   ;
   a_sqc_std_dev_range := l_sqc_std_dev_range ;

   IF UNAPIGEN.EndTxn <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE l_error;
   END IF;

   RETURN (UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF sqlcode <> 1 THEN
      UNAPIGEN.LogError('SQCCalcChartPreviousCharts',sqlerrm);
   END IF ;
   RETURN(UNAPIGEN.AbortTxn(UNAPIGEN.P_TXN_ERROR,'SQCCalcChartPreviousCharts'));

END SQCCalcChartPreviousCharts;
*/

FUNCTION CONTROL_CHART
(
 a_ch                   IN       VARCHAR2, /* VC20_TYPE  */
 a_datapoint_seq        IN       NUMBER,   /* NUM_TYPE */
 a_measure_seq          IN       NUMBER    /* NUM_TYPE */
)  RETURN NUMBER IS

l_datapoint_cnt             NUMBER;
l_datapoint_unit            VARCHAR2(20);
l_cy_calc_cf                VARCHAR2(255);
l_assign_cf                 VARCHAR2(255);
l_ch_context_key            VARCHAR2(255);
l_cy                        VARCHAR2(20);
l_ref_date                  TIMESTAMP WITH TIME ZONE;
l_time_based                BOOLEAN;
l_nr_datapoints             NUMBER;
l_creation_date             TIMESTAMP WITH TIME ZONE;
l_old_exec_end_date         TIMESTAMP WITH TIME ZONE;
l_old_exec_start_date       TIMESTAMP WITH TIME ZONE;
l_sql_string                VARCHAR2(1000);
l_sqc_avg                   NUMBER;
l_sqc_std_dev               NUMBER;
l_sqc_avg_range             NUMBER;
l_sqc_std_dev_range         NUMBER;
l_old_sqc_avg               NUMBER;
l_old_sqc_std_dev           NUMBER;
l_old_sqc_avg_range         NUMBER ;
l_old_sqc_std_dev_range     NUMBER ;
l_rule1_violated            CHAR(1);
l_rule2_violated            CHAR(1);
l_rule3_violated            CHAR(1);
l_rule4_violated            CHAR(1);
l_rule5_violated            CHAR(1);
l_rule6_violated            CHAR(1);
l_rule7_violated            CHAR(1);
l_rule8_violated            CHAR(1);
l_datapoint_marker          VARCHAR2(20);
l_datapoint_colour          VARCHAR2(20);
l_old_datapoint_marker      VARCHAR2(20);
l_old_datapoint_colour      VARCHAR2(20);
l_error                     EXCEPTION;
l_now                       TIMESTAMP WITH TIME ZONE;
l_datapoint_link            VARCHAR2(255);
l_old_spec1                 NUMBER;
l_old_spec2                 NUMBER;
l_old_spec3                 NUMBER;

--Specific local variables
l_spec_set                  CHAR(1);
l_nr_of_rows                NUMBER;
l_where_clause              VARCHAR2(511);
l_sc_tab                    UNAPIGEN.VC20_TABLE_TYPE;
l_pg_tab                    UNAPIGEN.VC20_TABLE_TYPE;
l_pgnode_tab                UNAPIGEN.LONG_TABLE_TYPE;
l_pa_tab                    UNAPIGEN.VC20_TABLE_TYPE;
l_panode_tab                UNAPIGEN.LONG_TABLE_TYPE;
l_low_limit_tab             UNAPIGEN.FLOAT_TABLE_TYPE;
l_high_limit_tab            UNAPIGEN.FLOAT_TABLE_TYPE;
l_low_spec_tab              UNAPIGEN.FLOAT_TABLE_TYPE;
l_high_spec_tab             UNAPIGEN.FLOAT_TABLE_TYPE;
l_low_dev_tab               UNAPIGEN.FLOAT_TABLE_TYPE;
l_rel_low_dev_tab           UNAPIGEN.CHAR1_TABLE_TYPE;
l_target_tab                UNAPIGEN.FLOAT_TABLE_TYPE;
l_high_dev_tab              UNAPIGEN.FLOAT_TABLE_TYPE;
l_rel_high_dev_tab          UNAPIGEN.CHAR1_TABLE_TYPE;
l_sc                        VARCHAR2(20);
l_pg                        VARCHAR2(20);
l_pgnode                    NUMBER;
l_pa                        VARCHAR2(20);
l_panode                    NUMBER;
l_reanalysis                NUMBER;
l_Y_axis_unit               VARCHAR2(20);
l_Y_axis_format             VARCHAR2(40);
l_parameter_unit            VARCHAR2(20);
l_parameter_format          VARCHAR2(40);
l_dummy_string              VARCHAR2(255);

l_eq                        VARCHAR2(20);
l_eq_version                VARCHAR2(20);
l_lab                       VARCHAR2(20);
l_ct                        VARCHAR2(20);
l_eqct_start_date           TIMESTAMP WITH TIME ZONE;


l_target                    NUMBER;
l_low_spec                  NUMBER;
l_high_spec                 NUMBER;

CURSOR c_ch(lc_ch VARCHAR2) IS
   SELECT sqc_avg, sqc_std_dev, sqc_avg_range, sqc_std_dev_range,
          ch_context_key, cy, datapoint_cnt, datapoint_unit, creation_date, exec_start_date,
          cy_calc_cf, assign_cf
     FROM utch
    WHERE ch = lc_ch;

CURSOR c_ch_exec_end_date(lc_cy VARCHAR2, lc_ch_context_key VARCHAR2, lc_ch VARCHAR2) IS
   SELECT exec_end_date
     FROM utch
    WHERE cy             = lc_cy
      AND ch_context_key = lc_ch_context_key
      AND exec_end_date  IS NULL
      AND ch             <> lc_ch;

CURSOR c_datapointlink IS
   SELECT datapoint_link
     FROM utchdp
    WHERE datapoint_seq = a_datapoint_seq
      AND measure_seq   = a_measure_seq
      AND ch            = a_ch;

CURSOR c_chdp(lc_ch VARCHAR2, lc_datapoint_seq NUMBER, lc_measure_seq NUMBER) IS
   SELECT sqc_avg, sqc_std_dev, sqc_avg_range, sqc_std_dev_range,
          datapoint_marker, datapoint_colour,
          spec1, spec2, spec3
     FROM utchdp
    WHERE ch            = lc_ch
      AND datapoint_seq = lc_datapoint_seq
      AND measure_seq   = lc_measure_seq;

CURSOR c_Y_axis_unit( c_ch IN VARCHAR2) IS
Select y_axis_unit from utch where
   ch = c_ch;

CURSOR c_parameter_unit
      (lc_sc VARCHAR2, lc_pg VARCHAR2, lc_pgnode NUMBER, lc_pa VARCHAR2, lc_panode NUMBER, lc_reanalysis NUMBER) IS
   SELECT unit, format
     FROM utscpa
    WHERE sc       = lc_sc
      AND pg       = lc_pg
      AND pgnode   = lc_pgnode
      AND pa       = lc_pa
      AND panode   = lc_panode
      AND reanalysis= lc_reanalysis;

CURSOR c_eqct_unit
      (lc_eq VARCHAR2, lc_lab VARCHAR2, lc_eq_version VARCHAR2, lc_ct_name VARCHAR2) IS
   SELECT unit, format
     FROM uteqct
    WHERE eq         = lc_eq
      AND lab        = lc_lab
      AND version    = lc_eq_version
      AND ct_name    = lc_ct_name;


BEGIN
   IF NVL(a_ch, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE  l_error;
   END IF;

   IF UNAPIGEN.BeginTxn(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE l_error;
   END IF;

   l_now := CURRENT_TIMESTAMP ;

   /* l_ev_seq_nr has to have a useful value */
   l_ret_code := UNAPIGEN.GetNextEventSeqNr(l_ev_seq_nr);
   IF l_ret_code <> 0 THEN
      UNAPIGEN.P_TXN_ERROR := l_ret_code;
      RAISE StpError;
   END IF;

   OPEN c_ch (a_ch );
   FETCH c_ch INTO l_sqc_avg, l_sqc_std_dev, l_sqc_avg_range, l_sqc_std_dev_range,
                   l_ch_context_key, l_cy, l_datapoint_cnt, l_datapoint_unit, l_creation_date,
                   l_old_exec_start_date, l_cy_calc_cf, l_assign_cf;
   CLOSE c_ch;

  -- fetch the datapointlink
   OPEN c_datapointlink ;
   FETCH c_datapointlink INTO l_datapoint_link;
   CLOSE c_datapointlink;

   IF INSTR( l_datapoint_link, '#', 1,5) > 0 THEN          -- pa result
      l_sc := SUBSTR(l_datapoint_link, 1,   INSTR( l_datapoint_link, '#', 1, 1) - 1);
      l_pg := SUBSTR(l_datapoint_link, INSTR( l_datapoint_link, '#', 1, 1) +1 ,   INSTR( l_datapoint_link, '#', 1, 2) - INSTR( l_datapoint_link, '#', 1, 1) - 1);
      l_pgnode := TO_NUMBER(SUBSTR(l_datapoint_link, INSTR( l_datapoint_link, '#', 1, 2) +1 ,   INSTR( l_datapoint_link, '#', 1, 3) - INSTR( l_datapoint_link, '#', 1, 2) - 1));
      l_pa := SUBSTR(l_datapoint_link, INSTR( l_datapoint_link, '#', 1, 3) +1 ,   INSTR( l_datapoint_link, '#', 1, 4) - INSTR( l_datapoint_link, '#', 1, 3) - 1);
      l_panode := TO_NUMBER(SUBSTR(l_datapoint_link, INSTR( l_datapoint_link, '#', 1,4) +1 ,   INSTR( l_datapoint_link, '#', 1, 5) - INSTR( l_datapoint_link, '#', 1, 4) - 1));
      l_reanalysis:= TO_NUMBER(SUBSTR(l_datapoint_link, INSTR( l_datapoint_link, '#', 1,5) +1));
      OPEN c_parameter_unit(l_sc, l_pg, l_pgnode, l_pa, l_panode, l_reanalysis);
      FETCH c_parameter_unit INTO l_parameter_unit, l_parameter_format;
      CLOSE c_parameter_unit;
   ELSIF INSTR( l_datapoint_link, '#', 1,4) > 0 THEN   -- eqct result
      l_eq         := SUBSTR(l_datapoint_link, 1,   INSTR( l_datapoint_link, '#', 1, 1) - 1);
      l_lab        := SUBSTR(l_datapoint_link, INSTR( l_datapoint_link, '#', 1, 1) +1 ,   INSTR( l_datapoint_link, '#', 1, 2) - INSTR( l_datapoint_link, '#', 1, 1) - 1);
      l_eq_version := SUBSTR(l_datapoint_link, INSTR( l_datapoint_link, '#', 1, 2) +1 ,   INSTR( l_datapoint_link, '#', 1, 3) - INSTR( l_datapoint_link, '#', 1, 2) - 1);
      l_ct         := SUBSTR(l_datapoint_link, INSTR( l_datapoint_link, '#', 1, 3) +1 ,   INSTR( l_datapoint_link, '#', 1, 4) - INSTR( l_datapoint_link, '#', 1, 3) - 1);
 --     l_eqct_start_date:= TO_DATE(SUBSTR(l_datapoint_link, INSTR( l_datapoint_link, '#', 1,3) +1), 'DD/MM/YYYY HH24:MI:SS');
      OPEN c_eqct_unit(l_eq, l_lab, l_eq_version, l_ct);
      FETCH c_eqct_unit INTO l_parameter_unit, l_parameter_format;
      CLOSE c_eqct_unit;
   END IF;

   -- for new charts
   IF (a_datapoint_seq = 0) and (a_measure_seq = 0) and (l_sqc_avg IS NULL )  and (l_sqc_avg_range IS NULL ) then
      -- close open charts from the same serie which are not the current chart
      UPDATE utch
      SET exec_end_date = l_now,
               exec_end_date_tz = DECODE(l_now, exec_end_date_tz, exec_end_date_tz, l_now)
      WHERE
         cy = l_cy and
         ch_context_key = l_ch_context_key and
         exec_end_date is NULL and
         ch <> a_ch;

      -- initialise the start date of this chart
      UPDATE utch
      SET exec_start_date = l_now,
              exec_start_date_tz = DECODE(l_now, exec_start_date_tz, exec_start_date_tz, l_now)
      WHERE
         ch = a_ch;

      l_ret_code := SQCCalcChart(a_ch);
   END IF;

   --initialize the chart unit if necessary
   OPEN c_Y_axis_unit (a_ch);
   FETCH c_Y_axis_unit INTO l_Y_axis_unit;
   CLOSE c_Y_axis_unit;

   IF NVL(l_Y_axis_unit, ' ') = ' ' AND NVL(l_parameter_unit, ' ') <> ' ' THEN
    -- copy the parameter unit to the chart unit
      UPDATE utch
      SET Y_axis_unit = l_parameter_unit
      WHERE
         ch = a_ch;
      l_Y_axis_unit := l_parameter_unit;
   END IF;

   -- set the sqc values for the datapoint
   -- refresh the sqc values of the chart (may be modified)
   OPEN c_ch (a_ch );
   FETCH c_ch INTO l_sqc_avg, l_sqc_std_dev, l_sqc_avg_range, l_sqc_std_dev_range,
                   l_ch_context_key, l_cy, l_datapoint_cnt, l_datapoint_unit, l_creation_date,
                   l_old_exec_start_date, l_cy_calc_cf, l_assign_cf;
   CLOSE c_ch;

   OPEN c_chdp (a_ch, a_datapoint_seq, a_measure_seq);
   FETCH c_chdp
   INTO l_old_sqc_avg, l_old_sqc_std_dev, l_old_sqc_avg_range, l_old_sqc_std_dev_range,
        l_old_datapoint_marker, l_old_datapoint_colour,
        l_old_spec1, l_old_spec2, l_old_spec3;
   CLOSE c_chdp;

   UPDATE utchdp
      SET
         sqc_avg           = l_sqc_avg,
         sqc_std_dev       = l_sqc_std_dev,
         sqc_avg_range     = l_sqc_avg_range,
         sqc_std_dev_range = l_sqc_std_dev_range
      WHERE
         ch = a_ch and
         datapoint_seq  = a_datapoint_seq and
         measure_seq    = a_measure_seq ;

   l_now := CURRENT_TIMESTAMP ;

   -- Check the western electric rules for control charts
   l_ret_code := WesternElectricRules(a_ch, a_datapoint_seq, a_measure_seq,
                                      l_rule1_violated, l_rule2_violated, l_rule3_violated,
                                      l_rule4_violated, l_rule5_violated, l_rule6_violated,
                                      l_rule7_violated, l_rule8_violated );
   IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
   --Alarm Handling
      IF l_rule1_violated = '1' THEN
         l_datapoint_marker := 'CIRCLE';
         l_datapoint_colour := 'red';
      ELSIF  l_rule2_violated = '1' THEN
         l_datapoint_marker := 'RECTANGLE';
         l_datapoint_colour := '#FA429A';
      ELSIF  l_rule3_violated = '1' THEN
         l_datapoint_marker := 'POLYGON';
         l_datapoint_colour := 'blue';
      ELSIF  l_rule4_violated = '1' THEN
         l_datapoint_marker := 'CIRCLE';
         l_datapoint_colour := 'red';
      ELSIF  l_rule5_violated = '1' THEN
         l_datapoint_marker := 'CIRCLE';
         l_datapoint_colour := 'red';
      ELSIF  l_rule6_violated = '1' THEN
         l_datapoint_marker := 'CIRCLE';
         l_datapoint_colour := 'red';
      ELSIF  l_rule7_violated = '1' THEN
         l_datapoint_marker := 'CIRCLE';
         l_datapoint_colour := 'red';
      ELSIF  l_rule8_violated = '1' THEN
         l_datapoint_marker := 'CIRCLE';
         l_datapoint_colour := 'red';
      ELSE
         l_datapoint_marker := 'x';
         l_datapoint_colour := 'black';
      END IF;

      UPDATE utchdp
      SET
         datapoint_marker = l_datapoint_marker,
         datapoint_colour = l_datapoint_colour,
         rule1_violated =  l_rule1_violated,
         rule2_violated =  l_rule2_violated,
         rule3_violated =  l_rule3_violated,
         rule4_violated =  l_rule4_violated,
         rule5_violated =  l_rule5_violated,
         rule6_violated =  l_rule6_violated,
         rule7_violated =  l_rule8_violated --a little assymetry introduced here, rule7_violated in our db
                                            --is corresponding to a violation of rule 8 of western electric rules
      WHERE
         ch = a_ch and
         datapoint_seq  = a_datapoint_seq and
         measure_seq = a_measure_seq ;

      --This piece of code will trigger the SQC alarm handling on client level
      --BEGIN trigger client
      IF l_rule1_violated = '1' OR
         l_rule2_violated = '1' OR
         l_rule3_violated = '1' OR
         l_rule4_violated = '1' OR
         l_rule5_violated = '1' OR
         l_rule6_violated = '1' OR
         l_rule7_violated = '1' THEN

         --Verify if the datapoint_link is corresponding to a scpa key
         IF INSTR( l_datapoint_link, '#', 1,5) > 0 THEN          -- pa result
            UPDATE utscpa
            SET pa_class = '2'
            WHERE sc = l_sc
              AND pg = l_pg
              AND pgnode = l_pgnode
              AND pa = l_pa
              AND panode = l_panode
              AND reanalysis = l_reanalysis;
         END IF;
      END IF;
      --END trigger client
   END IF;

   --set the spec1 .. spec3 fields, needed for calculating the capability indexes
   -- l_datapoint_link  := a_sc(l_seq_no) || '#'|| a_pg(l_seq_no) || '#' || a_pgnode(l_seq_no) || '#' || a_pa(l_seq_no) || '#' || a_panode(l_seq_no) || '#' || l_reanalysis;
   IF INSTR( l_datapoint_link, '#', 1,5) > 0 THEN          -- pa result
      l_where_clause := 'WHERE sc=''' || l_sc || ''' and pg=''' || REPLACE (l_pg, '''', '''''') || ''' and pgnode=' || l_pgnode || ' and pa=''' || REPLACE (l_pa, '''', '''''') || ''' and panode=' || l_panode;
      l_spec_set := 'a';
      l_nr_of_rows := 1;
      l_ret_code := UNAPIPA.GETSCPASPECS
                      (l_spec_set,
                       l_sc_tab,
                       l_pg_tab,
                       l_pgnode_tab,
                       l_pa_tab,
                       l_panode_tab,
                       l_low_limit_tab,
                       l_high_limit_tab,
                       l_low_spec_tab,
                       l_high_spec_tab,
                       l_low_dev_tab,
                       l_rel_low_dev_tab,
                       l_target_tab,
                       l_high_dev_tab,
                       l_rel_high_dev_tab,
                       l_nr_of_rows,
                       l_where_clause);
      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         --life goes on, even if no specifications can be found
         NULL;
      ELSE
        IF (NVL(l_parameter_unit, ' ') <> NVL(l_Y_axis_unit, ' ')) THEN
            --unit conversions
            l_ret_code := UNAPIGEN.TransformResult('',
                     l_target_tab(1),
                     l_parameter_unit,
                     l_parameter_format,
                     l_dummy_string,
                     l_target,
                     l_Y_axis_unit,
                     l_Y_axis_format);
            IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
               UNAPIGEN.P_TXN_ERROR := l_ret_code;
               RAISE StpError;
            END IF;
            l_ret_code := UNAPIGEN.TransformResult('',
                     l_low_spec_tab(1),
                     l_parameter_unit,
                     l_parameter_format,
                     l_dummy_string,
                     l_low_spec,
                     l_Y_axis_unit,
                     l_Y_axis_format);
            IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
               UNAPIGEN.P_TXN_ERROR := l_ret_code;
               RAISE StpError;
            END IF;
            l_ret_code := UNAPIGEN.TransformResult('',
                     l_high_spec_tab(1),
                     l_parameter_unit,
                     l_parameter_format,
                     l_dummy_string,
                     l_high_spec,
                     l_Y_axis_unit,
                     l_Y_axis_format);
            IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
               UNAPIGEN.P_TXN_ERROR := l_ret_code;
               RAISE StpError;
            END IF;
        ELSE
            l_target    := l_target_tab(1);
            l_low_spec  := l_low_spec_tab(1);
            l_high_spec := l_high_spec_tab(1);
        END IF;

        UPDATE utchdp
        SET
          spec1     = l_target,
          spec2     = l_low_spec,
          spec3     = l_high_spec
        WHERE
          ch = a_ch and
          datapoint_seq  = a_datapoint_seq and
          measure_seq    = a_measure_seq ;
      END IF;
   END IF;

   IF UNAPIGEN.EndTxn <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE l_error;
   END IF;

   IF l_rule1_violated = '1' OR
      l_rule2_violated = '1' OR
      l_rule3_violated = '1' OR
      l_rule4_violated = '1' OR
      l_rule5_violated = '1' OR
      l_rule6_violated = '1' OR
      l_rule7_violated = '1' THEN
      RETURN (UNAPIGEN.DBERR_SQCRULEVIOLATED);
   ELSE
      RETURN (UNAPIGEN.DBERR_SUCCESS);
   END IF;

EXCEPTION
WHEN OTHERS THEN
   IF sqlcode <> 1 THEN
      UNAPIGEN.LogError('CONTROL_CHART',sqlerrm);
   END IF ;
   IF c_ch_exec_end_date%ISOPEN THEN
      CLOSE c_ch_exec_end_date;
   END IF;
   IF c_chdp%ISOPEN THEN
      CLOSE c_chdp;
   END IF;
   RETURN(UNAPIGEN.AbortTxn(UNAPIGEN.P_TXN_ERROR,'CONTROL_CHART'));
END CONTROL_CHART;

/************************************************************************************************
*           CONTROL_CHART_ADV                *
*  This function is used for chart with an advanced use of AVG and STD_DEV       *
*                                   *
************************************************************************************************/

FUNCTION CONTROL_CHART_ADV
(
 a_ch                   IN       VARCHAR2, /* VC20_TYPE  */
 a_datapoint_seq        IN       NUMBER,   /* NUM_TYPE */
 a_measure_seq          IN       NUMBER    /* NUM_TYPE */
)  RETURN NUMBER IS

l_datapoint_cnt             NUMBER;
l_datapoint_unit            VARCHAR2(20);
l_cy_calc_cf                VARCHAR2(255);
l_assign_cf                 VARCHAR2(255);
l_ch_context_key            VARCHAR2(255);
l_cy                        VARCHAR2(20);
l_ref_date                  TIMESTAMP WITH TIME ZONE;
l_time_based                BOOLEAN;
l_nr_datapoints             NUMBER;
l_creation_date             TIMESTAMP WITH TIME ZONE;
l_old_exec_end_date         TIMESTAMP WITH TIME ZONE;
l_old_exec_start_date       TIMESTAMP WITH TIME ZONE;
l_sql_string                VARCHAR2(1000);
l_sqc_avg                   NUMBER;
l_sqc_std_dev               NUMBER;
l_sqc_avg_range             NUMBER;
l_sqc_std_dev_range         NUMBER;
l_old_sqc_avg               NUMBER;
l_old_sqc_std_dev           NUMBER;
l_old_sqc_avg_range         NUMBER ;
l_old_sqc_std_dev_range     NUMBER ;
l_rule1_violated            CHAR(1);
l_rule2_violated            CHAR(1);
l_rule3_violated            CHAR(1);
l_rule4_violated            CHAR(1);
l_rule5_violated            CHAR(1);
l_rule6_violated            CHAR(1);
l_rule7_violated            CHAR(1);
l_rule8_violated            CHAR(1);
l_datapoint_marker          VARCHAR2(20);
l_datapoint_colour          VARCHAR2(20);
l_old_datapoint_marker      VARCHAR2(20);
l_old_datapoint_colour      VARCHAR2(20);
l_error                     EXCEPTION;
l_now                       TIMESTAMP WITH TIME ZONE;
l_datapoint_link            VARCHAR2(255);
l_old_spec1                 NUMBER;
l_old_spec2                 NUMBER;
l_old_spec3                 NUMBER;

--Specific local variables
l_spec_set                  CHAR(1);
l_nr_of_rows                NUMBER;
l_where_clause              VARCHAR2(511);
l_sc_tab                    UNAPIGEN.VC20_TABLE_TYPE;
l_pg_tab                    UNAPIGEN.VC20_TABLE_TYPE;
l_pgnode_tab                UNAPIGEN.LONG_TABLE_TYPE;
l_pa_tab                    UNAPIGEN.VC20_TABLE_TYPE;
l_panode_tab                UNAPIGEN.LONG_TABLE_TYPE;
l_low_limit_tab             UNAPIGEN.FLOAT_TABLE_TYPE;
l_high_limit_tab            UNAPIGEN.FLOAT_TABLE_TYPE;
l_low_spec_tab              UNAPIGEN.FLOAT_TABLE_TYPE;
l_high_spec_tab             UNAPIGEN.FLOAT_TABLE_TYPE;
l_low_dev_tab               UNAPIGEN.FLOAT_TABLE_TYPE;
l_rel_low_dev_tab           UNAPIGEN.CHAR1_TABLE_TYPE;
l_target_tab                UNAPIGEN.FLOAT_TABLE_TYPE;
l_high_dev_tab              UNAPIGEN.FLOAT_TABLE_TYPE;
l_rel_high_dev_tab          UNAPIGEN.CHAR1_TABLE_TYPE;
l_sc                        VARCHAR2(20);
l_pg                        VARCHAR2(20);
l_pgnode                    NUMBER;
l_pa                        VARCHAR2(20);
l_panode                    NUMBER;
l_reanalysis                NUMBER;
l_Y_axis_unit               VARCHAR2(20);
l_Y_axis_format             VARCHAR2(40);
l_parameter_unit            VARCHAR2(20);
l_parameter_format          VARCHAR2(40);
l_dummy_string              VARCHAR2(255);

l_eq                       VARCHAR2(20);
l_eq_version               VARCHAR2(20);
l_lab                      VARCHAR2(20);
l_ct                       VARCHAR2(20);
l_eqct_start_date          TIMESTAMP WITH TIME ZONE;


l_target                   NUMBER;
l_low_spec                 NUMBER;
l_high_spec                NUMBER;

l_first_point        BOOLEAN;

CURSOR c_ch(lc_ch VARCHAR2) IS
   SELECT sqc_avg, sqc_std_dev, sqc_avg_range, sqc_std_dev_range,
          ch_context_key, cy, datapoint_cnt, datapoint_unit, creation_date, exec_start_date,
          cy_calc_cf, assign_cf
     FROM utch
    WHERE ch = lc_ch;

CURSOR c_ch_exec_end_date(lc_cy VARCHAR2, lc_ch_context_key VARCHAR2, lc_ch VARCHAR2) IS
   SELECT exec_end_date
     FROM utch
    WHERE cy             = lc_cy
      AND ch_context_key = lc_ch_context_key
      AND exec_end_date  IS NULL
      AND ch             <> lc_ch;

CURSOR c_datapointlink IS
   SELECT datapoint_link
     FROM utchdp
    WHERE datapoint_seq = a_datapoint_seq
      AND measure_seq   = a_measure_seq
      AND ch            = a_ch;

CURSOR c_chdp(lc_ch VARCHAR2, lc_datapoint_seq NUMBER, lc_measure_seq NUMBER) IS
   SELECT sqc_avg, sqc_std_dev, sqc_avg_range, sqc_std_dev_range,
          datapoint_marker, datapoint_colour,
          spec1, spec2, spec3
     FROM utchdp
    WHERE ch            = lc_ch
      AND datapoint_seq = lc_datapoint_seq
      AND measure_seq   = lc_measure_seq;

CURSOR c_Y_axis_unit( c_ch IN VARCHAR2) IS
Select y_axis_unit from utch where
   ch = c_ch;

CURSOR c_parameter_unit
      (lc_sc VARCHAR2, lc_pg VARCHAR2, lc_pgnode NUMBER, lc_pa VARCHAR2, lc_panode NUMBER, lc_reanalysis NUMBER) IS
   SELECT unit, format
     FROM utscpa
    WHERE sc       = lc_sc
      AND pg       = lc_pg
      AND pgnode   = lc_pgnode
      AND pa       = lc_pa
      AND panode   = lc_panode
      AND reanalysis= lc_reanalysis;

CURSOR c_eqct_unit
      (lc_eq VARCHAR2, lc_lab VARCHAR2, lc_eq_version VARCHAR2, lc_ct_name VARCHAR2) IS
   SELECT unit, format
     FROM uteqct
    WHERE eq         = lc_eq
      AND lab        = lc_lab
      AND version    = lc_eq_version
      AND ct_name    = lc_ct_name;


BEGIN
      l_first_point := False;

   IF NVL(a_ch, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE  l_error;
   END IF;

   IF UNAPIGEN.BeginTxn(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE l_error;
   END IF;

   l_now := CURRENT_TIMESTAMP ;

   /* l_ev_seq_nr has to have a useful value */
   l_ret_code := UNAPIGEN.GetNextEventSeqNr(l_ev_seq_nr);
   IF l_ret_code <> 0 THEN
      UNAPIGEN.P_TXN_ERROR := l_ret_code;
      RAISE StpError;
   END IF;

   OPEN c_ch (a_ch );
   FETCH c_ch INTO l_sqc_avg, l_sqc_std_dev, l_sqc_avg_range, l_sqc_std_dev_range,
                   l_ch_context_key, l_cy, l_datapoint_cnt, l_datapoint_unit, l_creation_date,
                   l_old_exec_start_date, l_cy_calc_cf, l_assign_cf;
   CLOSE c_ch;

  -- fetch the datapointlink
   OPEN c_datapointlink ;
   FETCH c_datapointlink INTO l_datapoint_link;
   CLOSE c_datapointlink;

   IF INSTR( l_datapoint_link, '#', 1,5) > 0 THEN          -- pa result
      l_sc := SUBSTR(l_datapoint_link, 1,   INSTR( l_datapoint_link, '#', 1, 1) - 1);
      l_pg := SUBSTR(l_datapoint_link, INSTR( l_datapoint_link, '#', 1, 1) +1 ,   INSTR( l_datapoint_link, '#', 1, 2) - INSTR( l_datapoint_link, '#', 1, 1) - 1);
      l_pgnode := TO_NUMBER(SUBSTR(l_datapoint_link, INSTR( l_datapoint_link, '#', 1, 2) +1 ,   INSTR( l_datapoint_link, '#', 1, 3) - INSTR( l_datapoint_link, '#', 1, 2) - 1));
      l_pa := SUBSTR(l_datapoint_link, INSTR( l_datapoint_link, '#', 1, 3) +1 ,   INSTR( l_datapoint_link, '#', 1, 4) - INSTR( l_datapoint_link, '#', 1, 3) - 1);
      l_panode := TO_NUMBER(SUBSTR(l_datapoint_link, INSTR( l_datapoint_link, '#', 1,4) +1 ,   INSTR( l_datapoint_link, '#', 1, 5) - INSTR( l_datapoint_link, '#', 1, 4) - 1));
      l_reanalysis:= TO_NUMBER(SUBSTR(l_datapoint_link, INSTR( l_datapoint_link, '#', 1,5) +1));
      OPEN c_parameter_unit(l_sc, l_pg, l_pgnode, l_pa, l_panode, l_reanalysis);
      FETCH c_parameter_unit INTO l_parameter_unit, l_parameter_format;
      CLOSE c_parameter_unit;
   ELSIF INSTR( l_datapoint_link, '#', 1,4) > 0 THEN   -- eqct result
      l_eq         := SUBSTR(l_datapoint_link, 1,   INSTR( l_datapoint_link, '#', 1, 1) - 1);
      l_lab        := SUBSTR(l_datapoint_link, INSTR( l_datapoint_link, '#', 1, 1) +1 ,   INSTR( l_datapoint_link, '#', 1, 2) - INSTR( l_datapoint_link, '#', 1, 1) - 1);
      l_eq_version := SUBSTR(l_datapoint_link, INSTR( l_datapoint_link, '#', 1, 2) +1 ,   INSTR( l_datapoint_link, '#', 1, 3) - INSTR( l_datapoint_link, '#', 1, 2) - 1);
      l_ct         := SUBSTR(l_datapoint_link, INSTR( l_datapoint_link, '#', 1, 3) +1 ,   INSTR( l_datapoint_link, '#', 1, 4) - INSTR( l_datapoint_link, '#', 1, 3) - 1);
 --     l_eqct_start_date:= TO_DATE(SUBSTR(l_datapoint_link, INSTR( l_datapoint_link, '#', 1,3) +1), 'DD/MM/YYYY HH24:MI:SS');
      OPEN c_eqct_unit(l_eq, l_lab, l_eq_version, l_ct);
      FETCH c_eqct_unit INTO l_parameter_unit, l_parameter_format;
      CLOSE c_eqct_unit;
   END IF;

   -- for new charts
   IF (a_datapoint_seq = 0) and (a_measure_seq = 0) and (l_sqc_avg IS NULL )  and (l_sqc_avg_range IS NULL ) then
      -- close open charts from the same serie which are not the current chart
      UPDATE utch
      SET exec_end_date = l_now,
              exec_end_date_tz =  DECODE(l_now, exec_end_date_tz, exec_end_date_tz, l_now)
      WHERE
         cy = l_cy and
         ch_context_key = l_ch_context_key and
         exec_end_date is NULL and
         ch <> a_ch;

      -- initialise the start date of this chart
      UPDATE utch
      SET exec_start_date = l_now,
              exec_start_date_tz =  DECODE(l_now, exec_start_date_tz, exec_start_date_tz, l_now)
      WHERE
         ch = a_ch;

      l_ret_code := SQCCalcChart(a_ch);
      l_first_point := TRUE;
   END IF;

   --initialize the chart unit if necessary
   OPEN c_Y_axis_unit (a_ch);
   FETCH c_Y_axis_unit INTO l_Y_axis_unit;
   CLOSE c_Y_axis_unit;

   IF NVL(l_Y_axis_unit, ' ') = ' ' AND NVL(l_parameter_unit, ' ') <> ' ' THEN
    -- copy the parameter unit to the chart unit
      UPDATE utch
      SET Y_axis_unit = l_parameter_unit
      WHERE
         ch = a_ch;
      l_Y_axis_unit := l_parameter_unit;
   END IF;

   -- set the sqc values for the datapoint
   -- refresh the sqc values of the chart (may be modified)
   OPEN c_ch (a_ch );
   FETCH c_ch INTO l_sqc_avg, l_sqc_std_dev, l_sqc_avg_range, l_sqc_std_dev_range,
                   l_ch_context_key, l_cy, l_datapoint_cnt, l_datapoint_unit, l_creation_date,
                   l_old_exec_start_date, l_cy_calc_cf, l_assign_cf;
   CLOSE c_ch;

   OPEN c_chdp (a_ch, a_datapoint_seq, a_measure_seq);
   FETCH c_chdp
   INTO l_old_sqc_avg, l_old_sqc_std_dev, l_old_sqc_avg_range, l_old_sqc_std_dev_range,
        l_old_datapoint_marker, l_old_datapoint_colour,
        l_old_spec1, l_old_spec2, l_old_spec3;
   CLOSE c_chdp;

   --****************************************************************
   IF l_first_point THEN
   IF AVG_STD_DEV_first_point( a_ch, a_datapoint_seq, a_measure_seq) <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE StpError;
   END IF;
   ELSE
   IF AVG_STD_DEV_new_point( a_ch, a_datapoint_seq, a_measure_seq) <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE StpError;
   END IF;
   END IF;
   --****************************************************************

   UPDATE utchdp
      SET
         --sqc_avg           = l_sqc_avg,
         --sqc_std_dev       = l_sqc_std_dev,
         sqc_avg_range     = l_sqc_avg_range,
         sqc_std_dev_range = l_sqc_std_dev_range
      WHERE
         ch = a_ch and
         datapoint_seq  = a_datapoint_seq and
         measure_seq    = a_measure_seq ;

   l_now := CURRENT_TIMESTAMP ;

   -- Check the western electric rules for control charts
   l_ret_code := WesternElectricRules(a_ch, a_datapoint_seq, a_measure_seq,
                                      l_rule1_violated, l_rule2_violated, l_rule3_violated,
                                      l_rule4_violated, l_rule5_violated, l_rule6_violated,
                                      l_rule7_violated, l_rule8_violated );
   IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
   --Alarm Handling
      IF l_rule1_violated = '1' THEN
         l_datapoint_marker := 'CIRCLE';
         l_datapoint_colour := 'red';
      ELSIF  l_rule2_violated = '1' THEN
         l_datapoint_marker := 'RECTANGLE';
         l_datapoint_colour := '#FA429A';
      ELSIF  l_rule3_violated = '1' THEN
         l_datapoint_marker := 'POLYGON';
         l_datapoint_colour := 'blue';
      ELSIF  l_rule4_violated = '1' THEN
         l_datapoint_marker := 'CIRCLE';
         l_datapoint_colour := 'red';
      ELSIF  l_rule5_violated = '1' THEN
         l_datapoint_marker := 'CIRCLE';
         l_datapoint_colour := 'red';
      ELSIF  l_rule6_violated = '1' THEN
         l_datapoint_marker := 'CIRCLE';
         l_datapoint_colour := 'red';
      ELSIF  l_rule7_violated = '1' THEN
         l_datapoint_marker := 'CIRCLE';
         l_datapoint_colour := 'red';
      ELSIF  l_rule8_violated = '1' THEN
         l_datapoint_marker := 'CIRCLE';
         l_datapoint_colour := 'red';
      ELSE
         l_datapoint_marker := 'x';
         l_datapoint_colour := 'black';
      END IF;

      UPDATE utchdp
      SET
         datapoint_marker = l_datapoint_marker,
         datapoint_colour = l_datapoint_colour,
         rule1_violated =  l_rule1_violated,
         rule2_violated =  l_rule2_violated,
         rule3_violated =  l_rule3_violated,
         rule4_violated =  l_rule4_violated,
         rule5_violated =  l_rule5_violated,
         rule6_violated =  l_rule6_violated,
         rule7_violated =  l_rule8_violated --a little assymetry introduced here, rule7_violated in our db
                                            --is corresponding to a violation of rule 8 of western electric rules
      WHERE
         ch = a_ch and
         datapoint_seq  = a_datapoint_seq and
         measure_seq = a_measure_seq ;
   END IF;

   --This piece of code will trigger the SQC alarm handling on client level
   --BEGIN trigger client
   IF l_rule1_violated = '1' OR
      l_rule2_violated = '1' OR
      l_rule3_violated = '1' OR
      l_rule4_violated = '1' OR
      l_rule5_violated = '1' OR
      l_rule6_violated = '1' OR
      l_rule7_violated = '1' THEN

      --Verify if the datapoint_link is corresponding to a scpa key
      IF INSTR( l_datapoint_link, '#', 1,5) > 0 THEN          -- pa result
         UPDATE utscpa
         SET pa_class = '2'
         WHERE sc = l_sc
           AND pg = l_pg
           AND pgnode = l_pgnode
           AND pa = l_pa
           AND panode = l_panode
           AND reanalysis = l_reanalysis;
      END IF;
   END IF;
   --END trigger client

   --set the spec1 .. spec3 fields, needed for calculating the capability indexes
   -- l_datapoint_link  := a_sc(l_seq_no) || '#'|| a_pg(l_seq_no) || '#' || a_pgnode(l_seq_no) || '#' || a_pa(l_seq_no) || '#' || a_panode(l_seq_no) || '#' || l_reanalysis;
   IF INSTR( l_datapoint_link, '#', 1,5) > 0 THEN          -- pa result
      l_where_clause := 'WHERE sc=''' || l_sc || ''' and pg=''' || REPLACE (l_pg, '''', '''''') || ''' and pgnode=' || l_pgnode || ' and pa=''' || REPLACE (l_pa, '''', '''''') || ''' and panode=' || l_panode;
      l_spec_set := 'a';
      l_nr_of_rows := 1;
      l_ret_code := UNAPIPA.GETSCPASPECS
                      (l_spec_set,
                       l_sc_tab,
                       l_pg_tab,
                       l_pgnode_tab,
                       l_pa_tab,
                       l_panode_tab,
                       l_low_limit_tab,
                       l_high_limit_tab,
                       l_low_spec_tab,
                       l_high_spec_tab,
                       l_low_dev_tab,
                       l_rel_low_dev_tab,
                       l_target_tab,
                       l_high_dev_tab,
                       l_rel_high_dev_tab,
                       l_nr_of_rows,
                       l_where_clause);
      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         --life goes on, even if no specifications can be found
         NULL;
      ELSE
        IF (NVL(l_parameter_unit, ' ') <> NVL(l_Y_axis_unit, ' ')) THEN
            --unit conversions
            l_ret_code := UNAPIGEN.TransformResult('',
                     l_target_tab(1),
                     l_parameter_unit,
                     l_parameter_format,
                     l_dummy_string,
                     l_target,
                     l_Y_axis_unit,
                     l_Y_axis_format);
            IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
               UNAPIGEN.P_TXN_ERROR := l_ret_code;
               RAISE StpError;
            END IF;
            l_ret_code := UNAPIGEN.TransformResult('',
                     l_low_spec_tab(1),
                     l_parameter_unit,
                     l_parameter_format,
                     l_dummy_string,
                     l_low_spec,
                     l_Y_axis_unit,
                     l_Y_axis_format);
            IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
               UNAPIGEN.P_TXN_ERROR := l_ret_code;
               RAISE StpError;
            END IF;
            l_ret_code := UNAPIGEN.TransformResult('',
                     l_high_spec_tab(1),
                     l_parameter_unit,
                     l_parameter_format,
                     l_dummy_string,
                     l_high_spec,
                     l_Y_axis_unit,
                     l_Y_axis_format);
            IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
               UNAPIGEN.P_TXN_ERROR := l_ret_code;
               RAISE StpError;
            END IF;
        ELSE
            l_target    := l_target_tab(1);
            l_low_spec  := l_low_spec_tab(1);
            l_high_spec := l_high_spec_tab(1);
        END IF;

        UPDATE utchdp
        SET
          spec1     = l_target,
          spec2     = l_low_spec,
          spec3     = l_high_spec
        WHERE
          ch = a_ch and
          datapoint_seq  = a_datapoint_seq and
          measure_seq    = a_measure_seq ;
      END IF;
   END IF;

   IF UNAPIGEN.EndTxn <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE l_error;
   END IF;

   IF l_rule1_violated = '1' OR
      l_rule2_violated = '1' OR
      l_rule3_violated = '1' OR
      l_rule4_violated = '1' OR
      l_rule5_violated = '1' OR
      l_rule6_violated = '1' OR
      l_rule7_violated = '1' THEN
      RETURN (UNAPIGEN.DBERR_SQCRULEVIOLATED);
   ELSE
      RETURN (UNAPIGEN.DBERR_SUCCESS);
   END IF;

EXCEPTION
WHEN OTHERS THEN
   IF sqlcode <> 1 THEN
      UNAPIGEN.LogError('CONTROL_CHART',sqlerrm);
   END IF ;
   IF c_ch_exec_end_date%ISOPEN THEN
      CLOSE c_ch_exec_end_date;
   END IF;
   IF c_chdp%ISOPEN THEN
      CLOSE c_chdp;
   END IF;
   RETURN(UNAPIGEN.AbortTxn(UNAPIGEN.P_TXN_ERROR,'CONTROL_CHART'));
END CONTROL_CHART_ADV;


FUNCTION TREND_CHART
(
 a_ch                   IN       VARCHAR2, /* VC20_TYPE  */
 a_datapoint_seq        IN       NUMBER,   /* NUM_TYPE */
 a_measure_seq          IN       NUMBER    /* NUM_TYPE */
)  RETURN NUMBER IS

l_datapoint_cnt             NUMBER;
l_datapoint_unit            VARCHAR2(20);
l_parameter_unit            VARCHAR2(20);
l_parameter_format          VARCHAR2(40);
l_cy_calc_cf                VARCHAR2(255);
l_assign_cf                 VARCHAR2(255);
l_sqc_avg                   NUMBER;
l_sqc_std_dev               NUMBER;
l_sqc_avg_range             NUMBER;
l_sqc_std_dev_range         NUMBER;
l_ch_context_key            VARCHAR2(255);
l_cy                        VARCHAR2(20);
l_ref_date                  TIMESTAMP WITH TIME ZONE;
l_time_based                BOOLEAN;
l_nr_datapoints             NUMBER;
l_creation_date             TIMESTAMP WITH TIME ZONE;
l_sql_string                VARCHAR2(1000);
l_datapoint_link            VARCHAR2(255);

l_ret_code                  INTEGER;
l_row                       INTEGER;
--Specific local variables
l_spec_set                  CHAR(1);
l_nr_of_rows                NUMBER;
l_where_clause              VARCHAR2(511);
l_dummy_string              VARCHAR2(2000);
l_sc_tab                    UNAPIGEN.VC20_TABLE_TYPE;
l_pg_tab                    UNAPIGEN.VC20_TABLE_TYPE;
l_pgnode_tab                UNAPIGEN.LONG_TABLE_TYPE;
l_pa_tab                    UNAPIGEN.VC20_TABLE_TYPE;
l_panode_tab                UNAPIGEN.LONG_TABLE_TYPE;
l_low_limit_tab             UNAPIGEN.FLOAT_TABLE_TYPE;
l_high_limit_tab            UNAPIGEN.FLOAT_TABLE_TYPE;
l_low_spec_tab              UNAPIGEN.FLOAT_TABLE_TYPE;
l_high_spec_tab             UNAPIGEN.FLOAT_TABLE_TYPE;
l_low_dev_tab               UNAPIGEN.FLOAT_TABLE_TYPE;
l_rel_low_dev_tab           UNAPIGEN.CHAR1_TABLE_TYPE;
l_target_tab                UNAPIGEN.FLOAT_TABLE_TYPE;
l_high_dev_tab              UNAPIGEN.FLOAT_TABLE_TYPE;
l_rel_high_dev_tab          UNAPIGEN.CHAR1_TABLE_TYPE;
l_sc                        VARCHAR2(20);
l_pg                        VARCHAR2(20);
l_pgnode                    NUMBER;
l_pa                        VARCHAR2(20);
l_panode                    NUMBER;
l_reanalysis                NUMBER;
l_error                     EXCEPTION;
l_Y_axis_unit               VARCHAR2(20);
l_Y_axis_format               VARCHAR2(40);

l_eq                       VARCHAR2(20);
l_eq_version               VARCHAR2(20);
l_ct                       VARCHAR2(20);
l_lab                      VARCHAR2(20);
l_eqct_start_date          TIMESTAMP WITH TIME ZONE;
l_target                   NUMBER;
l_low_spec                 NUMBER;
l_high_spec                NUMBER;

CURSOR c_datapointlink IS
SELECT datapoint_link FROM utchdp
WHERE datapoint_seq = a_datapoint_seq AND
      measure_seq   = a_measure_seq AND
      ch            = a_ch;

CURSOR c_ch(lc_ch VARCHAR2) IS
SELECT  ch_context_key,
       cy, datapoint_cnt, datapoint_unit, creation_date, cy_calc_cf, assign_cf from utch
   WHERE ch = lc_ch;

CURSOR c_nr_datapoints(lc_ch VARCHAR2) IS
   SELECT count(distinct datapoint_seq) from utchdp
      WHERE ch = lc_ch;

CURSOR c_Y_axis_unit( c_ch IN VARCHAR2) IS
Select y_axis_unit from utch where
   ch = c_ch;

CURSOR c_parameter_unit
      (lc_sc VARCHAR2, lc_pg VARCHAR2, lc_pgnode NUMBER, lc_pa VARCHAR2, lc_panode NUMBER, lc_reanalysis NUMBER) IS
   SELECT unit, format
     FROM utscpa
    WHERE sc       = lc_sc
      AND pg       = lc_pg
      AND pgnode   = lc_pgnode
      AND pa       = lc_pa
      AND panode   = lc_panode
      AND reanalysis= lc_reanalysis;

CURSOR c_eqct_unit
      (lc_eq VARCHAR2, lc_lab VARCHAR2, lc_eq_version VARCHAR2, lc_ct_name VARCHAR2) IS
   SELECT unit, format
     FROM uteqct
    WHERE eq         = lc_eq
      AND lab        = lc_lab
      AND version    = lc_eq_version
      AND ct_name    = lc_ct_name;

BEGIN
   IF UNAPIGEN.BeginTxn(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE l_error;
   END IF;

   IF NVL(a_ch, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE  l_error;
   END IF;

   -- get several fields of the chart
   OPEN c_ch (a_ch );
   FETCH c_ch INTO
       l_ch_context_key, l_cy, l_datapoint_cnt, l_datapoint_unit, l_creation_date, l_cy_calc_cf, l_assign_cf;
   CLOSE c_ch;

  -- retrieve the datapointlink
   OPEN c_datapointlink ;
   FETCH c_datapointlink INTO l_datapoint_link;
   CLOSE c_datapointlink;

   -- retrieve information of the parameter
   IF INSTR( l_datapoint_link, '#', 1,5) > 0 THEN          -- pa result
      l_sc          := SUBSTR(l_datapoint_link, 1,   INSTR( l_datapoint_link, '#', 1, 1) - 1);
      l_pg          := SUBSTR(l_datapoint_link, INSTR( l_datapoint_link, '#', 1, 1) +1 ,   INSTR( l_datapoint_link, '#', 1, 2) - INSTR( l_datapoint_link, '#', 1, 1) - 1);
      l_pgnode      := TO_NUMBER(SUBSTR(l_datapoint_link, INSTR( l_datapoint_link, '#', 1, 2) +1 ,   INSTR( l_datapoint_link, '#', 1, 3) - INSTR( l_datapoint_link, '#', 1, 2) - 1));
      l_pa          := SUBSTR(l_datapoint_link, INSTR( l_datapoint_link, '#', 1, 3) +1 ,   INSTR( l_datapoint_link, '#', 1, 4) - INSTR( l_datapoint_link, '#', 1, 3) - 1);
      l_panode      := TO_NUMBER(SUBSTR(l_datapoint_link, INSTR( l_datapoint_link, '#', 1,4) +1 ,   INSTR( l_datapoint_link, '#', 1, 5) - INSTR( l_datapoint_link, '#', 1, 4) - 1));
      l_reanalysis  := TO_NUMBER(SUBSTR(l_datapoint_link, INSTR( l_datapoint_link, '#', 1,5) +1));
      OPEN c_parameter_unit(l_sc, l_pg, l_pgnode, l_pa, l_panode, l_reanalysis);
      FETCH c_parameter_unit INTO l_parameter_unit, l_parameter_format;
      CLOSE c_parameter_unit;
   ELSIF INSTR( l_datapoint_link, '#', 1,4) > 0 THEN   -- eqct result
      l_eq         := SUBSTR(l_datapoint_link, 1,   INSTR( l_datapoint_link, '#', 1, 1) - 1);
      l_lab        := SUBSTR(l_datapoint_link, INSTR( l_datapoint_link, '#', 1, 1) +1 ,   INSTR( l_datapoint_link, '#', 1, 2) - INSTR( l_datapoint_link, '#', 1, 1) - 1);
      l_eq_version := SUBSTR(l_datapoint_link, INSTR( l_datapoint_link, '#', 1, 2) +1 ,   INSTR( l_datapoint_link, '#', 1, 3) - INSTR( l_datapoint_link, '#', 1, 2) - 1);
      l_ct         := SUBSTR(l_datapoint_link, INSTR( l_datapoint_link, '#', 1, 3) +1 ,   INSTR( l_datapoint_link, '#', 1, 4) - INSTR( l_datapoint_link, '#', 1, 3) - 1);
 --     l_eqct_start_date:= TO_DATE(SUBSTR(l_datapoint_link, INSTR( l_datapoint_link, '#', 1,3) +1), 'DD/MM/YYYY HH24:MI:SS');
      OPEN c_eqct_unit(l_eq, l_lab, l_eq_version, l_ct);
      FETCH c_eqct_unit INTO l_parameter_unit, l_parameter_format;
      CLOSE c_eqct_unit;
   END IF;

   -- close open charts from the same serie which are not the current chart
   UPDATE utch
   SET exec_end_date = CURRENT_TIMESTAMP,
          exec_end_date_tz = CURRENT_TIMESTAMP
   WHERE
      cy = l_cy and
      ch_context_key = l_ch_context_key and
      exec_end_date is NULL and
      ch <> a_ch;

   -- see if some points should be deleted from the chart (trend)
      l_time_based := TRUE;
      IF l_datapoint_unit = 'MI' THEN   --minutes
         l_ref_date :=    CURRENT_TIMESTAMP - (l_datapoint_cnt / 24 ) / 60;
      ELSIF l_datapoint_unit = 'HH' THEN   --hours
         l_ref_date :=    CURRENT_TIMESTAMP - (l_datapoint_cnt / 24) ;
      ELSIF l_datapoint_unit = 'DD' THEN   --days
         l_ref_date :=    CURRENT_TIMESTAMP - l_datapoint_cnt ;
      ELSIF l_datapoint_unit = 'WW' THEN   --weeks
         l_ref_date :=    CURRENT_TIMESTAMP - 7 * l_datapoint_cnt ;
      ELSIF l_datapoint_unit = 'MM' THEN   --months
         l_ref_date := ADD_MONTHS(CURRENT_TIMESTAMP,  0 - l_datapoint_cnt);
      ELSE
         l_time_based := FALSE;
      END IF;
      IF l_time_based = TRUE THEN
            --Trend: delete the old datapoints
            DELETE FROM utchdp
               where ch = a_ch and
               X_value_d <= l_ref_date;
      ELSE --datapoint count based
         OPEN c_nr_datapoints (a_ch );
         FETCH c_nr_datapoints INTO l_nr_datapoints;
         CLOSE c_nr_datapoints;
         WHILE (NVL(l_nr_datapoints, 0) > l_datapoint_cnt) LOOP
            DELETE FROM UTCHDP
               where ch = a_ch and
               datapoint_seq = (select min(datapoint_seq) from utchdp where ch = a_ch);
            l_nr_datapoints := l_nr_datapoints - 1 ;
         END LOOP;
      END IF;

   -- update the chart unit if needed
   OPEN c_Y_axis_unit (a_ch);
   FETCH c_Y_axis_unit INTO l_Y_axis_unit;
   CLOSE c_Y_axis_unit;
   IF NVL(l_Y_axis_unit, ' ') = ' ' AND NVL(l_parameter_unit, ' ') <> ' ' THEN
    -- copy the parameter unit to the chart unit
      UPDATE utch
      SET Y_axis_unit = l_parameter_unit
      WHERE
         ch = a_ch;
      l_Y_axis_unit := l_parameter_unit;
   END IF;

  --set the spec1 .. spec3 fields
   -- l_datapoint_link  := a_sc(l_seq_no) || '#'|| a_pg(l_seq_no) || '#' || a_pgnode(l_seq_no) || '#' || a_pa(l_seq_no) || '#' || a_panode(l_seq_no) || '#' || l_reanalysis;
   IF INSTR( l_datapoint_link, '#', 1,5) > 0 THEN          -- pa result
      l_sc := SUBSTR(l_datapoint_link, 1,   INSTR( l_datapoint_link, '#', 1, 1) - 1);
      l_pg := SUBSTR(l_datapoint_link, INSTR( l_datapoint_link, '#', 1, 1) +1 ,   INSTR( l_datapoint_link, '#', 1, 2) - INSTR( l_datapoint_link, '#', 1, 1) - 1);
      l_pgnode := TO_NUMBER(SUBSTR(l_datapoint_link, INSTR( l_datapoint_link, '#', 1, 2) +1 ,   INSTR( l_datapoint_link, '#', 1, 3) - INSTR( l_datapoint_link, '#', 1, 2) - 1));
      l_pa := SUBSTR(l_datapoint_link, INSTR( l_datapoint_link, '#', 1, 3) +1 ,   INSTR( l_datapoint_link, '#', 1, 4) - INSTR( l_datapoint_link, '#', 1, 3) - 1);
      l_panode := TO_NUMBER(SUBSTR(l_datapoint_link, INSTR( l_datapoint_link, '#', 1,4) +1 ,   INSTR( l_datapoint_link, '#', 1, 5) - INSTR( l_datapoint_link, '#', 1, 4) - 1));
      l_where_clause := 'WHERE sc=''' || l_sc || ''' and pg=''' || REPLACE (l_pg, '''', '''''') || ''' and pgnode=' || l_pgnode || ' and pa=''' || REPLACE (l_pa, '''', '''''') || ''' and panode=' || l_panode;
      l_spec_set := 'a';
      l_nr_of_rows := 1;
      l_ret_code := UNAPIPA.GETSCPASPECS
                      (l_spec_set,
                       l_sc_tab,
                       l_pg_tab,
                       l_pgnode_tab,
                       l_pa_tab,
                       l_panode_tab,
                       l_low_limit_tab,
                       l_high_limit_tab,
                       l_low_spec_tab,
                       l_high_spec_tab,
                       l_low_dev_tab,
                       l_rel_low_dev_tab,
                       l_target_tab,
                       l_high_dev_tab,
                       l_rel_high_dev_tab,
                       l_nr_of_rows,
                       l_where_clause);
      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
            --life goes on, even if no specification can be found
            NULL;
      ELSE
         IF (NVL(l_parameter_unit, ' ') <> NVL(l_Y_axis_unit, ' ')) THEN
           --unit conversions
            l_ret_code := UNAPIGEN.TransformResult('',
                     l_target_tab(1),
                     l_parameter_unit,
                     l_parameter_format,
                     l_dummy_string,
                     l_target,
                     l_Y_axis_unit,
                     l_Y_axis_format);
            IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
               UNAPIGEN.P_TXN_ERROR := l_ret_code;
               RAISE StpError;
            END IF;
            l_ret_code := UNAPIGEN.TransformResult('',
                     l_low_spec_tab(1),
                     l_parameter_unit,
                     l_parameter_format,
                     l_dummy_string,
                     l_low_spec,
                     l_Y_axis_unit,
                     l_Y_axis_format);
            IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
               UNAPIGEN.P_TXN_ERROR := l_ret_code;
               RAISE StpError;
            END IF;
            l_ret_code := UNAPIGEN.TransformResult('',
                     l_high_spec_tab(1),
                     l_parameter_unit,
                     l_parameter_format,
                     l_dummy_string,
                     l_high_spec,
                     l_Y_axis_unit,
                     l_Y_axis_format);
            IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
               UNAPIGEN.P_TXN_ERROR := l_ret_code;
               RAISE StpError;
            END IF;
         ELSE
            l_target    := l_target_tab(1);
            l_low_spec  := l_low_spec_tab(1);
            l_high_spec := l_high_spec_tab(1);
         END IF;

         UPDATE utchdp
           SET
              spec1     = l_target          ,
              spec2     = l_low_spec        ,
              spec3     = l_high_spec
           WHERE
              ch = a_ch and
              datapoint_seq  = a_datapoint_seq and
              measure_seq    = a_measure_seq ;
      END IF;
   END IF;

   -- Renumber the datapoints if a_datapoint_seq > 9990 (datapoint_seq = NUMBER(4))
   IF (a_datapoint_seq > 9990) THEN
      UPDATE utchdp
        SET
           datapoint_seq  = datapoint_seq - 9900
        WHERE
           ch = a_ch;
   END IF;

   IF UNAPIGEN.EndTxn <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE l_error;
   END IF;

   RETURN (UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF sqlcode <> 1 THEN
      UNAPIGEN.LogError('UNSQCCALC: TREND_CHART',sqlerrm);
   END IF ;
   RETURN(UNAPIGEN.AbortTxn(UNAPIGEN.P_TXN_ERROR,'TREND_CHART'));
END TREND_CHART;


/************************************************************************************************
*           AVG_STD_DEV_First_point                *
*  This function calculate the AVG and STANDARD DEVIATION of a first point of a chart  *
*                                   *
************************************************************************************************/
FUNCTION AVG_STD_DEV_first_point
(
 a_ch                   IN       VARCHAR2, /* VC20_TYPE  */
 a_datapoint_seq        IN       NUMBER,   /* NUM_TYPE */
 a_measure_seq          IN       NUMBER    /* NUM_TYPE */
)  RETURN NUMBER IS

l_xr_max_charts      NUMBER;     -- # of chart to calculate avg and std_dev
l_serie_lenght    NUMBER;     -- The # of charts in this serie
l_cy        VARCHAR2(255); -- The chart type of the chart
l_ch_context_key  VARCHAR2(255); -- The context key of the chart
l_sqc_avg      NUMBER;     -- The AVG
l_sqc_std_dev     NUMBER;     -- The STD_DEV
l_value        NUMBER;     -- The value of the datapoint

l_ch        VARCHAR2(255); -- The ch of the charts
l_count_points    NUMBER;     -- Count the number of points
l_sum       NUMBER;     -- Var used for local sum
l_res       NUMBER;     -- Var used for support
l_count        NUMBER;     -- Var to count... something!

--Get the number of chart to calculate AVG and STD_DEV (utch)
CURSOR get_xr_max_charts(c_ch VARCHAR2) IS
   SELECT xr_max_charts FROM utch
   WHERE ch = c_ch;
--Get the number of charts of the same serie (utch)
CURSOR count_ch_serie(c_cy VARCHAR2, c_context_key VARCHAR2) IS
   SELECT COUNT(*) FROM utch
   WHERE cy = c_cy AND ch_context_key = c_context_key;
--Get the CHART CY  (utch)
CURSOR get_chart_cy(c_ch VARCHAR2) IS
   SELECT cy FROM utch
   WHERE ch = c_ch;
--Get the CHART ch_context_key  (utch)
CURSOR get_chart_ch_context_key(c_ch VARCHAR2) IS
   SELECT ch_context_key FROM utch
   WHERE ch = c_ch;
--Get the chart's ID of the same serie (utch)
CURSOR get_ch_serie(c_cy VARCHAR2, c_context_key VARCHAR2) IS
   SELECT ch FROM utch
   WHERE cy = c_cy AND ch_context_key = c_context_key
   AND ch <> a_ch
   ORDER BY ch DESC;
CURSOR get_avg_dev_first(c_cy VARCHAR2, c_context_key VARCHAR2) IS
   SELECT sqc_avg, sqc_std_dev FROM utch
   WHERE cy = c_cy AND ch_context_key = c_context_key
   AND ch <> a_ch
   ORDER BY ch ASC;

BEGIN
--Get the number of chart to calculate AVG and STD_DEV (utcy)
OPEN  get_xr_max_charts(a_ch);
FETCH get_xr_max_charts INTO l_xr_max_charts;
CLOSE get_xr_max_charts;
--Get the CHART CY  (utch)
OPEN  get_chart_cy(a_ch);
FETCH get_chart_cy INTO l_cy;
CLOSE get_chart_cy;
--Get the CHART ch_context_key  (utch)
OPEN  get_chart_ch_context_key(a_ch);
FETCH get_chart_ch_context_key INTO l_ch_context_key;
CLOSE get_chart_ch_context_key;
--Get the number of charts of the same serie (utch)
OPEN  count_ch_serie(l_cy,l_ch_context_key);
FETCH count_ch_serie INTO l_serie_lenght;
CLOSE count_ch_serie;
--Check the nr of charts of the serie
IF (l_serie_lenght > l_xr_max_charts) = FALSE THEN
   -- The number of charts of the serie is less then the minimum to calculate AVG and STD_DEV
   -- We assign the initial values at the avg and std_dev
   OPEN  get_avg_dev_first(l_cy,l_ch_context_key);
   FETCH get_avg_dev_first INTO l_sqc_avg,l_sqc_std_dev;
   CLOSE get_avg_dev_first;
   --Check if is null (to be sure)
   IF ((l_sqc_avg = NULL) OR (l_sqc_avg = NULL)) AND (TO_NUMBER(SUBSTR(a_ch, LENGTH(a_ch),1)) <> 1) THEN
      --something didn't work in the past
      --we give at the AVG the value of the unique point of the chart
      SELECT DATAPOINT_VALUE_F
      INTO l_value
      FROM utchdp
      WHERE ch = a_ch AND  datapoint_seq = a_datapoint_seq AND measure_seq = a_measure_seq;
      l_sqc_avg := l_value;
      l_sqc_std_dev := 0;
   END IF;
ELSE
   l_sum := 0;
   l_count_points := 0;
   OPEN get_ch_serie (l_cy, l_ch_context_key);
   LOOP
      FETCH get_ch_serie INTO l_ch;
      EXIT WHEN get_ch_serie%NOTFOUND;
      EXIT WHEN get_ch_serie%ROWCOUNT = l_xr_max_charts; --exit when I take the necessary charts
      --take the sum and the nr of points
      SELECT SUM(DATAPOINT_VALUE_F), count(*) INTO l_res, l_count
      FROM utchdp
      WHERE ch = l_ch AND active = '1';
      l_sum := l_sum + l_res;
      l_count_points := l_count_points + l_count;
   END LOOP;
   CLOSE get_ch_serie;
   l_sqc_avg := l_sum / l_count_points;
   --Get the STD_DEV
   l_sum := 0;
   OPEN get_ch_serie (l_cy, l_ch_context_key);
   LOOP
      FETCH get_ch_serie INTO l_ch;
      EXIT WHEN get_ch_serie%NOTFOUND;
      EXIT WHEN get_ch_serie%ROWCOUNT = l_xr_max_charts; --exit when I take the necessary charts
      --take the sum of quared differences
      SELECT sum((DATAPOINT_VALUE_F - l_sqc_avg) * (DATAPOINT_VALUE_F - l_sqc_avg))
      INTO l_res
      FROM utchdp
      WHERE ch = l_ch AND active = '1';
      l_sum := l_sum + l_res;
   END LOOP;
   CLOSE get_ch_serie;
   l_sqc_std_dev := SQRT (l_sum / l_count_points);
END IF;
--update the chart values
UPDATE UTCH
SET   sqc_std_dev = l_sqc_std_dev,
   sqc_avg = l_sqc_avg
WHERE ch = a_ch;
--update the datapoints values
UPDATE UTCHDP
SET   sqc_std_dev = l_sqc_std_dev,
   sqc_avg = l_sqc_avg
WHERE ch = a_ch AND datapoint_seq = a_datapoint_seq AND measure_seq = a_measure_seq;
RETURN (UNAPIGEN.DBERR_SUCCESS);

--exception
EXCEPTION
WHEN OTHERS THEN
   IF sqlcode <> 1 THEN
      UNAPIGEN.LogError('SQCCalc.AVG_STD_DEV_first_point',sqlerrm);
   END IF ;
   RETURN(UNAPIGEN.AbortTxn(UNAPIGEN.P_TXN_ERROR,'AVG_STD_DEV_first_point'));
END AVG_STD_DEV_first_point;


/************************************************************************************************
*           AVG_STD_DEV_new_point                  *
*  This function calculate the AVG and STANDARD DEVIATION for a new point of the chart *
*                                   *
************************************************************************************************/
FUNCTION AVG_STD_DEV_new_point
(
 a_ch                   IN       VARCHAR2, /* VC20_TYPE  */
 a_datapoint_seq        IN       NUMBER,   /* NUM_TYPE */
 a_measure_seq          IN       NUMBER    /* NUM_TYPE */
)  RETURN NUMBER IS

l_sqc_avg      NUMBER;     -- The AVG
l_sqc_std_dev     NUMBER;     -- The STD_DEV
l_value        NUMBER;     -- The value of the datapoint

BEGIN

--AVG for the datapoint
SELECT AVG(DATAPOINT_VALUE_F)
INTO l_sqc_avg
FROM utchdp
WHERE ch = a_ch AND active = '1';

--STD_DEV for the datapoint
SELECT STDDEV(DATAPOINT_VALUE_F)
INTO l_sqc_std_dev
FROM utchdp
WHERE ch = a_ch AND active = '1';

--Check if is null (to be sure)
IF (l_sqc_avg = NULL) OR (l_sqc_avg = NULL) THEN
   --something didn't work
   --we give at the AVG the value of the point
   SELECT DATAPOINT_VALUE_F
   INTO l_value
   FROM utchdp
   WHERE ch = a_ch AND  datapoint_seq = a_datapoint_seq AND measure_seq = a_measure_seq;
   l_sqc_avg := l_value;
   l_sqc_std_dev := 0;
END IF;
--update the datapoint's values
UPDATE UTCHDP
SET   sqc_std_dev = l_sqc_std_dev,
   sqc_avg = l_sqc_avg
WHERE ch = a_ch AND datapoint_seq = a_datapoint_seq AND measure_seq = a_measure_seq;

RETURN (UNAPIGEN.DBERR_SUCCESS);
--exception
EXCEPTION
WHEN OTHERS THEN
   IF sqlcode <> 1 THEN
      UNAPIGEN.LogError('SQCCalc.AVG_STD_DEV_new_point',sqlerrm);
   END IF ;
   RETURN(UNAPIGEN.AbortTxn(UNAPIGEN.P_TXN_ERROR,'AVG_STD_DEV_new_point'));
END AVG_STD_DEV_new_point;

END unsqccalc;
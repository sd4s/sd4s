create or replace PACKAGE BODY
unsqcassign AS
-- SIMATIC IT UNILAB package
-- $Revision: 6.3.0 $
-- $Date: 2007-02-22T14:44:00 $

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
| The function SQCAssign assigns a datapoint to a chart of a certain type.
|
| This function should never perform any data modifications to any DB table (or view)
| All required updates and/or deletes must be handled in the "unsqcCalc" function!
|
| The name of this function (nor the arguments) can ever be changed or modified
| because this function is the "hook" between the standard packages and the actual custom assigment functions
| Although the contents of this function might/could be modified to meet specific project requirements,
| this is strongly discouraged (because it is assumed that any project requirement can be completely handled
| inside the custom assignment function (without the altering the SQCAssign function).
+---------------------------------------------------------------------------------------------
*/
FUNCTION SQCAssign
(
   a_cy                  IN        VARCHAR2, /* VC20_TYPE  */
   a_ch_context_key      IN OUT    VARCHAR2, /* VC255_TYPE */
   a_data_point_link     IN        VARCHAR2, /* VC255_TYPE */
   a_ch                  OUT       VARCHAR2, /* VC20_TYPE  */
   a_datapoint_seq       OUT       NUMBER  , /* NUM_TYPE   */
   a_measure_seq         OUT       NUMBER    /* NUM_TYPE   */
)  RETURN NUMBER IS
l_ch           VARCHAR2(20);
l_assign_cf    VARCHAR2(255);
l_error        EXCEPTION;
l_cy_found     BOOLEAN;
l_pos          NUMBER;
l_pos2         NUMBER;
l_arguments    VARCHAR2(255);

-- The 'FOR UPDATE' clause is necessary to create a critical section. Without that section,
-- error 'unique constraint violated' was generated when 2 concurrent sessions tried
-- to add a datapoint on the same chart (on utch when new ch to create, on utchdp when
-- normal datapoint).
-- No critical section on utprcyst (more detailed), because this package it customisable,
-- and by consequence it can't be guaranteed that the pr makes part of the ch id.
CURSOR c_assign_cf(c_cy IN VARCHAR2) IS
   SELECT assign_cf
   FROM utcy
   WHERE cy = c_cy
   ORDER BY version_is_current DESC
   FOR UPDATE;

BEGIN
   -- begin transaction
   IF UNAPIGEN.BeginTxn(UNAPIGEN.P_SINGLE_API_TXN) <>  UNAPIGEN.DBERR_SUCCESS THEN
      RAISE l_error;
   END IF;

   IF NVL(a_cy, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE  l_error;
   END IF;

  OPEN c_assign_cf ( a_cy );
   FETCH c_assign_cf INTO  l_assign_cf;
   IF c_assign_cf%NOTFOUND THEN -- all the charts in the serie are full or it is the first chart
        l_cy_found := FALSE;
   ELSE
        l_cy_found := TRUE;
   END IF;
   CLOSE c_assign_cf;

   IF l_cy_found = FALSE THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE  l_error;
    END IF;

   IF NVL(l_assign_cf, ' ') =' ' THEN
      l_assign_cf := 'TREND_CHART';
   END IF;

   IF InStr(l_assign_cf, '(' ) = 0 THEN
      l_assign_cf := l_assign_cf || '(:l_cy, :l_ch_context_key, :l_data_point_link, :l_ch, :l_datapoint_seq, :l_measure_seq)';
   ELSE --always append the six arguments before the closing ")"
      l_pos := InStr(l_assign_cf, '(' );
      l_pos2 := InStr(l_assign_cf, ')' );
      --find the last ")"
      WHILE InStr(l_assign_cf, ')', l_pos2 +1  ) > 0 LOOP
         l_pos2 := InStr(l_assign_cf, ')', l_pos2 +1  );
      END LOOP;
      l_arguments := SUBSTR(l_assign_cf, l_pos + 1, l_pos2 - l_pos - 1);
      IF LTRIM(l_arguments) <> '' THEN
         l_assign_cf := SUBSTR(l_assign_cf, 1, l_pos2 - 1) ||  ', :l_cy, :l_ch_context_key, :l_data_point_link, :l_ch, :l_datapoint_seq, :l_measure_seq)';
      ELSE
         l_assign_cf := SUBSTR(l_assign_cf, 1, l_pos - 1) || '(:l_cy, :l_ch_context_key, :l_data_point_link, :l_ch, :l_datapoint_seq, :l_measure_seq)';
      END IF;
   END IF;

   l_sql_string := 'BEGIN :l_retcode := UNSQCASSIGN.' || l_assign_cf || -- NO single quote handling required
                   '; END;';
   BEGIN
      EXECUTE IMMEDIATE l_sql_string
      USING OUT l_ret_code, a_cy, IN OUT a_ch_context_key, a_data_point_link, OUT a_ch, OUT a_datapoint_seq, OUT a_measure_seq ;
   EXCEPTION
   WHEN OTHERS THEN
      l_sqlerrm := SUBSTR(SQLERRM,1,255);
      INSERT INTO uterror(client_id, applic, who, logdate, logdate_tz, api_name, error_msg)
      VALUES(UNAPIGEN.P_CLIENT_ID , UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
             SUBSTR(' UNSQCASSIGN.' || l_assign_cf,1,40), l_sqlerrm);
      l_ret_code := UNAPIGEN.DBERR_GENFAIL;
   END;

   -- end transaction
   IF UNAPIGEN.EndTxn <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE l_error;
   END IF;

   RETURN (UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF sqlcode <> 1 THEN
      UNAPIGEN.LogError('SQCAssign',sqlerrm);
   END IF ;
   RETURN(UNAPIGEN.AbortTxn(UNAPIGEN.P_TXN_ERROR,'SQCAssign'));

END SQCAssign;

/*
+---------------------------------------------------------------------------------------------
| The function SQCDeAssign deassigns a datapoint from a chart of a certain type.
|
| This function should never perform any data modifications to any DB table (or view) !
|
| The name of this function (nor the arguments) can ever be changed or modified
| because this function is the "hook" between the standard packages and the actual custom assigment functions
| Although the contents of this function might/could be modified to meet specific project requirements,
| this is strongly discouraged (because it is assumed that any project requirement can be completely handled
| inside the custom assignment function (without the altering the SQCDeAssign function).
+---------------------------------------------------------------------------------------------
*/
FUNCTION SQCDeAssign
(a_cy                  IN           VARCHAR2, /* VC20_TYPE  */
 a_ch_context_key      IN OUT       VARCHAR2, /* VC255_TYPE */
 a_data_point_link     IN           VARCHAR2, /* VC255_TYPE */
 a_ch                  OUT          VARCHAR2, /* VC20_TYPE */
 a_datapoint_seq       OUT          NUMBER  , /* NUM_TYPE */
 a_measure_seq         OUT          NUMBER  ) /* NUM_TYPE */
RETURN NUMBER IS
   l_ch           VARCHAR2(20);
   l_assign_cf    VARCHAR2(255);
   l_error        EXCEPTION;
   l_cy_found     BOOLEAN;
   l_pos          NUMBER;
   l_pos2         NUMBER;
   l_arguments    VARCHAR2(255);

   CURSOR c_assign_cf(c_cy IN VARCHAR2) IS
      SELECT assign_cf
        FROM utcy
       WHERE cy = c_cy
    ORDER BY version_is_current DESC;
BEGIN
   IF UNAPIGEN.BeginTxn(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE l_error;
   END IF;

   IF NVL(a_cy, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE l_error;
   END IF;

   OPEN c_assign_cf(a_cy);
   FETCH c_assign_cf INTO l_assign_cf;
   IF c_assign_cf%NOTFOUND THEN -- all the charts in the serie are full or it is the first chart
      l_cy_found := FALSE;
   ELSE
      l_cy_found := TRUE;
   END IF;
   CLOSE c_assign_cf;

   IF l_cy_found = FALSE THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE l_error;
   END IF;

   IF NVL(l_assign_cf,' ') = ' ' THEN
      l_assign_cf := 'TREND_CHART';
   END IF;

   IF INSTR(l_assign_cf, '(') = 0 THEN
      l_assign_cf := l_assign_cf ||
         '(:l_cy, :l_ch_context_key, :l_data_point_link, :l_ch, :l_datapoint_seq, :l_measure_seq)';
   ELSE -- always append the arguments before the closing ")"
      l_pos := INSTR(l_assign_cf, '(');
      l_pos2 := INSTR(l_assign_cf, ')');
      -- find the last ")"
      WHILE INSTR(l_assign_cf, ')', l_pos2+1) > 0 LOOP
         l_pos2 := INSTR(l_assign_cf, ')', l_pos2+1);
      END LOOP;
      l_arguments := SUBSTR(l_assign_cf, l_pos+1, l_pos2-l_pos-1);
      IF LTRIM(l_arguments) <> '' THEN
         l_assign_cf := SUBSTR(l_assign_cf, 1, l_pos2-1) ||
           ', :l_cy, :l_ch_context_key, :l_data_point_link, :l_ch, :l_datapoint_seq, :l_measure_seq)';
      ELSE
         l_assign_cf := SUBSTR(l_assign_cf, 1, l_pos-1) ||
           '(:l_cy, :l_ch_context_key, :l_data_point_link, :l_ch, :l_datapoint_seq, :l_measure_seq)';
      END IF;
   END IF;

   l_sql_string := 'BEGIN :l_retcode := UNSQCASSIGN.DEASSIGN_' || l_assign_cf || -- NO single quote handling required
                   '; END;';
   BEGIN
      EXECUTE IMMEDIATE l_sql_string
      USING OUT l_ret_code, a_cy, IN OUT a_ch_context_key, a_data_point_link, OUT a_ch, OUT a_datapoint_seq, OUT a_measure_seq;
   EXCEPTION
   WHEN OTHERS THEN
      l_sqlerrm := SUBSTR(SQLERRM,1,255);
      INSERT INTO uterror(client_id, applic, who, logdate, logdate_tz, api_name, error_msg)
      VALUES(UNAPIGEN.P_CLIENT_ID , UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
             SUBSTR('UNSQCASSIGN.DEASSIGN_' || l_assign_cf,1,40), l_sqlerrm);
      l_ret_code := UNAPIGEN.DBERR_GENFAIL;
   END;

   IF UNAPIGEN.EndTxn <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE l_error;
   END IF;

   RETURN(l_ret_code);
EXCEPTION
WHEN OTHERS THEN
   IF sqlcode <> 1 THEN
      UNAPIGEN.LogError('SQCDeAssign', sqlerrm);
   END IF;
   RETURN(UNAPIGEN.AbortTxn(UNAPIGEN.P_TXN_ERROR, 'SQCDeAssign'));
END SQCDeAssign;

/*
+---------------------------------------------------------------------------------------------
| The "GenerateChartID" function generates an ID for a new chart.
|
| Since this very same functionality can be re-used in several custom assignment functions
| a separate function should avoid duplication of such code.
|
| This function may be customized as needed. If a specific assignment function (corresponding to a specific type of chart)
| would need his own ID generation logic, one will have to write this logic as another function (if it can be re-used)
| OR just directly include the logic inside the "assign" function (if it is exlusively goign to be used for 1 type of chart)
|
| NOTE: This function can never be called directly from within "SQCAssign" because it is not an assignment function
| ~~~~~ (it is just an auxiliary function to make the code more readible)
|
+---------------------------------------------------------------------------------------------
*/
FUNCTION GenerateChartID
(
a_cy                IN  VARCHAR2,  /* VC20_TYPE  */
a_ch_context_key    IN  VARCHAR2,  /* VC255_TYPE  */
a_ch                OUT VARCHAR2   /* VC20_TYPE  */
)
RETURN NUMBER IS
l_ch_exists NUMBER;
l_sequence NUMBER;
l_ch       VARCHAR2(300);

CURSOR c_ch_serie_sequence(c_cy VARCHAR2, c_context_key VARCHAR2) IS
SELECT count(*) + 1 from utch
   where cy = c_cy and
         ch_context_key = c_context_key ;

CURSOR c_ch_exists(c_ch VARCHAR2) IS
SELECT count(*) from utch where ch= c_ch;

BEGIN
   OPEN c_ch_serie_sequence ( a_cy, a_ch_context_key);
   FETCH c_ch_serie_sequence INTO l_sequence;
   CLOSE c_ch_serie_sequence;

   l_ch := a_cy || '#' || a_ch_context_key || '#' || l_sequence;
   IF (LENGTH(l_ch) >20) THEN
      l_ch := SUBSTR(l_ch, LENGTH(l_ch) - 19, 20);
   END IF;

   -- look if the proposed chart ID already exists
   OPEN c_ch_exists ( l_ch);
      FETCH c_ch_exists INTO l_ch_exists;
   CLOSE c_ch_exists;

   WHILE l_ch_exists = 1 LOOP
      l_sequence := l_sequence + 1;
      l_ch := a_cy || '#' || a_ch_context_key || '#' || l_sequence;
      IF (LENGTH(l_ch) >20) THEN
         l_ch := SUBSTR(l_ch, LENGTH(l_ch) - 19, 20);
      END IF;
      OPEN c_ch_exists ( l_ch);
      FETCH c_ch_exists INTO l_ch_exists;
      CLOSE c_ch_exists;
   END LOOP;

   a_ch := l_ch;
   RETURN (UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   UNAPIGEN.LogError('GenerateChartID',sqlerrm);
   RETURN (UNAPIGEN.DBERR_GENFAIL);
END GenerateChartID;

FUNCTION CONTROL_CHART
(
   a_cy                  IN        VARCHAR2, /* VC20_TYPE  */
   a_ch_context_key      IN OUT    VARCHAR2, /* VC255_TYPE */
   a_data_point_link     IN        VARCHAR2, /* VC255_TYPE */
   a_ch                  OUT       VARCHAR2, /* VC20_TYPE  */
   a_datapoint_seq       OUT       NUMBER  , /* NUM_TYPE   */
   a_measure_seq         OUT       NUMBER    /* NUM_TYPE   */
)  RETURN NUMBER IS
l_ch               VARCHAR2(20);
l_assign_cf        VARCHAR2(255);
l_datapoint_seq    NUMBER;
l_measure_seq      NUMBER;
l_datapoint_cnt    NUMBER;
l_datapoint_unit   VARCHAR2(20);
l_xr_measurements  NUMBER;
l_creation_date    TIMESTAMP WITH TIME ZONE;
l_ref_date         TIMESTAMP WITH TIME ZONE;
l_nr_datapoints    NUMBER;
l_ret              NUMBER;
l_new_ch_needed    BOOLEAN;
l_time_based       BOOLEAN;
l_error        EXCEPTION;

l_lc                   VARCHAR2(2);
l_lc_version           VARCHAR2(20);
l_ss                   VARCHAR2(2);
l_log_hs               CHAR(1);
l_log_hs_details       CHAR(1);
l_allow_modify         CHAR(1);
l_active               CHAR(1);
l_insert               BOOLEAN;
l_cy_version           VARCHAR2(20);

l_last_sched                  TIMESTAMP WITH TIME ZONE;
l_last_cnt                    NUMBER;
l_last_val                    VARCHAR2(40);


CURSOR c_ch(c_cy IN VARCHAR2, c_ch_context_key IN VARCHAR2) IS
SELECT ch, datapoint_cnt, datapoint_unit, xr_measurements, creation_date, assign_cf from utch where
   cy = c_cy and
   ch_context_key = c_ch_context_key and
   exec_end_date is null --normally there is at most one chart in a serie with exec_end_date = NULL
   --and NVL(allow_modify,'1') <> '0'
   --authorisation buffer must be evaluated also
   AND NVL(UNAPIAUT.SQLGetChAllowModify(ch), '1') = '1'
   order by NVL(creation_date, TO_TIMESTAMP_TZ('1/1/0001', 'DD/MM/YYYY')) desc;

CURSOR c_chmaxdatapointseq( c_ch IN VARCHAR2) IS
      Select max(datapoint_seq) from utchdp where
      ch = c_ch;

CURSOR c_chmaxmeasureseq( c_ch IN VARCHAR2, c_datapoint_seq IN NUMBER) IS
   Select max(measure_seq) from utchdp where
      ch = c_ch and
      datapoint_seq = c_datapoint_seq;

CURSOR c_cy(c_cy IN VARCHAR2) IS
SELECT xr_measurements from utcy where
   cy = c_cy and
   version_is_current <> '0';

BEGIN

   l_ret := AdjustContextKey(a_cy, a_ch_context_key, a_data_point_link);

   OPEN c_ch ( a_cy , a_ch_context_key);
   FETCH c_ch INTO l_ch, l_datapoint_cnt, l_datapoint_unit, l_xr_measurements, l_creation_date, l_assign_cf;
   IF c_ch%NOTFOUND THEN -- all the charts in the serie are full or it is the first chart
        l_new_ch_needed := TRUE;
   ELSE
        l_new_ch_needed := FALSE;
   END IF;
   CLOSE c_ch;

   IF l_new_ch_needed = FALSE THEN
       --Look if a new chart is needed because the current one is too old.
      IF (NVL(l_datapoint_unit, ' ') <> ' ') THEN
         l_time_based := TRUE;
         -- The UNAPIAUT.EVALASSIGNMENTFREQ function is used to evaluate the time period
         l_new_ch_needed := UNAPIAUT.EVALASSIGNMENTFREQ
                         (NULL, NULL, NULL, NULL,
                          NULL, NULL, 'T', l_datapoint_cnt, l_datapoint_unit,
                          NULL, CURRENT_TIMESTAMP, l_creation_date, l_last_cnt, l_last_val);
      ELSE
         l_time_based := FALSE;
      END IF;
   END IF;

   IF l_new_ch_needed = FALSE THEN
      -- chart can be in transition
      l_ret_code := UNAPIAUT.GetChAuthorisation( l_ch, l_cy_version, l_lc, l_lc_version, l_ss,
                                                  l_allow_modify, l_active, l_log_hs, l_log_hs_details);
      OPEN c_chmaxdatapointseq ( l_ch);
      FETCH c_chmaxdatapointseq INTO l_datapoint_seq;
      CLOSE c_chmaxdatapointseq;

      OPEN c_chmaxmeasureseq ( l_ch, l_datapoint_seq);
      FETCH c_chmaxmeasureseq INTO l_measure_seq;
      CLOSE c_chmaxmeasureseq;

   IF (l_xr_measurements > 1) THEN
      IF (l_measure_seq >= l_xr_measurements) THEN
         l_datapoint_seq := NVL(l_datapoint_seq, 0) + 1;
         l_measure_seq := 1;
      ELSE
         l_measure_seq := l_measure_seq + 1;
      END IF;
   ELSE
      l_measure_seq := 0;  -- X-chart only has single value datapoints!
      l_datapoint_seq := NVL(l_datapoint_seq, 0) + 1;
   END IF;

      -- look if the current control chart is full
      IF (l_datapoint_seq > (l_datapoint_cnt -1))  and (l_time_based = FALSE) THEN
           l_new_ch_needed :=  TRUE;
      END IF;
   END IF;

   IF l_new_ch_needed = TRUE THEN
      l_ret := GenerateChartID( a_cy, a_ch_context_key, l_ch);
      l_datapoint_seq := 0;

      OPEN c_cy ( a_cy);
      FETCH c_cy INTO l_xr_measurements;
      CLOSE c_cy;
      IF NVL(l_xr_measurements, 1) > 1 THEN
         l_measure_seq := 1;
      ELSE
         l_measure_seq := 0;  -- X-chart only has single value datapoints!
      END IF;
   END IF;

   a_ch            := l_ch;
   a_datapoint_seq := l_datapoint_seq;
   a_measure_seq   := l_measure_seq;
   RETURN (UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF sqlcode <> 1 THEN
      UNAPIGEN.LogError('CONTROL_CHART',sqlerrm);
   END IF ;
   RETURN(UNAPIGEN.AbortTxn(UNAPIGEN.P_TXN_ERROR,'CONTROL_CHART'));

END CONTROL_CHART;

FUNCTION TREND_CHART
(
   a_cy                  IN        VARCHAR2, /* VC20_TYPE  */
   a_ch_context_key      IN OUT    VARCHAR2, /* VC255_TYPE */
   a_data_point_link     IN        VARCHAR2, /* VC255_TYPE */
   a_ch                  OUT       VARCHAR2, /* VC20_TYPE  */
   a_datapoint_seq       OUT       NUMBER  , /* NUM_TYPE   */
   a_measure_seq         OUT       NUMBER    /* NUM_TYPE   */
)  RETURN NUMBER IS
l_ch               VARCHAR2(20);
l_assign_cf        VARCHAR2(255);
l_datapoint_seq    NUMBER;
l_measure_seq      NUMBER;
l_datapoint_cnt    NUMBER;
l_datapoint_unit   VARCHAR2(20);
l_xr_measurements  NUMBER;
l_creation_date    TIMESTAMP WITH TIME ZONE;
l_ref_date         TIMESTAMP WITH TIME ZONE;
l_nr_datapoints    NUMBER;
l_ret              NUMBER;
l_new_ch_needed    BOOLEAN;
l_time_based       BOOLEAN;

l_sc               VARCHAR2(20);
l_pg               VARCHAR2(20);
l_pgnode           NUMBER;
l_pa               VARCHAR2(20);
l_panode           NUMBER;
l_reanalysis       NUMBER;
l_pp_key1          VARCHAR2(20);
l_pp_key2          VARCHAR2(20);
l_pp_key3          VARCHAR2(20);
l_pp_key4          VARCHAR2(20);
l_pp_key5          VARCHAR2(20);
l_datapoint_link  VARCHAR2(255);
l_error        EXCEPTION;

l_lc                   VARCHAR2(2);
l_lc_version           VARCHAR2(20);
l_ss                   VARCHAR2(2);
l_log_hs               CHAR(1);
l_log_hs_details       CHAR(1);
l_allow_modify         CHAR(1);
l_active               CHAR(1);
l_insert               BOOLEAN;
l_cy_version           VARCHAR2(20);

CURSOR c_ch(c_cy IN VARCHAR2, c_ch_context_key IN VARCHAR2) IS
SELECT ch, datapoint_cnt, datapoint_unit, xr_measurements, creation_date, assign_cf from utch where
   cy = c_cy and
   ch_context_key = c_ch_context_key and
   Exec_end_date is null and --normally there is at most one chart in a serie with exec_end_date = NULL
   -- NVL(allow_modify,'1') <> '0'
   --authorisation buffer must be evaluated also
   NVL(UNAPIAUT.SQLGetChAllowModify(ch), '1') = '1'
   order by NVL(creation_date, TO_TIMESTAMP_TZ('1/1/0001', 'DD/MM/YYYY')) desc;

CURSOR c_chmaxdatapointseq( c_ch IN VARCHAR2) IS
      Select max(datapoint_seq) from utchdp where
      ch = c_ch;

CURSOR c_chmaxmeasureseq( c_ch IN VARCHAR2, c_datapoint_seq IN NUMBER) IS
   Select max(measure_seq) from utchdp where
      ch = c_ch and
      datapoint_seq = c_datapoint_seq;

CURSOR c_ppkeys(c_sc VARCHAR2, c_pgnode NUMBER) IS
SELECT pp_key1, pp_key2, pp_key3, pp_key4, pp_key5
    FROM utscpg
    WHERE
    sc = c_sc AND
    pgnode = c_pgnode;

CURSOR c_dp(c_cy IN VARCHAR2, c_ch_context_key IN VARCHAR2, c_datapoint_link IN VARCHAR2) IS
   SELECT dp.ch, dp.datapoint_seq, dp.measure_seq
     FROM utch ch, utchdp dp
    WHERE ch.cy = c_cy
      AND ch.ch_context_key = c_ch_context_key
      AND NVL(UNAPIAUT.SQLGetChAllowModify(ch.ch), '0') = '1'
      AND ch.ch = dp.ch
      AND SUBSTR(dp.datapoint_link, 1, INSTR(dp.datapoint_link,'#',1,5)-1) =
                  SUBSTR(c_datapoint_link, 1, INSTR(c_datapoint_link,'#',1,5)-1)
   ORDER BY dp.ch DESC, dp.datapoint_seq DESC, measure_seq DESC;

BEGIN

   -- the chart context key specifies the serie. This may be modified
   l_ret := AdjustContextKey(a_cy, a_ch_context_key, a_data_point_link);

   OPEN c_ch ( a_cy , a_ch_context_key);
   FETCH c_ch INTO l_ch, l_datapoint_cnt, l_datapoint_unit, l_xr_measurements, l_creation_date, l_assign_cf;
   IF c_ch%NOTFOUND THEN -- all the charts in the serie are full or it is the first chart
        l_new_ch_needed := TRUE;
   ELSE
        l_new_ch_needed := FALSE;
   END IF;
   CLOSE c_ch;

   IF l_new_ch_needed = FALSE THEN
       -- chart can be in transition
      l_ret_code := UNAPIAUT.GetChAuthorisation( l_ch, l_cy_version, l_lc, l_lc_version, l_ss,
                                                  l_allow_modify, l_active, l_log_hs, l_log_hs_details);

      -- Check if chdp does already exist
      OPEN c_dp(a_cy, a_ch_context_key, a_data_point_link);
      FETCH c_dp INTO l_ch, l_datapoint_seq, l_measure_seq; -- exist => return existing values
      IF c_dp%NOTFOUND THEN
         -- Datapoint does not yet exist

         OPEN c_chmaxdatapointseq ( l_ch);
         FETCH c_chmaxdatapointseq INTO l_datapoint_seq;
         CLOSE c_chmaxdatapointseq;

         OPEN c_chmaxmeasureseq ( l_ch, l_datapoint_seq);
         FETCH c_chmaxmeasureseq INTO l_measure_seq;
         CLOSE c_chmaxmeasureseq;

         IF NVL(l_measure_seq, 0) < (NVL(l_xr_measurements,1) - 1) THEN --seq starts at 0
            l_datapoint_seq := NVL(l_datapoint_seq, 0);
            l_measure_seq := NVL(l_measure_seq, 0) + 1;
         ELSE
            l_datapoint_seq := NVL(l_datapoint_seq, -1) + 1; --default behaviour
            l_measure_seq := 0;
         END IF;
      END IF;
      CLOSE c_dp;
   END IF;

   IF l_new_ch_needed = TRUE THEN
      l_ret := GenerateChartID( a_cy, a_ch_context_key, l_ch);
      l_datapoint_seq := 0;   -- default trend-chart only has single value datapoints!
      l_measure_seq := 0;
   END IF;
   l_datapoint_link := a_data_point_link;

  -- no charting for customer or supplier specific parameter groups
   IF (UNAPIGEN.P_PP_KEY4CUSTOMER > 0 OR UNAPIGEN.P_PP_KEY4SUPPLIER >0) AND INSTR( l_datapoint_link, '#', 1,5) > 0 THEN
   -- retrieve information of the parameter
        l_sc := SUBSTR(l_datapoint_link, 1,   INSTR( l_datapoint_link, '#', 1, 1) - 1);
        l_pg := SUBSTR(l_datapoint_link, INSTR( l_datapoint_link, '#', 1, 1) +1 ,   INSTR( l_datapoint_link, '#', 1, 2) - INSTR( l_datapoint_link, '#', 1, 1) - 1);
        l_pgnode := TO_NUMBER(SUBSTR(l_datapoint_link, INSTR( l_datapoint_link, '#', 1, 2) +1 ,   INSTR( l_datapoint_link, '#', 1, 3) - INSTR( l_datapoint_link, '#', 1, 2) - 1));
        l_pa := SUBSTR(l_datapoint_link, INSTR( l_datapoint_link, '#', 1, 3) +1 ,   INSTR( l_datapoint_link, '#', 1, 4) - INSTR( l_datapoint_link, '#', 1, 3) - 1);
        l_panode := TO_NUMBER(SUBSTR(l_datapoint_link, INSTR( l_datapoint_link, '#', 1,4) +1 ,   INSTR( l_datapoint_link, '#', 1, 5) - INSTR( l_datapoint_link, '#', 1, 4) - 1));
        l_reanalysis:= TO_NUMBER(SUBSTR(l_datapoint_link, INSTR( l_datapoint_link, '#', 1,5) +1));
    OPEN c_ppkeys(l_sc, l_pgnode);
    FETCH c_ppkeys INTO l_pp_key1,l_pp_key2,l_pp_key3,l_pp_key4,l_pp_key5 ;
    CLOSE c_ppkeys;
    IF (l_pp_key1 <> ' ') THEN
        IF  (UNAPIGEN.P_PP_KEY4CUSTOMER = 1) OR  (UNAPIGEN.P_PP_KEY4SUPPLIER = 1)  THEN
            l_ch   := '';
        END IF;
    END IF;
    IF (l_pp_key2 <> ' ') THEN
        IF  (UNAPIGEN.P_PP_KEY4CUSTOMER = 2) OR  (UNAPIGEN.P_PP_KEY4SUPPLIER = 2)  THEN
            l_ch   := '';
        END IF;
    END IF;
    IF (l_pp_key3 <> ' ') THEN
        IF  (UNAPIGEN.P_PP_KEY4CUSTOMER = 3) OR  (UNAPIGEN.P_PP_KEY4SUPPLIER = 3)  THEN
            l_ch   := '';
        END IF;
    END IF;
    IF (l_pp_key4 <> ' ') THEN
        IF  (UNAPIGEN.P_PP_KEY4CUSTOMER = 4) OR  (UNAPIGEN.P_PP_KEY4SUPPLIER = 4)  THEN
            l_ch   := '';
        END IF;
    END IF;
    IF (l_pp_key5 <> ' ') THEN
        IF  (UNAPIGEN.P_PP_KEY4CUSTOMER = 5) OR  (UNAPIGEN.P_PP_KEY4SUPPLIER = 5)  THEN
            l_ch   := '';
        END IF;
    END IF;
   END IF;
   a_ch            := l_ch;
   a_datapoint_seq := l_datapoint_seq;
   a_measure_seq   := l_measure_seq;
   RETURN (UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF sqlcode <> 1 THEN
      UNAPIGEN.LogError('UNSQCASSIGN.TREND_CHART',sqlerrm);
   END IF ;
   RETURN(UNAPIGEN.AbortTxn(UNAPIGEN.P_TXN_ERROR,'TREND_CHART'));

END TREND_CHART;

FUNCTION DEASSIGN_CONTROL_CHART
(a_cy                  IN        VARCHAR2, /* VC20_TYPE  */
 a_ch_context_key      IN OUT    VARCHAR2, /* VC255_TYPE */
 a_data_point_link     IN           VARCHAR2, /* VC255_TYPE */
 a_ch                  OUT          VARCHAR2, /* VC20_TYPE */
 a_datapoint_seq       OUT          NUMBER  , /* NUM_TYPE */
 a_measure_seq         OUT          NUMBER  ) /* NUM_TYPE */
RETURN NUMBER IS
   l_ret          INTEGER;
   CURSOR c_dp(c_cy IN VARCHAR2, c_ch_context_key IN VARCHAR2, c_datapoint_link IN VARCHAR2) IS
      SELECT dp.ch, dp.datapoint_seq, dp.measure_seq
        FROM utch ch, utchdp dp
       WHERE ch.cy = c_cy
         AND ch.ch_context_key = c_ch_context_key
         AND NVL(UNAPIAUT.SQLGetChAllowModify(ch.ch), '0') = '1'
         AND ch.ch = dp.ch
         AND SUBSTR(dp.datapoint_link, 1, INSTR(dp.datapoint_link,'#',1,5)-1) =
                  SUBSTR(c_datapoint_link, 1, INSTR(c_datapoint_link,'#',1,5)-1)
      ORDER BY dp.ch DESC, dp.datapoint_seq DESC, measure_seq DESC;
BEGIN
   l_ret := AdjustContextKey(a_cy, a_ch_context_key, a_data_point_link);
   OPEN c_dp(a_cy, a_ch_context_key, a_data_point_link);
   FETCH c_dp INTO a_ch, a_datapoint_seq, a_measure_seq;
   CLOSE c_dp;

   -- For a control chart, it is never wanted that a datapoint is removed (eg. when canceled)
   RETURN (UNAPIGEN.DBERR_GENFAIL);
EXCEPTION
WHEN OTHERS THEN
   IF sqlcode <> 1 THEN
      UNAPIGEN.LogError('DEASSIGN_CONTROL_CHART',sqlerrm);
   END IF ;
   RETURN(UNAPIGEN.AbortTxn(UNAPIGEN.P_TXN_ERROR,'DEASSIGN_CONTROL_CHART'));
END DEASSIGN_CONTROL_CHART;

FUNCTION DEASSIGN_TREND_CHART
(a_cy                  IN        VARCHAR2, /* VC20_TYPE  */
 a_ch_context_key      IN OUT    VARCHAR2, /* VC255_TYPE */
 a_data_point_link     IN           VARCHAR2, /* VC255_TYPE */
 a_ch                  OUT          VARCHAR2, /* VC20_TYPE */
 a_datapoint_seq       OUT          NUMBER  , /* NUM_TYPE */
 a_measure_seq         OUT          NUMBER  ) /* NUM_TYPE */
RETURN NUMBER IS
   l_ret          INTEGER;
   CURSOR c_dp(c_cy IN VARCHAR2, c_ch_context_key IN VARCHAR2, c_datapoint_link IN VARCHAR2) IS
      SELECT dp.ch, dp.datapoint_seq, dp.measure_seq
        FROM utch ch, utchdp dp
       WHERE ch.cy = c_cy
         AND ch.ch_context_key = c_ch_context_key
         AND NVL(UNAPIAUT.SQLGetChAllowModify(ch.ch), '0') = '1'
         AND ch.ch = dp.ch
         AND SUBSTR(dp.datapoint_link, 1, INSTR(dp.datapoint_link,'#',1,5)-1) =
                  SUBSTR(c_datapoint_link, 1, INSTR(c_datapoint_link,'#',1,5)-1)
      ORDER BY dp.ch DESC, dp.datapoint_seq DESC, measure_seq DESC;
BEGIN
   l_ret := AdjustContextKey(a_cy, a_ch_context_key, a_data_point_link);
   OPEN c_dp(a_cy, a_ch_context_key, a_data_point_link);
   FETCH c_dp INTO a_ch, a_datapoint_seq, a_measure_seq;
   IF c_dp%NOTFOUND THEN
      -- not modifiable
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   END IF;
   CLOSE c_dp;

   RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
WHEN OTHERS THEN
   IF sqlcode <> 1 THEN
      UNAPIGEN.LogError('DEASSIGN_TREND_CHART',sqlerrm);
   END IF ;
   RETURN(UNAPIGEN.AbortTxn(UNAPIGEN.P_TXN_ERROR,'DEASSIGN_TREND_CHART'));
END DEASSIGN_TREND_CHART;

FUNCTION AdjustContextKey
(a_cy                  IN           VARCHAR2, /* VC20_TYPE */
 a_ch_context_key      IN OUT       VARCHAR2, /* VC255_TYPE */
 a_data_point_link     IN           VARCHAR2) /* VC255_TYPE */
RETURN NUMBER IS
BEGIN
   --Implement modifcation of the context key in this function
   --it will be called by standard Unilab to provide the right list of chartid
   --when a parameter is not yet assigned (API used is GetScPaChartList)
   -- it should also be call from the Assign functions like TREND_CHART and CONTROL_CHART

   --the standard structure of ch_context_key:
   --a_ch_context_key  := st#pg#pp_key1#pp_key2#pp_key3#pp_key4#pp_key5#pa
   --a_datapoint_link  := sc#pg#pgnode#pa#panode#reanalysis
   --
   RETURN(UNAPIGEN.DBERR_SUCCESS);
END AdjustContextKey;

END unsqcassign;
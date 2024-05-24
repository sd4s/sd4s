create or replace PACKAGE BODY
-- SIMATIC IT UNILAB package
-- $Revision: 6.3.0 $
-- $Date: 2007-02-22T14:44:00 $
unlocation AS


l_sql_string      VARCHAR2(2000);
l_result          NUMBER;
l_sqlerrm         VARCHAR2(255);

--internal function for tracing/logging in autonomous transaction
PROCEDURE TraceError
(a_api_name     IN        VARCHAR2,    /* VC40_TYPE */
 a_error_msg    IN        VARCHAR2)    /* VC255_TYPE */
IS
PRAGMA AUTONOMOUS_TRANSACTION;

BEGIN
   --autonomous transaction used here
   --UNAPIGEN.LogError is also an autonomous transaction but may rollback the current transaction
   INSERT INTO uterror(client_id, applic, who, logdate, logdate_tz, api_name, error_msg)
   VALUES (UNAPIGEN.P_CLIENT_ID, SUBSTR(UNAPIGEN.P_APPLIC_NAME,1,8), NVL(UNAPIGEN.P_USER,USER), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
           SUBSTR(a_api_name,1,40), SUBSTR(a_error_msg,1,255));
   COMMIT;
END TraceError;

--This function is called by UNAPISD.SaveSdCellSample
--and something is modifed to the study cell sample location
--The cell context is passed completely
--This function is also responsible for the UPDATE of utlo for the counter
--The possible a_modify_action values are:
-- 'SDCELLSC_DELETED' when a sample is deleted from a study cell
-- 'SDCELLSC_ADDED' when a sample is added to a study cell
-- 'SDCELLSC_UPDATED' when the cell sample location is updated

--TIPS: At the moment that this function is called
--      utsdcellsc is containing the new list of sample and the old one (negative sequence number)
--
--      Custom code should ideally call SaveSdCellSample with a lo_end_date to remove a sample from a location
--      and not call this function directly

FUNCTION UpdateLocationCounter
(a_sd                              IN     VARCHAR2, /* VC20_TYPE */
 a_cs                              IN     VARCHAR2, /* VC20_TYPE */
 a_csnode                          IN     NUMBER,   /* LONG_TYPE */
 a_tp                              IN     NUMBER,   /* NUM_TYPE */
 a_tp_unit                         IN     VARCHAR2, /* VC20_TYPE */
 a_tpnode                          IN     NUMBER,   /* LONG_TYPE */
 a_sc                              IN     VARCHAR2, /* VC20_TYPE */
 a_old_sdce_rec_lo                 IN     VARCHAR2, /* VC20_TYPE */
 a_old_sdce_rec_lo_description     IN     VARCHAR2, /* VC40_TYPE */
 a_old_sdce_rec_lo_start_date      IN     DATE,     /* DATE_TYPE */
 a_old_sdce_rec_lo_end_date        IN     DATE,     /* DATE_TYPE */
 a_new_sdce_rec_lo                 IN     VARCHAR2, /* VC20_TYPE */
 a_new_sdce_rec_lo_description     IN     VARCHAR2, /* VC40_TYPE */
 a_new_sdce_rec_lo_start_date      IN     DATE,     /* DATE_TYPE */
 a_new_sdce_rec_lo_end_date        IN     DATE,     /* DATE_TYPE */
 a_modify_action                   IN     VARCHAR2) /* VC20_TYPE */
RETURN NUMBER IS
l_curr_nr_sc      NUMBER;
l_nr_sc_max       NUMBER;
   PROCEDURE Increment(a_lo IN VARCHAR2)
   IS
   BEGIN
      UPDATE utlo
      SET curr_nr_sc = LEAST(curr_nr_sc+1, nr_sc_max)
      WHERE lo = a_lo
      RETURNING curr_nr_sc, nr_sc_max
      INTO l_curr_nr_sc, l_nr_sc_max;
      IF l_curr_nr_sc >= l_nr_sc_max THEN
         --possible: Send an e-mail to LimsAdminsitrator indicating that location is empty/nearly full
         TraceError('UNACTION.UpdateLocationCounter', 'Warning! location '||a_lo||' has reached its maximum');
      END IF;
   END Increment;

   PROCEDURE Decrement(a_lo IN VARCHAR2)
   IS
   BEGIN
      UPDATE utlo
      SET curr_nr_sc = GREATEST(curr_nr_sc-1, 0)
      WHERE lo = a_lo
      RETURNING curr_nr_sc
      INTO l_curr_nr_sc;
      IF l_curr_nr_sc <= 0 THEN
         --possible: Send an e-mail to LimsAdminsitrator indicating that location is empty/nearly full
         TraceError('UNACTION.UpdateLocationCounter', 'Warning! location '||a_lo||' is empty');
      END IF;
   END Decrement;

BEGIN


   --special rules may be implemented: defaults are straightforward
   --Assumption made here: lo_start_date filled in upon location assignment
   --TraceError('UNACTION.UpdateLocationCounter', 'a_modify_action='||a_modify_action||' Begin');

   IF a_modify_action = 'SDCELLSC_DELETED' AND  --sample is deleted and was affected to a location => decrement
      a_old_sdce_rec_lo_start_date IS NOT NULL AND
      a_old_sdce_rec_lo_end_date IS NULL THEN

      Decrement(a_old_sdce_rec_lo);

   ELSIF a_modify_action = 'SDCELLSC_ADDED' AND  --sample is added and affected to a location => increment
      a_new_sdce_rec_lo_start_date IS NOT NULL AND
      a_new_sdce_rec_lo_end_date IS NULL THEN

      Increment(a_new_sdce_rec_lo);

   ELSIF a_modify_action = 'SDCELLSC_UPDATED' THEN  --sample is updated => decrement or increment
      --location modified
      IF NVL(a_old_sdce_rec_lo, ' ') <> NVL(a_new_sdce_rec_lo, ' ') THEN
         --location modified
         IF a_old_sdce_rec_lo_end_date IS NULL THEN
            Decrement(a_old_sdce_rec_lo);
         END IF;
         IF a_new_sdce_rec_lo_end_date IS NULL THEN
            Increment(a_new_sdce_rec_lo);
         END IF;
      ELSE
         --location not modified
         --verify only the end_date modifications
         IF a_old_sdce_rec_lo_end_date IS NULL AND
            a_new_sdce_rec_lo_end_date IS NOT NULL THEN
            Decrement(a_old_sdce_rec_lo);
         END IF;

         IF a_old_sdce_rec_lo_end_date IS NOT NULL AND
            a_new_sdce_rec_lo_end_date IS NULL THEN
            Increment(a_old_sdce_rec_lo);
         END IF;
       END IF;
   END IF;

   --TraceError('UNACTION.UpdateLocationCounter', 'a_modify_action='||a_modify_action||' End count='||l_curr_nr_sc);
   RETURN(UNAPIGEN.DBERR_SUCCESS);
END UpdateLocationCounter;

--location counter toolbox
--Must be adapted when counting has been customized
--query that should return the right counter by location (pay attention: Full scan)
/*
SELECT a.lo, z.counter
   FROM utlo a, (SELECT b.lo, COUNT(DISTINCT sc) counter
                 FROM utsdcellsc b
                 WHERE lo_end_date IS NULL
     GROUP BY b.lo) z
   WHERE a.lo = z.lo
*/
-- Update to perform corrections (pay attention: Full scan)
/*
UPDATE utlo a
SET a.curr_nr_sc
= (SELECT COUNT(DISTINCT sc)
   FROM utsdcellsc b
   WHERE b.lo = a.lo
   AND lo_end_date IS NULL)
*/

END unlocation;
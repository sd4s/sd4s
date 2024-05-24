create or replace PACKAGE BODY
-- SIMATIC IT UNILAB package
-- $Revision: 6.3.1 (06.03.01.00_10.01) $
-- $Date: 2007-10-04T16:42:00 $
undiff AS
----------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--  PROJECT : Vredestein Enschede
-------------------------------------------------------------------------------
--  PACKAGE : UNDIFF
-- ABSTRACT :
--------------------------------------------------------------------------------
--   WRITER : Rody Sparenberg
--     DATE : 14/02/2007
--   TARGET : Oracle 10.2.0 / Unilab 6.3 SP1
--  VERSION : av3.0
--------------------------------------------------------------------------------
--  REMARKS :
--1. CompareAndCreatePp
--2. CompareAndCreateSt
--3. SynchronizeChildSpec
--4. SynchronizeDerivedSpec
--5. SynchronizeDerivedSampleType
--6. SynchronizeDerivedParameter
--7. SynchronizeDerivedMethod
--8. CompareAndCreatePr
--9. CompareAndCreateMt
--
--  Requires IN_UTSYSTEM_UNDIFF
--------------------------------------------------------------------------------
--  CHANGES :
--
--  When      | Who       | What
--============|===========|=====================================================
-- 07/12/2006 | RS        | Changed function CompareAndCreatePp
-- 07/12/2006 | RS        | Changed function CompareAndCreateSt
-- 14/02/2007 | RS        | Implemented systemsetting CompareAndCreatePp
-- 14/02/2007 | RS        | Implemented systemsetting CompareAndCreateSt
-- 28/03/2007 | RS        | Merged into 1 system setting
-- 03/03/2011 | RS        | Replaced by Siemens Version V6.3
--                        | Reintroduced customizations
-- 04/03/2011 | RS        | Replaced by Siemens Version V6.3 SP1
--                        | Reintroduced customizations
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
ics_package_name CONSTANT VARCHAR2(20) := 'UNDIFF';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
l_sqlerrm         VARCHAR2(255);
l_sql_string      VARCHAR2(2000);
l_where_clause    VARCHAR2(1000);
l_event_tp        utev.ev_tp%TYPE;
l_ret_code        NUMBER;
l_result          NUMBER;
l_fetched_rows    NUMBER;
l_ev_seq_nr       NUMBER;
StpError          EXCEPTION;

P_PP_KEY4PLANT    NUMBER;

--This flag is indicating if the used object version column
--is ignored when comparing list of used objects
c_ignore_stpp_pp_version  CHAR(1) := '1';
--This flag is indicating if the stpp order specified in newref_st
--must be kept or not
--when set to '0' the order of parameter profiles in old_st will be kept
c_keep_newversion_stpp_order   CHAR(1) := '0';
--This flag is indicating if the pppr order specified in newref_pp
--must be kept or not
--when set to '0' the order of parameters in old_pp will be kept
c_keep_newversion_pppr_order   CHAR(1) := '0';
--This flag is indicating if the prmt order specified in newref_pr
--must be kept or not
--when set to '0' the order of parameters in old_pr will be kept
c_keep_newversion_prmt_order   CHAR(1) := '0';

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

FUNCTION CompareAndCreatePp
(a_oldref_pp           IN     VARCHAR2,       /* VC20_TYPE */
 a_oldref_pp_version   IN     VARCHAR2,       /* VC20_TYPE */
 a_oldref_pp_key1      IN     VARCHAR2,       /* VC20_TYPE */
 a_oldref_pp_key2      IN     VARCHAR2,       /* VC20_TYPE */
 a_oldref_pp_key3      IN     VARCHAR2,       /* VC20_TYPE */
 a_oldref_pp_key4      IN     VARCHAR2,       /* VC20_TYPE */
 a_oldref_pp_key5      IN     VARCHAR2,       /* VC20_TYPE */
 a_newref_pp           IN     VARCHAR2,       /* VC20_TYPE */
 a_newref_pp_version   IN     VARCHAR2,       /* VC20_TYPE */
 a_newref_pp_key1      IN     VARCHAR2,       /* VC20_TYPE */
 a_newref_pp_key2      IN     VARCHAR2,       /* VC20_TYPE */
 a_newref_pp_key3      IN     VARCHAR2,       /* VC20_TYPE */
 a_newref_pp_key4      IN     VARCHAR2,       /* VC20_TYPE */
 a_newref_pp_key5      IN     VARCHAR2,       /* VC20_TYPE */
 a_old_pp              IN     VARCHAR2,       /* VC20_TYPE */
 a_old_pp_version      IN     VARCHAR2,       /* VC20_TYPE */
 a_old_pp_key1         IN     VARCHAR2,       /* VC20_TYPE */
 a_old_pp_key2         IN     VARCHAR2,       /* VC20_TYPE */
 a_old_pp_key3         IN     VARCHAR2,       /* VC20_TYPE */
 a_old_pp_key4         IN     VARCHAR2,       /* VC20_TYPE */
 a_old_pp_key5         IN     VARCHAR2,       /* VC20_TYPE */
 a_new_pp              IN     VARCHAR2,       /* VC20_TYPE */
 a_new_pp_version      IN     VARCHAR2,       /* VC20_TYPE */
 a_new_pp_key1         IN     VARCHAR2,       /* VC20_TYPE */
 a_new_pp_key2         IN     VARCHAR2,       /* VC20_TYPE */
 a_new_pp_key3         IN     VARCHAR2,       /* VC20_TYPE */
 a_new_pp_key4         IN     VARCHAR2,       /* VC20_TYPE */
 a_new_pp_key5         IN     VARCHAR2)       /* VC20_TYPE */
RETURN NUMBER IS

l_seq                            NUMBER(5);
l_prev_pr                        VARCHAR2(20);
l_insteadofnull                  VARCHAR2(60);
l_order_modified_in_oldpp        CHAR(1);
l_max_seq_in_new_pp              NUMBER(5);
l_reorder_seq                    NUMBER(5);
l_error_logged                   BOOLEAN;
l_entered_loop                   BOOLEAN;
l_orig_seq                       INTEGER;
l_some_pr_appended_in_oldpp      BOOLEAN;
l_reorder_took_place             BOOLEAN;
l_count_follows_not_common1      INTEGER;
l_count_follows_not_common2      INTEGER;
lvs_change_ss_pp                 VARCHAR2(20);
--utpp cursors and variables
CURSOR l_utpp_cursor (c_pp IN VARCHAR2,
                      c_pp_version IN VARCHAR2,
                      c_pp_key1    IN VARCHAR2,
                      c_pp_key2    IN VARCHAR2,
                      c_pp_key3    IN VARCHAR2,
                      c_pp_key4    IN VARCHAR2,
                      c_pp_key5    IN VARCHAR2) IS
SELECT *
FROM utpp
WHERE pp = c_pp
AND version = c_pp_version
AND pp_key1 = c_pp_key1
AND pp_key2 = c_pp_key2
AND pp_key3 = c_pp_key3
AND pp_key4 = c_pp_key4
AND pp_key5 = c_pp_key5;
l_oldref_utpp_rec   l_utpp_cursor%ROWTYPE;
l_newref_utpp_rec   l_utpp_cursor%ROWTYPE;
l_old_utpp_rec      l_utpp_cursor%ROWTYPE;
l_new_utpp_rec      l_utpp_cursor%ROWTYPE;

--utppau cursors and variables
--assumption: au_version always NULL
CURSOR l_new_utppau_cursor IS
   --all attributes in oldpp
   --and that have not been suppressed in newref
   -- Part1= 1 (NOT IN 2) AND IN 3
   -- 1= all attributes in the old_pp
   -- old_pp has some differences with oldref, these modifications must be kept
   -- the subqueries are returning these differences
   -- 2= list of attributes that have been suppressed from oldref to make the final old_pp
   -- 3= list of attribute values that have not been modified between OLD_REF and OLD (values will be taken from NEW when applicable)
   --
   /* 1 */
   SELECT au, value
     FROM utppau
    WHERE pp = a_old_pp
      AND version = a_old_pp_version
      AND pp_key1 = a_old_pp_key1
      AND pp_key2 = a_old_pp_key2
      AND pp_key3 = a_old_pp_key3
      AND pp_key4 = a_old_pp_key4
      AND pp_key5 = a_old_pp_key5
    /* 2 */
    AND au NOT IN (SELECT au
                   FROM utppau
                   WHERE pp = a_old_pp
                     AND version = a_old_pp_version
                     AND pp_key1 = a_old_pp_key1
                     AND pp_key2 = a_old_pp_key2
                     AND pp_key3 = a_old_pp_key3
                     AND pp_key4 = a_old_pp_key4
                     AND pp_key5 = a_old_pp_key5
                   INTERSECT
                     (SELECT au
                      FROM utppau
                      WHERE pp = a_oldref_pp
                        AND version = a_oldref_pp_version
                        AND pp_key1 = a_oldref_pp_key1
                        AND pp_key2 = a_oldref_pp_key2
                        AND pp_key3 = a_oldref_pp_key3
                        AND pp_key4 = a_oldref_pp_key4
                        AND pp_key5 = a_oldref_pp_key5
                      MINUS
                      SELECT au
                      FROM utppau
                      WHERE pp = a_newref_pp
                        AND version = a_newref_pp_version
                        AND pp_key1 = a_newref_pp_key1
                        AND pp_key2 = a_newref_pp_key2
                        AND pp_key3 = a_newref_pp_key3
                        AND pp_key4 = a_newref_pp_key4
                        AND pp_key5 = a_newref_pp_key5
                     )
                   )
    /* 3 */
    --test might seem strange but is alo good for single valued attributes
    --The attribute values are not compared one by one but the list of values are compared
    --LOV are compared here
    --subquery is returning any attribute where the LOV has been modified
    --test is inverted here (would result in two times NOT IN)
    --subquery returns all attributes for which the list of values has been modified in OLD compared to OLD_REF
    AND au IN (SELECT DISTINCT au FROM
                     ((SELECT au, value
                       FROM utppau
                       WHERE pp = a_old_pp
                         AND version = a_old_pp_version
                         AND pp_key1 = a_old_pp_key1
                         AND pp_key2 = a_old_pp_key2
                         AND pp_key3 = a_old_pp_key3
                         AND pp_key4 = a_old_pp_key4
                         AND pp_key5 = a_old_pp_key5
                       UNION
                       SELECT au, value
                       FROM utppau
                       WHERE pp = a_oldref_pp
                         AND version = a_oldref_pp_version
                         AND pp_key1 = a_oldref_pp_key1
                         AND pp_key2 = a_oldref_pp_key2
                         AND pp_key3 = a_oldref_pp_key3
                         AND pp_key4 = a_oldref_pp_key4
                         AND pp_key5 = a_oldref_pp_key5
                       )
                      MINUS
                      (SELECT au, value
                       FROM utppau
                       WHERE pp = a_old_pp
                         AND version = a_old_pp_version
                         AND pp_key1 = a_old_pp_key1
                         AND pp_key2 = a_old_pp_key2
                         AND pp_key3 = a_old_pp_key3
                         AND pp_key4 = a_old_pp_key4
                         AND pp_key5 = a_old_pp_key5
                       INTERSECT
                       SELECT au, value
                       FROM utppau
                       WHERE pp = a_oldref_pp
                         AND version = a_oldref_pp_version
                         AND pp_key1 = a_oldref_pp_key1
                         AND pp_key2 = a_oldref_pp_key2
                         AND pp_key3 = a_oldref_pp_key3
                         AND pp_key4 = a_oldref_pp_key4
                         AND pp_key5 = a_oldref_pp_key5
                      )
                     )
               )
   UNION
   --all attributes in newref that are not already in oldpp
   --and that have not been suppressed
   -- Part2= 1 (NOT IN 2)
   -- 1= all attributes in the newref_pp
   -- newref_pp has some differences with oldref, these modifications must be kept
   -- the subqueries are returning these differences
   -- 2= list of attributes that are already in old_pp or that have been suppressed from oldref to make the final old_pp
   /* 1 */
   SELECT au, value
   FROM utppau
   WHERE pp = a_newref_pp
     AND version = a_newref_pp_version
     AND pp_key1 = a_newref_pp_key1
     AND pp_key2 = a_newref_pp_key2
     AND pp_key3 = a_newref_pp_key3
     AND pp_key4 = a_newref_pp_key4
     AND pp_key5 = a_newref_pp_key5
   /* 2 */
   AND au NOT IN (SELECT au
                  FROM utppau
                  WHERE pp = a_old_pp
                    AND version = a_old_pp_version
                    AND pp_key1 = a_old_pp_key1
                    AND pp_key2 = a_old_pp_key2
                    AND pp_key3 = a_old_pp_key3
                    AND pp_key4 = a_old_pp_key4
                    AND pp_key5 = a_old_pp_key5)
   AND au NOT IN (SELECT au
                  FROM utppau
                  WHERE pp = a_oldref_pp
                    AND version = a_oldref_pp_version
                    AND pp_key1 = a_oldref_pp_key1
                    AND pp_key2 = a_oldref_pp_key2
                    AND pp_key3 = a_oldref_pp_key3
                    AND pp_key4 = a_oldref_pp_key4
                    AND pp_key5 = a_oldref_pp_key5
                  INTERSECT
                  SELECT au
                  FROM utppau
                  WHERE pp = a_newref_pp
                    AND version = a_newref_pp_version
                    AND pp_key1 = a_newref_pp_key1
                    AND pp_key2 = a_newref_pp_key2
                    AND pp_key3 = a_newref_pp_key3
                    AND pp_key4 = a_newref_pp_key4
                    AND pp_key5 = a_newref_pp_key5)
   UNION
   --Add all attributes in newref that are already in oldpp
   --that have not been updated in oldpp
   --and that have not been suppressed
   -- Part3= 1 (NOT IN 2)
   -- 1= all attributes in the newref_pp
   -- 2= list of attributes that have been changed between OLD_REF and OLD
   --LOV are compared here
   --subquery is returning any attribute where the LOV has been modified
   --subquery returns all attributes for which the list of values has been modified in OLD compared to OLD_REF
   /* 1 */
   SELECT au, value
   FROM utppau
   WHERE pp = a_newref_pp
     AND version = a_newref_pp_version
     AND pp_key1 = a_newref_pp_key1
     AND pp_key2 = a_newref_pp_key2
     AND pp_key3 = a_newref_pp_key3
     AND pp_key4 = a_newref_pp_key4
     AND pp_key5 = a_newref_pp_key5
   /* 2 */
    AND au NOT IN (SELECT DISTINCT au FROM
                     ((SELECT au, value
                       FROM utppau
                       WHERE pp = a_old_pp
                         AND version = a_old_pp_version
                         AND pp_key1 = a_old_pp_key1
                         AND pp_key2 = a_old_pp_key2
                         AND pp_key3 = a_old_pp_key3
                         AND pp_key4 = a_old_pp_key4
                         AND pp_key5 = a_old_pp_key5
                       UNION
                       SELECT au, value
                       FROM utppau
                       WHERE pp = a_oldref_pp
                         AND version = a_oldref_pp_version
                         AND pp_key1 = a_oldref_pp_key1
                         AND pp_key2 = a_oldref_pp_key2
                         AND pp_key3 = a_oldref_pp_key3
                         AND pp_key4 = a_oldref_pp_key4
                         AND pp_key5 = a_oldref_pp_key5
                       )
                      MINUS
                      (SELECT au, value
                       FROM utppau
                       WHERE pp = a_old_pp
                         AND version = a_old_pp_version
                         AND pp_key1 = a_old_pp_key1
                         AND pp_key2 = a_old_pp_key2
                         AND pp_key3 = a_old_pp_key3
                         AND pp_key4 = a_old_pp_key4
                         AND pp_key5 = a_old_pp_key5
                       INTERSECT
                       SELECT au, value
                       FROM utppau
                       WHERE pp = a_oldref_pp
                         AND version = a_oldref_pp_version
                         AND pp_key1 = a_oldref_pp_key1
                         AND pp_key2 = a_oldref_pp_key2
                         AND pp_key3 = a_oldref_pp_key3
                         AND pp_key4 = a_oldref_pp_key4
                         AND pp_key5 = a_oldref_pp_key5
                      )
                     )
               )
   ORDER BY au, value;

--utpppr cursors and variables
CURSOR l_ppprls_cursor IS
SELECT *
FROM utpppr
WHERE pp = a_newref_pp
  AND version = a_newref_pp_version
  AND pp_key1 = a_newref_pp_key1
  AND pp_key2 = a_newref_pp_key2
  AND pp_key3 = a_newref_pp_key3
  AND pp_key4 = a_newref_pp_key4
  AND pp_key5 = a_newref_pp_key5
  AND (pp, pr, pr_version) IN
   (SELECT pp, pr, pr_version
   FROM utpppr
   WHERE pp = a_newref_pp
     AND version = a_newref_pp_version
     AND pp_key1 = a_newref_pp_key1
     AND pp_key2 = a_newref_pp_key2
     AND pp_key3 = a_newref_pp_key3
     AND pp_key4 = a_newref_pp_key4
     AND pp_key5 = a_newref_pp_key5
   UNION
   (SELECT pp, pr, pr_version
    FROM utpppr
    WHERE pp = a_old_pp
      AND version = a_old_pp_version
      AND pp_key1 = a_old_pp_key1
      AND pp_key2 = a_old_pp_key2
      AND pp_key3 = a_old_pp_key3
      AND pp_key4 = a_old_pp_key4
      AND pp_key5 = a_old_pp_key5
    MINUS
    SELECT pp, pr, pr_version
    FROM utpppr
    WHERE pp = a_oldref_pp
      AND version = a_oldref_pp_version
      AND pp_key1 = a_oldref_pp_key1
      AND pp_key2 = a_oldref_pp_key2
      AND pp_key3 = a_oldref_pp_key3
      AND pp_key4 = a_oldref_pp_key4
      AND pp_key5 = a_oldref_pp_key5)
   MINUS
   (SELECT pp, pr, pr_version
    FROM utpppr
    WHERE pp = a_oldref_pp
      AND version = a_oldref_pp_version
      AND pp_key1 = a_oldref_pp_key1
      AND pp_key2 = a_oldref_pp_key2
      AND pp_key3 = a_oldref_pp_key3
      AND pp_key4 = a_oldref_pp_key4
      AND pp_key5 = a_oldref_pp_key5
    MINUS
    SELECT pp, pr, pr_version
    FROM utpppr
    WHERE pp = a_old_pp
      AND version = a_old_pp_version
      AND pp_key1 = a_old_pp_key1
      AND pp_key2 = a_old_pp_key2
      AND pp_key3 = a_old_pp_key3
      AND pp_key4 = a_old_pp_key4
      AND pp_key5 = a_old_pp_key5))
   ORDER BY seq;

--This cursor is searching for the same parameter in a parameter profile
--with the same relative position
--
-- Example: pp1 v1.0                  pp1 v2.0
--          seq 1 pr1 rel_pos=1       seq 1 pr1 rel_pos=1
--          seq 2 pr2 rel_pos=1       seq 2 pr1 rel_pos=2
--          seq 3 pr1 rel_pos=2
-- The second pr1 parameter in pp1 v1.0 has the same relative position as
-- the second pr1 parameter but they have different sequences.
-- This query allows to perform search in function of relative positions
--
-- Note that 2 parameters with different pr_version are considered as different parameters
--
CURSOR l_utpppr_cursor (c_pp IN VARCHAR2,
                        c_pp_version IN VARCHAR2,
                        c_pp_key1    IN VARCHAR2,
                        c_pp_key2    IN VARCHAR2,
                        c_pp_key3    IN VARCHAR2,
                        c_pp_key4    IN VARCHAR2,
                        c_pp_key5    IN VARCHAR2,
                        c_pr         IN VARCHAR2,
                        c_pr_version IN VARCHAR2,
                        c_seq        IN NUMBER) IS
SELECT a.*
FROM utpppr a
WHERE (a.pp, a.version, a.pr, a.pr_version, a.seq) IN
(SELECT k.pp, k.version, k.pr, k.pr_version, k.seq
 FROM
    (SELECT ROWNUM relpos, b.pp, b.version, b.pr, b.pr_version, b.seq
    FROM
       (SELECT c.pp, c.version, c.pr, c.pr_version, c.seq
       FROM utpppr c
       WHERE c.pp = a_newref_pp
       AND c.version = a_newref_pp_version
       AND c.pp_key1 = a_newref_pp_key1
       AND c.pp_key2 = a_newref_pp_key2
       AND c.pp_key3 = a_newref_pp_key3
       AND c.pp_key4 = a_newref_pp_key4
       AND c.pp_key5 = a_newref_pp_key5
       AND c.pr = c_pr
       AND c.pr_version = c_pr_version
       GROUP BY c.pp, c.version, c.pr, c.pr_version, c.seq) b) z,
    (SELECT ROWNUM relpos, b.pp, b.version, b.pr, b.pr_version, b.seq
    FROM
       (SELECT c.pp, c.version, c.pr, c.pr_version, c.seq
       FROM utpppr c
       WHERE c.pp = c_pp
       AND c.version = c_pp_version
       AND c.pp_key1 = c_pp_key1
       AND c.pp_key2 = c_pp_key2
       AND c.pp_key3 = c_pp_key3
       AND c.pp_key4 = c_pp_key4
       AND c.pp_key5 = c_pp_key5
       AND c.pr = c_pr
       AND c.pr_version = c_pr_version
       GROUP BY c.pp, c.version, c.pr, c.pr_version, c.seq) b) k
    WHERE k.relpos = z.relpos
    AND z.seq = c_seq)
AND a.pp_key1 = c_pp_key1
AND a.pp_key2 = c_pp_key2
AND a.pp_key3 = c_pp_key3
AND a.pp_key4 = c_pp_key4
AND a.pp_key5 = c_pp_key5
ORDER BY a.seq;
l_oldref_utpppr_rec   utpppr%ROWTYPE;
l_newref_utpppr_rec   utpppr%ROWTYPE;
l_old_utpppr_rec      utpppr%ROWTYPE;
l_new_utpppr_rec      utpppr%ROWTYPE;

--utppprau cursors and variables
--assumptions: au_version always NULL, pr_version ignored since 2 pr with diferent pr_version may not have different attributes
CURSOR l_new_utppprau_cursor IS
   --all attributes in oldpp
   --and that have not been suppressed in newref
   -- (attibutes can have been suppressed or parameters can have been suppressed)
   -- Part1= 1 (NOT IN 2) AND IN 3 AND IN 4 AND (NOT IN 5)
   -- 1= all attributes in the old_pp
   -- old_pp has some differences with oldref, these modifications must be kept
   -- the subqueries are returning these differences
   -- 2= list of attributes that have been suppressed from oldref to make the final old_pp
   -- 3= list of parameters that have been suppressed from oldref to make the final old_pp
   -- 4= list of attribute values that have not been modified between OLD_REF and OLD (values will be taken from NEW when applicable)
   --
   /* 1 */
   SELECT pr, au, value
     FROM utppprau
    WHERE pp = a_old_pp
      AND version = a_old_pp_version
      AND pp_key1 = a_old_pp_key1
      AND pp_key2 = a_old_pp_key2
      AND pp_key3 = a_old_pp_key3
      AND pp_key4 = a_old_pp_key4
      AND pp_key5 = a_old_pp_key5
      /* 2 */
      AND (pr, au) NOT IN (SELECT pr, au
                    FROM utppprau
                    WHERE pp = a_old_pp
                      AND version = a_old_pp_version
                      AND pp_key1 = a_old_pp_key1
                      AND pp_key2 = a_old_pp_key2
                      AND pp_key3 = a_old_pp_key3
                      AND pp_key4 = a_old_pp_key4
                      AND pp_key5 = a_old_pp_key5
                    INTERSECT
                      (SELECT pr, au
                       FROM utppprau
                       WHERE pp = a_oldref_pp
                         AND version = a_oldref_pp_version
                         AND pp_key1 = a_oldref_pp_key1
                         AND pp_key2 = a_oldref_pp_key2
                         AND pp_key3 = a_oldref_pp_key3
                         AND pp_key4 = a_oldref_pp_key4
                         AND pp_key5 = a_oldref_pp_key5
                       MINUS
                       SELECT pr, au
                       FROM utppprau
                       WHERE pp = a_newref_pp
                         AND version = a_newref_pp_version
                         AND pp_key1 = a_newref_pp_key1
                         AND pp_key2 = a_newref_pp_key2
                         AND pp_key3 = a_newref_pp_key3
                         AND pp_key4 = a_newref_pp_key4
                         AND pp_key5 = a_newref_pp_key5))
      /* 3 */
      AND pr NOT IN (SELECT pr
                    FROM utpppr
                    WHERE pp = a_old_pp
                      AND version = a_old_pp_version
                      AND pp_key1 = a_old_pp_key1
                      AND pp_key2 = a_old_pp_key2
                      AND pp_key3 = a_old_pp_key3
                      AND pp_key4 = a_old_pp_key4
                      AND pp_key5 = a_old_pp_key5
                    INTERSECT
                      (SELECT pr
                       FROM utpppr
                       WHERE pp = a_oldref_pp
                         AND version = a_oldref_pp_version
                         AND pp_key1 = a_oldref_pp_key1
                         AND pp_key2 = a_oldref_pp_key2
                         AND pp_key3 = a_oldref_pp_key3
                         AND pp_key4 = a_oldref_pp_key4
                         AND pp_key5 = a_oldref_pp_key5
                       MINUS
                       SELECT pr
                       FROM utpppr
                       WHERE pp = a_newref_pp
                         AND version = a_newref_pp_version
                         AND pp_key1 = a_newref_pp_key1
                         AND pp_key2 = a_newref_pp_key2
                         AND pp_key3 = a_newref_pp_key3
                         AND pp_key4 = a_newref_pp_key4
                         AND pp_key5 = a_newref_pp_key5))
      /* 4 */
      --test might seem strange but is also good for single valued attributes
      --The attribute values are not compared one by one but the list of values are compared
      --LOV are compared here
      --subquery is returning any attribute where the LOV has been modified
      --test is inverted here (would result in two times NOT IN)
      --subquery returns all attributes for which the list of values has been modified in OLD compared to OLD_REF
      AND (pr, au)
           IN (SELECT DISTINCT pr, au
                 FROM ((SELECT pr, au, value
                          FROM utppprau
                          WHERE pp = a_old_pp
                            AND version = a_old_pp_version
                            AND pp_key1 = a_old_pp_key1
                            AND pp_key2 = a_old_pp_key2
                            AND pp_key3 = a_old_pp_key3
                            AND pp_key4 = a_old_pp_key4
                            AND pp_key5 = a_old_pp_key5
                        UNION
                        SELECT pr, au, value
                          FROM utppprau
                         WHERE pp = a_oldref_pp
                           AND version = a_oldref_pp_version
                           AND pp_key1 = a_oldref_pp_key1
                           AND pp_key2 = a_oldref_pp_key2
                           AND pp_key3 = a_oldref_pp_key3
                           AND pp_key4 = a_oldref_pp_key4
                           AND pp_key5 = a_oldref_pp_key5
                       )
                       MINUS
                       (SELECT pr, au, value
                          FROM utppprau
                          WHERE pp = a_old_pp
                            AND version = a_old_pp_version
                            AND pp_key1 = a_old_pp_key1
                            AND pp_key2 = a_old_pp_key2
                            AND pp_key3 = a_old_pp_key3
                            AND pp_key4 = a_old_pp_key4
                            AND pp_key5 = a_old_pp_key5
                        INTERSECT
                        SELECT pr, au, value
                          FROM utppprau
                         WHERE pp = a_oldref_pp
                           AND version = a_oldref_pp_version
                           AND pp_key1 = a_oldref_pp_key1
                           AND pp_key2 = a_oldref_pp_key2
                           AND pp_key3 = a_oldref_pp_key3
                           AND pp_key4 = a_oldref_pp_key4
                           AND pp_key5 = a_oldref_pp_key5
                       )
                      )
                   )
   UNION
   --all attributes in newref that are not already in oldpp
   --and that have not been suppressed
   -- (attibutes can have been suppressed or parameters can have been suppressed)
   -- Part2= 1 (NOT IN 2) AND (NOT IN 3)
   -- 1= all attributes in the newref_pp
   -- newref_pp has some differences with oldref, these modifications must be kept
   -- the subqueries are returning these differences
   -- 2= list of attributes that are already in old_pp or that have been suppressed from oldref to make the final old_pp
   -- 3= list of parameters deleted from oldref to make old_pp
   --
   /* 1 */
   SELECT pr, au, value
   FROM utppprau
   WHERE pp = a_newref_pp
     AND version = a_newref_pp_version
     AND pp_key1 = a_newref_pp_key1
     AND pp_key2 = a_newref_pp_key2
     AND pp_key3 = a_newref_pp_key3
     AND pp_key4 = a_newref_pp_key4
     AND pp_key5 = a_newref_pp_key5
     /* 2 */
     AND (pr, au)
          NOT IN (SELECT pr, au
                  FROM utppprau
                  WHERE pp = a_old_pp
                    AND version = a_old_pp_version
                    AND pp_key1 = a_old_pp_key1
                    AND pp_key2 = a_old_pp_key2
                    AND pp_key3 = a_old_pp_key3
                    AND pp_key4 = a_old_pp_key4
                    AND pp_key5 = a_old_pp_key5
                  )
     AND (pr, au)
          NOT IN (SELECT pr, au
                  FROM utppprau
                  WHERE pp = a_oldref_pp
                    AND version = a_oldref_pp_version
                    AND pp_key1 = a_oldref_pp_key1
                    AND pp_key2 = a_oldref_pp_key2
                    AND pp_key3 = a_oldref_pp_key3
                    AND pp_key4 = a_oldref_pp_key4
                    AND pp_key5 = a_oldref_pp_key5
                  MINUS
                  SELECT pr, au
                  FROM utppprau
                  WHERE pp = a_old_pp
                    AND version = a_old_pp_version
                    AND pp_key1 = a_old_pp_key1
                    AND pp_key2 = a_old_pp_key2
                    AND pp_key3 = a_old_pp_key3
                    AND pp_key4 = a_old_pp_key4
                    AND pp_key5 = a_old_pp_key5
                 )
  /* 3 */
  AND pr
      NOT IN (SELECT pr
              FROM utpppr
              WHERE pp = a_oldref_pp
                AND version = a_oldref_pp_version
                AND pp_key1 = a_oldref_pp_key1
                AND pp_key2 = a_oldref_pp_key2
                AND pp_key3 = a_oldref_pp_key3
                AND pp_key4 = a_oldref_pp_key4
                AND pp_key5 = a_oldref_pp_key5
              MINUS
              SELECT pr
              FROM utpppr
              WHERE pp = a_old_pp
                AND version = a_old_pp_version
                AND pp_key1 = a_old_pp_key1
                AND pp_key2 = a_old_pp_key2
                AND pp_key3 = a_old_pp_key3
                AND pp_key4 = a_old_pp_key4
                AND pp_key5 = a_old_pp_key5
             )
   UNION
   --Add all attributes in newref that are already in oldpp
   --that have not been updated in oldpp
   --and that have not been suppressed
   -- Part3= 1 (NOT IN 2) AND (NOT IN 3)
   -- 1= all attributes in the newref_pp
   -- 2= list of attributes that have been changed between OLD_REF and OLD
   -- 3= list of suppressed parameters
   --LOV are compared here
   --subquery is returning any attribute where the LOV has been modified
   --subquery returns all attributes for which the list of values has been modified in OLD compared to OLD_REF
   /* 1 */
   SELECT pr, au, value
   FROM utppprau
   WHERE pp = a_newref_pp
     AND version = a_newref_pp_version
     AND pp_key1 = a_newref_pp_key1
     AND pp_key2 = a_newref_pp_key2
     AND pp_key3 = a_newref_pp_key3
     AND pp_key4 = a_newref_pp_key4
     AND pp_key5 = a_newref_pp_key5
   /* 2 */
   AND (pr, au)
        NOT IN (SELECT DISTINCT pr, au FROM
                     ((SELECT pr, au, value
                       FROM utppprau
                       WHERE pp = a_old_pp
                         AND version = a_old_pp_version
                         AND pp_key1 = a_old_pp_key1
                         AND pp_key2 = a_old_pp_key2
                         AND pp_key3 = a_old_pp_key3
                         AND pp_key4 = a_old_pp_key4
                         AND pp_key5 = a_old_pp_key5
                       UNION
                       SELECT pr, au, value
                       FROM utppprau
                       WHERE pp = a_oldref_pp
                         AND version = a_oldref_pp_version
                         AND pp_key1 = a_oldref_pp_key1
                         AND pp_key2 = a_oldref_pp_key2
                         AND pp_key3 = a_oldref_pp_key3
                         AND pp_key4 = a_oldref_pp_key4
                         AND pp_key5 = a_oldref_pp_key5
                      )
                     MINUS
                     (SELECT pr, au, value
                       FROM utppprau
                       WHERE pp = a_old_pp
                         AND version = a_old_pp_version
                         AND pp_key1 = a_old_pp_key1
                         AND pp_key2 = a_old_pp_key2
                         AND pp_key3 = a_old_pp_key3
                         AND pp_key4 = a_old_pp_key4
                         AND pp_key5 = a_old_pp_key5
                       INTERSECT
                       SELECT pr, au, value
                       FROM utppprau
                       WHERE pp = a_oldref_pp
                         AND version = a_oldref_pp_version
                         AND pp_key1 = a_oldref_pp_key1
                         AND pp_key2 = a_oldref_pp_key2
                         AND pp_key3 = a_oldref_pp_key3
                         AND pp_key4 = a_oldref_pp_key4
                         AND pp_key5 = a_oldref_pp_key5
                      )
                     )
               )
   /* 3 */
   AND pr
       NOT IN (SELECT pr
                 FROM utpppr
                 WHERE pp = a_oldref_pp
                   AND version = a_oldref_pp_version
                   AND pp_key1 = a_oldref_pp_key1
                   AND pp_key2 = a_oldref_pp_key2
                   AND pp_key3 = a_oldref_pp_key3
                   AND pp_key4 = a_oldref_pp_key4
                   AND pp_key5 = a_oldref_pp_key5
               MINUS
               SELECT pr
               FROM utpppr
                       WHERE pp = a_old_pp
                         AND version = a_old_pp_version
                         AND pp_key1 = a_old_pp_key1
                         AND pp_key2 = a_old_pp_key2
                         AND pp_key3 = a_old_pp_key3
                         AND pp_key4 = a_old_pp_key4
                         AND pp_key5 = a_old_pp_key5
              )
   ORDER BY pr, au, value;

--utppspa cursors and variables
CURSOR l_ppspals_cursor IS
   SELECT a.pp, a.version, a.pp_key1, a.pp_key2, a.pp_key3, a.pp_key4, a.pp_key5,
          a.pr, a.pr_version, a.seq, b.low_limit, b.high_limit, b.low_spec, b.high_spec,
          b.low_dev, b.rel_low_dev, b.target, b.high_dev, b.rel_high_dev
   FROM utpppr a, utppspa b
   WHERE a.pp = a_newref_pp
     AND a.version = a_newref_pp_version
     AND a.pp_key1 = a_newref_pp_key1
     AND a.pp_key2 = a_newref_pp_key2
     AND a.pp_key3 = a_newref_pp_key3
     AND a.pp_key4 = a_newref_pp_key4
     AND a.pp_key5 = a_newref_pp_key5
     AND b.pp(+) = a.pp
     AND b.version(+) = a.version
     AND b.pp_key1(+) = a.pp_key1
     AND b.pp_key2(+) = a.pp_key2
     AND b.pp_key3(+) = a.pp_key3
     AND b.pp_key4(+) = a.pp_key4
     AND b.pp_key5(+) = a.pp_key5
     AND b.pr(+) = a.pr
     AND b.pr_version(+) = a.pr_version
     AND (a.pp, a.pr, a.pr_version) IN
      (SELECT pp, pr, pr_version
      FROM utppspa
      WHERE pp = a_newref_pp
        AND version = a_newref_pp_version
        AND pp_key1 = a_newref_pp_key1
        AND pp_key2 = a_newref_pp_key2
        AND pp_key3 = a_newref_pp_key3
        AND pp_key4 = a_newref_pp_key4
        AND pp_key5 = a_newref_pp_key5
      UNION
       SELECT pp, pr, pr_version
       FROM utppspa
       WHERE pp = a_old_pp
         AND version = a_old_pp_version
         AND pp_key1 = a_old_pp_key1
         AND pp_key2 = a_old_pp_key2
         AND pp_key3 = a_old_pp_key3
         AND pp_key4 = a_old_pp_key4
         AND pp_key5 = a_old_pp_key5)
      ORDER BY a.seq;

CURSOR l_utppspa_cursor (c_pp IN VARCHAR2,
                        c_pp_version IN VARCHAR2,
                        c_pp_key1    IN VARCHAR2,
                        c_pp_key2    IN VARCHAR2,
                        c_pp_key3    IN VARCHAR2,
                        c_pp_key4    IN VARCHAR2,
                        c_pp_key5    IN VARCHAR2,
                        c_pr         IN VARCHAR2,
                        c_pr_version IN VARCHAR2,
                        c_seq        IN NUMBER) IS
SELECT a.*
FROM utppspa a
WHERE (a.pp, a.version, a.pr, a.pr_version, a.seq) IN
(SELECT k.pp, k.version, k.pr, k.pr_version, k.seq
 FROM
    (SELECT ROWNUM relpos, b.pp, b.version, b.pr, b.pr_version, b.seq
    FROM
       (SELECT c.pp, c.version, c.pr, c.pr_version, c.seq
       FROM utppspa d, utpppr c
       WHERE c.pp = a_newref_pp
       AND c.version = a_newref_pp_version
       AND c.pp_key1 = a_newref_pp_key1
       AND c.pp_key2 = a_newref_pp_key2
       AND c.pp_key3 = a_newref_pp_key3
       AND c.pp_key4 = a_newref_pp_key4
       AND c.pp_key5 = a_newref_pp_key5
       AND c.pr = c_pr
       AND c.pr_version = c_pr_version
       AND d.pp (+) = c.pp
       AND d.version (+) = c.version
       AND d.pp_key1 (+) = c.pp_key1
       AND d.pp_key2 (+) = c.pp_key2
       AND d.pp_key3 (+) = c.pp_key3
       AND d.pp_key4 (+) = c.pp_key4
       AND d.pp_key5 (+) = c.pp_key5
       AND d.pr (+) = c.pr
       AND d.pr_version (+) = c.pr_version
       GROUP BY c.pp, c.version, c.pr, c.pr_version, c.seq) b) z,
    (SELECT ROWNUM relpos, b.pp, b.version, b.pr, b.pr_version, b.seq
    FROM
       (SELECT c.pp, c.version, c.pr, c.pr_version, c.seq
       FROM utppspa d, utpppr c
       WHERE c.pp = c_pp
       AND c.version = c_pp_version
       AND c.pp_key1 = c_pp_key1
       AND c.pp_key2 = c_pp_key2
       AND c.pp_key3 = c_pp_key3
       AND c.pp_key4 = c_pp_key4
       AND c.pp_key5 = c_pp_key5
       AND c.pr = c_pr
       AND c.pr_version = c_pr_version
       AND d.pp (+) = c.pp
       AND d.version (+) = c.version
       AND d.pp_key1 (+) = c.pp_key1
       AND d.pp_key2 (+) = c.pp_key2
       AND d.pp_key3 (+) = c.pp_key3
       AND d.pp_key4 (+) = c.pp_key4
       AND d.pp_key5 (+) = c.pp_key5
       AND d.pr (+) = c.pr
       AND d.pr_version (+) = c.pr_version
       GROUP BY c.pp, c.version, c.pr, c.pr_version, c.seq) b) k
    WHERE k.relpos = z.relpos
    AND z.seq = c_seq)
AND a.pp_key1 = c_pp_key1
AND a.pp_key2 = c_pp_key2
AND a.pp_key3 = c_pp_key3
AND a.pp_key4 = c_pp_key4
AND a.pp_key5 = c_pp_key5
ORDER BY a.seq;
l_oldref_utppspa_rec   utppspa%ROWTYPE;
l_newref_utppspa_rec   utppspa%ROWTYPE;
l_old_utppspa_rec      utppspa%ROWTYPE;
l_new_utppspa_rec      utppspa%ROWTYPE;

--utppspb cursors and variables
CURSOR l_ppspbls_cursor IS
   SELECT a.pp, a.version, a.pp_key1, a.pp_key2, a.pp_key3, a.pp_key4, a.pp_key5,
          a.pr, a.pr_version, a.seq, b.low_limit, b.high_limit, b.low_spec, b.high_spec,
          b.low_dev, b.rel_low_dev, b.target, b.high_dev, b.rel_high_dev
   FROM utpppr a, utppspb b
   WHERE a.pp = a_newref_pp
     AND a.version = a_newref_pp_version
     AND a.pp_key1 = a_newref_pp_key1
     AND a.pp_key2 = a_newref_pp_key2
     AND a.pp_key3 = a_newref_pp_key3
     AND a.pp_key4 = a_newref_pp_key4
     AND a.pp_key5 = a_newref_pp_key5
     AND b.pp(+) = a.pp
     AND b.version(+) = a.version
     AND b.pp_key1(+) = a.pp_key1
     AND b.pp_key2(+) = a.pp_key2
     AND b.pp_key3(+) = a.pp_key3
     AND b.pp_key4(+) = a.pp_key4
     AND b.pp_key5(+) = a.pp_key5
     AND b.pr(+) = a.pr
     AND b.pr_version(+) = a.pr_version
     AND (a.pp, a.pr, a.pr_version) IN
      (SELECT pp, pr, pr_version
      FROM utppspb
      WHERE pp = a_newref_pp
        AND version = a_newref_pp_version
        AND pp_key1 = a_newref_pp_key1
        AND pp_key2 = a_newref_pp_key2
        AND pp_key3 = a_newref_pp_key3
        AND pp_key4 = a_newref_pp_key4
        AND pp_key5 = a_newref_pp_key5
      UNION
       SELECT pp, pr, pr_version
       FROM utppspb
       WHERE pp = a_old_pp
         AND version = a_old_pp_version
         AND pp_key1 = a_old_pp_key1
         AND pp_key2 = a_old_pp_key2
         AND pp_key3 = a_old_pp_key3
         AND pp_key4 = a_old_pp_key4
         AND pp_key5 = a_old_pp_key5)
      ORDER BY a.seq;

CURSOR l_utppspb_cursor (c_pp IN VARCHAR2,
                        c_pp_version IN VARCHAR2,
                        c_pp_key1    IN VARCHAR2,
                        c_pp_key2    IN VARCHAR2,
                        c_pp_key3    IN VARCHAR2,
                        c_pp_key4    IN VARCHAR2,
                        c_pp_key5    IN VARCHAR2,
                        c_pr         IN VARCHAR2,
                        c_pr_version IN VARCHAR2,
                        c_seq        IN NUMBER) IS
SELECT a.*
FROM utppspb a
WHERE (a.pp, a.version, a.pr, a.pr_version, a.seq) IN
(SELECT k.pp, k.version, k.pr, k.pr_version, k.seq
 FROM
    (SELECT ROWNUM relpos, b.pp, b.version, b.pr, b.pr_version, b.seq
    FROM
       (SELECT c.pp, c.version, c.pr, c.pr_version, c.seq
       FROM utppspb d, utpppr c
       WHERE c.pp = a_newref_pp
       AND c.version = a_newref_pp_version
       AND c.pp_key1 = a_newref_pp_key1
       AND c.pp_key2 = a_newref_pp_key2
       AND c.pp_key3 = a_newref_pp_key3
       AND c.pp_key4 = a_newref_pp_key4
       AND c.pp_key5 = a_newref_pp_key5
       AND c.pr = c_pr
       AND c.pr_version = c_pr_version
       AND d.pp (+) = c.pp
       AND d.version (+) = c.version
       AND d.pp_key1 (+) = c.pp_key1
       AND d.pp_key2 (+) = c.pp_key2
       AND d.pp_key3 (+) = c.pp_key3
       AND d.pp_key4 (+) = c.pp_key4
       AND d.pp_key5 (+) = c.pp_key5
       AND d.pr (+) = c.pr
       AND d.pr_version (+) = c.pr_version
       GROUP BY c.pp, c.version, c.pr, c.pr_version, c.seq) b) z,
    (SELECT ROWNUM relpos, b.pp, b.version, b.pr, b.pr_version, b.seq
    FROM
       (SELECT c.pp, c.version, c.pr, c.pr_version, c.seq
       FROM utppspb d, utpppr c
       WHERE c.pp = c_pp
       AND c.version = c_pp_version
       AND c.pp_key1 = c_pp_key1
       AND c.pp_key2 = c_pp_key2
       AND c.pp_key3 = c_pp_key3
       AND c.pp_key4 = c_pp_key4
       AND c.pp_key5 = c_pp_key5
       AND c.pr = c_pr
       AND c.pr_version = c_pr_version
       AND d.pp (+) = c.pp
       AND d.version (+) = c.version
       AND d.pp_key1 (+) = c.pp_key1
       AND d.pp_key2 (+) = c.pp_key2
       AND d.pp_key3 (+) = c.pp_key3
       AND d.pp_key4 (+) = c.pp_key4
       AND d.pp_key5 (+) = c.pp_key5
       AND d.pr (+) = c.pr
       AND d.pr_version (+) = c.pr_version
       GROUP BY c.pp, c.version, c.pr, c.pr_version, c.seq) b) k
    WHERE k.relpos = z.relpos
    AND z.seq = c_seq)
AND a.pp_key1 = c_pp_key1
AND a.pp_key2 = c_pp_key2
AND a.pp_key3 = c_pp_key3
AND a.pp_key4 = c_pp_key4
AND a.pp_key5 = c_pp_key5
ORDER BY a.seq;
l_oldref_utppspb_rec   utppspb%ROWTYPE;
l_newref_utppspb_rec   utppspb%ROWTYPE;
l_old_utppspb_rec      utppspb%ROWTYPE;
l_new_utppspb_rec      utppspb%ROWTYPE;

--utppspc cursors and variables
CURSOR l_ppspcls_cursor IS
   SELECT a.pp, a.version, a.pp_key1, a.pp_key2, a.pp_key3, a.pp_key4, a.pp_key5,
          a.pr, a.pr_version, a.seq, b.low_limit, b.high_limit, b.low_spec, b.high_spec,
          b.low_dev, b.rel_low_dev, b.target, b.high_dev, b.rel_high_dev
   FROM utpppr a, utppspc b
   WHERE a.pp = a_newref_pp
     AND a.version = a_newref_pp_version
     AND a.pp_key1 = a_newref_pp_key1
     AND a.pp_key2 = a_newref_pp_key2
     AND a.pp_key3 = a_newref_pp_key3
     AND a.pp_key4 = a_newref_pp_key4
     AND a.pp_key5 = a_newref_pp_key5
     AND b.pp(+) = a.pp
     AND b.version(+) = a.version
     AND b.pp_key1(+) = a.pp_key1
     AND b.pp_key2(+) = a.pp_key2
     AND b.pp_key3(+) = a.pp_key3
     AND b.pp_key4(+) = a.pp_key4
     AND b.pp_key5(+) = a.pp_key5
     AND b.pr(+) = a.pr
     AND b.pr_version(+) = a.pr_version
     AND (a.pp, a.pr, a.pr_version) IN
      (SELECT pp, pr, pr_version
      FROM utppspc
      WHERE pp = a_newref_pp
        AND version = a_newref_pp_version
        AND pp_key1 = a_newref_pp_key1
        AND pp_key2 = a_newref_pp_key2
        AND pp_key3 = a_newref_pp_key3
        AND pp_key4 = a_newref_pp_key4
        AND pp_key5 = a_newref_pp_key5
      UNION
       SELECT pp, pr, pr_version
       FROM utppspc
       WHERE pp = a_old_pp
         AND version = a_old_pp_version
         AND pp_key1 = a_old_pp_key1
         AND pp_key2 = a_old_pp_key2
         AND pp_key3 = a_old_pp_key3
         AND pp_key4 = a_old_pp_key4
         AND pp_key5 = a_old_pp_key5)
      ORDER BY a.seq;

CURSOR l_utppspc_cursor (c_pp IN VARCHAR2,
                        c_pp_version IN VARCHAR2,
                        c_pp_key1    IN VARCHAR2,
                        c_pp_key2    IN VARCHAR2,
                        c_pp_key3    IN VARCHAR2,
                        c_pp_key4    IN VARCHAR2,
                        c_pp_key5    IN VARCHAR2,
                        c_pr         IN VARCHAR2,
                        c_pr_version IN VARCHAR2,
                        c_seq        IN NUMBER) IS
SELECT a.*
FROM utppspc a
WHERE (a.pp, a.version, a.pr, a.pr_version, a.seq) IN
(SELECT k.pp, k.version, k.pr, k.pr_version, k.seq
 FROM
    (SELECT ROWNUM relpos, b.pp, b.version, b.pr, b.pr_version, b.seq
    FROM
       (SELECT c.pp, c.version, c.pr, c.pr_version, c.seq
       FROM utppspc d, utpppr c
       WHERE c.pp = a_newref_pp
       AND c.version = a_newref_pp_version
       AND c.pp_key1 = a_newref_pp_key1
       AND c.pp_key2 = a_newref_pp_key2
       AND c.pp_key3 = a_newref_pp_key3
       AND c.pp_key4 = a_newref_pp_key4
       AND c.pp_key5 = a_newref_pp_key5
       AND c.pr = c_pr
       AND c.pr_version = c_pr_version
       AND d.pp (+) = c.pp
       AND d.version (+) = c.version
       AND d.pp_key1 (+) = c.pp_key1
       AND d.pp_key2 (+) = c.pp_key2
       AND d.pp_key3 (+) = c.pp_key3
       AND d.pp_key4 (+) = c.pp_key4
       AND d.pp_key5 (+) = c.pp_key5
       AND d.pr (+) = c.pr
       AND d.pr_version (+) = c.pr_version
       GROUP BY c.pp, c.version, c.pr, c.pr_version, c.seq) b) z,
    (SELECT ROWNUM relpos, b.pp, b.version, b.pr, b.pr_version, b.seq
    FROM
       (SELECT c.pp, c.version, c.pr, c.pr_version, c.seq
       FROM utppspc d, utpppr c
       WHERE c.pp = c_pp
       AND c.version = c_pp_version
       AND c.pp_key1 = c_pp_key1
       AND c.pp_key2 = c_pp_key2
       AND c.pp_key3 = c_pp_key3
       AND c.pp_key4 = c_pp_key4
       AND c.pp_key5 = c_pp_key5
       AND c.pr = c_pr
       AND c.pr_version = c_pr_version
       AND d.pp (+) = c.pp
       AND d.version (+) = c.version
       AND d.pp_key1 (+) = c.pp_key1
       AND d.pp_key2 (+) = c.pp_key2
       AND d.pp_key3 (+) = c.pp_key3
       AND d.pp_key4 (+) = c.pp_key4
       AND d.pp_key5 (+) = c.pp_key5
       AND d.pr (+) = c.pr
       AND d.pr_version (+) = c.pr_version
       GROUP BY c.pp, c.version, c.pr, c.pr_version, c.seq) b) k
    WHERE k.relpos = z.relpos
    AND z.seq = c_seq)
AND a.pp_key1 = c_pp_key1
AND a.pp_key2 = c_pp_key2
AND a.pp_key3 = c_pp_key3
AND a.pp_key4 = c_pp_key4
AND a.pp_key5 = c_pp_key5
ORDER BY a.seq;


CURSOR l_old_pppr_cursor IS
    SELECT * FROM utpppr
    WHERE pp = a_old_pp
      AND version = a_old_pp_version
      AND pp_key1 = a_old_pp_key1
      AND pp_key2 = a_old_pp_key2
      AND pp_key3 = a_old_pp_key3
      AND pp_key4 = a_old_pp_key4
      AND pp_key5 = a_old_pp_key5
      AND (pp, pr, pr_version) NOT IN
      (SELECT pp, pr, pr_version
        FROM utpppr
        WHERE pp = a_newref_pp
            AND version = a_newref_pp_version
            AND pp_key1 = a_newref_pp_key1
            AND pp_key2 = a_newref_pp_key2
            AND pp_key3 = a_newref_pp_key3
            AND pp_key4 = a_newref_pp_key4
            AND pp_key5 = a_newref_pp_key5
       UNION
       SELECT pp, pr, pr_version
        FROM utpppr
        WHERE pp = a_oldref_pp
        AND version = a_oldref_pp_version
        AND pp_key1 = a_oldref_pp_key1
        AND pp_key2 = a_oldref_pp_key2
        AND pp_key3 = a_oldref_pp_key3
        AND pp_key4 = a_oldref_pp_key4
        AND pp_key5 = a_oldref_pp_key5);

CURSOR l_old_spa_cursor (c_pr         IN VARCHAR2,
                         c_pr_version IN VARCHAR2,
                         c_seq        IN NUMBER) IS
    SELECT *
        FROM utppspa
    WHERE pp = a_old_pp
        AND version = a_old_pp_version
        AND pp_key1 = a_old_pp_key1
        AND pp_key2 = a_old_pp_key2
        AND pp_key3 = a_old_pp_key3
        AND pp_key4 = a_old_pp_key4
        AND pp_key5 = a_old_pp_key5
        AND pr= c_pr
        AND pr_version = c_pr_version
        AND seq = c_seq;

CURSOR l_old_spb_cursor (c_pr         IN VARCHAR2,
                         c_pr_version IN VARCHAR2,
                         c_seq        IN NUMBER) IS
    SELECT *
        FROM utppspb
    WHERE pp = a_old_pp
        AND version = a_old_pp_version
        AND pp_key1 = a_old_pp_key1
        AND pp_key2 = a_old_pp_key2
        AND pp_key3 = a_old_pp_key3
        AND pp_key4 = a_old_pp_key4
        AND pp_key5 = a_old_pp_key5
        AND pr= c_pr
        AND pr_version = c_pr_version
        AND seq = c_seq;

CURSOR l_old_spc_cursor (c_pr         IN VARCHAR2,
                         c_pr_version IN VARCHAR2,
                         c_seq        IN NUMBER) IS
    SELECT *
        FROM utppspc
    WHERE pp = a_old_pp
        AND version = a_old_pp_version
        AND pp_key1 = a_old_pp_key1
        AND pp_key2 = a_old_pp_key2
        AND pp_key3 = a_old_pp_key3
        AND pp_key4 = a_old_pp_key4
        AND pp_key5 = a_old_pp_key5
        AND pr= c_pr
        AND pr_version = c_pr_version
        AND seq = c_seq;

CURSOR l_new_ppprseq IS
    SELECT NVL(MAX(seq), 0) +1
    FROM utpppr
    WHERE pp = a_new_pp
        AND version = a_new_pp_version
        AND pp_key1 = a_new_pp_key1
        AND pp_key2 = a_new_pp_key2
        AND pp_key3 = a_new_pp_key3
        AND pp_key4 = a_new_pp_key4
        AND pp_key5 = a_new_pp_key5;

CURSOR l_reorder_follow_old_cursor (c_max_seq IN NUMBER) IS
SELECT pr, seq, '1' from_old
FROM utpppr
WHERE pp = a_old_pp
  AND version = a_old_pp_version
  AND pp_key1 = a_old_pp_key1
  AND pp_key2 = a_old_pp_key2
  AND pp_key3 = a_old_pp_key3
  AND pp_key4 = a_old_pp_key4
  AND pp_key5 = a_old_pp_key5
UNION ALL --(ALL is important for duplos)
SELECT zzz.pr, NVL(before_seq_in_old-0.5 , NVL(after_seq_in_old+0.5, c_max_seq+seq)) seq, '2' from_old
FROM
(
SELECT DISTINCT x.pr, x.seq,
FIRST_VALUE(z.seq_in_old) OVER
   (PARTITION BY x.pr, x.seq ORDER BY  x.seq ASC, z.seq_in_newref ASC nulls last ) before_seq_in_old,
--FIRST_VALUE(z.seq_in_newref) OVER
--   (PARTITION BY x.pr, x.seq ORDER BY  x.seq ASC, z.seq_in_newref ASC nulls last ) before_seq_in_newref,
--FIRST_VALUE(z.pr) OVER
--   (PARTITION BY x.pr, x.seq ORDER BY  x.seq ASC, z.seq_in_newref ASC nulls last ) before_pr,
FIRST_VALUE(y.seq_in_old) OVER
   (PARTITION BY x.pr, x.seq ORDER BY  x.seq ASC, y.seq_in_newref DESC nulls last ) after_seq_in_old --,
--FIRST_VALUE(y.seq_in_newref) OVER
--   (PARTITION BY x.pr, x.seq ORDER BY  x.seq ASC, y.seq_in_newref DESC nulls last ) after_seq_in_newref,
--FIRST_VALUE(y.pr) OVER
--   (PARTITION BY x.pr, x.seq ORDER BY  x.seq ASC, y.seq_in_newref DESC nulls last ) after_pr
FROM
    (--list of pr, seq existing in old_pp and in newref_pp and their seq
     SELECT a.pr, MIN(a.seq) seq_in_old, MIN(b.seq) seq_in_newref
     FROM utpppr a, utpppr b
     WHERE a.pp = a_old_pp
       AND a.version = a_old_pp_version
       AND a.pp_key1 = a_old_pp_key1
       AND a.pp_key2 = a_old_pp_key2
       AND a.pp_key3 = a_old_pp_key3
       AND a.pp_key4 = a_old_pp_key4
       AND a.pp_key5 = a_old_pp_key5
       AND b.pp = a_newref_pp
       AND b.version = a_newref_pp_version
       AND b.pp_key1 = a_newref_pp_key1
       AND b.pp_key2 = a_newref_pp_key2
       AND b.pp_key3 = a_newref_pp_key3
       AND b.pp_key4 = a_newref_pp_key4
       AND b.pp_key5 = a_newref_pp_key5
       AND a.pr = b.pr
     GROUP BY a.pr) z,
    (--list of pr, seq existing in old_pp and in newref_pp and their seq
     SELECT a.pr, MIN(a.seq) seq_in_old, MIN(b.seq) seq_in_newref
     FROM utpppr a, utpppr b
     WHERE a.pp = a_old_pp
       AND a.version = a_old_pp_version
       AND a.pp_key1 = a_old_pp_key1
       AND a.pp_key2 = a_old_pp_key2
       AND a.pp_key3 = a_old_pp_key3
       AND a.pp_key4 = a_old_pp_key4
       AND a.pp_key5 = a_old_pp_key5
       AND b.pp = a_newref_pp
       AND b.version = a_newref_pp_version
       AND b.pp_key1 = a_newref_pp_key1
       AND b.pp_key2 = a_newref_pp_key2
       AND b.pp_key3 = a_newref_pp_key3
       AND b.pp_key4 = a_newref_pp_key4
       AND b.pp_key5 = a_newref_pp_key5
       AND a.pr = b.pr
     GROUP BY a.pr) y,
    utpppr x
 WHERE x.pp = a_newref_pp
   AND x.version = a_newref_pp_version
   AND x.pp_key1 = a_newref_pp_key1
   AND x.pp_key2 = a_newref_pp_key2
   AND x.pp_key3 = a_newref_pp_key3
   AND x.pp_key4 = a_newref_pp_key4
   AND x.pp_key5 = a_newref_pp_key5
   AND x.seq < z.seq_in_newref (+)
   AND x.seq > y.seq_in_newref (+)
   AND x.pr NOT IN (SELECT j.pr
                    FROM utpppr j
                    WHERE j.pp = a_newref_pp
                      AND j.version = a_newref_pp_version
                      AND j.pp_key1 = a_newref_pp_key1
                      AND j.pp_key2 = a_newref_pp_key2
                      AND j.pp_key3 = a_newref_pp_key3
                      AND j.pp_key4 = a_newref_pp_key4
                      AND j.pp_key5 = a_newref_pp_key5
                    INTERSECT
                    SELECT k.pr
                    FROM utpppr k
                    WHERE k.pp = a_old_pp
                      AND k.version = a_old_pp_version
                      AND k.pp_key1 = a_old_pp_key1
                      AND k.pp_key2 = a_old_pp_key2
                      AND k.pp_key3 = a_old_pp_key3
                      AND k.pp_key4 = a_old_pp_key4
                      AND k.pp_key5 = a_old_pp_key5)
 ORDER BY  x.seq, x.pr
) zzz
ORDER BY seq, from_old, pr;

CURSOR l_reorder_follow_newref_cursor (c_max_seq IN NUMBER) IS
SELECT pr, seq,
      '1' from_newref
FROM utpppr
WHERE pp = a_newref_pp
  AND version = a_newref_pp_version
  AND pp_key1 = a_newref_pp_key1
  AND pp_key2 = a_newref_pp_key2
  AND pp_key3 = a_newref_pp_key3
  AND pp_key4 = a_newref_pp_key4
  AND pp_key5 = a_newref_pp_key5
UNION ALL --(ALL is important for duplos)
SELECT zzz.pr, NVL(before_seq_in_newref-0.5 , NVL(after_seq_in_newref+0.5, c_max_seq+seq)) seq,
       '2' from_newref
FROM
(
SELECT DISTINCT x.pr, x.seq,
--FIRST_VALUE(z.seq_in_old) OVER
--   (PARTITION BY x.pr, x.seq ORDER BY  x.seq ASC, z.seq_in_newref ASC nulls last ) before_seq_in_old,
FIRST_VALUE(z.seq_in_newref) OVER
   (PARTITION BY x.pr, x.seq ORDER BY  x.seq ASC, z.seq_in_newref ASC nulls last ) before_seq_in_newref,
--FIRST_VALUE(z.pr) OVER
--   (PARTITION BY x.pr, x.seq ORDER BY  x.seq ASC, z.seq_in_newref ASC nulls last ) before_pr,
--FIRST_VALUE(y.seq_in_old) OVER
--   (PARTITION BY x.pr, x.seq ORDER BY  x.seq ASC, y.seq_in_newref DESC nulls last ) after_seq_in_old,
FIRST_VALUE(y.seq_in_newref) OVER
   (PARTITION BY x.pr, x.seq ORDER BY  x.seq ASC, y.seq_in_newref DESC nulls last ) after_seq_in_newref --,
--FIRST_VALUE(y.pr) OVER
--   (PARTITION BY x.pr, x.seq ORDER BY  x.seq ASC, y.seq_in_newref DESC nulls last ) after_pr
FROM
    (--list of pr, seq existing in old_pp and in newref_pp and theri seq
     SELECT a.pr, MIN(a.seq) seq_in_old, MIN(b.seq) seq_in_newref
     FROM utpppr a, utpppr b
     WHERE a.pp = a_old_pp
       AND a.version = a_old_pp_version
       AND a.pp_key1 = a_old_pp_key1
       AND a.pp_key2 = a_old_pp_key2
       AND a.pp_key3 = a_old_pp_key3
       AND a.pp_key4 = a_old_pp_key4
       AND a.pp_key5 = a_old_pp_key5
       AND b.pp = a_newref_pp
       AND b.version = a_newref_pp_version
       AND b.pp_key1 = a_newref_pp_key1
       AND b.pp_key2 = a_newref_pp_key2
       AND b.pp_key3 = a_newref_pp_key3
       AND b.pp_key4 = a_newref_pp_key4
       AND b.pp_key5 = a_newref_pp_key5
       AND a.pr = b.pr
     GROUP BY a.pr) z,
    (--list of pr, seq existing in old_pp and in newref_pp and theri seq
     SELECT a.pr, MIN(a.seq) seq_in_old, MIN(b.seq) seq_in_newref
     FROM utpppr a, utpppr b
     WHERE a.pp = a_old_pp
       AND a.version = a_old_pp_version
       AND a.pp_key1 = a_old_pp_key1
       AND a.pp_key2 = a_old_pp_key2
       AND a.pp_key3 = a_old_pp_key3
       AND a.pp_key4 = a_old_pp_key4
       AND a.pp_key5 = a_old_pp_key5
       AND b.pp = a_newref_pp
       AND b.version = a_newref_pp_version
       AND b.pp_key1 = a_newref_pp_key1
       AND b.pp_key2 = a_newref_pp_key2
       AND b.pp_key3 = a_newref_pp_key3
       AND b.pp_key4 = a_newref_pp_key4
       AND b.pp_key5 = a_newref_pp_key5
       AND a.pr = b.pr
     GROUP BY a.pr) y,
    utpppr x
 WHERE x.pp = a_old_pp
   AND x.version = a_old_pp_version
   AND x.pp_key1 = a_old_pp_key1
   AND x.pp_key2 = a_old_pp_key2
   AND x.pp_key3 = a_old_pp_key3
   AND x.pp_key4 = a_old_pp_key4
   AND x.pp_key5 = a_old_pp_key5
   AND x.seq < z.seq_in_old (+)
   AND x.seq > y.seq_in_old (+)
   AND x.pr NOT IN (SELECT j.pr
                    FROM utpppr j
                    WHERE j.pp = a_newref_pp
                      AND j.version = a_newref_pp_version
                      AND j.pp_key1 = a_newref_pp_key1
                      AND j.pp_key2 = a_newref_pp_key2
                      AND j.pp_key3 = a_newref_pp_key3
                      AND j.pp_key4 = a_newref_pp_key4
                      AND j.pp_key5 = a_newref_pp_key5
                    INTERSECT
                    SELECT k.pr
                    FROM utpppr k
                    WHERE k.pp = a_old_pp
                      AND k.version = a_old_pp_version
                      AND k.pp_key1 = a_old_pp_key1
                      AND k.pp_key2 = a_old_pp_key2
                      AND k.pp_key3 = a_old_pp_key3
                      AND k.pp_key4 = a_old_pp_key4
                      AND k.pp_key5 = a_old_pp_key5)
 ORDER BY  x.seq, x.pr
) zzz
ORDER BY seq, from_newref, pr;

CURSOR l_reorder_corr_ppprseq_cursor  IS
SELECT a.pr, a.seq, a.rowid
FROM utpppr a
WHERE a.pp = a_new_pp
  AND a.version = a_new_pp_version
  AND a.pp_key1 = a_new_pp_key1
  AND a.pp_key2 = a_new_pp_key2
  AND a.pp_key3 = a_new_pp_key3
  AND a.pp_key4 = a_new_pp_key4
  AND a.pp_key5 = a_new_pp_key5
  AND a.seq < 0
  ORDER BY a.seq
FOR UPDATE;

CURSOR l_order_nogaps_ppprseq_cursor IS
SELECT a.pr, a.seq
FROM utpppr a
WHERE a.pp = a_new_pp
  AND a.version = a_new_pp_version
  AND a.pp_key1 = a_new_pp_key1
  AND a.pp_key2 = a_new_pp_key2
  AND a.pp_key3 = a_new_pp_key3
  AND a.pp_key4 = a_new_pp_key4
  AND a.pp_key5 = a_new_pp_key5
  ORDER BY a.seq
FOR UPDATE;

l_oldref_utppspc_rec   utppspc%ROWTYPE;
l_newref_utppspc_rec   utppspc%ROWTYPE;
l_old_utppspc_rec      utppspc%ROWTYPE;
l_new_utppspc_rec      utppspc%ROWTYPE;

/*
RS20110303 : START OF CHANGE VREDESTEIN
uncomment to force a statuschange to @A
*/
   -- Local variables for 'InsertEvent' API
   l_api_name                    VARCHAR2(40);
   l_evmgr_name                  VARCHAR2(20);
   l_object_tp                   VARCHAR2(4);
   l_object_id                   VARCHAR2(20);
   l_object_lc                   VARCHAR2(2);
   l_object_lc_version           VARCHAR2(20);
   l_object_ss                   VARCHAR2(2);
   l_ev_tp                       VARCHAR2(60);
   l_ev_details                  VARCHAR2(255);
   l_seq_nr                      NUMBER;
/*
RS20110303 : END OF CHANGE VREDESTEIN
*/
BEGIN

   l_some_pr_appended_in_oldpp:=FALSE;
   l_sqlerrm := NULL;
   l_insteadofnull:= UNAPIGEN.Cx_RPAD('*',60,'*');
   IF UNAPIGEN.BeginTxn(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE StpError;
   END IF;
 /*
DBMS_OUTPUT.PUT_LINE('oldref: ' ||a_oldref_pp||' ; '||a_oldref_pp_version||' ; '||a_oldref_pp_key1||' ; '||a_oldref_pp_key2||' ; '||a_oldref_pp_key3||' ; '||a_oldref_pp_key4||' ; '||a_oldref_pp_key5);
DBMS_OUTPUT.PUT_LINE('newref: ' ||a_newref_pp||' ; '||a_newref_pp_version||' ; '||a_newref_pp_key1||' ; '||a_newref_pp_key2||' ; '||a_newref_pp_key3||' ; '||a_newref_pp_key4||' ; '||a_newref_pp_key5);
DBMS_OUTPUT.PUT_LINE('old: ' ||a_old_pp||' ; '||a_old_pp_version||' ; '||a_old_pp_key1||' ; '||a_old_pp_key2||' ; '||a_old_pp_key3||' ; '||a_old_pp_key4||' ; '||a_old_pp_key5);
DBMS_OUTPUT.PUT_LINE('new: ' ||a_new_pp||' ; '||a_new_pp_version||' ; '||a_new_pp_key1||' ; '||a_new_pp_key2||' ; '||a_new_pp_key3||' ; '||a_new_pp_key4||' ; '||a_new_pp_key5);
*/
   /*-------------------*/
   /* Compare utpp      */
   /*-------------------*/
   --fetch 3 utpp records
   OPEN l_utpp_cursor(a_oldref_pp, a_oldref_pp_version, a_oldref_pp_key1, a_oldref_pp_key2, a_oldref_pp_key3, a_oldref_pp_key4, a_oldref_pp_key5);
   FETCH l_utpp_cursor
   INTO l_oldref_utpp_rec;
   IF l_utpp_cursor%NOTFOUND THEN
      CLOSE l_utpp_cursor;
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      RAISE STpError;
   END IF;
   CLOSE l_utpp_cursor;

   OPEN l_utpp_cursor(a_newref_pp, a_newref_pp_version, a_newref_pp_key1, a_newref_pp_key2, a_newref_pp_key3, a_newref_pp_key4, a_newref_pp_key5);
   FETCH l_utpp_cursor
   INTO l_newref_utpp_rec;
   IF l_utpp_cursor%NOTFOUND THEN
      CLOSE l_utpp_cursor;
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      RAISE STpError;
   END IF;
   CLOSE l_utpp_cursor;

   OPEN l_utpp_cursor(a_old_pp, a_old_pp_version, a_old_pp_key1, a_old_pp_key2, a_old_pp_key3, a_old_pp_key4, a_old_pp_key5);
   FETCH l_utpp_cursor
   INTO l_old_utpp_rec;
   IF l_utpp_cursor%NOTFOUND THEN
      CLOSE l_utpp_cursor;
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      RAISE STpError;
   END IF;
   CLOSE l_utpp_cursor;

   OPEN l_utpp_cursor(a_new_pp, a_new_pp_version, a_new_pp_key1, a_new_pp_key2, a_new_pp_key3, a_new_pp_key4, a_new_pp_key5);
   FETCH l_utpp_cursor
   INTO l_new_utpp_rec;
   IF l_utpp_cursor%FOUND THEN
      CLOSE l_utpp_cursor;
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_ALREADYEXISTS;
      RAISE STpError;
   END IF;
   CLOSE l_utpp_cursor;

   --compare
   --columns not compared: pp, version, pp_key[1-5], ss, allow_modify, active, ar[1-128],
   --                      effective_from, version_is_current, effective_till
   l_new_utpp_rec := l_newref_utpp_rec;
   IF NVL((l_old_utpp_rec.description <> l_oldref_utpp_rec.description), TRUE) AND NOT(l_old_utpp_rec.description IS NULL AND l_oldref_utpp_rec.description IS NULL)  THEN
      l_new_utpp_rec.description := l_old_utpp_rec.description;
   END IF;
   IF NVL((l_old_utpp_rec.description2 <> l_oldref_utpp_rec.description2), TRUE) AND NOT(l_old_utpp_rec.description2 IS NULL AND l_oldref_utpp_rec.description2 IS NULL)  THEN
     l_new_utpp_rec.description2 := l_old_utpp_rec.description2;
   END IF;
   IF NVL((l_old_utpp_rec.unit <> l_oldref_utpp_rec.unit), TRUE) AND NOT(l_old_utpp_rec.unit IS NULL AND l_oldref_utpp_rec.unit IS NULL)  THEN
     l_new_utpp_rec.unit := l_old_utpp_rec.unit;
   END IF;
   IF NVL((l_old_utpp_rec.format <> l_oldref_utpp_rec.format), TRUE) AND NOT(l_old_utpp_rec.format IS NULL AND l_oldref_utpp_rec.format IS NULL)  THEN
     l_new_utpp_rec.format := l_old_utpp_rec.format;
   END IF;
   IF NVL((l_old_utpp_rec.confirm_assign <> l_oldref_utpp_rec.confirm_assign), TRUE) AND NOT(l_old_utpp_rec.confirm_assign IS NULL AND l_oldref_utpp_rec.confirm_assign IS NULL)  THEN
     l_new_utpp_rec.confirm_assign := l_old_utpp_rec.confirm_assign;
   END IF;
   IF NVL((l_old_utpp_rec.allow_any_pr <> l_oldref_utpp_rec.allow_any_pr), TRUE) AND NOT(l_old_utpp_rec.allow_any_pr IS NULL AND l_oldref_utpp_rec.allow_any_pr IS NULL)  THEN
     l_new_utpp_rec.allow_any_pr := l_old_utpp_rec.allow_any_pr;
   END IF;
   IF NVL((l_old_utpp_rec.never_create_methods <> l_oldref_utpp_rec.never_create_methods), TRUE) AND NOT(l_old_utpp_rec.never_create_methods IS NULL AND l_oldref_utpp_rec.never_create_methods IS NULL)  THEN
     l_new_utpp_rec.never_create_methods := l_old_utpp_rec.never_create_methods;
   END IF;
   IF NVL((l_old_utpp_rec.delay <> l_oldref_utpp_rec.delay), TRUE) AND NOT(l_old_utpp_rec.delay IS NULL AND l_oldref_utpp_rec.delay IS NULL)  THEN
     l_new_utpp_rec.delay := l_old_utpp_rec.delay;
   END IF;
   IF NVL((l_old_utpp_rec.delay_unit <> l_oldref_utpp_rec.delay_unit), TRUE) AND NOT(l_old_utpp_rec.delay_unit IS NULL AND l_oldref_utpp_rec.delay_unit IS NULL)  THEN
     l_new_utpp_rec.delay_unit := l_old_utpp_rec.delay_unit;
   END IF;
   IF NVL((l_old_utpp_rec.is_template <> l_oldref_utpp_rec.is_template), TRUE) AND NOT(l_old_utpp_rec.is_template IS NULL AND l_oldref_utpp_rec.is_template IS NULL)  THEN
     l_new_utpp_rec.is_template := l_old_utpp_rec.is_template;
   END IF;
   IF NVL((l_old_utpp_rec.sc_lc <> l_oldref_utpp_rec.sc_lc), TRUE) AND NOT(l_old_utpp_rec.sc_lc IS NULL AND l_oldref_utpp_rec.sc_lc IS NULL)  THEN
     l_new_utpp_rec.sc_lc := l_old_utpp_rec.sc_lc;
   END IF;
   IF NVL((l_old_utpp_rec.sc_lc_version <> l_oldref_utpp_rec.sc_lc_version), TRUE) AND NOT(l_old_utpp_rec.sc_lc_version IS NULL AND l_oldref_utpp_rec.sc_lc_version IS NULL)  THEN
     l_new_utpp_rec.sc_lc_version := l_old_utpp_rec.sc_lc_version;
   END IF;
   IF NVL((l_old_utpp_rec.inherit_au <> l_oldref_utpp_rec.inherit_au), TRUE) AND NOT(l_old_utpp_rec.inherit_au IS NULL AND l_oldref_utpp_rec.inherit_au IS NULL)  THEN
     l_new_utpp_rec.inherit_au := l_old_utpp_rec.inherit_au;
   END IF;
   IF NVL((l_old_utpp_rec.last_comment <> l_oldref_utpp_rec.last_comment), TRUE) AND NOT(l_old_utpp_rec.last_comment IS NULL AND l_oldref_utpp_rec.last_comment IS NULL)  THEN
     l_new_utpp_rec.last_comment := l_old_utpp_rec.last_comment;
   END IF;
   IF NVL((l_old_utpp_rec.pp_class <> l_oldref_utpp_rec.pp_class), TRUE) AND NOT(l_old_utpp_rec.pp_class IS NULL AND l_oldref_utpp_rec.pp_class IS NULL)  THEN
     l_new_utpp_rec.pp_class := l_old_utpp_rec.pp_class;
   END IF;
   IF NVL((l_old_utpp_rec.log_hs <> l_oldref_utpp_rec.log_hs), TRUE) AND NOT(l_old_utpp_rec.log_hs IS NULL AND l_oldref_utpp_rec.log_hs IS NULL)  THEN
     l_new_utpp_rec.log_hs := l_old_utpp_rec.log_hs;
   END IF;
   IF NVL((l_old_utpp_rec.log_hs_details <> l_oldref_utpp_rec.log_hs_details), TRUE) AND NOT(l_old_utpp_rec.log_hs_details IS NULL AND l_oldref_utpp_rec.log_hs_details IS NULL)  THEN
     l_new_utpp_rec.log_hs_details := l_old_utpp_rec.log_hs_details;
   END IF;
   IF NVL((l_old_utpp_rec.lc <> l_oldref_utpp_rec.lc), TRUE) AND NOT(l_old_utpp_rec.lc IS NULL AND l_oldref_utpp_rec.lc IS NULL)  THEN
     l_new_utpp_rec.lc := l_old_utpp_rec.lc;
   END IF;
   IF NVL((l_old_utpp_rec.lc_version <> l_oldref_utpp_rec.lc_version), TRUE) AND NOT(l_old_utpp_rec.lc_version IS NULL AND l_oldref_utpp_rec.lc_version IS NULL)  THEN
     l_new_utpp_rec.lc_version := l_old_utpp_rec.lc_version;
   END IF;

   --insert the record in utpp
   --special cases: version_is_current, effective_till

   l_ret_code := UNAPIPP.SaveParameterProfile
                   (a_new_pp,
                    a_new_pp_version,
                    a_new_pp_key1,
                    a_new_pp_key2,
                    a_new_pp_key3,
                    a_new_pp_key4,
                    a_new_pp_key5,
                    NULL,
                    l_new_utpp_rec.effective_from,
                    NULL,
                    l_new_utpp_rec.description,
                    l_new_utpp_rec.description2,
                    l_new_utpp_rec.unit,
                    l_new_utpp_rec.format,
                    l_new_utpp_rec.confirm_assign,
                    l_new_utpp_rec.allow_any_pr,
                    l_new_utpp_rec.never_create_methods,
                    l_new_utpp_rec.delay,
                    l_new_utpp_rec.delay_unit,
                    l_new_utpp_rec.is_template,
                    l_new_utpp_rec.sc_lc,
                    l_new_utpp_rec.sc_lc_version,
                    l_new_utpp_rec.inherit_au,
                    l_new_utpp_rec.pp_class,
                    l_new_utpp_rec.log_hs,
                    l_new_utpp_rec.lc,
                    l_new_utpp_rec.lc_version,
                    '');
   IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
      l_sqlerrm := 'SaveParameterProfile ret_code='||l_ret_code||'#pp='||a_new_pp
                   ||'#version='||a_new_pp_version||'#pp_key1='||a_new_pp_key1
                   ||'#pp_key2='||a_new_pp_key2 ||'#pp_key3='||a_new_pp_key3
                   ||'#pp_key4='||a_new_pp_key4 ||'#pp_key5='||a_new_pp_key5;
      RAISE StpError;
   END IF;

   /*-------------------*/
   /* Compare utppau    */
   /*-------------------*/
   --Build up the list of pr and compare properties
   l_seq := 0;
   FOR l_new_utppau_rec IN l_new_utppau_cursor LOOP

      --insert the records in utppau
      --special cases: au_version always NULL
      l_seq := l_seq+1;
      INSERT INTO utppau
      (pp, version, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5,
       au, au_version, auseq, value)
      VALUES
      (a_new_pp, a_new_pp_version, a_new_pp_key1, a_new_pp_key2, a_new_pp_key3, a_new_pp_key4, a_new_pp_key5,
       l_new_utppau_rec.au, NULL, l_seq, l_new_utppau_rec.value);
   END LOOP;

   /*-------------------*/
   /* Compare utpppr    */
   /*-------------------*/
   --Build up the list of pr and compare properties
   FOR l_newref_utpppr_rec IN l_ppprls_cursor LOOP

      --fetch the corresponding record in other pp with the same relative position
      l_oldref_utpppr_rec := NULL;
      OPEN l_utpppr_cursor(a_oldref_pp, a_oldref_pp_version, a_oldref_pp_key1, a_oldref_pp_key2,
                           a_oldref_pp_key3, a_oldref_pp_key4, a_oldref_pp_key5,
                           l_newref_utpppr_rec.pr, l_newref_utpppr_rec.pr_version, l_newref_utpppr_rec.seq);
      FETCH l_utpppr_cursor
      INTO l_oldref_utpppr_rec;
      CLOSE l_utpppr_cursor;

      l_old_utpppr_rec := NULL;
      OPEN l_utpppr_cursor(a_old_pp, a_old_pp_version, a_old_pp_key1, a_old_pp_key2,
                           a_old_pp_key3, a_old_pp_key4, a_old_pp_key5,
                           l_newref_utpppr_rec.pr, l_newref_utpppr_rec.pr_version, l_newref_utpppr_rec.seq);
      FETCH l_utpppr_cursor
      INTO l_old_utpppr_rec;
      CLOSE l_utpppr_cursor;

      --compare
      --columns not compared: pp, version, pp_key[1-5], pr, pr_version, seq
      --might be a special case in some project but not handled: last_sched, last_count, last_val
      l_new_utpppr_rec := l_newref_utpppr_rec;
      IF NVL((l_old_utpppr_rec.nr_measur <> l_oldref_utpppr_rec.nr_measur), TRUE) AND NOT(l_old_utpppr_rec.nr_measur IS NULL AND l_oldref_utpppr_rec.nr_measur IS NULL)  THEN
        l_new_utpppr_rec.nr_measur := l_old_utpppr_rec.nr_measur;
      END IF;
      IF NVL((l_old_utpppr_rec.unit <> l_oldref_utpppr_rec.unit), TRUE) AND NOT(l_old_utpppr_rec.unit IS NULL AND l_oldref_utpppr_rec.unit IS NULL)  THEN
        l_new_utpppr_rec.unit := l_old_utpppr_rec.unit;
      END IF;
      IF NVL((l_old_utpppr_rec.format <> l_oldref_utpppr_rec.format), TRUE) AND NOT(l_old_utpppr_rec.format IS NULL AND l_oldref_utpppr_rec.format IS NULL)  THEN
        l_new_utpppr_rec.format := l_old_utpppr_rec.format;
      END IF;
      IF NVL((l_old_utpppr_rec.delay <> l_oldref_utpppr_rec.delay), TRUE) AND NOT(l_old_utpppr_rec.delay IS NULL AND l_oldref_utpppr_rec.delay IS NULL)  THEN
        l_new_utpppr_rec.delay := l_old_utpppr_rec.delay;
      END IF;
      IF NVL((l_old_utpppr_rec.delay_unit <> l_oldref_utpppr_rec.delay_unit), TRUE) AND NOT(l_old_utpppr_rec.delay_unit IS NULL AND l_oldref_utpppr_rec.delay_unit IS NULL)  THEN
        l_new_utpppr_rec.delay_unit := l_old_utpppr_rec.delay_unit;
      END IF;
      IF NVL((l_old_utpppr_rec.allow_add <> l_oldref_utpppr_rec.allow_add), TRUE) AND NOT(l_old_utpppr_rec.allow_add IS NULL AND l_oldref_utpppr_rec.allow_add IS NULL)  THEN
        l_new_utpppr_rec.allow_add := l_old_utpppr_rec.allow_add;
      END IF;
      IF NVL((l_old_utpppr_rec.is_pp <> l_oldref_utpppr_rec.is_pp), TRUE) AND NOT(l_old_utpppr_rec.is_pp IS NULL AND l_oldref_utpppr_rec.is_pp IS NULL)  THEN
        l_new_utpppr_rec.is_pp := l_old_utpppr_rec.is_pp;
      END IF;
      IF NVL((l_old_utpppr_rec.freq_tp <> l_oldref_utpppr_rec.freq_tp), TRUE) AND NOT(l_old_utpppr_rec.freq_tp IS NULL AND l_oldref_utpppr_rec.freq_tp IS NULL)  THEN
        l_new_utpppr_rec.freq_tp := l_old_utpppr_rec.freq_tp;
      END IF;
      IF NVL((l_old_utpppr_rec.freq_val <> l_oldref_utpppr_rec.freq_val), TRUE) AND NOT(l_old_utpppr_rec.freq_val IS NULL AND l_oldref_utpppr_rec.freq_val IS NULL)  THEN
        l_new_utpppr_rec.freq_val := l_old_utpppr_rec.freq_val;
      END IF;
      IF NVL((l_old_utpppr_rec.freq_unit <> l_oldref_utpppr_rec.freq_unit), TRUE) AND NOT(l_old_utpppr_rec.freq_unit IS NULL AND l_oldref_utpppr_rec.freq_unit IS NULL)  THEN
        l_new_utpppr_rec.freq_unit := l_old_utpppr_rec.freq_unit;
      END IF;
      IF NVL((l_old_utpppr_rec.invert_freq <> l_oldref_utpppr_rec.invert_freq), TRUE) AND NOT(l_old_utpppr_rec.invert_freq IS NULL AND l_oldref_utpppr_rec.invert_freq IS NULL)  THEN
        l_new_utpppr_rec.invert_freq := l_old_utpppr_rec.invert_freq;
      END IF;
      IF NVL((l_old_utpppr_rec.st_based_freq <> l_oldref_utpppr_rec.st_based_freq), TRUE) AND NOT(l_old_utpppr_rec.st_based_freq IS NULL AND l_oldref_utpppr_rec.st_based_freq IS NULL)  THEN
        l_new_utpppr_rec.st_based_freq := l_old_utpppr_rec.st_based_freq;
      END IF;
      --IF NVL((l_old_utpppr_rec.last_sched <> l_oldref_utpppr_rec.last_sched), TRUE) AND NOT(l_old_utpppr_rec.last_sched IS NULL AND l_oldref_utpppr_rec.last_sched IS NULL)  THEN
      --  l_new_utpppr_rec.last_sched := l_old_utpppr_rec.last_sched;
      --END IF;
      l_new_utpppr_rec.last_sched := NULL;
      --IF NVL((l_old_utpppr_rec.last_cnt <> l_oldref_utpppr_rec.last_cnt), TRUE) AND NOT(l_old_utpppr_rec.last_cnt IS NULL AND l_oldref_utpppr_rec.last_cnt IS NULL)  THEN
      --  l_new_utpppr_rec.last_cnt := l_old_utpppr_rec.last_cnt;
      --END IF;
      l_new_utpppr_rec.last_cnt := 0;
      --IF NVL((l_old_utpppr_rec.last_val <> l_oldref_utpppr_rec.last_val), TRUE) AND NOT(l_old_utpppr_rec.last_val IS NULL AND l_oldref_utpppr_rec.last_val IS NULL)  THEN
      --  l_new_utpppr_rec.last_val := l_old_utpppr_rec.last_val;
      --END IF;
      l_new_utpppr_rec.last_val := NULL;
      IF NVL((l_old_utpppr_rec.inherit_au <> l_oldref_utpppr_rec.inherit_au), TRUE) AND NOT(l_old_utpppr_rec.inherit_au IS NULL AND l_oldref_utpppr_rec.inherit_au IS NULL)  THEN
        l_new_utpppr_rec.inherit_au := l_old_utpppr_rec.inherit_au;
      END IF;
      IF NVL((l_old_utpppr_rec.mt <> l_oldref_utpppr_rec.mt), TRUE) AND NOT(l_old_utpppr_rec.mt IS NULL AND l_oldref_utpppr_rec.mt IS NULL)  THEN
        l_new_utpppr_rec.mt := l_old_utpppr_rec.mt;
      END IF;
      IF NVL((l_old_utpppr_rec.mt_version <> l_oldref_utpppr_rec.mt_version), TRUE) AND NOT(l_old_utpppr_rec.mt_version IS NULL AND l_oldref_utpppr_rec.mt_version IS NULL)  THEN
        l_new_utpppr_rec.mt_version := l_old_utpppr_rec.mt_version;
      END IF;
      IF NVL((l_old_utpppr_rec.mt_nr_measur <> l_oldref_utpppr_rec.mt_nr_measur), TRUE) AND NOT(l_old_utpppr_rec.mt_nr_measur IS NULL AND l_oldref_utpppr_rec.mt_nr_measur IS NULL)  THEN
        l_new_utpppr_rec.mt_nr_measur := l_old_utpppr_rec.mt_nr_measur;
      END IF;

      --insert the record in utpppr
      INSERT INTO utpppr
      (pp, version, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5,
       pr, pr_version, seq,
       nr_measur, unit, format, delay, delay_unit,
       allow_add, is_pp, freq_tp, freq_val,
       freq_unit, invert_freq, st_based_freq,
       last_sched, last_sched_tz, last_cnt, last_val,
       inherit_au, mt, mt_version, mt_nr_measur)
      VALUES
      (a_new_pp, a_new_pp_version, a_new_pp_key1, a_new_pp_key2, a_new_pp_key3, a_new_pp_key4, a_new_pp_key5,
       l_new_utpppr_rec.pr, l_new_utpppr_rec.pr_version, l_new_utpppr_rec.seq,
       l_new_utpppr_rec.nr_measur, l_new_utpppr_rec.unit, l_new_utpppr_rec.format, l_new_utpppr_rec.delay, l_new_utpppr_rec.delay_unit,
       l_new_utpppr_rec.allow_add, l_new_utpppr_rec.is_pp, l_new_utpppr_rec.freq_tp, l_new_utpppr_rec.freq_val,
       l_new_utpppr_rec.freq_unit, l_new_utpppr_rec.invert_freq, l_new_utpppr_rec.st_based_freq,
       l_new_utpppr_rec.last_sched, l_new_utpppr_rec.last_sched, l_new_utpppr_rec.last_cnt, l_new_utpppr_rec.last_val,
       l_new_utpppr_rec.inherit_au, l_new_utpppr_rec.mt, l_new_utpppr_rec.mt_version, l_new_utpppr_rec.mt_nr_measur);

   END LOOP;

   /*---------------------*/
   /* Compare utppprau    */
   /*---------------------*/
   --Build up the list of pr and compare properties
   l_seq := 0;
   FOR l_new_utppprau_rec IN l_new_utppprau_cursor LOOP
      --insert the records in utppau
      --special cases: pr_version is the result of a MAX and au_version always NULL
      --reset auseq on new pr
      IF l_prev_pr <> l_new_utppprau_rec.pr THEN
         l_seq := 0;
      END IF;
      l_seq := l_seq+1;
      l_prev_pr := l_new_utppprau_rec.pr;
       --special cases: pr_version is the result of a MAX and au_version always NULL
      INSERT INTO utppprau
      (pp, version, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5,
       pr, pr_version, au, au_version, auseq, value)
      VALUES
      (a_new_pp, a_new_pp_version, a_new_pp_key1, a_new_pp_key2, a_new_pp_key3, a_new_pp_key4, a_new_pp_key5,
       l_new_utppprau_rec.pr, NULL, l_new_utppprau_rec.au, NULL, l_seq, l_new_utppprau_rec.value);
   END LOOP;

   /*-------------------*/
   /* Compare utppspa   */
   /*-------------------*/
   --Build up the list of pr and compare properties
   FOR l_newref_utppspa_rec IN l_ppspals_cursor LOOP

      --fetch the corresponding record in other pp with the same relative position
      l_oldref_utppspa_rec := NULL;
      OPEN l_utppspa_cursor(a_oldref_pp, a_oldref_pp_version, a_oldref_pp_key1, a_oldref_pp_key2,
                           a_oldref_pp_key3, a_oldref_pp_key4, a_oldref_pp_key5,
                           l_newref_utppspa_rec.pr, l_newref_utppspa_rec.pr_version, l_newref_utppspa_rec.seq);
      FETCH l_utppspa_cursor
      INTO l_oldref_utppspa_rec;
      CLOSE l_utppspa_cursor;

      l_old_utppspa_rec := NULL;
      OPEN l_utppspa_cursor(a_old_pp, a_old_pp_version, a_old_pp_key1, a_old_pp_key2,
                           a_old_pp_key3, a_old_pp_key4, a_old_pp_key5,
                           l_newref_utppspa_rec.pr, l_newref_utppspa_rec.pr_version, l_newref_utppspa_rec.seq);
      FETCH l_utppspa_cursor
      INTO l_old_utppspa_rec;
      CLOSE l_utppspa_cursor;

      --compare
      --columns not compared: pp, version, pp_key[1-5], pr, pr_version, seq
      l_new_utppspa_rec.pr := l_newref_utppspa_rec.pr;
      l_new_utppspa_rec.pr_version := l_newref_utppspa_rec.pr_version;
      l_new_utppspa_rec.seq := l_newref_utppspa_rec.seq;
      l_new_utppspa_rec.low_limit := l_newref_utppspa_rec.low_limit;
      l_new_utppspa_rec.high_limit := l_newref_utppspa_rec.high_limit;
      l_new_utppspa_rec.low_spec := l_newref_utppspa_rec.low_spec;
      l_new_utppspa_rec.high_spec := l_newref_utppspa_rec.high_spec;
      l_new_utppspa_rec.low_dev := l_newref_utppspa_rec.low_dev;
      l_new_utppspa_rec.rel_low_dev := l_newref_utppspa_rec.rel_low_dev;
      l_new_utppspa_rec.target := l_newref_utppspa_rec.target;
      l_new_utppspa_rec.high_dev := l_newref_utppspa_rec.high_dev;
      l_new_utppspa_rec.rel_high_dev := l_newref_utppspa_rec.rel_high_dev;
      IF NVL((l_old_utppspa_rec.low_limit <> l_oldref_utppspa_rec.low_limit), TRUE) AND NOT(l_old_utppspa_rec.low_limit IS NULL AND l_oldref_utppspa_rec.low_limit IS NULL)  THEN
        l_new_utppspa_rec.low_limit := l_old_utppspa_rec.low_limit;
      END IF;
      IF NVL((l_old_utppspa_rec.high_limit <> l_oldref_utppspa_rec.high_limit), TRUE) AND NOT(l_old_utppspa_rec.high_limit IS NULL AND l_oldref_utppspa_rec.high_limit IS NULL)  THEN
        l_new_utppspa_rec.high_limit := l_old_utppspa_rec.high_limit;
      END IF;
      IF NVL((l_old_utppspa_rec.low_spec <> l_oldref_utppspa_rec.low_spec), TRUE) AND NOT(l_old_utppspa_rec.low_spec IS NULL AND l_oldref_utppspa_rec.low_spec IS NULL)  THEN
        l_new_utppspa_rec.low_spec := l_old_utppspa_rec.low_spec;
      END IF;
      IF NVL((l_old_utppspa_rec.high_spec <> l_oldref_utppspa_rec.high_spec), TRUE) AND NOT(l_old_utppspa_rec.high_spec IS NULL AND l_oldref_utppspa_rec.high_spec IS NULL)  THEN
        l_new_utppspa_rec.high_spec := l_old_utppspa_rec.high_spec;
      END IF;
      IF NVL((l_old_utppspa_rec.low_dev <> l_oldref_utppspa_rec.low_dev), TRUE) AND NOT(l_old_utppspa_rec.low_dev IS NULL AND l_oldref_utppspa_rec.low_dev IS NULL)  THEN
        l_new_utppspa_rec.low_dev := l_old_utppspa_rec.low_dev;
      END IF;
      IF NVL((l_old_utppspa_rec.rel_low_dev <> l_oldref_utppspa_rec.rel_low_dev), TRUE) AND NOT(l_old_utppspa_rec.rel_low_dev IS NULL AND l_oldref_utppspa_rec.rel_low_dev IS NULL)  THEN
        l_new_utppspa_rec.rel_low_dev := l_old_utppspa_rec.rel_low_dev;
      END IF;
      IF NVL((l_old_utppspa_rec.target <> l_oldref_utppspa_rec.target), TRUE) AND NOT(l_old_utppspa_rec.target IS NULL AND l_oldref_utppspa_rec.target IS NULL)  THEN
        l_new_utppspa_rec.target := l_old_utppspa_rec.target;
      END IF;
      IF NVL((l_old_utppspa_rec.high_dev <> l_oldref_utppspa_rec.high_dev), TRUE) AND NOT(l_old_utppspa_rec.high_dev IS NULL AND l_oldref_utppspa_rec.high_dev IS NULL)  THEN
        l_new_utppspa_rec.high_dev := l_old_utppspa_rec.high_dev;
      END IF;
      IF NVL((l_old_utppspa_rec.rel_high_dev <> l_oldref_utppspa_rec.rel_high_dev), TRUE) AND NOT(l_old_utppspa_rec.rel_high_dev IS NULL AND l_oldref_utppspa_rec.rel_high_dev IS NULL)  THEN
        l_new_utppspa_rec.rel_high_dev := l_old_utppspa_rec.rel_high_dev;
      END IF;

      --insert the record in utppspa
      IF l_new_utppspa_rec.low_limit IS NOT NULL OR
         l_new_utppspa_rec.high_limit IS NOT NULL OR
         l_new_utppspa_rec.low_spec IS NOT NULL OR
         l_new_utppspa_rec.high_spec IS NOT NULL OR
         l_new_utppspa_rec.low_dev IS NOT NULL OR
         l_new_utppspa_rec.target IS NOT NULL OR
         l_new_utppspa_rec.high_dev IS NOT NULL THEN --containing a valid spec

--DBMS_OUTPUT.PUT_LINE ('inserting pr='||l_new_utppspa_rec.pr||'#seq='||l_new_utppspa_rec.seq);

         l_old_utppspa_rec.rel_low_dev := NVL(l_old_utppspa_rec.rel_low_dev, '0');
         l_old_utppspa_rec.rel_high_dev := NVL(l_old_utppspa_rec.rel_high_dev, '0');
         INSERT INTO utppspa
         (pp, version, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5,
          pr, pr_version, seq,
          low_limit, high_limit, low_spec, high_spec,
          low_dev, rel_low_dev, target, high_dev, rel_high_dev)
         VALUES
         (a_new_pp, a_new_pp_version, a_new_pp_key1, a_new_pp_key2, a_new_pp_key3, a_new_pp_key4, a_new_pp_key5,
          l_new_utppspa_rec.pr, l_new_utppspa_rec.pr_version, l_new_utppspa_rec.seq,
          l_new_utppspa_rec.low_limit, l_new_utppspa_rec.high_limit, l_new_utppspa_rec.low_spec, l_new_utppspa_rec.high_spec,
          l_new_utppspa_rec.low_dev, l_new_utppspa_rec.rel_low_dev, l_new_utppspa_rec.target, l_new_utppspa_rec.high_dev, l_new_utppspa_rec.rel_high_dev);
      END IF;
   END LOOP;

   /*-------------------*/
   /* Compare utppspb   */
   /*-------------------*/
   --Build up the list of pr and compare properties
   FOR l_newref_utppspb_rec IN l_ppspbls_cursor LOOP

      --fetch the corresponding record in other pp with the same relative position
      l_oldref_utppspb_rec := NULL;
      OPEN l_utppspb_cursor(a_oldref_pp, a_oldref_pp_version, a_oldref_pp_key1, a_oldref_pp_key2,
                           a_oldref_pp_key3, a_oldref_pp_key4, a_oldref_pp_key5,
                           l_newref_utppspb_rec.pr, l_newref_utppspb_rec.pr_version, l_newref_utppspb_rec.seq);
      FETCH l_utppspb_cursor
      INTO l_oldref_utppspb_rec;
      CLOSE l_utppspb_cursor;

      l_old_utppspb_rec := NULL;
      OPEN l_utppspb_cursor(a_old_pp, a_old_pp_version, a_old_pp_key1, a_old_pp_key2,
                           a_old_pp_key3, a_old_pp_key4, a_old_pp_key5,
                           l_newref_utppspb_rec.pr, l_newref_utppspb_rec.pr_version, l_newref_utppspb_rec.seq);
      FETCH l_utppspb_cursor
      INTO l_old_utppspb_rec;
      CLOSE l_utppspb_cursor;

      --compare
      --columns not compared: pp, version, pp_key[1-5], pr, pr_version, seq
      l_new_utppspb_rec.pr := l_newref_utppspb_rec.pr;
      l_new_utppspb_rec.pr_version := l_newref_utppspb_rec.pr_version;
      l_new_utppspb_rec.seq := l_newref_utppspb_rec.seq;
      l_new_utppspb_rec.low_limit := l_newref_utppspb_rec.low_limit;
      l_new_utppspb_rec.high_limit := l_newref_utppspb_rec.high_limit;
      l_new_utppspb_rec.low_spec := l_newref_utppspb_rec.low_spec;
      l_new_utppspb_rec.high_spec := l_newref_utppspb_rec.high_spec;
      l_new_utppspb_rec.low_dev := l_newref_utppspb_rec.low_dev;
      l_new_utppspb_rec.rel_low_dev := l_newref_utppspb_rec.rel_low_dev;
      l_new_utppspb_rec.target := l_newref_utppspb_rec.target;
      l_new_utppspb_rec.high_dev := l_newref_utppspb_rec.high_dev;
      l_new_utppspb_rec.rel_high_dev := l_newref_utppspb_rec.rel_high_dev;
      IF NVL((l_old_utppspb_rec.low_limit <> l_oldref_utppspb_rec.low_limit), TRUE) AND NOT(l_old_utppspb_rec.low_limit IS NULL AND l_oldref_utppspb_rec.low_limit IS NULL)  THEN
        l_new_utppspb_rec.low_limit := l_old_utppspb_rec.low_limit;
      END IF;
      IF NVL((l_old_utppspb_rec.high_limit <> l_oldref_utppspb_rec.high_limit), TRUE) AND NOT(l_old_utppspb_rec.high_limit IS NULL AND l_oldref_utppspb_rec.high_limit IS NULL)  THEN
        l_new_utppspb_rec.high_limit := l_old_utppspb_rec.high_limit;
      END IF;
      IF NVL((l_old_utppspb_rec.low_spec <> l_oldref_utppspb_rec.low_spec), TRUE) AND NOT(l_old_utppspb_rec.low_spec IS NULL AND l_oldref_utppspb_rec.low_spec IS NULL)  THEN
        l_new_utppspb_rec.low_spec := l_old_utppspb_rec.low_spec;
      END IF;
      IF NVL((l_old_utppspb_rec.high_spec <> l_oldref_utppspb_rec.high_spec), TRUE) AND NOT(l_old_utppspb_rec.high_spec IS NULL AND l_oldref_utppspb_rec.high_spec IS NULL)  THEN
        l_new_utppspb_rec.high_spec := l_old_utppspb_rec.high_spec;
      END IF;
      IF NVL((l_old_utppspb_rec.low_dev <> l_oldref_utppspb_rec.low_dev), TRUE) AND NOT(l_old_utppspb_rec.low_dev IS NULL AND l_oldref_utppspb_rec.low_dev IS NULL)  THEN
        l_new_utppspb_rec.low_dev := l_old_utppspb_rec.low_dev;
      END IF;
      IF NVL((l_old_utppspb_rec.rel_low_dev <> l_oldref_utppspb_rec.rel_low_dev), TRUE) AND NOT(l_old_utppspb_rec.rel_low_dev IS NULL AND l_oldref_utppspb_rec.rel_low_dev IS NULL)  THEN
        l_new_utppspb_rec.rel_low_dev := l_old_utppspb_rec.rel_low_dev;
      END IF;
      IF NVL((l_old_utppspb_rec.target <> l_oldref_utppspb_rec.target), TRUE) AND NOT(l_old_utppspb_rec.target IS NULL AND l_oldref_utppspb_rec.target IS NULL)  THEN
        l_new_utppspb_rec.target := l_old_utppspb_rec.target;
      END IF;
      IF NVL((l_old_utppspb_rec.high_dev <> l_oldref_utppspb_rec.high_dev), TRUE) AND NOT(l_old_utppspb_rec.high_dev IS NULL AND l_oldref_utppspb_rec.high_dev IS NULL)  THEN
        l_new_utppspb_rec.high_dev := l_old_utppspb_rec.high_dev;
      END IF;
      IF NVL((l_old_utppspb_rec.rel_high_dev <> l_oldref_utppspb_rec.rel_high_dev), TRUE) AND NOT(l_old_utppspb_rec.rel_high_dev IS NULL AND l_oldref_utppspb_rec.rel_high_dev IS NULL)  THEN
        l_new_utppspb_rec.rel_high_dev := l_old_utppspb_rec.rel_high_dev;
      END IF;

      --insert the record in utppspb
      IF l_new_utppspb_rec.low_limit IS NOT NULL OR
         l_new_utppspb_rec.high_limit IS NOT NULL OR
         l_new_utppspb_rec.low_spec IS NOT NULL OR
         l_new_utppspb_rec.high_spec IS NOT NULL OR
         l_new_utppspb_rec.low_dev IS NOT NULL OR
         l_new_utppspb_rec.target IS NOT NULL OR
         l_new_utppspb_rec.high_dev IS NOT NULL THEN --containing a valid spec

         l_old_utppspb_rec.rel_low_dev := NVL(l_old_utppspb_rec.rel_low_dev, '0');
         l_old_utppspb_rec.rel_high_dev := NVL(l_old_utppspb_rec.rel_high_dev, '0');
         INSERT INTO utppspb
         (pp, version, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5,
          pr, pr_version, seq,
          low_limit, high_limit, low_spec, high_spec,
          low_dev, rel_low_dev, target, high_dev, rel_high_dev)
         VALUES
         (a_new_pp, a_new_pp_version, a_new_pp_key1, a_new_pp_key2, a_new_pp_key3, a_new_pp_key4, a_new_pp_key5,
          l_new_utppspb_rec.pr, l_new_utppspb_rec.pr_version, l_new_utppspb_rec.seq,
          l_new_utppspb_rec.low_limit, l_new_utppspb_rec.high_limit, l_new_utppspb_rec.low_spec, l_new_utppspb_rec.high_spec,
          l_new_utppspb_rec.low_dev, l_new_utppspb_rec.rel_low_dev, l_new_utppspb_rec.target, l_new_utppspb_rec.high_dev, l_new_utppspb_rec.rel_high_dev);
      END IF;
   END LOOP;

   /*-------------------*/
   /* Compare utppspc   */
   /*-------------------*/
   --Build up the list of pr and compare properties
   FOR l_newref_utppspc_rec IN l_ppspcls_cursor LOOP

      --fetch the corresponding record in other pp with the same relative position
      l_oldref_utppspc_rec := NULL;
      OPEN l_utppspc_cursor(a_oldref_pp, a_oldref_pp_version, a_oldref_pp_key1, a_oldref_pp_key2,
                           a_oldref_pp_key3, a_oldref_pp_key4, a_oldref_pp_key5,
                           l_newref_utppspc_rec.pr, l_newref_utppspc_rec.pr_version, l_newref_utppspc_rec.seq);
      FETCH l_utppspc_cursor
      INTO l_oldref_utppspc_rec;
      CLOSE l_utppspc_cursor;

      l_old_utppspc_rec := NULL;
      OPEN l_utppspc_cursor(a_old_pp, a_old_pp_version, a_old_pp_key1, a_old_pp_key2,
                           a_old_pp_key3, a_old_pp_key4, a_old_pp_key5,
                           l_newref_utppspc_rec.pr, l_newref_utppspc_rec.pr_version, l_newref_utppspc_rec.seq);
      FETCH l_utppspc_cursor
      INTO l_old_utppspc_rec;
      CLOSE l_utppspc_cursor;

      --compare
      --columns not compared: pp, version, pp_key[1-5], pr, pr_version, seq
      l_new_utppspc_rec.pr := l_newref_utppspc_rec.pr;
      l_new_utppspc_rec.pr_version := l_newref_utppspc_rec.pr_version;
      l_new_utppspc_rec.seq := l_newref_utppspc_rec.seq;
      l_new_utppspc_rec.low_limit := l_newref_utppspc_rec.low_limit;
      l_new_utppspc_rec.high_limit := l_newref_utppspc_rec.high_limit;
      l_new_utppspc_rec.low_spec := l_newref_utppspc_rec.low_spec;
      l_new_utppspc_rec.high_spec := l_newref_utppspc_rec.high_spec;
      l_new_utppspc_rec.low_dev := l_newref_utppspc_rec.low_dev;
      l_new_utppspc_rec.rel_low_dev := l_newref_utppspc_rec.rel_low_dev;
      l_new_utppspc_rec.target := l_newref_utppspc_rec.target;
      l_new_utppspc_rec.high_dev := l_newref_utppspc_rec.high_dev;
      l_new_utppspc_rec.rel_high_dev := l_newref_utppspc_rec.rel_high_dev;
      IF NVL((l_old_utppspc_rec.low_limit <> l_oldref_utppspc_rec.low_limit), TRUE) AND NOT(l_old_utppspc_rec.low_limit IS NULL AND l_oldref_utppspc_rec.low_limit IS NULL)  THEN
        l_new_utppspc_rec.low_limit := l_old_utppspc_rec.low_limit;
      END IF;
      IF NVL((l_old_utppspc_rec.high_limit <> l_oldref_utppspc_rec.high_limit), TRUE) AND NOT(l_old_utppspc_rec.high_limit IS NULL AND l_oldref_utppspc_rec.high_limit IS NULL)  THEN
        l_new_utppspc_rec.high_limit := l_old_utppspc_rec.high_limit;
      END IF;
      IF NVL((l_old_utppspc_rec.low_spec <> l_oldref_utppspc_rec.low_spec), TRUE) AND NOT(l_old_utppspc_rec.low_spec IS NULL AND l_oldref_utppspc_rec.low_spec IS NULL)  THEN
        l_new_utppspc_rec.low_spec := l_old_utppspc_rec.low_spec;
      END IF;
      IF NVL((l_old_utppspc_rec.high_spec <> l_oldref_utppspc_rec.high_spec), TRUE) AND NOT(l_old_utppspc_rec.high_spec IS NULL AND l_oldref_utppspc_rec.high_spec IS NULL)  THEN
        l_new_utppspc_rec.high_spec := l_old_utppspc_rec.high_spec;
      END IF;
      IF NVL((l_old_utppspc_rec.low_dev <> l_oldref_utppspc_rec.low_dev), TRUE) AND NOT(l_old_utppspc_rec.low_dev IS NULL AND l_oldref_utppspc_rec.low_dev IS NULL)  THEN
        l_new_utppspc_rec.low_dev := l_old_utppspc_rec.low_dev;
      END IF;
      IF NVL((l_old_utppspc_rec.rel_low_dev <> l_oldref_utppspc_rec.rel_low_dev), TRUE) AND NOT(l_old_utppspc_rec.rel_low_dev IS NULL AND l_oldref_utppspc_rec.rel_low_dev IS NULL)  THEN
        l_new_utppspc_rec.rel_low_dev := l_old_utppspc_rec.rel_low_dev;
      END IF;
      IF NVL((l_old_utppspc_rec.target <> l_oldref_utppspc_rec.target), TRUE) AND NOT(l_old_utppspc_rec.target IS NULL AND l_oldref_utppspc_rec.target IS NULL)  THEN
        l_new_utppspc_rec.target := l_old_utppspc_rec.target;
      END IF;
      IF NVL((l_old_utppspc_rec.high_dev <> l_oldref_utppspc_rec.high_dev), TRUE) AND NOT(l_old_utppspc_rec.high_dev IS NULL AND l_oldref_utppspc_rec.high_dev IS NULL)  THEN
        l_new_utppspc_rec.high_dev := l_old_utppspc_rec.high_dev;
      END IF;
      IF NVL((l_old_utppspc_rec.rel_high_dev <> l_oldref_utppspc_rec.rel_high_dev), TRUE) AND NOT(l_old_utppspc_rec.rel_high_dev IS NULL AND l_oldref_utppspc_rec.rel_high_dev IS NULL)  THEN
        l_new_utppspc_rec.rel_high_dev := l_old_utppspc_rec.rel_high_dev;
      END IF;

      --insert the record in utppspc
      IF l_new_utppspc_rec.low_limit IS NOT NULL OR
         l_new_utppspc_rec.high_limit IS NOT NULL OR
         l_new_utppspc_rec.low_spec IS NOT NULL OR
         l_new_utppspc_rec.high_spec IS NOT NULL OR
         l_new_utppspc_rec.low_dev IS NOT NULL OR
         l_new_utppspc_rec.target IS NOT NULL OR
         l_new_utppspc_rec.high_dev IS NOT NULL THEN --containing a valid spec

         l_old_utppspc_rec.rel_low_dev := NVL(l_old_utppspc_rec.rel_low_dev, '0');
         l_old_utppspc_rec.rel_high_dev := NVL(l_old_utppspc_rec.rel_high_dev, '0');
         INSERT INTO utppspc
         (pp, version, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5,
          pr, pr_version, seq,
          low_limit, high_limit, low_spec, high_spec,
          low_dev, rel_low_dev, target, high_dev, rel_high_dev)
         VALUES
         (a_new_pp, a_new_pp_version, a_new_pp_key1, a_new_pp_key2, a_new_pp_key3, a_new_pp_key4, a_new_pp_key5,
          l_new_utppspc_rec.pr, l_new_utppspc_rec.pr_version, l_new_utppspc_rec.seq,
          l_new_utppspc_rec.low_limit, l_new_utppspc_rec.high_limit, l_new_utppspc_rec.low_spec, l_new_utppspc_rec.high_spec,
          l_new_utppspc_rec.low_dev, l_new_utppspc_rec.rel_low_dev, l_new_utppspc_rec.target, l_new_utppspc_rec.high_dev, l_new_utppspc_rec.rel_high_dev);
      END IF;
   END LOOP;

   --insert the pr's that were added in the old pp and that are not present in the ref pp's
   FOR l_new_utpppr_rec IN l_old_pppr_cursor LOOP
      l_some_pr_appended_in_oldpp:=TRUE;
      OPEN l_new_ppprseq;
      FETCH l_new_ppprseq INTO l_seq;
      CLOSE l_new_ppprseq;
      --insert the record in utpppr
      l_new_utpppr_rec.last_sched := NULL;
      l_new_utpppr_rec.last_cnt := 0;
      l_new_utpppr_rec.last_val := NULL;
      INSERT INTO utpppr
      (pp, version, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5,
       pr, pr_version, seq,
       nr_measur, unit, format, delay, delay_unit,
       allow_add, is_pp, freq_tp, freq_val,
       freq_unit, invert_freq, st_based_freq,
       last_sched, last_sched_tz, last_cnt, last_val,
       inherit_au, mt, mt_version, mt_nr_measur)
      VALUES
      (a_new_pp, a_new_pp_version, a_new_pp_key1, a_new_pp_key2, a_new_pp_key3, a_new_pp_key4, a_new_pp_key5,
       l_new_utpppr_rec.pr, l_new_utpppr_rec.pr_version, l_seq,
       l_new_utpppr_rec.nr_measur, l_new_utpppr_rec.unit, l_new_utpppr_rec.format, l_new_utpppr_rec.delay, l_new_utpppr_rec.delay_unit,
       l_new_utpppr_rec.allow_add, l_new_utpppr_rec.is_pp, l_new_utpppr_rec.freq_tp, l_new_utpppr_rec.freq_val,
       l_new_utpppr_rec.freq_unit, l_new_utpppr_rec.invert_freq, l_new_utpppr_rec.st_based_freq,
       l_new_utpppr_rec.last_sched, l_new_utpppr_rec.last_sched, l_new_utpppr_rec.last_cnt, l_new_utpppr_rec.last_val,
       l_new_utpppr_rec.inherit_au, l_new_utpppr_rec.mt, l_new_utpppr_rec.mt_version, l_new_utpppr_rec.mt_nr_measur);
         FOR l_new_utppspa_rec IN l_old_spa_cursor(l_new_utpppr_rec.pr, l_new_utpppr_rec.pr_version, l_new_utpppr_rec.seq) LOOP
            l_new_utppspa_rec.seq := l_seq;
            --insert the record in utppspa
             INSERT INTO utppspa
             (pp, version, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5,
              pr, pr_version, seq,
              low_limit, high_limit, low_spec, high_spec,
              low_dev, rel_low_dev, target, high_dev, rel_high_dev)
             VALUES
             (a_new_pp, a_new_pp_version, a_new_pp_key1, a_new_pp_key2, a_new_pp_key3, a_new_pp_key4, a_new_pp_key5,
              l_new_utppspa_rec.pr, l_new_utppspa_rec.pr_version, l_new_utppspa_rec.seq,
              l_new_utppspa_rec.low_limit, l_new_utppspa_rec.high_limit, l_new_utppspa_rec.low_spec, l_new_utppspa_rec.high_spec,
              l_new_utppspa_rec.low_dev, l_new_utppspa_rec.rel_low_dev, l_new_utppspa_rec.target, l_new_utppspa_rec.high_dev, l_new_utppspa_rec.rel_high_dev);
        END LOOP;
        FOR l_new_utppspb_rec IN l_old_spb_cursor(l_new_utpppr_rec.pr, l_new_utpppr_rec.pr_version, l_new_utpppr_rec.seq) LOOP
            l_new_utppspb_rec.seq := l_seq;
            --insert the record in utppspb
             INSERT INTO utppspb
                 (pp, version, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5,
                  pr, pr_version, seq,
                  low_limit, high_limit, low_spec, high_spec,
                  low_dev, rel_low_dev, target, high_dev, rel_high_dev)
             VALUES
                 (a_new_pp, a_new_pp_version, a_new_pp_key1, a_new_pp_key2, a_new_pp_key3, a_new_pp_key4, a_new_pp_key5,
                  l_new_utppspb_rec.pr, l_new_utppspb_rec.pr_version, l_new_utppspb_rec.seq,
                  l_new_utppspb_rec.low_limit, l_new_utppspb_rec.high_limit, l_new_utppspb_rec.low_spec, l_new_utppspb_rec.high_spec,
                  l_new_utppspb_rec.low_dev, l_new_utppspb_rec.rel_low_dev, l_new_utppspb_rec.target, l_new_utppspb_rec.high_dev, l_new_utppspb_rec.rel_high_dev);
         END LOOP;
        FOR l_new_utppspc_rec IN l_old_spc_cursor(l_new_utpppr_rec.pr, l_new_utpppr_rec.pr_version, l_new_utpppr_rec.seq) LOOP
            l_new_utppspc_rec.seq := l_seq;
            --insert the record in utppspc
            INSERT INTO utppspc
                (pp, version, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5,
                pr, pr_version, seq,
                low_limit, high_limit, low_spec, high_spec,
                low_dev, rel_low_dev, target, high_dev, rel_high_dev)
            VALUES
                (a_new_pp, a_new_pp_version, a_new_pp_key1, a_new_pp_key2, a_new_pp_key3, a_new_pp_key4, a_new_pp_key5,
                l_new_utppspc_rec.pr, l_new_utppspc_rec.pr_version, l_new_utppspc_rec.seq,
                l_new_utppspc_rec.low_limit, l_new_utppspc_rec.high_limit, l_new_utppspc_rec.low_spec, l_new_utppspc_rec.high_spec,
                l_new_utppspc_rec.low_dev, l_new_utppspc_rec.rel_low_dev, l_new_utppspc_rec.target, l_new_utppspc_rec.high_dev, l_new_utppspc_rec.rel_high_dev);
        END LOOP;
   END LOOP;

   --Fill in pr_version in utppprau with MAX(pr_version)
   --since NULL is not tolerated by our client application
   UPDATE utppprau a
   SET a.pr_version = (SELECT MAX(b.pr_version)
                       FROM utpppr b
                       WHERE b.pp = a_new_pp
                       AND b.version = a_new_pp_version
                       AND b.pp_key1 = a_new_pp_key1
                       AND b.pp_key2 = a_new_pp_key2
                       AND b.pp_key3 = a_new_pp_key3
                       AND b.pp_key4 = a_new_pp_key4
                       AND b.pp_key5 = a_new_pp_key5
                       AND b.pr = a.pr)
   WHERE a.pp = a_new_pp
   AND a.version = a_new_pp_version
   AND a.pp_key1 = a_new_pp_key1
   AND a.pp_key2 = a_new_pp_key2
   AND a.pp_key3 = a_new_pp_key3
   AND a.pp_key4 = a_new_pp_key4
   AND a.pp_key5 = a_new_pp_key5;

   --determine which order to use
   --when the relative order has not been modified in in old_pp, the order
   --of pr's in pp is the similar to the order of pr's in newref_pp
   --when the relative order has been modified in in old_pp, the order
   --of pr's in pp is the similar to the order of pr's in old_pp
   -- Example1:
   --      oldref_pp: pp1 v1.0 - 1.prA  2.prB  3.prC  4.prD
   --      old_pp:    pp1 v1.1 - 1.prA  2.prD  3.prC  4.prB           <<< ORDER CHANGED
   --      newref_pp: pp1 v2.0 - 1.prA  2.prB  3.prE  4.prC  5.prD
   --      new_pp:    pp1 v1.1 - 1.prA  2.prD  3.prC  4.prB  5.prE
   -- Example2:
   --      oldref_pp: pp1 v1.0 - 1.prA  2.prB  3.prC  4.prD
   --      old_pp:    pp1 v1.1 - 1.prA  2.prD  3.prC  4.prB           <<< ORDER CHANGED
   --      newref_pp: pp1 v2.0 - 1.prA  2.prB  3.prC  4.prD  5.prE
   --      new_pp:    pp1 v1.1 - 1.prA  2.prD  3.prE  4.prC  5.prB
   -- Example3:
   --      oldref_pp: pp1 v1.0 - 1.prA  2.prB  3.prC  4.prD
   --      old_pp:    pp1 v1.1 -        1.prB  2.prC  3.prD  4.prE       (relative order kept here)
   --      newref_pp: pp1 v2.0 - 1.prA  2.prD  3.prC  4.prB           <<< ORDER CHANGED
   --      new_pp:    pp1 v1.1 -        1.prD  2.prE  3.prC  4.prB
   -- Example4:
   --      oldref_pp: pp1 v1.0 - 1.prA  2.prB  3.prC  4.prD
   --      old_pp:    pp1 v1.1 - 1.prA  2.prD  3.prC  4.prB           <<< ORDER CHANGED *
   --      newref_pp: pp1 v2.0 - 1.prB  2.prA  3.prC  4.prD  5.prE    <<< ORDER CHANGED
   --      new_pp:    pp1 v1.1 - 1.prA  2.prD  3.prE  4.prC  5.prB    *= winning order

   --Is the relative order changed in old_pp when comparing it to oldref_pp ?
   --The following query will return no record (no data found raised when somthing is found
   l_order_modified_in_oldpp := 'N';
   IF c_keep_newversion_pppr_order = '0' THEN

         --the 2 following queries is checking that all possible 'follows' relation
         --present in one pp are also present in the other for the pr's
         --that are common to the 2
         --
         --It is enough that one of the 2 is containing the possible 'follows'
         -- relation of the other to be sure that the order has not changed between the 2
         SELECT COUNT(*)
         INTO l_count_follows_not_common1
         FROM
            (SELECT DISTINCT PRIOR pr , a.pr FROM
               (SELECT aa.pr, ROWNUM rel_pos FROM
                  (SELECT MAX(pr) pr  FROM UTPPPR
                   WHERE pp=a_oldref_pp AND version=a_oldref_pp_version
                     AND pp_key1=a_oldref_pp_key1 AND pp_key2=a_oldref_pp_key2
                     AND pp_key3=a_oldref_pp_key3 AND pp_key4=a_oldref_pp_key4
                     AND pp_key5=a_oldref_pp_key5
                     AND pr IN (SELECT pr
                                FROM utpppr
                                WHERE pp=a_oldref_pp AND version=a_oldref_pp_version
                                  AND pp_key1=a_oldref_pp_key1 AND pp_key2=a_oldref_pp_key2
                                  AND pp_key3=a_oldref_pp_key3 AND pp_key4=a_oldref_pp_key4
                                  AND pp_key5=a_oldref_pp_key5
                                INTERSECT
                                SELECT pr
                                FROM utpppr
                                WHERE pp=a_old_pp AND version=a_old_pp_version
                                  AND pp_key1=a_old_pp_key1 AND pp_key2=a_old_pp_key2
                                  AND pp_key3=a_old_pp_key3 AND pp_key4=a_old_pp_key4
                                  AND pp_key5=a_old_pp_key5)
                  GROUP  BY seq) aa) a
              CONNECT BY PRIOR a.rel_pos <= a.rel_pos-1 AND PRIOR a.pr <> a.pr AND LEVEL <=2
                            MINUS
              SELECT DISTINCT PRIOR pr , a.pr FROM
                 (SELECT aa.pr, ROWNUM rel_pos FROM
                    (SELECT MAX(pr) pr  FROM UTPPPR
                     WHERE pp=a_old_pp AND version=a_old_pp_version
                       AND pp_key1=a_old_pp_key1 AND pp_key2=a_old_pp_key2
                       AND pp_key3=a_old_pp_key3 AND pp_key4=a_old_pp_key4
                       AND pp_key5=a_old_pp_key5
                       AND pr IN (SELECT pr
                                  FROM utpppr
                                  WHERE pp=a_oldref_pp AND version=a_oldref_pp_version
                                    AND pp_key1=a_oldref_pp_key1 AND pp_key2=a_oldref_pp_key2
                                    AND pp_key3=a_oldref_pp_key3 AND pp_key4=a_oldref_pp_key4
                                    AND pp_key5=a_oldref_pp_key5
                                  INTERSECT
                                  SELECT pr
                                  FROM utpppr
                                  WHERE pp=a_old_pp AND version=a_old_pp_version
                                    AND pp_key1=a_old_pp_key1 AND pp_key2=a_old_pp_key2
                                    AND pp_key3=a_old_pp_key3 AND pp_key4=a_old_pp_key4
                                    AND pp_key5=a_old_pp_key5)
                    GROUP  BY seq) aa) a
              CONNECT BY PRIOR a.rel_pos <= a.rel_pos-1 AND PRIOR a.pr <> a.pr AND LEVEL <=2);

         SELECT COUNT(*)
         INTO l_count_follows_not_common2
         FROM
            (SELECT DISTINCT PRIOR pr , a.pr FROM
               (SELECT aa.pr, ROWNUM rel_pos FROM
                  (SELECT MAX(pr) pr  FROM UTPPPR
                     WHERE pp=a_old_pp AND version=a_old_pp_version
                       AND pp_key1=a_old_pp_key1 AND pp_key2=a_old_pp_key2
                       AND pp_key3=a_old_pp_key3 AND pp_key4=a_old_pp_key4
                       AND pp_key5=a_old_pp_key5
                       AND pr IN (SELECT pr
                                    FROM utpppr
                                   WHERE pp=a_oldref_pp AND version=a_oldref_pp_version
                                     AND pp_key1=a_oldref_pp_key1 AND pp_key2=a_oldref_pp_key2
                                     AND pp_key3=a_oldref_pp_key3 AND pp_key4=a_oldref_pp_key4
                                     AND pp_key5=a_oldref_pp_key5
                                   INTERSECT
                                   SELECT pr FROM
                                   utpppr
                                   WHERE pp=a_old_pp AND version=a_old_pp_version
                                      AND pp_key1=a_old_pp_key1 AND pp_key2=a_old_pp_key2
                                      AND pp_key3=a_old_pp_key3 AND pp_key4=a_old_pp_key4
                                      AND pp_key5=a_old_pp_key5)
                  GROUP  BY seq) aa) a
              CONNECT BY PRIOR a.rel_pos <= a.rel_pos-1 AND PRIOR a.pr <> a.pr AND LEVEL <=2
              MINUS
              SELECT DISTINCT PRIOR pr , a.pr FROM
                 (SELECT aa.pr, ROWNUM rel_pos FROM
                    (SELECT MAX(pr) pr  FROM UTPPPR
                     WHERE pp=a_oldref_pp AND version=a_oldref_pp_version
                       AND pp_key1=a_oldref_pp_key1 AND pp_key2=a_oldref_pp_key2
                       AND pp_key3=a_oldref_pp_key3 AND pp_key4=a_oldref_pp_key4
                       AND pp_key5=a_oldref_pp_key5
                       AND pr IN (SELECT pr
                                  FROM utpppr
                                  WHERE pp=a_oldref_pp AND version=a_oldref_pp_version
                                    AND pp_key1=a_oldref_pp_key1 AND pp_key2=a_oldref_pp_key2
                                    AND pp_key3=a_oldref_pp_key3 AND pp_key4=a_oldref_pp_key4
                                    AND pp_key5=a_oldref_pp_key5
                                  INTERSECT
                                  SELECT pr FROM utpppr WHERE pp=a_old_pp AND version=a_old_pp_version
                                    AND pp_key1=a_old_pp_key1 AND pp_key2=a_old_pp_key2
                                    AND pp_key3=a_old_pp_key3 AND pp_key4=a_old_pp_key4
                                    AND pp_key5=a_old_pp_key5)
                    GROUP  BY seq) aa) a
              CONNECT BY PRIOR a.rel_pos <= a.rel_pos-1 AND PRIOR a.pr <> a.pr AND LEVEL <=2);
         IF l_count_follows_not_common1 > 0 AND
            l_count_follows_not_common2 > 0 THEN
            l_order_modified_in_oldpp := 'Y';
--DBMS_OUTPUT.PUT_LINE('Order modified');
--ELSE
--DBMS_OUTPUT.PUT_LINE('Order not modified');

         END IF;

/*
      BEGIN
         SELECT 'Y'
         INTO l_order_modified_in_oldpp
         FROM dual
         WHERE EXISTS
         (
            (SELECT a.pr, a.rel_pos, b.pr, b.rel_pos FROM
               (SELECT aa.pr, ROWNUM rel_pos FROM
                  (SELECT pr  FROM utpppr
                   WHERE pp=a_oldref_pp AND version=a_oldref_pp_version
                     AND pp_key1=a_oldref_pp_key1 AND pp_key2=a_oldref_pp_key2
                     AND pp_key3=a_oldref_pp_key3 AND pp_key4=a_oldref_pp_key4
                     AND pp_key5=a_oldref_pp_key5
                     AND pr IN (SELECT pr
                                FROM utpppr
                                WHERE pp=a_oldref_pp AND version=a_oldref_pp_version
                                  AND pp_key1=a_oldref_pp_key1 AND pp_key2=a_oldref_pp_key2
                                  AND pp_key3=a_oldref_pp_key3 AND pp_key4=a_oldref_pp_key4
                                  AND pp_key5=a_oldref_pp_key5
                                INTERSECT
                                SELECT pr FROM utpppr WHERE pp=a_old_pp AND version=a_old_pp_version
                                  AND pp_key1=a_old_pp_key1 AND pp_key2=a_old_pp_key2
                                  AND pp_key3=a_old_pp_key3 AND pp_key4=a_old_pp_key4
                                  AND pp_key5=a_old_pp_key5)
                  GROUP BY seq, pr) aa) a,
               (SELECT bb.pr, ROWNUM rel_pos FROM
                  (SELECT pr  FROM utpppr
                  WHERE pp=a_oldref_pp AND version=a_oldref_pp_version
                     AND pp_key1=a_oldref_pp_key1 AND pp_key2=a_oldref_pp_key2
                     AND pp_key3=a_oldref_pp_key3 AND pp_key4=a_oldref_pp_key4
                     AND pp_key5=a_oldref_pp_key5
                     AND pr IN (SELECT pr
                                FROM utpppr
                                WHERE pp=a_oldref_pp AND version=a_oldref_pp_version
                                  AND pp_key1=a_oldref_pp_key1 AND pp_key2=a_oldref_pp_key2
                                  AND pp_key3=a_oldref_pp_key3 AND pp_key4=a_oldref_pp_key4
                                  AND pp_key5=a_oldref_pp_key5
                                INTERSECT
                                SELECT pr FROM utpppr WHERE pp=a_old_pp AND version=a_old_pp_version
                                  AND pp_key1=a_old_pp_key1 AND pp_key2=a_old_pp_key2
                                  AND pp_key3=a_old_pp_key3 AND pp_key4=a_old_pp_key4
                                  AND pp_key5=a_old_pp_key5)
                  ORDER BY seq, pr) bb) b
            WHERE b.rel_pos = a.rel_pos+1)
            MINUS
            (SELECT  DISTINCT pr, pr_rel_pos, next_pr,  next_pr_rel_pos FROM
            (SELECT a.pr pr , a.rel_pos pr_rel_pos, b.pr next_pr, b.rel_pos next_pr_rel_pos,
                                PRIOR z.pr prior_pr, PRIOR z.rel_pos prior_pr_rel_pos, z.pr next_pr_2, z.rel_pos next_pr_rel_pos_2, LEVEL my_level  FROM
               (SELECT aa.pr, ROWNUM rel_pos FROM
                  (SELECT pr  FROM utpppr
                   WHERE pp=a_oldref_pp AND version=a_oldref_pp_version
                     AND pp_key1=a_oldref_pp_key1 AND pp_key2=a_oldref_pp_key2
                     AND pp_key3=a_oldref_pp_key3 AND pp_key4=a_oldref_pp_key4
                     AND pp_key5=a_oldref_pp_key5
                     AND pr IN (SELECT pr
                                FROM utpppr
                                WHERE pp=a_oldref_pp AND version=a_oldref_pp_version
                                  AND pp_key1=a_oldref_pp_key1 AND pp_key2=a_oldref_pp_key2
                                  AND pp_key3=a_oldref_pp_key3 AND pp_key4=a_oldref_pp_key4
                                  AND pp_key5=a_oldref_pp_key5
                                INTERSECT
                                SELECT pr FROM utpppr WHERE pp=a_old_pp AND version=a_old_pp_version
                                  AND pp_key1=a_old_pp_key1 AND pp_key2=a_old_pp_key2
                                  AND pp_key3=a_old_pp_key3 AND pp_key4=a_old_pp_key4
                                  AND pp_key5=a_old_pp_key5)
                  ORDER BY seq, pr) aa) a,
               (SELECT bb.pr, ROWNUM rel_pos FROM
                  (SELECT pr  FROM utpppr
                   WHERE pp=a_oldref_pp AND version=a_oldref_pp_version
                     AND pp_key1=a_oldref_pp_key1 AND pp_key2=a_oldref_pp_key2
                     AND pp_key3=a_oldref_pp_key3 AND pp_key4=a_oldref_pp_key4
                     AND pp_key5=a_oldref_pp_key5
                     AND pr IN (SELECT pr
                                FROM utpppr
                                WHERE pp=a_oldref_pp AND version=a_oldref_pp_version
                                  AND pp_key1=a_oldref_pp_key1 AND pp_key2=a_oldref_pp_key2
                                  AND pp_key3=a_oldref_pp_key3 AND pp_key4=a_oldref_pp_key4
                                  AND pp_key5=a_oldref_pp_key5
                                INTERSECT
                                SELECT pr FROM utpppr
                                WHERE pp=a_old_pp AND version=a_old_pp_version
                                  AND pp_key1=a_old_pp_key1 AND pp_key2=a_old_pp_key2
                                  AND pp_key3=a_old_pp_key3 AND pp_key4=a_old_pp_key4
                                  AND pp_key5=a_old_pp_key5)
                  ORDER BY seq, pr) bb) b,
               (SELECT zz.pr, ROWNUM rel_pos FROM
                  (SELECT pr FROM utpppr
                   WHERE pp=a_old_pp AND version=a_old_pp_version
                     AND pp_key1=a_old_pp_key1 AND pp_key2=a_old_pp_key2
                     AND pp_key3=a_old_pp_key3 AND pp_key4=a_old_pp_key4
                     AND pp_key5=a_old_pp_key5
                           AND pr IN (SELECT pr
                                FROM utpppr
                                WHERE pp=a_oldref_pp AND version=a_oldref_pp_version
                                  AND pp_key1=a_oldref_pp_key1 AND pp_key2=a_oldref_pp_key2
                                  AND pp_key3=a_oldref_pp_key3 AND pp_key4=a_oldref_pp_key4
                                  AND pp_key5=a_oldref_pp_key5
                                INTERSECT
                                SELECT pr FROM utpppr
                                WHERE pp=a_old_pp AND version=a_old_pp_version
                                  AND pp_key1=a_old_pp_key1 AND pp_key2=a_old_pp_key2
                                  AND pp_key3=a_old_pp_key3 AND pp_key4=a_old_pp_key4
                                  AND pp_key5=a_old_pp_key5)
                  ORDER BY seq, pr) zz) z
            WHERE b.rel_pos = a.rel_pos+1
            START WITH (z.pr = a.pr AND a.rel_pos=1)
            CONNECT BY PRIOR z.rel_pos  < z.rel_pos AND z.pr = b.pr AND b.rel_pos = LEVEL
            )
            WHERE prior_pr IS NOT NULL)
         );
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         l_order_modified_in_oldpp := 'N';
      END;
*/

   END IF;

   l_reorder_took_place := FALSE;
   IF l_order_modified_in_oldpp = 'Y' THEN

      l_reorder_took_place := TRUE;
      --sort according to order in oldpp
      --TraceError('UNDIFF.CompareAndCreatepp','(debug) order modified according to oldpp');

      SELECT NVL(MAX(a.seq),0)+1
      INTO l_max_seq_in_new_pp
      FROM utpppr a
      WHERE a.pp = a_new_pp
      AND a.version = a_new_pp_version
      AND a.pp_key1 = a_new_pp_key1
      AND a.pp_key2 = a_new_pp_key2
      AND a.pp_key3 = a_new_pp_key3
      AND a.pp_key4 = a_new_pp_key4
      AND a.pp_key5 = a_new_pp_key5;

      --turn all sequence to a negative value to avoid the unique constraint index violations
      UPDATE utpppr a
      SET a.seq = -seq
      WHERE a.pp = a_new_pp
      AND a.version = a_new_pp_version
      AND a.pp_key1 = a_new_pp_key1
      AND a.pp_key2 = a_new_pp_key2
      AND a.pp_key3 = a_new_pp_key3
      AND a.pp_key4 = a_new_pp_key4
      AND a.pp_key5 = a_new_pp_key5;

      UPDATE utppspa a
      SET a.seq = -seq
      WHERE a.pp = a_new_pp
      AND a.version = a_new_pp_version
      AND a.pp_key1 = a_new_pp_key1
      AND a.pp_key2 = a_new_pp_key2
      AND a.pp_key3 = a_new_pp_key3
      AND a.pp_key4 = a_new_pp_key4
      AND a.pp_key5 = a_new_pp_key5;

      UPDATE utppspb a
      SET a.seq = -seq
      WHERE a.pp = a_new_pp
      AND a.version = a_new_pp_version
      AND a.pp_key1 = a_new_pp_key1
      AND a.pp_key2 = a_new_pp_key2
      AND a.pp_key3 = a_new_pp_key3
      AND a.pp_key4 = a_new_pp_key4
      AND a.pp_key5 = a_new_pp_key5;

      UPDATE utppspc a
      SET a.seq = -seq
      WHERE a.pp = a_new_pp
      AND a.version = a_new_pp_version
      AND a.pp_key1 = a_new_pp_key1
      AND a.pp_key2 = a_new_pp_key2
      AND a.pp_key3 = a_new_pp_key3
      AND a.pp_key4 = a_new_pp_key4
      AND a.pp_key5 = a_new_pp_key5;

      l_reorder_seq := 0;
      l_error_logged := FALSE;
      FOR l_reorder_rec IN l_reorder_follow_old_cursor(l_max_seq_in_new_pp) LOOP
         BEGIN

            SELECT MAX(b.seq)
            INTO l_orig_seq
            FROM utpppr b
            WHERE b.pp = a_new_pp
            AND b.version = a_new_pp_version
            AND b.pp_key1 = a_new_pp_key1
            AND b.pp_key2 = a_new_pp_key2
            AND b.pp_key3 = a_new_pp_key3
            AND b.pp_key4 = a_new_pp_key4
            AND b.pp_key5 = a_new_pp_key5
            AND b.pr = l_reorder_rec.pr
            AND b.seq < 0;
/* DEBUGGING CODE
DBMS_OUTPUT.PUT_LINE('pr='||l_reorder_rec.pr||'#seq'||l_reorder_rec.seq||'#orig_seq='||l_orig_seq);
*/
            l_reorder_seq := l_reorder_seq+1;
            UPDATE utpppr a
            SET a.seq = l_reorder_seq
            WHERE a.pp = a_new_pp
            AND a.version = a_new_pp_version
            AND a.pp_key1 = a_new_pp_key1
            AND a.pp_key2 = a_new_pp_key2
            AND a.pp_key3 = a_new_pp_key3
            AND a.pp_key4 = a_new_pp_key4
            AND a.pp_key5 = a_new_pp_key5
            AND a.pr = l_reorder_rec.pr
            AND a.seq = l_orig_seq;

            UPDATE utppspa a
            SET a.seq = l_reorder_seq
            WHERE a.pp = a_new_pp
            AND a.version = a_new_pp_version
            AND a.pp_key1 = a_new_pp_key1
            AND a.pp_key2 = a_new_pp_key2
            AND a.pp_key3 = a_new_pp_key3
            AND a.pp_key4 = a_new_pp_key4
            AND a.pp_key5 = a_new_pp_key5
            AND a.pr = l_reorder_rec.pr
            AND a.seq = l_orig_seq;

            UPDATE utppspb a
            SET a.seq = l_reorder_seq
            WHERE a.pp = a_new_pp
            AND a.version = a_new_pp_version
            AND a.pp_key1 = a_new_pp_key1
            AND a.pp_key2 = a_new_pp_key2
            AND a.pp_key3 = a_new_pp_key3
            AND a.pp_key4 = a_new_pp_key4
            AND a.pp_key5 = a_new_pp_key5
            AND a.pr = l_reorder_rec.pr
            AND a.seq = l_orig_seq;

            UPDATE utppspc a
            SET a.seq = l_reorder_seq
            WHERE a.pp = a_new_pp
            AND a.version = a_new_pp_version
            AND a.pp_key1 = a_new_pp_key1
            AND a.pp_key2 = a_new_pp_key2
            AND a.pp_key3 = a_new_pp_key3
            AND a.pp_key4 = a_new_pp_key4
            AND a.pp_key5 = a_new_pp_key5
            AND a.pr = l_reorder_rec.pr
            AND a.seq = l_orig_seq;

            -- No check on SQL%ROWCOUNT since cursor is also returning the deleted records.
         EXCEPTION
         WHEN OTHERS THEN
            --the parameter is present more than once or the seq is already used
            IF l_error_logged = FALSE THEN
               TraceError('UNDIFF.CompareAndCreatepp','SQLERRM='||SQLERRM);
               TraceError('UNDIFF.CompareAndCreatepp',
                          'while resorting for pr='||l_reorder_rec.pr||'#pp='||a_new_pp||'#pp_version='||a_new_pp_version||
                          '#pp_key1='||a_new_pp_key1||'#pp_key2='||a_new_pp_key2||'#pp_key3='||a_new_pp_key3||
                          '#pp_key4='||a_new_pp_key4||'#pp_key5='||a_new_pp_key5);
               l_error_logged := TRUE;
            END IF;
         END;
      END LOOP;

   ELSIF l_some_pr_appended_in_oldpp THEN

      --some pr have been added to the old_pp and have been added to the new_pp
      --but the sequence is not correct
      --sort according to order in newref_pp
      l_reorder_took_place := TRUE;
      --TraceError('UNDIFF.CompareAndCreatepp','(debug) order modified according to nexref_pp');

      SELECT NVL(MAX(a.seq),0)+1
      INTO l_max_seq_in_new_pp
      FROM utpppr a
      WHERE a.pp = a_new_pp
      AND a.version = a_new_pp_version
      AND a.pp_key1 = a_new_pp_key1
      AND a.pp_key2 = a_new_pp_key2
      AND a.pp_key3 = a_new_pp_key3
      AND a.pp_key4 = a_new_pp_key4
      AND a.pp_key5 = a_new_pp_key5;

      --turn all sequence to a negative value to avoid the unique constraint index violations
      UPDATE utpppr a
      SET a.seq = -seq
      WHERE a.pp = a_new_pp
      AND a.version = a_new_pp_version
      AND a.pp_key1 = a_new_pp_key1
      AND a.pp_key2 = a_new_pp_key2
      AND a.pp_key3 = a_new_pp_key3
      AND a.pp_key4 = a_new_pp_key4
      AND a.pp_key5 = a_new_pp_key5;

      UPDATE utppspa a
      SET a.seq = -seq
      WHERE a.pp = a_new_pp
      AND a.version = a_new_pp_version
      AND a.pp_key1 = a_new_pp_key1
      AND a.pp_key2 = a_new_pp_key2
      AND a.pp_key3 = a_new_pp_key3
      AND a.pp_key4 = a_new_pp_key4
      AND a.pp_key5 = a_new_pp_key5;

      UPDATE utppspb a
      SET a.seq = -seq
      WHERE a.pp = a_new_pp
      AND a.version = a_new_pp_version
      AND a.pp_key1 = a_new_pp_key1
      AND a.pp_key2 = a_new_pp_key2
      AND a.pp_key3 = a_new_pp_key3
      AND a.pp_key4 = a_new_pp_key4
      AND a.pp_key5 = a_new_pp_key5;

      UPDATE utppspc a
      SET a.seq = -seq
      WHERE a.pp = a_new_pp
      AND a.version = a_new_pp_version
      AND a.pp_key1 = a_new_pp_key1
      AND a.pp_key2 = a_new_pp_key2
      AND a.pp_key3 = a_new_pp_key3
      AND a.pp_key4 = a_new_pp_key4
      AND a.pp_key5 = a_new_pp_key5;

      l_reorder_seq := 0;
      l_error_logged := FALSE;
      FOR l_reorder_rec IN l_reorder_follow_newref_cursor(l_max_seq_in_new_pp) LOOP
         BEGIN
            SELECT MAX(b.seq)
            INTO l_orig_seq
            FROM utpppr b
            WHERE b.pp = a_new_pp
            AND b.version = a_new_pp_version
            AND b.pp_key1 = a_new_pp_key1
            AND b.pp_key2 = a_new_pp_key2
            AND b.pp_key3 = a_new_pp_key3
            AND b.pp_key4 = a_new_pp_key4
            AND b.pp_key5 = a_new_pp_key5
            AND b.pr = l_reorder_rec.pr
            AND b.seq < 0;
/* DEBUGGING CODE
DBMS_OUTPUT.PUT_LINE('pr='||l_reorder_rec.pr||'#seq'||l_reorder_rec.seq||'#orig_seq='||l_orig_seq);
*/
            l_reorder_seq := l_reorder_seq+1;
            UPDATE utpppr a
            SET a.seq = l_reorder_seq
            WHERE a.pp = a_new_pp
            AND a.version = a_new_pp_version
            AND a.pp_key1 = a_new_pp_key1
            AND a.pp_key2 = a_new_pp_key2
            AND a.pp_key3 = a_new_pp_key3
            AND a.pp_key4 = a_new_pp_key4
            AND a.pp_key5 = a_new_pp_key5
            AND a.pr = l_reorder_rec.pr
            AND a.seq = l_orig_seq;

            UPDATE utppspa a
            SET a.seq = l_reorder_seq
            WHERE a.pp = a_new_pp
            AND a.version = a_new_pp_version
            AND a.pp_key1 = a_new_pp_key1
            AND a.pp_key2 = a_new_pp_key2
            AND a.pp_key3 = a_new_pp_key3
            AND a.pp_key4 = a_new_pp_key4
            AND a.pp_key5 = a_new_pp_key5
            AND a.pr = l_reorder_rec.pr
            AND a.seq = l_orig_seq;

            UPDATE utppspb a
            SET a.seq = l_reorder_seq
            WHERE a.pp = a_new_pp
            AND a.version = a_new_pp_version
            AND a.pp_key1 = a_new_pp_key1
            AND a.pp_key2 = a_new_pp_key2
            AND a.pp_key3 = a_new_pp_key3
            AND a.pp_key4 = a_new_pp_key4
            AND a.pp_key5 = a_new_pp_key5
            AND a.pr = l_reorder_rec.pr
            AND a.seq = l_orig_seq;

            UPDATE utppspc a
            SET a.seq = l_reorder_seq
            WHERE a.pp = a_new_pp
            AND a.version = a_new_pp_version
            AND a.pp_key1 = a_new_pp_key1
            AND a.pp_key2 = a_new_pp_key2
            AND a.pp_key3 = a_new_pp_key3
            AND a.pp_key4 = a_new_pp_key4
            AND a.pp_key5 = a_new_pp_key5
            AND a.pr = l_reorder_rec.pr
            AND a.seq = l_orig_seq;

            -- No check on SQL%ROWCOUNT since cursor is also returning the deleted records.
         EXCEPTION
         WHEN OTHERS THEN
            --the parameter is present more than once or the seq is already used
            IF l_error_logged = FALSE THEN
               TraceError('UNDIFF.CompareAndCreatepp','SQLERRM='||SQLERRM);
               TraceError('UNDIFF.CompareAndCreatepp',
                          'while resorting for pr='||l_reorder_rec.pr||'#pp='||a_new_pp||'#pp_version='||a_new_pp_version||
                          '#pp_key1='||a_new_pp_key1||'#pp_key2='||a_new_pp_key2||'#pp_key3='||a_new_pp_key3||
                          '#pp_key4='||a_new_pp_key4||'#pp_key5='||a_new_pp_key5);
               l_error_logged := TRUE;
            END IF;
         END;
      END LOOP;
   END IF;

   IF l_reorder_took_place THEN

      --set the sequence to a positive integer if necessary; should not be necessary but
      l_entered_loop := FALSE;
      FOR l_rec IN l_reorder_corr_ppprseq_cursor LOOP
         UPDATE utpppr a
         SET a.seq = (SELECT NVL(MAX(b.seq),0)+1
                      FROM utpppr b
                      WHERE b.pp = a_new_pp
                        AND b.version = a_new_pp_version
                        AND b.pp_key1 = a_new_pp_key1
                        AND b.pp_key2 = a_new_pp_key2
                        AND b.pp_key3 = a_new_pp_key3
                        AND b.pp_key4 = a_new_pp_key4
                        AND b.pp_key5 = a_new_pp_key5)
         --WHERE CURRENT OF l_reorder_corr_ppprseq_cursor
         --(Bug in Oracle Bug 2279457 COMBINING DML 'RETURNING' CLAUSE WITH 'WHERE CURRENT OF' IN PL/SQL GIVES ERROR)
         WHERE rowid = l_rec.rowid
         RETURNING a.seq
         INTO l_reorder_seq;

         UPDATE utppspa a
         SET a.seq = l_reorder_seq
         WHERE a.pp = a_new_pp
         AND a.version = a_new_pp_version
         AND a.pp_key1 = a_new_pp_key1
         AND a.pp_key2 = a_new_pp_key2
         AND a.pp_key3 = a_new_pp_key3
         AND a.pp_key4 = a_new_pp_key4
         AND a.pp_key5 = a_new_pp_key5
         AND a.pr = l_rec.pr
         AND a.seq = l_rec.seq;

         UPDATE utppspb a
         SET a.seq = l_reorder_seq
         WHERE a.pp = a_new_pp
         AND a.version = a_new_pp_version
         AND a.pp_key1 = a_new_pp_key1
         AND a.pp_key2 = a_new_pp_key2
         AND a.pp_key3 = a_new_pp_key3
         AND a.pp_key4 = a_new_pp_key4
         AND a.pp_key5 = a_new_pp_key5
         AND a.pr = l_rec.pr
         AND a.seq = l_rec.seq;

         UPDATE utppspc a
         SET a.seq = l_reorder_seq
         WHERE a.pp = a_new_pp
         AND a.version = a_new_pp_version
         AND a.pp_key1 = a_new_pp_key1
         AND a.pp_key2 = a_new_pp_key2
         AND a.pp_key3 = a_new_pp_key3
         AND a.pp_key4 = a_new_pp_key4
         AND a.pp_key5 = a_new_pp_key5
         AND a.pr = l_rec.pr
         AND a.seq = l_rec.seq;

         TraceError('UNDIFF.CompareAndCreatepp', 'pr='||l_rec.pr||'#seq='||l_rec.seq);
         l_entered_loop := TRUE;
      END LOOP;

      IF l_entered_loop THEN
         TraceError('UNDIFF.CompareAndCreatepp','(warning) records found with negative sequences!');
         TraceError('UNDIFF.CompareAndCreatepp',
                    '#pp='||a_new_pp||'#pp_version='||a_new_pp_version||
                    '#pp_key1='||a_new_pp_key1||'#pp_key2='||a_new_pp_key2||'#pp_key3='||a_new_pp_key3||
                    '#pp_key4='||a_new_pp_key4||'#pp_key5='||a_new_pp_key5);
      END IF;

      --gaps in sequence numbers might be present: clean
      l_reorder_seq := 0;
      FOR l_rec IN l_order_nogaps_ppprseq_cursor LOOP
         l_reorder_seq := l_reorder_seq+1;
         UPDATE utpppr a
         SET a.seq = l_reorder_seq
         WHERE CURRENT OF l_order_nogaps_ppprseq_cursor;

         UPDATE utppspa a
         SET a.seq = l_reorder_seq
         WHERE a.pp = a_new_pp
         AND a.version = a_new_pp_version
         AND a.pp_key1 = a_new_pp_key1
         AND a.pp_key2 = a_new_pp_key2
         AND a.pp_key3 = a_new_pp_key3
         AND a.pp_key4 = a_new_pp_key4
         AND a.pp_key5 = a_new_pp_key5
         AND a.pr = l_rec.pr
         AND a.seq = l_rec.seq;

         UPDATE utppspb a
         SET a.seq = l_reorder_seq
         WHERE a.pp = a_new_pp
         AND a.version = a_new_pp_version
         AND a.pp_key1 = a_new_pp_key1
         AND a.pp_key2 = a_new_pp_key2
         AND a.pp_key3 = a_new_pp_key3
         AND a.pp_key4 = a_new_pp_key4
         AND a.pp_key5 = a_new_pp_key5
         AND a.pr = l_rec.pr
         AND a.seq = l_rec.seq;

         UPDATE utppspc a
         SET a.seq = l_reorder_seq
         WHERE a.pp = a_new_pp
         AND a.version = a_new_pp_version
         AND a.pp_key1 = a_new_pp_key1
         AND a.pp_key2 = a_new_pp_key2
         AND a.pp_key3 = a_new_pp_key3
         AND a.pp_key4 = a_new_pp_key4
         AND a.pp_key5 = a_new_pp_key5
         AND a.pr = l_rec.pr
         AND a.seq = l_rec.seq;

      END LOOP;
   END IF;

   --In projects the following constructions will be added here:
   --  Add some audit trail information in history
   --  send a customized  event to trigger a specific transition
   --  call changestatus to bring the created object directly to a specific status
   INSERT INTO utpphs (pp, version, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5, who,
                       who_description, what, what_description, logdate, logdate_tz, why, tr_seq, ev_seq)
   VALUES (a_new_pp, a_new_pp_version, a_new_pp_key1, a_new_pp_key2, a_new_pp_key3, a_new_pp_key4, a_new_pp_key5,
           UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, 'UNDIFF generated new version(1)',
           'UNDIFF generated new pp:('||a_new_pp||','||a_new_pp_version||','||a_new_pp_key1||','||a_new_pp_key2||','||a_new_pp_key3||','||a_new_pp_key4||','||a_new_pp_key5||') based on'||
                  '#old ref pp:('||a_oldref_pp||','||a_oldref_pp_version||','||a_oldref_pp_key1||','||a_oldref_pp_key2||','||a_oldref_pp_key3||','||a_oldref_pp_key4||','||a_oldref_pp_key5||')',
           CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, '', UNAPIGEN.P_TR_SEQ,
           NVL(UNAPIEV.P_EV_REC.ev_seq, -1));

   INSERT INTO utpphs (pp, version, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5, who,
                       who_description, what, what_description, logdate, logdate_tz, why, tr_seq, ev_seq)
   VALUES (a_new_pp, a_new_pp_version, a_new_pp_key1, a_new_pp_key2, a_new_pp_key3, a_new_pp_key4, a_new_pp_key5,
           UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, 'UNDIFF generated new version(2)',
           '#old pp:('||a_old_pp||','||a_old_pp_version||','||a_old_pp_key1||','||a_old_pp_key2||','||a_old_pp_key3||','||a_old_pp_key4||','||a_old_pp_key5||')'||
           '#new ref pp:('||a_newref_pp||','||a_newref_pp_version||','||a_newref_pp_key1||','||a_newref_pp_key2||','||a_newref_pp_key3||','||a_newref_pp_key4||','||a_newref_pp_key5||')',
           CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, '', UNAPIGEN.P_TR_SEQ,
           NVL(UNAPIEV.P_EV_REC.ev_seq, -2));

    --------------------------------------------------------------------------------
    -- RS20110303 : START OF CHANGE VREDESTEIN
    -- uncomment to force a statuschange to @A
    --------------------------------------------------------------------------------
    lvs_change_ss_pp := APAOGEN.GetSystemSetting('APPROVE_INTERSPEC','NO');
    IF lvs_change_ss_pp = 'YES' THEN

       l_api_name := 'CompareAndCreatePp';
       l_evmgr_name := UNAPIGEN.P_EVMGR_NAME;
       l_object_tp := 'pp';
       l_object_id  := a_new_pp;
       l_object_lc  := '@L';
       l_object_ss  := '@E';
       l_ev_tp      := 'ObjectUpdated';
       l_ev_details := 'pp_key1='||a_new_pp_key1||'#pp_key2='||a_new_pp_key2||'#pp_key3='||a_new_pp_key3||
              '#pp_key4='||a_new_pp_key4||'#pp_key5='||a_new_pp_key5||'#version=' ||a_new_pp_version||'#ss_to=@A';
       l_seq_nr     := NULL;

       l_ret_code := UNAPIEV.INSERTEVENT
                       (l_api_name,
                        l_evmgr_name,
                        l_object_tp,
                        l_object_id,
                        l_object_lc,
                        l_object_lc_version,
                        l_object_ss,
                        l_ev_tp,
                        l_ev_details,
                        l_seq_nr);
       IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
          UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
          l_sqlerrm := 'UNAPIEV.INSERTEVENT ret_code='||l_ret_code||'#pp='||a_new_pp
                       ||'#version='||a_new_pp_version||'#pp_key1='||a_new_pp_key1
                       ||'#pp_key2='||a_new_pp_key2 ||'#pp_key3='||a_new_pp_key3
                       ||'#pp_key4='||a_new_pp_key4 ||'#pp_key5='||a_new_pp_key5;
          RAISE StpError;
       END IF;
   END IF;
    /*
    RS20110303 : END OF CHANGE VREDESTEIN
    */

   IF UNAPIGEN.EndTxn <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE StpError;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF sqlcode <> 1 THEN
      UNAPIGEN.LogError('CompareAndCreatePp',sqlerrm);
   ELSIF l_sqlerrm IS NOT NULL THEN
      UNAPIGEN.LogError('CompareAndCreatePp',l_sqlerrm);
   END IF;
   IF l_utpp_cursor%ISOPEN THEN
      CLOSE l_utpp_cursor;
   END IF;
   IF l_utpppr_cursor%ISOPEN THEN
      CLOSE l_utpppr_cursor;
   END IF;
   IF l_utppspa_cursor%ISOPEN THEN
      CLOSE l_utppspa_cursor;
   END IF;
   IF l_utppspb_cursor%ISOPEN THEN
      CLOSE l_utppspb_cursor;
   END IF;
   IF l_utppspc_cursor%ISOPEN THEN
      CLOSE l_utppspc_cursor;
   END IF;
   RETURN(UNAPIGEN.AbortTxn(UNAPIGEN.P_TXN_ERROR, 'CompareAndCreatePp'));
END CompareAndCreatePp;

-- -----------------------------------------------------------------------------
FUNCTION CompareAndCreateSt
(a_oldref_st           IN     VARCHAR2,       /* VC20_TYPE */
 a_oldref_st_version   IN     VARCHAR2,       /* VC20_TYPE */
 a_newref_st           IN     VARCHAR2,       /* VC20_TYPE */
 a_newref_st_version   IN     VARCHAR2,       /* VC20_TYPE */
 a_old_st              IN     VARCHAR2,       /* VC20_TYPE */
 a_old_st_version      IN     VARCHAR2,       /* VC20_TYPE */
 a_new_st              IN     VARCHAR2,       /* VC20_TYPE */
 a_new_st_version      IN     VARCHAR2)       /* VC20_TYPE */
RETURN NUMBER IS

l_prev_pp_string                    VARCHAR2(140);
l_prev_ip                           VARCHAR2(20);
l_seq                               NUMBER(5);
l_order_modified_in_oldst           CHAR(1);
l_count_follows_not_common1         INTEGER;
l_count_follows_not_common2         INTEGER;
l_reorder_took_place                BOOLEAN;
l_max_seq_in_new_st                 NUMBER(5);
l_reorder_seq                       NUMBER(5);
l_orig_seq                          INTEGER;
l_error_logged                      BOOLEAN;
l_entered_loop                      BOOLEAN;
l_some_pp_appended_in_oldst         BOOLEAN;
lvs_change_ss_st                              VARCHAR2(20);

--utst cursors and variables
CURSOR l_utst_cursor (c_st IN VARCHAR2,
                      c_st_version IN VARCHAR2) IS
SELECT *
FROM utst
WHERE st = c_st
AND version = c_st_version;
l_oldref_utst_rec   l_utst_cursor%ROWTYPE;
l_newref_utst_rec   l_utst_cursor%ROWTYPE;
l_old_utst_rec      l_utst_cursor%ROWTYPE;
l_new_utst_rec      l_utst_cursor%ROWTYPE;

--utstau cursors and variables
--assumption: au_version always NULL
CURSOR l_new_utstau_cursor IS
   --all attributes in oldst
   --and that have not been suppressed in newref
   -- Part1= 1 (NOT IN 2) AND IN 3
   -- 1= all attributes in the old_st
   -- old_st has some differences with oldref, these modifications must be kept
   -- the subqueries are returning these differences
   -- 2= list of attributes that have been suppressed from oldref to make the final old_st
   -- 3= list of attribute values that have not been modified between OLD_REF and OLD (values will be taken from NEW when applicable)
   --
   /* 1 */
   SELECT au, value
     FROM utstau
    WHERE st = a_old_st
      AND version = a_old_st_version
    /* 2 */
    AND au NOT IN (SELECT au
                   FROM utstau
                   WHERE st = a_old_st
                     AND version = a_old_st_version
                   INTERSECT
                     (SELECT au
                      FROM utstau
                      WHERE st = a_oldref_st
                        AND version = a_oldref_st_version
                      MINUS
                      SELECT au
                      FROM utstau
                      WHERE st = a_newref_st
                        AND version = a_newref_st_version
                     )
                   )
    /* 3 */
    --test might seem strange but is alo good for single valued attributes
    --The attribute values are not compared one by one but the list of values are compared
    --LOV are compared here
    --subquery is returning any attribute where the LOV has been modified
    --test is inverted here (would result in two times NOT IN)
    --subquery returns all attributes for which the list of values has been modified in OLD compared to OLD_REF
    AND au IN (SELECT DISTINCT au FROM
                     ((SELECT au, value
                       FROM utstau
                       WHERE st = a_old_st
                         AND version = a_old_st_version
                       UNION
                       SELECT au, value
                       FROM utstau
                       WHERE st = a_oldref_st
                         AND version = a_oldref_st_version
                       )
                      MINUS
                      (SELECT au, value
                       FROM utstau
                       WHERE st = a_old_st
                         AND version = a_old_st_version
                       INTERSECT
                       SELECT au, value
                       FROM utstau
                       WHERE st = a_oldref_st
                         AND version = a_oldref_st_version
                      )
                     )
               )
   UNION
   --all attributes in newref that are not already in oldst
   --and that have not been suppressed
   -- Part2= 1 (NOT IN 2)
   -- 1= all attributes in the newref_st
   -- newref_st has some differences with oldref, these modifications must be kept
   -- the subqueries are returning these differences
   -- 2= list of attributes that are already in old_st or that have been suppressed from oldref to make the final old_st
   /* 1 */
   SELECT au, value
   FROM utstau
   WHERE st = a_newref_st
     AND version = a_newref_st_version
   /* 2 */
   AND au NOT IN (SELECT au
                  FROM utstau
                  WHERE st = a_old_st
                    AND version = a_old_st_version
                 )
   AND au NOT IN (SELECT au
                  FROM utstau
                  WHERE st = a_oldref_st
                    AND version = a_oldref_st_version
                  INTERSECT
                  SELECT au
                  FROM utstau
                  WHERE st = a_newref_st
                    AND version = a_newref_st_version
                 )
   UNION
   --Add all attributes in newref that are already in oldst
   --that have not been updated in oldst
   --and that have not been suppressed
   -- Part3= 1 (NOT IN 2)
   -- 1= all attributes in the newref_st
   -- 2= list of attributes that have been changed between OLD_REF and OLD
   --LOV are compared here
   --subquery is returning any attribute where the LOV has been modified
   --subquery returns all attributes for which the list of values has been modified in OLD compared to OLD_REF
   /* 1 */
   SELECT au, value
   FROM utstau
   WHERE st = a_newref_st
     AND version = a_newref_st_version
   /* 2 */
    AND au NOT IN (SELECT DISTINCT au FROM
                     ((SELECT au, value
                       FROM utstau
                       WHERE st = a_old_st
                         AND version = a_old_st_version
                       UNION
                       SELECT au, value
                       FROM utstau
                       WHERE st = a_oldref_st
                         AND version = a_oldref_st_version
                       )
                      MINUS
                      (SELECT au, value
                       FROM utstau
                       WHERE st = a_old_st
                         AND version = a_old_st_version
                       INTERSECT
                       SELECT au, value
                       FROM utstau
                       WHERE st = a_oldref_st
                         AND version = a_oldref_st_version
                      )
                     )
               )
   ORDER BY au, value;

--utstgk cursors and variables
--assumption: gk_version always NULL
CURSOR l_new_utstgk_cursor IS
   --all group keys in oldst
   --and that have not been suppressed in newref
   -- Part1= 1 (NOT IN 2) AND IN 3
   -- 1= all group keys in the old_st
   -- old_st has some differences with oldref, these modifications must be kept
   -- the subqueries are returning these differences
   -- 2= list of group keys that have been suppressed from oldref to make the final old_st
   -- 3= list of group key values that have not been modified between OLD_REF and OLD (values will be taken from NEW when applicable)
   --
   /* 1 */
   SELECT gk, value
     FROM utstgk
    WHERE st = a_old_st
      AND version = a_old_st_version
    /* 2 */
    AND gk NOT IN (SELECT gk
                   FROM utstgk
                   WHERE st = a_old_st
                     AND version = a_old_st_version
                   INTERSECT
                     (SELECT gk
                      FROM utstgk
                      WHERE st = a_oldref_st
                        AND version = a_oldref_st_version
                      MINUS
                      SELECT gk
                      FROM utstgk
                      WHERE st = a_newref_st
                        AND version = a_newref_st_version
                     )
                   )
    /* 3 */
    --test might seem strange but is alo good for single valued group keys
    --The group key values are not compared one by one but the list of values are compared
    --LOV are compared here
    --subquery is returning any group key where the LOV has been modified
    --test is inverted here (would result in two times NOT IN)
    --subquery returns all group keys for which the list of values has been modified in OLD compared to OLD_REF
    AND gk IN (SELECT DISTINCT gk FROM
                     ((SELECT gk, value
                       FROM utstgk
                       WHERE st = a_old_st
                         AND version = a_old_st_version
                       UNION
                       SELECT gk, value
                       FROM utstgk
                       WHERE st = a_oldref_st
                         AND version = a_oldref_st_version
                       )
                      MINUS
                      (SELECT gk, value
                       FROM utstgk
                       WHERE st = a_old_st
                         AND version = a_old_st_version
                       INTERSECT
                       SELECT gk, value
                       FROM utstgk
                       WHERE st = a_oldref_st
                         AND version = a_oldref_st_version
                      )
                     )
               )
   UNION
   --all group keys in newref that are not already in oldst
   --and that have not been suppressed
   -- Part2= 1 (NOT IN 2)
   -- 1= all group keys in the newref_st
   -- newref_st has some differences with oldref, these modifications must be kept
   -- the subqueries are returning these differences
   -- 2= list of group keys that are already in old_st or that have been suppressed from oldref to make the final old_st
   /* 1 */
   SELECT gk, value
   FROM utstgk
   WHERE st = a_newref_st
     AND version = a_newref_st_version
   /* 2 */
   AND gk NOT IN (SELECT gk
                  FROM utstgk
                  WHERE st = a_old_st
                    AND version = a_old_st_version
                 )
   AND gk NOT IN (SELECT gk
                  FROM utstgk
                  WHERE st = a_oldref_st
                    AND version = a_oldref_st_version
                  INTERSECT
                  SELECT gk
                  FROM utstgk
                  WHERE st = a_newref_st
                    AND version = a_newref_st_version
                 )
   UNION
   --Add all group keys in newref that are already in oldst
   --that have not been updated in oldst
   --and that have not been suppressed
   -- Part3= 1 (NOT IN 2)
   -- 1= all group keys in the newref_st
   -- 2= list of group keys that have been changed between OLD_REF and OLD
   --LOV are compared here
   --subquery is returning any group key where the LOV has been modified
   --subquery returns all group keys for which the list of values has been modified in OLD compared to OLD_REF
   /* 1 */
   SELECT gk, value
   FROM utstgk
   WHERE st = a_newref_st
     AND version = a_newref_st_version
   /* 2 */
    AND gk NOT IN (SELECT DISTINCT gk FROM
                     ((SELECT gk, value
                       FROM utstgk
                       WHERE st = a_old_st
                         AND version = a_old_st_version
                       UNION
                       SELECT gk, value
                       FROM utstgk
                       WHERE st = a_oldref_st
                         AND version = a_oldref_st_version
                       )
                      MINUS
                      (SELECT gk, value
                       FROM utstgk
                       WHERE st = a_old_st
                         AND version = a_old_st_version
                       INTERSECT
                       SELECT gk, value
                       FROM utstgk
                       WHERE st = a_oldref_st
                         AND version = a_oldref_st_version
                      )
                     )
               )
   ORDER BY gk, value;

--utstpp cursors and variables
CURSOR l_stppls_cursor
(a_ignore_pp_version IN CHAR)
IS
SELECT *
FROM utstpp
WHERE st = a_newref_st
  AND version = a_newref_st_version
  AND (st, pp, DECODE(a_ignore_pp_version, '1', '1', pp_version),
       pp_key1, pp_key2, pp_key3, pp_key4, pp_key5) IN
   (SELECT st, pp, DECODE(a_ignore_pp_version, '1', '1', pp_version),
           pp_key1, pp_key2, pp_key3, pp_key4, pp_key5
   FROM utstpp
   WHERE st = a_newref_st
     AND version = a_newref_st_version
   UNION
   (SELECT st, pp, DECODE(a_ignore_pp_version, '1', '1', pp_version),
           pp_key1, pp_key2, pp_key3, pp_key4, pp_key5
    FROM utstpp
    WHERE st = a_old_st
      AND version = a_old_st_version
    MINUS
    SELECT st, pp, DECODE(a_ignore_pp_version, '1', '1', pp_version),
           pp_key1, pp_key2, pp_key3, pp_key4, pp_key5
    FROM utstpp
    WHERE st = a_oldref_st
      AND version = a_oldref_st_version)
   MINUS
   (SELECT st, pp, DECODE(a_ignore_pp_version, '1', '1', pp_version),
           pp_key1, pp_key2, pp_key3, pp_key4, pp_key5
    FROM utstpp
    WHERE st = a_oldref_st
      AND version = a_oldref_st_version
    MINUS
    SELECT st, pp, DECODE(a_ignore_pp_version, '1', '1', pp_version),
           pp_key1, pp_key2, pp_key3, pp_key4, pp_key5
    FROM utstpp
    WHERE st = a_old_st
      AND version = a_old_st_version))
   ORDER BY seq;

--This cursor is searching for the same parameter profile in a sample type
--with the same relative position
--
-- Example: st1 v1.0                  st1 v2.0
--          seq 1 pp1 rel_pos=1       seq 1 pp1 rel_pos=1
--          seq 2 pp2 rel_pos=1       seq 2 pp1 rel_pos=2
--          seq 3 pp1 rel_pos=2
-- The second pp1 parameter prfoile in st1 v1.0 has the same relative position as
-- the second pp1 parameter profile but they have different sequences.
-- This query allows to perform search in function of relative positions
--
-- Note that 2 parameter profiles with different pp_version are considered as different parameter profiles
-- when c_ignore_pp_version = 0, otherwise not.
--
CURSOR l_utstpp_cursor (c_st IN VARCHAR2,
                        c_st_version            IN VARCHAR2,
                        c_pp                    IN VARCHAR2,
                        c_pp_version            IN VARCHAR2,
                        c_pp_key1               IN VARCHAR2,
                        c_pp_key2               IN VARCHAR2,
                        c_pp_key3               IN VARCHAR2,
                        c_pp_key4               IN VARCHAR2,
                        c_pp_key5               IN VARCHAR2,
                        c_seq                   IN NUMBER,
                        c_ignore_pp_version     IN CHAR) IS
SELECT a.*
FROM utstpp a
WHERE (a.st, a.version, a.pp, a.pp_version, a.pp_key1, a.pp_key2, a.pp_key3, a.pp_key4, a.pp_key5, a.seq) IN
(SELECT k.st, k.version, k.pp, k.pp_version, k.pp_key1, k.pp_key2, k.pp_key3, k.pp_key4, k.pp_key5, k.seq
 FROM
    (SELECT ROWNUM relpos, b.st, b.version, b.pp, b.pp_version, b.pp_key1, b.pp_key2, b.pp_key3, b.pp_key4, b.pp_key5, b.seq
    FROM
       (SELECT c.st, c.version, c.pp, c.pp_version, c.pp_key1, c.pp_key2, c.pp_key3, c.pp_key4, c.pp_key5, c.seq
       FROM utstpp c
       WHERE c.st = a_newref_st
       AND c.version = a_newref_st_version
       AND c.pp = c_pp
       AND c.pp_version = DECODE(c_ignore_pp_version, '1', c.pp_version, c_pp_version)
       AND c.pp_key1 = c_pp_key1
       AND c.pp_key2 = c_pp_key2
       AND c.pp_key3 = c_pp_key3
       AND c.pp_key4 = c_pp_key4
       AND c.pp_key5 = c_pp_key5
       GROUP BY c.st, c.version, c.pp, c.pp_version, c.pp_key1, c.pp_key2, c.pp_key3, c.pp_key4, c.pp_key5, c.seq) b) z,
    (SELECT ROWNUM relpos, b.st, b.version, b.pp, b.pp_version, b.pp_key1, b.pp_key2, b.pp_key3, b.pp_key4, b.pp_key5, b.seq
    FROM
       (SELECT c.st, c.version, c.pp, c.pp_version, c.pp_key1, c.pp_key2, c.pp_key3, c.pp_key4, c.pp_key5, c.seq
       FROM utstpp c
       WHERE c.st = c_st
       AND c.version = c_st_version
       AND c.pp = c_pp
       AND c.pp_version = DECODE(c_ignore_pp_version, '1', c.pp_version, c_pp_version)
       AND c.pp_key1 = c_pp_key1
       AND c.pp_key2 = c_pp_key2
       AND c.pp_key3 = c_pp_key3
       AND c.pp_key4 = c_pp_key4
       AND c.pp_key5 = c_pp_key5
       GROUP BY c.st, c.version, c.pp, c.pp_version, c.pp_key1, c.pp_key2, c.pp_key3, c.pp_key4, c.pp_key5, c.seq) b) k
    WHERE k.relpos = z.relpos
    AND z.seq = c_seq)
ORDER BY a.seq;
l_oldref_utstpp_rec   utstpp%ROWTYPE;
l_newref_utstpp_rec   utstpp%ROWTYPE;
l_old_utstpp_rec      utstpp%ROWTYPE;
l_new_utstpp_rec      utstpp%ROWTYPE;

--cursor used to fetch all parameter profiles that have been added manually
--in the old sample type and that must be added by the Compare
--Special rule*: when a parameter profile has been deleted from the reference sample type
--               that parameter profile must be suppressed completely from the sample type
--               Also the records with the same parameter profile but with different pp_keys
--               (except when the reference sample type is already containing that same
--                parameter profile with different pp_keys)
CURSOR l_old_stpp_cursor
(c_ignore_pp_version     IN CHAR)
IS
   SELECT *
   FROM utstpp
   WHERE st = a_old_st
     AND version = a_old_st_version
     AND (st, pp, DECODE(c_ignore_pp_version, '1', '1', pp_version),
          pp_key1, pp_key2, pp_key3, pp_key4, pp_key5) NOT IN
     (SELECT st, pp, DECODE(c_ignore_pp_version, '1', '1', pp_version),
             pp_key1, pp_key2, pp_key3, pp_key4, pp_key5
      FROM utstpp
      WHERE st = a_newref_st
        AND version = a_newref_st_version
      UNION
      SELECT st, pp, DECODE(c_ignore_pp_version, '1', '1', pp_version),
             pp_key1, pp_key2, pp_key3, pp_key4, pp_key5
      FROM utstpp
      WHERE st = a_oldref_st
        AND version = a_oldref_st_version)
     --
     --Special rule* here
     -- pp suppressed in new reference st => suppressed in resulting st
     AND (st, pp, DECODE(c_ignore_pp_version, '1', '1', pp_version),
          pp_key1, pp_key2, pp_key3, pp_key4, pp_key5) NOT IN
     --subquery returning all pp in the old pp that have been suppressed
     (--all pp in old st that have been suppressed
      SELECT st, pp, DECODE(c_ignore_pp_version, '1', '1', pp_version),
             pp_key1, pp_key2, pp_key3, pp_key4, pp_key5
      FROM utstpp
      WHERE st = a_old_st
        AND version = a_old_st_version
        AND (st, pp) IN
            (SELECT st, pp        --subquery returning all suppressed pp (pp_keys ignored here)
             FROM utstpp
             WHERE st = a_oldref_st
               AND version = a_oldref_st_version
             MINUS
             SELECT st, pp
             FROM utstpp
             WHERE st = a_newref_st
               AND version = a_newref_st_version)
      MINUS
      SELECT st, pp, DECODE(c_ignore_pp_version, '1', '1', pp_version),
             pp_key1, pp_key2, pp_key3, pp_key4, pp_key5
      FROM utstpp
      WHERE st = a_newref_st
        AND version = a_newref_st_version);

CURSOR l_new_stppseq IS
    SELECT NVL(MAX(seq), 0) +1
    FROM utstpp
    WHERE st = a_new_st
        AND version = a_new_st_version;

--utstppau cursors and variables
--assumptions: au_version always ignored, pp_version ignored since 2 pp with diferent pp_version may not have different attributes
CURSOR l_new_utstppau_cursor IS
   --all attributes in oldst
   --and that have not been suppressed in newref
   -- Part1= 1 (NOT IN 2) AND IN 3 AND IN 4 AND (NOT IN 5)
   -- 1= all attributes in the old_st
   -- old_st has some differences with oldref, these modifications must be kept
   -- the subqueries are returning these differences
   -- 2= list of attributes that have been suppressed from oldref to make the final old_st
   -- 3= list of parameter profiles that have been suppressed from oldref to make the final old_st
   -- 4= list of attribute values that have not been modified between OLD_REF and OLD (values will be taken from NEW when applicable)
   -- 5= See special rule* in utstpp cusror
   --
   /* 1 */
   SELECT pp, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5, au, value
     FROM utstppau
    WHERE st = a_old_st
      AND version = a_old_st_version
    /* 2 */
    AND (pp, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5, au)
       NOT IN (SELECT pp, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5, au
               FROM utstppau
               WHERE st = a_old_st
                 AND version = a_old_st_version
               INTERSECT
                 (SELECT pp, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5, au
                  FROM utstppau
                  WHERE st = a_oldref_st
                    AND version = a_oldref_st_version
                  MINUS
                  SELECT pp, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5, au
                  FROM utstppau
                  WHERE st = a_newref_st
                    AND version = a_newref_st_version
                 )
              )
    /* 3 */
    AND (pp, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5)
          NOT IN (SELECT pp, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5
                  FROM utstpp
                  WHERE st = a_old_st
                    AND version = a_old_st_version
                  INTERSECT
                    (SELECT pp, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5
                     FROM utstpp
                     WHERE st = a_oldref_st
                       AND version = a_oldref_st_version
                     MINUS
                     SELECT pp, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5
                     FROM utstpp
                     WHERE st = a_newref_st
                       AND version = a_newref_st_version))
    /* 4 */
    --test might seem strange but is also good for single valued attributes
    --The attribute values are not compared one by one but the list of values are compared
    --LOV are compared here
    --subquery is returning any attribute where the LOV has been modified
    --test is inverted here (would result in two times NOT IN)
    --subquery returns all attributes for which the list of values has been modified in OLD compared to OLD_REF
    AND (pp, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5, au) IN
                 (SELECT DISTINCT pp, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5, au FROM
                     ((SELECT pp, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5, au, value
                       FROM utstppau
                       WHERE st = a_old_st
                         AND version = a_old_st_version
                       UNION
                       SELECT pp, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5, au, value
                       FROM utstppau
                       WHERE st = a_oldref_st
                         AND version = a_oldref_st_version
                      )
                      MINUS
                      (SELECT pp, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5, au, value
                       FROM utstppau
                       WHERE st = a_old_st
                         AND version = a_old_st_version
                       INTERSECT
                       SELECT pp, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5, au, value
                       FROM utstppau
                       WHERE st = a_oldref_st
                         AND version = a_oldref_st_version
                      )
                     )
                 )
     --
     /* 5 */
     --Special rule* here
     -- pp suppressed in new reference st => suppressed in resulting st
     AND (st, pp, pp_version, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5) NOT IN
        --subquery returning all pp in the old pp that have been suppressed
        (--all pp in old st that have been suppressed
         SELECT st, pp, pp_version, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5
         FROM utstpp
         WHERE st = a_old_st
           AND version = a_old_st_version
           AND (st, pp) IN
               (SELECT st, pp        --subquery returning all suppressed pp (pp_keys ignored here)
                FROM utstpp
                WHERE st = a_oldref_st
                  AND version = a_oldref_st_version
                MINUS
                SELECT st, pp
                FROM utstpp
                WHERE st = a_newref_st
                  AND version = a_newref_st_version)
         MINUS
         SELECT st, pp, pp_version, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5
         FROM utstpp
         WHERE st = a_newref_st
           AND version = a_newref_st_version
        )
   UNION
   --all attributes in newref that are not already in oldst
   --and that have not been suppressed
   -- Part2= 1 (NOT IN 2) AND (NOT IN 3)
   -- 1= all attributes in the newref_st
   -- newref_st has some differences with oldref, these modifications must be kept
   -- the subqueries are returning these differences
   -- 2= list of attributes that are already in old_st or that have been suppressed from oldref to make the final old_st
   -- 3= list of parameter profiles deleted from oldref to make old_st
   /* 1 */
   SELECT pp, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5, au, value
   FROM utstppau
   WHERE st = a_newref_st
     AND version = a_newref_st_version
   /* 2 */
   AND (pp, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5, au)
        NOT IN (SELECT pp, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5, au
                FROM utstppau
                WHERE st = a_old_st
                  AND version = a_old_st_version
               )
   AND (pp, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5, au)
        NOT IN (SELECT pp, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5, au
                FROM utstppau
                WHERE st = a_oldref_st
                  AND version = a_oldref_st_version
                MINUS
                SELECT pp, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5, au
                FROM utstppau
                WHERE st = a_old_st
                AND version = a_old_st_version
               )
   /* 3 */
   AND (pp, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5)
        NOT IN (SELECT pp, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5
                  FROM utstpp
                 WHERE st = a_oldref_st
                   AND version = a_oldref_st_version
                MINUS
                SELECT pp, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5
                FROM utstpp
                WHERE st = a_old_st
                  AND version = a_old_st_version)
   UNION
   --Add all attributes in newref that are already in oldst
   --that have not been updated in oldst
   --and that have not been suppressed
   -- Part3= 1 (NOT IN 2) AND (NOT IN 3)
   -- 1= all attributes in the newref_st
   -- 2= list of attributes that have been changed between OLD_REF and OLD
   -- 3= list of suppressed parameter profiles
   --LOV are compared here
   --subquery is returning any attribute where the LOV has been modified
   --subquery returns all attributes for which the list of values has been modified in OLD compared to OLD_REF
   /* 1 */
   SELECT pp, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5, au, value
   FROM utstppau
   WHERE st = a_newref_st
     AND version = a_newref_st_version
   /* 2 */
   AND (pp, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5, au)
        NOT IN (SELECT DISTINCT pp, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5, au FROM
                     ((SELECT pp, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5, au, value
                       FROM utstppau
                       WHERE st = a_old_st
                         AND version = a_old_st_version
                       UNION
                       SELECT pp, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5, au, value
                       FROM utstppau
                       WHERE st = a_oldref_st
                         AND version = a_oldref_st_version
                      )
                     MINUS
                     (SELECT pp, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5, au, value
                       FROM utstppau
                       WHERE st = a_old_st
                         AND version = a_old_st_version
                       INTERSECT
                       SELECT pp, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5, au, value
                       FROM utstppau
                       WHERE st = a_oldref_st
                         AND version = a_oldref_st_version
                      )
                     )
               )
   /* 3 */
   AND (pp, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5)
        NOT IN (SELECT pp, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5
                  FROM utstpp
                 WHERE st = a_oldref_st
                   AND version = a_oldref_st_version
                MINUS
                SELECT pp, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5
                FROM utstpp
                WHERE st = a_old_st
                  AND version = a_old_st_version)
   ORDER BY pp, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5, au, value;

CURSOR l_reorder_follow_old_cursor (c_max_seq IN NUMBER) IS
SELECT pp||pp_key1||pp_key2||pp_key3||pp_key4||pp_key5 pp_partial_key, seq, '1' from_old
FROM utstpp
WHERE st = a_old_st
  AND version = a_old_st_version
UNION ALL --(ALL is important for duplos)
SELECT zzz.pp_partial_key, NVL(before_seq_in_old-0.5 , NVL(after_seq_in_old+0.5, c_max_seq+seq)) seq, '2' from_old
FROM
(
SELECT DISTINCT x.pp||x.pp_key1||x.pp_key2||x.pp_key3||x.pp_key4||x.pp_key5 pp_partial_key, x.seq,
FIRST_VALUE(z.seq_in_old) OVER
   (PARTITION BY x.pp||x.pp_key1||x.pp_key2||x.pp_key3||x.pp_key4||x.pp_key5, x.seq ORDER BY  x.seq ASC, z.seq_in_newref ASC nulls last ) before_seq_in_old,
--FIRST_VALUE(z.seq_in_newref) OVER
--   (PARTITION BY x.pp||x.pp_key1||x.pp_key2||x.pp_key3||x.pp_key4||x.pp_key5, x.seq ORDER BY  x.seq ASC, z.seq_in_newref ASC nulls last ) before_seq_in_newref,
--FIRST_VALUE(z.pr) OVER
--   (PARTITION BY x.pp||x.pp_key1||x.pp_key2||x.pp_key3||x.pp_key4||x.pp_key5, x.seq ORDER BY  x.seq ASC, z.seq_in_newref ASC nulls last ) before_pr,
FIRST_VALUE(y.seq_in_old) OVER
   (PARTITION BY x.pp||x.pp_key1||x.pp_key2||x.pp_key3||x.pp_key4||x.pp_key5, x.seq ORDER BY  x.seq ASC, y.seq_in_newref DESC nulls last ) after_seq_in_old --,
--FIRST_VALUE(y.seq_in_newref) OVER
--   (PARTITION BY x.pp||x.pp_key1||x.pp_key2||x.pp_key3||x.pp_key4||x.pp_key5, x.seq ORDER BY  x.seq ASC, y.seq_in_newref DESC nulls last ) after_seq_in_newref,
--FIRST_VALUE(y.pr) OVER
--   (PARTITION BY x.pp||x.pp_key1||x.pp_key2||x.pp_key3||x.pp_key4||x.pp_key5, x.seq ORDER BY  x.seq ASC, y.seq_in_newref DESC nulls last ) after_pr
FROM
    (--list of pp, seq existing in old_st and in newref_st and their seq
     SELECT a.pp||a.pp_key1||a.pp_key2||a.pp_key3||a.pp_key4||a.pp_key5 pp_partial_key, MIN(a.seq) seq_in_old, MIN(b.seq) seq_in_newref
     FROM utstpp a, utstpp b
     WHERE a.st = a_old_st
       AND a.version = a_old_st_version
       AND b.st = a_newref_st
       AND b.version = a_newref_st_version
       AND a.pp||a.pp_key1||a.pp_key2||a.pp_key3||a.pp_key4||a.pp_key5 = b.pp||b.pp_key1||b.pp_key2||b.pp_key3||b.pp_key4||b.pp_key5
     GROUP BY a.pp||a.pp_key1||a.pp_key2||a.pp_key3||a.pp_key4||a.pp_key5) z,
    (--list of pp, seq existing in old_st and in newref_st and their seq
     SELECT a.pp||a.pp_key1||a.pp_key2||a.pp_key3||a.pp_key4||a.pp_key5 pp_partial_key, MIN(a.seq) seq_in_old, MIN(b.seq) seq_in_newref
     FROM utstpp a, utstpp b
     WHERE a.st = a_old_st
       AND a.version = a_old_st_version
       AND b.st = a_newref_st
       AND b.version = a_newref_st_version
       AND a.pp||a.pp_key1||a.pp_key2||a.pp_key3||a.pp_key4||a.pp_key5 = b.pp||b.pp_key1||b.pp_key2||b.pp_key3||b.pp_key4||b.pp_key5
     GROUP BY a.pp||a.pp_key1||a.pp_key2||a.pp_key3||a.pp_key4||a.pp_key5) y,
    utstpp x
 WHERE x.st = a_newref_st
   AND x.version = a_newref_st_version
   AND x.seq < z.seq_in_newref (+)
   AND x.seq > y.seq_in_newref (+)
   AND x.pp||x.pp_key1||x.pp_key2||x.pp_key3||x.pp_key4||x.pp_key5
            NOT IN (SELECT j.pp||j.pp_key1||j.pp_key2||j.pp_key3||j.pp_key4||j.pp_key5
                    FROM utstpp j
                    WHERE j.st = a_newref_st
                      AND j.version = a_newref_st_version
                    INTERSECT
                    SELECT k.pp||k.pp_key1||k.pp_key2||k.pp_key3||k.pp_key4||k.pp_key5
                    FROM utstpp k
                    WHERE k.st = a_old_st
                      AND k.version = a_old_st_version)
 ORDER BY  x.seq, x.pp||x.pp_key1||x.pp_key2||x.pp_key3||x.pp_key4||x.pp_key5
) zzz
ORDER BY seq, from_old, pp_partial_key;

CURSOR l_reorder_follow_newref_cursor (c_max_seq IN NUMBER) IS
SELECT pp||pp_key1||pp_key2||pp_key3||pp_key4||pp_key5 pp_partial_key, seq,
      '1' from_newref
FROM utstpp
WHERE st = a_newref_st
  AND version = a_newref_st_version
UNION ALL --(ALL is important for duplos)
SELECT zzz.pp_partial_key, NVL(before_seq_in_newref-0.5 , NVL(after_seq_in_newref+0.5, c_max_seq+seq)) seq,
       '2' from_newref
FROM
(
SELECT DISTINCT x.pp||x.pp_key1||x.pp_key2||x.pp_key3||x.pp_key4||x.pp_key5 pp_partial_key, x.seq,
--FIRST_VALUE(z.seq_in_old) OVER
--   (PARTITION BY x.pr, x.seq ORDER BY  x.seq ASC, z.seq_in_newref ASC nulls last ) before_seq_in_old,
FIRST_VALUE(z.seq_in_newref) OVER
   (PARTITION BY x.pp||x.pp_key1||x.pp_key2||x.pp_key3||x.pp_key4||x.pp_key5, x.seq ORDER BY  x.seq ASC, z.seq_in_newref ASC nulls last ) before_seq_in_newref,
--FIRST_VALUE(z.pr) OVER
--   (PARTITION BY x.pp||x.pp_key1||x.pp_key2||x.pp_key3||x.pp_key4||x.pp_key5 pp_partial_key, x.seq ORDER BY  x.seq ASC, z.seq_in_newref ASC nulls last ) before_pr,
--FIRST_VALUE(y.seq_in_old) OVER
--   (PARTITION BY x.pp||x.pp_key1||x.pp_key2||x.pp_key3||x.pp_key4||x.pp_key5 pp_partial_key, x.seq ORDER BY  x.seq ASC, y.seq_in_newref DESC nulls last ) after_seq_in_old,
FIRST_VALUE(y.seq_in_newref) OVER
   (PARTITION BY x.pp||x.pp_key1||x.pp_key2||x.pp_key3||x.pp_key4||x.pp_key5, x.seq ORDER BY  x.seq ASC, y.seq_in_newref DESC nulls last ) after_seq_in_newref --,
--FIRST_VALUE(y.pr) OVER
--   (PARTITION BY x.pp||x.pp_key1||x.pp_key2||x.pp_key3||x.pp_key4||x.pp_key5 pp_partial_key, x.seq ORDER BY  x.seq ASC, y.seq_in_newref DESC nulls last ) after_pr
FROM
    (--list of pp, seq existing in old_st and in newref_st and their seq
     SELECT a.pp||a.pp_key1||a.pp_key2||a.pp_key3||a.pp_key4||a.pp_key5 pp_partial_key, MIN(a.seq) seq_in_old, MIN(b.seq) seq_in_newref
     FROM utstpp a, utstpp b
     WHERE a.st = a_old_st
       AND a.version = a_old_st_version
       AND b.st = a_newref_st
       AND b.version = a_newref_st_version
       AND a.pp||a.pp_key1||a.pp_key2||a.pp_key3||a.pp_key4||a.pp_key5 = b.pp||b.pp_key1||b.pp_key2||b.pp_key3||b.pp_key4||b.pp_key5
     GROUP BY a.pp||a.pp_key1||a.pp_key2||a.pp_key3||a.pp_key4||a.pp_key5) z,
    (--list of pp, seq existing in old_st and in newref_st and their seq
     SELECT a.pp||a.pp_key1||a.pp_key2||a.pp_key3||a.pp_key4||a.pp_key5 pp_partial_key, MIN(a.seq) seq_in_old, MIN(b.seq) seq_in_newref
     FROM utstpp a, utstpp b
     WHERE a.st = a_old_st
       AND a.version = a_old_st_version
       AND b.st = a_newref_st
       AND b.version = a_newref_st_version
       AND a.pp||a.pp_key1||a.pp_key2||a.pp_key3||a.pp_key4||a.pp_key5 = b.pp||b.pp_key1||b.pp_key2||b.pp_key3||b.pp_key4||b.pp_key5
     GROUP BY a.pp||a.pp_key1||a.pp_key2||a.pp_key3||a.pp_key4||a.pp_key5) y,
    utstpp x
 WHERE x.st = a_old_st
   AND x.version = a_old_st_version
   AND x.seq < z.seq_in_old (+)
   AND x.seq > y.seq_in_old (+)
   AND x.pp||x.pp_key1||x.pp_key2||x.pp_key3||x.pp_key4||x.pp_key5
            NOT IN (SELECT j.pp||j.pp_key1||j.pp_key2||j.pp_key3||j.pp_key4||j.pp_key5
                    FROM utstpp j
                    WHERE j.st = a_newref_st
                      AND j.version = a_newref_st_version
                    INTERSECT
                    SELECT k.pp||k.pp_key1||k.pp_key2||k.pp_key3||k.pp_key4||k.pp_key5
                    FROM utstpp k
                    WHERE k.st = a_old_st
                      AND k.version = a_old_st_version)
 ORDER BY  x.seq, x.pp||x.pp_key1||x.pp_key2||x.pp_key3||x.pp_key4||x.pp_key5
) zzz
ORDER BY seq, from_newref, pp_partial_key;

CURSOR l_reorder_corr_stppseq_cursor  IS
SELECT a.pp, a.seq, a.rowid
FROM utstpp a
WHERE a.st = a_new_st
  AND a.version = a_new_st_version
  AND a.seq < 0
  ORDER BY a.seq
FOR UPDATE;

CURSOR l_order_nogaps_stppseq_cursor IS
SELECT a.pp, a.seq
FROM utstpp a
WHERE a.st = a_new_st
  AND a.version = a_new_st_version
  ORDER BY a.seq
FOR UPDATE;

--utstip cursors and variables
CURSOR l_stipls_cursor IS
SELECT *
FROM utstip
WHERE st = a_newref_st
  AND version = a_newref_st_version
  AND (st, ip, ip_version) IN
   (SELECT st, ip, ip_version
   FROM utstip
   WHERE st = a_newref_st
     AND version = a_newref_st_version
   UNION
   (SELECT st, ip, ip_version
    FROM utstip
    WHERE st = a_old_st
      AND version = a_old_st_version
    MINUS
    SELECT st, ip, ip_version
    FROM utstip
    WHERE st = a_oldref_st
      AND version = a_oldref_st_version)
   MINUS
   (SELECT st, ip, ip_version
    FROM utstip
    WHERE st = a_oldref_st
      AND version = a_oldref_st_version
    MINUS
    SELECT st, ip, ip_version
    FROM utstip
    WHERE st = a_old_st
      AND version = a_old_st_version))
   ORDER BY seq;

--This cursor is searching for the same info profile in a sample type
--with the same relative position
--
-- Example: st1 v1.0                  st1 v2.0
--          seq 1 ip1 rel_pos=1       seq 1 ip1 rel_pos=1
--          seq 2 ip2 rel_pos=1       seq 2 ip1 rel_pos=2
--          seq 3 ip1 rel_pos=2
-- The second ip1 in st1 v1.0 has the same relative position as
-- the second ip1 but they have different sequences.
-- This query allows to perform search in function of relative positions
--
-- Note that 2 parameters with different ip_version are considered as different parameters
--
CURSOR l_utstip_cursor (c_st         IN VARCHAR2,
                        c_st_version IN VARCHAR2,
                        c_ip         IN VARCHAR2,
                        c_ip_version IN VARCHAR2,
                        c_seq        IN NUMBER) IS
SELECT a.*
FROM utstip a
WHERE (a.st, a.version, a.ip, a.ip_version, a.seq) IN
(SELECT k.st, k.version, k.ip, k.ip_version, k.seq
 FROM
    (SELECT ROWNUM relpos, b.st, b.version, b.ip, b.ip_version, b.seq
    FROM
       (SELECT c.st, c.version, c.ip, c.ip_version, c.seq
       FROM utstip c
       WHERE c.st = a_newref_st
       AND c.version = a_newref_st_version
       AND c.ip = c_ip
       AND c.ip_version = c_ip_version
       GROUP BY c.st, c.version, c.ip, c.ip_version, c.seq) b) z,
    (SELECT ROWNUM relpos, b.st, b.version, b.ip, b.ip_version, b.seq
    FROM
       (SELECT c.st, c.version, c.ip, c.ip_version, c.seq
       FROM utstip c
       WHERE c.st = c_st
       AND c.version = c_st_version
       AND c.ip = c_ip
       AND c.ip_version = c_ip_version
       GROUP BY c.st, c.version, c.ip, c.ip_version, c.seq) b) k
    WHERE k.relpos = z.relpos
    AND z.seq = c_seq)
ORDER BY a.seq;
l_oldref_utstip_rec   utstip%ROWTYPE;
l_newref_utstip_rec   utstip%ROWTYPE;
l_old_utstip_rec      utstip%ROWTYPE;
l_new_utstip_rec      utstip%ROWTYPE;

CURSOR l_old_stip_cursor IS
   SELECT *
   FROM utstip
   WHERE st = a_old_st
     AND version = a_old_st_version
     AND (st, ip, ip_version) NOT IN
     (SELECT st, ip, ip_version
      FROM utstip
      WHERE st = a_newref_st
        AND version = a_newref_st_version
      UNION
      SELECT st, ip, ip_version
      FROM utstip
      WHERE st = a_oldref_st
        AND version = a_oldref_st_version);

--utstipau cursors and variables
--assumptions: au_version always ignored, ip_version ignored since 2 ip with diferent ip_version may not have different attributes
CURSOR l_new_utstipau_cursor IS
   --all attributes in oldst
   --and that have not been suppressed in newref
   -- Part1= 1 (NOT IN 2) AND IN 3
   -- 1= all attributes in the old_st
   -- old_st has some differences with oldref, these modifications must be kept
   -- the subqueries are returning these differences
   -- 2= list of attributes that have been suppressed from oldref to make the final old_st
   -- 3= list of info profiles that have been suppressed from oldref to make the final old_st
   -- 4= list of attribute values that have not been modified between OLD_REF and OLD (values will be taken from NEW when applicable)
   --
   /* 1 */
   SELECT ip, au, value
     FROM utstipau
    WHERE st = a_old_st
      AND version = a_old_st_version
    /* 2 */
    AND (ip, au)
         NOT IN (SELECT ip, au
                 FROM utstipau
                 WHERE st = a_old_st
                   AND version = a_old_st_version
                 INTERSECT
                   (SELECT ip, au
                    FROM utstipau
                    WHERE st = a_oldref_st
                      AND version = a_oldref_st_version
                    MINUS
                    SELECT ip, au
                    FROM utstipau
                    WHERE st = a_newref_st
                      AND version = a_newref_st_version
                   )
                )
    AND ip
         NOT IN (SELECT ip
                 FROM utstip
                 WHERE st = a_old_st
                   AND version = a_old_st_version
                 INTERSECT
                   (SELECT ip
                    FROM utstip
                    WHERE st = a_oldref_st
                      AND version = a_oldref_st_version
                    MINUS
                    SELECT ip
                    FROM utstip
                    WHERE st = a_newref_st
                      AND version = a_newref_st_version
                   )
                )
    /* 4 */
    --test might seem strange but is also good for single valued attributes
    --The attribute values are not compared one by one but the list of values are compared
    --LOV are compared here
    --subquery is returning any attribute where the LOV has been modified
    --test is inverted here (would result in two times NOT IN)
    --subquery returns all attributes for which the list of values has been modified in OLD compared to OLD_REF
    AND (ip, au) IN
                 (SELECT DISTINCT ip,  au FROM
                     ((SELECT ip, au, value
                       FROM utstipau
                       WHERE st = a_old_st
                         AND version = a_old_st_version
                       UNION
                       SELECT ip, au, value
                       FROM utstipau
                       WHERE st = a_oldref_st
                         AND version = a_oldref_st_version
                       )
                      MINUS
                      (SELECT ip, au, value
                       FROM utstipau
                       WHERE st = a_old_st
                         AND version = a_old_st_version
                       INTERSECT
                       SELECT ip, au, value
                       FROM utstipau
                       WHERE st = a_oldref_st
                         AND version = a_oldref_st_version
                      )
                     )
                 )
   UNION
   --all attributes in newref that are not already in oldst
   --and that have not been suppressed
   -- Part2= 1 (NOT IN 2) AND (NOT IN 3)
   -- 1= all attributes in the newref_st
   -- newref_st has some differences with oldref, these modifications must be kept
   -- the subqueries are returning these differences
   -- 2= list of attributes that are already in old_st or that have been suppressed from oldref to make the final old_st
   -- 3= list of parameter profiles deleted from oldref to make old_st
   /* 1 */
   SELECT ip, au, value
   FROM utstipau
   WHERE st = a_newref_st
     AND version = a_newref_st_version
   /* 2 */
   AND (ip, au) NOT IN
                 (SELECT ip, au
                  FROM utstipau
                  WHERE st = a_old_st
                    AND version = a_old_st_version
                 )
   AND (ip, au) NOT IN
                 (SELECT ip, au
                  FROM utstipau
                  WHERE st = a_oldref_st
                    AND version = a_oldref_st_version
                  MINUS
                  SELECT ip, au
                  FROM utstipau
                  WHERE st = a_old_st
                    AND version = a_old_st_version
                 )
   /* 3 */
   AND (ip)
        NOT IN (SELECT ip
                  FROM utstip
                 WHERE st = a_oldref_st
                   AND version = a_oldref_st_version
                MINUS
                SELECT ip
                FROM utstip
                WHERE st = a_old_st
                  AND version = a_old_st_version)
   UNION
   --Add all attributes in newref that are already in oldss
   --that have not been updated in oldst
   --and that have not been suppressed
   -- Part3= 1 (NOT IN 2) AND (NOT IN 3)
   -- 1= all attributes in the newref_st
   -- 2= list of attributes that have been changed between OLD_REF and OLD
   -- 3 = list of suppressed info profiles
   --LOV are compared here
   --subquery is returning any attribute where the LOV has been modified
   --subquery returns all attributes for which the list of values has been modified in OLD compared to OLD_REF
   /* 1 */
   SELECT ip, au, value
   FROM utstipau
   WHERE st = a_newref_st
     AND version = a_newref_st_version
   /* 2 */
   AND (ip, au)
        NOT IN (SELECT DISTINCT ip, au FROM
                     ((SELECT ip, au, value
                       FROM utstipau
                       WHERE st = a_old_st
                         AND version = a_old_st_version
                       UNION
                       SELECT ip, au, value
                       FROM utstipau
                       WHERE st = a_oldref_st
                         AND version = a_oldref_st_version
                      )
                     MINUS
                     (SELECT ip, au, value
                       FROM utstipau
                       WHERE st = a_old_st
                         AND version = a_old_st_version
                       INTERSECT
                       SELECT ip, au, value
                       FROM utstipau
                       WHERE st = a_oldref_st
                         AND version = a_oldref_st_version
                      )
                     )
               )
   /* 3 */
   AND (ip)
        NOT IN (SELECT ip
                  FROM utstip
                 WHERE st = a_oldref_st
                   AND version = a_oldref_st_version
                MINUS
                SELECT ip
                FROM utstip
                WHERE st = a_old_st
                  AND version = a_old_st_version)
ORDER BY ip, au, value;

CURSOR l_new_stipseq IS
    SELECT NVL(MAX(seq), 0) +1
    FROM utstip
    WHERE st = a_new_st
        AND version = a_new_st_version;

TABLE_DOES_NOT_EXIST EXCEPTION;
PRAGMA EXCEPTION_INIT (TABLE_DOES_NOT_EXIST, -942);

/*
RS20110303 : START OF CHANGE VREDESTEIN
uncomment to force a statuschange to @A
*/
   -- Local variables for 'InsertEvent' API
   l_api_name                    VARCHAR2(40);
   l_evmgr_name                  VARCHAR2(20);
   l_object_tp                   VARCHAR2(4);
   l_object_id                   VARCHAR2(20);
   l_object_lc                   VARCHAR2(2);
   l_object_lc_version           VARCHAR2(20);
   l_object_ss                   VARCHAR2(2);
   l_ev_tp                       VARCHAR2(60);
   l_ev_details                  VARCHAR2(255);
   l_seq_nr                      NUMBER;

   -- Cursor to check if the given sampletype is a generic sampletype
   CURSOR l_generic_cursor(c_st IN VARCHAR2, c_version IN VARCHAR) IS
      SELECT COUNT(stgk.st)
        FROM utstgk stgk, utsystem
       WHERE stgk.st      = c_st
         AND stgk.version = c_version
         AND stgk.value   = 'Yes'
         AND stgk.gk      = utsystem.setting_value
         AND utsystem.setting_name = 'STGK ID Generic St';
   l_count    NUMBER;
/*
RS20110303 : END OF CHANGE VREDESTEIN
*/

BEGIN

   l_some_pp_appended_in_oldst:=FALSE;
     l_sqlerrm := NULL;
   IF UNAPIGEN.BeginTxn(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE StpError;
   END IF;

   /*-------------------*/
   /* Compare utst      */
   /*-------------------*/
   --fetch 3 utst records
   OPEN l_utst_cursor(a_oldref_st, a_oldref_st_version);
   FETCH l_utst_cursor
   INTO l_oldref_utst_rec;
   IF l_utst_cursor%NOTFOUND THEN
      CLOSE l_utst_cursor;
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      RAISE STpError;
   END IF;
   CLOSE l_utst_cursor;

   OPEN l_utst_cursor(a_newref_st, a_newref_st_version);
   FETCH l_utst_cursor
   INTO l_newref_utst_rec;
   IF l_utst_cursor%NOTFOUND THEN
      CLOSE l_utst_cursor;
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      RAISE STpError;
   END IF;
   CLOSE l_utst_cursor;

   OPEN l_utst_cursor(a_old_st, a_old_st_version);
   FETCH l_utst_cursor
   INTO l_old_utst_rec;
   IF l_utst_cursor%NOTFOUND THEN
      CLOSE l_utst_cursor;
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      RAISE STpError;
   END IF;
   CLOSE l_utst_cursor;

   OPEN l_utst_cursor(a_new_st, a_new_st_version);
   FETCH l_utst_cursor
   INTO l_new_utst_rec;
   IF l_utst_cursor%FOUND THEN
      CLOSE l_utst_cursor;
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_ALREADYEXISTS;
      RAISE STpError;
   END IF;
   CLOSE l_utst_cursor;

   --compare
   --columns not compared: st, version, ss, allow_modify, active, ar[1-128],
   --                      effective_from, version_is_current, effective_till
   -- last_sched, last_val, last_cnt left NULL
   l_new_utst_rec := l_newref_utst_rec;
   IF NVL((l_old_utst_rec.description <> l_oldref_utst_rec.description), TRUE) AND NOT(l_old_utst_rec.description IS NULL AND l_oldref_utst_rec.description IS NULL)  THEN
     l_new_utst_rec.description := l_old_utst_rec.description;
   END IF;
   IF NVL((l_old_utst_rec.description2 <> l_oldref_utst_rec.description2), TRUE) AND NOT(l_old_utst_rec.description2 IS NULL AND l_oldref_utst_rec.description2 IS NULL)  THEN
     l_new_utst_rec.description2 := l_old_utst_rec.description2;
   END IF;
   IF NVL((l_old_utst_rec.is_template <> l_oldref_utst_rec.is_template), TRUE) AND NOT(l_old_utst_rec.is_template IS NULL AND l_oldref_utst_rec.is_template IS NULL)  THEN
     l_new_utst_rec.is_template := l_old_utst_rec.is_template;
   END IF;
   IF NVL((l_old_utst_rec.confirm_userid <> l_oldref_utst_rec.confirm_userid), TRUE) AND NOT(l_old_utst_rec.confirm_userid IS NULL AND l_oldref_utst_rec.confirm_userid IS NULL)  THEN
     l_new_utst_rec.confirm_userid := l_old_utst_rec.confirm_userid;
   END IF;
   IF NVL((l_old_utst_rec.shelf_life_val <> l_oldref_utst_rec.shelf_life_val), TRUE) AND NOT(l_old_utst_rec.shelf_life_val IS NULL AND l_oldref_utst_rec.shelf_life_val IS NULL)  THEN
     l_new_utst_rec.shelf_life_val := l_old_utst_rec.shelf_life_val;
   END IF;
   IF NVL((l_old_utst_rec.shelf_life_unit <> l_oldref_utst_rec.shelf_life_unit), TRUE) AND NOT(l_old_utst_rec.shelf_life_unit IS NULL AND l_oldref_utst_rec.shelf_life_unit IS NULL)  THEN
     l_new_utst_rec.shelf_life_unit := l_old_utst_rec.shelf_life_unit;
   END IF;
   IF NVL((l_old_utst_rec.nr_planned_sc <> l_oldref_utst_rec.nr_planned_sc), TRUE) AND NOT(l_old_utst_rec.nr_planned_sc IS NULL AND l_oldref_utst_rec.nr_planned_sc IS NULL)  THEN
     l_new_utst_rec.nr_planned_sc := l_old_utst_rec.nr_planned_sc;
   END IF;
   IF NVL((l_old_utst_rec.freq_tp <> l_oldref_utst_rec.freq_tp), TRUE) AND NOT(l_old_utst_rec.freq_tp IS NULL AND l_oldref_utst_rec.freq_tp IS NULL)  THEN
     l_new_utst_rec.freq_tp := l_old_utst_rec.freq_tp;
   END IF;
   IF NVL((l_old_utst_rec.freq_val <> l_oldref_utst_rec.freq_val), TRUE) AND NOT(l_old_utst_rec.freq_val IS NULL AND l_oldref_utst_rec.freq_val IS NULL)  THEN
     l_new_utst_rec.freq_val := l_old_utst_rec.freq_val;
   END IF;
   IF NVL((l_old_utst_rec.freq_unit <> l_oldref_utst_rec.freq_unit), TRUE) AND NOT(l_old_utst_rec.freq_unit IS NULL AND l_oldref_utst_rec.freq_unit IS NULL)  THEN
     l_new_utst_rec.freq_unit := l_old_utst_rec.freq_unit;
   END IF;
   IF NVL((l_old_utst_rec.invert_freq <> l_oldref_utst_rec.invert_freq), TRUE) AND NOT(l_old_utst_rec.invert_freq IS NULL AND l_oldref_utst_rec.invert_freq IS NULL)  THEN
     l_new_utst_rec.invert_freq := l_old_utst_rec.invert_freq;
   END IF;
   --IF NVL((l_old_utst_rec.last_sched <> l_oldref_utst_rec.last_sched), TRUE) AND NOT(l_old_utst_rec.last_sched IS NULL AND l_oldref_utst_rec.last_sched IS NULL)  THEN
   --  l_new_utst_rec.last_sched := l_old_utst_rec.last_sched;
   --END IF;
   l_new_utst_rec.last_sched := NULL;
   --IF NVL((l_old_utst_rec.last_cnt <> l_oldref_utst_rec.last_cnt), TRUE) AND NOT(l_old_utst_rec.last_cnt IS NULL AND l_oldref_utst_rec.last_cnt IS NULL)  THEN
   --  l_new_utst_rec.last_cnt := l_old_utst_rec.last_cnt;
   --END IF;
   l_new_utst_rec.last_cnt := 0;
   --IF NVL((l_old_utst_rec.last_val <> l_oldref_utst_rec.last_val), TRUE) AND NOT(l_old_utst_rec.last_val IS NULL AND l_oldref_utst_rec.last_val IS NULL)  THEN
   --  l_new_utst_rec.last_val := l_old_utst_rec.last_val;
   --END IF;
   l_new_utst_rec.last_val := NULL;
   IF NVL((l_old_utst_rec.priority <> l_oldref_utst_rec.priority), TRUE) AND NOT(l_old_utst_rec.priority IS NULL AND l_oldref_utst_rec.priority IS NULL)  THEN
     l_new_utst_rec.priority := l_old_utst_rec.priority;
   END IF;
   IF NVL((l_old_utst_rec.label_format <> l_oldref_utst_rec.label_format), TRUE) AND NOT(l_old_utst_rec.label_format IS NULL AND l_oldref_utst_rec.label_format IS NULL)  THEN
     l_new_utst_rec.label_format := l_old_utst_rec.label_format;
   END IF;
   IF NVL((l_old_utst_rec.descr_doc <> l_oldref_utst_rec.descr_doc), TRUE) AND NOT(l_old_utst_rec.descr_doc IS NULL AND l_oldref_utst_rec.descr_doc IS NULL)  THEN
     l_new_utst_rec.descr_doc := l_old_utst_rec.descr_doc;
   END IF;
   IF NVL((l_old_utst_rec.descr_doc_version <> l_oldref_utst_rec.descr_doc_version), TRUE) AND NOT(l_old_utst_rec.descr_doc_version IS NULL AND l_oldref_utst_rec.descr_doc_version IS NULL)  THEN
     l_new_utst_rec.descr_doc_version := l_old_utst_rec.descr_doc_version;
   END IF;
   IF NVL((l_old_utst_rec.allow_any_pp <> l_oldref_utst_rec.allow_any_pp), TRUE) AND NOT(l_old_utst_rec.allow_any_pp IS NULL AND l_oldref_utst_rec.allow_any_pp IS NULL)  THEN
     l_new_utst_rec.allow_any_pp := l_old_utst_rec.allow_any_pp;
   END IF;
   IF NVL((l_old_utst_rec.sc_uc <> l_oldref_utst_rec.sc_uc), TRUE) AND NOT(l_old_utst_rec.sc_uc IS NULL AND l_oldref_utst_rec.sc_uc IS NULL)  THEN
     l_new_utst_rec.sc_uc := l_old_utst_rec.sc_uc;
   END IF;
   IF NVL((l_old_utst_rec.sc_uc_version <> l_oldref_utst_rec.sc_uc_version), TRUE) AND NOT(l_old_utst_rec.sc_uc_version IS NULL AND l_oldref_utst_rec.sc_uc_version IS NULL)  THEN
     l_new_utst_rec.sc_uc_version := l_old_utst_rec.sc_uc_version;
   END IF;
   IF NVL((l_old_utst_rec.sc_lc <> l_oldref_utst_rec.sc_lc), TRUE) AND NOT(l_old_utst_rec.sc_lc IS NULL AND l_oldref_utst_rec.sc_lc IS NULL)  THEN
     l_new_utst_rec.sc_lc := l_old_utst_rec.sc_lc;
   END IF;
   IF NVL((l_old_utst_rec.sc_lc_version <> l_oldref_utst_rec.sc_lc_version), TRUE) AND NOT(l_old_utst_rec.sc_lc_version IS NULL AND l_oldref_utst_rec.sc_lc_version IS NULL)  THEN
     l_new_utst_rec.sc_lc_version := l_old_utst_rec.sc_lc_version;
   END IF;
   IF NVL((l_old_utst_rec.inherit_au <> l_oldref_utst_rec.inherit_au), TRUE) AND NOT(l_old_utst_rec.inherit_au IS NULL AND l_oldref_utst_rec.inherit_au IS NULL)  THEN
     l_new_utst_rec.inherit_au := l_old_utst_rec.inherit_au;
   END IF;
   IF NVL((l_old_utst_rec.inherit_gk <> l_oldref_utst_rec.inherit_gk), TRUE) AND NOT(l_old_utst_rec.inherit_gk IS NULL AND l_oldref_utst_rec.inherit_gk IS NULL)  THEN
     l_new_utst_rec.inherit_gk := l_old_utst_rec.inherit_gk;
   END IF;
   IF NVL((l_old_utst_rec.last_comment <> l_oldref_utst_rec.last_comment), TRUE) AND NOT(l_old_utst_rec.last_comment IS NULL AND l_oldref_utst_rec.last_comment IS NULL)  THEN
     l_new_utst_rec.last_comment := l_old_utst_rec.last_comment;
   END IF;
   IF NVL((l_old_utst_rec.st_class <> l_oldref_utst_rec.st_class), TRUE) AND NOT(l_old_utst_rec.st_class IS NULL AND l_oldref_utst_rec.st_class IS NULL)  THEN
     l_new_utst_rec.st_class := l_old_utst_rec.st_class;
   END IF;
   IF NVL((l_old_utst_rec.log_hs <> l_oldref_utst_rec.log_hs), TRUE) AND NOT(l_old_utst_rec.log_hs IS NULL AND l_oldref_utst_rec.log_hs IS NULL)  THEN
     l_new_utst_rec.log_hs := l_old_utst_rec.log_hs;
   END IF;
   IF NVL((l_old_utst_rec.log_hs_details <> l_oldref_utst_rec.log_hs_details), TRUE) AND NOT(l_old_utst_rec.log_hs_details IS NULL AND l_oldref_utst_rec.log_hs_details IS NULL)  THEN
     l_new_utst_rec.log_hs_details := l_old_utst_rec.log_hs_details;
   END IF;
   IF NVL((l_old_utst_rec.lc <> l_oldref_utst_rec.lc), TRUE) AND NOT(l_old_utst_rec.lc IS NULL AND l_oldref_utst_rec.lc IS NULL)  THEN
     l_new_utst_rec.lc := l_old_utst_rec.lc;
   END IF;
   IF NVL((l_old_utst_rec.lc_version <> l_oldref_utst_rec.lc_version), TRUE) AND NOT(l_old_utst_rec.lc_version IS NULL AND l_oldref_utst_rec.lc_version IS NULL)  THEN
     l_new_utst_rec.lc_version := l_old_utst_rec.lc_version;
   END IF;

   --insert the record in utst
   --special cases: version_is_current, effective_till
   l_ret_code := UNAPIST.SaveSampleType
                (a_new_st,
                 a_new_st_version,
                 NULL,
                 l_new_utst_rec.effective_from,
                 NULL,
                 l_new_utst_rec.description,
                 l_new_utst_rec.description2,
                 l_new_utst_rec.is_template,
                 l_new_utst_rec.confirm_userid,
                 l_new_utst_rec.shelf_life_val,
                 l_new_utst_rec.shelf_life_unit,
                 l_new_utst_rec.nr_planned_sc,
                 l_new_utst_rec.freq_tp,
                 l_new_utst_rec.freq_val,
                 l_new_utst_rec.freq_unit,
                 l_new_utst_rec.invert_freq,
                 l_new_utst_rec.last_sched,
                 l_new_utst_rec.last_cnt,
                 l_new_utst_rec.last_val,
                 l_new_utst_rec.priority,
                 l_new_utst_rec.label_format,
                 l_new_utst_rec.descr_doc,
                 l_new_utst_rec.descr_doc_version,
                 l_new_utst_rec.allow_any_pp,
                 l_new_utst_rec.sc_uc,
                 l_new_utst_rec.sc_uc_version,
                 l_new_utst_rec.sc_lc,
                 l_new_utst_rec.sc_lc_version,
                 l_new_utst_rec.inherit_au,
                 l_new_utst_rec.inherit_gk,
                 l_new_utst_rec.st_class,
                 l_new_utst_rec.log_hs,
                 l_new_utst_rec.lc,
                 l_new_utst_rec.lc_version,
                 '');

   IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
      l_sqlerrm := 'SaveSampleType ret_code='||l_ret_code||'#st='||a_new_st
                   ||'#version='||a_new_st_version;
      RAISE StpError;
   END IF;

   /*-------------------*/
   /* Compare utstau    */
   /*-------------------*/
   l_seq := 0;
   FOR l_new_utstau_rec IN l_new_utstau_cursor LOOP

      --insert the records in utstau
      --special cases: au_version always NULL
      l_seq := l_seq+1;
      INSERT INTO utstau
      (st, version, au, au_version, auseq, value)
      VALUES
      (a_new_st, a_new_st_version, l_new_utstau_rec.au, NULL, l_seq, l_new_utstau_rec.value);
   END LOOP;

   /*-------------------*/
   /* Compare utstgk    */
   /*-------------------*/
   l_seq := 0;
   FOR l_new_utstgk_rec IN l_new_utstgk_cursor LOOP

      --insert the records in utstgk
      --special cases: gk_version always NULL
      l_seq := l_seq+1;
      INSERT INTO utstgk
      (st, version, gk, gk_version, gkseq, value)
      VALUES
      (a_new_st, a_new_st_version, l_new_utstgk_rec.gk, NULL, l_seq, l_new_utstgk_rec.value);

      IF l_new_utstgk_rec.value IS NOT NULL THEN
         BEGIN
            EXECUTE IMMEDIATE 'INSERT INTO utstgk'||l_new_utstgk_rec.gk||
                              ' ('||l_new_utstgk_rec.gk||', st, version) VALUES '||
                              ' (:a_new_value, :a_new_st, :a_new_st_version)'
            USING l_new_utstgk_rec.value, a_new_st, a_new_st_version;
         EXCEPTION
         WHEN TABLE_DOES_NOT_EXIST THEN
            NULL;
         WHEN OTHERS THEN
            RAISE;
         END;
      END IF;
   END LOOP;

   /*-------------------*/
   /* Compare utstpp    */
   /*-------------------*/
   --Build up the list of pp and compare properties
   FOR l_newref_utstpp_rec IN l_stppls_cursor(c_ignore_stpp_pp_version) LOOP

      --fetch the corresponding record in other st with the same relative position
      l_oldref_utstpp_rec := NULL;
      OPEN l_utstpp_cursor(a_oldref_st, a_oldref_st_version,
                           l_newref_utstpp_rec.pp, l_newref_utstpp_rec.pp_version,
                           l_newref_utstpp_rec.pp_key1, l_newref_utstpp_rec.pp_key2, l_newref_utstpp_rec.pp_key3,
                           l_newref_utstpp_rec.pp_key4, l_newref_utstpp_rec.pp_key5,
                           l_newref_utstpp_rec.seq, c_ignore_stpp_pp_version);
      FETCH l_utstpp_cursor
      INTO l_oldref_utstpp_rec;
      CLOSE l_utstpp_cursor;

      l_old_utstpp_rec := NULL;
      OPEN l_utstpp_cursor(a_old_st, a_old_st_version,
                           l_newref_utstpp_rec.pp, l_newref_utstpp_rec.pp_version,
                           l_newref_utstpp_rec.pp_key1, l_newref_utstpp_rec.pp_key2, l_newref_utstpp_rec.pp_key3,
                           l_newref_utstpp_rec.pp_key4, l_newref_utstpp_rec.pp_key5,
                           l_newref_utstpp_rec.seq, c_ignore_stpp_pp_version);
      FETCH l_utstpp_cursor
      INTO l_old_utstpp_rec;
      CLOSE l_utstpp_cursor;

      --compare
      --columns not compared: st, version, pp, pp_version, pp_key[1..5], seq
      --might be a special case in some project but not handled: last_sched, last_count, last_val
      l_new_utstpp_rec := l_newref_utstpp_rec;
      IF NVL((l_old_utstpp_rec.freq_tp <> l_oldref_utstpp_rec.freq_tp), TRUE) AND NOT(l_old_utstpp_rec.freq_tp IS NULL AND l_oldref_utstpp_rec.freq_tp IS NULL)  THEN
        l_new_utstpp_rec.freq_tp := l_old_utstpp_rec.freq_tp;
      END IF;
      IF NVL((l_old_utstpp_rec.freq_val <> l_oldref_utstpp_rec.freq_val), TRUE) AND NOT(l_old_utstpp_rec.freq_val IS NULL AND l_oldref_utstpp_rec.freq_val IS NULL)  THEN
        l_new_utstpp_rec.freq_val := l_old_utstpp_rec.freq_val;
      END IF;
      IF NVL((l_old_utstpp_rec.freq_unit <> l_oldref_utstpp_rec.freq_unit), TRUE) AND NOT(l_old_utstpp_rec.freq_unit IS NULL AND l_oldref_utstpp_rec.freq_unit IS NULL)  THEN
        l_new_utstpp_rec.freq_unit := l_old_utstpp_rec.freq_unit;
      END IF;
      IF NVL((l_old_utstpp_rec.invert_freq <> l_oldref_utstpp_rec.invert_freq), TRUE) AND NOT(l_old_utstpp_rec.invert_freq IS NULL AND l_oldref_utstpp_rec.invert_freq IS NULL)  THEN
        l_new_utstpp_rec.invert_freq := l_old_utstpp_rec.invert_freq;
      END IF;
      --IF NVL((l_old_utstpp_rec.last_sched <> l_oldref_utstpp_rec.last_sched), TRUE) AND NOT(l_old_utstpp_rec.last_sched IS NULL AND l_oldref_utstpp_rec.last_sched IS NULL)  THEN
      --  l_new_utstpp_rec.last_sched := l_old_utstpp_rec.last_sched;
      --END IF;
      l_new_utstpp_rec.last_sched := NULL;
      --IF NVL((l_old_utstpp_rec.last_cnt <> l_oldref_utstpp_rec.last_cnt), TRUE) AND NOT(l_old_utstpp_rec.last_cnt IS NULL AND l_oldref_utstpp_rec.last_cnt IS NULL)  THEN
      --  l_new_utstpp_rec.last_cnt := l_old_utstpp_rec.last_cnt;
      --END IF;
      l_new_utstpp_rec.last_cnt := 0;
      --IF NVL((l_old_utstpp_rec.last_val <> l_oldref_utstpp_rec.last_val), TRUE) AND NOT(l_old_utstpp_rec.last_val IS NULL AND l_oldref_utstpp_rec.last_val IS NULL)  THEN
      --  l_new_utstpp_rec.last_val := l_old_utstpp_rec.last_val;
      --END IF;
      l_new_utstpp_rec.last_val := NULL;
      IF NVL((l_old_utstpp_rec.inherit_au <> l_oldref_utstpp_rec.inherit_au), TRUE) AND NOT(l_old_utstpp_rec.inherit_au IS NULL AND l_oldref_utstpp_rec.inherit_au IS NULL)  THEN
        l_new_utstpp_rec.inherit_au := l_old_utstpp_rec.inherit_au;
      END IF;

      --insert the record in utstpp
      INSERT INTO utstpp
      (st, version, pp, pp_version,
       pp_key1, pp_key2, pp_key3, pp_key4, pp_key5, seq,
       freq_tp, freq_val, freq_unit, invert_freq, last_sched, last_sched_tz, last_cnt, last_val, inherit_au)
      VALUES
      (a_new_st, a_new_st_version,
       l_new_utstpp_rec.pp, l_new_utstpp_rec.pp_version,
       l_new_utstpp_rec.pp_key1, l_new_utstpp_rec.pp_key2, l_new_utstpp_rec.pp_key3, l_new_utstpp_rec.pp_key4, l_new_utstpp_rec.pp_key5,
       l_new_utstpp_rec.seq,
       l_new_utstpp_rec.freq_tp, l_new_utstpp_rec.freq_val, l_new_utstpp_rec.freq_unit,
       l_new_utstpp_rec.invert_freq, l_new_utstpp_rec.last_sched, l_new_utstpp_rec.last_sched, l_new_utstpp_rec.last_cnt,
       l_new_utstpp_rec.last_val, l_new_utstpp_rec.inherit_au);

   END LOOP;

   --insert the pp's that were added in the old st and that are not present in the ref st
   FOR l_new_utstpp_rec IN l_old_stpp_cursor(c_ignore_stpp_pp_version) LOOP
      l_some_pp_appended_in_oldst:=TRUE;
            OPEN l_new_stppseq;
      FETCH l_new_stppseq INTO l_seq;
      CLOSE l_new_stppseq;
      --insert the record in utstpp
      l_new_utstpp_rec.last_cnt := 0;
      l_new_utstpp_rec.last_sched := NULL;
      l_new_utstpp_rec.last_val := NULL;
      INSERT INTO utstpp
      (st, version,
       pp, pp_version,
       pp_key1, pp_key2, pp_key3, pp_key4, pp_key5, seq,
       freq_tp, freq_val, freq_unit, invert_freq, last_sched, last_sched_tz, last_cnt, last_val, inherit_au)
      VALUES
      (a_new_st, a_new_st_version,
       l_new_utstpp_rec.pp, l_new_utstpp_rec.pp_version,
       l_new_utstpp_rec.pp_key1, l_new_utstpp_rec.pp_key2, l_new_utstpp_rec.pp_key3, l_new_utstpp_rec.pp_key4, l_new_utstpp_rec.pp_key5,
       l_new_utstpp_rec.seq,
       l_new_utstpp_rec.freq_tp, l_new_utstpp_rec.freq_val, l_new_utstpp_rec.freq_unit,
       l_new_utstpp_rec.invert_freq, l_new_utstpp_rec.last_sched, l_new_utstpp_rec.last_sched, l_new_utstpp_rec.last_cnt,
       l_new_utstpp_rec.last_val, l_new_utstpp_rec.inherit_au);
   END LOOP;

   /*---------------------*/
   /* Compare utstppau    */
   /*---------------------*/
   --Build up the list of pp and compare properties
   l_seq := 0;
   FOR l_new_utstppau_rec IN l_new_utstppau_cursor LOOP
      --insert the records in utstppau
      --special cases: pp_version is the result of a MAX and au_version always NULL
      --reset auseq on new pp
      IF l_prev_pp_string <> l_new_utstppau_rec.pp||l_new_utstppau_rec.pp_key1||l_new_utstppau_rec.pp_key2||
                             l_new_utstppau_rec.pp_key3|| l_new_utstppau_rec.pp_key4||
                             l_new_utstppau_rec.pp_key5 THEN
         l_seq := 0;
      END IF;
      l_seq := l_seq+1;
      l_prev_pp_string := l_new_utstppau_rec.pp||l_new_utstppau_rec.pp_key1||l_new_utstppau_rec.pp_key2||
                          l_new_utstppau_rec.pp_key3|| l_new_utstppau_rec.pp_key4||
                          l_new_utstppau_rec.pp_key5;
      --pp_version explicitely left empty
      INSERT INTO utstppau
      (st, version,
       pp, pp_version,
       pp_key1, pp_key2, pp_key3, pp_key4, pp_key5,
       au, au_version, auseq, value)
      VALUES
      (a_new_st, a_new_st_version,
       l_new_utstppau_rec.pp, NULL,
       l_new_utstppau_rec.pp_key1, l_new_utstppau_rec.pp_key2, l_new_utstppau_rec.pp_key3,
       l_new_utstppau_rec.pp_key4, l_new_utstppau_rec.pp_key5,
       l_new_utstppau_rec.au, NULL, l_seq, l_new_utstppau_rec.value);
   END LOOP;

   --determine which order to use
   --when the relative order has not been modified in in old_st, the order
   --of pp's in st is the similar to the order of pr's in newref_st
   --when the relative order has been modified in in old_st, the order
   --of pp's in st is the similar to the order of pp's in old_st
   -- Example1:
   --      oldref_st: st1 v1.0 - 1.ppA  2.ppB  3.ppC  4.ppD
   --      old_st:    st1 v1.1 - 1.ppA  2.ppD  3.ppC  4.ppB           <<< ORDER CHANGED
   --      newref_st: st1 v2.0 - 1.ppA  2.ppB  3.ppE  4.ppC  5.ppD
   --      new_st:    st1 v1.1 - 1.ppA  2.ppD  3.ppC  4.ppB  5.ppE
   -- Example2:
   --      oldref_st: st1 v1.0 - 1.ppA  2.ppB  3.ppC  4.ppD
   --      old_st:    st1 v1.1 - 1.ppA  2.ppD  3.ppC  4.ppB           <<< ORDER CHANGED
   --      newref_st: st1 v2.0 - 1.ppA  2.ppB  3.ppC  4.ppD  5.ppE
   --      new_st:    st1 v1.1 - 1.ppA  2.ppD  3.ppE  4.ppC  5.ppB
   -- Example3:
   --      oldref_st: st1 v1.0 - 1.ppA  2.ppB  3.ppC  4.ppD
   --      old_st:    st1 v1.1 -        1.ppB  2.ppC  3.ppD  4.ppE       (relative order kept here)
   --      newref_st: st1 v2.0 - 1.ppA  2.ppD  3.ppC  4.ppB           <<< ORDER CHANGED
   --      new_st:    st1 v1.1 -        1.ppD  2.ppE  3.ppC  4.ppB
   -- Example4:
   --      oldref_st: st1 v1.0 - 1.ppA  2.ppB  3.ppC  4.ppD
   --      old_st:    st1 v1.1 - 1.ppA  2.ppD  3.ppC  4.ppB           <<< ORDER CHANGED *
   --      newref_st: st1 v2.0 - 1.ppB  2.ppA  3.ppC  4.ppD  5.ppE    <<< ORDER CHANGED
   --      new_st:    st1 v1.1 - 1.ppA  2.ppD  3.ppE  4.ppC  5.ppB    *= winning order

   --Is the relative order changed in old_st when comparing it to oldref_st ?
   --The following query will return no record (no data found raised when somthing is found
   l_order_modified_in_oldst := 'N';
   IF c_keep_newversion_stpp_order = '0' THEN

         --the 2 following queries is checking that all possible 'follows' relation
         --present in one st are also present in the other for the pp's
         --that are common to the 2
         --
         --It is enough that one of the 2 is containing the possible 'follows'
         -- relation of the other to be sure that the order has not changed between the 2
         SELECT COUNT(*)
         INTO l_count_follows_not_common1
         FROM
            (SELECT DISTINCT PRIOR pp_partial_key , a.pp_partial_key FROM
               (SELECT aa.pp_partial_key, ROWNUM rel_pos FROM
                  (SELECT MAX(pp||pp_key1||pp_key2||pp_key3||pp_key4||pp_key5) pp_partial_key FROM utstpp
                   WHERE st=a_oldref_st AND version=a_oldref_st_version
                     AND (pp||pp_key1||pp_key2||pp_key3||pp_key4||pp_key5) IN
                               (SELECT pp||pp_key1||pp_key2||pp_key3||pp_key4||pp_key5
                                FROM utstpp
                                WHERE st=a_oldref_st AND version=a_oldref_st_version
                                INTERSECT
                                SELECT pp||pp_key1||pp_key2||pp_key3||pp_key4||pp_key5
                                FROM utstpp
                                WHERE st=a_old_st AND version=a_old_st_version)
                  GROUP  BY seq) aa) a
              CONNECT BY PRIOR a.rel_pos <= a.rel_pos-1 AND PRIOR a.pp_partial_key <> a.pp_partial_key AND LEVEL <=2
              MINUS
              SELECT DISTINCT PRIOR pp_partial_key , a.pp_partial_key FROM
                 (SELECT aa.pp_partial_key, ROWNUM rel_pos FROM
                    (SELECT MAX(pp||pp_key1||pp_key2||pp_key3||pp_key4||pp_key5) pp_partial_key FROM utstpp
                     WHERE st=a_old_st AND version=a_old_st_version
                       AND (pp||pp_key1||pp_key2||pp_key3||pp_key4||pp_key5) IN
                                 (SELECT pp||pp_key1||pp_key2||pp_key3||pp_key4||pp_key5
                                  FROM utstpp
                                  WHERE st=a_oldref_st AND version=a_oldref_st_version
                                  INTERSECT
                                  SELECT pp||pp_key1||pp_key2||pp_key3||pp_key4||pp_key5
                                  FROM utstpp
                                  WHERE st=a_old_st AND version=a_old_st_version)
                    GROUP  BY seq) aa) a
              CONNECT BY PRIOR a.rel_pos <= a.rel_pos-1 AND PRIOR a.pp_partial_key <> a.pp_partial_key AND LEVEL <=2);

         SELECT COUNT(*)
         INTO l_count_follows_not_common2
         FROM
            (SELECT DISTINCT PRIOR pp_partial_key , a.pp_partial_key FROM
               (SELECT aa.pp_partial_key, ROWNUM rel_pos FROM
                  (SELECT MAX(pp||pp_key1||pp_key2||pp_key3||pp_key4||pp_key5) pp_partial_key FROM utstpp
                     WHERE st=a_old_st AND version=a_old_st_version
                       AND (pp||pp_key1||pp_key2||pp_key3||pp_key4||pp_key5) IN
                                  (SELECT pp||pp_key1||pp_key2||pp_key3||pp_key4||pp_key5
                                    FROM utstpp
                                   WHERE st=a_oldref_st AND version=a_oldref_st_version
                                   INTERSECT
                                   SELECT pp||pp_key1||pp_key2||pp_key3||pp_key4||pp_key5
                                   FROM utstpp
                                   WHERE st=a_old_st AND version=a_old_st_version)
                  GROUP  BY seq) aa) a
              CONNECT BY PRIOR a.rel_pos <= a.rel_pos-1 AND PRIOR a.pp_partial_key <> a.pp_partial_key AND LEVEL <=2
              MINUS
              SELECT DISTINCT PRIOR pp_partial_key , a.pp_partial_key FROM
                 (SELECT aa.pp_partial_key, ROWNUM rel_pos FROM
                    (SELECT MAX(pp||pp_key1||pp_key2||pp_key3||pp_key4||pp_key5) pp_partial_key FROM utstpp
                     WHERE st=a_oldref_st AND version=a_oldref_st_version
                       AND (pp||pp_key1||pp_key2||pp_key3||pp_key4||pp_key5) IN
                                 (SELECT pp||pp_key1||pp_key2||pp_key3||pp_key4||pp_key5
                                  FROM utstpp
                                  WHERE st=a_oldref_st AND version=a_oldref_st_version
                                  INTERSECT
                                  SELECT pp||pp_key1||pp_key2||pp_key3||pp_key4||pp_key5
                                  FROM utstpp WHERE st=a_old_st AND version=a_old_st_version)
                    GROUP  BY seq) aa) a
              CONNECT BY PRIOR a.rel_pos <= a.rel_pos-1 AND PRIOR a.pp_partial_key <> a.pp_partial_key AND LEVEL <=2);
         IF l_count_follows_not_common1 > 0 AND
            l_count_follows_not_common2 > 0 THEN
            l_order_modified_in_oldst := 'Y';
--DBMS_OUTPUT.PUT_LINE('Order modified');
--ELSE
--DBMS_OUTPUT.PUT_LINE('Order not modified');

         END IF;
   END IF;

   l_reorder_took_place := FALSE;
   IF l_order_modified_in_oldst = 'Y' THEN

      l_reorder_took_place := TRUE;
      --sort according to order in oldpp
      --TraceError('UNDIFF.CompareAndCreateSt','(debug) order modified according to oldst');

      SELECT NVL(MAX(a.seq),0)+1
      INTO l_max_seq_in_new_st
      FROM utstpp a
      WHERE a.st = a_new_st
      AND a.version = a_new_st_version;

      --turn all sequence to a negative value to avoid the unique constraint index violations
      UPDATE utstpp a
      SET a.seq = -seq
      WHERE a.st = a_new_st
      AND a.version = a_new_st_version;

      l_reorder_seq := 0;
      l_error_logged := FALSE;
      FOR l_reorder_rec IN l_reorder_follow_old_cursor(l_max_seq_in_new_st) LOOP
         BEGIN

            SELECT MAX(b.seq)
            INTO l_orig_seq
            FROM utstpp b
            WHERE b.st = a_new_st
            AND b.version = a_new_st_version
            AND b.pp||b.pp_key1||b.pp_key2||b.pp_key3||b.pp_key4||b.pp_key5 = l_reorder_rec.pp_partial_key
            AND b.seq < 0;
/* DEBUGGING CODE
DBMS_OUTPUT.PUT_LINE('pp='||l_reorder_rec.pp_partial_key||'#seq'||l_reorder_rec.seq||'#orig_seq='||l_orig_seq);
*/
            l_reorder_seq := l_reorder_seq+1;
            UPDATE utstpp a
            SET a.seq = l_reorder_seq
            WHERE a.st = a_new_st
            AND a.version = a_new_st_version
            AND a.pp||a.pp_key1||a.pp_key2||a.pp_key3||a.pp_key4||a.pp_key5 = l_reorder_rec.pp_partial_key
            AND a.seq = l_orig_seq;

            -- No check on SQL%ROWCOUNT since cursor is also returning the deleted records.
         EXCEPTION
         WHEN OTHERS THEN
            --the parameter is present more than once or the seq is already used
            IF l_error_logged = FALSE THEN
               TraceError('UNDIFF.CompareAndCreateSt','SQLERRM='||SQLERRM);
               TraceError('UNDIFF.CompareAndCreateSt',
                          'while resorting for pp='||l_reorder_rec.pp_partial_key||'#st='||a_new_st||'#st_version='||a_new_st_version);
               l_error_logged := TRUE;
            END IF;
         END;
      END LOOP;

   ELSIF l_some_pp_appended_in_oldst THEN

      --some pp have been added to the old_st and have been added to the new_st
      --but the sequence is not correct
      --sort according to order in newref_st
      l_reorder_took_place := TRUE;
      --TraceError('UNDIFF.CompareAndCreatest','(debug) order modified according to nexref_st');

      SELECT NVL(MAX(a.seq),0)+1
      INTO l_max_seq_in_new_st
      FROM utstpp a
      WHERE a.st = a_new_st
      AND a.version = a_new_st_version;

      --turn all sequence to a negative value to avoid the unique constraint index violations
      UPDATE utstpp a
      SET a.seq = -seq
      WHERE a.st = a_new_st
      AND a.version = a_new_st_version;

      l_reorder_seq := 0;
      l_error_logged := FALSE;
      FOR l_reorder_rec IN l_reorder_follow_newref_cursor(l_max_seq_in_new_st) LOOP
         BEGIN
            SELECT MAX(b.seq)
            INTO l_orig_seq
            FROM utstpp b
            WHERE b.st = a_new_st
            AND b.version = a_new_st_version
            AND b.pp||b.pp_key1||b.pp_key2||b.pp_key3||b.pp_key4||b.pp_key5 = l_reorder_rec.pp_partial_key
            AND b.seq < 0;
/* DEBUGGING CODE
DBMS_OUTPUT.PUT_LINE('pp='||l_reorder_rec.pp_partial_key||'#seq'||l_reorder_rec.seq||'#orig_seq='||l_orig_seq);
*/
            l_reorder_seq := l_reorder_seq+1;
            UPDATE utstpp a
            SET a.seq = l_reorder_seq
            WHERE a.st = a_new_st
            AND a.version = a_new_st_version
            AND a.pp||a.pp_key1||a.pp_key2||a.pp_key3||a.pp_key4||a.pp_key5 = l_reorder_rec.pp_partial_key
            AND a.seq = l_orig_seq;

            -- No check on SQL%ROWCOUNT since cursor is also returning the deleted records.
         EXCEPTION
         WHEN OTHERS THEN
            --the parameter is present more than once or the seq is already used
            IF l_error_logged = FALSE THEN
               TraceError('UNDIFF.CompareAndCreateSt','SQLERRM='||SQLERRM);
               TraceError('UNDIFF.CompareAndCreateSt',
                          'while resorting for pp='||l_reorder_rec.pp_partial_key||'#st='||a_new_st||'#st_version='||a_new_st_version);
               l_error_logged := TRUE;
            END IF;
         END;
      END LOOP;
   END IF;

   IF l_reorder_took_place THEN

      --set the sequence to a positive integer if necessary; should not be necessary but
      l_entered_loop := FALSE;
      FOR l_rec IN l_reorder_corr_stppseq_cursor LOOP
         UPDATE utstpp a
         SET a.seq = (SELECT NVL(MAX(b.seq),0)+1
                      FROM utstpp b
                      WHERE b.st = a_new_st
                        AND b.version = a_new_st_version)
         --WHERE CURRENT OF l_reorder_corr_ppprseq_cursor
         --(Bug in Oracle Bug 2279457 COMBINING DML 'RETURNING' CLAUSE WITH 'WHERE CURRENT OF' IN PL/SQL GIVES ERROR)
         WHERE rowid = l_rec.rowid
         RETURNING a.seq
         INTO l_reorder_seq;

         TraceError('UNDIFF.CompareAndCreateSt', 'pp='||l_rec.pp||'#seq='||l_rec.seq);
         l_entered_loop := TRUE;
      END LOOP;

      IF l_entered_loop THEN
         TraceError('UNDIFF.CompareAndCreateSt','(warning) records found with negative sequences!');
         TraceError('UNDIFF.CompareAndCreateSt',
                    '#st='||a_new_st||'#st_version='||a_new_st_version);
      END IF;

      --gaps in sequence numbers might be present: clean
      l_reorder_seq := 0;
      FOR l_rec IN l_order_nogaps_stppseq_cursor LOOP
         l_reorder_seq := l_reorder_seq+1;
         UPDATE utstpp a
         SET a.seq = l_reorder_seq
         WHERE CURRENT OF l_order_nogaps_stppseq_cursor;
      END LOOP;
   END IF;

   /*-------------------*/
   /* Compare utstip    */
   /*-------------------*/
   --Build up the list of ip and compare properties
   FOR l_newref_utstip_rec IN l_stipls_cursor LOOP

      --fetch the corresponding record in other st with the same relative position
      l_oldref_utstip_rec := NULL;
      OPEN l_utstip_cursor(a_oldref_st, a_oldref_st_version,
                           l_newref_utstip_rec.ip, l_newref_utstip_rec.ip_version,
                           l_newref_utstip_rec.seq);
      FETCH l_utstip_cursor
      INTO l_oldref_utstip_rec;
      CLOSE l_utstip_cursor;

      l_old_utstip_rec := NULL;
      OPEN l_utstip_cursor(a_old_st, a_old_st_version,
                           l_newref_utstip_rec.ip, l_newref_utstip_rec.ip_version,
                           l_newref_utstip_rec.seq);
      FETCH l_utstip_cursor
      INTO l_old_utstip_rec;
      CLOSE l_utstip_cursor;

      --compare
      --columns not compared: st, version, ip, ip_version, seq
      --might be a special case in some project but not handled: last_sched, last_count, last_val
      l_new_utstip_rec := l_newref_utstip_rec;
      IF NVL((l_old_utstip_rec.is_protected <> l_oldref_utstip_rec.is_protected), TRUE) AND NOT(l_old_utstip_rec.is_protected IS NULL AND l_oldref_utstip_rec.is_protected IS NULL)  THEN
        l_new_utstip_rec.is_protected := l_old_utstip_rec.is_protected;
      END IF;
      IF NVL((l_old_utstip_rec.hidden <> l_oldref_utstip_rec.hidden), TRUE) AND NOT(l_old_utstip_rec.hidden IS NULL AND l_oldref_utstip_rec.hidden IS NULL)  THEN
        l_new_utstip_rec.hidden := l_old_utstip_rec.hidden;
      END IF;
      IF NVL((l_old_utstip_rec.freq_tp <> l_oldref_utstip_rec.freq_tp), TRUE) AND NOT(l_old_utstip_rec.freq_tp IS NULL AND l_oldref_utstip_rec.freq_tp IS NULL)  THEN
        l_new_utstip_rec.freq_tp := l_old_utstip_rec.freq_tp;
      END IF;
      IF NVL((l_old_utstip_rec.freq_val <> l_oldref_utstip_rec.freq_val), TRUE) AND NOT(l_old_utstip_rec.freq_val IS NULL AND l_oldref_utstip_rec.freq_val IS NULL)  THEN
        l_new_utstip_rec.freq_val := l_old_utstip_rec.freq_val;
      END IF;
      IF NVL((l_old_utstip_rec.freq_unit <> l_oldref_utstip_rec.freq_unit), TRUE) AND NOT(l_old_utstip_rec.freq_unit IS NULL AND l_oldref_utstip_rec.freq_unit IS NULL)  THEN
        l_new_utstip_rec.freq_unit := l_old_utstip_rec.freq_unit;
      END IF;
      IF NVL((l_old_utstip_rec.invert_freq <> l_oldref_utstip_rec.invert_freq), TRUE) AND NOT(l_old_utstip_rec.invert_freq IS NULL AND l_oldref_utstip_rec.invert_freq IS NULL)  THEN
        l_new_utstip_rec.invert_freq := l_old_utstip_rec.invert_freq;
      END IF;
      --IF NVL((l_old_utstip_rec.last_sched <> l_oldref_utstip_rec.last_sched), TRUE) AND NOT(l_old_utstip_rec.last_sched IS NULL AND l_oldref_utstip_rec.last_sched IS NULL)  THEN
      --  l_new_utstip_rec.last_sched := l_old_utstip_rec.last_sched;
      --END IF;
      --IF NVL((l_old_utstip_rec.last_cnt <> l_oldref_utstip_rec.last_cnt), TRUE) AND NOT(l_old_utstip_rec.last_cnt IS NULL AND l_oldref_utstip_rec.last_cnt IS NULL)  THEN
      --  l_new_utstip_rec.last_cnt := l_old_utstip_rec.last_cnt;
      --END IF;
      --IF NVL((l_old_utstip_rec.last_val <> l_oldref_utstip_rec.last_val), TRUE) AND NOT(l_old_utstip_rec.last_val IS NULL AND l_oldref_utstip_rec.last_val IS NULL)  THEN
      --  l_new_utstip_rec.last_val := l_old_utstip_rec.last_val;
      --END IF;
      l_new_utstip_rec.last_sched := NULL;
      l_new_utstip_rec.last_cnt := 0;
      l_new_utstip_rec.last_val := NULL;
      IF NVL((l_old_utstip_rec.inherit_au <> l_oldref_utstip_rec.inherit_au), TRUE) AND NOT(l_old_utstip_rec.inherit_au IS NULL AND l_oldref_utstip_rec.inherit_au IS NULL)  THEN
        l_new_utstip_rec.inherit_au := l_old_utstip_rec.inherit_au;
      END IF;

      --insert the record in utstpp
      INSERT INTO utstip
      (st, version, ip, ip_version, seq,
       is_protected, hidden,
       freq_tp, freq_val, freq_unit,
       invert_freq, last_sched, last_sched_tz, last_cnt,
       last_val, inherit_au)
      VALUES
      (a_new_st, a_new_st_version,
       l_new_utstip_rec.ip, l_new_utstip_rec.ip_version, l_new_utstip_rec.seq,
       l_new_utstip_rec.is_protected, l_new_utstip_rec.hidden,
       l_new_utstip_rec.freq_tp, l_new_utstip_rec.freq_val, l_new_utstip_rec.freq_unit,
       l_new_utstip_rec.invert_freq, l_new_utstip_rec.last_sched, l_new_utstip_rec.last_sched, l_new_utstip_rec.last_cnt,
       l_new_utstip_rec.last_val, l_new_utstip_rec.inherit_au);

   END LOOP;

   --insert the ip's that were added in the old st and that are not present in the ref st
   FOR l_new_utstip_rec IN l_old_stip_cursor LOOP
      OPEN l_new_stipseq;
      FETCH l_new_stipseq INTO l_seq;
      CLOSE l_new_stipseq;
      l_new_utstip_rec.last_sched := NULL;
      l_new_utstip_rec.last_cnt := 0;
      l_new_utstip_rec.last_val := NULL;
      --insert the record in utstip
      INSERT INTO utstip
      (st, version, ip, ip_version, seq,
       is_protected, hidden,
       freq_tp, freq_val, freq_unit,
       invert_freq, last_sched, last_sched_tz, last_cnt,
       last_val, inherit_au)
      VALUES
      (a_new_st, a_new_st_version,
       l_new_utstip_rec.ip, l_new_utstip_rec.ip_version, l_seq,
       l_new_utstip_rec.is_protected, l_new_utstip_rec.hidden,
       l_new_utstip_rec.freq_tp, l_new_utstip_rec.freq_val, l_new_utstip_rec.freq_unit,
       l_new_utstip_rec.invert_freq, l_new_utstip_rec.last_sched, l_new_utstip_rec.last_sched, l_new_utstip_rec.last_cnt,
       l_new_utstip_rec.last_val, l_new_utstip_rec.inherit_au);
   END LOOP;

   /*---------------------*/
   /* Compare utstipau    */
   /*---------------------*/
   --Build up the list of pp and compare properties
   l_seq := 0;
   FOR l_new_utstipau_rec IN l_new_utstipau_cursor LOOP
      --insert the records in utstipau
      --special cases: ip_version is the result of a MAX and au_version always NULL
      --reset auseq on new ip
      IF l_prev_ip <> l_new_utstipau_rec.ip THEN
         l_seq := 0;
      END IF;
      l_seq := l_seq+1;
      l_prev_ip := l_new_utstipau_rec.ip;
      --ip_version explicitely left empty

      INSERT INTO utstipau
      (st, version,
       ip, ip_version,
       au, au_version, auseq, value)
      VALUES
      (a_new_st, a_new_st_version,
       l_new_utstipau_rec.ip, NULL,
       l_new_utstipau_rec.au, NULL, l_seq, l_new_utstipau_rec.value);
   END LOOP;

   --Fill in ip_version in utstipau with MAX(ip_version)
   --since NULL is not tolerated by our client application
   UPDATE utstipau a
   SET a.ip_version = (SELECT MAX(b.ip_version)
                       FROM utstip b
                       WHERE b.st = a_new_st
                       AND b.version = a_new_st_version
                       AND b.ip = a.ip)
   WHERE a.st = a_new_st
   AND a.version = a_new_st_version;

   --Fill in pp_version in utstppau with MAX(pp_version)
   --since NULL is not tolerated by our client application
   UPDATE utstppau a
   SET a.pp_version = (SELECT MAX(b.pp_version)
                       FROM utstpp b
                       WHERE b.st = a_new_st
                       AND b.version = a_new_st_version
                       AND b.pp = a.pp)
   WHERE a.st = a_new_st
   AND a.version = a_new_st_version;

   --In projects the following constructions will be added here:
   --  Add some audit trail information in history
   --  send a customized  event to trigger a specific transition
   --  call changestatus to bring the created object directly to a specific status
   INSERT INTO utsths (st, version, who, who_description, what,
                       what_description, logdate, logdate_tz, why, tr_seq, ev_seq)
   VALUES (a_new_st, a_new_st_version, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, 'UNDIFF generated new version',
           SUBSTR('UNDIFF generated new st:('||a_new_st||','||a_new_st_version||') based on'||
                  '#old ref st:('||a_oldref_st||','||a_oldref_st_version||')'||
                  '#old st:('||a_old_st||','||a_old_st_version||')'||
                  '#new ref st:('||a_newref_st||','||a_newref_st_version||')',1,255)
           , CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, '', UNAPIGEN.P_TR_SEQ, NVL(UNAPIEV.P_EV_REC.ev_seq, -1));

    --------------------------------------------------------------------------------
    -- RS20110303 : START OF CHANGE VREDESTEIN
    -- uncomment to force a statuschange to @A
    --------------------------------------------------------------------------------
    lvs_change_ss_st := APAOGEN.GetSystemSetting('APPROVE_INTERSPEC','NO');
    IF lvs_change_ss_st = 'YES' THEN
       -- Check if the given sampletype is a generic sampletype. Change status to '@A' only if
       -- sampletype is not generic.
       OPEN l_generic_cursor(a_new_st, a_new_st_version);
       FETCH l_generic_cursor INTO l_count;
       CLOSE l_generic_cursor;
       IF l_count = 0 THEN
          l_api_name := 'CompareAndCreateSt';
          l_evmgr_name := UNAPIGEN.P_EVMGR_NAME;
          l_object_tp := 'st';
          l_object_id  := a_new_st;
          l_object_lc  := '@L';
          l_object_ss  := '@E';
          l_ev_tp      := 'ObjectUpdated';
          l_ev_details := 'version=' ||a_new_st_version||'#ss_to=@A';
          l_seq_nr     := NULL;

          l_ret_code := UNAPIEV.INSERTEVENT
                          (l_api_name,
                           l_evmgr_name,
                           l_object_tp,
                           l_object_id,
                           l_object_lc,
                           l_object_lc_version,
                           l_object_ss,
                           l_ev_tp,
                           l_ev_details,
                           l_seq_nr);
          IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
             UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
             l_sqlerrm := 'UNAPIEV.INSERTEVENT ret_code='||l_ret_code||'#st='||a_new_st
                          ||'#version='||a_new_st_version;
             RAISE StpError;
          END IF;
       END IF;
   END IF;
/*
    RS20110303 : END OF CHANGE VREDESTEIN
    */


   IF UNAPIGEN.EndTxn <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE StpError;
   END IF;


   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF sqlcode <> 1 THEN
      UNAPIGEN.LogError('CompareAndCreateSt',sqlerrm);
   ELSIF l_sqlerrm IS NOT NULL THEN
      UNAPIGEN.LogError('CompareAndCreateSt',l_sqlerrm);
   END IF;
   IF l_utst_cursor%ISOPEN THEN
      CLOSE l_utst_cursor;
   END IF;
   IF l_utstpp_cursor%ISOPEN THEN
      CLOSE l_utstpp_cursor;
   END IF;
   IF l_new_stppseq%ISOPEN THEN
      CLOSE l_new_stppseq;
   END IF;
   IF l_utstip_cursor%ISOPEN THEN
      CLOSE l_utstip_cursor;
   END IF;
   IF l_utstip_cursor%ISOPEN THEN
      CLOSE l_utstip_cursor;
   END IF;
   IF l_new_stipseq%ISOPEN THEN
      CLOSE l_new_stipseq;
   END IF;
   RETURN(UNAPIGEN.AbortTxn(UNAPIGEN.P_TXN_ERROR, 'CompareAndCreateSt'));
END CompareAndCreateSt;
--
FUNCTION SQLGetHighestApprovedVersion
(a_pp               IN      VARCHAR2, /* VC20_TYPE */
 a_version          IN      VARCHAR2, /* VC20_TYPE */
 a_pp_key1          IN      VARCHAR2, /* VC20_TYPE */
 a_pp_key2          IN      VARCHAR2, /* VC20_TYPE */
 a_pp_key3          IN      VARCHAR2, /* VC20_TYPE */
 a_pp_key4          IN      VARCHAR2, /* VC20_TYPE */
 a_pp_key5          IN      VARCHAR2) /* VC20_TYPE */
RETURN VARCHAR2 IS
l_version                VARCHAR2(20);
l_base_version           VARCHAR2(20);
l_major_version_string   VARCHAR2(20);

CURSOR l_pp_versions(l_like VARCHAR2) IS
SELECT version FROM UTPP
WHERE pp = a_pp
AND pp_key1 = a_pp_key1
AND pp_key2 = a_pp_key2
AND pp_key3 = a_pp_key3
AND pp_key4 = a_pp_key4
AND pp_key5 = a_pp_key5
AND version LIKE l_like
AND active= '1'
ORDER BY version DESC;
BEGIN
    l_base_version := a_version;
    l_major_version_string := SUBSTR(l_base_version, 1, INSTR(l_base_version,'.')-1) || '%';
    OPEN l_pp_versions(l_major_version_string);
    FETCH l_pp_versions INTO l_version;
    IF l_pp_versions%NOTFOUND THEN
        l_version := '';
    END IF;
    CLOSE l_pp_versions;
 RETURN(l_version);
END SQLGetHighestApprovedVersion;

-- -----------------------------------------------------------------------------
/*
This function SynchronizeChildSpec try to find the children of a certain parameterprofile
and tries to create a new version of these childs according to the new modifications of the parent
*/

/* --This version of SynchronizeChildSpec synchronizes all children. A child is a pp that has 1 pp_key more specified than his parent pp.
FUNCTION SynchronizeChildSpec
RETURN NUMBER IS

CURSOR childpp_cursor(c_pp VARCHAR2, c_version VARCHAR2, c_pp_key1 VARCHAR2, c_pp_key2 VARCHAR2, c_pp_key3 VARCHAR2, c_pp_key4 VARCHAR2, c_pp_key5 VARCHAR2) IS
select pp, version, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5
from utpp
where pp=c_pp
and pp_key1 = DECODE(c_pp_key1, ' ', pp_key1, c_pp_key1)
and pp_key2 = DECODE(c_pp_key2, ' ', pp_key2, c_pp_key2)
and pp_key3 = DECODE(c_pp_key3, ' ', pp_key3, c_pp_key3)
and pp_key4 = DECODE(c_pp_key4, ' ', pp_key4, c_pp_key4)
and pp_key5 = DECODE(c_pp_key5, ' ', pp_key5, c_pp_key5)
and  DECODE(pp_key1, ' ', 0, 1)+ DECODE(pp_key2, ' ', 0, 1) + DECODE(pp_key3, ' ', 0, 1) +  DECODE(pp_key4, ' ', 0, 1) +  DECODE(pp_key5, ' ', 0, 1) =
DECODE(c_pp_key1, ' ', 0, 1)+ DECODE(c_pp_key2, ' ', 0, 1) + DECODE(c_pp_key3, ' ', 0, 1) +  DECODE(c_pp_key4, ' ', 0, 1) +  DECODE(c_pp_key5, ' ', 0, 1) + 1 --one pp_key more
and version = UNVERSION.SQLGetPpHighestMinorVersion(pp, version, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5) --highest minor version
and UNVERSION.SQLGetNextMajorVersion(version) = UNVERSION.SQLGetNextMajorVersion(c_version); --same major version


CURSOR previous_parent_cursor(c_pp VARCHAR2, c_major_version VARCHAR2, c_pp_key1 VARCHAR2, c_pp_key2 VARCHAR2, c_pp_key3 VARCHAR2, c_pp_key4 VARCHAR2, c_pp_key5 VARCHAR2) IS
select pp, version, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5
from utpp
where pp=c_pp
and pp_key1 = c_pp_key1
and pp_key2 = c_pp_key2
and pp_key3 = c_pp_key3
and pp_key4 = c_pp_key4
and pp_key5 = c_pp_key5
and version = UNVERSION.SQLGetPpHighestMinorVersion(pp, version, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5) --highest minor version
and UNVERSION.SQLGetNextMajorVersion(version) like c_version  --previous major version
order by version desc;

l_oldref_pp                VARCHAR2(20);
l_oldref_pp_version        VARCHAR2(20);
l_oldref_pp_key1           VARCHAR2(20);
l_oldref_pp_key2           VARCHAR2(20);
l_oldref_pp_key3           VARCHAR2(20);
l_oldref_pp_key4           VARCHAR2(20);
l_oldref_pp_key5           VARCHAR2(20);
l_newref_pp                VARCHAR2(20);
l_newref_pp_version        VARCHAR2(20);
l_newref_pp_key1           VARCHAR2(20);
l_newref_pp_key2           VARCHAR2(20);
l_newref_pp_key3           VARCHAR2(20);
l_newref_pp_key4           VARCHAR2(20);
l_newref_pp_key5           VARCHAR2(20);
l_old_pp                   VARCHAR2(20);
l_old_pp_version           VARCHAR2(20);
l_old_pp_key1              VARCHAR2(20);
l_old_pp_key2              VARCHAR2(20);
l_old_pp_key3              VARCHAR2(20);
l_old_pp_key4              VARCHAR2(20);
l_old_pp_key5              VARCHAR2(20);
l_new_pp                   VARCHAR2(20);
l_new_pp_version           VARCHAR2(20);
l_new_pp_key1              VARCHAR2(20);
l_new_pp_key2              VARCHAR2(20);
l_new_pp_key3              VARCHAR2(20);
l_new_pp_key4              VARCHAR2(20);
l_new_pp_key5              VARCHAR2(20);

l_temp_version             VARCHAR2(20);
l_major_version            VARCHAR2(20);

BEGIN
l_newref_pp        := UNAPIEV.P_EV_REC.object_id;
l_newref_pp_version:= UNAPIEV.P_VERSION   ;
l_newref_pp_key1   := UNAPIEV.P_PP_KEY1   ;
l_newref_pp_key2   := UNAPIEV.P_PP_KEY2   ;
l_newref_pp_key3   := UNAPIEV.P_PP_KEY3   ;
l_newref_pp_key4   := UNAPIEV.P_PP_KEY4   ;
l_newref_pp_key5   := UNAPIEV.P_PP_KEY5   ;

l_major_version := SUBSTR(l_newref_pp_version, 1, INSTR(l_newref_pp_version,'.')-1) || '%';

OPEN previous_parent_cursor(l_newref_pp,l_major_version,l_newref_pp_key1,l_newref_pp_key2,l_newref_pp_key3,l_newref_pp_key4,l_newref_pp_key5);
FETCH previous_parent_cursor INTO l_oldref_pp,l_oldref_pp_version,l_oldref_pp_key1,l_oldref_pp_key2,l_oldref_pp_key3,l_oldref_pp_key4,l_oldref_pp_key5;
IF previous_parent_cursor%NOTFOUND THEN
    CLOSE previous_parent_cursor;  -- nothing to compare with
    RETURN(UNAPIGEN.DBERR_SUCCESS);
END IF;
CLOSE previous_parent_cursor;

FOR l_child_rec IN childpp_cursor(l_oldref_pp,l_oldref_pp_version,l_oldref_pp_key1,l_oldref_pp_key2,l_oldref_pp_key3,l_oldref_pp_key4,l_oldref_pp_key5) LOOP
    l_old_pp         :=  l_child_rec.pp     ;
    l_old_pp_version :=  l_child_rec.version;
    l_old_pp_key1    :=  l_child_rec.pp_key1;
    l_old_pp_key2    :=  l_child_rec.pp_key2;
    l_old_pp_key3    :=  l_child_rec.pp_key3;
    l_old_pp_key4    :=  l_child_rec.pp_key4;
    l_old_pp_key5    :=  l_child_rec.pp_key5;

    -- find the highest existing version with the same major version as l_newref_pp
    l_temp_version := UNVERSION.SQLGetPpHighestMinorVersion(l_old_pp, l_newref_pp_version, l_old_pp_key1, l_old_pp_key2, l_old_pp_key3, l_old_pp_key4, l_old_pp_key5 );
    IF NVL(l_temp_version, ' ') = ' ' THEN
        l_new_pp_version := l_newref_pp_version ; --same version as the reference object
    ELSE
        l_new_pp_version := UNVERSION.SQLGetNextMinorVersion(l_temp_version);
    END IF;
    l_new_pp           :=    l_old_pp         ;
    l_new_pp_key1      :=    l_old_pp_key1    ;
    l_new_pp_key2      :=    l_old_pp_key2    ;
    l_new_pp_key3      :=    l_old_pp_key3    ;
    l_new_pp_key4      :=    l_old_pp_key4    ;
    l_new_pp_key5      :=    l_old_pp_key5    ;

    l_ret_code  := CompareAndCreatePp
    (l_oldref_pp        ,
     l_oldref_pp_version,
     l_oldref_pp_key1   ,
     l_oldref_pp_key2   ,
     l_oldref_pp_key3   ,
     l_oldref_pp_key4   ,
     l_oldref_pp_key5   ,
     l_newref_pp        ,
     l_newref_pp_version,
     l_newref_pp_key1   ,
     l_newref_pp_key2   ,
     l_newref_pp_key3   ,
     l_newref_pp_key4   ,
     l_newref_pp_key5   ,
     l_old_pp           ,
     l_old_pp_version   ,
     l_old_pp_key1      ,
     l_old_pp_key2      ,
     l_old_pp_key3      ,
     l_old_pp_key4      ,
     l_old_pp_key5      ,
     l_new_pp           ,
     l_new_pp_version   ,
     l_new_pp_key1      ,
     l_new_pp_key2      ,
     l_new_pp_key3      ,
     l_new_pp_key4      ,
     l_new_pp_key5      ) ;

END LOOP;

RETURN(UNAPIGEN.DBERR_SUCCESS);

END SynchronizeChildSpec;
*/

/* This version SynchronizeChildSpec will synchronize the plant specific childs of product specific parameter profiles

This is the default behaviour: The Interspec interface, another application or any user
will create product specific parameter profiles.
It is possible to create manually plant specific variations of these parameter profiles.
When a new version of the product specific pp is created, this function will propagate
the modifications the plant specific childs.
The modifications are not brought into the existing child versions but new versions for these childs
are created.
*/
FUNCTION SynchronizeChildSpec
RETURN NUMBER IS

--The child pp are the parameter profile
--  1.that have the same pp_keys (blank is also matching)
--  2.that have one pp_key more specified
--  3.only the highest minor version is considered when multiple child versions are present
--  4.with the same major version as the parent
-- PLEASE BE SURE TO TUNE THIS QUERY WHEN YOU BRING SOME MODIFCATIONS TO IT
-- A project commented out the second and the fourth condition without tuning it
-- This resulted in many evaluations of SQLGetPpHighestMinorVersion (which performs queries internally)
-- (SQLGetPpHighestMinorVersion was called for all possible records in utpp where pp=c_pp)
-- (be sure to test it with put some DBMS_OUTPUT tracing in it to see how many times it is evaluated)
CURSOR childpp_cursor(c_pp VARCHAR2, c_version VARCHAR2, c_pp_key1 VARCHAR2, c_pp_key2 VARCHAR2, c_pp_key3 VARCHAR2, c_pp_key4 VARCHAR2, c_pp_key5 VARCHAR2) IS
    SELECT  pp, version, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5
    FROM utpp
    WHERE  pp=c_pp
    --1--
    AND pp_key1 = DECODE(c_pp_key1, ' ', pp_key1, c_pp_key1)
    AND pp_key2 = DECODE(c_pp_key2, ' ', pp_key2, c_pp_key2)
    AND pp_key3 = DECODE(c_pp_key3, ' ', pp_key3, c_pp_key3)
    AND pp_key4 = DECODE(c_pp_key4, ' ', pp_key4, c_pp_key4)
    AND pp_key5 = DECODE(c_pp_key5, ' ', pp_key5, c_pp_key5)
    --2--
    AND  DECODE(pp_key1, ' ', 0, 1)+ DECODE(pp_key2, ' ', 0, 1) + DECODE(pp_key3, ' ', 0, 1) +  DECODE(pp_key4, ' ', 0, 1) +  DECODE(pp_key5, ' ', 0, 1) =
    DECODE(c_pp_key1, ' ', 0, 1)+ DECODE(c_pp_key2, ' ', 0, 1) + DECODE(c_pp_key3, ' ', 0, 1) +  DECODE(c_pp_key4, ' ', 0, 1) +  DECODE(c_pp_key5, ' ', 0, 1) + 1 --one pp_key more
    --3--
    AND version = UNVERSION.SQLGetPpHighestMinorVersion(pp, version, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5) --highest minor version
    --4--
    AND UNVERSION.SQLGetNextMajorVersion(version) = UNVERSION.SQLGetNextMajorVersion(c_version); --same major version

CURSOR previous_parent_cursor(c_pp VARCHAR2, c_major_version VARCHAR2, c_pp_key1 VARCHAR2, c_pp_key2 VARCHAR2, c_pp_key3 VARCHAR2, c_pp_key4 VARCHAR2, c_pp_key5 VARCHAR2) IS
    SELECT MAX(version) version
    FROM   utpp
    --the parent has exactly the same pp_key
    WHERE  pp=c_pp
    AND pp_key1 = c_pp_key1
    AND pp_key2 = c_pp_key2
    AND pp_key3 = c_pp_key3
    AND pp_key4 = c_pp_key4
    AND pp_key5 = c_pp_key5
    --when multiple parents are possible
    --the parent with the highest minor version in a major version is considered
    --OBSOLETE: the next major version of the parent = the current major version
      --why obsolete ?
      --There may be gaps between major versions transferred
      --e.g: verion 12 is transferred but verion 11 was never transferred
      --     version 10 must be used as parent in such a case
    AND version < c_major_version  --previous major version
    ORDER BY version DESC;

CURSOR ppkey_cursor(c_key_tp VARCHAR2, c_key_name VARCHAR2) IS
    SELECT seq FROM utkeypp
    WHERE key_tp = c_key_tp
    AND key_name = c_key_name;

CURSOR c_nbr_keys_specified(l_key1 VARCHAR2, l_key2 VARCHAR2, l_key3 VARCHAR2, l_key4 VARCHAR2, l_key5 VARCHAR2) IS
SELECT  DECODE(l_key1, ' ', 0, 1) + DECODE(l_key2, ' ', 0, 1) + DECODE(l_key3, ' ', 0, 1) +
    DECODE(l_key4, ' ', 0, 1) + DECODE(l_key5, ' ', 0, 1)    nbr_keys FROM DUAL;

l_oldref_pp          VARCHAR2(20);
l_oldref_pp_version  VARCHAR2(20);
l_oldref_pp_key      UNAPIGEN.VC20_TABLE_TYPE;
l_newref_pp          VARCHAR2(20);
l_newref_pp_version  VARCHAR2(20);
l_newref_pp_key      UNAPIGEN.VC20_TABLE_TYPE;
l_old_pp             VARCHAR2(20);
l_old_pp_version     VARCHAR2(20);
l_old_pp_key         UNAPIGEN.VC20_TABLE_TYPE;
l_new_pp             VARCHAR2(20);
l_new_pp_version     VARCHAR2(20);
l_new_pp_key         UNAPIGEN.VC20_TABLE_TYPE;

l_temp_version       VARCHAR2(20);
l_major_version      VARCHAR2(20);
l_product_ppkey_seq  NUMBER;
l_nbr_keys_specified    NUMBER;
l_plant_is_obsolete     BOOLEAN;
l_count_fromis          INTEGER;
l_count_plant_present   INTEGER;

BEGIN

-- The key for the parameter profile for which the event rule has been triggered
-- is stored in l_newref_pp variables
l_newref_pp          := UNAPIEV.P_EV_REC.object_id;
l_newref_pp_version  := UNAPIEV.P_VERSION   ;
l_newref_pp_key(1)   := UNAPIEV.P_PP_KEY1   ;
l_newref_pp_key(2)   := UNAPIEV.P_PP_KEY2   ;
l_newref_pp_key(3)   := UNAPIEV.P_PP_KEY3   ;
l_newref_pp_key(4)   := UNAPIEV.P_PP_KEY4   ;
l_newref_pp_key(5)   := UNAPIEV.P_PP_KEY5   ;

-- fetch pp_key configuration
--
-- which pp_key is containing the product
-- pp_key for product initialised UNAPIGEN.P_PP_KEY4PRODUCT by SetConnection
--
-- which pp_key is conatining the plant
-- (fetched only one time by session)
IF P_PP_KEY4PLANT IS NULL THEN
   OPEN ppkey_cursor('gk', 'gk.plant');
   FETCH ppkey_cursor
   INTO P_PP_KEY4PLANT;
   IF ppkey_cursor%NOTFOUND THEN
       CLOSE ppkey_cursor;  -- no plant pp_key
       RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;
   CLOSE ppkey_cursor;
END IF;

-- how many pp_keys have been specified
OPEN  c_nbr_keys_specified(l_newref_pp_key(1),l_newref_pp_key(2),l_newref_pp_key(3),l_newref_pp_key(4),l_newref_pp_key(5));
FETCH c_nbr_keys_specified
INTO l_nbr_keys_specified;
CLOSE c_nbr_keys_specified;

--Check if the parameter profile is concerned by our rule
--The parameter profile is not further processed when the parameter profile
-- is not a product specific parameter profile OR when other pp_keys not related to the product
-- are also specified
-- This rule will be typically customized in projects since
-- the definition of a child will vary from one project to another
IF (l_newref_pp_key(UNAPIGEN.P_PP_KEY4PRODUCT) = ' ') OR
   (l_nbr_keys_specified != 1) THEN
    -- newref_pp is not a product specific pp or more than 1 key is specified
    RETURN(UNAPIGEN.DBERR_SUCCESS);
END IF;

--The parameter profile must be processed
--Find the previous parent version
l_major_version := SUBSTR(l_newref_pp_version, 1, INSTR(l_newref_pp_version,'.')-1) ||
                   '.'||
                   SUBSTR(UNVERSION.SQLGetNextMajorVersion(l_newref_pp_version), INSTR(UNVERSION.SQLGetNextMajorVersion(l_newref_pp_version),'.') +1);
OPEN previous_parent_cursor(l_newref_pp,l_major_version,l_newref_pp_key(1),l_newref_pp_key(2),l_newref_pp_key(3),l_newref_pp_key(4),l_newref_pp_key(5));
FETCH previous_parent_cursor
INTO l_oldref_pp_version;
IF l_oldref_pp_version IS NULL THEN
    CLOSE previous_parent_cursor;  -- nothing to compare with
    RETURN(UNAPIGEN.DBERR_SUCCESS);
END IF;
l_oldref_pp := l_newref_pp;
l_oldref_pp_key(1) := l_newref_pp_key(1);
l_oldref_pp_key(2) := l_newref_pp_key(2);
l_oldref_pp_key(3) := l_newref_pp_key(3);
l_oldref_pp_key(4) := l_newref_pp_key(4);
l_oldref_pp_key(5) := l_newref_pp_key(5);
CLOSE previous_parent_cursor;

--Process all childs
FOR l_child_rec IN childpp_cursor(l_oldref_pp,l_oldref_pp_version,l_oldref_pp_key(1),l_oldref_pp_key(2),l_oldref_pp_key(3),l_oldref_pp_key(4),l_oldref_pp_key(5)) LOOP
    l_old_pp         :=  l_child_rec.pp     ;
    l_old_pp_version :=  l_child_rec.version;
    l_old_pp_key(1)  :=  l_child_rec.pp_key1;
    l_old_pp_key(2)  :=  l_child_rec.pp_key2;
    l_old_pp_key(3)  :=  l_child_rec.pp_key3;
    l_old_pp_key(4)  :=  l_child_rec.pp_key4;
    l_old_pp_key(5)  :=  l_child_rec.pp_key5;

    IF l_old_pp_key(P_PP_KEY4PLANT) != ' ' THEN --we are only interested in the plant specific child
                                                --when the plant has not become obsolete
       l_plant_is_obsolete := FALSE;
       --check if it has not been marked as obsolete in Interspec
       --does it come from interspec ?
       --check for the presence of the interspec_orig_name attribute
       SELECT COUNT(*)
       INTO l_count_fromis
       FROM utppau
       WHERE pp = l_newref_pp
       AND version = l_newref_pp_version
       AND pp_key1 = l_newref_pp_key(1)
       AND pp_key2 = l_newref_pp_key(2)
       AND pp_key3 = l_newref_pp_key(3)
       AND pp_key4 = l_newref_pp_key(4)
       AND pp_key5 = l_newref_pp_key(5)
       AND au = 'interspec_orig_name';
       IF l_count_fromis > 0 THEN
          --is it an obsolete plant in Interspec?
          SELECT COUNT(*)
          INTO l_count_plant_present
          FROM utstgk
          WHERE gk = 'plant'
          AND st = l_newref_pp_key(UNAPIGEN.P_PP_KEY4PRODUCT)
          AND version = l_newref_pp_version
          AND value = l_old_pp_key(P_PP_KEY4PLANT);
          IF l_count_plant_present = 0 THEN
             l_plant_is_obsolete := TRUE;
          END IF;
       END IF;

       IF NOT l_plant_is_obsolete THEN

         --The new version of the generated child must have the major version as the new reference pp
         --A new minor version (within that major version) will be generated when there are already some childs with the same major version

         --Find the highest existing version with the same major version as l_newref_pp
         l_temp_version := UNVERSION.SQLGetPpHighestMinorVersion(l_old_pp, l_newref_pp_version, l_old_pp_key(1), l_old_pp_key(2), l_old_pp_key(3), l_old_pp_key(4), l_old_pp_key(5) );
         IF NVL(l_temp_version, ' ') = ' ' THEN
            l_new_pp_version := l_newref_pp_version ; --same version as the reference object
         ELSE
            l_new_pp_version := UNVERSION.SQLGetNextMinorVersion(l_temp_version);
         END IF;
         l_new_pp           :=    l_old_pp         ;
         l_new_pp_key(1)    :=    l_old_pp_key(1)    ;
         l_new_pp_key(2)    :=    l_old_pp_key(2)    ;
         l_new_pp_key(3)    :=    l_old_pp_key(3)    ;
         l_new_pp_key(4)    :=    l_old_pp_key(4)    ;
         l_new_pp_key(5)    :=    l_old_pp_key(5)    ;

         --Create the new child
         l_ret_code  := CompareAndCreatePp
         (l_oldref_pp        ,
         l_oldref_pp_version,
         l_oldref_pp_key(1) ,
         l_oldref_pp_key(2) ,
         l_oldref_pp_key(3) ,
         l_oldref_pp_key(4) ,
         l_oldref_pp_key(5) ,
         l_newref_pp        ,
         l_newref_pp_version,
         l_newref_pp_key(1) ,
         l_newref_pp_key(2) ,
         l_newref_pp_key(3) ,
         l_newref_pp_key(4) ,
         l_newref_pp_key(5) ,
         l_old_pp           ,
         l_old_pp_version   ,
         l_old_pp_key(1)    ,
         l_old_pp_key(2)    ,
         l_old_pp_key(3)    ,
         l_old_pp_key(4)    ,
         l_old_pp_key(5)    ,
         l_new_pp           ,
         l_new_pp_version   ,
         l_new_pp_key(1)    ,
         l_new_pp_key(2)    ,
         l_new_pp_key(3)    ,
         l_new_pp_key(4)    ,
         l_new_pp_key(5)    ) ;
         IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
            UNAPIGEN.LogError('SynchronizeChildSpec', 'CompareAndCreatePp#ret_code='||l_ret_code);
            RAISE StpError;
         END IF;
      END IF;
   END IF;
END LOOP;

RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LogError('SynchronizeChildSpec', SQLERRM);
   END IF;
   IF ppkey_cursor%ISOPEN THEN
       CLOSE ppkey_cursor;  -- no plant pp_key
   END IF;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END SynchronizeChildSpec;

-- -----------------------------------------------------------------------------
/* This version SynchronizeDerivedSpec will synchronize the derived parameter profile

When triggered for a major version, this rule will automatically generate
a derived minor version based on the previous major version and on the
highest minor version for the previous major version

*/
FUNCTION SynchronizeDerivedSpec
RETURN NUMBER IS

l_oldref_pp          VARCHAR2(20);
l_oldref_pp_version  VARCHAR2(20);
l_oldref_pp_key      UNAPIGEN.VC20_TABLE_TYPE;
l_newref_pp          VARCHAR2(20);
l_newref_pp_version  VARCHAR2(20);
l_newref_pp_key      UNAPIGEN.VC20_TABLE_TYPE;
l_old_pp             VARCHAR2(20);
l_old_pp_version     VARCHAR2(20);
l_old_pp_key         UNAPIGEN.VC20_TABLE_TYPE;
l_new_pp             VARCHAR2(20);
l_new_pp_version     VARCHAR2(20);
l_new_pp_key         UNAPIGEN.VC20_TABLE_TYPE;

l_temp_version       VARCHAR2(20);
l_major_version      VARCHAR2(20);
l_minor_version      VARCHAR2(20);
l_lowest_minor_version VARCHAR2(20);

--There may be gaps between major versions transferred
--e.g: verion 12 is transferred but verion 11 was never transferred
--     version 10 must be used as parent in such a case
CURSOR l_prev_major_version_cursor(c_pp VARCHAR2, c_minor_version VARCHAR2, c_next_version VARCHAR2, c_pp_key1 VARCHAR2, c_pp_key2 VARCHAR2, c_pp_key3 VARCHAR2, c_pp_key4 VARCHAR2, c_pp_key5 VARCHAR2) IS
    SELECT MAX(version) version
    FROM utpp
    WHERE pp= c_pp
    AND pp_key1 = c_pp_key1
    AND pp_key2 = c_pp_key2
    AND pp_key3 = c_pp_key3
    AND pp_key4 = c_pp_key4
    AND pp_key5 = c_pp_key5
    AND SUBSTR(version, INSTR(version,'.') +1) = c_minor_version
    AND version < c_next_version;

--There may be gaps between major versions transferred
--e.g: verion 12 is transferred but verion 11 was never transferred
--     version 10 must be used as parent in such a case
CURSOR l_old_version_cursor(c_pp VARCHAR2, c_next_version VARCHAR2, c_pp_key1 VARCHAR2, c_pp_key2 VARCHAR2, c_pp_key3 VARCHAR2, c_pp_key4 VARCHAR2, c_pp_key5 VARCHAR2) IS
    SELECT MAX(version) version
    FROM utpp
    WHERE pp= c_pp
    AND pp_key1 = c_pp_key1
    AND pp_key2 = c_pp_key2
    AND pp_key3 = c_pp_key3
    AND pp_key4 = c_pp_key4
    AND pp_key5 = c_pp_key5
    AND version < c_next_version;

BEGIN

-- The key for the parameter profile for which the event rule has been triggered
-- is stored in l_newref_pp variables
l_newref_pp          := UNAPIEV.P_EV_REC.object_id;
l_newref_pp_version  := UNAPIEV.P_VERSION   ;
l_newref_pp_key(1)   := UNAPIEV.P_PP_KEY1   ;
l_newref_pp_key(2)   := UNAPIEV.P_PP_KEY2   ;
l_newref_pp_key(3)   := UNAPIEV.P_PP_KEY3   ;
l_newref_pp_key(4)   := UNAPIEV.P_PP_KEY4   ;
l_newref_pp_key(5)   := UNAPIEV.P_PP_KEY5   ;

--Check if the parameter profile is a major version
--exit the function when not a major version
--
l_minor_version := SUBSTR(l_newref_pp_version, INSTR(l_newref_pp_version,'.') +1);
-- look what the lowest minor version is (can be '00' or 'aa' or '000')
l_lowest_minor_version := SUBSTR(UNVERSION.SQLGetNextMajorVersion(l_newref_pp_version), INSTR(UNVERSION.SQLGetNextMajorVersion(l_newref_pp_version),'.') +1);
IF l_minor_version <> l_lowest_minor_version THEN
    --This function is only being called for new major versions (minor version = 00 ->version of interspec)
    RETURN(UNAPIGEN.DBERR_SUCCESS);
END IF;

-- Find the previous major version
-- exit the function when no previous major version
OPEN l_prev_major_version_cursor(l_newref_pp, l_lowest_minor_version, l_newref_pp_version, l_newref_pp_key(1), l_newref_pp_key(2), l_newref_pp_key(3),l_newref_pp_key(4),l_newref_pp_key(5));
FETCH l_prev_major_version_cursor
INTO l_oldref_pp_version;
IF l_oldref_pp_version IS NULL THEN
    CLOSE l_prev_major_version_cursor;
    RETURN(UNAPIGEN.DBERR_SUCCESS); --nothing to compare with
END IF;
CLOSE l_prev_major_version_cursor;

-- Find the highest minor version in previous major version
-- exit the function when no highest minor version in previous major version
OPEN l_old_version_cursor(l_newref_pp,  l_newref_pp_version, l_newref_pp_key(1), l_newref_pp_key(2), l_newref_pp_key(3),l_newref_pp_key(4),l_newref_pp_key(5));
FETCH l_old_version_cursor INTO l_old_pp_version;
IF l_old_pp_version IS NULL THEN
    CLOSE l_old_version_cursor;
    RETURN(UNAPIGEN.DBERR_SUCCESS); --nothing to compare with
END IF;
CLOSE l_old_version_cursor;

-- exit the function when "previous major version" = "highest minor version in previous major version"
IF l_old_pp_version = l_oldref_pp_version THEN
    --no subversion of the version of interspec
    RETURN(UNAPIGEN.DBERR_SUCCESS);
END IF;

--Generate the new version string for the pp that must be created
l_temp_version   := UNVERSION.SQLGetPpHighestMinorVersion(l_newref_pp, l_newref_pp_version, l_newref_pp_key(1), l_newref_pp_key(2), l_newref_pp_key(3),l_newref_pp_key(4),l_newref_pp_key(5));
l_new_pp_version := UNVERSION.SQLGetNextMinorVersion(l_temp_version);

--DEBUG ONLY
--DBMS_OUTPUT.PUT_LINE(l_oldref_pp_version || ' ; ' ||l_newref_pp_version|| ' ; ' ||l_old_pp_version || ' ; ' ||l_new_pp_version);
--Create the new pp
l_ret_code  := CompareAndCreatePp
        (l_newref_pp        ,
         l_oldref_pp_version,
         l_newref_pp_key(1) ,
         l_newref_pp_key(2) ,
         l_newref_pp_key(3) ,
         l_newref_pp_key(4) ,
         l_newref_pp_key(5) ,
         l_newref_pp        ,
         l_newref_pp_version,
         l_newref_pp_key(1) ,
         l_newref_pp_key(2) ,
         l_newref_pp_key(3) ,
         l_newref_pp_key(4) ,
         l_newref_pp_key(5) ,
         l_newref_pp           ,
         l_old_pp_version   ,
         l_newref_pp_key(1)    ,
         l_newref_pp_key(2)    ,
         l_newref_pp_key(3)    ,
         l_newref_pp_key(4)    ,
         l_newref_pp_key(5)    ,
         l_newref_pp           ,
         l_new_pp_version   ,
         l_newref_pp_key(1)    ,
         l_newref_pp_key(2)    ,
         l_newref_pp_key(3)    ,
         l_newref_pp_key(4)    ,
         l_newref_pp_key(5)    ) ;


IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
   UNAPIGEN.LogError('SynchronizeDerivedSpec', 'CompareAndCreatePp#ret_code='||l_ret_code);
   RAISE StpError;
END IF;
RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LogError('SynchronizeDerivedSpec', SQLERRM);
   END IF;
   IF l_prev_major_version_cursor%ISOPEN THEN
       CLOSE l_prev_major_version_cursor;
   END IF;
   IF l_old_version_cursor%ISOPEN THEN
       CLOSE l_old_version_cursor;
   END IF;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END SynchronizeDerivedSpec;

-- -----------------------------------------------------------------------------

FUNCTION SynchronizeDerivedSampleType
RETURN NUMBER IS

l_oldref_st          VARCHAR2(20);
l_oldref_st_version  VARCHAR2(20);
l_newref_st          VARCHAR2(20);
l_newref_st_version  VARCHAR2(20);
l_old_st             VARCHAR2(20);
l_old_st_version     VARCHAR2(20);
l_new_st             VARCHAR2(20);
l_new_st_version     VARCHAR2(20);

l_temp_version       VARCHAR2(20);
l_major_version      VARCHAR2(20);
l_minor_version      VARCHAR2(20);
l_lowest_minor_version VARCHAR2(20);

--There may be gaps between major versions transferred
--e.g: verion 12 is transferred but verion 11 was never transferred
--     version 10 must be used as parent in such a case
CURSOR l_prev_major_version_cursor(c_st VARCHAR2, c_minor_version VARCHAR2, c_next_version VARCHAR2) IS
    SELECT MAX(version) version
    FROM utst
    WHERE st= c_st
    AND SUBSTR(version, INSTR(version,'.') +1) = c_minor_version
    AND version < c_next_version;

--There may be gaps between major versions transferred
--e.g: verion 12 is transferred but verion 11 was never transferred
--     version 10 must be used as parent in such a case
CURSOR l_old_version_cursor(c_st VARCHAR2, c_next_version VARCHAR2) IS
    SELECT MAX(version) version
    FROM utst
    WHERE st= c_st
    AND version < c_next_version;

BEGIN

-- The key for the sample type for which the event rule has been triggered
-- is stored in l_newref_st variables
l_newref_st          := UNAPIEV.P_EV_REC.object_id;
l_newref_st_version  := UNAPIEV.P_VERSION   ;

--Check if the parameter profile is a major version
--exit the function when not a major version
--
l_minor_version := SUBSTR(l_newref_st_version, INSTR(l_newref_st_version,'.') +1);
-- look what the lowest minor version is (can be '00' or 'aa' or '000')
l_lowest_minor_version := SUBSTR(UNVERSION.SQLGetNextMajorVersion(l_newref_st_version), INSTR(UNVERSION.SQLGetNextMajorVersion(l_newref_st_version),'.') +1);
IF l_minor_version <> l_lowest_minor_version THEN
    --This function is only being called for new major versions (minor version = 00 ->version of interspec)
    RETURN(UNAPIGEN.DBERR_SUCCESS);
END IF;

-- Find the previous major version
-- exit the function when no previous major version
OPEN l_prev_major_version_cursor(l_newref_st, l_lowest_minor_version, l_newref_st_version);
FETCH l_prev_major_version_cursor
INTO l_oldref_st_version;
IF l_oldref_st_version IS NULL THEN
    CLOSE l_prev_major_version_cursor;
    RETURN(UNAPIGEN.DBERR_SUCCESS); --nothing to compare with
END IF;
CLOSE l_prev_major_version_cursor;

-- Find the highest minor version in previous major version
-- exit the function when no highest minor version in previous major version
OPEN l_old_version_cursor(l_newref_st,  l_newref_st_version);
FETCH l_old_version_cursor INTO l_old_st_version;
IF l_old_st_version IS NULL THEN
    CLOSE l_old_version_cursor;
    RETURN(UNAPIGEN.DBERR_SUCCESS); --nothing to compare with
END IF;
CLOSE l_old_version_cursor;

-- exit the function when "previous major version" = "highest minor version in previous major version"
IF l_old_st_version = l_oldref_st_version THEN
    --no subversion of the version of interspec
    RETURN(UNAPIGEN.DBERR_SUCCESS);
END IF;

--Generate the new version string for the st that must be created
l_temp_version   := UNVERSION.SQLGetHighestMinorVersion('st', l_newref_st, l_newref_st_version);
l_new_st_version := UNVERSION.SQLGetNextMinorVersion(l_temp_version);

--DEBUG ONLY
--DBMS_OUTPUT.PUT_LINE(l_oldref_pp_version || ' ; ' ||l_newref_pp_version|| ' ; ' ||l_old_pp_version || ' ; ' ||l_new_pp_version);
--Create the new pp
l_ret_code  := CompareAndCreateSt
                  (l_newref_st        ,
                   l_oldref_st_version,
                   l_newref_st        ,
                   l_newref_st_version,
                   l_newref_st        ,
                   l_old_st_version   ,
                   l_newref_st        ,
                   l_new_st_version);

IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
   UNAPIGEN.LogError('SynchronizeDerivedSampleType', 'CompareAndCreateSt#ret_code='||l_ret_code);
   RAISE StpError;
END IF;
RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LogError('SynchronizeDerivedSampleType', SQLERRM);
   END IF;
   IF l_prev_major_version_cursor%ISOPEN THEN
       CLOSE l_prev_major_version_cursor;
   END IF;
   IF l_old_version_cursor%ISOPEN THEN
       CLOSE l_old_version_cursor;
   END IF;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END SynchronizeDerivedSampleType;

FUNCTION SynchronizeDerivedParameter
RETURN NUMBER IS

l_oldref_pr          VARCHAR2(20);
l_oldref_pr_version  VARCHAR2(20);
l_newref_pr          VARCHAR2(20);
l_newref_pr_version  VARCHAR2(20);
l_old_pr             VARCHAR2(20);
l_old_pr_version     VARCHAR2(20);
l_new_pr             VARCHAR2(20);
l_new_pr_version     VARCHAR2(20);

l_temp_version       VARCHAR2(20);
l_major_version      VARCHAR2(20);
l_minor_version      VARCHAR2(20);
l_lowest_minor_version VARCHAR2(20);

--There may be gaps between major versions transferred
--e.g: verion 12 is transferred but verion 11 was never transferred
--     version 10 must be used as parent in such a case
CURSOR l_prev_major_version_cursor(c_pr VARCHAR2, c_minor_version VARCHAR2, c_next_version VARCHAR2) IS
    SELECT MAX(version) version
    FROM utpr
    WHERE pr= c_pr
    AND SUBSTR(version, INSTR(version,'.') +1) = c_minor_version
    AND version < c_next_version;

--There may be gaps between major versions transferred
--e.g: verion 12 is transferred but verion 11 was never transferred
--     version 10 must be used as parent in such a case
CURSOR l_old_version_cursor(c_pr VARCHAR2, c_next_version VARCHAR2) IS
    SELECT MAX(version) version
    FROM utpr
    WHERE pr= c_pr
    AND version < c_next_version;

BEGIN

-- The key for the parameter for which the event rule has been triggered
-- is stored in l_newref_pr variables
l_newref_pr          := UNAPIEV.P_EV_REC.object_id;
l_newref_pr_version  := UNAPIEV.P_VERSION   ;

--Check if the parameter  is a major version
--exit the function when not a major version
--
l_minor_version := SUBSTR(l_newref_pr_version, INSTR(l_newref_pr_version,'.') +1);
-- look what the lowest minor version is (can be '00' or 'aa' or '000')
l_lowest_minor_version := SUBSTR(UNVERSION.SQLGetNextMajorVersion(l_newref_pr_version), INSTR(UNVERSION.SQLGetNextMajorVersion(l_newref_pr_version),'.') +1);
IF l_minor_version <> l_lowest_minor_version THEN
    --This function is only being called for new major versions (minor version = 00 ->version of interspec)
    RETURN(UNAPIGEN.DBERR_SUCCESS);
END IF;

-- Find the previous major version
-- exit the function when no previous major version
OPEN l_prev_major_version_cursor(l_newref_pr, l_lowest_minor_version, l_newref_pr_version);
FETCH l_prev_major_version_cursor
INTO l_oldref_pr_version;
IF l_oldref_pr_version IS NULL THEN
    CLOSE l_prev_major_version_cursor;
    RETURN(UNAPIGEN.DBERR_SUCCESS); --nothing to compare with
END IF;
CLOSE l_prev_major_version_cursor;

-- Find the highest minor version in previous major version
-- exit the function when no highest minor version in previous major version
OPEN l_old_version_cursor(l_newref_pr,  l_newref_pr_version);
FETCH l_old_version_cursor INTO l_old_pr_version;
IF l_old_pr_version IS NULL THEN
    CLOSE l_old_version_cursor;
    RETURN(UNAPIGEN.DBERR_SUCCESS); --nothing to compare with
END IF;
CLOSE l_old_version_cursor;

-- exit the function when "previous major version" = "highest minor version in previous major version"
IF l_old_pr_version = l_oldref_pr_version THEN
    --no subversion of the version of interspec
    RETURN(UNAPIGEN.DBERR_SUCCESS);
END IF;

--Generate the new version string for the pr that must be created
l_temp_version   := UNVERSION.SQLGetHighestMinorVersion('pr', l_newref_pr, l_newref_pr_version);
l_new_pr_version := UNVERSION.SQLGetNextMinorVersion(l_temp_version);

--DEBUG ONLY
--DBMS_OUTPUT.PUT_LINE(l_oldref_pr_version || ' ; ' ||l_newref_pr_version|| ' ; ' ||l_old_pr_version || ' ; ' ||l_new_pr_version);
--Create the new pp
l_ret_code  := CompareAndCreatePr
                  (l_newref_pr        ,
                   l_oldref_pr_version,
                   l_newref_pr        ,
                   l_newref_pr_version,
                   l_newref_pr        ,
                   l_old_pr_version   ,
                   l_newref_pr        ,
                   l_new_pr_version);

IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
   UNAPIGEN.LogError('SynchronizeDerivedParameter', 'CompareAndCreatePr#ret_code='||l_ret_code);
   RAISE StpError;
END IF;
RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LogError('SynchronizeDerivedParameter', SQLERRM);
   END IF;
   IF l_prev_major_version_cursor%ISOPEN THEN
       CLOSE l_prev_major_version_cursor;
   END IF;
   IF l_old_version_cursor%ISOPEN THEN
       CLOSE l_old_version_cursor;
   END IF;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END SynchronizeDerivedParameter;
-- -----------------------------------------------------------------------------

FUNCTION CompareAndCreatePr
(a_oldref_pr           IN     VARCHAR2,       /* VC20_TYPE */
 a_oldref_pr_version   IN     VARCHAR2,       /* VC20_TYPE */
 a_newref_pr           IN     VARCHAR2,       /* VC20_TYPE */
 a_newref_pr_version   IN     VARCHAR2,       /* VC20_TYPE */
 a_old_pr              IN     VARCHAR2,       /* VC20_TYPE */
 a_old_pr_version      IN     VARCHAR2,       /* VC20_TYPE */
 a_new_pr              IN     VARCHAR2,       /* VC20_TYPE */
 a_new_pr_version      IN     VARCHAR2)       /* VC20_TYPE */
RETURN NUMBER IS

l_seq                            NUMBER(5);
l_prev_mt                        VARCHAR2(20);
l_order_modified_in_oldpr        CHAR(1);
l_max_seq_in_new_pr              NUMBER(5);
l_reorder_seq                    NUMBER(5);
l_error_logged                   BOOLEAN;
l_entered_loop                   BOOLEAN;
l_orig_seq                       INTEGER;
l_some_mt_appended_in_oldpr      BOOLEAN;
l_reorder_took_place             BOOLEAN;
l_count_follows_not_common1      INTEGER;
l_count_follows_not_common2      INTEGER;

--utpr cursors and variables
CURSOR l_utpr_cursor (c_pr IN VARCHAR2,
                      c_pr_version IN VARCHAR2) IS
SELECT *
FROM utpr
WHERE pr = c_pr
AND version = c_pr_version;
l_oldref_utpr_rec   l_utpr_cursor%ROWTYPE;
l_newref_utpr_rec   l_utpr_cursor%ROWTYPE;
l_old_utpr_rec      l_utpr_cursor%ROWTYPE;
l_new_utpr_rec      l_utpr_cursor%ROWTYPE;

--utprau cursors and variables
--assumption: au_version always NULL
CURSOR l_new_utprau_cursor IS
   --all attributes in oldpr
   --and that have not been suppressed in newref
   -- Part1= 1 (NOT IN 2) AND IN 3
   -- 1= all attributes in the old_pr
   -- old_pr has some differences with oldref, these modifications must be kept
   -- the subqueries are returning these differences
   -- 2= list of attributes that have been suppressed from oldref to make the final old_pr
   -- 3= list of attribute values that have not been modified between OLD_REF and OLD (values will be taken from NEW when applicable)
   --
   /* 1 */
   SELECT au, value
     FROM utprau
    WHERE pr = a_old_pr
      AND version = a_old_pr_version
    /* 2 */
    AND au NOT IN (SELECT au
                   FROM utprau
                   WHERE pr = a_old_pr
                     AND version = a_old_pr_version
                   INTERSECT
                     (SELECT au
                      FROM utprau
                      WHERE pr = a_oldref_pr
                        AND version = a_oldref_pr_version
                      MINUS
                      SELECT au
                      FROM utprau
                      WHERE pr = a_newref_pr
                        AND version = a_newref_pr_version
                     )
                   )
    /* 3 */
    --test might seem strange but is alo good for single valued attributes
    --The attribute values are not compared one by one but the list of values are compared
    --LOV are compared here
    --subquery is returning any attribute where the LOV has been modified
    --test is inverted here (would result in two times NOT IN)
    --subquery returns all attributes for which the list of values has been modified in OLD compared to OLD_REF
    AND au IN (SELECT DISTINCT au FROM
                     ((SELECT au, value
                       FROM utprau
                       WHERE pr = a_old_pr
                         AND version = a_old_pr_version
                       UNION
                       SELECT au, value
                       FROM utprau
                       WHERE pr = a_oldref_pr
                         AND version = a_oldref_pr_version
                       )
                      MINUS
                      (SELECT au, value
                       FROM utprau
                       WHERE pr = a_old_pr
                         AND version = a_old_pr_version
                       INTERSECT
                       SELECT au, value
                       FROM utprau
                       WHERE pr = a_oldref_pr
                         AND version = a_oldref_pr_version
                      )
                     )
               )
   UNION
   --all attributes in newref that are not already in oldpr
   --and that have not been suppressed
   -- Part2= 1 (NOT IN 2)
   -- 1= all attributes in the newref_pr
   -- newref_pr has some differences with oldref, these modifications must be kept
   -- the subqueries are returning these differences
   -- 2= list of attributes that are already in old_pr or that have been suppressed from oldref to make the final old_pr
   /* 1 */
   SELECT au, value
   FROM utprau
   WHERE pr = a_newref_pr
     AND version = a_newref_pr_version
   /* 2 */
   AND au NOT IN (SELECT au
                  FROM utprau
                  WHERE pr = a_old_pr
                    AND version = a_old_pr_version)
   AND au NOT IN (SELECT au
                  FROM utprau
                  WHERE pr = a_oldref_pr
                    AND version = a_oldref_pr_version
                  INTERSECT
                  SELECT au
                  FROM utprau
                  WHERE pr = a_newref_pr
                    AND version = a_newref_pr_version)
   UNION
   --Add all attributes in newref that are already in oldpr
   --that have not been updated in oldpr
   --and that have not been suppressed
   -- Part3= 1 (NOT IN 2)
   -- 1= all attributes in the newref_pr
   -- 2= list of attributes that have been changed between OLD_REF and OLD
   --LOV are compared here
   --subquery is returning any attribute where the LOV has been modified
   --subquery returns all attributes for which the list of values has been modified in OLD compared to OLD_REF
   /* 1 */
   SELECT au, value
   FROM utprau
   WHERE pr = a_newref_pr
     AND version = a_newref_pr_version
   /* 2 */
    AND au NOT IN (SELECT DISTINCT au FROM
                     ((SELECT au, value
                       FROM utprau
                       WHERE pr = a_old_pr
                         AND version = a_old_pr_version
                       UNION
                       SELECT au, value
                       FROM utprau
                       WHERE pr = a_oldref_pr
                         AND version = a_oldref_pr_version
                       )
                      MINUS
                      (SELECT au, value
                       FROM utprau
                       WHERE pr = a_old_pr
                         AND version = a_old_pr_version
                       INTERSECT
                       SELECT au, value
                       FROM utprau
                       WHERE pr = a_oldref_pr
                         AND version = a_oldref_pr_version
                      )
                     )
               )
   ORDER BY au, value;

--utprmt cursors and variables
CURSOR l_prmtls_cursor IS
SELECT *
FROM utprmt
WHERE pr = a_newref_pr
  AND version = a_newref_pr_version
  AND (pr, mt, mt_version) IN
   (SELECT pr, mt, mt_version
   FROM utprmt
   WHERE pr = a_newref_pr
     AND version = a_newref_pr_version
   UNION
   (SELECT pr, mt, mt_version
    FROM utprmt
    WHERE pr = a_old_pr
      AND version = a_old_pr_version
    MINUS
    SELECT pr, mt, mt_version
    FROM utprmt
    WHERE pr = a_oldref_pr
      AND version = a_oldref_pr_version)
   MINUS
   (SELECT pr, mt, mt_version
    FROM utprmt
    WHERE pr = a_oldref_pr
      AND version = a_oldref_pr_version
    MINUS
    SELECT pr, mt, mt_version
    FROM utprmt
    WHERE pr = a_old_pr
      AND version = a_old_pr_version))
   ORDER BY seq;

--utprmt cursors and variables
CURSOR l_prcystls_cursor IS
   --all cy from newref
   SELECT pr, cy, cy_version, st, st_version
   FROM utprcyst
   WHERE pr = a_newref_pr
     AND version = a_newref_pr_version
   --add all cy that have been added in Unilab
   UNION
   (SELECT pr, cy, cy_version, st, st_version
    FROM utprcyst
    WHERE pr = a_old_pr
      AND version = a_old_pr_version
    MINUS
    SELECT pr, cy, cy_version, st, st_version
    FROM utprcyst
    WHERE pr = a_oldref_pr
      AND version = a_oldref_pr_version)
   --remove all cy that have been deleted in Unilab
   MINUS
   (SELECT pr, cy, cy_version, st, st_version
    FROM utprcyst
    WHERE pr = a_oldref_pr
      AND version = a_oldref_pr_version
    MINUS
    SELECT pr, cy, cy_version, st, st_version
    FROM utprcyst
    WHERE pr = a_old_pr
      AND version = a_old_pr_version)
   ORDER BY cy, st;

--This cursor is searching for the same method in a parameter
--with the same relative position
--
-- Example: pr1 v1.0                  pr1 v2.0
--          seq 1 mt1 rel_pos=1       seq 1 mt1 rel_pos=1
--          seq 2 mt2 rel_pos=1       seq 2 mt1 rel_pos=2
--          seq 3 mt1 rel_pos=2
-- The second mt1 method in pr1 v1.0 has the same relative position as
-- the second mt1 method but they have different sequences.
-- This query allows to perform search in function of relative positions
--
-- Note that 2 methods with different mt_version are considered as different methods
--
CURSOR l_utprmt_cursor (c_pr IN VARCHAR2,
                        c_pr_version IN VARCHAR2,
                        c_mt         IN VARCHAR2,
                        c_mt_version IN VARCHAR2,
                        c_seq        IN NUMBER) IS
SELECT a.*
FROM utprmt a
WHERE (a.pr, a.version, a.mt, a.mt_version, a.seq) IN
(SELECT k.pr, k.version, k.mt, k.mt_version, k.seq
 FROM
    (SELECT ROWNUM relpos, b.pr, b.version, b.mt, b.mt_version, b.seq
    FROM
       (SELECT c.pr, c.version, c.mt, c.mt_version, c.seq
       FROM utprmt c
       WHERE c.pr = a_newref_pr
       AND c.version = a_newref_pr_version
       AND c.mt = c_mt
       AND c.mt_version = c_mt_version
       GROUP BY c.pr, c.version, c.mt, c.mt_version, c.seq) b) z,
    (SELECT ROWNUM relpos, b.pr, b.version, b.mt, b.mt_version, b.seq
    FROM
       (SELECT c.pr, c.version, c.mt, c.mt_version, c.seq
       FROM utprmt c
       WHERE c.pr = c_pr
       AND c.version = c_pr_version
       AND c.mt = c_mt
       AND c.mt_version = c_mt_version
       GROUP BY c.pr, c.version, c.mt, c.mt_version, c.seq) b) k
    WHERE k.relpos = z.relpos
    AND z.seq = c_seq)
ORDER BY a.seq;
l_oldref_utprmt_rec   utprmt%ROWTYPE;
l_newref_utprmt_rec   utprmt%ROWTYPE;
l_old_utprmt_rec      utprmt%ROWTYPE;
l_new_utprmt_rec      utprmt%ROWTYPE;

--utprmtau cursors and variables
--assumptions: au_version always NULL, pr_version ignored since 2 pr with diferent pr_version may not have different attributes
CURSOR l_new_utprmtau_cursor IS
   --all attributes in oldpr
   --and that have not been suppressed in newref
   -- (attibutes can have been suppressed or parameters can have been suppressed)
   -- Part1= 1 (NOT IN 2) AND IN 3 AND IN 4 AND (NOT IN 5)
   -- 1= all attributes in the old_pr
   -- old_pr has some differences with oldref, these modifications must be kept
   -- the subqueries are returning these differences
   -- 2= list of attributes that have been suppressed from oldref to make the final old_pr
   -- 3= list of parameters that have been suppressed from oldref to make the final old_pr
   -- 4= list of attribute values that have not been modified between OLD_REF and OLD (values will be taken from NEW when applicable)
   --
   /* 1 */
   SELECT mt, au, value
     FROM utprmtau
    WHERE pr = a_old_pr
      AND version = a_old_pr_version
      /* 2 */
      AND (mt, au) NOT IN (SELECT mt, au
                    FROM utprmtau
                    WHERE pr = a_old_pr
                      AND version = a_old_pr_version
                    INTERSECT
                      (SELECT mt, au
                       FROM utprmtau
                       WHERE pr = a_oldref_pr
                         AND version = a_oldref_pr_version
                       MINUS
                       SELECT mt, au
                       FROM utprmtau
                       WHERE pr = a_newref_pr
                         AND version = a_newref_pr_version))
      /* 3 */
      AND mt NOT IN (SELECT mt
                    FROM utprmt
                    WHERE pr = a_old_pr
                      AND version = a_old_pr_version
                    INTERSECT
                      (SELECT mt
                       FROM utprmt
                       WHERE pr = a_oldref_pr
                         AND version = a_oldref_pr_version
                       MINUS
                       SELECT mt
                       FROM utprmt
                       WHERE pr = a_newref_pr
                         AND version = a_newref_pr_version))
      /* 4 */
      --test might seem strange but is also good for single valued attributes
      --The attribute values are not compared one by one but the list of values are compared
      --LOV are compared here
      --subquery is returning any attribute where the LOV has been modified
      --test is inverted here (would result in two times NOT IN)
      --subquery returns all attributes for which the list of values has been modified in OLD compared to OLD_REF
      AND (mt, au)
           IN (SELECT DISTINCT mt, au
                 FROM ((SELECT mt, au, value
                          FROM utprmtau
                          WHERE pr = a_old_pr
                            AND version = a_old_pr_version
                        UNION
                        SELECT mt, au, value
                          FROM utprmtau
                         WHERE pr = a_oldref_pr
                           AND version = a_oldref_pr_version
                       )
                       MINUS
                       (SELECT mt, au, value
                          FROM utprmtau
                          WHERE pr = a_old_pr
                            AND version = a_old_pr_version
                        INTERSECT
                        SELECT mt, au, value
                          FROM utprmtau
                         WHERE pr = a_oldref_pr
                           AND version = a_oldref_pr_version
                       )
                      )
                   )
   UNION
   --all attributes in newref that are not already in oldpr
   --and that have not been suppressed
   -- (attibutes can have been suppressed or parameters can have been suppressed)
   -- Part2= 1 (NOT IN 2) AND (NOT IN 3)
   -- 1= all attributes in the newref_pr
   -- newref_pr has some differences with oldref, these modifications must be kept
   -- the subqueries are returning these differences
   -- 2= list of attributes that are already in old_pr or that have been suppressed from oldref to make the final old_pr
   -- 3= list of parameters deleted from oldref to make old_pr
   --
   /* 1 */
   SELECT mt, au, value
   FROM utprmtau
   WHERE pr = a_newref_pr
     AND version = a_newref_pr_version
     /* 2 */
     AND (mt, au)
          NOT IN (SELECT mt, au
                  FROM utprmtau
                  WHERE pr = a_old_pr
                    AND version = a_old_pr_version
                  )
     AND (mt, au)
          NOT IN (SELECT mt, au
                  FROM utprmtau
                  WHERE pr = a_oldref_pr
                    AND version = a_oldref_pr_version
                  MINUS
                  SELECT mt, au
                  FROM utprmtau
                  WHERE pr = a_old_pr
                    AND version = a_old_pr_version
                 )
  /* 3 */
  AND mt
      NOT IN (SELECT mt
              FROM utprmt
              WHERE pr = a_oldref_pr
                AND version = a_oldref_pr_version
              MINUS
              SELECT mt
              FROM utprmt
              WHERE pr = a_old_pr
                AND version = a_old_pr_version
             )
   UNION
   --Add all attributes in newref that are already in oldpr
   --that have not been updated in oldpr
   --and that have not been suppressed
   -- Part3= 1 (NOT IN 2) AND (NOT IN 3)
   -- 1= all attributes in the newref_pr
   -- 2= list of attributes that have been changed between OLD_REF and OLD
   -- 3= list of suppressed parameters
   --LOV are compared here
   --subquery is returning any attribute where the LOV has been modified
   --subquery returns all attributes for which the list of values has been modified in OLD compared to OLD_REF
   /* 1 */
   SELECT mt, au, value
   FROM utprmtau
   WHERE pr = a_newref_pr
     AND version = a_newref_pr_version
   /* 2 */
   AND (mt, au)
        NOT IN (SELECT DISTINCT mt, au FROM
                     ((SELECT mt, au, value
                       FROM utprmtau
                       WHERE pr = a_old_pr
                         AND version = a_old_pr_version
                       UNION
                       SELECT mt, au, value
                       FROM utprmtau
                       WHERE pr = a_oldref_pr
                         AND version = a_oldref_pr_version
                      )
                     MINUS
                     (SELECT mt, au, value
                       FROM utprmtau
                       WHERE pr = a_old_pr
                         AND version = a_old_pr_version
                       INTERSECT
                       SELECT mt, au, value
                       FROM utprmtau
                       WHERE pr = a_oldref_pr
                         AND version = a_oldref_pr_version
                      )
                     )
               )
   /* 3 */
   AND mt
       NOT IN (SELECT mt
                 FROM utprmt
                 WHERE pr = a_oldref_pr
                   AND version = a_oldref_pr_version
               MINUS
               SELECT mt
               FROM utprmt
                       WHERE pr = a_old_pr
                         AND version = a_old_pr_version
              )
   ORDER BY mt, au, value;



CURSOR l_old_prmt_cursor IS
    SELECT * FROM utprmt
    WHERE pr = a_old_pr
      AND version = a_old_pr_version
      AND (pr, mt, mt_version) NOT IN
      (SELECT pr, mt, mt_version
        FROM utprmt
        WHERE pr = a_newref_pr
            AND version = a_newref_pr_version
       UNION
       SELECT pr, mt, mt_version
        FROM utprmt
        WHERE pr = a_oldref_pr
        AND version = a_oldref_pr_version);

CURSOR l_new_prmtseq IS
    SELECT NVL(MAX(seq), 0) +1
    FROM utprmt
    WHERE pr = a_new_pr
        AND version = a_new_pr_version;


CURSOR l_reorder_follow_old_cursor (c_max_seq IN NUMBER) IS
SELECT mt, seq, '1' from_old
FROM utprmt
WHERE pr = a_old_pr
  AND version = a_old_pr_version
UNION ALL --(ALL is important for duplos)
SELECT zzz.mt, NVL(before_seq_in_old-0.5 , NVL(after_seq_in_old+0.5, c_max_seq+seq)) seq, '2' from_old
FROM
(
SELECT DISTINCT x.mt, x.seq,
FIRST_VALUE(z.seq_in_old) OVER
   (PARTITION BY x.mt, x.seq ORDER BY  x.seq ASC, z.seq_in_newref ASC nulls last ) before_seq_in_old,
--FIRST_VALUE(z.seq_in_newref) OVER
--   (PARTITION BY x.mt, x.seq ORDER BY  x.seq ASC, z.seq_in_newref ASC nulls last ) before_seq_in_newref,
--FIRST_VALUE(z.mt) OVER
--   (PARTITION BY x.mt, x.seq ORDER BY  x.seq ASC, z.seq_in_newref ASC nulls last ) before_mt,
FIRST_VALUE(y.seq_in_old) OVER
   (PARTITION BY x.mt, x.seq ORDER BY  x.seq ASC, y.seq_in_newref DESC nulls last ) after_seq_in_old --,
--FIRST_VALUE(y.seq_in_newref) OVER
--   (PARTITION BY x.mt, x.seq ORDER BY  x.seq ASC, y.seq_in_newref DESC nulls last ) after_seq_in_newref,
--FIRST_VALUE(y.mt) OVER
--   (PARTITION BY x.mt, x.seq ORDER BY  x.seq ASC, y.seq_in_newref DESC nulls last ) after_mt
FROM
    (--list of mt, seq existing in old_pr and in newref_pr and their seq
     SELECT a.mt, MIN(a.seq) seq_in_old, MIN(b.seq) seq_in_newref
     FROM utprmt a, utprmt b
     WHERE a.pr = a_old_pr
       AND a.version = a_old_pr_version
       AND b.pr = a_newref_pr
       AND b.version = a_newref_pr_version
       AND a.mt = b.mt
     GROUP BY a.mt) z,
    (--list of mt, seq existing in old_pr and in newref_pr and their seq
     SELECT a.mt, MIN(a.seq) seq_in_old, MIN(b.seq) seq_in_newref
     FROM utprmt a, utprmt b
     WHERE a.pr = a_old_pr
       AND a.version = a_old_pr_version
       AND b.pr = a_newref_pr
       AND b.version = a_newref_pr_version
       AND a.mt = b.mt
     GROUP BY a.mt) y,
    utprmt x
 WHERE x.pr = a_newref_pr
   AND x.version = a_newref_pr_version
   AND x.seq < z.seq_in_newref (+)
   AND x.seq > y.seq_in_newref (+)
   AND x.mt NOT IN (SELECT j.mt
                    FROM utprmt j
                    WHERE j.pr = a_newref_pr
                      AND j.version = a_newref_pr_version
                    INTERSECT
                    SELECT k.mt
                    FROM utprmt k
                    WHERE k.pr = a_old_pr
                      AND k.version = a_old_pr_version)
 ORDER BY  x.seq, x.mt
) zzz
ORDER BY seq, from_old, mt;

CURSOR l_reorder_follow_newref_cursor (c_max_seq IN NUMBER) IS
SELECT mt, seq,
      '1' from_newref
FROM utprmt
WHERE pr = a_newref_pr
  AND version = a_newref_pr_version
UNION ALL --(ALL is important for duplos)
SELECT zzz.mt, NVL(before_seq_in_newref-0.5 , NVL(after_seq_in_newref+0.5, c_max_seq+seq)) seq,
       '2' from_newref
FROM
(
SELECT DISTINCT x.mt, x.seq,
--FIRST_VALUE(z.seq_in_old) OVER
--   (PARTITION BY x.mt, x.seq ORDER BY  x.seq ASC, z.seq_in_newref ASC nulls last ) before_seq_in_old,
FIRST_VALUE(z.seq_in_newref) OVER
   (PARTITION BY x.mt, x.seq ORDER BY  x.seq ASC, z.seq_in_newref ASC nulls last ) before_seq_in_newref,
--FIRST_VALUE(z.mt) OVER
--   (PARTITION BY x.mt, x.seq ORDER BY  x.seq ASC, z.seq_in_newref ASC nulls last ) before_mt,
--FIRST_VALUE(y.seq_in_old) OVER
--   (PARTITION BY x.mt, x.seq ORDER BY  x.seq ASC, y.seq_in_newref DESC nulls last ) after_seq_in_old,
FIRST_VALUE(y.seq_in_newref) OVER
   (PARTITION BY x.mt, x.seq ORDER BY  x.seq ASC, y.seq_in_newref DESC nulls last ) after_seq_in_newref --,
--FIRST_VALUE(y.mt) OVER
--   (PARTITION BY x.mt, x.seq ORDER BY  x.seq ASC, y.seq_in_newref DESC nulls last ) after_mt
FROM
    (--list of mt, seq existing in old_pr and in newref_pr and theri seq
     SELECT a.mt, MIN(a.seq) seq_in_old, MIN(b.seq) seq_in_newref
     FROM utprmt a, utprmt b
     WHERE a.pr = a_old_pr
       AND a.version = a_old_pr_version
       AND b.pr = a_newref_pr
       AND b.version = a_newref_pr_version
       AND a.mt = b.mt
     GROUP BY a.mt) z,
    (--list of mt, seq existing in old_pr and in newref_pr and theri seq
     SELECT a.mt, MIN(a.seq) seq_in_old, MIN(b.seq) seq_in_newref
     FROM utprmt a, utprmt b
     WHERE a.pr = a_old_pr
       AND a.version = a_old_pr_version
       AND b.pr = a_newref_pr
       AND b.version = a_newref_pr_version
       AND a.mt = b.mt
     GROUP BY a.mt) y,
    utprmt x
 WHERE x.pr = a_old_pr
   AND x.version = a_old_pr_version
   AND x.seq < z.seq_in_old (+)
   AND x.seq > y.seq_in_old (+)
   AND x.mt NOT IN (SELECT j.mt
                    FROM utprmt j
                    WHERE j.pr = a_newref_pr
                      AND j.version = a_newref_pr_version
                    INTERSECT
                    SELECT k.mt
                    FROM utprmt k
                    WHERE k.pr = a_old_pr
                      AND k.version = a_old_pr_version)
 ORDER BY  x.seq, x.mt
) zzz
ORDER BY seq, from_newref, mt;

CURSOR l_reorder_corr_prmtseq_cursor  IS
SELECT a.mt, a.seq, a.rowid
FROM utprmt a
WHERE a.pr = a_new_pr
  AND a.version = a_new_pr_version
  AND a.seq < 0
  ORDER BY a.seq
FOR UPDATE;

CURSOR l_order_nogaps_prmtseq_cursor IS
SELECT a.mt, a.seq
FROM utprmt a
WHERE a.pr = a_new_pr
  AND a.version = a_new_pr_version
  ORDER BY a.seq
FOR UPDATE;


--comment out when you want to perform the InsertEvent
--   -- Local variables for 'InsertEvent' API
--   l_api_name                    VARCHAR2(40);
--   l_evmgr_name                  VARCHAR2(20);
--   l_object_tp                   VARCHAR2(4);
--   l_object_id                   VARCHAR2(20);
--   l_object_lc                   VARCHAR2(2);
--   l_object_lc_version           VARCHAR2(20);
--   l_object_ss                   VARCHAR2(2);
--   l_ev_tp                       VARCHAR2(60);
--   l_ev_details                  VARCHAR2(255);
--   l_seq_nr                      NUMBER;

BEGIN

   l_some_mt_appended_in_oldpr:=FALSE;
   l_sqlerrm := NULL;
   IF UNAPIGEN.BeginTxn(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE StpError;
   END IF;

/* DEBUG ONLY */
--DBMS_OUTPUT.PUT_LINE('oldref: ' ||a_oldref_pr||' ; '||a_oldref_pr_version);
--DBMS_OUTPUT.PUT_LINE('newref: ' ||a_newref_pr||' ; '||a_newref_pr_version);
--DBMS_OUTPUT.PUT_LINE('old: ' ||a_old_pr||' ; '||a_old_pr_version);
--DBMS_OUTPUT.PUT_LINE('new: ' ||a_new_pr||' ; '||a_new_pr_version);
/* END OF DEBUG ONLY */

   /*-------------------*/
   /* Compare utpr      */
   /*-------------------*/
   --fetch 3 utpr records
   OPEN l_utpr_cursor(a_oldref_pr, a_oldref_pr_version);
   FETCH l_utpr_cursor
   INTO l_oldref_utpr_rec;
   IF l_utpr_cursor%NOTFOUND THEN
      CLOSE l_utpr_cursor;
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      RAISE STpError;
   END IF;
   CLOSE l_utpr_cursor;

   OPEN l_utpr_cursor(a_newref_pr, a_newref_pr_version);
   FETCH l_utpr_cursor
   INTO l_newref_utpr_rec;
   IF l_utpr_cursor%NOTFOUND THEN
      CLOSE l_utpr_cursor;
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      RAISE STpError;
   END IF;
   CLOSE l_utpr_cursor;

   OPEN l_utpr_cursor(a_old_pr, a_old_pr_version);
   FETCH l_utpr_cursor
   INTO l_old_utpr_rec;
   IF l_utpr_cursor%NOTFOUND THEN
      CLOSE l_utpr_cursor;
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      RAISE STpError;
   END IF;
   CLOSE l_utpr_cursor;

   OPEN l_utpr_cursor(a_new_pr, a_new_pr_version);
   FETCH l_utpr_cursor
   INTO l_new_utpr_rec;
   IF l_utpr_cursor%FOUND THEN
      CLOSE l_utpr_cursor;
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_ALREADYEXISTS;
      RAISE STpError;
   END IF;
   CLOSE l_utpr_cursor;

   --compare
   --columns not compared: pr, version, ss, allow_modify, active, ar[1-128],
   --                      effective_from, version_is_current, effective_till
   l_new_utpr_rec := l_newref_utpr_rec;
   IF NVL((l_old_utpr_rec.description <> l_oldref_utpr_rec.description), TRUE) AND NOT(l_old_utpr_rec.description IS NULL AND l_oldref_utpr_rec.description IS NULL)  THEN
      l_new_utpr_rec.description := l_old_utpr_rec.description;
   END IF;
   IF NVL((l_old_utpr_rec.description2 <> l_oldref_utpr_rec.description2), TRUE) AND NOT(l_old_utpr_rec.description2 IS NULL AND l_oldref_utpr_rec.description2 IS NULL)  THEN
      l_new_utpr_rec.description2 := l_old_utpr_rec.description2;
   END IF;
   IF NVL((l_old_utpr_rec.unit <> l_oldref_utpr_rec.unit), TRUE) AND NOT(l_old_utpr_rec.unit IS NULL AND l_oldref_utpr_rec.unit IS NULL)  THEN
      l_new_utpr_rec.unit := l_old_utpr_rec.unit;
   END IF;
   IF NVL((l_old_utpr_rec.format <> l_oldref_utpr_rec.format), TRUE) AND NOT(l_old_utpr_rec.format IS NULL AND l_oldref_utpr_rec.format IS NULL)  THEN
      l_new_utpr_rec.format := l_old_utpr_rec.format;
   END IF;
   IF NVL((l_old_utpr_rec.td_info <> l_oldref_utpr_rec.td_info), TRUE) AND NOT(l_old_utpr_rec.td_info IS NULL AND l_oldref_utpr_rec.td_info IS NULL)  THEN
      l_new_utpr_rec.td_info := l_old_utpr_rec.td_info;
   END IF;
   IF NVL((l_old_utpr_rec.td_info_unit <> l_oldref_utpr_rec.td_info_unit), TRUE) AND NOT(l_old_utpr_rec.td_info_unit IS NULL AND l_oldref_utpr_rec.td_info_unit IS NULL)  THEN
      l_new_utpr_rec.td_info_unit := l_old_utpr_rec.td_info_unit;
   END IF;
   IF NVL((l_old_utpr_rec.confirm_uid <> l_oldref_utpr_rec.confirm_uid), TRUE) AND NOT(l_old_utpr_rec.confirm_uid IS NULL AND l_oldref_utpr_rec.confirm_uid IS NULL)  THEN
      l_new_utpr_rec.confirm_uid := l_old_utpr_rec.confirm_uid;
   END IF;
   IF NVL((l_old_utpr_rec.def_val_tp <> l_oldref_utpr_rec.def_val_tp), TRUE) AND NOT(l_old_utpr_rec.def_val_tp IS NULL AND l_oldref_utpr_rec.def_val_tp IS NULL)  THEN
      l_new_utpr_rec.def_val_tp := l_old_utpr_rec.def_val_tp;
   END IF;
   IF NVL((l_old_utpr_rec.def_au_level <> l_oldref_utpr_rec.def_au_level), TRUE) AND NOT(l_old_utpr_rec.def_au_level IS NULL AND l_oldref_utpr_rec.def_au_level IS NULL)  THEN
      l_new_utpr_rec.def_au_level := l_old_utpr_rec.def_au_level;
   END IF;
   IF NVL((l_old_utpr_rec.def_val <> l_oldref_utpr_rec.def_val), TRUE) AND NOT(l_old_utpr_rec.def_val IS NULL AND l_oldref_utpr_rec.def_val IS NULL)  THEN
      l_new_utpr_rec.def_val := l_old_utpr_rec.def_val;
   END IF;
   IF NVL((l_old_utpr_rec.allow_any_mt <> l_oldref_utpr_rec.allow_any_mt), TRUE) AND NOT(l_old_utpr_rec.allow_any_mt IS NULL AND l_oldref_utpr_rec.allow_any_mt IS NULL)  THEN
      l_new_utpr_rec.allow_any_mt := l_old_utpr_rec.allow_any_mt;
   END IF;
   IF NVL((l_old_utpr_rec.delay <> l_oldref_utpr_rec.delay), TRUE) AND NOT(l_old_utpr_rec.delay IS NULL AND l_oldref_utpr_rec.delay IS NULL)  THEN
      l_new_utpr_rec.delay := l_old_utpr_rec.delay;
   END IF;
   IF NVL((l_old_utpr_rec.delay_unit <> l_oldref_utpr_rec.delay_unit), TRUE) AND NOT(l_old_utpr_rec.delay_unit IS NULL AND l_oldref_utpr_rec.delay_unit IS NULL)  THEN
      l_new_utpr_rec.delay_unit := l_old_utpr_rec.delay_unit;
   END IF;
   IF NVL((l_old_utpr_rec.min_nr_results <> l_oldref_utpr_rec.min_nr_results), TRUE) AND NOT(l_old_utpr_rec.min_nr_results IS NULL AND l_oldref_utpr_rec.min_nr_results IS NULL)  THEN
      l_new_utpr_rec.min_nr_results := l_old_utpr_rec.min_nr_results;
   END IF;
   IF NVL((l_old_utpr_rec.calc_method <> l_oldref_utpr_rec.calc_method), TRUE) AND NOT(l_old_utpr_rec.calc_method IS NULL AND l_oldref_utpr_rec.calc_method IS NULL)  THEN
      l_new_utpr_rec.calc_method := l_old_utpr_rec.calc_method;
   END IF;
   IF NVL((l_old_utpr_rec.calc_cf <> l_oldref_utpr_rec.calc_cf), TRUE) AND NOT(l_old_utpr_rec.calc_cf IS NULL AND l_oldref_utpr_rec.calc_cf IS NULL)  THEN
      l_new_utpr_rec.calc_cf := l_old_utpr_rec.calc_cf;
   END IF;
   IF NVL((l_old_utpr_rec.alarm_order <> l_oldref_utpr_rec.alarm_order), TRUE) AND NOT(l_old_utpr_rec.alarm_order IS NULL AND l_oldref_utpr_rec.alarm_order IS NULL)  THEN
      l_new_utpr_rec.alarm_order := l_old_utpr_rec.alarm_order;
   END IF;
   IF NVL((l_old_utpr_rec.seta_specs <> l_oldref_utpr_rec.seta_specs), TRUE) AND NOT(l_old_utpr_rec.seta_specs IS NULL AND l_oldref_utpr_rec.seta_specs IS NULL)  THEN
      l_new_utpr_rec.seta_specs := l_old_utpr_rec.seta_specs;
   END IF;
   IF NVL((l_old_utpr_rec.seta_limits <> l_oldref_utpr_rec.seta_limits), TRUE) AND NOT(l_old_utpr_rec.seta_limits IS NULL AND l_oldref_utpr_rec.seta_limits IS NULL)  THEN
      l_new_utpr_rec.seta_limits := l_old_utpr_rec.seta_limits;
   END IF;
   IF NVL((l_old_utpr_rec.seta_target <> l_oldref_utpr_rec.seta_target), TRUE) AND NOT(l_old_utpr_rec.seta_target IS NULL AND l_oldref_utpr_rec.seta_target IS NULL)  THEN
      l_new_utpr_rec.seta_target := l_old_utpr_rec.seta_target;
   END IF;
   IF NVL((l_old_utpr_rec.setb_specs <> l_oldref_utpr_rec.setb_specs), TRUE) AND NOT(l_old_utpr_rec.setb_specs IS NULL AND l_oldref_utpr_rec.setb_specs IS NULL)  THEN
      l_new_utpr_rec.setb_specs := l_old_utpr_rec.setb_specs;
   END IF;
   IF NVL((l_old_utpr_rec.setb_limits <> l_oldref_utpr_rec.setb_limits), TRUE) AND NOT(l_old_utpr_rec.setb_limits IS NULL AND l_oldref_utpr_rec.setb_limits IS NULL)  THEN
      l_new_utpr_rec.setb_limits := l_old_utpr_rec.setb_limits;
   END IF;
   IF NVL((l_old_utpr_rec.setb_target <> l_oldref_utpr_rec.setb_target), TRUE) AND NOT(l_old_utpr_rec.setb_target IS NULL AND l_oldref_utpr_rec.setb_target IS NULL)  THEN
      l_new_utpr_rec.setb_target := l_old_utpr_rec.setb_target;
   END IF;
   IF NVL((l_old_utpr_rec.setc_specs <> l_oldref_utpr_rec.setc_specs), TRUE) AND NOT(l_old_utpr_rec.setc_specs IS NULL AND l_oldref_utpr_rec.setc_specs IS NULL)  THEN
      l_new_utpr_rec.setc_specs := l_old_utpr_rec.setc_specs;
   END IF;
   IF NVL((l_old_utpr_rec.setc_limits <> l_oldref_utpr_rec.setc_limits), TRUE) AND NOT(l_old_utpr_rec.setc_limits IS NULL AND l_oldref_utpr_rec.setc_limits IS NULL)  THEN
      l_new_utpr_rec.setc_limits := l_old_utpr_rec.setc_limits;
   END IF;
   IF NVL((l_old_utpr_rec.setc_target <> l_oldref_utpr_rec.setc_target), TRUE) AND NOT(l_old_utpr_rec.setc_target IS NULL AND l_oldref_utpr_rec.setc_target IS NULL)  THEN
      l_new_utpr_rec.setc_target := l_old_utpr_rec.setc_target;
   END IF;
   IF NVL((l_old_utpr_rec.is_template <> l_oldref_utpr_rec.is_template), TRUE) AND NOT(l_old_utpr_rec.is_template IS NULL AND l_oldref_utpr_rec.is_template IS NULL)  THEN
      l_new_utpr_rec.is_template := l_old_utpr_rec.is_template;
   END IF;
   IF NVL((l_old_utpr_rec.log_exceptions <> l_oldref_utpr_rec.log_exceptions), TRUE) AND NOT(l_old_utpr_rec.log_exceptions IS NULL AND l_oldref_utpr_rec.log_exceptions IS NULL)  THEN
      l_new_utpr_rec.log_exceptions := l_old_utpr_rec.log_exceptions;
   END IF;
   IF NVL((l_old_utpr_rec.sc_lc <> l_oldref_utpr_rec.sc_lc), TRUE) AND NOT(l_old_utpr_rec.sc_lc IS NULL AND l_oldref_utpr_rec.sc_lc IS NULL)  THEN
      l_new_utpr_rec.sc_lc := l_old_utpr_rec.sc_lc;
   END IF;
   IF NVL((l_old_utpr_rec.sc_lc_version <> l_oldref_utpr_rec.sc_lc_version), TRUE) AND NOT(l_old_utpr_rec.sc_lc_version IS NULL AND l_oldref_utpr_rec.sc_lc_version IS NULL)  THEN
      l_new_utpr_rec.sc_lc_version := l_old_utpr_rec.sc_lc_version;
   END IF;
   IF NVL((l_old_utpr_rec.inherit_au <> l_oldref_utpr_rec.inherit_au), TRUE) AND NOT(l_old_utpr_rec.inherit_au IS NULL AND l_oldref_utpr_rec.inherit_au IS NULL)  THEN
      l_new_utpr_rec.inherit_au := l_old_utpr_rec.inherit_au;
   END IF;
   IF NVL((l_old_utpr_rec.last_comment <> l_oldref_utpr_rec.last_comment), TRUE) AND NOT(l_old_utpr_rec.last_comment IS NULL AND l_oldref_utpr_rec.last_comment IS NULL)  THEN
      l_new_utpr_rec.last_comment := l_old_utpr_rec.last_comment;
   END IF;
   IF NVL((l_old_utpr_rec.pr_class <> l_oldref_utpr_rec.pr_class), TRUE) AND NOT(l_old_utpr_rec.pr_class IS NULL AND l_oldref_utpr_rec.pr_class IS NULL)  THEN
      l_new_utpr_rec.pr_class := l_old_utpr_rec.pr_class;
   END IF;
   IF NVL((l_old_utpr_rec.log_hs <> l_oldref_utpr_rec.log_hs), TRUE) AND NOT(l_old_utpr_rec.log_hs IS NULL AND l_oldref_utpr_rec.log_hs IS NULL)  THEN
      l_new_utpr_rec.log_hs := l_old_utpr_rec.log_hs;
   END IF;
   IF NVL((l_old_utpr_rec.log_hs_details <> l_oldref_utpr_rec.log_hs_details), TRUE) AND NOT(l_old_utpr_rec.log_hs_details IS NULL AND l_oldref_utpr_rec.log_hs_details IS NULL)  THEN
      l_new_utpr_rec.log_hs_details := l_old_utpr_rec.log_hs_details;
   END IF;
   IF NVL((l_old_utpr_rec.lc <> l_oldref_utpr_rec.lc), TRUE) AND NOT(l_old_utpr_rec.lc IS NULL AND l_oldref_utpr_rec.lc IS NULL)  THEN
      l_new_utpr_rec.lc := l_old_utpr_rec.lc;
   END IF;
   IF NVL((l_old_utpr_rec.lc_version <> l_oldref_utpr_rec.lc_version), TRUE) AND NOT(l_old_utpr_rec.lc_version IS NULL AND l_oldref_utpr_rec.lc_version IS NULL)  THEN
      l_new_utpr_rec.lc_version := l_old_utpr_rec.lc_version;
   END IF;

   --insert the record in utpr
   --special cases: version_is_current, effective_till

   l_ret_code := UNAPIPR.SaveParameter
                   (a_new_pr,
                    a_new_pr_version,
                    NULL,
                    l_new_utpr_rec.effective_from,
                    NULL,
                    l_new_utpr_rec.description,
                    l_new_utpr_rec.description2,
                    l_new_utpr_rec.unit,
                    l_new_utpr_rec.format,
                    l_new_utpr_rec.td_info,
                    l_new_utpr_rec.td_info_unit,
                    l_new_utpr_rec.confirm_uid,
                    l_new_utpr_rec.def_val_tp,
                    l_new_utpr_rec.def_au_level,
                    l_new_utpr_rec.def_val,
                    l_new_utpr_rec.allow_any_mt,
                    l_new_utpr_rec.delay,
                    l_new_utpr_rec.delay_unit,
                    l_new_utpr_rec.min_nr_results,
                    l_new_utpr_rec.calc_method,
                    l_new_utpr_rec.calc_cf,
                    l_new_utpr_rec.alarm_order,
                    l_new_utpr_rec.seta_specs,
                    l_new_utpr_rec.seta_limits,
                    l_new_utpr_rec.seta_target,
                    l_new_utpr_rec.setb_specs,
                    l_new_utpr_rec.setb_limits,
                    l_new_utpr_rec.setb_target,
                    l_new_utpr_rec.setc_specs,
                    l_new_utpr_rec.setc_limits,
                    l_new_utpr_rec.setc_target,
                    l_new_utpr_rec.is_template,
                    l_new_utpr_rec.log_exceptions,
                    l_new_utpr_rec.sc_lc,
                    l_new_utpr_rec.sc_lc_version,
                    l_new_utpr_rec.inherit_au,
                    l_new_utpr_rec.pr_class,
                    l_new_utpr_rec.log_hs,
                    l_new_utpr_rec.lc,
                    l_new_utpr_rec.lc_version,
                    '');
   IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
      l_sqlerrm := 'SaveParameter ret_code='||l_ret_code||'#pr='||a_new_pr
                   ||'#version='||a_new_pr_version;
      RAISE StpError;
   END IF;

   /*-------------------*/
   /* Compare utprau    */
   /*-------------------*/
   --Build up the list of pr and compare properties
   l_seq := 0;
   FOR l_new_utprau_rec IN l_new_utprau_cursor LOOP

      --insert the records in utprau
      --special cases: au_version always NULL
      l_seq := l_seq+1;
      INSERT INTO utprau
      (pr, version,
       au, au_version, auseq, value)
      VALUES
      (a_new_pr, a_new_pr_version,
       l_new_utprau_rec.au, NULL, l_seq, l_new_utprau_rec.value);
   END LOOP;

   /*---------------------*/
   /* Compare utprcyst    */
   /*---------------------*/
   --Build up the list of cy and compare properties
   FOR l_newref_utprcyst_rec IN l_prcystls_cursor LOOP
      --insert the record in utprcyst
      INSERT INTO utprcyst
      (pr, version,
       cy,  cy_version,
       st,  st_version)
      VALUES
      (a_new_pr, a_new_pr_version,
       l_newref_utprcyst_rec.cy, l_newref_utprcyst_rec.cy_version,
       l_newref_utprcyst_rec.st, l_newref_utprcyst_rec.st_version);
   END LOOP;
   /* TO TEST: cy added in old */

   /*-------------------*/
   /* Compare utprmt    */
   /*-------------------*/
   --Build up the list of pr and compare properties
   FOR l_newref_utprmt_rec IN l_prmtls_cursor LOOP

      --fetch the corresponding record in other pr with the same relative position
      l_oldref_utprmt_rec := NULL;
      OPEN l_utprmt_cursor(a_oldref_pr, a_oldref_pr_version,
                           l_newref_utprmt_rec.mt, l_newref_utprmt_rec.mt_version, l_newref_utprmt_rec.seq);
      FETCH l_utprmt_cursor
      INTO l_oldref_utprmt_rec;
      CLOSE l_utprmt_cursor;

      l_old_utprmt_rec := NULL;
      OPEN l_utprmt_cursor(a_old_pr, a_old_pr_version,
                           l_newref_utprmt_rec.mt, l_newref_utprmt_rec.mt_version, l_newref_utprmt_rec.seq);
      FETCH l_utprmt_cursor
      INTO l_old_utprmt_rec;
      CLOSE l_utprmt_cursor;

      --compare
      --columns not compared: pr, version, mt, mt_version, seq
      --might be a special case in some project but not handled: last_sched, last_count, last_val
      l_new_utprmt_rec := l_newref_utprmt_rec;
      IF NVL((l_old_utprmt_rec.nr_measur <> l_oldref_utprmt_rec.nr_measur), TRUE) AND NOT(l_old_utprmt_rec.nr_measur IS NULL AND l_oldref_utprmt_rec.nr_measur IS NULL)  THEN
         l_new_utprmt_rec.nr_measur := l_old_utprmt_rec.nr_measur;
      END IF;
      IF NVL((l_old_utprmt_rec.unit <> l_oldref_utprmt_rec.unit), TRUE) AND NOT(l_old_utprmt_rec.unit IS NULL AND l_oldref_utprmt_rec.unit IS NULL)  THEN
         l_new_utprmt_rec.unit := l_old_utprmt_rec.unit;
      END IF;
      IF NVL((l_old_utprmt_rec.format <> l_oldref_utprmt_rec.format), TRUE) AND NOT(l_old_utprmt_rec.format IS NULL AND l_oldref_utprmt_rec.format IS NULL)  THEN
         l_new_utprmt_rec.format := l_old_utprmt_rec.format;
      END IF;
      IF NVL((l_old_utprmt_rec.allow_add <> l_oldref_utprmt_rec.allow_add), TRUE) AND NOT(l_old_utprmt_rec.allow_add IS NULL AND l_oldref_utprmt_rec.allow_add IS NULL)  THEN
         l_new_utprmt_rec.allow_add := l_old_utprmt_rec.allow_add;
      END IF;
      IF NVL((l_old_utprmt_rec.ignore_other <> l_oldref_utprmt_rec.ignore_other), TRUE) AND NOT(l_old_utprmt_rec.ignore_other IS NULL AND l_oldref_utprmt_rec.ignore_other IS NULL)  THEN
         l_new_utprmt_rec.ignore_other := l_old_utprmt_rec.ignore_other;
      END IF;
      IF NVL((l_old_utprmt_rec.accuracy <> l_oldref_utprmt_rec.accuracy), TRUE) AND NOT(l_old_utprmt_rec.accuracy IS NULL AND l_oldref_utprmt_rec.accuracy IS NULL)  THEN
         l_new_utprmt_rec.accuracy := l_old_utprmt_rec.accuracy;
      END IF;
      IF NVL((l_old_utprmt_rec.freq_tp <> l_oldref_utprmt_rec.freq_tp), TRUE) AND NOT(l_old_utprmt_rec.freq_tp IS NULL AND l_oldref_utprmt_rec.freq_tp IS NULL)  THEN
         l_new_utprmt_rec.freq_tp := l_old_utprmt_rec.freq_tp;
      END IF;
      IF NVL((l_old_utprmt_rec.freq_val <> l_oldref_utprmt_rec.freq_val), TRUE) AND NOT(l_old_utprmt_rec.freq_val IS NULL AND l_oldref_utprmt_rec.freq_val IS NULL)  THEN
         l_new_utprmt_rec.freq_val := l_old_utprmt_rec.freq_val;
      END IF;
      IF NVL((l_old_utprmt_rec.freq_unit <> l_oldref_utprmt_rec.freq_unit), TRUE) AND NOT(l_old_utprmt_rec.freq_unit IS NULL AND l_oldref_utprmt_rec.freq_unit IS NULL)  THEN
         l_new_utprmt_rec.freq_unit := l_old_utprmt_rec.freq_unit;
      END IF;
      IF NVL((l_old_utprmt_rec.invert_freq <> l_oldref_utprmt_rec.invert_freq), TRUE) AND NOT(l_old_utprmt_rec.invert_freq IS NULL AND l_oldref_utprmt_rec.invert_freq IS NULL)  THEN
         l_new_utprmt_rec.invert_freq := l_old_utprmt_rec.invert_freq;
      END IF;
      IF NVL((l_old_utprmt_rec.st_based_freq <> l_oldref_utprmt_rec.st_based_freq), TRUE) AND NOT(l_old_utprmt_rec.st_based_freq IS NULL AND l_oldref_utprmt_rec.st_based_freq IS NULL)  THEN
         l_new_utprmt_rec.st_based_freq := l_old_utprmt_rec.st_based_freq;
      END IF;
      --IF NVL((l_old_utprmt_rec.last_sched <> l_oldref_utprmt_rec.last_sched), TRUE) AND NOT(l_old_utprmt_rec.last_sched IS NULL AND l_oldref_utprmt_rec.last_sched IS NULL)  THEN
      --   l_new_utprmt_rec.last_sched := l_old_utprmt_rec.last_sched;
      --END IF;
      l_new_utprmt_rec.last_sched := NULL;
      --IF NVL((l_old_utprmt_rec.last_cnt <> l_oldref_utprmt_rec.last_cnt), TRUE) AND NOT(l_old_utprmt_rec.last_cnt IS NULL AND l_oldref_utprmt_rec.last_cnt IS NULL)  THEN
      --   l_new_utprmt_rec.last_cnt := l_old_utprmt_rec.last_cnt;
      --END IF;
      l_new_utprmt_rec.last_cnt := 0;
      --IF NVL((l_old_utprmt_rec.last_val <> l_oldref_utprmt_rec.last_val), TRUE) AND NOT(l_old_utprmt_rec.last_val IS NULL AND l_oldref_utprmt_rec.last_val IS NULL)  THEN
      --   l_new_utprmt_rec.last_val := l_old_utprmt_rec.last_val;
      --END IF;
      l_new_utprmt_rec.last_val := NULL;
      IF NVL((l_old_utprmt_rec.inherit_au <> l_oldref_utprmt_rec.inherit_au), TRUE) AND NOT(l_old_utprmt_rec.inherit_au IS NULL AND l_oldref_utprmt_rec.inherit_au IS NULL)  THEN
         l_new_utprmt_rec.inherit_au := l_old_utprmt_rec.inherit_au;
      END IF;

      --insert the record in utprmt
      INSERT INTO utprmt
      (pr, version,  mt,  mt_version,  seq,
       nr_measur, unit,  format, allow_add,
       ignore_other,  accuracy,
       freq_tp,  freq_val,  freq_unit,  invert_freq,
       st_based_freq, last_sched, last_sched_tz,
       last_cnt,  last_val,  inherit_au)
      VALUES
      (a_new_pr, a_new_pr_version, l_new_utprmt_rec.mt, l_new_utprmt_rec.mt_version, l_new_utprmt_rec.seq,
       l_new_utprmt_rec.nr_measur, l_new_utprmt_rec.unit, l_new_utprmt_rec.format, l_new_utprmt_rec.allow_add,
       l_new_utprmt_rec.ignore_other, l_new_utprmt_rec.accuracy,
       l_new_utprmt_rec.freq_tp, l_new_utprmt_rec.freq_val, l_new_utprmt_rec.freq_unit, l_new_utprmt_rec.invert_freq,
       l_new_utprmt_rec.st_based_freq, l_new_utprmt_rec.last_sched, l_new_utprmt_rec.last_sched,
       l_new_utprmt_rec.last_cnt, l_new_utprmt_rec.last_val, l_new_utprmt_rec.inherit_au);

   END LOOP;

   /*---------------------*/
   /* Compare utprmtau    */
   /*---------------------*/
   --Build up the list of pr and compare properties
   l_seq := 0;
   FOR l_new_utprmtau_rec IN l_new_utprmtau_cursor LOOP
      --insert the records in utprmtau
      --special cases: pr_version is the result of a MAX and au_version always NULL
      --reset auseq on new pr
      IF l_prev_mt <> l_new_utprmtau_rec.mt THEN
         l_seq := 0;
      END IF;
      l_seq := l_seq+1;
      l_prev_mt := l_new_utprmtau_rec.mt;
       --special cases: pr_version is the result of a MAX and au_version always NULL
      INSERT INTO utprmtau
      (pr, version,
       mt, mt_version, au, au_version, auseq, value)
      VALUES
      (a_new_pr, a_new_pr_version,
       l_new_utprmtau_rec.mt, NULL, l_new_utprmtau_rec.au, NULL, l_seq, l_new_utprmtau_rec.value);
   END LOOP;

   --insert the mt's that were added in the old pr and that are not present in the ref pr
   FOR l_new_utprmt_rec IN l_old_prmt_cursor LOOP
      l_some_mt_appended_in_oldpr:=TRUE;
      OPEN l_new_prmtseq;
      FETCH l_new_prmtseq INTO l_seq;
      CLOSE l_new_prmtseq;
      --insert the record in utprmt
      l_new_utprmt_rec.last_sched := NULL;
      l_new_utprmt_rec.last_cnt := 0;
      l_new_utprmt_rec.last_val := NULL;
      INSERT INTO utprmt
      (pr, version,  mt,  mt_version,  seq,
       nr_measur, unit,  format, allow_add,
       ignore_other,  accuracy,
       freq_tp,  freq_val,  freq_unit,  invert_freq,
       st_based_freq, last_sched, last_sched_tz,
       last_cnt,  last_val,  inherit_au)
      VALUES
      (a_new_pr, a_new_pr_version, l_new_utprmt_rec.mt, l_new_utprmt_rec.mt_version, l_seq,
       l_new_utprmt_rec.nr_measur, l_new_utprmt_rec.unit, l_new_utprmt_rec.format, l_new_utprmt_rec.allow_add,
       l_new_utprmt_rec.ignore_other, l_new_utprmt_rec.accuracy,
       l_new_utprmt_rec.freq_tp, l_new_utprmt_rec.freq_val, l_new_utprmt_rec.freq_unit, l_new_utprmt_rec.invert_freq,
       l_new_utprmt_rec.st_based_freq, l_new_utprmt_rec.last_sched, l_new_utprmt_rec.last_sched,
       l_new_utprmt_rec.last_cnt, l_new_utprmt_rec.last_val, l_new_utprmt_rec.inherit_au);
   END LOOP;

   --Fill in pr_version in utprmtau with MAX(pr_version)
   --since NULL is not tolerated by our client application
   UPDATE utprmtau a
   SET a.mt_version = (SELECT MAX(b.mt_version)
                       FROM utprmt b
                       WHERE b.pr = a_new_pr
                       AND b.version = a_new_pr_version
                       AND b.mt = a.mt)
   WHERE a.pr = a_new_pr
   AND a.version = a_new_pr_version;

   --determine which order to use
   --when the relative order has not been modified in in old_pr, the order
   --of mt's in pr is the similar to the order of mt's in newref_pr
   --when the relative order has been modified in in old_pr, the order
   --of mt's in pr is the similar to the order of mt's in old_pr
   -- Example1:
   --      oldref_pr: pr1 v1.0 - 1.mtA  2.mtB  3.mtC  4.mtD
   --      old_pr:    pr1 v1.1 - 1.mtA  2.mtD  3.mtC  4.mtB           <<< ORDER CHANGED
   --      newref_pr: pr1 v2.0 - 1.mtA  2.mtB  3.mtE  4.mtC  5.mtD
   --      new_pr:    pr1 v1.1 - 1.mtA  2.mtD  3.mtC  4.mtB  5.mtE
   -- Example2:
   --      oldref_pr: pr1 v1.0 - 1.mtA  2.mtB  3.mtC  4.mtD
   --      old_pr:    pr1 v1.1 - 1.mtA  2.mtD  3.mtC  4.mtB           <<< ORDER CHANGED
   --      newref_pr: pr1 v2.0 - 1.mtA  2.mtB  3.mtC  4.mtD  5.mtE
   --      new_pr:    pr1 v1.1 - 1.mtA  2.mtD  3.mtE  4.mtC  5.mtB
   -- Example3:
   --      oldref_pr: pr1 v1.0 - 1.mtA  2.mtB  3.mtC  4.mtD
   --      old_pr:    pr1 v1.1 -        1.mtB  2.mtC  3.mtD  4.mtE       (relative order kept here)
   --      newref_pr: pr1 v2.0 - 1.mtA  2.mtD  3.mtC  4.mtB           <<< ORDER CHANGED
   --      new_pr:    pr1 v1.1 -        1.mtD  2.mtE  3.mtC  4.mtB
   -- Example4:
   --      oldref_pr: pr1 v1.0 - 1.mtA  2.mtB  3.mtC  4.mtD
   --      old_pr:    pr1 v1.1 - 1.mtA  2.mtD  3.mtC  4.mtB           <<< ORDER CHANGED *
   --      newref_pr: pr1 v2.0 - 1.mtB  2.mtA  3.mtC  4.mtD  5.mtE    <<< ORDER CHANGED
   --      new_pr:    pr1 v1.1 - 1.mtA  2.mtD  3.mtE  4.mtC  5.mtB    *= winning order

   --Is the relative order changed in old_pr when comparing it to oldref_pr ?
   --The following query will return no record (no data found raised when somthing is found
   l_order_modified_in_oldpr := 'N';
   IF c_keep_newversion_prmt_order = '0' THEN

         --the 2 following queries is checking that all possible 'follows' relation
         --present in one pr are also present in the other for the pr's
         --that are common to the 2
         --
         --It is enough that one of the 2 is containing the possible 'follows'
         -- relation of the other to be sure that the order has not changed between the 2
         SELECT COUNT(*)
         INTO l_count_follows_not_common1
         FROM
            (SELECT DISTINCT PRIOR mt , a.mt FROM
               (SELECT aa.mt, ROWNUM rel_pos FROM
                  (SELECT MAX(mt) mt  FROM utprmt
                   WHERE pr=a_oldref_pr AND version=a_oldref_pr_version
                     AND mt IN (SELECT mt
                                FROM utprmt
                                WHERE pr=a_oldref_pr AND version=a_oldref_pr_version
                                INTERSECT
                                SELECT mt
                                FROM utprmt
                                WHERE pr=a_old_pr AND version=a_old_pr_version)
                  GROUP  BY seq) aa) a
              CONNECT BY PRIOR a.rel_pos <= a.rel_pos-1 AND PRIOR a.mt <> a.mt AND LEVEL <=2
              MINUS
              SELECT DISTINCT PRIOR mt , a.mt FROM
                 (SELECT aa.mt, ROWNUM rel_pos FROM
                    (SELECT MAX(mt) mt  FROM utprmt
                     WHERE pr=a_old_pr AND version=a_old_pr_version
                       AND mt IN (SELECT mt
                                  FROM utprmt
                                  WHERE pr=a_oldref_pr AND version=a_oldref_pr_version
                                  INTERSECT
                                  SELECT mt
                                  FROM utprmt
                                  WHERE pr=a_old_pr AND version=a_old_pr_version)
                    GROUP  BY seq) aa) a
              CONNECT BY PRIOR a.rel_pos <= a.rel_pos-1 AND PRIOR a.mt <> a.mt AND LEVEL <=2);

         SELECT COUNT(*)
         INTO l_count_follows_not_common2
         FROM
            (SELECT DISTINCT PRIOR mt , a.mt FROM
               (SELECT aa.mt, ROWNUM rel_pos FROM
                  (SELECT MAX(mt) mt  FROM utprmt
                     WHERE pr=a_old_pr AND version=a_old_pr_version
                       AND mt IN (SELECT mt
                                    FROM utprmt
                                   WHERE pr=a_oldref_pr AND version=a_oldref_pr_version
                                   INTERSECT
                                   SELECT mt FROM
                                   utprmt
                                   WHERE pr=a_old_pr AND version=a_old_pr_version)
                  GROUP  BY seq) aa) a
              CONNECT BY PRIOR a.rel_pos <= a.rel_pos-1 AND PRIOR a.mt <> a.mt AND LEVEL <=2
              MINUS
              SELECT DISTINCT PRIOR mt , a.mt FROM
                 (SELECT aa.mt, ROWNUM rel_pos FROM
                    (SELECT MAX(mt) mt  FROM UTprmt
                     WHERE pr=a_oldref_pr AND version=a_oldref_pr_version
                       AND mt IN (SELECT mt
                                  FROM utprmt
                                  WHERE pr=a_oldref_pr AND version=a_oldref_pr_version
                                  INTERSECT
                                  SELECT mt FROM utprmt WHERE pr=a_old_pr AND version=a_old_pr_version)
                    GROUP  BY seq) aa) a
              CONNECT BY PRIOR a.rel_pos <= a.rel_pos-1 AND PRIOR a.mt <> a.mt AND LEVEL <=2);
         IF l_count_follows_not_common1 > 0 AND
            l_count_follows_not_common2 > 0 THEN
            l_order_modified_in_oldpr := 'Y';
-- DEBUG ONLY
--DBMS_OUTPUT.PUT_LINE('Order modified');
--ELSE
--DBMS_OUTPUT.PUT_LINE('Order not modified');

         END IF;
--code left for interested customers
/*
      BEGIN
         SELECT 'Y'
         INTO l_order_modified_in_oldpr
         FROM dual
         WHERE EXISTS
         (
            (SELECT a.mt, a.rel_pos, b.mt, b.rel_pos FROM
               (SELECT aa.mt, ROWNUM rel_pos FROM
                  (SELECT mt  FROM utprmt
                   WHERE pr=a_oldref_pr AND version=a_oldref_pr_version
                     AND mt IN (SELECT mt
                                FROM utprmt
                                WHERE pr=a_oldref_pr AND version=a_oldref_pr_version
                                INTERSECT
                                SELECT mt FROM utprmt WHERE pr=a_old_pr AND version=a_old_pr_version)
                  GROUP BY seq, mt) aa) a,
               (SELECT bb.mt, ROWNUM rel_pos FROM
                  (SELECT mt  FROM utprmt
                  WHERE pr=a_oldref_pr AND version=a_oldref_pr_version
                     AND mt IN (SELECT mt
                                FROM utprmt
                                WHERE pr=a_oldref_pr AND version=a_oldref_pr_version
                                INTERSECT
                                SELECT mt FROM utprmt WHERE pr=a_old_pr AND version=a_old_pr_version)
                  ORDER BY seq, mt) bb) b
            WHERE b.rel_pos = a.rel_pos+1)
            MINUS
            (SELECT  DISTINCT mt, mt_rel_pos, next_mt,  next_mt_rel_pos FROM
            (SELECT a.mt mt , a.rel_pos mt_rel_pos, b.mt next_mt, b.rel_pos next_mt_rel_pos,
                                PRIOR z.mt prior_mt, PRIOR z.rel_pos prior_mt_rel_pos, z.mt next_mt_2, z.rel_pos next_mt_rel_pos_2, LEVEL my_level  FROM
               (SELECT aa.mt, ROWNUM rel_pos FROM
                  (SELECT mt  FROM utprmt
                   WHERE pr=a_oldref_pr AND version=a_oldref_pr_version
                     AND mt IN (SELECT mt
                                FROM utprmt
                                WHERE pr=a_oldref_pr AND version=a_oldref_pr_version
                                INTERSECT
                                SELECT mt FROM utprmt WHERE pr=a_old_pr AND version=a_old_pr_version)
                  ORDER BY seq, mt) aa) a,
               (SELECT bb.mt, ROWNUM rel_pos FROM
                  (SELECT mt  FROM utprmt
                   WHERE pr=a_oldref_pr AND version=a_oldref_pr_version
                     AND mt IN (SELECT mt
                                FROM utprmt
                                WHERE pr=a_oldref_pr AND version=a_oldref_pr_version
                                INTERSECT
                                SELECT mt FROM utprmt
                                WHERE pr=a_old_pr AND version=a_old_pr_version)
                  ORDER BY seq, mt) bb) b,
               (SELECT zz.mt, ROWNUM rel_pos FROM
                  (SELECT mt FROM utprmt
                   WHERE pr=a_old_pr AND version=a_old_pr_version
                           AND mt IN (SELECT mt
                                FROM utprmt
                                WHERE pr=a_oldref_pr AND version=a_oldref_pr_version
                                INTERSECT
                                SELECT mt FROM utprmt
                                WHERE pr=a_old_pr AND version=a_old_pr_version)
                  ORDER BY seq, mt) zz) z
            WHERE b.rel_pos = a.rel_pos+1
            START WITH (z.mt = a.mt AND a.rel_pos=1)
            CONNECT BY PRIOR z.rel_pos  < z.rel_pos AND z.mt = b.mt AND b.rel_pos = LEVEL
            )
            WHERE prior_mt IS NOT NULL)
         );
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         l_order_modified_in_oldpr := 'N';
      END;
*/


   END IF;

   l_reorder_took_place := FALSE;
   IF l_order_modified_in_oldpr = 'Y' THEN

      l_reorder_took_place := TRUE;
      --sort according to order in oldpr
      --TraceError('UNDIFF.CompareAndCreatepr','(debug) order modified according to oldpr');

      SELECT NVL(MAX(a.seq),0)+1
      INTO l_max_seq_in_new_pr
      FROM utprmt a
      WHERE a.pr = a_new_pr
      AND a.version = a_new_pr_version;

      --turn all sequence to a negative value to avoid the unique constraint index violations
      UPDATE utprmt a
      SET a.seq = -seq
      WHERE a.pr = a_new_pr
      AND a.version = a_new_pr_version;

      l_reorder_seq := 0;
      l_error_logged := FALSE;
      FOR l_reorder_rec IN l_reorder_follow_old_cursor(l_max_seq_in_new_pr) LOOP
         BEGIN

            SELECT MAX(b.seq)
            INTO l_orig_seq
            FROM utprmt b
            WHERE b.pr = a_new_pr
            AND b.version = a_new_pr_version
            AND b.mt = l_reorder_rec.mt
            AND b.seq < 0;
--DEBUG ONLY
--DBMS_OUTPUT.PUT_LINE('mt='||l_reorder_rec.mt||'#seq'||l_reorder_rec.seq||'#orig_seq='||l_orig_seq);

            l_reorder_seq := l_reorder_seq+1;
            UPDATE utprmt a
            SET a.seq = l_reorder_seq
            WHERE a.pr = a_new_pr
            AND a.version = a_new_pr_version
            AND a.mt = l_reorder_rec.mt
            AND a.seq = l_orig_seq;

            -- No check on SQL%ROWCOUNT since cursor is also returning the deleted records.
         EXCEPTION
         WHEN OTHERS THEN
            --the parameter is present more than once or the seq is already used
            IF l_error_logged = FALSE THEN
               TraceError('UNDIFF.CompareAndCreatePr','SQLERRM='||SQLERRM);
               TraceError('UNDIFF.CompareAndCreatePr',
                          'while resorting for mt='||l_reorder_rec.mt||'#pr='||a_new_pr||'#pr_version='||a_new_pr_version);
               l_error_logged := TRUE;
            END IF;
         END;
      END LOOP;

   ELSIF l_some_mt_appended_in_oldpr THEN

      --some mt have been added to the old_pr and have been added to the new_pr
      --but the sequence is not correct
      --sort according to order in newref_pr
      l_reorder_took_place := TRUE;
      --TraceError('UNDIFF.CompareAndCreatepr','(debug) order modified according to nexref_pr');

      SELECT NVL(MAX(a.seq),0)+1
      INTO l_max_seq_in_new_pr
      FROM utprmt a
      WHERE a.pr = a_new_pr
      AND a.version = a_new_pr_version;

      --turn all sequence to a negative value to avoid the unique constraint index violations
      UPDATE utprmt a
      SET a.seq = -seq
      WHERE a.pr = a_new_pr
      AND a.version = a_new_pr_version;

      l_reorder_seq := 0;
      l_error_logged := FALSE;
      FOR l_reorder_rec IN l_reorder_follow_newref_cursor(l_max_seq_in_new_pr) LOOP
         BEGIN
            SELECT MAX(b.seq)
            INTO l_orig_seq
            FROM utprmt b
            WHERE b.pr = a_new_pr
            AND b.version = a_new_pr_version
            AND b.mt = l_reorder_rec.mt
            AND b.seq < 0;
-- DEBUGGING ONLY
-- DBMS_OUTPUT.PUT_LINE('mt='||l_reorder_rec.mt||'#seq'||l_reorder_rec.seq||'#orig_seq='||l_orig_seq);
--
            l_reorder_seq := l_reorder_seq+1;
            UPDATE utprmt a
            SET a.seq = l_reorder_seq
            WHERE a.pr = a_new_pr
            AND a.version = a_new_pr_version
            AND a.mt = l_reorder_rec.mt
            AND a.seq = l_orig_seq;

            -- No check on SQL%ROWCOUNT since cursor is also returning the deleted records.
         EXCEPTION
         WHEN OTHERS THEN
            --the parameter is present more than once or the seq is already used
            IF l_error_logged = FALSE THEN
               TraceError('UNDIFF.CompareAndCreatePr','SQLERRM='||SQLERRM);
               TraceError('UNDIFF.CompareAndCreatePr',
                          'while resorting for mt='||l_reorder_rec.mt||'#pr='||a_new_pr||'#pr_version='||a_new_pr_version);
               l_error_logged := TRUE;
            END IF;
         END;
      END LOOP;
   END IF;

   IF l_reorder_took_place THEN

      --set the sequence to a positive integer if necessary; should not be necessary but
      l_entered_loop := FALSE;
      FOR l_rec IN l_reorder_corr_prmtseq_cursor LOOP
         UPDATE utprmt a
         SET a.seq = (SELECT NVL(MAX(b.seq),0)+1
                      FROM utprmt b
                      WHERE b.pr = a_new_pr
                        AND b.version = a_new_pr_version)
         --WHERE CURRENT OF l_reorder_corr_prmtseq_cursor
         --(Bug in Oracle Bug 2279457 COMBINING DML 'RETURNING' CLAUSE WITH 'WHERE CURRENT OF' IN PL/SQL GIVES ERROR)
         WHERE rowid = l_rec.rowid
         RETURNING a.seq
         INTO l_reorder_seq;

         TraceError('UNDIFF.CompareAndCreatepr', 'mt='||l_rec.mt||'#seq='||l_rec.seq);
         l_entered_loop := TRUE;
      END LOOP;

      IF l_entered_loop THEN
         TraceError('UNDIFF.CompareAndCreatepr','(warning) records found with negative sequences!');
         TraceError('UNDIFF.CompareAndCreatepr',
                    '#pr='||a_new_pr||'#pr_version='||a_new_pr_version);
      END IF;

      --gaps in sequence numbers might be present: clean
      l_reorder_seq := 0;
      FOR l_rec IN l_order_nogaps_prmtseq_cursor LOOP
         l_reorder_seq := l_reorder_seq+1;
         UPDATE utprmt a
         SET a.seq = l_reorder_seq
         WHERE CURRENT OF l_order_nogaps_prmtseq_cursor;

      END LOOP;
   END IF;

   --In projects the following constructions will be added here:
   --  Add some audit trail information in history
   --  send a customized  event to trigger a specific transition
   --  call changestatus to bring the created object directly to a specific status
   INSERT INTO utprhs (pr, version, who,
                       who_description, what, what_description, logdate, logdate_tz, why, tr_seq, ev_seq)
   VALUES (a_new_pr, a_new_pr_version, UNAPIGEN.P_USER,
           UNAPIGEN.P_USER_DESCRIPTION, 'UNDIFF generated new version(1)',
           SUBSTR('UNDIFF generated new pr:('||a_new_pr||','||a_new_pr_version||') based on'||
                  '#old ref pr:('||a_oldref_pr||','||a_oldref_pr_version||')'||
                  '#old pr:('||a_old_pr||','||a_old_pr_version||')'||
                  '#new ref pr:('||a_newref_pr||','||a_newref_pr_version||')',1,255),
           CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, '', UNAPIGEN.P_TR_SEQ,
           NVL(UNAPIEV.P_EV_REC.ev_seq, -1));

-- comment out to activate
/*
   l_api_name := 'CompareAndCreatePr';
   l_evmgr_name := UNAPIGEN.P_EVMGR_NAME;
   l_object_tp := 'pr';
   l_object_id  := a_new_pr;
   l_object_lc  := '@L';
   l_object_ss  := '@E';
   l_ev_tp      := 'ObjectUpdated';
   l_ev_details := 'version=' ||a_new_pr_version||'#ss_to=@A';
   l_seq_nr     := NULL;

   l_ret_code := UNAPIEV.INSERTEVENT
                   (l_api_name,
                    l_evmgr_name,
                    l_object_tp,
                    l_object_id,
                    l_object_lc,
                    l_object_lc_version,
                    l_object_ss,
                    l_ev_tp,
                    l_ev_details,
                    l_seq_nr);
   IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
      l_sqlerrm := 'UNAPIEV.INSERTEVENT ret_code='||l_ret_code||'#pr='||a_new_pr
                   ||'#version='||a_new_pr_version;
      RAISE StpError;
   END IF;
*/

   IF UNAPIGEN.EndTxn <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE StpError;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF sqlcode <> 1 THEN
      UNAPIGEN.LogError('CompareAndCreatePr',sqlerrm);
   ELSIF l_sqlerrm IS NOT NULL THEN
      UNAPIGEN.LogError('CompareAndCreatePr',l_sqlerrm);
   END IF;
   IF l_utpr_cursor%ISOPEN THEN
      CLOSE l_utpr_cursor;
   END IF;
   IF l_utprmt_cursor%ISOPEN THEN
      CLOSE l_utprmt_cursor;
   END IF;
   IF l_new_prmtseq%ISOPEN THEN
      CLOSE l_new_prmtseq;
   END IF;
   RETURN(UNAPIGEN.AbortTxn(UNAPIGEN.P_TXN_ERROR, 'CompareAndCreatePr'));
END CompareAndCreatePr;
-- -----------------------------------------------------------------------------
FUNCTION SynchronizeDerivedMethod
RETURN NUMBER IS

l_oldref_mt          VARCHAR2(20);
l_oldref_mt_version  VARCHAR2(20);
l_newref_mt          VARCHAR2(20);
l_newref_mt_version  VARCHAR2(20);
l_old_mt             VARCHAR2(20);
l_old_mt_version     VARCHAR2(20);
l_new_mt             VARCHAR2(20);
l_new_mt_version     VARCHAR2(20);

l_temp_version       VARCHAR2(20);
l_major_version      VARCHAR2(20);
l_minor_version      VARCHAR2(20);
l_lowest_minor_version VARCHAR2(20);

--There may be gaps between major versions transferred
--e.g: verion 12 is transferred but verion 11 was never transferred
--     version 10 must be used as parent in such a case
CURSOR l_prev_major_version_cursor(c_mt VARCHAR2, c_minor_version VARCHAR2, c_next_version VARCHAR2) IS
    SELECT MAX(version) version
    FROM utmt
    WHERE mt= c_mt
    AND SUBSTR(version, INSTR(version,'.') +1) = c_minor_version
    AND version < c_next_version;

--There may be gaps between major versions transferred
--e.g: verion 12 is transferred but verion 11 was never transferred
--     version 10 must be used as parent in such a case
CURSOR l_old_version_cursor(c_mt VARCHAR2, c_next_version VARCHAR2) IS
    SELECT MAX(version) version
    FROM utmt
    WHERE mt= c_mt
    AND version < c_next_version;

BEGIN

-- The key for the mt for which the event rule has been triggered
-- is stored in l_newref_mt variables
l_newref_mt          := UNAPIEV.P_EV_REC.object_id;
l_newref_mt_version  := UNAPIEV.P_VERSION   ;

--Check if the method is a major version
--exit the function when not a major version
--
l_minor_version := SUBSTR(l_newref_mt_version, INSTR(l_newref_mt_version,'.') +1);
-- look what the lowest minor version is (can be '00' or 'aa' or '000')
l_lowest_minor_version := SUBSTR(UNVERSION.SQLGetNextMajorVersion(l_newref_mt_version), INSTR(UNVERSION.SQLGetNextMajorVersion(l_newref_mt_version),'.') +1);
IF l_minor_version <> l_lowest_minor_version THEN
    --This function is only being called for new major versions (minor version = 00 ->version of interspec)
    RETURN(UNAPIGEN.DBERR_SUCCESS);
END IF;

-- Find the previous major version
-- exit the function when no previous major version
OPEN l_prev_major_version_cursor(l_newref_mt, l_lowest_minor_version, l_newref_mt_version);
FETCH l_prev_major_version_cursor
INTO l_oldref_mt_version;
IF l_oldref_mt_version IS NULL THEN
    CLOSE l_prev_major_version_cursor;
    RETURN(UNAPIGEN.DBERR_SUCCESS); --nothing to compare with
END IF;
CLOSE l_prev_major_version_cursor;

-- Find the highest minor version in previous major version
-- exit the function when no highest minor version in previous major version
OPEN l_old_version_cursor(l_newref_mt,  l_newref_mt_version);
FETCH l_old_version_cursor INTO l_old_mt_version;
IF l_old_mt_version IS NULL THEN
    CLOSE l_old_version_cursor;
    RETURN(UNAPIGEN.DBERR_SUCCESS); --nothing to compare with
END IF;
CLOSE l_old_version_cursor;

-- exit the function when "previous major version" = "highest minor version in previous major version"
IF l_old_mt_version = l_oldref_mt_version THEN
    --no subversion of the version of interspec
    RETURN(UNAPIGEN.DBERR_SUCCESS);
END IF;

--Generate the new version string for the mt that must be created
l_temp_version   := UNVERSION.SQLGetHighestMinorVersion('mt', l_newref_mt, l_newref_mt_version);
l_new_mt_version := UNVERSION.SQLGetNextMinorVersion(l_temp_version);

--DBMS_OUTPUT.PUT_LINE(l_oldref_mt_version || ' ; ' ||l_newref_mt_version|| ' ; ' ||l_old_mt_version || ' ; ' ||l_new_mt_version);
--Create the new pp
l_ret_code  := CompareAndCreateMt
                  (l_newref_mt        ,
                   l_oldref_mt_version,
                   l_newref_mt        ,
                   l_newref_mt_version,
                   l_newref_mt        ,
                   l_old_mt_version   ,
                   l_newref_mt        ,
                   l_new_mt_version);

IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
   UNAPIGEN.LogError('SynchronizeDerivedMethod', 'CompareAndCreateMt#ret_code='||l_ret_code);
   RAISE StpError;
END IF;
RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LogError('SynchronizeDerivedMethod', SQLERRM);
   END IF;
   IF l_prev_major_version_cursor%ISOPEN THEN
       CLOSE l_prev_major_version_cursor;
   END IF;
   IF l_old_version_cursor%ISOPEN THEN
       CLOSE l_old_version_cursor;
   END IF;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END SynchronizeDerivedMethod;
-- -----------------------------------------------------------------------------

FUNCTION CompareAndCreateMt
(a_oldref_mt           IN     VARCHAR2,       /* VC20_TYPE */
 a_oldref_mt_version   IN     VARCHAR2,       /* VC20_TYPE */
 a_newref_mt           IN     VARCHAR2,       /* VC20_TYPE */
 a_newref_mt_version   IN     VARCHAR2,       /* VC20_TYPE */
 a_old_mt              IN     VARCHAR2,       /* VC20_TYPE */
 a_old_mt_version      IN     VARCHAR2,       /* VC20_TYPE */
 a_new_mt              IN     VARCHAR2,       /* VC20_TYPE */
 a_new_mt_version      IN     VARCHAR2)       /* VC20_TYPE */
RETURN NUMBER IS

l_any_mt_details_modified        BOOLEAN;
l_count_details_modified         INTEGER;
l_copy_from_mt                   VARCHAR2(20);
l_copy_from_mt_version           VARCHAR2(20);
l_seq                            NUMBER(5);

--utmt cursors and variables
CURSOR l_utmt_cursor (c_mt IN VARCHAR2,
                      c_mt_version IN VARCHAR2) IS
SELECT *
FROM utmt
WHERE mt = c_mt
AND version = c_mt_version;
l_oldref_utmt_rec   l_utmt_cursor%ROWTYPE;
l_newref_utmt_rec   l_utmt_cursor%ROWTYPE;
l_old_utmt_rec      l_utmt_cursor%ROWTYPE;
l_new_utmt_rec      l_utmt_cursor%ROWTYPE;

--utmtau cursors and variables
--assumption: au_version always NULL
CURSOR l_new_utmtau_cursor IS
   --all attributes in oldmt
   --and that have not been suppressed in newref
   -- Part1= 1 (NOT IN 2) AND IN 3
   -- 1= all attributes in the old_mt
   -- old_mt has some differences with oldref, these modifications must be kept
   -- the subqueries are returning these differences
   -- 2= list of attributes that have been suppressed from oldref to make the final old_mt
   -- 3= list of attribute values that have not been modified between OLD_REF and OLD (values will be taken from NEW when applicable)
   --
   /* 1 */
   SELECT au, value
     FROM utmtau
    WHERE mt = a_old_mt
      AND version = a_old_mt_version
    /* 2 */
    AND au NOT IN (SELECT au
                   FROM utmtau
                   WHERE mt = a_old_mt
                     AND version = a_old_mt_version
                   INTERSECT
                     (SELECT au
                      FROM utmtau
                      WHERE mt = a_oldref_mt
                        AND version = a_oldref_mt_version
                      MINUS
                      SELECT au
                      FROM utmtau
                      WHERE mt = a_newref_mt
                        AND version = a_newref_mt_version
                     )
                   )
    /* 3 */
    --test might seem strange but is alo good for single valued attributes
    --The attribute values are not compared one by one but the list of values are compared
    --LOV are compared here
    --subquery is returning any attribute where the LOV has been modified
    --test is inverted here (would result in two times NOT IN)
    --subquery returns all attributes for which the list of values has been modified in OLD compared to OLD_REF
    AND au IN (SELECT DISTINCT au FROM
                     ((SELECT au, value
                       FROM utmtau
                       WHERE mt = a_old_mt
                         AND version = a_old_mt_version
                       UNION
                       SELECT au, value
                       FROM utmtau
                       WHERE mt = a_oldref_mt
                         AND version = a_oldref_mt_version
                       )
                      MINUS
                      (SELECT au, value
                       FROM utmtau
                       WHERE mt = a_old_mt
                         AND version = a_old_mt_version
                       INTERSECT
                       SELECT au, value
                       FROM utmtau
                       WHERE mt = a_oldref_mt
                         AND version = a_oldref_mt_version
                      )
                     )
               )
   UNION
   --all attributes in newref that are not already in oldmt
   --and that have not been suppressed
   -- Part2= 1 (NOT IN 2)
   -- 1= all attributes in the newref_mt
   -- newref_mt has some differences with oldref, these modifications must be kept
   -- the subqueries are returning these differences
   -- 2= list of attributes that are already in old_mt or that have been suppressed from oldref to make the final old_mt
   /* 1 */
   SELECT au, value
   FROM utmtau
   WHERE mt = a_newref_mt
     AND version = a_newref_mt_version
   /* 2 */
   AND au NOT IN (SELECT au
                  FROM utmtau
                  WHERE mt = a_old_mt
                    AND version = a_old_mt_version)
   AND au NOT IN (SELECT au
                  FROM utmtau
                  WHERE mt = a_oldref_mt
                    AND version = a_oldref_mt_version
                  INTERSECT
                  SELECT au
                  FROM utmtau
                  WHERE mt = a_newref_mt
                    AND version = a_newref_mt_version)
   UNION
   --Add all attributes in newref that are already in oldmt
   --that have not been updated in oldmt
   --and that have not been suppressed
   -- Part3= 1 (NOT IN 2)
   -- 1= all attributes in the newref_mt
   -- 2= list of attributes that have been changed between OLD_REF and OLD
   --LOV are compared here
   --subquery is returning any attribute where the LOV has been modified
   --subquery returns all attributes for which the list of values has been modified in OLD compared to OLD_REF
   /* 1 */
   SELECT au, value
   FROM utmtau
   WHERE mt = a_newref_mt
     AND version = a_newref_mt_version
   /* 2 */
    AND au NOT IN (SELECT DISTINCT au FROM
                     ((SELECT au, value
                       FROM utmtau
                       WHERE mt = a_old_mt
                         AND version = a_old_mt_version
                       UNION
                       SELECT au, value
                       FROM utmtau
                       WHERE mt = a_oldref_mt
                         AND version = a_oldref_mt_version
                       )
                      MINUS
                      (SELECT au, value
                       FROM utmtau
                       WHERE mt = a_old_mt
                         AND version = a_old_mt_version
                       INTERSECT
                       SELECT au, value
                       FROM utmtau
                       WHERE mt = a_oldref_mt
                         AND version = a_oldref_mt_version
                      )
                     )
               )
   ORDER BY au, value;

--utmtmr cursors and variables
CURSOR l_mtmrls_cursor IS
SELECT *
  FROM utmtmr
  WHERE mt = a_newref_mt
  AND version = a_newref_mt_version
  AND (mt, component) IN
   --all component(s) from newref
  (SELECT mt, component
   FROM utmtmr
   WHERE mt = a_newref_mt
     AND version = a_newref_mt_version
   --add all component that have been added in Unilab
   UNION
   (SELECT mt, component
    FROM utmtmr
    WHERE mt = a_old_mt
      AND version = a_old_mt_version
    MINUS
    SELECT mt, component
    FROM utmtmr
    WHERE mt = a_oldref_mt
      AND version = a_oldref_mt_version)
   --remove all component that have been deleted in Unilab
   MINUS
   (SELECT mt, component
    FROM utmtmr
    WHERE mt = a_oldref_mt
      AND version = a_oldref_mt_version
    MINUS
    SELECT mt, component
    FROM utmtmr
    WHERE mt = a_old_mt
      AND version = a_old_mt_version))
   ORDER BY seq;

CURSOR l_old_mtmrls_cursor IS
   SELECT *
   FROM utmtmr
   WHERE mt = a_old_mt
     AND version = a_old_mt_version
     AND (mt, component) NOT IN
     (SELECT mt, component
      FROM utmtmr
      WHERE mt = a_newref_mt
        AND version = a_newref_mt_version
      UNION
      SELECT mt, component
      FROM utmtmr
      WHERE mt = a_oldref_mt
        AND version = a_oldref_mt_version);

CURSOR l_new_mtmrseq IS
    SELECT NVL(MAX(seq), 0) +1
    FROM utmtmr
    WHERE mt = a_new_mt
      AND version = a_new_mt_version;

CURSOR l_mtells_cursor IS
SELECT * FROM
   --all el from newref
  (SELECT mt, el
   FROM utmtel
   WHERE mt = a_newref_mt
     AND version = a_newref_mt_version
   --add all el that have been added in Unilab
   UNION
   (SELECT mt, el
    FROM utmtel
    WHERE mt = a_old_mt
      AND version = a_old_mt_version
    MINUS
    SELECT mt, el
    FROM utmtel
    WHERE mt = a_oldref_mt
      AND version = a_oldref_mt_version)
   --remove all el that have been deleted in Unilab
   MINUS
   (SELECT mt, el
    FROM utmtel
    WHERE mt = a_oldref_mt
      AND version = a_oldref_mt_version
    MINUS
    SELECT mt, el
    FROM utmtel
    WHERE mt = a_old_mt
      AND version = a_old_mt_version))
   ORDER BY el;

/* DEBUG - was commented */
--   -- Local variables for 'InsertEvent' API
--   l_api_name                    VARCHAR2(40);
--   l_evmgr_name                  VARCHAR2(20);
--   l_object_tp                   VARCHAR2(4);
--   l_object_id                   VARCHAR2(20);
--   l_object_lc                   VARCHAR2(2);
--   l_object_lc_version           VARCHAR2(20);
--   l_object_ss                   VARCHAR2(2);
--   l_ev_tp                       VARCHAR2(60);
--   l_ev_details                  VARCHAR2(255);
--   l_seq_nr                      NUMBER;
/* END OF DEBUG - was commented */

BEGIN

--   l_some_mt_appended_in_oldmt:=FALSE;
   l_sqlerrm := NULL;
   IF UNAPIGEN.BeginTxn(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE StpError;
   END IF;

/* DEBUG ONLY */
--DBMS_OUTPUT.PUT_LINE('oldref: ' ||a_oldref_mt||' ; '||a_oldref_mt_version);
--DBMS_OUTPUT.PUT_LINE('newref: ' ||a_newref_mt||' ; '||a_newref_mt_version);
--DBMS_OUTPUT.PUT_LINE('old: ' ||a_old_mt||' ; '||a_old_mt_version);
--DBMS_OUTPUT.PUT_LINE('new: ' ||a_new_mt||' ; '||a_new_mt_version);
/* END OF DEBUG ONLY */

   /*-------------------*/
   /* Compare utmt      */
   /*-------------------*/
   --fetch 3 utmt records
   OPEN l_utmt_cursor(a_oldref_mt, a_oldref_mt_version);
   FETCH l_utmt_cursor
   INTO l_oldref_utmt_rec;
   IF l_utmt_cursor%NOTFOUND THEN
      CLOSE l_utmt_cursor;
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      RAISE STpError;
   END IF;
   CLOSE l_utmt_cursor;

   OPEN l_utmt_cursor(a_newref_mt, a_newref_mt_version);
   FETCH l_utmt_cursor
   INTO l_newref_utmt_rec;
   IF l_utmt_cursor%NOTFOUND THEN
      CLOSE l_utmt_cursor;
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      RAISE STpError;
   END IF;
   CLOSE l_utmt_cursor;

   OPEN l_utmt_cursor(a_old_mt, a_old_mt_version);
   FETCH l_utmt_cursor
   INTO l_old_utmt_rec;
   IF l_utmt_cursor%NOTFOUND THEN
      CLOSE l_utmt_cursor;
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      RAISE STpError;
   END IF;
   CLOSE l_utmt_cursor;

   OPEN l_utmt_cursor(a_new_mt, a_new_mt_version);
   FETCH l_utmt_cursor
   INTO l_new_utmt_rec;
   IF l_utmt_cursor%FOUND THEN
      CLOSE l_utmt_cursor;
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_ALREADYEXISTS;
      RAISE STpError;
   END IF;
   CLOSE l_utmt_cursor;

   --compare
   --columns not compared: mt, version, ss, allow_modify, active, ar[1-128],
   --                      effective_from, version_is_current, effective_till
   l_new_utmt_rec := l_newref_utmt_rec;
   IF NVL((l_old_utmt_rec.description <> l_oldref_utmt_rec.description), TRUE) AND NOT(l_old_utmt_rec.description IS NULL AND l_oldref_utmt_rec.description IS NULL)  THEN
      l_new_utmt_rec.description := l_old_utmt_rec.description;
   END IF;
   IF NVL((l_old_utmt_rec.description2 <> l_oldref_utmt_rec.description2), TRUE) AND NOT(l_old_utmt_rec.description2 IS NULL AND l_oldref_utmt_rec.description2 IS NULL)  THEN
      l_new_utmt_rec.description2 := l_old_utmt_rec.description2;
   END IF;
   IF NVL((l_old_utmt_rec.unit <> l_oldref_utmt_rec.unit), TRUE) AND NOT(l_old_utmt_rec.unit IS NULL AND l_oldref_utmt_rec.unit IS NULL)  THEN
      l_new_utmt_rec.unit := l_old_utmt_rec.unit;
   END IF;
   IF NVL((l_old_utmt_rec.est_cost <> l_oldref_utmt_rec.est_cost), TRUE) AND NOT(l_old_utmt_rec.est_cost IS NULL AND l_oldref_utmt_rec.est_cost IS NULL)  THEN
      l_new_utmt_rec.est_cost := l_old_utmt_rec.est_cost;
   END IF;
   IF NVL((l_old_utmt_rec.est_time <> l_oldref_utmt_rec.est_time), TRUE) AND NOT(l_old_utmt_rec.est_time IS NULL AND l_oldref_utmt_rec.est_time IS NULL)  THEN
      l_new_utmt_rec.est_time := l_old_utmt_rec.est_time;
   END IF;
   IF NVL((l_old_utmt_rec.accuracy <> l_oldref_utmt_rec.accuracy), TRUE) AND NOT(l_old_utmt_rec.accuracy IS NULL AND l_oldref_utmt_rec.accuracy IS NULL)  THEN
      l_new_utmt_rec.accuracy := l_old_utmt_rec.accuracy;
   END IF;
   IF NVL((l_old_utmt_rec.is_template <> l_oldref_utmt_rec.is_template), TRUE) AND NOT(l_old_utmt_rec.is_template IS NULL AND l_oldref_utmt_rec.is_template IS NULL)  THEN
      l_new_utmt_rec.is_template := l_old_utmt_rec.is_template;
   END IF;
   IF NVL((l_old_utmt_rec.calibration <> l_oldref_utmt_rec.calibration), TRUE) AND NOT(l_old_utmt_rec.calibration IS NULL AND l_oldref_utmt_rec.calibration IS NULL)  THEN
      l_new_utmt_rec.calibration := l_old_utmt_rec.calibration;
   END IF;
   IF NVL((l_old_utmt_rec.autorecalc <> l_oldref_utmt_rec.autorecalc), TRUE) AND NOT(l_old_utmt_rec.autorecalc IS NULL AND l_oldref_utmt_rec.autorecalc IS NULL)  THEN
      l_new_utmt_rec.autorecalc := l_old_utmt_rec.autorecalc;
   END IF;
   IF NVL((l_old_utmt_rec.confirm_complete <> l_oldref_utmt_rec.confirm_complete), TRUE) AND NOT(l_old_utmt_rec.confirm_complete IS NULL AND l_oldref_utmt_rec.confirm_complete IS NULL)  THEN
      l_new_utmt_rec.confirm_complete := l_old_utmt_rec.confirm_complete;
   END IF;
   IF NVL((l_old_utmt_rec.auto_create_cells <> l_oldref_utmt_rec.auto_create_cells), TRUE) AND NOT(l_old_utmt_rec.auto_create_cells IS NULL AND l_oldref_utmt_rec.auto_create_cells IS NULL)  THEN
      l_new_utmt_rec.auto_create_cells := l_old_utmt_rec.auto_create_cells;
   END IF;
   IF NVL((l_old_utmt_rec.me_result_editable <> l_oldref_utmt_rec.me_result_editable), TRUE) AND NOT(l_old_utmt_rec.me_result_editable IS NULL AND l_oldref_utmt_rec.me_result_editable IS NULL)  THEN
      l_new_utmt_rec.me_result_editable := l_old_utmt_rec.me_result_editable;
   END IF;
   IF NVL((l_old_utmt_rec.executor <> l_oldref_utmt_rec.executor), TRUE) AND NOT(l_old_utmt_rec.executor IS NULL AND l_oldref_utmt_rec.executor IS NULL)  THEN
      l_new_utmt_rec.executor := l_old_utmt_rec.executor;
   END IF;
   IF NVL((l_old_utmt_rec.eq_tp <> l_oldref_utmt_rec.eq_tp), TRUE) AND NOT(l_old_utmt_rec.eq_tp IS NULL AND l_oldref_utmt_rec.eq_tp IS NULL)  THEN
      l_new_utmt_rec.eq_tp := l_old_utmt_rec.eq_tp;
   END IF;
   IF NVL((l_old_utmt_rec.sop <> l_oldref_utmt_rec.sop), TRUE) AND NOT(l_old_utmt_rec.sop IS NULL AND l_oldref_utmt_rec.sop IS NULL)  THEN
      l_new_utmt_rec.sop := l_old_utmt_rec.sop;
   END IF;
   IF NVL((l_old_utmt_rec.sop_version <> l_oldref_utmt_rec.sop_version), TRUE) AND NOT(l_old_utmt_rec.sop_version IS NULL AND l_oldref_utmt_rec.sop_version IS NULL)  THEN
      l_new_utmt_rec.sop_version := l_old_utmt_rec.sop_version;
   END IF;
   IF NVL((l_old_utmt_rec.plaus_low <> l_oldref_utmt_rec.plaus_low), TRUE) AND NOT(l_old_utmt_rec.plaus_low IS NULL AND l_oldref_utmt_rec.plaus_low IS NULL)  THEN
      l_new_utmt_rec.plaus_low := l_old_utmt_rec.plaus_low;
   END IF;
   IF NVL((l_old_utmt_rec.plaus_high <> l_oldref_utmt_rec.plaus_high), TRUE) AND NOT(l_old_utmt_rec.plaus_high IS NULL AND l_oldref_utmt_rec.plaus_high IS NULL)  THEN
      l_new_utmt_rec.plaus_high := l_old_utmt_rec.plaus_high;
   END IF;
   IF NVL((l_old_utmt_rec.winsize_x <> l_oldref_utmt_rec.winsize_x), TRUE) AND NOT(l_old_utmt_rec.winsize_x IS NULL AND l_oldref_utmt_rec.winsize_x IS NULL)  THEN
      l_new_utmt_rec.winsize_x := l_old_utmt_rec.winsize_x;
   END IF;
   IF NVL((l_old_utmt_rec.winsize_y <> l_oldref_utmt_rec.winsize_y), TRUE) AND NOT(l_old_utmt_rec.winsize_y IS NULL AND l_oldref_utmt_rec.winsize_y IS NULL)  THEN
      l_new_utmt_rec.winsize_y := l_old_utmt_rec.winsize_y;
   END IF;
   IF NVL((l_old_utmt_rec.sc_lc <> l_oldref_utmt_rec.sc_lc), TRUE) AND NOT(l_old_utmt_rec.sc_lc IS NULL AND l_oldref_utmt_rec.sc_lc IS NULL)  THEN
      l_new_utmt_rec.sc_lc := l_old_utmt_rec.sc_lc;
   END IF;
   IF NVL((l_old_utmt_rec.sc_lc_version <> l_oldref_utmt_rec.sc_lc_version), TRUE) AND NOT(l_old_utmt_rec.sc_lc_version IS NULL AND l_oldref_utmt_rec.sc_lc_version IS NULL)  THEN
      l_new_utmt_rec.sc_lc_version := l_old_utmt_rec.sc_lc_version;
   END IF;
   IF NVL((l_old_utmt_rec.def_val_tp <> l_oldref_utmt_rec.def_val_tp), TRUE) AND NOT(l_old_utmt_rec.def_val_tp IS NULL AND l_oldref_utmt_rec.def_val_tp IS NULL)  THEN
      l_new_utmt_rec.def_val_tp := l_old_utmt_rec.def_val_tp;
   END IF;
   IF NVL((l_old_utmt_rec.def_au_level <> l_oldref_utmt_rec.def_au_level), TRUE) AND NOT(l_old_utmt_rec.def_au_level IS NULL AND l_oldref_utmt_rec.def_au_level IS NULL)  THEN
      l_new_utmt_rec.def_au_level := l_old_utmt_rec.def_au_level;
   END IF;
   IF NVL((l_old_utmt_rec.def_val <> l_oldref_utmt_rec.def_val), TRUE) AND NOT(l_old_utmt_rec.def_val IS NULL AND l_oldref_utmt_rec.def_val IS NULL)  THEN
      l_new_utmt_rec.def_val := l_old_utmt_rec.def_val;
   END IF;
   IF NVL((l_old_utmt_rec.format <> l_oldref_utmt_rec.format), TRUE) AND NOT(l_old_utmt_rec.format IS NULL AND l_oldref_utmt_rec.format IS NULL)  THEN
      l_new_utmt_rec.format := l_old_utmt_rec.format;
   END IF;
   IF NVL((l_old_utmt_rec.inherit_au <> l_oldref_utmt_rec.inherit_au), TRUE) AND NOT(l_old_utmt_rec.inherit_au IS NULL AND l_oldref_utmt_rec.inherit_au IS NULL)  THEN
      l_new_utmt_rec.inherit_au := l_old_utmt_rec.inherit_au;
   END IF;
   IF NVL((l_old_utmt_rec.last_comment <> l_oldref_utmt_rec.last_comment), TRUE) AND NOT(l_old_utmt_rec.last_comment IS NULL AND l_oldref_utmt_rec.last_comment IS NULL)  THEN
      l_new_utmt_rec.last_comment := l_old_utmt_rec.last_comment;
   END IF;
   IF NVL((l_old_utmt_rec.mt_class <> l_oldref_utmt_rec.mt_class), TRUE) AND NOT(l_old_utmt_rec.mt_class IS NULL AND l_oldref_utmt_rec.mt_class IS NULL)  THEN
      l_new_utmt_rec.mt_class := l_old_utmt_rec.mt_class;
   END IF;
   IF NVL((l_old_utmt_rec.log_hs <> l_oldref_utmt_rec.log_hs), TRUE) AND NOT(l_old_utmt_rec.log_hs IS NULL AND l_oldref_utmt_rec.log_hs IS NULL)  THEN
      l_new_utmt_rec.log_hs := l_old_utmt_rec.log_hs;
   END IF;
   IF NVL((l_old_utmt_rec.log_hs_details <> l_oldref_utmt_rec.log_hs_details), TRUE) AND NOT(l_old_utmt_rec.log_hs_details IS NULL AND l_oldref_utmt_rec.log_hs_details IS NULL)  THEN
      l_new_utmt_rec.log_hs_details := l_old_utmt_rec.log_hs_details;
   END IF;
   IF NVL((l_old_utmt_rec.lc <> l_oldref_utmt_rec.lc), TRUE) AND NOT(l_old_utmt_rec.lc IS NULL AND l_oldref_utmt_rec.lc IS NULL)  THEN
      l_new_utmt_rec.lc := l_old_utmt_rec.lc;
   END IF;
   IF NVL((l_old_utmt_rec.lc_version <> l_oldref_utmt_rec.lc_version), TRUE) AND NOT(l_old_utmt_rec.lc_version IS NULL AND l_oldref_utmt_rec.lc_version IS NULL)  THEN
      l_new_utmt_rec.lc_version := l_old_utmt_rec.lc_version;
   END IF;

   --insert the record in utmt
   --special cases: version_is_current, effective_till

   l_ret_code := UNAPIMT.SaveMethod
                   (a_new_mt,
                    a_new_mt_version,
                    NULL,
                    l_new_utmt_rec.effective_from,
                    NULL,
                    l_new_utmt_rec.description,
                    l_new_utmt_rec.description2,
                    l_new_utmt_rec.unit,
                    l_new_utmt_rec.est_cost,
                    l_new_utmt_rec.est_time,
                    l_new_utmt_rec.accuracy,
                    l_new_utmt_rec.is_template,
                    l_new_utmt_rec.calibration,
                    l_new_utmt_rec.autorecalc,
                    l_new_utmt_rec.confirm_complete,
                    l_new_utmt_rec.auto_create_cells,
                    l_new_utmt_rec.me_result_editable,
                    l_new_utmt_rec.executor,
                    l_new_utmt_rec.eq_tp,
                    l_new_utmt_rec.sop,
                    l_new_utmt_rec.sop_version,
                    l_new_utmt_rec.plaus_low,
                    l_new_utmt_rec.plaus_high,
                    l_new_utmt_rec.winsize_x,
                    l_new_utmt_rec.winsize_y,
                    l_new_utmt_rec.sc_lc,
                    l_new_utmt_rec.sc_lc_version,
                    l_new_utmt_rec.def_val_tp,
                    l_new_utmt_rec.def_au_level,
                    l_new_utmt_rec.def_val,
                    l_new_utmt_rec.format,
                    l_new_utmt_rec.inherit_au,
                    l_new_utmt_rec.mt_class,
                    l_new_utmt_rec.log_hs,
                    l_new_utmt_rec.lc,
                    l_new_utmt_rec.lc_version,
                    '');

   IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
      l_sqlerrm := 'SaveMethod ret_code='||l_ret_code||'#mt='||a_new_mt
                   ||'#version='||a_new_mt_version;
      RAISE StpError;
   END IF;

   /*-------------------*/
   /* Compare utmtau    */
   /*-------------------*/
   --Build up the list of mt and compare properties
   l_seq := 0;
   FOR l_new_utmtau_rec IN l_new_utmtau_cursor LOOP

      --insert the records in utmtau
      --special cases: au_version always NULL
      l_seq := l_seq+1;
      INSERT INTO utmtau
      (mt, version,
       au, au_version, auseq, value)
      VALUES
      (a_new_mt, a_new_mt_version,
       l_new_utmtau_rec.au, NULL, l_seq, l_new_utmtau_rec.value);
   END LOOP;

   /*-------------------*/
   /* Compare utmtmr    */
   /*-------------------*/
   --Build up the list of cy and compare properties
   l_seq := 0;
   FOR l_newref_utmtmr_rec IN l_mtmrls_cursor LOOP
      --insert the record in utmtmr
      l_seq := l_seq+1;
      INSERT INTO utmtmr
      (mt, version, seq, component, l_detection_limit, l_determ_limit, h_determ_limit, h_detection_limit, unit)
      VALUES
      (a_new_mt, a_new_mt_version,
       l_seq, l_newref_utmtmr_rec.component,
       l_newref_utmtmr_rec.l_detection_limit, l_newref_utmtmr_rec.l_determ_limit,
       l_newref_utmtmr_rec.h_determ_limit, l_newref_utmtmr_rec.h_detection_limit,
       l_newref_utmtmr_rec.unit);
   END LOOP;

   --insert the mr's that were added in the old mt and that are not present in the ref mt
   FOR l_new_utmtmr_rec IN l_old_mtmrls_cursor LOOP
      OPEN l_new_mtmrseq;
      FETCH l_new_mtmrseq INTO l_seq;
      CLOSE l_new_mtmrseq;
      --insert the record in utmtmr
      INSERT INTO utmtmr
      (mt, version, seq, component, l_detection_limit, l_determ_limit, h_determ_limit, h_detection_limit, unit)
      VALUES
      (a_new_mt, a_new_mt_version, l_seq,
       l_new_utmtmr_rec.component, l_new_utmtmr_rec.l_detection_limit, l_new_utmtmr_rec.l_determ_limit,
       l_new_utmtmr_rec.h_determ_limit, l_new_utmtmr_rec.h_detection_limit, l_new_utmtmr_rec.unit);
   END LOOP;
   /* TO TEST: mr added in old */

   /*-------------------*/
   /* Compare utmtel    */
   /*-------------------*/
   --Build up the list of cy and compare properties
   l_seq := 0;
   FOR l_newref_utmtel_rec IN l_mtells_cursor LOOP
      --insert the record in utmtmr
      l_seq := l_seq+1;
      INSERT INTO utmtel
      (mt, version, el, seq)
      VALUES
      (a_new_mt, a_new_mt_version, l_newref_utmtel_rec.el, l_seq);
   END LOOP;
   /* TO TEST: el added in old */

   /*-------------------------------------*/
   /* Compare the method sheet details    */
   /*-------------------------------------*/
   --Big difference here: a merge operation is a non sense (might be in some projects but left for customisation)
   --The details are compared globally and copied globally
   --details: cells + table cells (incuding drop-down-list) + cell equipments + cell spin values
   --Some might say, just always copy what has been defined in Unilab since cells are not coming from Interspec
   --but this does not fit with our templates

   --1. check if some modifications have been done in Unilab to cell details in Unilab
   --   Compare oldref_mt and new_mt
   l_any_mt_details_modified := FALSE;
   l_count_details_modified := 0;
   --compare utmtcell (seq column left out of compare)
   SELECT COUNT('X')
   INTO l_count_details_modified
   FROM ((SELECT cell, dsp_title, dsp_title2, value_f, value_s, pos_x, pos_y, align, cell_tp, winsize_x, winsize_y, is_protected, mandatory, hidden, input_tp, input_source, input_source_version, input_pp, input_pp_version, input_pr, input_pr_version, input_mt, input_mt_version, def_val_tp, def_au_level, save_tp, save_pp, save_pp_version, save_pr, save_pr_version, save_mt, save_mt_version, save_eq_tp, save_id, save_id_version, component, unit, format, calc_tp, calc_formula, valid_cf, max_x, max_y, multi_select, create_new
          FROM utmtcell
          WHERE mt = a_oldref_mt AND version = a_oldref_mt_version
          UNION
          SELECT cell, dsp_title, dsp_title2, value_f, value_s, pos_x, pos_y, align, cell_tp, winsize_x, winsize_y, is_protected, mandatory, hidden, input_tp, input_source, input_source_version, input_pp, input_pp_version, input_pr, input_pr_version, input_mt, input_mt_version, def_val_tp, def_au_level, save_tp, save_pp, save_pp_version, save_pr, save_pr_version, save_mt, save_mt_version, save_eq_tp, save_id, save_id_version, component, unit, format, calc_tp, calc_formula, valid_cf, max_x, max_y, multi_select, create_new
          FROM utmtcell
          WHERE mt = a_old_mt AND version = a_old_mt_version)
         MINUS
         (SELECT cell, dsp_title, dsp_title2, value_f, value_s, pos_x, pos_y, align, cell_tp, winsize_x, winsize_y, is_protected, mandatory, hidden, input_tp, input_source, input_source_version, input_pp, input_pp_version, input_pr, input_pr_version, input_mt, input_mt_version, def_val_tp, def_au_level, save_tp, save_pp, save_pp_version, save_pr, save_pr_version, save_mt, save_mt_version, save_eq_tp, save_id, save_id_version, component, unit, format, calc_tp, calc_formula, valid_cf, max_x, max_y, multi_select, create_new
          FROM utmtcell
          WHERE mt = a_oldref_mt AND version = a_oldref_mt_version
          INTERSECT
          SELECT cell, dsp_title, dsp_title2, value_f, value_s, pos_x, pos_y, align, cell_tp, winsize_x, winsize_y, is_protected, mandatory, hidden, input_tp, input_source, input_source_version, input_pp, input_pp_version, input_pr, input_pr_version, input_mt, input_mt_version, def_val_tp, def_au_level, save_tp, save_pp, save_pp_version, save_pr, save_pr_version, save_mt, save_mt_version, save_eq_tp, save_id, save_id_version, component, unit, format, calc_tp, calc_formula, valid_cf, max_x, max_y, multi_select, create_new
          FROM utmtcell
          WHERE mt = a_old_mt AND version = a_old_mt_version));

   IF l_count_details_modified > 0 THEN
      l_any_mt_details_modified := TRUE;
   END IF;
   --compare utmtcelllist
   IF l_any_mt_details_modified = FALSE THEN
      SELECT COUNT('X')
      INTO l_count_details_modified
      FROM ((SELECT cell, index_x, index_y, value_f, value_s, selected
             FROM utmtcelllist
             WHERE mt = a_oldref_mt AND version = a_oldref_mt_version
             UNION
             SELECT cell, index_x, index_y, value_f, value_s, selected
             FROM utmtcelllist
             WHERE mt = a_old_mt AND version= a_old_mt_version)
            MINUS
            (SELECT cell, index_x, index_y, value_f, value_s, selected
             FROM utmtcelllist
             WHERE mt = a_oldref_mt AND version = a_oldref_mt_version
             INTERSECT
             SELECT cell, index_x, index_y, value_f, value_s, selected
             FROM utmtcelllist
             WHERE mt = a_old_mt AND version = a_old_mt_version));
      IF l_count_details_modified > 0 THEN
         l_any_mt_details_modified := TRUE;
      END IF;
   END IF;
   --compare utmtcelleqtype (seq column left out of compare)
   IF l_any_mt_details_modified = FALSE THEN
      SELECT COUNT('X')
      INTO l_count_details_modified
      FROM ((SELECT cell, eq_tp
             FROM utmtcelleqtype
             WHERE mt = a_oldref_mt AND version = a_oldref_mt_version
             UNION
             SELECT cell, eq_tp
             FROM utmtcelleqtype
             WHERE mt = a_old_mt AND version = a_old_mt_version)
            MINUS
            (SELECT cell, eq_tp
             FROM utmtcelleqtype
             WHERE mt = a_oldref_mt AND version = a_oldref_mt_version
             INTERSECT
             SELECT cell, eq_tp
             FROM utmtcelleqtype
             WHERE mt = a_old_mt AND version = a_old_mt_version));
      IF l_count_details_modified > 0 THEN
         l_any_mt_details_modified := TRUE;
      END IF;
   END IF;
   --compare utmtcellspin (not used by std Unilab but this code will work the day it is enabled)
   IF l_any_mt_details_modified = FALSE THEN
      SELECT COUNT('X')
      INTO l_count_details_modified
      FROM ((SELECT cell, circular, incr, low_val_tp, low_au_level, low_val, high_val_tp, high_au_level, high_val
             FROM utmtcellspin
             WHERE mt = a_oldref_mt AND version = a_oldref_mt_version
             UNION
             SELECT cell, circular, incr, low_val_tp, low_au_level, low_val, high_val_tp, high_au_level, high_val
             FROM utmtcellspin
             WHERE mt = a_old_mt AND version = a_old_mt_version)
            MINUS
            (SELECT cell, circular, incr, low_val_tp, low_au_level, low_val, high_val_tp, high_au_level, high_val
             FROM utmtcellspin
             WHERE mt = a_oldref_mt AND version = a_oldref_mt_version
             INTERSECT
             SELECT cell, circular, incr, low_val_tp, low_au_level, low_val, high_val_tp, high_au_level, high_val
             FROM utmtcellspin
             WHERE mt = a_old_mt AND version = a_old_mt_version));
      IF l_count_details_modified > 0 THEN
         l_any_mt_details_modified := TRUE;
      END IF;
   END IF;

   --2. If modifified in Unilab (oldref_mt<>old_mt), copy from Unilab (old_mt => new_mt)
   --   If not modified in Unilab (oldref_mt<>old_mt),take everything from Interspec (newref_mt => new_mt)
   IF l_any_mt_details_modified THEN
      l_copy_from_mt := a_old_mt;
      l_copy_from_mt_version := a_old_mt_version;
   ELSE
      l_copy_from_mt := a_newref_mt;
      l_copy_from_mt_version := a_newref_mt_version;
   END IF;
   --copy utmtcell
   INSERT INTO utmtcell
   (mt, version, cell, seq, dsp_title, dsp_title2, value_f, value_s, pos_x, pos_y, align,
    cell_tp, winsize_x, winsize_y, is_protected, mandatory, hidden, input_tp, input_source,
    input_source_version, input_pp, input_pp_version, input_pr, input_pr_version, input_mt,
    input_mt_version, def_val_tp, def_au_level, save_tp, save_pp, save_pp_version, save_pr,
    save_pr_version, save_mt, save_mt_version, save_eq_tp, save_id, save_id_version, component,
    unit, format, calc_tp, calc_formula, valid_cf, max_x, max_y, multi_select, create_new)
   SELECT a_new_mt, a_new_mt_version, cell, seq, dsp_title, dsp_title2, value_f, value_s, pos_x, pos_y, align,
          cell_tp, winsize_x, winsize_y, is_protected, mandatory, hidden, input_tp, input_source,
          input_source_version, input_pp, input_pp_version, input_pr, input_pr_version, input_mt,
          input_mt_version, def_val_tp, def_au_level, save_tp, save_pp, save_pp_version, save_pr,
          save_pr_version, save_mt, save_mt_version, save_eq_tp, save_id, save_id_version, component,
          unit, format, calc_tp, calc_formula, valid_cf, max_x, max_y, multi_select, create_new
   FROM utmtcell
   WHERE mt = l_copy_from_mt
   AND version = l_copy_from_mt_version;

   --copy utmtcelllist
   INSERT INTO utmtcelllist
   (mt, version, cell, index_x, index_y, value_f, value_s, selected)
   SELECT a_new_mt, a_new_mt_version, cell, index_x, index_y, value_f, value_s, selected
   FROM utmtcelllist
   WHERE mt = l_copy_from_mt
   AND version = l_copy_from_mt_version;

   --copy utmtcelleqtype
   INSERT INTO utmtcelleqtype
   (mt, version, cell, seq, eq_tp)
   SELECT a_new_mt, a_new_mt_version, cell, seq, eq_tp
   FROM utmtcelleqtype
   WHERE mt = l_copy_from_mt
   AND version = l_copy_from_mt_version;

   --copy utmtcellspin (not used by std Unilab but this code will work the day it is enabled)
   INSERT INTO utmtcellspin
   (mt, version, cell, circular, incr, low_val_tp, low_au_level, low_val, high_val_tp, high_au_level, high_val)
   SELECT a_new_mt, a_new_mt_version, cell, circular, incr, low_val_tp, low_au_level, low_val, high_val_tp, high_au_level, high_val
   FROM utmtcellspin
   WHERE mt = l_copy_from_mt
   AND version = l_copy_from_mt_version;

   --In projects the following constructions will be added here:
   --  Add some audit trail information in history
   --  send a customized  event to trigger a specific transition
   --  call changestatus to bring the created object directly to a specific status
   INSERT INTO utmths (mt, version, who,
                       who_description, what, what_description, logdate, logdate_tz, why, tr_seq, ev_seq)
   VALUES (a_new_mt, a_new_mt_version, UNAPIGEN.P_USER,
           UNAPIGEN.P_USER_DESCRIPTION, 'UNDIFF generated new version(1)',
           SUBSTR('UNDIFF generated new mt:('||a_new_mt||','||a_new_mt_version||') based on'||
                  '#old ref mt:('||a_oldref_mt||','||a_oldref_mt_version||')'||
                  '#old mt:('||a_old_mt||','||a_old_mt_version||')'||
                  '#new ref mt:('||a_newref_mt||','||a_newref_mt_version||')',1,255),
           CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, '', UNAPIGEN.P_TR_SEQ,
           NVL(UNAPIEV.P_EV_REC.ev_seq, -1));

/* Not neccessary for standadr Unilab Life cycle and standard Life cycle when using the interface - left for eventual customization */
--/*
--   l_api_name := 'CompareAndCreateMt';
--   l_evmgr_name := UNAPIGEN.P_EVMGR_NAME;
--   l_object_tp := 'mt';
--   l_object_id  := a_new_mt;
--   l_object_lc  := '@L';
--   l_object_ss  := '@E';
--   l_ev_tp      := 'ObjectUpdated';
--   l_ev_details := 'version=' ||a_new_mt_version||'#ss_to=@A';
--   l_seq_nr     := NULL;
--
--   l_ret_code := UNAPIEV.INSERTEVENT
--                   (l_api_name,
--                    l_evmgr_name,
--                    l_object_tp,
--                    l_object_id,
--                    l_object_lc,
--                    l_object_lc_version,
--                    l_object_ss,
--                    l_ev_tp,
--                    l_ev_details,
--                    l_seq_nr);
--   IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
--      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
--      l_sqlerrm := 'UNAPIEV.INSERTEVENT ret_code='||l_ret_code||'#mt='||a_new_mt
--                   ||'#version='||a_new_mt_version;
--      RAISE StpError;
--   END IF;
--*/

   IF UNAPIGEN.EndTxn <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE StpError;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF sqlcode <> 1 THEN
      UNAPIGEN.LogError('CompareAndCreateMt',sqlerrm);
   ELSIF l_sqlerrm IS NOT NULL THEN
      UNAPIGEN.LogError('CompareAndCreateMt',l_sqlerrm);
   END IF;
   IF l_utmt_cursor%ISOPEN THEN
      CLOSE l_utmt_cursor;
   END IF;
   RETURN(UNAPIGEN.AbortTxn(UNAPIGEN.P_TXN_ERROR, 'CompareAndCreateMt'));
END CompareAndCreateMt;

FUNCTION GetVersion
  RETURN VARCHAR2
IS
BEGIN
  RETURN('06.07.00.00_13.00');
EXCEPTION
  WHEN OTHERS THEN
	 RETURN (NULL);
END GetVersion;


BEGIN
   P_PP_KEY4PLANT := NULL;
END undiff;
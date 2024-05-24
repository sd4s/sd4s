CREATE OR REPLACE PACKAGE        APAOTRIALS AS
--------------------------------------------------------------------------------
--  PROJECT : Vredestein Enschede
-------------------------------------------------------------------------------
--  PACKAGE : APAOTRIALS
-- ABSTRACT :
--   WRITER : Rody Sparenberg
--     DATE : 06/02/2008
--   TARGET : Oracle 10.2.0
--  VERSION : av2.0.C05
--------------------------------------------------------------------------------
--  REMARKS :
--------------------------------------------------------------------------------
--  CHANGES :
--
--  When      | Who       | What
--============|===========|=====================================================
-- 06/02/2008 | RS        | Created
-- 15/02/2008 | RS        | Added RQ_A02
-- 19/02/2008 | RS        | Added CREATE_DBLINK
-- 19/06/2008 | RS        | Added UpdateMeGk
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- functions- and/or procedures-declarations
--------------------------------------------------------------------------------
FUNCTION RQ_A01
RETURN APAOGEN.RETURN_TYPE;

FUNCTION RQ_A02
RETURN APAOGEN.RETURN_TYPE;

FUNCTION CREATE_DBLINK
RETURN APAOGEN.RETURN_TYPE;

FUNCTION UpdateMeGk(avs_sc IN VARCHAR2, avs_gk IN VARCHAR2, avs_value IN VARCHAR2)
RETURN APAOGEN.RETURN_TYPE;

END APAOTRIALS;

/


CREATE OR REPLACE PACKAGE BODY        APAOTRIALS AS
--------------------------------------------------------------------------------
--  PROJECT : Vredestein Enschede
-------------------------------------------------------------------------------
--  PACKAGE : APAOTRIALS
-- ABSTRACT :
--   WRITER : Rody Sparenberg
--     DATE : 06/02/2008
--   TARGET : Oracle 10.2.0 / Unilab 6.3
--  VERSION : av3.0
--------------------------------------------------------------------------------
--  REMARKS : This package requires avao_trials
--------------------------------------------------------------------------------
--  CHANGES :
--
--  When      | Who       | What
--============|===========|=====================================================
-- 06/02/2008 | RS        | Created
-- 15/02/2008 | RS        | Added RQ_A02
-- 19/02/2008 | RS        | Changed scgkavpartno into scgkpart_no
--                        | Changed RQ_A01 : added RqWaitForAdditional
-- 19/02/2008 | RS        | Added CREATE_DBLINK
-- 28/05/2008 | RS        | Changed RQ_A01 : removed NO DATA FOUND error
-- 10/06/2008 | RS        | Changed RQ_A01 : added WaitForInitial
-- 16/06/2008 | RS        | Changed RQ_A01 : Removed endless loop
--                        |                  Added ss = @C
-- 19/06/2008 | RS        | Changed RQ_A01 : Changed cursor TEST
--                        | Added RecheckOtherRq
--                        | Changed RQ_A02 : Added RecheckOtherRq
-- 25/06/2008 | RS        | Changed RQ_A01 : Ignore BoM-level = 0
-- 03/03/2011 | RS        | Upgrade V6.3
--                        | Changed SYSDATE INTO CURRENT_TIMESTAMP
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
ics_package_name  CONSTANT VARCHAR2(20) := 'APAOTRIALS';

ics_au_expiration CONSTANT APAOGEN.NAME_TYPE := APAOCONSTANT.GetConstString ('au_expiration');

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- functions- and/or procedures-declarations
--------------------------------------------------------------------------------
FUNCTION SetConnection(avs_user          IN APAOGEN.NAME_TYPE)
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'SetConnection';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN
  --------------------------------------------------------------------------------
  -- Make a connection to Interspec
  --------------------------------------------------------------------------------
  lvi_ret_code := iapiGeneral.SetConnection(asUserId => avs_user, asModuleName => lcs_function_name);

  RETURN(lvi_ret_code);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;
END SetConnection;

FUNCTION Explode(asPartNo     IN  iapiType.PartNo_Type,
                 anRevision   IN  iapiType.Revision_Type,
                 asPlant      IN  iapiType.Plant_Type,
                 anUniqueId   OUT iapiType.Sequence_Type)
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name       CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'Explode';
lvs_sqlerrm             APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code            iapiType.ErrorNum_Type;

lnAlternative           iapiType.BomAlternative_Type  := 1;
lnUsage                 iapiType.BomUsage_Type        := 1;
lnBatchQuantity         iapiType.BomQuantity_Type     := 1;
lnExplosionType         iapiType.NumVal_Type          := 1;
lnIncludeInDevelopment  iapiType.Boolean_Type         := 0;
ldExplosionDate         iapiType.Date_Type            := CURRENT_TIMESTAMP;
lqErrors                iapiType.Ref_Type;
lvs_user                APAOGEN.API_NAME_TYPE;

BEGIN

  --------------------------------------------------------------------------------
  -- Get Interspec-user from ATAOCONSTANT
  --------------------------------------------------------------------------------
  lvs_user := APAOCONSTANT.GetConstString ('InterspecUser');
  --------------------------------------------------------------------------------
  -- Make a connection to Interspec
  --------------------------------------------------------------------------------
  lvi_ret_code := SetConnection(lvs_user);

  IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
     lvs_sqlerrm := 'Unable to make a connection with Interspec. Error code <' || lvi_ret_code || '>';
     UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
     RETURN UNAPIGEN.DBERR_GENFAIL;
  END IF;
  --------------------------------------------------------------------------------
  -- Retrieve a new explosion ID from Interspec
  --------------------------------------------------------------------------------
  BEGIN
     SELECT bom_explosion_seq.NEXTVAL
       INTO anUniqueId
       FROM DUAL;

  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE != 1 THEN
        lvs_sqlerrm := 'Error while retrieving next_val of sequence "bom_explosion_seq" from Interspec';
        UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
        RETURN UNAPIGEN.DBERR_GENFAIL;
      END IF;
  END;
  --------------------------------------------------------------------------------
  -- Execute the BoM-explosion
  --------------------------------------------------------------------------------
  lvi_ret_code := iapiSpecificationBom.Explode(anUniqueId             => anUniqueId,
                                               asPartNo               => asPartNo,
                                               anRevision             => anRevision,
                                               asPlant                => asPlant,
                                               adExplosionDate        => ldExplosionDate,
                                               anAlternative          => lnAlternative,
                                               anUsage                => lnUsage,
                                               anBatchQuantity        => lnBatchQuantity,
                                               anExplosionType        => lnExplosionType,
                                               anIncludeInDevelopment => lnIncludeInDevelopment,
                                               aqErrors               => lqErrors);

  IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
     lvs_sqlerrm := 'BomExplosion failed for "' || asPartNo || ' [' || anRevision || ']". Error code <' || lvi_ret_code || '>';
     UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
     RETURN UNAPIGEN.DBERR_GENFAIL;
  END IF;

  RETURN lvi_ret_code;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;
END Explode;

FUNCTION GetActivity(avs_sc IN APAOGEN.NAME_TYPE)
RETURN VARCHAR2 IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'GetActivity';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvs_activity      VARCHAR2(20);

CURSOR lvq_activity(avs_sc IN VARCHAR2) IS
  SELECT value activity
    FROM utstau a, utsc b
   WHERE a.au = 'avCustScActivity'
     AND a.st = b.st
     AND b.sc = avs_sc
     AND a.version = b.st_version;

BEGIN
  --------------------------------------------------------------------------------
  -- Retrieve activity for current sample : CREATE / TEST
  --------------------------------------------------------------------------------
  FOR lvr_activity IN lvq_activity(avs_sc) LOOP
      RETURN lvr_activity.activity;
  END LOOP;

  RETURN NULL;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN NULL;
END GetActivity;

FUNCTION UpdateMeGk(avs_sc IN VARCHAR2, avs_gk IN VARCHAR2, avs_value IN VARCHAR2)
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'UpdateMeGk';

lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;

CURSOR lvq_me IS
    SELECT sc,
           pg, pgnode,
           pa, panode,
           me, menode
      FROM utscme
     WHERE sc = avs_sc;

lvs_value   VARCHAR2(40);
BEGIN

   lvs_value := avs_value;
   --------------------------------------------------------------------------------
   -- Execute tildesubstitution
   --------------------------------------------------------------------------------
   lvi_ret_code := UNAPIGEN.SubstituteAllTildesInText (UNAPIEV.P_EV_REC.OBJECT_TP, '~EV_REC~', lvs_value);

   FOR lvr_me IN lvq_me LOOP
      UNAPIEV.P_PG := lvr_me.pg;
      UNAPIEV.P_PGNODE := lvr_me.pgnode;
      UNAPIEV.P_PA := lvr_me.pa;
      UNAPIEV.P_PANODE := lvr_me.panode;
      UNAPIEV.P_ME := lvr_me.me;
      UNAPIEV.P_MENODE := lvr_me.menode;
      lvi_ret_code := UNACTION.ASSIGNGROUPKEY('megk', avs_gk, lvs_value, 1, 40);
   END LOOP;

   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END UpdateMeGk;

FUNCTION RecheckOtherRq(avs_rq IN VARCHAR2)
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'RecheckOtherRq';

lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;

CURSOR lvq_rq_check IS
    SELECT rq,
           rt_version,
           lc, lc_version,
           ss
      FROM utrq
     WHERE rq = avs_rq;

BEGIN

   FOR lvr_rq_check IN lvq_rq_check LOOP
        lvi_ret_code   := APAOFUNCTIONS.RecheckRq( lvr_rq_check.rq,
                                                   lvr_rq_check.rt_version,
                                                   lvr_rq_check.lc,
                                                   lvr_rq_check.lc_version,
                                                   lvr_rq_check.ss);
   END LOOP;

   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END RecheckOtherRq;

FUNCTION RQ_A01
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name   CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'RQ_A01';

lvs_sqlerrm         APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code        APAOGEN.RETURN_TYPE;
lnBomExplId         NUMBER;

lvs_activity        VARCHAR2(20);
lvi_additional_wait NUMBER       := 0;
lvs_additional_wait VARCHAR2(20) := '-';

CURSOR lvq_sc IS
  SELECT c.part_no, c.revision, c.plant, a.sc
    FROM utrqsc a, utscgkpart_no b, avao_trials c, utsc d
   WHERE a.rq = UNAPIEV.P_RQ
     AND a.sc = b.sc
     AND a.sc = d.sc
     AND d.ss != '@C'
     AND b.part_no = c.part_no;

CURSOR lvq_create(anBomExplId IN NUMBER) IS
  SELECT d.rq
    FROM itbomexplosion@interspec a, utscgkpart_no b, utrqsc c, utrq d, utsc e, utstau f
   WHERE a.bom_exp_no = anBomExplId
     AND a.component_part = b.part_no
     AND b.sc = c.sc
     AND c.rq = d.rq
     and d.rq != UNAPIEV.P_RQ
     AND d.ss NOT IN ('RJ','ST','CM', '@C')
     AND e.sc = c.sc
     AND e.ss != '@C'
     AND e.st = f.st AND e.st_version = f.version
     AND f.au = 'avCustScActivity' AND f.value = 'CREATE'
     AND a.bom_level != 0;

CURSOR lvq_test(avsPartNo IN  VARCHAR2) IS
  SELECT d.rq
    FROM utscgkpart_no b, utrqsc c, utrq d, utsc e, utstau f
   WHERE b.part_no = avsPartNo
     AND b.sc = c.sc
     AND c.rq = d.rq
     and d.rq != UNAPIEV.P_RQ
     AND d.ss NOT IN ('RJ','ST','CM', '@C')
     AND e.sc = c.sc
     AND e.ss != '@C'
     AND e.st = f.st AND e.st_version = f.version
     AND f.au = 'avCustScActivity' AND f.value = 'CREATE';

BEGIN
   --------------------------------------------------------------------------------
   -- Loop through all samples of current request
   --------------------------------------------------------------------------------
   FOR lvr_sc IN lvq_sc LOOP
      --------------------------------------------------------------------------------
      -- Retrieve activity
      --------------------------------------------------------------------------------
      lvs_activity := APAOTRIALS.GetActivity(lvr_sc.sc);
      --------------------------------------------------------------------------------
      -- activity = CREATE --> Check if we have to wait for component of BoM
      --------------------------------------------------------------------------------
      IF lvs_activity = 'CREATE' THEN
        --------------------------------------------------------------------------------
        -- Execute the BoM-explosion for scii value of ii_PartNo
        --------------------------------------------------------------------------------
        lvi_ret_code := APAOTRIALS.Explode(lvr_sc.part_no,
                                           lvr_sc.revision,
                                           lvr_sc.plant,
                                           lnBomExplId);
        IF lvi_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
           --------------------------------------------------------------------------------
           -- Loop through all parts of the BoM-explosion
           --------------------------------------------------------------------------------
           FOR lvr_create IN lvq_create(lnBomExplId) LOOP
               lvi_ret_code := APAOFUNCTIONS.AddValueToRqGk(UNAPIEV.P_RQ,
                                                         'WaitFor',
                                                         lvr_create.rq);
               lvi_ret_code := APAOFUNCTIONS.AddValueToRqGk(UNAPIEV.P_RQ,
                                                         'WaitForInitial',
                                                         lvr_create.rq);
           END LOOP;
        END IF;
      --------------------------------------------------------------------------------
      -- activity = TEST --> Check if we have to wait for the CREATE rq
      --------------------------------------------------------------------------------
      ELSIF lvs_activity = 'TEST' THEN
         --------------------------------------------------------------------------------
         -- Loop through all rq with create samples of the same part
         --------------------------------------------------------------------------------
         FOR lvr_test IN lvq_test(lvr_sc.part_no) LOOP
            lvi_ret_code := APAOFUNCTIONS.AddValueToRqGk(UNAPIEV.P_RQ,
                                                      'WaitFor',
                                                      lvr_test.rq);
            lvi_ret_code := APAOFUNCTIONS.AddValueToRqGk(UNAPIEV.P_RQ,
                                                      'WaitForInitial',
                                                      lvr_test.rq);
         END LOOP;
      END IF;
   END LOOP;

   --------------------------------------------------------------------------------
   -- Loop through all requests found in current rqii avRqReqWaitFor
   -- Requests are separated by TAB
   --------------------------------------------------------------------------------
   lvi_additional_wait := 0;
   lvs_additional_wait := '-';
   WHILE lvs_additional_wait IS NOT NULL LOOP
      lvi_additional_wait := lvi_additional_wait + 1;

      SELECT NVL(MAX(APAOGEN.STRTOK(iivalue, '	', lvi_additional_wait)), '-')
        INTO lvs_additional_wait
        FROM utrqii
       WHERE rq = UNAPIEV.P_RQ
         AND ii = 'avRqReqWaitFor';

      IF lvs_additional_wait != '-' THEN
         --------------------------------------------------------------------------------
         -- Assign rqgk WaitFor
         --------------------------------------------------------------------------------
         lvi_ret_code := APAOFUNCTIONS.AddValueToRqGk(UNAPIEV.P_RQ,
                                                      'WaitFor',
                                                      lvs_additional_wait);
         lvi_ret_code := APAOFUNCTIONS.AddValueToRqGk(UNAPIEV.P_RQ,
                                                      'WaitForInitial',
                                                      lvs_additional_wait);
      ELSE
         EXIT;
      END IF;
   END LOOP;

   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END RQ_A01;

FUNCTION RQ_A02
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'RQ_A02';

lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;

CURSOR lvq_rq IS
SELECT rq, waitfor
  FROM utrqgkwaitfor
 WHERE waitfor = UNAPIEV.P_RQ;

BEGIN

   FOR lvr_rq IN lvq_rq LOOP
      lvi_ret_code := APAOFUNCTIONS.RemValueFromRqGk(lvr_rq.rq, 'WaitFor', lvr_rq.waitfor);
      lvi_ret_code := RecheckOtherRq(lvr_rq.rq);
   END LOOP;

   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END RQ_A02;

FUNCTION CREATE_DBLINK(avs_host IN VARCHAR2,
                       avs_username IN VARCHAR2,
                       avs_password IN VARCHAR2)
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'CREATE_DBLINK';

lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;

BEGIN

DBMS_OUTPUT.PUT_LINE(avs_host);
DBMS_OUTPUT.PUT_LINE(avs_username);
DBMS_OUTPUT.PUT_LINE(avs_password);
   lvi_ret_code := UNAPIGEN.UNEXECDDL('drop public database link "INTERSPEC"');
DBMS_OUTPUT.PUT_LINE(lvi_ret_code);
   lvi_ret_code := UNAPIGEN.UNEXECDDL('create public database link "INTERSPEC" connect to ' || avs_username || ' identified by "' || avs_password || '" using ''' || avs_host || '''');
DBMS_OUTPUT.PUT_LINE(lvi_ret_code);
   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END CREATE_DBLINK;

FUNCTION CREATE_DBLINK
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'CREATE_DBLINK';

lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;

BEGIN

    RETURN CREATE_DBLINK(APAOCONSTANT.GetConstString ('InterspecDatabase'),
                         'INTERSPC',
                         'moonflower');

END CREATE_DBLINK;

END APAOTRIALS;
/

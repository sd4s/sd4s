CREATE OR REPLACE PACKAGE        APAOEVRULES AS
--------------------------------------------------------------------------------
--  PROJECT : Vredestein Enschede
-------------------------------------------------------------------------------
--  PACKAGE : APAOEVRULES
-- ABSTRACT :
--   WRITER : Rody Sparenberg
--     DATE : 15/03/2007
--   TARGET : Oracle 10.2.0
--  VERSION : 6.1.1	$Revision: 1 $
--------------------------------------------------------------------------------
--  REMARKS :
--------------------------------------------------------------------------------
--  CHANGES :
--
--  When      | Who       | What
--============|===========|=====================================================
-- 15/03/2007 | RS        | Created
-- 01/02/2008 | RS        | Added MtGroupOnly (av1.2.C04)
-- 06/08/2008 | RS        | Renamed MtGroupOnly into AllowDuplo (and attribute)
-- 11/02/2009 | RS        | Added meCustomSQL
-- 11/03/2009 | RS        | Added meCustomSQLWithOverwrite (av2.2.C03)
--                        | Added rqCopyStatus2ScGk (av2.2.C06)
-- 13/02/2013 | RS        | Added iiCreated_by
-- 23/06/2016 | JP/JR     | Added CopyRqIiToScIi
-- 18/07/2016 | JP/JR     | Added ChangeavScSite 		(ERULG010)
-- 18/07/2016 | JP/JR     | Added SetRqIiMaxDateScIi	(ERULG013B)
-- 18/07/2016 | JP/JR     | Added UpdScMeGkScPropSc, UpdScMeGkScPropIi (ERULG008C)
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
FUNCTION INHERIT_RQGK(avs_rq IN APAOGEN.RQ_TYPE)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION INHERIT_SCGK(avs_sc IN APAOGEN.SC_TYPE)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION INHERIT_SCGK(avs_sc IN APAOGEN.SC_TYPE,
                      avs_pg IN APAOGEN.PG_TYPE, avn_pgnode IN APAOGEN.PGNODE_TYPE,
                      avs_pa IN APAOGEN.PA_TYPE, avn_panode IN APAOGEN.PANODE_TYPE,
                      avs_me IN APAOGEN.ME_TYPE, avn_menode IN APAOGEN.MENODE_TYPE)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION CALCULATE_SPA(avs_pp 			IN APAOGEN.PP_TYPE,
							  avs_ev_details 	IN VARCHAR2)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION Irrelevant
RETURN APAOGEN.RETURN_TYPE;

FUNCTION ControleWacht
RETURN APAOGEN.RETURN_TYPE;

FUNCTION AllowDuplo
RETURN APAOGEN.RETURN_TYPE;

FUNCTION meCustomSQL
RETURN APAOGEN.RETURN_TYPE;

FUNCTION meCustomSQLWithOverwrite
RETURN APAOGEN.RETURN_TYPE;

FUNCTION rqCopyStatus2ScGk
RETURN APAOGEN.RETURN_TYPE;

FUNCTION iiCreated_by(avs_ii IN VARCHAR2)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION CopyRqIiToScIi
RETURN APAOGEN.RETURN_TYPE;

FUNCTION ChangeavScSite
RETURN APAOGEN.RETURN_TYPE;

FUNCTION SetRqIiMaxDateScIi
RETURN APAOGEN.RETURN_TYPE;

FUNCTION UpdScMeGkScPropSc
RETURN APAOGEN.RETURN_TYPE;

FUNCTION UpdScMeGkScPropIi
RETURN APAOGEN.RETURN_TYPE;


END APAOEVRULES;
/


CREATE OR REPLACE PACKAGE BODY        APAOEVRULES AS
--------------------------------------------------------------------------------
--  PROJECT : Vredestein Enschede
-------------------------------------------------------------------------------
--  PACKAGE : APAOEVRULES
-- ABSTRACT :
--   WRITER : Rody Sparenberg
--     DATE : 15/03/2007
--   TARGET : Oracle 10.2.0
--  VERSION : av2.03
--------------------------------------------------------------------------------
--  REMARKS :
--------------------------------------------------------------------------------
--  CHANGES :
--
--  When      | Who       | What
--============|===========|=====================================================
-- 15/03/2007 | RS        | Created
-- 13/04/2007 | RS       | Changed Irrelevant
-- 13/04/2007 | RS       | Changed ControleWacht
-- 19/07/2007 | AF        | Changed INHERIT_SCGK
-- 30/10/2007 | RS        | Changed INHERIT_RQGK : ignore DBERR_TRANSITION
--                        | Changed INHERIT_SCGK : ignore DBERR_TRANSITION
-- 01/02/2008 | RS        | Added MtGroupOnly (av1.2.C04)
-- 19/02/2008 | RS        | Changed MtGroupOnly (av1.2.C04)
-- 02/04/2008 | RS       | Changed ControleWacht
-- 03/06/2008 | RS        | Changed MtGroupOnly
-- 03/06/2008 | HVB       | Changed MtGroupOnly back
-- 11/06/2007 | RS        | Changed INHERIT_SCGK
-- 06/08/2008 | RS        | Renamed MtGroupOnly into AllowDuplo (and attribute)
-- 11/02/2009 | RS        | Added meCustomSQL
-- 11/03/2009 | RS        | Added meCustomSQLWithOverwrite (av2.2.C03)
--                        | Changed meCustomSQL  (av2.2.C03)
--                        | Added rqCopyStatus2ScGk (av2.2.C06)
-- 25/03/2009 | RS        | Changed rqCopyStatus2ScGk (av2.2.C06)
-- 08/04/2009 | RS        |"Changed rqCopyStatus2ScGk (av2.2.C06) (except status @~)
-- 28/05/2009 | RS        | Changed meCustomSQL (bug value_s = null)
-- 04/06/2009 | RS        | Changed rqCopyStatus2ScGk (prevent locks due to in transition)
-- 31/05/2011 | HVB       | Removed the exclustion for TP013B
-- 23/08/2011 | RS        | Changed rqCopyStatus2ScGk (fix out of sequence error)
-- 13/02/2013 | RS        | Added iiCreated_by
-- 23/06/2016 | JP/JR     | Added CopyRqIiToScIi 		(ERULG009)
-- 18/07/2016 | JP/JR     | Added ChangeavScSite 		(ERULG010)
-- 18/07/2016 | JP/JR     | Added SetRqIiMaxDateScIi	(ERULG013B)
-- 18/07/2016 | JP/JR     | Added UpdScMeGkScPropSc, UpdScMeGkScPropIi (ERULG008C)
-- 25/08/2016 | JP        | Corrected TildeSubstitution handling in meCustomSQL
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
ics_package_name                 CONSTANT APAOGEN.API_NAME_TYPE := 'APAOEVRULES';
ics_au_wait_for                  CONSTANT APAOGEN.NAME_TYPE      := APAOCONSTANT.GetConstString ('au_wait_for');
ics_au_createpgmultiple          CONSTANT APAOGEN.NAME_TYPE      := APAOCONSTANT.GetConstString ('au_createpgmultiple');
ics_au_createpamultiple          CONSTANT APAOGEN.NAME_TYPE      := APAOCONSTANT.GetConstString ('au_createpamultiple');
ics_au_specification             CONSTANT APAOGEN.NAME_TYPE      := APAOCONSTANT.GetConstString ('au_specification');
ics_ss_cancelled                 CONSTANT APAOGEN.NAME_TYPE      := APAOCONSTANT.GetConstString ('ss_cancelled');
ics_ss_irrelevant                CONSTANT APAOGEN.NAME_TYPE      := APAOCONSTANT.GetConstString ('ss_irrelevant');
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_sqlerrm         VARCHAR2(255);
lvi_ret_code        NUMBER;
StpError            EXCEPTION;

--------------------------------------------------------------------------------
-- functions- and/or procedures-declarations
--------------------------------------------------------------------------------
FUNCTION INHERIT_RQGK(avs_rq IN APAOGEN.RQ_TYPE)
RETURN APAOGEN.RETURN_TYPE IS
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------
CURSOR lvq_scgk IS
    SELECT b.sc,
             a.gk, a.gk_version,
             a.value
      FROM utrqgk a,
               utscgk b,
               utrqsc c
     WHERE a.rq = avs_rq
       AND a.rq = c.rq
       AND b.sc = c.sc
       AND a.gk = b.gk
       AND NVL(a.value,'-') != NVL(b.value,'-');

lvs_gk_version     APAOGEN.VERSION_TYPE;
lvs_modify_reason    APAOGEN.MODIFY_REASON_TYPE;
lts_value            UNAPIGEN.VC40_TABLE_TYPE;
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'INHERIT_RQGK';
BEGIN
    APAOFUNCTIONS.LogInfo(lcs_function_name, 'Start of <INHERIT_RQGK> for ' ||
                                             '#rq=' || avs_rq );

    FOR lvr_scgk IN lvq_scgk LOOP
        APAOFUNCTIONS.LogInfo(lcs_function_name, 'Toevoegen <' || lvr_scgk.gk || '> aan ' || lvr_scgk.sc );

        lts_value(1) := lvr_scgk.value;
        lvs_modify_reason := 'Groupkey <' || lvr_scgk.gk || '> updated with <' || lvr_scgk.value || '> by ' || ics_package_name || '.INHERIT_RQGK';
        --------------------------------------------------------------------------------
        -- Save scgk
        --------------------------------------------------------------------------------
        lvi_ret_code := UNAPISCP.Save1ScGroupKey(lvr_scgk.sc,
                                                 lvr_scgk.gk, lvs_gk_version,
                                                 lts_value, 1,
                                                 lvs_modify_reason);

      IF lvi_ret_code <> UNAPIGEN.DBERR_SUCCESS AND
         lvi_ret_code <> UNAPIGEN.DBERR_UNIQUEGK AND
         lvi_ret_code <> UNAPIGEN.DBERR_TRANSITION THEN
         lvs_sqlerrm := 'Save1ScGroupKey#return=' || TO_CHAR(lvi_ret_code) ||
                              '#sc=' || lvr_scgk.sc ||
                              '#gk=' || lvr_scgk.gk || '#gk_version=' || lvs_gk_version || '#nr_of_rows=' || 1;
         RAISE StpError;
      END IF;
      --------------------------------------------------------------------------------
      -- Save scgk to megk
      --------------------------------------------------------------------------------
      lvi_ret_code := APAOEVRULES.INHERIT_SCGK(lvr_scgk.sc);

    END LOOP;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      lvs_sqlerrm := SUBSTR(SQLERRM,1,255);
   END IF;
   APAOGEN.LogError(ics_package_name, lvs_sqlerrm);
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END INHERIT_RQGK;

FUNCTION INHERIT_SCGK(avs_sc IN APAOGEN.SC_TYPE)
RETURN APAOGEN.RETURN_TYPE IS
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------
CURSOR lvq_add_missing_megk IS
   SELECT b.sc, b.pg, b.pgnode, b.pa, b.panode, b.me, b.menode, a.gk,
          CASE WHEN version IS NULL THEN
             '0'
          ELSE
             version
          END gk_version
     FROM utgkme a, utscme b
    WHERE struct_created = '1'
      AND a.gk IN (SELECT gk
                     FROM utscgk
                    WHERE sc = avs_sc)
      AND b.sc = avs_sc
   MINUS
   SELECT sc, pg, pgnode, pa, panode, me, menode, gk,
          CASE WHEN gk_version IS NULL THEN
             '0'
          ELSE
             gk_version
          END gk_version
     FROM utscmegk
    WHERE sc = avs_sc;

CURSOR lvq_megk IS
    SELECT b.sc,
             b.pg, b.pgnode,
             b.pa, b.panode,
             b.me, b.menode,
             a.gk, a.gk_version,
             a.value
      FROM utscgk a,
               utscmegk b
     WHERE a.sc = b.sc
       AND a.sc = avs_sc
       AND a.gk = b.gk
        AND NVL(a.value,'-') != NVL(b.value,'-');

lvs_gk_version     APAOGEN.VERSION_TYPE;
lvs_modify_reason    APAOGEN.MODIFY_REASON_TYPE;
lts_value            UNAPIGEN.VC40_TABLE_TYPE;
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'INHERIT_SCGK';

BEGIN
   APAOFUNCTIONS.LogInfo(lcs_function_name, 'Start of <INHERIT_SCGK> for ' ||
                                            '#sc=' || avs_sc );
   -----------------------------------------------------------------------------------
   -- First add missing groupkeys with an empty value
   -----------------------------------------------------------------------------------
   FOR lvr_add_missing_megk in lvq_add_missing_megk LOOP
        APAOFUNCTIONS.LogInfo(lcs_function_name, 'Toevoegen <' || lvr_add_missing_megk.gk || '> aan ' || lvr_add_missing_megk.me );

        lts_value(1) := NULL;
        lvs_modify_reason := 'Groupkey <' || lvr_add_missing_megk.gk || '> added by ' || ics_package_name || '.INHERIT_SCGK';
        --------------------------------------------------------------------------------
        -- Save scgk
        --------------------------------------------------------------------------------
        lvi_ret_code := UNAPIMEP.Save1ScMeGroupKey(lvr_add_missing_megk.sc,
                                                   lvr_add_missing_megk.pg, lvr_add_missing_megk.pgnode,
                                                   lvr_add_missing_megk.pa, lvr_add_missing_megk.panode,
                                                   lvr_add_missing_megk.me, lvr_add_missing_megk.menode,
                                                   lvr_add_missing_megk.gk, lvr_add_missing_megk.gk_version,
                                                   lts_value, 1,
                                                   lvs_modify_reason);

      IF lvi_ret_code <> UNAPIGEN.DBERR_SUCCESS AND
         lvi_ret_code <> UNAPIGEN.DBERR_UNIQUEGK AND
         lvi_ret_code <> UNAPIGEN.DBERR_TRANSITION THEN

         lvs_sqlerrm := 'Save1ScMeGroupKey#return=' || TO_CHAR(lvi_ret_code) ||
                             '#sc=' || lvr_add_missing_megk.sc ||
                             '#pg=' || lvr_add_missing_megk.pg || '#pgnode=' || TO_CHAR(lvr_add_missing_megk.pgnode) ||
                             '#pa=' || lvr_add_missing_megk.pa || '#panode=' || TO_CHAR(lvr_add_missing_megk.panode) ||
                             '#me=' || lvr_add_missing_megk.me || '#menode=' || TO_CHAR(lvr_add_missing_megk.menode) ||
                             '#gk=' || lvr_add_missing_megk.gk || '#gk_version=' || lvr_add_missing_megk.gk_version || '#nr_of_rows=' || 1;
         RAISE StpError;
      END IF;
   END LOOP;

   -----------------------------------------------------------------------------------
   -- Next update the corresponding groupkeys on method level from sample level
    -----------------------------------------------------------------------------------
    FOR lvr_megk IN lvq_megk LOOP
        APAOFUNCTIONS.LogInfo(lcs_function_name, 'Update <' || lvr_megk.gk || '> with <' || lvr_megk.value || '>');

        lts_value(1) := lvr_megk.value;
        lvs_modify_reason := 'Groupkey <' || lvr_megk.gk || '> updated with <' || lvr_megk.value || '> by ' || ics_package_name || '.INHERIT_SCGK';
        --------------------------------------------------------------------------------
        -- Save scgk
        --------------------------------------------------------------------------------
        lvi_ret_code := UNAPIMEP.Save1ScMeGroupKey(lvr_megk.sc,
                                                                 lvr_megk.pg, lvr_megk.pgnode,
                                                 lvr_megk.pa, lvr_megk.panode,
                                                 lvr_megk.me, lvr_megk.menode,
                                                 lvr_megk.gk, lvs_gk_version,
                                                 lts_value, 1,
                                                 lvs_modify_reason);

      IF lvi_ret_code <> UNAPIGEN.DBERR_SUCCESS AND
         lvi_ret_code <> UNAPIGEN.DBERR_UNIQUEGK AND
         lvi_ret_code <> UNAPIGEN.DBERR_TRANSITION THEN
         lvs_sqlerrm := 'Save1ScMeGroupKey#return=' || TO_CHAR(lvi_ret_code) ||
                             '#sc=' || lvr_megk.sc ||
                             '#pg=' || lvr_megk.pg || '#pgnode=' || TO_CHAR(lvr_megk.pgnode) ||
                             '#pa=' || lvr_megk.pa || '#panode=' || TO_CHAR(lvr_megk.panode) ||
                             '#me=' || lvr_megk.me || '#menode=' || TO_CHAR(lvr_megk.menode) ||
                             '#gk=' || lvr_megk.gk || '#gk_version=' || lvs_gk_version || '#nr_of_rows=' || 1;
         RAISE StpError;
      END IF;
    END LOOP;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      lvs_sqlerrm := SUBSTR(SQLERRM,1,255);
   END IF;
   APAOGEN.LogError(lcs_function_name, lvs_sqlerrm);
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END INHERIT_SCGK;

FUNCTION INHERIT_SCGK(avs_sc IN APAOGEN.SC_TYPE,
                      avs_pg IN APAOGEN.PG_TYPE, avn_pgnode IN APAOGEN.PGNODE_TYPE,
                      avs_pa IN APAOGEN.PA_TYPE, avn_panode IN APAOGEN.PANODE_TYPE,
                      avs_me IN APAOGEN.ME_TYPE, avn_menode IN APAOGEN.MENODE_TYPE)
RETURN APAOGEN.RETURN_TYPE IS
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------
CURSOR lvq_add_missing_megk IS
   SELECT b.sc, b.pg, b.pgnode, b.pa, b.panode, b.me, b.menode, a.gk,
          CASE WHEN version IS NULL THEN
             '0'
          ELSE
             version
          END gk_version
     FROM utgkme a, utscme b
    WHERE struct_created = '1'
      AND a.gk IN (SELECT gk
                     FROM utscgk
                    WHERE sc = avs_sc)
      AND b.sc = avs_sc
      AND b.pg = avs_pg AND b.pgnode = avn_pgnode
      AND b.pa = avs_pa AND b.panode = avn_panode
      AND b.me = avs_me AND b.menode = avn_menode
   MINUS
   SELECT sc, pg, pgnode, pa, panode, me, menode, gk,
          CASE WHEN gk_version IS NULL THEN
             '0'
          ELSE
             gk_version
          END gk_version
     FROM utscmegk
    WHERE sc = avs_sc
      AND pg = avs_pg AND pgnode = avn_pgnode
      AND pa = avs_pa AND panode = avn_panode
      AND me = avs_me AND menode = avn_menode;

CURSOR lvq_megk IS
    SELECT b.sc,
             b.pg, b.pgnode,
             b.pa, b.panode,
             b.me, b.menode,
             a.gk, a.gk_version,
             a.value
      FROM utscgk a,
               utscmegk b
     WHERE a.sc = b.sc
       AND b.pg = avs_pg AND b.pgnode = avn_pgnode
       AND b.pa = avs_pa AND b.panode = avn_panode
       AND b.me = avs_me AND b.menode = avn_menode
       AND a.sc = avs_sc
       AND a.gk = b.gk
       AND NVL(a.value,'-') != NVL(b.value,'-');

lvs_gk_version       APAOGEN.VERSION_TYPE;
lvs_modify_reason    APAOGEN.MODIFY_REASON_TYPE;
lts_value            UNAPIGEN.VC40_TABLE_TYPE;
lcs_function_name    CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'INHERIT_SCGK';
lvi_count            NUMBER;
BEGIN

   lvi_ret_code := UNAPIAUT.DISABLEALLOWMODIFYCHECK('1');

   APAOFUNCTIONS.LogInfo(lcs_function_name, 'Start of <INHERIT_SCGK> for ' ||
                                            '#sc=' || avs_sc ||
                                            '#pg=' || avs_pg || '#pgnode=' || TO_CHAR(avn_pgnode) ||
                                            '#pa=' || avs_pa || '#panode=' || TO_CHAR(avn_panode) ||
                                            '#me=' || avs_me || '#menode=' || TO_CHAR(avn_menode));

   SELECT count(*)
     INTO lvi_count
     FROM utscgk
    WHERE sc = avs_sc;

   APAOFUNCTIONS.LogInfo(lcs_function_name, lvi_count || ' samplegroupkeys found for #sc=' || avs_sc);

   SELECT count(*)
     INTO lvi_count
     FROM utscmegk
    WHERE sc = avs_sc
      AND pg = avs_pg AND pgnode = avn_pgnode
      AND pa = avs_pa AND panode = avn_panode
      AND me = avs_me AND menode = avn_menode;

   APAOFUNCTIONS.LogInfo(lcs_function_name, lvi_count || ' methodgroupkeys found for #sc=' ||
                                            '#pg=' || avs_pg || '#pgnode=' || TO_CHAR(avn_pgnode) ||
                                            '#pa=' || avs_pa || '#panode=' || TO_CHAR(avn_panode) ||
                                            '#me=' || avs_me || '#menode=' || TO_CHAR(avn_menode));
   -----------------------------------------------------------------------------------
   -- First add missing groupkeys with an empty value
   -----------------------------------------------------------------------------------
   FOR lvr_add_missing_megk in lvq_add_missing_megk LOOP
      APAOFUNCTIONS.LogInfo(lcs_function_name, 'Toevoegen <' || lvr_add_missing_megk.gk || '> aan ' || lvr_add_missing_megk.me );

      lts_value(1) := NULL;
      lvs_modify_reason := 'Groupkey <' || lvr_add_missing_megk.gk || '> added by ' || ics_package_name || '.INHERIT_SCGK';
        --------------------------------------------------------------------------------
        -- Save scgk
        --------------------------------------------------------------------------------
        lvi_ret_code := UNAPIMEP.Save1ScMeGroupKey(lvr_add_missing_megk.sc,
                                                   lvr_add_missing_megk.pg, lvr_add_missing_megk.pgnode,
                                                   lvr_add_missing_megk.pa, lvr_add_missing_megk.panode,
                                                   lvr_add_missing_megk.me, lvr_add_missing_megk.menode,
                                                   lvr_add_missing_megk.gk, lvr_add_missing_megk.gk_version,
                                                   lts_value, 1,
                                                   lvs_modify_reason);

      IF lvi_ret_code <> UNAPIGEN.DBERR_SUCCESS AND
         lvi_ret_code <> UNAPIGEN.DBERR_UNIQUEGK AND
         lvi_ret_code <> UNAPIGEN.DBERR_TRANSITION THEN

         lvs_sqlerrm := 'Save1ScMeGroupKey#return=' || TO_CHAR(lvi_ret_code) ||
                             '#sc=' || lvr_add_missing_megk.sc ||
                             '#pg=' || lvr_add_missing_megk.pg || '#pgnode=' || TO_CHAR(lvr_add_missing_megk.pgnode) ||
                             '#pa=' || lvr_add_missing_megk.pa || '#panode=' || TO_CHAR(lvr_add_missing_megk.panode) ||
                             '#me=' || lvr_add_missing_megk.me || '#menode=' || TO_CHAR(lvr_add_missing_megk.menode) ||
                             '#gk=' || lvr_add_missing_megk.gk || '#gk_version=' || lvr_add_missing_megk.gk_version || '#nr_of_rows=' || 1;
         RAISE StpError;
      END IF;
   END LOOP;

   -----------------------------------------------------------------------------------
   -- Next update the corresponding groupkeys on method level from sample level
    -----------------------------------------------------------------------------------
    FOR lvr_megk IN lvq_megk LOOP
        APAOFUNCTIONS.LogInfo(lcs_function_name, 'Update <' || lvr_megk.gk || '> with <' || lvr_megk.value || '>');

        lts_value(1) := lvr_megk.value;
        lvs_modify_reason := 'Groupkey <' || lvr_megk.gk || '> updated with <' || lvr_megk.value || '> by ' || ics_package_name || '.INHERIT_SCGK';
        --------------------------------------------------------------------------------
        -- Save scgk
        --------------------------------------------------------------------------------
        lvi_ret_code := UNAPIMEP.Save1ScMeGroupKey(lvr_megk.sc,
                                                   lvr_megk.pg, lvr_megk.pgnode,
                                                   lvr_megk.pa, lvr_megk.panode,
                                                   lvr_megk.me, lvr_megk.menode,
                                                   lvr_megk.gk, lvs_gk_version,
                                                   lts_value, 1,
                                                   lvs_modify_reason);

      IF lvi_ret_code <> UNAPIGEN.DBERR_SUCCESS AND
         lvi_ret_code <> UNAPIGEN.DBERR_UNIQUEGK AND
         lvi_ret_code <> UNAPIGEN.DBERR_TRANSITION THEN
         lvs_sqlerrm := 'Save1ScMeGroupKey#return=' || TO_CHAR(lvi_ret_code) ||
                             '#sc=' || lvr_megk.sc ||
                             '#pg=' || lvr_megk.pg || '#pgnode=' || TO_CHAR(lvr_megk.pgnode) ||
                             '#pa=' || lvr_megk.pa || '#panode=' || TO_CHAR(lvr_megk.panode) ||
                             '#me=' || lvr_megk.me || '#menode=' || TO_CHAR(lvr_megk.menode) ||
                             '#gk=' || lvr_megk.gk || '#gk_version=' || lvs_gk_version || '#nr_of_rows=' || 1;
         RAISE StpError;
      END IF;
    END LOOP;
   lvi_ret_code := UNAPIAUT.DISABLEALLOWMODIFYCHECK('0');

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      lvs_sqlerrm := SUBSTR(SQLERRM,1,255);
   END IF;
   APAOGEN.LogError(lcs_function_name, lvs_sqlerrm);
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END INHERIT_SCGK;

FUNCTION SPA_AVAILABLE(avs_pp                IN APAOGEN.PP_TYPE,
                              avs_version        IN APAOGEN.VERSION_TYPE,
                              avs_pr                IN    APAOGEN.PR_TYPE,
                              avi_seq            IN    NUMBER,
                              avs_pp_key1        IN VARCHAR2,
                              avs_pp_key2        IN VARCHAR2,
                              avs_pp_key3        IN VARCHAR2,
                              avs_pp_key4        IN VARCHAR2,
                              avs_pp_key5        IN VARCHAR2)
RETURN BOOLEAN IS

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvi_count    INTEGER;

BEGIN

    SELECT COUNT(*)
      INTO lvi_count
      FROM utppspa
     WHERE pp         = avs_pp
       AND version = avs_version
       AND pr         = avs_pr
       AND seq         = avi_seq
       AND pp_key1 = avs_pp_key1
      AND pp_key2 = avs_pp_key2
      AND pp_key3 = avs_pp_key3
      AND pp_key4 = avs_pp_key4
        AND pp_key5 = avs_pp_key5
        AND (low_limit IS NOT NULL OR high_limit IS NOT NULL);

    IF lvi_count = 0 THEN
       RETURN FALSE;
   ELSE
        RETURN TRUE;
    END IF;

EXCEPTION
WHEN OTHERS THEN
   APAOGEN.LOGERROR(ics_package_name || '.SPA_AVAILABLE', 'pp=' || avs_pp  || '#version=' || avs_version || '#pp_key1=' || avs_pp_key1 || '#pp_key2=' || avs_pp_key2 ||'#pp_key3=' || avs_pp_key3 ||'#pp_key4=' || avs_pp_key4 ||'#pp_key5=' || avs_pp_key5);
   IF SQLCODE <> 1 THEN
      lvs_sqlerrm := SUBSTR(SQLERRM,1,255);
   END IF;
   APAOGEN.LogError(ics_package_name || '.SPA_AVAILABLE', lvs_sqlerrm);
   RETURN FALSE;
END SPA_AVAILABLE;

FUNCTION SPB_AVAILABLE(avs_pp                IN APAOGEN.PP_TYPE,
                              avs_version        IN APAOGEN.VERSION_TYPE,
                              avs_pr                IN    APAOGEN.PR_TYPE,
                              avi_seq            IN    NUMBER,
                              avs_pp_key1        IN VARCHAR2,
                              avs_pp_key2        IN VARCHAR2,
                              avs_pp_key3        IN VARCHAR2,
                              avs_pp_key4        IN VARCHAR2,
                              avs_pp_key5        IN VARCHAR2)
RETURN BOOLEAN IS

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvi_count    INTEGER;

BEGIN

    SELECT COUNT(*)
      INTO lvi_count
      FROM utppspb
     WHERE pp         = avs_pp
       AND version = avs_version
       AND pr         = avs_pr
       AND seq         = avi_seq
       AND pp_key1 = avs_pp_key1
      AND pp_key2 = avs_pp_key2
      AND pp_key3 = avs_pp_key3
      AND pp_key4 = avs_pp_key4
        AND pp_key5 = avs_pp_key5
        AND (low_limit IS NOT NULL OR high_limit IS NOT NULL);

    IF lvi_count = 0 THEN
       RETURN FALSE;
   ELSE
        RETURN TRUE;
    END IF;

EXCEPTION
WHEN OTHERS THEN
   APAOGEN.LOGERROR(ics_package_name || '.SPB_AVAILABLE', 'pp=' || avs_pp  || '#version=' || avs_version || '#pp_key1=' || avs_pp_key1 || '#pp_key2=' || avs_pp_key2 ||'#pp_key3=' || avs_pp_key3 ||'#pp_key4=' || avs_pp_key4 ||'#pp_key5=' || avs_pp_key5);
   IF SQLCODE <> 1 THEN
      lvs_sqlerrm := SUBSTR(SQLERRM,1,255);
   END IF;
   APAOGEN.LogError(ics_package_name || '.SPB_AVAILABLE', lvs_sqlerrm);
   RETURN FALSE;
END SPB_AVAILABLE;

FUNCTION SPC_AVAILABLE(avs_pp                IN APAOGEN.PP_TYPE,
                              avs_version        IN APAOGEN.VERSION_TYPE,
                              avs_pr                IN    APAOGEN.PR_TYPE,
                              avi_seq            IN    NUMBER,
                              avs_pp_key1        IN VARCHAR2,
                              avs_pp_key2        IN VARCHAR2,
                              avs_pp_key3        IN VARCHAR2,
                              avs_pp_key4        IN VARCHAR2,
                              avs_pp_key5        IN VARCHAR2)
RETURN BOOLEAN IS

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvi_count    INTEGER;

BEGIN

    SELECT COUNT(*)
      INTO lvi_count
      FROM utppspc
     WHERE pp         = avs_pp
       AND version = avs_version
       AND pr         = avs_pr
       AND seq         = avi_seq
       AND pp_key1 = avs_pp_key1
      AND pp_key2 = avs_pp_key2
      AND pp_key3 = avs_pp_key3
      AND pp_key4 = avs_pp_key4
        AND pp_key5 = avs_pp_key5
        AND (low_limit IS NOT NULL OR high_limit IS NOT NULL);

    IF lvi_count = 0 THEN
       RETURN FALSE;
   ELSE
        RETURN TRUE;
    END IF;

EXCEPTION
WHEN OTHERS THEN
   APAOGEN.LOGERROR(ics_package_name || '.SPC_AVAILABLE', 'pp=' || avs_pp  || '#version=' || avs_version || '#pp_key1=' || avs_pp_key1 || '#pp_key2=' || avs_pp_key2 ||'#pp_key3=' || avs_pp_key3 ||'#pp_key4=' || avs_pp_key4 ||'#pp_key5=' || avs_pp_key5);
   IF SQLCODE <> 1 THEN
      lvs_sqlerrm := SUBSTR(SQLERRM,1,255);
   END IF;
   APAOGEN.LogError(ics_package_name || '.SPC_AVAILABLE', lvs_sqlerrm);
   RETURN FALSE;
END SPC_AVAILABLE;

FUNCTION CALCULATE_SPA(avs_pp             IN APAOGEN.PP_TYPE,
                              avs_ev_details     IN VARCHAR2)
RETURN APAOGEN.RETURN_TYPE IS
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_version            APAOGEN.VERSION_TYPE;
lvs_pp_key1            VARCHAR2(20);
lvs_pp_key2            VARCHAR2(20);
lvs_pp_key3            VARCHAR2(20);
lvs_pp_key4            VARCHAR2(20);
lvs_pp_key5            VARCHAR2(20);
lvs_modify_reason    APAOGEN.MODIFY_REASON_TYPE;

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------
CURSOR lvq_pr IS
   SELECT pr, seq
     FROM utpppr
    WHERE pp = avs_pp
      AND version = lvs_version
      AND pp_key1 = lvs_pp_key1
      AND pp_key2 = lvs_pp_key2
      AND pp_key3 = lvs_pp_key3
      AND pp_key4 = lvs_pp_key4
        AND pp_key5 = lvs_pp_key5;

CURSOR lvq_specsB(avs_pr     IN VARCHAR2,
                        avi_seq    IN NUMBER) IS
   SELECT a.target - ABS(b.low_limit) low_limit,
            a.target +     b.high_limit high_limit,
             a.target - ABS(b.low_spec)  low_spec,
             a.target +     b.high_spec  high_spec
      FROM utppspa a, utppspb b
    WHERE a.pp         = b.pp
      AND a.version     = b.version
      AND a.seq         = b.seq
      AND a.pp         = avs_pp
      AND a.pr         = avs_pr
      AND a.seq         = avi_seq
      AND a.version     = lvs_version
      AND a.pp_key1     = lvs_pp_key1
      AND a.pp_key2     = lvs_pp_key2
      AND a.pp_key3     = lvs_pp_key3
      AND a.pp_key4     = lvs_pp_key4
        AND a.pp_key5     = lvs_pp_key5
       AND a.target IS NOT NULL;

CURSOR lvq_specsC(avs_pr     IN VARCHAR2,
                        avi_seq    IN NUMBER) IS
   SELECT a.target * (1 - ABS(c.low_limit )/100) low_limit,
            a.target * (1 +         c.high_limit /100) high_limit,
             a.target * (1 - ABS(c.low_spec  )/100) low_spec,
             a.target * (1 +         c.high_spec  /100) high_spec
      FROM utppspa a, utppspc c
    WHERE a.pp         = c.pp
      AND a.version     = c.version
      AND a.seq         = c.seq
      AND a.pp         = avs_pp
      AND a.pr         = avs_pr
      AND a.seq         = avi_seq
      AND a.version     = lvs_version
      AND a.pp_key1     = lvs_pp_key1
      AND a.pp_key2     = lvs_pp_key2
      AND a.pp_key3     = lvs_pp_key3
      AND a.pp_key4     = lvs_pp_key4
        AND a.pp_key5     = lvs_pp_key5
        AND a.target IS NOT NULL;

BEGIN

    --------------------------------------------------------------------------------
    -- Retrieve version and pp_keys from ev_datails
    --------------------------------------------------------------------------------
    lvs_version    := SUBSTR(APAOGEN.STRTOK(avs_ev_details, '#', 1), 9);
    lvs_pp_key1    := SUBSTR(APAOGEN.STRTOK(avs_ev_details, '#', 2), 9);
    lvs_pp_key2    := SUBSTR(APAOGEN.STRTOK(avs_ev_details, '#', 3), 9);
    lvs_pp_key3    := SUBSTR(APAOGEN.STRTOK(avs_ev_details, '#', 4), 9);
    lvs_pp_key4    := SUBSTR(APAOGEN.STRTOK(avs_ev_details, '#', 5), 9);
    lvs_pp_key5    := SUBSTR(APAOGEN.STRTOK(avs_ev_details, '#', 6), 9);

    FOR lvr_pr IN lvq_pr LOOP

        IF SPA_AVAILABLE(avs_pp, lvs_version, lvr_pr.pr, lvr_pr.seq, lvs_pp_key1, lvs_pp_key2, lvs_pp_key3, lvs_pp_key4, lvs_pp_key5) = FALSE THEN

            IF SPB_AVAILABLE(avs_pp, lvs_version, lvr_pr.pr, lvr_pr.seq, lvs_pp_key1, lvs_pp_key2, lvs_pp_key3, lvs_pp_key4, lvs_pp_key5) = TRUE THEN
                --------------------------------------------------------------------------------
                -- Calculate from spB
                --------------------------------------------------------------------------------
                FOR lvr_specsB IN lvq_specsB(lvr_pr.pr, lvr_pr.seq) LOOP

                   lvs_modify_reason := 'Specificatie calculatie voor <' || lvr_pr.pr || '> op basis van specset B door ' || ics_package_name || '.CALCULATE_SPA';

                    APAOGEN.LOGERROR(ics_package_name || '.CALCULATE_SPA', 'Start update');

                   UPDATE utppspa
                      SET low_limit     = lvr_specsB.low_limit,
                           high_limit = lvr_specsB.high_limit,
                           low_spec     = lvr_specsB.low_spec,
                           high_spec     = lvr_specsB.high_spec
                    WHERE pp             = avs_pp
                      AND pr             = lvr_pr.pr
                      AND seq             = lvr_pr.seq
                      AND version     = lvs_version
                      AND pp_key1     = lvs_pp_key1
                      AND pp_key2     = lvs_pp_key2
                      AND pp_key3     = lvs_pp_key3
                      AND pp_key4     = lvs_pp_key4
                        AND pp_key5     = lvs_pp_key5;

                   lvi_ret_code := UNAPIPPP.ADDPPCOMMENT (avs_pp,
                                                                        lvs_version,
                                                                        lvs_pp_key1,
                                                                  lvs_pp_key2,
                                                                  lvs_pp_key3,
                                                                  lvs_pp_key4,
                                                                  lvs_pp_key5,
                                                                  lvs_modify_reason);

               END LOOP;

            ELSIF SPC_AVAILABLE(avs_pp, lvs_version, lvr_pr.pr, lvr_pr.seq, lvs_pp_key1, lvs_pp_key2, lvs_pp_key3, lvs_pp_key4, lvs_pp_key5) THEN
                --------------------------------------------------------------------------------
                -- Calculate from spC
                --------------------------------------------------------------------------------
                FOR lvr_specsC IN lvq_specsC(lvr_pr.pr, lvr_pr.seq) LOOP

                   lvs_modify_reason := 'Specificatie calculatie voor <' || lvr_pr.pr || '> op basis van specset C door ' || ics_package_name || '.CALCULATE_SPA';

                   UPDATE utppspa
                      SET low_limit     = lvr_specsC.low_limit,
                           high_limit = lvr_specsC.high_limit,
                           low_spec     = lvr_specsC.low_spec,
                           high_spec     = lvr_specsC.high_spec
                    WHERE pp             = avs_pp
                      AND pr             = lvr_pr.pr
                      AND seq             = lvr_pr.seq
                      AND version     = lvs_version
                      AND pp_key1     = lvs_pp_key1
                      AND pp_key2     = lvs_pp_key2
                      AND pp_key3     = lvs_pp_key3
                      AND pp_key4     = lvs_pp_key4
                        AND pp_key5     = lvs_pp_key5;

                   lvi_ret_code := UNAPIPPP.ADDPPCOMMENT (avs_pp,
                                                                        lvs_version,
                                                                        lvs_pp_key1,
                                                                  lvs_pp_key2,
                                                                  lvs_pp_key3,
                                                                  lvs_pp_key4,
                                                                  lvs_pp_key5,
                                                                  lvs_modify_reason);

               END LOOP;

            END IF;
        END IF;
    END LOOP;


   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   APAOGEN.LOGERROR(ics_package_name || '.CALCULATE_SPA', 'pp=' || avs_pp  || '#version=' || lvs_version || '#pp_key1=' || lvs_pp_key1 || '#pp_key2=' || lvs_pp_key2 ||'#pp_key3=' || lvs_pp_key3 ||'#pp_key4=' || lvs_pp_key4 ||'#pp_key5=' || lvs_pp_key5);
   IF SQLCODE <> 1 THEN
      lvs_sqlerrm := SUBSTR(SQLERRM,1,255);
   END IF;
   APAOGEN.LogError(ics_package_name || '.CALCULATE_SPA', lvs_sqlerrm);
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END CALCULATE_SPA;

FUNCTION Irrelevant
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'Irrelevant';

lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;

CURSOR lvq_me_check IS
    SELECT sc,
             pg, pgnode,
             pa, panode,
             me, menode,
             mt_version,
             lc, lc_version,
             ss
      FROM utscme
     WHERE sc = UNAPIEV.P_SC
       AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE
       AND pa = UNAPIEV.P_PA AND panode = UNAPIEV.P_PANODE
       AND ss NOT IN (ics_ss_cancelled, ics_ss_irrelevant);

BEGIN

    --------------------------------------------------------------------------------
    -- Recheck all methods of current method
    --------------------------------------------------------------------------------
   FOR lvr_me_check IN lvq_me_check LOOP
        lvi_ret_code   := APAOFUNCTIONS.RecheckMe(lvr_me_check.sc,
                                                  lvr_me_check.pg, lvr_me_check.pgnode,
                                                  lvr_me_check.pa, lvr_me_check.panode,
                                                  lvr_me_check.me, lvr_me_check.menode,
                                                  lvr_me_check.mt_version,
                                                  lvr_me_check.lc,
                                                  lvr_me_check.lc_version,
                                                  lvr_me_check.ss);
    END LOOP;

   RETURN UNAPIGEN.DBERR_SUCCESS;
EXCEPTION
WHEN APAOGEN.API_FAILED THEN
   APAOGEN.LogError (lcs_function_name, lvs_sqlerrm);
   RETURN lvi_ret_code;
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END Irrelevant;

--------------------------------------------------------------------------------
-- Function called by eventrule
--------------------------------------------------------------------------------
FUNCTION ControleWacht
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ControleWacht';

lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;

CURSOR lvq_me_check IS
    SELECT a.sc,
             a.pg, a.pgnode,
             a.pa, a.panode,
             a.me, a.menode,
             a.mt_version,
             a.lc, a.lc_version,
             a.ss
      FROM utscme a, utscmeau b
     WHERE a.sc = UNAPIEV.P_SC
       AND a.sc = b.sc
       AND a.pg = b.pg AND a.pgnode = b.pgnode
       AND a.pa = b.pa AND a.panode = b.panode
       AND a.me = b.me AND a.menode = b.menode
       AND b.value = UNAPIEV.P_ME -- method we have been waiting for
       AND ss NOT IN (ics_ss_cancelled, ics_ss_irrelevant);

BEGIN
   --------------------------------------------------------------------------------
   -- Recheck all waiting methods
   --------------------------------------------------------------------------------
   FOR lvr_me_check IN lvq_me_check LOOP

      lvi_ret_code   := APAOFUNCTIONS.RecheckMe(lvr_me_check.sc,
                                                    lvr_me_check.pg, lvr_me_check.pgnode,
                                                    lvr_me_check.pa, lvr_me_check.panode,
                                                    lvr_me_check.me, lvr_me_check.menode,
                                                    lvr_me_check.mt_version,
                                                    lvr_me_check.lc,
                                                   lvr_me_check.lc_version,
                                                   lvr_me_check.ss);
   END LOOP;

   RETURN UNAPIGEN.DBERR_SUCCESS;
EXCEPTION
WHEN APAOGEN.API_FAILED THEN
   APAOGEN.LogError (lcs_function_name, lvs_sqlerrm);
   RETURN lvi_ret_code;
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END ControleWacht;

FUNCTION AllowDuplo
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'AllowDuplo ';

lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;
lvi_count          NUMBER;
lvn_panode            APAOGEN.NODE_TYPE;

CURSOR lvq_cells IS
SELECT a.sc,
       a.pg, a.pgnode,
       a.pa, a.panode,
       a.me, a.menode,
       a.cell,
       a.panode + a.menode/1000 + a.cellnode/10000 save_panode
  FROM utscmecell a, utscmecelloutput b
 WHERE a.sc = UNAPIEV.P_SC
   AND a.pg = UNAPIEV.P_PG AND a.pgnode = UNAPIEV.P_PGNODE
   AND a.pa = UNAPIEV.P_PA AND a.panode = UNAPIEV.P_PANODE
   AND a.me = UNAPIEV.P_ME AND a.menode = UNAPIEV.P_MENODE
   AND a.sc = b.sc
   AND a.pg = b.pg AND a.pgnode = b.pgnode
   AND a.pa = b.pa AND a.panode = b.panode
   AND a.me = b.me AND a.menode = b.menode
   AND a.cell = b.cell
   AND b.save_pa != '~Current~'
   AND save_panode IS NULL;

BEGIN

---Inserted this statement again, which was commented out.
   SELECT COUNT(*)
     INTO lvi_count
     FROM utmtau
    WHERE mt = UNAPIEV.P_ME AND version = UNAPIEV.P_MT_VERSION
      AND au = 'avCustAllowDuplo'
      AND value = '1';

   IF lvi_count = 0 THEN
      RETURN UNAPIGEN.DBERR_SUCCESS;
   END IF;

   FOR lvr_cells IN lvq_cells LOOP

     UPDATE utscmecelloutput
         SET save_panode = lvr_cells.save_panode
       WHERE sc = lvr_cells.sc
         AND pg = lvr_cells.pg AND pgnode = lvr_cells.pgnode
         AND pa = lvr_cells.pa AND panode = lvr_cells.panode
         AND me = lvr_cells.me AND menode = lvr_cells.menode
         AND cell = lvr_cells.cell
         AND save_pa != '~Current~'
         AND save_panode IS NULL;

   END LOOP;

   RETURN UNAPIGEN.DBERR_SUCCESS;
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END AllowDuplo ;

--------------------------------------------------------------------------------
-- meCustomSQL: Fill method cell with data retrieved from an SQL statement defined in a UA
-------------------------------------------------------------------------------
FUNCTION meCustomSQL
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'meCustomSQL';

lvs_sqlerrm          APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code         APAOGEN.RETURN_TYPE;
lvs_sqlstatement     VARCHAR2(3000);
lvs_value            VARCHAR2(255); -- Length after substitution may exceed 40 characters!

lvi_row              INTEGER;
lvs_dml_string       VARCHAR2(3000);
lvi_nr_of_rows       NUMBER;
lvi_next_rows        NUMBER;
lts_dml1_value_tab   UNAPIGEN.VC255_TABLE_TYPE;

lvf_value_f          FLOAT;
lvs_value_s          VARCHAR2(40);
lvs_format           VARCHAR2(20);

CURSOR lvq_cell IS
SELECT a.cell
  FROM utmtcell a, utau b
 WHERE a.mt = UNAPIEV.P_ME AND a.version = UNAPIEV.P_MT_VERSION
   AND b.service = 'CustomSqlLookup'
   AND a.def_val_tp = 'A' --AND a.def_au_level = 'mt'
   AND a.value_s = b.au AND b.version_is_current = 1
   ORDER BY a.seq;

CURSOR lvq_sqltext(avs_cell IN VARCHAR2) IS
SELECT c.value
  FROM utmtcell a, utau b, utaulist c
 WHERE a.mt = UNAPIEV.P_ME AND a.version = UNAPIEV.P_MT_VERSION
   AND b.service = 'CustomSqlLookup'
   AND a.def_val_tp = 'A' --AND a.def_au_level = 'mt'
   AND a.cell = avs_cell
   AND a.value_s = b.au AND b.version_is_current = 1 AND b.au = c.au AND b.version = c.version
   ORDER BY c.seq;

BEGIN

   --------------------------------------------------------------------------------
   -- Loop through all cells of current method
   --------------------------------------------------------------------------------
   FOR lvr_cell IN lvq_cell LOOP

      lvs_sqlstatement := '';

      --------------------------------------------------------------------------------
      -- Built statement for current cell
      --------------------------------------------------------------------------------
      FOR lvr_sqltext IN lvq_sqltext(lvr_cell.cell) LOOP
        --------------------------------------------------------------------------------
        -- Execute tildesubstitution for this part
        --------------------------------------------------------------------------------
        lvs_value := lvr_sqltext.value;
        --lvi_ret_code := APAOGEN.SqlSubstituteTildes (UNAPIEV.P_EV_REC.OBJECT_TP, '~EV_REC~', lvs_value);
        lvi_ret_code := UNAPIGEN.SubstituteAllTildesInText (UNAPIEV.P_EV_REC.OBJECT_TP, '~EV_REC~', lvs_value);
        APAOFUNCTIONS.LogInfo(lcs_function_name, lvr_cell.cell || ' Building ' || lvs_value);
        --------------------------------------------------------------------------------
        -- Add substituted part to the statement
        --------------------------------------------------------------------------------
        lvs_sqlstatement := lvs_sqlstatement || lvs_value;
      END LOOP;

      APAOFUNCTIONS.LogInfo(lcs_function_name, lvr_cell.cell || ' Execute ' || lvs_sqlstatement);

      IF lvs_sqlstatement IS NOT NULL THEN
         lvi_next_rows := 0;
         lvi_nr_of_rows := NULL;
         --------------------------------------------------------------------------------
         -- Initialize string and float values
         --------------------------------------------------------------------------------
         lvs_value_s := NULL;
         lvf_value_f := NULL;
         --------------------------------------------------------------------------------
         -- Execute the statement
         --------------------------------------------------------------------------------
         BEGIN
            lvi_ret_code := UNAPIGEN.UNEXECDML1(lvs_sqlstatement,
                                                lts_dml1_value_tab,
                                                lvi_nr_of_rows,
                                                lvi_next_rows);

            APAOFUNCTIONS.LogInfo(lcs_function_name, lvr_cell.cell || ' Return UNEXECDML1:' || lvi_ret_code);

         EXCEPTION
         WHEN OTHERS THEN
            NULL;
         END;
         --------------------------------------------------------------------------------
         -- Save the first record found as method cell result
         --------------------------------------------------------------------------------
         IF lvi_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
             SELECT format
               INTO lvs_format
               FROM utscmecell
              WHERE sc = UNAPIEV.P_SC
                AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE
                AND pa = UNAPIEV.P_PA AND panode = UNAPIEV.P_PANODE
                AND me = UNAPIEV.P_ME AND menode = UNAPIEV.P_MENODE
                AND cell = lvr_cell.cell;

             APAOFUNCTIONS.LogInfo(lcs_function_name, lvr_cell.cell || ' Format:' || lvs_format);

             lvs_value_s := SUBSTR(lts_dml1_value_tab(1), 1, 40);
             APAOFUNCTIONS.LogInfo(lcs_function_name, lvr_cell.cell || ' Value_s (left 40):' || lvs_value_s);

             BEGIN
                 lvf_value_f := TO_NUMBER(lvs_value_s);
                 lvs_value_s := NULL;

                 APAOFUNCTIONS.LogInfo(lcs_function_name, lvr_cell.cell || ' To_Number ' || lvs_value_s || '=>' || lvf_value_f);

             EXCEPTION
               WHEN OTHERS THEN
                 APAOFUNCTIONS.LogInfo(lcs_function_name, lvr_cell.cell || ' Error To_Number (' || lvs_value_s || ')');
                 lvf_value_f := NULL;
                 --lvs_value_s := NULL;
             END ;

             lvi_ret_code := UNAPIGEN.FORMATRESULT(lvf_value_f,
                                                   lvs_format,
                                                   lvs_value_s);

             APAOFUNCTIONS.LogInfo(lcs_function_name, lvr_cell.cell || ' Value_s (formatted):' || lvs_value_s);

             UPDATE utscmecell
                SET value_s = lvs_value_s,
                    value_f = lvf_value_f
              WHERE sc = UNAPIEV.P_SC
                AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE
                AND pa = UNAPIEV.P_PA AND panode = UNAPIEV.P_PANODE
                AND me = UNAPIEV.P_ME AND menode = UNAPIEV.P_MENODE
                AND cell = lvr_cell.cell;
         --------------------------------------------------------------------------------
         -- Save the constant 'sql_no_record_found' as method cell result (no data found)
         --------------------------------------------------------------------------------
         ELSIF lvi_ret_code = UNAPIGEN.DBERR_NORECORDS THEN

             UPDATE utscmecell
                SET value_s = APAOCONSTANT.GetConstString ('sql_no_record_found'),
                    value_f = NULL
              WHERE sc = UNAPIEV.P_SC
                AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE
                AND pa = UNAPIEV.P_PA AND panode = UNAPIEV.P_PANODE
                AND me = UNAPIEV.P_ME AND menode = UNAPIEV.P_MENODE
                AND cell = lvr_cell.cell;
         --------------------------------------------------------------------------------
         -- Log the error, the statement has been logged already by 'UNEXECDML1'
         --------------------------------------------------------------------------------
         ELSE
             UPDATE utscmecell
                SET value_s = 'SQL-ERROR',
                    value_f = NULL
              WHERE sc = UNAPIEV.P_SC
                AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE
                AND pa = UNAPIEV.P_PA AND panode = UNAPIEV.P_PANODE
                AND me = UNAPIEV.P_ME AND menode = UNAPIEV.P_MENODE
                AND cell = lvr_cell.cell;

            APAOGEN.LogError(lcs_function_name, 'Function returned ' || lvi_ret_code || ' for mecell "' || lvr_cell.cell || '"', FALSE);
         END IF;
      END IF;
   END LOOP;

   RETURN UNAPIGEN.DBERR_SUCCESS;
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_SUCCESS;
END meCustomSQL;


FUNCTION meCustomSQLWithOverwrite
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'meCustomSQLWithOverwrite';

lvs_sqlerrm          APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code         APAOGEN.RETURN_TYPE;

BEGIN

       lvi_ret_code := APAOEVRULES.meCustomSQL;
       IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
          APAOGEN.LogError (lcs_function_name, 'Call <APAOEVRULES.meCustomSQL> failed. Function returned <' || lvi_ret_code || '>');
       END IF;

       lvi_ret_code := APAOACTION.MeGetPreviousResults;
       IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
          APAOGEN.LogError (lcs_function_name, 'Call <APAOACTION.getPreviousResults> failed. Function returned <' || lvi_ret_code || '>');
       END IF;

   RETURN UNAPIGEN.DBERR_SUCCESS;
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_SUCCESS;
END meCustomSQLWithOverwrite;

FUNCTION GetRqSs
RETURN APAOGEN.SS_TYPE IS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'GetRqSs';
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_sqlerrm          APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code         APAOGEN.RETURN_TYPE;
l_ret_code                    INTEGER;

l_row                         INTEGER;



--Specific local variables

l_nr_of_rows                  NUMBER;

l_where_clause                VARCHAR2(511);

l_rq_tab                      UNAPIGEN.VC20_TABLE_TYPE;

l_rt_tab                      UNAPIGEN.VC20_TABLE_TYPE;

l_rt_version_tab              UNAPIGEN.VC20_TABLE_TYPE;

l_description_tab             UNAPIGEN.VC40_TABLE_TYPE;

l_descr_doc_tab               UNAPIGEN.VC40_TABLE_TYPE;

l_descr_doc_version_tab       UNAPIGEN.VC20_TABLE_TYPE;

l_sampling_date_tab           UNAPIGEN.DATE_TABLE_TYPE;

l_creation_date_tab           UNAPIGEN.DATE_TABLE_TYPE;

l_created_by_tab              UNAPIGEN.VC20_TABLE_TYPE;

l_exec_start_date_tab         UNAPIGEN.DATE_TABLE_TYPE;

l_exec_end_date_tab           UNAPIGEN.DATE_TABLE_TYPE;

l_due_date_tab                UNAPIGEN.DATE_TABLE_TYPE;

l_priority_tab                UNAPIGEN.NUM_TABLE_TYPE;

l_label_format_tab            UNAPIGEN.VC20_TABLE_TYPE;

l_date1_tab                   UNAPIGEN.DATE_TABLE_TYPE;

l_date2_tab                   UNAPIGEN.DATE_TABLE_TYPE;

l_date3_tab                   UNAPIGEN.DATE_TABLE_TYPE;

l_date4_tab                   UNAPIGEN.DATE_TABLE_TYPE;

l_date5_tab                   UNAPIGEN.DATE_TABLE_TYPE;

l_allow_any_st_tab            UNAPIGEN.CHAR1_TABLE_TYPE;

l_allow_new_sc_tab            UNAPIGEN.CHAR1_TABLE_TYPE;

l_responsible_tab             UNAPIGEN.VC20_TABLE_TYPE;

l_sc_counter_tab              UNAPIGEN.NUM_TABLE_TYPE;

l_rq_class_tab                UNAPIGEN.VC2_TABLE_TYPE;

l_log_hs_tab                  UNAPIGEN.CHAR1_TABLE_TYPE;

l_log_hs_details_tab          UNAPIGEN.CHAR1_TABLE_TYPE;

l_allow_modify_tab            UNAPIGEN.CHAR1_TABLE_TYPE;

l_ar_tab                      UNAPIGEN.CHAR1_TABLE_TYPE;

l_active_tab                  UNAPIGEN.CHAR1_TABLE_TYPE;

l_lc_tab                      UNAPIGEN.VC2_TABLE_TYPE;

l_lc_version_tab              UNAPIGEN.VC20_TABLE_TYPE;

l_ss_tab                      UNAPIGEN.VC2_TABLE_TYPE;

BEGIN
   -- IN and IN OUT arguments
   l_where_clause := UNAPIEV.P_RQ;
   l_nr_of_rows := NULL;

   l_ret_code := UNAPIRQ.GETREQUEST
                (l_rq_tab,
                 l_rt_tab,
                 l_rt_version_tab,
                 l_description_tab,
                 l_descr_doc_tab,
                 l_descr_doc_version_tab,
                 l_sampling_date_tab,
                 l_creation_date_tab,
                 l_created_by_tab,
                 l_exec_start_date_tab,
                 l_exec_end_date_tab,
                 l_due_date_tab,
                 l_priority_tab,
                 l_label_format_tab,
                 l_date1_tab,
                 l_date2_tab,
                 l_date3_tab,
                 l_date4_tab,
                 l_date5_tab,
                 l_allow_any_st_tab,
                 l_allow_new_sc_tab,
                 l_responsible_tab,
                 l_sc_counter_tab,
                 l_rq_class_tab,
                 l_log_hs_tab,
                 l_log_hs_details_tab,
                 l_allow_modify_tab,
                 l_ar_tab,
                 l_active_tab,
                 l_lc_tab,
                 l_lc_version_tab,
                 l_ss_tab,
                 l_nr_of_rows,
                 l_where_clause);

   IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
      RETURN l_ss_tab(1);
   END IF;

   RETURN NULL;
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN NULL;
END GetRqSs;


FUNCTION rqCopyStatus2ScGk
RETURN APAOGEN.RETURN_TYPE IS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'rqCopyStatus2ScGk';
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_sqlerrm          APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code         APAOGEN.RETURN_TYPE;
lvs_gk_version       APAOGEN.VERSION_TYPE;
lvs_modify_reason    APAOGEN.MODIFY_REASON_TYPE;
lts_status           UNAPIGEN.VC40_TABLE_TYPE;
lts_statustype       UNAPIGEN.VC40_TABLE_TYPE;
lvi_nrb_of_rows_status  NUMBER;
lvi_nrb_of_rows_type    NUMBER;
--------------------------------------------------------------------------------
-- Cursor to retrieve request status and name
--------------------------------------------------------------------------------
CURSOR lvq_rqss IS
   SELECT a.ss, NVL(b.name, '<' || a.ss || '>') name
     FROM utrq a, utss b
    WHERE a.rq = UNAPIEV.P_RQ
      AND a.ss = b.ss;
--------------------------------------------------------------------------------
-- Cursor to retrieve all samples of a request
--------------------------------------------------------------------------------
CURSOR lvq_rqsc IS
   SELECT sc
     FROM utrqsc
    WHERE rq = UNAPIEV.P_RQ;
--------------------------------------------------------------------------------
-- Cursor to retrieve the activity-code of a status
-- The activity is the first part of the setting_value
-- of all setting_names starting with RQ_STATUSTYPE
--------------------------------------------------------------------------------
CURSOR lvq_statustype(avs_ss IN VARCHAR2) IS
   SELECT apaogen.strtok (setting_value, ';', 1) activity
     FROM utsystem
    WHERE setting_name LIKE 'RQ_STATUSTYPE%'
      AND INSTR(setting_value, avs_ss) > INSTR( setting_value, ';')
 ORDER BY setting_name;

l_in_transition                BOOLEAN;
l_tmp_retrieswhenintransition  INTEGER;
l_tmp_intervalwhenintransition NUMBER;

BEGIN
   --------------------------------------------------------------------------------
   --reduce the time-out for in-transition objects (retsored at the end) to 400 ms
   --------------------------------------------------------------------------------
   l_tmp_retrieswhenintransition := UNAPIEV.P_RETRIESWHENINTRANSITION;
   l_tmp_intervalwhenintransition := UNAPIEV.P_INTERVALWHENINTRANSITION;
   UNAPIEV.P_RETRIESWHENINTRANSITION  := 1;
   UNAPIEV.P_INTERVALWHENINTRANSITION := 0.4;
   --------------------------------------------------------------------------------
   -- Get ss of current rq and its description
   --------------------------------------------------------------------------------
   lvi_nrb_of_rows_status := 0;
   FOR lvr_rqss IN lvq_rqss LOOP
      --------------------------------------------------------------------------------
      -- Fill array of groupkeyvalues
      --------------------------------------------------------------------------------
      lvi_nrb_of_rows_status := lvi_nrb_of_rows_status + 1;
      lts_status(lvi_nrb_of_rows_status) := lvr_rqss.name;
      --------------------------------------------------------------------------------
      -- Loop through all samples of current request
      --------------------------------------------------------------------------------
      FOR lvr_rqsc IN lvq_rqsc LOOP
         --------------------------------------------------------------------------------
         -- Fill array of groupkeyvalues
         --------------------------------------------------------------------------------
         lvs_modify_reason := 'Groupkey <rqStatus> updated with <';
         lvs_modify_reason          := lvs_modify_reason || lvr_rqss.name || ',';
         --------------------------------------------------------------------------------
         -- Do not execute the save of sample groupkeys during requestcreation
         -- (prevent in transition)
         --------------------------------------------------------------------------------
         IF UNAPIEV.P_SS_FROM != '@~' AND lvi_nrb_of_rows_status > 0 THEN
            lvs_modify_reason := SUBSTR(lvs_modify_reason, 1, LENGTH(lvs_modify_reason) -1) || '> by ' || lcs_function_name;
            --------------------------------------------------------------------------------
            -- Save scgk 'rqStatus'
            --------------------------------------------------------------------------------
            lvi_ret_code := UNAPISCP.Save1ScGroupKey(lvr_rqsc.sc,
                                                     'rqStatus', lvs_gk_version,
                                                     lts_status, lvi_nrb_of_rows_status,
                                                     lvs_modify_reason);
            --------------------------------------------------------------------------------
            -- Set flag 'in transition'
            --------------------------------------------------------------------------------
            IF lvi_ret_code = UNAPIGEN.DBERR_TRANSITION THEN
               l_in_transition := TRUE;
            END IF;
            --------------------------------------------------------------------------------
            -- Handle errors
            --------------------------------------------------------------------------------
            IF lvi_ret_code <> UNAPIGEN.DBERR_SUCCESS AND
               lvi_ret_code <> UNAPIGEN.DBERR_UNIQUEGK AND
               lvi_ret_code <> UNAPIGEN.DBERR_TRANSITION THEN
               lvs_sqlerrm := 'Save1ScGroupKey#return=' || TO_CHAR(lvi_ret_code) ||
                              '#sc=' || lvr_rqsc.sc ||
                              '#gk=' || 'rqStatus' || '#gk_version=' || lvs_gk_version || '#nr_of_rows=' || 1;
               APAOGEN.LogError (lcs_function_name, lvs_sqlerrm);
            END IF;
         END IF;
         --------------------------------------------------------------------------------
         -- Get all statustypes for current status of request
         --------------------------------------------------------------------------------
         lvi_nrb_of_rows_type   := 0;
         lvs_modify_reason := 'Groupkey <rqStatusType> updated with <';
         FOR lvr_statustype IN lvq_statustype(lvr_rqss.ss) LOOP
            --------------------------------------------------------------------------------
            -- Fill array of groupkeyvalues
            --------------------------------------------------------------------------------
            lvi_nrb_of_rows_type := lvi_nrb_of_rows_type + 1;
            lts_statustype(lvi_nrb_of_rows_type) := lvr_statustype.activity;
            lvs_modify_reason := lvs_modify_reason || lvr_statustype.activity || ',';
         END LOOP;

         --------------------------------------------------------------------------------
         -- Do not execute the save of sample groupkeys during requestcreation
         -- (prevent in transition)
         --------------------------------------------------------------------------------
         IF UNAPIEV.P_SS_FROM != '@~' AND lvi_nrb_of_rows_type > 0 THEN
            lvs_modify_reason := SUBSTR(lvs_modify_reason, 1, LENGTH(lvs_modify_reason) -1) || '> by ' || lcs_function_name;
            --------------------------------------------------------------------------------
            -- Save scgk 'rqStatusType'
            --------------------------------------------------------------------------------
            lvi_ret_code := UNAPISCP.Save1ScGroupKey(lvr_rqsc.sc,
                                                     'rqStatusType', lvs_gk_version,
                                                     lts_statustype, lvi_nrb_of_rows_type,
                                                     lvs_modify_reason);
            --------------------------------------------------------------------------------
            -- Set flag 'in transition'
            --------------------------------------------------------------------------------
            IF lvi_ret_code = UNAPIGEN.DBERR_TRANSITION THEN
               l_in_transition := TRUE;
            END IF;
            --------------------------------------------------------------------------------
            -- Handle errors
            --------------------------------------------------------------------------------
            IF lvi_ret_code <> UNAPIGEN.DBERR_SUCCESS AND
               lvi_ret_code <> UNAPIGEN.DBERR_UNIQUEGK AND
               lvi_ret_code <> UNAPIGEN.DBERR_TRANSITION THEN
               lvs_sqlerrm := 'Save1ScGroupKey#return=' || TO_CHAR(lvi_ret_code) ||
                              '#sc=' || lvr_rqsc.sc ||
                              '#gk=' || 'rqStatus' || '#gk_version=' || lvs_gk_version || '#nr_of_rows=' || 1;
               APAOGEN.LogError (lcs_function_name, lvs_sqlerrm);
            END IF;
         END IF;
      END LOOP;

      IF lvi_nrb_of_rows_type > 0 THEN
         --------------------------------------------------------------------------------
         -- Save scgk 'rqStatusType'
         --------------------------------------------------------------------------------
         lvi_ret_code := UNAPIRQP.Save1RQGroupKey(UNAPIEV.P_RQ,
                                                  'rqStatusType', lvs_gk_version,
                                                  lts_statustype, lvi_nrb_of_rows_type,
                                                  lvs_modify_reason);
         --------------------------------------------------------------------------------
         -- Set flag 'in transition'
         --------------------------------------------------------------------------------
         IF lvi_ret_code = UNAPIGEN.DBERR_TRANSITION THEN
            l_in_transition := TRUE;
         END IF;
         --------------------------------------------------------------------------------
         -- Handle errors
         --------------------------------------------------------------------------------
         IF lvi_ret_code <> UNAPIGEN.DBERR_SUCCESS AND
            lvi_ret_code <> UNAPIGEN.DBERR_UNIQUEGK AND
            lvi_ret_code <> UNAPIGEN.DBERR_TRANSITION THEN
            lvs_sqlerrm := 'Save1RqGroupKey#return=' || TO_CHAR(lvi_ret_code) ||
                           '#rq=' || UNAPIEV.P_RQ ||
                           '#gk=' || 'rqStatus' || '#gk_version=' || lvs_gk_version || '#nr_of_rows=' || 1;
            APAOGEN.LogError (lcs_function_name, lvs_sqlerrm);
         END IF;
      END IF;
   END LOOP;

   --------------------------------------------------------------------------------
   -- restore original time-out for in-transition objects
   --------------------------------------------------------------------------------
   UNAPIEV.P_RETRIESWHENINTRANSITION  := l_tmp_retrieswhenintransition;
   UNAPIEV.P_INTERVALWHENINTRANSITION := l_tmp_intervalwhenintransition;
   --------------------------------------------------------------------------------
   -- Return in transition if occured to prevent lose of data
   --------------------------------------------------------------------------------
   IF l_in_transition THEN
      RETURN(UNAPIGEN.DBERR_TRANSITION);
   END IF;

   RETURN UNAPIGEN.DBERR_SUCCESS;
EXCEPTION
WHEN OTHERS THEN
   --------------------------------------------------------------------------------
   -- restore original time-out for in-transition objects
   --------------------------------------------------------------------------------
   UNAPIEV.P_RETRIESWHENINTRANSITION  := l_tmp_retrieswhenintransition;
   UNAPIEV.P_INTERVALWHENINTRANSITION := l_tmp_intervalwhenintransition;

   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_SUCCESS;
END rqCopyStatus2ScGk;

FUNCTION iiCreated_by(avs_ii IN VARCHAR2)
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'iiCreated_by';

lvs_sqlerrm          APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code         APAOGEN.RETURN_TYPE;

BEGIN

   IF UNAPIEV.p_ev_rec.object_tp = 'rq' THEN
      UPDATE utrqii
         SET iivalue = (SELECT created_by FROM utrq WHERE rq = UNAPIEV.P_RQ)
       WHERE rq = UNAPIEV.P_RQ
         AND ii = avs_ii;
   END IF;

   IF UNAPIEV.p_ev_rec.object_tp = 'sc' THEN
      UPDATE utscii
         SET iivalue = (SELECT created_by FROM utsc WHERE sc = UNAPIEV.P_SC)
       WHERE sc = UNAPIEV.P_SC
         AND ii = avs_ii;
   END IF;

   RETURN UNAPIGEN.DBERR_SUCCESS;
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_SUCCESS;
END iiCreated_by;

--------------------------------------------------------------------------------
-- Copies a single request infofield value to all of the request's samples,
-- taking into account renaming via avCustRqIiCopyFrom.
--------------------------------------------------------------------------------
FUNCTION CopyRqIiToScIi
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'CopyRqIiToScIi';
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;
lvs_modify_reason  VARCHAR2(255);
--------------------------------------------------------------------------------
-- This cursor lists the infofields at the sample level, along with the request.
-- It supports attributes that are named differently between rq and sc via avCustRqIiCopyFrom.
-- It allows sample infofields to be in a different infocard than on the request level.
--------------------------------------------------------------------------------
CURSOR lvq_ii IS
   SELECT a.rq, b.sc, b.ic, b.icnode, b.ii, b.iinode
     FROM utrqsc a, utscii b
    WHERE a.rq = UNAPIEV.P_RQ
      AND b.ii = UNAPIEV.P_II
      AND a.sc = b.sc
   UNION
   SELECT b.rq, a.sc, a.ic, a.icnode, a.ii, a.iinode
     FROM utrqsc d, utscii a, utrqii b, utieau c
    WHERE d.rq = b.rq
      AND a.sc = d.sc
      AND b.rq = UNAPIEV.P_RQ
      AND a.ii = c.ie
      AND a.ie_version = c.version
      AND c.au = 'avCustRqIiCopyFrom'
      AND b.ii = c.value
      AND b.ii = UNAPIEV.P_II;

BEGIN

   --------------------------------------------------------------------------------
   -- Only for configuration parameterprofiles
   --------------------------------------------------------------------------------
   FOR lvr_ii IN lvq_ii LOOP
      lvi_ret_code := APAOFUNCTIONS.COPYRQIITOSCII(lvr_ii.rq,
                                                   lvr_ii.sc,
                                                   lvr_ii.ic, lvr_ii.icnode,
                                                   lvr_ii.ii, lvr_ii.iinode,
                                                   'Copied by ' || lcs_function_name );
      IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
         APAOGEN.LogError (lcs_function_name, 'Error while copying infofield  <' || lvr_ii.ii || '> from <' || lvr_ii.rq || '> to <' || lvr_ii.sc || '> Function returned: <' || lvi_ret_code || '>');
      END IF;
   END LOOP;

   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END CopyRqIiToScIi;

--------------------------------------------------------------------------------
-- Adds a pg + pp_key2_new to an sc,
-- creating only those parameters that already exist in the same pg + pp_key2_old,
-- then canceling those parameters in pg + pp_key2_old.
PROCEDURE AddScSitePg (a_sc          IN APAOGEN.NAME_TYPE,
                       a_pg          IN APAOGEN.NAME_TYPE,
                       a_pgnode      IN APAOGEN.NODE_TYPE,
                       a_pp_key1     IN APAOGEN.NAME_TYPE,
                       a_pp_key2_old IN APAOGEN.NAME_TYPE,
                       a_pp_key3     IN APAOGEN.NAME_TYPE,
                       a_pp_key4     IN APAOGEN.NAME_TYPE,
                       a_pp_key5     IN APAOGEN.NAME_TYPE,
                       a_pp_key2_new IN APAOGEN.NAME_TYPE)
IS

   lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'AddScSitePg';
   lvi_ret_code               APAOGEN.RETURN_TYPE;
   lvn_pgnode                 APAOGEN.NODE_TYPE;
   lvi_step                   INTEGER;
   l_seq                      NUMBER := NULL;
   l_nr_of_rows               NUMBER := NULL;

   -- Init/SaveScParameterGroup
   l_pp_version_in            VARCHAR2(20);
   l_sc_tab                   UNAPIGEN.VC20_TABLE_TYPE;
   l_pg_tab                   UNAPIGEN.VC20_TABLE_TYPE;
   l_pgnode_tab               UNAPIGEN.LONG_TABLE_TYPE;
   l_pp_version_tab           UNAPIGEN.VC20_TABLE_TYPE;
   l_pp_key1_tab              UNAPIGEN.VC20_TABLE_TYPE;
   l_pp_key2_tab              UNAPIGEN.VC20_TABLE_TYPE;
   l_pp_key3_tab              UNAPIGEN.VC20_TABLE_TYPE;
   l_pp_key4_tab              UNAPIGEN.VC20_TABLE_TYPE;
   l_pp_key5_tab              UNAPIGEN.VC20_TABLE_TYPE;
   l_description_tab          UNAPIGEN.VC40_TABLE_TYPE;
   l_value_f_tab              UNAPIGEN.FLOAT_TABLE_TYPE;
   l_value_s_tab              UNAPIGEN.VC40_TABLE_TYPE;
   l_unit_tab                 UNAPIGEN.VC20_TABLE_TYPE;
   l_exec_start_date_tab      UNAPIGEN.DATE_TABLE_TYPE;
   l_exec_end_date_tab        UNAPIGEN.DATE_TABLE_TYPE;
   l_executor_tab             UNAPIGEN.VC20_TABLE_TYPE;
   l_planned_executor_tab     UNAPIGEN.VC20_TABLE_TYPE;
   l_manually_entered_tab     UNAPIGEN.CHAR1_TABLE_TYPE;
   l_assign_date_tab          UNAPIGEN.DATE_TABLE_TYPE;
   l_assigned_by_tab          UNAPIGEN.VC20_TABLE_TYPE;
   l_manually_added_tab       UNAPIGEN.CHAR1_TABLE_TYPE;
   l_format_tab               UNAPIGEN.VC40_TABLE_TYPE;
   l_confirm_assign_tab       UNAPIGEN.CHAR1_TABLE_TYPE;
   l_allow_any_pr_tab         UNAPIGEN.CHAR1_TABLE_TYPE;
   l_never_create_methods_tab UNAPIGEN.CHAR1_TABLE_TYPE;
   l_delay_tab                UNAPIGEN.NUM_TABLE_TYPE;
   l_delay_unit_tab           UNAPIGEN.VC20_TABLE_TYPE;
   l_reanalysis_tab           UNAPIGEN.NUM_TABLE_TYPE;
   l_pg_class_tab             UNAPIGEN.VC2_TABLE_TYPE;
   l_log_hs_tab               UNAPIGEN.CHAR1_TABLE_TYPE;
   l_log_hs_details_tab       UNAPIGEN.CHAR1_TABLE_TYPE;
   l_lc_tab                   UNAPIGEN.VC2_TABLE_TYPE;
   l_lc_version_tab           UNAPIGEN.VC20_TABLE_TYPE;
   l_modify_flag_tab          UNAPIGEN.NUM_TABLE_TYPE;

   -- Init/SaveScParameter
   l_alarms_handled            CHAR(1) := '1';
   l_pa_tab                    UNAPIGEN.VC20_TABLE_TYPE;
   l_panode_tab                UNAPIGEN.LONG_TABLE_TYPE;
   l_pr_version_tab            UNAPIGEN.VC20_TABLE_TYPE;
   l_td_info_tab               UNAPIGEN.NUM_TABLE_TYPE;
   l_td_info_unit_tab          UNAPIGEN.VC20_TABLE_TYPE;
   l_confirm_uid_tab           UNAPIGEN. CHAR1_TABLE_TYPE;
   l_allow_any_me_tab          UNAPIGEN.CHAR1_TABLE_TYPE;
   l_min_nr_results_tab        UNAPIGEN.NUM_TABLE_TYPE;
   l_calc_method_tab           UNAPIGEN. CHAR1_TABLE_TYPE;
   l_calc_cf_tab               UNAPIGEN.VC20_TABLE_TYPE;
   l_alarm_order_tab           UNAPIGEN.VC3_TABLE_TYPE;
   l_valid_specsa_tab          UNAPIGEN.CHAR1_TABLE_TYPE;
   l_valid_specsb_tab          UNAPIGEN.CHAR1_TABLE_TYPE;
   l_valid_specsc_tab          UNAPIGEN.CHAR1_TABLE_TYPE;
   l_valid_limitsa_tab         UNAPIGEN.CHAR1_TABLE_TYPE;
   l_valid_limitsb_tab         UNAPIGEN.CHAR1_TABLE_TYPE;
   l_valid_limitsc_tab         UNAPIGEN.CHAR1_TABLE_TYPE;
   l_valid_targeta_tab         UNAPIGEN.CHAR1_TABLE_TYPE;
   l_valid_targetb_tab         UNAPIGEN.CHAR1_TABLE_TYPE;
   l_valid_targetc_tab         UNAPIGEN.CHAR1_TABLE_TYPE;
   l_mt_tab                    UNAPIGEN.VC20_TABLE_TYPE;
   l_mt_version_tab            UNAPIGEN.VC20_TABLE_TYPE;
   l_mt_nr_measur_tab          UNAPIGEN.NUM_TABLE_TYPE;
   l_log_exceptions_tab        UNAPIGEN.CHAR1_TABLE_TYPE;
   l_pa_class_tab              UNAPIGEN.VC2_TABLE_TYPE;

BEGIN

   --------------------------------------------------------------------------------
   -- Step 1. Create the parameter group (without parameters).
   --------------------------------------------------------------------------------
   lvi_step := 1;
   SELECT version
      INTO l_pp_version_in
      FROM utpp
      WHERE pp                 = a_pg
        AND version_is_current = '1'
        AND pp_key1            = a_pp_key1
        AND pp_key2            = a_pp_key2_new
        AND pp_key3            = a_pp_key3
        AND pp_key4            = a_pp_key4
        AND pp_key5            = a_pp_key5;

   lvi_step := 2;
   lvi_ret_code := UNAPIPG.InitScParameterGroup
                   (a_pg, l_pp_version_in, a_pp_key1, a_pp_key2_new, a_pp_key3, a_pp_key4, a_pp_key5, l_seq, a_sc,
                    l_pp_version_tab, l_description_tab, l_value_f_tab, l_value_s_tab, l_unit_tab,
                    l_exec_start_date_tab, l_exec_end_date_tab, l_executor_tab, l_planned_executor_tab,
                    l_manually_entered_tab, l_assign_date_tab, l_assigned_by_tab, l_manually_added_tab,
                    l_format_tab, l_confirm_assign_tab, l_allow_any_pr_tab, l_never_create_methods_tab,
                    l_delay_tab, l_delay_unit_tab, l_reanalysis_tab, l_pg_class_tab, l_log_hs_tab,
                    l_log_hs_details_tab, l_lc_tab, l_lc_version_tab, l_nr_of_rows);
   IF lvi_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
      APAOGEN.LogError (lcs_function_name, 'InitScParameterGroup returned '||lvi_ret_code||' for sc '||a_sc||', pg '||a_pg||' ('||a_pp_key2_new||').');
      RETURN;
   END IF;

   lvi_step := 3;
   FOR l_row IN 1..l_nr_of_rows LOOP
      l_sc_tab          (l_row) := a_sc;
      l_pg_tab          (l_row) := a_pg;
      l_pgnode_tab      (l_row) := NULL;
      l_pp_key1_tab     (l_row) := a_pp_key1;
      l_pp_key2_tab     (l_row) := a_pp_key2_new;
      l_pp_key3_tab     (l_row) := a_pp_key3;
      l_pp_key4_tab     (l_row) := a_pp_key4;
      l_pp_key5_tab     (l_row) := a_pp_key5;
      l_modify_flag_tab (l_row) := UNAPIGEN.MOD_FLAG_INSERT;
   END LOOP;

   lvi_step := 4;
   lvi_ret_code := UNAPIPG.SaveScParameterGroup
                   (l_sc_tab, l_pg_tab, l_pgnode_tab, l_pp_version_tab, l_pp_key1_tab, l_pp_key2_tab,
                    l_pp_key3_tab, l_pp_key4_tab, l_pp_key5_tab, l_description_tab, l_value_f_tab, l_value_s_tab,
                    l_unit_tab, l_exec_start_date_tab, l_exec_end_date_tab, l_executor_tab,
                    l_planned_executor_tab, l_manually_entered_tab, l_assign_date_tab, l_assigned_by_tab,
                    l_manually_added_tab, l_format_tab, l_confirm_assign_tab, l_allow_any_pr_tab,
                    l_never_create_methods_tab, l_delay_tab, l_delay_unit_tab, l_pg_class_tab, l_log_hs_tab,
                    l_log_hs_details_tab, l_lc_tab, l_lc_version_tab, l_modify_flag_tab, l_nr_of_rows,
                    lcs_function_name||': '||a_pp_key2_old||' -> '||a_pp_key2_new||'.');
   IF lvi_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
      APAOGEN.LogError (lcs_function_name, 'SaveScParameterGroup returned '||lvi_ret_code||' for sc '||a_sc||', pg '||a_pg||' ('||a_pp_key2_new||').');
      RETURN;
   END IF;

   --------------------------------------------------------------------------------
   -- Step 2. Process the parameters.
   --------------------------------------------------------------------------------

   lvi_step := 5;
   FOR r_pa IN (SELECT pr, UNAPIGEN.UseVersion ('pr', utpppr.pr, utpppr.pr_version) AS pr_version, utscpa.pgnode, panode
                FROM utscpg, utscpa, utpp, utpppr
                WHERE utscpg.sc               = a_sc
                  AND utscpg.pg               = a_pg
                  AND utscpg.pgnode           = a_pgnode
                  AND utscpa.sc               = utscpg.sc
                  AND utscpa.pg               = utscpg.pg
                  AND utscpa.pgnode           = utscpg.pgnode
                  AND utscpa.ss               IN ('@P', 'AV')
                  AND utpp.pp                 = utscpg.pg
                  AND utpp.pp_key1            = utscpg.pp_key1
                  AND utpp.pp_key2            = a_pp_key2_new
                  AND utpp.pp_key3            = utscpg.pp_key3
                  AND utpp.pp_key4            = utscpg.pp_key4
                  AND utpp.pp_key5            = utscpg.pp_key5
                  AND utpp.version_is_current = '1'
                  AND utpppr.pp               = utpp.pp
                  AND utpppr.pp_key1          = utpp.pp_key1
                  AND utpppr.pp_key2          = utpp.pp_key2
                  AND utpppr.pp_key3          = utpp.pp_key3
                  AND utpppr.pp_key4          = utpp.pp_key4
                  AND utpppr.pp_key5          = utpp.pp_key5
                  AND utpppr.pr               = utscpa.pa
                ORDER BY pgnode, panode) LOOP

      --------------------------------------------------------------------------------
      -- Step 2a. Add the parameters to pg + pp_key2_new that already exist in pg + pp_key2_old
      -- (and which also exist in pg + pp_key2_new).
      --------------------------------------------------------------------------------
      lvi_step := 6;
      l_nr_of_rows := NULL ;
      lvi_ret_code := UNAPIPA.InitScParameter
                         (r_pa.pr, r_pa.pr_version, NULL, a_sc, a_pg, l_pgnode_tab (1), l_pp_version_tab (1),
                          l_pp_key1_tab (1), l_pp_key2_tab (1), l_pp_key3_tab (1), l_pp_key4_tab (1), l_pp_key5_tab (1),
                          l_pr_version_tab, l_description_tab, l_value_f_tab, l_value_s_tab, l_unit_tab,
                          l_exec_start_date_tab, l_exec_end_date_tab, l_executor_tab, l_planned_executor_tab,
                          l_manually_entered_tab, l_assign_date_tab, l_assigned_by_tab, l_manually_added_tab,
                          l_format_tab, l_td_info_tab, l_td_info_unit_tab, l_confirm_uid_tab, l_allow_any_me_tab,
                          l_delay_tab, l_delay_unit_tab, l_min_nr_results_tab, l_calc_method_tab, l_calc_cf_tab,
                          l_alarm_order_tab, l_valid_specsa_tab, l_valid_specsb_tab, l_valid_specsc_tab,
                          l_valid_limitsa_tab, l_valid_limitsb_tab, l_valid_limitsc_tab, l_valid_targeta_tab,
                          l_valid_targetb_tab, l_valid_targetc_tab, l_mt_tab, l_mt_version_tab,
                          l_mt_nr_measur_tab, l_log_exceptions_tab, l_reanalysis_tab, l_pa_class_tab,
                          l_log_hs_tab, l_log_hs_details_tab, l_lc_tab, l_lc_version_tab, l_nr_of_rows);
      IF lvi_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         APAOGEN.LogError (lcs_function_name, 'InitScParameter returned '||lvi_ret_code||' for sc '||a_sc||', pg '||a_pg||' ('||a_pp_key2_new||'), pa '||r_pa.pr||'.');
      ELSE

         lvi_step := 7;
         l_alarms_handled := '1';
         FOR l_row IN 1..l_nr_of_rows LOOP
            l_sc_tab          (l_row) := a_sc;
            l_pg_tab          (l_row) := a_pg;
            l_pgnode_tab      (l_row) := l_pgnode_tab (1);
            l_pa_tab          (l_row) := r_pa.pr;
            l_panode_tab      (l_row) := NULL;
            l_modify_flag_tab (l_row) := UNAPIGEN.MOD_FLAG_CREATE;
         END LOOP;

         lvi_step := 8;
         lvi_ret_code := UNAPIPA.SaveScParameter
                            (l_alarms_handled, l_sc_tab, l_pg_tab, l_pgnode_tab, l_pa_tab, l_panode_tab,
                             l_pr_version_tab, l_description_tab, l_value_f_tab, l_value_s_tab, l_unit_tab,
                             l_exec_start_date_tab, l_exec_end_date_tab, l_executor_tab, l_planned_executor_tab,
                             l_manually_entered_tab, l_assign_date_tab, l_assigned_by_tab, l_manually_added_tab,
                             l_format_tab, l_td_info_tab, l_td_info_unit_tab, l_confirm_uid_tab, l_allow_any_me_tab,
                             l_delay_tab, l_delay_unit_tab, l_min_nr_results_tab, l_calc_method_tab, l_calc_cf_tab,
                             l_alarm_order_tab, l_valid_specsa_tab, l_valid_specsb_tab, l_valid_specsc_tab,
                             l_valid_limitsa_tab, l_valid_limitsb_tab, l_valid_limitsc_tab, l_valid_targeta_tab,
                             l_valid_targetb_tab, l_valid_targetc_tab, l_mt_tab, l_mt_version_tab,
                             l_mt_nr_measur_tab, l_log_exceptions_tab, l_pa_class_tab, l_log_hs_tab,
                             l_log_hs_details_tab, l_lc_tab, l_lc_version_tab, l_modify_flag_tab, l_nr_of_rows,
                             lcs_function_name||': '||a_pp_key2_old||' -> '||a_pp_key2_new||'.');
         IF lvi_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
            APAOGEN.LogError (lcs_function_name, 'SaveScParameter returned '||lvi_ret_code||' for sc '||a_sc||', pg '||a_pg||' ('||a_pp_key2_new||'), pa '||r_pa.pr||'.');
         ELSE

            --------------------------------------------------------------------------------
            -- Step 2b. Cancel the parameters in pg + pp_key2_old that now exist in pg + pp_key2_new.
            --------------------------------------------------------------------------------
            lvi_step := 9;
            lvi_ret_code := UNAPIPAP.CancelScPa (a_sc, a_pg, r_pa.pgnode, r_pa.pr, r_pa.panode, lcs_function_name||': '||a_pp_key2_old||' -> '||a_pp_key2_new||'.');
            IF lvi_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
               APAOGEN.LogError (lcs_function_name, 'CancelScPa returned '||lvi_ret_code||' for sc '||a_sc||', pg '||a_pg||' ('||a_pp_key2_old||'), pa '||r_pa.pr||'.');
            END IF;

         END IF;

      END IF;

   END LOOP;

   RETURN;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SUBSTR ('Exception in step '||lvi_step||': '||SQLERRM, 1, 255));
   END IF;
   RETURN;

END AddScSitePg;

--------------------------------------------------------------------------------
-- Adjust testplan when a sample's site changes.
-- Executed via an event rule on scii <avScSite>.
--------------------------------------------------------------------------------
FUNCTION ChangeavScSite
RETURN APAOGEN.RETURN_TYPE IS

   lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ChangeavScSite';
   lvi_count         INTEGER;

BEGIN

   FOR r_pg IN (SELECT pg, pgnode, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5
                FROM utscpg
                WHERE sc      = UNAPIEV.P_SC
                  AND pp_key2 = UNAPIEV.P_OLD_VALUE
                  AND ss      IN ('@P', 'AV')
                  AND pg IN (SELECT pp -- Consider only the pg's that have an equivalent pp for the new site...
                             FROM utpp
                             WHERE pp = pg
                               AND pp_key2 = UNAPIEV.P_NEW_VALUE)
                  AND pg NOT IN (SELECT pg -- ... but skip them if they already exist for the new site.
                                 FROM utscpg pgnew
                                 WHERE sc       = UNAPIEV.P_SC
                                   AND pgnew.pg = utscpg.pg
                                   AND pp_key2  = UNAPIEV.P_NEW_VALUE)
                ORDER BY pgnode) LOOP
      AddScSitePg (UNAPIEV.P_SC,
                   r_pg.pg,
                   r_pg.pgnode,
                   r_pg.pp_key1,
                   r_pg.pp_key2,
                   r_pg.pp_key3,
                   r_pg.pp_key4,
                   r_pg.pp_key5,
                   UNAPIEV.P_NEW_VALUE); -- Does its own error logging.
      -- If one pg fails to be added, keep trying the others.
   END LOOP;

   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;

END ChangeavScSite;

--------------------------------------------------------------------------------
-- Calculate the maximum date among a request's sample infofields, and save this
-- as a request infofield.
-- Executed via an event rule on InfoFieldValueChanged.
--------------------------------------------------------------------------------
FUNCTION SetRqIiMaxDateScIi
RETURN APAOGEN.RETURN_TYPE IS

   lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'SetRqIiMaxDateScIi';
   l_date1           utrq.date1%TYPE;
   lvi_step          INTEGER;

   -- SaveRqIiValue
   l_ret_code        NUMBER;
   l_nr_of_rows      NUMBER;
   l_rq_tab          UNAPIGEN.VC20_TABLE_TYPE;
   l_ic_tab          UNAPIGEN.VC20_TABLE_TYPE;
   l_icnode_tab      UNAPIGEN.LONG_TABLE_TYPE;
   l_ii_tab          UNAPIGEN.VC20_TABLE_TYPE;
   l_iinode_tab      UNAPIGEN.LONG_TABLE_TYPE;
   l_iivalue_tab     UNAPIGEN.VC2000_TABLE_TYPE;
   l_modify_flag_tab UNAPIGEN.NUM_TABLE_TYPE;

BEGIN

   lvi_step := 1;
   BEGIN
      SELECT utrqii.rq, utrqii.ic, utrqii.icnode, utrqii.ii, utrqii.iinode,
             TO_CHAR (MAX (TO_DATE (utscii.iivalue, SUBSTR (NVL (scie.format, 'DDDfx/fxMM/RR HH24fx:fxMI:SS'), 2))),
                                                    SUBSTR (NVL (rqie.format, 'DDDfx/fxMM/RR HH24fx:fxMI:SS'), 2)) AS MaxDate
      INTO l_rq_tab (1), l_ic_tab (1), l_icnode_tab (1), l_ii_tab (1), l_iinode_tab (1), l_iivalue_tab (1)
      FROM utrqii, utie rqie, utieau, utrqsc, utsc, utscii, utie scie
      WHERE utrqii.rq               = UNAPIEV.P_RQ
        AND rqie.ie                 = utrqii.ii
        AND rqie.version_is_current = 1
        AND utieau.ie               = utrqii.ii
        AND utieau.version          = utrqii.ie_version
        AND au                      = 'avCustMaxScDate'
        AND value                   = utscii.ii
        AND utrqsc.rq               = utrqii.rq
        AND utsc.sc                 = utrqsc.sc
        AND utscii.sc               = utsc.sc
        AND utscii.ii               = UNAPIEV.P_EV_REC.OBJECT_ID
        AND scie.ie                 = utscii.ii
        AND scie.version_is_current = 1
        GROUP BY utrqii.rq, utrqii.ic, utrqii.icnode, utrqii.ii, utrqii.iinode, scie.format, rqie.format;
        --
        APAOGEN.LogError (lcs_function_name, 'Success-query step '||lvi_step||' RQ:'||UNAPIEV.P_RQ||'-II:'||UNAPIEV.P_EV_REC.OBJECT_ID );
        --
   EXCEPTION WHEN NO_DATA_FOUND THEN
      APAOGEN.LogError (lcs_function_name, 'EXCP-NO-DATA-FOUND=OK step '||lvi_step||' RQ:'||UNAPIEV.P_RQ||'-II:'||UNAPIEV.P_EV_REC.OBJECT_ID );
      RETURN UNAPIGEN.DBERR_SUCCESS;
   END;

   lvi_step := 2;
   l_nr_of_rows := 1 ;
   l_modify_flag_tab (1) := UNAPIGEN.MOD_FLAG_UPDATE ;
   l_ret_code := UNAPIRQ.SaveRqIiValue (l_rq_tab, l_ic_tab, l_icnode_tab, l_ii_tab, l_iinode_tab,
                                        l_iivalue_tab, l_modify_flag_tab, l_nr_of_rows, lcs_function_name);
   IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
      APAOGEN.LogError (lcs_function_name, 'SaveRqIiValue ('||l_nr_of_rows||' rows) returned '||l_ret_code||' for request '||UNAPIEV.P_RQ||'.');
      RETURN UNAPIGEN.DBERR_SUCCESS;
   ELSE
     APAOGEN.LogError (lcs_function_name, 'Success-SaveRqIiValue step '||lvi_step||' RQ:'||UNAPIEV.P_RQ||'-II:'||UNAPIEV.P_EV_REC.OBJECT_ID );   
   END IF;

   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SUBSTR ('Exception in step '||lvi_step||' RQ:'||UNAPIEV.P_RQ||'-II:'||UNAPIEV.P_EV_REC.OBJECT_ID ||': '||SQLERRM, 1, 255));
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;

END SetRqIiMaxDateScIi;

--------------------------------------------------------------------------------
-- Update a number of groupkeys that are based on (and change with) some sample properties.
-- (Priority, and date1-5.) This is to allow method list sorting on these properties.
-- The groupkey are created by standard event rules, but kept up to date by an custom event rule
-- on SampleUpdated, for performance reasons.
--------------------------------------------------------------------------------
FUNCTION UpdScMeGkScPropSc
RETURN APAOGEN.RETURN_TYPE IS

   lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'UpdScMeGkScPropSc';
   lvi_step          INTEGER;
   l_priority        utsc.priority%TYPE;
   l_date1           utsc.date1%TYPE;
   l_date2           utsc.date2%TYPE;
   l_date3           utsc.date3%TYPE;
   l_date4           utsc.date4%TYPE;
   l_date5           utsc.date5%TYPE;

BEGIN

   lvi_step := 1;
   SELECT priority,   date1,   date2,   date3,   date4,   date5
   INTO l_priority, l_date1, l_date2, l_date3, l_date4, l_date5
   FROM utsc
   WHERE sc = UNAPIEV.P_SC ;

   lvi_step := 2;
   UPDATE utscmegkscpriority SET scPriority = NVL (TO_CHAR (l_priority                      ), '9'                  ) WHERE sc = UNAPIEV.P_SC ;
   UPDATE utscmegkscdate1    SET scDate1    = NVL (TO_CHAR (l_date1, 'YYYY/MM/DD HH24:MI:SS'), '9999/99/99 99:99:99') WHERE sc = UNAPIEV.P_SC ;
   UPDATE utscmegkscdate2    SET scDate2    = NVL (TO_CHAR (l_date2, 'YYYY/MM/DD HH24:MI:SS'), '9999/99/99 99:99:99') WHERE sc = UNAPIEV.P_SC ;
   UPDATE utscmegkscdate3    SET scDate3    = NVL (TO_CHAR (l_date3, 'YYYY/MM/DD HH24:MI:SS'), '9999/99/99 99:99:99') WHERE sc = UNAPIEV.P_SC ;
   UPDATE utscmegkscdate4    SET scDate4    = NVL (TO_CHAR (l_date4, 'YYYY/MM/DD HH24:MI:SS'), '9999/99/99 99:99:99') WHERE sc = UNAPIEV.P_SC ;
   UPDATE utscmegkscdate5    SET scDate5    = NVL (TO_CHAR (l_date5, 'YYYY/MM/DD HH24:MI:SS'), '9999/99/99 99:99:99') WHERE sc = UNAPIEV.P_SC ;
   -- Note that the groupkey format may differ from the Windows/infofield format, because it's used for sorting on.

   lvi_step := 3;
   UPDATE utscmegk SET value = NVL (TO_CHAR (l_priority                      ), '9'                  ) WHERE sc = UNAPIEV.P_SC AND gk = 'scPriority' ;
   UPDATE utscmegk SET value = NVL (TO_CHAR (l_date1, 'YYYY/MM/DD HH24:MI:SS'), '9999/99/99 99:99:99') WHERE sc = UNAPIEV.P_SC AND gk = 'scDate1' ;
   UPDATE utscmegk SET value = NVL (TO_CHAR (l_date2, 'YYYY/MM/DD HH24:MI:SS'), '9999/99/99 99:99:99') WHERE sc = UNAPIEV.P_SC AND gk = 'scDate2' ;
   UPDATE utscmegk SET value = NVL (TO_CHAR (l_date3, 'YYYY/MM/DD HH24:MI:SS'), '9999/99/99 99:99:99') WHERE sc = UNAPIEV.P_SC AND gk = 'scDate3' ;
   UPDATE utscmegk SET value = NVL (TO_CHAR (l_date4, 'YYYY/MM/DD HH24:MI:SS'), '9999/99/99 99:99:99') WHERE sc = UNAPIEV.P_SC AND gk = 'scDate4' ;
   UPDATE utscmegk SET value = NVL (TO_CHAR (l_date5, 'YYYY/MM/DD HH24:MI:SS'), '9999/99/99 99:99:99') WHERE sc = UNAPIEV.P_SC AND gk = 'scDate5' ;

   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SUBSTR ('Exception in step '||lvi_step||': '||SQLERRM, 1, 255));
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;

END UpdScMeGkScPropSc;

--------------------------------------------------------------------------------
-- Similar to the above function UpdScMeGkScPropSc, these function updates the same method groupkeys,
-- but is based on InfoFieldValueChanged. This is needed because no SampleUpdated occurs
-- when an infofield is saved as a method property.
--------------------------------------------------------------------------------
FUNCTION UpdScMeGkScPropIi
RETURN APAOGEN.RETURN_TYPE IS
   lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'UpdScMeGkScPropIi';
   lvs_ievalue       utie.ievalue%TYPE;
   lvs_def_val_tp    utie.def_val_tp%TYPE;
   l_priority        utsc.priority%TYPE;
   l_date1           utsc.date1%TYPE;
   l_date2           utsc.date2%TYPE;
   l_date3           utsc.date3%TYPE;
   l_date4           utsc.date4%TYPE;
   l_date5           utsc.date5%TYPE;
BEGIN
   SELECT ievalue, def_val_tp
      INTO lvs_ievalue, lvs_def_val_tp
      FROM utie
      WHERE ie      = UNAPIEV.P_II
        AND version = UNAPIEV.P_IE_VERSION;
   IF lvs_def_val_tp = 'S' THEN
      IF lvs_ievalue = 'priority' THEN
         -- This infofield was saved as the scprop priority, so also update the scmegk.
         -- We could use UNAPIEV.P_NEW_VALUE, but that might be formatted. Instead of retrieving
         -- the format from the infofield and converting it, just update with what's in the scprop,
         -- which is already up to date because the standard event rule has a lower rule_nr.
         SELECT priority INTO l_priority FROM utsc WHERE sc = UNAPIEV.P_SC ;
         UPDATE utscmegkscpriority SET scPriority = NVL (TO_CHAR (l_priority), '9') WHERE sc = UNAPIEV.P_SC ;
         UPDATE utscmegk           SET value      = NVL (TO_CHAR (l_priority), '9') WHERE sc = UNAPIEV.P_SC AND gk = 'scPriority' ;
      ELSIF lvs_ievalue = 'date1' THEN
         SELECT date1 INTO l_date1 FROM utsc WHERE sc = UNAPIEV.P_SC ;
         UPDATE utscmegkscdate1 SET scDate1 = NVL (TO_CHAR (l_date1, 'YYYY/MM/DD HH24:MI:SS'), '9999/99/99 99:99:99') WHERE sc = UNAPIEV.P_SC ;
         UPDATE utscmegk        SET value   = NVL (TO_CHAR (l_date1, 'YYYY/MM/DD HH24:MI:SS'), '9999/99/99 99:99:99') WHERE sc = UNAPIEV.P_SC AND gk = 'scDate1' ;
      ELSIF lvs_ievalue = 'date2' THEN
         SELECT date2 INTO l_date2 FROM utsc WHERE sc = UNAPIEV.P_SC ;
         UPDATE utscmegkscdate2 SET scDate2 = NVL (TO_CHAR (l_date2, 'YYYY/MM/DD HH24:MI:SS'), '9999/99/99 99:99:99') WHERE sc = UNAPIEV.P_SC ;
         UPDATE utscmegk        SET value   = NVL (TO_CHAR (l_date2, 'YYYY/MM/DD HH24:MI:SS'), '9999/99/99 99:99:99') WHERE sc = UNAPIEV.P_SC AND gk = 'scDate2' ;
      ELSIF lvs_ievalue = 'date3' THEN
         SELECT date3 INTO l_date3 FROM utsc WHERE sc = UNAPIEV.P_SC ;
         UPDATE utscmegkscdate3 SET scDate3 = NVL (TO_CHAR (l_date3, 'YYYY/MM/DD HH24:MI:SS'), '9999/99/99 99:99:99') WHERE sc = UNAPIEV.P_SC ;
         UPDATE utscmegk        SET value   = NVL (TO_CHAR (l_date3, 'YYYY/MM/DD HH24:MI:SS'), '9999/99/99 99:99:99') WHERE sc = UNAPIEV.P_SC AND gk = 'scDate3' ;
      ELSIF lvs_ievalue = 'date4' THEN
         SELECT date4 INTO l_date4 FROM utsc WHERE sc = UNAPIEV.P_SC ;
         UPDATE utscmegkscdate4 SET scDate4 = NVL (TO_CHAR (l_date4, 'YYYY/MM/DD HH24:MI:SS'), '9999/99/99 99:99:99') WHERE sc = UNAPIEV.P_SC ;
         UPDATE utscmegk        SET value   = NVL (TO_CHAR (l_date4, 'YYYY/MM/DD HH24:MI:SS'), '9999/99/99 99:99:99') WHERE sc = UNAPIEV.P_SC AND gk = 'scDate4' ;
      ELSIF lvs_ievalue = 'date5' THEN
         SELECT date5 INTO l_date5 FROM utsc WHERE sc = UNAPIEV.P_SC ;
         UPDATE utscmegkscdate5 SET scDate5 = NVL (TO_CHAR (l_date5, 'YYYY/MM/DD HH24:MI:SS'), '9999/99/99 99:99:99') WHERE sc = UNAPIEV.P_SC ;
         UPDATE utscmegk        SET value   = NVL (TO_CHAR (l_date5, 'YYYY/MM/DD HH24:MI:SS'), '9999/99/99 99:99:99') WHERE sc = UNAPIEV.P_SC AND gk = 'scDate5' ;
      END IF;
   END IF;
   RETURN UNAPIGEN.DBERR_SUCCESS;
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SUBSTR ('Exception: '||SQLERRM, 1, 255));
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END UpdScMeGkScPropIi;

END APAOEVRULES;
/

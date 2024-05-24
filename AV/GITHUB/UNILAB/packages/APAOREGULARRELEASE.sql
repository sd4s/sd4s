CREATE OR REPLACE PACKAGE        APAOREGULARRELEASE AS
--------------------------------------------------------------------------------
--  PROJECT : Vredestein Enschede
-------------------------------------------------------------------------------
--  PACKAGE : APAOREGULARRELEASE
-- ABSTRACT : Package to assign grondstoffen
--   WRITER : Rody Sparenberg
--     DATE : 23/02/2007
--   TARGET : Oracle 10.2.0
--  VERSION : 6.1.1	$Revision: 1 $
--------------------------------------------------------------------------------
--  REMARKS :
--------------------------------------------------------------------------------
--  CHANGES :
--
--  When      | Who       | What
--============|===========|=====================================================
-- 23/02/2007 | RS        | Created
-- 16/01/2013 | RS        | Added EvaluateTimeCountBased
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
FUNCTION EXPIRATION(avs_sc            IN APAOGEN.NAME_TYPE,
                    avs_modify_reason IN APAOGEN.MODIFY_REASON_TYPE)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION TIMECOUNTBASED(avs_sc            IN APAOGEN.NAME_TYPE,
                    		avs_modify_reason IN APAOGEN.MODIFY_REASON_TYPE)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION ASSIGN_PG( avs_sc            IN APAOGEN.NAME_TYPE,
                    avs_pg            IN APAOGEN.NAME_TYPE,
                    avs_modify_reason IN APAOGEN.MODIFY_REASON_TYPE)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION EvaluateTimeCountBased
RETURN APAOGEN.RETURN_TYPE;

END APAOREGULARRELEASE;

/


CREATE OR REPLACE PACKAGE BODY        APAOREGULARRELEASE AS
--------------------------------------------------------------------------------
--  PROJECT : Vredestein Enschede
-------------------------------------------------------------------------------
--  PACKAGE : APAOREGULARRELEASE
-- ABSTRACT : Package to assign grondstoffen
--   WRITER : Rody Sparenberg
--     DATE : 23/02/2007
--   TARGET : Oracle 10.2.0 / Unilab 6.3
--  VERSION : av3.0
--------------------------------------------------------------------------------
--  REMARKS :
--------------------------------------------------------------------------------
--  CHANGES :
--
--  When      | Who       | What
--============|===========|=====================================================
-- 23/02/2007 | RS        | mp20061205 Vredestein scope customisaties Unilab v05.doc
--                        | Created
-- 17/04/2007 | RS		  | Changed EXPIRATION
-- 26/04/2007 | RS		  | Changed TIMECOUNTBASED
-- 15/06/2007 | RS        | V1.2 RS20070615 Technische omschrijving customisaties Unilab.doc
--						  | Changed TIMECOUNTBASED
-- 25/01/2008 | RS        | Changed TIMECOUNTBASED (av1.2.C05)
-- 25/06/2008 | RS        | Changed API-calls AddComment into APAOFUNCTIONS.AddComment
-- 17/09/2008 | HVB       | HVB01: Changed TIMECOUNTBASED. Deleting empty pg should reset counter
-- 03/03/2011 | RS        | Upgrade V6.3
--                        | Changed SYSDATE INTO CURRENT_TIMESTAMP
--                        | Changed DATE; INTO TIMESTAMP WITH TIME ZONE;
-- 27/05/2011 | RS        | Removed unnecessary setting of UNAPIEV.P_SC
-- 16/01/2013 | RS        | Added EvaluateTimeCountBased
-- 03/04/2013 | RS        | Added EvaluateTimeCountBased
-- 21/04/2013 | RS        | Changed EvaluateTimeCountBased: in case of error don't retry
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
ics_package_name 	CONSTANT VARCHAR2(20) := 'APAOREGULARRELEASE';

ics_au_expiration	CONSTANT APAOGEN.NAME_TYPE := APAOCONSTANT.GetConstString ('au_expiration');

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
FUNCTION EXPIRATION(avs_sc            IN APAOGEN.NAME_TYPE,
                    avs_modify_reason IN APAOGEN.MODIFY_REASON_TYPE)
RETURN APAOGEN.RETURN_TYPE IS

lvs_sc     			APAOGEN.NAME_TYPE;
lvs_version			APAOGEN.NAME_TYPE;
lvs_st     			APAOGEN.NAME_TYPE;
lvn_pgnode 			APAOGEN.NODE_TYPE;
lvi_expiration 	NUMBER;
lvi_counter		 	NUMBER;
lvd_release_date	TIMESTAMP WITH TIME ZONE;

CURSOR lvq_pp_always IS
	SELECT pp, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5
	  FROM utstpp a, utsc b
	 WHERE b.sc = avs_sc
	   AND a.st = b.st
	   AND a.version = b.st_version
	   AND a.freq_tp = 'A'
	   AND NOT exists (SELECT *
	   						FROM utscpg
	   					  WHERE sc = b.sc
	   					    AND pg = a.pp);

CURSOR lvq_pp_new_release IS
	SELECT pp, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5
	  FROM utstpp a, utsc b
	 WHERE b.sc = avs_sc
	   AND a.st = b.st
	   AND a.version = b.st_version
	   AND a.freq_tp NOT IN ('A','N')
	   AND NOT exists (SELECT *
	   						FROM utscpg
	   					  WHERE sc = b.sc
	   					    AND pg = a.pp);

BEGIN
	--------------------------------------------------------------------------------
	-- Assign all pp's to avs_sc with frequency 'always' if not available yet
	--------------------------------------------------------------------------------
   FOR lvr_pp IN lvq_pp_always LOOP
		lvi_ret_code := APAOFUNCTIONS.AssignParametergroup ( avs_sc,
								                                	  lvr_pp.pp, lvn_pgnode,
								                                   lvr_pp.pp_key1,
								                                   lvr_pp.pp_key2,
								                                   lvr_pp.pp_key3,
								                                   lvr_pp.pp_key4,
								                                   lvr_pp.pp_key5,
								                                   avs_modify_reason);
	END LOOP;

	--------------------------------------------------------------------------------
	-- Retrieve current st
	--------------------------------------------------------------------------------
	SELECT st, st_version
	  INTO lvs_st, lvs_version
	  FROM utsc
	 WHERE sc = avs_sc;
	--------------------------------------------------------------------------------
	-- Check for stau ics_au_expiration
	--------------------------------------------------------------------------------
   SELECT NVL(MAX(value),-1)
	  INTO lvi_expiration
	  FROM utstau
	 WHERE st 		= lvs_st
	   AND version = lvs_version
	   AND au 		= ics_au_expiration;
	--------------------------------------------------------------------------------
	-- No attribute => do nothing
	--------------------------------------------------------------------------------
	IF lvi_expiration = -1 THEN
		RETURN UNAPIGEN.DBERR_SUCCESS;
	END IF;
	--------------------------------------------------------------------------------
	-- Has the sample been logged on before ?
	--------------------------------------------------------------------------------
	SELECT COUNT(*)
	  INTO lvi_counter
	  FROM ataoregularrelease
	 WHERE st = lvs_st
	   AND release_date IS NOT NULL;
	--------------------------------------------------------------------------------
	-- No release_date => do nothing
	--------------------------------------------------------------------------------
	IF lvi_counter = 0 THEN
		RETURN UNAPIGEN.DBERR_SUCCESS;
	END IF;
	--------------------------------------------------------------------------------
	-- Retrieve release_date + "lvi_expiration" months
	--------------------------------------------------------------------------------
	SELECT NVL(MAX(ADD_MONTHS(release_date, lvi_expiration)), CURRENT_TIMESTAMP)
	  INTO lvd_release_date
	  FROM ataoregularrelease
	 WHERE st = lvs_st;
	--------------------------------------------------------------------------------
	-- Check if last release date is too long ago
	--------------------------------------------------------------------------------
	IF lvd_release_date <= CURRENT_TIMESTAMP THEN
		--------------------------------------------------------------------------------
		-- Assign all pp's to avs_sc with frequency other than 'always'/'never'
		-- if not available yet
		--------------------------------------------------------------------------------
	   FOR lvr_pp IN lvq_pp_new_release LOOP
			lvi_ret_code := APAOFUNCTIONS.AssignParametergroup ( avs_sc,
									                                	  lvr_pp.pp, lvn_pgnode,
									                                   lvr_pp.pp_key1,
									                                   lvr_pp.pp_key2,
									                                   lvr_pp.pp_key3,
									                                   lvr_pp.pp_key4,
									                                   lvr_pp.pp_key5,
									                                   avs_modify_reason);
			IF lvi_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
				UPDATE utstpp
				   SET last_sched = CURRENT_TIMESTAMP
				 WHERE st = lvs_st
				   AND pp = lvr_pp.pp;
			END IF;
		END LOOP;
	END IF;
   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      lvs_sqlerrm := SUBSTR(SQLERRM,1,255);
   END IF;
   APAOGEN.LogError(ics_package_name || '.EXPIRATION', lvs_sqlerrm);
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END EXPIRATION;

FUNCTION TIMECOUNTBASED(avs_sc            IN APAOGEN.NAME_TYPE,
                    		avs_modify_reason IN APAOGEN.MODIFY_REASON_TYPE)
RETURN APAOGEN.RETURN_TYPE IS
--PRAGMA AUTONOMOUS_TRANSACTION;

lvs_sc     			APAOGEN.NAME_TYPE;
lvs_st     			APAOGEN.NAME_TYPE;
lvn_pgnode 			APAOGEN.NODE_TYPE;
lvi_count			NUMBER;

lvi_nr_of_rows                  NUMBER;
lts_dd_tab                      UNAPIGEN.VC3_TABLE_TYPE;
lts_access_rights_tab           UNAPIGEN.CHAR1_TABLE_TYPE;

CURSOR lvq_pp_always(avs_sc IN VARCHAR2) IS
	SELECT pp, version, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5
	  FROM utstpp a, utsc b
	 WHERE b.sc = avs_sc
	   AND a.st = b.st
	   AND a.version = b.st_version
	   AND a.freq_tp = 'A'
	   AND NOT exists (SELECT *
	   						FROM utscpg
	   					  WHERE sc = b.sc
	   					    AND pg = a.pp);

CURSOR lvq_pp_not_always(avs_sc IN VARCHAR2) IS
	SELECT pp, version, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5
	  FROM utstpp a, utsc b
	 WHERE b.sc = avs_sc
	   AND a.st = b.st
	   AND a.version = b.st_version
	   AND a.freq_tp != 'A'
	   AND NOT exists (SELECT *
	   						FROM utscpg
	   					  WHERE sc = b.sc
	   					    AND pg = a.pp);

BEGIN
    --------------------------------------------------------------------------------
	-- Retrieve current st
	--------------------------------------------------------------------------------
    SELECT st
	  INTO lvs_st
	  FROM utsc
	 WHERE sc = avs_sc;
	--------------------------------------------------------------------------------
	-- Save new release date
	--------------------------------------------------------------------------------
	DELETE
	  FROM ataoregularrelease
	 WHERE st = lvs_st;

	INSERT
	  INTO ataoregularrelease
	VALUES (lvs_st, CURRENT_TIMESTAMP);
	--------------------------------------------------------------------------------
	-- Are there any pp's with frequency other than 'always'
	--------------------------------------------------------------------------------
   SELECT COUNT(*)
	  INTO lvi_count
	  FROM utstpp a, utsc b
	 WHERE b.sc = avs_sc
	   AND a.st = b.st
	   AND a.version = b.st_version
	   AND a.freq_tp != 'A';

	IF lvi_count > 0 THEN
		--------------------------------------------------------------------------------
		-- Create new sample of same avs_st
		--------------------------------------------------------------------------------
   	    lvi_ret_code := APAOFUNCTIONS.CreateSample ( lvs_sc,
                     								 lvs_st,
                     								 '',
                     								 'MANUAL ASSIGNMENT',
													 avs_modify_reason);
        --------------------------------------------------------------------------------
		-- Change status to @P of new created sample
		--------------------------------------------------------------------------------
   	    UPDATE utsc
		   SET ss = '@P', lc = 'S1', lc_version = 0
		 WHERE sc = lvs_sc;
		--------------------------------------------------------------------------------
		-- Log audittrail
		--------------------------------------------------------------------------------
		lvi_ret_code := APAOFUNCTIONS.AddScComment( lvs_sc, 'Changed status to ''@P'' by ' || ics_package_name || '.AssignCOA');
		lvi_ret_code := APAOFUNCTIONS.AddScComment( avs_sc, 'Samplecode ' || lvs_sc || ' has been created...');
		lvi_ret_code := APAOFUNCTIONS.AddScPgComment( avs_sc, UNAPIEV.P_PG, UNAPIEV.P_PGNODE, 'Samplecode ' || lvs_sc || ' has been created...');
		--------------------------------------------------------------------------------
		-- Changed 15/06/2007
		-- V1.2 RS20070615 Technische omschrijving customisaties Unilab.doc
		-- Do not assign all pp's to lvs_sc with frequency 'always'
		--------------------------------------------------------------------------------
		--------------------------------------------------------------------------------
		-- Assign all pp's to lvs_sc with frequency other than 'always'
		-- and not assigned to original sc avs_sc
		--------------------------------------------------------------------------------
   	    FOR lvr_pp IN lvq_pp_not_always(avs_sc) LOOP
			IF APAOFUNCTIONS.EvalAssignmentfreq(lvs_sc, lvr_pp.pp) THEN
				--------------------------------------------------------------------------------
				-- Assign pp's with frequency other than 'always'
				--------------------------------------------------------------------------------
		   	    lvi_ret_code := APAOFUNCTIONS.AssignParametergroup ( lvs_sc,
										                             lvr_pp.pp, lvn_pgnode,
										                             lvr_pp.pp_key1,
										                             lvr_pp.pp_key2,
										                             lvr_pp.pp_key3,
										                             lvr_pp.pp_key4,
										                             lvr_pp.pp_key5,
										                             avs_modify_reason);
				IF lvi_ret_code = UNAPIGEN.DBERR_SUCCESS THEN

					--------------------------------------------------------------------------------
					-- HVB01: Moved this block from below:
					-- Reset frequency st-pp
					--------------------------------------------------------------------------------
					UPDATE utstpp
					   SET last_sched = CURRENT_TIMESTAMP,
					   	 last_cnt = 0
					 WHERE st 		= lvs_st
					   AND pp 		= lvr_pp.pp
					   AND version = lvr_pp.version;
					--------------------------------------------------------------------------------
					-- HVB01: End block
					--------------------------------------------------------------------------------

					--------------------------------------------------------------------------------
					-- It is possible that we did create an empty pg, in that case we delete it
					--------------------------------------------------------------------------------
		   		    lvi_ret_code := APAOFUNCTIONS.DeleteEmptyPg (lvs_sc);
                    lvi_ret_code := UNAPIGEN.DBERR_SUCCESS;
					--------------------------------------------------------------------------------
					-- If the function returned DBERR_NOOBJECT
					-- no pg has been deleted. In that case we reset the frequency st-pp
					--------------------------------------------------------------------------------
		   		    IF lvi_ret_code = UNAPIGEN.DBERR_NOOBJECT THEN
						--------------------------------------------------------------------------------
						-- Add comment to original parametergroup that pg has been assigned
						--------------------------------------------------------------------------------
						lvi_ret_code := APAOFUNCTIONS.AddScPgComment( avs_sc, UNAPIEV.P_PG, UNAPIEV.P_PGNODE, 'Parametergroup <' || lvr_pp.pp || '> of samplecode ' || lvs_sc || ' has been assigned');
---HVB01: Moved following block. If pg has been deleted, the frequency has to be reset too
---						--------------------------------------------------------------------------------
---						-- Reset frequency st-pp
---						--------------------------------------------------------------------------------
---						UPDATE utstpp
---						   SET last_sched = CURRENT_TIMESTAMP,
---						   	 last_cnt = 0
---						 WHERE st 		= lvs_st
---						   AND pp 		= lvr_pp.pp
---						   AND version = lvr_pp.version;
---HVB01: End block
					ELSE
						--------------------------------------------------------------------------------
						-- Add comment to original sample that the last assigned pg has been deleted
						--------------------------------------------------------------------------------
						lvi_ret_code := APAOFUNCTIONS.AddScComment( avs_sc, 'Parametergroup <' || lvr_pp.pp || '> of samplecode ' || lvs_sc || ' has been deleted');
				        --------------------------------------------------------------------------------
						-- Add comment to original parametergroup that the last assigned pg has been deleted
						--------------------------------------------------------------------------------
						lvi_ret_code := APAOFUNCTIONS.AddScPgComment( avs_sc, UNAPIEV.P_PG, UNAPIEV.P_PGNODE, 'Parametergroup <' || lvr_pp.pp || '> of samplecode ' || lvs_sc || ' has been deleted');
					END IF;
				END IF;
			ELSE
				--------------------------------------------------------------------------------
				-- Update frequency st-pp
				--------------------------------------------------------------------------------
				UPDATE utstpp
				   SET last_cnt = last_cnt + 1
				 WHERE st 		= lvs_st
				   AND pp 		= lvr_pp.pp
					AND version = lvr_pp.version;
			END IF;
		END LOOP;
   END IF;
	--------------------------------------------------------------------------------
	-- Delete the new sample
	--------------------------------------------------------------------------------
	lvi_ret_code := APAOFUNCTIONS.DeleteEmptySc(lvs_sc);
	--------------------------------------------------------------------------------
	-- If the function returned DBERR_SUCCESS the sc has been deleted.
	--------------------------------------------------------------------------------
	IF lvi_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
        --------------------------------------------------------------------------------
        -- Remove event from not created samples to prevent execution of the event rules
        -- on sample creation
        --------------------------------------------------------------------------------
        DELETE FROM utev WHERE dbapi_name = 'CreateSample' AND object_id = lvs_sc;
		--------------------------------------------------------------------------------
		-- Add comment to original sample that the new sc will not be used
		--------------------------------------------------------------------------------
		lvi_ret_code := APAOFUNCTIONS.AddScComment( avs_sc, 'Samplecode ' || lvs_sc || ' will not be used...');
		--------------------------------------------------------------------------------
		-- Add comment to original parametergroup that the new sc will not be used
		--------------------------------------------------------------------------------
		lvi_ret_code := APAOFUNCTIONS.AddScPgComment( avs_sc, UNAPIEV.P_PG, UNAPIEV.P_PGNODE, 'Samplecode ' || lvs_sc || ' will not be used...');
	END IF;

    RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      lvs_sqlerrm := SUBSTR(SQLERRM,1,255);
   END IF;
   APAOGEN.LogError(ics_package_name || '.TIMECOUNTBASED', lvs_sqlerrm);
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END TIMECOUNTBASED;

FUNCTION ASSIGN_PG( avs_sc            IN APAOGEN.NAME_TYPE,
                    avs_pg            IN APAOGEN.NAME_TYPE,
                    avs_modify_reason IN APAOGEN.MODIFY_REASON_TYPE)
RETURN APAOGEN.RETURN_TYPE IS

lvs_sc     		APAOGEN.NAME_TYPE;
lvn_pgnode 		APAOGEN.NODE_TYPE;
lvi_count		NUMBER;

CURSOR lvq_pp IS
	SELECT pp, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5
	  FROM utstpp a, utsc b
	 WHERE b.sc = avs_sc
	   AND a.st = b.st
	   AND a.version = b.st_version
	   AND a.pp = avs_pg
	   AND NOT exists (SELECT *
	   						FROM utscpg
	   					  WHERE sc = b.sc
	   					    AND pg = a.pp);

BEGIN

	lvi_ret_code := UNAPIGEN.DBERR_SUCCESS;
	--------------------------------------------------------------------------------
	-- Assign avs_pg to avs_sc if not available
	--------------------------------------------------------------------------------
	FOR lvr_pp IN lvq_pp LOOP
		lvi_ret_code := APAOFUNCTIONS.AssignParametergroup ( avs_sc,
								                                	  lvr_pp.pp, lvn_pgnode,
								                                   lvr_pp.pp_key1,
								                                   lvr_pp.pp_key2,
								                                   lvr_pp.pp_key3,
								                                   lvr_pp.pp_key4,
								                                   lvr_pp.pp_key5,
								                                   avs_modify_reason);
	END LOOP;

   RETURN lvi_ret_code;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      lvs_sqlerrm := SUBSTR(SQLERRM,1,255);
   END IF;
   APAOGEN.LogError(ics_package_name || '.ASSIGN_PG', lvs_sqlerrm);
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END ASSIGN_PG;

FUNCTION EvaluateTimeCountBased
RETURN APAOGEN.RETURN_TYPE IS

    CURSOR lvq_sc IS
    SELECT * FROM ATAOREGULARRELEASE_PLANNED ORDER BY SC, PGNODE;
BEGIN

    lvi_ret_code := UNILAB.APAOACTION.SETCONNECTION;

    IF lvi_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
        FOR lvr_sc IN lvq_sc LOOP
            -- first delete, we will try only once
            DELETE
              FROM ATAOREGULARRELEASE_PLANNED
             WHERE sc = lvr_sc.sc AND pg = lvr_sc.pg AND pgnode = lvr_sc.pgnode;
            COMMIT;
            lvi_ret_code := UNAPIGEN.BEGINTRANSACTION();
            IF lvi_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
                UNAPIEV.P_SC := lvr_sc.sc;
                UNAPIEV.P_PG := lvr_sc.pg;
                UNAPIEV.P_PGNODE := lvr_sc.pgnode;
                lvi_ret_code := APAOREGULARRELEASE.TIMECOUNTBASED(lvr_sc.sc, 'Job');
                --IF lvi_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
                --    DELETE
                --      FROM ATAOREGULARRELEASE_PLANNED
                --     WHERE sc = lvr_sc.sc AND pg = lvr_sc.pg AND pgnode = lvr_sc.pgnode;
                --END IF;
                lvi_ret_code := UNAPIGEN.ENDTRANSACTION();
            END IF;
        END LOOP;
    END IF;

    RETURN lvi_ret_code;
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      lvs_sqlerrm := SUBSTR(SQLERRM,1,255);
   END IF;
   APAOGEN.LogError(ics_package_name || '.EvaluateTimeCountBased', lvs_sqlerrm);
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END EvaluateTimeCountBased;

END APAOREGULARRELEASE;
/

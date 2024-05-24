--------------------------------------------------------
--  File created - dinsdag-oktober-27-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure STARTMEREMGKISREL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UNILAB"."STARTMEREMGKISREL" IS
--------------------------------------------------------------------------------
--  PROJECT : Vredestein Enschede
-------------------------------------------------------------------------------
--  PACKAGE : StartMeRemGkIsRel
-- ABSTRACT :
--   WRITER : Rody Sparenberg
--     DATE : 
--   TARGET : Oracle 10.2.0 / Unilab 6.4
--  VERSION : av3.0
--------------------------------------------------------------------------------
--  REMARKS :
--------------------------------------------------------------------------------
--  CHANGES :
--
--  When      | Who       | What
--============|===========|=====================================================
-- 03/03/2011 | RS        | Upgrade V6.3
--                        | Changed SYSDATE INTO CURRENT_TIMESTAMP
-- 04/03/2011 | RS        | Upgrade V6.4
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := 'StartMeRemGkIsRel';
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- functions- and/or procedures-declarations
--------------------------------------------------------------------------------
l_job                         VARCHAR2(30);

BEGIN
        l_job := 'UNI_J_RemoveMeGkME_IS_RELEVANT';
        DBMS_SCHEDULER.CREATE_JOB(
                        job_name          =>  l_job,
                        job_class            => 'UNI_JC_OTHER_JOBS',
                        job_type          =>  'PLSQL_BLOCK',
                        job_action        =>  'DECLARE r NUMBER; BEGIN r:= APAOACTION.MeRemoveGk(''ME_IS_RELEVANT''); END;',
                        start_date        =>   CURRENT_TIMESTAMP + 1/24/60,
                        --repeat_interval   =>  'FREQ = MINUTELY; INTERVAL = 1',
                        --was leading to an exception with an interval > 999
                        repeat_interval      =>  UNAPIEV.SQLTranslatedJobInterval(1, 'days'),                        
                        enabled              => TRUE
                );   
                DBMS_SCHEDULER.SET_ATTRIBUTE (
                        name           => l_job,
                        attribute      => 'restartable',
                        value          => TRUE);
   
END StartMeRemGkIsRel; 
 

/

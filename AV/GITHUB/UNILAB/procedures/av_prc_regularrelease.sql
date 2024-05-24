--------------------------------------------------------
--  File created - dinsdag-oktober-27-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure REGULARRELEASE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UNILAB"."REGULARRELEASE" IS
--------------------------------------------------------------------------------
--  PROJECT : Vredestein Enschede
-------------------------------------------------------------------------------
--  PACKAGE : RegularRelease
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
-- 13/02/2013 | RS        | Created
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := 'RegularRelease';
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
        l_job := 'UNI_J_RegularRelease';
        DBMS_SCHEDULER.CREATE_JOB(
                        job_name          =>  l_job,
                        job_class            => 'UNI_JC_OTHER_JOBS',
                        job_type          =>  'PLSQL_BLOCK',
                        job_action        =>  'DECLARE r NUMBER; BEGIN r:= APAOREGULARRELEASE.EvaluateTimeCountBased; END;',
                        start_date        =>   CURRENT_TIMESTAMP + 1/24/60,
                        --repeat_interval   =>  'FREQ = MINUTELY; INTERVAL = 1',
                        --was leading to an exception with an interval > 999
                        repeat_interval      =>  UNAPIEV.SQLTranslatedJobInterval(1, 'minutes'),
                        enabled              => TRUE
                );
                DBMS_SCHEDULER.SET_ATTRIBUTE (
                        name           => l_job,
                        attribute      => 'restartable',
                        value          => TRUE);

END RegularRelease;
 

/

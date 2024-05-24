--------------------------------------------------------
--  File created - dinsdag-oktober-27-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure STARTAPAOFEA
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UNILAB"."STARTAPAOFEA" IS
--------------------------------------------------------------------------------
--  PROJECT : Vredestein Enschede
-------------------------------------------------------------------------------
--  PACKAGE : StartAPAOFEA
-- ABSTRACT :
--   WRITER : Atos, Jan Roubos
--     DATE :
--   TARGET : -
--  VERSION : -
--------------------------------------------------------------------------------
--  REMARKS :
--------------------------------------------------------------------------------
--  CHANGES :
--
--  When      | Who       | What
--============|===========|=====================================================
-- 01/07/2015 | JR        | Created
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := 'StartAPAOFEA';
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
        l_job := 'UNI_J_FEA';
        DBMS_SCHEDULER.CREATE_JOB(
                        job_name          =>  l_job,
                        job_class            => 'UNI_JC_OTHER_JOBS',
                        job_type          =>  'PLSQL_BLOCK',
                        job_action        =>  'DECLARE r NUMBER; BEGIN r:= APAOFEA.ExecuteMeshing(); END;',
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

END StartAPAOFEA;

/

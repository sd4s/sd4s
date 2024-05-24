--------------------------------------------------------
--  File created - dinsdag-oktober-27-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure STARTWATSONINTERFACE
--------------------------------------------------------
set define off;

CREATE OR REPLACE PROCEDURE "UNILAB"."STARTWATSONINTERFACE" IS
--------------------------------------------------------------------------------
--  PROJECT : Vredestein Enschede
-------------------------------------------------------------------------------
--  PACKAGE : StartWatsonInterface
-- ABSTRACT :
--   WRITER : Jacco vd Broek
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
-- 07/09/2015 | JB        | Created
-- 31-03-2022 | PS        | Change START-DATE to current-date if time < 21:00 hr
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := 'StartWatsonInterface';
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- functions- and/or procedures-declarations
--------------------------------------------------------------------------------
  l_job varchar2(30);
begin
  l_job := 'UNI_J_WATSON';
  --
  --indien sysdate van restart-job voor 21:00 uur dan zelfde dag, anders volgende dag
  if sysdate < ( trunc(sysdate) + 21 / 24 )
  then
    dbms_scheduler.create_job
    (job_name        => l_job
    ,job_class       => 'UNI_JC_OTHER_JOBS'
    ,job_type        => 'PLSQL_BLOCK'
    ,job_action      => 'begin apao_watson.import_files(p_test => false); end;'
    ,start_date      =>  trunc(sysdate) + 21 / 24 
    ,repeat_interval => unapiev.sqltranslatedjobinterval(1, 'days')
    ,enabled         => true);
  else
    dbms_scheduler.create_job
    (job_name        => l_job
    ,job_class       => 'UNI_JC_OTHER_JOBS'
    ,job_type        => 'PLSQL_BLOCK'
    ,job_action      => 'begin apao_watson.import_files(p_test => false); end;'
    ,start_date      =>  trunc(sysdate) + 21 / 24 + 1
    ,repeat_interval => unapiev.sqltranslatedjobinterval(1, 'days')
    ,enabled         => true);
  end if;
  --  
  dbms_scheduler.set_attribute 
    (name            => l_job
    ,attribute       => 'restartable'
    ,value           => true);
  --
end startwatsoninterface; 
/

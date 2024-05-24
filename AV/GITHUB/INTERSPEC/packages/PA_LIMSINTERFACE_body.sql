---------------------------------------------------------------------------
-- $Workfile: PA_LIMSInterface.sql $
--      Type: Package Body
--   $Author: Fe $
--            COMPEX N.V.
----------------------------------------------------------------------------
--  Abstract: Functions and procedures for the interface between Interspec 
--            and Unilab.
--
--            REMARK 1: Do not use 'SELECT *' to select from an Unilab table, 
--            but always specify the column names. If they are not specified,
--            errors can occur when the column order of a table differs on
--            the Unilab databases.
--
--            REMARK 2: Do not directly use an Unilab api in a 'SELECT'- or 
--            'WHERE'-clause of a query in an Interspec package. If the packages
--            have public synonyms, and if the link connects to another Unilab
--            database as before the re-creation, this kind of Unilab api call
--            invalidates the Interspec packages.
--            The only mechanism that does not invalidate the packages, is to
--            create an Unilab view that uses the Unilab api.  
--
--            REMARK 3: Do not select from Unilab tables, but from Unilab views.
--            This is necessary since every user can be used in the 
--            database link.
--
--            REMARK 4: When both databases are unicode (CHARACTER_SET = AL32UTF8, 
--            NLS_LENGTH_SEMANTICS = CHAR), then watch out with selecting data of
--            datatype CHAR through the link. A column of type CHAR(1) at Unilab
--            side, becomes CHAR(4) at Interspec side. You have to SUBSTR
--            explicitely before assigning the value to a local variable.
--            For more info, cfr. Oracle bugs 2928548, and 2749304.
--            E.g. the selects from uvpppr_pr_specx, uvstpp_pp_specx.
----------------------------------------------------------------------------
-- Functions:
-- 1.  p_TransferCfgAndSpc
-- 2.  f_StartInterface
-- 3.  f_StopInterface
-- 4.  f_TransferAllHistObs
-- 5.  f_GetIUIVersion
----------------------------------------------------------------------------
-- Versions:
-- speCX ver  Date         Author          Description
-- ---------  -----------  --------------  ---------------------------------
-- 2.2.0      01/12/2000   CL              New release
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- 2.2.0      11/07/2001   CL              Bug: The planned effective date
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- 2.3.0      15/07/2001   CL              Release 2.3.0
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- 2.3.1     ....
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- 2.4.1      09/12/2002   JB              New job: historic/obsolete specs
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- 5.0        20/08/2003   RF              Release 5.0
--                                         Since Unilab 5.0 SP2 can handle versions, 
--                                         effective_dates, and multiple plants, a new design has been
--                                         made ("RFD0309021-DS DB API Interspec-Unilab interface.doc"
--                                         in the Unilab 5.0 SP2 URS folder). Please check this 
--                                         design for more detailed information of the modifications.
----------------------------------------------------------------------------



CREATE OR REPLACE PACKAGE BODY 
----------------------------------------------------------------------------
-- $Revision: 4 $
--  $Modtime: 10/05/10 22:45 $
----------------------------------------------------------------------------
PA_LIMSINTERFACE IS
   
   FUNCTION f_GetIUIVersion
      RETURN VARCHAR2
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Get the version of the Interspec-Unilab interface
      -- ** Return **
      -- The version of the Interspec-Unilab interface
      ------------------------------------------------------------------------------
      -- General variables
   BEGIN
      RETURN('06.04.00.00_00.00');
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 
                       'Unable to get the version of the Interspec-Unilab interface : '||SQLERRM);
         RETURN (NULL);
   END f_GetIUIVersion;

   PROCEDURE p_TransferCfgAndSpc
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- The procedure is executed by the database jobs which transfers
      -- the specx configuration and specification data to the
      -- Unilab database
      ------------------------------------------------------------------------------
      -- General variables
      ln_result   NUMBER;
      lb_result1  BOOLEAN;
      lb_result2  BOOLEAN;
      lb_result3  BOOLEAN;
      -- Constant variables for the tracing
      l_classname       CONSTANT VARCHAR2(14) := 'LimsInterface';
      l_method          CONSTANT VARCHAR2(32) := 'p_TransferCfgAndSpc';
      
   BEGIN
   
      --perform a SetConnection
      -- A SetConnection is required starting from Interspec 6.1,
      -- dynamic sql is used to be able to compile this package on Interspec 5.x database.
      IF SUBSTR(PA_LIMS.f_GetInterspecVersion,1,1) <> '5' THEN
         BEGIN
            EXECUTE IMMEDIATE 'DECLARE l_ret_code INTEGER; BEGIN :l_ret_code := iapiGeneral.SetConnection(:a_user, ''IUINTERFACE''); END;'
            USING IN OUT ln_result, IN USER;
            IF ln_result <> 0 THEN
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 'SetConnection failed, retrned error'||TO_CHAR(ln_result));
            END IF;
         EXCEPTION
         WHEN OTHERS THEN            
            PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 'SetConnection failed:'||SUBSTR(SQLERRM,1,100));
         END;
      END IF;
      
      LOOP
         PA_LIMS.g_RestartACompleteTransfer := FALSE;

         --Mark the records as "in transfer" to avoid the problem of transferring a specifications
         --for which the configuration has not been transferred yet
         PA_LIMS.p_Trace(l_classname, l_method, '', '', '', 'Turned flags (itlimsjob.to_be_transferred and to_be_updated) to 2 to mark the records to be transferred');
         UPDATE itlimsjob
         SET to_be_transferred = DECODE(to_be_transferred,'1','2',to_be_transferred),
             to_be_updated = DECODE(to_be_updated,'1','2',to_be_updated);
         --we commit at this point since the last update statement did lock all records of itlimsjob
         COMMIT;
          
         --Reset the event buffer to be suer to start from a clean event buffer
         PA_LIMS.g_evbuff_nr_of_rows := 0;
          
         -- Transfer the configuration
         ln_result := 0;
         ln_result := PA_LIMSCFG.f_TransferAllCfgInternal;
         IF ln_result = 0 THEN
            PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 'Unable to transfer the configuration');
         END IF;

         -- Transfer the specifications;
         lb_result1 := PA_LIMSSPC.f_TransferAllSpc;
         IF NOT lb_result1 THEN
            PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 'Unable to transfer the specifications');
         END IF;

         IF PA_LIMS.g_RestartACompleteTransfer THEN
            --this variable can be set in PA_LIMSSPC.f_TransferAllSpc to relaunch a complete transfer
            --when the user modified the priorities in such a way that a complete transfer is necessary
            lb_result2 := FALSE;
            PA_LIMS.p_Trace(l_classname, l_method, '', '', '', 'PA_LIMS.g_RestartACompleteTransfer set to TRUE after f_TransferAllSpc!');
         ELSE
            --Transfer the update of the specifications;
            lb_result2 := PA_LIMSSPC.f_TransferUpdateAllSpc;
            IF NOT lb_result2 THEN
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 'Unable to transfer the update of the specifications');
            END IF;
            IF PA_LIMS.g_RestartACompleteTransfer THEN
               --this variable cen be set in PA_LIMSSPC.f_TransferAllSpc to relaunch a complete transfert
               --when the user modified the priorities in such a way that a complete transfert is necessary
               lb_result2 := FALSE;
               PA_LIMS.p_Trace(l_classname, l_method, '', '', '', 'PA_LIMS.g_RestartACompleteTransfer set to TRUE after f_TransferUpdateAllSpc!');
            END IF;
        END IF;

         --reset all 2 flags back
         IF NOT PA_LIMS.g_RestartACompleteTransfer THEN
            --Send an event to all specifications that have been transferred for the first time to indicate that the transfer is totally completed
            lb_result3 := PA_LIMS.f_SendTransferFinishedEvents();       
            IF NOT lb_result3 THEN
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 'Unable to send the events for the specifications');
            END IF;

            IF (ln_result = 0) OR (lb_result1 = FALSE) OR (lb_result2 = FALSE) OR (lb_result3 = FALSE) THEN
               PA_LIMS.p_Trace(l_classname, l_method, '', '', '', 'Turned flags (itlimsjob.to_be_transferred and to_be_updated) back from 2 to 1 to clean the records to be transferred');
               UPDATE itlimsjob
               SET to_be_transferred = DECODE(to_be_transferred,'2','1',to_be_transferred),
                   to_be_updated = DECODE(to_be_updated,'2','1',to_be_updated);
               --we commit at this point since the last update statement did lock all records of itlimsjob
               COMMIT;
            ELSE
               PA_LIMS.p_Trace(l_classname, l_method, '', '', '', 'Turned flags (itlimsjob.to_be_transferred and to_be_updated) back from 2 to 1 to clean the records to be transferred');
               UPDATE itlimsjob
               SET to_be_transferred = DECODE(to_be_transferred,'2','0',to_be_transferred),
                   to_be_updated = DECODE(to_be_updated,'2','0',to_be_updated);
               --we commit at this point since the last update statement did lock all records of itlimsjob
               COMMIT;
            END IF;
         END IF;
         EXIT WHEN PA_LIMS.g_RestartACompleteTransfer = FALSE;
      END LOOP;
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unexpected error when transferring the configuration and specification data to Unilab: '||
                       SQLERRM);
         BEGIN
            --reset all 2 flags back
            PA_LIMS.p_Trace(l_classname, l_method, '', '', '', 'Turned flags (itlimsjob.to_be_transferred and to_be_updated) back from 2 to 1 to clean the records to be transferred');
            UPDATE itlimsjob
            SET to_be_transferred = DECODE(to_be_transferred,'2','1',to_be_transferred),
                to_be_updated = DECODE(to_be_updated,'2','1',to_be_updated);
            --we commit at this point since the last update statement did lock all records of itlimsjob
            COMMIT;
         EXCEPTION
         WHEN OTHERS THEN
            NULL;
         END;
   END p_TransferCfgAndSpc;

   PROCEDURE f_TransferAllHistObs
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- The procedure is executed by the database jobs which transfers
      -- the historic/obsolete specifications to the
      -- unilab database
      ------------------------------------------------------------------------------
   BEGIN
      -- Transfer the historic/obsolete specifications;
      PA_LIMSSPC.f_TransferAllHistObs;
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unexpected error when transferring the historic/obsolete specifications to Unilab: '||SQLERRM);
   END f_TransferAllHistObs;

   FUNCTION f_StartInterface
      RETURN NUMBER
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- The procedure starts the database jobs:
      --    1) the job which transfers the Interspec configuration and specification 
      --       data to the Unilab database
      --    2) the job which transfers the historic and obsolete specifications 
      --       to the Unilab database
      --    3) the job for error logging
      ------------------------------------------------------------------------------
      -- General variables
      l_jobnr        NUMBER;
      l_jobnr_h      NUMBER;
      lvb_created    BOOLEAN DEFAULT FALSE;

      -- Cursor to get the job p_TransferCfgAndSpc
      CURSOR l_dba_jobs_cursor
      IS
         SELECT JOB
           FROM DBA_JOBS
          WHERE WHAT = 'pa_limsinterface.p_transfercfgandspc;';

      -- Cursor to get the job f_TransferAllHistObs
      CURSOR l_dba_jobs_h_cursor
      IS
         SELECT JOB
           FROM DBA_JOBS
          WHERE WHAT = 'pa_limsspc.f_transferallhistobs;';
   BEGIN
      -------------------
      -- error logging --       
      -------------------
      -- Since the mechanism for errorlogging has been changed from Interspec 6.1 on,
      -- the job does not exist there anymore. 
      IF SUBSTR(PA_LIMS.f_GetInterspecVersion,1,1) = '5' THEN
         -- Create the job for the error logging
         EXECUTE IMMEDIATE 'BEGIN PA_ITERROR.p_StartErrorLogging; END;';
      END IF;

      ----------------------
      -- Normal interface --
      ----------------------
      -- check if record exists
      FOR l_dba_jobs_rec IN l_dba_jobs_cursor LOOP
         -- don't create job two times
         lvb_created := TRUE;
      END LOOP;

      IF NOT lvb_created THEN
         -- create the job for the Error_logging
         DBMS_JOB.SUBMIT(l_jobnr, 'pa_limsinterface.p_transfercfgandspc;', SYSDATE, 'SYSDATE + 1/2');
         COMMIT;
      END IF;

      ---------------------------------
      -- Historic/Obsolete interface --
      ---------------------------------
      -- check if record exists
      FOR l_dba_jobs_h_rec IN l_dba_jobs_h_cursor LOOP
         -- don't create job two times
         RETURN (0);
      END LOOP;

      -- create the job for the Error_logging
      DBMS_JOB.SUBMIT(l_jobnr_h, 'pa_limsspc.f_transferallhistobs;', SYSDATE, 'SYSDATE + 5/(24*60)');
      COMMIT;

      RETURN (1);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unexpected error when starting the database job for the interface: '||SQLERRM);
         RETURN (0);
   END f_StartInterface;

   FUNCTION f_StopInterface
      RETURN NUMBER
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- The procedure stops the database jobs:
      --    1) the job which transfers the Interspec configuration and specification 
      --       data to the Unilab database
      --    2) the job which transfers the historic and obsolete specifications 
      --       to the Unilab database
      --    3) the job for error logging
      ------------------------------------------------------------------------------
      -- Cursor to get the job p_TransferCfgAndSpc
      CURSOR l_dba_jobs_cursor
      IS
         SELECT JOB
           FROM DBA_JOBS
          WHERE WHAT = 'pa_limsinterface.p_transfercfgandspc;';

      -- Cursor to get the job f_TransferAllHistObs
      CURSOR l_dba_jobs_h_cursor
      IS
         SELECT JOB
           FROM DBA_JOBS
          WHERE WHAT = 'pa_limsspc.f_transferallhistobs;';
   BEGIN
      ----------------------
      -- Normal interface --
      ----------------------
      -- Remove the job for the database logging if it exists
      FOR l_dba_jobs_rec IN l_dba_jobs_cursor LOOP
         DBMS_JOB.REMOVE(l_dba_jobs_rec.job);
         COMMIT;
      END LOOP;
      
      ---------------------------------
      -- Historic/Obsolete interface --
      ---------------------------------
      -- Remove the job for the database logging if it exists
      FOR l_dba_jobs_h_rec IN l_dba_jobs_h_cursor LOOP
         DBMS_JOB.REMOVE(l_dba_jobs_h_rec.job);
         COMMIT;
      END LOOP;

      -------------------
      -- error logging --       
      -------------------
      -- Since the mechanism for errorlogging has been changed from Interspec 6.1 on,
      -- the job does not exist there anymore. 
      IF SUBSTR(PA_LIMS.f_GetInterspecVersion,1,1) = '5' THEN
         -- Remove the job for the error logging if it exists
         EXECUTE IMMEDIATE 'BEGIN PA_ITERROR.p_StopErrorLogging; END;';
      END IF;

      RETURN (1);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unexpected error when stopping the database job for the interface: '||SQLERRM);
         RETURN (0);
   END f_StopInterface;
END PA_LIMSINTERFACE;
/

create or replace PACKAGE
----------------------------------------------------------------------------
-- $Revision: 2 $
--  $Modtime: 27/05/10 12:54 $
----------------------------------------------------------------------------
PA_LIMSINTERFACE IS

   PROCEDURE p_TransferCfgAndSpc;

   FUNCTION f_StartInterface
      RETURN NUMBER;

   FUNCTION f_StopInterface
      RETURN NUMBER;

   PROCEDURE f_TransferAllHistObs;

   FUNCTION f_GetIUIVersion
      RETURN VARCHAR2;
END PA_LIMSINTERFACE;
 
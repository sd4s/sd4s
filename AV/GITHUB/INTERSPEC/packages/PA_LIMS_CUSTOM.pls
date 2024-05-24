create or replace PACKAGE
----------------------------------------------------------------------------
-- $Revision: 1 $
--  $Modtime: 23/04/10 16:06 $
----------------------------------------------------------------------------
PA_LIMS_CUSTOM IS

   -- PUBLIC FUNCTIONS AND PROCEDURES
   PROCEDURE p_InitObsoleteCascade(
      a_part_no     IN VARCHAR2,
      a_plant       IN VARCHAR2
   );

   PROCEDURE p_PerformObsoleteCascade;

   FUNCTION f_GetHighestMajorVersion
   (a_object_tp IN VARCHAR2,
    a_object_id IN VARCHAR2)
   RETURN VARCHAR2;

END PA_LIMS_CUSTOM;
 
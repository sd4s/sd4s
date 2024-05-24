--------------------------------------------------------
--  DDL for Package Body PA_LIMS_CUSTOM
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "INTERSPC"."PA_LIMS_CUSTOM" IS

   -- PRIVATE PACKAGE VARIABLES
   P_PART_NO      VARCHAR2(18);
   P_PLANT        VARCHAR2(8);
   P_TRIGGER_BUSY BOOLEAN DEFAULT FALSE;

   -- INTERNAL FUNCTIONS AND PROCEDURES

   -- PUBLIC FUNCTIONS AND PROCEDURES
   PROCEDURE p_InitObsoleteCascade(
      a_part_no     IN VARCHAR2,
      a_plant       IN VARCHAR2
   )
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- The 2 procedures p_InitObsoleteCascade and p_PerformObsoleteCascade
      -- are working together to cascade the obsoletion of a generic spec
      -- to its attached spec
      -- see also the 2 triggers: TR_LIMS_OBSOLETECASCADESTEP1 and TR_LIMS_OBSOLETECASCADESTEP2
      --
      -- An index should be created to increase the performance of the query performed
      -- on attached_specification
      --
      -- ** Note **
      -- Avoiding the mutating trigger exception in Oracle
      -- cache values in package variables in after statement trigger for each record
      -- perform required update in after statement trigger
      --
      -- This is a classical trick used by all Oracle progemmer in order to avoid the
      -- mutating trigger exception
      ------------------------------------------------------------------------------
   BEGIN
      -- Initialize variables
      P_PART_NO := a_part_no;
      P_PLANT := a_plant;
   END p_InitObsoleteCascade;

   PROCEDURE p_PerformObsoleteCascade
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Avoiding the mutating trigger exception in Oracle
      --
      -- assumption: there is no attachment cascade
      --             spec1 attached to spec2 and spec2 attached to spec3
      ------------------------------------------------------------------------------
   BEGIN
      IF P_TRIGGER_BUSY = FALSE THEN
         IF P_PART_NO IS NOT NULL AND P_PLANT IS NOT NULL THEN
            P_TRIGGER_BUSY := TRUE;
            UPDATE part_plant
               SET obsolete = '1'
               WHERE (part_no, plant) NOT IN ((P_PART_NO, P_PLANT))
                 AND plant = P_PLANT
                 AND (part_no) IN
                        (SELECT DISTINCT part_no
                         FROM attached_specification
                         WHERE attached_part_no = P_PART_NO);
                         --a specific index on attached_specification.attached_part_no is necessary
                         --to avoid a full table scan on attached_specification
            P_TRIGGER_BUSY := FALSE;
         END IF;
      END IF;
   EXCEPTION
   WHEN OTHERS THEN
      P_TRIGGER_BUSY := TRUE;
      RAISE;
   END p_PerformObsoleteCascade;

   FUNCTION f_GetHighestMajorVersion
   (a_object_tp IN VARCHAR2,
    a_object_id IN VARCHAR2)
   RETURN VARCHAR2 IS
   l_highest_major_version       VARCHAR2(20);
   BEGIN
      --This function was necesssary to return the real highest major version with '.00' as minor version digits
      --This function has been put in a customisable package
      --Projects that are not using the standard UNVRESION package (e.g: major version numbers on 5 digits instead of 4)
      --will be able to customize this function also and use the interface
      l_highest_major_version := UNVERSION.SQLGetHighestMajorVersion@LNK_LIMS(a_object_tp, a_object_id, '');
      IF INSTR(l_highest_major_version, '.')<>0 THEN
         RETURN(SUBSTR(l_highest_major_version,1,INSTR(l_highest_major_version, '.'))||'00');
      ELSE
         RETURN(l_highest_major_version);
      END IF;
   END f_GetHighestMajorVersion;

END PA_LIMS_CUSTOM;

/

create or replace PACKAGE iapiJobLogging
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiJobLogging.h $
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract:
   --           This package contains all
   --           functionality to handle job logging
   --
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   FUNCTION GetPackageVersion
      RETURN iapiType.String_Type;

   ---------------------------------------------------------------------------
   -- $NoKeywords: $
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   -- Member variables
   ---------------------------------------------------------------------------
   gsSource                      iapiType.Source_Type := 'iapiJobLogging';

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   FUNCTION DeleteJob(
      anJobId                    IN       iapiType.NumVal_Type )
      RETURN iapiType.ErrorNum_type;

   ---------------------------------------------------------------------------
   FUNCTION EndJob(
      anJobId                    IN       iapiType.NumVal_Type )
      RETURN iapiType.ErrorNum_type;

   ---------------------------------------------------------------------------
   FUNCTION StartJob(
      asJobDescription           IN       iapiType.Description_Type,
      anJobId                    OUT      iapiType.NumVal_Type )
      RETURN iapiType.ErrorNum_type;

   ---------------------------------------------------------------------------
   FUNCTION UpdateJob(
      anJobId                    IN       iapiType.NumVal_Type,
      asJobDescription           IN       iapiType.Description_Type )
      RETURN iapiType.ErrorNum_type;
---------------------------------------------------------------------------
-- Pragmas
---------------------------------------------------------------------------
END iapiJobLogging;
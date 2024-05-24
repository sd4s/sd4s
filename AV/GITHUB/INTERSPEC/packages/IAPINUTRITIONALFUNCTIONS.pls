create or replace PACKAGE iapiNutritionalFunctions
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiNutritionalFunctions.h $
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract:
   --           This package contains all nutritional
   --           functions
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
   gsSource                      iapiType.Source_Type := 'iapiNutritionalFunctions';

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   FUNCTION GetComments(
      asNutRefType               IN       iapiType.NutRefType_Type,
      anUniqueID                 IN       iapiType.Sequence_Type,
      anMopSequenceNo            IN       iapiType.Sequence_Type,
      anRowID                    IN       iapiType.Sequence_Type,
      anLayoutID                 IN       iapiType.Sequence_Type,
      anlayoutRevision           IN       iapiType.Revision_Type,
      anColID                    IN       iapiType.Sequence_Type,
      asOutVal                   OUT      iapiType.Clob_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetContributedKCalCalculated(
      asNutRefType               IN       iapiType.NutRefType_Type,
      anUniqueID                 IN       iapiType.Sequence_Type,
      anMopSequenceNo            IN       iapiType.Sequence_Type,
      anRowID                    IN       iapiType.Sequence_Type,
      anLayoutID                 IN       iapiType.Sequence_Type,
      anlayoutRevision           IN       iapiType.Revision_Type,
      anColID                    IN       iapiType.Sequence_Type,
      asOutVal                   OUT      iapiType.Clob_Type )
      RETURN iapiType.ErrorNum_Type;

--AP01058317 --AP01054597
   ---------------------------------------------------------------------------
   FUNCTION GetContributedKCalCalculatedRV(
      asNutRefType               IN       iapiType.NutRefType_Type,
      anRowID                    IN       iapiType.Sequence_Type,
      anColID                    IN       iapiType.Sequence_Type,
      anLogID                    IN       iapiType.LogId_Type,
      asOutVal                   OUT      iapiType.Clob_Type )
      RETURN iapiType.ErrorNum_Type;
--AP01058317 --AP01054597

   ---------------------------------------------------------------------------
   FUNCTION GetContributedKjCalculated(
      asNutRefType               IN       iapiType.NutRefType_Type,
      anUniqueID                 IN       iapiType.Sequence_Type,
      anMopSequenceNo            IN       iapiType.Sequence_Type,
      anRowID                    IN       iapiType.Sequence_Type,
      anLayoutID                 IN       iapiType.Sequence_Type,
      anlayoutRevision           IN       iapiType.Revision_Type,
      anColID                    IN       iapiType.Sequence_Type,
      asOutVal                   OUT      iapiType.Clob_Type )
      RETURN iapiType.ErrorNum_Type;

--AP01058317 --AP01054597
   ---------------------------------------------------------------------------
   FUNCTION GetContributedKjCalculatedRV(
      asNutRefType               IN       iapiType.NutRefType_Type,
      anRowID                    IN       iapiType.Sequence_Type,
      anColID                    IN       iapiType.Sequence_Type,
      anLogID                    IN       iapiType.LogId_Type,
      asOutVal                   OUT      iapiType.Clob_Type )
      RETURN iapiType.ErrorNum_Type;
--AP01058317 --AP01054597

   FUNCTION GetNutrient(
      asNutRefType               IN       iapiType.NutRefType_Type,
      anUniqueID                 IN       iapiType.Sequence_Type,
      anMopSequenceNo            IN       iapiType.Sequence_Type,
      anRowID                    IN       iapiType.Sequence_Type,
      anLayoutID                 IN       iapiType.Sequence_Type,
      anlayoutRevision           IN       iapiType.Revision_Type,
      anColID                    IN       iapiType.Sequence_Type,
      asOutVal                   OUT      iapiType.Clob_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION getPercentRDAUnRounded(
      asNutRefType               IN       iapiType.NutRefType_Type,
      anUniqueID                 IN       iapiType.Sequence_Type,
      anMopSequenceNo            IN       iapiType.Sequence_Type,
      anRowID                    IN       iapiType.Sequence_Type,
      anLayoutID                 IN       iapiType.Sequence_Type,
      anlayoutRevision           IN       iapiType.Revision_Type,
      anColID                    IN       iapiType.Sequence_Type,
      asOutVal                   OUT      iapiType.Clob_Type )
      RETURN iapiType.ErrorNum_Type;

--AP01058317 --AP01054597
   ---------------------------------------------------------------------------
   FUNCTION getPercentRDAUnRoundedRV(
      asNutRefType               IN       iapiType.NutRefType_Type,
      anRowID                    IN       iapiType.Sequence_Type,
      anColID                    IN       iapiType.Sequence_Type,
      anLogId                    IN       iapiType.LogId_Type,
      asOutVal                   OUT      iapiType.Clob_Type )
      RETURN iapiType.ErrorNum_Type;
--AP01058317 --AP01054597

   ---------------------------------------------------------------------------
   FUNCTION GetPercentRDACalculated(
      asNutRefType               IN       iapiType.NutRefType_Type,
      anUniqueID                 IN       iapiType.Sequence_Type,
      anMopSequenceNo            IN       iapiType.Sequence_Type,
      anRowID                    IN       iapiType.Sequence_Type,
      anLayoutID                 IN       iapiType.Sequence_Type,
      anlayoutRevision           IN       iapiType.Revision_Type,
      anColID                    IN       iapiType.Sequence_Type,
      asOutVal                   OUT      iapiType.Clob_Type )
      RETURN iapiType.ErrorNum_Type;

--AP01058317 --AP01054597
   ---------------------------------------------------------------------------
   FUNCTION GetPercentRDACalculatedRV(
      asNutRefType               IN       iapiType.NutRefType_Type,
      anRowID                    IN       iapiType.Sequence_Type,
      anColID                    IN       iapiType.Sequence_Type,
      anLogId                    IN       iapiType.LogId_Type,
      asOutVal                   OUT      iapiType.Clob_Type )
      RETURN iapiType.ErrorNum_Type;
--AP01058317 --AP01054597

--AP01058317 --AP01054597
   FUNCTION getPercentRDARV(
      asNutRefType               IN       iapiType.NutRefType_Type,
      anRowID                    IN       iapiType.Sequence_Type,
      anColID                    IN       iapiType.Sequence_Type,
      anLogId                    IN       iapiType.LogId_Type,
      anOutVal                   OUT      iapiType.NumVal_Type )
      RETURN iapiType.ErrorNum_Type;
--AP01058317 --AP01054597
   ---------------------------------------------------------------------------
   FUNCTION GetRDA(
      asNutRefType               IN       iapiType.NutRefType_Type,
      anUniqueID                 IN       iapiType.Sequence_Type,
      anMopSequenceNo            IN       iapiType.Sequence_Type,
      anRowID                    IN       iapiType.Sequence_Type,
      anLayoutID                 IN       iapiType.Sequence_Type,
      anlayoutRevision           IN       iapiType.Revision_Type,
      anColID                    IN       iapiType.Sequence_Type,
      asOutVal                   OUT      iapiType.Clob_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetUoM(
      asNutRefType               IN       iapiType.NutRefType_Type,
      anUniqueID                 IN       iapiType.Sequence_Type,
      anMopSequenceNo            IN       iapiType.Sequence_Type,
      anRowID                    IN       iapiType.Sequence_Type,
      anLayoutID                 IN       iapiType.Sequence_Type,
      anlayoutRevision           IN       iapiType.Revision_Type,
      anColID                    IN       iapiType.Sequence_Type,
      asOutVal                   OUT      iapiType.Clob_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetValueUnRounded(
      asNutRefType               IN       iapiType.NutRefType_Type,
      anUniqueID                 IN       iapiType.Sequence_Type,
      anMopSequenceNo            IN       iapiType.Sequence_Type,
      anRowID                    IN       iapiType.Sequence_Type,
      anLayoutID                 IN       iapiType.Sequence_Type,
      anlayoutRevision           IN       iapiType.Revision_Type,
      anColID                    IN       iapiType.Sequence_Type,
      asOutVal                   OUT      iapiType.Clob_Type )
      RETURN iapiType.ErrorNum_Type;

--AP01058317 --AP01054597
   ---------------------------------------------------------------------------
   FUNCTION GetValueUnRoundedRV(
      asNutRefType               IN       iapiType.NutRefType_Type,
      anRowID                    IN       iapiType.Sequence_Type,
      anColID                    IN       iapiType.Sequence_Type,
      anLogId                    IN       iapiType.LogId_Type,
      asOutVal                   OUT      iapiType.Clob_Type )
      RETURN iapiType.ErrorNum_Type;
--AP01058317 --AP01054597

   ---------------------------------------------------------------------------
   FUNCTION GetValueCalculated(
      asNutRefType               IN       iapiType.NutRefType_Type,
      anUniqueID                 IN       iapiType.Sequence_Type,
      anMopSequenceNo            IN       iapiType.Sequence_Type,
      anRowID                    IN       iapiType.Sequence_Type,
      anLayoutID                 IN       iapiType.Sequence_Type,
      anlayoutRevision           IN       iapiType.Revision_Type,
      anColID                    IN       iapiType.Sequence_Type,
      asOutVal                   OUT      iapiType.Clob_Type )
      RETURN iapiType.ErrorNum_Type;
--AP01058317 --AP01054597
   ---------------------------------------------------------------------------
   FUNCTION GetValueCalculatedRV(
      asNutRefType               IN       iapiType.NutRefType_Type,
      anRowID                    IN       iapiType.Sequence_Type,
      anColID                    IN       iapiType.Sequence_Type,
      anLogId                    IN       iapiType.LogId_Type,
      asOutVal                   OUT      iapiType.Clob_Type )
      RETURN iapiType.ErrorNum_Type;
--AP01058317 --AP01054597


-- Pragmas
---------------------------------------------------------------------------
END iapiNutritionalFunctions;
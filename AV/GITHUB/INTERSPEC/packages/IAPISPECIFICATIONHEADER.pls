create or replace PACKAGE iapiSpecificationHeader
IS
   ---------------------------------------------------------------------------
   --  Abstract: This package contains all general functionality to maintain a specification header.
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   FUNCTION GetPackageVersion
      RETURN iapiType.String_Type;

   ---------------------------------------------------------------------------
   -- Member variables
   ---------------------------------------------------------------------------
   gsSource                      iapiType.Source_Type := 'iapiSpecificationHeader';

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   --IS641 - TC_Cleaning
   --FUNCTION DecreaseTCInProgress(
   --   asPartNo                   IN       iapiType.PartNo_Type,
   --   anRevision                 IN       iapiType.Revision_Type )
   --   RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetHeaderItems(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      aqHeaderItems              OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetSpecificationsInProgress(
      aqSpecs                    OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   --IS641 - TC_Cleaning
   --FUNCTION IncreaseTCInProgress(
   --   asPartNo                   IN       iapiType.PartNo_Type,
   --   anRevision                 IN       iapiType.Revision_Type )
   --   RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   --IS641 - TC_Cleaning
   --FUNCTION SetTCInProgress(
   --   asPartNo                   IN       iapiType.PartNo_Type,
   --   anRevision                 IN       iapiType.Revision_Type,
   --   anTCInProgress             IN       iapiType.NumVal_Type )
   --   RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   --IS641 - TC_Cleaning
   --FUNCTION SpecificationSentToTCOk(
   --   asPartNo                   IN       iapiType.PartNo_Type,
   --   anRevision                 IN       iapiType.Revision_Type )
   --   RETURN iapiType.ErrorNum_Type;
---------------------------------------------------------------------------
-- Pragmas
---------------------------------------------------------------------------
END iapiSpecificationHeader;
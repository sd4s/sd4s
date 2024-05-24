create or replace PACKAGE iapiObject
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiObject.h $
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract:
   --           This package contains all
   --           functionality to handle Objects
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
   gsSource                      iapiType.Source_Type := 'iapiObject';
   gtErrors                      ErrorDataTable_Type := ErrorDataTable_Type( );

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   FUNCTION AddKeyword(
      anObjectId                 IN       iapiType.Id_Type,
      anOwner                    IN       iapiType.Owner_Type,
      anKeywordId                IN       iapiType.Id_Type,
      asValue                    IN       iapiType.KeywordValue_Type DEFAULT '<Any>',
      anInternational            IN       iapiType.Intl_Type DEFAULT 0,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION CheckPhantom(
      anRefId                    IN       iapiType.Id_Type,
      anRefVer                   IN       iapiType.ReferenceVersion_Type,
      anOwner                    IN       iapiType.Owner_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION CheckUsed(
      anRefId                    IN       iapiType.Id_Type,
      anRefVer                   IN       iapiType.ReferenceVersion_Type,
      anOwner                    IN       iapiType.Owner_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION CopyNextRevision(
      anRefId                    IN       iapiType.Id_Type,
      anOwner                    IN       iapiType.Owner_Type,
      anRefRevNext               OUT      iapiType.ReferenceVersion_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION DeleteObject(
      anRefId                    IN       iapiType.Id_Type,
      anRefVer                   IN       iapiType.ReferenceVersion_Type,
      anOwner                    IN       iapiType.Owner_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ExistId(
      anObjectId                 IN       iapiType.Id_Type,
      anOwner                    IN       iapiType.Owner_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetKeywords(
      anObjectId                 IN       iapiType.Id_Type,
      anOwner                    IN       iapiType.Owner_Type,
      aqKeywords                 OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetNextRevision(
      anRefId                    IN       iapiType.Id_Type,
      anOwner                    IN       iapiType.Owner_Type,
      anRevNumber                OUT      iapiType.ReferenceVersion_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ifValidate(
      asShortDescription         IN       iapiType.ShortDescription_Type,
      asDescription              IN       iapiType.ReferenceTextTypeDescr_Type,
      asFileName                 IN       iapiType.FileName_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ifValidateDescription(
      asDescription              IN       iapiType.ReferenceTextTypeDescr_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ifValidateFileName(
      asFileName                 IN       iapiType.FileName_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION IfValidateShortDescription(
      asShortDescription         IN       iapiType.ShortDescription_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION RemoveKeyword(
      anObjectId                 IN       iapiType.Id_Type,
      anOwner                    IN       iapiType.Owner_Type,
      anKeywordId                IN       iapiType.Id_Type,
      asValue                    IN       iapiType.KeywordValue_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SetHistoric(
      anRefId                    IN       iapiType.Id_Type,
      anRefVer                   IN       iapiType.ReferenceVersion_Type,
      anOwner                    IN       iapiType.Owner_Type )
      RETURN iapiType.ErrorNum_Type;
---------------------------------------------------------------------------
-- Pragmas
---------------------------------------------------------------------------
END iapiObject;
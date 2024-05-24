create or replace PACKAGE iapiWebRequest
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiWebRequest.h $
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract:
   --
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
   gsSource                      iapiType.Source_Type := 'iapiWebRequest';

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   FUNCTION AddRequest(
      asPassword                 IN       iapiType.String_Type,
      asPartNo                   IN       iapiType.PartNo_Type DEFAULT NULL,
      anRevision                 IN       iapiType.Revision_Type DEFAULT NULL,
      anUomType                  IN       iapiType.Boolean_Type DEFAULT NULL,
      anLanguageId               IN       iapiType.LanguageId_Type DEFAULT NULL,
      asApplicationLanguageId    IN       iapiType.GuiLanguage_Type DEFAULT NULL,
      --R-0004ba46-591
      anRuleSetId                IN       iapiType.Sequence_Type DEFAULT 0,
      --AP01202202 - evoVaLa3 - begin
      anInternationalMode        IN       iapiType.Boolean_Type DEFAULT NULL,
      --AP01202202 - evoVaLa3 - end
      anId                       OUT      iapiType.Id_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetRequestDetails(
      anId                       IN       iapiType.Id_Type,
      aqRequestDetails           OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION RemoveRequest(
      anId                       IN       iapiType.Id_Type )
      RETURN iapiType.ErrorNum_Type;
---------------------------------------------------------------------------
-- Pragmas
---------------------------------------------------------------------------
END iapiWebRequest;
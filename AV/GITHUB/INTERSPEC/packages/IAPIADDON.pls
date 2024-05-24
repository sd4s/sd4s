create or replace PACKAGE iapiAddOn
IS
   ---------------------------------------------------------------------------
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract: This package contains functions to create a request for an addon
   --
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   FUNCTION GetPackageVersion
      RETURN iapiType.String_Type;

   ---------------------------------------------------------------------------
   -- $NoKeywords: $
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   -- Member variables
   ---------------------------------------------------------------------------
   gsSource                      iapiType.Source_Type := 'iapiAddOn';

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   FUNCTION AddRequest(
      asUserId                   IN       iapiType.UserId_Type,
      anLanguageId               IN       iapiType.LanguageId_Type,
      anMetric                   IN       iapiType.MetricId_Type,
      anAddonId                  IN       iapiType.Id_Type,
      anNextAddonId              IN       iapiType.Id_Type,
      asCulture                  IN       iapiType.Culture_Type,
      asGuiLanguage              IN       iapiType.GuiLanguage_Type,
      anRequestId                OUT      iapiType.Id_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION AddRequestArguments(
      anRequestId                IN       iapiType.Id_Type,
      asArgument                 IN       iapiType.Description_Type,
      asValue                    IN       iapiType.Description_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetAddOn(
      anAddonId                  IN       iapiType.Id_Type,
      anAccessType               IN       iapiType.AddOnAccess_Type,
      aqAddOn                    OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetAddOns(
      anTypeId                   IN       iapiType.Id_Type,
      anAccessType               IN       iapiType.AddOnAccess_Type,
      aqAddOns                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetArguments(
      anAddonId                  IN       iapiType.Id_Type,
      aqArguments                OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetAssembly(
      asAssembly                 IN       iapiType.String_Type,
      anAccessType               IN       iapiType.AddOnAccess_Type,
      aqAddOn                    OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetDefaultArguments(
      anAddonId                  IN       iapiType.Id_Type,
      aqDefaultArguments         OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetRequest(
      anRequestId                IN       iapiType.Id_Type,
      aqRequestDetails           OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetRequestArguments(
      anRequestId                IN       iapiType.Id_Type,
      aqRequestArguments         OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetTypes(
      aqAddOnTypes               OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION RemoveRequest(
      anRequestId                IN       iapiType.Id_Type )
      RETURN iapiType.ErrorNum_Type;
---------------------------------------------------------------------------
-- Pragmas
---------------------------------------------------------------------------
END iapiAddOn;
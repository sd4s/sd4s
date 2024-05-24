create or replace PACKAGE iapiProperty
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiProperty.h $
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract:
   --           This package contains all
   --           functionality to handle properties
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
   gsSource                      iapiType.Source_Type := 'iapiProperty';

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------

   FUNCTION CreateFilter(
      anFilterId                 IN OUT   iapiType.FilterId_Type,
      anArray                    IN       iapiType.NumVal_Type,
      asPropertyGroup            IN       iapiType.String_Type,
      asSingleProperty           IN       iapiType.String_Type,
      asAttribute                IN       iapiType.String_Type,
      asTestMethod               IN       iapiType.String_Type,
      asUOM                      IN       iapiType.String_Type,
      asHeader                   IN       iapiType.String_Type,
      asPropertyGroupSingleProperty IN    iapiType.String_Type,
      asDataType                 IN       iapiType.String_Type,
      asOperator                 IN       iapiType.String_Type,
      asValue1                   IN       iapiType.String_Type,
      asValue2                   IN       iapiType.String_Type,
      --IS605 --oneLine
      asAndOr                    IN       iapiType.String_Type,
      asSortDesc                 IN       iapiType.ShortDescription_Type,
      asComment                  IN       iapiType.FilterDescription_Type,
      anOverwrite                IN       iapiType.Boolean_Type )
      RETURN Iapitype.ErrorNum_Type;
   ---------------------------------------------------------------------------
   FUNCTION CreateFilter(
      anFilterId                 IN OUT   iapiType.FilterId_Type,
      anArray                    IN       iapiType.NumVal_Type,
      axPropertyGroup            IN       iapiType.XmlType_Type,
      axSingleProperty           IN       iapiType.XmlType_Type,
      axAttribute                IN       iapiType.XmlType_Type,
      axTestMethod               IN       iapiType.XmlType_Type,
      axUOM                      IN       iapiType.XmlType_Type,
      axHeader                   IN       iapiType.XmlType_Type,
      axPropertyGroupSingleProperty IN    iapiType.XmlType_Type,
      axDataType                 IN       iapiType.XmlType_Type,
      axOperator                 IN       iapiType.XmlType_Type,
      axValue1                   IN       iapiType.XmlType_Type,
      axValue2                   IN       iapiType.XmlType_Type,
      --IS605 --oneLine
      axAndOr                    IN       iapiType.XmlType_Type,
      asSortDesc                 IN       iapiType.ShortDescription_Type,
      asComment                  IN       iapiType.FilterDescription_Type,
      anOverwrite                IN       iapiType.Boolean_Type )
      RETURN Iapitype.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION CreateFilter(
      anFilterId                 IN OUT   iapiType.FilterId_Type,
      anArray                    IN       iapiType.NumVal_Type,
      atPropertyGroup            IN       iapiType.NumberTab_Type,
      atSingleProperty           IN       iapiType.NumberTab_Type,
      atAttribute                IN       iapiType.NumberTab_Type,
      atTestMethod               IN       iapiType.NumberTab_Type,
      atUOM                      IN       iapiType.NumberTab_Type,
      atHeader                   IN       iapiType.NumberTab_Type,
      atPropertyGroupSingleProperty IN    iapiType.NumberTab_Type,
      atDataType                 IN       iapiType.NumberTab_Type,
      atOperator                 IN       iapiType.CharTab_Type,
      atValue1                   IN       iapiType.CharTab_Type,
      atValue2                   IN       iapiType.CharTab_Type,
      --IS605 --oneLine
      atAndOr                    IN       iapiType.CharTab_Type,
      asSortDesc                 IN       iapiType.ShortDescription_Type,
      asComment                  IN       iapiType.FilterDescription_Type,
      anOverwrite                IN       iapiType.Boolean_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ExistProperty(
      anProperty                 IN       iapiType.Id_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ExistProperty(
      anPropertyId               IN       iapiType.ID_Type,
      anPropertyRevision         IN       iapiType.Revision_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetProperties(
      atDefaultFilter            IN       iapiType.FilterTab_Type,
      aqProperties               OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetPropertyId(
      asPropertyDesc             IN       iapiType.Description_Type,
      anPropertyId               OUT      iapiType.Id_Type )
      RETURN iapiType.ErrorNum_Type;
---------------------------------------------------------------------------
-- Pragmas
---------------------------------------------------------------------------
END iapiProperty;
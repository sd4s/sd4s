create or replace PACKAGE iapiSpecificationPropertyGroup
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiSpecificationPropertyGroup.h $
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract:
   --           This package contains all
   --           functionality to maintain property groups of a
   --           specification. Also single properties
   --           will be handled in this package; a
   --           single property is in fact a property group
   --           with only one property.
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
   gsSource                      iapiType.Source_Type := 'iapiSpecificationPropertyGroup';
   gtPropertyGroups              iapiType.SpPropertyGroupTab_Type;
   gtProperties                  iapiType.SpPropertyTab_Type;
   gtErrors                      ErrorDataTable_Type := ErrorDataTable_Type( );
   gtGetProperties               SpPropertyTable_Type := SpPropertyTable_Type( );
   gtInfo                        iapiType.InfoTab_Type;
   gtTestMethods                 iapiType.SpTestMethodTab_Type;

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   FUNCTION AddProperty(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anPropertyGroupId          IN       iapiType.Id_Type,
      anPropertyId               IN       iapiType.Id_Type,
      anAttributeId              IN       iapiType.Id_Type,
      afHandle                   IN       iapiType.Float_Type DEFAULT NULL,
      --AP01100443 --AP01020557 Start
      --aqInfo                     OUT      iapiType.Ref_Type, --orig
      --aqErrors                   OUT      iapiType.Ref_Type ) --orig
      aqInfo                     IN OUT      iapiType.Ref_Type,
      aqErrors                   IN OUT      iapiType.Ref_Type )
      --AP01100443 --AP01020557 End
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION AddPropertyGroup(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anItemId                   IN       iapiType.Id_Type,
      anSingleProperty           IN       iapiType.Boolean_Type DEFAULT 0,
      afHandle                   IN       iapiType.Float_Type DEFAULT NULL,
      --AP01100443 --AP01020557 Start
      --aqInfo                     OUT      iapiType.Ref_Type,  --orig
      --aqErrors                   OUT      iapiType.Ref_Type ) --orig
      aqInfo                     IN OUT      iapiType.Ref_Type,
      aqErrors                   IN OUT      iapiType.Ref_Type )
      --AP01100443 --AP01020557 End
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION AddTestMethod(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anPropertyGroupId          IN       iapiType.Id_Type,
      anPropertyId               IN       iapiType.Id_Type,
      anAttributeId              IN       iapiType.Id_Type,
      anSequenceNo               IN       iapiType.SequenceNr_Type,
      anTestMethodTypeId         IN       iapiType.Id_Type,
      anTestMethodId             IN       iapiType.Id_Type,
      anTestMethodRevision       IN       iapiType.Revision_Type,
      anTestMethodSetNo          IN       iapiType.TestMethodSetNo_Type,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ConvertNumericValue(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      afValue                    IN       iapiType.Float_Type,
      anUomId                    IN       iapiType.Id_Type,
      anAlternativeUomId         IN       iapiType.Id_Type )
      RETURN iapiType.Float_Type;

   ---------------------------------------------------------------------------
   FUNCTION ExtendProperty(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anPropertyGroupId          IN       iapiType.Id_Type,
      anPropertyId               IN       iapiType.Id_Type,
      anAttributeId              IN       iapiType.Id_Type,
      anUomId                    IN       iapiType.Id_Type DEFAULT NULL,
      anAssociationId1           IN       iapiType.Id_Type DEFAULT NULL,
      anAssociationId2           IN       iapiType.Id_Type DEFAULT NULL,
      anAssociationId3           IN       iapiType.Id_Type DEFAULT NULL,
      anDisplayFormatId          IN       iapiType.Id_Type DEFAULT NULL,
      afHandle                   IN       iapiType.Float_Type DEFAULT NULL,
      anPropertySequenceNumber   OUT      iapiType.PropertySequenceNumber_Type,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ExtendPropertyGroup(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anItemId                   IN       iapiType.Id_Type,
      anDisplayFormatId          IN       iapiType.Id_Type,
      anSingleProperty           IN       iapiType.Boolean_Type DEFAULT 0,
      anAttributeId              IN       iapiType.Id_Type DEFAULT NULL,
      afHandle                   IN       iapiType.Float_Type DEFAULT NULL,
      anSectionSequenceNumber    OUT      iapiType.SpSectionSequenceNumber_Type,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ExtendPropertyGroupPb(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anItemId                   IN       iapiType.Id_Type,
      anDisplayFormatId          IN       iapiType.Id_Type,
      anSingleProperty           IN       iapiType.Boolean_Type DEFAULT 0,
      anAttributeId              IN       iapiType.Id_Type DEFAULT NULL,
      afHandle                   IN       iapiType.Float_Type DEFAULT NULL,
      aqSectionSequenceNumber    OUT      iapiType.Ref_Type,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ExtendPropertyPb(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anPropertyGroupId          IN       iapiType.Id_Type,
      anPropertyId               IN       iapiType.Id_Type,
      anAttributeId              IN       iapiType.Id_Type,
      anUomId                    IN       iapiType.Id_Type DEFAULT NULL,
      anAssociationId1           IN       iapiType.Id_Type DEFAULT NULL,
      anAssociationId2           IN       iapiType.Id_Type DEFAULT NULL,
      anAssociationId3           IN       iapiType.Id_Type DEFAULT NULL,
      anDisplayFormatId          IN       iapiType.Id_Type DEFAULT NULL,
      afHandle                   IN       iapiType.Float_Type DEFAULT NULL,
      aqPropertySequenceNumber   OUT      iapiType.Ref_Type,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetNumericPGHeaders(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anPropertyGroup            IN       iapiType.Id_Type,
      aqNumPGHeaders             OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetProperties(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type DEFAULT NULL,
      anSubSectionId             IN       iapiType.Id_Type DEFAULT NULL,
      anItemId                   IN       iapiType.Id_Type DEFAULT NULL,
      anIncludedOnly             IN       iapiType.Boolean_Type DEFAULT 1,
      anSingleProperty           IN       iapiType.Boolean_Type DEFAULT 0,
      anAlternativeLanguageId    IN       iapiType.LanguageId_Type DEFAULT NULL,
      aqProperties               OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetPropertyGroups(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type DEFAULT NULL,
      anSubSectionId             IN       iapiType.Id_Type DEFAULT NULL,
      anIncludedOnly             IN       iapitype.boolean_type DEFAULT 1,
      aqPropertyGroups           OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetUomDescription(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anUomId                    IN       iapiType.Id_Type,
      anUomRevision              IN       iapiType.Revision_Type,
      anAlternativeUomId         IN       iapiType.Id_Type,
      --AP01004814 --AP01004807 Start
      --anAlternativeUomRevision   IN       iapiType.Revision_Type ) --orig
      anAlternativeUomRevision   IN       iapiType.Revision_Type,
      anAccess                   IN       iapiType.Boolean_Type DEFAULT NULL )
      --AP01004814 --AP01004807 End
      RETURN iapiType.Description_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetUomId_AltUomId(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anUomId                    IN       iapiType.Id_Type,
      anUomRevision              IN       iapiType.Revision_Type,
      anAlternativeUomId         IN       iapiType.Id_Type,
      --AP01004814 --AP01004807 Start
      --anAlternativeUomRevision   IN       iapiType.Revision_Type ) --orig
      anAlternativeUomRevision   IN       iapiType.Revision_Type,
      anAccess                   IN       iapiType.Boolean_Type DEFAULT NULL )
      --AP01004814 --AP01004807 End
      RETURN iapiType.Id_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetUomRevision_AltUomRevision(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anUomId                    IN       iapiType.Id_Type,
      anUomRevision              IN       iapiType.Revision_Type,
      anAlternativeUomId         IN       iapiType.Id_Type,
      --AP01004814 --AP01004807 Start
      --anAlternativeUomRevision   IN       iapiType.Revision_Type ) --orig
      anAlternativeUomRevision   IN       iapiType.Revision_Type,
      anAccess                   IN       iapiType.Boolean_Type DEFAULT NULL )
      --AP01004814 --AP01004807 End
      RETURN iapiType.Revision_Type;

---------------------------------------------------------------------------
   FUNCTION IsExtendable(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anItemId                   IN       iapiType.Id_Type,
      asType                     IN       iapiType.SpecificationSectionType_Type )
      RETURN iapiType.Boolean_Type;

---------------------------------------------------------------------------
   FUNCTION IsItemExtended(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anType                     IN       iapiType.SpecificationSectionType_Type,
      anRefId                    IN       iapiType.Id_Type,
      anPropertyGroupId          IN       iapiType.Id_Type,
      anPropertyId               IN       iapiType.Id_Type,
      anAttributeId              IN       iapiType.Id_Type )
      RETURN iapiType.Boolean_Type;

---------------------------------------------------------------------------
   FUNCTION RemoveProperty(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anPropertyGroupId          IN       iapiType.Id_Type,
      anPropertyId               IN       iapiType.Id_Type,
      anAttributeId              IN       iapiType.Id_Type,
      afHandle                   IN       iapiType.Float_Type DEFAULT NULL,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION RemovePropertyGroup(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anItemId                   IN       iapiType.Id_Type,
      anSingleProperty           IN       iapiType.Boolean_Type DEFAULT 0,
      afHandle                   IN       iapiType.Float_Type DEFAULT NULL,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION RemoveTestMethod(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anPropertyGroupId          IN       iapiType.Id_Type,
      anPropertyId               IN       iapiType.Id_Type,
      anAttributeId              IN       iapiType.Id_Type,
      anSequenceNo               IN       iapiType.SequenceNr_Type,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SaveAddProperty(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anPropertyGroupId          IN       iapiType.Id_Type,
      anPropertyId               IN       iapiType.Id_Type,
      anAttributeId              IN       iapiType.Id_Type,
      anHeaderId                 IN       iapiType.Id_Type,
      asValue                    IN       iapiType.Info_Type,
      anAlternativeLanguageId    IN       iapiType.LanguageId_Type DEFAULT NULL,
      --AP01100443 --AP01020557 Start
      --aqInfo                     OUT      iapiType.Ref_Type,  --orig
      --aqErrors                   OUT      iapiType.Ref_Type ) --orig
      aqInfo                     IN OUT      iapiType.Ref_Type,
      aqErrors                   IN OUT      iapiType.Ref_Type )
      --AP01100443 --AP01020557 End
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SaveProperty(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anPropertyGroupId          IN       iapiType.Id_Type,
      anPropertyId               IN       iapiType.Id_Type,
      anAttributeId              IN       iapiType.Id_Type,
      anTestMethodId             IN       iapiType.Id_Type,
      anTestMethodSetNo          IN       iapiType.TestMethodSetNo_Type,
      afNumeric1                 IN       iapiType.Float_Type,
      afNumeric2                 IN       iapiType.Float_Type,
      afNumeric3                 IN       iapiType.Float_Type,
      afNumeric4                 IN       iapiType.Float_Type,
      afNumeric5                 IN       iapiType.Float_Type,
      afNumeric6                 IN       iapiType.Float_Type,
      afNumeric7                 IN       iapiType.Float_Type,
      afNumeric8                 IN       iapiType.Float_Type,
      afNumeric9                 IN       iapiType.Float_Type,
      afNumeric10                IN       iapiType.Float_Type,
      asString1                  IN       iapiType.PropertyShortString_Type,
      asString2                  IN       iapiType.PropertyShortString_Type,
      asString3                  IN       iapiType.PropertyShortString_Type,
      asString4                  IN       iapiType.PropertyShortString_Type,
      asString5                  IN       iapiType.PropertyShortString_Type,
      asString6                  IN       iapiType.PropertyLongString_Type,
      asInfo                     IN       iapiType.Info_Type,
      anBoolean1                 IN       iapiType.Boolean_Type,
      anBoolean2                 IN       iapiType.Boolean_Type,
      anBoolean3                 IN       iapiType.Boolean_Type,
      anBoolean4                 IN       iapiType.Boolean_Type,
      adDate1                    IN       iapiType.Date_Type,
      adDate2                    IN       iapiType.Date_Type,
      anCharacteristicId1        IN       iapiType.Id_Type,
      anCharacteristicId2        IN       iapiType.Id_Type,
      anCharacteristicId3        IN       iapiType.Id_Type,
      anTestMethodDetails1       IN       iapiType.Boolean_Type,
      anTestMethodDetails2       IN       iapiType.Boolean_Type,
      anTestMethodDetails3       IN       iapiType.Boolean_Type,
      anTestMethodDetails4       IN       iapiType.Boolean_Type,
      anAlternativeLanguageId    IN       iapiType.LanguageId_Type DEFAULT NULL,
      asAlternativeString1       IN       iapiType.PropertyShortString_Type DEFAULT NULL,
      asAlternativeString2       IN       iapiType.PropertyShortString_Type DEFAULT NULL,
      asAlternativeString3       IN       iapiType.PropertyShortString_Type DEFAULT NULL,
      asAlternativeString4       IN       iapiType.PropertyShortString_Type DEFAULT NULL,
      asAlternativeString5       IN       iapiType.PropertyShortString_Type DEFAULT NULL,
      asAlternativeString6       IN       iapiType.PropertyLongString_Type DEFAULT NULL,
      asAlternativeInfo          IN       iapiType.Info_Type DEFAULT NULL,
      afHandle                   IN       iapiType.Float_Type DEFAULT NULL,
      --AP01100443 --AP01020557 Start
      --aqInfo                     OUT      iapiType.Ref_Type, --orig
      --aqErrors                   OUT      iapiType.Ref_Type ) --orig
      aqInfo                     IN OUT      iapiType.Ref_Type,
      aqErrors                   IN OUT      iapiType.Ref_Type )
      --AP01100443 --AP01020557 End
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SavePropertyGroup(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anItemId                   IN       iapiType.Id_Type,
      anAction                   IN       iapiType.NumVal_Type,
      afHandle                   IN       iapiType.Float_Type DEFAULT NULL,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SaveTestMethod(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anPropertyGroupId          IN       iapiType.Id_Type,
      anPropertyId               IN       iapiType.Id_Type,
      anAttributeId              IN       iapiType.Id_Type,
      anSequenceNo               IN       iapiType.SequenceNr_Type,
      anTestMethodTypeId         IN       iapiType.Id_Type,
      anTestMethodId             IN       iapiType.Id_Type,
      anTestMethodRevision       IN       iapiType.Revision_Type,
      anTestMethodSetNo          IN       iapiType.TestMethodSetNo_Type,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;
---------------------------------------------------------------------------
-- Pragmas
---------------------------------------------------------------------------
END iapiSpecificationPropertyGroup;
create or replace PACKAGE aapiSpecificationPropertyGroup
IS
   FUNCTION GetPropertyValue(
      asPartNo            IN   iapiType.PartNo_Type,
      anRevision          IN   iapiType.Revision_Type,
      anSectionId         IN   iapiType.Id_Type,
      anSubSectionId      IN   iapiType.Id_Type,
      anPropertyGroupId   IN   iapiType.Id_Type,
      anPropertyId        IN   iapiType.Id_Type,
      anAttributeId       IN   iapiType.Id_Type,
      anHeaderId          IN   iapiType.Id_Type,
      anLanguageId        IN   iapiType.LanguageId_Type DEFAULT 1)
      RETURN iapiType.PropertyLongString_Type;

   FUNCTION GetPropertyValueByHeader(
      arProperty   IN   iapiType.SpPropertyRec_Type,
      anHeaderId   IN   iapiType.Id_Type)
      RETURN iapiType.PropertyLongString_Type;

   FUNCTION GetPropertyValueByField(
      arProperty   IN   iapiType.SpPropertyRec_Type,
      anFieldId    IN   iapiType.Id_Type)
      RETURN iapiType.PropertyLongString_Type;
END aapiSpecificationPropertyGroup;
 
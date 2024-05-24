create or replace PACKAGE aapiDisplayFormat
IS
   FUNCTION GetFieldMatchingHeader(
      asPartNo         IN       iapiType.PartNo_Type,
      anRevision       IN       iapiType.Revision_Type,
      anSectionId      IN       iapiType.Id_Type,
      anSubSectionId   IN       iapiType.Id_Type,
      anItemId         IN       iapiType.Id_Type,
      anHeaderId       IN       iapiType.Id_Type,
      anFieldId        OUT      iapiType.Id_Type)
      RETURN iapiType.ErrorNum_Type;

   FUNCTION GetHeaderMatchingField(
      asPartNo         IN       iapiType.PartNo_Type,
      anRevision       IN       iapiType.Revision_Type,
      anSectionId      IN       iapiType.Id_Type,
      anSubSectionId   IN       iapiType.Id_Type,
      anItemId         IN       iapiType.Id_Type,
      anFieldId        IN       iapiType.Id_Type,
      anHeaderId       OUT      iapiType.Id_Type)
      RETURN iapiType.ErrorNum_Type;

   FUNCTION GetHeaderMatchingFieldFrame(
      asPartNo         IN       iapiType.PartNo_Type,
      anRevision       IN       iapiType.Revision_Type,
      anSectionId      IN       iapiType.Id_Type,
      anSubSectionId   IN       iapiType.Id_Type,
      anItemId         IN       iapiType.Id_Type,
      anFieldId        IN       iapiType.Id_Type,
      anHeaderId       OUT      iapiType.Id_Type)
      RETURN iapiType.ErrorNum_Type;
END aapiDisplayFormat;
 
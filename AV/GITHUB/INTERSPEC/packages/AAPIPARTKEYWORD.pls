create or replace PACKAGE aapiPartKeyword
AS
   psSource   CONSTANT iapiType.Source_Type := 'aapiPartKeyword';

   FUNCTION GetKeywordValue(asPartNo IN iapiType.PartNo_Type, anKeywordId IN iapiType.Id_Type)
      RETURN iapiType.Description_Type;

   FUNCTION SetKeywordValue(
      asPartNo         IN   iapiType.PartNo_Type,
      anKeywordId      IN   iapiType.Id_Type,
      asKeywordValue   IN   iapiType.Description_Type)
      RETURN iapiType.ErrorNum_Type;
END aapiPartKeyword;
 
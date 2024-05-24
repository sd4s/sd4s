create or replace PACKAGE iapiMop
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiMop.h $
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract:
   --           Multi Operation List functionality
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
   gsSource                      iapiType.Source_Type := 'iapiMop';

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   FUNCTION AddSpecification(
      asUserId                   IN       iapiType.UserId_Type,
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetAttributes(
      anPropertyId               IN       iapiType.Id_Type,
      asDescriptionLike          IN       iapiType.Description_Type DEFAULT NULL,
      aqAttributes               OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetAvailablePlantInBom(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asBomItem                  IN       iapiType.PartNo_Type,
      asPlantNoLike              IN       iapiType.Description_Type DEFAULT NULL,
      aqAvailablePlantInBom      OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetAvailablePlantInBomMop(
      asUserId                   IN       iapiType.UserId_Type,
      asBomItem                  IN       iapiType.PartNo_Type,
      aqAvailablePlantInBomMop   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetHeaders(
      anLayoutType               IN       iapiType.Id_Type,
      anPropertyId               IN       iapiType.Id_Type,
      asDescriptionLike          IN       iapiType.Description_Type DEFAULT NULL,
      aqHeaders                  OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetJobLog(
      asUserId                   IN       iapiType.UserId_Type,
      adLogDate                  IN       iapiType.Date_Type,
      aqList                     OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetJobStatus(
      asUserId                   IN       iapiType.UserId_Type,
      aqList                     OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetList(
      asUserId                   IN       iapiType.UserId_Type,
      aqList                     OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetPartInBomList(
      asUserId                   IN       iapiType.UserId_Type,
      asPartNo                   IN       iapiType.PartNo_Type,
      aqList                     OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetPartsWithBom(
      asUserId                   IN       iapiType.UserId_Type,
      aqList                     OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetPlantLineConfigurations(
      asDescriptionLike          IN       iapiType.Description_Type DEFAULT NULL,
      aqPlantLineConfigurations  OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetProcessData(
      asUserId                   IN       iapiType.UserId_Type,
      anFieldType                IN       iapiType.NumVal_Type,
      asPlantNo                  IN       iapiType.PlantNo_Type,
      asLine                     IN       iapiType.Line_Type,
      anConfiguration            IN       iapiType.Configuration_Type,
      anStageId                  IN       iapiType.StageId_Type,
      anPropertyId               IN       iapiType.Id_Type,
      anAttributeId              IN       iapiType.Id_Type,
      anHeaderId                 IN       iapiType.Id_Type,
      aqProcessData              OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetProperties(
      anPropertyGroupId          IN       iapiType.Id_Type,
      asDescriptionLike          IN       iapiType.Description_Type DEFAULT NULL,
      aqProperties               OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetSectionData(
      asUserId                   IN       iapiType.UserId_Type,
      anFieldType                IN       iapiType.NumVal_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anPropertyGroupId          IN       iapiType.Id_Type,
      anPropertyId               IN       iapiType.Id_Type,
      anAttributeId              IN       iapiType.Id_Type,
      anHeaderId                 IN       iapiType.Id_Type,
      aqSectionData              OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetStageProperties(
      anStageId                  IN       iapiType.StageId_Type,
      asDescriptionLike          IN       iapiType.Description_Type DEFAULT NULL,
      aqProperties               OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetStages(
      asPlantNo                  IN       iapiType.PlantNo_Type,
      asLine                     IN       iapiType.Line_Type,
      anConfiguration            IN       iapiType.Configuration_Type,
      asDescriptionLike          IN       iapiType.Description_Type DEFAULT NULL,
      aqStages                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetUsedPlantInBom(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asBomItem                  IN       iapiType.PartNo_Type,
      asPlantNoLike              IN       iapiType.Description_Type DEFAULT NULL,
      aqUsedPlantInBom           OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetUsedPlantInBomMop(
      asUserId                   IN       iapiType.UserId_Type,
      asBomItem                  IN       iapiType.PartNo_Type,
      aqUsedPlantInBomMop        OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetUsedPropertyGroups(
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      asDescriptionLike          IN       iapiType.Description_Type DEFAULT NULL,
      aqUsedPropertyGroups       OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetUsedSubSections(
      anSectionId                IN       iapiType.Id_Type,
      asDescriptionLike          IN       iapiType.Description_Type DEFAULT NULL,
      aqUsedSubSections          OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION IsMopRunning(
      anIsRunning                OUT      iapiType.Boolean_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION RemoveAll(
      asUserId                   IN       iapiType.UserId_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION RemoveSpecification(
      asUserId                   IN       iapiType.UserId_Type,
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type )
      RETURN iapiType.ErrorNum_Type;

--AP00925448 Start
   ---------------------------------------------------------------------------
   FUNCTION SaveSpecification(
      asUserId                   IN       iapiType.UserId_Type,
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSelected                 IN       iapiType.Boolean_Type)
      RETURN iapiType.ErrorNum_Type;
--AP00925448 End

--AP00925448 Start
   ---------------------------------------------------------------------------
   FUNCTION SaveSpecifications(
      asUserId                   IN       iapiType.UserId_Type)
      RETURN iapiType.ErrorNum_Type;
--AP00925448 End

   ---------------------------------------------------------------------------
   FUNCTION StartJob
      RETURN iapiType.ErrorNum_type;

   ---------------------------------------------------------------------------
   FUNCTION StopJob
      RETURN iapiType.ErrorNum_type;

   ---------------------------------------------------------------------------
   FUNCTION UpdateProgress(
      asUserId                   IN       iapiType.UserId_Type,
      anProgress                 IN       iapiType.MopProgress_Type,
      asStatus                   IN       iapiType.MopStatus_Type DEFAULT NULL )
      RETURN iapiType.ErrorNum_Type;
---------------------------------------------------------------------------
-- Pragmas
---------------------------------------------------------------------------
END iapiMop;
create or replace PACKAGE iapiSpecificationProcessData
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiSpecificationProcessData.h $
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract:
   --           This package contains all
   --           functionality to maintain process data of a
   --           specification.
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
   gsSource                      iapiType.Source_Type := 'iapiSpecificationProcessData';
   gtErrors                      ErrorDataTable_Type := ErrorDataTable_Type( );
   gtSpPdLines                   iapiType.SpPdLineTab_Type;
   gtSpPdStages                  iapiType.SpPdStageTab_Type;
   gtSpPdStageData               iapiType.SpPdStageDataTab_Type;
   gtGetPdLines                  SpPdLineTable_Type := SpPdLineTable_Type( );
   gtGetPdStages                 SpPdStageTable_Type := SpPdStageTable_Type( );
   gtGetPdStageData              SpPdStageDataTable_Type := SpPdStageDataTable_Type( );
   gtGetStageData                iapiType.GetStageDataTab_Type;
   gtGetPdStageFreeTexts         SpPdStageFreeTextTable_Type := SpPdStageFreeTextTable_Type( );
   gtPrLines                     iapiType.PrLineTab_Type;
   gtGetPrLines                  PrLineTable_Type := PrLineTable_Type( );
   gtInfo                        iapiType.InfoTab_Type;

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   FUNCTION AddLine(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPlantNo                  IN       iapiType.PlantNo_Type,
      asLine                     IN       iapiType.Line_Type,
      anConfiguration            IN       iapiType.Configuration_Type,
      asUsePart                  IN       iapiType.PartNo_Type DEFAULT NULL,
      anUsePartRevision          IN       iapiType.Revision_Type DEFAULT NULL,
      anSequence                 IN       iapiType.SequenceNr_Type,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION AddStage(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPlantNo                  IN       iapiType.PlantNo_Type,
      asLine                     IN       iapiType.Line_Type,
      anConfiguration            IN       iapiType.Configuration_Type,
      anStageId                  IN       iapiType.StageId_Type,
      anStageSequence            IN       iapiType.StageSequence_Type,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION AddStageDataBomItem(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPlantNo                  IN       iapiType.PlantNo_Type,
      asLine                     IN       iapiType.Line_Type,
      anConfiguration            IN       iapiType.Configuration_Type,
      anStageId                  IN       iapiType.StageId_Type,
      anSequence                 IN       iapiType.LinePropSequence_Type,
      asComponentPart            IN       iapiType.PartNo_Type,
      --AP00978864 --AP00978035 Start
      --afQuantity                 IN       iapiType.Quantity_Type, --orig
      afQuantity                 IN       iapiType.BomQuantity_Type,
      --AP00978864 --AP00978035 End
      asUom                      IN       iapiType.BaseUom_Type,
      anAlternative              IN       iapiType.BomAlternative_Type,
      anBomUsage                 IN       iapiType.BomUsage_Type,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION AddStageDataProperty(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPlantNo                  IN       iapiType.PlantNo_Type,
      asLine                     IN       iapiType.Line_Type,
      anConfiguration            IN       iapiType.Configuration_Type,
      anStageId                  IN       iapiType.StageId_Type,
      anPropertyId               IN       iapiType.Id_Type,
      anAttributeId              IN       iapiType.Id_Type,
      anUomId                    IN       iapiType.Id_Type,
      anTestMethod               IN       iapiType.Id_Type,
      anSequence                 IN       iapiType.LinePropSequence_Type,
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
      asBoolean1                 IN       iapiType.Boolean_Type,
      asBoolean2                 IN       iapiType.Boolean_Type,
      asBoolean3                 IN       iapiType.Boolean_Type,
      asBoolean4                 IN       iapiType.Boolean_Type,
      adDate1                    IN       iapiType.Date_Type,
      adDate2                    IN       iapiType.Date_Type,
      anCharacteristicId1        IN       iapiType.Id_Type,
      anAlternativeLanguageId    IN       iapiType.LanguageId_Type DEFAULT NULL,
      asAlternativeString1       IN       iapiType.PropertyShortString_Type DEFAULT NULL,
      asAlternativeString2       IN       iapiType.PropertyShortString_Type DEFAULT NULL,
      asAlternativeString3       IN       iapiType.PropertyShortString_Type DEFAULT NULL,
      asAlternativeString4       IN       iapiType.PropertyShortString_Type DEFAULT NULL,
      asAlternativeString5       IN       iapiType.PropertyShortString_Type DEFAULT NULL,
      asAlternativeString6       IN       iapiType.PropertyLongString_Type DEFAULT NULL,
      --AP01329469 --oneLine
      anAssociationId            IN       iapiType.Id_Type DEFAULT NULL,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION AddStageDataText(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPlantNo                  IN       iapiType.PlantNo_Type,
      asLine                     IN       iapiType.Line_Type,
      anConfiguration            IN       iapiType.Configuration_Type,
      anStageId                  IN       iapiType.StageId_Type,
      anSequence                 IN       iapiType.LinePropSequence_Type,
      asText                     IN       iapiType.String_Type,
      anAlternativeLanguageId    IN       iapiType.LanguageId_Type DEFAULT NULL,
      asAlternativeText          IN       iapiType.String_Type DEFAULT NULL,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION CopyData(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPlantNoFrom              IN       iapiType.PlantNo_Type,
      asLineFrom                 IN       iapiType.Line_Type,
      anConfigurationFrom        IN       iapiType.Configuration_Type,
      asPlantNoTo                IN       iapiType.PlantNo_Type,
      asLineTo                   IN       iapiType.Line_Type,
      anConfigurationTo          IN       iapiType.Configuration_Type,
      anSequenceTo               IN       iapiType.Sequence_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ExistSecProcessData(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                OUT      iapiType.Id_Type,
      anSubSectionId             OUT      iapiType.Id_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetAvailableLines(
      asPartNo                   IN       iapiType.PartNo_Type,
      aqLines                    OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_type;

   ---------------------------------------------------------------------------
   FUNCTION GetAvailableStages(
      asPlant                    IN       iapiType.Plant_Type,
      asLine                     IN       iapiType.Line_Type,
      anConfiguration            IN       iapiType.Configuration_Type,
      aqStages                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_type;

   ---------------------------------------------------------------------------
   FUNCTION GetBomItems(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPlant                    IN       iapiType.Plant_Type,
      aqBomItems                 OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetLines(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      aqLines                    OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_type;

   ---------------------------------------------------------------------------
   FUNCTION GetStageData(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPlantNo                  IN       iapiType.PlantNo_Type DEFAULT NULL,
      asLine                     IN       iapiType.Line_Type DEFAULT NULL,
      anConfiguration            IN       iapiType.Configuration_Type DEFAULT NULL,
      anStageId                  IN       iapiType.StageId_Type DEFAULT NULL,
      anAlternativeLanguageId    IN       iapiType.LanguageId_Type DEFAULT NULL,
      aqStageData                OUT      iapiType.Ref_Type,
      aqStageFreeText            OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_type;

   ---------------------------------------------------------------------------
   FUNCTION GetStages(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPlantNo                  IN       iapiType.PlantNo_Type DEFAULT NULL,
      asLine                     IN       iapiType.Line_Type DEFAULT NULL,
      anConfiguration            IN       iapiType.Configuration_Type DEFAULT NULL,
      aqStages                   OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_type;

   ---------------------------------------------------------------------------
   FUNCTION GetUseSpecifications(
      asPlantNo                  IN       iapiType.PlantNo_Type,
      atDefaultFilter            IN       iapiType.FilterTab_Type,
      aqSpecifications           OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetUseSpecifications(
      asPlantNo                  IN       iapiType.PlantNo_Type,
      axDefaultFilter            IN       iapiType.XmlType_Type,
      aqSpecifications           OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION RemoveLine(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPlantNo                  IN       iapiType.PlantNo_Type,
      asLine                     IN       iapiType.Line_Type,
      anConfiguration            IN       iapiType.Configuration_Type,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION RemoveStage(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPlantNo                  IN       iapiType.PlantNo_Type,
      asLine                     IN       iapiType.Line_Type,
      anConfiguration            IN       iapiType.Configuration_Type,
      anStageId                  IN       iapiType.StageId_Type,
      anStageSequence            IN       iapiType.StageSequence_Type,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION RemoveStageData(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPlantNo                  IN       iapiType.PlantNo_Type,
      asLine                     IN       iapiType.Line_Type,
      anConfiguration            IN       iapiType.Configuration_Type,
      anStageId                  IN       iapiType.StageId_Type,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION RemoveStageDataItem(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPlantNo                  IN       iapiType.PlantNo_Type,
      asLine                     IN       iapiType.Line_Type,
      anConfiguration            IN       iapiType.Configuration_Type,
      anStageId                  IN       iapiType.StageId_Type,
      anSequence                 IN       iapiType.LinePropSequence_Type,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SaveLine(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPlantNo                  IN       iapiType.PlantNo_Type,
      asLine                     IN       iapiType.Line_Type,
      anConfiguration            IN       iapiType.Configuration_Type,
      asUsePart                  IN       iapiType.PartNo_Type DEFAULT NULL,
      anUsePartRevision          IN       iapiType.Revision_Type DEFAULT NULL,
      anSequence                 IN       iapiType.SequenceNr_Type,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SaveLines(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anAction                   IN       iapiType.NumVal_Type,
      afHandle                   IN       iapiType.Float_Type DEFAULT NULL,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SaveStage(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPlantNo                  IN       iapiType.PlantNo_Type,
      asLine                     IN       iapiType.Line_Type,
      anConfiguration            IN       iapiType.Configuration_Type,
      anStageId                  IN       iapiType.StageId_Type,
      anStageSequence            IN       iapiType.StageSequence_Type,
      anRecirculateTo            IN       iapiType.StageSequence_Type,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SaveStageData(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPlantNo                  IN       iapiType.PlantNo_Type,
      asLine                     IN       iapiType.Line_Type,
      anConfiguration            IN       iapiType.Configuration_Type,
      anStageId                  IN       iapiType.StageId_Type,
      anAction                   IN       iapiType.NumVal_Type,
      afHandle                   IN       iapiType.Float_Type DEFAULT NULL,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SaveStageDataBomItem(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPlantNo                  IN       iapiType.PlantNo_Type,
      asLine                     IN       iapiType.Line_Type,
      anConfiguration            IN       iapiType.Configuration_Type,
      anStageId                  IN       iapiType.StageId_Type,
      anSequence                 IN       iapiType.LinePropSequence_Type,
      anNewSequence              IN       iapiType.LinePropSequence_Type DEFAULT NULL,
      asComponentPart            IN       iapiType.PartNo_Type,
      --AP00978864 --AP00978035 Start
      --afQuantity                 IN       iapiType.Quantity_Type, --orig
      afQuantity                 IN       iapiType.BomQuantity_Type,
      --AP00978864 --AP00978035 End
      asUom                      IN       iapiType.BaseUom_Type,
      anAlternative              IN       iapiType.BomAlternative_Type,
      anBomUsage                 IN       iapiType.BomUsage_Type,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SaveStageDataFreeText(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPlantNo                  IN       iapiType.PlantNo_Type,
      asLine                     IN       iapiType.Line_Type,
      anConfiguration            IN       iapiType.Configuration_Type,
      anStageId                  IN       iapiType.StageId_Type,
      alText                     IN       iapiType.Clob_Type,
      anLanguageId               IN       iapiType.LanguageId_Type DEFAULT 1,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SaveStageDataProperty(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPlantNo                  IN       iapiType.PlantNo_Type,
      asLine                     IN       iapiType.Line_Type,
      anConfiguration            IN       iapiType.Configuration_Type,
      anStageId                  IN       iapiType.StageId_Type,
      anSequence                 IN       iapiType.LinePropSequence_Type,
      anNewSequence              IN       iapiType.LinePropSequence_Type DEFAULT NULL,
      anPropertyId               IN       iapiType.Id_Type,
      anAttributeId              IN       iapiType.Id_Type,
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
      asBoolean1                 IN       iapiType.Boolean_Type,
      asBoolean2                 IN       iapiType.Boolean_Type,
      asBoolean3                 IN       iapiType.Boolean_Type,
      asBoolean4                 IN       iapiType.Boolean_Type,
      adDate1                    IN       iapiType.Date_Type,
      adDate2                    IN       iapiType.Date_Type,
      anCharacteristicId1        IN       iapiType.Id_Type,
      anTestMethodId             IN       iapiType.Id_Type,
      anAlternativeLanguageId    IN       iapiType.LanguageId_Type DEFAULT NULL,
      asAlternativeString1       IN       iapiType.PropertyShortString_Type DEFAULT NULL,
      asAlternativeString2       IN       iapiType.PropertyShortString_Type DEFAULT NULL,
      asAlternativeString3       IN       iapiType.PropertyShortString_Type DEFAULT NULL,
      asAlternativeString4       IN       iapiType.PropertyShortString_Type DEFAULT NULL,
      asAlternativeString5       IN       iapiType.PropertyShortString_Type DEFAULT NULL,
      asAlternativeString6       IN       iapiType.PropertyLongString_Type DEFAULT NULL,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SaveStageDataText(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPlantNo                  IN       iapiType.PlantNo_Type,
      asLine                     IN       iapiType.Line_Type,
      anConfiguration            IN       iapiType.Configuration_Type,
      anStageId                  IN       iapiType.StageId_Type,
      anSequence                 IN       iapiType.LinePropSequence_Type,
      anNewSequence              IN       iapiType.LinePropSequence_Type DEFAULT NULL,
      asText                     IN       iapiType.String_Type,
      anAlternativeLanguageId    IN       iapiType.LanguageId_Type DEFAULT NULL,
      asAlternativeText          IN       iapiType.String_Type DEFAULT NULL,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SaveStages(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPlantNo                  IN       iapiType.PlantNo_Type,
      asLine                     IN       iapiType.Line_Type,
      anConfiguration            IN       iapiType.Configuration_Type,
      anAction                   IN       iapiType.NumVal_Type,
      afHandle                   IN       iapiType.Float_Type DEFAULT NULL,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SynchroniseData(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION UpdateData(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ValidateStages(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPlantNo                  IN       iapiType.PlantNo_Type,
      asLine                     IN       iapiType.Line_Type,
      anConfiguration            IN       iapiType.Configuration_Type,
      asUsePartNo                IN       iapiType.PartNo_Type,
      anUsePartRevision          IN       iapiType.Revision_Type,
      asErrorText                OUT      iapiType.Info_Type )
      RETURN iapiType.ErrorNum_Type;
---------------------------------------------------------------------------
-- Pragmas
---------------------------------------------------------------------------
END iapiSpecificationProcessData;
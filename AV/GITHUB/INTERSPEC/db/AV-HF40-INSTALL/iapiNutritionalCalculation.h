CREATE OR REPLACE PACKAGE iapiNutritionalCalculation
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiNutritionalCalculation.h $
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract:
   --           This package contains all
   --           functionality for the nutritional calculation
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
   gsSource                      iapiType.Source_Type := 'iapiNutritionalCalculation';
   gtErrors                      ErrorDataTable_Type := ErrorDataTable_Type( );

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   FUNCTION AddAdditionalXML(
      anUniqueId                 IN       iapiType.Sequence_Type,
      anMopSequenceNo            IN       iapiType.Sequence_Type,
      asName                     IN       iapiType.Name_Type,
      anBaseQty                  IN       iapiType.BomQuantity_Type,
      anServConvFactor           IN       iapiType.BomQuantity_Type,
      anServVolume               IN       iapiType.BomQuantity_Type,
      axNutXml                   IN       iapiType.XmlType_Type,
      anSequenceNo               OUT      iapiType.Sequence_Type,
      aqErrors                   OUT      iapiType.Ref_Type,
      anBomLevel                 IN       iapiType.Boolean_Type DEFAULT 1,
      anAccessStop               IN       iapiType.Boolean_Type DEFAULT 0,
      anRecursiveStop            IN       iapiType.Boolean_Type DEFAULT 0,
      anUse                      IN       iapiType.Boolean_Type DEFAULT 1 )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION AddExportedPanels(
      anLogID                    IN       iapiType.Id_Type,
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      adCreatedOn                IN       iapiType.Date_Type DEFAULT SYSDATE )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION AddFilter(
      asName                     IN       iapiType.Name_Type,
      asDescription              IN       iapiType.Description_Type,
      atFilterDetails            IN       iapiType.NutFilterDetailsTab_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION AddFilter(
      asName                     IN       iapiType.Name_Type,
      asDescription              IN       iapiType.Description_Type,
      axFilterDetails            IN       iapiType.XmlType_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION AddNutitionalLogResult(
      anLogId                    IN       iapiType.Id_Type,
      anColId                    IN       iapiType.Id_Type,
      anRowId                    IN       iapiType.Id_Type,
      alValue                    IN       iapiType.Clob_Type,
      anProperty                 IN       iapiType.Id_Type,
      anPropertyRevision         IN       iapiType.Revision_Type,
      anAttributeId              IN       iapiType.Id_Type,
      anAttributeRevision        IN       iapiType.Revision_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION AddNutLogResultDetails(
      anLogId                    IN       iapiType.Id_Type,
      anColId                    IN       iapiType.Id_Type,
      anRowId                    IN       iapiType.Id_Type,
      anSeqNo                    IN       iapiType.Id_Type,
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asDisplayName              IN       iapiType.Description_Type,
      alValue                    IN       iapiType.Clob_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION AddNutPath(
      anUniqueId                 IN       iapiType.Sequence_Type,
      anMopSequenceNo            IN       iapiType.Sequence_Type,
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anPropertyGroupId          IN       iapiType.Id_Type,
      asAlternativePartNo        IN       iapiType.PartNo_Type,
      anAlternativeRevision      IN       iapiType.Revision_Type,
      axNutXml                   IN       iapiType.XmlType_Type,
      anBaseQty                  IN       iapiType.BomQuantity_Type,
      anServingConvFactor        IN       iapiType.ServingConvFactor_Type,
      anServingVol               IN       iapiType.ServingConvFactor_Type,
      asUom                      IN       iapiType.Description_Type,
      anConversionFactor         IN       iapiType.BomConvFactor_Type,
      asToUnit                   IN       iapiType.Description_Type,
      anCalcQtyWithScrap         IN       iapiType.BomQuantity_Type,
      anBomLevel                 IN       iapiType.Bomlevel_Type,
      anAccessStop               IN       iapiType.Boolean_Type,
      anRecursiveStop            IN       iapiType.Boolean_Type,
      anUse                      IN       iapiType.Boolean_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION AddNutResult(
      anUniqueID                 IN       iapiType.Sequence_Type,
      anMopSequenceNo            IN       iapiType.Sequence_Type,
      anRowID                    IN       iapiType.Sequence_Type,
      anColID                    IN       iapiType.Sequence_Type,
      anNumVal                   IN       iapiType.BomQuantity_Type,
      asStrVal                   IN       iapiType.Clob_Type,
      adDateVal                  IN       iapiType.Date_Type,
      anBoolean                  IN       iapiType.Boolean_Type,
      anProperty                 IN       iapiType.Sequence_Type,
      anPropertyRevision         IN       iapiType.Revision_Type,
      anAttributeId              IN       iapiType.Sequence_Type,
      anAttributeRevision        IN       iapiType.Revision_Type,
      asDisplayName              IN       iapiType.String_Type,
      anLayoutID                 IN       iapiType.Sequence_Type,
      anlayoutRevision           IN       iapiType.Revision_Type,
      asDecSep                   IN       iapiType.DecimalSeperator_Type DEFAULT iapigeneral.getdbdecimalseperator )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION AddNutritionalLog(
      asLogName                  IN       iapiType.Description_Type,
      anStatus                   IN       iapiType.StatusId_Type,
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPlant                    IN       iapiType.Plant_Type,
      anAlternative              IN       iapiType.BomAlternative_Type,
      anBomUsage                 IN       iapiType.BomUsage_Type,
      adExplosionDate            IN       iapiType.Date_Type,
      anServingSizeID            IN       iapiType.Id_Type,
      anServingWeight            IN       iapiType.Quantity_Type,
      anResultWeight             IN       iapiType.Quantity_Type,
      asRefSpec                  IN       iapiType.PartNo_Type,
      anRefRev                   IN       iapiType.Revision_Type,
      anLayoutId                 IN       iapiType.Sequence_Type,
      anLayoutRevision           IN       iapiType.Revision_Type,
      alLoggingXml               IN       iapiType.Clob_Type,
      asDecSep                   IN       iapiType.DecimalSeperator_Type DEFAULT iapigeneral.getdbdecimalseperator,
      anLogId                    OUT      iapiType.LogId_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION AddNutritionalPanel(
      anBomExpNo                 IN       iapiType.Id_Type,
      anMopSeqNo                 IN       iapiType.Id_Type,
      asLogName                  IN       iapiType.Description_Type,
      anStatus                   IN       iapiType.StatusId_Type,
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPlant                    IN       iapiType.Plant_Type,
      anAlternative              IN       iapiType.BomAlternative_Type,
      anBomUsage                 IN       iapiType.BomUsage_Type,
      adExplosionDate            IN       iapiType.Date_Type,
      anServingSizeID            IN       iapiType.Id_Type,
      anServingWeight            IN       iapiType.Quantity_Type,
      anResultWeight             IN       iapiType.Quantity_Type,
      asRefSpec                  IN       iapiType.PartNo_Type,
      anRefRev                   IN       iapiType.Revision_Type,
      anLayoutId                 IN       iapiType.Sequence_Type,
      anLayoutRevision           IN       iapiType.Revision_Type,
      alLoggingXml               IN       iapiType.Clob_Type,
      asDecSep                   IN       iapiType.DecimalSeperator_Type DEFAULT iapigeneral.getdbdecimalseperator,
      anLogId                    OUT      iapiType.LogId_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION AddReferenceSpecification(
      asNutRefType               IN       iapiType.NutRefType_Type,
      asName                     IN       iapiType.Name_Type,
      asPartNo                   IN       iapiType.PartNo_Type,
      anBasicWeightPropertyGroupId IN     iapiType.Id_Type,
      anBasicWeightPropertyId    IN       iapiType.Id_Type,
      anBasicWeightValueId       IN       iapiType.Id_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anPropertyGroupId          IN       iapiType.Id_Type,
      anHeaderId                 IN       iapiType.Id_Type,
      anNoteId                   IN       iapiType.Id_Type DEFAULT NULL,
      anRoundingSectionId        IN       iapiType.Id_Type,
      anRoundingSubSectionId     IN       iapiType.Id_Type,
      anRoundingPropertyGroupId  IN       iapiType.Id_Type,
      anRoundingValueId          IN       iapiType.Id_Type,
      anRoundingRDAId            IN       iapiType.Id_Type,
      anEnergySectionId          IN       iapiType.Id_Type,
      anEnergySubSectionId       IN       iapiType.Id_Type,
      anEnergyPropertyGroupId    IN       iapiType.Id_Type,
      anEnergyPropertykCal       IN       iapiType.Id_Type,
      anEnergyPropertykJ         IN       iapiType.Id_Type,
      anEnergyAttributekCal      IN       iapiType.Id_Type,
      anEnergyAttributekJ        IN       iapiType.Id_Type,
      anEnergykCalValueId        IN       iapiType.Id_Type,
      anEnergykJValueId          IN       iapiType.Id_Type,
      anServingSectionId         IN       iapiType.Id_Type,
      anServingSubSectionId      IN       iapiType.Id_Type,
      anServingPropertyGroupId   IN       iapiType.Id_Type,
      anServingColId             IN       iapiType.Id_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION Calculate(
      anUniqueID                 IN       iapiType.Sequence_Type,
      anMopSequenceNo            IN       iapiType.Sequence_Type,
      asNutRefType               IN       iapiType.NutRefType_Type,
      anServingWeight            IN       iapiType.NumVal_Type DEFAULT 100,
      asDecSep                   IN       iapiType.DecimalSeperator_Type DEFAULT iapigeneral.getdbdecimalseperator )
      RETURN iapiType.ErrorNum_Type;

   --AP01111791 Start
   ---------------------------------------------------------------------------
   FUNCTION DropTempTable(
      asTableName                IN      iapiType.String_Type )
      RETURN iapiType.ErrorNum_Type;
   --AP01111791 End

   ---------------------------------------------------------------------------
   FUNCTION ExistFilter(
      anID                       IN       iapiType.ID_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ExistFilterName(
      asName                     IN       iapiType.Name_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ExistNutLayout(
      anLayoutID                 IN       iapiType.Sequence_Type,
      anRevision                 IN       iapiType.Revision_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ExistReferenceSpecification(
      asNutRefType               IN       iapiType.NutRefType_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION Explode(
      anUniqueID                 IN       iapiType.Sequence_Type,
      anMopSequenceNo            IN       iapiType.Sequence_Type,
      asNutRefType               IN       iapiType.NutRefType_Type,
      atFilterDetails            IN OUT   iapiType.NutFilterDetailsTab_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION Explode(
      anUniqueID                 IN       iapiType.Sequence_Type,
      anMopSequenceNo            IN       iapiType.Sequence_Type,
      asNutRefType               IN       iapiType.NutRefType_Type,
      axFilterDetails            IN       iapiType.XmlType_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetAllFilters(
      aqFilters                  OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetCurrentNutLy(
      aqNutLy                    OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetDefaultFilter(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anPropertyGroupId          IN       iapiType.Id_Type,
      aqDefaultFilters           OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetExportedPanels(
      anLogID                    IN       iapiType.Id_Type,
      aqExportedPanels           OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetFilterDetails(
      anID                       IN       iapiType.Id_Type,
      aqFilterDetails            OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetFilterDetailsByName(
      asName                     IN       iapiType.Name_Type,
      aqFilterDetails            OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetNutBasicConverstionFactor(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asNutRefType               IN       iapiType.NutRefType_Type )
      RETURN iapiType.Float_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetNutLogResultDetails(
      anLogId                    IN       iapiType.Id_Type,
      aqNutLogResultDetails      OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetNutLyItems(
      anLayoutID                 IN       iapiType.Sequence_Type,
      anRevision                 IN       iapiType.Revision_Type,
      aqNutLyItems               OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetNutPath(
      anUniqueId                 IN       iapiType.Sequence_Type,
      aqNutPaths                 OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetNutResult(
      anUniqueID                 IN       iapiType.Sequence_Type,
      anMopSequenceNo            IN       iapiType.Sequence_Type,
      aqNutResults               OUT      iapiType.Ref_Type,
      asDecimalSeperator         IN       iapiType.DecimalSeperator_Type DEFAULT iapigeneral.getDBDecimalSeperator )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetNutRemarks(
      anUniqueID                 IN       iapiType.Sequence_Type,
      anMopSequenceNo            IN       iapiType.Sequence_Type,
      aqNutRemarks               OUT      iapiType.Ref_Type)
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetNutResultDetail(
      anUniqueID                 IN       iapiType.Sequence_Type,
      anMopSequenceNo            IN       iapiType.Sequence_Type,
      aqNutResultDetails         OUT      iapiType.Ref_Type,
      --AP01111791 Start
      --asDecimalSeperator         IN       iapiType.DecimalSeperator_Type DEFAULT iapigeneral.getDBDecimalSeperator ) --orig
      asDecimalSeperator         IN       iapiType.DecimalSeperator_Type DEFAULT iapigeneral.getDBDecimalSeperator,
      asTableName                OUT      iapiType.String_Type)
      --AP01111791 End
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetNutritionalLogResults(
      anLogId                    IN       iapiType.LogId_Type,
      aqNutritionalLogResults    OUT      iapiType.Ref_Type,
      asDecimalSeperator         IN       iapiType.DecimalSeperator_Type DEFAULT iapigeneral.getDBDecimalSeperator )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetNutritionalLogResults_cs(
      anLogId                    IN       iapiType.LogId_Type,
      aqnutlogresult             OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetNutritionalLogs(
      asPartNo                   IN       iapiType.PartNo_Type,
      aqNutLogs                  OUT      iapiType.Ref_Type,
      anRevision                 IN       iapiType.Revision_Type DEFAULT NULL,
      asPlant                    IN       iapiType.Plant_Type DEFAULT NULL,
      anAlternative              IN       iapiType.BomAlternative_Type DEFAULT NULL,
      anUsage                    IN       iapiType.BomUsage_Type DEFAULT NULL )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetReferenceSpecifications(
      aqRefSpecifications        OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetServingSizes(
      asRefType                  IN       iapiType.NutRefType_Type,
      aqServingSizes             OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION isBasedOnPartlyEmptyFields(
      anUniqueID                 IN       iapiType.Sequence_Type,
      anMopSequenceNo            IN       iapiType.Sequence_Type,
      anPartlyEmptyFields        OUT      iapiType.Boolean_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION isValidNutPathXML(
      axNutXml                   IN       iapiType.XmlType_Type,
      aqErrors                   IN OUT NOCOPY iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION RemoveExportedPanels(
      anLogID                    IN       iapiType.Id_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION RemoveFilter(
      anID                       IN       iapiType.Id_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION RemoveNutPath(
      anUniqueId                 IN       iapiType.Sequence_Type,
      anMopSequenceNo            IN       iapiType.Sequence_Type,
      anSequenceNo               IN       iapiType.Sequence_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION RemoveNutResult(
      anUniqueID                 IN       iapiType.Sequence_Type,
      anMopSequenceNo            IN       iapiType.Sequence_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION RemoveReferenceSpecification(
      asNutRefType               IN       iapiType.NutRefType_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SaveAdditionalXml(
      anUniqueId                 IN       iapiType.Sequence_Type,
      anMopSequenceNo            IN       iapiType.Sequence_Type,
      anSequenceNo               IN       iapiType.Sequence_Type,
      asName                     IN       iapiType.Name_Type,
      axNutXml                   IN       iapiType.XmlType_Type,
      anBaseQty                  IN       iapiType.BomQuantity_Type,
      anServingConvFactor        IN       iapiType.ServingConvFactor_Type,
      anServingVol               IN       iapiType.ServingConvFactor_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

--AP00994801 Start
---------------------------------------------------------------------------
   FUNCTION DeleteAllAdditionalXml(
      anUniqueId                 IN       iapiType.Sequence_Type,
      anMopSequenceNo            IN       iapiType.Sequence_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;
--AP00994801 End

   ---------------------------------------------------------------------------
   FUNCTION SaveExportedPanels(
      anLogID                    IN       iapiType.Id_Type,
      anSequenceNo               IN       iapiType.Sequence_Type,
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      adCreatedOn                IN       iapiType.Date_Type DEFAULT SYSDATE )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SaveFilter(
      anID                       IN       iapiType.Id_Type,
      asName                     IN       iapiType.Name_Type,
      asDescription              IN       iapiType.Description_Type,
      atFilterDetails            IN       iapiType.NutFilterDetailsTab_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SaveFilter(
      anID                       IN       iapiType.Id_Type,
      asName                     IN       iapiType.Name_Type,
      asDescription              IN       iapiType.Description_Type,
      axFilterDetails            IN       iapiType.XmlType_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SaveNutPath(
      anUniqueId                 IN       iapiType.Sequence_Type,
      anMopSequenceNo            IN       iapiType.Sequence_Type,
      anSequenceNo               IN       iapiType.Sequence_Type,
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anPropertyGroupId          IN       iapiType.Id_Type,
      asAlternativePartNo        IN       iapiType.PartNo_Type,
      anAlternativeRevision      IN       iapiType.Revision_Type,
      axNutXml                   IN       iapiType.XmlType_Type,
      anBaseQty                  IN       iapiType.BomQuantity_Type,
      anServingConvFactor        IN       iapiType.ServingConvFactor_Type,
      anServingVol               IN       iapiType.ServingConvFactor_Type,
      asUom                      IN       iapiType.Description_Type,
      anConversionFactor         IN       iapiType.BomConvFactor_Type,
      asToUnit                   IN       iapiType.Description_Type,
      anCalcQtyWithScrap         IN       iapiType.BomQuantity_Type,
      anBomLevel                 IN       iapiType.Bomlevel_Type,
      anAccessStop               IN       iapiType.Boolean_Type,
      anRecursiveStop            IN       iapiType.Boolean_Type,
      anUse                      IN       iapiType.Boolean_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SaveNutResult(
      anUniqueID                 IN       iapiType.Sequence_Type,
      anMopSequenceNo            IN       iapiType.Sequence_Type,
      anRowID                    IN       iapiType.Sequence_Type,
      anColID                    IN       iapiType.Sequence_Type,
      anNumVal                   IN       iapiType.BomQuantity_Type,
      asStrVal                   IN       iapiType.Clob_Type,
      adDateVal                  IN       iapiType.Date_Type,
      anBoolean                  IN       iapiType.Boolean_Type,
      anProperty                 IN       iapiType.Sequence_Type,
      anPropertyRevision         IN       iapiType.Revision_Type,
      anAttributeId              IN       iapiType.Sequence_Type,
      anAttributeRevision        IN       iapiType.Revision_Type,
      asDisplayName              IN       iapiType.String_Type,
      anLayoutID                 IN       iapiType.Sequence_Type,
      anlayoutRevision           IN       iapiType.Revision_Type,
      asDecSep                   IN       iapiType.DecimalSeperator_Type DEFAULT iapigeneral.getdbdecimalseperator )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SaveNutritionalLog(
      anLogId                    IN       iapiType.LogId_Type,
      asLogName                  IN       iapiType.Description_Type,
      anStatus                   IN       iapiType.StatusId_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SaveNutUsage(
      anUniqueId                 IN       iapiType.Sequence_Type,
      anMopSequenceNo            IN       iapiType.Sequence_Type,
      anSequenceNo               IN       iapiType.Sequence_Type,      
      --AP01058317 --AP01054597 Start
      --anUse                      IN       iapiType.Boolean_Type ) --orig
      anUse                      IN       iapiType.Boolean_Type,
      anLogID                    IN       iapiType.LogId_Type DEFAULT NULL,
      anColID                    IN       iapiType.ColId_Type DEFAULT NULL)      
      --AP01058317 --AP01054597 End
      RETURN iapiType.ErrorNum_Type;

   --AP01058317 --AP01054597 Start
   --orig Start
   --AP00848542 Start
   -----------------------------------------------------------------------------
   --FUNCTION SaveNutUsage_new(
   --   anUniqueId                 IN       iapiType.Sequence_Type,
   --   anMopSequenceNo            IN       iapiType.Sequence_Type,
   --   anSequenceNo               IN       iapiType.Sequence_Type,
   --   anUse                      IN       iapiType.Boolean_Type,
   --   anLogID                    IN       iapiType.LogId_Type DEFAULT NULL)
   --   RETURN iapiType.ErrorNum_Type;
   ----AP00848542 End
   --orig End
   --AP01058317 --AP01054597 End


--AP01058317 --AP01054597 Start
--orig Start
--   --AP00848542 Start
--   ---------------------------------------------------------------------------
--    FUNCTION GetAdjustedValueColumnID(
--        anLogId                   IN        iapiType.LogId_Type,
--        anColId                   OUT       itnutlyitem.seq_no%TYPE)
--        RETURN iapiType.ErrorNum_Type;
--    --AP00848542 End
--orig End
--AP01058317 --AP01054597 End

--AP01058317 --AP01054597 Start
   ---------------------------------------------------------------------------
----   FUNCTION SaveNutUsage_new2(
--   FUNCTION SaveNutUsage_new(
--      anUniqueId                 IN       iapiType.Sequence_Type,
--      anMopSequenceNo            IN       iapiType.Sequence_Type,
--      anSequenceNo               IN       iapiType.Sequence_Type,
--      anUse                      IN       iapiType.Boolean_Type,
--      anLogID                    IN       iapiType.LogId_Type DEFAULT NULL,
--      anColID                    IN       iapiType.ColId_Type DEFAULT NULL)
--      RETURN iapiType.ErrorNum_Type;
----AP01058317 --AP01054597 End

   ---------------------------------------------------------------------------
   FUNCTION SaveReferenceSpecification(
      asNutRefType               IN       iapiType.NutRefType_Type,
      asName                     IN       iapiType.Name_Type,
      asPartNo                   IN       iapiType.PartNo_Type,
      anBasicWeightPropertyGroupId IN     iapiType.Id_Type,
      anBasicWeightPropertyId    IN       iapiType.Id_Type,
      anBasicWeightValueId       IN       iapiType.Id_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anPropertyGroupId          IN       iapiType.Id_Type,
      anHeaderId                 IN       iapiType.Id_Type,
      anNoteId                   IN       iapiType.Id_Type DEFAULT NULL,
      anRoundingSectionId        IN       iapiType.Id_Type,
      anRoundingSubSectionId     IN       iapiType.Id_Type,
      anRoundingPropertyGroupId  IN       iapiType.Id_Type,
      anRoundingValueId          IN       iapiType.Id_Type,
      anRoundingRDAId            IN       iapiType.Id_Type,
      anEnergySectionId          IN       iapiType.Id_Type,
      anEnergySubSectionId       IN       iapiType.Id_Type,
      anEnergyPropertyGroupId    IN       iapiType.Id_Type,
      anEnergyPropertykCal       IN       iapiType.Id_Type,
      anEnergyPropertykJ         IN       iapiType.Id_Type,
      anEnergyAttributekCal      IN       iapiType.Id_Type,
      anEnergyAttributekJ        IN       iapiType.Id_Type,
      anEnergykCalValueId        IN       iapiType.Id_Type,
      anEnergykJValueId          IN       iapiType.Id_Type,
      anServingSectionId         IN       iapiType.Id_Type,
      anServingSubSectionId      IN       iapiType.Id_Type,
      anServingPropertyGroupId   IN       iapiType.Id_Type,
      anServingColId             IN       iapiType.Id_Type,
      anPercentRDACalculation    IN       iapiType.Boolean_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SetReferences(
      anUniqueID                 IN       iapiType.Sequence_Type,
      asNutRefType               IN       iapiType.NutRefType_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION TransformXmlNutFilter(
      axFilterDetails            IN       iapiType.XmlType_Type,
      atFilterDetails            OUT      iapiType.NutFilterDetailsTab_Type,
      aqErrors                   IN OUT NOCOPY iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION TransformXmlNutPath(
      axNutXml                   IN       iapiType.XmlType_Type,
      atNutPath                  OUT      iapiType.NutXmlTab_Type )
      RETURN iapiType.ErrorNum_Type;
---------------------------------------------------------------------------
-- Pragmas
---------------------------------------------------------------------------
END iapiNutritionalCalculation;
/

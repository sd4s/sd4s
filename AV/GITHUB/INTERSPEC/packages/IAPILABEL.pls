create or replace PACKAGE iapiLabel
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiLabel.h $
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract:
   --           This package contains all
   --           functionality to handle ingredient/chemical
   --           labelling
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
   gsSource                      iapiType.Source_Type := 'iapiLabel';
   gtErrors                      ErrorDataTable_Type := ErrorDataTable_Type( );

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   FUNCTION AddLabelLog(
      asLogName                  IN       iapiType.Description_Type,
      anStatus                   IN       iapiType.StatusId_Type,
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPlant                    IN       iapiType.Plant_Type,
      anAlternative              IN       iapiType.BomAlternative_Type,
      anBomUsage                 IN       iapiType.BomUsage_Type,
      adExplosionDate            IN       iapiType.Date_Type,
      alLabel                    IN       iapiType.Clob_Type,
      anSoi                      IN       iapiType.Boolean_Type,
      anLanguageId               IN       iapiType.LanguageId_Type,
      anSynonymType              IN       iapiType.Id_Type,
      alLoggingXml               IN       iapiType.Clob_Type,
      anLabelType                IN       iapiType.LabelType_Type,
      allabelXml                 IN       iapiType.Clob_Type,
      aolabelRTF                 IN       iapiType.Blob_Type,
      anLogId                    OUT      iapiType.LogId_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION AddLabelLogResultDetails(
      anLogId                    IN       iapiType.Id_Type,
      anSequenceNo               IN       iapiType.Sequence_Type,
      anParentSequenceNo         IN       iapiType.Sequence_Type,
      anBomLevel                 IN       iapiType.BomLevel_Type,
      anIngredient               IN       iapiType.Id_Type,
      anIsInGroup                IN       iapiType.Boolean_Type,
      anIsInFunction             IN       iapiType.Boolean_Type,
      asDescription              IN       iapiType.String_Type,
      anQuantity                 IN       iapiType.BomQuantity_Type,
      asNote                     IN       iapiType.Clob_Type,
      anRecFromId                IN       iapiType.Id_Type,
      asRecFromDescription       IN       iapiType.Description_Type,
      anRecWithId                IN       iapiType.Id_Type,
      asRecWithDescription       IN       iapiType.Description_Type,
      anShowRec                  IN       iapiType.Boolean_Type,
      anActiveIngredient         IN       iapiType.Boolean_Type,
      anQuid                     IN       iapiType.Boolean_Type,
      anUsePerc                  IN       iapiType.Boolean_Type,
      anShowItems                IN       iapiType.Boolean_Type,
      anUsePercRel               IN       iapiType.Boolean_Type,
      anUsePercAbs               IN       iapiType.Boolean_Type,
      anUseBrackets              IN       iapiType.Boolean_Type,
      anAllergen                 IN       iapiType.Id_Type,
      anSoi                      IN       iapiType.Boolean_Type,
      anComplexLabelLogId        IN       iapiType.Id_Type,
      anParagraph                IN       iapiType.Boolean_Type,
      anSortSequenceNo           IN       iapiType.Sequence_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION CheckLabel(
      anUniqueId                 IN       iapiType.Id_Type,
      adExplosionDate            IN       iapiType.Date_Type DEFAULT SYSDATE,
      anIncludeInDevelopment     IN       iapiType.Boolean_Type DEFAULT 0 )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetIngredientList(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSynonymType              IN       iapiType.Id_Type,
      aqItems                    OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   --AP01194180 Start
   ---------------------------------------------------------------------------
   FUNCTION GetIngredientList(
      anUniqueId                 IN       iapiType.Sequence_Type,
      anSynonymType              IN       iapiType.Id_Type,
      aqItems                    OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;
   --AP01194180 End

   ---------------------------------------------------------------------------
   FUNCTION GetIngredients(
      anGroupId                  IN       iapiType.Id_Type,
      aqIngredients              OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetLabelLogResultDetails(
      anLogId                    IN       iapiType.LogId_Type,
      aqLabelLogResultDetails    OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetLabelLogs(
      asPartNo                   IN       iapiType.PartNo_Type,
      aqLabelLogs                OUT      iapiType.Ref_Type,
      anRevision                 IN       iapiType.Revision_Type DEFAULT NULL,
      asPlant                    IN       iapiType.Plant_Type DEFAULT NULL,
      anAlternative              IN       iapiType.BomAlternative_Type DEFAULT NULL,
      anUsage                    IN       iapiType.BomUsage_Type DEFAULT NULL,
     --IS741 --oneLine
      abShowHistoricLabels       IN       iapiType.Boolean_Type DEFAULT NULL)
      RETURN iapiType.ErrorNum_Type;

--AP00840468 -- AP00840159 Start
   ---------------------------------------------------------------------------
   FUNCTION GetLabelLogsPB(
      asPartNo                   IN       iapiType.PartNo_Type,
      aqLabelLogs                OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;
--AP00840468 -- AP00840159 End

   ---------------------------------------------------------------------------
   FUNCTION GetLanguageInfo(
      aqLanguageInfo             OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SaveLabelLog(
      anLogId                    IN       iapiType.LogId_Type,
      asLogName                  IN       iapiType.Description_Type,
      anStatus                   IN       iapiType.StatusId_Type,
      anSoi                      IN       iapiType.Id_Type,
      allabel                    IN       iapiType.Clob_Type,
      aolabelRTF                 IN       iapiType.Blob_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;
---------------------------------------------------------------------------
-- Pragmas
---------------------------------------------------------------------------
END iapiLabel;
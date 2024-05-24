create or replace PACKAGE iapiFoodClaims
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiFoodClaims.h $
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract:
   --
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
   gsSource                      iapiType.Source_Type := 'iapiFoodClaims';
   gtErrors                      ErrorDataTable_Type := ErrorDataTable_Type( );

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   FUNCTION AddFoodClaimLog(
      asLogName                  IN       iapiType.Description_Type,
      anStatus                   IN       iapiType.StatusId_Type DEFAULT 0,
      asPartNo                   IN       iapiType.PartNo_Type DEFAULT NULL,
      anRevision                 IN       iapiType.Revision_Type DEFAULT NULL,
      asPlant                    IN       iapiType.Plant_Type DEFAULT NULL,
      anAlternative              IN       iapiType.BomAlternative_Type DEFAULT NULL,
      anBomUsage                 IN       iapiType.BomUsage_Type DEFAULT NULL,
      adExplosionDate            IN       iapiType.Date_Type DEFAULT NULL,
      asCreatedBy                IN       iapiType.UserId_Type DEFAULT NULL,
      adCreatedOn                IN       iapiType.Date_Type DEFAULT SYSDATE,
      alLabel                    IN       iapiType.Clob_Type DEFAULT NULL,
      anLanguageId               IN       iapiType.LanguageId_Type,
      anReferenceAmount          IN       iapiType.NumVal_Type,
      alLoggingXml               IN       iapiType.Clob_Type,
      anLogId                    OUT      iapiType.SequenceNr_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION AddFoodClaimLogResult(
      anLogId                    IN       iapiType.SequenceNr_Type,
      anFoodClaimId              IN       iapiType.SequenceNr_Type,
      anNutLogId                 IN       iapiType.SequenceNr_Type,
      anResult                   IN       iapiType.ClaimsResultType_Type,
      anCompLogId                IN       iapiType.SequenceNr_Type DEFAULT NULL,
      anCompGroupId              IN       iapiType.SequenceNr_Type DEFAULT NULL,
      anFoodClaimDescription     IN       iapiType.Description_Type DEFAULT NULL,
      asDecSep                   IN       iapiType.DecimalSeperator_Type DEFAULT NULL,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION AddFoodClaimLogResultDetails(
      anLogId                    IN       iapiType.SequenceNr_Type,
      anFoodClaimId              IN       iapiType.SequenceNr_Type,
      anFoodClaimCritRuleCdId    IN       iapiType.SequenceNr_Type,
      anHierLevel                IN       iapiType.SequenceNr_Type,
      anNutLogId                 IN       iapiType.SequenceNr_Type,
      anSeqNo                    IN       iapiType.SequenceNr_Type DEFAULT NULL,
      anRefType                  IN       iapiType.ClaimResultDRefType_Type DEFAULT NULL,
      anRefId                    IN       iapiType.SequenceNr_Type DEFAULT NULL,
      asAndOr                    IN       iapiType.ClaimResultDAndOr_Type DEFAULT NULL,
      anRuleType                 IN       iapiType.ClaimResultDRuleType_Type DEFAULT NULL,
      anRuleId                   IN       iapiType.SequenceNr_Type DEFAULT NULL,
      asRuleOperator             IN       iapiType.ShortDescription_Type DEFAULT NULL,
      asRuleValue1               IN       iapiType.Description_Type DEFAULT NULL,
      asRuleValue2               IN       iapiType.Description_Type DEFAULT NULL,
      asServingSize              IN       iapiType.Description_Type DEFAULT NULL,
      anValueType                IN       iapiType.ClaimResultDValueType_Type DEFAULT NULL,
      anRelativePerc             IN       iapiType.ClaimResultDRelativePerc_Type DEFAULT NULL,
      anRelativeComp             IN       iapiType.ClaimResultDRelativeComp_Type DEFAULT NULL,
      asActualValue              IN       iapiType.ShortDescription_Type DEFAULT NULL,
      anResult                   IN       iapiType.ClaimsResultType_Type DEFAULT NULL,
      anParentFoodClaimId        IN       iapiType.SequenceNr_Type,
      anParentSeqNo              IN       iapiType.SequenceNr_Type,
      anErrorCode                IN       iapiType.ErrorNum_Type DEFAULT 0,
      anAttributeId              IN       iapiType.SequenceNr_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION AddFoodClaimPanel(
      anWebRq                    IN       iapiType.SequenceNr_Type,
      anNutLogId                 IN       iapiType.SequenceNr_Type,
      asLogName                  IN       iapiType.Description_Type,
      anStatus                   IN       iapiType.StatusId_Type DEFAULT 0,
      asPartNo                   IN       iapiType.PartNo_Type DEFAULT NULL,
      anRevision                 IN       iapiType.Revision_Type DEFAULT NULL,
      asPlant                    IN       iapiType.Plant_Type DEFAULT NULL,
      anAlternative              IN       iapiType.BomAlternative_Type DEFAULT NULL,
      anBomUsage                 IN       iapiType.BomUsage_Type DEFAULT NULL,
      adExplosionDate            IN       iapiType.Date_Type DEFAULT NULL,
      asCreatedBy                IN       iapiType.UserId_Type DEFAULT NULL,
      adCreatedOn                IN       iapiType.Date_Type DEFAULT SYSDATE,
      alLabel                    IN       iapiType.Clob_Type DEFAULT NULL,
      anLanguageId               IN       iapiType.LanguageId_Type,
      anResult                   IN       iapiType.ClaimsResultType_Type,
      alLoggingXml               IN       iapiType.Clob_Type,
      asDecSep                   IN       iapiType.DecimalSeperator_Type DEFAULT NULL,
      anLogId                    OUT      iapiType.SequenceNr_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ExecuteRun(
      anWebRq                    IN       iapiType.SequenceNr_Type,
      asDecSep                   IN       iapiType.DecimalSeperator_Type DEFAULT NULL,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ExecuteRunDetail(
      anWebRq                    IN       iapiType.SequenceNr_Type,
      arRun                      IN       iapiType.FoodClaimRunRec_Type,
      arProfiles                 IN       iapiType.FoodClaimProfileRec_Type,
      anParentFoodClaimId        IN       iapiType.SequenceNr_Type,
      anParentLogId              IN       iapiType.SequenceNr_Type,
      anParentSeqNo              IN OUT   iapiType.SequenceNr_Type,
      asConditions               IN OUT   iapiType.String_Type,
      abResult                   IN OUT   iapiType.Boolean_Type,
      anHierLevel                IN OUT   iapiType.HierLevel_Type,
      anErrorCode                IN OUT   iapiType.SequenceNr_Type,
      abNotClaim                 IN       iapiType.Boolean_Type,
      asDecSep                   IN       iapiType.DecimalSeperator_Type DEFAULT NULL )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetAlerts(
      anWebRq                    IN       iapiType.SequenceNr_Type,
      anLogId                    IN       iapiType.SequenceNr_Type,
      anFoodClaimId              IN       iapiType.SequenceNr_Type,
      aqAlerts                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetFoodClaim(
      anWebRq                    IN       iapiType.SequenceNr_Type,
      anParentFoodClaimId        IN       iapiType.SequenceNr_Type,
      anParentLogId              IN       iapiType.SequenceNr_Type,
      anParentSeqNo              IN OUT   iapiType.SequenceNr_Type,
      anFoodClaimId              IN       iapiType.SequenceNr_Type,
      arRun                      IN       iapiType.FoodClaimRunRec_Type,
      arProfiles                 IN       iapiType.FoodClaimProfileRec_Type,
      abResult                   IN OUT   iapiType.Boolean_Type,
      anHierLevel                IN OUT   iapiType.HierLevel_Type,
      anErrorCode                IN OUT   iapiType.SequenceNr_Type,
      abNotClaim                 IN       iapiType.Boolean_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetFoodClaimLog(
      asPartNo                   IN       iapiType.PartNo_Type,
      aqFoodClaimLog             OUT      iapiType.Ref_Type,
      anRevision                 IN       iapiType.Revision_Type DEFAULT NULL,
      asPlant                    IN       iapiType.Plant_Type DEFAULT NULL,
      anAlternative              IN       iapiType.BomAlternative_Type DEFAULT NULL,
      anUsage                    IN       iapiType.BomUsage_Type DEFAULT NULL )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetFoodClaimLogLabel(
      anLogId                    IN       iapiType.SequenceNr_Type,
      alLogLabel                 OUT      iapiType.Clob_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetFoodClaimLogResult(
      anLogId                    IN       iapiType.SequenceNr_Type,
      AqFoodClaimLogResult       OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetFoodClaimLogResultDetail(
      anLogId                    IN       iapiType.SequenceNr_Type,
      anNutLogId                 IN       iapiType.SequenceNr_Type,
      anFoodClaimId              IN       iapiType.SequenceNr_Type,
      anConditionFoodClaimId     IN       iapiType.SequenceNr_Type,
      AqFoodClaimLogResultDetails OUT     iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetFoodClaims(
      aqFoodClaims               OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetFoodClaims(
      anWebRq                    IN       iapiType.SequenceNr_Type,
      atKeyWordFilter            IN       iapiType.FoodClaimRunCritTab_Type,
      aqFoodClaims               OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetFoodClaims(
      anWebRq                    IN       iapiType.SequenceNr_Type,
      axKeyWordFilter            IN       iapiType.XmlType_Type,
      aqFoodClaims               OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetFoodTypes(
      aqFoodTypes                OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetKeyWordAssociations(
      aqValues                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_TYpe;

   ---------------------------------------------------------------------------
   FUNCTION GetKeyWords(
      aqKeyWords                 OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetLabels(
      anWebRq                    IN       iapiType.SequenceNr_Type,
      anLogId                    IN       iapiType.SequenceNr_Type,
      anFoodClaimId              IN       iapiType.SequenceNr_Type,
      aqLabels                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetLogProfiles(
      anLogId                    IN       iapiType.SequenceNr_Type,
      aqLogProfiles              OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetManualConditions(
      anId                       IN       iapiType.SequenceNr_Type,
      aqManCond                  OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetNotes(
      anWebRq                    IN       iapiType.SequenceNr_Type,
      anLogId                    IN       iapiType.SequenceNr_Type,
      anFoodClaimId              IN       iapiType.SequenceNr_Type,
      aqNotes                    OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetNutLyGroups(
      aqGroups                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetResultDetails(
      anWebRq                    IN       iapiType.SequenceNr_Type,
      anLogId                    IN       iapiType.SequenceNr_Type,
      anFoodClaimId              IN       iapiType.SequenceNr_Type,
      anConditionFoodClaimId     IN       iapiType.SequenceNr_Type,
      aqDetails                  OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetResults(
      anWebRq                    IN       iapiType.SequenceNr_Type,
      aqResults                  OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetSynonyms(
      anId                       IN       iapiType.SequenceNr_Type,
      aqSynonyms                 OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   --AP00811060 Start
   ---------------------------------------------------------------------------
   FUNCTION MultiplyValue(
      anValue                    IN       iapiType.NumVal_Type,
      anIndex                    IN       iapiType.NumVal_Type )
      RETURN iapiType.NumVal_Type;
   --AP00811060 End

   ---------------------------------------------------------------------------
   FUNCTION SaveFoodClaimLog(
      anLogId                    IN       iapiType.SequenceNr_Type,
      asLogName                  IN       iapiType.Description_Type,
      anStatus                   IN       iapiType.StatusId_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SaveFoodClaimResultDescription(
      anWebRq                    IN       iapiType.SequenceNr_Type,
      anLogId                    IN       iapiType.SequenceNr_Type,
      anFoodClaimId              IN       iapiType.SequenceNr_Type,
      anFoodClaimDescription     IN       iapiType.Description_Type DEFAULT NULL,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SaveProfile(
      anWebRq                    IN       iapiType.SequenceNr_Type,
      axProfile                  IN       iapiType.XmlType_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SaveProfile(
      anWebRq                    IN       iapiType.SequenceNr_Type,
      atProfile                  IN       iapiType.FoodClaimProfileTab_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SynchronizeRun(
      anWebRq                    IN       iapiType.SequenceNr_Type,
      atRun                      IN       iapiType.FoodClaimRunTab_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SynchronizeRun(
      anWebRq                    IN       iapiType.SequenceNr_Type,
      axRun                      IN       iapiType.XmlType_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SynchronizeRunConditions(
      anWebRq                    IN       iapiType.SequenceNr_Type,
      axManualConditions         IN       iapiType.XmlType_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SynchronizeRunConditions(
      anWebRq                    IN       iapiType.SequenceNr_Type,
      atManualConditions         IN       iapiType.FoodClaimRunCdTab_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION TransformXmlManualConditions(
      axManualConditions         IN       iapiType.XmlType_Type,
      atManualConditions         OUT      iapiType.FoodClaimRunCdTab_Type,
      aqErrors                   IN OUT   iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION TransformXmlProfile(
      axProfile                  IN       iapiType.XmlType_Type,
      atProfile                  OUT      iapiType.FoodClaimProfileTab_Type,
      aqErrors                   IN OUT   iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION TransformXmlRun(
      axRun                      IN       iapiType.XmlType_Type,
      atRun                      OUT      iapiType.FoodClaimRunTab_Type,
      aqErrors                   IN OUT   iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION TransformXmlRunKeywords(
      axRunKeywords              IN       iapiType.XmlType_Type,
      atRunKeywords              OUT      iapiType.FoodClaimRunCritTab_Type,
      aqErrors                   IN OUT   iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;
---------------------------------------------------------------------------

-- Pragmas
---------------------------------------------------------------------------
END iapiFoodClaims;
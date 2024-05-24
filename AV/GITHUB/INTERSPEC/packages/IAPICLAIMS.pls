create or replace PACKAGE iapiClaims
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiClaims.h $
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract:
   --           This package contains all
   --           functionality for retrieving and saving claim data
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
   gsSource                      iapiType.Source_Type := 'iapiClaims';
   gtErrors                      ErrorDataTable_Type := ErrorDataTable_Type( );

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   FUNCTION AddClaimsLog(
      asLogName                  IN       iapiType.Description_Type,
      anStatus                   IN       iapiType.StatusId_Type,
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPlant                    IN       iapiType.Plant_Type,
      anAlternative              IN       iapiType.BomAlternative_Type,
      anBomUsage                 IN       iapiType.BomUsage_Type,
      adExplosionDate            IN       iapiType.Date_Type,
      anReportType               IN       iapiType.Id_Type,
      alLoggingXml               IN       iapiType.Clob_Type,
      anLogId                    OUT      iapiType.LogId_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION AddClaimsLogResult(
      anLogId                    IN       iapiType.LogId_Type,
      anPropertyGroup            IN       iapiType.Id_Type,
      anPropertyGroupRev         IN       iapiType.Revision_Type,
      anProperty                 IN       iapiType.Id_Type,
      anPropertyRevision         IN       iapiType.Revision_Type,
      anPropertyGroupType        IN       iapiType.Boolean_Type,
      anValue                    IN       iapiType.ClaimsResultType_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION Explode(
      anUniqueId                 IN       iapiType.Sequence_Type,
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPlant                    IN       iapiType.Plant_Type,
      anAlternative              IN       iapiType.BomAlternative_Type,
      anUsage                    IN       iapiType.BomUsage_Type,
      anPropertyGroup            IN       iapiType.Id_Type,
      adExplosionDate            IN       iapiType.Date_Type DEFAULT SYSDATE,
      anIncludeInDevelopment     IN       iapiType.Boolean_Type DEFAULT 0,
      --AP01179955 oneLine
      anUseBomPath               IN       iapiType.Boolean_Type DEFAULT 0,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetClaimsLog(
      asPartNo                   IN       iapiType.PartNo_Type,
      aqClaimLogs                OUT      iapiType.Ref_Type,
      anRevision                 IN       iapiType.Revision_Type DEFAULT NULL,
      asPlant                    IN       iapiType.Plant_Type DEFAULT NULL,
      anAlternative              IN       iapiType.BomAlternative_Type DEFAULT NULL,
      anUsage                    IN       iapiType.BomUsage_Type DEFAULT NULL )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetClaimsLogResult(
      anLogId                    IN       iapiType.LogId_Type,
      aqClaimsLogResults         OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetExplosion(
      anUniqueId                 IN       iapiType.Sequence_Type,
      aqItems                    OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetInfoHeader(
      anColumn                   IN       iapiType.Id_Type,
      asDescription              OUT      iapiType.String_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetMaxClaimsPropertyGroupRev(
      anUniqueId                 IN       iapiType.Id_Type,
      anPropertyGroupId          IN       iapiType.Id_Type )
      RETURN iapiType.Revision_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetMaxClaimsPropertyRev(
      anUniqueId                 IN       iapiType.Id_Type,
      anPropertyId               IN       iapiType.Id_Type,
      anPropertyGroupId          IN       iapiType.Id_Type )
      RETURN iapiType.Revision_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetReportTypes(
      aqReportTypes              OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetResult(
      anUniqueId                 IN       iapiType.Sequence_Type,
      aqResult                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetResultDetails(
      anUniqueId                 IN       iapiType.Sequence_Type,
      aqResult                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SaveClaimsLog(
      anLogId                    IN       iapiType.LogId_Type,
      asLogName                  IN       iapiType.Description_Type,
      anStatus                   IN       iapiType.StatusId_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;
---------------------------------------------------------------------------
-- Pragmas
---------------------------------------------------------------------------
END iapiClaims;
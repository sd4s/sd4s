create or replace PACKAGE iapiReport
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiReport.h $
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract:
   --           Package contains functions to create,
   --           maintain and query reports
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
   gsSource                      iapiType.Source_Type := 'iapiReport';

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   FUNCTION AddRequestArgument(
      anRequestId                IN       iapiType.Id_Type,
      asArgument                 IN       iapiType.Argument_Type,
      asValue                    IN       iapiType.Value_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GenerateRequest(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asUserId                   IN       iapiType.UserId_Type,
      anLanguageId               IN       iapiType.LanguageId_Type,
      anMetric                   IN       iapiType.MetricId_Type,
      anReportId                 IN       iapiType.Id_Type,
      asCulture                  IN       iapiType.Culture_Type,
      asGuiLanguage              IN       iapiType.GuiLanguage_Type,
      anRequestId                OUT      iapiType.Id_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetBomLayout(
      anReportId                 IN       iapiType.Id_Type,
      aqLayout                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetDefaultTemplate(
      asType                     IN       iapiType.ReportItemType_Type,
      aqTemplate                 OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetGroups(
      asUserId                   IN       iapiType.UserId_Type,
      aqGroups                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetItemTypes(
      aqReportItemTypes          OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetLastModified(
      anReportId                 IN       iapiType.Id_Type,
      adDate                     OUT      iapiType.Date_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetNotOverruledItems(
      anReportId                 IN       iapiType.Id_Type,
      aqItems                    OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetOverruledItems(
      anReportId                 IN       iapiType.Id_Type,
      aqItems                    OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetReport(
      anReportId                 IN       iapiType.Id_Type,
      aqReport                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetReportDetails(
      anReportId                 IN       iapiType.Id_Type,
      aqReportDetails            OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetReports(
      asUserId                   IN       iapiType.UserId_Type,
      aqReports                  OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetRequestArguments(
      anRequestId                IN       iapiType.Id_Type,
      aqRequestArguments         OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetRequestDetails(
      anRequestId                IN       iapiType.Id_Type,
      aqRequestDetails           OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetUserReportGroupReports(
      asUserId                   IN       iapiType.UserId_Type,
      anReportGroupId            IN       iapiType.Id_Type,
      aqReports                  OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION RemoveRequest(
      anRequestId                IN       iapiType.Id_Type )
      RETURN iapiType.ErrorNum_Type;
---------------------------------------------------------------------------
-- Pragmas
---------------------------------------------------------------------------
END iapiReport;
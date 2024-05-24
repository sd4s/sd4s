create or replace PACKAGE iapiTransGlos
IS
---------------------------------------------------------------------------
-- $Workfile: iapiTransGloss.sql $
---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
---------------------------------------------------------------------------
--  Abstract:
--           This package contains
--           functionality to Save/Update/Delete  table_L using bulk collect
--           translate Status, Workflow_group, ITAddon, Workflow_group, ITKW, ITKWCH
--           We don't test the Session info
--           No audit trial
--           No revision
--           Table Name max VC2(30)
   ---------------------------------------------------------------------------
   FUNCTION GetPackageVersion
      RETURN iapiType.String_Type;


   -- $NoKeywords: $
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   -- Member variables
   ---------------------------------------------------------------------------
   gsSource                      iapiType.Source_Type := 'iapiTransGlos';
   gtErrors                      ErrorDataTable_Type := ErrorDataTable_Type( );

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------

    FUNCTION RemoveEmptyRow (
      asTableName                IN       IapiType.DatabaseObjectName_Type)
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION XmlTranslate(
      axTranslate                IN       iapiType.XmlType_Type,
      atTranslateDataTable       OUT      iapiType.TransGlosL_Type )
      RETURN iapiType.ErrorNum_Type;

  ---------------------------------------------------------------------------

   FUNCTION SaveTransL(
      asTableName                IN       IapiType.DatabaseObjectName_Type,
      asTransColumn              IN       Iapitype.DatabaseTableColumn_Type,
      axTranslate                IN       iapiType.XmlType_Type)
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------

   FUNCTION SaveTransL(
      asTableName                IN       IapiType.DatabaseObjectName_Type,
      asTransColumn              IN       Iapitype.DatabaseTableColumn_Type,
      atTranslate                IN       iapiType.TransGlosL_Type)
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------


END iapiTransGlos;
create or replace PACKAGE iapiTranslateL
IS
---------------------------------------------------------------------------
-- $Workfile: iapiTranslateL.sql $
---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
---------------------------------------------------------------------------
--  Abstract: This function saves/gets the description/short description of items
--            for a given language. There is no revision control
--            if the item isn't used in a frame or spec.

--           This package contains
--           functionality to handle (Get/Save) table_L
--           translate Status, Workflow_group, ITKW, ITADDON, ITKWCH
---------------------------------------------------------------------------

   ---------------------------------------------------------------------------

   -- $NoKeywords: $
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   -- Member variables
   ---------------------------------------------------------------------------
   gsSource                      iapiType.Source_Type := 'iapiTranslateL';

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   FUNCTION GetPackageVersion
      RETURN iapiType.String_Type;


   FUNCTION GetStatusL(
      anStatus                   IN       iapiType.StatusId_Type,
      aqstatus                  OUT       iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;
   ---------------------------------------------------------------------------------
   FUNCTION RemoveStatusL(
      anStatus                   IN       iapiType.StatusId_Type,
      anLangID                   IN       iapiType.LanguageId_Type )
      RETURN iapiType.ErrorNum_Type;
   ---------------------------------------------------------------------------
   FUNCTION SaveStatusL(
      anStatus                   IN       iapiType.StatusId_Type,
      asSortDesc                 IN       iapiType.ShortDescription_Type,
      asDescription              IN       iapiType.Description_Type,
      asEmailTitle               IN       iapiType.EmailSubject_Type,
      anLangID                   IN       iapiType.LanguageId_Type )
      RETURN iapiType.ErrorNum_Type;
   ---------------------------------------------------------------------------
   FUNCTION GetITAddonL(
      anAddonId                   IN       iapiType.Id_Type,
      aqAddon                    OUT       iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;
   -----------------------------------------------------------------------------
   FUNCTION RemoveITAddonL(
      anAddonId                  IN       iapiType.Id_Type,
      anLangID                   IN       iapiType.LanguageId_Type )
      RETURN iapiType.ErrorNum_Type;
   ----------------------------------------------------------------------------
   FUNCTION SaveITAddonL(
      anAddonId                  IN       iapiType.Id_Type,
      asDescription              IN       iapiType.Description_Type,
      anLangID                   IN       iapiType.LanguageId_Type )
      RETURN iapiType.ErrorNum_Type;

   ----------------------------------------------------------------------------
   FUNCTION GetWorkflowGL(
      anWorkflowGroupID                   IN       iapiType.Id_Type,
      aqWorkflowG                        OUT       iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ----------------------------------------------------------------------------
   FUNCTION RemoveWorkflowGL(
      anWorkflowGroupID            IN       iapiType.Id_Type,
      anLangID                   IN       iapiType.LanguageId_Type )
      RETURN iapiType.ErrorNum_Type;

   ----------------------------------------------------------------------------
   FUNCTION SaveWorkflowGL(
      anWorkflowGID              IN       iapiType.Id_Type,
      asSortDesc                 IN       iapiType.ShortDescription_Type,
      asDescription              IN       iapiType.Description_Type,
      anLangID                   IN       iapiType.LanguageId_Type )
      RETURN iapiType.ErrorNum_Type;

   ----------------------------------------------------------------------------
   FUNCTION GetITKWL(
      anKWId                   IN       iapiType.Id_Type,
      aqKW                    OUT       iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

  ----------------------------------------------------------------------------
  FUNCTION RemoveITKWL(
      anKWId                  IN       iapiType.Id_Type,
      anLangID                   IN       iapiType.LanguageId_Type )
      RETURN iapiType.ErrorNum_Type;

   ----------------------------------------------------------------------------
    FUNCTION SaveITKWL(
      anKWId                  IN       iapiType.Id_Type,
      asDescription              IN       iapiType.Description_Type,
      anLangID                   IN       iapiType.LanguageId_Type )
      RETURN iapiType.ErrorNum_Type;

   ----------------------------------------------------------------------------
   FUNCTION GetITKWCHL(
      anKWCHId                   IN       iapiType.Id_Type,
      aqKWCH                    OUT       iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ----------------------------------------------------------------------------
  FUNCTION RemoveITKWCHL(
      anKWCHId                   IN       iapiType.Id_Type,
      anLangID                   IN       iapiType.LanguageId_Type )
      RETURN iapiType.ErrorNum_Type;

   ----------------------------------------------------------------------------
    FUNCTION SaveITKWCHL(
      anKWCHId                   IN       iapiType.Id_Type,
      asDescription              IN       iapiType.Description_Type,
      anLangID                   IN       iapiType.LanguageId_Type )
      RETURN iapiType.ErrorNum_Type;

   ----------------------------------------------------------------------------
     FUNCTION GetAccessGL(
      anAccessGroup                      IN       iapiType.Id_Type,
      aqAccessG                         OUT       iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ----------------------------------------------------------------------------
   FUNCTION RemoveAccessGL(
      anAccessGroupID            IN       iapiType.Id_Type,
      anLangID                   IN       iapiType.LanguageId_Type )
      RETURN iapiType.ErrorNum_Type;

   ----------------------------------------------------------------------------
   FUNCTION SaveAccessGL(
      anAccessGID              IN       iapiType.Id_Type,
      asSortDesc                 IN       iapiType.ShortDescription_Type,
      asDescription              IN       iapiType.Description_Type,
      anLangID                   IN       iapiType.LanguageId_Type )
      RETURN iapiType.ErrorNum_Type;

   --AP01157684 Start
   ----------------------------------------------------------------------------
   FUNCTION GetRDStatusL(
      anStatusId                IN        iapiType.StatusId_Type,
      aqStatus                  OUT       iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;
   --AP01157684 End

   --AP01157684 Start
   ---------------------------------------------------------------------------------
   FUNCTION RemoveRDStatusL(
      anStatusId                 IN       iapiType.StatusId_Type,
      anLangID                   IN       iapiType.LanguageId_Type )
      RETURN iapiType.ErrorNum_Type;
   --AP01157684 End

   --AP01157684 Start
   ---------------------------------------------------------------------------
   FUNCTION SaveRDStatusL(
      anStatusId                 IN       iapiType.StatusId_Type,
      asShortDesc                IN       iapiType.ShortDescription_Type,
      asDescription              IN       iapiType.Description_Type,
      anLangID                   IN       iapiType.LanguageId_Type )
      RETURN iapiType.ErrorNum_Type;
   --AP01157684 End

END iapiTranslateL;
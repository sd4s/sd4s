create or replace PACKAGE iapiRuleSet
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiRuleSet.h $
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract:
   --           This package contains all
   --           functionality to handle nutritional rule sets
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
   gsSource                      iapiType.Source_Type := 'iapiRuleSet';

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   FUNCTION AddRuleSet(
      anRuleId                   IN OUT   iapiType.Sequence_Type,
      asName                     IN       iapiType.Name_Type,
      asDescription              IN       iapiType.Description_Type,
      adCreatedOn                IN       iapiType.Date_Type,
      anRuleType                 IN       iapiType.Sequence_Type,
      axRuleset                  IN       iapiType.XmlType_Type,
      anFramno                   IN       iapiType.FrameNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anIsDefault                IN       iapiType.Boolean_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ExistName(
      asName                     IN       iapiType.Name_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ExistRuleType(
      anRuleType                 IN       iapiType.Sequence_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetIdByName(
      asName                     IN       iapiType.Name_Type,
      anRuleId                   OUT      iapiType.Sequence_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetRuleSet(
      anRuleId                   IN       iapiType.Sequence_Type,
      aqRuleSets                 OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetRuleSets(
      anRuleType                 IN       iapiType.Sequence_Type,
      aqRuleSets                 OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION RemoveRuleSet(
      anRuleId                   IN       iapiType.Sequence_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SaveRuleSet(
      anRuleId                   IN       iapiType.Sequence_Type,
      asName                     IN       iapiType.Name_Type,
      asDescription              IN       iapiType.Description_Type,
      adCreatedOn                IN       iapiType.Date_Type,
      anRuleType                 IN       iapiType.Sequence_Type,
      axRuleset                  IN       iapiType.XmlType_Type,
      anFramno                   IN       iapiType.FrameNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anIsDefault                IN       iapiType.Boolean_Type )
      RETURN iapiType.ErrorNum_Type;
  ---------------------------------------------------------------------------
   FUNCTION GetRuleSetsDistFrame(
      anRuleType                 IN       iapiType.Sequence_Type,
      aqRuleSets                 OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

    ---------------------------------------------------------------------------
   FUNCTION GetRuleSetsForFrame(
      anRuleType                 IN       iapiType.Sequence_Type,
      anFrameNo                  IN       iapiType.FrameNo_Type,
      aqRuleSets                 OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
      FUNCTION SaveRuleSetDistFrame(
      anRuleId                   IN       iapiType.Sequence_Type,
      anRuleType                 IN       iapiType.Sequence_Type,
      anFramno                   IN       iapiType.FrameNo_Type)
      RETURN iapiType.ErrorNum_Type;
   -----------------------------------------------------------------------
      FUNCTION GetDefRuleSetsFrame(
--      anRuleType                 IN       iapiType.Sequence_Type,
      aqRuleSets                 OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;
---------------------------------------------------------------------------

-- Pragmas
---------------------------------------------------------------------------
END iapiRuleSet;
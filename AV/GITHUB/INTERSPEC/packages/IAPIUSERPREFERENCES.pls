create or replace PACKAGE iapiUserPreferences
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiUserPreferences.h $
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract:
   --           The package contains all functions to
   --           insert/modify/delete the user
   --           preferences.
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
   gsSource                      iapiType.Source_Type := 'iapiUserPreferences';

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   FUNCTION ExistDefaultPreference(
      asSectionName              IN       iapiType.PreferenceSectionName_Type,
      asPreferenceName           IN       iapiType.PreferenceName_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ExistUserPreference(
      asSectionName              IN       iapiType.PreferenceSectionName_Type,
      asPreferenceName           IN       iapiType.PreferenceName_Type,
      asUserId                   IN       iapiType.UserId_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ExistUserPreference(
      asSectionName              IN       iapiType.PreferenceSectionName_Type,
      asPreferenceName           IN       iapiType.PreferenceName_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetUserPreference(
      asSectionName              IN       iapiType.PreferenceSectionName_Type,
      asPreferenceName           IN       iapiType.PreferenceName_Type,
      asUserId                   IN       iapiType.UserId_Type,
      asPreferenceValue          OUT      iapiType.PreferenceValue_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetUserPreference(
      asSectionName              IN       iapiType.PreferenceSectionName_Type,
      asPreferenceName           IN       iapiType.PreferenceName_Type,
      asPreferenceValue          OUT      iapiType.PreferenceValue_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetUserPreferences(
      asUserId                   IN       iapiType.UserId_Type,
      aqUserPreferences          OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetUserPreferences(
      aqUserPreferences          OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION InitUserPreferences(
      asUserId                   IN       iapiType.UserId_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION RemoveUserPreferences(
      asUserId                   IN       iapiType.UserId_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SaveUserPreference(
      asSectionName              IN       iapiType.PreferenceSectionName_Type,
      asPreferenceName           IN       iapiType.PreferenceName_Type,
      asPreferenceValue          IN       iapiType.PreferenceValue_Type,
      asUserId                   IN       iapiType.UserId_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SaveUserPreference(
      asSectionName              IN       iapiType.PreferenceSectionName_Type,
      asPreferenceName           IN       iapiType.PreferenceName_Type,
      asPreferenceValue          IN       iapiType.PreferenceValue_Type )
      RETURN iapiType.ErrorNum_Type;
---------------------------------------------------------------------------
-- Pragmas
---------------------------------------------------------------------------
END iapiUserPreferences;
create or replace PACKAGE iapiIngredientGroups
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiIngredientGroups.h $
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract:
   --           This package contains all
   --           functionality to handle ingredient groups.
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
   gsSource                      iapiType.Source_Type := 'iapiIngredientGroups';

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   FUNCTION GetFunctions(
      anGroupId                  IN       iapiType.Id_Type,
      aqFunctions                OUT      iapiType.Ref_Type )
      RETURN iapiType.errornum_type;

   ---------------------------------------------------------------------------
   FUNCTION GetGroups(
      aqGroups                   OUT      iapiType.Ref_Type )
      RETURN iapiType.errornum_type;

   ---------------------------------------------------------------------------
   FUNCTION GetParentGroups(
      anGroupId                  IN       iapiType.Id_Type,
      aqParentGroups             OUT      iapiType.Ref_Type )
      RETURN iapiType.errornum_type;

   ---------------------------------------------------------------------------
   FUNCTION GetSubGroups(
      anGroupId                  IN       iapiType.Id_Type,
      aqSubGroups                OUT      iapiType.Ref_Type )
      RETURN iapiType.errornum_type;
---------------------------------------------------------------------------
-- Pragmas
---------------------------------------------------------------------------
END iapiIngredientGroups;
create or replace PACKAGE iapiUtilities
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiUtilities.h $
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract:
   --           This package contains all
   --           functionality to change owners and prefixes
   --           (after copy of database)
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
   gsSource                      iapiType.Source_Type := 'iapiUtilities';

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   FUNCTION ClassificationCheck(
      anDataType                 IN       iapiType.NumVal_Type DEFAULT 1 )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetArgumentType(
      asOwner                    IN       iapiType.StringVal_Type,
      asPackageName              IN       iapiType.StringVal_Type,
      asFunctionName             IN       iapiType.StringVal_Type,
      asArgumentName             IN       iapiType.StringVal_Type,
      anOverload                 IN       iapiType.NumVal_Type DEFAULT 0 )
      RETURN iapiType.StringVal_Type;

   ---------------------------------------------------------------------------
   PROCEDURE ReplacePrefix(
      asOldPrefix                IN       iapiType.Prefix_Type,
      asNewPrefix                IN       iapiType.Prefix_Type,
      asPaddingCharacter         IN       iapiType.StringVal_Type );

   ---------------------------------------------------------------------------
   PROCEDURE ResetDatabaseOwner(
      anOldOwnerId               IN       iapiType.Owner_Type,
      anNewOwnerId               IN       iapiType.Owner_Type );

   ---------------------------------------------------------------------------
   FUNCTION UpdateString(
      asOldValue                 IN       iapiType.StringVal_Type,
      asNewValue                 IN       iapiType.StringVal_Type )
      RETURN iapiType.ErrorNum_Type;
---------------------------------------------------------------------------
-- Pragmas
---------------------------------------------------------------------------
END iapiUtilities;
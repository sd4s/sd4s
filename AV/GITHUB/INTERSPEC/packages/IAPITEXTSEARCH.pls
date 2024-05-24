create or replace PACKAGE iapiTextSearch
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiTextSearch.h $
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
   gsSource                      iapiType.Source_Type := 'iapiTextSearch';

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   FUNCTION Search(
      anTextSearchNo             IN OUT   iapiType.sequence_type,
      asSearchText               IN       iapiType.StringVal_Type,
      anCaseSensitive            IN       iapiType.Boolean_Type,
      anUseMop                   IN       iapiType.Boolean_Type,
      asPlant                    IN       iapiType.Plant_Type,
      anSpecificationType        IN       iapiType.Id_Type,
      anStatus                   IN       iapiType.StatusId_Type,
      anReferenceType            IN       iapiType.NumVal_Type,
      anReferenceId              IN       iapiType.Id_Type,
      anReferenceOwner           IN       iapiType.Owner_Type,
      asSearchType               IN       iapiType.Search_Type )
      RETURN iapiType.ErrorNum_Type;
END iapiTextSearch;
create or replace PACKAGE iapiSubSection
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiSubSection.h $
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
   gsSource                      iapiType.Source_Type := 'iapiSubSection';

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   FUNCTION GetSubSectionId(
      asSubSection               IN       iapiType.Description_Type,
      anSubSectionId             OUT      iapiType.Id_Type )
      RETURN iapiType.ErrorNum_Type;
---------------------------------------------------------------------------
-- Pragmas
---------------------------------------------------------------------------
END iapiSubSection;
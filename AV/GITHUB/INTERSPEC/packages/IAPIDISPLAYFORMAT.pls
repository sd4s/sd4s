create or replace PACKAGE iapiDisplayFormat
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiDisplayFormat.h $
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract:
   --           This package contains all
   --           functionality for handling display formats.
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
   gsSource                      iapiType.Source_Type := 'iapiDisplayFormat';

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   FUNCTION CopyDisplayFormat(
      asType                     IN       iapiType.String_Type,
      anDisplayFormat            IN       iapiType.Id_Type,
      anRevision                 IN       iapiType.Revision_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION DuplicateDisplayFormat(
      asType                     IN       iapiType.String_Type,
      anDisplayFormatFrom        IN       iapiType.Id_Type,
      anDisplayFormatRevisionFrom IN      iapiType.Revision_Type,
      anDisplayFormatTo          IN       iapiType.Id_Type,
      asDescription              IN       iapiType.Description_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetHeaders(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anItemId                   IN       iapiType.Id_Type,
      anIncludedOnly             IN       iapitype.boolean_type DEFAULT 1,
      aqHeaders                  OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;
---------------------------------------------------------------------------
-- Pragmas
---------------------------------------------------------------------------
END iapiDisplayFormat;
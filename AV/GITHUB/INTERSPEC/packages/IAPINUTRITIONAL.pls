create or replace PACKAGE iapiNutritional
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiNutritional.h $
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
   gsSource                      iapiType.Source_Type := 'iapiNutritional';

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   FUNCTION ContributesToCalories(
      asNutritionalReference     IN       iapiType.NutRefType_Type,
      anPropertyId               IN       iapiType.Id_Type,
      anAttributeId              IN       iapiType.Id_Type )
      RETURN iapiType.Boolean_Type;

   ---------------------------------------------------------------------------
   PROCEDURE DeleteFootNote(
      anFootNoteId               IN       iapiType.Id_Type );

   ---------------------------------------------------------------------------
   PROCEDURE GetDisplayFormatColumns(
      aqDisplayFormatColumns     OUT      iapiType.Ref_Type );

   ---------------------------------------------------------------------------
   PROCEDURE GetFootNotes(
      anPanelId                  IN       iapiType.Id_Type,
      aqFootNotes                OUT      iapiType.Ref_Type );

   ---------------------------------------------------------------------------
   PROCEDURE GetFootNotesList(
      aqFootNotes                OUT      iapiType.Ref_Type );

   ---------------------------------------------------------------------------
   PROCEDURE GetNutrientInfo(
      asNutritionalReference     IN       iapiType.NutRefType_Type,
      aqNutrientInfo             OUT      iapiType.Ref_type );

   ---------------------------------------------------------------------------
   FUNCTION IsProperty(
      asNutritionalReference     IN       iapiType.NutRefType_Type,
      anFunctionId               IN       iapiType.Id_Type,
      anPropertyId               IN       iapiType.Id_Type,
      anAttributeId              IN       iapiType.Id_Type )
      RETURN iapiType.Boolean_Type;

   ---------------------------------------------------------------------------
   PROCEDURE SaveFootNote(
      anPanelId                  IN       iapiType.Id_Type,
      alFootNoteText             IN       iapiType.Clob_Type );
---------------------------------------------------------------------------
-- Pragmas
---------------------------------------------------------------------------
END iapiNutritional;
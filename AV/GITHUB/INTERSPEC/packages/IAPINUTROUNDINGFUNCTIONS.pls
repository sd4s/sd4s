create or replace PACKAGE iapiNutRoundingFunctions
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiNutRoundingFunctions.h $
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract:
   --           This package contains all nutritional
   --           rounding rule functions
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
   gsSource                      iapiType.Source_Type := 'iapiNutRoundingFunctions';

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   FUNCTION Energy(
      anValue                    IN       iapiType.Float_Type,
      asOutVal                   OUT      iapiType.String_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION General1(
      anValue                    IN       iapiType.Float_Type,
      asOutVal                   OUT      iapiType.String_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION General2(
      anValue                    IN       iapiType.Float_Type,
      asOutVal                   OUT      iapiType.String_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION General3(
      anValue                    IN       iapiType.Float_Type,
      asOutVal                   OUT      iapiType.String_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION General4(
      anValue                    IN       iapiType.Float_Type,
      asOutVal                   OUT      iapiType.String_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION Macronutrients(
      anValue                    IN       iapiType.Float_Type,
      asOutVal                   OUT      iapiType.String_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION Micronutrients(
      anValue                    IN       iapiType.Float_Type,
      asOutVal                   OUT      iapiType.String_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ParticularCase(
      anValue                    IN       iapiType.Float_Type,
      asOutVal                   OUT      iapiType.String_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION RDARule1(
      anValue                    IN       iapiType.Float_Type,
      asOutVal                   OUT      iapiType.String_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION RDARule2(
      anValue                    IN       iapiType.Float_Type,
      asOutVal                   OUT      iapiType.String_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION RDARule3(
      anValue                    IN       iapiType.Float_Type,
      asOutVal                   OUT      iapiType.String_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION Rule1(
      anValue                    IN       iapiType.Float_Type,
      asOutVal                   OUT      iapiType.String_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION Rule2(
      anValue                    IN       iapiType.Float_Type,
      asOutVal                   OUT      iapiType.String_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION Rule3(
      anValue                    IN       iapiType.Float_Type,
      asOutVal                   OUT      iapiType.String_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION Rule4(
      anValue                    IN       iapiType.Float_Type,
      asOutVal                   OUT      iapiType.String_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION Rule5a(
      anValue                    IN       iapiType.Float_Type,
      asOutVal                   OUT      iapiType.String_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION Rule5b(
      anValue                    IN       iapiType.Float_Type,
      asOutVal                   OUT      iapiType.String_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION Rule6(
      anValue                    IN       iapiType.Float_Type,
      asOutVal                   OUT      iapiType.String_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION Rule7(
      anValue                    IN       iapiType.Float_Type,
      asOutVal                   OUT      iapiType.String_Type )
      RETURN iapiType.ErrorNum_Type;
---------------------------------------------------------------------------
-- Pragmas
---------------------------------------------------------------------------
END iapiNutRoundingFunctions;
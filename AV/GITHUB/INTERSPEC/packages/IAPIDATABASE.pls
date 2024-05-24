create or replace PACKAGE iapiDatabase
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiDatabase.h $
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract:
   --           This package contains all
   --           functionality to maintain/modify the database.
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
   gsSource                      iapiType.Source_Type := 'iapiDatabase';

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   FUNCTION COMPILE(
      asObjectName               IN       iapiType.DatabaseObjectName_Type )
      RETURN iapiType.ErrorNum_type;

   ---------------------------------------------------------------------------
   FUNCTION CompileInvalidAll
      RETURN iapiType.ErrorNum_type;

   ---------------------------------------------------------------------------
   FUNCTION CompileInvalidFunctions
      RETURN iapiType.ErrorNum_type;

   ---------------------------------------------------------------------------
   FUNCTION CompileInvalidPackages
      RETURN iapiType.ErrorNum_type;

   ---------------------------------------------------------------------------
   FUNCTION CompileInvalidSynonyms
      RETURN iapiType.ErrorNum_type;

   ---------------------------------------------------------------------------
   FUNCTION CompileInvalidProcedures
      RETURN iapiType.ErrorNum_type;

   ---------------------------------------------------------------------------
   FUNCTION CompileInvalidTriggers
      RETURN iapiType.ErrorNum_type;

   ---------------------------------------------------------------------------
   FUNCTION CompileInvalidViews
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION CreateSynonyms
      RETURN iapiType.ErrorNum_type;

   ---------------------------------------------------------------------------
   FUNCTION DisableConstraints
      RETURN iapiType.ErrorNum_type;

   ---------------------------------------------------------------------------
   FUNCTION DisableTriggers
      RETURN iapiType.ErrorNum_type;

   ---------------------------------------------------------------------------
   FUNCTION DropSynonyms
      RETURN iapiType.ErrorNum_type;

   ---------------------------------------------------------------------------
   FUNCTION DropTriggers
      RETURN iapiType.ErrorNum_type;

   ---------------------------------------------------------------------------
   FUNCTION EnableConstraints
      RETURN iapiType.ErrorNum_type;

   ---------------------------------------------------------------------------
   FUNCTION EnableTriggers
      RETURN iapiType.ErrorNum_type;

   ---------------------------------------------------------------------------
   FUNCTION GetMaxOpenCursors(
      anMaxOpenCursors           OUT      iapiType.NumVal_Type )
      RETURN iapiType.ErrorNum_type;

   ---------------------------------------------------------------------------
   FUNCTION GetSchemaName(
      asSchemaName               OUT      iapiType.DatabaseSchemaName_Type )
      RETURN iapiType.ErrorNum_type;

   ---------------------------------------------------------------------------
   FUNCTION GrantTableAll
      RETURN iapiType.ErrorNum_type;

   ---------------------------------------------------------------------------
   FUNCTION RecreateSynonyms
      RETURN iapiType.ErrorNum_type;
---------------------------------------------------------------------------
-- Pragmas
---------------------------------------------------------------------------
END iapiDatabase;
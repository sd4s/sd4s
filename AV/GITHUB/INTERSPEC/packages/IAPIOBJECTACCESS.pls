create or replace PACKAGE iapiObjectAccess
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiObjectAccess.h $
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract:
   --           This package contains a number of
   --           procedures and function to retrieve
   --           access settings.
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
   gsSource                      iapiType.Source_Type := 'iapiObjectAccess';

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   FUNCTION GetViewAccess(
      anObjectId                 IN       iapiType.Id_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anOwner                    IN       iapiType.Owner_Type,
      anAccess                   OUT      iapiType.Boolean_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetBasicAccess(
      anObjectId                 IN       iapiType.Id_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anOwner                    IN       iapiType.Owner_Type,
      anModeIndependant          IN       iapiType.Boolean_Type DEFAULT 0,
      anAccess                   OUT      iapiType.Boolean_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetStatusIndepModifiableAccess(
      anObjectId                 IN       iapiType.Id_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anOwner                    IN       iapiType.Owner_Type,
      anModeIndependant          IN       iapiType.Boolean_Type DEFAULT 0,
      anAccess                   OUT      iapiType.Boolean_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetModifiableAccess(
      anObjectId                 IN       iapiType.Id_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anOwner                    IN       iapiType.Owner_Type,
      anAccess                   OUT      iapiType.Boolean_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetModeIndepModifiableAccess(
      anObjectId                 IN       iapiType.Id_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anOwner                    IN       iapiType.Owner_Type,
      anAccess                   OUT      iapiType.Boolean_Type )
      RETURN iapiType.ErrorNum_Type;
END iapiObjectAccess;
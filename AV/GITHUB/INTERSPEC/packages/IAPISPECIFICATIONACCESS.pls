create or replace PACKAGE iapiSpecificationAccess
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiSpecificationAccess.h $
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
   gsSource                      iapiType.Source_Type := 'iapiSpecificationAccess';
   --AP00909916
   gARCacheEnabled               NUMBER(3) := 0;

   --AP00909916 Start
   TYPE ARCache_Type IS TABLE OF iapiType.Boolean_Type INDEX BY VARCHAR2(1024);
   AR_Cache ARCache_Type;
   --AP00909916 End

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------

   --AP00909916
   ---------------------------------------------------------------------------
    PROCEDURE EnableARCache;

    --AP00909916
    ---------------------------------------------------------------------------
    PROCEDURE DisableARCache;

    --AP00909916
    ---------------------------------------------------------------------------
    FUNCTION GetFromARCache(
        asObject_id IN VARCHAR2,
        anAccess OUT IAPITYPE.BOOLEAN_TYPE)
        RETURN iapiType.ErrorNum_Type;

    --AP00909916
    ---------------------------------------------------------------------------
    PROCEDURE WriteToARCache(
        asObject_id IN VARCHAR2,
        anAccess IN IAPITYPE.BOOLEAN_TYPE);

   ---------------------------------------------------------------------------
   FUNCTION GetViewAccess(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anAccess                   OUT      iapiType.Boolean_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetBasicAccess(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anModeIndependant          IN       iapiType.Boolean_Type DEFAULT 0,
      anAccess                   OUT      iapiType.Boolean_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetStatusIndepModifiableAccess(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anModeIndependant          IN       iapiType.Boolean_Type DEFAULT 0,
      anAccess                   OUT      iapiType.Boolean_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetModifiableAccess(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anAccess                   OUT      iapiType.Boolean_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetModifiableAccess(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anAccess                   OUT      iapiType.Boolean_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetProductionMrpAccess(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anAccess                   OUT      iapiType.Boolean_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetPlanningMrpAccess(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anAccess                   OUT      iapiType.Boolean_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetPhaseMrpAccess(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anAccess                   OUT      iapiType.Boolean_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetModeIndepModifiableAccess(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anAccess                   OUT      iapiType.Boolean_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------

   FUNCTION CrossGetLock(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asUserId                   OUT      iapiType.UserId_Type )
      RETURN iapiType.ErrorNum_Type;

END iapiSpecificationAccess;
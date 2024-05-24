create or replace PACKAGE iapiUsers
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiUsers.h $
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   --   $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --   $Modtime: 2014-May-05 12:00 $
	 --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract:
   --           This package contains all
   --           functionality to handle users
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
   gsSource                      iapiType.Source_Type := 'iapiUsers';
   gtErrors                      ErrorDataTable_Type := ErrorDataTable_Type( );
   giReturn                      PLS_INTEGER;
   gsSqlString                   iapiType.Buffer_Type;
   giResult                      PLS_INTEGER;

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   FUNCTION AddApplicationUser(
      asUser                     IN       iapiType.UserId_Type,
      asForeName                 IN       iapiType.ForeName_Type,
      asLastName                 IN       iapiType.LastName_Type,
      asUserInitials             IN       iapiType.Initials_Type,
      asTelephone_no             IN       iapiType.Telephone_Type,
      asEmailAddress             IN       iapiType.EmailAddress_Type,
      anCurrentOnly              IN       iapiType.Boolean_Type DEFAULT 0,
      asInitialProfile           IN       iapiType.InitialProfile_Type,
      asUserProfile              IN       iapiType.UserProfile_Type,
      anUserDropped              IN       iapiType.Boolean_Type,
      anProdAccess               IN       iapiType.Boolean_Type DEFAULT 0,
      anPlanAccess               IN       iapiType.Boolean_Type DEFAULT 0,
      anPhaseAccess              IN       iapiType.Boolean_Type DEFAULT 0,
      anPrintingAllowed          IN       iapiType.Boolean_Type DEFAULT 1,
      anIntl                     IN       iapiType.Boolean_Type DEFAULT 0,
      anReferenceText            IN       iapiType.Boolean_Type DEFAULT 1,
      anApprovedOnly             IN       iapiType.Boolean_Type DEFAULT 0,
      anLocId                    IN       iapiType.LocId_Type,
      anCatId                    IN       iapiType.CatId_Type,
      anOverridePartVal          IN       iapiType.Boolean_Type DEFAULT 0,
      anWebAllowed               IN       iapiType.Boolean_Type DEFAULT 1,
      anLimitedConfigurator      IN       iapiType.Boolean_Type DEFAULT 0,
      anPlantAccess              IN       iapiType.Boolean_Type DEFAULT 0,
      anViewBom                  IN       iapiType.Boolean_Type DEFAULT 1,
      anViewPrice                IN       iapiType.Boolean_Type DEFAULT 1,
      anOptionalData             IN       iapiType.Boolean_Type DEFAULT 0,
      anExternal                 IN       iapiType.Boolean_Type DEFAULT 0,
      anGlobal                   IN       iapiType.Boolean_Type DEFAULT 0,
      anHistoricOnly             IN       iapiType.Boolean_Type DEFAULT 0,
      anUnlockingRight           IN       iapiType.Boolean_Type DEFAULT 0,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION AddUser(
      asUser                     IN       iapiType.UserId_Type,
      anExternal                 IN       iapiType.Boolean_Type,
      anGlobal                   IN       iapiType.Boolean_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ExistId(
      asUser                     IN       iapiType.UserId_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetApplicationUser(
      asUser                     IN       iapiType.UserId_Type,
      aqUser                     OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetApplicationUsers(
      axDefaultFilter            IN       iapiType.XmlType_Type,
      aqUser                     OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetApplicationUsers(
      atDefaultFilter            IN       iapiType.FilterTab_Type,
      aqUser                     OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetApplicationUsersPb(
      axDefaultFilter            IN       iapiType.XmlString_Type,
      aqUser                     OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetGracePeriodInDays(
      anDays                     OUT      iapiType.NumVal_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetUserDescription(
      asUser                     IN       iapiType.UserId_Type,
      asName                     OUT      iapiType.Description_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION IsExternal(
      asUser                     IN       iapiType.UserId_Type )
      RETURN iapiType.Boolean_Type;

   ---------------------------------------------------------------------------
   FUNCTION IsGlobal(
      asUser                     IN       iapiType.UserId_Type )
      RETURN iapiType.Boolean_Type;

   ---------------------------------------------------------------------------
   FUNCTION RemoveApplicationUser(
      asUser                     IN       iapiType.UserId_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION RemoveFromUserGroups(
      asUser                     IN       iapiType.UserId_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION RemoveUser(
      asUser                     IN       iapiType.UserId_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SaveApplicationUser(
      asUser                     IN       iapiType.UserId_Type,
      asForeName                 IN       iapiType.ForeName_Type,
      asLastName                 IN       iapiType.LastName_Type,
      asUserInitials             IN       iapiType.Initials_Type,
      asTelephone_no             IN       iapiType.Telephone_Type,
      asEmailAddress             IN       iapiType.EmailAddress_Type,
      anCurrentOnly              IN       iapiType.Boolean_Type DEFAULT 0,
      asInitialProfile           IN       iapiType.InitialProfile_Type,
      asUserProfile              IN       iapiType.UserProfile_Type,
      anUserDropped              IN       iapiType.Boolean_Type,
      anProdAccess               IN       iapiType.Boolean_Type DEFAULT 0,
      anPlanAccess               IN       iapiType.Boolean_Type DEFAULT 0,
      anPhaseAccess              IN       iapiType.Boolean_Type DEFAULT 0,
      anPrintingAllowed          IN       iapiType.Boolean_Type DEFAULT 1,
      anIntl                     IN       iapiType.Boolean_Type DEFAULT 0,
      anReferenceText            IN       iapiType.Boolean_Type DEFAULT 1,
      anApprovedOnly             IN       iapiType.Boolean_Type DEFAULT 0,
      anLocId                    IN       iapiType.LocId_Type,
      anCatId                    IN       iapiType.CatId_Type,
      anOverridePartVal          IN       iapiType.Boolean_Type DEFAULT 0,
      anWebAllowed               IN       iapiType.Boolean_Type DEFAULT 1,
      anLimitedConfigurator      IN       iapiType.Boolean_Type DEFAULT 0,
      anPlantAccess              IN       iapiType.Boolean_Type DEFAULT 0,
      anViewBom                  IN       iapiType.Boolean_Type DEFAULT 1,
      anViewPrice                IN       iapiType.Boolean_Type DEFAULT 1,
      anOptionalData             IN       iapiType.Boolean_Type DEFAULT 0,
      anExternal                 IN       iapiType.Boolean_Type DEFAULT 0,
      anGlobal                   IN       iapiType.Boolean_Type DEFAULT 0,
      anHistoricOnly             IN       iapiType.Boolean_Type DEFAULT 0,
      anUnlockingRight           IN       iapiType.Boolean_Type DEFAULT 0,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;
  ---------------------------------------------------------------------------
    FUNCTION CheckPassword(
      asUser                     IN       iapiType.UserId_Type,
      asPassword                 IN       iapiType.StringVal_Type )
      RETURN iapiType.ErrorNum_Type;
  ---------------------------------------------------------------------------
   FUNCTION SavePassword(
      asUser                     IN       iapiType.UserId_Type,
      asPassword                 IN       iapiType.StringVal_Type DEFAULT NULL,
      anSentEMail                IN       iapiType.NumVal_Type DEFAULT 0,
      anExpire                   IN       iapiType.NumVal_Type DEFAULT 0,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SaveProfile(
      asUser                     IN       iapiType.UserId_Type,
      asInitialProfile           IN       iapiType.InitialProfile_Type,
      asUserProfile              IN       iapiType.InitialProfile_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   --IS208 Start
   ---------------------------------------------------------------------------
   FUNCTION LogPasswordReset(
      asUser                     IN       iapiType.UserId_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;
   --IS208 End
---------------------------------------------------------------------------
-- Pragmas
---------------------------------------------------------------------------
END iapiUsers;
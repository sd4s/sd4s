create or replace PACKAGE iapiWorkFlow
IS
---------------------------------------------------------------------------
--  Workfile: iapiWorkFlow.sql
---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
---------------------------------------------------------------------------
--  Abstract: This package contains functionality to maintain statuses.
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
   gsSource                      iapiType.Source_Type := 'iapiWorkFlow';

---------------------------------------------------------------------------
-- Public procedures and functions
---------------------------------------------------------------------------
---------------------------------------------------------------------------
   --IS641 - TC_Cleaning
   --FUNCTION GetStatusType(
   --   asStatusType               IN       iapiType.StatusType_Type,
   --   asSendToTC                 OUT      iapiType.SingleVarChar_Type )
   --   RETURN iapiType.ErrorNum_Type;

   FUNCTION GetStatusTypes(
      aqStatusTypes              OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   --IS641 - TC_Cleaning
   --FUNCTION SetStatusType(
   --   asStatusType               IN       iapiType.StatusType_Type,
   --   asSendToTC                 IN       iapiType.SingleVarChar_Type )
   --   RETURN iapiType.ErrorNum_Type;
END iapiWorkFlow;
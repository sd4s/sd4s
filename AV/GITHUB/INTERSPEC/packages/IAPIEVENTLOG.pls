create or replace PACKAGE iapiEventLog
IS
   ---------------------------------------------------------------------------
   --  Abstract: This package contains all general functionality to maintain the
   --            association between a specification and a TC item.
   --
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
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
   gsSource                      iapiType.Source_Type := 'iapiSpecificationHeader';

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   FUNCTION AddEventLog(
      anEventId                  IN       iapiType.NumVal_Type,
      asTransmType               IN       iapiType.SingleVarChar_Type,
      asMsg                      IN       iapiType.Buffer_Type,
      adCreatedOn                IN       iapiType.Date_Type DEFAULT SYSDATE )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ExistId(
      anEventId                  IN       iapiType.NumVal_Type,
      asTransmType               IN       iapiType.SingleVarChar_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetEventLog(
      anEventId                  IN       iapiType.NumVal_Type,
      asTransmType               IN       iapiType.SingleVarChar_Type,
      asMsg                      OUT      iapiType.Buffer_Type,
      adCreatedOn                OUT      iapiType.Date_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetEventLogs(
      aqEventLogs                OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION RemoveEventLog(
      anEventId                  IN       iapiType.NumVal_Type,
      asTransmType               IN       iapiType.SingleVarChar_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SaveEventLog(
      anEventId                  IN       iapiType.NumVal_Type,
      asTransmType               IN       iapiType.SingleVarChar_Type,
      asMsg                      IN       iapiType.Buffer_Type,
      adCreatedOn                IN       iapiType.Date_Type DEFAULT SYSDATE )
      RETURN iapiType.ErrorNum_Type;
   ---------------------------------------------------------------------------
-- Pragmas
---------------------------------------------------------------------------
END iapiEventLog;
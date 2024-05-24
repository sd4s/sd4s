create or replace PACKAGE iapiEvent
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiEvent.h $
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract:
   --           This package contains all
   --           functionality for the event mechanism of SIMATIC
   --           IT Interspec
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
   gsSource                      iapiType.Source_Type := 'iapiEvent';
   gtErrors                      ErrorDataTable_Type := ErrorDataTable_Type( );

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   FUNCTION DeleteHandledEvents(
      asEvServiceName            IN       iapiType.StringVal_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ExistEventType4Service(
      asEvServiceName            IN       iapiType.StringVal_Type,
      anEventTypeId              IN       iapiType.Id_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetEvent(
      anEventId                  IN       iapiType.Id_Type,
      aqEvent                    OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetEvents(
      aqEvents                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetServiceEvents(
      asEvServiceName            IN       iapiType.StringVal_Type,
      aqEvents                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION RegisterEventService(
      asEvServiceName            IN       iapiType.StringVal_Type,
      anEventTypeId              IN       iapiType.Id_Type DEFAULT 0 )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SinkEvent(
      anEventId                  IN       iapiType.Id_Type,
      asEvDetails                IN       iapiType.String_Type,
      alEvData                   IN       iapiType.Clob_Type DEFAULT NULL )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION UnRegisterEventService(
      asEvServiceName            IN       iapiType.StringVal_Type,
      anEventTypeId              IN       iapiType.Id_Type DEFAULT 0 )
      RETURN iapiType.ErrorNum_Type;
---------------------------------------------------------------------------
-- Pragmas
---------------------------------------------------------------------------
END iapiEvent;
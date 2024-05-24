create or replace PACKAGE iapiSpecDataServer
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiSpecDataServer.h $
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract:
   --           Package to check if there is specdata
   --           available for the specifications.
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
   gsSource                      iapiType.Source_Type := 'iapiSpecDataServer';

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   FUNCTION InsertSpecDataCheck
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION IsSpecServerRunning
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION StartSpecServer(
      asUpdateStatus             IN       iapiType.Boolean_Type DEFAULT '1' )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION StopSpecServer(
      asUpdateStatus             IN       iapiType.Boolean_Type DEFAULT '1' )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   PROCEDURE ConvertFrame(
      asFrameNo                  IN       iapiType.FrameNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anOwner                    IN       iapiType.Owner_Type );

   ---------------------------------------------------------------------------
   PROCEDURE ConvertSpecification(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type );

   ---------------------------------------------------------------------------
   PROCEDURE RunSpecServer(
      asJobName                  IN       iapiType.String_Type );
---------------------------------------------------------------------------
-- Pragmas
---------------------------------------------------------------------------
END iapiSpecDataServer;
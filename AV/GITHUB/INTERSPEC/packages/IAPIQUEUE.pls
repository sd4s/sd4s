create or replace PACKAGE iapiQueue
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiQueue.h $
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract:
   --           This package contains all
   --           procedures/functions to start/stop/update Multi
   --           Operations (MOP).
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
   gsSource                      iapiType.Source_Type := 'iapiQueue';
   gsMopJob                      iapiType.String_Type := 'iapiQueue.ExecuteQueue';
   gsMopJobName                  iapiType.String_Type := 'DB_Q';
   --AP01360240 oneLine
   gnMaxLength                   NUMBER := 1024;  --by default set it to the size of the ITJOBQ.ERROR_MSG field

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   FUNCTION AddToQueue(
      asJob                      IN       iapiType.Job_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION CancelQueue
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION CheckQueue
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION EditQueue(
      asPartNo                   IN       iapiType.PartNoTab_Type,
      anRevision                 IN       iapiType.RevisionTab_Type,
      anNbrParts                 IN       iapiType.NumVal_Type,
      asAction                   IN       iapiType.Action_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   PROCEDURE ExecuteQueue;

   ---------------------------------------------------------------------------
   FUNCTION GetMaxRev
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION StartQueue
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION StopQueue
      RETURN iapiType.ErrorNum_Type;
---------------------------------------------------------------------------
-- Pragmas
---------------------------------------------------------------------------
END iapiQueue;
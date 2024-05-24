create or replace PACKAGE iapiEmail
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiEmail.h $
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract:
   --           This package contains all the
   --           functions to handle e-mails.
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
   gsSource                      iapiType.Source_Type := 'iapiEmail';
   gtErrors                      ErrorDataTable_Type := ErrorDataTable_Type( );

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   FUNCTION GetMail(
      anEmailNo                  IN       iapiType.EmailNo_Type,
      asSubject                  IN OUT   iapiType.EmailSubject_Type,
      asBody                     IN OUT   iapiType.Clob_Type,
      atRecipients               IN OUT   iapiType.EmailToTab_Type,
      anNumberRecipients         OUT      iapiType.NumVal_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION RegisterEmail(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anStatus                   IN       iapiType.StatusId_Type,
      adPlannedEffectiveDate     IN       iapiType.Date_Type,
      asEmailType                IN       iapiType.EmailType_Type DEFAULT 'S',
      asUserid                   IN       iapiType.UserId_Type,
      asPassword                 IN       iapiType.Password_Type,
      anReasonId                 IN       iapiType.Id_Type,
      anExemptionNo              IN       iapiType.NumVal_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_type;

   ---------------------------------------------------------------------------
   FUNCTION RegisterEmail(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anStatus                   IN       iapiType.StatusId_Type,
      adPlannedEffectiveDate     IN       iapiType.Date_Type,
      asEmailType                IN       iapiType.EmailType_Type DEFAULT 'S',
      asUserid                   IN       iapiType.UserId_Type,
      asPassword                 IN       iapiType.Password_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_type;

   ---------------------------------------------------------------------------
   FUNCTION SendEmail(
      asSender                   IN       iapiType.EmailSender_Type,
      atRecipients               IN       iapiType.EmailToTab_Type,
      asSubject                  IN       iapiType.EmailSubject_Type,
      asBody                     IN       iapiType.Clob_Type,
      anNumberRecipients         IN       iapiType.NumVal_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SendEmails
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION StartJob
      RETURN iapiType.ErrorNum_type;

   ---------------------------------------------------------------------------
   FUNCTION StopJob
      RETURN iapiType.ErrorNum_type;

   --AP00972365 Start
   ---------------------------------------------------------------------------
   FUNCTION IsValidEmailAddress(
      asEmailAddress IN iapiType.EmailTo_Type)
      RETURN BOOLEAN;
   --AP00972365 End
---------------------------------------------------------------------------
-- Pragmas
---------------------------------------------------------------------------
END iapiEmail;
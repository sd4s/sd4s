create or replace PACKAGE iapiElectronicSignature
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiElectronicSignature.h $
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract:
   --           Electronic Signature handling
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
   gsSource                      iapiType.Source_Type := 'iapiElectronicSignature';

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   FUNCTION CreateLogging(
      asType                     IN       iapiType.ElectronicSignatureType_Type,
      asUserId                   IN       iapiType.UserId_Type,
      asSignForId                IN       iapiType.ElectronicSignatureForId_Type,
      asSignFor                  IN       iapiType.ElectronicSignatureFor_Type,
      asSignWhatId               IN       iapiType.ElectronicSignatureWhatId_Type,
      asSignWhat                 IN       iapiType.ElectronicSignatureWhat_Type,
      anSuccess                  IN       iapiType.Numval_Type,
      asSuccessDescr             IN       iapiType.String_Type,
      anEsSeqNo                  OUT      iapiType.SequenceNr_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION LogObjectImage(
      anObjectId                 IN       iapiType.Id_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anOwner                    IN       iapiType.Owner_Type,
      anEsSeqNo                  IN       iapiType.SequenceNr_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION LogReferenceText(
      anRefTextType              IN       iapiType.Id_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anOwner                    IN       iapiType.Owner_Type,
      anEsSeqNo                  IN       iapiType.SequenceNr_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION LogSpecification(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anEsSeqNo                  IN       iapiType.SequenceNr_Type )
      RETURN iapiType.ErrorNum_Type;
---------------------------------------------------------------------------
-- Pragmas
---------------------------------------------------------------------------
END iapiElectronicSignature;
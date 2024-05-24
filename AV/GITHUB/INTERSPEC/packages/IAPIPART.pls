create or replace PACKAGE iapiPart
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiPart.h $
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract:
   --           This package contains all
   --           functionality to maintain parts.
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
   gsSource                      iapiType.Source_Type := 'iapiPart';
   gtParts                       iapiType.PartTab_Type;
   gtErrors                      ErrorDataTable_Type := ErrorDataTable_Type( );
   gtGetParts                    spPartTable_Type := spPartTable_Type( );
   gtDefaultFilter               iapiType.FilterTab_Type;
   gtPlantFilter                 iapiType.FilterTab_Type;
   --AP00975583
   gsUomDescription              iapiType.Description_Type;

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   FUNCTION AddPart(
      asPartNo                   IN OUT   iapiType.PartNo_Type,
      asDescription              IN       iapiType.Description_Type,
      asBaseUom                  IN       iapiType.BaseUom_Type,
      asBaseToUnit               IN       iapiType.BaseToUnit_Type DEFAULT NULL,
      anBaseConvFactor           IN       iapiType.NumVal_Type DEFAULT NULL,
      asPartSource               IN       iapiType.PartSource_Type,
      anPartTypeId               IN       iapiType.Id_Type DEFAULT NULL,
      asEanUpcBarcode            IN       iapiType.PartNo_Type DEFAULT NULL,
      anObsolete                 IN       iapiType.Boolean_Type DEFAULT NULL,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_type;

   ---------------------------------------------------------------------------
   FUNCTION AddPartPb(
      asPartNo                   IN       iapiType.PartNo_Type,
      asDescription              IN       iapiType.Description_Type,
      asBaseUom                  IN       iapiType.BaseUom_Type,
      asBaseToUnit               IN       iapiType.BaseToUnit_Type DEFAULT NULL,
      anBaseConvFactor           IN       iapiType.NumVal_Type DEFAULT NULL,
      asPartSource               IN       iapiType.PartSource_Type,
      anPartTypeId               IN       iapiType.Id_Type DEFAULT NULL,
      asEanUpcBarcode            IN       iapiType.PartNo_Type DEFAULT NULL,
      anObsolete                 IN       iapiType.Boolean_Type DEFAULT NULL,
      aqPartNo                   OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ChangePartType(
      asPartNo                   IN       iapiType.PartNo_Type,
      anPartTypeId               IN       iapiType.Id_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION CheckPart(
      asFromPartNo               IN       iapiType.PartNo_Type,
      anFromRevision             IN       iapiType.Revision_Type,
      anFromMaxRev               IN OUT   iapiType.Revision_Type,
      asToPartNo                 IN       iapiType.PartNo_Type,
      anToRevision               IN OUT   iapiType.Revision_Type,
      anInDevRev                 IN OUT   iapiType.Revision_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION CreateFilter(
      anFilterId                 IN OUT   iapiType.FilterId_Type,
      anArray                    IN       iapiType.NumVal_Type,
      atColumn                   IN       iapiType.CharTab_Type,
      atOperator                 IN       iapiType.CharTab_Type,
      atValueChar                IN       iapiType.CharTab_Type,
      atValueDate                IN       iapiType.DateTab_Type,
      asSortDesc                 IN       iapiType.ShortDescription_Type,
      asComment                  IN       iapiType.FilterDescription_Type,
      anOverwrite                IN       iapiType.Boolean_Type,
      anOptions                  IN       iapiType.NumVal_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION CreateSequence(
      anStartRange               IN       iapiType.NumVal_Type,
      anEndRange                 IN       iapiType.NumVal_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ExistId(
      asPartNo                   IN       iapiType.PartNo_Type )
      RETURN iapiType.ErrorNum_type;

   ---------------------------------------------------------------------------
   FUNCTION GetPart(
      asPartNo                   IN       iapiType.PartNo_Type,
      aqPart                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_type;

   ---------------------------------------------------------------------------
   FUNCTION GetParts(
      atDefaultFilter            IN       iapiType.FilterTab_Type,
      atPlantFilter              IN       iapiType.FilterTab_Type,
      aqParts                    OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetParts(
      axDefaultFilter            IN       iapiType.XmlType_Type,
      axPlantFilter              IN       iapiType.XmlType_Type,
      aqParts                    OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION InitialiseNewSpec(
      asPartNo                   OUT      iapiType.PartNo_Type,
      asDescription              OUT      iapiType.Description_Type,
      anPartTypeId               OUT      iapiType.Id_Type,
      asBaseUom                  OUT      iapiType.BaseUom_Type,
      anBaseConvFactor           OUT      iapiType.NumVal_Type,
      asBaseToUnit               OUT      iapiType.BaseToUnit_Type,
      asPartSource               OUT      iapiType.PartSource_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION PartUsedInSpecification(
      asPartNo                   IN       iapiType.PartNo_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION RemovePart(
      asPartNo                   IN       iapiType.PartNo_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_type;

   ---------------------------------------------------------------------------
   FUNCTION SavePart(
      asPartNo                   IN       iapiType.PartNo_Type,
      asDescription              IN       iapiType.Description_Type,
      asBaseUom                  IN       iapiType.BaseUom_Type,
      asBaseToUnit               IN       iapiType.BaseToUnit_Type DEFAULT NULL,
      anBaseConvFactor           IN       iapiType.NumVal_Type DEFAULT NULL,
      asPartSource               IN       iapiType.PartSource_Type,
      anPartTypeId               IN       iapiType.Id_Type DEFAULT NULL,
      adDateImported             IN       iapiType.Date_Type DEFAULT NULL,
      asEanUpcBarcode            IN       iapiType.PartNo_Type DEFAULT NULL,
      anObsolete                 IN       iapiType.Boolean_Type DEFAULT NULL,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_type;

   ---------------------------------------------------------------------------
   FUNCTION ValidateBom(
      asFromPartNo               IN       iapiType.PartNo_Type,
      anFromRevision             IN       iapiType.Revision_Type,
      asToPartNo                 IN       iapiType.PartNo_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ValidateNewSpec(
      asPartNo                   IN       iapiType.PartNo_Type,
      asDescription              IN       iapiType.Description_Type,
      anPartTypeId               IN       iapiType.Id_Type,
      asBaseUom                  IN       iapiType.BaseUom_Type,
      anBaseConvFactor           IN       iapiType.NumVal_Type,
      asBaseToUnit               IN       iapiType.BaseToUnit_Type,
      asPartSource               IN       iapiType.PartSource_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ValidatePart(
      asPartNo                   IN       iapiType.PartNo_Type )
      RETURN iapiType.ErrorNum_Type;
---------------------------------------------------------------------------
-- Pragmas
---------------------------------------------------------------------------
END iapiPart;
create or replace PACKAGE iapiUomGroups
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiUomGroups.h $
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract:
   --           This package contains all functionality to maintain the UOM
   --           Group and relationship between UOM group and UOM (conversion factor ) for Multiple UOM Part.
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   FUNCTION GetPackageVersion
      RETURN iapiType.String_Type;
   ---------------------------------------------------------------------------
   -- Member variables
   ---------------------------------------------------------------------------
   gsSource                      iapiType.Source_Type := 'iapiUomGroups';
   gtErrors                      ErrorDataTable_Type := ErrorDataTable_Type( );


   -- In iapiType
   SUBTYPE UomConvFactor_Type IS UOMC.conv_factor%TYPE;
   SUBTYPE UomConvFct_Type IS UOMC.conv_fct%TYPE;

   UOMBASE       CONSTANT NUMBER := 1;
   NOUOMBASE     CONSTANT NUMBER := 0;

   --Non used
   DBERR_NOTUOMBASE  CONSTANT NUMBER := 485;   --Unit of measure  [%1] is not an Uom base.


   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   FUNCTION AddGroup(
     asDescription              IN       iapiType.UomGroupDescription_Type,
     asIntl                     IN       iapiType.Intl_Type,
     anStatus                   IN       iapiType.StatusId_Type,
     anUomGroup                 OUT      iapiType.Id_Type)
     RETURN iapiType.ErrorNum_Type;

   FUNCTION RemoveGroup(
     anUomGroup                 IN       iapiType.Id_Type )
     RETURN iapiType.ErrorNum_Type;

   FUNCTION ChangeGroup(
     anUomGroup                 IN       iapiType.Id_Type,
     asDescription              IN       iapiType.UomGroupDescription_Type,
     anIntl                     IN       iapiType.Intl_Type,
     anStatus                   IN       iapiType.StatusId_Type)
     RETURN iapiType.ErrorNum_Type;

   FUNCTION AssignUomToGroup(
     anUomGroup                 IN       iapiType.Id_Type,
     anUom                      IN       iapiType.Id_Type)
     RETURN iapiType.ErrorNum_Type;

   FUNCTION GetGroups(
     anUomGroup            IN       iapiType.Id_Type DEFAULT NULL,
     aqGroups              OUT      iapiType.Ref_Type)
     RETURN iapiType.ErrorNum_Type;

   FUNCTION GetUomGroupDescription(
      anUomGroup                 IN       iapiType.Id_Type DEFAULT NULL,
      anUomGroupRevision         IN       iapiType.Revision_Type,
      aqGroups                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   FUNCTION GetUomDescription(
     anUom                 IN       iapiType.Id_Type DEFAULT NULL,
     anUomGroup            IN       iapiType.Id_Type DEFAULT NULL,
     anUomRevision         IN       iapiType.Revision_Type DEFAULT NULL,
     aqUoms                OUT      iapiType.Ref_Type)
     RETURN iapiType.ErrorNum_Type;

   FUNCTION GetUomId(
     asUom                 IN       iapiType.Description_Type ,
     anUomRevision         IN       iapiType.Revision_Type DEFAULT NULL)
     RETURN iapiType.Id_Type;

   FUNCTION IsUomsSameGroup(
      anUom                      IN       iapiType.Id_Type,
      anUom_2                    IN       iapiType.Id_Type )
      RETURN iapiType.Boolean_Type;

   FUNCTION IsUomsSameGroup(
      asUom                      IN       iapiType.Description_Type,
      asUom_2                  IN       iapiType.Description_Type )
      RETURN iapiType.Boolean_Type;

   FUNCTION AddUomConversion(
      anUomMetri                 IN       iapiType.Id_Type,
      anUomNoMetric              IN       iapiType.Id_Type,
      anConvFactor               IN       UomConvFactor_Type,
      anConvFct                  IN       UomConvFct_Type DEFAULT NULL)
      RETURN iapiType.ErrorNum_Type;

   FUNCTION GetAlternativeUomBase(
      anUomId                    IN       iapiType.Id_Type,
      anUomAlternative           OUT      iapiType.Id_Type)
      RETURN iapiType.ErrorNum_Type;


   FUNCTION GetUomsType(
      anType                     IN       iapiType.Boolean_Type DEFAULT NULL,
      aqUoms                     OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   FUNCTION GetUomsBase(
      anBase                     IN       iapiType.Boolean_Type DEFAULT NULL,
      aqUoms                     OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   FUNCTION GetUomsGroupType(
      anUomGroup               IN       iapiType.Id_Type,
      anType                   IN       iapiType.Boolean_Type,
      aqUoms                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   FUNCTION GetUomsGroupSameType(
      anUomId                  IN       iapiType.Id_Type,
      aqUoms                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   FUNCTION GetUomsGroupSameType(
      asUomId                    IN       iapiType.Description_Type,
      aqUoms                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

    --AP01194703 Start
    FUNCTION GetUomBaseGroupSameType(
      anUomId                    IN       iapiType.Id_Type)
      RETURN iapiType.Id_Type;
    --AP01194703 End

    --AP01194703 Start
    FUNCTION GetConversionFactor(
       anValue                    IN       iapiType.Float_Type DEFAULT 1,
       anFromUomId                IN       iapiType.Id_Type,
       anToUomId                  IN       iapiType.Id_Type,
       anRicorsiveLevel           IN       iapiType.Level_Type DEFAULT 1,
       anFirstValue               IN       iapiType.Float_Type DEFAULT 0 )
       RETURN iapiType.Float_Type;
    --AP01194703 End

    --AP01194703 Start
       FUNCTION GetUomsGroupSameTypeExt(
          anUomId                  IN       iapiType.Id_Type,
          aqUoms                   OUT      iapiType.Ref_Type )
          RETURN iapiType.ErrorNum_Type;
    --AP01194703 End

    --AP01194703 Start
       FUNCTION GetUomsGroupSameTypeExt(
          asUomId                  IN       iapiType.Description_Type,
          aqUoms                   OUT      iapiType.Ref_Type )
          RETURN iapiType.ErrorNum_Type;
    --AP01194703 End

   FUNCTION GetUomsGroupOtherType(
      anUomId                  IN       iapiType.Id_Type,
      aqUoms                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   FUNCTION GetUomsGroupOtherType(
      asUomId                    IN       iapiType.Description_Type,
      aqUoms                     OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

    FUNCTION GetUomBaseGroupSameType(
      anUomId                  IN       iapiType.Id_Type,
      anUomBaseId              OUT      iapiType.Id_Type )
      RETURN iapiType.ErrorNum_Type;

  FUNCTION GetUomBaseGroupOtherType(
      anUomId                  IN       iapiType.Id_Type,
      anUomBaseId              OUT      iapiType.Id_Type )
      RETURN iapiType.ErrorNum_Type;

  FUNCTION isSameModeType(
      anUomType                  IN       iapiType.Boolean_Type )
      RETURN BOOLEAN;

   FUNCTION GetUomsGroupSESSIONType(
      anUomId                    IN       iapiType.Id_Type,
      aqUoms                     OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   FUNCTION GetUomsGroupSESSIONType(
      asUomId                    IN       iapiType.Description_Type,
      aqUoms                     OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;


   FUNCTION GetTypeUom(
      anUomId                  IN      iapiType.Id_Type,
      anUomType                OUT     iapiType.Boolean_Type)
      RETURN iapiType.ErrorNum_Type;

   FUNCTION GetTypeUom(
      asUomId                  IN      iapiType.Description_Type,
      anUomType                OUT     iapiType.Boolean_Type)
      RETURN iapiType.ErrorNum_Type;

   FUNCTION ExistUomGroupId(
     anUomGroup                 IN       iapiType.Id_Type)
     RETURN iapiType.ErrorNum_Type;

    FUNCTION UomFound(
     anUom                      IN       iapiType.Id_Type)
     RETURN iapiType.Boolean_Type;

    FUNCTION UomGroupFound(
     anUomGroup                 IN       iapiType.Id_Type)
     RETURN iapiType.Boolean_Type;

END iapiUomGroups;
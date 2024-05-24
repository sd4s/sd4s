create or replace PACKAGE          TeunisUtil IS
  PROCEDURE LOGON;
  
  FUNCTION EraseBom(
      asPartNo        IN   iapiType.PartNo_Type)
  RETURN iapiType.ErrorNum_Type;
  
  FUNCTION AddBewerking(
    aPart_no      iapiType.PartNo_Type,
    aSubSectionId iapiType.Id_Type)
 RETURN iapiType.ErrorNum_Type;

  FUNCTION RemBewerking(
    aPart_no      iapiType.PartNo_Type,
    aRevision     iapiType.Revision_Type,
    aSubSectionId iapiType.Id_Type)
 RETURN iapiType.ErrorNum_Type;

  FUNCTION AddTPM(
    aPart_no      iapiType.PartNo_Type,
    aRevision     iapiType.Revision_Type,
    aSubSectionId iapiType.Id_Type)
 RETURN iapiType.ErrorNum_Type;

  FUNCTION AddWKK(
    aPart_no      iapiType.PartNo_Type,
    aSubSectionId iapiType.Id_Type)
 RETURN iapiType.ErrorNum_Type;

  FUNCTION AddZijkant(
    aPart_no      iapiType.PartNo_Type,
    aSubSectionId iapiType.Id_Type)
 RETURN iapiType.ErrorNum_Type;

  FUNCTION AddHiel(
    aPart_no      iapiType.PartNo_Type,
    aSubSectionId iapiType.Id_Type)
 RETURN iapiType.ErrorNum_Type;

  FUNCTION AddStaalstrook(
    aPart_no      iapiType.PartNo_Type,
    aSubSectionId iapiType.Id_Type)
 RETURN iapiType.ErrorNum_Type;

  FUNCTION AddTread(
    aPart_no      iapiType.PartNo_Type,
    aSubSectionId iapiType.Id_Type)
 RETURN iapiType.ErrorNum_Type;

  FUNCTION AddPhase(
    aPart_no      iapiType.PartNo_Type,
    aPropertyId iapiType.Id_Type)
 RETURN iapiType.ErrorNum_Type;

  FUNCTION AddHoogteLVT(
    aPart_no      iapiType.PartNo_Type,
    aSubSectionId iapiType.Id_Type)
 RETURN iapiType.ErrorNum_Type;

  FUNCTION AddCapstripWidth(
    aPart_no      iapiType.PartNo_Type,
    aSubSectionId iapiType.Id_Type)
 RETURN iapiType.ErrorNum_Type;

  FUNCTION AddCapstripLayer(
    aPart_no      iapiType.PartNo_Type,
    aSubSectionId iapiType.Id_Type)
 RETURN iapiType.ErrorNum_Type;

  FUNCTION AddRemark(
    aPart_no      iapiType.PartNo_Type,
    aSubSectionId iapiType.Id_Type)
 RETURN iapiType.ErrorNum_Type;

  FUNCTION AddSegmenten(
    aPart_no      iapiType.PartNo_Type,
    aSubSectionId iapiType.Id_Type)
 RETURN iapiType.ErrorNum_Type;

FUNCTION AddSectionItem(
    aPart_no      iapiType.PartNo_Type,
    aSectionId iapiType.Id_Type,
    aSubSectionId iapiType.Id_Type,
    aItemType  iapiType.SpecificationSectionType_Type,
    aItemId iapiType.Id_Type)
  RETURN iapiType.ErrorNum_Type;

FUNCTION AddGroupProperty(
    aPart_no      iapiType.PartNo_Type,
    aSectionId iapiType.Id_Type,
    aSubSectionId iapiType.Id_Type,
    aPropGroupId iapiType.Id_Type,
    aPropertyId iapiType.Id_Type)
  RETURN iapiType.ErrorNum_Type;

FUNCTION AddTooling(
    aPart_no      iapiType.PartNo_Type,
    aSubSectionId iapiType.Id_Type)
  RETURN iapiType.ErrorNum_Type;

FUNCTION CopySpec(
   aPart_no iapiType.PartNo_Type,
   aNewPart iapiType.PartNo_Type)
  RETURN  iapiType.ErrorNum_Type;
END;
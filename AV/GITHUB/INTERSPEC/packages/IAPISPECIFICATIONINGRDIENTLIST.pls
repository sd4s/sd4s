create or replace PACKAGE iapiSpecificationIngrdientList
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiSpecificationIngrdientList.h $
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.14 (06.07.00.14-08.00) $
   --  $Modtime: 2017-May-25 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract:
   --           This package contains all
   --           functionality to maintain ingredient lists of a
   --           specification.
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
   gsSource                      iapiType.Source_Type := 'iapiSpecificationIngrdientList';
   gtIngredientLists             iapiType.SpIngredientListTab_Type;
   gtIngredientListItems         iapiType.SpIngredientListItemTab_Type;
   --AP00892453 --AP00888937
   gtIngredientListItemsPb       iapiType.SpIngredientListItemTabPb_Type;
   gtChemicalLists               iapiType.SpIngredientListTab_Type;
   gtChemicalListItems           iapiType.SpChemicalListItemTab_Type;
   gtErrors                      ErrorDataTable_Type := ErrorDataTable_Type( );
   gtGetIngredientListItems      SpIngListItemTable_Type := SpIngListItemTable_Type( );
   --AP00892453 --AP00888937
   gtGetIngredientListItemsPb    SpIngListItemTablePb_Type := SpIngListItemTablePb_Type( );
   gtGetChemicalListItems        SpChemicalListItemTable_Type := SpChemicalListItemTable_Type( );
   gtInfo                        iapiType.InfoTab_Type;
-- ISQF194 start
   gtIngChar                    iapiType.SpIngCharTab_Type;
-- ISQF194 end
   grAllergen                   iapiType.SpIngredientAllergenRec_Type;
   grCharacteristic             iapiType.SpIngCharRec_Type;

  ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   FUNCTION AddChemicalList(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      afHandle                   IN       iapiType.Float_Type DEFAULT NULL,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION AddChemicalListItem(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anIngredientId             IN       iapiType.Id_Type,
      anSequenceNumber           IN       iapiType.IngredientSequenceNumber_Type,
      anSynonymId                IN       iapiType.Id_Type,
      anQuantity                 IN       iapiType.IngredientQuantity_Type,
      asLevel                    IN       iapiType.IngredientLevel_Type,
      asComment                  IN       iapiType.IngredientComment_Type,
      anDeclare                  IN       iapiType.Boolean_Type,
      anActiveIngredient         IN       iapiType.Boolean_Type DEFAULT 0,
      afHandle                   IN       iapiType.Float_Type DEFAULT NULL,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION AddIngredientList(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      afHandle                   IN       iapiType.Float_Type DEFAULT NULL,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION AddIngredientListItem(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anIngredientId             IN       iapiType.Id_Type,
      anSequenceNumber           IN       iapiType.IngredientSequenceNumber_Type,
      anSynonymId                IN       iapiType.Id_Type,
      anQuantity                 IN       iapiType.IngredientQuantity_Type,
      asLevel                    IN       iapiType.IngredientLevel_Type,
      asComment                  IN       iapiType.IngredientComment_Type,
      anDeclare                  IN       iapiType.Boolean_Type,
      anReconstitutionFactor     IN       iapiType.ReconstitutionFactor_Type DEFAULT NULL,
      anHierarchicalLevel        IN       iapiType.IngredientHierarchicLevel_Type DEFAULT 1,
      anParentId                 IN       iapiType.Id_Type DEFAULT 0,
      afHandle                   IN       iapiType.Float_Type DEFAULT NULL,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetChemicalListItems(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anAlternativeLanguageId    IN       iapiType.LanguageId_Type DEFAULT NULL,
      aqChemicalListItems        OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_type;

   ---------------------------------------------------------------------------
   FUNCTION GetIngredientListItems(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anAlternativeLanguageId    IN       iapiType.LanguageId_Type DEFAULT NULL,
      aqIngredientListItems      OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_type;

   --AP00892453 --AP00888937 Start
   ---------------------------------------------------------------------------
   FUNCTION GetIngredientListItemsPb(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anAlternativeLanguageId    IN       iapiType.LanguageId_Type DEFAULT NULL,
      aqIngredientListItems      OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_type;
   --AP00892453 --AP00888937 End

   ---------------------------------------------------------------------------
   FUNCTION IsIngredientDataTranslated(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anIngredientId             IN       iapiType.Id_Type,
      anParentId                 IN       iapiType.Id_Type,
      anHierarchicalLevel        IN       iapiType.IngredientHierarchicLevel_Type )
      RETURN iapiType.Boolean_Type;

   ---------------------------------------------------------------------------
   FUNCTION RemoveChemicalList(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      afHandle                   IN       iapiType.Float_Type DEFAULT NULL,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION RemoveChemicalListItem(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anIngredientId             IN       iapiType.Id_Type,
      anSequenceNumber           IN       iapiType.IngredientSequenceNumber_Type,
      afHandle                   IN       iapiType.Float_Type DEFAULT NULL,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION RemoveIngredientList(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      afHandle                   IN       iapiType.Float_Type DEFAULT NULL,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION RemoveIngredientListItem(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anIngredientId             IN       iapiType.Id_Type,
      anSequenceNumber           IN       iapiType.IngredientSequenceNumber_Type,
      afHandle                   IN       iapiType.Float_Type DEFAULT NULL,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION RemoveListData(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SaveChemicalList(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anAction                   IN       iapiType.NumVal_Type,
      afHandle                   IN       iapiType.Float_Type DEFAULT NULL,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SaveChemicalListItem(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anIngredientId             IN       iapiType.Id_Type,
      anSequenceNumber           IN       iapiType.IngredientSequenceNumber_Type,
      anSynonymId                IN       iapiType.Id_Type,
      anQuantity                 IN       iapiType.IngredientQuantity_Type,
      asLevel                    IN       iapiType.IngredientLevel_Type,
      asComment                  IN       iapiType.IngredientComment_Type,
      anDeclare                  IN       iapiType.Boolean_Type,
      anNewSequence              IN       iapiType.IngredientSequenceNumber_Type DEFAULT NULL,
      anActiveIngredient         IN       iapiType.Boolean_Type DEFAULT 0,
      anAlternativeLanguageId    IN       iapiType.LanguageId_Type DEFAULT NULL,
      asAlternativeLevel         IN       iapiType.IngredientLevel_Type DEFAULT NULL,
      asAlternativeComment       IN       iapiType.IngredientComment_Type DEFAULT NULL,
      afHandle                   IN       iapiType.Float_Type DEFAULT NULL,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SaveIngredientList(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anAction                   IN       iapiType.NumVal_Type,
      afHandle                   IN       iapiType.Float_Type DEFAULT NULL,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SaveIngredientListItem(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anIngredientId             IN       iapiType.Id_Type,
      anSequenceNumber           IN       iapiType.IngredientSequenceNumber_Type,
      anSynonymId                IN       iapiType.Id_Type,
      anQuantity                 IN       iapiType.IngredientQuantity_Type,
      asLevel                    IN       iapiType.IngredientLevel_Type,
      asComment                  IN       iapiType.IngredientComment_Type,
      anDeclare                  IN       iapiType.Boolean_Type,
      anNewSequence              IN       iapiType.IngredientSequenceNumber_Type DEFAULT NULL,
      anReconstitutionFactor     IN       iapiType.ReconstitutionFactor_Type DEFAULT NULL,
      anHierarchicalLevel        IN       iapiType.IngredientHierarchicLevel_Type DEFAULT 1,
      anParentId                 IN       iapiType.Id_Type DEFAULT 0,
      anAlternativeLanguageId    IN       iapiType.LanguageId_Type DEFAULT NULL,
      asAlternativeLevel         IN       iapiType.IngredientLevel_Type DEFAULT NULL,
      asAlternativeComment       IN       iapiType.IngredientComment_Type DEFAULT NULL,
      --IS18 Start
      anIngDetailType               IN       iapiType.Id_Type DEFAULT NULL,
      anIngDetailCharacteristic           IN       iapiType.Id_Type DEFAULT NULL,
      --IS18 End
      afHandle                   IN       iapiType.Float_Type DEFAULT NULL,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   --AP01326573 Start
   ---------------------------------------------------------------------------
   FUNCTION SaveIngredientListItemPb(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anIngredientId             IN       iapiType.Id_Type,
      anSequenceNumber           IN       iapiType.IngredientSequenceNumber_Type,
      anSynonymId                IN       iapiType.Id_Type,
      anQuantity                 IN       iapiType.IngredientQuantity_Type,
      asLevel                    IN       iapiType.IngredientLevel_Type,
      asComment                  IN       iapiType.IngredientComment_Type,
      anDeclare                  IN       iapiType.Boolean_Type,
      anNewSequence              IN       iapiType.IngredientSequenceNumber_Type DEFAULT NULL,
      anReconstitutionFactor     IN       iapiType.ReconstitutionFactor_Type DEFAULT NULL,
      anHierarchicalLevel        IN       iapiType.IngredientHierarchicLevel_Type DEFAULT 1,
      anParentId                 IN       iapiType.Id_Type DEFAULT 0,
      --AP01326573 Start
      anNewParentId              IN       iapiType.Id_Type DEFAULT 0,
      --AP01326573 End
      anAlternativeLanguageId    IN       iapiType.LanguageId_Type DEFAULT NULL,
      asAlternativeLevel         IN       iapiType.IngredientLevel_Type DEFAULT NULL,
      asAlternativeComment       IN       iapiType.IngredientComment_Type DEFAULT NULL,
      afHandle                   IN       iapiType.Float_Type DEFAULT NULL,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;
   --AP01326573 End

   --AP00892453 --AP00888937 Start
   ---------------------------------------------------------------------------
   FUNCTION GetPidList(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anSequence                 IN       iapiType.Sequence_Type )
      RETURN VARCHAR2;
   --AP00892453 --AP00888937 End
-- TFS3684 start
  ---------------------------------------------------------------------------
   FUNCTION AddIngredientAllergen(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anIngredientId             IN       iapiType.Id_Type,
      anAllergenId               IN       iapiType.Id_Type,
      afHandle                   IN       iapiType.Float_Type DEFAULT NULL,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;
  ---------------------------------------------------------------------------
   FUNCTION AddIngredientCharacteristic(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anIngredient               IN       iapiType.Id_Type,
			anIngredientSeqNo          IN       iapitype.IngredientSequenceNumber_Type ,
			anIngDetailType            IN       iapitype.Id_Type ,
			anCharacteristic           IN       iapitype.Id_Type ,
			asMandatory                IN       iapitype.Mandatory_Type ,
      afHandle                   IN       iapiType.Float_Type DEFAULT NULL,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;
-------------------------------------------------------------------------------
   FUNCTION RemoveIngredientCharacteristic(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anIngredient               IN       iapiType.Id_Type,
			anIngredientSeqNo          IN       iapitype.IngredientSequenceNumber_Type ,
			anIngDetailType            IN       iapitype.Id_Type ,
			anCharacteristic           IN       iapitype.Id_Type ,
			asMandatory                IN       iapitype.Mandatory_Type ,
      afHandle                   IN       iapiType.Float_Type DEFAULT NULL,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;
  ----------------------------------------------------------------------------
-- TFS3684 end
   --ING SUPPORT Start
   FUNCTION RemoveIngredientAllergen(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anIngredientId             IN       iapiType.Id_Type,
      anAllergenId               IN       iapiType.Id_Type,
-- TFS3684 start
			afHandle                   IN       iapiType.Float_Type DEFAULT NULL,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
-- -- TFS3684 end
      RETURN iapiType.ErrorNum_Type;

   FUNCTION RemoveIngredientAllergens(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anIngredientId             IN       iapiType.Id_Type,
-- TFS3684 start
			afHandle                   IN       iapiType.Float_Type DEFAULT NULL,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
-- TFS3684 end
      RETURN iapiType.ErrorNum_Type;
   --ING SUPPORT End

   --IS1031 Start
   FUNCTION AddIngredientDetail(
      --both have 18 chars
      asDescription                  IN       iapiType.PartNo_Type,
      anIngDetailAssociation     IN       iapiType.SequenceNr_Type,
      anIngDetailType              OUT   iapiType.SequenceNr_Type)
      RETURN iapiType.ErrorNum_Type;

   FUNCTION SaveIngredientDetail(
      anIngDetailType              IN       iapiType.SequenceNr_Type,
      asDescription                  IN       iapiType.PartNo_Type,
      anIngDetailAssociation     IN       iapiType.SequenceNr_Type)
      RETURN iapiType.ErrorNum_Type;

   FUNCTION RemoveIngredientDetail(
      anIngDetailType     IN       iapiType.SequenceNr_Type)
      RETURN iapiType.ErrorNum_Type;
   --IS1031 End

-- ISQF194 start
   FUNCTION GetIngredientCharacteristics(
      asPartNo                      IN       iapiType.PartNo_Type,
      anRevision                    IN       iapiType.Revision_Type,
      anIngredient                  IN       iapiType.Id_Type,
      anIngDetailType               IN       iapiType.Id_Type DEFAULT -1,
      anLanguageId                  IN       iapiType.LanguageId_Type DEFAULT NULL,
      aqIngChar                     OUT      iapiType.Ref_Type,
      aqErrors                      OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_type;
--ISQF194 end

---------------------------------------------------------------------------
-- Pragmas
---------------------------------------------------------------------------
END iapiSpecificationIngrdientList;
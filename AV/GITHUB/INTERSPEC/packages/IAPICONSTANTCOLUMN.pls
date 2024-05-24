create or replace PACKAGE iapiConstantColumn
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiConstantColumn.h $
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract:
   --           This class contains column name types
   --
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   -- $NoKeywords: $
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   -- Constant definitions
   ---------------------------------------------------------------------------
   AccessGroupCol       CONSTANT VARCHAR2( 30 ) := 'ACCESSGROUP';   --
   AccessGroupIdCol     CONSTANT VARCHAR2( 30 ) := 'ACCESSGROUPID';   --
   AccessGroupSortCol   CONSTANT VARCHAR2( 30 ) := 'ACCESSGROUPSORT';
   --
   AccessStopCol        CONSTANT VARCHAR2( 30 ) := 'ACCESSSTOP';   --
   ActionCol            CONSTANT VARCHAR2( 30 ) := 'ACTION';   --
   ActiveCmpStatusCol   CONSTANT VARCHAR2( 30 ) := 'ACTIVECMP';   --
   ActiveCol            CONSTANT VARCHAR2( 30 ) := 'ACTIVE';   --
   ActiveIngredientCmpStatusCol CONSTANT VARCHAR2( 30 ) := 'ACTIVEINGREDIENTCMPSTATUS';
   --
   ActiveIngredientCol  CONSTANT VARCHAR2( 30 ) := 'ACTIVEINGREDIENT';
   --
   --R18 Revert
   --ActualStatus       CONSTANT VARCHAR2( 30 ) := 'ACTUALSTATUS';   --
   ActualValueCol       CONSTANT VARCHAR2( 30 ) := 'ACTUALVALUE';   --
   AlertCol             CONSTANT VARCHAR2( 30 ) := 'ALERT';   --
   AlignmentCol         CONSTANT VARCHAR2( 30 ) := 'ALIGNMENT';   --
   AllergenCmpStatusCol CONSTANT VARCHAR2( 30 ) := 'ALLERGENCMPSTATUS';
   --
   AllergenCol          CONSTANT VARCHAR2( 30 ) := 'ALLERGEN';   --
   AllergenIdCol        CONSTANT VARCHAR2( 30 ) := 'ALLERGENID';   --
   AllowFrameChangesCol CONSTANT VARCHAR2( 30 ) := 'ALLOWFRAMECHANGES';
   --
   AllowFrameExportCol  CONSTANT VARCHAR2( 30 ) := 'ALLOWFRAMEEXPORT';
   --
   AllowGlossaryCol     CONSTANT VARCHAR2( 30 ) := 'ALLOWGLOSSARY';   --
   AllowPhantomCol      CONSTANT VARCHAR2( 30 ) := 'ALLOWPHANTOM';   --
   AllToApproveCol      CONSTANT VARCHAR2( 30 ) := 'ALLTOAPPROVE';   --
   AlternativeCol       CONSTANT VARCHAR2( 30 ) := 'ALTERNATIVE';   --
   AlternativeCommentCol CONSTANT VARCHAR2( 30 ) := 'ALTERNATIVECOMMENT';
   --
   AlternativeDescriptionCol CONSTANT VARCHAR2( 30 ) := 'ALTERNATIVEDESCRIPTION';
   --
   AlternativeGroupCmpStatusCol CONSTANT VARCHAR2( 30 ) := 'ALTERNATIVEGROUPCMPSTATUS';
   --
   AlternativeGroupCol  CONSTANT VARCHAR2( 30 ) := 'ALTERNATIVEGROUP';
   --
   AlternativeInfoCol   CONSTANT VARCHAR2( 30 ) := 'ALTERNATIVEINFO';
   --
   AlternativeLanguageIdCol CONSTANT VARCHAR2( 30 ) := 'ALTERNATIVELANGUAGEID';
   --
   AlternativeLevelCol  CONSTANT VARCHAR2( 30 ) := 'ALTERNATIVELEVEL';
   --
   AlternativeNameCol   CONSTANT VARCHAR2( 30 ) := 'ALTERNATIVENAME';
   --
   AlternativePartNoCol CONSTANT VARCHAR2( 30 ) := 'EANUPCBARCODE';   --
   AlternativePriceCol  CONSTANT VARCHAR2( 30 ) := 'ALTERNATIVEPRICE';
   --
   AlternativePrioCmpStatusCol CONSTANT VARCHAR2( 30 ) := 'ALTERNATIVEPRIORITYCMPSTATUS';
   --
   AlternativePriorityCol CONSTANT VARCHAR2( 30 ) := 'ALTERNATIVEPRIORITY';
   --
   AlternativeRevisionCol CONSTANT VARCHAR2( 30 ) := 'ALTERNATIVEREVISION';
   --
   AlternativeString1Col CONSTANT VARCHAR2( 30 ) := 'ALTERNATIVESTRING1';
   --
   AlternativeString2Col CONSTANT VARCHAR2( 30 ) := 'ALTERNATIVESTRING2';
   --
   AlternativeString3Col CONSTANT VARCHAR2( 30 ) := 'ALTERNATIVESTRING3';
   --
   AlternativeString4Col CONSTANT VARCHAR2( 30 ) := 'ALTERNATIVESTRING4';
   --
   AlternativeString5Col CONSTANT VARCHAR2( 30 ) := 'ALTERNATIVESTRING5';
   --
   AlternativeString6Col CONSTANT VARCHAR2( 30 ) := 'ALTERNATIVESTRING6';
   --
   AlternativeTextCol   CONSTANT VARCHAR2( 30 ) := 'ALTERNATIVETEXT';
   --
   AndOrCol             CONSTANT VARCHAR2( 30 ) := 'ANDOR';   --
   ApprovalDateCol      CONSTANT VARCHAR2( 30 ) := 'APPROVALDATE';   --
   ApprovedDateCol      CONSTANT VARCHAR2( 30 ) := 'APPROVEDDATE';   --
   ApprovedOnlyAccessCol CONSTANT VARCHAR2( 30 ) := 'APPROVEDONLYACCESS';
   --
   AssemblyScrapCmpStatusCol CONSTANT VARCHAR2( 30 ) := 'ASSEMBLYSCRAPCMPSTATUS';
   --
   AssemblyScrapCol     CONSTANT VARCHAR2( 30 ) := 'ASSEMBLYSCRAP';   --
   AssemblyScrapFactorCol CONSTANT VARCHAR2( 30 ) := 'ASSEMBLYSCRAPFACTOR';
   --
   AssociationCol       CONSTANT VARCHAR2( 30 ) := 'ASSOCIATION';   --
   AssociationDescription1Col CONSTANT VARCHAR2( 30 ) := 'ASSOCIATIONDESCRIPTION1';
   --
   AssociationDescription2Col CONSTANT VARCHAR2( 30 ) := 'ASSOCIATIONDESCRIPTION2';
   --
   AssociationDescription3Col CONSTANT VARCHAR2( 30 ) := 'ASSOCIATIONDESCRIPTION3';
   --
   AssociationId1Col    CONSTANT VARCHAR2( 30 ) := 'ASSOCIATIONID1';   --
   AssociationId2Col    CONSTANT VARCHAR2( 30 ) := 'ASSOCIATIONID2';   --
   AssociationId3Col    CONSTANT VARCHAR2( 30 ) := 'ASSOCIATIONID3';   --
   AssociationIdCol     CONSTANT VARCHAR2( 30 ) := 'ASSOCIATIONID';   --
   AssociationRevision1Col CONSTANT VARCHAR2( 30 ) := 'ASSOCIATIONREVISION1';
   --
   AssociationRevision2Col CONSTANT VARCHAR2( 30 ) := 'ASSOCIATIONREVISION2';
   --
   AssociationRevision3Col CONSTANT VARCHAR2( 30 ) := 'ASSOCIATIONREVISION3';
   --
   AssociationRevisionCol CONSTANT VARCHAR2( 30 ) := 'ASSOCIATIONREVISION';
   --
   AttachedDescriptionCol CONSTANT VARCHAR2( 30 ) := 'ATTACHEDDESCRIPTION';
   --
   AttachedInternationalCol CONSTANT VARCHAR2( 30 ) := 'ATTACHEDINTERNATIONAL';
   --
   AttachedOwnerIdCol   CONSTANT VARCHAR2( 30 ) := 'ATTACHEDOWNERID';
   --
   AttachedPartNoCol    CONSTANT VARCHAR2( 30 ) := 'ATTACHEDPARTNO';   --
   AttachedPhantomCol   CONSTANT VARCHAR2( 30 ) := 'ATTACHEDPHANTOM';
   --
   AttachedRevisionCol  CONSTANT VARCHAR2( 30 ) := 'ATTACHEDREVISION';
   --
   --AP00847482 oneLine
   AttachedRevisionPhantomCol  CONSTANT VARCHAR2( 30 ) := 'ATTACHEDREVISIONPHANTOM';
   --
   AttachedSpecificationCol CONSTANT VARCHAR2( 30 ) := 'ATTACHEDSPECIFICATION';
   --
   AttributeCol         CONSTANT VARCHAR2( 30 ) := 'ATTRIBUTE';   --
   AttributeIdCol       CONSTANT VARCHAR2( 30 ) := 'ATTRIBUTEID';   --
   AttributeRevisionCol CONSTANT VARCHAR2( 30 ) := 'ATTRIBUTEREVISION';
   --
   AttributeTextCol     CONSTANT VARCHAR2( 30 ) := 'ATTRIBUTETEXT';   --
   AuditDateCol         CONSTANT VARCHAR2( 30 ) := 'AUDITDATE';   --
   AuditFrequenceCol    CONSTANT VARCHAR2( 30 ) := 'AUDITFREQUENCE';   --
   BarcodeCol           CONSTANT VARCHAR2( 30 ) := 'BARCODE';   --
   BaseConversionFactorCol CONSTANT VARCHAR2( 30 ) := 'BASECONVFACTOR';   --
   BaseQuantityCmpStatusCol CONSTANT VARCHAR2( 30 ) := 'BASEQUANTITYCMPSTATUS';
   --
   BaseQuantityCol      CONSTANT VARCHAR2( 30 ) := 'BASEQUANTITY';   --
   BaseQuantityTextCol  CONSTANT VARCHAR2( 30 ) := 'BASEQUANTITYTEXT';
   --
   BaseToUnitCol        CONSTANT VARCHAR2( 30 ) := 'BASETOUNIT';   --
   BaseUomCol           CONSTANT VARCHAR2( 30 ) := 'BASEUOM';   --
   BoldCol              CONSTANT VARCHAR2( 30 ) := 'BOLD';   --
   BomAlternativeCol    CONSTANT VARCHAR2( 30 ) := 'BOMALTERNATIVE';   --
   BomAltGroupCol       CONSTANT VARCHAR2( 30 ) := 'BOMALTGROUP';   --
   BomAltPriorityCol    CONSTANT VARCHAR2( 30 ) := 'BOMALTPRIORITY';   --
   BomChangedCol        CONSTANT VARCHAR2( 30 ) := 'BOMCHANGED';   --
   BomDescriptionCol    CONSTANT VARCHAR2( 30 ) := 'BOMDESCRIPTION';   --
   BomEffectiveDateCol  CONSTANT VARCHAR2( 30 ) := 'BOMEFFECTIVEDATE';
   --
   BomHeaderCmpStatusCol CONSTANT VARCHAR2( 30 ) := 'BOMHEADERCMPSTATUS';
   --
   BomHeaderDescriptionCol CONSTANT VARCHAR2( 30 ) := 'BOMHEADERDESCRIPTION';
   --
   BomItemCmpStatusCol  CONSTANT VARCHAR2( 30 ) := 'BOMITEMCMPSTATUS';
   --
   BomItemTypeCmpStatusCol CONSTANT VARCHAR2( 30 ) := 'BOMITEMTYPECMPSTATUS';
   --
   BomItemTypeCol       CONSTANT VARCHAR2( 30 ) := 'BOMITEMTYPE';   --
   BomLevelCmpStatusCol CONSTANT VARCHAR2( 30 ) := 'BOMLEVELCMPSTATUS';
   --
   BomLevelCol          CONSTANT VARCHAR2( 30 ) := 'BOMLEVEL';   --
   BomSequenceCol       CONSTANT VARCHAR2( 30 ) := 'BOMSEQUENCE';   --
   BomTypeCmpStatusCol  CONSTANT VARCHAR2( 30 ) := 'BOMTYPECMPSTATUS';
   --
   BomTypeCol           CONSTANT VARCHAR2( 30 ) := 'BOMTYPE';   --
   BomUsageDescriptionCol CONSTANT VARCHAR2( 30 ) := 'BOMUSAGEDESCRIPTION';
   --
   BomUsageIdCol        CONSTANT VARCHAR2( 30 ) := 'BOMUSAGEID';   --
   Boolean1CmpStatusCol CONSTANT VARCHAR2( 30 ) := 'BOOLEAN1CMPSTATUS';
   --
   Boolean1Col          CONSTANT VARCHAR2( 30 ) := 'BOOLEAN1';   --
   Boolean2CmpStatusCol CONSTANT VARCHAR2( 30 ) := 'BOOLEAN2CMPSTATUS';
   --
   Boolean2Col          CONSTANT VARCHAR2( 30 ) := 'BOOLEAN2';   --
   Boolean3CmpStatusCol CONSTANT VARCHAR2( 30 ) := 'BOOLEAN3CMPSTATUS';
   --
   Boolean3Col          CONSTANT VARCHAR2( 30 ) := 'BOOLEAN3';   --
   Boolean4CmpStatusCol CONSTANT VARCHAR2( 30 ) := 'BOOLEAN4CMPSTATUS';
   --
   Boolean4Col          CONSTANT VARCHAR2( 30 ) := 'BOOLEAN4';   --
   BooleanValueCol      CONSTANT VARCHAR2( 30 ) := 'BOOLEANVALUE';   --
   BulkMaterialCmpStatusCol CONSTANT VARCHAR2( 30 ) := 'BULKMATERIALCMPSTATUS';
   --
   BulkMaterialCol      CONSTANT VARCHAR2( 30 ) := 'BULKMATERIAL';   --
   CalcQtyCol           CONSTANT VARCHAR2( 30 ) := 'CALCQTY';   --
   CalculatedCol        CONSTANT VARCHAR2( 30 ) := 'CALCULATED';   --
   CalculatedCostCol    CONSTANT VARCHAR2( 30 ) := 'CALCULATEDCOST';   --
   CalculatedCostWithScrapCol CONSTANT VARCHAR2( 30 ) := 'CALCULATEDCOSTWITHSCRAP';
   --
   CalculatedFieldQuantityCol CONSTANT VARCHAR2( 30 ) := 'CALCULATEDFIELDQUANTITY';
   --
   CalculatedQuantityCol CONSTANT VARCHAR2( 30 ) := 'CALCULATEDQUANTITY';
   --
   CalculatedQuantityWithScrapCol CONSTANT VARCHAR2( 30 ) := 'CALCULATEDQUANTITYWITHSCRAP';
   --
   CalculationIdCol     CONSTANT VARCHAR2( 30 ) := 'CALCULATIONID';   --
   CalculationModeCmpStatusCol CONSTANT VARCHAR2( 30 ) := 'CALCULATIONMODECMPSTATUS';
   --
   CalculationModeCol   CONSTANT VARCHAR2( 30 ) := 'CALCULATIONMODE';
   --
   CallPrepostCol       CONSTANT VARCHAR2( 30 ) := 'CALLPREPOST';   --
   CfAccessCol          CONSTANT VARCHAR2( 30 ) := 'CFACCESS';   --
   ChangedDateCol       CONSTANT VARCHAR2( 30 ) := 'CHANGEDDATE';   --
   ChangeToStatusCol    CONSTANT VARCHAR2( 30 ) := 'CHANGETOSTATUS';   --
   CharacteristicCol    CONSTANT VARCHAR2( 30 ) := 'CHARACTERISTIC';   --
   CharacteristicDesc1CmpStsCol CONSTANT VARCHAR2( 30 ) := 'CHARACTERISTICDESC1CMPSTATUS';
   --
   CharacteristicDesc2CmpStsCol CONSTANT VARCHAR2( 30 ) := 'CHARACTERISTICDESC2CMPSTATUS';
   --
   CharacteristicDesc3CmpStsCol CONSTANT VARCHAR2( 30 ) := 'CHARACTERISTICDESC3CMPSTATUS';
   --
   CharacteristicDescription1Col CONSTANT VARCHAR2( 30 ) := 'CHARACTERISTICDESCRIPTION1';
   --
   CharacteristicDescription2Col CONSTANT VARCHAR2( 30 ) := 'CHARACTERISTICDESCRIPTION2';
   --
   CharacteristicDescription3Col CONSTANT VARCHAR2( 30 ) := 'CHARACTERISTICDESCRIPTION3';
   --
   CharacteristicId1Col CONSTANT VARCHAR2( 30 ) := 'CHARACTERISTICID1';
   --
   CharacteristicId2Col CONSTANT VARCHAR2( 30 ) := 'CHARACTERISTICID2';
   --
   CharacteristicId3Col CONSTANT VARCHAR2( 30 ) := 'CHARACTERISTICID3';
   --
   CharacteristicIdCol  CONSTANT VARCHAR2( 30 ) := 'CHARACTERISTICID';
   --
   CharacteristicRevision1Col CONSTANT VARCHAR2( 30 ) := 'CHARACTERISTICREVISION1';
   --
   CharacteristicRevision2Col CONSTANT VARCHAR2( 30 ) := 'CHARACTERISTICREVISION2';
   --
   CharacteristicRevision3Col CONSTANT VARCHAR2( 30 ) := 'CHARACTERISTICREVISION3';
   --
   ChemicalCol          CONSTANT VARCHAR2( 30 ) := 'CHEMICAL';   --
   ChemicalIdCol        CONSTANT VARCHAR2( 30 ) := 'CHEMICALID';   --
   ChemicalIngredientCmpStatusCol CONSTANT VARCHAR2( 30 ) := 'CHEMICALINGREDIENTCMPSTATUS';
   --
   ChildCountCol        CONSTANT VARCHAR2( 30 ) := 'CHILDCOUNT';   --
   ChildIdCol           CONSTANT VARCHAR2( 30 ) := 'CHILDID';   --
   ClaimResultCol       CONSTANT VARCHAR2( 30 ) := 'CLAIMRESULT';   --
   ClaimsSequenceCol    CONSTANT VARCHAR2( 30 ) := 'CLAIMSSEQUENCE';   --
   Class1IdCol          CONSTANT VARCHAR2( 30 ) := 'CLASS1ID';   --
   Class2IDCol          CONSTANT VARCHAR2( 30 ) := 'CLASS2ID';   --
   Class3IdCol          CONSTANT VARCHAR2( 30 ) := 'CLASS3ID';   --
   ClassCol             CONSTANT VARCHAR2( 30 ) := 'CLASS';   --
   ClassIdCol           CONSTANT VARCHAR2( 30 ) := 'CLASSID';   --
   ClassificationSequenceCol CONSTANT VARCHAR2( 30 ) := 'CLASSIFICATIONSEQUENCE';
   --
   ClassificationTreeDescrCol CONSTANT VARCHAR2( 30 ) := 'CLASSIFICATIONTREEDESCR';
   --
   ClassNameCol         CONSTANT VARCHAR2( 30 ) := 'CLASSNAME';   --
   ClassSortCol         CONSTANT VARCHAR2( 30 ) := 'CLASSSORT';   --
   ClearanceNumberCol   CONSTANT VARCHAR2( 30 ) := 'CLEARANCENUMBER';
   --
   CodeCmpStatusCol     CONSTANT VARCHAR2( 30 ) := 'CODECMPSTATUS';   --
   CodeCol              CONSTANT VARCHAR2( 30 ) := 'CODE';   --
   ColIdCol             CONSTANT VARCHAR2( 30 ) := 'COLID';   --
   ColumnIDCol          CONSTANT VARCHAR2( 30 ) := 'COLUMNID';   --
   ColumnTypeCol        CONSTANT VARCHAR2( 30 ) := 'COLUMNTYPE';   --
   CommodityCodeCol     CONSTANT VARCHAR2( 30 ) := 'COMMODITYCODE';   --
   CompareReferenceCol  CONSTANT VARCHAR2( 30 ) := 'COMPAREREFERENCE';
   --
   CompareResultCol     CONSTANT VARCHAR2( 30 ) := 'COMPARERESULT';   --
   ComparisonDataSourceCol CONSTANT VARCHAR2( 30 ) := 'COMPARISONDATASOURCE';
   --
   ComparisonProductCol CONSTANT VARCHAR2( 30 ) := 'COMPARISONPRODUCT';
   --
   ComparisonProductDescrCol CONSTANT VARCHAR2( 30 ) := 'COMPARISONPRODUCTDESCR';
   --
   ComparisonProfileCol CONSTANT VARCHAR2( 30 ) := 'COMPARISONPROFILE';
   --
   ComparisonProfileDescrCol CONSTANT VARCHAR2( 30 ) := 'COMPARISONPROFILEDESCR';
   --
   ComparisonServingSizeCol CONSTANT VARCHAR2( 30 ) := 'COMPARISONSERVINGSIZE';
   --
   CompGroupIdCol       CONSTANT VARCHAR2( 30 ) := 'COMPGROUPID';   --
   ComplexLabelLogCol   CONSTANT VARCHAR2( 30 ) := 'COMPLEXLABELLOG';
   --
   ComplexLabelLogIdCmpStatusCol CONSTANT VARCHAR2( 30 ) := 'COMPLEXLABELLOGIDCMPSTATUS';
   --
   ComplexLabelLogIdCol CONSTANT VARCHAR2( 30 ) := 'COMPLEXLABELLOGID';
   --
   CompLogIdCol         CONSTANT VARCHAR2( 30 ) := 'COMPLOGID';   --
   ComponentCalcQtyCmpStatusCol CONSTANT VARCHAR2( 30 ) := 'COMPONENTCALCQTYCMPSTATUS';
   --
   ComponentCalcQtyCol  CONSTANT VARCHAR2( 30 ) := 'COMPONENTCALCQTY';
   --
   ComponentDescriptionCol CONSTANT VARCHAR2( 30 ) := 'COMPONENTDESCRIPTION';
   --
   ComponentOwnerIdCol  CONSTANT VARCHAR2( 30 ) := 'COMPONENTOWNERID';
   --
   ComponentPartNoCol   CONSTANT VARCHAR2( 30 ) := 'COMPONENTPARTNO';
   --
   ComponentPlantCmpStatusCol CONSTANT VARCHAR2( 30 ) := 'COMPONENTPLANTCMPSTATUS';
   --
   ComponentPlantCol    CONSTANT VARCHAR2( 30 ) := 'COMPONENTPLANT';   --
   ComponentRevisionCmpStatusCol CONSTANT VARCHAR2( 30 ) := 'COMPONENTREVISIONCMPSTATUS';
   --
   ComponentRevisionCol CONSTANT VARCHAR2( 30 ) := 'COMPONENTREVISION';
   --
   ComponentScrapCmpStatusCol CONSTANT VARCHAR2( 30 ) := 'COMPONENTSCRAPCMPSTATUS';
   --
   ComponentScrapCol    CONSTANT VARCHAR2( 30 ) := 'COMPONENTSCRAP';   --
   ComponentScrapSyncCol CONSTANT VARCHAR2( 30 ) := 'COMPONENTSCRAPSYNC';
   --
   ConditionCol         CONSTANT VARCHAR2( 30 ) := 'CONDITION';   --
   ConditionDescriptionCol CONSTANT VARCHAR2( 30 ) := 'CONDITIONDESCRIPTION';
   --
   ConfigurationCol     CONSTANT VARCHAR2( 30 ) := 'CONFIGURATION';   --
   ContributesToTotalCalCol CONSTANT VARCHAR2( 30 ) := 'CONTRIBUTESTOTOTALCALORIES';
   --
   ConversionFactorCmpStatusCol CONSTANT VARCHAR2( 30 ) := 'CONVERSIONFACTORCMPSTATUS';
   --
   ConversionFactorCol  CONSTANT VARCHAR2( 30 ) := 'CONVERSIONFACTOR';
   --
   ConvertedQuantityCol CONSTANT VARCHAR2( 30 ) := 'CONVERTEDQUANTITY';
   --
   ConvertedQuantityWithScrapCol CONSTANT VARCHAR2( 30 ) := 'CONVERTEDQUANTITYWITHSCRAP';
   --
   CopyCol              CONSTANT VARCHAR2( 30 ) := 'COPY';   --
   CostCol              CONSTANT VARCHAR2( 30 ) := 'COST';   --
   CostWithScrapCol     CONSTANT VARCHAR2( 30 ) := 'COSTWITHSCRAP';   --
   CountryCol           CONSTANT VARCHAR2( 30 ) := 'COUNTRY';   --
   Created_OnCol        CONSTANT VARCHAR2( 30 ) := 'CREATED_ON';   --
   CreatedByCol         CONSTANT VARCHAR2( 30 ) := 'CREATEDBY';   --
   CreatedOnCol         CONSTANT VARCHAR2( 30 ) := 'CREATEDON';   --
   CreateLocalPartAllowedCol CONSTANT VARCHAR2( 30 ) := 'CREATELOCALPARTALLOWED';
   --
   CriticalEffectiveDateCol CONSTANT VARCHAR2( 30 ) := 'CRITICALEFFECTIVEDATE';
   --
   CtfaIdCol            CONSTANT VARCHAR2( 30 ) := 'CTFAID';   --
   CtfaInternationalCol CONSTANT VARCHAR2( 30 ) := 'CTFAINTERNATIONAL';
   --
   CtfaNameCol          CONSTANT VARCHAR2( 30 ) := 'CTFANAME';   --
   CultureCol           CONSTANT VARCHAR2( 30 ) := 'CULTURE';   --
   CurrencyCol          CONSTANT VARCHAR2( 30 ) := 'CURRENCY';   --
   CurrentDateCol       CONSTANT VARCHAR2( 30 ) := 'CURRENTDATE';   --
   CurrentOnlyAccessCol CONSTANT VARCHAR2( 30 ) := 'CURRENTONLYACCESS';
   --
   CustomerCol          CONSTANT VARCHAR2( 30 ) := 'CUSTOMER';   --
   DataSourceCol        CONSTANT VARCHAR2( 30 ) := 'DATASOURCE';   --
   DataTypeCol          CONSTANT VARCHAR2( 30 ) := 'DATATYPE';   --
   DataTypeDescriptionCol CONSTANT VARCHAR2( 30 ) := 'DATATYPEDESCRIPTION';
   --
   Date1CmpStatusCol    CONSTANT VARCHAR2( 30 ) := 'DATE1CMPSTATUS';   --
   Date1Col             CONSTANT VARCHAR2( 30 ) := 'DATE1';   --
   Date2CmpStatusCol    CONSTANT VARCHAR2( 30 ) := 'DATE2CMPSTATUS';   --
   Date2Col             CONSTANT VARCHAR2( 30 ) := 'DATE2';   --
   DateImportedCol      CONSTANT VARCHAR2( 30 ) := 'DATEIMPORTED';   --
   DateValueCol         CONSTANT VARCHAR2( 30 ) := 'DATEVALUE';   --
   DBTypeCol            CONSTANT VARCHAR2( 30 ) := 'DBTYPE';   --
   DeclareCol           CONSTANT VARCHAR2( 30 ) := 'DECLAREFLAG';   --
   DecSepCol            CONSTANT VARCHAR2( 30 ) := 'DECSEP';   --
   DefaultFltCol        CONSTANT VARCHAR2( 30 ) := 'DEFAULTFLT';   --
   DeletedOnCol         CONSTANT VARCHAR2( 30 ) := 'DELETEDON';   --
   Description2Col      CONSTANT VARCHAR2( 30 ) := 'DESCRIPTION2';   --
   DescriptionCmpStatusCol CONSTANT VARCHAR2( 30 ) := 'DESCRIPTIONCMPSTATUS';
   --
   DescriptionCol       CONSTANT VARCHAR2( 30 ) := 'DESCRIPTION';   --
   DesktopObjectCol     CONSTANT VARCHAR2( 30 ) := 'DESKTOPOBJECT';   --
   DetailDescriptionCol CONSTANT VARCHAR2( 30 ) := 'DETAILDESCRIPTION';
   --
   DetailIdCol          CONSTANT VARCHAR2( 30 ) := 'DETAILID';   --
   DetailsCol           CONSTANT VARCHAR2( 30 ) := 'DETAILS';   --
   DevisionCol          CONSTANT VARCHAR2( 30 ) := 'DEVISION';   --
   DiscontinuationDateCol CONSTANT VARCHAR2( 30 ) := 'DISCONTINUATIONDATE';
   --
   DiscontinuationIndicatorCol CONSTANT VARCHAR2( 30 ) := 'DISCONTINUATIONINDICATOR';
   --
   DiscontinuedCol      CONSTANT VARCHAR2( 30 ) := 'DISCONTINUED';   --
   DisplayBomLevelCol   CONSTANT VARCHAR2( 30 ) := 'DISPLAYBOMLEVEL';
   --
   DisplayFlagCol       CONSTANT VARCHAR2( 30 ) := 'DISPLAY';   --
   DisplayFormatHeaderNameCol CONSTANT VARCHAR2( 30 ) := 'DISPLAYFORMATHEADERNAME';
   --
   DisplayFormatIdCol   CONSTANT VARCHAR2( 30 ) := 'DISPLAYFORMATID';
   --
   DisplayFormatRevisionCol CONSTANT VARCHAR2( 30 ) := 'DISPLAYFORMATREVISION';
   --
   DisplayNameCol       CONSTANT VARCHAR2( 30 ) := 'DISPLAYNAME';   --
   EditableCol          CONSTANT VARCHAR2( 30 ) := 'EDITABLE';   --
   ElectronicSignatureCol CONSTANT VARCHAR2( 30 ) := 'ELECTRONICSIGNATURE';
   --
   EmailAddressCol      CONSTANT VARCHAR2( 30 ) := 'EMAILADDRESS';   --
   EmailTitleCol        CONSTANT VARCHAR2( 30 ) := 'EMAILTITLE';   --
   EndDateCol           CONSTANT VARCHAR2( 30 ) := 'ENDDATE';   --
   EndPageCol           CONSTANT VARCHAR2( 30 ) := 'ENDPAGE';   --
   ErrorCodeCol         CONSTANT VARCHAR2( 30 ) := 'ERRORCODE';   --
   ErrorParameterIdCol  CONSTANT VARCHAR2( 30 ) := 'ERRORPARAMETERID';
   --
   ErrorTextCol         CONSTANT VARCHAR2( 30 ) := 'ERRORTEXT';   --
   EsSeqNoCol           CONSTANT VARCHAR2( 30 ) := 'ES_SEQ_NO';   --
   EventDataCol         CONSTANT VARCHAR2( 30 ) := 'EVENTDATA';   --
   EventDetailsCol      CONSTANT VARCHAR2( 30 ) := 'EVENTDETAILS';   --
   EventIdCol           CONSTANT VARCHAR2( 30 ) := 'EVENTID';   --
   EventNameCol         CONSTANT VARCHAR2( 30 ) := 'EVENTNAME';   --
   EventSequenceCol     CONSTANT VARCHAR2( 30 ) := 'EVENTSEQUENCE';   --
   EventServiceNameCol  CONSTANT VARCHAR2( 30 ) := 'EVENTSERVICENAME';
   --
   EventTypeCol         CONSTANT VARCHAR2( 30 ) := 'EVENTTYPE';   --
   ExemptionCol         CONSTANT VARCHAR2( 30 ) := 'EXEMPTION';   --
   ExpireDateCol        CONSTANT VARCHAR2( 30 ) := 'EXPIREDATE';   --
   ExplosionDateCol     CONSTANT VARCHAR2( 30 ) := 'EXPLOSIONDATE';   --
   ExportedCol          CONSTANT VARCHAR2( 30 ) := 'EXPORTED';   --
   ExtendableCol        CONSTANT VARCHAR2( 30 ) := 'EXTENDABLE';   --
   ExtendablePropertyGroupCol CONSTANT VARCHAR2( 30 ) := 'EXTENDABLEPROPERTYGROUP';
   --
   ExtendableSectionCol CONSTANT VARCHAR2( 30 ) := 'EXTENDABLESECTION';
   --
   ExtendedCol          CONSTANT VARCHAR2( 30 ) := 'EXTENDED';   --
   ExtendedQuantityCol  CONSTANT VARCHAR2( 30 ) := 'EXTENDEDQUANTITY';
   --
   ExternalCol          CONSTANT VARCHAR2( 30 ) := 'EXTERNAL';   --
   FailCol              CONSTANT VARCHAR2( 30 ) := 'FAIL';   --
   FatAdjustmentCol     CONSTANT VARCHAR2( 30 ) := 'FATADJUSTMENT';   --
   FatCol               CONSTANT VARCHAR2( 30 ) := 'FAT';   --
   FieldCol             CONSTANT VARCHAR2( 30 ) := 'FIELD';   --
   FieldIdCol           CONSTANT VARCHAR2( 30 ) := 'FIELDID';   --
   FieldTypeCol         CONSTANT VARCHAR2( 30 ) := 'FIELDTYPE';   --
   FileNameCol          CONSTANT VARCHAR2( 30 ) := 'FILENAME';   --
   FileSizeCol          CONSTANT VARCHAR2( 30 ) := 'FILESIZE';   --
   FileTypeCol          CONSTANT VARCHAR2( 30 ) := 'FILETYPE';   --
   FilterCommentCol     CONSTANT VARCHAR2( 30 ) := 'FLTCOMMENT';   --
   FilterIdCol          CONSTANT VARCHAR2( 30 ) := 'FILTERID';   --
   FixedQuantityCmpStatusCol CONSTANT VARCHAR2( 30 ) := 'FIXEDQUANTITYCMPSTATUS';
   --
   FixedQuantityCol     CONSTANT VARCHAR2( 30 ) := 'FIXEDQUANTITY';   --
   FltLanguageDescriptionCol CONSTANT VARCHAR2( 30 ) := 'FLTLANGDESCR';   --
   FltOpAccessGroupCol  CONSTANT VARCHAR2( 30 ) := 'FLTOPACCESSGROUP';
   --
   FltOpAlternativePartNoCol CONSTANT VARCHAR2( 30 ) := 'FLTOPALTPARTNO';   --
   FltOpBomChangedCol   CONSTANT VARCHAR2( 30 ) := 'FLTOPBOMCHANGED';
   --
   FltOpChangedDateCol  CONSTANT VARCHAR2( 30 ) := 'FLTOPCHANGEDDATE';
   --
   FltOpClass1IdCol     CONSTANT VARCHAR2( 30 ) := 'FLTOPCLASS1ID';   --
   FltOpClass2IdCol     CONSTANT VARCHAR2( 30 ) := 'FLTOPCLASS2ID';   --
   FltOpClass3IdCol     CONSTANT VARCHAR2( 30 ) := 'FLTOPCLASS3ID';   --
   FltOpCreatedByCol    CONSTANT VARCHAR2( 30 ) := 'FLTOPCREATEDBY';   --
   FltOpCreatedOnCol    CONSTANT VARCHAR2( 30 ) := 'FLTOPCREATEDON';   --
   FltOpCriticalEffectiveDateCol CONSTANT VARCHAR2( 30 ) := 'FLTOPCRITICALEFFECTIVEDATE';
   --
   FltOpDescriptionCol  CONSTANT VARCHAR2( 30 ) := 'FLTOPDESCRIPTION';
   --
   FltOpExportedCol     CONSTANT VARCHAR2( 30 ) := 'FLTOPEXPORTED';   --
   FltOpFrameIdCol      CONSTANT VARCHAR2( 30 ) := 'FLTOPFRAMEID';   --
   FltOpFrameOwnerCol   CONSTANT VARCHAR2( 30 ) := 'FLTOPFRAMEOWNER';
   --
   FltOpFrameRevisionCol CONSTANT VARCHAR2( 30 ) := 'FLTOPFRAMEREV';   --
   FltOpIntCol          CONSTANT VARCHAR2( 30 ) := 'FLTOPINT';   --
   FltOpIntFrameNoCol   CONSTANT VARCHAR2( 30 ) := 'FLTOPINTFRAMENO';
   --
   FltOpIntFrameRevisionCol CONSTANT VARCHAR2( 30 ) := 'FLTOPINTFRAMEREV';
   --
   FltOpIntPartNoCol    CONSTANT VARCHAR2( 30 ) := 'FLTOPINTPARTNO';   --
   FltOpIntPartRevisonCol CONSTANT VARCHAR2( 30 ) := 'FLTOPINTPARTREV';
   --
   FltOpIssuedDateCol   CONSTANT VARCHAR2( 30 ) := 'FLTOPISSUEDDATE';
   --
   FltOpLanguageDescriptionCol CONSTANT VARCHAR2( 30 ) := 'FLTOPLANGDESCR';   --
   FltOpLanguageIdCol   CONSTANT VARCHAR2( 30 ) := 'FLTOPLANGID';   --
   FltOpLastModifiedByCol CONSTANT VARCHAR2( 30 ) := 'FLTOPLASTMODIFIEDBY';
   --
   FltOpLastModifiedOnCol CONSTANT VARCHAR2( 30 ) := 'FLTOPLASTMODIFIEDON';
   --
   FltOpMultiLanguageCol CONSTANT VARCHAR2( 30 ) := 'FLTOPMULTILANG';   --
   FltOpObsolescenceDateCol CONSTANT VARCHAR2( 30 ) := 'FLTOPOBSOLESCENCEDATE';
   --
   FltOpOwnerCol        CONSTANT VARCHAR2( 30 ) := 'FLTOPOWNER';   --
   FltOpPartNoCol       CONSTANT VARCHAR2( 30 ) := 'FLTOPPARTNO';   --
   FltOpPEDInSyncCol    CONSTANT VARCHAR2( 30 ) := 'FLTOPPEDINSYNC';   --
   FltOpPhaseinToleranceCol CONSTANT VARCHAR2( 30 ) := 'FLTOPPHASEINTOLERANCE';
   --
   FltOpPlannedEffectiveDateCol CONSTANT VARCHAR2( 30 ) := 'FLTOPPLANNEDEFFECTIVEDATE';
   --
   FltOpPlantCol        CONSTANT VARCHAR2( 30 ) := 'FLTOPPLANT';   --
   FltOpRevisionCol     CONSTANT VARCHAR2( 30 ) := 'FLTOPREVISION';   --
   FltOpSpecificationTypeGroupCol CONSTANT VARCHAR2( 30 ) := 'FLTOPSPECTYPEGROUP';
   --
   FltOpStatusChangedDateCol CONSTANT VARCHAR2( 30 ) := 'FLTOPSTATUSCHANGEDDATE';
   --
   FltOpStatusCol       CONSTANT VARCHAR2( 30 ) := 'FLTOPSTATUS';   --
   FltOpStatusTypeCol   CONSTANT VARCHAR2( 30 ) := 'FLTOPSTATUSTYPE';
   --
   FltOpWorkflowGroupIdCol CONSTANT VARCHAR2( 30 ) := 'FLTOPWORKFLOWGROUPID';
   --
   FollowOnMaterialCol  CONSTANT VARCHAR2( 30 ) := 'FOLLOWONMATERIAL';
   --
   FoodClaimAlertIdCol  CONSTANT VARCHAR2( 30 ) := 'FOODCLAIMALERTID';
   --
   FoodClaimCdIdCol     CONSTANT VARCHAR2( 30 ) := 'FOODCLAIMCDID';   --
   FoodClaimCritIdCol   CONSTANT VARCHAR2( 30 ) := 'FOODCLAIMCRITID';
   --
   FoodClaimCritRuleCdIdCol CONSTANT VARCHAR2( 30 ) := 'FOODCLAIMCRITRULECDID';
   --
   FoodClaimCritRuleIdCol CONSTANT VARCHAR2( 30 ) := 'FOODCLAIMCRITRULEID';
   --
   FoodClaimDescriptionCol CONSTANT VARCHAR2( 30 ) := 'FOODCLAIMDESCRIPTION';
   --
   FoodClaimIdCol       CONSTANT VARCHAR2( 30 ) := 'FOODCLAIMID';   --
   FoodClaimLabelIdCol  CONSTANT VARCHAR2( 30 ) := 'FOODCLAIMLABELID';
   --
   FoodClaimNoteIdCol   CONSTANT VARCHAR2( 30 ) := 'FOODCLAIMNOTEID';
   --
   FoodClaimSynIdCol    CONSTANT VARCHAR2( 30 ) := 'FOODCLAIMSYNID';   --
   FoodTypeIdCol        CONSTANT VARCHAR2( 30 ) := 'FOODTYPEID';   --
   FootNoteCol          CONSTANT VARCHAR2( 30 ) := 'FOOTNOTE';   --
   FootNoteIdCol        CONSTANT VARCHAR2( 30 ) := 'FOOTNOTEID';   --
   ForenameCol          CONSTANT VARCHAR2( 30 ) := 'FORENAME';   --
   FormatIdCol          CONSTANT VARCHAR2( 30 ) := 'FORMATID';   --
   FormattedFrameCol    CONSTANT VARCHAR2( 30 ) := 'FORMATTEDFRAME';   --
   FormatValueCol       CONSTANT VARCHAR2( 30 ) := 'FORMATVALUE';   --
   FrameDescriptionCol  CONSTANT VARCHAR2( 30 ) := 'FRAMEDESCRIPTION';
   --
   FrameNoCol           CONSTANT VARCHAR2( 30 ) := 'FRAMENO';   --
   FrameOwnerCol        CONSTANT VARCHAR2( 30 ) := 'FRAMEOWNER';   --
   FrameOwnerDescriptionCol CONSTANT VARCHAR2( 30 ) := 'FRAMEOWNERDESCRIPTION';
   --
   FrameRevisionCol     CONSTANT VARCHAR2( 30 ) := 'FRAMEREVISION';   --
   FramesOnlyCol        CONSTANT VARCHAR2( 30 ) := 'FRAMESONLY';   --
   FreeObjectCol        CONSTANT VARCHAR2( 30 ) := 'FREEOBJECT';   --
   FreeSqlCol           CONSTANT VARCHAR2( 30 ) := 'FREESQL';   --
   FreeTextIdCol        CONSTANT VARCHAR2( 30 ) := 'FREETEXTID';   --
   FromDateCol          CONSTANT VARCHAR2( 30 ) := 'FROMDATE';   --
   FromStatusDescriptionCol CONSTANT VARCHAR2( 30 ) := 'FROMSTATUSDESCRIPTION';
   --
   FunctionCol          CONSTANT VARCHAR2( 30 ) := 'FUNCTION';   --
   FunctionIdCol        CONSTANT VARCHAR2( 30 ) := 'FUNCTIONID';   --
   FunctionNameCol      CONSTANT VARCHAR2( 30 ) := 'FUNCTIONNAME';   --
   GlobalCol            CONSTANT VARCHAR2( 30 ) := 'GLOBAL';   --
   GroupDescriptionCol  CONSTANT VARCHAR2( 30 ) := 'GROUPDESCRIPTION';
   --
   GroupIdCol           CONSTANT VARCHAR2( 30 ) := 'GROUPID';   --
   GroupNameCol         CONSTANT VARCHAR2( 30 ) := 'GROUPNAME';   --
   GUIDCol              CONSTANT VARCHAR2( 30 ) := 'GUID';   --
   GuiLanguageCol       CONSTANT VARCHAR2( 30 ) := 'GUILANGUAGE';   --
   HandleCol            CONSTANT VARCHAR2( 30 ) := 'HANDLE';   --
   HarmonisedCol        CONSTANT VARCHAR2( 30 ) := 'HARMONISED';   --
   HasAccessCol         CONSTANT VARCHAR2( 30 ) := 'HASACCESS';   --
   HasItemsCol          CONSTANT VARCHAR2( 30 ) := 'HASITEMS';   --
   --AP00886496 Start
   HasToBePresentCol    CONSTANT VARCHAR2( 30 ) := 'HASTOBEPRESENT';   --
   --AP00886496 End
   HasTestMethodConditionCol CONSTANT VARCHAR2( 30 ) := 'HASTESTMETHODCONDITION';
   --
   HeaderCol            CONSTANT VARCHAR2( 30 ) := 'HEADER';   --
   HeaderIdCol          CONSTANT VARCHAR2( 30 ) := 'HEADERID';   --
   HeaderRevisionCol    CONSTANT VARCHAR2( 30 ) := 'HEADERREVISION';   --
   HeaderValueCol       CONSTANT VARCHAR2( 30 ) := 'HEADERVALUE';   --
   HeightCol            CONSTANT VARCHAR2( 30 ) := 'HEIGHT';   --
   HierarchicalLevelCol CONSTANT VARCHAR2( 30 ) := 'HIERARCHICALLEVEL';
   --
   HistoricCol          CONSTANT VARCHAR2( 30 ) := 'HISTORIC';   --
   HistoricDateCol      CONSTANT VARCHAR2( 30 ) := 'HISTORICDATE';   --
   HistoricOnlyAccessCol CONSTANT VARCHAR2( 30 ) := 'HISTORICONLYACCESS';
   --
   IdCol                CONSTANT VARCHAR2( 30 ) := 'ID';   --
   IdentifierCol        CONSTANT VARCHAR2( 30 ) := 'IDENTIFIER';   --
   IgnorePartPlantRelationCol CONSTANT VARCHAR2( 30 ) := 'IGNOREPARTPLANTRELATION';
   --
   IncludeCol           CONSTANT VARCHAR2( 30 ) := 'INCLUDE';   --
   IncludedCol          CONSTANT VARCHAR2( 30 ) := 'INCLUDED';   --
   Info1Col             CONSTANT VARCHAR2( 30 ) := 'INFO1';   --
   Info2Col             CONSTANT VARCHAR2( 30 ) := 'INFO2';   --
   InfoCol              CONSTANT VARCHAR2( 30 ) := 'INFO';   --
   IngQtyCmpStatusCol   CONSTANT VARCHAR2( 30 ) := 'INGQTYCMPSTATUS';
   --
   IngQtyCol            CONSTANT VARCHAR2( 30 ) := 'INGQTY';   --
   IngQuantityPercentageCol CONSTANT VARCHAR2( 30 ) := 'INGQUANTITYPERCENTAGE';
   --
   IngredientCol        CONSTANT VARCHAR2( 30 ) := 'INGREDIENT';   --
   IngredientCommentCol CONSTANT VARCHAR2( 30 ) := 'INGREDIENTCOMMENT';
   --
   IngredientIdCmpStatusCol CONSTANT VARCHAR2( 30 ) := 'INGREDIENTIDCMPSTATUS';
   --
   IngredientIdCol      CONSTANT VARCHAR2( 30 ) := 'INGREDIENTID';   --
   IngredientInternationalCol CONSTANT VARCHAR2( 30 ) := 'INGREDIENTINTERNATIONAL';
   --
   IngredientLevelCol   CONSTANT VARCHAR2( 30 ) := 'INGREDIENTLEVEL';
   --
   IngredientParentCol  CONSTANT VARCHAR2( 30 ) := 'INGREDIENTPARENT';
   --
   IngredientParentIdCol CONSTANT VARCHAR2( 30 ) := 'INGREDIENTPARENTID';
   --
   IngredientParentIntlCol CONSTANT VARCHAR2( 30 ) := 'INGREDIENTPARENTINTL';
   --
   IngredientQuantityCol CONSTANT VARCHAR2( 30 ) := 'INGREDIENTQUANTITY';
   --
   IngredientRevisionCol CONSTANT VARCHAR2( 30 ) := 'INGREDIENTREVISION';
   --
   IngredientSequenceCol CONSTANT VARCHAR2( 30 ) := 'INGREDIENTSEQUENCE';
   --
   IngredientTypeCol    CONSTANT VARCHAR2( 30 ) := 'INGREDIENTTYPE';   --
   InitialProfileCol    CONSTANT VARCHAR2( 30 ) := 'INITIALPROFILE';   --
   InitialStatusCol     CONSTANT VARCHAR2( 30 ) := 'INITIALSTATUS';   --
   InstalledOnCol       CONSTANT VARCHAR2( 30 ) := 'INSTALLEDON';   --
   InternationalAccessCol CONSTANT VARCHAR2( 30 ) := 'INTERNATIONALACCESS';
   --
   InternationalCol     CONSTANT VARCHAR2( 30 ) := 'INTERNATIONAL';   --
   InternationalConditionCol CONSTANT VARCHAR2( 30 ) := 'INTERNATIONALCONDITION';
   --
   InternationalConfigurationCol CONSTANT VARCHAR2( 30 ) := 'CONFIGURATIONINTERNATIONAL';
   --
   InternationalDescriptionCol CONSTANT VARCHAR2( 30 ) := 'INTERNATIONALDESCRIPTION';
   --
   InternationalEquivalentCol CONSTANT VARCHAR2( 30 ) := 'INTERNATIONALEQUIVALENT';
   --
   InternationalPartNoCol CONSTANT VARCHAR2( 30 ) := 'INTERNATIONALPARTNO';
   --
   InternationalRevisionCol CONSTANT VARCHAR2( 30 ) := 'INTERNATIONALPARTREVISION';
   --
   IntFrameNoCol        CONSTANT VARCHAR2( 30 ) := 'INTFRAMENO';   --
   IntFrameRevisionCol  CONSTANT VARCHAR2( 30 ) := 'INTFRAMEREV';   --
   IntlCol              CONSTANT VARCHAR2( 30 ) := 'INTL';   --
   IntlEqlntCmpStatusCol CONSTANT VARCHAR2( 30 ) := 'INTLEQLNTCMPSTATUS';
   --
   IntlTestMethodConditionCol CONSTANT VARCHAR2( 30 ) := 'INTLTESTMETHODCONDITION';
   --
   IntPartNoCol         CONSTANT VARCHAR2( 30 ) := 'INTPARTNO';   --
   IntPartRevisionCol   CONSTANT VARCHAR2( 30 ) := 'INTPARTREV';   --
   IsBomEqualCol        CONSTANT VARCHAR2( 30 ) := 'ISBOMEQUAL';   --
   IsBomSectionCol      CONSTANT VARCHAR2( 30 ) := 'ISBOMSECTION';   --
   IsCaloriesCol        CONSTANT VARCHAR2( 30 ) := 'ISCALORIES';   --
   --
   --R-0004ba46-591
   IsDefault            CONSTANT VARCHAR2( 30 ) := 'ISDEFAULT';   --
   --
   IsExtendableCol      CONSTANT VARCHAR2( 30 ) := 'ISEXTENDABLE';   --
   IsFatCol             CONSTANT VARCHAR2( 30 ) := 'ISFAT';   --
   IsFatSolubleCol      CONSTANT VARCHAR2( 30 ) := 'ISFATSOLUBLE';   --
   IsInFunctionCmpStatusCol CONSTANT VARCHAR2( 30 ) := 'ISINFUNCTIONCMPSTATUS';
   --
   IsInFunctionCol      CONSTANT VARCHAR2( 30 ) := 'ISINFUNCTION';   --
   IsInGroupCmpStatusCol CONSTANT VARCHAR2( 30 ) := 'ISINGROUPCMPSTATUS';
   --
   IsInGroupCol         CONSTANT VARCHAR2( 30 ) := 'ISINGROUP';   --
   IsMoistureCol        CONSTANT VARCHAR2( 30 ) := 'ISMOISTURE';   --
   IsPreferredCol       CONSTANT VARCHAR2( 30 ) := 'ISPREFERRED';   --
   IsProcessDataCol     CONSTANT VARCHAR2( 30 ) := 'ISPROCESSDATA';   --
   IsProcessSectionCol  CONSTANT VARCHAR2( 30 ) := 'ISPROCESSSECTION';
   --
   IsSubsectionCol      CONSTANT VARCHAR2( 30 ) := 'ISSUBSECTION';   --
   IssuedDateCol        CONSTANT VARCHAR2( 30 ) := 'ISSUEDDATE';   --
   IssueLocationCmpStatusCol CONSTANT VARCHAR2( 30 ) := 'ISSUELOCATIONCMPSTATUS';
   --
   IssueLocationCol     CONSTANT VARCHAR2( 30 ) := 'ISSUELOCATION';   --
   IssueUomCol          CONSTANT VARCHAR2( 30 ) := 'ISSUEUOM';   --
   IsUpdateableCol      CONSTANT VARCHAR2( 30 ) := 'ISUPDATEABLE';   --
   IsUsedCol            CONSTANT VARCHAR2( 30 ) := 'ISUSED';   --
   ItemCategoryCmpStatusCol CONSTANT VARCHAR2( 30 ) := 'ITEMCATEGORYCMPSTATUS';
   --
   ItemCategoryCol      CONSTANT VARCHAR2( 30 ) := 'ITEMCATEGORY';   --
   ItemCategoryDescrCol CONSTANT VARCHAR2( 30 ) := 'ITEMCATEGORYDESCR';
   --
   ItemDescriptionCol   CONSTANT VARCHAR2( 30 ) := 'ITEMDESCRIPTION';
   --
   ItemIdCol            CONSTANT VARCHAR2( 30 ) := 'ITEMID';   --
   ItemInfoCol          CONSTANT VARCHAR2( 30 ) := 'ITEMINFO';   --
   ItemNumberCmpStatusCol CONSTANT VARCHAR2( 30 ) := 'ITEMNUMBERCMPSTATUS';
   --
   ItemNumberCol        CONSTANT VARCHAR2( 30 ) := 'ITEMNUMBER';   --
   ItemOwner2Col        CONSTANT VARCHAR2( 30 ) := 'ITEMOWNER2';   --
   ItemOwnerCol         CONSTANT VARCHAR2( 30 ) := 'ITEMOWNER';   --
   ItemPartNoCol        CONSTANT VARCHAR2( 30 ) := 'ITEMPARTNO';   --
   ItemRevision2Col     CONSTANT VARCHAR2( 30 ) := 'ITEMREVISION2';   --
   ItemRevisionCol      CONSTANT VARCHAR2( 30 ) := 'ITEMREVISION';   --
   ItemTypeCol          CONSTANT VARCHAR2( 30 ) := 'ITEMTYPE';   --
   JobDescriptionCol    CONSTANT VARCHAR2( 30 ) := 'JOBDESCRIPTION';   --
   JobStatusCol         CONSTANT VARCHAR2( 30 ) := 'JOBSTATUS';   --
   KeyCol               CONSTANT VARCHAR2( 30 ) := 'KEYID';   --
   KeyIdCol             CONSTANT VARCHAR2( 30 ) := 'KEYID';   --
   KeyOperatorCol       CONSTANT VARCHAR2( 30 ) := 'KEYOPERATOR';   --
   KeyTypeCol           CONSTANT VARCHAR2( 30 ) := 'KEYTYPE';   --
   KeyUomCol            CONSTANT VARCHAR2( 30 ) := 'KEYUOM';   --
   KeyValueCol          CONSTANT VARCHAR2( 30 ) := 'KEYVALUE';   --
   KeywordCol           CONSTANT VARCHAR2( 30 ) := 'KEYWORD';   --
   KeywordDescriptionCol CONSTANT VARCHAR2( 30 ) := 'KWDESCRIPTION';   --
   KeywordIdCol         CONSTANT VARCHAR2( 30 ) := 'KEYWORDID';   --
   KeywordTypeCol       CONSTANT VARCHAR2( 30 ) := 'KEYWORDTYPE';   --
   KeywordTypeDescriptionCol CONSTANT VARCHAR2( 30 ) := 'KEYWORDTYPEDESCRIPTION';
   --
   KeywordUsageCol      CONSTANT VARCHAR2( 30 ) := 'KEYWORDUSAGE';   --
   KeywordValueCol      CONSTANT VARCHAR2( 30 ) := 'KEYWORDVALUE';   --
   KeywordValueListCol  CONSTANT VARCHAR2( 30 ) := 'KWVALUELIST';   --
   LabelCol             CONSTANT VARCHAR2( 30 ) := 'LABEL';   --
   LabelItemCmpStatusCol CONSTANT VARCHAR2( 30 ) := 'LABELITEMCMPSTATUS';
   --
   LabelRTFCol          CONSTANT VARCHAR2( 30 ) := 'LABELRTF';   --
   LabelStatusCol       CONSTANT VARCHAR2( 30 ) := 'LABELSTATUS';   --
   LabelTypeCol         CONSTANT VARCHAR2( 30 ) := 'LABELTYPE';   --
   LabelXmlCol          CONSTANT VARCHAR2( 30 ) := 'LABELXML';   --
   LanguageCol          CONSTANT VARCHAR2( 30 ) := 'LANGUAGE';   --
   LanguageDescriptionCol CONSTANT VARCHAR2( 30 ) := 'LANGUAGEDESCRIPTION';
   --
   LanguageIdCol        CONSTANT VARCHAR2( 30 ) := 'LANGUAGEID';   --
   LastEditedByCol      CONSTANT VARCHAR2( 30 ) := 'LASTEDITEDBY';   --
   LastEditedOnFieldsCol CONSTANT VARCHAR2( 30 ) := 'LASTEDITEDONFIELDS';
   --
   LastModifiedByCol    CONSTANT VARCHAR2( 30 ) := 'LASTMODIFIEDBY';   --
   LastModifiedOnCol    CONSTANT VARCHAR2( 30 ) := 'LASTMODIFIEDON';   --
   LastNameCol          CONSTANT VARCHAR2( 30 ) := 'LASTNAME';   --
   LastSavedToTCOnCol   CONSTANT VARCHAR2( 30 ) := 'LASTSAVEDTOTCON';
   --
   LayoutArgument10Col  CONSTANT VARCHAR2( 30 ) := 'LAYOUTARGUMENT10';
   --
   LayoutArgument1Col   CONSTANT VARCHAR2( 30 ) := 'LAYOUTARGUMENT1';
   --
   LayoutArgument2Col   CONSTANT VARCHAR2( 30 ) := 'LAYOUTARGUMENT2';
   --
   LayoutArgument3Col   CONSTANT VARCHAR2( 30 ) := 'LAYOUTARGUMENT3';
   --
   LayoutArgument4Col   CONSTANT VARCHAR2( 30 ) := 'LAYOUTARGUMENT4';
   --
   LayoutArgument5Col   CONSTANT VARCHAR2( 30 ) := 'LAYOUTARGUMENT5';
   --
   LayoutArgument6Col   CONSTANT VARCHAR2( 30 ) := 'LAYOUTARGUMENT6';
   --
   LayoutArgument7Col   CONSTANT VARCHAR2( 30 ) := 'LAYOUTARGUMENT7';
   --
   LayoutArgument8Col   CONSTANT VARCHAR2( 30 ) := 'LAYOUTARGUMENT8';
   --
   LayoutArgument9Col   CONSTANT VARCHAR2( 30 ) := 'LAYOUTARGUMENT9';
   --
   LayoutHeaderCol      CONSTANT VARCHAR2( 30 ) := 'LAYOUTHEADER';   --
   LayoutIdCol          CONSTANT VARCHAR2( 30 ) := 'LAYOUTID';   --
   LayoutNameCol        CONSTANT VARCHAR2( 30 ) := 'LAYOUTNAME';   --
   LayoutRevisionCol    CONSTANT VARCHAR2( 30 ) := 'LAYOUTREVISION';   --
   LayoutTypeCol        CONSTANT VARCHAR2( 30 ) := 'LAYOUTTYPE';   --
   LeadTimeOffsetCmpStatusCol CONSTANT VARCHAR2( 30 ) := 'LEADTIMEOFFSETCMPSTATUS';
   --
   LeadTimeOffsetCol    CONSTANT VARCHAR2( 30 ) := 'LEADTIMEOFFSET';   --
   LengthCol            CONSTANT VARCHAR2( 30 ) := 'LENGTH';   --
   LevelCol             CONSTANT VARCHAR2( 30 ) := 'LEVEL';   --
   LicenseKeyCol        CONSTANT VARCHAR2( 30 ) := 'LICENSEKEY';   --
   LicenseNumberCol     CONSTANT VARCHAR2( 30 ) := 'LICENSENUMBER';   --
   LimitedConfiguratorCol CONSTANT VARCHAR2( 30 ) := 'LIMITEDCONFIGURATOR';
   --
   LineCol              CONSTANT VARCHAR2( 30 ) := 'LINE';   --
   LineRevisionCol      CONSTANT VARCHAR2( 30 ) := 'LINEREVISION';   --
   LinkedToTCCol        CONSTANT VARCHAR2( 30 ) := 'LINKEDTOTC';   --
   ListIndicatorCol     CONSTANT VARCHAR2( 30 ) := 'LISTINDICATOR';   --
   LiveDBCol            CONSTANT VARCHAR2( 30 ) := 'LIVEDB';   --
   LocalDescriptionCol  CONSTANT VARCHAR2( 30 ) := 'LOCALDESCRIPTION';
   --
   LocationCol          CONSTANT VARCHAR2( 30 ) := 'LOCATION';   --
   LocationIdCol        CONSTANT VARCHAR2( 30 ) := 'LOCATIONID';   --
   LockedCol            CONSTANT VARCHAR2( 8 ) := 'LOCKED';   --
   LoggingXmlCol        CONSTANT VARCHAR2( 30 ) := 'LOGGINGXML';   --
   LogIdCol             CONSTANT VARCHAR2( 30 ) := 'LOGID';   --
   LogNameCol           CONSTANT VARCHAR2( 30 ) := 'LOGNAME';   --
   LogTypeCol           CONSTANT VARCHAR2( 30 ) := 'LOGTYPE';   --
   LongDescriptionCol   CONSTANT VARCHAR2( 30 ) := 'LONGDESCRIPTION';
   --
   LowerLimitCol        CONSTANT VARCHAR2( 30 ) := 'LOWERLIMIT';   --
   MakeUpCol            CONSTANT VARCHAR2( 30 ) := 'MAKEUP';   --
   MandatoryCol         CONSTANT VARCHAR2( 30 ) := 'MANDATORY';   --
   ManufacturerCol      CONSTANT VARCHAR2( 30 ) := 'MANUFACTURER';   --
   ManufacturerIdCol    CONSTANT VARCHAR2( 30 ) := 'MANUFACTURERID';   --
   ManufacturerPlantCol CONSTANT VARCHAR2( 30 ) := 'MANUFACTURERPLANT';
   --
   ManufacturerPlantNoCol CONSTANT VARCHAR2( 30 ) := 'MANUFACTURERPLANTNO';
   --
   MaskCol              CONSTANT VARCHAR2( 30 ) := 'MASK';   --
   MaskIdCol            CONSTANT VARCHAR2( 30 ) := 'MASKID';   --
   MaterialClassCol     CONSTANT VARCHAR2( 64 ) := 'MATERIALCLASS';   --
   MaterialClassIdCol   CONSTANT VARCHAR2( 30 ) := 'MATERIALCLASSID';
   --
   MaterialCodeCol      CONSTANT VARCHAR2( 30 ) := 'MATERIALCODE';   --
   MaximumQuantityCmpStatusCol CONSTANT VARCHAR2( 30 ) := 'MAXIMUMQUANTITYCMPSTATUS';
   --
   MaximumQuantityCol   CONSTANT VARCHAR2( 30 ) := 'MAXIMUMQUANTITY';
   --
   MaximumWeightCol     CONSTANT VARCHAR2( 30 ) := 'MAXWEIGHT';   --
   MessageCol           CONSTANT VARCHAR2( 30 ) := 'MESSAGE';   --
   MessageIdCol         CONSTANT VARCHAR2( 30 ) := 'MESSAGEID';   --
   MessageLevelCol      CONSTANT VARCHAR2( 30 ) := 'MESSAGELEVEL';   --
   MessageTypeCol       CONSTANT VARCHAR2( 30 ) := 'MESSAGETYPE';   --
   MethodDetailCol      CONSTANT VARCHAR2( 30 ) := 'METHODDETAIL';   --
   MetricCol            CONSTANT VARCHAR2( 30 ) := 'METRIC';   --
   MinimumQuantityCmpStatusCol CONSTANT VARCHAR2( 30 ) := 'MINIMUMQUANTITYCMPSTATUS';
   --
   MinimumQuantityCol   CONSTANT VARCHAR2( 30 ) := 'MINIMUMQUANTITY';
   --
   ModeCol              CONSTANT VARCHAR2( 30 ) := 'MODE';   --
   ModifiableCol        CONSTANT VARCHAR2( 30 ) := 'MODIFIABLE';   --
   ModulesCol           CONSTANT VARCHAR2( 30 ) := 'MODULES';   --
   MoistureCol          CONSTANT VARCHAR2( 30 ) := 'MOISTURE';   --
   MoistureTargetCol    CONSTANT VARCHAR2( 30 ) := 'MOISTURETARGET';   --
   MopSequenceCol       CONSTANT VARCHAR2( 30 ) := 'MOPSEQUENCE';   --
   MrpPhaseAccessCol    CONSTANT VARCHAR2( 30 ) := 'MRPPHASEACCESS';   --
   MrpPlanningAccessCol CONSTANT VARCHAR2( 30 ) := 'MRPPLANNINGACCESS';
   --
   MrpProductionAccessCol CONSTANT VARCHAR2( 30 ) := 'MRPPRODUCTIONACCESS';
   --
   MrpUpdateCol         CONSTANT VARCHAR2( 30 ) := 'MRPUPDATE';   --
   MsgCol               CONSTANT VARCHAR2( 30 ) := 'MSG';   --
   MtpDescriptionCol    CONSTANT VARCHAR2( 30 ) := 'MANUFACTURERTYPE';
   --
   MtpIdCol             CONSTANT VARCHAR2( 30 ) := 'MANUFACTURERTYPEID';
   --
   MtpInternationalCol  CONSTANT VARCHAR2( 30 ) := 'MANUFACTURERTYPEINTERNATIONAL';
   --
   MtpStatusCol         CONSTANT VARCHAR2( 30 ) := 'MANUFACTURERTYPESTATUS';
   --
   MultiLanguageCol     CONSTANT VARCHAR2( 30 ) := 'MULTILANGUAGE';   --
   NameCol              CONSTANT VARCHAR2( 30 ) := 'NAME';   --
   NewAssemblyScrapCol  CONSTANT VARCHAR2( 30 ) := 'NEWASSEMBLYSCRAP';
   --
   NewBulkMaterialCol   CONSTANT VARCHAR2( 30 ) := 'NEWBULKMATERIAL';
   --
   NewCommodityCodeCol  CONSTANT VARCHAR2( 30 ) := 'NEWCOMMODITYCODE';
   --
   NewComponentScrapCol CONSTANT VARCHAR2( 30 ) := 'NEWCOMPONENTSCRAP';
   --
   NewComponentScrapSyncCol CONSTANT VARCHAR2( 30 ) := 'NEWCOMPONENTSCRAPSYNC';
   --
   NewConversionFactorCol CONSTANT VARCHAR2( 30 ) := 'NEWCONVERSIONFACTOR';
   --
   NewDiscontinuationDateCol CONSTANT VARCHAR2( 30 ) := 'NEWDISCONTINUATIONDATE';
   --
   NewDiscontinuationIndicatorCol CONSTANT VARCHAR2( 30 ) := 'NEWDISCONTINUATIONINDICATOR';
   --
   NewFollowOnMaterialCol CONSTANT VARCHAR2( 30 ) := 'NEWFOLLOWONMATERIAL';
   --
   NewIssueLocationCol  CONSTANT VARCHAR2( 30 ) := 'NEWISSUELOCATION';
   --
   NewIssueUomCol       CONSTANT VARCHAR2( 30 ) := 'NEWISSUEUOM';   --
   NewItemCategoryCol   CONSTANT VARCHAR2( 30 ) := 'NEWITEMCATEGORY';
   --
   NewItemNumberCol     CONSTANT VARCHAR2( 30 ) := 'NEWITEMNUMBER';   --
   NewLeadTimeOffsetCol CONSTANT VARCHAR2( 30 ) := 'NEWLEADTIMEOFFSET';
   --
   NewObsoleteCol       CONSTANT VARCHAR2( 30 ) := 'NEWOBSOLETE';   --
   NewOperationalStepCol CONSTANT VARCHAR2( 30 ) := 'NEWOPERATIONALSTEP';
   --
   NewPhaseInToleranceCol CONSTANT VARCHAR2( 30 ) := 'NEWPHASEINTOLERANCE';
   --
   NewPlannedEffectiveDateCol CONSTANT VARCHAR2( 30 ) := 'NEWPLANNEDEFFECTIVEDATE';
   --
   NewPlantAccessCol    CONSTANT VARCHAR2( 30 ) := 'NEWPLANTACCESS';   --
   NewPlantCol          CONSTANT VARCHAR2( 30 ) := 'NEWPLANT';   --
   NewRelevencyToCostingCol CONSTANT VARCHAR2( 30 ) := 'NEWRELEVENCYTOCOSTING';
   --
   NewValueAssIdCol     CONSTANT VARCHAR2( 30 ) := 'NEWVALUEASSID';   --
   NewValueCharCol      CONSTANT VARCHAR2( 30 ) := 'NEWVALUECHAR';   --
   NewValueCol          CONSTANT VARCHAR2( 30 ) := 'NEWVALUE';   --
   NewValueDateCol      CONSTANT VARCHAR2( 30 ) := 'NEWVALUEDATE';   --
   NewValueNumCol       CONSTANT VARCHAR2( 30 ) := 'NEWVALUENUM';   --
   NewValueTmIdCol      CONSTANT VARCHAR2( 30 ) := 'NEWVALUETMID';   --
   NextStatusCol        CONSTANT VARCHAR2( 30 ) := 'NEXTSTATUS';   --
   NextStatusDescriptionCol CONSTANT VARCHAR2( 30 ) := 'NEXTSTATUSDESCRIPTION';
   --
   NextStatusIdCol      CONSTANT VARCHAR2( 30 ) := 'NEXTSTATUSID';   --
   NextStatusTypeCol    CONSTANT VARCHAR2( 30 ) := 'NEXTSTATUSTYPE';   --
   NodeCol              CONSTANT VARCHAR2( 30 ) := 'NODE';   --
   NodeIdCol            CONSTANT VARCHAR2( 30 ) := 'NODEID';   --
   NodeTextCol          CONSTANT VARCHAR2( 30 ) := 'NODETEXT';   --
   NoteCmpStatusCol     CONSTANT VARCHAR2( 30 ) := 'NOTECMPSTATUS';   --
   NoteCol              CONSTANT VARCHAR2( 30 ) := 'NOTE';   --
   NumberOfUsersCol     CONSTANT VARCHAR2( 30 ) := 'NUMBEROFUSERS';   --
   Numeric10Col         CONSTANT VARCHAR2( 30 ) := 'NUMERIC10';   --
   Numeric1CmpStatusCol CONSTANT VARCHAR2( 30 ) := 'NUMERIC1CMPSTATUS';
   --
   Numeric1Col          CONSTANT VARCHAR2( 30 ) := 'NUMERIC1';   --
   Numeric2CmpStatusCol CONSTANT VARCHAR2( 30 ) := 'NUMERIC2CMPSTATUS';
   --
   Numeric2Col          CONSTANT VARCHAR2( 30 ) := 'NUMERIC2';   --
   Numeric3CmpStatusCol CONSTANT VARCHAR2( 30 ) := 'NUMERIC3CMPSTATUS';
   --
   Numeric3Col          CONSTANT VARCHAR2( 30 ) := 'NUMERIC3';   --
   Numeric4CmpStatusCol CONSTANT VARCHAR2( 30 ) := 'NUMERIC4CMPSTATUS';
   --
   Numeric4Col          CONSTANT VARCHAR2( 30 ) := 'NUMERIC4';   --
   Numeric5CmpStatusCol CONSTANT VARCHAR2( 30 ) := 'NUMERIC5CMPSTATUS';
   --
   Numeric5Col          CONSTANT VARCHAR2( 30 ) := 'NUMERIC5';   --
   Numeric6Col          CONSTANT VARCHAR2( 30 ) := 'NUMERIC6';   --
   Numeric7Col          CONSTANT VARCHAR2( 30 ) := 'NUMERIC7';   --
   Numeric8Col          CONSTANT VARCHAR2( 30 ) := 'NUMERIC8';   --
   Numeric9Col          CONSTANT VARCHAR2( 30 ) := 'NUMERIC9';   --
   NumericValueCol      CONSTANT VARCHAR2( 30 ) := 'NUMERICVALUE';   --
   NumSaveToTCInProgressCol CONSTANT VARCHAR2( 30 ) := 'NUMSAVEDTOTCINPROGRESS';
   --
   NutLogIdCol          CONSTANT VARCHAR2( 30 ) := 'NUTLOGID';   --
   NutrBasicWeightCol   CONSTANT VARCHAR2( 30 ) := 'NUTRBASICWEIGHT';
   --
   NutrBasicWeightPGCol CONSTANT VARCHAR2( 30 ) := 'NUTRBASICWEIGHTPG';
   --
   NutrBasicWeightPGIdCol CONSTANT VARCHAR2( 30 ) := 'NUTRBASICWEIGHTPGID';
   --
   NutrBasicWeightPropertyCol CONSTANT VARCHAR2( 30 ) := 'NUTRBASICWEIGHTPROPERTY';
   --
   NutrBasicWeightPropertyIdCol CONSTANT VARCHAR2( 30 ) := 'NUTRBASICWEIGHTPROPERTYID';
   --
   NutrBasicWeightValueCol CONSTANT VARCHAR2( 30 ) := 'NUTRBASICWEIGHTVALUE';
   --
   NutrBasicWeightValueIdCol CONSTANT VARCHAR2( 30 ) := 'NUTRBASICWEIGHTIDVALUE';
   --
   NutrEnergyAttributeKcalCol CONSTANT VARCHAR2( 30 ) := 'NUTRENERGYATTRIBUTEKCAL';
   --
   NutrEnergyAttributeKcalIdCol CONSTANT VARCHAR2( 30 ) := 'NUTRENERGYATTRIBUTEKCALID';
   --
   NutrEnergyAttributeKJCol CONSTANT VARCHAR2( 30 ) := 'NUTRENERGYATTRIBUTEKJ';
   --
   NutrEnergyAttributeKjIdCol CONSTANT VARCHAR2( 30 ) := 'NUTRENERGYATTRIBUTEKJID';
   --
   NutrEnergyKCalValueCol CONSTANT VARCHAR2( 30 ) := 'NUTRENERGYKCALVALUE';
   --
   NutrEnergyKCalValueIdCol CONSTANT VARCHAR2( 30 ) := 'NUTRENERGYKCALVALUEID';
   --
   NutrEnergyKJValueCol CONSTANT VARCHAR2( 30 ) := 'NUTRENERGYKJVALUE';
   --
   NutrEnergyKJValueIdCol CONSTANT VARCHAR2( 30 ) := 'NUTRENERGYKJVALUEID';
   --
   NutrEnergyPGCol      CONSTANT VARCHAR2( 30 ) := 'NUTRENERGYPG';   --
   NutrEnergyPGIdCol    CONSTANT VARCHAR2( 30 ) := 'NUTRENERGYPGID';   --
   NutrEnergyPropertyKcalCol CONSTANT VARCHAR2( 30 ) := 'NUTRENERGYPROPERTYKCAL';
   --
   NutrEnergyPropertyKcalIdCol CONSTANT VARCHAR2( 30 ) := 'NUTRENERGYPROPERTYKCALID';
   --
   NutrEnergyPropertyKJCol CONSTANT VARCHAR2( 30 ) := 'NUTRENERGYPROPERTYKJ';
   --
   NutrEnergyPropertyKjIdCol CONSTANT VARCHAR2( 30 ) := 'NUTRENERGYPROPERTYKJID';
   --
   NutrEnergySectionCol CONSTANT VARCHAR2( 30 ) := 'NUTRENERGYSECTION';
   --
   NutrEnergySectSubsectCol CONSTANT VARCHAR2( 30 ) := 'NUTRENERGYSECTSUBSECT';
   --
   NutrEnergySubSectionCol CONSTANT VARCHAR2( 30 ) := 'NUTRENERGYSUBSECTION';
   --
   NutrientCol          CONSTANT VARCHAR2( 30 ) := 'NUTRIENT';   --
   NutritionalIdCol     CONSTANT VARCHAR2( 30 ) := 'NUTRITIONALID';   --
   NutritionalxmlCol    CONSTANT VARCHAR2( 30 ) := 'NUTRITIONALXMLVALUE';
   --
   NutrNoteIdCol        CONSTANT VARCHAR2( 30 ) := 'NUTRNOTEID';   --
   NutrRoundingPGCol    CONSTANT VARCHAR2( 30 ) := 'NUTRROUNDINGPG';   --
   NutrRoundingPGIdCol  CONSTANT VARCHAR2( 30 ) := 'NUTRROUNDINGPGID';
   --
   NutrRoundingRDACol   CONSTANT VARCHAR2( 30 ) := 'NUTRROUNDINGRDA';
   --
   NutrRoundingRDAIdCol CONSTANT VARCHAR2( 30 ) := 'NUTRROUNDINGRDAID';
   --
   NutrRoundingSectionCol CONSTANT VARCHAR2( 30 ) := 'NUTRROUNDINGSECTION';
   --
   NutrRoundingSectSubsectCol CONSTANT VARCHAR2( 30 ) := 'NUTRROUNDINGSECTSUBSECT';
   --
   NutrRoundingSubsectionCol CONSTANT VARCHAR2( 30 ) := 'NUTRROUNDINGSUBSECTION';
   --
   NutrRoundingValueCol CONSTANT VARCHAR2( 30 ) := 'NUTRROUNDINGVALUE';
   --
   NutrRoundingValueIdCol CONSTANT VARCHAR2( 30 ) := 'NUTRROUNDINGVALUEID';
   --
   NutrSectionCol       CONSTANT VARCHAR2( 30 ) := 'NUTRSECTION';   --
   NutrSectSubsectCol   CONSTANT VARCHAR2( 30 ) := 'NUTRSECTSUBSECT';
   --
   NutrSequenceCol      CONSTANT VARCHAR2( 30 ) := 'NUTRSEQUENCE';   --
   NutrServingPGCol     CONSTANT VARCHAR2( 30 ) := 'NUTRSERVINGPG';   --
   NutrServingPGIdCol   CONSTANT VARCHAR2( 30 ) := 'NUTRSERVINGPGID';
   --
   NutrServingSectionCol CONSTANT VARCHAR2( 30 ) := 'NUTRSERVINGSECTION';
   --
   NutrServingSectSubsectCol CONSTANT VARCHAR2( 30 ) := 'NUTRSERVINGSECTSUBSECT';
   --
   NutrServingSubsectionCol CONSTANT VARCHAR2( 30 ) := 'NUTRSERVINGSUBSECTION';
   --
   NutrServingValueCol  CONSTANT VARCHAR2( 30 ) := 'NUTRSERVINGVALUE';
   --
   NutrServingValueIdCol CONSTANT VARCHAR2( 30 ) := 'NUTRSERVINGVALUEID';
   --
   NutrSubsectionCol    CONSTANT VARCHAR2( 30 ) := 'NUTRSUBSECTION';   --
   ObjectAndRefTextAccessCol CONSTANT VARCHAR2( 30 ) := 'OBJECTANDREFTEXTACCESS';
   --
   ObjectCol            CONSTANT VARCHAR2( 30 ) := 'OBJECT';   --
   ObjectIdCol          CONSTANT VARCHAR2( 30 ) := 'OBJECTID';   --
   ObjectImportedCol    CONSTANT VARCHAR2( 30 ) := 'OBJECTIMPORTED';   --
   ObjectOwnerCol       CONSTANT VARCHAR2( 30 ) := 'OBJECTOWNER';   --
   ObjectRevisionCol    CONSTANT VARCHAR2( 30 ) := 'OBJECTREVISION';   --
   ObsolescenceDateCol  CONSTANT VARCHAR2( 30 ) := 'OBSOLESCENCEDATE';
   --
   ObsoleteCol          CONSTANT VARCHAR2( 30 ) := 'OBSOLETE';   --
   OfficialCol          CONSTANT VARCHAR2( 30 ) := 'OFFICIAL';   --
   OldAssemblyScrapCol  CONSTANT VARCHAR2( 30 ) := 'OLDASSEMBLYSCRAP';
   --
   OldBulkMaterialCol   CONSTANT VARCHAR2( 30 ) := 'OLDBULKMATERIAL';
   --
   OldCommodityCodeCol  CONSTANT VARCHAR2( 30 ) := 'OLDCOMMODITYCODE';
   --
   OldComponentScrapCol CONSTANT VARCHAR2( 30 ) := 'OLDCOMPONENTSCRAP';
   --
   OldComponentScrapSyncCol CONSTANT VARCHAR2( 30 ) := 'OLDCOMPONENTSCRAPSYNC';
   --
   OldDiscontinuationDateCol CONSTANT VARCHAR2( 30 ) := 'OLDDISCONTINUATIONDATE';
   --
   OldDiscontinuationIndicatorCol CONSTANT VARCHAR2( 30 ) := 'OLDDISCONTINUATIONINDICATOR';
   --
   OldFollowOnMaterialCol CONSTANT VARCHAR2( 30 ) := 'OLDFOLLOWONMATERIAL';
   --
   OldIssueLocationCol  CONSTANT VARCHAR2( 30 ) := 'OLDISSUELOCATION';
   --
   OldIssueUomCol       CONSTANT VARCHAR2( 30 ) := 'OLDISSUEUOM';   --
   OldItemCategoryCol   CONSTANT VARCHAR2( 30 ) := 'OLDITEMCATEGORY';
   --
   OldLeadTimeOffsetCol CONSTANT VARCHAR2( 30 ) := 'OLDLEADTIMEOFFSET';
   --
   OldObsoleteCol       CONSTANT VARCHAR2( 30 ) := 'OLDOBSOLETE';   --
   OldOperationalStepCol CONSTANT VARCHAR2( 30 ) := 'OLDOPERATIONALSTEP';
   --
   OldPhaseInToleranceCol CONSTANT VARCHAR2( 30 ) := 'OLDPHASEINTOLERANCE';
   --
   OldPlannedEffectiveDateCol CONSTANT VARCHAR2( 30 ) := 'OLDPLANNEDEFFECTIVEDATE';
   --
   OldPlantAccessCol    CONSTANT VARCHAR2( 30 ) := 'OLDPLANTACCESS';   --
   OldPlantCol          CONSTANT VARCHAR2( 30 ) := 'OLDPLANT';   --
   OldRelevencyToCostingCol CONSTANT VARCHAR2( 30 ) := 'OLDRELEVENCYTOCOSTING';
   --
   OldValueAssCol       CONSTANT VARCHAR2( 30 ) := 'OLDVALUEASS';   --
   OldValueAssIdCol     CONSTANT VARCHAR2( 30 ) := 'OLDVALUEASSID';   --
   OldValueCharCol      CONSTANT VARCHAR2( 30 ) := 'OLDVALUECHAR';   --
   OldValueCol          CONSTANT VARCHAR2( 30 ) := 'OLDVALUE';   --
   OldValueDateCol      CONSTANT VARCHAR2( 30 ) := 'OLDVALUEDATE';   --
   OldValueNumCol       CONSTANT VARCHAR2( 30 ) := 'OLDVALUENUM';   --
   OldValueTmCol        CONSTANT VARCHAR2( 30 ) := 'OLDVALUETM';   --
   OldValueTmIdCol      CONSTANT VARCHAR2( 30 ) := 'OLDVALUETMID';   --
   OleObjectCol         CONSTANT VARCHAR2( 30 ) := 'OLEOBJECT';   --
   OnlyInDevelopmentCol CONSTANT VARCHAR2( 30 ) := 'ONLYINDEVELOPMENT';
   --
   OperationalStepCmpStatusCol CONSTANT VARCHAR2( 30 ) := 'OPERATIONALSTEPCMPSTATUS';
   --
   OperationalStepCol   CONSTANT VARCHAR2( 30 ) := 'OPERATIONALSTEP';
   --
   OperatorIdCol        CONSTANT VARCHAR2( 30 ) := 'OPERATORID';   --
   OperatorValueCol     CONSTANT VARCHAR2( 30 ) := 'OPERATORVALUE';   --
   OptionalCol          CONSTANT VARCHAR2( 30 ) := 'OPTIONAL';   --
   OptionsCol           CONSTANT VARCHAR2( 30 ) := 'OPTIONS';   --
   OrderCol             CONSTANT VARCHAR2( 30 ) := 'ORDER';   --
   OriginalIngredientCol CONSTANT VARCHAR2( 30 ) := 'ORIGINALINGREDIENT';
   --
   OriginalIngredientDescCol CONSTANT VARCHAR2( 30 ) := 'ORIGINALINGREDIENTDESC';
   --
   OwnerCol             CONSTANT VARCHAR2( 30 ) := 'OWNER';   --
   OwnerDescriptionCol  CONSTANT VARCHAR2( 30 ) := 'OWNERDESCRIPTION';
   --
   OwnerIdCol           CONSTANT VARCHAR2( 30 ) := 'OWNERID';   --
   PanelIdCol           CONSTANT VARCHAR2( 30 ) := 'PANELID';   --
   ParagraphCmpStatusCol CONSTANT VARCHAR2( 30 ) := 'PARAGRAPHCMPSTATUS';
   --
   ParagraphCol         CONSTANT VARCHAR2( 30 ) := 'PARAGRAPH';   --
   Parameter1Col        CONSTANT VARCHAR2( 30 ) := 'PARAMETER1';   --
   Parameter2Col        CONSTANT VARCHAR2( 30 ) := 'PARAMETER2';   --
   ParameterCol         CONSTANT VARCHAR2( 30 ) := 'PARAMETER';   --
   ParameterDataCol     CONSTANT VARCHAR2( 30 ) := 'PARAMETERDATA';   --
   ParameterIdCol       CONSTANT VARCHAR2( 30 ) := 'PARAMETERID';   --
   ParameterNameCol     CONSTANT VARCHAR2( 30 ) := 'PARAMETERNAME';   --
   ParentCol            CONSTANT VARCHAR2( 30 ) := 'PARENT';   --
   ParentFoodClaimIdCol CONSTANT VARCHAR2( 30 ) := 'PARENTFOODCLAIMID';
   --
   ParentIdCol          CONSTANT VARCHAR2( 30 ) := 'PARENTID';   --
   ParentInfoCol        CONSTANT VARCHAR2( 30 ) := 'PARENTINFO';   --
   ParentOwnerCol       CONSTANT VARCHAR2( 30 ) := 'PARENTOWNER';   --
   ParentPartNoCol      CONSTANT VARCHAR2( 30 ) := 'PARENTPARTNO';   --
   ParentRevisionCol    CONSTANT VARCHAR2( 30 ) := 'PARENTREVISION';   --
   ParentRowIndexCol    CONSTANT VARCHAR2( 30 ) := 'PARENTROWINDEX';   --
   ParentSequenceCol    CONSTANT VARCHAR2( 30 ) := 'PARENTSEQUENCE';   --
   PartManufacturerRevisionCol CONSTANT VARCHAR2( 30 ) := 'PARTMANUFACTURERREVISION';
   --
   PartNoCol            CONSTANT VARCHAR2( 30 ) := 'PARTNO';   --
   PartSourceCol        CONSTANT VARCHAR2( 30 ) := 'PARTSOURCE';   --
   PartTypeCol          CONSTANT VARCHAR2( 30 ) := 'PARTTYPE';   --
   PartTypeDescriptionCol CONSTANT VARCHAR2( 30 ) := 'PARTTYPEDESCRIPTION';
   --
   PartTypeIdCol        CONSTANT VARCHAR2( 30 ) := 'PARTTYPEID';   --
   PassedCol            CONSTANT VARCHAR2( 30 ) := 'PASSED';   --
   PasswordCol          CONSTANT VARCHAR2( 30 ) := 'PASSWORD';   --
   PedGroupCol          CONSTANT VARCHAR2( 30 ) := 'PEDGROUP';   --
   PedGroupIdCol        CONSTANT VARCHAR2( 30 ) := 'PEDGROUPID';   --
   PercentageTotalCol   CONSTANT VARCHAR2( 30 ) := 'PERCENTAGETOTAL';
   --
   PeriodCol            CONSTANT VARCHAR2( 30 ) := 'PERIOD';   --
   PhantomCol           CONSTANT VARCHAR2( 30 ) := 'PHANTOM';   --
   PhaseinDateCol       CONSTANT VARCHAR2( 30 ) := 'PHASEINDATE';   --
   PhaseinStatusCol     CONSTANT VARCHAR2( 30 ) := 'PHASEINSTATUS';   --
   PhaseinToleranceCol  CONSTANT VARCHAR2( 30 ) := 'PHASEINTOLERANCE';
   --
   PhaseMrpCol          CONSTANT VARCHAR2( 30 ) := 'PHASE_MRP';   --

   --AP00892453 --AP00888937
   PidListCol           CONSTANT VARCHAR2( 30 ) := 'PIDLIST';   --

   PlannedEffectiveDateCol CONSTANT VARCHAR2( 30 ) := 'PLANNEDEFFECTIVEDATE';
   --
   PlannedEffectiveDateInSyncCol CONSTANT VARCHAR2( 30 ) := 'PLANNEDEFFECTIVEDATEINSYNC';
   --
   PlannedEffectiveDateTextCol CONSTANT VARCHAR2( 30 ) := 'PLANNEDEFFECTIVEDATETEXT';
   --
   --R18 Revert
   --PlannedStatus       CONSTANT VARCHAR2( 30 ) := 'PLANNEDSTATUS';   --
   PlanningMrpCol       CONSTANT VARCHAR2( 30 ) := 'PLANNING_MRP';   --
   PlantAccessCol       CONSTANT VARCHAR2( 30 ) := 'PLANTACCESS';   --
   PlantCol             CONSTANT VARCHAR2( 30 ) := 'PLANT';   --
   PlantDescriptionCol  CONSTANT VARCHAR2( 30 ) := 'PLANTDESCRIPTION';
   --
   PlantEffectiveDateCmpStatusCol CONSTANT VARCHAR2( 30 ) := 'PLANTEFFECTIVEDATECMPSTATUS';
   --
   PlantEffectiveDateCol CONSTANT VARCHAR2( 30 ) := 'PLANTEFFECTIVEDATE';
   --
   PlantGroupCol        CONSTANT VARCHAR2( 30 ) := 'PLANTGROUP';   --
   PlantLineConfigCol   CONSTANT VARCHAR2( 30 ) := 'PLANTLINECONFIGURATION';
   --
   PlantNoCol           CONSTANT VARCHAR2( 30 ) := 'PLANTNO';   --
   PlantObsoleteCol     CONSTANT VARCHAR2( 30 ) := 'PLANTOBSOLETE';   --
   PlantSourceCol       CONSTANT VARCHAR2( 30 ) := 'PLANTSOURCE';   --
   PlugInURLCol         CONSTANT VARCHAR2( 30 ) := 'PLUGINURL';   --
   PositionCol          CONSTANT VARCHAR2( 30 ) := 'POSITION';   --
   PreferenceCol        CONSTANT VARCHAR2( 30 ) := 'PREFERENCE';   --
   PreferredCol         CONSTANT VARCHAR2( 30 ) := 'PREFERRED';   --
   PrefixCol            CONSTANT VARCHAR2( 30 ) := 'PREFIX';   --
   PriceCol             CONSTANT VARCHAR2( 30 ) := 'PRICE';   --
   PriceType2Col        CONSTANT VARCHAR2( 30 ) := 'PRICETYPE2';   --
   PriceTypeCol         CONSTANT VARCHAR2( 30 ) := 'PRICETYPE';   --
   PrintingAllowedCol   CONSTANT VARCHAR2( 30 ) := 'PRINTINGALLOWED';
   --
   ProcessLineCol       CONSTANT VARCHAR2( 30 ) := 'PROCESSLINE';   --
   ProductCodeCol       CONSTANT VARCHAR2( 30 ) := 'PRODUCTCODE';   --
   ProductionMrpCol     CONSTANT VARCHAR2( 30 ) := 'PRODUCTION_MRP';   --
   ProfileIdCol         CONSTANT VARCHAR2( 30 ) := 'PROFILEID';   --
   ProgressCol          CONSTANT VARCHAR2( 30 ) := 'PROGRESS';   --
   ProjectIdCol         CONSTANT VARCHAR2( 30 ) := 'PROJECTID';   --
   PromptForReasonCol   CONSTANT VARCHAR2( 30 ) := 'PROMPTFORREASONCOLUMN';
   --
   PropertyCol          CONSTANT VARCHAR2( 30 ) := 'PROPERTY';   --
   PropertyGroupCol     CONSTANT VARCHAR2( 30 ) := 'PROPERTYGROUP';   --
   PropertyGroupIdCol   CONSTANT VARCHAR2( 30 ) := 'PROPERTYGROUPID';
   --
   PropertyGroupRevisionCol CONSTANT VARCHAR2( 30 ) := 'PROPERTYGROUPREVISION';
   --
   PropertyGroupTypeCol CONSTANT VARCHAR2( 30 ) := 'PROPERTYGROUPTYPE';
   --
   PropertyIdCol        CONSTANT VARCHAR2( 30 ) := 'PROPERTYID';   --
   PropertyRevisionCol  CONSTANT VARCHAR2( 30 ) := 'PROPERTYREVISION';
   --
   PropertyValue2Col    CONSTANT VARCHAR2( 30 ) := 'PROPERTYVALUE2';   --
   PropertyValueCol     CONSTANT VARCHAR2( 30 ) := 'PROPERTYVALUE';   --
   QuantityBomPctCol    CONSTANT VARCHAR2( 30 ) := 'QUANTITYBOMPCT';   --
   QuantityCmpStatusCol CONSTANT VARCHAR2( 30 ) := 'QUANTITYCMPSTATUS';
   --
   QuantityCol          CONSTANT VARCHAR2( 30 ) := 'QUANTITY';   --
   QuidCmpStatusCol     CONSTANT VARCHAR2( 30 ) := 'QUIDCMPSTATUS';   --
   QuidCol              CONSTANT VARCHAR2( 30 ) := 'QUID';   --
   ReasonCol            CONSTANT VARCHAR2( 30 ) := 'REASON';   --
   ReasonForIssueCol    CONSTANT VARCHAR2( 30 ) := 'REASONFORISSUE';   --
   ReasonForRejectionCol CONSTANT VARCHAR2( 30 ) := 'REASONFORREJECTION';
   --
   ReasonForStatusChangeCol CONSTANT VARCHAR2( 30 ) := 'REASONFORSTATUSCHANGE';
   --
   ReasonIdCol          CONSTANT VARCHAR2( 30 ) := 'REASONID';   --
   ReasonMandatoryCol   CONSTANT VARCHAR2( 30 ) := 'REASONMANDATORY';
   --
   RecFromDescriptionCmpStatusCol CONSTANT VARCHAR2( 30 ) := 'RECFROMDESCRIPTIONCMPSTATUS';
   --
   RecFromDescriptionCol CONSTANT VARCHAR2( 30 ) := 'RECFROMDESC';   --
   RecFromIdCmpStatusCol CONSTANT VARCHAR2( 30 ) := 'RECFROMIDCMPSTATUS';
   --
   RecFromIdCol         CONSTANT VARCHAR2( 30 ) := 'RECFROMID';   --
   RecirculateToCol     CONSTANT VARCHAR2( 30 ) := 'RECIRCULATETO';   --
   ReconstitutionFactorCol CONSTANT VARCHAR2( 30 ) := 'RECONSTITUTIONFACTOR';
   --
   ReconstitutionIngredDescCol CONSTANT VARCHAR2( 30 ) := 'RECONSTITUTIONINGREDDESC';
   --
   ReconstitutionIngredientCol CONSTANT VARCHAR2( 30 ) := 'RECONSTITUTIONINGREDIENT';
   --
   RecursiveStopCol     CONSTANT VARCHAR2( 30 ) := 'RECURSIVESTOP';   --
   RecWithDescriptionCmpStatusCol CONSTANT VARCHAR2( 30 ) := 'RECWITHDESCRIPTIONCMPSTATUS';
   --
   RecWithDescriptionCol CONSTANT VARCHAR2( 30 ) := 'RECWITHDESC';   --
   RecWithIdCmpStatusCol CONSTANT VARCHAR2( 30 ) := 'RECWITHIDCMPSTATUS';
   --
   RecWithIdCol         CONSTANT VARCHAR2( 30 ) := 'RECWITHID';   --
   ReferenceAmountCol   CONSTANT VARCHAR2( 30 ) := 'REFERENCEAMOUNT';
   --
   ReferencePartNoCol   CONSTANT VARCHAR2( 30 ) := 'REFERENCEPARTNO';
   --
   ReferenceRevisionCol CONSTANT VARCHAR2( 30 ) := 'REFERENCEREVISION';
   --
   ReferenceSpecCol     CONSTANT VARCHAR2( 30 ) := 'REFERENCESPEC';   --
   ReferenceSpecIdCol   CONSTANT VARCHAR2( 30 ) := 'REFERENCESPECID';
   --
   ReferenceSpecRevCol  CONSTANT VARCHAR2( 30 ) := 'REFERENCESPECREVISION';
   --
   ReferenceTextTypeCol CONSTANT VARCHAR2( 30 ) := 'REFERENCETEXTTYPE';
   --
   ReferenceTextTypeOwnerCol CONSTANT VARCHAR2( 30 ) := 'REFERENCETEXTTYPEOWNER';
   --
   RefIdCol             CONSTANT VARCHAR2( 30 ) := 'REFID';   --
   RefTypeCol           CONSTANT VARCHAR2( 30 ) := 'REFTYPE';   --
   RegionCol            CONSTANT VARCHAR2( 30 ) := 'REGION';   --
   RegistrationDescriptionCol CONSTANT VARCHAR2( 30 ) := 'REGISTRATIONDESCRIPTION';
   --
   RegistrationIdCol    CONSTANT VARCHAR2( 30 ) := 'REGISTRATIONID';   --
   RegistrationNameCol  CONSTANT VARCHAR2( 30 ) := 'REGISTRATIONNAME';
   --
   RelativeCol          CONSTANT VARCHAR2( 30 ) := 'RELATIVE';   --
   RelativeCompCol      CONSTANT VARCHAR2( 30 ) := 'RELATIVECOMP';   --
   RelativePercCol      CONSTANT VARCHAR2( 30 ) := 'RELATIVEPERC';   --
   RelativeQuantityCol  CONSTANT VARCHAR2( 30 ) := 'RELATIVEQUANTITY';
   --
   RelevancyToCostingCmpStatusCol CONSTANT VARCHAR2( 30 ) := 'RELEVANCYTOCOSTINGCMPSTATUS';
   --
   RelevancyToCostingCol CONSTANT VARCHAR2( 30 ) := 'RELEVANCYTOCOSTING';
   --
   RemapGroupCol        CONSTANT VARCHAR2( 30 ) := 'REMAPGROUP';   --
   RemapItemCol         CONSTANT VARCHAR2( 30 ) := 'REMAPITEM';   --
   RemapOriginalValueCol CONSTANT VARCHAR2( 30 ) := 'REMAPORIGINALVALUE';
   --
   RemapTypeCol         CONSTANT VARCHAR2( 30 ) := 'REMAPTYPE';   --
   RemapValueCol        CONSTANT VARCHAR2( 30 ) := 'REMAPVALUE';   --
   ReplaceByLocalizedCol CONSTANT VARCHAR2( 30 ) := 'REPLACEBYLOCALIZED';
   --
   ReportFormatCol      CONSTANT VARCHAR2( 30 ) := 'REPORTFORMAT';   --
   ReportIdCol          CONSTANT VARCHAR2( 30 ) := 'REPORTID';   --
   ReportTypeCol        CONSTANT VARCHAR2( 30 ) := 'REPORTTYPE';   --
   RequestIdCol         CONSTANT VARCHAR2( 30 ) := 'REQUESTID';   --
   ResultCol            CONSTANT VARCHAR2( 30 ) := 'RESULT';   --
   ResultTextCol        CONSTANT VARCHAR2( 30 ) := 'RESULTTEXT';   --
   RetentionCodeCol     CONSTANT VARCHAR2( 30 ) := 'RETENTIONCODE';   --
   RetentionGroupIdCol  CONSTANT VARCHAR2( 30 ) := 'RETENTIONGROUPID';
   --
   RevisionCol          CONSTANT VARCHAR2( 30 ) := 'REVISION';   --
   RowIdCol             CONSTANT VARCHAR2( 30 ) := 'ROW_ID';   --
   RowIndexCol          CONSTANT VARCHAR2( 30 ) := 'ROWINDEX';   --
   RuleDescriptionCol   CONSTANT VARCHAR2( 30 ) := 'RULEDESCRIPTION';
   --
   RuleIDCol            CONSTANT VARCHAR2( 30 ) := 'RULEID';   --
   RuleOperatorCol      CONSTANT VARCHAR2( 30 ) := 'RULEOPERATOR';   --
   RulesetCol           CONSTANT VARCHAR2( 30 ) := 'RULESET';   --
   --R-0004ba46-591
   RulesetIdCol         CONSTANT VARCHAR2( 30 ) := 'RULESETID';   --
   RuleTypeCol          CONSTANT VARCHAR2( 30 ) := 'RULETYPE';   --
   RuleValue1Col        CONSTANT VARCHAR2( 30 ) := 'RULEVALUE1';   --
   RuleValue2Col        CONSTANT VARCHAR2( 30 ) := 'RULEVALUE2';   --
   --
   SavedToTCCol         CONSTANT VARCHAR2( 30 ) := 'SAVEDTOTC';   --
   ScrapCol             CONSTANT VARCHAR2( 30 ) := 'SCRAP';   --
   ScrapFactorCol       CONSTANT VARCHAR2( 30 ) := 'SCRAPFACTOR';   --
   SectionCol           CONSTANT VARCHAR2( 30 ) := 'SECTION';   --
   SectionDescriptionCol CONSTANT VARCHAR2( 30 ) := 'SECTIONDESCRIPTION';
   --
   SectionIdCol         CONSTANT VARCHAR2( 30 ) := 'SECTIONID';   --
   SectionNameCol       CONSTANT VARCHAR2( 30 ) := 'SECTIONNAME';   --
   SectionRevisionCol   CONSTANT VARCHAR2( 30 ) := 'SECTIONREVISION';
   --
   SectionSequenceNumberCol CONSTANT VARCHAR2( 30 ) := 'SECTIONSEQUENCENUMBER';
   --
   SectionStatusCol     CONSTANT VARCHAR2( 30 ) := 'SECTIONSTATUS';   --
   --AP00925448
   SelectedCol          CONSTANT VARCHAR2( 30 ) := 'SELECTED';   --
   SelectionCol         CONSTANT VARCHAR2( 30 ) := 'SELECTION';   --
   SendToTCCol          CONSTANT VARCHAR2( 30 ) := 'SENDTOTC';   --
   SequenceCol          CONSTANT VARCHAR2( 30 ) := 'SEQUENCE';   --
   ServingConversionFactorCol CONSTANT VARCHAR2( 30 ) := 'SERVINGCONVERSIONFACTOR';
   --
   ServingSizeCol       CONSTANT VARCHAR2( 30 ) := 'SERVINGSIZE';   --
   ServingSizeIdCol     CONSTANT VARCHAR2( 30 ) := 'SERVINGSIZEID';   --
   ServingVolumeCol     CONSTANT VARCHAR2( 30 ) := 'SERVINGVOLUME';   --
   SetNumberCol         CONSTANT VARCHAR2( 30 ) := 'SETNUMBER';   --
   ShowExtendablePropertyGroupCol CONSTANT VARCHAR2( 30 ) := 'SHOWEXTENDABLEPROPERTYGROUP';
   --
   ShowExtendableSectionCol CONSTANT VARCHAR2( 30 ) := 'SHOWEXTENDABLESECTION';
   --
   ShowItemsCmpStatusCol CONSTANT VARCHAR2( 30 ) := 'SHOWITEMSCMPSTATUS';
   --
   ShowItemsCol         CONSTANT VARCHAR2( 30 ) := 'SHOWITEMS';   --
   ShowOptionalDataCol  CONSTANT VARCHAR2( 30 ) := 'SHOWOPTIONALDATA';
   --
   ShowReconstitutesCmpStatusCol CONSTANT VARCHAR2( 30 ) := 'SHOWRECONSTITUTESCMPSTATUS';
   --
   ShowReconstitutesCol CONSTANT VARCHAR2( 30 ) := 'SHOWRECONSTITUTES';
   --
   SiteCol              CONSTANT VARCHAR2( 30 ) := 'SITE';   --
   SoiCmpStatusCol      CONSTANT VARCHAR2( 30 ) := 'SOICMPSTATUS';   --
   SoiCol               CONSTANT VARCHAR2( 30 ) := 'STANDARDOFIDENTITY';
   --
   SortSequenceCmpStatusCol CONSTANT VARCHAR2( 30 ) := 'SORTSEQUENCECMPSTATUS';
   --
   SortSequenceCol      CONSTANT VARCHAR2( 30 ) := 'SORTSEQUENCE';   --
   SourceCol            CONSTANT VARCHAR2( 30 ) := 'SOURCE';   --
   SourceDescriptionCol CONSTANT VARCHAR2( 30 ) := 'SOURCEDESCRIPTION';
   --
   SourceIdCol          CONSTANT VARCHAR2( 30 ) := 'SOURCEID';   --
   Specification1Col    CONSTANT VARCHAR2( 30 ) := 'SPECIFICATION1';   --
   Specification2Col    CONSTANT VARCHAR2( 30 ) := 'SPECIFICATION2';   --
   SpecificationAccessCol CONSTANT VARCHAR2( 30 ) := 'SPECIFICATIONACCESS';
   --
   SpecificationDescriptionCol CONSTANT VARCHAR2( 30 ) := 'SPECIFICATIONDESCRIPTION';
   --
   SpecificationGroupCol CONSTANT VARCHAR2( 30 ) := 'SPECIFICATIONGROUP';
   --
   SpecificationPlantCol CONSTANT VARCHAR2( 30 ) := 'SPECPLANT';   --
   SpecificationTypeCol CONSTANT VARCHAR2( 30 ) := 'SPECIFICATIONTYPE';
   --
   SpecificationTypeDescrCol CONSTANT VARCHAR2( 30 ) := 'SPECIFICATIONTYPEDESCR';
   --
   SpecificationTypeGroupCol CONSTANT VARCHAR2( 30 ) := 'SPECIFICATIONTYPEGROUP';
   --
   SpecificationTypeIdCol CONSTANT VARCHAR2( 30 ) := 'SPECIFICATIONTYPEID';
   --
   StageCol             CONSTANT VARCHAR2( 30 ) := 'STAGE';   --
   StageFreeTextCol     CONSTANT VARCHAR2( 30 ) := 'STAGEFREETEXT';   --
   StageIdCol           CONSTANT VARCHAR2( 30 ) := 'STAGEID';   --
   StageRevisionCol     CONSTANT VARCHAR2( 30 ) := 'STAGEREVISION';   --
   StandardOfIdentityCol CONSTANT VARCHAR2( 30 ) := 'STANDARDOFIDENTITY';
   --
   StartDateCol         CONSTANT VARCHAR2( 30 ) := 'STARTDATE';   --
   StartPageCol         CONSTANT VARCHAR2( 30 ) := 'STARTPAGE';   --
   StartPositionCol     CONSTANT VARCHAR2( 30 ) := 'STARTPOSITION';   --
   StatusChangedDateCol CONSTANT VARCHAR2( 30 ) := 'STATUSCHANGEDDATE';
   --
   StatusCol            CONSTANT VARCHAR2( 30 ) := 'STATUS';   --
   StatusDateTimeCol    CONSTANT VARCHAR2( 30 ) := 'STATUSDATETIME';   --
   StatusDescriptionCol CONSTANT VARCHAR2( 30 ) := 'STATUSDESCRIPTION';
   --
   StatusIdCol          CONSTANT VARCHAR2( 30 ) := 'STATUSID';   --
   StatusNameCol        CONSTANT VARCHAR2( 30 ) := 'STATUSNAME';   --
   StatusToCol          CONSTANT VARCHAR2( 30 ) := 'STATUSTO';   --
   StatusTypeCol        CONSTANT VARCHAR2( 30 ) := 'STATUSTYPE';   --
   StatusTypeIdCol      CONSTANT VARCHAR2( 30 ) := 'STATUSTYPEID';   --
-- multilanguage 2010.06.01
   StatusTypeDescriptionCol CONSTANT VARCHAR2( 30 ) := 'STATUSTYPEDESCRIPTION';

   StreamCol            CONSTANT VARCHAR2( 30 ) := 'STREAM';   --
   String1CmpStatusCol  CONSTANT VARCHAR2( 30 ) := 'STRING1CMPSTATUS';
   --
   String1Col           CONSTANT VARCHAR2( 30 ) := 'STRING1';   --
   String2CmpStatusCol  CONSTANT VARCHAR2( 30 ) := 'STRING2CMPSTATUS';
   --
   String2Col           CONSTANT VARCHAR2( 30 ) := 'STRING2';   --
   String3CmpStatusCol  CONSTANT VARCHAR2( 30 ) := 'STRING3CMPSTATUS';
   --
   String3Col           CONSTANT VARCHAR2( 30 ) := 'STRING3';   --
   String4CmpStatusCol  CONSTANT VARCHAR2( 30 ) := 'STRING4CMPSTATUS';
   --
   String4Col           CONSTANT VARCHAR2( 30 ) := 'STRING4';   --
   String5CmpStatusCol  CONSTANT VARCHAR2( 30 ) := 'STRING5CMPSTATUS';
   --
   String5Col           CONSTANT VARCHAR2( 30 ) := 'STRING5';   --
   String6Col           CONSTANT VARCHAR2( 30 ) := 'STRING6';   --
   StringValueCol       CONSTANT VARCHAR2( 30 ) := 'STRINGVALUE';   --
   SubsectionCol        CONSTANT VARCHAR2( 30 ) := 'SUBSECTION';   --
   SubSectionDescriptionCol CONSTANT VARCHAR2( 30 ) := 'SUBSECTIONDESCRIPTION';
   --
   SubsectionIdCol      CONSTANT VARCHAR2( 30 ) := 'SUBSECTIONID';   --
   SubsectionNameCol    CONSTANT VARCHAR2( 30 ) := 'SUBSECTIONNAME';   --
   SubsectionRevisionCol CONSTANT VARCHAR2( 30 ) := 'SUBSECTIONREVISION';
   --
   SubsectionStatusCol  CONSTANT VARCHAR2( 30 ) := 'SUBSECTIONSTATUS';
   --
   SuffixCol            CONSTANT VARCHAR2( 30 ) := 'SUFFIX';   --
   SynonymIdCol         CONSTANT VARCHAR2( 30 ) := 'SYNONYMID';   --
   SynonymNameCol       CONSTANT VARCHAR2( 30 ) := 'SYNONYMNAME';   --
   SynonymRevisionCol   CONSTANT VARCHAR2( 30 ) := 'SYNONYMREVISION';
   --
   SynonymTypeDescriptionCol CONSTANT VARCHAR2( 30 ) := 'SYNONYMTYPEDESCRIPTION';
   --
   SynonymTypeIdCol     CONSTANT VARCHAR2( 30 ) := 'SYNONYMTYPEID';   --
   SynonymTypeNameCol   CONSTANT VARCHAR2( 30 ) := 'SYNONYMTYPENAME';
   --
   TargetIdCol          CONSTANT VARCHAR2( 30 ) := 'TARGETID';   --
   TCDatasetUidCol      CONSTANT VARCHAR2( 30 ) := 'TCDATASETUID';   --
   TCFormulatedItemIdCol CONSTANT VARCHAR2( 30 ) := 'TCFORMULATEDITEMID';
   --
   TCFormulatedItemRevCol CONSTANT VARCHAR2( 30 ) := 'TCFORMULATEDITEMREV';
   --
   TCItemIdCol          CONSTANT VARCHAR2( 30 ) := 'TCITEMID';   --
   TCUidCol             CONSTANT VARCHAR2( 30 ) := 'TCUID';   --
   TelephoneNumberCol   CONSTANT VARCHAR2( 30 ) := 'TELEPHONE';   --
   TestMethodCol        CONSTANT VARCHAR2( 30 ) := 'TESTMETHOD';   --
   TestMethodDetails1Col CONSTANT VARCHAR2( 30 ) := 'TESTMETHODDETAILS1';
   --
   TestMethodDetails2Col CONSTANT VARCHAR2( 30 ) := 'TESTMETHODDETAILS2';
   --
   TestMethodDetails3Col CONSTANT VARCHAR2( 30 ) := 'TESTMETHODDETAILS3';
   --
   TestMethodDetails4Col CONSTANT VARCHAR2( 30 ) := 'TESTMETHODDETAILS4';
   --
   TestMethodIdCol      CONSTANT VARCHAR2( 30 ) := 'TESTMETHODID';   --
   TestMethodRevisionCol CONSTANT VARCHAR2( 30 ) := 'TESTMETHODREVISION';
   --
   TestMethodSetNoCol   CONSTANT VARCHAR2( 30 ) := 'TESTMETHODSETNO';
   --
   TestMethodTypeCol    CONSTANT VARCHAR2( 30 ) := 'TESTMETHODTYPE';   --
   TextCol              CONSTANT VARCHAR2( 30 ) := 'TEXT';   --
   TextDescriptionCol   CONSTANT VARCHAR2( 30 ) := 'TEXTDESCRIPTION';
   --
   TextRevisionCol      CONSTANT VARCHAR2( 30 ) := 'TEXTREVISION';   --
   TextTypeCol          CONSTANT VARCHAR2( 30 ) := 'TEXTTYPE';   --
   TimestampCol         CONSTANT VARCHAR2( 30 ) := 'TIMESTAMP';   --
   ToDateCol            CONSTANT VARCHAR2( 30 ) := 'TODATE';   --
   TopLevelCol          CONSTANT VARCHAR2( 30 ) := 'TOPLEVEL';   --
   TotalCalcCostWithScrapCol CONSTANT VARCHAR2( 30 ) := 'TOTALCALCCOSTWITHSCRAP';
   --
   TotalCalcQuantityWithScrapCol CONSTANT VARCHAR2( 30 ) := 'TOTALCALCQUANTITYWITHSCRAP';
   --
   TotalCalculatedCostCol CONSTANT VARCHAR2( 30 ) := 'TOTALCALCULATEDCOST';
   --
   TotalCalculatedQuantityCol CONSTANT VARCHAR2( 30 ) := 'TOTALCALCULATEDQUANTITY';
   --
   TotalCol             CONSTANT VARCHAR2( 30 ) := 'TOTAL';   --
   ToUnitCmpStatusCol   CONSTANT VARCHAR2( 30 ) := 'TOUNITCMPSTATUS';
   --
   ToUnitCol            CONSTANT VARCHAR2( 30 ) := 'TOUNIT';   --
   TradeNameCol         CONSTANT VARCHAR2( 30 ) := 'TRADENAME';   --
   TranslatedCol        CONSTANT VARCHAR2( 30 ) := 'TRANSLATED';   --
   TransmTypeCol        CONSTANT VARCHAR2( 30 ) := 'TRANSMTYPE';   --
   TypeCol              CONSTANT VARCHAR2( 30 ) := 'TYPE';   --
   TypeNameCol          CONSTANT VARCHAR2( 30 ) := 'TYPENAME';   --
   TypeRefCol           CONSTANT VARCHAR2( 30 ) := 'TYPEREF';   --
   TypeStatusCol        CONSTANT VARCHAR2( 30 ) := 'TYPESTATUS';   --
   UnderlineCol         CONSTANT VARCHAR2( 30 ) := 'UNDERLINE';   --
   UndoCol              CONSTANT VARCHAR2( 30 ) := 'UNDO';   --
   UniqueIdCol          CONSTANT VARCHAR2( 30 ) := 'UNIQUEID';   --
   UnlockingRightCol    CONSTANT VARCHAR2( 30 ) := 'UNLOCKINGRIGHT';   --
   UomBomPctCol         CONSTANT VARCHAR2( 30 ) := 'UOMBOMPCT';   --
   UomCmpStatusCol      CONSTANT VARCHAR2( 30 ) := 'UOMCMPSTATUS';   --
   UomCol               CONSTANT VARCHAR2( 30 ) := 'UOM';   --
   UomIdCol             CONSTANT VARCHAR2( 30 ) := 'UOMID';   --
   UomRevisionCol       CONSTANT VARCHAR2( 30 ) := 'UOMREVISION';   --
   UomTypeCol           CONSTANT VARCHAR2( 30 ) := 'NONMETRIC';   --
   UpdateAllowedCol     CONSTANT VARCHAR2( 30 ) := 'UPDATEALLOWED';   --
   UpperLimitCol        CONSTANT VARCHAR2( 30 ) := 'UPPERLIMIT';   --
   URLCol               CONSTANT VARCHAR2( 30 ) := 'URL';   --
   UseBracketsCmpStatusCol CONSTANT VARCHAR2( 30 ) := 'USEBRACKETSCMPSTATUS';
   --
   UseBracketsCol       CONSTANT VARCHAR2( 30 ) := 'USEBRACKETS';   --
   UseCol               CONSTANT VARCHAR2( 30 ) := 'USE';   --
   UseDataCol           CONSTANT VARCHAR2( 30 ) := 'USEDATA';   --
   UseMopListCol        CONSTANT VARCHAR2( 30 ) := 'USEMOPLIST';   --
   UsePartCol           CONSTANT VARCHAR2( 30 ) := 'USEPART';   --
   UsePercAbsCmpStatusCol CONSTANT VARCHAR2( 30 ) := 'USEPERCABSCMPSTATUS';
   --
   UsePercAbsCol        CONSTANT VARCHAR2( 30 ) := 'USEPERCABS';   --
   UsePercentageCmpStatusCol CONSTANT VARCHAR2( 30 ) := 'USEPERCENTAGECMPSTATUS';
   --
   UsePercentageCol     CONSTANT VARCHAR2( 30 ) := 'USEPERCENTAGE';   --
   UsePercRelCmpStatusCol CONSTANT VARCHAR2( 30 ) := 'USEPERCRELCMPSTATUS';
   --
   UsePercRelCol        CONSTANT VARCHAR2( 30 ) := 'USEPERCREL';   --
   UseProfileCol        CONSTANT VARCHAR2( 30 ) := 'USEPROFILE';   --
   UserDroppedCol       CONSTANT VARCHAR2( 30 ) := 'USERDROPPED';   --
   UserIdCol            CONSTANT VARCHAR2( 30 ) := 'USERID';   --
   UserInitialsCol      CONSTANT VARCHAR2( 30 ) := 'INITIALS';   --
   UserIntlCol          CONSTANT VARCHAR2( 30 ) := 'USER_INTL';   --
   UserNameCol          CONSTANT VARCHAR2( 30 ) := 'USERNAME';   --
   UserProfileCol       CONSTANT VARCHAR2( 30 ) := 'USERPROFILE';   --
   ValidCol             CONSTANT VARCHAR2( 30 ) := 'VALID';   --
   ValidParametersCol   CONSTANT VARCHAR2( 30 ) := 'VALIDPARAMETERS';
   --
   Value1Col            CONSTANT VARCHAR2( 30 ) := 'VALUE1';   --
   Value2Col            CONSTANT VARCHAR2( 30 ) := 'VALUE2';   --
   ValueCol             CONSTANT VARCHAR2( 30 ) := 'VALUE';   --
   ValueIdCol           CONSTANT VARCHAR2( 30 ) := 'VALUEID';   --
   ValueTextCol         CONSTANT VARCHAR2( 30 ) := 'VALUETEXT';   --
   ValueTypeCol         CONSTANT VARCHAR2( 30 ) := 'VALUETYPE';   --
   VersionCol           CONSTANT VARCHAR2( 30 ) := 'VERSION';   --
   ViewBomAccessCol     CONSTANT VARCHAR2( 30 ) := 'VIEWBOMACCESS';   --
   ViewIdCol            CONSTANT VARCHAR2( 30 ) := 'VIEWID';   --
   ViewPriceCol         CONSTANT VARCHAR2( 30 ) := 'VIEWPRICE';   --
   VisibleCol           CONSTANT VARCHAR2( 30 ) := 'VISIBLE';   --
   VisitedCol           CONSTANT VARCHAR2( 30 ) := 'VISITED';   --
   VisualCol            CONSTANT VARCHAR2( 30 ) := 'VISUAL';   --
   WarningLevelCol      CONSTANT VARCHAR2( 30 ) := 'WARNINGLEVEL';   --
   WarningQuantityCol   CONSTANT VARCHAR2( 30 ) := 'WARNINGQUANTITY';
   --
   WebAllowedCol        CONSTANT VARCHAR2( 30 ) := 'WEBALLOWED';   --
   WidthCol             CONSTANT VARCHAR2( 30 ) := 'WIDTH';   --
   WorkflowGroupCol     CONSTANT VARCHAR2( 30 ) := 'WORKFLOWGROUP';   --
   WorkflowGroupIdCol   CONSTANT VARCHAR2( 30 ) := 'WORKFLOWGROUPID';
   --
   WorkflowGroupSortCol CONSTANT VARCHAR2( 30 ) := 'WORKFLOWGROUPSORT';
   --
   WorkflowIdCol        CONSTANT VARCHAR2( 30 ) := 'WORKFLOWID';   --
   YesCol               CONSTANT VARCHAR2( 30 ) := 'YES';   --
   YesNoCol             CONSTANT VARCHAR2( 30 ) := 'YESNO';   --
   YieldCmpStatusCol    CONSTANT VARCHAR2( 30 ) := 'YIELDCMPSTATUS';   --
   YieldCol             CONSTANT VARCHAR2( 30 ) := 'YIELD';   --
   --
   -- Multi-language
   AddonIDCol           CONSTANT VARCHAR2( 30 ) := 'ADDONID';
   --
END iapiConstantColumn;
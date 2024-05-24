create or replace PACKAGE iapiType
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiType.h $
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.11 (06.07.11.00-00.00) $
   --  $Modtime: 2017-Apr-12 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract:
   --           This package holds all global type
   --           definitions for the Interspec DB
   --           API

   --
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   -- $NoKeywords: $
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   -- Type definitions
   ---------------------------------------------------------------------------
   SUBTYPE Access_Type IS VARCHAR2( 1 );

   SUBTYPE Action_Type IS VARCHAR2( 1 );

   SUBTYPE AddOnAccess_Type IS itaddonac.access_type%TYPE;

   SUBTYPE ApprovedOnly_Type IS application_user.approved_only%TYPE;

   SUBTYPE Argument_Type IS ITADDONRQARG.arg%TYPE;

   SUBTYPE AuditFrequence_Type IS itprmfc.audit_freq%TYPE;

   SUBTYPE BaseColumns_Type IS VARCHAR2( 4096 );

   SUBTYPE BaseToUnit_Type IS VARCHAR2( 3 );

   SUBTYPE BaseUom_Type IS VARCHAR2( 3 );

   SUBTYPE Blob_Type IS BLOB;

   SUBTYPE BomAlternative_Type IS bom_header.alternative%TYPE;

   SUBTYPE BomComponentRevision_Type IS bom_item.component_revision%TYPE;

   SUBTYPE BomComponentScrap_Type IS bom_item.component_scrap%TYPE;

   SUBTYPE BomConvFactor_Type IS bom_item.conv_factor%TYPE;

   SUBTYPE BomHeaderCalcFlag_Type IS bom_header.calc_flag%TYPE;

   SUBTYPE BomHeaderType_Type IS bom_header.bom_type%TYPE;

   SUBTYPE BomIssueLocation_Type IS bom_item.issue_location%TYPE;

   SUBTYPE BomItemAltGroup_Type IS bom_item.alt_group%TYPE;

   SUBTYPE BomItemAltPriority_Type IS bom_item.alt_priority%TYPE;

   SUBTYPE BomItemCalcFlag_Type IS bom_item.calc_flag%TYPE;

   SUBTYPE BomItemCategory_Type IS bom_item.item_category%TYPE;

   SUBTYPE BomItemCharacter_Type IS VARCHAR2( 40 );

   SUBTYPE BomItemCode_Type IS bom_item.code%TYPE;

   SUBTYPE BomItemLongCharacter_Type IS VARCHAR2( 255 );

   SUBTYPE BomItemNumber_Type IS bom_item.item_number%TYPE;

   SUBTYPE BomItemNumeric_Type IS FLOAT;

   SUBTYPE BomItemType_Type IS bom_item.bom_item_type%TYPE;

   SUBTYPE BomLeadTimeOffset_Type IS bom_item.lead_time_offset%TYPE;

   SUBTYPE BomLevel_Type IS itnutpath.BOM_LEVEL%TYPE;

   SUBTYPE BomMakeUp_Type IS bom_item.make_up%TYPE;

   SUBTYPE BomMaxQty_Type IS bom_item.max_qty%TYPE;

   SUBTYPE BomMinQty_Type IS bom_item.min_qty%TYPE;

   SUBTYPE BomOperationalStep_Type IS bom_item.operational_step%TYPE;

   SUBTYPE BomQuantity_Type IS bom_item.quantity%TYPE;

   SUBTYPE BomRelevancyToCosting_Type IS bom_item.relevency_to_costing%TYPE;

   SUBTYPE BomUsage_Type IS bom_header.bom_usage%TYPE;

   SUBTYPE BomUsageId_Type IS bom_header.bom_usage%TYPE;

   SUBTYPE BomYield_Type IS bom_item.yield%TYPE;

   SUBTYPE Boolean_Type IS NUMBER( 1 );

   SUBTYPE Buffer_Type IS VARCHAR2( 2000 );

   SUBTYPE BulkMaterial_Type IS part_plant.BULK_MATERIAL%TYPE;

   SUBTYPE CatId_Type IS application_user.cat_id%TYPE;

   --R18 Revert
   --SUBTYPE Character_Type IS VARCHAR2( 40 );

   SUBTYPE ClaimExplosion_Type IS itclaimexplosion%ROWTYPE;

   SUBTYPE ClaimResultDAndOr_Type IS VARCHAR2( 3 );

   SUBTYPE ClaimResultDetailsRow_Type IS ITCLAIMRESULTDETAILS%ROWTYPE;

   SUBTYPE ClaimResultDRefType_Type IS NUMBER( 2 );

   SUBTYPE ClaimResultDRelativeComp_Type IS NUMBER( 1 );

   SUBTYPE ClaimResultDRelativePerc_Type IS ITCLAIMRESULTDETAILS.CALC_QTY%TYPE;

   SUBTYPE ClaimResultDRuleType_Type IS NUMBER( 1 );

   SUBTYPE ClaimResultDValueType_Type IS NUMBER( 1 );

   SUBTYPE ClaimsResultType_Type IS NUMBER( 1 );

   SUBTYPE Class3PartType_Type IS class3.TYPE%TYPE;

   SUBTYPE ClassificationCode_Type IS VARCHAR2( 8 );

   SUBTYPE ClassificationType_Type IS VARCHAR2( 8 );

   SUBTYPE ClearanceNumber_Type IS itprmfc.clearance_no%TYPE;

   SUBTYPE Clob_Type IS CLOB;

   SUBTYPE Code_Type IS itclat.code%TYPE;

   --AP01058317 --AP01054597
   SUBTYPE ColId_Type IS itnutpath.col_id%TYPE;

   SUBTYPE Configuration_Type IS process_line.configuration%TYPE;

   SUBTYPE ConfigurationSection_Type IS interspc_cfg.section%TYPE;

   SUBTYPE Culture_Type IS itaddonrq.culture%TYPE;

   SUBTYPE Currency_Type IS part_cost.currency%TYPE;

   SUBTYPE CurrentOnly_Type IS application_user.current_only%TYPE;

   SUBTYPE DatabaseObjectName_Type IS dba_objects.object_name%TYPE;

   --R-004ba46-732 Extension of multilanguage support
   SUBTYPE DatabaseTableColumn_Type IS sys.user_tab_columns.column_name%TYPE;
   --end R-004ba46-732 Extension of multilanguage support

   SUBTYPE DatabaseSchemaName_Type IS SYS.dba_users.username%TYPE;

   SUBTYPE DatabaseType_Type IS itdbprofile.db_type%TYPE;

   SUBTYPE Date_Type IS DATE;

   SUBTYPE DecimalSeperator_Type IS VARCHAR2( 1 );

   SUBTYPE DelFlag_Type IS VARCHAR2( 4 );

   SUBTYPE Description_Type IS VARCHAR2( 60 );

   --AP00861305 Start
   --This type is cretaed to hold report type names
   --which is the concatenation of item description(approximatelly max 20 chars)
   --and Property Group names (max 60 characters by definition)
   SUBTYPE DescriptionReportType_Type IS VARCHAR2( 80 );
   --AP00861305 End

   SUBTYPE ElectronicSignatureFor_Type IS ITESHS.sign_for%TYPE;

   SUBTYPE ElectronicSignatureForId_Type IS ITESHS.sign_for_id%TYPE;

   SUBTYPE ElectronicSignatureType_Type IS ITESHS.TYPE%TYPE;

   SUBTYPE ElectronicSignatureWhat_Type IS ITESHS.sign_what%TYPE;

   SUBTYPE ElectronicSignatureWhatId_Type IS ITESHS.sign_what_id%TYPE;

   SUBTYPE EmailAddress_Type IS application_user.email_address%TYPE;

   SUBTYPE EmailBody_Type IS VARCHAR2;

   SUBTYPE EmailNo_Type IS NUMBER( 8 );

   SUBTYPE EmailSender_Type IS interspc_cfg.parameter_data%TYPE;

   SUBTYPE EmailSubject_Type IS VARCHAR2;

   SUBTYPE EmailTo_Type IS VARCHAR2( 255 );

   SUBTYPE EmailType_Type IS VARCHAR2( 1 );

   SUBTYPE ErrorMessage_Type IS CHAR( 1024 );

   SUBTYPE ErrorMessageType_Type IS NUMBER;

   SUBTYPE ErrorNum_Type IS NUMBER;

   SUBTYPE ErrorText_Type IS VARCHAR2( 2048 );

   SUBTYPE ExternalLanguage_Type IS VARCHAR2( 40 );

   SUBTYPE File_Type IS UTL_FILE.file_type;

   SUBTYPE FileName_Type IS itoid.FILE_NAME%TYPE;

   SUBTYPE FilterDescription_Type IS itpfltd.description%TYPE;

   SUBTYPE FilterId_Type IS itpflt.filter_id%TYPE;

   SUBTYPE Float_Type IS FLOAT;

   SUBTYPE ForeName_Type IS application_user.forename%TYPE;

   SUBTYPE FrameNo_Type IS frame_header.frame_no%TYPE;

   SUBTYPE FramePropertyGroup_Type IS NUMBER( 6 );

   SUBTYPE FrameRevision_Type IS frame_header.revision%TYPE;

   SUBTYPE FramesOnly_Type IS application_user.frames_only%TYPE;

   SUBTYPE GuiLanguage_Type IS itaddonrq.Gui_Lang%TYPE;

   SUBTYPE HierLevel_Type IS itprcl.hier_level%TYPE;

   SUBTYPE Id_Type IS PLS_INTEGER;

   SUBTYPE Info_Type IS VARCHAR2( 4000 );

   SUBTYPE InfoLevel_Type IS NUMBER;

   SUBTYPE Ingredient_Type IS specification_ing.ingredient%TYPE;

   SUBTYPE IngredientComment_Type IS specification_ing.ing_comment%TYPE;

   SUBTYPE IngredientHierarchicLevel_Type IS specification_ing.hier_level%TYPE;

   SUBTYPE IngredientLevel_Type IS specification_ing.ing_level%TYPE;

   SUBTYPE IngredientQuantity_Type IS specification_ing.quantity%TYPE;

   SUBTYPE IngredientRecFac_Type IS specification_ing.recfac%TYPE;

   SUBTYPE IngredientSection_Type IS specification_ing.section_id%TYPE;

   SUBTYPE IngredientSequenceNumber_Type IS specification_ing.seq_no%TYPE;

   SUBTYPE IngredientSubSection_Type IS specification_ing.sub_section_id%TYPE;

   SUBTYPE IngredientSynonym_Type IS specification_ing.ing_synonym%TYPE;

   SUBTYPE InitialProfile_Type IS application_user.initial_profile%TYPE;

   SUBTYPE Initials_Type IS application_user.user_initials%TYPE;

   SUBTYPE Intl_Type IS VARCHAR2( 1 );

   SUBTYPE IssueLocation_Type IS VARCHAR2( 4 );

   SUBTYPE IssueUom_Type IS VARCHAR2( 3 );

   SUBTYPE ItemCategory_Type IS part_plant.item_category%TYPE;

   SUBTYPE ItemInfo_Type IS NUMBER( 8 );

   SUBTYPE Job_Type IS itjob.job%TYPE;

   SUBTYPE JobId_Type IS itjob.job_id%TYPE;

   SUBTYPE Keyword_Type IS itkw.kw_type%TYPE;

   SUBTYPE KeywordId_Type IS itkw.kw_id%TYPE;

   SUBTYPE KeywordValue_Type IS specification_kw.kw_value%TYPE;

   SUBTYPE LabelLogResultDetailsRow_Type IS itlabellogresultdetails%ROWTYPE;

   SUBTYPE LabelType_Type IS itlabellog.labeltype%TYPE;

   SUBTYPE LanguageId_Type IS itlang.lang_id%TYPE;

   SUBTYPE LastName_Type IS application_user.last_name%TYPE;

   SUBTYPE LeadTimeOffset_Type IS NUMBER( 3 );

   SUBTYPE Level_Type IS NUMBER( 1 );

   SUBTYPE LicenseVersion_Type IS VARCHAR2( 4 );

   SUBTYPE LimitedConfigurator_Type IS application_user.limited_configurator%TYPE;

   SUBTYPE Line_Type IS process_line.line%TYPE;

   SUBTYPE LinePropSequence_Type IS specification_line_prop.sequence_no%TYPE;

   SUBTYPE Location_Type IS LOCATION.description%TYPE;

   SUBTYPE LocationId_Type IS LOCATION.LOCATION%TYPE;

   SUBTYPE LocId_Type IS application_user.loc_id%TYPE;

   SUBTYPE Logical_Type IS BOOLEAN;

   SUBTYPE LogId_Type IS itclaimlog.log_id%TYPE;

   SUBTYPE LogType_Type IS itimplog.log_type%TYPE;

   --R18 Revert
   --SUBTYPE LongCharacter_Type IS VARCHAR2( 255 );

   SUBTYPE LongDescription_Type IS VARCHAR2( 120 );

   SUBTYPE MachineName_Type IS iterror.machine%TYPE;

   SUBTYPE Mandatory_Type IS VARCHAR2( 1 );

   SUBTYPE ManufacturerId_Type IS itprmfc.mfc_id%TYPE;

   SUBTYPE ManufacturerPlantNo_Type IS itmfcmpl.mpl_id%TYPE;

   SUBTYPE MapGroup_Type IS itimp_mapping.remap_group%TYPE;

   SUBTYPE MapItem_Type IS itimp_mapping.remap_item%TYPE;

   SUBTYPE MapName_Type IS itimp_mapping.remap_name%TYPE;

   SUBTYPE MapType_Type IS itimp_mapping.remap_type%TYPE;

   SUBTYPE MapValue_Type IS itimp_mapping.remap_value%TYPE;

   SUBTYPE MaterialClassId_Type IS NUMBER( 8 );

   SUBTYPE MESSAGE_TYPE IS itimplog.MESSAGE%TYPE;

   SUBTYPE MessageId_Type IS ITMESSAGE.msg_id%TYPE;

   SUBTYPE MessageText_Type IS ITMESSAGE.MESSAGE%TYPE;

   SUBTYPE Method_Type IS ITERROR.SOURCE%TYPE;

   SUBTYPE MetricId_Type IS itaddonrq.metric%TYPE;

   SUBTYPE MopProgress_Type IS itq.progress%TYPE;

   SUBTYPE MopStatus_Type IS itq.status%TYPE;

   SUBTYPE Name_Type IS VARCHAR2( 60 );

   SUBTYPE Node_Type IS itcld.node%TYPE;

   --R18 Revert
   --SUBTYPE Numeric_Type IS FLOAT;

   SUBTYPE NumVal_Type IS NUMBER;

   SUBTYPE NutExplosion_Type IS ITNUTEXPLOSION%ROWTYPE;

   SUBTYPE NutRefRowType_Type IS itnutreftype%ROWTYPE;

   SUBTYPE NutRefType_Type IS VARCHAR2( 255 );

   SUBTYPE NutResult_Type IS itnutresult%ROWTYPE;

   SUBTYPE NutResultDetail_Type IS itnutresultDetail%ROWTYPE;

   SUBTYPE Object_Type IS ft_base_rules.object_type%TYPE;

   SUBTYPE OperationalStep_Type IS NUMBER( 6 );

   SUBTYPE OptParam_Type IS VARCHAR2( 255 );

   SUBTYPE OverridePartVal_Type IS application_user.override_part_val%TYPE;

   SUBTYPE Owner_Type IS itdbprofile.owner%TYPE;

   SUBTYPE Parameter_Type IS VARCHAR2( 20 );

   SUBTYPE ParameterData_Type IS interspc_cfg.parameter_data%TYPE;

   SUBTYPE PartNo_Type IS part.part_no%TYPE;

   SUBTYPE PartSource_Type IS VARCHAR2( 3 );

   SUBTYPE PartType_Type IS class3.sort_desc%TYPE;

   SUBTYPE PartTypeGroup_Type IS itstgrp.group_descr%TYPE;

   SUBTYPE Password_Type IS VARCHAR( 30 );

   SUBTYPE Period_Type IS part_cost.period%TYPE;

   SUBTYPE PhaseAccess_Type IS application_user.phase_access%TYPE;

   SUBTYPE PhaseInStatus_Type IS status.phase_in_status%TYPE;

   SUBTYPE PhaseInTolerance_Type IS NUMBER( 2 );

   SUBTYPE PlanAccess_Type IS application_user.Plan_Access%TYPE;

   SUBTYPE Plant_Type IS plant.plant%TYPE;

   --R18 Revert
   --SUBTYPE PlantStatus_Type IS PART_PLANT.PLANNED_STATUS%TYPE;

   SUBTYPE PlantAccess_Type IS application_user.plant_access%TYPE;

   SUBTYPE PlantDescription_Type IS plant.description%TYPE;

   SUBTYPE PlantGroup_Type IS itplgrp.plantgroup%TYPE;

   SUBTYPE PlantNo_Type IS plant.plant%TYPE;

   SUBTYPE PlantSource_Type IS VARCHAR2( 3 );

   SUBTYPE PreferenceName_Type IS ituspref.pref%TYPE;

   SUBTYPE PreferenceSectionName_Type IS ituspref.section_name%TYPE;

   SUBTYPE PreferenceValue_Type IS ituspref.VALUE%TYPE;

   SUBTYPE Prefix_Type IS spec_prefix.prefix%TYPE;

   SUBTYPE PrefixType_Type IS SPEC_PREFIX_DESCR.prefix_type%TYPE;

   SUBTYPE Price_Type IS part_cost.price%TYPE;

   SUBTYPE PriceType_Type IS part_cost.price_type%TYPE;

   SUBTYPE PrintingAllowed_Type IS application_user.printing_allowed%TYPE;

   SUBTYPE ProdAccess_Type IS application_user.prod_access%TYPE;

   SUBTYPE ProductCode_Type IS itprmfc.product_code%TYPE;

   SUBTYPE PropertyBoolean_Type IS VARCHAR2( 1 );

   SUBTYPE PropertyLongString_Type IS VARCHAR2( 256 );

   SUBTYPE PropertySequenceNumber_Type IS specification_prop.sequence_no%TYPE;

   SUBTYPE PropertyShortString_Type IS VARCHAR2( 40 );

   SUBTYPE PropertyTmDetail_Type IS VARCHAR2( 1 );

   --TFS-8174
   SUBTYPE Quantity_Type IS NUMBER( 17, 7 );

   SUBTYPE ReconstitutionFactor_Type IS specification_ing.recfac%TYPE;

   SUBTYPE ReferenceText_Type IS application_user.reference_text%TYPE;

   SUBTYPE ReferenceTextTypeDescr_Type IS VARCHAR2( 70 );

   SUBTYPE ReferenceVersion_Type IS ittsResults.ref_ver%TYPE;

   SUBTYPE RelevencyToCosting_Type IS part_plant.RELEVENCY_TO_COSTING%TYPE;

   SUBTYPE ReportItemType_Type IS ITREPITEMTYPE.TYPE%TYPE;

   SUBTYPE ReqId_Type IS ITADDONRQ.req_id%TYPE;

   SUBTYPE Revision_Type IS NUMBER( 4 );

   SUBTYPE Scrap_Type IS NUMBER( 5, 2 );

   SUBTYPE Search_Type IS VARCHAR2( 1 );

   SUBTYPE SearchResultsRow_Type IS ittsResults%ROWTYPE;

   SUBTYPE Sequence_Type IS NUMBER( 13 );

   SUBTYPE SequenceNr_Type IS NUMBER( 8 );

   SUBTYPE ServingConvFactor_Type IS itnutpath.SERV_CONV_FACTOR%TYPE;

   SUBTYPE ServingVol_Type IS itnutpath.SERV_VOL%TYPE;

   SUBTYPE ShortDescription_Type IS REF_TEXT_TYPE.sort_desc%TYPE;

   SUBTYPE SingleVarChar_Type IS VARCHAR2( 1 );

   SUBTYPE Source_Type IS iterror.SOURCE%TYPE;

   SUBTYPE SpecGroup_Type IS itcld.spec_group%TYPE;

   SUBTYPE SpecificationPrefixType_Type IS VARCHAR2( 1 );

   SUBTYPE SpecificationSectionType_Type IS specification_section.TYPE%TYPE;

   SUBTYPE SpecTextText_Type IS specification_text.text%TYPE;

   SUBTYPE SpSectionSequenceNumber_Type IS specification_section.section_sequence_no%TYPE;

   SUBTYPE SqlString_Type IS VARCHAR2( 32767 );

   SUBTYPE StageId_Type IS stage.stage%TYPE;

   SUBTYPE StageSequence_Type IS process_line_stage.sequence_no%TYPE;

   SUBTYPE StatusId_Type IS status.status%TYPE;

   SUBTYPE StatusType_Type IS status.status_type%TYPE;

   --AP01235261 Start
   --orig Start
   ---- AP00959542
   ----AP00922768
   ----SUBTYPE String_Type IS VARCHAR2( 256 ); --orig
   ----SUBTYPE String_Type IS VARCHAR2( 1024 );
   ---- for this we use ErrorMessage_Type - ITJOBQ.ERROR_MSG
   --SUBTYPE String_Type IS VARCHAR2( 256 );
   --orig End
   SUBTYPE String_Type IS VARCHAR2( 1024 );
   --AP01235261 End

   SUBTYPE StringVal_Type IS VARCHAR2;

   SUBTYPE TCUid_Type IS VARCHAR2( 255 );

   SUBTYPE Telephone_Type IS application_user.telephone_no%TYPE;

   SUBTYPE TestMethodSetNo_Type IS specification_tm.tm_set_no%TYPE;

   SUBTYPE Text_Type IS itshq.text%TYPE;

   SUBTYPE TextType_Type IS process_line_stage.text_type%TYPE;

   SUBTYPE TradeName_Type IS itprmfc.trade_name%TYPE;

   SUBTYPE UnicodeBuffer_Type IS NVARCHAR2( 2000 );

   SUBTYPE UnicodeInfo_Type IS NVARCHAR2( 4000 );

   SUBTYPE UomGroupDescription_Type IS VARCHAR2( 30 );

   SUBTYPE UserDropped_Type IS application_user.user_dropped%TYPE;

   SUBTYPE UserGroupDesc_Type IS USER_GROUP.short_desc%TYPE;

   SUBTYPE UserGroupId_Type IS NUMBER( 8 );

   SUBTYPE UserId_Type IS application_user.user_id%TYPE;

   SUBTYPE UserProfile_Type IS application_user.user_profile%TYPE;

   SUBTYPE Value_Type IS ITADDONRQARG.arg_val%TYPE;

   SUBTYPE ValueType_Type IS specification_line_prop.value_type%TYPE;

   SUBTYPE ViewBom_Type IS application_user.view_bom%TYPE;

   SUBTYPE WebAllowed_Type IS application_user.Web_Allowed%TYPE;

   SUBTYPE What_Type IS ITUSHS.what%TYPE;

   SUBTYPE WhatId_Type IS ITUSHS.what_id%TYPE;

   SUBTYPE WorkFlowGroupId_Type IS NUMBER( 8 );

   SUBTYPE WorkFlowId_Type IS NUMBER( 8 );

   SUBTYPE XmlDomDocument_Type IS xmldom.domdocument;

   SUBTYPE XmlString_Type IS VARCHAR2( 4000 );

   SUBTYPE XmlType_Type IS XMLTYPE;

   -- start R-0004ba46-589-009 Frame_Icon

   SUBTYPE Icon_Type IS FRAME_ICON.ICON%TYPE;

   -- end R-0004ba46-589-009 Frame_Icon
   ---------------------------------------------------------------------------
   -- Record definitions
   ---------------------------------------------------------------------------
   TYPE ApplicationUserRec_Type IS RECORD(
      UserId                        iapiType.UserId_Type,
      ForeName                      iapiType.ForeName_Type,
      LastName                      iapiType.LastName_Type,
      Initials                      iapiType.Initials_Type,
      Telephone                     iapiType.Telephone_Type,
      EmailAddress                  iapiType.EmailAddress_Type,
      CurrentOnlyAccess             iapiType.Boolean_Type,
      InitialProfile                iapiType.InitialProfile_Type,
      UserProfile                   iapiType.UserProfile_Type,
      UserDropped                   iapiType.Boolean_Type,
      MrpProductionAccess           iapiType.Boolean_Type,
      MrpPlanningAccess             iapiType.Boolean_Type,
      MrpPhaseAccess                iapiType.Boolean_Type,
      PrintingAllowed               iapiType.Boolean_Type,
      InternationalAccess           iapiType.Boolean_Type,
      ObjectAndRefTextAccess        iapiType.Boolean_Type,
      ApprovedOnlyAccess            iapiType.Boolean_Type,
      LocationId                    iapiType.Id_Type,
      CategoryId                    iapiType.Id_Type,
      CreateLocalPartAllowed        iapiType.Boolean_Type,
      WebAllowed                    iapiType.Boolean_Type,
      LimitedConfigurator           iapiType.Boolean_Type,
      PlantAccess                   iapiType.Boolean_Type,
      ViewBomAllowed                iapiType.Boolean_Type,
      ViewPriceAllowed              iapiType.Boolean_Type,
      OptionalData                  iapiType.Boolean_Type,
      HistoricOnlyAccess            IapiType.Boolean_Type
   );

   TYPE AttExplosionRec_Type IS RECORD(
      MOPSEQUENCE                   iapiType.Sequence_Type,
      SEQUENCE                      iapiType.Sequence_Type,
      PARTNO                        iapiType.PartNo_Type,
      REVISION                      iapiType.Revision_Type,
      DESCRIPTION                   iapiType.Description_Type,
      PARENTPARTNO                  iapiType.PartNo_Type,
      PARENTREVISION                iapiType.Revision_Type,
      PLANTNO                       iapiType.Plant_Type,
      ALTERNATIVE                   iapiType.BomAlternative_Type,
      BOMUSAGEID                    iapiType.BomUsage_Type
   );

   TYPE AttributeRec_Type IS RECORD(
      ATTRIBUTEID                   iapiType.Id_Type,
      INTERNATIONAL                 iapiType.Boolean_Type,
      DESCRIPTION                   iapiType.Description_Type
   );

   TYPE BomExplosionListRec_Type IS RECORD(
      MOPSEQUENCE                   iapiType.Id_Type,
      SEQUENCE                      iapiType.Id_Type,
      BOMLEVEL                      iapiType.BomLevel_Type,
      PARTNO                        iapiType.PartNo_Type,
      REVISION                      iapiType.Revision_Type,
      DESCRIPTION                   iapiType.Description_Type,
      PLANTNO                       iapiType.PlantNo_Type,
      UOM                           iapiType.BaseUom_Type,
      QUANTITY                      iapiType.BomQuantity_Type,
      SCRAP                         iapiType.Scrap_Type,
      CALCULATEDQUANTITY            iapiType.BomQuantity_Type,
      CALCULATEDQUANTITYWITHSCRAP   iapiType.BomQuantity_Type,
      COST                          iapiType.Float_Type,
      COSTWITHSCRAP                 iapiType.Float_Type,
      CALCULATEDCOST                iapiType.Float_Type,
      CALCULATEDCOSTWITHSCRAP       iapiType.Float_Type,
      PARTSOURCE                    iapiType.PartSource_Type,
      TOUNIT                        iapiType.BaseUom_Type,
      CONVERSIONFACTOR              iapiType.BomConvFactor_Type,
      PHANTOM                       iapiType.Boolean_Type,
      INGREDIENT                    iapiType.Boolean_Type,
      ALTERNATIVEPRICE              iapiType.Boolean_Type,
      PARTTYPEID                    iapiType.Id_Type,
      PARTTYPE                      iapiType.Description_Type,
      ALTERNATIVE                   iapiType.BomAlternative_Type,
      BOMUSAGEID                    iapiType.BomUsageId_Type,
      ASSEMBLYSCRAP                 iapiType.Scrap_Type,
      COMPONENTSCRAP                iapiType.Scrap_Type,
      LEADTIMEOFFSET                iapiType.BomLeadTimeOffset_Type,
      ITEMCATEGORY                  iapiType.BomItemCategory_Type,
      ISSUELOCATION                 iapiType.BomIssueLocation_Type,
      BOMTYPE                       iapiType.BomItemType_Type,
      OPERATIONALSTEP               iapiType.BomOperationalStep_Type,
      MINIMUMQUANTITY               iapiType.BomQuantity_Type,
      MAXIMUMQUANTITY               iapiType.BomQuantity_Type,
      CODE                          iapiType.BomItemCode_Type,
      BOMALTGROUP                   iapiType.BomItemAltGroup_Type,
      BOMALTPRIORITY                iapiType.BomItemAltPriority_Type,
      STRING1                       iapiType.BomItemLongCharacter_Type,
      STRING2                       iapiType.BomItemLongCharacter_Type,
      STRING3                       iapiType.BomItemCharacter_Type,
      STRING4                       iapiType.BomItemCharacter_Type,
      STRING5                       iapiType.BomItemCharacter_Type,
      NUMERIC1                      iapiType.BomItemNumeric_Type,
      NUMERIC2                      iapiType.BomItemNumeric_Type,
      NUMERIC3                      iapiType.BomItemNumeric_Type,
      NUMERIC4                      iapiType.BomItemNumeric_Type,
      NUMERIC5                      iapiType.BomItemNumeric_Type,
      BOOLEAN1                      iapiType.boolean_type,
      BOOLEAN2                      iapiType.boolean_type,
      BOOLEAN3                      iapiType.boolean_type,
      BOOLEAN4                      iapiType.boolean_type,
      DATE1                         iapiType.Date_Type,
      DATE2                         iapiType.Date_Type,
      CHARACTERISTICDESCRIPTION1    iapiType.Description_Type,
      CHARACTERISTICDESCRIPTION2    iapiType.Description_Type,
      CHARACTERISTICDESCRIPTION3    iapiType.Description_Type,
      RELEVANCYTOCOSTING            iapiType.Boolean_Type,
      BULKMATERIAL                  iapiType.Boolean_Type,
      RECURSIVESTOP                 iapiType.Boolean_Type,
      ACCESSSTOP                    iapiType.Boolean_Type
   );

   --AP00793731 Start
   TYPE BomExplosionListRecExt_Type IS RECORD(
      MOPSEQUENCE                   iapiType.Id_Type,
      SEQUENCE                      iapiType.Id_Type,
      BOMLEVEL                      iapiType.BomLevel_Type,
      PARTNO                        iapiType.PartNo_Type,
      REVISION                      iapiType.Revision_Type,
      DESCRIPTION                   iapiType.Description_Type,
      PLANTNO                       iapiType.PlantNo_Type,
      UOM                           iapiType.BaseUom_Type,
      QUANTITY                      iapiType.BomQuantity_Type,
      SCRAP                         iapiType.Scrap_Type,
      CALCULATEDQUANTITY            iapiType.BomQuantity_Type,
      CALCULATEDQUANTITYWITHSCRAP   iapiType.BomQuantity_Type,
      COST                          iapiType.Float_Type,
      COSTWITHSCRAP                 iapiType.Float_Type,
      CALCULATEDCOST                iapiType.Float_Type,
      CALCULATEDCOSTWITHSCRAP       iapiType.Float_Type,
      PARTSOURCE                    iapiType.PartSource_Type,
      TOUNIT                        iapiType.BaseUom_Type,
      CONVERSIONFACTOR              iapiType.BomConvFactor_Type,
      PHANTOM                       iapiType.Boolean_Type,
      INGREDIENT                    iapiType.Boolean_Type,
      ALTERNATIVEPRICE              iapiType.Boolean_Type,
      PARTTYPEID                    iapiType.Id_Type,
      PARTTYPE                      iapiType.Description_Type,
      ALTERNATIVE                   iapiType.BomAlternative_Type,
      BOMUSAGEID                    iapiType.BomUsageId_Type,
      ASSEMBLYSCRAP                 iapiType.Scrap_Type,
      COMPONENTSCRAP                iapiType.Scrap_Type,
      LEADTIMEOFFSET                iapiType.BomLeadTimeOffset_Type,
      ITEMCATEGORY                  iapiType.BomItemCategory_Type,
      ISSUELOCATION                 iapiType.BomIssueLocation_Type,
      BOMTYPE                       iapiType.BomItemType_Type,
      OPERATIONALSTEP               iapiType.BomOperationalStep_Type,
      MINIMUMQUANTITY               iapiType.BomQuantity_Type,
      MAXIMUMQUANTITY               iapiType.BomQuantity_Type,
      CODE                          iapiType.BomItemCode_Type,
      BOMALTGROUP                   iapiType.BomItemAltGroup_Type,
      BOMALTPRIORITY                iapiType.BomItemAltPriority_Type,
      STRING1                       iapiType.BomItemLongCharacter_Type,
      STRING2                       iapiType.BomItemLongCharacter_Type,
      STRING3                       iapiType.BomItemCharacter_Type,
      STRING4                       iapiType.BomItemCharacter_Type,
      STRING5                       iapiType.BomItemCharacter_Type,
      NUMERIC1                      iapiType.BomItemNumeric_Type,
      NUMERIC2                      iapiType.BomItemNumeric_Type,
      NUMERIC3                      iapiType.BomItemNumeric_Type,
      NUMERIC4                      iapiType.BomItemNumeric_Type,
      NUMERIC5                      iapiType.BomItemNumeric_Type,
      BOOLEAN1                      iapiType.boolean_type,
      BOOLEAN2                      iapiType.boolean_type,
      BOOLEAN3                      iapiType.boolean_type,
      BOOLEAN4                      iapiType.boolean_type,
      DATE1                         iapiType.Date_Type,
      DATE2                         iapiType.Date_Type,
      CHARACTERISTICDESCRIPTION1    iapiType.Description_Type,
      CHARACTERISTICDESCRIPTION2    iapiType.Description_Type,
      CHARACTERISTICDESCRIPTION3    iapiType.Description_Type,
      RELEVANCYTOCOSTING            iapiType.Boolean_Type,
      BULKMATERIAL                  iapiType.Boolean_Type,
      RECURSIVESTOP                 iapiType.Boolean_Type,
      --AP00793731 Start
      --ACCESSSTOP                    iapiType.Boolean_Type --orig
      ACCESSSTOP                    iapiType.Boolean_Type,
      HASTOBEPRESENT                iapiType.Boolean_Type
      --AP00793731 End
   );
--

   TYPE BomExplosionRec_Type IS RECORD(
-- ISQF248 start - include BOM explosion SequenceNo
      BomExplosionNo                iapiType.Sequence_Type, -- haju
-- ISQF248 end
      PartNo                        iapiType.PartNo_Type,
      Revision                      iapiType.Revision_Type,
      Plant                         iapiType.Plant_Type,
      Alternative                   iapiType.BomAlternative_Type,
      BomUsage                      iapiType.BomUsage_Type,
      MultiLevel                    iapiType.Boolean_Type,
      ExplosionDate                 iapiType.Date_Type,
      Quantity                      iapiType.BomQuantity_Type,
      IncludeInDevelopment          iapiType.Boolean_Type,
      UseMop                        iapiType.Boolean_Type,
      UseBomPath                    iapiType.Boolean_Type,
      ExplosionType                 iapiType.Id_Type,
      PriceType                     iapiType.PriceType_Type,
      Period                        iapiType.Period_Type,
      AlternativePriceType          iapiType.PriceType_Type,
      AlternativePeriode            iapiType.Period_Type
   );

   TYPE BomHeaderCompareRec_Type IS RECORD(
      CompareStatus                 iapiType.Id_Type,
      PartNo                        iapiType.PartNo_Type,
      Revision                      iapiType.Revision_Type,
      Plant                         iapiType.Plant_Type,
      Alternative                   iapiType.BomAlternative_Type,
      BomUsage                      iapiType.BomUsage_Type,
      Description                   iapiType.Description_Type,
      Quantity                      iapiType.BomQuantity_Type,
      Uom                           iapiType.Description_Type,
      ConversionFactor              iapiType.BomConvFactor_Type,
      ConvertedUom                  iapiType.Description_Type,
      Yield                         iapiType.BomYield_Type,
      TYPE                          iapiType.BomHeaderType_Type,
      MinimumQuantity               iapiType.BomQuantity_Type,
      MaximumQuantity               iapiType.BomQuantity_Type,
      FixedQuantity                 iapiType.Boolean_Type
   );

   TYPE BomHeaderRec_Type IS RECORD(
      PartNo                        iapiType.PartNo_Type,
      Revision                      iapiType.Revision_Type,
      SpecificationDescription      iapiType.Description_Type,
      Plant                         iapiType.Plant_Type,
      Alternative                   iapiType.BomAlternative_Type,
      BomUsage                      iapiType.BomUsage_Type,
      Description                   iapiType.Description_Type,
      PlantDescription              iapiType.Description_Type,
      UsageDescription              iapiType.Description_Type,
      Quantity                      iapiType.BomQuantity_Type,
      Uom                           iapiType.Description_Type,
      ConversionFactor              iapiType.BomConvFactor_Type,
      ConvertedUom                  iapiType.Description_Type,
      ConvertedQuantity             iapiType.BomQuantity_Type,
      MinimumQuantity               iapiType.BomQuantity_Type,
      MaximumQuantity               iapiType.BomQuantity_Type,
      Yield                         iapiType.BomYield_Type,
      CalculationMode               iapiType.BomItemCalcFlag_Type,
      BomItemType                   iapiType.BomItemType_Type,
      PlannedEffectiveDate          iapiType.Date_Type,
      Preferred                     iapiType.Boolean_Type,
      HasItems                      iapiType.Boolean_Type
   );

   TYPE BomImplosionListRec_Type IS RECORD(
      BOMLEVEL                      iapiType.BomLevel_Type,
      PARTNO                        iapiType.PartNo_Type,
      PARENTPARTNO                  iapiType.PartNo_Type,
      PARENTREVISION                iapiType.Revision_Type,
      DESCRIPTION                   iapiType.Description_Type,
      PLANTNO                       iapiType.PlantNo_Type,
      ALTERNATIVE                   iapiType.BomAlternative_Type,
      BOMUSAGEID                    iapiType.BomUsageId_Type,
      BOMUSAGEDESCRIPTION           iapiType.Description_Type,
      SPECIFICATIONTYPE             iapiType.Id_Type,
      TOPLEVEL                      iapiType.BomLevel_Type,
      RECURSIVESTOP                 iapiType.Boolean_Type,
      ACCESSSTOP                    iapiType.Boolean_Type,
      ALTERNATIVEGROUP              iapiType.BomItemAltGroup_Type,
      ALTERNATIVEPRIORITY           iapiType.BomItemAltPriority_Type
   );

   TYPE BomItemRec_Type IS RECORD(
      PartNo                        iapiType.PartNo_Type,
      Revision                      iapiType.Revision_Type,
      Plant                         iapiType.Plant_Type,
      Alternative                   iapiType.BomAlternative_Type,
      BomUsage                      iapiType.BomUsage_Type,
      ItemNumber                    iapiType.BomItemNumber_Type,
      AlternativeGroup              iapiType.BomItemAltGroup_Type,
      AlternativePriority           iapiType.BomItemAltPriority_Type,
      ComponentPartNo               iapiType.PartNo_Type,
      ComponentRevision             iapiType.Revision_Type,
      ComponentDescription          iapiType.Description_Type,
      ComponentPlant                iapiType.Plant_Type,
      --IS881 --AP01280332 --oneLine
      --OldComponentPartNo            iapiType.PartNo_Type,
      PartSource                    iapiType.PartSource_Type,
      PartTypeGroup                 iapiType.PartTypeGroup_Type,
      Quantity                      iapiType.BomQuantity_Type,
      Uom                           iapiType.Description_Type,
      ConversionFactor              iapiType.BomConvFactor_Type,
      ConvertedUom                  iapiType.Description_Type,
      Yield                         iapiType.BomYield_Type,
      AssemblyScrap                 iapiType.Scrap_Type,
      ComponentScrap                iapiType.Scrap_Type,
      LeadTimeOffset                iapiType.BomLeadTimeOffset_Type,
      RelevancyToCosting            iapiType.Boolean_Type,
      BulkMaterial                  iapiType.Boolean_Type,
      ItemCategory                  iapiType.BomItemCategory_Type,
      ItemCategoryDescr             iapiType.Description_Type,
      IssueLocation                 iapiType.BomIssueLocation_Type,
      CalculationMode               iapiType.BomItemCalcFlag_Type,
      BomItemType                   iapiType.BomItemType_Type,
      OperationalStep               iapiType.BomOperationalStep_Type,
      MinimumQuantity               iapiType.BomQuantity_Type,
      MaximumQuantity               iapiType.BomQuantity_Type,
      FixedQuantity                 iapiType.Boolean_Type,
      Code                          iapiType.BomItemCode_Type,
      Text1                         iapiType.BomItemLongCharacter_Type,
      Text2                         iapiType.BomItemLongCharacter_Type,
      Text3                         iapiType.BomItemCharacter_Type,
      Text4                         iapiType.BomItemCharacter_Type,
      Text5                         iapiType.BomItemCharacter_Type,
      Numeric1                      iapiType.BomItemNumeric_Type,
      Numeric2                      iapiType.BomItemNumeric_Type,
      Numeric3                      iapiType.BomItemNumeric_Type,
      Numeric4                      iapiType.BomItemNumeric_Type,
      Numeric5                      iapiType.BomItemNumeric_Type,
      Boolean1                      iapiType.boolean_type,
      Boolean2                      iapiType.boolean_type,
      Boolean3                      iapiType.boolean_type,
      Boolean4                      iapiType.boolean_type,
      Date1                         iapiType.Date_Type,
      Date2                         iapiType.Date_Type,
      Characteristic1               iapiType.id_type,
      Characteristic1Revision       iapiType.Revision_type,
      Characteristic2               iapiType.id_type,
      Characteristic2Revision       iapiType.Revision_type,
      Characteristic3               iapiType.id_type,
      Characteristic3Revision       iapiType.Revision_type,
      Characteristic1Description    iapiType.Description_Type,
      Characteristic2Description    iapiType.Description_Type,
      Characteristic3Description    iapiType.Description_Type,
      MakeUp                        iapiType.Boolean_Type,
      InternationalEquivalent       iapiType.PartNo_Type,
      ViewBomAccess                 iapiType.Boolean_Type,
      --IS160 Start
      --ComponentScrapSync            iapiType.Boolean_Type
      ComponentScrapSync            iapiType.Boolean_Type,
      Owner                         iapiType.Owner_Type
      --IS160 End
   );

   TYPE BomJournalRec_Type IS RECORD(
      PARTNO                        iapiType.PartNo_Type,
      REVISION                      iapiType.Revision_Type,
      PLANTNO                       iapiType.Plant_Type,
      ALTERNATIVE                   iapiType.BomAlternative_Type,
      BOMUSAGEID                    iapiType.BomUsage_Type,
      BOMUSAGEDESCRIPTION           iapiType.Description_Type,
      ITEMNUMBER                    iapiType.BomItemNumber_Type,
      OLDVALUE                      iapiType.String_Type,
      NEWVALUE                      iapiType.String_Type,
      HEADERID                      iapiType.Id_type,
      DESCRIPTION                   iapiType.Description_Type,
      FIELDID                       iapiType.Id_type,
      FORENAME                      iapiType.ForeName_Type,
      LASTNAME                      iapiType.LastName_Type,
      USERID                        iapiType.UserId_Type,
      TIMESTAMP                     iapiType.Date_Type
   );

   TYPE BomMRPItemRec_Type IS RECORD(
      PARTNO                        iapiType.PartNo_Type,
      REVISION                      iapiType.Revision_Type,
      DESCRIPTION                   iapiType.Description_Type,
      PARTSOURCE                    iapiType.PartSource_Type,
      PLANTNO                       iapiType.PlantNo_Type,
      ALTERNATIVE                   iapiType.BomAlternative_Type,
      BOMUSAGEID                    iapiType.BomUsage_Type,
      STATUSDESCRIPTION             iapiType.Description_Type,
      ITEMNUMBER                    iapiType.BomItemNumber_Type,
      BOMALTGROUP                   iapiType.BomItemAltGroup_Type,
      BOMALTPRIORITY                iapiType.BomItemAltPriority_Type,
      COMPONENTPARTNO               iapiType.PartNo_Type,
      COMPONENTREVISION             iapiType.Revision_Type,
      COMPONENTPLANT                iapiType.Plant_Type,
      QUANTITY                      iapiType.BomQuantity_Type,
      UOM                           iapiType.Description_Type,
      CONVERSIONFACTOR              iapiType.BomConvFactor_Type,
      TOUNIT                        iapiType.Description_Type,
      YIELD                         iapiType.BomYield_Type,
      ASSEMBLYSCRAP                 iapiType.Scrap_Type,
      COMPONENTSCRAP                iapiType.Scrap_Type,
      LEADTIMEOFFSET                iapiType.BomLeadTimeOffset_Type,
      RELEVANCYTOCOSTING            iapiType.Boolean_Type,
      BULKMATERIAL                  iapiType.Boolean_Type,
      ITEMCATEGORY                  iapiType.BomItemCategory_Type,
      ITEMCATEGORYDESCR             iapiType.Description_Type,
      ISSUELOCATION                 iapiType.BomIssueLocation_Type,
      CALCULATIONMODE               iapiType.BomItemCalcFlag_Type,
      BOMTYPE                       iapiType.BomItemType_Type,
      OPERATIONALSTEP               iapiType.BomOperationalStep_Type,
      MINIMUMQUANTITY               iapiType.BomQuantity_Type,
      MAXIMUMQUANTITY               iapiType.BomQuantity_Type,
      FIXEDQUANTITY                 iapiType.Boolean_Type,
      CODE                          iapiType.BomItemCode_Type,
      STRING1                       iapiType.BomItemLongCharacter_Type,
      STRING2                       iapiType.BomItemLongCharacter_Type,
      STRING3                       iapiType.BomItemCharacter_Type,
      STRING4                       iapiType.BomItemCharacter_Type,
      STRING5                       iapiType.BomItemCharacter_Type,
      NUMERIC1                      iapiType.BomItemNumeric_Type,
      NUMERIC2                      iapiType.BomItemNumeric_Type,
      NUMERIC3                      iapiType.BomItemNumeric_Type,
      NUMERIC4                      iapiType.BomItemNumeric_Type,
      NUMERIC5                      iapiType.BomItemNumeric_Type,
      BOOLEAN1                      iapiType.boolean_type,
      BOOLEAN2                      iapiType.boolean_type,
      BOOLEAN3                      iapiType.boolean_type,
      BOOLEAN4                      iapiType.boolean_type,
      DATE1                         iapiType.Date_Type,
      DATE2                         iapiType.Date_Type,
      CHARACTERISTICID1             iapiType.id_type,
      CHARACTERISTICID2             iapiType.id_type,
      CHARACTERISTICID3             iapiType.id_type,
      CHARACTERISTICDESCRIPTION1    iapiType.Description_Type,
      CHARACTERISTICDESCRIPTION2    iapiType.Description_Type,
      CHARACTERISTICDESCRIPTION3    iapiType.Description_Type,
      MAKEUP                        iapiType.Boolean_Type,
      INTERNATIONALEQUIVALENT       iapiType.PartNo_Type,
      COMPONENTSCRAPSYNC            iapiType.Boolean_Type,
      OWNER                         iapiType.Owner_Type
   );

   TYPE BomPathHeaderListRec_Type IS RECORD(
      PARTNO                        iapiType.PartNo_Type,
      REVISION                      iapiType.Revision_Type,
      SPECIFICATIONDESCRIPTION      iapiType.Description_Type,
      PLANTNO                       iapiType.Plant_Type,
      ALTERNATIVE                   iapiType.BomAlternative_Type,
      BOMUSAGEID                    iapiType.BomUsage_Type,
      DESCRIPTION                   iapiType.Description_Type,
      PLANTDESCRIPTION              iapiType.Description_Type,
      BOMUSAGEDESCRIPTION           iapiType.Description_Type,
      PREFERRED                     iapiType.Boolean_Type
   );

   TYPE BomPathListRec_Type IS RECORD(
      SEQUENCE                      iapiType.Sequence_Type,
      PARENTPARTNO                  iapiType.PartNo_Type,
      PARENTREVISION                iapiType.Revision_Type,
      DESCRIPTION                   iapiType.Description_Type,
      PARTNO                        iapiType.PartNo_Type,
      REVISION                      iapiType.Revision_Type,
      PLANTNO                       iapiType.Plant_Type,
      ALTERNATIVE                   iapiType.BomAlternative_Type,
      BOMUSAGEID                    iapiType.BomUsage_Type,
      BOMALTGROUP                   iapiType.BomItemAltGroup_Type,
      BOMALTPRIORITY                iapiType.BomItemAltPriority_Type,
      BOMLEVEL                      iapiType.BomLevel_Type
   );

   TYPE BomPathRec_Type IS RECORD(
      PARTNO                        iapiType.PartNo_Type,
      REVISION                      iapiType.Revision_Type,
      COMPONENTPARTNO               iapiType.PartNo_Type,
      COMPONENTREVISION             iapiType.Revision_Type,
      COMPONENTDESCRIPTION          iapiType.Description_Type,
      PLANTNO                       iapiType.Plant_Type,
      ALTERNATIVE                   iapiType.BomAlternative_Type,
      BOMUSAGEID                    iapiType.BomUsage_Type,
      BOMUSAGEDESCRIPTION           iapiType.Description_Type,
      DESCRIPTION                   iapiType.Description_Type,
      PREFERRED                     iapiType.Boolean_Type,
      BOMALTGROUP                   iapiType.BomItemAltGroup_Type,
      BOMALTPRIORITY                iapiType.BomItemAltPriority_Type
   );

   TYPE CheckDeletedPartPlantRec_Type IS RECORD(
      PARTNO                        iapiType.PartNo_Type,
      REVISION                      iapiType.Revision_Type,
      STATUS                        iapiType.StatusId_Type,
      SPECIFICATIONDESCRIPTION      iapiType.Description_Type,
      PLANTNO                       iapiType.Plant_Type
   );

   TYPE CheckDeletedPartRec_Type IS RECORD(
      PARTNO                        iapiType.PartNo_Type,
      REVISION                      iapiType.Revision_Type,
      STATUS                        iapiType.StatusId_Type,
      SPECIFICATIONDESCRIPTION      iapiType.Description_Type
   );

   TYPE CheckOrphanedRec_Type IS RECORD(
      PARTNO                        iapiType.PartNo_Type,
      REVISION                      iapiType.Revision_Type,
      SPECIFICATIONDESCRIPTION      iapiType.Description_Type
   );

   TYPE ClaimsExplosionRec_Type IS RECORD(
      UNIQUEID                      iapiType.Sequence_Type,
      MOPSEQUENCE                   iapiType.Sequence_Type,
      SEQUENCE                      iapiType.Sequence_Type,
      CLAIMSSEQUENCE                iapiType.Sequence_Type,
      PARTNO                        iapiType.PartNo_Type,
      REVISION                      iapiType.Revision_Type,
      DESCRIPTION                   iapiType.Description_Type,
      PROPERTYGROUP                 iapiType.Id_Type,
      PROPERTY                      iapiType.Id_Type,
      PROPERTYREVISION              iapiType.Revision_Type,
      ATTRIBUTE                     iapiType.Id_Type,
      ATTRIBUTEREVISION             iapiType.Revision_Type,
      BOOLEAN1                      iapiType.Boolean_Type
   );

   TYPE ClaimsLogRec_Type IS RECORD(
      LOGID                         iapiType.LogId_Type,
      LOGNAME                       iapiType.Description_Type,
      STATUSID                      iapiType.StatusId_Type,
      STATUS                        iapiType.Description_Type,
      PARTNO                        iapiType.PartNo_Type,
      REVISION                      iapiType.Revision_Type,
      SPECIFICATIONDESCRIPTION      iapiType.Description_Type,
      PLANT                         iapiType.Plant_Type,
      ALTERNATIVE                   iapiType.BomAlternative_Type,
      BOMUSAGEID                    iapiType.BomUsageId_Type,
      BOMUSAGEDESCRIPTION           iapiType.Description_Type,
      EXPLOSIONDATE                 iapiType.Date_Type,
      CREATEDBY                     iapiType.UserId_Type,
      CREATEDON                     iapiType.Date_Type,
      REPORTTYPE                    iapiType.Id_Type,
      DESCRIPTION                   iapiType.Description_Type,
      LOGGINGXML                    iapiType.Clob_Type
   );

   TYPE ClaimsLogResultRec_Type IS RECORD(
      LOGID                         iapiType.LogId_Type,
      PROPERTYGROUPID               iapiType.Id_Type,
      PROPERTYGROUPREVISION         iapiType.Revision_Type,
      PROPERTYGROUP                 iapiType.Description_Type,
      PROPERTYID                    iapiType.Id_Type,
      PROPERTYREVISION              iapiType.Revision_Type,
      PROPERTY                      iapiType.Description_Type,
      PROPERTYGROUPTYPE             iapiType.Boolean_Type,
      VALUE                         iapiType.Boolean_Type
   );

   TYPE ClaimsRepTypeRec_Type IS RECORD(
      DESCRIPTION                   iapiType.Description_Type,
      PROPERTYGROUP                 iapiType.Id_Type,
      PROPERTYGROUPTYPE             NUMBER( 1 )
   );

   TYPE ClaimsResultDetailRec_Type IS RECORD(
      PARTNO                        iapiType.PartNo_Type,
      REVISION                      iapiType.Revision_Type,
      SPECIFICATIONDESCRIPTION      iapiType.Description_Type,
      CALCULATEDQUANTITY            iapiType.BomQuantity_Type,
      UOM                           iapiType.BaseUom_Type,
      PROPERTYGROUPID               iapiType.Id_Type,
      PROPERTYGROUPREVISION         iapiType.Revision_Type,
      PROPERTYGROUP                 iapiType.Description_Type,
      PROPERTY                      iapiType.Description_Type,
      PROPERTYID                    iapiType.Id_Type,
      PROPERTYREVISION              iapiType.Revision_Type,
      BOOLEAN1                      iapiType.Boolean_Type,
      INFO1                         iapiType.String_Type,
      INFO2                         iapiType.String_Type,
      CLAIMRESULT                   iapiType.Boolean_Type,
      PROPERTYGROUPTYPE             iapiType.ClaimsResultType_Type
   );

   TYPE ClaimsResultRec_Type IS RECORD(
      PROPERTYGROUPID               iapiType.Id_Type,
      PROPERTYGROUP                 iapiType.Description_Type,
      PROPERTY                      iapiType.Description_Type,
      PROPERTYID                    iapiType.Id_Type,
      CLAIMRESULT                   iapiType.Boolean_Type
   );

   TYPE CompBomHeaderRec_Type IS RECORD(
      BOMHEADERCMPSTATUS            iapiType.Boolean_Type,
      PARTNO                        iapiType.PartNo_Type,
      REVISION                      iapiType.Revision_Type,
      PLANTNO                       iapiType.Plant_Type,
      ALTERNATIVE                   iapiType.BomAlternative_Type,
      BOMUSAGEID                    iapiType.BomUsage_Type,
      BOMUSAGEDESCRIPTION           iapiType.Description_Type,
      UOMCMPSTATUS                  iapiType.Boolean_Type,
      UOM                           iapiType.BaseUom_Type,
      BASEQUANTITYCMPSTATUS         iapiType.Boolean_Type,
      BASEQUANTITY                  iapiType.BomQuantity_Type,
      DESCRIPTIONCMPSTATUS          iapiType.Boolean_Type,
      DESCRIPTION                   iapiType.Description_Type,
      YIELDCMPSTATUS                iapiType.Boolean_Type,
      YIELD                         iapiType.BomYield_Type,
      CONVERSIONFACTORCMPSTATUS     iapiType.Boolean_Type,
      CONVERSIONFACTOR              iapiType.BomConvFactor_Type,
      TOUNITCMPSTATUS               iapiType.Boolean_Type,
      TOUNIT                        iapiType.BaseUom_Type,
      CALCULATIONMODECMPSTATUS      iapiType.Boolean_Type,
      CALCULATIONMODE               iapiType.BomItemCalcFlag_Type,
      BOMTYPECMPSTATUS              iapiType.Boolean_Type,
      BOMTYPE                       iapiType.BomItemType_Type,
      MINIMUMQUANTITYCMPSTATUS      iapiType.Boolean_Type,
      MINIMUMQUANTITY               iapiType.BomQuantity_Type,
      MAXIMUMQUANTITYCMPSTATUS      iapiType.Boolean_Type,
      MAXIMUMQUANTITY               iapiType.BomQuantity_Type,
      PLANTEFFECTIVEDATECMPSTATUS   iapiType.Boolean_Type,
      PLANTEFFECTIVEDATE            iapiType.Date_Type
   );

   TYPE CompBomItemsRec_Type IS RECORD(
      BOMITEMCMPSTATUS              iapiType.Boolean_Type,
      PARTNO                        iapiType.PartNo_Type,
      REVISION                      iapiType.Revision_Type,
      PLANTNO                       iapiType.Plant_Type,
      ALTERNATIVE                   iapiType.BomAlternative_Type,
      BOMUSAGEID                    iapiType.BomUsage_Type,
      ITEMNUMBER                    iapiType.BomItemNumber_Type,
      COMPONENTPARTNO               iapiType.PartNo_Type,
      COMPONENTREVISIONCMPSTATUS    iapiType.Boolean_Type,
      COMPONENTREVISION             iapiType.Revision_Type,
      COMPONENTDESCRIPTION          iapiType.Description_Type,
      COMPONENTPLANTCMPSTATUS       iapiType.Boolean_Type,
      COMPONENTPLANT                iapiType.Plant_Type,
      QUANTITYCMPSTATUS             iapiType.Boolean_Type,
      QUANTITY                      iapiType.BomQuantity_Type,
      UOMCMPSTATUS                  iapiType.Boolean_Type,
      UOM                           iapiType.BaseUom_Type,
      CONVERSIONFACTORCMPSTATUS     iapiType.Boolean_Type,
      CONVERSIONFACTOR              iapiType.BomQuantity_Type,
      TOUNITCMPSTATUS               iapiType.Boolean_Type,
      TOUNIT                        iapiType.BomQuantity_Type,
      YIELDCMPSTATUS                iapiType.Boolean_Type,
      YIELD                         iapiType.BomYield_Type,
      ASSEMBLYSCRAPCMPSTATUS        iapiType.Boolean_Type,
      ASSEMBLYSCRAP                 iapiType.Scrap_Type,
      COMPONENTSCRAPCMPSTATUS       iapiType.Boolean_Type,
      COMPONENTSCRAP                iapiType.Scrap_Type,
      LEADTIMEOFFSETCMPSTATUS       iapiType.Boolean_Type,
      LEADTIMEOFFSET                iapiType.BomLeadTimeOffset_Type,
      ITEMCATEGORYCMPSTATUS         iapiType.Boolean_Type,
      ITEMCATEGORY                  iapiType.BomItemCategory_Type,
      ISSUELOCATIONCMPSTATUS        iapiType.Boolean_Type,
      ISSUELOCATION                 iapiType.IssueLocation_Type,
      CALCULATIONMODECMPSTATUS      iapiType.Boolean_Type,
      CALCULATIONMODE               iapiType.BomItemCalcFlag_Type,
      BOMITEMTYPECMPSTATUS          iapiType.Boolean_Type,
      BOMITEMTYPE                   iapiType.BomItemType_Type,
      OPERATIONALSTEPCMPSTATUS      iapiType.Boolean_Type,
      OPERATIONALSTEP               iapiType.BomOperationalStep_Type,
      MINIMUMQUANTITYCMPSTATUS      iapiType.Boolean_Type,
      MINIMUMQUANTITY               iapiType.BomQuantity_Type,
      MAXIMUMQUANTITYCMPSTATUS      iapiType.Boolean_Type,
      MAXIMUMQUANTITY               iapiType.BomQuantity_Type,
      CODECMPSTATUS                 iapiType.Boolean_Type,
      CODE                          iapiType.BomItemCode_Type,
      ALTERNATIVEGROUPCMPSTATUS     iapiType.Boolean_Type,
      ALTERNATIVEGROUP              iapiType.BomItemAltGroup_Type,
      ALTERNATIVEPRIORITYCMPSTATUS  iapiType.Boolean_Type,
      ALTERNATIVEPRIORITY           iapiType.BomItemAltPriority_Type,
      NUMERIC1CMPSTATUS             iapiType.Boolean_Type,
      NUMERIC1                      iapiType.BomItemNumeric_Type,
      NUMERIC2CMPSTATUS             iapiType.Boolean_Type,
      NUMERIC2                      iapiType.BomItemNumeric_Type,
      NUMERIC3CMPSTATUS             iapiType.Boolean_Type,
      NUMERIC3                      iapiType.BomItemNumeric_Type,
      NUMERIC4CMPSTATUS             iapiType.Boolean_Type,
      NUMERIC4                      iapiType.BomItemNumeric_Type,
      NUMERIC5CMPSTATUS             iapiType.Boolean_Type,
      NUMERIC5                      iapiType.BomItemNumeric_Type,
      STRING1CMPSTATUS              iapiType.Boolean_Type,
      STRING1                       iapiType.BomItemLongCharacter_Type,
      STRING2CMPSTATUS              iapiType.Boolean_Type,
      STRING2                       iapiType.BomItemLongCharacter_Type,
      STRING3CMPSTATUS              iapiType.Boolean_Type,
      STRING3                       iapiType.BomItemCharacter_Type,
      STRING4CMPSTATUS              iapiType.Boolean_Type,
      STRING4                       iapiType.BomItemCharacter_Type,
      STRING5CMPSTATUS              iapiType.Boolean_Type,
      STRING5                       iapiType.BomItemCharacter_Type,
      DATE1CMPSTATUS                iapiType.Boolean_Type,
      DATE1                         iapiType.Date_Type,
      DATE2CMPSTATUS                iapiType.Boolean_Type,
      DATE2                         iapiType.Date_Type,
      CHARACTERISTICDESC1CMPSTATUS  iapiType.Boolean_Type,
      CHARACTERISTICDESCRIPTION1    iapiType.Description_Type,
      CHARACTERISTICDESC2CMPSTATUS  iapiType.Boolean_Type,
      CHARACTERISTICDESCRIPTION2    iapiType.Description_Type,
      CHARACTERISTICDESC3CMPSTATUS  iapiType.Boolean_Type,
      CHARACTERISTICDESCRIPTION3    iapiType.Description_Type,
      RELEVANCYTOCOSTINGCMPSTATUS   iapiType.Boolean_Type,
      RELEVANCYTOCOSTING            iapiType.Boolean_Type,
      BULKMATERIALCMPSTATUS         iapiType.Boolean_Type,
      BULKMATERIAL                  iapiType.Boolean_Type,
      FIXEDQUANTITYCMPSTATUS        iapiType.Boolean_Type,
      FIXEDQUANTITY                 iapiType.Boolean_Type,
      BOOLEAN1CMPSTATUS             iapiType.Boolean_Type,
      BOOLEAN1                      iapiType.Boolean_Type,
      BOOLEAN2CMPSTATUS             iapiType.Boolean_Type,
      BOOLEAN2                      iapiType.Boolean_Type,
      BOOLEAN3CMPSTATUS             iapiType.Boolean_Type,
      BOOLEAN3                      iapiType.Boolean_Type,
      BOOLEAN4CMPSTATUS             iapiType.Boolean_Type,
      BOOLEAN4                      iapiType.Boolean_Type,
      INTLEQLNTCMPSTATUS            iapiType.Boolean_Type,
      INTERNATIONALEQUIVALENT       iapiType.Boolean_Type
   );

   TYPE CompLocBomHeaderRec_Type IS RECORD(
      PARTNO                        iapiType.PartNo_Type,
      REVISION                      iapiType.Revision_Type,
      PLANTNO                       iapiType.Plant_Type,
      ALTERNATIVE                   iapiType.BomAlternative_Type,
      BOMUSAGEID                    iapiType.BomUsage_Type,
      BOMUSAGEDESCRIPTION           iapiType.Description_Type,
      BOMDESCRIPTION                iapiType.Description_Type,
      INTERNATIONALPARTNO           iapiType.PartNo_Type,
      INTERNATIONALPARTREVISION     iapiType.Revision_Type,
      BOMHEADERCMPSTATUS            NUMBER( 1 ),
      DESCRIPTION                   iapiType.Description_Type,
      INTERNATIONALDESCRIPTION      iapiType.Description_Type
   );

   TYPE CompLocBomItemsRec_Type IS RECORD(
      BOMITEMCMPSTATUS              NUMBER( 1 ),
      PARTNO                        iapiType.PartNo_Type,
      REVISION                      iapiType.Revision_Type,
      PLANTNO                       iapiType.Plant_Type,
      ALTERNATIVE                   iapiType.BomAlternative_Type,
      BOMUSAGEID                    iapiType.BomUsage_Type,
      COMPONENTPARTNO               iapiType.PartNo_Type,
      COMPONENTDESCRIPTION          iapiType.Description_Type,
      COMPONENTREVISIONCMPSTATUS    NUMBER( 1 ),
      COMPONENTREVISION             iapiType.Revision_Type,
      COMPONENTPLANTCMPSTATUS       NUMBER( 1 ),
      COMPONENTPLANT                iapiType.Plant_Type,
      ITEMNUMBERCMPSTATUS           NUMBER( 1 ),
      ITEMNUMBER                    iapiType.BomItemNumber_Type,
      QUANTITYCMPSTATUS             NUMBER( 1 ),
      QUANTITY                      iapiType.BomQuantity_Type,
      RELATIVEQUANTITY              iapiType.BomQuantity_Type,
      UOMCMPSTATUS                  NUMBER( 1 ),
      UOM                           iapiType.BaseUom_Type,
      YIELDCMPSTATUS                NUMBER( 1 ),
      YIELD                         iapiType.BomYield_Type,
      ALTERNATIVEPRIORITY           iapiType.BomItemAltPriority_Type,
      ALTERNATIVEPRIORITYCMPSTATUS  NUMBER( 1 ),
      ALTERNATIVEGROUP              iapiType.BomItemAltGroup_Type,
      ALTERNATIVEGROUPCMPSTATUS     NUMBER( 1 )
   );

   TYPE DatabaseConfigRec_Type IS RECORD(
      Fda21cfr11                    BOOLEAN,
      Glossary                      BOOLEAN,
      FrameChanges                  BOOLEAN,
      FrameExport                   BOOLEAN,
      TestServer                    BOOLEAN,
      Recovered                     BOOLEAN
   );

   TYPE DatabaseRec_Type IS RECORD(
      Owner                         iapiType.Id_Type,
      Description                   iapiType.Description_Type,
      DatabaseType                  iapiType.DatabaseType_Type,
      ParentOwner                   iapiType.Id_Type,
      --AP01058362 --AP01033131 Start
      --Configuration                 iapiType.DatabaseConfigRec_Type --orig
      Configuration                 iapiType.DatabaseConfigRec_Type,
      --CreateSectionHistory variable is used for:
      --tables that are updated in the sp_set_spec_current procedure and
      --log history is created by the updated table's trigger
      ----to eliminate those logs
      CreateSectionHistory          BOOLEAN
      --AP01058362 --AP01033131 End
   );

   TYPE DeletedItemsPartPlantRec_Type IS RECORD(
      PartNo                        iapiType.PartNo_Type,
      Revision                      iapiType.Revision_Type,
      StatusId                      iapiType.StatusId_Type,
      Description                   iapiType.Description_Type,
      Plant                         iapiType.Plant_Type,
      Status                        iapiType.ShortDescription_Type
   );

   TYPE DeletedItemsPartRec_Type IS RECORD(
      PartNo                        iapiType.PartNo_Type,
      Revision                      iapiType.Revision_Type,
      StatusId                      iapiType.StatusId_Type,
      Description                   iapiType.Description_Type,
      Status                        iapiType.ShortDescription_Type
   );

   TYPE DFHeaderListRec_Type IS RECORD(
      FIELDID                       iapiType.Id_Type,
      HEADERID                      iapiType.Id_Type,
      HEADER                        iapiType.Description_Type
   );

   TYPE ErrorRec_Type IS RECORD(
      MESSAGETYPE                   INTEGER,
      ERRORPARAMETERID              iapiType.String_Type,
      ERRORTEXT                     iapiType.ErrorText_Type
   );

   TYPE ExpResultBoughtSoldRec_Type IS RECORD(
      PARTNO                        iapiType.PartNo_Type,
      REVISION                      iapiType.Revision_Type,
      DESCRIPTION                   iapiType.Description_Type,
      UOM                           iapiType.Description_Type,
      CALCULATEDQUANTITY            iapiType.BomQuantity_Type,
      CALCULATEDQUANTITYWITHSCRAP   iapiType.BomQuantity_Type,
      COST                          iapiType.BomQuantity_Type,
      COSTWITHSCRAP                 iapiType.BomQuantity_Type,
      CALCULATEDCOST                iapiType.BomQuantity_Type,
      CALCULATEDCOSTWITHSCRAP       iapiType.BomQuantity_Type,
      RECURSIVESTOP                 iapiType.Boolean_Type,
      ACCESSSTOP                    iapiType.Boolean_Type,
      PARTTYPEID                    iapiType.Id_Type,
      PARTTYPE                      iapiType.PartType_Type,
      PARTTYPEDESCRIPTION           iapiType.Description_Type
   );

   TYPE ExpResultRec_Type IS RECORD(
      MOPSEQUENCE                   iapiType.Sequence_Type,
      SEQUENCE                      iapiType.Sequence_Type,
      BOMLEVEL                      iapiType.Sequence_Type,
      PARTNO                        iapiType.PartNo_Type,
      REVISION                      iapiType.Revision_Type,
      DESCRIPTION                   iapiType.Description_Type,
      PLANTNO                       iapiType.Plant_Type,
      UOM                           iapiType.Description_Type,
      QUANTITY                      iapiType.BomQuantity_Type,
      SCRAP                         iapiType.Scrap_Type,
      CALCULATEDQUANTITY            iapiType.BomQuantity_Type,
      CALCULATEDQUANTITYWITHSCRAP   iapiType.BomQuantity_Type,
      COST                          iapiType.BomQuantity_Type,
      COSTWITHSCRAP                 iapiType.BomQuantity_Type,
      CALCULATEDCOST                iapiType.BomQuantity_Type,
      CALCULATEDCOSTWITHSCRAP       iapiType.BomQuantity_Type,
      PARTSOURCE                    iapiType.PartSource_Type,
      TOUNIT                        iapiType.Description_Type,
      CONVERSIONFACTOR              iapiType.BomQuantity_Type,
      PHANTOM                       iapiType.Boolean_Type,
      INGREDIENT                    iapiType.Boolean_Type,
      ALTERNATIVEPRICE              iapiType.BomQuantity_Type,
      PARTTYPEID                    iapiType.Id_Type,
      PARTTYPE                      iapiType.PartType_Type,
      ALTERNATIVE                   iapiType.BomAlternative_Type,
      BOMUSAGEID                    iapiType.BomUsage_Type,
      ASSEMBLYSCRAP                 iapiType.Scrap_Type,
      COMPONENTSCRAP                iapiType.Scrap_Type,
      LEADTIMEOFFSET                iapiType.BomLeadTimeOffset_Type,
      ITEMCATEGORY                  iapiType.BomItemCategory_Type,
      ISSUELOCATION                 iapiType.BomIssueLocation_Type,
      BOMTYPE                       iapiType.BomItemType_Type,
      OPERATIONALSTEP               iapiType.BomOperationalStep_Type,
      MINIMUMQUANTITY               iapiType.BomQuantity_Type,
      MAXIMUMQUANTITY               iapiType.BomQuantity_Type,
      CODE                          iapiType.BomItemCode_Type,
      BOMALTGROUP                   iapiType.BomItemAltGroup_Type,
      BOMALTPRIORITY                iapiType.BomItemAltPriority_Type,
      STRING1                       iapiType.BomItemLongCharacter_Type,
      STRING2                       iapiType.BomItemLongCharacter_Type,
      STRING3                       iapiType.BomItemCharacter_Type,
      STRING4                       iapiType.BomItemCharacter_Type,
      STRING5                       iapiType.BomItemCharacter_Type,
      NUMERIC1                      iapiType.BomItemNumeric_Type,
      NUMERIC2                      iapiType.BomItemNumeric_Type,
      NUMERIC3                      iapiType.BomItemNumeric_Type,
      NUMERIC4                      iapiType.BomItemNumeric_Type,
      NUMERIC5                      iapiType.BomItemNumeric_Type,
      BOOLEAN1                      iapiType.Boolean_Type,
      BOOLEAN2                      iapiType.Boolean_Type,
      BOOLEAN3                      iapiType.Boolean_Type,
      BOOLEAN4                      iapiType.Boolean_Type,
      DATE1                         iapiType.Date_Type,
      DATE2                         iapiType.Date_Type,
      CHARACTERISTICDESCRIPTION1    iapiType.Description_Type,
      CHARACTERISTICDESCRIPTION2    iapiType.Description_Type,
      CHARACTERISTICDESCRIPTION3    iapiType.Description_Type,
      RELEVANCYTOCOSTING            iapiType.Boolean_Type,
      BULKMATERIAL                  iapiType.Boolean_Type,
      RECURSIVESTOP                 iapiType.Boolean_Type,
      ACCESSSTOP                    iapiType.Boolean_Type
   );

   TYPE FilterRec_Type IS RECORD(
      LeftOperand                   iapiType.String_Type,
      RightOperand                  iapiType.String_Type,
      OPERATOR                      iapiType.String_Type
   );

   TYPE FoodClaimProfileRec_Type IS RECORD(
      REQUESTID                     iapiType.SequenceNr_Type,
      LOGID                         iapiType.SequenceNr_Type,
      GROUPID                       iapiType.SequenceNr_Type
   );

   TYPE FoodClaimRec_Type IS RECORD(
      FOODCLAIMID                   iapiType.SequenceNr_Type,
      DESCRIPTION                   iapiType.Description_Type,
      RELATIVE                      iapiType.Boolean_Type,
      MANDATORY                     iapiType.Boolean_Type,
      INTL                          iapiType.Boolean_Type,
      STATUS                        iapiType.Boolean_Type
   );

   TYPE FoodClaimRunCdRec_Type IS RECORD(
      FOODCLAIMID                   iapiType.SequenceNr_Type,
      REQUESTID                     iapiType.SequenceNr_Type,
      REFTYPE                       iapiType.SequenceNr_Type,
      REFID                         iapiType.SequenceNr_Type,
      RESULT                        iapiType.Boolean_Type
   );

   TYPE FoodClaimRunCritRec_Type IS RECORD(
      REQUESTID                     iapiType.SequenceNr_Type,
      KEYTYPE                       iapiType.SequenceNr_Type,
      KEYID                         iapiType.SequenceNr_Type,
      KEYOPERATOR                   iapiType.String_Type,
      KEYVALUE                      iapiType.String_Type,
      KEYUOM                        iapiType.String_Type
   );

   TYPE FoodClaimRunRec_Type IS RECORD(
      FOODCLAIMID                   iapiType.SequenceNr_Type,
      REQUESTID                     iapiType.SequenceNr_Type,
      LOGID                         iapiType.SequenceNr_Type,
      GROUPID                       iapiType.SequenceNr_Type,
      INCLUDE                       iapiType.Boolean_Type,
      FOODCLAIMCRITRULEID           iapiType.SequenceNr_Type,
      ERRORCODE                     iapiType.SequenceNr_Type
   );

   TYPE FoodClaimsConditionsRec_Type IS RECORD(
      LEVEL                         iapiType.NumVal_Type,
      FOODCLAIMCRITRULEID           iapiType.Sequence_Type,
      SEQUENCE                      iapiType.Sequence_Type,
      REFTYPE                       iapiType.SequenceNr_Type,
      REFID                         iapiType.SequenceNr_Type,
      RULEDESCRIPTION               iapiType.SqlString_Type,
      ANDOR                         iapiType.ClaimResultDAndOr_Type,
      CONDITIONDESCRIPTION          iapiType.SqlString_Type,
      RULEOPERATOR                  iapiType.ShortDescription_Type,
      RULEVALUE1                    iapiType.Description_Type,
      RULEVALUE2                    iapiType.Description_Type,
      SERVINGSIZE                   iapiType.Description_Type,
      VALUETYPE                     iapiType.ClaimResultDValueType_Type,
      RELATIVEPERC                  iapiType.ClaimResultDRelativePerc_Type,
      RELATIVECOMP                  iapiType.ClaimResultDRelativeComp_Type,
      RULETYPE                      iapiType.ClaimResultDRuleType_Type,
      RULEID                        iapiType.Sequence_Type,
      ATTRIBUTEID                   iapiType.Sequence_Type,
      FOODCLAIMCRITRULECDID         iapiType.Sequence_Type
   );

   TYPE FrameRec_Type IS RECORD(
      FRAMENO                       iapiType.FrameNo_Type,
-- IS1311 start
--      REVISION                      iapiType.Revision_Type,
      REVISION                      iapiType.FrameRevision_Type,
-- IS1311 end
      OWNER                         iapiType.Owner_Type,
      MASKID                        iapiType.Id_Type
   );

   TYPE FrameSectionItemRec_Type IS RECORD(
      FRAMENO                       iapiType.FrameNo_Type,
      FRAMEREVISION                 iapiType.FrameRevision_Type,
      OWNER                         iapiType.Owner_Type,
      SECTIONID                     iapiType.Id_Type,
      SECTIONREVISION               iapiType.Revision_Type,
      SUBSECTIONID                  iapiType.Id_Type,
      SUBSECTIONREVISION            iapiType.Revision_Type,
      ITEMTYPE                      iapiType.SpecificationSectionType_Type,
      ITEMID                        iapiType.Id_Type,
      ITEMREVISION                  iapiType.Revision_Type,
      ITEMOWNER                     iapiType.Owner_Type,
      ITEMINFO                      iapiType.ItemInfo_Type,
      SEQUENCE                      iapiType.Sequence_Type,
      SECTIONSEQUENCENUMBER         iapiType.Sequence_Type,
      DISPLAYFORMATID               iapiType.Id_Type,
      DISPLAYFORMATREVISION         iapiType.Revision_Type,
      ASSOCIATIONID                 iapiType.Id_Type,
      INTERNATIONAL                 iapiType.Intl_Type,
      HEADER                        iapiType.Boolean_Type,
      OPTIONAL                      iapiType.Boolean_Type
   );

   TYPE FrameSectionListRec_Type IS RECORD(
      FRAMENO                       iapiType.FrameNo_Type,
      REVISION                      iapiType.FrameRevision_Type,
      OWNER                         iapiType.Owner_Type,
      SECTIONID                     iapiType.Id_Type,
      SECTIONREVISION               iapiType.Revision_Type,
      SUBSECTIONID                  iapiType.Id_Type,
      SUBSECTIONREVISION            iapiType.Revision_Type,
      SEQUENCE                      iapiType.Sequence_Type,
      EXTENDABLE                    iapiType.Boolean_Type
   );

   TYPE FrameSectionRec_Type IS RECORD(
      FrameNo                       iapiType.PartNo_Type,
      Revision                      iapiType.Revision_Type,
      SectionId                     iapiType.Id_Type,
      SectionRevision               iapiType.Revision_Type,
      SubSectionId                  iapiType.Id_Type,
      SubSectionRevision            iapiType.Revision_Type,
      NAME                          iapiType.Name_Type,
      Extendable                    iapiType.Boolean_Type,
      RowIndex                      iapiType.NumVal_Type,
      ParentRowIndex                iapiType.NumVal_Type
   );

   TYPE FreeTextListRec_Type IS RECORD(
      PARTNO                        iapiType.PartNo_Type,
      REVISION                      iapiType.Revision_Type,
      SECTIONID                     iapiType.Id_Type,
      SUBSECTIONID                  iapiType.Id_Type,
      ITEMID                        iapiType.Id_Type,
      ITEMREVISION                  iapiType.Revision_Type,
      ITEMDESCRIPTION               iapiType.Description_Type
   );

   TYPE FreeTextRec_Type IS RECORD(
      PARTNO                        iapiType.PartNo_Type,
      REVISION                      iapiType.Revision_Type,
      SECTIONID                     iapiType.Id_Type,
      SUBSECTIONID                  iapiType.Id_Type,
      ITEMID                        iapiType.Id_Type,
      ITEMREVISION                  iapiType.Revision_Type,
      ITEMDESCRIPTION               iapiType.Description_Type
   );

   TYPE FrSectionItemRec_Type IS RECORD(
      FRAMENO                       iapiType.PartNo_Type,
      FRAMEREVISION                 iapiType.Revision_Type,
      OWNER                         iapiType.Owner_Type,
      SECTIONID                     iapiType.Id_Type,
      SECTIONREVISION               iapiType.Revision_Type,
      SUBSECTIONID                  iapiType.Id_Type,
      SUBSECTIONREVISION            iapiType.Revision_Type,
      ITEMTYPE                      iapiType.SpecificationSectionType_Type,
      ITEMID                        iapiType.Id_Type,
      ITEMREVISION                  iapiType.Revision_Type,
      ITEMOWNER                     iapiType.Owner_Type,
      ITEMINFO                      iapiType.Id_Type,
      SEQUENCE                      iapiType.SpSectionSequenceNumber_Type,
      SECTIONSEQUENCENUMBER         iapiType.SpSectionSequenceNumber_Type,
      DISPLAYFORMATID               iapiType.Id_Type,
      DISPLAYFORMATREVISION         iapiType.Revision_Type,
      ASSOCIATIONID                 iapiType.Id_Type,
      INTERNATIONAL                 iapiType.Intl_Type,
      HEADER                        iapiType.Boolean_Type,
      OPTIONAL                      iapiType.Boolean_Type,
      ROWINDEX                      iapiType.NumVal_Type
   );

   TYPE FrSectionRec_Type IS RECORD(
      FrameNo                       iapiType.FrameNo_Type,
      Revision                      iapiType.FrameRevision_Type,
      SectionId                     iapiType.Id_Type,
      SectionRevision               iapiType.Revision_Type,
      SectionName                   iapiType.Name_Type,
      SubSectionId                  iapiType.Id_Type,
      SubSectionRevision            iapiType.Revision_Type,
      SubSectionName                iapiType.Name_Type,
      SEQUENCE                      iapiType.Sequence_Type,
      Extendable                    iapiType.Boolean_Type,
      RowIndex                      iapiType.NumVal_Type,
      ParentRowIndex                iapiType.NumVal_Type
   );

     --IS160 comm out
   TYPE GetBomItemRec_Type IS RECORD(
      PartNo                        iapiType.PartNo_Type,
      Revision                      iapiType.Revision_Type,
      Plant                         iapiType.Plant_Type,
      Alternative                   iapiType.BomAlternative_Type,
      BomUsage                      iapiType.BomUsage_Type,
      ItemNumber                    iapiType.BomItemNumber_Type,
     AlternativeGroup              iapiType.BomItemAltGroup_Type,
      AlternativePriority           iapiType.BomItemAltPriority_Type,
      ComponentPartNo               iapiType.PartNo_Type,
      ComponentRevision             iapiType.Revision_Type,
      ComponentDescription          iapiType.Description_Type,
      ComponentPlant                iapiType.Plant_Type,
      PartSource                    iapiType.PartSource_Type,
      PartTypeGroup                 iapiType.PartTypeGroup_Type,
      Quantity                      iapiType.BomQuantity_Type,
      Uom                           iapiType.Description_Type,
      ConversionFactor              iapiType.BomConvFactor_Type,
      ConvertedUom                  iapiType.Description_Type,
      Yield                         iapiType.BomYield_Type,
      AssemblyScrap                 iapiType.Scrap_Type,
      ComponentScrap                iapiType.Scrap_Type,
      LeadTimeOffset                iapiType.BomLeadTimeOffset_Type,
      RelevancyToCosting            iapiType.Boolean_Type,
      BulkMaterial                  iapiType.Boolean_Type,
      ItemCategory                  iapiType.BomItemCategory_Type,
      ItemCategoryDescr             iapiType.Description_Type,
      IssueLocation                 iapiType.BomIssueLocation_Type,
      CalculationMode               iapiType.BomItemCalcFlag_Type,
      BomItemType                   iapiType.BomItemType_Type,
      OperationalStep               iapiType.BomOperationalStep_Type,
      MinimumQuantity               iapiType.BomQuantity_Type,
      MaximumQuantity               iapiType.BomQuantity_Type,
      FixedQuantity                 iapiType.Boolean_Type,
      Code                          iapiType.BomItemCode_Type,
      Text1                         iapiType.BomItemLongCharacter_Type,
      Text2                         iapiType.BomItemLongCharacter_Type,
      Text3                         iapiType.BomItemCharacter_Type,
      Text4                         iapiType.BomItemCharacter_Type,
      Text5                         iapiType.BomItemCharacter_Type,
      Numeric1                      iapiType.BomItemNumeric_Type,
      Numeric2                      iapiType.BomItemNumeric_Type,
      Numeric3                      iapiType.BomItemNumeric_Type,
      Numeric4                      iapiType.BomItemNumeric_Type,
      Numeric5                      iapiType.BomItemNumeric_Type,
      Boolean1                      iapiType.boolean_type,
      Boolean2                      iapiType.boolean_type,
      Boolean3                      iapiType.boolean_type,
      Boolean4                      iapiType.boolean_type,
      Date1                         iapiType.Date_Type,
      Date2                         iapiType.Date_Type,
      Characteristic1               iapiType.id_type,
      Characteristic1Revision       iapiType.Revision_type,
      Characteristic2               iapiType.id_type,
      Characteristic2Revision       iapiType.Revision_type,
      Characteristic3               iapiType.id_type,
      Characteristic3Revision       iapiType.Revision_type,
      Characteristic1Description    iapiType.Description_Type,
      Characteristic2Description    iapiType.Description_Type,
      Characteristic3Description    iapiType.Description_Type,
      MakeUp                        iapiType.Boolean_Type,
      InternationalEquivalent       iapiType.PartNo_Type,
      ViewBomAccess                 iapiType.Boolean_Type,
      ComponentScrapSync            iapiType.Boolean_Type,
      Owner                         iapiType.Owner_Type
   );

   TYPE GetStageDataRec_Type IS RECORD(
      PARTNO                        iapiType.PartNo_Type,
      REVISION                      iapiType.Revision_Type,
      SECTIONID                     iapiType.Id_Type,
      SECTIONREVISION               iapiType.Revision_Type,
      SUBSECTIONID                  iapiType.Id_Type,
      SUBSECTIONREVISION            iapiType.Revision_Type,
      STAGEID                       iapiType.StageId_Type,
      PROPERTYID                    iapiType.Id_Type,
      PROPERTYREVISION              iapiType.Revision_Type,
      PROPERTY                      iapiType.Description_Type,
      ATTRIBUTEID                   iapiType.Id_Type,
      ATTRIBUTEREVISION             iapiType.Revision_Type,
      ATTRIBUTE                     iapiType.Description_Type,
      TESTMETHODID                  iapiType.Id_Type,
      TESTMETHODREVISION            iapiType.Revision_Type,
      TESTMETHOD                    iapiType.Description_Type,
      STRING1                       iapiType.PropertyShortString_Type,
      STRING2                       iapiType.PropertyShortString_Type,
      STRING3                       iapiType.PropertyShortString_Type,
      STRING4                       iapiType.PropertyShortString_Type,
      STRING5                       iapiType.PropertyShortString_Type,
      STRING6                       iapiType.PropertyLongString_Type,
      BOOLEAN1                      iapiType.Boolean_Type,
      BOOLEAN2                      iapiType.Boolean_Type,
      BOOLEAN3                      iapiType.Boolean_Type,
      BOOLEAN4                      iapiType.Boolean_Type,
      DATE1                         iapiType.Date_Type,
      DATE2                         iapiType.Date_Type,
      CHARACTERISTICID1             iapiType.Id_Type,
      CHARACTERISTICREVISION1       iapiType.Revision_Type,
      CHARACTERISTICDESCRIPTION1    iapiType.Description_Type,
      NUMERIC1                      iapiType.Float_Type,
      NUMERIC2                      iapiType.Float_Type,
      NUMERIC3                      iapiType.Float_Type,
      NUMERIC4                      iapiType.Float_Type,
      NUMERIC5                      iapiType.Float_Type,
      NUMERIC6                      iapiType.Float_Type,
      NUMERIC7                      iapiType.Float_Type,
      NUMERIC8                      iapiType.Float_Type,
      NUMERIC9                      iapiType.Float_Type,
      NUMERIC10                     iapiType.Float_Type,
      ASSOCIATIONID1                iapiType.Id_Type,
      ASSOCIATIONREVISION1          iapiType.Revision_Type,
      INTERNATIONAL                 iapiType.Intl_Type,
      UPPERLIMIT                    iapiType.NumVal_Type,
      LOWERLIMIT                    iapiType.NumVal_Type,
      UOMID                         iapiType.Id_Type,
      UOMREVISION                   iapiType.Revision_Type,
      UOM                           iapiType.Description_Type,
      STAGE                         iapiType.Description_Type,
      PLANTNO                       iapiType.PlantNo_Type,
      CONFIGURATION                 iapiType.Configuration_Type,
      LINEREVISION                  iapiType.Revision_Type,
      LINE                          iapiType.Line_Type,
      TEXT                          iapiType.String_Type,
      SEQUENCE                      iapiType.LinePropSequence_Type,
      VALUETYPE                     iapiType.ValueType_Type,
      COMPONENTPARTNO               iapiType.PartNo_Type,
      ITEMDESCRIPTION               iapiType.Description_Type,
      STAGEREVISION                 iapiType.Revision_Type,
      --AP00978864 --AP00978035 Start
--      QUANTITY                      iapiType.Quantity_Type, --orig
--      QUANTITYBOMPCT                iapiType.Quantity_Type, --orig
      QUANTITY                      iapiType.BomQuantity_Type,
      QUANTITYBOMPCT                iapiType.BomQuantity_Type,
      --AP00978864 --AP00978035 End
      UOMBOMPCT                     iapiType.Description_Type,
      BOMALTERNATIVE                iapiType.BomAlternative_Type,
      BOMUSAGEID                    iapiType.BomUsageId_Type,
      ALTERNATIVELANGUAGEID         iapiType.LanguageId_Type,
      ALTERNATIVESTRING1            iapiType.PropertyShortString_Type,
      ALTERNATIVESTRING2            iapiType.PropertyShortString_Type,
      ALTERNATIVESTRING3            iapiType.PropertyShortString_Type,
      ALTERNATIVESTRING4            iapiType.PropertyShortString_Type,
      ALTERNATIVESTRING5            iapiType.PropertyShortString_Type,
      ALTERNATIVESTRING6            iapiType.PropertyLongString_Type,
      ALTERNATIVETEXT               iapiType.String_Type,
      TRANSLATED                    iapiType.Boolean_Type,
      OWNER                         iapiType.Owner_Type,
      ROWINDEX                      iapiType.NumVal_Type
   );

   TYPE HdrRec_Type IS RECORD(
      FIELDID                       iapiType.Id_Type,
      HEADERID                      iapiType.Id_Type,
      HEADER                        iapiType.Description_Type
   );

   TYPE HeaderListRec_Type IS RECORD(
      PARTNO                        iapiType.PartNo_Type,
      REVISION                      iapiType.Revision_Type,
      SPECIFICATIONDESCRIPTION      iapiType.Description_Type,
      PLANTNO                       iapiType.PlantNo_Type,
      ALTERNATIVE                   iapiType.BomAlternative_Type,
      BOMUSAGEID                    iapiType.BomUsageId_Type,
      DESCRIPTION                   iapiType.Description_Type,
      PLANTDESCRIPTION              iapiType.Description_Type,
      BOMUSAGEDESCRIPTION           iapiType.Description_Type,
      QUANTITY                      iapiType.BomQuantity_Type,
      UOM                           iapiType.BaseUom_Type,
      CONVERSIONFACTOR              iapiType.BomConvFactor_Type,
      BASETOUNIT                    iapiType.BaseToUnit_Type,
      CALCULATEDQUANTITY            iapiType.BomQuantity_Type,
      MINIMUMQUANTITY               iapiType.BomQuantity_Type,
      MAXIMUMQUANTITY               iapiType.BomQuantity_Type,
      YIELD                         iapiType.BomYield_Type,
      CALCULATIONMODE               iapiType.BomItemCalcFlag_Type,
      BOMTYPE                       iapiType.BomItemType_Type,
      PLANNEDEFFECTIVEDATE          iapiType.Date_Type,
      PREFERRED                     iapiType.Boolean_Type,
      HASITEMS                      iapiType.Boolean_Type
   );

   TYPE HeaderRec_Type IS RECORD(
      HEADERID                      iapiType.Id_Type,
      DESCRIPTION                   iapiType.Description_Type,
      FIELDTYPE                     iapiType.NumVal_Type,
      FIELDID                       iapiType.Id_Type
   );

   TYPE ImplosionResultRec_Type IS RECORD(
      BOMLEVEL                      iapiType.BomLevel_Type,
      PARTNO                        iapiType.PartNo_Type,
      PARENTPARTNO                  iapiType.PartNo_Type,
      PARENTREVISION                iapiType.Revision_Type,
      DESCRIPTION                   iapiType.Description_Type,
      PLANTNO                       iapiType.Plant_Type,
      ALTERNATIVE                   iapiType.BomAlternative_Type,
      BOMUSAGEID                    iapiType.BomUsage_Type,
      BOMUSAGEDESCRIPTION           iapiType.Description_Type,
      SPECIFICATIONTYPE             iapiType.Id_Type,
      TOPLEVEL                      iapiType.Boolean_Type,
      RECURSIVESTOP                 iapiType.Boolean_Type,
      ACCESSSTOP                    iapiType.Boolean_Type,
      ALTERNATIVEGROUP              iapiType.BomItemAltGroup_Type,
      ALTERNATIVEPRIORITY           iapiType.BomItemAltPriority_Type
   );

   TYPE ImpMapNameListRec_Type IS RECORD(
      NAME                          iapiType.PropertyShortString_Type
   );

   TYPE ImpMappingListRec_Type IS RECORD(
      USERID                        iapiType.UserId_Type,
      NAME                          iapiType.PropertyShortString_Type,
      SEQUENCE                      iapiType.Sequence_Type,
      REMAPTYPE                     VARCHAR2( 1 ),
      REMAPGROUP                    VARCHAR2( 1 ),
      REMAPITEM                     VARCHAR2( 3 ),
      REMAPORIGINALVALUE            iapiType.PropertyShortString_Type,
      REMAPVALUE                    iapiType.PropertyShortString_Type
   );

   TYPE ImportLogRec_Type IS RECORD(
      TIMESTAMP                     iapiType.Date_Type,
      LOGTYPE                       iapiType.LogType_Type,
      MESSAGE                       iapiType.MESSAGE_TYPE
   );

   TYPE InfoRec_Type IS RECORD(
      PARAMETERNAME                 iapiType.Parameter_Type,
      PARAMETERDATA                 iapiType.ParameterData_Type
   );

   TYPE IngGroupLevelRec_Type IS RECORD(
      INGREDIENTID                  iapiType.Id_Type,
      INGREDIENT                    iapiType.Description_Type,
      INGREDIENTINTERNATIONAL       iapiType.Intl_Type
   );

   TYPE IngGroupsRec_Type IS RECORD(
      INGREDIENTPARENTID            iapiType.Id_Type,
      INGREDIENTPARENT              iapiType.Description_Type,
      INGREDIENTPARENTINTL          iapiType.Intl_Type,
      INGREDIENTID                  iapiType.Id_Type,
      INGREDIENT                    iapiType.Description_Type,
      INGREDIENTINTERNATIONAL       iapiType.Intl_Type
   );

   TYPE IngListRec_Type IS RECORD(
      INGREDIENT                    iapiType.Id_Type,
      QUANTITY                      iapiType.BomQuantity_Type,
      SEQUENCE                      iapiType.Sequence_Type,
      HIERARCHICALLEVEL             iapiType.IngredientHierarchicLevel_Type,
      PARENTSEQUENCE                iapiType.Sequence_Type,
      RECONSTITUTIONFACTOR          iapiType.ReconstitutionFactor_Type,
      STANDARDOFIDENTITY            iapiType.Boolean_Type,
      ALLERGENID                    iapiType.Id_Type,
      ALLERGEN                      iapiType.String_Type,
      DESCRIPTION                   iapiType.String_Type,
      SYNONYMNAME                   iapiType.String_Type,
      DECLAREFLAG                   iapiType.Boolean_Type,
      ORIGINALINGREDIENT            iapiType.Id_Type,
      ORIGINALINGREDIENTDESC        iapiType.String_Type,
      RECONSTITUTIONINGREDIENT      iapiType.Id_Type,
      RECONSTITUTIONINGREDDESC      iapiType.String_Type,
      ACTIVEINGREDIENT              iapiType.Boolean_Type
   );

   TYPE IngNotesRec_Type IS RECORD(
      ID                            iapiType.Id_Type,
      DESCRIPTION                   iapiType.String_Type,
      TEXT                          iapiType.Clob_Type,
      PREFERRED                     iapiType.SingleVarChar_Type
   );

   TYPE IngredientExplosionRec_Type IS RECORD(
      MOPSEQUENCE                   iapiType.Sequence_Type,
      SEQUENCE                      iapiType.Sequence_Type,
      INGREDIENTSEQUENCE            iapiType.Sequence_Type,
      BOMLEVEL                      iapiType.BomLevel_Type,
      INGREDIENT                    iapiType.Id_Type,
      REVISION                      iapiType.Revision_Type,
      DESCRIPTION                   iapiType.Description_Type,
      QUANTITY                      iapiType.BomQuantity_Type,
      INGREDIENTLEVEL               iapiType.IngredientLevel_Type,
      INGREDIENTCOMMENT             iapiType.IngredientComment_Type,
      INGREDIENTPARENT              iapiType.Id_Type,
      HIERARCHICALLEVEL             iapiType.IngredientHierarchicLevel_Type,
      RECONSTITUTIONFACTOR          iapiType.ReconstitutionFactor_Type,
      SYNONYMID                     iapiType.Id_Type,
      SYNONYMREVISION               iapiType.Revision_Type,
      ACTIVE                        iapiType.Boolean_Type,
      COMPONENTPARTNO               iapiType.PartNo_Type,
      COMPONENTREVISION             iapiType.Revision_Type,
      COMPONENTDESCRIPTION          iapiType.Description_Type,
      PLANTNO                       iapiType.Plant_Type,
      ALTERNATIVE                   iapiType.BomAlternative_Type,
      BOMUSAGEID                    iapiType.BomUsage_Type,
      CALCULATEDQUANTITY            iapiType.BomQuantity_Type,
      UOM                           iapiType.BaseUom_Type,
      CONVERSIONFACTOR              iapiType.BomConvFactor_Type,
      TOUNIT                        iapiType.BaseUom_Type,
      DECLAREFLAG                   iapiType.Boolean_Type
   );

   TYPE IngredientRec_Type IS RECORD(
      INGREDIENTID                  iapiType.Id_Type,
      INGREDIENT                    iapiType.String_Type,
      ALLERGENID                    iapiType.Id_Type,
      ALLERGEN                      iapiType.String_Type,
      STANDARDOFIDENTITY            iapiType.SingleVarChar_Type
   );

   TYPE KeywordRec_Type IS RECORD(
      KEYWORDID                     iapiType.Id_Type,
      KEYWORD                       iapiType.Description_Type,
      KEYWORDTYPE                   iapiType.Keyword_Type,
      KEYWORDVALUE                  iapiType.Description_Type,
      INTERNATIONAL                 iapiType.Boolean_Type
   );

   TYPE LabelIngListRec_Type IS RECORD(
      INGREDIENTID                  iapiType.Id_Type,
      INGREDIENT                    iapiType.Description_Type,
      ALLERGEN                      iapiType.Id_Type,
      STANDARDOFIDENTITY            iapiType.Boolean_Type
   );

   TYPE LabelLogRec_Type IS RECORD(
      LOGID                         iapiType.LogId_Type,
      LOGNAME                       iapiType.Description_Type,
      STATUSID                      iapiType.StatusId_Type,
      STATUS                        iapiType.Description_Type,
      PARTNO                        iapiType.PartNo_Type,
      REVISION                      iapiType.Revision_Type,
      SPECIFICATIONDESCRIPTION      iapiType.Description_Type,
      PLANT                         iapiType.Plant_Type,
      ALTERNATIVE                   iapiType.BomAlternative_Type,
      BOMUSAGEID                    iapiType.BomUsageId_Type,
      BOMUSAGEDESCRIPTION           iapiType.Description_Type,
      EXPLOSIONDATE                 iapiType.Date_Type,
      CREATEDBY                     iapiType.UserId_Type,
      CREATEDON                     iapiType.Date_Type,
      LABEL                         iapiType.Clob_Type,
      STANDARDOFIDENTITY            iapiType.Boolean_Type,
      LANGUAGEID                    iapiType.LanguageId_Type,
      LANGUAGE                      iapiType.Description_Type,
      SYNONYMTYPEID                 iapiType.Id_Type,
      SYNONYMTYPENAME               iapiType.String_Type,
      LOGGINGXML                    iapiType.Clob_Type,
      LABELTYPE                     iapiType.LabelType_Type,
      LABELXML                      iapiType.Clob_Type,
      LABELRTF                      iapiType.Blob_Type
   );

   TYPE LabelLogResDetRec_Type IS RECORD(
      LOGID                         iapiType.LogId_Type,
      SEQUENCE                      iapiType.Sequence_Type,
      PARENTSEQUENCE                iapiType.Sequence_Type,
      BOMLEVEL                      iapiType.BomLevel_Type,
      INGREDIENTID                  iapiType.Id_Type,
      ISINGROUP                     iapiType.Boolean_Type,
      ISINFUNCTION                  iapiType.Boolean_Type,
      DESCRIPTION                   iapiType.Description_Type,
      QUANTITY                      iapiType.BomQuantity_Type,
      NOTE                          iapiType.Clob_Type,
      RECFROMID                     iapiType.Id_Type,
      RECFROMDESC                   iapiType.Description_Type,
      RECWITHID                     iapiType.Id_Type,
      RECWITHDESC                   iapiType.Description_Type,
      SHOWRECONSTITUTES             iapiType.Boolean_Type,
      ACTIVEINGREDIENT              iapiType.Boolean_Type,
      QUID                          iapiType.Boolean_Type,
      USEPERCENTAGE                 iapiType.Boolean_Type,
      SHOWITEMS                     iapiType.Boolean_Type,
      USEPERCREL                    iapiType.Boolean_Type,
      USEPERCABS                    iapiType.Boolean_Type,
      USEBRACKETS                   iapiType.Boolean_Type,
      ALLERGEN                      iapiType.Id_Type,
      STANDARDOFIDENTITY            iapiType.Boolean_Type,
      COMPLEXLABELLOGID             iapiType.Id_Type,
      PARAGRAPH                     iapiType.NumVal_Type,
      SORTSEQUENCE                  iapiType.Sequence_Type
   );

   TYPE LocationRec_Type IS RECORD(
      LOCATIONID                    iapiType.LocationId_Type,
      LOCATION                      iapiType.Location_Type
   );

   TYPE ManufacturerPlantRec_Type IS RECORD(
      MANUFACTURERPLANTNO           iapiType.ManufacturerPlantNo_Type,
      MANUFACTURERPLANT             iapiType.Description_Type,
      MANUFACTURERID                iapiType.Id_Type,
      MANUFACTURER                  iapiType.Description_Type,
      HISTORIC                      iapiType.Boolean_Type,
      INTERNATIONAL                 iapiType.Boolean_Type
   );

   TYPE ManufacturerRec_Type IS RECORD(
      MANUFACTURERID                iapiType.Id_Type,
      MANUFACTURER                  iapiType.Description_Type,
      HISTORIC                      iapiType.Boolean_Type,
      INTERNATIONAL                 iapiType.Boolean_Type,
      MANUFACTURERTYPEID            iapiType.Id_Type,
      MANUFACTURERTYPE              iapiType.Description_Type,
      MANUFACTURERTYPESTATUS        iapiType.Boolean_Type,
      MANUFACTURERTYPEINTERNATIONAL iapiType.Boolean_Type
   );

   TYPE ManufacturerTypeRec_Type IS RECORD(
      MANUFACTURERTYPEID            iapiType.Id_Type,
      MANUFACTURERTYPE              iapiType.Description_Type,
      HISTORIC                      iapiType.Boolean_Type,
      INTERNATIONAL                 iapiType.Boolean_Type
   );

   TYPE MopRpvSectionDataRec_Type IS RECORD(
      USERID                        iapiType.UserId_Type,
      PARTNO                        iapiType.PartNo_Type,
      REVISION                      iapiType.Revision_Type,
      TEXT                          iapiType.Text_Type,
      INTERNATIONAL                 iapiType.Boolean_Type,
      FIELDTYPE                     iapiType.String_Type,
      OLDVALUECHAR                  iapiType.String_Type,
      NEWVALUECHAR                  iapiType.String_Type,
      OLDVALUENUM                   iapiType.Float_Type,
      NEWVALUENUM                   iapiType.Float_Type,
      OLDVALUEDATE                  iapiType.Date_Type,
      NEWVALUEDATE                  iapiType.Date_Type,
      OLDVALUETMID                  iapiType.Float_Type,
      NEWVALUETMID                  iapiType.Float_Type,
      OLDVALUETM                    iapiType.Description_Type,
      OLDVALUEASSID                 iapiType.Float_Type,
      NEWVALUEASSID                 iapiType.Float_Type,
      OLDVALUEASS                   iapiType.Description_Type,
      ROWINDEX                      iapiType.NumVal_Type
   );

   TYPE NutColRec_Type IS RECORD(
      COLUMNID                      iapiType.Id_Type,
      HEADER                        iapiType.Description_Type,
      DATATYPE                      iapiType.Boolean_Type
   );

   TYPE NutCurrentLyRec_Type IS RECORD(
      LAYOUTID                      iapiType.Id_Type,
      REVISION                      iapiType.Revision_Type,
      DESCRIPTION                   iapiType.Description_Type
   );

   TYPE NutEnergyFactorRec_Type IS RECORD(
      PROPERTY                      iapiType.Sequence_Type,
      PROPERTYREVISION              iapiType.Revision_Type,
      ATTRIBUTE                     iapiType.Sequence_Type,
      ATTRIBUTEREVISION             iapiType.Revision_Type,
      VALUE                         iapiType.Float_Type
   );

   TYPE NutFilterDetailRec_Type IS RECORD(
      ID                            iapiType.Id_Type,
      SEQUENCE                      iapiType.Sequence_Type,
      PROPERTY                      iapiType.Id_Type,
      PROPERTYREVISION              iapiType.Revision_Type,
      ATTRIBUTE                     iapiType.Id_Type,
      ATTRIBUTEREVISION             iapiType.Revision_Type,
      DESCRIPTION                   iapiType.Description_Type,
      VISIBLE                       iapiType.Boolean_Type
   );

   TYPE NutFilterDetailsRec_Type IS RECORD(
      SEQUENCE                      iapiType.Sequence_Type,
      PROPERTYID                    iapiType.Id_Type,
      PROPERTYREVISION              iapiType.Revision_Type,
      ATTRIBUTEID                   iapiType.Id_Type,
      ATTRIBUTEREVISION             iapiType.Revision_Type,
      VISIBLE                       iapiType.Boolean_Type,
      USE                           iapiType.Boolean_Type
   );

   TYPE NutFilterListRec_Type IS RECORD(
      ID                            iapiType.Id_Type,
      NAME                          iapiType.Description_Type,
      DESCRIPTION                   iapiType.Description_Type,
      CREATEDON                     iapiType.Date_Type
   );

   TYPE NutFilterRec_Type IS RECORD(
      ID                            iapiType.Id_Type,
      SEQUENCE                      iapiType.Sequence_Type,
      PROPERTY                      iapiType.Id_Type,
      PROPERTYREVISION              iapiType.Revision_Type,
      ATTRIBUTE                     iapiType.Id_Type,
      ATTRIBUTEREVISION             iapiType.Revision_Type,
      DESCRIPTION                   iapiType.Description_Type
   );

   TYPE NutLogRec_Type IS RECORD(
      LOGID                         iapiType.LogId_Type,
      LOGNAME                       iapiType.Description_Type,
      STATUSID                      iapiType.StatusId_Type,
      STATUS                        iapiType.Description_Type,
      PARTNO                        iapiType.PartNo_Type,
      REVISION                      iapiType.Revision_Type,
      SPECIFICATIONDESCRIPTION      iapiType.Description_Type,
      PLANT                         iapiType.Plant_Type,
      ALTERNATIVE                   iapiType.BomAlternative_Type,
      BOMUSAGEID                    iapiType.BomUsageId_Type,
      BOMUSAGEDESCRIPTION           iapiType.Description_Type,
      EXPLOSIONDATE                 iapiType.Date_Type,
      REFERENCESPECID               iapiType.PartNo_Type,
      REFERENCESPECREVISION         iapiType.Revision_Type,
      REFERENCESPEC                 iapiType.Description_Type,
      LAYOUTID                      iapiType.Id_Type,
      LAYOUTREVISION                iapiType.Revision_Type,
      LAYOUTNAME                    iapiType.Description_Type,
      CREATEDBY                     iapiType.UserId_Type,
      CREATEDON                     iapiType.Date_Type,
      LOGGINGXML                    iapiType.Clob_Type,
      SERVINGSIZEID                 iapiType.Id_Type,
      SERVINGSIZE                   iapiType.Description_Type,
      DECSEP                        iapiType.DecimalSeperator_Type
   );

   TYPE NutLogResDetRec_Type IS RECORD(
      LOGID                         iapiType.LogId_Type,
      COLUMNID                      iapiType.Id_Type,
      ROW_ID                        iapiType.Sequence_Type,
      SEQUENCE                      iapiType.Sequence_Type,
      PARTNO                        iapiType.PartNo_Type,
      REVISION                      iapiType.Revision_Type,
      DESCRIPTION                   iapiType.Description_Type,
      DISPLAYNAME                   iapiType.Description_Type,
      VALUE                         iapiType.Clob_Type
   );

   TYPE NutLogResultDetailRec_Type IS RECORD(
      LOGID                         iapiType.Id_Type,
      COLUMNID                      iapiType.Id_Type,
      ROW_ID                        iapiType.Id_Type,
      SEQUENCE                      iapiType.Id_Type,
      PARTNO                        iapiType.PartNo_Type,
      REVISION                      iapiType.Revision_Type,
      DESCRIPTION                   iapiType.Description_Type,
      DISPLAYNAME                   iapiType.Description_Type,
      VALUE                         iapiType.Clob_Type
   );

   TYPE NutLogResultRec_Type IS RECORD(
      LOGID                         iapiType.Id_Type,
      COLUMNID                      iapiType.Id_Type,
      ROW_ID                        iapiType.Id_Type,
      VALUE                         iapiType.Clob_Type,
      PROPERTYID                    iapiType.Id_Type,
      PROPERTYREVISION              iapiType.Revision_Type,
      PROPERTY                      iapiType.Description_Type,
      ATTRIBUTEID                   iapiType.Id_Type,
      ATTRIBUTEREVISION             iapiType.Revision_Type,
      ATTRIBUTE                     iapiType.Description_Type
   );

   TYPE NutLyItemsRec_Type IS RECORD(
      LAYOUTID                      iapiType.Id_Type,
      REVISION                      iapiType.Revision_Type,
      HEADER                        iapiType.Description_Type,
      DATATYPE                      NUMBER( 1 ),
      MODIFIABLE                    iapiType.Boolean_Type,
      LENGTH                        NUMBER( 5 ),
      COLUMNTYPE                    NUMBER( 1 ),
      SEQUENCE                      iapiType.Sequence_Type
   );

   TYPE NutLyRec_Type IS RECORD(
      LAYOUTID                      iapiType.Id_Type,
      REVISION                      iapiType.Revision_Type,
      HEADER                        iapiType.Description_Type
   );

   TYPE NutPanelListRec_Type IS RECORD(
      ID                            iapiType.Id_Type,
      SEQUENCE                      iapiType.Sequence_Type,
      PARTNO                        iapiType.PartNo_Type,
      REVISION                      iapiType.Revision_Type,
      CREATEDON                     iapiType.Date_Type
   );

   TYPE NutPathRec_Type IS RECORD(
      UNIQUEID                      iapiType.Sequence_Type,
      MOPSEQUENCE                   iapiType.Sequence_Type,
      SEQUENCE                      iapiType.Sequence_Type,
      PARTNO                        iapiType.PartNo_Type,
      REVISION                      iapiType.Revision_Type,
      SECTIONID                     iapiType.Id_Type,
      SUBSECTIONID                  iapiType.Id_Type,
      PROPERTYGROUP                 iapiType.Id_Type,
      EANUPCBARCODE                 iapiType.PartNo_Type,
      ALTERNATIVEREVISION           iapiType.Revision_Type,
      NUTRITIONALXMLVALUE           iapiType.Clob_Type,
      NAME                          iapiType.Description_Type,
      DESCRIPTION                   iapiType.Description_Type,
      BASEQUANTITY                  iapiType.BomQuantity_Type,
      SERVINGCONVERSIONFACTOR       iapiType.BomConvFactor_Type,
      SERVINGVOLUME                 iapiType.BomQuantity_Type,
      UOM                           iapiType.BaseUom_Type,
      CONVERSIONFACTOR              iapiType.BomConvFactor_Type,
      TOUNIT                        iapiType.BaseUom_Type,
      CALCULATEDQUANTITYWITHSCRAP   iapiType.BomQuantity_Type,
      BOMLEVEL                      iapiType.BomLevel_Type,
      ACCESSSTOP                    iapiType.Boolean_Type,
      RECURSIVESTOP                 iapiType.Boolean_Type,
      USE                           iapiType.Boolean_Type,
      CHILDCOUNT                    iapiType.NumVal_Type
   );

   TYPE NutRefListRec_Type IS RECORD(
      PARTNO                        iapiType.PartNo_Type,
      REVISION                      iapiType.Revision_Type,
      REFTYPE                       iapiType.NutRefType_Type,
      NAME                          iapiType.Description_Type,
      NUTRBASICWEIGHTPG             iapiType.Id_Type,
      NUTRBASICWEIGHTPGID           iapiType.Id_Type,
      NUTRBASICWEIGHTPROPERTY       iapiType.Id_Type,
      NUTRBASICWEIGHTPROPERTYID     iapiType.Id_Type,
      NUTRBASICWEIGHTIDVALUE        iapiType.Id_Type,
      NUTRSECTSUBSECT               iapiType.Id_Type,
      SECTION                       iapiType.Id_Type,
      SUBSECTION                    iapiType.Id_Type,
      PROPERTYGROUP                 iapiType.Id_Type,
      PROPERTYGROUPID               iapiType.Id_Type,
      HEADERID                      iapiType.Id_Type,
      NUTRNOTEID                    iapiType.Id_Type,
      NUTRROUNDINGSECTSUBSECT       iapiType.Id_Type,
      NUTRROUNDINGSECTION           iapiType.Id_Type,
      NUTRROUNDINGSUBSECTION        iapiType.Id_Type,
      NUTRROUNDINGPG                iapiType.Id_Type,
      NUTRROUNDINGPGID              iapiType.Id_Type,
      NUTRROUNDINGVALUEID           iapiType.Id_Type,
      NUTRROUNDINGRDAID             iapiType.Id_Type,
      NUTRENERGYSECTSUBSECT         iapiType.Id_Type,
      NUTRENERGYSECTION             iapiType.Id_Type,
      NUTRENERGYSUBSECTION          iapiType.Id_Type,
      NUTRENERGYPG                  iapiType.Id_Type,
      NUTRENERGYPGID                iapiType.Id_Type,
      NUTRENERGYPROPERTYKCAL        iapiType.Id_Type,
      NUTRENERGYPROPERTYKCALID      iapiType.Id_Type,
      NUTRENERGYPROPERTYKJ          iapiType.Id_Type,
      NUTRENERGYPROPERTYKJID        iapiType.Id_Type,
      NUTRENERGYATTRIBUTEKCAL       iapiType.Id_Type,
      NUTRENERGYATTRIBUTEKCALID     iapiType.Id_Type,
      NUTRENERGYATTRIBUTEKJ         iapiType.Id_Type,
      NUTRENERGYATTRIBUTEKJID       iapiType.Id_Type,
      NUTRENERGYKCALVALUEID         iapiType.Id_Type,
      NUTRENERGYKJVALUEID           iapiType.Id_Type,
      NUTRSERVINGSECTSUBSECT        iapiType.Id_Type,
      NUTRSERVINGSECTION            iapiType.Id_Type,
      NUTRSERVINGSUBSECTION         iapiType.Id_Type,
      NUTRSERVINGPG                 iapiType.Id_Type,
      NUTRSERVINGPGID               iapiType.Id_Type,
      NUTRSERVINGVALUE              iapiType.Id_Type
   );

   TYPE NutResultDetailRec_Type IS RECORD(
      COLID                         iapiType.Id_Type,
      HEADER                        iapiType.Description_Type,
      ROW_ID                        iapiType.Id_Type,
      DATATYPE                      iapiType.Boolean_Type,
      DISPLAYNAME                   iapiType.Description_Type,
      DESCRIPTION                   iapiType.Description_Type,
      CALCQTY                       iapiType.BomQuantity_Type,
      TEXT                          iapitype.SqlString_Type,
      VALUE                         iapiType.Description_Type
   );

   TYPE NutResultRec_Type IS RECORD(
      ROW_ID                        iapiType.Id_Type,
      PROPERTYID                    iapiType.Id_Type,
      PROPERTYREVISION              iapiType.Revision_Type,
      PROPERTY                      iapiType.String_Type,
      ATTRIBUTEID                   iapiType.Id_Type,
      ATTRIBUTEREVISION             iapiType.Revision_Type,
      ATTRIBUTE                     iapiType.String_Type
   );

   TYPE NutServSizesRec_Type IS RECORD(
      PROPERTY                      iapiType.Id_Type,
      BOOLEAN1                      iapiType.PropertyBoolean_Type,
      NUMERICVALUE                  iapiType.NumVal_Type,
      DESCRIPTION                   iapiType.Description_Type
   );

   TYPE NutXmlRec_Type IS RECORD(
      Property                      iapiType.Sequence_Type,
      PropertyRevision              iapiType.Revision_Type,
      ATTRIBUTE                     iapiType.Sequence_Type,
      AttributeRevision             iapiType.Revision_Type,
      Numeric1                      iapiType.Float_Type,
      Numeric2                      iapiType.Float_Type,
      Numeric3                      iapiType.Float_Type,
      Numeric4                      iapiType.Float_Type,
      Numeric5                      iapiType.Float_Type,
      Numeric6                      iapiType.Float_Type,
      Numeric7                      iapiType.Float_Type,
      Numeric8                      iapiType.Float_Type,
      Numeric9                      iapiType.Float_Type,
      Numeric10                     iapiType.Float_Type,
      Date1                         iapiType.Date_Type,
      Date2                         iapiType.Date_Type,
      String1                       iapiType.PropertyShortString_Type,
      String2                       iapiType.PropertyShortString_Type,
      String3                       iapiType.PropertyShortString_Type,
      String4                       iapiType.PropertyShortString_Type,
      String5                       iapiType.PropertyShortString_Type,
      String6                       iapiType.PropertyLongString_Type,
      Boolean1                      iapiType.Boolean_Type,
      Boolean2                      iapiType.Boolean_Type,
      Boolean3                      iapiType.Boolean_Type,
      Boolean4                      iapiType.Boolean_Type,
      Info                          iapiType.Clob_Type
   );

   TYPE ObjectRec_Type IS RECORD(
      OBJECTID                      iapiType.Id_Type,
      OBJECTOWNER                   iapiType.Owner_Type,
      KEYWORDID                     iapiType.Id_Type,
      KEYWORD                       iapiType.Description_Type,
      KEYWORDVALUE                  iapiType.Description_Type,
      KEYWORDTYPE                   iapiType.Keyword_Type,
      INTERNATIONAL                 iapiType.Boolean_Type
   );

   TYPE OrphanedItemsRec_Type IS RECORD(
      PartNo                        iapiType.PartNo_Type,
      Revision                      iapiType.Revision_Type,
      Description                   iapiType.Description_Type
   );

   TYPE PartKeywordListRec_Type IS RECORD(
      PARTNO                        iapiType.PartNo_Type,
      KEYWORDID                     iapiType.Id_Type,
      NAME                          iapiType.Description_Type,
      VALUE                         iapiType.Description_Type,
      KEYWORDTYPE                   iapiType.Boolean_Type,
      INTERNATIONAL                 iapiType.Intl_Type
   );

   TYPE PartManufacturerRec_Type IS RECORD(
      MANUFACTURERID                iapiType.Id_Type,
      MANUFACTURER                  iapiType.Description_Type,
      CLEARANCENUMBER               iapiType.ClearanceNumber_Type,
      TRADENAME                     iapiType.TradeName_Type,
      AUDITDATE                     iapiType.Date_Type,
      AUDITFREQUENCE                iapiType.AuditFrequence_Type,
      MANUFACTURERPLANTNO           iapiType.ManufacturerPlantNo_Type,
      INTERNATIONAL                 iapiType.Boolean_Type
   );

   TYPE PartMFCListRec_Type IS RECORD(
      PARTNO                        iapiType.PartNo_Type,
      MANUFACTURERID                iapiType.Id_Type,
      MANUFACTURER                  iapiType.Description_Type,
      MANUFACTURERPLANTNO           iapiType.Plant_Type,
      MANUFACTURERPLANT             iapiType.Description_Type,
      CLEARANCENUMBER               iapiType.ClearanceNumber_Type,
      TRADENAME                     iapiType.TradeName_Type,
      AUDITDATE                     iapiType.Date_Type,
      AUDITFREQUENCE                iapiType.AuditFrequence_Type,
      INTERNATIONAL                 iapiType.Intl_Type,
      MANUFACTURERTYPEID            iapiType.Id_Type,
      PRODUCTCODE                   iapiType.ProductCode_Type,
      APPROVALDATE                  iapiType.Date_Type,
      PARTMANUFACTURERREVISION      iapiType.Revision_Type,
      OBJECTID                      iapiType.Id_Type,
      OBJECTREVISION                iapiType.Revision_Type,
      OBJECTOWNER                   iapiType.Owner_Type,
      OBJECT                        iapiType.Description_Type
   );

   TYPE PartPlantListRec_Type IS RECORD(
      PARTNO                        iapiType.PartNo_Type,
      DESCRIPTION                   iapiType.Description_Type,
      PARTSOURCE                    iapiType.PartSource_Type,
      PLANTNO                       iapiType.Plant_Type,
      PLANTDESCRIPTION              iapiType.Description_Type,
      PLANTSOURCE                   iapiType.PlantSource_Type,
      COMPONENTSCRAP                iapiType.Scrap_Type,
      RELEVANCYTOCOSTING            iapiType.Boolean_Type,
      BULKMATERIAL                  iapiType.Boolean_Type,
      LEADTIMEOFFSET                iapiType.LeadTimeOffset_Type,
      ITEMCATEGORY                  iapiType.ItemCategory_Type,
      OBSOLETE                      iapiType.Boolean_Type,
      ISSUELOCATION                 iapiType.IssueLocation_Type,
      ISSUEUOM                      iapiType.IssueUom_Type,
      OPERATIONALSTEP               iapiType.OperationalStep_Type,
      COMPONENTSCRAPSYNC            iapiType.Boolean_Type
   );

   TYPE PartPriceListRec_Type IS RECORD(
      PARTNO                        iapiType.PartNo_Type,
      PERIOD                        iapiType.Period_Type,
      PRICETYPE                     iapiType.PriceType_Type,
      UOM                           iapiType.BaseUom_Type,
      PRICE                         iapiType.Price_Type,
      CURRENCY                      iapiType.Currency_Type,
      PLANTNO                       iapiType.Plant_Type
   );

   TYPE PartRec_Type IS RECORD(
      PARTNO                        iapiType.PartNo_Type,
      DESCRIPTION                   iapiType.Description_Type,
      BASEUOM                       iapiType.BaseUom_Type,
      PARTSOURCE                    iapiType.PartSource_Type,
      BASECONVFACTOR                iapiType.NumVal_Type,
      BASETOUNIT                    iapiType.BaseToUnit_Type,
      PARTTYPEID                    iapiType.Id_Type,
      DATEIMPORTED                  iapiType.Date_Type,
      EANUPCBARCODE                 iapiType.PartNo_Type,
      OBSOLETE                      iapiType.Boolean_Type,
      PARTTYPE                      iapiType.PartType_Type
   );

   TYPE PlannedEffectiveGroupRec_Type IS RECORD(
      PEDGROUPID                    ped_group.ped_group_id%TYPE,
      PEDGROUP                      ped_group.description%TYPE,
      PHASEINTOLERANCE              ped_group.pit%TYPE,
      PLANNEDEFFECTIVEDATE          ped_group.ped%TYPE,
      ACCESSGROUPID                 ped_group.access_group%TYPE,
      ACCESSGROUP                   access_group.description%TYPE
   );

   TYPE PlantGroupRec_Type IS RECORD(
      PLANTGROUP                    iapiType.PlantGroup_Type,
      DESCRIPTION                   iapiType.Description_Type
   );

   TYPE PlantRec_Type IS RECORD(
      PLANTNO                       iapiType.PlantNo_Type,
      PLANTDESCRIPTION              iapiType.Description_Type,
      PLANTSOURCE                   iapiType.PlantSource_Type
   );

   TYPE PrBomItemListRec_Type IS RECORD(
      COMPONENTPARTNO               iapiType.PartNo_Type,
      QUANTITY                      iapiType.BomQuantity_Type,
      UOM                           iapiType.BaseUom_Type,
      CONVERSIONFACTOR              iapiType.BomConvFactor_Type,
      TOUNIT                        iapiType.BaseToUnit_Type,
      PLANT                         iapiType.Plant_Type,
      ALTERNATIVE                   iapiType.BomAlternative_Type,
      BOMUSAGEID                    iapiType.BomUsage_Type,
      DESCRIPTION                   iapiType.Description_Type
   );

   TYPE PriceListRec_Type IS RECORD(
      PRICETYPE                     iapiType.PriceType_Type,
      PERIOD                        iapiType.Period_Type
   );

   TYPE PriceTypeRec_Type IS RECORD(
      PRICETYPE                     iapiType.PriceType_Type,
      PERIOD                        iapiType.Period_Type
   );

   TYPE PrLineRec_Type IS RECORD(
      PARTNO                        iapiType.PartNo_Type,
      PLANTNO                       iapiType.PlantNo_Type,
      LINE                          iapiType.Line_Type,
      CONFIGURATION                 iapiType.Configuration_Type,
      LINEREVISION                  iapiType.Revision_Type,
      DESCRIPTION                   iapiType.Description_Type,
      ROWINDEX                      iapiType.NumVal_Type
   );

   TYPE PropAttrRec_Type IS RECORD(
      PROPERTY                      iapiType.Description_Type,
      ASSOCIATION                   iapiType.Description_Type,
      UOM                           iapiType.Description_Type,
      ATTRIBUTE                     iapiType.Description_Type,
      INCLUDED                      iapiType.Boolean_Type,
      STAGEID                       iapiType.StageId_Type,
      PROPERTYID                    iapiType.Id_Type,
      UOMID                         iapiType.Id_Type,
      ASSOCIATIONID                 iapiType.Id_Type,
      ATTRIBUTEID                   iapiType.Id_Type,
      PROPERTYREVISION              iapiType.Revision_Type,
      ATTRIBUTEREVISION             iapiType.Revision_Type,
      ASSOCIATIONREVISION1          iapiType.Revision_Type,
      UOMREVISION                   iapiType.Revision_Type,
      SEQUENCE                      iapiType.NumVal_type
   );

   TYPE PropertyGroupRec_Type IS RECORD(
      PROPERTYGROUP                 iapiType.Id_Type,
      INTERNATIONAL                 iapiType.Boolean_Type,
      DESCRIPTION                   iapiType.Description_Type
   );

   TYPE PropertyRec_Type IS RECORD(
      PROPERTYID                    iapiType.Id_Type,
      PROPERTY                      iapiType.Description_Type,
      INTERNATIONAL                 iapiType.Boolean_Type,
      HISTORIC                      iapiType.Boolean_Type
   );

   TYPE RuleSetRec_Type IS RECORD(
      RULEID                        iapiType.Id_Type,
      NAME                          iapiType.Description_Type,
      DESCRIPTION                   iapiType.Description_Type,
      CREATEDON                     iapiType.Date_Type,
      RULETYPE                      iapiType.Id_Type,
      RULESET                       iapiType.Clob_Type
   );

   TYPE SessionRec_Type IS RECORD(
      SETTINGS                      iapiType.SessionSettingsRec_Type,
      DATABASE                      iapiType.DatabaseRec_Type,
      ApplicationUser               iapiType.ApplicationUserRec_Type,
      LicenseVersion                iapiType.LicenseVersion_Type
   );

   TYPE SessionSettingsRec_Type IS RECORD(
      International                 BOOLEAN,
      Metric                        BOOLEAN,
      LanguageId                    iapiType.Id_Type,
      AlternativeLanguageId         iapiType.Id_Type
   );

   TYPE SpAttachedSpecItemRec_Type IS RECORD(
      PARTNO                        iapiType.PartNo_Type,
      REVISION                      iapiType.Revision_Type,
      SECTIONID                     iapiType.Id_Type,
      SUBSECTIONID                  iapiType.Id_Type,
      ITEMID                        iapiType.Id_Type,
      ATTACHEDPARTNO                iapiType.PartNo_Type,
      ATTACHEDREVISION              iapiType.Revision_Type,
      INTERNATIONAL                 iapiType.Boolean_Type,
      ATTACHEDDESCRIPTION           iapiType.Description_Type,
      STATUSID                      iapiType.Id_Type,
      STATUSNAME                    iapiType.ShortDescription_Type,
      ATTACHEDPHANTOM               iapiType.Boolean_Type,
      SPECIFICATIONACCESS           iapiType.Boolean_Type,
      STATUSTYPE                    iapiType.StatusType_Type,
      ROWINDEX                      iapiType.NumVal_Type
   );

   TYPE SpAttachedSpecRec_Type IS RECORD(
      PARTNO                        iapiType.PartNo_Type,
      REVISION                      iapiType.Revision_Type,
      SECTIONID                     iapiType.Id_Type,
      SECTIONREVISION               iapiType.Revision_Type,
      SUBSECTIONID                  iapiType.Id_Type,
      SUBSECTIONREVISION            iapiType.Revision_Type,
      ITEMID                        iapiType.Id_Type,
      SECTIONSEQUENCENUMBER         iapiType.SpSectionSequenceNumber_Type
   );

   TYPE SpBaseNameRec_Type IS RECORD(
      PARTNO                        iapiType.PartNo_Type,
      REVISION                      iapiType.Revision_Type,
      SECTIONID                     iapiType.Id_Type,
      SECTIONREVISION               iapiType.Revision_Type,
      SUBSECTIONID                  iapiType.Id_Type,
      SUBSECTIONREVISION            iapiType.Revision_Type,
      ITEMID                        iapiType.Id_Type,
      ITEMREVISION                  iapiType.Revision_Type,
      INGREDIENT                    iapiType.String_Type
   );

   TYPE SpChemicalListItemRec_Type IS RECORD(
      PARTNO                        iapiType.PartNo_Type,
      REVISION                      iapiType.Revision_Type,
      SECTIONID                     iapiType.Id_Type,
      SUBSECTIONID                  iapiType.Id_Type,
      INGREDIENTID                  iapiType.Id_Type,
      INGREDIENTREVISION            iapiType.Revision_Type,
      INGREDIENTQUANTITY            iapiType.IngredientQuantity_Type,
      INGREDIENTLEVEL               iapiType.IngredientLevel_Type,
      INGREDIENTCOMMENT             iapiType.IngredientComment_Type,
      INTERNATIONAL                 iapiType.Boolean_Type,
      SEQUENCE                      iapiType.IngredientSequenceNumber_Type,
      ACTIVEINGREDIENT              iapiType.Boolean_Type,
      SYNONYMID                     iapiType.Id_Type,
      SYNONYMREVISION               iapiType.Revision_Type,
      ALTERNATIVELANGUAGEID         iapiType.LanguageId_Type,
      ALTERNATIVELEVEL              iapiType.IngredientLevel_Type,
      ALTERNATIVECOMMENT            iapiType.IngredientComment_Type,
      INGREDIENT                    iapiType.String_Type,
      SYNONYMNAME                   iapiType.String_Type,
      TRANSLATED                    iapiType.Boolean_Type,
      DECLAREFLAG                   iapiType.Boolean_Type,
      ROWINDEX                      iapiType.NumVal_Type
   );

   TYPE SpClaimspropertyRec_Type IS RECORD(
      PartNo                        iapiType.PartNo_Type,
      Revision                      iapiType.Revision_Type,
      PropertyGroup                 iapiType.Sequence_Type,
      PropertyGroup_rev             iapiType.Revision_Type,
      Property                      iapiType.Sequence_Type,
      Property_rev                  iapiType.Revision_Type,
      ATTRIBUTE                     iapiType.Sequence_Type,
      AttributeRev                  iapiType.Revision_Type,
      Num1                          iapiType.Float_Type,
      Num2                          iapiType.Float_Type,
      Num3                          iapiType.Float_Type,
      Num4                          iapiType.Float_Type,
      Num5                          iapiType.Float_Type,
      Num6                          iapiType.Float_Type,
      Num7                          iapiType.Float_Type,
      Num8                          iapiType.Float_Type,
      Num9                          iapiType.Float_Type,
      Num10                         iapiType.Float_Type,
      Char1                         iapiType.PropertyShortString_Type,
      Char2                         iapiType.PropertyShortString_Type,
      Char3                         iapiType.PropertyShortString_Type,
      Char4                         iapiType.PropertyShortString_Type,
      Char5                         iapiType.PropertyShortString_Type,
      Char6                         iapiType.PropertyLongString_Type,
      Info                          iapiType.Clob_Type,
      Boolean1                      iapiType.Boolean_Type,
      Boolean2                      iapiType.Boolean_Type,
      Boolean3                      iapiType.Boolean_Type,
      Boolean4                      iapiType.Boolean_Type,
      Date1                         iapiType.Date_Type,
      Date2                         iapiType.Date_Type,
      Characteristic1               iapiType.Id_Type,
      CharacteristicRev1            iapiType.Revision_Type,
      Characteristic2               iapiType.Id_Type,
      CharacteristicRev2            iapiType.Revision_Type,
      Characteristic                iapiType.Id_Type,
      CharacteristicRev3            iapiType.Revision_Type,
      Association1                  iapiType.Id_Type,
      AssociationRev1               iapiType.Revision_Type,
      Association2                  iapiType.Id_Type,
      AssociationRev2               iapiType.Revision_Type,
      Association3                  iapiType.Id_Type,
      AssociationRev3               iapiType.Revision_Type,
      TestMethod                    iapiType.Id_Type,
      TestMethodRev                 iapiType.Revision_Type,
      PropertyGroupType             iapiType.Boolean_Type
   );

   TYPE SpCopySpecRec_Type IS RECORD(
      FromPartNo                    iapiType.PartNo_Type,
      FromRevision                  iapiType.Revision_Type,
      PartNo                        iapiType.PartNo_Type,
      FrameId                       iapiType.FrameNo_Type,
      FrameRevision                 iapiType.FrameRevision_Type,
      FrameOwner                    iapiType.Owner_Type,
      WorkFlowGroupId               iapiType.Id_Type,
      AccessGroupId                 iapiType.Id_Type,
      SpecTypeId                    iapiType.Id_Type,
      Ped                           iapiType.Date_Type,
      NewRevision                   iapiType.Revision_Type,
      MultiLanguage                 iapiType.Boolean_Type,
      UomType                       iapiType.Boolean_Type,
      MaskId                        iapiType.Id_Type,
      Description                   iapiType.Description_Type,
      InternationalLinked           iapiType.Boolean_Type
   );

   TYPE SpCreateSpecRec_Type IS RECORD(
      PartNo                        iapiType.PartNo_Type,
      PartNoFrom                    iapiType.PartNo_Type,
      Revision                      iapiType.Revision_Type,
      Description                   iapiType.Description_Type,
      CreatedBy                     iapiType.UserId_Type,
      PlannedEffective              iapitype.Date_Type,
      FrameID                       iapiType.FrameNo_Type,
      FrameRev                      iapiType.FrameRevision_Type,
      FrameOwner                    iapiType.Owner_Type,
      Class3Id                      iapiType.Id_Type,
      WorkflowGroupId               iapiType.Id_Type,
      AccessGroup                   iapiType.Id_Type,
      Multilang                     iapiType.Boolean_Type,
      UomType                       iapiType.Boolean_Type,
      MaskID                        iapiType.Id_Type
   );

   TYPE SpecificationHeaderRec_Type IS RECORD(
      PartNo                        iapiType.PartNo_Type,
      Revision                      iapiType.Revision_Type,
      Status                        iapiType.StatusId_Type,
      Description                   iapiType.Description_Type,
      PhaseInDate                   iapiType.Date_Type,
      PlannedEffectiveDate          iapiType.Date_Type,
      IssuedDate                    iapiType.Date_Type,
      ObsolescenceDate              iapiType.Date_Type,
      ChangedDate                   iapiType.Date_Type,
      StatusChangedDate             iapiType.Date_Type,
      PhaseInTolerance              iapiType.PhaseinTolerance_Type,
      CreatedBy                     iapiType.UserId_Type,
      CreatedOn                     iapiType.Date_Type,
      LastModifiedBy                iapiType.UserId_Type,
      LastModifiedOn                iapiType.Date_Type,
      FrameNo                       iapiType.FrameNo_Type,
      FrameRevision                 iapiType.FrameRevision_Type,
      AccessGroupId                 iapiType.Id_Type,
      WorkflowGroupId               iapiType.Id_Type,
      SpecificationTypeId           iapiType.Id_Type,
      Owner                         iapiType.Id_Type,
      InternationalFrameNo          iapiType.FrameNo_Type,
      InternationalFrameRevision    iapiType.FrameRevision_Type,
      InternationalPartNo           iapiType.PartNo_Type,
      InternationalPartRevision     iapiType.Revision_Type,
      FrameOwner                    iapiType.Id_Type,
      International                 iapiType.Boolean_Type,
      MultiLanguage                 iapiType.Boolean_Type,
      NonMetric                     iapiType.Boolean_Type,
      MaskId                        iapiType.Id_Type,
      PlannedEffectiveDateInSync    iapiType.Boolean_Type
   );

   TYPE SpecKeywordRec_Type IS RECORD(
      PARTNO                        iapiType.PartNo_Type,
      KEYWORDID                     iapiType.Id_Type,
      NAME                          iapiType.Description_Type,
      VALUE                         iapiType.Description_Type,
      KEYWORDTYPE                   iapiType.Keyword_Type,
      INTERNATIONAL                 iapiType.Boolean_Type
   );

   TYPE SpFreeTextRec_Type IS RECORD(
      PARTNO                        iapiType.PartNo_Type,
      REVISION                      iapiType.Revision_Type,
      SECTIONID                     iapiType.Id_Type,
      SECTIONREVISION               iapiType.Revision_Type,
      SUBSECTIONID                  iapiType.Id_Type,
      SUBSECTIONREVISION            iapiType.Revision_Type,
      ITEMID                        iapiType.Id_Type,
      ITEMREVISION                  iapiType.Revision_Type,
      ITEMDESCRIPTION               iapiType.Description_Type,
      TEXT                          iapiType.Clob_Type,
      LANGUAGEID                    iapiType.LanguageId_Type,
      INCLUDED                      iapiType.Boolean_Type
   );

   TYPE SpGetAttSpecItemRec_Type IS RECORD(
      PARTNO                        iapiType.PartNo_Type,
      REVISION                      iapiType.Revision_Type,
      SECTIONID                     iapiType.Id_Type,
      SUBSECTIONID                  iapiType.Id_Type,
      ITEMID                        iapiType.Id_Type,
      ATTACHEDPARTNO                iapiType.PartNo_Type,
      ATTACHEDREVISION              iapiType.Revision_Type,
      INTERNATIONAL                 iapiType.Boolean_Type,
      ATTACHEDDESCRIPTION           iapiType.Description_Type,
      STATUSID                      iapiType.Id_Type,
      STATUSNAME                    iapiType.ShortDescription_Type,
      ATTACHEDPHANTOM               iapiType.Boolean_Type,
      SPECIFICATIONACCESS           iapiType.Boolean_Type,
      STATUSTYPE                    iapiType.StatusType_Type,
      OWNER                         iapiType.Owner_Type,
      --AP00847482 Start
      ATTACHEDREVISIONPHANTOM       iapiType.Revision_Type,
      --AP00847482 End
      ROWINDEX                      iapiType.NumVal_Type
   );

   TYPE SpIngredientListItemRec_Type IS RECORD(
      PARTNO                        iapiType.PartNo_Type,
      REVISION                      iapiType.Revision_Type,
      SECTIONID                     iapiType.Id_Type,
      SUBSECTIONID                  iapiType.Id_Type,
      INGREDIENTID                  iapiType.Id_Type,
      INGREDIENTREVISION            iapiType.Revision_Type,
      INGREDIENTQUANTITY            iapiType.IngredientQuantity_Type,
      INGREDIENTLEVEL               iapiType.IngredientLevel_Type,
      INGREDIENTCOMMENT             iapiType.IngredientComment_Type,
      INTERNATIONAL                 iapiType.Boolean_Type,
      SEQUENCE                      iapiType.IngredientSequenceNumber_Type,
      PARENTID                      iapiType.Id_Type,
      HIERARCHICALLEVEL             iapiType.IngredientHierarchicLevel_Type,
      RECONSTITUTIONFACTOR          iapiType.ReconstitutionFactor_Type,
      SYNONYMID                     iapiType.Id_Type,
      SYNONYMREVISION               iapiType.Revision_Type,
      ALTERNATIVELANGUAGEID         iapiType.LanguageId_Type,
      ALTERNATIVELEVEL              iapiType.IngredientLevel_Type,
      ALTERNATIVECOMMENT            iapiType.IngredientComment_Type,
      INGREDIENT                    iapiType.String_Type,  --should be desc type?
      SYNONYMNAME                   iapiType.String_Type,  --should be desc type?
      TRANSLATED                    iapiType.Boolean_Type,
      DECLAREFLAG                   iapiType.Boolean_Type,
      ROWINDEX                      iapiType.NumVal_Type
   );

   --AP00892453 --AP00888937 Start
   TYPE SpIngredientListItemRecPb_Type IS RECORD(
      PARTNO                        iapiType.PartNo_Type,
      REVISION                      iapiType.Revision_Type,
      SECTIONID                     iapiType.Id_Type,
      SUBSECTIONID                  iapiType.Id_Type,
      INGREDIENTID                  iapiType.Id_Type,
      INGREDIENTREVISION            iapiType.Revision_Type,
      INGREDIENTQUANTITY            iapiType.IngredientQuantity_Type,
      INGREDIENTLEVEL               iapiType.IngredientLevel_Type,
      INGREDIENTCOMMENT             iapiType.IngredientComment_Type,
      INTERNATIONAL                 iapiType.Boolean_Type,
      SEQUENCE                      iapiType.IngredientSequenceNumber_Type,
      PARENTID                      iapiType.Id_Type,
      HIERARCHICALLEVEL             iapiType.IngredientHierarchicLevel_Type,
      RECONSTITUTIONFACTOR          iapiType.ReconstitutionFactor_Type,
      SYNONYMID                     iapiType.Id_Type,
      SYNONYMREVISION               iapiType.Revision_Type,
      ALTERNATIVELANGUAGEID         iapiType.LanguageId_Type,
      ALTERNATIVELEVEL              iapiType.IngredientLevel_Type,
      ALTERNATIVECOMMENT            iapiType.IngredientComment_Type,
      INGREDIENT                    iapiType.String_Type,
      SYNONYMNAME                   iapiType.String_Type,
      TRANSLATED                    iapiType.Boolean_Type,
      DECLAREFLAG                   iapiType.Boolean_Type,
      --AP00892453 --AP00888937 Start
      PIDLIST                       VARCHAR2( 2048 ),
      --AP00892453 --AP00888937 End
      ROWINDEX                      iapiType.NumVal_Type
   );
   --AP00892453 --AP00888937 End

--ISQF194 start
   TYPE SpIngCharRec_Type IS RECORD(
      CHARACTERISTICID              iapiType.Id_Type,
      DESCRIPTION                   iapitype.Description_Type,
      PARTNO                        iapiType.PartNo_Type,
      REVISION                      iapiType.Revision_Type,
      SECTIONID                     iapiType.Id_Type,
      SUBSECTIONID                  iapiType.Id_Type,
      INGREDIENT                    iapiType.Id_Type,
      INGREDIENTSEQNO               iapitype.Sequence_Type,
      INGDETAILTYPE                 iapitype.Id_Type,
      MANDATORY                     iapitype.Mandatory_Type
   );
--ISQF194 end

   TYPE SpIngredientListRec_Type IS RECORD(
      PARTNO                        iapiType.PartNo_Type,
      REVISION                      iapiType.Revision_Type,
      SECTIONID                     iapiType.Id_Type,
      SECTIONREVISION               iapiType.Revision_Type,
      SUBSECTIONID                  iapiType.Id_Type,
      SUBSECTIONREVISION            iapiType.Revision_Type,
      ITEMID                        iapiType.Id_Type,
      SECTIONSEQUENCENUMBER         iapiType.SpSectionSequenceNumber_Type
   );

   --ING_SUPPORT Start
   TYPE SpIngredientAllergenRec_Type IS RECORD(
      PARTNO                        iapiType.PartNo_Type,
      REVISION                      iapiType.Revision_Type,
      SECTIONID                     iapiType.Id_Type,
      SUBSECTIONID                  iapiType.Id_Type,
      INGREDIENTID                  iapiType.Id_Type,
      ALLERGENID                    iapiType.Id_Type
   );
   --ING_SUPPORT End
   TYPE SpObjectRec_Type IS RECORD(
      PARTNO                        iapiType.PartNo_Type,
      REVISION                      iapiType.Revision_Type,
      SECTIONID                     iapiType.Id_Type,
      SECTIONREVISION               iapiType.Revision_Type,
      SUBSECTIONID                  iapiType.Id_Type,
      SUBSECTIONREVISION            iapiType.Revision_Type,
      ITEMID                        iapiType.Id_Type,
      ITEMREVISION                  iapiType.Revision_Type,
      ITEMOWNER                     iapiType.Owner_Type,
      SECTIONSEQUENCENUMBER         iapiType.SpSectionSequenceNumber_Type
   );

   TYPE SpPdLineRec_Type IS RECORD(
      PARTNO                        iapiType.PartNo_Type,
      REVISION                      iapiType.Revision_Type,
      PLANTNO                       iapiType.PlantNo_Type,
      LINE                          iapiType.Line_Type,
      CONFIGURATION                 iapiType.Configuration_Type,
      ITEMPARTNO                    iapiType.PartNo_Type,
      ITEMREVISION                  iapiType.Revision_Type,
      SEQUENCE                      iapiType.SequenceNr_Type,
      ROWINDEX                      iapiType.NumVal_Type
   );

   TYPE SpPdStageDataRec_Type IS RECORD(
      PARTNO                        iapiType.PartNo_Type,
      REVISION                      iapiType.Revision_Type,
      SECTIONID                     iapiType.Id_Type,
      SECTIONREVISION               iapiType.Revision_Type,
      SUBSECTIONID                  iapiType.Id_Type,
      SUBSECTIONREVISION            iapiType.Revision_Type,
      STAGEID                       iapiType.StageId_Type,
      PROPERTYID                    iapiType.Id_Type,
      PROPERTYREVISION              iapiType.Revision_Type,
      PROPERTY                      iapiType.Description_Type,
      ATTRIBUTEID                   iapiType.Id_Type,
      ATTRIBUTEREVISION             iapiType.Revision_Type,
      ATTRIBUTE                     iapiType.Description_Type,
      TESTMETHODID                  iapiType.Id_Type,
      TESTMETHODREVISION            iapiType.Revision_Type,
      TESTMETHOD                    iapiType.Description_Type,
      STRING1                       iapiType.PropertyShortString_Type,
      STRING2                       iapiType.PropertyShortString_Type,
      STRING3                       iapiType.PropertyShortString_Type,
      STRING4                       iapiType.PropertyShortString_Type,
      STRING5                       iapiType.PropertyShortString_Type,
      STRING6                       iapiType.PropertyLongString_Type,
      BOOLEAN1                      iapiType.Boolean_Type,
      BOOLEAN2                      iapiType.Boolean_Type,
      BOOLEAN3                      iapiType.Boolean_Type,
      BOOLEAN4                      iapiType.Boolean_Type,
      DATE1                         iapiType.Date_Type,
      DATE2                         iapiType.Date_Type,
      CHARACTERISTICID1             iapiType.Id_Type,
      CHARACTERISTICREVISION1       iapiType.Revision_Type,
      CHARACTERISTICDESCRIPTION1    iapiType.Description_Type,
      NUMERIC1                      iapiType.Float_Type,
      NUMERIC2                      iapiType.Float_Type,
      NUMERIC3                      iapiType.Float_Type,
      NUMERIC4                      iapiType.Float_Type,
      NUMERIC5                      iapiType.Float_Type,
      NUMERIC6                      iapiType.Float_Type,
      NUMERIC7                      iapiType.Float_Type,
      NUMERIC8                      iapiType.Float_Type,
      NUMERIC9                      iapiType.Float_Type,
      NUMERIC10                     iapiType.Float_Type,
      ASSOCIATIONID1                iapiType.Id_Type,
      ASSOCIATIONREVISION1          iapiType.Revision_Type,
      INTERNATIONAL                 iapiType.Intl_Type,
      UPPERLIMIT                    iapiType.NumVal_Type,
      LOWERLIMIT                    iapiType.NumVal_Type,
      UOMID                         iapiType.Id_Type,
      UOMREVISION                   iapiType.Revision_Type,
      UOM                           iapiType.Description_Type,
      STAGE                         iapiType.Description_Type,
      PLANTNO                       iapiType.PlantNo_Type,
      CONFIGURATION                 iapiType.Configuration_Type,
      LINEREVISION                  iapiType.Revision_Type,
      LINE                          iapiType.Line_Type,
      TEXT                          iapiType.String_Type,
      SEQUENCE                      iapiType.LinePropSequence_Type,
      VALUETYPE                     iapiType.ValueType_Type,
      COMPONENTPARTNO               iapiType.PartNo_Type,
      ITEMDESCRIPTION               iapiType.Description_Type,
      STAGEREVISION                 iapiType.Revision_Type,
      --AP00978035 Start
--      QUANTITY                      iapiType.Quantity_Type, --orig
--      QUANTITYBOMPCT                iapiType.Quantity_Type, --orig
      QUANTITY                      iapiType.BomQuantity_Type,
      QUANTITYBOMPCT                iapiType.BomQuantity_Type,
      --AP00978035 End
      UOMBOMPCT                     iapiType.Description_Type,
      BOMALTERNATIVE                iapiType.BomAlternative_Type,
      BOMUSAGEID                    iapiType.BomUsageId_Type,
      ALTERNATIVELANGUAGEID         iapiType.LanguageId_Type,
      ALTERNATIVESTRING1            iapiType.PropertyShortString_Type,
      ALTERNATIVESTRING2            iapiType.PropertyShortString_Type,
      ALTERNATIVESTRING3            iapiType.PropertyShortString_Type,
      ALTERNATIVESTRING4            iapiType.PropertyShortString_Type,
      ALTERNATIVESTRING5            iapiType.PropertyShortString_Type,
      ALTERNATIVESTRING6            iapiType.PropertyLongString_Type,
      ALTERNATIVETEXT               iapiType.String_Type,
      TRANSLATED                    iapiType.Boolean_Type,
      ROWINDEX                      iapiType.NumVal_Type
   );

   TYPE SpPdStageFreeTextRec_Type IS RECORD(
      PARTNO                        iapiType.PartNo_Type,
      REVISION                      iapiType.Revision_Type,
      PLANTNO                       iapiType.PlantNo_Type,
      LINE                          iapiType.Line_Type,
      CONFIGURATION                 iapiType.Configuration_Type,
      STAGEID                       iapiType.StageId_Type,
      FREETEXTID                    iapiType.Id_Type,
      ITEMDESCRIPTION               iapiType.Description_Type,
      TEXT                          iapiType.Clob_Type,
      ALTERNATIVELANGUAGEID         iapiType.LanguageId_Type,
      ROWINDEX                      iapiType.NumVal_Type
   );

   TYPE SpPdStageRec_Type IS RECORD(
      PARTNO                        iapiType.PartNo_Type,
      REVISION                      iapiType.Revision_Type,
      PLANTNO                       iapiType.PlantNo_Type,
      LINE                          iapiType.Line_Type,
      CONFIGURATION                 iapiType.Configuration_Type,
      LINEREVISION                  iapiType.Revision_Type,
      STAGEID                       iapiType.StageId_Type,
      STAGE                         iapiType.Description_Type,
      SEQUENCE                      iapiType.StageSequence_Type,
      RECIRCULATETO                 iapiType.StageSequence_Type,
      FREETEXTID                    iapiType.Id_Type,
      DISPLAYFORMATID               iapiType.Id_Type,
      DISPLAYFORMATREVISION         iapiType.Revision_Type,
      ROWINDEX                      iapiType.NumVal_Type
   );

   TYPE SpPropertyGroupRec_Type IS RECORD(
      PARTNO                        iapiType.PartNo_Type,
      REVISION                      iapiType.Revision_Type,
      SECTIONID                     iapiType.Id_Type,
      SECTIONREVISION               iapiType.Revision_Type,
      SUBSECTIONID                  iapiType.Id_Type,
      SUBSECTIONREVISION            iapiType.Revision_Type,
      ITEMID                        iapiType.Id_Type,
      ITEMREVISION                  iapiType.Revision_Type,
      DISPLAYFORMATID               iapiType.Id_Type,
      DISPLAYFORMATREVISION         iapiType.Revision_Type,
      SECTIONSEQUENCENUMBER         iapiType.SpSectionSequenceNumber_Type,
      ATTRIBUTEID                   iapiType.Id_Type
   );

   TYPE SpPropertyRec_Type IS RECORD(
      PARTNO                        iapiType.PartNo_Type,
      REVISION                      iapiType.Revision_Type,
      SECTIONID                     iapiType.Id_Type,
      SECTIONREVISION               iapiType.Revision_Type,
      SUBSECTIONID                  iapiType.Id_Type,
      SUBSECTIONREVISION            iapiType.Revision_Type,
      PROPERTYGROUPID               iapiType.Id_Type,
      PROPERTYGROUPREVISION         iapiType.Revision_Type,
      PROPERTYGROUP                 iapiType.Description_Type,
      PROPERTYID                    iapiType.Id_Type,
      PROPERTYREVISION              iapiType.Revision_Type,
      PROPERTY                      iapiType.Description_Type,
      ATTRIBUTEID                   iapiType.Id_Type,
      ATTRIBUTEREVISION             iapiType.Revision_Type,
      ATTRIBUTE                     iapiType.Description_Type,
      DISPLAYFORMATID               iapiType.Id_Type,
      TESTMETHODID                  iapiType.Id_Type,
      TESTMETHODREVISION            iapiType.Revision_Type,
      TESTMETHOD                    iapiType.Description_Type,
      STRING1                       iapiType.PropertyShortString_Type,
      STRING2                       iapiType.PropertyShortString_Type,
      STRING3                       iapiType.PropertyShortString_Type,
      STRING4                       iapiType.PropertyShortString_Type,
      STRING5                       iapiType.PropertyShortString_Type,
      STRING6                       iapiType.PropertyLongString_Type,
      BOOLEAN1                      iapiType.Boolean_Type,
      BOOLEAN2                      iapiType.Boolean_Type,
      BOOLEAN3                      iapiType.Boolean_Type,
      BOOLEAN4                      iapiType.Boolean_Type,
      DATE1                         iapiType.Date_Type,
      DATE2                         iapiType.Date_Type,
      CHARACTERISTICID1             iapiType.Id_Type,
      CHARACTERISTICREVISION1       iapiType.Revision_Type,
      CHARACTERISTICDESCRIPTION1    iapiType.Description_Type,
      CHARACTERISTICID2             iapiType.Id_Type,
      CHARACTERISTICREVISION2       iapiType.Revision_Type,
      CHARACTERISTICDESCRIPTION2    iapiType.Description_Type,
      CHARACTERISTICID3             iapiType.Id_Type,
      CHARACTERISTICREVISION3       iapiType.Revision_Type,
      CHARACTERISTICDESCRIPTION3    iapiType.Description_Type,
      TESTMETHODSETNO               iapiType.TestMethodSetNo_Type,
      METHODDETAIL                  VARCHAR2( 1 ),
      INFO                          iapiType.Info_Type,
      UOM                           iapiType.Description_Type,
      NUMERIC1                      iapiType.Float_Type,
      NUMERIC2                      iapiType.Float_Type,
      NUMERIC3                      iapiType.Float_Type,
      NUMERIC4                      iapiType.Float_Type,
      NUMERIC5                      iapiType.Float_Type,
      NUMERIC6                      iapiType.Float_Type,
      NUMERIC7                      iapiType.Float_Type,
      NUMERIC8                      iapiType.Float_Type,
      NUMERIC9                      iapiType.Float_Type,
      NUMERIC10                     iapiType.Float_Type,
      TESTMETHODDETAILS1            iapiType.Boolean_Type,
      TESTMETHODDETAILS2            iapiType.Boolean_Type,
      TESTMETHODDETAILS3            iapiType.Boolean_Type,
      TESTMETHODDETAILS4            iapiType.Boolean_Type,
      ALTERNATIVELANGUAGEID         iapiType.LanguageId_Type,
      ALTERNATIVESTRING1            iapiType.PropertyShortString_Type,
      ALTERNATIVESTRING2            iapiType.PropertyShortString_Type,
      ALTERNATIVESTRING3            iapiType.PropertyShortString_Type,
      ALTERNATIVESTRING4            iapiType.PropertyShortString_Type,
      ALTERNATIVESTRING5            iapiType.PropertyShortString_Type,
      ALTERNATIVESTRING6            iapiType.PropertyLongString_Type,
      ALTERNATIVEINFO               iapiType.Info_Type,
      UOMID                         iapiType.Id_Type,
      UOMREVISION                   iapiType.Revision_Type,
      ASSOCIATIONID1                iapiType.Id_Type,
      ASSOCIATIONREVISION1          iapiType.Revision_Type,
      ASSOCIATIONDESCRIPTION1       iapiType.Description_Type,
      ASSOCIATIONID2                iapiType.Id_Type,
      ASSOCIATIONREVISION2          iapiType.Revision_Type,
      ASSOCIATIONDESCRIPTION2       iapiType.Description_Type,
      ASSOCIATIONID3                iapiType.Id_Type,
      ASSOCIATIONREVISION3          iapiType.Revision_Type,
      ASSOCIATIONDESCRIPTION3       iapiType.Description_Type,
      INTERNATIONAL                 iapiType.Intl_Type,
      SEQUENCE                      iapiType.PropertySequenceNumber_Type,
      UPPERLIMIT                    iapiType.ErrorNum_Type,
      LOWERLIMIT                    iapiType.ErrorNum_Type,
      HASTESTMETHODCONDITION        iapiType.Boolean_Type,
      INCLUDED                      iapiType.Boolean_Type,
      OPTIONAL                      iapiType.Boolean_Type,
      EXTENDED                      iapiType.Boolean_Type,
      TRANSLATED                    iapiType.Boolean_Type,
      ROWINDEX                      iapiType.NumVal_Type,
      EDITABLE                      iapiType.Boolean_Type
   );

   TYPE SpReferenceTextRec_Type IS RECORD(
      PARTNO                        iapiType.PartNo_Type,
      REVISION                      iapiType.Revision_Type,
      SECTIONID                     iapiType.Id_Type,
      SECTIONREVISION               iapiType.Revision_Type,
      SUBSECTIONID                  iapiType.Id_Type,
      SUBSECTIONREVISION            iapiType.Revision_Type,
      ITEMID                        iapiType.Id_Type,
      ITEMREVISION                  iapiType.Revision_Type,
      ITEMOWNER                     iapiType.Owner_Type,
      TEXT                          iapiType.Clob_Type,
      LANGUAGEID                    iapiType.LanguageId_Type,
      DESCRIPTION                   iapiType.ReferenceTextTypeDescr_Type,
      INTERNATIONAL                 iapiType.Boolean_Type
   );

   TYPE SpSectionItemRec_Type IS RECORD(
      PARTNO                        iapiType.PartNo_Type,
      REVISION                      iapiType.Revision_Type,
      SECTIONID                     iapiType.Id_Type,
      SECTIONREVISION               iapiType.Revision_Type,
      SUBSECTIONID                  iapiType.Id_Type,
      SUBSECTIONREVISION            iapiType.Revision_Type,
      ITEMTYPE                      iapiType.SpecificationSectionType_Type,
      ITEMID                        iapiType.Id_Type,
      ITEMREVISION                  iapiType.Revision_Type,
      ITEMOWNER                     iapiType.Owner_Type,
      ITEMINFO                      iapiType.Id_Type,
      SEQUENCE                      iapiType.SpSectionSequenceNumber_Type,
      SECTIONSEQUENCENUMBER         iapiType.SpSectionSequenceNumber_Type,
      DISPLAYFORMATID               iapiType.Id_Type,
      DISPLAYFORMATREVISION         iapiType.Revision_Type,
      ASSOCIATIONID                 iapiType.Id_Type,
      INTERNATIONAL                 iapiType.Intl_Type,
      HEADER                        iapiType.Boolean_Type,
      OPTIONAL                      iapiType.Boolean_Type,
      EDITABLE                      iapiType.Boolean_Type,
      INCLUDED                      iapiType.Boolean_Type,
      EXTENDED                      iapiType.Boolean_Type,
      ISEXTENDABLE                  iapiType.Boolean_Type,
      ROWINDEX                      iapiType.NumVal_Type
   );

   TYPE SpSectionRec_Type IS RECORD(
      PartNo                        iapiType.PartNo_Type,
      Revision                      iapiType.Revision_Type,
      SectionId                     iapiType.Id_Type,
      SectionRevision               iapiType.Revision_Type,
      SubSectionId                  iapiType.Id_Type,
      SubSectionRevision            iapiType.Revision_Type,
      SEQUENCE                      iapiType.Sequence_Type,
      IsBomSection                  iapiType.Boolean_Type,
      IsProcessSection              iapiType.Boolean_Type,
      IsExtendable                  iapiType.Boolean_Type,
      EDITABLE                      iapiType.Boolean_Type,
      LOCKED                        iapiType.UserId_Type,
      VISIBLE                       iapiType.Boolean_Type,
      Included                      iapiType.Boolean_Type,
      SectionName                   iapiType.Name_Type,
      SubSectionName                iapiType.Name_Type,
      RowIndex                      iapiType.NumVal_Type,
      ParentRowIndex                iapiType.NumVal_Type
   );

   TYPE SpTestMethodRec_Type IS RECORD(
      PartNo                        iapiType.PartNo_Type,
      Revision                      iapiType.Revision_Type,
      SectionId                     iapiType.Id_Type,
      SubSectionId                  iapiType.Id_Type,
      PropertyGroupId               iapiType.Id_Type,
      PropertyId                    iapiType.Id_Type,
      AttributeId                   iapiType.Id_Type,
      SequenceNo                    iapiType.SequenceNr_Type,
      TestMethodTypeId              iapiType.Id_Type,
      TestMethodId                  iapiType.Id_Type,
      TestMethodRevision            iapiType.Revision_Type,
      TestMethodSetNo               iapiType.TestMethodSetNo_Type
   );

   TYPE StagePropListRec_Type IS RECORD(
      PROPERTYID                    iapiType.Id_Type,
      PROPERTY                      iapiType.Description_Type,
      INTERNATIONAL                 iapiType.Intl_Type,
      HISTORIC                      iapiType.Boolean_Type,
      ASSOCIATION                   iapiType.Description_Type,
      UOM                           iapiType.Description_Type,
      ATTRIBUTE                     iapiType.Description_Type,
      INCLUDED                      iapiType.Boolean_Type,
      STAGEID                       iapiType.Id_Type,
      UOMID                         iapiType.Id_Type,
      ASSOCIATIONID                 iapiType.Id_Type,
      ATTRIBUTEID                   iapiType.Id_Type,
      PROPERTYREVISION              iapiType.Revision_Type,
      ATTRIBUTEREVISION             iapiType.Revision_Type,
      ASSOCIATIONREVISION           iapiType.Revision_Type,
      UOMREVISION                   iapiType.Revision_Type,
      SEQUENCE                      iapiType.Sequence_Type
   );

   TYPE StageRec_Type IS RECORD(
      STAGEID                       iapiType.StageId_Type,
      TEXTTYPE                      iapiType.TextType_Type,
      DISPLAYFORMATID               iapiType.Id_Type,
      STAGE                         iapiType.Description_Type,
      INTERNATIONAL                 iapiType.Intl_Type,
      DISPLAYFORMATREVISION         iapiType.Revision_Type,
      ROWINDEX                      iapiType.NumVal_Type
   );

   TYPE StandardQRec_Type IS RECORD(
      STATUS                        iapiType.StatusId_Type,
      REVISION                      iapiType.Revision_Type,
      PARTNO                        iapiType.PartNo_Type,
      STATUSTO                      iapiType.StatusId_Type,
      TEXT                          iapiType.Buffer_Type,
      STATUSTYPE                    iapiType.StatusType_Type,
      CFACCESS                      iapiType.NumVal_Type,
      USERID                        iapiType.UserId_Type,
      ES_SEQ_NO                     iapiType.SequenceNr_Type,
      USER_INTL                     iapiType.Intl_Type,
      INTL                          iapiType.Intl_Type
   );

   TYPE StatusChangeRec_Type IS RECORD(
      STATUSID                      iapiType.StatusId_Type,
      REVISION                      iapiType.Revision_Type,
      PARTNO                        iapiType.PartNo_Type,
      NEXTSTATUSID                  iapiType.StatusId_Type,
      USERID                        iapiType.UserId_Type,
      ES_SEQ_NO                     iapiType.NumVal_Type
   );

   TYPE StatusRec_Type IS RECORD(
      STATUSID                      iapiType.StatusId_Type,
      STATUS                        iapiType.ShortDescription_Type,
      STATUSDESCRIPTION             iapiType.Description_Type,
      STATUSTYPE                    iapiType.StatusType_Type
   );

   TYPE SubSectionRec_Type IS RECORD(
      SUBSECTIONID                  iapiType.Id_Type,
      INTERNATIONAL                 iapiType.Boolean_Type,
      DESCRIPTION                   iapiType.Description_Type
   );

--start R-004ba46-732 Extension of multilanguage support -- translate <TableName>_L record

   TYPE TransGlosLRec_Type IS RECORD(
      PrimaryKey1                   iapiType.String_Type,
      PrimaryKey2                   iapiType.String_Type,
      TransValue                    iapiType.String_Type
   );

--end R-004ba46-732 Extension of multilanguage support

   ---------------------------------------------------------------------------
   -- Table definitions
   ---------------------------------------------------------------------------
   TYPE AttExplosionTab_Type IS TABLE OF AttExplosionRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE AttributeTab_Type IS TABLE OF AttributeRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE BomExplosionListTab_Type IS TABLE OF BomExplosionListRec_Type
      INDEX BY BINARY_INTEGER;

   --AP00793731 Start
   TYPE BomExplosionListTabExt_Type IS TABLE OF BomExplosionListRecExt_Type
      INDEX BY BINARY_INTEGER;
   --AP00793731 End

   TYPE BomHeaderCompareTab_Type IS TABLE OF BomHeaderCompareRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE BomHeaderTab_Type IS TABLE OF BomHeaderRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE BomImplosionListTab_Type IS TABLE OF BomImplosionListRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE BomItemTab_Type IS TABLE OF BomItemRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE BomJournalTab_Type IS TABLE OF BomJournalRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE BomMRPItemTab_Type IS TABLE OF BomMRPItemRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE BomPathHeaderListTab_Type IS TABLE OF BomPathHeaderListRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE BomPathListTab_Type IS TABLE OF BomPathListRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE BomPathTab_Type IS TABLE OF BomPathRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE CharTab_Type IS TABLE OF VARCHAR2( 80 )
      INDEX BY BINARY_INTEGER;

   TYPE ClaimExplosionTab_Type IS TABLE OF ClaimExplosion_Type
      INDEX BY BINARY_INTEGER;

   TYPE ClaimResultDetailsTab_Type IS TABLE OF ClaimResultDetailsRow_Type
      INDEX BY BINARY_INTEGER;

   TYPE ClaimsLogResultTab_Type IS TABLE OF ClaimsLogResultRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE ClaimsLogTab_Type IS TABLE OF ClaimsLogRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE CompBomHeaderTab_Type IS TABLE OF CompBomHeaderRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE CompBomItemsTab_Type IS TABLE OF CompBomItemsRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE DateTab_Type IS TABLE OF DATE
      INDEX BY BINARY_INTEGER;

   TYPE DeletedItemsPartPlantTab_Type IS TABLE OF DeletedItemsPartPlantRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE DeletedItemsPartTab_Type IS TABLE OF DeletedItemsPartRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE EmailToTab_Type IS TABLE OF EmailTo_Type
      INDEX BY BINARY_INTEGER;

   TYPE ErrorTab_Type IS TABLE OF ErrorRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE ExpResultBoughtSoldTab_Type IS TABLE OF ExpResultBoughtSoldRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE FileTab_Type IS TABLE OF File_Type
      INDEX BY BINARY_INTEGER;

   TYPE FilterTab_Type IS TABLE OF FilterRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE FoodClaimProfileTab_Type IS TABLE OF FoodClaimProfileRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE FoodClaimRunCdTab_Type IS TABLE OF FoodClaimRunCdRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE FoodClaimRunCritTab_Type IS TABLE OF FoodClaimRunCritRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE FoodClaimRunTab_Type IS TABLE OF FoodClaimRunRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE FoodClaimsConditionsTab_Type IS TABLE OF FoodClaimsConditionsRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE FoodClaimTab_Type IS TABLE OF FoodClaimRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE FrameSectionTab_Type IS TABLE OF FrameSectionRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE FrameTab_Type IS TABLE OF FrameRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE FreeTextTab_Type IS TABLE OF FreeTextRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE FrSectionItemTab_Type IS TABLE OF FrSectionItemRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE FrSectionTab_Type IS TABLE OF FrSectionRec_Type
      INDEX BY BINARY_INTEGER;

    --IS160
   TYPE GetBomItemTab_Type IS TABLE OF GetBomItemRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE GetStageDataTab_Type IS TABLE OF GetStageDataRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE HdrTab_Type IS TABLE OF HdrRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE HeaderListTab_Type IS TABLE OF HeaderListRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE HeaderTab_Type IS TABLE OF HeaderRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE ImplosionResultTab_Type IS TABLE OF ImplosionResultRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE ImportLogTab_Type IS TABLE OF ImportLogRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE InfoTab_Type IS TABLE OF InfoRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE IngGroupLevelTab_Type IS TABLE OF IngGroupLevelRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE IngGroupsTab_Type IS TABLE OF IngGroupsRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE IngListTab_Type IS TABLE OF IngListRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE IngNotesTab_Type IS TABLE OF IngNotesRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE IngredientTab_Type IS TABLE OF IngredientRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE IntegerTab_Type IS TABLE OF INTEGER
      INDEX BY BINARY_INTEGER;

   TYPE KeywordTab_Type IS TABLE OF KeywordRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE LabelLogResDetTab_Type IS TABLE OF LabelLogResDetRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE LabelLogTab_Type IS TABLE OF LabelLogRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE LocationTab_Type IS TABLE OF LocationRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE ManufacturerPlantTab_Type IS TABLE OF ManufacturerPlantRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE ManufacturerTab_Type IS TABLE OF ManufacturerRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE ManufacturerTypeTab_Type IS TABLE OF ManufacturerTypeRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE MopRpvSectionDataTab_Type IS TABLE OF MopRpvSectionDataRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE NumberTab_Type IS TABLE OF NUMBER
      INDEX BY BINARY_INTEGER;

   TYPE NutColTab_Type IS TABLE OF NutColRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE NutEnergyFactorTab_Type IS TABLE OF NutEnergyFactorRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE NutFilterDetailsTab_Type IS TABLE OF NutFilterDetailsRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE NutFilterDetailTab_Type IS TABLE OF NutFilterDetailRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE NutFilterListTab_Type IS TABLE OF NutFilterListRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE NutFilterTab_Type IS TABLE OF NutFilterRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE NutLogResultDetailTab_Type IS TABLE OF NutLogResultDetailRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE NutLogResultTab_Type IS TABLE OF NutLogResultRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE NutLogTab_Type IS TABLE OF NutLogRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE NutLyItemsTab_Type IS TABLE OF NutLyItemsRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE NutLyTab_Type IS TABLE OF NutLyRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE NutPanelListTab_Type IS TABLE OF NutPanelListRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE NutPathTab_Type IS TABLE OF NutPathRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE NutResultDetailTab_Type IS TABLE OF NutResultDetailRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE NutResultTab_Type IS TABLE OF NutResultRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE NutXmlTab_Type IS TABLE OF NutXmlRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE ObjectTab_Type IS TABLE OF ObjectRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE OperatorsTab_type IS TABLE OF INTEGER
      INDEX BY BINARY_INTEGER;

   TYPE OrphanedItemsTab_Type IS TABLE OF OrphanedItemsRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE PartMFCListTab_Type IS TABLE OF PartMFCListRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE PartNoTab_Type IS TABLE OF iapiType.PartNo_Type
      INDEX BY BINARY_INTEGER;

   TYPE PartPlantListTab_Type IS TABLE OF PartPlantListRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE PartPriceListTab_Type IS TABLE OF PartPriceListRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE PartTab_Type IS TABLE OF PartRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE PlannedEffectiveGroupTab_Type IS TABLE OF PlannedEffectiveGroupRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE PlantGroupTab_Type IS TABLE OF PlantGroupRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE PlantTab_Type IS TABLE OF PlantRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE PriceTypeTab_Type IS TABLE OF PriceTypeRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE PrLineTab_Type IS TABLE OF PrLineRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE PropAttrTab_Type IS TABLE OF PropAttrRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE PropertyGroupTab_Type IS TABLE OF PropertyGroupRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE PropertyTab_Type IS TABLE OF PropertyRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE RevisionTab_Type IS TABLE OF iapiType.Revision_Type
      INDEX BY BINARY_INTEGER;

   TYPE RuleSetTab_Type IS TABLE OF RuleSetRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE SpAttachedSpecItemTab_Type IS TABLE OF SpAttachedSpecItemRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE SpAttachedSpecTab_Type IS TABLE OF SpAttachedSpecRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE SpBaseNameTab_Type IS TABLE OF SpBaseNameRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE SpChemicalListItemTab_Type IS TABLE OF SpChemicalListItemRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE SpClaimspropertyTab_Type IS TABLE OF SpClaimspropertyRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE SpCopySpecTab_Type IS TABLE OF SpCopySpecRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE SpCreateSpecTab_Type IS TABLE OF SpCreateSpecRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE SpecKeywordTab_Type IS TABLE OF SpecKeywordRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE SpFreeTextTab_Type IS TABLE OF SpFreeTextRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE SpGetAttSpecItemTab_Type IS TABLE OF SpGetAttSpecItemRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE SpIngredientListItemTab_Type IS TABLE OF SpIngredientListItemRec_Type
      INDEX BY BINARY_INTEGER;

   --AP00892453 --AP00888937 Start
   TYPE SpIngredientListItemTabPb_Type IS TABLE OF SpIngredientListItemRecPb_Type
      INDEX BY BINARY_INTEGER;
   --AP00892453 --AP00888937 End

-- ISQF194 start
   TYPE SpIngCharTab_Type IS TABLE OF SpIngCharRec_Type
      INDEX BY BINARY_INTEGER;
-- ISQF194 end

   TYPE SpIngredientListTab_Type IS TABLE OF SpIngredientListRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE SpObjectTab_Type IS TABLE OF SpObjectRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE SpPdLineTab_Type IS TABLE OF SpPdLineRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE SpPdStageDataTab_Type IS TABLE OF SpPdStageDataRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE SpPdStageFreeTextTab_Type IS TABLE OF SpPdStageFreeTextRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE SpPdStageTab_Type IS TABLE OF SpPdStageRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE SpPropertyGroupTab_Type IS TABLE OF SpPropertyGroupRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE SpPropertyTab_Type IS TABLE OF SpPropertyRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE SpReferenceTextTab_Type IS TABLE OF SpReferenceTextRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE SpSectionItemTab_Type IS TABLE OF SpSectionItemRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE SpSectionTab_Type IS TABLE OF SpSectionRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE SpTestMethodTab_Type IS TABLE OF SpTestMethodRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE StageTab_Type IS TABLE OF StageRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE StandardQTab_Type IS TABLE OF StandardQRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE StatusChangeTab_Type IS TABLE OF StatusChangeRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE StatusTab_Type IS TABLE OF StatusRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE StringTab_Type IS TABLE OF VARCHAR2( 8 )
      INDEX BY BINARY_INTEGER;

   TYPE SubSectionTab_Type IS TABLE OF SubSectionRec_Type
      INDEX BY BINARY_INTEGER;

   TYPE TokensTab_type IS TABLE OF VARCHAR2( 255 )
      INDEX BY BINARY_INTEGER;

--start R-004ba46-732 Extension of multilanguage support translate <TableName>_L

   TYPE TransGlosL_Type IS TABLE OF TransGlosLRec_Type
      INDEX BY BINARY_INTEGER;


  TYPE VC30_TABLE_TYPE  IS TABLE OF VARCHAR2(30)
     INDEX BY BINARY_INTEGER;

--end R-004ba46-732 Extension of multilanguage support

   ---------------------------------------------------------------------------
   -- Ref.cursor definitions
   ---------------------------------------------------------------------------
   TYPE BomHeaderRef_Type IS REF CURSOR
      RETURN iapiType.BomHeaderRec_Type;

   TYPE BomItemRef_Type IS REF CURSOR
      RETURN iapiType.BomItemRec_Type;

   TYPE BomJournalRef_Type IS REF CURSOR
      RETURN iapiType.BomJournalRec_Type;

   TYPE OrphanedItemsRef_Type IS REF CURSOR
      RETURN iapiType.OrphanedItemsRec_Type;

   TYPE PartRef_Type IS REF CURSOR
      RETURN iapiType.PartRec_Type;

   TYPE Ref_Type IS REF CURSOR;

   TYPE SpSectionRef_Type IS REF CURSOR
      RETURN iapiType.SpSectionRec_Type;

   TYPE SpTestMethodRef_Type IS REF CURSOR
      RETURN iapiType.SpTestMethodRec_Type;
END iapiType;
--------------------------------------------------------
--  File created - Monday-October-26-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for View IVACCESS_GROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."IVACCESS_GROUP" ("ACCESS_GROUP", "SORT_DESC", "DESCRIPTION") AS 
  select
 access_group,
 F_AC_Descr(access_group) Sort_Desc,
 F_AG_Descr(access_group) description
from access_group;
--------------------------------------------------------
--  DDL for View IVADDON
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."IVADDON" ("ADDON_ID", "NAME", "DESCRIPTION", "CLASS", "DOMAIN", "ADDONTYPE", "ASSEMBLY", "STARTURL", "STARTPARAM") AS 
  select
  addon_id,
  name,
  F_Get_AddonDesc(addon_id) description,
  class,
  domain,
  addontype,
  assembly,
  starturl,
  startparam
from ITAddon;
--------------------------------------------------------
--  DDL for View IVATTACHED_SPECIFICATION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."IVATTACHED_SPECIFICATION" ("PART_NO", "REVISION", "REF_ID", "ATTACHED_PART_NO", "ATTACHED_REVISION", "SECTION_ID", "SUB_SECTION_ID", "INTL") AS 
  SELECT "PART_NO",
          "REVISION",
          "REF_ID",
          "ATTACHED_PART_NO",
          "ATTACHED_REVISION",
          "SECTION_ID",
          "SUB_SECTION_ID",
          "INTL"
     FROM ATTACHED_SPECIFICATION
    WHERE f_check_access( part_no,
                          revision ) = 1
 ;
--------------------------------------------------------
--  DDL for View IVBOM_HEADER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."IVBOM_HEADER" ("PART_NO", "REVISION", "PLANT", "ALTERNATIVE", "BASE_QUANTITY", "DESCRIPTION", "YIELD", "CONV_FACTOR", "TO_UNIT", "CALC_FLAG", "BOM_TYPE", "BOM_USAGE", "MIN_QTY", "MAX_QTY", "PLANT_EFFECTIVE_DATE", "PREFERRED") AS 
  SELECT "PART_NO",
          "REVISION",
          "PLANT",
          "ALTERNATIVE",
          "BASE_QUANTITY",
          "DESCRIPTION",
          "YIELD",
          "CONV_FACTOR",
          "TO_UNIT",
          "CALC_FLAG",
          "BOM_TYPE",
          "BOM_USAGE",
          "MIN_QTY",
          "MAX_QTY",
          "PLANT_EFFECTIVE_DATE",
          "PREFERRED"
     FROM BOM_HEADER
    WHERE f_check_access( part_no,
                          revision ) = 1
      AND f_check_view_bom = 1
	  AND f_check_plant( plant ) = 1
 ;
--------------------------------------------------------
--  DDL for View IVBOM_ITEM
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."IVBOM_ITEM" ("PART_NO", "REVISION", "PLANT", "ALTERNATIVE", "ITEM_NUMBER", "COMPONENT_PART", "COMPONENT_REVISION", "COMPONENT_PLANT", "QUANTITY", "UOM", "CONV_FACTOR", "TO_UNIT", "YIELD", "ASSEMBLY_SCRAP", "COMPONENT_SCRAP", "LEAD_TIME_OFFSET", "ITEM_CATEGORY", "ISSUE_LOCATION", "CALC_FLAG", "BOM_ITEM_TYPE", "OPERATIONAL_STEP", "BOM_USAGE", "MIN_QTY", "MAX_QTY", "CHAR_1", "CHAR_2", "CODE", "ALT_GROUP", "ALT_PRIORITY", "NUM_1", "NUM_2", "NUM_3", "NUM_4", "NUM_5", "CHAR_3", "CHAR_4", "CHAR_5", "DATE_1", "DATE_2", "CH_1", "CH_REV_1", "CH_2", "CH_REV_2", "CH_3", "CH_REV_3", "RELEVENCY_TO_COSTING", "BULK_MATERIAL", "FIXED_QTY", "BOOLEAN_1", "BOOLEAN_2", "BOOLEAN_3", "BOOLEAN_4", "MAKE_UP", "INTL_EQUIVALENT", "COMPONENT_SCRAP_SYNC") AS 
  SELECT "PART_NO",
          "REVISION",
          "PLANT",
          "ALTERNATIVE",
          "ITEM_NUMBER",
          "COMPONENT_PART",
          "COMPONENT_REVISION",
          "COMPONENT_PLANT",
          "QUANTITY",
          "UOM",
          "CONV_FACTOR",
          "TO_UNIT",
          "YIELD",
          "ASSEMBLY_SCRAP",
          "COMPONENT_SCRAP",
          "LEAD_TIME_OFFSET",
          "ITEM_CATEGORY",
          "ISSUE_LOCATION",
          "CALC_FLAG",
          "BOM_ITEM_TYPE",
          "OPERATIONAL_STEP",
          "BOM_USAGE",
          "MIN_QTY",
          "MAX_QTY",
          "CHAR_1",
          "CHAR_2",
          "CODE",
          "ALT_GROUP",
          "ALT_PRIORITY",
          "NUM_1",
          "NUM_2",
          "NUM_3",
          "NUM_4",
          "NUM_5",
          "CHAR_3",
          "CHAR_4",
          "CHAR_5",
          "DATE_1",
          "DATE_2",
          "CH_1",
          "CH_REV_1",
          "CH_2",
          "CH_REV_2",
          "CH_3",
          "CH_REV_3",
          "RELEVENCY_TO_COSTING",
          "BULK_MATERIAL",
          "FIXED_QTY",
          "BOOLEAN_1",
          "BOOLEAN_2",
          "BOOLEAN_3",
          "BOOLEAN_4",
          "MAKE_UP",
          "INTL_EQUIVALENT",
          "COMPONENT_SCRAP_SYNC"
     FROM BOM_ITEM
    WHERE f_check_access( part_no,
                          revision ) = 1
      AND f_check_view_bom = 1
      AND f_check_plant( plant ) = 1
 ;
--------------------------------------------------------
--  DDL for View IVBOMEXPLOSION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."IVBOMEXPLOSION" ("PATH", "BOM_EXP_NO", "MOP_SEQUENCE_NO", "SEQUENCE_NO", "PSEQUENCE_NO", "RECURSIVE_STOP", "BOM_LEVEL", "COMPONENT_PART", "REV", "QTY", "CALC_QTY", "UOM", "TO_UNIT", "CONV_FACTOR", "PLANT") AS 
  (SELECT sys_connect_by_Path(Sequence_no,'/') Path,a."BOM_EXP_NO",a."MOP_SEQUENCE_NO",a."SEQUENCE_NO",a."PSEQUENCE_NO",a."RECURSIVE_STOP",a."BOM_LEVEL",a."COMPONENT_PART",a."REV",a."QTY",a."CALC_QTY",a."UOM",a."TO_UNIT",a."CONV_FACTOR",a."PLANT"  FROM
    (SELECT itexp1.BOM_EXP_NO , itexp1.MOP_SEQUENCE_NO,itexp1.sequence_no,PSequence_no,
        RECURSIVE_STOP,BOM_LEVEL, COMPONENT_PART ,COMPONENT_rEVISION Rev ,
        QTY ,calc_qty,uom,to_unit,conv_factor /*IS234*/, PLANT
        FROM itbomexplosion    itexp1 , itbomExpTemp
        WHERE itexp1.BOM_EXP_NO = to_number(sys_context( 'IACBOMEXP','BOM_EXP_NO'))
        AND  itexp1.MOP_SEQUENCE_NO      = to_number(sys_context( 'IACBOMEXP','MOP_SEQUENCE_NO'))
        AND  itbomExpTemp.BOM_EXP_NO = itexp1.BOM_EXP_NO
        AND  itbomExpTemp.MOP_SEQUENCE_NO = itexp1.MOP_SEQUENCE_NO
        AND  itbomExpTemp.SEQUENCE_NO = itexp1.SEQUENCE_NO) a
    START WITH PSequence_no IS NULL
    CONNECT BY PRIOR Sequence_no = PSequence_no);
--------------------------------------------------------
--  DDL for View IVCLASS3
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."IVCLASS3" ("CLASS", "SORT_DESC", "DESCRIPTION", "INTL", "TYPE", "STATUS") AS 
  select
   class,
   sort_desc,
   F_Class3_Description(class) description,
   intl,
   type,
   status
from class3;
--------------------------------------------------------
--  DDL for View IVITSHBN
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."IVITSHBN" ("PART_NO", "REVISION", "SECTION_ID", "SECTION_REV", "SUB_SECTION_ID", "SUB_SECTION_REV", "BASE_NAME_ID", "BASE_NAME_REV") AS 
  SELECT "PART_NO",
          "REVISION",
          "SECTION_ID",
          "SECTION_REV",
          "SUB_SECTION_ID",
          "SUB_SECTION_REV",
          "BASE_NAME_ID",
          "BASE_NAME_REV"
     FROM ITSHBN
    WHERE f_check_access( part_no,
                          revision ) = 1
 ;
--------------------------------------------------------
--  DDL for View IVITSHDESCR_L
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."IVITSHDESCR_L" ("PART_NO", "REVISION", "LANG_ID", "DESCRIPTION") AS 
  SELECT "PART_NO",
          "REVISION",
          "LANG_ID",
          "DESCRIPTION"
     FROM ITSHDESCR_L
    WHERE f_check_access( part_no,
                          revision ) = 1
 ;
--------------------------------------------------------
--  DDL for View IVITSHLNPROPLANG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."IVITSHLNPROPLANG" ("PART_NO", "REVISION", "PLANT", "LINE", "CONFIGURATION", "STAGE", "PROPERTY", "ATTRIBUTE", "SEQUENCE_NO", "CHAR_1", "CHAR_2", "CHAR_3", "CHAR_4", "CHAR_5", "CHAR_6", "TEXT", "LANG_ID") AS 
  SELECT "PART_NO",
          "REVISION",
          "PLANT",
          "LINE",
          "CONFIGURATION",
          "STAGE",
          "PROPERTY",
          "ATTRIBUTE",
          "SEQUENCE_NO",
          "CHAR_1",
          "CHAR_2",
          "CHAR_3",
          "CHAR_4",
          "CHAR_5",
          "CHAR_6",
          "TEXT",
          "LANG_ID"
     FROM ITSHLNPROPLANG
    WHERE f_check_access( part_no,
                          revision ) = 1
      AND f_check_plant( plant ) = 1
 ;
--------------------------------------------------------
--  DDL for View IVKW
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."IVKW" ("KW_ID", "DESCRIPTION", "KW_TYPE", "INTL", "STATUS", "KW_USAGE") AS 
  select
   kw_id,
   F_Get_KWDesc(kw_id) description,
   kw_type,
   intl,
   status,
   kw_usage
from ITKW;
--------------------------------------------------------
--  DDL for View IVKWCH
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."IVKWCH" ("CH_ID", "DESCRIPTION", "INTL", "STATUS") AS 
  select
   ch_id,
   F_Get_KWchDesc(ch_id) description,
   intl,
   status
from ITKWCH;
--------------------------------------------------------
--  DDL for View IVLIMSJOB
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."IVLIMSJOB" ("PLANT", "PART_NO", "REVISION", "DATE_READY", "DATE_PROCEED", "RESULT_PROCEED", "DATE_TRANSFERRED", "RESULT_TRANSFER", "TO_BE_TRANSFERRED", "DATE_LAST_UPDATED", "RESULT_LAST_UPDATE", "TO_BE_UPDATED", "OBSOLETE_UPDATED", "ATTACHED_PART_NO", "PRIORITY") AS 
  SELECT "PLANT","PART_NO","REVISION","DATE_READY","DATE_PROCEED","RESULT_PROCEED","DATE_TRANSFERRED","RESULT_TRANSFER","TO_BE_TRANSFERRED","DATE_LAST_UPDATED","RESULT_LAST_UPDATE","TO_BE_UPDATED","OBSOLETE_UPDATED","ATTACHED_PART_NO","PRIORITY"
     FROM itlimsjob
 ;
--------------------------------------------------------
--  DDL for View IVPART
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."IVPART" ("PART_NO", "DESCRIPTION", "BASE_UOM", "PART_SOURCE", "BASE_CONV_FACTOR", "BASE_TO_UNIT", "PART_TYPE", "DATE_IMPORTED", "CHANGED_DATE", "ALT_PART_NO", "OBSOLETE") AS 
  SELECT "PART_NO",
          "DESCRIPTION",
          "BASE_UOM",
          "PART_SOURCE",
          "BASE_CONV_FACTOR",
          "BASE_TO_UNIT",
          "PART_TYPE",
          "DATE_IMPORTED",
          "CHANGED_DATE",
          "ALT_PART_NO",
          "OBSOLETE"
     FROM PART A
    WHERE EXISTS( SELECT PART_NO
                   FROM PART_PLANT B
                  WHERE B.PART_NO = A.PART_NO
                    AND F_CHECK_PLANT( PLANT ) = 1 )
       OR F_CHECK_PLANT( '' ) = 1
 ;
--------------------------------------------------------
--  DDL for View IVPART_PLANT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."IVPART_PLANT" ("PART_NO", "PLANT", "ISSUE_UOM", "ASSEMBLY_SCRAP", "COMPONENT_SCRAP", "LEAD_TIME_OFFSET", "RELEVENCY_TO_COSTING", "BULK_MATERIAL", "ITEM_CATEGORY", "ISSUE_LOCATION", "DISCONTINUATION_INDICATOR", "DISCONTINUATION_DATE", "FOLLOW_ON_MATERIAL", "COMMODITY_CODE", "OPERATIONAL_STEP", "OBSOLETE", "PLANT_ACCESS", "COMPONENT_SCRAP_SYNC") AS 
  SELECT "PART_NO",
          "PLANT",
          "ISSUE_UOM",
          "ASSEMBLY_SCRAP",
          "COMPONENT_SCRAP",
          "LEAD_TIME_OFFSET",
          "RELEVENCY_TO_COSTING",
          "BULK_MATERIAL",
          "ITEM_CATEGORY",
          "ISSUE_LOCATION",
          "DISCONTINUATION_INDICATOR",
          "DISCONTINUATION_DATE",
          "FOLLOW_ON_MATERIAL",
          "COMMODITY_CODE",
          "OPERATIONAL_STEP",
          "OBSOLETE",
          "PLANT_ACCESS",
		  "COMPONENT_SCRAP_SYNC"
     FROM part_plant
    WHERE f_check_plant( plant ) = 1
 ;
--------------------------------------------------------
--  DDL for View IVPGPR
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."IVPGPR" ("PART_NO", "REVISION", "SECTION_ID", "SUB_SECTION_ID", "TYPE", "PROPERTY_GROUP", "DISPLAY_FORMAT", "DISPLAY_FORMAT_REV", "PROPERTY", "ATTRIBUTE", "TEST_METHOD", "PROPERTY_GROUP_REV", "SEQUENCE_NO") AS 
  SELECT sps.part_no, sps.revision, sps.section_id, sps.sub_section_id, sps.type, spp.property_group,
          sps.display_format, sps.display_format_rev, spp.property, spp.attribute, spp.test_method,
          sps.ref_ver property_group_rev, spp.sequence_no
     FROM specification_section sps, specification_prop spp
    WHERE sps.part_no        = spp.part_no
      AND sps.revision       = spp.revision
      AND sps.ref_id         = spp.property_group
      AND sps.section_id     = spp.section_id
      AND sps.sub_section_id = spp.sub_section_id
 ;
--------------------------------------------------------
--  DDL for View IVPLANT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."IVPLANT" ("PLANT", "DESCRIPTION", "PLANT_SOURCE") AS 
  SELECT "PLANT",
          "DESCRIPTION",
          "PLANT_SOURCE"
     FROM plant
    WHERE f_check_plant( plant ) = 1
 ;
--------------------------------------------------------
--  DDL for View IVREASON
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."IVREASON" ("ID", "PART_NO", "REVISION", "STATUS_TYPE", "TEXT") AS 
  SELECT "ID",
          "PART_NO",
          "REVISION",
          "STATUS_TYPE",
          "TEXT"
     FROM REASON
    WHERE f_check_access( part_no,
                          revision ) = 1
 ;
--------------------------------------------------------
--  DDL for View IVRNDTFWBBOMEXPLOSION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."IVRNDTFWBBOMEXPLOSION" ("BOM_EXP_NO", "MOP_SEQUENCE_NO", "SEQUENCE_NO", "RECURSIVE_STOP", "BOM_LEVEL", "COMPONENT_PART", "REV", "QTY", "CALC_QTY", "UOM", "TO_UNIT", "CONV_FACTOR", "PLANT") AS 
  (    SELECT
               a."BOM_EXP_NO",
               a."MOP_SEQUENCE_NO",
               a."SEQUENCE_NO",
               a."RECURSIVE_STOP",
               a."BOM_LEVEL",
               a."COMPONENT_PART",
               a."REV",
               a."QTY",
               a."CALC_QTY",
               a."UOM",
               a."TO_UNIT",
               a."CONV_FACTOR",
               a."PLANT"
          FROM (SELECT itexp1.BOM_EXP_NO,
                       itexp1.MOP_SEQUENCE_NO,
                       itexp1.sequence_no,
                       RECURSIVE_STOP,
                       BOM_LEVEL,
                       COMPONENT_PART,
                       COMPONENT_rEVISION Rev,
                       QTY,
                       calc_qty,
                       uom,
                       to_unit,
                       conv_factor,
                       PLANT  /*IS234*/
                   FROM RNDTFWBBOMEXPLOSION itexp1
                  ) a
    );
--------------------------------------------------------
--  DDL for View IVRNDTFWBINGREDIENTSNEW
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."IVRNDTFWBINGREDIENTSNEW" ("REQ_ID", "PART_NO", "REVISION", "INGREDIENT", "QUANTITY", "SEQ_NO", "PID", "HIER_LEVEL", "RECFAC", "ING_SYNONYM", "ACTIV_IND", "INGDECLARE") AS 
  SELECT REQ_ID,
           PARTNO PART_NO,
          REVISION,
          INGREDIENT,
          QUANTITY,
          SEQUENCE SEQ_NO,
          PARENTSEQUENCE PID,
          HIERARCHICALLEVEL HIER_LEVEL,
          RECONSTITUTIONFACTOR RECFAC,
          SYNONYMNAME ING_SYNONYM,
          ACTIVEINGREDIENT ACTIV_IND,
          DECLAREFLAG INGDECLARE
     FROM RNDTFWBINGREDIENTSNEW
    WHERE f_check_access (partno, revision) = 1;
--------------------------------------------------------
--  DDL for View IVSPECDATA
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."IVSPECDATA" ("PART_NO", "REVISION", "SECTION_ID", "SUB_SECTION_ID", "SEQUENCE_NO", "TYPE", "REF_ID", "REF_VER", "PROPERTY_GROUP", "PROPERTY", "ATTRIBUTE", "HEADER_ID", "VALUE", "VALUE_S", "UOM_ID", "TEST_METHOD", "CHARACTERISTIC", "ASSOCIATION", "REF_INFO", "INTL", "VALUE_TYPE", "VALUE_DT", "SECTION_REV", "SUB_SECTION_REV", "PROPERTY_GROUP_REV", "PROPERTY_REV", "ATTRIBUTE_REV", "UOM_REV", "TEST_METHOD_REV", "CHARACTERISTIC_REV", "ASSOCIATION_REV", "HEADER_REV", "REF_OWNER", "LANG_ID") AS 
  SELECT "PART_NO",
          "REVISION",
          "SECTION_ID",
          "SUB_SECTION_ID",
          "SEQUENCE_NO",
          "TYPE",
          "REF_ID",
          "REF_VER",
          "PROPERTY_GROUP",
          "PROPERTY",
          "ATTRIBUTE",
          "HEADER_ID",
          "VALUE",
          "VALUE_S",
          "UOM_ID",
          "TEST_METHOD",
          "CHARACTERISTIC",
          "ASSOCIATION",
          "REF_INFO",
          "INTL",
          "VALUE_TYPE",
          "VALUE_DT",
          "SECTION_REV",
          "SUB_SECTION_REV",
          "PROPERTY_GROUP_REV",
          "PROPERTY_REV",
          "ATTRIBUTE_REV",
          "UOM_REV",
          "TEST_METHOD_REV",
          "CHARACTERISTIC_REV",
          "ASSOCIATION_REV",
          "HEADER_REV",
          "REF_OWNER",
          "LANG_ID"
     FROM SPECDATA
    WHERE f_check_access( part_no,
                          revision ) = 1
 ;
--------------------------------------------------------
--  DDL for View IVSPECDATA_PROCESS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."IVSPECDATA_PROCESS" ("PART_NO", "REVISION", "SECTION_ID", "SECTION_REV", "SUB_SECTION_ID", "SUB_SECTION_REV", "SEQUENCE_NO", "TYPE", "PLANT", "LINE", "LINE_REV", "CONFIGURATION", "PROCESS_LINE_REV", "STAGE", "STAGE_REV", "PROPERTY", "PROPERTY_REV", "ATTRIBUTE", "ATTRIBUTE_REV", "HEADER_ID", "VALUE", "VALUE_S", "COMPONENT_PART", "QUANTITY", "UOM_ID", "UOM_REV", "TEST_METHOD", "TEST_METHOD_REV", "CHARACTERISTIC", "ASSOCIATION", "REF_INFO", "INTL", "VALUE_TYPE", "VALUE_DT", "CHARACTERISTIC_REV", "ASSOCIATION_REV", "HEADER_REV", "REF_OWNER", "UOM", "LANG_ID") AS 
  SELECT "PART_NO",
          "REVISION",
          "SECTION_ID",
          "SECTION_REV",
          "SUB_SECTION_ID",
          "SUB_SECTION_REV",
          "SEQUENCE_NO",
          "TYPE",
          "PLANT",
          "LINE",
          "LINE_REV",
          "CONFIGURATION",
          "PROCESS_LINE_REV",
          "STAGE",
          "STAGE_REV",
          "PROPERTY",
          "PROPERTY_REV",
          "ATTRIBUTE",
          "ATTRIBUTE_REV",
          "HEADER_ID",
          "VALUE",
          "VALUE_S",
          "COMPONENT_PART",
          "QUANTITY",
          "UOM_ID",
          "UOM_REV",
          "TEST_METHOD",
          "TEST_METHOD_REV",
          "CHARACTERISTIC",
          "ASSOCIATION",
          "REF_INFO",
          "INTL",
          "VALUE_TYPE",
          "VALUE_DT",
          "CHARACTERISTIC_REV",
          "ASSOCIATION_REV",
          "HEADER_REV",
          "REF_OWNER",
          "UOM",
          "LANG_ID"
     FROM SPECDATA_PROCESS
    WHERE f_check_access( part_no,
                          revision ) = 1
 ;
--------------------------------------------------------
--  DDL for View IVSPECIFICATION_CD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."IVSPECIFICATION_CD" ("PART_NO", "REVISION", "SECTION_ID", "SUB_SECTION_ID", "PROPERTY_GROUP", "PROPERTY", "ATTRIBUTE", "SEQ_NO", "CD", "CD_REV") AS 
  SELECT "PART_NO",
          "REVISION",
          "SECTION_ID",
          "SUB_SECTION_ID",
          "PROPERTY_GROUP",
          "PROPERTY",
          "ATTRIBUTE",
          "SEQ_NO",
          "CD",
          "CD_REV"
     FROM SPECIFICATION_CD
    WHERE f_check_access( part_no,
                          revision ) = 1
 ;
--------------------------------------------------------
--  DDL for View IVSPECIFICATION_HEADER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."IVSPECIFICATION_HEADER" ("PART_NO", "REVISION", "STATUS", "DESCRIPTION", "PLANNED_EFFECTIVE_DATE", "ISSUED_DATE", "OBSOLESCENCE_DATE", "STATUS_CHANGE_DATE", "PHASE_IN_TOLERANCE", "CREATED_BY", "CREATED_ON", "LAST_MODIFIED_BY", "LAST_MODIFIED_ON", "FRAME_ID", "FRAME_REV", "ACCESS_GROUP", "WORKFLOW_GROUP_ID", "CLASS3_ID", "OWNER", "INT_FRAME_NO", "INT_FRAME_REV", "INT_PART_NO", "INT_PART_REV", "FRAME_OWNER", "INTL", "MULTILANG", "UOM_TYPE", "MASK_ID", "PED_IN_SYNC", "LOCKED") AS 
  SELECT "PART_NO",
          "REVISION",
          "STATUS",
          "DESCRIPTION",
          "PLANNED_EFFECTIVE_DATE",
          "ISSUED_DATE",
          "OBSOLESCENCE_DATE",
          "STATUS_CHANGE_DATE",
          "PHASE_IN_TOLERANCE",
          "CREATED_BY",
          "CREATED_ON",
          "LAST_MODIFIED_BY",
          "LAST_MODIFIED_ON",
          "FRAME_ID",
          "FRAME_REV",
          "ACCESS_GROUP",
          "WORKFLOW_GROUP_ID",
          "CLASS3_ID",
          "OWNER",
          "INT_FRAME_NO",
          "INT_FRAME_REV",
          "INT_PART_NO",
          "INT_PART_REV",
          "FRAME_OWNER",
          "INTL",
          "MULTILANG",
          "UOM_TYPE",
          "MASK_ID",
          "PED_IN_SYNC",
          "LOCKED"
          --IS641 - TC_Cleaning
          --"LINKED_TO_TC",
          --"LAST_SAVED_TO_TC",
          --"TC_IN_PROGRESS"
     FROM SPECIFICATION_HEADER
    WHERE f_check_access( part_no,
                          revision ) = 1;
--------------------------------------------------------
--  DDL for View IVSPECIFICATION_ING
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."IVSPECIFICATION_ING" ("PART_NO", "REVISION", "SECTION_ID", "SUB_SECTION_ID", "INGREDIENT", "INGREDIENT_REV", "QUANTITY", "ING_LEVEL", "ING_COMMENT", "INTL", "SEQ_NO", "PID", "HIER_LEVEL", "RECFAC", "ING_SYNONYM", "ING_SYNONYM_REV", "ACTIV_IND", "INGDECLARE") AS 
  SELECT "PART_NO",
          "REVISION",
          "SECTION_ID",
          "SUB_SECTION_ID",
          "INGREDIENT",
          "INGREDIENT_REV",
          "QUANTITY",
          "ING_LEVEL",
          "ING_COMMENT",
          "INTL",
          "SEQ_NO",
          "PID",
          "HIER_LEVEL",
          "RECFAC",
          "ING_SYNONYM",
          "ING_SYNONYM_REV",
          "ACTIV_IND",
          "INGDECLARE"
     FROM SPECIFICATION_ING
    WHERE f_check_access( part_no,
                          revision ) = 1
 ;
--------------------------------------------------------
--  DDL for View IVSPECIFICATION_ING_LANG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."IVSPECIFICATION_ING_LANG" ("PART_NO", "REVISION", "SECTION_ID", "SUB_SECTION_ID", "INGREDIENT", "LANG_ID", "ING_LEVEL", "ING_COMMENT", "PID", "HIER_LEVEL", "SEQ_NO") AS 
  SELECT "PART_NO",
          "REVISION",
          "SECTION_ID",
          "SUB_SECTION_ID",
          "INGREDIENT",
          "LANG_ID",
          "ING_LEVEL",
          "ING_COMMENT",
          "PID",
          "HIER_LEVEL",
          "SEQ_NO"
     FROM SPECIFICATION_ING_LANG
    WHERE f_check_access( part_no,
                          revision ) = 1
 ;
--------------------------------------------------------
--  DDL for View IVSPECIFICATION_LINE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."IVSPECIFICATION_LINE" ("PART_NO", "REVISION", "PLANT", "LINE", "CONFIGURATION", "PROCESS_LINE_REV", "ITEM_PART_NO", "ITEM_REVISION", "SEQUENCE") AS 
  SELECT "PART_NO",
          "REVISION",
          "PLANT",
          "LINE",
          "CONFIGURATION",
          "PROCESS_LINE_REV",
          "ITEM_PART_NO",
          "ITEM_REVISION",
          "SEQUENCE"
     FROM specification_line
    WHERE f_check_access (part_no, revision) = 1;
--------------------------------------------------------
--  DDL for View IVSPECIFICATION_LINE_PROP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."IVSPECIFICATION_LINE_PROP" ("PART_NO", "REVISION", "SECTION_ID", "SECTION_REV", "SUB_SECTION_ID", "SUB_SECTION_REV", "PLANT", "LINE", "LINE_REV", "CONFIGURATION", "PROCESS_LINE_REV", "STAGE", "STAGE_REV", "PROPERTY", "PROPERTY_REV", "ATTRIBUTE", "ATTRIBUTE_REV", "UOM_ID", "UOM_REV", "TEST_METHOD", "TEST_METHOD_REV", "SEQUENCE_NO", "VALUE_TYPE", "NUM_1", "NUM_2", "NUM_3", "NUM_4", "NUM_5", "NUM_6", "NUM_7", "NUM_8", "NUM_9", "NUM_10", "CHAR_1", "CHAR_2", "CHAR_3", "CHAR_4", "CHAR_5", "CHAR_6", "TEXT", "BOOLEAN_1", "BOOLEAN_2", "BOOLEAN_3", "BOOLEAN_4", "DATE_1", "DATE_2", "CHARACTERISTIC", "CHARACTERISTIC_REV", "ASSOCIATION", "ASSOCIATION_REV", "INTL", "COMPONENT_PART", "QUANTITY", "UOM", "ALTERNATIVE", "BOM_USAGE") AS 
  SELECT "PART_NO",
          "REVISION",
          "SECTION_ID",
          "SECTION_REV",
          "SUB_SECTION_ID",
          "SUB_SECTION_REV",
          "PLANT",
          "LINE",
          "LINE_REV",
          "CONFIGURATION",
          "PROCESS_LINE_REV",
          "STAGE",
          "STAGE_REV",
          "PROPERTY",
          "PROPERTY_REV",
          "ATTRIBUTE",
          "ATTRIBUTE_REV",
          "UOM_ID",
          "UOM_REV",
          "TEST_METHOD",
          "TEST_METHOD_REV",
          "SEQUENCE_NO",
          "VALUE_TYPE",
          "NUM_1",
          "NUM_2",
          "NUM_3",
          "NUM_4",
          "NUM_5",
          "NUM_6",
          "NUM_7",
          "NUM_8",
          "NUM_9",
          "NUM_10",
          "CHAR_1",
          "CHAR_2",
          "CHAR_3",
          "CHAR_4",
          "CHAR_5",
          "CHAR_6",
          "TEXT",
          "BOOLEAN_1",
          "BOOLEAN_2",
          "BOOLEAN_3",
          "BOOLEAN_4",
          "DATE_1",
          "DATE_2",
          "CHARACTERISTIC",
          "CHARACTERISTIC_REV",
          "ASSOCIATION",
          "ASSOCIATION_REV",
          "INTL",
          "COMPONENT_PART",
          "QUANTITY",
          "UOM",
          "ALTERNATIVE",
          "BOM_USAGE"
     FROM SPECIFICATION_LINE_PROP
    WHERE f_check_access( part_no,
                          revision ) = 1
 ;
--------------------------------------------------------
--  DDL for View IVSPECIFICATION_LINE_TEXT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."IVSPECIFICATION_LINE_TEXT" ("PART_NO", "REVISION", "PLANT", "LINE", "CONFIGURATION", "TEXT_TYPE", "TEXT", "STAGE", "LANG_ID") AS 
  SELECT "PART_NO",
          "REVISION",
          "PLANT",
          "LINE",
          "CONFIGURATION",
          "TEXT_TYPE",
          "TEXT",
          "STAGE",
          "LANG_ID"
     FROM SPECIFICATION_LINE_TEXT
    WHERE f_check_access( part_no,
                          revision ) = 1
 ;
--------------------------------------------------------
--  DDL for View IVSPECIFICATION_PROP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."IVSPECIFICATION_PROP" ("PART_NO", "REVISION", "SECTION_ID", "SECTION_REV", "SUB_SECTION_ID", "SUB_SECTION_REV", "PROPERTY_GROUP", "PROPERTY_GROUP_REV", "PROPERTY", "PROPERTY_REV", "ATTRIBUTE", "ATTRIBUTE_REV", "UOM_ID", "UOM_REV", "TEST_METHOD", "TEST_METHOD_REV", "SEQUENCE_NO", "NUM_1", "NUM_2", "NUM_3", "NUM_4", "NUM_5", "NUM_6", "NUM_7", "NUM_8", "NUM_9", "NUM_10", "CHAR_1", "CHAR_2", "CHAR_3", "CHAR_4", "CHAR_5", "CHAR_6", "BOOLEAN_1", "BOOLEAN_2", "BOOLEAN_3", "BOOLEAN_4", "DATE_1", "DATE_2", "CHARACTERISTIC", "CHARACTERISTIC_REV", "ASSOCIATION", "ASSOCIATION_REV", "INTL", "INFO", "UOM_ALT_ID", "UOM_ALT_REV", "TM_DET_1", "TM_DET_2", "TM_DET_3", "TM_DET_4", "TM_SET_NO", "CH_2", "CH_REV_2", "CH_3", "CH_REV_3", "AS_2", "AS_REV_2", "AS_3", "AS_REV_3") AS 
  SELECT "PART_NO",
          "REVISION",
          "SECTION_ID",
          "SECTION_REV",
          "SUB_SECTION_ID",
          "SUB_SECTION_REV",
          "PROPERTY_GROUP",
          "PROPERTY_GROUP_REV",
          "PROPERTY",
          "PROPERTY_REV",
          "ATTRIBUTE",
          "ATTRIBUTE_REV",
          "UOM_ID",
          "UOM_REV",
          "TEST_METHOD",
          "TEST_METHOD_REV",
          "SEQUENCE_NO",
          "NUM_1",
          "NUM_2",
          "NUM_3",
          "NUM_4",
          "NUM_5",
          "NUM_6",
          "NUM_7",
          "NUM_8",
          "NUM_9",
          "NUM_10",
          "CHAR_1",
          "CHAR_2",
          "CHAR_3",
          "CHAR_4",
          "CHAR_5",
          "CHAR_6",
          "BOOLEAN_1",
          "BOOLEAN_2",
          "BOOLEAN_3",
          "BOOLEAN_4",
          "DATE_1",
          "DATE_2",
          "CHARACTERISTIC",
          "CHARACTERISTIC_REV",
          "ASSOCIATION",
          "ASSOCIATION_REV",
          "INTL",
          "INFO",
          "UOM_ALT_ID",
          "UOM_ALT_REV",
          "TM_DET_1",
          "TM_DET_2",
          "TM_DET_3",
          "TM_DET_4",
          "TM_SET_NO",
          "CH_2",
          "CH_REV_2",
          "CH_3",
          "CH_REV_3",
          "AS_2",
          "AS_REV_2",
          "AS_3",
          "AS_REV_3"
     FROM SPECIFICATION_PROP
    WHERE f_check_access( part_no,
                          revision ) = 1
 ;
--------------------------------------------------------
--  DDL for View IVSPECIFICATION_PROP_LANG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."IVSPECIFICATION_PROP_LANG" ("PART_NO", "REVISION", "SECTION_ID", "SUB_SECTION_ID", "PROPERTY_GROUP", "PROPERTY", "ATTRIBUTE", "LANG_ID", "SEQUENCE_NO", "CHAR_1", "CHAR_2", "CHAR_3", "CHAR_4", "CHAR_5", "CHAR_6", "INTL", "INFO") AS 
  SELECT "PART_NO",
          "REVISION",
          "SECTION_ID",
          "SUB_SECTION_ID",
          "PROPERTY_GROUP",
          "PROPERTY",
          "ATTRIBUTE",
          "LANG_ID",
          "SEQUENCE_NO",
          "CHAR_1",
          "CHAR_2",
          "CHAR_3",
          "CHAR_4",
          "CHAR_5",
          "CHAR_6",
          "INTL",
          "INFO"
     FROM SPECIFICATION_PROP_LANG
    WHERE f_check_access( part_no,
                          revision ) = 1
 ;
--------------------------------------------------------
--  DDL for View IVSPECIFICATION_SECTION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."IVSPECIFICATION_SECTION" ("PART_NO", "REVISION", "SECTION_ID", "SUB_SECTION_ID", "TYPE", "REF_ID", "REF_VER", "REF_INFO", "SEQUENCE_NO", "HEADER", "MANDATORY", "SECTION_SEQUENCE_NO", "DISPLAY_FORMAT", "ASSOCIATION", "INTL", "SECTION_REV", "SUB_SECTION_REV", "DISPLAY_FORMAT_REV", "REF_OWNER", "LOCKED") AS 
  SELECT "PART_NO",
          "REVISION",
          "SECTION_ID",
          "SUB_SECTION_ID",
          "TYPE",
          "REF_ID",
          "REF_VER",
          "REF_INFO",
          "SEQUENCE_NO",
          "HEADER",
          "MANDATORY",
          "SECTION_SEQUENCE_NO",
          "DISPLAY_FORMAT",
          "ASSOCIATION",
          "INTL",
          "SECTION_REV",
          "SUB_SECTION_REV",
          "DISPLAY_FORMAT_REV",
          "REF_OWNER",
          "LOCKED"
     FROM SPECIFICATION_SECTION
    WHERE f_check_access( part_no,
                          revision ) = 1
 ;
--------------------------------------------------------
--  DDL for View IVSPECIFICATION_STAGE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."IVSPECIFICATION_STAGE" ("PART_NO", "REVISION", "PLANT", "LINE", "CONFIGURATION", "PROCESS_LINE_REV", "STAGE", "SEQUENCE_NO", "RECIRCULATE_TO", "TEXT_TYPE", "DISPLAY_FORMAT", "DISPLAY_FORMAT_REV") AS 
  SELECT "PART_NO",
          "REVISION",
          "PLANT",
          "LINE",
          "CONFIGURATION",
          "PROCESS_LINE_REV",
          "STAGE",
          "SEQUENCE_NO",
          "RECIRCULATE_TO",
          "TEXT_TYPE",
          "DISPLAY_FORMAT",
          "DISPLAY_FORMAT_REV"
     FROM SPECIFICATION_STAGE
    WHERE f_check_access( part_no,
                          revision ) = 1
 ;
--------------------------------------------------------
--  DDL for View IVSPECIFICATION_TEXT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."IVSPECIFICATION_TEXT" ("PART_NO", "REVISION", "TEXT_TYPE", "TEXT", "SECTION_ID", "SECTION_REV", "SUB_SECTION_ID", "SUB_SECTION_REV", "TEXT_TYPE_REV", "LANG_ID") AS 
  SELECT "PART_NO",
          "REVISION",
          "TEXT_TYPE",
          "TEXT",
          "SECTION_ID",
          "SECTION_REV",
          "SUB_SECTION_ID",
          "SUB_SECTION_REV",
          "TEXT_TYPE_REV",
          "LANG_ID"
     FROM SPECIFICATION_TEXT
    WHERE f_check_access( part_no,
                          revision ) = 1
 ;
--------------------------------------------------------
--  DDL for View IVSPECIFICATION_TEXT_NORTF
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."IVSPECIFICATION_TEXT_NORTF" ("PART_NO", "REVISION", "TEXT_TYPE", "TEXT", "SECTION_ID", "SECTION_REV", "SUB_SECTION_ID", "SUB_SECTION_REV", "TEXT_TYPE_REV", "LANG_ID") AS 
  SELECT "PART_NO",
          "REVISION",
          "TEXT_TYPE",
          --"TEXT",
          --NVL(iapiRTF.RTFToText( TEXT ), TEXT) AS TEXT,
          NVL (iapiRTF.RTFToText (f_get_text_custom (TEXT)), TEXT) AS TEXT,
          "SECTION_ID",
          "SECTION_REV",
          "SUB_SECTION_ID",
          "SUB_SECTION_REV",
          "TEXT_TYPE_REV",
          "LANG_ID"
     FROM SPECIFICATION_TEXT
     WHERE f_check_access (part_no, revision) = 1;
--------------------------------------------------------
--  DDL for View IVSPECIFICATION_TM
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."IVSPECIFICATION_TM" ("PART_NO", "REVISION", "SECTION_ID", "SUB_SECTION_ID", "PROPERTY_GROUP", "PROPERTY", "ATTRIBUTE", "SEQ_NO", "TM_TYPE", "TM", "TM_REV", "TM_SET_NO") AS 
  SELECT "PART_NO",
          "REVISION",
          "SECTION_ID",
          "SUB_SECTION_ID",
          "PROPERTY_GROUP",
          "PROPERTY",
          "ATTRIBUTE",
          "SEQ_NO",
          "TM_TYPE",
          "TM",
          "TM_REV",
          "TM_SET_NO"
     FROM SPECIFICATION_TM
    WHERE f_check_access( part_no,
                          revision ) = 1
 ;
--------------------------------------------------------
--  DDL for View IVSTATUS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."IVSTATUS" ("STATUS", "SORT_DESC", "DESCRIPTION", "STATUS_TYPE", "PHASE_IN_STATUS", "EMAIL_TITLE", "PROMPT_FOR_REASON", "REASON_MANDATORY", "ES", "COLOR") AS 
  select
 status,
 F_SS_DESCR(Status) Sort_Desc,
 F_Get_StatusDesc(Status) description,
 status_type,
 phase_in_status,
 F_Get_StatusEmailTitle(status) email_title,
 prompt_for_reason,
 reason_mandatory,
 es,
 color
from STATUS;
--------------------------------------------------------
--  DDL for View IVUOM_UOM_GROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."IVUOM_UOM_GROUP" ("UOM_GROUP", "UOM_ID", "STATUS", "INTL", "UOM_BASE", "UOM_TYPE") AS 
  SELECT   uug.UOM_GROUP,
         uug.UOM_ID,
         u.STATUS,
         uug.INTL,
         u.UOM_BASE,
         u.UOM_TYPE
    FROM UOM_UOM_GROUP uug,
         UOM u
   WHERE uug.UOM_ID = u.UOM_ID
 ;
--------------------------------------------------------
--  DDL for View IVWORKFLOW_GROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."IVWORKFLOW_GROUP" ("WORKFLOW_GROUP_ID", "SORT_DESC", "DESCRIPTION", "WORK_FLOW_ID", "APPROVERS_NUMBER") AS 
  select
 workflow_group_id,
 F_Get_WorkflowGroupSortDesc(workflow_group_id) Sort_Desc,
 F_Get_WorkflowGroupDesc(workflow_group_id) description,
 work_flow_id,
 approvers_number
from workflow_group;
--------------------------------------------------------
--  DDL for View RMWSETTINGS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RMWSETTINGS" ("SERVER", "DATABASE", "USERNAME", "COMPANY", "IMAGEFOLDER", "VERSION") AS 
  SELECT max(vi.host_name) SERVER,
       max(UPPER ( vi.instance_name )) DATABASE,
       max(user) USERNAME,
       max(DECODE(rt.Setting,'Company' , rt.Value)) as Company,
       max(DECODE( rt.Setting , 'SourceFolder' , rt.Value )) as ImageFolder,
	   max(DECODE( rt.Setting , 'Version' , rt.Value )) as Version
  FROM v$instance vi, RMtSETTINGS rt

 ;
--------------------------------------------------------
--  DDL for View RPMV_ACCESS_GROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ACCESS_GROUP" ("ACCESS_GROUP", "SORT_DESC", "DESCRIPTION") AS 
  select "ACCESS_GROUP","SORT_DESC","DESCRIPTION" from ACCESS_GROUP
 ;
--------------------------------------------------------
--  DDL for View RPMV_AOPERFORMANCETABLE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_AOPERFORMANCETABLE" ("BOM_EXP_NO", "COMPONENT_PART", "DESCRIPTION", "REVISION", "PROPERTY", "PROPERTY_REV", "PROPERY_DESCR") AS 
  select "BOM_EXP_NO","COMPONENT_PART","DESCRIPTION","REVISION","PROPERTY","PROPERTY_REV","PROPERY_DESCR" from AOPERFORMANCETABLE
 ;
--------------------------------------------------------
--  DDL for View RPMV_APPLICATION_USER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_APPLICATION_USER" ("USER_ID", "FORENAME", "LAST_NAME", "USER_INITIALS", "TELEPHONE_NO", "EMAIL_ADDRESS", "CURRENT_ONLY", "INITIAL_PROFILE", "USER_PROFILE", "USER_DROPPED", "PROD_ACCESS", "PLAN_ACCESS", "PHASE_ACCESS", "PRINTING_ALLOWED", "INTL", "FRAMES_ONLY", "REFERENCE_TEXT", "APPROVED_ONLY", "LOC_ID", "CAT_ID", "OVERRIDE_PART_VAL", "WEB_ALLOWED", "LIMITED_CONFIGURATOR", "PLANT_ACCESS", "VIEW_BOM", "VIEW_PRICE", "OPTIONAL_DATA", "HISTORIC_ONLY", "UNLOCKING_RIGHT") AS 
  select "USER_ID","FORENAME","LAST_NAME","USER_INITIALS","TELEPHONE_NO","EMAIL_ADDRESS","CURRENT_ONLY","INITIAL_PROFILE","USER_PROFILE","USER_DROPPED","PROD_ACCESS","PLAN_ACCESS","PHASE_ACCESS","PRINTING_ALLOWED","INTL","FRAMES_ONLY","REFERENCE_TEXT","APPROVED_ONLY","LOC_ID","CAT_ID","OVERRIDE_PART_VAL","WEB_ALLOWED","LIMITED_CONFIGURATOR","PLANT_ACCESS","VIEW_BOM","VIEW_PRICE","OPTIONAL_DATA","HISTORIC_ONLY","UNLOCKING_RIGHT" from APPLICATION_USER
 ;
--------------------------------------------------------
--  DDL for View RPMV_APPROVAL_HISTORY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_APPROVAL_HISTORY" ("PART_NO", "REVISION", "STATUS_DATE_TIME", "USER_ID", "STATUS", "APPROVED_DATE", "PASS_FAIL", "FORENAME", "LAST_NAME", "ES_SEQ_NO") AS 
  select "PART_NO","REVISION","STATUS_DATE_TIME","USER_ID","STATUS","APPROVED_DATE","PASS_FAIL","FORENAME","LAST_NAME","ES_SEQ_NO" from APPROVAL_HISTORY
 ;
--------------------------------------------------------
--  DDL for View RPMV_APPROVER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_APPROVER" ("TABLE_NAME", "COL_SELECT", "COL_INSERT", "COL_UPDATE", "COL_DELETE") AS 
  select "TABLE_NAME","COL_SELECT","COL_INSERT","COL_UPDATE","COL_DELETE" from APPROVER
 ;
--------------------------------------------------------
--  DDL for View RPMV_APPROVER_SELECTED
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_APPROVER_SELECTED" ("PART_NO", "REVISION", "USER_ID", "APPROVED", "ALL_TO_APPROVE", "STATUS", "SELECTED", "USER_GROUP_ID") AS 
  select "PART_NO","REVISION","USER_ID","APPROVED","ALL_TO_APPROVE","STATUS","SELECTED","USER_GROUP_ID" from APPROVER_SELECTED
 ;
--------------------------------------------------------
--  DDL for View RPMV_ASSOCIATION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ASSOCIATION" ("ASSOCIATION", "DESCRIPTION", "ASSOCIATION_TYPE", "INTL", "STATUS") AS 
  select "ASSOCIATION","DESCRIPTION","ASSOCIATION_TYPE","INTL","STATUS" from ASSOCIATION
 ;
--------------------------------------------------------
--  DDL for View RPMV_ASSOCIATION_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ASSOCIATION_H" ("ASSOCIATION", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "ASSOCIATION_TYPE", "MAX_REV", "DATE_IMPORTED", "ES_SEQ_NO") AS 
  select "ASSOCIATION","REVISION","LANG_ID","DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","ASSOCIATION_TYPE","MAX_REV","DATE_IMPORTED","ES_SEQ_NO" from ASSOCIATION_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_ATFUNCBOM
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ATFUNCBOM" ("USER_ID", "FUNC_LEVEL", "FUNCTION", "FUNC_OVERRIDE", "COMPONENT_PART", "COMPONENT_REVISION", "DESCRIPTION", "PART_TYPE", "PLANT", "ALTERNATIVE", "USAGE", "QTY", "FRAME_NO", "ACTION", "APPLIC") AS 
  select "USER_ID","FUNC_LEVEL","FUNCTION","FUNC_OVERRIDE","COMPONENT_PART","COMPONENT_REVISION","DESCRIPTION","PART_TYPE","PLANT","ALTERNATIVE","USAGE","QTY","FRAME_NO","ACTION","APPLIC" from ATFUNCBOM
 ;
--------------------------------------------------------
--  DDL for View RPMV_ATFUNCBOMDATA
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ATFUNCBOMDATA" ("USER_ID", "SEQUENCE_NO", "FUNC_LEVEL", "SPEC_HEADER", "KEYWORD", "KEYWORD_ID", "ATTACHED_SPECS", "SECTION", "SECTION_ID", "SUB_SECTION", "SUB_SECTION_ID", "PROPERTY_GROUP", "PROPERTY_GROUP_ID", "PROPERTY", "PROPERTY_ID", "FIELD", "FIELD_TYPE", "VALUE", "APPLIC") AS 
  select "USER_ID","SEQUENCE_NO","FUNC_LEVEL","SPEC_HEADER","KEYWORD","KEYWORD_ID","ATTACHED_SPECS","SECTION","SECTION_ID","SUB_SECTION","SUB_SECTION_ID","PROPERTY_GROUP","PROPERTY_GROUP_ID","PROPERTY","PROPERTY_ID","FIELD","FIELD_TYPE","VALUE","APPLIC" from ATFUNCBOMDATA
 ;
--------------------------------------------------------
--  DDL for View RPMV_ATFUNCBOMWORKAREA
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ATFUNCBOMWORKAREA" ("USER_ID", "SEQUENCE_NO", "BOM_LEVEL", "COMPONENT_PART", "COMPONENT_REVISION", "DESCRIPTION", "PART_TYPE", "PLANT", "ALTERNATIVE", "USAGE", "EXPLOSION_DATE", "QTY", "FUNC_QTY", "UOM", "FUNCTION", "FUNC_LEVEL", "FUNC_OVERRIDE", "PARENT_PART", "PARENT_REVISION", "PARENT_SEQUENCE_NO", "APPLIC") AS 
  select "USER_ID","SEQUENCE_NO","BOM_LEVEL","COMPONENT_PART","COMPONENT_REVISION","DESCRIPTION","PART_TYPE","PLANT","ALTERNATIVE","USAGE","EXPLOSION_DATE","QTY","FUNC_QTY","UOM","FUNCTION","FUNC_LEVEL","FUNC_OVERRIDE","PARENT_PART","PARENT_REVISION","PARENT_SEQUENCE_NO","APPLIC" from ATFUNCBOMWORKAREA
 ;
--------------------------------------------------------
--  DDL for View RPMV_ATTRIBUTE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ATTRIBUTE" ("ATTRIBUTE", "DESCRIPTION", "INTL", "STATUS") AS 
  select "ATTRIBUTE","DESCRIPTION","INTL","STATUS" from ATTRIBUTE
 ;
--------------------------------------------------------
--  DDL for View RPMV_ATTRIBUTE_B
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ATTRIBUTE_B" ("ATTRIBUTE", "REVISION", "LANG_ID", "BUBBLE", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY") AS 
  select "ATTRIBUTE","REVISION","LANG_ID","BUBBLE","LAST_MODIFIED_ON","LAST_MODIFIED_BY" from ATTRIBUTE_B
 ;
--------------------------------------------------------
--  DDL for View RPMV_ATTRIBUTE_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ATTRIBUTE_H" ("ATTRIBUTE", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED", "ES_SEQ_NO") AS 
  select "ATTRIBUTE","REVISION","LANG_ID","DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","MAX_REV","DATE_IMPORTED","ES_SEQ_NO" from ATTRIBUTE_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_ATTRIBUTE_PROPERTY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ATTRIBUTE_PROPERTY" ("PROPERTY", "ATTRIBUTE", "INTL") AS 
  select "PROPERTY","ATTRIBUTE","INTL" from ATTRIBUTE_PROPERTY
 ;
--------------------------------------------------------
--  DDL for View RPMV_ATTRIBUTE_PROPERTY_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ATTRIBUTE_PROPERTY_H" ("PROPERTY", "ATTRIBUTE", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "INTL", "ACTION") AS 
  select "PROPERTY","ATTRIBUTE","LAST_MODIFIED_ON","LAST_MODIFIED_BY","INTL","ACTION" from ATTRIBUTE_PROPERTY_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_ATVERSIONINFO
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ATVERSIONINFO" ("TYPE", "ID", "INSTALLED_ON", "DESCRIPTION") AS 
  select "TYPE","ID","INSTALLED_ON","DESCRIPTION" from ATVERSIONINFO
 ;
--------------------------------------------------------
--  DDL for View RPMV_ATVREDESTEIN_TOBEREMOVED
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ATVREDESTEIN_TOBEREMOVED" ("KEY", "VALUE") AS 
  select "KEY","VALUE" from ATVREDESTEIN_TOBEREMOVED
 ;
--------------------------------------------------------
--  DDL for View RPMV_AVARTICLEPRICES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_AVARTICLEPRICES" ("PART_NO", "ART_GROUP", "BUDGET_QUANTITY", "MATERIAL_PRICE", "PRICE_2", "PRICE_3", "PRICE_4", "PRICE_5") AS 
  select "PART_NO","ART_GROUP","BUDGET_QUANTITY","MATERIAL_PRICE","PRICE_2","PRICE_3","PRICE_4","PRICE_5" from AVARTICLEPRICES
 ;
--------------------------------------------------------
--  DDL for View RPMV_AVARTICLEPRICES_SAV
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_AVARTICLEPRICES_SAV" ("PART_NO", "ART_GROUP", "BUDGET_QUANTITY", "MATERIAL_PRICE", "PRICE_2", "PRICE_3", "PRICE_4", "PRICE_5") AS 
  select "PART_NO","ART_GROUP","BUDGET_QUANTITY","MATERIAL_PRICE","PRICE_2","PRICE_3","PRICE_4","PRICE_5" from AVARTICLEPRICES_SAV
 ;
--------------------------------------------------------
--  DDL for View RPMV_BOMDISPLAYFORMAT_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_BOMDISPLAYFORMAT_TYPE" ("ID", "BOMFORMATTYPE") AS 
  SELECT ID,BOMFORMATTYPE 
     FROM RPMT_BOMDISPLAYFORMAT_TYPE

 ;
--------------------------------------------------------
--  DDL for View RPMV_CHARACTERISTIC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_CHARACTERISTIC" ("CHARACTERISTIC_ID", "DESCRIPTION", "INTL", "STATUS") AS 
  select "CHARACTERISTIC_ID","DESCRIPTION","INTL","STATUS" from CHARACTERISTIC
 ;
--------------------------------------------------------
--  DDL for View RPMV_CHARACTERISTIC_ASS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_CHARACTERISTIC_ASS" ("ASSOCIATION", "CHARACTERISTIC", "INTL") AS 
  select "ASSOCIATION","CHARACTERISTIC","INTL" from CHARACTERISTIC_ASSOCIATION
 ;
--------------------------------------------------------
--  DDL for View RPMV_CHARACTERISTIC_ASS_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_CHARACTERISTIC_ASS_H" ("CHARACTERISTIC_ID", "ASSOCIATION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "INTL", "ACTION") AS 
  select "CHARACTERISTIC_ID","ASSOCIATION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","INTL","ACTION" from CHARACTERISTIC_ASSOCIATION_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_CHARACTERISTIC_B
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_CHARACTERISTIC_B" ("CHARACTERISTIC_ID", "REVISION", "LANG_ID", "BUBBLE", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY") AS 
  select "CHARACTERISTIC_ID","REVISION","LANG_ID","BUBBLE","LAST_MODIFIED_ON","LAST_MODIFIED_BY" from CHARACTERISTIC_B
 ;
--------------------------------------------------------
--  DDL for View RPMV_CHARACTERISTIC_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_CHARACTERISTIC_H" ("CHARACTERISTIC_ID", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED", "ES_SEQ_NO") AS 
  select "CHARACTERISTIC_ID","REVISION","LANG_ID","DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","MAX_REV","DATE_IMPORTED","ES_SEQ_NO" from CHARACTERISTIC_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_CLASS3
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_CLASS3" ("CLASS", "SORT_DESC", "DESCRIPTION", "INTL", "TYPE", "STATUS") AS 
  select "CLASS","SORT_DESC","DESCRIPTION","INTL","TYPE","STATUS" from CLASS3
 ;
--------------------------------------------------------
--  DDL for View RPMV_CLASS3_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_CLASS3_H" ("CLASS", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "TYPE", "SORT_DESC", "MAX_REV", "DATE_IMPORTED", "ES_SEQ_NO") AS 
  select "CLASS","REVISION","LANG_ID","DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","TYPE","SORT_DESC","MAX_REV","DATE_IMPORTED","ES_SEQ_NO" from CLASS3_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_CONDITION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_CONDITION" ("CONDITION", "DESCRIPTION", "INTL", "STATUS") AS 
  select "CONDITION","DESCRIPTION","INTL","STATUS" from CONDITION
 ;
--------------------------------------------------------
--  DDL for View RPMV_CONDITION_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_CONDITION_H" ("CONDITION", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED", "ES_SEQ_NO") AS 
  select "CONDITION","REVISION","LANG_ID","DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","MAX_REV","DATE_IMPORTED","ES_SEQ_NO" from CONDITION_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_CTLICSECID
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_CTLICSECID" ("SERIAL_ID", "SETTING_SEQ", "SETTING_NAME", "SETTING_VALUE", "SHORTNAME") AS 
  select "SERIAL_ID","SETTING_SEQ","SETTING_NAME","SETTING_VALUE","SHORTNAME" from CTLICSECID
 ;
--------------------------------------------------------
--  DDL for View RPMV_CTLICSECIDAUXILIARY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_CTLICSECIDAUXILIARY" ("SERIAL_ID", "HASH_CODE_CLIENT", "HASH_CODE_SERVER", "TEMPLATE", "REF_DATE", "EXPIRATION_DATE", "SHORTNAME") AS 
  select "SERIAL_ID","HASH_CODE_CLIENT","HASH_CODE_SERVER","TEMPLATE","REF_DATE","EXPIRATION_DATE","SHORTNAME" from CTLICSECIDAUXILIARY
 ;
--------------------------------------------------------
--  DDL for View RPMV_CTLICSECIDAUXILIARYOLD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_CTLICSECIDAUXILIARYOLD" ("LOCAL_TRAN_ID", "LOGDATE", "SERIAL_ID", "SHORTNAME", "HASH_CODE_CLIENT", "HASH_CODE_SERVER", "TEMPLATE", "REF_DATE", "EXPIRATION_DATE") AS 
  select "LOCAL_TRAN_ID","LOGDATE","SERIAL_ID","SHORTNAME","HASH_CODE_CLIENT","HASH_CODE_SERVER","TEMPLATE","REF_DATE","EXPIRATION_DATE" from CTLICSECIDAUXILIARYOLD
 ;
--------------------------------------------------------
--  DDL for View RPMV_CTLICSECIDOLD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_CTLICSECIDOLD" ("LOCAL_TRAN_ID", "LOGDATE", "SERIAL_ID", "SHORTNAME", "SETTING_SEQ", "SETTING_NAME", "SETTING_VALUE") AS 
  select "LOCAL_TRAN_ID","LOGDATE","SERIAL_ID","SHORTNAME","SETTING_SEQ","SETTING_NAME","SETTING_VALUE" from CTLICSECIDOLD
 ;
--------------------------------------------------------
--  DDL for View RPMV_CTLICUSERCNT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_CTLICUSERCNT" ("USER_SID", "USER_NAME", "APP_ID", "APP_VERSION", "LIC_CHECK_APPLIES", "LOGON_DATE", "LAST_HEARTBEAT", "LOGOFF_DATE", "LOGON_STATION", "AUDSID", "APP_CUSTOM_PARAM") AS 
  select "USER_SID","USER_NAME","APP_ID","APP_VERSION","LIC_CHECK_APPLIES","LOGON_DATE","LAST_HEARTBEAT","LOGOFF_DATE","LOGON_STATION","AUDSID","APP_CUSTOM_PARAM" from CTLICUSERCNT
 ;
--------------------------------------------------------
--  DDL for View RPMV_DAISY_METHOD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_DAISY_METHOD" ("AV_METHOD", "METHOD", "PREPARATION", "AGING") AS 
  select "AV_METHOD","METHOD","PREPARATION","AGING" from DAISY_METHOD
 ;
--------------------------------------------------------
--  DDL for View RPMV_DATA_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_DATA_TYPE" ("FORMAT_ID", "TYPE") AS 
  SELECT FORMAT_ID,TYPE 
	  FROM RPMT_DATA_TYPE

 ;
--------------------------------------------------------
--  DDL for View RPMV_DEV_MGR
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_DEV_MGR" ("TABLE_NAME", "COL_SELECT", "COL_INSERT", "COL_UPDATE", "COL_DELETE") AS 
  select "TABLE_NAME","COL_SELECT","COL_INSERT","COL_UPDATE","COL_DELETE" from DEV_MGR
 ;
--------------------------------------------------------
--  DDL for View RPMV_DISPLAYFORMAT_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_DISPLAYFORMAT_TYPE" ("ID", "DISPLAYFORMATTYPE") AS 
  SELECT ID,DISPLAYFORMATTYPE 
     FROM RPMT_DISPLAYFORMAT_TYPE

 ;
--------------------------------------------------------
--  DDL for View RPMV_EXEMPTION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_EXEMPTION" ("PART_NO", "PART_EXEMPTION_NO", "DESCRIPTION", "TEXT", "FROM_DATE", "TO_DATE") AS 
  select "PART_NO","PART_EXEMPTION_NO","DESCRIPTION","TEXT","FROM_DATE","TO_DATE" from EXEMPTION
 ;
--------------------------------------------------------
--  DDL for View RPMV_FIXED_STATES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_FIXED_STATES" ("STATUS", "FRAMES", "OBJECTSREFTEXTS", "GLOSSARY") AS 
  SELECT STATUS,FRAMES,OBJECTSREFTEXTS,GLOSSARY 
      FROM RPMT_FIXED_STATES

 ;
--------------------------------------------------------
--  DDL for View RPMV_FOODCLAIMLOGRESULTDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_FOODCLAIMLOGRESULTDETAILS" ("LOG_ID", "FOOD_CLAIM_ID", "FOOD_CLAIM_CRIT_RULE_CD_ID", "HIER_LEVEL", "NUT_LOG_ID", "SEQ_NO", "REF_TYPE", "REF_ID", "AND_OR", "RULE_TYPE", "RULE_ID", "RULE_OPERATOR", "RULE_VALUE_1", "RULE_VALUE_2", "SERVING_SIZE", "VALUE_TYPE", "RELATIVE_PERC", "RELATIVE_COMP", "ACTUAL_VALUE", "RESULT", "PARENT_FOOD_CLAIM_ID", "PARENT_SEQ_NO", "ERROR_CODE", "ATTRIBUTE_ID") AS 
  select "LOG_ID","FOOD_CLAIM_ID","FOOD_CLAIM_CRIT_RULE_CD_ID","HIER_LEVEL","NUT_LOG_ID","SEQ_NO","REF_TYPE","REF_ID","AND_OR","RULE_TYPE","RULE_ID","RULE_OPERATOR","RULE_VALUE_1","RULE_VALUE_2","SERVING_SIZE","VALUE_TYPE","RELATIVE_PERC","RELATIVE_COMP","ACTUAL_VALUE","RESULT","PARENT_FOOD_CLAIM_ID","PARENT_SEQ_NO","ERROR_CODE","ATTRIBUTE_ID" from ITFOODCLAIMLOGRESULTDETAILS
 ;
--------------------------------------------------------
--  DDL for View RPMV_FORMAT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_FORMAT" ("FORMAT_ID", "DESCRIPTION", "INTL", "TYPE") AS 
  select "FORMAT_ID","DESCRIPTION","INTL","TYPE" from FORMAT
 ;
--------------------------------------------------------
--  DDL for View RPMV_FRAME_BUILDER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_FRAME_BUILDER" ("TABLE_NAME", "COL_SELECT", "COL_INSERT", "COL_UPDATE", "COL_DELETE") AS 
  select "TABLE_NAME","COL_SELECT","COL_INSERT","COL_UPDATE","COL_DELETE" from FRAME_BUILDER
 ;
--------------------------------------------------------
--  DDL for View RPMV_FRAME_HEADER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_FRAME_HEADER" ("FRAME_NO", "REVISION", "OWNER", "STATUS", "DESCRIPTION", "STATUS_CHANGE_DATE", "CREATED_BY", "CREATED_ON", "LAST_MODIFIED_BY", "LAST_MODIFIED_ON", "INTL", "CLASS3_ID", "WORKFLOW_GROUP_ID", "ACCESS_GROUP", "INT_FRAME_NO", "INT_FRAME_REV", "EXPORTED") AS 
  select "FRAME_NO","REVISION","OWNER","STATUS","DESCRIPTION","STATUS_CHANGE_DATE","CREATED_BY","CREATED_ON","LAST_MODIFIED_BY","LAST_MODIFIED_ON","INTL","CLASS3_ID","WORKFLOW_GROUP_ID","ACCESS_GROUP","INT_FRAME_NO","INT_FRAME_REV","EXPORTED" from FRAME_HEADER
 ;
--------------------------------------------------------
--  DDL for View RPMV_FRAME_KW
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_FRAME_KW" ("FRAME_NO", "KW_ID", "KW_VALUE", "INTL", "OWNER") AS 
  select "FRAME_NO","KW_ID","KW_VALUE","INTL","OWNER" from FRAME_KW
 ;
--------------------------------------------------------
--  DDL for View RPMV_FRAME_PROP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_FRAME_PROP" ("FRAME_NO", "REVISION", "OWNER", "SECTION_ID", "SECTION_REV", "SUB_SECTION_ID", "SUB_SECTION_REV", "PROPERTY_GROUP", "PROPERTY_GROUP_REV", "PROPERTY", "PROPERTY_REV", "ATTRIBUTE", "ATTRIBUTE_REV", "UOM_ID", "UOM_REV", "TEST_METHOD", "TEST_METHOD_REV", "SEQUENCE_NO", "NUM_1", "NUM_2", "NUM_3", "NUM_4", "NUM_5", "NUM_6", "NUM_7", "NUM_8", "NUM_9", "NUM_10", "CHAR_1", "CHAR_2", "CHAR_3", "CHAR_4", "CHAR_5", "CHAR_6", "BOOLEAN_1", "BOOLEAN_2", "BOOLEAN_3", "BOOLEAN_4", "DATE_1", "DATE_2", "CHARACTERISTIC", "ASSOCIATION", "INTL", "MANDATORY", "CHARACTERISTIC_REV", "ASSOCIATION_REV", "UOM_ALT_ID", "UOM_ALT_REV", "CH_2", "CH_REV_2", "CH_3", "CH_REV_3", "AS_2", "AS_REV_2", "AS_3", "AS_REV_3") AS 
  select "FRAME_NO","REVISION","OWNER","SECTION_ID","SECTION_REV","SUB_SECTION_ID","SUB_SECTION_REV","PROPERTY_GROUP","PROPERTY_GROUP_REV","PROPERTY","PROPERTY_REV","ATTRIBUTE","ATTRIBUTE_REV","UOM_ID","UOM_REV","TEST_METHOD","TEST_METHOD_REV","SEQUENCE_NO","NUM_1","NUM_2","NUM_3","NUM_4","NUM_5","NUM_6","NUM_7","NUM_8","NUM_9","NUM_10","CHAR_1","CHAR_2","CHAR_3","CHAR_4","CHAR_5","CHAR_6","BOOLEAN_1","BOOLEAN_2","BOOLEAN_3","BOOLEAN_4","DATE_1","DATE_2","CHARACTERISTIC","ASSOCIATION","INTL","MANDATORY","CHARACTERISTIC_REV","ASSOCIATION_REV","UOM_ALT_ID","UOM_ALT_REV","CH_2","CH_REV_2","CH_3","CH_REV_3","AS_2","AS_REV_2","AS_3","AS_REV_3" from FRAME_PROP
 ;
--------------------------------------------------------
--  DDL for View RPMV_FRAME_SECTION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_FRAME_SECTION" ("FRAME_NO", "REVISION", "OWNER", "SECTION_ID", "SECTION_REV", "SUB_SECTION_ID", "SUB_SECTION_REV", "TYPE", "REF_ID", "SEQUENCE_NO", "HEADER", "MANDATORY", "SECTION_SEQUENCE_NO", "REF_VER", "REF_INFO", "DISPLAY_FORMAT", "DISPLAY_FORMAT_REV", "ASSOCIATION", "INTL", "REF_OWNER", "SC_EXT", "REF_EXT") AS 
  select "FRAME_NO","REVISION","OWNER","SECTION_ID","SECTION_REV","SUB_SECTION_ID","SUB_SECTION_REV","TYPE","REF_ID","SEQUENCE_NO","HEADER","MANDATORY","SECTION_SEQUENCE_NO","REF_VER","REF_INFO","DISPLAY_FORMAT","DISPLAY_FORMAT_REV","ASSOCIATION","INTL","REF_OWNER","SC_EXT","REF_EXT" from FRAME_SECTION
 ;
--------------------------------------------------------
--  DDL for View RPMV_FRAME_TEXT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_FRAME_TEXT" ("FRAME_NO", "REVISION", "OWNER", "SECTION_ID", "SECTION_REV", "SUB_SECTION_ID", "SUB_SECTION_REV", "TEXT_TYPE", "TEXT", "TEXT_TYPE_REV") AS 
  select "FRAME_NO","REVISION","OWNER","SECTION_ID","SECTION_REV","SUB_SECTION_ID","SUB_SECTION_REV","TEXT_TYPE","TEXT","TEXT_TYPE_REV" from FRAME_TEXT
 ;
--------------------------------------------------------
--  DDL for View RPMV_FRAMEDATA
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_FRAMEDATA" ("FRAME_NO", "REVISION", "OWNER", "SECTION_ID", "SUB_SECTION_ID", "SEQUENCE_NO", "TYPE", "REF_ID", "REF_VER", "PROPERTY_GROUP", "PROPERTY", "ATTRIBUTE", "HEADER_ID", "VALUE", "VALUE_S", "UOM_ID", "TEST_METHOD", "CHARACTERISTIC", "ASSOCIATION", "REF_INFO", "INTL", "VALUE_TYPE", "VALUE_DT", "SECTION_REV", "SUB_SECTION_REV", "PROPERTY_GROUP_REV", "PROPERTY_REV", "ATTRIBUTE_REV", "UOM_REV", "TEST_METHOD_REV", "CHARACTERISTIC_REV", "ASSOCIATION_REV", "HEADER_REV", "REF_OWNER") AS 
  select "FRAME_NO","REVISION","OWNER","SECTION_ID","SUB_SECTION_ID","SEQUENCE_NO","TYPE","REF_ID","REF_VER","PROPERTY_GROUP","PROPERTY","ATTRIBUTE","HEADER_ID","VALUE","VALUE_S","UOM_ID","TEST_METHOD","CHARACTERISTIC","ASSOCIATION","REF_INFO","INTL","VALUE_TYPE","VALUE_DT","SECTION_REV","SUB_SECTION_REV","PROPERTY_GROUP_REV","PROPERTY_REV","ATTRIBUTE_REV","UOM_REV","TEST_METHOD_REV","CHARACTERISTIC_REV","ASSOCIATION_REV","HEADER_REV","REF_OWNER" from FRAMEDATA
 ;
--------------------------------------------------------
--  DDL for View RPMV_FRAMEDATA_SERVER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_FRAMEDATA_SERVER" ("FRAME_NO", "REVISION", "OWNER", "DATE_PROCESSED") AS 
  select "FRAME_NO","REVISION","OWNER","DATE_PROCESSED" from FRAMEDATA_SERVER
 ;
--------------------------------------------------------
--  DDL for View RPMV_FT_ATTACH_SPEC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_FT_ATTACH_SPEC" ("PART_NO", "REF_ID", "ATTACHED_PART_NO", "ATTACHED_REVISION", "SECTION_ID", "SUB_SECTION_ID", "INTL") AS 
  select "PART_NO","REF_ID","ATTACHED_PART_NO","ATTACHED_REVISION","SECTION_ID","SUB_SECTION_ID","INTL" from FT_ATTACH_SPEC
 ;
--------------------------------------------------------
--  DDL for View RPMV_FT_BASE_RULES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_FT_BASE_RULES" ("FT_GROUP_ID", "FT_ID", "OLD_SECTION", "OLD_SUB_SECTION", "OLD_PROP_GROUP", "OLD_PROPERTY", "OLD_ATTRIBUTE", "OLD_COLUMN", "NEW_SECTION", "NEW_SUB_SECTION", "NEW_PROP_GROUP", "NEW_PROPERTY", "NEW_ATTRIBUTE", "NEW_COLUMN", "OBJECT_TYPE") AS 
  select "FT_GROUP_ID","FT_ID","OLD_SECTION","OLD_SUB_SECTION","OLD_PROP_GROUP","OLD_PROPERTY","OLD_ATTRIBUTE","OLD_COLUMN","NEW_SECTION","NEW_SUB_SECTION","NEW_PROP_GROUP","NEW_PROPERTY","NEW_ATTRIBUTE","NEW_COLUMN","OBJECT_TYPE" from FT_BASE_RULES
 ;
--------------------------------------------------------
--  DDL for View RPMV_FT_BASE_RULES_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_FT_BASE_RULES_H" ("FT_GROUP_ID", "FT_ID", "OLD_SECTION", "OLD_SUB_SECTION", "OLD_PROP_GROUP", "OLD_PROPERTY", "OLD_ATTRIBUTE", "OLD_COLUMN", "NEW_SECTION", "NEW_SUB_SECTION", "NEW_PROP_GROUP", "NEW_PROPERTY", "NEW_ATTRIBUTE", "NEW_COLUMN", "OBJECT_TYPE", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "ACTION") AS 
  select "FT_GROUP_ID","FT_ID","OLD_SECTION","OLD_SUB_SECTION","OLD_PROP_GROUP","OLD_PROPERTY","OLD_ATTRIBUTE","OLD_COLUMN","NEW_SECTION","NEW_SUB_SECTION","NEW_PROP_GROUP","NEW_PROPERTY","NEW_ATTRIBUTE","NEW_COLUMN","OBJECT_TYPE","LAST_MODIFIED_ON","LAST_MODIFIED_BY","ACTION" from FT_BASE_RULES_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_FT_FRAMES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_FT_FRAMES" ("FT_GROUP_ID", "FT_FRAME_ID", "OLD_FRAME_NO", "OLD_FRAME_REV", "OLD_FRAME_OWNER", "NEW_FRAME_NO", "NEW_FRAME_REV", "NEW_FRAME_OWNER", "OLD_FRAME_REV_FROM", "OLD_FRAME_REV_TO", "NEW_FRAME_REV_FROM", "NEW_FRAME_REV_TO") AS 
  select "FT_GROUP_ID","FT_FRAME_ID","OLD_FRAME_NO","OLD_FRAME_REV","OLD_FRAME_OWNER","NEW_FRAME_NO","NEW_FRAME_REV","NEW_FRAME_OWNER","OLD_FRAME_REV_FROM","OLD_FRAME_REV_TO","NEW_FRAME_REV_FROM","NEW_FRAME_REV_TO" from FT_FRAMES
 ;
--------------------------------------------------------
--  DDL for View RPMV_FT_FRAMES_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_FT_FRAMES_H" ("FT_GROUP_ID", "FT_FRAME_ID", "OLD_FRAME_NO", "OLD_FRAME_REV", "OLD_FRAME_OWNER", "NEW_FRAME_NO", "NEW_FRAME_REV", "NEW_FRAME_OWNER", "OLD_FRAME_REV_FROM", "OLD_FRAME_REV_TO", "NEW_FRAME_REV_FROM", "NEW_FRAME_REV_TO", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "ACTION") AS 
  select "FT_GROUP_ID","FT_FRAME_ID","OLD_FRAME_NO","OLD_FRAME_REV","OLD_FRAME_OWNER","NEW_FRAME_NO","NEW_FRAME_REV","NEW_FRAME_OWNER","OLD_FRAME_REV_FROM","OLD_FRAME_REV_TO","NEW_FRAME_REV_FROM","NEW_FRAME_REV_TO","LAST_MODIFIED_ON","LAST_MODIFIED_BY","ACTION" from FT_FRAMES_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_FT_RULE_GROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_FT_RULE_GROUP" ("FT_RULE_ID", "DESCRIPTION") AS 
  select "FT_RULE_ID","DESCRIPTION" from FT_RULE_GROUP
 ;
--------------------------------------------------------
--  DDL for View RPMV_FT_RULE_GROUP_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_FT_RULE_GROUP_H" ("FT_RULE_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "ACTION", "DATE_IMPORTED") AS 
  select "FT_RULE_ID","DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","ACTION","DATE_IMPORTED" from FT_RULE_GROUP_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_FT_SPEC_PROP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_FT_SPEC_PROP" ("PART_NO", "SECTION_ID", "SECTION_REV", "SUB_SECTION_ID", "SUB_SECTION_REV", "PROPERTY_GROUP", "PROPERTY_GROUP_REV", "PROPERTY", "PROPERTY_REV", "ATTRIBUTE", "ATTRIBUTE_REV", "UOM_ID", "UOM_REV", "TEST_METHOD", "TEST_METHOD_REV", "SEQUENCE_NO", "NUM_1", "NUM_2", "NUM_3", "NUM_4", "NUM_5", "NUM_6", "NUM_7", "NUM_8", "NUM_9", "NUM_10", "CHAR_1", "CHAR_2", "CHAR_3", "CHAR_4", "CHAR_5", "CHAR_6", "BOOLEAN_1", "BOOLEAN_2", "BOOLEAN_3", "BOOLEAN_4", "DATE_1", "DATE_2", "CHARACTERISTIC", "CHARACTERISTIC_REV", "ASSOCIATION", "ASSOCIATION_REV", "INTL", "AS_2", "AS_REV_2", "AS_3", "AS_REV_3", "TM_DET_1", "TM_DET_2", "TM_DET_3", "TM_DET_4", "INFO", "TM_SET_NO") AS 
  select "PART_NO","SECTION_ID","SECTION_REV","SUB_SECTION_ID","SUB_SECTION_REV","PROPERTY_GROUP","PROPERTY_GROUP_REV","PROPERTY","PROPERTY_REV","ATTRIBUTE","ATTRIBUTE_REV","UOM_ID","UOM_REV","TEST_METHOD","TEST_METHOD_REV","SEQUENCE_NO","NUM_1","NUM_2","NUM_3","NUM_4","NUM_5","NUM_6","NUM_7","NUM_8","NUM_9","NUM_10","CHAR_1","CHAR_2","CHAR_3","CHAR_4","CHAR_5","CHAR_6","BOOLEAN_1","BOOLEAN_2","BOOLEAN_3","BOOLEAN_4","DATE_1","DATE_2","CHARACTERISTIC","CHARACTERISTIC_REV","ASSOCIATION","ASSOCIATION_REV","INTL","AS_2","AS_REV_2","AS_3","AS_REV_3","TM_DET_1","TM_DET_2","TM_DET_3","TM_DET_4","INFO","TM_SET_NO" from FT_SPEC_PROP
 ;
--------------------------------------------------------
--  DDL for View RPMV_FT_SPEC_PROP_LANG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_FT_SPEC_PROP_LANG" ("PART_NO", "SECTION_ID", "SUB_SECTION_ID", "PROPERTY_GROUP", "PROPERTY", "ATTRIBUTE", "LANG_ID", "SEQUENCE_NO", "CHAR_1", "CHAR_2", "CHAR_3", "CHAR_4", "CHAR_5", "CHAR_6", "INTL", "INFO") AS 
  select "PART_NO","SECTION_ID","SUB_SECTION_ID","PROPERTY_GROUP","PROPERTY","ATTRIBUTE","LANG_ID","SEQUENCE_NO","CHAR_1","CHAR_2","CHAR_3","CHAR_4","CHAR_5","CHAR_6","INTL","INFO" from FT_SPEC_PROP_LANG
 ;
--------------------------------------------------------
--  DDL for View RPMV_FT_SPEC_SECTION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_FT_SPEC_SECTION" ("PART_NO", "SECTION_ID", "SUB_SECTION_ID", "TYPE", "REF_ID", "REF_VER", "REF_INFO", "SEQUENCE_NO", "HEADER", "MANDATORY", "SECTION_SEQUENCE_NO", "DISPLAY_FORMAT", "ASSOCIATION", "INTL", "SECTION_REV", "SUB_SECTION_REV", "DISPLAY_FORMAT_REV", "REF_OWNER") AS 
  select "PART_NO","SECTION_ID","SUB_SECTION_ID","TYPE","REF_ID","REF_VER","REF_INFO","SEQUENCE_NO","HEADER","MANDATORY","SECTION_SEQUENCE_NO","DISPLAY_FORMAT","ASSOCIATION","INTL","SECTION_REV","SUB_SECTION_REV","DISPLAY_FORMAT_REV","REF_OWNER" from FT_SPEC_SECTION
 ;
--------------------------------------------------------
--  DDL for View RPMV_FT_SPEC_TEXT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_FT_SPEC_TEXT" ("PART_NO", "TEXT_TYPE", "TEXT", "SECTION_ID", "SECTION_REV", "SUB_SECTION_ID", "SUB_SECTION_REV", "TEXT_TYPE_REV", "LANG_ID") AS 
  select "PART_NO","TEXT_TYPE","TEXT","SECTION_ID","SECTION_REV","SUB_SECTION_ID","SUB_SECTION_REV","TEXT_TYPE_REV","LANG_ID" from FT_SPEC_TEXT
 ;
--------------------------------------------------------
--  DDL for View RPMV_FT_SPEC_TM
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_FT_SPEC_TM" ("PART_NO", "SECTION_ID", "SUB_SECTION_ID", "PROPERTY_GROUP", "PROPERTY", "ATTRIBUTE", "SEQ_NO", "TM_TYPE", "TM", "TM_REV", "TM_SET_NO") AS 
  select "PART_NO","SECTION_ID","SUB_SECTION_ID","PROPERTY_GROUP","PROPERTY","ATTRIBUTE","SEQ_NO","TM_TYPE","TM","TM_REV","TM_SET_NO" from FT_SPEC_TM
 ;
--------------------------------------------------------
--  DDL for View RPMV_FT_SQL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_FT_SQL" ("FT_GROUP_ID", "FT_ID", "SQL_TEXT") AS 
  select "FT_GROUP_ID","FT_ID","SQL_TEXT" from FT_SQL
 ;
--------------------------------------------------------
--  DDL for View RPMV_FT_SQL_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_FT_SQL_H" ("FT_GROUP_ID", "FT_ID", "SQL_TEXT", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "ACTION") AS 
  select "FT_GROUP_ID","FT_ID","SQL_TEXT","LAST_MODIFIED_ON","LAST_MODIFIED_BY","ACTION" from FT_SQL_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_FUNCTIONS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_FUNCTIONS" ("FUNCTION_ID", "DESCRIPTION", "INTL") AS 
  select "FUNCTION_ID","DESCRIPTION","INTL" from FUNCTIONS
 ;
--------------------------------------------------------
--  DDL for View RPMV_GRANT_EXECUTE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_GRANT_EXECUTE" ("OBJECT_NAME", "CONFIGURATOR", "APPROVER", "DEV_MGR", "VIEW_ONLY", "MRP", "FRAME_BUILDER") AS 
  select "OBJECT_NAME","CONFIGURATOR","APPROVER","DEV_MGR","VIEW_ONLY","MRP","FRAME_BUILDER" from GRANT_EXECUTE
 ;
--------------------------------------------------------
--  DDL for View RPMV_GROUP_PROPERTY_LIMIT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_GROUP_PROPERTY_LIMIT" ("PROPERTY_GROUP", "PROPERTY", "UOM_ID", "LOWER_REJECT", "UPPER_REJECT", "INTL") AS 
  select "PROPERTY_GROUP","PROPERTY","UOM_ID","LOWER_REJECT","UPPER_REJECT","INTL" from GROUP_PROPERTY_LIMIT
 ;
--------------------------------------------------------
--  DDL for View RPMV_HEADER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_HEADER" ("HEADER_ID", "DESCRIPTION", "INTL", "STATUS") AS 
  select "HEADER_ID","DESCRIPTION","INTL","STATUS" from HEADER
 ;
--------------------------------------------------------
--  DDL for View RPMV_HEADER_B
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_HEADER_B" ("HEADER_ID", "REVISION", "LANG_ID", "BUBBLE", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY") AS 
  select "HEADER_ID","REVISION","LANG_ID","BUBBLE","LAST_MODIFIED_ON","LAST_MODIFIED_BY" from HEADER_B
 ;
--------------------------------------------------------
--  DDL for View RPMV_HEADER_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_HEADER_H" ("HEADER_ID", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED", "ES_SEQ_NO") AS 
  select "HEADER_ID","REVISION","LANG_ID","DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","MAX_REV","DATE_IMPORTED","ES_SEQ_NO" from HEADER_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_INGREDIENTDETAIL_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_INGREDIENTDETAIL_TYPE" ("ID", "INGTYPE") AS 
  SELECT ID,INGTYPE 
     FROM RPMT_INGREDIENTDETAIL_TYPE

 ;
--------------------------------------------------------
--  DDL for View RPMV_INGREDIENTDISPLAY_FORMAT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_INGREDIENTDISPLAY_FORMAT" ("ID", "INGREDIENTDISPLAYFORMAT") AS 
  SELECT ID,INGREDIENTDISPLAYFORMAT 
     FROM RPMT_INGREDIENTDISPLAY_FORMAT

 ;
--------------------------------------------------------
--  DDL for View RPMV_INTERSPC_CFG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_INTERSPC_CFG" ("SECTION", "PARAMETER", "PARAMETER_DATA", "VISIBLE", "ES", "ES_SEQ_NO") AS 
  select "SECTION","PARAMETER","PARAMETER_DATA","VISIBLE","ES","ES_SEQ_NO" from INTERSPC_CFG
 ;
--------------------------------------------------------
--  DDL for View RPMV_INTERSPC_CFG_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_INTERSPC_CFG_H" ("SECTION", "PARAMETER", "PARAMETER_DATA_OLD", "PARAMETER_DATA_NEW", "ACTION", "ES_SEQ_NO", "USER_ID", "FORENAME", "LAST_NAME", "TIMESTAMP", "SIGN_FOR_ID", "SIGN_FOR", "SIGN_WHAT_ID", "SIGN_WHAT") AS 
  select "SECTION","PARAMETER","PARAMETER_DATA_OLD","PARAMETER_DATA_NEW","ACTION","ES_SEQ_NO","USER_ID","FORENAME","LAST_NAME","TIMESTAMP","SIGN_FOR_ID","SIGN_FOR","SIGN_WHAT_ID","SIGN_WHAT" from INTERSPC_CFG_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_IT_TR_JRNL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_IT_TR_JRNL" ("ID", "REVISION", "PREV_DESCR", "NEW_DESCR", "LAST_MODIFIED_BY", "LAST_MODIFIED_ON", "ID_TYPE", "OWNER", "LANG_ID") AS 
  select "ID","REVISION","PREV_DESCR","NEW_DESCR","LAST_MODIFIED_BY","LAST_MODIFIED_ON","ID_TYPE","OWNER","LANG_ID" from IT_TR_JRNL
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITADDON
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITADDON" ("ADDON_ID", "NAME", "DESCRIPTION", "CLASS", "DOMAIN", "ADDONTYPE", "ASSEMBLY", "STARTURL", "STARTPARAM") AS 
  select "ADDON_ID","NAME","DESCRIPTION","CLASS","DOMAIN","ADDONTYPE","ASSEMBLY","STARTURL","STARTPARAM" from ITADDON
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITADDONAC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITADDONAC" ("ADDON_ID", "USER_GROUP_ID", "USER_ID", "ACCESS_TYPE") AS 
  select "ADDON_ID","USER_GROUP_ID","USER_ID","ACCESS_TYPE" from ITADDONAC
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITADDONARG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITADDONARG" ("ADDON_ID", "ARG_ID", "ARG") AS 
  select "ADDON_ID","ARG_ID","ARG" from ITADDONARG
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITADDONRQ
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITADDONRQ" ("REQ_ID", "USER_ID", "ADDON_ID", "METRIC", "LANG_ID", "CULTURE", "GUI_LANG", "NEXT_ADDON_ID") AS 
  select "REQ_ID","USER_ID","ADDON_ID","METRIC","LANG_ID","CULTURE","GUI_LANG","NEXT_ADDON_ID" from ITADDONRQ
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITADDONRQARG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITADDONRQARG" ("REQ_ID", "ARG", "ARG_VAL") AS 
  select "REQ_ID","ARG","ARG_VAL" from ITADDONRQARG
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITADDONTYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITADDONTYPE" ("ADDONTYPE_ID", "DESCRIPTION") AS 
  select "ADDONTYPE_ID","DESCRIPTION" from ITADDONTYPE
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITAGHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITAGHS" ("ACCESS_GROUP", "AUDIT_TRAIL_SEQ_NO", "USER_ID", "FORENAME", "LAST_NAME", "TIMESTAMP", "WHAT_ID", "WHAT") AS 
  select "ACCESS_GROUP","AUDIT_TRAIL_SEQ_NO","USER_ID","FORENAME","LAST_NAME","TIMESTAMP","WHAT_ID","WHAT" from ITAGHS
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITAGHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITAGHSDETAILS" ("ACCESS_GROUP", "AUDIT_TRAIL_SEQ_NO", "SEQ_NO", "DETAILS") AS 
  select "ACCESS_GROUP","AUDIT_TRAIL_SEQ_NO","SEQ_NO","DETAILS" from ITAGHSDETAILS
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITAPI
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITAPI" ("PROCEDURE_NAME", "TYPE", "CUSTOM") AS 
  select "PROCEDURE_NAME","TYPE","CUSTOM" from ITAPI
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITATTEXPLOSION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITATTEXPLOSION" ("BOM_EXP_NO", "MOP_SEQUENCE_NO", "SEQUENCE_NO", "ATT_PART", "ATT_REVISION", "DESCRIPTION", "PARENT_PART", "PARENT_REVISION", "PLANT", "ALTERNATIVE", "USAGE") AS 
  select "BOM_EXP_NO","MOP_SEQUENCE_NO","SEQUENCE_NO","ATT_PART","ATT_REVISION","DESCRIPTION","PARENT_PART","PARENT_REVISION","PLANT","ALTERNATIVE","USAGE" from ITATTEXPLOSION
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITBIT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITBIT" ("BIT_ID", "DESCRIPTION", "PART_SOURCE") AS 
  select "BIT_ID","DESCRIPTION","PART_SOURCE" from ITBIT
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITBOMEXPTEMP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITBOMEXPTEMP" ("BOM_EXP_NO", "MOP_SEQUENCE_NO", "SEQUENCE_NO", "PSEQUENCE_NO") AS 
  select "BOM_EXP_NO","MOP_SEQUENCE_NO","SEQUENCE_NO","PSEQUENCE_NO" from ITBOMEXPTEMP
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITBOMIMPLOSION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITBOMIMPLOSION" ("BOM_IMP_NO", "MOP_SEQUENCE_NO", "MOP_PART", "SEQUENCE_NO", "BOM_LEVEL", "PARENT_PART", "PARENT_REVISION", "DESCRIPTION", "PLANT", "ALTERNATIVE", "USAGE", "SPEC_TYPE", "TOP_LEVEL", "ACCESS_STOP", "RECURSIVE_STOP", "ALT_GROUP", "ALT_PRIORITY", "QUANTITY", "UOM", "CONV_FACTOR", "TO_UNIT") AS 
  select "BOM_IMP_NO","MOP_SEQUENCE_NO","MOP_PART","SEQUENCE_NO","BOM_LEVEL","PARENT_PART","PARENT_REVISION","DESCRIPTION","PLANT","ALTERNATIVE","USAGE","SPEC_TYPE","TOP_LEVEL","ACCESS_STOP","RECURSIVE_STOP","ALT_GROUP","ALT_PRIORITY","QUANTITY","UOM","CONV_FACTOR","TO_UNIT" from ITBOMIMPLOSION
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITBOMJRNL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITBOMJRNL" ("PART_NO", "REVISION", "PLANT", "ALTERNATIVE", "BOM_USAGE", "ITEM_NUMBER", "USER_ID", "TIMESTAMP", "FORENAME", "LAST_NAME", "HEADER_ID", "FIELD_ID", "OLD_VALUE", "NEW_VALUE") AS 
  select "PART_NO","REVISION","PLANT","ALTERNATIVE","BOM_USAGE","ITEM_NUMBER","USER_ID","TIMESTAMP","FORENAME","LAST_NAME","HEADER_ID","FIELD_ID","OLD_VALUE","NEW_VALUE" from ITBOMJRNL
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITBOMLY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITBOMLY" ("LAYOUT_ID", "DESCRIPTION", "INTL", "STATUS", "CREATED_BY", "CREATED_ON", "LAST_MODIFIED_BY", "LAST_MODIFIED_ON", "REVISION", "DATE_IMPORTED", "LAYOUT_TYPE") AS 
  select "LAYOUT_ID","DESCRIPTION","INTL","STATUS","CREATED_BY","CREATED_ON","LAST_MODIFIED_BY","LAST_MODIFIED_ON","REVISION","DATE_IMPORTED","LAYOUT_TYPE" from ITBOMLY
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITBOMLYITEM
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITBOMLYITEM" ("LAYOUT_ID", "HEADER_ID", "FIELD_ID", "INCLUDED", "START_POS", "LENGTH", "ALIGNMENT", "FORMAT_ID", "HEADER", "COLOR", "BOLD", "UNDERLINE", "INTL", "REVISION", "HEADER_REV", "DEF", "FIELD_TYPE", "EDITABLE", "PHASE_MRP", "PLANNING_MRP", "PRODUCTION_MRP", "ASSOCIATION", "CHARACTERISTIC") AS 
  select "LAYOUT_ID","HEADER_ID","FIELD_ID","INCLUDED","START_POS","LENGTH","ALIGNMENT","FORMAT_ID","HEADER","COLOR","BOLD","UNDERLINE","INTL","REVISION","HEADER_REV","DEF","FIELD_TYPE","EDITABLE","PHASE_MRP","PLANNING_MRP","PRODUCTION_MRP","ASSOCIATION","CHARACTERISTIC" from ITBOMLYITEM
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITBOMLYSOURCE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITBOMLYSOURCE" ("SOURCE", "LAYOUT_TYPE", "LAYOUT_ID", "LAYOUT_REV", "PREFERRED") AS 
  select "SOURCE","LAYOUT_TYPE","LAYOUT_ID","LAYOUT_REV","PREFERRED" from ITBOMLYSOURCE
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITBOMPATH
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITBOMPATH" ("BOM_EXP_NO", "SEQ_NO", "PARENT_PART_NO", "PARENT_REVISION", "PART_NO", "REVISION", "PLANT", "ALTERNATIVE", "BOM_USAGE", "ALT_GROUP", "ALT_PRIORITY", "BOM_LEVEL") AS 
  select "BOM_EXP_NO","SEQ_NO","PARENT_PART_NO","PARENT_REVISION","PART_NO","REVISION","PLANT","ALTERNATIVE","BOM_USAGE","ALT_GROUP","ALT_PRIORITY","BOM_LEVEL" from ITBOMPATH
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITBU
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITBU" ("BOM_USAGE", "DESCR") AS 
  select "BOM_USAGE","DESCR" from ITBU
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITCF
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITCF" ("CF_ID", "CF_TYPE", "DESCRIPTION", "PROCEDURE_NAME", "CUSTOM", "STANDARD_FUNCTION") AS 
  select "CF_ID","CF_TYPE","DESCRIPTION","PROCEDURE_NAME","CUSTOM","STANDARD_FUNCTION" from ITCF
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITCLAIMEXPLOSION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITCLAIMEXPLOSION" ("BOM_EXP_NO", "MOP_SEQUENCE_NO", "SEQUENCE_NO", "CLAIMS_SEQUENCE_NO", "PART_NO", "REVISION", "PROPERTY_GROUP", "PROPERTY_GROUP_REV", "PROPERTY", "PROPERTY_REV", "ATTRIBUTE", "ATTRIBUTE_REV", "NUM_1", "NUM_2", "NUM_3", "NUM_4", "NUM_5", "NUM_6", "NUM_7", "NUM_8", "NUM_9", "NUM_10", "CHAR_1", "CHAR_2", "CHAR_3", "CHAR_4", "CHAR_5", "CHAR_6", "INFO", "BOOLEAN_1", "BOOLEAN_2", "BOOLEAN_3", "BOOLEAN_4", "DATE_1", "DATE_2", "CHARACTERISTIC_1", "CHARACTERISTIC_REV_1", "CHARACTERISTIC_2", "CHARACTERISTIC_REV_2", "CHARACTERISTIC_3", "CHARACTERISTIC_REV_3", "ASSOCIATION_1", "ASSOCIATION_REV_1", "ASSOCIATION_2", "ASSOCIATION_REV_2", "ASSOCIATION_3", "ASSOCIATION_REV_3", "TEST_METHOD", "TEST_METHOD_REV", "CALC_QTY", "UOM", "PG_TYPE") AS 
  select "BOM_EXP_NO","MOP_SEQUENCE_NO","SEQUENCE_NO","CLAIMS_SEQUENCE_NO","PART_NO","REVISION","PROPERTY_GROUP","PROPERTY_GROUP_REV","PROPERTY","PROPERTY_REV","ATTRIBUTE","ATTRIBUTE_REV","NUM_1","NUM_2","NUM_3","NUM_4","NUM_5","NUM_6","NUM_7","NUM_8","NUM_9","NUM_10","CHAR_1","CHAR_2","CHAR_3","CHAR_4","CHAR_5","CHAR_6","INFO","BOOLEAN_1","BOOLEAN_2","BOOLEAN_3","BOOLEAN_4","DATE_1","DATE_2","CHARACTERISTIC_1","CHARACTERISTIC_REV_1","CHARACTERISTIC_2","CHARACTERISTIC_REV_2","CHARACTERISTIC_3","CHARACTERISTIC_REV_3","ASSOCIATION_1","ASSOCIATION_REV_1","ASSOCIATION_2","ASSOCIATION_REV_2","ASSOCIATION_3","ASSOCIATION_REV_3","TEST_METHOD","TEST_METHOD_REV","CALC_QTY","UOM","PG_TYPE" from ITCLAIMEXPLOSION
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITCLAIMLOG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITCLAIMLOG" ("LOG_ID", "LOG_NAME", "STATUS", "PART_NO", "REVISION", "PLANT", "ALTERNATIVE", "BOM_USAGE", "EXPLOSION_DATE", "CREATED_BY", "CREATED_ON", "REPORT_TYPE", "LOGGINGXML") AS 
  select "LOG_ID","LOG_NAME","STATUS","PART_NO","REVISION","PLANT","ALTERNATIVE","BOM_USAGE","EXPLOSION_DATE","CREATED_BY","CREATED_ON","REPORT_TYPE","LOGGINGXML" from ITCLAIMLOG
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITCLAIMLOGRESULT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITCLAIMLOGRESULT" ("LOG_ID", "PROPERTY_GROUP", "PROPERTY_GROUP_REV", "PROPERTY", "PROPERTY_REV", "PG_TYPE", "VALUE") AS 
  select "LOG_ID","PROPERTY_GROUP","PROPERTY_GROUP_REV","PROPERTY","PROPERTY_REV","PG_TYPE","VALUE" from ITCLAIMLOGRESULT
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITCLAIMRESULT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITCLAIMRESULT" ("BOM_EXP_NO", "PROPERTY_GROUP", "PROPERTY_GROUP_REV", "PROPERTY", "PROPERTY_REV", "PG_TYPE", "CLAIM") AS 
  select "BOM_EXP_NO","PROPERTY_GROUP","PROPERTY_GROUP_REV","PROPERTY","PROPERTY_REV","PG_TYPE","CLAIM" from ITCLAIMRESULT
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITCLAIMRESULTDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITCLAIMRESULTDETAILS" ("BOM_EXP_NO", "PART_NO", "REVISION", "PROPERTY_GROUP", "PROPERTY_GROUP_REV", "PROPERTY", "PROPERTY_REV", "SEQUENCE_NO", "CALC_QTY", "UOM", "PG_TYPE", "CLAIM", "INFO1", "INFO2", "CLAIM_RESULT") AS 
  select "BOM_EXP_NO","PART_NO","REVISION","PROPERTY_GROUP","PROPERTY_GROUP_REV","PROPERTY","PROPERTY_REV","SEQUENCE_NO","CALC_QTY","UOM","PG_TYPE","CLAIM","INFO1","INFO2","CLAIM_RESULT" from ITCLAIMRESULTDETAILS
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITCLAT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITCLAT" ("TREE_ID", "ATTRIBUTE_ID", "LABEL", "TYPE", "CODE") AS 
  select "TREE_ID","ATTRIBUTE_ID","LABEL","TYPE","CODE" from ITCLAT
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITCLCLF
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITCLCLF" ("ID", "PID", "CID", "DESCR") AS 
  select "ID","PID","CID","DESCR" from ITCLCLF
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITCLD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITCLD" ("ID", "SPEC_GROUP", "NODE") AS 
  select "ID","SPEC_GROUP","NODE" from ITCLD
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITCLFLT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITCLFLT" ("FILTER_ID", "MATL_CLASS_ID", "CODE", "TYPE") AS 
  select "FILTER_ID","MATL_CLASS_ID","CODE","TYPE" from ITCLFLT
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITCLTV
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITCLTV" ("PID", "CID", "DESCR", "CCNT", "CODE", "TYPE", "LONG_DESCR", "STATUS") AS 
  select "PID","CID","DESCR","CCNT","CODE","TYPE","LONG_DESCR","STATUS" from ITCLTV
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITCMPPARTS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITCMPPARTS" ("USER_ID", "PART_NO", "REVISION", "MASTER") AS 
  select "USER_ID","PART_NO","REVISION","MASTER" from ITCMPPARTS
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITCSTREPSH
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITCSTREPSH" ("REP_ID", "PART_NO", "REVISION", "SEQ_NO") AS 
  select "REP_ID","PART_NO","REVISION","SEQ_NO" from ITCSTREPSH
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITCULTUREMAPPING
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITCULTUREMAPPING" ("LANG_ID", "CULTURE_ID") AS 
  select "LANG_ID","CULTURE_ID" from ITCULTUREMAPPING
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITCUSTOMCALCULATION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITCUSTOMCALCULATION" ("CUSTOMCALCULATION_ID", "CUSTOMCALCULATION_GUID", "DESCRIPTION", "PLUGINURL", "CLASSNAME", "INTL", "STATUS", "VALIDATIONFUNCTION") AS 
  select "CUSTOMCALCULATION_ID","CUSTOMCALCULATION_GUID","DESCRIPTION","PLUGINURL","CLASSNAME","INTL","STATUS","VALIDATIONFUNCTION" from ITCUSTOMCALCULATION
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITCUSTOMCALCULATION_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITCUSTOMCALCULATION_H" ("CUSTOMCALCULATION_ID", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV") AS 
  select "CUSTOMCALCULATION_ID","REVISION","LANG_ID","DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","MAX_REV" from ITCUSTOMCALCULATION_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITCUSTOMCALCULATIONVALUES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITCUSTOMCALCULATIONVALUES" ("CUSTOMCALCULATION_ID", "VALUEDESCRIPTION", "SECTION_ID", "SUB_SECTION_ID", "PROPERTY_GROUP", "PROPERTY", "ATTRIBUTE", "VALUE") AS 
  select "CUSTOMCALCULATION_ID","VALUEDESCRIPTION","SECTION_ID","SUB_SECTION_ID","PROPERTY_GROUP","PROPERTY","ATTRIBUTE","VALUE" from ITCUSTOMCALCULATIONVALUES
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITDATEOFFSET
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITDATEOFFSET" ("OFFSET") AS 
  select "OFFSET" from ITDATEOFFSET
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITDBPROFILE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITDBPROFILE" ("OWNER", "DESCRIPTION", "DB_TYPE", "ALLOW_GLOSSARY", "ALLOW_FRAME_CHANGES", "ALLOW_FRAME_EXPORT", "LIVE_DB", "PARENT_OWNER", "REGION", "DEVISION", "COUNTRY") AS 
  select "OWNER","DESCRIPTION","DB_TYPE","ALLOW_GLOSSARY","ALLOW_FRAME_CHANGES","ALLOW_FRAME_EXPORT","LIVE_DB","PARENT_OWNER","REGION","DEVISION","COUNTRY" from ITDBPROFILE
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITEMAIL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITEMAIL" ("EMAIL_NO", "EMAIL_TYPE", "PART_NO", "REVISION", "PART_EXEMPTION", "STATUS", "PREV_EFFECTIVE_DATE", "STATUS_DATE_TIME", "REASON_ID", "USERID", "PASSWORD") AS 
  select "EMAIL_NO","EMAIL_TYPE","PART_NO","REVISION","PART_EXEMPTION","STATUS","PREV_EFFECTIVE_DATE","STATUS_DATE_TIME","REASON_ID","USERID","PASSWORD" from ITEMAIL
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITENSSLOG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITENSSLOG" ("EN_TP", "EN_ID", "STATUS_CHANGE_DATE", "USER_ID", "STATUS", "PLANT", "LINE", "CONFIGURATION") AS 
  select "EN_TP","EN_ID","STATUS_CHANGE_DATE","USER_ID","STATUS","PLANT","LINE","CONFIGURATION" from ITENSSLOG
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITERROR
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITERROR" ("SEQ_NO", "MACHINE", "MODULE", "SOURCE", "APPLIC", "USER_ID", "LOGDATE", "ERROR_MSG", "MSG_TYPE", "INFOLEVEL") AS 
  select "SEQ_NO","MACHINE","MODULE","SOURCE","APPLIC","USER_ID","LOGDATE","ERROR_MSG","MSG_TYPE","INFOLEVEL" from ITERROR
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITESHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITESHS" ("ES_SEQ_NO", "TYPE", "USER_ID", "FORENAME", "LAST_NAME", "TIMESTAMP", "SIGN_FOR_ID", "SIGN_FOR", "SIGN_WHAT_ID", "SIGN_WHAT", "SUCCESS", "SUCCESS_DESCR") AS 
  select "ES_SEQ_NO","TYPE","USER_ID","FORENAME","LAST_NAME","TIMESTAMP","SIGN_FOR_ID","SIGN_FOR","SIGN_WHAT_ID","SIGN_WHAT","SUCCESS","SUCCESS_DESCR" from ITESHS
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITEVENT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITEVENT" ("EVENT_ID", "NAME", "CREATED_ON", "CREATED_BY", "INVISIBLE", "EVENT_TYPE_ID") AS 
  select "EVENT_ID","NAME","CREATED_ON","CREATED_BY","INVISIBLE","EVENT_TYPE_ID" from ITEVENT
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITEVENTLOG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITEVENTLOG" ("EVENT_ID", "TRANSM_TYPE", "MSG", "CREATED_ON") AS 
  select "EVENT_ID","TRANSM_TYPE","MSG","CREATED_ON" from ITEVENTLOG
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITEVENTTYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITEVENTTYPE" ("EVENT_TYPE_ID", "EVENT_TYPE_NAME") AS 
  select "EVENT_TYPE_ID","EVENT_TYPE_NAME" from ITEVENTTYPE
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITEVSERVICES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITEVSERVICES" ("EV_SERVICE_NAME", "CREATED_ON") AS 
  select "EV_SERVICE_NAME","CREATED_ON" from ITEVSERVICES
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITEVSERVICETYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITEVSERVICETYPE" ("EVENT_SERVICE_NAME", "EVENT_TYPE_ID") AS 
  select "EVENT_SERVICE_NAME","EVENT_TYPE_ID" from ITEVSERVICETYPE
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITEVSINK
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITEVSINK" ("EV_SEQUENCE", "EV_SERVICE_NAME", "EV_NAME", "EV_DETAILS", "CREATED_ON", "HANDLED_OK", "EVENT_ID", "EV_DATA") AS 
  select "EV_SEQUENCE","EV_SERVICE_NAME","EV_NAME","EV_DETAILS","CREATED_ON","HANDLED_OK","EVENT_ID","EV_DATA" from ITEVSINK
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFCLAIM
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFCLAIM" ("CLAIM_ID", "CLAIM_GUID", "DESCRIPTION", "PLUGINURL", "CLASSNAME", "CLAIMGROUP_ID", "CLAIMTYPE_ID", "INTL", "STATUS") AS 
  SELECT 0 AS CLAIM_ID, 'NO R&'||'D LIBRARY INSTALLED' AS CLAIM_GUID, 
				'NO R&'||'D LIBRARY INSTALLED' AS DESCRIPTION, 
				'NO R&'||'D LIBRARY INSTALLED' AS PLUGINURL, 
				'NO R&'||'D LIBRARY INSTALLED' AS CLASSNAME, 
				0 AS CLAIMGROUP_ID, 0 AS CLAIMTYPE_ID, 
				'N' AS INTL, 0 AS STATUS 
		FROM DUAL

 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFCLAIM_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFCLAIM_H" ("CLAIM_ID", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV") AS 
  SELECT 0 AS CLAIM_ID, 
					 0 AS REVISION, 
					 1 AS LANG_ID, 
					 'NO R&'||'D LIBRARY INSTALLED' AS DESCRIPTION, 
					 SYSDATE AS LAST_MODIFIED_ON, 
					 USER AS LAST_MODIFIED_BY, 
					 0 AS MAX_REV 
			FROM DUAL

 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFCLAIMCONDITION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFCLAIMCONDITION" ("CLAIM_ID", "CONDITION_ID") AS 
  SELECT 0 AS CLAIM_ID, 
					 0 AS CONDITION_ID 
			FROM DUAL

 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFCLAIMGROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFCLAIMGROUP" ("CLAIMGROUP_ID", "DESCRIPTION", "INTL", "STATUS") AS 
  SELECT 0 AS CLAIMGROUP_ID, 
					 'NO R&'||'D LIBRARY INSTALLED' AS DESCRIPTION, 
					 'N' AS INTL, 0 AS STATUS 
FROM DUAL

 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFCLAIMGROUP_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFCLAIMGROUP_H" ("CLAIMGROUP_ID", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV") AS 
  SELECT 0 AS CLAIMGROUP_ID, 
					 0 AS REVISION, 
					 1 AS LANG_ID, 
					 'NO R&'||'D LIBRARY INSTALLED' AS DESCRIPTION, 
					 SYSDATE AS LAST_MODIFIED_ON, 
					 USER AS LAST_MODIFIED_BY, 
					 0 AS MAX_REV 
			FROM DUAL

 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFCLAIMLOG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFCLAIMLOG" ("LOG_ID", "LOG_NAME", "STATUS", "PART_NO", "REVISION", "PLANT", "ALTERNATIVE", "BOM_USAGE", "EXPLOSION_DATE", "CREATED_BY", "CREATED_ON", "REPORT_TYPE", "LOGGINGXML") AS 
  SELECT 0 AS LOG_ID, 
				    'NO R&'||'D LIBRARY INSTALLED' AS LOG_NAME, 
				     0 AS STATUS,
				     0 AS PART_NO, 
				     0 AS REVISION, 
				     '---' AS PLANT, 
				     0 AS ALTERNATIVE, 
				     0 AS BOM_USAGE, 
				     SYSDATE AS EXPLOSION_DATE, 
				     USER AS CREATED_BY, 
				     SYSDATE AS CREATED_ON, 
				     0 AS REPORT_TYPE, 
				     'NO R&'||'D LIBRARY INSTALLED' AS LOGGINGXML 
		  FROM DUAL

 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFCLAIMLOGRESULT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFCLAIMLOGRESULT" ("LOG_ID", "CLAIM_ID", "PROFILE_ID", "RESULT", "VALUE", "CLAIMTEXT") AS 
  SELECT 0 AS LOG_ID, 
					 0 AS CLAIM_ID, 
					 0 AS PROFILE_ID, 
					 'N' AS RESULT, 
					 'NO R&'||'D LIBRARY INSTALLED' AS vALUE, 
					 'NO R&'||'D LIBRARY INSTALLED' AS 
			CLAIMTEXT FROM DUAL

 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFCLAIMTYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFCLAIMTYPE" ("CLAIMTYPE_ID", "DESCRIPTION", "INTL", "STATUS") AS 
  SELECT 0 AS CLAIMTYPE_ID, 
					 'NO R&'||'D LIBRARY INSTALLED' AS DESCRIPTION, 
					 'N' AS INTL, 0 AS STATUS 
			FROM DUAL

 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFCLAIMTYPE_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFCLAIMTYPE_H" ("CLAIMTYPE_ID", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV") AS 
  SELECT 0 AS CLAIMTYPE_ID, 
					 0 AS REVISION, 
					 1 AS LANG_ID, 
					 'NO R&'||'D LIBRARY INSTALLED' AS DESCRIPTION, 
					 SYSDATE AS LAST_MODIFIED_ON, 
					 USER AS LAST_MODIFIED_BY, 
					 0 AS MAX_REV 
			FROM DUAL

 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFCONDITION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFCONDITION" ("CONDITION_ID", "DESCRIPTION", "INTL", "STATUS") AS 
  SELECT 0 AS CONDITION_ID, 
					 'NO R&'||'D LIBRARY INSTALLED' AS DESCRIPTION, 
					 'N' AS INTL, 0 AS STATUS 
FROM DUAL

 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFCONDITION_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFCONDITION_H" ("CONDITION_ID", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV") AS 
  SELECT 0 AS CONDITION_ID, 
					 0 AS REVISION, 
					 1 AS LANG_ID, 
					 'NO R&'||'D LIBRARY INSTALLED' AS DESCRIPTION, 
					 SYSDATE AS LAST_MODIFIED_ON, 
					 USER AS LAST_MODIFIED_BY, 
					 0 AS MAX_REV 
		FROM DUAL

 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFOODCLAIM
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFOODCLAIM" ("FOOD_CLAIM_ID", "DESCRIPTION", "RELATIVE", "MANDATORY", "INTL", "STATUS") AS 
  select "FOOD_CLAIM_ID","DESCRIPTION","RELATIVE","MANDATORY","INTL","STATUS" from ITFOODCLAIM
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFOODCLAIM_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFOODCLAIM_H" ("FOOD_CLAIM_ID", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "ES_SEQ_NO") AS 
  select "FOOD_CLAIM_ID","REVISION","LANG_ID","DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","MAX_REV","ES_SEQ_NO" from ITFOODCLAIM_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFOODCLAIMALERT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFOODCLAIMALERT" ("FOOD_CLAIM_ALERT_ID", "DESCRIPTION", "LONG_DESCRIPTION", "INTL", "STATUS") AS 
  select "FOOD_CLAIM_ALERT_ID","DESCRIPTION","LONG_DESCRIPTION","INTL","STATUS" from ITFOODCLAIMALERT
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFOODCLAIMALERT_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFOODCLAIMALERT_H" ("FOOD_CLAIM_ALERT_ID", "REVISION", "LANG_ID", "DESCRIPTION", "LONG_DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "ES_SEQ_NO") AS 
  select "FOOD_CLAIM_ALERT_ID","REVISION","LANG_ID","DESCRIPTION","LONG_DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","MAX_REV","ES_SEQ_NO" from ITFOODCLAIMALERT_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFOODCLAIMCD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFOODCLAIMCD" ("FOOD_CLAIM_CD_ID", "DESCRIPTION", "LONG_DESCRIPTION", "INTL", "STATUS") AS 
  select "FOOD_CLAIM_CD_ID","DESCRIPTION","LONG_DESCRIPTION","INTL","STATUS" from ITFOODCLAIMCD
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFOODCLAIMCD_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFOODCLAIMCD_H" ("FOOD_CLAIM_CD_ID", "REVISION", "LANG_ID", "DESCRIPTION", "LONG_DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "ES_SEQ_NO") AS 
  select "FOOD_CLAIM_CD_ID","REVISION","LANG_ID","DESCRIPTION","LONG_DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","MAX_REV","ES_SEQ_NO" from ITFOODCLAIMCD_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFOODCLAIMCRIT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFOODCLAIMCRIT" ("FOOD_CLAIM_CRIT_ID", "DESCRIPTION", "FOOD_CLAIM_CRIT_RULE_ID", "FOOD_CLAIM_CRIT_KEY_ID", "INTL", "STATUS") AS 
  select "FOOD_CLAIM_CRIT_ID","DESCRIPTION","FOOD_CLAIM_CRIT_RULE_ID","FOOD_CLAIM_CRIT_KEY_ID","INTL","STATUS" from ITFOODCLAIMCRIT
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFOODCLAIMCRIT_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFOODCLAIMCRIT_H" ("FOOD_CLAIM_CRIT_ID", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "ES_SEQ_NO") AS 
  select "FOOD_CLAIM_CRIT_ID","REVISION","LANG_ID","DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","MAX_REV","ES_SEQ_NO" from ITFOODCLAIMCRIT_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFOODCLAIMCRITKEY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFOODCLAIMCRITKEY" ("FOOD_CLAIM_CRIT_KEY_ID", "DESCRIPTION", "INTL", "STATUS") AS 
  select "FOOD_CLAIM_CRIT_KEY_ID","DESCRIPTION","INTL","STATUS" from ITFOODCLAIMCRITKEY
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFOODCLAIMCRITKEY_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFOODCLAIMCRITKEY_H" ("FOOD_CLAIM_CRIT_KEY_ID", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "ES_SEQ_NO") AS 
  select "FOOD_CLAIM_CRIT_KEY_ID","REVISION","LANG_ID","DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","MAX_REV","ES_SEQ_NO" from ITFOODCLAIMCRITKEY_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFOODCLAIMCRITKEYCD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFOODCLAIMCRITKEYCD" ("FOOD_CLAIM_CRIT_KEY_CD_ID", "DESCRIPTION", "KEY_TYPE", "KEY_ID", "KEY_OPERATOR", "KEY_VALUE", "KEY_UOM", "INTL", "STATUS") AS 
  select "FOOD_CLAIM_CRIT_KEY_CD_ID","DESCRIPTION","KEY_TYPE","KEY_ID","KEY_OPERATOR","KEY_VALUE","KEY_UOM","INTL","STATUS" from ITFOODCLAIMCRITKEYCD
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFOODCLAIMCRITKEYCD_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFOODCLAIMCRITKEYCD_H" ("FOOD_CLAIM_CRIT_KEY_CD_ID", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "ES_SEQ_NO") AS 
  select "FOOD_CLAIM_CRIT_KEY_CD_ID","REVISION","LANG_ID","DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","MAX_REV","ES_SEQ_NO" from ITFOODCLAIMCRITKEYCD_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFOODCLAIMCRITKEYD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFOODCLAIMCRITKEYD" ("FOOD_CLAIM_CRIT_KEY_ID", "SEQ_NO", "REF_TYPE", "REF_ID", "AND_OR", "INTL") AS 
  select "FOOD_CLAIM_CRIT_KEY_ID","SEQ_NO","REF_TYPE","REF_ID","AND_OR","INTL" from ITFOODCLAIMCRITKEYD
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFOODCLAIMCRITRULE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFOODCLAIMCRITRULE" ("FOOD_CLAIM_CRIT_RULE_ID", "DESCRIPTION", "INTL", "STATUS") AS 
  select "FOOD_CLAIM_CRIT_RULE_ID","DESCRIPTION","INTL","STATUS" from ITFOODCLAIMCRITRULE
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFOODCLAIMCRITRULE_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFOODCLAIMCRITRULE_H" ("FOOD_CLAIM_CRIT_RULE_ID", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "ES_SEQ_NO") AS 
  select "FOOD_CLAIM_CRIT_RULE_ID","REVISION","LANG_ID","DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","MAX_REV","ES_SEQ_NO" from ITFOODCLAIMCRITRULE_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFOODCLAIMCRITRULECD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFOODCLAIMCRITRULECD" ("FOOD_CLAIM_CRIT_RULE_CD_ID", "DESCRIPTION", "RULE_TYPE", "RULE_ID", "RULE_OPERATOR", "RULE_VALUE_1", "RULE_VALUE_2", "SERVING_SIZE", "VALUE_TYPE", "RELATIVE_PERC", "RELATIVE_COMP", "INTL", "STATUS", "ATTRIBUTE_ID") AS 
  select "FOOD_CLAIM_CRIT_RULE_CD_ID","DESCRIPTION","RULE_TYPE","RULE_ID","RULE_OPERATOR","RULE_VALUE_1","RULE_VALUE_2","SERVING_SIZE","VALUE_TYPE","RELATIVE_PERC","RELATIVE_COMP","INTL","STATUS","ATTRIBUTE_ID" from ITFOODCLAIMCRITRULECD
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFOODCLAIMCRITRULECD_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFOODCLAIMCRITRULECD_H" ("FOOD_CLAIM_CRIT_RULE_CD_ID", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "ES_SEQ_NO") AS 
  select "FOOD_CLAIM_CRIT_RULE_CD_ID","REVISION","LANG_ID","DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","MAX_REV","ES_SEQ_NO" from ITFOODCLAIMCRITRULECD_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFOODCLAIMCRITRULED
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFOODCLAIMCRITRULED" ("FOOD_CLAIM_CRIT_RULE_ID", "SEQ_NO", "REF_TYPE", "REF_ID", "AND_OR", "INTL") AS 
  select "FOOD_CLAIM_CRIT_RULE_ID","SEQ_NO","REF_TYPE","REF_ID","AND_OR","INTL" from ITFOODCLAIMCRITRULED
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFOODCLAIMD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFOODCLAIMD" ("FOOD_CLAIM_ID", "REF_TYPE", "REF_ID", "FOOD_CLAIM_CRIT_ID", "INTL") AS 
  select "FOOD_CLAIM_ID","REF_TYPE","REF_ID","FOOD_CLAIM_CRIT_ID","INTL" from ITFOODCLAIMD
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFOODCLAIMLABEL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFOODCLAIMLABEL" ("FOOD_CLAIM_LABEL_ID", "DESCRIPTION", "LONG_DESCRIPTION", "INTL", "STATUS") AS 
  select "FOOD_CLAIM_LABEL_ID","DESCRIPTION","LONG_DESCRIPTION","INTL","STATUS" from ITFOODCLAIMLABEL
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFOODCLAIMLABEL_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFOODCLAIMLABEL_H" ("FOOD_CLAIM_LABEL_ID", "REVISION", "LANG_ID", "DESCRIPTION", "LONG_DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "ES_SEQ_NO") AS 
  select "FOOD_CLAIM_LABEL_ID","REVISION","LANG_ID","DESCRIPTION","LONG_DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","MAX_REV","ES_SEQ_NO" from ITFOODCLAIMLABEL_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFOODCLAIMLOG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFOODCLAIMLOG" ("LOG_ID", "LOG_NAME", "STATUS", "PART_NO", "REVISION", "PLANT", "ALTERNATIVE", "BOM_USAGE", "EXPLOSION_DATE", "CREATED_BY", "CREATED_ON", "LABEL", "LANGUAGE_ID", "REFERENCE_AMOUNT", "LOGGINGXML") AS 
  select "LOG_ID","LOG_NAME","STATUS","PART_NO","REVISION","PLANT","ALTERNATIVE","BOM_USAGE","EXPLOSION_DATE","CREATED_BY","CREATED_ON","LABEL","LANGUAGE_ID","REFERENCE_AMOUNT","LOGGINGXML" from ITFOODCLAIMLOG
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFOODCLAIMLOGRESULT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFOODCLAIMLOGRESULT" ("LOG_ID", "FOOD_CLAIM_ID", "NUT_LOG_ID", "RESULT", "COMP_LOG_ID", "COMP_GROUP_ID", "FOOD_CLAIM_DESCRIPTION", "DEC_SEP") AS 
  select "LOG_ID","FOOD_CLAIM_ID","NUT_LOG_ID","RESULT","COMP_LOG_ID","COMP_GROUP_ID","FOOD_CLAIM_DESCRIPTION","DEC_SEP" from ITFOODCLAIMLOGRESULT
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFOODCLAIMNOTE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFOODCLAIMNOTE" ("FOOD_CLAIM_NOTE_ID", "DESCRIPTION", "LONG_DESCRIPTION", "INTL", "STATUS") AS 
  select "FOOD_CLAIM_NOTE_ID","DESCRIPTION","LONG_DESCRIPTION","INTL","STATUS" from ITFOODCLAIMNOTE
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFOODCLAIMNOTE_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFOODCLAIMNOTE_H" ("FOOD_CLAIM_NOTE_ID", "REVISION", "LANG_ID", "DESCRIPTION", "LONG_DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "ES_SEQ_NO") AS 
  select "FOOD_CLAIM_NOTE_ID","REVISION","LANG_ID","DESCRIPTION","LONG_DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","MAX_REV","ES_SEQ_NO" from ITFOODCLAIMNOTE_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFOODCLAIMPROFILE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFOODCLAIMPROFILE" ("REQ_ID", "LOG_ID", "GROUP_ID") AS 
  select "REQ_ID","LOG_ID","GROUP_ID" from ITFOODCLAIMPROFILE
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFOODCLAIMRESULT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFOODCLAIMRESULT" ("REQ_ID", "LOG_ID", "FOOD_CLAIM_ID", "RESULT", "COMP_LOG_ID", "COMP_GROUP_ID", "FOOD_CLAIM_DESCRIPTION", "DEC_SEP") AS 
  select "REQ_ID","LOG_ID","FOOD_CLAIM_ID","RESULT","COMP_LOG_ID","COMP_GROUP_ID","FOOD_CLAIM_DESCRIPTION","DEC_SEP" from ITFOODCLAIMRESULT
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFOODCLAIMRESULTDETAIL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFOODCLAIMRESULTDETAIL" ("REQ_ID", "LOG_ID", "FOOD_CLAIM_ID", "FOOD_CLAIM_CRIT_RULE_CD_ID", "HIER_LEVEL", "SEQ_NO", "REF_TYPE", "REF_ID", "AND_OR", "RULE_TYPE", "RULE_ID", "RULE_OPERATOR", "RULE_VALUE_1", "RULE_VALUE_2", "SERVING_SIZE", "VALUE_TYPE", "RELATIVE_PERC", "RELATIVE_COMP", "ACTUAL_VALUE", "RESULT", "PARENT_FOOD_CLAIM_ID", "PARENT_SEQ_NO", "ERROR_CODE", "ATTRIBUTE_ID", "NOT_CLAIM") AS 
  select "REQ_ID","LOG_ID","FOOD_CLAIM_ID","FOOD_CLAIM_CRIT_RULE_CD_ID","HIER_LEVEL","SEQ_NO","REF_TYPE","REF_ID","AND_OR","RULE_TYPE","RULE_ID","RULE_OPERATOR","RULE_VALUE_1","RULE_VALUE_2","SERVING_SIZE","VALUE_TYPE","RELATIVE_PERC","RELATIVE_COMP","ACTUAL_VALUE","RESULT","PARENT_FOOD_CLAIM_ID","PARENT_SEQ_NO","ERROR_CODE","ATTRIBUTE_ID","NOT_CLAIM" from ITFOODCLAIMRESULTDETAIL
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFOODCLAIMRUN
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFOODCLAIMRUN" ("FOOD_CLAIM_ID", "REQ_ID", "INCLUDE", "LOG_ID", "GROUP_ID", "FOOD_CLAIM_CRIT_RULE_ID", "ERROR_CODE") AS 
  select "FOOD_CLAIM_ID","REQ_ID","INCLUDE","LOG_ID","GROUP_ID","FOOD_CLAIM_CRIT_RULE_ID","ERROR_CODE" from ITFOODCLAIMRUN
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFOODCLAIMRUNCD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFOODCLAIMRUNCD" ("FOOD_CLAIM_ID", "REQ_ID", "REF_TYPE", "REF_ID", "RESULT", "LOG_ID") AS 
  select "FOOD_CLAIM_ID","REQ_ID","REF_TYPE","REF_ID","RESULT","LOG_ID" from ITFOODCLAIMRUNCD
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFOODCLAIMRUNCRIT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFOODCLAIMRUNCRIT" ("REQ_ID", "KEY_TYPE", "KEY_ID", "KEY_OPERATOR", "KEY_VALUE", "KEY_UOM") AS 
  select "REQ_ID","KEY_TYPE","KEY_ID","KEY_OPERATOR","KEY_VALUE","KEY_UOM" from ITFOODCLAIMRUNCRIT
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFOODCLAIMRUNKW
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFOODCLAIMRUNKW" ("REQ_ID", "KEY_ID", "KEY_OPERATOR", "KEY_VALUE") AS 
  select "REQ_ID","KEY_ID","KEY_OPERATOR","KEY_VALUE" from ITFOODCLAIMRUNKW
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFOODCLAIMSYN
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFOODCLAIMSYN" ("FOOD_CLAIM_SYN_ID", "DESCRIPTION", "INTL", "STATUS") AS 
  select "FOOD_CLAIM_SYN_ID","DESCRIPTION","INTL","STATUS" from ITFOODCLAIMSYN
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFOODCLAIMSYN_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFOODCLAIMSYN_H" ("FOOD_CLAIM_SYN_ID", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "ES_SEQ_NO") AS 
  select "FOOD_CLAIM_SYN_ID","REVISION","LANG_ID","DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","MAX_REV","ES_SEQ_NO" from ITFOODCLAIMSYN_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFOODTYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFOODTYPE" ("FOOD_TYPE_ID", "DESCRIPTION", "INTL", "STATUS") AS 
  select "FOOD_TYPE_ID","DESCRIPTION","INTL","STATUS" from ITFOODTYPE
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFOODTYPE_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFOODTYPE_H" ("FOOD_TYPE_ID", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "ES_SEQ_NO") AS 
  select "FOOD_TYPE_ID","REVISION","LANG_ID","DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","MAX_REV","ES_SEQ_NO" from ITFOODTYPE_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFOOTNOTE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFOOTNOTE" ("FOOTNOTE_ID", "PANEL_ID", "HEADER", "TEXT") AS 
  select "FOOTNOTE_ID","PANEL_ID","HEADER","TEXT" from ITFOOTNOTE
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFRM_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFRM_H" ("FRAME_NO", "OWNER", "LAST_MODIFIED_ON") AS 
  select "FRAME_NO","OWNER","LAST_MODIFIED_ON" from ITFRM_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFRMCL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFRMCL" ("FRAME_NO", "OWNER", "HIER_LEVEL", "MATL_CLASS_ID", "CODE", "TYPE") AS 
  select "FRAME_NO","OWNER","HIER_LEVEL","MATL_CLASS_ID","CODE","TYPE" from ITFRMCL
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFRMDEL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFRMDEL" ("FRAME_NO", "REVISION", "OWNER", "DELETION_DATE", "STATUS", "USER_ID", "FORENAME", "LAST_NAME") AS 
  select "FRAME_NO","REVISION","OWNER","DELETION_DATE","STATUS","USER_ID","FORENAME","LAST_NAME" from ITFRMDEL
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFRMFLT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFRMFLT" ("FILTER_ID", "FRAME_NO", "REVISION", "OWNER", "STATUS", "DESCRIPTION", "STATUS_CHANGE_DATE", "CREATED_BY", "CREATED_ON", "LAST_MODIFIED_BY", "LAST_MODIFIED_ON", "INTL", "CLASS3_ID", "WORKFLOW_GROUP_ID", "ACCESS_GROUP", "INT_FRAME_NO", "INT_FRAME_REV", "EXPORTED") AS 
  select "FILTER_ID","FRAME_NO","REVISION","OWNER","STATUS","DESCRIPTION","STATUS_CHANGE_DATE","CREATED_BY","CREATED_ON","LAST_MODIFIED_BY","LAST_MODIFIED_ON","INTL","CLASS3_ID","WORKFLOW_GROUP_ID","ACCESS_GROUP","INT_FRAME_NO","INT_FRAME_REV","EXPORTED" from ITFRMFLT
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFRMFLTD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFRMFLTD" ("FILTER_ID", "USER_ID", "DESCRIPTION", "SORT_DESC", "OPTIONS", "DEFAULT_FLT") AS 
  select "FILTER_ID","USER_ID","DESCRIPTION","SORT_DESC","OPTIONS","DEFAULT_FLT" from ITFRMFLTD
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFRMFLTOP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFRMFLTOP" ("FILTER_ID", "LOG_FRAME_NO", "LOG_REVISION", "LOG_OWNER", "LOG_STATUS", "LOG_DESCRIPTION", "LOG_STATUS_CHANGE_DATE", "LOG_CREATED_BY", "LOG_CREATED_ON", "LOG_LAST_MODIFIED_BY", "LOG_LAST_MODIFIED_ON", "LOG_INTL", "LOG_CLASS3_ID", "LOG_WORKFLOW_GROUP_ID", "LOG_ACCESS_GROUP", "LOG_INT_FRAME_NO", "LOG_INT_FRAME_REV", "LOG_EXPORTED") AS 
  select "FILTER_ID","LOG_FRAME_NO","LOG_REVISION","LOG_OWNER","LOG_STATUS","LOG_DESCRIPTION","LOG_STATUS_CHANGE_DATE","LOG_CREATED_BY","LOG_CREATED_ON","LOG_LAST_MODIFIED_BY","LOG_LAST_MODIFIED_ON","LOG_INTL","LOG_CLASS3_ID","LOG_WORKFLOW_GROUP_ID","LOG_ACCESS_GROUP","LOG_INT_FRAME_NO","LOG_INT_FRAME_REV","LOG_EXPORTED" from ITFRMFLTOP
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFRMNOTE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFRMNOTE" ("FRAME_NO", "OWNER", "TEXT") AS 
  select "FRAME_NO","OWNER","TEXT" from ITFRMNOTE
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFRMV
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFRMV" ("FRAME_NO", "REVISION", "OWNER", "VIEW_ID", "DESCRIPTION", "LAST_MODIFIED_BY", "LAST_MODIFIED_ON", "STATUS") AS 
  select "FRAME_NO","REVISION","OWNER","VIEW_ID","DESCRIPTION","LAST_MODIFIED_BY","LAST_MODIFIED_ON","STATUS" from ITFRMV
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFRMVAL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFRMVAL" ("FRAME_NO", "REVISION", "OWNER", "VAL_ID", "MASK_ID", "LAST_MODIFIED_BY", "LAST_MODIFIED_ON", "STATUS") AS 
  select "FRAME_NO","REVISION","OWNER","VAL_ID","MASK_ID","LAST_MODIFIED_BY","LAST_MODIFIED_ON","STATUS" from ITFRMVAL
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFRMVALD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFRMVALD" ("VAL_ID", "VAL_SEQ", "TYPE", "SECTION_ID", "SUB_SECTION_ID", "PROPERTY_GROUP", "PROPERTY", "ATTRIBUTE", "HEADER_ID", "REF_ID", "REF_OWNER") AS 
  select "VAL_ID","VAL_SEQ","TYPE","SECTION_ID","SUB_SECTION_ID","PROPERTY_GROUP","PROPERTY","ATTRIBUTE","HEADER_ID","REF_ID","REF_OWNER" from ITFRMVALD
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFRMVPG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFRMVPG" ("VIEW_ID", "FRAME_NO", "REVISION", "OWNER", "SECTION_ID", "SUB_SECTION_ID", "PROPERTY_GROUP", "PROPERTY", "ATTRIBUTE", "MANDATORY") AS 
  select "VIEW_ID","FRAME_NO","REVISION","OWNER","SECTION_ID","SUB_SECTION_ID","PROPERTY_GROUP","PROPERTY","ATTRIBUTE","MANDATORY" from ITFRMVPG
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFRMVSC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFRMVSC" ("VIEW_ID", "FRAME_NO", "REVISION", "OWNER", "SECTION_ID", "SUB_SECTION_ID", "TYPE", "REF_ID", "SECTION_SEQUENCE_NO", "MANDATORY") AS 
  select "VIEW_ID","FRAME_NO","REVISION","OWNER","SECTION_ID","SUB_SECTION_ID","TYPE","REF_ID","SECTION_SEQUENCE_NO","MANDATORY" from ITFRMVSC
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITFUNCTION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITFUNCTION" ("FUNCTION_ID", "DESCRIPTION") AS 
  select "FUNCTION_ID","DESCRIPTION" from ITFUNCTION
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITIMP_CHANGES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITIMP_CHANGES" ("OBJECT_TYPE", "ITEM", "WHAT", "OLD_VALUE", "NEW_VALUE", "TIMESTAMP") AS 
  select "OBJECT_TYPE","ITEM","WHAT","OLD_VALUE","NEW_VALUE","TIMESTAMP" from ITIMP_CHANGES
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITIMP_LOG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITIMP_LOG" ("TYPE", "PART_NO", "REVISION", "OWNER", "TIMESTAMP") AS 
  select "TYPE","PART_NO","REVISION","OWNER","TIMESTAMP" from ITIMP_LOG
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITIMP_MAPPING
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITIMP_MAPPING" ("USER_ID", "REMAP_NAME", "REMAP_SEQ", "REMAP_TYPE", "REMAP_GROUP", "REMAP_ITEM", "ORIG_VALUE", "REMAP_VALUE") AS 
  select "USER_ID","REMAP_NAME","REMAP_SEQ","REMAP_TYPE","REMAP_GROUP","REMAP_ITEM","ORIG_VALUE","REMAP_VALUE" from ITIMP_MAPPING
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITIMPBOM
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITIMPBOM" ("IMPGETDATA_NO", "LINE_NO", "BOM_HEADER_DESC", "BOM_HEADER_BASE_QTY", "PLANT", "ALTERNATIVE", "ITEM_NUMBER", "COMPONENT_PART", "COMPONENT_REVISION", "COMPONENT_PLANT", "QUANTITY", "UOM", "CONV_FACTOR", "TO_UNIT", "YIELD", "ASSEMBLY_SCRAP", "COMPONENT_SCRAP", "LEAD_TIME_OFFSET", "ITEM_CATEGORY", "ISSUE_LOCATION", "CALC_FLAG", "BOM_ITEM_TYPE", "OPERATIONAL_STEP", "BOM_USAGE", "MIN_QTY", "MAX_QTY", "CHAR_1", "CHAR_2", "CODE", "ALT_GROUP", "ALT_PRIORITY", "NUM_1", "NUM_2", "NUM_3", "NUM_4", "NUM_5", "CHAR_3", "CHAR_4", "CHAR_5", "DATE_1", "DATE_2", "CH_1", "CH_2", "CH_3", "RELEVENCY_TO_COSTING", "BULK_MATERIAL", "FIXED_QTY", "BOOLEAN_1", "BOOLEAN_2", "BOOLEAN_3", "BOOLEAN_4", "MAKE_UP") AS 
  select "IMPGETDATA_NO","LINE_NO","BOM_HEADER_DESC","BOM_HEADER_BASE_QTY","PLANT","ALTERNATIVE","ITEM_NUMBER","COMPONENT_PART","COMPONENT_REVISION","COMPONENT_PLANT","QUANTITY","UOM","CONV_FACTOR","TO_UNIT","YIELD","ASSEMBLY_SCRAP","COMPONENT_SCRAP","LEAD_TIME_OFFSET","ITEM_CATEGORY","ISSUE_LOCATION","CALC_FLAG","BOM_ITEM_TYPE","OPERATIONAL_STEP","BOM_USAGE","MIN_QTY","MAX_QTY","CHAR_1","CHAR_2","CODE","ALT_GROUP","ALT_PRIORITY","NUM_1","NUM_2","NUM_3","NUM_4","NUM_5","CHAR_3","CHAR_4","CHAR_5","DATE_1","DATE_2","CH_1","CH_2","CH_3","RELEVENCY_TO_COSTING","BULK_MATERIAL","FIXED_QTY","BOOLEAN_1","BOOLEAN_2","BOOLEAN_3","BOOLEAN_4","MAKE_UP" from ITIMPBOM
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITIMPLOG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITIMPLOG" ("IMPGETDATA_NO", "LINE_NO", "TIMESTAMP", "LOG_TYPE", "MESSAGE") AS 
  select "IMPGETDATA_NO","LINE_NO","TIMESTAMP","LOG_TYPE","MESSAGE" from ITIMPLOG
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITIMPPROP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITIMPPROP" ("IMPGETDATA_NO", "LINE_NO", "PROPERTY_GROUP", "PROPERTY", "ATTRIBUTE", "HEADER_ID", "VALUE_S", "VALUE_N", "LANG_ID") AS 
  select "IMPGETDATA_NO","LINE_NO","PROPERTY_GROUP","PROPERTY","ATTRIBUTE","HEADER_ID","VALUE_S","VALUE_N","LANG_ID" from ITIMPPROP
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITING
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITING" ("INGREDIENT", "DESCRIPTION", "INTL", "STATUS", "ING_TYPE", "RECFAC", "SOI", "ORG_ING", "REC_ING", "ALLERGEN") AS 
  select "INGREDIENT","DESCRIPTION","INTL","STATUS","ING_TYPE","RECFAC","SOI","ORG_ING","REC_ING","ALLERGEN" from ITING
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITING_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITING_H" ("INGREDIENT", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED", "ING_TYPE", "ES_SEQ_NO") AS 
  select "INGREDIENT","REVISION","LANG_ID","DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","MAX_REV","DATE_IMPORTED","ING_TYPE","ES_SEQ_NO" from ITING_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITINGCFG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITINGCFG" ("PID", "CID", "DESCRIPTION", "INTL", "STATUS", "CID_TYPE", "MAX_PCT", "ING_TYPE", "SUFFIX") AS 
  select "PID","CID","DESCRIPTION","INTL","STATUS","CID_TYPE","MAX_PCT","ING_TYPE","SUFFIX" from ITINGCFG
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITINGCFG_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITINGCFG_H" ("PID", "CID", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED", "ES_SEQ_NO") AS 
  select "PID","CID","REVISION","LANG_ID","DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","MAX_REV","DATE_IMPORTED","ES_SEQ_NO" from ITINGCFG_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITINGCTFA
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITINGCTFA" ("INGREDIENT", "REG_ID", "START_PG", "END_PG", "LIST_IND", "INTL") AS 
  select "INGREDIENT","REG_ID","START_PG","END_PG","LIST_IND","INTL" from ITINGCTFA
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITINGCTFA_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITINGCTFA_H" ("INGREDIENT", "REG_ID", "START_PG", "END_PG", "LIST_IND", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "DATE_IMPORTED", "ACTION", "INTL") AS 
  select "INGREDIENT","REG_ID","START_PG","END_PG","LIST_IND","LAST_MODIFIED_ON","LAST_MODIFIED_BY","DATE_IMPORTED","ACTION","INTL" from ITINGCTFA_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITINGD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITINGD" ("INGREDIENT", "PID", "CID", "INTL", "PREF") AS 
  select "INGREDIENT","PID","CID","INTL","PREF" from ITINGD
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITINGD_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITINGD_H" ("INGREDIENT", "PID", "CID", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "DATE_IMPORTED", "ACTION", "PREF", "INTL") AS 
  select "INGREDIENT","PID","CID","LAST_MODIFIED_ON","LAST_MODIFIED_BY","DATE_IMPORTED","ACTION","PREF","INTL" from ITINGD_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITINGEXPLOSION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITINGEXPLOSION" ("BOM_EXP_NO", "MOP_SEQUENCE_NO", "SEQUENCE_NO", "ING_SEQUENCE_NO", "BOM_LEVEL", "INGREDIENT", "REVISION", "DESCRIPTION", "ING_QTY", "ING_LEVEL", "ING_COMMENT", "PID", "HIER_LEVEL", "RECFAC", "ING_SYNONYM", "ING_SYNONYM_REV", "ACTIVE", "COMPONENT_PART_NO", "COMPONENT_REVISION", "COMPONENT_DESCRIPTION", "COMPONENT_PLANT", "COMPONENT_ALTERNATIVE", "COMPONENT_USAGE", "COMPONENT_CALC_QTY", "COMPONENT_UOM", "COMPONENT_CONV_FACTOR", "COMPONENT_TO_UNIT", "INGDECLARE") AS 
  select "BOM_EXP_NO","MOP_SEQUENCE_NO","SEQUENCE_NO","ING_SEQUENCE_NO","BOM_LEVEL","INGREDIENT","REVISION","DESCRIPTION","ING_QTY","ING_LEVEL","ING_COMMENT","PID","HIER_LEVEL","RECFAC","ING_SYNONYM","ING_SYNONYM_REV","ACTIVE","COMPONENT_PART_NO","COMPONENT_REVISION","COMPONENT_DESCRIPTION","COMPONENT_PLANT","COMPONENT_ALTERNATIVE","COMPONENT_USAGE","COMPONENT_CALC_QTY","COMPONENT_UOM","COMPONENT_CONV_FACTOR","COMPONENT_TO_UNIT","INGDECLARE" from ITINGEXPLOSION
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITINGGROUPD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITINGGROUPD" ("PID", "CID", "INTL", "CID_TYPE") AS 
  select "PID","CID","INTL","CID_TYPE" from ITINGGROUPD
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITINGGROUPD_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITINGGROUPD_H" ("PID", "CID", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "DATE_IMPORTED", "ACTION", "INTL", "CID_TYPE") AS 
  select "PID","CID","LAST_MODIFIED_ON","LAST_MODIFIED_BY","DATE_IMPORTED","ACTION","INTL","CID_TYPE" from ITINGGROUPD_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITINGNOTE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITINGNOTE" ("NOTE_ID", "DESCRIPTION", "TEXT", "INTL", "STATUS") AS 
  select "NOTE_ID","DESCRIPTION","TEXT","INTL","STATUS" from ITINGNOTE
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITINGNOTE_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITINGNOTE_H" ("NOTE_ID", "REVISION", "LANG_ID", "DESCRIPTION", "TEXT", "MAX_REV", "DATE_IMPORTED", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY") AS 
  select "NOTE_ID","REVISION","LANG_ID","DESCRIPTION","TEXT","MAX_REV","DATE_IMPORTED","LAST_MODIFIED_ON","LAST_MODIFIED_BY" from ITINGNOTE_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITINGREG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITINGREG" ("INGREDIENT", "REG_ID", "DESCRIPTION", "INTL") AS 
  select "INGREDIENT","REG_ID","DESCRIPTION","INTL" from ITINGREG
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITINGREG_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITINGREG_H" ("INGREDIENT", "REG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "DATE_IMPORTED", "ACTION", "INTL") AS 
  select "INGREDIENT","REG_ID","DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","DATE_IMPORTED","ACTION","INTL" from ITINGREG_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITINGSYNTYPES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITINGSYNTYPES" ("SYN_CID", "SYN_TYPE_CID") AS 
  select "SYN_CID","SYN_TYPE_CID" from ITINGSYNTYPES
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITINGSYNTYPES_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITINGSYNTYPES_H" ("SYN_CID", "SYN_TYPE_CID", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "DATE_IMPORTED", "ACTION") AS 
  select "SYN_CID","SYN_TYPE_CID","LAST_MODIFIED_ON","LAST_MODIFIED_BY","DATE_IMPORTED","ACTION" from ITINGSYNTYPES_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITITEMACCESS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITITEMACCESS" ("USER_GROUP_ID", "STATUS", "SPEC_TYPE", "SECTION_ID", "SUB_SECTION_ID", "ITEM_TYPE", "ITEM_ID", "ITEM_OWNER", "PROPERTY", "ATTRIBUTE", "ACCESS_LEVEL") AS 
  select "USER_GROUP_ID","STATUS","SPEC_TYPE","SECTION_ID","SUB_SECTION_ID","ITEM_TYPE","ITEM_ID","ITEM_OWNER","PROPERTY","ATTRIBUTE","ACCESS_LEVEL" from ITITEMACCESS
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITJOB
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITJOB" ("JOB", "START_DATE", "END_DATE", "JOB_ID") AS 
  select "JOB","START_DATE","END_DATE","JOB_ID" from ITJOB
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITJOBQ
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITJOBQ" ("USER_ID", "LOGDATE", "ERROR_MSG", "JOB_SEQ") AS 
  select "USER_ID","LOGDATE","ERROR_MSG","JOB_SEQ" from ITJOBQ
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITKW
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITKW" ("KW_ID", "DESCRIPTION", "KW_TYPE", "INTL", "STATUS", "KW_USAGE") AS 
  select "KW_ID","DESCRIPTION","KW_TYPE","INTL","STATUS","KW_USAGE" from ITKW
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITKW_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITKW_H" ("KW_ID", "REVISION", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "KW_TYPE", "KW_USAGE", "DATE_IMPORTED") AS 
  select "KW_ID","REVISION","DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","KW_TYPE","KW_USAGE","DATE_IMPORTED" from ITKW_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITKWAS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITKWAS" ("KW_ID", "CH_ID", "INTL") AS 
  select "KW_ID","CH_ID","INTL" from ITKWAS
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITKWAS_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITKWAS_H" ("KW_ID", "CH_ID", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "INTL", "ACTION") AS 
  select "KW_ID","CH_ID","LAST_MODIFIED_ON","LAST_MODIFIED_BY","INTL","ACTION" from ITKWAS_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITKWCH
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITKWCH" ("CH_ID", "DESCRIPTION", "INTL", "STATUS") AS 
  select "CH_ID","DESCRIPTION","INTL","STATUS" from ITKWCH
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITKWCH_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITKWCH_H" ("CH_ID", "REVISION", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "DATE_IMPORTED") AS 
  select "CH_ID","REVISION","DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","DATE_IMPORTED" from ITKWCH_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITKWFLT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITKWFLT" ("FILTER_ID", "KW_NO", "KW_ID", "KW_VALUE", "KW_VALUE_LIST", "KW_TYPE", "OPERATOR") AS 
  select "FILTER_ID","KW_NO","KW_ID","KW_VALUE","KW_VALUE_LIST","KW_TYPE","OPERATOR" from ITKWFLT
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITLABELLOG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITLABELLOG" ("LOG_ID", "LOG_NAME", "STATUS", "PART_NO", "REVISION", "PLANT", "ALTERNATIVE", "BOM_USAGE", "EXPLOSION_DATE", "CREATED_BY", "CREATED_ON", "LABEL", "SOI", "LANGUAGE_ID", "SYNONYM_TYPE", "LOGGINGXML", "LABELTYPE", "LABELXML", "LABELRTF") AS 
  select "LOG_ID","LOG_NAME","STATUS","PART_NO","REVISION","PLANT","ALTERNATIVE","BOM_USAGE","EXPLOSION_DATE","CREATED_BY","CREATED_ON","LABEL","SOI","LANGUAGE_ID","SYNONYM_TYPE","LOGGINGXML","LABELTYPE","LABELXML","LABELRTF" from ITLABELLOG
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITLABELLOGRESULTDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITLABELLOGRESULTDETAILS" ("LOG_ID", "SEQUENCE_NO", "PARENT_SEQUENCE_NO", "BOM_LEVEL", "INGREDIENT", "IS_IN_GROUP", "IS_IN_FUNCTION", "DESCRIPTION", "QUANTITY", "NOTE", "REC_FROM_ID", "REC_FROM_DESCRIPTION", "REC_WITH_ID", "REC_WITH_DESCRIPTION", "SHOW_REC", "ACTIVE_INGREDIENT", "QUID", "USE_PERC", "SHOW_ITEMS", "USE_PERC_REL", "USE_PERC_ABS", "USE_BRACKETS", "ALLERGEN", "SOI", "COMPLEX_LABEL_LOG_ID", "PARAGRAPH", "SORT_SEQUENCE_NO") AS 
  select "LOG_ID","SEQUENCE_NO","PARENT_SEQUENCE_NO","BOM_LEVEL","INGREDIENT","IS_IN_GROUP","IS_IN_FUNCTION","DESCRIPTION","QUANTITY","NOTE","REC_FROM_ID","REC_FROM_DESCRIPTION","REC_WITH_ID","REC_WITH_DESCRIPTION","SHOW_REC","ACTIVE_INGREDIENT","QUID","USE_PERC","SHOW_ITEMS","USE_PERC_REL","USE_PERC_ABS","USE_BRACKETS","ALLERGEN","SOI","COMPLEX_LABEL_LOG_ID","PARAGRAPH","SORT_SEQUENCE_NO" from ITLABELLOGRESULTDETAILS
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITLANG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITLANG" ("LANG_ID", "DESCRIPTION") AS 
  select "LANG_ID","DESCRIPTION" from ITLANG
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITLANGMAPPING
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITLANGMAPPING" ("EXT_LANG", "IS_LANG") AS 
  select "EXT_LANG","IS_LANG" from ITLANGMAPPING
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITLIMSCONFDT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITLIMSCONFDT" ("SEQ_NO", "LIMS_FIELD", "DESCRIPTION") AS 
  select "SEQ_NO","LIMS_FIELD","DESCRIPTION" from ITLIMSCONFDT
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITLIMSCONFKW
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITLIMSCONFKW" ("KW_ID", "UN_ID") AS 
  select "KW_ID","UN_ID" from ITLIMSCONFKW
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITLIMSCONFLY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITLIMSCONFLY" ("LAYOUT_ID", "LAYOUT_REV", "IS_COL", "PROPERTY", "UN_OBJECT", "UN_TYPE", "UN_ID") AS 
  select "LAYOUT_ID","LAYOUT_REV","IS_COL","PROPERTY","UN_OBJECT","UN_TYPE","UN_ID" from ITLIMSCONFLY
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITLIMSJOB_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITLIMSJOB_H" ("PLANT", "PART_NO", "REVISION", "DATE_READY", "DATE_PROCEED", "RESULT_PROCEED", "DATE_TRANSFERRED", "RESULT_TRANSFER", "TO_BE_TRANSFERRED", "DATE_LAST_UPDATED", "RESULT_LAST_UPDATE", "TO_BE_UPDATED") AS 
  select "PLANT","PART_NO","REVISION","DATE_READY","DATE_PROCEED","RESULT_PROCEED","DATE_TRANSFERRED","RESULT_TRANSFER","TO_BE_TRANSFERRED","DATE_LAST_UPDATED","RESULT_LAST_UPDATE","TO_BE_UPDATED" from ITLIMSJOB_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITLIMSPLANT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITLIMSPLANT" ("PLANT", "CONNECT_STRING", "LANG_ID", "LANG_ID_4ID") AS 
  select "PLANT","CONNECT_STRING","LANG_ID","LANG_ID_4ID" from ITLIMSPLANT
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITLIMSPPKEY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITLIMSPPKEY" ("DB", "PP_KEY_SEQ", "PATH") AS 
  select "DB","PP_KEY_SEQ","PATH" from ITLIMSPPKEY
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITLIMSTMP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITLIMSTMP" ("EN_TP", "EN_ID", "LIMS_TMP") AS 
  select "EN_TP","EN_ID","LIMS_TMP" from ITLIMSTMP
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITMESSAGE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITMESSAGE" ("MSG_ID", "CULTURE_ID", "DESCRIPTION", "MESSAGE", "MSG_LEVEL", "MSG_COMMENT") AS 
  select "MSG_ID","CULTURE_ID","DESCRIPTION","MESSAGE","MSG_LEVEL","MSG_COMMENT" from ITMESSAGE
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITMFC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITMFC" ("MFC_ID", "DESCRIPTION", "STATUS", "INTL", "MTP_ID") AS 
  select "MFC_ID","DESCRIPTION","STATUS","INTL","MTP_ID" from ITMFC
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITMFC_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITMFC_H" ("MFC_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "DATE_IMPORTED", "STATUS", "INTL", "MTP_ID", "ACTION") AS 
  select "MFC_ID","DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","DATE_IMPORTED","STATUS","INTL","MTP_ID","ACTION" from ITMFC_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITMFCKW
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITMFCKW" ("MFC_ID", "KW_ID", "KW_VALUE", "INTL") AS 
  select "MFC_ID","KW_ID","KW_VALUE","INTL" from ITMFCKW
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITMFCMPL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITMFCMPL" ("MPL_ID", "MFC_ID", "INTL", "STATUS") AS 
  select "MPL_ID","MFC_ID","INTL","STATUS" from ITMFCMPL
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITMFCMPLKW
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITMFCMPLKW" ("MFC_ID", "MPL_ID", "KW_ID", "KW_VALUE", "INTL") AS 
  select "MFC_ID","MPL_ID","KW_ID","KW_VALUE","INTL" from ITMFCMPLKW
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITMPL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITMPL" ("MPL_ID", "DESCRIPTION", "STATUS", "INTL") AS 
  select "MPL_ID","DESCRIPTION","STATUS","INTL" from ITMPL
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITMPL_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITMPL_H" ("MPL_ID", "DESCRIPTION", "STATUS", "INTL", "ACTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "DATE_IMPORTED") AS 
  select "MPL_ID","DESCRIPTION","STATUS","INTL","ACTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","DATE_IMPORTED" from ITMPL_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITMTP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITMTP" ("MTP_ID", "DESCRIPTION", "STATUS", "INTL") AS 
  select "MTP_ID","DESCRIPTION","STATUS","INTL" from ITMTP
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITNUTCONFIG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITNUTCONFIG" ("REF_TYPE", "FUNCTION_ID", "VALUE") AS 
  select "REF_TYPE","FUNCTION_ID","VALUE" from ITNUTCONFIG
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITNUTEXPLOSION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITNUTEXPLOSION" ("BOM_EXP_NO", "MOP_SEQUENCE_NO", "SEQUENCE_NO", "PART_NO", "REVISION", "PROPERTY_GROUP", "PROPERTY", "PROPERTY_REV", "ATTRIBUTE", "ATTRIBUTE_REV", "NUM_1", "NUM_2", "NUM_3", "NUM_4", "NUM_5", "NUM_6", "NUM_7", "NUM_8", "NUM_9", "NUM_10", "CHAR_1", "CHAR_2", "CHAR_3", "CHAR_4", "CHAR_5", "CHAR_6", "INFO", "BOOLEAN_1", "BOOLEAN_2", "BOOLEAN_3", "BOOLEAN_4", "DATE_1", "DATE_2", "CHARACTERISTIC_1", "CHARACTERISTIC_REV_1", "CHARACTERISTIC_2", "CHARACTERISTIC_REV_2", "CHARACTERISTIC_3", "CHARACTERISTIC_REV_3", "ASSOCIATION_1", "ASSOCIATION_REV_1", "ASSOCIATION_2", "ASSOCIATION_REV_2", "ASSOCIATION_3", "ASSOCIATION_REV_3", "TEST_METHOD", "TEST_METHOD_REV", "CALC_QTY", "UOM_ID", "UOM_REV", "PG_TYPE", "NUT_SEQUENCE_NO", "DISPLAY_NAME", "ROW_ID") AS 
  select "BOM_EXP_NO","MOP_SEQUENCE_NO","SEQUENCE_NO","PART_NO","REVISION","PROPERTY_GROUP","PROPERTY","PROPERTY_REV","ATTRIBUTE","ATTRIBUTE_REV","NUM_1","NUM_2","NUM_3","NUM_4","NUM_5","NUM_6","NUM_7","NUM_8","NUM_9","NUM_10","CHAR_1","CHAR_2","CHAR_3","CHAR_4","CHAR_5","CHAR_6","INFO","BOOLEAN_1","BOOLEAN_2","BOOLEAN_3","BOOLEAN_4","DATE_1","DATE_2","CHARACTERISTIC_1","CHARACTERISTIC_REV_1","CHARACTERISTIC_2","CHARACTERISTIC_REV_2","CHARACTERISTIC_3","CHARACTERISTIC_REV_3","ASSOCIATION_1","ASSOCIATION_REV_1","ASSOCIATION_2","ASSOCIATION_REV_2","ASSOCIATION_3","ASSOCIATION_REV_3","TEST_METHOD","TEST_METHOD_REV","CALC_QTY","UOM_ID","UOM_REV","PG_TYPE","NUT_SEQUENCE_NO","DISPLAY_NAME","ROW_ID" from ITNUTEXPLOSION
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITNUTEXPORTEDPANELS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITNUTEXPORTEDPANELS" ("LOG_ID", "SEQUENCE_NO", "PART_NO", "REVISION", "CREATED_ON") AS 
  select "LOG_ID","SEQUENCE_NO","PART_NO","REVISION","CREATED_ON" from ITNUTEXPORTEDPANELS
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITNUTFILTER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITNUTFILTER" ("ID", "NAME", "DESCRIPTION", "CREATED_ON") AS 
  select "ID","NAME","DESCRIPTION","CREATED_ON" from ITNUTFILTER
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITNUTFILTERDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITNUTFILTERDETAILS" ("ID", "SEQ", "PROPERTY_ID", "PROPERTY_REV", "ATTRIBUTE_ID", "ATTRIBUTE_REV", "VISIBLE") AS 
  select "ID","SEQ","PROPERTY_ID","PROPERTY_REV","ATTRIBUTE_ID","ATTRIBUTE_REV","VISIBLE" from ITNUTFILTERDETAILS
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITNUTLOG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITNUTLOG" ("LOG_ID", "LOG_NAME", "STATUS", "PART_NO", "REVISION", "PLANT", "ALTERNATIVE", "BOM_USAGE", "EXPLOSION_DATE", "REF_SPEC", "REF_REV", "LAYOUT_ID", "LAYOUT_REV", "CREATED_BY", "CREATED_ON", "LOGGINGXML", "SERVING_SIZE_ID", "SERVING_WEIGHT", "RESULT_WEIGHT", "DEC_SEP") AS 
  select "LOG_ID","LOG_NAME","STATUS","PART_NO","REVISION","PLANT","ALTERNATIVE","BOM_USAGE","EXPLOSION_DATE","REF_SPEC","REF_REV","LAYOUT_ID","LAYOUT_REV","CREATED_BY","CREATED_ON","LOGGINGXML","SERVING_SIZE_ID","SERVING_WEIGHT","RESULT_WEIGHT","DEC_SEP" from ITNUTLOG
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITNUTLOGRESULT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITNUTLOGRESULT" ("LOG_ID", "COL_ID", "ROW_ID", "VALUE", "PROPERTY", "PROPERTY_REV", "ATTRIBUTE", "ATTRIBUTE_REV") AS 
  select "LOG_ID","COL_ID","ROW_ID","VALUE","PROPERTY","PROPERTY_REV","ATTRIBUTE","ATTRIBUTE_REV" from ITNUTLOGRESULT
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITNUTLOGRESULTDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITNUTLOGRESULTDETAILS" ("LOG_ID", "COL_ID", "ROW_ID", "SEQ_NO", "PART_NO", "REVISION", "DISPLAY_NAME", "VALUE") AS 
  select "LOG_ID","COL_ID","ROW_ID","SEQ_NO","PART_NO","REVISION","DISPLAY_NAME","VALUE" from ITNUTLOGRESULTDETAILS
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITNUTLY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITNUTLY" ("LAYOUT_ID", "DESCRIPTION", "INTL", "STATUS", "CREATED_BY", "CREATED_ON", "LAST_MODIFIED_BY", "LAST_MODIFIED_ON", "REVISION") AS 
  select "LAYOUT_ID","DESCRIPTION","INTL","STATUS","CREATED_BY","CREATED_ON","LAST_MODIFIED_BY","LAST_MODIFIED_ON","REVISION" from ITNUTLY
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITNUTLYGROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITNUTLYGROUP" ("ID", "DESCRIPTION", "INTL", "STATUS") AS 
  select "ID","DESCRIPTION","INTL","STATUS" from ITNUTLYGROUP
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITNUTLYITEM
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITNUTLYITEM" ("LAYOUT_ID", "REVISION", "SEQ_NO", "COL_TYPE", "HEADER_ID", "HEADER_REV", "DATA_TYPE", "CALC_SEQ", "CALC_METHOD", "MODIFIABLE", "LENGTH", "GROUPING_ID") AS 
  select "LAYOUT_ID","REVISION","SEQ_NO","COL_TYPE","HEADER_ID","HEADER_REV","DATA_TYPE","CALC_SEQ","CALC_METHOD","MODIFIABLE","LENGTH","GROUPING_ID" from ITNUTLYITEM
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITNUTLYTYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITNUTLYTYPE" ("ID", "DESCRIPTION", "CUSTOM") AS 
  select "ID","DESCRIPTION","CUSTOM" from ITNUTLYTYPE
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITNUTNOTE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITNUTNOTE" ("NUT_NOTE_ID", "DESCRIPTION", "LONG_DESCRIPTION", "INTL", "STATUS") AS 
  select "NUT_NOTE_ID","DESCRIPTION","LONG_DESCRIPTION","INTL","STATUS" from ITNUTNOTE
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITNUTNOTE_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITNUTNOTE_H" ("NUT_NOTE_ID", "REVISION", "LANG_ID", "DESCRIPTION", "LONG_DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "ES_SEQ_NO") AS 
  select "NUT_NOTE_ID","REVISION","LANG_ID","DESCRIPTION","LONG_DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","MAX_REV","ES_SEQ_NO" from ITNUTNOTE_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITNUTPATH
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITNUTPATH" ("BOM_EXP_NO", "MOP_SEQUENCE_NO", "SEQUENCE_NO", "PART_NO", "REVISION", "SECTION_ID", "SUB_SECTION_ID", "PROPERTY_GROUP", "ALT_PART_NO", "ALT_REVISION", "NUT_XML", "DISPLAY_NAME", "BASE_QTY", "SERV_CONV_FACTOR", "SERV_VOL", "UOM", "CONV_FACTOR", "TO_UNIT", "CALC_QTY_WITH_SCRAP", "BOM_LEVEL", "ACCESS_STOP", "USE", "CALC_QTY", "RECURSIVE_STOP", "LOG_ID", "COL_ID") AS 
  select "BOM_EXP_NO","MOP_SEQUENCE_NO","SEQUENCE_NO","PART_NO","REVISION","SECTION_ID","SUB_SECTION_ID","PROPERTY_GROUP","ALT_PART_NO","ALT_REVISION","NUT_XML","DISPLAY_NAME","BASE_QTY","SERV_CONV_FACTOR","SERV_VOL","UOM","CONV_FACTOR","TO_UNIT","CALC_QTY_WITH_SCRAP","BOM_LEVEL","ACCESS_STOP","USE","CALC_QTY","RECURSIVE_STOP","LOG_ID","COL_ID" from ITNUTPATH
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITNUTPROPERTYCONFIG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITNUTPROPERTYCONFIG" ("REF_TYPE", "FUNCTION_ID", "PROPETY_ID", "ATTRIBUTE_ID") AS 
  select "REF_TYPE","FUNCTION_ID","PROPETY_ID","ATTRIBUTE_ID" from ITNUTPROPERTYCONFIG
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITNUTREFTYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITNUTREFTYPE" ("REF_TYPE", "PART_NO", "NAME", "SECTION_ID", "SUB_SECTION_ID", "PROPERTY_GROUP", "VALUE_COL", "NOTE", "ROUND_SECTION_ID", "ROUND_SUB_SECTION_ID", "ROUND_PROPERTY_GROUP", "ROUND_VALUE_COL", "ROUND_RDA_COL", "ENERGY_SECTION_ID", "ENERGY_SUB_SECTION_ID", "ENERGY_PROPERTY_GROUP", "ENERGY_KCAL_PROPERTY", "ENERGY_KJ_PROPERTY", "ENERGY_KCAL_ATTRIBUTE", "ENERGY_KJ_ATTRIBUTE", "SERVING_SECTION_ID", "SERVING_SUB_SECTION_ID", "SERVING_PROPERTY_GROUP", "SERVING_VALUE_COL", "ENERGY_KCAL_COL", "ENERGY_KJ_COL", "BASIC_WEIGHT_PROPERTY_GROUP", "BASIC_WEIGHT_PROPERTY", "BASIC_WEIGHT_VALUE_COL") AS 
  select "REF_TYPE","PART_NO","NAME","SECTION_ID","SUB_SECTION_ID","PROPERTY_GROUP","VALUE_COL","NOTE","ROUND_SECTION_ID","ROUND_SUB_SECTION_ID","ROUND_PROPERTY_GROUP","ROUND_VALUE_COL","ROUND_RDA_COL","ENERGY_SECTION_ID","ENERGY_SUB_SECTION_ID","ENERGY_PROPERTY_GROUP","ENERGY_KCAL_PROPERTY","ENERGY_KJ_PROPERTY","ENERGY_KCAL_ATTRIBUTE","ENERGY_KJ_ATTRIBUTE","SERVING_SECTION_ID","SERVING_SUB_SECTION_ID","SERVING_PROPERTY_GROUP","SERVING_VALUE_COL","ENERGY_KCAL_COL","ENERGY_KJ_COL","BASIC_WEIGHT_PROPERTY_GROUP","BASIC_WEIGHT_PROPERTY","BASIC_WEIGHT_VALUE_COL" from ITNUTREFTYPE
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITNUTRESULT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITNUTRESULT" ("BOM_EXP_NO", "COL_ID", "NUM_VAL", "STR_VAL", "PROPERTY", "PROPERTY_REV", "ATTRIBUTE", "ATTRIBUTE_REV", "DATE_VAL", "BOOLEAN_VAL", "LAYOUT_ID", "LAYOUT_REVISION", "MOP_SEQUENCE_NO", "ROW_ID", "DISPLAY_NAME", "DEC_SEP") AS 
  select "BOM_EXP_NO","COL_ID","NUM_VAL","STR_VAL","PROPERTY","PROPERTY_REV","ATTRIBUTE","ATTRIBUTE_REV","DATE_VAL","BOOLEAN_VAL","LAYOUT_ID","LAYOUT_REVISION","MOP_SEQUENCE_NO","ROW_ID","DISPLAY_NAME","DEC_SEP" from ITNUTRESULT
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITNUTRESULTDETAIL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITNUTRESULTDETAIL" ("BOM_EXP_NO", "MOP_SEQUENCE_NO", "ROW_ID", "COL_ID", "NUM_VAL", "STR_VAL", "DATE_VAL", "BOOLEAN_VAL", "PROPERTY", "PROPERTY_REV", "ATTRIBUTE", "ATTRIBUTE_REV", "LAYOUT_ID", "LAYOUT_REVISION", "DISPLAY_NAME", "PART_NO", "PART_REVISION", "CALC_QTY", "NOTE", "NOT_AVAILABLE") AS 
  select "BOM_EXP_NO","MOP_SEQUENCE_NO","ROW_ID","COL_ID","NUM_VAL","STR_VAL","DATE_VAL","BOOLEAN_VAL","PROPERTY","PROPERTY_REV","ATTRIBUTE","ATTRIBUTE_REV","LAYOUT_ID","LAYOUT_REVISION","DISPLAY_NAME","PART_NO","PART_REVISION","CALC_QTY","NOTE","NOT_AVAILABLE" from ITNUTRESULTDETAIL
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITNUTROUNDING
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITNUTROUNDING" ("CHARACTERISTIC_ID", "PROCEDURE_NAME") AS 
  select "CHARACTERISTIC_ID","PROCEDURE_NAME" from ITNUTROUNDING
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITOID
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITOID" ("OBJECT_ID", "REVISION", "OWNER", "STATUS", "CREATED_ON", "CREATED_BY", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "OBSOLESCENCE_DATE", "CURRENT_DATE", "OBJECT_WIDTH", "OBJECT_HEIGHT", "FILE_NAME", "FILE_SIZE", "VISUAL", "OLE_OBJECT", "FREE_OBJECT", "EXPORTED", "ACCESS_GROUP") AS 
  select "OBJECT_ID","REVISION","OWNER","STATUS","CREATED_ON","CREATED_BY","LAST_MODIFIED_ON","LAST_MODIFIED_BY","OBSOLESCENCE_DATE","CURRENT_DATE","OBJECT_WIDTH","OBJECT_HEIGHT","FILE_NAME","FILE_SIZE","VISUAL","OLE_OBJECT","FREE_OBJECT","EXPORTED","ACCESS_GROUP" from ITOID
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITOIH
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITOIH" ("OBJECT_ID", "OWNER", "LANG_ID", "SORT_DESC", "DESCRIPTION", "OBJECT_IMPORTED", "ALLOW_PHANTOM", "INTL", "ES_SEQ_NO") AS 
  select "OBJECT_ID","OWNER","LANG_ID","SORT_DESC","DESCRIPTION","OBJECT_IMPORTED","ALLOW_PHANTOM","INTL","ES_SEQ_NO" from ITOIH
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITOIHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITOIHS" ("OBJECT_ID", "REVISION", "OWNER", "ES_SEQ_NO", "USER_ID", "FORENAME", "LAST_NAME", "TIMESTAMP", "SIGN_FOR_ID", "SIGN_FOR", "SIGN_WHAT_ID", "SIGN_WHAT") AS 
  select "OBJECT_ID","REVISION","OWNER","ES_SEQ_NO","USER_ID","FORENAME","LAST_NAME","TIMESTAMP","SIGN_FOR_ID","SIGN_FOR","SIGN_WHAT_ID","SIGN_WHAT" from ITOIHS
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITOIKW
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITOIKW" ("OBJECT_ID", "OWNER", "KW_ID", "KW_VALUE", "INTL") AS 
  select "OBJECT_ID","OWNER","KW_ID","KW_VALUE","INTL" from ITOIKW
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITOIRAW
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITOIRAW" ("OBJECT_ID", "REVISION", "OWNER", "DESKTOP_OBJECT") AS 
  select "OBJECT_ID","REVISION","OWNER","DESKTOP_OBJECT" from ITOIRAW
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITPFLT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITPFLT" ("FILTER_ID", "PART_NO", "DESCRIPTION", "PLANT", "BASE_UOM", "PART_SOURCE", "BASE_CONV_FACTOR", "BASE_TO_UNIT", "PART_TYPE", "DATE_IMPORTED", "OBSOLETE", "ALT_PART_NO", "PART_OBSOLETE") AS 
  select "FILTER_ID","PART_NO","DESCRIPTION","PLANT","BASE_UOM","PART_SOURCE","BASE_CONV_FACTOR","BASE_TO_UNIT","PART_TYPE","DATE_IMPORTED","OBSOLETE","ALT_PART_NO","PART_OBSOLETE" from ITPFLT
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITPFLTD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITPFLTD" ("FILTER_ID", "USER_ID", "DESCRIPTION", "SORT_DESC", "OPTIONS", "DEFAULT_FLT") AS 
  select "FILTER_ID","USER_ID","DESCRIPTION","SORT_DESC","OPTIONS","DEFAULT_FLT" from ITPFLTD
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITPFLTOP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITPFLTOP" ("FILTER_ID", "LOG_PART_NO", "LOG_DESCRIPTION", "LOG_PLANT", "LOG_BASE_UOM", "LOG_PART_SOURCE", "LOG_BASE_CONV_FACTOR", "LOG_BASE_TO_UNIT", "LOG_PART_TYPE", "LOG_DATE_IMPORTED", "LOG_OBSOLETE", "LOG_ALT_PART_NO", "LOG_PART_OBSOLETE") AS 
  select "FILTER_ID","LOG_PART_NO","LOG_DESCRIPTION","LOG_PLANT","LOG_BASE_UOM","LOG_PART_SOURCE","LOG_BASE_CONV_FACTOR","LOG_BASE_TO_UNIT","LOG_PART_TYPE","LOG_DATE_IMPORTED","LOG_OBSOLETE","LOG_ALT_PART_NO","LOG_PART_OBSOLETE" from ITPFLTOP
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITPLGRP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITPLGRP" ("PLANTGROUP", "DESCRIPTION") AS 
  select "PLANTGROUP","DESCRIPTION" from ITPLGRP
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITPLGRPLIST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITPLGRPLIST" ("PLANTGROUP", "PLANT") AS 
  select "PLANTGROUP","PLANT" from ITPLGRPLIST
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITPLKW
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITPLKW" ("PL_ID", "KW_ID", "KW_VALUE", "INTL") AS 
  select "PL_ID","KW_ID","KW_VALUE","INTL" from ITPLKW
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITPRCL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITPRCL" ("PART_NO", "HIER_LEVEL", "MATL_CLASS_ID", "CODE", "TYPE") AS 
  select "PART_NO","HIER_LEVEL","MATL_CLASS_ID","CODE","TYPE" from ITPRCL
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITPRCL_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITPRCL_H" ("PART_NO", "HIER_LEVEL", "MATL_CLASS_ID", "CODE", "TYPE", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "FORENAME", "LAST_NAME") AS 
  select "PART_NO","HIER_LEVEL","MATL_CLASS_ID","CODE","TYPE","LAST_MODIFIED_ON","LAST_MODIFIED_BY","FORENAME","LAST_NAME" from ITPRCL_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITPRMFC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITPRMFC" ("PART_NO", "MFC_ID", "MPL_ID", "CLEARANCE_NO", "TRADE_NAME", "AUDIT_DATE", "AUDIT_FREQ", "INTL", "PRODUCT_CODE", "APPROVAL_DATE", "REVISION", "OBJECT_ID", "OBJECT_REVISION", "OBJECT_OWNER") AS 
  select "PART_NO","MFC_ID","MPL_ID","CLEARANCE_NO","TRADE_NAME","AUDIT_DATE","AUDIT_FREQ","INTL","PRODUCT_CODE","APPROVAL_DATE","REVISION","OBJECT_ID","OBJECT_REVISION","OBJECT_OWNER" from ITPRMFC
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITPRMFC_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITPRMFC_H" ("PART_NO", "LAST_MODIFIED_ON", "ACTION", "LAST_MODIFIED_BY", "MFC_ID", "MPL_ID", "CLEARANCE_NO", "TRADE_NAME", "AUDIT_DATE", "AUDIT_FREQ", "FORENAME", "LAST_NAME", "PRODUCT_CODE", "APPROVAL_DATE", "REVISION", "OBJECT_ID", "OBJECT_REVISION", "OBJECT_OWNER") AS 
  select "PART_NO","LAST_MODIFIED_ON","ACTION","LAST_MODIFIED_BY","MFC_ID","MPL_ID","CLEARANCE_NO","TRADE_NAME","AUDIT_DATE","AUDIT_FREQ","FORENAME","LAST_NAME","PRODUCT_CODE","APPROVAL_DATE","REVISION","OBJECT_ID","OBJECT_REVISION","OBJECT_OWNER" from ITPRMFC_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITPRNOTE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITPRNOTE" ("PART_NO", "TEXT") AS 
  select "PART_NO","TEXT" from ITPRNOTE
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITPRNOTE_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITPRNOTE_H" ("PART_NO", "TEXT", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "FORENAME", "LAST_NAME") AS 
  select "PART_NO","TEXT","LAST_MODIFIED_ON","LAST_MODIFIED_BY","FORENAME","LAST_NAME" from ITPRNOTE_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITPROBJ
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITPROBJ" ("PART_NO", "OBJECT_ID", "REVISION", "OWNER", "INTL") AS 
  select "PART_NO","OBJECT_ID","REVISION","OWNER","INTL" from ITPROBJ
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITPROBJ_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITPROBJ_H" ("PART_NO", "LAST_MODIFIED_ON", "ACTION", "LAST_MODIFIED_BY", "OBJECT_ID", "REVISION", "OWNER", "FORENAME", "LAST_NAME") AS 
  select "PART_NO","LAST_MODIFIED_ON","ACTION","LAST_MODIFIED_BY","OBJECT_ID","REVISION","OWNER","FORENAME","LAST_NAME" from ITPROBJ_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITPRPL_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITPRPL_H" ("PART_NO", "ACTION", "OLD_PLANT", "NEW_PLANT", "OLD_ISSUE_UOM", "NEW_ISSUE_UOM", "OLD_ASSEMBLY_SCRAP", "NEW_ASSEMBLY_SCRAP", "OLD_COMPONENT_SCRAP", "NEW_COMPONENT_SCRAP", "OLD_LEAD_TIME_OFFSET", "NEW_LEAD_TIME_OFFSET", "OLD_RELEVENCY_TO_COSTING", "NEW_RELEVENCY_TO_COSTING", "OLD_BULK_MATERIAL", "NEW_BULK_MATERIAL", "OLD_ITEM_CATEGORY", "NEW_ITEM_CATEGORY", "OLD_ISSUE_LOCATION", "NEW_ISSUE_LOCATION", "OLD_DISCONTINUATION_INDICATOR", "NEW_DISCONTINUATION_INDICATOR", "OLD_DISCONTINUATION_DATE", "NEW_DISCONTINUATION_DATE", "OLD_FOLLOW_ON_MATERIAL", "NEW_FOLLOW_ON_MATERIAL", "OLD_COMMODITY_CODE", "NEW_COMMODITY_CODE", "OLD_OPERATIONAL_STEP", "NEW_OPERATIONAL_STEP", "OLD_OBSOLETE", "NEW_OBSOLETE", "OLD_PLANT_ACCESS", "NEW_PLANT_ACCESS", "TIMESTAMP", "USER_ID", "FORENAME", "LAST_NAME", "OLD_COMPONENT_SCRAP_SYNC", "NEW_COMPONENT_SCRAP_SYNC") AS 
  select "PART_NO","ACTION","OLD_PLANT","NEW_PLANT","OLD_ISSUE_UOM","NEW_ISSUE_UOM","OLD_ASSEMBLY_SCRAP","NEW_ASSEMBLY_SCRAP","OLD_COMPONENT_SCRAP","NEW_COMPONENT_SCRAP","OLD_LEAD_TIME_OFFSET","NEW_LEAD_TIME_OFFSET","OLD_RELEVENCY_TO_COSTING","NEW_RELEVENCY_TO_COSTING","OLD_BULK_MATERIAL","NEW_BULK_MATERIAL","OLD_ITEM_CATEGORY","NEW_ITEM_CATEGORY","OLD_ISSUE_LOCATION","NEW_ISSUE_LOCATION","OLD_DISCONTINUATION_INDICATOR","NEW_DISCONTINUATION_INDICATOR","OLD_DISCONTINUATION_DATE","NEW_DISCONTINUATION_DATE","OLD_FOLLOW_ON_MATERIAL","NEW_FOLLOW_ON_MATERIAL","OLD_COMMODITY_CODE","NEW_COMMODITY_CODE","OLD_OPERATIONAL_STEP","NEW_OPERATIONAL_STEP","OLD_OBSOLETE","NEW_OBSOLETE","OLD_PLANT_ACCESS","NEW_PLANT_ACCESS","TIMESTAMP","USER_ID","FORENAME","LAST_NAME","OLD_COMPONENT_SCRAP_SYNC","NEW_COMPONENT_SCRAP_SYNC" from ITPRPL_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITPRSOURCE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITPRSOURCE" ("SOURCE") AS 
  select "SOURCE" from ITPRSOURCE
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITQ
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITQ" ("USER_ID", "STATUS", "PROGRESS", "START_DATE", "END_DATE", "JOB_DESCR") AS 
  select "USER_ID","STATUS","PROGRESS","START_DATE","END_DATE","JOB_DESCR" from ITQ
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITRDSTATUS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITRDSTATUS" ("STATUS", "SORT_DESC", "DESCRIPTION", "STATUS_TYPE") AS 
  select "STATUS","SORT_DESC","DESCRIPTION","STATUS_TYPE" from ITRDSTATUS
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITREPAC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITREPAC" ("REP_ID", "USER_GROUP_ID", "USER_ID", "ACCESS_TYPE") AS 
  select "REP_ID","USER_GROUP_ID","USER_ID","ACCESS_TYPE" from ITREPAC
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITREPARG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITREPARG" ("REP_ID", "REP_TYPE", "REP_ARG1", "REP_DT_1", "REP_ARG2", "REP_DT_2", "REP_ARG3", "REP_DT_3", "REP_ARG4", "REP_DT_4") AS 
  select "REP_ID","REP_TYPE","REP_ARG1","REP_DT_1","REP_ARG2","REP_DT_2","REP_ARG3","REP_DT_3","REP_ARG4","REP_DT_4" from ITREPARG
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITREPD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITREPD" ("REP_ID", "SORT_DESC", "DESCRIPTION", "INFO", "STATUS", "REP_TYPE", "BATCH_ALLOWED", "WEB_ALLOWED", "ADDON_ID", "TITLE", "CONFIDENTIAL_TEXT", "CS_ALLOWED", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY") AS 
  select "REP_ID","SORT_DESC","DESCRIPTION","INFO","STATUS","REP_TYPE","BATCH_ALLOWED","WEB_ALLOWED","ADDON_ID","TITLE","CONFIDENTIAL_TEXT","CS_ALLOWED","LAST_MODIFIED_ON","LAST_MODIFIED_BY" from ITREPD
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITREPDATA
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITREPDATA" ("REP_ID", "NREP_TYPE", "REF_ID", "REF_VER", "REF_OWNER", "INCLUDE", "SEQ", "HEADER", "HEADER_DESCR", "DISPLAY_FORMAT", "DISPLAY_FORMAT_REV", "INCL_OBJ") AS 
  select "REP_ID","NREP_TYPE","REF_ID","REF_VER","REF_OWNER","INCLUDE","SEQ","HEADER","HEADER_DESCR","DISPLAY_FORMAT","DISPLAY_FORMAT_REV","INCL_OBJ" from ITREPDATA
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITREPG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITREPG" ("REPG_ID", "DESCRIPTION") AS 
  select "REPG_ID","DESCRIPTION" from ITREPG
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITREPGHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITREPGHS" ("REPG_ID", "AUDIT_TRAIL_SEQ_NO", "USER_ID", "FORENAME", "LAST_NAME", "TIMESTAMP", "WHAT_ID", "WHAT") AS 
  select "REPG_ID","AUDIT_TRAIL_SEQ_NO","USER_ID","FORENAME","LAST_NAME","TIMESTAMP","WHAT_ID","WHAT" from ITREPGHS
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITREPGHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITREPGHSDETAILS" ("REPG_ID", "AUDIT_TRAIL_SEQ_NO", "SEQ_NO", "DETAILS") AS 
  select "REPG_ID","AUDIT_TRAIL_SEQ_NO","SEQ_NO","DETAILS" from ITREPGHSDETAILS
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITREPHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITREPHS" ("REP_ID", "AUDIT_TRAIL_SEQ_NO", "USER_ID", "FORENAME", "LAST_NAME", "TIMESTAMP", "WHAT_ID", "WHAT") AS 
  select "REP_ID","AUDIT_TRAIL_SEQ_NO","USER_ID","FORENAME","LAST_NAME","TIMESTAMP","WHAT_ID","WHAT" from ITREPHS
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITREPHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITREPHSDETAILS" ("REP_ID", "AUDIT_TRAIL_SEQ_NO", "SEQ_NO", "DETAILS") AS 
  select "REP_ID","AUDIT_TRAIL_SEQ_NO","SEQ_NO","DETAILS" from ITREPHSDETAILS
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITREPITEMS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITREPITEMS" ("REP_ID", "TYPE", "TEMPL_ID", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY") AS 
  select "REP_ID","TYPE","TEMPL_ID","LAST_MODIFIED_ON","LAST_MODIFIED_BY" from ITREPITEMS
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITREPITEMTYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITREPITEMTYPE" ("TYPE", "DESCRIPTION", "STANDARD", "DEFAULT_TEMPL_ID", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY") AS 
  select "TYPE","DESCRIPTION","STANDARD","DEFAULT_TEMPL_ID","LAST_MODIFIED_ON","LAST_MODIFIED_BY" from ITREPITEMTYPE
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITREPL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITREPL" ("REPG_ID", "REP_ID") AS 
  select "REPG_ID","REP_ID" from ITREPL
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITREPNSTDEF
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITREPNSTDEF" ("REP_ID", "NREP_TYPE", "NREP_D", "NREP_R", "NREP_L", "NREP_HL", "NREP_D_LANG", "NREP_L_LANG", "REMARKS") AS 
  select "REP_ID","NREP_TYPE","NREP_D","NREP_R","NREP_L","NREP_HL","NREP_D_LANG","NREP_L_LANG","REMARKS" from ITREPNSTDEF
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITREPRQ
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITREPRQ" ("REQ_ID", "PART_NO", "REVISION", "USER_ID", "REP_ID", "METRIC", "LANG_ID", "CULTURE", "GUI_LANG") AS 
  select "REQ_ID","PART_NO","REVISION","USER_ID","REP_ID","METRIC","LANG_ID","CULTURE","GUI_LANG" from ITREPRQ
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITREPRQARG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITREPRQARG" ("REQ_ID", "ARG", "ARG_VAL") AS 
  select "REQ_ID","ARG","ARG_VAL" from ITREPRQARG
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITREPSQL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITREPSQL" ("REP_ID", "SORT_DESC", "REP_SQL1", "REP_SQL2", "REP_SQL3") AS 
  select "REP_ID","SORT_DESC","REP_SQL1","REP_SQL2","REP_SQL3" from ITREPSQL
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITREPTEMPLATE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITREPTEMPLATE" ("TEMPL_ID", "TYPE", "DESCRIPTION", "PDF", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY") AS 
  select "TEMPL_ID","TYPE","DESCRIPTION","PDF","LAST_MODIFIED_ON","LAST_MODIFIED_BY" from ITREPTEMPLATE;
--------------------------------------------------------
--  DDL for View RPMV_ITREPTYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITREPTYPE" ("REP_TYPE", "SORT_DESC", "DESCRIPTION") AS 
  select "REP_TYPE","SORT_DESC","DESCRIPTION" from ITREPTYPE
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITRTHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITRTHS" ("REF_TEXT_TYPE", "TEXT_REVISION", "OWNER", "ES_SEQ_NO", "USER_ID", "FORENAME", "LAST_NAME", "TIMESTAMP", "SIGN_FOR_ID", "SIGN_FOR", "SIGN_WHAT_ID", "SIGN_WHAT") AS 
  select "REF_TEXT_TYPE","TEXT_REVISION","OWNER","ES_SEQ_NO","USER_ID","FORENAME","LAST_NAME","TIMESTAMP","SIGN_FOR_ID","SIGN_FOR","SIGN_WHAT_ID","SIGN_WHAT" from ITRTHS
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITRULESET
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITRULESET" ("RULE_ID", "NAME", "DESCRIPTION", "CREATED_ON", "RULE_TYPE", "RULESET") AS 
  select "RULE_ID","NAME","DESCRIPTION","CREATED_ON","RULE_TYPE","RULESET" from ITRULESET
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITRULETYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITRULETYPE" ("RULE_TYPE", "DESCRIPTION") AS 
  select "RULE_TYPE","DESCRIPTION" from ITRULETYPE
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITSAPPLRANGE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITSAPPLRANGE" ("LOGIC_IND", "FSFIX", "ID", "PLANTGROUP") AS 
  select "LOGIC_IND","FSFIX","ID","PLANTGROUP" from ITSAPPLRANGE
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITSAPPLRANGE_SS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITSAPPLRANGE_SS" ("RANGEID", "STATUS", "BS", "BU") AS 
  select "RANGEID","STATUS","BS","BU" from ITSAPPLRANGE_SS
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITSCCF
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITSCCF" ("WORKFLOW_GROUP_ID", "STATUS", "CF_ID", "CUSTOM") AS 
  select "WORKFLOW_GROUP_ID","STATUS","CF_ID","CUSTOM" from ITSCCF
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITSCHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITSCHS" ("PART_NO", "REVISION", "SECTION_ID", "SUB_SECTION_ID", "TIMESTAMP", "USER_ID", "FORENAME", "LAST_NAME") AS 
  select "PART_NO","REVISION","SECTION_ID","SUB_SECTION_ID","TIMESTAMP","USER_ID","FORENAME","LAST_NAME" from ITSCHS
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITSCUSRLOG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITSCUSRLOG" ("SESSION_ID", "USER_ID", "PART_NO", "REVISION", "VW_HANDLE", "SECTION_ID", "SUB_SECTION_ID", "TIMESTAMP", "UPD_TIMESTAMP") AS 
  select "SESSION_ID","USER_ID","PART_NO","REVISION","VW_HANDLE","SECTION_ID","SUB_SECTION_ID","TIMESTAMP","UPD_TIMESTAMP" from ITSCUSRLOG
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITSH_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITSH_H" ("PART_NO", "LAST_MODIFIED_ON") AS 
  select "PART_NO","LAST_MODIFIED_ON" from ITSH_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITSHCMP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITSHCMP" ("COMP_NO", "SECTION_ID", "SUB_SECTION_ID", "TYPE", "REF_ID", "REF_VER", "REF_OWNER", "REF_INFO", "REF_VER2", "REF_OWNER2", "PROPERTY_GROUP", "PROPERTY", "ATTRIBUTE", "HEADER", "PROPERTY_VALUE", "PROPERTY_VALUE2", "UOM_ID", "UOM_ID2", "TEST_METHOD", "TEST_METHOD2", "INTL", "SEQUENCE_NO", "COMP_REF", "COMP_RESULT", "PLANT", "LINE", "LINE_REV", "CONFIGURATION", "PROCESS_LINE_REV") AS 
  select "COMP_NO","SECTION_ID","SUB_SECTION_ID","TYPE","REF_ID","REF_VER","REF_OWNER","REF_INFO","REF_VER2","REF_OWNER2","PROPERTY_GROUP","PROPERTY","ATTRIBUTE","HEADER","PROPERTY_VALUE","PROPERTY_VALUE2","UOM_ID","UOM_ID2","TEST_METHOD","TEST_METHOD2","INTL","SEQUENCE_NO","COMP_REF","COMP_RESULT","PLANT","LINE","LINE_REV","CONFIGURATION","PROCESS_LINE_REV" from ITSHCMP
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITSHDEL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITSHDEL" ("PART_NO", "REVISION", "DELETION_DATE", "STATUS", "USER_ID", "FORENAME", "LAST_NAME") AS 
  select "PART_NO","REVISION","DELETION_DATE","STATUS","USER_ID","FORENAME","LAST_NAME" from ITSHDEL
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITSHEXT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITSHEXT" ("PART_NO", "REVISION", "SECTION_ID", "SUB_SECTION_ID", "TYPE", "REF_ID", "REF_VER", "REF_OWNER", "PROPERTY_GROUP", "PROPERTY", "ATTRIBUTE") AS 
  select "PART_NO","REVISION","SECTION_ID","SUB_SECTION_ID","TYPE","REF_ID","REF_VER","REF_OWNER","PROPERTY_GROUP","PROPERTY","ATTRIBUTE" from ITSHEXT
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITSHFLT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITSHFLT" ("FILTER_ID", "PART_NO", "REVISION", "STATUS", "DESCRIPTION", "PHASE_IN_DATE", "PLANNED_EFFECTIVE_DATE", "CRITICAL_EFFECTIVE_DATE", "ISSUED_DATE", "OBSOLESCENCE_DATE", "CHANGED_DATE", "BOM_CHANGED", "STATUS_CHANGE_DATE", "PHASE_IN_TOLERANCE", "CREATED_BY", "CREATED_ON", "LAST_MODIFIED_BY", "LAST_MODIFIED_ON", "FRAME_ID", "FRAME_REV", "ACCESS_GROUP", "WORKFLOW_GROUP_ID", "CLASS1_ID", "CLASS2_ID", "CLASS3_ID", "OWNER", "INT_FRAME_NO", "INT_FRAME_REV", "INT_PART_NO", "INT_PART_REV", "FRAME_OWNER", "INTL", "MULTILANG", "PLANT", "STATUS_TYPE", "SPEC_TYPE_GROUP", "ALT_PART_NO", "PED_IN_SYNC", "LANG_ID", "LANG_DESCR") AS 
  select "FILTER_ID","PART_NO","REVISION","STATUS","DESCRIPTION","PHASE_IN_DATE","PLANNED_EFFECTIVE_DATE","CRITICAL_EFFECTIVE_DATE","ISSUED_DATE","OBSOLESCENCE_DATE","CHANGED_DATE","BOM_CHANGED","STATUS_CHANGE_DATE","PHASE_IN_TOLERANCE","CREATED_BY","CREATED_ON","LAST_MODIFIED_BY","LAST_MODIFIED_ON","FRAME_ID","FRAME_REV","ACCESS_GROUP","WORKFLOW_GROUP_ID","CLASS1_ID","CLASS2_ID","CLASS3_ID","OWNER","INT_FRAME_NO","INT_FRAME_REV","INT_PART_NO","INT_PART_REV","FRAME_OWNER","INTL","MULTILANG","PLANT","STATUS_TYPE","SPEC_TYPE_GROUP","ALT_PART_NO","PED_IN_SYNC","LANG_ID","LANG_DESCR" from ITSHFLT
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITSHFLTD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITSHFLTD" ("FILTER_ID", "USER_ID", "DESCRIPTION", "SORT_DESC", "OPTIONS", "DEFAULT_FLT") AS 
  select "FILTER_ID","USER_ID","DESCRIPTION","SORT_DESC","OPTIONS","DEFAULT_FLT" from ITSHFLTD
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITSHFLTOP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITSHFLTOP" ("FILTER_ID", "LOG_PART_NO", "LOG_REVISION", "LOG_STATUS", "LOG_DESCRIPTION", "LOG_PHASE_IN_DATE", "LOG_PLANNED_EFFECTIVE_DATE", "LOG_CRITICAL_EFFECTIVE_DATE", "LOG_ISSUED_DATE", "LOG_OBSOLESCENCE_DATE", "LOG_CHANGED_DATE", "LOG_BOM_CHANGED", "LOG_STATUS_CHANGE_DATE", "LOG_PHASE_IN_TOLERANCE", "LOG_CREATED_BY", "LOG_CREATED_ON", "LOG_LAST_MODIFIED_BY", "LOG_LAST_MODIFIED_ON", "LOG_FRAME_ID", "LOG_FRAME_REV", "LOG_ACCESS_GROUP", "LOG_WORKFLOW_GROUP_ID", "LOG_CLASS1_ID", "LOG_CLASS2_ID", "LOG_CLASS3_ID", "LOG_OWNER", "LOG_INT_FRAME_NO", "LOG_INT_FRAME_REV", "LOG_INT_PART_NO", "LOG_INT_PART_REV", "LOG_FRAME_OWNER", "LOG_INTL", "LOG_MULTILANG", "LOG_PLANT", "LOG_STATUS_TYPE", "LOG_SPEC_TYPE_GROUP", "LOG_ALT_PART_NO", "LOG_PED_IN_SYNC", "LOG_LANG_DESCR", "LOG_LANG_ID") AS 
  select "FILTER_ID","LOG_PART_NO","LOG_REVISION","LOG_STATUS","LOG_DESCRIPTION","LOG_PHASE_IN_DATE","LOG_PLANNED_EFFECTIVE_DATE","LOG_CRITICAL_EFFECTIVE_DATE","LOG_ISSUED_DATE","LOG_OBSOLESCENCE_DATE","LOG_CHANGED_DATE","LOG_BOM_CHANGED","LOG_STATUS_CHANGE_DATE","LOG_PHASE_IN_TOLERANCE","LOG_CREATED_BY","LOG_CREATED_ON","LOG_LAST_MODIFIED_BY","LOG_LAST_MODIFIED_ON","LOG_FRAME_ID","LOG_FRAME_REV","LOG_ACCESS_GROUP","LOG_WORKFLOW_GROUP_ID","LOG_CLASS1_ID","LOG_CLASS2_ID","LOG_CLASS3_ID","LOG_OWNER","LOG_INT_FRAME_NO","LOG_INT_FRAME_REV","LOG_INT_PART_NO","LOG_INT_PART_REV","LOG_FRAME_OWNER","LOG_INTL","LOG_MULTILANG","LOG_PLANT","LOG_STATUS_TYPE","LOG_SPEC_TYPE_GROUP","LOG_ALT_PART_NO","LOG_PED_IN_SYNC","LOG_LANG_DESCR","LOG_LANG_ID" from ITSHFLTOP
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITSHHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITSHHS" ("PART_NO", "REVISION", "ES_SEQ_NO", "USER_ID", "FORENAME", "LAST_NAME", "TIMESTAMP", "SIGN_FOR_ID", "SIGN_FOR", "SIGN_WHAT_ID", "SIGN_WHAT") AS 
  select "PART_NO","REVISION","ES_SEQ_NO","USER_ID","FORENAME","LAST_NAME","TIMESTAMP","SIGN_FOR_ID","SIGN_FOR","SIGN_WHAT_ID","SIGN_WHAT" from ITSHHS
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITSHLY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITSHLY" ("LY_ID", "LY_TYPE", "DISPLAY_FORMAT") AS 
  select "LY_ID","LY_TYPE","DISPLAY_FORMAT" from ITSHLY
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITSHQ
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITSHQ" ("USER_ID", "PART_NO", "REVISION", "STATUS_TO", "TEXT", "USER_INTL", "WORKFLOW_GROUP_ID", "ACCESS_GROUP", "VIEW_ID", "FRAME_NO", "FRAME_OWNER", "NEW_VALUE_CHAR", "NEW_VALUE_NUM", "NEW_VALUE_DATE", "ES_SEQ_NO", "PLANT", "ALTERNATIVE", "SELECTED") AS 
  select "USER_ID","PART_NO","REVISION","STATUS_TO","TEXT","USER_INTL","WORKFLOW_GROUP_ID","ACCESS_GROUP","VIEW_ID","FRAME_NO","FRAME_OWNER","NEW_VALUE_CHAR","NEW_VALUE_NUM","NEW_VALUE_DATE","ES_SEQ_NO","PLANT","ALTERNATIVE","SELECTED" from ITSHQ
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITSHVALD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITSHVALD" ("PART_NO", "REVISION", "VAL_SEQ", "TYPE", "SECTION_ID", "SUB_SECTION_ID", "PROPERTY_GROUP", "PROPERTY", "ATTRIBUTE", "HEADER_ID", "REF_ID", "REF_OWNER") AS 
  select "PART_NO","REVISION","VAL_SEQ","TYPE","SECTION_ID","SUB_SECTION_ID","PROPERTY_GROUP","PROPERTY","ATTRIBUTE","HEADER_ID","REF_ID","REF_OWNER" from ITSHVALD
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITSMCLSTEPS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITSMCLSTEPS" ("GUID", "TYPE", "DESCRIPTION") AS 
  select "GUID","TYPE","DESCRIPTION" from ITSMCLSTEPS
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITSPFLT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITSPFLT" ("FILTER_ID", "PG", "SP", "ATT", "TM", "UM", "HDR", "PGSP", "OPERATOR", "VALUE1", "VALUE2", "DT") AS 
  select "FILTER_ID","PG","SP","ATT","TM","UM","HDR","PGSP","OPERATOR","VALUE1","VALUE2","DT" from ITSPFLT
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITSPFLTD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITSPFLTD" ("FILTER_ID", "USER_ID", "DESCRIPTION", "SORT_DESC", "OPTIONS", "DEFAULT_FLT") AS 
  select "FILTER_ID","USER_ID","DESCRIPTION","SORT_DESC","OPTIONS","DEFAULT_FLT" from ITSPFLTD
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITSPPHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITSPPHS" ("PART_NO", "REVISION", "SECTION_ID", "SUB_SECTION_ID", "PROPERTY_GROUP", "PROPERTY", "ATTRIBUTE", "TIMESTAMP", "USER_ID") AS 
  select "PART_NO","REVISION","SECTION_ID","SUB_SECTION_ID","PROPERTY_GROUP","PROPERTY","ATTRIBUTE","TIMESTAMP","USER_ID" from ITSPPHS
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITSSCF
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITSSCF" ("WORKFLOW_GROUP_ID", "CF_ID", "STATUS_TYPE", "S_FROM", "S_TO", "ALLOW_MODIFY") AS 
  select "WORKFLOW_GROUP_ID","CF_ID","STATUS_TYPE","S_FROM","S_TO","ALLOW_MODIFY" from ITSSCF
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITSSHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITSSHS" ("STATUS", "AUDIT_TRAIL_SEQ_NO", "USER_ID", "FORENAME", "LAST_NAME", "TIMESTAMP", "WHAT_ID", "WHAT") AS 
  select "STATUS","AUDIT_TRAIL_SEQ_NO","USER_ID","FORENAME","LAST_NAME","TIMESTAMP","WHAT_ID","WHAT" from ITSSHS
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITSSHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITSSHSDETAILS" ("STATUS", "AUDIT_TRAIL_SEQ_NO", "SEQ_NO", "DETAILS") AS 
  select "STATUS","AUDIT_TRAIL_SEQ_NO","SEQ_NO","DETAILS" from ITSSHSDETAILS
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITSTGRP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITSTGRP" ("GROUP_DESCR", "STATUS", "INTL") AS 
  select "GROUP_DESCR","STATUS","INTL" from ITSTGRP
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITTMTYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITTMTYPE" ("TM_TYPE", "DESCRIPTION", "INTL", "STATUS") AS 
  select "TM_TYPE","DESCRIPTION","INTL","STATUS" from ITTMTYPE
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITTSRESULTS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITTSRESULTS" ("TEXT_SEARCH_NO", "PART_NO", "REVISION", "SECTION_ID", "SUB_SECTION_ID", "REF_TYPE", "REF_ID", "REF_VER", "REF_OWNER", "PLANT", "ALTERNATIVE", "BOM_USAGE", "LANG_ID", "EXP_DATE", "SYN_TYPE", "LOG_ID", "ROW_ID", "COL_ID") AS 
  select "TEXT_SEARCH_NO","PART_NO","REVISION","SECTION_ID","SUB_SECTION_ID","REF_TYPE","REF_ID","REF_VER","REF_OWNER","PLANT","ALTERNATIVE","BOM_USAGE","LANG_ID","EXP_DATE","SYN_TYPE","LOG_ID","ROW_ID","COL_ID" from ITTSRESULTS
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITUGHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITUGHS" ("USER_GROUP_ID", "AUDIT_TRAIL_SEQ_NO", "USER_ID", "FORENAME", "LAST_NAME", "TIMESTAMP", "WHAT_ID", "WHAT") AS 
  select "USER_GROUP_ID","AUDIT_TRAIL_SEQ_NO","USER_ID","FORENAME","LAST_NAME","TIMESTAMP","WHAT_ID","WHAT" from ITUGHS
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITUGHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITUGHSDETAILS" ("USER_GROUP_ID", "AUDIT_TRAIL_SEQ_NO", "SEQ_NO", "DETAILS") AS 
  select "USER_GROUP_ID","AUDIT_TRAIL_SEQ_NO","SEQ_NO","DETAILS" from ITUGHSDETAILS
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITUMC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITUMC" ("UOM_ID", "UOM_ALT_ID", "CONV_FACTOR", "INTL", "STATUS", "CONV_FCT") AS 
  select "UOM_ID","UOM_ALT_ID","CONV_FACTOR","INTL","STATUS","CONV_FCT" from ITUMC
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITUMC_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITUMC_H" ("UOM_ID", "UOM_ALT_ID", "CONV_FACTOR", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "INTL", "ACTION") AS 
  select "UOM_ID","UOM_ALT_ID","CONV_FACTOR","LAST_MODIFIED_ON","LAST_MODIFIED_BY","INTL","ACTION" from ITUMC_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITUP" ("USER_ID", "PLANT") AS 
  select "USER_ID","PLANT" from ITUP
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITUS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITUS" ("USER_ID", "FORENAME", "LAST_NAME", "CREATED_ON", "DELETED_ON") AS 
  select "USER_ID","FORENAME","LAST_NAME","CREATED_ON","DELETED_ON" from ITUS
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITUSCAT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITUSCAT" ("CAT_ID", "DESCRIPTION", "STATUS") AS 
  select "CAT_ID","DESCRIPTION","STATUS" from ITUSCAT
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITUSHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITUSHS" ("USER_ID_CHANGED", "AUDIT_TRAIL_SEQ_NO", "USER_ID", "FORENAME", "LAST_NAME", "TIMESTAMP", "WHAT_ID", "WHAT") AS 
  select "USER_ID_CHANGED","AUDIT_TRAIL_SEQ_NO","USER_ID","FORENAME","LAST_NAME","TIMESTAMP","WHAT_ID","WHAT" from ITUSHS
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITUSHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITUSHSDETAILS" ("USER_ID_CHANGED", "AUDIT_TRAIL_SEQ_NO", "SEQ_NO", "DETAILS") AS 
  select "USER_ID_CHANGED","AUDIT_TRAIL_SEQ_NO","SEQ_NO","DETAILS" from ITUSHSDETAILS
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITUSLOC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITUSLOC" ("LOC_ID", "DESCRIPTION", "STATUS") AS 
  select "LOC_ID","DESCRIPTION","STATUS" from ITUSLOC
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITUSPREF
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITUSPREF" ("USER_ID", "SECTION_NAME", "PREF", "VALUE") AS 
  select "USER_ID","SECTION_NAME","PREF","VALUE" from ITUSPREF
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITUSPREFDEF
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITUSPREFDEF" ("SECTION_NAME", "PREF", "VALUE") AS 
  select "SECTION_NAME","PREF","VALUE" from ITUSPREFDEF
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITVERSIONINFO
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITVERSIONINFO" ("TYPE", "ID", "INSTALLED_ON", "DESCRIPTION") AS 
  select "TYPE","ID","INSTALLED_ON","DESCRIPTION" from ITVERSIONINFO
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITWEBRQ
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITWEBRQ" ("USER_ID", "PASSWORD", "REQ_ID", "PART_NO", "REVISION", "REP_ID", "METRIC", "LANG_ID", "GUI_LANG", "REPORTFORMAT") AS 
  select "USER_ID","PASSWORD","REQ_ID","PART_NO","REVISION","REP_ID","METRIC","LANG_ID","GUI_LANG","REPORTFORMAT" from ITWEBRQ
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITWGHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITWGHS" ("WORKFLOW_GROUP_ID", "AUDIT_TRAIL_SEQ_NO", "USER_ID", "FORENAME", "LAST_NAME", "TIMESTAMP", "WHAT_ID", "WHAT") AS 
  select "WORKFLOW_GROUP_ID","AUDIT_TRAIL_SEQ_NO","USER_ID","FORENAME","LAST_NAME","TIMESTAMP","WHAT_ID","WHAT" from ITWGHS
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITWGHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITWGHSDETAILS" ("WORKFLOW_GROUP_ID", "AUDIT_TRAIL_SEQ_NO", "SEQ_NO", "DETAILS") AS 
  select "WORKFLOW_GROUP_ID","AUDIT_TRAIL_SEQ_NO","SEQ_NO","DETAILS" from ITWGHSDETAILS
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITWTHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITWTHS" ("WORK_FLOW_ID", "AUDIT_TRAIL_SEQ_NO", "USER_ID", "FORENAME", "LAST_NAME", "TIMESTAMP", "WHAT_ID", "WHAT") AS 
  select "WORK_FLOW_ID","AUDIT_TRAIL_SEQ_NO","USER_ID","FORENAME","LAST_NAME","TIMESTAMP","WHAT_ID","WHAT" from ITWTHS
 ;
--------------------------------------------------------
--  DDL for View RPMV_ITWTHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITWTHSDETAILS" ("WORK_FLOW_ID", "AUDIT_TRAIL_SEQ_NO", "SEQ_NO", "DETAILS") AS 
  select "WORK_FLOW_ID","AUDIT_TRAIL_SEQ_NO","SEQ_NO","DETAILS" from ITWTHSDETAILS
 ;
--------------------------------------------------------
--  DDL for View RPMV_JRNL_SPECIFICATION_HEADER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_JRNL_SPECIFICATION_HEADER" ("PART_NO", "REVISION", "USER_ID", "TIMESTAMP", "OLD_PLANNED_EFFECTIVE_DATE", "OLD_PHASE_IN_TOLERANCE", "NEW_PLANNED_EFFECTIVE_DATE", "FORENAME", "LAST_NAME", "PLANT", "NEW_PHASE_IN_TOLERANCE") AS 
  select "PART_NO","REVISION","USER_ID","TIMESTAMP","OLD_PLANNED_EFFECTIVE_DATE","OLD_PHASE_IN_TOLERANCE","NEW_PLANNED_EFFECTIVE_DATE","FORENAME","LAST_NAME","PLANT","NEW_PHASE_IN_TOLERANCE" from JRNL_SPECIFICATION_HEADER
 ;
--------------------------------------------------------
--  DDL for View RPMV_LANGUAGES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_LANGUAGES" ("LANGUAGE") AS 
  select "LANGUAGE" from LANGUAGES
 ;
--------------------------------------------------------
--  DDL for View RPMV_LAYOUT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_LAYOUT" ("LAYOUT_ID", "DESCRIPTION", "INTL", "STATUS", "CREATED_BY", "CREATED_ON", "LAST_MODIFIED_BY", "LAST_MODIFIED_ON", "REVISION", "DATE_IMPORTED") AS 
  select "LAYOUT_ID","DESCRIPTION","INTL","STATUS","CREATED_BY","CREATED_ON","LAST_MODIFIED_BY","LAST_MODIFIED_ON","REVISION","DATE_IMPORTED" from LAYOUT
 ;
--------------------------------------------------------
--  DDL for View RPMV_LAYOUT_VALIDATION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_LAYOUT_VALIDATION" ("LAYOUT_ID", "FUNCTION_ID", "ARG1", "ARG2", "ARG3", "ARG4", "ARG5", "ARG6", "ARG7", "ARG8", "ARG9", "ARG10", "INTL", "REVISION") AS 
  select "LAYOUT_ID","FUNCTION_ID","ARG1","ARG2","ARG3","ARG4","ARG5","ARG6","ARG7","ARG8","ARG9","ARG10","INTL","REVISION" from LAYOUT_VALIDATION
 ;
--------------------------------------------------------
--  DDL for View RPMV_LIMITED
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_LIMITED" ("TABLE_NAME", "COL_SELECT", "COL_INSERT", "COL_UPDATE", "COL_DELETE") AS 
  select "TABLE_NAME","COL_SELECT","COL_INSERT","COL_UPDATE","COL_DELETE" from LIMITED
 ;
--------------------------------------------------------
--  DDL for View RPMV_LOCATION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_LOCATION" ("PLANT", "LOCATION", "DESCRIPTION") AS 
  select "PLANT","LOCATION","DESCRIPTION" from LOCATION
 ;
--------------------------------------------------------
--  DDL for View RPMV_LTCUSTOMCALCULATION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_LTCUSTOMCALCULATION" ("CUSTOMCALCULATION_ID", "CUSTOMCALCULATION_GUID", "DESCRIPTION", "PLUGINURL", "CLASSNAME", "INTL", "STATUS", "VALIDATIONFUNCTION") AS 
  SELECT 0 AS CUSTOMCALCULATION_ID, 
					 0 AS CUSTOMCALCULATION_GUID, 
					 'NO R&'||'D LIBRARY INSTALLED' AS DESCRIPTION, 
					 'NO R&'||'D LIBRARY INSTALLED' AS PLUGINURL, 
			       'NO R&'||'D LIBRARY INSTALLED' AS CLASSNAME, 
					 'N' AS INTL, 
			       0 AS STATUS, 
			       'NO R&'||'D LIBRARY INSTALLED' AS VALIDATIONFUNCTION 
			FROM DUAL

 ;
--------------------------------------------------------
--  DDL for View RPMV_LTCUSTOMCALCULATION_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_LTCUSTOMCALCULATION_H" ("CUSTOMCALCULATION_ID", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV") AS 
  SELECT 0 AS CUSTOMCALCULATION_ID, 
					 0 AS REVISION, 
					 1 AS LANG_ID, 
					 'NO R&'||'D LIBRARY INSTALLED' AS DESCRIPTION, 
					 SYSDATE AS LAST_MODIFIED_ON, 
					 USER AS LAST_MODIFIED_BY, 
					 0 AS MAX_REV 
			FROM DUAL

 ;
--------------------------------------------------------
--  DDL for View RPMV_LTCUSTOMCALCULATIONVALS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_LTCUSTOMCALCULATIONVALS" ("CUSTOMCALCULATION_ID", "VALUEDESCRIPTION", "SECTION_ID", "SUB_SECTION_ID", "PROPERTY_GROUP", "PROPERTY", "ATTRIBUTE", "VALUE") AS 
  SELECT 0 AS CUSTOMCALCULATION_ID, 
						 'NO R&'||'D LIBRARY INSTALLED' AS VALUEDESCRIPTION, 
						 0 AS SECTION_ID, 
						 0 AS SUB_SECTION_ID, 
						 0 AS PROPERTY_GROUP, 
						 0 AS PROPERTY, 0 AS ATTRIBUTE, 
						 'NO R&'||'D LIBRARY INSTALLED' AS VALUE 
				FROM DUAL

 ;
--------------------------------------------------------
--  DDL for View RPMV_LTFOOTNOTE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_LTFOOTNOTE" ("FOOTNOTE_ID", "PANEL_ID", "TEXT") AS 
  SELECT 0 AS FOOTNOTE_ID, 
					 0 AS PANEL_ID, 
					 'NO R&'||'D LIBRARY INSTALLED' AS TEXT 
			FROM DUAL

 ;
--------------------------------------------------------
--  DDL for View RPMV_LTFUNCTION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_LTFUNCTION" ("FUNCTION_ID", "DESCRIPTION") AS 
  SELECT 0 AS FUNCTION_ID, 
					 'NO R&'||'D LIBRARY INSTALLED' AS DESCRIPTION 
			FROM DUAL

 ;
--------------------------------------------------------
--  DDL for View RPMV_LTNUTCONFIG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_LTNUTCONFIG" ("REF_TYPE", "FUNCTION_ID", "VALUE") AS 
  SELECT 'NO R&'||'D LIBRARY INSTALLED' AS REF_TYPE, 
					  0 AS FUNCTION_ID, 
					  'NO R&'||'D LIBRARY INSTALLED' AS VALUE 
		   FROM DUAL

 ;
--------------------------------------------------------
--  DDL for View RPMV_LTNUTPROFILELOG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_LTNUTPROFILELOG" ("LOG_ID_FROM", "LOG_ID_TO") AS 
  SELECT 0 AS LOG_ID_FROM, 
				    0 AS LOG_ID_TO 
			FROM DUAL

 ;
--------------------------------------------------------
--  DDL for View RPMV_LTNUTPROPERTYCONFIG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_LTNUTPROPERTYCONFIG" ("REF_TYPE", "FUNCTION_ID", "PROPETY_ID", "ATTRIBUTE_ID") AS 
  SELECT 'NO R&'||'D LIBRARY INSTALLED' AS REF_TYPE, 
					  0 AS FUNCTION_ID, 
					  0 AS PROPETY_ID, 
					  0 AS ATTRIBUTE_ID 
			FROM DUAL

 ;
--------------------------------------------------------
--  DDL for View RPMV_MATERIAL_CLASS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_MATERIAL_CLASS" ("IDENTIFIER", "CODE", "LICENSE", "SHORT_NAME", "LONG_NAME", "DESCRIPTION", "CREATION_DATETIME", "MODIFICATION_DATETIME", "DELETION_DATETIME") AS 
  select "IDENTIFIER","CODE","LICENSE","SHORT_NAME","LONG_NAME","DESCRIPTION","CREATION_DATETIME","MODIFICATION_DATETIME","DELETION_DATETIME" from MATERIAL_CLASS
 ;
--------------------------------------------------------
--  DDL for View RPMV_MATERIAL_CLASS_B
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_MATERIAL_CLASS_B" ("IDENTIFIER", "LANG_ID", "BUBBLE", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY") AS 
  select "IDENTIFIER","LANG_ID","BUBBLE","LAST_MODIFIED_ON","LAST_MODIFIED_BY" from MATERIAL_CLASS_B
 ;
--------------------------------------------------------
--  DDL for View RPMV_MRP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_MRP" ("TABLE_NAME", "COL_SELECT", "COL_INSERT", "COL_UPDATE", "COL_DELETE") AS 
  select "TABLE_NAME","COL_SELECT","COL_INSERT","COL_UPDATE","COL_DELETE" from MRP
 ;
--------------------------------------------------------
--  DDL for View RPMV_PART_COST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_PART_COST" ("PART_NO", "PERIOD", "CURRENCY", "PRICE", "PRICE_TYPE", "UOM", "PLANT") AS 
  select "PART_NO","PERIOD","CURRENCY","PRICE","PRICE_TYPE","UOM","PLANT" from PART_COST
 ;
--------------------------------------------------------
--  DDL for View RPMV_PART_L
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_PART_L" ("PART_NO", "LANG_ID", "DESCRIPTION") AS 
  select "PART_NO","LANG_ID","DESCRIPTION" from PART_L
 ;
--------------------------------------------------------
--  DDL for View RPMV_PART_LOCATION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_PART_LOCATION" ("PART_NO", "PLANT", "LOCATION") AS 
  select "PART_NO","PLANT","LOCATION" from PART_LOCATION
 ;
--------------------------------------------------------
--  DDL for View RPMV_PED_GROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_PED_GROUP" ("PED_GROUP_ID", "DESCRIPTION", "PED", "PIT", "ACCESS_GROUP") AS 
  select "PED_GROUP_ID","DESCRIPTION","PED","PIT","ACCESS_GROUP" from PED_GROUP
 ;
--------------------------------------------------------
--  DDL for View RPMV_PRICE_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_PRICE_TYPE" ("PRICE_TYPE", "PERIOD") AS 
  select "PRICE_TYPE","PERIOD" from PRICE_TYPE
 ;
--------------------------------------------------------
--  DDL for View RPMV_PROCESS_LINE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_PROCESS_LINE" ("PLANT", "LINE", "CONFIGURATION", "DESCRIPTION", "STATUS", "INTL") AS 
  select "PLANT","LINE","CONFIGURATION","DESCRIPTION","STATUS","INTL" from PROCESS_LINE
 ;
--------------------------------------------------------
--  DDL for View RPMV_PROCESS_LINE_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_PROCESS_LINE_H" ("PLANT", "LINE", "CONFIGURATION", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED", "ES_SEQ_NO") AS 
  select "PLANT","LINE","CONFIGURATION","REVISION","LANG_ID","DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","MAX_REV","DATE_IMPORTED","ES_SEQ_NO" from PROCESS_LINE_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_PROCESS_LINE_STAGE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_PROCESS_LINE_STAGE" ("PLANT", "LINE", "CONFIGURATION", "STAGE", "SEQUENCE_NO", "RECIRCULATE_TO", "TEXT_TYPE", "DISPLAY_FORMAT", "INTL") AS 
  select "PLANT","LINE","CONFIGURATION","STAGE","SEQUENCE_NO","RECIRCULATE_TO","TEXT_TYPE","DISPLAY_FORMAT","INTL" from PROCESS_LINE_STAGE
 ;
--------------------------------------------------------
--  DDL for View RPMV_PROCESS_LINE_STAGE_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_PROCESS_LINE_STAGE_H" ("PLANT", "LINE", "CONFIGURATION", "STAGE", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "SEQUENCE_NO", "RECIRCULATE_TO", "TEXT_TYPE", "DISPLAY_FORMAT", "INTL", "ACTION") AS 
  select "PLANT","LINE","CONFIGURATION","STAGE","LAST_MODIFIED_ON","LAST_MODIFIED_BY","SEQUENCE_NO","RECIRCULATE_TO","TEXT_TYPE","DISPLAY_FORMAT","INTL","ACTION" from PROCESS_LINE_STAGE_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_PROPERTY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_PROPERTY" ("PROPERTY", "DESCRIPTION", "INTL", "STATUS") AS 
  select "PROPERTY","DESCRIPTION","INTL","STATUS" from PROPERTY
 ;
--------------------------------------------------------
--  DDL for View RPMV_PROPERTY_ASSOCIATION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_PROPERTY_ASSOCIATION" ("PROPERTY", "ASSOCIATION", "INTL") AS 
  select "PROPERTY","ASSOCIATION","INTL" from PROPERTY_ASSOCIATION
 ;
--------------------------------------------------------
--  DDL for View RPMV_PROPERTY_ASSOCIATION_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_PROPERTY_ASSOCIATION_H" ("PROPERTY", "ASSOCIATION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "INTL", "ACTION") AS 
  select "PROPERTY","ASSOCIATION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","INTL","ACTION" from PROPERTY_ASSOCIATION_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_PROPERTY_B
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_PROPERTY_B" ("PROPERTY", "REVISION", "LANG_ID", "BUBBLE", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY") AS 
  select "PROPERTY","REVISION","LANG_ID","BUBBLE","LAST_MODIFIED_ON","LAST_MODIFIED_BY" from PROPERTY_B
 ;
--------------------------------------------------------
--  DDL for View RPMV_PROPERTY_DISPLAY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_PROPERTY_DISPLAY" ("PROPERTY", "DISPLAY_FORMAT", "INTL") AS 
  select "PROPERTY","DISPLAY_FORMAT","INTL" from PROPERTY_DISPLAY
 ;
--------------------------------------------------------
--  DDL for View RPMV_PROPERTY_DISPLAY_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_PROPERTY_DISPLAY_H" ("PROPERTY", "DISPLAY_FORMAT", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "INTL", "ACTION") AS 
  select "PROPERTY","DISPLAY_FORMAT","LAST_MODIFIED_ON","LAST_MODIFIED_BY","INTL","ACTION" from PROPERTY_DISPLAY_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_PROPERTY_GROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_PROPERTY_GROUP" ("PROPERTY_GROUP", "DESCRIPTION", "DISPLAY_FORMAT", "INTL", "STATUS", "PG_TYPE") AS 
  select "PROPERTY_GROUP","DESCRIPTION","DISPLAY_FORMAT","INTL","STATUS","PG_TYPE" from PROPERTY_GROUP
 ;
--------------------------------------------------------
--  DDL for View RPMV_PROPERTY_GROUP_B
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_PROPERTY_GROUP_B" ("PROPERTY_GROUP", "REVISION", "LANG_ID", "BUBBLE", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY") AS 
  select "PROPERTY_GROUP","REVISION","LANG_ID","BUBBLE","LAST_MODIFIED_ON","LAST_MODIFIED_BY" from PROPERTY_GROUP_B
 ;
--------------------------------------------------------
--  DDL for View RPMV_PROPERTY_GROUP_DISPLAY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_PROPERTY_GROUP_DISPLAY" ("PROPERTY_GROUP", "DISPLAY_FORMAT", "INTL") AS 
  select "PROPERTY_GROUP","DISPLAY_FORMAT","INTL" from PROPERTY_GROUP_DISPLAY
 ;
--------------------------------------------------------
--  DDL for View RPMV_PROPERTY_GROUP_DISPLAY_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_PROPERTY_GROUP_DISPLAY_H" ("PROPERTY_GROUP", "DISPLAY_FORMAT", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "INTL", "ACTION") AS 
  select "PROPERTY_GROUP","DISPLAY_FORMAT","LAST_MODIFIED_ON","LAST_MODIFIED_BY","INTL","ACTION" from PROPERTY_GROUP_DISPLAY_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_PROPERTY_GROUP_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_PROPERTY_GROUP_H" ("PROPERTY_GROUP", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "PG_TYPE", "DATE_IMPORTED", "ES_SEQ_NO") AS 
  select "PROPERTY_GROUP","REVISION","LANG_ID","DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","MAX_REV","PG_TYPE","DATE_IMPORTED","ES_SEQ_NO" from PROPERTY_GROUP_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_PROPERTY_GROUP_LIST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_PROPERTY_GROUP_LIST" ("PROPERTY_GROUP", "PROPERTY", "MANDATORY", "INTL") AS 
  select "PROPERTY_GROUP","PROPERTY","MANDATORY","INTL" from PROPERTY_GROUP_LIST
 ;
--------------------------------------------------------
--  DDL for View RPMV_PROPERTY_GROUP_LIST_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_PROPERTY_GROUP_LIST_H" ("PROPERTY_GROUP", "PROPERTY", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "INTL", "MANDATORY", "ACTION") AS 
  select "PROPERTY_GROUP","PROPERTY","LAST_MODIFIED_ON","LAST_MODIFIED_BY","INTL","MANDATORY","ACTION" from PROPERTY_GROUP_LIST_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_PROPERTY_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_PROPERTY_H" ("PROPERTY", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED", "ES_SEQ_NO") AS 
  select "PROPERTY","REVISION","LANG_ID","DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","MAX_REV","DATE_IMPORTED","ES_SEQ_NO" from PROPERTY_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_PROPERTY_LAYOUT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_PROPERTY_LAYOUT" ("LAYOUT_ID", "HEADER_ID", "FIELD_ID", "INCLUDED", "START_POS", "LENGTH", "ALIGNMENT", "FORMAT_ID", "HEADER", "COLOR", "BOLD", "UNDERLINE", "INTL", "REVISION", "HEADER_REV", "DEF", "URL", "ATTACHED_SPEC") AS 
  select "LAYOUT_ID","HEADER_ID","FIELD_ID","INCLUDED","START_POS","LENGTH","ALIGNMENT","FORMAT_ID","HEADER","COLOR","BOLD","UNDERLINE","INTL","REVISION","HEADER_REV","DEF","URL","ATTACHED_SPEC" from PROPERTY_LAYOUT
 ;
--------------------------------------------------------
--  DDL for View RPMV_PROPERTY_TEST_METHOD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_PROPERTY_TEST_METHOD" ("TEST_METHOD", "PROPERTY", "INTL") AS 
  select "TEST_METHOD","PROPERTY","INTL" from PROPERTY_TEST_METHOD
 ;
--------------------------------------------------------
--  DDL for View RPMV_PROPERTY_TEST_METHOD_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_PROPERTY_TEST_METHOD_H" ("PROPERTY", "TEST_METHOD", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "INTL", "ACTION") AS 
  select "PROPERTY","TEST_METHOD","LAST_MODIFIED_ON","LAST_MODIFIED_BY","INTL","ACTION" from PROPERTY_TEST_METHOD_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_PROPERTYGROUP_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_PROPERTYGROUP_TYPE" ("ID", "PROPGRPTYPE") AS 
  SELECT ID,PROPGRPTYPE 
	   FROM RPMT_PROPERTYGROUP_TYPE

 ;
--------------------------------------------------------
--  DDL for View RPMV_REF_TEXT_KW
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_REF_TEXT_KW" ("REF_TEXT_TYPE", "KW_ID", "KW_VALUE", "INTL", "OWNER") AS 
  select "REF_TEXT_TYPE","KW_ID","KW_VALUE","INTL","OWNER" from REF_TEXT_KW
 ;
--------------------------------------------------------
--  DDL for View RPMV_REF_TEXT_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_REF_TEXT_TYPE" ("REF_TEXT_TYPE", "DESCRIPTION", "INTL", "ALLOW_PHANTOM", "LAST_MODIFIED_ON", "OWNER", "LANG_ID", "SORT_DESC", "ES_SEQ_NO") AS 
  select "REF_TEXT_TYPE","DESCRIPTION","INTL","ALLOW_PHANTOM","LAST_MODIFIED_ON","OWNER","LANG_ID","SORT_DESC","ES_SEQ_NO" from REF_TEXT_TYPE
 ;
--------------------------------------------------------
--  DDL for View RPMV_REFERENCE_TEXT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_REFERENCE_TEXT" ("REF_TEXT_TYPE", "TEXT_REVISION", "TEXT", "CREATED_BY", "CREATED_ON", "LAST_EDITED_BY", "LAST_EDITED_ON_FIELDS", "STATUS", "LAST_MODIFIED_ON", "OWNER", "EXPORTED", "LANG_ID", "OBSOLESCENCE_DATE", "CURRENT_DATE", "ACCESS_GROUP") AS 
  select "REF_TEXT_TYPE","TEXT_REVISION","TEXT","CREATED_BY","CREATED_ON","LAST_EDITED_BY","LAST_EDITED_ON_FIELDS","STATUS","LAST_MODIFIED_ON","OWNER","EXPORTED","LANG_ID","OBSOLESCENCE_DATE","CURRENT_DATE","ACCESS_GROUP" from REFERENCE_TEXT
 ;
--------------------------------------------------------
--  DDL for View RPMV_RMTSETTINGS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_RMTSETTINGS" ("SETTING", "VALUE", "COMPONENT", "DESCRIPTION", "DATA") AS 
  select "SETTING","VALUE","COMPONENT","DESCRIPTION","DATA" from RMTSETTINGS
 ;
--------------------------------------------------------
--  DDL for View RPMV_RPMT_DATA_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_RPMT_DATA_TYPE" ("FORMAT_ID", "TYPE") AS 
  select "FORMAT_ID","TYPE" from RPMT_DATA_TYPE
 ;
--------------------------------------------------------
--  DDL for View RPMV_RPMT_DISPLAYFORMAT_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_RPMT_DISPLAYFORMAT_TYPE" ("ID", "DISPLAYFORMATTYPE") AS 
  select "ID","DISPLAYFORMATTYPE" from RPMT_DISPLAYFORMAT_TYPE
 ;
--------------------------------------------------------
--  DDL for View RPMV_RPMT_FIXED_STATES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_RPMT_FIXED_STATES" ("STATUS", "FRAMES", "OBJECTSREFTEXTS", "GLOSSARY") AS 
  select "STATUS","FRAMES","OBJECTSREFTEXTS","GLOSSARY" from RPMT_FIXED_STATES
 ;
--------------------------------------------------------
--  DDL for View RPMV_RPMT_PROPERTYGROUP_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_RPMT_PROPERTYGROUP_TYPE" ("ID", "PROPGRPTYPE") AS 
  select "ID","PROPGRPTYPE" from RPMT_PROPERTYGROUP_TYPE
 ;
--------------------------------------------------------
--  DDL for View RPMV_RPMT_SECTION_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_RPMT_SECTION_TYPE" ("ID", "SECTIONTYPE") AS 
  select "ID","SECTIONTYPE" from RPMT_SECTION_TYPE
 ;
--------------------------------------------------------
--  DDL for View RPMV_RPMT_UOM_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_RPMT_UOM_TYPE" ("ID", "UOMTYPE") AS 
  select "ID","UOMTYPE" from RPMT_UOM_TYPE
 ;
--------------------------------------------------------
--  DDL for View RPMV_RPMT_USER_PROFILES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_RPMT_USER_PROFILES" ("PROFILE", "EDIT", "CHANGESTATUS", "OBJECTSREFTEXTS", "PLANTACCESS", "INTL", "MRPACCESS") AS 
  select "PROFILE","EDIT","CHANGESTATUS","OBJECTSREFTEXTS","PLANTACCESS","INTL","MRPACCESS" from RPMT_USER_PROFILES
 ;
--------------------------------------------------------
--  DDL for View RPMV_RTI_BOM_DISPLAY_DBFIELD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_RTI_BOM_DISPLAY_DBFIELD" ("ID", "DB_FIELD") AS 
  select "ID","DB_FIELD" from RTI_BOM_DISPLAY_DBFIELD
 ;
--------------------------------------------------------
--  DDL for View RPMV_RTI_BOMDISPLAYFORMAT_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_RTI_BOMDISPLAYFORMAT_TYPE" ("ID", "BOMFORMATTYPE") AS 
  select "ID","BOMFORMATTYPE" from RTI_BOMDISPLAYFORMAT_TYPE
 ;
--------------------------------------------------------
--  DDL for View RPMV_RTI_DATA_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_RTI_DATA_TYPE" ("FORMAT_ID", "TYPE") AS 
  select "FORMAT_ID","TYPE" from RTI_DATA_TYPE
 ;
--------------------------------------------------------
--  DDL for View RPMV_RTI_DISPLAY_FORMAT_TYPES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_RTI_DISPLAY_FORMAT_TYPES" ("ID", "DISPLAYFORMATTYPE") AS 
  select "ID","DISPLAYFORMATTYPE" from RTI_DISPLAY_FORMAT_TYPES
 ;
--------------------------------------------------------
--  DDL for View RPMV_RTI_DISPLAYFORMAT_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_RTI_DISPLAYFORMAT_TYPE" ("ID", "DISPLAYFORMATTYPE") AS 
  select "ID","DISPLAYFORMATTYPE" from RTI_DISPLAYFORMAT_TYPE
 ;
--------------------------------------------------------
--  DDL for View RPMV_RTI_FIXED_STATES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_RTI_FIXED_STATES" ("STATUS", "FRAMES", "OBJECTSREFTEXTS", "GLOSSARY") AS 
  select "STATUS","FRAMES","OBJECTSREFTEXTS","GLOSSARY" from RTI_FIXED_STATES
 ;
--------------------------------------------------------
--  DDL for View RPMV_RTI_FORMAT_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_RTI_FORMAT_TYPE" ("FORMAT_ID", "TYPE") AS 
  select "FORMAT_ID","TYPE" from RTI_FORMAT_TYPE
 ;
--------------------------------------------------------
--  DDL for View RPMV_RTI_INGREDIENTDETAIL_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_RTI_INGREDIENTDETAIL_TYPE" ("ID", "INGTYPE") AS 
  select "ID","INGTYPE" from RTI_INGREDIENTDETAIL_TYPE
 ;
--------------------------------------------------------
--  DDL for View RPMV_RTI_PROPERTYGROUP_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_RTI_PROPERTYGROUP_TYPE" ("ID", "PROPGRPTYPE") AS 
  select "ID","PROPGRPTYPE" from RTI_PROPERTYGROUP_TYPE
 ;
--------------------------------------------------------
--  DDL for View RPMV_RTI_SECTION_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_RTI_SECTION_TYPE" ("ID", "SECTIONTYPE") AS 
  select "ID","SECTIONTYPE" from RTI_SECTION_TYPE
 ;
--------------------------------------------------------
--  DDL for View RPMV_RTI_UOM_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_RTI_UOM_TYPE" ("ID", "UOMTYPE") AS 
  select "ID","UOMTYPE" from RTI_UOM_TYPE
 ;
--------------------------------------------------------
--  DDL for View RPMV_RTI_USER_PROFILES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_RTI_USER_PROFILES" ("PROFILE", "EDIT", "CHANGESTATUS", "OBJECTSREFTEXTS", "PLANTACCESS", "INTL", "MRPACCESS") AS 
  select "PROFILE","EDIT","CHANGESTATUS","OBJECTSREFTEXTS","PLANTACCESS","INTL","MRPACCESS" from RTI_USER_PROFILES
 ;
--------------------------------------------------------
--  DDL for View RPMV_SECTION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_SECTION" ("SECTION_ID", "DESCRIPTION", "INTL", "STATUS") AS 
  select "SECTION_ID","DESCRIPTION","INTL","STATUS" from SECTION
 ;
--------------------------------------------------------
--  DDL for View RPMV_SECTION_B
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_SECTION_B" ("SECTION_ID", "REVISION", "LANG_ID", "BUBBLE", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY") AS 
  select "SECTION_ID","REVISION","LANG_ID","BUBBLE","LAST_MODIFIED_ON","LAST_MODIFIED_BY" from SECTION_B
 ;
--------------------------------------------------------
--  DDL for View RPMV_SECTION_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_SECTION_H" ("SECTION_ID", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED", "ES_SEQ_NO") AS 
  select "SECTION_ID","REVISION","LANG_ID","DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","MAX_REV","DATE_IMPORTED","ES_SEQ_NO" from SECTION_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_SECTION_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_SECTION_TYPE" ("ID", "SECTIONTYPE") AS 
  SELECT ID,SECTIONTYPE 
     FROM RPMT_SECTION_TYPE

 ;
--------------------------------------------------------
--  DDL for View RPMV_SPEC_ACCESS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_SPEC_ACCESS" ("USER_ID", "ACCESS_GROUP", "MRP_UPDATE", "PLAN_ACCESS", "PROD_ACCESS", "PHASE_ACCESS") AS 
  select "USER_ID","ACCESS_GROUP","MRP_UPDATE","PLAN_ACCESS","PROD_ACCESS","PHASE_ACCESS" from SPEC_ACCESS
 ;
--------------------------------------------------------
--  DDL for View RPMV_SPEC_PED_GROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_SPEC_PED_GROUP" ("PED_GROUP_ID", "PART_NO", "REVISION") AS 
  select "PED_GROUP_ID","PART_NO","REVISION" from SPEC_PED_GROUP
 ;
--------------------------------------------------------
--  DDL for View RPMV_SPEC_PREFIX
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_SPEC_PREFIX" ("OWNER", "PREFIX", "DESTINATION", "WORKFLOW_GROUP_ID", "ACCESS_GROUP", "IMPORT_ALLOWED") AS 
  select "OWNER","PREFIX","DESTINATION","WORKFLOW_GROUP_ID","ACCESS_GROUP","IMPORT_ALLOWED" from SPEC_PREFIX
 ;
--------------------------------------------------------
--  DDL for View RPMV_SPEC_PREFIX_ACCESS_GROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_SPEC_PREFIX_ACCESS_GROUP" ("PREFIX", "ACCESS_GROUP") AS 
  select "PREFIX","ACCESS_GROUP" from SPEC_PREFIX_ACCESS_GROUP
 ;
--------------------------------------------------------
--  DDL for View RPMV_SPEC_PREFIX_DESCR
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_SPEC_PREFIX_DESCR" ("OWNER", "PREFIX", "DESCRIPTION", "PREFIX_TYPE") AS 
  select "OWNER","PREFIX","DESCRIPTION","PREFIX_TYPE" from SPEC_PREFIX_DESCR
 ;
--------------------------------------------------------
--  DDL for View RPMV_SPECDATA_CHECK
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_SPECDATA_CHECK" ("PART_NO", "REVISION", "SECTION_ID", "SUB_SECTION_ID", "PROPERTY_GROUP", "PROPERTY", "ATTRIBUTE", "HEADER_ID", "REASON") AS 
  select "PART_NO","REVISION","SECTION_ID","SUB_SECTION_ID","PROPERTY_GROUP","PROPERTY","ATTRIBUTE","HEADER_ID","REASON" from SPECDATA_CHECK
 ;
--------------------------------------------------------
--  DDL for View RPMV_SPECDATA_SERVER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_SPECDATA_SERVER" ("PART_NO", "REVISION", "DATE_PROCESSED", "SECTION_ID", "SUB_SECTION_ID") AS 
  select "PART_NO","REVISION","DATE_PROCESSED","SECTION_ID","SUB_SECTION_ID" from SPECDATA_SERVER
 ;
--------------------------------------------------------
--  DDL for View RPMV_SPECIFICATION_KW
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_SPECIFICATION_KW" ("PART_NO", "KW_ID", "KW_VALUE", "INTL") AS 
  select "PART_NO","KW_ID","KW_VALUE","INTL" from SPECIFICATION_KW
 ;
--------------------------------------------------------
--  DDL for View RPMV_SPECIFICATION_KW_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_SPECIFICATION_KW_H" ("PART_NO", "KW_ID", "KW_VALUE", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "ACTION", "FORENAME", "LAST_NAME") AS 
  select "PART_NO","KW_ID","KW_VALUE","LAST_MODIFIED_ON","LAST_MODIFIED_BY","ACTION","FORENAME","LAST_NAME" from SPECIFICATION_KW_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_SPECIFICATION_TO_APPROVE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_SPECIFICATION_TO_APPROVE" ("PART_NO", "REVISION", "STATUS") AS 
  select "PART_NO","REVISION","STATUS" from SPECIFICATION_TO_APPROVE
 ;
--------------------------------------------------------
--  DDL for View RPMV_STAGE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_STAGE" ("STAGE", "DESCRIPTION", "DISPLAY_FORMAT", "INTL", "STATUS") AS 
  select "STAGE","DESCRIPTION","DISPLAY_FORMAT","INTL","STATUS" from STAGE
 ;
--------------------------------------------------------
--  DDL for View RPMV_STAGE_DISPLAY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_STAGE_DISPLAY" ("STAGE", "DISPLAY_FORMAT", "INTL") AS 
  select "STAGE","DISPLAY_FORMAT","INTL" from STAGE_DISPLAY
 ;
--------------------------------------------------------
--  DDL for View RPMV_STAGE_DISPLAY_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_STAGE_DISPLAY_H" ("STAGE", "DISPLAY_FORMAT", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "INTL", "ACTION") AS 
  select "STAGE","DISPLAY_FORMAT","LAST_MODIFIED_ON","LAST_MODIFIED_BY","INTL","ACTION" from STAGE_DISPLAY_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_STAGE_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_STAGE_H" ("STAGE", "REVISION", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "LANG_ID", "MAX_REV", "DATE_IMPORTED", "ES_SEQ_NO") AS 
  select "STAGE","REVISION","DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","LANG_ID","MAX_REV","DATE_IMPORTED","ES_SEQ_NO" from STAGE_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_STAGE_LIST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_STAGE_LIST" ("STAGE", "PROPERTY", "MANDATORY", "INTL", "UOM_ID", "ASSOCIATION") AS 
  select "STAGE","PROPERTY","MANDATORY","INTL","UOM_ID","ASSOCIATION" from STAGE_LIST
 ;
--------------------------------------------------------
--  DDL for View RPMV_STAGE_LIST_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_STAGE_LIST_H" ("STAGE", "PROPERTY", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "INTL", "MANDATORY", "ACTION", "UOM_ID", "ASSOCIATION") AS 
  select "STAGE","PROPERTY","LAST_MODIFIED_ON","LAST_MODIFIED_BY","INTL","MANDATORY","ACTION","UOM_ID","ASSOCIATION" from STAGE_LIST_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_STATUS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_STATUS" ("STATUS", "SORT_DESC", "DESCRIPTION", "STATUS_TYPE", "PHASE_IN_STATUS", "EMAIL_TITLE", "PROMPT_FOR_REASON", "REASON_MANDATORY", "ES", "COLOR") AS 
  select "STATUS","SORT_DESC","DESCRIPTION","STATUS_TYPE","PHASE_IN_STATUS","EMAIL_TITLE","PROMPT_FOR_REASON","REASON_MANDATORY","ES","COLOR" from STATUS
 ;
--------------------------------------------------------
--  DDL for View RPMV_STATUS_HISTORY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_STATUS_HISTORY" ("PART_NO", "REVISION", "STATUS", "STATUS_DATE_TIME", "USER_ID", "SORT_SEQ", "REASON_ID", "FORENAME", "LAST_NAME", "ES_SEQ_NO") AS 
  select "PART_NO","REVISION","STATUS","STATUS_DATE_TIME","USER_ID","SORT_SEQ","REASON_ID","FORENAME","LAST_NAME","ES_SEQ_NO" from STATUS_HISTORY
 ;
--------------------------------------------------------
--  DDL for View RPMV_STATUS_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_STATUS_TYPE" ("STATUS_TYPE") AS 
  select "STATUS_TYPE" from STATUS_TYPE;
--------------------------------------------------------
--  DDL for View RPMV_SUB_SECTION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_SUB_SECTION" ("SUB_SECTION_ID", "DESCRIPTION", "INTL", "STATUS") AS 
  select "SUB_SECTION_ID","DESCRIPTION","INTL","STATUS" from SUB_SECTION
 ;
--------------------------------------------------------
--  DDL for View RPMV_SUB_SECTION_B
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_SUB_SECTION_B" ("SUB_SECTION_ID", "REVISION", "LANG_ID", "BUBBLE", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY") AS 
  select "SUB_SECTION_ID","REVISION","LANG_ID","BUBBLE","LAST_MODIFIED_ON","LAST_MODIFIED_BY" from SUB_SECTION_B
 ;
--------------------------------------------------------
--  DDL for View RPMV_SUB_SECTION_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_SUB_SECTION_H" ("SUB_SECTION_ID", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED", "ES_SEQ_NO") AS 
  select "SUB_SECTION_ID","REVISION","LANG_ID","DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","MAX_REV","DATE_IMPORTED","ES_SEQ_NO" from SUB_SECTION_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_TEST_METHOD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_TEST_METHOD" ("TEST_METHOD", "DESCRIPTION", "INTL", "STATUS", "LONG_DESCR") AS 
  select "TEST_METHOD","DESCRIPTION","INTL","STATUS","LONG_DESCR" from TEST_METHOD
 ;
--------------------------------------------------------
--  DDL for View RPMV_TEST_METHOD_CONDITION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_TEST_METHOD_CONDITION" ("TEST_METHOD", "SET_NO", "CONDITION", "INTL") AS 
  select "TEST_METHOD","SET_NO","CONDITION","INTL" from TEST_METHOD_CONDITION
 ;
--------------------------------------------------------
--  DDL for View RPMV_TEST_METHOD_CONDITION_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_TEST_METHOD_CONDITION_H" ("TEST_METHOD", "SET_NO", "CONDITION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "INTL", "ACTION") AS 
  select "TEST_METHOD","SET_NO","CONDITION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","INTL","ACTION" from TEST_METHOD_CONDITION_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_TEST_METHOD_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_TEST_METHOD_H" ("TEST_METHOD", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED", "LONG_DESCR", "ES_SEQ_NO") AS 
  select "TEST_METHOD","REVISION","LANG_ID","DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","MAX_REV","DATE_IMPORTED","LONG_DESCR","ES_SEQ_NO" from TEST_METHOD_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_TEXT_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_TEXT_TYPE" ("TEXT_TYPE", "DESCRIPTION", "PROCESS_FLAG", "INTL", "STATUS") AS 
  select "TEXT_TYPE","DESCRIPTION","PROCESS_FLAG","INTL","STATUS" from TEXT_TYPE
 ;
--------------------------------------------------------
--  DDL for View RPMV_TEXT_TYPE_B
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_TEXT_TYPE_B" ("TEXT_TYPE", "REVISION", "LANG_ID", "BUBBLE", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY") AS 
  select "TEXT_TYPE","REVISION","LANG_ID","BUBBLE","LAST_MODIFIED_ON","LAST_MODIFIED_BY" from TEXT_TYPE_B
 ;
--------------------------------------------------------
--  DDL for View RPMV_TEXT_TYPE_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_TEXT_TYPE_H" ("TEXT_TYPE", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED", "ES_SEQ_NO") AS 
  select "TEXT_TYPE","REVISION","LANG_ID","DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","MAX_REV","DATE_IMPORTED","ES_SEQ_NO" from TEXT_TYPE_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_TOAD_PLAN_TABLE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_TOAD_PLAN_TABLE" ("STATEMENT_ID", "PLAN_ID", "TIMESTAMP", "REMARKS", "OPERATION", "OPTIONS", "OBJECT_NODE", "OBJECT_OWNER", "OBJECT_NAME", "OBJECT_ALIAS", "OBJECT_INSTANCE", "OBJECT_TYPE", "OPTIMIZER", "SEARCH_COLUMNS", "ID", "PARENT_ID", "DEPTH", "POSITION", "COST", "CARDINALITY", "BYTES", "OTHER_TAG", "PARTITION_START", "PARTITION_STOP", "PARTITION_ID", "OTHER", "DISTRIBUTION", "CPU_COST", "IO_COST", "TEMP_SPACE", "ACCESS_PREDICATES", "FILTER_PREDICATES", "PROJECTION", "TIME", "QBLOCK_NAME", "OTHER_XML") AS 
  select "STATEMENT_ID","PLAN_ID","TIMESTAMP","REMARKS","OPERATION","OPTIONS","OBJECT_NODE","OBJECT_OWNER","OBJECT_NAME","OBJECT_ALIAS","OBJECT_INSTANCE","OBJECT_TYPE","OPTIMIZER","SEARCH_COLUMNS","ID","PARENT_ID","DEPTH","POSITION","COST","CARDINALITY","BYTES","OTHER_TAG","PARTITION_START","PARTITION_STOP","PARTITION_ID","OTHER","DISTRIBUTION","CPU_COST","IO_COST","TEMP_SPACE","ACCESS_PREDICATES","FILTER_PREDICATES","PROJECTION","TIME","QBLOCK_NAME","OTHER_XML" from TOAD_PLAN_TABLE
 ;
--------------------------------------------------------
--  DDL for View RPMV_UOM
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_UOM" ("UOM_ID", "DESCRIPTION", "INTL", "STATUS", "UOM_TYPE", "UOM_BASE") AS 
  select "UOM_ID","DESCRIPTION","INTL","STATUS","UOM_TYPE","UOM_BASE" from UOM
 ;
--------------------------------------------------------
--  DDL for View RPMV_UOM_ASSOCIATION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_UOM_ASSOCIATION" ("ASSOCIATION", "UOM", "LOWER_REJECT", "UPPER_REJECT", "INTL") AS 
  select "ASSOCIATION","UOM","LOWER_REJECT","UPPER_REJECT","INTL" from UOM_ASSOCIATION
 ;
--------------------------------------------------------
--  DDL for View RPMV_UOM_ASSOCIATION_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_UOM_ASSOCIATION_H" ("ASSOCIATION", "UOM", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "LOWER_REJECT", "UPPER_REJECT", "INTL", "ACTION") AS 
  select "ASSOCIATION","UOM","LAST_MODIFIED_ON","LAST_MODIFIED_BY","LOWER_REJECT","UPPER_REJECT","INTL","ACTION" from UOM_ASSOCIATION_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_UOM_B
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_UOM_B" ("UOM_ID", "REVISION", "LANG_ID", "BUBBLE", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY") AS 
  select "UOM_ID","REVISION","LANG_ID","BUBBLE","LAST_MODIFIED_ON","LAST_MODIFIED_BY" from UOM_B
 ;
--------------------------------------------------------
--  DDL for View RPMV_UOM_GROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_UOM_GROUP" ("UOM_GROUP", "DESCRIPTION", "INTL", "STATUS") AS 
  select "UOM_GROUP","DESCRIPTION","INTL","STATUS" from UOM_GROUP
 ;
--------------------------------------------------------
--  DDL for View RPMV_UOM_GROUP_B
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_UOM_GROUP_B" ("UOM_GROUP", "REVISION", "LANG_ID", "BUBBLE", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY") AS 
  select "UOM_GROUP","REVISION","LANG_ID","BUBBLE","LAST_MODIFIED_ON","LAST_MODIFIED_BY" from UOM_GROUP_B
 ;
--------------------------------------------------------
--  DDL for View RPMV_UOM_GROUP_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_UOM_GROUP_H" ("UOM_GROUP", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED", "ES_SEQ_NO") AS 
  select "UOM_GROUP","REVISION","LANG_ID","DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","MAX_REV","DATE_IMPORTED","ES_SEQ_NO" from UOM_GROUP_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_UOM_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_UOM_H" ("UOM_ID", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED", "ES_SEQ_NO") AS 
  select "UOM_ID","REVISION","LANG_ID","DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","MAX_REV","DATE_IMPORTED","ES_SEQ_NO" from UOM_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_UOM_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_UOM_TYPE" ("ID", "UOMTYPE") AS 
  SELECT ID,UOMTYPE 
     FROM RPMT_UOM_TYPE

 ;
--------------------------------------------------------
--  DDL for View RPMV_UOM_UOM_GROUP_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_UOM_UOM_GROUP_H" ("UOM_GROUP", "UOM_ID", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "INTL", "ACTION") AS 
  select "UOM_GROUP","UOM_ID","LAST_MODIFIED_ON","LAST_MODIFIED_BY","INTL","ACTION" from UOM_UOM_GROUP_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_UOMC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_UOMC" ("UOM_ID", "UOM_ALT_ID", "CONV_FACTOR", "CONV_FCT", "INTL", "STATUS") AS 
  select "UOM_ID","UOM_ALT_ID","CONV_FACTOR","CONV_FCT","INTL","STATUS" from UOMC
 ;
--------------------------------------------------------
--  DDL for View RPMV_UOMC_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_UOMC_H" ("UOM_ID", "UOM_ALT_ID", "CONV_FACTOR", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "INTL", "ACTION") AS 
  select "UOM_ID","UOM_ALT_ID","CONV_FACTOR","LAST_MODIFIED_ON","LAST_MODIFIED_BY","INTL","ACTION" from UOMC_H
 ;
--------------------------------------------------------
--  DDL for View RPMV_UPDATE_HISTORY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_UPDATE_HISTORY" ("TABLE_NAME", "LAST_UPDATE") AS 
  select "TABLE_NAME","LAST_UPDATE" from UPDATE_HISTORY
 ;
--------------------------------------------------------
--  DDL for View RPMV_USER_ACCESS_GROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_USER_ACCESS_GROUP" ("ACCESS_GROUP", "USER_GROUP_ID", "UPDATE_ALLOWED", "MRP_UPDATE") AS 
  select "ACCESS_GROUP","USER_GROUP_ID","UPDATE_ALLOWED","MRP_UPDATE" from USER_ACCESS_GROUP
 ;
--------------------------------------------------------
--  DDL for View RPMV_USER_GROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_USER_GROUP" ("USER_GROUP_ID", "DESCRIPTION", "SHORT_DESC") AS 
  select "USER_GROUP_ID","DESCRIPTION","SHORT_DESC" from USER_GROUP
 ;
--------------------------------------------------------
--  DDL for View RPMV_USER_GROUP_LIST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_USER_GROUP_LIST" ("USER_GROUP_ID", "USER_ID") AS 
  select "USER_GROUP_ID","USER_ID" from USER_GROUP_LIST
 ;
--------------------------------------------------------
--  DDL for View RPMV_USER_PROFILES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_USER_PROFILES" ("PROFILE", "EDIT", "CHANGESTATUS", "OBJECTSREFTEXTS", "PLANTACCESS", "INTL", "MRPACCESS") AS 
  SELECT PROFILE,EDIT,CHANGESTATUS,OBJECTSREFTEXTS,PLANTACCESS,INTL,MRPACCESS 
	  FROM RPMT_USER_PROFILES

 ;
--------------------------------------------------------
--  DDL for View RPMV_USER_WORKFLOW_GROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_USER_WORKFLOW_GROUP" ("WORKFLOW_GROUP_ID", "USER_GROUP_ID") AS 
  select "WORKFLOW_GROUP_ID","USER_GROUP_ID" from USER_WORKFLOW_GROUP
 ;
--------------------------------------------------------
--  DDL for View RPMV_USERS_APPROVED
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_USERS_APPROVED" ("PART_NO", "REVISION", "STATUS_DATE_TIME", "USER_ID", "STATUS", "APPROVED_DATE", "PASS_FAIL", "ES_SEQ_NO") AS 
  select "PART_NO","REVISION","STATUS_DATE_TIME","USER_ID","STATUS","APPROVED_DATE","PASS_FAIL","ES_SEQ_NO" from USERS_APPROVED
 ;
--------------------------------------------------------
--  DDL for View RPMV_VIEW_ONLY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_VIEW_ONLY" ("TABLE_NAME", "COL_SELECT", "COL_INSERT", "COL_UPDATE", "COL_DELETE") AS 
  select "TABLE_NAME","COL_SELECT","COL_INSERT","COL_UPDATE","COL_DELETE" from VIEW_ONLY
 ;
--------------------------------------------------------
--  DDL for View RPMV_VIEW_ONLY_BCK
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_VIEW_ONLY_BCK" ("TABLE_NAME", "COL_SELECT", "COL_INSERT", "COL_UPDATE", "COL_DELETE") AS 
  select "TABLE_NAME","COL_SELECT","COL_INSERT","COL_UPDATE","COL_DELETE" from VIEW_ONLY_BCK
 ;
--------------------------------------------------------
--  DDL for View RPMV_WORK_FLOW
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_WORK_FLOW" ("WORK_FLOW_ID", "STATUS", "NEXT_STATUS", "EXPORT_ERP") AS 
  select "WORK_FLOW_ID","STATUS","NEXT_STATUS","EXPORT_ERP" from WORK_FLOW
 ;
--------------------------------------------------------
--  DDL for View RPMV_WORK_FLOW_GROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_WORK_FLOW_GROUP" ("WORK_FLOW_ID", "DESCRIPTION", "INITIAL_STATUS") AS 
  select "WORK_FLOW_ID","DESCRIPTION","INITIAL_STATUS" from WORK_FLOW_GROUP
 ;
--------------------------------------------------------
--  DDL for View RPMV_WORK_FLOW_LIST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_WORK_FLOW_LIST" ("WORKFLOW_GROUP_ID", "STATUS", "USER_GROUP_ID", "ALL_TO_APPROVE", "SEND_MAIL", "EFF_DATE_MAIL", "EDITABLE") AS 
  select "WORKFLOW_GROUP_ID","STATUS","USER_GROUP_ID","ALL_TO_APPROVE","SEND_MAIL","EFF_DATE_MAIL","EDITABLE" from WORK_FLOW_LIST
 ;
--------------------------------------------------------
--  DDL for View RPMV_WORKFLOW_GROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_WORKFLOW_GROUP" ("WORKFLOW_GROUP_ID", "SORT_DESC", "DESCRIPTION", "WORK_FLOW_ID", "APPROVERS_NUMBER") AS 
  select "WORKFLOW_GROUP_ID","SORT_DESC","DESCRIPTION","WORK_FLOW_ID","APPROVERS_NUMBER" from WORKFLOW_GROUP
 ;
--------------------------------------------------------
--  DDL for View RPMV1_APPLICATION_USER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_APPLICATION_USER" ("USER_ID", "FORENAME", "LAST_NAME", "USER_INITIALS", "TELEPHONE_NO", "EMAIL_ADDRESS", "CURRENT_ONLY", "INITIAL_PROFILE", "USER_PROFILE", "USER_DROPPED", "PROD_ACCESS", "PLAN_ACCESS", "PHASE_ACCESS", "PRINTING_ALLOWED", "INTL", "FRAMES_ONLY", "REFERENCE_TEXT", "APPROVED_ONLY", "LOC_DESCRIPTION", "LOC_STATUS", "CAT_DESCRIPTION", "CAT_STATUS", "OVERRIDE_PART_VAL", "WEB_ALLOWED", "LIMITED_CONFIGURATOR", "PLANT_ACCESS", "VIEW_BOM", "HISTORIC_ONLY") AS 
  SELECT application_user.user_id,
       application_user.forename,
       application_user.last_name,
       application_user.user_initials,
       application_user.telephone_no,
       application_user.email_address,
       application_user.current_only,
       application_user.initial_profile,
       application_user.user_profile,
       application_user.user_dropped,
       application_user.prod_access,
       application_user.plan_access,
       application_user.phase_access,
       application_user.printing_allowed,
       application_user.intl,
       application_user.frames_only,
       application_user.reference_text,
       application_user.approved_only,
       itusloc.description loc_description,
       itusloc.status loc_status,
       ituscat.description cat_description,
       ituscat.status cat_status,
       application_user.override_part_val,
       application_user.web_allowed,
       application_user.limited_configurator,
       application_user.plant_access,
       application_user.view_bom,
       application_user.historic_only    
  FROM application_user, ituscat, itusloc
 WHERE ituscat.cat_id(+) = application_user.cat_id
   AND itusloc.loc_id(+) = application_user.loc_id

 ;
--------------------------------------------------------
--  DDL for View RPMV1_ASSOCIATION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_ASSOCIATION" ("ASSOCIATION", "INTL", "STATUS", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "ASSOCIATION_TYPE", "MAX_REV", "DATE_IMPORTED", "ES_SEQ_NO") AS 
  SELECT
  ass.association,
  ass.intl,
  ass.status,
  ass_h.revision,
  ass_h.lang_id,
  ass_h.description,
  ass_h.last_modified_on,
  ass_h.last_modified_by,
  ass_h.association_type,
  ass_h.max_rev,
  ass_h.date_imported,
  ass_h.es_seq_no
FROM
  association ass,
  association_h ass_h
WHERE
  ass.association = ass_h.association(+) and ass_h.max_rev=1

 ;
--------------------------------------------------------
--  DDL for View RPMV1_ATTRIBUTE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_ATTRIBUTE" ("ATTRIBUTE_ID", "INTL", "STATUS", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED") AS 
  SELECT
  att_h.ATTRIBUTE as attribute_id,
  att.intl,
  att.status,
  att_h.revision,
  att_h.lang_id,
  att_h.description,
  att_h.last_modified_on,
  att_h.last_modified_by,
  att_h.max_rev,
  att_h.date_imported
FROM
  ATTRIBUTE att,
  attribute_h att_h
WHERE
  att.ATTRIBUTE = att_h.ATTRIBUTE(+) and att_h.max_rev=1

 ;
--------------------------------------------------------
--  DDL for View RPMV1_AUDIT_ACCESS_GROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_AUDIT_ACCESS_GROUP" ("SORT_DESC", "USER_ID", "FORENAME", "LAST_NAME", "TIMESTAMP", "AUDIT_TRAIL_SEQ_NO", "SEQ_NO", "DETAILS") AS 
  SELECT "ACCESS_GROUP"."SORT_DESC",
       "ITAGHS"."USER_ID",
       "ITAGHS"."FORENAME",
       "ITAGHS"."LAST_NAME",
       "ITAGHS"."TIMESTAMP",
       "ITAGHSDETAILS"."AUDIT_TRAIL_SEQ_NO",
       "ITAGHSDETAILS"."SEQ_NO",
       "ITAGHSDETAILS"."DETAILS"
   FROM ACCESS_GROUP, ITAGHS,ITAGHSDETAILS
   WHERE ("ACCESS_GROUP"."ACCESS_GROUP"(+) = "ITAGHS"."ACCESS_GROUP")
   AND ("ITAGHS"."ACCESS_GROUP" = "ITAGHSDETAILS"."ACCESS_GROUP")
   AND ("ITAGHS"."AUDIT_TRAIL_SEQ_NO" = "ITAGHSDETAILS"."AUDIT_TRAIL_SEQ_NO")

 ;
--------------------------------------------------------
--  DDL for View RPMV1_AUDIT_PREFERENCES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_AUDIT_PREFERENCES" ("SECTION", "PARAMETER", "USER_ID", "FORENAME", "LAST_NAME", "TIMESTAMP", "SIGN_FOR", "SIGN_WHAT") AS 
  SELECT   "INTERSPC_CFG_H"."SECTION",
         "INTERSPC_CFG_H"."PARAMETER",
         "INTERSPC_CFG_H"."USER_ID",
         "INTERSPC_CFG_H"."FORENAME",
         "INTERSPC_CFG_H"."LAST_NAME",
         "INTERSPC_CFG_H"."TIMESTAMP",
         "INTERSPC_CFG_H"."SIGN_FOR",
         "INTERSPC_CFG_H"."SIGN_WHAT"
    FROM "INTERSPC_CFG_H", "INTERSPC_CFG"
   WHERE ("INTERSPC_CFG_H"."SECTION" = "INTERSPC_CFG"."SECTION")
     AND ("INTERSPC_CFG_H"."PARAMETER" = "INTERSPC_CFG"."PARAMETER")
     AND (("INTERSPC_CFG"."VISIBLE" = '1'))

 ;
--------------------------------------------------------
--  DDL for View RPMV1_AUDIT_REPORT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_AUDIT_REPORT" ("DESCRIPTION", "USER_ID", "FORENAME", "LAST_NAME", "TIMESTAMP", "AUDIT_TRAIL_SEQ_NO", "SEQ_NO", "DETAILS") AS 
  SELECT DECODE ("ITREPHS"."REP_ID",
               0, 'SQL',
               "ITREPD"."SORT_DESC"
              ) description,
       "ITREPHS"."USER_ID",
       "ITREPHS"."FORENAME",
       "ITREPHS"."LAST_NAME",
       "ITREPHS"."TIMESTAMP",
       "ITREPHSDETAILS"."AUDIT_TRAIL_SEQ_NO",
       "ITREPHSDETAILS"."SEQ_NO",
       "ITREPHSDETAILS"."DETAILS"
  FROM "ITREPD", "ITREPHS", "ITREPHSDETAILS"
 WHERE ("ITREPD"."REP_ID"(+) = "ITREPHS"."REP_ID")
   AND ("ITREPHS"."REP_ID" = "ITREPHSDETAILS"."REP_ID")
   AND ("ITREPHS"."AUDIT_TRAIL_SEQ_NO" = "ITREPHSDETAILS"."AUDIT_TRAIL_SEQ_NO")

 ;
--------------------------------------------------------
--  DDL for View RPMV1_AUDIT_REPORT_GROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_AUDIT_REPORT_GROUP" ("DESCRIPTION", "USER_ID", "FORENAME", "LAST_NAME", "TIMESTAMP", "AUDIT_TRAIL_SEQ_NO", "SEQ_NO", "DETAILS") AS 
  SELECT "ITREPG"."DESCRIPTION",
       "ITREPGHS"."USER_ID",
       "ITREPGHS"."FORENAME",
       "ITREPGHS"."LAST_NAME",
       "ITREPGHS"."TIMESTAMP",
       "ITREPGHSDETAILS"."AUDIT_TRAIL_SEQ_NO",
       "ITREPGHSDETAILS"."SEQ_NO",
       "ITREPGHSDETAILS"."DETAILS"
  FROM "ITREPG", "ITREPGHS", "ITREPGHSDETAILS"
 WHERE ("ITREPG"."REPG_ID"(+) = "ITREPGHS"."REPG_ID")
   AND ("ITREPGHS"."REPG_ID" = "ITREPGHSDETAILS"."REPG_ID")
   AND ("ITREPGHS"."AUDIT_TRAIL_SEQ_NO" = "ITREPGHSDETAILS"."AUDIT_TRAIL_SEQ_NO")

 ;
--------------------------------------------------------
--  DDL for View RPMV1_AUDIT_STATUS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_AUDIT_STATUS" ("DESCRIPTION", "USER_ID", "FORENAME", "LAST_NAME", "TIMESTAMP", "SEQ_NO", "DETAILS") AS 
  SELECT "STATUS"."DESCRIPTION",
       "ITSSHS"."USER_ID",
       "ITSSHS"."FORENAME",
       "ITSSHS"."LAST_NAME",
       "ITSSHS"."TIMESTAMP",
       "ITSSHSDETAILS"."SEQ_NO",
       "ITSSHSDETAILS"."DETAILS"
  FROM "STATUS", "ITSSHS", "ITSSHSDETAILS"
 WHERE ("STATUS"."STATUS"(+) = "ITSSHS"."STATUS")
   AND ("ITSSHS"."STATUS" = "ITSSHSDETAILS"."STATUS")
   AND ("ITSSHS"."AUDIT_TRAIL_SEQ_NO" = "ITSSHSDETAILS"."AUDIT_TRAIL_SEQ_NO")

 ;
--------------------------------------------------------
--  DDL for View RPMV1_AUDIT_USER_CONFIG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_AUDIT_USER_CONFIG" ("USER_ID_CHANGED", "USER_ID", "FORENAME", "LAST_NAME", "TIMESTAMP", "AUDIT_TRAIL_SEQ_NO", "SEQ_NO", "DETAILS") AS 
  SELECT   ITUSHS.USER_ID_CHANGED,
         ITUSHS.USER_ID,
         ITUSHS.FORENAME,
         ITUSHS.LAST_NAME,
         ITUSHS.TIMESTAMP,
         ITUSHSDETAILS.AUDIT_TRAIL_SEQ_NO,
         ITUSHSDETAILS.SEQ_NO,
         ITUSHSDETAILS.DETAILS
    FROM ITUSHS, ITUSHSDETAILS
   WHERE (ITUSHS.USER_ID_CHANGED = ITUSHSDETAILS.USER_ID_CHANGED)
     AND (ITUSHS.AUDIT_TRAIL_SEQ_NO = ITUSHSDETAILS.AUDIT_TRAIL_SEQ_NO)

 ;
--------------------------------------------------------
--  DDL for View RPMV1_AUDIT_USER_GROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_AUDIT_USER_GROUP" ("SHORT_DESC", "USER_ID", "FORENAME", "LAST_NAME", "TIMESTAMP", "AUDIT_TRAIL_SEQ_NO", "SEQ_NO", "DETAILS") AS 
  SELECT   "USER_GROUP"."SHORT_DESC",
         "ITUGHS"."USER_ID",
         "ITUGHS"."FORENAME",
         "ITUGHS"."LAST_NAME",
         "ITUGHS"."TIMESTAMP",
         "ITUGHSDETAILS"."AUDIT_TRAIL_SEQ_NO",
         "ITUGHSDETAILS"."SEQ_NO",
         "ITUGHSDETAILS"."DETAILS"
    FROM "USER_GROUP", "ITUGHS", "ITUGHSDETAILS"
   WHERE ("USER_GROUP"."USER_GROUP_ID"(+) = "ITUGHS"."USER_GROUP_ID")
     AND ("ITUGHS"."USER_GROUP_ID" = "ITUGHSDETAILS"."USER_GROUP_ID")
     AND ("ITUGHS"."AUDIT_TRAIL_SEQ_NO" = "ITUGHSDETAILS"."AUDIT_TRAIL_SEQ_NO")

 ;
--------------------------------------------------------
--  DDL for View RPMV1_AUDIT_WORKFLOW_GROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_AUDIT_WORKFLOW_GROUP" ("SORT_DESC", "USER_ID", "FORENAME", "LAST_NAME", "TIMESTAMP", "SEQ_NO", "DETAILS", "AUDIT_TRAIL_SEQ_NO") AS 
  SELECT "WORKFLOW_GROUP"."SORT_DESC",
       "ITWGHS"."USER_ID",
       "ITWGHS"."FORENAME",
       "ITWGHS"."LAST_NAME",
       "ITWGHS"."TIMESTAMP",
       "ITWGHSDETAILS"."SEQ_NO",
       "ITWGHSDETAILS"."DETAILS",
       "ITWGHSDETAILS"."AUDIT_TRAIL_SEQ_NO"
  FROM "ITWGHS", "ITWGHSDETAILS", "WORKFLOW_GROUP"
 WHERE ("ITWGHS"."WORKFLOW_GROUP_ID" = "ITWGHSDETAILS"."WORKFLOW_GROUP_ID")
   AND ("ITWGHS"."AUDIT_TRAIL_SEQ_NO" = "ITWGHSDETAILS"."AUDIT_TRAIL_SEQ_NO")
   AND ("WORKFLOW_GROUP"."WORKFLOW_GROUP_ID"(+) = "ITWGHS"."WORKFLOW_GROUP_ID")

 ;
--------------------------------------------------------
--  DDL for View RPMV1_AUDIT_WORKFLOW_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_AUDIT_WORKFLOW_TYPE" ("DESCRIPTION", "USER_ID", "FORENAME", "LAST_NAME", "TIMESTAMP", "SEQ_NO", "DETAILS") AS 
  SELECT "WORK_FLOW_GROUP"."DESCRIPTION",
       "ITWTHS"."USER_ID",
       "ITWTHS"."FORENAME",
       "ITWTHS"."LAST_NAME",
       "ITWTHS"."TIMESTAMP",
       "ITWTHSDETAILS"."SEQ_NO",
       "ITWTHSDETAILS"."DETAILS"
  FROM "WORK_FLOW_GROUP", "ITWTHS", "ITWTHSDETAILS"
 WHERE ("WORK_FLOW_GROUP"."WORK_FLOW_ID"(+) = "ITWTHS"."WORK_FLOW_ID")
   AND ("ITWTHS"."WORK_FLOW_ID" = "ITWTHSDETAILS"."WORK_FLOW_ID")
   AND ("ITWTHS"."AUDIT_TRAIL_SEQ_NO" = "ITWTHSDETAILS"."AUDIT_TRAIL_SEQ_NO")

 ;
--------------------------------------------------------
--  DDL for View RPMV1_BOM_DISPLAY_SOURCE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_BOM_DISPLAY_SOURCE" ("SOURCE", "LAYOUT_ID") AS 
  select itprsource.SOURCE,LAYOUT_ID from itbomlysource, itprsource
   where itbomlysource.source(+)=itprsource.source

 ;
--------------------------------------------------------
--  DDL for View RPMV1_BOM_HEADER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_BOM_HEADER" ("PART_NO", "REVISION", "PLANT", "ALTERNATIVE", "BASE_QUANTITY", "DESCRIPTION", "YIELD", "CONV_FACTOR", "TO_UNIT", "CALC_FLAG", "BOM_TYPE", "BOM_USAGE", "MIN_QTY", "MAX_QTY", "PLANT_EFFECTIVE_DATE", "PREFERRED", "SECTION_ID", "SUB_SECTION_ID", "BASE_UOM") AS 
  SELECT bom."PART_NO", bom."REVISION", bom."PLANT", bom."ALTERNATIVE",
          bom."BASE_QUANTITY", bom."DESCRIPTION", bom."YIELD",
          bom."CONV_FACTOR", bom."TO_UNIT", bom."CALC_FLAG", bom."BOM_TYPE",
          bom."BOM_USAGE", bom."MIN_QTY", bom."MAX_QTY",
          bom."PLANT_EFFECTIVE_DATE", bom."PREFERRED", section_id,
          sub_section_id, part.base_uom
     FROM bom_header bom, specification_section sect, part
    WHERE sect.part_no = bom.part_no
      AND sect.revision = bom.revision
      AND bom.part_no = part.part_no
      AND sect.TYPE = 3

 ;
--------------------------------------------------------
--  DDL for View RPMV1_BOM_HEADER_LAYOUT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_BOM_HEADER_LAYOUT" ("LAYOUT_TYPE", "LAYOUT_ID", "DESCRIPTION", "INTL", "LAST_MODIFIED_BY", "LAST_MODIFIED_ON", "CREATED_BY", "CREATED_ON", "STATUS", "REVISION") AS 
  SELECT ITBOMLY.LAYOUT_TYPE, 
		 ITBOMLY.LAYOUT_ID,
         ITBOMLY.DESCRIPTION, 
		 ITBOMLY.INTL,
         ITBOMLY.LAST_MODIFIED_BY, 
		 ITBOMLY.LAST_MODIFIED_ON,
         ITBOMLY.CREATED_BY, 
		 ITBOMLY.CREATED_ON,
         RPMV1_FIXED_STATES.STATUS, 
		 ITBOMLY.REVISION
    FROM ITBOMLY,
         RPMV1_FIXED_STATES
   WHERE ITBOMLY.layout_type = 3
     AND ITBOMLY.STATUS = OBJECTSREFTEXTS(+)

 ;
--------------------------------------------------------
--  DDL for View RPMV1_BOM_ITEM
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_BOM_ITEM" ("PART_NO", "REVISION", "PLANT", "ALTERNATIVE", "ITEM_NUMBER", "COMPONENT_PART", "COMPONENT_REVISION", "COMPONENT_PLANT", "QUANTITY", "UOM", "CONV_FACTOR", "TO_UNIT", "YIELD", "ASSEMBLY_SCRAP", "COMPONENT_SCRAP", "LEAD_TIME_OFFSET", "ITEM_CATEGORY", "ISSUE_LOCATION", "CALC_FLAG", "BOM_ITEM_TYPE", "OPERATIONAL_STEP", "BOM_USAGE", "MIN_QTY", "MAX_QTY", "CHAR_1", "CHAR_2", "CODE", "ALT_GROUP", "ALT_PRIORITY", "NUM_1", "NUM_2", "NUM_3", "NUM_4", "NUM_5", "CHAR_3", "CHAR_4", "CHAR_5", "DATE_1", "DATE_2", "CH_1", "CH_REV_1", "CH_2", "CH_REV_2", "CH_3", "CH_REV_3", "RELEVENCY_TO_COSTING", "BULK_MATERIAL", "FIXED_QTY", "BOOLEAN_1", "BOOLEAN_2", "BOOLEAN_3", "BOOLEAN_4", "MAKE_UP", "INTL_EQUIVALENT", "COMPONENT_SCRAP_SYNC", "LAYOUT_ID", "LAYOUT_REV") AS 
  SELECT IVBOM_ITEM."PART_NO",IVBOM_ITEM."REVISION",IVBOM_ITEM."PLANT",IVBOM_ITEM."ALTERNATIVE",IVBOM_ITEM."ITEM_NUMBER",IVBOM_ITEM."COMPONENT_PART",IVBOM_ITEM."COMPONENT_REVISION",IVBOM_ITEM."COMPONENT_PLANT",IVBOM_ITEM."QUANTITY",IVBOM_ITEM."UOM",IVBOM_ITEM."CONV_FACTOR",IVBOM_ITEM."TO_UNIT",IVBOM_ITEM."YIELD",IVBOM_ITEM."ASSEMBLY_SCRAP",IVBOM_ITEM."COMPONENT_SCRAP",IVBOM_ITEM."LEAD_TIME_OFFSET",IVBOM_ITEM."ITEM_CATEGORY",IVBOM_ITEM."ISSUE_LOCATION",IVBOM_ITEM."CALC_FLAG",IVBOM_ITEM."BOM_ITEM_TYPE",IVBOM_ITEM."OPERATIONAL_STEP",IVBOM_ITEM."BOM_USAGE",IVBOM_ITEM."MIN_QTY",IVBOM_ITEM."MAX_QTY",IVBOM_ITEM."CHAR_1",IVBOM_ITEM."CHAR_2",IVBOM_ITEM."CODE",IVBOM_ITEM."ALT_GROUP",IVBOM_ITEM."ALT_PRIORITY",IVBOM_ITEM."NUM_1",IVBOM_ITEM."NUM_2",IVBOM_ITEM."NUM_3",IVBOM_ITEM."NUM_4",IVBOM_ITEM."NUM_5",IVBOM_ITEM."CHAR_3",IVBOM_ITEM."CHAR_4",IVBOM_ITEM."CHAR_5",IVBOM_ITEM."DATE_1",IVBOM_ITEM."DATE_2",IVBOM_ITEM."CH_1",IVBOM_ITEM."CH_REV_1",IVBOM_ITEM."CH_2",IVBOM_ITEM."CH_REV_2",IVBOM_ITEM."CH_3",IVBOM_ITEM."CH_REV_3",IVBOM_ITEM."RELEVENCY_TO_COSTING",IVBOM_ITEM."BULK_MATERIAL",IVBOM_ITEM."FIXED_QTY",IVBOM_ITEM."BOOLEAN_1",IVBOM_ITEM."BOOLEAN_2",IVBOM_ITEM."BOOLEAN_3",IVBOM_ITEM."BOOLEAN_4",IVBOM_ITEM."MAKE_UP",IVBOM_ITEM."INTL_EQUIVALENT",IVBOM_ITEM."COMPONENT_SCRAP_SYNC",
       NVL(DISPLAY_FORMAT,src.LAYOUT_ID) AS LAYOUT_ID,
	   DECODE(DISPLAY_FORMAT_REV,0,src.LAYOUT_REV,DISPLAY_FORMAT_REV) AS LAYOUT_REV
  FROM IVBOM_ITEM,
       IVSPECIFICATION_SECTION,
	   IVPART,
	   ITBOMLYSOURCE src
 WHERE IVBOM_ITEM.PART_NO = IVSPECIFICATION_SECTION.PART_NO
   AND IVBOM_ITEM.REVISION = IVSPECIFICATION_SECTION.REVISION
   AND IVSPECIFICATION_SECTION.TYPE = 3
   AND IVSPECIFICATION_SECTION.PART_NO = IVPART.PART_NO
   AND IVPART.PART_SOURCE = src.SOURCE
   AND src.LAYOUT_TYPE = 2
   AND src.PREFERRED = 1

 ;
--------------------------------------------------------
--  DDL for View RPMV1_BOM_ITEM_LAYOUT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_BOM_ITEM_LAYOUT" ("LAYOUT_TYPE", "LAYOUT_ID", "DESCRIPTION", "INTL", "LAST_MODIFIED_BY", "LAST_MODIFIED_ON", "CREATED_BY", "CREATED_ON", "STATUS", "REVISION", "DATE_IMPORTED") AS 
  SELECT   ITBOMLY.LAYOUT_TYPE, 
		 ITBOMLY.LAYOUT_ID,
         ITBOMLY.DESCRIPTION, 
		 ITBOMLY.INTL,
         ITBOMLY.LAST_MODIFIED_BY, 
		 ITBOMLY.LAST_MODIFIED_ON,
         ITBOMLY.CREATED_BY, 
		 ITBOMLY.CREATED_ON,
         RPMV1_FIXED_STATES.STATUS, 
		 ITBOMLY.REVISION,
		 ITBOMLY.DATE_IMPORTED
    FROM ITBOMLY,
         RPMV1_FIXED_STATES
   WHERE layout_type IN (1, 2)
     AND ITBOMLY.STATUS = OBJECTSREFTEXTS(+)

 ;
--------------------------------------------------------
--  DDL for View RPMV1_CHARACTERISTIC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_CHARACTERISTIC" ("CHARACTERISTIC_ID", "DESCRIPTION", "INTL", "STATUS", "LANG_ID", "REVISION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED") AS 
  SELECT
  cha.characteristic_id,
  cha_h.description,
  cha.intl,
  cha.status,
  cha_h.lang_id,
  cha_h.revision,
  cha_h.last_modified_on,
  cha_h.last_modified_by,
  cha_h.max_rev,
  cha_h.date_imported
FROM
  characteristic cha,
  characteristic_h cha_h
WHERE
  cha.characteristic_id = cha_h.characteristic_id(+)
  and cha_h.max_rev=1

 ;
--------------------------------------------------------
--  DDL for View RPMV1_CHEMICAL_REGISTRATION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_CHEMICAL_REGISTRATION" ("PID", "CID", "INTL", "STATUS", "CID_TYPE", "MAX_PCT", "ING_TYPE", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED", "ES_SEQ_NO") AS 
  SELECT itingcfg_h.pid,
          itingcfg_h.cid,
          itingcfg.intl,
          itingcfg.status,
          itingcfg.cid_type,
          itingcfg.max_pct,
          itingcfg.ing_type,
          itingcfg_h.revision,
          itingcfg_h.lang_id,
          itingcfg_h.description,
          itingcfg_h.last_modified_on,
          itingcfg_h.last_modified_by,
          itingcfg_h.max_rev,
          itingcfg_h.date_imported,
          itingcfg_h.es_seq_no
     FROM itingcfg_h, itingcfg
    WHERE itingcfg.cid = itingcfg_h.cid(+)
      AND itingcfg_h.pid = 0
      AND itingcfg_h.max_rev = 1

 ;
--------------------------------------------------------
--  DDL for View RPMV1_CL_ATTRIBUTES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_CL_ATTRIBUTES" ("LABEL", "CODE", "DESCR") AS 
  SELECT a.label, a.code, b.descr
  FROM itclat a, itclclf b
 WHERE a.attribute_id = b.ID
UNION
SELECT c.label, c.code, f_get_classification_path (e.cid)
  FROM itclat c, itcld d, itcltv e
 WHERE c.attribute_id = d.ID AND d.node = e.TYPE

 ;
--------------------------------------------------------
--  DDL for View RPMV1_CL_TREETYPES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_CL_TREETYPES" ("TREETYPE", "NODE", "ID") AS 
  SELECT DISTINCT itcld.spec_group AS treetype, itcld.node, itcld.ID
              FROM itcld itcld, class3 class3
             WHERE itcld.spec_group = class3.TYPE

 ;
--------------------------------------------------------
--  DDL for View RPMV1_CLASSIFICATION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_CLASSIFICATION" ("PART_NO", "NODE", "CF_SEQ") AS 
  SELECT sh.part_no, d.node, 1 AS cf_seq
     FROM ivspecification_header sh, class3 c3, itcld d
    WHERE sh.class3_id = c3.CLASS AND d.spec_group = c3.TYPE
   UNION
   SELECT a.part_no, AT.code, DECODE (AT.TYPE, 'TV', 2, 3) AS cf_seq
     FROM itprcl a, itclat AT
    WHERE a.TYPE = AT.code

 ;
--------------------------------------------------------
--  DDL for View RPMV1_CONDITION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_CONDITION" ("CONDITION_ID", "INTL", "STATUS", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED") AS 
  SELECT
  con.condition AS condition_id,
  con.intl,
  con.status,
  con_h.revision,
  con_h.lang_id,
  con_h.description,
  con_h.last_modified_on,
  con_h.last_modified_by,
  con_h.max_rev,
  con_h.date_imported
FROM
  condition con,
  condition_h con_h
WHERE
  con.condition = con_h.condition(+) and con_h.max_rev=1

 ;
--------------------------------------------------------
--  DDL for View RPMV1_DATA_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_DATA_TYPE" ("FORMAT_ID", "TYPE") AS 
  SELECT "FORMAT_ID","TYPE" FROM RPMT_DATA_TYPE

 ;
--------------------------------------------------------
--  DDL for View RPMV1_DB_PROFILES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_DB_PROFILES" ("OWNER", "DESCRIPTION", "DB_TYPE", "PARENTOWNER", "ALLOW_GLOSSARY", "ALLOW_FRAME_CHANGES", "ALLOW_FRAME_EXPORT", "REGION", "DEVISION", "LIVE_DB", "COUNTRY") AS 
  SELECT a.owner,
       a.description,
       a.db_type,
       b.DESCRIPTION as ParentOwner,
       a.allow_glossary,
       a.allow_frame_changes,
       a.allow_frame_export,
       a.region,
       a.devision,
       a.live_db,
       a.country
  FROM itdbprofile a, itdbprofile b
 WHERE a.parent_owner = b.owner(+)

 ;
--------------------------------------------------------
--  DDL for View RPMV1_DELETION_LOG_SPEC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_DELETION_LOG_SPEC" ("PART_NO", "REVISION", "DELETION_DATE", "USER_ID", "FULL_NAME", "STATUS", "DESCRIPTION") AS 
  SELECT "ITSHDEL"."PART_NO",
       "ITSHDEL"."REVISION",
       "ITSHDEL"."DELETION_DATE",
       "ITSHDEL"."USER_ID",
       "ITSHDEL"."FORENAME" || ' ' || "ITSHDEL"."LAST_NAME" full_name,
       "STATUS"."STATUS",
       "STATUS"."DESCRIPTION"
  FROM "ITSHDEL", "STATUS"
 WHERE ("ITSHDEL"."STATUS" = "STATUS"."STATUS")

 ;
--------------------------------------------------------
--  DDL for View RPMV1_DISPLAYFORMAT_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_DISPLAYFORMAT_TYPE" ("ID", "DISPLAYFORMATTYPE") AS 
  SELECT "ID","DISPLAYFORMATTYPE" 
FROM RPMT_DISPLAYFORMAT_TYPE

 ;
--------------------------------------------------------
--  DDL for View RPMV1_FCM_FRAMES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_FCM_FRAMES" ("FT_GROUP_ID", "FT_FRAME_ID", "OLD_FRAME_NO", "OLD_FRAME_REV_FROM", "OLD_FRAME_REV_TO", "OLD_FRAME_OWNER", "OLD_FRAME_OWNER_ID", "NEW_FRAME_NO", "NEW_FRAME_OWNER", "NEW_FRAME_OWNER_ID", "NEW_FRAME_REV_FROM", "NEW_FRAME_REV_TO") AS 
  SELECT "FT_FRAMES"."FT_GROUP_ID",
       "FT_FRAMES"."FT_FRAME_ID",
       "FT_FRAMES"."OLD_FRAME_NO",
       "FT_FRAMES"."OLD_FRAME_REV_FROM",
       "FT_FRAMES"."OLD_FRAME_REV_TO",
       old_owner.description AS old_frame_owner,
	   ft_frames.OLD_FRAME_OWNER as old_frame_owner_id,
       "FT_FRAMES"."NEW_FRAME_NO",
       new_owner.description AS new_frame_owner,
	   ft_frames.NEW_FRAME_OWNER as new_frame_owner_id,
       "FT_FRAMES"."NEW_FRAME_REV_FROM",
       "FT_FRAMES"."NEW_FRAME_REV_TO"
  FROM "FT_FRAMES", itdbprofile old_owner, itdbprofile new_owner
 WHERE old_owner.owner = ft_frames.old_frame_owner
   AND new_owner.owner = ft_frames.new_frame_owner

 ;
--------------------------------------------------------
--  DDL for View RPMV1_FCM_RULES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_FCM_RULES" ("FT_GROUP_ID", "PROP_G_ID", "FT_ID", "OLD_SECTION", "OLD_SUB_SECTION", "OLD_PROP_GROUP", "OLD_PROPERTY", "OLD_ATTRIBUTE", "OLD_COLUMN", "NEW_SECTION", "NEW_SUB_SECTION", "NEW_PROP_GROUP", "NEW_PROPERTY", "NEW_ATTRIBUTE", "NEW_COLUMN", "OBJECT_TYPE") AS 
  SELECT "FT_BASE_RULES"."FT_GROUP_ID", 
ft_base_rules.OLD_PROP_GROUP as prop_g_id, 
         "FT_BASE_RULES"."FT_ID", 
		 old_section.description as old_section , 
         old_ss.description as old_sub_section, 
		 DECODE(FT_BASE_RULES.OBJECT_TYPE,5,old_text.DESCRIPTION,old_pg.description) as OLD_PROP_GROUP, 
         old_p.description as OLD_PROPERTY, 
		 old_attr.description as OLD_ATTRIBUTE, 
         old_col.DISPLAYFORMATTYPE as OLD_COLUMN, 
		 new_section.description as new_section, 
		 new_ss.description as new_sub_section, 
		 DECODE(FT_BASE_RULES.OBJECT_TYPE,5,new_text.DESCRIPTION,new_pg.description) as NEW_PROP_GROUP, 
		 new_p.description as new_property, 
		 new_attr.description as new_attribute, 
         new_col.DISPLAYFORMATTYPE as NEW_COLUMN, 
         "FT_BASE_RULES"."OBJECT_TYPE" 
    FROM "FT_BASE_RULES",section old_section, section new_section, property_group old_pg, property_group new_pg, 
	     property old_p, property new_p, sub_section old_ss, sub_section new_ss, 
		 attribute new_attr, attribute old_attr, RPMV1_DISPLAYFORMAT_TYPE  new_col, RPMV1_DISPLAYFORMAT_TYPE  old_col, 
		 text_type old_text, text_type new_text 
   WHERE ft_base_rules.OLD_SECTION = old_section.section_id(+) and ft_base_rules.new_section = new_section.section_id(+) 
   AND	ft_base_rules.old_prop_group = old_pg.property_group(+) and ft_base_rules.new_prop_group = new_pg.property_group(+) 
   AND   ft_base_rules.old_property = old_p.PROPERTY(+) and ft_base_rules.new_property = new_p.property(+) 
   and   ft_base_rules.old_sub_section=old_ss.SUB_SECTION_ID(+) and ft_base_rules.NEW_SUB_SECTION = new_ss.sub_section_id(+) 
   and   ft_base_rules.old_attribute = old_attr.attribute(+) and ft_base_rules.new_attribute = new_attr.attribute(+) 
   and   ft_base_rules.old_column = old_col.ID(+) and ft_base_rules.new_column = new_col.ID(+) 
   and   ft_base_rules.old_prop_group = old_text.text_type(+) and ft_base_rules.new_prop_group = new_text.text_type(+)

 ;
--------------------------------------------------------
--  DDL for View RPMV1_FIXED_STATES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_FIXED_STATES" ("STATUS", "FRAMES", "OBJECTSREFTEXTS", "GLOSSARY") AS 
  SELECT "STATUS","FRAMES","OBJECTSREFTEXTS","GLOSSARY" 
FROM RPMT_FIXED_STATES

 ;
--------------------------------------------------------
--  DDL for View RPMV1_FOODCLAIM_ALERT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_FOODCLAIM_ALERT" ("FOOD_CLAIM_ID", "FOOD_CLAIM_CRIT_ID", "FOOD_CLAIM_ALERT_ID", "DESCRIPTION", "LONG_DESCRIPTION", "INTL", "STATUS") AS 
  select foodclaim_alert.food_claim_id,
       foodclaim_alert.food_claim_crit_id,
       a.food_claim_alert_id,
	   a.description,
	   a.long_description,
	   a.intl,
	   a.status
from itfoodclaimd foodclaim_alert, itfoodclaimalert a
where
foodclaim_alert.ref_id=a.food_claim_alert_id and foodclaim_alert.ref_type=6

 ;
--------------------------------------------------------
--  DDL for View RPMV1_FOODCLAIM_CD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_FOODCLAIM_CD" ("FOOD_CLAIM_ID", "FOOD_CLAIM_CRIT_ID", "FOOD_CLAIM_CD_ID", "DESCRIPTION", "LONG_DESCRIPTION", "INTL", "STATUS") AS 
  select foodclaim_cd.food_claim_id,
       foodclaim_cd.food_claim_crit_id,
       a.food_claim_cd_id,
	    a.description,
	    a.long_description,
	    a.intl,
	    a.status
from itfoodclaimd foodclaim_cd, ITFOODCLAIMCD a
where
FOODCLAIM_CD.REF_ID=a.FOOD_CLAIM_CD_ID(+) AND FOODCLAIM_CD.REF_TYPE=2

 ;
--------------------------------------------------------
--  DDL for View RPMV1_FOODCLAIM_CRITRULE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_FOODCLAIM_CRITRULE" ("FOOD_CLAIM_ID", "FOOD_CLAIM_CRIT_ID", "FOOD_CLAIM_CRIT_RULE_ID", "DESCRIPTION", "INTL", "STATUS") AS 
  select FOODCLAIM_CRITRULE.food_claim_id,
		 FOODCLAIM_CRITRULE.food_claim_crit_id,
		 a.food_claim_crit_rule_id,
		 a.Description,a.intl,
		 a.status
from itfoodclaimd FOODCLAIM_CRITRULE, ITFOODCLAIMCRITRULE a
where
FOODCLAIM_CRITRULE.REF_ID=a.FOOD_CLAIM_CRIT_RULE_ID AND FOODCLAIM_CRITRULE.REF_TYPE=1

 ;
--------------------------------------------------------
--  DDL for View RPMV1_FOODCLAIM_LABEL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_FOODCLAIM_LABEL" ("FOOD_CLAIM_ID", "FOOD_CLAIM_CRIT_ID", "FOOD_CLAIM_LABEL_ID", "DESCRIPTION", "LONG_DESCRIPTION", "INTL", "STATUS") AS 
  select FOODCLAIM_LABEL.food_claim_id,
       FOODCLAIM_LABEL.food_claim_crit_id,
       a.food_claim_label_id,
       a.Description,
       a.long_Description,
       a.intl,a.status
from itfoodclaimd FOODCLAIM_LABEL, ITFOODCLAIMLABEL a
where
FOODCLAIM_LABEL.REF_ID=a.FOOD_CLAIM_LABEL_ID AND FOODCLAIM_LABEL.REF_TYPE=4

 ;
--------------------------------------------------------
--  DDL for View RPMV1_FOODCLAIM_NOTE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_FOODCLAIM_NOTE" ("FOOD_CLAIM_ID", "FOOD_CLAIM_CRIT_ID", "FOOD_CLAIM_NOTE_ID", "DESCRIPTION", "LONG_DESCRIPTION", "INTL", "STATUS") AS 
  select foodclaim_note.food_claim_id,
       foodclaim_note.food_claim_crit_id,
       a.food_claim_note_id,
	    a.description,
	    a.long_description,
	    a.intl,
	    a.status
from itfoodclaimd foodclaim_note, itfoodclaimnote a
where
foodclaim_note.ref_id=a.food_claim_note_id and foodclaim_note.ref_type=5

 ;
--------------------------------------------------------
--  DDL for View RPMV1_FOODCLAIM_SYN
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_FOODCLAIM_SYN" ("FOOD_CLAIM_ID", "FOOD_CLAIM_CRIT_ID", "FOOD_CLAIM_SYN_ID", "DESCRIPTION", "INTL", "STATUS") AS 
  select FOOD_CLAIM_SYN.food_claim_id,
		 FOOD_CLAIM_SYN.food_claim_crit_id,
		 a.food_claim_syn_id,a.Description,
		 a.intl,
		 a.status
from itfoodclaimd FOOD_CLAIM_SYN, ITFOODCLAIMSYN a
where
FOOD_CLAIM_SYN.REF_ID=a.FOOD_CLAIM_SYN_ID(+) AND FOOD_CLAIM_SYN.REF_TYPE=3

 ;
--------------------------------------------------------
--  DDL for View RPMV1_FOODCLAIMKEYWORD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_FOODCLAIMKEYWORD" ("KW_ID", "INTL", "STATUS", "REVISION", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "KW_TYPE", "KW_USAGE", "DATE_IMPORTED") AS 
  SELECT itkw.kw_id,
       itkw.intl,
       itkw.status,
       itkw_h.revision,
       itkw_h.description,
       itkw_h.last_modified_on,
       itkw_h.last_modified_by,
       itkw_h.kw_type,
       itkw_h.kw_usage,
       itkw_h.date_imported
  FROM itkw itkw, itkw_h itkw_h
 WHERE ((itkw.kw_id = itkw_h.kw_id(+))) and itkw.kw_usage =6

 ;
--------------------------------------------------------
--  DDL for View RPMV1_FORMAT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_FORMAT" ("FORMAT_ID", "DESCRIPTION", "INTL", "TYPE") AS 
  SELECT 
  format.format_id,
  format.description,
  format.intl,
  RPMV1_DATA_TYPE.TYPE
FROM 
  format , RPMV1_DATA_TYPE
where format.type=RPMV1_DATA_TYPE.FORMAT_ID

 ;
--------------------------------------------------------
--  DDL for View RPMV1_GLOSS_STATUS_CHANGE_LOG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_GLOSS_STATUS_CHANGE_LOG" ("DESCRIPTION", "EN_TP", "STATUS_CHANGE_DATE", "USER_ID", "STATUS") AS 
  SELECT "PROPERTY"."DESCRIPTION",
       "ITENSSLOG"."EN_TP",
       "ITENSSLOG"."STATUS_CHANGE_DATE",
       "ITENSSLOG"."USER_ID",
       "ITENSSLOG"."STATUS"
  FROM "ITENSSLOG", "PROPERTY"
 WHERE TO_CHAR ("ITENSSLOG"."EN_ID") = "PROPERTY"."PROPERTY"
   AND "ITENSSLOG"."EN_TP" = 'sp'
UNION
SELECT "UOM"."DESCRIPTION",
       "ITENSSLOG"."EN_TP",
       "ITENSSLOG"."STATUS_CHANGE_DATE",
       "ITENSSLOG"."USER_ID",
       "ITENSSLOG"."STATUS"
  FROM "ITENSSLOG", "UOM"
 WHERE TO_CHAR ("ITENSSLOG"."EN_ID") = "UOM"."UOM_ID"
   AND "ITENSSLOG"."EN_TP" = 'um'
UNION
SELECT "ASSOCIATION"."DESCRIPTION",
       "ITENSSLOG"."EN_TP",
       "ITENSSLOG"."STATUS_CHANGE_DATE",
       "ITENSSLOG"."USER_ID",
       "ITENSSLOG"."STATUS"
  FROM "ITENSSLOG", "ASSOCIATION"
 WHERE TO_CHAR ("ITENSSLOG"."EN_ID") = "ASSOCIATION"."ASSOCIATION"
   AND "ITENSSLOG"."EN_TP" = 'as'
UNION
SELECT "ATTRIBUTE"."DESCRIPTION",
       "ITENSSLOG"."EN_TP",
       "ITENSSLOG"."STATUS_CHANGE_DATE",
       "ITENSSLOG"."USER_ID",
       "ITENSSLOG"."STATUS"
  FROM "ITENSSLOG", "ATTRIBUTE"
 WHERE TO_CHAR ("ITENSSLOG"."EN_ID") = "ATTRIBUTE"."ATTRIBUTE"
   AND "ITENSSLOG"."EN_TP" = 'at'
UNION
SELECT "CHARACTERISTIC"."DESCRIPTION",
       "ITENSSLOG"."EN_TP",
       "ITENSSLOG"."STATUS_CHANGE_DATE",
       "ITENSSLOG"."USER_ID",
       "ITENSSLOG"."STATUS"
  FROM "ITENSSLOG", "CHARACTERISTIC"
 WHERE TO_CHAR ("ITENSSLOG"."EN_ID") = "CHARACTERISTIC"."CHARACTERISTIC_ID"
   AND "ITENSSLOG"."EN_TP" = 'ch'
UNION
SELECT "HEADER"."DESCRIPTION",
       "ITENSSLOG"."EN_TP",
       "ITENSSLOG"."STATUS_CHANGE_DATE",
       "ITENSSLOG"."USER_ID",
       "ITENSSLOG"."STATUS"
  FROM "ITENSSLOG", "HEADER"
 WHERE TO_CHAR ("ITENSSLOG"."EN_ID") = "HEADER"."HEADER_ID"
   AND "ITENSSLOG"."EN_TP" = 'hd'
UNION
SELECT "ITING"."DESCRIPTION",
       "ITENSSLOG"."EN_TP",
       "ITENSSLOG"."STATUS_CHANGE_DATE",
       "ITENSSLOG"."USER_ID",
       "ITENSSLOG"."STATUS"
  FROM "ITENSSLOG", "ITING"
 WHERE TO_CHAR ("ITENSSLOG"."EN_ID") = "ITING"."INGREDIENT"
   AND "ITENSSLOG"."EN_TP" = 'in'
UNION
SELECT "ITKWCH"."DESCRIPTION",
       "ITENSSLOG"."EN_TP",
       "ITENSSLOG"."STATUS_CHANGE_DATE",
       "ITENSSLOG"."USER_ID",
       "ITENSSLOG"."STATUS"
  FROM "ITENSSLOG", "ITKWCH"
 WHERE TO_CHAR ("ITENSSLOG"."EN_ID") = "ITKWCH"."CH_ID"
   AND "ITENSSLOG"."EN_TP" = 'kc'
UNION
SELECT "ITKW"."DESCRIPTION",
       "ITENSSLOG"."EN_TP",
       "ITENSSLOG"."STATUS_CHANGE_DATE",
       "ITENSSLOG"."USER_ID",
       "ITENSSLOG"."STATUS"
  FROM "ITENSSLOG", "ITKW"
 WHERE TO_CHAR ("ITENSSLOG"."EN_ID") = "ITKW"."KW_ID"
   AND "ITENSSLOG"."EN_TP" = 'kw'
UNION
SELECT "PROPERTY_GROUP"."DESCRIPTION",
       "ITENSSLOG"."EN_TP",
       "ITENSSLOG"."STATUS_CHANGE_DATE",
       "ITENSSLOG"."USER_ID",
       "ITENSSLOG"."STATUS"
  FROM "ITENSSLOG", "PROPERTY_GROUP"
 WHERE TO_CHAR ("ITENSSLOG"."EN_ID") = "PROPERTY_GROUP"."PROPERTY_GROUP"
   AND "ITENSSLOG"."EN_TP" = 'pg'
UNION
SELECT "SUB_SECTION"."DESCRIPTION",
       "ITENSSLOG"."EN_TP",
       "ITENSSLOG"."STATUS_CHANGE_DATE",
       "ITENSSLOG"."USER_ID",
       "ITENSSLOG"."STATUS"
  FROM "ITENSSLOG", "SUB_SECTION"
 WHERE TO_CHAR ("ITENSSLOG"."EN_ID") = "SUB_SECTION"."SUB_SECTION_ID"
   AND "ITENSSLOG"."EN_TP" = 'sb'
UNION
SELECT "SECTION"."DESCRIPTION",
       "ITENSSLOG"."EN_TP",
       "ITENSSLOG"."STATUS_CHANGE_DATE",
       "ITENSSLOG"."USER_ID",
       "ITENSSLOG"."STATUS"
  FROM "ITENSSLOG", "SECTION"
 WHERE TO_CHAR ("ITENSSLOG"."EN_ID") = "SECTION"."SECTION_ID"
   AND "ITENSSLOG"."EN_TP" = 'sc'
UNION
SELECT "TEXT_TYPE"."DESCRIPTION",
       "ITENSSLOG"."EN_TP",
       "ITENSSLOG"."STATUS_CHANGE_DATE",
       "ITENSSLOG"."USER_ID",
       "ITENSSLOG"."STATUS"
  FROM "ITENSSLOG", "TEXT_TYPE"
 WHERE TO_CHAR ("ITENSSLOG"."EN_ID") = "TEXT_TYPE"."TEXT_TYPE"
   AND "ITENSSLOG"."EN_TP" = 'tt'
UNION
SELECT "TEST_METHOD"."DESCRIPTION",
       "ITENSSLOG"."EN_TP",
       "ITENSSLOG"."STATUS_CHANGE_DATE",
       "ITENSSLOG"."USER_ID",
       "ITENSSLOG"."STATUS"
  FROM "ITENSSLOG", "TEST_METHOD"
 WHERE TO_CHAR ("ITENSSLOG"."EN_ID") = "TEST_METHOD"."TEST_METHOD"
   AND "ITENSSLOG"."EN_TP" = 'tm'

 ;
--------------------------------------------------------
--  DDL for View RPMV1_GROUP_PROPERTY_LIMIT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_GROUP_PROPERTY_LIMIT" ("PROPERTY_GROUP", "PROPERTY", "LOWER_REJECT", "UPPER_REJECT", "INTL", "UOM_ID", "UOM") AS 
  SELECT group_property_limit.property_group,
          group_property_limit.property,
          group_property_limit.lower_reject,
          group_property_limit.upper_reject,
          group_property_limit.intl,
		  group_property_limit.uom_id,
          uom.description AS uom
     FROM group_property_limit, uom
    WHERE group_property_limit.uom_id = uom.uom_id

 ;
--------------------------------------------------------
--  DDL for View RPMV1_HEADER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_HEADER" ("INTL", "STATUS", "HEADER_ID", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED", "ES_SEQ_NO") AS 
  SELECT 
  header.intl,
  header.status,
  header_h.header_id,
  header_h.revision,
  header_h.lang_id,
  header_h.description,
  header_h.last_modified_on,
  header_h.last_modified_by,
  header_h.max_rev,
  header_h.date_imported,
  header_h.es_seq_no
FROM 
  header header,
  header_h header_h
WHERE 
  header.header_id = header_h.header_id(+)
  and header_h.max_rev=1

 ;
--------------------------------------------------------
--  DDL for View RPMV1_IDI_LOGGING
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_IDI_LOGGING" ("PROPERTY", "DESCRIPTION", "REVISION", "DATE_IMPORTED") AS 
  SELECT 'Property' as  Property,
       description,
       revision,
       date_imported
  FROM property_h
UNION
SELECT 'Characteristic',
       description,
       revision,
       date_imported
  FROM characteristic_h
UNION
SELECT 'UOM',
       description,
       revision,
       date_imported
  FROM uom_h
UNION
SELECT 'Propery Group',
       description,
       revision,
       date_imported
  FROM property_group_h
UNION
SELECT 'Association',
       description,
       revision,
       date_imported
  FROM association_h
UNION
SELECT 'Characteristic',
       description,
       revision,
       date_imported
  FROM characteristic_h
UNION
SELECT 'Attribute',
       description,
       revision,
       date_imported
  FROM attribute_h
UNION
SELECT 'Specification Type',
       description,
       revision,
       date_imported
  FROM class3_h
UNION
SELECT 'Free Text',
       description,
       revision,
       date_imported
  FROM text_type_h
UNION
SELECT 'Header',
       description,
       revision,
       date_imported
  FROM header_h
UNION
SELECT 'Sub Section',
       description,
       revision,
       date_imported
  FROM sub_section_h
UNION
SELECT 'Section',
       description,
       revision,
       date_imported
  FROM section_h
UNION
SELECT 'Test Method',
       description,
       revision,
       date_imported
  FROM test_method_h
UNION
SELECT 'Ingredient',
       description,
       revision,
       date_imported
  FROM iting_h
UNION
SELECT 'Display Format',
       description,
       revision,
       date_imported
  FROM layout
UNION
SELECT 'Key Word',
       description,
       revision,
       date_imported
  FROM itkw_h
UNION
SELECT 'Key Word Characteristic',
       description,
       revision,
       date_imported
  FROM itkwch_h
UNION
SELECT 'Frame Ch Mgt Rule',
       description,
       0,
	   date_imported
  FROM ft_rule_group_h
UNION
SELECT TYPE,
       part_no,
       revision,
       "TIMESTAMP"
  FROM itimp_log

 ;
--------------------------------------------------------
--  DDL for View RPMV1_INGREDIENT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_INGREDIENT" ("INGREDIENT", "INTL", "STATUS", "RECFAC", "ALLERGEN", "SOI", "ORG_ING", "REC_ING", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED", "ING_TYPE", "ES_SEQ_NO") AS 
  SELECT iting_h.ingredient, iting.intl, iting.status, iting.recfac,
       iting.allergen, iting.soi, iting.org_ing, iting.rec_ing,
       iting_h.revision, iting_h.lang_id, iting_h.description,
       iting_h.last_modified_on, iting_h.last_modified_by, iting_h.max_rev,
       iting_h.date_imported, iting_h.ing_type,
       iting_h.es_seq_no
  FROM iting , iting_h 
 WHERE iting.ingredient = iting_h.ingredient(+) and iting_h.max_rev=1

 ;
--------------------------------------------------------
--  DDL for View RPMV1_INGREDIENT_ALLERGEN
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_INGREDIENT_ALLERGEN" ("PID", "CID", "INTL", "STATUS", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED", "ES_SEQ_NO") AS 
  SELECT itingcfg_h.pid,itingcfg_h.cid,itingcfg.intl,itingcfg.status,itingcfg_h.revision,itingcfg_h.lang_id,itingcfg_h.description,
        itingcfg_h.last_modified_on,itingcfg_h.last_modified_by,itingcfg_h.max_rev,itingcfg_h.date_imported,itingcfg_h.es_seq_no
from itingcfg_h,itingcfg
where  itingcfg.cid=itingcfg_h.cid(+) and 
	   itingcfg_h.pid=7 and itingcfg_h.max_rev=1

 ;
--------------------------------------------------------
--  DDL for View RPMV1_INGREDIENT_CTFA
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_INGREDIENT_CTFA" ("PID", "CID", "INTL", "STATUS", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED", "ES_SEQ_NO") AS 
  SELECT itingcfg_h.pid, itingcfg_h.cid, itingcfg.intl, itingcfg.status,          
          itingcfg_h.revision, itingcfg_h.lang_id, itingcfg_h.description, 
          itingcfg_h.last_modified_on, itingcfg_h.last_modified_by, 
          itingcfg_h.max_rev, itingcfg_h.date_imported, itingcfg_h.es_seq_no 
     FROM itingcfg_h itingcfg_h, itingcfg itingcfg
    WHERE itingcfg.cid = itingcfg_h.cid(+) AND itingcfg_h.pid = 3 and itingcfg_h.max_rev=1

 ;
--------------------------------------------------------
--  DDL for View RPMV1_INGREDIENT_FUNCTIONS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_INGREDIENT_FUNCTIONS" ("PID", "CID", "INTL", "STATUS", "CID_TYPE", "MAX_PCT", "ING_TYPE", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED", "ES_SEQ_NO") AS 
  SELECT itingcfg_h.pid, itingcfg_h.cid, itingcfg.intl, itingcfg.status, 
          itingcfg.cid_type, itingcfg.max_pct, itingcfg.ing_type, 
          itingcfg_h.revision, itingcfg_h.lang_id, itingcfg_h.description, 
          itingcfg_h.last_modified_on, itingcfg_h.last_modified_by, 
          itingcfg_h.max_rev, itingcfg_h.date_imported, itingcfg_h.es_seq_no 
     FROM itingcfg_h itingcfg_h, itingcfg itingcfg
    WHERE itingcfg.cid = itingcfg_h.cid(+) AND itingcfg_h.pid = 2 and itingcfg_h.max_rev=1

 ;
--------------------------------------------------------
--  DDL for View RPMV1_INGREDIENT_GROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_INGREDIENT_GROUP" ("PID", "CID", "INTL", "STATUS", "CID_TYPE", "MAX_PCT", "ING_TYPE", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED", "ES_SEQ_NO") AS 
  SELECT itingcfg_h.pid, itingcfg_h.cid, itingcfg.intl, itingcfg.status,
          itingcfg.cid_type, itingcfg.max_pct, itingcfg.ing_type,
          itingcfg_h.revision, itingcfg_h.lang_id, itingcfg_h.description,
          itingcfg_h.last_modified_on, itingcfg_h.last_modified_by,
          itingcfg_h.max_rev, itingcfg_h.date_imported, itingcfg_h.es_seq_no
     FROM itingcfg_h itingcfg_h, itingcfg itingcfg
    WHERE itingcfg.cid = itingcfg_h.cid(+) AND itingcfg_h.pid = 1 and itingcfg_h.max_rev=1

 ;
--------------------------------------------------------
--  DDL for View RPMV1_ITBOMEXPLOSION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_ITBOMEXPLOSION" ("BOM_EXP_NO", "MOP_SEQUENCE_NO", "SEQUENCE_NO", "BOM_LEVEL", "COMPONENT_PART", "COMPONENT_REVISION", "DESCRIPTION", "PLANT", "ALTERNATIVE", "USAGE", "PART_SOURCE", "INGREDIENT", "PHANTOM", "RECURSIVE_STOP", "ACCESS_STOP", "QTY", "UOM", "CONV_FACTOR", "TO_UNIT", "SCRAP", "CALC_QTY", "CALC_QTY_WITH_SCRAP", "COST", "COST_WITH_SCRAP", "CALC_COST", "CALC_COST_WITH_SCRAP", "CALCULATED", "ALT_PRICE_TYPE", "PART_TYPE", "ASSEMBLY_SCRAP", "COMPONENT_SCRAP", "LEAD_TIME_OFFSET", "ITEM_CATEGORY", "ISSUE_LOCATION", "BOM_ITEM_TYPE", "OPERATIONAL_STEP", "MIN_QTY", "MAX_QTY", "CHAR_1", "CHAR_2", "CODE", "ALT_GROUP", "ALT_PRIORITY", "NUM_1", "NUM_2", "NUM_3", "NUM_4", "NUM_5", "CHAR_3", "CHAR_4", "CHAR_5", "DATE_1", "DATE_2", "CH_1", "CH_REV_1", "CH_2", "CH_REV_2", "CH_3", "CH_REV_3", "RELEVENCY_TO_COSTING", "BULK_MATERIAL", "BOOLEAN_1", "BOOLEAN_2", "BOOLEAN_3", "BOOLEAN_4") AS 
  SELECT "BOM_EXP_NO","MOP_SEQUENCE_NO","SEQUENCE_NO","BOM_LEVEL","COMPONENT_PART","COMPONENT_REVISION","DESCRIPTION","PLANT","ALTERNATIVE","USAGE","PART_SOURCE","INGREDIENT","PHANTOM","RECURSIVE_STOP","ACCESS_STOP","QTY","UOM","CONV_FACTOR","TO_UNIT","SCRAP","CALC_QTY","CALC_QTY_WITH_SCRAP","COST","COST_WITH_SCRAP","CALC_COST","CALC_COST_WITH_SCRAP","CALCULATED","ALT_PRICE_TYPE","PART_TYPE","ASSEMBLY_SCRAP","COMPONENT_SCRAP","LEAD_TIME_OFFSET","ITEM_CATEGORY","ISSUE_LOCATION","BOM_ITEM_TYPE","OPERATIONAL_STEP","MIN_QTY","MAX_QTY","CHAR_1","CHAR_2","CODE","ALT_GROUP","ALT_PRIORITY","NUM_1","NUM_2","NUM_3","NUM_4","NUM_5","CHAR_3","CHAR_4","CHAR_5","DATE_1","DATE_2","CH_1","CH_REV_1","CH_2","CH_REV_2","CH_3","CH_REV_3","RELEVENCY_TO_COSTING","BULK_MATERIAL","BOOLEAN_1","BOOLEAN_2","BOOLEAN_3","BOOLEAN_4" FROM ITBOMEXPLOSION WHERE iapiRM.CheckBOMAccess = 'Y'
 ;
--------------------------------------------------------
--  DDL for View RPMV1_ITBOMIMPLOSION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_ITBOMIMPLOSION" ("BOM_IMP_NO", "MOP_SEQUENCE_NO", "MOP_PART", "SEQUENCE_NO", "BOM_LEVEL", "PARENT_PART", "PARENT_REVISION", "DESCRIPTION", "PLANT", "ALTERNATIVE", "USAGE", "SPEC_TYPE", "TOP_LEVEL", "ACCESS_STOP", "RECURSIVE_STOP", "ALT_GROUP", "ALT_PRIORITY", "QUANTITY", "UOM", "CONV_FACTOR", "TO_UNIT") AS 
  SELECT "BOM_IMP_NO","MOP_SEQUENCE_NO","MOP_PART","SEQUENCE_NO","BOM_LEVEL","PARENT_PART","PARENT_REVISION","DESCRIPTION","PLANT","ALTERNATIVE","USAGE","SPEC_TYPE","TOP_LEVEL","ACCESS_STOP","RECURSIVE_STOP","ALT_GROUP","ALT_PRIORITY","QUANTITY","UOM","CONV_FACTOR","TO_UNIT" FROM ITBOMIMPLOSION WHERE iapiRM.CheckBOMAccess = 'Y'
 ;
--------------------------------------------------------
--  DDL for View RPMV1_ITBOMJRNL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_ITBOMJRNL" ("PART_NO", "REVISION", "PLANT", "ALTERNATIVE", "BOM_USAGE", "ITEM_NUMBER", "USER_ID", "TIMESTAMP", "FORENAME", "LAST_NAME", "HEADER_ID", "FIELD_ID", "OLD_VALUE", "NEW_VALUE") AS 
  SELECT "PART_NO","REVISION","PLANT","ALTERNATIVE","BOM_USAGE","ITEM_NUMBER","USER_ID","TIMESTAMP","FORENAME","LAST_NAME","HEADER_ID","FIELD_ID","OLD_VALUE","NEW_VALUE" FROM ITBOMJRNL WHERE F_CHECK_ACCESS(PART_NO,REVISION) = 1 AND iapiRM.CheckBOMAccess = 'Y'
 ;
--------------------------------------------------------
--  DDL for View RPMV1_ITBOMLY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_ITBOMLY" ("LAYOUT_ID", "DESCRIPTION", "INTL", "STATUS", "CREATED_BY", "CREATED_ON", "LAST_MODIFIED_BY", "LAST_MODIFIED_ON", "REVISION", "DATE_IMPORTED", "LAYOUT_TYPE") AS 
  SELECT "LAYOUT_ID","DESCRIPTION","INTL","STATUS","CREATED_BY","CREATED_ON","LAST_MODIFIED_BY","LAST_MODIFIED_ON","REVISION","DATE_IMPORTED","LAYOUT_TYPE" FROM ITBOMLY WHERE iapiRM.CheckBOMAccess = 'Y'
 ;
--------------------------------------------------------
--  DDL for View RPMV1_ITBOMLYITEM
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_ITBOMLYITEM" ("LAYOUT_ID", "HEADER_ID", "FIELD_ID", "INCLUDED", "START_POS", "LENGTH", "ALIGNMENT", "FORMAT_ID", "HEADER", "COLOR", "BOLD", "UNDERLINE", "INTL", "REVISION", "HEADER_REV", "DEF", "FIELD_TYPE", "EDITABLE", "PHASE_MRP", "PLANNING_MRP", "PRODUCTION_MRP", "ASSOCIATION", "CHARACTERISTIC") AS 
  SELECT "LAYOUT_ID","HEADER_ID","FIELD_ID","INCLUDED","START_POS","LENGTH","ALIGNMENT","FORMAT_ID","HEADER","COLOR","BOLD","UNDERLINE","INTL","REVISION","HEADER_REV","DEF","FIELD_TYPE","EDITABLE","PHASE_MRP","PLANNING_MRP","PRODUCTION_MRP","ASSOCIATION","CHARACTERISTIC" FROM ITBOMLYITEM WHERE iapiRM.CheckBOMAccess = 'Y'
 ;
--------------------------------------------------------
--  DDL for View RPMV1_ITBOMLYSOURCE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_ITBOMLYSOURCE" ("SOURCE", "LAYOUT_TYPE", "LAYOUT_ID", "LAYOUT_REV", "PREFERRED") AS 
  SELECT "SOURCE","LAYOUT_TYPE","LAYOUT_ID","LAYOUT_REV","PREFERRED" FROM ITBOMLYSOURCE WHERE iapiRM.CheckBOMAccess = 'Y'
 ;
--------------------------------------------------------
--  DDL for View RPMV1_ITBOMPATH
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_ITBOMPATH" ("BOM_EXP_NO", "SEQ_NO", "PARENT_PART_NO", "PARENT_REVISION", "PART_NO", "REVISION", "PLANT", "ALTERNATIVE", "BOM_USAGE", "ALT_GROUP", "ALT_PRIORITY", "BOM_LEVEL") AS 
  SELECT "BOM_EXP_NO","SEQ_NO","PARENT_PART_NO","PARENT_REVISION","PART_NO","REVISION","PLANT","ALTERNATIVE","BOM_USAGE","ALT_GROUP","ALT_PRIORITY","BOM_LEVEL" FROM ITBOMPATH WHERE F_CHECK_ACCESS(PART_NO,REVISION) = 1 AND iapiRM.CheckBOMAccess = 'Y'
 ;
--------------------------------------------------------
--  DDL for View RPMV1_ITBU
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_ITBU" ("BOM_USAGE", "DESCR") AS 
  SELECT "BOM_USAGE","DESCR" FROM ITBU WHERE iapiRM.CheckBOMAccess = 'Y'
 ;
--------------------------------------------------------
--  DDL for View RPMV1_KEYWORD_CHARACTERISTIC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_KEYWORD_CHARACTERISTIC" ("CH_ID", "INTL", "STATUS", "REVISION", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "DATE_IMPORTED") AS 
  SELECT itkwch.ch_id,
       itkwch.intl,
       itkwch.status,
       itkwch_h.revision,
       itkwch_h.description,
       itkwch_h.last_modified_on,
       itkwch_h.last_modified_by,
       itkwch_h.date_imported
  FROM itkwch itkwch, itkwch_h itkwch_h
 WHERE ((itkwch.ch_id = itkwch_h.ch_id(+)))

 ;
--------------------------------------------------------
--  DDL for View RPMV1_NUTLOGRESULT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_NUTLOGRESULT" ("LOG_ID", "COL_ID", "ROW_ID", "VALUE", "PROPERTY", "PROPERTY_REV", "ATTRIBUTE", "ATTRIBUTE_REV", "LAYOUT_ID", "LAYOUT_REV") AS 
  SELECT ITNUTLOG.log_id,
       col_id,
       row_id,
       value,
       property,
       property_rev,
       attribute,
       attribute_rev,
       layout_id,
       layout_rev
  FROM ITNUTLOGRESULT,
       ITNUTLOG
 WHERE ITNUTLOG.log_id=ITNUTLOGRESULT.log_id(+)

 ;
--------------------------------------------------------
--  DDL for View RPMV1_PART_COST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_PART_COST" ("PART_NO", "PERIOD", "CURRENCY", "PRICE", "PRICE_TYPE", "UOM", "PLANT") AS 
  SELECT "PART_NO","PERIOD","CURRENCY", iapiRM.CheckPriceAccess("PRICE"),"PRICE_TYPE","UOM","PLANT" FROM PART_COST
 ;
--------------------------------------------------------
--  DDL for View RPMV1_PREFERENCES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_PREFERENCES" ("SECTION", "PARAMETER", "PARAMETER_DATA", "ES", "ES_SEQ_NO") AS 
  SELECT INTERSPC_CFG.SECTION,
       INTERSPC_CFG.PARAMETER,
       INTERSPC_CFG.PARAMETER_DATA,
       INTERSPC_CFG.ES,
       INTERSPC_CFG.ES_SEQ_NO
  FROM INTERSPC_CFG INTERSPC_CFG
 WHERE (INTERSPC_CFG.VISIBLE = '1')

 ;
--------------------------------------------------------
--  DDL for View RPMV1_PROP_DISPLAY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_PROP_DISPLAY" ("PROPERTY_GROUP", "PROPERTY", "IS_DISPLAY", "INTL", "MANDATORY") AS 
  select property_group,
       property,
       0 as is_display,
       INTL,
       mandatory
  from property_group_list
UNION
select property_group,
       display_format,
       1,
       INTL,
       null
 from property_group_display

 ;
--------------------------------------------------------
--  DDL for View RPMV1_PROPERTY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_PROPERTY" ("PROPERTY_ID", "INTL", "STATUS", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED") AS 
  SELECT
  pro.property as property_id,
  property.intl,
  property.status,
  pro.revision,
  pro.lang_id,
  pro.description,
  pro.last_modified_on,
  pro.last_modified_by,
  pro.max_rev,
  pro.date_imported
FROM
  property property,
  property_h pro
WHERE
  property.property = pro.property(+) and pro.max_rev=1

 ;
--------------------------------------------------------
--  DDL for View RPMV1_PROPERTY_GROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_PROPERTY_GROUP" ("PROPERTY_GROUP_ID", "DISPLAY_FORMAT", "INTL", "STATUS", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "PG_TYPE", "DATE_IMPORTED") AS 
  SELECT 
  pro_h.property_group as property_group_id,
  pro.display_format,
  pro.intl,
  pro.status,
  pro_h.revision,
  pro_h.lang_id,
  pro_h.description,
  pro_h.last_modified_on,
  pro_h.last_modified_by,
  pro_h.max_rev,
  pro_h.pg_type,
  pro_h.date_imported
FROM 
  property_group pro,
  property_group_h pro_h
WHERE 
  pro.property_group = pro_h.property_group(+) and pro_h.max_rev=1

 ;
--------------------------------------------------------
--  DDL for View RPMV1_PROPERTY_LAYOUT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_PROPERTY_LAYOUT" ("LAYOUT_ID", "HEADER_ID", "DISPLAYFORMATTYPE", "INCLUDED", "START_POS", "LENGTH", "ALIGNMENT", "FORMAT_ID", "HEADER", "COLOR", "BOLD", "UNDERLINE", "INTL", "REVISION", "HEADER_REV", "ATTACHED_SPEC", "URL", "DEF") AS 
  SELECT 
  pro.layout_id,
  pro.header_id,
  rti.displayformattype,
  pro.included,
  pro.start_pos,
  pro.LENGTH,
  pro.alignment,
  pro.format_id,
  pro.header,
  pro.color,
  pro.bold,
  pro.underline,
  pro.intl,
  pro.revision,
  pro.header_rev,
  attached_spec, 
  Url,			
  pro.def
FROM 
  property_layout pro,
  RPMV1_DISPLAYFORMAT_TYPE  rti
WHERE 
  ((pro.field_id(+) = rti.ID))

 ;
--------------------------------------------------------
--  DDL for View RPMV1_SECTION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_SECTION" ("SECTION_ID", "INTL", "STATUS", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED", "ES_SEQ_NO") AS 
  SELECT section_h.section_id,
          section.intl,
          section.status,
          section_h.revision,
          section_h.lang_id,
          section_h.description,
          section_h.last_modified_on,
          section_h.last_modified_by,
          section_h.max_rev,
          section_h.date_imported,
          section_h.es_seq_no
     FROM section section, section_h section_h
    WHERE section.section_id = section_h.section_id(+)
      AND section_h.max_rev = 1

 ;
--------------------------------------------------------
--  DDL for View RPMV1_SPEC_PREF_ACCESS_GROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_SPEC_PREF_ACCESS_GROUP" ("PREFIX", "ACCESS_GROUP_ID", "ACCESS_GROUP") AS 
  SELECT prefix, spec_prefix_access_group.access_group AS access_group_id,
       access_group.description AS access_group
  FROM spec_prefix_access_group spec_prefix_access_group,
       access_group access_group
 WHERE spec_prefix_access_group.access_group = access_group.access_group

 ;
--------------------------------------------------------
--  DDL for View RPMV1_SPEC_PREFIX
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_SPEC_PREFIX" ("OWNER", "PREFIX", "DESTINATION_ID", "DESTINATION", "WORKFLOW_GROUP_ID", "WORKFLOW_GROUP", "WORKFLOW_GROUP_SORT_DESC", "ACCESS_GROUP_ID", "ACCESS_GROUP", "ACCESS_GROUP_SORT_DESC", "IMPORT_ALLOWED", "LIVE_DB") AS 
  SELECT spec_prefix.owner,
       spec_prefix.prefix,
	   spec_prefix.destination as destination_id,
       itdbprofile.description as destination,
       spec_prefix.workflow_group_id,
	   workflow_group.DESCRIPTION as workflow_group,
	   workflow_group.SORT_DESC as workflow_group_sort_desc,
       spec_prefix.access_group as access_group_id,
	   access_group.DESCRIPTION as access_group,
	   access_group.sort_desc as access_group_sort_desc,
       spec_prefix.import_allowed,
	   itdbprofile.LIVE_DB
  FROM spec_prefix spec_prefix, itdbprofile itdbprofile, access_group access_group, workflow_group workflow_group
  where spec_prefix.destination =  itdbprofile.owner AND
  		spec_prefix.workflow_group_id = workflow_group.WORKFLOW_GROUP_ID AND
		spec_prefix.access_group = access_group.ACCESS_GROUP

 ;
--------------------------------------------------------
--  DDL for View RPMV1_SPECIFICATION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_SPECIFICATION" ("PART_NO", "DESCRIPTION", "REVISION", "STATUS_ID", "STATUS", "ACCESS_GROUP_SORT", "ACCESS_GROUP", "WORKFLOW_GROUP_SORT", "WORKFLOW_GROUP", "SORT_DESC") AS 
  SELECT ivspecification_header.PART_NO,
       ivspecification_header.DESCRIPTION,
       ivspecification_header.REVISION,
       ivspecification_header.STATUS as status_id,
	   RPMV1_FIXED_STATES.STATUS as status,
       ACCESS_GROUP.SORT_DESC as access_group_sort,
       ACCESS_GROUP.DESCRIPTION as access_group,
       WORKFLOW_GROUP.SORT_DESC as workflow_group_sort,
       WORKFLOW_GROUP.DESCRIPTION as workflow_group,
       CLASS3.SORT_DESC
  FROM ivspecification_header ivspecification_header, ACCESS_GROUP ACCESS_GROUP,
       WORKFLOW_GROUP WORKFLOW_GROUP, CLASS3 CLASS3, RPMV1_FIXED_STATES
 WHERE (ivspecification_header.ACCESS_GROUP = ACCESS_GROUP.ACCESS_GROUP)
   AND (WORKFLOW_GROUP.WORKFLOW_GROUP_ID = ivspecification_header.WORKFLOW_GROUP_ID)
   AND (ivspecification_header.CLASS3_ID = CLASS3.CLASS)
   AND (RPMV1_FIXED_STATES.FRAMES = ivspecification_header.STATUS)

 ;
--------------------------------------------------------
--  DDL for View RPMV1_SPECIFICATION_LINE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_SPECIFICATION_LINE" ("PART_NO", "REVISION", "PLANT", "LINE", "CONFIGURATION", "PROCESS_LINE_REV", "ITEM_PART_NO", "ITEM_REVISION", "SEQUENCE", "SECTION_ID", "SUB_SECTION_ID") AS 
  SELECT line."PART_NO",line."REVISION",line."PLANT",line."LINE",line."CONFIGURATION",line."PROCESS_LINE_REV",line."ITEM_PART_NO",line."ITEM_REVISION",line."SEQUENCE",
       SECTION_ID,
       SUB_SECTION_ID
  FROM IVSPECIFICATION_LINE line,
       IVSPECIFICATION_SECTION sect
 WHERE sect.PART_NO = line.PART_NO
   AND sect.REVISION = line.REVISION
   AND sect.TYPE = 7

 ;
--------------------------------------------------------
--  DDL for View RPMV1_SPECIFICATION_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_SPECIFICATION_TYPE" ("INTL", "STATUS", "CLASS", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "TYPE", "SORT_DESC", "ES_SEQ_NO", "DATE_IMPORTED", "MAX_REV") AS 
  SELECT class3.intl,
       class3.status,
       class3_h.CLASS,
       class3_h.revision,
       class3_h.lang_id,
       class3_h.description,
       class3_h.last_modified_on,
       class3_h.last_modified_by,
       class3_h.TYPE,
       class3_h.sort_desc,
       class3_h.es_seq_no,
       class3_h.date_imported,
       class3_h.max_rev
  FROM class3 class3, class3_h class3_h
 WHERE ((class3.CLASS = class3_h.CLASS(+)))
 and class3_h.MAX_REV=1

 ;
--------------------------------------------------------
--  DDL for View RPMV1_SUB_SECTION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_SUB_SECTION" ("SUB_SECTION_ID", "INTL", "STATUS", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED", "ES_SEQ_NO") AS 
  SELECT sub_section_h.sub_section_id, sub_section.intl, sub_section.status,
          sub_section_h.revision, sub_section_h.lang_id,
          sub_section_h.description, sub_section_h.last_modified_on,
          sub_section_h.last_modified_by, sub_section_h.max_rev,
          sub_section_h.date_imported, sub_section_h.es_seq_no
     FROM sub_section_h sub_section_h, sub_section sub_section
    WHERE ((sub_section.sub_section_id = sub_section_h.sub_section_id(+)))

 ;
--------------------------------------------------------
--  DDL for View RPMV1_SYNONYM_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_SYNONYM_TYPE" ("PID", "CID", "INTL", "STATUS", "CID_TYPE", "MAX_PCT", "ING_TYPE", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED", "ES_SEQ_NO") AS 
  SELECT itingcfg_h.pid,
       itingcfg_h.cid,
       itingcfg.intl,
       itingcfg.status,
       itingcfg.cid_type,
       itingcfg.max_pct,
       itingcfg.ing_type,
       itingcfg_h.revision,
       itingcfg_h.lang_id,
       itingcfg_h.description,
       itingcfg_h.last_modified_on,
       itingcfg_h.last_modified_by,
       itingcfg_h.max_rev,
       itingcfg_h.date_imported,
       itingcfg_h.es_seq_no
  FROM itingcfg_h itingcfg_h, itingcfg itingcfg
 WHERE itingcfg.cid = itingcfg_h.cid(+)
   AND itingcfg_h.pid = 6
   AND itingcfg_h.max_rev=1

 ;
--------------------------------------------------------
--  DDL for View RPMV1_SYNONYMS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_SYNONYMS" ("PID", "CID", "INTL", "STATUS", "CID_TYPE", "MAX_PCT", "ING_TYPE", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED", "ES_SEQ_NO") AS 
  SELECT itingcfg_h.pid, 
			 itingcfg_h.cid, 
			 itingcfg.intl, 
			 itingcfg.status,
          itingcfg.cid_type, 
          itingcfg.max_pct, 
          itingcfg.ing_type,
          itingcfg_h.revision, 
          itingcfg_h.lang_id, 
          itingcfg_h.description,
          itingcfg_h.last_modified_on, 
          itingcfg_h.last_modified_by,
          itingcfg_h.max_rev, 
          itingcfg_h.date_imported, 
          itingcfg_h.es_seq_no
     FROM itingcfg_h itingcfg_h, itingcfg itingcfg
    WHERE itingcfg.cid = itingcfg_h.cid(+) 
          AND itingcfg_h.pid = 4
          AND itingcfg_h.max_rev = 1

 ;
--------------------------------------------------------
--  DDL for View RPMV1_TEST_METHOD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_TEST_METHOD" ("TEST_METHOD_ID", "INTL", "STATUS", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED", "LONG_DESCR") AS 
  SELECT tes.test_method AS test_method_id,
       tes.intl,
       tes.status,
       tes_h.revision,
       tes_h.lang_id,
       tes_h.description,
       tes_h.last_modified_on,
       tes_h.last_modified_by,
       tes_h.max_rev,
       tes_h.date_imported,
       tes_h.long_descr
  FROM test_method tes, test_method_h tes_h
 WHERE tes.test_method = tes_h.test_method(+)
   AND tes_h.max_rev = 1

 ;
--------------------------------------------------------
--  DDL for View RPMV1_TEXT_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_TEXT_TYPE" ("TEXT_TYPE", "PROCESS_FLAG", "INTL", "STATUS", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED", "ES_SEQ_NO") AS 
  SELECT text_type.text_type,
       text_type.process_flag,
       text_type.intl,
       text_type.status,
       text_type_h.revision,
       text_type_h.lang_id,
       text_type_h.description,
       text_type_h.last_modified_on,
       text_type_h.last_modified_by,
       text_type_h.max_rev,
       text_type_h.date_imported,
       text_type_h.es_seq_no
  FROM text_type text_type, text_type_h text_type_h
 WHERE ((text_type.text_type = text_type_h.text_type))
and text_type_h.max_rev=1

 ;
--------------------------------------------------------
--  DDL for View RPMV1_TREETYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_TREETYPE" ("TREETYPE", "CID") AS 
  SELECT distinct SPEC_GROUP as TreeType,itcltv.cid  
from itcld itcld, itcltv itcltv
where itcld.node = itcltv.TYPE
and itcltv.pid=0

 ;
--------------------------------------------------------
--  DDL for View RPMV1_UOM
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_UOM" ("UOM_ID", "INTL", "STATUS", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED") AS 
  SELECT uom_h.uom_id,
          uom.intl,
          uom.status,
          uom_h.revision,
          uom_h.lang_id,
          uom_h.description,
          uom_h.last_modified_on,
          uom_h.last_modified_by,
          uom_h.max_rev,
          uom_h.date_imported
     FROM uom_h uom_h, uom uom
    WHERE uom.uom_id = uom_h.uom_id(+)
      AND uom_h.max_rev = 1

 ;
--------------------------------------------------------
--  DDL for View RPMV1_USERS_LOGGED_ON
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_USERS_LOGGED_ON" ("SID", "USERNAME", "FORENAME", "LAST_NAME", "TELEPHONE_NO", "LOGON_TIME", "OSUSER", "MACHINE", "PROGRAM", "MODULE") AS 
  SELECT SID,
       username,
       application_user.forename,
       application_user.last_name,
       telephone_no,
       logon_time,
       osuser,
       machine,
       program,
       module
  FROM v$session, application_user 
 WHERE v$session.username = application_user.user_id
   AND TYPE <> 'BACKGROUND'
   AND schemaname <> 'SYS'
   AND schemaname <> 'INTERSPC'

 ;
--------------------------------------------------------
--  DDL for View RPMV1_WHO_HAS_HASNT_APPRVD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_WHO_HAS_HASNT_APPRVD" ("PART_NO", "REVISION", "STATUS", "DESCRIPTION", "ALL_TO_APPROVE", "USER_ID", "LAST_NAME", "TEL", "APPROVED_DATE") AS 
  (SELECT DISTINCT specification_header.part_no,
                    specification_header.revision, work_flow_list.status,
                    iapirm.rmf_us_descr (user_group_list.user_group_id) description,
                    work_flow_list.all_to_approve, user_group_list.user_id,
                    SUBSTR (iapirm.rmf_us_descr (user_group_list.user_id),
                            1,
                            80
                           ) last_name,
                    SUBSTR (iapirm.rmf_us_detail (user_group_list.user_id, 'telephone'),
                            1,
                            80
                           ) tel,
                    TO_DATE ('', 'MONTH DD, YYYY') approved_date
               FROM work_flow_list, specification_header, user_group_list
              WHERE work_flow_list.workflow_group_id =
                                        specification_header.workflow_group_id
                AND user_group_list.user_group_id =
                                                  work_flow_list.user_group_id
                AND work_flow_list.status = specification_header.status
                AND (   all_to_approve = UPPER ('Y')
                     OR (    all_to_approve = UPPER ('N')
                         AND editable = UPPER ('n')
                        )
                    )
                AND user_group_list.user_id NOT IN (
                       SELECT user_id
                         FROM users_approved
                        WHERE specification_header.part_no =
                                                        users_approved.part_no
                          AND specification_header.revision =
                                                       users_approved.revision
                          AND specification_header.status =
                                                         users_approved.status)
    UNION
    (SELECT DISTINCT specification_header.part_no,
                     specification_header.revision, work_flow_list.status,
                     iapirm.rmf_us_descr (user_group_list.user_group_id)
                                                                  description,
                     work_flow_list.all_to_approve, user_group_list.user_id,
                     SUBSTR (iapirm.rmf_us_descr (user_group_list.user_id),
                             1,
                             80
                            ) last_name,
                     SUBSTR (iapirm.rmf_us_detail (user_group_list.user_id,
                                          'telephone'),
                             1,
                             80
                            ) tel,
                     users_approved.approved_date
                FROM users_approved,
                     user_group_list,
                     work_flow_list,
                     specification_header
               WHERE user_group_list.user_id = users_approved.user_id
                 AND work_flow_list.user_group_id =
                                                 user_group_list.user_group_id
                 AND work_flow_list.workflow_group_id =
                                        specification_header.workflow_group_id
                 AND specification_header.part_no = users_approved.part_no
                 AND specification_header.revision = users_approved.revision
                 AND users_approved.status = work_flow_list.status)
    UNION
    (SELECT DISTINCT approver_selected.part_no, approver_selected.revision,
                     work_flow_list.status,
                     iapirm.rmf_us_descr (user_group_list.user_group_id)
                                                                  description,
                     approver_selected.all_to_approve,
                     approver_selected.user_id,
                     SUBSTR (iapirm.rmf_us_descr (user_group_list.user_id),
                             1,
                             80
                            ) last_name,
                     SUBSTR (iapirm.rmf_us_detail(user_group_list.user_id,
                                          'telephone'),
                             1,
                             80
                            ) tel,
                     TO_DATE ('', 'MONTH DD, YYYY') approved_date
                FROM approver_selected,
                     work_flow_list,
                     user_group_list,
                     specification_header
               WHERE approver_selected.user_id = user_group_list.user_id
                 AND work_flow_list.user_group_id =
                                                 user_group_list.user_group_id
                 AND work_flow_list.status = approver_selected.status
                 AND work_flow_list.all_to_approve =
                                              approver_selected.all_to_approve
                 AND work_flow_list.workflow_group_id =
                                        specification_header.workflow_group_id
                 AND specification_header.part_no = approver_selected.part_no
                 AND specification_header.revision =
                                                    approver_selected.revision
                 AND approver_selected.status = work_flow_list.status
                 AND approver_selected.status = 2))

 ;
--------------------------------------------------------
--  DDL for View RPMV1_WORKFLOW
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_WORKFLOW" ("WORK_FLOW_ID", "STATUS_SORT_DESC", "STATUS_DESCRIPTION", "STATUS_STATUS_TYPE", "STATUS_PHASE_IN_STATUS", "STATUS_EMAIL_TITLE", "STATUS_PROMPT_FOR_REASON", "STATUS_REASON_MANDATORY", "STATUS_ES", "NEXTSTATUS_SORT_DESC", "NEXTSTATUS_DESCRIPTION", "NEXTSTATUS_STATUS_TYPE", "NEXTSTATUS_PHASE_IN_STATUS", "NEXTSTATUS_EMAIL_TITLE", "NEXTSTATUS_PROMPT_FOR_REASON", "NEXTSTATUS_REASON_MANDATORY", "NEXTSTATUS_ES", "EXPORT_ERP") AS 
  SELECT work_flow.work_flow_id, 
       status.sort_desc as status_sort_desc,
	   status.description as status_description,
       status.status_type as status_status_type,
	   status.phase_in_status as status_phase_in_status,
	   status.email_title as status_email_title,
       status.prompt_for_reason as status_prompt_for_reason,
	   status.reason_mandatory as status_reason_mandatory,
	   status.es as status_es,
       stat.sort_desc as nextstatus_sort_desc,
	   stat.description as nextstatus_description,
	   stat.status_type as nextstatus_status_type,
       stat.phase_in_status as nextstatus_phase_in_status,
	   stat.email_title as nextstatus_email_title, 
	   stat.prompt_for_reason as nextstatus_prompt_for_reason,
       stat.reason_mandatory as nextstatus_reason_mandatory, 
	   stat.es as nextstatus_es,
	   work_flow.EXPORT_ERP
  FROM work_flow work_flow, status status, status stat
 WHERE (    (work_flow.status = status.status)
        AND (work_flow.next_status = stat.status)
       )

 ;
--------------------------------------------------------
--  DDL for View RPMV1_WORKFLOW_GROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_WORKFLOW_GROUP" ("WORKFLOW_GROUP_ID", "SORT_DESC", "DESCRIPTION", "WORK_FLOW_ID") AS 
  SELECT workflow_group.workflow_group_id,
       workflow_group.sort_desc,
       workflow_group.description,
       workflow_group.work_flow_id
  FROM workflow_group workflow_group
UNION
SELECT -1,
       '<ALL>',
       'All workflows',
       TO_NUMBER(NULL)
  FROM DUAL

 ;
--------------------------------------------------------
--  DDL for View RPMV1_WORKFLOW_GROUP_FILTER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_WORKFLOW_GROUP_FILTER" ("DESCRIPTION", "WORKFLOW_GROUP_ID", "USER_GROUP_ID") AS 
  SELECT USER_GROUP.DESCRIPTION,
       USER_WORKFLOW_GROUP.WORKFLOW_GROUP_ID,
       USER_WORKFLOW_GROUP.USER_GROUP_ID
  FROM USER_GROUP USER_GROUP, USER_WORKFLOW_GROUP USER_WORKFLOW_GROUP
 WHERE (USER_GROUP.USER_GROUP_ID = USER_WORKFLOW_GROUP.USER_GROUP_ID)

 ;
--------------------------------------------------------
--  DDL for View RPMV1_WORKFLOW_LIST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV1_WORKFLOW_LIST" ("WORKFLOW_GROUP_ID", "USER_GROUP_ID", "ALL_TO_APPROVE", "SEND_MAIL", "EFF_DATE_MAIL", "STATUS_DESCRIPTION", "STATUS_SORT_DESC") AS 
  SELECT work_flow_list.workflow_group_id,
       work_flow_list.user_group_id,
       work_flow_list.all_to_approve,
       work_flow_list.send_mail,
       work_flow_list.eff_date_mail,
       status.description as status_description,
       status.sort_desc as status_sort_desc
  FROM work_flow_list, status
 WHERE ((work_flow_list.status = status.status))

 ;
--------------------------------------------------------
--  DDL for View RV_BOM_DISPLAY_DBFIELD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RV_BOM_DISPLAY_DBFIELD" ("ID", "DB_FIELD") AS 
  SELECT "ID","DB_FIELD" FROM RTI_BOM_DISPLAY_DBFIELD
 ;
--------------------------------------------------------
--  DDL for View RV_BOMDISPLAYFORMAT_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RV_BOMDISPLAYFORMAT_TYPE" ("ID", "BOMFORMATTYPE") AS 
  SELECT "ID","BOMFORMATTYPE" FROM RTI_BOMDISPLAYFORMAT_TYPE
 ;
--------------------------------------------------------
--  DDL for View RV_DATA_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RV_DATA_TYPE" ("FORMAT_ID", "TYPE") AS 
  SELECT "FORMAT_ID","TYPE" FROM RTI_DATA_TYPE
 ;
--------------------------------------------------------
--  DDL for View RV_DISPLAY_FORMAT_TYPES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RV_DISPLAY_FORMAT_TYPES" ("ID", "DISPLAYFORMATTYPE") AS 
  SELECT "ID","DISPLAYFORMATTYPE" FROM RTI_DISPLAY_FORMAT_TYPES
 ;
--------------------------------------------------------
--  DDL for View RV_DISPLAYFORMAT_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RV_DISPLAYFORMAT_TYPE" ("ID", "DISPLAYFORMATTYPE") AS 
  SELECT "ID","DISPLAYFORMATTYPE" FROM RTI_DISPLAYFORMAT_TYPE
 ;
--------------------------------------------------------
--  DDL for View RV_FIXED_STATES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RV_FIXED_STATES" ("STATUS", "FRAMES", "OBJECTSREFTEXTS", "GLOSSARY") AS 
  SELECT "STATUS","FRAMES","OBJECTSREFTEXTS","GLOSSARY" FROM RTI_FIXED_STATES
 ;
--------------------------------------------------------
--  DDL for View RV_FORMAT_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RV_FORMAT_TYPE" ("FORMAT_ID", "TYPE") AS 
  SELECT "FORMAT_ID","TYPE" FROM RTI_FORMAT_TYPE
 ;
--------------------------------------------------------
--  DDL for View RV_INGREDIENT_DETAIL_TYPES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RV_INGREDIENT_DETAIL_TYPES" ("ID", "Type") AS 
  SELECT "ID","Type" FROM RTI_INGREDIENT_DETAIL_TYPES
 ;
--------------------------------------------------------
--  DDL for View RV_INGREDIENT_DISPLAY_FORMAT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RV_INGREDIENT_DISPLAY_FORMAT" ("ID", "INGREDIENTDISPLAYFORMAT") AS 
  SELECT "ID","INGREDIENTDISPLAYFORMAT" FROM RTI_INGREDIENT_DISPLAY_FORMAT
 ;
--------------------------------------------------------
--  DDL for View RV_INGREDIENTDETAIL_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RV_INGREDIENTDETAIL_TYPE" ("ID", "INGTYPE") AS 
  SELECT "ID","INGTYPE" FROM RTI_INGREDIENTDETAIL_TYPE
 ;
--------------------------------------------------------
--  DDL for View RV_INGREDIENTDISPLAY_FORMAT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RV_INGREDIENTDISPLAY_FORMAT" ("ID", "INGREDIENTDISPLAYFORMAT") AS 
  SELECT "ID","INGREDIENTDISPLAYFORMAT" FROM RTI_INGREDIENTDISPLAY_FORMAT
 ;
--------------------------------------------------------
--  DDL for View RV_PROPERTYGROUP_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RV_PROPERTYGROUP_TYPE" ("ID", "PROPGRPTYPE") AS 
  SELECT "ID","PROPGRPTYPE" FROM RTI_PROPERTYGROUP_TYPE
 ;
--------------------------------------------------------
--  DDL for View RV_SECTION_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RV_SECTION_TYPE" ("ID", "SECTIONTYPE") AS 
  SELECT "ID","SECTIONTYPE" FROM RTI_SECTION_TYPE
 ;
--------------------------------------------------------
--  DDL for View RV_UOM_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RV_UOM_TYPE" ("ID", "UOMTYPE") AS 
  SELECT "ID","UOMTYPE" FROM RTI_UOM_TYPE
 ;
--------------------------------------------------------
--  DDL for View RV_USER_PROFILES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RV_USER_PROFILES" ("PROFILE", "EDIT", "CHANGESTATUS", "OBJECTSREFTEXTS", "PLANTACCESS", "INTL", "MRPACCESS") AS 
  SELECT "PROFILE","EDIT","CHANGESTATUS","OBJECTSREFTEXTS","PLANTACCESS","INTL","MRPACCESS" FROM RTI_USER_PROFILES
 ;
--------------------------------------------------------
--  DDL for View RVACCESS_GROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVACCESS_GROUP" ("ACCESS_GROUP", "SORT_DESC", "DESCRIPTION") AS 
  SELECT "ACCESS_GROUP","SORT_DESC","DESCRIPTION" FROM ACCESS_GROUP
 ;
--------------------------------------------------------
--  DDL for View RVAOPERFORMANCETABLE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVAOPERFORMANCETABLE" ("BOM_EXP_NO", "COMPONENT_PART", "DESCRIPTION", "REVISION", "PROPERTY", "PROPERTY_REV", "PROPERY_DESCR") AS 
  SELECT "BOM_EXP_NO","COMPONENT_PART","DESCRIPTION","REVISION","PROPERTY","PROPERTY_REV","PROPERY_DESCR" FROM AOPERFORMANCETABLE
 ;
--------------------------------------------------------
--  DDL for View RVAPPLICATION_USER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVAPPLICATION_USER" ("USER_ID", "FORENAME", "LAST_NAME", "USER_INITIALS", "TELEPHONE_NO", "EMAIL_ADDRESS", "CURRENT_ONLY", "INITIAL_PROFILE", "USER_PROFILE", "USER_DROPPED", "PROD_ACCESS", "PLAN_ACCESS", "PHASE_ACCESS", "PRINTING_ALLOWED", "INTL", "FRAMES_ONLY", "REFERENCE_TEXT", "APPROVED_ONLY", "LOC_ID", "CAT_ID", "OVERRIDE_PART_VAL", "WEB_ALLOWED", "LIMITED_CONFIGURATOR", "PLANT_ACCESS", "VIEW_BOM", "VIEW_PRICE", "OPTIONAL_DATA") AS 
  SELECT "USER_ID","FORENAME","LAST_NAME","USER_INITIALS","TELEPHONE_NO","EMAIL_ADDRESS","CURRENT_ONLY","INITIAL_PROFILE","USER_PROFILE","USER_DROPPED","PROD_ACCESS","PLAN_ACCESS","PHASE_ACCESS","PRINTING_ALLOWED","INTL","FRAMES_ONLY","REFERENCE_TEXT","APPROVED_ONLY","LOC_ID","CAT_ID","OVERRIDE_PART_VAL","WEB_ALLOWED","LIMITED_CONFIGURATOR","PLANT_ACCESS","VIEW_BOM","VIEW_PRICE","OPTIONAL_DATA" FROM APPLICATION_USER
 ;
--------------------------------------------------------
--  DDL for View RVAPPROVER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVAPPROVER" ("TABLE_NAME", "COL_SELECT", "COL_INSERT", "COL_UPDATE", "COL_DELETE") AS 
  SELECT "TABLE_NAME","COL_SELECT","COL_INSERT","COL_UPDATE","COL_DELETE" FROM APPROVER
 ;
--------------------------------------------------------
--  DDL for View RVASSOCIATION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVASSOCIATION" ("ASSOCIATION", "DESCRIPTION", "ASSOCIATION_TYPE", "INTL", "STATUS") AS 
  SELECT "ASSOCIATION","DESCRIPTION","ASSOCIATION_TYPE","INTL","STATUS" FROM ASSOCIATION
 ;
--------------------------------------------------------
--  DDL for View RVASSOCIATION_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVASSOCIATION_H" ("ASSOCIATION", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "ASSOCIATION_TYPE", "MAX_REV", "DATE_IMPORTED", "ES_SEQ_NO") AS 
  SELECT "ASSOCIATION","REVISION","LANG_ID","DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","ASSOCIATION_TYPE","MAX_REV","DATE_IMPORTED","ES_SEQ_NO" FROM ASSOCIATION_H
 ;
--------------------------------------------------------
--  DDL for View RVATFUNCBOM
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVATFUNCBOM" ("USER_ID", "FUNC_LEVEL", "FUNCTION", "FUNC_OVERRIDE", "COMPONENT_PART", "COMPONENT_REVISION", "DESCRIPTION", "PART_TYPE", "PLANT", "ALTERNATIVE", "USAGE", "QTY", "FRAME_NO", "ACTION") AS 
  SELECT "USER_ID","FUNC_LEVEL","FUNCTION","FUNC_OVERRIDE","COMPONENT_PART","COMPONENT_REVISION","DESCRIPTION","PART_TYPE","PLANT","ALTERNATIVE","USAGE","QTY","FRAME_NO","ACTION" FROM ATFUNCBOM
 ;
--------------------------------------------------------
--  DDL for View RVATFUNCBOMDATA
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVATFUNCBOMDATA" ("USER_ID", "SEQUENCE_NO", "FUNC_LEVEL", "SPEC_HEADER", "KEYWORD", "KEYWORD_ID", "ATTACHED_SPECS", "SECTION", "SECTION_ID", "SUB_SECTION", "SUB_SECTION_ID", "PROPERTY_GROUP", "PROPERTY_GROUP_ID", "PROPERTY", "PROPERTY_ID", "FIELD", "FIELD_TYPE", "VALUE") AS 
  SELECT "USER_ID","SEQUENCE_NO","FUNC_LEVEL","SPEC_HEADER","KEYWORD","KEYWORD_ID","ATTACHED_SPECS","SECTION","SECTION_ID","SUB_SECTION","SUB_SECTION_ID","PROPERTY_GROUP","PROPERTY_GROUP_ID","PROPERTY","PROPERTY_ID","FIELD","FIELD_TYPE","VALUE" FROM ATFUNCBOMDATA
 ;
--------------------------------------------------------
--  DDL for View RVATFUNCBOMWORKAREA
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVATFUNCBOMWORKAREA" ("USER_ID", "SEQUENCE_NO", "BOM_LEVEL", "COMPONENT_PART", "COMPONENT_REVISION", "DESCRIPTION", "PART_TYPE", "PLANT", "ALTERNATIVE", "USAGE", "EXPLOSION_DATE", "QTY", "FUNC_QTY", "UOM", "FUNCTION", "FUNC_LEVEL", "FUNC_OVERRIDE", "PARENT_PART", "PARENT_REVISION", "PARENT_SEQUENCE_NO") AS 
  SELECT "USER_ID","SEQUENCE_NO","BOM_LEVEL","COMPONENT_PART","COMPONENT_REVISION","DESCRIPTION","PART_TYPE","PLANT","ALTERNATIVE","USAGE","EXPLOSION_DATE","QTY","FUNC_QTY","UOM","FUNCTION","FUNC_LEVEL","FUNC_OVERRIDE","PARENT_PART","PARENT_REVISION","PARENT_SEQUENCE_NO" FROM ATFUNCBOMWORKAREA
 ;
--------------------------------------------------------
--  DDL for View RVATTRIBUTE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVATTRIBUTE" ("ATTRIBUTE", "DESCRIPTION", "INTL", "STATUS") AS 
  SELECT "ATTRIBUTE","DESCRIPTION","INTL","STATUS" FROM ATTRIBUTE
 ;
--------------------------------------------------------
--  DDL for View RVATTRIBUTE_B
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVATTRIBUTE_B" ("ATTRIBUTE", "REVISION", "LANG_ID", "BUBBLE", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY") AS 
  SELECT "ATTRIBUTE","REVISION","LANG_ID","BUBBLE","LAST_MODIFIED_ON","LAST_MODIFIED_BY" FROM ATTRIBUTE_B
 ;
--------------------------------------------------------
--  DDL for View RVATTRIBUTE_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVATTRIBUTE_H" ("ATTRIBUTE", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED", "ES_SEQ_NO") AS 
  SELECT "ATTRIBUTE","REVISION","LANG_ID","DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","MAX_REV","DATE_IMPORTED","ES_SEQ_NO" FROM ATTRIBUTE_H
 ;
--------------------------------------------------------
--  DDL for View RVATTRIBUTE_PROPERTY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVATTRIBUTE_PROPERTY" ("PROPERTY", "ATTRIBUTE", "INTL") AS 
  SELECT "PROPERTY","ATTRIBUTE","INTL" FROM ATTRIBUTE_PROPERTY
 ;
--------------------------------------------------------
--  DDL for View RVATTRIBUTE_PROPERTY_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVATTRIBUTE_PROPERTY_H" ("PROPERTY", "ATTRIBUTE", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "INTL", "ACTION") AS 
  SELECT "PROPERTY","ATTRIBUTE","LAST_MODIFIED_ON","LAST_MODIFIED_BY","INTL","ACTION" FROM ATTRIBUTE_PROPERTY_H
 ;
--------------------------------------------------------
--  DDL for View RVATVERSIONINFO
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVATVERSIONINFO" ("TYPE", "ID", "INSTALLED_ON", "DESCRIPTION") AS 
  SELECT "TYPE","ID","INSTALLED_ON","DESCRIPTION" FROM ATVERSIONINFO
 ;
--------------------------------------------------------
--  DDL for View RVATVREDESTEIN_TOBEREMOVED
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVATVREDESTEIN_TOBEREMOVED" ("KEY", "VALUE") AS 
  SELECT "KEY","VALUE" FROM ATVREDESTEIN_TOBEREMOVED
 ;
--------------------------------------------------------
--  DDL for View RVCHARACTERISTIC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVCHARACTERISTIC" ("CHARACTERISTIC_ID", "DESCRIPTION", "INTL", "STATUS") AS 
  SELECT "CHARACTERISTIC_ID","DESCRIPTION","INTL","STATUS" FROM CHARACTERISTIC
 ;
--------------------------------------------------------
--  DDL for View RVCHARACTERISTIC_ASSOCIATION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVCHARACTERISTIC_ASSOCIATION" ("ASSOCIATION", "CHARACTERISTIC", "INTL") AS 
  SELECT "ASSOCIATION","CHARACTERISTIC","INTL" FROM CHARACTERISTIC_ASSOCIATION
 ;
--------------------------------------------------------
--  DDL for View RVCHARACTERISTIC_ASSOCIATION_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVCHARACTERISTIC_ASSOCIATION_H" ("CHARACTERISTIC_ID", "ASSOCIATION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "INTL", "ACTION") AS 
  SELECT "CHARACTERISTIC_ID","ASSOCIATION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","INTL","ACTION" FROM CHARACTERISTIC_ASSOCIATION_H
 ;
--------------------------------------------------------
--  DDL for View RVCHARACTERISTIC_B
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVCHARACTERISTIC_B" ("CHARACTERISTIC_ID", "REVISION", "LANG_ID", "BUBBLE", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY") AS 
  SELECT "CHARACTERISTIC_ID","REVISION","LANG_ID","BUBBLE","LAST_MODIFIED_ON","LAST_MODIFIED_BY" FROM CHARACTERISTIC_B
 ;
--------------------------------------------------------
--  DDL for View RVCHARACTERISTIC_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVCHARACTERISTIC_H" ("CHARACTERISTIC_ID", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED", "ES_SEQ_NO") AS 
  SELECT "CHARACTERISTIC_ID","REVISION","LANG_ID","DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","MAX_REV","DATE_IMPORTED","ES_SEQ_NO" FROM CHARACTERISTIC_H
 ;
--------------------------------------------------------
--  DDL for View RVCLASS3
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVCLASS3" ("CLASS", "SORT_DESC", "DESCRIPTION", "INTL", "TYPE", "STATUS") AS 
  SELECT "CLASS","SORT_DESC","DESCRIPTION","INTL","TYPE","STATUS" FROM CLASS3
 ;
--------------------------------------------------------
--  DDL for View RVCLASS3_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVCLASS3_H" ("CLASS", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "TYPE", "SORT_DESC", "MAX_REV", "DATE_IMPORTED", "ES_SEQ_NO") AS 
  SELECT "CLASS","REVISION","LANG_ID","DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","TYPE","SORT_DESC","MAX_REV","DATE_IMPORTED","ES_SEQ_NO" FROM CLASS3_H
 ;
--------------------------------------------------------
--  DDL for View RVCONDITION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVCONDITION" ("CONDITION", "DESCRIPTION", "INTL", "STATUS") AS 
  SELECT "CONDITION","DESCRIPTION","INTL","STATUS" FROM CONDITION
 ;
--------------------------------------------------------
--  DDL for View RVCONDITION_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVCONDITION_H" ("CONDITION", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED", "ES_SEQ_NO") AS 
  SELECT "CONDITION","REVISION","LANG_ID","DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","MAX_REV","DATE_IMPORTED","ES_SEQ_NO" FROM CONDITION_H
 ;
--------------------------------------------------------
--  DDL for View RVCTLICSECID
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVCTLICSECID" ("SERIAL_ID", "SETTING_SEQ", "SETTING_NAME", "SETTING_VALUE", "SHORTNAME") AS 
  SELECT "SERIAL_ID","SETTING_SEQ","SETTING_NAME","SETTING_VALUE","SHORTNAME" FROM CTLICSECID
 ;
--------------------------------------------------------
--  DDL for View RVCTLICSECIDAUXILIARY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVCTLICSECIDAUXILIARY" ("SERIAL_ID", "HASH_CODE_CLIENT", "HASH_CODE_SERVER", "TEMPLATE", "REF_DATE", "EXPIRATION_DATE", "SHORTNAME") AS 
  SELECT "SERIAL_ID","HASH_CODE_CLIENT","HASH_CODE_SERVER","TEMPLATE","REF_DATE","EXPIRATION_DATE","SHORTNAME" FROM CTLICSECIDAUXILIARY
 ;
--------------------------------------------------------
--  DDL for View RVCTLICSECIDAUXILIARYOLD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVCTLICSECIDAUXILIARYOLD" ("LOCAL_TRAN_ID", "LOGDATE", "SERIAL_ID", "SHORTNAME", "HASH_CODE_CLIENT", "HASH_CODE_SERVER", "TEMPLATE", "REF_DATE", "EXPIRATION_DATE") AS 
  SELECT "LOCAL_TRAN_ID","LOGDATE","SERIAL_ID","SHORTNAME","HASH_CODE_CLIENT","HASH_CODE_SERVER","TEMPLATE","REF_DATE","EXPIRATION_DATE" FROM CTLICSECIDAUXILIARYOLD
 ;
--------------------------------------------------------
--  DDL for View RVCTLICSECIDOLD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVCTLICSECIDOLD" ("LOCAL_TRAN_ID", "LOGDATE", "SERIAL_ID", "SHORTNAME", "SETTING_SEQ", "SETTING_NAME", "SETTING_VALUE") AS 
  SELECT "LOCAL_TRAN_ID","LOGDATE","SERIAL_ID","SHORTNAME","SETTING_SEQ","SETTING_NAME","SETTING_VALUE" FROM CTLICSECIDOLD
 ;
--------------------------------------------------------
--  DDL for View RVCTLICUSERCNT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVCTLICUSERCNT" ("USER_SID", "USER_NAME", "APP_ID", "APP_VERSION", "LIC_CHECK_APPLIES", "LOGON_DATE", "LAST_HEARTBEAT", "LOGOFF_DATE", "LOGON_STATION", "AUDSID", "APP_CUSTOM_PARAM") AS 
  SELECT "USER_SID","USER_NAME","APP_ID","APP_VERSION","LIC_CHECK_APPLIES","LOGON_DATE","LAST_HEARTBEAT","LOGOFF_DATE","LOGON_STATION","AUDSID","APP_CUSTOM_PARAM" FROM CTLICUSERCNT
 ;
--------------------------------------------------------
--  DDL for View RVDAISY_METHOD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVDAISY_METHOD" ("AV_METHOD", "METHOD", "PREPARATION", "AGING") AS 
  SELECT "AV_METHOD","METHOD","PREPARATION","AGING" FROM DAISY_METHOD
 ;
--------------------------------------------------------
--  DDL for View RVDEV_MGR
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVDEV_MGR" ("TABLE_NAME", "COL_SELECT", "COL_INSERT", "COL_UPDATE", "COL_DELETE") AS 
  SELECT "TABLE_NAME","COL_SELECT","COL_INSERT","COL_UPDATE","COL_DELETE" FROM DEV_MGR
 ;
--------------------------------------------------------
--  DDL for View RVEXEMPTION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVEXEMPTION" ("PART_NO", "PART_EXEMPTION_NO", "DESCRIPTION", "TEXT", "FROM_DATE", "TO_DATE") AS 
  SELECT "PART_NO","PART_EXEMPTION_NO","DESCRIPTION","TEXT","FROM_DATE","TO_DATE" FROM EXEMPTION
 ;
--------------------------------------------------------
--  DDL for View RVFORMAT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVFORMAT" ("FORMAT_ID", "DESCRIPTION", "INTL", "TYPE") AS 
  SELECT "FORMAT_ID","DESCRIPTION","INTL","TYPE" FROM FORMAT
 ;
--------------------------------------------------------
--  DDL for View RVFRAME_BUILDER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVFRAME_BUILDER" ("TABLE_NAME", "COL_SELECT", "COL_INSERT", "COL_UPDATE", "COL_DELETE") AS 
  SELECT "TABLE_NAME","COL_SELECT","COL_INSERT","COL_UPDATE","COL_DELETE" FROM FRAME_BUILDER
 ;
--------------------------------------------------------
--  DDL for View RVFRAME_HEADER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVFRAME_HEADER" ("FRAME_NO", "REVISION", "OWNER", "STATUS", "DESCRIPTION", "STATUS_CHANGE_DATE", "CREATED_BY", "CREATED_ON", "LAST_MODIFIED_BY", "LAST_MODIFIED_ON", "INTL", "CLASS3_ID", "WORKFLOW_GROUP_ID", "ACCESS_GROUP", "INT_FRAME_NO", "INT_FRAME_REV", "EXPORTED") AS 
  SELECT "FRAME_NO","REVISION","OWNER","STATUS","DESCRIPTION","STATUS_CHANGE_DATE","CREATED_BY","CREATED_ON","LAST_MODIFIED_BY","LAST_MODIFIED_ON","INTL","CLASS3_ID","WORKFLOW_GROUP_ID","ACCESS_GROUP","INT_FRAME_NO","INT_FRAME_REV","EXPORTED" FROM FRAME_HEADER
 ;
--------------------------------------------------------
--  DDL for View RVFRAME_KW
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVFRAME_KW" ("FRAME_NO", "KW_ID", "KW_VALUE", "INTL", "OWNER") AS 
  SELECT "FRAME_NO","KW_ID","KW_VALUE","INTL","OWNER" FROM FRAME_KW
 ;
--------------------------------------------------------
--  DDL for View RVFRAME_PROP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVFRAME_PROP" ("FRAME_NO", "REVISION", "OWNER", "SECTION_ID", "SECTION_REV", "SUB_SECTION_ID", "SUB_SECTION_REV", "PROPERTY_GROUP", "PROPERTY_GROUP_REV", "PROPERTY", "PROPERTY_REV", "ATTRIBUTE", "ATTRIBUTE_REV", "UOM_ID", "UOM_REV", "TEST_METHOD", "TEST_METHOD_REV", "SEQUENCE_NO", "NUM_1", "NUM_2", "NUM_3", "NUM_4", "NUM_5", "NUM_6", "NUM_7", "NUM_8", "NUM_9", "NUM_10", "CHAR_1", "CHAR_2", "CHAR_3", "CHAR_4", "CHAR_5", "CHAR_6", "BOOLEAN_1", "BOOLEAN_2", "BOOLEAN_3", "BOOLEAN_4", "DATE_1", "DATE_2", "CHARACTERISTIC", "ASSOCIATION", "INTL", "MANDATORY", "CHARACTERISTIC_REV", "ASSOCIATION_REV", "UOM_ALT_ID", "UOM_ALT_REV", "CH_2", "CH_REV_2", "CH_3", "CH_REV_3", "AS_2", "AS_REV_2", "AS_3", "AS_REV_3") AS 
  SELECT "FRAME_NO","REVISION","OWNER","SECTION_ID","SECTION_REV","SUB_SECTION_ID","SUB_SECTION_REV","PROPERTY_GROUP","PROPERTY_GROUP_REV","PROPERTY","PROPERTY_REV","ATTRIBUTE","ATTRIBUTE_REV","UOM_ID","UOM_REV","TEST_METHOD","TEST_METHOD_REV","SEQUENCE_NO","NUM_1","NUM_2","NUM_3","NUM_4","NUM_5","NUM_6","NUM_7","NUM_8","NUM_9","NUM_10","CHAR_1","CHAR_2","CHAR_3","CHAR_4","CHAR_5","CHAR_6","BOOLEAN_1","BOOLEAN_2","BOOLEAN_3","BOOLEAN_4","DATE_1","DATE_2","CHARACTERISTIC","ASSOCIATION","INTL","MANDATORY","CHARACTERISTIC_REV","ASSOCIATION_REV","UOM_ALT_ID","UOM_ALT_REV","CH_2","CH_REV_2","CH_3","CH_REV_3","AS_2","AS_REV_2","AS_3","AS_REV_3" FROM FRAME_PROP
 ;
--------------------------------------------------------
--  DDL for View RVFRAME_SECTION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVFRAME_SECTION" ("FRAME_NO", "REVISION", "OWNER", "SECTION_ID", "SECTION_REV", "SUB_SECTION_ID", "SUB_SECTION_REV", "TYPE", "REF_ID", "SEQUENCE_NO", "HEADER", "MANDATORY", "SECTION_SEQUENCE_NO", "REF_VER", "REF_INFO", "DISPLAY_FORMAT", "DISPLAY_FORMAT_REV", "ASSOCIATION", "INTL", "REF_OWNER", "SC_EXT", "REF_EXT") AS 
  SELECT "FRAME_NO","REVISION","OWNER","SECTION_ID","SECTION_REV","SUB_SECTION_ID","SUB_SECTION_REV","TYPE","REF_ID","SEQUENCE_NO","HEADER","MANDATORY","SECTION_SEQUENCE_NO","REF_VER","REF_INFO","DISPLAY_FORMAT","DISPLAY_FORMAT_REV","ASSOCIATION","INTL","REF_OWNER","SC_EXT","REF_EXT" FROM FRAME_SECTION
 ;
--------------------------------------------------------
--  DDL for View RVFRAME_TEXT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVFRAME_TEXT" ("FRAME_NO", "REVISION", "OWNER", "SECTION_ID", "SECTION_REV", "SUB_SECTION_ID", "SUB_SECTION_REV", "TEXT_TYPE", "TEXT", "TEXT_TYPE_REV") AS 
  SELECT "FRAME_NO","REVISION","OWNER","SECTION_ID","SECTION_REV","SUB_SECTION_ID","SUB_SECTION_REV","TEXT_TYPE","TEXT","TEXT_TYPE_REV" FROM FRAME_TEXT
 ;
--------------------------------------------------------
--  DDL for View RVFRAMEDATA
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVFRAMEDATA" ("FRAME_NO", "REVISION", "OWNER", "SECTION_ID", "SUB_SECTION_ID", "SEQUENCE_NO", "TYPE", "REF_ID", "REF_VER", "PROPERTY_GROUP", "PROPERTY", "ATTRIBUTE", "HEADER_ID", "VALUE", "VALUE_S", "UOM_ID", "TEST_METHOD", "CHARACTERISTIC", "ASSOCIATION", "REF_INFO", "INTL", "VALUE_TYPE", "VALUE_DT", "SECTION_REV", "SUB_SECTION_REV", "PROPERTY_GROUP_REV", "PROPERTY_REV", "ATTRIBUTE_REV", "UOM_REV", "TEST_METHOD_REV", "CHARACTERISTIC_REV", "ASSOCIATION_REV", "HEADER_REV", "REF_OWNER") AS 
  SELECT "FRAME_NO","REVISION","OWNER","SECTION_ID","SUB_SECTION_ID","SEQUENCE_NO","TYPE","REF_ID","REF_VER","PROPERTY_GROUP","PROPERTY","ATTRIBUTE","HEADER_ID","VALUE","VALUE_S","UOM_ID","TEST_METHOD","CHARACTERISTIC","ASSOCIATION","REF_INFO","INTL","VALUE_TYPE","VALUE_DT","SECTION_REV","SUB_SECTION_REV","PROPERTY_GROUP_REV","PROPERTY_REV","ATTRIBUTE_REV","UOM_REV","TEST_METHOD_REV","CHARACTERISTIC_REV","ASSOCIATION_REV","HEADER_REV","REF_OWNER" FROM FRAMEDATA
 ;
--------------------------------------------------------
--  DDL for View RVFRAMEDATA_SERVER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVFRAMEDATA_SERVER" ("FRAME_NO", "REVISION", "OWNER", "DATE_PROCESSED") AS 
  SELECT "FRAME_NO","REVISION","OWNER","DATE_PROCESSED" FROM FRAMEDATA_SERVER
 ;
--------------------------------------------------------
--  DDL for View RVFT_ATTACH_SPEC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVFT_ATTACH_SPEC" ("PART_NO", "REF_ID", "ATTACHED_PART_NO", "ATTACHED_REVISION", "SECTION_ID", "SUB_SECTION_ID", "INTL") AS 
  SELECT "PART_NO","REF_ID","ATTACHED_PART_NO","ATTACHED_REVISION","SECTION_ID","SUB_SECTION_ID","INTL" FROM FT_ATTACH_SPEC
 ;
--------------------------------------------------------
--  DDL for View RVFT_BASE_RULES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVFT_BASE_RULES" ("FT_GROUP_ID", "FT_ID", "OLD_SECTION", "OLD_SUB_SECTION", "OLD_PROP_GROUP", "OLD_PROPERTY", "OLD_ATTRIBUTE", "OLD_COLUMN", "NEW_SECTION", "NEW_SUB_SECTION", "NEW_PROP_GROUP", "NEW_PROPERTY", "NEW_ATTRIBUTE", "NEW_COLUMN", "OBJECT_TYPE") AS 
  SELECT "FT_GROUP_ID","FT_ID","OLD_SECTION","OLD_SUB_SECTION","OLD_PROP_GROUP","OLD_PROPERTY","OLD_ATTRIBUTE","OLD_COLUMN","NEW_SECTION","NEW_SUB_SECTION","NEW_PROP_GROUP","NEW_PROPERTY","NEW_ATTRIBUTE","NEW_COLUMN","OBJECT_TYPE" FROM FT_BASE_RULES
 ;
--------------------------------------------------------
--  DDL for View RVFT_BASE_RULES_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVFT_BASE_RULES_H" ("FT_GROUP_ID", "FT_ID", "OLD_SECTION", "OLD_SUB_SECTION", "OLD_PROP_GROUP", "OLD_PROPERTY", "OLD_ATTRIBUTE", "OLD_COLUMN", "NEW_SECTION", "NEW_SUB_SECTION", "NEW_PROP_GROUP", "NEW_PROPERTY", "NEW_ATTRIBUTE", "NEW_COLUMN", "OBJECT_TYPE", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "ACTION") AS 
  SELECT "FT_GROUP_ID","FT_ID","OLD_SECTION","OLD_SUB_SECTION","OLD_PROP_GROUP","OLD_PROPERTY","OLD_ATTRIBUTE","OLD_COLUMN","NEW_SECTION","NEW_SUB_SECTION","NEW_PROP_GROUP","NEW_PROPERTY","NEW_ATTRIBUTE","NEW_COLUMN","OBJECT_TYPE","LAST_MODIFIED_ON","LAST_MODIFIED_BY","ACTION" FROM FT_BASE_RULES_H
 ;
--------------------------------------------------------
--  DDL for View RVFT_FRAMES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVFT_FRAMES" ("FT_GROUP_ID", "FT_FRAME_ID", "OLD_FRAME_NO", "OLD_FRAME_REV", "OLD_FRAME_OWNER", "NEW_FRAME_NO", "NEW_FRAME_REV", "NEW_FRAME_OWNER", "OLD_FRAME_REV_FROM", "OLD_FRAME_REV_TO", "NEW_FRAME_REV_FROM", "NEW_FRAME_REV_TO") AS 
  SELECT "FT_GROUP_ID","FT_FRAME_ID","OLD_FRAME_NO","OLD_FRAME_REV","OLD_FRAME_OWNER","NEW_FRAME_NO","NEW_FRAME_REV","NEW_FRAME_OWNER","OLD_FRAME_REV_FROM","OLD_FRAME_REV_TO","NEW_FRAME_REV_FROM","NEW_FRAME_REV_TO" FROM FT_FRAMES
 ;
--------------------------------------------------------
--  DDL for View RVFT_FRAMES_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVFT_FRAMES_H" ("FT_GROUP_ID", "FT_FRAME_ID", "OLD_FRAME_NO", "OLD_FRAME_REV", "OLD_FRAME_OWNER", "NEW_FRAME_NO", "NEW_FRAME_REV", "NEW_FRAME_OWNER", "OLD_FRAME_REV_FROM", "OLD_FRAME_REV_TO", "NEW_FRAME_REV_FROM", "NEW_FRAME_REV_TO", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "ACTION") AS 
  SELECT "FT_GROUP_ID","FT_FRAME_ID","OLD_FRAME_NO","OLD_FRAME_REV","OLD_FRAME_OWNER","NEW_FRAME_NO","NEW_FRAME_REV","NEW_FRAME_OWNER","OLD_FRAME_REV_FROM","OLD_FRAME_REV_TO","NEW_FRAME_REV_FROM","NEW_FRAME_REV_TO","LAST_MODIFIED_ON","LAST_MODIFIED_BY","ACTION" FROM FT_FRAMES_H
 ;
--------------------------------------------------------
--  DDL for View RVFT_RULE_GROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVFT_RULE_GROUP" ("FT_RULE_ID", "DESCRIPTION") AS 
  SELECT "FT_RULE_ID","DESCRIPTION" FROM FT_RULE_GROUP
 ;
--------------------------------------------------------
--  DDL for View RVFT_RULE_GROUP_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVFT_RULE_GROUP_H" ("FT_RULE_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "ACTION", "DATE_IMPORTED") AS 
  SELECT "FT_RULE_ID","DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","ACTION","DATE_IMPORTED" FROM FT_RULE_GROUP_H
 ;
--------------------------------------------------------
--  DDL for View RVFT_SPEC_PROP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVFT_SPEC_PROP" ("PART_NO", "SECTION_ID", "SECTION_REV", "SUB_SECTION_ID", "SUB_SECTION_REV", "PROPERTY_GROUP", "PROPERTY_GROUP_REV", "PROPERTY", "PROPERTY_REV", "ATTRIBUTE", "ATTRIBUTE_REV", "UOM_ID", "UOM_REV", "TEST_METHOD", "TEST_METHOD_REV", "SEQUENCE_NO", "NUM_1", "NUM_2", "NUM_3", "NUM_4", "NUM_5", "NUM_6", "NUM_7", "NUM_8", "NUM_9", "NUM_10", "CHAR_1", "CHAR_2", "CHAR_3", "CHAR_4", "CHAR_5", "CHAR_6", "BOOLEAN_1", "BOOLEAN_2", "BOOLEAN_3", "BOOLEAN_4", "DATE_1", "DATE_2", "CHARACTERISTIC", "CHARACTERISTIC_REV", "ASSOCIATION", "ASSOCIATION_REV", "INTL", "AS_2", "AS_REV_2", "AS_3", "AS_REV_3", "TM_DET_1", "TM_DET_2", "TM_DET_3", "TM_DET_4", "INFO", "TM_SET_NO") AS 
  SELECT "PART_NO","SECTION_ID","SECTION_REV","SUB_SECTION_ID","SUB_SECTION_REV","PROPERTY_GROUP","PROPERTY_GROUP_REV","PROPERTY","PROPERTY_REV","ATTRIBUTE","ATTRIBUTE_REV","UOM_ID","UOM_REV","TEST_METHOD","TEST_METHOD_REV","SEQUENCE_NO","NUM_1","NUM_2","NUM_3","NUM_4","NUM_5","NUM_6","NUM_7","NUM_8","NUM_9","NUM_10","CHAR_1","CHAR_2","CHAR_3","CHAR_4","CHAR_5","CHAR_6","BOOLEAN_1","BOOLEAN_2","BOOLEAN_3","BOOLEAN_4","DATE_1","DATE_2","CHARACTERISTIC","CHARACTERISTIC_REV","ASSOCIATION","ASSOCIATION_REV","INTL","AS_2","AS_REV_2","AS_3","AS_REV_3","TM_DET_1","TM_DET_2","TM_DET_3","TM_DET_4","INFO","TM_SET_NO" FROM FT_SPEC_PROP
 ;
--------------------------------------------------------
--  DDL for View RVFT_SPEC_PROP_LANG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVFT_SPEC_PROP_LANG" ("PART_NO", "SECTION_ID", "SUB_SECTION_ID", "PROPERTY_GROUP", "PROPERTY", "ATTRIBUTE", "LANG_ID", "SEQUENCE_NO", "CHAR_1", "CHAR_2", "CHAR_3", "CHAR_4", "CHAR_5", "CHAR_6", "INTL", "INFO") AS 
  SELECT "PART_NO","SECTION_ID","SUB_SECTION_ID","PROPERTY_GROUP","PROPERTY","ATTRIBUTE","LANG_ID","SEQUENCE_NO","CHAR_1","CHAR_2","CHAR_3","CHAR_4","CHAR_5","CHAR_6","INTL","INFO" FROM FT_SPEC_PROP_LANG
 ;
--------------------------------------------------------
--  DDL for View RVFT_SPEC_SECTION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVFT_SPEC_SECTION" ("PART_NO", "SECTION_ID", "SUB_SECTION_ID", "TYPE", "REF_ID", "REF_VER", "REF_INFO", "SEQUENCE_NO", "HEADER", "MANDATORY", "SECTION_SEQUENCE_NO", "DISPLAY_FORMAT", "ASSOCIATION", "INTL", "SECTION_REV", "SUB_SECTION_REV", "DISPLAY_FORMAT_REV", "REF_OWNER") AS 
  SELECT "PART_NO","SECTION_ID","SUB_SECTION_ID","TYPE","REF_ID","REF_VER","REF_INFO","SEQUENCE_NO","HEADER","MANDATORY","SECTION_SEQUENCE_NO","DISPLAY_FORMAT","ASSOCIATION","INTL","SECTION_REV","SUB_SECTION_REV","DISPLAY_FORMAT_REV","REF_OWNER" FROM FT_SPEC_SECTION
 ;
--------------------------------------------------------
--  DDL for View RVFT_SPEC_TEXT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVFT_SPEC_TEXT" ("PART_NO", "TEXT_TYPE", "TEXT", "SECTION_ID", "SECTION_REV", "SUB_SECTION_ID", "SUB_SECTION_REV", "TEXT_TYPE_REV", "LANG_ID") AS 
  SELECT "PART_NO","TEXT_TYPE","TEXT","SECTION_ID","SECTION_REV","SUB_SECTION_ID","SUB_SECTION_REV","TEXT_TYPE_REV","LANG_ID" FROM FT_SPEC_TEXT
 ;
--------------------------------------------------------
--  DDL for View RVFT_SPEC_TM
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVFT_SPEC_TM" ("PART_NO", "SECTION_ID", "SUB_SECTION_ID", "PROPERTY_GROUP", "PROPERTY", "ATTRIBUTE", "SEQ_NO", "TM_TYPE", "TM", "TM_REV", "TM_SET_NO") AS 
  SELECT "PART_NO","SECTION_ID","SUB_SECTION_ID","PROPERTY_GROUP","PROPERTY","ATTRIBUTE","SEQ_NO","TM_TYPE","TM","TM_REV","TM_SET_NO" FROM FT_SPEC_TM
 ;
--------------------------------------------------------
--  DDL for View RVFT_SQL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVFT_SQL" ("FT_GROUP_ID", "FT_ID", "SQL_TEXT") AS 
  SELECT "FT_GROUP_ID","FT_ID","SQL_TEXT" FROM FT_SQL
 ;
--------------------------------------------------------
--  DDL for View RVFT_SQL_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVFT_SQL_H" ("FT_GROUP_ID", "FT_ID", "SQL_TEXT", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "ACTION") AS 
  SELECT "FT_GROUP_ID","FT_ID","SQL_TEXT","LAST_MODIFIED_ON","LAST_MODIFIED_BY","ACTION" FROM FT_SQL_H
 ;
--------------------------------------------------------
--  DDL for View RVFUNCTIONS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVFUNCTIONS" ("FUNCTION_ID", "DESCRIPTION", "INTL") AS 
  SELECT "FUNCTION_ID","DESCRIPTION","INTL" FROM FUNCTIONS
 ;
--------------------------------------------------------
--  DDL for View RVGRANT_EXECUTE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVGRANT_EXECUTE" ("OBJECT_NAME", "CONFIGURATOR", "APPROVER", "DEV_MGR", "VIEW_ONLY", "MRP", "FRAME_BUILDER") AS 
  SELECT "OBJECT_NAME","CONFIGURATOR","APPROVER","DEV_MGR","VIEW_ONLY","MRP","FRAME_BUILDER" FROM GRANT_EXECUTE
 ;
--------------------------------------------------------
--  DDL for View RVGROUP_PROPERTY_LIMIT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVGROUP_PROPERTY_LIMIT" ("PROPERTY_GROUP", "PROPERTY", "UOM_ID", "LOWER_REJECT", "UPPER_REJECT", "INTL") AS 
  SELECT "PROPERTY_GROUP","PROPERTY","UOM_ID","LOWER_REJECT","UPPER_REJECT","INTL" FROM GROUP_PROPERTY_LIMIT
 ;
--------------------------------------------------------
--  DDL for View RVHEADER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVHEADER" ("HEADER_ID", "DESCRIPTION", "INTL", "STATUS") AS 
  SELECT "HEADER_ID","DESCRIPTION","INTL","STATUS" FROM HEADER
 ;
--------------------------------------------------------
--  DDL for View RVHEADER_B
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVHEADER_B" ("HEADER_ID", "REVISION", "LANG_ID", "BUBBLE", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY") AS 
  SELECT "HEADER_ID","REVISION","LANG_ID","BUBBLE","LAST_MODIFIED_ON","LAST_MODIFIED_BY" FROM HEADER_B
 ;
--------------------------------------------------------
--  DDL for View RVHEADER_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVHEADER_H" ("HEADER_ID", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED", "ES_SEQ_NO") AS 
  SELECT "HEADER_ID","REVISION","LANG_ID","DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","MAX_REV","DATE_IMPORTED","ES_SEQ_NO" FROM HEADER_H
 ;
--------------------------------------------------------
--  DDL for View RVI_ACCESS_GROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_ACCESS_GROUP" ("ACCESS_GROUP_ID", "SORT_DESC", "DESCRIPTION") AS 
  SELECT access_group as access_group_id,
          sort_desc,
          description
     FROM access_group
 ;
--------------------------------------------------------
--  DDL for View RVI_APPLICATION_USER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_APPLICATION_USER" ("USER_ID", "FORENAME", "LAST_NAME", "USER_INITIALS", "TELEPHONE_NO", "EMAIL_ADDRESS", "CURRENT_ONLY", "INITIAL_PROFILE", "USER_PROFILE", "USER_DROPPED", "PROD_ACCESS", "PLAN_ACCESS", "PHASE_ACCESS", "PRINTING_ALLOWED", "INTL", "FRAMES_ONLY", "REFERENCE_TEXT", "APPROVED_ONLY", "LOC_DESCRIPTION", "LOC_STATUS", "CAT_DESCRIPTION", "CAT_STATUS", "OVERRIDE_PART_VAL", "WEB_ALLOWED", "LIMITED_CONFIGURATOR", "PLANT_ACCESS", "VIEW_BOM") AS 
  SELECT RVapplication_user.user_id,
       RVapplication_user.forename,
       RVapplication_user.last_name,
       RVapplication_user.user_initials,
       RVapplication_user.telephone_no,
       RVapplication_user.email_address,
       RVapplication_user.current_only,
       RVapplication_user.initial_profile,
       RVapplication_user.user_profile,
       RVapplication_user.user_dropped,
       RVapplication_user.prod_access,
       RVapplication_user.plan_access,
       RVapplication_user.phase_access,
       RVapplication_user.printing_allowed,
       RVapplication_user.intl,
       RVapplication_user.frames_only,
       RVapplication_user.reference_text,
       RVapplication_user.approved_only,
       RVitusloc.description loc_description,
       RVitusloc.status loc_status,
       RVituscat.description cat_description,
       RVituscat.status cat_status,
       RVapplication_user.override_part_val,
       RVapplication_user.web_allowed,
       RVapplication_user.limited_configurator,
       RVapplication_user.plant_access,
       RVapplication_user.view_bom
  FROM RVapplication_user, RVituscat, RVitusloc
 WHERE RVituscat.cat_id(+) = RVapplication_user.cat_id
   AND RVitusloc.loc_id(+) = RVapplication_user.loc_id
 ;
--------------------------------------------------------
--  DDL for View RVI_ASSOCIATION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_ASSOCIATION" ("ASSOCIATION", "INTL", "STATUS", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "ASSOCIATION_TYPE", "MAX_REV", "DATE_IMPORTED", "ES_SEQ_NO") AS 
  SELECT
  ass.association,
  ass.intl,
  ass.status,
  ass_h.revision,
  ass_h.lang_id,
  ass_h.description,
  ass_h.last_modified_on,
  ass_h.last_modified_by,
  ass_h.association_type,
  ass_h.max_rev,
  ass_h.date_imported,
  ass_h.es_seq_no
FROM
  RVassociation ass,
  RVassociation_h ass_h
WHERE
  ass.association = ass_h.association(+) and ass_h.max_rev=1
 ;
--------------------------------------------------------
--  DDL for View RVI_ATTRIBUTE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_ATTRIBUTE" ("ATTRIBUTE_ID", "INTL", "STATUS", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED") AS 
  SELECT
  att_h.ATTRIBUTE as attribute_id,
  att.intl,
  att.status,
  att_h.revision,
  att_h.lang_id,
  att_h.description,
  att_h.last_modified_on,
  att_h.last_modified_by,
  att_h.max_rev,
  att_h.date_imported
FROM
  RVATTRIBUTE att,
  RVattribute_h att_h
WHERE
  att.ATTRIBUTE = att_h.ATTRIBUTE(+) and att_h.max_rev=1
 ;
--------------------------------------------------------
--  DDL for View RVI_ATTRIBUTE_PROPERTY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_ATTRIBUTE_PROPERTY" ("PROPERTY_ID", "ATTRIBUTE_ID", "INTL") AS 
  SELECT
  property as property_id,
  ATTRIBUTE as attribute_id,
  INTL
FROM
  attribute_property
 ;
--------------------------------------------------------
--  DDL for View RVI_AUDIT_ACCESS_GROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_AUDIT_ACCESS_GROUP" ("SORT_DESC", "USER_ID", "FORENAME", "LAST_NAME", "TIMESTAMP", "AUDIT_TRAIL_SEQ_NO", "SEQ_NO", "DETAILS") AS 
  SELECT "RVACCESS_GROUP"."SORT_DESC",
       "RVITAGHS"."USER_ID",
       "RVITAGHS"."FORENAME",
       "RVITAGHS"."LAST_NAME",
       "RVITAGHS"."TIMESTAMP",
       "RVITAGHSDETAILS"."AUDIT_TRAIL_SEQ_NO",
       "RVITAGHSDETAILS"."SEQ_NO",
       "RVITAGHSDETAILS"."DETAILS"
  FROM "RVACCESS_GROUP", "RVITAGHS", "RVITAGHSDETAILS"
 WHERE ("RVACCESS_GROUP"."ACCESS_GROUP"(+) = "RVITAGHS"."ACCESS_GROUP")
   AND ("RVITAGHS"."ACCESS_GROUP" = "RVITAGHSDETAILS"."ACCESS_GROUP")
   AND ("RVITAGHS"."AUDIT_TRAIL_SEQ_NO" = "RVITAGHSDETAILS"."AUDIT_TRAIL_SEQ_NO")
 ;
--------------------------------------------------------
--  DDL for View RVI_AUDIT_PREFERENCES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_AUDIT_PREFERENCES" ("SECTION", "PARAMETER", "USER_ID", "FORENAME", "LAST_NAME", "TIMESTAMP", "SIGN_FOR", "SIGN_WHAT") AS 
  SELECT   "RVINTERSPC_CFG_H"."SECTION",
         "RVINTERSPC_CFG_H"."PARAMETER",
         "RVINTERSPC_CFG_H"."USER_ID",
         "RVINTERSPC_CFG_H"."FORENAME",
         "RVINTERSPC_CFG_H"."LAST_NAME",
         "RVINTERSPC_CFG_H"."TIMESTAMP",
         "RVINTERSPC_CFG_H"."SIGN_FOR",
         "RVINTERSPC_CFG_H"."SIGN_WHAT"
    FROM "RVINTERSPC_CFG_H", "RVINTERSPC_CFG"
   WHERE ("RVINTERSPC_CFG_H"."SECTION" = "RVINTERSPC_CFG"."SECTION")
     AND ("RVINTERSPC_CFG_H"."PARAMETER" = "RVINTERSPC_CFG"."PARAMETER")
     AND (("RVINTERSPC_CFG"."VISIBLE" = '1'))
 ;
--------------------------------------------------------
--  DDL for View RVI_AUDIT_REPORT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_AUDIT_REPORT" ("DESCRIPTION", "USER_ID", "FORENAME", "LAST_NAME", "TIMESTAMP", "AUDIT_TRAIL_SEQ_NO", "SEQ_NO", "DETAILS") AS 
  SELECT DECODE ("RVITREPHS"."REP_ID",
               0, 'SQL',
               "RVITREPD"."SORT_DESC"
              ) description,
       "RVITREPHS"."USER_ID",
       "RVITREPHS"."FORENAME",
       "RVITREPHS"."LAST_NAME",
       "RVITREPHS"."TIMESTAMP",
       "RVITREPHSDETAILS"."AUDIT_TRAIL_SEQ_NO",
       "RVITREPHSDETAILS"."SEQ_NO",
       "RVITREPHSDETAILS"."DETAILS"
  FROM "RVITREPD", "RVITREPHS", "RVITREPHSDETAILS"
 WHERE ("RVITREPD"."REP_ID"(+) = "RVITREPHS"."REP_ID")
   AND ("RVITREPHS"."REP_ID" = "RVITREPHSDETAILS"."REP_ID")
   AND ("RVITREPHS"."AUDIT_TRAIL_SEQ_NO" = "RVITREPHSDETAILS"."AUDIT_TRAIL_SEQ_NO")
 ;
--------------------------------------------------------
--  DDL for View RVI_AUDIT_REPORT_GROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_AUDIT_REPORT_GROUP" ("DESCRIPTION", "USER_ID", "FORENAME", "LAST_NAME", "TIMESTAMP", "AUDIT_TRAIL_SEQ_NO", "SEQ_NO", "DETAILS") AS 
  SELECT "RVITREPG"."DESCRIPTION",
       "RVITREPGHS"."USER_ID",
       "RVITREPGHS"."FORENAME",
       "RVITREPGHS"."LAST_NAME",
       "RVITREPGHS"."TIMESTAMP",
       "RVITREPGHSDETAILS"."AUDIT_TRAIL_SEQ_NO",
       "RVITREPGHSDETAILS"."SEQ_NO",
       "RVITREPGHSDETAILS"."DETAILS"
  FROM "RVITREPG", "RVITREPGHS", "RVITREPGHSDETAILS"
 WHERE ("RVITREPG"."REPG_ID"(+) = "RVITREPGHS"."REPG_ID")
   AND ("RVITREPGHS"."REPG_ID" = "RVITREPGHSDETAILS"."REPG_ID")
   AND ("RVITREPGHS"."AUDIT_TRAIL_SEQ_NO" = "RVITREPGHSDETAILS"."AUDIT_TRAIL_SEQ_NO")
 ;
--------------------------------------------------------
--  DDL for View RVI_AUDIT_STATUS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_AUDIT_STATUS" ("DESCRIPTION", "USER_ID", "FORENAME", "LAST_NAME", "TIMESTAMP", "SEQ_NO", "DETAILS") AS 
  SELECT "RVSTATUS"."DESCRIPTION",
       "RVITSSHS"."USER_ID",
       "RVITSSHS"."FORENAME",
       "RVITSSHS"."LAST_NAME",
       "RVITSSHS"."TIMESTAMP",
       "RVITSSHSDETAILS"."SEQ_NO",
       "RVITSSHSDETAILS"."DETAILS"
  FROM "RVSTATUS", "RVITSSHS", "RVITSSHSDETAILS"
 WHERE ("RVSTATUS"."STATUS"(+) = "RVITSSHS"."STATUS")
   AND ("RVITSSHS"."STATUS" = "RVITSSHSDETAILS"."STATUS")
   AND ("RVITSSHS"."AUDIT_TRAIL_SEQ_NO" = "RVITSSHSDETAILS"."AUDIT_TRAIL_SEQ_NO")
 ;
--------------------------------------------------------
--  DDL for View RVI_AUDIT_USER_CONFIG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_AUDIT_USER_CONFIG" ("USER_ID_CHANGED", "USER_ID", "FORENAME", "LAST_NAME", "TIMESTAMP", "AUDIT_TRAIL_SEQ_NO", "SEQ_NO", "DETAILS") AS 
  SELECT   RVITUSHS.USER_ID_CHANGED,
         RVITUSHS.USER_ID,
         RVITUSHS.FORENAME,
         RVITUSHS.LAST_NAME,
         RVITUSHS.TIMESTAMP,
         RVITUSHSDETAILS.AUDIT_TRAIL_SEQ_NO,
         RVITUSHSDETAILS.SEQ_NO,
         RVITUSHSDETAILS.DETAILS
    FROM RVITUSHS, RVITUSHSDETAILS
   WHERE (RVITUSHS.USER_ID_CHANGED = RVITUSHSDETAILS.USER_ID_CHANGED)
     AND (RVITUSHS.AUDIT_TRAIL_SEQ_NO = RVITUSHSDETAILS.AUDIT_TRAIL_SEQ_NO)
 ;
--------------------------------------------------------
--  DDL for View RVI_AUDIT_USER_GROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_AUDIT_USER_GROUP" ("SHORT_DESC", "USER_ID", "FORENAME", "LAST_NAME", "TIMESTAMP", "AUDIT_TRAIL_SEQ_NO", "SEQ_NO", "DETAILS") AS 
  SELECT   "RVUSER_GROUP"."SHORT_DESC",
         "RVITUGHS"."USER_ID",
         "RVITUGHS"."FORENAME",
         "RVITUGHS"."LAST_NAME",
         "RVITUGHS"."TIMESTAMP",
         "RVITUGHSDETAILS"."AUDIT_TRAIL_SEQ_NO",
         "RVITUGHSDETAILS"."SEQ_NO",
         "RVITUGHSDETAILS"."DETAILS"
    FROM "RVUSER_GROUP", "RVITUGHS", "RVITUGHSDETAILS"
   WHERE ("RVUSER_GROUP"."USER_GROUP_ID"(+) = "RVITUGHS"."USER_GROUP_ID")
     AND ("RVITUGHS"."USER_GROUP_ID" = "RVITUGHSDETAILS"."USER_GROUP_ID")
     AND ("RVITUGHS"."AUDIT_TRAIL_SEQ_NO" = "RVITUGHSDETAILS"."AUDIT_TRAIL_SEQ_NO")
 ;
--------------------------------------------------------
--  DDL for View RVI_AUDIT_WORKFLOW_GROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_AUDIT_WORKFLOW_GROUP" ("SORT_DESC", "USER_ID", "FORENAME", "LAST_NAME", "TIMESTAMP", "SEQ_NO", "DETAILS", "AUDIT_TRAIL_SEQ_NO") AS 
  SELECT "RVWORKFLOW_GROUP"."SORT_DESC",
       "RVITWGHS"."USER_ID",
       "RVITWGHS"."FORENAME",
       "RVITWGHS"."LAST_NAME",
       "RVITWGHS"."TIMESTAMP",
       "RVITWGHSDETAILS"."SEQ_NO",
       "RVITWGHSDETAILS"."DETAILS",
       "RVITWGHSDETAILS"."AUDIT_TRAIL_SEQ_NO"
  FROM "RVITWGHS", "RVITWGHSDETAILS", "RVWORKFLOW_GROUP"
 WHERE ("RVITWGHS"."WORKFLOW_GROUP_ID" = "RVITWGHSDETAILS"."WORKFLOW_GROUP_ID")
   AND ("RVITWGHS"."AUDIT_TRAIL_SEQ_NO" = "RVITWGHSDETAILS"."AUDIT_TRAIL_SEQ_NO")
   AND ("RVWORKFLOW_GROUP"."WORKFLOW_GROUP_ID"(+) = "RVITWGHS"."WORKFLOW_GROUP_ID")
 ;
--------------------------------------------------------
--  DDL for View RVI_AUDIT_WORKFLOW_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_AUDIT_WORKFLOW_TYPE" ("DESCRIPTION", "USER_ID", "FORENAME", "LAST_NAME", "TIMESTAMP", "SEQ_NO", "DETAILS") AS 
  SELECT "RVWORK_FLOW_GROUP"."DESCRIPTION",
       "RVITWTHS"."USER_ID",
       "RVITWTHS"."FORENAME",
       "RVITWTHS"."LAST_NAME",
       "RVITWTHS"."TIMESTAMP",
       "RVITWTHSDETAILS"."SEQ_NO",
       "RVITWTHSDETAILS"."DETAILS"
  FROM "RVWORK_FLOW_GROUP", "RVITWTHS", "RVITWTHSDETAILS"
 WHERE ("RVWORK_FLOW_GROUP"."WORK_FLOW_ID"(+) = "RVITWTHS"."WORK_FLOW_ID")
   AND ("RVITWTHS"."WORK_FLOW_ID" = "RVITWTHSDETAILS"."WORK_FLOW_ID")
   AND ("RVITWTHS"."AUDIT_TRAIL_SEQ_NO" = "RVITWTHSDETAILS"."AUDIT_TRAIL_SEQ_NO")
 ;
--------------------------------------------------------
--  DDL for View RVI_BOM_DISPLAY_SOURCE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_BOM_DISPLAY_SOURCE" ("SOURCE", "LAYOUT_ID") AS 
  select RVitprsource.SOURCE,LAYOUT_ID from RVitbomlysource, RVitprsource
   where RVitbomlysource.source(+)=RVitprsource.source
 ;
--------------------------------------------------------
--  DDL for View RVI_BOM_HEADER_LAYOUT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_BOM_HEADER_LAYOUT" ("LAYOUT_TYPE", "LAYOUT_ID", "DESCRIPTION", "INTL", "LAST_MODIFIED_BY", "LAST_MODIFIED_ON", "CREATED_BY", "CREATED_ON", "STATUS", "REVISION") AS 
  SELECT RVITBOMLY.LAYOUT_TYPE,
		 RVITBOMLY.LAYOUT_ID,
         RVITBOMLY.DESCRIPTION,
		 RVITBOMLY.INTL,
         RVITBOMLY.LAST_MODIFIED_BY,
		 RVITBOMLY.LAST_MODIFIED_ON,
         RVITBOMLY.CREATED_BY,
		 RVITBOMLY.CREATED_ON,
         RV_FIXED_STATES.STATUS,
		 RVITBOMLY.REVISION
    FROM RVITBOMLY,
         RV_FIXED_STATES
   WHERE RVITBOMLY.layout_type = 3
     AND RVITBOMLY.STATUS = OBJECTSREFTEXTS(+)
 ;
--------------------------------------------------------
--  DDL for View RVI_BOM_ITEM_LAYOUT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_BOM_ITEM_LAYOUT" ("LAYOUT_TYPE", "LAYOUT_ID", "DESCRIPTION", "INTL", "LAST_MODIFIED_BY", "LAST_MODIFIED_ON", "CREATED_BY", "CREATED_ON", "STATUS", "REVISION", "DATE_IMPORTED") AS 
  SELECT   RVITBOMLY.LAYOUT_TYPE,
		 RVITBOMLY.LAYOUT_ID,
         RVITBOMLY.DESCRIPTION,
		 RVITBOMLY.INTL,
         RVITBOMLY.LAST_MODIFIED_BY,
		 RVITBOMLY.LAST_MODIFIED_ON,
         RVITBOMLY.CREATED_BY,
		 RVITBOMLY.CREATED_ON,
         RV_FIXED_STATES.STATUS,
		 RVITBOMLY.REVISION,
		 RVITBOMLY.DATE_IMPORTED
    FROM RVITBOMLY,
         RV_FIXED_STATES
   WHERE layout_type IN (1, 2)
     AND RVITBOMLY.STATUS = OBJECTSREFTEXTS(+)
 ;
--------------------------------------------------------
--  DDL for View RVI_BUBBLE_ATTRIBUTE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_BUBBLE_ATTRIBUTE" ("ATTRIBUTE", "REVISION", "LANG_ID", "BUBBLE", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY") AS 
  SELECT att.ATTRIBUTE, att.revision, att.lang_id, att.bubble,
       att.last_modified_on, att.last_modified_by
  FROM attribute_b att
 ;
--------------------------------------------------------
--  DDL for View RVI_BUBBLE_CHARACTERISTIC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_BUBBLE_CHARACTERISTIC" ("CHARACTERISTIC_ID", "REVISION", "LANG_ID", "BUBBLE", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY") AS 
  SELECT characteristic_b.characteristic_id,
	   characteristic_b.revision,
       characteristic_b.lang_id,
	   characteristic_b.bubble,
       characteristic_b.last_modified_on,
	   characteristic_b.last_modified_by
  FROM characteristic_b
 ;
--------------------------------------------------------
--  DDL for View RVI_BUBBLE_HEADER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_BUBBLE_HEADER" ("HEADER_ID", "REVISION", "LANG_ID", "BUBBLE", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY") AS 
  SELECT header_b.header_id, header_b.revision, header_b.lang_id,
       header_b.bubble, header_b.last_modified_on, header_b.last_modified_by
  FROM header_b
 ;
--------------------------------------------------------
--  DDL for View RVI_BUBBLE_MATERIAL_CLASS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_BUBBLE_MATERIAL_CLASS" ("IDENTIFIER", "LANG_ID", "BUBBLE", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY") AS 
  SELECT material_class_b.IDENTIFIER, material_class_b.lang_id,
       material_class_b.bubble, material_class_b.last_modified_on,
       material_class_b.last_modified_by
  FROM material_class_b
 ;
--------------------------------------------------------
--  DDL for View RVI_BUBBLE_PROPERTY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_BUBBLE_PROPERTY" ("PROPERTY", "REVISION", "LANG_ID", "BUBBLE", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY") AS 
  SELECT pro.property, pro.revision, pro.lang_id, pro.bubble,
       pro.last_modified_on, pro.last_modified_by
  FROM property_b pro
 ;
--------------------------------------------------------
--  DDL for View RVI_BUBBLE_PROPERTY_GROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_BUBBLE_PROPERTY_GROUP" ("PROPERTY_GROUP", "REVISION", "LANG_ID", "BUBBLE", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY") AS 
  SELECT property_group_b.property_group, property_group_b.revision,
       property_group_b.lang_id, property_group_b.bubble,
       property_group_b.last_modified_on, property_group_b.last_modified_by
  FROM property_group_b
 ;
--------------------------------------------------------
--  DDL for View RVI_BUBBLE_SECTION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_BUBBLE_SECTION" ("SECTION_ID", "LANG_ID", "REVISION", "BUBBLE", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY") AS 
  SELECT section_b.section_id, section_b.lang_id, section_b.revision,
       section_b.bubble, section_b.last_modified_on,
       section_b.last_modified_by
  FROM section_b
 ;
--------------------------------------------------------
--  DDL for View RVI_BUBBLE_SUB_SECTION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_BUBBLE_SUB_SECTION" ("SUB_SECTION_ID", "REVISION", "LANG_ID", "BUBBLE", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY") AS 
  SELECT sub_section_b.sub_section_id, sub_section_b.revision,
       sub_section_b.lang_id, sub_section_b.bubble,
       sub_section_b.last_modified_on, sub_section_b.last_modified_by
  FROM sub_section_b
 ;
--------------------------------------------------------
--  DDL for View RVI_BUBBLE_TEXT_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_BUBBLE_TEXT_TYPE" ("TEXT_TYPE", "REVISION", "LANG_ID", "BUBBLE", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY") AS 
  SELECT text_type_b.text_type, text_type_b.revision, text_type_b.lang_id,
       text_type_b.bubble, text_type_b.last_modified_on,
       text_type_b.last_modified_by
  FROM text_type_b
 ;
--------------------------------------------------------
--  DDL for View RVI_BUBBLE_UOM
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_BUBBLE_UOM" ("UOM_ID", "REVISION", "LANG_ID", "BUBBLE", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY") AS 
  SELECT uom_b.uom_id, uom_b.revision, uom_b.lang_id, uom_b.bubble,
       uom_b.last_modified_on, uom_b.last_modified_by
  FROM uom_b
 ;
--------------------------------------------------------
--  DDL for View RVI_CHARACTERISTIC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_CHARACTERISTIC" ("CHARACTERISTIC_ID", "DESCRIPTION", "INTL", "STATUS", "LANG_ID", "REVISION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED") AS 
  SELECT
  cha.characteristic_id,
  cha_h.description,
  cha.intl,
  cha.status,
  cha_h.lang_id,
  cha_h.revision,
  cha_h.last_modified_on,
  cha_h.last_modified_by,
  cha_h.max_rev,
  cha_h.date_imported
FROM
  RVcharacteristic cha,
  RVcharacteristic_h cha_h
WHERE
  cha.characteristic_id = cha_h.characteristic_id(+)
  and cha_h.max_rev=1
 ;
--------------------------------------------------------
--  DDL for View RVI_CHARACTERISTIC_ASSOCIATION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_CHARACTERISTIC_ASSOCIATION" ("ASSOCIATION_ID", "CHARACTERISTIC_ID", "INTL") AS 
  SELECT
  association as association_id,
  characteristic as characteristic_id,
  INTL
FROM
  characteristic_association
 ;
--------------------------------------------------------
--  DDL for View RVI_CHEMICAL_REGISTRATION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_CHEMICAL_REGISTRATION" ("PID", "CID", "INTL", "STATUS", "CID_TYPE", "MAX_PCT", "ING_TYPE", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED", "ES_SEQ_NO") AS 
  SELECT RVitingcfg_h.pid,
          RVitingcfg_h.cid,
          RVitingcfg.intl,
          RVitingcfg.status,
          RVitingcfg.cid_type,
          RVitingcfg.max_pct,
          RVitingcfg.ing_type,
          RVitingcfg_h.revision,
          RVitingcfg_h.lang_id,
          RVitingcfg_h.description,
          RVitingcfg_h.last_modified_on,
          RVitingcfg_h.last_modified_by,
          RVitingcfg_h.max_rev,
          RVitingcfg_h.date_imported,
          RVitingcfg_h.es_seq_no
     FROM RVitingcfg_h, RVitingcfg
    WHERE RVitingcfg.cid = RVitingcfg_h.cid(+)
      AND RVitingcfg_h.pid = 0
      AND RVitingcfg_h.max_rev = 1
 ;
--------------------------------------------------------
--  DDL for View RVI_CL_ATTRIBUTES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_CL_ATTRIBUTES" ("LABEL", "CODE", "DESCR") AS 
  SELECT a.label, a.code, b.descr
  FROM itclat a, itclclf b
 WHERE a.attribute_id = b.ID
UNION
SELECT c.label, c.code, f_get_classification_path (e.cid)
  FROM RVitclat c, RVitcld d, RVitcltv e
 WHERE c.attribute_id = d.ID AND d.node = e.TYPE
 ;
--------------------------------------------------------
--  DDL for View RVI_CL_TREETYPES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_CL_TREETYPES" ("TREETYPE", "NODE", "ID") AS 
  SELECT DISTINCT itcld.spec_group AS treetype, itcld.node, itcld.ID
              FROM RVitcld itcld, RVclass3 class3
             WHERE itcld.spec_group = class3.TYPE
 ;
--------------------------------------------------------
--  DDL for View RVI_CONDITION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_CONDITION" ("CONDITION_ID", "INTL", "STATUS", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED") AS 
  SELECT
  con.condition AS condition_id,
  con.intl,
  con.status,
  con_h.revision,
  con_h.lang_id,
  con_h.description,
  con_h.last_modified_on,
  con_h.last_modified_by,
  con_h.max_rev,
  con_h.date_imported
FROM
  RVcondition con,
  RVcondition_h con_h
WHERE
  con.condition = con_h.condition(+) and con_h.max_rev=1
 ;
--------------------------------------------------------
--  DDL for View RVI_DB_MSG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_DB_MSG" ("MSG_ID", "DESCRIPTION", "MESSAGE", "MSG_LEVEL", "MSG_COMMENT", "CULTURE_ID") AS 
  SELECT   ITMESSAGE.MSG_ID,
         ITMESSAGE.DESCRIPTION,
         ITMESSAGE.MESSAGE,
         ITMESSAGE.MSG_LEVEL,
         ITMESSAGE.MSG_COMMENT,
         ITMESSAGE.CULTURE_ID
    FROM ITMESSAGE
 ;
--------------------------------------------------------
--  DDL for View RVI_DB_PROFILES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_DB_PROFILES" ("OWNER", "DESCRIPTION", "DB_TYPE", "PARENTOWNER", "ALLOW_GLOSSARY", "ALLOW_FRAME_CHANGES", "ALLOW_FRAME_EXPORT", "REGION", "DEVISION", "LIVE_DB", "COUNTRY") AS 
  SELECT a.owner,
       a.description,
       a.db_type,
       b.DESCRIPTION as ParentOwner,
       a.allow_glossary,
       a.allow_frame_changes,
       a.allow_frame_export,
       a.region,
       a.devision,
       a.live_db,
       a.country
  FROM RVitdbprofile a, RVitdbprofile b
 WHERE a.parent_owner = b.owner(+)
 ;
--------------------------------------------------------
--  DDL for View RVI_DELETION_LOG_FRM
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_DELETION_LOG_FRM" ("FRAME_NO", "REVISION", "OWNER", "DELETION_DATE", "USER_ID", "FULL_NAME", "STATUS") AS 
  SELECT itfrmdel.frame_no,
       itfrmdel.revision,
       itfrmdel.owner,
       itfrmdel.deletion_date,
       itfrmdel.user_id,
       itfrmdel.forename || ' ' || itfrmdel.last_name full_name,
       itfrmdel.status
  FROM itfrmdel
 ;
--------------------------------------------------------
--  DDL for View RVI_DUAL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_DUAL" ("DUMMY") AS 
  select "DUMMY" from DUAL
 ;
--------------------------------------------------------
--  DDL for View RVI_ERP_CONF_BOM_STS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_ERP_CONF_BOM_STS" ("RANGEID", "STATUS", "BS", "BU") AS 
  SELECT "ITSAPPLRANGE_SS"."RANGEID",
       "ITSAPPLRANGE_SS"."STATUS",
       "ITSAPPLRANGE_SS"."BS",
       "ITSAPPLRANGE_SS"."BU"
  FROM "ITSAPPLRANGE_SS"
 ;
--------------------------------------------------------
--  DDL for View RVI_ERROR_LOG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_ERROR_LOG" ("SOURCE", "APPLIC", "USER_ID", "LOGDATE", "ERROR_MSG") AS 
  SELECT   "ITERROR"."SOURCE",
         "ITERROR"."APPLIC",
         "ITERROR"."USER_ID",
         "ITERROR"."LOGDATE",
         "ITERROR"."ERROR_MSG"
    FROM "ITERROR"
 ;
--------------------------------------------------------
--  DDL for View RVI_ES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_ES" ("ES_SEQ_NO", "TYPE", "USER_ID", "FORENAME", "LAST_NAME", "SIGN_FOR_ID", "SIGN_FOR", "SIGN_WHAT_ID", "SIGN_WHAT", "SUCCESS", "SUCCESS_DESCR") AS 
  SELECT es_seq_no,
       TYPE,
       user_id,
       forename,
       last_name,
       sign_for_id,
       sign_for,
       sign_what_id,
       sign_what,
       success,
       success_descr
  FROM iteshs
 ;
--------------------------------------------------------
--  DDL for View RVI_ES_LOG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_ES_LOG" ("ES_SEQ_NO", "TYPE", "USER_ID", "FORENAME", "LAST_NAME", "TIMESTAMP", "SIGN_FOR", "SIGN_WHAT", "SUCCESS_DESCR") AS 
  SELECT   iteshs.es_seq_no,
         iteshs.TYPE,
         iteshs.user_id,
         iteshs.forename,
         iteshs.last_name,
         iteshs.TIMESTAMP,
         iteshs.sign_for,
         iteshs.sign_what,
         iteshs.success_descr
    FROM iteshs
ORDER BY iteshs.es_seq_no DESC
 ;
--------------------------------------------------------
--  DDL for View RVI_FCM_FRAMES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_FCM_FRAMES" ("FT_GROUP_ID", "FT_FRAME_ID", "OLD_FRAME_NO", "OLD_FRAME_REV_FROM", "OLD_FRAME_REV_TO", "OLD_FRAME_OWNER", "OLD_FRAME_OWNER_ID", "NEW_FRAME_NO", "NEW_FRAME_OWNER", "NEW_FRAME_OWNER_ID", "NEW_FRAME_REV_FROM", "NEW_FRAME_REV_TO") AS 
  SELECT "RVFT_FRAMES"."FT_GROUP_ID",
       "RVFT_FRAMES"."FT_FRAME_ID",
       "RVFT_FRAMES"."OLD_FRAME_NO",
       "RVFT_FRAMES"."OLD_FRAME_REV_FROM",
       "RVFT_FRAMES"."OLD_FRAME_REV_TO",
       old_owner.description AS old_frame_owner,
	   RVft_frames.OLD_FRAME_OWNER as old_frame_owner_id,
       "RVFT_FRAMES"."NEW_FRAME_NO",
       new_owner.description AS new_frame_owner,
	   RVft_frames.NEW_FRAME_OWNER as new_frame_owner_id,
       "RVFT_FRAMES"."NEW_FRAME_REV_FROM",
       "RVFT_FRAMES"."NEW_FRAME_REV_TO"
  FROM "RVFT_FRAMES", RVitdbprofile old_owner, RVitdbprofile new_owner
 WHERE old_owner.owner = RVft_frames.old_frame_owner
   AND new_owner.owner = RVft_frames.new_frame_owner
 ;
--------------------------------------------------------
--  DDL for View RVI_FCM_RULES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_FCM_RULES" ("FT_GROUP_ID", "PROP_G_ID", "FT_ID", "OLD_SECTION", "OLD_SUB_SECTION", "OLD_PROP_GROUP", "OLD_PROPERTY", "OLD_ATTRIBUTE", "OLD_COLUMN", "NEW_SECTION", "NEW_SUB_SECTION", "NEW_PROP_GROUP", "NEW_PROPERTY", "NEW_ATTRIBUTE", "NEW_COLUMN", "OBJECT_TYPE") AS 
  SELECT "RVFT_BASE_RULES"."FT_GROUP_ID",
RVft_base_rules.OLD_PROP_GROUP as prop_g_id,
         "RVFT_BASE_RULES"."FT_ID",
		 old_section.description as old_section ,
         old_ss.description as old_sub_section,
		 DECODE(RVFT_BASE_RULES.OBJECT_TYPE,5,old_text.DESCRIPTION,old_pg.description) as OLD_PROP_GROUP,
         old_p.description as OLD_PROPERTY,
		 old_attr.description as OLD_ATTRIBUTE,
         old_col.DISPLAYFORMATTYPE as OLD_COLUMN,
		 new_section.description as new_section,
		 new_ss.description as new_sub_section,
		 DECODE(RVFT_BASE_RULES.OBJECT_TYPE,5,new_text.DESCRIPTION,new_pg.description) as NEW_PROP_GROUP,
		 new_p.description as new_property,
		 new_attr.description as new_attribute,
         new_col.DISPLAYFORMATTYPE as NEW_COLUMN,
         "RVFT_BASE_RULES"."OBJECT_TYPE"
    FROM "RVFT_BASE_RULES",RVsection old_section, RVsection new_section, RVproperty_group old_pg, RVproperty_group new_pg,
	     RVproperty old_p, RVproperty new_p, RVsub_section old_ss, RVsub_section new_ss,
		 RVattribute new_attr, RVattribute old_attr, RV_DISPLAYFORMAT_TYPE new_col, RV_DISPLAYFORMAT_TYPE old_col,
		 RVtext_type old_text, RVtext_type new_text
   WHERE RVft_base_rules.OLD_SECTION = old_section.section_id(+) and RVft_base_rules.new_section = new_section.section_id(+)
   AND	RVft_base_rules.old_prop_group = old_pg.property_group(+) and RVft_base_rules.new_prop_group = new_pg.property_group(+)
   AND   RVft_base_rules.old_property = old_p.PROPERTY(+) and RVft_base_rules.new_property = new_p.property(+)
   and   RVft_base_rules.old_sub_section=old_ss.SUB_SECTION_ID(+) and RVft_base_rules.NEW_SUB_SECTION = new_ss.sub_section_id(+)
   and   RVft_base_rules.old_attribute = old_attr.attribute(+) and RVft_base_rules.new_attribute = new_attr.attribute(+)
   and   RVft_base_rules.old_column = old_col.ID(+) and RVft_base_rules.new_column = new_col.ID(+)
   and   RVft_base_rules.old_prop_group = old_text.text_type(+) and RVft_base_rules.new_prop_group = new_text.text_type(+)
 ;
--------------------------------------------------------
--  DDL for View RVI_FCM_SQLRULE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_FCM_SQLRULE" ("FT_GROUP_ID", "FT_ID", "SQL_TEXT") AS 
  select ft_group_id,ft_id,sql_text from ft_sql
 ;
--------------------------------------------------------
--  DDL for View RVI_FORMAT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_FORMAT" ("FORMAT_ID", "DESCRIPTION", "INTL", "TYPE") AS 
  SELECT
  format.format_id,
  format.description,
  format.intl,
  RV_DATA_TYPE.TYPE
FROM
  RVformat format, RV_DATA_TYPE
where format.type=RV_DATA_TYPE.FORMAT_ID
 ;
--------------------------------------------------------
--  DDL for View RVI_GLOSSARY_STATUS_CHANGE_LOG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_GLOSSARY_STATUS_CHANGE_LOG" ("DESCRIPTION", "EN_TP", "STATUS_CHANGE_DATE", "USER_ID", "STATUS") AS 
  SELECT "RVPROPERTY"."DESCRIPTION",
       "RVITENSSLOG"."EN_TP",
       "RVITENSSLOG"."STATUS_CHANGE_DATE",
       "RVITENSSLOG"."USER_ID",
       "RVITENSSLOG"."STATUS"
  FROM "RVITENSSLOG", "RVPROPERTY"
 WHERE TO_CHAR ("RVITENSSLOG"."EN_ID") = "RVPROPERTY"."PROPERTY"
   AND "RVITENSSLOG"."EN_TP" = 'sp'
UNION
SELECT "RVUOM"."DESCRIPTION",
       "RVITENSSLOG"."EN_TP",
       "RVITENSSLOG"."STATUS_CHANGE_DATE",
       "RVITENSSLOG"."USER_ID",
       "RVITENSSLOG"."STATUS"
  FROM "RVITENSSLOG", "RVUOM"
 WHERE TO_CHAR ("RVITENSSLOG"."EN_ID") = "RVUOM"."UOM_ID"
   AND "RVITENSSLOG"."EN_TP" = 'um'
UNION
SELECT "RVASSOCIATION"."DESCRIPTION",
       "RVITENSSLOG"."EN_TP",
       "RVITENSSLOG"."STATUS_CHANGE_DATE",
       "RVITENSSLOG"."USER_ID",
       "RVITENSSLOG"."STATUS"
  FROM "RVITENSSLOG", "RVASSOCIATION"
 WHERE TO_CHAR ("RVITENSSLOG"."EN_ID") = "RVASSOCIATION"."ASSOCIATION"
   AND "RVITENSSLOG"."EN_TP" = 'as'
UNION
SELECT "RVATTRIBUTE"."DESCRIPTION",
       "RVITENSSLOG"."EN_TP",
       "RVITENSSLOG"."STATUS_CHANGE_DATE",
       "RVITENSSLOG"."USER_ID",
       "RVITENSSLOG"."STATUS"
  FROM "RVITENSSLOG", "RVATTRIBUTE"
 WHERE TO_CHAR ("RVITENSSLOG"."EN_ID") = "RVATTRIBUTE"."ATTRIBUTE"
   AND "RVITENSSLOG"."EN_TP" = 'at'
UNION
SELECT "RVCHARACTERISTIC"."DESCRIPTION",
       "RVITENSSLOG"."EN_TP",
       "RVITENSSLOG"."STATUS_CHANGE_DATE",
       "RVITENSSLOG"."USER_ID",
       "RVITENSSLOG"."STATUS"
  FROM "RVITENSSLOG", "RVCHARACTERISTIC"
 WHERE TO_CHAR ("RVITENSSLOG"."EN_ID") = "RVCHARACTERISTIC"."CHARACTERISTIC_ID"
   AND "RVITENSSLOG"."EN_TP" = 'ch'
UNION
SELECT "RVHEADER"."DESCRIPTION",
       "RVITENSSLOG"."EN_TP",
       "RVITENSSLOG"."STATUS_CHANGE_DATE",
       "RVITENSSLOG"."USER_ID",
       "RVITENSSLOG"."STATUS"
  FROM "RVITENSSLOG", "RVHEADER"
 WHERE TO_CHAR ("RVITENSSLOG"."EN_ID") = "RVHEADER"."HEADER_ID"
   AND "RVITENSSLOG"."EN_TP" = 'hd'
UNION
SELECT "RVITING"."DESCRIPTION",
       "RVITENSSLOG"."EN_TP",
       "RVITENSSLOG"."STATUS_CHANGE_DATE",
       "RVITENSSLOG"."USER_ID",
       "RVITENSSLOG"."STATUS"
  FROM "RVITENSSLOG", "RVITING"
 WHERE TO_CHAR ("RVITENSSLOG"."EN_ID") = "RVITING"."INGREDIENT"
   AND "RVITENSSLOG"."EN_TP" = 'in'
UNION
SELECT "RVITKWCH"."DESCRIPTION",
       "RVITENSSLOG"."EN_TP",
       "RVITENSSLOG"."STATUS_CHANGE_DATE",
       "RVITENSSLOG"."USER_ID",
       "RVITENSSLOG"."STATUS"
  FROM "RVITENSSLOG", "RVITKWCH"
 WHERE TO_CHAR ("RVITENSSLOG"."EN_ID") = "RVITKWCH"."CH_ID"
   AND "RVITENSSLOG"."EN_TP" = 'kc'
UNION
SELECT "RVITKW"."DESCRIPTION",
       "RVITENSSLOG"."EN_TP",
       "RVITENSSLOG"."STATUS_CHANGE_DATE",
       "RVITENSSLOG"."USER_ID",
       "RVITENSSLOG"."STATUS"
  FROM "RVITENSSLOG", "RVITKW"
 WHERE TO_CHAR ("RVITENSSLOG"."EN_ID") = "RVITKW"."KW_ID"
   AND "RVITENSSLOG"."EN_TP" = 'kw'
UNION
SELECT "RVPROPERTY_GROUP"."DESCRIPTION",
       "RVITENSSLOG"."EN_TP",
       "RVITENSSLOG"."STATUS_CHANGE_DATE",
       "RVITENSSLOG"."USER_ID",
       "RVITENSSLOG"."STATUS"
  FROM "RVITENSSLOG", "RVPROPERTY_GROUP"
 WHERE TO_CHAR ("RVITENSSLOG"."EN_ID") = "RVPROPERTY_GROUP"."PROPERTY_GROUP"
   AND "RVITENSSLOG"."EN_TP" = 'pg'
UNION
SELECT "RVSUB_SECTION"."DESCRIPTION",
       "RVITENSSLOG"."EN_TP",
       "RVITENSSLOG"."STATUS_CHANGE_DATE",
       "RVITENSSLOG"."USER_ID",
       "RVITENSSLOG"."STATUS"
  FROM "RVITENSSLOG", "RVSUB_SECTION"
 WHERE TO_CHAR ("RVITENSSLOG"."EN_ID") = "RVSUB_SECTION"."SUB_SECTION_ID"
   AND "RVITENSSLOG"."EN_TP" = 'sb'
UNION
SELECT "RVSECTION"."DESCRIPTION",
       "RVITENSSLOG"."EN_TP",
       "RVITENSSLOG"."STATUS_CHANGE_DATE",
       "RVITENSSLOG"."USER_ID",
       "RVITENSSLOG"."STATUS"
  FROM "RVITENSSLOG", "RVSECTION"
 WHERE TO_CHAR ("RVITENSSLOG"."EN_ID") = "RVSECTION"."SECTION_ID"
   AND "RVITENSSLOG"."EN_TP" = 'sc'
UNION
SELECT "RVTEXT_TYPE"."DESCRIPTION",
       "RVITENSSLOG"."EN_TP",
       "RVITENSSLOG"."STATUS_CHANGE_DATE",
       "RVITENSSLOG"."USER_ID",
       "RVITENSSLOG"."STATUS"
  FROM "RVITENSSLOG", "RVTEXT_TYPE"
 WHERE TO_CHAR ("RVITENSSLOG"."EN_ID") = "RVTEXT_TYPE"."TEXT_TYPE"
   AND "RVITENSSLOG"."EN_TP" = 'tt'
UNION
SELECT "RVTEST_METHOD"."DESCRIPTION",
       "RVITENSSLOG"."EN_TP",
       "RVITENSSLOG"."STATUS_CHANGE_DATE",
       "RVITENSSLOG"."USER_ID",
       "RVITENSSLOG"."STATUS"
  FROM "RVITENSSLOG", "RVTEST_METHOD"
 WHERE TO_CHAR ("RVITENSSLOG"."EN_ID") = "RVTEST_METHOD"."TEST_METHOD"
   AND "RVITENSSLOG"."EN_TP" = 'tm'
 ;
--------------------------------------------------------
--  DDL for View RVI_GROUP_PROPERTY_LIMIT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_GROUP_PROPERTY_LIMIT" ("PROPERTY_GROUP", "PROPERTY", "LOWER_REJECT", "UPPER_REJECT", "INTL", "UOM_ID", "UOM") AS 
  SELECT RVgroup_property_limit.property_group,
          RVgroup_property_limit.property,
          RVgroup_property_limit.lower_reject,
          RVgroup_property_limit.upper_reject,
          RVgroup_property_limit.intl,
		  RVgroup_property_limit.uom_id,
          RVuom.description AS uom
     FROM RVgroup_property_limit, RVuom
    WHERE RVgroup_property_limit.uom_id = RVuom.uom_id
 ;
--------------------------------------------------------
--  DDL for View RVI_HEADER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_HEADER" ("INTL", "STATUS", "HEADER_ID", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED", "ES_SEQ_NO") AS 
  SELECT
  header.intl,
  header.status,
  header_h.header_id,
  header_h.revision,
  header_h.lang_id,
  header_h.description,
  header_h.last_modified_on,
  header_h.last_modified_by,
  header_h.max_rev,
  header_h.date_imported,
  header_h.es_seq_no
FROM
  RVheader header,
  RVheader_h header_h
WHERE
  header.header_id = header_h.header_id(+)
  and header_h.max_rev=1
 ;
--------------------------------------------------------
--  DDL for View RVI_IMP_SPEC_OBJ_REFTXT_FRM
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_IMP_SPEC_OBJ_REFTXT_FRM" ("TYPE", "PART_NO", "REVISION", "OWNER", "TIMESTAMP") AS 
  select "TYPE","PART_NO","REVISION","OWNER","TIMESTAMP" from itimp_log
 ;
--------------------------------------------------------
--  DDL for View RVI_INGREDIENT_CTFA
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_INGREDIENT_CTFA" ("PID", "CID", "INTL", "STATUS", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED", "ES_SEQ_NO") AS 
  SELECT itingcfg_h.pid, itingcfg_h.cid, itingcfg.intl, itingcfg.status,
          itingcfg_h.revision, itingcfg_h.lang_id, itingcfg_h.description,
          itingcfg_h.last_modified_on, itingcfg_h.last_modified_by,
          itingcfg_h.max_rev, itingcfg_h.date_imported, itingcfg_h.es_seq_no
     FROM RVitingcfg_h itingcfg_h, RVitingcfg itingcfg
    WHERE itingcfg.cid = itingcfg_h.cid(+) AND itingcfg_h.pid = 3 and itingcfg_h.max_rev=1
 ;
--------------------------------------------------------
--  DDL for View RVI_INGREDIENT_FUNCTIONS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_INGREDIENT_FUNCTIONS" ("PID", "CID", "INTL", "STATUS", "CID_TYPE", "MAX_PCT", "ING_TYPE", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED", "ES_SEQ_NO") AS 
  SELECT itingcfg_h.pid, itingcfg_h.cid, itingcfg.intl, itingcfg.status,
          itingcfg.cid_type, itingcfg.max_pct, itingcfg.ing_type,
          itingcfg_h.revision, itingcfg_h.lang_id, itingcfg_h.description,
          itingcfg_h.last_modified_on, itingcfg_h.last_modified_by,
          itingcfg_h.max_rev, itingcfg_h.date_imported, itingcfg_h.es_seq_no
     FROM RVitingcfg_h itingcfg_h, RVitingcfg itingcfg
    WHERE itingcfg.cid = itingcfg_h.cid(+) AND itingcfg_h.pid = 2 and itingcfg_h.max_rev=1
 ;
--------------------------------------------------------
--  DDL for View RVI_INGREDIENT_GROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_INGREDIENT_GROUP" ("PID", "CID", "INTL", "STATUS", "CID_TYPE", "MAX_PCT", "ING_TYPE", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED", "ES_SEQ_NO") AS 
  SELECT itingcfg_h.pid, itingcfg_h.cid, itingcfg.intl, itingcfg.status,
          itingcfg.cid_type, itingcfg.max_pct, itingcfg.ing_type,
          itingcfg_h.revision, itingcfg_h.lang_id, itingcfg_h.description,
          itingcfg_h.last_modified_on, itingcfg_h.last_modified_by,
          itingcfg_h.max_rev, itingcfg_h.date_imported, itingcfg_h.es_seq_no
     FROM RVitingcfg_h itingcfg_h, RVitingcfg itingcfg
    WHERE itingcfg.cid = itingcfg_h.cid(+) AND itingcfg_h.pid = 1 and itingcfg_h.max_rev=1
 ;
--------------------------------------------------------
--  DDL for View RVI_INGREDIENT_LINKS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_INGREDIENT_LINKS" ("INGREDIENT", "PID", "CID", "INTL", "PREF") AS 
  select "INGREDIENT","PID","CID","INTL","PREF" from itingd
 ;
--------------------------------------------------------
--  DDL for View RVI_JOB_LOG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_JOB_LOG" ("JOB", "START_DATE", "END_DATE") AS 
  SELECT   "ITJOB"."JOB",
         "ITJOB"."START_DATE",
         "ITJOB"."END_DATE"
    FROM "ITJOB"
 ;
--------------------------------------------------------
--  DDL for View RVI_KEYWORD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_KEYWORD" ("KW_ID", "INTL", "STATUS", "REVISION", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "KW_TYPE", "KW_USAGE", "DATE_IMPORTED") AS 
  SELECT itkw.kw_id,
       itkw.intl,
       itkw.status,
       itkw_h.revision,
       itkw_h.description,
       itkw_h.last_modified_on,
       itkw_h.last_modified_by,
       itkw_h.kw_type,
       itkw_h.kw_usage,
       itkw_h.date_imported
  FROM RVitkw itkw, RVitkw_h itkw_h
 WHERE ((itkw.kw_id = itkw_h.kw_id(+)))
 ;
--------------------------------------------------------
--  DDL for View RVI_KEYWORD_CHAR_LINKS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_KEYWORD_CHAR_LINKS" ("KW_ID", "CH_ID", "INTL") AS 
  select KW_ID,CH_ID,INTL  from itkwas
 ;
--------------------------------------------------------
--  DDL for View RVI_KEYWORD_CHARACTERISTIC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_KEYWORD_CHARACTERISTIC" ("CH_ID", "INTL", "STATUS", "REVISION", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "DATE_IMPORTED") AS 
  SELECT itkwch.ch_id,
       itkwch.intl,
       itkwch.status,
       itkwch_h.revision,
       itkwch_h.description,
       itkwch_h.last_modified_on,
       itkwch_h.last_modified_by,
       itkwch_h.date_imported
  FROM RVitkwch itkwch, RVitkwch_h itkwch_h
 WHERE ((itkwch.ch_id = itkwch_h.ch_id(+)))
 ;
--------------------------------------------------------
--  DDL for View RVI_LAYOUT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_LAYOUT" ("LAYOUT_ID", "DESCRIPTION", "INTL", "STATUS", "CREATED_BY", "CREATED_ON", "LAST_MODIFIED_BY", "LAST_MODIFIED_ON", "REVISION", "DATE_IMPORTED") AS 
  SELECT
  layout.layout_id,
  layout.description,
  layout.intl,
  layout.status,
  layout.created_by,
  layout.created_on,
  layout.last_modified_by,
  layout.last_modified_on,
  layout.revision,
  layout.date_imported
FROM
  layout layout
 ;
--------------------------------------------------------
--  DDL for View RVI_LOCATION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_LOCATION" ("LOCATION", "DESCRIPTION", "PLANT") AS 
  SELECT "LOCATION"."LOCATION",
         "LOCATION"."DESCRIPTION",
         "LOCATION"."PLANT"
    FROM "LOCATION"
 ;
--------------------------------------------------------
--  DDL for View RVI_MANUFACTURER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_MANUFACTURER" ("MFC_ID", "DESCRIPTION", "STATUS", "INTL") AS 
  SELECT   "ITMFC"."MFC_ID",
         "ITMFC"."DESCRIPTION",
         "ITMFC"."STATUS",
         "ITMFC"."INTL"
    FROM "ITMFC"
 ;
--------------------------------------------------------
--  DDL for View RVI_MATERIAL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_MATERIAL" ("PID", "CID", "DESCR", "CCNT", "CODE", "TYPE", "LONG_DESCR") AS 
  select PID,CID,DESCR,CCNT,CODE,"TYPE",LONG_DESCR from itcltv
 ;
--------------------------------------------------------
--  DDL for View RVI_METRIC_NONMETRIC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_METRIC_NONMETRIC" ("UOM_ID", "UOM_ALT_ID", "CONV_FACTOR", "INTL", "STATUS", "CONV_FCT") AS 
  SELECT itumc.uom_id,
       itumc.uom_alt_id,
       itumc.conv_factor,
       itumc.intl,
       itumc.status,
       itumc.conv_fct
  FROM itumc
 ;
--------------------------------------------------------
--  DDL for View RVI_MRP_JOURNAL_LOG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_MRP_JOURNAL_LOG" ("PART_NO", "REVISION", "USER_ID", "TIMESTAMP", "OLD_PLANNED_EFFECTIVE_DATE", "OLD_PHASE_IN_TOLERANCE", "NEW_PLANNED_EFFECTIVE_DATE", "FORENAME", "LAST_NAME", "PLANT", "NEW_PHASE_IN_TOLERANCE") AS 
  SELECT   "JRNL_SPECIFICATION_HEADER"."PART_NO",
         "JRNL_SPECIFICATION_HEADER"."REVISION",
         "JRNL_SPECIFICATION_HEADER"."USER_ID",
         "JRNL_SPECIFICATION_HEADER"."TIMESTAMP",
         "JRNL_SPECIFICATION_HEADER"."OLD_PLANNED_EFFECTIVE_DATE",
         "JRNL_SPECIFICATION_HEADER"."OLD_PHASE_IN_TOLERANCE",
         "JRNL_SPECIFICATION_HEADER"."NEW_PLANNED_EFFECTIVE_DATE",
         "JRNL_SPECIFICATION_HEADER"."FORENAME",
         "JRNL_SPECIFICATION_HEADER"."LAST_NAME",
         "JRNL_SPECIFICATION_HEADER"."PLANT",
         "JRNL_SPECIFICATION_HEADER"."NEW_PHASE_IN_TOLERANCE"
    FROM "JRNL_SPECIFICATION_HEADER"
 ;
--------------------------------------------------------
--  DDL for View RVI_PART_DATA_IF_LOG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_PART_DATA_IF_LOG" ("OBJECT_TYPE", "ITEM", "WHAT", "NEW_VALUE", "TIMESTAMP", "OLD_VALUE") AS 
  SELECT   "ITIMP_CHANGES"."OBJECT_TYPE",
         "ITIMP_CHANGES"."ITEM",
         "ITIMP_CHANGES"."WHAT",
         "ITIMP_CHANGES"."NEW_VALUE",
         "ITIMP_CHANGES"."TIMESTAMP",
         "ITIMP_CHANGES"."OLD_VALUE"
    FROM "ITIMP_CHANGES"
 ;
--------------------------------------------------------
--  DDL for View RVI_PLANT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_PLANT" ("PLANT", "DESCRIPTION", "PLANT_SOURCE") AS 
  SELECT "PLANT"."PLANT",
       "PLANT"."DESCRIPTION",
       "PLANT"."PLANT_SOURCE"
  FROM "PLANT"
 ;
--------------------------------------------------------
--  DDL for View RVI_PREFERENCES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_PREFERENCES" ("SECTION", "PARAMETER", "PARAMETER_DATA", "ES", "ES_SEQ_NO") AS 
  SELECT INTERSPC_CFG.SECTION,
       INTERSPC_CFG.PARAMETER,
       INTERSPC_CFG.PARAMETER_DATA,
       INTERSPC_CFG.ES,
       INTERSPC_CFG.ES_SEQ_NO
  FROM RVINTERSPC_CFG INTERSPC_CFG
 WHERE (INTERSPC_CFG.VISIBLE = '1')
 ;
--------------------------------------------------------
--  DDL for View RVI_PROP_DISPLAY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_PROP_DISPLAY" ("PROPERTY_GROUP", "PROPERTY", "IS_DISPLAY", "INTL", "MANDATORY") AS 
  select property_group,
       property,
       0 as is_display,
       INTL,
       mandatory
  from rvproperty_group_list
UNION
select property_group,
       display_format,
       1,
       INTL,
       null
 from rvproperty_group_display
 ;
--------------------------------------------------------
--  DDL for View RVI_PROPERTY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_PROPERTY" ("PROPERTY_ID", "INTL", "STATUS", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED") AS 
  SELECT
  pro.property as property_id,
  property.intl,
  property.status,
  pro.revision,
  pro.lang_id,
  pro.description,
  pro.last_modified_on,
  pro.last_modified_by,
  pro.max_rev,
  pro.date_imported
FROM
  RVproperty property,
  RVproperty_h pro
WHERE
  property.property = pro.property(+) and pro.max_rev=1
 ;
--------------------------------------------------------
--  DDL for View RVI_PROPERTY_ASSOCIATION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_PROPERTY_ASSOCIATION" ("PROPERTY_ID", "ASSOCIATION_ID", "INTL") AS 
  SELECT
  property as property_id,
  association as association_id,
  intl
FROM
  property_association
 ;
--------------------------------------------------------
--  DDL for View RVI_PROPERTY_DISPLAY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_PROPERTY_DISPLAY" ("PROPERTY_ID", "DISPLAY_FORMAT", "INTL") AS 
  SELECT
  property as property_id,
  display_format,
  intl
FROM
  property_display
 ;
--------------------------------------------------------
--  DDL for View RVI_PROPERTY_GROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_PROPERTY_GROUP" ("PROPERTY_GROUP_ID", "DISPLAY_FORMAT", "INTL", "STATUS", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "PG_TYPE", "DATE_IMPORTED") AS 
  SELECT
  pro_h.property_group as property_group_id,
  pro.display_format,
  pro.intl,
  pro.status,
  pro_h.revision,
  pro_h.lang_id,
  pro_h.description,
  pro_h.last_modified_on,
  pro_h.last_modified_by,
  pro_h.max_rev,
  pro_h.pg_type,
  pro_h.date_imported
FROM
  RVproperty_group pro,
  RVproperty_group_h pro_h
WHERE
  pro.property_group = pro_h.property_group(+) and pro_h.max_rev=1
 ;
--------------------------------------------------------
--  DDL for View RVI_PROPERTY_GROUP_DISPLAY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_PROPERTY_GROUP_DISPLAY" ("PROPERTY_GROUP_ID", "DISPLAY_FORMAT", "INTL") AS 
  SELECT
  property_group as property_group_id,
  display_format,
  intl
FROM
  property_group_display
 ;
--------------------------------------------------------
--  DDL for View RVI_PROPERTY_GROUP_LIST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_PROPERTY_GROUP_LIST" ("PROPERTY_GROUP", "PROPERTY", "INTL", "MANDATORY") AS 
  SELECT
  property_group_list.property_group,
  property_group_list.property,
  property_group_list.intl,
  property_group_list.mandatory
FROM
  property_group_list
 ;
--------------------------------------------------------
--  DDL for View RVI_PROPERTY_LAYOUT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_PROPERTY_LAYOUT" ("LAYOUT_ID", "HEADER_ID", "DISPLAYFORMATTYPE", "INCLUDED", "START_POS", "LENGTH", "ALIGNMENT", "FORMAT_ID", "HEADER", "COLOR", "BOLD", "UNDERLINE", "INTL", "REVISION", "HEADER_REV", "DEF") AS 
  SELECT
  pro.layout_id,
  pro.header_id,
  rti.displayformattype,
  pro.included,
  pro.start_pos,
  pro.LENGTH,
  pro.alignment,
  pro.format_id,
  pro.header,
  pro.color,
  pro.bold,
  pro.underline,
  pro.intl,
  pro.revision,
  pro.header_rev,
  pro.def
FROM
  RVproperty_layout pro,
  RV_DISPLAYFORMAT_TYPE rti
WHERE
  ((pro.field_id(+) = rti.ID))
 ;
--------------------------------------------------------
--  DDL for View RVI_PROPERTY_TEST_METHOD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_PROPERTY_TEST_METHOD" ("PROPERTY_ID", "TEST_METHOD_ID", "INTL") AS 
  SELECT
  pro.property as property_id,
  pro.test_method as test_method_id,
  pro.intl
FROM
  property_test_method pro
 ;
--------------------------------------------------------
--  DDL for View RVI_REGISTRATION_DETAIL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_REGISTRATION_DETAIL" ("INGREDIENT", "REG_ID", "DESCRIPTION", "INTL") AS 
  select INGREDIENT,REG_ID,DESCRIPTION,INTL from itingreg
 ;
--------------------------------------------------------
--  DDL for View RVI_RULE_GROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_RULE_GROUP" ("FT_RULE_ID", "DESCRIPTION") AS 
  select ft_rule_id,description from ft_rule_group
 ;
--------------------------------------------------------
--  DDL for View RVI_SECTION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_SECTION" ("SECTION_ID", "INTL", "STATUS", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED", "ES_SEQ_NO") AS 
  SELECT section_h.section_id,
          section.intl,
          section.status,
          section_h.revision,
          section_h.lang_id,
          section_h.description,
          section_h.last_modified_on,
          section_h.last_modified_by,
          section_h.max_rev,
          section_h.date_imported,
          section_h.es_seq_no
     FROM RVsection section, RVsection_h section_h
    WHERE section.section_id = section_h.section_id(+)
      AND section_h.max_rev = 1
 ;
--------------------------------------------------------
--  DDL for View RVI_SPEC_PREF_ACCESS_GROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_SPEC_PREF_ACCESS_GROUP" ("PREFIX", "ACCESS_GROUP_ID", "ACCESS_GROUP") AS 
  select PREFIX,spec_prefix_access_group.ACCESS_GROUP as ACCESS_GROUP_ID,access_group.DESCRIPTION as ACCESS_GROUP
from RVspec_prefix_access_group spec_prefix_access_group, RVaccess_group access_group
where spec_prefix_access_group.ACCESS_GROUP = access_group.ACCESS_GROUP
 ;
--------------------------------------------------------
--  DDL for View RVI_SPEC_PREFIX
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_SPEC_PREFIX" ("OWNER", "PREFIX", "DESTINATION_ID", "DESTINATION", "WORKFLOW_GROUP_ID", "WORKFLOW_GROUP", "WORKFLOW_GROUP_SORT_DESC", "ACCESS_GROUP_ID", "ACCESS_GROUP", "ACCESS_GROUP_SORT_DESC", "IMPORT_ALLOWED", "LIVE_DB") AS 
  SELECT spec_prefix.owner,
       spec_prefix.prefix,
	   spec_prefix.destination as destination_id,
       itdbprofile.description as destination,
       spec_prefix.workflow_group_id,
	   workflow_group.DESCRIPTION as workflow_group,
	   workflow_group.SORT_DESC as workflow_group_sort_desc,
       spec_prefix.access_group as access_group_id,
	   access_group.DESCRIPTION as access_group,
	   access_group.sort_desc as access_group_sort_desc,
       spec_prefix.import_allowed,
	   itdbprofile.LIVE_DB
  FROM RVspec_prefix spec_prefix, RVitdbprofile itdbprofile, RVaccess_group access_group, RVworkflow_group workflow_group
  where spec_prefix.destination =  itdbprofile.owner AND
  		spec_prefix.workflow_group_id = workflow_group.WORKFLOW_GROUP_ID AND
		spec_prefix.access_group = access_group.ACCESS_GROUP
 ;
--------------------------------------------------------
--  DDL for View RVI_SPEC_PREFIX_DESCR
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_SPEC_PREFIX_DESCR" ("OWNER", "PREFIX", "DESCRIPTION", "PREFIX_TYPE") AS 
  SELECT "SPEC_PREFIX_DESCR"."OWNER",
       "SPEC_PREFIX_DESCR"."PREFIX",
       "SPEC_PREFIX_DESCR"."DESCRIPTION",
       "SPEC_PREFIX_DESCR"."PREFIX_TYPE"
  FROM "SPEC_PREFIX_DESCR"
 ;
--------------------------------------------------------
--  DDL for View RVI_SPEC_TYPE_GROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_SPEC_TYPE_GROUP" ("GROUP_DESCR", "STATUS", "INTL") AS 
  SELECT   ITSTGRP.GROUP_DESCR,
         ITSTGRP.STATUS,
         ITSTGRP.INTL
    FROM ITSTGRP
 ;
--------------------------------------------------------
--  DDL for View RVI_SPECIFICATION_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_SPECIFICATION_TYPE" ("INTL", "STATUS", "CLASS", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "TYPE", "SORT_DESC", "ES_SEQ_NO", "DATE_IMPORTED", "MAX_REV") AS 
  SELECT class3.intl,
       class3.status,
       class3_h.CLASS,
       class3_h.revision,
       class3_h.lang_id,
       class3_h.description,
       class3_h.last_modified_on,
       class3_h.last_modified_by,
       class3_h.TYPE,
       class3_h.sort_desc,
       class3_h.es_seq_no,
       class3_h.date_imported,
       class3_h.max_rev
  FROM RVclass3 class3, RVclass3_h class3_h
 WHERE ((class3.CLASS = class3_h.CLASS(+)))
 and class3_h.MAX_REV=1
 ;
--------------------------------------------------------
--  DDL for View RVI_STAGE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_STAGE" ("STAGE", "DESCRIPTION", "INTL", "STATUS") AS 
  SELECT   STAGE.STAGE,
         STAGE.DESCRIPTION,
		 STAGE.INTL,
         STAGE.STATUS
    FROM STAGE
 ;
--------------------------------------------------------
--  DDL for View RVI_STAGE_LIST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_STAGE_LIST" ("STAGE", "PROPERTY", "MANDATORY", "INTL", "UOM_ID", "ASSOCIATION") AS 
  select STAGE,PROPERTY,MANDATORY,INTL,UOM_ID,ASSOCIATION from stage_list
 ;
--------------------------------------------------------
--  DDL for View RVI_STATUS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_STATUS" ("SORT_DESC", "DESCRIPTION", "EMAIL_TITLE", "PHASE_IN_STATUS", "STATUS_TYPE", "STATUS", "PROMPT_FOR_REASON", "REASON_MANDATORY", "ES") AS 
  SELECT
  STATUS.SORT_DESC,
  STATUS.DESCRIPTION,
  STATUS.EMAIL_TITLE,
  STATUS.PHASE_IN_STATUS,
  STATUS.STATUS_TYPE,
  STATUS.STATUS,
  STATUS.PROMPT_FOR_REASON,
  STATUS.REASON_MANDATORY,
  STATUS.ES
FROM
  STATUS
 ;
--------------------------------------------------------
--  DDL for View RVI_SUB_SECTION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_SUB_SECTION" ("SUB_SECTION_ID", "INTL", "STATUS", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED", "ES_SEQ_NO") AS 
  SELECT sub_section_h.sub_section_id, sub_section.intl, sub_section.status,
       sub_section_h.revision, sub_section_h.lang_id,
       sub_section_h.description, sub_section_h.last_modified_on,
       sub_section_h.last_modified_by, sub_section_h.max_rev,
       sub_section_h.date_imported, sub_section_h.es_seq_no
  FROM RVsub_section_h sub_section_h, RVsub_section sub_section
 WHERE ((sub_section.sub_section_id = sub_section_h.sub_section_id(+)))
 ;
--------------------------------------------------------
--  DDL for View RVI_SYNONYM_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_SYNONYM_TYPE" ("PID", "CID", "INTL", "STATUS", "CID_TYPE", "MAX_PCT", "ING_TYPE", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED", "ES_SEQ_NO") AS 
  SELECT itingcfg_h.pid,
       itingcfg_h.cid,
       itingcfg.intl,
       itingcfg.status,
       itingcfg.cid_type,
       itingcfg.max_pct,
       itingcfg.ing_type,
       itingcfg_h.revision,
       itingcfg_h.lang_id,
       itingcfg_h.description,
       itingcfg_h.last_modified_on,
       itingcfg_h.last_modified_by,
       itingcfg_h.max_rev,
       itingcfg_h.date_imported,
       itingcfg_h.es_seq_no
  FROM RVitingcfg_h itingcfg_h, RVitingcfg itingcfg
 WHERE itingcfg.cid = itingcfg_h.cid(+)
   AND itingcfg_h.pid = 6
   AND itingcfg_h.max_rev=1
 ;
--------------------------------------------------------
--  DDL for View RVI_SYNONYMS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_SYNONYMS" ("PID", "CID", "INTL", "STATUS", "CID_TYPE", "MAX_PCT", "ING_TYPE", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED", "ES_SEQ_NO") AS 
  SELECT itingcfg_h.pid,
       itingcfg_h.cid,
       itingcfg.intl,
       itingcfg.status,
       itingcfg.cid_type,
       itingcfg.max_pct,
       itingcfg.ing_type,
       itingcfg_h.revision,
       itingcfg_h.lang_id,
       itingcfg_h.description,
       itingcfg_h.last_modified_on,
       itingcfg_h.last_modified_by,
       itingcfg_h.max_rev,
       itingcfg_h.date_imported,
       itingcfg_h.es_seq_no
  FROM RVitingcfg_h itingcfg_h, RVitingcfg itingcfg
 WHERE itingcfg.cid = itingcfg_h.cid(+)
   AND itingcfg_h.pid = 4
   AND itingcfg_h.max_rev = 1
 ;
--------------------------------------------------------
--  DDL for View RVI_TEST_METHOD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_TEST_METHOD" ("TEST_METHOD_ID", "INTL", "STATUS", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED", "LONG_DESCR") AS 
  SELECT tes.test_method AS test_method_id,
       tes.intl,
       tes.status,
       tes_h.revision,
       tes_h.lang_id,
       tes_h.description,
       tes_h.last_modified_on,
       tes_h.last_modified_by,
       tes_h.max_rev,
       tes_h.date_imported,
       tes_h.long_descr
  FROM RVtest_method tes, RVtest_method_h tes_h
 WHERE tes.test_method = tes_h.test_method(+)
   AND tes_h.max_rev = 1
 ;
--------------------------------------------------------
--  DDL for View RVI_TEST_METHOD_CONDITION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_TEST_METHOD_CONDITION" ("TEST_METHOD_ID", "CONDITION_ID", "SET_NO", "CONDITION", "INTL") AS 
  SELECT test_method AS test_method_id,
       condition AS condition_id,
       set_no,
       condition,
       intl
  FROM test_method_condition
 ;
--------------------------------------------------------
--  DDL for View RVI_TEXT_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_TEXT_TYPE" ("TEXT_TYPE", "PROCESS_FLAG", "INTL", "STATUS", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED", "ES_SEQ_NO") AS 
  SELECT text_type.text_type,
       text_type.process_flag,
       text_type.intl,
       text_type.status,
       text_type_h.revision,
       text_type_h.lang_id,
       text_type_h.description,
       text_type_h.last_modified_on,
       text_type_h.last_modified_by,
       text_type_h.max_rev,
       text_type_h.date_imported,
       text_type_h.es_seq_no
  FROM RVtext_type text_type, RVtext_type_h text_type_h
 WHERE ((text_type.text_type = text_type_h.text_type))
and text_type_h.max_rev=1
 ;
--------------------------------------------------------
--  DDL for View RVI_TREETYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_TREETYPE" ("TREETYPE", "CID") AS 
  SELECT distinct SPEC_GROUP as TreeType,itcltv.cid
from RVitcld itcld, RVitcltv itcltv
where itcld.node = itcltv.TYPE
and itcltv.pid=0
 ;
--------------------------------------------------------
--  DDL for View RVI_UOM
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_UOM" ("UOM_ID", "INTL", "STATUS", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED") AS 
  SELECT uom_h.uom_id,
          uom.intl,
          uom.status,
          uom_h.revision,
          uom_h.lang_id,
          uom_h.description,
          uom_h.last_modified_on,
          uom_h.last_modified_by,
          uom_h.max_rev,
          uom_h.date_imported
     FROM RVuom_h uom_h, RVuom uom
    WHERE uom.uom_id = uom_h.uom_id(+)
      AND uom_h.max_rev = 1
 ;
--------------------------------------------------------
--  DDL for View RVI_UOM_ASSOCIATION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_UOM_ASSOCIATION" ("ASSOCATION_ID", "UOM_ID", "LOWER_REJECT", "UPPER_REJECT", "INTL") AS 
  SELECT association AS assocation_id,
          uom AS uom_id,
          lower_reject,
          upper_reject,
          intl
     FROM uom_association
 ;
--------------------------------------------------------
--  DDL for View RVI_USER_ACCESS_GROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_USER_ACCESS_GROUP" ("ACCESS_GROUP_ID", "USER_GROUP_ID", "UPDATE_ALLOWED", "MRP_UPDATE") AS 
  SELECT access_group as access_group_id,
          user_group_id,
          update_allowed,
          mrp_update
     FROM user_access_group
 ;
--------------------------------------------------------
--  DDL for View RVI_USER_GROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_USER_GROUP" ("DESCRIPTION", "USER_GROUP_ID", "SHORT_DESC") AS 
  SELECT   user_group.description,
         user_group.user_group_id,
         user_group.short_desc
    FROM user_group
ORDER BY user_group.description ASC
 ;
--------------------------------------------------------
--  DDL for View RVI_USER_GROUP_LIST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_USER_GROUP_LIST" ("USER_GROUP_ID", "USER_ID") AS 
  SELECT user_group_list.user_group_id,
       user_group_list.user_id
  FROM user_group_list
 ;
--------------------------------------------------------
--  DDL for View RVI_USER_WORKFLOW_GROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_USER_WORKFLOW_GROUP" ("WORKFLOW_GROUP_ID", "USER_GROUP_ID") AS 
  SELECT workflow_group_id,
          user_group_id
     FROM user_workflow_group
 ;
--------------------------------------------------------
--  DDL for View RVI_USERS_LOGGED_ON
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_USERS_LOGGED_ON" ("SID", "USERNAME", "FORENAME", "LAST_NAME", "TELEPHONE_NO", "LOGON_TIME", "OSUSER", "MACHINE", "PROGRAM", "MODULE") AS 
  SELECT SID,
       username,
       application_user.forename,
       application_user.last_name,
       telephone_no,
       logon_time,
       osuser,
       machine,
       program,
       module
  FROM v$session, RVapplication_user application_user
 WHERE v$session.username = application_user.user_id
   AND TYPE <> 'BACKGROUND'
   AND schemaname <> 'SYS'
   AND schemaname <> 'INTERSPC'
 ;
--------------------------------------------------------
--  DDL for View RVI_VALIDATION_RULES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_VALIDATION_RULES" ("CF_ID", "CF_TYPE", "DESCRIPTION", "PROCEDURE_NAME", "CUSTOM") AS 
  SELECT itcf.cf_id,
	   DECODE(itcf.cf_type,'V','ERROR','WARNING') as cf_type,
	   itcf.description,
	   itcf.procedure_name,
       itcf.custom
  FROM itcf
 ;
--------------------------------------------------------
--  DDL for View RVI_WORKFLOW
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_WORKFLOW" ("WORK_FLOW_ID", "STATUS_SORT_DESC", "STATUS_DESCRIPTION", "STATUS_STATUS_TYPE", "STATUS_PHASE_IN_STATUS", "STATUS_EMAIL_TITLE", "STATUS_PROMPT_FOR_REASON", "STATUS_REASON_MANDATORY", "STATUS_ES", "NEXTSTATUS_SORT_DESC", "NEXTSTATUS_DESCRIPTION", "NEXTSTATUS_STATUS_TYPE", "NEXTSTATUS_PHASE_IN_STATUS", "NEXTSTATUS_EMAIL_TITLE", "NEXTSTATUS_PROMPT_FOR_REASON", "NEXTSTATUS_REASON_MANDATORY", "NEXTSTATUS_ES", "EXPORT_ERP") AS 
  SELECT work_flow.work_flow_id,
       status.sort_desc as status_sort_desc,
	   status.description as status_description,
       status.status_type as status_status_type,
	   status.phase_in_status as status_phase_in_status,
	   status.email_title as status_email_title,
       status.prompt_for_reason as status_prompt_for_reason,
	   status.reason_mandatory as status_reason_mandatory,
	   status.es as status_es,
       stat.sort_desc as nextstatus_sort_desc,
	   stat.description as nextstatus_description,
	   stat.status_type as nextstatus_status_type,
       stat.phase_in_status as nextstatus_phase_in_status,
	   stat.email_title as nextstatus_email_title,
	   stat.prompt_for_reason as nextstatus_prompt_for_reason,
       stat.reason_mandatory as nextstatus_reason_mandatory,
	   stat.es as nextstatus_es,
	   work_flow.EXPORT_ERP
  FROM RVwork_flow work_flow, RVstatus status, RVstatus stat
 WHERE (    (work_flow.status = status.status)
        AND (work_flow.next_status = stat.status)
       )
 ;
--------------------------------------------------------
--  DDL for View RVI_WORKFLOW_GROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_WORKFLOW_GROUP" ("WORKFLOW_GROUP_ID", "SORT_DESC", "DESCRIPTION", "WORK_FLOW_ID") AS 
  SELECT workflow_group.workflow_group_id,
       workflow_group.sort_desc,
       workflow_group.description,
       workflow_group.work_flow_id
  FROM RVworkflow_group workflow_group
UNION
SELECT -1,
       '<ALL>',
       'All workflows',
       TO_NUMBER(NULL)
  FROM DUAL
 ;
--------------------------------------------------------
--  DDL for View RVI_WORKFLOW_GROUP_FILTER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_WORKFLOW_GROUP_FILTER" ("DESCRIPTION", "WORKFLOW_GROUP_ID", "USER_GROUP_ID") AS 
  SELECT USER_GROUP.DESCRIPTION,
       USER_WORKFLOW_GROUP.WORKFLOW_GROUP_ID,
       USER_WORKFLOW_GROUP.USER_GROUP_ID
  FROM RVUSER_GROUP USER_GROUP, RVUSER_WORKFLOW_GROUP USER_WORKFLOW_GROUP
 WHERE (USER_GROUP.USER_GROUP_ID = USER_WORKFLOW_GROUP.USER_GROUP_ID)
 ;
--------------------------------------------------------
--  DDL for View RVI_WORKFLOW_LIST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_WORKFLOW_LIST" ("WORKFLOW_GROUP_ID", "USER_GROUP_ID", "ALL_TO_APPROVE", "SEND_MAIL", "EFF_DATE_MAIL", "STATUS_DESCRIPTION", "STATUS_SORT_DESC") AS 
  SELECT work_flow_list.workflow_group_id,
       work_flow_list.user_group_id,
       work_flow_list.all_to_approve,
       work_flow_list.send_mail,
       work_flow_list.eff_date_mail,
       rvstatus.description as status_description,
       rvstatus.sort_desc as status_sort_desc
  FROM RVwork_flow_list work_flow_list, rvstatus
 WHERE ((work_flow_list.status = rvstatus.status))
 ;
--------------------------------------------------------
--  DDL for View RVI_WORKFLOW_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_WORKFLOW_TYPE" ("WORK_FLOW_ID", "DESCRIPTION", "INITIAL_STATUS") AS 
  SELECT work_flow_group.work_flow_id,
	   work_flow_group.description,
       work_flow_group.initial_status
FROM work_flow_group
 ;
--------------------------------------------------------
--  DDL for View RVI_WORKFLOW_VALIDATION_RULES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVI_WORKFLOW_VALIDATION_RULES" ("WORKFLOW_GROUP_ID", "CF_ID", "STATUS_TYPE", "S_FROM", "S_TO", "CUSTOM") AS 
  SELECT itsscf.WORKFLOW_GROUP_ID,
	   itsscf.CF_ID,
	   itsscf.status_type,
       itsscf.s_from,
	   itsscf.s_to,
	   itsscf.allow_modify as custom
  FROM itsscf
 ;
--------------------------------------------------------
--  DDL for View RVINTERSPC_CFG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVINTERSPC_CFG" ("SECTION", "PARAMETER", "PARAMETER_DATA", "VISIBLE", "ES", "ES_SEQ_NO") AS 
  SELECT "SECTION","PARAMETER","PARAMETER_DATA","VISIBLE","ES","ES_SEQ_NO" FROM INTERSPC_CFG
 ;
--------------------------------------------------------
--  DDL for View RVINTERSPC_CFG_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVINTERSPC_CFG_H" ("SECTION", "PARAMETER", "PARAMETER_DATA_OLD", "PARAMETER_DATA_NEW", "ACTION", "ES_SEQ_NO", "USER_ID", "FORENAME", "LAST_NAME", "TIMESTAMP", "SIGN_FOR_ID", "SIGN_FOR", "SIGN_WHAT_ID", "SIGN_WHAT") AS 
  SELECT "SECTION","PARAMETER","PARAMETER_DATA_OLD","PARAMETER_DATA_NEW","ACTION","ES_SEQ_NO","USER_ID","FORENAME","LAST_NAME","TIMESTAMP","SIGN_FOR_ID","SIGN_FOR","SIGN_WHAT_ID","SIGN_WHAT" FROM INTERSPC_CFG_H
 ;
--------------------------------------------------------
--  DDL for View RVIT_TR_JRNL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVIT_TR_JRNL" ("ID", "REVISION", "PREV_DESCR", "NEW_DESCR", "LAST_MODIFIED_BY", "LAST_MODIFIED_ON", "ID_TYPE", "OWNER", "LANG_ID") AS 
  SELECT "ID","REVISION","PREV_DESCR","NEW_DESCR","LAST_MODIFIED_BY","LAST_MODIFIED_ON","ID_TYPE","OWNER","LANG_ID" FROM IT_TR_JRNL
 ;
--------------------------------------------------------
--  DDL for View RVITADDON
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITADDON" ("ADDON_ID", "NAME", "DESCRIPTION", "CLASS", "DOMAIN", "ADDONTYPE", "ASSEMBLY", "STARTURL", "STARTPARAM") AS 
  SELECT "ADDON_ID","NAME","DESCRIPTION","CLASS","DOMAIN","ADDONTYPE","ASSEMBLY","STARTURL","STARTPARAM" FROM ITADDON
 ;
--------------------------------------------------------
--  DDL for View RVITADDONARG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITADDONARG" ("ADDON_ID", "ARG_ID", "ARG") AS 
  SELECT "ADDON_ID","ARG_ID","ARG" FROM ITADDONARG
 ;
--------------------------------------------------------
--  DDL for View RVITADDONRQ
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITADDONRQ" ("REQ_ID", "USER_ID", "ADDON_ID", "METRIC", "LANG_ID", "CULTURE", "GUI_LANG", "NEXT_ADDON_ID") AS 
  SELECT "REQ_ID","USER_ID","ADDON_ID","METRIC","LANG_ID","CULTURE","GUI_LANG","NEXT_ADDON_ID" FROM ITADDONRQ
 ;
--------------------------------------------------------
--  DDL for View RVITADDONRQARG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITADDONRQARG" ("REQ_ID", "ARG", "ARG_VAL") AS 
  SELECT "REQ_ID","ARG","ARG_VAL" FROM ITADDONRQARG
 ;
--------------------------------------------------------
--  DDL for View RVITADDONTYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITADDONTYPE" ("ADDONTYPE_ID", "DESCRIPTION") AS 
  SELECT "ADDONTYPE_ID","DESCRIPTION" FROM ITADDONTYPE
 ;
--------------------------------------------------------
--  DDL for View RVITAGHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITAGHS" ("ACCESS_GROUP", "AUDIT_TRAIL_SEQ_NO", "USER_ID", "FORENAME", "LAST_NAME", "TIMESTAMP", "WHAT_ID", "WHAT") AS 
  SELECT "ACCESS_GROUP","AUDIT_TRAIL_SEQ_NO","USER_ID","FORENAME","LAST_NAME","TIMESTAMP","WHAT_ID","WHAT" FROM ITAGHS
 ;
--------------------------------------------------------
--  DDL for View RVITAGHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITAGHSDETAILS" ("ACCESS_GROUP", "AUDIT_TRAIL_SEQ_NO", "SEQ_NO", "DETAILS") AS 
  SELECT "ACCESS_GROUP","AUDIT_TRAIL_SEQ_NO","SEQ_NO","DETAILS" FROM ITAGHSDETAILS
 ;
--------------------------------------------------------
--  DDL for View RVITAPI
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITAPI" ("PROCEDURE_NAME", "TYPE", "CUSTOM") AS 
  SELECT "PROCEDURE_NAME","TYPE","CUSTOM" FROM ITAPI
 ;
--------------------------------------------------------
--  DDL for View RVITATTEXPLOSION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITATTEXPLOSION" ("BOM_EXP_NO", "MOP_SEQUENCE_NO", "SEQUENCE_NO", "ATT_PART", "ATT_REVISION", "DESCRIPTION", "PARENT_PART", "PARENT_REVISION", "PLANT", "ALTERNATIVE", "USAGE") AS 
  SELECT "BOM_EXP_NO","MOP_SEQUENCE_NO","SEQUENCE_NO","ATT_PART","ATT_REVISION","DESCRIPTION","PARENT_PART","PARENT_REVISION","PLANT","ALTERNATIVE","USAGE" FROM ITATTEXPLOSION
 ;
--------------------------------------------------------
--  DDL for View RVITBIT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITBIT" ("BIT_ID", "DESCRIPTION", "PART_SOURCE") AS 
  SELECT "BIT_ID","DESCRIPTION","PART_SOURCE" FROM ITBIT
 ;
--------------------------------------------------------
--  DDL for View RVITBOMEXPLOSION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITBOMEXPLOSION" ("BOM_EXP_NO", "MOP_SEQUENCE_NO", "SEQUENCE_NO", "BOM_LEVEL", "COMPONENT_PART", "COMPONENT_REVISION", "DESCRIPTION", "PLANT", "ALTERNATIVE", "USAGE", "PART_SOURCE", "INGREDIENT", "PHANTOM", "RECURSIVE_STOP", "ACCESS_STOP", "QTY", "UOM", "CONV_FACTOR", "TO_UNIT", "SCRAP", "CALC_QTY", "CALC_QTY_WITH_SCRAP", "COST", "COST_WITH_SCRAP", "CALC_COST", "CALC_COST_WITH_SCRAP", "CALCULATED", "ALT_PRICE_TYPE", "PART_TYPE", "ASSEMBLY_SCRAP", "COMPONENT_SCRAP", "LEAD_TIME_OFFSET", "ITEM_CATEGORY", "ISSUE_LOCATION", "BOM_ITEM_TYPE", "OPERATIONAL_STEP", "MIN_QTY", "MAX_QTY", "CHAR_1", "CHAR_2", "CODE", "ALT_GROUP", "ALT_PRIORITY", "NUM_1", "NUM_2", "NUM_3", "NUM_4", "NUM_5", "CHAR_3", "CHAR_4", "CHAR_5", "DATE_1", "DATE_2", "CH_1", "CH_REV_1", "CH_2", "CH_REV_2", "CH_3", "CH_REV_3", "RELEVENCY_TO_COSTING", "BULK_MATERIAL", "BOOLEAN_1", "BOOLEAN_2", "BOOLEAN_3", "BOOLEAN_4") AS 
  SELECT "BOM_EXP_NO","MOP_SEQUENCE_NO","SEQUENCE_NO","BOM_LEVEL","COMPONENT_PART","COMPONENT_REVISION","DESCRIPTION","PLANT","ALTERNATIVE","USAGE","PART_SOURCE","INGREDIENT","PHANTOM","RECURSIVE_STOP","ACCESS_STOP","QTY","UOM","CONV_FACTOR","TO_UNIT","SCRAP","CALC_QTY","CALC_QTY_WITH_SCRAP","COST","COST_WITH_SCRAP","CALC_COST","CALC_COST_WITH_SCRAP","CALCULATED","ALT_PRICE_TYPE","PART_TYPE","ASSEMBLY_SCRAP","COMPONENT_SCRAP","LEAD_TIME_OFFSET","ITEM_CATEGORY","ISSUE_LOCATION","BOM_ITEM_TYPE","OPERATIONAL_STEP","MIN_QTY","MAX_QTY","CHAR_1","CHAR_2","CODE","ALT_GROUP","ALT_PRIORITY","NUM_1","NUM_2","NUM_3","NUM_4","NUM_5","CHAR_3","CHAR_4","CHAR_5","DATE_1","DATE_2","CH_1","CH_REV_1","CH_2","CH_REV_2","CH_3","CH_REV_3","RELEVENCY_TO_COSTING","BULK_MATERIAL","BOOLEAN_1","BOOLEAN_2","BOOLEAN_3","BOOLEAN_4" FROM ITBOMEXPLOSION WHERE iapiRM.CheckBOMAccess = 'Y'
 ;
--------------------------------------------------------
--  DDL for View RVITBOMEXPTEMP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITBOMEXPTEMP" ("BOM_EXP_NO", "MOP_SEQUENCE_NO", "SEQUENCE_NO", "PSEQUENCE_NO") AS 
  SELECT "BOM_EXP_NO","MOP_SEQUENCE_NO","SEQUENCE_NO","PSEQUENCE_NO" FROM ITBOMEXPTEMP
 ;
--------------------------------------------------------
--  DDL for View RVITBOMIMPLOSION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITBOMIMPLOSION" ("BOM_IMP_NO", "MOP_SEQUENCE_NO", "MOP_PART", "SEQUENCE_NO", "BOM_LEVEL", "PARENT_PART", "PARENT_REVISION", "DESCRIPTION", "PLANT", "ALTERNATIVE", "USAGE", "SPEC_TYPE", "TOP_LEVEL", "ACCESS_STOP", "RECURSIVE_STOP", "ALT_GROUP", "ALT_PRIORITY") AS 
  SELECT "BOM_IMP_NO","MOP_SEQUENCE_NO","MOP_PART","SEQUENCE_NO","BOM_LEVEL","PARENT_PART","PARENT_REVISION","DESCRIPTION","PLANT","ALTERNATIVE","USAGE","SPEC_TYPE","TOP_LEVEL","ACCESS_STOP","RECURSIVE_STOP","ALT_GROUP","ALT_PRIORITY" FROM ITBOMIMPLOSION WHERE iapiRM.CheckBOMAccess = 'Y'
 ;
--------------------------------------------------------
--  DDL for View RVITBOMLY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITBOMLY" ("LAYOUT_ID", "DESCRIPTION", "INTL", "STATUS", "CREATED_BY", "CREATED_ON", "LAST_MODIFIED_BY", "LAST_MODIFIED_ON", "REVISION", "DATE_IMPORTED", "LAYOUT_TYPE") AS 
  SELECT "LAYOUT_ID","DESCRIPTION","INTL","STATUS","CREATED_BY","CREATED_ON","LAST_MODIFIED_BY","LAST_MODIFIED_ON","REVISION","DATE_IMPORTED","LAYOUT_TYPE" FROM ITBOMLY WHERE iapiRM.CheckBOMAccess = 'Y'
 ;
--------------------------------------------------------
--  DDL for View RVITBOMLYITEM
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITBOMLYITEM" ("LAYOUT_ID", "HEADER_ID", "FIELD_ID", "INCLUDED", "START_POS", "LENGTH", "ALIGNMENT", "FORMAT_ID", "HEADER", "COLOR", "BOLD", "UNDERLINE", "INTL", "REVISION", "HEADER_REV", "DEF", "FIELD_TYPE", "EDITABLE", "PHASE_MRP", "PLANNING_MRP", "PRODUCTION_MRP", "ASSOCIATION", "CHARACTERISTIC") AS 
  SELECT "LAYOUT_ID","HEADER_ID","FIELD_ID","INCLUDED","START_POS","LENGTH","ALIGNMENT","FORMAT_ID","HEADER","COLOR","BOLD","UNDERLINE","INTL","REVISION","HEADER_REV","DEF","FIELD_TYPE","EDITABLE","PHASE_MRP","PLANNING_MRP","PRODUCTION_MRP","ASSOCIATION","CHARACTERISTIC" FROM ITBOMLYITEM WHERE iapiRM.CheckBOMAccess = 'Y'
 ;
--------------------------------------------------------
--  DDL for View RVITBOMLYSOURCE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITBOMLYSOURCE" ("SOURCE", "LAYOUT_TYPE", "LAYOUT_ID", "LAYOUT_REV", "PREFERRED") AS 
  SELECT "SOURCE","LAYOUT_TYPE","LAYOUT_ID","LAYOUT_REV","PREFERRED" FROM ITBOMLYSOURCE WHERE iapiRM.CheckBOMAccess = 'Y'
 ;
--------------------------------------------------------
--  DDL for View RVITBU
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITBU" ("BOM_USAGE", "DESCR") AS 
  SELECT "BOM_USAGE","DESCR" FROM ITBU WHERE iapiRM.CheckBOMAccess = 'Y'
 ;
--------------------------------------------------------
--  DDL for View RVITCF
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITCF" ("CF_ID", "CF_TYPE", "DESCRIPTION", "PROCEDURE_NAME", "CUSTOM", "STANDARD_FUNCTION") AS 
  SELECT "CF_ID","CF_TYPE","DESCRIPTION","PROCEDURE_NAME","CUSTOM","STANDARD_FUNCTION" FROM ITCF
 ;
--------------------------------------------------------
--  DDL for View RVITCLAIMLOGRESULT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITCLAIMLOGRESULT" ("LOG_ID", "PROPERTY_GROUP", "PROPERTY_GROUP_REV", "PROPERTY", "PROPERTY_REV", "PG_TYPE", "VALUE") AS 
  SELECT "LOG_ID","PROPERTY_GROUP","PROPERTY_GROUP_REV","PROPERTY","PROPERTY_REV","PG_TYPE","VALUE" FROM ITCLAIMLOGRESULT
 ;
--------------------------------------------------------
--  DDL for View RVITCLAIMRESULT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITCLAIMRESULT" ("BOM_EXP_NO", "PROPERTY_GROUP", "PROPERTY_GROUP_REV", "PROPERTY", "PROPERTY_REV", "PG_TYPE", "CLAIM") AS 
  SELECT "BOM_EXP_NO","PROPERTY_GROUP","PROPERTY_GROUP_REV","PROPERTY","PROPERTY_REV","PG_TYPE","CLAIM" FROM ITCLAIMRESULT
 ;
--------------------------------------------------------
--  DDL for View RVITCLAT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITCLAT" ("TREE_ID", "ATTRIBUTE_ID", "LABEL", "TYPE", "CODE") AS 
  SELECT "TREE_ID","ATTRIBUTE_ID","LABEL","TYPE","CODE" FROM ITCLAT
 ;
--------------------------------------------------------
--  DDL for View RVITCLCLF
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITCLCLF" ("ID", "PID", "CID", "DESCR") AS 
  SELECT "ID","PID","CID","DESCR" FROM ITCLCLF
 ;
--------------------------------------------------------
--  DDL for View RVITCLD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITCLD" ("ID", "SPEC_GROUP", "NODE") AS 
  SELECT "ID","SPEC_GROUP","NODE" FROM ITCLD
 ;
--------------------------------------------------------
--  DDL for View RVITCLFLT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITCLFLT" ("FILTER_ID", "MATL_CLASS_ID", "CODE", "TYPE") AS 
  SELECT "FILTER_ID","MATL_CLASS_ID","CODE","TYPE" FROM ITCLFLT
 ;
--------------------------------------------------------
--  DDL for View RVITCLTV
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITCLTV" ("PID", "CID", "DESCR", "CCNT", "CODE", "TYPE", "LONG_DESCR") AS 
  SELECT "PID","CID","DESCR","CCNT","CODE","TYPE","LONG_DESCR" FROM ITCLTV
 ;
--------------------------------------------------------
--  DDL for View RVITCULTUREMAPPING
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITCULTUREMAPPING" ("LANG_ID", "CULTURE_ID") AS 
  SELECT "LANG_ID","CULTURE_ID" FROM ITCULTUREMAPPING
 ;
--------------------------------------------------------
--  DDL for View RVITDATEOFFSET
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITDATEOFFSET" ("OFFSET") AS 
  SELECT "OFFSET" FROM ITDATEOFFSET
 ;
--------------------------------------------------------
--  DDL for View RVITDBPROFILE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITDBPROFILE" ("OWNER", "DESCRIPTION", "DB_TYPE", "ALLOW_GLOSSARY", "ALLOW_FRAME_CHANGES", "ALLOW_FRAME_EXPORT", "LIVE_DB", "PARENT_OWNER", "REGION", "DEVISION", "COUNTRY") AS 
  SELECT "OWNER","DESCRIPTION","DB_TYPE","ALLOW_GLOSSARY","ALLOW_FRAME_CHANGES","ALLOW_FRAME_EXPORT","LIVE_DB","PARENT_OWNER","REGION","DEVISION","COUNTRY" FROM ITDBPROFILE
 ;
--------------------------------------------------------
--  DDL for View RVITENSSLOG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITENSSLOG" ("EN_TP", "EN_ID", "STATUS_CHANGE_DATE", "USER_ID", "STATUS") AS 
  SELECT "EN_TP","EN_ID","STATUS_CHANGE_DATE","USER_ID","STATUS" FROM ITENSSLOG
 ;
--------------------------------------------------------
--  DDL for View RVITERROR
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITERROR" ("SEQ_NO", "MACHINE", "MODULE", "SOURCE", "APPLIC", "USER_ID", "LOGDATE", "ERROR_MSG", "MSG_TYPE", "INFOLEVEL") AS 
  SELECT "SEQ_NO","MACHINE","MODULE","SOURCE","APPLIC","USER_ID","LOGDATE","ERROR_MSG","MSG_TYPE","INFOLEVEL" FROM ITERROR
 ;
--------------------------------------------------------
--  DDL for View RVITESHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITESHS" ("ES_SEQ_NO", "TYPE", "USER_ID", "FORENAME", "LAST_NAME", "TIMESTAMP", "SIGN_FOR_ID", "SIGN_FOR", "SIGN_WHAT_ID", "SIGN_WHAT", "SUCCESS", "SUCCESS_DESCR") AS 
  SELECT "ES_SEQ_NO","TYPE","USER_ID","FORENAME","LAST_NAME","TIMESTAMP","SIGN_FOR_ID","SIGN_FOR","SIGN_WHAT_ID","SIGN_WHAT","SUCCESS","SUCCESS_DESCR" FROM ITESHS
 ;
--------------------------------------------------------
--  DDL for View RVITEVENT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITEVENT" ("EVENT_ID", "NAME", "CREATED_ON", "CREATED_BY") AS 
  SELECT "EVENT_ID","NAME","CREATED_ON","CREATED_BY" FROM ITEVENT
 ;
--------------------------------------------------------
--  DDL for View RVITEVSERVICES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITEVSERVICES" ("EV_SERVICE_NAME", "CREATED_ON") AS 
  SELECT "EV_SERVICE_NAME","CREATED_ON" FROM ITEVSERVICES
 ;
--------------------------------------------------------
--  DDL for View RVITEVSINK
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITEVSINK" ("EV_SEQUENCE", "EV_SERVICE_NAME", "EV_NAME", "EV_DETAILS", "CREATED_ON", "HANDLED_OK", "EVENT_ID", "EV_DATA") AS 
  SELECT "EV_SEQUENCE","EV_SERVICE_NAME","EV_NAME","EV_DETAILS","CREATED_ON","HANDLED_OK","EVENT_ID","EV_DATA" FROM ITEVSINK
 ;
--------------------------------------------------------
--  DDL for View RVITFCLAIM
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITFCLAIM" ("CLAIM_ID", "CLAIM_GUID", "DESCRIPTION", "PLUGINURL", "CLASSNAME", "CLAIMGROUP_ID", "CLAIMTYPE_ID", "INTL", "STATUS") AS 
  SELECT 0 AS CLAIM_ID, 'NO R&'||'D LIBRARY INSTALLED' AS CLAIM_GUID, 'NO R&'||'D LIBRARY INSTALLED' AS DESCRIPTION, 'NO R&'||'D LIBRARY INSTALLED' AS PLUGINURL, 'NO R&'||'D LIBRARY INSTALLED' AS CLASSNAME, 0 AS CLAIMGROUP_ID, 0 AS CLAIMTYPE_ID, 'N' AS INTL, 0 AS STATUS FROM DUAL
 ;
--------------------------------------------------------
--  DDL for View RVITFCLAIM_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITFCLAIM_H" ("CLAIM_ID", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV") AS 
  SELECT 0 AS CLAIM_ID, 0 AS REVISION, 1 AS LANG_ID, 'NO R&'||'D LIBRARY INSTALLED' AS DESCRIPTION, SYSDATE AS LAST_MODIFIED_ON, USER AS LAST_MODIFIED_BY, 0 AS MAX_REV FROM DUAL
 ;
--------------------------------------------------------
--  DDL for View RVITFCLAIMCONDITION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITFCLAIMCONDITION" ("CLAIM_ID", "CONDITION_ID") AS 
  SELECT 0 AS CLAIM_ID, 0 AS CONDITION_ID FROM DUAL
 ;
--------------------------------------------------------
--  DDL for View RVITFCLAIMGROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITFCLAIMGROUP" ("CLAIMGROUP_ID", "DESCRIPTION", "INTL", "STATUS") AS 
  SELECT 0 AS CLAIMGROUP_ID, 'NO R&'||'D LIBRARY INSTALLED' AS DESCRIPTION, 'N' AS INTL, 0 AS STATUS FROM DUAL
 ;
--------------------------------------------------------
--  DDL for View RVITFCLAIMGROUP_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITFCLAIMGROUP_H" ("CLAIMGROUP_ID", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV") AS 
  SELECT 0 AS CLAIMGROUP_ID, 0 AS REVISION, 1 AS LANG_ID, 'NO R&'||'D LIBRARY INSTALLED' AS DESCRIPTION, SYSDATE AS LAST_MODIFIED_ON, USER AS LAST_MODIFIED_BY, 0 AS MAX_REV FROM DUAL
 ;
--------------------------------------------------------
--  DDL for View RVITFCLAIMLOG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITFCLAIMLOG" ("LOG_ID", "LOG_NAME", "STATUS", "PART_NO", "REVISION", "PLANT", "ALTERNATIVE", "BOM_USAGE", "EXPLOSION_DATE", "CREATED_BY", "CREATED_ON", "REPORT_TYPE", "LOGGINGXML") AS 
  SELECT 0 AS LOG_ID, 'NO R&'||'D LIBRARY INSTALLED' AS LOG_NAME, 0 AS STATUS, 0 AS PART_NO, 0 AS REVISION, '---' AS PLANT, 0 AS ALTERNATIVE, 0 AS BOM_USAGE, SYSDATE AS EXPLOSION_DATE, USER AS CREATED_BY, SYSDATE AS CREATED_ON, 0 AS REPORT_TYPE, 'NO R&'||'D LIBRARY INSTALLED' AS LOGGINGXML FROM DUAL
 ;
--------------------------------------------------------
--  DDL for View RVITFCLAIMLOGRESULT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITFCLAIMLOGRESULT" ("LOG_ID", "CLAIM_ID", "PROFILE_ID", "RESULT", "VALUE", "CLAIMTEXT") AS 
  SELECT 0 AS LOG_ID, 0 AS CLAIM_ID, 0 AS PROFILE_ID, 'N' AS RESULT, 'NO R&'||'D LIBRARY INSTALLED' AS vALUE, 'NO R&'||'D LIBRARY INSTALLED' AS CLAIMTEXT FROM DUAL
 ;
--------------------------------------------------------
--  DDL for View RVITFCLAIMTYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITFCLAIMTYPE" ("CLAIMTYPE_ID", "DESCRIPTION", "INTL", "STATUS") AS 
  SELECT 0 AS CLAIMTYPE_ID, 'NO R&'||'D LIBRARY INSTALLED' AS DESCRIPTION, 'N' AS INTL, 0 AS STATUS FROM DUAL
 ;
--------------------------------------------------------
--  DDL for View RVITFCLAIMTYPE_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITFCLAIMTYPE_H" ("CLAIMTYPE_ID", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV") AS 
  SELECT 0 AS CLAIMTYPE_ID, 0 AS REVISION, 1 AS LANG_ID, 'NO R&'||'D LIBRARY INSTALLED' AS DESCRIPTION, SYSDATE AS LAST_MODIFIED_ON, USER AS LAST_MODIFIED_BY, 0 AS MAX_REV FROM DUAL
 ;
--------------------------------------------------------
--  DDL for View RVITFCONDITION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITFCONDITION" ("CONDITION_ID", "DESCRIPTION", "INTL", "STATUS") AS 
  SELECT 0 AS CONDITION_ID, 'NO R&'||'D LIBRARY INSTALLED' AS DESCRIPTION, 'N' AS INTL, 0 AS STATUS FROM DUAL
 ;
--------------------------------------------------------
--  DDL for View RVITFCONDITION_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITFCONDITION_H" ("CONDITION_ID", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV") AS 
  SELECT 0 AS CONDITION_ID, 0 AS REVISION, 1 AS LANG_ID, 'NO R&'||'D LIBRARY INSTALLED' AS DESCRIPTION, SYSDATE AS LAST_MODIFIED_ON, USER AS LAST_MODIFIED_BY, 0 AS MAX_REV FROM DUAL
 ;
--------------------------------------------------------
--  DDL for View RVITFRM_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITFRM_H" ("FRAME_NO", "OWNER", "LAST_MODIFIED_ON") AS 
  SELECT "FRAME_NO","OWNER","LAST_MODIFIED_ON" FROM ITFRM_H
 ;
--------------------------------------------------------
--  DDL for View RVITFRMCL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITFRMCL" ("FRAME_NO", "OWNER", "HIER_LEVEL", "MATL_CLASS_ID", "CODE", "TYPE") AS 
  SELECT "FRAME_NO","OWNER","HIER_LEVEL","MATL_CLASS_ID","CODE","TYPE" FROM ITFRMCL
 ;
--------------------------------------------------------
--  DDL for View RVITFRMDEL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITFRMDEL" ("FRAME_NO", "REVISION", "OWNER", "DELETION_DATE", "STATUS", "USER_ID", "FORENAME", "LAST_NAME") AS 
  SELECT "FRAME_NO","REVISION","OWNER","DELETION_DATE","STATUS","USER_ID","FORENAME","LAST_NAME" FROM ITFRMDEL
 ;
--------------------------------------------------------
--  DDL for View RVITFRMFLT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITFRMFLT" ("FILTER_ID", "FRAME_NO", "REVISION", "OWNER", "STATUS", "DESCRIPTION", "STATUS_CHANGE_DATE", "CREATED_BY", "CREATED_ON", "LAST_MODIFIED_BY", "LAST_MODIFIED_ON", "INTL", "CLASS3_ID", "WORKFLOW_GROUP_ID", "ACCESS_GROUP", "INT_FRAME_NO", "INT_FRAME_REV", "EXPORTED") AS 
  SELECT "FILTER_ID","FRAME_NO","REVISION","OWNER","STATUS","DESCRIPTION","STATUS_CHANGE_DATE","CREATED_BY","CREATED_ON","LAST_MODIFIED_BY","LAST_MODIFIED_ON","INTL","CLASS3_ID","WORKFLOW_GROUP_ID","ACCESS_GROUP","INT_FRAME_NO","INT_FRAME_REV","EXPORTED" FROM ITFRMFLT
 ;
--------------------------------------------------------
--  DDL for View RVITFRMFLTD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITFRMFLTD" ("FILTER_ID", "USER_ID", "DESCRIPTION", "SORT_DESC", "OPTIONS", "DEFAULT_FLT") AS 
  SELECT "FILTER_ID","USER_ID","DESCRIPTION","SORT_DESC","OPTIONS","DEFAULT_FLT" FROM ITFRMFLTD
 ;
--------------------------------------------------------
--  DDL for View RVITFRMFLTOP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITFRMFLTOP" ("FILTER_ID", "LOG_FRAME_NO", "LOG_REVISION", "LOG_OWNER", "LOG_STATUS", "LOG_DESCRIPTION", "LOG_STATUS_CHANGE_DATE", "LOG_CREATED_BY", "LOG_CREATED_ON", "LOG_LAST_MODIFIED_BY", "LOG_LAST_MODIFIED_ON", "LOG_INTL", "LOG_CLASS3_ID", "LOG_WORKFLOW_GROUP_ID", "LOG_ACCESS_GROUP", "LOG_INT_FRAME_NO", "LOG_INT_FRAME_REV", "LOG_EXPORTED") AS 
  SELECT "FILTER_ID","LOG_FRAME_NO","LOG_REVISION","LOG_OWNER","LOG_STATUS","LOG_DESCRIPTION","LOG_STATUS_CHANGE_DATE","LOG_CREATED_BY","LOG_CREATED_ON","LOG_LAST_MODIFIED_BY","LOG_LAST_MODIFIED_ON","LOG_INTL","LOG_CLASS3_ID","LOG_WORKFLOW_GROUP_ID","LOG_ACCESS_GROUP","LOG_INT_FRAME_NO","LOG_INT_FRAME_REV","LOG_EXPORTED" FROM ITFRMFLTOP
 ;
--------------------------------------------------------
--  DDL for View RVITFRMNOTE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITFRMNOTE" ("FRAME_NO", "OWNER", "TEXT") AS 
  SELECT "FRAME_NO","OWNER","TEXT" FROM ITFRMNOTE
 ;
--------------------------------------------------------
--  DDL for View RVITFRMV
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITFRMV" ("FRAME_NO", "REVISION", "OWNER", "VIEW_ID", "DESCRIPTION", "LAST_MODIFIED_BY", "LAST_MODIFIED_ON", "STATUS") AS 
  SELECT "FRAME_NO","REVISION","OWNER","VIEW_ID","DESCRIPTION","LAST_MODIFIED_BY","LAST_MODIFIED_ON","STATUS" FROM ITFRMV
 ;
--------------------------------------------------------
--  DDL for View RVITFRMVAL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITFRMVAL" ("FRAME_NO", "REVISION", "OWNER", "VAL_ID", "MASK_ID", "LAST_MODIFIED_BY", "LAST_MODIFIED_ON", "STATUS") AS 
  SELECT "FRAME_NO","REVISION","OWNER","VAL_ID","MASK_ID","LAST_MODIFIED_BY","LAST_MODIFIED_ON","STATUS" FROM ITFRMVAL
 ;
--------------------------------------------------------
--  DDL for View RVITFRMVALD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITFRMVALD" ("VAL_ID", "VAL_SEQ", "TYPE", "SECTION_ID", "SUB_SECTION_ID", "PROPERTY_GROUP", "PROPERTY", "ATTRIBUTE", "HEADER_ID", "REF_ID", "REF_OWNER") AS 
  SELECT "VAL_ID","VAL_SEQ","TYPE","SECTION_ID","SUB_SECTION_ID","PROPERTY_GROUP","PROPERTY","ATTRIBUTE","HEADER_ID","REF_ID","REF_OWNER" FROM ITFRMVALD
 ;
--------------------------------------------------------
--  DDL for View RVITFRMVPG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITFRMVPG" ("VIEW_ID", "FRAME_NO", "REVISION", "OWNER", "SECTION_ID", "SUB_SECTION_ID", "PROPERTY_GROUP", "PROPERTY", "ATTRIBUTE", "MANDATORY") AS 
  SELECT "VIEW_ID","FRAME_NO","REVISION","OWNER","SECTION_ID","SUB_SECTION_ID","PROPERTY_GROUP","PROPERTY","ATTRIBUTE","MANDATORY" FROM ITFRMVPG
 ;
--------------------------------------------------------
--  DDL for View RVITFRMVSC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITFRMVSC" ("VIEW_ID", "FRAME_NO", "REVISION", "OWNER", "SECTION_ID", "SUB_SECTION_ID", "TYPE", "REF_ID", "SECTION_SEQUENCE_NO", "MANDATORY") AS 
  SELECT "VIEW_ID","FRAME_NO","REVISION","OWNER","SECTION_ID","SUB_SECTION_ID","TYPE","REF_ID","SECTION_SEQUENCE_NO","MANDATORY" FROM ITFRMVSC
 ;
--------------------------------------------------------
--  DDL for View RVITIMP_CHANGES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITIMP_CHANGES" ("OBJECT_TYPE", "ITEM", "WHAT", "OLD_VALUE", "NEW_VALUE", "TIMESTAMP") AS 
  SELECT "OBJECT_TYPE","ITEM","WHAT","OLD_VALUE","NEW_VALUE","TIMESTAMP" FROM ITIMP_CHANGES
 ;
--------------------------------------------------------
--  DDL for View RVITIMP_MAPPING
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITIMP_MAPPING" ("USER_ID", "REMAP_NAME", "REMAP_SEQ", "REMAP_TYPE", "REMAP_GROUP", "REMAP_ITEM", "ORIG_VALUE", "REMAP_VALUE") AS 
  SELECT "USER_ID","REMAP_NAME","REMAP_SEQ","REMAP_TYPE","REMAP_GROUP","REMAP_ITEM","ORIG_VALUE","REMAP_VALUE" FROM ITIMP_MAPPING
 ;
--------------------------------------------------------
--  DDL for View RVITIMPBOM
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITIMPBOM" ("IMPGETDATA_NO", "LINE_NO", "BOM_HEADER_DESC", "BOM_HEADER_BASE_QTY", "PLANT", "ALTERNATIVE", "ITEM_NUMBER", "COMPONENT_PART", "COMPONENT_REVISION", "COMPONENT_PLANT", "QUANTITY", "UOM", "CONV_FACTOR", "TO_UNIT", "YIELD", "ASSEMBLY_SCRAP", "COMPONENT_SCRAP", "LEAD_TIME_OFFSET", "ITEM_CATEGORY", "ISSUE_LOCATION", "CALC_FLAG", "BOM_ITEM_TYPE", "OPERATIONAL_STEP", "BOM_USAGE", "MIN_QTY", "MAX_QTY", "CHAR_1", "CHAR_2", "CODE", "ALT_GROUP", "ALT_PRIORITY", "NUM_1", "NUM_2", "NUM_3", "NUM_4", "NUM_5", "CHAR_3", "CHAR_4", "CHAR_5", "DATE_1", "DATE_2", "CH_1", "CH_2", "CH_3", "RELEVENCY_TO_COSTING", "BULK_MATERIAL", "FIXED_QTY", "BOOLEAN_1", "BOOLEAN_2", "BOOLEAN_3", "BOOLEAN_4", "MAKE_UP") AS 
  SELECT "IMPGETDATA_NO","LINE_NO","BOM_HEADER_DESC","BOM_HEADER_BASE_QTY","PLANT","ALTERNATIVE","ITEM_NUMBER","COMPONENT_PART","COMPONENT_REVISION","COMPONENT_PLANT","QUANTITY","UOM","CONV_FACTOR","TO_UNIT","YIELD","ASSEMBLY_SCRAP","COMPONENT_SCRAP","LEAD_TIME_OFFSET","ITEM_CATEGORY","ISSUE_LOCATION","CALC_FLAG","BOM_ITEM_TYPE","OPERATIONAL_STEP","BOM_USAGE","MIN_QTY","MAX_QTY","CHAR_1","CHAR_2","CODE","ALT_GROUP","ALT_PRIORITY","NUM_1","NUM_2","NUM_3","NUM_4","NUM_5","CHAR_3","CHAR_4","CHAR_5","DATE_1","DATE_2","CH_1","CH_2","CH_3","RELEVENCY_TO_COSTING","BULK_MATERIAL","FIXED_QTY","BOOLEAN_1","BOOLEAN_2","BOOLEAN_3","BOOLEAN_4","MAKE_UP" FROM ITIMPBOM
 ;
--------------------------------------------------------
--  DDL for View RVITIMPLOG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITIMPLOG" ("IMPGETDATA_NO", "LINE_NO", "TIMESTAMP", "LOG_TYPE", "MESSAGE") AS 
  SELECT "IMPGETDATA_NO","LINE_NO","TIMESTAMP","LOG_TYPE","MESSAGE" FROM ITIMPLOG
 ;
--------------------------------------------------------
--  DDL for View RVITIMPPROP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITIMPPROP" ("IMPGETDATA_NO", "LINE_NO", "PROPERTY_GROUP", "PROPERTY", "ATTRIBUTE", "HEADER_ID", "VALUE_S", "VALUE_N", "LANG_ID") AS 
  SELECT "IMPGETDATA_NO","LINE_NO","PROPERTY_GROUP","PROPERTY","ATTRIBUTE","HEADER_ID","VALUE_S","VALUE_N","LANG_ID" FROM ITIMPPROP
 ;
--------------------------------------------------------
--  DDL for View RVITING
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITING" ("INGREDIENT", "DESCRIPTION", "INTL", "STATUS", "ING_TYPE", "RECFAC", "ALLERGEN", "SOI", "ORG_ING", "REC_ING") AS 
  SELECT "INGREDIENT","DESCRIPTION","INTL","STATUS","ING_TYPE","RECFAC","ALLERGEN","SOI","ORG_ING","REC_ING" FROM ITING
 ;
--------------------------------------------------------
--  DDL for View RVITINGCFG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITINGCFG" ("PID", "CID", "DESCRIPTION", "INTL", "STATUS", "CID_TYPE", "MAX_PCT", "ING_TYPE", "SUFFIX") AS 
  SELECT "PID","CID","DESCRIPTION","INTL","STATUS","CID_TYPE","MAX_PCT","ING_TYPE","SUFFIX" FROM ITINGCFG
 ;
--------------------------------------------------------
--  DDL for View RVITINGCFG_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITINGCFG_H" ("PID", "CID", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED", "ES_SEQ_NO") AS 
  SELECT "PID","CID","REVISION","LANG_ID","DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","MAX_REV","DATE_IMPORTED","ES_SEQ_NO" FROM ITINGCFG_H
 ;
--------------------------------------------------------
--  DDL for View RVITINGCTFA
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITINGCTFA" ("INGREDIENT", "REG_ID", "START_PG", "END_PG", "LIST_IND", "INTL") AS 
  SELECT "INGREDIENT","REG_ID","START_PG","END_PG","LIST_IND","INTL" FROM ITINGCTFA
 ;
--------------------------------------------------------
--  DDL for View RVITINGCTFA_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITINGCTFA_H" ("INGREDIENT", "REG_ID", "START_PG", "END_PG", "LIST_IND", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "DATE_IMPORTED", "ACTION", "INTL") AS 
  SELECT "INGREDIENT","REG_ID","START_PG","END_PG","LIST_IND","LAST_MODIFIED_ON","LAST_MODIFIED_BY","DATE_IMPORTED","ACTION","INTL" FROM ITINGCTFA_H
 ;
--------------------------------------------------------
--  DDL for View RVITINGD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITINGD" ("INGREDIENT", "PID", "CID", "INTL", "PREF") AS 
  SELECT "INGREDIENT","PID","CID","INTL","PREF" FROM ITINGD
 ;
--------------------------------------------------------
--  DDL for View RVITINGD_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITINGD_H" ("INGREDIENT", "PID", "CID", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "DATE_IMPORTED", "ACTION", "PREF", "INTL") AS 
  SELECT "INGREDIENT","PID","CID","LAST_MODIFIED_ON","LAST_MODIFIED_BY","DATE_IMPORTED","ACTION","PREF","INTL" FROM ITINGD_H
 ;
--------------------------------------------------------
--  DDL for View RVITINGEXPLOSION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITINGEXPLOSION" ("BOM_EXP_NO", "MOP_SEQUENCE_NO", "SEQUENCE_NO", "ING_SEQUENCE_NO", "BOM_LEVEL", "INGREDIENT", "REVISION", "DESCRIPTION", "ING_QTY", "ING_LEVEL", "ING_COMMENT", "PID", "HIER_LEVEL", "RECFAC", "ING_SYNONYM", "ING_SYNONYM_REV", "ACTIVE", "COMPONENT_PART_NO", "COMPONENT_REVISION", "COMPONENT_DESCRIPTION", "COMPONENT_PLANT", "COMPONENT_ALTERNATIVE", "COMPONENT_USAGE", "COMPONENT_CALC_QTY", "COMPONENT_UOM", "COMPONENT_CONV_FACTOR", "COMPONENT_TO_UNIT", "INGDECLARE") AS 
  SELECT "BOM_EXP_NO","MOP_SEQUENCE_NO","SEQUENCE_NO","ING_SEQUENCE_NO","BOM_LEVEL","INGREDIENT","REVISION","DESCRIPTION","ING_QTY","ING_LEVEL","ING_COMMENT","PID","HIER_LEVEL","RECFAC","ING_SYNONYM","ING_SYNONYM_REV","ACTIVE","COMPONENT_PART_NO","COMPONENT_REVISION","COMPONENT_DESCRIPTION","COMPONENT_PLANT","COMPONENT_ALTERNATIVE","COMPONENT_USAGE","COMPONENT_CALC_QTY","COMPONENT_UOM","COMPONENT_CONV_FACTOR","COMPONENT_TO_UNIT","INGDECLARE" FROM ITINGEXPLOSION
 ;
--------------------------------------------------------
--  DDL for View RVITINGGROUPD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITINGGROUPD" ("PID", "CID", "INTL") AS 
  SELECT "PID","CID","INTL" FROM ITINGGROUPD
 ;
--------------------------------------------------------
--  DDL for View RVITINGGROUPD_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITINGGROUPD_H" ("PID", "CID", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "DATE_IMPORTED", "ACTION", "INTL") AS 
  SELECT "PID","CID","LAST_MODIFIED_ON","LAST_MODIFIED_BY","DATE_IMPORTED","ACTION","INTL" FROM ITINGGROUPD_H
 ;
--------------------------------------------------------
--  DDL for View RVITINGNOTE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITINGNOTE" ("NOTE_ID", "DESCRIPTION", "TEXT", "INTL", "STATUS") AS 
  SELECT "NOTE_ID","DESCRIPTION","TEXT","INTL","STATUS" FROM ITINGNOTE
 ;
--------------------------------------------------------
--  DDL for View RVITINGNOTE_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITINGNOTE_H" ("NOTE_ID", "REVISION", "LANG_ID", "DESCRIPTION", "TEXT", "MAX_REV", "DATE_IMPORTED", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY") AS 
  SELECT "NOTE_ID","REVISION","LANG_ID","DESCRIPTION","TEXT","MAX_REV","DATE_IMPORTED","LAST_MODIFIED_ON","LAST_MODIFIED_BY" FROM ITINGNOTE_H
 ;
--------------------------------------------------------
--  DDL for View RVITINGREG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITINGREG" ("INGREDIENT", "REG_ID", "DESCRIPTION", "INTL") AS 
  SELECT "INGREDIENT","REG_ID","DESCRIPTION","INTL" FROM ITINGREG
 ;
--------------------------------------------------------
--  DDL for View RVITINGREG_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITINGREG_H" ("INGREDIENT", "REG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "DATE_IMPORTED", "ACTION", "INTL") AS 
  SELECT "INGREDIENT","REG_ID","DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","DATE_IMPORTED","ACTION","INTL" FROM ITINGREG_H
 ;
--------------------------------------------------------
--  DDL for View RVITITEMACCESS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITITEMACCESS" ("USER_GROUP_ID", "STATUS", "SPEC_TYPE", "SECTION_ID", "SUB_SECTION_ID", "ITEM_TYPE", "ITEM_ID", "ITEM_OWNER", "PROPERTY", "ATTRIBUTE", "ACCESS_LEVEL") AS 
  SELECT "USER_GROUP_ID","STATUS","SPEC_TYPE","SECTION_ID","SUB_SECTION_ID","ITEM_TYPE","ITEM_ID","ITEM_OWNER","PROPERTY","ATTRIBUTE","ACCESS_LEVEL" FROM ITITEMACCESS
 ;
--------------------------------------------------------
--  DDL for View RVITJOB
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITJOB" ("JOB", "START_DATE", "END_DATE", "JOB_ID") AS 
  SELECT "JOB","START_DATE","END_DATE","JOB_ID" FROM ITJOB
 ;
--------------------------------------------------------
--  DDL for View RVITJOBQ
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITJOBQ" ("USER_ID", "LOGDATE", "ERROR_MSG", "JOB_SEQ") AS 
  SELECT "USER_ID","LOGDATE","ERROR_MSG","JOB_SEQ" FROM ITJOBQ
 ;
--------------------------------------------------------
--  DDL for View RVITKW
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITKW" ("KW_ID", "DESCRIPTION", "KW_TYPE", "INTL", "STATUS", "KW_USAGE") AS 
  SELECT "KW_ID","DESCRIPTION","KW_TYPE","INTL","STATUS","KW_USAGE" FROM ITKW
 ;
--------------------------------------------------------
--  DDL for View RVITKW_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITKW_H" ("KW_ID", "REVISION", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "KW_TYPE", "KW_USAGE", "DATE_IMPORTED") AS 
  SELECT "KW_ID","REVISION","DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","KW_TYPE","KW_USAGE","DATE_IMPORTED" FROM ITKW_H
 ;
--------------------------------------------------------
--  DDL for View RVITKWAS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITKWAS" ("KW_ID", "CH_ID", "INTL") AS 
  SELECT "KW_ID","CH_ID","INTL" FROM ITKWAS
 ;
--------------------------------------------------------
--  DDL for View RVITKWAS_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITKWAS_H" ("KW_ID", "CH_ID", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "INTL", "ACTION") AS 
  SELECT "KW_ID","CH_ID","LAST_MODIFIED_ON","LAST_MODIFIED_BY","INTL","ACTION" FROM ITKWAS_H
 ;
--------------------------------------------------------
--  DDL for View RVITKWCH
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITKWCH" ("CH_ID", "DESCRIPTION", "INTL", "STATUS") AS 
  SELECT "CH_ID","DESCRIPTION","INTL","STATUS" FROM ITKWCH
 ;
--------------------------------------------------------
--  DDL for View RVITKWCH_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITKWCH_H" ("CH_ID", "REVISION", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "DATE_IMPORTED") AS 
  SELECT "CH_ID","REVISION","DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","DATE_IMPORTED" FROM ITKWCH_H
 ;
--------------------------------------------------------
--  DDL for View RVITKWFLT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITKWFLT" ("FILTER_ID", "KW_NO", "KW_ID", "KW_VALUE", "KW_VALUE_LIST", "KW_TYPE", "OPERATOR") AS 
  SELECT "FILTER_ID","KW_NO","KW_ID","KW_VALUE","KW_VALUE_LIST","KW_TYPE","OPERATOR" FROM ITKWFLT
 ;
--------------------------------------------------------
--  DDL for View RVITLABELLOGRESULTDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITLABELLOGRESULTDETAILS" ("LOG_ID", "SEQUENCE_NO", "PARENT_SEQUENCE_NO", "BOM_LEVEL", "INGREDIENT", "IS_IN_GROUP", "IS_IN_FUNCTION", "DESCRIPTION", "QUANTITY", "NOTE", "REC_FROM_ID", "REC_FROM_DESCRIPTION", "REC_WITH_ID", "REC_WITH_DESCRIPTION", "SHOW_REC", "ACTIVE_INGREDIENT", "QUID", "USE_PERC", "SHOW_ITEMS", "USE_PERC_REL", "USE_PERC_ABS", "USE_BRACKETS", "ALLERGEN", "SOI", "COMPLEX_LABEL_LOG_ID", "PARAGRAPH", "SORT_SEQUENCE_NO") AS 
  SELECT "LOG_ID","SEQUENCE_NO","PARENT_SEQUENCE_NO","BOM_LEVEL","INGREDIENT","IS_IN_GROUP","IS_IN_FUNCTION","DESCRIPTION","QUANTITY","NOTE","REC_FROM_ID","REC_FROM_DESCRIPTION","REC_WITH_ID","REC_WITH_DESCRIPTION","SHOW_REC","ACTIVE_INGREDIENT","QUID","USE_PERC","SHOW_ITEMS","USE_PERC_REL","USE_PERC_ABS","USE_BRACKETS","ALLERGEN","SOI","COMPLEX_LABEL_LOG_ID","PARAGRAPH","SORT_SEQUENCE_NO" FROM ITLABELLOGRESULTDETAILS
 ;
--------------------------------------------------------
--  DDL for View RVITLANG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITLANG" ("LANG_ID", "DESCRIPTION") AS 
  SELECT "LANG_ID","DESCRIPTION" FROM ITLANG
 ;
--------------------------------------------------------
--  DDL for View RVITLANGMAPPING
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITLANGMAPPING" ("EXT_LANG", "IS_LANG") AS 
  SELECT "EXT_LANG","IS_LANG" FROM ITLANGMAPPING
 ;
--------------------------------------------------------
--  DDL for View RVITLIMSCONFDT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITLIMSCONFDT" ("SEQ_NO", "LIMS_FIELD", "DESCRIPTION") AS 
  SELECT "SEQ_NO","LIMS_FIELD","DESCRIPTION" FROM ITLIMSCONFDT
 ;
--------------------------------------------------------
--  DDL for View RVITLIMSCONFKW
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITLIMSCONFKW" ("KW_ID", "UN_ID") AS 
  SELECT "KW_ID","UN_ID" FROM ITLIMSCONFKW
 ;
--------------------------------------------------------
--  DDL for View RVITLIMSCONFLY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITLIMSCONFLY" ("LAYOUT_ID", "LAYOUT_REV", "IS_COL", "PROPERTY", "UN_OBJECT", "UN_TYPE", "UN_ID") AS 
  SELECT "LAYOUT_ID","LAYOUT_REV","IS_COL","PROPERTY","UN_OBJECT","UN_TYPE","UN_ID" FROM ITLIMSCONFLY
 ;
--------------------------------------------------------
--  DDL for View RVITLIMSPLANT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITLIMSPLANT" ("PLANT", "CONNECT_STRING", "LANG_ID", "LANG_ID_4ID") AS 
  SELECT "PLANT","CONNECT_STRING","LANG_ID","LANG_ID_4ID" FROM ITLIMSPLANT
 ;
--------------------------------------------------------
--  DDL for View RVITLIMSPPKEY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITLIMSPPKEY" ("DB", "PP_KEY_SEQ", "PATH") AS 
  SELECT "DB","PP_KEY_SEQ","PATH" FROM ITLIMSPPKEY
 ;
--------------------------------------------------------
--  DDL for View RVITLIMSTMP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITLIMSTMP" ("EN_TP", "EN_ID", "LIMS_TMP") AS 
  SELECT "EN_TP","EN_ID","LIMS_TMP" FROM ITLIMSTMP
 ;
--------------------------------------------------------
--  DDL for View RVITMESSAGE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITMESSAGE" ("MSG_ID", "CULTURE_ID", "DESCRIPTION", "MESSAGE", "MSG_LEVEL", "MSG_COMMENT") AS 
  SELECT "MSG_ID","CULTURE_ID","DESCRIPTION","MESSAGE","MSG_LEVEL","MSG_COMMENT" FROM ITMESSAGE
 ;
--------------------------------------------------------
--  DDL for View RVITMFC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITMFC" ("MFC_ID", "DESCRIPTION", "STATUS", "INTL", "MTP_ID") AS 
  SELECT "MFC_ID","DESCRIPTION","STATUS","INTL","MTP_ID" FROM ITMFC
 ;
--------------------------------------------------------
--  DDL for View RVITMFC_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITMFC_H" ("MFC_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "DATE_IMPORTED") AS 
  SELECT "MFC_ID","DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","DATE_IMPORTED" FROM ITMFC_H
 ;
--------------------------------------------------------
--  DDL for View RVITMFCKW
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITMFCKW" ("MFC_ID", "KW_ID", "KW_VALUE", "INTL") AS 
  SELECT "MFC_ID","KW_ID","KW_VALUE","INTL" FROM ITMFCKW
 ;
--------------------------------------------------------
--  DDL for View RVITMFCMPL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITMFCMPL" ("MPL_ID", "MFC_ID", "INTL", "STATUS") AS 
  SELECT "MPL_ID","MFC_ID","INTL","STATUS" FROM ITMFCMPL
 ;
--------------------------------------------------------
--  DDL for View RVITMFCMPLKW
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITMFCMPLKW" ("MFC_ID", "MPL_ID", "KW_ID", "KW_VALUE", "INTL") AS 
  SELECT "MFC_ID","MPL_ID","KW_ID","KW_VALUE","INTL" FROM ITMFCMPLKW
 ;
--------------------------------------------------------
--  DDL for View RVITMPL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITMPL" ("MPL_ID", "DESCRIPTION", "STATUS", "INTL") AS 
  SELECT "MPL_ID","DESCRIPTION","STATUS","INTL" FROM ITMPL
 ;
--------------------------------------------------------
--  DDL for View RVITMTP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITMTP" ("MTP_ID", "DESCRIPTION", "STATUS", "INTL") AS 
  SELECT "MTP_ID","DESCRIPTION","STATUS","INTL" FROM ITMTP
 ;
--------------------------------------------------------
--  DDL for View RVITNUTFILTER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITNUTFILTER" ("ID", "NAME", "DESCRIPTION", "CREATED_ON") AS 
  SELECT "ID","NAME","DESCRIPTION","CREATED_ON" FROM ITNUTFILTER
 ;
--------------------------------------------------------
--  DDL for View RVITNUTFILTERDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITNUTFILTERDETAILS" ("ID", "SEQ", "PROPERTY_ID", "PROPERTY_REV", "ATTRIBUTE_ID", "ATTRIBUTE_REV", "VISIBLE") AS 
  SELECT "ID","SEQ","PROPERTY_ID","PROPERTY_REV","ATTRIBUTE_ID","ATTRIBUTE_REV","VISIBLE" FROM ITNUTFILTERDETAILS
 ;
--------------------------------------------------------
--  DDL for View RVITNUTLOGRESULT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITNUTLOGRESULT" ("LOG_ID", "COL_ID", "ROW_ID", "VALUE", "PROPERTY", "PROPERTY_REV", "ATTRIBUTE", "ATTRIBUTE_REV") AS 
  SELECT "LOG_ID","COL_ID","ROW_ID","VALUE","PROPERTY","PROPERTY_REV","ATTRIBUTE","ATTRIBUTE_REV" FROM ITNUTLOGRESULT
 ;
--------------------------------------------------------
--  DDL for View RVITNUTLY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITNUTLY" ("LAYOUT_ID", "DESCRIPTION", "INTL", "STATUS", "CREATED_BY", "CREATED_ON", "LAST_MODIFIED_BY", "LAST_MODIFIED_ON", "REVISION") AS 
  SELECT "LAYOUT_ID","DESCRIPTION","INTL","STATUS","CREATED_BY","CREATED_ON","LAST_MODIFIED_BY","LAST_MODIFIED_ON","REVISION" FROM ITNUTLY
 ;
--------------------------------------------------------
--  DDL for View RVITNUTLYITEM
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITNUTLYITEM" ("LAYOUT_ID", "REVISION", "SEQ_NO", "COL_TYPE", "HEADER_ID", "HEADER_REV", "DATA_TYPE", "CALC_SEQ", "CALC_METHOD", "MODIFIABLE", "LENGTH") AS 
  SELECT "LAYOUT_ID","REVISION","SEQ_NO","COL_TYPE","HEADER_ID","HEADER_REV","DATA_TYPE","CALC_SEQ","CALC_METHOD","MODIFIABLE","LENGTH" FROM ITNUTLYITEM
 ;
--------------------------------------------------------
--  DDL for View RVITNUTLYTYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITNUTLYTYPE" ("ID", "DESCRIPTION", "CUSTOM") AS 
  SELECT "ID","DESCRIPTION","CUSTOM" FROM ITNUTLYTYPE
 ;
--------------------------------------------------------
--  DDL for View RVITNUTREFTYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITNUTREFTYPE" ("REF_TYPE", "PART_NO", "NAME", "SECTION_ID", "SUB_SECTION_ID", "PROPERTY_GROUP", "VALUE_COL", "NOTE", "ROUND_SECTION_ID", "ROUND_SUB_SECTION_ID", "ROUND_PROPERTY_GROUP", "ROUND_VALUE_COL", "ROUND_RDA_COL", "ENERGY_SECTION_ID", "ENERGY_SUB_SECTION_ID", "ENERGY_PROPERTY_GROUP", "ENERGY_KCAL_PROPERTY", "ENERGY_KJ_PROPERTY", "ENERGY_KCAL_ATTRIBUTE", "ENERGY_KJ_ATTRIBUTE", "SERVING_SECTION_ID", "SERVING_SUB_SECTION_ID", "SERVING_PROPERTY_GROUP", "SERVING_VALUE_COL", "ENERGY_KCAL_COL", "ENERGY_KJ_COL", "BASIC_WEIGHT_PROPERTY_GROUP", "BASIC_WEIGHT_PROPERTY", "BASIC_WEIGHT_VALUE_COL") AS 
  SELECT "REF_TYPE","PART_NO","NAME","SECTION_ID","SUB_SECTION_ID","PROPERTY_GROUP","VALUE_COL","NOTE","ROUND_SECTION_ID","ROUND_SUB_SECTION_ID","ROUND_PROPERTY_GROUP","ROUND_VALUE_COL","ROUND_RDA_COL","ENERGY_SECTION_ID","ENERGY_SUB_SECTION_ID","ENERGY_PROPERTY_GROUP","ENERGY_KCAL_PROPERTY","ENERGY_KJ_PROPERTY","ENERGY_KCAL_ATTRIBUTE","ENERGY_KJ_ATTRIBUTE","SERVING_SECTION_ID","SERVING_SUB_SECTION_ID","SERVING_PROPERTY_GROUP","SERVING_VALUE_COL","ENERGY_KCAL_COL","ENERGY_KJ_COL","BASIC_WEIGHT_PROPERTY_GROUP","BASIC_WEIGHT_PROPERTY","BASIC_WEIGHT_VALUE_COL" FROM ITNUTREFTYPE
 ;
--------------------------------------------------------
--  DDL for View RVITNUTRESULT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITNUTRESULT" ("BOM_EXP_NO", "COL_ID", "NUM_VAL", "STR_VAL", "PROPERTY", "PROPERTY_REV", "ATTRIBUTE", "ATTRIBUTE_REV", "DATE_VAL", "BOOLEAN_VAL", "LAYOUT_ID", "LAYOUT_REVISION", "MOP_SEQUENCE_NO", "ROW_ID", "DISPLAY_NAME") AS 
  SELECT "BOM_EXP_NO","COL_ID","NUM_VAL","STR_VAL","PROPERTY","PROPERTY_REV","ATTRIBUTE","ATTRIBUTE_REV","DATE_VAL","BOOLEAN_VAL","LAYOUT_ID","LAYOUT_REVISION","MOP_SEQUENCE_NO","ROW_ID","DISPLAY_NAME" FROM ITNUTRESULT
 ;
--------------------------------------------------------
--  DDL for View RVITNUTRESULTDETAIL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITNUTRESULTDETAIL" ("BOM_EXP_NO", "MOP_SEQUENCE_NO", "ROW_ID", "COL_ID", "NUM_VAL", "STR_VAL", "DATE_VAL", "BOOLEAN_VAL", "PROPERTY", "PROPERTY_REV", "ATTRIBUTE", "ATTRIBUTE_REV", "LAYOUT_ID", "LAYOUT_REVISION", "DISPLAY_NAME", "PART_NO", "PART_REVISION", "CALC_QTY", "NOTE", "NOT_AVAILABLE") AS 
  SELECT "BOM_EXP_NO","MOP_SEQUENCE_NO","ROW_ID","COL_ID","NUM_VAL","STR_VAL","DATE_VAL","BOOLEAN_VAL","PROPERTY","PROPERTY_REV","ATTRIBUTE","ATTRIBUTE_REV","LAYOUT_ID","LAYOUT_REVISION","DISPLAY_NAME","PART_NO","PART_REVISION","CALC_QTY","NOTE","NOT_AVAILABLE" FROM ITNUTRESULTDETAIL
 ;
--------------------------------------------------------
--  DDL for View RVITNUTROUNDING
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITNUTROUNDING" ("CHARACTERISTIC_ID", "PROCEDURE_NAME") AS 
  SELECT "CHARACTERISTIC_ID","PROCEDURE_NAME" FROM ITNUTROUNDING
 ;
--------------------------------------------------------
--  DDL for View RVITOID
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITOID" ("OBJECT_ID", "REVISION", "OWNER", "STATUS", "CREATED_ON", "CREATED_BY", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "OBSOLESCENCE_DATE", "CURRENT_DATE", "OBJECT_WIDTH", "OBJECT_HEIGHT", "FILE_NAME", "FILE_SIZE", "VISUAL", "OLE_OBJECT", "FREE_OBJECT", "EXPORTED") AS 
  SELECT "OBJECT_ID","REVISION","OWNER","STATUS","CREATED_ON","CREATED_BY","LAST_MODIFIED_ON","LAST_MODIFIED_BY","OBSOLESCENCE_DATE","CURRENT_DATE","OBJECT_WIDTH","OBJECT_HEIGHT","FILE_NAME","FILE_SIZE","VISUAL","OLE_OBJECT","FREE_OBJECT","EXPORTED" FROM ITOID
 ;
--------------------------------------------------------
--  DDL for View RVITOIH
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITOIH" ("OBJECT_ID", "OWNER", "LANG_ID", "SORT_DESC", "DESCRIPTION", "OBJECT_IMPORTED", "ALLOW_PHANTOM", "INTL", "ES_SEQ_NO") AS 
  SELECT "OBJECT_ID","OWNER","LANG_ID","SORT_DESC","DESCRIPTION","OBJECT_IMPORTED","ALLOW_PHANTOM","INTL","ES_SEQ_NO" FROM ITOIH
 ;
--------------------------------------------------------
--  DDL for View RVITOIHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITOIHS" ("OBJECT_ID", "REVISION", "OWNER", "ES_SEQ_NO", "USER_ID", "FORENAME", "LAST_NAME", "TIMESTAMP", "SIGN_FOR_ID", "SIGN_FOR", "SIGN_WHAT_ID", "SIGN_WHAT") AS 
  SELECT "OBJECT_ID","REVISION","OWNER","ES_SEQ_NO","USER_ID","FORENAME","LAST_NAME","TIMESTAMP","SIGN_FOR_ID","SIGN_FOR","SIGN_WHAT_ID","SIGN_WHAT" FROM ITOIHS
 ;
--------------------------------------------------------
--  DDL for View RVITOIKW
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITOIKW" ("OBJECT_ID", "OWNER", "KW_ID", "KW_VALUE", "INTL") AS 
  SELECT "OBJECT_ID","OWNER","KW_ID","KW_VALUE","INTL" FROM ITOIKW
 ;
--------------------------------------------------------
--  DDL for View RVITOIRAW
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITOIRAW" ("OBJECT_ID", "REVISION", "OWNER", "DESKTOP_OBJECT") AS 
  SELECT "OBJECT_ID","REVISION","OWNER","DESKTOP_OBJECT" FROM ITOIRAW
 ;
--------------------------------------------------------
--  DDL for View RVITPFLT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITPFLT" ("FILTER_ID", "PART_NO", "DESCRIPTION", "PLANT", "BASE_UOM", "PART_SOURCE", "BASE_CONV_FACTOR", "BASE_TO_UNIT", "PART_TYPE", "DATE_IMPORTED", "OBSOLETE", "ALT_PART_NO", "PART_OBSOLETE") AS 
  SELECT "FILTER_ID","PART_NO","DESCRIPTION","PLANT","BASE_UOM","PART_SOURCE","BASE_CONV_FACTOR","BASE_TO_UNIT","PART_TYPE","DATE_IMPORTED","OBSOLETE","ALT_PART_NO","PART_OBSOLETE" FROM ITPFLT
 ;
--------------------------------------------------------
--  DDL for View RVITPFLTD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITPFLTD" ("FILTER_ID", "USER_ID", "DESCRIPTION", "SORT_DESC", "OPTIONS", "DEFAULT_FLT") AS 
  SELECT "FILTER_ID","USER_ID","DESCRIPTION","SORT_DESC","OPTIONS","DEFAULT_FLT" FROM ITPFLTD
 ;
--------------------------------------------------------
--  DDL for View RVITPFLTOP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITPFLTOP" ("FILTER_ID", "LOG_PART_NO", "LOG_DESCRIPTION", "LOG_PLANT", "LOG_BASE_UOM", "LOG_PART_SOURCE", "LOG_BASE_CONV_FACTOR", "LOG_BASE_TO_UNIT", "LOG_PART_TYPE", "LOG_DATE_IMPORTED", "LOG_OBSOLETE", "LOG_ALT_PART_NO", "LOG_PART_OBSOLETE") AS 
  SELECT "FILTER_ID","LOG_PART_NO","LOG_DESCRIPTION","LOG_PLANT","LOG_BASE_UOM","LOG_PART_SOURCE","LOG_BASE_CONV_FACTOR","LOG_BASE_TO_UNIT","LOG_PART_TYPE","LOG_DATE_IMPORTED","LOG_OBSOLETE","LOG_ALT_PART_NO","LOG_PART_OBSOLETE" FROM ITPFLTOP
 ;
--------------------------------------------------------
--  DDL for View RVITPLGRP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITPLGRP" ("PLANTGROUP", "DESCRIPTION") AS 
  SELECT "PLANTGROUP","DESCRIPTION" FROM ITPLGRP
 ;
--------------------------------------------------------
--  DDL for View RVITPLGRPLIST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITPLGRPLIST" ("PLANTGROUP", "PLANT") AS 
  SELECT "PLANTGROUP","PLANT" FROM ITPLGRPLIST
 ;
--------------------------------------------------------
--  DDL for View RVITPLKW
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITPLKW" ("PL_ID", "KW_ID", "KW_VALUE", "INTL") AS 
  SELECT "PL_ID","KW_ID","KW_VALUE","INTL" FROM ITPLKW
 ;
--------------------------------------------------------
--  DDL for View RVITPP_0
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITPP_0" ("PART_NO") AS 
  SELECT "PART_NO" FROM ITPP_0
 ;
--------------------------------------------------------
--  DDL for View RVITPP_DEV
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITPP_DEV" ("PART_NO") AS 
  SELECT "PART_NO" FROM ITPP_DEV
 ;
--------------------------------------------------------
--  DDL for View RVITPP_E
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITPP_E" ("PART_NO") AS 
  SELECT "PART_NO" FROM ITPP_E
 ;
--------------------------------------------------------
--  DDL for View RVITPP_ENS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITPP_ENS" ("PART_NO") AS 
  SELECT "PART_NO" FROM ITPP_ENS
 ;
--------------------------------------------------------
--  DDL for View RVITPP_K
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITPP_K" ("PART_NO") AS 
  SELECT "PART_NO" FROM ITPP_K
 ;
--------------------------------------------------------
--  DDL for View RVITPP_KIR
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITPP_KIR" ("PART_NO") AS 
  SELECT "PART_NO" FROM ITPP_KIR
 ;
--------------------------------------------------------
--  DDL for View RVITPP_MOS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITPP_MOS" ("PART_NO") AS 
  SELECT "PART_NO" FROM ITPP_MOS
 ;
--------------------------------------------------------
--  DDL for View RVITPP_SPCTRC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITPP_SPCTRC" ("PART_NO") AS 
  SELECT "PART_NO" FROM ITPP_SPCTRC
 ;
--------------------------------------------------------
--  DDL for View RVITPP_TCE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITPP_TCE" ("PART_NO") AS 
  SELECT "PART_NO" FROM ITPP_TCE
 ;
--------------------------------------------------------
--  DDL for View RVITPP_V1
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITPP_V1" ("PART_NO") AS 
  SELECT "PART_NO" FROM ITPP_V1
 ;
--------------------------------------------------------
--  DDL for View RVITPP_V2
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITPP_V2" ("PART_NO") AS 
  SELECT "PART_NO" FROM ITPP_V2
 ;
--------------------------------------------------------
--  DDL for View RVITPP_VOR
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITPP_VOR" ("PART_NO") AS 
  SELECT "PART_NO" FROM ITPP_VOR
 ;
--------------------------------------------------------
--  DDL for View RVITPP_Y
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITPP_Y" ("PART_NO") AS 
  SELECT "PART_NO" FROM ITPP_Y
 ;
--------------------------------------------------------
--  DDL for View RVITPRCL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITPRCL" ("PART_NO", "HIER_LEVEL", "MATL_CLASS_ID", "CODE", "TYPE") AS 
  SELECT "PART_NO","HIER_LEVEL","MATL_CLASS_ID","CODE","TYPE" FROM ITPRCL
 ;
--------------------------------------------------------
--  DDL for View RVITPRCL_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITPRCL_H" ("PART_NO", "HIER_LEVEL", "MATL_CLASS_ID", "CODE", "TYPE", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "FORENAME", "LAST_NAME") AS 
  SELECT "PART_NO","HIER_LEVEL","MATL_CLASS_ID","CODE","TYPE","LAST_MODIFIED_ON","LAST_MODIFIED_BY","FORENAME","LAST_NAME" FROM ITPRCL_H
 ;
--------------------------------------------------------
--  DDL for View RVITPRNOTE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITPRNOTE" ("PART_NO", "TEXT") AS 
  SELECT "PART_NO","TEXT" FROM ITPRNOTE
 ;
--------------------------------------------------------
--  DDL for View RVITPRNOTE_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITPRNOTE_H" ("PART_NO", "TEXT", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "FORENAME", "LAST_NAME") AS 
  SELECT "PART_NO","TEXT","LAST_MODIFIED_ON","LAST_MODIFIED_BY","FORENAME","LAST_NAME" FROM ITPRNOTE_H
 ;
--------------------------------------------------------
--  DDL for View RVITPRPL_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITPRPL_H" ("PART_NO", "ACTION", "OLD_PLANT", "NEW_PLANT", "OLD_ISSUE_UOM", "NEW_ISSUE_UOM", "OLD_ASSEMBLY_SCRAP", "NEW_ASSEMBLY_SCRAP", "OLD_COMPONENT_SCRAP", "NEW_COMPONENT_SCRAP", "OLD_LEAD_TIME_OFFSET", "NEW_LEAD_TIME_OFFSET", "OLD_RELEVENCY_TO_COSTING", "NEW_RELEVENCY_TO_COSTING", "OLD_BULK_MATERIAL", "NEW_BULK_MATERIAL", "OLD_ITEM_CATEGORY", "NEW_ITEM_CATEGORY", "OLD_ISSUE_LOCATION", "NEW_ISSUE_LOCATION", "OLD_DISCONTINUATION_INDICATOR", "NEW_DISCONTINUATION_INDICATOR", "OLD_DISCONTINUATION_DATE", "NEW_DISCONTINUATION_DATE", "OLD_FOLLOW_ON_MATERIAL", "NEW_FOLLOW_ON_MATERIAL", "OLD_COMMODITY_CODE", "NEW_COMMODITY_CODE", "OLD_OPERATIONAL_STEP", "NEW_OPERATIONAL_STEP", "OLD_OBSOLETE", "NEW_OBSOLETE", "OLD_PLANT_ACCESS", "NEW_PLANT_ACCESS", "TIMESTAMP", "USER_ID", "FORENAME", "LAST_NAME") AS 
  SELECT "PART_NO","ACTION","OLD_PLANT","NEW_PLANT","OLD_ISSUE_UOM","NEW_ISSUE_UOM","OLD_ASSEMBLY_SCRAP","NEW_ASSEMBLY_SCRAP","OLD_COMPONENT_SCRAP","NEW_COMPONENT_SCRAP","OLD_LEAD_TIME_OFFSET","NEW_LEAD_TIME_OFFSET","OLD_RELEVENCY_TO_COSTING","NEW_RELEVENCY_TO_COSTING","OLD_BULK_MATERIAL","NEW_BULK_MATERIAL","OLD_ITEM_CATEGORY","NEW_ITEM_CATEGORY","OLD_ISSUE_LOCATION","NEW_ISSUE_LOCATION","OLD_DISCONTINUATION_INDICATOR","NEW_DISCONTINUATION_INDICATOR","OLD_DISCONTINUATION_DATE","NEW_DISCONTINUATION_DATE","OLD_FOLLOW_ON_MATERIAL","NEW_FOLLOW_ON_MATERIAL","OLD_COMMODITY_CODE","NEW_COMMODITY_CODE","OLD_OPERATIONAL_STEP","NEW_OPERATIONAL_STEP","OLD_OBSOLETE","NEW_OBSOLETE","OLD_PLANT_ACCESS","NEW_PLANT_ACCESS","TIMESTAMP","USER_ID","FORENAME","LAST_NAME" FROM ITPRPL_H
 ;
--------------------------------------------------------
--  DDL for View RVITPRSOURCE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITPRSOURCE" ("SOURCE") AS 
  SELECT "SOURCE" FROM ITPRSOURCE
 ;
--------------------------------------------------------
--  DDL for View RVITQ
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITQ" ("USER_ID", "STATUS", "PROGRESS", "START_DATE", "END_DATE", "JOB_DESCR") AS 
  SELECT "USER_ID","STATUS","PROGRESS","START_DATE","END_DATE","JOB_DESCR" FROM ITQ
 ;
--------------------------------------------------------
--  DDL for View RVITRDSTATUS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITRDSTATUS" ("STATUS", "SORT_DESC", "DESCRIPTION", "STATUS_TYPE") AS 
  SELECT "STATUS","SORT_DESC","DESCRIPTION","STATUS_TYPE" FROM ITRDSTATUS
 ;
--------------------------------------------------------
--  DDL for View RVITREPAC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITREPAC" ("REP_ID", "USER_GROUP_ID", "USER_ID", "ACCESS_TYPE") AS 
  SELECT "REP_ID","USER_GROUP_ID","USER_ID","ACCESS_TYPE" FROM ITREPAC
 ;
--------------------------------------------------------
--  DDL for View RVITREPARG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITREPARG" ("REP_ID", "REP_TYPE", "REP_ARG1", "REP_DT_1", "REP_ARG2", "REP_DT_2", "REP_ARG3", "REP_DT_3", "REP_ARG4", "REP_DT_4") AS 
  SELECT "REP_ID","REP_TYPE","REP_ARG1","REP_DT_1","REP_ARG2","REP_DT_2","REP_ARG3","REP_DT_3","REP_ARG4","REP_DT_4" FROM ITREPARG
 ;
--------------------------------------------------------
--  DDL for View RVITREPD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITREPD" ("REP_ID", "SORT_DESC", "DESCRIPTION", "INFO", "STATUS", "REP_TYPE", "BATCH_ALLOWED", "WEB_ALLOWED", "ADDON_ID", "TITLE", "CONFIDENTIAL_TEXT", "CS_ALLOWED", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY") AS 
  SELECT "REP_ID","SORT_DESC","DESCRIPTION","INFO","STATUS","REP_TYPE","BATCH_ALLOWED","WEB_ALLOWED","ADDON_ID","TITLE","CONFIDENTIAL_TEXT","CS_ALLOWED","LAST_MODIFIED_ON","LAST_MODIFIED_BY" FROM ITREPD
 ;
--------------------------------------------------------
--  DDL for View RVITREPDATA
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITREPDATA" ("REP_ID", "NREP_TYPE", "REF_ID", "REF_VER", "REF_OWNER", "INCLUDE", "SEQ", "HEADER", "HEADER_DESCR", "DISPLAY_FORMAT", "DISPLAY_FORMAT_REV", "INCL_OBJ") AS 
  SELECT "REP_ID","NREP_TYPE","REF_ID","REF_VER","REF_OWNER","INCLUDE","SEQ","HEADER","HEADER_DESCR","DISPLAY_FORMAT","DISPLAY_FORMAT_REV","INCL_OBJ" FROM ITREPDATA
 ;
--------------------------------------------------------
--  DDL for View RVITREPG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITREPG" ("REPG_ID", "DESCRIPTION") AS 
  SELECT "REPG_ID","DESCRIPTION" FROM ITREPG
 ;
--------------------------------------------------------
--  DDL for View RVITREPGHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITREPGHS" ("REPG_ID", "AUDIT_TRAIL_SEQ_NO", "USER_ID", "FORENAME", "LAST_NAME", "TIMESTAMP", "WHAT_ID", "WHAT") AS 
  SELECT "REPG_ID","AUDIT_TRAIL_SEQ_NO","USER_ID","FORENAME","LAST_NAME","TIMESTAMP","WHAT_ID","WHAT" FROM ITREPGHS
 ;
--------------------------------------------------------
--  DDL for View RVITREPGHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITREPGHSDETAILS" ("REPG_ID", "AUDIT_TRAIL_SEQ_NO", "SEQ_NO", "DETAILS") AS 
  SELECT "REPG_ID","AUDIT_TRAIL_SEQ_NO","SEQ_NO","DETAILS" FROM ITREPGHSDETAILS
 ;
--------------------------------------------------------
--  DDL for View RVITREPHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITREPHS" ("REP_ID", "AUDIT_TRAIL_SEQ_NO", "USER_ID", "FORENAME", "LAST_NAME", "TIMESTAMP", "WHAT_ID", "WHAT") AS 
  SELECT "REP_ID","AUDIT_TRAIL_SEQ_NO","USER_ID","FORENAME","LAST_NAME","TIMESTAMP","WHAT_ID","WHAT" FROM ITREPHS
 ;
--------------------------------------------------------
--  DDL for View RVITREPHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITREPHSDETAILS" ("REP_ID", "AUDIT_TRAIL_SEQ_NO", "SEQ_NO", "DETAILS") AS 
  SELECT "REP_ID","AUDIT_TRAIL_SEQ_NO","SEQ_NO","DETAILS" FROM ITREPHSDETAILS
 ;
--------------------------------------------------------
--  DDL for View RVITREPITEMS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITREPITEMS" ("REP_ID", "TYPE", "TEMPL_ID", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY") AS 
  SELECT "REP_ID","TYPE","TEMPL_ID","LAST_MODIFIED_ON","LAST_MODIFIED_BY" FROM ITREPITEMS
 ;
--------------------------------------------------------
--  DDL for View RVITREPITEMTYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITREPITEMTYPE" ("TYPE", "DESCRIPTION", "STANDARD", "DEFAULT_TEMPL_ID", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY") AS 
  SELECT "TYPE","DESCRIPTION","STANDARD","DEFAULT_TEMPL_ID","LAST_MODIFIED_ON","LAST_MODIFIED_BY" FROM ITREPITEMTYPE
 ;
--------------------------------------------------------
--  DDL for View RVITREPL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITREPL" ("REPG_ID", "REP_ID") AS 
  SELECT "REPG_ID","REP_ID" FROM ITREPL
 ;
--------------------------------------------------------
--  DDL for View RVITREPNSTDEF
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITREPNSTDEF" ("REP_ID", "NREP_TYPE", "NREP_D", "NREP_R", "NREP_L", "NREP_HL", "NREP_D_LANG", "NREP_L_LANG", "REMARKS") AS 
  SELECT "REP_ID","NREP_TYPE","NREP_D","NREP_R","NREP_L","NREP_HL","NREP_D_LANG","NREP_L_LANG","REMARKS" FROM ITREPNSTDEF
 ;
--------------------------------------------------------
--  DDL for View RVITREPRQARG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITREPRQARG" ("REQ_ID", "ARG", "ARG_VAL") AS 
  SELECT "REQ_ID","ARG","ARG_VAL" FROM ITREPRQARG
 ;
--------------------------------------------------------
--  DDL for View RVITREPSQL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITREPSQL" ("REP_ID", "SORT_DESC", "REP_SQL1", "REP_SQL2", "REP_SQL3") AS 
  SELECT "REP_ID","SORT_DESC","REP_SQL1","REP_SQL2","REP_SQL3" FROM ITREPSQL
 ;
--------------------------------------------------------
--  DDL for View RVITREPTEMPLATE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITREPTEMPLATE" ("TEMPL_ID", "TYPE", "DESCRIPTION", "PDF", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY") AS 
  SELECT "TEMPL_ID","TYPE","DESCRIPTION","PDF","LAST_MODIFIED_ON","LAST_MODIFIED_BY" FROM ITREPTEMPLATE;
--------------------------------------------------------
--  DDL for View RVITREPTYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITREPTYPE" ("REP_TYPE", "SORT_DESC", "DESCRIPTION") AS 
  SELECT "REP_TYPE","SORT_DESC","DESCRIPTION" FROM ITREPTYPE
 ;
--------------------------------------------------------
--  DDL for View RVITRTHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITRTHS" ("REF_TEXT_TYPE", "TEXT_REVISION", "OWNER", "ES_SEQ_NO", "USER_ID", "FORENAME", "LAST_NAME", "TIMESTAMP", "SIGN_FOR_ID", "SIGN_FOR", "SIGN_WHAT_ID", "SIGN_WHAT") AS 
  SELECT "REF_TEXT_TYPE","TEXT_REVISION","OWNER","ES_SEQ_NO","USER_ID","FORENAME","LAST_NAME","TIMESTAMP","SIGN_FOR_ID","SIGN_FOR","SIGN_WHAT_ID","SIGN_WHAT" FROM ITRTHS
 ;
--------------------------------------------------------
--  DDL for View RVITRULESET
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITRULESET" ("RULE_ID", "NAME", "DESCRIPTION", "CREATED_ON", "RULE_TYPE", "RULESET") AS 
  SELECT "RULE_ID","NAME","DESCRIPTION","CREATED_ON","RULE_TYPE","RULESET" FROM ITRULESET
 ;
--------------------------------------------------------
--  DDL for View RVITRULETYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITRULETYPE" ("RULE_TYPE", "DESCRIPTION") AS 
  SELECT "RULE_TYPE","DESCRIPTION" FROM ITRULETYPE
 ;
--------------------------------------------------------
--  DDL for View RVITSAPPLRANGE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITSAPPLRANGE" ("LOGIC_IND", "FSFIX", "ID", "PLANTGROUP") AS 
  SELECT "LOGIC_IND","FSFIX","ID","PLANTGROUP" FROM ITSAPPLRANGE
 ;
--------------------------------------------------------
--  DDL for View RVITSAPPLRANGE_SS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITSAPPLRANGE_SS" ("RANGEID", "STATUS", "BS", "BU") AS 
  SELECT "RANGEID","STATUS","BS","BU" FROM ITSAPPLRANGE_SS
 ;
--------------------------------------------------------
--  DDL for View RVITSH_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITSH_H" ("PART_NO", "LAST_MODIFIED_ON") AS 
  SELECT "PART_NO","LAST_MODIFIED_ON" FROM ITSH_H
 ;
--------------------------------------------------------
--  DDL for View RVITSHCMP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITSHCMP" ("COMP_NO", "SECTION_ID", "SUB_SECTION_ID", "TYPE", "REF_ID", "REF_VER", "REF_OWNER", "REF_INFO", "REF_VER2", "REF_OWNER2", "PROPERTY_GROUP", "PROPERTY", "ATTRIBUTE", "HEADER", "PROPERTY_VALUE", "PROPERTY_VALUE2", "UOM_ID", "UOM_ID2", "TEST_METHOD", "TEST_METHOD2", "INTL", "SEQUENCE_NO", "COMP_REF", "COMP_RESULT", "PLANT", "LINE", "LINE_REV", "CONFIGURATION", "PROCESS_LINE_REV") AS 
  SELECT "COMP_NO","SECTION_ID","SUB_SECTION_ID","TYPE","REF_ID","REF_VER","REF_OWNER","REF_INFO","REF_VER2","REF_OWNER2","PROPERTY_GROUP","PROPERTY","ATTRIBUTE","HEADER","PROPERTY_VALUE","PROPERTY_VALUE2","UOM_ID","UOM_ID2","TEST_METHOD","TEST_METHOD2","INTL","SEQUENCE_NO","COMP_REF","COMP_RESULT","PLANT","LINE","LINE_REV","CONFIGURATION","PROCESS_LINE_REV" FROM ITSHCMP
 ;
--------------------------------------------------------
--  DDL for View RVITSHFLTD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITSHFLTD" ("FILTER_ID", "USER_ID", "DESCRIPTION", "SORT_DESC", "OPTIONS", "DEFAULT_FLT") AS 
  SELECT "FILTER_ID","USER_ID","DESCRIPTION","SORT_DESC","OPTIONS","DEFAULT_FLT" FROM ITSHFLTD
 ;
--------------------------------------------------------
--  DDL for View RVITSHFLTOP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITSHFLTOP" ("FILTER_ID", "LOG_PART_NO", "LOG_REVISION", "LOG_STATUS", "LOG_DESCRIPTION", "LOG_PHASE_IN_DATE", "LOG_PLANNED_EFFECTIVE_DATE", "LOG_CRITICAL_EFFECTIVE_DATE", "LOG_ISSUED_DATE", "LOG_OBSOLESCENCE_DATE", "LOG_CHANGED_DATE", "LOG_BOM_CHANGED", "LOG_STATUS_CHANGE_DATE", "LOG_PHASE_IN_TOLERANCE", "LOG_CREATED_BY", "LOG_CREATED_ON", "LOG_LAST_MODIFIED_BY", "LOG_LAST_MODIFIED_ON", "LOG_FRAME_ID", "LOG_FRAME_REV", "LOG_ACCESS_GROUP", "LOG_WORKFLOW_GROUP_ID", "LOG_CLASS1_ID", "LOG_CLASS2_ID", "LOG_CLASS3_ID", "LOG_OWNER", "LOG_INT_FRAME_NO", "LOG_INT_FRAME_REV", "LOG_INT_PART_NO", "LOG_INT_PART_REV", "LOG_FRAME_OWNER", "LOG_INTL", "LOG_MULTILANG", "LOG_PLANT", "LOG_STATUS_TYPE", "LOG_SPEC_TYPE_GROUP", "LOG_ALT_PART_NO", "LOG_PED_IN_SYNC", "LOG_LANG_DESCR", "LOG_LANG_ID") AS 
  SELECT "FILTER_ID","LOG_PART_NO","LOG_REVISION","LOG_STATUS","LOG_DESCRIPTION","LOG_PHASE_IN_DATE","LOG_PLANNED_EFFECTIVE_DATE","LOG_CRITICAL_EFFECTIVE_DATE","LOG_ISSUED_DATE","LOG_OBSOLESCENCE_DATE","LOG_CHANGED_DATE","LOG_BOM_CHANGED","LOG_STATUS_CHANGE_DATE","LOG_PHASE_IN_TOLERANCE","LOG_CREATED_BY","LOG_CREATED_ON","LOG_LAST_MODIFIED_BY","LOG_LAST_MODIFIED_ON","LOG_FRAME_ID","LOG_FRAME_REV","LOG_ACCESS_GROUP","LOG_WORKFLOW_GROUP_ID","LOG_CLASS1_ID","LOG_CLASS2_ID","LOG_CLASS3_ID","LOG_OWNER","LOG_INT_FRAME_NO","LOG_INT_FRAME_REV","LOG_INT_PART_NO","LOG_INT_PART_REV","LOG_FRAME_OWNER","LOG_INTL","LOG_MULTILANG","LOG_PLANT","LOG_STATUS_TYPE","LOG_SPEC_TYPE_GROUP","LOG_ALT_PART_NO","LOG_PED_IN_SYNC","LOG_LANG_DESCR","LOG_LANG_ID" FROM ITSHFLTOP
 ;
--------------------------------------------------------
--  DDL for View RVITSHLY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITSHLY" ("LY_ID", "LY_TYPE", "DISPLAY_FORMAT") AS 
  SELECT "LY_ID","LY_TYPE","DISPLAY_FORMAT" FROM ITSHLY
 ;
--------------------------------------------------------
--  DDL for View RVITSPFLT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITSPFLT" ("FILTER_ID", "PG", "SP", "ATT", "TM", "UM", "HDR", "PGSP", "OPERATOR", "VALUE1", "VALUE2", "DT") AS 
  SELECT "FILTER_ID","PG","SP","ATT","TM","UM","HDR","PGSP","OPERATOR","VALUE1","VALUE2","DT" FROM ITSPFLT
 ;
--------------------------------------------------------
--  DDL for View RVITSPFLTD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITSPFLTD" ("FILTER_ID", "USER_ID", "DESCRIPTION", "SORT_DESC", "OPTIONS", "DEFAULT_FLT") AS 
  SELECT "FILTER_ID","USER_ID","DESCRIPTION","SORT_DESC","OPTIONS","DEFAULT_FLT" FROM ITSPFLTD
 ;
--------------------------------------------------------
--  DDL for View RVITSSCF
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITSSCF" ("WORKFLOW_GROUP_ID", "CF_ID", "STATUS_TYPE", "S_FROM", "S_TO", "ALLOW_MODIFY") AS 
  SELECT "WORKFLOW_GROUP_ID","CF_ID","STATUS_TYPE","S_FROM","S_TO","ALLOW_MODIFY" FROM ITSSCF
 ;
--------------------------------------------------------
--  DDL for View RVITSSHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITSSHS" ("STATUS", "AUDIT_TRAIL_SEQ_NO", "USER_ID", "FORENAME", "LAST_NAME", "TIMESTAMP", "WHAT_ID", "WHAT") AS 
  SELECT "STATUS","AUDIT_TRAIL_SEQ_NO","USER_ID","FORENAME","LAST_NAME","TIMESTAMP","WHAT_ID","WHAT" FROM ITSSHS
 ;
--------------------------------------------------------
--  DDL for View RVITSSHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITSSHSDETAILS" ("STATUS", "AUDIT_TRAIL_SEQ_NO", "SEQ_NO", "DETAILS") AS 
  SELECT "STATUS","AUDIT_TRAIL_SEQ_NO","SEQ_NO","DETAILS" FROM ITSSHSDETAILS
 ;
--------------------------------------------------------
--  DDL for View RVITSTGRP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITSTGRP" ("GROUP_DESCR", "STATUS", "INTL") AS 
  SELECT "GROUP_DESCR","STATUS","INTL" FROM ITSTGRP
 ;
--------------------------------------------------------
--  DDL for View RVITTMTYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITTMTYPE" ("TM_TYPE", "DESCRIPTION", "INTL", "STATUS") AS 
  SELECT "TM_TYPE","DESCRIPTION","INTL","STATUS" FROM ITTMTYPE
 ;
--------------------------------------------------------
--  DDL for View RVITUGHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITUGHS" ("USER_GROUP_ID", "AUDIT_TRAIL_SEQ_NO", "USER_ID", "FORENAME", "LAST_NAME", "TIMESTAMP", "WHAT_ID", "WHAT") AS 
  SELECT "USER_GROUP_ID","AUDIT_TRAIL_SEQ_NO","USER_ID","FORENAME","LAST_NAME","TIMESTAMP","WHAT_ID","WHAT" FROM ITUGHS
 ;
--------------------------------------------------------
--  DDL for View RVITUGHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITUGHSDETAILS" ("USER_GROUP_ID", "AUDIT_TRAIL_SEQ_NO", "SEQ_NO", "DETAILS") AS 
  SELECT "USER_GROUP_ID","AUDIT_TRAIL_SEQ_NO","SEQ_NO","DETAILS" FROM ITUGHSDETAILS
 ;
--------------------------------------------------------
--  DDL for View RVITUMC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITUMC" ("UOM_ID", "UOM_ALT_ID", "CONV_FACTOR", "INTL", "STATUS", "CONV_FCT") AS 
  SELECT "UOM_ID","UOM_ALT_ID","CONV_FACTOR","INTL","STATUS","CONV_FCT" FROM ITUMC
 ;
--------------------------------------------------------
--  DDL for View RVITUMC_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITUMC_H" ("UOM_ID", "UOM_ALT_ID", "CONV_FACTOR", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "INTL", "ACTION") AS 
  SELECT "UOM_ID","UOM_ALT_ID","CONV_FACTOR","LAST_MODIFIED_ON","LAST_MODIFIED_BY","INTL","ACTION" FROM ITUMC_H
 ;
--------------------------------------------------------
--  DDL for View RVITUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITUP" ("USER_ID", "PLANT") AS 
  SELECT "USER_ID","PLANT" FROM ITUP
 ;
--------------------------------------------------------
--  DDL for View RVITUS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITUS" ("USER_ID", "FORENAME", "LAST_NAME", "CREATED_ON", "DELETED_ON") AS 
  SELECT "USER_ID","FORENAME","LAST_NAME","CREATED_ON","DELETED_ON" FROM ITUS
 ;
--------------------------------------------------------
--  DDL for View RVITUSCAT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITUSCAT" ("CAT_ID", "DESCRIPTION", "STATUS") AS 
  SELECT "CAT_ID","DESCRIPTION","STATUS" FROM ITUSCAT
 ;
--------------------------------------------------------
--  DDL for View RVITUSHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITUSHS" ("USER_ID_CHANGED", "AUDIT_TRAIL_SEQ_NO", "USER_ID", "FORENAME", "LAST_NAME", "TIMESTAMP", "WHAT_ID", "WHAT") AS 
  SELECT "USER_ID_CHANGED","AUDIT_TRAIL_SEQ_NO","USER_ID","FORENAME","LAST_NAME","TIMESTAMP","WHAT_ID","WHAT" FROM ITUSHS
 ;
--------------------------------------------------------
--  DDL for View RVITUSHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITUSHSDETAILS" ("USER_ID_CHANGED", "AUDIT_TRAIL_SEQ_NO", "SEQ_NO", "DETAILS") AS 
  SELECT "USER_ID_CHANGED","AUDIT_TRAIL_SEQ_NO","SEQ_NO","DETAILS" FROM ITUSHSDETAILS
 ;
--------------------------------------------------------
--  DDL for View RVITUSLOC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITUSLOC" ("LOC_ID", "DESCRIPTION", "STATUS") AS 
  SELECT "LOC_ID","DESCRIPTION","STATUS" FROM ITUSLOC
 ;
--------------------------------------------------------
--  DDL for View RVITUSPREF
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITUSPREF" ("USER_ID", "SECTION_NAME", "PREF", "VALUE") AS 
  SELECT "USER_ID","SECTION_NAME","PREF","VALUE" FROM ITUSPREF
 ;
--------------------------------------------------------
--  DDL for View RVITUSPREFDEF
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITUSPREFDEF" ("SECTION_NAME", "PREF", "VALUE") AS 
  SELECT "SECTION_NAME","PREF","VALUE" FROM ITUSPREFDEF
 ;
--------------------------------------------------------
--  DDL for View RVITVERSIONINFO
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITVERSIONINFO" ("TYPE", "ID", "INSTALLED_ON", "DESCRIPTION") AS 
  SELECT "TYPE","ID","INSTALLED_ON","DESCRIPTION" FROM ITVERSIONINFO
 ;
--------------------------------------------------------
--  DDL for View RVITWGHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITWGHS" ("WORKFLOW_GROUP_ID", "AUDIT_TRAIL_SEQ_NO", "USER_ID", "FORENAME", "LAST_NAME", "TIMESTAMP", "WHAT_ID", "WHAT") AS 
  SELECT "WORKFLOW_GROUP_ID","AUDIT_TRAIL_SEQ_NO","USER_ID","FORENAME","LAST_NAME","TIMESTAMP","WHAT_ID","WHAT" FROM ITWGHS
 ;
--------------------------------------------------------
--  DDL for View RVITWGHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITWGHSDETAILS" ("WORKFLOW_GROUP_ID", "AUDIT_TRAIL_SEQ_NO", "SEQ_NO", "DETAILS") AS 
  SELECT "WORKFLOW_GROUP_ID","AUDIT_TRAIL_SEQ_NO","SEQ_NO","DETAILS" FROM ITWGHSDETAILS
 ;
--------------------------------------------------------
--  DDL for View RVITWTHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITWTHS" ("WORK_FLOW_ID", "AUDIT_TRAIL_SEQ_NO", "USER_ID", "FORENAME", "LAST_NAME", "TIMESTAMP", "WHAT_ID", "WHAT") AS 
  SELECT "WORK_FLOW_ID","AUDIT_TRAIL_SEQ_NO","USER_ID","FORENAME","LAST_NAME","TIMESTAMP","WHAT_ID","WHAT" FROM ITWTHS
 ;
--------------------------------------------------------
--  DDL for View RVITWTHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITWTHSDETAILS" ("WORK_FLOW_ID", "AUDIT_TRAIL_SEQ_NO", "SEQ_NO", "DETAILS") AS 
  SELECT "WORK_FLOW_ID","AUDIT_TRAIL_SEQ_NO","SEQ_NO","DETAILS" FROM ITWTHSDETAILS
 ;
--------------------------------------------------------
--  DDL for View RVLANGUAGES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVLANGUAGES" ("LANGUAGE") AS 
  SELECT "LANGUAGE" FROM LANGUAGES
 ;
--------------------------------------------------------
--  DDL for View RVLAYOUT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVLAYOUT" ("LAYOUT_ID", "DESCRIPTION", "INTL", "STATUS", "CREATED_BY", "CREATED_ON", "LAST_MODIFIED_BY", "LAST_MODIFIED_ON", "REVISION", "DATE_IMPORTED") AS 
  SELECT "LAYOUT_ID","DESCRIPTION","INTL","STATUS","CREATED_BY","CREATED_ON","LAST_MODIFIED_BY","LAST_MODIFIED_ON","REVISION","DATE_IMPORTED" FROM LAYOUT
 ;
--------------------------------------------------------
--  DDL for View RVLAYOUT_VALIDATION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVLAYOUT_VALIDATION" ("LAYOUT_ID", "FUNCTION_ID", "ARG1", "ARG2", "ARG3", "ARG4", "ARG5", "ARG6", "ARG7", "ARG8", "ARG9", "ARG10", "INTL", "REVISION") AS 
  SELECT "LAYOUT_ID","FUNCTION_ID","ARG1","ARG2","ARG3","ARG4","ARG5","ARG6","ARG7","ARG8","ARG9","ARG10","INTL","REVISION" FROM LAYOUT_VALIDATION
 ;
--------------------------------------------------------
--  DDL for View RVLIMITED
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVLIMITED" ("TABLE_NAME", "COL_SELECT", "COL_INSERT", "COL_UPDATE", "COL_DELETE") AS 
  SELECT "TABLE_NAME","COL_SELECT","COL_INSERT","COL_UPDATE","COL_DELETE" FROM LIMITED
 ;
--------------------------------------------------------
--  DDL for View RVLOCATION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVLOCATION" ("PLANT", "LOCATION", "DESCRIPTION") AS 
  SELECT "PLANT","LOCATION","DESCRIPTION" FROM LOCATION
 ;
--------------------------------------------------------
--  DDL for View RVLTCUSTOMCALCULATION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVLTCUSTOMCALCULATION" ("CUSTOMCALCULATION_ID", "CUSTOMCALCULATION_GUID", "DESCRIPTION", "PLUGINURL", "CLASSNAME", "INTL", "STATUS", "VALIDATIONFUNCTION") AS 
  SELECT 0 AS CUSTOMCALCULATION_ID, 0 AS CUSTOMCALCULATION_GUID, 'NO R&'||'D LIBRARY INSTALLED' AS DESCRIPTION, 'NO R&'||'D LIBRARY INSTALLED' AS PLUGINURL, 'NO R&'||'D LIBRARY INSTALLED' AS CLASSNAME, 'N' AS INTL, 0 AS STATUS, 'NO R&'||'D LIBRARY INSTALLED' AS VALIDATIONFUNCTION FROM DUAL
 ;
--------------------------------------------------------
--  DDL for View RVLTCUSTOMCALCULATION_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVLTCUSTOMCALCULATION_H" ("CUSTOMCALCULATION_ID", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV") AS 
  SELECT 0 AS CUSTOMCALCULATION_ID, 0 AS REVISION, 1 AS LANG_ID, 'NO R&'||'D LIBRARY INSTALLED' AS DESCRIPTION, SYSDATE AS LAST_MODIFIED_ON, USER AS LAST_MODIFIED_BY, 0 AS MAX_REV FROM DUAL
 ;
--------------------------------------------------------
--  DDL for View RVLTCUSTOMCALCULATIONVALUES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVLTCUSTOMCALCULATIONVALUES" ("CUSTOMCALCULATION_ID", "VALUEDESCRIPTION", "SECTION_ID", "SUB_SECTION_ID", "PROPERTY_GROUP", "PROPERTY", "ATTRIBUTE", "VALUE") AS 
  SELECT 0 AS CUSTOMCALCULATION_ID, 'NO R&'||'D LIBRARY INSTALLED' AS VALUEDESCRIPTION, 0 AS SECTION_ID, 0 AS SUB_SECTION_ID, 0 AS PROPERTY_GROUP, 0 AS PROPERTY, 0 AS ATTRIBUTE, 'NO R&'||'D LIBRARY INSTALLED' AS VALUE FROM DUAL
 ;
--------------------------------------------------------
--  DDL for View RVLTFOOTNOTE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVLTFOOTNOTE" ("FOOTNOTE_ID", "PANEL_ID", "TEXT") AS 
  SELECT 0 AS FOOTNOTE_ID, 0 AS PANEL_ID, 'NO R&'||'D LIBRARY INSTALLED' AS TEXT FROM DUAL
 ;
--------------------------------------------------------
--  DDL for View RVLTFUNCTION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVLTFUNCTION" ("FUNCTION_ID", "DESCRIPTION") AS 
  SELECT 0 AS FUNCTION_ID, 'NO R&'||'D LIBRARY INSTALLED' AS DESCRIPTION FROM DUAL
 ;
--------------------------------------------------------
--  DDL for View RVLTNUTCONFIG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVLTNUTCONFIG" ("REF_TYPE", "FUNCTION_ID", "VALUE") AS 
  SELECT 'NO R&'||'D LIBRARY INSTALLED' AS REF_TYPE, 0 AS FUNCTION_ID, 'NO R&'||'D LIBRARY INSTALLED' AS VALUE FROM DUAL
 ;
--------------------------------------------------------
--  DDL for View RVLTNUTPROFILELOG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVLTNUTPROFILELOG" ("LOG_ID_FROM", "LOG_ID_TO") AS 
  SELECT 0 AS LOG_ID_FROM, 0 AS LOG_ID_TO FROM DUAL
 ;
--------------------------------------------------------
--  DDL for View RVLTNUTPROPERTYCONFIG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVLTNUTPROPERTYCONFIG" ("REF_TYPE", "FUNCTION_ID", "PROPETY_ID", "ATTRIBUTE_ID") AS 
  SELECT 'NO R&'||'D LIBRARY INSTALLED' AS REF_TYPE, 0 AS FUNCTION_ID, 0 AS PROPETY_ID, 0 AS ATTRIBUTE_ID FROM DUAL
 ;
--------------------------------------------------------
--  DDL for View RVMATERIAL_CLASS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVMATERIAL_CLASS" ("IDENTIFIER", "CODE", "LICENSE", "SHORT_NAME", "LONG_NAME", "DESCRIPTION", "CREATION_DATETIME", "MODIFICATION_DATETIME", "DELETION_DATETIME") AS 
  SELECT "IDENTIFIER","CODE","LICENSE","SHORT_NAME","LONG_NAME","DESCRIPTION","CREATION_DATETIME","MODIFICATION_DATETIME","DELETION_DATETIME" FROM MATERIAL_CLASS
 ;
--------------------------------------------------------
--  DDL for View RVMATERIAL_CLASS_B
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVMATERIAL_CLASS_B" ("IDENTIFIER", "LANG_ID", "BUBBLE", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY") AS 
  SELECT "IDENTIFIER","LANG_ID","BUBBLE","LAST_MODIFIED_ON","LAST_MODIFIED_BY" FROM MATERIAL_CLASS_B
 ;
--------------------------------------------------------
--  DDL for View RVMRP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVMRP" ("TABLE_NAME", "COL_SELECT", "COL_INSERT", "COL_UPDATE", "COL_DELETE") AS 
  SELECT "TABLE_NAME","COL_SELECT","COL_INSERT","COL_UPDATE","COL_DELETE" FROM MRP
 ;
--------------------------------------------------------
--  DDL for View RVPART
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVPART" ("PART_NO", "DESCRIPTION", "BASE_UOM", "PART_SOURCE", "BASE_CONV_FACTOR", "BASE_TO_UNIT", "PART_TYPE", "DATE_IMPORTED", "CHANGED_DATE", "ALT_PART_NO", "OBSOLETE") AS 
  SELECT "PART_NO","DESCRIPTION","BASE_UOM","PART_SOURCE","BASE_CONV_FACTOR","BASE_TO_UNIT","PART_TYPE","DATE_IMPORTED","CHANGED_DATE","ALT_PART_NO","OBSOLETE" FROM PART
 ;
--------------------------------------------------------
--  DDL for View RVPART_COST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVPART_COST" ("PART_NO", "PERIOD", "CURRENCY", "PRICE", "PRICE_TYPE", "UOM", "PLANT") AS 
  SELECT "PART_NO","PERIOD","CURRENCY", iapiRM.CheckPriceAccess("PRICE"),"PRICE_TYPE","UOM","PLANT" FROM PART_COST
 ;
--------------------------------------------------------
--  DDL for View RVPART_L
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVPART_L" ("PART_NO", "LANG_ID", "DESCRIPTION") AS 
  SELECT "PART_NO","LANG_ID","DESCRIPTION" FROM PART_L
 ;
--------------------------------------------------------
--  DDL for View RVPART_LOCATION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVPART_LOCATION" ("PART_NO", "PLANT", "LOCATION") AS 
  SELECT "PART_NO","PLANT","LOCATION" FROM PART_LOCATION
 ;
--------------------------------------------------------
--  DDL for View RVPART_PLANT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVPART_PLANT" ("PART_NO", "PLANT", "ISSUE_UOM", "ASSEMBLY_SCRAP", "COMPONENT_SCRAP", "LEAD_TIME_OFFSET", "RELEVENCY_TO_COSTING", "BULK_MATERIAL", "ITEM_CATEGORY", "ISSUE_LOCATION", "DISCONTINUATION_INDICATOR", "DISCONTINUATION_DATE", "FOLLOW_ON_MATERIAL", "COMMODITY_CODE", "OPERATIONAL_STEP", "OBSOLETE", "PLANT_ACCESS") AS 
  SELECT "PART_NO","PLANT","ISSUE_UOM","ASSEMBLY_SCRAP","COMPONENT_SCRAP","LEAD_TIME_OFFSET","RELEVENCY_TO_COSTING","BULK_MATERIAL","ITEM_CATEGORY","ISSUE_LOCATION","DISCONTINUATION_INDICATOR","DISCONTINUATION_DATE","FOLLOW_ON_MATERIAL","COMMODITY_CODE","OPERATIONAL_STEP","OBSOLETE","PLANT_ACCESS" FROM PART_PLANT
 ;
--------------------------------------------------------
--  DDL for View RVPED_GROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVPED_GROUP" ("PED_GROUP_ID", "DESCRIPTION", "PED", "PIT", "ACCESS_GROUP") AS 
  SELECT "PED_GROUP_ID","DESCRIPTION","PED","PIT","ACCESS_GROUP" FROM PED_GROUP
 ;
--------------------------------------------------------
--  DDL for View RVPLANT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVPLANT" ("PLANT", "DESCRIPTION", "PLANT_SOURCE") AS 
  SELECT "PLANT","DESCRIPTION","PLANT_SOURCE" FROM PLANT
 ;
--------------------------------------------------------
--  DDL for View RVPRICE_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVPRICE_TYPE" ("PRICE_TYPE", "PERIOD") AS 
  SELECT "PRICE_TYPE","PERIOD" FROM PRICE_TYPE
 ;
--------------------------------------------------------
--  DDL for View RVPROPERTY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVPROPERTY" ("PROPERTY", "DESCRIPTION", "INTL", "STATUS") AS 
  SELECT "PROPERTY","DESCRIPTION","INTL","STATUS" FROM PROPERTY
 ;
--------------------------------------------------------
--  DDL for View RVPROPERTY_ASSOCIATION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVPROPERTY_ASSOCIATION" ("PROPERTY", "ASSOCIATION", "INTL") AS 
  SELECT "PROPERTY","ASSOCIATION","INTL" FROM PROPERTY_ASSOCIATION
 ;
--------------------------------------------------------
--  DDL for View RVPROPERTY_ASSOCIATION_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVPROPERTY_ASSOCIATION_H" ("PROPERTY", "ASSOCIATION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "INTL", "ACTION") AS 
  SELECT "PROPERTY","ASSOCIATION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","INTL","ACTION" FROM PROPERTY_ASSOCIATION_H
 ;
--------------------------------------------------------
--  DDL for View RVPROPERTY_B
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVPROPERTY_B" ("PROPERTY", "REVISION", "LANG_ID", "BUBBLE", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY") AS 
  SELECT "PROPERTY","REVISION","LANG_ID","BUBBLE","LAST_MODIFIED_ON","LAST_MODIFIED_BY" FROM PROPERTY_B
 ;
--------------------------------------------------------
--  DDL for View RVPROPERTY_DISPLAY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVPROPERTY_DISPLAY" ("PROPERTY", "DISPLAY_FORMAT", "INTL") AS 
  SELECT "PROPERTY","DISPLAY_FORMAT","INTL" FROM PROPERTY_DISPLAY
 ;
--------------------------------------------------------
--  DDL for View RVPROPERTY_DISPLAY_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVPROPERTY_DISPLAY_H" ("PROPERTY", "DISPLAY_FORMAT", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "INTL", "ACTION") AS 
  SELECT "PROPERTY","DISPLAY_FORMAT","LAST_MODIFIED_ON","LAST_MODIFIED_BY","INTL","ACTION" FROM PROPERTY_DISPLAY_H
 ;
--------------------------------------------------------
--  DDL for View RVPROPERTY_GROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVPROPERTY_GROUP" ("PROPERTY_GROUP", "DESCRIPTION", "DISPLAY_FORMAT", "INTL", "STATUS", "PG_TYPE") AS 
  SELECT "PROPERTY_GROUP","DESCRIPTION","DISPLAY_FORMAT","INTL","STATUS","PG_TYPE" FROM PROPERTY_GROUP
 ;
--------------------------------------------------------
--  DDL for View RVPROPERTY_GROUP_B
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVPROPERTY_GROUP_B" ("PROPERTY_GROUP", "REVISION", "LANG_ID", "BUBBLE", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY") AS 
  SELECT "PROPERTY_GROUP","REVISION","LANG_ID","BUBBLE","LAST_MODIFIED_ON","LAST_MODIFIED_BY" FROM PROPERTY_GROUP_B
 ;
--------------------------------------------------------
--  DDL for View RVPROPERTY_GROUP_DISPLAY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVPROPERTY_GROUP_DISPLAY" ("PROPERTY_GROUP", "DISPLAY_FORMAT", "INTL") AS 
  SELECT "PROPERTY_GROUP","DISPLAY_FORMAT","INTL" FROM PROPERTY_GROUP_DISPLAY
 ;
--------------------------------------------------------
--  DDL for View RVPROPERTY_GROUP_DISPLAY_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVPROPERTY_GROUP_DISPLAY_H" ("PROPERTY_GROUP", "DISPLAY_FORMAT", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "INTL", "ACTION") AS 
  SELECT "PROPERTY_GROUP","DISPLAY_FORMAT","LAST_MODIFIED_ON","LAST_MODIFIED_BY","INTL","ACTION" FROM PROPERTY_GROUP_DISPLAY_H
 ;
--------------------------------------------------------
--  DDL for View RVPROPERTY_GROUP_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVPROPERTY_GROUP_H" ("PROPERTY_GROUP", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "PG_TYPE", "DATE_IMPORTED", "ES_SEQ_NO") AS 
  SELECT "PROPERTY_GROUP","REVISION","LANG_ID","DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","MAX_REV","PG_TYPE","DATE_IMPORTED","ES_SEQ_NO" FROM PROPERTY_GROUP_H
 ;
--------------------------------------------------------
--  DDL for View RVPROPERTY_GROUP_LIST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVPROPERTY_GROUP_LIST" ("PROPERTY_GROUP", "PROPERTY", "MANDATORY", "INTL") AS 
  SELECT "PROPERTY_GROUP","PROPERTY","MANDATORY","INTL" FROM PROPERTY_GROUP_LIST
 ;
--------------------------------------------------------
--  DDL for View RVPROPERTY_GROUP_LIST_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVPROPERTY_GROUP_LIST_H" ("PROPERTY_GROUP", "PROPERTY", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "INTL", "MANDATORY", "ACTION") AS 
  SELECT "PROPERTY_GROUP","PROPERTY","LAST_MODIFIED_ON","LAST_MODIFIED_BY","INTL","MANDATORY","ACTION" FROM PROPERTY_GROUP_LIST_H
 ;
--------------------------------------------------------
--  DDL for View RVPROPERTY_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVPROPERTY_H" ("PROPERTY", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED", "ES_SEQ_NO") AS 
  SELECT "PROPERTY","REVISION","LANG_ID","DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","MAX_REV","DATE_IMPORTED","ES_SEQ_NO" FROM PROPERTY_H
 ;
--------------------------------------------------------
--  DDL for View RVPROPERTY_LAYOUT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVPROPERTY_LAYOUT" ("LAYOUT_ID", "HEADER_ID", "FIELD_ID", "INCLUDED", "START_POS", "LENGTH", "ALIGNMENT", "FORMAT_ID", "HEADER", "COLOR", "BOLD", "UNDERLINE", "INTL", "REVISION", "HEADER_REV", "DEF") AS 
  SELECT "LAYOUT_ID","HEADER_ID","FIELD_ID","INCLUDED","START_POS","LENGTH","ALIGNMENT","FORMAT_ID","HEADER","COLOR","BOLD","UNDERLINE","INTL","REVISION","HEADER_REV","DEF" FROM PROPERTY_LAYOUT
 ;
--------------------------------------------------------
--  DDL for View RVPROPERTY_TEST_METHOD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVPROPERTY_TEST_METHOD" ("TEST_METHOD", "PROPERTY", "INTL") AS 
  SELECT "TEST_METHOD","PROPERTY","INTL" FROM PROPERTY_TEST_METHOD
 ;
--------------------------------------------------------
--  DDL for View RVPROPERTY_TEST_METHOD_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVPROPERTY_TEST_METHOD_H" ("PROPERTY", "TEST_METHOD", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "INTL", "ACTION") AS 
  SELECT "PROPERTY","TEST_METHOD","LAST_MODIFIED_ON","LAST_MODIFIED_BY","INTL","ACTION" FROM PROPERTY_TEST_METHOD_H
 ;
--------------------------------------------------------
--  DDL for View RVREF_TEXT_KW
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVREF_TEXT_KW" ("REF_TEXT_TYPE", "KW_ID", "KW_VALUE", "INTL", "OWNER") AS 
  SELECT "REF_TEXT_TYPE","KW_ID","KW_VALUE","INTL","OWNER" FROM REF_TEXT_KW
 ;
--------------------------------------------------------
--  DDL for View RVREF_TEXT_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVREF_TEXT_TYPE" ("REF_TEXT_TYPE", "DESCRIPTION", "INTL", "ALLOW_PHANTOM", "LAST_MODIFIED_ON", "OWNER", "LANG_ID", "SORT_DESC", "ES_SEQ_NO") AS 
  SELECT "REF_TEXT_TYPE","DESCRIPTION","INTL","ALLOW_PHANTOM","LAST_MODIFIED_ON","OWNER","LANG_ID","SORT_DESC","ES_SEQ_NO" FROM REF_TEXT_TYPE
 ;
--------------------------------------------------------
--  DDL for View RVREFERENCE_TEXT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVREFERENCE_TEXT" ("REF_TEXT_TYPE", "TEXT_REVISION", "TEXT", "CREATED_BY", "CREATED_ON", "LAST_EDITED_BY", "LAST_EDITED_ON_FIELDS", "STATUS", "LAST_MODIFIED_ON", "OWNER", "EXPORTED", "LANG_ID", "OBSOLESCENCE_DATE", "CURRENT_DATE") AS 
  SELECT "REF_TEXT_TYPE","TEXT_REVISION","TEXT","CREATED_BY","CREATED_ON","LAST_EDITED_BY","LAST_EDITED_ON_FIELDS","STATUS","LAST_MODIFIED_ON","OWNER","EXPORTED","LANG_ID","OBSOLESCENCE_DATE","CURRENT_DATE" FROM REFERENCE_TEXT
 ;
--------------------------------------------------------
--  DDL for View RVSECTION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVSECTION" ("SECTION_ID", "DESCRIPTION", "INTL", "STATUS") AS 
  SELECT "SECTION_ID","DESCRIPTION","INTL","STATUS" FROM SECTION
 ;
--------------------------------------------------------
--  DDL for View RVSECTION_B
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVSECTION_B" ("SECTION_ID", "REVISION", "LANG_ID", "BUBBLE", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY") AS 
  SELECT "SECTION_ID","REVISION","LANG_ID","BUBBLE","LAST_MODIFIED_ON","LAST_MODIFIED_BY" FROM SECTION_B
 ;
--------------------------------------------------------
--  DDL for View RVSECTION_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVSECTION_H" ("SECTION_ID", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED", "ES_SEQ_NO") AS 
  SELECT "SECTION_ID","REVISION","LANG_ID","DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","MAX_REV","DATE_IMPORTED","ES_SEQ_NO" FROM SECTION_H
 ;
--------------------------------------------------------
--  DDL for View RVSPEC_ACCESS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVSPEC_ACCESS" ("USER_ID", "ACCESS_GROUP", "MRP_UPDATE", "PLAN_ACCESS", "PROD_ACCESS", "PHASE_ACCESS") AS 
  SELECT "USER_ID","ACCESS_GROUP","MRP_UPDATE","PLAN_ACCESS","PROD_ACCESS","PHASE_ACCESS" FROM SPEC_ACCESS
 ;
--------------------------------------------------------
--  DDL for View RVSPEC_PREFIX
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVSPEC_PREFIX" ("OWNER", "PREFIX", "DESTINATION", "WORKFLOW_GROUP_ID", "ACCESS_GROUP", "IMPORT_ALLOWED") AS 
  SELECT "OWNER","PREFIX","DESTINATION","WORKFLOW_GROUP_ID","ACCESS_GROUP","IMPORT_ALLOWED" FROM SPEC_PREFIX
 ;
--------------------------------------------------------
--  DDL for View RVSPEC_PREFIX_ACCESS_GROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVSPEC_PREFIX_ACCESS_GROUP" ("PREFIX", "ACCESS_GROUP") AS 
  SELECT "PREFIX","ACCESS_GROUP" FROM SPEC_PREFIX_ACCESS_GROUP
 ;
--------------------------------------------------------
--  DDL for View RVSPEC_PREFIX_DESCR
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVSPEC_PREFIX_DESCR" ("OWNER", "PREFIX", "DESCRIPTION", "PREFIX_TYPE") AS 
  SELECT "OWNER","PREFIX","DESCRIPTION","PREFIX_TYPE" FROM SPEC_PREFIX_DESCR
 ;
--------------------------------------------------------
--  DDL for View RVSPECDATA
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVSPECDATA" ("PART_NO", "REVISION", "SECTION_ID", "SUB_SECTION_ID", "SEQUENCE_NO", "TYPE", "REF_ID", "REF_VER", "PROPERTY_GROUP", "PROPERTY", "ATTRIBUTE", "HEADER_ID", "VALUE", "VALUE_S", "UOM_ID", "TEST_METHOD", "CHARACTERISTIC", "ASSOCIATION", "REF_INFO", "INTL", "VALUE_TYPE", "VALUE_DT", "SECTION_REV", "SUB_SECTION_REV", "PROPERTY_GROUP_REV", "PROPERTY_REV", "ATTRIBUTE_REV", "UOM_REV", "TEST_METHOD_REV", "CHARACTERISTIC_REV", "ASSOCIATION_REV", "HEADER_REV", "REF_OWNER", "LANG_ID") AS 
  SELECT "PART_NO","REVISION","SECTION_ID","SUB_SECTION_ID","SEQUENCE_NO","TYPE","REF_ID","REF_VER","PROPERTY_GROUP","PROPERTY","ATTRIBUTE","HEADER_ID","VALUE","VALUE_S","UOM_ID","TEST_METHOD","CHARACTERISTIC","ASSOCIATION","REF_INFO","INTL","VALUE_TYPE","VALUE_DT","SECTION_REV","SUB_SECTION_REV","PROPERTY_GROUP_REV","PROPERTY_REV","ATTRIBUTE_REV","UOM_REV","TEST_METHOD_REV","CHARACTERISTIC_REV","ASSOCIATION_REV","HEADER_REV","REF_OWNER","LANG_ID" FROM SPECDATA
 ;
--------------------------------------------------------
--  DDL for View RVSPECIFICATION_KW
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVSPECIFICATION_KW" ("PART_NO", "KW_ID", "KW_VALUE", "INTL") AS 
  SELECT "PART_NO","KW_ID","KW_VALUE","INTL" FROM SPECIFICATION_KW
 ;
--------------------------------------------------------
--  DDL for View RVSPECIFICATION_KW_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVSPECIFICATION_KW_H" ("PART_NO", "KW_ID", "KW_VALUE", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "ACTION", "FORENAME", "LAST_NAME") AS 
  SELECT "PART_NO","KW_ID","KW_VALUE","LAST_MODIFIED_ON","LAST_MODIFIED_BY","ACTION","FORENAME","LAST_NAME" FROM SPECIFICATION_KW_H
 ;
--------------------------------------------------------
--  DDL for View RVSPECIFICATION_SECTION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVSPECIFICATION_SECTION" ("PART_NO", "REVISION", "SECTION_ID", "SUB_SECTION_ID", "TYPE", "REF_ID", "REF_VER", "REF_INFO", "SEQUENCE_NO", "HEADER", "MANDATORY", "SECTION_SEQUENCE_NO", "DISPLAY_FORMAT", "ASSOCIATION", "INTL", "SECTION_REV", "SUB_SECTION_REV", "DISPLAY_FORMAT_REV", "REF_OWNER") AS 
  SELECT "PART_NO","REVISION","SECTION_ID","SUB_SECTION_ID","TYPE","REF_ID","REF_VER","REF_INFO","SEQUENCE_NO","HEADER","MANDATORY","SECTION_SEQUENCE_NO","DISPLAY_FORMAT","ASSOCIATION","INTL","SECTION_REV","SUB_SECTION_REV","DISPLAY_FORMAT_REV","REF_OWNER" FROM SPECIFICATION_SECTION
 ;
--------------------------------------------------------
--  DDL for View RVSTAGE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVSTAGE" ("STAGE", "DESCRIPTION", "DISPLAY_FORMAT", "INTL", "STATUS") AS 
  SELECT "STAGE","DESCRIPTION","DISPLAY_FORMAT","INTL","STATUS" FROM STAGE
 ;
--------------------------------------------------------
--  DDL for View RVSTAGE_DISPLAY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVSTAGE_DISPLAY" ("STAGE", "DISPLAY_FORMAT", "INTL") AS 
  SELECT "STAGE","DISPLAY_FORMAT","INTL" FROM STAGE_DISPLAY
 ;
--------------------------------------------------------
--  DDL for View RVSTAGE_DISPLAY_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVSTAGE_DISPLAY_H" ("STAGE", "DISPLAY_FORMAT", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "INTL", "ACTION") AS 
  SELECT "STAGE","DISPLAY_FORMAT","LAST_MODIFIED_ON","LAST_MODIFIED_BY","INTL","ACTION" FROM STAGE_DISPLAY_H
 ;
--------------------------------------------------------
--  DDL for View RVSTAGE_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVSTAGE_H" ("STAGE", "REVISION", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY") AS 
  SELECT "STAGE","REVISION","DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY" FROM STAGE_H
 ;
--------------------------------------------------------
--  DDL for View RVSTAGE_LIST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVSTAGE_LIST" ("STAGE", "PROPERTY", "MANDATORY", "INTL", "UOM_ID", "ASSOCIATION") AS 
  SELECT "STAGE","PROPERTY","MANDATORY","INTL","UOM_ID","ASSOCIATION" FROM STAGE_LIST
 ;
--------------------------------------------------------
--  DDL for View RVSTAGE_LIST_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVSTAGE_LIST_H" ("STAGE", "PROPERTY", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "INTL", "MANDATORY", "ACTION", "UOM_ID", "ASSOCIATION") AS 
  SELECT "STAGE","PROPERTY","LAST_MODIFIED_ON","LAST_MODIFIED_BY","INTL","MANDATORY","ACTION","UOM_ID","ASSOCIATION" FROM STAGE_LIST_H
 ;
--------------------------------------------------------
--  DDL for View RVSTATUS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVSTATUS" ("STATUS", "SORT_DESC", "DESCRIPTION", "STATUS_TYPE", "PHASE_IN_STATUS", "EMAIL_TITLE", "PROMPT_FOR_REASON", "REASON_MANDATORY", "ES") AS 
  SELECT "STATUS","SORT_DESC","DESCRIPTION","STATUS_TYPE","PHASE_IN_STATUS","EMAIL_TITLE","PROMPT_FOR_REASON","REASON_MANDATORY","ES" FROM STATUS
 ;
--------------------------------------------------------
--  DDL for View RVSUB_SECTION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVSUB_SECTION" ("SUB_SECTION_ID", "DESCRIPTION", "INTL", "STATUS") AS 
  SELECT "SUB_SECTION_ID","DESCRIPTION","INTL","STATUS" FROM SUB_SECTION
 ;
--------------------------------------------------------
--  DDL for View RVSUB_SECTION_B
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVSUB_SECTION_B" ("SUB_SECTION_ID", "REVISION", "LANG_ID", "BUBBLE", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY") AS 
  SELECT "SUB_SECTION_ID","REVISION","LANG_ID","BUBBLE","LAST_MODIFIED_ON","LAST_MODIFIED_BY" FROM SUB_SECTION_B
 ;
--------------------------------------------------------
--  DDL for View RVSUB_SECTION_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVSUB_SECTION_H" ("SUB_SECTION_ID", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED", "ES_SEQ_NO") AS 
  SELECT "SUB_SECTION_ID","REVISION","LANG_ID","DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","MAX_REV","DATE_IMPORTED","ES_SEQ_NO" FROM SUB_SECTION_H
 ;
--------------------------------------------------------
--  DDL for View RVTEST_METHOD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVTEST_METHOD" ("TEST_METHOD", "DESCRIPTION", "INTL", "STATUS", "LONG_DESCR") AS 
  SELECT "TEST_METHOD","DESCRIPTION","INTL","STATUS","LONG_DESCR" FROM TEST_METHOD
 ;
--------------------------------------------------------
--  DDL for View RVTEST_METHOD_CONDITION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVTEST_METHOD_CONDITION" ("TEST_METHOD", "SET_NO", "CONDITION", "INTL") AS 
  SELECT "TEST_METHOD","SET_NO","CONDITION","INTL" FROM TEST_METHOD_CONDITION
 ;
--------------------------------------------------------
--  DDL for View RVTEST_METHOD_CONDITION_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVTEST_METHOD_CONDITION_H" ("TEST_METHOD", "SET_NO", "CONDITION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "INTL", "ACTION") AS 
  SELECT "TEST_METHOD","SET_NO","CONDITION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","INTL","ACTION" FROM TEST_METHOD_CONDITION_H
 ;
--------------------------------------------------------
--  DDL for View RVTEST_METHOD_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVTEST_METHOD_H" ("TEST_METHOD", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED", "LONG_DESCR", "ES_SEQ_NO") AS 
  SELECT "TEST_METHOD","REVISION","LANG_ID","DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","MAX_REV","DATE_IMPORTED","LONG_DESCR","ES_SEQ_NO" FROM TEST_METHOD_H
 ;
--------------------------------------------------------
--  DDL for View RVTEXT_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVTEXT_TYPE" ("TEXT_TYPE", "DESCRIPTION", "PROCESS_FLAG", "INTL", "STATUS") AS 
  SELECT "TEXT_TYPE","DESCRIPTION","PROCESS_FLAG","INTL","STATUS" FROM TEXT_TYPE
 ;
--------------------------------------------------------
--  DDL for View RVTEXT_TYPE_B
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVTEXT_TYPE_B" ("TEXT_TYPE", "REVISION", "LANG_ID", "BUBBLE", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY") AS 
  SELECT "TEXT_TYPE","REVISION","LANG_ID","BUBBLE","LAST_MODIFIED_ON","LAST_MODIFIED_BY" FROM TEXT_TYPE_B
 ;
--------------------------------------------------------
--  DDL for View RVTEXT_TYPE_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVTEXT_TYPE_H" ("TEXT_TYPE", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED", "ES_SEQ_NO") AS 
  SELECT "TEXT_TYPE","REVISION","LANG_ID","DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","MAX_REV","DATE_IMPORTED","ES_SEQ_NO" FROM TEXT_TYPE_H
 ;
--------------------------------------------------------
--  DDL for View RVTOAD_PLAN_TABLE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVTOAD_PLAN_TABLE" ("STATEMENT_ID", "PLAN_ID", "TIMESTAMP", "REMARKS", "OPERATION", "OPTIONS", "OBJECT_NODE", "OBJECT_OWNER", "OBJECT_NAME", "OBJECT_ALIAS", "OBJECT_INSTANCE", "OBJECT_TYPE", "OPTIMIZER", "SEARCH_COLUMNS", "ID", "PARENT_ID", "DEPTH", "POSITION", "COST", "CARDINALITY", "BYTES", "OTHER_TAG", "PARTITION_START", "PARTITION_STOP", "PARTITION_ID", "OTHER", "DISTRIBUTION", "CPU_COST", "IO_COST", "TEMP_SPACE", "ACCESS_PREDICATES", "FILTER_PREDICATES", "PROJECTION", "TIME", "QBLOCK_NAME", "OTHER_XML") AS 
  SELECT "STATEMENT_ID","PLAN_ID","TIMESTAMP","REMARKS","OPERATION","OPTIONS","OBJECT_NODE","OBJECT_OWNER","OBJECT_NAME","OBJECT_ALIAS","OBJECT_INSTANCE","OBJECT_TYPE","OPTIMIZER","SEARCH_COLUMNS","ID","PARENT_ID","DEPTH","POSITION","COST","CARDINALITY","BYTES","OTHER_TAG","PARTITION_START","PARTITION_STOP","PARTITION_ID","OTHER","DISTRIBUTION","CPU_COST","IO_COST","TEMP_SPACE","ACCESS_PREDICATES","FILTER_PREDICATES","PROJECTION","TIME","QBLOCK_NAME","OTHER_XML" FROM TOAD_PLAN_TABLE
 ;
--------------------------------------------------------
--  DDL for View RVUOM
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVUOM" ("UOM_ID", "DESCRIPTION", "INTL", "STATUS") AS 
  SELECT "UOM_ID","DESCRIPTION","INTL","STATUS" FROM UOM
 ;
--------------------------------------------------------
--  DDL for View RVUOM_ASSOCIATION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVUOM_ASSOCIATION" ("ASSOCIATION", "UOM", "LOWER_REJECT", "UPPER_REJECT", "INTL") AS 
  SELECT "ASSOCIATION","UOM","LOWER_REJECT","UPPER_REJECT","INTL" FROM UOM_ASSOCIATION
 ;
--------------------------------------------------------
--  DDL for View RVUOM_ASSOCIATION_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVUOM_ASSOCIATION_H" ("ASSOCIATION", "UOM", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "LOWER_REJECT", "UPPER_REJECT", "INTL", "ACTION") AS 
  SELECT "ASSOCIATION","UOM","LAST_MODIFIED_ON","LAST_MODIFIED_BY","LOWER_REJECT","UPPER_REJECT","INTL","ACTION" FROM UOM_ASSOCIATION_H
 ;
--------------------------------------------------------
--  DDL for View RVUOM_B
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVUOM_B" ("UOM_ID", "REVISION", "LANG_ID", "BUBBLE", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY") AS 
  SELECT "UOM_ID","REVISION","LANG_ID","BUBBLE","LAST_MODIFIED_ON","LAST_MODIFIED_BY" FROM UOM_B
 ;
--------------------------------------------------------
--  DDL for View RVUOM_H
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVUOM_H" ("UOM_ID", "REVISION", "LANG_ID", "DESCRIPTION", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY", "MAX_REV", "DATE_IMPORTED", "ES_SEQ_NO") AS 
  SELECT "UOM_ID","REVISION","LANG_ID","DESCRIPTION","LAST_MODIFIED_ON","LAST_MODIFIED_BY","MAX_REV","DATE_IMPORTED","ES_SEQ_NO" FROM UOM_H
 ;
--------------------------------------------------------
--  DDL for View RVUPDATE_HISTORY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVUPDATE_HISTORY" ("TABLE_NAME", "LAST_UPDATE") AS 
  SELECT "TABLE_NAME","LAST_UPDATE" FROM UPDATE_HISTORY
 ;
--------------------------------------------------------
--  DDL for View RVUSER_ACCESS_GROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVUSER_ACCESS_GROUP" ("ACCESS_GROUP", "USER_GROUP_ID", "UPDATE_ALLOWED", "MRP_UPDATE") AS 
  SELECT "ACCESS_GROUP","USER_GROUP_ID","UPDATE_ALLOWED","MRP_UPDATE" FROM USER_ACCESS_GROUP
 ;
--------------------------------------------------------
--  DDL for View RVUSER_GROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVUSER_GROUP" ("USER_GROUP_ID", "DESCRIPTION", "SHORT_DESC") AS 
  SELECT "USER_GROUP_ID","DESCRIPTION","SHORT_DESC" FROM USER_GROUP
 ;
--------------------------------------------------------
--  DDL for View RVUSER_GROUP_LIST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVUSER_GROUP_LIST" ("USER_GROUP_ID", "USER_ID") AS 
  SELECT "USER_GROUP_ID","USER_ID" FROM USER_GROUP_LIST
 ;
--------------------------------------------------------
--  DDL for View RVUSER_WORKFLOW_GROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVUSER_WORKFLOW_GROUP" ("WORKFLOW_GROUP_ID", "USER_GROUP_ID") AS 
  SELECT "WORKFLOW_GROUP_ID","USER_GROUP_ID" FROM USER_WORKFLOW_GROUP
 ;
--------------------------------------------------------
--  DDL for View RVVIEW_ONLY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVVIEW_ONLY" ("TABLE_NAME", "COL_SELECT", "COL_INSERT", "COL_UPDATE", "COL_DELETE") AS 
  SELECT "TABLE_NAME","COL_SELECT","COL_INSERT","COL_UPDATE","COL_DELETE" FROM VIEW_ONLY
 ;
--------------------------------------------------------
--  DDL for View RVVIEW_ONLY_BCK
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVVIEW_ONLY_BCK" ("TABLE_NAME", "COL_SELECT", "COL_INSERT", "COL_UPDATE", "COL_DELETE") AS 
  SELECT "TABLE_NAME","COL_SELECT","COL_INSERT","COL_UPDATE","COL_DELETE" FROM VIEW_ONLY_BCK
 ;
--------------------------------------------------------
--  DDL for View RVWORK_FLOW
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVWORK_FLOW" ("WORK_FLOW_ID", "STATUS", "NEXT_STATUS", "EXPORT_ERP") AS 
  SELECT "WORK_FLOW_ID","STATUS","NEXT_STATUS","EXPORT_ERP" FROM WORK_FLOW
 ;
--------------------------------------------------------
--  DDL for View RVWORK_FLOW_GROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVWORK_FLOW_GROUP" ("WORK_FLOW_ID", "DESCRIPTION", "INITIAL_STATUS") AS 
  SELECT "WORK_FLOW_ID","DESCRIPTION","INITIAL_STATUS" FROM WORK_FLOW_GROUP
 ;
--------------------------------------------------------
--  DDL for View RVWORK_FLOW_LIST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVWORK_FLOW_LIST" ("WORKFLOW_GROUP_ID", "STATUS", "USER_GROUP_ID", "ALL_TO_APPROVE", "SEND_MAIL", "EFF_DATE_MAIL") AS 
  SELECT "WORKFLOW_GROUP_ID","STATUS","USER_GROUP_ID","ALL_TO_APPROVE","SEND_MAIL","EFF_DATE_MAIL" FROM WORK_FLOW_LIST
 ;
--------------------------------------------------------
--  DDL for View RVWORKFLOW_GROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVWORKFLOW_GROUP" ("WORKFLOW_GROUP_ID", "SORT_DESC", "DESCRIPTION", "WORK_FLOW_ID") AS 
  SELECT "WORKFLOW_GROUP_ID","SORT_DESC","DESCRIPTION","WORK_FLOW_ID" FROM WORKFLOW_GROUP
 ;
--------------------------------------------------------
--  DDL for View WF_SPECIFICATION_HEADER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."WF_SPECIFICATION_HEADER" ("PART_NO", "REVISION", "STATUS", "DESCRIPTION", "PLANNED_EFFECTIVE_DATE", "ISSUED_DATE", "OBSOLESCENCE_DATE", "STATUS_CHANGE_DATE", "PHASE_IN_TOLERANCE", "CREATED_BY", "CREATED_ON", "LAST_MODIFIED_BY", "LAST_MODIFIED_ON", "FRAME_ID", "FRAME_REV", "ACCESS_GROUP", "WORKFLOW_GROUP_ID", "CLASS3_ID", "OWNER", "INT_FRAME_NO", "INT_FRAME_REV", "INT_PART_NO", "INT_PART_REV", "FRAME_OWNER", "INTL", "MULTILANG", "UOM_TYPE", "MASK_ID", "PED_IN_SYNC", "LOCKED", "STATUS_TYPE", "STATUS_DESCRIPTION") AS 
  SELECT specification_header."PART_NO",specification_header."REVISION",specification_header."STATUS",specification_header."DESCRIPTION",specification_header."PLANNED_EFFECTIVE_DATE",specification_header."ISSUED_DATE",specification_header."OBSOLESCENCE_DATE",specification_header."STATUS_CHANGE_DATE",specification_header."PHASE_IN_TOLERANCE",specification_header."CREATED_BY",specification_header."CREATED_ON",specification_header."LAST_MODIFIED_BY",specification_header."LAST_MODIFIED_ON",specification_header."FRAME_ID",specification_header."FRAME_REV",specification_header."ACCESS_GROUP",specification_header."WORKFLOW_GROUP_ID",specification_header."CLASS3_ID",specification_header."OWNER",specification_header."INT_FRAME_NO",specification_header."INT_FRAME_REV",specification_header."INT_PART_NO",specification_header."INT_PART_REV",specification_header."FRAME_OWNER",specification_header."INTL",specification_header."MULTILANG",specification_header."UOM_TYPE",specification_header."MASK_ID",specification_header."PED_IN_SYNC",specification_header."LOCKED", status.status_type, status.description AS status_description
FROM specification_header
INNER JOIN status ON (specification_header.status = status.status);

   COMMENT ON TABLE "INTERSPC"."WF_SPECIFICATION_HEADER"  IS 'Specification header and status-type in a single view.
Reason: We can only join a WebFOCUS FOCUS file to a single database table or view, but the status-type is almost always important for filtering results.';
--------------------------------------------------------
--  DDL for View WF_SPECIFICATION_PROP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."WF_SPECIFICATION_PROP" ("PART_NO", "REVISION", "SECTION_ID", "SECTION_REV", "SUB_SECTION_ID", "SUB_SECTION_REV", "PROPERTY_GROUP", "PROPERTY_GROUP_REV", "PROPERTY", "PROPERTY_REV", "ATTRIBUTE", "ATTRIBUTE_REV", "UOM_ID", "UOM_REV", "TEST_METHOD", "TEST_METHOD_REV", "SEQUENCE_NO", "NUM_1", "NUM_2", "NUM_3", "NUM_4", "NUM_5", "NUM_6", "NUM_7", "NUM_8", "NUM_9", "NUM_10", "CHAR_1", "CHAR_2", "CHAR_3", "CHAR_4", "CHAR_5", "CHAR_6", "BOOLEAN_1", "BOOLEAN_2", "BOOLEAN_3", "BOOLEAN_4", "DATE_1", "DATE_2", "CHARACTERISTIC", "CHARACTERISTIC_REV", "ASSOCIATION", "ASSOCIATION_REV", "INTL", "INFO", "UOM_ALT_ID", "UOM_ALT_REV", "TM_DET_1", "TM_DET_2", "TM_DET_3", "TM_DET_4", "TM_SET_NO", "CH_2", "CH_REV_2", "CH_3", "CH_REV_3", "AS_2", "AS_REV_2", "AS_3", "AS_REV_3", "STATUS_TYPE") AS 
  (
SELECT specification_prop."PART_NO",specification_prop."REVISION",specification_prop."SECTION_ID",specification_prop."SECTION_REV",specification_prop."SUB_SECTION_ID",specification_prop."SUB_SECTION_REV",specification_prop."PROPERTY_GROUP",specification_prop."PROPERTY_GROUP_REV",specification_prop."PROPERTY",specification_prop."PROPERTY_REV",specification_prop."ATTRIBUTE",specification_prop."ATTRIBUTE_REV",specification_prop."UOM_ID",specification_prop."UOM_REV",specification_prop."TEST_METHOD",specification_prop."TEST_METHOD_REV",specification_prop."SEQUENCE_NO",specification_prop."NUM_1",specification_prop."NUM_2",specification_prop."NUM_3",specification_prop."NUM_4",specification_prop."NUM_5",specification_prop."NUM_6",specification_prop."NUM_7",specification_prop."NUM_8",specification_prop."NUM_9",specification_prop."NUM_10",specification_prop."CHAR_1",specification_prop."CHAR_2",specification_prop."CHAR_3",specification_prop."CHAR_4",specification_prop."CHAR_5",specification_prop."CHAR_6",specification_prop."BOOLEAN_1",specification_prop."BOOLEAN_2",specification_prop."BOOLEAN_3",specification_prop."BOOLEAN_4",specification_prop."DATE_1",specification_prop."DATE_2",specification_prop."CHARACTERISTIC",specification_prop."CHARACTERISTIC_REV",specification_prop."ASSOCIATION",specification_prop."ASSOCIATION_REV",specification_prop."INTL",specification_prop."INFO",specification_prop."UOM_ALT_ID",specification_prop."UOM_ALT_REV",specification_prop."TM_DET_1",specification_prop."TM_DET_2",specification_prop."TM_DET_3",specification_prop."TM_DET_4",specification_prop."TM_SET_NO",specification_prop."CH_2",specification_prop."CH_REV_2",specification_prop."CH_3",specification_prop."CH_REV_3",specification_prop."AS_2",specification_prop."AS_REV_2",specification_prop."AS_3",specification_prop."AS_REV_3", status_type
  FROM specification_prop
  INNER JOIN specification_header ON (specification_prop.part_no = specification_header.part_no AND specification_prop.revision = specification_header.revision)
  INNER JOIN status ON (specification_header.status = status.status)
)
 ;

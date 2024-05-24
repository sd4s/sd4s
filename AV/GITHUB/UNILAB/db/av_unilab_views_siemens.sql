--------------------------------------------------------
--  File created - dinsdag-oktober-27-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for View UDCH
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UDCH" ("CH", "CY", "CY_VERSION", "DESCRIPTION", "CHART_TITLE", "X_AXIS_TITLE", "Y_AXIS_TITLE", "Y_AXIS_UNIT", "CREATION_DATE", "CREATION_DATE_TZ", "CH_CONTEXT_KEY", "DATAPOINT_CNT", "DATAPOINT_UNIT", "XR_MEASUREMENTS", "XR_MAX_CHARTS", "SQC_AVG", "SQC_STD_DEV", "SQC_AVG_RANGE", "SQC_STD_DEV_RANGE", "EXEC_START_DATE", "EXEC_START_DATE_TZ", "EXEC_END_DATE", "EXEC_END_DATE_TZ", "ASSIGN_CF", "CY_CALC_CF", "VISUAL_CF", "VALID_SQC_RULE1", "VALID_SQC_RULE2", "VALID_SQC_RULE3", "VALID_SQC_RULE4", "VALID_SQC_RULE5", "VALID_SQC_RULE6", "VALID_SQC_RULE7", "XR_SERIE_SEQ", "LAST_COMMENT", "CH_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR1", "AR2", "AR3", "AR4", "AR5", "AR6", "AR7", "AR8", "AR9", "AR10", "AR11", "AR12", "AR13", "AR14", "AR15", "AR16", "AR17", "AR18", "AR19", "AR20", "AR21", "AR22", "AR23", "AR24", "AR25", "AR26", "AR27", "AR28", "AR29", "AR30", "AR31", "AR32", "AR33", "AR34", "AR35", "AR36", "AR37", "AR38", "AR39", "AR40", "AR41", "AR42", "AR43", "AR44", "AR45", "AR46", "AR47", "AR48", "AR49", "AR50", "AR51", "AR52", "AR53", "AR54", "AR55", "AR56", "AR57", "AR58", "AR59", "AR60", "AR61", "AR62", "AR63", "AR64", "AR65", "AR66", "AR67", "AR68", "AR69", "AR70", "AR71", "AR72", "AR73", "AR74", "AR75", "AR76", "AR77", "AR78", "AR79", "AR80", "AR81", "AR82", "AR83", "AR84", "AR85", "AR86", "AR87", "AR88", "AR89", "AR90", "AR91", "AR92", "AR93", "AR94", "AR95", "AR96", "AR97", "AR98", "AR99", "AR100", "AR101", "AR102", "AR103", "AR104", "AR105", "AR106", "AR107", "AR108", "AR109", "AR110", "AR111", "AR112", "AR113", "AR114", "AR115", "AR116", "AR117", "AR118", "AR119", "AR120", "AR121", "AR122", "AR123", "AR124", "AR125", "AR126", "AR127", "AR128") AS 
  SELECT
   ch,
   cy,
   cy_version,
   description,
   chart_title,
   X_axis_title,
   Y_axis_title,
   Y_axis_unit,
   creation_date,
   creation_date_tz,
   ch_context_key,
   datapoint_cnt,
   datapoint_unit,
   xr_measurements,
   xr_max_charts,
   sqc_avg,
   sqc_std_dev,
   sqc_avg_range,
   sqc_std_dev_range,
   exec_start_date,
   exec_start_date_tz,
   exec_end_date,
   exec_end_date_tz,
   assign_cf,
   cy_calc_cf,
   visual_cf,
   valid_sqc_rule1,
   valid_sqc_rule2,
   valid_sqc_rule3,
   valid_sqc_rule4,
   valid_sqc_rule5,
   valid_sqc_rule6,
   valid_sqc_rule7,
   xr_serie_seq,
   last_comment,
   ch_class,
   log_hs,
   log_hs_details,
   allow_modify,
   active,
   lc,
   lc_version,
   ss,
   ar1,
   ar2,
   ar3,
   ar4,
   ar5,
   ar6,
   ar7,
   ar8,
   ar9,
   ar10,
   ar11,
   ar12,
   ar13,
   ar14,
   ar15,
   ar16,
   'N' ar17,
   'N' ar18,
   'N' ar19,
   'N' ar20,
   'N' ar21,
   'N' ar22,
   'N' ar23,
   'N' ar24,
   'N' ar25,
   'N' ar26,
   'N' ar27,
   'N' ar28,
   'N' ar29,
   'N' ar30,
   'N' ar31,
   'N' ar32,
   'N' ar33,
   'N' ar34,
   'N' ar35,
   'N' ar36,
   'N' ar37,
   'N' ar38,
   'N' ar39,
   'N' ar40,
   'N' ar41,
   'N' ar42,
   'N' ar43,
   'N' ar44,
   'N' ar45,
   'N' ar46,
   'N' ar47,
   'N' ar48,
   'N' ar49,
   'N' ar50,
   'N' ar51,
   'N' ar52,
   'N' ar53,
   'N' ar54,
   'N' ar55,
   'N' ar56,
   'N' ar57,
   'N' ar58,
   'N' ar59,
   'N' ar60,
   'N' ar61,
   'N' ar62,
   'N' ar63,
   'N' ar64,
   'N' ar65,
   'N' ar66,
   'N' ar67,
   'N' ar68,
   'N' ar69,
   'N' ar70,
   'N' ar71,
   'N' ar72,
   'N' ar73,
   'N' ar74,
   'N' ar75,
   'N' ar76,
   'N' ar77,
   'N' ar78,
   'N' ar79,
   'N' ar80,
   'N' ar81,
   'N' ar82,
   'N' ar83,
   'N' ar84,
   'N' ar85,
   'N' ar86,
   'N' ar87,
   'N' ar88,
   'N' ar89,
   'N' ar90,
   'N' ar91,
   'N' ar92,
   'N' ar93,
   'N' ar94,
   'N' ar95,
   'N' ar96,
   'N' ar97,
   'N' ar98,
   'N' ar99,
   'N' ar100,
   'N' ar101,
   'N' ar102,
   'N' ar103,
   'N' ar104,
   'N' ar105,
   'N' ar106,
   'N' ar107,
   'N' ar108,
   'N' ar109,
   'N' ar110,
   'N' ar111,
   'N' ar112,
   'N' ar113,
   'N' ar114,
   'N' ar115,
   'N' ar116,
   'N' ar117,
   'N' ar118,
   'N' ar119,
   'N' ar120,
   'N' ar121,
   'N' ar122,
   'N' ar123,
   'N' ar124,
   'N' ar125,
   'N' ar126,
   'N' ar127,
   'N' ar128
FROM "UNILAB".utch;
--------------------------------------------------------
--  DDL for View UDCY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UDCY" ("CY", "VERSION", "VERSION_IS_CURRENT", "EFFECTIVE_FROM", "EFFECTIVE_FROM_TZ", "EFFECTIVE_TILL", "EFFECTIVE_TILL_TZ", "DESCRIPTION", "DESCRIPTION2", "IS_TEMPLATE", "CHART_TITLE", "X_AXIS_TITLE", "Y_AXIS_TITLE", "Y_AXIS_UNIT", "X_LABEL", "DATAPOINT_CNT", "DATAPOINT_UNIT", "XR_MEASUREMENTS", "XR_MAX_CHARTS", "ASSIGN_CF", "CY_CALC_CF", "VISUAL_CF", "VALID_SQC_RULE1", "VALID_SQC_RULE2", "VALID_SQC_RULE3", "VALID_SQC_RULE4", "VALID_SQC_RULE5", "VALID_SQC_RULE6", "VALID_SQC_RULE7", "CH_LC", "CH_LC_VERSION", "INHERIT_AU", "LAST_COMMENT", "CY_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR1", "AR2", "AR3", "AR4", "AR5", "AR6", "AR7", "AR8", "AR9", "AR10", "AR11", "AR12", "AR13", "AR14", "AR15", "AR16", "AR17", "AR18", "AR19", "AR20", "AR21", "AR22", "AR23", "AR24", "AR25", "AR26", "AR27", "AR28", "AR29", "AR30", "AR31", "AR32", "AR33", "AR34", "AR35", "AR36", "AR37", "AR38", "AR39", "AR40", "AR41", "AR42", "AR43", "AR44", "AR45", "AR46", "AR47", "AR48", "AR49", "AR50", "AR51", "AR52", "AR53", "AR54", "AR55", "AR56", "AR57", "AR58", "AR59", "AR60", "AR61", "AR62", "AR63", "AR64", "AR65", "AR66", "AR67", "AR68", "AR69", "AR70", "AR71", "AR72", "AR73", "AR74", "AR75", "AR76", "AR77", "AR78", "AR79", "AR80", "AR81", "AR82", "AR83", "AR84", "AR85", "AR86", "AR87", "AR88", "AR89", "AR90", "AR91", "AR92", "AR93", "AR94", "AR95", "AR96", "AR97", "AR98", "AR99", "AR100", "AR101", "AR102", "AR103", "AR104", "AR105", "AR106", "AR107", "AR108", "AR109", "AR110", "AR111", "AR112", "AR113", "AR114", "AR115", "AR116", "AR117", "AR118", "AR119", "AR120", "AR121", "AR122", "AR123", "AR124", "AR125", "AR126", "AR127", "AR128") AS 
  SELECT
   cy,
   version,
   version_is_current,
   effective_from,
   effective_from_tz,
   effective_till,
   effective_till_tz,
   description,
   description2,
   is_template,
   chart_title,
   X_axis_title,
   Y_axis_title,
   Y_axis_unit,
   x_label,
   datapoint_cnt,
   datapoint_unit,
   xr_measurements,
   xr_max_CHARts,
   assign_cf,
   cy_calc_cf,
   visual_cf,
   valid_sqc_rule1,
   valid_sqc_rule2,
   valid_sqc_rule3,
   valid_sqc_rule4,
   valid_sqc_rule5,
   valid_sqc_rule6,
   valid_sqc_rule7,
   ch_lc,
   ch_lc_version,
   inherit_au,
   last_comment,
   cy_class,
   log_hs,
   log_hs_details,
   allow_modify,
   active,
   lc,
   lc_version,
   ss,
   ar1,
   ar2,
   ar3,
   ar4,
   ar5,
   ar6,
   ar7,
   ar8,
   ar9,
   ar10,
   ar11,
   ar12,
   ar13,
   ar14,
   ar15,
   ar16,
   'N' ar17,
   'N' ar18,
   'N' ar19,
   'N' ar20,
   'N' ar21,
   'N' ar22,
   'N' ar23,
   'N' ar24,
   'N' ar25,
   'N' ar26,
   'N' ar27,
   'N' ar28,
   'N' ar29,
   'N' ar30,
   'N' ar31,
   'N' ar32,
   'N' ar33,
   'N' ar34,
   'N' ar35,
   'N' ar36,
   'N' ar37,
   'N' ar38,
   'N' ar39,
   'N' ar40,
   'N' ar41,
   'N' ar42,
   'N' ar43,
   'N' ar44,
   'N' ar45,
   'N' ar46,
   'N' ar47,
   'N' ar48,
   'N' ar49,
   'N' ar50,
   'N' ar51,
   'N' ar52,
   'N' ar53,
   'N' ar54,
   'N' ar55,
   'N' ar56,
   'N' ar57,
   'N' ar58,
   'N' ar59,
   'N' ar60,
   'N' ar61,
   'N' ar62,
   'N' ar63,
   'N' ar64,
   'N' ar65,
   'N' ar66,
   'N' ar67,
   'N' ar68,
   'N' ar69,
   'N' ar70,
   'N' ar71,
   'N' ar72,
   'N' ar73,
   'N' ar74,
   'N' ar75,
   'N' ar76,
   'N' ar77,
   'N' ar78,
   'N' ar79,
   'N' ar80,
   'N' ar81,
   'N' ar82,
   'N' ar83,
   'N' ar84,
   'N' ar85,
   'N' ar86,
   'N' ar87,
   'N' ar88,
   'N' ar89,
   'N' ar90,
   'N' ar91,
   'N' ar92,
   'N' ar93,
   'N' ar94,
   'N' ar95,
   'N' ar96,
   'N' ar97,
   'N' ar98,
   'N' ar99,
   'N' ar100,
   'N' ar101,
   'N' ar102,
   'N' ar103,
   'N' ar104,
   'N' ar105,
   'N' ar106,
   'N' ar107,
   'N' ar108,
   'N' ar109,
   'N' ar110,
   'N' ar111,
   'N' ar112,
   'N' ar113,
   'N' ar114,
   'N' ar115,
   'N' ar116,
   'N' ar117,
   'N' ar118,
   'N' ar119,
   'N' ar120,
   'N' ar121,
   'N' ar122,
   'N' ar123,
   'N' ar124,
   'N' ar125,
   'N' ar126,
   'N' ar127,
   'N' ar128
FROM "UNILAB".utcy;
--------------------------------------------------------
--  DDL for View UDDC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UDDC" ("DC", "VERSION", "VERSION_IS_CURRENT", "EFFECTIVE_FROM", "EFFECTIVE_FROM_TZ", "EFFECTIVE_TILL", "EFFECTIVE_TILL_TZ", "DESCRIPTION", "CREATION_DATE", "CREATION_DATE_TZ", "CREATED_BY", "LAST_MODIFIED", "LAST_MODIFIED_TZ", "TOOLTIP", "URL", "DATA", "LAST_CHECKOUT_BY", "LAST_CHECKOUT_URL", "CHECKED_OUT", "LAST_COMMENT", "DC_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR1", "AR2", "AR3", "AR4", "AR5", "AR6", "AR7", "AR8", "AR9", "AR10", "AR11", "AR12", "AR13", "AR14", "AR15", "AR16", "AR17", "AR18", "AR19", "AR20", "AR21", "AR22", "AR23", "AR24", "AR25", "AR26", "AR27", "AR28", "AR29", "AR30", "AR31", "AR32", "AR33", "AR34", "AR35", "AR36", "AR37", "AR38", "AR39", "AR40", "AR41", "AR42", "AR43", "AR44", "AR45", "AR46", "AR47", "AR48", "AR49", "AR50", "AR51", "AR52", "AR53", "AR54", "AR55", "AR56", "AR57", "AR58", "AR59", "AR60", "AR61", "AR62", "AR63", "AR64", "AR65", "AR66", "AR67", "AR68", "AR69", "AR70", "AR71", "AR72", "AR73", "AR74", "AR75", "AR76", "AR77", "AR78", "AR79", "AR80", "AR81", "AR82", "AR83", "AR84", "AR85", "AR86", "AR87", "AR88", "AR89", "AR90", "AR91", "AR92", "AR93", "AR94", "AR95", "AR96", "AR97", "AR98", "AR99", "AR100", "AR101", "AR102", "AR103", "AR104", "AR105", "AR106", "AR107", "AR108", "AR109", "AR110", "AR111", "AR112", "AR113", "AR114", "AR115", "AR116", "AR117", "AR118", "AR119", "AR120", "AR121", "AR122", "AR123", "AR124", "AR125", "AR126", "AR127", "AR128") AS 
  SELECT
   dc,
   version,
   version_is_current,
   effective_from,
   effective_from_tz,
   effective_till,
   effective_till_tz,
   description,
   creation_date,
   creation_date_tz,
   created_by,
   last_modified,
   last_modified_tz,
   tooltip,
   url,
   data,
   last_checkout_by,
   last_checkout_url,
   checked_out,
   last_comment,
   dc_class,
   log_hs,
   log_hs_details,
   allow_modify,
   active,
   lc,
   lc_version,
   ss,
   ar1,
   ar2,
   ar3,
   ar4,
   ar5,
   ar6,
   ar7,
   ar8,
   ar9,
   ar10,
   ar11,
   ar12,
   ar13,
   ar14,
   ar15,
   ar16,
   'N' ar17,
   'N' ar18,
   'N' ar19,
   'N' ar20,
   'N' ar21,
   'N' ar22,
   'N' ar23,
   'N' ar24,
   'N' ar25,
   'N' ar26,
   'N' ar27,
   'N' ar28,
   'N' ar29,
   'N' ar30,
   'N' ar31,
   'N' ar32,
   'N' ar33,
   'N' ar34,
   'N' ar35,
   'N' ar36,
   'N' ar37,
   'N' ar38,
   'N' ar39,
   'N' ar40,
   'N' ar41,
   'N' ar42,
   'N' ar43,
   'N' ar44,
   'N' ar45,
   'N' ar46,
   'N' ar47,
   'N' ar48,
   'N' ar49,
   'N' ar50,
   'N' ar51,
   'N' ar52,
   'N' ar53,
   'N' ar54,
   'N' ar55,
   'N' ar56,
   'N' ar57,
   'N' ar58,
   'N' ar59,
   'N' ar60,
   'N' ar61,
   'N' ar62,
   'N' ar63,
   'N' ar64,
   'N' ar65,
   'N' ar66,
   'N' ar67,
   'N' ar68,
   'N' ar69,
   'N' ar70,
   'N' ar71,
   'N' ar72,
   'N' ar73,
   'N' ar74,
   'N' ar75,
   'N' ar76,
   'N' ar77,
   'N' ar78,
   'N' ar79,
   'N' ar80,
   'N' ar81,
   'N' ar82,
   'N' ar83,
   'N' ar84,
   'N' ar85,
   'N' ar86,
   'N' ar87,
   'N' ar88,
   'N' ar89,
   'N' ar90,
   'N' ar91,
   'N' ar92,
   'N' ar93,
   'N' ar94,
   'N' ar95,
   'N' ar96,
   'N' ar97,
   'N' ar98,
   'N' ar99,
   'N' ar100,
   'N' ar101,
   'N' ar102,
   'N' ar103,
   'N' ar104,
   'N' ar105,
   'N' ar106,
   'N' ar107,
   'N' ar108,
   'N' ar109,
   'N' ar110,
   'N' ar111,
   'N' ar112,
   'N' ar113,
   'N' ar114,
   'N' ar115,
   'N' ar116,
   'N' ar117,
   'N' ar118,
   'N' ar119,
   'N' ar120,
   'N' ar121,
   'N' ar122,
   'N' ar123,
   'N' ar124,
   'N' ar125,
   'N' ar126,
   'N' ar127,
   'N' ar128
FROM "UNILAB".utdc;
--------------------------------------------------------
--  DDL for View UDEQ
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UDEQ" ("EQ", "LAB", "VERSION", "VERSION_IS_CURRENT", "EFFECTIVE_FROM", "EFFECTIVE_FROM_TZ", "EFFECTIVE_TILL", "EFFECTIVE_TILL_TZ", "DESCRIPTION", "SERIAL_NO", "SUPPLIER", "LOCATION", "INVEST_COST", "INVEST_UNIT", "USAGE_COST", "USAGE_UNIT", "INSTALL_DATE", "INSTALL_DATE_TZ", "IN_SERVICE_DATE", "IN_SERVICE_DATE_TZ", "ACCESSORIES", "OPERATION", "OPERATION_DOC", "OPERATION_DOC_VERSION", "USAGE", "USAGE_DOC", "USAGE_DOC_VERSION", "EQ_CLASS", "EQ_COMPONENT", "KEEP_CTOLD", "KEEP_CTOLD_UNIT", "IS_TEMPLATE", "LAST_COMMENT", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "CA_WARN_LEVEL", "SS", "LC", "LC_VERSION", "AR1", "AR2", "AR3", "AR4", "AR5", "AR6", "AR7", "AR8", "AR9", "AR10", "AR11", "AR12", "AR13", "AR14", "AR15", "AR16", "AR17", "AR18", "AR19", "AR20", "AR21", "AR22", "AR23", "AR24", "AR25", "AR26", "AR27", "AR28", "AR29", "AR30", "AR31", "AR32", "AR33", "AR34", "AR35", "AR36", "AR37", "AR38", "AR39", "AR40", "AR41", "AR42", "AR43", "AR44", "AR45", "AR46", "AR47", "AR48", "AR49", "AR50", "AR51", "AR52", "AR53", "AR54", "AR55", "AR56", "AR57", "AR58", "AR59", "AR60", "AR61", "AR62", "AR63", "AR64", "AR65", "AR66", "AR67", "AR68", "AR69", "AR70", "AR71", "AR72", "AR73", "AR74", "AR75", "AR76", "AR77", "AR78", "AR79", "AR80", "AR81", "AR82", "AR83", "AR84", "AR85", "AR86", "AR87", "AR88", "AR89", "AR90", "AR91", "AR92", "AR93", "AR94", "AR95", "AR96", "AR97", "AR98", "AR99", "AR100", "AR101", "AR102", "AR103", "AR104", "AR105", "AR106", "AR107", "AR108", "AR109", "AR110", "AR111", "AR112", "AR113", "AR114", "AR115", "AR116", "AR117", "AR118", "AR119", "AR120", "AR121", "AR122", "AR123", "AR124", "AR125", "AR126", "AR127", "AR128") AS 
  SELECT
   eq,
   lab,
   version,
   version_is_current,
   effective_from,
   effective_from_tz,
   effective_till,
   effective_till_tz,
   description,
   serial_no,
   supplier,
   location,
   invest_cost,
   invest_unit,
   usage_cost,
   usage_unit,
   install_date,
   install_date_tz,
   in_service_date,
   in_service_date_tz,
   accessories,
   operation,
   operation_doc,
   operation_doc_version,
   usage,
   usage_doc,
   usage_doc_version,
   eq_class,
   eq_component,
   keep_ctold,
   keep_ctold_unit,
   is_template,
   last_comment,
   log_hs,
   log_hs_details,
   allow_modify,
   active,
   ca_warn_level,
   ss,
   lc,
   lc_version,
   ar1,
   ar2,
   ar3,
   ar4,
   ar5,
   ar6,
   ar7,
   ar8,
   ar9,
   ar10,
   ar11,
   ar12,
   ar13,
   ar14,
   ar15,
   ar16,
   'N' ar17,
   'N' ar18,
   'N' ar19,
   'N' ar20,
   'N' ar21,
   'N' ar22,
   'N' ar23,
   'N' ar24,
   'N' ar25,
   'N' ar26,
   'N' ar27,
   'N' ar28,
   'N' ar29,
   'N' ar30,
   'N' ar31,
   'N' ar32,
   'N' ar33,
   'N' ar34,
   'N' ar35,
   'N' ar36,
   'N' ar37,
   'N' ar38,
   'N' ar39,
   'N' ar40,
   'N' ar41,
   'N' ar42,
   'N' ar43,
   'N' ar44,
   'N' ar45,
   'N' ar46,
   'N' ar47,
   'N' ar48,
   'N' ar49,
   'N' ar50,
   'N' ar51,
   'N' ar52,
   'N' ar53,
   'N' ar54,
   'N' ar55,
   'N' ar56,
   'N' ar57,
   'N' ar58,
   'N' ar59,
   'N' ar60,
   'N' ar61,
   'N' ar62,
   'N' ar63,
   'N' ar64,
   'N' ar65,
   'N' ar66,
   'N' ar67,
   'N' ar68,
   'N' ar69,
   'N' ar70,
   'N' ar71,
   'N' ar72,
   'N' ar73,
   'N' ar74,
   'N' ar75,
   'N' ar76,
   'N' ar77,
   'N' ar78,
   'N' ar79,
   'N' ar80,
   'N' ar81,
   'N' ar82,
   'N' ar83,
   'N' ar84,
   'N' ar85,
   'N' ar86,
   'N' ar87,
   'N' ar88,
   'N' ar89,
   'N' ar90,
   'N' ar91,
   'N' ar92,
   'N' ar93,
   'N' ar94,
   'N' ar95,
   'N' ar96,
   'N' ar97,
   'N' ar98,
   'N' ar99,
   'N' ar100,
   'N' ar101,
   'N' ar102,
   'N' ar103,
   'N' ar104,
   'N' ar105,
   'N' ar106,
   'N' ar107,
   'N' ar108,
   'N' ar109,
   'N' ar110,
   'N' ar111,
   'N' ar112,
   'N' ar113,
   'N' ar114,
   'N' ar115,
   'N' ar116,
   'N' ar117,
   'N' ar118,
   'N' ar119,
   'N' ar120,
   'N' ar121,
   'N' ar122,
   'N' ar123,
   'N' ar124,
   'N' ar125,
   'N' ar126,
   'N' ar127,
   'N' ar128
FROM "UNILAB".uteq;
--------------------------------------------------------
--  DDL for View UDIE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UDIE" ("IE", "VERSION", "VERSION_IS_CURRENT", "EFFECTIVE_FROM", "EFFECTIVE_FROM_TZ", "EFFECTIVE_TILL", "EFFECTIVE_TILL_TZ", "IS_PROTECTED", "MANDATORY", "HIDDEN", "DATA_TP", "FORMAT", "VALID_CF", "DEF_VAL_TP", "DEF_AU_LEVEL", "IEVALUE", "ALIGN", "DSP_TITLE", "DSP_TITLE2", "DSP_LEN", "DSP_TP", "DSP_ROWS", "LOOK_UP_PTR", "IS_TEMPLATE", "MULTI_SELECT", "SC_LC", "SC_LC_VERSION", "INHERIT_AU", "LAST_COMMENT", "IE_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR1", "AR2", "AR3", "AR4", "AR5", "AR6", "AR7", "AR8", "AR9", "AR10", "AR11", "AR12", "AR13", "AR14", "AR15", "AR16", "AR17", "AR18", "AR19", "AR20", "AR21", "AR22", "AR23", "AR24", "AR25", "AR26", "AR27", "AR28", "AR29", "AR30", "AR31", "AR32", "AR33", "AR34", "AR35", "AR36", "AR37", "AR38", "AR39", "AR40", "AR41", "AR42", "AR43", "AR44", "AR45", "AR46", "AR47", "AR48", "AR49", "AR50", "AR51", "AR52", "AR53", "AR54", "AR55", "AR56", "AR57", "AR58", "AR59", "AR60", "AR61", "AR62", "AR63", "AR64", "AR65", "AR66", "AR67", "AR68", "AR69", "AR70", "AR71", "AR72", "AR73", "AR74", "AR75", "AR76", "AR77", "AR78", "AR79", "AR80", "AR81", "AR82", "AR83", "AR84", "AR85", "AR86", "AR87", "AR88", "AR89", "AR90", "AR91", "AR92", "AR93", "AR94", "AR95", "AR96", "AR97", "AR98", "AR99", "AR100", "AR101", "AR102", "AR103", "AR104", "AR105", "AR106", "AR107", "AR108", "AR109", "AR110", "AR111", "AR112", "AR113", "AR114", "AR115", "AR116", "AR117", "AR118", "AR119", "AR120", "AR121", "AR122", "AR123", "AR124", "AR125", "AR126", "AR127", "AR128") AS 
  SELECT
   ie,
   version,
   version_is_current,
   effective_from,
   effective_from_tz,
   effective_till,
   effective_till_tz,
   is_protected,
   mandatory,
   hidden,
   data_tp,
   format,
   valid_cf,
   def_val_tp,
   def_au_level,
   ievalue,
   align,
   dsp_title,
   dsp_title2,
   dsp_len,
   dsp_tp,
   dsp_rows,
   look_up_ptr,
   is_template,
   multi_select,
   sc_lc,
   sc_lc_version,
   inherit_au,
   last_comment,
   ie_class,
   log_hs,
   log_hs_details,
   allow_modify,
   active,
   lc,
   lc_version,
   ss,
   ar1,
   ar2,
   ar3,
   ar4,
   ar5,
   ar6,
   ar7,
   ar8,
   ar9,
   ar10,
   ar11,
   ar12,
   ar13,
   ar14,
   ar15,
   ar16,
   'N' ar17,
   'N' ar18,
   'N' ar19,
   'N' ar20,
   'N' ar21,
   'N' ar22,
   'N' ar23,
   'N' ar24,
   'N' ar25,
   'N' ar26,
   'N' ar27,
   'N' ar28,
   'N' ar29,
   'N' ar30,
   'N' ar31,
   'N' ar32,
   'N' ar33,
   'N' ar34,
   'N' ar35,
   'N' ar36,
   'N' ar37,
   'N' ar38,
   'N' ar39,
   'N' ar40,
   'N' ar41,
   'N' ar42,
   'N' ar43,
   'N' ar44,
   'N' ar45,
   'N' ar46,
   'N' ar47,
   'N' ar48,
   'N' ar49,
   'N' ar50,
   'N' ar51,
   'N' ar52,
   'N' ar53,
   'N' ar54,
   'N' ar55,
   'N' ar56,
   'N' ar57,
   'N' ar58,
   'N' ar59,
   'N' ar60,
   'N' ar61,
   'N' ar62,
   'N' ar63,
   'N' ar64,
   'N' ar65,
   'N' ar66,
   'N' ar67,
   'N' ar68,
   'N' ar69,
   'N' ar70,
   'N' ar71,
   'N' ar72,
   'N' ar73,
   'N' ar74,
   'N' ar75,
   'N' ar76,
   'N' ar77,
   'N' ar78,
   'N' ar79,
   'N' ar80,
   'N' ar81,
   'N' ar82,
   'N' ar83,
   'N' ar84,
   'N' ar85,
   'N' ar86,
   'N' ar87,
   'N' ar88,
   'N' ar89,
   'N' ar90,
   'N' ar91,
   'N' ar92,
   'N' ar93,
   'N' ar94,
   'N' ar95,
   'N' ar96,
   'N' ar97,
   'N' ar98,
   'N' ar99,
   'N' ar100,
   'N' ar101,
   'N' ar102,
   'N' ar103,
   'N' ar104,
   'N' ar105,
   'N' ar106,
   'N' ar107,
   'N' ar108,
   'N' ar109,
   'N' ar110,
   'N' ar111,
   'N' ar112,
   'N' ar113,
   'N' ar114,
   'N' ar115,
   'N' ar116,
   'N' ar117,
   'N' ar118,
   'N' ar119,
   'N' ar120,
   'N' ar121,
   'N' ar122,
   'N' ar123,
   'N' ar124,
   'N' ar125,
   'N' ar126,
   'N' ar127,
   'N' ar128
FROM "UNILAB".utie;
--------------------------------------------------------
--  DDL for View UDIP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UDIP" ("IP", "VERSION", "VERSION_IS_CURRENT", "EFFECTIVE_FROM", "EFFECTIVE_FROM_TZ", "EFFECTIVE_TILL", "EFFECTIVE_TILL_TZ", "DESCRIPTION", "DESCRIPTION2", "WINSIZE_X", "WINSIZE_Y", "IS_PROTECTED", "HIDDEN", "IS_TEMPLATE", "SC_LC", "SC_LC_VERSION", "INHERIT_AU", "LAST_COMMENT", "IP_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR1", "AR2", "AR3", "AR4", "AR5", "AR6", "AR7", "AR8", "AR9", "AR10", "AR11", "AR12", "AR13", "AR14", "AR15", "AR16", "AR17", "AR18", "AR19", "AR20", "AR21", "AR22", "AR23", "AR24", "AR25", "AR26", "AR27", "AR28", "AR29", "AR30", "AR31", "AR32", "AR33", "AR34", "AR35", "AR36", "AR37", "AR38", "AR39", "AR40", "AR41", "AR42", "AR43", "AR44", "AR45", "AR46", "AR47", "AR48", "AR49", "AR50", "AR51", "AR52", "AR53", "AR54", "AR55", "AR56", "AR57", "AR58", "AR59", "AR60", "AR61", "AR62", "AR63", "AR64", "AR65", "AR66", "AR67", "AR68", "AR69", "AR70", "AR71", "AR72", "AR73", "AR74", "AR75", "AR76", "AR77", "AR78", "AR79", "AR80", "AR81", "AR82", "AR83", "AR84", "AR85", "AR86", "AR87", "AR88", "AR89", "AR90", "AR91", "AR92", "AR93", "AR94", "AR95", "AR96", "AR97", "AR98", "AR99", "AR100", "AR101", "AR102", "AR103", "AR104", "AR105", "AR106", "AR107", "AR108", "AR109", "AR110", "AR111", "AR112", "AR113", "AR114", "AR115", "AR116", "AR117", "AR118", "AR119", "AR120", "AR121", "AR122", "AR123", "AR124", "AR125", "AR126", "AR127", "AR128") AS 
  SELECT
   ip,
   version,
   version_is_current,
   effective_from,
   effective_from_tz,
   effective_till,
   effective_till_tz,
   description,
   description2,
   winsize_x,
   winsize_y,
   is_protected,
   hidden,
   is_template,
   sc_lc,
   sc_lc_version,
   inherit_au,
   last_comment,
   ip_class,
   log_hs,
   log_hs_details,
   allow_modify,
   active,
   lc,
   lc_version,
   ss,
   ar1,
   ar2,
   ar3,
   ar4,
   ar5,
   ar6,
   ar7,
   ar8,
   ar9,
   ar10,
   ar11,
   ar12,
   ar13,
   ar14,
   ar15,
   ar16,
   'N' ar17,
   'N' ar18,
   'N' ar19,
   'N' ar20,
   'N' ar21,
   'N' ar22,
   'N' ar23,
   'N' ar24,
   'N' ar25,
   'N' ar26,
   'N' ar27,
   'N' ar28,
   'N' ar29,
   'N' ar30,
   'N' ar31,
   'N' ar32,
   'N' ar33,
   'N' ar34,
   'N' ar35,
   'N' ar36,
   'N' ar37,
   'N' ar38,
   'N' ar39,
   'N' ar40,
   'N' ar41,
   'N' ar42,
   'N' ar43,
   'N' ar44,
   'N' ar45,
   'N' ar46,
   'N' ar47,
   'N' ar48,
   'N' ar49,
   'N' ar50,
   'N' ar51,
   'N' ar52,
   'N' ar53,
   'N' ar54,
   'N' ar55,
   'N' ar56,
   'N' ar57,
   'N' ar58,
   'N' ar59,
   'N' ar60,
   'N' ar61,
   'N' ar62,
   'N' ar63,
   'N' ar64,
   'N' ar65,
   'N' ar66,
   'N' ar67,
   'N' ar68,
   'N' ar69,
   'N' ar70,
   'N' ar71,
   'N' ar72,
   'N' ar73,
   'N' ar74,
   'N' ar75,
   'N' ar76,
   'N' ar77,
   'N' ar78,
   'N' ar79,
   'N' ar80,
   'N' ar81,
   'N' ar82,
   'N' ar83,
   'N' ar84,
   'N' ar85,
   'N' ar86,
   'N' ar87,
   'N' ar88,
   'N' ar89,
   'N' ar90,
   'N' ar91,
   'N' ar92,
   'N' ar93,
   'N' ar94,
   'N' ar95,
   'N' ar96,
   'N' ar97,
   'N' ar98,
   'N' ar99,
   'N' ar100,
   'N' ar101,
   'N' ar102,
   'N' ar103,
   'N' ar104,
   'N' ar105,
   'N' ar106,
   'N' ar107,
   'N' ar108,
   'N' ar109,
   'N' ar110,
   'N' ar111,
   'N' ar112,
   'N' ar113,
   'N' ar114,
   'N' ar115,
   'N' ar116,
   'N' ar117,
   'N' ar118,
   'N' ar119,
   'N' ar120,
   'N' ar121,
   'N' ar122,
   'N' ar123,
   'N' ar124,
   'N' ar125,
   'N' ar126,
   'N' ar127,
   'N' ar128
FROM "UNILAB".utip;
--------------------------------------------------------
--  DDL for View UDMT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UDMT" ("MT", "VERSION", "VERSION_IS_CURRENT", "EFFECTIVE_FROM", "EFFECTIVE_FROM_TZ", "EFFECTIVE_TILL", "EFFECTIVE_TILL_TZ", "DESCRIPTION", "DESCRIPTION2", "UNIT", "EST_COST", "EST_TIME", "ACCURACY", "IS_TEMPLATE", "CALIBRATION", "AUTORECALC", "CONFIRM_COMPLETE", "AUTO_CREATE_CELLS", "ME_RESULT_EDITABLE", "EXECUTOR", "EQ_TP", "SOP", "SOP_VERSION", "PLAUS_LOW", "PLAUS_HIGH", "WINSIZE_X", "WINSIZE_Y", "SC_LC", "SC_LC_VERSION", "DEF_VAL_TP", "DEF_AU_LEVEL", "DEF_VAL", "FORMAT", "INHERIT_AU", "LAST_COMMENT", "MT_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR1", "AR2", "AR3", "AR4", "AR5", "AR6", "AR7", "AR8", "AR9", "AR10", "AR11", "AR12", "AR13", "AR14", "AR15", "AR16", "AR17", "AR18", "AR19", "AR20", "AR21", "AR22", "AR23", "AR24", "AR25", "AR26", "AR27", "AR28", "AR29", "AR30", "AR31", "AR32", "AR33", "AR34", "AR35", "AR36", "AR37", "AR38", "AR39", "AR40", "AR41", "AR42", "AR43", "AR44", "AR45", "AR46", "AR47", "AR48", "AR49", "AR50", "AR51", "AR52", "AR53", "AR54", "AR55", "AR56", "AR57", "AR58", "AR59", "AR60", "AR61", "AR62", "AR63", "AR64", "AR65", "AR66", "AR67", "AR68", "AR69", "AR70", "AR71", "AR72", "AR73", "AR74", "AR75", "AR76", "AR77", "AR78", "AR79", "AR80", "AR81", "AR82", "AR83", "AR84", "AR85", "AR86", "AR87", "AR88", "AR89", "AR90", "AR91", "AR92", "AR93", "AR94", "AR95", "AR96", "AR97", "AR98", "AR99", "AR100", "AR101", "AR102", "AR103", "AR104", "AR105", "AR106", "AR107", "AR108", "AR109", "AR110", "AR111", "AR112", "AR113", "AR114", "AR115", "AR116", "AR117", "AR118", "AR119", "AR120", "AR121", "AR122", "AR123", "AR124", "AR125", "AR126", "AR127", "AR128") AS 
  SELECT
   mt,
   version,
   version_is_current,
   effective_from,
   effective_from_tz,
   effective_till,
   effective_till_tz,
   description,
   description2,
   unit,
   est_cost,
   est_time,
   accuracy,
   is_template,
   calibration,
   autorecalc,
   confirm_complete,
   auto_create_cells,
   me_result_editable,
   executor,
   eq_tp,
   sop,
   sop_version,
   plaus_low,
   plaus_high,
   winsize_x,
   winsize_y,
   sc_lc,
   sc_lc_version,
   def_val_tp,
   def_au_level,
   def_val,
   format,
   inherit_au,
   last_comment,
   mt_class,
   log_hs,
   log_hs_details,
   allow_modify,
   active,
   lc,
   lc_version,
   ss,
   ar1,
   ar2,
   ar3,
   ar4,
   ar5,
   ar6,
   ar7,
   ar8,
   ar9,
   ar10,
   ar11,
   ar12,
   ar13,
   ar14,
   ar15,
   ar16,
   'N' ar17,
   'N' ar18,
   'N' ar19,
   'N' ar20,
   'N' ar21,
   'N' ar22,
   'N' ar23,
   'N' ar24,
   'N' ar25,
   'N' ar26,
   'N' ar27,
   'N' ar28,
   'N' ar29,
   'N' ar30,
   'N' ar31,
   'N' ar32,
   'N' ar33,
   'N' ar34,
   'N' ar35,
   'N' ar36,
   'N' ar37,
   'N' ar38,
   'N' ar39,
   'N' ar40,
   'N' ar41,
   'N' ar42,
   'N' ar43,
   'N' ar44,
   'N' ar45,
   'N' ar46,
   'N' ar47,
   'N' ar48,
   'N' ar49,
   'N' ar50,
   'N' ar51,
   'N' ar52,
   'N' ar53,
   'N' ar54,
   'N' ar55,
   'N' ar56,
   'N' ar57,
   'N' ar58,
   'N' ar59,
   'N' ar60,
   'N' ar61,
   'N' ar62,
   'N' ar63,
   'N' ar64,
   'N' ar65,
   'N' ar66,
   'N' ar67,
   'N' ar68,
   'N' ar69,
   'N' ar70,
   'N' ar71,
   'N' ar72,
   'N' ar73,
   'N' ar74,
   'N' ar75,
   'N' ar76,
   'N' ar77,
   'N' ar78,
   'N' ar79,
   'N' ar80,
   'N' ar81,
   'N' ar82,
   'N' ar83,
   'N' ar84,
   'N' ar85,
   'N' ar86,
   'N' ar87,
   'N' ar88,
   'N' ar89,
   'N' ar90,
   'N' ar91,
   'N' ar92,
   'N' ar93,
   'N' ar94,
   'N' ar95,
   'N' ar96,
   'N' ar97,
   'N' ar98,
   'N' ar99,
   'N' ar100,
   'N' ar101,
   'N' ar102,
   'N' ar103,
   'N' ar104,
   'N' ar105,
   'N' ar106,
   'N' ar107,
   'N' ar108,
   'N' ar109,
   'N' ar110,
   'N' ar111,
   'N' ar112,
   'N' ar113,
   'N' ar114,
   'N' ar115,
   'N' ar116,
   'N' ar117,
   'N' ar118,
   'N' ar119,
   'N' ar120,
   'N' ar121,
   'N' ar122,
   'N' ar123,
   'N' ar124,
   'N' ar125,
   'N' ar126,
   'N' ar127,
   'N' ar128
FROM "UNILAB".utmt;
--------------------------------------------------------
--  DDL for View UDPP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UDPP" ("PP", "VERSION", "PP_KEY1", "PP_KEY2", "PP_KEY3", "PP_KEY4", "PP_KEY5", "VERSION_IS_CURRENT", "EFFECTIVE_FROM", "EFFECTIVE_FROM_TZ", "EFFECTIVE_TILL", "EFFECTIVE_TILL_TZ", "DESCRIPTION", "DESCRIPTION2", "UNIT", "FORMAT", "CONFIRM_ASSIGN", "ALLOW_ANY_PR", "NEVER_CREATE_METHODS", "DELAY", "DELAY_UNIT", "IS_TEMPLATE", "SC_LC", "SC_LC_VERSION", "INHERIT_AU", "LAST_COMMENT", "PP_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR1", "AR2", "AR3", "AR4", "AR5", "AR6", "AR7", "AR8", "AR9", "AR10", "AR11", "AR12", "AR13", "AR14", "AR15", "AR16", "AR17", "AR18", "AR19", "AR20", "AR21", "AR22", "AR23", "AR24", "AR25", "AR26", "AR27", "AR28", "AR29", "AR30", "AR31", "AR32", "AR33", "AR34", "AR35", "AR36", "AR37", "AR38", "AR39", "AR40", "AR41", "AR42", "AR43", "AR44", "AR45", "AR46", "AR47", "AR48", "AR49", "AR50", "AR51", "AR52", "AR53", "AR54", "AR55", "AR56", "AR57", "AR58", "AR59", "AR60", "AR61", "AR62", "AR63", "AR64", "AR65", "AR66", "AR67", "AR68", "AR69", "AR70", "AR71", "AR72", "AR73", "AR74", "AR75", "AR76", "AR77", "AR78", "AR79", "AR80", "AR81", "AR82", "AR83", "AR84", "AR85", "AR86", "AR87", "AR88", "AR89", "AR90", "AR91", "AR92", "AR93", "AR94", "AR95", "AR96", "AR97", "AR98", "AR99", "AR100", "AR101", "AR102", "AR103", "AR104", "AR105", "AR106", "AR107", "AR108", "AR109", "AR110", "AR111", "AR112", "AR113", "AR114", "AR115", "AR116", "AR117", "AR118", "AR119", "AR120", "AR121", "AR122", "AR123", "AR124", "AR125", "AR126", "AR127", "AR128") AS 
  SELECT
   pp,
   version,
   pp_key1,
   pp_key2,
   pp_key3,
   pp_key4,
   pp_key5,
   version_is_current,
   effective_from,
   effective_from_tz,
   effective_till,
   effective_till_tz,
   description,
   description2,
   unit,
   format,
   confirm_assign,
   allow_any_pr,
   never_create_methods,
   delay,
   delay_unit,
   is_template,
   sc_lc,
   sc_lc_version,
   inherit_au,
   last_comment,
   pp_class,
   log_hs,
   log_hs_details,
   allow_modify,
   active,
   lc,
   lc_version,
   ss,
   ar1,
   ar2,
   ar3,
   ar4,
   ar5,
   ar6,
   ar7,
   ar8,
   ar9,
   ar10,
   ar11,
   ar12,
   ar13,
   ar14,
   ar15,
   ar16,
   'N' ar17,
   'N' ar18,
   'N' ar19,
   'N' ar20,
   'N' ar21,
   'N' ar22,
   'N' ar23,
   'N' ar24,
   'N' ar25,
   'N' ar26,
   'N' ar27,
   'N' ar28,
   'N' ar29,
   'N' ar30,
   'N' ar31,
   'N' ar32,
   'N' ar33,
   'N' ar34,
   'N' ar35,
   'N' ar36,
   'N' ar37,
   'N' ar38,
   'N' ar39,
   'N' ar40,
   'N' ar41,
   'N' ar42,
   'N' ar43,
   'N' ar44,
   'N' ar45,
   'N' ar46,
   'N' ar47,
   'N' ar48,
   'N' ar49,
   'N' ar50,
   'N' ar51,
   'N' ar52,
   'N' ar53,
   'N' ar54,
   'N' ar55,
   'N' ar56,
   'N' ar57,
   'N' ar58,
   'N' ar59,
   'N' ar60,
   'N' ar61,
   'N' ar62,
   'N' ar63,
   'N' ar64,
   'N' ar65,
   'N' ar66,
   'N' ar67,
   'N' ar68,
   'N' ar69,
   'N' ar70,
   'N' ar71,
   'N' ar72,
   'N' ar73,
   'N' ar74,
   'N' ar75,
   'N' ar76,
   'N' ar77,
   'N' ar78,
   'N' ar79,
   'N' ar80,
   'N' ar81,
   'N' ar82,
   'N' ar83,
   'N' ar84,
   'N' ar85,
   'N' ar86,
   'N' ar87,
   'N' ar88,
   'N' ar89,
   'N' ar90,
   'N' ar91,
   'N' ar92,
   'N' ar93,
   'N' ar94,
   'N' ar95,
   'N' ar96,
   'N' ar97,
   'N' ar98,
   'N' ar99,
   'N' ar100,
   'N' ar101,
   'N' ar102,
   'N' ar103,
   'N' ar104,
   'N' ar105,
   'N' ar106,
   'N' ar107,
   'N' ar108,
   'N' ar109,
   'N' ar110,
   'N' ar111,
   'N' ar112,
   'N' ar113,
   'N' ar114,
   'N' ar115,
   'N' ar116,
   'N' ar117,
   'N' ar118,
   'N' ar119,
   'N' ar120,
   'N' ar121,
   'N' ar122,
   'N' ar123,
   'N' ar124,
   'N' ar125,
   'N' ar126,
   'N' ar127,
   'N' ar128
FROM "UNILAB".utpp;
--------------------------------------------------------
--  DDL for View UDPR
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UDPR" ("PR", "VERSION", "VERSION_IS_CURRENT", "EFFECTIVE_FROM", "EFFECTIVE_FROM_TZ", "EFFECTIVE_TILL", "EFFECTIVE_TILL_TZ", "DESCRIPTION", "DESCRIPTION2", "UNIT", "FORMAT", "TD_INFO", "TD_INFO_UNIT", "CONFIRM_UID", "DEF_VAL_TP", "DEF_AU_LEVEL", "DEF_VAL", "ALLOW_ANY_MT", "DELAY", "DELAY_UNIT", "MIN_NR_RESULTS", "CALC_METHOD", "CALC_CF", "ALARM_ORDER", "SETA_SPECS", "SETA_LIMITS", "SETA_TARGET", "SETB_SPECS", "SETB_LIMITS", "SETB_TARGET", "SETC_SPECS", "SETC_LIMITS", "SETC_TARGET", "IS_TEMPLATE", "LOG_EXCEPTIONS", "SC_LC", "SC_LC_VERSION", "INHERIT_AU", "LAST_COMMENT", "PR_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR1", "AR2", "AR3", "AR4", "AR5", "AR6", "AR7", "AR8", "AR9", "AR10", "AR11", "AR12", "AR13", "AR14", "AR15", "AR16", "AR17", "AR18", "AR19", "AR20", "AR21", "AR22", "AR23", "AR24", "AR25", "AR26", "AR27", "AR28", "AR29", "AR30", "AR31", "AR32", "AR33", "AR34", "AR35", "AR36", "AR37", "AR38", "AR39", "AR40", "AR41", "AR42", "AR43", "AR44", "AR45", "AR46", "AR47", "AR48", "AR49", "AR50", "AR51", "AR52", "AR53", "AR54", "AR55", "AR56", "AR57", "AR58", "AR59", "AR60", "AR61", "AR62", "AR63", "AR64", "AR65", "AR66", "AR67", "AR68", "AR69", "AR70", "AR71", "AR72", "AR73", "AR74", "AR75", "AR76", "AR77", "AR78", "AR79", "AR80", "AR81", "AR82", "AR83", "AR84", "AR85", "AR86", "AR87", "AR88", "AR89", "AR90", "AR91", "AR92", "AR93", "AR94", "AR95", "AR96", "AR97", "AR98", "AR99", "AR100", "AR101", "AR102", "AR103", "AR104", "AR105", "AR106", "AR107", "AR108", "AR109", "AR110", "AR111", "AR112", "AR113", "AR114", "AR115", "AR116", "AR117", "AR118", "AR119", "AR120", "AR121", "AR122", "AR123", "AR124", "AR125", "AR126", "AR127", "AR128") AS 
  SELECT
   pr,
   version,
   version_is_current,
   effective_from,
   effective_from_tz,
   effective_till,
   effective_till_tz,
   description,
   description2,
   unit,
   format,
   td_info,
   td_info_unit,
   confirm_uid,
   def_val_tp,
   def_au_level,
   def_val,
   allow_any_mt,
   delay,
   delay_unit,
   min_nr_results,
   calc_method,
   calc_cf,
   alarm_order,
   seta_specs,
   seta_limits,
   seta_target,
   setb_specs,
   setb_limits,
   setb_target,
   setc_specs,
   setc_limits,
   setc_target,
   is_template,
   log_exceptions,
   sc_lc,
   sc_lc_version,
   inherit_au,
   last_comment,
   pr_class,
   log_hs,
   log_hs_details,
   allow_modify,
   active,
   lc,
   lc_version,
   ss,
   ar1,
   ar2,
   ar3,
   ar4,
   ar5,
   ar6,
   ar7,
   ar8,
   ar9,
   ar10,
   ar11,
   ar12,
   ar13,
   ar14,
   ar15,
   ar16,
   'N' ar17,
   'N' ar18,
   'N' ar19,
   'N' ar20,
   'N' ar21,
   'N' ar22,
   'N' ar23,
   'N' ar24,
   'N' ar25,
   'N' ar26,
   'N' ar27,
   'N' ar28,
   'N' ar29,
   'N' ar30,
   'N' ar31,
   'N' ar32,
   'N' ar33,
   'N' ar34,
   'N' ar35,
   'N' ar36,
   'N' ar37,
   'N' ar38,
   'N' ar39,
   'N' ar40,
   'N' ar41,
   'N' ar42,
   'N' ar43,
   'N' ar44,
   'N' ar45,
   'N' ar46,
   'N' ar47,
   'N' ar48,
   'N' ar49,
   'N' ar50,
   'N' ar51,
   'N' ar52,
   'N' ar53,
   'N' ar54,
   'N' ar55,
   'N' ar56,
   'N' ar57,
   'N' ar58,
   'N' ar59,
   'N' ar60,
   'N' ar61,
   'N' ar62,
   'N' ar63,
   'N' ar64,
   'N' ar65,
   'N' ar66,
   'N' ar67,
   'N' ar68,
   'N' ar69,
   'N' ar70,
   'N' ar71,
   'N' ar72,
   'N' ar73,
   'N' ar74,
   'N' ar75,
   'N' ar76,
   'N' ar77,
   'N' ar78,
   'N' ar79,
   'N' ar80,
   'N' ar81,
   'N' ar82,
   'N' ar83,
   'N' ar84,
   'N' ar85,
   'N' ar86,
   'N' ar87,
   'N' ar88,
   'N' ar89,
   'N' ar90,
   'N' ar91,
   'N' ar92,
   'N' ar93,
   'N' ar94,
   'N' ar95,
   'N' ar96,
   'N' ar97,
   'N' ar98,
   'N' ar99,
   'N' ar100,
   'N' ar101,
   'N' ar102,
   'N' ar103,
   'N' ar104,
   'N' ar105,
   'N' ar106,
   'N' ar107,
   'N' ar108,
   'N' ar109,
   'N' ar110,
   'N' ar111,
   'N' ar112,
   'N' ar113,
   'N' ar114,
   'N' ar115,
   'N' ar116,
   'N' ar117,
   'N' ar118,
   'N' ar119,
   'N' ar120,
   'N' ar121,
   'N' ar122,
   'N' ar123,
   'N' ar124,
   'N' ar125,
   'N' ar126,
   'N' ar127,
   'N' ar128
FROM "UNILAB".utpr;
--------------------------------------------------------
--  DDL for View UDPT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UDPT" ("PT", "VERSION", "VERSION_IS_CURRENT", "EFFECTIVE_FROM", "EFFECTIVE_FROM_TZ", "EFFECTIVE_TILL", "EFFECTIVE_TILL_TZ", "DESCRIPTION", "DESCRIPTION2", "DESCR_DOC", "DESCR_DOC_VERSION", "IS_TEMPLATE", "CONFIRM_USERID", "NR_PLANNED_SD", "FREQ_TP", "FREQ_VAL", "FREQ_UNIT", "INVERT_FREQ", "LAST_SCHED", "LAST_SCHED_TZ", "LAST_CNT", "LAST_VAL", "LABEL_FORMAT", "PLANNED_RESPONSIBLE", "SD_UC", "SD_UC_VERSION", "SD_LC", "SD_LC_VERSION", "INHERIT_AU", "INHERIT_GK", "LAST_COMMENT", "PT_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR1", "AR2", "AR3", "AR4", "AR5", "AR6", "AR7", "AR8", "AR9", "AR10", "AR11", "AR12", "AR13", "AR14", "AR15", "AR16", "AR17", "AR18", "AR19", "AR20", "AR21", "AR22", "AR23", "AR24", "AR25", "AR26", "AR27", "AR28", "AR29", "AR30", "AR31", "AR32", "AR33", "AR34", "AR35", "AR36", "AR37", "AR38", "AR39", "AR40", "AR41", "AR42", "AR43", "AR44", "AR45", "AR46", "AR47", "AR48", "AR49", "AR50", "AR51", "AR52", "AR53", "AR54", "AR55", "AR56", "AR57", "AR58", "AR59", "AR60", "AR61", "AR62", "AR63", "AR64", "AR65", "AR66", "AR67", "AR68", "AR69", "AR70", "AR71", "AR72", "AR73", "AR74", "AR75", "AR76", "AR77", "AR78", "AR79", "AR80", "AR81", "AR82", "AR83", "AR84", "AR85", "AR86", "AR87", "AR88", "AR89", "AR90", "AR91", "AR92", "AR93", "AR94", "AR95", "AR96", "AR97", "AR98", "AR99", "AR100", "AR101", "AR102", "AR103", "AR104", "AR105", "AR106", "AR107", "AR108", "AR109", "AR110", "AR111", "AR112", "AR113", "AR114", "AR115", "AR116", "AR117", "AR118", "AR119", "AR120", "AR121", "AR122", "AR123", "AR124", "AR125", "AR126", "AR127", "AR128") AS 
  SELECT
   pt,
   version,
   version_is_current,
   effective_from,
   effective_from_tz,
   effective_till,
   effective_till_tz,
   description,
   description2,
   descr_doc,
   descr_doc_version,
   is_template,
   confirm_userid,
   nr_planned_sd,
   freq_tp,
   freq_val,
   freq_unit,
   invert_freq,
   last_sched,
   last_sched_tz,
   last_cnt,
   last_val,
   label_format,
   planned_responsible,
   sd_uc,
   sd_uc_version,
   sd_lc,
   sd_lc_version,
   inherit_au,
   inherit_gk,
   last_comment,
   pt_class,
   log_hs,
   log_hs_details,
   allow_modify,
   active,
   lc,
   lc_version,
   ss,
   ar1,
   ar2,
   ar3,
   ar4,
   ar5,
   ar6,
   ar7,
   ar8,
   ar9,
   ar10,
   ar11,
   ar12,
   ar13,
   ar14,
   ar15,
   ar16,
   'N' ar17,
   'N' ar18,
   'N' ar19,
   'N' ar20,
   'N' ar21,
   'N' ar22,
   'N' ar23,
   'N' ar24,
   'N' ar25,
   'N' ar26,
   'N' ar27,
   'N' ar28,
   'N' ar29,
   'N' ar30,
   'N' ar31,
   'N' ar32,
   'N' ar33,
   'N' ar34,
   'N' ar35,
   'N' ar36,
   'N' ar37,
   'N' ar38,
   'N' ar39,
   'N' ar40,
   'N' ar41,
   'N' ar42,
   'N' ar43,
   'N' ar44,
   'N' ar45,
   'N' ar46,
   'N' ar47,
   'N' ar48,
   'N' ar49,
   'N' ar50,
   'N' ar51,
   'N' ar52,
   'N' ar53,
   'N' ar54,
   'N' ar55,
   'N' ar56,
   'N' ar57,
   'N' ar58,
   'N' ar59,
   'N' ar60,
   'N' ar61,
   'N' ar62,
   'N' ar63,
   'N' ar64,
   'N' ar65,
   'N' ar66,
   'N' ar67,
   'N' ar68,
   'N' ar69,
   'N' ar70,
   'N' ar71,
   'N' ar72,
   'N' ar73,
   'N' ar74,
   'N' ar75,
   'N' ar76,
   'N' ar77,
   'N' ar78,
   'N' ar79,
   'N' ar80,
   'N' ar81,
   'N' ar82,
   'N' ar83,
   'N' ar84,
   'N' ar85,
   'N' ar86,
   'N' ar87,
   'N' ar88,
   'N' ar89,
   'N' ar90,
   'N' ar91,
   'N' ar92,
   'N' ar93,
   'N' ar94,
   'N' ar95,
   'N' ar96,
   'N' ar97,
   'N' ar98,
   'N' ar99,
   'N' ar100,
   'N' ar101,
   'N' ar102,
   'N' ar103,
   'N' ar104,
   'N' ar105,
   'N' ar106,
   'N' ar107,
   'N' ar108,
   'N' ar109,
   'N' ar110,
   'N' ar111,
   'N' ar112,
   'N' ar113,
   'N' ar114,
   'N' ar115,
   'N' ar116,
   'N' ar117,
   'N' ar118,
   'N' ar119,
   'N' ar120,
   'N' ar121,
   'N' ar122,
   'N' ar123,
   'N' ar124,
   'N' ar125,
   'N' ar126,
   'N' ar127,
   'N' ar128
FROM "UNILAB".utpt;
--------------------------------------------------------
--  DDL for View UDRQ
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UDRQ" ("RQ", "RT", "RT_VERSION", "DESCRIPTION", "DESCR_DOC", "DESCR_DOC_VERSION", "SAMPLING_DATE", "SAMPLING_DATE_TZ", "CREATION_DATE", "CREATION_DATE_TZ", "CREATED_BY", "EXEC_START_DATE", "EXEC_START_DATE_TZ", "EXEC_END_DATE", "EXEC_END_DATE_TZ", "DUE_DATE", "DUE_DATE_TZ", "PRIORITY", "LABEL_FORMAT", "DATE1", "DATE1_TZ", "DATE2", "DATE2_TZ", "DATE3", "DATE3_TZ", "DATE4", "DATE4_TZ", "DATE5", "DATE5_TZ", "ALLOW_ANY_ST", "ALLOW_NEW_SC", "RESPONSIBLE", "SC_COUNTER", "RQ_COUNTER", "LAST_COMMENT", "RQ_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR1", "AR2", "AR3", "AR4", "AR5", "AR6", "AR7", "AR8", "AR9", "AR10", "AR11", "AR12", "AR13", "AR14", "AR15", "AR16", "AR17", "AR18", "AR19", "AR20", "AR21", "AR22", "AR23", "AR24", "AR25", "AR26", "AR27", "AR28", "AR29", "AR30", "AR31", "AR32", "AR33", "AR34", "AR35", "AR36", "AR37", "AR38", "AR39", "AR40", "AR41", "AR42", "AR43", "AR44", "AR45", "AR46", "AR47", "AR48", "AR49", "AR50", "AR51", "AR52", "AR53", "AR54", "AR55", "AR56", "AR57", "AR58", "AR59", "AR60", "AR61", "AR62", "AR63", "AR64", "AR65", "AR66", "AR67", "AR68", "AR69", "AR70", "AR71", "AR72", "AR73", "AR74", "AR75", "AR76", "AR77", "AR78", "AR79", "AR80", "AR81", "AR82", "AR83", "AR84", "AR85", "AR86", "AR87", "AR88", "AR89", "AR90", "AR91", "AR92", "AR93", "AR94", "AR95", "AR96", "AR97", "AR98", "AR99", "AR100", "AR101", "AR102", "AR103", "AR104", "AR105", "AR106", "AR107", "AR108", "AR109", "AR110", "AR111", "AR112", "AR113", "AR114", "AR115", "AR116", "AR117", "AR118", "AR119", "AR120", "AR121", "AR122", "AR123", "AR124", "AR125", "AR126", "AR127", "AR128") AS 
  SELECT
   rq,
   rt,
   rt_version,
   description,
   descr_doc,
   descr_doc_version,
   sampling_date,
   sampling_date_tz,
   creation_date,
   creation_date_tz,
   created_by,
   exec_start_date,
   exec_start_date_tz,
   exec_end_date,
   exec_end_date_tz,
   due_date,
   due_date_tz,
   priority,
   label_format,
   date1,
   date1_tz,
   date2,
   date2_tz,
   date3,
   date3_tz,
   date4,
   date4_tz,
   date5,
   date5_tz,
   allow_any_st,
   allow_new_sc,
   responsible,
   sc_counter,
   rq_counter,
   last_comment,
   rq_class,
   log_hs,
   log_hs_details,
   allow_modify,
   active,
   lc,
   lc_version,
   ss,
   ar1,
   ar2,
   ar3,
   ar4,
   ar5,
   ar6,
   ar7,
   ar8,
   ar9,
   ar10,
   ar11,
   ar12,
   ar13,
   ar14,
   ar15,
   ar16,
   'N' ar17,
   'N' ar18,
   'N' ar19,
   'N' ar20,
   'N' ar21,
   'N' ar22,
   'N' ar23,
   'N' ar24,
   'N' ar25,
   'N' ar26,
   'N' ar27,
   'N' ar28,
   'N' ar29,
   'N' ar30,
   'N' ar31,
   'N' ar32,
   'N' ar33,
   'N' ar34,
   'N' ar35,
   'N' ar36,
   'N' ar37,
   'N' ar38,
   'N' ar39,
   'N' ar40,
   'N' ar41,
   'N' ar42,
   'N' ar43,
   'N' ar44,
   'N' ar45,
   'N' ar46,
   'N' ar47,
   'N' ar48,
   'N' ar49,
   'N' ar50,
   'N' ar51,
   'N' ar52,
   'N' ar53,
   'N' ar54,
   'N' ar55,
   'N' ar56,
   'N' ar57,
   'N' ar58,
   'N' ar59,
   'N' ar60,
   'N' ar61,
   'N' ar62,
   'N' ar63,
   'N' ar64,
   'N' ar65,
   'N' ar66,
   'N' ar67,
   'N' ar68,
   'N' ar69,
   'N' ar70,
   'N' ar71,
   'N' ar72,
   'N' ar73,
   'N' ar74,
   'N' ar75,
   'N' ar76,
   'N' ar77,
   'N' ar78,
   'N' ar79,
   'N' ar80,
   'N' ar81,
   'N' ar82,
   'N' ar83,
   'N' ar84,
   'N' ar85,
   'N' ar86,
   'N' ar87,
   'N' ar88,
   'N' ar89,
   'N' ar90,
   'N' ar91,
   'N' ar92,
   'N' ar93,
   'N' ar94,
   'N' ar95,
   'N' ar96,
   'N' ar97,
   'N' ar98,
   'N' ar99,
   'N' ar100,
   'N' ar101,
   'N' ar102,
   'N' ar103,
   'N' ar104,
   'N' ar105,
   'N' ar106,
   'N' ar107,
   'N' ar108,
   'N' ar109,
   'N' ar110,
   'N' ar111,
   'N' ar112,
   'N' ar113,
   'N' ar114,
   'N' ar115,
   'N' ar116,
   'N' ar117,
   'N' ar118,
   'N' ar119,
   'N' ar120,
   'N' ar121,
   'N' ar122,
   'N' ar123,
   'N' ar124,
   'N' ar125,
   'N' ar126,
   'N' ar127,
   'N' ar128
FROM "UNILAB".utrq;
--------------------------------------------------------
--  DDL for View UDRQIC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UDRQIC" ("RQ", "IC", "ICNODE", "IP_VERSION", "DESCRIPTION", "WINSIZE_X", "WINSIZE_Y", "IS_PROTECTED", "HIDDEN", "MANUALLY_ADDED", "NEXT_II", "LAST_COMMENT", "IC_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR1", "AR2", "AR3", "AR4", "AR5", "AR6", "AR7", "AR8", "AR9", "AR10", "AR11", "AR12", "AR13", "AR14", "AR15", "AR16", "AR17", "AR18", "AR19", "AR20", "AR21", "AR22", "AR23", "AR24", "AR25", "AR26", "AR27", "AR28", "AR29", "AR30", "AR31", "AR32", "AR33", "AR34", "AR35", "AR36", "AR37", "AR38", "AR39", "AR40", "AR41", "AR42", "AR43", "AR44", "AR45", "AR46", "AR47", "AR48", "AR49", "AR50", "AR51", "AR52", "AR53", "AR54", "AR55", "AR56", "AR57", "AR58", "AR59", "AR60", "AR61", "AR62", "AR63", "AR64", "AR65", "AR66", "AR67", "AR68", "AR69", "AR70", "AR71", "AR72", "AR73", "AR74", "AR75", "AR76", "AR77", "AR78", "AR79", "AR80", "AR81", "AR82", "AR83", "AR84", "AR85", "AR86", "AR87", "AR88", "AR89", "AR90", "AR91", "AR92", "AR93", "AR94", "AR95", "AR96", "AR97", "AR98", "AR99", "AR100", "AR101", "AR102", "AR103", "AR104", "AR105", "AR106", "AR107", "AR108", "AR109", "AR110", "AR111", "AR112", "AR113", "AR114", "AR115", "AR116", "AR117", "AR118", "AR119", "AR120", "AR121", "AR122", "AR123", "AR124", "AR125", "AR126", "AR127", "AR128") AS 
  SELECT
   rq,
   ic,
   icnode,
   ip_version,
   description,
   winsize_x,
   winsize_y,
   is_protected,
   hidden,
   manually_added,
   next_ii,
   last_comment,
   ic_class,
   log_hs,
   log_hs_details,
   allow_modify,
   active,
   lc,
   lc_version,
   ss,
   ar1,
   ar2,
   ar3,
   ar4,
   ar5,
   ar6,
   ar7,
   ar8,
   ar9,
   ar10,
   ar11,
   ar12,
   ar13,
   ar14,
   ar15,
   ar16,
   'N' ar17,
   'N' ar18,
   'N' ar19,
   'N' ar20,
   'N' ar21,
   'N' ar22,
   'N' ar23,
   'N' ar24,
   'N' ar25,
   'N' ar26,
   'N' ar27,
   'N' ar28,
   'N' ar29,
   'N' ar30,
   'N' ar31,
   'N' ar32,
   'N' ar33,
   'N' ar34,
   'N' ar35,
   'N' ar36,
   'N' ar37,
   'N' ar38,
   'N' ar39,
   'N' ar40,
   'N' ar41,
   'N' ar42,
   'N' ar43,
   'N' ar44,
   'N' ar45,
   'N' ar46,
   'N' ar47,
   'N' ar48,
   'N' ar49,
   'N' ar50,
   'N' ar51,
   'N' ar52,
   'N' ar53,
   'N' ar54,
   'N' ar55,
   'N' ar56,
   'N' ar57,
   'N' ar58,
   'N' ar59,
   'N' ar60,
   'N' ar61,
   'N' ar62,
   'N' ar63,
   'N' ar64,
   'N' ar65,
   'N' ar66,
   'N' ar67,
   'N' ar68,
   'N' ar69,
   'N' ar70,
   'N' ar71,
   'N' ar72,
   'N' ar73,
   'N' ar74,
   'N' ar75,
   'N' ar76,
   'N' ar77,
   'N' ar78,
   'N' ar79,
   'N' ar80,
   'N' ar81,
   'N' ar82,
   'N' ar83,
   'N' ar84,
   'N' ar85,
   'N' ar86,
   'N' ar87,
   'N' ar88,
   'N' ar89,
   'N' ar90,
   'N' ar91,
   'N' ar92,
   'N' ar93,
   'N' ar94,
   'N' ar95,
   'N' ar96,
   'N' ar97,
   'N' ar98,
   'N' ar99,
   'N' ar100,
   'N' ar101,
   'N' ar102,
   'N' ar103,
   'N' ar104,
   'N' ar105,
   'N' ar106,
   'N' ar107,
   'N' ar108,
   'N' ar109,
   'N' ar110,
   'N' ar111,
   'N' ar112,
   'N' ar113,
   'N' ar114,
   'N' ar115,
   'N' ar116,
   'N' ar117,
   'N' ar118,
   'N' ar119,
   'N' ar120,
   'N' ar121,
   'N' ar122,
   'N' ar123,
   'N' ar124,
   'N' ar125,
   'N' ar126,
   'N' ar127,
   'N' ar128
FROM "UNILAB".utrqic;
--------------------------------------------------------
--  DDL for View UDRQII
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UDRQII" ("RQ", "IC", "ICNODE", "II", "IINODE", "IE_VERSION", "IIVALUE", "POS_X", "POS_Y", "IS_PROTECTED", "MANDATORY", "HIDDEN", "DSP_TITLE", "DSP_LEN", "DSP_TP", "DSP_ROWS", "II_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR1", "AR2", "AR3", "AR4", "AR5", "AR6", "AR7", "AR8", "AR9", "AR10", "AR11", "AR12", "AR13", "AR14", "AR15", "AR16", "AR17", "AR18", "AR19", "AR20", "AR21", "AR22", "AR23", "AR24", "AR25", "AR26", "AR27", "AR28", "AR29", "AR30", "AR31", "AR32", "AR33", "AR34", "AR35", "AR36", "AR37", "AR38", "AR39", "AR40", "AR41", "AR42", "AR43", "AR44", "AR45", "AR46", "AR47", "AR48", "AR49", "AR50", "AR51", "AR52", "AR53", "AR54", "AR55", "AR56", "AR57", "AR58", "AR59", "AR60", "AR61", "AR62", "AR63", "AR64", "AR65", "AR66", "AR67", "AR68", "AR69", "AR70", "AR71", "AR72", "AR73", "AR74", "AR75", "AR76", "AR77", "AR78", "AR79", "AR80", "AR81", "AR82", "AR83", "AR84", "AR85", "AR86", "AR87", "AR88", "AR89", "AR90", "AR91", "AR92", "AR93", "AR94", "AR95", "AR96", "AR97", "AR98", "AR99", "AR100", "AR101", "AR102", "AR103", "AR104", "AR105", "AR106", "AR107", "AR108", "AR109", "AR110", "AR111", "AR112", "AR113", "AR114", "AR115", "AR116", "AR117", "AR118", "AR119", "AR120", "AR121", "AR122", "AR123", "AR124", "AR125", "AR126", "AR127", "AR128") AS 
  SELECT
   rq,
   ic,
   icnode,
   ii,
   iinode,
   ie_version,
   iivalue,
   pos_x,
   pos_y,
   is_protected,
   mandatory,
   hidden,
   dsp_title,
   dsp_len,
   dsp_tp,
   dsp_rows,
   ii_class,
   log_hs,
   log_hs_details,
   allow_modify,
   active,
   lc,
   lc_version,
   ss,
   ar1,
   ar2,
   ar3,
   ar4,
   ar5,
   ar6,
   ar7,
   ar8,
   ar9,
   ar10,
   ar11,
   ar12,
   ar13,
   ar14,
   ar15,
   ar16,
   'N' ar17,
   'N' ar18,
   'N' ar19,
   'N' ar20,
   'N' ar21,
   'N' ar22,
   'N' ar23,
   'N' ar24,
   'N' ar25,
   'N' ar26,
   'N' ar27,
   'N' ar28,
   'N' ar29,
   'N' ar30,
   'N' ar31,
   'N' ar32,
   'N' ar33,
   'N' ar34,
   'N' ar35,
   'N' ar36,
   'N' ar37,
   'N' ar38,
   'N' ar39,
   'N' ar40,
   'N' ar41,
   'N' ar42,
   'N' ar43,
   'N' ar44,
   'N' ar45,
   'N' ar46,
   'N' ar47,
   'N' ar48,
   'N' ar49,
   'N' ar50,
   'N' ar51,
   'N' ar52,
   'N' ar53,
   'N' ar54,
   'N' ar55,
   'N' ar56,
   'N' ar57,
   'N' ar58,
   'N' ar59,
   'N' ar60,
   'N' ar61,
   'N' ar62,
   'N' ar63,
   'N' ar64,
   'N' ar65,
   'N' ar66,
   'N' ar67,
   'N' ar68,
   'N' ar69,
   'N' ar70,
   'N' ar71,
   'N' ar72,
   'N' ar73,
   'N' ar74,
   'N' ar75,
   'N' ar76,
   'N' ar77,
   'N' ar78,
   'N' ar79,
   'N' ar80,
   'N' ar81,
   'N' ar82,
   'N' ar83,
   'N' ar84,
   'N' ar85,
   'N' ar86,
   'N' ar87,
   'N' ar88,
   'N' ar89,
   'N' ar90,
   'N' ar91,
   'N' ar92,
   'N' ar93,
   'N' ar94,
   'N' ar95,
   'N' ar96,
   'N' ar97,
   'N' ar98,
   'N' ar99,
   'N' ar100,
   'N' ar101,
   'N' ar102,
   'N' ar103,
   'N' ar104,
   'N' ar105,
   'N' ar106,
   'N' ar107,
   'N' ar108,
   'N' ar109,
   'N' ar110,
   'N' ar111,
   'N' ar112,
   'N' ar113,
   'N' ar114,
   'N' ar115,
   'N' ar116,
   'N' ar117,
   'N' ar118,
   'N' ar119,
   'N' ar120,
   'N' ar121,
   'N' ar122,
   'N' ar123,
   'N' ar124,
   'N' ar125,
   'N' ar126,
   'N' ar127,
   'N' ar128
FROM "UNILAB".utrqii;
--------------------------------------------------------
--  DDL for View UDRSCME
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UDRSCME" ("SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE", "MT_VERSION", "DESCRIPTION", "VALUE_F", "VALUE_S", "UNIT", "EXEC_START_DATE", "EXEC_START_DATE_TZ", "EXEC_END_DATE", "EXEC_END_DATE_TZ", "EXECUTOR", "LAB", "EQ", "EQ_VERSION", "PLANNED_EXECUTOR", "PLANNED_EQ", "PLANNED_EQ_VERSION", "MANUALLY_ENTERED", "ALLOW_ADD", "ASSIGN_DATE", "ASSIGN_DATE_TZ", "ASSIGNED_BY", "MANUALLY_ADDED", "DELAY", "DELAY_UNIT", "FORMAT", "ACCURACY", "REAL_COST", "REAL_TIME", "CALIBRATION", "CONFIRM_COMPLETE", "AUTORECALC", "ME_RESULT_EDITABLE", "NEXT_CELL", "SOP", "SOP_VERSION", "PLAUS_LOW", "PLAUS_HIGH", "WINSIZE_X", "WINSIZE_Y", "REANALYSIS", "LAST_COMMENT", "ME_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR1", "AR2", "AR3", "AR4", "AR5", "AR6", "AR7", "AR8", "AR9", "AR10", "AR11", "AR12", "AR13", "AR14", "AR15", "AR16", "AR17", "AR18", "AR19", "AR20", "AR21", "AR22", "AR23", "AR24", "AR25", "AR26", "AR27", "AR28", "AR29", "AR30", "AR31", "AR32", "AR33", "AR34", "AR35", "AR36", "AR37", "AR38", "AR39", "AR40", "AR41", "AR42", "AR43", "AR44", "AR45", "AR46", "AR47", "AR48", "AR49", "AR50", "AR51", "AR52", "AR53", "AR54", "AR55", "AR56", "AR57", "AR58", "AR59", "AR60", "AR61", "AR62", "AR63", "AR64", "AR65", "AR66", "AR67", "AR68", "AR69", "AR70", "AR71", "AR72", "AR73", "AR74", "AR75", "AR76", "AR77", "AR78", "AR79", "AR80", "AR81", "AR82", "AR83", "AR84", "AR85", "AR86", "AR87", "AR88", "AR89", "AR90", "AR91", "AR92", "AR93", "AR94", "AR95", "AR96", "AR97", "AR98", "AR99", "AR100", "AR101", "AR102", "AR103", "AR104", "AR105", "AR106", "AR107", "AR108", "AR109", "AR110", "AR111", "AR112", "AR113", "AR114", "AR115", "AR116", "AR117", "AR118", "AR119", "AR120", "AR121", "AR122", "AR123", "AR124", "AR125", "AR126", "AR127", "AR128") AS 
  SELECT
   sc,
   pg,
   pgnode,
   pa,
   panode,
   me,
   menode,
   mt_version,
   description,
   value_f,
   value_s,
   unit,
   exec_start_date,
   exec_start_date_tz,
   exec_end_date,
   exec_end_date_tz,
   executor,
   lab,
   eq,
   eq_version,
   planned_executor,
   planned_eq,
   planned_eq_version,
   manually_entered,
   allow_add,
   assign_date,
   assign_date_tz,
   assigned_by,
   manually_added,
   delay,
   delay_unit,
   format,
   accuracy,
   real_cost,
   real_time,
   calibration,
   confirm_complete,
   autorecalc,
   me_result_editable,
   next_cell,
   sop,
   sop_version,
   plaus_low,
   plaus_high,
   winsize_x,
   winsize_y,
   reanalysis,
   last_comment,
   me_class,
   log_hs,
   log_hs_details,
   allow_modify,
   active,
   lc,
   lc_version,
   ss,
   ar1,
   ar2,
   ar3,
   ar4,
   ar5,
   ar6,
   ar7,
   ar8,
   ar9,
   ar10,
   ar11,
   ar12,
   ar13,
   ar14,
   ar15,
   ar16,
   'N' ar17,
   'N' ar18,
   'N' ar19,
   'N' ar20,
   'N' ar21,
   'N' ar22,
   'N' ar23,
   'N' ar24,
   'N' ar25,
   'N' ar26,
   'N' ar27,
   'N' ar28,
   'N' ar29,
   'N' ar30,
   'N' ar31,
   'N' ar32,
   'N' ar33,
   'N' ar34,
   'N' ar35,
   'N' ar36,
   'N' ar37,
   'N' ar38,
   'N' ar39,
   'N' ar40,
   'N' ar41,
   'N' ar42,
   'N' ar43,
   'N' ar44,
   'N' ar45,
   'N' ar46,
   'N' ar47,
   'N' ar48,
   'N' ar49,
   'N' ar50,
   'N' ar51,
   'N' ar52,
   'N' ar53,
   'N' ar54,
   'N' ar55,
   'N' ar56,
   'N' ar57,
   'N' ar58,
   'N' ar59,
   'N' ar60,
   'N' ar61,
   'N' ar62,
   'N' ar63,
   'N' ar64,
   'N' ar65,
   'N' ar66,
   'N' ar67,
   'N' ar68,
   'N' ar69,
   'N' ar70,
   'N' ar71,
   'N' ar72,
   'N' ar73,
   'N' ar74,
   'N' ar75,
   'N' ar76,
   'N' ar77,
   'N' ar78,
   'N' ar79,
   'N' ar80,
   'N' ar81,
   'N' ar82,
   'N' ar83,
   'N' ar84,
   'N' ar85,
   'N' ar86,
   'N' ar87,
   'N' ar88,
   'N' ar89,
   'N' ar90,
   'N' ar91,
   'N' ar92,
   'N' ar93,
   'N' ar94,
   'N' ar95,
   'N' ar96,
   'N' ar97,
   'N' ar98,
   'N' ar99,
   'N' ar100,
   'N' ar101,
   'N' ar102,
   'N' ar103,
   'N' ar104,
   'N' ar105,
   'N' ar106,
   'N' ar107,
   'N' ar108,
   'N' ar109,
   'N' ar110,
   'N' ar111,
   'N' ar112,
   'N' ar113,
   'N' ar114,
   'N' ar115,
   'N' ar116,
   'N' ar117,
   'N' ar118,
   'N' ar119,
   'N' ar120,
   'N' ar121,
   'N' ar122,
   'N' ar123,
   'N' ar124,
   'N' ar125,
   'N' ar126,
   'N' ar127,
   'N' ar128
FROM "UNILAB".utrscme;
--------------------------------------------------------
--  DDL for View UDRSCPA
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UDRSCPA" ("SC", "PG", "PGNODE", "PA", "PANODE", "PR_VERSION", "DESCRIPTION", "VALUE_F", "VALUE_S", "UNIT", "EXEC_START_DATE", "EXEC_START_DATE_TZ", "EXEC_END_DATE", "EXEC_END_DATE_TZ", "EXECUTOR", "PLANNED_EXECUTOR", "MANUALLY_ENTERED", "ASSIGN_DATE", "ASSIGN_DATE_TZ", "ASSIGNED_BY", "MANUALLY_ADDED", "FORMAT", "TD_INFO", "TD_INFO_UNIT", "CONFIRM_UID", "ALLOW_ANY_ME", "DELAY", "DELAY_UNIT", "MIN_NR_RESULTS", "CALC_METHOD", "CALC_CF", "ALARM_ORDER", "VALID_SPECSA", "VALID_SPECSB", "VALID_SPECSC", "VALID_LIMITSA", "VALID_LIMITSB", "VALID_LIMITSC", "VALID_TARGETA", "VALID_TARGETB", "VALID_TARGETC", "LOG_EXCEPTIONS", "REANALYSIS", "LAST_COMMENT", "PA_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR1", "AR2", "AR3", "AR4", "AR5", "AR6", "AR7", "AR8", "AR9", "AR10", "AR11", "AR12", "AR13", "AR14", "AR15", "AR16", "AR17", "AR18", "AR19", "AR20", "AR21", "AR22", "AR23", "AR24", "AR25", "AR26", "AR27", "AR28", "AR29", "AR30", "AR31", "AR32", "AR33", "AR34", "AR35", "AR36", "AR37", "AR38", "AR39", "AR40", "AR41", "AR42", "AR43", "AR44", "AR45", "AR46", "AR47", "AR48", "AR49", "AR50", "AR51", "AR52", "AR53", "AR54", "AR55", "AR56", "AR57", "AR58", "AR59", "AR60", "AR61", "AR62", "AR63", "AR64", "AR65", "AR66", "AR67", "AR68", "AR69", "AR70", "AR71", "AR72", "AR73", "AR74", "AR75", "AR76", "AR77", "AR78", "AR79", "AR80", "AR81", "AR82", "AR83", "AR84", "AR85", "AR86", "AR87", "AR88", "AR89", "AR90", "AR91", "AR92", "AR93", "AR94", "AR95", "AR96", "AR97", "AR98", "AR99", "AR100", "AR101", "AR102", "AR103", "AR104", "AR105", "AR106", "AR107", "AR108", "AR109", "AR110", "AR111", "AR112", "AR113", "AR114", "AR115", "AR116", "AR117", "AR118", "AR119", "AR120", "AR121", "AR122", "AR123", "AR124", "AR125", "AR126", "AR127", "AR128") AS 
  SELECT
   sc,
   pg,
   pgnode,
   pa,
   panode,
   pr_version,
   description,
   value_f,
   value_s,
   unit,
   exec_start_date,
   exec_start_date_tz,
   exec_end_date,
   exec_end_date_tz,
   executor,
   planned_executor,
   manually_entered,
   assign_date,
   assign_date_tz,
   assigned_by,
   manually_added,
   format,
   td_info,
   td_info_unit,
   confirm_uid,
   allow_any_me,
   delay,
   delay_unit,
   min_nr_results,
   calc_method,
   calc_cf,
   alarm_order,
   valid_specsa,
   valid_specsb,
   valid_specsc,
   valid_limitsa,
   valid_limitsb,
   valid_limitsc,
   valid_targeta,
   valid_targetb,
   valid_targetc,
   log_exceptions,
   reanalysis,
   last_comment,
   pa_class,
   log_hs,
   log_hs_details,
   allow_modify,
   active,
   lc,
   lc_version,
   ss,
   ar1,
   ar2,
   ar3,
   ar4,
   ar5,
   ar6,
   ar7,
   ar8,
   ar9,
   ar10,
   ar11,
   ar12,
   ar13,
   ar14,
   ar15,
   ar16,
   'N' ar17,
   'N' ar18,
   'N' ar19,
   'N' ar20,
   'N' ar21,
   'N' ar22,
   'N' ar23,
   'N' ar24,
   'N' ar25,
   'N' ar26,
   'N' ar27,
   'N' ar28,
   'N' ar29,
   'N' ar30,
   'N' ar31,
   'N' ar32,
   'N' ar33,
   'N' ar34,
   'N' ar35,
   'N' ar36,
   'N' ar37,
   'N' ar38,
   'N' ar39,
   'N' ar40,
   'N' ar41,
   'N' ar42,
   'N' ar43,
   'N' ar44,
   'N' ar45,
   'N' ar46,
   'N' ar47,
   'N' ar48,
   'N' ar49,
   'N' ar50,
   'N' ar51,
   'N' ar52,
   'N' ar53,
   'N' ar54,
   'N' ar55,
   'N' ar56,
   'N' ar57,
   'N' ar58,
   'N' ar59,
   'N' ar60,
   'N' ar61,
   'N' ar62,
   'N' ar63,
   'N' ar64,
   'N' ar65,
   'N' ar66,
   'N' ar67,
   'N' ar68,
   'N' ar69,
   'N' ar70,
   'N' ar71,
   'N' ar72,
   'N' ar73,
   'N' ar74,
   'N' ar75,
   'N' ar76,
   'N' ar77,
   'N' ar78,
   'N' ar79,
   'N' ar80,
   'N' ar81,
   'N' ar82,
   'N' ar83,
   'N' ar84,
   'N' ar85,
   'N' ar86,
   'N' ar87,
   'N' ar88,
   'N' ar89,
   'N' ar90,
   'N' ar91,
   'N' ar92,
   'N' ar93,
   'N' ar94,
   'N' ar95,
   'N' ar96,
   'N' ar97,
   'N' ar98,
   'N' ar99,
   'N' ar100,
   'N' ar101,
   'N' ar102,
   'N' ar103,
   'N' ar104,
   'N' ar105,
   'N' ar106,
   'N' ar107,
   'N' ar108,
   'N' ar109,
   'N' ar110,
   'N' ar111,
   'N' ar112,
   'N' ar113,
   'N' ar114,
   'N' ar115,
   'N' ar116,
   'N' ar117,
   'N' ar118,
   'N' ar119,
   'N' ar120,
   'N' ar121,
   'N' ar122,
   'N' ar123,
   'N' ar124,
   'N' ar125,
   'N' ar126,
   'N' ar127,
   'N' ar128
FROM "UNILAB".utrscpa;
--------------------------------------------------------
--  DDL for View UDRSCPG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UDRSCPG" ("SC", "PG", "PGNODE", "PP_VERSION", "PP_KEY1", "PP_KEY2", "PP_KEY3", "PP_KEY4", "PP_KEY5", "DESCRIPTION", "VALUE_F", "VALUE_S", "UNIT", "EXEC_START_DATE", "EXEC_START_DATE_TZ", "EXEC_END_DATE", "EXEC_END_DATE_TZ", "EXECUTOR", "PLANNED_EXECUTOR", "MANUALLY_ENTERED", "ASSIGN_DATE", "ASSIGN_DATE_TZ", "ASSIGNED_BY", "MANUALLY_ADDED", "FORMAT", "CONFIRM_ASSIGN", "ALLOW_ANY_PR", "NEVER_CREATE_METHODS", "DELAY", "DELAY_UNIT", "REANALYSIS", "LAST_COMMENT", "PG_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR1", "AR2", "AR3", "AR4", "AR5", "AR6", "AR7", "AR8", "AR9", "AR10", "AR11", "AR12", "AR13", "AR14", "AR15", "AR16", "AR17", "AR18", "AR19", "AR20", "AR21", "AR22", "AR23", "AR24", "AR25", "AR26", "AR27", "AR28", "AR29", "AR30", "AR31", "AR32", "AR33", "AR34", "AR35", "AR36", "AR37", "AR38", "AR39", "AR40", "AR41", "AR42", "AR43", "AR44", "AR45", "AR46", "AR47", "AR48", "AR49", "AR50", "AR51", "AR52", "AR53", "AR54", "AR55", "AR56", "AR57", "AR58", "AR59", "AR60", "AR61", "AR62", "AR63", "AR64", "AR65", "AR66", "AR67", "AR68", "AR69", "AR70", "AR71", "AR72", "AR73", "AR74", "AR75", "AR76", "AR77", "AR78", "AR79", "AR80", "AR81", "AR82", "AR83", "AR84", "AR85", "AR86", "AR87", "AR88", "AR89", "AR90", "AR91", "AR92", "AR93", "AR94", "AR95", "AR96", "AR97", "AR98", "AR99", "AR100", "AR101", "AR102", "AR103", "AR104", "AR105", "AR106", "AR107", "AR108", "AR109", "AR110", "AR111", "AR112", "AR113", "AR114", "AR115", "AR116", "AR117", "AR118", "AR119", "AR120", "AR121", "AR122", "AR123", "AR124", "AR125", "AR126", "AR127", "AR128") AS 
  SELECT
   sc,
   pg,
   pgnode,
   pp_version,
   pp_key1,
   pp_key2,
   pp_key3,
   pp_key4,
   pp_key5,
   description,
   value_f,
   value_s,
   unit,
   exec_start_date,
   exec_start_date_tz,
   exec_end_date,
   exec_end_date_tz,
   executor,
   planned_executor,
   manually_entered,
   assign_date,
   assign_date_tz,
   assigned_by,
   manually_added,
   format,
   confirm_assign,
   allow_any_pr,
   never_create_methods,
   delay,
   delay_unit,
   reanalysis,
   last_comment,
   pg_class,
   log_hs,
   log_hs_details,
   allow_modify,
   active,
   lc,
   lc_version,
   ss,
   ar1,
   ar2,
   ar3,
   ar4,
   ar5,
   ar6,
   ar7,
   ar8,
   ar9,
   ar10,
   ar11,
   ar12,
   ar13,
   ar14,
   ar15,
   ar16,
   'N' ar17,
   'N' ar18,
   'N' ar19,
   'N' ar20,
   'N' ar21,
   'N' ar22,
   'N' ar23,
   'N' ar24,
   'N' ar25,
   'N' ar26,
   'N' ar27,
   'N' ar28,
   'N' ar29,
   'N' ar30,
   'N' ar31,
   'N' ar32,
   'N' ar33,
   'N' ar34,
   'N' ar35,
   'N' ar36,
   'N' ar37,
   'N' ar38,
   'N' ar39,
   'N' ar40,
   'N' ar41,
   'N' ar42,
   'N' ar43,
   'N' ar44,
   'N' ar45,
   'N' ar46,
   'N' ar47,
   'N' ar48,
   'N' ar49,
   'N' ar50,
   'N' ar51,
   'N' ar52,
   'N' ar53,
   'N' ar54,
   'N' ar55,
   'N' ar56,
   'N' ar57,
   'N' ar58,
   'N' ar59,
   'N' ar60,
   'N' ar61,
   'N' ar62,
   'N' ar63,
   'N' ar64,
   'N' ar65,
   'N' ar66,
   'N' ar67,
   'N' ar68,
   'N' ar69,
   'N' ar70,
   'N' ar71,
   'N' ar72,
   'N' ar73,
   'N' ar74,
   'N' ar75,
   'N' ar76,
   'N' ar77,
   'N' ar78,
   'N' ar79,
   'N' ar80,
   'N' ar81,
   'N' ar82,
   'N' ar83,
   'N' ar84,
   'N' ar85,
   'N' ar86,
   'N' ar87,
   'N' ar88,
   'N' ar89,
   'N' ar90,
   'N' ar91,
   'N' ar92,
   'N' ar93,
   'N' ar94,
   'N' ar95,
   'N' ar96,
   'N' ar97,
   'N' ar98,
   'N' ar99,
   'N' ar100,
   'N' ar101,
   'N' ar102,
   'N' ar103,
   'N' ar104,
   'N' ar105,
   'N' ar106,
   'N' ar107,
   'N' ar108,
   'N' ar109,
   'N' ar110,
   'N' ar111,
   'N' ar112,
   'N' ar113,
   'N' ar114,
   'N' ar115,
   'N' ar116,
   'N' ar117,
   'N' ar118,
   'N' ar119,
   'N' ar120,
   'N' ar121,
   'N' ar122,
   'N' ar123,
   'N' ar124,
   'N' ar125,
   'N' ar126,
   'N' ar127,
   'N' ar128
FROM "UNILAB".utrscpg;
--------------------------------------------------------
--  DDL for View UDRT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UDRT" ("RT", "VERSION", "VERSION_IS_CURRENT", "EFFECTIVE_FROM", "EFFECTIVE_FROM_TZ", "EFFECTIVE_TILL", "EFFECTIVE_TILL_TZ", "DESCRIPTION", "DESCRIPTION2", "DESCR_DOC", "DESCR_DOC_VERSION", "IS_TEMPLATE", "CONFIRM_USERID", "NR_PLANNED_RQ", "FREQ_TP", "FREQ_VAL", "FREQ_UNIT", "INVERT_FREQ", "LAST_SCHED", "LAST_SCHED_TZ", "LAST_CNT", "LAST_VAL", "PRIORITY", "LABEL_FORMAT", "ALLOW_ANY_ST", "ALLOW_NEW_SC", "ADD_STPP", "PLANNED_RESPONSIBLE", "SC_UC", "SC_UC_VERSION", "RQ_UC", "RQ_UC_VERSION", "RQ_LC", "RQ_LC_VERSION", "INHERIT_AU", "INHERIT_GK", "LAST_COMMENT", "RT_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR1", "AR2", "AR3", "AR4", "AR5", "AR6", "AR7", "AR8", "AR9", "AR10", "AR11", "AR12", "AR13", "AR14", "AR15", "AR16", "AR17", "AR18", "AR19", "AR20", "AR21", "AR22", "AR23", "AR24", "AR25", "AR26", "AR27", "AR28", "AR29", "AR30", "AR31", "AR32", "AR33", "AR34", "AR35", "AR36", "AR37", "AR38", "AR39", "AR40", "AR41", "AR42", "AR43", "AR44", "AR45", "AR46", "AR47", "AR48", "AR49", "AR50", "AR51", "AR52", "AR53", "AR54", "AR55", "AR56", "AR57", "AR58", "AR59", "AR60", "AR61", "AR62", "AR63", "AR64", "AR65", "AR66", "AR67", "AR68", "AR69", "AR70", "AR71", "AR72", "AR73", "AR74", "AR75", "AR76", "AR77", "AR78", "AR79", "AR80", "AR81", "AR82", "AR83", "AR84", "AR85", "AR86", "AR87", "AR88", "AR89", "AR90", "AR91", "AR92", "AR93", "AR94", "AR95", "AR96", "AR97", "AR98", "AR99", "AR100", "AR101", "AR102", "AR103", "AR104", "AR105", "AR106", "AR107", "AR108", "AR109", "AR110", "AR111", "AR112", "AR113", "AR114", "AR115", "AR116", "AR117", "AR118", "AR119", "AR120", "AR121", "AR122", "AR123", "AR124", "AR125", "AR126", "AR127", "AR128") AS 
  SELECT
   rt,
   version,
   version_is_current,
   effective_from,
   effective_from_tz,
   effective_till,
   effective_till_tz,
   description,
   description2,
   descr_doc,
   descr_doc_version,
   is_template,
   confirm_userid,
   nr_planned_rq,
   freq_tp,
   freq_val,
   freq_unit,
   invert_freq,
   last_sched,
   last_sched_tz,
   last_cnt,
   last_val,
   priority,
   label_format,
   allow_any_st,
   allow_new_sc,
   add_stpp,
   planned_responsible,
   sc_uc,
   sc_uc_version,
   rq_uc,
   rq_uc_version,
   rq_lc,
   rq_lc_version,
   inherit_au,
   inherit_gk,
   last_comment,
   rt_class,
   log_hs,
   log_hs_details,
   allow_modify,
   active,
   lc,
   lc_version,
   ss,
   ar1,
   ar2,
   ar3,
   ar4,
   ar5,
   ar6,
   ar7,
   ar8,
   ar9,
   ar10,
   ar11,
   ar12,
   ar13,
   ar14,
   ar15,
   ar16,
   'N' ar17,
   'N' ar18,
   'N' ar19,
   'N' ar20,
   'N' ar21,
   'N' ar22,
   'N' ar23,
   'N' ar24,
   'N' ar25,
   'N' ar26,
   'N' ar27,
   'N' ar28,
   'N' ar29,
   'N' ar30,
   'N' ar31,
   'N' ar32,
   'N' ar33,
   'N' ar34,
   'N' ar35,
   'N' ar36,
   'N' ar37,
   'N' ar38,
   'N' ar39,
   'N' ar40,
   'N' ar41,
   'N' ar42,
   'N' ar43,
   'N' ar44,
   'N' ar45,
   'N' ar46,
   'N' ar47,
   'N' ar48,
   'N' ar49,
   'N' ar50,
   'N' ar51,
   'N' ar52,
   'N' ar53,
   'N' ar54,
   'N' ar55,
   'N' ar56,
   'N' ar57,
   'N' ar58,
   'N' ar59,
   'N' ar60,
   'N' ar61,
   'N' ar62,
   'N' ar63,
   'N' ar64,
   'N' ar65,
   'N' ar66,
   'N' ar67,
   'N' ar68,
   'N' ar69,
   'N' ar70,
   'N' ar71,
   'N' ar72,
   'N' ar73,
   'N' ar74,
   'N' ar75,
   'N' ar76,
   'N' ar77,
   'N' ar78,
   'N' ar79,
   'N' ar80,
   'N' ar81,
   'N' ar82,
   'N' ar83,
   'N' ar84,
   'N' ar85,
   'N' ar86,
   'N' ar87,
   'N' ar88,
   'N' ar89,
   'N' ar90,
   'N' ar91,
   'N' ar92,
   'N' ar93,
   'N' ar94,
   'N' ar95,
   'N' ar96,
   'N' ar97,
   'N' ar98,
   'N' ar99,
   'N' ar100,
   'N' ar101,
   'N' ar102,
   'N' ar103,
   'N' ar104,
   'N' ar105,
   'N' ar106,
   'N' ar107,
   'N' ar108,
   'N' ar109,
   'N' ar110,
   'N' ar111,
   'N' ar112,
   'N' ar113,
   'N' ar114,
   'N' ar115,
   'N' ar116,
   'N' ar117,
   'N' ar118,
   'N' ar119,
   'N' ar120,
   'N' ar121,
   'N' ar122,
   'N' ar123,
   'N' ar124,
   'N' ar125,
   'N' ar126,
   'N' ar127,
   'N' ar128
FROM "UNILAB".utrt;
--------------------------------------------------------
--  DDL for View UDSC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UDSC" ("SC", "ST", "ST_VERSION", "DESCRIPTION", "SHELF_LIFE_VAL", "SHELF_LIFE_UNIT", "SAMPLING_DATE", "SAMPLING_DATE_TZ", "CREATION_DATE", "CREATION_DATE_TZ", "CREATED_BY", "EXEC_START_DATE", "EXEC_START_DATE_TZ", "EXEC_END_DATE", "EXEC_END_DATE_TZ", "PRIORITY", "LABEL_FORMAT", "DESCR_DOC", "DESCR_DOC_VERSION", "RQ", "SD", "DATE1", "DATE1_TZ", "DATE2", "DATE2_TZ", "DATE3", "DATE3_TZ", "DATE4", "DATE4_TZ", "DATE5", "DATE5_TZ", "ALLOW_ANY_PP", "LAST_COMMENT", "SC_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR1", "AR2", "AR3", "AR4", "AR5", "AR6", "AR7", "AR8", "AR9", "AR10", "AR11", "AR12", "AR13", "AR14", "AR15", "AR16", "AR17", "AR18", "AR19", "AR20", "AR21", "AR22", "AR23", "AR24", "AR25", "AR26", "AR27", "AR28", "AR29", "AR30", "AR31", "AR32", "AR33", "AR34", "AR35", "AR36", "AR37", "AR38", "AR39", "AR40", "AR41", "AR42", "AR43", "AR44", "AR45", "AR46", "AR47", "AR48", "AR49", "AR50", "AR51", "AR52", "AR53", "AR54", "AR55", "AR56", "AR57", "AR58", "AR59", "AR60", "AR61", "AR62", "AR63", "AR64", "AR65", "AR66", "AR67", "AR68", "AR69", "AR70", "AR71", "AR72", "AR73", "AR74", "AR75", "AR76", "AR77", "AR78", "AR79", "AR80", "AR81", "AR82", "AR83", "AR84", "AR85", "AR86", "AR87", "AR88", "AR89", "AR90", "AR91", "AR92", "AR93", "AR94", "AR95", "AR96", "AR97", "AR98", "AR99", "AR100", "AR101", "AR102", "AR103", "AR104", "AR105", "AR106", "AR107", "AR108", "AR109", "AR110", "AR111", "AR112", "AR113", "AR114", "AR115", "AR116", "AR117", "AR118", "AR119", "AR120", "AR121", "AR122", "AR123", "AR124", "AR125", "AR126", "AR127", "AR128") AS 
  SELECT
   sc,
   st,
   st_version,
   description,
   shelf_life_val,
   shelf_life_unit,
   sampling_date,
   sampling_date_tz,
   creation_date,
   creation_date_tz,
   created_by,
   exec_start_date,
   exec_start_date_tz,
   exec_end_date,
   exec_end_date_tz,
   priority,
   label_format,
   descr_doc,
   descr_doc_version,
   rq,
   sd,
   date1,
   date1_tz,
   date2,
   date2_tz,
   date3,
   date3_tz,
   date4,
   date4_tz,
   date5,
   date5_tz,
   allow_any_pp,
   last_comment,
   sc_class,
   log_hs,
   log_hs_details,
   allow_modify,
   active,
   lc,
   lc_version,
   ss,
   ar1,
   ar2,
   ar3,
   ar4,
   ar5,
   ar6,
   ar7,
   ar8,
   ar9,
   ar10,
   ar11,
   ar12,
   ar13,
   ar14,
   ar15,
   ar16,
   'N' ar17,
   'N' ar18,
   'N' ar19,
   'N' ar20,
   'N' ar21,
   'N' ar22,
   'N' ar23,
   'N' ar24,
   'N' ar25,
   'N' ar26,
   'N' ar27,
   'N' ar28,
   'N' ar29,
   'N' ar30,
   'N' ar31,
   'N' ar32,
   'N' ar33,
   'N' ar34,
   'N' ar35,
   'N' ar36,
   'N' ar37,
   'N' ar38,
   'N' ar39,
   'N' ar40,
   'N' ar41,
   'N' ar42,
   'N' ar43,
   'N' ar44,
   'N' ar45,
   'N' ar46,
   'N' ar47,
   'N' ar48,
   'N' ar49,
   'N' ar50,
   'N' ar51,
   'N' ar52,
   'N' ar53,
   'N' ar54,
   'N' ar55,
   'N' ar56,
   'N' ar57,
   'N' ar58,
   'N' ar59,
   'N' ar60,
   'N' ar61,
   'N' ar62,
   'N' ar63,
   'N' ar64,
   'N' ar65,
   'N' ar66,
   'N' ar67,
   'N' ar68,
   'N' ar69,
   'N' ar70,
   'N' ar71,
   'N' ar72,
   'N' ar73,
   'N' ar74,
   'N' ar75,
   'N' ar76,
   'N' ar77,
   'N' ar78,
   'N' ar79,
   'N' ar80,
   'N' ar81,
   'N' ar82,
   'N' ar83,
   'N' ar84,
   'N' ar85,
   'N' ar86,
   'N' ar87,
   'N' ar88,
   'N' ar89,
   'N' ar90,
   'N' ar91,
   'N' ar92,
   'N' ar93,
   'N' ar94,
   'N' ar95,
   'N' ar96,
   'N' ar97,
   'N' ar98,
   'N' ar99,
   'N' ar100,
   'N' ar101,
   'N' ar102,
   'N' ar103,
   'N' ar104,
   'N' ar105,
   'N' ar106,
   'N' ar107,
   'N' ar108,
   'N' ar109,
   'N' ar110,
   'N' ar111,
   'N' ar112,
   'N' ar113,
   'N' ar114,
   'N' ar115,
   'N' ar116,
   'N' ar117,
   'N' ar118,
   'N' ar119,
   'N' ar120,
   'N' ar121,
   'N' ar122,
   'N' ar123,
   'N' ar124,
   'N' ar125,
   'N' ar126,
   'N' ar127,
   'N' ar128
FROM "UNILAB".utsc;
--------------------------------------------------------
--  DDL for View UDSCIC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UDSCIC" ("SC", "IC", "ICNODE", "IP_VERSION", "DESCRIPTION", "WINSIZE_X", "WINSIZE_Y", "IS_PROTECTED", "HIDDEN", "MANUALLY_ADDED", "NEXT_II", "LAST_COMMENT", "IC_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR1", "AR2", "AR3", "AR4", "AR5", "AR6", "AR7", "AR8", "AR9", "AR10", "AR11", "AR12", "AR13", "AR14", "AR15", "AR16", "AR17", "AR18", "AR19", "AR20", "AR21", "AR22", "AR23", "AR24", "AR25", "AR26", "AR27", "AR28", "AR29", "AR30", "AR31", "AR32", "AR33", "AR34", "AR35", "AR36", "AR37", "AR38", "AR39", "AR40", "AR41", "AR42", "AR43", "AR44", "AR45", "AR46", "AR47", "AR48", "AR49", "AR50", "AR51", "AR52", "AR53", "AR54", "AR55", "AR56", "AR57", "AR58", "AR59", "AR60", "AR61", "AR62", "AR63", "AR64", "AR65", "AR66", "AR67", "AR68", "AR69", "AR70", "AR71", "AR72", "AR73", "AR74", "AR75", "AR76", "AR77", "AR78", "AR79", "AR80", "AR81", "AR82", "AR83", "AR84", "AR85", "AR86", "AR87", "AR88", "AR89", "AR90", "AR91", "AR92", "AR93", "AR94", "AR95", "AR96", "AR97", "AR98", "AR99", "AR100", "AR101", "AR102", "AR103", "AR104", "AR105", "AR106", "AR107", "AR108", "AR109", "AR110", "AR111", "AR112", "AR113", "AR114", "AR115", "AR116", "AR117", "AR118", "AR119", "AR120", "AR121", "AR122", "AR123", "AR124", "AR125", "AR126", "AR127", "AR128") AS 
  SELECT
   sc,
   ic,
   icnode,
   ip_version,
   description,
   winsize_x,
   winsize_y,
   is_protected,
   hidden,
   manually_added,
   next_ii,
   last_comment,
   ic_class,
   log_hs,
   log_hs_details,
   allow_modify,
   active,
   lc,
   lc_version,
   ss,
   ar1,
   ar2,
   ar3,
   ar4,
   ar5,
   ar6,
   ar7,
   ar8,
   ar9,
   ar10,
   ar11,
   ar12,
   ar13,
   ar14,
   ar15,
   ar16,
   'N' ar17,
   'N' ar18,
   'N' ar19,
   'N' ar20,
   'N' ar21,
   'N' ar22,
   'N' ar23,
   'N' ar24,
   'N' ar25,
   'N' ar26,
   'N' ar27,
   'N' ar28,
   'N' ar29,
   'N' ar30,
   'N' ar31,
   'N' ar32,
   'N' ar33,
   'N' ar34,
   'N' ar35,
   'N' ar36,
   'N' ar37,
   'N' ar38,
   'N' ar39,
   'N' ar40,
   'N' ar41,
   'N' ar42,
   'N' ar43,
   'N' ar44,
   'N' ar45,
   'N' ar46,
   'N' ar47,
   'N' ar48,
   'N' ar49,
   'N' ar50,
   'N' ar51,
   'N' ar52,
   'N' ar53,
   'N' ar54,
   'N' ar55,
   'N' ar56,
   'N' ar57,
   'N' ar58,
   'N' ar59,
   'N' ar60,
   'N' ar61,
   'N' ar62,
   'N' ar63,
   'N' ar64,
   'N' ar65,
   'N' ar66,
   'N' ar67,
   'N' ar68,
   'N' ar69,
   'N' ar70,
   'N' ar71,
   'N' ar72,
   'N' ar73,
   'N' ar74,
   'N' ar75,
   'N' ar76,
   'N' ar77,
   'N' ar78,
   'N' ar79,
   'N' ar80,
   'N' ar81,
   'N' ar82,
   'N' ar83,
   'N' ar84,
   'N' ar85,
   'N' ar86,
   'N' ar87,
   'N' ar88,
   'N' ar89,
   'N' ar90,
   'N' ar91,
   'N' ar92,
   'N' ar93,
   'N' ar94,
   'N' ar95,
   'N' ar96,
   'N' ar97,
   'N' ar98,
   'N' ar99,
   'N' ar100,
   'N' ar101,
   'N' ar102,
   'N' ar103,
   'N' ar104,
   'N' ar105,
   'N' ar106,
   'N' ar107,
   'N' ar108,
   'N' ar109,
   'N' ar110,
   'N' ar111,
   'N' ar112,
   'N' ar113,
   'N' ar114,
   'N' ar115,
   'N' ar116,
   'N' ar117,
   'N' ar118,
   'N' ar119,
   'N' ar120,
   'N' ar121,
   'N' ar122,
   'N' ar123,
   'N' ar124,
   'N' ar125,
   'N' ar126,
   'N' ar127,
   'N' ar128
FROM "UNILAB".utscic;
--------------------------------------------------------
--  DDL for View UDSCII
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UDSCII" ("SC", "IC", "ICNODE", "II", "IINODE", "IE_VERSION", "IIVALUE", "POS_X", "POS_Y", "IS_PROTECTED", "MANDATORY", "HIDDEN", "DSP_TITLE", "DSP_LEN", "DSP_TP", "DSP_ROWS", "II_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR1", "AR2", "AR3", "AR4", "AR5", "AR6", "AR7", "AR8", "AR9", "AR10", "AR11", "AR12", "AR13", "AR14", "AR15", "AR16", "AR17", "AR18", "AR19", "AR20", "AR21", "AR22", "AR23", "AR24", "AR25", "AR26", "AR27", "AR28", "AR29", "AR30", "AR31", "AR32", "AR33", "AR34", "AR35", "AR36", "AR37", "AR38", "AR39", "AR40", "AR41", "AR42", "AR43", "AR44", "AR45", "AR46", "AR47", "AR48", "AR49", "AR50", "AR51", "AR52", "AR53", "AR54", "AR55", "AR56", "AR57", "AR58", "AR59", "AR60", "AR61", "AR62", "AR63", "AR64", "AR65", "AR66", "AR67", "AR68", "AR69", "AR70", "AR71", "AR72", "AR73", "AR74", "AR75", "AR76", "AR77", "AR78", "AR79", "AR80", "AR81", "AR82", "AR83", "AR84", "AR85", "AR86", "AR87", "AR88", "AR89", "AR90", "AR91", "AR92", "AR93", "AR94", "AR95", "AR96", "AR97", "AR98", "AR99", "AR100", "AR101", "AR102", "AR103", "AR104", "AR105", "AR106", "AR107", "AR108", "AR109", "AR110", "AR111", "AR112", "AR113", "AR114", "AR115", "AR116", "AR117", "AR118", "AR119", "AR120", "AR121", "AR122", "AR123", "AR124", "AR125", "AR126", "AR127", "AR128") AS 
  SELECT
   sc,
   ic,
   icnode,
   ii,
   iinode,
   ie_version,
   iivalue,
   pos_x,
   pos_y,
   is_protected,
   mandatory,
   hidden,
   dsp_title,
   dsp_len,
   dsp_tp,
   dsp_rows,
   ii_class,
   log_hs,
   log_hs_details,
   allow_modify,
   active,
   lc,
   lc_version,
   ss,
   ar1,
   ar2,
   ar3,
   ar4,
   ar5,
   ar6,
   ar7,
   ar8,
   ar9,
   ar10,
   ar11,
   ar12,
   ar13,
   ar14,
   ar15,
   ar16,
   'N' ar17,
   'N' ar18,
   'N' ar19,
   'N' ar20,
   'N' ar21,
   'N' ar22,
   'N' ar23,
   'N' ar24,
   'N' ar25,
   'N' ar26,
   'N' ar27,
   'N' ar28,
   'N' ar29,
   'N' ar30,
   'N' ar31,
   'N' ar32,
   'N' ar33,
   'N' ar34,
   'N' ar35,
   'N' ar36,
   'N' ar37,
   'N' ar38,
   'N' ar39,
   'N' ar40,
   'N' ar41,
   'N' ar42,
   'N' ar43,
   'N' ar44,
   'N' ar45,
   'N' ar46,
   'N' ar47,
   'N' ar48,
   'N' ar49,
   'N' ar50,
   'N' ar51,
   'N' ar52,
   'N' ar53,
   'N' ar54,
   'N' ar55,
   'N' ar56,
   'N' ar57,
   'N' ar58,
   'N' ar59,
   'N' ar60,
   'N' ar61,
   'N' ar62,
   'N' ar63,
   'N' ar64,
   'N' ar65,
   'N' ar66,
   'N' ar67,
   'N' ar68,
   'N' ar69,
   'N' ar70,
   'N' ar71,
   'N' ar72,
   'N' ar73,
   'N' ar74,
   'N' ar75,
   'N' ar76,
   'N' ar77,
   'N' ar78,
   'N' ar79,
   'N' ar80,
   'N' ar81,
   'N' ar82,
   'N' ar83,
   'N' ar84,
   'N' ar85,
   'N' ar86,
   'N' ar87,
   'N' ar88,
   'N' ar89,
   'N' ar90,
   'N' ar91,
   'N' ar92,
   'N' ar93,
   'N' ar94,
   'N' ar95,
   'N' ar96,
   'N' ar97,
   'N' ar98,
   'N' ar99,
   'N' ar100,
   'N' ar101,
   'N' ar102,
   'N' ar103,
   'N' ar104,
   'N' ar105,
   'N' ar106,
   'N' ar107,
   'N' ar108,
   'N' ar109,
   'N' ar110,
   'N' ar111,
   'N' ar112,
   'N' ar113,
   'N' ar114,
   'N' ar115,
   'N' ar116,
   'N' ar117,
   'N' ar118,
   'N' ar119,
   'N' ar120,
   'N' ar121,
   'N' ar122,
   'N' ar123,
   'N' ar124,
   'N' ar125,
   'N' ar126,
   'N' ar127,
   'N' ar128
FROM "UNILAB".utscii;
--------------------------------------------------------
--  DDL for View UDSCME
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UDSCME" ("SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE", "MT_VERSION", "DESCRIPTION", "VALUE_F", "VALUE_S", "UNIT", "EXEC_START_DATE", "EXEC_START_DATE_TZ", "EXEC_END_DATE", "EXEC_END_DATE_TZ", "EXECUTOR", "LAB", "EQ", "EQ_VERSION", "PLANNED_EXECUTOR", "PLANNED_EQ", "PLANNED_EQ_VERSION", "MANUALLY_ENTERED", "ALLOW_ADD", "ASSIGN_DATE", "ASSIGN_DATE_TZ", "ASSIGNED_BY", "MANUALLY_ADDED", "DELAY", "DELAY_UNIT", "FORMAT", "ACCURACY", "REAL_COST", "REAL_TIME", "CALIBRATION", "CONFIRM_COMPLETE", "AUTORECALC", "ME_RESULT_EDITABLE", "NEXT_CELL", "SOP", "SOP_VERSION", "PLAUS_LOW", "PLAUS_HIGH", "WINSIZE_X", "WINSIZE_Y", "REANALYSIS", "LAST_COMMENT", "ME_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR1", "AR2", "AR3", "AR4", "AR5", "AR6", "AR7", "AR8", "AR9", "AR10", "AR11", "AR12", "AR13", "AR14", "AR15", "AR16", "AR17", "AR18", "AR19", "AR20", "AR21", "AR22", "AR23", "AR24", "AR25", "AR26", "AR27", "AR28", "AR29", "AR30", "AR31", "AR32", "AR33", "AR34", "AR35", "AR36", "AR37", "AR38", "AR39", "AR40", "AR41", "AR42", "AR43", "AR44", "AR45", "AR46", "AR47", "AR48", "AR49", "AR50", "AR51", "AR52", "AR53", "AR54", "AR55", "AR56", "AR57", "AR58", "AR59", "AR60", "AR61", "AR62", "AR63", "AR64", "AR65", "AR66", "AR67", "AR68", "AR69", "AR70", "AR71", "AR72", "AR73", "AR74", "AR75", "AR76", "AR77", "AR78", "AR79", "AR80", "AR81", "AR82", "AR83", "AR84", "AR85", "AR86", "AR87", "AR88", "AR89", "AR90", "AR91", "AR92", "AR93", "AR94", "AR95", "AR96", "AR97", "AR98", "AR99", "AR100", "AR101", "AR102", "AR103", "AR104", "AR105", "AR106", "AR107", "AR108", "AR109", "AR110", "AR111", "AR112", "AR113", "AR114", "AR115", "AR116", "AR117", "AR118", "AR119", "AR120", "AR121", "AR122", "AR123", "AR124", "AR125", "AR126", "AR127", "AR128") AS 
  SELECT
   sc,
   pg,
   pgnode,
   pa,
   panode,
   me,
   menode,
   mt_version,
   description,
   value_f,
   value_s,
   unit,
   exec_start_date,
   exec_start_date_tz,
   exec_end_date,
   exec_end_date_tz,
   executor,
   lab,
   eq,
   eq_version,
   planned_executor,
   planned_eq,
   planned_eq_version,
   manually_entered,
   allow_add,
   assign_date,
   assign_date_tz,
   assigned_by,
   manually_added,
   delay,
   delay_unit,
   format,
   accuracy,
   real_cost,
   real_time,
   calibration,
   confirm_complete,
   autorecalc,
   me_result_editable,
   next_cell,
   sop,
   sop_version,
   plaus_low,
   plaus_high,
   winsize_x,
   winsize_y,
   reanalysis,
   last_comment,
   me_class,
   log_hs,
   log_hs_details,
   allow_modify,
   active,
   lc,
   lc_version,
   ss,
   ar1,
   ar2,
   ar3,
   ar4,
   ar5,
   ar6,
   ar7,
   ar8,
   ar9,
   ar10,
   ar11,
   ar12,
   ar13,
   ar14,
   ar15,
   ar16,
   'N' ar17,
   'N' ar18,
   'N' ar19,
   'N' ar20,
   'N' ar21,
   'N' ar22,
   'N' ar23,
   'N' ar24,
   'N' ar25,
   'N' ar26,
   'N' ar27,
   'N' ar28,
   'N' ar29,
   'N' ar30,
   'N' ar31,
   'N' ar32,
   'N' ar33,
   'N' ar34,
   'N' ar35,
   'N' ar36,
   'N' ar37,
   'N' ar38,
   'N' ar39,
   'N' ar40,
   'N' ar41,
   'N' ar42,
   'N' ar43,
   'N' ar44,
   'N' ar45,
   'N' ar46,
   'N' ar47,
   'N' ar48,
   'N' ar49,
   'N' ar50,
   'N' ar51,
   'N' ar52,
   'N' ar53,
   'N' ar54,
   'N' ar55,
   'N' ar56,
   'N' ar57,
   'N' ar58,
   'N' ar59,
   'N' ar60,
   'N' ar61,
   'N' ar62,
   'N' ar63,
   'N' ar64,
   'N' ar65,
   'N' ar66,
   'N' ar67,
   'N' ar68,
   'N' ar69,
   'N' ar70,
   'N' ar71,
   'N' ar72,
   'N' ar73,
   'N' ar74,
   'N' ar75,
   'N' ar76,
   'N' ar77,
   'N' ar78,
   'N' ar79,
   'N' ar80,
   'N' ar81,
   'N' ar82,
   'N' ar83,
   'N' ar84,
   'N' ar85,
   'N' ar86,
   'N' ar87,
   'N' ar88,
   'N' ar89,
   'N' ar90,
   'N' ar91,
   'N' ar92,
   'N' ar93,
   'N' ar94,
   'N' ar95,
   'N' ar96,
   'N' ar97,
   'N' ar98,
   'N' ar99,
   'N' ar100,
   'N' ar101,
   'N' ar102,
   'N' ar103,
   'N' ar104,
   'N' ar105,
   'N' ar106,
   'N' ar107,
   'N' ar108,
   'N' ar109,
   'N' ar110,
   'N' ar111,
   'N' ar112,
   'N' ar113,
   'N' ar114,
   'N' ar115,
   'N' ar116,
   'N' ar117,
   'N' ar118,
   'N' ar119,
   'N' ar120,
   'N' ar121,
   'N' ar122,
   'N' ar123,
   'N' ar124,
   'N' ar125,
   'N' ar126,
   'N' ar127,
   'N' ar128
FROM "UNILAB".utscme;
--------------------------------------------------------
--  DDL for View UDSCPA
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UDSCPA" ("SC", "PG", "PGNODE", "PA", "PANODE", "PR_VERSION", "DESCRIPTION", "VALUE_F", "VALUE_S", "UNIT", "EXEC_START_DATE", "EXEC_START_DATE_TZ", "EXEC_END_DATE", "EXEC_END_DATE_TZ", "EXECUTOR", "PLANNED_EXECUTOR", "MANUALLY_ENTERED", "ASSIGN_DATE", "ASSIGN_DATE_TZ", "ASSIGNED_BY", "MANUALLY_ADDED", "FORMAT", "TD_INFO", "TD_INFO_UNIT", "CONFIRM_UID", "ALLOW_ANY_ME", "DELAY", "DELAY_UNIT", "MIN_NR_RESULTS", "CALC_METHOD", "CALC_CF", "ALARM_ORDER", "VALID_SPECSA", "VALID_SPECSB", "VALID_SPECSC", "VALID_LIMITSA", "VALID_LIMITSB", "VALID_LIMITSC", "VALID_TARGETA", "VALID_TARGETB", "VALID_TARGETC", "LOG_EXCEPTIONS", "REANALYSIS", "LAST_COMMENT", "PA_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR1", "AR2", "AR3", "AR4", "AR5", "AR6", "AR7", "AR8", "AR9", "AR10", "AR11", "AR12", "AR13", "AR14", "AR15", "AR16", "AR17", "AR18", "AR19", "AR20", "AR21", "AR22", "AR23", "AR24", "AR25", "AR26", "AR27", "AR28", "AR29", "AR30", "AR31", "AR32", "AR33", "AR34", "AR35", "AR36", "AR37", "AR38", "AR39", "AR40", "AR41", "AR42", "AR43", "AR44", "AR45", "AR46", "AR47", "AR48", "AR49", "AR50", "AR51", "AR52", "AR53", "AR54", "AR55", "AR56", "AR57", "AR58", "AR59", "AR60", "AR61", "AR62", "AR63", "AR64", "AR65", "AR66", "AR67", "AR68", "AR69", "AR70", "AR71", "AR72", "AR73", "AR74", "AR75", "AR76", "AR77", "AR78", "AR79", "AR80", "AR81", "AR82", "AR83", "AR84", "AR85", "AR86", "AR87", "AR88", "AR89", "AR90", "AR91", "AR92", "AR93", "AR94", "AR95", "AR96", "AR97", "AR98", "AR99", "AR100", "AR101", "AR102", "AR103", "AR104", "AR105", "AR106", "AR107", "AR108", "AR109", "AR110", "AR111", "AR112", "AR113", "AR114", "AR115", "AR116", "AR117", "AR118", "AR119", "AR120", "AR121", "AR122", "AR123", "AR124", "AR125", "AR126", "AR127", "AR128") AS 
  SELECT
   sc,
   pg,
   pgnode,
   pa,
   panode,
   pr_version,
   description,
   value_f,
   value_s,
   unit,
   exec_start_date,
   exec_start_date_tz,
   exec_end_date,
   exec_end_date_tz,
   executor,
   planned_executor,
   manually_entered,
   assign_date,
   assign_date_tz,
   assigned_by,
   manually_added,
   format,
   td_info,
   td_info_unit,
   confirm_uid,
   allow_any_me,
   delay,
   delay_unit,
   min_nr_results,
   calc_method,
   calc_cf,
   alarm_order,
   valid_specsa,
   valid_specsb,
   valid_specsc,
   valid_limitsa,
   valid_limitsb,
   valid_limitsc,
   valid_targeta,
   valid_targetb,
   valid_targetc,
   log_exceptions,
   reanalysis,
   last_comment,
   pa_class,
   log_hs,
   log_hs_details,
   allow_modify,
   active,
   lc,
   lc_version,
   ss,
   ar1,
   ar2,
   ar3,
   ar4,
   ar5,
   ar6,
   ar7,
   ar8,
   ar9,
   ar10,
   ar11,
   ar12,
   ar13,
   ar14,
   ar15,
   ar16,
   'N' ar17,
   'N' ar18,
   'N' ar19,
   'N' ar20,
   'N' ar21,
   'N' ar22,
   'N' ar23,
   'N' ar24,
   'N' ar25,
   'N' ar26,
   'N' ar27,
   'N' ar28,
   'N' ar29,
   'N' ar30,
   'N' ar31,
   'N' ar32,
   'N' ar33,
   'N' ar34,
   'N' ar35,
   'N' ar36,
   'N' ar37,
   'N' ar38,
   'N' ar39,
   'N' ar40,
   'N' ar41,
   'N' ar42,
   'N' ar43,
   'N' ar44,
   'N' ar45,
   'N' ar46,
   'N' ar47,
   'N' ar48,
   'N' ar49,
   'N' ar50,
   'N' ar51,
   'N' ar52,
   'N' ar53,
   'N' ar54,
   'N' ar55,
   'N' ar56,
   'N' ar57,
   'N' ar58,
   'N' ar59,
   'N' ar60,
   'N' ar61,
   'N' ar62,
   'N' ar63,
   'N' ar64,
   'N' ar65,
   'N' ar66,
   'N' ar67,
   'N' ar68,
   'N' ar69,
   'N' ar70,
   'N' ar71,
   'N' ar72,
   'N' ar73,
   'N' ar74,
   'N' ar75,
   'N' ar76,
   'N' ar77,
   'N' ar78,
   'N' ar79,
   'N' ar80,
   'N' ar81,
   'N' ar82,
   'N' ar83,
   'N' ar84,
   'N' ar85,
   'N' ar86,
   'N' ar87,
   'N' ar88,
   'N' ar89,
   'N' ar90,
   'N' ar91,
   'N' ar92,
   'N' ar93,
   'N' ar94,
   'N' ar95,
   'N' ar96,
   'N' ar97,
   'N' ar98,
   'N' ar99,
   'N' ar100,
   'N' ar101,
   'N' ar102,
   'N' ar103,
   'N' ar104,
   'N' ar105,
   'N' ar106,
   'N' ar107,
   'N' ar108,
   'N' ar109,
   'N' ar110,
   'N' ar111,
   'N' ar112,
   'N' ar113,
   'N' ar114,
   'N' ar115,
   'N' ar116,
   'N' ar117,
   'N' ar118,
   'N' ar119,
   'N' ar120,
   'N' ar121,
   'N' ar122,
   'N' ar123,
   'N' ar124,
   'N' ar125,
   'N' ar126,
   'N' ar127,
   'N' ar128
FROM "UNILAB".utscpa;
--------------------------------------------------------
--  DDL for View UDSCPG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UDSCPG" ("SC", "PG", "PGNODE", "PP_VERSION", "PP_KEY1", "PP_KEY2", "PP_KEY3", "PP_KEY4", "PP_KEY5", "DESCRIPTION", "VALUE_F", "VALUE_S", "UNIT", "EXEC_START_DATE", "EXEC_START_DATE_TZ", "EXEC_END_DATE", "EXEC_END_DATE_TZ", "EXECUTOR", "PLANNED_EXECUTOR", "MANUALLY_ENTERED", "ASSIGN_DATE", "ASSIGN_DATE_TZ", "ASSIGNED_BY", "MANUALLY_ADDED", "FORMAT", "CONFIRM_ASSIGN", "ALLOW_ANY_PR", "NEVER_CREATE_METHODS", "DELAY", "DELAY_UNIT", "REANALYSIS", "LAST_COMMENT", "PG_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR1", "AR2", "AR3", "AR4", "AR5", "AR6", "AR7", "AR8", "AR9", "AR10", "AR11", "AR12", "AR13", "AR14", "AR15", "AR16", "AR17", "AR18", "AR19", "AR20", "AR21", "AR22", "AR23", "AR24", "AR25", "AR26", "AR27", "AR28", "AR29", "AR30", "AR31", "AR32", "AR33", "AR34", "AR35", "AR36", "AR37", "AR38", "AR39", "AR40", "AR41", "AR42", "AR43", "AR44", "AR45", "AR46", "AR47", "AR48", "AR49", "AR50", "AR51", "AR52", "AR53", "AR54", "AR55", "AR56", "AR57", "AR58", "AR59", "AR60", "AR61", "AR62", "AR63", "AR64", "AR65", "AR66", "AR67", "AR68", "AR69", "AR70", "AR71", "AR72", "AR73", "AR74", "AR75", "AR76", "AR77", "AR78", "AR79", "AR80", "AR81", "AR82", "AR83", "AR84", "AR85", "AR86", "AR87", "AR88", "AR89", "AR90", "AR91", "AR92", "AR93", "AR94", "AR95", "AR96", "AR97", "AR98", "AR99", "AR100", "AR101", "AR102", "AR103", "AR104", "AR105", "AR106", "AR107", "AR108", "AR109", "AR110", "AR111", "AR112", "AR113", "AR114", "AR115", "AR116", "AR117", "AR118", "AR119", "AR120", "AR121", "AR122", "AR123", "AR124", "AR125", "AR126", "AR127", "AR128") AS 
  SELECT
   sc,
   pg,
   pgnode,
   pp_version,
   pp_key1,
   pp_key2,
   pp_key3,
   pp_key4,
   pp_key5,
   description,
   value_f,
   value_s,
   unit,
   exec_start_date,
   exec_start_date_tz,
   exec_end_date,
   exec_end_date_tz,
   executor,
   planned_executor,
   manually_entered,
   assign_date,
   assign_date_tz,
   assigned_by,
   manually_added,
   format,
   confirm_assign,
   allow_any_pr,
   never_create_methods,
   delay,
   delay_unit,
   reanalysis,
   last_comment,
   pg_class,
   log_hs,
   log_hs_details,
   allow_modify,
   active,
   lc,
   lc_version,
   ss,
   ar1,
   ar2,
   ar3,
   ar4,
   ar5,
   ar6,
   ar7,
   ar8,
   ar9,
   ar10,
   ar11,
   ar12,
   ar13,
   ar14,
   ar15,
   ar16,
   'N' ar17,
   'N' ar18,
   'N' ar19,
   'N' ar20,
   'N' ar21,
   'N' ar22,
   'N' ar23,
   'N' ar24,
   'N' ar25,
   'N' ar26,
   'N' ar27,
   'N' ar28,
   'N' ar29,
   'N' ar30,
   'N' ar31,
   'N' ar32,
   'N' ar33,
   'N' ar34,
   'N' ar35,
   'N' ar36,
   'N' ar37,
   'N' ar38,
   'N' ar39,
   'N' ar40,
   'N' ar41,
   'N' ar42,
   'N' ar43,
   'N' ar44,
   'N' ar45,
   'N' ar46,
   'N' ar47,
   'N' ar48,
   'N' ar49,
   'N' ar50,
   'N' ar51,
   'N' ar52,
   'N' ar53,
   'N' ar54,
   'N' ar55,
   'N' ar56,
   'N' ar57,
   'N' ar58,
   'N' ar59,
   'N' ar60,
   'N' ar61,
   'N' ar62,
   'N' ar63,
   'N' ar64,
   'N' ar65,
   'N' ar66,
   'N' ar67,
   'N' ar68,
   'N' ar69,
   'N' ar70,
   'N' ar71,
   'N' ar72,
   'N' ar73,
   'N' ar74,
   'N' ar75,
   'N' ar76,
   'N' ar77,
   'N' ar78,
   'N' ar79,
   'N' ar80,
   'N' ar81,
   'N' ar82,
   'N' ar83,
   'N' ar84,
   'N' ar85,
   'N' ar86,
   'N' ar87,
   'N' ar88,
   'N' ar89,
   'N' ar90,
   'N' ar91,
   'N' ar92,
   'N' ar93,
   'N' ar94,
   'N' ar95,
   'N' ar96,
   'N' ar97,
   'N' ar98,
   'N' ar99,
   'N' ar100,
   'N' ar101,
   'N' ar102,
   'N' ar103,
   'N' ar104,
   'N' ar105,
   'N' ar106,
   'N' ar107,
   'N' ar108,
   'N' ar109,
   'N' ar110,
   'N' ar111,
   'N' ar112,
   'N' ar113,
   'N' ar114,
   'N' ar115,
   'N' ar116,
   'N' ar117,
   'N' ar118,
   'N' ar119,
   'N' ar120,
   'N' ar121,
   'N' ar122,
   'N' ar123,
   'N' ar124,
   'N' ar125,
   'N' ar126,
   'N' ar127,
   'N' ar128
FROM "UNILAB".utscpg;
--------------------------------------------------------
--  DDL for View UDSD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UDSD" ("SD", "PT", "PT_VERSION", "DESCRIPTION", "DESCR_DOC", "DESCR_DOC_VERSION", "RESPONSIBLE", "LABEL_FORMAT", "CREATION_DATE", "CREATION_DATE_TZ", "CREATED_BY", "EXEC_START_DATE", "EXEC_START_DATE_TZ", "EXEC_END_DATE", "EXEC_END_DATE_TZ", "T0_DATE", "T0_DATE_TZ", "NR_SC_CURRENT", "LAST_COMMENT", "SD_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR1", "AR2", "AR3", "AR4", "AR5", "AR6", "AR7", "AR8", "AR9", "AR10", "AR11", "AR12", "AR13", "AR14", "AR15", "AR16", "AR17", "AR18", "AR19", "AR20", "AR21", "AR22", "AR23", "AR24", "AR25", "AR26", "AR27", "AR28", "AR29", "AR30", "AR31", "AR32", "AR33", "AR34", "AR35", "AR36", "AR37", "AR38", "AR39", "AR40", "AR41", "AR42", "AR43", "AR44", "AR45", "AR46", "AR47", "AR48", "AR49", "AR50", "AR51", "AR52", "AR53", "AR54", "AR55", "AR56", "AR57", "AR58", "AR59", "AR60", "AR61", "AR62", "AR63", "AR64", "AR65", "AR66", "AR67", "AR68", "AR69", "AR70", "AR71", "AR72", "AR73", "AR74", "AR75", "AR76", "AR77", "AR78", "AR79", "AR80", "AR81", "AR82", "AR83", "AR84", "AR85", "AR86", "AR87", "AR88", "AR89", "AR90", "AR91", "AR92", "AR93", "AR94", "AR95", "AR96", "AR97", "AR98", "AR99", "AR100", "AR101", "AR102", "AR103", "AR104", "AR105", "AR106", "AR107", "AR108", "AR109", "AR110", "AR111", "AR112", "AR113", "AR114", "AR115", "AR116", "AR117", "AR118", "AR119", "AR120", "AR121", "AR122", "AR123", "AR124", "AR125", "AR126", "AR127", "AR128") AS 
  SELECT
   sd,
   pt,
   pt_version,
   description,
   descr_doc,
   descr_doc_version,
   responsible,
   label_format,
   creation_date,
   creation_date_tz,
   created_by,
   exec_start_date,
   exec_start_date_tz,
   exec_end_date,
   exec_end_date_tz,
   t0_date,
   t0_date_tz,
   nr_sc_current,
   last_comment,
   sd_class,
   log_hs,
   log_hs_details,
   allow_modify,
   active,
   lc,
   lc_version,
   ss,
   ar1,
   ar2,
   ar3,
   ar4,
   ar5,
   ar6,
   ar7,
   ar8,
   ar9,
   ar10,
   ar11,
   ar12,
   ar13,
   ar14,
   ar15,
   ar16,
   'N' ar17,
   'N' ar18,
   'N' ar19,
   'N' ar20,
   'N' ar21,
   'N' ar22,
   'N' ar23,
   'N' ar24,
   'N' ar25,
   'N' ar26,
   'N' ar27,
   'N' ar28,
   'N' ar29,
   'N' ar30,
   'N' ar31,
   'N' ar32,
   'N' ar33,
   'N' ar34,
   'N' ar35,
   'N' ar36,
   'N' ar37,
   'N' ar38,
   'N' ar39,
   'N' ar40,
   'N' ar41,
   'N' ar42,
   'N' ar43,
   'N' ar44,
   'N' ar45,
   'N' ar46,
   'N' ar47,
   'N' ar48,
   'N' ar49,
   'N' ar50,
   'N' ar51,
   'N' ar52,
   'N' ar53,
   'N' ar54,
   'N' ar55,
   'N' ar56,
   'N' ar57,
   'N' ar58,
   'N' ar59,
   'N' ar60,
   'N' ar61,
   'N' ar62,
   'N' ar63,
   'N' ar64,
   'N' ar65,
   'N' ar66,
   'N' ar67,
   'N' ar68,
   'N' ar69,
   'N' ar70,
   'N' ar71,
   'N' ar72,
   'N' ar73,
   'N' ar74,
   'N' ar75,
   'N' ar76,
   'N' ar77,
   'N' ar78,
   'N' ar79,
   'N' ar80,
   'N' ar81,
   'N' ar82,
   'N' ar83,
   'N' ar84,
   'N' ar85,
   'N' ar86,
   'N' ar87,
   'N' ar88,
   'N' ar89,
   'N' ar90,
   'N' ar91,
   'N' ar92,
   'N' ar93,
   'N' ar94,
   'N' ar95,
   'N' ar96,
   'N' ar97,
   'N' ar98,
   'N' ar99,
   'N' ar100,
   'N' ar101,
   'N' ar102,
   'N' ar103,
   'N' ar104,
   'N' ar105,
   'N' ar106,
   'N' ar107,
   'N' ar108,
   'N' ar109,
   'N' ar110,
   'N' ar111,
   'N' ar112,
   'N' ar113,
   'N' ar114,
   'N' ar115,
   'N' ar116,
   'N' ar117,
   'N' ar118,
   'N' ar119,
   'N' ar120,
   'N' ar121,
   'N' ar122,
   'N' ar123,
   'N' ar124,
   'N' ar125,
   'N' ar126,
   'N' ar127,
   'N' ar128
FROM "UNILAB".utsd;
--------------------------------------------------------
--  DDL for View UDSDIC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UDSDIC" ("SD", "IC", "ICNODE", "IP_VERSION", "DESCRIPTION", "WINSIZE_X", "WINSIZE_Y", "IS_PROTECTED", "HIDDEN", "MANUALLY_ADDED", "NEXT_II", "LAST_COMMENT", "IC_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR1", "AR2", "AR3", "AR4", "AR5", "AR6", "AR7", "AR8", "AR9", "AR10", "AR11", "AR12", "AR13", "AR14", "AR15", "AR16", "AR17", "AR18", "AR19", "AR20", "AR21", "AR22", "AR23", "AR24", "AR25", "AR26", "AR27", "AR28", "AR29", "AR30", "AR31", "AR32", "AR33", "AR34", "AR35", "AR36", "AR37", "AR38", "AR39", "AR40", "AR41", "AR42", "AR43", "AR44", "AR45", "AR46", "AR47", "AR48", "AR49", "AR50", "AR51", "AR52", "AR53", "AR54", "AR55", "AR56", "AR57", "AR58", "AR59", "AR60", "AR61", "AR62", "AR63", "AR64", "AR65", "AR66", "AR67", "AR68", "AR69", "AR70", "AR71", "AR72", "AR73", "AR74", "AR75", "AR76", "AR77", "AR78", "AR79", "AR80", "AR81", "AR82", "AR83", "AR84", "AR85", "AR86", "AR87", "AR88", "AR89", "AR90", "AR91", "AR92", "AR93", "AR94", "AR95", "AR96", "AR97", "AR98", "AR99", "AR100", "AR101", "AR102", "AR103", "AR104", "AR105", "AR106", "AR107", "AR108", "AR109", "AR110", "AR111", "AR112", "AR113", "AR114", "AR115", "AR116", "AR117", "AR118", "AR119", "AR120", "AR121", "AR122", "AR123", "AR124", "AR125", "AR126", "AR127", "AR128") AS 
  SELECT
   sd,
   ic,
   icnode,
   ip_version,
   description,
   winsize_x,
   winsize_y,
   is_protected,
   hidden,
   manually_added,
   next_ii,
   last_comment,
   ic_class,
   log_hs,
   log_hs_details,
   allow_modify,
   active,
   lc,
   lc_version,
   ss,
   ar1,
   ar2,
   ar3,
   ar4,
   ar5,
   ar6,
   ar7,
   ar8,
   ar9,
   ar10,
   ar11,
   ar12,
   ar13,
   ar14,
   ar15,
   ar16,
   'N' ar17,
   'N' ar18,
   'N' ar19,
   'N' ar20,
   'N' ar21,
   'N' ar22,
   'N' ar23,
   'N' ar24,
   'N' ar25,
   'N' ar26,
   'N' ar27,
   'N' ar28,
   'N' ar29,
   'N' ar30,
   'N' ar31,
   'N' ar32,
   'N' ar33,
   'N' ar34,
   'N' ar35,
   'N' ar36,
   'N' ar37,
   'N' ar38,
   'N' ar39,
   'N' ar40,
   'N' ar41,
   'N' ar42,
   'N' ar43,
   'N' ar44,
   'N' ar45,
   'N' ar46,
   'N' ar47,
   'N' ar48,
   'N' ar49,
   'N' ar50,
   'N' ar51,
   'N' ar52,
   'N' ar53,
   'N' ar54,
   'N' ar55,
   'N' ar56,
   'N' ar57,
   'N' ar58,
   'N' ar59,
   'N' ar60,
   'N' ar61,
   'N' ar62,
   'N' ar63,
   'N' ar64,
   'N' ar65,
   'N' ar66,
   'N' ar67,
   'N' ar68,
   'N' ar69,
   'N' ar70,
   'N' ar71,
   'N' ar72,
   'N' ar73,
   'N' ar74,
   'N' ar75,
   'N' ar76,
   'N' ar77,
   'N' ar78,
   'N' ar79,
   'N' ar80,
   'N' ar81,
   'N' ar82,
   'N' ar83,
   'N' ar84,
   'N' ar85,
   'N' ar86,
   'N' ar87,
   'N' ar88,
   'N' ar89,
   'N' ar90,
   'N' ar91,
   'N' ar92,
   'N' ar93,
   'N' ar94,
   'N' ar95,
   'N' ar96,
   'N' ar97,
   'N' ar98,
   'N' ar99,
   'N' ar100,
   'N' ar101,
   'N' ar102,
   'N' ar103,
   'N' ar104,
   'N' ar105,
   'N' ar106,
   'N' ar107,
   'N' ar108,
   'N' ar109,
   'N' ar110,
   'N' ar111,
   'N' ar112,
   'N' ar113,
   'N' ar114,
   'N' ar115,
   'N' ar116,
   'N' ar117,
   'N' ar118,
   'N' ar119,
   'N' ar120,
   'N' ar121,
   'N' ar122,
   'N' ar123,
   'N' ar124,
   'N' ar125,
   'N' ar126,
   'N' ar127,
   'N' ar128
FROM "UNILAB".utsdic;
--------------------------------------------------------
--  DDL for View UDSDII
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UDSDII" ("SD", "IC", "ICNODE", "II", "IINODE", "IE_VERSION", "IIVALUE", "POS_X", "POS_Y", "IS_PROTECTED", "MANDATORY", "HIDDEN", "DSP_TITLE", "DSP_LEN", "DSP_TP", "DSP_ROWS", "II_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR1", "AR2", "AR3", "AR4", "AR5", "AR6", "AR7", "AR8", "AR9", "AR10", "AR11", "AR12", "AR13", "AR14", "AR15", "AR16", "AR17", "AR18", "AR19", "AR20", "AR21", "AR22", "AR23", "AR24", "AR25", "AR26", "AR27", "AR28", "AR29", "AR30", "AR31", "AR32", "AR33", "AR34", "AR35", "AR36", "AR37", "AR38", "AR39", "AR40", "AR41", "AR42", "AR43", "AR44", "AR45", "AR46", "AR47", "AR48", "AR49", "AR50", "AR51", "AR52", "AR53", "AR54", "AR55", "AR56", "AR57", "AR58", "AR59", "AR60", "AR61", "AR62", "AR63", "AR64", "AR65", "AR66", "AR67", "AR68", "AR69", "AR70", "AR71", "AR72", "AR73", "AR74", "AR75", "AR76", "AR77", "AR78", "AR79", "AR80", "AR81", "AR82", "AR83", "AR84", "AR85", "AR86", "AR87", "AR88", "AR89", "AR90", "AR91", "AR92", "AR93", "AR94", "AR95", "AR96", "AR97", "AR98", "AR99", "AR100", "AR101", "AR102", "AR103", "AR104", "AR105", "AR106", "AR107", "AR108", "AR109", "AR110", "AR111", "AR112", "AR113", "AR114", "AR115", "AR116", "AR117", "AR118", "AR119", "AR120", "AR121", "AR122", "AR123", "AR124", "AR125", "AR126", "AR127", "AR128") AS 
  SELECT
   sd,
   ic,
   icnode,
   ii,
   iinode,
   ie_version,
   iivalue,
   pos_x,
   pos_y,
   is_protected,
   mandatory,
   hidden,
   dsp_title,
   dsp_len,
   dsp_tp,
   dsp_rows,
   ii_class,
   log_hs,
   log_hs_details,
   allow_modify,
   active,
   lc,
   lc_version,
   ss,
   ar1,
   ar2,
   ar3,
   ar4,
   ar5,
   ar6,
   ar7,
   ar8,
   ar9,
   ar10,
   ar11,
   ar12,
   ar13,
   ar14,
   ar15,
   ar16,
   'N' ar17,
   'N' ar18,
   'N' ar19,
   'N' ar20,
   'N' ar21,
   'N' ar22,
   'N' ar23,
   'N' ar24,
   'N' ar25,
   'N' ar26,
   'N' ar27,
   'N' ar28,
   'N' ar29,
   'N' ar30,
   'N' ar31,
   'N' ar32,
   'N' ar33,
   'N' ar34,
   'N' ar35,
   'N' ar36,
   'N' ar37,
   'N' ar38,
   'N' ar39,
   'N' ar40,
   'N' ar41,
   'N' ar42,
   'N' ar43,
   'N' ar44,
   'N' ar45,
   'N' ar46,
   'N' ar47,
   'N' ar48,
   'N' ar49,
   'N' ar50,
   'N' ar51,
   'N' ar52,
   'N' ar53,
   'N' ar54,
   'N' ar55,
   'N' ar56,
   'N' ar57,
   'N' ar58,
   'N' ar59,
   'N' ar60,
   'N' ar61,
   'N' ar62,
   'N' ar63,
   'N' ar64,
   'N' ar65,
   'N' ar66,
   'N' ar67,
   'N' ar68,
   'N' ar69,
   'N' ar70,
   'N' ar71,
   'N' ar72,
   'N' ar73,
   'N' ar74,
   'N' ar75,
   'N' ar76,
   'N' ar77,
   'N' ar78,
   'N' ar79,
   'N' ar80,
   'N' ar81,
   'N' ar82,
   'N' ar83,
   'N' ar84,
   'N' ar85,
   'N' ar86,
   'N' ar87,
   'N' ar88,
   'N' ar89,
   'N' ar90,
   'N' ar91,
   'N' ar92,
   'N' ar93,
   'N' ar94,
   'N' ar95,
   'N' ar96,
   'N' ar97,
   'N' ar98,
   'N' ar99,
   'N' ar100,
   'N' ar101,
   'N' ar102,
   'N' ar103,
   'N' ar104,
   'N' ar105,
   'N' ar106,
   'N' ar107,
   'N' ar108,
   'N' ar109,
   'N' ar110,
   'N' ar111,
   'N' ar112,
   'N' ar113,
   'N' ar114,
   'N' ar115,
   'N' ar116,
   'N' ar117,
   'N' ar118,
   'N' ar119,
   'N' ar120,
   'N' ar121,
   'N' ar122,
   'N' ar123,
   'N' ar124,
   'N' ar125,
   'N' ar126,
   'N' ar127,
   'N' ar128
FROM "UNILAB".utsdii;
--------------------------------------------------------
--  DDL for View UDST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UDST" ("ST", "VERSION", "VERSION_IS_CURRENT", "EFFECTIVE_FROM", "EFFECTIVE_FROM_TZ", "EFFECTIVE_TILL", "EFFECTIVE_TILL_TZ", "DESCRIPTION", "DESCRIPTION2", "IS_TEMPLATE", "CONFIRM_USERID", "SHELF_LIFE_VAL", "SHELF_LIFE_UNIT", "NR_PLANNED_SC", "FREQ_TP", "FREQ_VAL", "FREQ_UNIT", "INVERT_FREQ", "LAST_SCHED", "LAST_SCHED_TZ", "LAST_CNT", "LAST_VAL", "PRIORITY", "LABEL_FORMAT", "DESCR_DOC", "DESCR_DOC_VERSION", "ALLOW_ANY_PP", "SC_UC", "SC_UC_VERSION", "SC_LC", "SC_LC_VERSION", "INHERIT_AU", "INHERIT_GK", "LAST_COMMENT", "ST_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR1", "AR2", "AR3", "AR4", "AR5", "AR6", "AR7", "AR8", "AR9", "AR10", "AR11", "AR12", "AR13", "AR14", "AR15", "AR16", "AR17", "AR18", "AR19", "AR20", "AR21", "AR22", "AR23", "AR24", "AR25", "AR26", "AR27", "AR28", "AR29", "AR30", "AR31", "AR32", "AR33", "AR34", "AR35", "AR36", "AR37", "AR38", "AR39", "AR40", "AR41", "AR42", "AR43", "AR44", "AR45", "AR46", "AR47", "AR48", "AR49", "AR50", "AR51", "AR52", "AR53", "AR54", "AR55", "AR56", "AR57", "AR58", "AR59", "AR60", "AR61", "AR62", "AR63", "AR64", "AR65", "AR66", "AR67", "AR68", "AR69", "AR70", "AR71", "AR72", "AR73", "AR74", "AR75", "AR76", "AR77", "AR78", "AR79", "AR80", "AR81", "AR82", "AR83", "AR84", "AR85", "AR86", "AR87", "AR88", "AR89", "AR90", "AR91", "AR92", "AR93", "AR94", "AR95", "AR96", "AR97", "AR98", "AR99", "AR100", "AR101", "AR102", "AR103", "AR104", "AR105", "AR106", "AR107", "AR108", "AR109", "AR110", "AR111", "AR112", "AR113", "AR114", "AR115", "AR116", "AR117", "AR118", "AR119", "AR120", "AR121", "AR122", "AR123", "AR124", "AR125", "AR126", "AR127", "AR128") AS 
  SELECT
   st,
   version,
   version_is_current,
   effective_from,
   effective_from_tz,
   effective_till,
   effective_till_tz,
   description,
   description2,
   is_template,
   confirm_userid,
   shelf_life_val,
   shelf_life_unit,
   nr_planned_sc,
   freq_tp,
   freq_val,
   freq_unit,
   invert_freq,
   last_sched,
   last_sched_tz,
   last_cnt,
   last_val,
   priority,
   label_format,
   descr_doc,
   descr_doc_version,
   allow_any_pp,
   sc_uc,
   sc_uc_version,
   sc_lc,
   sc_lc_version,
   inherit_au,
   inherit_gk,
   last_comment,
   st_class,
   log_hs,
   log_hs_details,
   allow_modify,
   active,
   lc,
   lc_version,
   ss,
   ar1,
   ar2,
   ar3,
   ar4,
   ar5,
   ar6,
   ar7,
   ar8,
   ar9,
   ar10,
   ar11,
   ar12,
   ar13,
   ar14,
   ar15,
   ar16,
   'N' ar17,
   'N' ar18,
   'N' ar19,
   'N' ar20,
   'N' ar21,
   'N' ar22,
   'N' ar23,
   'N' ar24,
   'N' ar25,
   'N' ar26,
   'N' ar27,
   'N' ar28,
   'N' ar29,
   'N' ar30,
   'N' ar31,
   'N' ar32,
   'N' ar33,
   'N' ar34,
   'N' ar35,
   'N' ar36,
   'N' ar37,
   'N' ar38,
   'N' ar39,
   'N' ar40,
   'N' ar41,
   'N' ar42,
   'N' ar43,
   'N' ar44,
   'N' ar45,
   'N' ar46,
   'N' ar47,
   'N' ar48,
   'N' ar49,
   'N' ar50,
   'N' ar51,
   'N' ar52,
   'N' ar53,
   'N' ar54,
   'N' ar55,
   'N' ar56,
   'N' ar57,
   'N' ar58,
   'N' ar59,
   'N' ar60,
   'N' ar61,
   'N' ar62,
   'N' ar63,
   'N' ar64,
   'N' ar65,
   'N' ar66,
   'N' ar67,
   'N' ar68,
   'N' ar69,
   'N' ar70,
   'N' ar71,
   'N' ar72,
   'N' ar73,
   'N' ar74,
   'N' ar75,
   'N' ar76,
   'N' ar77,
   'N' ar78,
   'N' ar79,
   'N' ar80,
   'N' ar81,
   'N' ar82,
   'N' ar83,
   'N' ar84,
   'N' ar85,
   'N' ar86,
   'N' ar87,
   'N' ar88,
   'N' ar89,
   'N' ar90,
   'N' ar91,
   'N' ar92,
   'N' ar93,
   'N' ar94,
   'N' ar95,
   'N' ar96,
   'N' ar97,
   'N' ar98,
   'N' ar99,
   'N' ar100,
   'N' ar101,
   'N' ar102,
   'N' ar103,
   'N' ar104,
   'N' ar105,
   'N' ar106,
   'N' ar107,
   'N' ar108,
   'N' ar109,
   'N' ar110,
   'N' ar111,
   'N' ar112,
   'N' ar113,
   'N' ar114,
   'N' ar115,
   'N' ar116,
   'N' ar117,
   'N' ar118,
   'N' ar119,
   'N' ar120,
   'N' ar121,
   'N' ar122,
   'N' ar123,
   'N' ar124,
   'N' ar125,
   'N' ar126,
   'N' ar127,
   'N' ar128
FROM "UNILAB".utst;
--------------------------------------------------------
--  DDL for View UDWS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UDWS" ("WS", "WT", "WT_VERSION", "DESCRIPTION", "CREATION_DATE", "CREATION_DATE_TZ", "CREATED_BY", "EXEC_START_DATE", "EXEC_START_DATE_TZ", "EXEC_END_DATE", "EXEC_END_DATE_TZ", "PRIORITY", "DUE_DATE", "DUE_DATE_TZ", "RESPONSIBLE", "SC_COUNTER", "MIN_ROWS", "MAX_ROWS", "COMPLETE", "VALID_CF", "DESCR_DOC", "DESCR_DOC_VERSION", "DATE1", "DATE1_TZ", "DATE2", "DATE2_TZ", "DATE3", "DATE3_TZ", "DATE4", "DATE4_TZ", "DATE5", "DATE5_TZ", "LAST_COMMENT", "WS_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR1", "AR2", "AR3", "AR4", "AR5", "AR6", "AR7", "AR8", "AR9", "AR10", "AR11", "AR12", "AR13", "AR14", "AR15", "AR16", "AR17", "AR18", "AR19", "AR20", "AR21", "AR22", "AR23", "AR24", "AR25", "AR26", "AR27", "AR28", "AR29", "AR30", "AR31", "AR32", "AR33", "AR34", "AR35", "AR36", "AR37", "AR38", "AR39", "AR40", "AR41", "AR42", "AR43", "AR44", "AR45", "AR46", "AR47", "AR48", "AR49", "AR50", "AR51", "AR52", "AR53", "AR54", "AR55", "AR56", "AR57", "AR58", "AR59", "AR60", "AR61", "AR62", "AR63", "AR64", "AR65", "AR66", "AR67", "AR68", "AR69", "AR70", "AR71", "AR72", "AR73", "AR74", "AR75", "AR76", "AR77", "AR78", "AR79", "AR80", "AR81", "AR82", "AR83", "AR84", "AR85", "AR86", "AR87", "AR88", "AR89", "AR90", "AR91", "AR92", "AR93", "AR94", "AR95", "AR96", "AR97", "AR98", "AR99", "AR100", "AR101", "AR102", "AR103", "AR104", "AR105", "AR106", "AR107", "AR108", "AR109", "AR110", "AR111", "AR112", "AR113", "AR114", "AR115", "AR116", "AR117", "AR118", "AR119", "AR120", "AR121", "AR122", "AR123", "AR124", "AR125", "AR126", "AR127", "AR128") AS 
  SELECT
   ws,
   wt,
   wt_version,
   description,
   creation_date,
   creation_date_tz,
   created_by,
   exec_start_date,
   exec_start_date_tz,
   exec_end_date,
   exec_end_date_tz,
   priority,
   due_date,
   due_date_tz,
   responsible,
   sc_counter,
   min_rows,
   max_rows,
   complete,
   valid_cf,
   descr_doc,
   descr_doc_version,
   date1,
   date1_tz,
   date2,
   date2_tz,
   date3,
   date3_tz,
   date4,
   date4_tz,
   date5,
   date5_tz,
   last_comment,
   ws_class,
   log_hs,
   log_hs_details,
   allow_modify,
   active,
   lc,
   lc_version,
   ss,
   ar1,
   ar2,
   ar3,
   ar4,
   ar5,
   ar6,
   ar7,
   ar8,
   ar9,
   ar10,
   ar11,
   ar12,
   ar13,
   ar14,
   ar15,
   ar16,
   'N' ar17,
   'N' ar18,
   'N' ar19,
   'N' ar20,
   'N' ar21,
   'N' ar22,
   'N' ar23,
   'N' ar24,
   'N' ar25,
   'N' ar26,
   'N' ar27,
   'N' ar28,
   'N' ar29,
   'N' ar30,
   'N' ar31,
   'N' ar32,
   'N' ar33,
   'N' ar34,
   'N' ar35,
   'N' ar36,
   'N' ar37,
   'N' ar38,
   'N' ar39,
   'N' ar40,
   'N' ar41,
   'N' ar42,
   'N' ar43,
   'N' ar44,
   'N' ar45,
   'N' ar46,
   'N' ar47,
   'N' ar48,
   'N' ar49,
   'N' ar50,
   'N' ar51,
   'N' ar52,
   'N' ar53,
   'N' ar54,
   'N' ar55,
   'N' ar56,
   'N' ar57,
   'N' ar58,
   'N' ar59,
   'N' ar60,
   'N' ar61,
   'N' ar62,
   'N' ar63,
   'N' ar64,
   'N' ar65,
   'N' ar66,
   'N' ar67,
   'N' ar68,
   'N' ar69,
   'N' ar70,
   'N' ar71,
   'N' ar72,
   'N' ar73,
   'N' ar74,
   'N' ar75,
   'N' ar76,
   'N' ar77,
   'N' ar78,
   'N' ar79,
   'N' ar80,
   'N' ar81,
   'N' ar82,
   'N' ar83,
   'N' ar84,
   'N' ar85,
   'N' ar86,
   'N' ar87,
   'N' ar88,
   'N' ar89,
   'N' ar90,
   'N' ar91,
   'N' ar92,
   'N' ar93,
   'N' ar94,
   'N' ar95,
   'N' ar96,
   'N' ar97,
   'N' ar98,
   'N' ar99,
   'N' ar100,
   'N' ar101,
   'N' ar102,
   'N' ar103,
   'N' ar104,
   'N' ar105,
   'N' ar106,
   'N' ar107,
   'N' ar108,
   'N' ar109,
   'N' ar110,
   'N' ar111,
   'N' ar112,
   'N' ar113,
   'N' ar114,
   'N' ar115,
   'N' ar116,
   'N' ar117,
   'N' ar118,
   'N' ar119,
   'N' ar120,
   'N' ar121,
   'N' ar122,
   'N' ar123,
   'N' ar124,
   'N' ar125,
   'N' ar126,
   'N' ar127,
   'N' ar128
FROM "UNILAB".utws;
--------------------------------------------------------
--  DDL for View UDWT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UDWT" ("WT", "VERSION", "VERSION_IS_CURRENT", "EFFECTIVE_FROM", "EFFECTIVE_FROM_TZ", "EFFECTIVE_TILL", "EFFECTIVE_TILL_TZ", "DESCRIPTION", "DESCRIPTION2", "MIN_ROWS", "MAX_ROWS", "VALID_CF", "DESCR_DOC", "DESCR_DOC_VERSION", "WS_LY", "WS_UC", "WS_UC_VERSION", "WS_LC", "WS_LC_VERSION", "INHERIT_AU", "LAST_COMMENT", "WT_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR1", "AR2", "AR3", "AR4", "AR5", "AR6", "AR7", "AR8", "AR9", "AR10", "AR11", "AR12", "AR13", "AR14", "AR15", "AR16", "AR17", "AR18", "AR19", "AR20", "AR21", "AR22", "AR23", "AR24", "AR25", "AR26", "AR27", "AR28", "AR29", "AR30", "AR31", "AR32", "AR33", "AR34", "AR35", "AR36", "AR37", "AR38", "AR39", "AR40", "AR41", "AR42", "AR43", "AR44", "AR45", "AR46", "AR47", "AR48", "AR49", "AR50", "AR51", "AR52", "AR53", "AR54", "AR55", "AR56", "AR57", "AR58", "AR59", "AR60", "AR61", "AR62", "AR63", "AR64", "AR65", "AR66", "AR67", "AR68", "AR69", "AR70", "AR71", "AR72", "AR73", "AR74", "AR75", "AR76", "AR77", "AR78", "AR79", "AR80", "AR81", "AR82", "AR83", "AR84", "AR85", "AR86", "AR87", "AR88", "AR89", "AR90", "AR91", "AR92", "AR93", "AR94", "AR95", "AR96", "AR97", "AR98", "AR99", "AR100", "AR101", "AR102", "AR103", "AR104", "AR105", "AR106", "AR107", "AR108", "AR109", "AR110", "AR111", "AR112", "AR113", "AR114", "AR115", "AR116", "AR117", "AR118", "AR119", "AR120", "AR121", "AR122", "AR123", "AR124", "AR125", "AR126", "AR127", "AR128") AS 
  SELECT
   wt,
   version,
   version_is_current,
   effective_from,
   effective_from_tz,
   effective_till,
   effective_till_tz,
   description,
   description2,
   min_rows,
   max_rows,
   valid_cf,
   descr_doc,
   descr_doc_version,
   ws_ly,
   ws_uc,
   ws_uc_version,
   ws_lc,
   ws_lc_version,
   inherit_au,
   last_comment,
   wt_class,
   log_hs,
   log_hs_details,
   allow_modify,
   active,
   lc,
   lc_version,
   ss,
   ar1,
   ar2,
   ar3,
   ar4,
   ar5,
   ar6,
   ar7,
   ar8,
   ar9,
   ar10,
   ar11,
   ar12,
   ar13,
   ar14,
   ar15,
   ar16,
   'N' ar17,
   'N' ar18,
   'N' ar19,
   'N' ar20,
   'N' ar21,
   'N' ar22,
   'N' ar23,
   'N' ar24,
   'N' ar25,
   'N' ar26,
   'N' ar27,
   'N' ar28,
   'N' ar29,
   'N' ar30,
   'N' ar31,
   'N' ar32,
   'N' ar33,
   'N' ar34,
   'N' ar35,
   'N' ar36,
   'N' ar37,
   'N' ar38,
   'N' ar39,
   'N' ar40,
   'N' ar41,
   'N' ar42,
   'N' ar43,
   'N' ar44,
   'N' ar45,
   'N' ar46,
   'N' ar47,
   'N' ar48,
   'N' ar49,
   'N' ar50,
   'N' ar51,
   'N' ar52,
   'N' ar53,
   'N' ar54,
   'N' ar55,
   'N' ar56,
   'N' ar57,
   'N' ar58,
   'N' ar59,
   'N' ar60,
   'N' ar61,
   'N' ar62,
   'N' ar63,
   'N' ar64,
   'N' ar65,
   'N' ar66,
   'N' ar67,
   'N' ar68,
   'N' ar69,
   'N' ar70,
   'N' ar71,
   'N' ar72,
   'N' ar73,
   'N' ar74,
   'N' ar75,
   'N' ar76,
   'N' ar77,
   'N' ar78,
   'N' ar79,
   'N' ar80,
   'N' ar81,
   'N' ar82,
   'N' ar83,
   'N' ar84,
   'N' ar85,
   'N' ar86,
   'N' ar87,
   'N' ar88,
   'N' ar89,
   'N' ar90,
   'N' ar91,
   'N' ar92,
   'N' ar93,
   'N' ar94,
   'N' ar95,
   'N' ar96,
   'N' ar97,
   'N' ar98,
   'N' ar99,
   'N' ar100,
   'N' ar101,
   'N' ar102,
   'N' ar103,
   'N' ar104,
   'N' ar105,
   'N' ar106,
   'N' ar107,
   'N' ar108,
   'N' ar109,
   'N' ar110,
   'N' ar111,
   'N' ar112,
   'N' ar113,
   'N' ar114,
   'N' ar115,
   'N' ar116,
   'N' ar117,
   'N' ar118,
   'N' ar119,
   'N' ar120,
   'N' ar121,
   'N' ar122,
   'N' ar123,
   'N' ar124,
   'N' ar125,
   'N' ar126,
   'N' ar127,
   'N' ar128
FROM "UNILAB".utwt;
--------------------------------------------------------
--  DDL for View UVAD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVAD" ("AD", "VERSION", "VERSION_IS_CURRENT", "EFFECTIVE_FROM", "EFFECTIVE_TILL", "IS_TEMPLATE", "IS_USER", "STRUCT_CREATED", "AD_TP", "PERSON", "TITLE", "FUNCTION_NAME", "DEF_UP", "COMPANY", "STREET", "CITY", "STATE", "COUNTRY", "AD_NR", "PO_BOX", "ZIP_CODE", "PHONE_NR", "EXT_NR", "FAX_NR", "EMAIL", "LAST_COMMENT", "AD_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "EFFECTIVE_FROM_TZ", "EFFECTIVE_TILL_TZ") AS 
  SELECT "AD","VERSION","VERSION_IS_CURRENT","EFFECTIVE_FROM","EFFECTIVE_TILL","IS_TEMPLATE","IS_USER","STRUCT_CREATED","AD_TP","PERSON","TITLE","FUNCTION_NAME","DEF_UP","COMPANY","STREET","CITY","STATE","COUNTRY","AD_NR","PO_BOX","ZIP_CODE","PHONE_NR","EXT_NR","FAX_NR","EMAIL","LAST_COMMENT","AD_CLASS","LOG_HS","LOG_HS_DETAILS","ALLOW_MODIFY","ACTIVE","LC","LC_VERSION","SS","EFFECTIVE_FROM_TZ","EFFECTIVE_TILL_TZ"
   FROM "UNILAB".utad;
--------------------------------------------------------
--  DDL for View UVADAU
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVADAU" ("AD", "VERSION", "AU", "AU_VERSION", "AUSEQ", "VALUE") AS 
  SELECT "AD","VERSION","AU","AU_VERSION","AUSEQ","VALUE"
   FROM "UNILAB".utadau;
--------------------------------------------------------
--  DDL for View UVADHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVADHS" ("AD", "VERSION", "WHO", "WHO_DESCRIPTION", "WHAT", "WHAT_DESCRIPTION", "LOGDATE", "WHY", "TR_SEQ", "EV_SEQ", "LOGDATE_TZ") AS 
  SELECT "AD","VERSION","WHO","WHO_DESCRIPTION","WHAT","WHAT_DESCRIPTION","LOGDATE","WHY","TR_SEQ","EV_SEQ","LOGDATE_TZ"
   FROM "UNILAB".utadhs;
--------------------------------------------------------
--  DDL for View UVADHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVADHSDETAILS" ("AD", "VERSION", "TR_SEQ", "EV_SEQ", "SEQ", "DETAILS") AS 
  SELECT "AD","VERSION","TR_SEQ","EV_SEQ","SEQ","DETAILS"
   FROM "UNILAB".utadhsdetails;
--------------------------------------------------------
--  DDL for View UVAPPLIC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVAPPLIC" ("APPLIC", "DESCRIPTION") AS 
  SELECT "APPLIC","DESCRIPTION"
   FROM "UNILAB".utapplic;
--------------------------------------------------------
--  DDL for View UVARCHINDEX
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVARCHINDEX" ("OBJECT_TP", "OBJECT_ID", "VERSION", "OBJECT_DETAILS", "ARCHIVE_ID", "ARCHIVE_DATE", "ARCHIVE_DATE_TZ") AS 
  SELECT "OBJECT_TP","OBJECT_ID","VERSION","OBJECT_DETAILS","ARCHIVE_ID","ARCHIVE_DATE","ARCHIVE_DATE_TZ"
   FROM "UNILAB".utarchindex;
--------------------------------------------------------
--  DDL for View UVASSIGNFULLTESTPLAN
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVASSIGNFULLTESTPLAN" ("OBJECT_TP", "OBJECT_ID", "OBJECT_VERSION", "TST_TP", "TST_ID", "TST_ID_VERSION", "TST_DESCRIPTION", "TST_NR_MEASUR", "PP", "PP_VERSION", "PP_KEY1", "PP_KEY2", "PP_KEY3", "PP_KEY4", "PP_KEY5", "PP_SEQ", "PR", "PR_VERSION", "PR_SEQ", "MT", "MT_VERSION", "MT_SEQ", "CONFIRM_ASSIGN", "IS_PP_IN_PP", "ALREADY_ASSIGNED", "NEVER_CREATE_METHODS") AS 
  SELECT "OBJECT_TP","OBJECT_ID","OBJECT_VERSION","TST_TP","TST_ID","TST_ID_VERSION","TST_DESCRIPTION","TST_NR_MEASUR","PP","PP_VERSION","PP_KEY1","PP_KEY2","PP_KEY3","PP_KEY4","PP_KEY5","PP_SEQ","PR","PR_VERSION","PR_SEQ","MT","MT_VERSION","MT_SEQ","CONFIRM_ASSIGN","IS_PP_IN_PP","ALREADY_ASSIGNED","NEVER_CREATE_METHODS"
   FROM "UNILAB".utassignfulltestplan;
--------------------------------------------------------
--  DDL for View UVAU
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVAU" ("AU", "VERSION", "VERSION_IS_CURRENT", "EFFECTIVE_FROM", "EFFECTIVE_TILL", "DESCRIPTION", "DESCRIPTION2", "IS_PROTECTED", "SINGLE_VALUED", "NEW_VAL_ALLOWED", "STORE_DB", "INHERIT_AU", "SHORTCUT", "VALUE_LIST_TP", "DEFAULT_VALUE", "RUN_MODE", "SERVICE", "CF_VALUE", "LAST_COMMENT", "AU_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "EFFECTIVE_FROM_TZ", "EFFECTIVE_TILL_TZ") AS 
  SELECT "AU","VERSION","VERSION_IS_CURRENT","EFFECTIVE_FROM","EFFECTIVE_TILL","DESCRIPTION","DESCRIPTION2","IS_PROTECTED","SINGLE_VALUED","NEW_VAL_ALLOWED","STORE_DB","INHERIT_AU","SHORTCUT","VALUE_LIST_TP","DEFAULT_VALUE","RUN_MODE","SERVICE","CF_VALUE","LAST_COMMENT","AU_CLASS","LOG_HS","LOG_HS_DETAILS","ALLOW_MODIFY","ACTIVE","LC","LC_VERSION","SS","EFFECTIVE_FROM_TZ","EFFECTIVE_TILL_TZ"
   FROM "UNILAB".utau;
--------------------------------------------------------
--  DDL for View UVAUHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVAUHS" ("AU", "VERSION", "WHO", "WHO_DESCRIPTION", "WHAT", "WHAT_DESCRIPTION", "LOGDATE", "WHY", "TR_SEQ", "EV_SEQ", "LOGDATE_TZ") AS 
  SELECT "AU","VERSION","WHO","WHO_DESCRIPTION","WHAT","WHAT_DESCRIPTION","LOGDATE","WHY","TR_SEQ","EV_SEQ","LOGDATE_TZ"
   FROM "UNILAB".utauhs;
--------------------------------------------------------
--  DDL for View UVAUHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVAUHSDETAILS" ("AU", "VERSION", "TR_SEQ", "EV_SEQ", "SEQ", "DETAILS") AS 
  SELECT "AU","VERSION","TR_SEQ","EV_SEQ","SEQ","DETAILS"
   FROM "UNILAB".utauhsdetails;
--------------------------------------------------------
--  DDL for View UVAULIST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVAULIST" ("AU", "VERSION", "SEQ", "VALUE") AS 
  SELECT "AU","VERSION","SEQ","VALUE"
   FROM "UNILAB".utaulist;
--------------------------------------------------------
--  DDL for View UVAUSQL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVAUSQL" ("AU", "VERSION", "SEQ", "SQLTEXT") AS 
  SELECT "AU","VERSION","SEQ","SQLTEXT"
   FROM "UNILAB".utausql;
--------------------------------------------------------
--  DDL for View UVBLOB
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVBLOB" ("ID", "DESCRIPTION", "OBJECT_LINK", "KEY1", "KEY2", "KEY3", "KEY4", "KEY5", "URL", "DATA") AS 
  SELECT "ID","DESCRIPTION","OBJECT_LINK","KEY1","KEY2","KEY3","KEY4","KEY5","URL","DATA"
   FROM "UNILAB".utblob;
--------------------------------------------------------
--  DDL for View UVBLOBHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVBLOBHS" ("ID", "WHO", "WHO_DESCRIPTION", "WHAT", "WHAT_DESCRIPTION", "LOGDATE", "WHY", "TR_SEQ", "EV_SEQ", "LOGDATE_TZ") AS 
  SELECT "ID","WHO","WHO_DESCRIPTION","WHAT","WHAT_DESCRIPTION","LOGDATE","WHY","TR_SEQ","EV_SEQ","LOGDATE_TZ"
   FROM "UNILAB".utblobhs;
--------------------------------------------------------
--  DDL for View UVCATALOGUEDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVCATALOGUEDETAILS" ("CATALOGUE", "FROM_DATE", "TO_DATE", "SEQ_NR", "OBJECT_TP", "OBJECT_ID", "OBJECT_VERSION", "PP_KEY1", "PP_KEY2", "PP_KEY3", "PP_KEY4", "PP_KEY5", "CRITERIUM1", "CRITERIUM2", "CRITERIUM3", "DESCRIPTION", "INPUT_PRICE", "INPUT_CURR", "DISC_ABS", "DISC_REL", "CALC_DISC", "NET_PRICE", "AC_CODE", "FROM_DATE_TZ", "TO_DATE_TZ") AS 
  SELECT "CATALOGUE","FROM_DATE","TO_DATE","SEQ_NR","OBJECT_TP","OBJECT_ID","OBJECT_VERSION","PP_KEY1","PP_KEY2","PP_KEY3","PP_KEY4","PP_KEY5","CRITERIUM1","CRITERIUM2","CRITERIUM3","DESCRIPTION","INPUT_PRICE","INPUT_CURR","DISC_ABS","DISC_REL","CALC_DISC","NET_PRICE","AC_CODE","FROM_DATE_TZ","TO_DATE_TZ"
   FROM "UNILAB".utcataloguedetails;
--------------------------------------------------------
--  DDL for View UVCATALOGUEID
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVCATALOGUEID" ("CATALOGUE", "DESCRIPTION", "CATALOGUE_TYPE") AS 
  SELECT "CATALOGUE","DESCRIPTION","CATALOGUE_TYPE"
   FROM "UNILAB".utcatalogueid;
--------------------------------------------------------
--  DDL for View UVCD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVCD" ("CD", "SETTING_NAME", "SETTING_VALUE", "SETTING_SEQ") AS 
  SELECT "CD","SETTING_NAME","SETTING_VALUE","SETTING_SEQ"
   FROM "UNILAB".utcd;
--------------------------------------------------------
--  DDL for View UVCF
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVCF" ("CF", "DESCRIPTION", "CF_TYPE", "CF_FILE") AS 
  SELECT "CF","DESCRIPTION","CF_TYPE","CF_FILE"
   FROM "UNILAB".utcf;
--------------------------------------------------------
--  DDL for View UVCH
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVCH" ("CH", "CY", "CY_VERSION", "DESCRIPTION", "CHART_TITLE", "X_AXIS_TITLE", "Y_AXIS_TITLE", "Y_AXIS_UNIT", "CREATION_DATE", "CREATION_DATE_TZ", "CH_CONTEXT_KEY", "DATAPOINT_CNT", "DATAPOINT_UNIT", "XR_MEASUREMENTS", "XR_MAX_CHARTS", "SQC_AVG", "SQC_STD_DEV", "SQC_AVG_RANGE", "SQC_STD_DEV_RANGE", "EXEC_START_DATE", "EXEC_START_DATE_TZ", "EXEC_END_DATE", "EXEC_END_DATE_TZ", "ASSIGN_CF", "CY_CALC_CF", "VISUAL_CF", "VALID_SQC_RULE1", "VALID_SQC_RULE2", "VALID_SQC_RULE3", "VALID_SQC_RULE4", "VALID_SQC_RULE5", "VALID_SQC_RULE6", "VALID_SQC_RULE7", "XR_SERIE_SEQ", "LAST_COMMENT", "CH_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR") AS 
  SELECT
   ch,
   cy,
   cy_version,
   description,
   chart_title,
   X_axis_title,
   Y_axis_title,
   Y_axis_unit,
   creation_date,
   creation_date_tz,
   ch_context_key,
   datapoint_cnt,
   datapoint_unit,
   xr_measurements,
   xr_max_charts,
   sqc_avg,
   sqc_std_dev,
   sqc_avg_range,
   sqc_std_dev_range,
   exec_start_date,
   exec_start_date_tz,
   exec_end_date,
   exec_end_date_tz,
   assign_cf,
   cy_calc_cf,
   visual_cf,
   valid_sqc_rule1,
   valid_sqc_rule2,
   valid_sqc_rule3,
   valid_sqc_rule4,
   valid_sqc_rule5,
   valid_sqc_rule6,
   valid_sqc_rule7,
   xr_serie_seq,
   last_comment,
   ch_class,
   log_hs,
   log_hs_details,
   allow_modify,
   active,
   lc,
   lc_version,
   ss,
 'W' ar
FROM "UNILAB".utch;
--------------------------------------------------------
--  DDL for View UVCHAU
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVCHAU" ("CH", "AU", "AU_VERSION", "AUSEQ", "VALUE") AS 
  SELECT "CH","AU","AU_VERSION","AUSEQ","VALUE"
FROM "UNILAB".utchau;
--------------------------------------------------------
--  DDL for View UVCHDP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVCHDP" ("CH", "DATAPOINT_SEQ", "MEASURE_SEQ", "X_VALUE_F", "X_VALUE_S", "X_VALUE_D", "DATAPOINT_VALUE_F", "DATAPOINT_VALUE_S", "DATAPOINT_LABEL", "DATAPOINT_MARKER", "DATAPOINT_COLOUR", "DATAPOINT_LINK", "Z_VALUE_F", "Z_VALUE_S", "DATAPOINT_RANGE", "SQC_AVG", "SQC_AVG_RANGE", "SQC_STD_DEV", "SQC_STD_DEV_RANGE", "SPEC1", "SPEC2", "SPEC3", "SPEC4", "SPEC5", "SPEC6", "SPEC7", "SPEC8", "SPEC9", "SPEC10", "SPEC11", "SPEC12", "SPEC13", "SPEC14", "SPEC15", "ACTIVE", "X_VALUE_D_TZ", "RULE1_VIOLATED", "RULE2_VIOLATED", "RULE3_VIOLATED", "RULE4_VIOLATED", "RULE5_VIOLATED", "RULE6_VIOLATED", "RULE7_VIOLATED") AS 
  SELECT "CH","DATAPOINT_SEQ","MEASURE_SEQ","X_VALUE_F","X_VALUE_S","X_VALUE_D","DATAPOINT_VALUE_F","DATAPOINT_VALUE_S","DATAPOINT_LABEL","DATAPOINT_MARKER","DATAPOINT_COLOUR","DATAPOINT_LINK","Z_VALUE_F","Z_VALUE_S","DATAPOINT_RANGE","SQC_AVG","SQC_AVG_RANGE","SQC_STD_DEV","SQC_STD_DEV_RANGE","SPEC1","SPEC2","SPEC3","SPEC4","SPEC5","SPEC6","SPEC7","SPEC8","SPEC9","SPEC10","SPEC11","SPEC12","SPEC13","SPEC14","SPEC15","ACTIVE","X_VALUE_D_TZ","RULE1_VIOLATED","RULE2_VIOLATED","RULE3_VIOLATED","RULE4_VIOLATED","RULE5_VIOLATED","RULE6_VIOLATED","RULE7_VIOLATED"
FROM "UNILAB".utchdp;
--------------------------------------------------------
--  DDL for View UVCHGK
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVCHGK" ("CH", "GK", "GK_VERSION", "GKSEQ", "VALUE") AS 
  SELECT "CH","GK","GK_VERSION","GKSEQ","VALUE"
FROM "UNILAB".utchgk;
--------------------------------------------------------
--  DDL for View UVCHHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVCHHS" ("CH", "WHO", "WHO_DESCRIPTION", "WHAT", "WHAT_DESCRIPTION", "LOGDATE", "WHY", "TR_SEQ", "EV_SEQ", "LOGDATE_TZ") AS 
  SELECT "CH","WHO","WHO_DESCRIPTION","WHAT","WHAT_DESCRIPTION","LOGDATE","WHY","TR_SEQ","EV_SEQ","LOGDATE_TZ"
FROM "UNILAB".utchhs;
--------------------------------------------------------
--  DDL for View UVCHHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVCHHSDETAILS" ("CH", "TR_SEQ", "EV_SEQ", "SEQ", "DETAILS") AS 
  SELECT "CH","TR_SEQ","EV_SEQ","SEQ","DETAILS"
FROM "UNILAB".utchhsdetails;
--------------------------------------------------------
--  DDL for View UVCLIENT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVCLIENT" ("CLIENT_ID", "EVMGR_NAME", "EVMGR_TP", "EVMGR_PUBLIC") AS 
  SELECT "CLIENT_ID","EVMGR_NAME","EVMGR_TP","EVMGR_PUBLIC"
   FROM "UNILAB".utclient;
--------------------------------------------------------
--  DDL for View UVCLIENTALERTS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVCLIENTALERTS" ("ALERT_SEQ", "ALERT_NAME", "ALERT_DATA") AS 
  SELECT "ALERT_SEQ","ALERT_NAME","ALERT_DATA"
   FROM "UNILAB".utclientalerts;
--------------------------------------------------------
--  DDL for View UVCOMMENT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVCOMMENT" ("COMMENT_GROUP", "SEQ", "STD_COMMENT") AS 
  SELECT "COMMENT_GROUP","SEQ","STD_COMMENT"
   FROM "UNILAB".utcomment;
--------------------------------------------------------
--  DDL for View UVCOMPARECUSTOMER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVCOMPARECUSTOMER" ("SC", "CUSTOMER", "PP", "PP_DESCRIPTION", "PP_VERSION", "PP_KEY1", "PP_KEY2", "PP_KEY3", "PP_KEY4", "PP_KEY5", "PP_SEQ", "PR", "PR_DESCRIPTION", "PR_VERSION", "PR_SEQ", "MT", "MT_VERSION", "MT_SEQ", "IS_PP_IN_PP", "VALUE_F", "UNIT", "LOW_LIMIT_A", "HIGH_LIMIT_A", "LOW_SPEC_A", "HIGH_SPEC_A", "LOW_DEV_A", "REL_LOW_DEV_A", "TARGET_A", "HIGH_DEV_A", "REL_HIGH_DEV_A", "LOW_LIMIT_B", "HIGH_LIMIT_B", "LOW_SPEC_B", "HIGH_SPEC_B", "LOW_DEV_B", "REL_LOW_DEV_B", "TARGET_B", "HIGH_DEV_B", "REL_HIGH_DEV_B", "LOW_LIMIT_C", "HIGH_LIMIT_C", "LOW_SPEC_C", "HIGH_SPEC_C", "LOW_DEV_C", "REL_LOW_DEV_C", "TARGET_C", "HIGH_DEV_C", "REL_HIGH_DEV_C", "LIMIT_A_COMPLIANT", "SPEC_A_COMPLIANT", "TARGET_A_COMPLIANT", "LIMIT_B_COMPLIANT", "SPEC_B_COMPLIANT", "TARGET_B_COMPLIANT", "LIMIT_C_COMPLIANT", "SPEC_C_COMPLIANT", "TARGET_C_COMPLIANT", "ALL_COMPLIANT") AS 
  SELECT "SC","CUSTOMER","PP","PP_DESCRIPTION","PP_VERSION","PP_KEY1","PP_KEY2","PP_KEY3","PP_KEY4","PP_KEY5","PP_SEQ","PR","PR_DESCRIPTION","PR_VERSION","PR_SEQ","MT","MT_VERSION","MT_SEQ","IS_PP_IN_PP","VALUE_F","UNIT","LOW_LIMIT_A","HIGH_LIMIT_A","LOW_SPEC_A","HIGH_SPEC_A","LOW_DEV_A","REL_LOW_DEV_A","TARGET_A","HIGH_DEV_A","REL_HIGH_DEV_A","LOW_LIMIT_B","HIGH_LIMIT_B","LOW_SPEC_B","HIGH_SPEC_B","LOW_DEV_B","REL_LOW_DEV_B","TARGET_B","HIGH_DEV_B","REL_HIGH_DEV_B","LOW_LIMIT_C","HIGH_LIMIT_C","LOW_SPEC_C","HIGH_SPEC_C","LOW_DEV_C","REL_LOW_DEV_C","TARGET_C","HIGH_DEV_C","REL_HIGH_DEV_C","LIMIT_A_COMPLIANT","SPEC_A_COMPLIANT","TARGET_A_COMPLIANT","LIMIT_B_COMPLIANT","SPEC_B_COMPLIANT","TARGET_B_COMPLIANT","LIMIT_C_COMPLIANT","SPEC_C_COMPLIANT","TARGET_C_COMPLIANT","ALL_COMPLIANT"
   FROM "UNILAB".utcomparecustomer;
--------------------------------------------------------
--  DDL for View UVCOUNTER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVCOUNTER" ("COUNTER", "CURR_CNT", "LOW_CNT", "HIGH_CNT", "INCR_CNT", "FIXED_LENGTH", "CIRCULAR") AS 
  SELECT "COUNTER","CURR_CNT","LOW_CNT","HIGH_CNT","INCR_CNT","FIXED_LENGTH","CIRCULAR"
   FROM "UNILAB".utcounter;
--------------------------------------------------------
--  DDL for View UVCS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVCS" ("CS", "DESCRIPTION", "DESCRIPTION2") AS 
  SELECT "CS","DESCRIPTION","DESCRIPTION2"
   FROM "UNILAB".utcs;
--------------------------------------------------------
--  DDL for View UVCSAU
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVCSAU" ("CS", "AU", "AU_VERSION", "AUSEQ", "VALUE") AS 
  SELECT "CS","AU","AU_VERSION","AUSEQ","VALUE"
   FROM "UNILAB".utcsau;
--------------------------------------------------------
--  DDL for View UVCSCN
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVCSCN" ("CS", "CN", "CNSEQ", "VALUE") AS 
  SELECT "CS","CN","CNSEQ","VALUE"
   FROM "UNILAB".utcscn;
--------------------------------------------------------
--  DDL for View UVCURRENCY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVCURRENCY" ("CURRENCY", "IS_DEFAULT", "ROUNDING", "CONVERSION") AS 
  SELECT "CURRENCY","IS_DEFAULT","ROUNDING","CONVERSION"
   FROM "UNILAB".utcurrency;
--------------------------------------------------------
--  DDL for View UVCY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVCY" ("CY", "VERSION", "VERSION_IS_CURRENT", "EFFECTIVE_FROM", "EFFECTIVE_FROM_TZ", "EFFECTIVE_TILL", "EFFECTIVE_TILL_TZ", "DESCRIPTION", "DESCRIPTION2", "IS_TEMPLATE", "CHART_TITLE", "X_AXIS_TITLE", "Y_AXIS_TITLE", "Y_AXIS_UNIT", "X_LABEL", "DATAPOINT_CNT", "DATAPOINT_UNIT", "XR_MEASUREMENTS", "XR_MAX_CHARTS", "ASSIGN_CF", "CY_CALC_CF", "VISUAL_CF", "VALID_SQC_RULE1", "VALID_SQC_RULE2", "VALID_SQC_RULE3", "VALID_SQC_RULE4", "VALID_SQC_RULE5", "VALID_SQC_RULE6", "VALID_SQC_RULE7", "CH_LC", "CH_LC_VERSION", "INHERIT_AU", "LAST_COMMENT", "CY_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR") AS 
  SELECT
   cy,
   version,
   version_is_current,
   effective_from,
   effective_from_tz,
   effective_till,
   effective_till_tz,
   description,
   description2,
   is_template,
   chart_title,
   X_axis_title,
   Y_axis_title,
   Y_axis_unit,
   x_label,
   datapoint_cnt,
   datapoint_unit,
   xr_measurements,
   xr_max_CHARts,
   assign_cf,
   cy_calc_cf,
   visual_cf,
   valid_sqc_rule1,
   valid_sqc_rule2,
   valid_sqc_rule3,
   valid_sqc_rule4,
   valid_sqc_rule5,
   valid_sqc_rule6,
   valid_sqc_rule7,
   ch_lc,
   ch_lc_version,
   inherit_au,
   last_comment,
   cy_class,
   log_hs,
   log_hs_details,
   allow_modify,
   active,
   lc,
   lc_version,
   ss,
 'W' ar
FROM "UNILAB".utcy;
--------------------------------------------------------
--  DDL for View UVCYAU
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVCYAU" ("CY", "VERSION", "AU", "AU_VERSION", "AUSEQ", "VALUE") AS 
  SELECT "CY","VERSION","AU","AU_VERSION","AUSEQ","VALUE"
FROM "UNILAB".utcyau;
--------------------------------------------------------
--  DDL for View UVCYHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVCYHS" ("CY", "VERSION", "WHO", "WHAT", "LOGDATE", "WHY", "WHO_DESCRIPTION", "WHAT_DESCRIPTION", "TR_SEQ", "EV_SEQ", "LOGDATE_TZ") AS 
  SELECT "CY","VERSION","WHO","WHAT","LOGDATE","WHY","WHO_DESCRIPTION","WHAT_DESCRIPTION","TR_SEQ","EV_SEQ","LOGDATE_TZ"
FROM "UNILAB".utcyhs;
--------------------------------------------------------
--  DDL for View UVCYHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVCYHSDETAILS" ("CY", "VERSION", "TR_SEQ", "EV_SEQ", "SEQ", "DETAILS") AS 
  SELECT "CY","VERSION","TR_SEQ","EV_SEQ","SEQ","DETAILS"
FROM "UNILAB".utcyhsdetails;
--------------------------------------------------------
--  DDL for View UVCYSTYLE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVCYSTYLE" ("VISUAL_CF", "CY", "VERSION", "SEQ", "PROP_NAME", "PROP_VALUE") AS 
  SELECT "VISUAL_CF","CY","VERSION","SEQ","PROP_NAME","PROP_VALUE"
   FROM "UNILAB".utcystyle;
--------------------------------------------------------
--  DDL for View UVCYSTYLELIST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVCYSTYLELIST" ("VISUAL_CF", "CY", "VERSION", "SEQ", "PROP_NAME", "PROP_VALUE") AS 
  SELECT "VISUAL_CF","CY","VERSION","SEQ","PROP_NAME","PROP_VALUE"
   FROM "UNILAB".utcystylelist;
--------------------------------------------------------
--  DDL for View UVDBA
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVDBA" ("SETTING_NAME", "SETTING_VALUE") AS 
  SELECT "SETTING_NAME","SETTING_VALUE"
   FROM "UNILAB".utdba;
--------------------------------------------------------
--  DDL for View UVDC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVDC" ("DC", "VERSION", "VERSION_IS_CURRENT", "EFFECTIVE_FROM", "EFFECTIVE_FROM_TZ", "EFFECTIVE_TILL", "EFFECTIVE_TILL_TZ", "DESCRIPTION", "CREATION_DATE", "CREATION_DATE_TZ", "CREATED_BY", "LAST_MODIFIED", "LAST_MODIFIED_TZ", "TOOLTIP", "URL", "DATA", "LAST_CHECKOUT_BY", "LAST_CHECKOUT_URL", "CHECKED_OUT", "LAST_COMMENT", "DC_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR") AS 
  SELECT
   dc,
   version,
   version_is_current,
   effective_from,
   effective_from_tz,
   effective_till,
   effective_till_tz,
   description,
   creation_date,
   creation_date_tz,
   created_by,
   last_modified,
   last_modified_tz,
   tooltip,
   url,
   data,
   last_checkout_by,
   last_checkout_url,
   checked_out,
   last_comment,
   dc_class,
   log_hs,
   log_hs_details,
   allow_modify,
   active,
   lc,
   lc_version,
   ss,
 'W' ar
FROM "UNILAB".utdc;
--------------------------------------------------------
--  DDL for View UVDCAU
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVDCAU" ("DC", "VERSION", "AU", "AU_VERSION", "AUSEQ", "VALUE") AS 
  SELECT "DC","VERSION","AU","AU_VERSION","AUSEQ","VALUE"
FROM "UNILAB".utdcau;
--------------------------------------------------------
--  DDL for View UVDCGK
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVDCGK" ("DC", "VERSION", "GK", "GK_VERSION", "GKSEQ", "VALUE") AS 
  SELECT "DC","VERSION","GK","GK_VERSION","GKSEQ","VALUE"
FROM "UNILAB".utdcgk;
--------------------------------------------------------
--  DDL for View UVDCHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVDCHS" ("DC", "VERSION", "WHO", "WHO_DESCRIPTION", "WHAT", "WHAT_DESCRIPTION", "LOGDATE", "LOGDATE_TZ", "WHY", "TR_SEQ", "EV_SEQ") AS 
  SELECT "DC","VERSION","WHO","WHO_DESCRIPTION","WHAT","WHAT_DESCRIPTION","LOGDATE","LOGDATE_TZ","WHY","TR_SEQ","EV_SEQ"
FROM "UNILAB".utdchs;
--------------------------------------------------------
--  DDL for View UVDCHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVDCHSDETAILS" ("DC", "VERSION", "TR_SEQ", "EV_SEQ", "SEQ", "DETAILS") AS 
  SELECT "DC","VERSION","TR_SEQ","EV_SEQ","SEQ","DETAILS"
FROM "UNILAB".utdchsdetails;
--------------------------------------------------------
--  DDL for View UVDD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVDD" ("DD", "DESCRIPTION") AS 
  SELECT "DD","DESCRIPTION"
   FROM "UNILAB".utdd;
--------------------------------------------------------
--  DDL for View UVDECODE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVDECODE" ("CODE_TP", "CODE", "DESCRIPTION1", "DESCRIPTION2", "DESCRIPTION3", "DESCRIPTION4", "DESCRIPTION5", "DESCRIPTION6", "DESCRIPTION7", "DESCRIPTION8", "DESCRIPTION9", "DESCRIPTION10") AS 
  SELECT "CODE_TP","CODE","DESCRIPTION1","DESCRIPTION2","DESCRIPTION3","DESCRIPTION4","DESCRIPTION5","DESCRIPTION6","DESCRIPTION7","DESCRIPTION8","DESCRIPTION9","DESCRIPTION10"
   FROM "UNILAB".utdecode;
--------------------------------------------------------
--  DDL for View UVDELAY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVDELAY" ("SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE", "OBJECT_TP", "DELAY", "DELAY_UNIT", "DELAYED_FROM", "DELAYED_TILL", "DELAYED_FROM_TZ", "DELAYED_TILL_TZ") AS 
  SELECT "SC","PG","PGNODE","PA","PANODE","ME","MENODE","OBJECT_TP","DELAY","DELAY_UNIT","DELAYED_FROM","DELAYED_TILL","DELAYED_FROM_TZ","DELAYED_TILL_TZ"
   FROM "UNILAB".utdelay;
--------------------------------------------------------
--  DDL for View UVEDTBL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVEDTBL" ("SEQ", "TABLE_NAME", "DESCRIPTION", "LOG_HS", "LOG_HS_DETAILS", "WHERE_CLAUSE") AS 
  SELECT "SEQ","TABLE_NAME","DESCRIPTION","LOG_HS","LOG_HS_DETAILS","WHERE_CLAUSE"
   FROM "UNILAB".utedtbl;
--------------------------------------------------------
--  DDL for View UVEDTBLHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVEDTBLHS" ("TABLE_NAME", "WHO", "WHO_DESCRIPTION", "WHAT", "WHAT_DESCRIPTION", "LOGDATE", "WHY", "TR_SEQ", "EV_SEQ", "LOGDATE_TZ") AS 
  SELECT "TABLE_NAME","WHO","WHO_DESCRIPTION","WHAT","WHAT_DESCRIPTION","LOGDATE","WHY","TR_SEQ","EV_SEQ","LOGDATE_TZ"
   FROM "UNILAB".utedtblhs;
--------------------------------------------------------
--  DDL for View UVEDTBLHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVEDTBLHSDETAILS" ("TABLE_NAME", "TR_SEQ", "EV_SEQ", "SEQ", "DETAILS") AS 
  SELECT "TABLE_NAME","TR_SEQ","EV_SEQ","SEQ","DETAILS"
   FROM "UNILAB".utedtblhsdetails;
--------------------------------------------------------
--  DDL for View UVEDTBLTMP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVEDTBLTMP" ("OBJECT_TP", "OBJECT_PK", "OBJECT_KEY", "ROW_VALUES", "MODIFY_FLAG") AS 
  SELECT "OBJECT_TP","OBJECT_PK","OBJECT_KEY","ROW_VALUES","MODIFY_FLAG"
   FROM "UNILAB".utedtbltmp;
--------------------------------------------------------
--  DDL for View UVEL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVEL" ("EL", "DESCR_DOC", "DESCR_DOC_VERSION") AS 
  SELECT "EL","DESCR_DOC","DESCR_DOC_VERSION"
   FROM "UNILAB".utel;
--------------------------------------------------------
--  DDL for View UVEQ
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVEQ" ("EQ", "LAB", "VERSION", "VERSION_IS_CURRENT", "EFFECTIVE_FROM", "EFFECTIVE_FROM_TZ", "EFFECTIVE_TILL", "EFFECTIVE_TILL_TZ", "DESCRIPTION", "SERIAL_NO", "SUPPLIER", "LOCATION", "INVEST_COST", "INVEST_UNIT", "USAGE_COST", "USAGE_UNIT", "INSTALL_DATE", "INSTALL_DATE_TZ", "IN_SERVICE_DATE", "IN_SERVICE_DATE_TZ", "ACCESSORIES", "OPERATION", "OPERATION_DOC", "OPERATION_DOC_VERSION", "USAGE", "USAGE_DOC", "USAGE_DOC_VERSION", "EQ_CLASS", "EQ_COMPONENT", "KEEP_CTOLD", "KEEP_CTOLD_UNIT", "IS_TEMPLATE", "LAST_COMMENT", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "CA_WARN_LEVEL", "SS", "LC", "LC_VERSION", "AR") AS 
  SELECT
   eq,
   lab,
   version,
   version_is_current,
   effective_from,
   effective_from_tz,
   effective_till,
   effective_till_tz,
   description,
   serial_no,
   supplier,
   location,
   invest_cost,
   invest_unit,
   usage_cost,
   usage_unit,
   install_date,
   install_date_tz,
   in_service_date,
   in_service_date_tz,
   accessories,
   operation,
   operation_doc,
   operation_doc_version,
   usage,
   usage_doc,
   usage_doc_version,
   eq_class,
   eq_component,
   keep_ctold,
   keep_ctold_unit,
   is_template,
   last_comment,
   log_hs,
   log_hs_details,
   allow_modify,
   active,
   ca_warn_level,
   ss,
   lc,
   lc_version,
 'W' ar
FROM "UNILAB".uteq;
--------------------------------------------------------
--  DDL for View UVEQAU
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVEQAU" ("EQ", "LAB", "VERSION", "AU", "AU_VERSION", "AUSEQ", "VALUE") AS 
  SELECT "EQ","LAB","VERSION","AU","AU_VERSION","AUSEQ","VALUE"
FROM "UNILAB".uteqau;
--------------------------------------------------------
--  DDL for View UVEQCA
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVEQCA" ("EQ", "LAB", "VERSION", "CA", "SEQ", "DESCRIPTION", "SOP", "SOP_VERSION", "ST", "ST_VERSION", "MT", "MT_VERSION", "CAL_VAL", "CAL_COST", "CAL_TIME_VAL", "CAL_TIME_UNIT", "FREQ_TP", "FREQ_VAL", "FREQ_UNIT", "INVERT_FREQ", "LAST_SCHED", "LAST_VAL", "LAST_CNT", "SUSPEND", "GRACE_VAL", "GRACE_UNIT", "SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE", "CA_WARN_LEVEL", "LAST_SCHED_TZ") AS 
  SELECT "EQ","LAB","VERSION","CA","SEQ","DESCRIPTION","SOP","SOP_VERSION","ST","ST_VERSION","MT","MT_VERSION","CAL_VAL","CAL_COST","CAL_TIME_VAL","CAL_TIME_UNIT","FREQ_TP","FREQ_VAL","FREQ_UNIT","INVERT_FREQ","LAST_SCHED","LAST_VAL","LAST_CNT","SUSPEND","GRACE_VAL","GRACE_UNIT","SC","PG","PGNODE","PA","PANODE","ME","MENODE","CA_WARN_LEVEL","LAST_SCHED_TZ"
FROM "UNILAB".uteqca;
--------------------------------------------------------
--  DDL for View UVEQCALOG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVEQCALOG" ("EQ", "LAB", "VERSION", "CA", "SEQ", "WHO", "LOGDATE", "SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE", "CA_WARN_LEVEL", "WHY", "LOGDATE_TZ") AS 
  SELECT "EQ","LAB","VERSION","CA","SEQ","WHO","LOGDATE","SC","PG","PGNODE","PA","PANODE","ME","MENODE","CA_WARN_LEVEL","WHY","LOGDATE_TZ"
FROM "UNILAB".uteqcalog;
--------------------------------------------------------
--  DDL for View UVEQCD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVEQCD" ("EQ", "LAB", "VERSION", "CD", "SETTING_NAME", "SETTING_VALUE", "SETTING_SEQ") AS 
  SELECT "EQ","LAB","VERSION","CD","SETTING_NAME","SETTING_VALUE","SETTING_SEQ"
FROM "UNILAB".uteqcd;
--------------------------------------------------------
--  DDL for View UVEQCT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVEQCT" ("EQ", "LAB", "VERSION", "SEQ", "CT_NAME", "CA", "VALUE_S", "VALUE_F", "FORMAT", "UNIT") AS 
  SELECT "EQ","LAB","VERSION","SEQ","CT_NAME","CA","VALUE_S","VALUE_F","FORMAT","UNIT"
FROM "UNILAB".uteqct;
--------------------------------------------------------
--  DDL for View UVEQCTOLD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVEQCTOLD" ("EQ", "LAB", "VERSION", "SEQ", "EXEC_START_DATE", "CT_NAME", "CA", "VALUE_S", "VALUE_F", "FORMAT", "UNIT", "EXEC_START_DATE_TZ") AS 
  SELECT "EQ","LAB","VERSION","SEQ","EXEC_START_DATE","CT_NAME","CA","VALUE_S","VALUE_F","FORMAT","UNIT","EXEC_START_DATE_TZ"
FROM "UNILAB".uteqctold;
--------------------------------------------------------
--  DDL for View UVEQCYCT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVEQCYCT" ("EQ", "LAB", "VERSION", "CY", "CY_VERSION", "CT_NAME") AS 
  SELECT "EQ","LAB","VERSION","CY","CY_VERSION","CT_NAME"
FROM "UNILAB".uteqcyct;
--------------------------------------------------------
--  DDL for View UVEQHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVEQHS" ("EQ", "LAB", "VERSION", "WHO", "WHO_DESCRIPTION", "WHAT", "WHAT_DESCRIPTION", "LOGDATE", "WHY", "TR_SEQ", "EV_SEQ", "LOGDATE_TZ") AS 
  SELECT "EQ","LAB","VERSION","WHO","WHO_DESCRIPTION","WHAT","WHAT_DESCRIPTION","LOGDATE","WHY","TR_SEQ","EV_SEQ","LOGDATE_TZ"
FROM "UNILAB".uteqhs;
--------------------------------------------------------
--  DDL for View UVEQHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVEQHSDETAILS" ("EQ", "LAB", "VERSION", "TR_SEQ", "EV_SEQ", "SEQ", "DETAILS") AS 
  SELECT "EQ","LAB","VERSION","TR_SEQ","EV_SEQ","SEQ","DETAILS"
FROM "UNILAB".uteqhsdetails;
--------------------------------------------------------
--  DDL for View UVEQMR
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVEQMR" ("EQ", "LAB", "VERSION", "SEQ", "COMPONENT", "L_DETECTION_LIMIT", "L_DETERM_LIMIT", "H_DETERM_LIMIT", "H_DETECTION_LIMIT", "UNIT") AS 
  SELECT "EQ","LAB","VERSION","SEQ","COMPONENT","L_DETECTION_LIMIT","L_DETERM_LIMIT","H_DETERM_LIMIT","H_DETECTION_LIMIT","UNIT"
FROM "UNILAB".uteqmr;
--------------------------------------------------------
--  DDL for View UVEQTYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVEQTYPE" ("EQ", "VERSION", "LAB", "EQ_TP", "SEQ") AS 
  SELECT "EQ","VERSION","LAB","EQ_TP","SEQ"
FROM "UNILAB".uteqtype;
--------------------------------------------------------
--  DDL for View UVERROR
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVERROR" ("CLIENT_ID", "APPLIC", "WHO", "LOGDATE", "LOGDATE_TZ", "API_NAME", "ERROR_MSG", "ERR_SEQ") AS 
  SELECT "CLIENT_ID","APPLIC","WHO","LOGDATE","LOGDATE_TZ","API_NAME","ERROR_MSG","ERR_SEQ"
   FROM "UNILAB".uterror;
--------------------------------------------------------
--  DDL for View UVEV
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVEV" ("TR_SEQ", "EV_SEQ", "CREATED_ON", "CLIENT_ID", "APPLIC", "DBAPI_NAME", "EVMGR_NAME", "OBJECT_TP", "OBJECT_ID", "OBJECT_LC", "OBJECT_LC_VERSION", "OBJECT_SS", "EV_TP", "USERNAME", "EV_DETAILS", "CREATED_ON_TZ") AS 
  SELECT "TR_SEQ","EV_SEQ","CREATED_ON","CLIENT_ID","APPLIC","DBAPI_NAME","EVMGR_NAME","OBJECT_TP","OBJECT_ID","OBJECT_LC","OBJECT_LC_VERSION","OBJECT_SS","EV_TP","USERNAME","EV_DETAILS","CREATED_ON_TZ"
   FROM "UNILAB".utev;
--------------------------------------------------------
--  DDL for View UVEVLOG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVEVLOG" ("TR_SEQ", "EV_SEQ", "EV_SESSION", "CREATED_ON", "CREATED_ON_TZ", "CLIENT_ID", "APPLIC", "DBAPI_NAME", "EVMGR_NAME", "OBJECT_TP", "OBJECT_ID", "OBJECT_LC", "OBJECT_LC_VERSION", "OBJECT_SS", "EV_TP", "USERNAME", "EV_DETAILS", "EXECUTED_ON", "EXECUTED_ON_TZ", "ERRORCODE", "INSTANCE_NUMBER", "WHAT") AS 
  SELECT "TR_SEQ","EV_SEQ","EV_SESSION","CREATED_ON","CREATED_ON_TZ","CLIENT_ID","APPLIC","DBAPI_NAME","EVMGR_NAME","OBJECT_TP","OBJECT_ID","OBJECT_LC","OBJECT_LC_VERSION","OBJECT_SS","EV_TP","USERNAME","EV_DETAILS","EXECUTED_ON","EXECUTED_ON_TZ","ERRORCODE","INSTANCE_NUMBER","WHAT"
   FROM "UNILAB".utevlog;
--------------------------------------------------------
--  DDL for View UVEVRULES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVEVRULES" ("RULE_NR", "APPLIC", "DBAPI_NAME", "OBJECT_TP", "OBJECT_ID", "OBJECT_LC", "OBJECT_LC_VERSION", "OBJECT_SS", "EV_TP", "CONDITION", "AF", "AF_DELAY", "AF_DELAY_UNIT", "CUSTOM") AS 
  SELECT "RULE_NR","APPLIC","DBAPI_NAME","OBJECT_TP","OBJECT_ID","OBJECT_LC","OBJECT_LC_VERSION","OBJECT_SS","EV_TP","CONDITION","AF","AF_DELAY","AF_DELAY_UNIT","CUSTOM"
   FROM "UNILAB".utevrules;
--------------------------------------------------------
--  DDL for View UVEVRULESDELAYED
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVEVRULESDELAYED" ("TR_SEQ", "EV_SEQ", "CLIENT_ID", "APPLIC", "DBAPI_NAME", "EVMGR_NAME", "OBJECT_TP", "OBJECT_ID", "OBJECT_LC", "OBJECT_LC_VERSION", "OBJECT_SS", "EV_TP", "USERNAME", "EV_DETAILS", "CONDITION", "AF", "AF_DELAY", "AF_DELAY_UNIT", "CREATED_ON", "EXECUTE_AT", "CREATED_ON_TZ", "EXECUTE_AT_TZ") AS 
  SELECT "TR_SEQ","EV_SEQ","CLIENT_ID","APPLIC","DBAPI_NAME","EVMGR_NAME","OBJECT_TP","OBJECT_ID","OBJECT_LC","OBJECT_LC_VERSION","OBJECT_SS","EV_TP","USERNAME","EV_DETAILS","CONDITION","AF","AF_DELAY","AF_DELAY_UNIT","CREATED_ON","EXECUTE_AT","CREATED_ON_TZ","EXECUTE_AT_TZ"
   FROM "UNILAB".utevrulesdelayed;
--------------------------------------------------------
--  DDL for View UVEVSERVICES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVEVSERVICES" ("EVSERVICE_NAME", "CREATED_ON", "CREATED_ON_TZ") AS 
  SELECT "EVSERVICE_NAME","CREATED_ON","CREATED_ON_TZ"
   FROM "UNILAB".utevservices;
--------------------------------------------------------
--  DDL for View UVEVSINK
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVEVSINK" ("TR_SEQ", "EV_SEQ", "CREATED_ON", "CLIENT_ID", "APPLIC", "DBAPI_NAME", "EVSERVICE_NAME", "OBJECT_TP", "OBJECT_ID", "OBJECT_LC", "OBJECT_LC_VERSION", "OBJECT_SS", "EV_TP", "USERNAME", "EV_DETAILS", "HANDLED_OK", "CREATED_ON_TZ") AS 
  SELECT "TR_SEQ","EV_SEQ","CREATED_ON","CLIENT_ID","APPLIC","DBAPI_NAME","EVSERVICE_NAME","OBJECT_TP","OBJECT_ID","OBJECT_LC","OBJECT_LC_VERSION","OBJECT_SS","EV_TP","USERNAME","EV_DETAILS","HANDLED_OK","CREATED_ON_TZ"
   FROM "UNILAB".utevsink;
--------------------------------------------------------
--  DDL for View UVEVSTAT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVEVSTAT" ("EV_CLIENT_ID", "EV_APPLIC", "EV_DBAPI_NAME", "EV_EVMGR_NAME", "EV_OBJECT_TP", "EV_OBJECT_ID", "EV_OBJECT_LC", "EV_OBJECT_LC_VERSION", "EV_OBJECT_SS", "EV_EV_TP", "LC_OBJECT_TP", "LC_OBJECT_ID", "LC_OBJECT_LC", "LC_TRANS", "LC_EV_RULE_EXEC") AS 
  SELECT "EV_CLIENT_ID","EV_APPLIC","EV_DBAPI_NAME","EV_EVMGR_NAME","EV_OBJECT_TP","EV_OBJECT_ID","EV_OBJECT_LC","EV_OBJECT_LC_VERSION","EV_OBJECT_SS","EV_EV_TP","LC_OBJECT_TP","LC_OBJECT_ID","LC_OBJECT_LC","LC_TRANS","LC_EV_RULE_EXEC"
   FROM "UNILAB".utevstat;
--------------------------------------------------------
--  DDL for View UVEVTIMED
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVEVTIMED" ("EV_SEQ", "CREATED_ON", "CLIENT_ID", "APPLIC", "DBAPI_NAME", "EVMGR_NAME", "OBJECT_TP", "OBJECT_ID", "OBJECT_LC", "OBJECT_LC_VERSION", "OBJECT_SS", "EV_TP", "USERNAME", "EV_DETAILS", "EXECUTE_AT", "CREATED_ON_TZ", "EXECUTE_AT_TZ") AS 
  SELECT "EV_SEQ","CREATED_ON","CLIENT_ID","APPLIC","DBAPI_NAME","EVMGR_NAME","OBJECT_TP","OBJECT_ID","OBJECT_LC","OBJECT_LC_VERSION","OBJECT_SS","EV_TP","USERNAME","EV_DETAILS","EXECUTE_AT","CREATED_ON_TZ","EXECUTE_AT_TZ"
   FROM "UNILAB".utevtimed;
--------------------------------------------------------
--  DDL for View UVEVTRACE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVEVTRACE" ("LOGDATE", "SEQ", "TEXT", "LOGDATE_TZ") AS 
  SELECT "LOGDATE","SEQ","TEXT","LOGDATE_TZ"
   FROM "UNILAB".utevtrace;
--------------------------------------------------------
--  DDL for View UVFA
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVFA" ("APPLIC", "DESCRIPTION", "SEQ", "TOPIC", "TOPIC_DESCRIPTION", "FA") AS 
  SELECT "APPLIC","DESCRIPTION","SEQ","TOPIC","TOPIC_DESCRIPTION","FA"
   FROM "UNILAB".utfa;
--------------------------------------------------------
--  DDL for View UVFI
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVFI" ("FI", "VERSION", "VERSION_IS_CURRENT", "EFFECTIVE_FROM", "EFFECTIVE_TILL", "CREATION_DATE", "CREATED_BY", "DLL_ID", "CPP_ID", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "EFFECTIVE_FROM_TZ", "EFFECTIVE_TILL_TZ", "CREATION_DATE_TZ") AS 
  SELECT "FI","VERSION","VERSION_IS_CURRENT","EFFECTIVE_FROM","EFFECTIVE_TILL","CREATION_DATE","CREATED_BY","DLL_ID","CPP_ID","LOG_HS","LOG_HS_DETAILS","ALLOW_MODIFY","ACTIVE","LC","LC_VERSION","SS","EFFECTIVE_FROM_TZ","EFFECTIVE_TILL_TZ","CREATION_DATE_TZ"
   FROM "UNILAB".utfi;
--------------------------------------------------------
--  DDL for View UVFIHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVFIHS" ("FI", "VERSION", "WHO", "WHO_DESCRIPTION", "WHAT", "WHAT_DESCRIPTION", "LOGDATE", "WHY", "TR_SEQ", "EV_SEQ", "LOGDATE_TZ") AS 
  SELECT "FI","VERSION","WHO","WHO_DESCRIPTION","WHAT","WHAT_DESCRIPTION","LOGDATE","WHY","TR_SEQ","EV_SEQ","LOGDATE_TZ"
   FROM "UNILAB".utfihs;
--------------------------------------------------------
--  DDL for View UVFIHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVFIHSDETAILS" ("FI", "VERSION", "TR_SEQ", "EV_SEQ", "SEQ", "DETAILS") AS 
  SELECT "FI","VERSION","TR_SEQ","EV_SEQ","SEQ","DETAILS"
   FROM "UNILAB".utfihsdetails;
--------------------------------------------------------
--  DDL for View UVGKCH
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVGKCH" ("GK", "VERSION", "VERSION_IS_CURRENT", "EFFECTIVE_FROM", "EFFECTIVE_FROM_TZ", "EFFECTIVE_TILL", "EFFECTIVE_TILL_TZ", "DESCRIPTION", "IS_PROTECTED", "VALUE_UNIQUE", "SINGLE_VALUED", "NEW_VAL_ALLOWED", "MANDATORY", "STRUCT_CREATED", "INHERIT_GK", "VALUE_LIST_TP", "DEFAULT_VALUE", "DSP_ROWS", "VAL_LENGTH", "VAL_START", "ASSIGN_TP", "ASSIGN_ID", "Q_TP", "Q_ID", "Q_CHECK_AU", "Q_AU", "LAST_COMMENT", "GK_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS") AS 
  SELECT "GK","VERSION","VERSION_IS_CURRENT","EFFECTIVE_FROM","EFFECTIVE_FROM_TZ","EFFECTIVE_TILL","EFFECTIVE_TILL_TZ","DESCRIPTION","IS_PROTECTED","VALUE_UNIQUE","SINGLE_VALUED","NEW_VAL_ALLOWED","MANDATORY","STRUCT_CREATED","INHERIT_GK","VALUE_LIST_TP","DEFAULT_VALUE","DSP_ROWS","VAL_LENGTH","VAL_START","ASSIGN_TP","ASSIGN_ID","Q_TP","Q_ID","Q_CHECK_AU","Q_AU","LAST_COMMENT","GK_CLASS","LOG_HS","LOG_HS_DETAILS","ALLOW_MODIFY","ACTIVE","LC","LC_VERSION","SS"
   FROM "UNILAB".utgkch;
--------------------------------------------------------
--  DDL for View UVGKCHHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVGKCHHS" ("GK", "VERSION", "WHO", "WHO_DESCRIPTION", "WHAT", "WHAT_DESCRIPTION", "LOGDATE", "LOGDATE_TZ", "WHY", "TR_SEQ", "EV_SEQ") AS 
  SELECT "GK","VERSION","WHO","WHO_DESCRIPTION","WHAT","WHAT_DESCRIPTION","LOGDATE","LOGDATE_TZ","WHY","TR_SEQ","EV_SEQ"
   FROM "UNILAB".utgkchhs;
--------------------------------------------------------
--  DDL for View UVGKCHHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVGKCHHSDETAILS" ("GK", "VERSION", "TR_SEQ", "EV_SEQ", "SEQ", "DETAILS") AS 
  SELECT "GK","VERSION","TR_SEQ","EV_SEQ","SEQ","DETAILS"
   FROM "UNILAB".utgkchhsdetails;
--------------------------------------------------------
--  DDL for View UVGKCHLIST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVGKCHLIST" ("GK", "VERSION", "SEQ", "VALUE") AS 
  SELECT "GK","VERSION","SEQ","VALUE"
   FROM "UNILAB".utgkchlist;
--------------------------------------------------------
--  DDL for View UVGKCHSQL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVGKCHSQL" ("GK", "VERSION", "SEQ", "SQLTEXT") AS 
  SELECT "GK","VERSION","SEQ","SQLTEXT"
   FROM "UNILAB".utgkchsql;
--------------------------------------------------------
--  DDL for View UVGKDC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVGKDC" ("GK", "VERSION", "VERSION_IS_CURRENT", "EFFECTIVE_FROM", "EFFECTIVE_FROM_TZ", "EFFECTIVE_TILL", "EFFECTIVE_TILL_TZ", "DESCRIPTION", "IS_PROTECTED", "VALUE_UNIQUE", "SINGLE_VALUED", "NEW_VAL_ALLOWED", "MANDATORY", "STRUCT_CREATED", "INHERIT_GK", "VALUE_LIST_TP", "DEFAULT_VALUE", "DSP_ROWS", "VAL_LENGTH", "VAL_START", "ASSIGN_TP", "ASSIGN_ID", "Q_TP", "Q_ID", "Q_CHECK_AU", "Q_AU", "LAST_COMMENT", "GK_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS") AS 
  SELECT "GK","VERSION","VERSION_IS_CURRENT","EFFECTIVE_FROM","EFFECTIVE_FROM_TZ","EFFECTIVE_TILL","EFFECTIVE_TILL_TZ","DESCRIPTION","IS_PROTECTED","VALUE_UNIQUE","SINGLE_VALUED","NEW_VAL_ALLOWED","MANDATORY","STRUCT_CREATED","INHERIT_GK","VALUE_LIST_TP","DEFAULT_VALUE","DSP_ROWS","VAL_LENGTH","VAL_START","ASSIGN_TP","ASSIGN_ID","Q_TP","Q_ID","Q_CHECK_AU","Q_AU","LAST_COMMENT","GK_CLASS","LOG_HS","LOG_HS_DETAILS","ALLOW_MODIFY","ACTIVE","LC","LC_VERSION","SS"
   FROM "UNILAB".utgkdc;
--------------------------------------------------------
--  DDL for View UVGKDCHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVGKDCHS" ("GK", "VERSION", "WHO", "WHO_DESCRIPTION", "WHAT", "WHAT_DESCRIPTION", "LOGDATE", "LOGDATE_TZ", "WHY", "TR_SEQ", "EV_SEQ") AS 
  SELECT "GK","VERSION","WHO","WHO_DESCRIPTION","WHAT","WHAT_DESCRIPTION","LOGDATE","LOGDATE_TZ","WHY","TR_SEQ","EV_SEQ"
   FROM "UNILAB".utgkdchs;
--------------------------------------------------------
--  DDL for View UVGKDCHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVGKDCHSDETAILS" ("GK", "VERSION", "TR_SEQ", "EV_SEQ", "SEQ", "DETAILS") AS 
  SELECT "GK","VERSION","TR_SEQ","EV_SEQ","SEQ","DETAILS"
   FROM "UNILAB".utgkdchsdetails;
--------------------------------------------------------
--  DDL for View UVGKDCLIST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVGKDCLIST" ("GK", "VERSION", "SEQ", "VALUE") AS 
  SELECT "GK","VERSION","SEQ","VALUE"
   FROM "UNILAB".utgkdclist;
--------------------------------------------------------
--  DDL for View UVGKDCSQL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVGKDCSQL" ("GK", "VERSION", "SEQ", "SQLTEXT") AS 
  SELECT "GK","VERSION","SEQ","SQLTEXT"
   FROM "UNILAB".utgkdcsql;
--------------------------------------------------------
--  DDL for View UVGKME
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVGKME" ("GK", "VERSION", "VERSION_IS_CURRENT", "EFFECTIVE_FROM", "EFFECTIVE_TILL", "DESCRIPTION", "IS_PROTECTED", "VALUE_UNIQUE", "SINGLE_VALUED", "NEW_VAL_ALLOWED", "MANDATORY", "STRUCT_CREATED", "INHERIT_GK", "VALUE_LIST_TP", "DEFAULT_VALUE", "DSP_ROWS", "VAL_LENGTH", "VAL_START", "ASSIGN_TP", "ASSIGN_ID", "Q_TP", "Q_ID", "Q_CHECK_AU", "Q_AU", "LAST_COMMENT", "GK_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "EFFECTIVE_FROM_TZ", "EFFECTIVE_TILL_TZ") AS 
  SELECT "GK","VERSION","VERSION_IS_CURRENT","EFFECTIVE_FROM","EFFECTIVE_TILL","DESCRIPTION","IS_PROTECTED","VALUE_UNIQUE","SINGLE_VALUED","NEW_VAL_ALLOWED","MANDATORY","STRUCT_CREATED","INHERIT_GK","VALUE_LIST_TP","DEFAULT_VALUE","DSP_ROWS","VAL_LENGTH","VAL_START","ASSIGN_TP","ASSIGN_ID","Q_TP","Q_ID","Q_CHECK_AU","Q_AU","LAST_COMMENT","GK_CLASS","LOG_HS","LOG_HS_DETAILS","ALLOW_MODIFY","ACTIVE","LC","LC_VERSION","SS","EFFECTIVE_FROM_TZ","EFFECTIVE_TILL_TZ"
   FROM "UNILAB".utgkme;
--------------------------------------------------------
--  DDL for View UVGKMEHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVGKMEHS" ("GK", "VERSION", "WHO", "WHO_DESCRIPTION", "WHAT", "WHAT_DESCRIPTION", "LOGDATE", "WHY", "TR_SEQ", "EV_SEQ", "LOGDATE_TZ") AS 
  SELECT "GK","VERSION","WHO","WHO_DESCRIPTION","WHAT","WHAT_DESCRIPTION","LOGDATE","WHY","TR_SEQ","EV_SEQ","LOGDATE_TZ"
   FROM "UNILAB".utgkmehs;
--------------------------------------------------------
--  DDL for View UVGKMEHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVGKMEHSDETAILS" ("GK", "VERSION", "TR_SEQ", "EV_SEQ", "SEQ", "DETAILS") AS 
  SELECT "GK","VERSION","TR_SEQ","EV_SEQ","SEQ","DETAILS"
   FROM "UNILAB".utgkmehsdetails;
--------------------------------------------------------
--  DDL for View UVGKMELIST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVGKMELIST" ("GK", "VERSION", "SEQ", "VALUE") AS 
  SELECT "GK","VERSION","SEQ","VALUE"
   FROM "UNILAB".utgkmelist;
--------------------------------------------------------
--  DDL for View UVGKMESQL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVGKMESQL" ("GK", "VERSION", "SEQ", "SQLTEXT") AS 
  SELECT "GK","VERSION","SEQ","SQLTEXT"
   FROM "UNILAB".utgkmesql;
--------------------------------------------------------
--  DDL for View UVGKPT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVGKPT" ("GK", "VERSION", "VERSION_IS_CURRENT", "EFFECTIVE_FROM", "EFFECTIVE_TILL", "DESCRIPTION", "IS_PROTECTED", "VALUE_UNIQUE", "SINGLE_VALUED", "NEW_VAL_ALLOWED", "MANDATORY", "STRUCT_CREATED", "INHERIT_GK", "VALUE_LIST_TP", "DEFAULT_VALUE", "DSP_ROWS", "VAL_LENGTH", "VAL_START", "ASSIGN_TP", "ASSIGN_ID", "Q_TP", "Q_ID", "Q_CHECK_AU", "Q_AU", "LAST_COMMENT", "GK_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "EFFECTIVE_FROM_TZ", "EFFECTIVE_TILL_TZ") AS 
  SELECT "GK","VERSION","VERSION_IS_CURRENT","EFFECTIVE_FROM","EFFECTIVE_TILL","DESCRIPTION","IS_PROTECTED","VALUE_UNIQUE","SINGLE_VALUED","NEW_VAL_ALLOWED","MANDATORY","STRUCT_CREATED","INHERIT_GK","VALUE_LIST_TP","DEFAULT_VALUE","DSP_ROWS","VAL_LENGTH","VAL_START","ASSIGN_TP","ASSIGN_ID","Q_TP","Q_ID","Q_CHECK_AU","Q_AU","LAST_COMMENT","GK_CLASS","LOG_HS","LOG_HS_DETAILS","ALLOW_MODIFY","ACTIVE","LC","LC_VERSION","SS","EFFECTIVE_FROM_TZ","EFFECTIVE_TILL_TZ"
   FROM "UNILAB".utgkpt;
--------------------------------------------------------
--  DDL for View UVGKPTHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVGKPTHS" ("GK", "VERSION", "WHO", "WHO_DESCRIPTION", "WHAT", "WHAT_DESCRIPTION", "LOGDATE", "WHY", "TR_SEQ", "EV_SEQ", "LOGDATE_TZ") AS 
  SELECT "GK","VERSION","WHO","WHO_DESCRIPTION","WHAT","WHAT_DESCRIPTION","LOGDATE","WHY","TR_SEQ","EV_SEQ","LOGDATE_TZ"
   FROM "UNILAB".utgkpths;
--------------------------------------------------------
--  DDL for View UVGKPTHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVGKPTHSDETAILS" ("GK", "VERSION", "TR_SEQ", "EV_SEQ", "SEQ", "DETAILS") AS 
  SELECT "GK","VERSION","TR_SEQ","EV_SEQ","SEQ","DETAILS"
   FROM "UNILAB".utgkpthsdetails;
--------------------------------------------------------
--  DDL for View UVGKPTLIST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVGKPTLIST" ("GK", "VERSION", "SEQ", "VALUE") AS 
  SELECT "GK","VERSION","SEQ","VALUE"
   FROM "UNILAB".utgkptlist;
--------------------------------------------------------
--  DDL for View UVGKPTSQL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVGKPTSQL" ("GK", "VERSION", "SEQ", "SQLTEXT") AS 
  SELECT "GK","VERSION","SEQ","SQLTEXT"
   FROM "UNILAB".utgkptsql;
--------------------------------------------------------
--  DDL for View UVGKRQ
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVGKRQ" ("GK", "VERSION", "VERSION_IS_CURRENT", "EFFECTIVE_FROM", "EFFECTIVE_TILL", "DESCRIPTION", "IS_PROTECTED", "VALUE_UNIQUE", "SINGLE_VALUED", "NEW_VAL_ALLOWED", "MANDATORY", "STRUCT_CREATED", "INHERIT_GK", "VALUE_LIST_TP", "DEFAULT_VALUE", "DSP_ROWS", "VAL_LENGTH", "VAL_START", "ASSIGN_TP", "ASSIGN_ID", "Q_TP", "Q_ID", "Q_CHECK_AU", "Q_AU", "LAST_COMMENT", "GK_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "EFFECTIVE_FROM_TZ", "EFFECTIVE_TILL_TZ") AS 
  SELECT "GK","VERSION","VERSION_IS_CURRENT","EFFECTIVE_FROM","EFFECTIVE_TILL","DESCRIPTION","IS_PROTECTED","VALUE_UNIQUE","SINGLE_VALUED","NEW_VAL_ALLOWED","MANDATORY","STRUCT_CREATED","INHERIT_GK","VALUE_LIST_TP","DEFAULT_VALUE","DSP_ROWS","VAL_LENGTH","VAL_START","ASSIGN_TP","ASSIGN_ID","Q_TP","Q_ID","Q_CHECK_AU","Q_AU","LAST_COMMENT","GK_CLASS","LOG_HS","LOG_HS_DETAILS","ALLOW_MODIFY","ACTIVE","LC","LC_VERSION","SS","EFFECTIVE_FROM_TZ","EFFECTIVE_TILL_TZ"
   FROM "UNILAB".utgkrq;
--------------------------------------------------------
--  DDL for View UVGKRQHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVGKRQHS" ("GK", "VERSION", "WHO", "WHO_DESCRIPTION", "WHAT", "WHAT_DESCRIPTION", "LOGDATE", "WHY", "TR_SEQ", "EV_SEQ", "LOGDATE_TZ") AS 
  SELECT "GK","VERSION","WHO","WHO_DESCRIPTION","WHAT","WHAT_DESCRIPTION","LOGDATE","WHY","TR_SEQ","EV_SEQ","LOGDATE_TZ"
   FROM "UNILAB".utgkrqhs;
--------------------------------------------------------
--  DDL for View UVGKRQHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVGKRQHSDETAILS" ("GK", "VERSION", "TR_SEQ", "EV_SEQ", "SEQ", "DETAILS") AS 
  SELECT "GK","VERSION","TR_SEQ","EV_SEQ","SEQ","DETAILS"
   FROM "UNILAB".utgkrqhsdetails;
--------------------------------------------------------
--  DDL for View UVGKRQLIST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVGKRQLIST" ("GK", "VERSION", "SEQ", "VALUE") AS 
  SELECT "GK","VERSION","SEQ","VALUE"
   FROM "UNILAB".utgkrqlist;
--------------------------------------------------------
--  DDL for View UVGKRQSQL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVGKRQSQL" ("GK", "VERSION", "SEQ", "SQLTEXT") AS 
  SELECT "GK","VERSION","SEQ","SQLTEXT"
   FROM "UNILAB".utgkrqsql;
--------------------------------------------------------
--  DDL for View UVGKRT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVGKRT" ("GK", "VERSION", "VERSION_IS_CURRENT", "EFFECTIVE_FROM", "EFFECTIVE_TILL", "DESCRIPTION", "IS_PROTECTED", "VALUE_UNIQUE", "SINGLE_VALUED", "NEW_VAL_ALLOWED", "MANDATORY", "STRUCT_CREATED", "INHERIT_GK", "VALUE_LIST_TP", "DEFAULT_VALUE", "DSP_ROWS", "VAL_LENGTH", "VAL_START", "ASSIGN_TP", "ASSIGN_ID", "Q_TP", "Q_ID", "Q_CHECK_AU", "Q_AU", "LAST_COMMENT", "GK_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "EFFECTIVE_FROM_TZ", "EFFECTIVE_TILL_TZ") AS 
  SELECT "GK","VERSION","VERSION_IS_CURRENT","EFFECTIVE_FROM","EFFECTIVE_TILL","DESCRIPTION","IS_PROTECTED","VALUE_UNIQUE","SINGLE_VALUED","NEW_VAL_ALLOWED","MANDATORY","STRUCT_CREATED","INHERIT_GK","VALUE_LIST_TP","DEFAULT_VALUE","DSP_ROWS","VAL_LENGTH","VAL_START","ASSIGN_TP","ASSIGN_ID","Q_TP","Q_ID","Q_CHECK_AU","Q_AU","LAST_COMMENT","GK_CLASS","LOG_HS","LOG_HS_DETAILS","ALLOW_MODIFY","ACTIVE","LC","LC_VERSION","SS","EFFECTIVE_FROM_TZ","EFFECTIVE_TILL_TZ"
   FROM "UNILAB".utgkrt;
--------------------------------------------------------
--  DDL for View UVGKRTHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVGKRTHS" ("GK", "VERSION", "WHO", "WHO_DESCRIPTION", "WHAT", "WHAT_DESCRIPTION", "LOGDATE", "WHY", "TR_SEQ", "EV_SEQ", "LOGDATE_TZ") AS 
  SELECT "GK","VERSION","WHO","WHO_DESCRIPTION","WHAT","WHAT_DESCRIPTION","LOGDATE","WHY","TR_SEQ","EV_SEQ","LOGDATE_TZ"
   FROM "UNILAB".utgkrths;
--------------------------------------------------------
--  DDL for View UVGKRTHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVGKRTHSDETAILS" ("GK", "VERSION", "TR_SEQ", "EV_SEQ", "SEQ", "DETAILS") AS 
  SELECT "GK","VERSION","TR_SEQ","EV_SEQ","SEQ","DETAILS"
   FROM "UNILAB".utgkrthsdetails;
--------------------------------------------------------
--  DDL for View UVGKRTLIST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVGKRTLIST" ("GK", "VERSION", "SEQ", "VALUE") AS 
  SELECT "GK","VERSION","SEQ","VALUE"
   FROM "UNILAB".utgkrtlist;
--------------------------------------------------------
--  DDL for View UVGKRTSQL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVGKRTSQL" ("GK", "VERSION", "SEQ", "SQLTEXT") AS 
  SELECT "GK","VERSION","SEQ","SQLTEXT"
   FROM "UNILAB".utgkrtsql;
--------------------------------------------------------
--  DDL for View UVGKSC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVGKSC" ("GK", "VERSION", "VERSION_IS_CURRENT", "EFFECTIVE_FROM", "EFFECTIVE_TILL", "DESCRIPTION", "IS_PROTECTED", "VALUE_UNIQUE", "SINGLE_VALUED", "NEW_VAL_ALLOWED", "MANDATORY", "STRUCT_CREATED", "INHERIT_GK", "VALUE_LIST_TP", "DEFAULT_VALUE", "DSP_ROWS", "VAL_LENGTH", "VAL_START", "ASSIGN_TP", "ASSIGN_ID", "Q_TP", "Q_ID", "Q_CHECK_AU", "Q_AU", "LAST_COMMENT", "GK_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "EFFECTIVE_FROM_TZ", "EFFECTIVE_TILL_TZ") AS 
  SELECT "GK","VERSION","VERSION_IS_CURRENT","EFFECTIVE_FROM","EFFECTIVE_TILL","DESCRIPTION","IS_PROTECTED","VALUE_UNIQUE","SINGLE_VALUED","NEW_VAL_ALLOWED","MANDATORY","STRUCT_CREATED","INHERIT_GK","VALUE_LIST_TP","DEFAULT_VALUE","DSP_ROWS","VAL_LENGTH","VAL_START","ASSIGN_TP","ASSIGN_ID","Q_TP","Q_ID","Q_CHECK_AU","Q_AU","LAST_COMMENT","GK_CLASS","LOG_HS","LOG_HS_DETAILS","ALLOW_MODIFY","ACTIVE","LC","LC_VERSION","SS","EFFECTIVE_FROM_TZ","EFFECTIVE_TILL_TZ"
   FROM "UNILAB".utgksc;
--------------------------------------------------------
--  DDL for View UVGKSCHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVGKSCHS" ("GK", "VERSION", "WHO", "WHO_DESCRIPTION", "WHAT", "WHAT_DESCRIPTION", "LOGDATE", "WHY", "TR_SEQ", "EV_SEQ", "LOGDATE_TZ") AS 
  SELECT "GK","VERSION","WHO","WHO_DESCRIPTION","WHAT","WHAT_DESCRIPTION","LOGDATE","WHY","TR_SEQ","EV_SEQ","LOGDATE_TZ"
   FROM "UNILAB".utgkschs;
--------------------------------------------------------
--  DDL for View UVGKSCHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVGKSCHSDETAILS" ("GK", "VERSION", "TR_SEQ", "EV_SEQ", "SEQ", "DETAILS") AS 
  SELECT "GK","VERSION","TR_SEQ","EV_SEQ","SEQ","DETAILS"
   FROM "UNILAB".utgkschsdetails;
--------------------------------------------------------
--  DDL for View UVGKSCLIST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVGKSCLIST" ("GK", "VERSION", "SEQ", "VALUE") AS 
  SELECT "GK","VERSION","SEQ","VALUE"
   FROM "UNILAB".utgksclist;
--------------------------------------------------------
--  DDL for View UVGKSCSQL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVGKSCSQL" ("GK", "VERSION", "SEQ", "SQLTEXT") AS 
  SELECT "GK","VERSION","SEQ","SQLTEXT"
   FROM "UNILAB".utgkscsql;
--------------------------------------------------------
--  DDL for View UVGKSD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVGKSD" ("GK", "VERSION", "VERSION_IS_CURRENT", "EFFECTIVE_FROM", "EFFECTIVE_TILL", "DESCRIPTION", "IS_PROTECTED", "VALUE_UNIQUE", "SINGLE_VALUED", "NEW_VAL_ALLOWED", "MANDATORY", "STRUCT_CREATED", "INHERIT_GK", "VALUE_LIST_TP", "DEFAULT_VALUE", "DSP_ROWS", "VAL_LENGTH", "VAL_START", "ASSIGN_TP", "ASSIGN_ID", "Q_TP", "Q_ID", "Q_CHECK_AU", "Q_AU", "LAST_COMMENT", "GK_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "EFFECTIVE_FROM_TZ", "EFFECTIVE_TILL_TZ") AS 
  SELECT "GK","VERSION","VERSION_IS_CURRENT","EFFECTIVE_FROM","EFFECTIVE_TILL","DESCRIPTION","IS_PROTECTED","VALUE_UNIQUE","SINGLE_VALUED","NEW_VAL_ALLOWED","MANDATORY","STRUCT_CREATED","INHERIT_GK","VALUE_LIST_TP","DEFAULT_VALUE","DSP_ROWS","VAL_LENGTH","VAL_START","ASSIGN_TP","ASSIGN_ID","Q_TP","Q_ID","Q_CHECK_AU","Q_AU","LAST_COMMENT","GK_CLASS","LOG_HS","LOG_HS_DETAILS","ALLOW_MODIFY","ACTIVE","LC","LC_VERSION","SS","EFFECTIVE_FROM_TZ","EFFECTIVE_TILL_TZ"
   FROM "UNILAB".utgksd;
--------------------------------------------------------
--  DDL for View UVGKSDHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVGKSDHS" ("GK", "VERSION", "WHO", "WHO_DESCRIPTION", "WHAT", "WHAT_DESCRIPTION", "LOGDATE", "WHY", "TR_SEQ", "EV_SEQ", "LOGDATE_TZ") AS 
  SELECT "GK","VERSION","WHO","WHO_DESCRIPTION","WHAT","WHAT_DESCRIPTION","LOGDATE","WHY","TR_SEQ","EV_SEQ","LOGDATE_TZ"
   FROM "UNILAB".utgksdhs;
--------------------------------------------------------
--  DDL for View UVGKSDHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVGKSDHSDETAILS" ("GK", "VERSION", "TR_SEQ", "EV_SEQ", "SEQ", "DETAILS") AS 
  SELECT "GK","VERSION","TR_SEQ","EV_SEQ","SEQ","DETAILS"
   FROM "UNILAB".utgksdhsdetails;
--------------------------------------------------------
--  DDL for View UVGKSDLIST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVGKSDLIST" ("GK", "VERSION", "SEQ", "VALUE") AS 
  SELECT "GK","VERSION","SEQ","VALUE"
   FROM "UNILAB".utgksdlist;
--------------------------------------------------------
--  DDL for View UVGKSDSQL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVGKSDSQL" ("GK", "VERSION", "SEQ", "SQLTEXT") AS 
  SELECT "GK","VERSION","SEQ","SQLTEXT"
   FROM "UNILAB".utgksdsql;
--------------------------------------------------------
--  DDL for View UVGKST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVGKST" ("GK", "VERSION", "VERSION_IS_CURRENT", "EFFECTIVE_FROM", "EFFECTIVE_TILL", "DESCRIPTION", "IS_PROTECTED", "VALUE_UNIQUE", "SINGLE_VALUED", "NEW_VAL_ALLOWED", "MANDATORY", "STRUCT_CREATED", "INHERIT_GK", "VALUE_LIST_TP", "DEFAULT_VALUE", "DSP_ROWS", "VAL_LENGTH", "VAL_START", "ASSIGN_TP", "ASSIGN_ID", "Q_TP", "Q_ID", "Q_CHECK_AU", "Q_AU", "LAST_COMMENT", "GK_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "EFFECTIVE_FROM_TZ", "EFFECTIVE_TILL_TZ") AS 
  SELECT "GK","VERSION","VERSION_IS_CURRENT","EFFECTIVE_FROM","EFFECTIVE_TILL","DESCRIPTION","IS_PROTECTED","VALUE_UNIQUE","SINGLE_VALUED","NEW_VAL_ALLOWED","MANDATORY","STRUCT_CREATED","INHERIT_GK","VALUE_LIST_TP","DEFAULT_VALUE","DSP_ROWS","VAL_LENGTH","VAL_START","ASSIGN_TP","ASSIGN_ID","Q_TP","Q_ID","Q_CHECK_AU","Q_AU","LAST_COMMENT","GK_CLASS","LOG_HS","LOG_HS_DETAILS","ALLOW_MODIFY","ACTIVE","LC","LC_VERSION","SS","EFFECTIVE_FROM_TZ","EFFECTIVE_TILL_TZ"
   FROM "UNILAB".utgkst;
--------------------------------------------------------
--  DDL for View UVGKSTHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVGKSTHS" ("GK", "VERSION", "WHO", "WHO_DESCRIPTION", "WHAT", "WHAT_DESCRIPTION", "LOGDATE", "WHY", "TR_SEQ", "EV_SEQ", "LOGDATE_TZ") AS 
  SELECT "GK","VERSION","WHO","WHO_DESCRIPTION","WHAT","WHAT_DESCRIPTION","LOGDATE","WHY","TR_SEQ","EV_SEQ","LOGDATE_TZ"
   FROM "UNILAB".utgksths;
--------------------------------------------------------
--  DDL for View UVGKSTHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVGKSTHSDETAILS" ("GK", "VERSION", "TR_SEQ", "EV_SEQ", "SEQ", "DETAILS") AS 
  SELECT "GK","VERSION","TR_SEQ","EV_SEQ","SEQ","DETAILS"
   FROM "UNILAB".utgksthsdetails;
--------------------------------------------------------
--  DDL for View UVGKSTLIST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVGKSTLIST" ("GK", "VERSION", "SEQ", "VALUE") AS 
  SELECT "GK","VERSION","SEQ","VALUE"
   FROM "UNILAB".utgkstlist;
--------------------------------------------------------
--  DDL for View UVGKSTSQL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVGKSTSQL" ("GK", "VERSION", "SEQ", "SQLTEXT") AS 
  SELECT "GK","VERSION","SEQ","SQLTEXT"
   FROM "UNILAB".utgkstsql;
--------------------------------------------------------
--  DDL for View UVGKSUPPORTEDEV
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVGKSUPPORTEDEV" ("EV_TP") AS 
  SELECT "EV_TP"
   FROM "UNILAB".utgksupportedev;
--------------------------------------------------------
--  DDL for View UVGKWS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVGKWS" ("GK", "VERSION", "VERSION_IS_CURRENT", "EFFECTIVE_FROM", "EFFECTIVE_TILL", "DESCRIPTION", "IS_PROTECTED", "VALUE_UNIQUE", "SINGLE_VALUED", "NEW_VAL_ALLOWED", "MANDATORY", "STRUCT_CREATED", "INHERIT_GK", "VALUE_LIST_TP", "DEFAULT_VALUE", "DSP_ROWS", "VAL_LENGTH", "VAL_START", "ASSIGN_TP", "ASSIGN_ID", "Q_TP", "Q_ID", "Q_CHECK_AU", "Q_AU", "LAST_COMMENT", "GK_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "EFFECTIVE_FROM_TZ", "EFFECTIVE_TILL_TZ") AS 
  SELECT "GK","VERSION","VERSION_IS_CURRENT","EFFECTIVE_FROM","EFFECTIVE_TILL","DESCRIPTION","IS_PROTECTED","VALUE_UNIQUE","SINGLE_VALUED","NEW_VAL_ALLOWED","MANDATORY","STRUCT_CREATED","INHERIT_GK","VALUE_LIST_TP","DEFAULT_VALUE","DSP_ROWS","VAL_LENGTH","VAL_START","ASSIGN_TP","ASSIGN_ID","Q_TP","Q_ID","Q_CHECK_AU","Q_AU","LAST_COMMENT","GK_CLASS","LOG_HS","LOG_HS_DETAILS","ALLOW_MODIFY","ACTIVE","LC","LC_VERSION","SS","EFFECTIVE_FROM_TZ","EFFECTIVE_TILL_TZ"
   FROM "UNILAB".utgkws;
--------------------------------------------------------
--  DDL for View UVGKWSHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVGKWSHS" ("GK", "VERSION", "WHO", "WHO_DESCRIPTION", "WHAT", "WHAT_DESCRIPTION", "LOGDATE", "WHY", "TR_SEQ", "EV_SEQ", "LOGDATE_TZ") AS 
  SELECT "GK","VERSION","WHO","WHO_DESCRIPTION","WHAT","WHAT_DESCRIPTION","LOGDATE","WHY","TR_SEQ","EV_SEQ","LOGDATE_TZ"
   FROM "UNILAB".utgkwshs;
--------------------------------------------------------
--  DDL for View UVGKWSHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVGKWSHSDETAILS" ("GK", "VERSION", "TR_SEQ", "EV_SEQ", "SEQ", "DETAILS") AS 
  SELECT "GK","VERSION","TR_SEQ","EV_SEQ","SEQ","DETAILS"
   FROM "UNILAB".utgkwshsdetails;
--------------------------------------------------------
--  DDL for View UVGKWSLIST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVGKWSLIST" ("GK", "VERSION", "SEQ", "VALUE") AS 
  SELECT "GK","VERSION","SEQ","VALUE"
   FROM "UNILAB".utgkwslist;
--------------------------------------------------------
--  DDL for View UVGKWSSQL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVGKWSSQL" ("GK", "VERSION", "SEQ", "SQLTEXT") AS 
  SELECT "GK","VERSION","SEQ","SQLTEXT"
   FROM "UNILAB".utgkwssql;
--------------------------------------------------------
--  DDL for View UVIE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVIE" ("IE", "VERSION", "VERSION_IS_CURRENT", "EFFECTIVE_FROM", "EFFECTIVE_FROM_TZ", "EFFECTIVE_TILL", "EFFECTIVE_TILL_TZ", "IS_PROTECTED", "MANDATORY", "HIDDEN", "DATA_TP", "FORMAT", "VALID_CF", "DEF_VAL_TP", "DEF_AU_LEVEL", "IEVALUE", "ALIGN", "DSP_TITLE", "DSP_TITLE2", "DSP_LEN", "DSP_TP", "DSP_ROWS", "LOOK_UP_PTR", "IS_TEMPLATE", "MULTI_SELECT", "SC_LC", "SC_LC_VERSION", "INHERIT_AU", "LAST_COMMENT", "IE_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR") AS 
  SELECT
   ie,
   version,
   version_is_current,
   effective_from,
   effective_from_tz,
   effective_till,
   effective_till_tz,
   is_protected,
   mandatory,
   hidden,
   data_tp,
   format,
   valid_cf,
   def_val_tp,
   def_au_level,
   ievalue,
   align,
   dsp_title,
   dsp_title2,
   dsp_len,
   dsp_tp,
   dsp_rows,
   look_up_ptr,
   is_template,
   multi_select,
   sc_lc,
   sc_lc_version,
   inherit_au,
   last_comment,
   ie_class,
   log_hs,
   log_hs_details,
   allow_modify,
   active,
   lc,
   lc_version,
   ss,
 'W' ar
FROM "UNILAB".utie;
--------------------------------------------------------
--  DDL for View UVIEAU
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVIEAU" ("IE", "VERSION", "AU", "AU_VERSION", "AUSEQ", "VALUE") AS 
  SELECT "IE","VERSION","AU","AU_VERSION","AUSEQ","VALUE"
FROM "UNILAB".utieau;
--------------------------------------------------------
--  DDL for View UVIEHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVIEHS" ("IE", "VERSION", "WHO", "WHO_DESCRIPTION", "WHAT", "WHAT_DESCRIPTION", "LOGDATE", "WHY", "TR_SEQ", "EV_SEQ", "LOGDATE_TZ") AS 
  SELECT "IE","VERSION","WHO","WHO_DESCRIPTION","WHAT","WHAT_DESCRIPTION","LOGDATE","WHY","TR_SEQ","EV_SEQ","LOGDATE_TZ"
FROM "UNILAB".utiehs;
--------------------------------------------------------
--  DDL for View UVIEHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVIEHSDETAILS" ("IE", "VERSION", "TR_SEQ", "EV_SEQ", "SEQ", "DETAILS") AS 
  SELECT "IE","VERSION","TR_SEQ","EV_SEQ","SEQ","DETAILS"
FROM "UNILAB".utiehsdetails;
--------------------------------------------------------
--  DDL for View UVIELIST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVIELIST" ("IE", "VERSION", "SEQ", "VALUE") AS 
  SELECT "IE","VERSION","SEQ","VALUE"
FROM "UNILAB".utielist;
--------------------------------------------------------
--  DDL for View UVIESPIN
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVIESPIN" ("IE", "VERSION", "CIRCULAR", "INCR", "LOW_VAL_TP", "LOW_AU_LEVEL", "LOW_VAL", "HIGH_VAL_TP", "HIGH_AU_LEVEL", "HIGH_VAL") AS 
  SELECT "IE","VERSION","CIRCULAR","INCR","LOW_VAL_TP","LOW_AU_LEVEL","LOW_VAL","HIGH_VAL_TP","HIGH_AU_LEVEL","HIGH_VAL"
FROM "UNILAB".utiespin;
--------------------------------------------------------
--  DDL for View UVIESQL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVIESQL" ("IE", "VERSION", "SEQ", "SQLTEXT") AS 
  SELECT "IE","VERSION","SEQ","SQLTEXT"
FROM "UNILAB".utiesql;
--------------------------------------------------------
--  DDL for View UVIP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVIP" ("IP", "VERSION", "VERSION_IS_CURRENT", "EFFECTIVE_FROM", "EFFECTIVE_FROM_TZ", "EFFECTIVE_TILL", "EFFECTIVE_TILL_TZ", "DESCRIPTION", "DESCRIPTION2", "WINSIZE_X", "WINSIZE_Y", "IS_PROTECTED", "HIDDEN", "IS_TEMPLATE", "SC_LC", "SC_LC_VERSION", "INHERIT_AU", "LAST_COMMENT", "IP_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR") AS 
  SELECT
   ip,
   version,
   version_is_current,
   effective_from,
   effective_from_tz,
   effective_till,
   effective_till_tz,
   description,
   description2,
   winsize_x,
   winsize_y,
   is_protected,
   hidden,
   is_template,
   sc_lc,
   sc_lc_version,
   inherit_au,
   last_comment,
   ip_class,
   log_hs,
   log_hs_details,
   allow_modify,
   active,
   lc,
   lc_version,
   ss,
 'W' ar
FROM "UNILAB".utip;
--------------------------------------------------------
--  DDL for View UVIPAU
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVIPAU" ("IP", "VERSION", "AU", "AU_VERSION", "AUSEQ", "VALUE") AS 
  SELECT "IP","VERSION","AU","AU_VERSION","AUSEQ","VALUE"
FROM "UNILAB".utipau;
--------------------------------------------------------
--  DDL for View UVIPHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVIPHS" ("IP", "VERSION", "WHO", "WHO_DESCRIPTION", "WHAT", "WHAT_DESCRIPTION", "LOGDATE", "WHY", "TR_SEQ", "EV_SEQ", "LOGDATE_TZ") AS 
  SELECT "IP","VERSION","WHO","WHO_DESCRIPTION","WHAT","WHAT_DESCRIPTION","LOGDATE","WHY","TR_SEQ","EV_SEQ","LOGDATE_TZ"
FROM "UNILAB".utiphs;
--------------------------------------------------------
--  DDL for View UVIPHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVIPHSDETAILS" ("IP", "VERSION", "TR_SEQ", "EV_SEQ", "SEQ", "DETAILS") AS 
  SELECT "IP","VERSION","TR_SEQ","EV_SEQ","SEQ","DETAILS"
FROM "UNILAB".utiphsdetails;
--------------------------------------------------------
--  DDL for View UVIPIE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVIPIE" ("IP", "VERSION", "IE", "IE_VERSION", "SEQ", "POS_X", "POS_Y", "IS_PROTECTED", "MANDATORY", "HIDDEN", "DEF_VAL_TP", "DEF_AU_LEVEL", "IEVALUE", "DSP_TITLE", "DSP_TITLE2", "DSP_LEN", "DSP_ROWS", "DSP_TP", "DSP_TITLE_USE_IE") AS 
  SELECT "IP","VERSION","IE","IE_VERSION","SEQ","POS_X","POS_Y","IS_PROTECTED","MANDATORY","HIDDEN","DEF_VAL_TP","DEF_AU_LEVEL","IEVALUE","DSP_TITLE","DSP_TITLE2","DSP_LEN","DSP_ROWS","DSP_TP","DSP_TITLE_USE_IE"
FROM "UNILAB".utipie;
--------------------------------------------------------
--  DDL for View UVIPIEAU
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVIPIEAU" ("IP", "VERSION", "IE", "IE_VERSION", "AU", "AU_VERSION", "AUSEQ", "VALUE") AS 
  SELECT "IP","VERSION","IE","IE_VERSION","AU","AU_VERSION","AUSEQ","VALUE"
FROM "UNILAB".utipieau;
--------------------------------------------------------
--  DDL for View UVJOURNAL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVJOURNAL" ("JOURNAL_NR", "DESCRIPTION", "CURRENCY", "CURRENCY2", "JOURNAL_TP", "JOURNAL_SS", "CALC_TP", "TOTAL1", "TOTAL2", "DISC_ABS1", "DISC_ABS2", "DISC_REL", "GRAND_TOTAL1", "GRAND_TOTAL2", "TAX1", "TAX2", "TAX_REL", "GRAND_TOTAL_AT1", "GRAND_TOTAL_AT2", "ACTIVE", "ALLOW_MODIFY", "INVOICED", "INVOICED_ON", "DATE1", "DATE2", "DATE3", "LAST_UPDATED", "WHO", "COMMENTS", "INCLUDE_REANAL", "INVOICED_ON_TZ", "DATE1_TZ", "DATE2_TZ", "DATE3_TZ", "LAST_UPDATED_TZ") AS 
  SELECT "JOURNAL_NR","DESCRIPTION","CURRENCY","CURRENCY2","JOURNAL_TP","JOURNAL_SS","CALC_TP","TOTAL1","TOTAL2","DISC_ABS1","DISC_ABS2","DISC_REL","GRAND_TOTAL1","GRAND_TOTAL2","TAX1","TAX2","TAX_REL","GRAND_TOTAL_AT1","GRAND_TOTAL_AT2","ACTIVE","ALLOW_MODIFY","INVOICED","INVOICED_ON","DATE1","DATE2","DATE3","LAST_UPDATED","WHO","COMMENTS","INCLUDE_REANAL","INVOICED_ON_TZ","DATE1_TZ","DATE2_TZ","DATE3_TZ","LAST_UPDATED_TZ"
   FROM "UNILAB".utjournal;
--------------------------------------------------------
--  DDL for View UVJOURNALDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVJOURNALDETAILS" ("JOURNAL_NR", "RQSEQ", "SEQ", "OBJECT_TP", "OBJECT_VERSION", "RQ", "SC", "PG", "PGNODE", "PP_KEY1", "PP_KEY2", "PP_KEY3", "PP_KEY4", "PP_KEY5", "PA", "PANODE", "ME", "MENODE", "REANALYSIS", "DESCRIPTION", "QTITY", "PRICE", "DISC_ABS", "DISC_REL", "NET_PRICE", "ACTIVE", "ALLOW_MODIFY", "LAST_UPDATED", "AC_CODE", "LAST_UPDATED_TZ") AS 
  SELECT "JOURNAL_NR","RQSEQ","SEQ","OBJECT_TP","OBJECT_VERSION","RQ","SC","PG","PGNODE","PP_KEY1","PP_KEY2","PP_KEY3","PP_KEY4","PP_KEY5","PA","PANODE","ME","MENODE","REANALYSIS","DESCRIPTION","QTITY","PRICE","DISC_ABS","DISC_REL","NET_PRICE","ACTIVE","ALLOW_MODIFY","LAST_UPDATED","AC_CODE","LAST_UPDATED_TZ"
   FROM "UNILAB".utjournaldetails;
--------------------------------------------------------
--  DDL for View UVJOURNALLOG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVJOURNALLOG" ("CLIENT_ID", "APPLIC", "WHO", "LOGDATE", "JOURNAL_NR", "ERROR_LEVEL", "ERROR_MSG", "LOGDATE_TZ") AS 
  SELECT "CLIENT_ID","APPLIC","WHO","LOGDATE","JOURNAL_NR","ERROR_LEVEL","ERROR_MSG","LOGDATE_TZ"
   FROM "UNILAB".utjournallog;
--------------------------------------------------------
--  DDL for View UVJOURNALRQ
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVJOURNALRQ" ("JOURNAL_NR", "RQ", "RQSEQ") AS 
  SELECT "JOURNAL_NR","RQ","RQSEQ"
   FROM "UNILAB".utjournalrq;
--------------------------------------------------------
--  DDL for View UVKEYPP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVKEYPP" ("SEQ", "KEY_TP", "KEY_NAME", "DESCRIPTION") AS 
  SELECT "SEQ","KEY_TP","KEY_NAME","DESCRIPTION"
   FROM "UNILAB".utkeypp;
--------------------------------------------------------
--  DDL for View UVLAB
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVLAB" ("LAB") AS 
  SELECT "LAB"
   FROM "UNILAB".utlab;
--------------------------------------------------------
--  DDL for View UVLABEL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVLABEL" ("LABEL_FORMAT", "SEQ", "VALUE") AS 
  SELECT "LABEL_FORMAT","SEQ","VALUE"
   FROM "UNILAB".utlabel;
--------------------------------------------------------
--  DDL for View UVLC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVLC" ("LC", "VERSION", "VERSION_IS_CURRENT", "EFFECTIVE_FROM", "EFFECTIVE_TILL", "NAME", "DESCRIPTION", "INTENDED_USE", "IS_TEMPLATE", "INHERIT_AU", "SS_AFTER_REANALYSIS", "LAST_COMMENT", "LC_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC_LC", "LC_LC_VERSION", "SS", "EFFECTIVE_FROM_TZ", "EFFECTIVE_TILL_TZ") AS 
  SELECT "LC","VERSION","VERSION_IS_CURRENT","EFFECTIVE_FROM","EFFECTIVE_TILL","NAME","DESCRIPTION","INTENDED_USE","IS_TEMPLATE","INHERIT_AU","SS_AFTER_REANALYSIS","LAST_COMMENT","LC_CLASS","LOG_HS","LOG_HS_DETAILS","ALLOW_MODIFY","ACTIVE","LC_LC","LC_LC_VERSION","SS","EFFECTIVE_FROM_TZ","EFFECTIVE_TILL_TZ"
   FROM "UNILAB".utlc;
--------------------------------------------------------
--  DDL for View UVLCAF
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVLCAF" ("LC", "VERSION", "SS_FROM", "SS_TO", "TR_NO", "SEQ", "AF") AS 
  SELECT "LC","VERSION","SS_FROM","SS_TO","TR_NO","SEQ","AF"
   FROM "UNILAB".utlcaf;
--------------------------------------------------------
--  DDL for View UVLCAU
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVLCAU" ("LC", "VERSION", "AU", "AU_VERSION", "AUSEQ", "VALUE") AS 
  SELECT "LC","VERSION","AU","AU_VERSION","AUSEQ","VALUE"
   FROM "UNILAB".utlcau;
--------------------------------------------------------
--  DDL for View UVLCHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVLCHS" ("LC", "VERSION", "WHO", "WHO_DESCRIPTION", "WHAT", "WHAT_DESCRIPTION", "LOGDATE", "WHY", "TR_SEQ", "EV_SEQ", "LOGDATE_TZ") AS 
  SELECT "LC","VERSION","WHO","WHO_DESCRIPTION","WHAT","WHAT_DESCRIPTION","LOGDATE","WHY","TR_SEQ","EV_SEQ","LOGDATE_TZ"
   FROM "UNILAB".utlchs;
--------------------------------------------------------
--  DDL for View UVLCHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVLCHSDETAILS" ("LC", "VERSION", "TR_SEQ", "EV_SEQ", "SEQ", "DETAILS") AS 
  SELECT "LC","VERSION","TR_SEQ","EV_SEQ","SEQ","DETAILS"
   FROM "UNILAB".utlchsdetails;
--------------------------------------------------------
--  DDL for View UVLCTR
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVLCTR" ("LC", "VERSION", "SS_FROM", "SS_TO", "TR_NO", "CONDITION") AS 
  SELECT "LC","VERSION","SS_FROM","SS_TO","TR_NO","CONDITION"
   FROM "UNILAB".utlctr;
--------------------------------------------------------
--  DDL for View UVLCUS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVLCUS" ("LC", "VERSION", "SS_FROM", "SS_TO", "TR_NO", "US") AS 
  SELECT "LC","VERSION","SS_FROM","SS_TO","TR_NO","US"
   FROM "UNILAB".utlcus;
--------------------------------------------------------
--  DDL for View UVLICSECID
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVLICSECID" ("SERIAL_ID", "SHORTNAME", "SETTING_SEQ", "SETTING_NAME", "SETTING_VALUE") AS 
  SELECT "SERIAL_ID","SHORTNAME","SETTING_SEQ","SETTING_NAME","SETTING_VALUE"
   FROM "UNILAB".ctlicsecid;
--------------------------------------------------------
--  DDL for View UVLICSECIDAUXILIARY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVLICSECIDAUXILIARY" ("SERIAL_ID", "SHORTNAME", "HASH_CODE_CLIENT", "HASH_CODE_SERVER", "TEMPLATE", "REF_DATE", "EXPIRATION_DATE") AS 
  SELECT "SERIAL_ID","SHORTNAME","HASH_CODE_CLIENT","HASH_CODE_SERVER","TEMPLATE","REF_DATE","EXPIRATION_DATE"
   FROM "UNILAB".ctlicsecidauxiliary;
--------------------------------------------------------
--  DDL for View UVLICSECIDAUXILIARYOLD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVLICSECIDAUXILIARYOLD" ("LOCAL_TRAN_ID", "LOGDATE", "SERIAL_ID", "SHORTNAME", "HASH_CODE_CLIENT", "HASH_CODE_SERVER", "TEMPLATE", "REF_DATE", "EXPIRATION_DATE", "LOGDATE_TZ") AS 
  SELECT "LOCAL_TRAN_ID","LOGDATE","SERIAL_ID","SHORTNAME","HASH_CODE_CLIENT","HASH_CODE_SERVER","TEMPLATE","REF_DATE","EXPIRATION_DATE","LOGDATE_TZ"
   FROM "UNILAB".ctlicsecidauxiliaryold;
--------------------------------------------------------
--  DDL for View UVLICSECIDOLD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVLICSECIDOLD" ("LOCAL_TRAN_ID", "LOGDATE", "SERIAL_ID", "SHORTNAME", "SETTING_SEQ", "SETTING_NAME", "SETTING_VALUE", "LOGDATE_TZ") AS 
  SELECT "LOCAL_TRAN_ID","LOGDATE","SERIAL_ID","SHORTNAME","SETTING_SEQ","SETTING_NAME","SETTING_VALUE","LOGDATE_TZ"
   FROM "UNILAB".ctlicsecidold;
--------------------------------------------------------
--  DDL for View UVLICUSERCNT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVLICUSERCNT" ("USER_SID", "USER_NAME", "APP_ID", "APP_VERSION", "LIC_CHECK_APPLIES", "LOGON_DATE", "LAST_HEARTBEAT", "LOGOFF_DATE", "LOGON_STATION", "AUDSID", "APP_CUSTOM_PARAM", "INST_ID") AS 
  SELECT "USER_SID","USER_NAME","APP_ID","APP_VERSION","LIC_CHECK_APPLIES","LOGON_DATE","LAST_HEARTBEAT","LOGOFF_DATE","LOGON_STATION","AUDSID","APP_CUSTOM_PARAM","INST_ID"
   FROM "UNILAB".ctlicusercnt;
--------------------------------------------------------
--  DDL for View UVLKIN
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVLKIN" ("SEQ", "API_NAME", "CREATED_ON", "ARG1", "ARG2", "ARG3", "ARG4", "ARG5", "ARG6", "ARG7", "ARG8", "ARG9", "ARG10", "ARG11", "ARG12", "ARG13", "ARG14", "ARG15", "ARG16", "ARG17", "ARG18", "ARG19", "ARG20", "ARG21", "ARG22", "ARG23", "ARG24", "ARG25", "ARG26", "ARG27", "ARG28", "ARG29", "ARG30", "ARG31", "ARG32", "ARG33", "ARG34", "ARG35", "ARG36", "ARG37", "ARG38", "ARG39", "ARG40", "ARG41", "ARG42", "ARG43", "ARG44", "ARG45", "ARG46", "ARG47", "ARG48", "ARG49", "ARG50", "ARG51", "ARG52", "ARG53", "ARG54", "ARG55", "ARG56", "ARG57", "ARG58", "ARG59", "CREATED_ON_TZ") AS 
  SELECT "SEQ","API_NAME","CREATED_ON","ARG1","ARG2","ARG3","ARG4","ARG5","ARG6","ARG7","ARG8","ARG9","ARG10","ARG11","ARG12","ARG13","ARG14","ARG15","ARG16","ARG17","ARG18","ARG19","ARG20","ARG21","ARG22","ARG23","ARG24","ARG25","ARG26","ARG27","ARG28","ARG29","ARG30","ARG31","ARG32","ARG33","ARG34","ARG35","ARG36","ARG37","ARG38","ARG39","ARG40","ARG41","ARG42","ARG43","ARG44","ARG45","ARG46","ARG47","ARG48","ARG49","ARG50","ARG51","ARG52","ARG53","ARG54","ARG55","ARG56","ARG57","ARG58","ARG59","CREATED_ON_TZ"
   FROM "UNILAB".utlkin;
--------------------------------------------------------
--  DDL for View UVLO
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVLO" ("LO", "DESCRIPTION", "DESCRIPTION2", "NR_SC_MAX", "CURR_NR_SC", "IS_TEMPLATE") AS 
  SELECT "LO","DESCRIPTION","DESCRIPTION2","NR_SC_MAX","CURR_NR_SC","IS_TEMPLATE"
   FROM "UNILAB".utlo;
--------------------------------------------------------
--  DDL for View UVLOAU
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVLOAU" ("LO", "AU", "AU_VERSION", "AUSEQ", "VALUE") AS 
  SELECT "LO","AU","AU_VERSION","AUSEQ","VALUE"
   FROM "UNILAB".utloau;
--------------------------------------------------------
--  DDL for View UVLOCS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVLOCS" ("LO", "CS", "SEQ") AS 
  SELECT "LO","CS","SEQ"
   FROM "UNILAB".utlocs;
--------------------------------------------------------
--  DDL for View UVLONGTEXT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVLONGTEXT" ("OBJ_ID", "OBJ_TP", "OBJ_VERSION", "DOC_ID", "DOC_TP", "DOC_NAME", "LINE_NBR", "TEXT_LINE") AS 
  SELECT "OBJ_ID","OBJ_TP","OBJ_VERSION","DOC_ID","DOC_TP","DOC_NAME","LINE_NBR","TEXT_LINE"
   FROM "UNILAB".utlongtext;
--------------------------------------------------------
--  DDL for View UVLU
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVLU" ("LU", "SEQ", "STRING_VAL", "NUM_VAL", "SHORTCUT") AS 
  SELECT "LU","SEQ","STRING_VAL","NUM_VAL","SHORTCUT"
   FROM "UNILAB".utlu;
--------------------------------------------------------
--  DDL for View UVLY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVLY" ("LY_TP", "LY", "SEQ", "COL_ID", "COL_TP", "COL_LEN", "DISP_TITLE", "DISP_STYLE", "DISP_TP", "DISP_WIDTH", "DISP_FORMAT", "COL_ORDER", "COL_ASC") AS 
  SELECT "LY_TP","LY","SEQ","COL_ID","COL_TP","COL_LEN","DISP_TITLE","DISP_STYLE","DISP_TP","DISP_WIDTH","DISP_FORMAT","COL_ORDER","COL_ASC"
   FROM "UNILAB".utly;
--------------------------------------------------------
--  DDL for View UVMELSSAVESAMPLE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVMELSSAVESAMPLE" ("SC", "ST", "ST_VERSION", "DESCRIPTION", "SHELF_LIFE_VAL", "SHELF_LIFE_UNIT", "SAMPLING_DATE", "CREATION_DATE", "CREATED_BY", "EXEC_START_DATE", "EXEC_END_DATE", "PRIORITY", "LABEL_FORMAT", "DESCR_DOC", "DESCR_DOC_VERSION", "RQ", "SD", "DATE1", "DATE2", "DATE3", "DATE4", "DATE5", "ALLOW_ANY_PP", "SC_CLASS", "LOG_HS", "LOG_HS_DETAILS", "LC", "LC_VERSION", "SAMPLING_DATE_TZ", "CREATION_DATE_TZ", "EXEC_START_DATE_TZ", "EXEC_END_DATE_TZ", "DATE1_TZ", "DATE2_TZ", "DATE3_TZ", "DATE4_TZ", "DATE5_TZ") AS 
  SELECT "SC","ST","ST_VERSION","DESCRIPTION","SHELF_LIFE_VAL","SHELF_LIFE_UNIT","SAMPLING_DATE","CREATION_DATE","CREATED_BY","EXEC_START_DATE","EXEC_END_DATE","PRIORITY","LABEL_FORMAT","DESCR_DOC","DESCR_DOC_VERSION","RQ","SD","DATE1","DATE2","DATE3","DATE4","DATE5","ALLOW_ANY_PP","SC_CLASS","LOG_HS","LOG_HS_DETAILS","LC","LC_VERSION","SAMPLING_DATE_TZ","CREATION_DATE_TZ","EXEC_START_DATE_TZ","EXEC_END_DATE_TZ","DATE1_TZ","DATE2_TZ","DATE3_TZ","DATE4_TZ","DATE5_TZ"
   FROM "UNILAB".utmelssavesample;
--------------------------------------------------------
--  DDL for View UVMELSSAVESCATTRIBUTE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVMELSSAVESCATTRIBUTE" ("SC", "AU", "AU_VERSION", "VALUE", "ROW_NUMBER") AS 
  SELECT "SC","AU","AU_VERSION","VALUE","ROW_NUMBER"
   FROM "UNILAB".utmelssavescattribute;
--------------------------------------------------------
--  DDL for View UVMELSSAVESCGROUPKEY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVMELSSAVESCGROUPKEY" ("SC", "GK", "GK_VERSION", "VALUE", "ROW_NUMBER") AS 
  SELECT "SC","GK","GK_VERSION","VALUE","ROW_NUMBER"
   FROM "UNILAB".utmelssavescgroupkey;
--------------------------------------------------------
--  DDL for View UVMELSSAVESCMEATTRIBUTE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVMELSSAVESCMEATTRIBUTE" ("SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE", "AU", "AU_VERSION", "VALUE", "ROW_NUMBER") AS 
  SELECT "SC","PG","PGNODE","PA","PANODE","ME","MENODE","AU","AU_VERSION","VALUE","ROW_NUMBER"
   FROM "UNILAB".utmelssavescmeattribute;
--------------------------------------------------------
--  DDL for View UVMELSSAVESCMECELL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVMELSSAVESCMECELL" ("COMPLETED", "SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE", "REANALYSIS", "CELL", "CELLNODE", "DSP_TITLE", "VALUE_F", "VALUE_S", "CELL_TP", "POS_X", "POS_Y", "ALIGN", "WINSIZE_X", "WINSIZE_Y", "IS_PROTECTED", "MANDATORY", "HIDDEN", "UNIT", "FORMAT", "EQ", "EQ_VERSION", "COMPONENT", "CALC_TP", "CALC_FORMULA", "VALID_CF", "MAX_X", "MAX_Y", "MULTI_SELECT", "MODIFY_FLAG") AS 
  SELECT "COMPLETED","SC","PG","PGNODE","PA","PANODE","ME","MENODE","REANALYSIS","CELL","CELLNODE","DSP_TITLE","VALUE_F","VALUE_S","CELL_TP","POS_X","POS_Y","ALIGN","WINSIZE_X","WINSIZE_Y","IS_PROTECTED","MANDATORY","HIDDEN","UNIT","FORMAT","EQ","EQ_VERSION","COMPONENT","CALC_TP","CALC_FORMULA","VALID_CF","MAX_X","MAX_Y","MULTI_SELECT","MODIFY_FLAG"
   FROM "UNILAB".utmelssavescmecell;
--------------------------------------------------------
--  DDL for View UVMELSSAVESCMECELLVALUES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVMELSSAVESCMECELLVALUES" ("SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE", "REANALYSIS", "CELL", "INDEX_X", "INDEX_Y", "VALUE_F", "VALUE_S", "SELECTED") AS 
  SELECT "SC","PG","PGNODE","PA","PANODE","ME","MENODE","REANALYSIS","CELL","INDEX_X","INDEX_Y","VALUE_F","VALUE_S","SELECTED"
   FROM "UNILAB".utmelssavescmecellvalues;
--------------------------------------------------------
--  DDL for View UVMELSSAVESCMEGROUPKEY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVMELSSAVESCMEGROUPKEY" ("SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE", "GK", "GK_VERSION", "VALUE", "ROW_NUMBER") AS 
  SELECT "SC","PG","PGNODE","PA","PANODE","ME","MENODE","GK","GK_VERSION","VALUE","ROW_NUMBER"
   FROM "UNILAB".utmelssavescmegroupkey;
--------------------------------------------------------
--  DDL for View UVMELSSAVESCMERESULT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVMELSSAVESCMERESULT" ("ALARMS_HANDLED", "SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE", "REANALYSIS", "VALUE_F", "VALUE_S", "UNIT", "FORMAT", "EXEC_END_DATE", "EXECUTOR", "LAB", "EQ", "EQ_VERSION", "MANUALLY_ENTERED", "REAL_COST", "REAL_TIME", "MODIFY_FLAG", "EXEC_END_DATE_TZ") AS 
  SELECT "ALARMS_HANDLED","SC","PG","PGNODE","PA","PANODE","ME","MENODE","REANALYSIS","VALUE_F","VALUE_S","UNIT","FORMAT","EXEC_END_DATE","EXECUTOR","LAB","EQ","EQ_VERSION","MANUALLY_ENTERED","REAL_COST","REAL_TIME","MODIFY_FLAG","EXEC_END_DATE_TZ"
   FROM "UNILAB".utmelssavescmeresult;
--------------------------------------------------------
--  DDL for View UVMELSSAVESCMETHOD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVMELSSAVESCMETHOD" ("ALARMS_HANDLED", "SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE", "REANALYSIS", "MT_VERSION", "DESCRIPTION", "VALUE_F", "VALUE_S", "UNIT", "EXEC_START_DATE", "EXEC_END_DATE", "EXECUTOR", "LAB", "EQ", "EQ_VERSION", "PLANNED_EXECUTOR", "PLANNED_EQ", "PLANNED_EQ_VERSION", "MANUALLY_ENTERED", "ALLOW_ADD", "ASSIGN_DATE", "ASSIGNED_BY", "MANUALLY_ADDED", "DELAY", "DELAY_UNIT", "FORMAT", "ACCURACY", "REAL_COST", "REAL_TIME", "CALIBRATION", "CONFIRM_COMPLETE", "AUTORECALC", "ME_RESULT_EDITABLE", "NEXT_CELL", "SOP", "SOP_VERSION", "PLAUS_LOW", "PLAUS_HIGH", "WINSIZE_X", "WINSIZE_Y", "ME_CLASS", "LOG_HS", "LOG_HS_DETAILS", "LC", "LC_VERSION", "MODIFY_FLAG", "EXEC_START_DATE_TZ", "EXEC_END_DATE_TZ", "ASSIGN_DATE_TZ") AS 
  SELECT "ALARMS_HANDLED","SC","PG","PGNODE","PA","PANODE","ME","MENODE","REANALYSIS","MT_VERSION","DESCRIPTION","VALUE_F","VALUE_S","UNIT","EXEC_START_DATE","EXEC_END_DATE","EXECUTOR","LAB","EQ","EQ_VERSION","PLANNED_EXECUTOR","PLANNED_EQ","PLANNED_EQ_VERSION","MANUALLY_ENTERED","ALLOW_ADD","ASSIGN_DATE","ASSIGNED_BY","MANUALLY_ADDED","DELAY","DELAY_UNIT","FORMAT","ACCURACY","REAL_COST","REAL_TIME","CALIBRATION","CONFIRM_COMPLETE","AUTORECALC","ME_RESULT_EDITABLE","NEXT_CELL","SOP","SOP_VERSION","PLAUS_LOW","PLAUS_HIGH","WINSIZE_X","WINSIZE_Y","ME_CLASS","LOG_HS","LOG_HS_DETAILS","LC","LC_VERSION","MODIFY_FLAG","EXEC_START_DATE_TZ","EXEC_END_DATE_TZ","ASSIGN_DATE_TZ"
   FROM "UNILAB".utmelssavescmethod;
--------------------------------------------------------
--  DDL for View UVMT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVMT" ("MT", "VERSION", "VERSION_IS_CURRENT", "EFFECTIVE_FROM", "EFFECTIVE_FROM_TZ", "EFFECTIVE_TILL", "EFFECTIVE_TILL_TZ", "DESCRIPTION", "DESCRIPTION2", "UNIT", "EST_COST", "EST_TIME", "ACCURACY", "IS_TEMPLATE", "CALIBRATION", "AUTORECALC", "CONFIRM_COMPLETE", "AUTO_CREATE_CELLS", "ME_RESULT_EDITABLE", "EXECUTOR", "EQ_TP", "SOP", "SOP_VERSION", "PLAUS_LOW", "PLAUS_HIGH", "WINSIZE_X", "WINSIZE_Y", "SC_LC", "SC_LC_VERSION", "DEF_VAL_TP", "DEF_AU_LEVEL", "DEF_VAL", "FORMAT", "INHERIT_AU", "LAST_COMMENT", "MT_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR") AS 
  SELECT
   mt,
   version,
   version_is_current,
   effective_from,
   effective_from_tz,
   effective_till,
   effective_till_tz,
   description,
   description2,
   unit,
   est_cost,
   est_time,
   accuracy,
   is_template,
   calibration,
   autorecalc,
   confirm_complete,
   auto_create_cells,
   me_result_editable,
   executor,
   eq_tp,
   sop,
   sop_version,
   plaus_low,
   plaus_high,
   winsize_x,
   winsize_y,
   sc_lc,
   sc_lc_version,
   def_val_tp,
   def_au_level,
   def_val,
   format,
   inherit_au,
   last_comment,
   mt_class,
   log_hs,
   log_hs_details,
   allow_modify,
   active,
   lc,
   lc_version,
   ss,
 'W' ar
FROM "UNILAB".utmt;
--------------------------------------------------------
--  DDL for View UVMTAU
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVMTAU" ("MT", "VERSION", "AU", "AU_VERSION", "AUSEQ", "VALUE") AS 
  SELECT "MT","VERSION","AU","AU_VERSION","AUSEQ","VALUE"
FROM "UNILAB".utmtau;
--------------------------------------------------------
--  DDL for View UVMTCELL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVMTCELL" ("MT", "VERSION", "CELL", "SEQ", "DSP_TITLE", "DSP_TITLE2", "VALUE_F", "VALUE_S", "POS_X", "POS_Y", "ALIGN", "CELL_TP", "WINSIZE_X", "WINSIZE_Y", "IS_PROTECTED", "MANDATORY", "HIDDEN", "INPUT_TP", "INPUT_SOURCE", "INPUT_SOURCE_VERSION", "INPUT_PP", "INPUT_PP_VERSION", "INPUT_PR", "INPUT_PR_VERSION", "INPUT_MT", "INPUT_MT_VERSION", "DEF_VAL_TP", "DEF_AU_LEVEL", "SAVE_TP", "SAVE_PP", "SAVE_PP_VERSION", "SAVE_PR", "SAVE_PR_VERSION", "SAVE_MT", "SAVE_MT_VERSION", "SAVE_EQ_TP", "SAVE_ID", "SAVE_ID_VERSION", "COMPONENT", "UNIT", "FORMAT", "CALC_TP", "CALC_FORMULA", "VALID_CF", "MAX_X", "MAX_Y", "MULTI_SELECT", "CREATE_NEW") AS 
  SELECT "MT","VERSION","CELL","SEQ","DSP_TITLE","DSP_TITLE2","VALUE_F","VALUE_S","POS_X","POS_Y","ALIGN","CELL_TP","WINSIZE_X","WINSIZE_Y","IS_PROTECTED","MANDATORY","HIDDEN","INPUT_TP","INPUT_SOURCE","INPUT_SOURCE_VERSION","INPUT_PP","INPUT_PP_VERSION","INPUT_PR","INPUT_PR_VERSION","INPUT_MT","INPUT_MT_VERSION","DEF_VAL_TP","DEF_AU_LEVEL","SAVE_TP","SAVE_PP","SAVE_PP_VERSION","SAVE_PR","SAVE_PR_VERSION","SAVE_MT","SAVE_MT_VERSION","SAVE_EQ_TP","SAVE_ID","SAVE_ID_VERSION","COMPONENT","UNIT","FORMAT","CALC_TP","CALC_FORMULA","VALID_CF","MAX_X","MAX_Y","MULTI_SELECT","CREATE_NEW"
FROM "UNILAB".utmtcell;
--------------------------------------------------------
--  DDL for View UVMTCELLEQTYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVMTCELLEQTYPE" ("MT", "VERSION", "CELL", "SEQ", "EQ_TP") AS 
  SELECT "MT","VERSION","CELL","SEQ","EQ_TP"
FROM "UNILAB".utmtcelleqtype;
--------------------------------------------------------
--  DDL for View UVMTCELLLIST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVMTCELLLIST" ("MT", "VERSION", "CELL", "INDEX_X", "INDEX_Y", "VALUE_F", "VALUE_S", "SELECTED") AS 
  SELECT "MT","VERSION","CELL","INDEX_X","INDEX_Y","VALUE_F","VALUE_S","SELECTED"
FROM "UNILAB".utmtcelllist;
--------------------------------------------------------
--  DDL for View UVMTCELLSPIN
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVMTCELLSPIN" ("MT", "VERSION", "CELL", "CIRCULAR", "INCR", "LOW_VAL_TP", "LOW_AU_LEVEL", "LOW_VAL", "HIGH_VAL_TP", "HIGH_AU_LEVEL", "HIGH_VAL") AS 
  SELECT "MT","VERSION","CELL","CIRCULAR","INCR","LOW_VAL_TP","LOW_AU_LEVEL","LOW_VAL","HIGH_VAL_TP","HIGH_AU_LEVEL","HIGH_VAL"
FROM "UNILAB".utmtcellspin;
--------------------------------------------------------
--  DDL for View UVMTEL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVMTEL" ("MT", "VERSION", "EL", "SEQ") AS 
  SELECT "MT","VERSION","EL","SEQ"
FROM "UNILAB".utmtel;
--------------------------------------------------------
--  DDL for View UVMTHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVMTHS" ("MT", "VERSION", "WHO", "WHO_DESCRIPTION", "WHAT", "WHAT_DESCRIPTION", "LOGDATE", "WHY", "TR_SEQ", "EV_SEQ", "LOGDATE_TZ") AS 
  SELECT "MT","VERSION","WHO","WHO_DESCRIPTION","WHAT","WHAT_DESCRIPTION","LOGDATE","WHY","TR_SEQ","EV_SEQ","LOGDATE_TZ"
FROM "UNILAB".utmths;
--------------------------------------------------------
--  DDL for View UVMTHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVMTHSDETAILS" ("MT", "VERSION", "TR_SEQ", "EV_SEQ", "SEQ", "DETAILS") AS 
  SELECT "MT","VERSION","TR_SEQ","EV_SEQ","SEQ","DETAILS"
FROM "UNILAB".utmthsdetails;
--------------------------------------------------------
--  DDL for View UVMTMR
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVMTMR" ("MT", "VERSION", "SEQ", "COMPONENT", "L_DETECTION_LIMIT", "L_DETERM_LIMIT", "H_DETERM_LIMIT", "H_DETECTION_LIMIT", "UNIT") AS 
  SELECT "MT","VERSION","SEQ","COMPONENT","L_DETECTION_LIMIT","L_DETERM_LIMIT","H_DETERM_LIMIT","H_DETECTION_LIMIT","UNIT"
FROM "UNILAB".utmtmr;
--------------------------------------------------------
--  DDL for View UVOBJECTS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVOBJECTS" ("OBJECT", "DESCRIPTION", "DEF_LC", "LOG_HS", "LOG_HS_DETAILS", "AR") AS 
  SELECT "OBJECT","DESCRIPTION","DEF_LC","LOG_HS","LOG_HS_DETAILS","AR"
   FROM "UNILAB".utobjects;
--------------------------------------------------------
--  DDL for View UVOBJECTSLY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVOBJECTSLY" ("OBJ_TP", "OBJ_ID", "LY") AS 
  SELECT "OBJ_TP","OBJ_ID","LY"
   FROM "UNILAB".utobjectsly;
--------------------------------------------------------
--  DDL for View UVOTDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVOTDETAILS" ("COL_TP", "SEQ", "COL_ID", "COL_LEN", "DISP_TP", "DISP_TITLE", "DISP_STYLE", "DISP_WIDTH", "DISP_FORMAT") AS 
  SELECT "COL_TP","SEQ","COL_ID","COL_LEN","DISP_TP","DISP_TITLE","DISP_STYLE","DISP_WIDTH","DISP_FORMAT"
   FROM "UNILAB".utotdetails;
--------------------------------------------------------
--  DDL for View UVPP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVPP" ("PP", "VERSION", "PP_KEY1", "PP_KEY2", "PP_KEY3", "PP_KEY4", "PP_KEY5", "VERSION_IS_CURRENT", "EFFECTIVE_FROM", "EFFECTIVE_FROM_TZ", "EFFECTIVE_TILL", "EFFECTIVE_TILL_TZ", "DESCRIPTION", "DESCRIPTION2", "UNIT", "FORMAT", "CONFIRM_ASSIGN", "ALLOW_ANY_PR", "NEVER_CREATE_METHODS", "DELAY", "DELAY_UNIT", "IS_TEMPLATE", "SC_LC", "SC_LC_VERSION", "INHERIT_AU", "LAST_COMMENT", "PP_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR") AS 
  SELECT
   pp,
   version,
   pp_key1,
   pp_key2,
   pp_key3,
   pp_key4,
   pp_key5,
   version_is_current,
   effective_from,
   effective_from_tz,
   effective_till,
   effective_till_tz,
   description,
   description2,
   unit,
   format,
   confirm_assign,
   allow_any_pr,
   never_create_methods,
   delay,
   delay_unit,
   is_template,
   sc_lc,
   sc_lc_version,
   inherit_au,
   last_comment,
   pp_class,
   log_hs,
   log_hs_details,
   allow_modify,
   active,
   lc,
   lc_version,
   ss,
 'W' ar
FROM "UNILAB".utpp;
--------------------------------------------------------
--  DDL for View UVPPAU
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVPPAU" ("PP", "VERSION", "PP_KEY1", "PP_KEY2", "PP_KEY3", "PP_KEY4", "PP_KEY5", "AU", "AU_VERSION", "AUSEQ", "VALUE") AS 
  SELECT "PP","VERSION","PP_KEY1","PP_KEY2","PP_KEY3","PP_KEY4","PP_KEY5","AU","AU_VERSION","AUSEQ","VALUE"
FROM "UNILAB".utppau;
--------------------------------------------------------
--  DDL for View UVPPHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVPPHS" ("PP", "VERSION", "PP_KEY1", "PP_KEY2", "PP_KEY3", "PP_KEY4", "PP_KEY5", "WHO", "WHO_DESCRIPTION", "WHAT", "WHAT_DESCRIPTION", "LOGDATE", "WHY", "TR_SEQ", "EV_SEQ", "LOGDATE_TZ") AS 
  SELECT "PP","VERSION","PP_KEY1","PP_KEY2","PP_KEY3","PP_KEY4","PP_KEY5","WHO","WHO_DESCRIPTION","WHAT","WHAT_DESCRIPTION","LOGDATE","WHY","TR_SEQ","EV_SEQ","LOGDATE_TZ"
FROM "UNILAB".utpphs;
--------------------------------------------------------
--  DDL for View UVPPHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVPPHSDETAILS" ("PP", "VERSION", "PP_KEY1", "PP_KEY2", "PP_KEY3", "PP_KEY4", "PP_KEY5", "TR_SEQ", "EV_SEQ", "SEQ", "DETAILS") AS 
  SELECT "PP","VERSION","PP_KEY1","PP_KEY2","PP_KEY3","PP_KEY4","PP_KEY5","TR_SEQ","EV_SEQ","SEQ","DETAILS"
FROM "UNILAB".utpphsdetails;
--------------------------------------------------------
--  DDL for View UVPPPR
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVPPPR" ("PP", "VERSION", "PP_KEY1", "PP_KEY2", "PP_KEY3", "PP_KEY4", "PP_KEY5", "PR", "PR_VERSION", "SEQ", "NR_MEASUR", "UNIT", "FORMAT", "DELAY", "DELAY_UNIT", "ALLOW_ADD", "IS_PP", "FREQ_TP", "FREQ_VAL", "FREQ_UNIT", "INVERT_FREQ", "ST_BASED_FREQ", "LAST_SCHED", "LAST_CNT", "LAST_VAL", "INHERIT_AU", "MT", "MT_VERSION", "MT_NR_MEASUR", "LAST_SCHED_TZ") AS 
  SELECT "PP","VERSION","PP_KEY1","PP_KEY2","PP_KEY3","PP_KEY4","PP_KEY5","PR","PR_VERSION","SEQ","NR_MEASUR","UNIT","FORMAT","DELAY","DELAY_UNIT","ALLOW_ADD","IS_PP","FREQ_TP","FREQ_VAL","FREQ_UNIT","INVERT_FREQ","ST_BASED_FREQ","LAST_SCHED","LAST_CNT","LAST_VAL","INHERIT_AU","MT","MT_VERSION","MT_NR_MEASUR","LAST_SCHED_TZ"
FROM "UNILAB".utpppr;
--------------------------------------------------------
--  DDL for View UVPPPR_PR_SPECX
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVPPPR_PR_SPECX" ("PP", "VERSION", "PP_KEY1", "PP_KEY2", "PP_KEY3", "PP_KEY4", "PP_KEY5", "PR", "PR_VERSION", "SEQ", "NR_MEASUR", "DELAY", "DELAY_UNIT", "ALLOW_ADD", "IS_PP", "FREQ_TP", "FREQ_VAL", "FREQ_UNIT", "INVERT_FREQ", "ST_BASED_FREQ", "LAST_SCHED", "LAST_CNT", "LAST_VAL", "INHERIT_AU", "MT", "MT_VERSION", "MT_NR_MEASUR", "UNIT", "FORMAT", "DESCRIPTION") AS 
  SELECT pppr.pp, pppr.version, pppr.pp_key1, pppr.pp_key2, pppr.pp_key3, pppr.pp_key4, pppr.pp_key5,
       pppr.pr, pppr.pr_version, pppr.seq, pppr.nr_measur, pppr.delay, pppr.delay_unit,
       pppr.allow_add, pppr.is_pp, pppr.freq_tp, pppr.freq_val, pppr.freq_unit, pppr.invert_freq,
       pppr.st_based_freq, pppr.last_sched, pppr.last_cnt, pppr.last_val, pppr.inherit_au,
       pppr.mt, pppr.mt_version, pppr.mt_nr_measur, pppr.unit, pppr.format, pr.description
FROM utpppr pppr, utpr pr
WHERE pppr.pr = pr.pr
  AND NVL(unapigen.UseVersion('pr',pppr.pr,pppr.pr_version),
          unapigen.UseVersion('pr',pppr.pr,'*')) = pr.version
 ;
--------------------------------------------------------
--  DDL for View UVPPPRAU
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVPPPRAU" ("PP", "VERSION", "PP_KEY1", "PP_KEY2", "PP_KEY3", "PP_KEY4", "PP_KEY5", "PR", "PR_VERSION", "AU", "AU_VERSION", "AUSEQ", "VALUE") AS 
  SELECT "PP","VERSION","PP_KEY1","PP_KEY2","PP_KEY3","PP_KEY4","PP_KEY5","PR","PR_VERSION","AU","AU_VERSION","AUSEQ","VALUE"
FROM "UNILAB".utppprau;
--------------------------------------------------------
--  DDL for View UVPPPRBUFFER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVPPPRBUFFER" ("PP", "VERSION", "PP_KEY1", "PP_KEY2", "PP_KEY3", "PP_KEY4", "PP_KEY5", "PR", "PR_VERSION", "SEQ", "NR_MEASUR", "UNIT", "FORMAT", "DELAY", "DELAY_UNIT", "ALLOW_ADD", "IS_PP", "FREQ_TP", "FREQ_VAL", "FREQ_UNIT", "INVERT_FREQ", "ST_BASED_FREQ", "LAST_SCHED", "LAST_SCHED_TZ", "LAST_CNT", "LAST_VAL", "INHERIT_AU", "MT", "MT_VERSION", "MT_NR_MEASUR", "HANDLED") AS 
  SELECT "PP","VERSION","PP_KEY1","PP_KEY2","PP_KEY3","PP_KEY4","PP_KEY5","PR","PR_VERSION","SEQ","NR_MEASUR","UNIT","FORMAT","DELAY","DELAY_UNIT","ALLOW_ADD","IS_PP","FREQ_TP","FREQ_VAL","FREQ_UNIT","INVERT_FREQ","ST_BASED_FREQ","LAST_SCHED","LAST_SCHED_TZ","LAST_CNT","LAST_VAL","INHERIT_AU","MT","MT_VERSION","MT_NR_MEASUR","HANDLED"
   FROM "UNILAB".UTPPPRBUFFER;
--------------------------------------------------------
--  DDL for View UVPPSPA
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVPPSPA" ("PP", "VERSION", "PP_KEY1", "PP_KEY2", "PP_KEY3", "PP_KEY4", "PP_KEY5", "PR", "PR_VERSION", "SEQ", "LOW_LIMIT", "HIGH_LIMIT", "LOW_SPEC", "HIGH_SPEC", "LOW_DEV", "REL_LOW_DEV", "TARGET", "HIGH_DEV", "REL_HIGH_DEV") AS 
  SELECT "PP","VERSION","PP_KEY1","PP_KEY2","PP_KEY3","PP_KEY4","PP_KEY5","PR","PR_VERSION","SEQ","LOW_LIMIT","HIGH_LIMIT","LOW_SPEC","HIGH_SPEC","LOW_DEV","REL_LOW_DEV","TARGET","HIGH_DEV","REL_HIGH_DEV"
FROM "UNILAB".utppspa;
--------------------------------------------------------
--  DDL for View UVPPSPB
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVPPSPB" ("PP", "VERSION", "PP_KEY1", "PP_KEY2", "PP_KEY3", "PP_KEY4", "PP_KEY5", "PR", "PR_VERSION", "SEQ", "LOW_LIMIT", "HIGH_LIMIT", "LOW_SPEC", "HIGH_SPEC", "LOW_DEV", "REL_LOW_DEV", "TARGET", "HIGH_DEV", "REL_HIGH_DEV") AS 
  SELECT "PP","VERSION","PP_KEY1","PP_KEY2","PP_KEY3","PP_KEY4","PP_KEY5","PR","PR_VERSION","SEQ","LOW_LIMIT","HIGH_LIMIT","LOW_SPEC","HIGH_SPEC","LOW_DEV","REL_LOW_DEV","TARGET","HIGH_DEV","REL_HIGH_DEV"
FROM "UNILAB".utppspb;
--------------------------------------------------------
--  DDL for View UVPPSPC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVPPSPC" ("PP", "VERSION", "PP_KEY1", "PP_KEY2", "PP_KEY3", "PP_KEY4", "PP_KEY5", "PR", "PR_VERSION", "SEQ", "LOW_LIMIT", "HIGH_LIMIT", "LOW_SPEC", "HIGH_SPEC", "LOW_DEV", "REL_LOW_DEV", "TARGET", "HIGH_DEV", "REL_HIGH_DEV") AS 
  SELECT "PP","VERSION","PP_KEY1","PP_KEY2","PP_KEY3","PP_KEY4","PP_KEY5","PR","PR_VERSION","SEQ","LOW_LIMIT","HIGH_LIMIT","LOW_SPEC","HIGH_SPEC","LOW_DEV","REL_LOW_DEV","TARGET","HIGH_DEV","REL_HIGH_DEV"
FROM "UNILAB".utppspc;
--------------------------------------------------------
--  DDL for View UVPR
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVPR" ("PR", "VERSION", "VERSION_IS_CURRENT", "EFFECTIVE_FROM", "EFFECTIVE_FROM_TZ", "EFFECTIVE_TILL", "EFFECTIVE_TILL_TZ", "DESCRIPTION", "DESCRIPTION2", "UNIT", "FORMAT", "TD_INFO", "TD_INFO_UNIT", "CONFIRM_UID", "DEF_VAL_TP", "DEF_AU_LEVEL", "DEF_VAL", "ALLOW_ANY_MT", "DELAY", "DELAY_UNIT", "MIN_NR_RESULTS", "CALC_METHOD", "CALC_CF", "ALARM_ORDER", "SETA_SPECS", "SETA_LIMITS", "SETA_TARGET", "SETB_SPECS", "SETB_LIMITS", "SETB_TARGET", "SETC_SPECS", "SETC_LIMITS", "SETC_TARGET", "IS_TEMPLATE", "LOG_EXCEPTIONS", "SC_LC", "SC_LC_VERSION", "INHERIT_AU", "LAST_COMMENT", "PR_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR") AS 
  SELECT
   pr,
   version,
   version_is_current,
   effective_from,
   effective_from_tz,
   effective_till,
   effective_till_tz,
   description,
   description2,
   unit,
   format,
   td_info,
   td_info_unit,
   confirm_uid,
   def_val_tp,
   def_au_level,
   def_val,
   allow_any_mt,
   delay,
   delay_unit,
   min_nr_results,
   calc_method,
   calc_cf,
   alarm_order,
   seta_specs,
   seta_limits,
   seta_target,
   setb_specs,
   setb_limits,
   setb_target,
   setc_specs,
   setc_limits,
   setc_target,
   is_template,
   log_exceptions,
   sc_lc,
   sc_lc_version,
   inherit_au,
   last_comment,
   pr_class,
   log_hs,
   log_hs_details,
   allow_modify,
   active,
   lc,
   lc_version,
   ss,
 'W' ar
FROM "UNILAB".utpr;
--------------------------------------------------------
--  DDL for View UVPRAU
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVPRAU" ("PR", "VERSION", "AU", "AU_VERSION", "AUSEQ", "VALUE") AS 
  SELECT "PR","VERSION","AU","AU_VERSION","AUSEQ","VALUE"
FROM "UNILAB".utprau;
--------------------------------------------------------
--  DDL for View UVPRCYST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVPRCYST" ("PR", "VERSION", "CY", "CY_VERSION", "ST", "ST_VERSION") AS 
  SELECT "PR","VERSION","CY","CY_VERSION","ST","ST_VERSION"
FROM "UNILAB".utprcyst;
--------------------------------------------------------
--  DDL for View UVPREF
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVPREF" ("PREF_TP", "PREF_NAME", "SEQ", "PREF_VALUE", "APPLICABLE_OBJ", "CATEGORY", "DESCRIPTION") AS 
  SELECT "PREF_TP","PREF_NAME","SEQ","PREF_VALUE","APPLICABLE_OBJ","CATEGORY","DESCRIPTION"
   FROM "UNILAB".utpref;
--------------------------------------------------------
--  DDL for View UVPREFLIST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVPREFLIST" ("PREF_TP", "PREF_NAME", "SEQ", "PREF_VALUE", "IS_DEFAULT") AS 
  SELECT "PREF_TP","PREF_NAME","SEQ","PREF_VALUE","IS_DEFAULT"
   FROM "UNILAB".utpreflist;
--------------------------------------------------------
--  DDL for View UVPRHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVPRHS" ("PR", "VERSION", "WHO", "WHO_DESCRIPTION", "WHAT", "WHAT_DESCRIPTION", "LOGDATE", "WHY", "TR_SEQ", "EV_SEQ", "LOGDATE_TZ") AS 
  SELECT "PR","VERSION","WHO","WHO_DESCRIPTION","WHAT","WHAT_DESCRIPTION","LOGDATE","WHY","TR_SEQ","EV_SEQ","LOGDATE_TZ"
FROM "UNILAB".utprhs;
--------------------------------------------------------
--  DDL for View UVPRHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVPRHSDETAILS" ("PR", "VERSION", "TR_SEQ", "EV_SEQ", "SEQ", "DETAILS") AS 
  SELECT "PR","VERSION","TR_SEQ","EV_SEQ","SEQ","DETAILS"
FROM "UNILAB".utprhsdetails;
--------------------------------------------------------
--  DDL for View UVPRINTCLDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVPRINTCLDETAILS" ("REQ_ID", "ROW_SEQ", "ROW_TYPE", "COL00", "COL01", "COL02", "COL03", "COL04", "COL05", "COL06", "COL07", "COL08", "COL09", "COL10", "COL11", "COL12", "COL13", "COL14", "COL15", "COL16", "COL17", "COL18", "COL19", "COL20", "COL21", "COL22", "COL23", "COL24", "COL25", "COL26", "COL27", "COL28", "COL29", "COL30") AS 
  SELECT "REQ_ID","ROW_SEQ","ROW_TYPE","COL00","COL01","COL02","COL03","COL04","COL05","COL06","COL07","COL08","COL09","COL10","COL11","COL12","COL13","COL14","COL15","COL16","COL17","COL18","COL19","COL20","COL21","COL22","COL23","COL24","COL25","COL26","COL27","COL28","COL29","COL30"
   FROM "UNILAB".utprintCLdetails;
--------------------------------------------------------
--  DDL for View UVPRINTCMDS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVPRINTCMDS" ("APPLIC", "WINDOW", "PRINT_CURR_LAYOUT", "PRINT_FULL_DETAILS") AS 
  SELECT "APPLIC","WINDOW","PRINT_CURR_LAYOUT","PRINT_FULL_DETAILS"
   FROM "UNILAB".utprintcmds;
--------------------------------------------------------
--  DDL for View UVPRMT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVPRMT" ("PR", "VERSION", "MT", "MT_VERSION", "SEQ", "NR_MEASUR", "UNIT", "FORMAT", "ALLOW_ADD", "IGNORE_OTHER", "ACCURACY", "FREQ_TP", "FREQ_VAL", "FREQ_UNIT", "INVERT_FREQ", "ST_BASED_FREQ", "LAST_SCHED", "LAST_CNT", "LAST_VAL", "INHERIT_AU", "LAST_SCHED_TZ") AS 
  SELECT "PR","VERSION","MT","MT_VERSION","SEQ","NR_MEASUR","UNIT","FORMAT","ALLOW_ADD","IGNORE_OTHER","ACCURACY","FREQ_TP","FREQ_VAL","FREQ_UNIT","INVERT_FREQ","ST_BASED_FREQ","LAST_SCHED","LAST_CNT","LAST_VAL","INHERIT_AU","LAST_SCHED_TZ"
FROM "UNILAB".utprmt;
--------------------------------------------------------
--  DDL for View UVPRMTAU
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVPRMTAU" ("PR", "VERSION", "MT", "MT_VERSION", "AU", "AU_VERSION", "AUSEQ", "VALUE") AS 
  SELECT "PR","VERSION","MT","MT_VERSION","AU","AU_VERSION","AUSEQ","VALUE"
FROM "UNILAB".utprmtau;
--------------------------------------------------------
--  DDL for View UVPRMTBUFFER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVPRMTBUFFER" ("PR", "VERSION", "MT", "MT_VERSION", "SEQ", "FREQ_TP", "FREQ_VAL", "FREQ_UNIT", "INVERT_FREQ", "ST_BASED_FREQ", "LAST_SCHED", "LAST_SCHED_TZ", "LAST_CNT", "LAST_VAL", "IGNORE_OTHER", "HANDLED") AS 
  SELECT "PR","VERSION","MT","MT_VERSION","SEQ","FREQ_TP","FREQ_VAL","FREQ_UNIT","INVERT_FREQ","ST_BASED_FREQ","LAST_SCHED","LAST_SCHED_TZ","LAST_CNT","LAST_VAL","IGNORE_OTHER","HANDLED"
   FROM "UNILAB".UTPRMTBUFFER;
--------------------------------------------------------
--  DDL for View UVPT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVPT" ("PT", "VERSION", "VERSION_IS_CURRENT", "EFFECTIVE_FROM", "EFFECTIVE_FROM_TZ", "EFFECTIVE_TILL", "EFFECTIVE_TILL_TZ", "DESCRIPTION", "DESCRIPTION2", "DESCR_DOC", "DESCR_DOC_VERSION", "IS_TEMPLATE", "CONFIRM_USERID", "NR_PLANNED_SD", "FREQ_TP", "FREQ_VAL", "FREQ_UNIT", "INVERT_FREQ", "LAST_SCHED", "LAST_SCHED_TZ", "LAST_CNT", "LAST_VAL", "LABEL_FORMAT", "PLANNED_RESPONSIBLE", "SD_UC", "SD_UC_VERSION", "SD_LC", "SD_LC_VERSION", "INHERIT_AU", "INHERIT_GK", "LAST_COMMENT", "PT_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR") AS 
  SELECT
   pt,
   version,
   version_is_current,
   effective_from,
   effective_from_tz,
   effective_till,
   effective_till_tz,
   description,
   description2,
   descr_doc,
   descr_doc_version,
   is_template,
   confirm_userid,
   nr_planned_sd,
   freq_tp,
   freq_val,
   freq_unit,
   invert_freq,
   last_sched,
   last_sched_tz,
   last_cnt,
   last_val,
   label_format,
   planned_responsible,
   sd_uc,
   sd_uc_version,
   sd_lc,
   sd_lc_version,
   inherit_au,
   inherit_gk,
   last_comment,
   pt_class,
   log_hs,
   log_hs_details,
   allow_modify,
   active,
   lc,
   lc_version,
   ss,
 'W' ar
FROM "UNILAB".utpt;
--------------------------------------------------------
--  DDL for View UVPTAU
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVPTAU" ("PT", "VERSION", "AU", "AU_VERSION", "AUSEQ", "VALUE") AS 
  SELECT "PT","VERSION","AU","AU_VERSION","AUSEQ","VALUE"
FROM "UNILAB".utptau;
--------------------------------------------------------
--  DDL for View UVPTCELLIP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVPTCELLIP" ("PT", "VERSION", "PTROW", "PTCOLUMN", "SEQ", "IP", "IP_VERSION") AS 
  SELECT "PT","VERSION","PTROW","PTCOLUMN","SEQ","IP","IP_VERSION"
FROM "UNILAB".utptcellip;
--------------------------------------------------------
--  DDL for View UVPTCELLPP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVPTCELLPP" ("PT", "VERSION", "PTROW", "PTCOLUMN", "SEQ", "PP", "PP_VERSION", "PP_KEY1", "PP_KEY2", "PP_KEY3", "PP_KEY4", "PP_KEY5") AS 
  SELECT "PT","VERSION","PTROW","PTCOLUMN","SEQ","PP","PP_VERSION","PP_KEY1","PP_KEY2","PP_KEY3","PP_KEY4","PP_KEY5"
FROM "UNILAB".utptcellpp;
--------------------------------------------------------
--  DDL for View UVPTCELLST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVPTCELLST" ("PT", "VERSION", "PTROW", "PTCOLUMN", "SEQ", "ST", "ST_VERSION", "NR_PLANNED_SC", "SC_LC", "SC_LC_VERSION", "SC_UC", "SC_UC_VERSION", "ADD_STPP", "ADD_STIP", "NR_SC_MAX", "INHERIT_AU") AS 
  SELECT "PT","VERSION","PTROW","PTCOLUMN","SEQ","ST","ST_VERSION","NR_PLANNED_SC","SC_LC","SC_LC_VERSION","SC_UC","SC_UC_VERSION","ADD_STPP","ADD_STIP","NR_SC_MAX","INHERIT_AU"
FROM "UNILAB".utptcellst;
--------------------------------------------------------
--  DDL for View UVPTCELLSTAU
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVPTCELLSTAU" ("PT", "VERSION", "PTROW", "PTCOLUMN", "SEQ", "ST", "ST_VERSION", "AU", "AU_VERSION", "AUSEQ", "VALUE") AS 
  SELECT "PT","VERSION","PTROW","PTCOLUMN","SEQ","ST","ST_VERSION","AU","AU_VERSION","AUSEQ","VALUE"
FROM "UNILAB".utptcellstau;
--------------------------------------------------------
--  DDL for View UVPTCS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVPTCS" ("PT", "VERSION", "PTROW", "CS", "DESCRIPTION") AS 
  SELECT "PT","VERSION","PTROW","CS","DESCRIPTION"
FROM "UNILAB".utptcs;
--------------------------------------------------------
--  DDL for View UVPTCSCN
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVPTCSCN" ("PT", "VERSION", "PTROW", "CS", "CN", "CNSEQ", "VALUE") AS 
  SELECT "PT","VERSION","PTROW","CS","CN","CNSEQ","VALUE"
FROM "UNILAB".utptcscn;
--------------------------------------------------------
--  DDL for View UVPTGK
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVPTGK" ("PT", "VERSION", "GK", "GK_VERSION", "GKSEQ", "VALUE") AS 
  SELECT "PT","VERSION","GK","GK_VERSION","GKSEQ","VALUE"
FROM "UNILAB".utptgk;
--------------------------------------------------------
--  DDL for View UVPTHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVPTHS" ("PT", "VERSION", "WHO", "WHO_DESCRIPTION", "WHAT", "WHAT_DESCRIPTION", "LOGDATE", "WHY", "TR_SEQ", "EV_SEQ", "LOGDATE_TZ") AS 
  SELECT "PT","VERSION","WHO","WHO_DESCRIPTION","WHAT","WHAT_DESCRIPTION","LOGDATE","WHY","TR_SEQ","EV_SEQ","LOGDATE_TZ"
FROM "UNILAB".utpths;
--------------------------------------------------------
--  DDL for View UVPTHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVPTHSDETAILS" ("PT", "VERSION", "TR_SEQ", "EV_SEQ", "SEQ", "DETAILS") AS 
  SELECT "PT","VERSION","TR_SEQ","EV_SEQ","SEQ","DETAILS"
FROM "UNILAB".utpthsdetails;
--------------------------------------------------------
--  DDL for View UVPTIP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVPTIP" ("PT", "VERSION", "IP", "IP_VERSION", "SEQ", "IS_PROTECTED", "HIDDEN", "FREQ_TP", "FREQ_VAL", "FREQ_UNIT", "INVERT_FREQ", "LAST_SCHED", "LAST_CNT", "LAST_VAL", "INHERIT_AU", "LAST_SCHED_TZ") AS 
  SELECT "PT","VERSION","IP","IP_VERSION","SEQ","IS_PROTECTED","HIDDEN","FREQ_TP","FREQ_VAL","FREQ_UNIT","INVERT_FREQ","LAST_SCHED","LAST_CNT","LAST_VAL","INHERIT_AU","LAST_SCHED_TZ"
FROM "UNILAB".utptip;
--------------------------------------------------------
--  DDL for View UVPTIPAU
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVPTIPAU" ("PT", "VERSION", "IP", "IP_VERSION", "AU", "AU_VERSION", "AUSEQ", "VALUE") AS 
  SELECT "PT","VERSION","IP","IP_VERSION","AU","AU_VERSION","AUSEQ","VALUE"
FROM "UNILAB".utptipau;
--------------------------------------------------------
--  DDL for View UVPTTP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVPTTP" ("PT", "VERSION", "PTCOLUMN", "TP", "TP_UNIT", "ALLOW_UPFRONT", "ALLOW_UPFRONT_UNIT", "ALLOW_OVERDUE", "ALLOW_OVERDUE_UNIT") AS 
  SELECT "PT","VERSION","PTCOLUMN","TP","TP_UNIT","ALLOW_UPFRONT","ALLOW_UPFRONT_UNIT","ALLOW_OVERDUE","ALLOW_OVERDUE_UNIT"
FROM "UNILAB".utpttp;
--------------------------------------------------------
--  DDL for View UVQUALIFICATION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVQUALIFICATION" ("QUALIFICATION", "DESCRIPTION") AS 
  SELECT "QUALIFICATION","DESCRIPTION"
   FROM "UNILAB".utqualification;
--------------------------------------------------------
--  DDL for View UVRESULTEXCEPTION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRESULTEXCEPTION" ("SC", "PG", "PGNODE", "PA", "PANODE", "REANALYSIS") AS 
  SELECT "SC","PG","PGNODE","PA","PANODE","REANALYSIS"
FROM "UNILAB".utresultexception;
--------------------------------------------------------
--  DDL for View UVRQ
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRQ" ("RQ", "RT", "RT_VERSION", "DESCRIPTION", "DESCR_DOC", "DESCR_DOC_VERSION", "SAMPLING_DATE", "SAMPLING_DATE_TZ", "CREATION_DATE", "CREATION_DATE_TZ", "CREATED_BY", "EXEC_START_DATE", "EXEC_START_DATE_TZ", "EXEC_END_DATE", "EXEC_END_DATE_TZ", "DUE_DATE", "DUE_DATE_TZ", "PRIORITY", "LABEL_FORMAT", "DATE1", "DATE1_TZ", "DATE2", "DATE2_TZ", "DATE3", "DATE3_TZ", "DATE4", "DATE4_TZ", "DATE5", "DATE5_TZ", "ALLOW_ANY_ST", "ALLOW_NEW_SC", "RESPONSIBLE", "SC_COUNTER", "RQ_COUNTER", "LAST_COMMENT", "RQ_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR") AS 
  SELECT
   rq,
   rt,
   rt_version,
   description,
   descr_doc,
   descr_doc_version,
   sampling_date,
   sampling_date_tz,
   creation_date,
   creation_date_tz,
   created_by,
   exec_start_date,
   exec_start_date_tz,
   exec_end_date,
   exec_end_date_tz,
   due_date,
   due_date_tz,
   priority,
   label_format,
   date1,
   date1_tz,
   date2,
   date2_tz,
   date3,
   date3_tz,
   date4,
   date4_tz,
   date5,
   date5_tz,
   allow_any_st,
   allow_new_sc,
   responsible,
   sc_counter,
   rq_counter,
   last_comment,
   rq_class,
   log_hs,
   log_hs_details,
   allow_modify,
   active,
   lc,
   lc_version,
   ss,
 'W' ar
FROM "UNILAB".utrq;
--------------------------------------------------------
--  DDL for View UVRQAU
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRQAU" ("RQ", "AU", "AU_VERSION", "AUSEQ", "VALUE") AS 
  SELECT "RQ","AU","AU_VERSION","AUSEQ","VALUE"
FROM "UNILAB".utrqau;
--------------------------------------------------------
--  DDL for View UVRQGK
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRQGK" ("RQ", "GK", "GK_VERSION", "GKSEQ", "VALUE") AS 
  SELECT "RQ","GK","GK_VERSION","GKSEQ","VALUE"
FROM "UNILAB".utrqgk;
--------------------------------------------------------
--  DDL for View UVRQGKISRELEVANT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRQGKISRELEVANT" ("ISRELEVANT", "RQ") AS 
  SELECT "ISRELEVANT","RQ" FROM UTRQGKisRelevant
 ;
--------------------------------------------------------
--  DDL for View UVRQGKISTEST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRQGKISTEST" ("ISTEST", "RQ") AS 
  SELECT "ISTEST","RQ" FROM UTRQGKisTest
 ;
--------------------------------------------------------
--  DDL for View UVRQGKMANUAL2AVAILABLE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRQGKMANUAL2AVAILABLE" ("MANUAL2AVAILABLE", "RQ") AS 
  SELECT "MANUAL2AVAILABLE","RQ" FROM UTRQGKmanual2Available
 ;
--------------------------------------------------------
--  DDL for View UVRQGKOUTSOURCED_TO
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRQGKOUTSOURCED_TO" ("OUTSOURCED_TO", "RQ") AS 
  SELECT "OUTSOURCED_TO","RQ" FROM UTRQGKOutsourced_to;
--------------------------------------------------------
--  DDL for View UVRQGKREQUESTCODE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRQGKREQUESTCODE" ("REQUESTCODE", "RQ") AS 
  SELECT "REQUESTCODE","RQ" FROM UTRQGKRequestCode
 ;
--------------------------------------------------------
--  DDL for View UVRQGKRQDAY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRQGKRQDAY" ("RQDAY", "RQ") AS 
  SELECT "RQDAY","RQ" FROM UTRQGKRqDay
 ;
--------------------------------------------------------
--  DDL for View UVRQGKRQEXECUTIONWEEK
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRQGKRQEXECUTIONWEEK" ("RQEXECUTIONWEEK", "RQ") AS 
  SELECT "RQEXECUTIONWEEK","RQ" FROM UTRQGKRqExecutionWeek
 ;
--------------------------------------------------------
--  DDL for View UVRQGKRQEXECUTOR
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRQGKRQEXECUTOR" ("RQEXECUTOR", "RQ") AS 
  SELECT "RQEXECUTOR","RQ" FROM UTRQGKRqExecutor
 ;
--------------------------------------------------------
--  DDL for View UVRQGKRQMONTH
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRQGKRQMONTH" ("RQMONTH", "RQ") AS 
  SELECT "RQMONTH","RQ" FROM UTRQGKRqMonth
 ;
--------------------------------------------------------
--  DDL for View UVRQGKRQPLANNEDEXECWEEK
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRQGKRQPLANNEDEXECWEEK" ("RQPLANNEDEXECWEEK", "RQ") AS 
  SELECT "RQPLANNEDEXECWEEK","RQ" FROM UTRQGKrqPlannedExecWeek;
--------------------------------------------------------
--  DDL for View UVRQGKRQREQREADYDATE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRQGKRQREQREADYDATE" ("RQREQREADYDATE", "RQ") AS 
  SELECT "RQREQREADYDATE","RQ" FROM UTRQGKRqReqReadyDate
 ;
--------------------------------------------------------
--  DDL for View UVRQGKRQRQREADYDD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRQGKRQRQREADYDD" ("RQRQREADYDD", "RQ") AS 
  SELECT "RQRQREADYDD","RQ" FROM UTRQGKRQrqreadyDD
 ;
--------------------------------------------------------
--  DDL for View UVRQGKRQRQREADYMM
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRQGKRQRQREADYMM" ("RQRQREADYMM", "RQ") AS 
  SELECT "RQRQREADYMM","RQ" FROM UTRQGKRQrqreadyMM
 ;
--------------------------------------------------------
--  DDL for View UVRQGKRQRQREADYYYYY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRQGKRQRQREADYYYYY" ("RQRQREADYYYYY", "RQ") AS 
  SELECT "RQRQREADYYYYY","RQ" FROM UTRQGKRQrqreadyYYYY
 ;
--------------------------------------------------------
--  DDL for View UVRQGKRQSTATUS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRQGKRQSTATUS" ("RQSTATUS", "RQ") AS 
  SELECT "RQSTATUS","RQ" FROM UTRQGKrqStatus
 ;
--------------------------------------------------------
--  DDL for View UVRQGKRQSTATUSTYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRQGKRQSTATUSTYPE" ("RQSTATUSTYPE", "RQ") AS 
  SELECT "RQSTATUSTYPE","RQ" FROM UTRQGKrqStatusType
 ;
--------------------------------------------------------
--  DDL for View UVRQGKRQWEEK
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRQGKRQWEEK" ("RQWEEK", "RQ") AS 
  SELECT "RQWEEK","RQ" FROM UTRQGKRqWeek
 ;
--------------------------------------------------------
--  DDL for View UVRQGKRQYEAR
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRQGKRQYEAR" ("RQYEAR", "RQ") AS 
  SELECT "RQYEAR","RQ" FROM UTRQGKRqYear
 ;
--------------------------------------------------------
--  DDL for View UVRQGKSITE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRQGKSITE" ("SITE", "RQ") AS 
  SELECT "SITE","RQ" FROM UTRQGKSite;
--------------------------------------------------------
--  DDL for View UVRQGKTESTLOCATION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRQGKTESTLOCATION" ("TESTLOCATION", "RQ") AS 
  SELECT "TESTLOCATION","RQ" FROM UTRQGKTestLocation
 ;
--------------------------------------------------------
--  DDL for View UVRQGKTESTTYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRQGKTESTTYPE" ("TESTTYPE", "RQ") AS 
  SELECT "TESTTYPE","RQ" FROM UTRQGKTestType
 ;
--------------------------------------------------------
--  DDL for View UVRQGKVALIDATERESULT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRQGKVALIDATERESULT" ("VALIDATERESULT", "RQ") AS 
  SELECT "VALIDATERESULT","RQ" FROM UTRQGKvalidateResult
 ;
--------------------------------------------------------
--  DDL for View UVRQGKWAITFOR
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRQGKWAITFOR" ("WAITFOR", "RQ") AS 
  SELECT "WAITFOR","RQ" FROM UTRQGKWaitFor
 ;
--------------------------------------------------------
--  DDL for View UVRQGKWAITFORINITIAL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRQGKWAITFORINITIAL" ("WAITFORINITIAL", "RQ") AS 
  SELECT "WAITFORINITIAL","RQ" FROM UTRQGKWaitForInitial
 ;
--------------------------------------------------------
--  DDL for View UVRQGKWORKORDER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRQGKWORKORDER" ("WORKORDER", "RQ") AS 
  SELECT "WORKORDER","RQ" FROM UTRQGKWorkorder;
--------------------------------------------------------
--  DDL for View UVRQHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRQHS" ("RQ", "WHO", "WHO_DESCRIPTION", "WHAT", "WHAT_DESCRIPTION", "LOGDATE", "WHY", "TR_SEQ", "EV_SEQ", "LOGDATE_TZ") AS 
  SELECT "RQ","WHO","WHO_DESCRIPTION","WHAT","WHAT_DESCRIPTION","LOGDATE","WHY","TR_SEQ","EV_SEQ","LOGDATE_TZ"
FROM "UNILAB".utrqhs;
--------------------------------------------------------
--  DDL for View UVRQHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRQHSDETAILS" ("RQ", "TR_SEQ", "EV_SEQ", "SEQ", "DETAILS") AS 
  SELECT "RQ","TR_SEQ","EV_SEQ","SEQ","DETAILS"
FROM "UNILAB".utrqhsdetails;
--------------------------------------------------------
--  DDL for View UVRQIC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRQIC" ("RQ", "IC", "ICNODE", "IP_VERSION", "DESCRIPTION", "WINSIZE_X", "WINSIZE_Y", "IS_PROTECTED", "HIDDEN", "MANUALLY_ADDED", "NEXT_II", "LAST_COMMENT", "IC_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR") AS 
  SELECT
   rq,
   ic,
   icnode,
   ip_version,
   description,
   winsize_x,
   winsize_y,
   is_protected,
   hidden,
   manually_added,
   next_ii,
   last_comment,
   ic_class,
   log_hs,
   log_hs_details,
   allow_modify,
   active,
   lc,
   lc_version,
   ss,
 'W' ar
FROM "UNILAB".utrqic;
--------------------------------------------------------
--  DDL for View UVRQICAU
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRQICAU" ("RQ", "IC", "ICNODE", "AU", "AU_VERSION", "AUSEQ", "VALUE") AS 
  SELECT "RQ","IC","ICNODE","AU","AU_VERSION","AUSEQ","VALUE"
FROM "UNILAB".utrqicau;
--------------------------------------------------------
--  DDL for View UVRQICHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRQICHS" ("RQ", "IC", "ICNODE", "WHO", "WHO_DESCRIPTION", "WHAT", "WHAT_DESCRIPTION", "LOGDATE", "WHY", "TR_SEQ", "EV_SEQ", "LOGDATE_TZ") AS 
  SELECT "RQ","IC","ICNODE","WHO","WHO_DESCRIPTION","WHAT","WHAT_DESCRIPTION","LOGDATE","WHY","TR_SEQ","EV_SEQ","LOGDATE_TZ"
FROM "UNILAB".utrqichs;
--------------------------------------------------------
--  DDL for View UVRQICHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRQICHSDETAILS" ("RQ", "IC", "ICNODE", "TR_SEQ", "EV_SEQ", "SEQ", "DETAILS") AS 
  SELECT "RQ","IC","ICNODE","TR_SEQ","EV_SEQ","SEQ","DETAILS"
FROM "UNILAB".utrqichsdetails;
--------------------------------------------------------
--  DDL for View UVRQII
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRQII" ("RQ", "IC", "ICNODE", "II", "IINODE", "IE_VERSION", "IIVALUE", "POS_X", "POS_Y", "IS_PROTECTED", "MANDATORY", "HIDDEN", "DSP_TITLE", "DSP_LEN", "DSP_TP", "DSP_ROWS", "II_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR") AS 
  SELECT
   rq,
   ic,
   icnode,
   ii,
   iinode,
   ie_version,
   iivalue,
   pos_x,
   pos_y,
   is_protected,
   mandatory,
   hidden,
   dsp_title,
   dsp_len,
   dsp_tp,
   dsp_rows,
   ii_class,
   log_hs,
   log_hs_details,
   allow_modify,
   active,
   lc,
   lc_version,
   ss,
 'W' ar
FROM "UNILAB".utrqii;
--------------------------------------------------------
--  DDL for View UVRQPP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRQPP" ("RQ", "PP", "PP_VERSION", "PP_KEY1", "PP_KEY2", "PP_KEY3", "PP_KEY4", "PP_KEY5", "SEQ", "DELAY", "DELAY_UNIT", "FREQ_TP", "FREQ_VAL", "FREQ_UNIT", "INVERT_FREQ", "LAST_SCHED", "LAST_CNT", "LAST_VAL", "INHERIT_AU", "LAST_SCHED_TZ") AS 
  SELECT "RQ","PP","PP_VERSION","PP_KEY1","PP_KEY2","PP_KEY3","PP_KEY4","PP_KEY5","SEQ","DELAY","DELAY_UNIT","FREQ_TP","FREQ_VAL","FREQ_UNIT","INVERT_FREQ","LAST_SCHED","LAST_CNT","LAST_VAL","INHERIT_AU","LAST_SCHED_TZ"
FROM "UNILAB".utrqpp;
--------------------------------------------------------
--  DDL for View UVRQPPAU
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRQPPAU" ("RQ", "PP", "PP_VERSION", "PP_KEY1", "PP_KEY2", "PP_KEY3", "PP_KEY4", "PP_KEY5", "AU", "AU_VERSION", "AUSEQ", "VALUE") AS 
  SELECT "RQ","PP","PP_VERSION","PP_KEY1","PP_KEY2","PP_KEY3","PP_KEY4","PP_KEY5","AU","AU_VERSION","AUSEQ","VALUE"
FROM "UNILAB".utrqppau;
--------------------------------------------------------
--  DDL for View UVRQSC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRQSC" ("RQ", "SC", "SEQ", "ASSIGN_DATE", "ASSIGNED_BY", "ASSIGN_DATE_TZ") AS 
  SELECT "RQ","SC","SEQ","ASSIGN_DATE","ASSIGNED_BY","ASSIGN_DATE_TZ"
FROM "UNILAB".utrqsc;
--------------------------------------------------------
--  DDL for View UVRSCME
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRSCME" ("SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE", "MT_VERSION", "DESCRIPTION", "VALUE_F", "VALUE_S", "UNIT", "EXEC_START_DATE", "EXEC_END_DATE", "EXECUTOR", "LAB", "EQ", "EQ_VERSION", "PLANNED_EXECUTOR", "PLANNED_EQ", "PLANNED_EQ_VERSION", "MANUALLY_ENTERED", "ALLOW_ADD", "ASSIGN_DATE", "ASSIGNED_BY", "MANUALLY_ADDED", "DELAY", "DELAY_UNIT", "FORMAT", "ACCURACY", "REAL_COST", "REAL_TIME", "CALIBRATION", "CONFIRM_COMPLETE", "AUTORECALC", "ME_RESULT_EDITABLE", "NEXT_CELL", "SOP", "SOP_VERSION", "PLAUS_LOW", "PLAUS_HIGH", "WINSIZE_X", "WINSIZE_Y", "REANALYSIS", "LAST_COMMENT", "ME_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR1", "AR2", "AR3", "AR4", "AR5", "AR6", "AR7", "AR8", "AR9", "AR10", "AR11", "AR12", "AR13", "AR14", "AR15", "AR16", "EXEC_START_DATE_TZ", "EXEC_END_DATE_TZ", "ASSIGN_DATE_TZ") AS 
  SELECT "SC","PG","PGNODE","PA","PANODE","ME","MENODE","MT_VERSION","DESCRIPTION","VALUE_F","VALUE_S","UNIT","EXEC_START_DATE","EXEC_END_DATE","EXECUTOR","LAB","EQ","EQ_VERSION","PLANNED_EXECUTOR","PLANNED_EQ","PLANNED_EQ_VERSION","MANUALLY_ENTERED","ALLOW_ADD","ASSIGN_DATE","ASSIGNED_BY","MANUALLY_ADDED","DELAY","DELAY_UNIT","FORMAT","ACCURACY","REAL_COST","REAL_TIME","CALIBRATION","CONFIRM_COMPLETE","AUTORECALC","ME_RESULT_EDITABLE","NEXT_CELL","SOP","SOP_VERSION","PLAUS_LOW","PLAUS_HIGH","WINSIZE_X","WINSIZE_Y","REANALYSIS","LAST_COMMENT","ME_CLASS","LOG_HS","LOG_HS_DETAILS","ALLOW_MODIFY","ACTIVE","LC","LC_VERSION","SS","AR1","AR2","AR3","AR4","AR5","AR6","AR7","AR8","AR9","AR10","AR11","AR12","AR13","AR14","AR15","AR16","EXEC_START_DATE_TZ","EXEC_END_DATE_TZ","ASSIGN_DATE_TZ"
FROM "UNILAB".utrscme;
--------------------------------------------------------
--  DDL for View UVRSCMECELL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRSCMECELL" ("SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE", "REANALYSIS", "CELL", "CELLNODE", "DSP_TITLE", "VALUE_F", "VALUE_S", "CELL_TP", "POS_X", "POS_Y", "ALIGN", "WINSIZE_X", "WINSIZE_Y", "IS_PROTECTED", "MANDATORY", "HIDDEN", "UNIT", "FORMAT", "EQ", "EQ_VERSION", "COMPONENT", "CALC_TP", "CALC_FORMULA", "VALID_CF", "MAX_X", "MAX_Y", "MULTI_SELECT") AS 
  SELECT "SC","PG","PGNODE","PA","PANODE","ME","MENODE","REANALYSIS","CELL","CELLNODE","DSP_TITLE","VALUE_F","VALUE_S","CELL_TP","POS_X","POS_Y","ALIGN","WINSIZE_X","WINSIZE_Y","IS_PROTECTED","MANDATORY","HIDDEN","UNIT","FORMAT","EQ","EQ_VERSION","COMPONENT","CALC_TP","CALC_FORMULA","VALID_CF","MAX_X","MAX_Y","MULTI_SELECT"
FROM "UNILAB".utrscmecell;
--------------------------------------------------------
--  DDL for View UVRSCMECELLINPUT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRSCMECELLINPUT" ("SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE", "REANALYSIS", "CELL", "INPUT_TP", "INPUT_SOURCE", "INPUT_VERSION", "INPUT_PG", "INPUT_PGNODE", "INPUT_PP_VERSION", "INPUT_PA", "INPUT_PANODE", "INPUT_PR_VERSION", "INPUT_ME", "INPUT_MENODE", "INPUT_MT_VERSION", "INPUT_REANALYSIS") AS 
  SELECT "SC","PG","PGNODE","PA","PANODE","ME","MENODE","REANALYSIS","CELL","INPUT_TP","INPUT_SOURCE","INPUT_VERSION","INPUT_PG","INPUT_PGNODE","INPUT_PP_VERSION","INPUT_PA","INPUT_PANODE","INPUT_PR_VERSION","INPUT_ME","INPUT_MENODE","INPUT_MT_VERSION","INPUT_REANALYSIS"
FROM "UNILAB".utrscmecellinput;
--------------------------------------------------------
--  DDL for View UVRSCMECELLLIST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRSCMECELLLIST" ("SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE", "REANALYSIS", "CELL", "INDEX_X", "INDEX_Y", "VALUE_F", "VALUE_S", "SELECTED") AS 
  SELECT "SC","PG","PGNODE","PA","PANODE","ME","MENODE","REANALYSIS","CELL","INDEX_X","INDEX_Y","VALUE_F","VALUE_S","SELECTED"
FROM "UNILAB".utrscmecelllist;
--------------------------------------------------------
--  DDL for View UVRSCMECELLLISTOUTPUT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRSCMECELLLISTOUTPUT" ("SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE", "REANALYSIS", "CELL", "INDEX_Y", "SAVE_TP", "SAVE_PG", "SAVE_PGNODE", "SAVE_PP_VERSION", "SAVE_PA", "SAVE_PANODE", "SAVE_PR_VERSION", "SAVE_ME", "SAVE_MENODE", "SAVE_MT_VERSION", "SAVE_EQ", "SAVE_EQ_VERSION", "SAVE_ID", "SAVE_IDNODE", "SAVE_REANALYSIS", "CREATE_NEW") AS 
  SELECT "SC","PG","PGNODE","PA","PANODE","ME","MENODE","REANALYSIS","CELL","INDEX_Y","SAVE_TP","SAVE_PG","SAVE_PGNODE","SAVE_PP_VERSION","SAVE_PA","SAVE_PANODE","SAVE_PR_VERSION","SAVE_ME","SAVE_MENODE","SAVE_MT_VERSION","SAVE_EQ","SAVE_EQ_VERSION","SAVE_ID","SAVE_IDNODE","SAVE_REANALYSIS","CREATE_NEW"
FROM "UNILAB".utrscmecelllistoutput;
--------------------------------------------------------
--  DDL for View UVRSCMECELLOUTPUT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRSCMECELLOUTPUT" ("SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE", "REANALYSIS", "CELL", "SAVE_TP", "SAVE_PG", "SAVE_PGNODE", "SAVE_PP_VERSION", "SAVE_PA", "SAVE_PANODE", "SAVE_PR_VERSION", "SAVE_ME", "SAVE_MENODE", "SAVE_MT_VERSION", "SAVE_EQ", "SAVE_EQ_VERSION", "SAVE_ID", "SAVE_IDNODE", "SAVE_REANALYSIS", "CREATE_NEW") AS 
  SELECT "SC","PG","PGNODE","PA","PANODE","ME","MENODE","REANALYSIS","CELL","SAVE_TP","SAVE_PG","SAVE_PGNODE","SAVE_PP_VERSION","SAVE_PA","SAVE_PANODE","SAVE_PR_VERSION","SAVE_ME","SAVE_MENODE","SAVE_MT_VERSION","SAVE_EQ","SAVE_EQ_VERSION","SAVE_ID","SAVE_IDNODE","SAVE_REANALYSIS","CREATE_NEW"
FROM "UNILAB".utrscmecelloutput;
--------------------------------------------------------
--  DDL for View UVRSCPA
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRSCPA" ("SC", "PG", "PGNODE", "PA", "PANODE", "PR_VERSION", "DESCRIPTION", "VALUE_F", "VALUE_S", "UNIT", "EXEC_START_DATE", "EXEC_END_DATE", "EXECUTOR", "PLANNED_EXECUTOR", "MANUALLY_ENTERED", "ASSIGN_DATE", "ASSIGNED_BY", "MANUALLY_ADDED", "FORMAT", "TD_INFO", "TD_INFO_UNIT", "CONFIRM_UID", "ALLOW_ANY_ME", "DELAY", "DELAY_UNIT", "MIN_NR_RESULTS", "CALC_METHOD", "CALC_CF", "ALARM_ORDER", "VALID_SPECSA", "VALID_SPECSB", "VALID_SPECSC", "VALID_LIMITSA", "VALID_LIMITSB", "VALID_LIMITSC", "VALID_TARGETA", "VALID_TARGETB", "VALID_TARGETC", "LOG_EXCEPTIONS", "REANALYSIS", "LAST_COMMENT", "PA_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR1", "AR2", "AR3", "AR4", "AR5", "AR6", "AR7", "AR8", "AR9", "AR10", "AR11", "AR12", "AR13", "AR14", "AR15", "AR16", "EXEC_START_DATE_TZ", "EXEC_END_DATE_TZ", "ASSIGN_DATE_TZ") AS 
  SELECT "SC","PG","PGNODE","PA","PANODE","PR_VERSION","DESCRIPTION","VALUE_F","VALUE_S","UNIT","EXEC_START_DATE","EXEC_END_DATE","EXECUTOR","PLANNED_EXECUTOR","MANUALLY_ENTERED","ASSIGN_DATE","ASSIGNED_BY","MANUALLY_ADDED","FORMAT","TD_INFO","TD_INFO_UNIT","CONFIRM_UID","ALLOW_ANY_ME","DELAY","DELAY_UNIT","MIN_NR_RESULTS","CALC_METHOD","CALC_CF","ALARM_ORDER","VALID_SPECSA","VALID_SPECSB","VALID_SPECSC","VALID_LIMITSA","VALID_LIMITSB","VALID_LIMITSC","VALID_TARGETA","VALID_TARGETB","VALID_TARGETC","LOG_EXCEPTIONS","REANALYSIS","LAST_COMMENT","PA_CLASS","LOG_HS","LOG_HS_DETAILS","ALLOW_MODIFY","ACTIVE","LC","LC_VERSION","SS","AR1","AR2","AR3","AR4","AR5","AR6","AR7","AR8","AR9","AR10","AR11","AR12","AR13","AR14","AR15","AR16","EXEC_START_DATE_TZ","EXEC_END_DATE_TZ","ASSIGN_DATE_TZ"
FROM "UNILAB".utrscpa;
--------------------------------------------------------
--  DDL for View UVRSCPAOUTPUT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRSCPAOUTPUT" ("SC", "PG", "PGNODE", "PA", "PANODE", "REANALYSIS", "SAVE_PG", "SAVE_PGNODE", "SAVE_PA", "SAVE_PANODE") AS 
  SELECT "SC","PG","PGNODE","PA","PANODE","REANALYSIS","SAVE_PG","SAVE_PGNODE","SAVE_PA","SAVE_PANODE"
FROM "UNILAB".utrscpaoutput;
--------------------------------------------------------
--  DDL for View UVRSCPASPA
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRSCPASPA" ("SC", "PG", "PGNODE", "PA", "PANODE", "REANALYSIS", "LOW_LIMIT", "HIGH_LIMIT", "LOW_SPEC", "HIGH_SPEC", "LOW_DEV", "REL_LOW_DEV", "TARGET", "HIGH_DEV", "REL_HIGH_DEV") AS 
  SELECT "SC","PG","PGNODE","PA","PANODE","REANALYSIS","LOW_LIMIT","HIGH_LIMIT","LOW_SPEC","HIGH_SPEC","LOW_DEV","REL_LOW_DEV","TARGET","HIGH_DEV","REL_HIGH_DEV"
FROM "UNILAB".utrscpaspa;
--------------------------------------------------------
--  DDL for View UVRSCPASPB
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRSCPASPB" ("SC", "PG", "PGNODE", "PA", "PANODE", "REANALYSIS", "LOW_LIMIT", "HIGH_LIMIT", "LOW_SPEC", "HIGH_SPEC", "LOW_DEV", "REL_LOW_DEV", "TARGET", "HIGH_DEV", "REL_HIGH_DEV") AS 
  SELECT "SC","PG","PGNODE","PA","PANODE","REANALYSIS","LOW_LIMIT","HIGH_LIMIT","LOW_SPEC","HIGH_SPEC","LOW_DEV","REL_LOW_DEV","TARGET","HIGH_DEV","REL_HIGH_DEV"
FROM "UNILAB".utrscpaspb;
--------------------------------------------------------
--  DDL for View UVRSCPASPC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRSCPASPC" ("SC", "PG", "PGNODE", "PA", "PANODE", "REANALYSIS", "LOW_LIMIT", "HIGH_LIMIT", "LOW_SPEC", "HIGH_SPEC", "LOW_DEV", "REL_LOW_DEV", "TARGET", "HIGH_DEV", "REL_HIGH_DEV") AS 
  SELECT "SC","PG","PGNODE","PA","PANODE","REANALYSIS","LOW_LIMIT","HIGH_LIMIT","LOW_SPEC","HIGH_SPEC","LOW_DEV","REL_LOW_DEV","TARGET","HIGH_DEV","REL_HIGH_DEV"
FROM "UNILAB".utrscpaspc;
--------------------------------------------------------
--  DDL for View UVRSCPASQC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRSCPASQC" ("SC", "PG", "PGNODE", "PA", "PANODE", "REANALYSIS", "SQC_AVG", "SQC_SIGMA", "SQC_AVGR", "SQC_UCLR", "VALID_SQC") AS 
  SELECT "SC","PG","PGNODE","PA","PANODE","REANALYSIS","SQC_AVG","SQC_SIGMA","SQC_AVGR","SQC_UCLR","VALID_SQC"
FROM "UNILAB".utrscpasqc;
--------------------------------------------------------
--  DDL for View UVRSCPG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRSCPG" ("SC", "PG", "PGNODE", "PP_VERSION", "PP_KEY1", "PP_KEY2", "PP_KEY3", "PP_KEY4", "PP_KEY5", "DESCRIPTION", "VALUE_F", "VALUE_S", "UNIT", "EXEC_START_DATE", "EXEC_END_DATE", "EXECUTOR", "PLANNED_EXECUTOR", "MANUALLY_ENTERED", "ASSIGN_DATE", "ASSIGNED_BY", "MANUALLY_ADDED", "FORMAT", "CONFIRM_ASSIGN", "ALLOW_ANY_PR", "NEVER_CREATE_METHODS", "DELAY", "DELAY_UNIT", "REANALYSIS", "LAST_COMMENT", "PG_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR1", "AR2", "AR3", "AR4", "AR5", "AR6", "AR7", "AR8", "AR9", "AR10", "AR11", "AR12", "AR13", "AR14", "AR15", "AR16", "EXEC_START_DATE_TZ", "EXEC_END_DATE_TZ", "ASSIGN_DATE_TZ") AS 
  SELECT "SC","PG","PGNODE","PP_VERSION","PP_KEY1","PP_KEY2","PP_KEY3","PP_KEY4","PP_KEY5","DESCRIPTION","VALUE_F","VALUE_S","UNIT","EXEC_START_DATE","EXEC_END_DATE","EXECUTOR","PLANNED_EXECUTOR","MANUALLY_ENTERED","ASSIGN_DATE","ASSIGNED_BY","MANUALLY_ADDED","FORMAT","CONFIRM_ASSIGN","ALLOW_ANY_PR","NEVER_CREATE_METHODS","DELAY","DELAY_UNIT","REANALYSIS","LAST_COMMENT","PG_CLASS","LOG_HS","LOG_HS_DETAILS","ALLOW_MODIFY","ACTIVE","LC","LC_VERSION","SS","AR1","AR2","AR3","AR4","AR5","AR6","AR7","AR8","AR9","AR10","AR11","AR12","AR13","AR14","AR15","AR16","EXEC_START_DATE_TZ","EXEC_END_DATE_TZ","ASSIGN_DATE_TZ"
FROM "UNILAB".utrscpg;
--------------------------------------------------------
--  DDL for View UVRSCRD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRSCRD" ("SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE", "RD", "RDNODE", "VALUE_F", "VALUE_S", "REANALYSIS") AS 
  SELECT "SC","PG","PGNODE","PA","PANODE","ME","MENODE","RD","RDNODE","VALUE_F","VALUE_S","REANALYSIS"
   FROM "UNILAB".utrscrd;
--------------------------------------------------------
--  DDL for View UVRT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRT" ("RT", "VERSION", "VERSION_IS_CURRENT", "EFFECTIVE_FROM", "EFFECTIVE_FROM_TZ", "EFFECTIVE_TILL", "EFFECTIVE_TILL_TZ", "DESCRIPTION", "DESCRIPTION2", "DESCR_DOC", "DESCR_DOC_VERSION", "IS_TEMPLATE", "CONFIRM_USERID", "NR_PLANNED_RQ", "FREQ_TP", "FREQ_VAL", "FREQ_UNIT", "INVERT_FREQ", "LAST_SCHED", "LAST_SCHED_TZ", "LAST_CNT", "LAST_VAL", "PRIORITY", "LABEL_FORMAT", "ALLOW_ANY_ST", "ALLOW_NEW_SC", "ADD_STPP", "PLANNED_RESPONSIBLE", "SC_UC", "SC_UC_VERSION", "RQ_UC", "RQ_UC_VERSION", "RQ_LC", "RQ_LC_VERSION", "INHERIT_AU", "INHERIT_GK", "LAST_COMMENT", "RT_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR") AS 
  SELECT
   rt,
   version,
   version_is_current,
   effective_from,
   effective_from_tz,
   effective_till,
   effective_till_tz,
   description,
   description2,
   descr_doc,
   descr_doc_version,
   is_template,
   confirm_userid,
   nr_planned_rq,
   freq_tp,
   freq_val,
   freq_unit,
   invert_freq,
   last_sched,
   last_sched_tz,
   last_cnt,
   last_val,
   priority,
   label_format,
   allow_any_st,
   allow_new_sc,
   add_stpp,
   planned_responsible,
   sc_uc,
   sc_uc_version,
   rq_uc,
   rq_uc_version,
   rq_lc,
   rq_lc_version,
   inherit_au,
   inherit_gk,
   last_comment,
   rt_class,
   log_hs,
   log_hs_details,
   allow_modify,
   active,
   lc,
   lc_version,
   ss,
 'W' ar
FROM "UNILAB".utrt;
--------------------------------------------------------
--  DDL for View UVRTAU
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRTAU" ("RT", "VERSION", "AU", "AU_VERSION", "AUSEQ", "VALUE") AS 
  SELECT "RT","VERSION","AU","AU_VERSION","AUSEQ","VALUE"
FROM "UNILAB".utrtau;
--------------------------------------------------------
--  DDL for View UVRTGK
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRTGK" ("RT", "VERSION", "GK", "GK_VERSION", "GKSEQ", "VALUE") AS 
  SELECT "RT","VERSION","GK","GK_VERSION","GKSEQ","VALUE"
FROM "UNILAB".utrtgk;
--------------------------------------------------------
--  DDL for View UVRTGKISTEST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRTGKISTEST" ("ISTEST", "RT", "VERSION") AS 
  SELECT "ISTEST","RT","VERSION" FROM UTRTGKisTest
 ;
--------------------------------------------------------
--  DDL for View UVRTGKREQUESTERUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRTGKREQUESTERUP" ("REQUESTERUP", "RT", "VERSION") AS 
  SELECT "REQUESTERUP","RT","VERSION" FROM UTRTGKrequesterUp
 ;
--------------------------------------------------------
--  DDL for View UVRTGKRQCREATEUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRTGKRQCREATEUP" ("RQCREATEUP", "RT", "VERSION") AS 
  SELECT "RQCREATEUP","RT","VERSION" FROM UTRTGKrqCreateUp
 ;
--------------------------------------------------------
--  DDL for View UVRTGKRQLISTUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRTGKRQLISTUP" ("RQLISTUP", "RT", "VERSION") AS 
  SELECT "RQLISTUP","RT","VERSION" FROM UTRTGKrqListUp
 ;
--------------------------------------------------------
--  DDL for View UVRTGKRTLISTSORTORDER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRTGKRTLISTSORTORDER" ("RTLISTSORTORDER", "RT", "VERSION") AS 
  SELECT "RTLISTSORTORDER","RT","VERSION" FROM UTRTGKRtListSortOrder
 ;
--------------------------------------------------------
--  DDL for View UVRTGKSITE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRTGKSITE" ("SITE", "RT", "VERSION") AS 
  SELECT "SITE","RT","VERSION" FROM UTRTGKSite;
--------------------------------------------------------
--  DDL for View UVRTGKSPEC_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRTGKSPEC_TYPE" ("SPEC_TYPE", "RT", "VERSION") AS 
  SELECT "SPEC_TYPE","RT","VERSION" FROM UTRTGKSPEC_TYPE
 ;
--------------------------------------------------------
--  DDL for View UVRTGKUSERPROFILES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRTGKUSERPROFILES" ("USERPROFILES", "RT", "VERSION") AS 
  SELECT "USERPROFILES","RT","VERSION" FROM UTRTGKuserProfiles
 ;
--------------------------------------------------------
--  DDL for View UVRTGKVALIDATERESULT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRTGKVALIDATERESULT" ("VALIDATERESULT", "RT", "VERSION") AS 
  SELECT "VALIDATERESULT","RT","VERSION" FROM UTRTGKvalidateResult;
--------------------------------------------------------
--  DDL for View UVRTHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRTHS" ("RT", "VERSION", "WHO", "WHO_DESCRIPTION", "WHAT", "WHAT_DESCRIPTION", "LOGDATE", "WHY", "TR_SEQ", "EV_SEQ", "LOGDATE_TZ") AS 
  SELECT "RT","VERSION","WHO","WHO_DESCRIPTION","WHAT","WHAT_DESCRIPTION","LOGDATE","WHY","TR_SEQ","EV_SEQ","LOGDATE_TZ"
FROM "UNILAB".utrths;
--------------------------------------------------------
--  DDL for View UVRTHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRTHSDETAILS" ("RT", "VERSION", "TR_SEQ", "EV_SEQ", "SEQ", "DETAILS") AS 
  SELECT "RT","VERSION","TR_SEQ","EV_SEQ","SEQ","DETAILS"
FROM "UNILAB".utrthsdetails;
--------------------------------------------------------
--  DDL for View UVRTIP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRTIP" ("RT", "VERSION", "IP", "IP_VERSION", "SEQ", "IS_PROTECTED", "HIDDEN", "FREQ_TP", "FREQ_VAL", "FREQ_UNIT", "INVERT_FREQ", "LAST_SCHED", "LAST_CNT", "LAST_VAL", "INHERIT_AU", "LAST_SCHED_TZ") AS 
  SELECT "RT","VERSION","IP","IP_VERSION","SEQ","IS_PROTECTED","HIDDEN","FREQ_TP","FREQ_VAL","FREQ_UNIT","INVERT_FREQ","LAST_SCHED","LAST_CNT","LAST_VAL","INHERIT_AU","LAST_SCHED_TZ"
FROM "UNILAB".utrtip;
--------------------------------------------------------
--  DDL for View UVRTIPAU
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRTIPAU" ("RT", "VERSION", "IP", "IP_VERSION", "AU", "AU_VERSION", "AUSEQ", "VALUE") AS 
  SELECT "RT","VERSION","IP","IP_VERSION","AU","AU_VERSION","AUSEQ","VALUE"
FROM "UNILAB".utrtipau;
--------------------------------------------------------
--  DDL for View UVRTPP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRTPP" ("RT", "VERSION", "PP", "PP_VERSION", "PP_KEY1", "PP_KEY2", "PP_KEY3", "PP_KEY4", "PP_KEY5", "SEQ", "DELAY", "DELAY_UNIT", "FREQ_TP", "FREQ_VAL", "FREQ_UNIT", "INVERT_FREQ", "LAST_SCHED", "LAST_CNT", "LAST_VAL", "INHERIT_AU", "LAST_SCHED_TZ") AS 
  SELECT "RT","VERSION","PP","PP_VERSION","PP_KEY1","PP_KEY2","PP_KEY3","PP_KEY4","PP_KEY5","SEQ","DELAY","DELAY_UNIT","FREQ_TP","FREQ_VAL","FREQ_UNIT","INVERT_FREQ","LAST_SCHED","LAST_CNT","LAST_VAL","INHERIT_AU","LAST_SCHED_TZ"
FROM "UNILAB".utrtpp;
--------------------------------------------------------
--  DDL for View UVRTPPAU
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRTPPAU" ("RT", "VERSION", "PP", "PP_VERSION", "PP_KEY1", "PP_KEY2", "PP_KEY3", "PP_KEY4", "PP_KEY5", "AU", "AU_VERSION", "AUSEQ", "VALUE") AS 
  SELECT "RT","VERSION","PP","PP_VERSION","PP_KEY1","PP_KEY2","PP_KEY3","PP_KEY4","PP_KEY5","AU","AU_VERSION","AUSEQ","VALUE"
FROM "UNILAB".utrtppau;
--------------------------------------------------------
--  DDL for View UVRTST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRTST" ("RT", "VERSION", "ST", "ST_VERSION", "SEQ", "NR_PLANNED_SC", "DELAY", "DELAY_UNIT", "FREQ_TP", "FREQ_VAL", "FREQ_UNIT", "INVERT_FREQ", "LAST_SCHED", "LAST_CNT", "LAST_VAL", "INHERIT_AU", "LAST_SCHED_TZ") AS 
  SELECT "RT","VERSION","ST","ST_VERSION","SEQ","NR_PLANNED_SC","DELAY","DELAY_UNIT","FREQ_TP","FREQ_VAL","FREQ_UNIT","INVERT_FREQ","LAST_SCHED","LAST_CNT","LAST_VAL","INHERIT_AU","LAST_SCHED_TZ"
FROM "UNILAB".utrtst;
--------------------------------------------------------
--  DDL for View UVRTSTAU
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRTSTAU" ("RT", "VERSION", "ST", "ST_VERSION", "AU", "AU_VERSION", "AUSEQ", "VALUE") AS 
  SELECT "RT","VERSION","ST","ST_VERSION","AU","AU_VERSION","AUSEQ","VALUE"
FROM "UNILAB".utrtstau;
--------------------------------------------------------
--  DDL for View UVRTSTBUFFER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVRTSTBUFFER" ("RT", "VERSION", "ST", "ST_VERSION", "SEQ", "NR_PLANNED_SC", "DELAY", "DELAY_UNIT", "FREQ_TP", "FREQ_VAL", "FREQ_UNIT", "INVERT_FREQ", "LAST_SCHED", "LAST_SCHED_TZ", "LAST_CNT", "LAST_VAL", "INHERIT_AU", "HANDLED") AS 
  SELECT "RT","VERSION","ST","ST_VERSION","SEQ","NR_PLANNED_SC","DELAY","DELAY_UNIT","FREQ_TP","FREQ_VAL","FREQ_UNIT","INVERT_FREQ","LAST_SCHED","LAST_SCHED_TZ","LAST_CNT","LAST_VAL","INHERIT_AU","HANDLED"
   FROM "UNILAB".UTRTSTBUFFER;
--------------------------------------------------------
--  DDL for View UVSAPCODE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSAPCODE" ("SAP_CODE_GROUP", "SAP_CODE", "UL_DESCRIPTION") AS 
  SELECT "SAP_CODE_GROUP","SAP_CODE","UL_DESCRIPTION"
   FROM "UNILAB".utsapcode;
--------------------------------------------------------
--  DDL for View UVSAPCODEGROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSAPCODEGROUP" ("SAP_CODE_GROUP", "UL_DESCRIPTION") AS 
  SELECT "SAP_CODE_GROUP","UL_DESCRIPTION"
   FROM "UNILAB".utsapcodegroup;
--------------------------------------------------------
--  DDL for View UVSAPLOCATION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSAPLOCATION" ("SAP_LOCATION_CODE", "UL_LOCATION") AS 
  SELECT "SAP_LOCATION_CODE","UL_LOCATION"
   FROM "UNILAB".utsaplocation;
--------------------------------------------------------
--  DDL for View UVSAPMETHOD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSAPMETHOD" ("SAP_METHOD_CODE", "UL_METHOD") AS 
  SELECT "SAP_METHOD_CODE","UL_METHOD"
   FROM "UNILAB".utsapmethod;
--------------------------------------------------------
--  DDL for View UVSAPOPERATION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSAPOPERATION" ("SAP_OPERATION_NR", "UL_OPERATION") AS 
  SELECT "SAP_OPERATION_NR","UL_OPERATION"
   FROM "UNILAB".utsapoperation;
--------------------------------------------------------
--  DDL for View UVSAPPLANT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSAPPLANT" ("SAP_PLANT_CODE", "UL_PLANTNAME") AS 
  SELECT "SAP_PLANT_CODE","UL_PLANTNAME"
   FROM "UNILAB".utsapplant;
--------------------------------------------------------
--  DDL for View UVSAPUNIT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSAPUNIT" ("SAP_UNIT_CODE", "UL_UOM") AS 
  SELECT "SAP_UNIT_CODE","UL_UOM"
   FROM "UNILAB".utsapunit;
--------------------------------------------------------
--  DDL for View UVSC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSC" ("SC", "ST", "ST_VERSION", "DESCRIPTION", "SHELF_LIFE_VAL", "SHELF_LIFE_UNIT", "SAMPLING_DATE", "SAMPLING_DATE_TZ", "CREATION_DATE", "CREATION_DATE_TZ", "CREATED_BY", "EXEC_START_DATE", "EXEC_START_DATE_TZ", "EXEC_END_DATE", "EXEC_END_DATE_TZ", "PRIORITY", "LABEL_FORMAT", "DESCR_DOC", "DESCR_DOC_VERSION", "RQ", "SD", "DATE1", "DATE1_TZ", "DATE2", "DATE2_TZ", "DATE3", "DATE3_TZ", "DATE4", "DATE4_TZ", "DATE5", "DATE5_TZ", "ALLOW_ANY_PP", "LAST_COMMENT", "SC_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR") AS 
  SELECT
   sc,
   st,
   st_version,
   description,
   shelf_life_val,
   shelf_life_unit,
   sampling_date,
   sampling_date_tz,
   creation_date,
   creation_date_tz,
   created_by,
   exec_start_date,
   exec_start_date_tz,
   exec_end_date,
   exec_end_date_tz,
   priority,
   label_format,
   descr_doc,
   descr_doc_version,
   rq,
   sd,
   date1,
   date1_tz,
   date2,
   date2_tz,
   date3,
   date3_tz,
   date4,
   date4_tz,
   date5,
   date5_tz,
   allow_any_pp,
   last_comment,
   sc_class,
   log_hs,
   log_hs_details,
   allow_modify,
   active,
   lc,
   lc_version,
   ss,
 'W' ar
FROM "UNILAB".utsc;
--------------------------------------------------------
--  DDL for View UVSCAU
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCAU" ("SC", "AU", "AU_VERSION", "AUSEQ", "VALUE") AS 
  SELECT "SC","AU","AU_VERSION","AUSEQ","VALUE"
FROM "UNILAB".utscau;
--------------------------------------------------------
--  DDL for View UVSCGK
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCGK" ("SC", "GK", "GK_VERSION", "GKSEQ", "VALUE") AS 
  SELECT "SC","GK","GK_VERSION","GKSEQ","VALUE"
FROM "UNILAB".utscgk;
--------------------------------------------------------
--  DDL for View UVSCGKCERT_LOTNR
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCGKCERT_LOTNR" ("CERT_LOTNR", "SC") AS 
  SELECT "CERT_LOTNR","SC" FROM UTSCGKCert_lotnr;
--------------------------------------------------------
--  DDL for View UVSCGKCERTIFICATESEQ
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCGKCERTIFICATESEQ" ("CERTIFICATESEQ", "SC") AS 
  SELECT "CERTIFICATESEQ","SC" FROM UTSCGKCertificateSeq
 ;
--------------------------------------------------------
--  DDL for View UVSCGKCONTEXT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCGKCONTEXT" ("CONTEXT", "SC") AS 
  SELECT "CONTEXT","SC" FROM UTSCGKContext
 ;
--------------------------------------------------------
--  DDL for View UVSCGKDAY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCGKDAY" ("DAY", "SC") AS 
  SELECT "DAY","SC" FROM UTSCGKday
 ;
--------------------------------------------------------
--  DDL for View UVSCGKINTERVENTION4EQ
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCGKINTERVENTION4EQ" ("INTERVENTION4EQ", "SC") AS 
  SELECT "INTERVENTION4EQ","SC" FROM UTSCGKintervention4eq
 ;
--------------------------------------------------------
--  DDL for View UVSCGKINTERVENTION4LAB
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCGKINTERVENTION4LAB" ("INTERVENTION4LAB", "SC") AS 
  SELECT "INTERVENTION4LAB","SC" FROM UTSCGKintervention4lab
 ;
--------------------------------------------------------
--  DDL for View UVSCGKINTERVENTIONRULE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCGKINTERVENTIONRULE" ("INTERVENTIONRULE", "SC") AS 
  SELECT "INTERVENTIONRULE","SC" FROM UTSCGKinterventionrule
 ;
--------------------------------------------------------
--  DDL for View UVSCGKISTEST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCGKISTEST" ("ISTEST", "SC") AS 
  SELECT "ISTEST","SC" FROM UTSCGKisTest
 ;
--------------------------------------------------------
--  DDL for View UVSCGKKINDOFSAMPLE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCGKKINDOFSAMPLE" ("KINDOFSAMPLE", "SC") AS 
  SELECT "KINDOFSAMPLE","SC" FROM UTSCGKKindOfSample
 ;
--------------------------------------------------------
--  DDL for View UVSCGKMANUAL2AVAILABLE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCGKMANUAL2AVAILABLE" ("MANUAL2AVAILABLE", "SC") AS 
  SELECT "MANUAL2AVAILABLE","SC" FROM UTSCGKmanual2available
 ;
--------------------------------------------------------
--  DDL for View UVSCGKMONTH
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCGKMONTH" ("MONTH", "SC") AS 
  SELECT "MONTH","SC" FROM UTSCGKmonth
 ;
--------------------------------------------------------
--  DDL for View UVSCGKOUTSOURCED_TO
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCGKOUTSOURCED_TO" ("OUTSOURCED_TO", "SC") AS 
  SELECT "OUTSOURCED_TO","SC" FROM UTSCGKOutsourced_to;
--------------------------------------------------------
--  DDL for View UVSCGKPART_NO
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCGKPART_NO" ("PART_NO", "SC") AS 
  SELECT "PART_NO","SC" FROM UTSCGKPART_NO
 ;
--------------------------------------------------------
--  DDL for View UVSCGKPARTGROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCGKPARTGROUP" ("PARTGROUP", "SC") AS 
  SELECT "PARTGROUP","SC" FROM UTSCGKpartGroup
 ;
--------------------------------------------------------
--  DDL for View UVSCGKPARTNO_REINF
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCGKPARTNO_REINF" ("PARTNO_REINF", "SC") AS 
  SELECT "PARTNO_REINF","SC" FROM UTSCGKPARTNO_REINF;
--------------------------------------------------------
--  DDL for View UVSCGKPRODUCT_LINE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCGKPRODUCT_LINE" ("PRODUCT_LINE", "SC") AS 
  SELECT "PRODUCT_LINE","SC" FROM UTSCGKProduct_line
 ;
--------------------------------------------------------
--  DDL for View UVSCGKPRODUCT_RANGE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCGKPRODUCT_RANGE" ("PRODUCT_RANGE", "SC") AS 
  SELECT "PRODUCT_RANGE","SC" FROM UTSCGKProduct_range
 ;
--------------------------------------------------------
--  DDL for View UVSCGKPROJECT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCGKPROJECT" ("PROJECT", "SC") AS 
  SELECT "PROJECT","SC" FROM UTSCGKProject
 ;
--------------------------------------------------------
--  DDL for View UVSCGKRAWDATASC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCGKRAWDATASC" ("RAWDATASC", "SC") AS 
  SELECT "RAWDATASC","SC" FROM UTSCGKrawDataSc
 ;
--------------------------------------------------------
--  DDL for View UVSCGKRECALLNO
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCGKRECALLNO" ("RECALLNO", "SC") AS 
  SELECT "RECALLNO","SC" FROM UTSCGKRecallNo
 ;
--------------------------------------------------------
--  DDL for View UVSCGKREQUESTCODE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCGKREQUESTCODE" ("REQUESTCODE", "SC") AS 
  SELECT "REQUESTCODE","SC" FROM UTSCGKRequestCode
 ;
--------------------------------------------------------
--  DDL for View UVSCGKRIMCODE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCGKRIMCODE" ("RIMCODE", "SC") AS 
  SELECT "RIMCODE","SC" FROM UTSCGKRimCode
 ;
--------------------------------------------------------
--  DDL for View UVSCGKRQSTATUS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCGKRQSTATUS" ("RQSTATUS", "SC") AS 
  SELECT "RQSTATUS","SC" FROM UTSCGKrqStatus
 ;
--------------------------------------------------------
--  DDL for View UVSCGKRQSTATUSTYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCGKRQSTATUSTYPE" ("RQSTATUSTYPE", "SC") AS 
  SELECT "RQSTATUSTYPE","SC" FROM UTSCGKrqStatusType
 ;
--------------------------------------------------------
--  DDL for View UVSCGKRTSTSEQUENCE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCGKRTSTSEQUENCE" ("RTSTSEQUENCE", "SC") AS 
  SELECT "RTSTSEQUENCE","SC" FROM UTSCGKRtStSequence
 ;
--------------------------------------------------------
--  DDL for View UVSCGKSAMPLINGPOINT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCGKSAMPLINGPOINT" ("SAMPLINGPOINT", "SC") AS 
  SELECT "SAMPLINGPOINT","SC" FROM UTSCGKSamplingPoint
 ;
--------------------------------------------------------
--  DDL for View UVSCGKSCCREATEUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCGKSCCREATEUP" ("SCCREATEUP", "SC") AS 
  SELECT "SCCREATEUP","SC" FROM UTSCGKscCreateUp
 ;
--------------------------------------------------------
--  DDL for View UVSCGKSCLISTUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCGKSCLISTUP" ("SCLISTUP", "SC") AS 
  SELECT "SCLISTUP","SC" FROM UTSCGKscListUp
 ;
--------------------------------------------------------
--  DDL for View UVSCGKSCRECEIVERUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCGKSCRECEIVERUP" ("SCRECEIVERUP", "SC") AS 
  SELECT "SCRECEIVERUP","SC" FROM UTSCGKscReceiverUp
 ;
--------------------------------------------------------
--  DDL for View UVSCGKSI
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCGKSI" ("SI", "SC") AS 
  SELECT "SI","SC" FROM UTSCGKSI
 ;
--------------------------------------------------------
--  DDL for View UVSCGKSITE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCGKSITE" ("SITE", "SC") AS 
  SELECT "SITE","SC" FROM UTSCGKSite;
--------------------------------------------------------
--  DDL for View UVSCGKSPEC_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCGKSPEC_TYPE" ("SPEC_TYPE", "SC") AS 
  SELECT "SPEC_TYPE","SC" FROM UTSCGKSPEC_TYPE
 ;
--------------------------------------------------------
--  DDL for View UVSCGKUNSAP_WL_PLFNL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCGKUNSAP_WL_PLFNL" ("UNSAP_WL_PLFNL", "SC") AS 
  SELECT "UNSAP_WL_PLFNL","SC" FROM UTSCGKunsap_wl_plfnl
 ;
--------------------------------------------------------
--  DDL for View UVSCGKUNSDLO
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCGKUNSDLO" ("UNSDLO", "SC") AS 
  SELECT "UNSDLO","SC" FROM UTSCGKunsdlo
 ;
--------------------------------------------------------
--  DDL for View UVSCGKUNSDPULLABLE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCGKUNSDPULLABLE" ("UNSDPULLABLE", "SC") AS 
  SELECT "UNSDPULLABLE","SC" FROM UTSCGKunsdpullable
 ;
--------------------------------------------------------
--  DDL for View UVSCGKUNSDPULLINGDAY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCGKUNSDPULLINGDAY" ("UNSDPULLINGDAY", "SC") AS 
  SELECT "UNSDPULLINGDAY","SC" FROM UTSCGKunsdpullingday
 ;
--------------------------------------------------------
--  DDL for View UVSCGKUNSDPUSHABLE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCGKUNSDPUSHABLE" ("UNSDPUSHABLE", "SC") AS 
  SELECT "UNSDPUSHABLE","SC" FROM UTSCGKunsdpushable
 ;
--------------------------------------------------------
--  DDL for View UVSCGKUNSDTP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCGKUNSDTP" ("UNSDTP", "SC") AS 
  SELECT "UNSDTP","SC" FROM UTSCGKunsdtp
 ;
--------------------------------------------------------
--  DDL for View UVSCGKUNSDTPSTATUS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCGKUNSDTPSTATUS" ("UNSDTPSTATUS", "SC") AS 
  SELECT "UNSDTPSTATUS","SC" FROM UTSCGKunsdtpstatus
 ;
--------------------------------------------------------
--  DDL for View UVSCGKVARIANTSC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCGKVARIANTSC" ("VARIANTSC", "SC") AS 
  SELECT "VARIANTSC","SC" FROM UTSCGKvariantSc
 ;
--------------------------------------------------------
--  DDL for View UVSCGKWEEK
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCGKWEEK" ("WEEK", "SC") AS 
  SELECT "WEEK","SC" FROM UTSCGKweek
 ;
--------------------------------------------------------
--  DDL for View UVSCGKWORKORDER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCGKWORKORDER" ("WORKORDER", "SC") AS 
  SELECT "WORKORDER","SC" FROM UTSCGKWorkorder;
--------------------------------------------------------
--  DDL for View UVSCGKYEAR
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCGKYEAR" ("YEAR", "SC") AS 
  SELECT "YEAR","SC" FROM UTSCGKyear
 ;
--------------------------------------------------------
--  DDL for View UVSCHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCHS" ("SC", "WHO", "WHO_DESCRIPTION", "WHAT", "WHAT_DESCRIPTION", "LOGDATE", "WHY", "TR_SEQ", "EV_SEQ", "LOGDATE_TZ") AS 
  SELECT "SC","WHO","WHO_DESCRIPTION","WHAT","WHAT_DESCRIPTION","LOGDATE","WHY","TR_SEQ","EV_SEQ","LOGDATE_TZ"
FROM "UNILAB".utschs;
--------------------------------------------------------
--  DDL for View UVSCHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCHSDETAILS" ("SC", "TR_SEQ", "EV_SEQ", "SEQ", "DETAILS") AS 
  SELECT "SC","TR_SEQ","EV_SEQ","SEQ","DETAILS"
FROM "UNILAB".utschsdetails;
--------------------------------------------------------
--  DDL for View UVSCIC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCIC" ("SC", "IC", "ICNODE", "IP_VERSION", "DESCRIPTION", "WINSIZE_X", "WINSIZE_Y", "IS_PROTECTED", "HIDDEN", "MANUALLY_ADDED", "NEXT_II", "LAST_COMMENT", "IC_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR") AS 
  SELECT
   sc,
   ic,
   icnode,
   ip_version,
   description,
   winsize_x,
   winsize_y,
   is_protected,
   hidden,
   manually_added,
   next_ii,
   last_comment,
   ic_class,
   log_hs,
   log_hs_details,
   allow_modify,
   active,
   lc,
   lc_version,
   ss,
 'W' ar
FROM "UNILAB".utscic;
--------------------------------------------------------
--  DDL for View UVSCICAU
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCICAU" ("SC", "IC", "ICNODE", "AU", "AU_VERSION", "AUSEQ", "VALUE") AS 
  SELECT "SC","IC","ICNODE","AU","AU_VERSION","AUSEQ","VALUE"
FROM "UNILAB".utscicau;
--------------------------------------------------------
--  DDL for View UVSCICHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCICHS" ("SC", "IC", "ICNODE", "WHO", "WHO_DESCRIPTION", "WHAT", "WHAT_DESCRIPTION", "LOGDATE", "WHY", "TR_SEQ", "EV_SEQ", "LOGDATE_TZ") AS 
  SELECT "SC","IC","ICNODE","WHO","WHO_DESCRIPTION","WHAT","WHAT_DESCRIPTION","LOGDATE","WHY","TR_SEQ","EV_SEQ","LOGDATE_TZ"
FROM "UNILAB".utscichs;
--------------------------------------------------------
--  DDL for View UVSCICHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCICHSDETAILS" ("SC", "IC", "ICNODE", "TR_SEQ", "EV_SEQ", "SEQ", "DETAILS") AS 
  SELECT "SC","IC","ICNODE","TR_SEQ","EV_SEQ","SEQ","DETAILS"
FROM "UNILAB".utscichsdetails;
--------------------------------------------------------
--  DDL for View UVSCII
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCII" ("SC", "IC", "ICNODE", "II", "IINODE", "IE_VERSION", "IIVALUE", "POS_X", "POS_Y", "IS_PROTECTED", "MANDATORY", "HIDDEN", "DSP_TITLE", "DSP_LEN", "DSP_TP", "DSP_ROWS", "II_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR") AS 
  SELECT
   sc,
   ic,
   icnode,
   ii,
   iinode,
   ie_version,
   iivalue,
   pos_x,
   pos_y,
   is_protected,
   mandatory,
   hidden,
   dsp_title,
   dsp_len,
   dsp_tp,
   dsp_rows,
   ii_class,
   log_hs,
   log_hs_details,
   allow_modify,
   active,
   lc,
   lc_version,
   ss,
 'W' ar
FROM "UNILAB".utscii;
--------------------------------------------------------
--  DDL for View UVSCME
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCME" ("SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE", "MT_VERSION", "DESCRIPTION", "VALUE_F", "VALUE_S", "UNIT", "EXEC_START_DATE", "EXEC_START_DATE_TZ", "EXEC_END_DATE", "EXEC_END_DATE_TZ", "EXECUTOR", "LAB", "EQ", "EQ_VERSION", "PLANNED_EXECUTOR", "PLANNED_EQ", "PLANNED_EQ_VERSION", "MANUALLY_ENTERED", "ALLOW_ADD", "ASSIGN_DATE", "ASSIGN_DATE_TZ", "ASSIGNED_BY", "MANUALLY_ADDED", "DELAY", "DELAY_UNIT", "FORMAT", "ACCURACY", "REAL_COST", "REAL_TIME", "CALIBRATION", "CONFIRM_COMPLETE", "AUTORECALC", "ME_RESULT_EDITABLE", "NEXT_CELL", "SOP", "SOP_VERSION", "PLAUS_LOW", "PLAUS_HIGH", "WINSIZE_X", "WINSIZE_Y", "REANALYSIS", "LAST_COMMENT", "ME_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR") AS 
  SELECT
   sc,
   pg,
   pgnode,
   pa,
   panode,
   me,
   menode,
   mt_version,
   description,
   value_f,
   value_s,
   unit,
   exec_start_date,
   exec_start_date_tz,
   exec_end_date,
   exec_end_date_tz,
   executor,
   lab,
   eq,
   eq_version,
   planned_executor,
   planned_eq,
   planned_eq_version,
   manually_entered,
   allow_add,
   assign_date,
   assign_date_tz,
   assigned_by,
   manually_added,
   delay,
   delay_unit,
   format,
   accuracy,
   real_cost,
   real_time,
   calibration,
   confirm_complete,
   autorecalc,
   me_result_editable,
   next_cell,
   sop,
   sop_version,
   plaus_low,
   plaus_high,
   winsize_x,
   winsize_y,
   reanalysis,
   last_comment,
   me_class,
   log_hs,
   log_hs_details,
   allow_modify,
   active,
   lc,
   lc_version,
   ss,
 'W' ar
FROM "UNILAB".utscme;
--------------------------------------------------------
--  DDL for View UVSCMEAU
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCMEAU" ("SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE", "AU", "AU_VERSION", "AUSEQ", "VALUE") AS 
  SELECT "SC","PG","PGNODE","PA","PANODE","ME","MENODE","AU","AU_VERSION","AUSEQ","VALUE"
FROM "UNILAB".utscmeau;
--------------------------------------------------------
--  DDL for View UVSCMECELL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCMECELL" ("SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE", "REANALYSIS", "CELL", "CELLNODE", "DSP_TITLE", "VALUE_F", "VALUE_S", "CELL_TP", "POS_X", "POS_Y", "ALIGN", "WINSIZE_X", "WINSIZE_Y", "IS_PROTECTED", "MANDATORY", "HIDDEN", "UNIT", "FORMAT", "EQ", "EQ_VERSION", "COMPONENT", "CALC_TP", "CALC_FORMULA", "VALID_CF", "MAX_X", "MAX_Y", "MULTI_SELECT") AS 
  SELECT "SC","PG","PGNODE","PA","PANODE","ME","MENODE","REANALYSIS","CELL","CELLNODE","DSP_TITLE","VALUE_F","VALUE_S","CELL_TP","POS_X","POS_Y","ALIGN","WINSIZE_X","WINSIZE_Y","IS_PROTECTED","MANDATORY","HIDDEN","UNIT","FORMAT","EQ","EQ_VERSION","COMPONENT","CALC_TP","CALC_FORMULA","VALID_CF","MAX_X","MAX_Y","MULTI_SELECT"
FROM "UNILAB".utscmecell;
--------------------------------------------------------
--  DDL for View UVSCMECELLINPUT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCMECELLINPUT" ("SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE", "REANALYSIS", "CELL", "INPUT_TP", "INPUT_SOURCE", "INPUT_VERSION", "INPUT_PG", "INPUT_PGNODE", "INPUT_PP_VERSION", "INPUT_PA", "INPUT_PANODE", "INPUT_PR_VERSION", "INPUT_ME", "INPUT_MENODE", "INPUT_MT_VERSION", "INPUT_REANALYSIS") AS 
  SELECT "SC","PG","PGNODE","PA","PANODE","ME","MENODE","REANALYSIS","CELL","INPUT_TP","INPUT_SOURCE","INPUT_VERSION","INPUT_PG","INPUT_PGNODE","INPUT_PP_VERSION","INPUT_PA","INPUT_PANODE","INPUT_PR_VERSION","INPUT_ME","INPUT_MENODE","INPUT_MT_VERSION","INPUT_REANALYSIS"
FROM "UNILAB".utscmecellinput;
--------------------------------------------------------
--  DDL for View UVSCMECELLLIST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCMECELLLIST" ("SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE", "REANALYSIS", "CELL", "INDEX_X", "INDEX_Y", "VALUE_F", "VALUE_S", "SELECTED") AS 
  SELECT "SC","PG","PGNODE","PA","PANODE","ME","MENODE","REANALYSIS","CELL","INDEX_X","INDEX_Y","VALUE_F","VALUE_S","SELECTED"
FROM "UNILAB".utscmecelllist;
--------------------------------------------------------
--  DDL for View UVSCMECELLLISTOUTPUT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCMECELLLISTOUTPUT" ("SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE", "REANALYSIS", "CELL", "INDEX_Y", "SAVE_TP", "SAVE_PG", "SAVE_PGNODE", "SAVE_PP_VERSION", "SAVE_PA", "SAVE_PANODE", "SAVE_PR_VERSION", "SAVE_ME", "SAVE_MENODE", "SAVE_MT_VERSION", "SAVE_EQ", "SAVE_EQ_VERSION", "SAVE_ID", "SAVE_IDNODE", "SAVE_REANALYSIS", "CREATE_NEW") AS 
  SELECT "SC","PG","PGNODE","PA","PANODE","ME","MENODE","REANALYSIS","CELL","INDEX_Y","SAVE_TP","SAVE_PG","SAVE_PGNODE","SAVE_PP_VERSION","SAVE_PA","SAVE_PANODE","SAVE_PR_VERSION","SAVE_ME","SAVE_MENODE","SAVE_MT_VERSION","SAVE_EQ","SAVE_EQ_VERSION","SAVE_ID","SAVE_IDNODE","SAVE_REANALYSIS","CREATE_NEW"
FROM "UNILAB".utscmecelllistoutput;
--------------------------------------------------------
--  DDL for View UVSCMECELLOUTPUT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCMECELLOUTPUT" ("SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE", "REANALYSIS", "CELL", "SAVE_TP", "SAVE_PG", "SAVE_PGNODE", "SAVE_PP_VERSION", "SAVE_PA", "SAVE_PANODE", "SAVE_PR_VERSION", "SAVE_ME", "SAVE_MENODE", "SAVE_MT_VERSION", "SAVE_EQ", "SAVE_EQ_VERSION", "SAVE_ID", "SAVE_IDNODE", "SAVE_REANALYSIS", "CREATE_NEW") AS 
  SELECT "SC","PG","PGNODE","PA","PANODE","ME","MENODE","REANALYSIS","CELL","SAVE_TP","SAVE_PG","SAVE_PGNODE","SAVE_PP_VERSION","SAVE_PA","SAVE_PANODE","SAVE_PR_VERSION","SAVE_ME","SAVE_MENODE","SAVE_MT_VERSION","SAVE_EQ","SAVE_EQ_VERSION","SAVE_ID","SAVE_IDNODE","SAVE_REANALYSIS","CREATE_NEW"
FROM "UNILAB".utscmecelloutput;
--------------------------------------------------------
--  DDL for View UVSCMEGK
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCMEGK" ("SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE", "GK", "GK_VERSION", "GKSEQ", "VALUE") AS 
  SELECT "SC","PG","PGNODE","PA","PANODE","ME","MENODE","GK","GK_VERSION","GKSEQ","VALUE"
FROM "UNILAB".utscmegk;
--------------------------------------------------------
--  DDL for View UVSCMEGKAVTESTMETHOD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCMEGKAVTESTMETHOD" ("AVTESTMETHOD", "SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE") AS 
  SELECT "AVTESTMETHOD","SC","PG","PGNODE","PA","PANODE","ME","MENODE" FROM UTSCMEGKavTestMethod
 ;
--------------------------------------------------------
--  DDL for View UVSCMEGKAVTESTMETHODDESC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCMEGKAVTESTMETHODDESC" ("AVTESTMETHODDESC", "SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE") AS 
  SELECT "AVTESTMETHODDESC","SC","PG","PGNODE","PA","PANODE","ME","MENODE" FROM UTSCMEGKavTestMethodDesc
 ;
--------------------------------------------------------
--  DDL for View UVSCMEGKAVTESTSET
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCMEGKAVTESTSET" ("AVTESTSET", "SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE") AS 
  SELECT "AVTESTSET","SC","PG","PGNODE","PA","PANODE","ME","MENODE" FROM UTSCMEGKavTestSet
 ;
--------------------------------------------------------
--  DDL for View UVSCMEGKDAY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCMEGKDAY" ("DAY", "SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE") AS 
  SELECT "DAY","SC","PG","PGNODE","PA","PANODE","ME","MENODE" FROM UTSCMEGKday
 ;
--------------------------------------------------------
--  DDL for View UVSCMEGKEQUIPEMENT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCMEGKEQUIPEMENT" ("EQUIPEMENT", "SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE") AS 
  SELECT "EQUIPEMENT","SC","PG","PGNODE","PA","PANODE","ME","MENODE" FROM UTSCMEGKEquipement
 ;
--------------------------------------------------------
--  DDL for View UVSCMEGKEQUIPMENT_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCMEGKEQUIPMENT_TYPE" ("EQUIPMENT_TYPE", "SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE") AS 
  SELECT "EQUIPMENT_TYPE","SC","PG","PGNODE","PA","PANODE","ME","MENODE" FROM UTSCMEGKEquipment_type;
--------------------------------------------------------
--  DDL for View UVSCMEGKEXECUTING_UP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCMEGKEXECUTING_UP" ("EXECUTING_UP", "SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE") AS 
  SELECT "EXECUTING_UP","SC","PG","PGNODE","PA","PANODE","ME","MENODE" FROM UTSCMEGKExecuting_up;
--------------------------------------------------------
--  DDL for View UVSCMEGKIMPORTID
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCMEGKIMPORTID" ("IMPORTID", "SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE") AS 
  SELECT "IMPORTID","SC","PG","PGNODE","PA","PANODE","ME","MENODE" FROM UTSCMEGKImportId
 ;
--------------------------------------------------------
--  DDL for View UVSCMEGKKINDOFSAMPLE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCMEGKKINDOFSAMPLE" ("KINDOFSAMPLE", "SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE") AS 
  SELECT "KINDOFSAMPLE","SC","PG","PGNODE","PA","PANODE","ME","MENODE" FROM UTSCMEGKKindOfSample
 ;
--------------------------------------------------------
--  DDL for View UVSCMEGKLAB
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCMEGKLAB" ("LAB", "SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE") AS 
  SELECT "LAB","SC","PG","PGNODE","PA","PANODE","ME","MENODE" FROM UTSCMEGKLab
 ;
--------------------------------------------------------
--  DDL for View UVSCMEGKME_IS_RELEVANT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCMEGKME_IS_RELEVANT" ("ME_IS_RELEVANT", "SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE") AS 
  SELECT "ME_IS_RELEVANT","SC","PG","PGNODE","PA","PANODE","ME","MENODE" FROM UTSCMEGKME_IS_RELEVANT
 ;
--------------------------------------------------------
--  DDL for View UVSCMEGKMESEQ
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCMEGKMESEQ" ("MESEQ", "SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE") AS 
  SELECT "MESEQ","SC","PG","PGNODE","PA","PANODE","ME","MENODE" FROM UTSCMEGKMeSeq;
--------------------------------------------------------
--  DDL for View UVSCMEGKMONTH
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCMEGKMONTH" ("MONTH", "SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE") AS 
  SELECT "MONTH","SC","PG","PGNODE","PA","PANODE","ME","MENODE" FROM UTSCMEGKmonth
 ;
--------------------------------------------------------
--  DDL for View UVSCMEGKMTPROGRESS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCMEGKMTPROGRESS" ("MTPROGRESS", "SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE") AS 
  SELECT "MTPROGRESS","SC","PG","PGNODE","PA","PANODE","ME","MENODE" FROM UTSCMEGKmtProgress
 ;
--------------------------------------------------------
--  DDL for View UVSCMEGKPART_NO
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCMEGKPART_NO" ("PART_NO", "SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE") AS 
  SELECT "PART_NO","SC","PG","PGNODE","PA","PANODE","ME","MENODE" FROM UTSCMEGKPART_NO
 ;
--------------------------------------------------------
--  DDL for View UVSCMEGKREQUESTCODE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCMEGKREQUESTCODE" ("REQUESTCODE", "SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE") AS 
  SELECT "REQUESTCODE","SC","PG","PGNODE","PA","PANODE","ME","MENODE" FROM UTSCMEGKRequestCode
 ;
--------------------------------------------------------
--  DDL for View UVSCMEGKSCDATE1
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCMEGKSCDATE1" ("SCDATE1", "SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE") AS 
  SELECT "SCDATE1","SC","PG","PGNODE","PA","PANODE","ME","MENODE" FROM UTSCMEGKscDate1;
--------------------------------------------------------
--  DDL for View UVSCMEGKSCDATE2
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCMEGKSCDATE2" ("SCDATE2", "SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE") AS 
  SELECT "SCDATE2","SC","PG","PGNODE","PA","PANODE","ME","MENODE" FROM UTSCMEGKscDate2;
--------------------------------------------------------
--  DDL for View UVSCMEGKSCDATE3
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCMEGKSCDATE3" ("SCDATE3", "SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE") AS 
  SELECT "SCDATE3","SC","PG","PGNODE","PA","PANODE","ME","MENODE" FROM UTSCMEGKscDate3;
--------------------------------------------------------
--  DDL for View UVSCMEGKSCDATE4
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCMEGKSCDATE4" ("SCDATE4", "SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE") AS 
  SELECT "SCDATE4","SC","PG","PGNODE","PA","PANODE","ME","MENODE" FROM UTSCMEGKscDate4;
--------------------------------------------------------
--  DDL for View UVSCMEGKSCDATE5
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCMEGKSCDATE5" ("SCDATE5", "SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE") AS 
  SELECT "SCDATE5","SC","PG","PGNODE","PA","PANODE","ME","MENODE" FROM UTSCMEGKscDate5;
--------------------------------------------------------
--  DDL for View UVSCMEGKSCPRIORITY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCMEGKSCPRIORITY" ("SCPRIORITY", "SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE") AS 
  SELECT "SCPRIORITY","SC","PG","PGNODE","PA","PANODE","ME","MENODE" FROM UTSCMEGKscPriority;
--------------------------------------------------------
--  DDL for View UVSCMEGKTM_POSITION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCMEGKTM_POSITION" ("TM_POSITION", "SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE") AS 
  SELECT "TM_POSITION","SC","PG","PGNODE","PA","PANODE","ME","MENODE" FROM UTSCMEGKTM_position
 ;
--------------------------------------------------------
--  DDL for View UVSCMEGKUSER_GROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCMEGKUSER_GROUP" ("USER_GROUP", "SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE") AS 
  SELECT "USER_GROUP","SC","PG","PGNODE","PA","PANODE","ME","MENODE" FROM UTSCMEGKuser_group;
--------------------------------------------------------
--  DDL for View UVSCMEGKWEEK
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCMEGKWEEK" ("WEEK", "SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE") AS 
  SELECT "WEEK","SC","PG","PGNODE","PA","PANODE","ME","MENODE" FROM UTSCMEGKweek
 ;
--------------------------------------------------------
--  DDL for View UVSCMEGKWORKSHEETS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCMEGKWORKSHEETS" ("WORKSHEETS", "SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE") AS 
  SELECT "WORKSHEETS","SC","PG","PGNODE","PA","PANODE","ME","MENODE" FROM UTSCMEGKworksheets
 ;
--------------------------------------------------------
--  DDL for View UVSCMEGKYEAR
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCMEGKYEAR" ("YEAR", "SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE") AS 
  SELECT "YEAR","SC","PG","PGNODE","PA","PANODE","ME","MENODE" FROM UTSCMEGKyear
 ;
--------------------------------------------------------
--  DDL for View UVSCMEHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCMEHS" ("SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE", "WHO", "WHO_DESCRIPTION", "WHAT", "WHAT_DESCRIPTION", "LOGDATE", "WHY", "TR_SEQ", "EV_SEQ", "LOGDATE_TZ") AS 
  SELECT "SC","PG","PGNODE","PA","PANODE","ME","MENODE","WHO","WHO_DESCRIPTION","WHAT","WHAT_DESCRIPTION","LOGDATE","WHY","TR_SEQ","EV_SEQ","LOGDATE_TZ"
FROM "UNILAB".utscmehs;
--------------------------------------------------------
--  DDL for View UVSCMEHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCMEHSDETAILS" ("SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE", "TR_SEQ", "EV_SEQ", "SEQ", "DETAILS") AS 
  SELECT "SC","PG","PGNODE","PA","PANODE","ME","MENODE","TR_SEQ","EV_SEQ","SEQ","DETAILS"
FROM "UNILAB".utscmehsdetails;
--------------------------------------------------------
--  DDL for View UVSCPA
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCPA" ("SC", "PG", "PGNODE", "PA", "PANODE", "PR_VERSION", "DESCRIPTION", "VALUE_F", "VALUE_S", "UNIT", "EXEC_START_DATE", "EXEC_START_DATE_TZ", "EXEC_END_DATE", "EXEC_END_DATE_TZ", "EXECUTOR", "PLANNED_EXECUTOR", "MANUALLY_ENTERED", "ASSIGN_DATE", "ASSIGN_DATE_TZ", "ASSIGNED_BY", "MANUALLY_ADDED", "FORMAT", "TD_INFO", "TD_INFO_UNIT", "CONFIRM_UID", "ALLOW_ANY_ME", "DELAY", "DELAY_UNIT", "MIN_NR_RESULTS", "CALC_METHOD", "CALC_CF", "ALARM_ORDER", "VALID_SPECSA", "VALID_SPECSB", "VALID_SPECSC", "VALID_LIMITSA", "VALID_LIMITSB", "VALID_LIMITSC", "VALID_TARGETA", "VALID_TARGETB", "VALID_TARGETC", "LOG_EXCEPTIONS", "REANALYSIS", "LAST_COMMENT", "PA_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR") AS 
  SELECT
   sc,
   pg,
   pgnode,
   pa,
   panode,
   pr_version,
   description,
   value_f,
   value_s,
   unit,
   exec_start_date,
   exec_start_date_tz,
   exec_end_date,
   exec_end_date_tz,
   executor,
   planned_executor,
   manually_entered,
   assign_date,
   assign_date_tz,
   assigned_by,
   manually_added,
   format,
   td_info,
   td_info_unit,
   confirm_uid,
   allow_any_me,
   delay,
   delay_unit,
   min_nr_results,
   calc_method,
   calc_cf,
   alarm_order,
   valid_specsa,
   valid_specsb,
   valid_specsc,
   valid_limitsa,
   valid_limitsb,
   valid_limitsc,
   valid_targeta,
   valid_targetb,
   valid_targetc,
   log_exceptions,
   reanalysis,
   last_comment,
   pa_class,
   log_hs,
   log_hs_details,
   allow_modify,
   active,
   lc,
   lc_version,
   ss,
 'W' ar
FROM "UNILAB".utscpa;
--------------------------------------------------------
--  DDL for View UVSCPAAU
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCPAAU" ("SC", "PG", "PGNODE", "PA", "PANODE", "AU", "AU_VERSION", "AUSEQ", "VALUE") AS 
  SELECT "SC","PG","PGNODE","PA","PANODE","AU","AU_VERSION","AUSEQ","VALUE"
FROM "UNILAB".utscpaau;
--------------------------------------------------------
--  DDL for View UVSCPAHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCPAHS" ("SC", "PG", "PGNODE", "PA", "PANODE", "WHO", "WHO_DESCRIPTION", "WHAT", "WHAT_DESCRIPTION", "LOGDATE", "WHY", "TR_SEQ", "EV_SEQ", "LOGDATE_TZ") AS 
  SELECT "SC","PG","PGNODE","PA","PANODE","WHO","WHO_DESCRIPTION","WHAT","WHAT_DESCRIPTION","LOGDATE","WHY","TR_SEQ","EV_SEQ","LOGDATE_TZ"
FROM "UNILAB".utscpahs;
--------------------------------------------------------
--  DDL for View UVSCPAHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCPAHSDETAILS" ("SC", "PG", "PGNODE", "PA", "PANODE", "TR_SEQ", "EV_SEQ", "SEQ", "DETAILS") AS 
  SELECT "SC","PG","PGNODE","PA","PANODE","TR_SEQ","EV_SEQ","SEQ","DETAILS"
FROM "UNILAB".utscpahsdetails;
--------------------------------------------------------
--  DDL for View UVSCPAOUTPUT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCPAOUTPUT" ("SC", "PG", "PGNODE", "PA", "PANODE", "SAVE_PG", "SAVE_PGNODE", "SAVE_PA", "SAVE_PANODE") AS 
  SELECT "SC","PG","PGNODE","PA","PANODE","SAVE_PG","SAVE_PGNODE","SAVE_PA","SAVE_PANODE"
FROM "UNILAB".utscpaoutput;
--------------------------------------------------------
--  DDL for View UVSCPASPA
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCPASPA" ("SC", "PG", "PGNODE", "PA", "PANODE", "LOW_LIMIT", "HIGH_LIMIT", "LOW_SPEC", "HIGH_SPEC", "LOW_DEV", "REL_LOW_DEV", "TARGET", "HIGH_DEV", "REL_HIGH_DEV") AS 
  SELECT "SC","PG","PGNODE","PA","PANODE","LOW_LIMIT","HIGH_LIMIT","LOW_SPEC","HIGH_SPEC","LOW_DEV","REL_LOW_DEV","TARGET","HIGH_DEV","REL_HIGH_DEV"
FROM "UNILAB".utscpaspa;
--------------------------------------------------------
--  DDL for View UVSCPASPB
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCPASPB" ("SC", "PG", "PGNODE", "PA", "PANODE", "LOW_LIMIT", "HIGH_LIMIT", "LOW_SPEC", "HIGH_SPEC", "LOW_DEV", "REL_LOW_DEV", "TARGET", "HIGH_DEV", "REL_HIGH_DEV") AS 
  SELECT "SC","PG","PGNODE","PA","PANODE","LOW_LIMIT","HIGH_LIMIT","LOW_SPEC","HIGH_SPEC","LOW_DEV","REL_LOW_DEV","TARGET","HIGH_DEV","REL_HIGH_DEV"
FROM "UNILAB".utscpaspb;
--------------------------------------------------------
--  DDL for View UVSCPASPC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCPASPC" ("SC", "PG", "PGNODE", "PA", "PANODE", "LOW_LIMIT", "HIGH_LIMIT", "LOW_SPEC", "HIGH_SPEC", "LOW_DEV", "REL_LOW_DEV", "TARGET", "HIGH_DEV", "REL_HIGH_DEV") AS 
  SELECT "SC","PG","PGNODE","PA","PANODE","LOW_LIMIT","HIGH_LIMIT","LOW_SPEC","HIGH_SPEC","LOW_DEV","REL_LOW_DEV","TARGET","HIGH_DEV","REL_HIGH_DEV"
FROM "UNILAB".utscpaspc;
--------------------------------------------------------
--  DDL for View UVSCPASQC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCPASQC" ("SC", "PG", "PGNODE", "PA", "PANODE", "SQC_AVG", "SQC_SIGMA", "SQC_AVGR", "SQC_UCLR", "VALID_SQC") AS 
  SELECT "SC","PG","PGNODE","PA","PANODE","SQC_AVG","SQC_SIGMA","SQC_AVGR","SQC_UCLR","VALID_SQC"
FROM "UNILAB".utscpasqc;
--------------------------------------------------------
--  DDL for View UVSCPATD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCPATD" ("SC", "PG", "PGNODE", "PA", "PANODE", "REANALYSIS", "ST", "ST_VERSION", "EXEC_END_DATE", "VALUE_F", "VALUE_S", "EXEC_END_DATE_TZ") AS 
  SELECT "SC","PG","PGNODE","PA","PANODE","REANALYSIS","ST","ST_VERSION","EXEC_END_DATE","VALUE_F","VALUE_S","EXEC_END_DATE_TZ"
FROM "UNILAB".utscpatd;
--------------------------------------------------------
--  DDL for View UVSCPG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCPG" ("SC", "PG", "PGNODE", "PP_VERSION", "PP_KEY1", "PP_KEY2", "PP_KEY3", "PP_KEY4", "PP_KEY5", "DESCRIPTION", "VALUE_F", "VALUE_S", "UNIT", "EXEC_START_DATE", "EXEC_START_DATE_TZ", "EXEC_END_DATE", "EXEC_END_DATE_TZ", "EXECUTOR", "PLANNED_EXECUTOR", "MANUALLY_ENTERED", "ASSIGN_DATE", "ASSIGN_DATE_TZ", "ASSIGNED_BY", "MANUALLY_ADDED", "FORMAT", "CONFIRM_ASSIGN", "ALLOW_ANY_PR", "NEVER_CREATE_METHODS", "DELAY", "DELAY_UNIT", "REANALYSIS", "LAST_COMMENT", "PG_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR") AS 
  SELECT
   sc,
   pg,
   pgnode,
   pp_version,
   pp_key1,
   pp_key2,
   pp_key3,
   pp_key4,
   pp_key5,
   description,
   value_f,
   value_s,
   unit,
   exec_start_date,
   exec_start_date_tz,
   exec_end_date,
   exec_end_date_tz,
   executor,
   planned_executor,
   manually_entered,
   assign_date,
   assign_date_tz,
   assigned_by,
   manually_added,
   format,
   confirm_assign,
   allow_any_pr,
   never_create_methods,
   delay,
   delay_unit,
   reanalysis,
   last_comment,
   pg_class,
   log_hs,
   log_hs_details,
   allow_modify,
   active,
   lc,
   lc_version,
   ss,
 'W' ar
FROM "UNILAB".utscpg;
--------------------------------------------------------
--  DDL for View UVSCPGAU
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCPGAU" ("SC", "PG", "PGNODE", "AU", "AU_VERSION", "AUSEQ", "VALUE") AS 
  SELECT "SC","PG","PGNODE","AU","AU_VERSION","AUSEQ","VALUE"
FROM "UNILAB".utscpgau;
--------------------------------------------------------
--  DDL for View UVSCPGHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCPGHS" ("SC", "PG", "PGNODE", "WHO", "WHO_DESCRIPTION", "WHAT", "WHAT_DESCRIPTION", "LOGDATE", "WHY", "TR_SEQ", "EV_SEQ", "LOGDATE_TZ") AS 
  SELECT "SC","PG","PGNODE","WHO","WHO_DESCRIPTION","WHAT","WHAT_DESCRIPTION","LOGDATE","WHY","TR_SEQ","EV_SEQ","LOGDATE_TZ"
FROM "UNILAB".utscpghs;
--------------------------------------------------------
--  DDL for View UVSCPGHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCPGHSDETAILS" ("SC", "PG", "PGNODE", "TR_SEQ", "EV_SEQ", "SEQ", "DETAILS") AS 
  SELECT "SC","PG","PGNODE","TR_SEQ","EV_SEQ","SEQ","DETAILS"
FROM "UNILAB".utscpghsdetails;
--------------------------------------------------------
--  DDL for View UVSCRD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSCRD" ("SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE", "RD", "RDNODE", "VALUE_F", "VALUE_S", "REANALYSIS") AS 
  SELECT "SC","PG","PGNODE","PA","PANODE","ME","MENODE","RD","RDNODE","VALUE_F","VALUE_S","REANALYSIS"
   FROM "UNILAB".utscrd;
--------------------------------------------------------
--  DDL for View UVSD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSD" ("SD", "PT", "PT_VERSION", "DESCRIPTION", "DESCR_DOC", "DESCR_DOC_VERSION", "RESPONSIBLE", "LABEL_FORMAT", "CREATION_DATE", "CREATION_DATE_TZ", "CREATED_BY", "EXEC_START_DATE", "EXEC_START_DATE_TZ", "EXEC_END_DATE", "EXEC_END_DATE_TZ", "T0_DATE", "T0_DATE_TZ", "NR_SC_CURRENT", "LAST_COMMENT", "SD_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR") AS 
  SELECT
   sd,
   pt,
   pt_version,
   description,
   descr_doc,
   descr_doc_version,
   responsible,
   label_format,
   creation_date,
   creation_date_tz,
   created_by,
   exec_start_date,
   exec_start_date_tz,
   exec_end_date,
   exec_end_date_tz,
   t0_date,
   t0_date_tz,
   nr_sc_current,
   last_comment,
   sd_class,
   log_hs,
   log_hs_details,
   allow_modify,
   active,
   lc,
   lc_version,
   ss,
 'W' ar
FROM "UNILAB".utsd;
--------------------------------------------------------
--  DDL for View UVSDAU
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSDAU" ("SD", "AU", "AU_VERSION", "AUSEQ", "VALUE") AS 
  SELECT "SD","AU","AU_VERSION","AUSEQ","VALUE"
FROM "UNILAB".utsdau;
--------------------------------------------------------
--  DDL for View UVSDCELLSC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSDCELLSC" ("SD", "CSNODE", "TPNODE", "SEQ", "SC", "LO", "LO_DESCRIPTION", "LO_START_DATE", "LO_END_DATE", "LO_START_DATE_TZ", "LO_END_DATE_TZ") AS 
  SELECT "SD","CSNODE","TPNODE","SEQ","SC","LO","LO_DESCRIPTION","LO_START_DATE","LO_END_DATE","LO_START_DATE_TZ","LO_END_DATE_TZ"
FROM "UNILAB".utsdcellsc;
--------------------------------------------------------
--  DDL for View UVSDCS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSDCS" ("SD", "CSNODE", "CS", "DESCRIPTION", "T0_DATE", "T0_DATE_TZ") AS 
  SELECT "SD","CSNODE","CS","DESCRIPTION","T0_DATE","T0_DATE_TZ"
FROM "UNILAB".utsdcs;
--------------------------------------------------------
--  DDL for View UVSDCSCN
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSDCSCN" ("SD", "CSNODE", "CS", "CN", "CNSEQ", "VALUE") AS 
  SELECT "SD","CSNODE","CS","CN","CNSEQ","VALUE"
FROM "UNILAB".utsdcscn;
--------------------------------------------------------
--  DDL for View UVSDGK
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSDGK" ("SD", "GK", "GK_VERSION", "GKSEQ", "VALUE") AS 
  SELECT "SD","GK","GK_VERSION","GKSEQ","VALUE"
FROM "UNILAB".utsdgk;
--------------------------------------------------------
--  DDL for View UVSDHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSDHS" ("SD", "WHO", "WHO_DESCRIPTION", "WHAT", "WHAT_DESCRIPTION", "LOGDATE", "WHY", "TR_SEQ", "EV_SEQ", "LOGDATE_TZ") AS 
  SELECT "SD","WHO","WHO_DESCRIPTION","WHAT","WHAT_DESCRIPTION","LOGDATE","WHY","TR_SEQ","EV_SEQ","LOGDATE_TZ"
FROM "UNILAB".utsdhs;
--------------------------------------------------------
--  DDL for View UVSDHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSDHSDETAILS" ("SD", "TR_SEQ", "EV_SEQ", "SEQ", "DETAILS") AS 
  SELECT "SD","TR_SEQ","EV_SEQ","SEQ","DETAILS"
FROM "UNILAB".utsdhsdetails;
--------------------------------------------------------
--  DDL for View UVSDIC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSDIC" ("SD", "IC", "ICNODE", "IP_VERSION", "DESCRIPTION", "WINSIZE_X", "WINSIZE_Y", "IS_PROTECTED", "HIDDEN", "MANUALLY_ADDED", "NEXT_II", "LAST_COMMENT", "IC_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR") AS 
  SELECT
   sd,
   ic,
   icnode,
   ip_version,
   description,
   winsize_x,
   winsize_y,
   is_protected,
   hidden,
   manually_added,
   next_ii,
   last_comment,
   ic_class,
   log_hs,
   log_hs_details,
   allow_modify,
   active,
   lc,
   lc_version,
   ss,
 'W' ar
FROM "UNILAB".utsdic;
--------------------------------------------------------
--  DDL for View UVSDICAU
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSDICAU" ("SD", "IC", "ICNODE", "AU", "AU_VERSION", "AUSEQ", "VALUE") AS 
  SELECT "SD","IC","ICNODE","AU","AU_VERSION","AUSEQ","VALUE"
FROM "UNILAB".utsdicau;
--------------------------------------------------------
--  DDL for View UVSDICHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSDICHS" ("SD", "IC", "ICNODE", "WHO", "WHO_DESCRIPTION", "WHAT", "WHAT_DESCRIPTION", "LOGDATE", "WHY", "TR_SEQ", "EV_SEQ", "LOGDATE_TZ") AS 
  SELECT "SD","IC","ICNODE","WHO","WHO_DESCRIPTION","WHAT","WHAT_DESCRIPTION","LOGDATE","WHY","TR_SEQ","EV_SEQ","LOGDATE_TZ"
FROM "UNILAB".utsdichs;
--------------------------------------------------------
--  DDL for View UVSDICHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSDICHSDETAILS" ("SD", "IC", "ICNODE", "TR_SEQ", "EV_SEQ", "SEQ", "DETAILS") AS 
  SELECT "SD","IC","ICNODE","TR_SEQ","EV_SEQ","SEQ","DETAILS"
FROM "UNILAB".utsdichsdetails;
--------------------------------------------------------
--  DDL for View UVSDII
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSDII" ("SD", "IC", "ICNODE", "II", "IINODE", "IE_VERSION", "IIVALUE", "POS_X", "POS_Y", "IS_PROTECTED", "MANDATORY", "HIDDEN", "DSP_TITLE", "DSP_LEN", "DSP_TP", "DSP_ROWS", "II_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR") AS 
  SELECT
   sd,
   ic,
   icnode,
   ii,
   iinode,
   ie_version,
   iivalue,
   pos_x,
   pos_y,
   is_protected,
   mandatory,
   hidden,
   dsp_title,
   dsp_len,
   dsp_tp,
   dsp_rows,
   ii_class,
   log_hs,
   log_hs_details,
   allow_modify,
   active,
   lc,
   lc_version,
   ss,
 'W' ar
FROM "UNILAB".utsdii;
--------------------------------------------------------
--  DDL for View UVSDSC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSDSC" ("SD", "SC", "SEQ", "ASSIGN_DATE", "ASSIGNED_BY", "ASSIGN_DATE_TZ") AS 
  SELECT "SD","SC","SEQ","ASSIGN_DATE","ASSIGNED_BY","ASSIGN_DATE_TZ"
FROM "UNILAB".utsdsc;
--------------------------------------------------------
--  DDL for View UVSDTP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSDTP" ("SD", "TPNODE", "TP", "TP_UNIT", "ALLOW_UPFRONT", "ALLOW_UPFRONT_UNIT", "ALLOW_OVERDUE", "ALLOW_OVERDUE_UNIT") AS 
  SELECT "SD","TPNODE","TP","TP_UNIT","ALLOW_UPFRONT","ALLOW_UPFRONT_UNIT","ALLOW_OVERDUE","ALLOW_OVERDUE_UNIT"
FROM "UNILAB".utsdtp;
--------------------------------------------------------
--  DDL for View UVSHORTCUT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSHORTCUT" ("SHORTCUT", "KEY_TP", "VALUE_S", "VALUE_F", "STORE_DB", "RUN_MODE", "SERVICE") AS 
  SELECT "SHORTCUT","KEY_TP","VALUE_S","VALUE_F","STORE_DB","RUN_MODE","SERVICE"
   FROM "UNILAB".utshortcut;
--------------------------------------------------------
--  DDL for View UVSS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSS" ("SS", "NAME", "DESCRIPTION", "COLOR", "SHORTCUT", "ALLOW_MODIFY", "ACTIVE", "SS_CLASS") AS 
  SELECT "SS","NAME","DESCRIPTION","COLOR","SHORTCUT","ALLOW_MODIFY","ACTIVE","SS_CLASS"
   FROM "UNILAB".utss;
--------------------------------------------------------
--  DDL for View UVSSWL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSSWL" ("SS", "ENTRY_ACTION", "GK_ENTRY", "GK_VERSION", "ENTRY_TP", "USE_VALUE") AS 
  SELECT "SS","ENTRY_ACTION","GK_ENTRY","GK_VERSION","ENTRY_TP","USE_VALUE"
   FROM "UNILAB".utsswl;
--------------------------------------------------------
--  DDL for View UVST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVST" ("ST", "VERSION", "VERSION_IS_CURRENT", "EFFECTIVE_FROM", "EFFECTIVE_FROM_TZ", "EFFECTIVE_TILL", "EFFECTIVE_TILL_TZ", "DESCRIPTION", "DESCRIPTION2", "IS_TEMPLATE", "CONFIRM_USERID", "SHELF_LIFE_VAL", "SHELF_LIFE_UNIT", "NR_PLANNED_SC", "FREQ_TP", "FREQ_VAL", "FREQ_UNIT", "INVERT_FREQ", "LAST_SCHED", "LAST_SCHED_TZ", "LAST_CNT", "LAST_VAL", "PRIORITY", "LABEL_FORMAT", "DESCR_DOC", "DESCR_DOC_VERSION", "ALLOW_ANY_PP", "SC_UC", "SC_UC_VERSION", "SC_LC", "SC_LC_VERSION", "INHERIT_AU", "INHERIT_GK", "LAST_COMMENT", "ST_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR") AS 
  SELECT
   st,
   version,
   version_is_current,
   effective_from,
   effective_from_tz,
   effective_till,
   effective_till_tz,
   description,
   description2,
   is_template,
   confirm_userid,
   shelf_life_val,
   shelf_life_unit,
   nr_planned_sc,
   freq_tp,
   freq_val,
   freq_unit,
   invert_freq,
   last_sched,
   last_sched_tz,
   last_cnt,
   last_val,
   priority,
   label_format,
   descr_doc,
   descr_doc_version,
   allow_any_pp,
   sc_uc,
   sc_uc_version,
   sc_lc,
   sc_lc_version,
   inherit_au,
   inherit_gk,
   last_comment,
   st_class,
   log_hs,
   log_hs_details,
   allow_modify,
   active,
   lc,
   lc_version,
   ss,
 'W' ar
FROM "UNILAB".utst;
--------------------------------------------------------
--  DDL for View UVSTAU
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTAU" ("ST", "VERSION", "AU", "AU_VERSION", "AUSEQ", "VALUE") AS 
  SELECT "ST","VERSION","AU","AU_VERSION","AUSEQ","VALUE"
FROM "UNILAB".utstau;
--------------------------------------------------------
--  DDL for View UVSTGK
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTGK" ("ST", "VERSION", "GK", "GK_VERSION", "GKSEQ", "VALUE") AS 
  SELECT "ST","VERSION","GK","GK_VERSION","GKSEQ","VALUE"
FROM "UNILAB".utstgk;
--------------------------------------------------------
--  DDL for View UVSTGKAPPROVAL_DOCUMENT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTGKAPPROVAL_DOCUMENT" ("APPROVAL_DOCUMENT", "ST", "VERSION") AS 
  SELECT "APPROVAL_DOCUMENT","ST","VERSION" FROM UTSTGKApproval_document
 ;
--------------------------------------------------------
--  DDL for View UVSTGKASPECT_RATIO
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTGKASPECT_RATIO" ("ASPECT_RATIO", "ST", "VERSION") AS 
  SELECT "ASPECT_RATIO","ST","VERSION" FROM UTSTGKAspect_ratio;
--------------------------------------------------------
--  DDL for View UVSTGKBRAND
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTGKBRAND" ("BRAND", "ST", "VERSION") AS 
  SELECT "BRAND","ST","VERSION" FROM UTSTGKBrand
 ;
--------------------------------------------------------
--  DDL for View UVSTGKCATEGORY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTGKCATEGORY" ("CATEGORY", "ST", "VERSION") AS 
  SELECT "CATEGORY","ST","VERSION" FROM UTSTGKCategory
 ;
--------------------------------------------------------
--  DDL for View UVSTGKCERTIFICATE_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTGKCERTIFICATE_TYPE" ("CERTIFICATE_TYPE", "ST", "VERSION") AS 
  SELECT "CERTIFICATE_TYPE","ST","VERSION" FROM UTSTGKCertificate_type;
--------------------------------------------------------
--  DDL for View UVSTGKCODE_APOLLO
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTGKCODE_APOLLO" ("CODE_APOLLO", "ST", "VERSION") AS 
  SELECT "CODE_APOLLO","ST","VERSION" FROM UTSTGKCode_Apollo
 ;
--------------------------------------------------------
--  DDL for View UVSTGKCODE_CHENNAI
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTGKCODE_CHENNAI" ("CODE_CHENNAI", "ST", "VERSION") AS 
  SELECT "CODE_CHENNAI","ST","VERSION" FROM UTSTGKCode_Chennai;
--------------------------------------------------------
--  DDL for View UVSTGKCODE_DUNLOP_SA
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTGKCODE_DUNLOP_SA" ("CODE_DUNLOP_SA", "ST", "VERSION") AS 
  SELECT "CODE_DUNLOP_SA","ST","VERSION" FROM UTSTGKCode_Dunlop_SA
 ;
--------------------------------------------------------
--  DDL for View UVSTGKCODE_ENSCHEDE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTGKCODE_ENSCHEDE" ("CODE_ENSCHEDE", "ST", "VERSION") AS 
  SELECT "CODE_ENSCHEDE","ST","VERSION" FROM UTSTGKCode_Enschede;
--------------------------------------------------------
--  DDL for View UVSTGKCODE_GYONGYOSHALASZ
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTGKCODE_GYONGYOSHALASZ" ("CODE_GYONGYOSHALASZ", "ST", "VERSION") AS 
  SELECT "CODE_GYONGYOSHALASZ","ST","VERSION" FROM UTSTGKCode_Gyongyoshalasz;
--------------------------------------------------------
--  DDL for View UVSTGKCODE_LIMDA
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTGKCODE_LIMDA" ("CODE_LIMDA", "ST", "VERSION") AS 
  SELECT "CODE_LIMDA","ST","VERSION" FROM UTSTGKCode_Limda;
--------------------------------------------------------
--  DDL for View UVSTGKCOMPOUND_APPLICATION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTGKCOMPOUND_APPLICATION" ("COMPOUND_APPLICATION", "ST", "VERSION") AS 
  SELECT "COMPOUND_APPLICATION","ST","VERSION" FROM UTSTGKCompound_application
 ;
--------------------------------------------------------
--  DDL for View UVSTGKCONTEXT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTGKCONTEXT" ("CONTEXT", "ST", "VERSION") AS 
  SELECT "CONTEXT","ST","VERSION" FROM UTSTGKContext
 ;
--------------------------------------------------------
--  DDL for View UVSTGKDATE_SEND_TO_SUPPLIE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTGKDATE_SEND_TO_SUPPLIE" ("DATE_SEND_TO_SUPPLIE", "ST", "VERSION") AS 
  SELECT "DATE_SEND_TO_SUPPLIE","ST","VERSION" FROM UTSTGKDate_send_to_supplie
 ;
--------------------------------------------------------
--  DDL for View UVSTGKDATE_SIGNED_SPECIFIC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTGKDATE_SIGNED_SPECIFIC" ("DATE_SIGNED_SPECIFIC", "ST", "VERSION") AS 
  SELECT "DATE_SIGNED_SPECIFIC","ST","VERSION" FROM UTSTGKDate_signed_specific
 ;
--------------------------------------------------------
--  DDL for View UVSTGKFPCC_HEADER_1
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTGKFPCC_HEADER_1" ("FPCC_HEADER_1", "ST", "VERSION") AS 
  SELECT "FPCC_HEADER_1","ST","VERSION" FROM UTSTGKFPCC_header_1;
--------------------------------------------------------
--  DDL for View UVSTGKFPCC_HEADER_2
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTGKFPCC_HEADER_2" ("FPCC_HEADER_2", "ST", "VERSION") AS 
  SELECT "FPCC_HEADER_2","ST","VERSION" FROM UTSTGKFPCC_header_2;
--------------------------------------------------------
--  DDL for View UVSTGKFPCC_HEADER_3
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTGKFPCC_HEADER_3" ("FPCC_HEADER_3", "ST", "VERSION") AS 
  SELECT "FPCC_HEADER_3","ST","VERSION" FROM UTSTGKFPCC_header_3;
--------------------------------------------------------
--  DDL for View UVSTGKFRAME_FOR_ATHENA_PER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTGKFRAME_FOR_ATHENA_PER" ("FRAME_FOR_ATHENA_PER", "ST", "VERSION") AS 
  SELECT "FRAME_FOR_ATHENA_PER","ST","VERSION" FROM UTSTGKFrame_for_Athena_per;
--------------------------------------------------------
--  DDL for View UVSTGKFUNCTION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTGKFUNCTION" ("FUNCTION", "ST", "VERSION") AS 
  SELECT "FUNCTION","ST","VERSION" FROM UTSTGKFunction
 ;
--------------------------------------------------------
--  DDL for View UVSTGKISTEST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTGKISTEST" ("ISTEST", "ST", "VERSION") AS 
  SELECT "ISTEST","ST","VERSION" FROM UTSTGKisTest
 ;
--------------------------------------------------------
--  DDL for View UVSTGKLINKED_PRODUCTION_CO
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTGKLINKED_PRODUCTION_CO" ("LINKED_PRODUCTION_CO", "ST", "VERSION") AS 
  SELECT "LINKED_PRODUCTION_CO","ST","VERSION" FROM UTSTGKLinked_production_co;
--------------------------------------------------------
--  DDL for View UVSTGKOLD_AMTEL_CODE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTGKOLD_AMTEL_CODE" ("OLD_AMTEL_CODE", "ST", "VERSION") AS 
  SELECT "OLD_AMTEL_CODE","ST","VERSION" FROM UTSTGKOld_Amtel_code
 ;
--------------------------------------------------------
--  DDL for View UVSTGKOLD_PRODUCTGROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTGKOLD_PRODUCTGROUP" ("OLD_PRODUCTGROUP", "ST", "VERSION") AS 
  SELECT "OLD_PRODUCTGROUP","ST","VERSION" FROM UTSTGKOld_Productgroup
 ;
--------------------------------------------------------
--  DDL for View UVSTGKOLD_VR_CODE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTGKOLD_VR_CODE" ("OLD_VR_CODE", "ST", "VERSION") AS 
  SELECT "OLD_VR_CODE","ST","VERSION" FROM UTSTGKOld_VR_code
 ;
--------------------------------------------------------
--  DDL for View UVSTGKPART_NO
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTGKPART_NO" ("PART_NO", "ST", "VERSION") AS 
  SELECT "PART_NO","ST","VERSION" FROM UTSTGKPART_NO
 ;
--------------------------------------------------------
--  DDL for View UVSTGKPART_SHORT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTGKPART_SHORT" ("PART_SHORT", "ST", "VERSION") AS 
  SELECT "PART_SHORT","ST","VERSION" FROM UTSTGKpart_short
 ;
--------------------------------------------------------
--  DDL for View UVSTGKPARTGROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTGKPARTGROUP" ("PARTGROUP", "ST", "VERSION") AS 
  SELECT "PARTGROUP","ST","VERSION" FROM UTSTGKpartGroup
 ;
--------------------------------------------------------
--  DDL for View UVSTGKPRODUCT_RANGE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTGKPRODUCT_RANGE" ("PRODUCT_RANGE", "ST", "VERSION") AS 
  SELECT "PRODUCT_RANGE","ST","VERSION" FROM UTSTGKProduct_range
 ;
--------------------------------------------------------
--  DDL for View UVSTGKPRODUCTGROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTGKPRODUCTGROUP" ("PRODUCTGROUP", "ST", "VERSION") AS 
  SELECT "PRODUCTGROUP","ST","VERSION" FROM UTSTGKProductgroup
 ;
--------------------------------------------------------
--  DDL for View UVSTGKPRODUCTLINE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTGKPRODUCTLINE" ("PRODUCTLINE", "ST", "VERSION") AS 
  SELECT "PRODUCTLINE","ST","VERSION" FROM UTSTGKProductline
 ;
--------------------------------------------------------
--  DDL for View UVSTGKPROJECT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTGKPROJECT" ("PROJECT", "ST", "VERSION") AS 
  SELECT "PROJECT","ST","VERSION" FROM UTSTGKProject
 ;
--------------------------------------------------------
--  DDL for View UVSTGKREPORT_FORMAT_NUMBER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTGKREPORT_FORMAT_NUMBER" ("REPORT_FORMAT_NUMBER", "ST", "VERSION") AS 
  SELECT "REPORT_FORMAT_NUMBER","ST","VERSION" FROM UTSTGKReport_format_number;
--------------------------------------------------------
--  DDL for View UVSTGKRIM_CODE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTGKRIM_CODE" ("RIM_CODE", "ST", "VERSION") AS 
  SELECT "RIM_CODE","ST","VERSION" FROM UTSTGKRIM_code;
--------------------------------------------------------
--  DDL for View UVSTGKRTSTSEQUENCE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTGKRTSTSEQUENCE" ("RTSTSEQUENCE", "ST", "VERSION") AS 
  SELECT "RTSTSEQUENCE","ST","VERSION" FROM UTSTGKRtStSequence
 ;
--------------------------------------------------------
--  DDL for View UVSTGKSCCREATEUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTGKSCCREATEUP" ("SCCREATEUP", "ST", "VERSION") AS 
  SELECT "SCCREATEUP","ST","VERSION" FROM UTSTGKscCreateUp
 ;
--------------------------------------------------------
--  DDL for View UVSTGKSCLISTUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTGKSCLISTUP" ("SCLISTUP", "ST", "VERSION") AS 
  SELECT "SCLISTUP","ST","VERSION" FROM UTSTGKscListUp
 ;
--------------------------------------------------------
--  DDL for View UVSTGKSCRECEIVERUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTGKSCRECEIVERUP" ("SCRECEIVERUP", "ST", "VERSION") AS 
  SELECT "SCRECEIVERUP","ST","VERSION" FROM UTSTGKscReceiverUp
 ;
--------------------------------------------------------
--  DDL for View UVSTGKSCRECIEVEUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTGKSCRECIEVEUP" ("SCRECIEVEUP", "ST", "VERSION") AS 
  SELECT "SCRECIEVEUP","ST","VERSION" FROM UTSTGKscRecieveUp
 ;
--------------------------------------------------------
--  DDL for View UVSTGKSITE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTGKSITE" ("SITE", "ST", "VERSION") AS 
  SELECT "SITE","ST","VERSION" FROM UTSTGKSite;
--------------------------------------------------------
--  DDL for View UVSTGKSPEC__FUNCTION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTGKSPEC__FUNCTION" ("SPEC__FUNCTION", "ST", "VERSION") AS 
  SELECT "SPEC__FUNCTION","ST","VERSION" FROM UTSTGKSpec__Function
 ;
--------------------------------------------------------
--  DDL for View UVSTGKSPEC__REF_
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTGKSPEC__REF_" ("SPEC__REF_", "ST", "VERSION") AS 
  SELECT "SPEC__REF_","ST","VERSION" FROM UTSTGKSpec__Ref_
 ;
--------------------------------------------------------
--  DDL for View UVSTGKSPEC_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTGKSPEC_TYPE" ("SPEC_TYPE", "ST", "VERSION") AS 
  SELECT "SPEC_TYPE","ST","VERSION" FROM UTSTGKSPEC_TYPE
 ;
--------------------------------------------------------
--  DDL for View UVSTGKSPECIFICATION_TYPE_G
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTGKSPECIFICATION_TYPE_G" ("SPECIFICATION_TYPE_G", "ST", "VERSION") AS 
  SELECT "SPECIFICATION_TYPE_G","ST","VERSION" FROM UTSTGKSpecification_type_g;
--------------------------------------------------------
--  DDL for View UVSTGKSPECTRAC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTGKSPECTRAC" ("SPECTRAC", "ST", "VERSION") AS 
  SELECT "SPECTRAC","ST","VERSION" FROM UTSTGKSpectrac
 ;
--------------------------------------------------------
--  DDL for View UVSTGKSTLISTGROUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTGKSTLISTGROUP" ("STLISTGROUP", "ST", "VERSION") AS 
  SELECT "STLISTGROUP","ST","VERSION" FROM UTSTGKstListGroup
 ;
--------------------------------------------------------
--  DDL for View UVSTGKSUPPLIER_CODE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTGKSUPPLIER_CODE" ("SUPPLIER_CODE", "ST", "VERSION") AS 
  SELECT "SUPPLIER_CODE","ST","VERSION" FROM UTSTGKSupplier_code
 ;
--------------------------------------------------------
--  DDL for View UVSTGKSUPPLIERS_RUSSIA
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTGKSUPPLIERS_RUSSIA" ("SUPPLIERS_RUSSIA", "ST", "VERSION") AS 
  SELECT "SUPPLIERS_RUSSIA","ST","VERSION" FROM UTSTGKSuppliers_russia
 ;
--------------------------------------------------------
--  DDL for View UVSTGKTEMPLATE_VALUE_OVERW
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTGKTEMPLATE_VALUE_OVERW" ("TEMPLATE_VALUE_OVERW", "ST", "VERSION") AS 
  SELECT "TEMPLATE_VALUE_OVERW","ST","VERSION" FROM UTSTGKTemplate_value_overw;
--------------------------------------------------------
--  DDL for View UVSTGKTYRE_WIDTH
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTGKTYRE_WIDTH" ("TYRE_WIDTH", "ST", "VERSION") AS 
  SELECT "TYRE_WIDTH","ST","VERSION" FROM UTSTGKTyre_width;
--------------------------------------------------------
--  DDL for View UVSTGKXPERT_MATERIAL_LIST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTGKXPERT_MATERIAL_LIST" ("XPERT_MATERIAL_LIST", "ST", "VERSION") AS 
  SELECT "XPERT_MATERIAL_LIST","ST","VERSION" FROM UTSTGKXpert_material_list;
--------------------------------------------------------
--  DDL for View UVSTHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTHS" ("ST", "VERSION", "WHO", "WHO_DESCRIPTION", "WHAT", "WHAT_DESCRIPTION", "LOGDATE", "WHY", "TR_SEQ", "EV_SEQ", "LOGDATE_TZ") AS 
  SELECT "ST","VERSION","WHO","WHO_DESCRIPTION","WHAT","WHAT_DESCRIPTION","LOGDATE","WHY","TR_SEQ","EV_SEQ","LOGDATE_TZ"
FROM "UNILAB".utsths;
--------------------------------------------------------
--  DDL for View UVSTHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTHSDETAILS" ("ST", "VERSION", "TR_SEQ", "EV_SEQ", "SEQ", "DETAILS") AS 
  SELECT "ST","VERSION","TR_SEQ","EV_SEQ","SEQ","DETAILS"
FROM "UNILAB".utsthsdetails;
--------------------------------------------------------
--  DDL for View UVSTIP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTIP" ("ST", "VERSION", "IP", "IP_VERSION", "SEQ", "IS_PROTECTED", "HIDDEN", "FREQ_TP", "FREQ_VAL", "FREQ_UNIT", "INVERT_FREQ", "LAST_SCHED", "LAST_CNT", "LAST_VAL", "INHERIT_AU", "LAST_SCHED_TZ") AS 
  SELECT "ST","VERSION","IP","IP_VERSION","SEQ","IS_PROTECTED","HIDDEN","FREQ_TP","FREQ_VAL","FREQ_UNIT","INVERT_FREQ","LAST_SCHED","LAST_CNT","LAST_VAL","INHERIT_AU","LAST_SCHED_TZ"
FROM "UNILAB".utstip;
--------------------------------------------------------
--  DDL for View UVSTIPAU
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTIPAU" ("ST", "VERSION", "IP", "IP_VERSION", "AU", "AU_VERSION", "AUSEQ", "VALUE") AS 
  SELECT "ST","VERSION","IP","IP_VERSION","AU","AU_VERSION","AUSEQ","VALUE"
FROM "UNILAB".utstipau;
--------------------------------------------------------
--  DDL for View UVSTIPBUFFER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTIPBUFFER" ("ST", "VERSION", "IP", "IP_VERSION", "SEQ", "IS_PROTECTED", "HIDDEN", "FREQ_TP", "FREQ_VAL", "FREQ_UNIT", "INVERT_FREQ", "LAST_SCHED", "LAST_SCHED_TZ", "LAST_CNT", "LAST_VAL", "INHERIT_AU", "HANDLED") AS 
  SELECT "ST","VERSION","IP","IP_VERSION","SEQ","IS_PROTECTED","HIDDEN","FREQ_TP","FREQ_VAL","FREQ_UNIT","INVERT_FREQ","LAST_SCHED","LAST_SCHED_TZ","LAST_CNT","LAST_VAL","INHERIT_AU","HANDLED"
   FROM "UNILAB".UTSTIPBUFFER;
--------------------------------------------------------
--  DDL for View UVSTMTFREQ
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTMTFREQ" ("ST", "VERSION", "PR", "PR_VERSION", "MT", "MT_VERSION", "FREQ_TP", "FREQ_VAL", "FREQ_UNIT", "INVERT_FREQ", "LAST_SCHED", "LAST_CNT", "LAST_VAL", "LAST_SCHED_TZ") AS 
  SELECT "ST","VERSION","PR","PR_VERSION","MT","MT_VERSION","FREQ_TP","FREQ_VAL","FREQ_UNIT","INVERT_FREQ","LAST_SCHED","LAST_CNT","LAST_VAL","LAST_SCHED_TZ"
FROM "UNILAB".utstmtfreq;
--------------------------------------------------------
--  DDL for View UVSTMTFREQBUFFER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTMTFREQBUFFER" ("ST", "VERSION", "PR", "PR_VERSION", "MT", "MT_VERSION", "FREQ_TP", "FREQ_VAL", "FREQ_UNIT", "INVERT_FREQ", "LAST_SCHED", "LAST_SCHED_TZ", "LAST_CNT", "LAST_VAL", "HANDLED") AS 
  SELECT "ST","VERSION","PR","PR_VERSION","MT","MT_VERSION","FREQ_TP","FREQ_VAL","FREQ_UNIT","INVERT_FREQ","LAST_SCHED","LAST_SCHED_TZ","LAST_CNT","LAST_VAL","HANDLED"
   FROM "UNILAB".UTSTMTFREQBUFFER;
--------------------------------------------------------
--  DDL for View UVSTPP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTPP" ("ST", "VERSION", "PP", "PP_VERSION", "PP_KEY1", "PP_KEY2", "PP_KEY3", "PP_KEY4", "PP_KEY5", "SEQ", "FREQ_TP", "FREQ_VAL", "FREQ_UNIT", "INVERT_FREQ", "LAST_SCHED", "LAST_CNT", "LAST_VAL", "INHERIT_AU", "LAST_SCHED_TZ") AS 
  SELECT "ST","VERSION","PP","PP_VERSION","PP_KEY1","PP_KEY2","PP_KEY3","PP_KEY4","PP_KEY5","SEQ","FREQ_TP","FREQ_VAL","FREQ_UNIT","INVERT_FREQ","LAST_SCHED","LAST_CNT","LAST_VAL","INHERIT_AU","LAST_SCHED_TZ"
FROM "UNILAB".utstpp;
--------------------------------------------------------
--  DDL for View UVSTPP_PP_SPECX
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTPP_PP_SPECX" ("ST", "VERSION", "PP", "PP_VERSION", "PP_KEY1", "PP_KEY2", "PP_KEY3", "PP_KEY4", "PP_KEY5", "SEQ", "FREQ_TP", "FREQ_VAL", "FREQ_UNIT", "INVERT_FREQ", "LAST_SCHED", "LAST_CNT", "LAST_VAL", "INHERIT_AU", "DESCRIPTION", "SS", "LC", "LC_VERSION", "KEY1_SET", "KEY2_SET", "KEY3_SET", "KEY4_SET", "KEY5_SET", "PP_EXACT_VERSION") AS 
  SELECT stpp.st, stpp.version,
       stpp.pp, stpp.pp_version, stpp.pp_key1, stpp.pp_key2, stpp.pp_key3, stpp.pp_key4,
       stpp.pp_key5, stpp.seq, stpp.freq_tp, stpp.freq_val, stpp.freq_unit, stpp.invert_freq,
       stpp.last_sched, stpp.last_cnt, stpp.last_val, stpp.inherit_au,
       pp.description, pp.ss, pp.lc, pp.lc_version,
       DECODE(stpp.pp_key1,' ','0','1'), DECODE(stpp.pp_key2,' ','0','1'), DECODE(stpp.pp_key3,' ','0','1'),
       DECODE(stpp.pp_key4,' ','0','1'), DECODE(stpp.pp_key5,' ','0','1'),
       pp.version pp_exact_version
FROM utstpp stpp, utpp pp
WHERE stpp.pp         = pp.pp
  AND NVL(unapigen.UsePpVersion(stpp.pp, stpp.pp_version, stpp.pp_key1, stpp.pp_key2, stpp.pp_key3, stpp.pp_key4, stpp.pp_key5 ),
          unapigen.UsePpVersion(stpp.pp, '*', stpp.pp_key1, stpp.pp_key2, stpp.pp_key3, stpp.pp_key4, stpp.pp_key5 ))
      = pp.version
  AND stpp.pp_key1    = pp.pp_key1
  AND stpp.pp_key2    = pp.pp_key2
  AND stpp.pp_key3    = pp.pp_key3
  AND stpp.pp_key4    = pp.pp_key4
  AND stpp.pp_key5    = pp.pp_key5
 ;
--------------------------------------------------------
--  DDL for View UVSTPPAU
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTPPAU" ("ST", "VERSION", "PP", "PP_VERSION", "PP_KEY1", "PP_KEY2", "PP_KEY3", "PP_KEY4", "PP_KEY5", "AU", "AU_VERSION", "AUSEQ", "VALUE") AS 
  SELECT "ST","VERSION","PP","PP_VERSION","PP_KEY1","PP_KEY2","PP_KEY3","PP_KEY4","PP_KEY5","AU","AU_VERSION","AUSEQ","VALUE"
FROM "UNILAB".utstppau;
--------------------------------------------------------
--  DDL for View UVSTPPBUFFER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTPPBUFFER" ("ST", "VERSION", "PP", "PP_VERSION", "PP_KEY1", "PP_KEY2", "PP_KEY3", "PP_KEY4", "PP_KEY5", "SEQ", "FREQ_TP", "FREQ_VAL", "FREQ_UNIT", "INVERT_FREQ", "LAST_SCHED", "LAST_SCHED_TZ", "LAST_CNT", "LAST_VAL", "INHERIT_AU", "HANDLED") AS 
  SELECT "ST","VERSION","PP","PP_VERSION","PP_KEY1","PP_KEY2","PP_KEY3","PP_KEY4","PP_KEY5","SEQ","FREQ_TP","FREQ_VAL","FREQ_UNIT","INVERT_FREQ","LAST_SCHED","LAST_SCHED_TZ","LAST_CNT","LAST_VAL","INHERIT_AU","HANDLED"
   FROM "UNILAB".UTSTPPBUFFER;
--------------------------------------------------------
--  DDL for View UVSTPRFREQ
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTPRFREQ" ("ST", "VERSION", "PP", "PP_VERSION", "PP_KEY1", "PP_KEY2", "PP_KEY3", "PP_KEY4", "PP_KEY5", "PR", "PR_VERSION", "FREQ_TP", "FREQ_VAL", "FREQ_UNIT", "INVERT_FREQ", "LAST_SCHED", "LAST_CNT", "LAST_VAL", "LAST_SCHED_TZ") AS 
  SELECT "ST","VERSION","PP","PP_VERSION","PP_KEY1","PP_KEY2","PP_KEY3","PP_KEY4","PP_KEY5","PR","PR_VERSION","FREQ_TP","FREQ_VAL","FREQ_UNIT","INVERT_FREQ","LAST_SCHED","LAST_CNT","LAST_VAL","LAST_SCHED_TZ"
FROM "UNILAB".utstprfreq;
--------------------------------------------------------
--  DDL for View UVSTPRFREQBUFFER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSTPRFREQBUFFER" ("ST", "VERSION", "PP", "PP_VERSION", "PP_KEY1", "PP_KEY2", "PP_KEY3", "PP_KEY4", "PP_KEY5", "PR", "PR_VERSION", "FREQ_TP", "FREQ_VAL", "FREQ_UNIT", "INVERT_FREQ", "LAST_SCHED", "LAST_SCHED_TZ", "LAST_CNT", "LAST_VAL", "HANDLED") AS 
  SELECT "ST","VERSION","PP","PP_VERSION","PP_KEY1","PP_KEY2","PP_KEY3","PP_KEY4","PP_KEY5","PR","PR_VERSION","FREQ_TP","FREQ_VAL","FREQ_UNIT","INVERT_FREQ","LAST_SCHED","LAST_SCHED_TZ","LAST_CNT","LAST_VAL","HANDLED"
   FROM "UNILAB".UTSTPRFREQBUFFER;
--------------------------------------------------------
--  DDL for View UVSYSTEM
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSYSTEM" ("SETTING_NAME", "SETTING_VALUE") AS 
  SELECT "SETTING_NAME","SETTING_VALUE"
   FROM "UNILAB".utsystem;
--------------------------------------------------------
--  DDL for View UVSYSTEMCOST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSYSTEMCOST" ("SETTING_NAME", "SETTING_VALUE") AS 
  SELECT "SETTING_NAME","SETTING_VALUE"
   FROM "UNILAB".utsystemcost;
--------------------------------------------------------
--  DDL for View UVSYSTEMLIST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVSYSTEMLIST" ("SETTING_NAME", "SEQ", "SETTING_VALUE") AS 
  SELECT "SETTING_NAME","SEQ","SETTING_VALUE"
   FROM "UNILAB".utsystemlist;
--------------------------------------------------------
--  DDL for View UVTITLEFMT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVTITLEFMT" ("WINDOW", "TITLE_FORMAT") AS 
  SELECT "WINDOW","TITLE_FORMAT"
   FROM "UNILAB".uttitlefmt;
--------------------------------------------------------
--  DDL for View UVTK
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVTK" ("TK_TP", "TK", "VERSION", "VERSION_IS_CURRENT", "EFFECTIVE_FROM", "EFFECTIVE_TILL", "DESCRIPTION", "COL_ID", "COL_TP", "SEQ", "DEF_VAL", "HIDDEN", "IS_PROTECTED", "MANDATORY", "AUTO_REFRESH", "COL_ASC", "DSP_LEN", "LAST_COMMENT", "TK_CLASS", "VALUE_LIST_TP", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "EFFECTIVE_FROM_TZ", "EFFECTIVE_TILL_TZ", "OPERAT", "ANDOR", "DSP_TITLE", "OPERAT_PROTECT", "ANDOR_PROTECT") AS 
  SELECT "TK_TP","TK","VERSION","VERSION_IS_CURRENT","EFFECTIVE_FROM","EFFECTIVE_TILL","DESCRIPTION","COL_ID","COL_TP","SEQ","DEF_VAL","HIDDEN","IS_PROTECTED","MANDATORY","AUTO_REFRESH","COL_ASC","DSP_LEN","LAST_COMMENT","TK_CLASS","VALUE_LIST_TP","LOG_HS","LOG_HS_DETAILS","ALLOW_MODIFY","ACTIVE","LC","LC_VERSION","SS","EFFECTIVE_FROM_TZ","EFFECTIVE_TILL_TZ","OPERAT","ANDOR","DSP_TITLE","OPERAT_PROTECT","ANDOR_PROTECT"
   FROM "UNILAB".uttk;
--------------------------------------------------------
--  DDL for View UVTKHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVTKHS" ("TK_TP", "TK", "VERSION", "WHO", "WHO_DESCRIPTION", "WHAT", "WHAT_DESCRIPTION", "LOGDATE", "WHY", "TR_SEQ", "EV_SEQ", "LOGDATE_TZ") AS 
  SELECT "TK_TP","TK","VERSION","WHO","WHO_DESCRIPTION","WHAT","WHAT_DESCRIPTION","LOGDATE","WHY","TR_SEQ","EV_SEQ","LOGDATE_TZ"
   FROM "UNILAB".uttkhs;
--------------------------------------------------------
--  DDL for View UVTKHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVTKHSDETAILS" ("TK_TP", "TK", "VERSION", "TR_SEQ", "EV_SEQ", "SEQ", "DETAILS") AS 
  SELECT "TK_TP","TK","VERSION","TR_SEQ","EV_SEQ","SEQ","DETAILS"
   FROM "UNILAB".uttkhsdetails;
--------------------------------------------------------
--  DDL for View UVTKPREF
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVTKPREF" ("TK_TP", "TK", "VERSION", "PREF_NAME", "SEQ", "PREF_VALUE") AS 
  SELECT "TK_TP","TK","VERSION","PREF_NAME","SEQ","PREF_VALUE"
   FROM "UNILAB".uttkpref;
--------------------------------------------------------
--  DDL for View UVTKSQL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVTKSQL" ("TK", "TK_TP", "VERSION", "COL_ID", "COL_TP", "SQLSEQ", "SQLTEXT") AS 
  SELECT "TK","TK_TP","VERSION","COL_ID","COL_TP","SQLSEQ","SQLTEXT"
   FROM "UNILAB".uttksql;
--------------------------------------------------------
--  DDL for View UVTOARCHIVE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVTOARCHIVE" ("OBJECT_TP", "OBJECT_ID", "VERSION", "OBJECT_DETAILS", "COPY_FLAG", "DELETE_FLAG", "ARCHIVE_ID", "ARCHIVE_TO", "ARCHIVE_ON", "HANDLED_OK", "ARCHIVE_ON_TZ") AS 
  SELECT "OBJECT_TP","OBJECT_ID","VERSION","OBJECT_DETAILS","COPY_FLAG","DELETE_FLAG","ARCHIVE_ID","ARCHIVE_TO","ARCHIVE_ON","HANDLED_OK","ARCHIVE_ON_TZ"
   FROM "UNILAB".uttoarchive;
--------------------------------------------------------
--  DDL for View UVUC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVUC" ("UC", "VERSION", "VERSION_IS_CURRENT", "EFFECTIVE_FROM", "EFFECTIVE_TILL", "DESCRIPTION", "UC_STRUCTURE", "CURR_VAL", "DEF_MASK_FOR", "EDIT_ALLOWED", "VALID_CF", "LAST_COMMENT", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "EFFECTIVE_FROM_TZ", "EFFECTIVE_TILL_TZ") AS 
  SELECT "UC","VERSION","VERSION_IS_CURRENT","EFFECTIVE_FROM","EFFECTIVE_TILL","DESCRIPTION","UC_STRUCTURE","CURR_VAL","DEF_MASK_FOR","EDIT_ALLOWED","VALID_CF","LAST_COMMENT","LOG_HS","LOG_HS_DETAILS","ALLOW_MODIFY","ACTIVE","LC","LC_VERSION","SS","EFFECTIVE_FROM_TZ","EFFECTIVE_TILL_TZ"
   FROM "UNILAB".utuc;
--------------------------------------------------------
--  DDL for View UVUCAU
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVUCAU" ("UC", "VERSION", "AU", "AU_VERSION", "AUSEQ", "VALUE") AS 
  SELECT "UC","VERSION","AU","AU_VERSION","AUSEQ","VALUE"
   FROM "UNILAB".utucau;
--------------------------------------------------------
--  DDL for View UVUCAUDITTRAIL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVUCAUDITTRAIL" ("UC", "VERSION", "CURR_VAL", "REF_DATE", "LOGDATE", "US", "CLIENT_ID", "APPLIC", "SID", "SERIAL#", "OSUSER", "TERMINAL", "PROGRAM", "LOGON_TIME", "REF_DATE_TZ", "LOGDATE_TZ", "LOGON_TIME_TZ") AS 
  SELECT "UC","VERSION","CURR_VAL","REF_DATE","LOGDATE","US","CLIENT_ID","APPLIC","SID","SERIAL#","OSUSER","TERMINAL","PROGRAM","LOGON_TIME","REF_DATE_TZ","LOGDATE_TZ","LOGON_TIME_TZ"
   FROM "UNILAB".utucaudittrail;
--------------------------------------------------------
--  DDL for View UVUCHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVUCHS" ("UC", "VERSION", "WHO", "WHO_DESCRIPTION", "WHAT", "WHAT_DESCRIPTION", "LOGDATE", "WHY", "TR_SEQ", "EV_SEQ", "LOGDATE_TZ") AS 
  SELECT "UC","VERSION","WHO","WHO_DESCRIPTION","WHAT","WHAT_DESCRIPTION","LOGDATE","WHY","TR_SEQ","EV_SEQ","LOGDATE_TZ"
   FROM "UNILAB".utuchs;
--------------------------------------------------------
--  DDL for View UVUCHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVUCHSDETAILS" ("UC", "VERSION", "TR_SEQ", "EV_SEQ", "SEQ", "DETAILS") AS 
  SELECT "UC","VERSION","TR_SEQ","EV_SEQ","SEQ","DETAILS"
   FROM "UNILAB".utuchsdetails;
--------------------------------------------------------
--  DDL for View UVUCOBJECTCOUNTER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVUCOBJECTCOUNTER" ("OBJECT_TP", "OBJECT_ID", "OBJECT_COUNTER") AS 
  SELECT "OBJECT_TP","OBJECT_ID","OBJECT_COUNTER"
   FROM "UNILAB".utucobjectcounter;
--------------------------------------------------------
--  DDL for View UVUICOMPONENT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVUICOMPONENT" ("COMPONENT_TP", "COMPONENT_ID", "SEQ", "COL_TP", "DISP_TITLE") AS 
  SELECT "COMPONENT_TP","COMPONENT_ID","SEQ","COL_TP","DISP_TITLE"
   FROM "UNILAB".utuicomponent;
--------------------------------------------------------
--  DDL for View UVULFILESTATUS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVULFILESTATUS" ("DIRECTORY_NAME", "FILE_NAME", "FILE_SIZE", "PROCESS_DATE", "PARSE_RETURN", "PROCESSED", "PROCESS_DATE_TZ") AS 
  SELECT "DIRECTORY_NAME","FILE_NAME","FILE_SIZE","PROCESS_DATE","PARSE_RETURN","PROCESSED","PROCESS_DATE_TZ"
   FROM "UNILAB".utulfilestatus;
--------------------------------------------------------
--  DDL for View UVULIN
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVULIN" ("UNILINK_ID", "FILE_NAME", "READ_ON", "LINE_NBR", "TEXT_LINE", "READ_ON_TZ") AS 
  SELECT "UNILINK_ID","FILE_NAME","READ_ON","LINE_NBR","TEXT_LINE","READ_ON_TZ"
   FROM "UNILAB".utulin;
--------------------------------------------------------
--  DDL for View UVULLOG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVULLOG" ("UNILINK_ID", "EQ", "LOC_DIR", "FILE_NAME", "API_NAME", "LOGDATE", "LOG_MSG", "LOGDATE_TZ") AS 
  SELECT "UNILINK_ID","EQ","LOC_DIR","FILE_NAME","API_NAME","LOGDATE","LOG_MSG","LOGDATE_TZ"
   FROM "UNILAB".utullog;
--------------------------------------------------------
--  DDL for View UVULPEERS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVULPEERS" ("SID", "DESCRIPTION", "IMPORT_URL") AS 
  SELECT "SID","DESCRIPTION","IMPORT_URL"
   FROM "UNILAB".utulpeers;
--------------------------------------------------------
--  DDL for View UVUNIT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVUNIT" ("UNIT", "UNIT_TP", "CONV_FACTOR") AS 
  SELECT "UNIT","UNIT_TP","CONV_FACTOR"
   FROM "UNILAB".utunit;
--------------------------------------------------------
--  DDL for View UVUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVUP" ("UP", "VERSION", "VERSION_IS_CURRENT", "EFFECTIVE_FROM", "EFFECTIVE_TILL", "DESCRIPTION", "DD", "DESCR_DOC", "DESCR_DOC_VERSION", "CHG_PWD", "DEFINE_MENU", "CONFIRM_CHG_SS", "LANGUAGE", "LAST_COMMENT", "UP_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "EFFECTIVE_FROM_TZ", "EFFECTIVE_TILL_TZ") AS 
  SELECT "UP","VERSION","VERSION_IS_CURRENT","EFFECTIVE_FROM","EFFECTIVE_TILL","DESCRIPTION","DD","DESCR_DOC","DESCR_DOC_VERSION","CHG_PWD","DEFINE_MENU","CONFIRM_CHG_SS","LANGUAGE","LAST_COMMENT","UP_CLASS","LOG_HS","LOG_HS_DETAILS","ALLOW_MODIFY","ACTIVE","LC","LC_VERSION","SS","EFFECTIVE_FROM_TZ","EFFECTIVE_TILL_TZ"
   FROM "UNILAB".utup;
--------------------------------------------------------
--  DDL for View UVUPAU
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVUPAU" ("UP", "VERSION", "AU", "AU_VERSION", "AUSEQ", "VALUE") AS 
  SELECT "UP","VERSION","AU","AU_VERSION","AUSEQ","VALUE"
   FROM "UNILAB".utupau;
--------------------------------------------------------
--  DDL for View UVUPFA
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVUPFA" ("UP", "VERSION", "APPLIC", "TOPIC", "FA", "INHERIT_FA") AS 
  SELECT "UP","VERSION","APPLIC","TOPIC","FA","INHERIT_FA"
   FROM "UNILAB".utupfa;
--------------------------------------------------------
--  DDL for View UVUPHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVUPHS" ("UP", "VERSION", "WHO", "WHO_DESCRIPTION", "WHAT", "WHAT_DESCRIPTION", "LOGDATE", "WHY", "TR_SEQ", "EV_SEQ", "LOGDATE_TZ") AS 
  SELECT "UP","VERSION","WHO","WHO_DESCRIPTION","WHAT","WHAT_DESCRIPTION","LOGDATE","WHY","TR_SEQ","EV_SEQ","LOGDATE_TZ"
   FROM "UNILAB".utuphs;
--------------------------------------------------------
--  DDL for View UVUPHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVUPHSDETAILS" ("UP", "VERSION", "TR_SEQ", "EV_SEQ", "SEQ", "DETAILS") AS 
  SELECT "UP","VERSION","TR_SEQ","EV_SEQ","SEQ","DETAILS"
   FROM "UNILAB".utuphsdetails;
--------------------------------------------------------
--  DDL for View UVUPPREF
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVUPPREF" ("UP", "VERSION", "PREF_NAME", "SEQ", "PREF_VALUE", "INHERIT_PREF") AS 
  SELECT "UP","VERSION","PREF_NAME","SEQ","PREF_VALUE","INHERIT_PREF"
   FROM "UNILAB".utuppref;
--------------------------------------------------------
--  DDL for View UVUPTK
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVUPTK" ("UP", "VERSION", "SEQ", "TK_TP", "TK", "IS_ENABLED") AS 
  SELECT "UP","VERSION","SEQ","TK_TP","TK","IS_ENABLED"
   FROM "UNILAB".utuptk;
--------------------------------------------------------
--  DDL for View UVUPTKDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVUPTKDETAILS" ("UP", "VERSION", "TK_TP", "TK", "COL_ID", "COL_TP", "SEQ", "DEF_VAL", "HIDDEN", "IS_PROTECTED", "MANDATORY", "AUTO_REFRESH", "COL_ASC", "DSP_LEN", "INHERIT_TK", "OPERAT", "ANDOR", "DSP_TITLE", "OPERAT_PROTECT", "ANDOR_PROTECT") AS 
  SELECT "UP","VERSION","TK_TP","TK","COL_ID","COL_TP","SEQ","DEF_VAL","HIDDEN","IS_PROTECTED","MANDATORY","AUTO_REFRESH","COL_ASC","DSP_LEN","INHERIT_TK","OPERAT","ANDOR","DSP_TITLE","OPERAT_PROTECT","ANDOR_PROTECT"
   FROM "UNILAB".utuptkdetails;
--------------------------------------------------------
--  DDL for View UVUPUS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVUPUS" ("UP", "VERSION", "US", "US_VERSION") AS 
  SELECT "UP","VERSION","US","US_VERSION"
   FROM "UNILAB".utupus;
--------------------------------------------------------
--  DDL for View UVUPUSEL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVUPUSEL" ("UP", "VERSION", "US", "US_VERSION", "EL", "IS_ENABLED", "SEQ") AS 
  SELECT "UP","VERSION","US","US_VERSION","EL","IS_ENABLED","SEQ"
   FROM "UNILAB".utupusel;
--------------------------------------------------------
--  DDL for View UVUPUSFA
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVUPUSFA" ("UP", "VERSION", "US", "US_VERSION", "APPLIC", "TOPIC", "FA", "INHERIT_FA") AS 
  SELECT "UP","VERSION","US","US_VERSION","APPLIC","TOPIC","FA","INHERIT_FA"
   FROM "UNILAB".utupusfa;
--------------------------------------------------------
--  DDL for View UVUPUSOUTLOOKPAGES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVUPUSOUTLOOKPAGES" ("UP", "US", "SEQ", "PAGE_ID", "PAGE_DESCRIPTION", "PAGE_TP", "ACTIVE") AS 
  SELECT "UP","US","SEQ","PAGE_ID","PAGE_DESCRIPTION","PAGE_TP","ACTIVE"
   FROM "UNILAB".utupusoutlookpages;
--------------------------------------------------------
--  DDL for View UVUPUSOUTLOOKTASKS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVUPUSOUTLOOKTASKS" ("UP", "US", "PAGE_ID", "SEQ", "TK", "TK_TP", "DESCRIPTION", "ICON_NAME", "ICON_NBR", "CMD_LINE", "ACTIVE") AS 
  SELECT "UP","US","PAGE_ID","SEQ","TK","TK_TP","DESCRIPTION","ICON_NAME","ICON_NBR","CMD_LINE","ACTIVE"
   FROM "UNILAB".utupusoutlooktasks;
--------------------------------------------------------
--  DDL for View UVUPUSPREF
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVUPUSPREF" ("UP", "VERSION", "US", "US_VERSION", "PREF_NAME", "SEQ", "PREF_VALUE", "INHERIT_PREF") AS 
  SELECT "UP","VERSION","US","US_VERSION","PREF_NAME","SEQ","PREF_VALUE","INHERIT_PREF"
   FROM "UNILAB".utupuspref;
--------------------------------------------------------
--  DDL for View UVUPUSTK
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVUPUSTK" ("UP", "VERSION", "US", "US_VERSION", "SEQ", "TK_TP", "TK", "IS_ENABLED") AS 
  SELECT "UP","VERSION","US","US_VERSION","SEQ","TK_TP","TK","IS_ENABLED"
   FROM "UNILAB".utupustk;
--------------------------------------------------------
--  DDL for View UVUPUSTKDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVUPUSTKDETAILS" ("UP", "VERSION", "US", "US_VERSION", "TK_TP", "TK", "COL_ID", "COL_TP", "SEQ", "DEF_VAL", "HIDDEN", "IS_PROTECTED", "MANDATORY", "AUTO_REFRESH", "COL_ASC", "DSP_LEN", "INHERIT_TK", "OPERAT", "ANDOR", "DSP_TITLE", "OPERAT_PROTECT", "ANDOR_PROTECT") AS 
  SELECT "UP","VERSION","US","US_VERSION","TK_TP","TK","COL_ID","COL_TP","SEQ","DEF_VAL","HIDDEN","IS_PROTECTED","MANDATORY","AUTO_REFRESH","COL_ASC","DSP_LEN","INHERIT_TK","OPERAT","ANDOR","DSP_TITLE","OPERAT_PROTECT","ANDOR_PROTECT"
   FROM "UNILAB".utupustkdetails;
--------------------------------------------------------
--  DDL for View UVUPUSTKVALUELISTS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVUPUSTKVALUELISTS" ("UP", "US", "TK_TP", "TK", "COL_ID", "COL_TP", "SEQ", "VALUESEQ", "VALUE") AS 
  SELECT "UP","US","TK_TP","TK","COL_ID","COL_TP","SEQ","VALUESEQ","VALUE"
   FROM "UNILAB".utupustkvaluelists;
--------------------------------------------------------
--  DDL for View UVVERSION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVVERSION" ("NAME", "TYPE", "STATUS", "VERSION", "CHECK_IN_DATE", "CREATED", "LAST_DDL_TIME", "TIMESTAMP") AS 
  SELECT a.name,
   a.type,
   MAX(b.status) status,
   MAX(LTRIM(DECODE(INSTR(a.text,'-- $Revi'||'sion:'),0,'',REPLACE(REPLACE(SUBSTR(a.text,INSTR(a.text,'-- $Revi'||'sion:')+14,INSTR(a.text,'$',INSTR(a.text,'-- $Revi'||'sion:')+14)-(INSTR(a.text,'-- $Revi'||'sion:')+14)),'-- $Revi'||'sion:',''),'$','')))) version,
   MAX(LTRIM(DECODE(INSTR(a.text,'-- $Da'||'te:')    ,0,'',REPLACE(REPLACE(SUBSTR(a.text,INSTR(a.text,'-- $Da'||'te:')+10,INSTR(a.text,'$',INSTR(a.text,'-- $Da'||'te:')+10)-(INSTR(a.text,'-- $Da'||'te:')+10)),'-- $Da'||'te:',''),'$','')))) check_in_date,
   MAX(b.created) created,
   MAX(b.last_ddl_time) last_ddl_time,
   MAX(b.timestamp) timestamp
FROM SYS.DBA_SOURCE a, SYS.DBA_OBJECTS b
WHERE a.type LIKE 'PACKAGE%'
AND a.owner = (SELECT setting_value FROM utsystem WHERE setting_name='DBA_NAME')
AND a.line < 10
AND (INSTR(a.text,'-- $Revi'||'sion:')<>0 OR INSTR(a.text,'-- $Da'||'te:')<>0)
AND a.name = b.object_name
AND a.type = b.object_type
GROUP BY a.name,a.type
 ;
--------------------------------------------------------
--  DDL for View UVVFORMAT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVVFORMAT" ("RANGE_NAME", "SEQ", "RANGE_MIN_BOUNDARY", "RANGE_MIN", "RANGE_MAX", "RANGE_MAX_BOUNDARY", "FORMAT") AS 
  SELECT "RANGE_NAME","SEQ","RANGE_MIN_BOUNDARY","RANGE_MIN","RANGE_MAX","RANGE_MAX_BOUNDARY","FORMAT"
   FROM "UNILAB".utvformat;
--------------------------------------------------------
--  DDL for View UVWEEKNR
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVWEEKNR" ("DAY_OF_YEAR", "DAY_OF_WEEK", "WEEK_NR", "YEAR_NR", "DAY_CNT", "WEEK_CNT", "DAY_OF_YEAR_TZ", "DAY_CNT1", "WEEK_CNT1", "DAY_CNT2", "WEEK_CNT2", "DAY_CNT3", "WEEK_CNT3", "DAY_CNT4", "WEEK_CNT4") AS 
  SELECT "DAY_OF_YEAR","DAY_OF_WEEK","WEEK_NR","YEAR_NR","DAY_CNT","WEEK_CNT","DAY_OF_YEAR_TZ","DAY_CNT1","WEEK_CNT1","DAY_CNT2","WEEK_CNT2","DAY_CNT3","WEEK_CNT3","DAY_CNT4","WEEK_CNT4"
   FROM "UNILAB".utweeknr;
--------------------------------------------------------
--  DDL for View UVWS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVWS" ("WS", "WT", "WT_VERSION", "DESCRIPTION", "CREATION_DATE", "CREATION_DATE_TZ", "CREATED_BY", "EXEC_START_DATE", "EXEC_START_DATE_TZ", "EXEC_END_DATE", "EXEC_END_DATE_TZ", "PRIORITY", "DUE_DATE", "DUE_DATE_TZ", "RESPONSIBLE", "SC_COUNTER", "MIN_ROWS", "MAX_ROWS", "COMPLETE", "VALID_CF", "DESCR_DOC", "DESCR_DOC_VERSION", "DATE1", "DATE1_TZ", "DATE2", "DATE2_TZ", "DATE3", "DATE3_TZ", "DATE4", "DATE4_TZ", "DATE5", "DATE5_TZ", "LAST_COMMENT", "WS_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR") AS 
  SELECT
   ws,
   wt,
   wt_version,
   description,
   creation_date,
   creation_date_tz,
   created_by,
   exec_start_date,
   exec_start_date_tz,
   exec_end_date,
   exec_end_date_tz,
   priority,
   due_date,
   due_date_tz,
   responsible,
   sc_counter,
   min_rows,
   max_rows,
   complete,
   valid_cf,
   descr_doc,
   descr_doc_version,
   date1,
   date1_tz,
   date2,
   date2_tz,
   date3,
   date3_tz,
   date4,
   date4_tz,
   date5,
   date5_tz,
   last_comment,
   ws_class,
   log_hs,
   log_hs_details,
   allow_modify,
   active,
   lc,
   lc_version,
   ss,
 'W' ar
FROM "UNILAB".utws;
--------------------------------------------------------
--  DDL for View UVWSAU
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVWSAU" ("WS", "AU", "AU_VERSION", "AUSEQ", "VALUE") AS 
  SELECT "WS","AU","AU_VERSION","AUSEQ","VALUE"
FROM "UNILAB".utwsau;
--------------------------------------------------------
--  DDL for View UVWSGK
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVWSGK" ("WS", "GK", "GK_VERSION", "GKSEQ", "VALUE") AS 
  SELECT "WS","GK","GK_VERSION","GKSEQ","VALUE"
FROM "UNILAB".utwsgk;
--------------------------------------------------------
--  DDL for View UVWSGKAVBRAKEINMILAGE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVWSGKAVBRAKEINMILAGE" ("AVBRAKEINMILAGE", "WS") AS 
  SELECT "AVBRAKEINMILAGE","WS" FROM UTWSGKavBrakeInMilage
 ;
--------------------------------------------------------
--  DDL for View UVWSGKAVRQREQUIREDREADY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVWSGKAVRQREQUIREDREADY" ("AVRQREQUIREDREADY", "WS") AS 
  SELECT "AVRQREQUIREDREADY","WS" FROM UTWSGKavRqRequiredReady;
--------------------------------------------------------
--  DDL for View UVWSGKAVTESTMETHOD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVWSGKAVTESTMETHOD" ("AVTESTMETHOD", "WS") AS 
  SELECT "AVTESTMETHOD","WS" FROM UTWSGKavTestMethod
 ;
--------------------------------------------------------
--  DDL for View UVWSGKAVTESTMETHODDESC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVWSGKAVTESTMETHODDESC" ("AVTESTMETHODDESC", "WS") AS 
  SELECT "AVTESTMETHODDESC","WS" FROM UTWSGKavTestMethodDesc
 ;
--------------------------------------------------------
--  DDL for View UVWSGKBOLDPATTERN
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVWSGKBOLDPATTERN" ("BOLDPATTERN", "WS") AS 
  SELECT "BOLDPATTERN","WS" FROM UTWSGKBoldPattern;
--------------------------------------------------------
--  DDL for View UVWSGKDRIVER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVWSGKDRIVER" ("DRIVER", "WS") AS 
  SELECT "DRIVER","WS" FROM UTWSGKDriver;
--------------------------------------------------------
--  DDL for View UVWSGKNUMBEROFREFS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVWSGKNUMBEROFREFS" ("NUMBEROFREFS", "WS") AS 
  SELECT "NUMBEROFREFS","WS" FROM UTWSGKNumberOfRefs
 ;
--------------------------------------------------------
--  DDL for View UVWSGKNUMBEROFSETS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVWSGKNUMBEROFSETS" ("NUMBEROFSETS", "WS") AS 
  SELECT "NUMBEROFSETS","WS" FROM UTWSGKNumberOfSets
 ;
--------------------------------------------------------
--  DDL for View UVWSGKNUMBEROFVARIANTS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVWSGKNUMBEROFVARIANTS" ("NUMBEROFVARIANTS", "WS") AS 
  SELECT "NUMBEROFVARIANTS","WS" FROM UTWSGKNumberOfVariants
 ;
--------------------------------------------------------
--  DDL for View UVWSGKOPENSHEETS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVWSGKOPENSHEETS" ("OPENSHEETS", "WS") AS 
  SELECT "OPENSHEETS","WS" FROM UTWSGKopensheets
 ;
--------------------------------------------------------
--  DDL for View UVWSGKOUTSOURCE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVWSGKOUTSOURCE" ("OUTSOURCE", "WS") AS 
  SELECT "OUTSOURCE","WS" FROM UTWSGKOutsource;
--------------------------------------------------------
--  DDL for View UVWSGKP_INFL_FRONT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVWSGKP_INFL_FRONT" ("P_INFL_FRONT", "WS") AS 
  SELECT "P_INFL_FRONT","WS" FROM UTWSGKp_infl_front
 ;
--------------------------------------------------------
--  DDL for View UVWSGKP_INFL_REAR
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVWSGKP_INFL_REAR" ("P_INFL_REAR", "WS") AS 
  SELECT "P_INFL_REAR","WS" FROM UTWSGKp_infl_rear
 ;
--------------------------------------------------------
--  DDL for View UVWSGKREFSETDESC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVWSGKREFSETDESC" ("REFSETDESC", "WS") AS 
  SELECT "REFSETDESC","WS" FROM UTWSGKRefSetDesc
 ;
--------------------------------------------------------
--  DDL for View UVWSGKREQUESTCODE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVWSGKREQUESTCODE" ("REQUESTCODE", "WS") AS 
  SELECT "REQUESTCODE","WS" FROM UTWSGKRequestCode
 ;
--------------------------------------------------------
--  DDL for View UVWSGKRIM
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVWSGKRIM" ("RIM", "WS") AS 
  SELECT "RIM","WS" FROM UTWSGKRim
 ;
--------------------------------------------------------
--  DDL for View UVWSGKRIMCENTRALBORE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVWSGKRIMCENTRALBORE" ("RIMCENTRALBORE", "WS") AS 
  SELECT "RIMCENTRALBORE","WS" FROM UTWSGKRimCentralBore;
--------------------------------------------------------
--  DDL for View UVWSGKRIMETFRONT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVWSGKRIMETFRONT" ("RIMETFRONT", "WS") AS 
  SELECT "RIMETFRONT","WS" FROM UTWSGKRimETfront
 ;
--------------------------------------------------------
--  DDL for View UVWSGKRIMETREAR
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVWSGKRIMETREAR" ("RIMETREAR", "WS") AS 
  SELECT "RIMETREAR","WS" FROM UTWSGKRimETrear
 ;
--------------------------------------------------------
--  DDL for View UVWSGKRIMWIDTHFRONT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVWSGKRIMWIDTHFRONT" ("RIMWIDTHFRONT", "WS") AS 
  SELECT "RIMWIDTHFRONT","WS" FROM UTWSGKRimWidthFront
 ;
--------------------------------------------------------
--  DDL for View UVWSGKRIMWIDTHREAR
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVWSGKRIMWIDTHREAR" ("RIMWIDTHREAR", "WS") AS 
  SELECT "RIMWIDTHREAR","WS" FROM UTWSGKRimWidthRear
 ;
--------------------------------------------------------
--  DDL for View UVWSGKSPEC_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVWSGKSPEC_TYPE" ("SPEC_TYPE", "WS") AS 
  SELECT "SPEC_TYPE","WS" FROM UTWSGKSPEC_TYPE
 ;
--------------------------------------------------------
--  DDL for View UVWSGKSUBPROGRAMID
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVWSGKSUBPROGRAMID" ("SUBPROGRAMID", "WS") AS 
  SELECT "SUBPROGRAMID","WS" FROM UTWSGKSubProgramID
 ;
--------------------------------------------------------
--  DDL for View UVWSGKTESTLOCATION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVWSGKTESTLOCATION" ("TESTLOCATION", "WS") AS 
  SELECT "TESTLOCATION","WS" FROM UTWSGKTestLocation
 ;
--------------------------------------------------------
--  DDL for View UVWSGKTESTPRIO
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVWSGKTESTPRIO" ("TESTPRIO", "WS") AS 
  SELECT "TESTPRIO","WS" FROM UTWSGKTestPrio
 ;
--------------------------------------------------------
--  DDL for View UVWSGKTESTSETPOSITION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVWSGKTESTSETPOSITION" ("TESTSETPOSITION", "WS") AS 
  SELECT "TESTSETPOSITION","WS" FROM UTWSGKTestSetPosition;
--------------------------------------------------------
--  DDL for View UVWSGKTESTSETSIZE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVWSGKTESTSETSIZE" ("TESTSETSIZE", "WS") AS 
  SELECT "TESTSETSIZE","WS" FROM UTWSGKTestSetSize
 ;
--------------------------------------------------------
--  DDL for View UVWSGKTESTVEHICLETYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVWSGKTESTVEHICLETYPE" ("TESTVEHICLETYPE", "WS") AS 
  SELECT "TESTVEHICLETYPE","WS" FROM UTWSGKTestVehicleType
 ;
--------------------------------------------------------
--  DDL for View UVWSGKTESTWEEK
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVWSGKTESTWEEK" ("TESTWEEK", "WS") AS 
  SELECT "TESTWEEK","WS" FROM UTWSGKTestWeek
 ;
--------------------------------------------------------
--  DDL for View UVWSGKWSPRIO
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVWSGKWSPRIO" ("WSPRIO", "WS") AS 
  SELECT "WSPRIO","WS" FROM UTWSGKWsPrio
 ;
--------------------------------------------------------
--  DDL for View UVWSGKWSTESTLOCATION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVWSGKWSTESTLOCATION" ("WSTESTLOCATION", "WS") AS 
  SELECT "WSTESTLOCATION","WS" FROM UTWSGKWsTestLocation
 ;
--------------------------------------------------------
--  DDL for View UVWSGKWSTRACK
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVWSGKWSTRACK" ("WSTRACK", "WS") AS 
  SELECT "WSTRACK","WS" FROM UTWSGKWsTrack
 ;
--------------------------------------------------------
--  DDL for View UVWSGKWSVEHICLE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVWSGKWSVEHICLE" ("WSVEHICLE", "WS") AS 
  SELECT "WSVEHICLE","WS" FROM UTWSGKWsVehicle
 ;
--------------------------------------------------------
--  DDL for View UVWSGKWSWEEK
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVWSGKWSWEEK" ("WSWEEK", "WS") AS 
  SELECT "WSWEEK","WS" FROM UTWSGKWsWeek
 ;
--------------------------------------------------------
--  DDL for View UVWSHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVWSHS" ("WS", "WHO", "WHO_DESCRIPTION", "WHAT", "WHAT_DESCRIPTION", "LOGDATE", "WHY", "TR_SEQ", "EV_SEQ", "LOGDATE_TZ") AS 
  SELECT "WS","WHO","WHO_DESCRIPTION","WHAT","WHAT_DESCRIPTION","LOGDATE","WHY","TR_SEQ","EV_SEQ","LOGDATE_TZ"
FROM "UNILAB".utwshs;
--------------------------------------------------------
--  DDL for View UVWSHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVWSHSDETAILS" ("WS", "TR_SEQ", "EV_SEQ", "SEQ", "DETAILS") AS 
  SELECT "WS","TR_SEQ","EV_SEQ","SEQ","DETAILS"
FROM "UNILAB".utwshsdetails;
--------------------------------------------------------
--  DDL for View UVWSII
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVWSII" ("WS", "ROWNR", "SC", "IC", "ICNODE", "II", "IINODE") AS 
  SELECT "WS","ROWNR","SC","IC","ICNODE","II","IINODE"
FROM "UNILAB".utwsii;
--------------------------------------------------------
--  DDL for View UVWSME
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVWSME" ("WS", "ROWNR", "SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE", "REANALYSIS") AS 
  SELECT "WS","ROWNR","SC","PG","PGNODE","PA","PANODE","ME","MENODE","REANALYSIS"
FROM "UNILAB".utwsme;
--------------------------------------------------------
--  DDL for View UVWSSC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVWSSC" ("WS", "ROWNR", "SC") AS 
  SELECT "WS","ROWNR","SC"
FROM "UNILAB".utwssc;
--------------------------------------------------------
--  DDL for View UVWT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVWT" ("WT", "VERSION", "VERSION_IS_CURRENT", "EFFECTIVE_FROM", "EFFECTIVE_FROM_TZ", "EFFECTIVE_TILL", "EFFECTIVE_TILL_TZ", "DESCRIPTION", "DESCRIPTION2", "MIN_ROWS", "MAX_ROWS", "VALID_CF", "DESCR_DOC", "DESCR_DOC_VERSION", "WS_LY", "WS_UC", "WS_UC_VERSION", "WS_LC", "WS_LC_VERSION", "INHERIT_AU", "LAST_COMMENT", "WT_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR") AS 
  SELECT
   wt,
   version,
   version_is_current,
   effective_from,
   effective_from_tz,
   effective_till,
   effective_till_tz,
   description,
   description2,
   min_rows,
   max_rows,
   valid_cf,
   descr_doc,
   descr_doc_version,
   ws_ly,
   ws_uc,
   ws_uc_version,
   ws_lc,
   ws_lc_version,
   inherit_au,
   last_comment,
   wt_class,
   log_hs,
   log_hs_details,
   allow_modify,
   active,
   lc,
   lc_version,
   ss,
 'W' ar
FROM "UNILAB".utwt;
--------------------------------------------------------
--  DDL for View UVWTAU
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVWTAU" ("WT", "VERSION", "AU", "AU_VERSION", "AUSEQ", "VALUE") AS 
  SELECT "WT","VERSION","AU","AU_VERSION","AUSEQ","VALUE"
FROM "UNILAB".utwtau;
--------------------------------------------------------
--  DDL for View UVWTHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVWTHS" ("WT", "VERSION", "WHO", "WHO_DESCRIPTION", "WHAT", "WHAT_DESCRIPTION", "LOGDATE", "WHY", "TR_SEQ", "EV_SEQ", "LOGDATE_TZ") AS 
  SELECT "WT","VERSION","WHO","WHO_DESCRIPTION","WHAT","WHAT_DESCRIPTION","LOGDATE","WHY","TR_SEQ","EV_SEQ","LOGDATE_TZ"
FROM "UNILAB".utwths;
--------------------------------------------------------
--  DDL for View UVWTHSDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVWTHSDETAILS" ("WT", "VERSION", "TR_SEQ", "EV_SEQ", "SEQ", "DETAILS") AS 
  SELECT "WT","VERSION","TR_SEQ","EV_SEQ","SEQ","DETAILS"
FROM "UNILAB".utwthsdetails;
--------------------------------------------------------
--  DDL for View UVWTROWS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVWTROWS" ("WT", "VERSION", "ROWNR", "ST", "ST_VERSION", "SC", "SC_CREATE") AS 
  SELECT "WT","VERSION","ROWNR","ST","ST_VERSION","SC","SC_CREATE"
FROM "UNILAB".utwtrows;
--------------------------------------------------------
--  DDL for View UVXSLT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVXSLT" ("OBJ_ID", "USAGE_TYPE", "SEQ", "LINE") AS 
  SELECT "OBJ_ID","USAGE_TYPE","SEQ","LINE"
   FROM "UNILAB".utxslt;
--------------------------------------------------------
--  DDL for View UVYEARNR
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."UVYEARNR" ("MONTH_OF_YEAR", "MONTH_CNT", "YEAR_CNT", "MONTH_OF_YEAR_TZ", "MONTH_CNT1", "YEAR_CNT1", "MONTH_CNT2", "YEAR_CNT2", "MONTH_CNT3", "YEAR_CNT3", "MONTH_CNT4", "YEAR_CNT4") AS 
  SELECT "MONTH_OF_YEAR","MONTH_CNT","YEAR_CNT","MONTH_OF_YEAR_TZ","MONTH_CNT1","YEAR_CNT1","MONTH_CNT2","YEAR_CNT2","MONTH_CNT3","YEAR_CNT3","MONTH_CNT4","YEAR_CNT4"
   FROM "UNILAB".utyearnr;
--------------------------------------------------------
--  DDL for View V_MLOG$_UTSC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."V_MLOG$_UTSC" ("SC", "SNAPTIME$$", "DMLTYPE$$", "OLD_NEW$$", "CHANGE_VECTOR$$", "XID$$", "RID") AS 
  SELECT
    tbl."SC",tbl."SNAPTIME$$",tbl."DMLTYPE$$",tbl."OLD_NEW$$",tbl."CHANGE_VECTOR$$",tbl."XID$$"
,        rowidtochar(rowid) rid
FROM
    mlog$_utsc tbl;
--------------------------------------------------------
--  DDL for View V_MLOG$_UTSCPA
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."V_MLOG$_UTSCPA" ("SC", "PG", "PGNODE", "PA", "PANODE", "SNAPTIME$$", "DMLTYPE$$", "OLD_NEW$$", "CHANGE_VECTOR$$", "XID$$", "RID") AS 
  SELECT
    tbl."SC",tbl."PG",tbl."PGNODE",tbl."PA",tbl."PANODE",tbl."SNAPTIME$$",tbl."DMLTYPE$$",tbl."OLD_NEW$$",tbl."CHANGE_VECTOR$$",tbl."XID$$"
,        rowidtochar(rowid) rid
FROM
    mlog$_utscpa tbl;

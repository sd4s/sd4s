--********************************************************
--let op: SCRIPT ZOVEEL MOGELIJK ALS SCRIPT STARTEN, EN NIET HANDMATIG VIA SQL*DEVELOPER COPY/PASTE STARTEN !!!!
--Aanroep:	@select_spec_data_GENXML_VW_na_1April2023_not_ENSGYO.sql
--
--********************************************************
--AD-HOC-SCRIPT VOOR ADDITIONELE EXPORT VAN RAW-MATERIALS OM ALLE SPECS VAN NA 1-APRIL-2023 TE SELECTEREN/EXPORTEREN...
--HARD-CODED:   FRAME-ID
--              STATUS
--********************************************************
--Script om RAW-MATERIALS  NEW-SPECS/REVISIONS uit Specification tables te selecteren.
--

prompt start selectie...
set define on
--MAX-SIZE VOOR LONG...
SET LONG 2000000000
--voorkom afbreken regellengte in xml  (MAX 32767)
SET LONGCHUNKSIZE 32767
--
set verify off
SET ECHO OFF
set feedback off
set termout off
set pages 0
SET WRAP ON
set linesize 1500

alter session set events '31151 trace name context forever, level 0x40000';


--spool E:\CONTACT-DataExport-Interspec\output_data\spec_data_GENXML_frame_&1._PART1_TYPE1en4_status_&2..xml
spool C:\Peter\CONTACT-EXPORT\output_data\spec_data_GENXML_rawdata_NewSpecs_after_1April2023_not_ENSGYO.xml

select '<?xml version="1.0"?>' from dual;

select dbms_xmlgen.getxmltype(
'select DISTINCT part_no '||
' , part_rev '||
' , part_description '||
' , frame_id '||
' , status '||
' , part_status '||
' , part_status_type '||
' , Base_Uom '||
' , Base_Conv_Factor '||
' , material_class_lvl0 '||
' , material_class_lvl1 '||
' , material_class_lvl2 '||
' , Supplier '||
' , Supplier_Plant '||
' , Supplier_Trade_Name '||
' , section_seq_no '||
' , seq_no '||
' , section_id '||
' , section_descr '||
' , sub_section_id '||
' , sub_section_descr '||
' , sps_type2 '||
' , Type_Descr '||
' , Type_Descr_id '||
' , Type_descr_Description      '||
' , property_group '||
' , property_group_desc '||
' , seq '||
' , property '||
' , property_desc '||
' , uom_id '||
' , uom '||
' , test_method '||
' , test_method_desc '||
' , num_1, num_2, num_3, num_4, num_5, num_6, num_7, num_8, num_9, num_10 '||
' , char_1, char_2, char_3, char_4, char_5, char_6 '||
' , boolean_1, boolean_2, boolean_3, boolean_4 '||
' , date_1, date_2 '||
' , association '||
' , association_desc '||
' , characteristic '||
' , characteristic_desc '||
' , intl '||
' , info '||
' , uom_alt_id '||
' , uom_alt_rev '||
' , tm_det_1, tm_det_2, tm_det_3, tm_det_4  '||
' , tm_set_no '||
' , association2 '||
' , association2_desc '||
' , characteristic2 '||
' , characteristic2_desc '||
' , association3 '||
' , association3_desc '||
' , characteristic3 '||
' , characteristic3_desc '||
' , sps_type '||
' , sps_display_format_rev '||
' , ref_id'||
' , DsplFrmt_Txt_AttSpc_Objct'||
' , Text_Rev '||
' , Reason_for_change '||
' from DBA_BHR_EXPORT_FRAME_SPEC  d'||
' where NOT EXISTS (select pp2.plant from part_plant pp2 where pp2.part_no = d.part_no and pp2.plant in ('||''''||'ENS'||''''||','||''''||'GYO'||''''||') )'||
' AND  d.frame_id  in ( '||
     ''''||'A_RM_Antidegradant'||''''||
','||''''||'A_RM_Aux'           ||''''||
','||''''||'A_RM_Aux_Chem'        ||''''||
','||''''||'A_RM_Aux_EA'          ||''''||
','||''''||'A_RM_Aux_Liners'      ||''''||
','||''''||'A_RM_bead_wire v1'    ||''''||
','||''''||'A_RM_chafer v1'       ||''''||
','||''''||'A_RM_Fabric v1'       ||''''||
','||''''||'A_RM_Filller v1'      ||''''||
','||''''||'A_RM_Filller Wh v1'   ||''''||
','||''''||'A_RM_Polymer v1'      ||''''||
','||''''||'A_RM_Rectbead v1'     ||''''||
','||''''||'A_RM_Resinv1'         ||''''||
','||''''||'A_RM_RubChem v1'      ||''''||
','||''''||'A_RM_Silanes v1'      ||''''||
','||''''||'A_RM_softener v1'     ||''''||
','||''''||'A_RM_SpeChem v1'      ||''''||
','||''''||'A_RM_Steel cord v1'   ||''''||
','||''''||'A_RM_Valves'          ||''''||
','||''''||'A_RM_VarRM v1'        ||''''||
','||''''||'A_RM_Vulcagents v1'   ||''''||
','||''''||'A_Man_RM_AntiD'       ||''''||
','||''''||'A_Man_RM_Aux'         ||''''||
','||''''||'A_Man_RM_Aux_EA'      ||''''||
','||''''||'A_Man_RM_Aux_Liner'   ||''''||
','||''''||'A_Man_RM_bead_wire'   ||''''||
','||''''||'A_Man_RM_chaferv1'     ||''''||
','||''''||'A_Man_RM_Fabric v1'    ||''''||
','||''''||'A_Man_RM_Filllerv1'     ||''''||
','||''''||'A_Man_RM_Fill Wv1'    ||''''||
','||''''||'A_Man_RM_Polymerv1'    ||''''||
','||''''||'A_Man_RM_rectbead'    ||''''||
','||''''||'A_Man_RM_Resinv1'     ||''''||
','||''''||'A_Man_RM_RubChemv1'   ||''''||
','||''''||'A_Man_RM_Silanesv1'   ||''''||
','||''''||'A_Man_RM_soft. v1'    ||''''||
','||''''||'A_Man_RM_SpeChem'     ||''''||
','||''''||'A_Man_RM_Steel v1'    ||''''||
','||''''||'A_Man_RM_VarRM v1'   ||''''||
','||''''||'A_Man_RM_Vulc v1'  ||''''||' ) '||
' and    d.part_status_type    = '||''''||'CURRENT'||''''||
' and    d.issued_date > to_date('||''''||'01-04-2023'||''''||','||''''||'dd-mm-yyyy'||''''||' ) '|| 
' and    d.part_rev = 1 '||
' order by 1, 13, 14 , 20 '
).getClobVal() xdoc from dual
;

SPOOL OFF;

spool C:\Peter\CONTACT-EXPORT\output_data\spec_data_GENXML_rawdata_ChangedSpecs_after_1April2023_not_ENSGYO.xml

select '<?xml version="1.0"?>' from dual;

select dbms_xmlgen.getxmltype(
'select DISTINCT part_no '||
' , part_rev '||
' , part_description '||
' , frame_id '||
' , status '||
' , part_status '||
' , part_status_type '||
' , Base_Uom '||
' , Base_Conv_Factor '||
' , material_class_lvl0 '||
' , material_class_lvl1 '||
' , material_class_lvl2 '||
' , Supplier '||
' , Supplier_Plant '||
' , Supplier_Trade_Name '||
' , section_seq_no '||
' , seq_no '||
' , section_id '||
' , section_descr '||
' , sub_section_id '||
' , sub_section_descr '||
' , sps_type2 '||
' , Type_Descr '||
' , Type_Descr_id '||
' , Type_descr_Description      '||
' , property_group '||
' , property_group_desc '||
' , seq '||
' , property '||
' , property_desc '||
' , uom_id '||
' , uom '||
' , test_method '||
' , test_method_desc '||
' , num_1, num_2, num_3, num_4, num_5, num_6, num_7, num_8, num_9, num_10 '||
' , char_1, char_2, char_3, char_4, char_5, char_6 '||
' , boolean_1, boolean_2, boolean_3, boolean_4 '||
' , date_1, date_2 '||
' , association '||
' , association_desc '||
' , characteristic '||
' , characteristic_desc '||
' , intl '||
' , info '||
' , uom_alt_id '||
' , uom_alt_rev '||
' , tm_det_1, tm_det_2, tm_det_3, tm_det_4  '||
' , tm_set_no '||
' , association2 '||
' , association2_desc '||
' , characteristic2 '||
' , characteristic2_desc '||
' , association3 '||
' , association3_desc '||
' , sps_type '||
' , sps_display_format_rev '||
' , ref_id'||
' , DsplFrmt_Txt_AttSpc_Objct'||
' , Text_Rev '||
' , Reason_for_change '||
' from DBA_BHR_EXPORT_FRAME_SPEC  d'||
' where NOT EXISTS (select pp2.plant from part_plant pp2 where pp2.part_no = d.part_no and pp2.plant in ('||''''||'ENS'||''''||','||''''||'GYO'||''''||') )'||
' AND  d.frame_id  in ( '||
     ''''||'A_RM_Antidegradant'||''''||
','||''''||'A_RM_Aux'           ||''''||
','||''''||'A_RM_Aux_Chem'        ||''''||
','||''''||'A_RM_Aux_EA'          ||''''||
','||''''||'A_RM_Aux_Liners'      ||''''||
','||''''||'A_RM_bead_wire v1'    ||''''||
','||''''||'A_RM_chafer v1'       ||''''||
','||''''||'A_RM_Fabric v1'       ||''''||
','||''''||'A_RM_Filller v1'      ||''''||
','||''''||'A_RM_Filller Wh v1'   ||''''||
','||''''||'A_RM_Polymer v1'      ||''''||
','||''''||'A_RM_Rectbead v1'     ||''''||
','||''''||'A_RM_Resinv1'         ||''''||
','||''''||'A_RM_RubChem v1'      ||''''||
','||''''||'A_RM_Silanes v1'      ||''''||
','||''''||'A_RM_softener v1'     ||''''||
','||''''||'A_RM_SpeChem v1'      ||''''||
','||''''||'A_RM_Steel cord v1'   ||''''||
','||''''||'A_RM_Valves'          ||''''||
','||''''||'A_RM_VarRM v1'        ||''''||
','||''''||'A_RM_Vulcagents v1'   ||''''||
','||''''||'A_Man_RM_AntiD'       ||''''||
','||''''||'A_Man_RM_Aux'         ||''''||
','||''''||'A_Man_RM_Aux_EA'      ||''''||
','||''''||'A_Man_RM_Aux_Liner'   ||''''||
','||''''||'A_Man_RM_bead_wire'   ||''''||
','||''''||'A_Man_RM_chaferv1'     ||''''||
','||''''||'A_Man_RM_Fabric v1'    ||''''||
','||''''||'A_Man_RM_Filllerv1'     ||''''||
','||''''||'A_Man_RM_Fill Wv1'    ||''''||
','||''''||'A_Man_RM_Polymerv1'    ||''''||
','||''''||'A_Man_RM_rectbead'    ||''''||
','||''''||'A_Man_RM_Resinv1'     ||''''||
','||''''||'A_Man_RM_RubChemv1'   ||''''||
','||''''||'A_Man_RM_Silanesv1'   ||''''||
','||''''||'A_Man_RM_soft. v1'    ||''''||
','||''''||'A_Man_RM_SpeChem'     ||''''||
','||''''||'A_Man_RM_Steel v1'    ||''''||
','||''''||'A_Man_RM_VarRM v1'   ||''''||
','||''''||'A_Man_RM_Vulc v1'  ||''''||' ) '||
' and    d.part_status_type    = '||''''||'CURRENT'||''''||
' and    d.issued_date > to_date('||''''||'01-04-2023'||''''||','||''''||'dd-mm-yyyy'||''''||' ) '|| 
' and    d.part_rev > 1 '||
' order by 1, 13, 14 , 20 '
).getClobVal() xdoc from dual
;

SPOOL OFF;


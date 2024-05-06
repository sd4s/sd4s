--********************************************************
--COMBINATION OF 2 QUERIES
-- THIS QUERY WILL EXPORT TO XML!!!
-- based on Specification tables
-- To export data from Interspec
-- Attention: first run the two lines below to set the correct frame
--set define on
--define frame = 'A_Man_RM_Silanesv1';  -- A_Man_RM_Polymerv1
--define frame = 'A_Man_RM_Polymerv1';  
--define status = 'DEVELOPMENT';
--define status = 'CURRENT';

--********************************************************
--Script om data uit Specification tables te selecteren.
--To export data from Interspec for CONTACT-software.
--Aanroep: @select_spec_data_cal_GENXML_VW_20230327.sql  <frame-id> <status-type>
--
--bijv.:   @select_spec_data_cal_GENXML_VW_20230327.sql  A_TextComp_v1  CURRENT    --> GEBRUIK "_" VOOR EENS SPATIE !! 
--bijv.:   @select_spec_data_cal_GENXML_VW_20230327.sql  A_Steelcomp_v1  CURRENT   --> GEBRUIK "_" VOOR EENS SPATIE !! 

--
--select PART_NO, FRAME_ID  from specification_header where part_no='130090'
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

set linesize 500
--set linesize 500

alter session set events '31151 trace name context forever, level 0x40000';


--spool E:\CONTACT-DataExport-Interspec\output_data\spec_data_GENXML_frame_&1._PART1_TYPE1en4_status_&2..xml
spool C:\Peter\CONTACT-EXPORT\output_data\spec_data_cal_GENXML_&1._&2..xml

select '<?xml version="1.0"?>' from dual;


select dbms_xmlgen.getxmltype(
'select '||''''||' AAAAAA'||''''||'  part_no '||
' , -1              part_rev '||
' , to_char(1)  part_description '||
' , to_char(1)  frame_id '||
' , -1          status '||
' , to_char(1)  part_status '||
' , to_char(1) part_status_type '||
' , to_char(1)  Base_Uom '||
' , -1           Base_Conv_Factor '||
' , to_char(1)  part_plant '||
' , to_char(1) material_class_lvl0 '||
' , to_char(1)  material_class_lvl1 '||
' , to_char(1)  material_class_lvl2 '||
' , to_char(1)  Supplier '||
' , to_char(1)  Supplier_Plant '||
' , to_char(1)  Supplier_Trade_Name '||
' , -1          section_seq_no '||
' , -1          seq_no '||
' , to_char(1)  section_descr '||
' , to_char(1)  sub_section_descr '||
' , -1          sps_type2 '||
' , to_char(1)  Type_Descr '||
' , to_char(1)  Type_descr_Description      '||
' , -1          seq '||
' , to_char(1)  property_desc '||
' , to_char(1)  uom '||
' , to_char(1)  test_method '||
' , -1  num_1, -1  num_2, -1  num_3, -1  num_4, -1  num_5, -1  num_6, -1  num_7, -1  num_8, -1  num_9, -1  num_10 '||
' , to_char(1)  char_1, to_char(1)  char_2, to_char(1)  char_3, to_char(1)  char_4, to_char(1) char_5, to_char(1)  char_6 '||
' , to_char(1)  boolean_1, to_char(1) boolean_2, to_char(1) boolean_3, to_char(1) boolean_4 '||
' , to_date(null)  date_1, to_date(null)  date_2 '||
' , to_char(1)  association '||
' , to_char(1)  characteristic '||
' , to_char(1)  intl '||
' , to_char(1)  info '||
' , -1         uom_alt_id '||
' , -1         uom_alt_rev '||
' , to_char(1)  tm_det_1, to_char(1)  tm_det_2, to_char(1)  tm_det_3, to_char(1)  tm_det_4  '||
' , -1          tm_set_no '||
' , to_char(1)  ass2 '||
' , to_char(1)  char2 '||
' , to_char(1)  ass3 '||
' , to_char(1) char3 '||
' , -1         sps_type '||
' , -1         sps_display_format_rev '||
' , -1         ref_id'||
' , to_char(1)  DsplFrmt_Txt_AttSpc_Objct'||
' , -1          Text_Rev '||
' from dual '||
'UNION ALL '||
'select part_no '||
' , part_rev '||
' , part_description '||
' , frame_id '||
' , status '||
' , part_status '||
' , part_status_type '||
' , Base_Uom '||
' , Base_Conv_Factor '||
' , part_plant '||
' , material_class_lvl0 '||
' , material_class_lvl1 '||
' , material_class_lvl2 '||
' , Supplier '||
' , Supplier_Plant '||
' , Supplier_Trade_Name '||
' , section_seq_no '||
' , seq_no '||
' , section_descr '||
' , sub_section_descr '||
' , sps_type2 '||
' , Type_Descr '||
' , Type_descr_Description      '||
' , seq '||
' , property_desc '||
' , uom '||
' , test_method '||
' , num_1, num_2, num_3, num_4, num_5, num_6, num_7, num_8, num_9, num_10 '||
' , char_1, char_2, char_3, char_4, char_5, char_6 '||
' , boolean_1, boolean_2, boolean_3, boolean_4 '||
' , date_1, date_2 '||
' , association '||
' , characteristic '||
' , intl '||
' , info '||
' , uom_alt_id '||
' , uom_alt_rev '||
' , tm_det_1, tm_det_2, tm_det_3, tm_det_4  '||
' , tm_set_no '||
' , ass2 '||
' , char2 '||
' , ass3 '||
' , char3 '||
' , sps_type '||
' , sps_display_format_rev '||
' , ref_id'||
' , DsplFrmt_Txt_AttSpc_Objct'||
' , Text_Rev '||
' from DBA_BHR_EXPORT_FRAME_SPEC  d'||
' where  d.frame_id         like '||''''||'&&1'||''''||
' and    d.part_status_type    = '||''''||'&&2'||''''||
--' AND    d.sps_type in (5,6,8)  '||
--' AND    rownum < 10 '||
' order by part_no, section_seq_no, seq_no , seq '
).getClobVal() xdoc from dual
;

SPOOL OFF;



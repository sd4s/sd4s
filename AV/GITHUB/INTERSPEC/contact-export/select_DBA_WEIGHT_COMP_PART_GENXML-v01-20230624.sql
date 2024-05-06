--********************************************************
--COMBINATION OF 2 QUERIES
-- THIS QUERY WILL EXPORT TO XML!!!
-- based on table = DBA_WEIGHT_COMPONENT_PART
-- To export weight-data from Interspec
-- Attention: first run the two lines below to set the correct frame

--********************************************************
--Script om data uit Specification tables te selecteren.
--To export data from Interspec for CONTACT-software.
--Aanroep: @select_DBA_WEIGHT_COMP_PART_GENXML-v01-20230624.sql

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
set linesize 200

alter session set events '31151 trace name context forever, level 0x40000';


--spool E:\CONTACT-DataExport-Interspec\output_data\spec_data_GENXML_frame_&1._PART1_TYPE1en4_status_&2..xml
spool C:\Peter\CONTACT-EXPORT\output_data\DBA_WEIGHT_COMPONENT_PART_GENXML_20230624_2.xml

select '<?xml version="1.0"?>' from dual;

select dbms_xmlgen.getxmltype(
'select  datum_verwerking, mainpart,mainrevision,mainframeid,lvl_tree,part_no,revision,alternative,header_status,component_part_no,component_revision,component_status,quantity_path,comp_gewicht_path_top_down '|| 
' ,result_bepaal_header_gewicht, tyre_related_comp_gewicht, sap_article_code, sap_da_article_code '||
' from DBA_V_WEIGHT_COMP_PART dba '
).getClobVal() xdoc from dual
;

SPOOL OFF;



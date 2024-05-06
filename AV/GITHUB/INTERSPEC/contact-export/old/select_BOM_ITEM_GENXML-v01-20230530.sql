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
--Aanroep: @select_spec_data_GENXML_VW_20230327.sql  <frame-id> <status-type>
--bijv.:   @select_spec_data_GENXML_VW_20230327.sql  A_PCR  CURRENT
--bijv.:   @select_spec_data_GENXML_VW_20230327.sql  A_Man_RM_Aux  CURRENT
--bijv.:   @select_spec_data_GENXML_VW_20230327.sql  A_RM_softener_v1  CURRENT             --> GEBRUIK "_" VOOR EENS SPATIE !! 
--bijv.:   @select_spec_data_GENXML_VW_20230327.sql  A_RM_Polymer_v1  CURRENT              --> GEBRUIK "_" VOOR EENS SPATIE !! 
--bijv.:   @C:\Peter\issues\issue-107-CONTACT-EXPORT\select_spec_data_GENXML_VW_20230327.sql  A_RM_Silanes_v1  CURRENT              --> GEBRUIK "_" VOOR EENS SPATIE !! 

--bijv.:   @select_spec_data_GENXML_VW_20230327.sql  A_Man_RM_Aux  CURRENT

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
set linesize 100

alter session set events '31151 trace name context forever, level 0x40000';


--spool E:\CONTACT-DataExport-Interspec\output_data\spec_data_GENXML_frame_&1._PART1_TYPE1en4_status_&2..xml
spool C:\Peter\CONTACT-EXPORT\output_data\MV_BOM_ITEM_COMP_HEADER_GENXML.xml

select '<?xml version="1.0"?>' from dual;

select dbms_xmlgen.getxmltype(
'select  part_no, revision, plant, alternative, preferred, base_quantity, status, issued_date, frame_id, item_number, '||
'        component_part, comp_revision, comp_plant, comp_alternative, comp_preferred, comp_base_quantity, comp_status, comp_issued_date, comp_frame_id, quantity, uom, characteristic '||
' from MV_BOM_ITEM_COMP_HEADER mv '||
' order by 1 '
).getClobVal() xdoc from dual
;

SPOOL OFF;



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
set linesize 4000

alter session set events '31151 trace name context forever, level 0x40000';


--spool E:\CONTACT-DataExport-Interspec\output_data\spec_data_GENXML_frame_&1._PART1_TYPE1en4_status_&2..xml
spool C:\Peter\CONTACT-EXPORT\output_data\ITOID_RAW_GENXML.xml

select '<?xml version="1.0"?>' from dual;

select dbms_xmlgen.getxmltype(
'select sps.part_no, sps.section_id, sps.sub_section_id, sps.ref_id, sps.type, i.file_name, r.desktop_object '||
' from specification_section sps '||
' ,    ITOID                 i '||
' ,    ITOIRAW               r '||
' where sps.part_no = '||''''||'160280_GEN_LAN'||''''||
' and   sps.type = 6 '||
' and   sps.ref_id = i.object_id '||
' AND   sps.ref_ver = i.revision '||
' and   sps.ref_owner = i.owner '||
' AND   i.object_id = r.object_id '||
' and   i.revision  = r.revision '||
' order by 1 '
).getClobVal() xdoc from dual
;

SPOOL OFF;



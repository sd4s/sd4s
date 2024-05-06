--
--Aanroep: @select_ITOID_SafetyDataSheets_PDF_GENXML.sql    <sectie-id>  <filename extentie zonder punt>  <object-id-prefix>
--
--         @select_ITOID_SafetyDataSheets_PDF_GENXML.sql   701035   pdf     --loopt vast op RAW-data, unable to extend TEMP-segment !!
--         @select_ITOID_SafetyDataSheets_PDF_GENXML.sql   701035   txt     --done
--         @select_ITOID_SafetyDataSheets_PDF_GENXML.sql   701035   CATPart --loopt vast op RAW-data
--         @select_ITOID_SafetyDataSheets_PDF_GENXML.sql   701035   stp     --loopt vast op RAW-data
--         @select_ITOID_SafetyDataSheets_PDF_GENXML.sql   701035   inc      --done
--         @select_ITOID_SafetyDataSheets_PDF_GENXML.sql   701035   xls     --done
--         @select_ITOID_SafetyDataSheets_PDF_GENXML.sql   701035   doc     --done
--         @select_ITOID_SafetyDataSheets_PDF_GENXML.sql   700581   alle      --
--         @select_ITOID_SafetyDataSheets_PDF_GENXML.sql   700582   alle      --
--         @select_ITOID_SafetyDataSheets_PDF_GENXML.sql   700635   alle      --decode('alle','%') + TOEVOEGEN AAN QUERY:  NOT IN ('')
--         @select_ITOID_SafetyDataSheets_PDF_GENXML.sql   700955   alle      --700955	Specification	
--         @select_ITOID_SafetyDataSheets_PDF_GENXML.sql   701035   alle      --
--         @select_ITOID_SafetyDataSheets_PDF_GENXML.sql   701095   alle      --701095	Labels and certification
--
--total ORACLEPROD:
--         @select_ITOID_SafetyDataSheets_PDF_GENXML_oracleprod.sql   700577   alle      --700577	Chemical and physical properties
--         @select_ITOID_SafetyDataSheets_PDF_GENXML_oracleprod.sql   700578   alle      --700578	Controlplan
--         @select_ITOID_SafetyDataSheets_PDF_GENXML_oracleprod.sql   700579   alle      --700579	General information	
--         @select_ITOID_SafetyDataSheets_PDF_GENXML_oracleprod.sql   700580   alle      --700580	Global specification	
--         @select_ITOID_SafetyDataSheets_PDF_GENXML_oracleprod.sql   700581   alle      --700581	Storage, Logistics & Packaging
--         @select_ITOID_SafetyDataSheets_PDF_GENXML_oracleprod.sql   700582   alle      --700582	Permissable deviations
--         @select_ITOID_SafetyDataSheets_PDF_GENXML_oracleprod.sql   700583   alle      --700583	Processing
--         @select_ITOID_SafetyDataSheets_PDF_GENXML_oracleprod.sql   700584   alle      --700584	Properties
--         @select_ITOID_SafetyDataSheets_PDF_GENXML_oracleprod.sql   700586   alle      --700586	TCE	
--         @select_ITOID_SafetyDataSheets_PDF_GENXML_oracleprod.sql   700635   alle      --700635	Safety Datasheet
--         @select_ITOID_SafetyDataSheets_PDF_GENXML_oracleprod.sql   700935   alle      --700935	Design Information	
--         @select_ITOID_SafetyDataSheets_PDF_GENXML_oracleprod.sql   700955   alle      --700955	Specification
--         @select_ITOID_SafetyDataSheets_PDF_GENXML_oracleprod.sql   701015   alle      --701015	FEA material definition	
--         @select_ITOID_SafetyDataSheets_PDF_GENXML_oracleprod.sql   701035   alle      --701035	QESH	
--         @select_ITOID_SafetyDataSheets_PDF_GENXML_oracleprod.sql   701058   alle      --701058	Processing Gyongyoshalasz	
--         @select_ITOID_SafetyDataSheets_PDF_GENXML_oracleprod.sql   701155   alle      --701155	New Vendor and raw material development request
--
--Te groot om in 1x te verwerken:
--         @select_ITOID_SafetyDataSheets_PDF_GENXML_oracleprod.sql   700835   alle      --700835	D-spec  (=te groot voor 1x, OBJECT_ID like 1,4,5,6,7,8,9)
--         @select_ITOID_SafetyDataSheets_PDF_GENXML_oracleprod.sql   701095   alle      --701095	Labels and certification (=te groot, only 100 rows!!!)


-- LET OP: SCRIPT DRAAIEN ALS SCRIPT, NIET MET KNIPPEN/PLAKKEN IN SQL*PLUS/DEVELOPER OMDAT WE ANDERS
--         DE TERMOUT-REGELS ER NOG UIT MOETEN HALEN.

--********************************************************
--Script om data uit Specification tables te selecteren.
--To export data from Interspec for CONTACT-software.
--********************************************************
--COMBINATION OF 2 QUERIES
-- THIS QUERY WILL EXPORT TO XML!!!
-- based on Specification tables To export data from Interspec
--
--************************************************************
--SPECIFICATION-TYPE:
--when sps.type = 1 then 'Property Group'
--when sps.type = 2 then 'Reference Text'
--when sps.type = 3 then 'BOM'
--when sps.type = 4 then 'Single Property'
--when sps.type = 5 then 'Free Text'
--when sps.type = 6 then 'Object'
--when sps.type = 7 then 'Process Data'
--when sps.type = 8 then 'Attached Specification'
--when sps.type = 9 then 'Ingredient List'
--when sps.type = 10 then 'Base Name'
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


/*
select dbms_xmlgen.getxmltype(
'select sps.part_no, sps.section_id, sps.sub_section_id, sps.ref_id, sps.type, i.file_name, r.desktop_object '||
' from specification_section sps '||
' ,    ITOID                 i '||
' ,    ITOIRAW               r '||
' where sps.type = 6 '||
' and   sps.ref_id = i.object_id '||
' AND   sps.ref_ver = i.revision '||
' and   sps.ref_owner = i.owner '||
' AND   i.object_id = r.object_id '||
' and   i.revision  = r.revision '||
' order by 1 '
).getClobVal() xdoc from dual
;
--where sps.part_no = '||''''||'160280_GEN_LAN'||''''||
*/

--WE MAKEN WEL IEDERE KEER EEN VOLLEDIGE EXPORT VAN ADMIN-DATA OBJECT-ID=6 !!!

prompt VOOR OBJECT

--spool C:\Peter\CONTACT-EXPORT\output_data\ITOID_SafetyDataSheets_OBJECT_GENXML_++1.++2..xml

spool E:\CONTACT-DataExport-Interspec\output_data\ITOID_SafetyDataSheets_OBJECT_GENXML_&&1.&&2..xml

select '<?xml version="1.0"?>' from dual;

select dbms_xmlgen.getxmltype(
'SELECT sps.part_no, sps.revision, sps.section_id, sps.sub_section_id, sps.ref_id, sps.ref_ver, sps.type '||
' ,     i.file_name, i.revision '||
' from ITOID   i '||
' JOIN ITOIRAW r                   ON  i.object_id = r.object_id AND i.revision  = r.revision  '||
' JOIN specification_section sps   ON  sps.ref_id  = i.object_id AND sps.ref_ver = i.revision AND   sps.ref_owner = i.owner and sps.section_id = &&1 '||
' JOIN specification_header  sh    ON  sh.part_no = sps.part_no  AND sh.revision = sps.revision '||
' JOIN status  s                   ON  s.status = sh.status      AND s.status_type = ''CURRENT'' '||
' where sps.type = 6  '||
' and   substr(i.file_name, instr(i.file_name,'||''''||'.'||''''||',-1)+1) like decode(''&&2'',''alle'',''%'',''&&2'')'
).getClobVal() xdoc from dual
;


SPOOL OFF;



prompt VOOR RAW:

--spool C:\Peter\CONTACT-EXPORT\output_data\ITOID_SafetyDataSheets_RAW_CURRENT_GENXML_++1.++2-++3..xml
spool E:\CONTACT-DataExport-Interspec\output_data\ITOID_SafetyDataSheets_RAW_CURRENT_GENXML_&&1.&&2-&&3..xml

select '<?xml version="1.0"?>' from dual;

select dbms_xmlgen.getxmltype(
'SELECT i.object_id, i.revision, i.file_name, r.desktop_object '||
' from ITOID   i '||
' JOIN ITOIRAW r  ON  i.object_id = r.object_id AND   i.revision  = r.revision  '||
' JOIN specification_section sps   ON  sps.ref_id  = i.object_id AND sps.ref_ver = i.revision AND   sps.ref_owner = i.owner and sps.section_id = &&1 '||
' JOIN specification_header  sh    ON  sh.part_no = sps.part_no  AND sh.revision = sps.revision '||
' JOIN status  s                   ON  s.status = sh.status      AND s.status_type = ''CURRENT'' '||
' WHERE length(r.desktop_object) > 0 '||
' and   sps.type = 6  '||
' and   substr(i.file_name, instr(i.file_name,'||''''||'.'||''''||',-1)+1) like decode(''&&2'',''alle'',''%'',''&&2'')'  
--|| ' and rownum < 100 '
|| 'AND (  substr(i.object_id,1,1) in ( &&3 ) OR substr(i.object_id,1,2) in ( &&3 )  OR substr(i.object_id,1,3) in ( &&3 )  ) ' 
).getClobVal() xdoc from dual
;


SPOOL OFF;

/*
--hier blijft proces hangen !!!!
<OBJECT_ID>41138</OBJECT_ID>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
<REVISION>1</REVISION>  
*/  

EXIT;

--einde script


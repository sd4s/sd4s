--********************************************************
--COMBINATION OF 2 QUERIES
-- THIS QUERY WILL EXPORT TO XML!!!
-- based on Specification tables To export data from Interspec
--
--SECTION:   700635	 Safety Datasheet
--
--SELECT sps.section_id, sps.type, count(*) from specification_section sps where section_id = 700635 group by sps.section_id, sps.type
--700635	6	7824   --> only this one related to ITOID !!!!
--700635	1	2059
--700635	5	309
--
--
SELECT sps.section_id, s.description, sps.type, count(*) 
from specification_section sps 
JOIN section               s    on s.section_id = sps.section_id 
JOIN specification_header  sh   ON  sh.part_no = sps.part_no AND sh.revision = sps.revision
JOIN status                st   ON  st.status = sh.status AND st.status_type = 'CURRENT'
where sps.type = 6 
group by sps.section_id, s.description, sps.type
;

/*
--CURRENT-STATUS:
701035	QESH								6	3604
700582	Permissable deviations				6	548
700635	Safety Datasheet					6	2335
700581	Storage, Logistics & Packaging		6	26
700955	Specification						6	2
701095	Labels and certification			6	9608
700580	Global specification				6	21187
700583	Processing							6	816
701058	Processing Gyongyoshalasz			6	61
701155	New Vendor and raw material development request	6	2
701015	FEA material definition				6	21682
700935	Design Information					6	815
700577	Chemical and physical properties	6	208
700578	Controlplan							6	121
700579	General information					6	218
700586	TCE									6	37620
700835	D-spec								6	34299
700584	Properties							6	139

--all STATUS:
701035	QESH								6	4553       --> QESH
700582	Permissable deviations				6	804
700635	Safety Datasheet					6	7824       --> nu gebruikt...
700581	Storage, Logistics & Packaging		6	76
700955	Specification						6	58
701095	Labels and certification			6	30726
700815	Summary								6	68
700580	Global specification				6	28448
700583	Processing							6	2651
701058	Processing Gyongyoshalasz			6	275
700855	Include (files)						6	19
701155	New Vendor and raw material development request	6	4
701015	FEA material definition				6	60244
700935	Design Information					6	8517
700577	Chemical and physical properties	6	670
700578	Controlplan							6	854
700579	General information					6	497
700586	TCE									6	45517
700835	D-spec								6	86230
700584	Properties							6	715
*/


--
--Aanroep: @select_ITOID_SafetyDataSheets_PDF_GENXML.sql    <filename extentie zonder punt>
--
--         @select_ITOID_SafetyDataSheets_PDF_GENXML.sql   701035   pdf     --loopt vast op RAW-data, unable to extend TEMP-segment !!
--         @select_ITOID_SafetyDataSheets_PDF_GENXML.sql   701035   txt     --done
--         @select_ITOID_SafetyDataSheets_PDF_GENXML.sql   701035   CATPart --loopt vast op RAW-data
--         @select_ITOID_SafetyDataSheets_PDF_GENXML.sql   701035   stp     --loopt vast op RAW-data
--         @select_ITOID_SafetyDataSheets_PDF_GENXML.sql   701035   inc      --done
--         @select_ITOID_SafetyDataSheets_PDF_GENXML.sql   701035   xls     --done
--         @select_ITOID_SafetyDataSheets_PDF_GENXML.sql   701035   doc     --done
--
--         @select_ITOID_SafetyDataSheets_PDF_GENXML.sql   701035   alle      --decode('alle','%') + TOEVOEGEN AAN QUERY:  NOT IN ('')

--
-- LET OP: SCRIPT DRAAIEN ALS SCRIPT, NIET MET KNIPPEN/PLAKKEN IN SQL*PLUS/DEVELOPER OMDAT WE ANDERS
--         DE TERMOUT-REGELS ER NOG UIT MOETEN HALEN.

--********************************************************
--Script om data uit Specification tables te selecteren.
--To export data from Interspec for CONTACT-software.

/*
--VOORONDERZOEK RESULTS/PERFORMANCE
select count(*) from specification_section;
--8.024.266
select count(*) from itoid;
--59.122
select count(distinct OBJECT_ID) from itoid;
--59.005
select count(*) from itoiraw;
--59.122  (=gelijk aan itoid !!!)
*/

/*
select count(*)
select count(sps.part_no)
--

--SELECT /+ LEADING(ITOID) INDEX(sps PK_SPECIFICATION_SECTION) / sps.part_no, sps.revision, sps.section_id, sps.sub_section_id, sps.ref_id, sps.ref_ver, sps.type, i.file_name, i.revision, r.object_id, r.revision    --, r.desktop_object
select sps.part_no, sps.revision, sps.section_id, sps.sub_section_id, sps.ref_id, sps.ref_ver, sps.type, i.file_name, i.revision, r.object_id, r.revision    --, r.desktop_object
from ITOID   i
JOIN specification_section sps   ON  sps.ref_id  = i.object_id AND   sps.ref_ver = i.revision AND   sps.ref_owner = i.owner 
JOIN specification_header  sh    ON  sh.part_no = sps.part_no AND sh.revision = sps.revision
JOIN status  s                   ON  s.status = sh.status AND s.status_type = 'CURRENT'
JOIN ITOIRAW r  ON  i.object_id = r.object_id AND   i.revision  = r.revision 
where sps.type = 6 
and   (   (   substr(i.file_name, instr(i.file_name,'.',-1)+1)     like decode('overig','overig','%','overig')
          and   substr(i.file_name, instr(i.file_name,'.',-1)+1) NOT IN ('pdf','txt','CATPart','stp','inc','xls','doc')
		  )
      or   substr(i.file_name, instr(i.file_name,'.',-1)+1) like 'doc'
	  )
--and   sps.revision = (select max(sps2.revision) 
--                      from specification_section sps2 
--					  where sps2.part_no = sps.part_no 
--					  and sps2.ref_id = sps.ref_id 
--					  and sps2.ref_ver = sps.ref_ver )
;
--order by 1 ,2

--AANTAL TOTAAL PARTNO-REFID: 150806
--AANTAL DISTINCT REF-ID: 52423
--AANTAL DISTINCT PARTNO-REFID: 133294

102283B_MIL_GEN	1	701035	0	104479	6	MSDS_102283B_milliken code 2283.pdf	1	104479	1
102283B_MIL_GEN	1	701035	0	104479	6	MSDS_102283B_milliken code 2283.pdf	1	104479	1
102283B_MIL_GEN	1	701035	0	104479	6	MSDS_102283B_milliken code 2283.pdf	1	104479	1

select * from specification_section where part_no = '102283B_MIL_GEN' ; 
--part-no komt met meerdere REVISION voor, bij hetzelfde REF-ID/REF-VER !!!


SELECT substr(sps.part_no,1,3) , count(*)
from ITOID   i
JOIN specification_section sps   ON  sps.ref_id  = i.object_id AND   sps.ref_ver = i.revision AND   sps.ref_owner = i.owner 
JOIN ITOIRAW r  ON  i.object_id = r.object_id AND   i.revision  = r.revision 
where sps.type = 6 
and   sps.revision = (select max(sps2.revision) from specification_section sps2 where sps2.part_no = sps.part_no and sps2.ref_id = sps.ref_id and sps2.ref_ver = sps.ref_ver)
group by substr(sps.part_no,1,3)
;
--133.000
--CONCLUSIE: Er komen PART-NO voor met meerdere REF-TEXTs!!

SELECT sps.part_no, sps.type, i.object_id, count(*)
from ITOID   i
JOIN specification_section sps   ON  sps.ref_id  = i.object_id AND   sps.ref_ver = i.revision AND   sps.ref_owner = i.owner and sps.section_id = 700635
JOIN ITOIRAW r  ON  i.object_id = r.object_id AND   i.revision  = r.revision 
where sps.type in ( 6 )
and   sps.revision = (select max(sps2.revision) from specification_section sps2 where sps2.part_no = sps.part_no and sps2.ref_id = sps.ref_id and sps2.ref_ver = sps.ref_ver)
group by sps.part_no
having count(*) > 1
;
130901_ASA_SIN	2
164312_EVE_EIJ	3
140203_TOT_HAR	2
160774_LAN_DOR	3
130962B_GRP_ANK	2
160326_RHE_USA	3
--
160007_MDH_MEH	63109	1

--onderzoek type bestanden...
select substr(i.file_name, instr(i.file_name,'.',-1)+1) ext, count(*)
from ITOID i
--where substr(i.file_name, instr(i.file_name,'.',-1)+1) like 'doc'
group by substr(i.file_name, instr(i.file_name,'.',-1)+1)
;
/*
pdf	23964
txt	16783
CATPart	9335
stp	6462
inc	388
xls	316
doc	293
...
etc
*/


/*
--FILE-FORMATS ONLY FOR CURRENT SPECS FOR SECTION-ID = 700635 !!!
--
SELECT substr(i.file_name, instr(i.file_name,'.',-1)+1) ext, count(*)
from ITOID   i
JOIN specification_section sps   ON  sps.ref_id  = i.object_id AND   sps.ref_ver = i.revision AND   sps.ref_owner = i.owner and sps.section_id = 700635
JOIN specification_header  sh    ON  sh.part_no = sps.part_no  AND sh.revision = sps.revision 
JOIN status  s                   ON  s.status = sh.status      AND s.status_type = 'CURRENT'
where sps.type in ( 6 )
--and   sps.revision = (select max(sps2.revision) from specification_section sps2 where sps2.part_no = sps.part_no and sps2.ref_id = sps.ref_id and sps2.ref_ver = sps.ref_ver)
group by substr(i.file_name, instr(i.file_name,'.',-1)+1) 
ORDER by substr(i.file_name, instr(i.file_name,'.',-1)+1) 
;

5 ENG	1
DOC		1
PDF		26
doc		50
docx	2
msg		5
pdf		1003
rtf		2
tif		2
--
--NOT IN ('5 ENG')
*/

/*
--FILE-FORMATS ONLY FOR CURRENT SPECS FOR SECTION-ID = 701035 !!!
--
SELECT substr(i.file_name, instr(i.file_name,'.',-1)+1) ext, count(*)
from ITOID   i
JOIN specification_section sps   ON  sps.ref_id  = i.object_id AND   sps.ref_ver = i.revision AND   sps.ref_owner = i.owner and sps.section_id = 701035
JOIN specification_header  sh    ON  sh.part_no = sps.part_no  AND sh.revision = sps.revision 
JOIN status  s                   ON  s.status = sh.status      AND s.status_type = 'CURRENT'
where sps.type in ( 6 )
--and   sps.revision = (select max(sps2.revision) from specification_section sps2 where sps2.part_no = sps.part_no and sps2.ref_id = sps.ref_id and sps2.ref_ver = sps.ref_ver)
group by substr(i.file_name, instr(i.file_name,'.',-1)+1) 
ORDER by substr(i.file_name, instr(i.file_name,'.',-1)+1) 
;
--
PDF		90
html	1
pdf		1502
tif		1
*/


/*
select count(*) 
from itoiraw   r
where length(r.desktop_object) > 0
;
--58904 (>0 dus wel aanwezig)
--61 bestanden leeg !!

SELECT i.file_name, i.revision, r.object_id, r.revision    
from ITOID   i
JOIN ITOIRAW r  ON  i.object_id = r.object_id AND   i.revision  = r.revision 
where substr(i.file_name, instr(i.file_name,'.',-1)+1)     like decode('overig','overig','%','overig')
and   substr(i.file_name, instr(i.file_name,'.',-1)+1) NOT IN ('pdf','txt','CATPart','stp','inc','xls','doc')
;
*/



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


prompt VOOR OBJECT

spool C:\Peter\CONTACT-EXPORT\output_data\ITOID_SafetyDataSheets_OBJECT_GENXML_&&1.&&2..xml

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

--' and   (   (    substr(i.file_name, instr(i.file_name,'||''''||'.'||''''||',-1)+1) like decode(''++1'',''alle'',''%'',''++1'')'||
--'           and   substr(i.file_name, instr(i.file_name,'||''''||'.'||''''||',-1)+1) NOT IN (''pdf'',''txt'',''CATPart'',''stp'',''inc'',''xls'',''doc'')'||
--'           ) '||
--'       or  substr(i.file_name, instr(i.file_name,'||''''||'.'||''''||',-1 )+1) like ''++1'''||
--'       ) '
--
--' and   sps.revision = (select max(sps2.revision) ' ||
--'                       from specification_section sps2 '||
--'                       where sps2.part_no = sps.part_no '||
--'                       and sps2.ref_id    = sps.ref_id '||
--'                       and sps2.ref_ver   = sps.ref_ver  ) '

--' ,     r.desktop_object '||
--' AND   rownum < 5 ' 
--' order by 1,2 ' 

SPOOL OFF;



prompt VOOR RAW:

spool C:\Peter\CONTACT-EXPORT\output_data\ITOID_SafetyDataSheets_RAW_CURRENT_GENXML_&&1.&&2..xml

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
).getClobVal() xdoc from dual
;

--' and   substr(i.file_name, instr(i.file_name,'||''''||'.'||''''||',-1 )+1) like ''++1'''
--'           and   substr(i.file_name, instr(i.file_name,'||''''||'.'||''''||',-1)+1) NOT IN (''pdf'',''txt'',''CATPart'',''stp'',''inc'',''xls'',''doc'')'||
--' and   i.object_id = 41138 '||
--' and rownum < 100 '
--' ,     r.desktop_object '||
--' AND   rownum < 5 ' 
--' order by 1,2 ' 

SPOOL OFF;

/*
--hier blijft proces hangen !!!!
<OBJECT_ID>41138</OBJECT_ID>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
<REVISION>1</REVISION>  
*/  

--einde script


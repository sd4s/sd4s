---------  Script ---------
--- make a list of reference texts
--
-- AANROEP: @select-reftext-all-GENXML.sql 
--
-- LET OP: SCRIPT DRAAIEN ALS SCRIPT, NIET MET KNIPPEN/PLAKKEN IN SQL*PLUS/DEVELOPER OMDAT WE ANDERS
--         DE TERMOUT-REGELS ER NOG UIT MOETEN HALEN.
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

set linesize 1000
--set linesize 500

alter session set events '31151 trace name context forever, level 0x40000';

/*
--VOORONDERZOEK TBV VERGELIJKING XLS VAN PATRICK-SIMON DIE HIJ WAARSCHIJNLIJK VAN NICO GEEVERS GEHAD HEEFT, EN ONZE LEVERING...

select r.ref_text_type, r.text_revision, r.status, length(r.text)
from reference_text  r
where status in (1,2)
order by length(text)
; 
select distinct r.ref_text_type
from reference_text  r
; 
--197 unique rows

--select REF-TEXTS only LATEST-REVISION (all statusses, 1=DEV, 2=CURRENT, 3=HISTORIC)
select r.ref_text_type, t.description, r.text_revision, r.status, length(r.text)
from reference_text  r
,    ref_text_type   t
where r.lang_id = 1
--and   r.text is not null
--and  r.status in (1,2)
and  r.text_revision = (select max(r2.text_revision) from reference_text r2 where r2.ref_text_type = r.ref_text_type and r2.lang_id=1)
and  r.ref_text_type = t.ref_text_type and r.owner = t.owner and t.lang_id=1
--and exists (select '' from ref_text_type typ where r.ref_text_type = typ.ref_text_type and lang_id=1)
order by r.ref_text_type, r.text_revision, length(text)
; 
--CONCLUSION:
--In spreadsheet from Patrick Simon there are: -all revisions
--                                             -all statusses
*/


spool C:\Peter\CONTACT-EXPORT\output_data\reftext_all_XMLTYPE.xml

--select '<?xml version="1.0"?>' from dual;

select xmltype(
cursor(
select t.ref_text_type
,      t.description
,      t.sort_desc
,      r.text_revision
,      r.status
,      r.text
from reference_text r 
JOIN ref_text_type  t on t.ref_text_type = r.ref_text_type  and   t.lang_id = r.lang_id  and   t.owner  = r.owner
where t.lang_id = 1
and   r.text_revision = (select max(r2.text_revision) from reference_text r2 where r2.ref_text_type = r.ref_text_type and r2.lang_id=1)
--and   txt.status = 2
order by t.ref_text_type
,        r.text_revision
)
).getClobVal() xdoc from dual
;


SPOOL OFF;



--einde script


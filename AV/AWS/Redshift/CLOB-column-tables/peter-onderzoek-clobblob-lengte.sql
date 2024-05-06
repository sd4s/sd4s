--analyse op TEST-CLOB en BLOB-columns om te zien hoe groot dit soort velden zijn.
--
--NCLOB NVARCHAR (maximum LOB size)	The maximum LOB size cannot exceed 63 KB.
--                Amazon Redshift doesn't support VARCHARs larger than 64 KB.
--CLOB VARCHAR (maximum LOB size)		The maximum LOB size cannot exceed 63 KB.
--                Amazon Redshift doesn't support VARCHARs larger than 64 KB.


--bulk-max-size – Set this value to a zero or non-zero value in kilobytes, depending on the mode as
--described for the previous items. In limited mode, you must set a nonzero value for this parameter.
--The instance converts LOBs to binary format. Therefore, to specify the largest LOB you need to
--replicate, multiply its size by three. For example, if your largest LOB is 2 MB, set bulk-max-size to 6,000 (6 MB).
--


--UNILAB:
--UTBLOB      DATA          BLOB

--INTERSPEC:
--FRAME_TEXT           TEXT                CLOB
--ITOIRAW              DESKTOP_OBJECT       BLOB
--ITPRNOTE             TEXT                CLOB
--REFERENCE_TEXT       TEXT                CLOB
--SPECIFICATION_TEXT   TEXT                CLOB


select dbms_lob.getlength(blb.DATA) lengte from utblob where rownum < 5;

select max(dbms_lob.getlength(blb.DATA)) / 1024 / 1024  lengte_mb from utblob blb where rownum < 1000;
--9 MB
select max(dbms_lob.getlength(blb.DATA)) / 1024 / 1024  lengte_mb from utblob blb ;
--max over alles: 367 MB
--Hoeveel groter dan 100MB? 
select count(*) from utblob blb  where (dbms_lob.getlength(blb.DATA) / 1024 / 1024 ) > 100
--21 stuks
--Hoeveel groter dan 1 MB?
select count(*) from utblob blb  where (dbms_lob.getlength(blb.DATA) / 1024 / 1024 ) > 1
--7883 stuks

--conclusie: max-grootte ligt hoger dan de 100MB (d


--INTERSPEC:
--FRAME_TEXT           TEXT                CLOB
--ITOIRAW              DESKTOP_OBJECT       BLOB
--ITPRNOTE             TEXT                CLOB
--REFERENCE_TEXT       TEXT                CLOB
--SPECIFICATION_TEXT   TEXT                CLOB

--
select max(dbms_lob.getlength(fr.TEXT)) / 1024 / 1024 lengte_mb , max(dbms_lob.getlength(fr.TEXT)) / 1024  lengte_kb from frame_text fr ;
--0.00316715240478515625	3.2431640625
select max(dbms_lob.getlength(no.TEXT)) / 1024 / 1024  lengte_mb,  max(dbms_lob.getlength(no.TEXT)) / 1024 lengte_kb from itprnote no ;
--0.0003643035888671875	    0.373046875
select max(dbms_lob.getlength(rt.TEXT)) / 1024 / 1024  lengte_mb , max(dbms_lob.getlength(rt.TEXT)) / 1024 lengte_kb from  reference_text rt ;
--0.00155925750732421875	1.5966796875
select max(dbms_lob.getlength(st.TEXT)) / 1024 / 1024  lengte_mb ,max(dbms_lob.getlength(st.TEXT)) / 1024 lengte_kb  from  specification_text st ;
--0.00399017333984375	    4.0859375

select max(dbms_lob.getlength(r.DESKTOP_OBJECT)) / 1024 / 1024  lengte_mb ,max(dbms_lob.getlength(r.DESKTOP_OBJECT)) / 1024 lengte_kb  from itoiraw r ;
--37.8560943603515625	38764.640625


prompt
prompt einde script
prompt





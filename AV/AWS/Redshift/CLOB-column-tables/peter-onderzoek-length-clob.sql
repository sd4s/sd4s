--Onderzoek naar de lengte van de CLOB-columns 

--INTERSPEC:
/*
30	INTERSPC	FRAME_TEXT	J	ALL	N		 COLUMN=TEXT=CLOB
57	INTERSPC	ITPRNOTE	J	ALL	N		 COLUMN=TEXT=CLOB
78	INTERSPC	REFERENCE_TEXT	J	ALL	N		 COLUMN=TEXT=CLOB
88	INTERSPC	SPECIFICATION_TEXT	J	ALL	N		 COLUMN=TEXT=CLOB
*/

--UNILAB
--nvt.


select lengte
from (select (length(text)) lengte from frame_text where length(text) is not null order by length(text) desc   )
where rownum < 10
;

select max(length(text)) lengte from frame_text where length(text) is not null    ;
--3321 

select max(length(text)) lengte from ITPRNOTE where length(text) is not null    ;
--11710

select max(length(text)) lengte from REFERENCE_TEXT where length(text) is not null    ;
--2228

select max(length(text)) lengte from SPECIFICATION_TEXT where length(text) is not null    ;
--4184



--CONCLUSIION: SHOULD ALL FIT IN VARCHAR2-FIELD IN REDSHIFT !!!!!!!!
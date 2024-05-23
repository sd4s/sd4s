--reguliere expressies tbv validatie van de inhoud van UTSCMECELL-tabel.
--
/*
Name         Null?    Type                
------------ -------- ------------------- 
SC           NOT NULL VARCHAR2(20 CHAR)   
PG           NOT NULL VARCHAR2(20 CHAR)   
PGNODE       NOT NULL NUMBER(9)           
PA           NOT NULL VARCHAR2(20 CHAR)   
PANODE       NOT NULL NUMBER(9)           
ME           NOT NULL VARCHAR2(20 CHAR)   
MENODE       NOT NULL NUMBER(9)           
REANALYSIS   NOT NULL NUMBER(3)           
CELL         NOT NULL VARCHAR2(20 CHAR)   
CELLNODE              NUMBER(9)           
DSP_TITLE             VARCHAR2(40 CHAR)   
VALUE_F               FLOAT(126)          
VALUE_S               VARCHAR2(40 CHAR)   
CELL_TP               CHAR(1 CHAR)        
POS_X        NOT NULL NUMBER(4)           
POS_Y        NOT NULL NUMBER(4)           
ALIGN                 CHAR(1 CHAR)        
WINSIZE_X    NOT NULL NUMBER(4)           
WINSIZE_Y    NOT NULL NUMBER(4)           
IS_PROTECTED          CHAR(1 CHAR)        
MANDATORY             CHAR(1 CHAR)        
HIDDEN                CHAR(1 CHAR)        
UNIT                  VARCHAR2(20 CHAR)   
FORMAT                VARCHAR2(40 CHAR)   
EQ                    VARCHAR2(20 CHAR)   
EQ_VERSION            VARCHAR2(20 CHAR)   
COMPONENT             VARCHAR2(20 CHAR)   
CALC_TP               CHAR(1 CHAR)        
CALC_FORMULA          VARCHAR2(2000 CHAR) 
VALID_CF              VARCHAR2(20 CHAR)   
MAX_X        NOT NULL NUMBER(3)           
MAX_Y        NOT NULL NUMBER(3)           
MULTI_SELECT          CHAR(1 CHAR)        
*/

--totale lijst
select mec.sc, mec.pg, mec.pa, mec.me, mec.cell, mec.dsp_title , '#'||mec.dsp_title||'#' tot_dsp_title
from utscmecell  mec
where rownum<100
order by sc,pg,pa,me,cell


--selecteer alle records waarbij eerste teken bestaat (zonder null/newline)
select mec.dsp_title 
from utscmecell  mec
where  REGEXP_LIKE(mec.dsp_title, '^(.)' )   
and rownum<100
order by sc,pg,pa,me,cell

--select alle records waarbij dsp-title begint met een kleine/hoofd-letter
select mec.dsp_title 
from utscmecell  mec
where  REGEXP_LIKE(mec.dsp_title, '^([a-z]|[A-Z])' )   
and rownum<100
order by sc,pg,pa,me,cell

--select alle records waarbij dsp-title niet alleen kleine letters bevat
select mec.sc, mec.pg, mec.pa, mec.me, mec.cell, mec.dsp_title 
from utscmecell  mec
where  REGEXP_LIKE(mec.dsp_title, '([^a-z])' )   
and rownum<100
order by sc,pg,pa,me,cell

--select alle records waarbij dsp-title niet alleen kleine/hoofd letters bevat
select mec.sc, mec.pg, mec.pa, mec.me, mec.cell, mec.dsp_title 
from utscmecell  mec
where  REGEXP_LIKE(mec.dsp_title, '([^(a-z|A-Z)])' )   
and rownum<100
order by sc,pg,pa,me,cell

--select alle records waarbij dsp-title niet alleen tekens bevat, 
select mec.sc, mec.pg, mec.pa, mec.me, mec.cell, mec.dsp_title, '#'||mec.dsp_title||'#' tot_dsp_title 
from utscmecell  mec
where  REGEXP_LIKE(mec.dsp_title, '([^(.)])' )   
and rownum<100
order by sc,pg,pa,me,cell


--linefeed windows:  \x0a 
select mec.sc, mec.pg, mec.pa, mec.me, mec.cell, mec.dsp_title, '#'||mec.dsp_title||'#' tot_dsp_title 
from utscmecell  mec
where  REGEXP_LIKE(mec.dsp_title, '(#x0a)' )   
and rownum<100
order by sc,pg,pa,me,cell
--NO ROWS SELECTED.

--select alle records waarbij dsp-title niet alleen kleine/hoofd letters / cijfers / spaties bevat
select mec.sc, mec.pg, mec.pa, mec.me, mec.cell, mec.dsp_title 
from utscmecell  mec
where  REGEXP_LIKE(mec.dsp_title, '([^(a-z|A-Z|0-9|( :_%/"())|(-+<>))])' )   
and rownum<100
order by sc,pg,pa,me,cell


select mec.sc, mec.pg, mec.pa, mec.me, mec.cell, mec.dsp_title,  '#'||mec.dsp_title||'#' tot_dsp_title 
from utscmecell  mec
where  REGEXP_LIKE(mec.dsp_title, '([^( (a-z) | (A-Z) | (0-9) | [:space:] (\*\:\_\%\/\"\ \-\+\<\>\(\) ) ) ] )' )   
and rownum<100
order by sc,pg,pa,me,cell

select mec.sc, mec.pg, mec.pa, mec.me, mec.cell, mec.dsp_title,  '#'||mec.dsp_title||'#' tot_dsp_title 
from utscmecell  mec
where  REGEXP_LIKE(mec.dsp_title, '( [:space:] )' )   
and rownum<100
order by sc,pg,pa,me,cell

select mec.sc, mec.pg, mec.pa, mec.me, mec.cell, mec.dsp_title,  '#'||mec.dsp_title||'#' tot_dsp_title 
from utscmecell  mec
where  REGEXP_LIKE(mec.dsp_title, '( [^:alpha:] )' )   
and rownum<100
order by sc,pg,pa,me,cell

select mec.sc, mec.pg, mec.pa, mec.me, mec.cell, mec.dsp_title,  '#'||mec.dsp_title||'#' tot_dsp_title 
from utscmecell  mec
where  REGEXP_LIKE(mec.dsp_title, '( [:xdigit:] )' )   
and rownum<100
order by sc,pg,pa,me,cell

--[:cntrl:] Nonprinting or control characters
select mec.sc, mec.pg, mec.pa, mec.me, mec.cell, mec.dsp_title,  '#'||mec.dsp_title||'#' tot_dsp_title 
from utscmecell  mec
where  REGEXP_LIKE(mec.dsp_title, '( [:cntrl:] )' )   
and rownum<100
order by sc,pg,pa,me,cell


--raphical characters (same as [:punct:] + [:upper:] + [:lower:] + [:digit:])
-- alnum = Alphanumeric characters (same as [:alpha:] + [:digit:])
select mec.sc, mec.pg, mec.pa, mec.me, mec.cell, mec.dsp_title,  '#'||mec.dsp_title||'#' tot_dsp_title 
from utscmecell  mec
where  REGEXP_LIKE(mec.dsp_title, '( [^(:graph:|:blanks:|:alnum:)] )' )   
and rownum<100
order by sc,pg,pa,me,cell


--The string should start (the first caret) with any character which is not in the character class of [:space:], 
--followed by one or more characters (the period) 
--and it should end with (the dollar) any character as long as it's not in the character class of [:space:].
regexp_like (str, '^[^[:space:]].+[^[:space:]]$')


--
WITH 
base AS ( SELECT dsp_title      AS text
          ,      '[^(a-z|A-Z)]' AS pattern
		  ,      'm'            AS param
        FROM utscmecell 
        )
-- main
SELECT text
,      regexp_substr(text, pattern, 1, level, param) AS matched_text
,      regexp_instr(text, pattern, 1, level, 0, param) AS at_pos
FROM base
CONNECT BY level <= regexp_count(text, pattern, 1, param)
;

--•	spaces 				chr(32)
--•	horizontal tabs 	chr(9)
--•	carriage returns 	chr(13)
--•	line feeds/newlines chr(10)
--•	form feeds 			chr(12)
--•	vertical tabs 		chr(11)

WITH 
   base AS (
      SELECT dsp_title AS text,
             'CHR(10)' AS pattern,
             'nm' AS param
        FROM utscmecell 
        where rownum < 1000
   )
-- main
 SELECT text
  ,     regexp_substr(text, pattern, 1, level, param) AS matched_text
  ,     regexp_instr(text, pattern, 1, level, 0, param) AS at_pos
   FROM base
   where regexp_like ( text, pattern, param)
CONNECT BY level <= regexp_count(text, pattern, 1, param);


select nls_lang, nls_char from dual;

select dsp_title, dump(dsp_title) from utscmecell where rownum<10

--show NLS
DB_TIMEZONE +01:00
NLS_CALENDAR GREGORIAN
NLS_CHARACTERSET AL32UTF8
NLS_COMP BINARY
NLS_CURRENCY $
NLS_DATE_FORMAT DD-MM-YYYY HH:MI:SS
NLS_DATE_LANGUAGE AMERICAN
NLS_DUAL_CURRENCY $
NLS_ISO_CURRENCY AMERICA
NLS_LANGUAGE AMERICAN
NLS_LENGTH_SEMANTICS BYTE
NLS_NCHAR_CONV_EXCP FALSE
NLS_NUMERIC_CHARACTERS .,
NLS_SORT BINARY
NLS_TERRITORY AMERICA
NLS_TIMESTAMP_FORMAT DD-MM-YYYY HH.MI.SSXFF AM
NLS_TIMESTAMP_TZ_FORMAT DD-MM-YYYY HH.MI.SSXFF AM TZR
NLS_TIME_FORMAT HH.MI.SSXFF AM
NLS_TIME_TZ_FORMAT HH.MI.SSXFF AM TZR
SESSION_TIMEZONE Europe/Berlin
SESSION_TIMEZONE_OFFSET +02:00


--bekijk teken van chr
select chr(34) from dual;		--"
select chr(37) from dual;		--%
select chr(41) from dual;		--)
select chr(43) from dual;		--+
select chr(45) from dual;		---
select chr(47) from dual;		--/
select chr(60) from dual;		--<
select chr(62) from dual;		-->
select chr(95) from dual;		--_
select chr(105) from dual;		--(
select chr(176) from dual;		--graden celcius °

/*
The following table shows the common character sets:

Character Set	Description
AL32UTF8		Unicode 5.0 Universal character set UTF-8 encoding form
EE8MSWIN1250	Microsoft Windows East European Code Page 1250
JA16SJISTILDE	Japanese Shift-JIS Character Set, compatible with MS Code Page 932
US7ASCII		US 7-bit ASCII character set
UTF8			Unicode 3.0 Universal character set CESU-8 encoding form
WE8EBCDIC1047	IBM West European EBCDIC Code Page 1047
WE8ISO8859P1	ISO 8859-1 West European 8-bit character set
WE8MSWIN1252	Microsoft Windows West European Code Page 1252
ZHT16MSWIN950	Microsoft Windows Traditional Chinese Code Page 950
*/

SELECT CONVERT( 'ABC', 'AL32UTF8', 'WE8MSWIN1252' )
FROM dual
;

SELECT DSP_TITLE
,      CONVERT( dsp_title, 'AL32UTF8', 'WE8MSWIN1252' )
FROM utscmecell
where rownum<100
and dsp_title <> CONVERT( dsp_title, 'AL32UTF8', 'WE8MSWIN1252' )
;
/*
ML(1+4) 100°C	ML(1+4) 100Â°C
ML(1+8) 125°C	ML(1+8) 125Â°C
ML(1+4) 100°C	ML(1+4) 100Â°C
ML(1+8) 125°C	ML(1+8) 125Â°C
ML(1+8) 125°C	ML(1+8) 125Â°C
ML(1+8) 125°C	ML(1+8) 125Â°C
ML(1+4) 100°C	ML(1+4) 100Â°C
tan (70°C)	tan (70Â°C)
E* (20°C)	E* (20Â°C)
E' (20°C)	E' (20Â°C)
*/

select 'ML(1+4) 100°C'
,    convert('ML(1+4) 100°C','AL32UTF8', 'WE8MSWIN1252' )
,    convert( convert('ML(1+4) 100°C','AL32UTF8', 'WE8MSWIN1252' ), 'WE8MSWIN1252', 'AL32UTF8' )
from dual;
/*
ML(1+4) 100°C	ML(1+4) 100Â°C	ML(1+4) 100°C
*/


SELECT sc,pg,pa,me,cell, DSP_TITLE
,      CONVERT( dsp_title, 'AL32UTF8', 'WE8MSWIN1252' )
,      convert( convert('ML(1+4) 100°C','AL32UTF8', 'WE8MSWIN1252' ), 'WE8MSWIN1252', 'AL32UTF8' )
FROM utscmecell
where dsp_title <> convert( convert(DSP_TITLE,'AL32UTF8', 'WE8MSWIN1252' ), 'WE8MSWIN1252', 'AL32UTF8' )
and rownum < 100
;


SELECT count(*)
FROM utscmecell
where dsp_title <> convert( convert(DSP_TITLE,'AL32UTF8', 'WE8MSWIN1252' ), 'WE8MSWIN1252', 'AL32UTF8' )
;
--0

SELECT count(*)
FROM utscmecell
where dsp_title <>  convert(DSP_TITLE,'AL32UTF8', 'WE8MSWIN1252' )
;
--615683 (test-omgeving totaal 22559189)


/*
SPI0907005M03	Standard	TP018AA	TP018A	E_loss70	E" (70°C)
SPI0907005M03	Standard	TP018AA	TP018A	D_loss70	D" (70°C)
SPI0907005M03	Standard	TP018AA	TP018A	tan70	tan (70°C)
etc
CONCLUSIE: alleen velden met celcius in title.
*/



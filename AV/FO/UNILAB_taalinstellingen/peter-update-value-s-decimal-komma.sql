--****************************************************************************************************************************
--HERSTEL-SCRIPT om voor 1 SPECIFIEK REQUEST alle VALUE_S-strings in numerieke-waardes de komma te vervangen door een PUNT !!!
--Dit doen we voor de PARAMETERS, TEST-METHODES en TEST-METHODE-CELLEN

--PARAMETER:
select m.sc, m.pg, m.pa, m.value_s, m.value_f
, case WHEN REGEXP_LIKE (m.value_s, '^-?\d+,\d+$')  THEN REGEXP_REPLACE (m.value_s, ',', '.' ) ELSE 'FOUT' end  expresult 
from ( select pa.sc, pa.pg, pa.pa, pa.value_s, pa.value_f
       from utscpa  pa
       WHERE  REGEXP_LIKE(pa.value_s, '^-?\d+,\d+$') 
	   and   pa.sc in (select sc.sc from utsc sc where sc.rq = 'RTW2213086T' ) 
      )  m
;
--35 rijen

--TEST-METHODE
select m.sc, m.pg, m.pa, m.me, m.value_s, m.value_f
, case WHEN REGEXP_LIKE (m.value_s, '^-?\d+,\d+$')  THEN REGEXP_REPLACE (m.value_s, ',', '.' ) ELSE 'FOUT' end  expresult 
from ( select me.sc, me.pg, me.pa, me.me, me.value_s, me.value_f
       from utscme  me
       WHERE  REGEXP_LIKE(me.value_s, '^-?\d+,\d+$') 
	   and   me.sc in (select sc.sc from utsc sc where sc.rq = 'RTW2213086T' ) 
      )  m
;
--0 rijen

--TEST-METHODE-CELLS
select m.sc, m.pg, m.pa, m.me, m.cell, m.dsp_title, m.value_s, m.value_f
, case WHEN REGEXP_LIKE (m.value_s, '^-?\d+,\d+$')  THEN REGEXP_REPLACE (m.value_s, ',', '.' ) ELSE 'FOUT' end  expresult 
from ( select me.sc, me.pg, me.pa, me.me, me.cell, me.dsp_title, me.value_s, me.value_f
       from utscmecell  me
       WHERE  REGEXP_LIKE(me.value_s, '^-?\d+,\d+$') 
	   and   me.sc in (select sc.sc from utsc sc where sc.rq = 'RTW2213086T' ) 
      )  m
;
--132 rijen

--TEST-METHODE-CELL-LISTS
select m.sc, m.pg, m.pa, m.me, m.cell, m.dsp_title, m.value_s, m.value_f
, case WHEN REGEXP_LIKE (m.value_s, '^-?\d+,\d+$')  THEN REGEXP_REPLACE (m.value_s, ',', '.' ) ELSE 'FOUT' end  expresult 
from ( select me.sc, me.pg, me.pa, me.me, me.cell, me.dsp_title, me.value_s, me.value_f
       from utscmecellLIST  me
       WHERE  REGEXP_LIKE(me.value_s, '^-?\d+,\d+$') 
	   and   me.sc in (select sc.sc from utsc sc where sc.rq = 'RTW2213086T' ) 
      )  m
;
--****************************************************************************************************************************

--***************************************************************
--***************************************************************
-- LOGGING VOORAF van FOUTIEVE VALUE_S met numerieke-waardes en komma als decimaal-scheider...
-- DIT OM LATER EVT. WAARDES TE KUNNEN HERSTELLEN...
--***************************************************************
--***************************************************************
set pages 0
set linesize 200

spool oracleprod_test_utscpa.txt
--PARAMETER:
select 'UTSCPA'||';'||m.sc||';'|| m.pg||';'|| m.pa||';'|| m.value_s||';'|| m.value_f||';'||
       case WHEN REGEXP_LIKE (m.value_s, '^-?\d+,\d+$')  THEN REGEXP_REPLACE (m.value_s, ',', '.' ) ELSE 'FOUT' end  expresult 
from ( select pa.sc, pa.pg, pa.pa, pa.value_s, pa.value_f
       from utscpa  pa
       WHERE   REGEXP_LIKE(pa.value_s, '^-?\d+,\d+$') 
       AND NOT REGEXP_LIKE(pa.value_s, '^-?\d+,\d+,')     --niet een string met meerdere komma's
      )  m
;
spool off;
--89408 rows selected.

spool oracleprod_test_utscme.txt
--TEST-METHODE
select 'UTSCME'||';'||m.sc||';'|| m.pg||';'|| m.pa||';'|| m.me ||';'||m.value_s||';'|| m.value_f||';'||
       case WHEN REGEXP_LIKE (m.value_s, '^-?\d+,\d+$')  THEN REGEXP_REPLACE (m.value_s, ',', '.' ) ELSE 'FOUT' end  expresult 
from ( select me.sc, me.pg, me.pa, me.me, me.value_s, me.value_f
       from utscme  me
       WHERE   REGEXP_LIKE(me.value_s, '^-?\d+,\d+$') 
       AND NOT REGEXP_LIKE(me.value_s, '^-?\d+,\d+,')     --niet een string met meerdere komma's
      )  m
;
spool off;

spool oracleprod_test_utscmecell.txt
--TEST-METHODE-CELLS
select 'UTSCMECELL'||';'||m.sc||';'|| m.pg||';'|| m.pa||';'|| m.me ||';'||m.cell||';'||m.dsp_title||';'||m.value_s||';'|| m.value_f||';'||
       case WHEN REGEXP_LIKE (m.value_s, '^-?\d+,\d+$')  THEN REGEXP_REPLACE (m.value_s, ',', '.' ) ELSE 'FOUT' end  expresult 
from ( select me.sc, me.pg, me.pa, me.me, me.cell, me.dsp_title, me.value_s, me.value_f
       from utscmecell  me
       WHERE   REGEXP_LIKE(me.value_s, '^-?\d+,\d+$') 
       AND NOT REGEXP_LIKE(me.value_s, '^-?\d+,\d+,')     --niet een string met meerdere komma's
      )  m
;
spool off;

spool oracleprod_test_utscmecelllist.txt
--TEST-METHODE-CELL-LISTS
select 'UTSCMECELLLIST'||';'||m.sc||';'|| m.pg||';'|| m.pa||';'|| m.me ||';'||m.cell||';'||m.index_x||';'||m.index_y||';'||m.value_s||';'|| m.value_f||';'||
       case WHEN REGEXP_LIKE (m.value_s, '^-?\d+,\d+$')  THEN REGEXP_REPLACE (m.value_s, ',', '.' ) ELSE 'FOUT' end  expresult 
from ( select me.sc, me.pg, me.pa, me.me, me.cell, me.index_x, me.index_y, me.value_s, me.value_f
       from utscmecellLIST  me
       WHERE   REGEXP_LIKE(me.value_s, '^-?\d+,\d+$') 
       AND NOT REGEXP_LIKE(me.value_s, '^-?\d+,\d+,')     --niet een string met meerdere komma's
      )  m
;
SPOOL OFF;



--CONTROLE TABLESPACES VOORAF
ATS_USERS	16	1024	863		162		84		1024	16	ONLINE	PERMANENT
SYSAUX		96	1680	65		1615	4		32768	5	ONLINE	PERMANENT
SYSTEM		100	13250	65		13185	0		32768	40	ONLINE	PERMANENT
UNI_BO		1	100		99		1		99		32768	0	ONLINE	PERMANENT
UNI_DATAC	95	5415	258		5157	5		32768	16	ONLINE	PERMANENT
UNI_DATAO	98	272688	6131	266557	2		292144	91	ONLINE	PERMANENT
UNI_INDEXC	95	10750	547		10203	5		32768	31	ONLINE	PERMANENT
UNI_INDEXO	95	181248	8574	172674	5		196608	88	ONLINE	PERMANENT
UNI_LOB		98	57225	1194	56031	2		65536	85	ONLINE	PERMANENT
UNI_TEMP	0	30720	30715	5		100		30720	0	ONLINE	TEMPORARY
UNI_UNDO	0	10440	10410	30		100		32768	0	ONLINE	UNDO

--CONTROLE TABLESPACES ACHTERAF
ATS_USERS	16	1024	863		162		84		1024	16	ONLINE	PERMANENT
SYSAUX		96	1680	65		1615	4		32768	5	ONLINE	PERMANENT
SYSTEM		100	13250	65		13185	0		32768	40	ONLINE	PERMANENT
UNI_BO		1	100		99		1		99		32768	0	ONLINE	PERMANENT
UNI_DATAC	95	5415	258		5157	5		32768	16	ONLINE	PERMANENT
UNI_DATAO	98	272688	6131	266557	2		292144	91	ONLINE	PERMANENT
UNI_INDEXC	95	10750	547		10203	5		32768	31	ONLINE	PERMANENT
UNI_INDEXO	95	181248	8574	172674	5		196608	88	ONLINE	PERMANENT
UNI_LOB		98	57225	1194	56031	2		65536	85	ONLINE	PERMANENT
UNI_TEMP	0	30720	30715	5		100		30720	0	ONLINE	TEMPORARY
UNI_UNDO	2	10440	10220	220		98		32768	1	ONLINE	UNDO



--***************************************************************
--***************************************************************
-- HERSTELLEN van VALUE_S met numerieke-waardes en komma als decimaal-scheider...
--***************************************************************
--***************************************************************
--PARAMETER:
--update VALUE_S + insert VALUE_F with value_s
update UTSCPA me
set me.value_s = case WHEN REGEXP_LIKE (me.value_s, '^-?\d+,\d+$')  
                      THEN REGEXP_REPLACE (me.value_s, ',', '.' ) 
					  ELSE me.value_s 
			     end 
,   me.value_F = case WHEN REGEXP_LIKE (me.value_s, '^-?\d+,\d+$')  
                      THEN to_number(REGEXP_REPLACE (me.value_s, ',', '.' )  )
					  ELSE me.value_f
			     end 
WHERE  REGEXP_LIKE(me.value_s, '^-?\d+,\d+$') 
AND NOT REGEXP_LIKE(me.value_s, '^-?\d+,\d+,')     --niet een string met meerdere komma's
AND   me.value_F is null
--and   me.sc in (select sc.sc from utsc sc where sc.rq = 'RTW2213086T' ) 
;
--72 rows updated
--update VALUE_S ONLY (VALUE_F is already filled)
update UTSCPA pa
set pa.value_s = case WHEN REGEXP_LIKE (pa.value_s, '^-?\d+,\d+$')  
                      THEN REGEXP_REPLACE (pa.value_s, ',', '.' ) 
					  ELSE pa.value_s 
			     end 
WHERE  REGEXP_LIKE(pa.value_s, '^-?\d+,\d+$') 
AND NOT REGEXP_LIKE(pa.value_s, '^-?\d+,\d+,')     --niet een string met meerdere komma's
AND   pa.value_F is NOT null
--and   pa.sc in (select sc.sc from utsc sc where sc.rq = 'RTW2213086T' ) 
;
--89336 rows updated.

commit;


--**************************************
--TEST-METHOD
--**************************************
--update VALUE_S + insert VALUE_F with value_s
update UTSCME me
set me.value_s = case WHEN REGEXP_LIKE (me.value_s, '^-?\d+,\d+$')  
                      THEN REGEXP_REPLACE (me.value_s, ',', '.' ) 
					  ELSE me.value_s 
			     end 
,   me.value_F = case WHEN REGEXP_LIKE (me.value_s, '^-?\d+,\d+$')  
                      THEN to_number(REGEXP_REPLACE (me.value_s, ',', '.' ) )
					  ELSE me.value_f
			     end 
WHERE  REGEXP_LIKE(me.value_s, '^-?\d+,\d+$') 
AND NOT REGEXP_LIKE(me.value_s, '^-?\d+,\d+,')     --niet een string met meerdere komma's
AND   me.value_F is null
--and   me.sc in (select sc.sc from utsc sc where sc.rq = 'RTW2213086T' ) 
;
--68 rows updated.

--update VALUE_S ONLY (VALUE_F is already filled)
update UTSCME me
set me.value_s = case WHEN REGEXP_LIKE (me.value_s, '^-?\d+,\d+$')  
                      THEN REGEXP_REPLACE (me.value_s, ',', '.' ) 
					  ELSE me.value_s 
			     end 
WHERE  REGEXP_LIKE(me.value_s, '^-?\d+,\d+$') 
AND NOT REGEXP_LIKE(me.value_s, '^-?\d+,\d+,')     --niet een string met meerdere komma's
AND   me.value_F is NOT null
--and   me.sc in (select sc.sc from utsc sc where sc.rq = 'RTW2213086T' ) 
;
--20412 rows updated.

commit;


--**************************************
--TEST-METHOD-CELLS
--**************************************
--update VALUE_S + insert VALUE_F with value_s
update UTSCMECELL me
set me.value_s = case WHEN REGEXP_LIKE (me.value_s, '^-?\d+,\d+$')  
                      THEN REGEXP_REPLACE (me.value_s, ',', '.' ) 
					  ELSE me.value_s 
			     end 
,   me.value_F = case WHEN REGEXP_LIKE (me.value_s, '^-?\d+,\d+$')  
                      THEN to_number(REGEXP_REPLACE (me.value_s, ',', '.' ) )
					  ELSE me.value_f
			     end 
WHERE  REGEXP_LIKE(me.value_s, '^-?\d+,\d+$') 
AND NOT REGEXP_LIKE(me.value_s, '^-?\d+,\d+,')     --niet een string met meerdere komma's
AND   me.value_F is null
--and   me.sc in (select sc.sc from utsc sc where sc.rq = 'RTW2213086T' ) 
;
--15685 rows updated.

--update VALUE_S ONLY (VALUE_F is already filled)
update UTSCMECELL me
set me.value_s = case WHEN REGEXP_LIKE (me.value_s, '^-?\d+,\d+$')  
                      THEN REGEXP_REPLACE (me.value_s, ',', '.' ) 
					  ELSE me.value_s 
			     end 
WHERE  REGEXP_LIKE(me.value_s, '^-?\d+,\d+$') 
AND NOT REGEXP_LIKE(me.value_s, '^-?\d+,\d+,')     --niet een string met meerdere komma's
AND   me.value_F is NOT null
--and   me.sc in (select sc.sc from utsc sc where sc.rq = 'RTW2213086T' ) 
;
--109103 rows updated.

commit;


--**************************************
--TEST-METHOD-CELL-LIST
--**************************************
--update VALUE_S + insert VALUE_F with value_s
update UTSCMECELLLIST me
set me.value_s = case WHEN REGEXP_LIKE (me.value_s, '^-?\d+,\d+$')  
                      THEN REGEXP_REPLACE (me.value_s, ',', '.' ) 
					  ELSE me.value_s 
			     end 
,   me.value_F = case WHEN REGEXP_LIKE (me.value_s, '^-?\d+,\d+$')  
                      THEN to_number( REGEXP_REPLACE (me.value_s, ',', '.' ) )
					  ELSE me.value_f
			     end 
WHERE  REGEXP_LIKE(me.value_s, '^-?\d+,\d+$') 
AND NOT REGEXP_LIKE(me.value_s, '^-?\d+,\d+,')     --niet een string met meerdere komma's
AND   me.value_F is null
--and   me.sc in (select sc.sc from utsc sc where sc.rq = 'RTW2213086T' ) 
;
--1536 rows updated.

--update VALUE_S ONLY (VALUE_F is already filled)
update UTSCMECELLlist me
set me.value_s = case WHEN REGEXP_LIKE (me.value_s, '^-?\d+,\d+$')  
                      THEN REGEXP_REPLACE (me.value_s, ',', '.' ) 
					  ELSE me.value_s 
			     end 
WHERE  REGEXP_LIKE(me.value_s, '^-?\d+,\d+$') 
AND NOT REGEXP_LIKE(me.value_s, '^-?\d+,\d+,')     --niet een string met meerdere komma's
AND   me.value_F is NOT null
--and   me.sc in (select sc.sc from utsc sc where sc.rq = 'RTW2213086T' ) 
;
--20076 rows updated.

commit;











--einde script...


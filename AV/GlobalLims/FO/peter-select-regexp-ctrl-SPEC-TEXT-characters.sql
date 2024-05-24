ora-31061 xdb error special char to escaped char conversion failed

WITH DATAA AS (
  2      SELECT UNISTR('SO\0013bad') TEST FROM DUAL
  3      UNION ALL
  4      SELECT UNISTR('SO\00aegood') TEST FROM DUAL
  5  )
  6  SELECT *
  7  FROM DATAA
  8  WHERE REGEXP_LIKE ( TEST, '[[:cntrl:]]' );
  
--table: specification_text   regel 601 like 'C)'
--REF_ID = 702846


part-no=BLD0122

SELECT *
FROM specification_text
WHERE TEXT LIKE 'C)%' 
AND   PART_NO = 'BLD0122' 
;
--BLD0122	1	702846	"C) Property to be reported in the certificate of analysis provided with every consignment

Bladders should be stored in a dark and dry place, protected from direct sunlight and ozone sources.	
700577	100	0	100	100	1  

descr specification_text
/*
Name            Null?    Type              
--------------- -------- ----------------- 
PART_NO         NOT NULL VARCHAR2(18 CHAR) 
REVISION        NOT NULL NUMBER(4)         
TEXT_TYPE       NOT NULL NUMBER(8)         
TEXT                     CLOB              
SECTION_ID      NOT NULL NUMBER(8)         
SECTION_REV     NOT NULL NUMBER(4)         
SUB_SECTION_ID  NOT NULL NUMBER(8)         
SUB_SECTION_REV NOT NULL NUMBER(4)         
TEXT_TYPE_REV            NUMBER(4)         
LANG_ID         NOT NULL NUMBER(2)
*/


SELECT * FROM NLS_DATABASE_PARAMETERS;



WITH SPEC_TEXT AS (
        SELECT PART_NO, TEXT 
		FROM specification_text
		WHERE TEXT LIKE 'C)%' 
		AND   PART_NO = 'BLD0122' 
    )
    SELECT PART_NO
	, REGEXP_REPLACE(TEXT, '[[:cntrl:]]', '@@@@@')  TEXT_CTRL
	, CONVERT(TEXT, 'AL32UTF8','UTF-8')          TEXT_CONV
	, REGEXP_REPLACE(CONVERT(TEXT, 'AL32UTF8','UTF-8'), '[[:cntrl:]]', '@@@@@')   TEXT_CONV_CTRL
    FROM SPEC_TEXT
    WHERE REGEXP_LIKE ( TEXT, '[[:cntrl:]]' )
;	
	
UNISTR takes as its argument a text literal or an expression that resolves to character data and returns it in the national character set. 
The national character set of the database can be either AL16UTF16 or UTF8. UNISTR provides support for Unicode string literals by letting 
you specify the Unicode encoding value of characters in the string. This is useful, for example, for inserting data into NCHAR columns.
The Unicode encoding value has the form '\xxxx' where 'xxxx' is the hexadecimal value of a character in UCS-2 encoding format. 
Supplementary characters are encoded as two code units, the first from the high-surrogates range (U+D800 to U+DBFF), and the second from 
the low-surrogates range (U+DC00 to U+DFFF). To include the backslash in the string itself, precede it with another backslash (\\).

--SELECT CONVERT('HELLO WORLD', 'WE8ISO8859P1','AL32UTF8') FROM DUAL;

Control character	Value
Carriage return	 	CHR(13)
Line feed	 		CHR(10)
Tab	 				CHR(9)

:cntrl: is the opposite of :print:, so you could negate the combination of that plus the control character(s) you want to keep:
regexp_replace(description, '[^[:print:]'||chr(10)||chr(13)||']', null)
	
	
WITH SPEC_TEXT AS (
        SELECT PART_NO, TEXT 
		FROM specification_text
		WHERE TEXT LIKE 'C)%' 
		AND   PART_NO = 'BLD0122' 
    )
    SELECT PART_NO
	,      REGEXP_REPLACE(TEXT, '[[:cntrl:]]', '@')  TEXT_CTRL
    ,      REGEXP_REPLACE(TEXT, '[^[:print:]'||chr(10)||chr(13)||']', null)
    FROM SPEC_TEXT
    WHERE REGEXP_LIKE ( TEXT, '[[:cntrl:]]' )
;	

--totaal:   240.000
--not null: 102.673

SELECT PART_NO, REVISION, TEXT_TYPE_REV, TEXT 
FROM specification_text
WHERE TEXT LIKE 'C)%' 
AND   PART_NO = '140203'
		
/*
140203	1	702846	"C) Manufacturer to provide their test results for these parameters in the COA.
1) 8 PAH are Benzo(a)anthracene (BaA), Chrysen (CHR), Benzo(j)fluoranthene (BjFA), Benzo(e)pyrene (BeP),Benzo(b)fluoranthene (BbFA), Benzo(k)fluoranthene (BkFA), Benzo(a)pyrene (BaP) and Dibenzo(a,h)anthracene (DBAhA).
2) Typical - These are only indicative values. Tolerance to be established based on Supplier's inputs and Internal test results.
3) Testing may be carried out using either Grimmer Method or by Producer's own method."	
700577	100	0	100	100	1

140203	2	702846	"C) Manufacturer to provide their test results for these parameters in the COA.
1) 8 PAH are Benzo(a)anthracene (BaA), Chrysen (CHR), Benzo(j)fluoranthene (BjFA), Benzo(e)pyrene (BeP),Benzo(b)fluoranthene (BbFA), Benzo(k)fluoranthene (BkFA), Benzo(a)pyrene (BaP) and Dibenzo(a,h)anthracene (DBAhA).
2) Typical - These are only indicative values. Tolerance to be established based on Supplier's inputs and Internal test results.
3) Testing may be carried out using either Grimmer Method or by Producer's own method.

."	
700577	100	0	100	100	1

140203	3	702846	"C) Manufacturer to provide their test results for these parameters in the COA.
1) 8 PAH are Benzo(a)anthracene (BaA), Chrysen (CHR), Benzo(j)fluoranthene (BjFA), Benzo(e)pyrene (BeP),Benzo(b)fluoranthene (BbFA), Benzo(k)fluoranthene (BkFA), Benzo(a)pyrene (BaP) and Dibenzo(a,h)anthracene (DBAhA).
2) Typical - These are only indicative values. Tolerance to be established based on Supplier's inputs and Internal test results.
3) Testing may be carried out using either Grimmer Method or by Producer's own method.

."	
700577	100	0	100	100	1

140203	4	702846	"C) Manufacturer to provide their test results for these parameters in the COA.
1) 8 PAH are Benzo(a)anthracene (BaA), Chrysen (CHR), Benzo(j)fluoranthene (BjFA), Benzo(e)pyrene (BeP),Benzo(b)fluoranthene (BbFA), Benzo(k)fluoranthene (BkFA), Benzo(a)pyrene (BaP) and Dibenzo(a,h)anthracene (DBAhA).
2) Typical - These are only indicative values. Tolerance to be established based on Supplier's inputs and Internal test results.


."	
700577	100	0	100	100	1

140203	5	702846	"C) Manufacturer to provide their test results for these parameters in the COA.
1) 8 PAH are Benzo(a)anthracene (BaA), Chrysen (CHR), Benzo(j)fluoranthene (BjFA), Benzo(e)pyrene (BeP),Benzo(b)fluoranthene (BbFA), Benzo(k)fluoranthene (BkFA), Benzo(a)pyrene (BaP) and Dibenzo(a,h)anthracene (DBAhA).
2) Typical - These are only indicative values. Tolerance to be established based on Supplier's inputs and Internal test results.


."	
700577	100	0	100	100	1

140203	6	702846	"C) Manufacturer to provide their test results for these parameters in the COA.
1) 8 PAH are Benzo(a)anthracene (BaA), Chrysen (CHR), Benzo(j)fluoranthene (BjFA), Benzo(e)pyrene (BeP),Benzo(b)fluoranthene (BbFA), Benzo(k)fluoranthene (BkFA), Benzo(a)pyrene (BaP) and Dibenzo(a,h)anthracene (DBAhA).
2) Typical - These are only indicative values. Tolerance to be established based on Supplier's inputs and Internal test results.


."	
700577	100	0	100	100	1

140203	7	702846	"C) Manufacturer to provide their test results for these parameters in the COA.
1) 8 PAH are Benzo(a)anthracene (BaA), Chrysen (CHR), Benzo(j)fluoranthene (BjFA), Benzo(e)pyrene (BeP),Benzo(b)fluoranthene (BbFA), Benzo(k)fluoranthene (BkFA), Benzo(a)pyrene (BaP) and Dibenzo(a,h)anthracene (DBAhA).
2) Manufacturer shall report specific gravity parameter either at 15 °C or at 25°C.

"	
700577	100	0	100	100	1

140203	7	703067	"Based on supplier feedback, specific gravity at 25°C changed from 0.968 (target) to 0.920 - 1.00 with target 0.960
Kinematic Viscosity changed from 40-80 with target 60 to 30-80 with target 55.
Specific gravity at 15°C is added as a specification parameter to be reported in COA. 
Specification range for carbon chain distribution are given: C-A 27 -  39 (33 - Target), C-P 38 - 50 (44-Target), C-N 17 - 29 (23-Target) 
Specification range for refractive Index is given as 1.500 - 1.60 (1.550 - Target)
Specification range for viscosity gravity constant given as 0.89 - 0.93 (0.91 - Target)
Specification range for glass transition temperature given as -44°C  to -36°C ( -40°C - Target) "	700577	100	0	100	100	1
*/		
	

Use workaround below
alter session set events '31151 trace name context forever, level 0x40000';
Or
alter system set events ='31151 trace name context forever, level 0x40000' scope=both;

spool peter-onderzoek-xmlgen-xmltype-error.log	
		
set serveroutput on size unlimited
set linesize 300
set pages 0
alter session set events '31151 trace name context forever, level 0x40000';
declare
l_xmltype   xmltype;
c_query     sys_refcursor;
l_query     varchar2(4000);
l_rowid   rowid;
l_part_no varchar2(100);
l_revision varchar2(10);
l_text_type number(8);
l_section_id    number;
l_sub_section_id number;
l_text   clob;
l_clob   clob;
l_var    varchar2(4000);
l_var_zonder_ctrl varchar2(4000);
c_cur    sys_refcursor;
l_teller  number := 0;
begin
  dbms_output.enable(10000000);
  dbms_output.put_line('start procedure');
  --open c_cur for select part_no, revision, text_type, text from specification_text where text like 'C)%' and part_no='140203' and revision=7 and text_type=702846 and rownum=1;   --and rownum=1;
  open c_cur for select rowid, part_no, revision, text_type, section_id, sub_section_id, substr(text,1,3990) text
                 from specification_text  st
				 where exists (select ''
				               from specification_text st2
							   where st2.part_no = st.part_no
							   and   st2.revision = st.revision
							   and   st2.text_type = st.text_type
							   and   st2.section_id = st.section_id
							   and   st2.sub_section_id = st.sub_section_id
							   and   st2.revision = (select max(st3.revision) 
							                         from specification_text st3
                                                     where st3.part_no = st2.part_no
                                                     --and   st3.revision = st2.revision
                                                     and   st3.text_type = st2.text_type
							                         and   st3.section_id = st2.section_id
                        							 and   st3.sub_section_id = st2.sub_section_id
													 )
								)
                 and st.text is not null
                 --and rownum<50000
				 --and part_no = 'EF_T205/55R16NO2X' 
				 --and   revision=7 
				 --and   text_type=703067 
				 --and   rownum=1;   --and rownum=1;
                 order by part_no, revision, text_type, section_id, sub_section_id
				 ;
  --voor de gehele query:				 
  --l_xmltype := XMLTYPE(C_CUR);
  --bms_output.put_line(l_xmltype.getClobVal);
  loop
    fetch c_cur into l_rowid, l_part_no, l_revision, l_text_type ,l_section_id, l_sub_section_id, l_text ;
    if (c_cur%notfound)   
    then CLOSE C_CUR;
         exit;
    end if;
    --
	--Dbms_output.put_line('START part_no: '||l_part_no||'-'||l_revision||'-'||l_text_type||'-'||l_section_id||'-'||l_sub_section_id||': '||l_TEXT);
	--
	l_teller := l_teller + 1;
	l_var := null;
	l_var_zonder_ctrl := null;
	l_clob := null;
	--
	begin
	  --open c_query for SELECT part_no, text from specification_text where part_no=l_part_no and revision=l_revision and text_type=l_text_type and section_id=l_section_id AND sub_section_id=l_sub_section_id and text is not null;
      l_xmltype := dbms_xmlgen.getxmltype( 'select rowid, part_no, revision, text_type, section_id, sub_section_id, substr(text,1,3990) text '||
                 ' from specification_text  st '||
				 ' where exists (select 1 '||
				             '  from specification_text st2 '||
							 '  where st2.part_no = st.part_no '||
							 '  and   st2.revision = st.revision '||
							 '  and   st2.text_type = st.text_type '||
							 '  and   st2.section_id = st.section_id '||
							 '  and   st2.sub_section_id = st.sub_section_id '||
							 '  and   st2.revision = (select max(st3.revision)  '||
							  '                       from specification_text st3 '||
                              '                       where st3.part_no = st2.part_no '||
                              '                       and   st3.text_type = st2.text_type  '||
							  '                       and   st3.section_id = st2.section_id '||
                        	  '						 and   st3.sub_section_id = st2.sub_section_id '||
							  '						 ) '||
							  '	) '||
                ' and st.text is not null '||
				' and st.part_no = '||''''||l_part_no||''''
				);
	  --l_query := 'select part_no, text from specification_text where part_no='||l_part_no ;  -- where part_no = '||l_part_no||' and 1=1;';
	  --l_xmltype := dbms_xmlgen.getxmltype( l_query );
      --dbms_output.put_line(l_xmltype.getclobval);
	  --close l_query;
	  --
	exception
	  when others
	  then dbms_output.put_line('NOT-OK DBMS_XMLGEN-part_no: '||l_part_no||'-'||l_revision||'-'||l_text_type||'-'||l_section_id||'-'||l_sub_section_id);   --||': '||'#'||SQLERRM);
	end;
	if mod(l_teller,1000) = 0
	then dbms_output.put_line('Teller: '||l_teller);
	end if;
  end loop;
  dbms_output.put_line('end procedure');
end;
/

spool off;




/*	
	begin
      select REGEXP_REPLACE(l_text, '[[:cntrl:]]', '@') into l_var from dual;
	  dbms_output.put_line('OK NA VULLEN VAN L_VAR-NA-REPLACE part_no: '||l_part_no||'-'||l_revision||'-'||l_text_type||'-'||l_section_id||'-'||l_sub_section_id||': '||l_var);
      --select xmltype(l_var).getClobVal() into l_clob from dual;
	  --select xmltype(cursor(select part_no, text from specification_text where part_no = l_part_no and revision=l_revision and text_type=l_text_type and section_id = l_section_id and sub_section_id = l_sub_section_id AND TEXT IS not null)).getClobVal() into l_clob from dual;
	  dbms_xmlgen.getxmltype
	  dbms_output.put_line('OK XMLTYPE-na-replace part_no: '||l_part_no||'-'||l_revision||'-'||l_text_type||'-'||l_section_id||'-'||l_sub_section_id||': '||l_clob);
	exception
	  when others
	  then dbms_output.put_line('alg-excp FOUT XMLTYPE-na-replace part_no: '||l_part_no||'-'||l_revision||'-'||l_text_type||'-'||l_section_id||'-'||l_sub_section_id||'#'||sqlerrm);    --': '||l_text||
           --dbms_output.put_line('alg-excp FOUT part_no: '||l_part_no||'-'||l_revision||'-'||l_text_type||'-'||l_section_id||'-'||l_sub_section_id);
	end;
	--
    begin	
	  if REGEXP_LIKE (l_text, '[[:cntrl:]]' ) 
	  then dbms_output.put_line('cntrl');
	  else dbms_output.put_line('no-cntrl');
	  end if;
	  l_clob := xmltype(l_TEXT).getClobVal();
	  dbms_output.put_line('OK xmltype-text part_no: '||l_part_no||'-'||l_revision||'-'||l_text_type||'-'||l_section_id||'-'||l_sub_section_id||': '||L_CLOB);
	exception
	  when others
	  then dbms_output.put_line('alg-excp FOUT xmltype-text part_no: '||l_part_no||'-'||l_revision||'-'||l_text_type||': '||l_text||'#'||sqlerrm);
    end;
*/	
	
	--
/*  begin	
	  select xmltype(cursor(select part_no, REGEXP_REPLACE(text, '[[:cntrl:]]', '') from specification_text where part_no = l_part_no and revision = l_revision and text_type=l_text_type )).getClobVal() into l_var_zonder_ctrl from dual;
	  --l_clob := xmltype(text).getClobVal();
	  dbms_output.put_line('OK replace-ctrl-spatie-part_no: '||l_part_no||'-'||l_revision||'-'||l_text_type||': '||l_VAR_ZONDER_CTRL);
	exception
	  when others
	  then dbms_output.put_line('alg-excp FOUT replace-ctrl-spatie-part_no: '||l_part_no||'-'||l_revision||'-'||l_text_type||': '||l_text||'#'||sqlerrm);
    end;
*/
	--
/*  begin
      select xmltype(cursor(select part_no, REGEXP_REPLACE(text, '[[:cntrl:]]', '@') from specification_text where part_no = l_part_no and revision = l_revision and text_type=l_text_type )).getClobVal() into l_var_zonder_ctrl from dual;
      dbms_output.put_line('OK VAR-zonder-ctrl-naar-@ part_no: '||l_part_no||'-'||l_revision||'-'||l_text_type||': '||l_VAR_ZONDER_CTRL);
    exception
      when others
	  then dbms_output.put_line('alg-excp FOUT VAR-zonder-ctrl-naar-@ part_no: '||l_part_no||'-'||l_revision||'-'||l_text_type||': '||l_text||'#'||sqlerrm);
	end;
*/
    --	
/*    begin
      select xmltype(cursor(select part_no, REGEXP_REPLACE(text, '[[:cntrl:]]', '[[:print:]]') from specification_text where part_no = l_part_no and revision = l_revision and text_type=l_text_type )).getClobVal() into l_var_zonder_ctrl from dual;
      dbms_output.put_line('OK VAR-zonder-ctrl-naar-print part_no: '||l_part_no||'-'||l_revision||'-'||l_text_type||': '||l_VAR_ZONDER_CTRL);
    exception
      when others
	  then dbms_output.put_line('alg-excp FOUT VAR-zonder-ctrl-naar-print part_no: '||l_part_no||'-'||l_revision||'-'||l_text_type||': '||l_text||'#'||sqlerrm);
	end;
*/
	--
/*	begin
      select REGEXP_REPLACE(text, '[[:cntrl:]]', '@') into l_var from specification_text where part_no = l_part_no and revision = l_revision and text_type=l_text_type ;
      dbms_output.put_line('alg-excp VULLEN VAN L_VAR-NA-REPLACE part_no: '||l_part_no||'-'||l_revision||'-'||l_text_type||': '||l_var||'#'||l_var_zonder_ctrl||'#'||sqlerrm);
      select xmltype(l_var).getClobVal() into l_var_zonder_ctrl from dual;
      dbms_output.put_line('alg-excp = OK na XMLTYPE VAN L_VAR-NA-REPLACE part_no: '||l_part_no||'-'||l_revision||'-'||l_text_type||': '||l_var||'#'||l_var_zonder_ctrl||'#'||sqlerrm);
    exception
	  when others
	  then dbms_output.put_line('alg-excp FOUT na XMLTYPE VAN L_VAR-NA-REPLACE part_no: '||l_part_no||'-'||l_revision||'-'||l_text_type||': '||l_var||'#'||l_var_zonder_ctrl||'#'||sqlerrm);
	end;
*/
    --dbms_output.put_line('verwerking gereed voor part_no: '||l_part_no||'-'||l_revision||'-'||l_text_type||': '||l_var);

	
	
	
--verwerking gereed voor part_no: 140203-7-702846: 
/*
OK part_no: 140203-7-702846: <?xml version="1.0"?>
<ROWSET>
 <ROW>
  <PART_NO>140203</PART_NO>
  <TEXT>C) Manufacturer to provide their test results for these parameters in the COA.
1) 8 PAH are Benzo(a)anthracene (BaA), Chrysen (CHR), Benzo(j)fluoranthene (BjFA), Benzo(e)pyrene (BeP),Benzo(b)fluoranthene (BbFA), Benzo(k)fluoranthene (BkFA), Benzo(a)pyrene (BaP) and Dibenzo(a,h)anthracene (DBAhA).
2) Manufacturer shall report specific gravity parameter either at 15 °C or at 25°C.
</TEXT>
 </ROW>
</ROWSET>
*/

--nieuwe FOUT:XEV_E21348A-1-702766-700583-700987:
#ORA-21780: Maximum number of object durations exceeded.
	
--nieuwe FOUT:
/*
start procedure
START part_no: EF_T205/55R16NO2X-21-702526-700583-700542: use structol in case of mould stick
OK NA VULLEN VAN L_VAR-NA-REPLACE part_no: EF_T205/55R16NO2X-21-702526-700583-700542: use structol in case of mould stick
alg-excp FOUT part_no: EF_T205/55R16NO2X-21-702526-700583-700542#ORA-31011: XML parsing failed
ORA-19202: Error occurred in XML processing
LPX-00210: expected '<' instead of 'u'
Error at line 1
ORA-06512: at "SYS.XMLTYPE", line 310
ORA-06512: at line 1
end procedure	
*/	


--werkt:
SELECT dbms_xmlgen.getxmltype( 'select part_no, text from specification_text where part_no='||''''||'EF_T205/55R16NO2X'||''''  )
from dual;

--WERKT:
select table_name, DBMS_XMLGen.GetXMLType('select count(*) cnt from '||table_name)  XML_Data
from user_tables
where table_name in ('SPECIFICATION_TEXT')
  
--werkt:
SELECT dbms_xmlgen.getxmltype( 'select rowid, part_no, revision, text_type, section_id, sub_section_id, substr(text,1,3990) text '||
                 ' from specification_text  st '||
				 ' where exists (select 1 '||
				             '  from specification_text st2 '||
							 '  where st2.part_no = st.part_no '||
							 '  and   st2.revision = st.revision '||
							 '  and   st2.text_type = st.text_type '||
							 '  and   st2.section_id = st.section_id '||
							 '  and   st2.sub_section_id = st.sub_section_id '||
							 '  and   st2.revision = (select max(st3.revision)  '||
							  '                       from specification_text st3 '||
                              '                       where st3.part_no = st2.part_no '||
                              '                       and   st3.text_type = st2.text_type  '||
							  '                       and   st3.section_id = st2.section_id '||
                        	  '						 and   st3.sub_section_id = st2.sub_section_id '||
							  '						 ) '||
							  '	) '||
                ' and st.text is not null '||
				' and rownum < 10000 '
                )
from dual;

--met rownum > 1000/10000 loopt proces stuk lijkt het...
start procedure
Teller: 1000
Teller: 2000
Teller: 3000
Teller: 4000
Teller: 5000
Teller: 6000
Teller: 7000
Teller: 8000
Teller: 9000
Teller: 10000
Teller: 11000
Teller: 12000
Teller: 13000
Teller: 14000
Teller: 15000
Teller: 16000
Teller: 17000
Teller: 18000
Teller: 19000
Teller: 20000
Teller: 21000
Teller: 22000
Teller: 23000
Teller: 24000
Teller: 25000
Teller: 26000
Teller: 27000
Teller: 28000
Teller: 29000
Teller: 30000
Teller: 31000
Teller: 32000
Teller: 33000
Teller: 34000
Teller: 35000
Teller: 36000
Teller: 37000
Teller: 38000
Teller: 39000
Teller: 40000
Teller: 41000
Teller: 42000
Teller: 43000
Teller: 44000
Teller: 45000
Teller: 46000
Teller: 47000
Teller: 48000
Teller: 49000
Teller: 50000
Teller: 51000
Teller: 52000
Teller: 53000
Teller: 54000
Teller: 55000
Teller: 56000
Teller: 57000
Teller: 58000
Teller: 59000
Teller: 60000
Teller: 61000
Teller: 62000
Teller: 63000
Teller: 64000
Teller: 65000
Teller: 66000
Teller: 67000
Teller: 68000
Teller: 69000
Teller: 70000
Teller: 71000
Teller: 72000
Teller: 73000
Teller: 74000
Teller: 75000
Teller: 76000
Teller: 77000
Teller: 78000
Teller: 79000
Teller: 80000
Teller: 81000
Teller: 82000
Teller: 83000
Teller: 84000
Teller: 85000
Teller: 86000
Teller: 87000
Teller: 88000
Teller: 89000
Teller: 90000
Teller: 91000
Teller: 92000
Teller: 93000
Teller: 94000
Teller: 95000
Teller: 96000
Teller: 97000
Teller: 98000
Teller: 99000
Teller: 100000
Teller: 101000
Teller: 102000
Teller: 103000
Teller: 104000
Teller: 105000
end procedure

PL/SQL procedure successfully completed.

--CONCLUSIE: MET DBMS_XMLGEN.GETXMLTYPE lukt het dus wel !!!!!!!!!!


--nieuwe procedure:

DECLARE
   l_xmltype XMLTYPE;
BEGIN
    l_xmltype := dbms_xmlgen.getxmltype('SELECT department_id
                                              , department_name
                                           FROM departments
                                          WHERE department_id IN (10,20)'
                                       );
 
    dbms_output.put_line(l_xmltype.getClobVal);
END;
/


--TEST NU OORSPRONKELIJKE XML MET XMLGEN !!!!!!!!!









	
/*
FOUT part_no: 140203-C) Manufacturer to provide their test results for these parameters in the COA.
1) 8 PAH are Benzo(a)anthracene (BaA), Chrysen (CHR), Benzo(j)fluoranthene (BjFA), Benzo(e)pyrene (BeP),Benzo(b)fluoranthene (BbFA), Benzo(k)fluoranthene (BkFA), Benzo(a)pyrene (BaP) and Dibenzo(a,h)anthracene (DBAhA).
2) Manufacturer shall report specific gravity parameter either at 15 °C or at 25°C.

FOUT part_no: 625833R-C) Manufacturer to provide their test results for these parameters in the COA.
1) To be tested with oven dried sample only
2) Specification to be developed
3) 9.53 mm embedment for H adhesion.
4)  Mass per unit area calculated on a calendered fabric width of 127 cm, 98.42 EPDM and 1%  Moisture Regain



.
FOUT part_no: 617542-C) Manufacturer to provide their test results for these parameters in the COA.
1) Sample conditioned for 24 Hours at 24 Deg.C, 55% Relative Humidity
2)Tentative specification
3) Pretension of 0.5 cN / tex
4) 9.52 mm embedment for H adhesion
5)Mass per unit area calculated on a calendered fabric width of 142 cm, 67 EPDM and 0.5 Moisture Regain
6) Spec to be developed

FOUT part_no: 140203-C) Manufacturer to provide their test results for these parameters in the COA.
1) 8 PAH are Benzo(a)anthracene (BaA), Chrysen (CHR), Benzo(j)fluoranthene (BjFA), Benzo(e)pyrene (BeP),Benzo(b)fluoranthene (BbFA), Benzo(k)fluoranthene (BkFA), Benzo(a)pyrene (BaP) and Dibenzo(a,h)anthracene (DBAhA).
2) Typical - These are only indicative values. Tolerance to be established based on Supplier's inputs and Internal test results.
3) Testing may be carried out using either Grimmer Method or by Producer's own method.

FOUT part_no: 636814-C) Manufacturer to provide their test results for these parameters in the COA.
1) Sample conditioned for 24 hours at 24°C, 55% relative humidity
2) Mass per unit area calculated on a calendered fabric width of 127 cm, 140 EPDM and 1%  Moisture Regain

FOUT part_no: 121013-C)  Manufacturer to provide their test results for these parameters in the COA.
1) Softening point by Mercury method (F- 2604) is an acceptable alternative.
2) During the manufacturing process, addition of Castor oil to a maximum of 0.7% as process aid is acceptable.

FOUT part_no: 100141R-C)  Manufacturer to provide their test results for these parameters in the COA.
1) 25 mm width strip
2) no air diffusion

FOUT part_no: 628831-C) Manufacturer to provide their test results for these parameters in the COA.
1) Sample conditioned for 24 Hours at 24 Deg.C, 55% Relative Humidity
2) Mass per unit area calculated on a calendered fabric width of 140 cm, 112 EPDM and 0.5 Moisture Regain

FOUT part_no: X139305-C)  Manufacturer to provide their test results for these parameters in the COA.
1) Identical to Standard
2)  Data to be generated for spec limits.
3) Test method to be generated, Supplier can use their own test method.
4) Softening point by Mercury method (F- 2604) is an acceptable alternative.
5) LDPE Heat sealed sachets


FOUT part_no: 624841-C) Manufacturer to provide their test results for these parameters in the COA.
1) Sample conditioned for 24 Hours at 24 Deg.C, 55% Relative Humidity
2) Mass per unit area calculated on a calendered fabric width of 140 cm, 93 EPDM and 0.5 Moisture Regain
FOUT part_no: 130962B-C)  Manufacturer to provide their test results for these parameters in the COA.
1)Manufacturer may adopt either ISO formation or F method formulation for mixing and testing the vulcanisate properties. Test results based on any one of this should be reported in the COA.

Compound formulation as per F-3153
Stress @ 200 % elongation			min. 2.3 MPa
Tensile Strength				min. 5.9 MPa
Ultimate Elongation ( Strain @ Break )		min. 325 %

F 3153 formulation
Parts by mass 1
MASTER BATCH
RSS-2 100.0
Peptiser (DBD) 0.1
Zinc Oxide 5.0
Stearic Acid 2.0
Total ( Master batch) 107.1
FINAL BATCH
Master batch 42.9
Whole Tyre Reclaim ( UltraFine ) 126.9
MBT 0.5
DPG 0.2
Sulfur 3.0
Total ( Final batch ) 173.5

FOUT part_no: 130962B-C)  Manufacturer to provide their test results for these parameters in the COA.
1) Vulcanized sheet preparation to be done as per ASTM D 3182/ISO 2393. Manufacturer may adopt either ISO formulation or F Method formulation for vulcanizate properties. Test results based on any one of this shall be reported in the COA. Curing conditions are 20 minutes, 140 Deg C for ISO 16095 recipe & 25 minutes, 145 Deg C for F-3153 recipe.
2) Mixing to be done as per the Laboratory mill mixing method
F 3153 formulation (parts by mass)
MASTER BATCH                                                          FINAL BATCH
-------------------                                                                   --------------------
RSS-2                        100.0                                         Master batch                                  42.9
Peptiser (DBD)            0.1                                           Whole Tyre Reclaim ( UltraFine )   126.9
Zinc Oxide                   5.0                                           MBT                                                0.5
Stearic Acid                 2.0                                           DPG                                                0.2
Total ( Master batch) 107.1                                        Sulfur                                               3.0
                                                                                    Total ( Final batch )                        173.5
FOUT part_no: 130090-C)  Manufacturer to provide their test results for these parameters in the COA.
1) Vulcanized sheet preparation to be done as per ASTM D 3182/ISO 2393. Manufacturer may adopt either ISO formulation or F Method formulation for vulcanizate properties. Test results based on any one of this shall be reported in the COA. Curing conditions are 20 minutes, 140 Deg C for ISO 16095 recipe & 25 minutes, 145 Deg C for F-3153 recipe.
2) Mixing to be done as per the Laboratory mill mixing method. 3) Specification to be developed
F 3153 formulation (Parts by mass) 
MASTER BATCH                                                          FINAL BATCH
-------------------                                                                   --------------------
RSS-2                        100.0                                         Master batch                                  42.9
Peptiser (DBD)            0.1                                           Whole Tyre Reclaim ( UltraFine )   126.9
Zinc Oxide                   5.0                                           MBT                                                0.5
Stearic Acid                 2.0                                           DPG                                                0.2
Total ( Master batch) 107.1                                        Sulfur                                               3.0
                                                                                    Total ( Final batch )                        173.5
FOUT part_no: 140203-C) Manufacturer to provide their test results for these parameters in the COA.
1) 8 PAH are Benzo(a)anthracene (BaA), Chrysen (CHR), Benzo(j)fluoranthene (BjFA), Benzo(e)pyrene (BeP),Benzo(b)fluoranthene (BbFA), Benzo(k)fluoranthene (BkFA), Benzo(a)pyrene (BaP) and Dibenzo(a,h)anthracene (DBAhA).
2) Typical - These are only indicative values. Tolerance to be established based on Supplier's inputs and Internal test results.
3) Testing may be carried out using either Grimmer Method or by Producer's own method.

.
FOUT part_no: 629821-C) Manufacturer to provide their test results for these parameters in the COA
1) Pretension 0.1 cN/tex 
2) (5-0.7*heat shrinkage)/5*lase 5% (5=reference for elongation 5 %, 0.7 = factor for lase adjustment)
3) Mass per unit area calculated on 113 epdm at 0.5% MR on a calendered width of 140 cm

FOUT part_no: 150781-C) Manufacturer to provide their test results for these parameters in the COA.
1) DBP Absorption Number is an acceptable alternate to Oil Absorption Number. 
2) The manufacturer should report either STSA or CTAB in the COA.
3) 24 M4 Oil absorption.
4) For Loss on heating and Fines content, the values corresponding to the packing (bulk tankers or jumbo bags or bags) to be taken as specification.
5) Applicable only for supplies in Bulk Tankers.
6) For Ash content, 4 Hrs at 950°C is an acceptable alternative.
7) Fines content through 0.125 mm sieve for 5 minutes.
8) Pellet hardness and pellet size distribution must be controlled to meet the requirements of the plant to which supplies are made with respect to dispersion in the compound and carbon black handling system.

FOUT part_no: 629821-C) Manufacturer to provide their test results for these parameters in the COA.
1) Sample conditioned for 24 Hours at 24 Deg.C, 55% Relative Humidity
2) Mass per unit area calculated on a calendered fabric width of 140 cm, 113 EPDM and 0.5 Moisture Regain
3) Single cord stiffness
FOUT part_no: 105527R-C)  Manufacturer to provide their test results for these parameters in the COA.
1) 25 mm width strip
2) No air diffusion at 1377 kPa for Warp and Weft

Selvedges shall be cut and heat sealed. Additionally supplier can use leno woven cord up to 4th cord from both edges

Compound for testing adhesion
The producer shall send request to the purchase department of the plant to which supplies are made for requirement of compound for testing adhesion

Fabric winding - These are general guidelines only The producer shall clarify the complete packing details with the purchase department of the plant to which supplies are made before supplying the material.



.
FOUT part_no: 617542-C) Manufacturer to provide their test results for these parameters in the COA.
1) Sample conditioned for 24 Hours at 24 Deg.C, 55% Relative Humidity
2) Specification to be developed
3) Mass per unit area calculated on a calendered fabric width of 142 cm, 67 EPDM and 0.5 Moisture Regain
FOUT part_no: 100141R-C)  Manufacturer to provide their test results for these parameters in the COA.
1) 25 mm width strip
2) No air diffusion at 1377 kPa for Warp and Weft

Selvedges shall be cut and heat sealed. Additionally supplier can use leno woven cord up to 4th cord from both edges

Compound for testing adhesion
The producer shall send request to the purchase department of the plant to which supplies are made for requirement of compound for testing adhesion

Fabric winding - These are general guidelines only The producer shall clarify the complete packing details with the purchase department of the plant to which supplies are made before supplying the material.



.
FOUT part_no: 636814-C) Manufacturer to provide their test results for these parameters in the COA.
1) Sample conditioned for 24 hours at 24°C, 55% relative humidity
2) Mass per unit area calculated on a calendered fabric width of 127 cm, 140 EPDM and 1%  Moisture Regain



.
FOUT part_no: 625833R-C) Manufacturer to provide their test results for these parameters in the COA.
1) Stress strain properties to be tested with oven dried sample only
2) Specification to be developed
3) Mass per unit area calculated on a calendered fabric width of 127 cm, 98.42 EPDM and 1%  Moisture Regain



.
FOUT part_no: 161238B-C)  Manufacturer to provide their test results for these parameters in the COA.
1) Vulcanized sheet preparation as per ASTM D 3182, cured for 45 minutes at 141.7 Deg C. Difference in property values between Control and Sample expressed as percentage over Control property values. 
Control - Plant mixed final batch without rubber crumb. Sample - Plant mixed final batch compound with rubber crumb.( Control to be milled to same extend as sample)
Melting point of poly film determined as per ASTM D1519 (DSC peak). Apollo test method F-2604 is an acceptable alternative
Laboratory mill mixing method   
                                 Parts by mass                                     Pre weighed poly bag packing details
                                 ---------------                                       -------------------------------------------                   
Final batch                 172.80                                               Bag weight:                   4.0 kg
Rubber Crumb            5.00                                                  Material:                         LDPE or EVA or blend of these                        
                                  -------------                                                                             Melting point:                 107 Deg C maximum
Total                          177.80                                               Thickness of poly film:    0.04 - 0.06 mm
FOUT part_no: 161238A-C)  Manufacturer to provide their test results for these parameters in the COA.
1) Vulcanized sheet preparation as per ASTM D 3182, cured for 45 minutes at 141.7 Deg C. Difference in property values between Control and Sample expressed as percentage over Control property values. 
Control - Plant mixed final batch without rubber crumb. Sample - Plant mixed final batch compound with rubber crumb.( Control to be milled to same extend as sample)
Melting point of poly film determined as per ASTM D1519 (DSC peak). Apollo test method F-2604 is an acceptable alternative
Laboratory mill mixing method   
                                 Parts by mass                                     Pre weighed poly bag packing details
                                 ---------------                                       -------------------------------------------                   
Final batch                 172.80                                               Bag weight:                   5.5 kg
Rubber Crumb            5.00                                                  Material:                         LDPE or EVA or blend of these                        
                                  -------------                                                                             Melting point:                 107 Deg C maximum
Total                          177.80                                               Thickness of poly film:    0.04 - 0.06 mm
FOUT part_no: 150781-C) Manufacturer to provide their test results for these parameters in the COA.
1) DBP Absorption Number is an acceptable alternate to Oil Absorption Number. 
2) The manufacturer should report either STSA or CTAB in the COA.
3) 24 M4 Oil absorption.
4) For Loss on heating & Fines content, the values corresponding to the packing (bulk tankers or jumbo bags or bags) to be taken as specification.
5) Applicable only for supplies in Bulk Tankers.
6) For Ash content, 4 Hrs at 950°C is an acceptable alternative.
7) Fines content through 0.125 mm sieve for 5 minutes.
8) Pellet hardness and pellet size distribution must be controlled to meet the requirements of the plant to which supplies are made with respect to dispersion in the compound and carbon black handling system.

FOUT part_no: 624841-C) Manufacturer to provide their test results for these parameters in the COA
1) Pretension 0.1 cN/tex pretension
2) (5-0.7*heat shrinkage)/5*lase 5% (5=reference for elongation 5 %, 0.7 = factor for lase adjustment)
3) Mass per unit area calculated on a calendered width of 142 cm, 93.3 epdm and 0.5% MR


.
FOUT part_no: X139305-C) Manufacturer to provide their test results for these parameters in the COA.
1) Identical to Standard
2) Data to be generated for spec limits.
3) Test method to be generated, Supplier can use their own test method.
4) LDPE Heat sealed sachets
5) Softening point by Mercury method (F- 2604) is an acceptable alternative.

Packing
----------
These are general guidelines only. The producer shall clarify the complete packing & material identification details with the purchase department of the plant to which supplies are made before supplying the material. 
The material can be supplied in 2 Kg pouch, 15 kg can, 165 kg drum or 800 Kgs Intermediate Bulk Container ( net weight ) or as specified in the purchase order. The packing should be capable of preventing sunlight / moisture absorption during transit, storage and handling. The base of the drum / IBC should be of good quality material and shall not damage during transit, storage and handling. Each can / drum / container / IBC shall be identified with all relevant details given under "Material Identification".
FOUT part_no: 628831-C) Manufacturer to provide their test results for these parameters in the COA
1) Pretension 0.1 cN/tex pretension
2) (5-0.7*heat shrinkage)/5*lase 5% (5=reference for elongation 5 %, 0.7 = factor for lase adjustment)
3) Mass per unit area calculated for calendered width of 140 cm,112 epdm and 0.5% MR


.
FOUT part_no: 140203-C) Manufacturer to provide their test results for these parameters in the COA.
1) 8 PAH are Benzo(a)anthracene (BaA), Chrysen (CHR), Benzo(j)fluoranthene (BjFA), Benzo(e)pyrene (BeP),Benzo(b)fluoranthene (BbFA), Benzo(k)fluoranthene (BkFA), Benzo(a)pyrene (BaP) and Dibenzo(a,h)anthracene (DBAhA).
2) Typical - These are only indicative values. Tolerance to be established based on Supplier's inputs and Internal test results.
3) Testing may be carried out using either Grimmer Method or by Producer's own method.

.
FOUT part_no: 636751-C) Manufacturer to provide their test results for these parameters in the COA.
1) Sample conditioned for 24 hours at 24°C, 55% relative humidity
2) Pretension 0.5 cN/tex
3) Mass per unit area & mass per linear meter calculated on a calendered fabric width of 137 cm, 140 EPDM and 1%  Moisture Regain
FOUT part_no: X139305-C) Manufacturer to provide their test results for these parameters in the COA.
1) Identical to Standard.
2) Data to be generated for spec limits.
3) Test method to be generated, Supplier can use their own test method.
4) LDPE Heat sealed sachets.
5) Softening point by Mercury method (F- 2604) is an acceptable alternative.

Packing
----------
These are general guidelines only. The producer shall clarify the complete packing & material identification details with the purchase department of the plant to which supplies are made before supplying the material. 
The material can be supplied in 2 Kg pouch, 15 kg can, 165 kg drum or 800 Kgs Intermediate Bulk Container ( net weight ) or as specified in the purchase order. The packing should be capable of preventing sunlight / moisture absorption during transit, storage and handling. The base of the drum / IBC should be of good quality material and shall not damage during transit, storage and handling. Each can / drum / container / IBC shall be identified with all relevant details given under "Material Identification".
FOUT part_no: 139305-C) Manufacturer to provide their test results for these parameters in the COA.
1) Identical to Standard
2) Data to be generated for spec limits.
3) Test method to be generated, Supplier can use their own test method.
4) LDPE Heat sealed sachets
5) Softening point by Mercury method (F- 2604) is an acceptable alternative.

Packing
----------
These are general guidelines only. The producer shall clarify the complete packing & material identification details with the purchase department of the plant to which supplies are made before supplying the material. 
The material can be supplied in 2 Kg pouch, 15 kg can, 165 kg drum or 800 Kgs Intermediate Bulk Container ( net weight ) or as specified in the purchase order. The packing should be capable of preventing sunlight / moisture absorption during transit, storage and handling. The base of the drum / IBC should be of good quality material and shall not damage during transit, storage and handling. Each can / drum / container / IBC shall be identified with all relevant details given under "Material Identification".
FOUT part_no: 130962B-C)  Manufacturer to provide their test results for these parameters in the COA.
1) Vulcanized sheet preparation to be done as per ASTM D 3182/ISO 2393. Manufacturer may adopt either ISO formulation or F Method formulation for vulcanizate properties. Test results based on any one of this shall be reported in the COA. Curing conditions are 20 minutes, 140 Deg C for ISO 16095 recipe & 25 minutes, 145 Deg C for F-3153 recipe.
2) Mixing to be done as per the Laboratory mill mixing method
F 3153 formulation (parts by mass)
MASTER BATCH                                                          FINAL BATCH
-------------------                                                                   --------------------
RSS-2                        100.0                                         Master batch                                  42.9
Peptiser (DBD)            0.1                                           Whole Tyre Reclaim ( UltraFine )   126.9
Zinc Oxide                   5.0                                           MBT                                                0.5
Stearic Acid                 2.0                                           DPG                                                0.2
Total ( Master batch) 107.1                                        Sulfur                                               3.0
                                                                                    Total ( Final batch )                        173.5
FOUT part_no: 130090-C)  Manufacturer to provide their test results for these parameters in the COA.
1) Vulcanized sheet preparation to be done as per ASTM D 3182/ISO 2393. Manufacturer may adopt either ISO formulation or F Method formulation for vulcanizate properties. Test results based on any one of this shall be reported in the COA. Curing conditions are 20 minutes, 140 Deg C for ISO 16095 recipe & 25 minutes, 145 Deg C for F-3153 recipe.
2) Mixing to be done as per the Laboratory mill mixing method. 3) Specification to be developed
F 3153 formulation (Parts by mass) 
MASTER BATCH                                                          FINAL BATCH
-------------------                                                                   --------------------
RSS-2                        100.0                                         Master batch                                  42.9
Peptiser (DBD)            0.1                                           Whole Tyre Reclaim ( UltraFine )   126.9
Zinc Oxide                   5.0                                           MBT                                                0.5
Stearic Acid                 2.0                                           DPG                                                0.2
Total ( Master batch) 107.1                                        Sulfur                                               3.0
                                                                                    Total ( Final batch )                        173.5
FOUT part_no: 100141R-C)  Manufacturer to provide their test results for these parameters in the COA.
1) 25 mm width strip
2) No air diffusion at 1377 kPa for Warp and Weft

Selvedges shall be cut and heat sealed. Additionally supplier can use leno woven cord up to 4th cord from both edges

Compound for testing adhesion
The producer shall send request to the purchase department of the plant to which supplies are made for requirement of compound for testing adhesion

Fabric winding - These are general guidelines only The producer shall clarify the complete packing details with the purchase department of the plant to which supplies are made before supplying the material.



.
FOUT part_no: 150781-C) Manufacturer to provide their test results for these parameters in the COA.
1) DBP Absorption Number is an acceptable alternate to Oil Absorption Number. 
2) The manufacturer should report either STSA or CTAB in the COA.
3) 24 M4 Oil absorption.
4) For Loss on heating & Fines content, the values corresponding to the packing (bulk tankers or jumbo bags or bags) to be taken as specification.
5) Applicable only for supplies in Bulk Tankers.
6) For Ash content, 4 Hrs at 950°C is an acceptable alternative.
7) Fines content through 0.125 mm sieve for 5 minutes.
8) Pellet hardness and pellet size distribution must be controlled to meet the requirements of the plant to which supplies are made with respect to dispersion in the compound and carbon black handling system.

FOUT part_no: X139305-C) Manufacturer to provide their test results for these parameters in the COA.
1) Identical to Standard.
2) Data to be generated for spec limits.
3) Test method to be generated, Supplier can use their own test method.
4) LDPE Heat sealed sachets.
5) Softening point by Mercury method (F- 2604) is an acceptable alternative.

Packing
----------
These are general guidelines only. The producer shall clarify the complete packing & material identification details with the purchase department of the plant to which supplies are made before supplying the material. 
The material can be supplied in 2 Kg pouch, 15 kg can, 165 kg drum or 800 Kgs Intermediate Bulk Container ( net weight ) or as specified in the purchase order. The packing should be capable of preventing sunlight / moisture absorption during transit, storage and handling. The base of the drum / IBC should be of good quality material and shall not damage during transit, storage and handling. Each can / drum / container / IBC shall be identified with all relevant details given under "Material Identification".
FOUT part_no: 130962B-C)  Manufacturer to provide their test results for these parameters in the COA.
1) Vulcanized sheet preparation to be done as per ASTM D 3182/ISO 2393. Manufacturer may adopt either ISO formulation or F Method formulation for vulcanizate properties. Test results based on any one of this shall be reported in the COA. Curing conditions are 20 minutes, 140 Deg C for ISO 16095 recipe & 25 minutes, 145 Deg C for F-3153 recipe.
2) Mixing to be done as per the Laboratory mill mixing method
F 3153 formulation (parts by mass)
MASTER BATCH                                                          FINAL BATCH
-------------------                                                                   --------------------
RSS-2                        100.0                                         Master batch                                  42.9
Peptiser (DBD)            0.1                                           Whole Tyre Reclaim ( UltraFine )   126.9
Zinc Oxide                   5.0                                           MBT                                                0.5
Stearic Acid                 2.0                                           DPG                                                0.2
Total ( Master batch) 107.1                                        Sulfur                                               3.0
                                                                                    Total ( Final batch )                        173.5
FOUT part_no: 636751-C) Manufacturer to provide their test results for these parameters in the COA.
1) Sample conditioned for 24 hours at 24°C, 55% relative humidity
2) Pretension 0.5 cN/tex
3) Mass per unit area & mass per linear meter calculated on a calendered fabric width of 137 cm, 140 EPDM and 1%  Moisture Regain
4) Specification to be generated based on test results.


.
FOUT part_no: 161238A-C)  Manufacturer to provide their test results for these parameters in the COA.
1) Vulcanized sheet preparation as per ASTM D 3182, cured for 45 minutes at 141.7 Deg C. Difference in property values between Control and Sample expressed as percentage over Control property values. 
Control - Plant mixed final batch without rubber crumb. Sample - Plant mixed final batch compound with rubber crumb.( Control to be milled to same extend as sample)
Melting point of poly film determined as per ASTM D1519 (DSC peak). Apollo test method F-2604 is an acceptable alternative
Laboratory mill mixing method   
                                 Parts by mass                                     Pre weighed poly bag packing details
                                 ---------------                                       -------------------------------------------                   
Final batch                 172.80                                               Bag weight:                   5.5 kg
Rubber Crumb            5.00                                                  Material:                         LDPE or EVA or blend of these                        
                                  -------------                                                                             Melting point:                 107 Deg C maximum
Total                          177.80                                               Thickness of poly film:    0.04 - 0.06 mm
FOUT part_no: 617542-C) Manufacturer to provide their test results for these parameters in the COA.
1) Sample conditioned for 24 Hours at 24 Deg.C, 55% Relative Humidity
2) Specification to be developed
3) Mass per unit area calculated on a calendered fabric width of 142 cm, 67 EPDM and 0.5 Moisture Regain
FOUT part_no: 161238B-C)  Manufacturer to provide their test results for these parameters in the COA.
1) Vulcanized sheet preparation as per ASTM D 3182, cured for 45 minutes at 141.7 Deg C. Difference in property values between Control and Sample expressed as percentage over Control property values. 
Control - Plant mixed final batch without rubber crumb. Sample - Plant mixed final batch compound with rubber crumb.( Control to be milled to same extend as sample)
Melting point of poly film determined as per ASTM D1519 (DSC peak). Apollo test method F-2604 is an acceptable alternative
Laboratory mill mixing method   
                                 Parts by mass                                     Pre weighed poly bag packing details
                                 ---------------                                       -------------------------------------------                   
Final batch                 172.80                                               Bag weight:                   4.0 kg
Rubber Crumb            5.00                                                  Material:                         LDPE or EVA or blend of these                        
                                  -------------                                                                             Melting point:                 107 Deg C maximum
Total                          177.80                                               Thickness of poly film:    0.04 - 0.06 mm
FOUT part_no: 636814-C) Manufacturer to provide their test results for these parameters in the COA.
1) Sample conditioned for 24 hours at 24°C, 55% relative humidity
2) Mass per unit area calculated on a calendered fabric width of 127 cm, 140 EPDM and 1%  Moisture Regain



.
FOUT part_no: 140203-C) Manufacturer to provide their test results for these parameters in the COA.
1) 8 PAH are Benzo(a)anthracene (BaA), Chrysen (CHR), Benzo(j)fluoranthene (BjFA), Benzo(e)pyrene (BeP),Benzo(b)fluoranthene (BbFA), Benzo(k)fluoranthene (BkFA), Benzo(a)pyrene (BaP) and Dibenzo(a,h)anthracene (DBAhA).
2) Typical - These are only indicative values. Tolerance to be established based on Supplier's inputs and Internal test results.


.
FOUT part_no: 161238B-C)  Manufacturer to provide their test results for these parameters in the COA.
1) Vulcanized sheet preparation as per ASTM D 3182, cured for 45 minutes at 141.7 Deg C. Difference in property values between Control and Sample expressed as percentage over Control property values. 
Control - Plant mixed final batch without rubber crumb. Sample - Plant mixed final batch compound with rubber crumb.( Control to be milled to same extend as sample)
Melting point of poly film determined as per ASTM D1519 (DSC peak). Apollo test method F-2604 is an acceptable alternative
Laboratory mill mixing method   
                                 Parts by mass                                     Pre weighed poly bag packing details
                                 ---------------                                       -------------------------------------------                   
Final batch                 172.80                                               Bag weight:                   4.0 kg
Rubber Crumb            5.00                                                  Material:                         LDPE or EVA or blend of these                        
                                  -------------                                                                             Melting point:                 107 Deg C maximum
Total                          177.80                                               Thickness of poly film:    0.04 - 0.06 mm
FOUT part_no: 161238B-C)  Manufacturer to provide their test results for these parameters in the COA.
1) Vulcanized sheet preparation as per ASTM D 3182, cured for 45 minutes at 141.7 Deg C. Difference in property values between Control and Sample expressed as percentage over Control property values. 
Control - Plant mixed final batch without rubber crumb. Sample - Plant mixed final batch compound with rubber crumb.( Control to be milled to same extend as sample)
Melting point of poly film determined as per ASTM D1519 (DSC peak). Apollo test method F-2604 is an acceptable alternative
Laboratory mill mixing method   
                                 Parts by mass                                     Pre weighed poly bag packing details
                                 ---------------                                       -------------------------------------------                   
Final batch                 172.80                                               Bag weight:                   4.0 kg
Rubber Crumb            5.00                                                  Material:                         LDPE or EVA or blend of these                        
                                  -------------                                                                             Melting point:                 107 Deg C maximum
Total                          177.80                                               Thickness of poly film:    0.04 - 0.06 mm
FOUT part_no: 161238A-C)  Manufacturer to provide their test results for these parameters in the COA.
1) Vulcanized sheet preparation as per ASTM D 3182, cured for 45 minutes at 141.7 Deg C. Difference in property values between Control and Sample expressed as percentage over Control property values. 
Control - Plant mixed final batch without rubber crumb. Sample - Plant mixed final batch compound with rubber crumb.( Control to be milled to same extend as sample)
Melting point of poly film determined as per ASTM D1519 (DSC peak). Apollo test method F-2604 is an acceptable alternative
Laboratory mill mixing method   
                                 Parts by mass                                     Pre weighed poly bag packing details
                                 ---------------                                       -------------------------------------------                   
Final batch                 172.80                                               Bag weight:                   5.5 kg
Rubber Crumb            5.00                                                  Material:                         LDPE or EVA or blend of these                        
                                  -------------                                                                             Melting point:                 107 Deg C maximum
Total                          177.80                                               Thickness of poly film:    0.04 - 0.06 mm
FOUT part_no: 628831-C) Manufacturer to provide their test results for these parameters in the COA
1) Pretension 0.1 cN/tex pretension
2) (5-0.7*heat shrinkage)/5*lase 5% (5=reference for elongation 5 %, 0.7 = factor for lase adjustment)
3) Mass per unit area calculated for calendered width of 140 cm,112 epdm and 0.5% MR


.
FOUT part_no: 624841-C) Manufacturer to provide their test results for these parameters in the COA
1) Pretension 0.1 cN/tex pretension
2) (5-0.7*heat shrinkage)/5*lase 5% (5=reference for elongation 5 %, 0.7 = factor for lase adjustment)
3) Mass per unit area calculated on a calendered width of 142 cm, 93.3 epdm and 0.5% MR


.
FOUT part_no: 636814-C) Manufacturer to provide their test results for these parameters in the COA.
1) Sample conditioned for 24 hours at 24°C, 55% relative humidity
2) Mass per unit area calculated on a calendered fabric width of 127 cm, 140 EPDM and 1%  Moisture Regain



.
FOUT part_no: 150781-C) Manufacturer to provide their test results for these parameters in the COA.
1) DBP Absorption Number is an acceptable alternate to Oil Absorption Number. 
2) The manufacturer should report either STSA or CTAB in the COA.
3) 24 M4 Oil absorption.
4) For Loss on heating & Fines content, the values corresponding to the packing (bulk tankers or jumbo bags or bags) to be taken as specification.
5) Applicable only for supplies in Bulk Tankers.
6) For Ash content, 4 Hrs at 950°C is an acceptable alternative.
7) Fines content through 0.125 mm sieve for 5 minutes.
8) Pellet hardness and pellet size distribution must be controlled to meet the requirements of the plant to which supplies are made with respect to dispersion in the compound and carbon black handling system.

FOUT part_no: 636814-C) Manufacturer to provide their test results for these parameters in the COA.
1) Sample conditioned for 24 hours at 24°C, 55% relative humidity
2) Mass per unit area calculated on a calendered fabric width of 127 cm, 140 EPDM and 1%  Moisture Regain



.
FOUT part_no: 636751-C) Manufacturer to provide their test results for these parameters in the COA.
1) Sample conditioned for 24 hours at 24°C, 55% relative humidity
2) Pretension 0.5 cN/tex
3) Mass per unit area & mass per linear meter calculated on a calendered fabric width of 137 cm, 140 EPDM and 1%  Moisture Regain
4) Specification to be generated based on test results.


.
FOUT part_no: 629821-C) Manufacturer to provide their test results for these parameters in the COA
1) Pretension 0.1 cN/tex 
2) (5-0.7*heat shrinkage)/5*lase 5% (5=reference for elongation 5 %, 0.7 = factor for lase adjustment)
3) Mass per unit area calculated on 113 epdm at 0.5% MR on a calendered width of 140 cm

FOUT part_no: 636814-C) Manufacturer to provide their test results for these parameters in the COA.
1) Sample conditioned for 24 hours at 24°C, 55% relative humidity
2) Mass per unit area calculated on a calendered fabric width of 127 cm, 140 EPDM and 1%  Moisture Regain



.
FOUT part_no: 140203-C) Manufacturer to provide their test results for these parameters in the COA.
1) 8 PAH are Benzo(a)anthracene (BaA), Chrysen (CHR), Benzo(j)fluoranthene (BjFA), Benzo(e)pyrene (BeP),Benzo(b)fluoranthene (BbFA), Benzo(k)fluoranthene (BkFA), Benzo(a)pyrene (BaP) and Dibenzo(a,h)anthracene (DBAhA).
2) Typical - These are only indicative values. Tolerance to be established based on Supplier's inputs and Internal test results.


.
FOUT part_no: 139305-C) Manufacturer to provide their test results for these parameters in the COA.
1) Identical to Standard
2) Data to be generated for spec limits.
3) Test method to be generated, Supplier can use their own test method.
4) LDPE Heat sealed sachets
5) Softening point by Mercury method (F- 2604) is an acceptable alternative.

Packing
----------
These are general guidelines only. The producer shall clarify the complete packing & material identification details with the purchase department of the plant to which supplies are made before supplying the material. 
The material can be supplied in 2 Kg pouch, 15 kg can, 165 kg drum or 800 Kgs Intermediate Bulk Container ( net weight ) or as specified in the purchase order. The packing should be capable of preventing sunlight / moisture absorption during transit, storage and handling. The base of the drum / IBC should be of good quality material and shall not damage during transit, storage and handling. Each can / drum / container / IBC shall be identified with all relevant details given under "Material Identification".
FOUT part_no: 140203-C) Manufacturer to provide their test results for these parameters in the COA.
1) 8 PAH are Benzo(a)anthracene (BaA), Chrysen (CHR), Benzo(j)fluoranthene (BjFA), Benzo(e)pyrene (BeP),Benzo(b)fluoranthene (BbFA), Benzo(k)fluoranthene (BkFA), Benzo(a)pyrene (BaP) and Dibenzo(a,h)anthracene (DBAhA).
2) Typical - These are only indicative values. Tolerance to be established based on Supplier's inputs and Internal test results.


.
FOUT part_no: 130090-C)  Manufacturer to provide their test results for these parameters in the COA.
1) Vulcanized sheet preparation to be done as per ASTM D 3182/ISO 2393. Manufacturer may adopt either ISO formulation or F Method formulation for vulcanizate properties. Test results based on any one of this shall be reported in the COA. Curing conditions are 20 minutes, 140 Deg C for ISO 16095 recipe & 25 minutes, 145 Deg C for F-3153 recipe.
2) Mixing to be done as per the Laboratory mill mixing method. 3) Specification to be developed
F 3153 formulation (Parts by mass) 
MASTER BATCH                                                          FINAL BATCH
-------------------                                                                   --------------------
RSS-2                        100.0                                         Master batch                                  42.9
Peptiser (DBD)            0.1                                           Whole Tyre Reclaim ( UltraFine )   126.9
Zinc Oxide                   5.0                                           MBT                                                0.5
Stearic Acid                 2.0                                           DPG                                                0.2
Total ( Master batch) 107.1                                        Sulfur                                               3.0
                                                                                    Total ( Final batch )                        173.5
FOUT part_no: 629821-C) Manufacturer to provide their test results for these parameters in the COA
1) Pretension 0.1 cN/tex 
2) (5-0.7*heat shrinkage)/5*lase 5% (5=reference for elongation 5 %, 0.7 = factor for lase adjustment)
3) Mass per unit area calculated on 113 epdm at 0.5% MR on a calendered width of 140 cm

FOUT part_no: 629821-C) Manufacturer to provide their test results for these parameters in the COA
1) Pretension 0.1 cN/tex 
2) (5-0.7*heat shrinkage)/5*lase 5% (5=reference for elongation 5 %, 0.7 = factor for lase adjustment)
3) Mass per unit area calculated on 113 epdm at 0.5% MR on a calendered width of 140 cm

FOUT part_no: 625833R-C) Manufacturer to provide their test results for these parameters in the COA.
1) Stress strain properties to be tested with oven dried sample only
2) Specification to be developed
3) Mass per unit area calculated on a calendered fabric width of 127 cm, 98.42 EPDM and 1%  Moisture Regain



.
FOUT part_no: 617542-C) Manufacturer to provide their test results for these parameters in the COA.
1) Sample conditioned for 24 Hours at 24 Deg.C, 55% Relative Humidity
2) Specification to be developed
3) Mass per unit area calculated on a calendered fabric width of 142 cm, 67 EPDM and 0.5 Moisture Regain
FOUT part_no: 625833R-C) Manufacturer to provide their test results for these parameters in the COA.
1) Stress strain properties to be tested with oven dried sample only
2) Specification to be developed
3) Mass per unit area calculated on a calendered fabric width of 127 cm, 98.42 EPDM and 1%  Moisture Regain



.
FOUT part_no: 636751-C) Manufacturer to provide their test results for these parameters in the COA.
1) Sample conditioned for 24 hours at 24°C, 55% relative humidity
2) Pretension 0.5 cN/tex
3) Mass per unit area & mass per linear meter calculated on a calendered fabric width of 137 cm, 140 EPDM and 1%  Moisture Regain
4) Specification to be generated based on test results.


.
FOUT part_no: 105527R-C)  Manufacturer to provide their test results for these parameters in the COA.
1) 25 mm width strip
2) No air diffusion at 1377 kPa for Warp and Weft

Selvedges shall be cut and heat sealed. Additionally supplier can use leno woven cord up to 4th cord from both edges

Compound for testing adhesion
The producer shall send request to the purchase department of the plant to which supplies are made for requirement of compound for testing adhesion

Fabric winding - These are general guidelines only The producer shall clarify the complete packing details with the purchase department of the plant to which supplies are made before supplying the material.



.
FOUT part_no: 100141R-C)  Manufacturer to provide their test results for these parameters in the COA.
1) 25 mm width strip
2) No air diffusion at 1377 kPa for Warp and Weft

Selvedges shall be cut and heat sealed. Additionally supplier can use leno woven cord up to 4th cord from both edges

Compound for testing adhesion
The producer shall send request to the purchase department of the plant to which supplies are made for requirement of compound for testing adhesion

Fabric winding - These are general guidelines only The producer shall clarify the complete packing details with the purchase department of the plant to which supplies are made before supplying the material.



.
FOUT part_no: 100141R-C)  Manufacturer to provide their test results for these parameters in the COA.
1) 25 mm width strip
2) No air diffusion at 1377 kPa for Warp and Weft

Selvedges shall be cut and heat sealed. Additionally supplier can use leno woven cord up to 4th cord from both edges

Compound for testing adhesion
The producer shall send request to the purchase department of the plant to which supplies are made for requirement of compound for testing adhesion

Fabric winding - These are general guidelines only The producer shall clarify the complete packing details with the purchase department of the plant to which supplies are made before supplying the material.



.
FOUT part_no: 625833R-C) Manufacturer to provide their test results for these parameters in the COA.
1) To be tested with oven dried sample only
2) Specification to be developed
3) Mass per unit area calculated on a calendered fabric width of 127 cm, 98.42 EPDM and 1%  Moisture Regain



.
FOUT part_no: 105527R-C)  Manufacturer to provide their test results for these parameters in the COA.
1) 25 mm width strip
2) No air diffusion at 1377 kPa for Warp and Weft

Selvedges shall be cut and heat sealed. Additionally supplier can use leno woven cord up to 4th cord from both edges

Compound for testing adhesion
The producer shall send request to the purchase department of the plant to which supplies are made for requirement of compound for testing adhesion

Fabric winding - These are general guidelines only The producer shall clarify the complete packing details with the purchase department of the plant to which supplies are made before supplying the material.



.
FOUT part_no: 628831-C) Manufacturer to provide their test results for these parameters in the COA
1) Pretension 0.1 cN/tex pretension
2) (5-0.7*heat shrinkage)/5*lase 5% (5=reference for elongation 5 %, 0.7 = factor for lase adjustment)
3) Mass per unit area calculated for calendered width of 140 cm,112 epdm and 0.5% MR


.
FOUT part_no: 624841-C) Manufacturer to provide their test results for these parameters in the COA
1) Pretension 0.1 cN/tex pretension
2) (5-0.7*heat shrinkage)/5*lase 5% (5=reference for elongation 5 %, 0.7 = factor for lase adjustment)
3) Mass per unit area calculated on a calendered width of 142 cm, 93.3 epdm and 0.5% MR


.
FOUT part_no: 636814-C) Manufacturer to provide their test results for these parameters in the COA.
1) Sample conditioned for 24 hours at 24°C, 55% relative humidity
2) Mass per unit area calculated on a calendered fabric width of 127 cm, 140 EPDM and 1%  Moisture Regain



.
FOUT part_no: 617542-C) Manufacturer to provide their test results for these parameters in the COA.
1) Sample conditioned for 24 Hours at 24 Deg.C, 55% Relative Humidity
2) Specification to be developed
3) Mass per unit area calculated on a calendered fabric width of 142 cm, 67 EPDM and 0.5 Moisture Regain
FOUT part_no: 636814-C) Manufacturer to provide their test results for these parameters in the COA.
1) Sample conditioned for 24 hours at 24°C, 55% relative humidity
2) Mass per unit area calculated on a calendered fabric width of 127 cm, 140 EPDM and 1%  Moisture Regain



.
FOUT part_no: 617542-C) Manufacturer to provide their test results for these parameters in the COA.
1) Sample conditioned for 24 Hours at 24 Deg.C, 55% Relative Humidity
2) Specification to be developed
3) Mass per unit area calculated on a calendered fabric width of 142 cm, 67 EPDM and 0.5 Moisture Regain
FOUT part_no: 636751-C) Manufacturer to provide their test results for these parameters in the COA.
1) Sample conditioned for 24 hours at 24°C, 55% relative humidity
2) Pretension 0.5 cN/tex
3) Mass per unit area & mass per linear meter calculated on a calendered fabric width of 137 cm, 140 EPDM and 1%  Moisture Regain
4) Specification to be generated based on test results.


.
FOUT part_no: 625833R-C) Manufacturer to provide their test results for these parameters in the COA.
1) To be tested with oven dried sample only
2) Specification to be developed
3) Mass per unit area calculated on a calendered fabric width of 127 cm, 98.42 EPDM and 1%  Moisture Regain



.
FOUT part_no: 625833R-C) Manufacturer to provide their test results for these parameters in the COA.
1) To be tested with oven dried sample only
2) Specification to be developed
3) Mass per unit area calculated on a calendered fabric width of 127 cm, 98.42 EPDM and 1%  Moisture Regain



.
FOUT part_no: 636751-C) Manufacturer to provide their test results for these parameters in the COA.
1) Sample conditioned for 24 hours at 24°C, 55% relative humidity
2) Pretension 0.5 cN/tex
3) Mass per unit area & mass per linear meter calculated on a calendered fabric width of 137 cm, 140 EPDM and 1%  Moisture Regain
4) Specification to be generated based on test results.


.
FOUT part_no: 617542-C) Manufacturer to provide their test results for these parameters in the COA.
1) Sample conditioned for 24 Hours at 24 Deg.C, 55% Relative Humidity
2) Specification to be developed
3) Pretension of 0.5 cN / tex
4) Mass per unit area calculated on a calendered fabric width of 142 cm, 67 EPDM and 0.5 Moisture Regain
FOUT part_no: 105527R-C)  Manufacturer to provide their test results for these parameters in the COA.
1) No air diffusion at 1377 kPa for Warp and Weft

Selvedges shall be cut and heat sealed. Additionally supplier can use leno woven cord up to 4th cord from both edges

Compound for testing adhesion
The producer shall send request to the purchase department of the plant to which supplies are made for requirement of compound for testing adhesion







.
FOUT part_no: 100046B-C)  Manufacturer to provide their test results for these parameters in the COA. 

Selvedges shall be cut and heat sealed. Additionally supplier can use leno woven cord upto 4th cord from both edges.

Compound for testing adhesion
The producer shall send request to the purchase department of the plant to which supplies are made for requirement of compound for testing adhesion.








.
FOUT part_no: 100046R-C)  Manufacturer to provide their test results for these parameters in the COA. 

Selvedges shall be cut and heat sealed. Additionally supplier can use leno woven cord upto 4th cord from both edges.

Compound for testing adhesion
The producer shall send request to the purchase department of the plant to which supplies are made for requirement of compound for testing adhesion.

Fabric winding
These are general guidelines only. The producer shall clarify the complete packing details with the purchase department of the plant to which supplies are made before supplying the material.





.
FOUT part_no: 100141R-C)  Manufacturer to provide their test results for these parameters in the COA.
1) No air diffusion at 1377 kPa for Warp and Weft

Selvedges shall be cut and heat sealed. Additionally supplier can use leno woven cord up to 4th cord from both edges

Compound for testing adhesion
The producer shall send request to the purchase department of the plant to which supplies are made for requirement of compound for testing adhesion






.
FOUT part_no: X135125-C) Manufacturer to provide their test results for these parameters in the COA.
1) Identical to Standard.
2) Data to be generated for spec limits.
3) Test method to be generated, Supplier can use their own test method.




.
FOUT part_no: X135125-C) Manufacturer to provide their test results for these parameters in the COA.
1) Identical to Standard.








.
FOUT part_no: 628831-C) Manufacturer to provide their test results for these parameters in the COA
1) Pretension 0.1 cN/tex pretension
2) (5-0.7*heat shrinkage)/5*lase 5% (5=reference for elongation 5 %, 0.7 = factor for lase adjustment)
3) Mass per unit area calculated for calendered width of 140 cm,112 epdm and 0.5% MR


.
FOUT part_no: 629821-C) Manufacturer to provide their test results for these parameters in the COA
1) Pretension 0.1 cN/tex 
2) (5-0.7*heat shrinkage)/5*lase 5% (5=reference for elongation 5 %, 0.7 = factor for lase adjustment)
3) Mass per unit area calculated on 113 epdm at 0.5% MR on a calendered width of 140 cm

.

FOUT part_no: 636814-C) Manufacturer to provide their test results for these parameters in the COA.
1) Sample conditioned for 24 hours at 24°C, 55% relative humidity
2) Mass per unit area calculated on a calendered fabric width of 127 cm, 140 EPDM and 1%  Moisture Regain



.
FOUT part_no: 139305-C) Manufacturer to provide their test results for these parameters in the COA.
1) Identical to Standard.
2) Data to be generated for spec limits.
3) Test method to be generated, Supplier can use their own test method.
4) LDPE Heat sealed sachets.
5) Softening point by Mercury method (F- 2604) is an acceptable alternative.

Packing
----------
These are general guidelines only. The producer shall clarify the complete packing & material identification details with the purchase department of the plant to which supplies are made before supplying the material. 
The material can be supplied in 2 Kg pouch, 15 kg can, 165 kg drum or 800 Kgs Intermediate Bulk Container ( net weight ) or as specified in the purchase order. The packing should be capable of preventing sunlight / moisture absorption during transit, storage and handling. The base of the drum / IBC should be of good quality material and shall not damage during transit, storage and handling. Each can / drum / container / IBC shall be identified with all relevant details given under "Material Identification".
FOUT part_no: 629821-C) Manufacturer to provide their test results for these parameters in the COA
1) Pretension 0.1 cN/tex 
2) (5-0.7*heat shrinkage)/5*lase 5% (5=reference for elongation 5 %, 0.7 = factor for lase adjustment)
3) Mass per unit area calculated on 113 epdm at 0.5% MR on a calendered width of 140 cm

.

FOUT part_no: 628831-C) Manufacturer to provide their test results for these parameters in the COA
1) Pretension 0.1 cN/tex pretension
2) (5-0.7*heat shrinkage)/5*lase 5% (5=reference for elongation 5 %, 0.7 = factor for lase adjustment)
3) Mass per unit area calculated for calendered width of 140 cm,112 epdm and 0.5% MR


.
FOUT part_no: 624841-C) Manufacturer to provide their test results for these parameters in the COA
1) Pretension 0.1 cN/tex pretension
2) (5-0.7*heat shrinkage)/5*lase 5% (5=reference for elongation 5 %, 0.7 = factor for lase adjustment)
3) Mass per unit area calculated on a calendered width of 142 cm, 93.3 epdm and 0.5% MR


.
FOUT part_no: 636751-C) Manufacturer to provide their test results for these parameters in the COA.
1) Sample conditioned for 24 hours at 24°C, 55% relative humidity
2) Pretension 0.5 cN/tex
3) Mass per unit area & mass per linear meter calculated on a calendered fabric width of 137 cm, 140 EPDM and 1%  Moisture Regain
4) Specification to be generated based on test results.


.
FOUT part_no: BLD0121-C) Property to be reported in the certificate of analysis provided with every consignmentBladders should be stored in a dark and dry place, protected from direct sunlight and ozone sources.
FOUT part_no: 624841-C) Manufacturer to provide their test results for these parameters in the COA
1) Sample conditioned for 24 hours at 24°C, 55% relative humidity
2) Pretension 0.1 cN/tex pretension
3) 9.53mm embedment for H-Adhesion
4) (5-0.7*heat shrinkage)/5*lase 5% (5=reference for elongation 5 %, 0.7 = factor for lase adjustment)
5) Mass per unit area calculated on a calendered width of 142 cm, 93.3 epdm and 0.5% MR


.
FOUT part_no: 636751-C) Manufacturer to provide their test results for these parameters in the COA.
1) Sample conditioned for 24 hours at 24°C, 55% relative humidity
2) Pretension 0.5 cN/tex
3) 6.35 mm embedment for H adhesion.
4) Mass per unit area & mass per linear meter calculated on a calendered fabric width of 137 cm, 140 EPDM and 1%  Moisture Regain
5) Specification to be generated based on test results.


.
FOUT part_no: 629821-C) Manufacturer to provide their test results for these parameters in the COA
1) Sample conditioned for 24 hours at 24°C, 55% relative humidity.                                                                                                                                                           2) Pretension 0.1 cN/tex                                                                                                                                                                                                                            3) 9.53 mm embedment for H-adhesion.
4) (5-0.7*heat shrinkage)/5*lase 5% (5=reference for elongation 5 %, 0.7 = factor for lase adjustment)                                                                                                      5) Mass per unit area calculated on 113 epdm at 0.5% MR on a calendered width of 140 cm.                                                                                                                 


PL/SQL procedure successfully completed.
*/	
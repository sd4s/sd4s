--Waar vinden we de SUPPLIER-NAME terug in UNILAB?
--In de XML vind ik volgende structuur terug:

<IC>
    <IC>avBoughtPibs</IC>
    <ICNODE>2000000</ICNODE>
    <IP_VERSION>0001.01</IP_VERSION>
    <DESCRIPTION>PIBS information</DESCRIPTION>
	...
	<II>
      <II>avSupplierCode</II>
      <IINODE>2000000</IINODE>
      <IE_VERSION>0001.07</IE_VERSION>
      <IIVALUE>EVONI</IIVALUE>
      ...
	</II>
	...
</IC>	


select ii.sc, ii.ic, ii.ii, ii.iivalue
from utscii  ii
where ii.ic like 'avBoughtPibs' 
and   ii.ii like 'avSupplierCode' 
and   ii.iivalue like 'W%'  
AND   ii.sc in (select sc.sc from utsc sc where sc.creation_date > to_date('01-05-2022','dd-mm-yyyy' ) )
;

/*
2226000014	avBoughtPibs	avSupplierCode	WEBER&SCHAER
2224001843	avBoughtPibs	avSupplierCode	WEBER&SCHAER
2224001842	avBoughtPibs	avSupplierCode	WEBER&SCHAER
2224000824	avBoughtPibs	avSupplierCode	WEBER&SCHAER
--
2223002266	avBoughtPibs	avSupplierCode	WEBER
--
2223001623	avBoughtPibs	avSupplierCode	WURFB S
2222003013	avBoughtPibs	avSupplierCode	WURFB S
2219002136	avBoughtPibs	avSupplierCode	WURFB S
2218003216	avBoughtPibs	avSupplierCode	WURFB S
2218002220	avBoughtPibs	avSupplierCode	WURFB S
2218002219	avBoughtPibs	avSupplierCode	WURFB S
*/



--query:
descr AVAO_SC_XML;
/*
Name       Null?    Type              
---------- -------- ----------------- 
SC         NOT NULL VARCHAR2(20 CHAR) 
ST                  VARCHAR2(20 CHAR) 
CREATED_BY          VARCHAR2(20 CHAR) 
SS                  VARCHAR2(2 CHAR)  
ICLS                ATAO_ICLS 
--
ATAO_ICLS TABLE OF IC
ATAO_IILS TABLE OF UNILAB.II
Name           Null? Type                
-------------- ----- ------------------- 
II                   VARCHAR2(20 CHAR)   
IINODE               NUMBER(9)           
IE_VERSION           VARCHAR2(20 CHAR)   
IIVALUE              VARCHAR2(2000 CHAR) 
POS_X                NUMBER(4)           
POS_Y                NUMBER(4)           
IS_PROTECTED         CHAR(1 CHAR)        
MANDATORY            CHAR(1 CHAR)        
HIDDEN               CHAR(1 CHAR)        
DSP_TITLE            VARCHAR2(40 CHAR)   
DSP_LEN              NUMBER(4)           
DSP_TP               CHAR(1 CHAR)        
DSP_ROWS             NUMBER(3)           
II_CLASS             VARCHAR2(2 CHAR)    
LOG_HS               CHAR(1 CHAR)        
LOG_HS_DETAILS       CHAR(1 CHAR)        
ALLOW_MODIFY         CHAR(1 CHAR)        
AR                   CHAR(1 CHAR)        
ACTIVE               CHAR(1 CHAR)        
LC                   VARCHAR2(2 CHAR)    
LC_VERSION           VARCHAR2(20 CHAR)   
SS                   VARCHAR2(2 CHAR)    


*/

SELECT * FROM avao_sc_xml WHERE sc = '2226000014';
--Hierin zit hele structuur van SAMPLE om in XML opgenomen te worden...
/*
2226000014	GR_1151_SEL_SEL	RMO	CM	(DATASET)
--
--conclusie: In deze tabel komt SUPPLIER nog wel gewoon als "WEBER&SCHAER" voor !!!!
*/

--*********************************
--aanmaken xml-bestand PROD-OMGEVING:
--*********************************
set serveroutput on
declare
lavs_sc        varchar2(100)  := '2226000014';
lavs_uc        varchar2(100)  := 'XML';
lavs_directory VARCHAR2(1000) := 'EXPORT_DIR';     --EXPORT_DIR	D:\Export\U611
lavs_filename  VARCHAR2(100)  := 'TestPeterPIBS-2226000014.xml';  
lavs_query     VARCHAR2(1000);  
--
l_return number;
begin
  --init
  lavs_query    := 'SELECT * FROM avao_sc_xml WHERE sc = '''|| lavs_sc ||'''' ;
  dbms_output.put_line('query: '||lavs_query);
  --
  l_return := apao_xml.WriteToXML(avs_directory=>lavs_directory
                                 ,avs_filename=>lavs_filename
								 ,avs_query=>lavs_query     
								 );
  dbms_output.put_line('result: '||l_return);
end;
/

--****************************************************************
SELECT * FROM avao_sc_xml WHERE sc = '2226000014';



/*
package: APAO_XML:
--
FUNCTION WriteToXML(avs_directory IN VARCHAR2,
                    avs_filename  IN VARCHAR2,
                    avs_query     IN VARCHAR2)
RETURN NUMBER IS
--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------

DECLARE
avs_sc        varchar2(100)  := '2226000014';
avs_uc        varchar2(100)  := 'XML';
avs_directory VARCHAR2(1000) := 'EXPORT_DIR';   --oorspronkelijk: 'XML_OUT';
avs_filename  VARCHAR2(100);  
avs_query     VARCHAR2(1000);  
					
lcs_function_name CONSTANT VARCHAR2(40) := 'TEST-peter'||'.'||'WriteToXML(4)';
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_sqlerrm      VARCHAR2(255);
lvi_ret_code     NUMBER;
queryCtx         dbms_xmlstore.ctxType;
ctx              dbms_xmlstore.ctxHandle;
lv_xml_clob      CLOB;
lv_clob_len      PLS_INTEGER;
--------------------------------------------------------------------------------
-- Local functions and/or procedures
--------------------------------------------------------------------------------
BEGIN
   ctx := dbms_xmlgen.newContext(avs_query);
   dbms_xmlgen.setRowTag(ctx, 'SC');
   dbms_xmlgen.setRowSetTag(ctx, 'SCLS');
   dbms_xmlgen.setNullHandling(ctx, dbms_xmlgen.EMPTY_TAG);
   lv_xml_clob := dbms_xmlgen.getXML(ctx);
   lv_clob_len := dbms_lob.getlength(lv_xml_clob);
   lvi_ret_code := ClobToFile( avs_directory,
                               avs_filename,
                               lv_xml_clob);
   dbms_xmlgen.closeContext(ctx);
   RETURN lvi_ret_code;
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      UNAPIGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END WriteToXML;
*/



--****************************************************************
--HANDMATIG AANMAKEN VAN PIBS-XML-bestand:
--draaien script als UNILAB op ORACLEPROD !!!!
--****************************************************************

--*********************************
--test-update IC/II
--*********************************
set pages 999
set linesize 300
--
select ii.sc, ii.ic, ii.ii, ii.iivalue
from utscii  ii
where ii.ic like 'avBoughtPibs' 
and   ii.ii like 'avSupplierCode' 
and   ii.iivalue like 'W%'  
and  rownum < 10
;
--update
SET DEFINE OFF;
--
update utscii ii
set iivalue=iivalue||'&PETER' 
where ii.sc      = '112208450'
and   ii.ic like 'avBoughtPibs' 
and   ii.ii like 'avSupplierCode' 
--and   ii.iivalue = 'WURFB'
;
--
set pages 999
set linesize 300
SELECT * FROM avao_sc_xml WHERE sc = '112208450';


--*********************************
--aanmaken xml-bestand TESTOMGEVING:
--*********************************
set serveroutput on
declare
lavs_sc        varchar2(100)  := '112208450';
lavs_uc        varchar2(100)  := 'XML';
lavs_directory VARCHAR2(1000) := 'EXPORT_DIR';     --EXPORT_DIR	D:\Export\U611
lavs_filename  VARCHAR2(100)  := 'TestPeterPIBS-112208450.xml';  
lavs_query     VARCHAR2(1000);  
--
l_return number;
begin
  --init
  lavs_query    := 'SELECT * FROM avao_sc_xml WHERE sc = '''|| lavs_sc ||'''' ;
  dbms_output.put_line('query: '||lavs_query);
  --
  l_return := apao_xml.WriteToXML(avs_directory=>lavs_directory
                                 ,avs_filename=>lavs_filename
								 ,avs_query=>lavs_query     
								 );
  dbms_output.put_line('result: '||l_return);
end;
/

--****************************************************************
--SELECT * FROM avao_sc_xml WHERE sc = '2226000014';



--OUTPUT-XML:
/*
     <II>
      <II>avSupplierCode</II>
      <IINODE>2000000</IINODE>
      <IE_VERSION>0001.07</IE_VERSION>
      <IIVALUE>WEBER&amp;SCHAER</IIVALUE>       ==> fout zit hem dus al in UNILAB !!!!!!!!!!!
      <POS_X>155</POS_X>
      <POS_Y>69</POS_Y>
      <IS_PROTECTED>0</IS_PROTECTED>
      <MANDATORY>1</MANDATORY>
      <HIDDEN>0</HIDDEN>
      <DSP_TITLE>Supplier Code</DSP_TITLE>
      <DSP_LEN>40</DSP_LEN>
      <DSP_TP>C</DSP_TP>
      <DSP_ROWS>3</DSP_ROWS>
      <II_CLASS/>
      <LOG_HS>1</LOG_HS>
      <LOG_HS_DETAILS>1</LOG_HS_DETAILS>
      <ALLOW_MODIFY>1</ALLOW_MODIFY>
      <AR>W</AR>
      <ACTIVE>1</ACTIVE>
      <LC/>
      <LC_VERSION/>
      <SS/>
     </II>
*/	 

--****************************************************************
--****************************************************************


--ONDERZOEK: APAO_XML.CLOBTOFILE
/*
FUNCTION ClobToFile ( avs_directory IN VARCHAR2,
                      avs_filename  IN VARCHAR2,
                      avc_clob      IN CLOB )
RETURN NUMBER IS
--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT VARCHAR2(40) := ics_package_name||'.'||'ClobToFile';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_sqlerrm      VARCHAR2(255);
lvi_ret_code     NUMBER;
c_amount         CONSTANT BINARY_INTEGER := 32767;
l_buffer         VARCHAR2(32767);
l_chr10          PLS_INTEGER;
l_clobLen        PLS_INTEGER;
l_fHandler       UTL_FILE.FILE_TYPE;
l_pos            PLS_INTEGER    := 1;

--------------------------------------------------------------------------------
-- Local functions and/or procedures
--------------------------------------------------------------------------------
BEGIN

   l_clobLen  := DBMS_LOB.GETLENGTH(avc_clob);
   l_fHandler := UTL_FILE.FOPEN(avs_directory, avs_filename,'W',c_amount);

   WHILE l_pos < l_clobLen 
   LOOP
      l_buffer := DBMS_LOB.SUBSTR(avc_clob, c_amount, l_pos);
      EXIT WHEN l_buffer IS NULL;
      l_chr10  := INSTR(l_buffer,CHR(10),-1);
      IF l_chr10 != 0 THEN
         l_buffer := SUBSTR(l_buffer,1,l_chr10-1);
      END IF;
      UTL_FILE.PUT_LINE(l_fHandler, l_buffer,TRUE);
      l_pos := l_pos + LEAST(LENGTH(l_buffer)+1,c_amount);
   END LOOP;

   UTL_FILE.FCLOSE(l_fHandler);
   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
   IF UTL_FILE.IS_OPEN(l_fHandler) THEN
      UTL_FILE.FCLOSE(l_fHandler);
   END IF;
   IF SQLCODE != 1 THEN
      UNAPIGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;

END ClobToFile;
*/

--ONDERZOEK INTERNET:
--The & character is itself an escape character in XML so the solution is to concatenate it and a Unicode decimal 
--equivalent for & thus ensuring that there are no XML parsing errors. That is, replace the character & with &#038;.

--ORIGINELE VIEW DD. 28-06-2022:
CREATE OR REPLACE FORCE VIEW "UNILAB"."AVAO_SC_XML" ("SC", "ST", "CREATED_BY", "SS", "ICLS") AS 
  SELECT m.sc, 
          m.st,
          m.created_by,
          m.ss,
          CAST (MULTISET (SELECT ic, icnode, ip_version, description, winsize_x, winsize_y,
                                 is_protected, hidden, manually_added, next_ii, 
                                 ic_class, log_hs, log_hs_details, allow_modify, ar, active, lc,
                                 lc_version, ss,
                                 CAST (MULTISET (SELECT ii, iinode, ie_version, iivalue, pos_x, pos_y,
                                                        is_protected, mandatory, hidden, 
                                                        dsp_title, dsp_len, dsp_tp, dsp_rows, 
                                                        ii_class, log_hs, log_hs_details, allow_modify, ar, active, lc,
                                                        lc_version, ss
                                                   FROM uvscii
                                                  WHERE sc(+) = a.sc
                                                    AND ic = a.ic AND icnode = a.icnode) AS atao_iils) iils
                            FROM uvscic a
                           WHERE a.sc(+) = m.sc) AS atao_icls) icls 
     FROM utsc m 
 ;


--MET REPLACE-AMPERSAND-CONSTRUCTIE VOOR XML !!!  & = &#038; ==> replace(iivalue,'&','&#038;')
--
--Met onderstaande versie komt de supplier name = 'WURFB&PETER' corretc in de XML te staan !!!
--<II>avSupplierCode</II>
--<IINODE>2000000</IINODE>
--<IE_VERSION>0001.04</IE_VERSION>
--<IIVALUE>WURFB&#038;PETER</IIVALUE>
--LET OP: Hoe krijgen we dit voor elkaar ????
/*	  
So, I need to change my document to be valid XML. If I am building the XML myself, I have two approaches. 
CDATA I can wrap the offending data in a CDATA block: 
<COLA><![CDATA[lewis&me]]></COLA>
--'<![CDATA['||iivalue||']]>'    leidt tot XML:  <IIVALUE><![CDATA[WURFB&PETER]]></IIVALUE>
--
--This code works. I don’t like to use CDATA when I can avoid it so I would use the converfunction instead. DBMS_XMLGEN.CONVERT
dbms_xmlgen.convert('lewis&me')
*/
CREATE OR REPLACE FORCE VIEW "UNILAB"."AVAO_SC_XML" ("SC", "ST", "CREATED_BY", "SS", "ICLS") AS 
  SELECT m.sc, 
          m.st,
          m.created_by,
          m.ss,
          CAST (MULTISET (SELECT ic, icnode, ip_version, description, winsize_x, winsize_y,
                                 is_protected, hidden, manually_added, next_ii, 
                                 ic_class, log_hs, log_hs_details, allow_modify, ar, active, lc,
                                 lc_version, ss,
                                 CAST (MULTISET (SELECT ii, iinode, ie_version, dbms_xmlgen.convert(iivalue,1), pos_x, pos_y,
                                                        is_protected, mandatory, hidden, 
                                                        dsp_title, dsp_len, dsp_tp, dsp_rows, 
                                                        ii_class, log_hs, log_hs_details, allow_modify, ar, active, lc,
                                                        lc_version, ss
                                                   FROM uvscii
                                                  WHERE sc(+) = a.sc
                                                    AND ic = a.ic AND icnode = a.icnode
											    ) AS atao_iils
									   ) iils
                            FROM uvscic a
                           WHERE a.sc(+) = m.sc
						  ) AS atao_icls
				) icls 
     FROM utsc m 
 ;
 
 
 
--*********************************
--aanmaken xml-bestand.
--*********************************
set serveroutput on
declare
lavs_sc        varchar2(100)  := '112208450';
lavs_uc        varchar2(100)  := 'XML';
lavs_directory VARCHAR2(1000) := 'EXPORT_DIR';     --EXPORT_DIR	D:\Export\U611
lavs_filename  VARCHAR2(100)  := 'TestPeterPIBS-112208450.xml';  
lavs_query     VARCHAR2(1000);  
--
l_return number;
begin
  --init
  lavs_query    := 'SELECT * FROM avao_sc_xml WHERE sc = '''|| lavs_sc ||'''' ;
  dbms_output.put_line('query: '||lavs_query);
  --
  l_return := apao_xml.WriteToXML(avs_directory=>lavs_directory
                                 ,avs_filename=>lavs_filename
								 ,avs_query=>lavs_query     
								 );
  dbms_output.put_line('result: '||l_return);
end;
/


--extra testen:
DBMS_XMLGEN.GETXMLTYPE (sqlQuery     IN VARCHAR2,  dtdOrSchema  IN number := NONE)  RETURN sys.XMLType;

select DBMS_XMLGEN.GETXML(sqlQuery=>'SELECT * FROM avao_sc_xml WHERE sc = '||''''||'2226000014'||'''', dtdOrSchema=>null) from dual;

/*
 <II>
   <II>avSupplierCode</II>
   <IINODE>2000000</IINODE>
   <IE_VERSION>0001.07</IE_VERSION>
   <IIVALUE>WEBER&amp;SCHAER</IIVALUE>
   <POS_X>155</POS_X>
   <POS_Y>69</POS_Y>
   <IS_PROTECTED>0</IS_PROTECTED>
   <MANDATORY>1</MANDATORY>
   <HIDDEN>0</HIDDEN>
   <DSP_TITLE>Supplier Code</DSP_TITLE>
   <DSP_LEN>40</DSP_LEN>
   <DSP_TP>C</DSP_TP>
   <DSP_ROWS>3</DSP_ROWS>
   <LOG_HS>1</LOG_HS>
   <LOG_HS_DETAILS>1</LOG_HS_DETAILS>
   <ALLOW_MODIFY>1</ALLOW_MODIFY>
   <AR>W</AR>
   <ACTIVE>1</ACTIVE>
 </II>
*/

select dbMs_xmlgen.CONVERT( DBMS_XMLGEN.GETXML(sqlQuery=>'SELECT * FROM avao_sc_xml WHERE sc = '||''''||'2226000014'||'''', dtdOrSchema=>null) , 1) from dual;
/*
 <II>
  <II>avSupplierCode</II>
  <IINODE>2000000</IINODE>
  <IE_VERSION>0001.07</IE_VERSION>
  <IIVALUE>WEBER&SCHAER</IIVALUE>
  <POS_X>155</POS_X>
  <POS_Y>69</POS_Y>
  <IS_PROTECTED>0</IS_PROTECTED>
  <MANDATORY>1</MANDATORY>
  <HIDDEN>0</HIDDEN>
  <DSP_TITLE>Supplier Code</DSP_TITLE>
  <DSP_LEN>40</DSP_LEN>
  <DSP_TP>C</DSP_TP>
  <DSP_ROWS>3</DSP_ROWS>
  <LOG_HS>1</LOG_HS>
  <LOG_HS_DETAILS>1</LOG_HS_DETAILS>
  <ALLOW_MODIFY>1</ALLOW_MODIFY>
  <AR>W</AR>
  <ACTIVE>1</ACTIVE>
 </II>
*/

 

 
 

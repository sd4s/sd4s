select * from avao_sc_xml where sc='2226000014';
--
--In deze tabel zit alle data die uiteindelijk in de XML moet worden opgenomen.
--



--UITTESTEN van XML-AANMAKEN op PRODUTIEOMGEVING
--DRAAIEN ALS USER UNILAB OP ORACLEPROD !!!!
select * from dba_directories;
--
set serveroutput on
--
declare
lavs_sc        varchar2(100)  := '2226000014';
lavs_uc        varchar2(100)  := 'XML';
lavs_directory VARCHAR2(1000) := 'EXPORT_DIR';      --d:\export_dir\
lavs_filename  VARCHAR2(100)  := 'TestPeterPIBS';  
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






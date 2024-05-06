CREATE OR REPLACE PACKAGE APAO_WATSON AS
--------------------------------------------------------------------------------
--  PROJECT : Vredestein Enschede
-------------------------------------------------------------------------------
--  PACKAGE : APAO_WATSON
-- ABSTRACT :
--   WRITER : Jacco van den Broek
--     DATE : 13/04/2015
--   TARGET : Oracle 11.2.0 / Unilab 6.4 sp1
--  VERSION : av1.0
--------------------------------------------------------------------------------
--  REMARKS :
--------------------------------------------------------------------------------
--  CHANGES :
--
--  When      | Who       | What
--============|===========|=====================================================
-- 13/04/2015 | JB        | Created
--------------------------------------------------------------------------------
-- 09-03-2021 | PS        | http omgezet naar https
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- functions- and/or procedures-declarations
--------------------------------------------------------------------------------
--
procedure set_connection;
--
procedure show_files
  (p_username in varchar2 default null
  ,p_password in varchar2 default null
  ,p_method in varchar2 default null
  ,p_errors in boolean default false);
--
function get_unique_link
   return varchar2;
--
--START-WATSON-IMPORT-procedure, aangeroepen vanuit JOB:
--'begin apao_watson.import_files(p_test => false); end;' 
procedure import_files
  (p_username in varchar2 default null
  ,p_password in varchar2 default null
  ,p_method in varchar2 default null
  ,p_test in boolean default true
  ,p_errors in boolean default false
  ,p_attachment in varchar2 default null);
--
procedure update_file
  (p_username in varchar2 default null
  ,p_password in varchar2 default null
  ,p_link in varchar2);
--
procedure delete_files;
--
procedure delete_method
  (p_mt in varchar2
  ,p_version in varchar2);
--
--*********************************************************************
-- test-procedure om HTTP/HTTPS-connectie naar WATSON-server te testen.
--*********************************************************************
PROCEDURE api_test_show_html_from_url (
  p_url              IN  VARCHAR2,
  p_username         IN  VARCHAR2 DEFAULT NULL,
  p_password         IN  VARCHAR2 DEFAULT NULL,
  p_wallet_path      IN  VARCHAR2 DEFAULT NULL,
  p_wallet_password  IN  VARCHAR2 DEFAULT NULL);
--
--of aanroepen met kant-en-klare settings + URL:
--
PROCEDURE api_aanroep_show_html_from_url ;
--*********************************************************************
--
END APAO_WATSON;
/
CREATE OR REPLACE PACKAGE BODY        APAO_WATSON AS
--------------------------------------------------------------------------------
--  PROJECT : Vredestein Enschede
-------------------------------------------------------------------------------
--  PACKAGE : APAO_WATSON
-- ABSTRACT :
--   WRITER : Jacco van den Broek
--     DATE : 13/04/2015
--   TARGET : Oracle 11.2.0 / Unilab 6.4 sp1
--  VERSION : av1.0
--------------------------------------------------------------------------------
--  REMARKS :
--------------------------------------------------------------------------------
--  CHANGES :
--
--  When      | Who       | What
--============|===========|=====================================================
-- 13/04/2015 | JB        | Created
--------------------------------------------------------------------------------
-- 09-03-2021 | PS        | http omgezet naar https
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
ics_package_name                 constant varchar2(20) := 'APAO_WATSON';
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- functions- and/or procedures-declarations
--------------------------------------------------------------------------------
--
v_site utl_http.html_pieces;
--
type t_array is table of utsystem.setting_value%type index by pls_integer;
--
--indicator waarmee je de synchronisatie aan/uit kunt zetten
v_sync_actief     utsystem.setting_value%type;
--watson-http-parameters
v_server          utsystem.setting_value%type;
v_libraries       t_array;
v_username        utsystem.setting_value%type;
v_password        utsystem.setting_value%type;
--tbv https-call
v_wallet_path     utsystem.setting_value%type;
v_wallet_password utsystem.setting_value%type;
--
type r_mth is record (mth utmt%rowtype
                     ,mth_name varchar2(32767)
                     ,mth_new_version utmt.version%type);
type t_mth is table of r_mth index by utmt.mt%type;
--
type r_doc is record (doc_unid varchar2(32767)
                     ,doc_attachments varchar2(32767)
                     ,doc_files t_array
                     ,doc_reference varchar2(32767)
                     ,doc_subject varchar2(32767)
                     ,doc_methods t_array
                     ,doc_version varchar2(32767)
                     ,doc_link varchar2(32767)
                     ,doc_filename varchar2(32767)
                     ,doc_watson_version varchar2(32767)
                     ,doc_error boolean
                     ,doc_response varchar2(32767)
--                     ,doc_record utmt%rowtype
--                     ,doc_new_version utmt.version%type
                     ,doc_mth t_mth
                     ,doc_data blob);
type t_doc is table of r_doc index by pls_integer;
v_doc t_doc;
--
function varchar2_to_array
  (p_string in varchar2
  ,p_separator in varchar2 default ','
  ,p_trailing_separators in boolean default true)
   return t_array
is
  l_array t_array;
  l_start pls_integer;
  l_end pls_integer;
  l_string varchar2(32767);
  l_index pls_integer := 0;
  l_length pls_integer;
begin
  if p_string is not null
  then
    l_string := p_string;
    l_length := length(p_separator);
    --
    if l_length > 0
    then
      if substr(l_string, -l_length, l_length) <> p_separator
      or not p_trailing_separators
      then
        l_string := l_string||p_separator;
      end if;
      --
      if substr(l_string, 1, l_length) <> p_separator
      or not p_trailing_separators
      then
        l_string := p_separator||l_string;
      end if;
      --
      for i in 1..(length(l_string) - nvl(length(replace(l_string, p_separator)), 0)) / l_length - 1
      loop
        l_start := instr(l_string, p_separator, 1, i);
        l_end := instr(l_string, p_separator, l_start + l_length);
        l_index := l_index + 1;
        l_array(l_index) := substr(l_string, l_start + l_length, (l_end - l_start) - l_length);
      end loop;
    else
      for i in 1..length(l_string)
      loop
        l_index := l_index + 1;
        l_array(l_index) := substr(l_string, i, 1);
      end loop;
    end if;
  end if;
  --
  return l_array;
end;
--
function encode
  (p_value in varchar2)
   return varchar2
is
  l_value varchar2(32767) := p_value;
begin
  if l_value is not null
  then
    l_value := trim(replace(replace(replace(replace(l_value, chr(10)), chr(11)), chr(13)), ' '));
    l_value := replace(utl_raw.cast_to_varchar2(utl_encode.base64_decode(utl_raw.cast_to_raw(l_value))), chr(0));
  end if;
  --
  return l_value;
end;
--
function xml_unescape
  (p_value in varchar2)
   return varchar2
is
begin
  return replace(replace(replace(replace(replace(replace(p_value, '&amp;', '&'), '&quot;', '"'), '&apos;', ''''), '&lt;', '<'), '&gt;', '>'), '&#x2F;', '/');
end;
--
procedure initialize
  (p_username in varchar2
  ,p_password in varchar2)
is
begin
  for r_stm in (select *
                from   utsystem stm
                where  stm.setting_name like 'WATSON%')
  loop
    case r_stm.setting_name
      when 'WATSON_SYNC_ACTIEF'
      then v_sync_actief := r_stm.setting_value;
      when 'WATSON_SERVER'
      then v_server := r_stm.setting_value;
      when 'WATSON_LIBRARIES'
      then v_libraries := varchar2_to_array(p_string => r_stm.setting_value);
      when 'WATSON_USERNAME'
      then v_username := r_stm.setting_value;
      when 'WATSON_PASSWORD'
      then v_password := r_stm.setting_value;
      when 'WATSON_WALLET_PATH'
      then v_wallet_path := r_stm.setting_value;
      when 'WATSON_WALLET_PW'
      then v_wallet_password := r_stm.setting_value;
      else null;
    end case;
  end loop;
  --
  v_username := nvl(p_username, v_username);
  v_password := nvl(p_password, v_password);
end;
--
procedure set_connection
is
 l_ret_code           INTEGER;
 l_client_id          VARCHAR2(20);
 l_us                 VARCHAR2(20);
 l_applic             VARCHAR2(8);
 l_numeric_characters VARCHAR2(2);
 l_date_format        VARCHAR2(255);
 l_up                 NUMBER;
 l_user_profile       VARCHAR2(40);
 l_language           VARCHAR2(20);
 l_tk                 VARCHAR2(20);
BEGIN
 l_client_id := 'THIS'; --&ComputerName;
 l_us := 'UNILAB'; --&Username;
 l_applic := 'UNILAB'; --&Application;
 l_numeric_characters := 'DB';
 l_date_format := 'DDfx/fxMM/RR HH24fx:fxMI:SS';
  --
 l_ret_code := unapigen.setconnection(
  l_client_id,
  l_us,
  l_applic,
  l_numeric_characters,
  l_date_format,
  l_up,
  l_user_profile,
  l_language,
  l_tk
 );
end;
--
function escape_file
  (p_name in varchar2)
   return varchar2
is
begin
  return replace(replace(replace(replace(utl_url.escape(p_name), '(', '%28'), ')', '%29'), '''', '%27'), '_', '%5f');
end;
--
function download_file
  (p_library in varchar2
  ,p_unid in varchar2
  ,p_filename in varchar2)
   return blob
is
  l_blob blob;
  l_raw raw(32767);
  l_length pls_integer;
  l_url varchar2(32767);
begin
  l_url := 'http://'||v_username||':'||v_password||'@'||v_server||'/docova/'||p_library||'/0/'||p_unid||'/$file/'||escape_file(p_filename)||'?OpenElement';

  dbms_output.put_line(p_filename);
  dbms_output.put_line(l_url);
  --
  v_site := usr_http.request_pieces(l_url);
  --
  dbms_lob.createtemporary(l_blob, true);
  dbms_lob.open(l_blob, dbms_lob.lob_readwrite);
  --
  for i in 1..v_site.count
  loop
    l_raw := utl_raw.cast_to_raw(v_site(i));
    l_length := utl_raw.length(l_raw);
    dbms_lob.writeappend(l_blob, l_length, l_raw);
  end loop;
  --
  dbms_lob.close(l_blob);
  --
  return l_blob;
end;
--
function get_unique_link
   return varchar2
is
  l_link varchar2(20);
  l_check pls_integer;
begin
  loop
    begin
      l_link := substr(to_char(systimestamp, 'yymmddhh24missff'), 1, 14)||lpad(trunc(dbms_random.value(0, 99)), 2, 0)||'#BLB';
      --
      select 1
      into   l_check
      from   utblob blb
      where  blb.id = l_link;
    exception
      when no_data_found
      then
        return l_link;
    end;
  end loop;
  --
  return l_link;
end;

--
procedure set_list
  (p_library in varchar2
  ,p_link in varchar2 default null
  ,p_method in varchar2 default null
  ,p_errors in boolean default false
  ,p_attachment in varchar2 default null)
is
  l_clob clob;
  l_url varchar2(32767);
  l_idx pls_integer := 0;
  l_action varchar2(5) := 'LIST';
begin
  if p_errors
  then
    l_action := 'ERROR';
  end if;
  --
  l_url := utl_url.escape('http://'||v_username||':'||v_password||'@'||v_server||'/docova/'||p_library||'/UnilabDocumentAgent?OpenAgent&Action='||l_action||'&Link='||p_link);
  dbms_output.put_line(l_url);
  --
  v_site := usr_http.request_pieces(l_url);
  --
--  dbms_output.put_line('set_list loop '||v_site.count);
  for i in 1..v_site.count
  loop
--    dbms_output.put_line('set_list loop '||i);
    l_clob := l_clob||v_site(i);
--    dbms_output.put_line(i||' - '||v_site(i));
  end loop;
  --
  v_doc.delete;
  --
  for r_doc in (select extractvalue(xml_document, '/Document/Attachments') doc_attachments
                ,      extractvalue(xml_document, '/Document/Unid') doc_unid
                ,      extractvalue(xml_document, '/Document/Reference') doc_reference
                ,      extractvalue(xml_document, '/Document/SOPcode') doc_sop_code
                ,      extractvalue(xml_document, '/Document/Subject') doc_subject
                ,      extractvalue(xml_document, '/Document/Method') doc_method
                ,      extractvalue(xml_document, '/Document/Version') doc_version
                ,      extractvalue(xml_document, '/Document/WatsonVersion') doc_watson_version
                ,      extractvalue(xml_document, '/Document/Link') doc_link
                from  (select column_value xml_document
                       from   table(xmlsequence(xmltype(l_clob).extract('/Documents/Document')))))
  loop
    if upper(nvl(p_method, r_doc.doc_sop_code)) = upper(r_doc.doc_sop_code)
    then
      dbms_output.put_line('Start doc');
      --
      if p_link is null
      or r_doc.doc_link = p_link
      then
        l_idx := l_idx + 1;
        --
        v_doc(l_idx).doc_error := false;
        --v_doc(l_idx).doc_method := r_doc.doc_method;
        v_doc(l_idx).doc_methods := varchar2_to_array
                                      (p_string => r_doc.doc_method
                                      ,p_separator => ','
                                      ,p_trailing_separators => false);
        v_doc(l_idx).doc_unid := r_doc.doc_unid;
        v_doc(l_idx).doc_reference := r_doc.doc_reference;
        v_doc(l_idx).doc_version := r_doc.doc_version;
        v_doc(l_idx).doc_watson_version := r_doc.doc_watson_version;
        v_doc(l_idx).doc_subject := r_doc.doc_subject;
        --
      dbms_output.put_line('Methods count '||v_doc(l_idx).doc_methods.count);
        if v_doc(l_idx).doc_methods.count = 0
        then
          v_doc(l_idx).doc_error := true;
          v_doc(l_idx).doc_response := 'Method name not specified';
        else
          if p_link is null
          then
            for i in 1..v_doc(l_idx).doc_methods.count
            loop
              --
              for r_rec in (select   *
                            from     utmt mth
                            where    mth.mt like upper(trim(replace(v_doc(l_idx).doc_methods(i), '?', '_')))
                            and      mth.version = (select max(mthmax.version)
                                                    from   utmt mthmax
                                                    where  mthmax.mt = mth.mt)
                            order by mth.version desc)
              loop
                v_doc(l_idx).doc_mth(r_rec.mt).mth_name := v_doc(l_idx).doc_methods(i);
                v_doc(l_idx).doc_mth(r_rec.mt).mth := r_rec;
              end loop;
            end loop;
            --
            if v_doc(l_idx).doc_mth.count = 0
            then
              v_doc(l_idx).doc_error := true;
              v_doc(l_idx).doc_response := 'Method not found';
  --          else
  --            v_doc(l_idx).doc_link := v_doc(l_idx).doc_mth(v_doc(l_idx).doc_mth.first).mth.mt||'-'||v_doc(l_idx).doc_watson_version||'#BLB';
  --            --
  --            if length(v_doc(l_idx).doc_link) > 20
  --            then
  --              v_doc(l_idx).doc_link := substr(v_doc(l_idx).doc_link, -20, 20);
  --            end if;
            end if;
          else
            v_doc(l_idx).doc_link := upper(p_link);
          end if;
          --
          if not v_doc(l_idx).doc_error
          then
            v_doc(l_idx).doc_attachments :=  xml_unescape(utl_url.unescape(r_doc.doc_attachments));

            --

            --v_doc(l_idx).doc_link := r_doc.doc_link;
            --
            v_doc(l_idx).doc_files := varchar2_to_array
                                          (p_string => v_doc(l_idx).doc_attachments
                                          ,p_separator => '|'
                                          ,p_trailing_separators => false);
            --
            if v_doc(l_idx).doc_files.count = 0
            then
              v_doc(l_idx).doc_error := true;
              v_doc(l_idx).doc_response := 'No attachment(s) found';
              dbms_output.put_line('No file(s) found');
            elsif v_doc(l_idx).doc_files.count = 1
            then
              dbms_output.put_line('One file found');
              v_doc(l_idx).doc_filename := v_doc(l_idx).doc_files(1);
            else
              dbms_output.put_line('Multiple files found');
              for i in 1..v_doc(l_idx).doc_files.count
              loop
                dbms_output.put_line('>>>> '||v_doc(l_idx).doc_reference||' >>> '||v_doc(l_idx).doc_files(i));
                --
                if lower(v_doc(l_idx).doc_files(i)) like '%'||lower(v_doc(l_idx).doc_reference)||'%.docx'
                or lower(v_doc(l_idx).doc_files(i)) = lower(p_attachment)
                then
                  dbms_output.put_line('- found: '||v_doc(l_idx).doc_files(i));
                  v_doc(l_idx).doc_filename := v_doc(l_idx).doc_files(i);
                end if;
              end loop;
              --
              if v_doc(l_idx).doc_filename is null
              then
                v_doc(l_idx).doc_error := true;
                v_doc(l_idx).doc_response := 'Unable to select the correct attachment';
              end if;
            end if;
            --
            if not v_doc(l_idx).doc_error
            then
              v_doc(l_idx).doc_data := download_file
                                         (p_library => p_library
                                         ,p_unid => v_doc(l_idx).doc_unid
                                         ,p_filename => v_doc(l_idx).doc_filename);
              --
              if v_doc(l_idx).doc_data is null
              then
                v_doc(l_idx).doc_error := true;
                v_doc(l_idx).doc_response := 'Unable to download attachment';
              else
                v_doc(l_idx).doc_response := 'File successful downloaded';
              end if;
            end if;
          end if;
        end if;
      end if;
      dbms_output.put_line('End doc');
    end if;
  end loop;
end;
--
function update_document
  (p_library in varchar2
  ,p_unid in varchar2
  ,p_version in varchar2
  ,p_response in varchar2
  ,p_link in varchar2
  ,p_error in boolean)
   return clob
is
  l_clob clob;
  l_param varchar2(32767);
  l_url varchar2(32767);
begin
  l_param := 'Action=UPDATE&Unid='||p_unid||'&Version='||p_version||'&Response='||utl_url.escape(p_response)||'&Link='||utl_url.escape(p_link);
  --
  if p_error
  then
    l_param := l_param||'&Error=Y';
  end if;
  --
  l_url := 'http://'||v_username||':'||v_password||'@'||v_server||'/docova/'||p_library||'/UnilabDocumentAgent?OpenAgent&'||l_param;
  dbms_output.put_line(l_url);
  --
  v_site := usr_http.request_pieces('http://'||v_username||':'||v_password||'@'||v_server||'/docova/'||p_library||'/UnilabDocumentAgent?OpenAgent&'||l_param);
  --
  for i in 1..v_site.count
  loop
    l_clob := l_clob||v_site(i);
    dbms_output.put_line(v_site(i));
  end loop;
  --
  return l_clob;
end;
--
procedure show_files
  (p_username in varchar2 default null
  ,p_password in varchar2 default null
  ,p_method in varchar2 default null
  ,p_errors in boolean default false)
is
  l_list clob;
  l_lib pls_integer;
begin
  initialize
    (p_username => p_username
    ,p_password => p_password);
  --
  dbms_output.put_line('Set connection');
  --
  set_connection;
  --
  l_lib := v_libraries.first;
  while l_lib is not null
  loop
    begin
      dbms_output.put_line('Library: '||v_libraries(l_lib));
      --
      dbms_output.put_line('Set list lib '||l_lib);
      --
      set_list
        (p_library => v_libraries(l_lib)
        ,p_method => p_method
        ,p_errors => p_errors);
      --
      for i in 1..v_doc.count
      loop
        dbms_output.put_line('==============================================');
        dbms_output.put_line('Unid       : '||v_doc(i).doc_unid);
        dbms_output.put_line('Subject    : '||v_doc(i).doc_subject);
        dbms_output.put_line('Attachments: '||encode(v_doc(i).doc_attachments));
      end loop;
    exception
      when others
      then
        dbms_output.put_line(sqlerrm);
    end;
    --
    l_lib := v_libraries.next(l_lib);
  end loop;
end;
--
procedure import_files
  (p_username in varchar2 default null
  ,p_password in varchar2 default null
  ,p_method in varchar2 default null
  ,p_test in boolean default true
  ,p_errors in boolean default false
  ,p_attachment in varchar2 default null)
is
  l_update clob;
  l_error pls_integer;
  l_lib pls_integer;
  l_version varchar2(32767);
  l_result varchar2(32767);
  l_commit boolean;
  l_count pls_integer;
  l_mth utmt.mt%type;
  l_continue boolean;
  type t_versions is table of utmt.mt%type index by utmt.version%type;
  l_versions t_versions;
begin
  dbms_output.enable(1000000);
  --if cxapp.get_host_name() <> 'ORACLEPROD'
  --then raise_application_error(-20000, 'Only running on production!!!');
  --end if;
  if p_test
  then dbms_output.put_line('========== TEST MODE!!! ==========');
  end if;
  --
  --haal alle watson-variabelen vanuit UTSYSTEM op
  initialize (p_username => p_username
             ,p_password => p_password);
  --
  if NOT nvl(UPPER(v_sync_actief),'NEE') = 'JA' 
  then raise_application_error(-20000, 'Proces is stopped. Only running on production!!!');
  end if;
  --zet connectie op, en controleer autorisatie etc.
  set_connection;
  --
  --dd. 08-03-2021 TOEGEVOEGD PS TBV WATSON-CERTIFICATEN.
  --Bekend maken van de WALLET binnen SESSION
  UTL_HTTP.set_wallet('file:' || v_wallet_path, v_wallet_password);
  --
  l_lib := v_libraries.first;
  --LOOP door de verschillende LIBRARIES om te zien of er nog gerelateerde documenten klaar staan.
  --Er zijn er 3x: ZZZ_Development.nsf, GlobalPVRnD.nsf, GlobalTesting.nsf
  --Voor een test alleen de ZZZ_Development.nsf gebruiken !!!!
  while l_lib is not null
  loop
    if p_test
    then dbms_output.put_line('In loop Library: '||v_libraries(l_lib));
    end if;
    --
    set_list
      (p_library => v_libraries(l_lib)
      ,p_method => p_method
      ,p_errors => p_errors
      ,p_attachment => p_attachment);
    --
	if p_test
    then dbms_output.put_line('Aantal doc in LIST: '||v_doc.count );
    end if;
	--
    for i in 1..v_doc.count
    loop
      begin
        l_continue := true;
--        if p_method is null
--        then
--          l_continue := true;
--        else
--          l_continue := false;
--          --
--          l_mth := v_doc(i).doc_mth.first;
--          --
--          while l_mth is not null
--          loop
--            if p_method = v_doc(i).doc_mth(l_mth).mth.mt
--            then
--              l_continue := true;
--              exit;
--            end if;
--            --
--            l_mth := v_doc(i).doc_mth.next(l_mth);
--          end loop;
--        end if;
        --
        if l_continue
        then
          dbms_output.put_line('==============================================');
          dbms_output.put_line('Unid: '||v_doc(i).doc_unid);
          dbms_output.put_line('Attachments: '||encode(v_doc(i).doc_attachments));
          --
          l_error := unapigen.begintransaction;
          l_commit := false;
          l_version := null;
          l_count := 0;
          --
          if not v_doc(i).doc_error
          then
            if not p_test
            then
              v_doc(i).doc_link := get_unique_link;
              --
              l_error := unapifi.saveblob
                           (a_id => v_doc(i).doc_link
                           ,a_description => null
                           ,a_object_link => null
                           ,a_key_1 => null
                           ,a_key_2 => null
                           ,a_key_3 => null
                           ,a_key_4 => null
                           ,a_key_5 => null
                           ,a_url => v_doc(i).doc_filename
                           ,a_data => v_doc(i).doc_data
                           ,a_modify_reason => null);
              --
              dbms_output.put_line('Save blob: '||l_error);
            end if;
            --
            l_mth := v_doc(i).doc_mth.first;
            --
            while l_mth is not null
            loop
              if nvl(p_method, v_doc(i).doc_mth(l_mth).mth.mt) = v_doc(i).doc_mth(l_mth).mth.mt
              then
                begin
                  dbms_output.put_line('Select method '||v_doc(i).doc_mth(l_mth).mth.mt);
                  --
                  if not p_test
                  then
                    v_doc(i).doc_mth(l_mth).mth_new_version := unversion.sqlgetnextmajorversion
                                                                 (a_version => v_doc(i).doc_mth(l_mth).mth.version);
                    --
                    l_error := unapimt.copymethod
                                 (a_mt => v_doc(i).doc_mth(l_mth).mth.mt
                                 ,a_version => v_doc(i).doc_mth(l_mth).mth.version
                                 ,a_cp_mt => v_doc(i).doc_mth(l_mth).mth.mt
                                 ,a_cp_version => v_doc(i).doc_mth(l_mth).mth_new_version
                                 ,a_modify_reason => 'Copy');
                    --
                    dbms_output.put_line('Copy method: '||l_error);
                    --
                    if l_error > 0
                    then
                      raise_application_error(-20000, 'Error copying method');
                    end if;
                    --
                    select *
                    into   v_doc(i).doc_mth(l_mth).mth
                    from   utmt mth
                    where  mth.mt = v_doc(i).doc_mth(l_mth).mth.mt
                    and    mth.version = v_doc(i).doc_mth(l_mth).mth_new_version;
                  end if;
                  --
                  if not p_test
                  then
                    l_error := unapimt.savemethod
                                 (a_mt => v_doc(i).doc_mth(l_mth).mth.mt
                                 ,a_version => v_doc(i).doc_mth(l_mth).mth.version
                                 ,a_version_is_current => 1 --v_doc(i).doc_mth(l_mth).mth.version_is_current
                                 ,a_effective_from => v_doc(i).doc_mth(l_mth).mth.effective_from
                                 ,a_effective_till => v_doc(i).doc_mth(l_mth).mth.effective_till
                                 ,a_description => v_doc(i).doc_mth(l_mth).mth.description
                                 ,a_description2 => v_doc(i).doc_mth(l_mth).mth.description2
                                 ,a_unit => v_doc(i).doc_mth(l_mth).mth.unit
                                 ,a_est_cost => v_doc(i).doc_mth(l_mth).mth.est_cost
                                 ,a_est_time => v_doc(i).doc_mth(l_mth).mth.est_time
                                 ,a_accuracy => v_doc(i).doc_mth(l_mth).mth.accuracy
                                 ,a_is_template => v_doc(i).doc_mth(l_mth).mth.is_template
                                 ,a_calibration => v_doc(i).doc_mth(l_mth).mth.calibration
                                 ,a_autorecalc => v_doc(i).doc_mth(l_mth).mth.autorecalc
                                 ,a_confirm_complete => v_doc(i).doc_mth(l_mth).mth.confirm_complete
                                 ,a_auto_create_cells => v_doc(i).doc_mth(l_mth).mth.auto_create_cells
                                 ,a_me_result_editable => v_doc(i).doc_mth(l_mth).mth.me_result_editable
                                 ,a_executor => v_doc(i).doc_mth(l_mth).mth.executor
                                 ,a_eq_tp => v_doc(i).doc_mth(l_mth).mth.eq_tp
                                 ,a_sop => v_doc(i).doc_link
                                 ,a_sop_version => v_doc(i).doc_mth(l_mth).mth.sop_version
                                 ,a_plaus_low => v_doc(i).doc_mth(l_mth).mth.plaus_low
                                 ,a_plaus_high => v_doc(i).doc_mth(l_mth).mth.plaus_high
                                 ,a_winsize_x => v_doc(i).doc_mth(l_mth).mth.winsize_x
                                 ,a_winsize_y => v_doc(i).doc_mth(l_mth).mth.winsize_y
                                 ,a_sc_lc => v_doc(i).doc_mth(l_mth).mth.sc_lc
                                 ,a_sc_lc_version => v_doc(i).doc_mth(l_mth).mth.sc_lc_version
                                 ,a_def_val_tp => v_doc(i).doc_mth(l_mth).mth.def_val_tp
                                 ,a_def_au_level => v_doc(i).doc_mth(l_mth).mth.def_au_level
                                 ,a_def_val => v_doc(i).doc_mth(l_mth).mth.def_val
                                 ,a_format => v_doc(i).doc_mth(l_mth).mth.format
                                 ,a_inherit_au => v_doc(i).doc_mth(l_mth).mth.inherit_au
                                 ,a_mt_class => v_doc(i).doc_mth(l_mth).mth.mt_class
                                 ,a_log_hs => v_doc(i).doc_mth(l_mth).mth.log_hs
                                 ,a_lc => v_doc(i).doc_mth(l_mth).mth.lc
                                 ,a_lc_version => v_doc(i).doc_mth(l_mth).mth.lc_version
                                 ,a_modify_reason => 'Watson set current');
                    --
                    dbms_output.put_line('Save method '||l_error||' - '||length(l_version));
                    dbms_output.put_line(l_version);
                    --
                    if l_error > 0
                    then
                      raise_application_error(-20000, 'Error saving method');
                    end if;
                    --
                    l_count := l_count + 1;
                    --
                    if l_count > 1
                    then
                      l_version := l_version||',';
                    end if;
                    --
                    l_version := l_version||v_doc(i).doc_mth(l_mth).mth.mt||'+-+'||ltrim(v_doc(i).doc_mth(l_mth).mth.version, '0');
                  end if;
                exception
                  when others
                  then
                    rollback;
                    dbms_output.put_line(sqlerrm);
                    dbms_output.put_line('Response: '||v_doc(i).doc_response);
                end;
              end if;
              --
              l_mth := v_doc(i).doc_mth.next(l_mth);
            end loop;
            --
            l_commit := true;
          end if;
          --
          if not p_test
          then
            l_update := update_document
                          (p_library => v_libraries(l_lib)
                          ,p_unid => v_doc(i).doc_unid
                          ,p_version => l_version
                          ,p_response => v_doc(i).doc_response
                          ,p_link => v_doc(i).doc_link
                          ,p_error => not l_commit);
            --
            select extractvalue(xmltype(l_update), '/Document')
            into   l_result
            from   dual;
            --
            dbms_output.put_line('Result '||l_result);
            --
            if l_commit
            then
              commit;
            else
              rollback;
            end if;
          end if;
          --
  --        if l_result = 'OK'
  --        then
  --          commit;
  --        else
  --          rollback;
  --        end if;
          --
          dbms_output.put_line(v_doc(i).doc_filename||' - '||v_doc(i).doc_response);
        end if;
      exception
        when others
        then
          rollback;
          dbms_output.put_line(sqlerrm);
          dbms_output.put_line('Response: '||v_doc(i).doc_response);
      end;
    end loop;
    --
    l_lib := v_libraries.next(l_lib);
  end loop;
  --
  commit;
end;
--
procedure update_file
  (p_username in varchar2 default null
  ,p_password in varchar2 default null
  ,p_link in varchar2)
is
  l_lib pls_integer;
begin
  initialize
    (p_username => p_username
    ,p_password => p_password);
  --
  set_connection;
  --
  l_lib := v_libraries.first;
  while l_lib is not null
  loop
    dbms_output.put_line('Library: '||v_libraries(l_lib));
    --
    set_list
      (p_library => v_libraries(l_lib)
      ,p_link => p_link);
    --
    for i in 1..v_doc.count
    loop
      begin
        dbms_output.put_line('==============================================');
        dbms_output.put_line('Unid: '||v_doc(i).doc_unid);
        dbms_output.put_line('Attachments: '||v_doc(i).doc_attachments);
--        dbms_output.put_line('Attachments: '||v_doc(i).doc_attachments);
        dbms_output.put_line('Link: '||v_doc(i).doc_link);
        --
        if upper(v_doc(i).doc_link) = upper(p_link)
        then
          dbms_output.put_line('####################################################################################');
          --
          if not v_doc(i).doc_error
          then
            dbms_output.put_line('Update blob');
            --
            update utblob blb
            set    blb.data = v_doc(i).doc_data
            ,      blb.url = v_doc(i).doc_filename
            where  blb.id = p_link;
            --
            commit;
          end if;
          --
          exit;
        end if;
        --
        dbms_output.put_line(v_doc(i).doc_filename||' - '||v_doc(i).doc_response);
      exception
        when others
        then
          dbms_output.put_line(sqlerrm);
          dbms_output.put_line('Response: '||v_doc(i).doc_response);
      end;
    end loop;
    --
    l_lib := v_libraries.next(l_lib);
  end loop;
  --
  commit;
end;
--
procedure delete_files
is
  l_error pls_integer;
begin
  for r_blb in (select *
                from   utblob blb
                where  blb.id like '%UL_TEST_TT%')
  loop
    l_error := unapifi.deletedocument
                 (a_id => r_blb.id
                 ,a_modify_reason => '');
    dbms_output.put_line(r_blb.id||' -  - '||l_error);
  end loop;
  --
  commit;
end;
--
procedure delete_method
  (p_mt in varchar2
  ,p_version in varchar2)
is
  l_ret_code number;
begin
  set_connection;
  --
--  l_ret_code := unapimt.deletemethod
--                  (a_mt => p_mt
--                  ,a_version => p_version
--                  ,a_modify_reason => '');
  --
  delete utmtau
  where  mt = p_mt
  and    version = p_version;

  delete utmtcell
  where  mt = p_mt
  and    version = p_version;

  delete utmtcelleqtype
  where  mt = p_mt
  and    version = p_version;

  delete utmtcelllist
  where  mt = p_mt
  and    version = p_version;
  --
  delete utmtcellspin
  where  mt = p_mt
  and    version = p_version;
  --
  delete utmths
  where  mt = p_mt
  and    version = p_version;
  --
  delete utprmt
  where  mt = p_mt
  and    version = p_version;
  --
  delete utprmtau
  where  mt = p_mt
  and    version = p_version;
  --
  delete utstmtfreq
  where  mt = p_mt
  and    version = p_version;
  --
--  delete utevtimed
--  where  mt = p_mt
--  and    version = p_version;
  --
--  delete utevrulesdelayed
--  where  mt = p_mt
--  and    version = p_version;
  --
  delete utmt
  where  mt = p_mt
  and    version = p_version;
  dbms_output.put_line(l_ret_code);
end;
--
--
-- API-TEST-PROCEDURES:
-- 
PROCEDURE api_test_show_html_from_url (
  p_url              IN  VARCHAR2,
  p_username         IN  VARCHAR2 DEFAULT NULL,
  p_password         IN  VARCHAR2 DEFAULT NULL,
  p_wallet_path      IN  VARCHAR2 DEFAULT NULL,
  p_wallet_password  IN  VARCHAR2 DEFAULT NULL
) AS
  l_http_request   UTL_HTTP.req;
  l_http_response  UTL_HTTP.resp;
  l_text           VARCHAR2(32767);
BEGIN
  dbms_output.enable(1000000);
  -- If using HTTPS, open a wallet containing the trusted root certificate.
  IF p_wallet_path IS NOT NULL 
  AND p_wallet_password IS NOT NULL 
  THEN
    UTL_HTTP.set_wallet('file:' || p_wallet_path, p_wallet_password);
  END IF;
  -- Make a HTTP request and get the response.
  l_http_request  := UTL_HTTP.begin_request(p_url);
  -- Use basic authentication if required.
  IF p_username IS NOT NULL 
  and p_password IS NOT NULL 
  THEN
    UTL_HTTP.set_authentication(l_http_request, p_username, p_password);
  END IF;
  --
  l_http_response := UTL_HTTP.get_response(l_http_request);
  --
  -- Loop through the response.
  BEGIN
    LOOP
      UTL_HTTP.read_text(l_http_response, l_text, 32766);
      DBMS_OUTPUT.put_line (l_text);
    END LOOP;
  EXCEPTION
    WHEN UTL_HTTP.end_of_body THEN
      UTL_HTTP.end_response(l_http_response);
  END;
  --
EXCEPTION
  WHEN OTHERS 
  THEN
    UTL_HTTP.end_response(l_http_response);
    RAISE;
END api_test_show_html_from_url;
--
--of aanroepen met kant-en-klare settings + URL:
--
PROCEDURE api_aanroep_show_html_from_url 
IS
l_url              VARCHAR2(1000) := 'https://ensidoc.vredestein.com/docova/zzz_development.nsf/WhoAmi?openpage';  
l_username         VARCHAR2(100)  := 'Unilab';
l_password         VARCHAR2(100)  := 'unilab';
l_wallet_path      VARCHAR2(1000) := 'C:\oracle\admin\U611\wallet\watson';
l_wallet_password  VARCHAR2(100)  := 'U611WalletPW001';
begin
  api_test_show_html_from_url (p_url=>l_url
                              ,p_username=>l_username
                              ,p_password=>l_password
                              ,p_wallet_path=>l_wallet_path      
                              ,p_wallet_password=>l_wallet_password);
end api_aanroep_show_html_from_url;  
--
END APAO_WATSON;
/

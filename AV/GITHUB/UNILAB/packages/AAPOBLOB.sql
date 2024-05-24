CREATE OR REPLACE package        aapoblob as
--
procedure do;
--
function do2 (avnObjectId  IN NUMBER)
RETURN INTEGER;
--
end aapoblob;
/


CREATE OR REPLACE PACKAGE BODY        AAPOBLOB AS
--
procedure do
is
  l_filename varchar2(32767);
  l_raw aapiblob.t_raw@interspec;
  l_result pls_integer;
  l_index pls_integer;
  l_blob blob;
begin
  delete ut_test_blob;
  --
  l_result := aapiblob.get@interspec
                (asFileName => l_filename
                ,abRaw => l_raw);
  --
  dbms_lob.createtemporary(l_blob, true);
  dbms_lob.open(l_blob, dbms_lob.lob_readwrite);
  --
  l_index := l_raw.first;
  while l_index is not null
  loop
    dbms_lob.writeappend(l_blob, utl_raw.length(l_raw(l_index)), l_raw(l_index));
    l_index := l_raw.next(l_index);
  end loop;
  --
  dbms_lob.close(l_blob);
  --
  insert into ut_test_blob
  values (l_filename, l_blob);
  --
  commit;
end do;
--

function do2 (avnObjectId  IN NUMBER)
RETURN INTEGER IS
 l_filename varchar2(32767);
  l_raw aapiblob.t_raw@interspec;
  l_result pls_integer;
  l_index pls_integer;
  l_blob blob;
begin
  delete ut_test_blob;
  --
  l_result := aapiblob.getBLOBbyObjectId@interspec
                (anObjectId => avnObjectId,
                 asFileName => l_filename,
                abRaw => l_raw);
  --
  dbms_lob.createtemporary(l_blob, true);
  dbms_lob.open(l_blob, dbms_lob.lob_readwrite);
  --
  l_index := l_raw.first;
  while l_index is not null
  loop
    dbms_lob.writeappend(l_blob, utl_raw.length(l_raw(l_index)), l_raw(l_index));
    l_index := l_raw.next(l_index);
  end loop;
  --
  dbms_lob.close(l_blob);
  --
  insert into ut_test_blob
  values (l_filename, l_blob);
  --
  commit;
RETURN 0;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
   null;
  END IF;
  RETURN SQLCODE;
END do2;

END AAPOBLOB;
/

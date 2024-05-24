create or replace package body aapiblob as
--
--
function convert
  (abBlob in blob)
   return t_raw
is
  l_length pls_integer;
  l_index pls_integer := 0;
  l_raw t_raw;
  l_max_length constant pls_integer := 16000;
begin
  l_length := dbms_lob.getlength(abBlob);
  while l_length > 0
  loop
    if l_length > l_max_length
    then
      l_raw(l_index) := dbms_lob.substr(abBlob, l_max_length, l_max_length * l_index + 1);
    else
      l_raw(l_index) := dbms_lob.substr(abBlob, l_length, l_max_length * l_index + 1);
    end if;
    --
    l_index := l_index + 1;
    l_length := l_length - l_max_length;
  end loop;
  --
  return l_raw;
end;
--
function get
  (asFileName out varchar2
  ,abRaw out t_raw)
   return iapiType.ErrorNum_Type
is
  l_length pls_integer;
  l_index pls_integer := 0;
  l_max_length constant pls_integer := 16000;
begin
  for r_rec in (select   iid.file_name
                ,        irw.desktop_object
                from     itoid iid
                ,        itoiraw irw
                where    iid.file_name is not null
                and      irw.object_id = iid.object_id
                and      irw.revision = iid.revision
                and      irw.owner = iid.owner
                order by dbms_random.value)
  loop
    asFileName := r_rec.file_name;
    --
    l_length := dbms_lob.getlength(r_rec.desktop_object);
    while l_length > 0
    loop
      if l_length > l_max_length
      then
        abRaw(l_index) := dbms_lob.substr(r_rec.desktop_object, l_max_length, l_max_length * l_index + 1);
      else
        abRaw(l_index) := dbms_lob.substr(r_rec.desktop_object, l_length, l_max_length * l_index + 1);
      end if;
      --
      l_index := l_index + 1;
      l_length := l_length - l_max_length;
    end loop;
    --
    exit;
  end loop;
  --
  return null;
end;
--
function getBLOBbyObjectId
  (anObjectId in number,
  asFileName out varchar2
  ,abRaw out t_raw)
   return iapiType.ErrorNum_Type
is
  l_length pls_integer;
  l_index pls_integer := 0;
  l_max_length constant pls_integer := 16000;
begin
  for r_rec in (select   iid.file_name
                ,        irw.desktop_object
                from     itoid iid
                ,        itoiraw irw
                where    iid.object_id = anObjectId
                and      iid.file_name is not null
                and      irw.object_id = iid.object_id
                and      irw.revision = iid.revision
                and      irw.owner = iid.owner)
  loop
    asFileName := r_rec.file_name;
    --
    l_length := dbms_lob.getlength(r_rec.desktop_object);
    while l_length > 0
    loop
      if l_length > l_max_length
      then
        abRaw(l_index) := dbms_lob.substr(r_rec.desktop_object, l_max_length, l_max_length * l_index + 1);
      else
        abRaw(l_index) := dbms_lob.substr(r_rec.desktop_object, l_length, l_max_length * l_index + 1);
      end if;
      --
      l_index := l_index + 1;
      l_length := l_length - l_max_length;
    end loop;
    --
    exit;
  end loop;
  --
  return null;
end;
end aapiblob; 
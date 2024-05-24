create or replace PACKAGE BODY          APAO_WATSON_1 AS
--
--
v_site utl_http.html_pieces;
--
v_server varchar2(255);
v_library varchar2(255);
v_username varchar2(255) := 'Administrator';
v_password varchar2(255) := 'Idoc2008';
--
type t_kyw is table of specification_kw%rowtype index by pls_integer;
--
type t_sec is table of specification_section%rowtype index by pls_integer;
type t_prp is table of specification_prop%rowtype index by pls_integer;
--
type r_att is record (att_spec attached_specification%rowtype);
type t_att is table of attached_specification%rowtype index by pls_integer;
--
type r_obj is record (obj_oid itoid%rowtype
                     ,obj_oih itoih%rowtype
                     ,obj_oiraw itoiraw%rowtype);
type t_obj is table of r_obj index by pls_integer;
--
type r_spc is record (wts watson_certificates_1%rowtype
                     ,description part.description%type
                     ,keywords t_kyw
                     ,sections t_sec
                     ,properties t_prp
                     ,attachments t_att
                     ,objects t_obj);
v_spc r_spc;
--
type r_crt is record (crt_property pls_integer
                     ,crt_property_rev pls_integer);
type t_crt is table of r_crt index by varchar2(50);
v_crt t_crt;
--
function string_to_array
  (p_string in varchar2
  ,p_separator in varchar2 := ','
  ,p_trim in varchar2 := 'N'
  ,p_trailing_separators in varchar2 := 'N')
   return t_chr_int
is
  l_values t_chr_int;
  l_start pls_integer;
  l_string varchar2(32767);
  l_index pls_integer := 0;
  l_length pls_integer;
  l_end pls_integer;
begin
  if p_string is not null
  then
    l_string := p_string;
    l_length := length(p_separator);
    --
    if l_length > 0
    then
      if substr(l_string, -l_length, l_length) <> p_separator
      or p_trailing_separators = 'N'
      then
        l_string := l_string||p_separator;
      end if;
      --
      if substr(l_string, 1, l_length) <> p_separator
      or p_trailing_separators = 'N'
      then
        l_string := p_separator||l_string;
      end if;
      --
      for i in 1..(length(l_string) - nvl(length(replace(l_string, p_separator)), 0)) / l_length - 1
      loop
        l_start := instr(l_string, p_separator, 1, i);
        l_end := instr(l_string, p_separator, l_start + l_length);
        l_index := l_index + 1;
        l_values(l_index) := substr(l_string, l_start + l_length, (l_end - l_start) - l_length);
      end loop;
    else
      for i in 1..length(l_string)
      loop
        l_index := l_index + 1;
        l_values(l_index) := substr(l_string, i, 1);
      end loop;
    end if;
  end if;
  --
  if upper(p_trim) = 'Y'
  then
    for i in 1..l_values.count
    loop
      l_values(i) := trim(l_values(i));
    end loop;
  end if;
  --
  return l_values;
end;
--
procedure update_wts
is
begin
  update watson_certificates_1 wts
  set    wts.wts_new_certificate_type = 'ECE R30 / R54'
  where  wts.wts_certificate_type in ('R30', 'R54');
  --
  update watson_certificates_1 wts
  set    wts.wts_new_certificate_type = 'ECE R117'
  where  wts.wts_certificate_type = 'R117';
  --
  update watson_certificates_1 wts
  set    wts.wts_new_certificate_type = 'China certificate (CCC)'
  where  wts.wts_certificate_type = 'CCC';
  --
  update watson_certificates_1 wts
  set    wts.wts_new_certificate_type = 'India certificate (BIS)'
  where  wts.wts_certificate_type = 'BIS';
  --
  update watson_certificates_1 wts
  set    wts.wts_new_certificate_type = 'Middle East certificate (GSO)'
  where  wts.wts_certificate_type = 'GSO';
  --
  update watson_certificates_1 wts
  set    wts.wts_new_certificate_type = 'Brasil certificate (Inmetro)'
  where  wts.wts_certificate_type = 'INMETRO';
  --
  update watson_certificates_1 wts
  set    wts.wts_new_certificate_type = 'Indonesia certificate (SNI)'
  where  wts.wts_certificate_type = 'SNI';
  --
  update watson_certificates_1 wts
  set    wts.wts_new_certificate_type = 'Taiwan certificate (VSCC)'
  where  wts.wts_certificate_type = 'VSCC';
  --
  update watson_certificates_1 wts
  set    wts.wts_new_certificate_type = 'Finland certificate (TRAFI)'
  where  wts.wts_certificate_type = 'TRAFI';
  --
  update watson_certificates_1 wts
  set    wts.wts_new_certificate_type = 'LATU (Uruguay)'
  where  wts.wts_certificate_type = 'LATU';
  --
  update watson_certificates_1 wts
  set    wts.wts_filename = replace(wts.wts_filename, '.PDF', '.pdf')
  where  wts.wts_filename like '%.PDF';
  --
--  for r_wts in (select wts.*
--                ,      substr(wts.wts_product_size, instr(translate(wts.wts_product_size, '012345678', '99999999'), '999/99R99'), 9) wts_size
--                from   watson_certificates_1 wts
--                where  wts.wts_section_width is null
--                and    instr(translate(wts.wts_product_size, '012345678', '99999999'), '999/99R99') > 0)
--  loop
--    update watson_certificates_1 wts
--    set    wts.wts_section_width = substr(r_wts.wts_size, 1, 3)
--    , 
--    where  wts.wts_unid = r_wts.wts_unid;
--  end loop;
  --
  commit;
end;
--
procedure add_section
  (p_id in number
  ,p_type in pls_integer
  ,p_ref_id in number
  ,p_ref_version in pls_integer
  ,p_ref_info in pls_integer
  ,p_sequence_no in pls_integer
  ,p_mandatory in varchar2
  ,p_section_sequence_no in pls_integer
  ,p_display_format in pls_integer
  ,p_intl in pls_integer
  ,p_display_format_rev in pls_integer
  ,p_ref_owner in pls_integer)
is
  l_idx pls_integer := v_spc.sections.count + 1;
begin
  v_spc.sections(l_idx).part_no := v_spc.wts.wts_certificate;
  v_spc.sections(l_idx).revision := 1;
  v_spc.sections(l_idx).section_id := p_id;
  v_spc.sections(l_idx).sub_section_id := 0;
  v_spc.sections(l_idx).type := p_type;
  v_spc.sections(l_idx).ref_id := p_ref_id;
  v_spc.sections(l_idx).ref_ver := p_ref_version;
  v_spc.sections(l_idx).ref_info := p_ref_info;
  v_spc.sections(l_idx).sequence_no := p_sequence_no;
  v_spc.sections(l_idx).header := 1;
  v_spc.sections(l_idx).mandatory := p_mandatory;
  v_spc.sections(l_idx).section_sequence_no := p_section_sequence_no;
  v_spc.sections(l_idx).display_format := p_display_format;
  v_spc.sections(l_idx).intl := p_intl;
  v_spc.sections(l_idx).section_rev := 100;
  v_spc.sections(l_idx).sub_section_rev := 100;
  v_spc.sections(l_idx).display_format_rev := p_display_format_rev;
  v_spc.sections(l_idx).ref_owner := p_ref_owner;
end;
--
procedure add_keyword
  (p_id in number
  ,p_value in varchar2
  ,p_intl in varchar2)
is
  l_idx pls_integer := v_spc.keywords.count + 1;
begin
  if p_value is not null
  then
    v_spc.keywords(l_idx).part_no := v_spc.wts.wts_certificate;
    v_spc.keywords(l_idx).kw_id := p_id;
    v_spc.keywords(l_idx).kw_value := p_value;
    v_spc.keywords(l_idx).intl := p_intl;
  end if;
end;
--
function new_object
  (p_wts in watson_certificates_1%rowtype)
   return number
is
  pragma autonomous_transaction;
  --
  l_object_id number;
begin
  select object_id_seq.nextval
  into   l_object_id
  from   dual;
  --
  update watson_certificates_1 wts
  set    wts.wts_object_id = l_object_id
  where  wts.wts_unid = p_wts.wts_unid;
  --
  commit;
  --
  return l_object_id;
end;
--
procedure add_object
  (p_wts in watson_certificates_1%rowtype)
is
  l_idx pls_integer := v_spc.objects.count + 1;
  --
  l_object_id number;
begin
  if p_wts.wts_object_id is null
  then
    l_object_id := new_object
                     (p_wts => p_wts);
  else
    l_object_id := p_wts.wts_object_id;
  end if;
  --
  v_spc.objects(l_idx).obj_oiraw.object_id := l_object_id;
  v_spc.objects(l_idx).obj_oiraw.revision := 1;
  v_spc.objects(l_idx).obj_oiraw.owner := 1;
  v_spc.objects(l_idx).obj_oiraw.desktop_object := p_wts.wts_file;
  --
  v_spc.objects(l_idx).obj_oid.object_id := l_object_id;
  v_spc.objects(l_idx).obj_oid.revision := 1;
  v_spc.objects(l_idx).obj_oid.owner := 1;
  v_spc.objects(l_idx).obj_oid.status := 2;
  v_spc.objects(l_idx).obj_oid.created_on := sysdate;
  v_spc.objects(l_idx).obj_oid.created_by := 'INTERSPC';
  v_spc.objects(l_idx).obj_oid.last_modified_on := sysdate;
  v_spc.objects(l_idx).obj_oid.last_modified_by := 'INTERSPC';
  v_spc.objects(l_idx).obj_oid.current_date := sysdate;
  v_spc.objects(l_idx).obj_oid.object_width := 0;
  v_spc.objects(l_idx).obj_oid.object_height := 0;
  v_spc.objects(l_idx).obj_oid.file_name := trim(substr(replace(p_wts.wts_filename, '.pdf', ''), 1, 36))||'.pdf';
  v_spc.objects(l_idx).obj_oid.visual := 0;
  v_spc.objects(l_idx).obj_oid.ole_object := 'P';
  v_spc.objects(l_idx).obj_oid.free_object := 'Y';
  v_spc.objects(l_idx).obj_oid.exported := 0;
  v_spc.objects(l_idx).obj_oid.access_group := 1;
  --
  v_spc.objects(l_idx).obj_oih.object_id := l_object_id;
  v_spc.objects(l_idx).obj_oih.owner := 1;
  v_spc.objects(l_idx).obj_oih.lang_id := 0;
  v_spc.objects(l_idx).obj_oih.sort_desc := trim(substr(replace(p_wts.wts_filename, '.pdf', ''), 1, 20));
  v_spc.objects(l_idx).obj_oih.description := trim(substr(replace(p_wts.wts_filename, '.pdf', ''), 1, 70));
  v_spc.objects(l_idx).obj_oih.object_imported := 'Y';
  v_spc.objects(l_idx).obj_oih.allow_phantom := 'Y';
  v_spc.objects(l_idx).obj_oih.intl := 0;
end;
--
procedure add_objects
is
begin
  add_object
    (p_wts => v_spc.wts);
  --
  for r_wts in (select *
                from   watson_certificates_1 wts
                where  wts.wts_parent_certificate = v_spc.wts.wts_certificate)
  loop
    add_object
      (p_wts => r_wts);
  end loop;
end;
--
procedure add_parent_property
  (p_part_no in varchar2
  ,p_revision in pls_integer
  ,p_crt_type in varchar2
  ,p_certificate in varchar2
  ,p_sidewall_plates in varchar2		
  ,p_current_validity in varchar2		
  ,p_week_validity in varchar2		
  ,p_sidewall_marking in varchar2		
  ,p_tyre_sticker in varchar2
  ,p_remarks in varchar2)
is
  l_idx pls_integer := v_spc.properties.count + 1;
begin
  v_spc.properties(l_idx).part_no := p_part_no;
  v_spc.properties(l_idx).revision := p_revision;
  v_spc.properties(l_idx).section_id := 701095;
  v_spc.properties(l_idx).section_rev := 100;
  v_spc.properties(l_idx).sub_section_id := 0;
  v_spc.properties(l_idx).sub_section_rev := 100;
  v_spc.properties(l_idx).property_group := 700696;
  v_spc.properties(l_idx).property_group_rev := 100;
  dbms_output.put_line(p_part_no||' - type: '||p_crt_type);
  v_spc.properties(l_idx).property := v_crt(p_crt_type).crt_property;
  v_spc.properties(l_idx).property_rev := v_crt(p_crt_type).crt_property_rev;
  v_spc.properties(l_idx).attribute := 0;
  v_spc.properties(l_idx).attribute_rev := 100;
  v_spc.properties(l_idx).test_method_rev := 0;
  --
  select nvl(max(spr.sequence_no), 0) + 100
  into   v_spc.properties(l_idx).sequence_no
  from   specification_prop spr
  where  spr.part_no = p_part_no
  and    spr.revision = p_revision
  and    spr.property_group = 700696
  and    spr.attribute = 0
  and    spr.section_id = 701095
  and    spr.sub_section_id = 0;
  --
  v_spc.properties(l_idx).char_1 := p_sidewall_plates;
  v_spc.properties(l_idx).char_2 := p_current_validity;
  v_spc.properties(l_idx).char_4 := p_week_validity;
  v_spc.properties(l_idx).char_6 := p_certificate;
  v_spc.properties(l_idx).char_3 := p_sidewall_marking;
  v_spc.properties(l_idx).char_5 := p_remarks;
  v_spc.properties(l_idx).boolean_1 := 'N';
  v_spc.properties(l_idx).boolean_2 := 'N';
  v_spc.properties(l_idx).boolean_3 := 'N';
  v_spc.properties(l_idx).boolean_4 := 'N';
  --
  if p_tyre_sticker = 'Y'
  then
    v_spc.properties(l_idx).characteristic := 900484;
  elsif p_tyre_sticker = 'N'
  then
    v_spc.properties(l_idx).characteristic := 900485;
  end if;
  --
  v_spc.properties(l_idx).characteristic_rev := 0;
  v_spc.properties(l_idx).association := 900141;
  v_spc.properties(l_idx).association_rev := 100;
  --
  v_spc.properties(l_idx).intl := 2;
  v_spc.properties(l_idx).tm_det_1 := 'N';
  v_spc.properties(l_idx).tm_det_2 := 'N';
  v_spc.properties(l_idx).tm_det_3 := 'N';
  v_spc.properties(l_idx).tm_det_4 := 'N';
  v_spc.properties(l_idx).ch_rev_2 := 0;
  v_spc.properties(l_idx).ch_rev_3 := 0;
  v_spc.properties(l_idx).as_2 := 900141;
  v_spc.properties(l_idx).as_rev_2 := 100;
end;
--
procedure add_attachment
  (p_hdr in specification_header%rowtype
  ,p_prt in watson_certificate_parts_1%rowtype)
is
  l_idx pls_integer := v_spc.attachments.count + 1;
begin
  v_spc.attachments(l_idx).part_no := p_hdr.part_no;
  v_spc.attachments(l_idx).revision := p_hdr.revision;
  v_spc.attachments(l_idx).ref_id := 170719;
  v_spc.attachments(l_idx).attached_part_no := v_spc.wts.wts_certificate;
  v_spc.attachments(l_idx).attached_revision := 0;
  v_spc.attachments(l_idx).section_id := 701095;
  v_spc.attachments(l_idx).sub_section_id := 0;
  v_spc.attachments(l_idx).intl := 0;
  --
  add_parent_property
    (p_part_no => p_hdr.part_no
    ,p_revision => p_hdr.revision
    ,p_crt_type => v_spc.wts.wts_new_certificate_type
    ,p_certificate => v_spc.wts.wts_certificate
    ,p_sidewall_plates => p_prt.prt_sidewall_plates		
    ,p_current_validity => p_prt.prt_current_validity
    ,p_week_validity => p_prt.prt_week_validity
    ,p_sidewall_marking => p_prt.prt_sidewall_marking
    ,p_tyre_sticker => p_prt.prt_tyre_sticker
    ,p_remarks => p_prt.prt_remarks);
end;
--
procedure add_attachments
is
begin
  for r_prt in (select *
                from   watson_certificate_parts_1 prt
                where  prt.prt_wts_dockey = v_spc.wts.wts_dockey)
  loop
    for r_hdr in (select   hdr.*
                  from    (select   hdr.part_no
                           ,        min(hdr.planned_effective_date) planned_effective_date
                           from     specification_header hdr
                           ,        status sts
                           where    hdr.part_no = r_prt.prt_no
                           and      sts.status = hdr.status
                           and      sts.status_type in ('DEVELOPMENT', 'CURRENT')
                           group by hdr.part_no) prt
                  ,        specification_header hdr
                  where    hdr.part_no = prt.part_no
                  and      hdr.planned_effective_date >= prt.planned_effective_date)
    loop
      add_attachment
        (p_hdr => r_hdr
        ,p_prt => r_prt);
    end loop;
  end loop;
end;
--
procedure add_property
  (p_property_group in pls_integer
  ,p_property in pls_integer
  ,p_property_rev in pls_integer
  ,p_sequence_no in pls_integer
  ,p_char_1 in varchar2
  ,p_characteristic in pls_integer
  ,p_association in pls_integer
--    ,p_value in varchar2
--    ,p_intl in varchar2
  )
is
  l_idx pls_integer := v_spc.properties.count + 1;
begin
  if p_char_1 is not null
  then
    v_spc.properties(l_idx).part_no := v_spc.wts.wts_certificate;
    v_spc.properties(l_idx).revision := 1;
    v_spc.properties(l_idx).section_id := 700579;
    v_spc.properties(l_idx).section_rev := 100;
    v_spc.properties(l_idx).sub_section_id := 0;
    v_spc.properties(l_idx).sub_section_rev := 100;
    v_spc.properties(l_idx).property_group := p_property_group;
    v_spc.properties(l_idx).property_group_rev := 100;
    v_spc.properties(l_idx).property := p_property;
    v_spc.properties(l_idx).property_rev := p_property_rev;
    v_spc.properties(l_idx).attribute := 0;
    v_spc.properties(l_idx).attribute_rev := 100;
    v_spc.properties(l_idx).uom_rev := 0;
    v_spc.properties(l_idx).test_method := 0;
    v_spc.properties(l_idx).test_method_rev := 0;
    v_spc.properties(l_idx).sequence_no := p_sequence_no;
    v_spc.properties(l_idx).boolean_1 := 'N';
    v_spc.properties(l_idx).boolean_2 := 'N';
    v_spc.properties(l_idx).boolean_3 := 'N';
    v_spc.properties(l_idx).boolean_4 := 'N';
    --
    if p_property = 703422
    then
      
    dbms_output.put_line('Char 1: '||p_char_1);
      select pas.association
      ,      cas.characteristic
      into   v_spc.properties(l_idx).association
      ,      v_spc.properties(l_idx).characteristic
      from   property_association pas
      ,      association ass
      ,      characteristic_association cas
      ,      characteristic cha
      where  pas.property = p_property
      and    ass.association = pas.association
      and    cas.association = ass.association
      and    cha.characteristic_id = cas.characteristic
      and    upper(cha.description) = upper(p_char_1);
    else
      v_spc.properties(l_idx).char_1 := p_char_1;
      v_spc.properties(l_idx).characteristic := p_characteristic;
      v_spc.properties(l_idx).association := p_association;
    end if;
    --
    v_spc.properties(l_idx).characteristic_rev := 0;
    --
    if p_association > 0
    then
      v_spc.properties(l_idx).association_rev := 100;
    else
      v_spc.properties(l_idx).association_rev := 0;
    end if;
    --
    v_spc.properties(l_idx).intl := 2;
    v_spc.properties(l_idx).uom_alt_rev := 0;
    v_spc.properties(l_idx).tm_det_1 := 'N';
    v_spc.properties(l_idx).tm_det_2 := 'N';
    v_spc.properties(l_idx).tm_det_3 := 'N';
    v_spc.properties(l_idx).tm_det_4 := 'N';
    v_spc.properties(l_idx).ch_rev_2 := 0;
    v_spc.properties(l_idx).ch_rev_3 := 0;
    v_spc.properties(l_idx).as_rev_2 := 0;
    v_spc.properties(l_idx).as_rev_3 := 0;
  end if;
end;
--
procedure set_spec
  (p_wts in watson_certificates_1%rowtype)
is
begin
  v_spc := null;
  v_spc.wts := p_wts;
  --
  if p_wts.wts_status = 'INSERT'
  then
    v_spc.description := p_wts.wts_description;
    --
    add_keyword(700426, 'Certificate', 0);
    add_keyword(700751, p_wts.wts_new_certificate_type, 1);
    add_keyword(700752, p_wts.wts_section_width, 1);
    add_keyword(700753, p_wts.wts_aspect_ratio, 1);
    add_keyword(700754, p_wts.wts_rim_size, 1);
    add_keyword(700755, p_wts.wts_product_line, 1);
    --
    add_objects;
    --
    add_section(701095, 6,                        0,   0, null, null, 'Y', 300,   null, 2, 0, null);
    --
    for i in 1..v_spc.objects.count
    loop
      add_section(701095, 6, v_spc.objects(i).obj_oih.object_id,   1,    2,    0, 'N', 300 + i,   null, 0, 0,    1);
    end loop;
    --
    add_section(700579, 1,                   701563, 100, null, null, 'N', 100, 700929, 2, 4, null);
    add_section(700579, 1,                   701569, 100, null, null, 'N', 200, 700930, 2, 2, null);
    --
    add_property(701569, 703417, 301,  700, p_wts.wts_aspect_ratio    , null, null);
    add_property(701569, 703423, 301,  800, p_wts.wts_rim_size        , null, null);
    add_property(701569, 703424, 301,  600, p_wts.wts_section_width   , null, null);
    add_property(701563, 703422, 301,  100, p_wts.wts_new_product_line, null, null); -- Productline
  end if;
  --
  add_attachments;
end;
--
procedure test_spec
  (p_unid in varchar2 default '8A930BAEE8F27150C125824B00275CA3') --'7B8CAAB32F1BDC24C1257C0B002DA16D')
is
  r_wts watson_certificates_1%rowtype;
begin
  select *
  into   r_wts
  from   watson_certificates_1 wts
  where  wts.wts_unid = p_unid;
  --
  set_spec
    (p_wts => r_wts);
  --
  v_spc.attachments.delete;
  --
--  for r_hdr in (select   hdr.*
--                from     specification_header hdr
--                where    hdr.part_no = 'XEF_W255/60R18USAQ')
--  loop
--    add_attachment
--      (p_hdr => r_hdr);
--  end loop;
end;
--
procedure add_spec
is
  r_prt part%rowtype;
  r_hdr specification_header%rowtype;
  l_obj r_obj;
begin
  begin
    if iapigeneral.setconnection('INTERSPC') = 0
    then
      if v_spc.wts.wts_status = 'INSERT'
      then
        r_prt.part_no := v_spc.wts.wts_certificate;
        r_prt.description := v_spc.description;
        r_prt.base_uom := 'pcs';
        r_prt.part_source := 'I-S';
        r_prt.part_type := 700309;
        r_prt.obsolete := 0;
        --
        r_hdr.revision := 1;
        r_hdr.status := 4;
        r_hdr.phase_in_tolerance := 0;
        r_hdr.created_by := 'INTERSPC';
        r_hdr.last_modified_by := 'INTERSPC';
        r_hdr.frame_id := 'A_PCR_Certificate';
        r_hdr.frame_rev := 3;
        r_hdr.access_group := 1;
        r_hdr.workflow_group_id := 270;
        r_hdr.class3_id := 700309;
        r_hdr.owner := 1;
        r_hdr.frame_owner := 1;
        r_hdr.intl := 0;
        r_hdr.multilang := 1;
        r_hdr.uom_type := 0;
        r_hdr.ped_in_sync := 'Y';
--        r_hdr.linked_to_tc := 0;
--        r_hdr.tc_in_progress := 0;
        --
        r_hdr.part_no := r_prt.part_no;
        r_hdr.description := r_prt.description;
        r_hdr.planned_effective_date := trunc(sysdate);
        r_hdr.status_change_date := sysdate;
        r_hdr.created_on := sysdate;
        r_hdr.last_modified_on := sysdate;
        --
        insert into part
        values r_prt;
        --
        for i in 1..v_spc.objects.count
        loop
          l_obj := v_spc.objects(i);
          dbms_output.put_line('-- '||v_spc.objects(i).obj_oih.object_id);
          dbms_output.put_line('-- '||v_spc.objects(i).obj_oid.file_name);
          --
          insert into itoid
          values l_obj.obj_oid;
          --
          insert into itoiraw
          values l_obj.obj_oiraw;
          --
          insert into itoih
          values l_obj.obj_oih;
          --
          update itoih ith
          set    ith.lang_id = 1
          where  ith.object_id = v_spc.objects(i).obj_oih.object_id
          and    ith.owner = v_spc.objects(i).obj_oih.owner
          and    ith.lang_id = 0;
        end loop;
        --
        insert into specification_header
        values r_hdr;
        --
        for i in 1..v_spc.keywords.count
        loop
          insert into specification_kw
          values v_spc.keywords(i);
        end loop;
        --
        for i in 1..v_spc.sections.count
        loop
          insert into specification_section
          values v_spc.sections(i);
        end loop;
      end if;
      --
      for i in 1..v_spc.properties.count
      loop
        begin
          dbms_output.put_line('Prop: '||v_spc.properties(i).part_no||' - '||v_spc.properties(i).revision||' - '||v_spc.properties(i).section_id||' - '||v_spc.properties(i).sub_section_id||' - '||v_spc.properties(i).property_group||' - '||v_spc.properties(i).property);
          --
          insert into specification_prop
          values v_spc.properties(i);
        exception
          when dup_val_on_index
          then
            dbms_output.put_line('Prop: '||v_spc.properties(i).part_no||' - '||v_spc.properties(i).revision||' - '||v_spc.properties(i).section_id||' - '||v_spc.properties(i).sub_section_id||' - '||v_spc.properties(i).property_group||' - '||v_spc.properties(i).property);
            dbms_output.put_line(sqlerrm);
        end;
      end loop;
      --
      for i in 1..v_spc.attachments.count
      loop
        insert into attached_specification
        values v_spc.attachments(i);
      end loop;
      --
      update watson_certificates_1 crt
      set    crt.wts_status = v_spc.wts.wts_status||'ED'
      where  crt.wts_unid = v_spc.wts.wts_unid;
      --
      commit;
    end if;
  exception
    when others
    then
      rollback;
      --
      dbms_output.put_line(sqlerrm);
  end;
end;
--
procedure add_specs
is
begin                     
--  for r_wts in (select *
--                from  (select *
--                       from   watson_certificates_1 crt
--                       where  crt.wts_certificate is not null
--                       and    crt.wts_description is not null
--                       and    crt.wts_status is null
--                       and    exists (select 1
--                                      from   watson_certificate_part_1s prt
--                                      where  prt.prt_wts_dockey = crt.wts_dockey)
--                       and    not exists (select 1
--                                          from   part par
--                                          where  par.part_no = crt.wts_certificate)
--                       order by crt.wts_unid)
--                --where  rownum < 16
--                )         
  for r_wts in (select   *
                from     watson_certificates_1 crt
                where    crt.wts_status = 'ATTACH'
                and      crt.wts_parent_certificate is null
                order by crt.wts_unid)
  loop
    set_spec
      (p_wts => r_wts);
    --
    dbms_output.put_line('-- ADD -- '||v_spc.wts.wts_certificate);
    --
    add_spec;
  end loop;
end;
--
procedure del_spec
is
begin
  if iapigeneral.setconnection('INTERSPC') = 0
  then
    delete attached_specification
    where  attached_part_no = v_spc.wts.wts_certificate;
    --
    delete specification_section
    where  part_no = v_spc.wts.wts_certificate;
    --
    for i in 1..v_spc.objects.count
    loop
      update itoid iid
      set    iid.status = 1
      where  iid.object_id = v_spc.objects(i).obj_oiraw.object_id;
      --
      delete itoiraw
      where  object_id = v_spc.objects(i).obj_oiraw.object_id;
      --
      delete itoih
      where  object_id = v_spc.objects(i).obj_oiraw.object_id;
      --
      delete itoid
      where  object_id = v_spc.objects(i).obj_oiraw.object_id;
    end loop;
    --
    delete specification_kw
    where  part_no = v_spc.wts.wts_certificate;
    --
    delete specification_kw_h
    where  part_no = v_spc.wts.wts_certificate;
    --
    for i in 1..v_spc.properties.count
    loop
      delete specification_prop
      where  part_no = v_spc.properties(i).part_no
      and    revision = v_spc.properties(i).revision
      and    property_group = v_spc.properties(i).property_group
      and    property = v_spc.properties(i).property
      and    attribute = v_spc.properties(i).attribute
      and    section_id = v_spc.properties(i).section_id
      and    sub_section_id = v_spc.properties(i).sub_section_id;
    end loop;
    --
    delete specification_header
    where  part_no = v_spc.wts.wts_certificate;
    --
    delete part_plant
    where  part_no = v_spc.wts.wts_certificate;
    --
    delete part
    where  part_no = v_spc.wts.wts_certificate;
    --
    delete itschs
    where  part_no = v_spc.wts.wts_certificate;
    --
    update watson_certificates_1 crt
    set    crt.wts_status = 'DELETED'
    where  crt.wts_unid = v_spc.wts.wts_unid;
    --
    commit;
  end if;
end;
--
procedure del_specs
is
begin
  for r_wts in (select crt.*
                from   specification_header hdr
                ,      watson_certificates crt
                where  hdr.created_by = 'INTERSPC'
                and    trunc(hdr.created_on) = to_date('20190625', 'yyyymmdd')
                and    crt.crt_certificate = hdr.part_no
--                and    hdr.part_no = 'E4-117R-023651'
                --group by hdr.part_no
                and    crt.crt_revision is not null)
  loop

--  for r_wts in (select *
--                from   watson_certificates_1 crt
--                where  crt.wts_unid = 'B15823FAB1159F78C1257C32002AEBB4')
--  loop


--  for r_wts in (select *
--                from   watson_certificates_1 crt
--                where  crt.wts_status = 'INSERTED')
--  loop
    set_spec
      (p_wts => r_wts);
    --
    del_spec;
    --
    commit;
  end loop;
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
  v_server := 'ensidoc.vredestein.com';
  v_library := 'GlobalPVRnD.nsf';
  --
  v_username := nvl(p_username, v_username);
  v_password := nvl(p_password, v_password);
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
function get_file
  (p_unid in varchar2
  ,p_filename in varchar2
  ,p_username in varchar2 default null
  ,p_password in varchar2 default null)
   return blob
is
begin
  initialize
    (p_username => p_username
    ,p_password => p_password);
  --
  return download_file
           (p_library => v_library
           ,p_unid => p_unid
           ,p_filename => p_filename);
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
function get_crt_type
  (p_name in varchar2)
   return pls_integer
is
begin
  return v_crt(p_name).crt_property;
exception
  when others
  then
    return null;
end;
--
function get_crt_type_rev
  (p_name in varchar2)
   return pls_integer
is
begin
  return v_crt(p_name).crt_property_rev;
exception
  when others
  then
    return null;
end;
--
procedure update_watson
is
begin
  update watson_certificate_parts_1 prt
  set    prt.prt_week_validity = lpad(prt.prt_week_validity, 4, '0')
  where  prt.prt_week_validity is not null
  and    replace(translate(prt.prt_week_validity, '123456789', '000000000'), '0') is null
  and    length(prt.prt_week_validity) = 3;
  --
  commit;
end;
--
procedure equalize_spec_properties
is
begin
  for r_prp in (select   prp.part_no
                ,        prp.revision
                ,        sts.sort_desc
                ,        prp.property_group
                ,        prp.property
                ,        prp.attribute
                ,        prp.section_id
                ,        prp.sub_section_id
                ,        prt.prt_sidewall_plates
                ,        prp.char_1
                ,        prt.prt_current_validity
                ,        prp.char_2
                ,        prt.prt_week_validity
                ,        prp.char_4
                ,        crt.wts_certificate
                ,        prp.char_6
                ,        prt.prt_sidewall_marking
                ,        prp.char_3
                ,        prt.prt_remarks
                ,        prp.char_5
                ,        decode(prt.prt_tyre_sticker, 'Y', 900484, 'N', 900485) prt_tyre_sticker
                ,        prp.characteristic
                from     watson_certificates_1 crt
                ,        watson_certificate_parts_1 prt
                ,        specification_header hdr
                ,        specification_prop prp
                ,        status sts
                where    crt.wts_status is not null --= 'INSERTED'
                and      prt.prt_wts_dockey = crt.wts_dockey
                and      hdr.part_no = prt.prt_no
                and      sts.status_type in ('CURRENT', 'DEVELOPMENT')
                and      hdr.status = sts.status
                and      prp.part_no = hdr.part_no
                and      prp.revision = hdr.revision
                and      prp.section_id = 701095
                and      prp.property_group = 700696
                and      prp.property = apao_watson_1.get_crt_type(crt.wts_new_certificate_type)
                and      prp.property_rev = apao_watson_1.get_crt_type_rev(crt.wts_new_certificate_type)
                and      prt.prt_sidewall_plates||'@'||prt.prt_current_validity||'@'
                       ||prt.prt_week_validity||'@'||crt.wts_certificate||'@'
                       ||prt.prt_sidewall_marking||'@'||prt.prt_remarks||'@'||decode(prt.prt_tyre_sticker, 'Y', 900484, 'N', 900485)
                         <>
                         prp.char_1||'@'||prp.char_2||'@'
                       ||prp.char_4||'@'||prp.char_6||'@'
                       ||prp.char_3||'@'||prp.char_5||'@'||prp.characteristic
                order by prp.part_no
                ,        prp.revision)
  loop
    update specification_prop prp
    set    prp.char_1 = r_prp.prt_sidewall_plates
    ,      prp.char_2 = r_prp.prt_current_validity
    ,      prp.char_4 = r_prp.prt_week_validity
    ,      prp.char_6 = r_prp.wts_certificate
    ,      prp.char_3 = r_prp.prt_sidewall_marking
    ,      prp.char_5 = r_prp.prt_remarks
    ,      prp.characteristic = r_prp.prt_tyre_sticker
    where  prp.part_no = r_prp.part_no
    and    prp.revision = r_prp.revision
    and    prp.property_group = r_prp.property_group
    and    prp.property = r_prp.property
    and    prp.attribute = r_prp.attribute
    and    prp.section_id = r_prp.section_id
    and    prp.sub_section_id = r_prp.sub_section_id;
    --
    commit;
  end loop;
end;
--
procedure equalize_certificate_keywords
is
  procedure update_kyw
    (p_part_no in varchar2
    ,p_id in number
    ,p_value in varchar2)
  is
  begin
    update specification_kw kyw
    set    kyw.kw_value = p_value
    where  kyw.part_no = p_part_no
    and    kyw.kw_id = p_id;
  end;
begin
  if iapigeneral.setconnection('INTERSPC') = 0
  then
    for r_kyw in (select   crt.wts_certificate
                  ,        crt.wts_new_certificate_type
                  ,        kw1.kw_value kw_certificate_type
                  ,        decode(kw1.part_no, null, 'N', 'Y') kw1_exist
                  ,        nvl(crt.wts_section_width, '<Any>') wts_section_width
                  ,        kw2.kw_value kw_section_width
                  ,        decode(kw2.part_no, null, 'N', 'Y') kw2_exist
                  ,        nvl(crt.wts_aspect_ratio, '<Any>') wts_aspect_ratio
                  ,        kw3.kw_value kw_aspect_ratio
                  ,        decode(kw3.part_no, null, 'N', 'Y') kw3_exist
                  ,        nvl(crt.wts_rim_size, '<Any>') wts_rim_size
                  ,        kw4.kw_value kw_rim_size
                  ,        decode(kw4.part_no, null, 'N', 'Y') kw4_exist
                  ,        nvl(crt.wts_product_line, '<Any>') wts_product_line
                  ,        kw5.kw_value kw_product_line
                  ,        decode(kw5.part_no, null, 'N', 'Y') kw5_exist
                  ,        'Certificate' wts_type
                  ,        kw6.kw_value kw_type
                  ,        decode(kw6.part_no, null, 'N', 'Y') kw6_exist
                  from     watson_certificates_1 crt
                  ,        part prt
                  ,        specification_kw kw1
                  ,        specification_kw kw2
                  ,        specification_kw kw3
                  ,        specification_kw kw4
                  ,        specification_kw kw5
                  ,        specification_kw kw6
                  where    crt.wts_status is not null
                  and      prt.part_no = crt.wts_certificate
                  and      kw1.part_no(+) = crt.wts_certificate
                  and      kw1.kw_id(+) = 700751
                  and      kw2.part_no(+) = crt.wts_certificate
                  and      kw2.kw_id(+) = 700752
                  and      kw3.part_no(+) = crt.wts_certificate
                  and      kw3.kw_id(+) = 700753
                  and      kw4.part_no(+) = crt.wts_certificate
                  and      kw4.kw_id(+) = 700754
                  and      kw5.part_no(+) = crt.wts_certificate
                  and      kw5.kw_id(+) = 700755
                  and      kw6.part_no(+) = crt.wts_certificate
                  and      kw6.kw_id(+) = 700426
                  and      crt.wts_new_certificate_type||chr(0)||
                           crt.wts_section_width||chr(0)||
                           crt.wts_aspect_ratio||chr(0)||
                           crt.wts_rim_size||chr(0)||
                           crt.wts_product_line||chr(0)||
                           'Certificate'
                           <>
                           kw1.kw_value||chr(0)||
                           replace(kw2.kw_value, '<Any>')||chr(0)||
                           replace(kw3.kw_value, '<Any>')||chr(0)||
                           replace(kw4.kw_value, '<Any>')||chr(0)||
                           replace(kw5.kw_value, '<Any>')||chr(0)||
                           kw6.kw_value)
    loop
      if r_kyw.wts_new_certificate_type <> r_kyw.kw_certificate_type
      then
        update_kyw(r_kyw.wts_certificate, 700751, r_kyw.wts_new_certificate_type);
      end if;
      --
      if r_kyw.wts_section_width <> r_kyw.kw_section_width
      then
        update_kyw(r_kyw.wts_certificate, 700752, r_kyw.wts_section_width);
      end if;
      --
      if r_kyw.wts_aspect_ratio <> r_kyw.kw_aspect_ratio
      then
        update_kyw(r_kyw.wts_certificate, 700753, r_kyw.wts_aspect_ratio);
      end if;
      --
      if r_kyw.wts_rim_size <> r_kyw.kw_rim_size
      then
        update_kyw(r_kyw.wts_certificate, 700754, r_kyw.wts_rim_size);
      end if;
      --
      if r_kyw.wts_product_line <> r_kyw.kw_product_line
      then
        update_kyw(r_kyw.wts_certificate, 700755, r_kyw.wts_product_line);
      end if;
      --
      if r_kyw.kw6_exist = 'N'
      then
        insert into specification_kw
        values
          (r_kyw.wts_certificate
          ,700426
          ,r_kyw.wts_type
          ,0);
      else
        if r_kyw.wts_type <> r_kyw.kw_type
        then
          update_kyw(r_kyw.wts_certificate, 700426, r_kyw.wts_type);
        end if;
      end if;
      --
  --    commit;
    end loop;
  end if;
end;
--
procedure new_certificate_frame
is
  r_prp specification_prop%rowtype;
  r_sct specification_section%rowtype;
  l_property pls_integer := 712394;
  l_description varchar2(50) := 'E4-30R%';
begin
  if iapigeneral.setconnection('INTERSPC') = 0
  then
    for r_spc in (select hdr.*
                  from   specification_header hdr
                  ,      status sts
                  where  hdr.frame_id = 'A_PCR_Certificate'
                  and    hdr.frame_rev = 7
                  and    hdr.description like l_description
                  and    sts.status = hdr.status
                  and    sts.status_type = 'DEVELOPMENT'
                  and    exists (select 1
                                 from   specification_prop prp
                                 where  prp.part_no = hdr.part_no
                                 and    prp.revision = hdr.revision
                                 and    prp.section_id = 701095
                                 and    prp.property_group = 700696
                                 and    prp.property = l_property))
    loop
      select *
      into   r_sct
      from   specification_section spc
      where  spc.part_no = r_spc.part_no
      and    spc.revision = r_spc.revision
      and    spc.ref_id = 700696
      and    spc.section_id = 701095;
      --
      select *
      into   r_prp
      from   specification_prop prp
      where  prp.part_no = r_spc.part_no
      and    prp.revision = r_spc.revision
      and    prp.section_id = 701095
      and    prp.property_group = 700696
      and    prp.property = l_property;
      --
      exit;
    end loop;
    --
    for r_spc in (select hdr.*
                  from   specification_header hdr
                  ,      status sts
                  where  hdr.frame_id = 'A_PCR_Certificate'
                  and    hdr.frame_rev = 7
                  and    hdr.description like l_description
                  and    sts.status = hdr.status
                  and    sts.status_type = 'DEVELOPMENT'
                  and    not exists (select 1
                                     from   specification_prop prp
                                     where  prp.part_no = hdr.part_no
                                     and    prp.revision = hdr.revision
                                     and    prp.section_id = 701095
                                     and    prp.property_group = 700696
                                     and    prp.property = l_property))
    loop
      begin
        r_sct.part_no := r_spc.part_no;
        r_sct.revision := r_spc.revision;
        --
        insert into specification_section
        values r_sct;
        --
        r_prp.part_no := r_spc.part_no;
        r_prp.revision := r_spc.revision;
        --
        insert into specification_prop
        values r_prp;
        --
        commit;
      exception
        when others
        then
          dbms_output.put_line(r_spc.part_no||' - '||sqlerrm);
      end;
    end loop;
  end if;
end;
--
procedure clean_up_temp
is
begin
  delete watson_temp tmp
  where  tmp.tmp_varchar2_1 = 'SPECIFICATION'
  and    replace(replace(tmp.tmp_varchar2_2, ';'), ' ') is null;
  --
  delete watson_temp tmp
  where  tmp.tmp_varchar2_1 = 'SPECIFICATION'
  and    not (   tmp.tmp_varchar2_2 like 'Duplicates;%'
              or translate(tmp.tmp_varchar2_2, '012345678', '999999999') like '9;%');
  --
  commit;
end;
--
procedure specification_temp
is
  l_cll t_chr_int;
begin
  for r_spc in (select   *
                from     watson_temp tmp
                where    tmp.tmp_varchar2_1 = 'SPECIFICATION'
                order by tmp.tmp_varchar2_2)
  loop
    if l_cll.count = 0
    then
      l_cll := string_to_array
                 (p_string => r_spc.tmp_varchar2_2
                 ,p_separator => ';');
    else
      null;
    end if;
  end loop;
end;
--
begin
  for r_prp in (select   prp1.description
                ,        prp.property
                ,        max(prp.property_rev) property_rev
                from     specification_prop prp
                ,        property prp1
                where    prp.property_group = 700696
                and      prp1.property = prp.property
                group by prp1.description
                ,        prp.property)
  loop
    v_crt(r_prp.description).crt_property := r_prp.property;
    v_crt(r_prp.description).crt_property_rev := r_prp.property_rev;
  end loop;
end apao_watson_1;
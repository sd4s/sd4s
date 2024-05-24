create or replace PACKAGE BODY          APAO_WATSON_2 AS
--
-- DIFFERENCES
--
--select   sct.sct_crt_name
--,        min(sct.sct_productline)||' <> '||max(sct.sct_productline) sct_productline
--,        min(sct.sct_sidewall_plates)||' <> '||max(sct.sct_sidewall_plates) sct_sidewall_plates
--,        min(sct.sct_current_validity)||' <> '||max(sct.sct_current_validity) sct_current_validity
--,        min(sct.sct_week_validity)||' <> '||max(sct.sct_week_validity) sct_week_validity
--,        min(sct.sct_sidewall_marking)||' <> '||max(sct.sct_sidewall_marking) sct_sidewall_marking
--,        min(sct.sct_tyre_sticker)||' <> '||max(sct.sct_tyre_sticker) sct_tyre_sticker
--,        min(sct.sct_remarks)||' <> '||max(sct.sct_remarks) sct_remarks
--,        count(0) sct_count
--from    (select
--         distinct sct.sct_crt_name
--         ,        sct_type    
--         ,        sct_productline    
--         ,        sct_sidewall_plates    
--         ,        sct_current_validity    
--         ,        sct_week_validity    
--         ,        sct_sidewall_marking    
--         ,        sct_tyre_sticker    
--         ,        sct_remarks
--         from     watson_specs_certificates sct) sct
--group by sct.sct_crt_name
--having   count(0) > 1
--order by sct.sct_crt_name
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
type r_spc is record (wts watson_specs_certificates%rowtype
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
function fread_blob
  (p_path in varchar2
  ,p_filename in varchar2)
   return blob
is
  l_file utl_file.file_type;
  l_blob blob;
  l_raw raw(32767);
  l_length pls_integer;
  l_pos pls_integer := 1;
begin
  l_file := utl_file.fopen
              (location => p_path
              ,filename => p_filename
              ,open_mode => 'rb'
              ,max_linesize => 32767);
  --
  dbms_lob.createtemporary(l_blob, true);
  dbms_lob.open(l_blob, dbms_lob.lob_readwrite);
  --
  begin
    loop
      utl_file.get_raw
        (file => l_file
        ,buffer => l_raw
        ,len => 16000);
      --
      l_length := length(l_raw);
      dbms_lob.writeappend(l_blob, l_length / 2, l_raw);
      l_pos := l_pos + l_length;
    end loop;
  exception
    when no_data_found
    then
      null;
    when others
    then
      raise;
  end;
  --
  dbms_lob.close(l_blob);
  --
  utl_file.fclose_all;
  --
  return l_blob;
exception
  when others
  then
    if dbms_lob.isopen(l_blob) > 0
    then
      dbms_lob.close(l_blob);
    end if;
    --
    utl_file.fclose_all;
    --
    raise;
end;
--
function add_file
  (p_crt in watson_certificates%rowtype)
   return number
is
  r_oid itoid%rowtype;
  r_oih itoih%rowtype;
  r_raw itoiraw%rowtype;
begin
  select object_id_seq.nextval
  into   r_raw.object_id
  from   dual;
  --
  r_raw.revision := 1;
  r_raw.owner := 1;
  r_raw.desktop_object := p_crt.crt_file;
  --
  r_oid.object_id := r_raw.object_id;
  r_oid.revision := 1;
  r_oid.owner := 1;
  r_oid.status := 2;
  r_oid.created_on := sysdate;
  r_oid.created_by := 'INTERSPC';
  r_oid.last_modified_on := sysdate;
  r_oid.last_modified_by := 'INTERSPC';
  r_oid.current_date := sysdate;
  r_oid.object_width := 0;
  r_oid.object_height := 0;
  r_oid.file_name := trim(substr(replace(p_crt.crt_attachments, '.pdf', ''), 1, 36))||'.pdf';
  r_oid.visual := 0;
  r_oid.ole_object := 'P';
  r_oid.free_object := 'Y';
  r_oid.exported := 0;
  r_oid.access_group := 1;
  --
  r_oih.object_id := r_raw.object_id;
  r_oih.owner := 1;
  r_oih.lang_id := 0;
  r_oih.sort_desc := trim(substr(replace(p_crt.crt_attachments, '.pdf', ''), 1, 20));
  r_oih.description := trim(substr(replace(p_crt.crt_attachments, '.pdf', ''), 1, 70));
  r_oih.object_imported := 'Y';
  r_oih.allow_phantom := 'Y';
  r_oih.intl := 0;
  --
  insert into itoid
  values r_oid;
  --
  insert into itoiraw
  values r_raw;
  --
  insert into itoih
  values r_oih;
  --
  update itoih ith
  set    ith.lang_id = 1
  where  ith.object_id = r_oih.object_id
  and    ith.owner = r_oih.owner
  and    ith.lang_id = 0;
  --
  return r_raw.object_id;
end;
--
procedure add_section
  (p_crt in watson_certificates%rowtype
  ,p_id in number
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
  r_spc specification_section%rowtype;
begin
  r_spc.part_no := p_crt.crt_certificate;
  r_spc.revision := 1;
  r_spc.section_id := p_id;
  r_spc.sub_section_id := 0;
  r_spc.type := p_type;
  r_spc.ref_id := p_ref_id;
  r_spc.ref_ver := p_ref_version;
  r_spc.ref_info := p_ref_info;
  r_spc.sequence_no := p_sequence_no;
  r_spc.header := 1;
  r_spc.mandatory := p_mandatory;
  r_spc.section_sequence_no := p_section_sequence_no;
  r_spc.display_format := p_display_format;
  r_spc.intl := p_intl;
  r_spc.section_rev := 100;
  r_spc.sub_section_rev := 100;
  r_spc.display_format_rev := p_display_format_rev;
  r_spc.ref_owner := p_ref_owner;
  --
  insert into specification_section
  values r_spc;
end;
--
procedure add_keyword
  (p_crt in watson_certificates%rowtype
  ,p_id in number
  ,p_value in varchar2
  ,p_intl in varchar2)
is
  r_kyw specification_kw%rowtype;
begin
  if p_value is not null
  then
    r_kyw.part_no := p_crt.crt_certificate;
    r_kyw.kw_id := p_id;
    r_kyw.kw_value := p_value;
    r_kyw.intl := p_intl;
    --
    insert into specification_kw
    values r_kyw;
  end if;
end;
--
procedure add_property
  (p_crt in watson_certificates%rowtype
  ,p_section_id in pls_integer
  ,p_property_group in pls_integer
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
  r_prp specification_prop%rowtype;
begin
  if p_char_1 is not null
  then
    r_prp.part_no := p_crt.crt_certificate;
    r_prp.revision := 1;
    r_prp.section_id := p_section_id;
    r_prp.section_rev := 100;
    r_prp.sub_section_id := 0;
    r_prp.sub_section_rev := 100;
    r_prp.property_group := p_property_group;
    r_prp.property_group_rev := 100;
    r_prp.property := p_property;
    r_prp.property_rev := p_property_rev;
    r_prp.attribute := 0;
    r_prp.attribute_rev := 100;
    r_prp.uom_rev := 0;
    r_prp.test_method := 0;
    r_prp.test_method_rev := 0;
    r_prp.sequence_no := p_sequence_no;
    r_prp.boolean_1 := 'N';
    r_prp.boolean_2 := 'N';
    r_prp.boolean_3 := 'N';
    r_prp.boolean_4 := 'N';
    --
    if p_property = 703422
    then
      select pas.association
      ,      cas.characteristic
      into   r_prp.association
      ,      r_prp.characteristic
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
      r_prp.char_1 := p_char_1;
      r_prp.characteristic := p_characteristic;
      r_prp.association := p_association;
    end if;
    --
    r_prp.characteristic_rev := 0;
    --
    if p_association > 0
    then
      r_prp.association_rev := 100;
    else
      r_prp.association_rev := 0;
    end if;
    --
    r_prp.intl := 2;
    r_prp.uom_alt_rev := 0;
    r_prp.tm_det_1 := 'N';
    r_prp.tm_det_2 := 'N';
    r_prp.tm_det_3 := 'N';
    r_prp.tm_det_4 := 'N';
    r_prp.ch_rev_2 := 0;
    r_prp.ch_rev_3 := 0;
    r_prp.as_rev_2 := 0;
    r_prp.as_rev_3 := 0;
    --
    insert into specification_prop
    values r_prp;
  end if;
end;
--
procedure add_labels
is
  r_lbl watson_certificates%rowtype;
begin
  if iapigeneral.setconnection('INTERSPC') = 0
  then
    for r_crt in (select   *
                  from     watson_certificates crt
                  where    crt.crt_certificate_type = 'GSO'
                  and      crt.crt_watson_label_uid like 'LABEL%'
                  and      crt.crt_label_object_id is null)
    loop
      select *
      into   r_lbl
      from   watson_certificates crt
      where  crt.crt_watson_uid = r_crt.crt_watson_label_uid;
      --
      r_crt.crt_label_object_id := add_file(r_lbl);
      --
      if r_crt.crt_label_object_id is not null
      then
        add_section(r_crt, 701095, 6, r_crt.crt_label_object_id, 1, 2, 0, 'N', 302, null, 0, 0, 1);
      end if;
      --
      update watson_certificates crt
      set    crt.crt_label_object_id = r_crt.crt_label_object_id
      where  crt.crt_watson_uid = r_crt.crt_watson_uid;
    end loop;
  end if;
end;
--
procedure set_attachments
  (p_certificate in varchar2 default null
  ,p_part_no in varchar2 default null)
is
begin
  for r_sct in (select   *
                from     watson_certificates crt
                ,        watson_specs_certificates sct
                ,        watson_specifications spc
                where    crt.crt_certificate = nvl(p_certificate, crt.crt_certificate)
                and      sct.sct_crt_name = crt.crt_certificate
                and      spc.spc_part_no = sct.sct_prt_no
                and      spc.spc_part_no = nvl(p_part_no, spc.spc_part_no)
                and      not exists (select 1
                                     from   attached_specification att
                                     where  att.part_no = spc.spc_part_no
                                     and    att.revision = spc.spc_revision
                                     and    att.attached_part_no = crt.crt_certificate
                                     and    att.attached_revision = 0)
                order by spc.spc_part_no
                ,        crt.crt_certificate)
  loop
    dbms_output.put_line(r_sct.spc_part_no||' '||r_sct.spc_revision||' '||r_sct.crt_certificate);
    --
    insert into attached_specification att
    values
      (r_sct.spc_part_no
      ,r_sct.spc_revision
      ,0
      ,r_sct.crt_certificate
      ,0 --nvl(r_sct.crt_revision, 1)
      ,701095
      ,0
      ,0);
    --
    commit;
  end loop;
end;
--
procedure set_certificate_properties
is
begin
  for r_prp in (select   crt.crt_certificate
                ,        crt.crt_revision
                ,        nvl(crt.crt_property, crt.crt_certificate) crt_property
                ,        prp.char_6 prp_certificate
                ,        crt.crt_sidewall_plates
                ,        prp.char_1 prp_sidewall_plates
                ,        crt.crt_current_validity
                ,        prp.char_2 prp_current_validity
                ,        crt.crt_week_validity
                ,        prp.char_4 prp_week_validity
                ,        crt.crt_sidewall_marking
                ,        prp.char_3 prp_sidewall_marking
                ,        decode(crt.crt_tyre_sticker, 'Y', 900484, 'N', 900485) crt_tyre_sticker
                ,        prp.characteristic prp_tyre_sticker
                ,        crt.crt_remarks
                ,        prp.char_5 prp_remarks
                from     watson_certificates crt
                ,        specification_prop prp
                where    prp.part_no = crt.crt_certificate
                and      prp.revision = nvl(crt.crt_revision, 1)
                and      prp.section_id = 701095
                and      prp.property_group = 700696
                and     (   nvl(prp.char_1, chr(0)) <> nvl(crt.crt_sidewall_plates, chr(0))
                         or nvl(prp.char_2, chr(0)) <> nvl(crt.crt_current_validity, chr(0))
                         or nvl(prp.char_4, chr(0)) <> nvl(crt.crt_week_validity, chr(0))
                         or nvl(prp.char_3, chr(0)) <> nvl(crt.crt_sidewall_marking, chr(0))
                         or nvl(prp.char_5, chr(0)) <> nvl(crt.crt_remarks, chr(0))
                         or nvl(prp.char_6, chr(0)) <> nvl(nvl(crt.crt_property, crt.crt_certificate), chr(0))
                         or nvl(prp.characteristic, 0) <> nvl(decode(crt.crt_tyre_sticker, 'Y', 900484, 'N', 900485), 0)))
  loop
    update specification_prop prp
    set    prp.char_1 = r_prp.crt_sidewall_plates
    ,      prp.char_2 = r_prp.crt_current_validity
    ,      prp.char_3 = r_prp.crt_sidewall_marking
    ,      prp.char_4 = r_prp.crt_week_validity
    ,      prp.char_5 = r_prp.crt_remarks
    ,      prp.char_6 = r_prp.crt_property
    ,      prp.characteristic = r_prp.crt_tyre_sticker
    where  prp.part_no = r_prp.crt_certificate
    and    prp.revision = nvl(r_prp.crt_revision, 1)
    and    prp.section_id = 701095
    and    prp.property_group = 700696;
  end loop;
  --
  commit;
end;
--
procedure set_attachment_sections
is
begin
  for r_spc in (select   *
                from     watson_specifications spc
                where    not exists (select 1
                                     from   specification_section sct
                                     where  sct.part_no = spc.spc_part_no
                                     and    sct.revision = spc.spc_revision
                                     and    sct.section_id = 701095
                                     and    sct.type = 8)
                and     exists (select 1
                                from   watson_specs_certificates sct
                                where  sct.sct_prt_no = spc.spc_part_no))
  loop
    insert into specification_section
      (part_no
      ,revision
      ,section_id
      ,sub_section_id
      ,type
      ,ref_id
      ,ref_ver
      ,ref_info
      ,sequence_no
      ,header
      ,mandatory
      ,section_sequence_no
      ,display_format
      ,association
      ,intl
      ,section_rev
      ,sub_section_rev
      ,display_format_rev
      ,ref_owner
      ,locked) 
    values
      (r_spc.spc_part_no
      ,r_spc.spc_revision
      ,701095
      ,0
      ,8
      ,0
      ,1
      ,null
      ,null
      ,1
      ,'N'
      ,2200
      ,null
      ,null
      ,2
      ,100
      ,100
      ,0
      ,null
      ,null);
  end loop;
  --
  commit;
end;
--
procedure set_brasil_specification_prop
is
begin
  for r_prp in (select   spc.spc_part_no
                ,        spc.spc_revision
                ,        sct.sct_property
                ,        crt.crt_certificate
                ,        prp.char_6 prp_certificate
                ,        sct.sct_sidewall_plates
                ,        prp.char_1 prp_sidewall_plates
                ,        crt.crt_current_validity
                ,        prp.char_2 prp_current_validity
                ,        crt.crt_week_validity
                ,        prp.char_4 prp_week_validity
                ,        crt.crt_sidewall_marking
                ,        prp.char_3 prp_sidewall_marking
                ,        decode(crt.crt_tyre_sticker, 'Y', 900484, 'N', 900485) crt_tyre_sticker
                ,        prp.characteristic prp_tyre_sticker
                ,        prp.association
                ,        crt.crt_remarks
                ,        prp.char_5 prp_remarks
                from     watson_certificates crt
                ,        watson_specs_certificates sct
                ,        watson_specifications spc
                ,        specification_prop prp
                where    sct.sct_crt_name = crt.crt_certificate
                and      spc.spc_part_no = sct.sct_prt_no
                and      sct.sct_type = 'Brasil certificate (Inmetro)'
                and      prp.part_no = spc.spc_part_no
                --and      spc.spc_part_no in ('EF_H195/65Q15SP5')
                and      prp.revision = spc.spc_revision
                and      prp.section_id = 701095
                and      prp.property_group = 700696
                and      prp.property = sct.sct_property
                and     (   nvl(prp.char_1, chr(0)) <> nvl(sct.sct_sidewall_plates, chr(0))
                         or nvl(prp.char_2, chr(0)) <> nvl(crt.crt_current_validity, chr(0))
                         or nvl(prp.char_4, chr(0)) <> nvl(crt.crt_week_validity, chr(0))
                         or nvl(prp.char_3, chr(0)) <> nvl(crt.crt_sidewall_marking, chr(0))
                         or nvl(prp.char_5, chr(0)) <> nvl(crt.crt_remarks, chr(0))
                         or nvl(prp.char_6, chr(0)) <> nvl(crt.crt_certificate, chr(0))
                         or nvl(prp.characteristic, 0) <> nvl(decode(crt.crt_tyre_sticker, 'Y', 900484, 'N', 900485), 0)))
  loop
    update specification_prop prp
    set    prp.char_1 = r_prp.sct_sidewall_plates
    ,      prp.char_2 = r_prp.crt_current_validity
    ,      prp.char_3 = r_prp.crt_sidewall_marking
    ,      prp.char_4 = r_prp.crt_week_validity
    ,      prp.char_5 = r_prp.crt_remarks
    ,      prp.char_6 = r_prp.crt_certificate
    ,      prp.characteristic = r_prp.crt_tyre_sticker
    where  prp.part_no = r_prp.spc_part_no
    and    prp.revision = r_prp.spc_revision
    and    prp.section_id = 701095
    and    prp.property_group = 700696
    and    prp.property = r_prp.sct_property;
  end loop;
  --
  commit;
end;
--
procedure set_specification_properties
is
begin
  if iapigeneral.setconnection('INTERSPC') = 0
  then
    for r_prp in (select   spc.spc_part_no
                  ,        spc.spc_revision
                  ,        sct.sct_property
                  ,        nvl(crt.crt_property, crt.crt_certificate) crt_property
                  ,        prp.char_6 prp_certificate
                  ,        crt.crt_sidewall_plates
                  ,        prp.char_1 prp_sidewall_plates
                  ,        crt.crt_current_validity
                  ,        prp.char_2 prp_current_validity
                  ,        crt.crt_week_validity
                  ,        prp.char_4 prp_week_validity
                  ,        crt.crt_sidewall_marking
                  ,        prp.char_3 prp_sidewall_marking
                  ,        decode(crt.crt_tyre_sticker, 'Y', 900484, 'N', 900485) crt_tyre_sticker
                  ,        prp.characteristic prp_tyre_sticker
                  ,        prp.association
                  ,        crt.crt_remarks
                  ,        prp.char_5 prp_remarks
                  ,        sct.sct_property_rev crt_property_rev
                  ,        prp.property_rev prp_property_rev
                  from     watson_certificates crt
                  ,        watson_specs_certificates sct
                  ,        watson_specifications spc
                  ,        specification_prop prp
                  where    sct.sct_crt_name = crt.crt_certificate
                  and      spc.spc_part_no = sct.sct_prt_no
                  and      prp.part_no = spc.spc_part_no
                  --and      spc.spc_part_no in ('EF_H195/65Q15SP5')
                  and      prp.revision = spc.spc_revision
                  and      prp.section_id = 701095
                  and      prp.property_group = 700696
                  and      prp.property = sct.sct_property
                  and     (   nvl(prp.char_1, chr(0)) <> nvl(crt.crt_sidewall_plates, chr(0))
                           or nvl(prp.char_2, chr(0)) <> nvl(crt.crt_current_validity, chr(0))
                           or nvl(prp.char_4, chr(0)) <> nvl(crt.crt_week_validity, chr(0))
                           or nvl(prp.char_3, chr(0)) <> nvl(crt.crt_sidewall_marking, chr(0))
                           or nvl(prp.char_5, chr(0)) <> nvl(crt.crt_remarks, chr(0))
                           or nvl(prp.char_6, chr(0)) <> nvl(nvl(crt.crt_property, crt.crt_certificate), chr(0))
                           or nvl(prp.characteristic, 0) <> nvl(decode(crt.crt_tyre_sticker, 'Y', 900484, 'N', 900485), 0)
                           or prp.property_rev <> sct.sct_property_rev))
    loop
      update specification_prop prp
      set    prp.char_1 = r_prp.crt_sidewall_plates
      ,      prp.char_2 = r_prp.crt_current_validity
      ,      prp.char_3 = r_prp.crt_sidewall_marking
      ,      prp.char_4 = r_prp.crt_week_validity
      ,      prp.char_5 = r_prp.crt_remarks
      ,      prp.char_6 = r_prp.crt_property
      ,      prp.characteristic = r_prp.crt_tyre_sticker
      ,      prp.property_rev = r_prp.crt_property_rev
      where  prp.part_no = r_prp.spc_part_no
      and    prp.revision = r_prp.spc_revision
      and    prp.section_id = 701095
      and    prp.property_group = 700696
      and    prp.property = r_prp.sct_property;
    end loop;
    --
    commit;
    --
    for r_prp in (select   prp.*
                  from     watson_specifications spc
                  ,        specification_prop prp
                  where    prp.part_no = spc.spc_part_no
                  and      prp.revision = spc.spc_revision
                  and      prp.section_id = 701095
                  and      prp.property_group = 700696
                  and      not exists (select 1
                                       from   watson_specs_certificates sct
                                       where  sct.sct_prt_no = prp.part_no
                                       and    sct.sct_property = prp.property
                                       and    sct.sct_property_rev = prp.property_rev)
                  order by spc.spc_part_no)
    loop
      delete specification_prop prp
      where  prp.part_no = r_prp.part_no
      and    prp.revision = r_prp.revision
      and    prp.section_id = 701095
      and    prp.property_group = 700696
      and    prp.property = r_prp.property;
    end loop;
    --
    commit;
  end if;
end;
--
procedure set_development_to_current
  (p_part_no in varchar2 default null)
is
begin
  if iapigeneral.setconnection('INTERSPC') = 0
  then
    for r_spc in (select   spc.spc_part_no
                  ,        spc.spc_revision
                  from     watson_specifications spc
                  ,        specification_header hdr1
                  ,        status sts1
                  ,        specification_header hdr2
                  ,        status sts2
                  where    spc.spc_part_no = nvl(p_part_no, spc.spc_part_no)
                  and      hdr1.part_no = spc.spc_part_no
                  and      hdr1.revision = spc.spc_revision
                  and      sts1.status = hdr1.status
                  and      sts1.status_type = 'DEVELOPMENT'
                  and      hdr2.part_no = spc.spc_part_no
                  and      hdr2.revision = spc.spc_revision - 1
                  and      sts2.status = hdr2.status
                  and      sts2.status_type = 'CURRENT'
                  order by spc.spc_part_no)
    loop
      for r_sct in (select *
                    from   watson_specs_certificates sct
                    where  sct.sct_prt_no = r_spc.spc_part_no)
      loop
        delete attached_specification att
        where  att.part_no = r_spc.spc_part_no
        and    att.revision = r_spc.spc_revision - 1
        and    att.attached_part_no = r_sct.sct_crt_name;
        --
        insert into attached_specification att
        values
          (r_spc.spc_part_no
          ,r_spc.spc_revision - 1
          ,0
          ,r_sct.sct_crt_name
          ,0
          ,701095
          ,0
          ,0);
      end loop;
      --
      for r_prp in (select *
                    from   specification_prop prp
                    where  prp.part_no = r_spc.spc_part_no
                    and    prp.revision = r_spc.spc_revision
                    and    prp.section_id = 701095
                    and    prp.property_group = 700696)
      loop
        delete specification_prop prp
        where  prp.part_no = r_spc.spc_part_no
        and    prp.revision = r_spc.spc_revision - 1
        and    prp.section_id = 701095
        and    prp.property_group = 700696
        and    prp.property = r_prp.property;
        --
        r_prp.revision := r_prp.revision - 1;
        --
        insert into specification_prop
        values r_prp;
        --
        dbms_output.put_line(r_prp.property);
      end loop;
  --    commit;
    end loop;
  end if;
end;
--
procedure set_certificate_keywords
is
  procedure ins_keyword
    (p_part_no in varchar2
    ,p_id in number
    ,p_value in varchar2
    ,p_intl in varchar2)
  is
    r_kyw specification_kw%rowtype;
  begin
    if p_value is not null
    then
      r_kyw.part_no := p_part_no;
      r_kyw.kw_id := p_id;
      r_kyw.kw_value := p_value;
      r_kyw.intl := p_intl;
      --
      insert into specification_kw
      values r_kyw;
    end if;
  end;
  --
begin
  if iapigeneral.setconnection('INTERSPC') = 0
  then
    for r_kyw in (select crt.crt_certificate part_no
                  ,      700752 kw_id
                  ,      crt.crt_section_width kw_value
                  ,      1 intl
                  ,     (select kyw.kw_value
                         from   specification_kw kyw
                         where  kyw.part_no = crt.crt_certificate
                         and    kyw.kw_id = 700752) old_value
                  from   watson_certificates crt
                  ,      part prt
                  where  prt.part_no = crt.crt_certificate
                  and    crt.crt_certificate is not null
                  and    crt.crt_section_width is not null
                  and    not exists (select 1
                                     from   specification_kw kyw
                                     where  kyw.part_no = crt.crt_certificate
                                     and    kyw.kw_id = 700752
                                     and    kyw.kw_value = crt.crt_section_width)
                  union all
                  select crt.crt_certificate
                  ,      700753
                  ,      crt.crt_aspect_ratio
                  ,      1
                  ,     (select kyw.kw_value
                         from   specification_kw kyw
                         where  kyw.part_no = crt.crt_certificate
                         and    kyw.kw_id = 700753)
                  from   watson_certificates crt
                  ,      part prt
                  where  prt.part_no = crt.crt_certificate
                  and    crt.crt_certificate is not null
                  and    crt.crt_aspect_ratio is not null
                  and    not exists (select 1
                                     from   specification_kw kyw
                                     where  kyw.part_no = crt.crt_certificate
                                     and    kyw.kw_id = 700753
                                     and    kyw.kw_value = crt.crt_aspect_ratio)
                  union all
                  select crt.crt_certificate
                  ,      700754
                  ,      crt.crt_rim_size
                  ,      1
                  ,     (select kyw.kw_value
                         from   specification_kw kyw
                         where  kyw.part_no = crt.crt_certificate
                         and    kyw.kw_id = 700754)
                  from   watson_certificates crt
                  ,      part prt
                  where  prt.part_no = crt.crt_certificate
                  and    crt.crt_certificate is not null
                  and    crt.crt_rim_size is not null
                  and    not exists (select 1
                                     from   specification_kw kyw
                                     where  kyw.part_no = crt.crt_certificate
                                     and    kyw.kw_id = 700754
                                     and    kyw.kw_value = crt.crt_rim_size)
                  union all
                  select crt.crt_certificate
                  ,      700755
                  ,      crt.crt_product_line
                  ,      1
                  ,     (select kyw.kw_value
                         from   specification_kw kyw
                         where  kyw.part_no = crt.crt_certificate
                         and    kyw.kw_id = 700755)
                  from   watson_certificates crt
                  ,      part prt
                  where  prt.part_no = crt.crt_certificate
                  and    crt.crt_certificate is not null
                  and    crt.crt_product_line is not null
                  and    not exists (select 1
                                     from   specification_kw kyw
                                     where  kyw.part_no = crt.crt_certificate
                                     and    kyw.kw_id = 700755
                                     and    kyw.kw_value = crt.crt_product_line)
                  union all
                  select crt.crt_certificate
                  ,      700426
                  ,      'Certificate'
                  ,      0
                  ,     (select kyw.kw_value
                         from   specification_kw kyw
                         where  kyw.part_no = crt.crt_certificate
                         and    kyw.kw_id = 700426)
                  from   watson_certificates crt
                  ,      part prt
                  where  prt.part_no = crt.crt_certificate
                  and    crt.crt_certificate is not null
                  and    not exists (select 1
                                     from   specification_kw kyw
                                     where  kyw.part_no = crt.crt_certificate
                                     and    kyw.kw_id = 700426
                                     and    kyw.kw_value = 'Certificate')
                 order by 1)
    loop
      if r_kyw.old_value is null
      then
        ins_keyword(r_kyw.part_no, r_kyw.kw_id, r_kyw.kw_value, r_kyw.intl);
      end if;
    end loop;
    --
    for r_kyw in (select crt.crt_certificate part_no
                  ,      700752 kw_id
                  ,      1 intl
                  ,     (select kyw.kw_value
                         from   specification_kw kyw
                         where  kyw.part_no = crt.crt_certificate
                         and    kyw.kw_id = 700752) old_value
                  from   watson_certificates crt
                  ,      part prt
                  where  prt.part_no = crt.crt_certificate
                  and    crt.crt_certificate is not null
                  and    crt.crt_section_width is null
                  and    exists (select 1
                                 from   specification_kw kyw
                                 where  kyw.part_no = crt.crt_certificate
                                 and    kyw.kw_id = 700752)
                  union all
                  select crt.crt_certificate
                  ,      700753
                  ,      1
                  ,     (select kyw.kw_value
                         from   specification_kw kyw
                         where  kyw.part_no = crt.crt_certificate
                         and    kyw.kw_id = 700753)
                  from   watson_certificates crt
                  ,      part prt
                  where  prt.part_no = crt.crt_certificate
                  and    crt.crt_certificate is not null
                  and    crt.crt_aspect_ratio is null
                  and    exists (select 1
                                 from   specification_kw kyw
                                 where  kyw.part_no = crt.crt_certificate
                                 and    kyw.kw_id = 700753)
                  union all
                  select crt.crt_certificate
                  ,      700754
                  ,      1
                  ,     (select kyw.kw_value
                         from   specification_kw kyw
                         where  kyw.part_no = crt.crt_certificate
                         and    kyw.kw_id = 700754)
                  from   watson_certificates crt
                  ,      part prt
                  where  prt.part_no = crt.crt_certificate
                  and    crt.crt_certificate is not null
                  and    crt.crt_rim_size is null
                  and    exists (select 1
                                 from   specification_kw kyw
                                 where  kyw.part_no = crt.crt_certificate
                                 and    kyw.kw_id = 700754)
                  union all
                  select crt.crt_certificate
                  ,      700755
                  ,      1
                  ,     (select kyw.kw_value
                         from   specification_kw kyw
                         where  kyw.part_no = crt.crt_certificate
                         and    kyw.kw_id = 700755)
                  from   watson_certificates crt
                  ,      part prt
                  where  prt.part_no = crt.crt_certificate
                  and    crt.crt_certificate is not null
                  and    crt.crt_product_line is null
                  and    exists (select 1
                                 from   specification_kw kyw
                                 where  kyw.part_no = crt.crt_certificate
                                 and    kyw.kw_id = 700755)
                 order by 1)
    loop
      delete specification_kw kyw
      where  kyw.part_no = r_kyw.part_no
      and    kyw.kw_id = r_kyw.kw_id
      and    kyw.kw_value = r_kyw.old_value;
    end loop;
  end if;
end;
--
procedure set_certificate
is
  r_lbl watson_certificates%rowtype;
begin
  for r_crt in (select *
                from   watson_certificates crt
                where  exists (select 1
                               from   part prt
                               where  prt.part_no = crt.crt_certificate
                               and    prt.description <> crt.crt_description))
  loop
    update part prt
    set    prt.description = r_crt.crt_description
    where  prt.part_no = r_crt.crt_certificate;
  end loop;
  --
  commit;
  --
  for r_crt in (select *
                from   watson_certificates crt
                where  exists (select 1
                               from   specification_header hdr
                               where  hdr.part_no = crt.crt_certificate
                               and    hdr.description <> crt.crt_description))
  loop
    update specification_header hdr
    set    hdr.description = r_crt.crt_description
    where  hdr.part_no = r_crt.crt_certificate;
  end loop;
  --
  commit;
  --
  for r_crt in (select   crt.*
                from     watson_certificates crt
                where    crt.crt_watson_label_uid is not null
                and     (select count(0)
                         from   specification_section sct
                         where  sct.part_no = crt.crt_certificate
                         and    sct.type = 6
                         and    sct.section_id = 701095
                         and    sct.ref_id > 0) = 1)
  loop
    select *
    into   r_lbl
    from   watson_certificates crt
    where  crt.crt_watson_uid = r_crt.crt_watson_label_uid;
    --
    r_crt.crt_label_object_id := add_file(r_lbl);
    --
    add_section(r_crt, 701095, 6, r_crt.crt_label_object_id, 1, 2, 0, 'N', 302, null, 0, 0, 1);
  end loop;
  --
  commit;
end;
--
procedure add_certificate
  (p_certificate in varchar2 default null)
is
  r_prt part%rowtype;
  r_hdr specification_header%rowtype;
  r_lbl watson_certificates%rowtype;
  --
  procedure add_certification_property
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
    r_prp specification_prop%rowtype;
  begin
    r_prp.part_no := p_part_no;
    r_prp.revision := p_revision;
    r_prp.section_id := 701095;
    r_prp.section_rev := 100;
    r_prp.sub_section_id := 0;
    r_prp.sub_section_rev := 100;
    r_prp.property_group := 700696;
    r_prp.property_group_rev := 100;
    r_prp.property := v_crt(p_crt_type).crt_property;
    r_prp.property_rev := v_crt(p_crt_type).crt_property_rev;
    r_prp.attribute := 0;
    r_prp.attribute_rev := 100;
    r_prp.test_method_rev := 0;
    --
    select nvl(max(spr.sequence_no), 0) + 100
    into   r_prp.sequence_no
    from   specification_prop spr
    where  spr.part_no = r_prp.part_no
    and    spr.revision = r_prp.revision
    and    spr.property_group = 700696
    and    spr.attribute = 0
    and    spr.section_id = 701095
    and    spr.sub_section_id = 0;
    --
    r_prp.char_1 := p_sidewall_plates;
    r_prp.char_2 := p_current_validity;
    r_prp.char_4 := p_week_validity;
    r_prp.char_6 := p_certificate;
    r_prp.char_3 := p_sidewall_marking;
    r_prp.char_5 := p_remarks;
    r_prp.boolean_1 := 'N';
    r_prp.boolean_2 := 'N';
    r_prp.boolean_3 := 'N';
    r_prp.boolean_4 := 'N';
    --
    if p_tyre_sticker = 'Y'
    then
      r_prp.characteristic := 900484;
    elsif p_tyre_sticker = 'N'
    then
      r_prp.characteristic := 900485;
    end if;
    --
    r_prp.characteristic_rev := 0;
    r_prp.association := 900141;
    r_prp.association_rev := 100;
    --
    r_prp.intl := 2;
    r_prp.tm_det_1 := 'N';
    r_prp.tm_det_2 := 'N';
    r_prp.tm_det_3 := 'N';
    r_prp.tm_det_4 := 'N';
    r_prp.ch_rev_2 := 0;
    r_prp.ch_rev_3 := 0;
    r_prp.as_2 := 900141;
    r_prp.as_rev_2 := 100;
    --
    insert into specification_prop
    values r_prp;
  end;
begin
  if iapigeneral.setconnection('INTERSPC') = 0
  then
    for r_crt in (select   *
                  from     watson_certificates crt
                  where    crt.crt_certificate is not null
                  and      crt.crt_certificate = nvl(p_certificate, crt.crt_certificate)
                  and      not exists (select 1
                                       from   part prt
                                       where  prt.part_no = crt.crt_certificate)
                  order by crt.crt_certificate)
    loop
      r_prt := null;
      r_hdr := null;
      --
      r_prt.part_no := r_crt.crt_certificate;
      r_prt.description := r_crt.crt_description;
      r_prt.base_uom := 'pcs';
      r_prt.part_source := 'I-S';
      r_prt.part_type := 701134;
      r_prt.obsolete := 0;
      --
      insert into part
      values r_prt;
      --
      r_hdr.part_no := r_crt.crt_certificate;
      r_hdr.revision := 1;
      --
      if length(r_crt.crt_file) > 0
      then
        r_hdr.status := 128;
      else
        r_hdr.status := 126;
      end if;
      --
      r_hdr.description := r_crt.crt_description;
      r_hdr.planned_effective_date := trunc(sysdate);
      r_hdr.status_change_date := sysdate;
      r_hdr.phase_in_tolerance := 0;
      r_hdr.created_by := 'INTERSPC';
      r_hdr.created_on := sysdate;
      r_hdr.last_modified_by := 'INTERSPC';
      r_hdr.last_modified_on := sysdate;
      r_hdr.frame_id := 'A_PCR_Certificate';
      r_hdr.frame_rev := 7;
      r_hdr.access_group := 1885;
      r_hdr.workflow_group_id := 292;
      r_hdr.class3_id := 701134;
      r_hdr.owner := 1;
      r_hdr.frame_owner := 1;
      r_hdr.intl := 0;
      r_hdr.multilang := 1;
      r_hdr.uom_type := 0;
      r_hdr.ped_in_sync := 'Y';
      --
      insert into specification_header
      values r_hdr;
      --
      if length(r_crt.crt_file) > 0
      then
        r_crt.crt_object_id := add_file(r_crt);
        --
        if r_crt.crt_watson_label_uid is not null
        then
          select *
          into   r_lbl
          from   watson_certificates crt
          where  crt.crt_watson_uid = r_crt.crt_watson_label_uid;
          --
          r_crt.crt_label_object_id := add_file(r_lbl);
        end if;
        --
        add_section(r_crt, 701095, 6, 0, 0, null, null, 'Y', 300, null, 2, 0, null);
        add_section(r_crt, 701095, 6, r_crt.crt_object_id, 1, 2, 0, 'N', 301, null, 0, 0, 1);
        --
        if r_crt.crt_label_object_id is not null
        then
          add_section(r_crt, 701095, 6, r_crt.crt_label_object_id, 1, 2, 0, 'N', 302, null, 0, 0, 1);
        end if;
      end if;
      --
      add_section(r_crt, 701095, 1, 700696, 100, null, null, 'N', 500, 704110, 2, 3, null);
      add_section(r_crt, 700579, 1, 701563, 100, null, null, 'N', 100, 700929, 2, 4, null);
      add_section(r_crt, 700579, 1, 701569, 100, null, null, 'N', 200, 700930, 2, 2, null);
      --
      add_property(r_crt, 700579, 701569, 703417, 301,  700, r_crt.crt_aspect_ratio    , null, null);
      add_property(r_crt, 700579, 701569, 703423, 301,  800, r_crt.crt_rim_size        , null, null);
      add_property(r_crt, 700579, 701569, 703424, 301,  600, r_crt.crt_section_width   , null, null);
      add_property(r_crt, 700579, 701563, 703422, 301,  100, r_crt.crt_product_line    , null, null); -- Productline
      --
      add_keyword(r_crt, 700426, 'Certificate', 0);
      add_keyword(r_crt, 700751, r_crt.crt_type, 1);
      add_keyword(r_crt, 700752, r_crt.crt_section_width, 1);
      add_keyword(r_crt, 700753, r_crt.crt_aspect_ratio, 1);
      add_keyword(r_crt, 700754, r_crt.crt_rim_size, 1);
      add_keyword(r_crt, 700755, r_crt.crt_product_line, 1);
      --
      add_certification_property
        (p_part_no => r_crt.crt_certificate
        ,p_revision => 1
        ,p_crt_type => r_crt.crt_type
        ,p_certificate => r_crt.crt_certificate
        ,p_sidewall_plates => r_crt.crt_sidewall_plates  
        ,p_current_validity => r_crt.crt_current_validity
        ,p_week_validity => r_crt.crt_week_validity
        ,p_sidewall_marking => r_crt.crt_sidewall_marking
        ,p_tyre_sticker => r_crt.crt_tyre_sticker
        ,p_remarks => r_crt.crt_remarks);
      --
      update watson_certificates crt
      set    crt.crt_object_id = r_crt.crt_object_id
      ,      crt.crt_label_object_id = r_crt.crt_label_object_id
      ,      crt.crt_revision = r_hdr.revision
      ,      crt.crt_action = 'INSERTED'
      where  crt.crt_watson_uid = r_crt.crt_watson_uid;
      --
      commit;
    end loop;
  end if;
end;
--
procedure del_certificate
  (p_certificate in varchar2)
is
begin
  if iapigeneral.setconnection('INTERSPC') = 0
  then
    delete attached_specification
    where  attached_part_no = p_certificate;
    --
    for r_sct in (select *
                  from   specification_section sct
                  where  sct.part_no = p_certificate
                  and    sct.revision = 1
                  and    sct.section_id = 701095
                  and    sct.type = 6
                  and    sct.ref_id > 0)
    loop
      update itoid iid
      set    iid.status = 1
      where  iid.object_id = r_sct.ref_id;
      --
      delete itoiraw
      where  object_id = r_sct.ref_id;
      --
      delete itoih
      where  object_id = r_sct.ref_id;
      --
      delete itoid
      where  object_id = r_sct.ref_id;
    end loop;
    --
    delete specification_section
    where  part_no = p_certificate;
    --
    delete specification_kw
    where  part_no = p_certificate;
    --
    delete specification_kw_h
    where  part_no = p_certificate;
    --
    delete specification_prop
    where  part_no = p_certificate;
    --
    delete specification_header
    where  part_no = p_certificate;
    --
    delete part_plant
    where  part_no = p_certificate;
    --
    delete part
    where  part_no = p_certificate;
    --
    delete itschs
    where  part_no = p_certificate;
    --
    update watson_certificates crt
    set    crt.crt_object_id = null
    ,      crt.crt_label_object_id = null
    ,      crt.crt_revision = null
    ,      crt.crt_action = 'DELETED'
    where  crt.crt_certificate = p_certificate;
    --
    commit;
  end if;
end;
--
procedure link_certificate
  (p_part_no in varchar2 default null)
is
  r_prt part%rowtype;
  r_hdr specification_header%rowtype;
  r_lbl watson_certificates%rowtype;
  --
  procedure add_keyword
    (p_crt in watson_certificates%rowtype
    ,p_id in number
    ,p_value in varchar2
    ,p_intl in varchar2)
  is
    r_kyw specification_kw%rowtype;
  begin
    if p_value is not null
    then
      r_kyw.part_no := p_crt.crt_certificate;
      r_kyw.kw_id := p_id;
      r_kyw.kw_value := p_value;
      r_kyw.intl := p_intl;
      --
      insert into specification_kw
      values r_kyw;
    end if;
  end;
  --
  procedure add_property
    (p_crt in watson_certificates%rowtype
    ,p_section_id in pls_integer
    ,p_property_group in pls_integer
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
    r_prp specification_prop%rowtype;
  begin
    if p_char_1 is not null
    then
      r_prp.part_no := p_crt.crt_certificate;
      r_prp.revision := 1;
      r_prp.section_id := p_section_id;
      r_prp.section_rev := 100;
      r_prp.sub_section_id := 0;
      r_prp.sub_section_rev := 100;
      r_prp.property_group := p_property_group;
      r_prp.property_group_rev := 100;
      r_prp.property := p_property;
      r_prp.property_rev := p_property_rev;
      r_prp.attribute := 0;
      r_prp.attribute_rev := 100;
      r_prp.uom_rev := 0;
      r_prp.test_method := 0;
      r_prp.test_method_rev := 0;
      r_prp.sequence_no := p_sequence_no;
      r_prp.boolean_1 := 'N';
      r_prp.boolean_2 := 'N';
      r_prp.boolean_3 := 'N';
      r_prp.boolean_4 := 'N';
      --
      if p_property = 703422
      then
        select pas.association
        ,      cas.characteristic
        into   r_prp.association
        ,      r_prp.characteristic
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
        r_prp.char_1 := p_char_1;
        r_prp.characteristic := p_characteristic;
        r_prp.association := p_association;
      end if;
      --
      r_prp.characteristic_rev := 0;
      --
      if p_association > 0
      then
        r_prp.association_rev := 100;
      else
        r_prp.association_rev := 0;
      end if;
      --
      r_prp.intl := 2;
      r_prp.uom_alt_rev := 0;
      r_prp.tm_det_1 := 'N';
      r_prp.tm_det_2 := 'N';
      r_prp.tm_det_3 := 'N';
      r_prp.tm_det_4 := 'N';
      r_prp.ch_rev_2 := 0;
      r_prp.ch_rev_3 := 0;
      r_prp.as_rev_2 := 0;
      r_prp.as_rev_3 := 0;
      --
      insert into specification_prop
      values r_prp;
    end if;
  end;
  --
  procedure add_section
    (p_part_no in varchar2
    ,p_revision in pls_integer
    ,p_id in number
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
    r_spc specification_section%rowtype;
  begin
    r_spc.part_no := p_part_no;
    r_spc.revision := p_revision;
    r_spc.section_id := p_id;
    r_spc.sub_section_id := 0;
    r_spc.type := p_type;
    r_spc.ref_id := p_ref_id;
    r_spc.ref_ver := p_ref_version;
    r_spc.ref_info := p_ref_info;
    r_spc.sequence_no := p_sequence_no;
    r_spc.header := 1;
    r_spc.mandatory := p_mandatory;
    r_spc.section_sequence_no := p_section_sequence_no;
    r_spc.display_format := p_display_format;
    r_spc.intl := p_intl;
    r_spc.section_rev := 100;
    r_spc.sub_section_rev := 100;
    r_spc.display_format_rev := p_display_format_rev;
    r_spc.ref_owner := p_ref_owner;
    --
    insert into specification_section
    values r_spc;
  end;
  --
  procedure add_certification_property
    (p_part_no in varchar2
    ,p_revision in pls_integer
    ,p_certificate in varchar2
    ,p_property in pls_integer
    ,p_property_rev in pls_integer
    ,p_sidewall_plates in varchar2  
    ,p_current_validity in varchar2  
    ,p_week_validity in varchar2  
    ,p_sidewall_marking in varchar2  
    ,p_tyre_sticker in varchar2
    ,p_remarks in varchar2)
  is
    r_prp specification_prop%rowtype;
  begin
    r_prp.part_no := p_part_no;
    r_prp.revision := p_revision;
    r_prp.section_id := 701095;
    r_prp.section_rev := 100;
    r_prp.sub_section_id := 0;
    r_prp.sub_section_rev := 100;
    r_prp.property_group := 700696;
    r_prp.property_group_rev := 100;
    r_prp.property := p_property;
    r_prp.property_rev := p_property_rev;
    r_prp.attribute := 0;
    r_prp.attribute_rev := 100;
    r_prp.test_method_rev := 0;
    --
    select nvl(max(spr.sequence_no), 0) + 100
    into   r_prp.sequence_no
    from   specification_prop spr
    where  spr.part_no = r_prp.part_no
    and    spr.revision = r_prp.revision
    and    spr.property_group = 700696
    and    spr.attribute = 0
    and    spr.section_id = 701095
    and    spr.sub_section_id = 0;
    --
    r_prp.char_1 := p_sidewall_plates;
    r_prp.char_2 := p_current_validity;
    r_prp.char_4 := p_week_validity;
    r_prp.char_6 := p_certificate;
    r_prp.char_3 := p_sidewall_marking;
    r_prp.char_5 := p_remarks;
    r_prp.boolean_1 := 'N';
    r_prp.boolean_2 := 'N';
    r_prp.boolean_3 := 'N';
    r_prp.boolean_4 := 'N';
    --
    if p_tyre_sticker = 'Y'
    then
      r_prp.characteristic := 900484;
    elsif p_tyre_sticker = 'N'
    then
      r_prp.characteristic := 900485;
    end if;
    --
    r_prp.characteristic_rev := 0;
    r_prp.association := 900141;
    r_prp.association_rev := 100;
    --
    r_prp.intl := 2;
    r_prp.tm_det_1 := 'N';
    r_prp.tm_det_2 := 'N';
    r_prp.tm_det_3 := 'N';
    r_prp.tm_det_4 := 'N';
    r_prp.ch_rev_2 := 0;
    r_prp.ch_rev_3 := 0;
    r_prp.as_2 := 900141;
    r_prp.as_rev_2 := 100;
    --
    insert into specification_prop
    values r_prp;
  end;
begin
  if iapigeneral.setconnection('INTERSPC') = 0
  then
    for r_spc in (select   spc.*
                  ,       (select max(sst.section_sequence_no) + 100
                           from   specification_section sst
                           where  sst.part_no = spc.spc_part_no
                           and    sst.revision = spc.spc_revision) section_sequence_no
                  from     watson_specifications spc
                  where    spc.spc_part_no = nvl(p_part_no, spc.spc_part_no)
                  and      exists (select 1
                                   from   watson_specs_certificates sct
                                   where  sct.sct_prt_no = spc.spc_part_no)
                  and      not exists (select 1
                                       from   specification_section sst
                                       where  sst.part_no = spc.spc_part_no
                                       and    sst.revision = spc.spc_revision
                                       and    sst.section_id = 701095
                                       and    sst.ref_id = 700696))
    loop
      add_section(r_spc.spc_part_no, r_spc.spc_revision, 701095, 1, 700696, 100, null, null, 'N', r_spc.section_sequence_no, 704110, 2, 3, null);
--      add_section(r_spc.spc_part_no, r_spc.spc_revision, 701095, 6,      0,   0, null, null, 'N', r_spc.section_sequence_no,   null, 2, 0, null);
      --
      commit;
    end loop;
    --
    for r_crt in (select   *
                  from     watson_specifications spc
                  ,        watson_specs_certificates sct
                  ,        specification_section sst
                  ,        watson_certificates crt
                  where    spc.spc_part_no = nvl(p_part_no, spc.spc_part_no)
                  and      sct.sct_prt_no = spc.spc_part_no
                  and      sst.part_no = spc.spc_part_no
                  and      sst.revision = spc.spc_revision
                  and      sst.section_id = 701095
                  and      sst.ref_id = 700696
                  and      crt.crt_certificate = sct.sct_crt_name
                  and      not exists (select 1
                                       from   specification_prop prp
                                       where  prp.part_no = spc.spc_part_no
                                       and    prp.revision = spc.spc_revision
                                       and    prp.section_id = 701095
                                       and    prp.property_group = 700696
                                       and    prp.property = sct.sct_property))
    loop
      --
      add_certification_property
        (p_part_no => r_crt.spc_part_no
        ,p_revision => r_crt.spc_revision
        ,p_certificate => r_crt.crt_certificate
        ,p_property => r_crt.sct_property
        ,p_property_rev => r_crt.sct_property_rev
        ,p_sidewall_plates => r_crt.sct_sidewall_plates  
        ,p_current_validity => r_crt.sct_current_validity
        ,p_week_validity => r_crt.sct_week_validity
        ,p_sidewall_marking => r_crt.sct_sidewall_marking
        ,p_tyre_sticker => r_crt.sct_tyre_sticker
        ,p_remarks => r_crt.sct_remarks);
--      add_section(r_spc.spc_part_no, r_spc.spc_revision, 701095, 1, 700696, 100, null, null, 'N', r_spc.section_sequence_no, 704110, 2, 3, null);
--      add_section(r_spc.spc_part_no, r_spc.spc_revision, 701095, 6,      0,   0, null, null, 'N', r_spc.section_sequence_no,   null, 2, 0, null);
      --
      commit;
    end loop;
      
      
      
      
      
      --
--      add_property(r_crt, 700579, 701569, 703417, 301,  700, r_crt.crt_aspect_ratio    , null, null);
--      add_property(r_crt, 700579, 701569, 703423, 301,  800, r_crt.crt_rim_size        , null, null);
--      add_property(r_crt, 700579, 701569, 703424, 301,  600, r_crt.crt_section_width   , null, null);
--      add_property(r_crt, 700579, 701563, 703422, 301,  100, r_crt.crt_product_line    , null, null); -- Productline
--      --
--      add_certification_property
--        (p_part_no => r_crt.crt_certificate
--        ,p_revision => 1
--        ,p_crt_type => r_crt.crt_type
--        ,p_certificate => r_crt.crt_certificate
--        ,p_sidewall_plates => r_crt.crt_sidewall_plates  
--        ,p_current_validity => r_crt.crt_current_validity
--        ,p_week_validity => r_crt.crt_week_validity
--        ,p_sidewall_marking => r_crt.crt_sidewall_marking
--        ,p_tyre_sticker => r_crt.crt_tyre_sticker
--        ,p_remarks => r_crt.crt_remarks);
--      --
--      update watson_certificates crt
--      set    crt.crt_object_id = r_crt.crt_object_id
--      ,      crt.crt_label_object_id = r_crt.crt_label_object_id
--      ,      crt.crt_revision = r_hdr.revision
--      where  crt.crt_watson_uid = r_crt.crt_watson_uid;
  end if;
end;
--
procedure update_spec_certificates
is
begin
  update watson_specs_certificates spc
  set    spc.sct_tyre_sticker = null
  where  trim(spc.sct_tyre_sticker) is null
  and    spc.sct_tyre_sticker is not null;
  --
  update watson_specs_certificates spc
  set    spc.sct_tyre_sticker = null
  where  upper(spc.sct_tyre_sticker) = 'NA';
  --
  update watson_specs_certificates spc
  set    spc.sct_tyre_sticker = substr(spc.sct_tyre_sticker, 1, 1)
  where  spc.sct_tyre_sticker is not null;
  --
  update watson_specs_certificates spc
  set    spc.sct_current_validity = to_char(to_date('30-12-1899', 'dd-mm-yyyy') + spc.sct_current_validity, 'mm/dd/yyyy')
  where  replace(translate(spc.sct_current_validity, '012345678', '999999999'), '9') is null
  and    spc.sct_current_validity is not null;
  --
  update watson_specs_certificates spc
  set    spc.sct_week_validity = trim(spc.sct_week_validity)
  where  spc.sct_week_validity is not null;
  --
  update watson_specs_certificates sct
  set    sct.sct_new_name = 'GSO'||(select spc.spc_sizekey
                                    from   watson_specifications spc
                                    where  spc.spc_part_no = sct.sct_prt_no)
  where  sct.sct_type = 'Middle East certificate (GSO)';
  --
  update watson_specs_certificates spc
  set    spc.sct_crt_name = trim(spc.sct_crt_name);
end;
--
procedure update_certificates
is
  procedure set_dimensions
    (p_mask in varchar2
    ,p_replace1 in varchar2 default ' '
    ,p_replace2 in varchar2 default ' ')
  is
    l_len pls_integer := length(p_mask);
  begin
    
    for r_crt in (select crt.*
                  from  (select substr(crt.crt_subject, crt.crt_pos, 3) crt_section_width
                         ,      substr(crt.crt_subject, crt.crt_pos + 4, 2) crt_aspect_ratio
                         ,      substr(crt.crt_subject, crt.crt_pos + l_len - 2, 2) crt_rim_size
                         ,      regexp_substr(trim(substr(crt.crt_subject, instr(crt.crt_trans, p_mask) + l_len + 1)), '[0-9]+') crt_load_index
                         ,      regexp_substr(trim(substr(crt.crt_subject, instr(crt.crt_trans, p_mask) + l_len + 1)), '[A-Z]') crt_speed_index
                         ,      crt.*
                         from  (select translate(replace(replace(crt.crt_subject, p_replace1, ' '), p_replace2, ' '), '012345678', '999999999') crt_trans
                                ,      instr(translate(replace(replace(crt.crt_subject, p_replace1, ' '), p_replace2, ' '), '012345678', '999999999'), p_mask) crt_pos
                                ,      crt.crt_dockey
                                ,      replace(replace(crt.crt_subject, p_replace1, ' '), p_replace2, ' ') crt_subject
                                from   watson_certificates crt
                                where  crt.crt_section_width is null
                                and    instr(translate(replace(replace(crt.crt_subject, p_replace1, ' '), p_replace2, ' '), '012345678', '999999999'), p_mask) > 0) crt) crt)
    loop
      update watson_certificates crt
      set    crt.crt_section_width = r_crt.crt_section_width
      ,      crt.crt_aspect_ratio = r_crt.crt_aspect_ratio
      ,      crt.crt_rim_size = r_crt.crt_rim_size
      ,      crt.crt_load_index = r_crt.crt_load_index
      ,      crt.crt_speed_index = r_crt.crt_speed_index
      where  crt.crt_dockey = r_crt.crt_dockey;
    end loop;
    --
    commit;
  end;
begin
  for r_crt in (select
                distinct crt.crt_certificate
                ,        substr(crt.sct_prt_no, crt.crt_pos, 3) crt_section_width
                ,        substr(crt.sct_prt_no, crt.crt_pos + 3, 2) crt_aspect_ratio
                ,        substr(crt.sct_prt_no, crt.crt_pos + 5, 2) crt_rim_size
                from    (select instr(translate(sct.sct_prt_no, '012345678', '999999999'), '9999999') crt_pos
                         ,      sct.sct_prt_no
                         ,      crt.*
                         from   watson_certificates crt
                         ,      watson_specs_certificates sct
                         where  crt.crt_section_width is null
                         and    crt.crt_aspect_ratio is null
                         and    crt.crt_rim_size is null
                         and    sct.sct_crt_name = crt.crt_certificate
                         and    instr(translate(sct.sct_prt_no, '012345678', '999999999'), '9999999') > 0
                         and    crt.crt_certificate in (select   crtin.crt_certificate
                                                        from    (select
                                                                 distinct crt.crt_certificate
                                                                 ,        substr(sct.sct_prt_no, instr(translate(sct.sct_prt_no, '012345678', '999999999'), '9999999'), 9) crt_size
                                                                 from     watson_certificates crt
                                                                 ,      watson_specs_certificates sct
                                                                 where  crt.crt_section_width is null
                                                                 and    crt.crt_aspect_ratio is null
                                                                 and    crt.crt_rim_size is null
                                                                 and    sct.sct_crt_name = crt.crt_certificate
                                                                 and    instr(translate(sct.sct_prt_no, '012345678', '999999999'), '9999999') > 0) crtin
                                                        group by crtin.crt_certificate
                                                        having   count(0) = 1)) crt)
  loop
    update watson_certificates crt
    set    crt.crt_section_width = r_crt.crt_section_width
    ,      crt.crt_aspect_ratio = r_crt.crt_aspect_ratio
    ,      crt.crt_rim_size = r_crt.crt_rim_size
    where  crt.crt_certificate = r_crt.crt_certificate;
  end loop;
  --
  commit;
  --
--  for r_crt in (select decode(translate(crt.crt_load, '012345678THYVW', '999999999XXXXX' )
--                             ,'99X', substr(crt.crt_load, 1, 2), '999X', substr(crt.crt_load, 1, 3), null) crt_load_index
--                ,      decode(translate(crt.crt_load, '012345678THYVW', '999999999XXXXX' )
--                             ,'99X', substr(crt.crt_load, 3), '999X', substr(crt.crt_load, 4), null) crt_speed_index
--                ,      crt.*
--                from  (select substr(crt.crt_subject, crt.crt_pos, 3) crt_section_width
--                       ,      substr(crt.crt_subject, crt.crt_pos + 4, 2) crt_aspect_ratio
--                       ,      substr(crt.crt_subject, crt.crt_pos + 8, 2) crt_rim_size
--                       ,      trim(rtrim(substr(replace(crt.crt_subject, '('), crt.crt_pos + 11, 4), '-)')) crt_load
--                       ,      crt.*
--                       from  (select translate(crt.crt_subject, '012345678', '999999999') crt_trans
--                              ,      instr(translate(crt.crt_subject, '012345678', '999999999'), '999-99-R99') crt_pos
--                              ,      crt.crt_dockey
--                              ,      crt.crt_subject
--                              from   watson_certificates crt
--                              where  crt.crt_section_width is null
--                              and    instr(translate(crt.crt_subject, '012345678', '999999999'), '999-99-R99') > 0) crt) crt)
--  loop
--    update watson_certificates crt
--    set    crt.crt_section_width = r_crt.crt_section_width
--    ,      crt.crt_aspect_ratio = r_crt.crt_aspect_ratio
--    ,      crt.crt_rim_size = r_crt.crt_rim_size
--    ,      crt.crt_load_index = r_crt.crt_load_index
--    ,      crt.crt_speed_index = r_crt.crt_speed_index
--    where  crt.crt_dockey = r_crt.crt_dockey;
--  end loop;
--  --
--  commit;
--  --
--  set_dimensions('999/99R99');
--  set_dimensions('999 99 R99');
--  set_dimensions('999 99R99');
--  set_dimensions('999-99R99');
--  set_dimensions('999-99 R99');
--  set_dimensions('999/99ZR99');
--  set_dimensions('999-99-ZR99');
--  set_dimensions('999-99ZR99');
--  set_dimensions('999-99 ZR99');
--  set_dimensions('999/99VR99');
--  set_dimensions('999-99-99', '-00-', '-01-');
end;
--
procedure update_specification
is
begin
  for r_spc in (select   hdr.part_no
                ,        max(hdr.revision) keep (dense_rank first
                                                 order by   hdr.planned_effective_date desc) revision
                from     watson_specifications spc
                ,        specification_header hdr
                ,        status sts
                where    hdr.part_no = spc.spc_part_no
                and      sts.status = hdr.status
                and      sts.status_type in ('CURRENT', 'DEVELOPMENT')
                and      spc.spc_revision is null
                group by hdr.part_no)
  loop
    update watson_specifications spc
    set    spc.spc_revision = r_spc.revision
    where  spc.spc_part_no = r_spc.part_no;
  end loop;
  --
  commit;
  --
  for r_spc in (select   hdr.part_no
                ,        max(hdr.revision) keep (dense_rank first
                                                 order by   hdr.planned_effective_date desc) revision
                from     watson_specifications spc
                ,        specification_header hdr
                ,        status sts
                where    hdr.part_no = spc.spc_part_no
                and      sts.status = hdr.status
                and      not sts.status_type in ('CURRENT', 'DEVELOPMENT')
                and      spc.spc_revision is null
                group by hdr.part_no)
  loop
    update watson_specifications spc
    set    spc.spc_revision = r_spc.revision
    where  spc.spc_part_no = r_spc.part_no;
  end loop;
  --
  commit;
end;
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
  update watson_certificates crt
  set    crt.crt_type = 'ECE R30 / R54'
  where  crt.crt_certificate_type in ('R30', 'R54');
  --
  update watson_certificates crt
  set    crt.crt_type = 'ECE R117'
  where  crt.crt_certificate_type = 'R117';
  --
  update watson_certificates crt
  set    crt.crt_type = 'China certificate (CCC)'
  where  crt.crt_certificate_type = 'CCC';
  --
  update watson_certificates crt
  set    crt.crt_type = 'India certificate (BIS)'
  where  crt.crt_certificate_type = 'BIS';
  --
  update watson_certificates crt
  set    crt.crt_type = 'Middle East certificate (GSO)'
  where  crt.crt_certificate_type = 'GSO';
  --
  update watson_certificates crt
  set    crt.crt_type = 'Brasil certificate (Inmetro)'
  where  crt.crt_certificate_type = 'INMETRO';
  --
  update watson_certificates crt
  set    crt.crt_type = 'Indonesia certificate (SNI)'
  where  crt.crt_certificate_type = 'SNI';
  --
  update watson_certificates crt
  set    crt.crt_type = 'Taiwan certificate (VSCC)'
  where  crt.crt_certificate_type = 'VSCC';
  --
  update watson_certificates crt
  set    crt.crt_type = 'Finland certificate (TRAFI)'
  where  crt.crt_certificate_type = 'TRAFI';
  --
  update watson_certificates crt
  set    crt.crt_type = 'LATU (Uruguay)'
  where  crt.crt_certificate_type = 'LATAU';
  --
  update watson_certificates crt
  set    crt.crt_attachments = replace(crt.crt_attachments, '.PDF', '.pdf')
  where  crt.crt_attachments like '%.PDF';
  --
--  for r_wts in (select wts.*
--                ,      substr(wts.wts_product_size, instr(translate(wts.wts_product_size, '012345678', '99999999'), '999/99R99'), 9) wts_size
--                from   watson_certificates crt
--                where  wts.wts_section_width is null
--                and    instr(translate(wts.wts_product_size, '012345678', '99999999'), '999/99R99') > 0)
--  loop
--    update watson_certificates crt
--    set    wts.wts_section_width = substr(r_wts.wts_size, 1, 3)
--    , 
--    where  wts.wts_unid = r_wts.wts_unid;
--  end loop;
  --
  commit;
end;
--
--procedure add_section
--  (p_id in number
--  ,p_type in pls_integer
--  ,p_ref_id in number
--  ,p_ref_version in pls_integer
--  ,p_ref_info in pls_integer
--  ,p_sequence_no in pls_integer
--  ,p_mandatory in varchar2
--  ,p_section_sequence_no in pls_integer
--  ,p_display_format in pls_integer
--  ,p_intl in pls_integer
--  ,p_display_format_rev in pls_integer
--  ,p_ref_owner in pls_integer)
--is
--  l_idx pls_integer := v_spc.sections.count + 1;
--begin
--  v_spc.sections(l_idx).part_no := v_spc.wts.wts_certificate;
--  v_spc.sections(l_idx).revision := 1;
--  v_spc.sections(l_idx).section_id := p_id;
--  v_spc.sections(l_idx).sub_section_id := 0;
--  v_spc.sections(l_idx).type := p_type;
--  v_spc.sections(l_idx).ref_id := p_ref_id;
--  v_spc.sections(l_idx).ref_ver := p_ref_version;
--  v_spc.sections(l_idx).ref_info := p_ref_info;
--  v_spc.sections(l_idx).sequence_no := p_sequence_no;
--  v_spc.sections(l_idx).header := 1;
--  v_spc.sections(l_idx).mandatory := p_mandatory;
--  v_spc.sections(l_idx).section_sequence_no := p_section_sequence_no;
--  v_spc.sections(l_idx).display_format := p_display_format;
--  v_spc.sections(l_idx).intl := p_intl;
--  v_spc.sections(l_idx).section_rev := 100;
--  v_spc.sections(l_idx).sub_section_rev := 100;
--  v_spc.sections(l_idx).display_format_rev := p_display_format_rev;
--  v_spc.sections(l_idx).ref_owner := p_ref_owner;
--end;
----
--procedure add_keyword
--  (p_id in number
--  ,p_value in varchar2
--  ,p_intl in varchar2)
--is
--  l_idx pls_integer := v_spc.keywords.count + 1;
--begin
--  if p_value is not null
--  then
--    v_spc.keywords(l_idx).part_no := v_spc.wts.wts_certificate;
--    v_spc.keywords(l_idx).kw_id := p_id;
--    v_spc.keywords(l_idx).kw_value := p_value;
--    v_spc.keywords(l_idx).intl := p_intl;
--  end if;
--end;
----
--function new_object
--  (p_wts in watson_certificates%rowtype)
--   return number
--is
--  pragma autonomous_transaction;
--  --
--  l_object_id number;
--begin
--  select object_id_seq.nextval
--  into   l_object_id
--  from   dual;
--  --
--  update watson_certificates crt
--  set    wts.wts_object_id = l_object_id
--  where  wts.wts_unid = p_wts.wts_unid;
--  --
--  commit;
--  --
--  return l_object_id;
--end;
----
--procedure add_object
--  (p_wts in watson_certificates%rowtype)
--is
--  l_idx pls_integer := v_spc.objects.count + 1;
--  --
--  l_object_id number;
--begin
--  if p_wts.wts_object_id is null
--  then
--    l_object_id := new_object
--                     (p_wts => p_wts);
--  else
--    l_object_id := p_wts.wts_object_id;
--  end if;
--  --
--  v_spc.objects(l_idx).obj_oiraw.object_id := l_object_id;
--  v_spc.objects(l_idx).obj_oiraw.revision := 1;
--  v_spc.objects(l_idx).obj_oiraw.owner := 1;
--  v_spc.objects(l_idx).obj_oiraw.desktop_object := p_wts.wts_file;
--  --
--  v_spc.objects(l_idx).obj_oid.object_id := l_object_id;
--  v_spc.objects(l_idx).obj_oid.revision := 1;
--  v_spc.objects(l_idx).obj_oid.owner := 1;
--  v_spc.objects(l_idx).obj_oid.status := 2;
--  v_spc.objects(l_idx).obj_oid.created_on := sysdate;
--  v_spc.objects(l_idx).obj_oid.created_by := 'INTERSPC';
--  v_spc.objects(l_idx).obj_oid.last_modified_on := sysdate;
--  v_spc.objects(l_idx).obj_oid.last_modified_by := 'INTERSPC';
--  v_spc.objects(l_idx).obj_oid.current_date := sysdate;
--  v_spc.objects(l_idx).obj_oid.object_width := 0;
--  v_spc.objects(l_idx).obj_oid.object_height := 0;
--  v_spc.objects(l_idx).obj_oid.file_name := trim(substr(replace(p_wts.wts_filename, '.pdf', ''), 1, 36))||'.pdf';
--  v_spc.objects(l_idx).obj_oid.visual := 0;
--  v_spc.objects(l_idx).obj_oid.ole_object := 'P';
--  v_spc.objects(l_idx).obj_oid.free_object := 'Y';
--  v_spc.objects(l_idx).obj_oid.exported := 0;
--  v_spc.objects(l_idx).obj_oid.access_group := 1;
--  --
--  v_spc.objects(l_idx).obj_oih.object_id := l_object_id;
--  v_spc.objects(l_idx).obj_oih.owner := 1;
--  v_spc.objects(l_idx).obj_oih.lang_id := 0;
--  v_spc.objects(l_idx).obj_oih.sort_desc := trim(substr(replace(p_wts.wts_filename, '.pdf', ''), 1, 20));
--  v_spc.objects(l_idx).obj_oih.description := trim(substr(replace(p_wts.wts_filename, '.pdf', ''), 1, 70));
--  v_spc.objects(l_idx).obj_oih.object_imported := 'Y';
--  v_spc.objects(l_idx).obj_oih.allow_phantom := 'Y';
--  v_spc.objects(l_idx).obj_oih.intl := 0;
--end;
----
--procedure add_objects
--is
--begin
--  add_object
--    (p_wts => v_spc.wts);
--  --
--  for r_wts in (select *
--                from   watson_certificates crt
--                where  wts.wts_parent_certificate = v_spc.wts.wts_certificate)
--  loop
--    add_object
--      (p_wts => r_wts);
--  end loop;
--end;
----
--procedure add_parent_property
--  (p_part_no in varchar2
--  ,p_revision in pls_integer
--  ,p_crt_type in varchar2
--  ,p_certificate in varchar2
--  ,p_sidewall_plates in varchar2		
--  ,p_current_validity in varchar2		
--  ,p_week_validity in varchar2		
--  ,p_sidewall_marking in varchar2		
--  ,p_tyre_sticker in varchar2
--  ,p_remarks in varchar2)
--is
--  l_idx pls_integer := v_spc.properties.count + 1;
--begin
--  v_spc.properties(l_idx).part_no := p_part_no;
--  v_spc.properties(l_idx).revision := p_revision;
--  v_spc.properties(l_idx).section_id := 701095;
--  v_spc.properties(l_idx).section_rev := 100;
--  v_spc.properties(l_idx).sub_section_id := 0;
--  v_spc.properties(l_idx).sub_section_rev := 100;
--  v_spc.properties(l_idx).property_group := 700696;
--  v_spc.properties(l_idx).property_group_rev := 100;
--  dbms_output.put_line(p_part_no||' - type: '||p_crt_type);
--  v_spc.properties(l_idx).property := v_crt(p_crt_type).crt_property;
--  v_spc.properties(l_idx).property_rev := v_crt(p_crt_type).crt_property_rev;
--  v_spc.properties(l_idx).attribute := 0;
--  v_spc.properties(l_idx).attribute_rev := 100;
--  v_spc.properties(l_idx).test_method_rev := 0;
--  --
--  select nvl(max(spr.sequence_no), 0) + 100
--  into   v_spc.properties(l_idx).sequence_no
--  from   specification_prop spr
--  where  spr.part_no = p_part_no
--  and    spr.revision = p_revision
--  and    spr.property_group = 700696
--  and    spr.attribute = 0
--  and    spr.section_id = 701095
--  and    spr.sub_section_id = 0;
--  --
--  v_spc.properties(l_idx).char_1 := p_sidewall_plates;
--  v_spc.properties(l_idx).char_2 := p_current_validity;
--  v_spc.properties(l_idx).char_4 := p_week_validity;
--  v_spc.properties(l_idx).char_6 := p_certificate;
--  v_spc.properties(l_idx).char_3 := p_sidewall_marking;
--  v_spc.properties(l_idx).char_5 := p_remarks;
--  v_spc.properties(l_idx).boolean_1 := 'N';
--  v_spc.properties(l_idx).boolean_2 := 'N';
--  v_spc.properties(l_idx).boolean_3 := 'N';
--  v_spc.properties(l_idx).boolean_4 := 'N';
--  --
--  if p_tyre_sticker = 'Y'
--  then
--    v_spc.properties(l_idx).characteristic := 900484;
--  elsif p_tyre_sticker = 'N'
--  then
--    v_spc.properties(l_idx).characteristic := 900485;
--  end if;
--  --
--  v_spc.properties(l_idx).characteristic_rev := 0;
--  v_spc.properties(l_idx).association := 900141;
--  v_spc.properties(l_idx).association_rev := 100;
--  --
--  v_spc.properties(l_idx).intl := 2;
--  v_spc.properties(l_idx).tm_det_1 := 'N';
--  v_spc.properties(l_idx).tm_det_2 := 'N';
--  v_spc.properties(l_idx).tm_det_3 := 'N';
--  v_spc.properties(l_idx).tm_det_4 := 'N';
--  v_spc.properties(l_idx).ch_rev_2 := 0;
--  v_spc.properties(l_idx).ch_rev_3 := 0;
--  v_spc.properties(l_idx).as_2 := 900141;
--  v_spc.properties(l_idx).as_rev_2 := 100;
--end;
----
--procedure add_attachment
--  (p_hdr in specification_header%rowtype
--  ,p_prt in watson_certificate_parts%rowtype)
--is
--  l_idx pls_integer := v_spc.attachments.count + 1;
--begin
--  v_spc.attachments(l_idx).part_no := p_hdr.part_no;
--  v_spc.attachments(l_idx).revision := p_hdr.revision;
--  v_spc.attachments(l_idx).ref_id := 170719;
--  v_spc.attachments(l_idx).attached_part_no := v_spc.wts.wts_certificate;
--  v_spc.attachments(l_idx).attached_revision := 0;
--  v_spc.attachments(l_idx).section_id := 701095;
--  v_spc.attachments(l_idx).sub_section_id := 0;
--  v_spc.attachments(l_idx).intl := 0;
--  --
--  add_parent_property
--    (p_part_no => p_hdr.part_no
--    ,p_revision => p_hdr.revision
--    ,p_crt_type => v_spc.crt.crt_type
--    ,p_certificate => v_spc.wts.wts_certificate
--    ,p_sidewall_plates => p_prt.prt_sidewall_plates		
--    ,p_current_validity => p_prt.prt_current_validity
--    ,p_week_validity => p_prt.prt_week_validity
--    ,p_sidewall_marking => p_prt.prt_sidewall_marking
--    ,p_tyre_sticker => p_prt.prt_tyre_sticker
--    ,p_remarks => p_prt.prt_remarks);
--end;
----
--procedure add_attachments
--is
--begin
--  for r_prt in (select *
--                from   watson_certificate_parts prt
--                where  prt.prt_wts_dockey = v_spc.wts.wts_dockey)
--  loop
--    for r_hdr in (select   hdr.*
--                  from    (select   hdr.part_no
--                           ,        min(hdr.planned_effective_date) planned_effective_date
--                           from     specification_header hdr
--                           ,        status sts
--                           where    hdr.part_no = r_prt.prt_no
--                           and      sts.status = hdr.status
--                           and      sts.status_type in ('DEVELOPMENT', 'CURRENT')
--                           group by hdr.part_no) prt
--                  ,        specification_header hdr
--                  where    hdr.part_no = prt.part_no
--                  and      hdr.planned_effective_date >= prt.planned_effective_date)
--    loop
--      add_attachment
--        (p_hdr => r_hdr
--        ,p_prt => r_prt);
--    end loop;
--  end loop;
--end;
----
--procedure add_property
--  (p_property_group in pls_integer
--  ,p_property in pls_integer
--  ,p_property_rev in pls_integer
--  ,p_sequence_no in pls_integer
--  ,p_char_1 in varchar2
--  ,p_characteristic in pls_integer
--  ,p_association in pls_integer
----    ,p_value in varchar2
----    ,p_intl in varchar2
--  )
--is
--  l_idx pls_integer := v_spc.properties.count + 1;
--begin
--  if p_char_1 is not null
--  then
--    v_spc.properties(l_idx).part_no := v_spc.wts.wts_certificate;
--    v_spc.properties(l_idx).revision := 1;
--    v_spc.properties(l_idx).section_id := 700579;
--    v_spc.properties(l_idx).section_rev := 100;
--    v_spc.properties(l_idx).sub_section_id := 0;
--    v_spc.properties(l_idx).sub_section_rev := 100;
--    v_spc.properties(l_idx).property_group := p_property_group;
--    v_spc.properties(l_idx).property_group_rev := 100;
--    v_spc.properties(l_idx).property := p_property;
--    v_spc.properties(l_idx).property_rev := p_property_rev;
--    v_spc.properties(l_idx).attribute := 0;
--    v_spc.properties(l_idx).attribute_rev := 100;
--    v_spc.properties(l_idx).uom_rev := 0;
--    v_spc.properties(l_idx).test_method := 0;
--    v_spc.properties(l_idx).test_method_rev := 0;
--    v_spc.properties(l_idx).sequence_no := p_sequence_no;
--    v_spc.properties(l_idx).boolean_1 := 'N';
--    v_spc.properties(l_idx).boolean_2 := 'N';
--    v_spc.properties(l_idx).boolean_3 := 'N';
--    v_spc.properties(l_idx).boolean_4 := 'N';
--    --
--    if p_property = 703422
--    then
--      
--    dbms_output.put_line('Char 1: '||p_char_1);
--      select pas.association
--      ,      cas.characteristic
--      into   v_spc.properties(l_idx).association
--      ,      v_spc.properties(l_idx).characteristic
--      from   property_association pas
--      ,      association ass
--      ,      characteristic_association cas
--      ,      characteristic cha
--      where  pas.property = p_property
--      and    ass.association = pas.association
--      and    cas.association = ass.association
--      and    cha.characteristic_id = cas.characteristic
--      and    upper(cha.description) = upper(p_char_1);
--    else
--      v_spc.properties(l_idx).char_1 := p_char_1;
--      v_spc.properties(l_idx).characteristic := p_characteristic;
--      v_spc.properties(l_idx).association := p_association;
--    end if;
--    --
--    v_spc.properties(l_idx).characteristic_rev := 0;
--    --
--    if p_association > 0
--    then
--      v_spc.properties(l_idx).association_rev := 100;
--    else
--      v_spc.properties(l_idx).association_rev := 0;
--    end if;
--    --
--    v_spc.properties(l_idx).intl := 2;
--    v_spc.properties(l_idx).uom_alt_rev := 0;
--    v_spc.properties(l_idx).tm_det_1 := 'N';
--    v_spc.properties(l_idx).tm_det_2 := 'N';
--    v_spc.properties(l_idx).tm_det_3 := 'N';
--    v_spc.properties(l_idx).tm_det_4 := 'N';
--    v_spc.properties(l_idx).ch_rev_2 := 0;
--    v_spc.properties(l_idx).ch_rev_3 := 0;
--    v_spc.properties(l_idx).as_rev_2 := 0;
--    v_spc.properties(l_idx).as_rev_3 := 0;
--  end if;
--end;
----
--procedure set_spec
--  (p_wts in watson_certificates%rowtype)
--is
--begin
--  v_spc := null;
--  v_spc.wts := p_wts;
--  --
--  if p_wts.wts_status = 'INSERT'
--  then
--    v_spc.description := p_wts.wts_description;
--    --
--    add_keyword(700426, 'Certificate', 0);
--    add_keyword(700751, p_crt.crt_type, 1);
--    add_keyword(700752, p_wts.wts_section_width, 1);
--    add_keyword(700753, p_wts.wts_aspect_ratio, 1);
--    add_keyword(700754, p_wts.wts_rim_size, 1);
--    add_keyword(700755, p_wts.wts_product_line, 1);
--    --
--    add_objects;
--    --
--    add_section(701095, 6,                        0,   0, null, null, 'Y', 300,   null, 2, 0, null);
--    --
--    for i in 1..v_spc.objects.count
--    loop
--      add_section(701095, 6, v_spc.objects(i).obj_oih.object_id,   1,    2,    0, 'N', 300 + i,   null, 0, 0,    1);
--    end loop;
--    --
--    add_section(700579, 1,                   701563, 100, null, null, 'N', 100, 700929, 2, 4, null);
--    add_section(700579, 1,                   701569, 100, null, null, 'N', 200, 700930, 2, 2, null);
--    --
--    add_property(701569, 703417, 301,  700, p_wts.wts_aspect_ratio    , null, null);
--    add_property(701569, 703423, 301,  800, p_wts.wts_rim_size        , null, null);
--    add_property(701569, 703424, 301,  600, p_wts.wts_section_width   , null, null);
--    add_property(701563, 703422, 301,  100, p_wts.wts_new_product_line, null, null); -- Productline
--  end if;
--  --
--  add_attachments;
--end;
----
--procedure test_spec
--  (p_unid in varchar2 default '8A930BAEE8F27150C125824B00275CA3') --'7B8CAAB32F1BDC24C1257C0B002DA16D')
--is
--  r_wts watson_certificates%rowtype;
--begin
--  select *
--  into   r_wts
--  from   watson_certificates crt
--  where  wts.wts_unid = p_unid;
--  --
--  set_spec
--    (p_wts => r_wts);
--  --
--  v_spc.attachments.delete;
--  --
----  for r_hdr in (select   hdr.*
----                from     specification_header hdr
----                where    hdr.part_no = 'XEF_W255/60R18USAQ')
----  loop
----    add_attachment
----      (p_hdr => r_hdr);
----  end loop;
--end;
----
--procedure add_spec
--is
--  r_prt part%rowtype;
--  r_hdr specification_header%rowtype;
--  l_obj r_obj;
--begin
--  begin
--    if iapigeneral.setconnection('INTERSPC') = 0
--    then
--      if v_spc.wts.wts_status = 'INSERT'
--      then
--        r_prt.part_no := v_spc.wts.wts_certificate;
--        r_prt.description := v_spc.description;
--        r_prt.base_uom := 'pcs';
--        r_prt.part_source := 'I-S';
--        r_prt.part_type := 700309;
--        r_prt.obsolete := 0;
--        --
--        r_hdr.revision := 1;
--        r_hdr.status := 4;
--        r_hdr.phase_in_tolerance := 0;
--        r_hdr.created_by := 'INTERSPC';
--        r_hdr.last_modified_by := 'INTERSPC';
--        r_hdr.frame_id := 'A_PCR_Certificate';
--        r_hdr.frame_rev := 3;
--        r_hdr.access_group := 1;
--        r_hdr.workflow_group_id := 270;
--        r_hdr.class3_id := 700309;
--        r_hdr.owner := 1;
--        r_hdr.frame_owner := 1;
--        r_hdr.intl := 0;
--        r_hdr.multilang := 1;
--        r_hdr.uom_type := 0;
--        r_hdr.ped_in_sync := 'Y';
----        r_hdr.linked_to_tc := 0;
----        r_hdr.tc_in_progress := 0;
--        --
--        r_hdr.part_no := r_prt.part_no;
--        r_hdr.description := r_prt.description;
--        r_hdr.planned_effective_date := trunc(sysdate);
--        r_hdr.status_change_date := sysdate;
--        r_hdr.created_on := sysdate;
--        r_hdr.last_modified_on := sysdate;
--        --
--        insert into part
--        values r_prt;
--        --
--        for i in 1..v_spc.objects.count
--        loop
--          l_obj := v_spc.objects(i);
--          dbms_output.put_line('-- '||v_spc.objects(i).obj_oih.object_id);
--          dbms_output.put_line('-- '||v_spc.objects(i).obj_oid.file_name);
--          --
--          insert into itoid
--          values l_obj.obj_oid;
--          --
--          insert into itoiraw
--          values l_obj.obj_oiraw;
--          --
--          insert into itoih
--          values l_obj.obj_oih;
--          --
--          update itoih ith
--          set    ith.lang_id = 1
--          where  ith.object_id = v_spc.objects(i).obj_oih.object_id
--          and    ith.owner = v_spc.objects(i).obj_oih.owner
--          and    ith.lang_id = 0;
--        end loop;
--        --
--        insert into specification_header
--        values r_hdr;
--        --
--        for i in 1..v_spc.keywords.count
--        loop
--          insert into specification_kw
--          values v_spc.keywords(i);
--        end loop;
--        --
--        for i in 1..v_spc.sections.count
--        loop
--          insert into specification_section
--          values v_spc.sections(i);
--        end loop;
--      end if;
--      --
--      for i in 1..v_spc.properties.count
--      loop
--        begin
--          dbms_output.put_line('Prop: '||v_spc.properties(i).part_no||' - '||v_spc.properties(i).revision||' - '||v_spc.properties(i).section_id||' - '||v_spc.properties(i).sub_section_id||' - '||v_spc.properties(i).property_group||' - '||v_spc.properties(i).property);
--          --
--          insert into specification_prop
--          values v_spc.properties(i);
--        exception
--          when dup_val_on_index
--          then
--            dbms_output.put_line('Prop: '||v_spc.properties(i).part_no||' - '||v_spc.properties(i).revision||' - '||v_spc.properties(i).section_id||' - '||v_spc.properties(i).sub_section_id||' - '||v_spc.properties(i).property_group||' - '||v_spc.properties(i).property);
--            dbms_output.put_line(sqlerrm);
--        end;
--      end loop;
--      --
--      for i in 1..v_spc.attachments.count
--      loop
--        insert into attached_specification
--        values v_spc.attachments(i);
--      end loop;
--      --
--      update watson_certificates crt
--      set    crt.wts_status = v_spc.wts.wts_status||'ED'
--      where  crt.wts_unid = v_spc.wts.wts_unid;
--      --
--      commit;
--    end if;
--  exception
--    when others
--    then
--      rollback;
--      --
--      dbms_output.put_line(sqlerrm);
--  end;
--end;
----
--procedure add_specs
--is
--begin                     
----  for r_wts in (select *
----                from  (select *
----                       from   watson_certificates crt
----                       where  crt.wts_certificate is not null
----                       and    crt.wts_description is not null
----                       and    crt.wts_status is null
----                       and    exists (select 1
----                                      from   watson_certificate_parts prt
----                                      where  prt.prt_wts_dockey = crt.wts_dockey)
----                       and    not exists (select 1
----                                          from   part par
----                                          where  par.part_no = crt.wts_certificate)
----                       order by crt.wts_unid)
----                --where  rownum < 16
----                )         
--  for r_wts in (select   *
--                from     watson_certificates crt
--                where    crt.wts_status = 'ATTACH'
--                and      crt.wts_parent_certificate is null
--                order by crt.wts_unid)
--  loop
--    set_spec
--      (p_wts => r_wts);
--    --
--    dbms_output.put_line('-- ADD -- '||v_spc.wts.wts_certificate);
--    --
--    add_spec;
--  end loop;
--end;
----
--procedure del_spec
--is
--begin
--  if iapigeneral.setconnection('INTERSPC') = 0
--  then
--    delete attached_specification
--    where  attached_part_no = v_spc.wts.wts_certificate;
--    --
--    delete specification_section
--    where  part_no = v_spc.wts.wts_certificate;
--    --
--    for i in 1..v_spc.objects.count
--    loop
--      update itoid iid
--      set    iid.status = 1
--      where  iid.object_id = v_spc.objects(i).obj_oiraw.object_id;
--      --
--      delete itoiraw
--      where  object_id = v_spc.objects(i).obj_oiraw.object_id;
--      --
--      delete itoih
--      where  object_id = v_spc.objects(i).obj_oiraw.object_id;
--      --
--      delete itoid
--      where  object_id = v_spc.objects(i).obj_oiraw.object_id;
--    end loop;
--    --
--    delete specification_kw
--    where  part_no = v_spc.wts.wts_certificate;
--    --
--    delete specification_kw_h
--    where  part_no = v_spc.wts.wts_certificate;
--    --
--    for i in 1..v_spc.properties.count
--    loop
--      delete specification_prop
--      where  part_no = v_spc.properties(i).part_no
--      and    revision = v_spc.properties(i).revision
--      and    property_group = v_spc.properties(i).property_group
--      and    property = v_spc.properties(i).property
--      and    attribute = v_spc.properties(i).attribute
--      and    section_id = v_spc.properties(i).section_id
--      and    sub_section_id = v_spc.properties(i).sub_section_id;
--    end loop;
--    --
--    delete specification_header
--    where  part_no = v_spc.wts.wts_certificate;
--    --
--    delete part_plant
--    where  part_no = v_spc.wts.wts_certificate;
--    --
--    delete part
--    where  part_no = v_spc.wts.wts_certificate;
--    --
--    delete itschs
--    where  part_no = v_spc.wts.wts_certificate;
--    --
--    update watson_certificates crt
--    set    crt.wts_status = 'DELETED'
--    where  crt.wts_unid = v_spc.wts.wts_unid;
--    --
--    commit;
--  end if;
--end;
----
--procedure del_specs
--is
--begin
--  for r_wts in (select crt.*
--                from   specification_header hdr
--                ,      watson_certificates crt
--                where  hdr.created_by = 'INTERSPC'
--                and    trunc(hdr.created_on) = to_date('20180504', 'yyyymmdd')
--                and    crt.wts_certificate = hdr.part_no
----                and    hdr.part_no = 'E4-117R-023651'
--                --group by hdr.part_no
--                and    crt.wts_status = 'INSERTED')
--  loop
--
----  for r_wts in (select *
----                from   watson_certificates crt
----                where  crt.wts_unid = 'B15823FAB1159F78C1257C32002AEBB4')
----  loop
--
--
----  for r_wts in (select *
----                from   watson_certificates crt
----                where  crt.wts_status = 'INSERTED')
----  loop
--    set_spec
--      (p_wts => r_wts);
--    --
--    del_spec;
--    --
--    commit;
--  end loop;
--end;
----
--function encode
--  (p_value in varchar2)
--   return varchar2
--is
--  l_value varchar2(32767) := p_value;
--begin
--  if l_value is not null
--  then
--    l_value := trim(replace(replace(replace(replace(l_value, chr(10)), chr(11)), chr(13)), ' '));
--    l_value := replace(utl_raw.cast_to_varchar2(utl_encode.base64_decode(utl_raw.cast_to_raw(l_value))), chr(0));
--  end if;
--  --
--  return l_value;
--end;
----
--function xml_unescape
--  (p_value in varchar2)
--   return varchar2
--is
--begin
--  return replace(replace(replace(replace(replace(replace(p_value, '&amp;', '&'), '&quot;', '"'), '&apos;', ''''), '&lt;', '<'), '&gt;', '>'), '&#x2F;', '/');
--end;
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
----
--function update_document
--  (p_library in varchar2
--  ,p_unid in varchar2
--  ,p_version in varchar2
--  ,p_response in varchar2
--  ,p_link in varchar2
--  ,p_error in boolean)
--   return clob
--is
--  l_clob clob;
--  l_param varchar2(32767);
--  l_url varchar2(32767);
--begin
--  l_param := 'Action=UPDATE&Unid='||p_unid||'&Version='||p_version||'&Response='||utl_url.escape(p_response)||'&Link='||utl_url.escape(p_link);
--  --
--  if p_error
--  then
--    l_param := l_param||'&Error=Y';
--  end if;
--  --
--  l_url := 'http://'||v_username||':'||v_password||'@'||v_server||'/docova/'||p_library||'/UnilabDocumentAgent?OpenAgent&'||l_param;
--  dbms_output.put_line(l_url);
--  v_site := usr_http.request_pieces('http://'||v_username||':'||v_password||'@'||v_server||'/docova/'||p_library||'/UnilabDocumentAgent?OpenAgent&'||l_param);
--  --
--  for i in 1..v_site.count
--  loop
--    l_clob := l_clob||v_site(i);
--    dbms_output.put_line(v_site(i));
--  end loop;
--  --
--  return l_clob;
--end;
----
--function get_crt_type
--  (p_name in varchar2)
--   return pls_integer
--is
--begin
--  return v_crt(p_name).crt_property;
--exception
--  when others
--  then
--    return null;
--end;
----
--function get_crt_type_rev
--  (p_name in varchar2)
--   return pls_integer
--is
--begin
--  return v_crt(p_name).crt_property_rev;
--exception
--  when others
--  then
--    return null;
--end;
----
--procedure update_watson
--is
--begin
--  update watson_certificate_parts prt
--  set    prt.prt_week_validity = lpad(prt.prt_week_validity, 4, '0')
--  where  prt.prt_week_validity is not null
--  and    replace(translate(prt.prt_week_validity, '123456789', '000000000'), '0') is null
--  and    length(prt.prt_week_validity) = 3;
--  --
--  commit;
--end;
----
--procedure equalize_spec_properties
--is
--begin
--  for r_prp in (select   prp.part_no
--                ,        prp.revision
--                ,        sts.sort_desc
--                ,        prp.property_group
--                ,        prp.property
--                ,        prp.attribute
--                ,        prp.section_id
--                ,        prp.sub_section_id
--                ,        prt.prt_sidewall_plates
--                ,        prp.char_1
--                ,        prt.prt_current_validity
--                ,        prp.char_2
--                ,        prt.prt_week_validity
--                ,        prp.char_4
--                ,        crt.wts_certificate
--                ,        prp.char_6
--                ,        prt.prt_sidewall_marking
--                ,        prp.char_3
--                ,        prt.prt_remarks
--                ,        prp.char_5
--                ,        decode(prt.prt_tyre_sticker, 'Y', 900484, 'N', 900485) prt_tyre_sticker
--                ,        prp.characteristic
--                from     watson_certificates crt
--                ,        watson_certificate_parts prt
--                ,        specification_header hdr
--                ,        specification_prop prp
--                ,        status sts
--                where    crt.wts_status is not null --= 'INSERTED'
--                and      prt.prt_wts_dockey = crt.wts_dockey
--                and      hdr.part_no = prt.prt_no
--                and      sts.status_type in ('CURRENT', 'DEVELOPMENT')
--                and      hdr.status = sts.status
--                and      prp.part_no = hdr.part_no
--                and      prp.revision = hdr.revision
--                and      prp.section_id = 701095
--                and      prp.property_group = 700696
--                and      prp.property = apao_watson_2.get_crt_type(crt.wts_new_certificate_type)
--                and      prp.property_rev = apao_watson_2.get_crt_type_rev(crt.wts_new_certificate_type)
--                and      prt.prt_sidewall_plates||'@'||prt.prt_current_validity||'@'
--                       ||prt.prt_week_validity||'@'||crt.wts_certificate||'@'
--                       ||prt.prt_sidewall_marking||'@'||prt.prt_remarks||'@'||decode(prt.prt_tyre_sticker, 'Y', 900484, 'N', 900485)
--                         <>
--                         prp.char_1||'@'||prp.char_2||'@'
--                       ||prp.char_4||'@'||prp.char_6||'@'
--                       ||prp.char_3||'@'||prp.char_5||'@'||prp.characteristic
--                order by prp.part_no
--                ,        prp.revision)
--  loop
--    update specification_prop prp
--    set    prp.char_1 = r_prp.prt_sidewall_plates
--    ,      prp.char_2 = r_prp.prt_current_validity
--    ,      prp.char_4 = r_prp.prt_week_validity
--    ,      prp.char_6 = r_prp.wts_certificate
--    ,      prp.char_3 = r_prp.prt_sidewall_marking
--    ,      prp.char_5 = r_prp.prt_remarks
--    ,      prp.characteristic = r_prp.prt_tyre_sticker
--    where  prp.part_no = r_prp.part_no
--    and    prp.revision = r_prp.revision
--    and    prp.property_group = r_prp.property_group
--    and    prp.property = r_prp.property
--    and    prp.attribute = r_prp.attribute
--    and    prp.section_id = r_prp.section_id
--    and    prp.sub_section_id = r_prp.sub_section_id;
--    --
--    commit;
--  end loop;
--end;
----
--procedure equalize_certificate_keywords
--is
--  procedure update_kyw
--    (p_part_no in varchar2
--    ,p_id in number
--    ,p_value in varchar2)
--  is
--  begin
--    update specification_kw kyw
--    set    kyw.kw_value = p_value
--    where  kyw.part_no = p_part_no
--    and    kyw.kw_id = p_id;
--  end;
--begin
--  if iapigeneral.setconnection('INTERSPC') = 0
--  then
--    for r_kyw in (select   crt.wts_certificate
--                  ,        crt.wts_new_certificate_type
--                  ,        kw1.kw_value kw_certificate_type
--                  ,        decode(kw1.part_no, null, 'N', 'Y') kw1_exist
--                  ,        nvl(crt.wts_section_width, '<Any>') wts_section_width
--                  ,        kw2.kw_value kw_section_width
--                  ,        decode(kw2.part_no, null, 'N', 'Y') kw2_exist
--                  ,        nvl(crt.wts_aspect_ratio, '<Any>') wts_aspect_ratio
--                  ,        kw3.kw_value kw_aspect_ratio
--                  ,        decode(kw3.part_no, null, 'N', 'Y') kw3_exist
--                  ,        nvl(crt.wts_rim_size, '<Any>') wts_rim_size
--                  ,        kw4.kw_value kw_rim_size
--                  ,        decode(kw4.part_no, null, 'N', 'Y') kw4_exist
--                  ,        nvl(crt.wts_product_line, '<Any>') wts_product_line
--                  ,        kw5.kw_value kw_product_line
--                  ,        decode(kw5.part_no, null, 'N', 'Y') kw5_exist
--                  ,        'Certificate' wts_type
--                  ,        kw6.kw_value kw_type
--                  ,        decode(kw6.part_no, null, 'N', 'Y') kw6_exist
--                  from     watson_certificates crt
--                  ,        part prt
--                  ,        specification_kw kw1
--                  ,        specification_kw kw2
--                  ,        specification_kw kw3
--                  ,        specification_kw kw4
--                  ,        specification_kw kw5
--                  ,        specification_kw kw6
--                  where    crt.wts_status is not null
--                  and      prt.part_no = crt.wts_certificate
--                  and      kw1.part_no(+) = crt.wts_certificate
--                  and      kw1.kw_id(+) = 700751
--                  and      kw2.part_no(+) = crt.wts_certificate
--                  and      kw2.kw_id(+) = 700752
--                  and      kw3.part_no(+) = crt.wts_certificate
--                  and      kw3.kw_id(+) = 700753
--                  and      kw4.part_no(+) = crt.wts_certificate
--                  and      kw4.kw_id(+) = 700754
--                  and      kw5.part_no(+) = crt.wts_certificate
--                  and      kw5.kw_id(+) = 700755
--                  and      kw6.part_no(+) = crt.wts_certificate
--                  and      kw6.kw_id(+) = 700426
--                  and      crt.wts_new_certificate_type||chr(0)||
--                           crt.wts_section_width||chr(0)||
--                           crt.wts_aspect_ratio||chr(0)||
--                           crt.wts_rim_size||chr(0)||
--                           crt.wts_product_line||chr(0)||
--                           'Certificate'
--                           <>
--                           kw1.kw_value||chr(0)||
--                           replace(kw2.kw_value, '<Any>')||chr(0)||
--                           replace(kw3.kw_value, '<Any>')||chr(0)||
--                           replace(kw4.kw_value, '<Any>')||chr(0)||
--                           replace(kw5.kw_value, '<Any>')||chr(0)||
--                           kw6.kw_value)
--    loop
--      if r_kyw.wts_new_certificate_type <> r_kyw.kw_certificate_type
--      then
--        update_kyw(r_kyw.wts_certificate, 700751, r_kyw.wts_new_certificate_type);
--      end if;
--      --
--      if r_kyw.wts_section_width <> r_kyw.kw_section_width
--      then
--        update_kyw(r_kyw.wts_certificate, 700752, r_kyw.wts_section_width);
--      end if;
--      --
--      if r_kyw.wts_aspect_ratio <> r_kyw.kw_aspect_ratio
--      then
--        update_kyw(r_kyw.wts_certificate, 700753, r_kyw.wts_aspect_ratio);
--      end if;
--      --
--      if r_kyw.wts_rim_size <> r_kyw.kw_rim_size
--      then
--        update_kyw(r_kyw.wts_certificate, 700754, r_kyw.wts_rim_size);
--      end if;
--      --
--      if r_kyw.wts_product_line <> r_kyw.kw_product_line
--      then
--        update_kyw(r_kyw.wts_certificate, 700755, r_kyw.wts_product_line);
--      end if;
--      --
--      if r_kyw.kw6_exist = 'N'
--      then
--        insert into specification_kw
--        values
--          (r_kyw.wts_certificate
--          ,700426
--          ,r_kyw.wts_type
--          ,0);
--      else
--        if r_kyw.wts_type <> r_kyw.kw_type
--        then
--          update_kyw(r_kyw.wts_certificate, 700426, r_kyw.wts_type);
--        end if;
--      end if;
--      --
--  --    commit;
--    end loop;
--  end if;
--end;
----
--procedure new_certificate_frame
--is
--  r_prp specification_prop%rowtype;
--  r_sct specification_section%rowtype;
--  l_property pls_integer := 712394;
--  l_description varchar2(50) := 'E4-30R%';
--begin
--  if iapigeneral.setconnection('INTERSPC') = 0
--  then
--    for r_spc in (select hdr.*
--                  from   specification_header hdr
--                  ,      status sts
--                  where  hdr.frame_id = 'A_PCR_Certificate'
--                  and    hdr.frame_rev = 7
--                  and    hdr.description like l_description
--                  and    sts.status = hdr.status
--                  and    sts.status_type = 'DEVELOPMENT'
--                  and    exists (select 1
--                                 from   specification_prop prp
--                                 where  prp.part_no = hdr.part_no
--                                 and    prp.revision = hdr.revision
--                                 and    prp.section_id = 701095
--                                 and    prp.property_group = 700696
--                                 and    prp.property = l_property))
--    loop
--      select *
--      into   r_sct
--      from   specification_section spc
--      where  spc.part_no = r_spc.part_no
--      and    spc.revision = r_spc.revision
--      and    spc.ref_id = 700696
--      and    spc.section_id = 701095;
--      --
--      select *
--      into   r_prp
--      from   specification_prop prp
--      where  prp.part_no = r_spc.part_no
--      and    prp.revision = r_spc.revision
--      and    prp.section_id = 701095
--      and    prp.property_group = 700696
--      and    prp.property = l_property;
--      --
--      exit;
--    end loop;
--    --
--    for r_spc in (select hdr.*
--                  from   specification_header hdr
--                  ,      status sts
--                  where  hdr.frame_id = 'A_PCR_Certificate'
--                  and    hdr.frame_rev = 7
--                  and    hdr.description like l_description
--                  and    sts.status = hdr.status
--                  and    sts.status_type = 'DEVELOPMENT'
--                  and    not exists (select 1
--                                     from   specification_prop prp
--                                     where  prp.part_no = hdr.part_no
--                                     and    prp.revision = hdr.revision
--                                     and    prp.section_id = 701095
--                                     and    prp.property_group = 700696
--                                     and    prp.property = l_property))
--    loop
--      begin
--        r_sct.part_no := r_spc.part_no;
--        r_sct.revision := r_spc.revision;
--        --
--        insert into specification_section
--        values r_sct;
--        --
--        r_prp.part_no := r_spc.part_no;
--        r_prp.revision := r_spc.revision;
--        --
--        insert into specification_prop
--        values r_prp;
--        --
--        commit;
--      exception
--        when others
--        then
--          dbms_output.put_line(r_spc.part_no||' - '||sqlerrm);
--      end;
--    end loop;
--  end if;
--end;
----
--procedure clean_up_temp
--is
--begin
--  delete watson_temp tmp
--  where  tmp.tmp_varchar2_1 = 'SPECIFICATION'
--  and    replace(replace(tmp.tmp_varchar2_2, ';'), ' ') is null;
--  --
--  delete watson_temp tmp
--  where  tmp.tmp_varchar2_1 = 'SPECIFICATION'
--  and    not (   tmp.tmp_varchar2_2 like 'Duplicates;%'
--              or translate(tmp.tmp_varchar2_2, '012345678', '999999999') like '9;%');
--  --
--  commit;
--end;
----
--procedure specification_temp
--is
--  l_cll t_chr_int;
--begin
--  for r_spc in (select   *
--                from     watson_temp tmp
--                where    tmp.tmp_varchar2_1 = 'SPECIFICATION'
--                order by tmp.tmp_varchar2_2)
--  loop
--    if l_cll.count = 0
--    then
--      l_cll := string_to_array
--                 (p_string => r_spc.tmp_varchar2_2
--                 ,p_separator => ';');
--    else
--      null;
--    end if;
--  end loop;
--end;
--
function get_crt_property
  (p_type in varchar2)
   return pls_integer
is
begin
  return v_crt(p_type).crt_property;
end;
--
function get_crt_property_rev
  (p_type in varchar2)
   return pls_integer
is
begin
  return v_crt(p_type).crt_property_rev;
end;
--
procedure update_labels
  (p_part_no in varchar2 default null)
is
begin
  for r_prp in (select *
                from   watson_labels lbl
                ,      specification_prop prp
                where  lbl.lbl_part_no = nvl(p_part_no, lbl.lbl_part_no)
                and    lbl.lbl_type = 'WAVES'
                and    prp.part_no = lbl.lbl_part_no
                and    prp.section_id = 701095
                and    prp.property_group = lbl.lbl_property_group
                and    prp.property = lbl.lbl_property
                and    prp.num_1 is null)
  loop
    update specification_prop prp
    set    prp.num_1 = r_prp.lbl_value
    where  prp.part_no = r_prp.part_no
    and    prp.revision = r_prp.revision
    and    prp.section_id = r_prp.section_id
    and    prp.property_group = r_prp.property_group
    and    prp.property = r_prp.property;
  end loop;
  --
  for r_prp in (select *
                from   watson_labels lbl
                ,      specification_prop prp
                where  lbl.lbl_part_no = nvl(p_part_no, lbl.lbl_part_no)
                and    lbl.lbl_type = 'NOISE'
                and    prp.part_no = lbl.lbl_part_no
                and    prp.section_id = 701095
                and    prp.property_group = lbl.lbl_property_group
                and    prp.property = lbl.lbl_property
                and    prp.num_2 is null)
  loop
    update specification_prop prp
    set    prp.num_2 = r_prp.lbl_value
    where  prp.part_no = r_prp.part_no
    and    prp.revision = r_prp.revision
    and    prp.section_id = r_prp.section_id
    and    prp.property_group = r_prp.property_group
    and    prp.property = r_prp.property;
  end loop;
  --
  for r_lbl in (select *
                from   watson_labels lbl
                where  lbl.lbl_type in ('ROLLING', 'WET', 'TREAD', 'TRACTION', 'TEMP')
                and    lbl.lbl_association is null)
  loop
    begin
      select   cas.association
      ,        cas.characteristic
      into     r_lbl.lbl_association
      ,        r_lbl.lbl_characteristic
      from     property_association pas
      ,        association ass
      ,        characteristic_association cas
      ,        characteristic cha
      where    pas.property = r_lbl.lbl_property
      and      ass.association = pas.association
      and      cas.association = ass.association
      and      cha.characteristic_id = cas.characteristic
      and      cha.description = r_lbl.lbl_value;
      --
      update watson_labels lbl
      set    lbl.lbl_association = r_lbl.lbl_association
      ,      lbl.lbl_characteristic = r_lbl.lbl_characteristic
      where  lbl.lbl_part_no = r_lbl.lbl_part_no
      and    lbl.lbl_type = r_lbl.lbl_type
      and    lbl.lbl_property = r_lbl.lbl_property;
    exception
      when no_data_found
      then
        null;
    end;
  end loop;
  --
--                select *
--                from   watson_labels lbl
--                where  lbl.lbl_type in ('ROLLING', 'WET')
--                and    not exists (select 1
--                                   from   specification_prop prp
--                                   where  prp.part_no = lbl.lbl_part_no
--                                   and    prp.section_id = 701095
--                                   and    prp.property_group = lbl.lbl_property_group
--                                   and    prp.property = lbl.lbl_property)
  --
  for r_prp in (select *
                from   watson_labels lbl
                ,      specification_prop prp
                where  lbl.lbl_part_no = nvl(p_part_no, lbl.lbl_part_no)
                and    lbl.lbl_type in ('ROLLING', 'WET', 'TREAD', 'TRACTION', 'TEMP')
                and    prp.part_no = lbl.lbl_part_no
                and    prp.section_id = 701095
                and    prp.property_group = lbl.lbl_property_group
                and    prp.property = lbl.lbl_property
                and    prp.characteristic is null)
  loop
    update specification_prop prp
    set    prp.characteristic = r_prp.lbl_characteristic
    ,      prp.characteristic_rev = 100
    where  prp.part_no = r_prp.part_no
    and    prp.revision = r_prp.revision
    and    prp.section_id = r_prp.section_id
    and    prp.property_group = r_prp.property_group
    and    prp.property = r_prp.property;
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
end apao_watson_2;
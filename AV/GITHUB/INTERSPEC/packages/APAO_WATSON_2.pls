create or replace PACKAGE          APAO_WATSON_2 AS
--
-- Double keywords by specifications
--
--select   spc.spc_part_no
--,        kyw.kw_id
--,        min(kyw.kw_value)
--,        max(kyw.kw_value)
--,        count(0)
--from     watson_specifications spc
--,        specification_kw kyw
--where    kyw.part_no = spc.spc_part_no
--group by spc.spc_part_no
--,        kyw.kw_id
--having   count(0) > 1
--
-- Select all differences between certificate and spec properties
--
--select prp.part_no
--,      prp.revision
--,      prp.property_group
--,      prp.property
--,      prp.attribute
--,      prp.section_id
--,      prp.sub_section_id
--,      prt.prt_sidewall_plates
--,      prp.char_1
--,      prt.prt_current_validity
--,      prp.char_2
--,      prt.prt_week_validity
--,      prp.char_4
--,      crt.wts_certificate
--,      prp.char_6
--,      prt.prt_sidewall_marking
--,      prp.char_3
--,      prt.prt_remarks
--,      prp.char_5
--,      prt.prt_sidewall_plates||'@'||prt.prt_current_validity||'@'
--     ||prt.prt_week_validity||'@'||crt.wts_certificate||'@'
--     ||prt.prt_sidewall_marking||'@'||prt.prt_remarks prp_certificate
--,      prp.char_1||'@'||prp.char_2||'@'
--     ||prp.char_4||'@'||prp.char_6||'@'
--     ||prp.char_3||'@'||prp.char_5 prp_spec
--from   watson_certificates crt
--,      watson_certificate_parts prt
--,      specification_header hdr
--,      specification_prop prp
--,      status sts
--where  crt.wts_status = 'ATTACHED'
--and    prt.prt_wts_dockey = crt.wts_dockey
--and    hdr.part_no = prt.prt_no
--and    sts.status_type in ('CURRENT', 'DEVELOPMENT')
--and    hdr.status = sts.status
----and    prt.prt_no = 'EF_W215/55R17USAX'
--and    prp.part_no = hdr.part_no
--and    prp.revision = hdr.revision
--and    prp.section_id = 701095
--and    prp.property_group = 700696
--and    prp.property = apao_watson.get_crt_type(crt.wts_new_certificate_type)
--and    prp.property_rev = apao_watson.get_crt_type_rev(crt.wts_new_certificate_type)
--and    prt.prt_sidewall_plates||'@'||prt.prt_current_validity||'@'
--     ||prt.prt_week_validity||'@'||crt.wts_certificate||'@'
--     ||prt.prt_sidewall_marking||'@'||prt.prt_remarks <>
--       prp.char_1||'@'||prp.char_2||'@'
--     ||prp.char_4||'@'||prp.char_6||'@'
--     ||prp.char_3||'@'||prp.char_5


--
-- XEF_W255/60R18
type t_chr_int is table of varchar2(32767) index by binary_integer;
--
function fread_blob
  (p_path in varchar2
  ,p_filename in varchar2)
   return blob;
--
procedure add_labels;
--
procedure set_attachments
  (p_certificate in varchar2 default null
  ,p_part_no in varchar2 default null);
--
procedure set_attachment_sections;
--
procedure set_certificate_properties;
--
procedure set_brasil_specification_prop;
--
procedure set_specification_properties;
--
procedure set_development_to_current
  (p_part_no in varchar2 default null);
--
procedure set_certificate_keywords;
--
procedure set_certificate;
--
procedure add_certificate
  (p_certificate in varchar2 default null);
--
procedure del_certificate
  (p_certificate in varchar2);
--
procedure link_certificate
  (p_part_no in varchar2 default null);
--
procedure update_wts;
--
procedure update_certificates;
--
procedure update_specification;
--
--procedure test_spec
--  (p_unid in varchar2 default '8A930BAEE8F27150C125824B00275CA3');
----
--procedure add_spec;
----
--procedure del_spec;
----
--procedure add_specs;
----
--procedure del_specs;
----
--function escape_file
--  (p_name in varchar2)
--   return varchar2;
--
function get_file
  (p_unid in varchar2
  ,p_filename in varchar2
  ,p_username in varchar2 default null
  ,p_password in varchar2 default null)
   return blob;
----
--function get_crt_type
--  (p_name in varchar2)
--   return pls_integer;
----
--function get_crt_type_rev
--  (p_name in varchar2)
--   return pls_integer;
----
--procedure equalize_spec_properties;
----
--procedure equalize_certificate_keywords;
----
--procedure new_certificate_frame;
----
--procedure clean_up_temp;
----
--procedure specification_temp;
--
--begin
--  for r_prp in (select prt.*
--                ,      prp.*
--                from   watson_certificates crt
--                ,      watson_certificate_parts prt
--                ,      specification_prop prp
--                ,      specification_header hdr
--                ,      status sts
--                where  crt.wts_new_certificate_type = 'Brasil certificate (Inmetro)'
--                and    prt.prt_wts_dockey = crt.wts_dockey
--                and    prp.part_no = prt.prt_no
--                and    prp.section_id = 701095
--                and    prp.property_group = 700696
--                and    prp.property = 714114
--                and    prp.property_group_rev = 100
--                and    prp.section_rev = 100
--                and    hdr.part_no = prp.part_no
--                and    hdr.revision = prp.revision
--                and    sts.status = hdr.status
--                and    sts.status_type in ('CURRENT', 'DEVELOPMENT')
--                and    prp.char_6 = crt.wts_certificate
--                order by prp.part_no
--                ,        prp.revision)
--  loop
--    update specification_prop prp
--    set    prp.char_1 = r_prp.prt_sidewall_plates
--    ,      prp.char_2 = r_prp.prt_current_validity
--    ,      prp.char_3 = r_prp.prt_sidewall_marking
--    ,      prp.char_4 = r_prp.prt_week_validity
--    ,      prp.char_5 = r_prp.prt_remarks
--    ,      prp.characteristic = 900484
--    where  prp.part_no = r_prp.part_no
--    and    prp.revision = r_prp.revision
--    and    prp.property_group = r_prp.property_group
--    and    prp.property = r_prp.property
--    and    prp.attribute = r_prp.attribute
--    and    prp.section_id = r_prp.section_id
--    and    prp.sub_section_id = r_prp.sub_section_id;
--  end loop;
--end;
--
function get_crt_property
  (p_type in varchar2)
   return pls_integer;
--
function get_crt_property_rev
  (p_type in varchar2)
   return pls_integer;
--
--
procedure update_labels
  (p_part_no in varchar2 default null);
--
END APAO_WATSON_2;
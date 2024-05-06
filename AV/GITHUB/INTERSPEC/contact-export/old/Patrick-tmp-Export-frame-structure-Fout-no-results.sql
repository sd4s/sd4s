-- List the Frame structure like in Frame manager 
-- This one is with properties in correct ORDER, including UOM, associations and test methods
-- Attention: First run the two lines below to set the correct frame.
--Org-query PGO
set define on
define frame  = 'A_SteelComp v1';
--define frame  = 'E_SCW';
define status = 2  -- Current;


--select xmltype(cursor(
select fh.frame_no
,      fh.revision
,      fs.sequence_no
,      fs.section_sequence_no
,      fs.section_id
,      fs.section_rev
,      s.description   section_descr
,      fs.header Show_header
,      fs.mandatory
,      fs.intl
,      fs.sub_section_id
,      fs.sub_section_rev
,      ss.description   subsection_descr
,      fs.type
,      case when fs.type = 1 then 'Property Group'
            when fs.type = 2 then 'Reference Text'
            when fs.type = 3 then 'BOM'
            when fs.type = 4 then 'Single Property'
            when fs.type = 5 then 'Free Text'
            when fs.type = 6 then 'Object'
            when fs.type = 7 then 'Process Data'
            when fs.type = 8 then 'Attached Specification'
            when fs.type = 9 then 'Ingredient List'
            when fs.type = 10 then 'Base Name'
            else 'NULL'
       end fs_type
,      fs.ref_id
,      case when fs.type = 1
            then (select DBMS_LOB.SUBSTR( pg.description, 4000, 1) from property_group pg where pg.property_group=fs.ref_id)
            when fs.type = 4
            then (select DBMS_LOB.SUBSTR( p.description, 4000, 1) from property p where p.property=fs.ref_id)
            else NULL
       end spec_text
,      fs.display_format
,      fs.display_format_rev
,      l.description           layout_descr
,      fp.property_group
,      pg.description          prop_group_descr
,      fp.property
,      p.description           prop_desc
,      fp.mandatory            prop_Mandatory
,      fp.intl                 prop_intl
,      fp.test_method          prop_test_method_id
,      tm.description          prop_test_method
,      fp.uom_id               prop_uom_id
,      u.description           prop_uom
,      fp.sequence_no          prop_seq_no
,      fp.association          prop_ass1
,      a1.description          ass1_descr
,      fp.as_2                 prop_ass2
,      a2.description          ass2_descr
,      fp.as_3                 prop_ass3
,      a3.description          ass3_descr
from layout         l
,    sub_section   ss
,    section        s
,    property       p
,    property_group pg
,    frame_section fs
,    frame_prop    fp
,    frame_header  fh
,    test_method   tm
,    uom           u
,    association   a1
,    association   a2
,    association   a3
where fh.frame_no        = '&frame'  -- 'A_Man_RM_Fabric v1'
and fh.status            = 2 -- Current   
and fp.frame_no          = fh.frame_no   
and fp.revision          = fh.revision   
and fs.frame_no          = fh.frame_no   
and fs.revision          = fh.revision 
-- 
AND FS.TYPE IN (1,4) 
AND    (  (   fs.type = 1
          and fs.ref_id = fp.property_group )
       or (   fs.type = 4
          and fs.ref_id = fp.property )
       )
--
and pg.property_group(+) = fp.property_group
and p.property(+)        = fp.property
--
and fp.section_id        = fs.section_id
and fp.section_rev       = fs.section_rev
and fp.sub_section_id    = fs.sub_section_id
and fp.sub_section_rev   = fs.sub_section_rev
and s.section_id(+)      = fs.section_id   
and ss.sub_section_id(+) = fs.sub_section_id   
and l.layout_id(+)       = fs.display_format   
and l.revision(+)        = fs.display_format_rev   
and tm.test_method(+)    = fp.test_method
and u.uom_id(+)          = fp.uom_id
and a1.association(+)    = fp.association
and a2.association(+)    = fp.as_2
and a3.association(+)    = fp.as_3
UNION ALL
select fh.frame_no
,      fh.revision
,      fs.sequence_no
,      fs.section_sequence_no
,      fs.section_id
,      fs.section_rev
,      s.description   section_descr
,      fs.header Show_header
,      fs.mandatory
,      fs.intl
,      fs.sub_section_id
,      fs.sub_section_rev
,      ss.description   subsection_descr
,      fs.type
,      case when fs.type = 1 then 'Property Group'
            when fs.type = 2 then 'Reference Text'
            when fs.type = 3 then 'BOM'
            when fs.type = 4 then 'Single Property'
            when fs.type = 5 then 'Free Text'
            when fs.type = 6 then 'Object'
            when fs.type = 7 then 'Process Data'
            when fs.type = 8 then 'Attached Specification'
            when fs.type = 9 then 'Ingredient List'
            when fs.type = 10 then 'Base Name'
            else 'NULL'
       end fs_type
,      fs.ref_id
,      case 
            when fs.type = 2
            then (select DBMS_LOB.SUBSTR( rtt.description, 4000, 1) from ref_text_type rtt where rtt.ref_text_type=fs.ref_id and rtt.lang_id = 1)
            when fs.type = 5
            then (select DBMS_LOB.SUBSTR( tt.description, 4000, 1)  from text_type tt where tt.text_type = fs.ref_id)
            else NULL
       end spec_text
,      fs.display_format
,      fs.display_format_rev
,      l.description           layout_descr
,      NULL      property_group
,      ''        prop_group_descr
,      NULL      property
,      ''        prop_desc
,      ''        prop_Mandatory
,      NULL      prop_intl
,      NULL      prop_test_method_id
,      NULL      prop_test_method
,      NULL      prop_uom_id
,      NULL      prop_uom
,      NULL      prop_seq_no
,      NULL      prop_ass1
,      NULL      ass1_descr
,      NULL      prop_ass2
,      NULL      ass2_descr
,      NULL      prop_ass3
,      NULL      ass3_descr
from layout         l
,    sub_section   ss
,    section        s
,    frame_section fs
,    frame_header  fh
where fh.frame_no        = '&frame' -- 'A_Man_RM_Fabric v1'
and fh.status            = 2 -- Current   
and fs.type IN (2,3,5,6,8)
and fs.frame_no          = fh.frame_no   
and fs.revision          = fh.revision 
and s.section_id(+)      = fs.section_id   
and ss.sub_section_id(+) = fs.sub_section_id   
and l.layout_id(+)       = fs.display_format   
and l.revision(+)        = fs.display_format_rev   
--
order by 1,4, 3, prop_seq_no
--)).getClobVal() xdoc from dual
;  --- END frame structure export

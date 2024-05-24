/*
De statuscodes in de tabel Frame_Header zijn anders dan die in de tabel Status.
In Frame Header is de betekenis:1 - In Development2 - Current3 - Historic 
We moeten dus frame revision 101 hebben want die heeft status = 2 (Current).
--
Daarnaast is het ingewikkeld. Specs zijn ooit met een bepaald frame gemaakt maar 
het komt voor dat de betreffende frame revisie zelf helemaal niet meer bestaat.
Daarom zijn er volgens mij vergelijkbare tabellen voor het frame en de specificatie. 
Zoals frame_ en Specification header en frame-, en specification Prop.
Een nieuwe spec wordt aangemaakt ahv het dan geldende current frame. 
Maar vervolgens wordt de frame data ook lokaal bij de specificatie opgeslagen waardoor 
je later het frame niet meer nodig hebt om de specificatie te kunnen tonen.

Dit is hem geworden:
-- versie van Peter, revised by Patrick on 1-2-2023
--QUERY INCL. DISPLAY-FORMAT 
*/

select spr.part_no    part_no
, spr.revision        part_rev
, st.sort_desc        part_status
--, sh.frame_id         frame_id   -- Frame_id not really relevant for importing in Contact
--, sh.frame_rev        frame_rev  -- Frame_rev not really relevant for importing in Contact
--, s.section_id        section    -- Section_id not really relevant for importing in Contact
, sps.section_sequence_no sect_seq
, s.description     section_descr
--, ss.sub_section_id sub_section  -- Sub-section_id not really relevant for importing in Contact
, ss.description    sub_section_descr
--, pg.property_group prop_group   -- Property_Group_Id not really relevant for importing in Contact
, pg.description    prop_group_descr
, spr.sequence_no     seq
--, p.property        property     -- Property_id not really relevant for importing in Contact
, p.description     property_desc
, u.description     uom
, tm.description    test_method
, spr.num_1, spr.num_2, spr.num_3, spr.num_4, spr.num_5, spr.num_6, spr.num_7, spr.num_8, spr.num_9, spr.num_10
, spr.char_1, spr.char_2, spr.char_3, spr.char_4, spr.char_5, spr.char_6
, spr.boolean_1, spr.boolean_2, spr.boolean_3, spr.boolean_4
, spr.date_1, spr.date_2
, a.description     association
, c.description     characteristic
, spr.intl
, spr.info
, spr.uom_alt_id
, spr.uom_alt_rev
, spr.tm_det_1, spr.tm_det_2, spr.tm_det_3, spr.tm_det_4
, spr.tm_set_no
, a2.description ass2
, c2.description char2
, a3.description ass3
, c3.description char3
--, sps.frame_no        sps_frame  -- PG removed, not necesarry anymore
--, sps.revision        sps_rev
--, sps.section_id      sps_section
--, sps.sub_section_id  sps_sub_section
--, sps.ref_id          sps_ref_id
--, sps.type            sps_type
--, sps.display_format  sps_dispay_format  -- Display_Format_Id not really relevant for importing in Contact
, sps.display_format_rev sps_display_format_rev
, (SELECT DISTINCT l.description from layout l where (l.layout_id = sps.display_format and l.revision = sps.display_format_rev)) display_format_descr
from specification_prop   spr
,    specification_header sh
,    specification_section sps  -- PG ipv frame_section
,    status         st
,    section        s
,    sub_section    ss
,    property_group pg
,    property       p
--,    frame_section  sps    --is erbij gekomen
,    uom            u
,    test_method   tm
,    association    a
,    characteristic c
,    association    a2
,    characteristic c2
,    association    a3
,    characteristic c3
--where  sh.frame_id         = 'Global compound' 
   where sh.part_no = '120020BA' 
   and st.status_type       = 'CURRENT'
   and sh.status           = st.status
--   and sh.frame_id          = sps.frame_id  -- PG: Geen frame nodig
--   and sh.frame_rev         = sps.revision  -- PG: Geen frame nodig
--   and sh.revision in (select max(fh.revision) from frame_header fh where fh.frame_no = sps.frame_no and fh.status = 2 ) --CURRENT
   and sps.part_no  = sh.part_no   -- PG Toegevoegd, zoek in specification_section niet in frame_section
   and sps.revision = sh.revision  -- PG Toegevoegd, zoek in specification_section niet in frame_section
   and sps.section_id        = spr.section_id
   and sps.sub_section_id    = spr.sub_section_id
   AND (  (   sps.type = 1
          and sps.ref_id = spr.property_group )
          or (   sps.type = 4
             and sps.ref_id = spr.property )
          )
   and spr.part_no          = sh.part_no
   and spr.revision         = sh.revision
   and s.section_id         = spr.section_id
   and ss.sub_section_id(+) = spr.sub_section_id
   and pg.property_group(+) = spr.property_group
   and p.property(+)        = spr.property
   and u.uom_id(+)          = spr.uom_id
   and tm.test_method(+)    = spr.test_method
   and a.association(+)        = spr.association
   and c.characteristic_id(+)  = spr.characteristic
   and a2.association(+)       = spr.as_2
   and c2.characteristic_id(+) = spr.ch_2
   and a3.association(+)       = spr.as_3
   and c3.characteristic_id(+) = spr.ch_3
   order by spr.part_no, sps.section_sequence_no, pg.description, spr.sequence_no
;

/*
--
-- Show all sections and types within spec
select sh.part_no
, sh.revision
, ss.section_id
, s.description section
, sub.description sub_section
, ss.type
, ss.section_sequence_no
, ss.ref_id
from specification_header  sh
,    specification_section ss
,    status                st
,    section               s
,    sub_section sub    
where sh.frame_id         = 'A_RM_Polymer v1'
   and st.status_type      = 'CURRENT'
   and sh.status           = st.status
   and sh.part_no          = '120020BA'  
   and ss.part_no          = sh.part_no
   and ss.revision         = sh.revision
   and s.section_id        = ss.section_id
   and sub.sub_section_id(+)  = ss.sub_section_id
--   and ss.type =1
--   and ((ss.type             = 1
--        and ss.ref_id = pg.property_group
--        and pg.property_group = sp.property_group
--         )
--        or(ss.type             = 4
--        and ss.ref_id = p.property
--        and p.property = sp.property
--        )
--       )
  order by ss.section_sequence_no
   ;

--QUERY INCL. DISPLAY-FORMAT -- tbv Reference texts
select sh.part_no, sh.revision, st.sort_desc, ss.type, ss.ref_id, rt.text_revision, rt.text
  from specification_header sh, specification_section ss, status st, reference_text rt
where sh.frame_id         = 'A_RM_Polymer v1'
   and st.status_type      = 'CURRENT'
   and sh.status           = st.status
   and sh.part_no          = '120020BA'  
   and ss.part_no          = sh.part_no
   and ss.revision         = sh.revision
   and ss.type             = 2
   and rt.ref_text_type    = ss.ref_id
   and rt.text_revision    = ss.ref_Ver 
   ;

--QUERY INCL. DISPLAY-FORMAT -- tbv Free texts
select st.text, ss.ref_id
  from specification_header sh, specification_section ss, status stat, specification_text st
where sh.frame_id         = 'A_RM_Polymer v1'
   and stat.status_type    = 'CURRENT'
   and sh.status           = stat.status
   and sh.part_no          = '120020BA'  
   and ss.part_no          = sh.part_no
   and ss.revision         = sh.revision
   and ss.type             = 5
   and st.part_no          = ss.part_no
   and st.revision         = ss.revision
   and st.text_type        = ss.ref_id
   ;
*/

--SHOW DISPLAY-FORMAT OF TYPES = 2,5 
select sh.part_no
, sh.revision
, ss.section_id
, s.description section
, sub.description sub_section
, ss.type
, ss.section_sequence_no
, ss.ref_id
, case WHEN SS.TYPE = 2
       THEN (select rt.text from reference_text rt where rt.ref_text_type=ss.ref_id and rt.text_revision = ss.ref_ver )
       WHEN SS.TYPE = 5
       THEN (select spt.text from specification_text spt where spt.part_no = ss.part_no and spt.revision = ss.revision and spt.text_type=ref_id)	   
	   ELSE null
  end   spec_text
from specification_header  sh
,    specification_section ss
,    status                st
,    section               s
,    sub_section sub    
where sh.frame_id         = 'A_RM_Polymer v1'
   and st.status_type      = 'CURRENT'
   and sh.status           = st.status
   and sh.part_no          = '120020BA'  
   and ss.part_no          = sh.part_no
   and ss.revision         = sh.revision
   and s.section_id        = ss.section_id
   and sub.sub_section_id(+)  = ss.sub_section_id
  order by ss.section_sequence_no
   ;

--********************************************************
--COMBINATION OF 2 QUERIES
select spr.part_no        part_no
, spr.revision            part_rev
, st.sort_desc            part_status
, sps.section_sequence_no section_seq_no
, s.description           section_descr
, ss.description          sub_section_descr
, pg.description          prop_group_descr
, spr.sequence_no         seq
, p.description           property_desc
, u.description           uom
, tm.description          test_method
, spr.num_1, spr.num_2, spr.num_3, spr.num_4, spr.num_5, spr.num_6, spr.num_7, spr.num_8, spr.num_9, spr.num_10
, spr.char_1, spr.char_2, spr.char_3, spr.char_4, spr.char_5, spr.char_6
, spr.boolean_1, spr.boolean_2, spr.boolean_3, spr.boolean_4
, spr.date_1, spr.date_2
, a.description           association
, c.description           characteristic
, spr.intl
, spr.info
, spr.uom_alt_id
, spr.uom_alt_rev
, spr.tm_det_1, spr.tm_det_2, spr.tm_det_3, spr.tm_det_4
, spr.tm_set_no
, a2.description ass2
, c2.description char2
, a3.description ass3
, c3.description char3
, sps.type                 sps_type
, sps.display_format_rev   sps_display_format_rev
, (SELECT DISTINCT l.description from layout l where (l.layout_id = sps.display_format and l.revision = sps.display_format_rev)) display_format_descr
from specification_prop   spr
,    specification_header sh
,    specification_section sps  
,    status         st
,    section        s
,    sub_section    ss
,    property_group pg
,    property       p
,    uom            u
,    test_method   tm
,    association    a
,    characteristic c
,    association    a2
,    characteristic c2
,    association    a3
,    characteristic c3
--where  sh.frame_id         = 'Global compound' 
   where sh.part_no         = '120020BA' 
   and st.status_type       = 'CURRENT'
   and sh.status           = st.status
   and sps.part_no  = sh.part_no   
   and sps.revision = sh.revision  
   and sps.section_id        = spr.section_id
   and sps.sub_section_id    = spr.sub_section_id
   AND (  (   sps.type = 1
          and sps.ref_id = spr.property_group )
       or (   sps.type = 4
          and sps.ref_id = spr.property )
       )
   and spr.part_no          = sh.part_no
   and spr.revision         = sh.revision
   and s.section_id         = spr.section_id
   and ss.sub_section_id(+) = spr.sub_section_id
   and pg.property_group(+) = spr.property_group
   and p.property(+)        = spr.property
   and u.uom_id(+)          = spr.uom_id
   and tm.test_method(+)    = spr.test_method
   and a.association(+)        = spr.association
   and c.characteristic_id(+)  = spr.characteristic
   and a2.association(+)       = spr.as_2
   and c2.characteristic_id(+) = spr.ch_2
   and a3.association(+)       = spr.as_3
   and c3.characteristic_id(+) = spr.ch_3
UNION ALL
select sh.part_no
, sh.revision
, st.sort_desc            part_status
, sps.section_sequence_no section_seq_no
, s.description           section_descr
, sub.description         sub_section_descr
, to_char(null)           prop_group_descr
, null                    seq
, to_char(null)           property_desc
, to_char(null)           uom
, to_char(null)          test_method
, null num_1, null num_2, null num_3, null num_4, null num_5, null num_6, null num_7, null num_8, null num_9, null num_10
, to_char(null) char_1, to_char(null) char_2, to_char(null) char_3, to_char(null) char_4, to_char(null) char_5, to_char(null) char_6
, to_char(null) boolean_1, to_char(null) boolean_2, to_char(null) boolean_3, to_char(null) boolean_4
, to_date(null) date_1, to_date(null) date_2
, to_char(null) association
, to_char(null) characteristic
, to_char(null) intl
, to_char(null) info
, null uom_alt_id
, null uom_alt_rev
, to_char(null) tm_det_1, to_char(null) tm_det_2, to_char(null) tm_det_3, to_char(null) tm_det_4
, null tm_set_no
, to_char(null) ass2
, to_char(null) char2
, to_char(null) ass3
, to_char(null) char3
, sps.type
, sps.display_format_rev   sps_display_format_rev
, case WHEN SPS.TYPE = 2
       THEN (select DBMS_LOB.SUBSTR( rt.text, 4000, 1) from reference_text rt where rt.ref_text_type=sps.ref_id and rt.text_revision = sps.ref_ver )
       WHEN SPS.TYPE = 5
       THEN (select DBMS_LOB.SUBSTR( spt.text, 4000, 1)  from specification_text spt where spt.part_no = sps.part_no and spt.revision = sps.revision and spt.text_type = sps.ref_id)	   
	   ELSE null
  end   spec_text
from specification_header  sh
,    specification_section sps
,    status                st
,    section               s
,    sub_section sub    
--where sh.frame_id            = 'A_RM_Polymer v1'
  where st.status_type        = 'CURRENT'
   and sh.status             = st.status
   and sh.part_no            = '120020BA'  
   and sps.type in (2,5)
   and sps.part_no           = sh.part_no
   and sps.revision          = sh.revision
   and s.section_id          = sps.section_id
   and sub.sub_section_id(+) = sps.sub_section_id
order by 1, 3, 4
;



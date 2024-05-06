--dd. 13-07-2023: added a relation from PART-PLANT to SPECIFICATION-HEADER to ONLY select CORRECT-plant.
--                There are PART-PLANTS without a specification-header itself. How, we don't know. 
--                This will result in duplicate property-rows in query.
--dd. 21-09-2023: added SPECIFICATION_HEADER.ISSUED_DATE  tbv selectie voor gewijzigde SPECS/REVISIONS na datum 1April2023 oa. voor export raw-materials
--                      SPECIFICATION_PROPERTY.PROPERTY   tbv CONTACT voor import
--                      REASON.TEXT                       tbv audit-historie
--                      SPECIFICATION_PROPERTY/SECTION.SECTION_ID 
--                      SPECIFICATION_PROPERTY/SECTION.SUB_SECTION_ID
--                      SPECIFICATION_PROPERTY.UOM_ID 
--                      SPECIFICATION_PROPERTY.TEST_METHOD   (column aangepast, descr staat nu in TEST_METHOD_DESC)
--                      
--dd. 26-09-2023: remove restriction on PLANT=ENS/GYO, to EXPORT only RAW-MATERIALS with NO-relation to ENS/GYO. We forgot those in previous EXPORT.
--

CREATE OR REPLACE VIEW DBA_BHR_EXPORT_FRAME_SPEC
(  part_no
 , part_rev
 , part_description
 , frame_id
 , issued_date
 , status
 , part_status
 , part_status_type
 , Base_Uom
 , Base_Conv_Factor
 , part_plant
 , material_class_lvl0
 , material_class_lvl1
 , material_class_lvl2
 , Supplier
 , Supplier_Plant
 , Supplier_Trade_Name
 , section_seq_no
 , seq_no
 , section_id
 , section_descr
 , sub_section_id
 , sub_section_descr
 , sps_type2
 , Type_Descr
 , Type_descr_id 
 , Type_descr_Description   
 , property_group
 , property_group_desc
 , seq
 , property
 , property_desc
 , uom_id
 , uom
 , test_method
 , test_method_desc
 , num_1, num_2, num_3, num_4, num_5, num_6, num_7, num_8, num_9, num_10
 , char_1, char_2, char_3, char_4, char_5, char_6
 , boolean_1, boolean_2, boolean_3, boolean_4
 , date_1, date_2
 , attribute
 , association
 , association_desc
 , characteristic
 , characteristic_desc
 , intl
 , info
 , uom_alt_id
 , uom_alt_rev
 , tm_det_1, tm_det_2, tm_det_3, tm_det_4
 , tm_set_no
 , association2
 , association2_desc
 , characteristic2
 , characteristic2_desc
 , association3
 , association3_desc
 , characteristic3
 , characteristic3_desc
 , sps_type
 , sps_display_format
 , sps_display_format_rev
 , ref_id
 , DsplFrmt_Txt_AttSpc_Objct
 , Text_Rev
 , Reason_for_change
)
as
select sh.part_no         part_no
 , sh.revision            part_rev
 , sh.description         part_description
 , sh.frame_id 
 , sh.issued_date
 , sh.status
 , st.sort_desc            part_status
 , st.status_type          part_status_type
 , part.base_uom           Base_Uom
 , part.base_conv_factor   Base_Conv_Factor
 , pp.plant                part_plant
 , mc0.long_name           material_class_lvl0
 , mc1.long_name           material_class_lvl1
 , mc2.long_name           material_class_lvl2
 , mf.description          Supplier
 , mfp.description         Supplier_Plant
 , pmf.trade_name          Supplier_Trade_Name
 , sps.section_sequence_no section_seq_no
 , sps.sequence_no         seq_no
 , spr.section_id          section_id
 , s.description           section_descr
 , spr.sub_section_id      sub_section_id
 , ss.description          sub_section_descr
 , sps.type                type
 , case when sps.type = 1 then 'Property Group'
            when sps.type = 2 then 'Reference Text'
            when sps.type = 3 then 'BOM'
            when sps.type = 4 then 'Single Property'
            when sps.type = 5 then 'Free Text'
            when sps.type = 6 then 'Object'
            when sps.type = 7 then 'Process Data'
            when sps.type = 8 then 'Attached Specification'
            when sps.type = 9 then 'Ingredient List'
            when sps.type = 10 then 'Base Name'
            else 'NULL'
       end Type_Descr
, case when sps.type = 1
        THEN spr.property_group
        when sps.type = 4
        THEN spr.property
        ELSE NULL
      end  Type_descr_id     
, case when sps.type = 1
        THEN (select pg1.description from property_group pg1 where pg1.property_group = spr.property_group)
        when sps.type = 4
        THEN (select p1.description from property p1 where p1.property = spr.property)
        ELSE 'NULL'
      end  Type_descr_Description     
 , spr.property_group      property_group
 , pg.description          property_group_desc
 , spr.sequence_no         seq
 , spr.property            property
 , p.description           property_desc
 , spr.uom_id              uom_id
 , u.description           uom
 , spr.test_method         test_method
 , tm.description          test_method_desc
 , spr.num_1, spr.num_2, spr.num_3, spr.num_4, spr.num_5, spr.num_6, spr.num_7, spr.num_8, spr.num_9, spr.num_10
 , spr.char_1, spr.char_2, spr.char_3, spr.char_4, spr.char_5, spr.char_6
 , spr.boolean_1, spr.boolean_2, spr.boolean_3, spr.boolean_4
 , spr.date_1, spr.date_2
 , spr.attribute
 , spr.association         association
 , a.description           association_desc
 , spr.characteristic      characteristic
 , c.description           characteristic_desc
 , spr.intl
 , spr.info
 , spr.uom_alt_id
 , spr.uom_alt_rev
 , spr.tm_det_1, spr.tm_det_2, spr.tm_det_3, spr.tm_det_4
 , spr.tm_set_no
 , spr.as_2       association2
 , a2.description association2_desc
 , spr.ch_2       characteristic2
 , c2.description characteristic2_desc
 , spr.as_3       association3
 , a3.description association3_desc
 , spr.ch_3       characteristic3
 , c3.description characteristic3_desc
 , sps.type                 sps_type
 , sps.display_format       sps_display_format
 , sps.display_format_rev   sps_display_format_rev
 , sps.ref_id
 , (SELECT DISTINCT l.description from layout l where (l.layout_id = sps.display_format and l.revision = sps.display_format_rev)) DsplFrmt_Txt_AttSpc_Objct
 , null                      Text_Rev
 , r.text                    Reason_for_change
 from specification_header       sh
 join status                     st     on sh.status    = st.status
 join  specification_prop        spr    on spr.part_no  = sh.part_no and spr.revision = sh.revision
 join  part                             on part.part_no = sh.part_no
 left outer join  reason         r      on r.part_no    = sh.part_no and r.revision = sh.revision and r.text is not null and r.status_type='RI'
 join  part_plant                pp     on pp.part_no   = part.part_no  --and pp.plant in ('ENS','GYO')
 left outer join  itprcl         prc0   on prc0.part_no  = part.part_no AND prc0.hier_level = 0
 left outer join  itprcl         prc1   on prc1.part_no  = part.part_no AND prc1.hier_level = 1
 left outer join  itprcl         prc2   on prc2.part_no  = part.part_no AND prc2.hier_level = 2
 left outer join  material_class mc0    on mc0.identifier = prc0.matl_class_id 
 left outer join  material_class mc1    on mc1.identifier = prc1.matl_class_id 
 left outer join  material_class mc2    on mc2.identifier = prc2.matl_class_id 
 left outer join  itprmfc        pmf    on pmf.part_no  = sh.part_no
 left outer join  itmfc          mf     on mf.mfc_id    = pmf.mfc_id
 left outer join  itmpl          mfp    on mfp.mpl_id   = pmf.mpl_id
 join  specification_section     sps    on sps.part_no  = spr.part_no and sps.revision = spr.revision and  sps.section_id      = spr.section_id     and sps.sub_section_id = spr.sub_section_id
 join  section                   s      on s.section_id        = spr.section_id
 join  sub_section               ss     on ss.sub_section_id   = spr.sub_section_id
 left outer join property_group  pg     on pg.property_group   = spr.property_group
 left outer join property        p      on p.property          = spr.property
 left outer join uom             u      on u.uom_id            = spr.uom_id
 left outer join test_method     tm     on tm.test_method      = spr.test_method
 left outer join association     a      on a.association       = spr.association
 left outer join characteristic  c      on c.characteristic_id = spr.characteristic
 left outer join association     a2     on a2.association       = spr.as_2
 left outer join characteristic  c2     on c2.characteristic_id = spr.ch_2
 left outer join association     a3     on a3.association       = spr.as_3
 left outer join characteristic  c3     on c3.characteristic_id = spr.ch_3
 WHERE (  (   sps.type = 1 and sps.ref_id = spr.property_group )
       or (   sps.type = 4 and sps.ref_id = spr.property )
       )
UNION ALL
select sh.part_no         part_no
 , sh.revision            part_revision
 , sh.description         part_description
 , sh.frame_id
 , sh.issued_date
 , sh.status
 , st.sort_desc            part_status
 , st.status_type          part_status_type
 , part.base_uom           Base_Uom
 , part.base_conv_factor   Base_Conv_Factor
 , pp.plant                part_plant
 , mc0.long_name           material_class_lvl0
 , mc1.long_name           material_class_lvl1
 , mc2.long_name           material_class_lvl2
 , mf.description          Supplier
 , mfp.description         Supplier_Plant
 , pmf.trade_name          Supplier_Trade_Name
 , sps.section_sequence_no section_seq_no
 , sps.sequence_no         seq_no
 , sps.section_id          section_id
 , s.description           section_descr
 , sps.sub_section_id      sub_section_id
 , ss.description          sub_section_descr
 , sps.type                type
 ,     case when sps.type = 1 then 'Property Group'
            when sps.type = 2 then 'Reference Text'
            when sps.type = 3 then 'BOM'
            when sps.type = 4 then 'Single Property'
            when sps.type = 5 then 'Free Text'
            when sps.type = 6 then 'Object'
            when sps.type = 7 then 'Process Data'
            when sps.type = 8 then 'Attached Specification'
            when sps.type = 9 then 'Ingredient List'
            when sps.type = 10 then 'Base Name'
            else 'NULL'
       end   Type_Descr
, case      when sps.type = 2
            THEN sps.ref_id 
            when sps.type = 5
            THEN sps.ref_id
            ELSE NULL
   end Type_descr_id 
, case      when sps.type = 2
            THEN (select rtt2.description from ref_text_type rtt2 where rtt2.ref_text_type = sps.ref_id and lang_id = 1)
            when sps.type = 5
            THEN (select tt2.description from text_type tt2 where tt2.text_type = sps.ref_id)
            ELSE 'NULL'
   end Type_descr_Description 
 , null                    property_group
 , to_char(null)           property_group_desc
 , null                    seq
 , null                    property
 , to_char(null)           property_desc
 , null                    uom_id
 , to_char(null)           uom
 , null                    test_method
 , to_char(null)           test_method_desc
 , null num_1, null num_2, null num_3, null num_4, null num_5, null num_6, null num_7, null num_8, null num_9, null num_10
 , to_char(null) char_1, to_char(null) char_2, to_char(null) char_3, to_char(null) char_4, to_char(null) char_5, to_char(null) char_6
 , to_char(null) boolean_1, to_char(null) boolean_2, to_char(null) boolean_3, to_char(null) boolean_4
 , to_date(null) date_1, to_date(null) date_2
 , null          attribute
 , null          association
 , to_char(null) association_desc
 , null          characteristic
 , to_char(null) characteristic_desc
 , to_char(null) intl
 , to_char(null) info
 , null uom_alt_id
 , null uom_alt_rev
 , to_char(null) tm_det_1, to_char(null) tm_det_2, to_char(null) tm_det_3, to_char(null) tm_det_4
 , null tm_set_no
 , null          association2
 , to_char(null) association2_desc
 , null          characteristic2
 , to_char(null) characteristic2_desc
 , null          association3
 , to_char(null) association3_desc
 , null          characteristic3
 , to_char(null) characteristic3_desc
 , sps.type                 sps_type
 , sps.display_format       sps_display_format
 , sps.display_format_rev   sps_display_format_rev
 , sps.ref_id
 , case WHEN SPS.TYPE = 2
       THEN (select REGEXP_REPLACE( DBMS_LOB.SUBSTR( NVL(rt.text,'NULL'), 4000, 1), '[[:cntrl:]]', '#') 
	         from reference_text rt 
			 where rt.ref_text_type=sps.ref_id 
			 and rt.text_revision = sps.ref_ver 
			 and rt.lang_id = 1 )
       WHEN SPS.TYPE = 5
       THEN (select REGEXP_REPLACE( DBMS_LOB.SUBSTR( NVL(spt.text,'NULL'), 3990, 1), '[[:cntrl:]]', '#')  
	         from specification_text spt 
			 where spt.part_no = sps.part_no 
			 and spt.revision  = sps.revision 
			 and spt.text_type = sps.ref_id
			 and spt.section_id = sps.section_id
			 and spt.sub_section_id = sps.sub_section_id
             and spt.lang_id = 1 
            ) 								 
       WHEN SPS.TYPE = 6  -- Object
       THEN (select itoid.file_name  
	         from itoid 
			 where itoid.object_id = sps.ref_id 
			 and itoid.revision = sps.ref_ver 
			 and itoid.owner = sps.ref_owner)      
       WHEN SPS.TYPE = 8  -- Attached Specification
       THEN (select ass.attached_part_no  
	         from attached_specification ass 
			 where ass.part_no = sps.part_no 
			 and ass.revision = sps.revision 
			 and ass.ref_id = sps.ref_id 
			 and rownum = 1)      
       ELSE null
  end                  DsplFrmt_Txt_AttSpc_Objct    --was: spec_text
 , case when sps.type = 2  -- reference text
        THEN sps.ref_ver
        ELSE NULL
   end                 Text_Rev   
 , r.text              Reason_for_change
 from specification_header  sh
 join status  st                   on sh.status    = st.status
 join  specification_section sps   on sps.part_no = sh.part_no    and sps.revision    = sh.revision
 join  part                        on part.part_no = sh.part_no
 left outer join  reason  r         on r.part_no    = sh.part_no and r.revision = sh.revision and r.text is not null and r.status_type='RI'
 join  part_plant         pp       on pp.part_no   = part.part_no  --and pp.plant in ('ENS','GYO')
 left outer join  itprcl  prc0     on prc0.part_no  = part.part_no AND prc0.hier_level = 0
 left outer join  itprcl  prc1     on prc1.part_no  = part.part_no AND prc1.hier_level = 1
 left outer join  itprcl  prc2     on prc2.part_no  = part.part_no AND prc2.hier_level = 2
 left outer join  material_class mc0    on mc0.identifier = prc0.matl_class_id 
 left outer join  material_class mc1    on mc1.identifier = prc1.matl_class_id 
 left outer join  material_class mc2    on mc2.identifier = prc2.matl_class_id 
 join  section        s            on s.section_id        = sps.section_id
 join  sub_section    ss           on ss.sub_section_id   = sps.sub_section_id
 left outer join  itprmfc pmf      on pmf.part_no  = sh.part_no
 left outer join  itmfc   mf       on mf.mfc_id    = pmf.mfc_id
 left outer join  itmpl   mfp      on mfp.mpl_id   = pmf.mpl_id
 where sps.type        in (2,5,6,8)
;   
	   
	   
--TEST-QUERY
SELECT *
FROM DBA_BHR_EXPORT_FRAME_SPEC
--WHERE part_no='GF_2156517QPRNV' and part_rev=16
WHERE part_no='GV_2156517QPRNV' AND PART_REV=16
;
	   
	   
	   
--einde script

	   
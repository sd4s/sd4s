-- List the Frame structure like in Frame manager
--******************************************************************************
--EXPORT VAN FRAMES INCL. PROPERTIES !!!!!!
--DEZE EXPORTEREN WE VANUIT SQL*DEVELOPER, EN COPY/PASTE NAAR EXCEL TOE. 
--DIT DOEN WE HANDMATIG PER FRAME
--WE MAKEN GEEN GEBRUIK VAN XML-EXPORT !!!! IS (NOG) NIET NODIG IN DIT GEVAL...
--******************************************************************************

/*
select property from frame_prop fp where fp.frame_no = 'A_Man_RM_Fabric v1' and fp.revision=19 and property_group = 700630;
select * from frame_section fs where fs.frame_no = 'A_Man_RM_Fabric v1' and fs.revision=19 and fs.type=5;
select fp.section_id, fp.section_rev, fp.sub_section_id, fp.sub_section_rev, fp.property_group, fp.property , fs.ref_id
from frame_prop fp, frame_section fs 
where fp.frame_no = 'A_Man_RM_Fabric v1' and fp.revision=19 
and fp.frame_no = fs.frame_no and fp.revision = fs.revision 
and fp.section_id = fs.section_id AND fp.section_rev = fs.section_rev 
and fp.sub_section_id = fs.sub_section_id and fp.sub_section_rev=fs.sub_section_rev 
and fs.type=1
order by 1,3,5,6
;
*/


/*
dd. 06-06-2023:		Frames		A_TextComp v1 (13)
								A_Steelcomp v1 (18)   
*/

--***************************************
--EXPORT: COLUMN-HEADER-REGELS !!!!!!!
--***************************************
select 'frame_no'
,      'revision'
,      'section_sequence_no'
,      'section_id'
,      'section_rev'
,      'section_descr'
,      'Show_header'
,      'mandatory'
,      'intl'
,      'sub_section_id'
,      'sub_section_rev'
,      'subsection_descr'
,      'type'
,      'fs_type'
,      'ref_id'
,      'spec_text'
,      'display_format'
,      'display_format_rev'
,      'layout_descr'
,      'property_group'
,      'prop_group_descr'
,      'property'
,      'property_desc'
,      'prop_seq_no'
FROM DUAL;

--***************************************
--EXPORT: EN BIJBEHORENDE DATA-REGELS !!!!!!!
--***************************************
select fh.frame_no
,      fh.revision
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
,      p.description           property_desc
,      fp.sequence_no          prop_seq_no
from layout         l
,    sub_section   ss
,    section        s
,    property       p
,    property_group pg
,    frame_section fs
,    frame_prop    fp
,    frame_header  fh
where fh.frame_no        = 'A_Steelcomp v1'   --'A_Man_RM_Fabric v1'
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
UNION ALL
select fh.frame_no
,      fh.revision
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
,      case when fs.type = 2
            then (select DBMS_LOB.SUBSTR( rtt.description, 4000, 1) from ref_text_type rtt where rtt.ref_text_type=fs.ref_id)
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
,      ''        property_desc
,      NULL      prop_seq_no
from layout         l
,    sub_section   ss
,    section        s
,    frame_section fs
,    frame_header  fh
where fh.frame_no        = 'A_Steelcomp v1'  --'A_Man_RM_Fabric v1'
and fh.status            = 2 -- Current   
and fs.type IN (2,5)
and fs.frame_no          = fh.frame_no   
and fs.revision          = fh.revision 
and s.section_id(+)      = fs.section_id   
and ss.sub_section_id(+) = fs.sub_section_id   
and l.layout_id(+)       = fs.display_format   
and l.revision(+)        = fs.display_format_rev   
--
order by section_sequence_no , sub_section_id, property_group, prop_seq_no
;


--Org-query PGO
/*
select fh.frame_no
,      fh.revision
,      fs.section_sequence_no
,      fs.section_id
,      fs.section_rev
,      s.description
,      fs.header Show_header
,      fs.mandatory
,      fs.intl
,      fs.sub_section_id
,      fs.sub_section_rev
,      ss.description
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
            when fs.type = 2
            then (select DBMS_LOB.SUBSTR( rtt.description, 4000, 1) from ref_text_type rtt where rtt.ref_text_type=fs.ref_id)
            when fs.type = 4
            then (select DBMS_LOB.SUBSTR( p.description, 4000, 1) from property p where p.property=fs.ref_id)
            when fs.type = 5
            then (select DBMS_LOB.SUBSTR( tt.description, 4000, 1)  from text_type tt where tt.text_type = fs.ref_id)
            else NULL
       end spec_text
,      fs.display_format
,      fs.display_format_rev
,      l.description
from layout         l
,    sub_section   ss
,    section        s
,    frame_section fs
,    frame_header  fh
where fh.frame_no        = 'A_Man_RM_Fabric v1'
and fh.status            = 2 -- Current   
and fs.frame_no          = fh.frame_no   
and fs.revision          = fh.revision 
--  
and s.section_id(+)      = fs.section_id   
and ss.sub_section_id(+) = fs.sub_section_id   
and l.layout_id(+)       = fs.display_format   
and l.revision(+)        = fs.display_format_rev   
order by fs.section_sequence_no   
;
*/

/*
A_Man_RM_Fabric v1	19	100		700577	Chemical and physical properties	            1	Y	2	0	(none)			Attached Specification	0			0	
A_Man_RM_Fabric v1	19	200		700577	Chemical and physical properties	            1	N	2	0	(none)			Single Property		712816	Shelf life								702048	2	IS_PROP_CHAR
A_Man_RM_Fabric v1	19	300		700577	Chemical and physical properties	            1	N	2	0	(none)			Property Group		704240	Fabric manufacturing information		704213	1	IS_PROP_Fabric info 2
A_Man_RM_Fabric v1	19	400		700577	Chemical and physical properties	            1	N	2	0	(none)			Property Group		700630	Warp cord characteristics				701650	1	IS_UOM_CHAR_REM_DF
A_Man_RM_Fabric v1	19	500		700577	Chemical and physical properties	            1	N	2	0	(none)			Property Group		703756	Fabric release parameters				703733	5	UNI_RAWM_DF_Testmethod_Sort
A_Man_RM_Fabric v1	19	600		700577	Chemical and physical properties	            1	N	2	0	(none)			Property Group		700629	Cord data dipped						703733	5	UNI_RAWM_DF_Testmethod_Sort
A_Man_RM_Fabric v1	19	700		700577	Chemical and physical properties	            1	N	2	0	(none)			Property Group		700633	Fabric after dipping					703733	5	UNI_RAWM_DF_Testmethod_Sort
A_Man_RM_Fabric v1	19	800		700577	Chemical and physical properties	            1	N	2	0	(none)			Property Group		703776	Untreated (Greige) Fabric weft yarn data (Guideline)	703768	1	IS_RAWM_DF_Testmethod_Sort
A_Man_RM_Fabric v1	19	900		700577	Chemical and physical properties	            1	N	2	0	(none)			Property Group		703757	Weft cord characteristics				701650	1	IS_UOM_CHAR_REM_DF
A_Man_RM_Fabric v1	19	1000	700577	Chemical and physical properties	            1	N	2	0	(none)			Property Group		703759	Adhesion samples preparation condition	703749	3	IS_PROP_CHAR1_CHAR2_NUM1_NUM2_NUM3_CHAR3
A_Man_RM_Fabric v1	19	1100	700577	Chemical and physical properties	            1	N	2	0	(none)			Free Text			703008	Compound for testing adhesion		0	
A_Man_RM_Fabric v1	19	1200	700577	Chemical and physical properties	            1	N	2	0	(none)			Free Text			703007	Fabric winding		0	
A_Man_RM_Fabric v1	19	1300	700577	Chemical and physical properties	            1	N	2	0	(none)			Property Group		703758	Fabric winding							703748	1	IS_PROP_CHAR1_CHAR2_CHAR3_CHAR4_CHAR5_CHAR6
A_Man_RM_Fabric v1	19	1400	700577	Chemical and physical properties	            1	N	2	0	(none)			Free Text			702526	Remarks		0	
A_Man_RM_Fabric v1	19	1500	700579	General information					            1	N	2	0	(none)			Free Text			702866	Special instructions (if any)		0	
A_Man_RM_Fabric v1	19	1600	701036	Plant information					            1	Y	2	700542	General		Property Group		704241	Approval status per region			704174	1	IS_Approval status
A_Man_RM_Fabric v1	19	1700	701036	Plant information					            1	N	1	700542	General		Property Group		704300	Approval status per plant			704174	1	IS_Approval status
A_Man_RM_Fabric v1	19	1800	701036	Plant information					            1	N	2	702343	Enschede	Property Group		700623	Controlplan fabrics					703968	2	IS_Controlplan_Testmethod 2
A_Man_RM_Fabric v1	19	1900	701036	Plant information					            1	N	2	702343	Enschede	Single Property		712796	Approval status raw material		701888	1	IS_PROP_ASS
A_Man_RM_Fabric v1	19	2000	701036	Plant information					            1	N	2	702346	Chennai		Property Group		700623	Controlplan fabrics					703968	2	IS_Controlplan_Testmethod 2
A_Man_RM_Fabric v1	19	2100	701036	Plant information					            1	N	2	702346	Chennai		Single Property		712796	Approval status raw material		701888	1	IS_PROP_ASS
A_Man_RM_Fabric v1	19	2200	701036	Plant information					            1	N	2	702345	Limda		Property Group		700623	Controlplan fabrics					703968	2	IS_Controlplan_Testmethod 2
A_Man_RM_Fabric v1	19	2300	701036	Plant information					            1	N	2	702345	Limda		Single Property		712796	Approval status raw material		701888	1	IS_PROP_ASS
A_Man_RM_Fabric v1	19	2400	701036	Plant information					            1	N	2	702348	Perambra	Property Group		700623	Controlplan fabrics					703968	2	IS_Controlplan_Testmethod 2
A_Man_RM_Fabric v1	19	2500	701036	Plant information					            1	N	2	702348	Perambra	Single Property		712796	Approval status raw material		701888	1	IS_PROP_ASS
A_Man_RM_Fabric v1	19	2600	701036	Plant information					            1	N	2	702347	Kalamassery	Property Group		700623	Controlplan fabrics					703968	2	IS_Controlplan_Testmethod 2
A_Man_RM_Fabric v1	19	2700	701036	Plant information					            1	N	2	702347	Kalamassery	Single Property		712796	Approval status raw material		701888	1	IS_PROP_ASS
A_Man_RM_Fabric v1	19	2800	701036	Plant information					            1	N	2	702342	Gyongyoshalasz	Property Group	700623	Controlplan fabrics					703968	2	IS_Controlplan_Testmethod 2
A_Man_RM_Fabric v1	19	2900	701036	Plant information					            1	N	2	702342	Gyongyoshalasz	Single Property	712796	Approval status raw material		701888	1	IS_PROP_ASS
A_Man_RM_Fabric v1	19	3000	701036	Plant information					            1	N	2	702344	Pune		Property Group		700623	Controlplan fabrics					703968	2	IS_Controlplan_Testmethod 2
A_Man_RM_Fabric v1	19	3100	701036	Plant information					            1	N	2	702344	Pune		Single Property		712796	Approval status raw material		701888	1	IS_PROP_ASS
A_Man_RM_Fabric v1	19	3200	701035	QESH								            1	N	2	0	(none)			Object				0			0	
A_Man_RM_Fabric v1	19	3300	701035	QESH								            1	N	2	0	(none)			Property Group		703738	Certification Q systems				703728	4	IS_PROP_ASS1_CHAR1_CHAR2_CERT
A_Man_RM_Fabric v1	19	3400	701035	QESH								            1	N	2	0	(none)			Property Group		703739	Reach								703729	1	IS_PROP_ASS1_ASS2_ASS3_CHAR1_reach
A_Man_RM_Fabric v1	19	3500	701035	QESH								            1	N	2	0	(none)			Property Group		704740	SVHC information					704815	2	IS_SVHC_Char6_Char1_Char2_Char3_Num1_Bool1
A_Man_RM_Fabric v1	19	3600	701155	New Vendor and raw material development request	1	N	2	0	(none)			Object				0			0	
A_Man_RM_Fabric v1	19	3700	701155	New Vendor and raw material development request	1	N	2	0	(none)			Single Property		714916	Originating department				703730	3	IS_PROP_CHAR_LONG
A_Man_RM_Fabric v1	19	3800	701155	New Vendor and raw material development request	1	N	2	0	(none)			Free Text			703087	Goal		0	
A_Man_RM_Fabric v1	19	3900	701155	New Vendor and raw material development request	1	N	2	0	(none)			Free Text			703086	Motivation		0	
A_Man_RM_Fabric v1	19	4000	701155	New Vendor and raw material development request	1	N	2	0	(none)			Property Group		701736	Product information					700930	2	IS_Single_Value_CHAR_DF
A_Man_RM_Fabric v1	19	4100	701155	New Vendor and raw material development request	1	N	2	0	(none)			Property Group		704421	Vendor information					703730	3	IS_PROP_CHAR_LONG
*/

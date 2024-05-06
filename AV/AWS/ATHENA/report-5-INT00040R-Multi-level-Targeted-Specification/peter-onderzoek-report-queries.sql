--REPORT:  int00040r_templatedsinglespec
--ONDERZOEK PART-NO QUERIES
--onderzoek: 'XGG_BF66A17J1'

-* Interspec globals
-INCLUDE INT00000P_db_config
-INCLUDE INT00000P_fieldTypes
 
-* BoM code
-INCLUDE INT00011P_defaults
-INCLUDE INT00011P0_preparePartList

-INCLUDE INT00040P_BoM
			::TABLE FILE SQLBOM
			SUM	PART_DESCRIPTION,	INDENTPART,	QUANTITY,	UOM,	WEIGHT,	WEIGHT_UOM
			--
			WITH
			-INCLUDE INT00011P2_BoM_explosion_SQL
			-INCLUDE INT00013P_BoM_template
			-INCLUDE INT00013P_BoM_filter
			SELECT f.*
			,	part.description AS part_description
			,	weight.weight, weight.uom AS weight_uom
			 FROM filtered f
			 LEFT JOIN	part                         ON (part.part_no   = f.part_no)
			 LEFT JOIN avspecification_weight weight ON (weight.part_no = f.part_no)
			ORDER BY f.hierarchy, f.functiongrp, f.item_number
			;
-INCLUDE INT00040P_Properties
		::SQLBOMPROPS
		WITH
			 templateParts (
				hierarchy
				, functionGrp
				, function_description
				, tpl_part_no
				, tpl_revision
				, part_no
				, revision
				, item_number
				, branch
		 ) AS 
		(
		-	INCLUDE INT00040H_TPLBOMPARTS                       --> BOM-FULL-QUERY !!!!!!!!! LIKE SQLBOM = filtered !!!!
		) 
		-INCLUDE INT00013P_BoM_templateProps
		WITH template AS (
         	SELECT t.tpl_part_no
			,   t.tpl_revision
         	,	sh.frame_id AS tpl_frame_id
         	,	sp.sequence_no, sp.section_id, sp.sub_section_id, sp.property_group, sp.property
         	,	fs.type
         	,	pl.layout_id, pl.field_id, pl.header_id
         	,	pl.start_pos AS tpl_start_pos
           	,	sp.num_1, sp.num_2, sp.num_3, sp.num_4, sp.num_5
         	,	sp.num_6, sp.num_7, sp.num_8, sp.num_9, sp.num_10
         	,	sp.char_1, sp.char_2, sp.char_3, sp.char_4, sp.char_5, sp.char_6
         	,	sp.date_1, sp.date_2
         	,	sp.boolean_1, sp.boolean_2, sp.boolean_3, sp.boolean_4
         	,	sp.characteristic, sp.ch_2, sp.ch_3
          	,	decode(pl.field_id
         		, &FT_NUM_1, sp.num_1
         		, &FT_NUM_2, sp.num_2
         		, &FT_NUM_3, sp.num_3
         		, &FT_NUM_4, sp.num_4
         		, &FT_NUM_5, sp.num_5
         		, &FT_NUM_6, sp.num_6
         		, &FT_NUM_7, sp.num_7
         		, &FT_NUM_8, sp.num_8
         		, &FT_NUM_9, sp.num_9
         		, &FT_NUM_10, sp.num_10
         		, NULL
         		) AS tpl_num
         	,	decode(pl.field_id
         		, &FT_CHAR_1, sp.char_1
         		, &FT_CHAR_2, sp.char_2
         		, &FT_CHAR_3, sp.char_3
         		, &FT_CHAR_4, sp.char_4
         		, &FT_CHAR_5, sp.char_5
         		, &FT_CHAR_6, sp.char_6
         		, NULL
         		) AS tpl_char
         	,	decode(pl.field_id
         		, &FT_DATE_1, sp.date_1
         		, &FT_DATE_2, sp.date_2
         		, NULL
         		) AS tpl_date
         	,	decode(pl.field_id
         		, &FT_BOOLEAN_1, sp.boolean_1
         		, &FT_BOOLEAN_2, sp.boolean_2
         		, &FT_BOOLEAN_3, sp.boolean_3
         		, &FT_BOOLEAN_4, sp.boolean_4
         		, NULL
         		) AS tpl_boolean
         	,	decode(pl.field_id
         		, &FT_ASSOCIATION_1, sp.characteristic
         		, &FT_ASSOCIATION_2, sp.ch_2
         		, &FT_ASSOCIATION_3, sp.ch_3
         		, NULL
         		) AS tpl_association
         	,	sp.uom_id AS tpl_uom_id
         	,	NULLIF(sp.test_method, 0) AS tpl_test_method
         	,	CASE WHEN pl.field_id = &FT_UOM THEN 0
                                                ELSE 1
         		END AS tpl_field_relevance_bit
         	  FROM templateParts t
         	  JOIN specification_header sh ON (sh.part_no = t.tpl_part_no AND sh.revision = t.tpl_revision )
         	  JOIN specification_prop sp ON (sp.part_no = sh.part_no AND sp.revision = sh.revision)
       
             -* Base columns per property-group or single property on layout fields
         	  JOIN specification_section fs ON (    fs.part_no			= sh.part_no
         	                                   	AND fs.revision			= sh.revision
         	                                   	AND fs.section_id		= sp.section_id
         	                                   	AND fs.section_rev		= sp.section_rev
         	                                   	AND fs.sub_section_id	= sp.sub_section_id
         	                                   	AND fs.sub_section_rev	= sp.sub_section_rev
         	                                   	AND (   (  fs.type = &SECTIONTYPE_PROPERTYGROUP  AND fs.ref_id = sp.property_group)
                                                       OR (fs.type = &SECTIONTYPE_SINGLEPROPERTY AND fs.ref_id = sp.property)
                                                       )
        	                                    )
         	  JOIN property_layout pl ON ( pl.layout_id	= fs.display_format  AND pl.revision = fs.display_format_rev )
          
         -* Filter out irrelevant and empty fields
         	  JOIN layout l ON ( l.layout_id = pl.layout_id AND l.revision = pl.revision )
          	 WHERE (
         		   (pl.field_id = &FT_NUM_1			AND sp.num_1	IS NOT NULL)
         	    OR (pl.field_id = &FT_NUM_2			AND sp.num_2	IS NOT NULL)
         	    OR (pl.field_id = &FT_NUM_3			AND sp.num_3	IS NOT NULL)
         	    OR (pl.field_id = &FT_NUM_4			AND sp.num_4	IS NOT NULL)
         	    OR (pl.field_id = &FT_NUM_5			AND sp.num_5	IS NOT NULL)
         	    OR (pl.field_id = &FT_NUM_6			AND sp.num_6	IS NOT NULL)
         	    OR (pl.field_id = &FT_NUM_7			AND sp.num_7	IS NOT NULL)
         	    OR (pl.field_id = &FT_NUM_8			AND sp.num_8	IS NOT NULL)
         	    OR (pl.field_id = &FT_NUM_9			AND sp.num_9	IS NOT NULL)
         	    OR (pl.field_id = &FT_NUM_10		AND sp.num_10	IS NOT NULL)
         	    OR (pl.field_id = &FT_CHAR_1		AND sp.char_1	IS NOT NULL AND sp.char_1 <> 'XXXX')
         	    OR (pl.field_id = &FT_CHAR_2		AND sp.char_2	IS NOT NULL AND sp.char_2 <> 'XXXX')
         	    OR (pl.field_id = &FT_CHAR_3		AND sp.char_3	IS NOT NULL AND sp.char_3 <> 'XXXX')
         	    OR (pl.field_id = &FT_CHAR_4		AND sp.char_4	IS NOT NULL AND sp.char_4 <> 'XXXX')
         	    OR (pl.field_id = &FT_CHAR_5		AND sp.char_5	IS NOT NULL AND sp.char_5 <> 'XXXX')
         	    OR (pl.field_id = &FT_CHAR_6		AND sp.char_6	IS NOT NULL AND sp.char_6 <> 'XXXX')
         	    OR (pl.field_id = &FT_BOOLEAN_1		AND sp.boolean_1 <> 'N')
         	    OR (pl.field_id = &FT_BOOLEAN_2		AND sp.boolean_2 <> 'N')
         	    OR (pl.field_id = &FT_BOOLEAN_3		AND sp.boolean_3 <> 'N')
         	    OR (pl.field_id = &FT_BOOLEAN_4		AND sp.boolean_4 <> 'N')
         	    OR (pl.field_id = &FT_DATE_1		AND sp.date_1	IS NOT NULL)
         	    OR (pl.field_id = &FT_DATE_2		AND sp.date_2	IS NOT NULL)
         	    OR (pl.field_id = &FT_UOM			AND sp.uom_id	IS NOT NULL)
         	    OR (pl.field_id = &FT_TESTMETHOD	AND sp.test_method	<> 0)
         	    OR (pl.field_id = &FT_ASSOCIATION_1	AND sp.characteristic	IS NOT NULL)
         	    OR (pl.field_id = &FT_ASSOCIATION_2	AND sp.ch_2	IS NOT NULL)
         	    OR (pl.field_id = &FT_ASSOCIATION_3	AND sp.ch_3	IS NOT NULL)
         		OR (pl.field_id = &FT_PROPERTY)
         	)
         )
 
		
		
		-INCLUDE INT00013P_BoM_properties
        --
        SELECT	bp.*
        ,	part.description AS part_description
        ,	sc.description AS section_d
        ,	su.description AS sub_section_d
        ,	pg.description AS property_group_d
        ,	p.description AS property_d
        ,	h.description AS header_d
        ,	u.description AS u_description
        ,	a.description AS a_description
        ,	tm.description AS t_description
        ,	ch.description AS ch_description
        ,	c2.description AS c2_description
        ,	c3.description AS c3_description
        ,	pc.description AS p_description
          FROM BoMProperties bp
          LEFT JOIN	part ON (part.part_no = bp.part_no)
          JOIN section sc ON (sc.section_id = bp.section_id)
          LEFT JOIN sub_section su ON (su.sub_section_id = bp.sub_section_id AND bp.sub_section_id <> 0)
          JOIN property_group pg ON (pg.property_group = bp.property_group)
          JOIN property p ON (p.property = bp.property)
          JOIN header       h ON (h.header_id = bp.header_id)
          LEFT JOIN uom             u ON (bp.field_id = &FT_UOM AND u.uom_id = bp.sp_uom_id)
          LEFT JOIN attribute       a ON (bp.field_id = &FT_ATTRIBUTE AND a.attribute = bp.sp_attribute)
          LEFT JOIN test_method    tm ON (bp.field_id = &FT_TESTMETHOD AND tm.test_method = bp.sp_test_method)
          LEFT JOIN characteristic ch ON (bp.field_id = &FT_ASSOCIATION_1 AND ch.characteristic_id = bp.sp_characteristic)
          LEFT JOIN characteristic c2 ON (bp.field_id = &FT_ASSOCIATION_2 AND c2.characteristic_id = bp.sp_ch_2)
          LEFT JOIN characteristic c3 ON (bp.field_id = &FT_ASSOCIATION_3 AND c3.characteristic_id = bp.sp_ch_3)
          LEFT JOIN property pc ON (bp.field_id = &FT_PROPERTY AND pc.property = bp.property)
        WHERE bp.section_id <> &S_CONFIG
        ;

 
-INCLUDE GEN00501_compound_init
-INCLUDE GEN00506_compound_heading_open
-	INCLUDE INT00040R0_header
-INCLUDE GEN00507_compound_heading_close
-INCLUDE GEN00502_compound_page_open

-INCLUDE GEN00502_compound_report_open
-	INCLUDE INT00040R2_TopBoMProperties
-INCLUDE GEN00503_compound_report_close

-:BOM_PROPS
-INCLUDE GEN00502_compound_report_open
-	INCLUDE INT00040R3_BoM_Properties
-INCLUDE GEN00503_compound_report_close
 
-:PROPS
-	INCLUDE INT00040R1_Top_Properties






--FILTER part-no
SELECT SH.PART_NO
,      SH.REVISION
FROM SPECIFICATION_HEADER sh
JOIN STATUS                s on s.status = sh.status AND s.status_type = 'CURRENT'
WHERE sh.PART_NO LIKE '%||PART_PATTERN||%'
;

--FILTER: TEMPLATE
--zoek TEMPLATE-PART-NO related to FRAME-ID of SELECTED-PART-NO. 
select distinct p.part_no
,      p.description       --This is template-name !!!!!
,      sh.part_no
,      sh.revision
,      sh.frame_id
,      kw.kw_value
,      ikw.description
FROM SPECIFICATION_KW     kw 
JOIN SPECIFICATION_HEADER sh on kw.kw_value = sh.frame_id  
JOIN ITKW                ikw on ikw.kw_id   = kw.kw_id
JOIN part                  p on p.part_no   = kw.part_no
WHERE sh.part_no = 'XGG_BF66A17J1'
AND   sh.revision = (select max(sh3.revision) from specification_header sh3 where sh3.part_no = sh.part_no)
AND   ikw.DESCRIPTION = 'Frame for Athena perspective'
;

--ITKW:		700686	Frame for Athena perspective	0	1	0	1
--
/*
P.PART_NO       P.DESCRIPTION                           SH.PART-NO      rev	frame_id	kw-value	ikw-description					
ZZ_RnD_PCR_GTX	PCR GREEN TYRE SPECIFICATION-FLIPPER	XGG_BF66A17J1	2	A_PCR_GT v1	A_PCR_GT v1	Frame for Athena perspective	
ZZ_RnD_PCR_GT	PCR GREEN TYRE SPECIFICATION			XGG_BF66A17J1	2	A_PCR_GT v1	A_PCR_GT v1	Frame for Athena perspective	
ZZ_RnD_PCR_XGT1	TRIAL DATA SHEET - BUILDING				XGG_BF66A17J1	2	A_PCR_GT v1	A_PCR_GT v1	Frame for Athena perspective	
ZZ_RnD_PCR_XGT	PCR FIRST TYRE ROUTE CARD - BUILDING	XGG_BF66A17J1	2	A_PCR_GT v1	A_PCR_GT v1	Frame for Athena perspective	

--CONCLUSIE: DIT ZIJN DE PART-NO DIE ALS TEMPLATE GEBRUIKT KUNNEN WORDEN !!!!!!!!!!!!
--           TEMPLATE-STRUCTUUR BEPAALT DAN DE OPBOUW VAN HET REPORT, TBV TONEN COMPONENTEN + PROPERTIES !!!!!!!
*/


--SPECIFICATION-PART-NO
SELECT SH.PART_NO
,      SH.REVISION
,      SH.DESCRIPTION
,      TO_CHAR(SH.ISSUED_DATE,'dd-mm-yyyy hh24:mi:ss')  issued_date
,       s.sort_desc
,       us.user_id
,       us.forename||' '||us.last_name
,       r.text
FROM SPECIFICATION_HEADER SH
JOIN status                     S  on S.STATUS = SH.STATUS
JOIN itus                       us on us.user_id = sh.last_modified_by
LEFT OUTER JOIN STATUS_HISTORY his on his.part_no = sh.part_no and his.revision = sh.revision AND his.status = sh.status and his.reason_id is not null
LEFT OUTER JOIN REASON           r on r.id = his.reason_id
where sh.PART_NO = 'XGG_BF66A17J1'  --'EF_540/65R34TVZM45'
AND   sh.REVISION = 2               --1

--
--XGG_BF66A17J1	2	Greentyre BMW F66A17	15-02-2023 13:59:43	CRRNT QR2	KTO	Kitti Toth	flipper change


--ASSEMBLY-PROPERTIES
--INCLUDE INT00040R2_TopBoMProperties
--OUTPUT VAN BOM-QUERY RELATED WITH FILTERED-TEMPLATE-BOM:
/*
ZZ_RnD_PCR_GTX	8	PCR GREEN TYRE SPECIFICATION-FLIPPER	ZZ_RnD_PCR_GTX		8	PCR GREEN TYRE SPECIFICATION-FLIPPER			A_PCR_GT v1		34	1	1	0
ZZ_RnD_PCR_GTX	8	PCR GREEN TYRE SPECIFICATION-FLIPPER	ZZ_RnD_PCRSW		3	PCR SIDEWALL									A_Sidewall v1	21	10	1.0.01	1
ZZ_RnD_PCR_GTX	8	PCR GREEN TYRE SPECIFICATION-FLIPPER	ZZ_RnD_PCR_IL		2	Template PCR production BoM						A_Innerliner v1	20	20	1.0.02	1
ZZ_RnD_PCR_GTX	8	PCR GREEN TYRE SPECIFICATION-FLIPPER	ZZ_RnD_PCR_Runflat	1	Template Runflat strip							A_Run flat		1	25	1.0.025	1
ZZ_RnD_PCR_GTX	8	PCR GREEN TYRE SPECIFICATION-FLIPPER	ZZ_RnD_PLYV1		3	PCR BODY PLY 									A_Ply v1		13	30	1.0.03	1
ZZ_RnD_PCR_GTX	8	PCR GREEN TYRE SPECIFICATION-FLIPPER	ZZ_RnD_PLYV1		3	PCR BODY PLY 									A_Ply v1		13	40	1.0.04	1
ZZ_RnD_PCR_GTX	8	PCR GREEN TYRE SPECIFICATION-FLIPPER	ZZ_RnD_FLIPPER_X	2	PCR FLIPPER 									A_Ply v1		13	45	1.0.045	1
ZZ_RnD_PCR_GTX	8	PCR GREEN TYRE SPECIFICATION-FLIPPER	ZZ_RnD_FLIPPER_X	2	PCR FLIPPER 									A_Ply v1		13	48	1.0.048	1
ZZ_RnD_PCR_GTX	8	PCR GREEN TYRE SPECIFICATION-FLIPPER	ZZ_RnD_PCR_BEADAPE	2	Template Bead Apex								A_Bead v1		24	50	1.0.05	1
ZZ_RnD_PCR_GTX	8	PCR GREEN TYRE SPECIFICATION-FLIPPER	ZZ_RnD_BELT1PCR		7	Test new mask functionality BELT Material		A_Belt v1		12	60	1.0.06	1
ZZ_RnD_PCR_GTX	8	PCR GREEN TYRE SPECIFICATION-FLIPPER	ZZ_RnD_BELT1PCR		7	Test new mask functionality BELT Material		A_Belt v1		12	70	1.0.07	1
ZZ_RnD_PCR_GTX	8	PCR GREEN TYRE SPECIFICATION-FLIPPER	ZZ_RnD_PLYV1		3	PCR BODY PLY 									A_Ply v1		13	80	1.0.08	1
ZZ_RnD_PCR_GTX	8	PCR GREEN TYRE SPECIFICATION-FLIPPER	ZZ_RnD_TREADPCR		13	Test new mask functionality- PCR TREAD METERS	A_tread v1		29	90	1.0.09	1
*/


Sidewall L/R	XGS_WBTV120TN		1.312	m	0.921	.
Innerliner		XGL_LAQ1360F360N	1.312	m	0.859	120
Body Ply 1		XGR_PK08490L80		1.323	m	0.982	240
Flipper L		XGR_WR01450085		1.000	m	0.136	.
Flipper R		XGR_WR01450085		1.000	m	0.136	.
Bead apex		XGB_AH138700124543	2.000	pcs	0.640	.
Belt 1			XGR_GSA1327195		1.838	m	0.805	40
Belt 2			XGR_NSA1327185		1.845	m	0.721	220
Capstrip		GR_NB01000012		1.440	m	0.298	295
Tread			XGT_PSTBF66A17D2	1.857	m	2.977	 


--INCLUDE INT00040R3_BoM_Properties
--TABLE FILE INT00040H_TPL_FULL 
WHERE FUNCTIONGRP NE '&ITEM';
WHERE FIELD_ID NE &FT_PROPERTY;
WHERE TOTAL ROW_RELEVANCE2 GT 0;
ON TABLE SUBHEAD
"Assembly Properties"

 
 
-INCLUDE INT00013P_BoM_templateProps
-INCLUDE INT00013P_BoM_properties

SELECT bp.*
,	part.description AS part_description
,	sc.description   AS section_d
,	su.description   AS sub_section_d
,	pg.description   AS property_group_d
,	p.description    AS property_d
,	h.description    AS header_d
,	u.description    AS u_description
,	a.description    AS a_description
,	tm.description   AS t_description
,	ch.description   AS ch_description
,	c2.description   AS c2_description
,	c3.description   AS c3_description
,	pc.description   AS p_description
FROM BoMProperties bp
LEFT JOIN	part              ON (part.part_no = bp.part_no)
JOIN section             sc ON (sc.section_id = bp.section_id)
LEFT JOIN sub_section    su ON (su.sub_section_id = bp.sub_section_id AND bp.sub_section_id <> 0)
JOIN property_group      pg ON (pg.property_group = bp.property_group)
JOIN property             p ON (p.property = bp.property)
JOIN header               h ON (h.header_id = bp.header_id)
LEFT JOIN uom             u ON (bp.field_id = &FT_UOM AND u.uom_id = bp.sp_uom_id)
LEFT JOIN attribute       a ON (bp.field_id = &FT_ATTRIBUTE AND a.attribute = bp.sp_attribute)
LEFT JOIN test_method    tm ON (bp.field_id = &FT_TESTMETHOD AND tm.test_method = bp.sp_test_method)
LEFT JOIN characteristic ch ON (bp.field_id = &FT_ASSOCIATION_1 AND ch.characteristic_id = bp.sp_characteristic)
LEFT JOIN characteristic c2 ON (bp.field_id = &FT_ASSOCIATION_2 AND c2.characteristic_id = bp.sp_ch_2)
LEFT JOIN characteristic c3 ON (bp.field_id = &FT_ASSOCIATION_3 AND c3.characteristic_id = bp.sp_ch_3)
LEFT JOIN property       pc ON (bp.field_id = &FT_PROPERTY AND pc.property = bp.property)
WHERE bp.section_id <> &S_CONFIG
;

 
 
--INCLUDE INT00040R1_Top_Properties
Interspec/int00040p1_section
	-INCLUDE INT00040P11_property_group
	-INCLUDE INT00040P14_property



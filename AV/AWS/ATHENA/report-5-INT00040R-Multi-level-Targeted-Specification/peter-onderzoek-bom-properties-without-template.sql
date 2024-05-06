--ONDERZOEK properties bij SPEC

--QUERY TO RETRIEVE ALL PART-NO-PROPERTIES COMBINED WITH ALL THE TEMPLATE-PROPERTIES !!!

--research: 'XGG_BF66A17J1'

/*
--with relation to TEMPLATEBOM BASED ON TEMPLATE-PART-NO from template:	ZZ_RnD_PCR_GTX !!!!!!!!!!!!
--
XGG_BF66A17J1	2	CURRENT	XGG_BF66A17J1		2	CURRENT	Greentyre						0			0	XGG_BF66A17J1	ZZ_RnD_PCR_GTX	PCR GREEN TYRE SPECIFICATION-FLIPPER		ZZ_RnD_PCR_GTX		8	PCR GREEN TYRE SPECIFICATION-FLIPPER	1	1	Greentyre	Greentyre	Greentyre	%Greentyre		1	1	pcs																			1			Greentyre BMW F66A17	8.47570444	KG
XGG_BF66A17J1	2	CURRENT	XGS_WBTV120TN		1	CURRENT	Greentyre.Sidewall L/R			10	0010	1	XGS_WBTV120TN	ZZ_RnD_PCR_GTX	PCR GREEN TYRE SPECIFICATION-FLIPPER		ZZ_RnD_PCRSW		3	PCR SIDEWALL	10	1.0.01	Sidewall L/R	Sidewall L/R	Sidewall L/R	%Sidewall L/R		1.312		m													0	0	0	0	903394		1.312			B-120 Thin GM_R5026/GM_Z5020	0.702	KG
XGG_BF66A17J1	2	CURRENT	XGL_LAQ1360F360N	1	CURRENT	Greentyre.Innerliner assembly	20	0020	1	XGL_LAQ1360F360N	ZZ_RnD_PCR_GTX	PCR GREEN TYRE SPECIFICATION-FLIPPER	ZZ_RnD_PCR_IL		2	Template PCR production BoM	20	1.0.02	Innerliner 	Innerliner assembly	Innerliner	%Innerliner assembly		1.312		m													0	0	0	0	903345		1.312			LAQ1-360-F360 - GM_L2002 / GM_B1054	0.655	KG
XGG_BF66A17J1	2	CURRENT	XGR_PK08490L80		1	CURRENT	Greentyre.Ply 1					90	0090	1	XGR_PK08490L80	ZZ_RnD_PCR_GTX	PCR GREEN TYRE SPECIFICATION-FLIPPER		ZZ_RnD_PLYV1		3	PCR BODY PLY 	30	1.0.03	Body Ply 1	Ply 1	Body Ply 1	%Ply 1		1.323		m													0	0	0	0	903320		1.323			PK08-90-490 - Ply with XGX_L170 gum B1008	0.742238	KG
XGG_BF66A17J1	2	CURRENT	XGR_WR01450085		3	CURRENT	Greentyre.Flipper L				40	0040	1	XGR_WR01450085	ZZ_RnD_PCR_GTX	PCR GREEN TYRE SPECIFICATION-FLIPPER		ZZ_RnD_FLIPPER_X	2	PCR FLIPPER 	45	1.0.045	Flipper L	Flipper L	Flipper L	%Flipper L		1		m													0	0	0	0	688		1			RL01-45-85 Rayon Flipper	0.136	KG
XGG_BF66A17J1	2	CURRENT	XGR_WR01450085		3	CURRENT	Greentyre.Flipper R				50	0050	1	XGR_WR01450085	ZZ_RnD_PCR_GTX	PCR GREEN TYRE SPECIFICATION-FLIPPER		ZZ_RnD_FLIPPER_X	2	PCR FLIPPER 	48	1.0.048	Flipper R	Flipper R	Flipper R	%Flipper R		1		m													0	0	0	0	689		1			RL01-45-85 Rayon Flipper	0.136	KG
XGG_BF66A17J1	2	CURRENT	XGB_AH138700124543	1	CURRENT	Greentyre.Bead apex				110	0110	1	XGB_AH138700124543	ZZ_RnD_PCR_GTX	PCR GREEN TYRE SPECIFICATION-FLIPPER	ZZ_RnD_PCR_BEADAPE	2	Template Bead Apex	50	1.0.05	Bead apex	Bead apex	Bead apex	%Bead apex		2		pcs													0	0	0	0	903323		2			17" 4-5-4-3 Filler 12mm A4012	0.32	KG
XGG_BF66A17J1	2	CURRENT	XGR_GSA1327195		1	CURRENT	Greentyre.Belt 1				120	0120	1	XGR_GSA1327195	ZZ_RnD_PCR_GTX	PCR GREEN TYRE SPECIFICATION-FLIPPER		ZZ_RnD_BELT1PCR		7	Test new mask functionality BELT Material	60	1.0.06	Belt 1	Belt 1	Belt 1	%Belt 1		1.838		m													0	0	0	0	903316		1.838			SA13-27-195 Top gum 0.5x20 (2x)	0.438138	KG
XGG_BF66A17J1	2	CURRENT	XGR_NSA1327185		3	CURRENT	Greentyre.Belt 2				130	0130	1	XGR_NSA1327185	ZZ_RnD_PCR_GTX	PCR GREEN TYRE SPECIFICATION-FLIPPER		ZZ_RnD_BELT1PCR		7	Test new mask functionality BELT Material	70	1.0.07	Belt 2	Belt 2	Belt 2	%Belt 2		1.845		m													0	0	0	0	903317		1.845			SA13-27-185-No Gum	0.390905	KG
XGG_BF66A17J1	2	CURRENT	GR_NB01000012		7	CURRENT	Greentyre.Capstrip				140	0140	1	GR_NB01000012	ZZ_RnD_PCR_GTX	PCR GREEN TYRE SPECIFICATION-FLIPPER		ZZ_RnD_PLYV1		3	PCR BODY PLY 	80	1.0.08	Capstrip	Capstrip	Capstrip	%Capstrip		31.44		m													0	0	0	0	903372		31.44			NB01 Capstrip 12 mm	0.00948	KG
XGG_BF66A17J1	2	CURRENT	XGT_PSTBF66A17D2	4	CURRENT	Greentyre.Tread					150	0150	1	XGT_PSTBF66A17D2	ZZ_RnD_PCR_GTX	PCR GREEN TYRE SPECIFICATION-FLIPPER	ZZ_RnD_TREADPCR		13	Test new mask functionality- PCR TREAD METERS	90	1.0.09	Tread	Tread	Tread	%Tread		1.857		m													0	0	0	0	903311		1.857			TREAD BF66AS17 B220 SB190 GMST7022/T3008/T3030	1.603	KG
*/

/*
--property-groupen ASSEMBLY-properties:
703376	Assembly info
701566	Pre-Assembly properties
704283	Sidewall and innerliner assembly
703933	Sidewall innerliner Assembly

select * from specification_prop where part_no='XGS_WBTV120TN'  and property_group in (703376, 701566, 704283, 703933);


*/

/*
--STRUCTURE COMING FROM EXPORT-FOR-CONTACT GLOBAL-LIMS:

       CASE when pl.field_id = 1  then 'Num_1'
            when pl.field_id = 2  then 'Num_2'
            when pl.field_id = 3  then 'Num_3'
            when pl.field_id = 4  then 'Num_4'
            when pl.field_id = 5  then 'Num_5'
            when pl.field_id = 6  then 'Num_6'
            when pl.field_id = 7  then 'Num_7'
            when pl.field_id = 8  then 'Num_8'
            when pl.field_id = 9  then 'Num_9'
            when pl.field_id = 10 then 'Num_10'
            when pl.field_id = 11 then 'Char_1'
            when pl.field_id = 12 then 'Char_2'
            when pl.field_id = 13 then 'Char_3'
            when pl.field_id = 14 then 'Char_4'
            when pl.field_id = 15 then 'Char_5'
            when pl.field_id = 16 then 'Char_6'
            when pl.field_id = 17 then 'Boolean_1'
            when pl.field_id = 18 then 'Boolean_2'
            when pl.field_id = 19 then 'Boolean_3'
            when pl.field_id = 20 then 'Boolean_4'
            when pl.field_id = 21 then 'Date_1'
            when pl.field_id = 22 then 'Date_2'
            when pl.field_id = 23 then 'UOM_id'
            when pl.field_id = 24 then 'Attribute'
            when pl.field_id = 25 then 'Test method'
            when pl.field_id = 26 then 'Characteristic'
            when pl.field_id = 27 then 'Property'
            when pl.field_id = 30 then 'Ch_2 (Characteristic 2)'
            when pl.field_id = 31 then 'Ch_3 (Characteristic 3)'
            when pl.field_id = 32 then 'Tm_det_1 (Test method detail)'
            when pl.field_id = 33 then 'Tm_det_2 (Test method detail)'
            when pl.field_id = 34 then 'Tm_det_3 (Test method detail)'
            when pl.field_id = 35 then 'Tm_det_4 (Test method detail)'
            when pl.field_id = 40 then 'Info'
            else 'NULL'
       END db_field
*/	   


--***************************************************************************************
--***************************************************************************************
--***************************************************************************************
--***************************************************************************************
-- TOTAL QUERY PROPERTIES
-- LET OP: DIT IS QUERY VOOR OPHALEN PROPERTIES VAN ALLE BOM-ITEMS DIE ONDER PART-NO VOORKOMEN.
--         IN PRINCIPE ALLEEN VOOR LEVEL=1 !!!
--         (IS WEL VREEMD DAT IN DE QUERY WE EEN LEVEL < 1 MOETEN OPGEVEN OM UITEINDELIJK LEVEL=1 TE KRIJGEN)
--         
--***************************************************************************************
--***************************************************************************************
--***************************************************************************************
--***************************************************************************************

WITH cart AS 
 (SELECT 'Array'                                                AS origin
 ,      'XGG_BF66A17J1'                                         AS part_no
 ,      to_date('2023/10/09 10:36:32', 'YYYY/MM/DD HH24:MI:SS') AS reference_date
 ,      NULL                                                    AS plant 
 FROM dual
 )
, partList AS 
(SELECT H.part_no
 ,      H.revision
 ,	    H.issued_date
 ,      H.planned_effective_date
 ,      H.obsolescence_date
 ,	    H.class3_id
 ,	    B.plant
 ,      B.preferred
 ,      B.alternative
 ,	    S.status
 ,      S.sort_desc AS status_code
 ,      S.status_type
 ,	    L.reference_date
 FROM cart L
 JOIN specification_header H ON (H.part_no  = L.part_no)
 JOIN status               S ON (S.status   = H.status)
 JOIN class3               C ON (C.class    = H.class3_id)
 LEFT JOIN bom_header      B ON ( B.part_no = H.part_no AND B.revision = H.revision )
 WHERE S.status_type IN ('HISTORIC', 'CURRENT')
 --AND C.sort_desc	= 'FOC_NONE'
 AND B.preferred	= 1
 AND B.alternative	= 1            --FOC_NONE
 AND (L.plant IS NULL OR B.plant = L.plant)
 AND NOT EXISTS ( SELECT 1
                  FROM specification_header
                  JOIN status USING (status)
                  WHERE part_no = H.part_no
                  AND revision  > H.revision
                  AND status_type IN ('HISTORIC', 'CURRENT')
                 )
 AND	( 'DEFAULT' <> 'REFDATE'
        OR ( 'DEFAULT' = 'REFDATE'
           AND	L.reference_date >= coalesce(H.issued_date, H.planned_effective_date)
           AND (H.obsolescence_date IS NULL OR L.reference_date < H.obsolescence_date)
           )
        )
 GROUP BY H.part_no
 ,        H.revision
 ,	      H.issued_date
 ,        H.planned_effective_date
 ,        H.obsolescence_date
 ,	      H.class3_id
 ,	      B.plant
 ,        B.preferred
 ,        B.alternative
 ,	      S.status
 ,        S.sort_desc
 ,        S.status_type
 ,	      L.reference_date
)
, specList AS 
(SELECT h2.part_no
 ,      h2.revision
 ,	    h2.issued_date
 ,      h2.obsolescence_date
 ,      h2.planned_effective_date
 ,	    h2.status
 ,      s2.sort_desc     AS status_code
 ,      s2.status_type
 ,	    h2.class3_id
 ,	    CASE WHEN 'DEFAULT' = 'REFDATE' 
             THEN 1 
			 ELSE 0 
	    END               AS f_checkRefDate
 FROM specification_header h2
 JOIN status s2 ON ( s2.status = h2.status AND status_type IN ('HISTORIC', 'CURRENT') )
 WHERE (  'DEFAULT' = 'HIGHEST' 
       OR h2.issued_date IS NOT NULL
	   )
)
, componentList AS 
(SELECT h2.part_no
 ,      h2.revision
 ,	    h2.issued_date
 ,      h2.obsolescence_date
 ,      h2.planned_effective_date
 ,	    h2.status
 ,      s2.sort_desc         AS status_code
 ,      s2.status_type
 ,	    h2.class3_id
 ,	    CASE WHEN 'DEFAULT' = 'REFDATE' 
             THEN 1 
			 ELSE 0 
	    END                  AS f_checkRefDate
 FROM specification_header h2
 JOIN status s2 ON ( s2.status = h2.status AND status_type IN ('HISTORIC', 'CURRENT') )
 WHERE h2.part_no NOT LIKE 'X%'
 AND (  'DEFAULT' = 'HIGHEST' 
     OR h2.issued_date IS NOT NULL
	 )
 UNION ALL
 SELECT h2.part_no
 ,      h2.revision
 ,	    h2.issued_date
 ,      h2.obsolescence_date
 ,      h2.planned_effective_date
 ,	    h2.status
 ,      s2.sort_desc          AS status_code
 ,      s2.status_type
 ,	    h2.class3_id
 ,	    CASE WHEN 'DEFAULT' = 'REFDATE' 
             THEN 1 
			 ELSE 0 
	    END                   AS f_checkRefDate
 FROM specification_header h2
 JOIN status s2 ON ( s2.status = h2.status AND status_type IN ('HISTORIC', 'CURRENT') )
 WHERE h2.part_no LIKE 'X%'
 AND (  'DEFAULT' = 'HIGHEST' 
     OR h2.issued_date IS NOT NULL
	 )
)
, root_function AS 
(SELECT sk.part_no
 ,      sk.kw_value
 FROM specification_kw sk
 JOIN itkw                 ON ( itkw.kw_id = sk.kw_id AND itkw.description = 'Function' )
)
, bom_function AS 
(SELECT f.characteristic_id
 ,      f.description
 FROM characteristic f
 JOIN characteristic_association ca ON ( ca.characteristic = f.characteristic_id AND ca.intl = f.intl )
 JOIN association                 a ON ( a.association = ca.association          AND a.intl = ca.intl )
 WHERE a.description = 'Function'
 )
, tree (
    root_part, root_rev
 ,	root_status, root_status_type
 ,	root_preferred, root_alternative
 ,	root_issued_date
 ,	root_density
 ,	parent_part, parent_rev
 ,	parent_status, parent_status_type
 ,	parent_seq
 ,	parent_function, parent_uom
 ,	part_no, revision, plant, item_number
 ,	issued_date, obsolete_date
 ,	status, status_code, status_type
 ,	class3_id
 ,	function
 ,	preferred, alternative, base_quantity
 ,	phr, quantity, density, uom
 ,	num_1, num_2, num_3, num_4, num_5
 ,	char_1, char_2, char_3, char_4, char_5
 ,	date_1, date_2
 ,	boolean_1, boolean_2, boolean_3, boolean_4
 ,	ch_1, ch_2
 ,	parent_quantity
 ,	normalized_quantity
 ,	component_volume, volume, normalized_volume
 ,	parent_volume
 ,	component_kg, assembly_kg
 ,	parent_kg
 ,	lvl	, step
 ,	path, pathNode
 ,	parent_branch, branch
 ,	indentStr
 ,	breadcrumbs
 ,	reference_date
 ,	part_reference_date
 ,	e_issuedAfterExplDate
 ,	e_noPhantomRevision
 ) AS 
 (SELECT p.part_no            AS root_part
 ,  p.revision                AS root_rev
 ,	p.status                  AS root_status
 ,  p.status_type             AS root_status_type
 ,	bh.preferred              AS root_preferred
 ,  bh.alternative            AS root_alternative
 ,	p.issued_date             AS root_issued_date
 ,	bi.num_1                  AS root_density
 ,	p.part_no                 AS parent_part
 ,  p.revision                AS parent_rev
 ,	p.status                  AS parent_status
 ,  p.status_type             AS parent_status_type
 ,	bi.item_number            AS parent_seq
 ,	NULL                      AS parent_function
 ,  NULL                      AS parent_uom
 ,	bi.component_part         AS part_no
 ,  hh.revision
 ,  bi.plant
 ,  bi.item_number
 ,	coalesce(hh.issued_date, hh.planned_effective_date)  AS issued_date
 ,	coalesce(hh.obsolescence_date, CURRENT_DATE +1)      AS obsolete_date
 ,	hh.status
 ,  hh.status_code
 ,  hh.status_type
 ,	hh.class3_id
 ,	f.description                            AS function
 ,	bh.preferred
 ,  bh.alternative
 ,  bh.base_quantity
 ,	bi.num_5                                 AS phr
 ,  bi.quantity
 ,  bi.num_1                                 AS density, bi.uom
 ,	bi.num_1, bi.num_2, bi.num_3, bi.num_4, bi.num_5
 ,	bi.char_1, bi.char_2, bi.char_3, bi.char_4, bi.char_5
 ,	bi.date_1, bi.date_2
 ,	bi.boolean_1, bi.boolean_2, bi.boolean_3, bi.boolean_4
 ,	bi.ch_1, bi.ch_2
 ,	bh.base_quantity        AS parent_quantity
 ,	bi.quantity * 1.0       AS normalized_quantity
 ,	bi.quantity / bi.num_1	AS component_volume
 ,	bi.quantity / bi.num_1	AS volume
 ,	bi.quantity / bi.num_1	AS normalized_volume
 ,	1.0 AS parent_volume
 ,	CASE WHEN bi.uom = 'kg' THEN bi.quantity * 1.0
                            ELSE NULL
    END
 ,	CASE WHEN bi.uom = 'kg' THEN bi.quantity * 1.0
                            ELSE NULL
    END
 ,	SUM(CASE WHEN bi.uom = 'kg' THEN bi.quantity * 1.0
                                ELSE NULL        END )  OVER ()
 ,	1 AS lvl
 ,	ROW_NUMBER() OVER (ORDER BY bi.item_number) -1
 ,	CAST('0000' AS varchar2(120)) AS path
 ,	to_char(bi.item_number, 'FM0999') AS pathNode
 ,	CAST('' AS VARCHAR2(100)) AS parent_branch
 ,	CAST(to_char(bi.item_number, 'FM0999') AS varchar2(100)) AS branch
 ,	CAST ('' AS VARCHAR2(200)) AS indentStr
 ,	CAST(r.kw_value || '.' || f.description AS VARCHAR2(254)) AS breadcrumbs
 ,	CAST(p.reference_date AS date)
 ,	CAST(CASE WHEN 'DEFAULT' = 'REFDATE' THEN p.reference_date
              WHEN 'DEFAULT' = 'DEFAULT' AND bi.component_part LIKE 'X%' THEN p.issued_date
                                                                         ELSE coalesce(p.obsolescence_date, CURRENT_DATE)
         END AS date
		)
 ,	CASE WHEN p.revision = 1 AND hh.revision = 1 AND p.reference_date < coalesce(hh.issued_date, hh.planned_effective_date) THEN '1'
                                                                                                                            ELSE '0'
    END AS e_issuedAfterExplDate
 ,	CASE WHEN hh.revision IS NULL THEN 1 
                                  ELSE 0 
	END AS e_noPhantomRevision
 FROM partList p
 LEFT JOIN root_function r ON (r.part_no = p.part_no)
 LEFT JOIN bom_header   bh ON (bh.part_no = p.part_no   AND bh.revision = p.revision  AND bh.preferred = p.preferred )
 LEFT JOIN bom_item     bi ON ( bi.part_no = bh.part_no AND bi.revision = bh.revision AND bi.plant = bh.plant AND bi.alternative = bh.alternative )
 LEFT JOIN specList     hh ON ( bi.component_part = hh.part_no  AND (  f_checkRefDate = 0 
                                                                    OR (    hh.issued_date <= p.reference_date
                                                                       AND (  hh.obsolescence_date IS NULL 
																	       OR p.reference_date < hh.obsolescence_date
																		   )
                                                                        )
                                                                    )
                                                                AND NOT EXISTS (SELECT 1
                                                                                FROM specification_header h2a
                                                                                JOIN status s2a ON (s2a.status = h2a.status)
                                                                                WHERE h2a.part_no = hh.part_no
                                                                                AND h2a.revision > hh.revision
                                                                                AND s2a.status_type IN ('HISTORIC', 'CURRENT')
                                                                                AND (   'DEFAULT' <> 'REFDATE'
                                                                                    OR (   h2a.issued_date <= p.reference_date
   																					   AND (  h2a.obsolescence_date IS NULL 
																					       OR p.reference_date < h2a.obsolescence_date
																						   )
                                                                                        )
                                                                                    )
                                                                                )
                               )
 LEFT JOIN bom_function f ON (f.characteristic_id = bi.ch_1)
 WHERE 1 = 1
 AND bh.preferred	= 1
 AND bh.alternative	= 1    --FOC_NONE
 UNION ALL
 SELECT t.root_part
 ,  t.root_rev
 ,	t.root_status, t.root_status_type
 ,	t.root_preferred, t.root_alternative
 ,	t.root_issued_date
 ,	t.root_density
 ,	t.part_no AS parent_part, t.revision AS parent_rev
 ,	t.status AS parent_status, t.status_type AS parent_status_type
 ,	t.item_number AS parent_seq
 ,	t.function AS parent_function, t.uom AS parent_uom
 ,	bi.component_part AS part_no, hh.revision, t.plant, bi.item_number
 ,	hh.issued_date, hh.obsolescence_date AS obsolete_date
 ,	hh.status, hh.status_code, hh.status_type
 ,	hh.class3_id
 ,	f.description AS function
 ,	bh.preferred, bh.alternative, bh.base_quantity
 ,	bi.num_5 AS phr, bi.quantity, bi.num_1 AS density, bi.uom
 ,	bi.num_1, bi.num_2, bi.num_3, bi.num_4, bi.num_5
 ,	bi.char_1, bi.char_2, bi.char_3, bi.char_4, bi.char_5
 ,	bi.date_1, bi.date_2
 ,	bi.boolean_1, bi.boolean_2, bi.boolean_3, bi.boolean_4
 ,	bi.ch_1, bi.ch_2
 ,	bh.base_quantity                                                                        AS parent_quantity
 ,	DECODE(bh.base_quantity, 0, 0, bi.quantity * t.normalized_quantity / bh.base_quantity)	AS normalized_quantity
 ,	DECODE(bi.num_1, 0, 0, bi.quantity / bi.num_1)		                                    AS component_volume
 ,	DECODE(bi.num_1, 0, 0, bi.quantity / bi.num_1) * coalesce(t.volume,	DECODE(bh.base_quantity, 0, 0, bi.quantity / bh.base_quantity),	1.0 )                         AS volume
 ,	DECODE(bi.num_1, 0, 0, bi.quantity / bi.num_1) * coalesce(t.volume,	DECODE(bh.base_quantity, 0, 0, bi.quantity * t.normalized_quantity / bh.base_quantity),	1.0 ) AS normalized_volume
 ,	t.volume AS parent_volume
 ,	CASE WHEN bi.uom = 'kg'  THEN DECODE(bh.base_quantity, 0, 0, bi.quantity * t.normalized_quantity / bh.base_quantity)
                             ELSE NULL
    END
 ,	CASE WHEN t.uom <> 'kg' AND bi.uom = 'kg' THEN DECODE(bh.base_quantity, 0, 0, bi.quantity * t.normalized_quantity / bh.base_quantity)
                                              ELSE NULL
    END
 ,	SUM(CASE WHEN t.uom <> 'kg' AND bi.uom = 'kg' THEN DECODE(bh.base_quantity, 0, 0, bi.quantity * t.normalized_quantity / bh.base_quantity)
                                                  ELSE 0
        END) OVER (PARTITION BY t.branch)
 ,	t.lvl +1									                          AS lvl
 ,	ROW_NUMBER() OVER (PARTITION BY t.branch ORDER BY bi.item_number) -1
 ,	substr(t.path || '.' || t.pathNode, 1, 120)	                          AS path
 ,	to_char(bi.item_number, 'FM0999')			                          AS pathNode
 ,	t.branch									                          AS parent_branch
 ,	substr(t.branch || '.' || to_char(bi.item_number, 'FM0999'), 1, 100)  AS branch
 --,	substr(t.indentStr || '$nbsp;$nbsp;$nbsp;', 1, 200)                   AS indentStr
 ,	substr(t.indentStr || '   ', 1, 200)                   AS indentStr
 ,	cast(t.breadcrumbs || '.' || case when f.description is null then '(null)'
                                      when f.description = '' then '(null)'
									  else f.description
                                  end AS varchar2(254)
		)
 ,	CAST(t.reference_date AS date)
 ,	CAST(CASE WHEN bi.component_part NOT LIKE 'X%' AND 'DEFAULT' = 'REFDATE' THEN t.reference_date
              WHEN bi.component_part LIKE 'X%' AND 'DEFAULT' = 'REFDATE' THEN t.reference_date
                                                                         ELSE t.part_reference_date
              END AS date
	    )
 ,	CASE WHEN t.root_rev = 1 AND hh.revision = 1 AND t.reference_date < coalesce(hh.issued_date, hh.planned_effective_date) THEN '1'
                                                                                                                            ELSE '0'
    END AS e_issuedAfterExplDate
 ,	CASE WHEN hh.revision IS NULL THEN 1 
                                  ELSE 0 
    END AS e_noPhantomRevision
 FROM tree t
 JOIN bom_header bh ON ( bh.part_no		= t.part_no AND bh.revision		= t.revision AND bh.plant		= t.plant AND bh.preferred	= 1 AND bh.alternative	= 1 )     --replace ALTERNATIVE=FOC_NONE
 JOIN bom_item bi ON ( bh.part_no		= bi.part_no AND bh.revision		= bi.revision AND bh.plant		= bi.plant AND bh.alternative	= bi.alternative )
 LEFT JOIN componentList hh ON ( hh.part_no = bi.component_part AND (  f_checkRefDate = 0
                                                                    OR (   hh.issued_date <= t.reference_date
  																	   AND (  hh.obsolescence_date IS NULL 
																	       OR t.reference_date < hh.obsolescence_date
																		   )
                                                                        )
                                                                    )
                                                                AND NOT EXISTS ( SELECT 1
                                                                                 FROM specification_header h2a
                                                                                 JOIN status s2a ON ( s2a.status = h2a.status AND s2a.status_type IN ('HISTORIC', 'CURRENT') )
                                                                                 WHERE h2a.part_no = hh.part_no
                                                                                 AND h2a.part_no NOT LIKE 'X%'
                                                                                 AND h2a.revision > hh.revision
                                                                                 AND ('DEFAULT' = 'HIGHEST' OR h2a.issued_date IS NOT NULL)
                                                                                 UNION ALL
                                                                                 SELECT 1
                                                                                 FROM specification_header h2a
                                                                                 JOIN status s2a ON ( s2a.status = h2a.status AND s2a.status_type IN ('HISTORIC', 'CURRENT') )
                                                                                 WHERE h2a.part_no = hh.part_no
                                                                                 AND h2a.part_no LIKE 'X%'
                                                                                 AND h2a.revision > hh.revision
                                                                                 AND ('DEFAULT' = 'HIGHEST' OR h2a.issued_date IS NOT NULL)
                                                                               )
                               )
 LEFT JOIN bom_function f ON (f.characteristic_id = bi.ch_1)
 WHERE 1 = 1
 AND hh.status_type IN ('HISTORIC', 'CURRENT')  --= 'FOC_NONE'
 AND t.lvl          < 1                        --FOC_NONE
 AND t.revision     IS NOT NULL
 AND t.function     IS NOT NULL 
 AND t.function     NOT LIKE '%FOC_NONE'
) CYCLE part_no SET e_cyclic TO '1' DEFAULT '0'
, BoMProperties (part_no                     
                ,revision                    
                ,item_number
				,branch 
                ,lvl				
                ,section_sequence_no
                ,ref_id
                ,type
                ,sequence_no
                ,section_id
                ,section_rev
                ,sub_section_id
                ,sub_section_rev
                ,property_group
                ,property
                ,pg_sequence_no
                ,sp_num_1
                ,sp_num_2
                ,sp_num_3
                ,sp_num_4
                ,sp_num_5
                ,sp_num_6
                ,sp_num_7
                ,sp_num_8
                ,sp_num_9
                ,sp_num_10
                ,sp_char_1
                ,sp_char_2
                ,sp_char_3
                ,sp_char_4
                ,sp_char_5
                ,sp_char_6
                ,sp_boolean_1
                ,sp_boolean_2
                ,sp_boolean_3
                ,sp_boolean_4
                ,sp_date_1
                ,sp_date_2
                ,sp_uom_id
                ,sp_attribute
                ,sp_test_method
                ,sp_characteristic
                ,sp_ch_2
                ,sp_ch_3
                ,layout_id
                ,field_id
                ,header_id
                ,start_pos
                ,format_id
                ,field_relevance_bit 
) AS 
(SELECT	p.part_no                     
,       p.revision                    
,       p.item_number
,       p.branch
,       p.lvl       
,	    ss.section_sequence_no
,       ss.ref_id
,       ss.type
,	    ss.sequence_no
,	    sp.section_id
,       sp.section_rev
,	    sp.sub_section_id
,       sp.sub_section_rev
,	    sp.property_group
,       sp.property
,       sp.sequence_no as pg_sequence_no
,	sp.num_1 AS sp_num_1
,	sp.num_2 AS sp_num_2
,	sp.num_3 AS sp_num_3
,	sp.num_4 AS sp_num_4
,	sp.num_5 AS sp_num_5
,	sp.num_6 AS sp_num_6
,	sp.num_7 AS sp_num_7
,	sp.num_8 AS sp_num_8
,	sp.num_9 AS sp_num_9
,	sp.num_10 AS sp_num_10
,	sp.char_1 AS sp_char_1
,	sp.char_2 AS sp_char_2
,	sp.char_3 AS sp_char_3
,	sp.char_4 AS sp_char_4
,	sp.char_5 AS sp_char_5
,	sp.char_6 AS sp_char_6
,	sp.boolean_1 AS sp_boolean_1
,	sp.boolean_2 AS sp_boolean_2
,	sp.boolean_3 AS sp_boolean_3
,	sp.boolean_4 AS sp_boolean_4
,	sp.date_1 AS sp_date_1
,	sp.date_2 AS sp_date_2
,	sp.uom_id AS sp_uom_id
,	sp.attribute AS sp_attribute
,	sp.test_method AS sp_test_method
,	sp.characteristic AS sp_characteristic
,	sp.ch_2 AS sp_ch_2
,	sp.ch_3 AS sp_ch_3
,	pl.layout_id
,	pl.field_id
,   pl.header_id
,   pl.start_pos
,   pl.format_id
,	CASE	WHEN pl.field_id = 27  AND UPPER(h.description) = 'PROPERTY' THEN 0
			WHEN pl.field_id = 23  THEN 0	ELSE 1
	END AS field_relevance_bit
FROM tree       p            --FROM templateParts       p
JOIN specification_prop sp ON (	  sp.part_no			= p.part_no    --changed-p-to-t
                              AND sp.revision			= p.revision   --changed-p-to-t
                              )
-- Base columns per property-group or single property on layout fields
JOIN specification_section ss ON (   ss.part_no			= sp.part_no
                                 AND ss.revision		= sp.revision
                                 AND ss.section_id		= sp.section_id
                                 AND ss.section_rev		= sp.section_rev
                                 AND ss.sub_section_id	= sp.sub_section_id
                                 AND ss.sub_section_rev	= sp.sub_section_rev
                                 --AND ss.type			= t.type
                                 AND (	(ss.type = 1 AND ss.ref_id = sp.property_group)
                                     OR (ss.type = 4 AND ss.ref_id = sp.property)
                                     )
                                 )
JOIN property_layout pl ON (   pl.layout_id		= ss.display_format
                           AND pl.revision		= ss.display_format_rev
                           AND (  (pl.field_id = 1	 AND sp.num_1	IS NOT NULL			)
                               OR (pl.field_id = 2	 AND sp.num_2	IS NOT NULL			)
                               OR (pl.field_id = 3	 AND sp.num_3	IS NOT NULL			)
                               OR (pl.field_id = 4	 AND sp.num_4	IS NOT NULL			)
                               OR (pl.field_id = 5	 AND sp.num_5	IS NOT NULL			)
                               OR (pl.field_id = 6	 AND sp.num_6	IS NOT NULL			)
                               OR (pl.field_id = 7  AND sp.num_7	IS NOT NULL			)
							   OR (pl.field_id = 8	 AND sp.num_8	IS NOT NULL			)
							   OR (pl.field_id = 9  AND sp.num_9	IS NOT NULL			)
							   OR (pl.field_id = 10 AND sp.num_10	IS NOT NULL			)
							   OR (pl.field_id = 11 AND sp.char_1	IS NOT NULL			)
							   OR (pl.field_id = 12 AND sp.char_2	IS NOT NULL			)
							   OR (pl.field_id = 13 AND sp.char_3	IS NOT NULL			)
							   OR (pl.field_id = 14 AND sp.char_4	IS NOT NULL			)
							   OR (pl.field_id = 15 AND sp.char_5	IS NOT NULL			)
							   OR (pl.field_id = 16 AND sp.char_6	IS NOT NULL			)
							   OR (pl.field_id = 17 AND sp.boolean_1 <> 'N'				)
							   OR (pl.field_id = 18 AND sp.boolean_2 <> 'N'				)
							   OR (pl.field_id = 19 AND sp.boolean_3 <> 'N'				)
							   OR (pl.field_id = 20 AND sp.boolean_4 <> 'N'				)
							   OR (pl.field_id = 21 AND sp.date_1	IS NOT NULL			)
							   OR (pl.field_id = 22 AND sp.date_2	IS NOT NULL			)
							   OR (pl.field_id = 23 AND sp.uom_id	IS NOT NULL			)
							   OR (pl.field_id = 32 AND sp.test_method	<> 0			)
							   OR (pl.field_id = 26 AND sp.characteristic IS NOT NULL	)
							   OR (pl.field_id = 30 AND sp.ch_2	IS NOT NULL				)
							   OR (pl.field_id = 31 AND sp.ch_3	IS NOT NULL				)
							   OR (pl.field_id = 27)
	                           )
                            )
JOIN layout l ON (l.layout_id = pl.layout_id AND l.revision = pl.revision )
JOIN header h ON (h.header_id = pl.header_id)
WHERE NOT (  (  pl.field_id = 27  AND UPPER(h.description) = 'PROPERTY' )
             or (  pl.field_id = 23  )
	      )
)
SELECT bp.part_no                     
,   part.description AS part_descr
,bp.revision                    
,bp.item_number
,bp.branch       
,bp.section_sequence_no
,bp.ref_id
,bp.type
,bp.sequence_no
,bp.section_id
,	sc.description   AS section_descr
,bp.section_rev
,bp.sub_section_id
,	su.description   AS sub_section_descr
,bp.sub_section_rev
,bp.property_group
,	pg.description   AS property_group_descr
,bp.property
,	p.description    AS property_descr
,bp.pg_sequence_no
,bp.sp_num_1
,bp.sp_num_2
,bp.sp_num_3
,bp.sp_num_4
,bp.sp_num_5
,bp.sp_num_6
,bp.sp_num_7
,bp.sp_num_8
,bp.sp_num_9
,bp.sp_num_10
,bp.sp_char_1
,bp.sp_char_2
,bp.sp_char_3
,bp.sp_char_4
,bp.sp_char_5
,bp.sp_char_6
,bp.sp_boolean_1
,bp.sp_boolean_2
,bp.sp_boolean_3
,bp.sp_boolean_4
,bp.sp_date_1
,bp.sp_date_2
,bp.sp_uom_id
,	u.description    AS uom_descr
,bp.sp_attribute
,	a.description    AS attribute_descr
,bp.sp_test_method
,	tm.description   AS test_method_descr
,bp.sp_characteristic
,	ch.description   AS ch_1_descr
,bp.sp_ch_2
,	c2.description   AS ch_2_descr
,bp.sp_ch_3
,	c3.description   AS ch_3_descr
,bp.layout_id
,bp.field_id
,bp.header_id
,	h.description    AS header_descr
,bp.start_pos
,bp.format_id
,bp.field_relevance_bit
,	pc.description   AS property_descr2
,   bp.lvl           as lvl
FROM BoMProperties bp 
LEFT JOIN	part            ON (part.part_no      = bp.part_no)
JOIN section             sc ON (sc.section_id     = bp.section_id)
LEFT JOIN sub_section    su ON (su.sub_section_id = bp.sub_section_id AND bp.sub_section_id <> 0)
JOIN property_group      pg ON (pg.property_group = bp.property_group)
JOIN property             p ON (p.property        = bp.property)
JOIN header               h ON (h.header_id       = bp.header_id)
LEFT JOIN uom             u ON (bp.field_id = 23 AND u.uom_id             = bp.sp_uom_id)
LEFT JOIN attribute       a ON (bp.field_id = 24 AND a.attribute          = bp.sp_attribute)
LEFT JOIN test_method    tm ON (bp.field_id = 25 AND tm.test_method       = bp.sp_test_method)
LEFT JOIN characteristic ch ON (bp.field_id = 26 AND ch.characteristic_id = bp.sp_characteristic)
LEFT JOIN characteristic c2 ON (bp.field_id = 30 AND c2.characteristic_id = bp.sp_ch_2)
LEFT JOIN characteristic c3 ON (bp.field_id = 31 AND c3.characteristic_id = bp.sp_ch_3)
LEFT JOIN property       pc ON (bp.field_id = 27 AND pc.property          = bp.property)
;


/*
part_no                     
part_descr
revision                    
item_number
branch       
section_sequence_no
ref_id
type
sequence_no
section_id
section_descr
section_rev
sub_section_id
sub_section_descr
sub_section_rev
property_group
property_group_descr
property
property_descr
pg_sequence_no
sp_num_1
sp_num_2
sp_num_3
sp_num_4
sp_num_5
sp_num_6
sp_num_7
sp_num_8
sp_num_9
sp_num_10
sp_char_1
sp_char_2
sp_char_3
sp_char_4
sp_char_5
sp_char_6
sp_boolean_1
sp_boolean_2
sp_boolean_3
sp_boolean_4
sp_date_1
sp_date_2
sp_uom_id
uom_descr
sp_attribute
attribute_descr
sp_test_method
test_method_descr
sp_characteristic
ch_1_descr
sp_ch_2
ch_2_descr
sp_ch_3
ch_3_descr
layout_id
field_id
header_id
header_descr
start_pos
format_id
field_relevance_bit
property_descr2
*/


/*
SELECT f.*
 ,	part.description AS part_description
 ,	weight.weight
 ,  weight.uom       AS weight_uom
 FROM tree f
 LEFT JOIN	part ON (part.part_no = f.part_no)
 LEFT JOIN avspecification_weight weight ON (weight.part_no = f.part_no)
 ORDER BY  f.item_number
 --ORDER BY  f.hierarchy,         f.functiongrp,         f.item_number
 ;

--WHERE bp.section_id <> &S_CONFIG

*/


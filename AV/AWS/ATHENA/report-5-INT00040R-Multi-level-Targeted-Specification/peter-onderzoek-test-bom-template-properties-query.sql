--QUERY TO RETRIEVE ALL TEMPLATE-PROPERTIES DEFINED IN THE TEMPLATE 
--THESE ARE THE BASE OF THE QUERY TO RETRIEVE THE PART-NO-PROPERTIES ...

--research: 'XGG_BF66A17J1'

/*
--with relation to TEMPLATEBOM BASED ON TEMPLATE-PART-NO:	ZZ_RnD_PCR_GTX !!!!!!!!!!!!
--
XGG_BF66A17J1	2	CURRENT	XGG_BF66A17J1		2	CURRENT	Greentyre						0			0	XGG_BF66A17J1	ZZ_RnD_PCR_GTX	PCR GREEN TYRE SPECIFICATION-FLIPPER	ZZ_RnD_PCR_GTX	8	PCR GREEN TYRE SPECIFICATION-FLIPPER	1	1	Greentyre	Greentyre	Greentyre	%Greentyre		1	1	pcs																			1			Greentyre BMW F66A17	8.47570444	KG
XGG_BF66A17J1	2	CURRENT	XGS_WBTV120TN		1	CURRENT	Greentyre.Sidewall L/R			10	0010	1	XGS_WBTV120TN	ZZ_RnD_PCR_GTX	PCR GREEN TYRE SPECIFICATION-FLIPPER	ZZ_RnD_PCRSW	3	PCR SIDEWALL	10	1.0.01	Sidewall L/R	Sidewall L/R	Sidewall L/R	%Sidewall L/R		1.312		m													0	0	0	0	903394		1.312			B-120 Thin GM_R5026/GM_Z5020	0.702	KG
XGG_BF66A17J1	2	CURRENT	XGL_LAQ1360F360N	1	CURRENT	Greentyre.Innerliner assembly	20	0020	1	XGL_LAQ1360F360N	ZZ_RnD_PCR_GTX	PCR GREEN TYRE SPECIFICATION-FLIPPER	ZZ_RnD_PCR_IL	2	Template PCR production BoM	20	1.0.02	Innerliner 	Innerliner assembly	Innerliner	%Innerliner assembly		1.312		m													0	0	0	0	903345		1.312			LAQ1-360-F360 - GM_L2002 / GM_B1054	0.655	KG
XGG_BF66A17J1	2	CURRENT	XGR_PK08490L80		1	CURRENT	Greentyre.Ply 1					90	0090	1	XGR_PK08490L80	ZZ_RnD_PCR_GTX	PCR GREEN TYRE SPECIFICATION-FLIPPER	ZZ_RnD_PLYV1	3	PCR BODY PLY 	30	1.0.03	Body Ply 1	Ply 1	Body Ply 1	%Ply 1		1.323		m													0	0	0	0	903320		1.323			PK08-90-490 - Ply with XGX_L170 gum B1008	0.742238	KG
XGG_BF66A17J1	2	CURRENT	XGR_WR01450085		3	CURRENT	Greentyre.Flipper L				40	0040	1	XGR_WR01450085	ZZ_RnD_PCR_GTX	PCR GREEN TYRE SPECIFICATION-FLIPPER	ZZ_RnD_FLIPPER_X	2	PCR FLIPPER 	45	1.0.045	Flipper L	Flipper L	Flipper L	%Flipper L		1		m													0	0	0	0	688		1			RL01-45-85 Rayon Flipper	0.136	KG
XGG_BF66A17J1	2	CURRENT	XGR_WR01450085		3	CURRENT	Greentyre.Flipper R				50	0050	1	XGR_WR01450085	ZZ_RnD_PCR_GTX	PCR GREEN TYRE SPECIFICATION-FLIPPER	ZZ_RnD_FLIPPER_X	2	PCR FLIPPER 	48	1.0.048	Flipper R	Flipper R	Flipper R	%Flipper R		1		m													0	0	0	0	689		1			RL01-45-85 Rayon Flipper	0.136	KG
XGG_BF66A17J1	2	CURRENT	XGB_AH138700124543	1	CURRENT	Greentyre.Bead apex				110	0110	1	XGB_AH138700124543	ZZ_RnD_PCR_GTX	PCR GREEN TYRE SPECIFICATION-FLIPPER	ZZ_RnD_PCR_BEADAPE	2	Template Bead Apex	50	1.0.05	Bead apex	Bead apex	Bead apex	%Bead apex		2		pcs													0	0	0	0	903323		2			17" 4-5-4-3 Filler 12mm A4012	0.32	KG
XGG_BF66A17J1	2	CURRENT	XGR_GSA1327195		1	CURRENT	Greentyre.Belt 1				120	0120	1	XGR_GSA1327195	ZZ_RnD_PCR_GTX	PCR GREEN TYRE SPECIFICATION-FLIPPER	ZZ_RnD_BELT1PCR	7	Test new mask functionality BELT Material	60	1.0.06	Belt 1	Belt 1	Belt 1	%Belt 1		1.838		m													0	0	0	0	903316		1.838			SA13-27-195 Top gum 0.5x20 (2x)	0.438138	KG
XGG_BF66A17J1	2	CURRENT	XGR_NSA1327185		3	CURRENT	Greentyre.Belt 2				130	0130	1	XGR_NSA1327185	ZZ_RnD_PCR_GTX	PCR GREEN TYRE SPECIFICATION-FLIPPER	ZZ_RnD_BELT1PCR	7	Test new mask functionality BELT Material	70	1.0.07	Belt 2	Belt 2	Belt 2	%Belt 2		1.845		m													0	0	0	0	903317		1.845			SA13-27-185-No Gum	0.390905	KG
XGG_BF66A17J1	2	CURRENT	GR_NB01000012		7	CURRENT	Greentyre.Capstrip				140	0140	1	GR_NB01000012	ZZ_RnD_PCR_GTX	PCR GREEN TYRE SPECIFICATION-FLIPPER	ZZ_RnD_PLYV1	3	PCR BODY PLY 	80	1.0.08	Capstrip	Capstrip	Capstrip	%Capstrip		31.44		m													0	0	0	0	903372		31.44			NB01 Capstrip 12 mm	0.00948	KG
XGG_BF66A17J1	2	CURRENT	XGT_PSTBF66A17D2	4	CURRENT	Greentyre.Tread					150	0150	1	XGT_PSTBF66A17D2	ZZ_RnD_PCR_GTX	PCR GREEN TYRE SPECIFICATION-FLIPPER	ZZ_RnD_TREADPCR	13	Test new mask functionality- PCR TREAD METERS	90	1.0.09	Tread	Tread	Tread	%Tread		1.857		m													0	0	0	0	903311		1.857			TREAD BF66AS17 B220 SB190 GMST7022/T3008/T3030	1.603	KG
*/


--REFINED-VIEW MAKE VALUES CONCRETE 

--
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
 AND t.lvl          <= 1                        --FOC_NONE
 AND t.revision     IS NOT NULL
 AND t.function     IS NOT NULL 
 AND t.function     NOT LIKE '%FOC_NONE'
) CYCLE part_no SET e_cyclic TO '1' DEFAULT '0'
,templateBoM 
(   tpl_root_part
 ,  tpl_root_revision
 ,  tpl_root_description
 ,	tpl_part_no, tpl_revision
 ,	tpl_description
 ,	tpl_frame_id, tpl_frame_rev
 ,	tpl_item_number
 ,	hierarchy
 ,	function_description
 ,	function_code
 ,	functiongrp
 ,	mask
 ,	lvl
 ) AS 
(SELECT sh.part_no
 ,  sh.revision
 ,	sh.description
 ,	sh.part_no, sh.revision
 ,	sh.description
 ,	sh.frame_id, sh.frame_rev
 ,	1
 ,	'1'
 ,	(SELECT kw_value FROM root_function WHERE part_no = sh.part_no)
 ,	(SELECT kw_value FROM root_function WHERE part_no = sh.part_no)
 ,	(SELECT kw_value FROM root_function WHERE part_no = sh.part_no)
 ,	'%' || (SELECT kw_value FROM root_function WHERE part_no = sh.part_no)
 ,	0
 FROM specification_header sh
 JOIN status                s ON (s.status = sh.status)
 WHERE sh.part_no    = 'ZZ_RnD_PCR_GTX'               --'NONE'   --SELECTED TEMPLATE-PART-NO FROM REPORT-TOP-FILTER!!!!!!!!!!!!!!!!!!
 AND   s.status_type = 'CURRENT'
 UNION ALL
 SELECT t.tpl_root_part
 ,  t.tpl_root_revision
 ,  t.tpl_root_description
 ,	bi.component_part
 ,	bish.revision
 ,	bish.description
 ,	bish.frame_id, bish.frame_rev
 ,	bi.item_number
 ,	'1.' || coalesce(bi.char_1, '0.' || to_char(bi.item_number, 'FM0999'))
 ,	bi.char_2
 ,	bic.description
 ,	bi.char_3
 ,	bi.char_4
 ,	t.lvl +1
 FROM templateBoM t
 JOIN bom_item                    bi ON (bi.part_no = t.tpl_part_no and bi.revision = t.tpl_revision)
 LEFT JOIN specification_header bish ON (bish.part_no = bi.component_part)
 LEFT JOIN status                bis ON (bis.status = bish.status)
 LEFT JOIN characteristic        bic ON (bic.characteristic_id = bi.ch_1)
 WHERE bis.status_type = 'CURRENT'
 )
, filtered 
(   root_part
 ,  root_rev
 ,  root_status
 ,	part_no
 ,  revision
 ,  status_type
 ,	breadcrumbs
 ,  item_number
 ,	branch
 ,  lvl
 ,  indentPart
 ,	tpl_root_part
 ,  tpl_root_description
 ,	tpl_part_no
 ,  tpl_revision
 ,  tpl_description
 ,  tpl_item_number
 ,	hierarchy
 ,  functiongrp
 ,  function_code
 ,  function_description
 ,  mask
 ,	phr
 ,  quantity
 ,  density
 ,  uom
 ,	num_1, num_2, num_3, num_4, num_5
 ,	char_1, char_2, char_3, char_4, char_5
 ,	date_1, date_2
 ,	boolean_1, boolean_2, boolean_3, boolean_4
 ,	ch_1, ch_2
 ,	normalized_quantity
 ,	component_kg
 ,  assembly_kg
 ) AS
(SELECT p.part_no
 ,  p.revision
 ,  p.status_type
 ,	p.part_no
 ,  p.revision
 ,  p.status_type
 ,	r.kw_value
 ,  0
 ,	NULL
 ,  0
 ,  p.part_no
 ,	tpl.tpl_root_part
 ,  tpl.tpl_root_description
 ,	tpl.tpl_part_no
 ,  tpl.tpl_revision
 ,  tpl.tpl_description
 ,  tpl.tpl_item_number
 ,	tpl.hierarchy
 ,  tpl.functiongrp
 ,  tpl.function_code
 ,  tpl.function_description
 ,  tpl.mask
 ,	NULL, 1.0, 1.0, 'pcs'
 ,	NULL, NULL, NULL, NULL, NULL
 ,	NULL, NULL, NULL, NULL, NULL
 ,	NULL, NULL
 ,	NULL, NULL, NULL, NULL
 ,	NULL, NULL
 ,	1.0
 ,	NULL, NULL
 FROM partList p
 JOIN root_function r ON (r.part_no = p.part_no)
 JOIN templateBoM tpl ON (tpl.lvl = 0)
 UNION ALL
 SELECT tree.root_part
 ,  tree.root_rev
 ,  tree.root_status_type
 ,	tree.part_no
 ,  tree.revision
 ,  tree.status_type
 ,	tree.breadcrumbs
 ,  tree.item_number
 ,	tree.branch
 ,  tree.lvl
 ,  tree.indentStr || tree.part_no
 ,	tpl.tpl_root_part
 ,  tpl.tpl_root_description
 ,	tpl.tpl_part_no
 ,  tpl.tpl_revision
 ,  tpl.tpl_description
 ,  tpl.tpl_item_number
 ,	tpl.hierarchy
 ,  tpl.functiongrp
 ,  tpl.function_code
 ,  tpl.function_description
 ,  tpl.mask
 ,	tree.phr
 ,  tree.quantity
 ,  tree.density
 ,  tree.uom
 ,	tree.num_1, tree.num_2, tree.num_3, tree.num_4, tree.num_5
 ,	tree.char_1, tree.char_2, tree.char_3, tree.char_4, tree.char_5
 ,	tree.date_1, tree.date_2
 ,	tree.boolean_1, tree.boolean_2, tree.boolean_3, tree.boolean_4
 ,	tree.ch_1, tree.ch_2
 ,	tree.normalized_quantity
 ,	tree.component_kg
 ,  tree.assembly_kg
 FROM tree                                                 --recursive-loop through BOM of selected-part-no !!!!!!
 JOIN templateBoM tpl ON (tree.breadcrumbs LIKE tpl.mask)
 WHERE EXISTS ( SELECT 1
                FROM bom_header     node
                WHERE node.part_no		= tree.part_no
                AND node.revision		= tree.revision
                AND node.alternative	= tree.alternative
                AND node.plant	        = tree.plant
                )
 )
-- SELECT f.*
-- ,	part.description AS part_description
-- ,	weight.weight
-- ,  weight.uom       AS weight_uom
-- FROM filtered f
-- LEFT JOIN	part ON (part.part_no = f.part_no)
-- LEFT JOIN avspecification_weight weight ON (weight.part_no = f.part_no)
-- ORDER BY  
-- f.hierarchy
-- ,         f.functiongrp
-- ,         f.item_number
--WITH template AS (                                                --template-QUERY
SELECT t.tpl_part_no
			,   t.tpl_revision
         	,	sh.frame_id             AS tpl_frame_id
         	,	sp.sequence_no
			,   sp.section_id
			,   sp.sub_section_id
			,   sp.property_group
			,   sp.property
         	,	fs.type
         	,	pl.layout_id
			,   pl.field_id
			,   pl.header_id
         	,	pl.start_pos               AS tpl_start_pos
           	,	sp.num_1, sp.num_2, sp.num_3, sp.num_4, sp.num_5
         	,	sp.num_6, sp.num_7, sp.num_8, sp.num_9, sp.num_10
         	,	sp.char_1, sp.char_2, sp.char_3, sp.char_4, sp.char_5, sp.char_6
         	,	sp.date_1, sp.date_2
         	,	sp.boolean_1, sp.boolean_2, sp.boolean_3, sp.boolean_4
         	,	sp.characteristic, sp.ch_2, sp.ch_3
          	,	decode(pl.field_id
         		, 1, sp.num_1
         		, 2, sp.num_2
         		, 3, sp.num_3
         		, 4, sp.num_4
         		, 5, sp.num_5
         		, 6, sp.num_6
         		, 7, sp.num_7
         		, 8, sp.num_8
         		, 9, sp.num_9
         		, 10, sp.num_10
         		, NULL
         		) AS tpl_num
         	,	decode(pl.field_id
         		, 11, sp.char_1
         		, 12, sp.char_2
         		, 13, sp.char_3
         		, 14, sp.char_4
         		, 15, sp.char_5
         		, 16, sp.char_6
         		, NULL
         		) AS tpl_char
         	,	decode(pl.field_id
         		, 21, sp.date_1
         		, 22, sp.date_2
         		, NULL
         		) AS tpl_date
         	,	decode(pl.field_id
         		, 17, sp.boolean_1
         		, 18, sp.boolean_2
         		, 19, sp.boolean_3
         		, 20, sp.boolean_4
         		, NULL
         		) AS tpl_boolean
         	,	decode(pl.field_id
         		, 26, sp.characteristic
         		, 30, sp.ch_2
         		, 31, sp.ch_3
         		, NULL
         		) AS tpl_association
         	,	sp.uom_id AS tpl_uom_id
         	,	NULLIF(sp.test_method, 0) AS tpl_test_method
         	,	CASE WHEN pl.field_id = 23 THEN 0
                                           ELSE 1
         		END AS tpl_field_relevance_bit
         	  FROM filtered t
         	  JOIN specification_header sh ON (sh.part_no = t.tpl_part_no AND sh.revision = t.tpl_revision )
         	  JOIN specification_prop   sp ON (sp.part_no = sh.part_no    AND sp.revision = sh.revision)
              -- Base columns per property-group or single property on layout fields
         	  JOIN specification_section fs ON (    fs.part_no			= sh.part_no
         	                                   	AND fs.revision			= sh.revision
         	                                   	AND fs.section_id		= sp.section_id
         	                                   	AND fs.section_rev		= sp.section_rev
         	                                   	AND fs.sub_section_id	= sp.sub_section_id
         	                                   	AND fs.sub_section_rev	= sp.sub_section_rev
         	                                   	AND (   (  fs.type = 1  AND fs.ref_id = sp.property_group)
                                                       OR (fs.type = 4  AND fs.ref_id = sp.property)
                                                       )
        	                                    )
         	  JOIN property_layout pl ON ( pl.layout_id	= fs.display_format  AND pl.revision = fs.display_format_rev )
              -- Filter out irrelevant and empty fields
         	  JOIN layout l ON ( l.layout_id = pl.layout_id AND l.revision = pl.revision )
          	 WHERE (  (pl.field_id = 1	AND sp.num_1	IS NOT NULL)
         	       OR (pl.field_id = 2	AND sp.num_2	IS NOT NULL)
         	       OR (pl.field_id = 3	AND sp.num_3	IS NOT NULL)
         	       OR (pl.field_id = 4	AND sp.num_4	IS NOT NULL)
         	       OR (pl.field_id = 5	AND sp.num_5	IS NOT NULL)
         	       OR (pl.field_id = 6	AND sp.num_6	IS NOT NULL)
         	       OR (pl.field_id = 7	AND sp.num_7	IS NOT NULL)
         	       OR (pl.field_id = 8	AND sp.num_8	IS NOT NULL)
         	       OR (pl.field_id = 9	AND sp.num_9	IS NOT NULL)
         	       OR (pl.field_id = 10	AND sp.num_10	IS NOT NULL)
         	       OR (pl.field_id = 11	AND sp.char_1	IS NOT NULL AND sp.char_1 <> 'XXXX')
         	       OR (pl.field_id = 12	AND sp.char_2	IS NOT NULL AND sp.char_2 <> 'XXXX')
         	       OR (pl.field_id = 13	AND sp.char_3	IS NOT NULL AND sp.char_3 <> 'XXXX')
         	       OR (pl.field_id = 14	AND sp.char_4	IS NOT NULL AND sp.char_4 <> 'XXXX')
         	       OR (pl.field_id = 15	AND sp.char_5	IS NOT NULL AND sp.char_5 <> 'XXXX')
         	       OR (pl.field_id = 16	AND sp.char_6	IS NOT NULL AND sp.char_6 <> 'XXXX')
         	       OR (pl.field_id = 17	AND sp.boolean_1 <> 'N')
         	       OR (pl.field_id = 18	AND sp.boolean_2 <> 'N')
         	       OR (pl.field_id = 19	AND sp.boolean_3 <> 'N')
         	       OR (pl.field_id = 20	AND sp.boolean_4 <> 'N')
         	       OR (pl.field_id = 21	AND sp.date_1	IS NOT NULL)
         	       OR (pl.field_id = 22	AND sp.date_2	IS NOT NULL)
         	       OR (pl.field_id = 23	AND sp.uom_id	IS NOT NULL)
         	       OR (pl.field_id = 32	AND sp.test_method	<> 0)
         	       OR (pl.field_id = 26	AND sp.characteristic	IS NOT NULL)
         	       OR (pl.field_id = 30	AND sp.ch_2	IS NOT NULL)
         	       OR (pl.field_id = 31	AND sp.ch_3	IS NOT NULL)
         		   --OR (pl.field_id = 27 )
         	)
;

--OUTPUT OF ALL TEMPLATE-PART-NO-PROPERTIES FILLED WITH A "1" IF IT IS USED FOR THE REPORT..
/*
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	200	700584	0	701557	705244	1	703829	19	701633	4																			N	N	Y	N							Y				1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	100	700584	0	701557	705632	1	703829	19	701633	4																			N	N	Y	N							Y				1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	300	700584	0	701557	706588	1	703829	19	701633	4																			N	N	Y	N							Y				1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	100	700584	0	701564	703508	1	701928	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	100	700584	0	701564	703508	1	701928	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	200	700584	0	701564	705408	1	701928	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	200	700584	0	701564	705408	1	701928	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	400	700584	0	701564	705642	1	701928	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	400	700584	0	701564	705642	1	701928	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	300	700584	0	701564	705668	1	701928	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	300	700584	0	701564	705668	1	701928	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	500	700584	0	701564	706128	1	701928	1	700498	3	1																		N	N	N	N				1							1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	300	700584	0	703816	707770	1	703828	17	701632	2																			Y	Y	N	N							Y				1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	300	700584	0	703816	707770	1	703828	18	701633	3																			Y	Y	N	N							Y				1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	200	700584	0	703816	712210	1	703828	17	701632	2																			Y	Y	N	N							Y				1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	200	700584	0	703816	712210	1	703828	18	701633	3																			Y	Y	N	N							Y				1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	100	700584	0	703816	712211	1	703828	17	701632	2																			Y	Y	N	N							Y				1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	100	700584	0	703816	712211	1	703828	18	701633	3																			Y	Y	N	N							Y				1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	400	700584	0	703816	712213	1	703828	17	701632	2																			Y	Y	N	N							Y				1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	400	700584	0	703816	712213	1	703828	18	701633	3																			Y	Y	N	N							Y				1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	100	700584	0	704760	708147	1	702128	23	700010	2		1	1																N												700573		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	100	700584	0	704760	708147	1	702128	2	700951	4		1	1																N							1					700573		1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	100	700584	0	704760	708147	1	702128	3	700952	5		1	1																N							1					700573		1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	100	701058	700542	704000	707088	1	702068	23	700010	2	1																		N	N	N	N									701009		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	100	701058	700542	704000	707088	1	702068	1	700511	3	1																		N	N	N	N				1					701009		1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	500	701058	700542	704000	707092	1	702068	1	700511	3	1																		N	N	N	N				1							1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	600	701058	700542	704000	707096	1	702068	23	700010	2	1																		N	N	N	N									701009		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	600	701058	700542	704000	707096	1	702068	1	700511	3	1																		N	N	N	N				1					701009		1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	700	701058	700542	704000	707097	1	702068	23	700010	2	1																		N	N	N	N									701009		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	700	701058	700542	704000	707097	1	702068	1	700511	3	1																		N	N	N	N				1					701009		1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	200	701058	700542	704000	707751	1	702068	23	700010	2	1																		N	N	N	N									701009		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	200	701058	700542	704000	707751	1	702068	1	700511	3	1																		N	N	N	N				1					701009		1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	300	701058	700542	704000	712428	1	702068	23	700010	2	1																		N	N	N	N									701009		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	300	701058	700542	704000	712428	1	702068	1	700511	3	1																		N	N	N	N				1					701009		1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	400	701058	700542	704000	712429	1	702068	23	700010	2	1																		N	N	N	N									701009		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	400	701058	700542	704000	712429	1	702068	1	700511	3	1																		N	N	N	N				1					701009		1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	800	701058	700542	704000	712430	1	702068	1	700511	3	1																		N	N	N	N				1							1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	900	701058	700542	704000	712553	1	702068	1	700511	3	1																		N	N	N	N				1							1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	1000	701058	700542	704000	713739	1	702068	1	700511	3	1																		N	N	N	N				1							1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	1500	701058	700542	704660	716647	1	704793	23	700010	2																															700649		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	1600	701058	700542	704660	716648	1	704793	23	700010	2																															700649		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	100	701058	700542	701567	705222	1	701749	1	700840	2	1	1	1	1															N	N	N	N				1							1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	100	701058	700542	701567	705222	1	701749	2	700841	3	1	1	1	1															N	N	N	N				1							1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	100	701058	700542	701567	705222	1	701749	3	700842	4	1	1	1	1															N	N	N	N				1							1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	100	701058	700542	701567	705222	1	701749	4	700843	5	1	1	1	1															N	N	N	N				1							1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	200	701058	700542	701567	705223	1	701749	1	700840	2	1	1	1	1															N	N	N	N				1							1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	200	701058	700542	701567	705223	1	701749	2	700841	3	1	1	1	1															N	N	N	N				1							1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	200	701058	700542	701567	705223	1	701749	3	700842	4	1	1	1	1															N	N	N	N				1							1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	200	701058	700542	701567	705223	1	701749	4	700843	5	1	1	1	1															N	N	N	N				1							1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	300	701058	700542	701567	705224	1	701749	1	700840	2	1	1	1	1															N	N	N	N				1							1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	300	701058	700542	701567	705224	1	701749	2	700841	3	1	1	1	1															N	N	N	N				1							1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	300	701058	700542	701567	705224	1	701749	3	700842	4	1	1	1	1															N	N	N	N				1							1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	300	701058	700542	701567	705224	1	701749	4	700843	5	1	1	1	1															N	N	N	N				1							1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	400	701058	700542	701567	705225	1	701749	1	700840	2	1	1	1	1															N	N	N	N				1							1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	400	701058	700542	701567	705225	1	701749	2	700841	3	1	1	1	1															N	N	N	N				1							1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	400	701058	700542	701567	705225	1	701749	3	700842	4	1	1	1	1															N	N	N	N				1							1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	400	701058	700542	701567	705225	1	701749	4	700843	5	1	1	1	1															N	N	N	N				1							1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	500	701058	700542	701567	705226	1	701749	1	700840	2	1	1	1	1															N	N	N	N				1							1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	500	701058	700542	701567	705226	1	701749	2	700841	3	1	1	1	1															N	N	N	N				1							1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	500	701058	700542	701567	705226	1	701749	3	700842	4	1	1	1	1															N	N	N	N				1							1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	500	701058	700542	701567	705226	1	701749	4	700843	5	1	1	1	1															N	N	N	N				1							1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	600	701058	700542	701567	705227	1	701749	1	700840	2	1	1	11	1															N	N	N	N				1							1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	600	701058	700542	701567	705227	1	701749	2	700841	3	1	1	11	1															N	N	N	N				1							1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	600	701058	700542	701567	705227	1	701749	3	700842	4	1	1	11	1															N	N	N	N				11							1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	600	701058	700542	701567	705227	1	701749	4	700843	5	1	1	11	1															N	N	N	N				1							1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	700	701058	700542	701567	705228	1	701749	1	700840	2	1	1	1	1															N	N	N	N				1							1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	700	701058	700542	701567	705228	1	701749	2	700841	3	1	1	1	1															N	N	N	N				1							1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	700	701058	700542	701567	705228	1	701749	3	700842	4	1	1	1	1															N	N	N	N				1							1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	700	701058	700542	701567	705228	1	701749	4	700843	5	1	1	1	1															N	N	N	N				1							1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	100	701058	702449	701556	703452	1	701928	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	100	701058	702449	701556	703452	1	701928	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	200	701058	702449	701556	703514	1	701928	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	200	701058	702449	701556	703514	1	701928	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	300	701058	702449	701556	705207	1	701928	23	700010	2																			N	N	N	N									700569		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	1400	701058	702449	701556	705220	1	701928	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	1400	701058	702449	701556	705220	1	701928	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	1500	701058	702449	701556	705221	1	701928	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	1500	701058	702449	701556	705221	1	701928	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	600	701058	702449	701556	705231	1	701928	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	600	701058	702449	701556	705231	1	701928	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	500	701058	702449	701556	705286	1	701928	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	500	701058	702449	701556	705286	1	701928	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	700	701058	702449	701556	705630	1	701928	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	700	701058	702449	701556	705630	1	701928	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	1100	701058	702449	701556	705639	1	701928	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	1100	701058	702449	701556	705639	1	701928	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	800	701058	702449	701556	705647	1	701928	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	800	701058	702449	701556	705647	1	701928	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	1300	701058	702449	701556	707208	1	701928	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	1300	701058	702449	701556	707208	1	701928	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	400	701058	702449	701556	713523	1	701928	23	700010	2																			N	N	N	N									700569		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	900	701058	702449	701556	713524	1	701928	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	900	701058	702449	701556	713524	1	701928	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	1000	701058	702449	701556	713644	1	701928	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	1000	701058	702449	701556	713644	1	701928	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	1200	701058	702449	701556	713743	1	701928	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	1200	701058	702449	701556	713743	1	701928	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	1600	701058	702449	701556	715442	1	701928	23	700010	2																			N												700649		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	800	701058	702449	701570	703413	1	704793	11	700511	3											1																1						1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	700	701058	702449	701570	703876	1	704793	11	700511	3											1																1						1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	200	701058	702449	701570	705030	1	704793	11	700511	3											1																1						1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	100	701058	702449	701570	713522	1	704793	11	700511	3											1																1						1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	300	701058	702449	701570	713740	1	704793	11	700511	3											1																1						1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	400	701058	702449	701570	713741	1	704793	11	700511	3											1																1						1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	500	701058	702449	701570	713742	1	704793	11	700511	3											1																1						1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	900	701058	702449	701570	713745	1	704793	11	700511	3											1																1						1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	1000	701058	702449	701570	715667	1	704793	11	700511	3											1																1						1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	700	701058	702449	704284	707090	1	704393	26	701411	5	1										1								N	N	N	N	903605		903628					903605			1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	700	701058	702449	704284	707090	1	704393	1	702024	6	1										1								N	N	N	N	903605		903628	1							1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	700	701058	702449	704284	707090	1	704393	11	702028	9	1										1								N	N	N	N	903605		903628		1						1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	700	701058	702449	704284	707090	1	704393	31	702133	8	1										1								N	N	N	N	903605		903628					903628			1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	800	701058	702449	704284	707091	1	704393	26	701411	5	1										1								N	N	N	N	903605		903628					903605			1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	800	701058	702449	704284	707091	1	704393	1	702024	6	1										1								N	N	N	N	903605		903628	1							1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	800	701058	702449	704284	707091	1	704393	11	702028	9	1										1								N	N	N	N	903605		903628		1						1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	800	701058	702449	704284	707091	1	704393	31	702133	8	1										1								N	N	N	N	903605		903628					903628			1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	1000	701058	702449	704284	707097	1	704393	26	701411	5	1										11								N	N	N	N	903605		903628					903605			1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	1000	701058	702449	704284	707097	1	704393	1	702024	6	1										11								N	N	N	N	903605		903628	1							1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	1000	701058	702449	704284	707097	1	704393	11	702028	9	1										11								N	N	N	N	903605		903628		11						1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	1000	701058	702449	704284	707097	1	704393	31	702133	8	1										11								N	N	N	N	903605		903628					903628			1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	300	701058	702449	704284	712428	1	704393	26	701411	5	1										1								N	N	N	N	903605		903628					903605			1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	300	701058	702449	704284	712428	1	704393	1	702024	6	1										1								N	N	N	N	903605		903628	1							1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	300	701058	702449	704284	712428	1	704393	11	702028	9	1										1								N	N	N	N	903605		903628		1						1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	300	701058	702449	704284	712428	1	704393	31	702133	8	1										1								N	N	N	N	903605		903628					903628			1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	400	701058	702449	704284	712429	1	704393	1	702024	6	1																									1							1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	200	701058	702449	704284	714435	1	704393	26	701411	5	1										1								N	N	N	N	903605		903628					903605			1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	200	701058	702449	704284	714435	1	704393	1	702024	6	1										1								N	N	N	N	903605		903628	1							1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	200	701058	702449	704284	714435	1	704393	11	702028	9	1										1								N	N	N	N	903605		903628		1						1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	200	701058	702449	704284	714435	1	704393	31	702133	8	1										1								N	N	N	N	903605		903628					903628			1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	600	701058	702449	704284	714436	1	704393	26	701411	5	1										1								N	N	N	N	903605		903628					903605			1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	600	701058	702449	704284	714436	1	704393	1	702024	6	1										1								N	N	N	N	903605		903628	1							1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	600	701058	702449	704284	714436	1	704393	11	702028	9	1										1								N	N	N	N	903605		903628		1						1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	600	701058	702449	704284	714436	1	704393	31	702133	8	1										1								N	N	N	N	903605		903628					903628			1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	100	701058	702449	704284	714661	1	704393	26	701411	5	1										1								N	N	N	N	903605		903628					903605			1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	100	701058	702449	704284	714661	1	704393	1	702024	6	1										1								N	N	N	N	903605		903628	1							1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	100	701058	702449	704284	714661	1	704393	11	702028	9	1										1								N	N	N	N	903605		903628		1						1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	100	701058	702449	704284	714661	1	704393	31	702133	8	1										1								N	N	N	N	903605		903628					903628			1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	900	701058	702449	704284	714662	1	704393	26	701411	5	1										1								N	N	N	N	903605		903628					903605			1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	900	701058	702449	704284	714662	1	704393	1	702024	6	1										1								N	N	N	N	903605		903628	1							1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	900	701058	702449	704284	714662	1	704393	11	702028	9	1										1								N	N	N	N	903605		903628		1						1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	900	701058	702449	704284	714662	1	704393	31	702133	8	1										1								N	N	N	N	903605		903628					903628			1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	100	701058	702449	704500	715189	1	704795	23	700010	2																			N												700649		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	200	701058	702449	704500	715191	1	704795	23	700010	2																			N												700649		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	300	701058	702449	704500	715192	1	704795	23	700010	2																			N												700649		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	400	701058	702449	704500	715193	1	704795	23	700010	2																			N												700649		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	500	701058	702449	704500	715194	1	704795	23	700010	2																			N												700649		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	100	701058	702449	704501	715190	1	704795	23	700010	2																			N												700649		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	200	701058	702449	704501	715195	1	704795	23	700010	2																			N												700649		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	300	701058	702449	704501	715196	1	704795	23	700010	2																			N												700649		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	400	701058	702449	704501	715198	1	704795	23	700010	2																			N												700649		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	500	701058	702449	704501	715199	1	704795	23	700010	2																			N												700649		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	600	701058	702449	704501	715200	1	704795	23	700010	2																			N												700649		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	700	701058	702449	704501	715201	1	704795	23	700010	2																			N												700649		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	800	701058	702449	704501	715202	1	704795	23	700010	2																			N												700649		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	900	701058	702449	704501	717313	1	704795	23	700010	2																			N												700649		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	1000	701058	702449	704501	717314	1	704795	23	700010	2																			N												700649		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	100	701058	702449	704502	715187	1	701928	23	700010	2																			N												700649		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	200	701058	702449	704502	715188	1	701928	23	700010	2																			N												700581		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	100	701058	702449	0	705238	4	700930	11	700511	2											1								N	N	N	N					1						1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	100	701058	702622	701556	703452	1	701928	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	100	701058	702622	701556	703452	1	701928	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	200	701058	702622	701556	703514	1	701928	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	200	701058	702622	701556	703514	1	701928	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	300	701058	702622	701556	705207	1	701928	23	700010	2	1																		N	N	N	N									700569		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	300	701058	702622	701556	705207	1	701928	1	700498	3	1																		N	N	N	N				1					700569		1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	1400	701058	702622	701556	705220	1	701928	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	1400	701058	702622	701556	705220	1	701928	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	1500	701058	702622	701556	705221	1	701928	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	1500	701058	702622	701556	705221	1	701928	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	600	701058	702622	701556	705231	1	701928	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	600	701058	702622	701556	705231	1	701928	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	500	701058	702622	701556	705286	1	701928	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	500	701058	702622	701556	705286	1	701928	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	700	701058	702622	701556	705630	1	701928	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	700	701058	702622	701556	705630	1	701928	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	1100	701058	702622	701556	705639	1	701928	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	1100	701058	702622	701556	705639	1	701928	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	800	701058	702622	701556	705647	1	701928	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	800	701058	702622	701556	705647	1	701928	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	1300	701058	702622	701556	707208	1	701928	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	1300	701058	702622	701556	707208	1	701928	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	400	701058	702622	701556	713523	1	701928	23	700010	2	1																		N	N	N	N									700569		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	400	701058	702622	701556	713523	1	701928	1	700498	3	1																		N	N	N	N				1					700569		1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	1600	701058	702622	701556	715442	1	701928	23	700010	2																			N												700649		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	900	701058	702622	701556	716869	1	701928	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	900	701058	702622	701556	716869	1	701928	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	1000	701058	702622	701556	716889	1	701928	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	1000	701058	702622	701556	716889	1	701928	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	1200	701058	702622	701556	716890	1	701928	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	1200	701058	702622	701556	716890	1	701928	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	800	701058	702622	701570	703413	1	700930	11	700511	2											1								N	N	N	N					1						1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	700	701058	702622	701570	703876	1	700930	11	700511	2											1								N	N	N	N					1						1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	200	701058	702622	701570	705030	1	700930	11	700511	2											1								N	N	N	N					1						1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	600	701058	702622	701570	705628	1	700930	11	700511	2											1								N	N	N	N					1						1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	100	701058	702622	701570	713522	1	700930	11	700511	2											1								N	N	N	N					1						1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	300	701058	702622	701570	713740	1	700930	11	700511	2											1								N	N	N	N					1						1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	400	701058	702622	701570	713741	1	700930	11	700511	2											1								N	N	N	N					1						1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	500	701058	702622	701570	713742	1	700930	11	700511	2											1								N	N	N	N					1						1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	900	701058	702622	701570	713745	1	700930	11	700511	2											1								N	N	N	N					1						1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	100	701058	702622	0	705238	4	700930	11	700511	2											1								N	N	N	N					1						1
ZZ_RnD_PCR_GTX	8	A_PCR_GT v1	100	701058	702622	0	713542	4	702068	1	700511	3	1																		N	N	N	N				1							1
ZZ_RnD_PCRSW	3	A_Sidewall v1	100	700584	0	701598	705782	1	704199	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_PCRSW	3	A_Sidewall v1	100	700584	0	701598	705782	1	704199	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_PCRSW	3	A_Sidewall v1	300	700584	0	701598	712308	1	704199	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_PCRSW	3	A_Sidewall v1	300	700584	0	701598	712308	1	704199	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_PCRSW	3	A_Sidewall v1	1000	700584	0	701598	714386	1	704199	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_PCRSW	3	A_Sidewall v1	1000	700584	0	701598	714386	1	704199	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_PCRSW	3	A_Sidewall v1	100	700775	0	701636	705788	1	701848	23	700010	2																															700579		0
ZZ_RnD_PCRSW	3	A_Sidewall v1	100	700775	0	702062	707029	1	702068	23	700010	2																															701009		0
ZZ_RnD_PCRSW	3	A_Sidewall v1	100	700775	0	0	705789	4	700929	26	700511	2																			N	N	N	N	900534							900534			1
ZZ_RnD_PCR_IL	2	A_Innerliner v1	300	700584	0	701817	703209	1	702108	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_PCR_IL	2	A_Innerliner v1	300	700584	0	701817	703209	1	702108	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_PCR_IL	2	A_Innerliner v1	100	700584	0	701817	703268	1	702108	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_PCR_IL	2	A_Innerliner v1	100	700584	0	701817	703268	1	702108	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_PCR_IL	2	A_Innerliner v1	200	700584	0	701817	708829	1	702108	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_PCR_IL	2	A_Innerliner v1	200	700584	0	701817	708829	1	702108	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_PCR_IL	2	A_Innerliner v1	400	700584	0	701817	712268	1	702108	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_PCR_IL	2	A_Innerliner v1	400	700584	0	701817	712268	1	702108	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_PCR_IL	2	A_Innerliner v1	500	700584	0	701817	712269	1	702108	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_PCR_IL	2	A_Innerliner v1	500	700584	0	701817	712269	1	702108	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_PCR_IL	2	A_Innerliner v1	900	700584	0	701817	714021	1	702108	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_PCR_IL	2	A_Innerliner v1	900	700584	0	701817	714021	1	702108	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_FLIPPER_X	2	A_Ply v1	100	700584	0	701817	703268	1	702108	23	700010	2	1	-3	3																N	N	N	N									700649		0
ZZ_RnD_FLIPPER_X	2	A_Ply v1	100	700584	0	701817	703268	1	702108	1	700498	3	1	-3	3																N	N	N	N				1					700649		1
ZZ_RnD_FLIPPER_X	2	A_Ply v1	100	700584	0	701817	703268	1	702108	2	700811	4	1	-3	3																N	N	N	N				-3					700649		1
ZZ_RnD_FLIPPER_X	2	A_Ply v1	100	700584	0	701817	703268	1	702108	3	700812	5	1	-3	3																N	N	N	N				3					700649		1
ZZ_RnD_FLIPPER_X	2	A_Ply v1	200	700584	0	701817	704688	1	702108	23	700010	2																			N	N	N	N									701009		0
ZZ_RnD_FLIPPER_X	2	A_Ply v1	1600	700584	0	701817	717351	1	702108	23	700010	2	1	1	1																N												700649		0
ZZ_RnD_FLIPPER_X	2	A_Ply v1	1600	700584	0	701817	717351	1	702108	1	700498	3	1	1	1																N							1					700649		1
ZZ_RnD_FLIPPER_X	2	A_Ply v1	1600	700584	0	701817	717351	1	702108	2	700811	4	1	1	1																N							1					700649		1
ZZ_RnD_FLIPPER_X	2	A_Ply v1	1600	700584	0	701817	717351	1	702108	3	700812	5	1	1	1																N							1					700649		1
ZZ_RnD_FLIPPER_X	2	A_Ply v1	1800	700584	0	701817	717353	1	702108	23	700010	2	1	1	1																N												700649		0
ZZ_RnD_FLIPPER_X	2	A_Ply v1	1800	700584	0	701817	717353	1	702108	1	700498	3	1	1	1																N							1					700649		1
ZZ_RnD_FLIPPER_X	2	A_Ply v1	1800	700584	0	701817	717353	1	702108	2	700811	4	1	1	1																N							1					700649		1
ZZ_RnD_FLIPPER_X	2	A_Ply v1	1800	700584	0	701817	717353	1	702108	3	700812	5	1	1	1																N							1					700649		1
ZZ_RnD_FLIPPER_X	2	A_Ply v1	1900	700584	0	701817	717354	1	702108	23	700010	2	1	1	1																N												700649		0
ZZ_RnD_FLIPPER_X	2	A_Ply v1	1900	700584	0	701817	717354	1	702108	1	700498	3	1	1	1																N							1					700649		1
ZZ_RnD_FLIPPER_X	2	A_Ply v1	1900	700584	0	701817	717354	1	702108	2	700811	4	1	1	1																N							1					700649		1
ZZ_RnD_FLIPPER_X	2	A_Ply v1	1900	700584	0	701817	717354	1	702108	3	700812	5	1	1	1																N							1					700649		1
ZZ_RnD_FLIPPER_X	2	A_Ply v1	1700	700584	0	701817	717355	1	702108	23	700010	2	1	1	1																N												700649		0
ZZ_RnD_FLIPPER_X	2	A_Ply v1	1700	700584	0	701817	717355	1	702108	1	700498	3	1	1	1																N							1					700649		1
ZZ_RnD_FLIPPER_X	2	A_Ply v1	1700	700584	0	701817	717355	1	702108	2	700811	4	1	1	1																N							1					700649		1
ZZ_RnD_FLIPPER_X	2	A_Ply v1	1700	700584	0	701817	717355	1	702108	3	700812	5	1	1	1																N							1					700649		1
ZZ_RnD_FLIPPER_X	2	A_Ply v1	100	700584	0	701817	703268	1	702108	23	700010	2	1	-3	3																N	N	N	N									700649		0
ZZ_RnD_FLIPPER_X	2	A_Ply v1	100	700584	0	701817	703268	1	702108	1	700498	3	1	-3	3																N	N	N	N				1					700649		1
ZZ_RnD_FLIPPER_X	2	A_Ply v1	100	700584	0	701817	703268	1	702108	2	700811	4	1	-3	3																N	N	N	N				-3					700649		1
ZZ_RnD_FLIPPER_X	2	A_Ply v1	100	700584	0	701817	703268	1	702108	3	700812	5	1	-3	3																N	N	N	N				3					700649		1
ZZ_RnD_FLIPPER_X	2	A_Ply v1	200	700584	0	701817	704688	1	702108	23	700010	2																			N	N	N	N									701009		0
ZZ_RnD_FLIPPER_X	2	A_Ply v1	1600	700584	0	701817	717351	1	702108	23	700010	2	1	1	1																N												700649		0
ZZ_RnD_FLIPPER_X	2	A_Ply v1	1600	700584	0	701817	717351	1	702108	1	700498	3	1	1	1																N							1					700649		1
ZZ_RnD_FLIPPER_X	2	A_Ply v1	1600	700584	0	701817	717351	1	702108	2	700811	4	1	1	1																N							1					700649		1
ZZ_RnD_FLIPPER_X	2	A_Ply v1	1600	700584	0	701817	717351	1	702108	3	700812	5	1	1	1																N							1					700649		1
ZZ_RnD_FLIPPER_X	2	A_Ply v1	1800	700584	0	701817	717353	1	702108	23	700010	2	1	1	1																N												700649		0
ZZ_RnD_FLIPPER_X	2	A_Ply v1	1800	700584	0	701817	717353	1	702108	1	700498	3	1	1	1																N							1					700649		1
ZZ_RnD_FLIPPER_X	2	A_Ply v1	1800	700584	0	701817	717353	1	702108	2	700811	4	1	1	1																N							1					700649		1
ZZ_RnD_FLIPPER_X	2	A_Ply v1	1800	700584	0	701817	717353	1	702108	3	700812	5	1	1	1																N							1					700649		1
ZZ_RnD_FLIPPER_X	2	A_Ply v1	1900	700584	0	701817	717354	1	702108	23	700010	2	1	1	1																N												700649		0
ZZ_RnD_FLIPPER_X	2	A_Ply v1	1900	700584	0	701817	717354	1	702108	1	700498	3	1	1	1																N							1					700649		1
ZZ_RnD_FLIPPER_X	2	A_Ply v1	1900	700584	0	701817	717354	1	702108	2	700811	4	1	1	1																N							1					700649		1
ZZ_RnD_FLIPPER_X	2	A_Ply v1	1900	700584	0	701817	717354	1	702108	3	700812	5	1	1	1																N							1					700649		1
ZZ_RnD_FLIPPER_X	2	A_Ply v1	1700	700584	0	701817	717355	1	702108	23	700010	2	1	1	1																N												700649		0
ZZ_RnD_FLIPPER_X	2	A_Ply v1	1700	700584	0	701817	717355	1	702108	1	700498	3	1	1	1																N							1					700649		1
ZZ_RnD_FLIPPER_X	2	A_Ply v1	1700	700584	0	701817	717355	1	702108	2	700811	4	1	1	1																N							1					700649		1
ZZ_RnD_FLIPPER_X	2	A_Ply v1	1700	700584	0	701817	717355	1	702108	3	700812	5	1	1	1																N							1					700649		1
ZZ_RnD_PLYV1	3	A_Ply v1	400	700584	0	701817	703209	1	702108	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_PLYV1	3	A_Ply v1	400	700584	0	701817	703209	1	702108	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_PLYV1	3	A_Ply v1	100	700584	0	701817	703268	1	702108	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_PLYV1	3	A_Ply v1	100	700584	0	701817	703268	1	702108	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_PLYV1	3	A_Ply v1	200	700584	0	701817	704688	1	702108	23	700010	2	1																		N	N	N	N									701009		0
ZZ_RnD_PLYV1	3	A_Ply v1	200	700584	0	701817	704688	1	702108	1	700498	3	1																		N	N	N	N				1					701009		1
ZZ_RnD_PLYV1	3	A_Ply v1	1600	700584	0	701817	717351	1	702108	23	700010	2	1																		N												700649		0
ZZ_RnD_PLYV1	3	A_Ply v1	1600	700584	0	701817	717351	1	702108	1	700498	3	1																		N							1					700649		1
ZZ_RnD_PLYV1	3	A_Ply v1	1800	700584	0	701817	717353	1	702108	23	700010	2	1																		N												700649		0
ZZ_RnD_PLYV1	3	A_Ply v1	1800	700584	0	701817	717353	1	702108	1	700498	3	1																		N							1					700649		1
ZZ_RnD_PLYV1	3	A_Ply v1	1900	700584	0	701817	717354	1	702108	23	700010	2	1																		N												700649		0
ZZ_RnD_PLYV1	3	A_Ply v1	1900	700584	0	701817	717354	1	702108	1	700498	3	1																		N							1					700649		1
ZZ_RnD_PLYV1	3	A_Ply v1	1700	700584	0	701817	717355	1	702108	23	700010	2	1																		N												700649		0
ZZ_RnD_PLYV1	3	A_Ply v1	1700	700584	0	701817	717355	1	702108	1	700498	3	1																		N							1					700649		1
ZZ_RnD_PCR_BEADAPE	2	A_Bead v1	100	700584	0	701796	706088	1	702108	23	700010	2																			N												700649		0
ZZ_RnD_PCR_BEADAPE	2	A_Bead v1	100	700584	0	701598	703415	1	702108	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_PCR_BEADAPE	2	A_Bead v1	100	700584	0	701598	703415	1	702108	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_BELT1PCR	7	A_Belt v1	300	700584	0	701817	703209	1	702108	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_BELT1PCR	7	A_Belt v1	300	700584	0	701817	703209	1	702108	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_BELT1PCR	7	A_Belt v1	200	700584	0	701817	704688	1	702108	23	700010	2	1																		N	N	N	N									701009		0
ZZ_RnD_BELT1PCR	7	A_Belt v1	200	700584	0	701817	704688	1	702108	1	700498	3	1																		N	N	N	N				1					701009		1
ZZ_RnD_BELT1PCR	7	A_Belt v1	400	700584	0	701817	715337	1	702108	23	700010	2	1																		N												700649		0
ZZ_RnD_BELT1PCR	7	A_Belt v1	400	700584	0	701817	715337	1	702108	1	700498	3	1																		N							1					700649		1
ZZ_RnD_BELT1PCR	7	A_Belt v1	100	700584	0	702337	703209	1	702108	1	700498	3	1																		N	N	N	N				1							1
ZZ_RnD_BELT1PCR	7	A_Belt v1	200	700584	0	702337	703268	1	702108	1	700498	3	1																		N	N	N	N				1							1
ZZ_RnD_BELT1PCR	7	A_Belt v1	100	700584	0	702338	703209	1	702108	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_BELT1PCR	7	A_Belt v1	100	700584	0	702338	703209	1	702108	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_BELT1PCR	7	A_Belt v1	300	700584	0	702338	703268	1	702108	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_BELT1PCR	7	A_Belt v1	300	700584	0	702338	703268	1	702108	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_BELT1PCR	7	A_Belt v1	200	700584	0	702338	713511	1	702108	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_BELT1PCR	7	A_Belt v1	200	700584	0	702338	713511	1	702108	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_BELT1PCR	7	A_Belt v1	500	700584	0	702338	715001	1	702108	23	700010	2	1																		N												700649		0
ZZ_RnD_BELT1PCR	7	A_Belt v1	500	700584	0	702338	715001	1	702108	1	700498	3	1																		N							1					700649		1
ZZ_RnD_BELT1PCR	7	A_Belt v1	600	700584	0	702338	715002	1	702108	23	700010	2	1																		N												700649		0
ZZ_RnD_BELT1PCR	7	A_Belt v1	600	700584	0	702338	715002	1	702108	1	700498	3	1																		N							1					700649		1
ZZ_RnD_BELT1PCR	7	A_Belt v1	400	700584	0	702338	715003	1	702108	23	700010	2	1																		N												700649		0
ZZ_RnD_BELT1PCR	7	A_Belt v1	400	700584	0	702338	715003	1	702108	1	700498	3	1																		N							1					700649		1
ZZ_RnD_BELT1PCR	7	A_Belt v1	300	700584	0	701817	703209	1	702108	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_BELT1PCR	7	A_Belt v1	300	700584	0	701817	703209	1	702108	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_BELT1PCR	7	A_Belt v1	200	700584	0	701817	704688	1	702108	23	700010	2	1																		N	N	N	N									701009		0
ZZ_RnD_BELT1PCR	7	A_Belt v1	200	700584	0	701817	704688	1	702108	1	700498	3	1																		N	N	N	N				1					701009		1
ZZ_RnD_BELT1PCR	7	A_Belt v1	400	700584	0	701817	715337	1	702108	23	700010	2	1																		N												700649		0
ZZ_RnD_BELT1PCR	7	A_Belt v1	400	700584	0	701817	715337	1	702108	1	700498	3	1																		N							1					700649		1
ZZ_RnD_BELT1PCR	7	A_Belt v1	100	700584	0	702337	703209	1	702108	1	700498	3	1																		N	N	N	N				1							1
ZZ_RnD_BELT1PCR	7	A_Belt v1	200	700584	0	702337	703268	1	702108	1	700498	3	1																		N	N	N	N				1							1
ZZ_RnD_BELT1PCR	7	A_Belt v1	100	700584	0	702338	703209	1	702108	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_BELT1PCR	7	A_Belt v1	100	700584	0	702338	703209	1	702108	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_BELT1PCR	7	A_Belt v1	300	700584	0	702338	703268	1	702108	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_BELT1PCR	7	A_Belt v1	300	700584	0	702338	703268	1	702108	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_BELT1PCR	7	A_Belt v1	200	700584	0	702338	713511	1	702108	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_BELT1PCR	7	A_Belt v1	200	700584	0	702338	713511	1	702108	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_BELT1PCR	7	A_Belt v1	500	700584	0	702338	715001	1	702108	23	700010	2	1																		N												700649		0
ZZ_RnD_BELT1PCR	7	A_Belt v1	500	700584	0	702338	715001	1	702108	1	700498	3	1																		N							1					700649		1
ZZ_RnD_BELT1PCR	7	A_Belt v1	600	700584	0	702338	715002	1	702108	23	700010	2	1																		N												700649		0
ZZ_RnD_BELT1PCR	7	A_Belt v1	600	700584	0	702338	715002	1	702108	1	700498	3	1																		N							1					700649		1
ZZ_RnD_BELT1PCR	7	A_Belt v1	400	700584	0	702338	715003	1	702108	23	700010	2	1																		N												700649		0
ZZ_RnD_BELT1PCR	7	A_Belt v1	400	700584	0	702338	715003	1	702108	1	700498	3	1																		N							1					700649		1
ZZ_RnD_PLYV1	3	A_Ply v1	400	700584	0	701817	703209	1	702108	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_PLYV1	3	A_Ply v1	400	700584	0	701817	703209	1	702108	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_PLYV1	3	A_Ply v1	100	700584	0	701817	703268	1	702108	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_PLYV1	3	A_Ply v1	100	700584	0	701817	703268	1	702108	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_PLYV1	3	A_Ply v1	200	700584	0	701817	704688	1	702108	23	700010	2	1																		N	N	N	N									701009		0
ZZ_RnD_PLYV1	3	A_Ply v1	200	700584	0	701817	704688	1	702108	1	700498	3	1																		N	N	N	N				1					701009		1
ZZ_RnD_PLYV1	3	A_Ply v1	1600	700584	0	701817	717351	1	702108	23	700010	2	1																		N												700649		0
ZZ_RnD_PLYV1	3	A_Ply v1	1600	700584	0	701817	717351	1	702108	1	700498	3	1																		N							1					700649		1
ZZ_RnD_PLYV1	3	A_Ply v1	1800	700584	0	701817	717353	1	702108	23	700010	2	1																		N												700649		0
ZZ_RnD_PLYV1	3	A_Ply v1	1800	700584	0	701817	717353	1	702108	1	700498	3	1																		N							1					700649		1
ZZ_RnD_PLYV1	3	A_Ply v1	1900	700584	0	701817	717354	1	702108	23	700010	2	1																		N												700649		0
ZZ_RnD_PLYV1	3	A_Ply v1	1900	700584	0	701817	717354	1	702108	1	700498	3	1																		N							1					700649		1
ZZ_RnD_PLYV1	3	A_Ply v1	1700	700584	0	701817	717355	1	702108	23	700010	2	1																		N												700649		0
ZZ_RnD_PLYV1	3	A_Ply v1	1700	700584	0	701817	717355	1	702108	1	700498	3	1																		N							1					700649		1
ZZ_RnD_TREADPCR	13	A_tread v1	100	700584	0	701597	705775	1	703949	26	700932	2																							900596							900596			1
ZZ_RnD_TREADPCR	13	A_tread v1	200	700584	0	701597	705776	1	703949	26	700932	2	1																						900593	903301						900593			1
ZZ_RnD_TREADPCR	13	A_tread v1	200	700584	0	701597	705776	1	703949	30	701692	4	1																						900593	903301						903301			1
ZZ_RnD_TREADPCR	13	A_tread v1	200	700584	0	701597	705776	1	703949	1	701994	3	1																						900593	903301		1							1
ZZ_RnD_TREADPCR	13	A_tread v1	300	700584	0	701597	705777	1	703949	26	700932	2	1																						900598	903302						900598			1
ZZ_RnD_TREADPCR	13	A_tread v1	300	700584	0	701597	705777	1	703949	30	701692	4	1																						900598	903302						903302			1
ZZ_RnD_TREADPCR	13	A_tread v1	300	700584	0	701597	705777	1	703949	1	701994	3	1																						900598	903302		1							1
ZZ_RnD_TREADPCR	13	A_tread v1	400	700584	0	701597	705778	1	703949	26	700932	2	1																						901016	903302						901016			1
ZZ_RnD_TREADPCR	13	A_tread v1	400	700584	0	701597	705778	1	703949	30	701692	4	1																						901016	903302						903302			1
ZZ_RnD_TREADPCR	13	A_tread v1	400	700584	0	701597	705778	1	703949	1	701994	3	1																						901016	903302		1							1
ZZ_RnD_TREADPCR	13	A_tread v1	500	700584	0	701597	705779	1	703949	26	700932	2	1																						901016	903302						901016			1
ZZ_RnD_TREADPCR	13	A_tread v1	500	700584	0	701597	705779	1	703949	30	701692	4	1																						901016	903302						903302			1
ZZ_RnD_TREADPCR	13	A_tread v1	500	700584	0	701597	705779	1	703949	1	701994	3	1																						901016	903302		1							1
ZZ_RnD_TREADPCR	13	A_tread v1	600	700584	0	701597	705780	1	703949	26	700932	2	1																						901016	903301						901016			1
ZZ_RnD_TREADPCR	13	A_tread v1	600	700584	0	701597	705780	1	703949	30	701692	4	1																						901016	903301						903301			1
ZZ_RnD_TREADPCR	13	A_tread v1	600	700584	0	701597	705780	1	703949	1	701994	3	1																						901016	903301		1							1
ZZ_RnD_TREADPCR	13	A_tread v1	200	700584	0	701598	705781	1	702108	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_TREADPCR	13	A_tread v1	200	700584	0	701598	705781	1	702108	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_TREADPCR	13	A_tread v1	100	700584	0	701598	705782	1	702108	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_TREADPCR	13	A_tread v1	100	700584	0	701598	705782	1	702108	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_TREADPCR	13	A_tread v1	300	700584	0	701598	710028	1	702108	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_TREADPCR	13	A_tread v1	300	700584	0	701598	710028	1	702108	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_TREADPCR	13	A_tread v1	700	700584	0	701598	714170	1	702108	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_TREADPCR	13	A_tread v1	700	700584	0	701598	714170	1	702108	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_TREADPCR	13	A_tread v1	800	700584	0	701598	714171	1	702108	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_TREADPCR	13	A_tread v1	800	700584	0	701598	714171	1	702108	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_TREADPCR	13	A_tread v1	1000	700584	0	701598	714173	1	702108	23	700010	2	1																		N	N	N	N									700649		0
ZZ_RnD_TREADPCR	13	A_tread v1	1000	700584	0	701598	714173	1	702108	1	700498	3	1																		N	N	N	N				1					700649		1
ZZ_RnD_TREADPCR	13	A_tread v1	1100	700584	0	701598	715047	1	702108	23	700010	2																			N												700649		0
ZZ_RnD_TREADPCR	13	A_tread v1	100	700915	0	0	709128	4	700930	11	700511	2											m																m						1
ZZ_RnD_TREADPCR	13	A_tread v1	100	701058	701142	0	715389	4	701888	26	700038	2																							900485							900485			1
*/
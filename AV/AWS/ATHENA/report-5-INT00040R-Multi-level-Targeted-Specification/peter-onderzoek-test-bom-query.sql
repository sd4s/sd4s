--REFINED-VIEW MAKE VALUES CONCRETE...
--research: 'XGG_BF66A17J1'
--

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


/*
--without relating to TEMPLATEBOM:
--
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1		2	125	CURRENT	120			XGR_GSA1327195	1	GYO	120	15-08-2022 16:31:27	01-12-2023 12:43:07	125	CRRNT QR2	CURRENT	700302	Belt 1	1	1	1		1.838		m													0	0	0	0	903316		1	1.838				1				1	6	0000	0120		0120		Greentyre.Belt 1	09-10-2023 10:36:32	15-02-2023 13:59:43	0	0	0	SA13-27-195 Top gum 0.5x20 (2x)	0.438138	KG
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1		2	125	CURRENT	110			XGB_AH138700124543	1	GYO	110	10-05-2022 14:41:25	01-12-2023 12:43:07	125	CRRNT QR2	CURRENT	700302	Bead apex	1	1	1		2		pcs													0	0	0	0	903323		1	2				1				1	5	0000	0110		0110		Greentyre.Bead apex	09-10-2023 10:36:32	15-02-2023 13:59:43	0	0	0	17" 4-5-4-3 Filler 12mm A4012	0.32	KG
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1		2	125	CURRENT	90			XGR_PK08490L80	1	GYO	90	12-10-2022 14:35:42	01-12-2023 12:43:07	125	CRRNT QR2	CURRENT	700302	Ply 1	1	1	1		1.323		m													0	0	0	0	903320		1	1.323				1				1	4	0000	0090		0090		Greentyre.Ply 1	09-10-2023 10:36:32	15-02-2023 13:59:43	0	0	0	PK08-90-490 - Ply with XGX_L170 gum B1008	0.742238	KG
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1		2	125	CURRENT	50			XGR_WR01450085	3	GYO	50	26-10-2022 10:53:22	01-12-2023 12:43:07	125	CRRNT QR2	CURRENT	700302	Flipper R	1	1	1		1		m													0	0	0	0	689		1	1				1				1	3	0000	0050		0050		Greentyre.Flipper R	09-10-2023 10:36:32	15-02-2023 13:59:43	0	0	0	RL01-45-85 Rayon Flipper	0.136	KG
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1		2	125	CURRENT	130			XGR_NSA1327185	3	GYO	130	26-11-2021 13:34:15	01-12-2023 12:43:07	125	CRRNT QR2	CURRENT	700302	Belt 2	1	1	1		1.845		m													0	0	0	0	903317		1	1.845				1				1	7	0000	0130		0130		Greentyre.Belt 2	09-10-2023 10:36:32	15-02-2023 13:59:43	0	0	0	SA13-27-185-No Gum	0.390905	KG
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1		2	125	CURRENT	20			XGL_LAQ1360F360N	1	GYO	20	17-09-2021 09:52:16	01-12-2023 12:43:07	125	CRRNT QR2	CURRENT	700302	Innerliner assembly	1	1	1		1.312		m													0	0	0	0	903345		1	1.312				1				1	1	0000	0020		0020		Greentyre.Innerliner assembly	09-10-2023 10:36:32	15-02-2023 13:59:43	0	0	0	LAQ1-360-F360 - GM_L2002 / GM_B1054	0.655	KG
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1		2	125	CURRENT	10			XGS_WBTV120TN	1	GYO	10	28-10-2021 09:53:44	01-12-2023 12:43:07	125	CRRNT QR2	CURRENT	700304	Sidewall L/R	1	1	1		1.312		m													0	0	0	0	903394		1	1.312				1				1	0	0000	0010		0010		Greentyre.Sidewall L/R	09-10-2023 10:36:32	15-02-2023 13:59:43	0	0	0	B-120 Thin GM_R5026/GM_Z5020	0.702	KG
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1		2	125	CURRENT	150			XGT_PSTBF66A17D2	4	GYO	150	12-10-2022 14:54:35	01-12-2023 12:43:07	125	CRRNT QR2	CURRENT	700304	Tread	1	1	1		1.857		m													0	0	0	0	903311		1	1.857				1				1	9	0000	0150		0150		Greentyre.Tread	09-10-2023 10:36:32	15-02-2023 13:59:43	0	0	0	TREAD BF66AS17 B220 SB190 GMST7022/T3008/T3030	1.603	KG
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1		2	125	CURRENT	140			GR_NB01000012	7	GYO	140	29-06-2021 09:53:08	01-12-2023 12:43:07	128	CRRNT QR5	CURRENT	700302	Capstrip	1	1	1		31.44		m													0	0	0	0	903372		1	31.44				1				1	8	0000	0140		0140		Greentyre.Capstrip	09-10-2023 10:36:32	30-11-2023 12:43:07	0	0	0	NB01 Capstrip 12 mm	0.00948	KG
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1		2	125	CURRENT	40			XGR_WR01450085	3	GYO	40	26-10-2022 10:53:22	01-12-2023 12:43:07	125	CRRNT QR2	CURRENT	700302	Flipper L	1	1	1		1		m													0	0	0	0	688		1	1				1				1	2	0000	0040		0040		Greentyre.Flipper L	09-10-2023 10:36:32	15-02-2023 13:59:43	0	0	0	RL01-45-85 Rayon Flipper	0.136	KG
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGR_GSA1327195		1	125	CURRENT	120	Belt 1	m	GC_SAP095105	9	GYO	10	19-07-2023 11:36:41		128	CRRNT QR5	CURRENT	700313	Composite	1	1	1		0.195		m²													0	0	0	0	903361		1	0.35841							0	2	0	0000.0120	0010	0120	0120.0010	   	Greentyre.Belt 1.Composite	09-10-2023 10:36:32	15-02-2023 13:59:43	0	0	0	SA13 (Steel 2*0.30, 95 EPDM, B1008 )	2.113	KG
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGR_GSA1327195		1	125	CURRENT	120	Belt 1	m	GX_T40	4	GYO	20	18-01-2021 09:08:55		125	CRRNT QR2	CURRENT	700302	Belt gum	1	1	1		1		m													0	0	0	0	903370		1	1.838							0	2	1	0000.0120	0020	0120	0120.0020	   	Greentyre.Belt 1.Belt gum	09-10-2023 10:36:32	15-02-2023 13:59:43	0	0	0	Beltstrip  0.5X40  (U-wrap).	0.026103	KG
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGR_NSA1327185		3	125	CURRENT	130	Belt 2	m	GC_SAP095105	9	GYO	10	19-07-2023 11:36:41		128	CRRNT QR5	CURRENT	700313	Composite	1	1	1		0.185		m²													0	0	0	0	903361		1	0.341325							0	2	0	0000.0130	0010	0130	0130.0010	   	Greentyre.Belt 2.Composite	09-10-2023 10:36:32	15-02-2023 13:59:43	0	0	0	SA13 (Steel 2*0.30, 95 EPDM, B1008 )	2.113	KG
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		GR_NB01000012		7	128	CURRENT	140	Capstrip	m	GR_NB01000150	6	GYO	10	28-05-2020 09:29:37		128	CRRNT QR5	CURRENT	700302	Capply	1	1	1		0.08		m													0	0	0	0	903326		1	2.5152							0	2	0	0000.0140	0010	0140	0140.0010	   	Greentyre.Capstrip.Capply	09-10-2023 10:36:32	30-11-2023 12:43:07	0	0	0	NB01 Capply for minislitter	0.1185	KG
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGT_PSTBF66A17D2	4	125	CURRENT	150	Tread	m	GM_ST7022	13	GYO	20	25-01-2023 14:33:11		127	CRRNT QR4	CURRENT	700306	Tread compound	1	1	1		1.089		kg													0	0	0	0	903348		1	2.022273					2.022273	2.022273	2.976771	2	0	0000.0150	0020	0150	0150.0020	   	Greentyre.Tread.Tread compound	09-10-2023 10:36:32	15-02-2023 13:59:43	0	0	0	Tread All Season LRR C version update 	1	KG
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGT_PSTBF66A17D2	4	125	CURRENT	150	Tread	m	GM_T3030	10	GYO	30	22-06-2023 15:50:43		127	CRRNT QR4	CURRENT	700306	Base 1 compound	1	1	1		0.226		kg													0	0	0	0	903312		1	0.419682					0.419682	0.419682	2.976771	2	1	0000.0150	0030	0150	0150.0030	   	Greentyre.Tread.Base 1 compound	09-10-2023 10:36:32	15-02-2023 13:59:43	0	0	0	Tread Base LRR & Conductive imp.	1	KG
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGT_PSTBF66A17D2	4	125	CURRENT	150	Tread	m	GM_T3008	1	GYO	40	23-06-2022 10:01:38		126	CRRNT QR3	CURRENT	700306	Wingtip compound	1	1	1		0.042		kg													0	0	0	0	903313		1	0.077994					0.077994	0.077994	2.976771	2	2	0000.0150	0040	0150	0150.0040	   	Greentyre.Tread.Wingtip compound	09-10-2023 10:36:32	15-02-2023 13:59:43	0	0	0	FB ULRR Wingtip 	1	KG
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGB_AH138700124543	1	125	CURRENT	110	Bead apex	pcs	GM_A4012	9	GYO	20	19-09-2023 14:27:19		127	CRRNT QR4	CURRENT	700306	Apex compound	1	1	1		0.071365		kg													0	0	0	0	903368		1	0.14273					0.14273	0.14273	0.14273	2	1	0000.0110	0020	0110	0110.0020	   	Greentyre.Bead apex.Apex compound	09-10-2023 10:36:32	15-02-2023 13:59:43	0	0	0	Apex LRR SM final_adjusted formulation	1	KG
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGB_AH138700124543	1	125	CURRENT	110	Bead apex	pcs	GB_BH138704543	9	GYO	10	01-09-2023 08:57:28		128	CRRNT QR5	CURRENT	700302	Bead	1	1	1		1		pcs													0	0	0	0	903365		1	2							0.14273	2	0	0000.0110	0010	0110	0110.0010	   	Greentyre.Bead apex.Bead	09-10-2023 10:36:32	15-02-2023 13:59:43	0	0	0	17" 4-5-4-3	0.249	KG
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGR_PK08490L80		1	125	CURRENT	90	Ply 1	m	XGX_L170	1	GYO	20	15-08-2022 12:46:02		125	CRRNT QR2	CURRENT	700302	Belt gum	1	1	1		1		m													0	0	0	0	903370		1	1.323							0	2	1	0000.0090	0020	0090	0090.0020	   	Greentyre.Ply 1.Belt gum	09-10-2023 10:36:32	15-02-2023 13:59:43	0	0	0	Beltstrip 0.75X170 (Apex extension) B1008	0.039578	KG
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGR_PK08490L80		1	125	CURRENT	90	Ply 1	m	XGR_PK08M900490	1	GYO	10	10-05-2022 14:36:44		125	CRRNT QR2	CURRENT	700302	Reinforcement	1	1	1		1		m													0	0	0	0	903374		1	1.323							0	2	0	0000.0090	0010	0090	0090.0010	   	Greentyre.Ply 1.Reinforcement	09-10-2023 10:36:32	15-02-2023 13:59:43	0	0	0	XPK08-90-490  GM_B1054 Low gauge 1.3mm	0.70266	KG
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGR_WR01450085		3	125	CURRENT	50	Flipper R	m	GC_RLB108140	36	GYO	10	03-08-2023 15:47:40		128	CRRNT QR5	CURRENT	700310	Composite	1	1	1		0.085		m²													0	0	0	0	903361		1	0.085							0	2	0	0000.0050	0010	0050	0050.0010	   	Greentyre.Flipper R.Composite	09-10-2023 10:36:32	15-02-2023 13:59:43	0	0	0	RL01 (Rayon 2440*2 108 epdm) B1024	1.6	KG
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGR_WR01450085		3	125	CURRENT	40	Flipper L	m	GC_RLB108140	36	GYO	10	03-08-2023 15:47:40		128	CRRNT QR5	CURRENT	700310	Composite	1	1	1		0.085		m²													0	0	0	0	903361		1	0.085							0	2	0	0000.0040	0010	0040	0040.0010	   	Greentyre.Flipper L.Composite	09-10-2023 10:36:32	15-02-2023 13:59:43	0	0	0	RL01 (Rayon 2440*2 108 epdm) B1024	1.6	KG
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGT_PSTBF66A17D2	4	125	CURRENT	150	Tread	m	GM_T3030	10	GYO	50	22-06-2023 15:50:43		127	CRRNT QR4	CURRENT	700306	Base 2 compound	1	1	1		0.246		kg													0	0	0	0	903314		1	0.456822					0.456822	0.456822	2.976771	2	3	0000.0150	0050	0150	0150.0050	   	Greentyre.Tread.Base 2 compound	09-10-2023 10:36:32	15-02-2023 13:59:43	0	0	0	Tread Base LRR & Conductive imp.	1	KG
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGL_LAQ1360F360N	1	125	CURRENT	20	Innerliner assembly	m	GM_L2002	43	GYO	20	10-05-2023 15:26:06		128	CRRNT QR5	CURRENT	700306	Innerliner compound	1	1	1		0.418		kg													0	0	0	0	903349		1	0.548416					0.548416	0.548416	0.85936	2	0	0000.0020	0020	0020	0020.0020	   	Greentyre.Innerliner assembly.Innerliner compound	09-10-2023 10:36:32	15-02-2023 13:59:43	0	0	0	FM Innerliner PCR L2002	1	KG
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGS_WBTV120TN		1	125	CURRENT	10	Sidewall L/R	m	GM_Z5020	11	GYO	30	25-08-2023 12:11:16		127	CRRNT QR4	CURRENT	700306	Sidewall compound	1	1	1		0.396		kg													0	0	0	0	903346		1	0.519552					0.519552	0.519552	0.921024	2	1	0000.0010	0030	0010	0010.0030	   	Greentyre.Sidewall L/R.Sidewall compound	09-10-2023 10:36:32	15-02-2023 13:59:43	0	0	0	FB ULRR Sidewall OE	1	KG
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGS_WBTV120TN		1	125	CURRENT	10	Sidewall L/R	m	GM_R5026	11	GYO	20	14-07-2023 15:42:38		127	CRRNT QR4	CURRENT	700306	Rim cushion compound	1	1	1		0.306		kg													0	0	0	0	903347		1	0.401472					0.401472	0.401472	0.921024	2	0	0000.0010	0020	0010	0010.0020	   	Greentyre.Sidewall L/R.Rim cushion compound	09-10-2023 10:36:32	15-02-2023 13:59:43	0	0	0	ULRR Rimcushion OE D variant 	1	KG
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGL_LAQ1360F360N	1	125	CURRENT	20	Innerliner assembly	m	GM_B1054	11	GYO	30	25-01-2023 11:34:37		127	CRRNT QR4	CURRENT	700306	Technical layer compound	1	1	1		0.237		kg													0	0	0	0	903350		1	0.310944					0.310944	0.310944	0.85936	2	1	0000.0020	0030	0020	0020.0030	   	Greentyre.Innerliner assembly.Technical layer compound	09-10-2023 10:36:32	15-02-2023 13:59:43	0	0	0	ULRR Bodyply & Tech. layer	1	KG*/
*/

--and LVL = 1
/*
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	10			XGS_WBTV120TN		1	GYO	10	28-10-2021 09:53:44	01-12-2023 12:50:19	125	CRRNT QR2	CURRENT	700304	Sidewall L/R	1	1	1		1.312		m													0	0	0	0	903394		1	1.312				1				1	0	0000	0010		0010		Greentyre.Sidewall L/R	09-10-2023 10:36:32	15-02-2023 13:59:43	0	0	0	B-120 Thin GM_R5026/GM_Z5020	0.702	KG
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	20			XGL_LAQ1360F360N	1	GYO	20	17-09-2021 09:52:16	01-12-2023 12:50:19	125	CRRNT QR2	CURRENT	700302	Innerliner assembly	1	1	1		1.312		m													0	0	0	0	903345		1	1.312				1				1	1	0000	0020		0020		Greentyre.Innerliner assembly	09-10-2023 10:36:32	15-02-2023 13:59:43	0	0	0	LAQ1-360-F360 - GM_L2002 / GM_B1054	0.655	KG
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	40			XGR_WR01450085		3	GYO	40	26-10-2022 10:53:22	01-12-2023 12:50:19	125	CRRNT QR2	CURRENT	700302	Flipper L	1	1	1		1		m													0	0	0	0	688		1	1				1				1	2	0000	0040		0040		Greentyre.Flipper L	09-10-2023 10:36:32	15-02-2023 13:59:43	0	0	0	RL01-45-85 Rayon Flipper	0.136	KG
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	50			XGR_WR01450085		3	GYO	50	26-10-2022 10:53:22	01-12-2023 12:50:19	125	CRRNT QR2	CURRENT	700302	Flipper R	1	1	1		1		m													0	0	0	0	689		1	1				1				1	3	0000	0050		0050		Greentyre.Flipper R	09-10-2023 10:36:32	15-02-2023 13:59:43	0	0	0	RL01-45-85 Rayon Flipper	0.136	KG
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	90			XGR_PK08490L80		1	GYO	90	12-10-2022 14:35:42	01-12-2023 12:50:19	125	CRRNT QR2	CURRENT	700302	Ply 1	1	1	1		1.323		m													0	0	0	0	903320		1	1.323				1				1	4	0000	0090		0090		Greentyre.Ply 1	09-10-2023 10:36:32	15-02-2023 13:59:43	0	0	0	PK08-90-490 - Ply with XGX_L170 gum B1008	0.742238	KG
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	110			XGB_AH138700124543	1	GYO	110	10-05-2022 14:41:25	01-12-2023 12:50:19	125	CRRNT QR2	CURRENT	700302	Bead apex	1	1	1		2		pcs													0	0	0	0	903323		1	2				1				1	5	0000	0110		0110		Greentyre.Bead apex	09-10-2023 10:36:32	15-02-2023 13:59:43	0	0	0	17" 4-5-4-3 Filler 12mm A4012	0.32	KG
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	120			XGR_GSA1327195		1	GYO	120	15-08-2022 16:31:27	01-12-2023 12:50:19	125	CRRNT QR2	CURRENT	700302	Belt 1	1	1	1		1.838		m													0	0	0	0	903316		1	1.838				1				1	6	0000	0120		0120		Greentyre.Belt 1	09-10-2023 10:36:32	15-02-2023 13:59:43	0	0	0	SA13-27-195 Top gum 0.5x20 (2x)	0.438138	KG
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	130			XGR_NSA1327185		3	GYO	130	26-11-2021 13:34:15	01-12-2023 12:50:19	125	CRRNT QR2	CURRENT	700302	Belt 2	1	1	1		1.845		m													0	0	0	0	903317		1	1.845				1				1	7	0000	0130		0130		Greentyre.Belt 2	09-10-2023 10:36:32	15-02-2023 13:59:43	0	0	0	SA13-27-185-No Gum	0.390905	KG
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	140			GR_NB01000012		7	GYO	140	29-06-2021 09:53:08	01-12-2023 12:50:19	128	CRRNT QR5	CURRENT	700302	Capstrip	1	1	1		31.44		m													0	0	0	0	903372		1	31.44				1				1	8	0000	0140		0140		Greentyre.Capstrip	09-10-2023 10:36:32	30-11-2023 12:50:19	0	0	0	NB01 Capstrip 12 mm	0.00948	KG
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	150			XGT_PSTBF66A17D2	4	GYO	150	12-10-2022 14:54:35	01-12-2023 12:50:19	125	CRRNT QR2	CURRENT	700304	Tread	1	1	1		1.857		m													0	0	0	0	903311		1	1.857				1				1	9	0000	0150		0150		Greentyre.Tread	09-10-2023 10:36:32	15-02-2023 13:59:43	0	0	0	TREAD BF66AS17 B220 SB190 GMST7022/T3008/T3030	1.603	KG
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
 SELECT f.*
 ,	part.description AS part_description
 ,	weight.weight
 ,  weight.uom       AS weight_uom
 FROM filtered f
 LEFT JOIN	part ON (part.part_no = f.part_no)
 LEFT JOIN avspecification_weight weight ON (weight.part_no = f.part_no)
 ORDER BY  
 f.hierarchy
 ,         f.functiongrp
 ,         f.item_number
 ;


/*
--with relation to TEMPLATEBOM:
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

--Hieruit komt wel de TYRE zelf = XGG_BF66A17J1  !!!!!!!!
--dit in tegenstelling tot property-query !!!!
*/





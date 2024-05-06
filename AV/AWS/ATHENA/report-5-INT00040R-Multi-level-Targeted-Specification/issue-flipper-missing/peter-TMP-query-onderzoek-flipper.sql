 WITH
 cart AS (
 SELECT 'Array' AS origin, 'XGG_BF66A17J1' AS part_no
, to_date('2023/10/09 10:36:32', 'YYYY/MM/DD HH24:MI:SS') AS reference_date
, NULL AS plant FROM dual
 ),
 partList AS (
 SELECT H.part_no, H.revision
 ,	H.issued_date, H.planned_effective_date, H.obsolescence_date
 ,	H.class3_id
 ,	B.plant, B.preferred, B.alternative
 ,	S.status, S.sort_desc AS status_code, S.status_type
 ,	L.reference_date
 FROM cart L
 JOIN specification_header H ON (H.part_no = L.part_no)
 JOIN status S ON (S.status = H.status)
 JOIN class3 C ON (C.class = H.class3_id)
 LEFT JOIN bom_header B ON (
 B.part_no 		= H.part_no
 AND B.revision 		= H.revision
 )
 WHERE S.status_type IN ('HISTORIC', 'CURRENT')
 --AND C.sort_desc	= 'FOC_NONE'
 AND B.preferred	= 1
 --AND B.alternative	= FOC_NONE
 AND (L.plant IS NULL OR B.plant = L.plant)
 AND NOT EXISTS ( SELECT 1
                  FROM specification_header
                  JOIN status USING (status)
                  WHERE part_no = H.part_no
                  AND revision > H.revision
                  AND status_type IN ('HISTORIC', 'CURRENT')
                 )
 AND	( 'DEFAULT' <> 'REFDATE'
        OR ( 'DEFAULT' = 'REFDATE'
           AND	L.reference_date >= coalesce(H.issued_date, H.planned_effective_date)
           AND (H.obsolescence_date IS NULL OR L.reference_date < H.obsolescence_date)
           )
        )
 GROUP BY H.part_no, H.revision
 ,	H.issued_date, H.planned_effective_date, H.obsolescence_date
 ,	H.class3_id
 ,	B.plant, B.preferred, B.alternative
 ,	S.status, S.sort_desc, S.status_type
 ,	L.reference_date
 )
select p.*
from partlist p
;

--XGG_BF66A17J1	2	15-02-2023 13:59:43	15-02-2023 00:00:00		700554	GYO	1	1	125	CRRNT QR2	CURRENT	09-10-2023 10:36:32

--sort-desc:   CRRNT QR2
--alternative: 1



 WITH
 cart AS (
 SELECT 'Array' AS origin, 'XGG_BF66A17J1' AS part_no
, to_date('2023/10/09 10:36:32', 'YYYY/MM/DD HH24:MI:SS') AS reference_date
, NULL AS plant FROM dual
 ),
 partList AS (
 SELECT H.part_no, H.revision
 ,	H.issued_date, H.planned_effective_date, H.obsolescence_date
 ,	H.class3_id
 ,	B.plant, B.preferred, B.alternative
 ,	S.status, S.sort_desc AS status_code, S.status_type
 ,	L.reference_date
 FROM cart L
 JOIN specification_header H ON (H.part_no = L.part_no)
 JOIN status S ON (S.status = H.status)
 JOIN class3 C ON (C.class = H.class3_id)
 LEFT JOIN bom_header B ON (
 B.part_no 		= H.part_no
 AND B.revision 		= H.revision
 )
 WHERE S.status_type IN ('HISTORIC', 'CURRENT')
 --AND C.sort_desc	= 'FOC_NONE'
 AND B.preferred	= 1
 --AND B.alternative	= FOC_NONE
 AND (L.plant IS NULL OR B.plant = L.plant)
 AND NOT EXISTS ( SELECT 1
                  FROM specification_header
                  JOIN status USING (status)
                  WHERE part_no = H.part_no
                  AND revision > H.revision
                  AND status_type IN ('HISTORIC', 'CURRENT')
                 )
 AND	( 'DEFAULT' <> 'REFDATE'
        OR ( 'DEFAULT' = 'REFDATE'
           AND	L.reference_date >= coalesce(H.issued_date, H.planned_effective_date)
           AND (H.obsolescence_date IS NULL OR L.reference_date < H.obsolescence_date)
           )
        )
 GROUP BY H.part_no, H.revision
 ,	H.issued_date, H.planned_effective_date, H.obsolescence_date
 ,	H.class3_id
 ,	B.plant, B.preferred, B.alternative
 ,	S.status, S.sort_desc, S.status_type
 ,	L.reference_date
 )
 ,	 specList AS (
 SELECT h2.part_no, h2.revision
 ,	h2.issued_date, h2.obsolescence_date, h2.planned_effective_date
 ,	h2.status, s2.sort_desc AS status_code, s2.status_type
 ,	h2.class3_id
 ,	CASE WHEN 'DEFAULT' = 'REFDATE' THEN 1 ELSE 0 END AS f_checkRefDate
 FROM specification_header h2
 JOIN status s2 ON ( s2.status = h2.status AND status_type IN ('HISTORIC', 'CURRENT') )
 WHERE ('DEFAULT' = 'HIGHEST' OR h2.issued_date IS NOT NULL)
 )
 ,	 componentList AS (
 SELECT h2.part_no, h2.revision
 ,	h2.issued_date, h2.obsolescence_date, h2.planned_effective_date
 ,	h2.status, s2.sort_desc AS status_code, s2.status_type
 ,	h2.class3_id
 ,	CASE WHEN 'DEFAULT' = 'REFDATE' THEN 1 ELSE 0 END AS f_checkRefDate
 FROM specification_header h2
 JOIN status s2 ON ( s2.status = h2.status AND status_type IN ('HISTORIC', 'CURRENT') )
 WHERE h2.part_no NOT LIKE 'X%'
 AND ('DEFAULT' = 'HIGHEST' OR h2.issued_date IS NOT NULL)
 UNION ALL
 SELECT h2.part_no, h2.revision
 ,	h2.issued_date, h2.obsolescence_date, h2.planned_effective_date
 ,	h2.status, s2.sort_desc AS status_code, s2.status_type
 ,	h2.class3_id
 ,	CASE WHEN 'DEFAULT' = 'REFDATE' THEN 1 ELSE 0 END AS f_checkRefDate
 FROM specification_header h2
 JOIN status s2 ON ( s2.status = h2.status AND status_type IN ('HISTORIC', 'CURRENT') )
 WHERE h2.part_no LIKE 'X%'
 AND ('DEFAULT' = 'HIGHEST' OR h2.issued_date IS NOT NULL)
 )
 ,	 root_function AS (
 SELECT sk.part_no, sk.kw_value
 FROM specification_kw sk
 JOIN itkw ON ( itkw.kw_id = sk.kw_id AND itkw.description = 'Function' )
 )
 ,	 bom_function AS (
 SELECT f.characteristic_id, f.description
 FROM characteristic f
 JOIN	characteristic_association ca ON ( ca.characteristic = f.characteristic_id AND ca.intl = f.intl )
 JOIN association a ON ( a.association = ca.association AND a.intl = ca.intl )
 WHERE a.description = 'Function'
 )
 ,	 tree (
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
 ) AS (
 SELECT
 p.part_no AS root_part, p.revision AS root_rev
 ,	p.status AS root_status, p.status_type AS root_status_type
 ,	bh.preferred AS root_preferred, bh.alternative AS root_alternative
 ,	p.issued_date AS root_issued_date
 ,	bi.num_1 AS root_density
 ,	p.part_no AS parent_part, p.revision AS parent_rev
 ,	p.status AS parent_status, p.status_type AS parent_status_type
 ,	bi.item_number AS parent_seq
 ,	NULL AS parent_function, NULL AS parent_uom
 ,	bi.component_part AS part_no, hh.revision, bi.plant, bi.item_number
 ,	coalesce(hh.issued_date, hh.planned_effective_date) AS issued_date
 ,	coalesce(hh.obsolescence_date, CURRENT_DATE +1) AS obsolete_date
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
 ,	bh.base_quantity AS parent_quantity
 ,	bi.quantity * 1.0 AS normalized_quantity
 ,	bi.quantity / bi.num_1	AS component_volume
 ,	bi.quantity / bi.num_1	AS volume
 ,	bi.quantity / bi.num_1	AS normalized_volume
 ,	1.0 AS parent_volume
 ,	CASE
 WHEN bi.uom = 'kg' THEN bi.quantity * 1.0
 ELSE NULL
 END
 ,	CASE
 WHEN bi.uom = 'kg' THEN bi.quantity * 1.0
 ELSE NULL
 END
 ,	SUM(CASE
 WHEN bi.uom = 'kg' THEN bi.quantity * 1.0
 ELSE NULL
 END) OVER ()
 ,	1 AS lvl
 ,	ROW_NUMBER() OVER (ORDER BY bi.item_number) -1
 ,	CAST('0000' AS varchar2(120)) AS path
 ,	to_char(bi.item_number, 'FM0999') AS pathNode
 ,	CAST('' AS VARCHAR2(100)) AS parent_branch
 ,	CAST(to_char(bi.item_number, 'FM0999') AS varchar2(100)) AS branch
 ,	CAST ('' AS VARCHAR2(200)) AS indentStr
 ,	CAST(r.kw_value || '.' || f.description AS VARCHAR2(254)) AS breadcrumbs
 ,	CAST(p.reference_date AS date)
 ,	CAST(CASE
 WHEN 'DEFAULT' = 'REFDATE' THEN p.reference_date
 WHEN 'DEFAULT' = 'DEFAULT' AND bi.component_part LIKE 'X%'
 THEN p.issued_date
 ELSE coalesce(p.obsolescence_date, CURRENT_DATE)
 END AS date)
 ,	CASE WHEN p.revision = 1 AND hh.revision = 1 AND p.reference_date < coalesce(hh.issued_date, hh.planned_effective_date)
 THEN '1'
 ELSE '0'
 END AS e_issuedAfterExplDate
 ,	CASE WHEN hh.revision IS NULL THEN 1 ELSE 0 END AS e_noPhantomRevision
 FROM partList p
 LEFT JOIN root_function r ON (r.part_no = p.part_no)
 LEFT JOIN bom_header bh ON (   bh.part_no = p.part_no
                            AND bh.revision = p.revision
                            AND bh.preferred = p.preferred
                            )
 LEFT JOIN bom_item bi ON (   bi.part_no = bh.part_no
                          AND bi.revision = bh.revision
                          AND bi.plant = bh.plant
                          AND bi.alternative = bh.alternative
                          )
 LEFT JOIN specList hh ON (   bi.component_part = hh.part_no
                          AND (   f_checkRefDate = 0
                              OR ( hh.issued_date <= p.reference_date
                                 AND (hh.obsolescence_date IS NULL OR p.reference_date < hh.obsolescence_date)
                                 )
                              ) 
                          AND NOT EXISTS ( SELECT 1
                                           FROM specification_header h2a
                                           JOIN status s2a ON (s2a.status = h2a.status)
                                           WHERE h2a.part_no = hh.part_no
                                           AND h2a.revision > hh.revision
                                           AND s2a.status_type IN ('HISTORIC', 'CURRENT')
                                           AND (  'DEFAULT' <> 'REFDATE'
                                               OR ( h2a.issued_date <= p.reference_date
                                                  AND (h2a.obsolescence_date IS NULL OR p.reference_date < h2a.obsolescence_date)
                                                  )
                                               )
                                          )             
                           )
 LEFT JOIN bom_function f ON (f.characteristic_id = bi.ch_1)
 WHERE 1 = 1
 AND bh.preferred		= 1
 AND bh.alternative	    = 1
 )
select t.*
from tree t
;
 
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	10			XGS_WBTV120TN	1	GYO	10	28-10-2021 09:53:44	10-10-2023 11:57:06	125	CRRNT QR2	CURRENT	700304	Sidewall L/R	1	1	1		1.312		m													0	0	0	0	903394		1	1.312				1				1	0	0000	0010		0010		Greentyre.Sidewall L/R	09-10-2023 10:36:32	15-02-2023 13:59:43	0	0
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	20			XGL_LAQ1360F360N	1	GYO	20	17-09-2021 09:52:16	10-10-2023 11:57:06	125	CRRNT QR2	CURRENT	700302	Innerliner assembly	1	1	1		1.312		m													0	0	0	0	903345		1	1.312				1				1	1	0000	0020		0020		Greentyre.Innerliner assembly	09-10-2023 10:36:32	15-02-2023 13:59:43	0	0
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	40			XGR_WR01450085	3	GYO	40	26-10-2022 10:53:22	10-10-2023 11:57:06	125	CRRNT QR2	CURRENT	700302	Flipper L	1	1	1		1		m													0	0	0	0	688		1	1				1				1	2	0000	0040		0040		Greentyre.Flipper L	09-10-2023 10:36:32	15-02-2023 13:59:43	0	0
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	50			XGR_WR01450085	3	GYO	50	26-10-2022 10:53:22	10-10-2023 11:57:06	125	CRRNT QR2	CURRENT	700302	Flipper R	1	1	1		1		m													0	0	0	0	689		1	1				1				1	3	0000	0050		0050		Greentyre.Flipper R	09-10-2023 10:36:32	15-02-2023 13:59:43	0	0
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	90			XGR_PK08490L80	1	GYO	90	12-10-2022 14:35:42	10-10-2023 11:57:06	125	CRRNT QR2	CURRENT	700302	Ply 1	1	1	1		1.323		m													0	0	0	0	903320		1	1.323				1				1	4	0000	0090		0090		Greentyre.Ply 1	09-10-2023 10:36:32	15-02-2023 13:59:43	0	0
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	110			XGB_AH138700124543	1	GYO	110	10-05-2022 14:41:25	10-10-2023 11:57:06	125	CRRNT QR2	CURRENT	700302	Bead apex	1	1	1		2		pcs													0	0	0	0	903323		1	2				1				1	5	0000	0110		0110		Greentyre.Bead apex	09-10-2023 10:36:32	15-02-2023 13:59:43	0	0
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	120			XGR_GSA1327195	1	GYO	120	15-08-2022 16:31:27	10-10-2023 11:57:06	125	CRRNT QR2	CURRENT	700302	Belt 1	1	1	1		1.838		m													0	0	0	0	903316		1	1.838				1				1	6	0000	0120		0120		Greentyre.Belt 1	09-10-2023 10:36:32	15-02-2023 13:59:43	0	0
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	130			XGR_NSA1327185	3	GYO	130	26-11-2021 13:34:15	10-10-2023 11:57:06	125	CRRNT QR2	CURRENT	700302	Belt 2	1	1	1		1.845		m													0	0	0	0	903317		1	1.845				1				1	7	0000	0130		0130		Greentyre.Belt 2	09-10-2023 10:36:32	15-02-2023 13:59:43	0	0
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	140			GR_NB01000012	7	GYO	140	29-06-2021 09:53:08	10-10-2023 11:57:06	128	CRRNT QR5	CURRENT	700302	Capstrip	1	1	1		31.44		m													0	0	0	0	903372		1	31.44				1				1	8	0000	0140		0140		Greentyre.Capstrip	09-10-2023 10:36:32	09-10-2023 11:57:06	0	0
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	150			XGT_PSTBF66A17D2	4	GYO	150	12-10-2022 14:54:35	10-10-2023 11:57:06	125	CRRNT QR2	CURRENT	700304	Tread	1	1	1		1.857		m													0	0	0	0	903311		1	1.857				1				1	9	0000	0150		0150		Greentyre.Tread	09-10-2023 10:36:32	15-02-2023 13:59:43	0	0


WITH root_function AS (
 SELECT sk.part_no, sk.kw_value
 FROM specification_kw sk
 JOIN itkw ON ( itkw.kw_id = sk.kw_id AND itkw.description = 'Function' )
 ) 
, TEMPLATEBOM
(   tpl_root_part, tpl_root_revision, tpl_root_description
 ,	tpl_part_no, tpl_revision
 ,	tpl_description
 ,	tpl_frame_id, tpl_frame_rev
 ,	tpl_item_number
 --,	hierarchy
 --,	function_description
 --,	function_code
 --,	functiongrp
 ,	mask
 ,	lvl
 )  AS
( SELECT sh.part_no, sh.revision,	sh.description
       ,	sh.part_no, sh.revision
       ,	sh.description
       ,	sh.frame_id, sh.frame_rev
       ,	1
       --,	'1'
       --,	(SELECT kw_value FROM root_function WHERE part_no = sh.part_no)
       --,	(SELECT kw_value FROM root_function WHERE part_no = sh.part_no)
       --,	(SELECT kw_value FROM root_function WHERE part_no = sh.part_no)
       ,	'%' || (SELECT kw_value FROM root_function WHERE part_no = sh.part_no)
       ,	0
       FROM specification_header sh
       JOIN status s ON (s.status = sh.status)
       WHERE sh.part_no = 'XGG_BF66A17J1'   --'NONE'
       AND s.status_type = 'CURRENT'
       UNION ALL
       SELECT
       t.tpl_root_part, t.tpl_root_revision, t.tpl_root_description
       ,	bi.component_part
       ,	bish.revision
       ,	bish.description
       ,	bish.frame_id, bish.frame_rev
       ,	bi.item_number
       --,	'1.' || coalesce(bi.char_1, '0.' || to_char(bi.item_number, 'FM0999'))
      -- ,	bi.char_2
       --,	bic.description
      -- ,	bi.char_3
       ,	bi.char_4
       ,	t.lvl +1
       FROM templateBoM t
       JOIN bom_item bi ON (bi.part_no = t.tpl_part_no and bi.revision = t.tpl_revision)
       LEFT JOIN specification_header bish ON (bish.part_no = bi.component_part)
       LEFT JOIN status bis ON (bis.status = bish.status)
       LEFT JOIN characteristic bic ON (bic.characteristic_id = bi.ch_1)
       WHERE bis.status_type = 'CURRENT'
)
select t.*
from templatebom t
;

/*
XGG_BF66A17J1	2	Greentyre BMW F66A17	XGG_BF66A17J1		2	Greentyre BMW F66A17						A_PCR_GT v1		33	1	0
XGG_BF66A17J1	2	Greentyre BMW F66A17	XGS_WBTV120TN		1	B-120 Thin GM_R5026/GM_Z5020				A_Sidewall v1	21	10	1
XGG_BF66A17J1	2	Greentyre BMW F66A17	XGL_LAQ1360F360N	1	LAQ1-360-F360 - GM_L2002 / GM_B1054			A_Innerliner v1	22	20	1
XGG_BF66A17J1	2	Greentyre BMW F66A17	XGR_WR01450085		3	RL01-45-85 Rayon Flipper					A_Ply v1		13	40	1
XGG_BF66A17J1	2	Greentyre BMW F66A17	XGR_WR01450085		3	RL01-45-85 Rayon Flipper					A_Ply v1		13	50	1
XGG_BF66A17J1	2	Greentyre BMW F66A17	XGR_PK08490L80		1	PK08-90-490 - Ply with XGX_L170 gum B1008	A_Ply v1		13	90	1
XGG_BF66A17J1	2	Greentyre BMW F66A17	XGB_AH138700124543	1	17" 4-5-4-3 Filler 12mm A4012				A_Bead v1		26	110	1
XGG_BF66A17J1	2	Greentyre BMW F66A17	XGR_GSA1327195		1	SA13-27-195 Top gum 0.5x20 (2x)				A_Belt v1		14	120	1
XGG_BF66A17J1	2	Greentyre BMW F66A17	XGR_NSA1327185		3	SA13-27-185-No Gum							A_Belt v1		14	130	1
...
*/ 

SELECT sk.part_no, sk.kw_value
 FROM specification_kw sk
 JOIN itkw ON ( itkw.kw_id = sk.kw_id AND itkw.description = 'Function' )
WHERE part_no = 'XGG_BF66A17J1'
--part-no			kw-value (functioN)
--XGG_BF66A17J1		Greentyre
 



 WITH
 cart AS (
 SELECT 'Array' AS origin, 'XGG_BF66A17J1' AS part_no
, to_date('2023/10/09 10:36:32', 'YYYY/MM/DD HH24:MI:SS') AS reference_date
, NULL AS plant FROM dual
 ),
 partList AS (
 SELECT H.part_no, H.revision
 ,	H.issued_date, H.planned_effective_date, H.obsolescence_date
 ,	H.class3_id
 ,	B.plant, B.preferred, B.alternative
 ,	S.status, S.sort_desc AS status_code, S.status_type
 ,	L.reference_date
 FROM cart L
 JOIN specification_header H ON (H.part_no = L.part_no)
 JOIN status S ON (S.status = H.status)
 JOIN class3 C ON (C.class = H.class3_id)
 LEFT JOIN bom_header B ON (
 B.part_no 		= H.part_no
 AND B.revision 		= H.revision
 )
 WHERE S.status_type IN ('HISTORIC', 'CURRENT')
 --AND C.sort_desc	= 'FOC_NONE'
 AND B.preferred	= 1
 --AND B.alternative	= FOC_NONE
 AND (L.plant IS NULL OR B.plant = L.plant)
 AND NOT EXISTS ( SELECT 1
                  FROM specification_header
                  JOIN status USING (status)
                  WHERE part_no = H.part_no
                  AND revision > H.revision
                  AND status_type IN ('HISTORIC', 'CURRENT')
                 )
 AND	( 'DEFAULT' <> 'REFDATE'
        OR ( 'DEFAULT' = 'REFDATE'
           AND	L.reference_date >= coalesce(H.issued_date, H.planned_effective_date)
           AND (H.obsolescence_date IS NULL OR L.reference_date < H.obsolescence_date)
           )
        )
 GROUP BY H.part_no, H.revision
 ,	H.issued_date, H.planned_effective_date, H.obsolescence_date
 ,	H.class3_id
 ,	B.plant, B.preferred, B.alternative
 ,	S.status, S.sort_desc, S.status_type
 ,	L.reference_date
 )
 ,	 specList AS (
 SELECT h2.part_no, h2.revision
 ,	h2.issued_date, h2.obsolescence_date, h2.planned_effective_date
 ,	h2.status, s2.sort_desc AS status_code, s2.status_type
 ,	h2.class3_id
 ,	CASE WHEN 'DEFAULT' = 'REFDATE' THEN 1 ELSE 0 END AS f_checkRefDate
 FROM specification_header h2
 JOIN status s2 ON ( s2.status = h2.status AND status_type IN ('HISTORIC', 'CURRENT') )
 WHERE ('DEFAULT' = 'HIGHEST' OR h2.issued_date IS NOT NULL)
 )
 ,	 componentList AS (
 SELECT h2.part_no, h2.revision
 ,	h2.issued_date, h2.obsolescence_date, h2.planned_effective_date
 ,	h2.status, s2.sort_desc AS status_code, s2.status_type
 ,	h2.class3_id
 ,	CASE WHEN 'DEFAULT' = 'REFDATE' THEN 1 ELSE 0 END AS f_checkRefDate
 FROM specification_header h2
 JOIN status s2 ON ( s2.status = h2.status AND status_type IN ('HISTORIC', 'CURRENT') )
 WHERE h2.part_no NOT LIKE 'X%'
 AND ('DEFAULT' = 'HIGHEST' OR h2.issued_date IS NOT NULL)
 UNION ALL
 SELECT h2.part_no, h2.revision
 ,	h2.issued_date, h2.obsolescence_date, h2.planned_effective_date
 ,	h2.status, s2.sort_desc AS status_code, s2.status_type
 ,	h2.class3_id
 ,	CASE WHEN 'DEFAULT' = 'REFDATE' THEN 1 ELSE 0 END AS f_checkRefDate
 FROM specification_header h2
 JOIN status s2 ON ( s2.status = h2.status AND status_type IN ('HISTORIC', 'CURRENT') )
 WHERE h2.part_no LIKE 'X%'
 AND ('DEFAULT' = 'HIGHEST' OR h2.issued_date IS NOT NULL)
 )
 ,	 root_function AS (
 SELECT sk.part_no, sk.kw_value
 FROM specification_kw sk
 JOIN itkw ON ( itkw.kw_id = sk.kw_id AND itkw.description = 'Function' )
 )
 ,	 bom_function AS (
 SELECT f.characteristic_id, f.description
 FROM characteristic f
 JOIN	characteristic_association ca ON ( ca.characteristic = f.characteristic_id AND ca.intl = f.intl )
 JOIN association a ON ( a.association = ca.association AND a.intl = ca.intl )
 WHERE a.description = 'Function'
 )
 ,	 tree (
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
 ) AS (
 SELECT
 p.part_no AS root_part, p.revision AS root_rev
 ,	p.status AS root_status, p.status_type AS root_status_type
 ,	bh.preferred AS root_preferred, bh.alternative AS root_alternative
 ,	p.issued_date AS root_issued_date
 ,	bi.num_1 AS root_density
 ,	p.part_no AS parent_part, p.revision AS parent_rev
 ,	p.status AS parent_status, p.status_type AS parent_status_type
 ,	bi.item_number AS parent_seq
 ,	NULL AS parent_function, NULL AS parent_uom
 ,	bi.component_part AS part_no, hh.revision, bi.plant, bi.item_number
 ,	coalesce(hh.issued_date, hh.planned_effective_date) AS issued_date
 ,	coalesce(hh.obsolescence_date, CURRENT_DATE +1) AS obsolete_date
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
 ,	bh.base_quantity AS parent_quantity
 ,	bi.quantity * 1.0 AS normalized_quantity
 ,	bi.quantity / bi.num_1	AS component_volume
 ,	bi.quantity / bi.num_1	AS volume
 ,	bi.quantity / bi.num_1	AS normalized_volume
 ,	1.0 AS parent_volume
 ,	CASE
 WHEN bi.uom = 'kg' THEN bi.quantity * 1.0
 ELSE NULL
 END
 ,	CASE
 WHEN bi.uom = 'kg' THEN bi.quantity * 1.0
 ELSE NULL
 END
 ,	SUM(CASE
 WHEN bi.uom = 'kg' THEN bi.quantity * 1.0
 ELSE NULL
 END) OVER ()
 ,	1 AS lvl
 ,	ROW_NUMBER() OVER (ORDER BY bi.item_number) -1
 ,	CAST('0000' AS varchar2(120)) AS path
 ,	to_char(bi.item_number, 'FM0999') AS pathNode
 ,	CAST('' AS VARCHAR2(100)) AS parent_branch
 ,	CAST(to_char(bi.item_number, 'FM0999') AS varchar2(100)) AS branch
 ,	CAST ('' AS VARCHAR2(200)) AS indentStr
 ,	CAST(r.kw_value || '.' || f.description AS VARCHAR2(254)) AS breadcrumbs
 ,	CAST(p.reference_date AS date)
 ,	CAST(CASE
 WHEN 'DEFAULT' = 'REFDATE' THEN p.reference_date
 WHEN 'DEFAULT' = 'DEFAULT' AND bi.component_part LIKE 'X%'
 THEN p.issued_date
 ELSE coalesce(p.obsolescence_date, CURRENT_DATE)
 END AS date)
 ,	CASE WHEN p.revision = 1 AND hh.revision = 1 AND p.reference_date < coalesce(hh.issued_date, hh.planned_effective_date)
 THEN '1'
 ELSE '0'
 END AS e_issuedAfterExplDate
 ,	CASE WHEN hh.revision IS NULL THEN 1 ELSE 0 END AS e_noPhantomRevision
 FROM partList p
 LEFT JOIN root_function r ON (r.part_no = p.part_no)
 LEFT JOIN bom_header bh ON (   bh.part_no = p.part_no
                            AND bh.revision = p.revision
                            AND bh.preferred = p.preferred
                            )
 LEFT JOIN bom_item bi ON (   bi.part_no = bh.part_no
                          AND bi.revision = bh.revision
                          AND bi.plant = bh.plant
                          AND bi.alternative = bh.alternative
                          )
 LEFT JOIN specList hh ON (   bi.component_part = hh.part_no
                          AND (   f_checkRefDate = 0
                              OR ( hh.issued_date <= p.reference_date
                                 AND (hh.obsolescence_date IS NULL OR p.reference_date < hh.obsolescence_date)
                                 )
                              ) 
                          AND NOT EXISTS ( SELECT 1
                                           FROM specification_header h2a
                                           JOIN status s2a ON (s2a.status = h2a.status)
                                           WHERE h2a.part_no = hh.part_no
                                           AND h2a.revision > hh.revision
                                           AND s2a.status_type IN ('HISTORIC', 'CURRENT')
                                           AND (  'DEFAULT' <> 'REFDATE'
                                               OR ( h2a.issued_date <= p.reference_date
                                                  AND (h2a.obsolescence_date IS NULL OR p.reference_date < h2a.obsolescence_date)
                                                  )
                                               )
                                          )             
                           )
 LEFT JOIN bom_function f ON (f.characteristic_id = bi.ch_1)
 WHERE 1 = 1
 AND bh.preferred		= 1
 AND bh.alternative	    = 1
 )
 ,	 templateBoM (
    tpl_root_part, tpl_root_revision, tpl_root_description
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
 ) AS ( SELECT sh.part_no, sh.revision,	sh.description
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
       JOIN status s ON (s.status = sh.status)
       WHERE sh.part_no = 'XGG_BF66A17J1'   --'NONE'
       AND s.status_type = 'CURRENT'
       UNION ALL
       SELECT
       t.tpl_root_part, t.tpl_root_revision, t.tpl_root_description
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
       JOIN bom_item bi ON (bi.part_no = t.tpl_part_no and bi.revision = t.tpl_revision)
       LEFT JOIN specification_header bish ON (bish.part_no = bi.component_part)
       LEFT JOIN status bis ON (bis.status = bish.status)
       LEFT JOIN characteristic bic ON (bic.characteristic_id = bi.ch_1)
       WHERE bis.status_type = 'CURRENT'
       )
 , filtered (
    root_part, root_rev, root_status
 ,	part_no, revision, status_type
 ,	breadcrumbs, item_number
 ,	branch, lvl, indentPart
 ,	tpl_root_part, tpl_root_description
 ,	tpl_part_no, tpl_revision, tpl_description, tpl_item_number
 ,	hierarchy, functiongrp, function_code, function_description, mask
 ,	phr, quantity, density, uom
 ,	num_1, num_2, num_3, num_4, num_5
 ,	char_1, char_2, char_3, char_4, char_5
 ,	date_1, date_2
 ,	boolean_1, boolean_2, boolean_3, boolean_4
 ,	ch_1, ch_2
 ,	normalized_quantity
 ,	component_kg, assembly_kg
 ) AS ( SELECT  p.part_no, p.revision, p.status_type
        ,	p.part_no, p.revision, p.status_type
        ,	r.kw_value, 0
        ,	NULL, 0, p.part_no
        ,	tpl.tpl_root_part, tpl.tpl_root_description
        ,	tpl.tpl_part_no, tpl.tpl_revision, tpl.tpl_description, tpl.tpl_item_number
        ,	tpl.hierarchy, tpl.functiongrp, tpl.function_code, tpl.function_description, tpl.mask
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
        SELECT tree.root_part, tree.root_rev, tree.root_status_type
        ,	tree.part_no, tree.revision, tree.status_type
        ,	tree.breadcrumbs, tree.item_number
        ,	tree.branch, tree.lvl, tree.indentStr || tree.part_no
        ,	tpl.tpl_root_part, tpl.tpl_root_description
        ,	tpl.tpl_part_no, tpl.tpl_revision, tpl.tpl_description, tpl.tpl_item_number
        ,	tpl.hierarchy, tpl.functiongrp, tpl.function_code, tpl.function_description, tpl.mask
        ,	tree.phr, tree.quantity, tree.density, tree.uom
        ,	tree.num_1, tree.num_2, tree.num_3, tree.num_4, tree.num_5
        ,	tree.char_1, tree.char_2, tree.char_3, tree.char_4, tree.char_5
        ,	tree.date_1, tree.date_2
        ,	tree.boolean_1, tree.boolean_2, tree.boolean_3, tree.boolean_4
        ,	tree.ch_1, tree.ch_2
        ,	tree.normalized_quantity
        ,	tree.component_kg, tree.assembly_kg
        FROM tree
        JOIN templateBoM tpl ON (tree.breadcrumbs LIKE tpl.mask)
        WHERE EXISTS ( SELECT 1
                       FROM bom_header node
                       WHERE node.part_no		= tree.part_no
                       AND node.revision		= tree.revision
                       AND node.alternative	= tree.alternative
                       AND node.plant		= tree.plant
                       )
      )
 SELECT f.*
 FROM filtered f
 ORDER BY f.hierarchy
 , f.functiongrp
 , f.item_number
 ;
 
--XGG_BF66A17J1	2	CURRENT	XGG_BF66A17J1	2	CURRENT	Greentyre	0		0	XGG_BF66A17J1	XGG_BF66A17J1	Greentyre BMW F66A17	XGG_BF66A17J1	2	Greentyre BMW F66A17	1	1	Greentyre	Greentyre	Greentyre	%Greentyre		1	1	pcs																			1		




--new WITH-statement OVERALL
 
 WITH
 cart AS (
 SELECT 'Array' AS origin, 'XGG_BF66A17J1' AS part_no
, to_date('2023/10/09 10:36:32', 'YYYY/MM/DD HH24:MI:SS') AS reference_date
, NULL AS plant FROM dual
 ),
 partList AS (
 SELECT H.part_no, H.revision
 ,	H.issued_date, H.planned_effective_date, H.obsolescence_date
 ,	H.class3_id
 ,	B.plant, B.preferred, B.alternative
 ,	S.status, S.sort_desc AS status_code, S.status_type
 ,	L.reference_date
 FROM cart L
 JOIN specification_header H ON (H.part_no = L.part_no)
 JOIN status S ON (S.status = H.status)
 JOIN class3 C ON (C.class = H.class3_id)
 LEFT JOIN bom_header B ON ( B.part_no 		= H.part_no  AND B.revision 		= H.revision )
 WHERE S.status_type IN ('HISTORIC', 'CURRENT')
 --AND C.sort_desc	= 'FOC_NONE'
 AND B.preferred	= 1
 --AND B.alternative	= FOC_NONE
 AND (L.plant IS NULL OR B.plant = L.plant)
 AND NOT EXISTS ( SELECT 1
                  FROM specification_header
                  JOIN status USING (status)
                  WHERE part_no = H.part_no
                  AND revision > H.revision
                  AND status_type IN ('HISTORIC', 'CURRENT')
                 )
 AND	( 'DEFAULT' <> 'REFDATE'
        OR ( 'DEFAULT' = 'REFDATE'
           AND	L.reference_date >= coalesce(H.issued_date, H.planned_effective_date)
           AND (H.obsolescence_date IS NULL OR L.reference_date < H.obsolescence_date)
           )
        )
 GROUP BY H.part_no, H.revision
 ,	H.issued_date, H.planned_effective_date, H.obsolescence_date
 ,	H.class3_id
 ,	B.plant, B.preferred, B.alternative
 ,	S.status, S.sort_desc, S.status_type
 ,	L.reference_date
 )
 ,	 specList AS (
 SELECT h2.part_no, h2.revision
 ,	h2.issued_date, h2.obsolescence_date, h2.planned_effective_date
 ,	h2.status, s2.sort_desc AS status_code, s2.status_type
 ,	h2.class3_id
 ,	CASE WHEN 'DEFAULT' = 'REFDATE' THEN 1 ELSE 0 END AS f_checkRefDate
 FROM specification_header h2
 JOIN status s2 ON ( s2.status = h2.status AND status_type IN ('HISTORIC', 'CURRENT') )
 WHERE ('DEFAULT' = 'HIGHEST' OR h2.issued_date IS NOT NULL)
 )
 ,	 componentList AS (
         SELECT h2.part_no, h2.revision
         ,	h2.issued_date, h2.obsolescence_date, h2.planned_effective_date
         ,	h2.status, s2.sort_desc AS status_code, s2.status_type
         ,	h2.class3_id
         ,	CASE WHEN 'DEFAULT' = 'REFDATE' THEN 1 ELSE 0 END AS f_checkRefDate
         FROM specification_header h2
         JOIN status s2 ON ( s2.status = h2.status AND status_type IN ('HISTORIC', 'CURRENT') )
         WHERE h2.part_no NOT LIKE 'X%'
         AND ('DEFAULT' = 'HIGHEST' OR h2.issued_date IS NOT NULL)
         UNION ALL
         SELECT h2.part_no, h2.revision
         ,	h2.issued_date, h2.obsolescence_date, h2.planned_effective_date
         ,	h2.status, s2.sort_desc AS status_code, s2.status_type
         ,	h2.class3_id
         ,	CASE WHEN 'DEFAULT' = 'REFDATE' THEN 1 ELSE 0 END AS f_checkRefDate
         FROM specification_header h2
         JOIN status s2 ON ( s2.status = h2.status AND status_type IN ('HISTORIC', 'CURRENT') )
         WHERE h2.part_no LIKE 'X%'
         AND ('DEFAULT' = 'HIGHEST' OR h2.issued_date IS NOT NULL)
 )
 ,	 root_function AS (
 SELECT sk.part_no, sk.kw_value
 FROM specification_kw sk
 JOIN itkw ON ( itkw.kw_id = sk.kw_id AND itkw.description = 'Function' )
 )
 ,	 bom_function AS (
 SELECT f.characteristic_id, f.description
 FROM characteristic f
 JOIN	characteristic_association ca ON ( ca.characteristic = f.characteristic_id AND ca.intl = f.intl )
 JOIN association a ON ( a.association = ca.association AND a.intl = ca.intl )
 WHERE a.description = 'Function'
 )
 ,	 tree (
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
 ) AS (
 SELECT
 p.part_no AS root_part, p.revision AS root_rev
 ,	p.status AS root_status, p.status_type AS root_status_type
 ,	bh.preferred AS root_preferred, bh.alternative AS root_alternative
 ,	p.issued_date AS root_issued_date
 ,	bi.num_1 AS root_density
 ,	p.part_no AS parent_part, p.revision AS parent_rev
 ,	p.status AS parent_status, p.status_type AS parent_status_type
 ,	bi.item_number AS parent_seq
 ,	NULL AS parent_function, NULL AS parent_uom
 ,	bi.component_part AS part_no, hh.revision, bi.plant, bi.item_number
 ,	coalesce(hh.issued_date, hh.planned_effective_date) AS issued_date
 ,	coalesce(hh.obsolescence_date, CURRENT_DATE +1) AS obsolete_date
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
 ,	bh.base_quantity AS parent_quantity
 ,	bi.quantity * 1.0 AS normalized_quantity
 ,	bi.quantity / bi.num_1	AS component_volume
 ,	bi.quantity / bi.num_1	AS volume
 ,	bi.quantity / bi.num_1	AS normalized_volume
 ,	1.0 AS parent_volume
 ,	CASE
 WHEN bi.uom = 'kg' THEN bi.quantity * 1.0
 ELSE NULL
 END
 ,	CASE
 WHEN bi.uom = 'kg' THEN bi.quantity * 1.0
 ELSE NULL
 END
 ,	SUM(CASE
 WHEN bi.uom = 'kg' THEN bi.quantity * 1.0
 ELSE NULL
 END) OVER ()
 ,	1 AS lvl
 ,	ROW_NUMBER() OVER (ORDER BY bi.item_number) -1
 ,	CAST('0000' AS varchar2(120)) AS path
 ,	to_char(bi.item_number, 'FM0999') AS pathNode
 ,	CAST('' AS VARCHAR2(100)) AS parent_branch
 ,	CAST(to_char(bi.item_number, 'FM0999') AS varchar2(100)) AS branch
 ,	CAST ('' AS VARCHAR2(200)) AS indentStr
 ,	CAST(r.kw_value || '.' || f.description AS VARCHAR2(254)) AS breadcrumbs               -->root_function.kw_value ||'.'||bom_function.description
 ,	CAST(p.reference_date AS date)
 ,	CAST(CASE WHEN 'DEFAULT' = 'REFDATE' 
              THEN p.reference_date
              WHEN 'DEFAULT' = 'DEFAULT' AND bi.component_part LIKE 'X%'
              THEN p.issued_date
              ELSE coalesce(p.obsolescence_date, CURRENT_DATE)
              END AS date)
 ,	CASE WHEN p.revision = 1 AND hh.revision = 1 AND p.reference_date < coalesce(hh.issued_date, hh.planned_effective_date)
         THEN '1'
         ELSE '0'
         END AS e_issuedAfterExplDate
 ,	CASE WHEN hh.revision IS NULL THEN 1 ELSE 0 END AS e_noPhantomRevision
 FROM partList p
 LEFT JOIN root_function r ON (r.part_no = p.part_no)
 LEFT JOIN bom_header bh ON (   bh.part_no = p.part_no  AND bh.revision = p.revision  AND bh.preferred = p.preferred )
 LEFT JOIN bom_item bi ON (   bi.part_no = bh.part_no   AND bi.revision = bh.revision AND bi.plant = bh.plant AND bi.alternative = bh.alternative )
 LEFT JOIN specList hh ON (   bi.component_part = hh.part_no
                          AND (   f_checkRefDate = 0
                              OR ( hh.issued_date <= p.reference_date
                                 AND (hh.obsolescence_date IS NULL OR p.reference_date < hh.obsolescence_date)
                                 )
                              ) 
                          AND NOT EXISTS ( SELECT 1
                                           FROM specification_header h2a
                                           JOIN status s2a ON (s2a.status = h2a.status)
                                           WHERE h2a.part_no = hh.part_no
                                           AND h2a.revision > hh.revision
                                           AND s2a.status_type IN ('HISTORIC', 'CURRENT')
                                           AND (  'DEFAULT' <> 'REFDATE'
                                               OR ( h2a.issued_date <= p.reference_date
                                                  AND (h2a.obsolescence_date IS NULL OR p.reference_date < h2a.obsolescence_date)
                                                  )
                                               )
                                          )             
                           )
 LEFT JOIN bom_function f ON (f.characteristic_id = bi.ch_1)
 WHERE 1 = 1
 AND bh.preferred		= 1
 AND bh.alternative	    = 1  --FOC_NONE
 UNION ALL
 SELECT
 t.root_part, t.root_rev
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
 ,	bh.base_quantity AS parent_quantity
 ,	DECODE(bh.base_quantity, 0, 0, bi.quantity * t.normalized_quantity / bh.base_quantity)	AS normalized_quantity
 ,	DECODE(bi.num_1, 0, 0, bi.quantity / bi.num_1)		AS component_volume
 ,	DECODE(bi.num_1, 0, 0, bi.quantity / bi.num_1) * coalesce( t.volume ,	DECODE(bh.base_quantity, 0, 0, bi.quantity / bh.base_quantity) ,	1.0 ) AS volume
 ,	DECODE(bi.num_1, 0, 0, bi.quantity / bi.num_1) * coalesce( t.volume ,	DECODE(bh.base_quantity, 0, 0, bi.quantity * t.normalized_quantity / bh.base_quantity) ,	1.0 ) AS normalized_volume
 ,	t.volume AS parent_volume
 ,	CASE WHEN bi.uom = 'kg'
         THEN DECODE(bh.base_quantity, 0, 0, bi.quantity * t.normalized_quantity / bh.base_quantity)
         ELSE NULL
         END
 ,	CASE WHEN t.uom <> 'kg' AND bi.uom = 'kg'
         THEN DECODE(bh.base_quantity, 0, 0, bi.quantity * t.normalized_quantity / bh.base_quantity)
         ELSE NULL
         END
 ,	SUM(CASE WHEN t.uom <> 'kg' AND bi.uom = 'kg'
             THEN DECODE(bh.base_quantity, 0, 0, bi.quantity * t.normalized_quantity / bh.base_quantity)
             ELSE 0
             END) OVER (PARTITION BY t.branch)
 ,	t.lvl +1									AS lvl
 ,	ROW_NUMBER() OVER (PARTITION BY t.branch ORDER BY bi.item_number) -1
 ,	substr(t.path || '.' || t.pathNode, 1, 120)	AS path
 ,	to_char(bi.item_number, 'FM0999')			AS pathNode
 ,	t.branch									AS parent_branch
 ,	substr(t.branch || '.' || to_char(bi.item_number, 'FM0999'), 1, 100) AS branch
 ,	substr(t.indentStr || ' ; ; ;', 1, 200) AS indentStr
 ,	cast(t.breadcrumbs || '.' || case when f.description is null 
                                      then '(null)'
                                      when f.description = '' 
									  then '(null)'
                                      else f.description
                                      end AS varchar2(254))           as breadcrumbs
 ,	CAST(t.reference_date AS date)
 ,	CAST(CASE WHEN bi.component_part NOT LIKE 'X%' AND 'DEFAULT' = 'REFDATE' 
              THEN t.reference_date
              WHEN bi.component_part LIKE 'X%' AND 'DEFAULT' = 'REFDATE' 
			  THEN t.reference_date
              ELSE t.part_reference_date
              END AS date)
 ,	CASE WHEN t.root_rev = 1  AND hh.revision = 1 AND t.reference_date < coalesce(hh.issued_date, hh.planned_effective_date)
         THEN '1'
         ELSE '0'
         END AS e_issuedAfterExplDate
 ,	CASE WHEN hh.revision IS NULL THEN 1 ELSE 0 END AS e_noPhantomRevision
 FROM tree t
 JOIN bom_header bh ON (   bh.part_no		= t.part_no
                       AND bh.revision		= t.revision
                       AND bh.plant		    = t.plant
                       AND bh.preferred	    = 1
                       AND bh.alternative	= 1 --FOC_NONE
                       )
 JOIN bom_item bi ON (    bh.part_no		= bi.part_no
                     AND bh.revision		= bi.revision
                     AND bh.plant		    = bi.plant
                     AND bh.alternative	    = bi.alternative
                     )
 LEFT JOIN componentList hh ON (    hh.part_no = bi.component_part
                               AND (   f_checkRefDate = 0
                                    OR (     hh.issued_date <= t.reference_date
                                       AND (hh.obsolescence_date IS NULL OR t.reference_date < hh.obsolescence_date)
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
 AND hh.status_type LIKE 'CRRNT%'
 AND t.lvl <= 1 --FOC_NONE
 AND t.revision IS NOT NULL
 AND t.function IS NOT NULL AND t.function NOT LIKE '%FOC_NONE'
 ) CYCLE part_no SET e_cyclic TO '1' DEFAULT '0'
 SELECT t.root_part, t.root_rev, t.breadcrumbs, t.part_no, t.revision
 --,	part.description AS part_description
 --,	weight.weight, weight.uom AS weight_uom
 FROM tree t
 --LEFT JOIN	part ON (part.part_no = f.part_no)
 --LEFT OUTER JOIN avspecification_weight weight ON (weight.part_no = f.part_no)
 ;
 
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	10			XGS_WBTV120TN	1	GYO	10	28-10-2021 09:53:44	10-10-2023 14:16:34	125	CRRNT QR2	CURRENT	700304	Sidewall L/R	1	1	1		1.312		m													0	0	0	0	903394		1	1.312				1				1	0	0000	0010		0010		Greentyre.Sidewall L/R	09-10-2023 10:36:32	15-02-2023 13:59:43	0	0	0
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	20			XGL_LAQ1360F360N	1	GYO	20	17-09-2021 09:52:16	10-10-2023 14:16:34	125	CRRNT QR2	CURRENT	700302	Innerliner assembly	1	1	1		1.312		m													0	0	0	0	903345		1	1.312				1				1	1	0000	0020		0020		Greentyre.Innerliner assembly	09-10-2023 10:36:32	15-02-2023 13:59:43	0	0	0
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	40			XGR_WR01450085	3	GYO	40	26-10-2022 10:53:22	10-10-2023 14:16:34	125	CRRNT QR2	CURRENT	700302	Flipper L	1	1	1		1		m													0	0	0	0	688		1	1				1				1	2	0000	0040		0040		Greentyre.Flipper L	09-10-2023 10:36:32	15-02-2023 13:59:43	0	0	0
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	50			XGR_WR01450085	3	GYO	50	26-10-2022 10:53:22	10-10-2023 14:16:34	125	CRRNT QR2	CURRENT	700302	Flipper R	1	1	1		1		m													0	0	0	0	689		1	1				1				1	3	0000	0050		0050		Greentyre.Flipper R	09-10-2023 10:36:32	15-02-2023 13:59:43	0	0	0
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	90			XGR_PK08490L80	1	GYO	90	12-10-2022 14:35:42	10-10-2023 14:16:34	125	CRRNT QR2	CURRENT	700302	Ply 1	1	1	1		1.323		m													0	0	0	0	903320		1	1.323				1				1	4	0000	0090		0090		Greentyre.Ply 1	09-10-2023 10:36:32	15-02-2023 13:59:43	0	0	0
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	110			XGB_AH138700124543	1	GYO	110	10-05-2022 14:41:25	10-10-2023 14:16:34	125	CRRNT QR2	CURRENT	700302	Bead apex	1	1	1		2		pcs													0	0	0	0	903323		1	2				1				1	5	0000	0110		0110		Greentyre.Bead apex	09-10-2023 10:36:32	15-02-2023 13:59:43	0	0	0
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	120			XGR_GSA1327195	1	GYO	120	15-08-2022 16:31:27	10-10-2023 14:16:34	125	CRRNT QR2	CURRENT	700302	Belt 1	1	1	1		1.838		m													0	0	0	0	903316		1	1.838				1				1	6	0000	0120		0120		Greentyre.Belt 1	09-10-2023 10:36:32	15-02-2023 13:59:43	0	0	0
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	130			XGR_NSA1327185	3	GYO	130	26-11-2021 13:34:15	10-10-2023 14:16:34	125	CRRNT QR2	CURRENT	700302	Belt 2	1	1	1		1.845		m													0	0	0	0	903317		1	1.845				1				1	7	0000	0130		0130		Greentyre.Belt 2	09-10-2023 10:36:32	15-02-2023 13:59:43	0	0	0
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	140			GR_NB01000012	7	GYO	140	29-06-2021 09:53:08	10-10-2023 14:16:34	128	CRRNT QR5	CURRENT	700302	Capstrip	1	1	1		31.44		m													0	0	0	0	903372		1	31.44				1				1	8	0000	0140		0140		Greentyre.Capstrip	09-10-2023 10:36:32	09-10-2023 14:16:34	0	0	0
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	150			XGT_PSTBF66A17D2	4	GYO	150	12-10-2022 14:54:35	10-10-2023 14:16:34	125	CRRNT QR2	CURRENT	700304	Tread	1	1	1		1.857		m													0	0	0	0	903311		1	1.857				1				1	9	0000	0150		0150		Greentyre.Tread	09-10-2023 10:36:32	15-02-2023 13:59:43	0	0	0

--                  BREADCRUMPS
XGG_BF66A17J1	2	Greentyre.Sidewall L/R			XGS_WBTV120TN		1
XGG_BF66A17J1	2	Greentyre.Innerliner assembly	XGL_LAQ1360F360N	1
XGG_BF66A17J1	2	Greentyre.Flipper L				XGR_WR01450085		3
XGG_BF66A17J1	2	Greentyre.Flipper R				XGR_WR01450085		3
XGG_BF66A17J1	2	Greentyre.Ply 1					XGR_PK08490L80		1
XGG_BF66A17J1	2	Greentyre.Bead apex				XGB_AH138700124543	1
XGG_BF66A17J1	2	Greentyre.Belt 1				XGR_GSA1327195		1
XGG_BF66A17J1	2	Greentyre.Belt 2				XGR_NSA1327185		3
XGG_BF66A17J1	2	Greentyre.Capstrip				GR_NB01000012		7
XGG_BF66A17J1	2	Greentyre.Tread					XGT_PSTBF66A17D2	4 


 
 WITH
 cart AS (
 SELECT 'Array' AS origin, 'XGG_BF66A17J1' AS part_no
, to_date('2023/10/09 10:36:32', 'YYYY/MM/DD HH24:MI:SS') AS reference_date
, NULL AS plant FROM dual
 ),
 partList AS (
 SELECT H.part_no, H.revision
 ,	H.issued_date, H.planned_effective_date, H.obsolescence_date
 ,	H.class3_id
 ,	B.plant, B.preferred, B.alternative
 ,	S.status, S.sort_desc AS status_code, S.status_type
 ,	L.reference_date
 FROM cart L
 JOIN specification_header H ON (H.part_no = L.part_no)
 JOIN status S ON (S.status = H.status)
 JOIN class3 C ON (C.class = H.class3_id)
 LEFT JOIN bom_header B ON ( B.part_no 		= H.part_no  AND B.revision 		= H.revision )
 WHERE S.status_type IN ('HISTORIC', 'CURRENT')
 --AND C.sort_desc	= 'FOC_NONE'
 AND B.preferred	= 1
 --AND B.alternative	= FOC_NONE
 AND (L.plant IS NULL OR B.plant = L.plant)
 AND NOT EXISTS ( SELECT 1
                  FROM specification_header
                  JOIN status USING (status)
                  WHERE part_no = H.part_no
                  AND revision > H.revision
                  AND status_type IN ('HISTORIC', 'CURRENT')
                 )
 AND	( 'DEFAULT' <> 'REFDATE'
        OR ( 'DEFAULT' = 'REFDATE'
           AND	L.reference_date >= coalesce(H.issued_date, H.planned_effective_date)
           AND (H.obsolescence_date IS NULL OR L.reference_date < H.obsolescence_date)
           )
        )
 GROUP BY H.part_no, H.revision
 ,	H.issued_date, H.planned_effective_date, H.obsolescence_date
 ,	H.class3_id
 ,	B.plant, B.preferred, B.alternative
 ,	S.status, S.sort_desc, S.status_type
 ,	L.reference_date
 )
 ,	 specList AS (
 SELECT h2.part_no, h2.revision
 ,	h2.issued_date, h2.obsolescence_date, h2.planned_effective_date
 ,	h2.status, s2.sort_desc AS status_code, s2.status_type
 ,	h2.class3_id
 ,	CASE WHEN 'DEFAULT' = 'REFDATE' THEN 1 ELSE 0 END AS f_checkRefDate
 FROM specification_header h2
 JOIN status s2 ON ( s2.status = h2.status AND status_type IN ('HISTORIC', 'CURRENT') )
 WHERE ('DEFAULT' = 'HIGHEST' OR h2.issued_date IS NOT NULL)
 )
 ,	 componentList AS (
         SELECT h2.part_no, h2.revision
         ,	h2.issued_date, h2.obsolescence_date, h2.planned_effective_date
         ,	h2.status, s2.sort_desc AS status_code, s2.status_type
         ,	h2.class3_id
         ,	CASE WHEN 'DEFAULT' = 'REFDATE' THEN 1 ELSE 0 END AS f_checkRefDate
         FROM specification_header h2
         JOIN status s2 ON ( s2.status = h2.status AND status_type IN ('HISTORIC', 'CURRENT') )
         WHERE h2.part_no NOT LIKE 'X%'
         AND ('DEFAULT' = 'HIGHEST' OR h2.issued_date IS NOT NULL)
         UNION ALL
         SELECT h2.part_no, h2.revision
         ,	h2.issued_date, h2.obsolescence_date, h2.planned_effective_date
         ,	h2.status, s2.sort_desc AS status_code, s2.status_type
         ,	h2.class3_id
         ,	CASE WHEN 'DEFAULT' = 'REFDATE' THEN 1 ELSE 0 END AS f_checkRefDate
         FROM specification_header h2
         JOIN status s2 ON ( s2.status = h2.status AND status_type IN ('HISTORIC', 'CURRENT') )
         WHERE h2.part_no LIKE 'X%'
         AND ('DEFAULT' = 'HIGHEST' OR h2.issued_date IS NOT NULL)
 )
 ,	 root_function AS (
 SELECT sk.part_no, sk.kw_value
 FROM specification_kw sk
 JOIN itkw ON ( itkw.kw_id = sk.kw_id AND itkw.description = 'Function' )
 )
 ,	 bom_function AS (
 SELECT f.characteristic_id, f.description
 FROM characteristic f
 JOIN	characteristic_association ca ON ( ca.characteristic = f.characteristic_id AND ca.intl = f.intl )
 JOIN association a ON ( a.association = ca.association AND a.intl = ca.intl )
 WHERE a.description = 'Function'
 )
 ,	 tree (
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
 ) AS (
 SELECT
 p.part_no AS root_part, p.revision AS root_rev
 ,	p.status AS root_status, p.status_type AS root_status_type
 ,	bh.preferred AS root_preferred, bh.alternative AS root_alternative
 ,	p.issued_date AS root_issued_date
 ,	bi.num_1 AS root_density
 ,	p.part_no AS parent_part, p.revision AS parent_rev
 ,	p.status AS parent_status, p.status_type AS parent_status_type
 ,	bi.item_number AS parent_seq
 ,	NULL AS parent_function, NULL AS parent_uom
 ,	bi.component_part AS part_no, hh.revision, bi.plant, bi.item_number
 ,	coalesce(hh.issued_date, hh.planned_effective_date) AS issued_date
 ,	coalesce(hh.obsolescence_date, CURRENT_DATE +1) AS obsolete_date
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
 ,	bh.base_quantity AS parent_quantity
 ,	bi.quantity * 1.0 AS normalized_quantity
 ,	bi.quantity / bi.num_1	AS component_volume
 ,	bi.quantity / bi.num_1	AS volume
 ,	bi.quantity / bi.num_1	AS normalized_volume
 ,	1.0 AS parent_volume
 ,	CASE
 WHEN bi.uom = 'kg' THEN bi.quantity * 1.0
 ELSE NULL
 END
 ,	CASE
 WHEN bi.uom = 'kg' THEN bi.quantity * 1.0
 ELSE NULL
 END
 ,	SUM(CASE
 WHEN bi.uom = 'kg' THEN bi.quantity * 1.0
 ELSE NULL
 END) OVER ()
 ,	1 AS lvl
 ,	ROW_NUMBER() OVER (ORDER BY bi.item_number) -1
 ,	CAST('0000' AS varchar2(120)) AS path
 ,	to_char(bi.item_number, 'FM0999') AS pathNode
 ,	CAST('' AS VARCHAR2(100)) AS parent_branch
 ,	CAST(to_char(bi.item_number, 'FM0999') AS varchar2(100)) AS branch
 ,	CAST ('' AS VARCHAR2(200)) AS indentStr
 ,	CAST(r.kw_value || '.' || f.description AS VARCHAR2(254)) AS breadcrumbs
 ,	CAST(p.reference_date AS date)
 ,	CAST(CASE WHEN 'DEFAULT' = 'REFDATE' 
              THEN p.reference_date
              WHEN 'DEFAULT' = 'DEFAULT' AND bi.component_part LIKE 'X%'
              THEN p.issued_date
              ELSE coalesce(p.obsolescence_date, CURRENT_DATE)
              END AS date)
 ,	CASE WHEN p.revision = 1 AND hh.revision = 1 AND p.reference_date < coalesce(hh.issued_date, hh.planned_effective_date)
         THEN '1'
         ELSE '0'
         END AS e_issuedAfterExplDate
 ,	CASE WHEN hh.revision IS NULL THEN 1 ELSE 0 END AS e_noPhantomRevision
 FROM partList p
 LEFT JOIN root_function r ON (r.part_no = p.part_no)
 LEFT JOIN bom_header bh ON (   bh.part_no = p.part_no  AND bh.revision = p.revision  AND bh.preferred = p.preferred )
 LEFT JOIN bom_item bi ON (   bi.part_no = bh.part_no   AND bi.revision = bh.revision AND bi.plant = bh.plant AND bi.alternative = bh.alternative )
 LEFT JOIN specList hh ON (   bi.component_part = hh.part_no
                          AND (   f_checkRefDate = 0
                              OR ( hh.issued_date <= p.reference_date
                                 AND (hh.obsolescence_date IS NULL OR p.reference_date < hh.obsolescence_date)
                                 )
                              ) 
                          AND NOT EXISTS ( SELECT 1
                                           FROM specification_header h2a
                                           JOIN status s2a ON (s2a.status = h2a.status)
                                           WHERE h2a.part_no = hh.part_no
                                           AND h2a.revision > hh.revision
                                           AND s2a.status_type IN ('HISTORIC', 'CURRENT')
                                           AND (  'DEFAULT' <> 'REFDATE'
                                               OR ( h2a.issued_date <= p.reference_date
                                                  AND (h2a.obsolescence_date IS NULL OR p.reference_date < h2a.obsolescence_date)
                                                  )
                                               )
                                          )             
                           )
 LEFT JOIN bom_function f ON (f.characteristic_id = bi.ch_1)
 WHERE 1 = 1
 AND bh.preferred		= 1
 AND bh.alternative	    = 1  --FOC_NONE
 UNION ALL
 SELECT
 t.root_part, t.root_rev
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
 ,	bh.base_quantity AS parent_quantity
 ,	DECODE(bh.base_quantity, 0, 0, bi.quantity * t.normalized_quantity / bh.base_quantity)	AS normalized_quantity
 ,	DECODE(bi.num_1, 0, 0, bi.quantity / bi.num_1)		AS component_volume
 ,	DECODE(bi.num_1, 0, 0, bi.quantity / bi.num_1) * coalesce( t.volume ,	DECODE(bh.base_quantity, 0, 0, bi.quantity / bh.base_quantity) ,	1.0 ) AS volume
 ,	DECODE(bi.num_1, 0, 0, bi.quantity / bi.num_1) * coalesce( t.volume ,	DECODE(bh.base_quantity, 0, 0, bi.quantity * t.normalized_quantity / bh.base_quantity) ,	1.0 ) AS normalized_volume
 ,	t.volume AS parent_volume
 ,	CASE WHEN bi.uom = 'kg'
         THEN DECODE(bh.base_quantity, 0, 0, bi.quantity * t.normalized_quantity / bh.base_quantity)
         ELSE NULL
         END
 ,	CASE WHEN t.uom <> 'kg' AND bi.uom = 'kg'
         THEN DECODE(bh.base_quantity, 0, 0, bi.quantity * t.normalized_quantity / bh.base_quantity)
         ELSE NULL
         END
 ,	SUM(CASE WHEN t.uom <> 'kg' AND bi.uom = 'kg'
             THEN DECODE(bh.base_quantity, 0, 0, bi.quantity * t.normalized_quantity / bh.base_quantity)
             ELSE 0
             END) OVER (PARTITION BY t.branch)
 ,	t.lvl +1									AS lvl
 ,	ROW_NUMBER() OVER (PARTITION BY t.branch ORDER BY bi.item_number) -1
 ,	substr(t.path || '.' || t.pathNode, 1, 120)	AS path
 ,	to_char(bi.item_number, 'FM0999')			AS pathNode
 ,	t.branch									AS parent_branch
 ,	substr(t.branch || '.' || to_char(bi.item_number, 'FM0999'), 1, 100) AS branch
 ,	substr(t.indentStr || ' ; ; ;', 1, 200) AS indentStr
 ,	cast(t.breadcrumbs || '.' || case when f.description is null 
                                      then '(null)'
                                      when f.description = '' 
									  then '(null)'
                                      else f.description
                                      end AS varchar2(254))
 ,	CAST(t.reference_date AS date)
 ,	CAST(CASE WHEN bi.component_part NOT LIKE 'X%' AND 'DEFAULT' = 'REFDATE' 
              THEN t.reference_date
              WHEN bi.component_part LIKE 'X%' AND 'DEFAULT' = 'REFDATE' 
			  THEN t.reference_date
              ELSE t.part_reference_date
              END AS date)
 ,	CASE WHEN t.root_rev = 1  AND hh.revision = 1 AND t.reference_date < coalesce(hh.issued_date, hh.planned_effective_date)
         THEN '1'
         ELSE '0'
         END AS e_issuedAfterExplDate
 ,	CASE WHEN hh.revision IS NULL THEN 1 ELSE 0 END AS e_noPhantomRevision
 FROM tree t
 JOIN bom_header bh ON (   bh.part_no		= t.part_no
                       AND bh.revision		= t.revision
                       AND bh.plant		    = t.plant
                       AND bh.preferred	    = 1
                       AND bh.alternative	= 1 --FOC_NONE
                       )
 JOIN bom_item bi ON (    bh.part_no		= bi.part_no
                     AND bh.revision		= bi.revision
                     AND bh.plant		    = bi.plant
                     AND bh.alternative	    = bi.alternative
                     )
 LEFT JOIN componentList hh ON (    hh.part_no = bi.component_part
                               AND (   f_checkRefDate = 0
                                    OR (     hh.issued_date <= t.reference_date
                                       AND (hh.obsolescence_date IS NULL OR t.reference_date < hh.obsolescence_date)
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
 AND hh.status_type LIKE 'CURRENT%'
 AND t.lvl <= 1 --FOC_NONE
 AND t.revision IS NOT NULL
 AND t.function IS NOT NULL AND t.function NOT LIKE '%FOC_NONE'
 ) CYCLE part_no SET e_cyclic TO '1' DEFAULT '0'
,	 templateBoM (
    tpl_root_part, tpl_root_revision, tpl_root_description
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
 ) AS ( SELECT sh.part_no, sh.revision,	sh.description
       ,	sh.part_no, sh.revision
       ,	sh.description
       ,	sh.frame_id, sh.frame_rev
       ,	1    item_number
       ,	'1'                                                                    hierarchy
       ,	(SELECT kw_value FROM root_function WHERE part_no = sh.part_no)        function_description
       ,	(SELECT kw_value FROM root_function WHERE part_no = sh.part_no)        function_code
       ,	(SELECT kw_value FROM root_function WHERE part_no = sh.part_no)        functiongrp
       ,	'%' || (SELECT kw_value FROM root_function WHERE part_no = sh.part_no) mask
       ,	0
       FROM specification_header sh
       JOIN status s ON (s.status = sh.status)
       WHERE sh.part_no =   'XGG_BF66A17J1'    --'NONE'
       AND s.status_type = 'CURRENT'
       UNION ALL
       SELECT
       t.tpl_root_part, t.tpl_root_revision, t.tpl_root_description
       ,	bi.component_part
       ,	bish.revision
       ,	bish.description
       ,	bish.frame_id, bish.frame_rev
       ,	bi.item_number
       ,	'1.' || coalesce(bi.char_1, '0.' || to_char(bi.item_number, 'FM0999'))    hierarchy
       ,	bi.char_2                                                                 function_description
       ,	bic.description                                                           function_code
       ,	bi.char_3                                                                 functiongrp
       ,	bi.char_4                                                                 mask
       ,	t.lvl +1
       FROM templateBoM t
       JOIN bom_item                  bi   ON (bi.part_no = t.tpl_part_no and bi.revision = t.tpl_revision)
       LEFT JOIN specification_header bish ON (bish.part_no = bi.component_part)
       LEFT JOIN status               bis  ON (bis.status = bish.status)
       LEFT JOIN characteristic       bic  ON (bic.characteristic_id = bi.ch_1)
       WHERE bis.status_type = 'CURRENT'
       )
 , filtered (
    root_part, root_rev, root_status
 ,	part_no, revision, status_type
 ,	breadcrumbs, item_number
 ,	branch, lvl, indentPart
 ,	tpl_root_part, tpl_root_description
 ,	tpl_part_no, tpl_revision, tpl_description, tpl_item_number
 ,	hierarchy, functiongrp, function_code, function_description, mask
 ,	phr, quantity, density, uom
 ,	num_1, num_2, num_3, num_4, num_5
 ,	char_1, char_2, char_3, char_4, char_5
 ,	date_1, date_2
 ,	boolean_1, boolean_2, boolean_3, boolean_4
 ,	ch_1, ch_2
 ,	normalized_quantity
 ,	component_kg, assembly_kg
 ) AS ( SELECT  p.part_no, p.revision, p.status_type
        ,	p.part_no, p.revision, p.status_type
        ,	r.kw_value, 0
        ,	NULL, 0, p.part_no
        ,	tpl.tpl_root_part, tpl.tpl_root_description
        ,	tpl.tpl_part_no, tpl.tpl_revision, tpl.tpl_description, tpl.tpl_item_number
        ,	tpl.hierarchy, tpl.functiongrp, tpl.function_code, tpl.function_description, tpl.mask
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
        SELECT tree.root_part, tree.root_rev, tree.root_status_type
        ,	tree.part_no, tree.revision,   tree.status_type
        ,	tree.breadcrumbs, tree.item_number
        ,	tree.branch, tree.lvl, tree.indentStr || tree.part_no
        ,	tpl.tpl_root_part, tpl.tpl_root_description
        ,	tpl.tpl_part_no, tpl.tpl_revision, tpl.tpl_description, tpl.tpl_item_number
        ,	tpl.hierarchy, tpl.functiongrp, tpl.function_code, tpl.function_description, tpl.mask
        ,	tree.phr, tree.quantity, tree.density, tree.uom
        ,	tree.num_1, tree.num_2, tree.num_3, tree.num_4, tree.num_5
        ,	tree.char_1, tree.char_2, tree.char_3, tree.char_4, tree.char_5
        ,	tree.date_1, tree.date_2
        ,	tree.boolean_1, tree.boolean_2, tree.boolean_3, tree.boolean_4
        ,	tree.ch_1, tree.ch_2
        ,	tree.normalized_quantity
        ,	tree.component_kg, tree.assembly_kg
        FROM tree
        FULL OUTER JOIN templateBoM tpl ON (tree.breadcrumbs LIKE tpl.mask)
        WHERE EXISTS ( SELECT 1
                       FROM bom_header node
                       WHERE node.part_no		= tree.part_no
                       AND   node.revision		= tree.revision
                       AND   node.alternative	= tree.alternative
                       AND   node.plant		    = tree.plant
                       )
      )
 SELECT f.*
-- ,	part.description AS part_description
-- ,	weight.weight, weight.uom AS weight_uom
 FROM filtered f
-- LEFT JOIN	part ON (part.part_no = f.part_no)
-- LEFT JOIN avspecification_weight weight ON (weight.part_no = f.part_no)
 ORDER BY f.hierarchy
 , f.functiongrp
 , f.item_number
 ;


/*
root-part			status	part_no							breadcrumbs									    branch	    lvl	Indentstr		tpl-root-part	tpl-root-desc			tpl-part-no		rev	tpl-desc				item
XGG_BF66A17J1	2	CURRENT	XGG_BF66A17J1		2	CURRENT	Greentyre									0				0	XGG_BF66A17J1	XGG_BF66A17J1	Greentyre BMW F66A17	XGG_BF66A17J1	2	Greentyre BMW F66A17	1		1	Greentyre	Greentyre	Greentyre	%Greentyre		1	1	pcs																			1		
XGG_BF66A17J1	2	CURRENT	GC_RLB108140		36	CURRENT	Greentyre.Flipper L.Composite				10	0040.0010	2	 ; ; ;GC_RLB108140													0.085		m²													0	0	0	0	903361		0.085		
XGG_BF66A17J1	2	CURRENT	GC_RLB108140		36	CURRENT	Greentyre.Flipper R.Composite				10	0050.0010	2	 ; ; ;GC_RLB108140													0.085		m²													0	0	0	0	903361		0.085		
XGG_BF66A17J1	2	CURRENT	XGS_WBTV120TN		1	CURRENT	Greentyre.Sidewall L/R						10	0010		1	XGS_WBTV120TN													1.312		m													0	0	0	0	903394		1.312		
XGG_BF66A17J1	2	CURRENT	XGR_PK08M900490		1	CURRENT	Greentyre.Ply 1.Reinforcement				10	0090.0010	2	 ; ; ;XGR_PK08M900490													1		m													0	0	0	0	903374		1.323		
XGG_BF66A17J1	2	CURRENT	GB_BH138704543		9	CURRENT	Greentyre.Bead apex.Bead					10	0110.0010	2	 ; ; ;GB_BH138704543													1		pcs													0	0	0	0	903365		2		
XGG_BF66A17J1	2	CURRENT	GC_SAP095105		9	CURRENT	Greentyre.Belt 1.Composite					10	0120.0010	2	 ; ; ;GC_SAP095105													0.195		m²													0	0	0	0	903361		0.35841		
XGG_BF66A17J1	2	CURRENT	GC_SAP095105		9	CURRENT	Greentyre.Belt 2.Composite					10	0130.0010	2	 ; ; ;GC_SAP095105													0.185		m²													0	0	0	0	903361		0.341325		
XGG_BF66A17J1	2	CURRENT	GR_NB01000150		6	CURRENT	Greentyre.Capstrip.Capply					10	0140.0010	2	 ; ; ;GR_NB01000150													0.08		m													0	0	0	0	903326		2.5152		
XGG_BF66A17J1	2	CURRENT	GM_L2002			43	CURRENT	Greentyre.Innerliner assembly.Innerliner compound	20	0020.0020	2	 ; ; ;GM_L2002													0.418		kg													0	0	0	0	903349		0.548416	0.548416	0.548416
XGG_BF66A17J1	2	CURRENT	GM_A4012			9	CURRENT	Greentyre.Bead apex.Apex compound			20	0110.0020	2	 ; ; ;GM_A4012													0.071365		kg													0	0	0	0	903368		0.14273	0.14273	0.14273
XGG_BF66A17J1	2	CURRENT	XGL_LAQ1360F360N	1	CURRENT	Greentyre.Innerliner assembly				20	0020		1	XGL_LAQ1360F360N													1.312		m													0	0	0	0	903345		1.312		
XGG_BF66A17J1	2	CURRENT	GX_T40				4	CURRENT	Greentyre.Belt 1.Belt gum					20	0120.0020	2	 ; ; ;GX_T40													1		m													0	0	0	0	903370		1.838		
XGG_BF66A17J1	2	CURRENT	GM_R5026			11	CURRENT	Greentyre.Sidewall L/R.Rim cushion compound	20	0010.0020	2	 ; ; ;GM_R5026													0.306		kg													0	0	0	0	903347		0.401472	0.401472	0.401472
XGG_BF66A17J1	2	CURRENT	XGX_L170			1	CURRENT	Greentyre.Ply 1.Belt gum					20	0090.0020	2	 ; ; ;XGX_L170													1		m													0	0	0	0	903370		1.323		
XGG_BF66A17J1	2	CURRENT	GM_ST7022			13	CURRENT	Greentyre.Tread.Tread compound				20	0150.0020	2	 ; ; ;GM_ST7022													1.089		kg													0	0	0	0	903348		2.022273	2.022273	2.022273
XGG_BF66A17J1	2	CURRENT	GM_Z5020			11	CURRENT	Greentyre.Sidewall L/R.Sidewall compound	30	0010.0030	2	 ; ; ;GM_Z5020													0.396		kg													0	0	0	0	903346		0.519552	0.519552	0.519552
XGG_BF66A17J1	2	CURRENT	GM_B1054			11	CURRENT	Greentyre.Innerliner assembly.Technical layer compound	30	0020.0030	2	 ; ; ;GM_B1054													0.237		kg													0	0	0	0	903350		0.310944	0.310944	0.310944
XGG_BF66A17J1	2	CURRENT	GM_T3030			10	CURRENT	Greentyre.Tread.Base 1 compound				30	0150.0030	2	 ; ; ;GM_T3030													0.226		kg													0	0	0	0	903312		0.419682	0.419682	0.419682
XGG_BF66A17J1	2	CURRENT	GM_T3008			1	CURRENT	Greentyre.Tread.Wingtip compound			40	0150.0040	2	 ; ; ;GM_T3008													0.042		kg													0	0	0	0	903313		0.077994	0.077994	0.077994
XGG_BF66A17J1	2	CURRENT	XGR_WR01450085		3	CURRENT	Greentyre.Flipper L							40	0040		1	XGR_WR01450085													1		m													0	0	0	0	688		1		
XGG_BF66A17J1	2	CURRENT	XGR_WR01450085		3	CURRENT	Greentyre.Flipper R							50	0050		1	XGR_WR01450085													1		m													0	0	0	0	689		1		
XGG_BF66A17J1	2	CURRENT	GM_T3030			10	CURRENT	Greentyre.Tread.Base 2 compound				50	0150.0050	2	 ; ; ;GM_T3030													0.246		kg													0	0	0	0	903314		0.456822	0.456822	0.456822
XGG_BF66A17J1	2	CURRENT	XGR_PK08490L80		1	CURRENT	Greentyre.Ply 1								90	0090		1	XGR_PK08490L80													1.323		m													0	0	0	0	903320		1.323		
XGG_BF66A17J1	2	CURRENT	XGB_AH138700124543	1	CURRENT	Greentyre.Bead apex							110	0110		1	XGB_AH138700124543													2		pcs													0	0	0	0	903323		2		
XGG_BF66A17J1	2	CURRENT	XGR_GSA1327195		1	CURRENT	Greentyre.Belt 1							120	0120		1	XGR_GSA1327195													1.838		m													0	0	0	0	903316		1.838		
XGG_BF66A17J1	2	CURRENT	XGR_NSA1327185		3	CURRENT	Greentyre.Belt 2							130	0130		1	XGR_NSA1327185													1.845		m													0	0	0	0	903317		1.845		
XGG_BF66A17J1	2	CURRENT	GR_NB01000012		7	CURRENT	Greentyre.Capstrip							140	0140		1	GR_NB01000012													31.44		m													0	0	0	0	903372		31.44		
XGG_BF66A17J1	2	CURRENT	XGT_PSTBF66A17D2	4	CURRENT	Greentyre.Tread								150	0150		1	XGT_PSTBF66A17D2													1.857		m													0	0	0	0	903311		1.857		
*/





--ONDERZOEK VAN TEMPLATEBOM:
SELECT bi.*
FROM  bom_item                  bi   
LEFT JOIN specification_header bish ON (bish.part_no = bi.component_part)
LEFT JOIN status               bis  ON (bis.status = bish.status)
LEFT JOIN characteristic       bic  ON (bic.characteristic_id = bi.ch_1)
WHERE bis.status_type = 'CURRENT'
AND   bi.part_no = 'XGG_BF66A17J1' and bi.revision = 2
;
XGG_BF66A17J1	2	GYO	1	10	XGS_WBTV120TN		GYO	1.312	m			100		0	0	L		N			1							1											903394	100					0	0	0	0	0	0	0	0		0
XGG_BF66A17J1	2	GYO	1	20	XGL_LAQ1360F360N		GYO	1.312	m			100		0	0	L		N			1							1											903345	200					1	0	0	0	0	0	0	0		0
XGG_BF66A17J1	2	GYO	1	40	XGR_WR01450085		GYO	1	m			100		0	0	L		N			1							1											688	100					1	0	0	0	0	0	0	0		0
XGG_BF66A17J1	2	GYO	1	50	XGR_WR01450085		GYO	1	m			100		0	0	L		N			1							1											689	100					1	0	0	0	0	0	0	0		0
XGG_BF66A17J1	2	GYO	1	90	XGR_PK08490L80		GYO	1.323	m			100		0	0	L		N			1							1											903320	100					1	0	0	0	0	0	0	0		0
XGG_BF66A17J1	2	GYO	1	110	XGB_AH138700124543		GYO	2	pcs			100		0	0	L		N			1							1											903323	100					1	0	0	0	0	0	0	0		0
XGG_BF66A17J1	2	GYO	1	120	XGR_GSA1327195		GYO	1.838	m			100		0	0	L		N			1							1											903316	100					1	0	0	0	0	0	0	0		0
XGG_BF66A17J1	2	GYO	1	130	XGR_NSA1327185		GYO	1.845	m			100		0	0	L		N			1							1											903317	100					1	0	0	0	0	0	0	0		0
XGG_BF66A17J1	2	GYO	1	140	GR_NB01000012		GYO	31.44	m			100		0	0	L		N			1							1											903372	100					0	0	0	0	0	0	0	0		0
XGG_BF66A17J1	2	GYO	1	150	XGT_PSTBF66A17D2		GYO	1.857	m			100		0	0	L		N			1							1											903311	100					1	0	0	0	0	0	0	0		0


--ONDERZOEK BOM-HEADER
SELECT *
FROM bom_header node
WHERE node.part_no		= 'XGR_WR01450085'
AND   node.revision		= 3
AND   node.alternative	= 1
AND   node.plant	    = 'GYO'
;
	XGR_WR01450085	3	GYO	1	1					N		1			26-10-2022 00:00:00	1		


--CHARACTERISTIC
select * from characteristic where characteristic_id in (688, 689)
688	Flipper L	1	0
689	Flipper R	1	0

select * from characteristic_association where characteristic_id in (688, 689);
900288	688	1
900288	689	1

select * from association where association=900288;
900288	Function	C	1	0


select * from avspecification_weight WHERE PART_NO IN 'XGR_WR01450085';
5500	XGR_WR01450085	3	M1	CURRENT	XG	RWR01450085	XGRWR01450085	0.136	KG	0	


--ONDERZOEK OF ER NOG MEER PART-NO ZIJN DIE AAN DEZE CHARACTERISTIC GEASSOCIEERD ZIJN.
select * 
from bom_item bi 
where bi.ch_1 in (688, 689)
and component_part in (select sh.part_no from specification_header sh where sh.status=125)
and revision = (select max(sh2.revision) from specification_header sh2 where sh2.part_no = bi.part_no)
;

/*
XGG_BF66A17E1	4	GYO	1	110	XGR_WR01450085		GYO	1	m
XGG_BF66S18F1	1	GYO	1	110	XGR_WR02450075		GYO	1	m
XGG_G23C998A	2	GYO	1	110	XGR_WR01450090		GYO	1	m
XGG_BU06N17D5	1	GYO	1	40	XGR_WR02450090		GYO	1	m
XGG_AU336S18G3	1	GYO	1	110	XGR_WR08450045		GYO	1	m
XGG_AU336S18G1	1	GYO	1	40	XGR_WR08450045		GYO	1	m
XGG_AU336S18G2	1	GYO	1	40	XGR_WR08450045		GYO	1	m
XGG_AU336S18I4	2	GYO	1	40	XGR_WR01450045		GYO	1	m
XGG_AU336S18I3	2	GYO	1	40	XGR_WR01450045		GYO	1	m
XGG_BNA5A20B5	2	GYO	1	40	XGR_WR02450085		GYO	1	m
XGG_BF66A17J1	2	GYO	1	40	XGR_WR01450085		GYO	1	m
XGG_BNA5S20D2	1	GYO	1	40	XGR_WR02450090		GYO	1	m
XGG_BF66A17L3	1	GYO	1	40	XGR_WR01450045		GYO	1	m
XGG_AU336S19J1	1	GYO	1	40	XGR_WR01450045		GYO	1	m
XGG_BI20S20F1	1	GYO	1	40	XGR_WR02450090		GYO	1	m
XGG_G22C034B	1	GYO	1	110	XGR_WR01450080		GYO	1	m
XGG_G22C026C	1	GYO	1	110	XGR_WR02450060		GYO	1	m
XGG_BF66S18H3	1	GYO	1	110	XGR_WR02450080		GYO	1	m
XGG_BF66S18H4	1	GYO	1	110	XGR_WR02450080		GYO	1	m
XGG_G22C073E	2	GYO	1	110	XGR_WR02450035		GYO	35	m
XGG_BF66A17H1	2	GYO	1	40	XGR_WR02450090		GYO	1	m
XGG_BF66S18GCT1	1	GYO	1	110	XGR_WR02450075		GYO	1	m
XGG_AU336S18H2	2	GYO	1	40	XGR_WR01450045		GYO	1	m
XGG_BF66A17I3	1	GYO	1	40	XGR_WR08450085		GYO	1	m
XGG_BNA5S20B5	1	GYO	1	40	XGR_WR02450085		GYO	1	m
XGG_BF66A17M2	1	GYO	1	40	XGR_WR01450090		GYO	1	m
XGG_BNA5W20D4	1	GYO	1	40	XGR_WR02450085		GYO	1.556	m
XGG_BI20S20G3	1	GYO	1	40	XGR_WR02450090		GYO	1.558	m
XGG_BI20S20G4	1	GYO	1	40	XGR_WR02450090		GYO	1.558	m
...
GG_216516QT5NH	47	GYO	1	40	GR_WR01450060		GYO	1	m
GG_216516QT5NH	47	GYO	1	50	GR_WR01450060		GYO	1	m

*/

select part_no, component_part, count(distinct ch_1)
from bom_item bi 
--where part_no = 'XGG_BI20S20G3'  
where  component_part in (select sh.part_no from specification_header sh where sh.status=125)
and  bi.ch_1 NOT in (688, 689)
and revision = (select max(sh2.revision) from specification_header sh2 where sh2.part_no = bi.part_no)
group by part_no, component_part
HAVING count(distinct ch_1) > 1
;
/*
XGT_Test	GM_1897237	2
GT_QTX01B	GM_189708	2
XET_LV570	XEM_B17-2543_04	2
XET_E21335	XEM_774_118	2
XET_E21386	XEM_774_118	2
XET_E21392	XEM_774_120	2
XET_E22425	XEM_B22-1080_01	2
XET_E22515	XEM_B22-1080_01	2
XGG_CHAFER	GR_WW01450045	2
XGG_MichD4	GR_WW01450045	2
XGG_MichD4	XGR_AB01000045	2
XGG_MichD4	XGR_AB01000090	2
XGT_QTX01B	GM_189708	2
XGT_VWCAD5	GM_197669	2
GT_G18C153A	GM_1893001	2
GT_G18C153B	GM_1893001	2
GT_G19C032B	GM_1997006	2
XEG_E21411A	XES_E21411	2
XEG_E21411B	XES_E21411	2
XEG_E21411C	XES_E21411	2
XEG_E21411D	XES_E21411	2
XEG_E21411E	XES_E21411	2
XET_E19B452	XEM_B18-2415_20	2
XET_E20B371	XEM_B18-2415_20	2
XET_E22354A	XEM_774_135	2
XET_E22354B	XEM_B20-3457_17	2
...
*/

--CHARACTERISTIC <> 688/689
select part_no, component_part, count(distinct ch_1)
from bom_item bi 
--where part_no = 'XGG_BI20S20G3'  
where  component_part in (select sh.part_no from specification_header sh where sh.status=125)
and  bi.ch_1 NOT in (688, 689)
and revision = (select max(sh2.revision) from specification_header sh2 where sh2.part_no = bi.part_no)
group by part_no, component_part
HAVING count(distinct ch_1) > 1
;

/*
XGT_Test	GM_1897237	2
GT_QTX01B	GM_189708	2
XET_LV570	XEM_B17-2543_04	2
XET_E21335	XEM_774_118	2
XET_E21386	XEM_774_118	2
XET_E21392	XEM_774_120	2
XET_E22425	XEM_B22-1080_01	2
XET_E22515	XEM_B22-1080_01	2
XGG_CHAFER	GR_WW01450045	2
XGG_MichD4	GR_WW01450045	2
XGG_MichD4	XGR_AB01000045	2
XGT_QTX01B	GM_189708	2
XGT_VWCAD5	GM_197669	2
GT_G18C153A	GM_1893001	2
GT_G18C153B	GM_1893001	2
GT_G19C032B	GM_1997006	2
XEG_E21411A	XES_E21411	2
XEG_E21411B	XES_E21411	2
XEG_E21411C	XES_E21411	2
XEG_E21411D	XES_E21411	2
XEG_E21411E	XES_E21411	2
XET_E19B452	XEM_B18-2415_20	2
XET_E20B371	XEM_B18-2415_20	2
XET_E22354A	XEM_774_135	2
XET_E22354B	XEM_B20-3457_17	2
XET_E22354C	XEM_B22-1500_01	2
...
XGT_PSTU11S18AL4	GM_222072A	2
XGT_PSTBU11S18WCT3	GM_211570	2
XGT_PSTBU11S18WCT4	GM_201557	2
*/


select part_no, component_part, ch_1
from  bom_item bi2
where exists 
(
select bi.part_no, bi.component_part, count(distinct bi.ch_1)
from bom_item bi 
where bi.part_no = bi2.part_no
and   bi.revision = bi2.revision
AND   bi.component_part = bi2.component_part
and   bi.component_part in (select sh.part_no from specification_header sh where sh.status=125 and sh.part_no = bi.component_part)
and   bi.ch_1 NOT in (688, 689)
and   bi.revision = (select max(sh2.revision) from specification_header sh2 where sh2.part_no = bi.part_no)
group by bi.part_no, bi.component_part
HAVING count(distinct bi.ch_1) > 1
)
;
/*
GT_G19C032B	GM_1997006	903348
GT_G19C032B	GM_1997006	903314
XGT_G19C040A	GM_1993003	903312
XGT_G19C040A	GM_1993003	903314
XGT_G19C040B	GM_1993003	903312
XGT_G19C040B	GM_1993003	903314
XGT_PSTBMW181	GM_1897237	903348
XGT_PSTBMW181	GM_1897237	903314
XGT_PSTBMW181C	GM_1897237	903348
XGT_PSTBMW181C	GM_1897237	903314
XGT_G19C012B	GM_1997003	903348
XGT_G19C012B	GM_1997003	903314
XGT_G19C012C	GM_1997004	903348
XGT_G19C012C	GM_1997004	903314
XGT_G19C012D	GM_1997005	903348
XGT_G19C012D	GM_1997005	903314
XGT_PSTRFT181C	GM_1897237	903348
XGT_PSTRFT181C	GM_1897237	903314
XGT_AU272SB		XGM_1997021	903348
XGT_AU272SB		XGM_1997021	903314
XGT_AU272SA1	GM_1897126	903348
XGT_AU272SA1	GM_1897126	903314
XGT_PSTBMW1617C	GM_1897237	903348
XGT_PSTBMW1617C	GM_1897237	903314
XGT_PSTBMW1617C3	XGM_1997021	903348
XGT_PSTBMW1617C3	XGM_1997021	903314
XGT_G18C139A	GM_1897115	903348
XGT_G18C139A	GM_1897115	903314
XGT_Test		GM_1897237	903348
XGT_Test		GM_1897237	903314
XGT_G19C042A2	XGM_1997007	903348
XGT_G19C042A2	XGM_1997007	903314
XGT_G19C042A4	XGM_1897115	903348
XGT_G19C042A4	XGM_1897115	903314
XGT_G21C133C	GM_211644	903348
XGT_G21C133C	GM_211644	903314
XGT_G21C133		GM_211835A	903348
XGT_G21C133		GM_211835A	903314
XGT_G21C133D	GM_211717	903348
XGT_G21C133D	GM_211717	903314
XGT_AU272SA		GM_1897126	903348
XGT_AU272SA		GM_1897126	903314
XGT_AU272SA2	XGM_1997021	903348
XGT_AU272SA2	XGM_1997021	903314
XGT_PSTBMW181C3	XGM_1997021	903348
XGT_PSTBMW181C3	XGM_1997021	903314
XET_E22355A		XEM_774_135	903348
XET_E22355A		XEM_774_135	903314
XGT_AU274SB2	GM_ST7076	903348
XGT_AU274SB2	GM_ST7076	903314
XET_E19B452		XEM_B18-2415_20	903312
XET_E19B452		XEM_B18-2415_20	903314
XGT_PSTBMWF40	GM_1897126	903348
XGT_PSTBMWF40	GM_1897126	903314
XGT_PSTBMW1617K3	GM_201538	903348
XGT_PSTBMW1617K3	GM_201538	903314
XGT_PSTBMW181K3	GM_201538	903348
XGT_PSTBMW181K3	GM_201538	903314
XGT_PSTBMW1617L3	GM_201538	903348
XGT_PSTBMW1617L3	GM_201538	903314
XGT_G19C086D	XGM_197750	903348
XGT_G19C086D	XGM_197750	903314
XGT_G19C096C4	XGM_1997010	903348
XGT_G19C096C4	XGM_1997010	903314
XGT_PSTBMWBU11A1	GM_1897126	903348
XGT_PSTBMWBU11A1	GM_1897126	903314
XGT_PSTBF66S18J1	GM_211835A	903348
XGT_PSTBF66S18J1	GM_211835A	903314
XGT_G19C109B	GM_203781	903348
XGT_G19C109B	GM_203781	903314
XGT_PSTBMW181C5	XGM_1997010	903348
XGT_PSTBMW181C5	XGM_1997010	903314
XGT_G20C085		GM_ST7064	903348
XGT_G20C086		GM_ST7064	903348
XGT_G20C086		GM_ST7064	903314
XGT_G20C085		GM_ST7064	903314
XET_E22355D		XEM_B22-1501_01	903314
XET_E22355B		XEM_B20-3457_17	903348
...
*/


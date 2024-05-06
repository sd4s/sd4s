--INT00040P_BOM
/*
WITH
-INCLUDE INT00011P2_BoM_explosion_SQL
-INCLUDE INT00013P_BoM_template
-INCLUDE INT00013P_BoM_filter
 
SELECT f.*
,	part.description AS part_description
,	weight.weight, weight.uom AS weight_uom
  FROM filtered f
  LEFT JOIN	part ON (part.part_no = f.part_no)
  LEFT JOIN avspecification_weight weight ON (weight.part_no = f.part_no)
 ORDER BY
	f.hierarchy, f.functiongrp, f.item_number
;
*/



WITH cart AS 
 (SELECT 'Array'                                                AS origin
 ,      'EF_540/65R34TVZM45'                                    AS part_no
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
 AND C.sort_desc	= 'FOC_NONE'
 AND B.preferred	= 1
 AND B.alternative	= FOC_NONE
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
 ,	substr(t.indentStr || '&nbsp;&nbsp;&nbsp;', 1, 200)                   AS indentStr
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
 JOIN bom_header bh ON ( bh.part_no		= t.part_no AND bh.revision		= t.revision AND bh.plant		= t.plant AND bh.preferred	= 1 AND bh.alternative	= FOC_NONE )
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
 AND hh.status_type = 'FOC_NONE'
 AND t.lvl          <= FOC_NONE
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
 WHERE sh.part_no    = 'NONE'
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
 ORDER BY  f.hierarchy
 ,         f.functiongrp
 ,         f.item_number
 ;

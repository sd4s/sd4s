--view_2_1_1_3_1_partno_dispersion.sql
--Report name : UNI00036R_dispersion	
--Called from: UNI00403R_execution	execution-dashboard
--					"UNI00403R1_requests	"	request-to-execute
--						UNI00403R31	method-details
--							field: part-no
--

/*
WITH partList AS (
SELECT p.part_no AS part_no
FROM part p
)
*/

DROP VIEW sc_lims_dal.av_exec_db_partno_dispersion;
--
CREATE OR REPLACE VIEW  sc_lims_dal.av_exec_db_partno_dispersion
AS
WITH partList AS (
SELECT 'XEM_B18-1164_46' AS part_no
,      to_date('29-11-2023 12:18:41','dd-mm-yyyy hh24:mi:ss') AS default_reference_date 
--FROM dual
)
, specs AS (
SELECT	 H.part_no
, H.revision
, H.description AS part
, H.frame_id
, H.frame_rev
, H.created_by
, H.planned_effective_date
, H.issued_date
, H.obsolescence_date
, H.class3_id
, B.alternative
, B.preferred
, S.status
, S.sort_desc AS status_code
, S.description AS status_desc
, S.status_type
, L.default_reference_date AS reference_date
FROM specification_header H
JOIN partList             L ON (H.part_no = L.part_no)
JOIN status               S ON (S.status = H.status)
LEFT JOIN bom_header      B ON ( B.part_no = H.part_no AND B.revision = H.revision )
WHERE S.status_type IN ('CURRENT', 'HISTORIC')
AND B.preferred = 1
--AND B.alternative = 1
AND NOT EXISTS (SELECT 1
				FROM specification_header  sh2
				JOIN status                 s2 USING (status)
				WHERE sh2.part_no  = H.part_no
				AND   sh2.revision > H.revision
				AND    s2.status_type IN ('CURRENT','HISTORIC')
               )
AND	L.default_reference_date >= coalesce(H.issued_date, H.planned_effective_date)
AND (  H.obsolescence_date IS NULL 
    OR L.default_reference_date < H.obsolescence_date)
AND EXISTS (SELECT 1 FROM class3 C WHERE C.class = H.class3_id )   
GROUP BY H.part_no
, H.revision
, H.description
, H.planned_effective_date
, H.issued_date
, H.obsolescence_date
, H.frame_id
, H.frame_rev
, H.created_by
, H.class3_id
, B.alternative
, B.preferred
, S.status
, S.sort_desc
, S.description
, S.status_type
, L.default_reference_date
)  
--select sp.* from specs sp;
--XEM_B18-1164_46	1	B168 w/TSR20 - lab ref -3 stages	Trial E_ FM	30	EGT	23-11-2023 00:00:00	23-11-2023 15:58:16		700362	1	1	154	TEMP CRRNT	Temporary Current	CURRENT	29-11-2023 12:18:41
--* Top specifications filtered by scenario
, specList AS (
SELECT	h2.part_no
, h2.revision
, h2.issued_date
, h2.obsolescence_date
, h2.planned_effective_date
, h2.status
, s2.sort_desc AS status_code
, s2.status_type
, h2.class3_id
--, CASE WHEN '$$TOP_SCENARIO' = 'REFDATE' THEN 1 ELSE 0 END AS f_checkRefDate
FROM specification_header h2
JOIN status               s2 ON ( s2.status = h2.status AND status_type IN ('CURRENT','HISTORIC') )
WHERE h2.issued_date IS NOT NULL
--WHERE ('$$TOP_SCENARIO' = 'HIGHEST' OR h2.issued_date IS NOT NULL)
)
--* Component specifications filtered according to selected scenario
, componentList AS (
--*	Production specs
SELECT	h2.part_no
, h2.revision
, h2.issued_date
, h2.obsolescence_date
, h2.planned_effective_date
, h2.status
, s2.sort_desc AS status_code
, s2.status_type
, h2.class3_id
--, CASE WHEN '$$PROD_SCENARIO' = 'REFDATE' THEN 1 ELSE 0 END AS f_checkRefDate
FROM specification_header h2
JOIN status s2 ON (s2.status = h2.status AND status_type IN ('CURRENT','HISTORIC') )
WHERE h2.part_no     NOT LIKE 'X%'
AND   h2.issued_date IS NOT NULL
--AND ('$$PROD_SCENARIO' = 'HIGHEST' OR h2.issued_date IS NOT NULL)
UNION ALL
--*	Trial specs
SELECT	h2.part_no
, h2.revision
, h2.issued_date
, h2.obsolescence_date
, h2.planned_effective_date
, h2.status
, s2.sort_desc AS status_code
, s2.status_type
, h2.class3_id
--,	CASE WHEN '$$TRIAL_SCENARIO' = 'REFDATE' THEN 1 ELSE 0 END AS f_checkRefDate
FROM specification_header h2
JOIN status s2 ON (	s2.status = h2.status AND status_type IN ('CURRENT','HISTORIC') )
WHERE h2.part_no LIKE 'X%'
AND   h2.issued_date IS NOT NULL
--AND ('$$TRIAL_SCENARIO' = 'HIGHEST' OR h2.issued_date IS NOT NULL)
)
--*
--* Hierarchical list based on above parts (this is a so-called "recursive CTE"; SQL92 standard)
--*
--* CTE field list
, tree (
--*		Current node
  part_no
, revision
, plant
, item_number
, status
, status_code
, status_type
, class3_id
--*		Parent fields
, parent_part
, parent_rev
, parent_status
, parent_status_type
--*		Part details
, alternative
, preferred
, phr
, quantity
, density
, root_density
, uom
, num_1, num_2, num_3, num_4, num_5
, char_1, char_2, char_3, char_4, char_5
, date_1, date_2
, boolean_1, boolean_2, boolean_3, boolean_4
, ch_1, ch_2
, issued_date
, obsolete_date
--*		Root node
, root_part
, root_rev
, root_status
, root_status_type
, root_alternative
, root_preferred
, root_issued_date
, root_reference_date
--*		BoM Explosion behaviour
, reference_date
, part_reference_date
--*		Calculated fields
, lvl
, path
, pathNode
, parent_branch
, parent_seq
, parent_quantity
, normalized_quantity
, component_volume
, volume
, normalized_volume
, parent_volume
, branch
, indentStr
, breadcrumbs
, e_issuedAfterExplDate
, e_noPhantomRevision
) AS (
--*	Initial query: "Anchor" members, containing the top-level items of the BoMs for each part
SELECT
--*		Current node
  b1.component_part AS part_no
, hh.revision
, b1.plant
, b1.item_number
, hh.status
, hh.status_code
, hh.status_type
, hh.class3_id
--*		Parent fields (= root here)
, p.part_no     AS parent_part
, p.revision    AS parent_rev
, p.status      AS parent_status
, p.status_type AS parent_status_type
--*		Part details
, b1.alternative
, bh1.preferred
, b1.num_5      AS phr
, b1.quantity
, b1.num_1      AS density
, b1.num_1      AS root_density
, b1.uom
, b1.num_1, b1.num_2, b1.num_3, b1.num_4, b1.num_5
, b1.char_1, b1.char_2, b1.char_3, b1.char_4, b1.char_5
, b1.date_1, b1.date_2
, b1.boolean_1, b1.boolean_2, b1.boolean_3, b1.boolean_4
, b1.ch_1, b1.ch_2
, coalesce(hh.issued_date, hh.planned_effective_date) AS issued_date
, hh.obsolescence_date                                AS obsolete_date
--*		Root node
, p.part_no       AS root_part
, p.revision      AS root_rev
, p.status        AS root_status
, p.status_type   AS root_status_type
, b1.alternative  AS root_alternative
, bh1.preferred   AS root_preferred
, p.issued_date   AS root_issued_date
, CAST(p.reference_date AS date)                                 AS root_reference_date
--*		Behaviour
, CAST(p.reference_date AS date)                                 AS reference_date
, CAST( p.reference_date AS date)                                AS  part_reference_date  
--*		Calculated fields
, 1                                                         AS lvl
, CAST('0000' AS char(120))                             AS path
, to_char(b1.item_number, 'FM0999')                         AS pathNode
, CAST('' AS CHAR(100))                                 AS parent_branch
, b1.item_number                                            AS parent_seq
, bh1.base_quantity                                         AS parent_quantity
, b1.quantity * 1 / 1                                       AS normalized_quantity
, DECODE(b1.num_1, 0, 0, b1.quantity / b1.num_1)            AS component_volume
, DECODE(b1.num_1, 0, 0, b1.quantity / b1.num_1)            AS volume
, DECODE(b1.num_1, 0, 0, b1.quantity / b1.num_1)            AS normalized_volume
, 1                                                         AS parent_volume
, CAST(to_char(b1.item_number, 'FM0999') AS char(100))  AS branch
, CAST ('' AS CHAR(200))                                AS indentStr
, CAST('Top' AS CHAR(200))                              AS breadcrumbs
--*		Sanity checks
, CASE WHEN p.revision = 1 AND hh.revision = 1 AND p.reference_date < coalesce(hh.issued_date, hh.planned_effective_date)
			THEN '1'
			ELSE '0'
		END                                                 AS e_issuedAfterExplDate
, CASE WHEN hh.revision IS NULL THEN 1 ELSE 0 END           AS e_noPhantomRevision
FROM      specs        p
LEFT JOIN bom_header bh1 ON (p.part_no = bh1.part_no AND p.revision = bh1.revision AND p.alternative = bh1.alternative )
LEFT JOIN bom_item    b1 ON (   b1.part_no     = bh1.part_no
                            AND b1.revision    = bh1.revision
                            AND b1.plant       = bh1.plant
                            AND b1.alternative = bh1.alternative
                           )
LEFT JOIN specList    hh ON (   b1.component_part = hh.part_no
		                    AND (   hh.issued_date <= p.reference_date
                                AND (hh.obsolescence_date IS NULL OR p.reference_date < hh.obsolescence_date)
                                )
                            AND NOT EXISTS (--*			XXX: Using specList here performs badly
                                            SELECT 1
                                           FROM specification_header h2a
                                           JOIN status               s2a ON (s2a.status = h2a.status)
                                            WHERE h2a.part_no = hh.part_no
                                           AND h2a.revision > hh.revision
                                           AND s2a.status_type IN ('CURRENT','HISTORIC')
                                           AND (    h2a.issued_date <= p.reference_date
                                                AND (h2a.obsolescence_date IS NULL OR p.reference_date < h2a.obsolescence_date)
                                                )
                                           )
                            )
LEFT JOIN class3 c3   ON (c3.class = hh.class3_id)
WHERE 1 = 1
AND bh1.preferred	= 1
--AND bh1.alternative	= $$ALTERNATIVE
UNION ALL
--*====================================
--*	Repeated query: Recursive members
--*====================================
--*	Fields "root_part" and "root_rev" are passed on verbatim and thus will keep returning the original values from the initial part of the query.
--*	All other values get modified based on the values of their respective parent nodes values.
SELECT  
--*		Current node
  b2.component_part                                AS part_no
, hh.revision
, t.plant
, b2.item_number
, hh.status
, hh.status_code
, hh.status_type
, hh.class3_id
--*		Parent node
, t.part_no                                        AS parent_part
, t.revision                                       AS parent_rev
, t.status                                         AS parent_status
, t.status_type                                    AS parent_status_type
--*		Part details
, b2.alternative
, bh2.preferred
, b2.num_5                                         AS phr
, b2.quantity
, b2.num_1                                         AS density
, t.root_density
, b2.uom
, b2.num_1, b2.num_2, b2.num_3, b2.num_4, b2.num_5
, b2.char_1, b2.char_2, b2.char_3, b2.char_4, b2.char_5
, b2.date_1, b2.date_2
, b2.boolean_1, b2.boolean_2, b2.boolean_3, b2.boolean_4
, b2.ch_1, b2.ch_2
, coalesce(hh.issued_date, hh.planned_effective_date)      AS issued_date
, hh.obsolescence_date                                     AS obsolete_date
--*		Root node
, t.root_part
, t.root_rev
, t.root_status
, t.root_status_type
, t.root_alternative
, t.root_preferred
, t.root_issued_date
, CAST(t.root_reference_date AS date)                    AS root_reference_date
--*		Behaviour
, CAST(t.reference_date AS date)                         AS reference_date
, CAST(part_reference_date AS date)                      as part_reference_date
--*		Calculated fields
, t.lvl +1                                               AS lvl
, substring(t.path || '.' || t.pathNode, 1, 120)            AS path
, to_char(b2.item_number, 'FM0999')                      AS pathNode
, t.branch                                               AS parent_branch
, t.item_number                                          AS parent_seq
, bh2.base_quantity                                       AS parent_quantity
, DECODE(bh2.base_quantity, 0, 0, b2.quantity * t.normalized_quantity / bh2.base_quantity)   AS normalized_quantity
, DECODE(b2.num_1, 0, 0, b2.quantity / b2.num_1)                                             AS component_volume
, DECODE(b2.num_1, 0, 0, b2.quantity / b2.num_1) * coalesce(t.volume,DECODE(bh2.base_quantity, 0, 0, b2.quantity / bh2.base_quantity), 1.0 )                       AS volume
, DECODE(b2.num_1, 0, 0, b2.quantity / b2.num_1) * coalesce(t.volume,DECODE(bh2.base_quantity, 0, 0, b2.quantity * t.normalized_quantity / bh2.base_quantity),1.0) AS normalized_volume
, t.volume                                                                                   AS parent_volume
, substring(t.branch || '.' || to_char(b2.item_number, 'FM0999'), 1, 100)                       AS branch
, substring(t.indentStr || ';' , 1, 200)                                                        AS indentStr
, substring(t.breadcrumbs || ' / ' || b2.part_no, 1, 200)                                       AS breadcrumbs
--*		Sanity checks
,	CASE WHEN t.root_rev = 1 AND hh.revision = 1 AND t.reference_date < coalesce(hh.issued_date, hh.planned_effective_date)
		THEN '1'
		ELSE '0'
	END                                                                                      AS e_issuedAfterExplDate
,	CASE WHEN hh.revision IS NULL THEN 1 ELSE 0 END                                          AS e_noPhantomRevision
--* parent-node record from table "tree" (= this CTE)
FROM tree         t
JOIN bom_header bh2 ON ( bh2.part_no = t.part_no   AND bh2.revision = t.revision   AND bh2.plant = t.plant   AND bh2.preferred = 1 )
JOIN bom_item    b2 ON ( b2.part_no	 = bh2.part_no AND b2.revision  = bh2.revision AND b2.plant  = bh2.plant AND b2.alternative	= bh2.alternative )
--* component part + rev @ date range
LEFT JOIN componentList hh ON (   b2.component_part = hh.part_no 
                              AND (   hh.issued_date <= t.reference_date
                                  AND (hh.obsolescence_date IS NULL OR t.reference_date < hh.obsolescence_date)
                                  )
                              AND NOT EXISTS (
                                  --* Production specs; XXX: using componentList here performs badly
                                  SELECT 1
                                 FROM specification_header h2a
                                 JOIN status s2a ON ( s2a.status = h2a.status AND s2a.status_type IN ('CURRENT','HISTORIC'))
                                 WHERE h2a.part_no = hh.part_no
                                 AND h2a.part_no NOT LIKE 'X%'
                                 AND h2a.revision > hh.revision
                                 AND h2a.issued_date IS NOT NULL
                                  UNION ALL
                                  --* Trial specs
                                  SELECT 1
                                 FROM specification_header h2a
                                 JOIN status s2a ON (	s2a.status = h2a.status	AND s2a.status_type IN ('CURRENT','HISTORIC') )
                                 WHERE h2a.part_no = hh.part_no
                                 AND h2a.part_no LIKE 'X%'
                                 AND h2a.revision > hh.revision
                                 AND h2a.issued_date IS NOT NULL
                                  )
                              )
WHERE 1 = 1
AND t.lvl < 2
--* Stop recursion for missing components
AND t.revision IS NOT NULL
)   -- $$BOM_CYCLE_CHECK
SELECT root_part
, root_rev
, root_status
, root_status_type
, root_part || ' [' || root_rev || ']'     AS root_part_rev
, alternative
, preferred
, root.description                         AS root_description
, root_alternative
, root_preferred
, root_issued_date
, root_reference_date
, tree.part_no
, tree.revision
, tree.plant
, tree.item_number
, part.description                         AS part_description
, tree.status_code
, tree.status_type
, coalesce(plant.description, tree.plant, 'Plant not specified') AS plant_desc
, C3.sort_desc                             AS spec_type
, CAST(issued_date AS date)                AS issued_date
, CAST(obsolete_date AS date)              AS obsolete_date
, part_reference_date                      AS reference_date
, kw.kw_value                              AS function
, kw.kw_label
, phr
, quantity
, density
, root_density
, component_volume
, volume
, normalized_volume
, parent_volume
, normalized_quantity
, to_char(SUM(quantity))                   AS quantity_str
, tree.uom
, num_1, num_2, num_3, num_4, num_5
, char_1, char_2, char_3, char_4, char_5
, date_1, date_2
, boolean_1, boolean_2, boolean_3, boolean_4
, ch_1, ch_2
, parent_part
, parnt.description                        AS parent_description
, parent_rev
, parent_status
, parent_status_type
, parent_part || ' [' || parent_rev || ']' AS parent_part_rev
, parent_kw.kw_value                       AS parent_function
, lvl
, pathNode
, indentstr
, indentstr || tree.part_no                AS indent_part
, path
, branch
, parent_branch
, parent_seq
, parent_quantity
, tree.normalized_quantity
, path || '.' || pathNode                  AS fullpath
, breadcrumbs
, e_issuedAfterExplDate
, e_noPhantomRevision
--, $$BOM_TOP_DUMMY e_cyclic
, CASE WHEN EXISTS (SELECT 1 FROM bom_item c WHERE c.part_no = tree.part_no) THEN 0 ELSE 1 END AS leaf
, part_cost.price
, part_cost.uom                           AS cost_per_uom
, part_cost.currency
, part_cost.period                        AS cost_period
, part_cost.price * tree.normalized_quantity * ( CASE
                           WHEN tree.uom = 'g' AND part_cost.uom = 'kg' THEN 0.001
                           WHEN tree.uom = 'mm' AND part_cost.uom = 'm' THEN 0.001
                           WHEN tree.uom = 'kg' AND part_cost.uom = 'g' THEN 1000.0
                           WHEN tree.uom = 'm' AND part_cost.uom = 'mm' THEN 1000.0
                           ELSE 1.0
                           END  )           AS cost
FROM      tree
JOIN      part    root ON (tree.root_part   = root.part_no)
LEFT JOIN class3    c3 ON (c3.class         = tree.class3_id)
LEFT JOIN part   parnt ON (tree.parent_part = parnt.part_no)
LEFT JOIN part         ON (tree.part_no     = part.part_no)
LEFT JOIN (	SELECT part_no
            , kw_value
			, itkw.description AS kw_label
            FROM specification_kw skw
            JOIN itkw                  ON (skw.kw_id = itkw.kw_id AND itkw.description IN ('Function', 'Spec. Function') )
          ) kw ON (tree.part_no = kw.part_no)
LEFT JOIN (	SELECT part_no, kw_value
            FROM specification_kw skw
            JOIN itkw                  ON (skw.kw_id = itkw.kw_id AND itkw.description IN ('Function', 'Spec. Function') )
          ) parent_kw ON (tree.parent_part = parent_kw.part_no)
LEFT JOIN plant       ON (tree.plant = plant.plant)
LEFT JOIN part_cost   ON (tree.part_no = part_cost.part_no AND tree.plant = part_cost.plant)
WHERE 1 = 1
-- AND kw.kw_value = '$$FUNCTION'           --'
-- AND parent_kw.kw_value = ''$$PARENT_FUNCTION'   --'
-- AND parent_branch = '$$PARENT_BRANCH'
GROUP BY root_part
, root_rev
, root_status
, root_status_type
, alternative
, preferred
, root.description
, root_alternative
, root_preferred
, root_issued_date
, root_reference_date
, tree.part_no
, tree.revision
, tree.plant
, tree.item_number
, part.description
, tree.status_code
, tree.status_type
, plant.description
, C3.sort_desc
, issued_date
, obsolete_date
, part_reference_date
, kw.kw_value
, kw.kw_label
, phr
, quantity
, density
, root_density
, component_volume
, volume
, normalized_volume
, parent_volume
, normalized_quantity
, tree.uom
, num_1, num_2, num_3, num_4, num_5
, char_1, char_2, char_3, char_4, char_5
, date_1, date_2
, boolean_1, boolean_2, boolean_3, boolean_4
, ch_1, ch_2
, parent_part
, parnt.description
, parent_rev
, parent_kw.kw_value
, parent_status
, parent_status_type
, lvl
, path
, branch
, pathNode
, parent_branch
, parent_seq
, parent_quantity
, tree.normalized_quantity
, indentstr
, breadcrumbs
, e_issuedAfterExplDate
, e_noPhantomRevision 
--, $$BOM_FULL_CYCLE
, part_cost.price
, part_cost.uom
, part_cost.currency
, part_cost.period
ORDER BY root_part
, root_rev
, preferred DESC
, alternative
, path DESC
, lvl
, tree.part_no
, tree.revision
, tree.plant
;

/*
XEM_B18-1164_46	1	154	CURRENT	XEM_B18-1164_46 [1]	1	1	B168 w/TSR20 - lab ref -3 stages	1	1	23-11-2023 15:58:16	29-11-2023 12:18:41	160200	6	ENS	40	DCBS ( N,N'-Dicyclohexyl-2-Benzothiazyl Sulphenamide )	CURRENT	CURRENT	Enschede Plant	RUB CHEM	03-10-2018 13:55:32		29-11-2023 12:18:41	Global	Spec. Function	1.1	0.0066835	1.2	1.2	0.005569583333333333333333333333333333333333	0.005569583333333333333333333333333333333333	0.005569583333333333333333333333333333333333	1	0.0066835	.0066835	kg	1.2	1	1.2	0	1.1								0	0	0	0			XEM_B18-1164_46	B168 w/TSR20 - lab ref -3 stages	1	154	CURRENT	XEM_B18-1164_46 [1]	Compound	1	0040		160200	0000	0040		40	1.193248	0.0066835	0000.0040	Top	0	0	1	1	kg	EU	manual	0.0066835
XEM_B18-1164_46	1	154	CURRENT	XEM_B18-1164_46 [1]	1	1	B168 w/TSR20 - lab ref -3 stages	1	1	23-11-2023 15:58:16	29-11-2023 12:18:41	160612	3	ENS	50	20 % Oil Treated Insoluble Sulphur	CURRENT	CURRENT	Enschede Plant	VULC AGENT	28-08-2018 15:52:31		29-11-2023 12:18:41	Manufacturer	Spec. Function	5.6	0.0340251	1.58	1.58	0.0215348734177215189873417721518987341772	0.0215348734177215189873417721518987341772	0.0215348734177215189873417721518987341772	1	0.0340251	.0340251	kg	1.58	1	1.58	0	5.6								0	0	0	0			XEM_B18-1164_46	B168 w/TSR20 - lab ref -3 stages	1	154	CURRENT	XEM_B18-1164_46 [1]	Compound	1	0050		160612	0000	0050		50	1.193248	0.0340251	0000.0050	Top	0	0	1	1	kg	EU	manual	0.0340251
XEM_B18-1164_46	1	154	CURRENT	XEM_B18-1164_46 [1]	1	1	B168 w/TSR20 - lab ref -3 stages	1	1	23-11-2023 15:58:16	29-11-2023 12:18:41	160774	4	ENS	30	CTP [ N - ( Cyclohexyl Thio ) Phthalimide ]	CURRENT	CURRENT	Enschede Plant	RUB CHEM	13-11-2018 13:36:00		29-11-2023 12:18:41	Global	Spec. Function	0.15	0.0009114	1.3	1.3	0.000701076923076923076923076923076923076923	0.000701076923076923076923076923076923076923	0.000701076923076923076923076923076923076923	1	0.0009114	.0009114	kg	1.3	1	1.3	0	0.15								0	0	0	0			XEM_B18-1164_46	B168 w/TSR20 - lab ref -3 stages	1	154	CURRENT	XEM_B18-1164_46 [1]	Compound	1	0030		160774	0000	0030		30	1.193248	0.0009114	0000.0030	Top	0	0	1	1	kg	EU	manual	0.0009114
XEM_B18-1164_46	1	154	CURRENT	XEM_B18-1164_46 [1]	1	1	B168 w/TSR20 - lab ref -3 stages	1	1	23-11-2023 15:58:16	29-11-2023 12:18:41	165421	4	ENS	20	Homogeneous mixture of 72 Parts HMMM and 28 parts Silica	CURRENT	CURRENT	Enschede Plant	VAR RM	02-07-2018 13:55:51		29-11-2023 12:18:41	Global	Spec. Function	3.28	0.019929	1.4	1.4	0.014235	0.014235	0.014235	1	0.019929	.019929	kg	1.4	1	1.4	0	3.28								0	0	0	0			XEM_B18-1164_46	B168 w/TSR20 - lab ref -3 stages	1	154	CURRENT	XEM_B18-1164_46 [1]	Compound	1	0020		165421	0000	0020		20	1.193248	0.019929	0000.0020	Top	0	0	1	1	kg	EU	manual	0.019929
XEM_B18-1164_46	1	154	CURRENT	XEM_B18-1164_46 [1]	1	1	B168 w/TSR20 - lab ref -3 stages	1	1	23-11-2023 15:58:16	29-11-2023 12:18:41	XEM_B18-1164XN5_46		ENS	10	B1008 with TSR20			Enschede Plant				29-11-2023 12:18:41	Compound	Function	186.26	1.131699	1.18136417	1.18136417	0.9579594749348120148251999212063457113313	0.9579594749348120148251999212063457113313	0.9579594749348120148251999212063457113313	1	1.131699	1.131699	kg	1.18136417			53.68839257	186.26								0	0	0	0			XEM_B18-1164_46	B168 w/TSR20 - lab ref -3 stages	1	154	CURRENT	XEM_B18-1164_46 [1]	Compound	1	0010		XEM_B18-1164XN5_46	0000	0010		10	1.193248	1.131699	0000.0010	Top	0	1	0		kg	EU	manual	
*/




/* ONDERZOEK IMPORT-ID

User group	:	Physical lab / (none)		PDF	
View schedule
Due in	:	≥ 0 < 1 weeks	


User profile	:	Physical lab / (none)		PDF		Excel	
Request code	:	EGT2347104M	
Status	:			AV	
Due in	:			weeks


Part-no	:	XEM_B23-1747_01	;	Rev	:	1	
Description	:	lab B1008 PF CMOD CTP,w.o Co	
Alternative	:	1		Preferred	:	1	
Production date	:	2024/02/02 00:00:00	
Import ID	:	24051304

EGT2347104M03	3	XEM_B23-1747_01	lab B1008 PF CMOD CTP,w.o Co

select * from utscmeimportid where sc = 'EGT2347104M03' 

24030727	EGT2347104M03	Development Testing	3000000	ST-test 20m,160C,S57	6000000	TP102A	3000000
23501101	EGT2347104M03	Development Testing	3000000	ST-test 60m,175C,S57	7000000	TP102A	3000000
24051304	EGT2347104M03	Development Testing	3000000	ST-test corr 7d 2S	8000000	TP102A	4000000
24050715	EGT2347104M03	Development Testing	3000000	ST-test hot air 2S	9000000	TP102A	4000000
24051307	EGT2347104M03	Development Testing	3000000	ST-test humidity 2S	10000000	TP102A	4000000
23491566	EGT2347104M03	Development Testing	3000000	TP002AND	4000000	TP002A	4000000
23481095	EGT2347104M03	Development Testing	3000000	TP046GA	1000000	TP046G	2000000
23480884	EGT2347104M03	FEASimResearchTestin	4000000	TP013H	1000000	TP013H	1000000
23480913	EGT2347104M03	Standard Testing	2000000	Dispersion FM (dk)	4000000	TP005A	1000000
23481096	EGT2347104M03	Standard Testing	2000000	TP002AN	2000000	TP002A	3000000
23481097	EGT2347104M03	Standard Testing	2000000	TP004AB	3000000	TP004A	3000000
23480885	EGT2347104M03	Standard Testing	2000000	TP012B	5000000	TP012B	1000000
23480886	EGT2347104M03	Standard Testing	2000000	TP013P	6000000	TP013P	1000000

select * from utscmegkimportid where importid = '24051304';
24051304	EGT2347104M03	Development Testing	3000000	ST-test corr 7d 2S	8000000	TP102A	4000000


select * from utscme where sc = 'EGT2347104M03' 
EGT2347104M03	Standard Testing	2000000	Hardness (median)	1000000	PP004D	1000000	0005.00	Vulc. hardness cilinder 9' at 170°C		Completed		29-11-2023 01.55.18.000000000 PM	29-11-2023 01.55.17.000000000 PM	EFL	PV RnD			Preparation lab	Lab vulc press	0	0	0	23-11-2023 03.58.49.000000000 PM	EGT	0	0	DD	C	1	0.1	0.2	0	1	1	0	Comment	2201172100063014#BLB				465	270	0			1	1	1	1	M1	0	CM	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	29-11-2023 01.55.17.957000000 PM CET	29-11-2023 01.55.17.000000000 PM CET	23-11-2023 03.58.49.000000000 PM CET
EGT2347104M03	Standard Testing	2000000	Hardness (median)	1000000	CP001E	2000000	0003.00	Cond. SLA 16h		Completed			30-11-2023 05.55.38.000000000 AM		PV RnD			Physical lab	Miscellaneous	0	0	0	23-11-2023 03.58.49.000000000 PM	EGT	0	0	DD	C	1	0	16	0	0	1	0		2006262200201257#BLB				510	269	0			1	1	1	1	M1	0	CM	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N			23-11-2023 03.58.49.000000000 PM CET
EGT2347104M03	Standard Testing	2000000	Hardness (median)	1000000	TP001A	3000000	0005.00	Hardness Shore A	83.3	83,3	°Sh A	30-11-2023 07.35.17.000000000 AM	30-11-2023 07.35.16.000000000 AM	JTH	PV RnD	-		Physical lab	Hardness		0	0	23-11-2023 03.58.49.000000000 PM	EGT	0	0	DD	R.1	1	0.2	0.1	0	0	1	0	Comment	2301102100143917#BLB				475	201	0			1	1	1	1	M1	0	CM	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	30-11-2023 07.35.17.000000000 AM CET	30-11-2023 07.35.16.000000000 AM CET	23-11-2023 03.58.49.000000000 PM CET
EGT2347104M03	Standard Testing	2000000	TP002AN	2000000	PP001E	1000000	0004.00	Vulc. tensile sheet 20' at 160°C 		Completed		29-11-2023 01.55.17.000000000 PM	29-11-2023 01.55.17.000000000 PM	EFL	PV RnD			Preparation lab	Lab vulc press	0	0	0	23-11-2023 03.58.49.000000000 PM	EGT	0	0	DD	C	1	0.2	0.6	0	1	1	0	Comment	2201172100065254#BLB				510	226	0			1	1	1	1	M1	0	CM	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	29-11-2023 01.55.17.175000000 PM CET	29-11-2023 01.55.17.000000000 PM CET	23-11-2023 03.58.49.000000000 PM CET
EGT2347104M03	Standard Testing	2000000	TP002AN	2000000	CP001E	2000000	0003.00	Cond. SLA 16h		Completed			30-11-2023 05.55.37.000000000 AM		PV RnD			Physical lab	Miscellaneous	0	0	0	23-11-2023 03.58.49.000000000 PM	EGT	0	0	DD	C	1	0	16	0	0	1	0		2006262200201257#BLB				510	269	0			1	1	1	1	M1	0	CM	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N			23-11-2023 03.58.49.000000000 PM CET
EGT2347104M03	Standard Testing	2000000	TP002AN	2000000	TP002A	3000000	0005.00	Tensile test rubber compound		Completed		01-12-2023 03.02.51.000000000 PM	01-12-2023 03.02.51.000000000 PM	UNILAB	PV RnD			Physical lab	Tensile tester		0	0	23-11-2023 03.58.49.000000000 PM	EGT	0	0	DD	C	1	0.3	0.2	0	1	1	0	Comment	2208172200102508#BLB				510	602	0			1	1	1	1	M1	0	CM	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	01-12-2023 03.02.51.000000000 PM CET	01-12-2023 03.02.51.000000000 PM CET	23-11-2023 03.58.49.000000000 PM CET
EGT2347104M03	Standard Testing	2000000	TP004AB	3000000	PP001E	1000000	0004.00	Vulc. tensile sheet 20' at 160°C 		Completed		29-11-2023 01.55.17.000000000 PM	29-11-2023 01.55.17.000000000 PM	EFL	PV RnD			Preparation lab	Lab vulc press	0	0	0	23-11-2023 03.58.49.000000000 PM	EGT	0	0	DD	C	1	0.2	0.6	0	1	1	0	Comment	2201172100065254#BLB				510	226	0			1	1	1	1	M1	0	CM	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	29-11-2023 01.55.17.081000000 PM CET	29-11-2023 01.55.17.000000000 PM CET	23-11-2023 03.58.49.000000000 PM CET
EGT2347104M03	Standard Testing	2000000	TP004AB	3000000	CP001E	2000000	0003.00	Cond. SLA 16h		Completed			30-11-2023 05.55.37.000000000 AM		PV RnD			Physical lab	Miscellaneous	0	0	0	23-11-2023 03.58.49.000000000 PM	EGT	0	0	DD	C	1	0	16	0	0	1	0		2006262200201257#BLB				510	269	0			1	1	1	1	M1	0	CM	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N			23-11-2023 03.58.49.000000000 PM CET
EGT2347104M03	Standard Testing	2000000	TP004AB	3000000	TP004A	3000000	0004.00	Tear strength (delft)		Completed		01-12-2023 03.02.42.000000000 PM	01-12-2023 03.02.42.000000000 PM	UNILAB	PV RnD			Physical lab	Tensile tester		0	0	23-11-2023 03.58.49.000000000 PM	EGT	0	0	DD	C	1	0.2	0.1	0	1	1	0	rsd_w_break	2109092200055678#BLB				465	224	0			1	1	1	1	M1	0	CM	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	01-12-2023 03.02.42.000000000 PM CET	01-12-2023 03.02.42.000000000 PM CET	23-11-2023 03.58.49.000000000 PM CET
EGT2347104M03	Standard Testing	2000000	Dispersion FM (dk)	4000000	TP005A	1000000	0005.00	Filler dispersion		92,6382226357523	%	30-11-2023 11.44.07.000000000 AM	30-11-2023 11.44.06.000000000 AM	UNILAB	PV RnD			Physical lab	RnD microscope	0	0	0	23-11-2023 03.58.49.000000000 PM	EGT	0	0	DD	R.1	1	0.3	0.3	0	1	1	0	dispersion_table	2301102100133649#BLB		25	100	510	1411	0			1	1	1	1	M1	0	CM	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	30-11-2023 11.44.07.000000000 AM CET	30-11-2023 11.44.06.000000000 AM CET	23-11-2023 03.58.49.000000000 PM CET
EGT2347104M03	Standard Testing	2000000	TP012B	5000000	TP012B	1000000	0003.00	ML Scorch at 135°C		Completed	M.U.	04-12-2023 11.58.09.000000000 AM	04-12-2023 11.58.08.000000000 AM	UNILAB	PV RnD			Physical lab	Mooney testers		0	0	23-11-2023 03.58.49.000000000 PM	EGT	0	0	DD	R.1	1	0.1	0.1	0	1	1	0	TestType	2203082100060888#BLB				510	269	0			1	1	1	1	M1	0	CM	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	04-12-2023 11.58.09.000000000 AM CET	04-12-2023 11.58.08.000000000 AM CET	23-11-2023 03.58.49.000000000 PM CET
EGT2347104M03	Standard Testing	2000000	TP013P	6000000	TP013P	1000000	0003.00	Vulc. properties 160°C + tanD 60°C		Completed		04-12-2023 07.33.27.000000000 AM	04-12-2023 07.33.27.000000000 AM	UNILAB	PV RnD	LAB_RPA2		Physical lab	RPA	0	0	0	23-11-2023 03.58.49.000000000 PM	EGT	0	0	DD	C	1	0.1	0.3	0	1	1	0	Reversion	2103182100068245#BLB				510	844	0			1	1	1	1	M1	0	CM	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	04-12-2023 07.33.27.000000000 AM CET	04-12-2023 07.33.27.000000000 AM CET	23-11-2023 03.58.49.000000000 PM CET
EGT2347104M03	Development Testing	3000000	TP046GA	1000000	CP001E	1000000	0003.00	Cond. SLA 16h		Completed			30-11-2023 05.55.37.000000000 AM		PV RnD			Physical lab	Miscellaneous	0	0	0	23-11-2023 03.58.49.000000000 PM	EGT	0	0	DD	C	1	0	16	0	0	1	0		2006262200201257#BLB				510	269	0			1	1	1	1	M1	0	CM	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N			23-11-2023 03.58.49.000000000 PM CET
EGT2347104M03	Development Testing	3000000	TP046GA	1000000	TP046G	2000000	0002.00	DMA tensile -10°C to 80°C at 3.0%		Completed		12-12-2023 10.16.21.000000000 AM	12-12-2023 10.16.21.000000000 AM	UNILAB	PV RnD			Physical lab	RnD DMAGabo	0	0	0	23-11-2023 03.58.49.000000000 PM	EGT	0	0	DD	C	1	0.1	1.9	0	1	1	0	Comment	2308212200077737#BLB				528	1094	0			1	1	1	1	M1	0	CM	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	12-12-2023 10.16.21.000000000 AM CET	12-12-2023 10.16.21.000000000 AM CET	23-11-2023 03.58.49.000000000 PM CET
EGT2347104M03	Development Testing	3000000	Rebound (70C)	2000000	PP005B	1000000	0006.00	Vulc. rebound cilinder 12' at 170°C		Completed		29-11-2023 01.55.19.000000000 PM	29-11-2023 01.55.18.000000000 PM	EFL	PV RnD			Preparation lab	Lab vulc press	0	0	0	23-11-2023 03.58.49.000000000 PM	EGT	0	0	DD	C	1	0.1	0.2	0	1	1	0	Comment	2201172100058897#BLB				465	270	0			1	1	1	1	M1	0	CM	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	29-11-2023 01.55.18.941000000 PM CET	29-11-2023 01.55.18.000000000 PM CET	23-11-2023 03.58.49.000000000 PM CET
EGT2347104M03	Development Testing	3000000	Rebound (70C)	2000000	CP001E	2000000	0003.00	Cond. SLA 16h		Completed			30-11-2023 05.55.37.000000000 AM		PV RnD			Physical lab	Miscellaneous	0	0	0	23-11-2023 03.58.49.000000000 PM	EGT	0	0	DD	C	1	0	16	0	0	1	0		2006262200201257#BLB				510	269	0			1	1	1	1	M1	0	CM	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N			23-11-2023 03.58.49.000000000 PM CET
EGT2347104M03	Development Testing	3000000	Rebound (70C)	2000000	TP019A	3000000	0005.00	Rebound at 70°C	51.3	51,3	%	30-11-2023 08.15.00.000000000 AM	30-11-2023 08.14.59.000000000 AM	JTH	PV RnD	-		Physical lab	Rebound tester		0	0	23-11-2023 03.58.49.000000000 PM	EGT	0	0	DD	R.1	1	0.1	0.1	0	1	1	1	Comment	2211152100116554#BLB		0	120	465	132	0			1	1	1	1	M1	0	CM	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	30-11-2023 08.15.00.000000000 AM CET	30-11-2023 08.14.59.000000000 AM CET	23-11-2023 03.58.49.000000000 PM CET
EGT2347104M03	Development Testing	3000000	TP001AAD	3000000	PP004D	1000000	0005.00	Vulc. hardness cilinder 9' at 170°C		Completed		29-11-2023 01.55.18.000000000 PM	29-11-2023 01.55.18.000000000 PM	EFL	PV RnD			Preparation lab	Lab vulc press	0	0	0	23-11-2023 03.58.49.000000000 PM	EGT	0	0	DD	C	1	0.1	0.2	0	1	1	0	Comment	2201172100063014#BLB				465	270	0			1	1	1	1	M1	0	CM	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	29-11-2023 01.55.18.253000000 PM CET	29-11-2023 01.55.18.000000000 PM CET	23-11-2023 03.58.49.000000000 PM CET
EGT2347104M03	Development Testing	3000000	TP001AAD	3000000	AP013B	2000000	0003.00	Age Hot Air, 100°C 2d		Completed		06-12-2023 12.37.36.000000000 PM	06-12-2023 12.37.36.000000000 PM	ROR	PV RnD			Physical lab	Stove		0	0	23-11-2023 03.58.49.000000000 PM	EGT	0	0	DD	C	1	1	168	0	1	1	0	Comment	2012182100030844#BLB				630	203	0			1	1	1	1	M1	0	CM	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	06-12-2023 12.37.36.482000000 PM CET	06-12-2023 12.37.36.000000000 PM CET	23-11-2023 03.58.49.000000000 PM CET
EGT2347104M03	Development Testing	3000000	TP001AAD	3000000	CP001E	3000000	0003.00	Cond. SLA 16h		Completed			07-12-2023 04.42.10.000000000 AM		PV RnD			Physical lab	Miscellaneous	0	0	0	23-11-2023 03.58.49.000000000 PM	EGT	0	0	DD	C	1	0	16.08333333333333333333	0	0	1	0		2006262200201257#BLB				510	269	0			1	1	1	1	M1	0	CM	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N			23-11-2023 03.58.49.000000000 PM CET
EGT2347104M03	Development Testing	3000000	TP001AAD	3000000	TP001A	4000000	0005.00	Hardness Shore A	87.9	87,9	°Sh A	07-12-2023 07.52.02.000000000 AM	07-12-2023 07.52.02.000000000 AM	JTH	PV RnD	-		Physical lab	Hardness		0	0	23-11-2023 03.58.49.000000000 PM	EGT	0	0	DD	R.1	1	0.2	0.1	0	0	1	0	Comment	2301102100143917#BLB				475	201	0			1	1	1	1	M1	0	CM	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	07-12-2023 07.52.02.000000000 AM CET	07-12-2023 07.52.02.000000000 AM CET	23-11-2023 03.58.49.000000000 PM CET
EGT2347104M03	Development Testing	3000000	TP002AND	4000000	PP001E	1000000	0004.00	Vulc. tensile sheet 20' at 160°C 		Completed		29-11-2023 01.55.17.000000000 PM	29-11-2023 01.55.16.000000000 PM	EFL	PV RnD			Preparation lab	Lab vulc press	0	0	0	23-11-2023 03.58.49.000000000 PM	EGT	0	0	DD	C	1	0.2	0.6	0	1	1	0	Comment	2201172100065254#BLB				510	226	0			1	1	1	1	M1	0	CM	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	29-11-2023 01.55.16.956000000 PM CET	29-11-2023 01.55.16.000000000 PM CET	23-11-2023 03.58.49.000000000 PM CET
EGT2347104M03	Development Testing	3000000	TP002AND	4000000	AP013B	2000000	0003.00	Age Hot Air, 100°C 2d		Completed		06-12-2023 12.37.37.000000000 PM	06-12-2023 12.37.37.000000000 PM	ROR	PV RnD			Physical lab	Stove		0	0	23-11-2023 03.58.49.000000000 PM	EGT	0	0	DD	C	1	1	168	0	1	1	0	Comment	2012182100030844#BLB				630	203	0			1	1	1	1	M1	0	CM	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	06-12-2023 12.37.37.451000000 PM CET	06-12-2023 12.37.37.000000000 PM CET	23-11-2023 03.58.49.000000000 PM CET
EGT2347104M03	Development Testing	3000000	TP002AND	4000000	CP001E	3000000	0003.00	Cond. SLA 16h		Completed			07-12-2023 04.42.10.000000000 AM		PV RnD			Physical lab	Miscellaneous	0	0	0	23-11-2023 03.58.49.000000000 PM	EGT	0	0	DD	C	1	0	16.08333333333333333333	0	0	1	0		2006262200201257#BLB				510	269	0			1	1	1	1	M1	0	CM	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N			23-11-2023 03.58.49.000000000 PM CET
EGT2347104M03	Development Testing	3000000	TP002AND	4000000	TP002A	4000000	0005.00	Tensile test rubber compound		Completed		07-12-2023 01.16.22.000000000 PM	07-12-2023 01.16.22.000000000 PM	UNILAB	PV RnD			Physical lab	Tensile tester		0	0	23-11-2023 03.58.49.000000000 PM	EGT	0	0	DD	C	1	0.3	0.2	0	1	1	0	M200_median	2208172200102508#BLB				510	602	0			1	1	1	1	M1	0	CM	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	07-12-2023 01.16.22.000000000 PM CET	07-12-2023 01.16.22.000000000 PM CET	23-11-2023 03.58.49.000000000 PM CET
EGT2347104M03	Development Testing	3000000	TP019AAD	5000000	PP005B	1000000	0006.00	Vulc. rebound cilinder 12' at 170°C		Completed		29-11-2023 01.55.19.000000000 PM	29-11-2023 01.55.19.000000000 PM	EFL	PV RnD			Preparation lab	Lab vulc press	0	0	0	23-11-2023 03.58.49.000000000 PM	EGT	0	0	DD	C	1	0.1	0.2	0	1	1	0	Comment	2201172100058897#BLB				465	270	0			1	1	1	1	M1	0	CM	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	29-11-2023 01.55.19.004000000 PM CET	29-11-2023 01.55.19.000000000 PM CET	23-11-2023 03.58.49.000000000 PM CET
EGT2347104M03	Development Testing	3000000	TP019AAD	5000000	AP013B	2000000	0003.00	Age Hot Air, 100°C 2d		Completed		06-12-2023 12.37.37.000000000 PM	06-12-2023 12.37.36.000000000 PM	ROR	PV RnD			Physical lab	Stove		0	0	23-11-2023 03.58.49.000000000 PM	EGT	0	0	DD	C	1	1	168	0	1	1	0	Comment	2012182100030844#BLB				630	203	0			1	1	1	1	M1	0	CM	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	06-12-2023 12.37.36.967000000 PM CET	06-12-2023 12.37.36.000000000 PM CET	23-11-2023 03.58.49.000000000 PM CET
EGT2347104M03	Development Testing	3000000	TP019AAD	5000000	CP001E	3000000	0003.00	Cond. SLA 16h		Completed			07-12-2023 04.42.10.000000000 AM		PV RnD			Physical lab	Miscellaneous	0	0	0	23-11-2023 03.58.49.000000000 PM	EGT	0	0	DD	C	1	0	16.08333333333333333333	0	0	1	0		2006262200201257#BLB				510	269	0			1	1	1	1	M1	0	CM	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N			23-11-2023 03.58.49.000000000 PM CET
EGT2347104M03	Development Testing	3000000	TP019AAD	5000000	TP019A	4000000	0005.00	Rebound at 70°C	54.6	54,6	%	07-12-2023 09.23.52.000000000 AM	07-12-2023 09.23.51.000000000 AM	JTH	PV RnD	-		Physical lab	Rebound tester		0	0	23-11-2023 03.58.49.000000000 PM	EGT	0	0	DD	R.1	1	0.1	0.1	0	1	1	1	Comment	2211152100116554#BLB		0	120	465	132	0			1	1	1	1	M1	0	CM	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	07-12-2023 09.23.52.000000000 AM CET	07-12-2023 09.23.51.000000000 AM CET	23-11-2023 03.58.49.000000000 PM CET
EGT2347104M03	Development Testing	3000000	ST-test 20m,160C,S57	6000000	PP009EB	1000000	0007.00	Vulc. T-test SC 20' at 160°C, 2/3*0.30		Completed		16-01-2024 02.51.06.000000000 PM	16-01-2024 02.51.05.000000000 PM	TDV	PV RnD			Physical lab	Lab vulc press	0	0	0	23-11-2023 03.58.49.000000000 PM	EGT	0	0	DD	C	1	0.2	0.5	0	1	1	0	partno_opposite	2308302200099315#BLB				465	293	0			1	1	1	1	M1	0	CM	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	16-01-2024 02.51.05.822000000 PM CET	16-01-2024 02.51.05.000000000 PM CET	23-11-2023 03.58.49.000000000 PM CET
EGT2347104M03	Development Testing	3000000	ST-test 20m,160C,S57	6000000	CP001E	2000000	0003.00	Cond. SLA 16h		Completed			17-01-2024 06.52.27.000000000 AM		PV RnD			Physical lab	Miscellaneous	0	0	0	23-11-2023 03.58.49.000000000 PM	EGT	0	0	DD	C	1	0	16.01666666666666666667	0	0	1	0		2006262200201257#BLB				510	269	0			1	1	1	1	M1	0	CM	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N			23-11-2023 03.58.49.000000000 PM CET
EGT2347104M03	Development Testing	3000000	ST-test 20m,160C,S57	6000000	TP102A	3000000	0007.00	Adh. T-test of steel cord	372.198	372	N	24-01-2024 01.15.03.000000000 PM	24-01-2024 01.15.02.000000000 PM	UNILAB	PV RnD			Physical lab	Tensile tester		0	0	23-11-2023 03.58.49.000000000 PM	EGT	0	0	DD	R1	1	0.2	0.2	0	0	1	0	F_max	2308312201411172#BLB		10	1000	510	517	0			1	1	1	1	M1	0	CM	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	24-01-2024 01.15.03.000000000 PM CET	24-01-2024 01.15.02.000000000 PM CET	23-11-2023 03.58.49.000000000 PM CET
EGT2347104M03	Development Testing	3000000	ST-test 60m,175C,S57	7000000	PP009HB	1000000	0007.00	Vulc. T-test SC 60' at 175°C, 2*0.30		Completed		12-12-2023 03.37.25.000000000 PM	12-12-2023 03.37.25.000000000 PM	TDV	PV RnD			Physical lab	Lab vulc press	0	0	0	23-11-2023 03.58.49.000000000 PM	EGT	0	0	DD	C	1	0.2	1.2	0	1	1	0	partno_reinf	2308302200099315#BLB				465	293	0			1	1	1	1	M1	0	CM	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	12-12-2023 03.37.25.362000000 PM CET	12-12-2023 03.37.25.000000000 PM CET	23-11-2023 03.58.49.000000000 PM CET
EGT2347104M03	Development Testing	3000000	ST-test 60m,175C,S57	7000000	CP001E	2000000	0003.00	Cond. SLA 16h		Completed			13-12-2023 07.42.08.000000000 AM		PV RnD			Physical lab	Miscellaneous	0	0	0	23-11-2023 03.58.49.000000000 PM	EGT	0	0	DD	C	1	0	16.08333333333333333333	0	0	1	0		2006262200201257#BLB				510	269	0			1	1	1	1	M1	0	CM	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N			23-11-2023 03.58.49.000000000 PM CET
EGT2347104M03	Development Testing	3000000	ST-test 60m,175C,S57	7000000	TP102A	3000000	0007.00	Adh. T-test of steel cord	346.374	346	N	22-12-2023 10.59.39.000000000 AM	22-12-2023 10.59.39.000000000 AM	UNILAB	PV RnD			Physical lab	Tensile tester		0	0	23-11-2023 03.58.49.000000000 PM	EGT	0	0	DD	R1	1	0.2	0.2	0	0	1	0	F_max	2308312201411172#BLB		10	1000	510	517	0			1	1	1	1	M1	0	CM	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	22-12-2023 10.59.39.000000000 AM CET	22-12-2023 10.59.39.000000000 AM CET	23-11-2023 03.58.49.000000000 PM CET
EGT2347104M03	Development Testing	3000000	ST-test corr 7d 2S	8000000	PP009ZZ	1000000	0007.00	Vulc. T-test SC var. vulc. to steel		Completed		16-01-2024 02.54.03.000000000 PM	16-01-2024 02.54.03.000000000 PM	TDV	PV RnD	-		Physical lab	Lab vulc press	0	0	0	23-11-2023 03.58.49.000000000 PM	EGT	0	0	DD	C	1	0.2	1.2	0	1	1	0	Comment	2308302200099315#BLB				465	270	0			1	1	1	1	M1	0	CM	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	16-01-2024 02.54.03.000000000 PM CET	16-01-2024 02.54.03.000000000 PM CET	23-11-2023 03.58.49.000000000 PM CET
EGT2347104M03	Development Testing	3000000	ST-test corr 7d 2S	8000000	AP005G	2000000	0005.00	Corrosion (2% NaCl) 7d, 80°C		Completed		01-02-2024 01.10.43.000000000 PM	01-02-2024 01.10.42.000000000 PM	ROR	PV RnD			Physical lab	Stove		0	0	23-11-2023 03.58.49.000000000 PM	EGT	0	0	DD	C	1	1	168	0	1	1	0	Comment	2012212100025529#BLB				550	201	0			1	1	1	1	M1	0	CM	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	01-02-2024 01.10.42.926000000 PM CET	01-02-2024 01.10.42.000000000 PM CET	23-11-2023 03.58.49.000000000 PM CET
EGT2347104M03	Development Testing	3000000	ST-test corr 7d 2S	8000000	CP001E	3000000	0003.00	Cond. SLA 16h		Completed			02-02-2024 05.11.36.000000000 AM		PV RnD			Physical lab	Miscellaneous	0	0	0	23-11-2023 03.58.49.000000000 PM	EGT	0	0	DD	C	1	0	16.01666666666666666667	0	0	1	0	timerCompleted	2006262200201257#BLB				510	269	0			1	1	1	1	M1	0	CM	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N			23-11-2023 03.58.49.000000000 PM CET
EGT2347104M03	Development Testing	3000000	ST-test corr 7d 2S	8000000	TP102A	4000000	0007.00	Adh. T-test of steel cord			N				PV RnD			Physical lab	Tensile tester		0	0	23-11-2023 03.58.49.000000000 PM	EGT	0	0	DD	R1	1	0.2	0.2	0	0	1	0	F_max_mean	2308312201411172#BLB		10	1000	510	517	0			1	1	1	1	M1	0	AV	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N			23-11-2023 03.58.49.000000000 PM CET
EGT2347104M03	Development Testing	3000000	ST-test hot air 2S	9000000	PP009ZZ	1000000	0007.00	Vulc. T-test SC var. vulc. to steel		Completed		16-01-2024 02.54.13.000000000 PM	16-01-2024 02.54.13.000000000 PM	TDV	PV RnD	-		Physical lab	Lab vulc press	0	0	0	23-11-2023 03.58.49.000000000 PM	EGT	0	0	DD	C	1	0.2	1.2	0	1	1	0	Comment	2308302200099315#BLB				465	270	0			1	1	1	1	M1	0	CM	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	16-01-2024 02.54.13.000000000 PM CET	16-01-2024 02.54.13.000000000 PM CET	23-11-2023 03.58.49.000000000 PM CET
EGT2347104M03	Development Testing	3000000	ST-test hot air 2S	9000000	AP002G	2000000	0005.00	Age Hot Air, 70°C 7d		Completed		30-01-2024 11.12.46.000000000 AM	30-01-2024 11.12.45.000000000 AM	ROR	PV RnD			Physical lab	Stove		0	0	23-11-2023 03.58.49.000000000 PM	EGT	0	0	DD	C	1	1	168	0	1	1	0	Comment	2012182100030844#BLB				550	201	0			1	1	1	1	M1	0	CM	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	30-01-2024 11.12.45.965000000 AM CET	30-01-2024 11.12.45.000000000 AM CET	23-11-2023 03.58.49.000000000 PM CET
EGT2347104M03	Development Testing	3000000	ST-test hot air 2S	9000000	CP001E	3000000	0003.00	Cond. SLA 16h		Completed			31-01-2024 03.16.36.000000000 AM		PV RnD			Physical lab	Miscellaneous	0	0	0	23-11-2023 03.58.49.000000000 PM	EGT	0	0	DD	C	1	0	16.06666666666666666667	0	0	1	0		2006262200201257#BLB				510	269	0			1	1	1	1	M1	0	CM	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N			23-11-2023 03.58.49.000000000 PM CET
EGT2347104M03	Development Testing	3000000	ST-test hot air 2S	9000000	TP102A	4000000	0007.00	Adh. T-test of steel cord	388.754	389	N	31-01-2024 10.55.07.000000000 AM	31-01-2024 10.55.06.000000000 AM	UNILAB	PV RnD			Physical lab	Tensile tester		0	0	23-11-2023 03.58.49.000000000 PM	EGT	0	0	DD	R1	1	0.2	0.2	0	0	1	0	F_max	2308312201411172#BLB		10	1000	510	517	0			1	1	1	1	M1	0	CM	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	31-01-2024 10.55.07.000000000 AM CET	31-01-2024 10.55.06.000000000 AM CET	23-11-2023 03.58.49.000000000 PM CET
EGT2347104M03	Development Testing	3000000	ST-test humidity 2S	10000000	PP009ZZ	1000000	0007.00	Vulc. T-test SC var. vulc. to steel		Completed		16-01-2024 02.54.21.000000000 PM	16-01-2024 02.54.20.000000000 PM	TDV	PV RnD	-		Physical lab	Lab vulc press	0	0	0	23-11-2023 03.58.49.000000000 PM	EGT	0	0	DD	C	1	0.2	1.2	0	1	1	0	Comment	2308302200099315#BLB				465	270	0			1	1	1	1	M1	0	CM	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	16-01-2024 02.54.21.000000000 PM CET	16-01-2024 02.54.20.000000000 PM CET	23-11-2023 03.58.49.000000000 PM CET
EGT2347104M03	Development Testing	3000000	ST-test humidity 2S	10000000	AP006G	2000000	0005.00	Age 23°C 85 RH (Ozon Cabinet) 7d		Completed		01-02-2024 01.21.24.000000000 PM	01-02-2024 01.21.24.000000000 PM	ROR	PV RnD			Physical lab	RnD ozone tester	0	0	0	23-11-2023 03.58.49.000000000 PM	EGT	0	0	DD	C	1	1	168	0	1	1	0	Comment	2011132100039138#BLB				630	203	0			1	1	1	1	M1	0	CM	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	01-02-2024 01.21.24.309000000 PM CET	01-02-2024 01.21.24.000000000 PM CET	23-11-2023 03.58.49.000000000 PM CET
EGT2347104M03	Development Testing	3000000	ST-test humidity 2S	10000000	CP001E	3000000	0003.00	Cond. SLA 16h		Completed			02-02-2024 05.21.36.000000000 AM		PV RnD			Physical lab	Miscellaneous	0	0	0	23-11-2023 03.58.49.000000000 PM	EGT	0	0	DD	C	1	0	16	0	0	1	0	timerCompleted	2006262200201257#BLB				510	269	0			1	1	1	1	M1	0	CM	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N			23-11-2023 03.58.49.000000000 PM CET
EGT2347104M03	Development Testing	3000000	ST-test humidity 2S	10000000	TP102A	4000000	0007.00	Adh. T-test of steel cord			N				PV RnD			Physical lab	Tensile tester		0	0	23-11-2023 03.58.49.000000000 PM	EGT	0	0	DD	R1	1	0.2	0.2	0	0	1	0	F_max_mean	2308312201411172#BLB		10	1000	510	517	0			1	1	1	1	M1	0	AV	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N			23-11-2023 03.58.49.000000000 PM CET
EGT2347104M03	FEASimResearchTestin	4000000	TP013H	1000000	TP013H	1000000	0003.00	RPA vulc. properties 10' at 180°C		Completed		04-12-2023 07.33.02.000000000 AM	04-12-2023 07.33.02.000000000 AM	UNILAB	PV RnD	LAB_RPA2		Physical lab	RPA	0	0	0	23-11-2023 03.58.49.000000000 PM	EGT	0	0	DD	C	1	0.1	0.3	0	1	1	0	Reversion	2103182100068245#BLB				465	431	0			1	1	1	1	M1	0	CM	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	04-12-2023 07.33.02.000000000 AM CET	04-12-2023 07.33.02.000000000 AM CET	23-11-2023 03.58.49.000000000 PM CET
EGT2347104M03	MP003	1000000	MP003	1000000	MP003	1000000	0002.00	Mixing compound on lab mixer		5: very good		29-11-2023 12.19.09.000000000 PM	29-11-2023 12.19.09.000000000 PM	DDV	PV RnD	RnD_Lab_Mixer		Preparation lab	RnD lab mixer	0	0	0	23-11-2023 03.58.49.000000000 PM	EGT	0	0	DD	C	1	1	0.2	0	1	1	0	mixing_problems	1803290831372421#BLB				279	111	0			1	1	1	1	M1	0	CM	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	29-11-2023 12.19.09.000000000 PM CET	29-11-2023 12.19.09.000000000 PM CET	23-11-2023 03.58.49.000000000 PM CET


select * from utscme where sc = 'EGT2347104M03' and ss NOT IN ('CM' );
EGT2347104M03	Development Testing	3000000	ST-test corr 7d 2S	8000000	TP102A	4000000	0007.00	Adh. T-test of steel cord			N				PV RnD			Physical lab	Tensile tester		0	0	23-11-2023 03.58.49.000000000 PM	EGT	0	0	DD	R1	1	0.2	0.2	0	0	1	0	F_max_mean	2308312201411172#BLB		10	1000	510	517	0			1	1	1	1	M1	0	AV	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N			23-11-2023 03.58.49.000000000 PM CET
EGT2347104M03	Development Testing	3000000	ST-test humidity 2S	10000000	TP102A	4000000	0007.00	Adh. T-test of steel cord			N				PV RnD			Physical lab	Tensile tester		0	0	23-11-2023 03.58.49.000000000 PM	EGT	0	0	DD	R1	1	0.2	0.2	0	0	1	0	F_max_mean	2308312201411172#BLB		10	1000	510	517	0			1	1	1	1	M1	0	AV	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N			23-11-2023 03.58.49.000000000 PM CET

SELECT * FROM UTSCGKPART_NO WHERE PART_NO = 'XEM_B23-1747_01';
XEM_B23-1747_01	EGT2347104M03


--PART-NO ZONDER IMPORT-ID:  XEM_B23-1253_10
SELECT * FROM UTSCGKPART_NO WHERE PART_NO = 'XEM_B23-1253_10';

SELECT * FROM UTSCGKPART_NO WHERE PART_NO = 'XEM_B23-1253_10';
XEM_B23-1253_10	AYB2401015M01
XEM_B23-1253_10	AYB2401029M01

SELECT * FROM UTSCMEGKIMPORTID WHERE SC IN ('AYB2401015M01','AYB2401029M01' ) 
24030478	AYB2401029M01	Development Testing		3000000	TP046GA	1000000	TP046G	2000000
24030233	AYB2401029M01	FEASimResearchTestin	5000000	TP013H	1000000	TP013H	1000000
24030253	AYB2401029M01	Standard Testing		2000000	Dispersion FM (dk)	4000000	TP005A	1000000
24030479	AYB2401029M01	Standard Testing		2000000	TP002AN	2000000	TP002A	3000000
24030480	AYB2401029M01	Standard Testing		2000000	TP004AB	3000000	TP004A	3000000
24030234	AYB2401029M01	Standard Testing		2000000	TP012B	5000000	TP012B	1000000
24030235	AYB2401029M01	Standard Testing		2000000	TP013P	6000000	TP013P	1000000

--conclusie: er zijn meerder IMPORTID's bij SAMPLES...


SELECT * FROM UTSCME WHERE SC IN ('AYB2401015M01','AYB2401029M01' ) AND SS NOT IN ('CM' );
AYB2401015M01	Development Testing	3000000	Rebound (70C)	2000000	CP001E	2000000	0003.00	Cond. SLA 16h		Cancelled		04-01-2024 05.00.15.000000000 PM	04-01-2024 05.00.20.000000000 PM		PV RnD			Physical lab	Miscellaneous	0	0	0	03-01-2024 09.17.56.000000000 AM	AYB	0	0	DD	C	1	0	16	0	0	1	0	timerCompleted	2006262200201257#BLB				510	269	0			1	1	1	1	M1	0	@C	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	04-01-2024 05.00.15.000000000 PM CET	04-01-2024 05.00.15.000000000 PM CET	03-01-2024 09.17.56.000000000 AM CET
AYB2401015M01	Development Testing	3000000	Rebound (70C)	2000000	PP005B	1000000	0006.00	Vulc. rebound cilinder 12' at 170°C		Cancelled		04-01-2024 05.00.15.000000000 PM	04-01-2024 05.00.20.000000000 PM		PV RnD			Preparation lab	Lab vulc press	0	0	0	03-01-2024 09.17.56.000000000 AM	AYB	0	0	DD	C	1	0.1	0.2	0	1	1	0		2201172100058897#BLB				465	270	0			1	1	1	1	M1	0	@C	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	04-01-2024 05.00.15.000000000 PM CET	04-01-2024 05.00.15.000000000 PM CET	03-01-2024 09.17.56.000000000 AM CET
AYB2401015M01	Development Testing	3000000	Rebound (70C)	2000000	TP019A	3000000	0005.00	Rebound at 70°C		Cancelled	%	04-01-2024 05.00.15.000000000 PM	04-01-2024 05.00.20.000000000 PM		PV RnD			Physical lab	Rebound tester		0	0	03-01-2024 09.17.56.000000000 AM	AYB	0	0	DD	R.1	1	0.1	0.1	0	1	1	1		2211152100116554#BLB		0	120	465	132	0			1	1	1	1	M1	0	@C	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	04-01-2024 05.00.15.000000000 PM CET	04-01-2024 05.00.15.000000000 PM CET	03-01-2024 09.17.56.000000000 AM CET
AYB2401015M01	Development Testing	3000000	TP001AAD	3000000	AP013B	2000000	0003.00	Age Hot Air, 100°C 2d		Cancelled		04-01-2024 05.00.15.000000000 PM	04-01-2024 05.00.20.000000000 PM		PV RnD			Physical lab	Stove		0	0	03-01-2024 09.17.56.000000000 AM	AYB	0	0	DD	C	1	1	168	0	1	1	0		2012182100030844#BLB				630	203	0			1	1	1	1	M1	0	@C	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	04-01-2024 05.00.15.000000000 PM CET	04-01-2024 05.00.15.000000000 PM CET	03-01-2024 09.17.56.000000000 AM CET
AYB2401015M01	Development Testing	3000000	TP001AAD	3000000	CP001E	3000000	0003.00	Cond. SLA 16h		Cancelled		04-01-2024 05.00.15.000000000 PM	04-01-2024 05.00.20.000000000 PM		PV RnD			Physical lab	Miscellaneous	0	0	0	03-01-2024 09.17.56.000000000 AM	AYB	0	0	DD	C	1	0	16	0	0	1	0	timerCompleted	2006262200201257#BLB				510	269	0			1	1	1	1	M1	0	@C	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	04-01-2024 05.00.15.000000000 PM CET	04-01-2024 05.00.15.000000000 PM CET	03-01-2024 09.17.56.000000000 AM CET
AYB2401015M01	Development Testing	3000000	TP001AAD	3000000	PP004D	1000000	0005.00	Vulc. hardness cilinder 9' at 170°C		Cancelled		04-01-2024 05.00.15.000000000 PM	04-01-2024 05.00.20.000000000 PM		PV RnD			Preparation lab	Lab vulc press	0	0	0	03-01-2024 09.17.56.000000000 AM	AYB	0	0	DD	C	1	0.1	0.2	0	1	1	0		2201172100063014#BLB				465	270	0			1	1	1	1	M1	0	@C	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	04-01-2024 05.00.15.000000000 PM CET	04-01-2024 05.00.15.000000000 PM CET	03-01-2024 09.17.56.000000000 AM CET
AYB2401015M01	Development Testing	3000000	TP001AAD	3000000	TP001A	4000000	0005.00	Hardness Shore A		Cancelled	°Sh A	04-01-2024 05.00.15.000000000 PM	04-01-2024 05.00.20.000000000 PM		PV RnD			Physical lab	Hardness		0	0	03-01-2024 09.17.56.000000000 AM	AYB	0	0	DD		1	0.2	0.1	0	0	1	0		2301102100143917#BLB				475	201	0			1	1	1	1	M1	0	@C	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	04-01-2024 05.00.15.000000000 PM CET	04-01-2024 05.00.15.000000000 PM CET	03-01-2024 09.17.56.000000000 AM CET
AYB2401015M01	Development Testing	3000000	TP002AND	4000000	AP013B	2000000	0003.00	Age Hot Air, 100°C 2d		Cancelled		04-01-2024 05.00.15.000000000 PM	04-01-2024 05.00.20.000000000 PM		PV RnD			Physical lab	Stove		0	0	03-01-2024 09.17.56.000000000 AM	AYB	0	0	DD	C	1	1	168	0	1	1	0		2012182100030844#BLB				630	203	0			1	1	1	1	M1	0	@C	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	04-01-2024 05.00.15.000000000 PM CET	04-01-2024 05.00.15.000000000 PM CET	03-01-2024 09.17.56.000000000 AM CET
AYB2401015M01	Development Testing	3000000	TP002AND	4000000	CP001E	3000000	0003.00	Cond. SLA 16h		Cancelled		04-01-2024 05.00.15.000000000 PM	04-01-2024 05.00.20.000000000 PM		PV RnD			Physical lab	Miscellaneous	0	0	0	03-01-2024 09.17.56.000000000 AM	AYB	0	0	DD	C	1	0	16	0	0	1	0	timerCompleted	2006262200201257#BLB				510	269	0			1	1	1	1	M1	0	@C	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	04-01-2024 05.00.15.000000000 PM CET	04-01-2024 05.00.15.000000000 PM CET	03-01-2024 09.17.56.000000000 AM CET
AYB2401015M01	Development Testing	3000000	TP002AND	4000000	PP001E	1000000	0004.00	Vulc. tensile sheet 20' at 160°C 		Cancelled		04-01-2024 05.00.15.000000000 PM	04-01-2024 05.00.20.000000000 PM		PV RnD			Preparation lab	Lab vulc press	0	0	0	03-01-2024 09.17.56.000000000 AM	AYB	0	0	DD	C	1	0.2	0.6	0	1	1	0		2201172100065254#BLB				510	226	0			1	1	1	1	M1	0	@C	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	04-01-2024 05.00.15.000000000 PM CET	04-01-2024 05.00.15.000000000 PM CET	03-01-2024 09.17.56.000000000 AM CET
AYB2401015M01	Development Testing	3000000	TP002AND	4000000	TP002A	4000000	0005.00	Tensile test rubber compound		Cancelled		04-01-2024 05.00.15.000000000 PM	04-01-2024 05.00.20.000000000 PM		PV RnD			Physical lab	Tensile tester		0	0	03-01-2024 09.17.56.000000000 AM	AYB	0	0	DD	C	1	0.3	0.2	0	1	1	0		2208172200102508#BLB				510	602	0			1	1	1	1	M1	0	@C	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	04-01-2024 05.00.15.000000000 PM CET	04-01-2024 05.00.15.000000000 PM CET	03-01-2024 09.17.56.000000000 AM CET
AYB2401015M01	Development Testing	3000000	TP019AAD	5000000	AP013B	2000000	0003.00	Age Hot Air, 100°C 2d		Cancelled		04-01-2024 05.00.15.000000000 PM	04-01-2024 05.00.20.000000000 PM		PV RnD			Physical lab	Stove		0	0	03-01-2024 09.17.56.000000000 AM	AYB	0	0	DD	C	1	1	168	0	1	1	0		2012182100030844#BLB				630	203	0			1	1	1	1	M1	0	@C	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	04-01-2024 05.00.15.000000000 PM CET	04-01-2024 05.00.15.000000000 PM CET	03-01-2024 09.17.56.000000000 AM CET
AYB2401015M01	Development Testing	3000000	TP019AAD	5000000	CP001E	3000000	0003.00	Cond. SLA 16h		Cancelled		04-01-2024 05.00.15.000000000 PM	04-01-2024 05.00.20.000000000 PM		PV RnD			Physical lab	Miscellaneous	0	0	0	03-01-2024 09.17.56.000000000 AM	AYB	0	0	DD	C	1	0	16	0	0	1	0	timerCompleted	2006262200201257#BLB				510	269	0			1	1	1	1	M1	0	@C	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	04-01-2024 05.00.15.000000000 PM CET	04-01-2024 05.00.15.000000000 PM CET	03-01-2024 09.17.56.000000000 AM CET
AYB2401015M01	Development Testing	3000000	TP019AAD	5000000	PP005B	1000000	0006.00	Vulc. rebound cilinder 12' at 170°C		Cancelled		04-01-2024 05.00.15.000000000 PM	04-01-2024 05.00.20.000000000 PM		PV RnD			Preparation lab	Lab vulc press	0	0	0	03-01-2024 09.17.56.000000000 AM	AYB	0	0	DD	C	1	0.1	0.2	0	1	1	0		2201172100058897#BLB				465	270	0			1	1	1	1	M1	0	@C	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	04-01-2024 05.00.15.000000000 PM CET	04-01-2024 05.00.15.000000000 PM CET	03-01-2024 09.17.56.000000000 AM CET
AYB2401015M01	Development Testing	3000000	TP019AAD	5000000	TP019A	4000000	0005.00	Rebound at 70°C		Cancelled	%	04-01-2024 05.00.15.000000000 PM	04-01-2024 05.00.20.000000000 PM		PV RnD			Physical lab	Rebound tester		0	0	03-01-2024 09.17.56.000000000 AM	AYB	0	0	DD	R.1	1	0.1	0.1	0	1	1	1		2211152100116554#BLB		0	120	465	132	0			1	1	1	1	M1	0	@C	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	04-01-2024 05.00.15.000000000 PM CET	04-01-2024 05.00.15.000000000 PM CET	03-01-2024 09.17.56.000000000 AM CET
AYB2401015M01	Development Testing	3000000	TP046GA	1000000	CP001E	1000000	0003.00	Cond. SLA 16h		Cancelled		04-01-2024 05.00.15.000000000 PM	04-01-2024 05.00.20.000000000 PM		PV RnD			Physical lab	Miscellaneous	0	0	0	03-01-2024 09.17.56.000000000 AM	AYB	0	0	DD	C	1	0	16	0	0	1	0	timerCompleted	2006262200201257#BLB				510	269	0			1	1	1	1	M1	0	@C	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	04-01-2024 05.00.15.000000000 PM CET	04-01-2024 05.00.15.000000000 PM CET	03-01-2024 09.17.56.000000000 AM CET
AYB2401015M01	Development Testing	3000000	TP046GA	1000000	TP046G	2000000	0002.00	DMA tensile -10°C to 80°C at 3.0%		Cancelled		04-01-2024 05.00.15.000000000 PM	04-01-2024 05.00.20.000000000 PM		PV RnD			Physical lab	RnD DMAGabo	0	0	0	03-01-2024 09.17.56.000000000 AM	AYB	0	0	DD	C	1	0.1	1.9	0	1	1	0		2308212200077737#BLB				528	1094	0			1	1	1	1	M1	0	@C	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	04-01-2024 05.00.15.000000000 PM CET	04-01-2024 05.00.15.000000000 PM CET	03-01-2024 09.17.56.000000000 AM CET
AYB2401015M01	MP003	1000000	MP003	1000000	MP003	1000000	0002.00	Mixing compound on lab mixer		Cancelled		04-01-2024 05.00.15.000000000 PM	04-01-2024 05.00.20.000000000 PM		PV RnD			Preparation lab	RnD lab mixer	0	0	0	03-01-2024 09.17.56.000000000 AM	AYB	0	0	DD	C	1	1	0.2	0	1	1	0	mixing_behaviour	1803290831372421#BLB				279	111	0			1	1	1	1	M1	0	@C	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	04-01-2024 05.00.15.000000000 PM CET	04-01-2024 05.00.15.000000000 PM CET	03-01-2024 09.17.56.000000000 AM CET
AYB2401015M01	Standard Testing	2000000	Dispersion FM (dk)	4000000	TP005A	1000000	0005.00	Filler dispersion		Cancelled	%	04-01-2024 05.00.15.000000000 PM	04-01-2024 05.00.20.000000000 PM		PV RnD			Physical lab	RnD microscope	0	0	0	03-01-2024 09.17.56.000000000 AM	AYB	0	0	DD	R.1	1	0.3	0.3	0	1	1	0		2301102100133649#BLB		25	100	510	1411	0			1	1	1	1	M1	0	@C	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	04-01-2024 05.00.15.000000000 PM CET	04-01-2024 05.00.15.000000000 PM CET	03-01-2024 09.17.56.000000000 AM CET
AYB2401015M01	Standard Testing	2000000	Hardness (median)	1000000	CP001E	2000000	0003.00	Cond. SLA 16h		Cancelled		04-01-2024 05.00.15.000000000 PM	04-01-2024 05.00.20.000000000 PM		PV RnD			Physical lab	Miscellaneous	0	0	0	03-01-2024 09.17.56.000000000 AM	AYB	0	0	DD	C	1	0	16	0	0	1	0	timerCompleted	2006262200201257#BLB				510	269	0			1	1	1	1	M1	0	@C	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	04-01-2024 05.00.15.000000000 PM CET	04-01-2024 05.00.15.000000000 PM CET	03-01-2024 09.17.56.000000000 AM CET
AYB2401015M01	Standard Testing	2000000	Hardness (median)	1000000	PP004D	1000000	0005.00	Vulc. hardness cilinder 9' at 170°C		Cancelled		04-01-2024 05.00.15.000000000 PM	04-01-2024 05.00.20.000000000 PM		PV RnD			Preparation lab	Lab vulc press	0	0	0	03-01-2024 09.17.56.000000000 AM	AYB	0	0	DD	C	1	0.1	0.2	0	1	1	0		2201172100063014#BLB				465	270	0			1	1	1	1	M1	0	@C	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	04-01-2024 05.00.15.000000000 PM CET	04-01-2024 05.00.15.000000000 PM CET	03-01-2024 09.17.56.000000000 AM CET
AYB2401015M01	Standard Testing	2000000	Hardness (median)	1000000	TP001A	3000000	0005.00	Hardness Shore A		Cancelled	°Sh A	04-01-2024 05.00.15.000000000 PM	04-01-2024 05.00.20.000000000 PM		PV RnD			Physical lab	Hardness		0	0	03-01-2024 09.17.56.000000000 AM	AYB	0	0	DD		1	0.2	0.1	0	0	1	0		2301102100143917#BLB				475	201	0			1	1	1	1	M1	0	@C	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	04-01-2024 05.00.15.000000000 PM CET	04-01-2024 05.00.15.000000000 PM CET	03-01-2024 09.17.56.000000000 AM CET
AYB2401015M01	Standard Testing	2000000	TP002AN	2000000	CP001E	2000000	0003.00	Cond. SLA 16h		Cancelled		04-01-2024 05.00.15.000000000 PM	04-01-2024 05.00.20.000000000 PM		PV RnD			Physical lab	Miscellaneous	0	0	0	03-01-2024 09.17.56.000000000 AM	AYB	0	0	DD	C	1	0	16	0	0	1	0	timerCompleted	2006262200201257#BLB				510	269	0			1	1	1	1	M1	0	@C	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	04-01-2024 05.00.15.000000000 PM CET	04-01-2024 05.00.15.000000000 PM CET	03-01-2024 09.17.56.000000000 AM CET
AYB2401015M01	Standard Testing	2000000	TP002AN	2000000	PP001E	1000000	0004.00	Vulc. tensile sheet 20' at 160°C 		Cancelled		04-01-2024 05.00.15.000000000 PM	04-01-2024 05.00.20.000000000 PM		PV RnD			Preparation lab	Lab vulc press	0	0	0	03-01-2024 09.17.56.000000000 AM	AYB	0	0	DD	C	1	0.2	0.6	0	1	1	0		2201172100065254#BLB				510	226	0			1	1	1	1	M1	0	@C	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	04-01-2024 05.00.15.000000000 PM CET	04-01-2024 05.00.15.000000000 PM CET	03-01-2024 09.17.56.000000000 AM CET
AYB2401015M01	Standard Testing	2000000	TP002AN	2000000	TP002A	3000000	0005.00	Tensile test rubber compound		Cancelled		04-01-2024 05.00.15.000000000 PM	04-01-2024 05.00.20.000000000 PM		PV RnD			Physical lab	Tensile tester		0	0	03-01-2024 09.17.56.000000000 AM	AYB	0	0	DD	C	1	0.3	0.2	0	1	1	0		2208172200102508#BLB				510	602	0			1	1	1	1	M1	0	@C	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	04-01-2024 05.00.15.000000000 PM CET	04-01-2024 05.00.15.000000000 PM CET	03-01-2024 09.17.56.000000000 AM CET
AYB2401015M01	Standard Testing	2000000	TP004AB	3000000	CP001E	2000000	0003.00	Cond. SLA 16h		Cancelled		04-01-2024 05.00.15.000000000 PM	04-01-2024 05.00.20.000000000 PM		PV RnD			Physical lab	Miscellaneous	0	0	0	03-01-2024 09.17.56.000000000 AM	AYB	0	0	DD	C	1	0	16	0	0	1	0	timerCompleted	2006262200201257#BLB				510	269	0			1	1	1	1	M1	0	@C	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	04-01-2024 05.00.15.000000000 PM CET	04-01-2024 05.00.15.000000000 PM CET	03-01-2024 09.17.56.000000000 AM CET
AYB2401015M01	Standard Testing	2000000	TP004AB	3000000	PP001E	1000000	0004.00	Vulc. tensile sheet 20' at 160°C 		Cancelled		04-01-2024 05.00.15.000000000 PM	04-01-2024 05.00.20.000000000 PM		PV RnD			Preparation lab	Lab vulc press	0	0	0	03-01-2024 09.17.56.000000000 AM	AYB	0	0	DD	C	1	0.2	0.6	0	1	1	0		2201172100065254#BLB				510	226	0			1	1	1	1	M1	0	@C	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	04-01-2024 05.00.15.000000000 PM CET	04-01-2024 05.00.15.000000000 PM CET	03-01-2024 09.17.56.000000000 AM CET
AYB2401015M01	Standard Testing	2000000	TP004AB	3000000	TP004A	3000000	0004.00	Tear strength (delft)		Cancelled		04-01-2024 05.00.15.000000000 PM	04-01-2024 05.00.20.000000000 PM		PV RnD			Physical lab	Tensile tester		0	0	03-01-2024 09.17.56.000000000 AM	AYB	0	0	DD	C	1	0.2	0.1	0	1	1	0		2109092200055678#BLB				465	224	0			1	1	1	1	M1	0	@C	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	04-01-2024 05.00.15.000000000 PM CET	04-01-2024 05.00.15.000000000 PM CET	03-01-2024 09.17.56.000000000 AM CET
AYB2401015M01	Standard Testing	2000000	TP012B	5000000	TP012B	1000000	0003.00	ML Scorch at 135°C		Cancelled	M.U.	04-01-2024 05.00.15.000000000 PM	04-01-2024 05.00.20.000000000 PM		PV RnD			Physical lab	Mooney testers		0	0	03-01-2024 09.17.56.000000000 AM	AYB	0	0	DD	R.1	1	0.1	0.1	0	1	1	0		2203082100060888#BLB				510	269	0			1	1	1	1	M1	0	@C	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	04-01-2024 05.00.15.000000000 PM CET	04-01-2024 05.00.15.000000000 PM CET	03-01-2024 09.17.56.000000000 AM CET
AYB2401015M01	Standard Testing	2000000	TP013P	6000000	TP013P	1000000	0003.00	Vulc. properties 160°C + tanD 60°C		Cancelled		04-01-2024 05.00.15.000000000 PM	04-01-2024 05.00.20.000000000 PM		PV RnD			Physical lab	RPA	0	0	0	03-01-2024 09.17.56.000000000 AM	AYB	0	0	DD	C	1	0.1	0.3	0	1	1	0		2103182100068245#BLB				510	844	0			1	1	1	1	M1	0	@C	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	04-01-2024 05.00.15.000000000 PM CET	04-01-2024 05.00.15.000000000 PM CET	03-01-2024 09.17.56.000000000 AM CET
AYB2401029M01	Development Testing	3000000	TP001AAD	3000000	CP001E	3000000	0003.00	Cond. SLA 16h							PV RnD			Physical lab	Miscellaneous	0	0	0	04-01-2024 04.35.44.000000000 PM	AYB	0	0	DD	C	1	0	16	0	0	1	0	timerCompleted	2006262200201257#BLB				510	269	0			1	1	1	1	M1	0	IE	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N			04-01-2024 04.35.44.000000000 PM CET
AYB2401029M01	Development Testing	3000000	TP001AAD	3000000	TP001A	4000000	0005.00	Hardness Shore A			°Sh A				PV RnD			Physical lab	Hardness		0	0	04-01-2024 04.35.44.000000000 PM	AYB	0	0	DD		1	0.2	0.1	0	0	1	0		2301102100143917#BLB				475	201	0			1	1	1	1	M1	0	WA	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N			04-01-2024 04.35.44.000000000 PM CET
AYB2401029M01	Development Testing	3000000	TP002AND	4000000	CP001E	3000000	0003.00	Cond. SLA 16h							PV RnD			Physical lab	Miscellaneous	0	0	0	04-01-2024 04.35.44.000000000 PM	AYB	0	0	DD	C	1	0	16	0	0	1	0	timerCompleted	2006262200201257#BLB				510	269	0			1	1	1	1	M1	0	IE	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N			04-01-2024 04.35.44.000000000 PM CET
AYB2401029M01	Development Testing	3000000	TP002AND	4000000	TP002A	4000000	0005.00	Tensile test rubber compound							PV RnD			Physical lab	Tensile tester		0	0	04-01-2024 04.35.44.000000000 PM	AYB	0	0	DD	C	1	0.3	0.2	0	1	1	0		2208172200102508#BLB				510	602	0			1	1	1	1	M1	0	WA	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N			04-01-2024 04.35.44.000000000 PM CET
AYB2401029M01	Development Testing	3000000	TP019AAD	5000000	CP001E	3000000	0003.00	Cond. SLA 16h							PV RnD			Physical lab	Miscellaneous	0	0	0	04-01-2024 04.35.44.000000000 PM	AYB	0	0	DD	C	1	0	16	0	0	1	0	timerCompleted	2006262200201257#BLB				510	269	0			1	1	1	1	M1	0	IE	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N			04-01-2024 04.35.44.000000000 PM CET
AYB2401029M01	Development Testing	3000000	TP019AAD	5000000	TP019A	4000000	0005.00	Rebound at 70°C			%				PV RnD			Physical lab	Rebound tester		0	0	04-01-2024 04.35.44.000000000 PM	AYB	0	0	DD	R.1	1	0.1	0.1	0	1	1	1		2211152100116554#BLB		0	120	465	132	0			1	1	1	1	M1	0	WA	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N			04-01-2024 04.35.44.000000000 PM CET
 


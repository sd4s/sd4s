--*******************************************************************
--view_2_1_1_3_1_partno_dispersion.sql
--Report name : UNI00036R_dispersion	
--Called from: UNI00403R_execution	execution-dashboard
--					"UNI00403R1_requests	"	request-to-execute
--						UNI00403R31	method-details
--							field: part-no
--
--RESULT: RECURSIVE-SQL ON BOM-TREE !!!!!!!!!!
--*******************************************************************

/*
WITH partList AS (
SELECT p.part_no AS part_no
FROM part p
)
*/

--part-no: XEM_B23-1748_01
select DISTINCT * from mv_bom_item_comp_header where part_no='XEM_B23-1748_01' and preferred=1 order by item_number;

XEM_B23-1748_01	1	ENS	1	1	1.1871076	154	2023-11-23 15:46:06.000	Trial E_ FM	10	XEM_B23-1748XN5_01	1.0000000000	ENS	1.0000000000	1.0000000000	1.1752480000	154.0000000000	2023-11-23 15:45:59.000	Trial E_XNP	1.1276276	kg		191.1
XEM_B23-1748_01	1	ENS	1	1	1.1871076	154	2023-11-23 15:46:06.000	Trial E_ FM	20	165421	-1.0000000000	-1	-1.0000000000	-1.0000000000	-1.0000000000	-1.0000000000	1900-01-01 00:00:00.000	-1	0.0193544	kg		3.28
XEM_B23-1748_01	1	ENS	1	1	1.1871076	154	2023-11-23 15:46:06.000	Trial E_ FM	30	160774	-1.0000000000	-1	-1.0000000000	-1.0000000000	-1.0000000000	-1.0000000000	1900-01-01 00:00:00.000	-1	0.0011801	kg		0.2
XEM_B23-1748_01	1	ENS	1	1	1.1871076	154	2023-11-23 15:46:06.000	Trial E_ FM	40	160732	-1.0000000000	-1	-1.0000000000	-1.0000000000	-1.0000000000	-1.0000000000	1900-01-01 00:00:00.000	-1	0.0076709	kg		1.3
XEM_B23-1748_01	1	ENS	1	1	1.1871076	154	2023-11-23 15:46:06.000	Trial E_ FM	50	160612	-1.0000000000	-1	-1.0000000000	-1.0000000000	-1.0000000000	-1.0000000000	1900-01-01 00:00:00.000	-1	0.0312738	kg		5.3

select DISTINCT * from mv_bom_item_comp_header where part_no='XEM_B23-1748XN5_01' and preferred=1 order by item_number;
XEM_B23-1748XN5_01	1	ENS	1	1	1.1752480	154	2023-11-23 15:45:59.000	Trial E_XNP	10	XEM_B23-1748XN4_01	1.0000000000	ENS	1.0000000000	1.0000000000	1.1251261000	154.0000000000	2023-11-23 15:45:54.000	Trial E_XNP	1.0221150	kg		166.2
XEM_B23-1748XN5_01	1	ENS	1	1	1.1752480	154	2023-11-23 15:45:59.000	Trial E_XNP	20	150655	-1.0000000000	-1	-1.0000000000	-1.0000000000	-1.0000000000	-1.0000000000	1900-01-01 00:00:00.000	-1	0.0614991	kg		10.0
XEM_B23-1748XN5_01	1	ENS	1	1	1.1752480	154	2023-11-23 15:45:59.000	Trial E_XNP	50	160514	-1.0000000000	-1	-1.0000000000	-1.0000000000	-1.0000000000	-1.0000000000	1900-01-01 00:00:00.000	-1	0.0368995	kg		6.0
XEM_B23-1748XN5_01	1	ENS	1	1	1.1752480	154	2023-11-23 15:45:59.000	Trial E_XNP	80	165141	-1.0000000000	-1	-1.0000000000	-1.0000000000	-1.0000000000	-1.0000000000	1900-01-01 00:00:00.000	-1	0.0289046	kg		4.7
XEM_B23-1748XN5_01	1	ENS	1	1	1.1752480	154	2023-11-23 15:45:59.000	Trial E_XNP	90	160224	-1.0000000000	-1	-1.0000000000	-1.0000000000	-1.0000000000	-1.0000000000	1900-01-01 00:00:00.000	-1	0.0073799	kg		1.2
XEM_B23-1748XN5_01	1	ENS	1	1	1.1752480	154	2023-11-23 15:45:59.000	Trial E_XNP	100	XGR_1502	-1.0000000000	-1	-1.0000000000	-1.0000000000	-1.0000000000	-1.0000000000	1900-01-01 00:00:00.000	-1	0.0184497	kg		3.0

select DISTINCT * from mv_bom_item_comp_header where part_no='XEM_B23-1748XN4_01' and preferred=1 order by item_number;
XEM_B23-1748XN4_01	1	ENS	1	1	1.1251261	154	2023-11-23 15:45:54.000	Trial E_XNP	10	120020	-1.0000000000	-1	-1.0000000000	-1.0000000000	-1.0000000000	-1.0000000000	1900-01-01 00:00:00.000	-1	0.6769710	kg		100.0
XEM_B23-1748XN4_01	1	ENS	1	1	1.1251261	154	2023-11-23 15:45:54.000	Trial E_XNP	20	150655	-1.0000000000	-1	-1.0000000000	-1.0000000000	-1.0000000000	-1.0000000000	1900-01-01 00:00:00.000	-1	0.3384855	kg		50.0
XEM_B23-1748XN4_01	1	ENS	1	1	1.1251261	154	2023-11-23 15:45:54.000	Trial E_XNP	30	160007	-1.0000000000	-1	-1.0000000000	-1.0000000000	-1.0000000000	-1.0000000000	1900-01-01 00:00:00.000	-1	0.0676971	kg		10.0
XEM_B23-1748XN4_01	1	ENS	1	1	1.1251261	154	2023-11-23 15:45:54.000	Trial E_XNP	40	140203	-1.0000000000	-1	-1.0000000000	-1.0000000000	-1.0000000000	-1.0000000000	1900-01-01 00:00:00.000	-1	0.0270788	kg		4.0
XEM_B23-1748XN4_01	1	ENS	1	1	1.1251261	154	2023-11-23 15:45:54.000	Trial E_XNP	50	160727	-1.0000000000	-1	-1.0000000000	-1.0000000000	-1.0000000000	-1.0000000000	1900-01-01 00:00:00.000	-1	0.0135394	kg		2.0
XEM_B23-1748XN4_01	1	ENS	1	1	1.1251261	154	2023-11-23 15:45:54.000	Trial E_XNP	60	161218	-1.0000000000	-1	-1.0000000000	-1.0000000000	-1.0000000000	-1.0000000000	1900-01-01 00:00:00.000	-1	0.0013539	kg		0.2

/*
--origineel POSTGRES, WERKT NIET OP REDSHIFT...
--
DROP VIEW sc_lims_dal.av_exec_db_partno_dispersion;
--
CREATE OR REPLACE VIEW  sc_lims_dal.av_exec_db_partno_dispersion
AS
WITH RECURSIVE partList AS (
SELECT cast('XEM_B18-1164_46' as CHAR(18) )  AS part_no
,      to_date('29-11-2023 12:18:41','dd-mm-yyyy hh24:mi:ss') AS default_reference_date 
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
--AND NOT EXISTS (SELECT 1
--				FROM specification_header  sh2
--				JOIN status                 s2 USING (status)
--				WHERE sh2.part_no  = H.part_no
--				AND   sh2.revision > H.revision
--				AND    s2.status_type IN ('CURRENT','HISTORIC')
--               )
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
FROM specification_header h2
JOIN status               s2 ON ( s2.status = h2.status AND status_type IN ('CURRENT','HISTORIC') )
WHERE h2.issued_date IS NOT NULL
--AND NOT EXISTS (SELECT 1
--                                           FROM specification_header h2a
--                                           JOIN status               s2a ON (s2a.status = h2a.status)
--                                            WHERE h2a.part_no = h2.part_no
--                                           AND h2a.revision > h2.revision
--                                           AND s2a.status_type IN ('CURRENT','HISTORIC')
--                                           --AND (    h2a.issued_date <= p.reference_date
--                                           --     AND (h2a.obsolescence_date IS NULL OR p.reference_date < h2a.obsolescence_date)
--                                           --     )
--                                           )
)
, componentList AS (
SELECT	h2.part_no
, h2.revision
, h2.issued_date
, h2.obsolescence_date
, h2.planned_effective_date
, h2.status
, s2.sort_desc AS status_code
, s2.status_type
, h2.class3_id
FROM specification_header h2
JOIN status s2 ON (s2.status = h2.status AND status_type IN ('CURRENT','HISTORIC') )
WHERE h2.part_no     NOT LIKE 'X%'
AND   h2.issued_date IS NOT NULL
--AND NOT EXISTS (                 SELECT 1
--                                 FROM specification_header h2a
--                                 JOIN status s2a ON ( s2a.status = h2a.status AND s2a.status_type IN ('CURRENT','HISTORIC'))
--                                 WHERE h2a.part_no = h2.part_no
--                                 AND h2a.part_no NOT LIKE 'X%'
--                                 AND h2a.revision > h2.revision
--                                 AND h2a.issued_date IS NOT NULL
--                )
UNION ALL
SELECT	h2.part_no
, h2.revision
, h2.issued_date
, h2.obsolescence_date
, h2.planned_effective_date
, h2.status
, s2.sort_desc AS status_code
, s2.status_type
, h2.class3_id
FROM specification_header h2
JOIN status s2 ON (	s2.status = h2.status AND status_type IN ('CURRENT','HISTORIC') )
WHERE h2.part_no LIKE 'X%'
AND   h2.issued_date IS NOT NULL
--AND NOT EXISTS (                 SELECT 1
--                                 FROM specification_header h2a
--                                 JOIN status s2a ON (	s2a.status = h2a.status	AND s2a.status_type IN ('CURRENT','HISTORIC') )
--                                 WHERE h2a.part_no = h2.part_no
--                                 AND h2a.part_no LIKE 'X%'
--                                 AND h2a.revision > h2.revision
--                                 AND h2a.issued_date IS NOT NULL
--               )
)
, tree (
  part_no
, revision
, plant
, item_number
, status
, status_code
, status_type
, class3_id
, parent_part
, parent_rev
, parent_status
, parent_status_type
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
, root_part
, root_rev
, root_status
, root_status_type
, root_alternative
, root_preferred
, root_issued_date
, root_reference_date
, reference_date
, part_reference_date
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
SELECT
  b1.component_part AS part_no
, hh.revision
, b1.plant
, b1.item_number
, hh.status
, hh.status_code
, hh.status_type
, hh.class3_id
, p.part_no     AS parent_part
, p.revision    AS parent_rev
, p.status      AS parent_status
, p.status_type AS parent_status_type
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
, p.part_no       AS root_part
, p.revision      AS root_rev
, p.status        AS root_status
, p.status_type   AS root_status_type
, b1.alternative  AS root_alternative
, bh1.preferred   AS root_preferred
, p.issued_date   AS root_issued_date
, CAST(p.reference_date AS date)                                 AS root_reference_date
, CAST(p.reference_date AS date)                                 AS reference_date
, CAST( p.reference_date AS date)                                AS  part_reference_date  
, 1                                                         AS lvl
, CAST('0000' AS char(120))                                AS path
, to_char(b1.item_number, '0999')                          AS pathNode
, CAST('' AS CHAR(100))                                     AS parent_branch
, b1.item_number                                            AS parent_seq
, bh1.base_quantity                                         AS parent_quantity
, b1.quantity * 1 / 1                                       AS normalized_quantity
, DECODE(b1.num_1, 0, 0, b1.quantity / b1.num_1)            AS component_volume
, DECODE(b1.num_1, 0, 0, b1.quantity / b1.num_1)            AS volume
, DECODE(b1.num_1, 0, 0, b1.quantity / b1.num_1)            AS normalized_volume
, CAST(1  AS DECIMAL )                                        AS parent_volume
, to_char(b1.item_number, '0999')                       AS branch
, CAST ('' AS CHAR(200))                                AS indentStr
, CAST('Top' AS CHAR(200))                              AS breadcrumbs
, CASE WHEN p.revision = 1 AND hh.revision = 1 AND p.reference_date < coalesce(hh.issued_date, hh.planned_effective_date) THEN '1' ELSE '0'	END  AS e_issuedAfterExplDate
, CASE WHEN hh.revision IS NULL THEN 1 ELSE 0 END                                                                                                AS e_noPhantomRevision
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
                            --AND NOT EXISTS (SELECT 1
                            --               FROM specification_header h2a
                            --               JOIN status               s2a ON (s2a.status = h2a.status)
                            --                WHERE h2a.part_no = hh.part_no
                            --               AND h2a.revision > hh.revision
                            --               AND s2a.status_type IN ('CURRENT','HISTORIC')
                            --               AND (    h2a.issued_date <= p.reference_date
                            --                    AND (h2a.obsolescence_date IS NULL OR p.reference_date < h2a.obsolescence_date)
                            --                    )
                            --               )
                            )
LEFT JOIN class3 c3   ON (c3.class = hh.class3_id)
WHERE 1 = 1
AND bh1.preferred	= 1
UNION ALL
SELECT b2.component_part                                AS part_no
, hh.revision
, t.plant
, b2.item_number
, hh.status
, hh.status_code
, hh.status_type
, hh.class3_id
, t.part_no                                        AS parent_part
, t.revision                                       AS parent_rev
, t.status                                         AS parent_status
, t.status_type                                    AS parent_status_type
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
, t.root_part
, t.root_rev
, t.root_status
, t.root_status_type
, t.root_alternative
, t.root_preferred
, t.root_issued_date
, CAST(t.root_reference_date AS date)                    AS root_reference_date
, CAST(t.reference_date      AS date)                    AS reference_date
, CAST(part_reference_date   AS date)                    as part_reference_date
, t.lvl +1                                               AS lvl
, cast(substring(t.path || '.' || t.pathNode, 1, 120) as char(120))    AS path
, to_char(b2.item_number, '0999')                        AS pathNode
, t.branch                                                AS parent_branch
, t.item_number                                           AS parent_seq
, bh2.base_quantity                                       AS parent_quantity
, DECODE(bh2.base_quantity, 0, 0, b2.quantity * t.normalized_quantity / bh2.base_quantity)   AS normalized_quantity
, DECODE(b2.num_1, 0, 0, b2.quantity / b2.num_1)                                             AS component_volume
, DECODE(b2.num_1, 0, 0, b2.quantity / b2.num_1) * coalesce(t.volume,DECODE(bh2.base_quantity, 0, 0, b2.quantity / bh2.base_quantity), 1.0 )                       AS volume
, DECODE(b2.num_1, 0, 0, b2.quantity / b2.num_1) * coalesce(t.volume,DECODE(bh2.base_quantity, 0, 0, b2.quantity * t.normalized_quantity / bh2.base_quantity),1.0) AS normalized_volume
, CAST(t.volume AS DECIMAL)                                                                     AS parent_volume
, substring(t.branch || '.' || to_char(b2.item_number, '0999'), 1, 100)                         AS branch
, substring(t.indentStr || ';' , 1, 200)                                                        AS indentStr
, substring(t.breadcrumbs || ' / ' || b2.part_no, 1, 200)                                       AS breadcrumbs
, CASE WHEN t.root_rev = 1 AND hh.revision = 1 AND t.reference_date < coalesce(hh.issued_date, hh.planned_effective_date) THEN '1' ELSE '0' END   AS e_issuedAfterExplDate
, CASE WHEN hh.revision IS NULL THEN 1 ELSE 0 END                                                                                                 AS e_noPhantomRevision
FROM tree         t
JOIN bom_header bh2 ON ( bh2.part_no = t.part_no   AND bh2.revision = t.revision   AND bh2.plant = t.plant   AND bh2.preferred = 1 )
JOIN bom_item    b2 ON ( b2.part_no	 = bh2.part_no AND b2.revision  = bh2.revision AND b2.plant  = bh2.plant AND b2.alternative	= bh2.alternative )
LEFT JOIN componentList hh ON (   b2.component_part = hh.part_no 
                              AND (   hh.issued_date <= t.reference_date
                                  AND (hh.obsolescence_date IS NULL OR t.reference_date < hh.obsolescence_date)
                                  )
                              --AND NOT EXISTS (
                              --    SELECT 1
                              --   FROM specification_header h2a
                              --   JOIN status s2a ON ( s2a.status = h2a.status AND s2a.status_type IN ('CURRENT','HISTORIC'))
                              --   WHERE h2a.part_no = hh.part_no
                              --   AND h2a.part_no NOT LIKE 'X%'
                              --   AND h2a.revision > hh.revision
                              --   AND h2a.issued_date IS NOT NULL
                              --    UNION ALL
                              --    SELECT 1
                              --   FROM specification_header h2a
                              --   JOIN status s2a ON (	s2a.status = h2a.status	AND s2a.status_type IN ('CURRENT','HISTORIC') )
                              --   WHERE h2a.part_no = hh.part_no
                              --   AND h2a.part_no LIKE 'X%'
                              --   AND h2a.revision > hh.revision
                              --   AND h2a.issued_date IS NOT NULL
                              --    )
                              )
WHERE 1 = 1
AND t.lvl < 2
AND t.revision IS NOT NULL
)   
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
, skw.kw_value                              AS function
, itkw.description                          AS kw_label
, phr
, quantity
, density
, root_density
, component_volume
, volume
, normalized_volume
, parent_volume
, normalized_quantity
, cast( SUM(quantity) as char(30) )                   AS quantity_str
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
, skw2.kw_value                           AS parent_function
, lvl
, pathNode
, indentstr
, indentstr || tree.part_no                AS indent_part
, path
, branch
, parent_branch
, parent_seq
, parent_quantity
, tree.normalized_quantity                 AS tree_normalized_quantity
, path || '.' || pathNode                  AS fullpath
, breadcrumbs
, e_issuedAfterExplDate
, e_noPhantomRevision
, CASE WHEN EXISTS (SELECT 1 FROM bom_item c WHERE c.part_no = tree.part_no) THEN 0 ELSE 1 END AS leaf
--, part_cost.price
--, part_cost.uom                           AS cost_per_uom
--, part_cost.currency
--, part_cost.period                        AS cost_period
--, part_cost.price * tree.normalized_quantity * ( CASE
--                           WHEN tree.uom = 'g' AND part_cost.uom = 'kg' THEN 0.001
--                           WHEN tree.uom = 'mm' AND part_cost.uom = 'm' THEN 0.001
--                           WHEN tree.uom = 'kg' AND part_cost.uom = 'g' THEN 1000.0
--                           WHEN tree.uom = 'm' AND part_cost.uom = 'mm' THEN 1000.0
--                           ELSE 1.0
--                           END  )           AS cost
FROM      tree
JOIN      part    root ON (tree.root_part   = root.part_no)
LEFT JOIN class3    c3 ON (c3.class         = tree.class3_id)
LEFT JOIN part   parnt ON (tree.parent_part = parnt.part_no)
LEFT JOIN part         ON (tree.part_no     = part.part_no)
left JOIN specification_kw skw  ON ( tree.part_no = skw.part_no )
left join itkw             itkw on ( skw.kw_id = itkw.kw_id and itkw.description IN ('Function', 'Spec. Function') )
--LEFT JOIN (	SELECT part_no
--            , kw_value
--			, itkw.description AS kw_label
--           FROM specification_kw skw
--            JOIN itkw                  ON (skw.kw_id = itkw.kw_id AND itkw.description IN ('Function', 'Spec. Function') )
--          ) kw ON (tree.part_no = kw.part_no)
left JOIN specification_kw skw2  ON ( tree.parent_part = skw2.part_no )
left join itkw             itkw2 on ( skw2.kw_id = itkw2.kw_id and itkw2.description IN ('Function', 'Spec. Function') )
--LEFT JOIN (	SELECT part_no, kw_value
--            FROM specification_kw skw
--            JOIN itkw                  ON (skw.kw_id = itkw.kw_id AND itkw.description IN ('Function', 'Spec. Function') )
--          ) parent_kw ON (tree.parent_part = parent_kw.part_no)
LEFT JOIN plant       ON (tree.plant = plant.plant)
--LEFT JOIN part_cost   ON (tree.part_no = part_cost.part_no AND tree.plant = part_cost.plant)
WHERE 1 = 1
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
, skw.kw_value
, itkw.description        --label
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
, skw2.kw_value                           --parent_kw.kw_value
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
--, part_cost.price
--, part_cost.uom
--, part_cost.currency
--, part_cost.period
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
*/

select * from sc_lims_dal.av_exec_db_partno_dispersion;
--*******************************
--redshift-error:
--SQL Error [0A000]: ERROR: Correlated subquery in recursive CTE is not supported yet !!!!!!!!!!!!!!!!!!!
--******************************* *





--******************************************************************    
--******************************************************************    
--NIEUWE POGING OM DE TREE VIA DE MATERIALIZED-VIEW sc_interspec_ens.mv_bom_item_comp_header TE LATEN LOPEN...
--*******************************************************************************************************    
--REVISION:
--25-03-2024  Add extra criterium for COMP_PREFERRED otherwise we get all alternatives in output...
--            + Use COMP_REVISION for JOINING part-no + component-part-no !!!!!!!!!
--08-04-2024  Add DENSITY-columns based on BOM_ITEM.NUM_1 (already added to MV = MV_BOM_ITEM_COMP_HEADER !!!
--********************************************************************************************************    
DROP VIEW sc_lims_dal.av_exec_db_partno_dispersion;
--
CREATE OR REPLACE VIEW  sc_lims_dal.av_exec_db_partno_dispersion
( part_no
, revision
, plant
, item_number
, status
, parent_part
, parent_rev
, parent_status
, alternative
, preferred
, phr
, quantity
, density
, root_density
, uom
, characteristic
, issued_date
, root_part
, root_rev
, root_status
, root_alternative
, root_preferred
, root_issued_date
, lvl
, lvl_tree
, path
, pathNode
, parent_branch
, parent_seq
, parent_quantity
, normalized_quantity
, component_volume
, volume
--, normalized_volume
--, parent_volume
, branch
, indentStr
, breadcrumbs
)
AS
WITH RECURSIVE tree (
  part_no
, revision
, plant
, item_number
, status
, parent_part
, parent_rev
, parent_status
, alternative
, preferred
, phr
, quantity
, density
, root_density
, uom
, characteristic
, issued_date
, root_part
, root_rev
, root_status
, root_alternative
, root_preferred
, root_issued_date
, lvl
, lvl_tree
, path
, pathNode
, parent_branch
, parent_seq
, parent_quantity
, normalized_quantity
, component_volume
, volume
--, normalized_volume
--, parent_volume
, branch
, indentStr
, breadcrumbs
) AS 
(SELECT DISTINCT mv.component_part AS part_no
, convert(integer, mv.comp_revision)                  as revision
, mv.plant                         as plant
, mv.item_number
, mv.status                        as status
, mv.part_no     AS parent_part
, convert(integer, mv.revision)    AS parent_rev
, mv.status      AS parent_status
, mv.alternative
, mv.preferred
, mv.phr_num_5      AS phr
, mv.quantity
, mv.density_num_1      AS density
, mv.density_num_1      AS root_density
, mv.uom
, mv.characteristic
, mv.issued_date
, mv.part_no       AS root_part
, mv.revision      AS root_rev
, mv.status        AS root_status
, mv.alternative  AS root_alternative
, mv.preferred   AS root_preferred
, mv.issued_date   AS root_issued_date
, cast(1  as integer)                                       AS lvl
, RPAD('.', (1-1)*2, '.') || '1'                            AS lvl_tree
, CAST('0000' AS VARchar(200))                              AS path
, to_char(mv.item_number, '0999')                           AS pathNode
, CAST('' AS VARCHAR(100))                                  AS parent_branch
, mv.item_number                                            AS parent_seq
, mv.base_quantity                                          AS parent_quantity
, cast( (mv.quantity * 1 / 1 ) as decimal)                  AS normalized_quantity
, DECODE(mv.density_num_1, 0, 0, mv.quantity / mv.density_num_1)    AS component_volume
, DECODE(mv.density_num_1, 0, 0, mv.quantity / mv.density_num_1)    AS volume
--, DECODE(b1.num_1, 0, 0, b1.quantity / b1.num_1)            AS normalized_volume
--, CAST(1  AS DECIMAL )                                        AS parent_volume
, cast( to_char(mv.item_number, '0999') as varchar(200) )     AS branch
, CAST ('' AS VARCHAR(200))                                AS indentStr
, CAST('Top' AS VARCHAR(200))                              AS breadcrumbs
FROM  sc_interspec_ens.mv_bom_item_comp_header  mv
WHERE mv.preferred	= 1 
and   abs(mv.comp_preferred) = 1
UNION ALL
SELECT mv2.component_part                          AS part_no
, convert(integer, mv2.comp_revision )                as revision 
, mv2.plant                                      as plant
, mv2.item_number
, mv2.status                                  as status
, t.part_no                                        AS parent_part
, convert(integer, t.revision )                  AS parent_rev
, t.status                                         AS parent_status
, mv2.alternative
, mv2.preferred
, mv2.phr_num_5                                   AS phr
, mv2.quantity
, mv2.density_num_1                               AS density
, t.root_density                                  AS root_density
, mv2.uom
, mv2.characteristic                              as characteristic
, t.issued_date
, t.root_part
, t.root_rev
, t.root_status
, t.root_alternative
, t.root_preferred
, t.root_issued_date
, cast(t.lvl +1  as integer)                                              AS lvl
, RPAD('.', (t.lvl)*2, '.') || t.lvl+1                                    AS lvl_tree
, cast(substring(t.path || '.' || t.pathNode, 1, 120) as VARchar(120))    AS path
, to_char(mv2.item_number, '0999')                                        AS pathNode
, t.branch                                                                AS parent_branch
, t.item_number                                                           AS parent_seq
, mv2.base_quantity                                                       AS parent_quantity
, cast(DECODE(mv2.base_quantity, 0, 0, mv2.quantity * t.normalized_quantity / mv2.base_quantity) as decimal)   AS normalized_quantity
, DECODE(mv2.density_num_1, 0, 0, mv2.quantity / mv2.density_num_1)                                            AS component_volume
, DECODE(mv2.density_num_1, 0, 0, mv2.quantity / mv2.density_num_1) * t.volume                                 AS volume
--, DECODE(b2.num_1, 0, 0, b2.quantity / b2.num_1) * coalesce(t.volume,DECODE(bh2.base_quantity, 0, 0, b2.quantity * t.normalized_quantity / bh2.base_quantity),1.0) AS normalized_volume
--, CAST(t.volume AS DECIMAL)                                                                     AS parent_volume
, cast(substring(t.branch || '.' || to_char(mv2.item_number, '0999'), 1, 100) as varchar(200))     AS branch
, CAST(substring(t.indentStr || ';' , 1, 200)  AS VARCHAR(200) )                                AS indentStr
, CAST(substring(t.breadcrumbs || ' / ' || mv2.part_no, 1, 200)   AS VARCHAR(200) )              AS breadcrumbs
FROM tree         t
JOIN sc_interspec_ens.mv_bom_item_comp_header  mv2 ON (mv2.part_no = t.part_no  AND convert(integer, mv2.revision) = convert(integer, t.revision) AND mv2.plant = t.plant and mv2.preferred = 1 and abs(mv2.comp_preferred) = 1)
--JOIN bom_header bh2 ON ( bh2.part_no = t.part_no   AND bh2.revision = t.revision   AND bh2.plant = t.plant   AND bh2.alternative = t.alternative AND bh2.preferred = 1 )
--JOIN bom_item    b2 ON ( b2.part_no	 = bh2.part_no AND b2.revision  = bh2.revision AND b2.plant  = bh2.plant AND b2.alternative  = bh2.alternative )
WHERE t.lvl < 12
)
select * 
from tree tt
--where tt.root_part = 'EG_L650/65R42-174G'  --'EF_650/65R42TRO174'   --'XEM_B23-1748_01'   --XEM_B24-1198
order by tt.root_part
,        tt.lvl
,        tt.parent_part
,        tt.item_number
;

--get the correct ORDER in REPORT:
--order by RPAD( replace( PATH||'.'|| PATHNODE ,' ','') ,64,'.0000')

--
grant all on  sc_lims_dal.av_exec_db_partno_dispersion   to usr_rna_readonly1;



/*
--VERSION BEFORE COMP-REVISION DD 25-03-2024 !!!!!!!
CREATE OR REPLACE VIEW  sc_lims_dal.av_exec_db_partno_dispersion
( part_no
, revision
, plant
, item_number
, status
, parent_part
, parent_rev
, parent_status
, alternative
, preferred
, phr
, quantity
--, density
--, root_density
, uom
, characteristic
, issued_date
, root_part
, root_rev
, root_status
, root_alternative
, root_preferred
, root_issued_date
, lvl
, path
, pathNode
, parent_branch
, parent_seq
, parent_quantity
, normalized_quantity
--, component_volume
--, volume
--, normalized_volume
--, parent_volume
, branch
, indentStr
, breadcrumbs
)
AS
WITH RECURSIVE tree (
  part_no
, revision
, plant
, item_number
, status
, parent_part
, parent_rev
, parent_status
, alternative
, preferred
, phr
, quantity
--, density
--, root_density
, uom
, characteristic
, issued_date
, root_part
, root_rev
, root_status
, root_alternative
, root_preferred
, root_issued_date
, lvl
, path
, pathNode
, parent_branch
, parent_seq
, parent_quantity
, normalized_quantity
--, component_volume
--, volume
--, normalized_volume
--, parent_volume
, branch
, indentStr
, breadcrumbs
) AS 
(SELECT DISTINCT mv.component_part AS part_no
, mv.revision
, mv.plant
, mv.item_number
, mv.status
, mv.part_no     AS parent_part
, mv.revision    AS parent_rev
, mv.status      AS parent_status
, mv.alternative
, mv.preferred
, mv.phr_num_5      AS phr
, mv.quantity
--, b1.num_1      AS density
--, b1.num_1      AS root_density
, mv.uom
, mv.characteristic
, mv.issued_date
, mv.part_no       AS root_part
, mv.revision      AS root_rev
, mv.status        AS root_status
, mv.alternative  AS root_alternative
, mv.preferred   AS root_preferred
, mv.issued_date   AS root_issued_date
, cast(1  as integer)                                      AS lvl
, CAST('0000' AS VARchar(200))                                AS path
, to_char(mv.item_number, '0999')                          AS pathNode
, CAST('' AS VARCHAR(100))                                     AS parent_branch
, mv.item_number                                            AS parent_seq
, mv.base_quantity                                         AS parent_quantity
, cast( (mv.quantity * 1 / 1 ) as decimal)                 AS normalized_quantity
--, DECODE(b1.num_1, 0, 0, b1.quantity / b1.num_1)            AS component_volume
--, DECODE(b1.num_1, 0, 0, b1.quantity / b1.num_1)            AS volume
--, DECODE(b1.num_1, 0, 0, b1.quantity / b1.num_1)            AS normalized_volume
--, CAST(1  AS DECIMAL )                                        AS parent_volume
, cast( to_char(mv.item_number, '0999') as varchar(200) )     AS branch
, CAST ('' AS VARCHAR(200))                                AS indentStr
, CAST('Top' AS VARCHAR(200))                              AS breadcrumbs
FROM  sc_interspec_ens.mv_bom_item_comp_header  mv
WHERE mv.preferred	= 1 
and   abs(mv.comp_preferred) = 1
UNION ALL
SELECT b2.component_part                                AS part_no
, bh2.revision
, t.plant
, b2.item_number
, t.status
, t.part_no                                        AS parent_part
, t.revision                                       AS parent_rev
, t.status                                         AS parent_status
, bh2.alternative
, bh2.preferred
, b2.num_5                                         AS phr
, b2.quantity
--, b2.num_1                                         AS density
--, t.root_density
, b2.uom
, b2.ch_1                                         as characteristic
, t.issued_date
, t.root_part
, t.root_rev
, t.root_status
, t.root_alternative
, t.root_preferred
, t.root_issued_date
, cast(t.lvl +1  as integer)                                          AS lvl
, cast(substring(t.path || '.' || t.pathNode, 1, 120) as VARchar(120))    AS path
, to_char(b2.item_number, '0999')                         AS pathNode
, t.branch                                                AS parent_branch
, t.item_number                                           AS parent_seq
, bh2.base_quantity                                       AS parent_quantity
, cast(DECODE(bh2.base_quantity, 0, 0, b2.quantity * t.normalized_quantity / bh2.base_quantity) as decimal)   AS normalized_quantity
--, DECODE(b2.num_1, 0, 0, b2.quantity / b2.num_1)                                             AS component_volume
--, DECODE(b2.num_1, 0, 0, b2.quantity / b2.num_1) * coalesce(t.volume,DECODE(bh2.base_quantity, 0, 0, b2.quantity / bh2.base_quantity), 1.0 )                       AS volume
--, DECODE(b2.num_1, 0, 0, b2.quantity / b2.num_1) * coalesce(t.volume,DECODE(bh2.base_quantity, 0, 0, b2.quantity * t.normalized_quantity / bh2.base_quantity),1.0) AS normalized_volume
--, CAST(t.volume AS DECIMAL)                                                                     AS parent_volume
, cast(substring(t.branch || '.' || to_char(b2.item_number, '0999'), 1, 100) as varchar(200))     AS branch
, CAST(substring(t.indentStr || ';' , 1, 200)  AS VARCHAR(200) )                                AS indentStr
, CAST(substring(t.breadcrumbs || ' / ' || b2.part_no, 1, 200)   AS VARCHAR(200) )              AS breadcrumbs
FROM tree         t
JOIN bom_header bh2 ON ( bh2.part_no = t.part_no   AND bh2.revision = t.revision   AND bh2.plant = t.plant   AND bh2.alternative = t.alternative AND bh2.preferred = 1 )
JOIN bom_item    b2 ON ( b2.part_no	 = bh2.part_no AND b2.revision  = bh2.revision AND b2.plant  = bh2.plant AND b2.alternative  = bh2.alternative )
WHERE t.lvl < 12
)
select * 
from tree tt
--where tt.root_part = 'XEM_B23-1748_01'   --XEM_B24-1198
order by tt.root_part
,        tt.lvl
,        tt.parent_part
,        tt.item_number
;

grant all on  sc_lims_dal.av_exec_db_partno_dispersion   to usr_rna_readonly1;
*/



/*
--SQL Error [0A000]: ERROR: The recursive subquery of CTE tree can not have distinct clause.
*/
/*
SQL Error [XX000]: ERROR: Hit recursive CTE max rows limit, please add correct CTE termination predicates or change the max_recursion_rows parameter.
  Detail: 
  -----------------------------------------------
  error:  Hit recursive CTE max rows limit, please add correct CTE termination predicates or change the max_recursion_rows parameter.
  code:      8001
  context:   
  query:     839145818
  location:  step_common.cpp:1573
  process:   query1_122_839145818 [pid=13483]
  -----------------------------------------------
*/

select * from sc_interspec_ens.mv_bom_item_comp_header  mv where part_no = 'EF_650/65R42TRO174'  and revision=12;
select * from sc_interspec_ens.mv_bom_item_comp_header  mv where part_no = 'EG_L650/65R42-174G'  and revision=9;
select * from sc_interspec_ens.mv_bom_item_comp_header  mv where part_no = 'EV_BY245/30R20UVPX'  ;




--TEST-QUERY
select * 
from  sc_lims_dal.av_exec_db_partno_dispersion
where root_part = 'XEM_B23-1748_01' 
and   root_rev = 1
;

select * 
from  sc_lims_dal.av_exec_db_partno_dispersion
where root_part = 'EM_721' 
and   root_rev = 102
order by RPAD( replace( PATH||'.'|| PATHNODE ,' ','') ,64,'.0000')
;




/*
--QUERY om NUM_1 erbij te halen (zit nu nog niet in MV !!) 
with c_bom as
(select a.part_no, p.part_descr, a.revision, a.parent_part, a.parent_rev, a.phr, a.quantity, a.uom 
from  sc_lims_dal.av_exec_db_partno_dispersion  a
join  sc_lims_dal.av_parts                      p on p.part_number = a.part_no
where a.root_part = 'XEM_B23-1734_04' 
and   a.root_rev = 1
)
select b.part_no
,      b.part_descr
,      b.revision
,      b.parent_part
,      b.parent_rev 
,      b.phr
,      b.quantity
,      b.uom
,      bi.num_1 as density
from  c_bom  b
join  sc_interspec_ens.bom_item bi on (bi.part_no = b.parent_part and bi.revision = b.parent_rev and bi.component_part = b.part_no)
;
*/

/*
--query om de ORDERING uit te testen, voor het tonen van de part-no in juiste volgorde, doen we nu obv PATH !!!
with c_bom as
(select a.part_no, p.part_descr, a.revision, a.parent_part, a.parent_rev, a.alternative, a.phr, a.quantity, a.uom , a.lvl, a.lvl_tree, a.path, a.pathNode, a.breadcrumbs
from  sc_lims_dal.av_exec_db_partno_dispersion  a
join  sc_lims_dal.av_parts                      p on p.part_number = a.part_no
where a.root_part = 'EF_650/65R42TRO174' 
and   a.root_rev = 12
--AND   a.revision = -1 
)
select b.part_no
,      b.part_descr
,      b.revision
,      case when b.revision = -1
            then (select max(sh.revision) from specification_header sh where sh.part_no = b.part_no)
            else b.revision
       end           as  case_revision
,      b.parent_part
,      b.parent_rev 
,      b.alternative
,      b.phr
,      b.quantity
,      b.uom
,      bi.num_1 as density
,      b.lvl, b.lvl_tree, b.path, b.pathNode, b.breadcrumbs
,      RPAD( replace( PATH||'.'|| PATHNODE ,' ','') ,64,'.0000')
from c_bom               b
join  sc_interspec_ens.bom_item bi on (bi.part_no = b.parent_part and bi.revision = b.parent_rev and bi.alternative = b.alternative and bi.component_part = b.part_no)
order by RPAD( replace( PATH||'.'|| PATHNODE ,' ','') ,64,'.0000')
;
*/

select * from sc_interspec_ens.mv_bom_item_comp_header where part_no='XEM_B23-1734_04'  and component_part = '160612'  



--AGRICULTERAL-TYRE
select * 
from  sc_lims_dal.av_exec_db_partno_dispersion
where root_part = 'EF_650/65R42TRO174' 
and   root_rev = 12
;

select * 
from  sc_lims_dal.av_exec_db_partno_dispersion
where root_part = 'EG_L650/65R42-174G' 
and   root_rev = 9
;






select DISTINCT PART_NO
from  sc_lims_dal.av_exec_db_partno_dispersion
;




/*
where tt.root_part = 'XEM_B23-1748_01'   
--
120020				1	ENS	10	154	XEM_B23-1748XN4_01	1	154	1	1	100.0	0.6769710	kg		2023-11-23 15:46:06.000	XEM_B23-1748_01	1	154	1	1	2023-11-23 15:46:06.000	3	0000. 0010. 0010                                                                                                        	 0010	 0010. 0010                                                                                         	10	1.1251261	0	 0010. 0010. 0010	;;                                                                                                                                                                                                      	Top / XEM_B23-1748XN5_01 / XEM_B23-1748XN4_01                                                                                                                                                           
140203				1	ENS	40	154	XEM_B23-1748XN4_01	1	154	1	1	4.0	0.0270788	kg		2023-11-23 15:46:06.000	XEM_B23-1748_01	1	154	1	1	2023-11-23 15:46:06.000	3	0000. 0010. 0010                                                                                                        	 0040	 0010. 0010                                                                                         	10	1.1251261	0	 0010. 0010. 0040	;;                                                                                                                                                                                                      	Top / XEM_B23-1748XN5_01 / XEM_B23-1748XN4_01                                                                                                                                                           
150655				1	ENS	20	154	XEM_B23-1748XN5_01	1	154	1	1	10.0	0.0614991	kg		2023-11-23 15:46:06.000	XEM_B23-1748_01	1	154	1	1	2023-11-23 15:46:06.000	2	0000. 0010                                                                                                              	 0020	 0010                                                                                               	10	1.1752480	0	 0010. 0020	;                                                                                                                                                                                                       	Top / XEM_B23-1748XN5_01                                                                                                                                                                                
150655				1	ENS	20	154	XEM_B23-1748XN4_01	1	154	1	1	50.0	0.3384855	kg		2023-11-23 15:46:06.000	XEM_B23-1748_01	1	154	1	1	2023-11-23 15:46:06.000	3	0000. 0010. 0010                                                                                                        	 0020	 0010. 0010                                                                                         	10	1.1251261	0	 0010. 0010. 0020	;;                                                                                                                                                                                                      	Top / XEM_B23-1748XN5_01 / XEM_B23-1748XN4_01                                                                                                                                                           
160007				1	ENS	30	154	XEM_B23-1748XN4_01	1	154	1	1	10.0	0.0676971	kg		2023-11-23 15:46:06.000	XEM_B23-1748_01	1	154	1	1	2023-11-23 15:46:06.000	3	0000. 0010. 0010                                                                                                        	 0030	 0010. 0010                                                                                         	10	1.1251261	0	 0010. 0010. 0030	;;                                                                                                                                                                                                      	Top / XEM_B23-1748XN5_01 / XEM_B23-1748XN4_01                                                                                                                                                           
160224				1	ENS	90	154	XEM_B23-1748XN5_01	1	154	1	1	1.2	0.0073799	kg		2023-11-23 15:46:06.000	XEM_B23-1748_01	1	154	1	1	2023-11-23 15:46:06.000	2	0000. 0010                                                                                                              	 0090	 0010                                                                                               	10	1.1752480	0	 0010. 0090	;                                                                                                                                                                                                       	Top / XEM_B23-1748XN5_01                                                                                                                                                                                
160514				1	ENS	50	154	XEM_B23-1748XN5_01	1	154	1	1	6.0	0.0368995	kg		2023-11-23 15:46:06.000	XEM_B23-1748_01	1	154	1	1	2023-11-23 15:46:06.000	2	0000. 0010                                                                                                              	 0050	 0010                                                                                               	10	1.1752480	0	 0010. 0050	;                                                                                                                                                                                                       	Top / XEM_B23-1748XN5_01                                                                                                                                                                                
160612				1	ENS	50	154	XEM_B23-1748_01	1	154	1	1	5.3	0.0312738	kg		2023-11-23 15:46:06.000	XEM_B23-1748_01	1	154	1	1	2023-11-23 15:46:06.000	1	0000                                                                                                                    	 0050	                                                                                                    	50	1.1871076	0	 0050	                                                                                                                                                                                                        	Top                                                                                                                                                                                                     
160727				1	ENS	50	154	XEM_B23-1748XN4_01	1	154	1	1	2.0	0.0135394	kg		2023-11-23 15:46:06.000	XEM_B23-1748_01	1	154	1	1	2023-11-23 15:46:06.000	3	0000. 0010. 0010                                                                                                        	 0050	 0010. 0010                                                                                         	10	1.1251261	0	 0010. 0010. 0050	;;                                                                                                                                                                                                      	Top / XEM_B23-1748XN5_01 / XEM_B23-1748XN4_01                                                                                                                                                           
160732				1	ENS	40	154	XEM_B23-1748_01	1	154	1	1	1.3	0.0076709	kg		2023-11-23 15:46:06.000	XEM_B23-1748_01	1	154	1	1	2023-11-23 15:46:06.000	1	0000                                                                                                                    	 0040	                                                                                                    	40	1.1871076	0	 0040	                                                                                                                                                                                                        	Top                                                                                                                                                                                                     
160774				1	ENS	30	154	XEM_B23-1748_01	1	154	1	1	0.2	0.0011801	kg		2023-11-23 15:46:06.000	XEM_B23-1748_01	1	154	1	1	2023-11-23 15:46:06.000	1	0000                                                                                                                    	 0030	                                                                                                    	30	1.1871076	0	 0030	                                                                                                                                                                                                        	Top                                                                                                                                                                                                     
161218				1	ENS	60	154	XEM_B23-1748XN4_01	1	154	1	1	0.2	0.0013539	kg		2023-11-23 15:46:06.000	XEM_B23-1748_01	1	154	1	1	2023-11-23 15:46:06.000	3	0000. 0010. 0010                                                                                                        	 0060	 0010. 0010                                                                                         	10	1.1251261	0	 0010. 0010. 0060	;;                                                                                                                                                                                                      	Top / XEM_B23-1748XN5_01 / XEM_B23-1748XN4_01                                                                                                                                                           
165141				1	ENS	80	154	XEM_B23-1748XN5_01	1	154	1	1	4.7	0.0289046	kg		2023-11-23 15:46:06.000	XEM_B23-1748_01	1	154	1	1	2023-11-23 15:46:06.000	2	0000. 0010                                                                                                              	 0080	 0010                                                                                               	10	1.1752480	0	 0010. 0080	;                                                                                                                                                                                                       	Top / XEM_B23-1748XN5_01                                                                                                                                                                                
165421				1	ENS	20	154	XEM_B23-1748_01	1	154	1	1	3.28	0.0193544	kg		2023-11-23 15:46:06.000	XEM_B23-1748_01	1	154	1	1	2023-11-23 15:46:06.000	1	0000                                                                                                                    	 0020	                                                                                                    	20	1.1871076	0	 0020	                                                                                                                                                                                                        	Top                                                                                                                                                                                                     
XEM_B23-1748XN4_01	1	ENS	10	154	XEM_B23-1748XN5_01	1	154	1	1	166.2	1.0221150	kg		2023-11-23 15:46:06.000	XEM_B23-1748_01	1	154	1	1	2023-11-23 15:46:06.000	2	0000. 0010                                                                                                              	 0010	 0010                                                                                               	10	1.1752480	0	 0010. 0010	;                                                                                                                                                                                                       	Top / XEM_B23-1748XN5_01                                                                                                                                                                                
XEM_B23-1748XN5_01	1	ENS	10	154	XEM_B23-1748_01	1	154	1	1	191.1	1.1276276	kg		2023-11-23 15:46:06.000	XEM_B23-1748_01	1	154	1	1	2023-11-23 15:46:06.000	1	0000                                                                                                                    	 0010	                                                                                                    	10	1.1871076	1	 0010	                                                                                                                                                                                                        	Top                                                                                                                                                                                                     
XGR_1502			1	ENS	100	154	XEM_B23-1748XN5_01	1	154	1	1	3.0	0.0184497	kg		2023-11-23 15:46:06.000	XEM_B23-1748_01	1	154	1	1	2023-11-23 15:46:06.000	2	0000. 0010                                                                                                              	 0100	 0010                                                                                               	10	1.1752480	0	 0010. 0100	;                                                                                                                                                                                                       	Top / XEM_B23-1748XN5_01                                                                                                                                                                                
*/

/*
where tt.root_part = 'XEM_B24-1198' 
--
120020	2	GYO	10	154	XEM_B24-1198XN4	2	154	1	1	37.5	0.3024836	kg		2024-01-31 12:25:41.000	XEM_B24-1198	2	154	1	1	2024-01-31 12:25:41.000	3	0000. 0010. 0010	 0010	 0010. 0010	10	1.0244110	0	 0010. 0010. 0010	;;	Top / XEM_B24-1198XN5 / XEM_B24-1198XN4
131424	2	GYO	20	154	XEM_B24-1198XN4	2	154	1	1	62.5	0.5041394	kg		2024-01-31 12:25:41.000	XEM_B24-1198	2	154	1	1	2024-01-31 12:25:41.000	3	0000. 0010. 0010	 0020	 0010. 0010	10	1.0244110	0	 0010. 0010. 0020	;;	Top / XEM_B24-1198XN5 / XEM_B24-1198XN4
150708	2	GYO	30	154	XEM_B24-1198XN5	2	154	1	1	20.0	0.1327054	kg		2024-01-31 12:25:41.000	XEM_B24-1198	2	154	1	1	2024-01-31 12:25:41.000	2	0000. 0010	 0030	 0010	10	1.0749136	0	 0010. 0030	;	Top / XEM_B24-1198XN5
150708	2	GYO	30	154	XEM_B24-1198XN4	2	154	1	1	21.0	0.1693908	kg		2024-01-31 12:25:41.000	XEM_B24-1198	2	154	1	1	2024-01-31 12:25:41.000	3	0000. 0010. 0010	 0030	 0010. 0010	10	1.0244110	0	 0010. 0010. 0030	;;	Top / XEM_B24-1198XN5 / XEM_B24-1198XN4
160224	2	GYO	60	154	XEM_B24-1198XN4	2	154	1	1	2.0	0.0161325	kg		2024-01-31 12:25:41.000	XEM_B24-1198	2	154	1	1	2024-01-31 12:25:41.000	3	0000. 0010. 0010	 0060	 0010. 0010	10	1.0244110	0	 0010. 0010. 0060	;;	Top / XEM_B24-1198XN5 / XEM_B24-1198XN4
160327	2	GYO	30	154	XEM_B24-1198	2	154	1	1	0.55	0.0036019	kg		2024-01-31 12:25:41.000	XEM_B24-1198	2	154	1	1	2024-01-31 12:25:41.000	1	0000	 0030		30	1.0795846	0	 0030		Top
160514	2	GYO	50	154	XEM_B24-1198XN4	2	154	1	1	4.0	0.0322649	kg		2024-01-31 12:25:41.000	XEM_B24-1198	2	154	1	1	2024-01-31 12:25:41.000	3	0000. 0010. 0010	 0050	 0010. 0010	10	1.0244110	0	 0010. 0010. 0050	;;	Top / XEM_B24-1198XN5 / XEM_B24-1198XN4
160612	2	GYO	20	154	XEM_B24-1198	2	154	1	1	1.5	0.0098233	kg		2024-01-31 12:25:41.000	XEM_B24-1198	2	154	1	1	2024-01-31 12:25:41.000	1	0000	 0020		20	1.0795846	0	 0020		Top
160774	2	GYO	40	154	XEM_B24-1198	2	154	1	1	0.1	0.0006549	kg		2024-01-31 12:25:41.000	XEM_B24-1198	2	154	1	1	2024-01-31 12:25:41.000	1	0000	 0040		40	1.0795846	0	 0040		Top
160909	2	GYO	50	154	XEM_B24-1198	2	154	1	1	0.7	0.0045842	kg		2024-01-31 12:25:41.000	XEM_B24-1198	2	154	1	1	2024-01-31 12:25:41.000	1	0000	 0050		50	1.0795846	0	 0050		Top
X169075	2	GYO	50	154	XEM_B24-1198XN5	2	154	1	1	15.0	0.0995291	kg		2024-01-31 12:25:41.000	XEM_B24-1198	2	154	1	1	2024-01-31 12:25:41.000	2	0000. 0010	 0050	 0010	10	1.0749136	0	 0010. 0050	;	Top / XEM_B24-1198XN5
XEM_B24-1198XN4	2	GYO	10	154	XEM_B24-1198XN5	2	154	1	1	127.0	0.8426793	kg		2024-01-31 12:25:41.000	XEM_B24-1198	2	154	1	1	2024-01-31 12:25:41.000	2	0000. 0010	 0010	 0010	10	1.0749136	0	 0010. 0010	;	Top / XEM_B24-1198XN5
XEM_B24-1198XN5	2	GYO	10	154	XEM_B24-1198	2	154	1	1	162.0	1.0609202	kg		2024-01-31 12:25:41.000	XEM_B24-1198	2	154	1	1	2024-01-31 12:25:41.000	1	0000	 0010		10	1.0795846	1	 0010		Top
*/

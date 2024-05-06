WITH cart AS 

SELECT 'Array'                                                AS origin
 ,      'EF_540/65R34TVZM45'                                    AS part_no
 ,      to_date('2023/10/09 10:36:32', 'YYYY/MM/DD HH24:MI:SS') AS reference_date
 ,      NULL                                                    AS plant 
 FROM dual
;
--Array	EF_540/65R34TVZM45	09-10-2023 10:36:32	 
WITH  partList AS 

SELECT H.part_no
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
 ,	    to_date('2023/10/09 10:36:32', 'YYYY/MM/DD HH24:MI:SS')    reference_date
 FROM specification_header H                    --cart vervangen door hard-coded PART-NO !!!
 JOIN status               S ON (S.status   = H.status)
 JOIN class3               C ON (C.class    = H.class3_id)
 LEFT JOIN bom_header      B ON ( B.part_no = H.part_no AND B.revision = H.revision )
 WHERE h.part_no ='EF_540/65R34TVZM45'       --cart vervangen door hard-coded PART-NO !!!
 AND S.status_type IN ('HISTORIC', 'CURRENT')
 --AND C.sort_desc	= 'FOC_NONE'
 AND B.preferred	= 1
 AND B.alternative	= 1    --FOC_NONE
 AND (NULL IS NULL OR B.plant = NULL)    --L.plant VERVANGEN door NULL
 AND H.revision = ( SELECT MAX(sh.revision)
                 --NOT EXISTS ( SELECT 1
                  FROM specification_header  sh
                  JOIN status s on (s.status = sh.status)
                  WHERE sh.part_no = H.part_no
                  AND sh.revision  = H.revision
                  AND s.status_type IN ('HISTORIC', 'CURRENT')
                 )
 AND	( 'DEFAULT' <> 'REFDATE'
        OR ( 'DEFAULT' = 'REFDATE'
           AND	to_date('2023/10/09 10:36:32', 'YYYY/MM/DD HH24:MI:SS') >= coalesce(H.issued_date, H.planned_effective_date)     --L.REFERENCE_DATE = to_date('2023/10/09 10:36:32', 'YYYY/MM/DD HH24:MI:SS')
           AND (  H.obsolescence_date IS NULL 
		       OR to_date('2023/10/09 10:36:32', 'YYYY/MM/DD HH24:MI:SS') < H.obsolescence_date                                  --L.REFERENCE_DATE = to_date('2023/10/09 10:36:32', 'YYYY/MM/DD HH24:MI:SS')
			   )
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
 ,	      to_date('2023/10/09 10:36:32', 'YYYY/MM/DD HH24:MI:SS')   --L_reference_date
;
--EF_540/65R34TVZM45	1	07-01-2022 13:30:14	07-01-2022 00:00:00		700303	ENS	1	1	127	CRRNT QR4	CURRENT	09-10-2023 10:36:32
--EF_540/65R34TVZM45	1	07-01-2022 13:30:14	07-01-2022 00:00:00		700303	ENS	1	1	127	CRRNT QR4	CURRENT	09-10-2023 10:36:32 


, specList AS 

SELECT h2.part_no
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
/*
AF_380/85R24TR1318	2	08-04-2019 10:28:45						08-04-2019 00:00:00	125	CRRNT QR2	CURRENT		700303	0
AF_420/85R34TR1428	2	08-04-2019 10:31:09						08-04-2019 00:00:00	125	CRRNT QR2	CURRENT		700303	0
AF_460/85R34TR1478	1	08-04-2019 10:36:02						08-04-2019 00:00:00	125	CRRNT QR2	CURRENT		700303	0
AG_460/85R34TR1478	1	08-04-2019 10:33:09						08-04-2019 00:00:00	125	CRRNT QR2	CURRENT		700574	0
GF_2355018WPRXV		5	08-04-2019 11:11:28	27-05-2019 09:10:02	08-04-2019 00:00:00	5	HISTORIC	HISTORIC	700309	0
GV_2355018WPRXV		3	08-04-2019 11:11:17	27-05-2019 09:09:47	08-04-2019 00:00:00	5	HISTORIC	HISTORIC	700674	0
GG_235018WPRXV		3	08-04-2019 11:11:05	27-05-2019 09:09:34	08-04-2019 00:00:00	5	HISTORIC	HISTORIC	700554	0
GV_2155517WPRXV		1	12-04-2019 16:10:27	05-06-2019 15:04:18	12-04-2019 00:00:00	5	HISTORIC	HISTORIC	700674	0
GG_215517WPRXV		1	12-04-2019 16:10:16	05-06-2019 13:12:19	12-04-2019 00:00:00	5	HISTORIC	HISTORIC	700554	0
ETC
*/

, componentList AS 

SELECT h2.part_no
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
 WHERE h2.part_no NOT LIKE 'X%'      --NOT LIKE 'X%' 
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
 WHERE h2.part_no LIKE 'X%'       --LIKE 'X%'
 AND (  'DEFAULT' = 'HIGHEST' 
     OR h2.issued_date IS NOT NULL
	 )
/*
--TOTAAL: 313908 rijen...
AF_380/85R24TR1318	2	08-04-2019 10:28:45		08-04-2019 00:00:00	125	CRRNT QR2	CURRENT	700303	0
AF_420/85R34TR1428	2	08-04-2019 10:31:09		08-04-2019 00:00:00	125	CRRNT QR2	CURRENT	700303	0
AF_460/85R34TR1478	1	08-04-2019 10:36:02		08-04-2019 00:00:00	125	CRRNT QR2	CURRENT	700303	0
AG_460/85R34TR1478	1	08-04-2019 10:33:09		08-04-2019 00:00:00	125	CRRNT QR2	CURRENT	700574	0
GF_2355018WPRXV		5	08-04-2019 11:11:28	27-05-2019 09:10:02	08-04-2019 00:00:00	5	HISTORIC	HISTORIC	700309	0
--
XGS_SWBR050L		1	07-11-2023 12:36:41		07-11-2023 00:00:00	125	CRRNT QR2	CURRENT	700304	0
XGS_SWBR050R		1	07-11-2023 12:37:08		07-11-2023 00:00:00	125	CRRNT QR2	CURRENT	700304	0
XGG_GT5642002		1	07-11-2023 12:50:12	08-11-2023 08:43:32	07-11-2023 00:00:00	5	HISTORIC	HISTORIC	700935	0
XGL_ILRS468A		1	07-11-2023 12:48:23	07-11-2023 16:25:10	07-11-2023 00:00:00	5	HISTORIC	HISTORIC	700302	0
XGL_S468A			1	07-11-2023 12:44:41		07-11-2023 00:00:00	125	CRRNT QR2	CURRENT	700302	0
XGF_2958022RA2001	2	09-11-2023 11:57:43		09-11-2023 00:00:00	125	CRRNT QR2	CURRENT	700934	0
*/

, root_function AS 

SELECT sk.part_no
 ,      sk.kw_value
 FROM specification_kw sk
 JOIN itkw                 ON ( itkw.kw_id = sk.kw_id AND itkw.description = 'Function' )

/*
XEM_524_013			Compound
XEM_724_013			Compound
XET_PA10-122C		Tread
XET_PA10-122E		Tread
XET_PA10-122B		Tread
600830				Fabric
XET_PA10-122G		Tread
XET_PA10-122D		Tread
XET_PA10-122F		Tread
XEM_440_013			Compound
XEM_B09-513XN4_02	Compound
EB_13775AP56S		Bead
EB_13775AP66S		Bead
...
ETC
*/

, bom_function AS 
 SELECT f.characteristic_id
 ,      f.description
 FROM characteristic f
 JOIN characteristic_association ca ON ( ca.characteristic = f.characteristic_id AND ca.intl = f.intl )
 JOIN association                 a ON ( a.association = ca.association          AND a.intl = ca.intl )
 WHERE a.description = 'Function'

/*
903334	Vulcanized tyre
903345	Innerliner assembly
903347	Rim cushion compound
903346	Sidewall compound
903304	Innerliner
903330	Sidewall L
903331	Sidewall R
903348	Tread compound
903349	Innerliner compound
903350	Technical layer compound
903358	Chafer
...
etc
*/

, tree 
(    root_part, root_rev
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

SELECT p.part_no            AS root_part
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
 ,	CAST(sk.kw_value || '.' || f.description AS VARCHAR2(254)) AS breadcrumbs
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
 FROM partList p                --SELECTED-PART-NO USED FOR THE REPORT !!!!
 LEFT JOIN specification_kw sk on (sk.part_no = p.part_no)
 LEFT JOIN itkw                ON ( itkw.kw_id = sk.kw_id   AND itkw.description = 'Function' )
 LEFT JOIN bom_header   bh ON (bh.part_no = p.part_no   AND bh.revision = p.revision  AND bh.preferred = p.preferred )                                --SELECTED-PART-NO
 LEFT JOIN bom_item     bi ON ( bi.part_no = bh.part_no AND bi.revision = bh.revision AND bi.plant = bh.plant AND bi.alternative = bh.alternative )   --ALL ITEMS RELATED TO SELECTED-PART-NO
 LEFT JOIN specList     hh ON ( bi.component_part = hh.part_no  AND (  f_checkRefDate = 0                                                             --ALL COMPONENT-ITEMS RELATED TO SELECTED-PART-NO
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
 LEFT JOIN bom_function f ON (f.characteristic_id = bi.ch_1)                   --BOM-FUNCTION OF COMPONENT-ITEM
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
 FROM tree t                        --recursive cursor to ITSELF (START WITH SELECTED-PART-NO)
 JOIN bom_header bh ON ( bh.part_no	= t.part_no  AND bh.revision = t.revision  AND bh.plant	= t.plant  AND bh.preferred	= 1 AND bh.alternative	= 1 )  --FOC_NONE )    --BOM-HEADER OF SELECTED-PART-NO
 JOIN bom_item   bi ON ( bh.part_no	= bi.part_no AND bh.revision = bi.revision AND bh.plant	= bi.plant AND bh.alternative = bi.alternative )                    --BOM-ITEMS RELATED TO SELECTED-PART-NO
 LEFT JOIN componentList hh ON ( hh.part_no = bi.component_part AND (  f_checkRefDate = 0                                             --COMPONENT-LIST OF ALL BOM-ITEMS OF SELECTED-PART-NO
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
 AND hh.status_type IN ('HISTORIC', 'CURRENT')          --= 'FOC_NONE'
 AND t.lvl          <= FOC_NONE
 AND t.revision     IS NOT NULL
 AND t.function     IS NOT NULL 
 AND t.function     NOT LIKE '%FOC_NONE'
) CYCLE part_no SET e_cyclic TO '1' DEFAULT '0'                    --CYCLE tbv opbouwen TREE-structure !!!!!!!!!

/*
The cycle clause monitors selected columns of the result of a recursive query for recurring values. 
If the same values appear a second time, the cycle clause prevents following that path a second time. 
Thereby the cycle clause prevents infinite loops.

*/

select * 
from
(WITH BOM (part_no, revision, component_part) AS
(SELECT PART_NO, REVISION, COMPONENT_PART FROM BOM_ITEM BI WHERE bi.PART_NO ='EF_540/65R34TVZM45' AND bi.revision = (select max(sh.revision) from specification_header sh where sh.part_no=bi.part_no)
 UNION ALL
 select bi2.part_no, bi2.revision, bi2.component_part from BOM  join bom_item bi2 on BOM.component_part = BI2.part_no AND bi2.revision = (select max(sh2.revision) from specification_header sh2 where sh2.part_no=bi2.part_no)
) cycle part_no set is_loop to 'Y'  DEFAULT 'N' 
select * from BOM
)


 

/*
--peter test voor ROW_NUMBER-function !!!!!!!!
select part_no, revision, ROW_NUMBER() OVER (ORDER BY sh.part_no, sh.revision) -1
from specification_header sh
where part_no like 'EF%' 
ORDER BY sh.revision, sh.part_no
;

EF_125/90R15CLS	1	0
EF_155/70-15-SM	1	38
EF_165/80-17-SM	1	84
EF_175/55-19-SMS	1	167
...
*/

WITH templateBoM 
(   tpl_root_part
 ,  tpl_root_revision
 ,  tpl_root_description
 ,	tpl_part_no
 ,  tpl_revision
 ,	tpl_description
 ,	tpl_frame_id
 ,  tpl_frame_rev
 ,	tpl_item_number
 ,	hierarchy
 --,	function_description
 --,	function_code
 --,	functiongrp
 --,	mask
 ,	lvl
 ) AS 
(SELECT sh.part_no
 ,  sh.revision
 ,	sh.description
 ,	sh.part_no
 ,  sh.revision
 ,	sh.description
 ,	sh.frame_id
 ,  sh.frame_rev
 ,	1
 ,	'1'
 --,	(SELECT kw_value FROM root_function WHERE part_no = sh.part_no)
 --,	(SELECT kw_value FROM root_function WHERE part_no = sh.part_no)
 --,	(SELECT kw_value FROM root_function WHERE part_no = sh.part_no)
 --,	'%' || (SELECT kw_value FROM root_function WHERE part_no = sh.part_no)
 ,	0
 FROM specification_header sh
 JOIN status                s ON (s.status = sh.status)
 WHERE sh.part_no    = 'EF_540/65R34TVZM45'   --'NONE'
 AND   s.status_type = 'CURRENT'
 UNION ALL
 SELECT t.tpl_root_part
 ,  t.tpl_root_revision
 ,  t.tpl_root_description
 ,	bi.component_part
 ,	bish.revision
 ,	bish.description
 ,	bish.frame_id
 ,  bish.frame_rev
 ,	bi.item_number
 ,	'1.' || coalesce(bi.char_1, '0.' || to_char(bi.item_number, 'FM0999'))
 --,	bi.char_2
 --,	bic.description
 --,	bi.char_3
 --,	bi.char_4
 ,	t.lvl +1
 FROM templateBoM t
 JOIN bom_item                    bi ON (bi.part_no = t.tpl_part_no and bi.revision = t.tpl_revision)
 LEFT JOIN specification_header bish ON (bish.part_no = bi.component_part)
 LEFT JOIN status                bis ON (bis.status = bish.status)
 LEFT JOIN characteristic        bic ON (bic.characteristic_id = bi.ch_1)
 WHERE bis.status_type = 'CURRENT'
)
SELECT * FROM templateBoM;

--EF_540/65R34TVZM45	1	540/65R34 145D TRAXION65 RRO	EF_540/65R34TVZM45	1	540/65R34 145D TRAXION65 RRO	E_AT_RRO	1	1	1	0



--AANROEP TEMPLATE-BOM MET TEMPLATE-PART-NO SELECTED WITH TOP-FILTER OF REPORT:
WITH templateBoM 
(   tpl_root_part
 ,  tpl_root_revision
 ,  tpl_root_description
 ,	tpl_part_no
 ,  tpl_revision
 ,	tpl_description
 ,	tpl_frame_id
 ,  tpl_frame_rev
 ,	tpl_item_number
 ,	hierarchy
 --,	function_description
 --,	function_code
 --,	functiongrp
 --,	mask
 ,	lvl
 ) AS 
(SELECT sh.part_no
 ,  sh.revision
 ,	sh.description
 ,	sh.part_no
 ,  sh.revision
 ,	sh.description
 ,	sh.frame_id
 ,  sh.frame_rev
 ,	1
 ,	'1'
 --,	(SELECT kw_value FROM root_function WHERE part_no = sh.part_no)
 --,	(SELECT kw_value FROM root_function WHERE part_no = sh.part_no)
 --,	(SELECT kw_value FROM root_function WHERE part_no = sh.part_no)
 --,	'%' || (SELECT kw_value FROM root_function WHERE part_no = sh.part_no)
 ,	0
 FROM specification_header sh
 JOIN status                s ON (s.status = sh.status)
 WHERE sh.part_no    = 'ZZ_RnD_PCR_GTX'   --'NONE'
 AND   s.status_type = 'CURRENT'
 UNION ALL
 SELECT t.tpl_root_part
 ,  t.tpl_root_revision
 ,  t.tpl_root_description
 ,	bi.component_part
 ,	bish.revision
 ,	bish.description
 ,	bish.frame_id
 ,  bish.frame_rev
 ,	bi.item_number
 ,	'1.' || coalesce(bi.char_1, '0.' || to_char(bi.item_number, 'FM0999'))
 --,	bi.char_2
 --,	bic.description
 --,	bi.char_3
 --,	bi.char_4
 ,	t.lvl +1
 FROM templateBoM t
 JOIN bom_item                    bi ON (bi.part_no = t.tpl_part_no and bi.revision = t.tpl_revision)
 LEFT JOIN specification_header bish ON (bish.part_no = bi.component_part)
 LEFT JOIN status                bis ON (bis.status = bish.status)
 LEFT JOIN characteristic        bic ON (bic.characteristic_id = bi.ch_1)
 WHERE bis.status_type = 'CURRENT'
)
SELECT * FROM templateBoM;


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
 JOIN templateBoM tpl ON (tree.breadcrumbs LIKE tpl.mask)  -- 
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
 
 
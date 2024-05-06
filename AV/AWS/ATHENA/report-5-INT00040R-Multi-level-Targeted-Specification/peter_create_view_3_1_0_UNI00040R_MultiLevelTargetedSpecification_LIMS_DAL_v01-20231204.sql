--UNI00040R MULTI LEVEL TARGETED SPECIFICATION
--(athena: [product&proces development] + [specifications] + [multi-level targeted specifications]
--
--Create VIEWS MULTI-LEVEL-TARGET
--test-object: XGF_BF66A17J1   --only part-no + properties (no BOM-info + ASSEMBLY-properties)
--             XGV_BF66A17J1   --only part-no + properties (no BOM-info + assembly-properties)
--             XGG_BF66A17J1   --ALL: part-no + BOM-info + ASSEMBLY-properties + properties !!!!!
--
--             GF_1856015ULAXH --only part-no + properties (no BOM-info + assembly-properties)
--             GG_186015ULAXH  --ALL: part-no + BOM-info + ASSEMBLY-properties + properties !!!!!
--
--             EF_145/60-20-SM  --NO template aanwezig, REPORT crashed...
--             EV_145/60-20-SM  --NO template aanwezig, REPORT crashed...
--             EG_145/60-20-SM  --NO template aanwezig, REPORT crashed...

/*
ALTER VIEW sc_lims_dal.av_mlts_templates owner TO usr_eu_lims_dl_admin;

DROP VIEW sc_lims_dal.av_mlts_templates;
--
CREATE OR REPLACE VIEW sc_lims_dal.av_mlts_templates
AS 
SELECT DISTINCT d.h_part_no AS query_part_no
, d.h2_part_no AS header_part_no
, d.description AS "template"
FROM ( SELECT DISTINCT c.kw_part_no
       , c.h_part_no
	   , c.kw_id
	   , c.kw_value
	   , c.revision
	   , c.status
	   , c.p_part_no
	   , c.description
	   , h2.part_no AS h2_part_no
	   , h2.status AS h2_status
       FROM ( SELECT DISTINCT b.kw_part_no
	         , b.h_part_no
			 , b.kw_id
			 , b.kw_value
			 , b.revision
			 , b.status
			 , p.part_no AS p_part_no
			 , p.description
             FROM ( SELECT a.kw_part_no
			        , a.h_part_no
					, a.kw_id
					, a.kw_value
					, a.revision
					, a.status
                    FROM ( SELECT DISTINCT kw.part_no AS kw_part_no
					       , h.part_no AS h_part_no
						   , kw.kw_id
						   , kw.kw_value
						   , h.revision
						   , h.status
                           FROM specification_kw kw
						   ,    specification_header h   
						   WHERE kw.kw_value = h.frame_id
						 ) a
  				         ,     itkw "k"                    
						 WHERE "k".description = 'Frame for Athena perspective' 
						 AND "k".kw_id = a.kw_id
				  ) b
 				  , part p                      
            	  WHERE b.kw_part_no = p.part_no
			) c
            , specification_header h2     
			WHERE c.kw_part_no = h2.part_no
	 ) d
	 , status s  
WHERE s.status = d.h2_status 
AND s.status_type = 'CURRENT'
;

--
templateBoM 
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
 
*/  



--tbv. part-no-FILTER + 1st Section part-no-info 
DROP VIEW sc_lims_dal.av_mlts_partno;
--
CREATE OR REPLACE VIEW sc_lims_dal.av_mlts_partno
(part_no
,revision
,part_description
,issued_date
,planned_effective_date
,obsolescence_date
,class3_id
,approved_by
,preferred
,alternative
,plant
,status
,status_code
,status_type
) as
SELECT  H.part_no
 ,      H.revision
 ,      H.description  part_description
 ,	    H.issued_date  
 ,      H.planned_effective_date
 ,      H.obsolescence_date
 ,	    H.class3_id
 ,      U.forename||' '||u.last_name    AS APPROVED_BY
 ,      B.preferred
 ,      B.alternative
 ,      B.plant
 ,	    S.status
 ,      S.sort_desc AS status_code
 ,      S.status_type
 FROM sc_interspec_ens.specification_header H  
 JOIN sc_interspec_ens.status               S ON (S.status   = H.status)
 JOIN sc_interspec_ens.class3               C ON (C.class    = H.class3_id)
 JOIN sc_interspec_ens.itus                 u on (u.user_id  = h.last_modified_by)
 LEFT JOIN sc_interspec_ens.bom_header      B ON ( B.part_no = H.part_no AND B.revision = H.revision )
 WHERE S.status_type IN ('HISTORIC', 'CURRENT')
 --and   h.part_no = 'XGG_BF66A17J1'
 --AND   B.preferred	= 1
 AND   B.revision = ( SELECT MAX(sh.revision)
                      FROM specification_header  sh
                      JOIN status                 s on (s.status = sh.status)
                      WHERE sh.part_no           = H.part_no
                      AND   s.status_type IN ('HISTORIC', 'CURRENT')
                     )
;

--example WHERE-CLAUSE
--select * from sc_lims_dal.av_mlts_partno where part_no = 'XGG_BF66A17J1'
--and   preferred = 1

--tbv SECTION: BOM
DROP VIEW sc_lims_dal.av_mlts_partno_bom_items
--
CREATE OR REPLACE VIEW sc_lims_dal.av_mlts_partno_bom_items
( parent_part_no
,      parent_revision
,      parent_status
,      parent_status_type
,      parent_issued_date
,      obsolescence_date
,      preferred
,      alternative
,	   parent_quantity
,	   component_part_no
,      component_part_no_descr
,      characteristic_id
,      FUNCTION
,      component_revision
,      plant
,      item_number
,      quantity
,      uom
) 
AS
 SELECT bi.part_no                                            AS parent_part_no
 ,      bi.revision                                           AS parent_rev
 ,      sh.status                                             AS parent_status
 ,      s.status_type                                         AS parent_status_type
 ,      coalesce(sh.issued_date, sh.planned_effective_date)   AS parent_issued_date
 ,      sh.obsolescence_date
 ,      bh.preferred
 ,      bh.alternative
 ,	    bh.base_quantity        AS parent_quantity
 ,	    sh2.part_no             AS component_part_no
 ,      p.description           AS component_part_no_descr
 ,      bi.ch_1                 AS characteristic_id
 ,      ch.description          AS FUNCTION
 ,      sh2.revision            as component_revision
 ,      bi.plant
 ,      bi.item_number
 ,      bi.quantity
 ,      bi.uom
 FROM specification_header  SH  
 JOIN status                 S ON (S.status    = SH.status and S.status_type IN ('HISTORIC', 'CURRENT') )
 JOIN class3                 C ON (C.class     = SH.class3_id)
 JOIN bom_header            BH ON ( Bh.part_no = SH.part_no AND BH.revision = SH.revision )
 JOIN bom_item              bi ON ( bi.part_no = bh.part_no AND bi.revision = bh.revision AND bi.plant =  bh.plant AND bi.alternative = bh.alternative )                    --BOM-ITEMS RELATED TO SELECTED-PART-NO
 JOIN specification_header SH2 ON ( sh2.part_no = bi.component_part )
 JOIN part                   p on ( p.part_no   = sh.part_no )
 JOIN status                s2 ON ( s2.status   = sh2.status AND s2.status_type IN ('HISTORIC', 'CURRENT') )
 LEFT OUTER JOIN characteristic             ch ON ( ch.characteristic_id = bi.ch_1) 
 LEFT OUTER JOIN characteristic_association ca ON ( ca.characteristic    = ch.characteristic_id AND ca.intl = ch.intl )
 LEFT OUTER JOIN association                 a ON (  a.association       = ca.association       AND a.intl  = ca.intl AND a.description = 'Function' )
 WHERE SH.revision = ( SELECT MAX(sh3.revision)
                      FROM specification_header  sh3
                      JOIN status                 s3 on (s3.status = sh3.status)
                      WHERE sh3.part_no   = SH.part_no
                      AND   s3.status_type IN ('HISTORIC', 'CURRENT')
                      )
 --AND   bi.part_no = 'EF_W235/40R19QPEX'
 AND   SH2.revision = (select max(sh4.revision) 
                       from specification_header sh4 
					   JOIN status               s4 on s4.status = sh4.status 
					   WHERE sh4.part_no = bi.component_part    --sh2.part_no !!!!!!!!!!!!!
					   and   s4.status_type IN ('HISTORIC', 'CURRENT') 
					  )
 --ORDER by sh.part_no, bi.item_number 
;

--*******************************************************************************
--*******************************************************************************
--LET OP: IN SUBQUERY SH2.REVISION  ZIT EEN "BUG" IN REDSHIFT....
--        ALS IK HIER DE ALIAS-VERWIJZING SH2.PART_NO gebruik levert query (IN TEGENSTELLING TOT ORACLE WAAR HET WEL GOED GAAT) geen resultaat op !!!!!!
--        DUS ALTIJD DE BRON-TABEL BI.COMPONENT_PART GEBRUIKEN, DAN GAAT HET WEL GOED.
--*******************************************************************************
--*******************************************************************************


--part_no: EF_W235/40R19QPEX
--EV_BW235/40R19QPEX
--            EG_BW234019QPEX-G
--GR_9786

--test view
SELECT * FROM sc_lims_dal.av_mlts_partno_bom_items
WHERE parent_part_no = 'XGG_BF66A17J1'
and   preferred = 1
;

/*
XGG_BF66A17J1	2	125	CURRENT	15-02-2023 13:59:43		1	1	1	XGS_WBTV120TN	B-120 Thin GM_R5026/GM_Z5020	1	GYO	10	1.312	m	903394	Sidewall L/R
XGG_BF66A17J1	2	125	CURRENT	15-02-2023 13:59:43		1	1	1	XGL_LAQ1360F360N	LAQ1-360-F360 - GM_L2002 / GM_B1054	1	GYO	20	1.312	m	903345	Innerliner assembly
XGG_BF66A17J1	2	125	CURRENT	15-02-2023 13:59:43		1	1	1	XGR_WR01450085	RL01-45-85 Rayon Flipper	3	GYO	40	1	m	688	Flipper L
XGG_BF66A17J1	2	125	CURRENT	15-02-2023 13:59:43		1	1	1	XGR_WR01450085	RL01-45-85 Rayon Flipper	3	GYO	50	1	m	689	Flipper R
XGG_BF66A17J1	2	125	CURRENT	15-02-2023 13:59:43		1	1	1	XGR_PK08490L80	PK08-90-490 - Ply with XGX_L170 gum B1008	1	GYO	90	1.323	m	903320	Ply 1
XGG_BF66A17J1	2	125	CURRENT	15-02-2023 13:59:43		1	1	1	XGB_AH138700124543	17" 4-5-4-3 Filler 12mm A4012	1	GYO	110	2	pcs	903323	Bead apex
XGG_BF66A17J1	2	125	CURRENT	15-02-2023 13:59:43		1	1	1	XGR_GSA1327195	SA13-27-195 Top gum 0.5x20 (2x)	1	GYO	120	1.838	m	903316	Belt 1
XGG_BF66A17J1	2	125	CURRENT	15-02-2023 13:59:43		1	1	1	XGR_NSA1327185	SA13-27-185-No Gum	3	GYO	130	1.845	m	903317	Belt 2
XGG_BF66A17J1	2	125	CURRENT	15-02-2023 13:59:43		1	1	1	GR_NB01000012	NB01 Capstrip 12 mm	7	GYO	140	31.44	m	903372	Capstrip
XGG_BF66A17J1	2	125	CURRENT	15-02-2023 13:59:43		1	1	1	XGT_PSTBF66A17D2	TREAD BF66AS17 B220 SB190 GMST7022/T3008/T3030	4	GYO	150	1.857	m	903311	Tread
*/


/*
--base-query coming from ATHENA, but i cannot make this thing working on INTERSPEC/REDSHIFT. It doesn't work. It is too complex...
--After extracting all the meaningless-WITH-views in globa-query, I am getting an error on the fact that value NUM_1 + CHAR_5 are empty !!!
--The calculated-WEIGHT doesn't match te weight in INTERSPEC / bom_weight_component_part !!!!!!

CREATE OR REPLACE VIEW sc_lims_dal.av_mlts_partno_bom
(   root_part
,   root_rev
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
,	ch_1, ch_2
,	parent_quantity
,	normalized_quantity
,	component_volume, volume, normalized_volume
,	parent_volume
,	component_kg, assembly_kg
,	parent_kg
,	lvl	
,   step
,	path, pathNode
,	parent_branch, branch
,	breadcrumbs
,	reference_date
,	part_reference_date
,	e_issuedAfterExplDate
,	e_noPhantomRevision
) AS


select root_part
,   root_rev
,	root_status
,   root_status_type
,	root_preferred
,   root_alternative
,	root_issued_date
,	root_density
,	parent_part
,   parent_rev
,	parent_status
,   parent_status_type
,	parent_seq
,	parent_function
,   parent_uom
,	part_no
,   revision
,   plant
,   item_number
,	issued_date
,   obsolete_date
,	status, status_code, status_type
,	class3_id
,	function
,	preferred
,   alternative
,   base_quantity
,	phr
,   quantity
,   density
,   uom
,	ch_1, ch_2
,	parent_quantity
,	normalized_quantity
,	component_kg
,	lvl	
,   step
,	path
,   pathNode
,	parent_branch
,   branch
--,	breadcrumbs
FROM 

(

WITH tree 
(   root_part
,   root_rev
,	root_status
,   root_status_type
,	root_preferred
,   root_alternative
,	root_issued_date
,	root_density
,	parent_part
,   parent_rev
,	parent_status
,   parent_status_type
,	parent_seq
,	parent_function
,   parent_uom
,	part_no
,   revision
,   plant
,   item_number
,	issued_date
,   obsolete_date
,	status, status_code, status_type
,	class3_id
,	function
,	preferred
,   alternative
,   base_quantity
,	phr
,   quantity
,   density
,   uom
,	ch_1, ch_2
,	parent_quantity
,	normalized_quantity
,	component_kg
,	lvl	
,   step
,	path
,   pathNode
,	parent_branch
,   branch
--,	breadcrumbs
) as
(SELECT sh.part_no             AS root_part
 ,  sh.revision                AS root_rev
 ,	sh.status                  AS root_status
 ,  s.status_type             AS root_status_type
 ,	bh.preferred              AS root_preferred
 ,  bh.alternative            AS root_alternative
 ,	sh.issued_date             AS root_issued_date
 ,	bi.num_1                  AS root_density
 ,	sh.part_no                 AS parent_part
 ,  sh.revision                AS parent_rev
 ,	sh.status                  AS parent_status
 ,  s.status_type             AS parent_status_type
 ,	bi.item_number            AS parent_seq
 ,	NULL                      AS parent_function
 ,  NULL                      AS parent_uom
 ,	bi.component_part         AS part_no
 ,  sh2.revision
 ,  bi.plant
 ,  bi.item_number
 ,	coalesce(sh2.issued_date, sh2.planned_effective_date)  AS issued_date
 ,	sh2.obsolescence_date                                 AS obsolete_date
 ,	sh2.status
 ,  s2.sort_desc                                             AS status_code
 ,  s2.status_type
 ,	sh2.class3_id
 ,	ch.description                           AS function
 ,	bh.preferred
 ,  bh.alternative
 ,  bh.base_quantity
 ,	bi.num_5                                 AS phr
 ,  bi.quantity
 ,  bi.num_1                                 AS density
 ,  bi.uom
 ,	bi.ch_1, bi.ch_2
 ,	bh.base_quantity                            AS parent_quantity
 ,	bi.quantity * 1                             AS normalized_quantity
 ,	CASE WHEN bi.uom = 'kg' THEN bi.quantity * 1
                            ELSE NULL
    END                                                      AS component_kg
 ,	1                                                        AS lvl
 ,	ROW_NUMBER() OVER (ORDER BY bi.item_number) -1           AS STEP
 ,	CAST('0000' AS varchar2(120))                            AS path
 ,	to_char(bi.item_number, 'FM0999')                        AS pathNode
 ,	CAST('' AS VARCHAR2(100))                                AS parent_branch
 ,	CAST(to_char(bi.item_number, 'FM0999') AS varchar2(100)) AS branch
 FROM specification_header SH  
 JOIN status               S ON (S.status   = SH.status   AND s.status_type IN ('HISTORIC', 'CURRENT') )
 JOIN class3               C ON (C.class    = SH.class3_id)
 LEFT JOIN bom_header      Bh ON ( BH.part_no = SH.part_no AND BH.revision = SH.revision )
 LEFT JOIN bom_item     bi ON ( bi.part_no = bh.part_no AND bi.revision = bh.revision AND bi.plant = bh.plant AND bi.alternative = bh.alternative )   --ALL ITEMS RELATED TO SELECTED-PART-NO
 JOIN specification_header SH2 ON ( sh2.part_no = bi.component_part )
 --JOIN part                   p on ( p.part_no  = sh2.part_no )
 JOIN status                s2 ON ( s2.status  = sh2.status AND s2.status_type IN ('HISTORIC', 'CURRENT') )
 LEFT OUTER JOIN characteristic       ch ON ( ch.characteristic_id = bi.ch_1) 
 LEFT JOIN characteristic_association ca ON ( ca.characteristic    = ch.characteristic_id AND ca.intl = ch.intl )
 LEFT JOIN association                 a ON (  a.association       = ca.association       AND a.intl  = ca.intl  )
 WHERE sH.revision = ( SELECT MAX(sh3.revision)
                             FROM specification_header  sh3
                             JOIN status                 s3 on (s3.status = sh3.status)
                             WHERE sh3.part_no   = SH.part_no
                             AND   s3.status_type IN ('HISTORIC', 'CURRENT')
                            )
 AND   sH2.revision = ( SELECT MAX(sh4.revision)
                             FROM specification_header  sh4
                             JOIN status                 s4 on (s4.status = sh4.status)
                             WHERE sh4.part_no   = SH2.part_no
                             AND   s4.status_type IN ('HISTORIC', 'CURRENT')
                            )
 AND a.description = 'Function'								
 UNION ALL
 SELECT t.root_part
 ,  t.root_rev
 ,	t.root_status
 ,  t.root_status_type
 ,	t.root_preferred
 ,  t.root_alternative
 ,	t.root_issued_date
 ,	t.root_density
 ,	t.part_no         AS parent_part
 ,  t.revision        AS parent_rev
 ,	t.status          AS parent_status
 ,  t.status_type     AS parent_status_type
 ,	t.item_number     AS parent_seq
 ,	t.function        AS parent_function
 ,  t.uom             AS parent_uom
 ,	bi.component_part AS part_no
 ,  sh2.revision
 ,  t.plant
 ,  bi.item_number
 ,	sh2.issued_date
 ,  sh2.obsolescence_date AS obsolete_date
 ,	sh2.status
 ,  s2.sort_desc         AS status_code
 ,  s2.status_type
 ,	sh2.class3_id
 ,	ch.description          AS function
 ,	bh.preferred
 ,  bh.alternative
 ,  bh.base_quantity
 ,	bi.num_5                AS phr
 ,  bi.quantity
 ,  bi.num_1                AS density
 ,  bi.uom
 ,	bi.ch_1, bi.ch_2
 ,	bh.base_quantity                                                                        AS parent_quantity
 ,	DECODE(BH.base_quantity, 0, 0, bi.quantity * t.normalized_quantity / bh.base_quantity)	                                     AS normalized_quantity
 ,	CASE WHEN bi.uom = 'kg'  THEN DECODE(BH.base_quantity, 0, 0, bi.quantity * t.normalized_quantity / BH.base_quantity)
                               ELSE NULL
      END                                                                                                                        AS COMPONENT_KG
 ,	t.lvl +1									                          AS lvl
 ,	ROW_NUMBER() OVER (PARTITION BY t.branch ORDER BY bi.item_number) -1  as step
 ,	substr(t.path || '.' || t.pathNode, 1, 120)	                          AS path
 ,	to_char(bi.item_number, 'FM0999')			                          AS pathNode
 ,	t.branch									                          AS parent_branch
 ,	substr(t.branch || '.' || to_char(bi.item_number, 'FM0999'), 1, 100)  AS branch
 FROM tree t                        --recursive cursor to ITSELF (START WITH SELECTED-PART-NO)
 JOIN bom_header bh            ON ( bh.part_no	= t.part_no  AND bh.revision = t.revision  AND bh.plant	= t.plant  AND bh.preferred	= t.preferred AND bh.alternativE = 1 )  --FOC_NONE )    --BOM-HEADER OF SELECTED-PART-NO
 JOIN bom_item   bi            ON ( bi.part_no	= BH.part_no AND bi.revision = BH.revision AND bi.plant	= BH.plant AND bi.alternative = BH.alternative )          
 JOIN specification_header SH2 ON ( sh2.part_no = bi.component_part )
 --JOIN part                   p on ( p.part_no   = sh2.part_no  )
 JOIN status                s2 ON ( s2.status   = sh2.status AND s2.status_type IN ('HISTORIC', 'CURRENT') )
 LEFT OUTER JOIN characteristic             ch ON ( ch.characteristic_id = bi.ch_1) 
 LEFT JOIN characteristic_association ca ON ( ca.characteristic    = ch.characteristic_id AND ca.intl = ch.intl )
 LEFT JOIN association                 a ON (  a.association       = ca.association       AND a.intl  = ca.intl  )
 WHERE SH2.revision = (select max(sh4.revision) 
                       from specification_header sh4 
					   JOIN status               s4 on s4.status = sh4.status 
					   WHERE sh4.part_no = sh2.part_no 
					   and   s4.status_type IN ('HISTORIC', 'CURRENT') 
					  )
 AND a.description = 'Function'
 AND t.lvl          <= 1                                --level
) CYCLE part_no SET e_cyclic TO '1' DEFAULT '0'                    --CYCLE tbv opbouwen TREE-structure !!!!!!!!!
SELECT t.* from tree t 
where T.root_part = 'XGG_BF66A17J1'     
AND   T.preferred	= 1
ORDER BY LVL, PARENT_PART, ch_1
;

--root-part = 'XGG_BF66A17J1'
*/


/*
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	10			XGS_WBTV120TN	1	GYO	10	28-10-2021 09:53:44		125	CRRNT QR2	CURRENT	700304	Sidewall L/R	1	1	1		1.312		m	903394		1	1.312				1				1	0	0000	0010		0010	Greentyre.Sidewall L/R
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	10			XGS_WBTV120TN	1	GYO	10	28-10-2021 09:53:44		125	CRRNT QR2	CURRENT	700304	Sidewall L/R	1	1	1		1.312		m	903394		1	1.312				1				1	1	0000	0010		0010	Quatrac 3.Sidewall L/R
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	10			XGS_WBTV120TN	1	GYO	10	28-10-2021 09:53:44		125	CRRNT QR2	CURRENT	700304	Sidewall L/R	1	1	1		1.312		m	903394		1	1.312				1				1	2	0000	0010		0010	<Any>.Sidewall L/R
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	10			XGS_WBTV120TN	1	GYO	10	28-10-2021 09:53:44		125	CRRNT QR2	CURRENT	700304	Sidewall L/R	1	1	1		1.312		m	903394		1	1.312				1				1	3	0000	0010		0010	SFG (semi finished goods).Sidewall L/R

--XGS_WBTV120TN	1	GYO	1	20	GM_R5026		GYO	0.306	kg			100		0	0	L		N			1							1											903347						1	0	0	0	0	0	0	0		0
--XGS_WBTV120TN	1	GYO	1	30	GM_Z5020		GYO	0.396	kg			100		0	0	L		N			1							1											903346						1	0	0	0	0	0	0	0		0


XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	20			XGL_LAQ1360F360N	1	GYO	20	17-09-2021 09:52:16		125	CRRNT QR2	CURRENT	700302	Innerliner assembly	1	1	1		1.312		m	903345		1	1.312				1				1	4	0000	0020		0020	SFG (semi finished goods).Innerliner assembly
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	20			XGL_LAQ1360F360N	1	GYO	20	17-09-2021 09:52:16		125	CRRNT QR2	CURRENT	700302	Innerliner assembly	1	1	1		1.312		m	903345		1	1.312				1				1	5	0000	0020		0020	<Any>.Innerliner assembly
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	20			XGL_LAQ1360F360N	1	GYO	20	17-09-2021 09:52:16		125	CRRNT QR2	CURRENT	700302	Innerliner assembly	1	1	1		1.312		m	903345		1	1.312				1				1	6	0000	0020		0020	Quatrac 3.Innerliner assembly
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	20			XGL_LAQ1360F360N	1	GYO	20	17-09-2021 09:52:16		125	CRRNT QR2	CURRENT	700302	Innerliner assembly	1	1	1		1.312		m	903345		1	1.312				1				1	7	0000	0020		0020	Greentyre.Innerliner assembly
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	40			XGR_WR01450085	3	GYO	40	26-10-2022 10:53:22		125	CRRNT QR2	CURRENT	700302	Flipper L	1	1	1		1		m	688		1	1				1				1	8	0000	0040		0040	Greentyre.Flipper L
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	40			XGR_WR01450085	3	GYO	40	26-10-2022 10:53:22		125	CRRNT QR2	CURRENT	700302	Flipper L	1	1	1		1		m	688		1	1				1				1	9	0000	0040		0040	Quatrac 3.Flipper L
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	40			XGR_WR01450085	3	GYO	40	26-10-2022 10:53:22		125	CRRNT QR2	CURRENT	700302	Flipper L	1	1	1		1		m	688		1	1				1				1	10	0000	0040		0040	<Any>.Flipper L
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	40			XGR_WR01450085	3	GYO	40	26-10-2022 10:53:22		125	CRRNT QR2	CURRENT	700302	Flipper L	1	1	1		1		m	688		1	1				1				1	11	0000	0040		0040	SFG (semi finished goods).Flipper L
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	50			XGR_WR01450085	3	GYO	50	26-10-2022 10:53:22		125	CRRNT QR2	CURRENT	700302	Flipper R	1	1	1		1		m	689		1	1				1				1	12	0000	0050		0050	Greentyre.Flipper R
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	50			XGR_WR01450085	3	GYO	50	26-10-2022 10:53:22		125	CRRNT QR2	CURRENT	700302	Flipper R	1	1	1		1		m	689		1	1				1				1	13	0000	0050		0050	Quatrac 3.Flipper R
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	50			XGR_WR01450085	3	GYO	50	26-10-2022 10:53:22		125	CRRNT QR2	CURRENT	700302	Flipper R	1	1	1		1		m	689		1	1				1				1	14	0000	0050		0050	SFG (semi finished goods).Flipper R
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	50			XGR_WR01450085	3	GYO	50	26-10-2022 10:53:22		125	CRRNT QR2	CURRENT	700302	Flipper R	1	1	1		1		m	689		1	1				1				1	15	0000	0050		0050	<Any>.Flipper R
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	90			XGR_PK08490L80	1	GYO	90	12-10-2022 14:35:42		125	CRRNT QR2	CURRENT	700302	Ply 1	1	1	1		1.323		m	903320		1	1.323				1				1	16	0000	0090		0090	SFG (semi finished goods).Ply 1
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	90			XGR_PK08490L80	1	GYO	90	12-10-2022 14:35:42		125	CRRNT QR2	CURRENT	700302	Ply 1	1	1	1		1.323		m	903320		1	1.323				1				1	17	0000	0090		0090	Quatrac 3.Ply 1
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	90			XGR_PK08490L80	1	GYO	90	12-10-2022 14:35:42		125	CRRNT QR2	CURRENT	700302	Ply 1	1	1	1		1.323		m	903320		1	1.323				1				1	18	0000	0090		0090	<Any>.Ply 1
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	90			XGR_PK08490L80	1	GYO	90	12-10-2022 14:35:42		125	CRRNT QR2	CURRENT	700302	Ply 1	1	1	1		1.323		m	903320		1	1.323				1				1	19	0000	0090		0090	Greentyre.Ply 1
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	110			XGB_AH138700124543	1	GYO	110	10-05-2022 14:41:25		125	CRRNT QR2	CURRENT	700302	Bead apex	1	1	1		2		pcs	903323		1	2				1				1	20	0000	0110		0110	Quatrac 3.Bead apex
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	110			XGB_AH138700124543	1	GYO	110	10-05-2022 14:41:25		125	CRRNT QR2	CURRENT	700302	Bead apex	1	1	1		2		pcs	903323		1	2				1				1	21	0000	0110		0110	Greentyre.Bead apex
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	110			XGB_AH138700124543	1	GYO	110	10-05-2022 14:41:25		125	CRRNT QR2	CURRENT	700302	Bead apex	1	1	1		2		pcs	903323		1	2				1				1	22	0000	0110		0110	<Any>.Bead apex
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	110			XGB_AH138700124543	1	GYO	110	10-05-2022 14:41:25		125	CRRNT QR2	CURRENT	700302	Bead apex	1	1	1		2		pcs	903323		1	2				1				1	23	0000	0110		0110	SFG (semi finished goods).Bead apex
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	120			XGR_GSA1327195	1	GYO	120	15-08-2022 16:31:27		125	CRRNT QR2	CURRENT	700302	Belt 1	1	1	1		1.838		m	903316		1	1.838				1				1	24	0000	0120		0120	SFG (semi finished goods).Belt 1
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	120			XGR_GSA1327195	1	GYO	120	15-08-2022 16:31:27		125	CRRNT QR2	CURRENT	700302	Belt 1	1	1	1		1.838		m	903316		1	1.838				1				1	25	0000	0120		0120	<Any>.Belt 1
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	120			XGR_GSA1327195	1	GYO	120	15-08-2022 16:31:27		125	CRRNT QR2	CURRENT	700302	Belt 1	1	1	1		1.838		m	903316		1	1.838				1				1	26	0000	0120		0120	Quatrac 3.Belt 1
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	120			XGR_GSA1327195	1	GYO	120	15-08-2022 16:31:27		125	CRRNT QR2	CURRENT	700302	Belt 1	1	1	1		1.838		m	903316		1	1.838				1				1	27	0000	0120		0120	Greentyre.Belt 1
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	130			XGR_NSA1327185	3	GYO	130	26-11-2021 13:34:15		125	CRRNT QR2	CURRENT	700302	Belt 2	1	1	1		1.845		m	903317		1	1.845				1				1	28	0000	0130		0130	SFG (semi finished goods).Belt 2
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	130			XGR_NSA1327185	3	GYO	130	26-11-2021 13:34:15		125	CRRNT QR2	CURRENT	700302	Belt 2	1	1	1		1.845		m	903317		1	1.845				1				1	29	0000	0130		0130	<Any>.Belt 2
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	130			XGR_NSA1327185	3	GYO	130	26-11-2021 13:34:15		125	CRRNT QR2	CURRENT	700302	Belt 2	1	1	1		1.845		m	903317		1	1.845				1				1	30	0000	0130		0130	Quatrac 3.Belt 2
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	130			XGR_NSA1327185	3	GYO	130	26-11-2021 13:34:15		125	CRRNT QR2	CURRENT	700302	Belt 2	1	1	1		1.845		m	903317		1	1.845				1				1	31	0000	0130		0130	Greentyre.Belt 2
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	140			GR_NB01000012	7	GYO	140	29-06-2021 09:53:08		128	CRRNT QR5	CURRENT	700302	Capstrip	1	1	1		31.44		m	903372		1	31.44				1				1	32	0000	0140		0140	Quatrac 3.Capstrip
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	140			GR_NB01000012	7	GYO	140	29-06-2021 09:53:08		128	CRRNT QR5	CURRENT	700302	Capstrip	1	1	1		31.44		m	903372		1	31.44				1				1	33	0000	0140		0140	Greentyre.Capstrip
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	140			GR_NB01000012	7	GYO	140	29-06-2021 09:53:08		128	CRRNT QR5	CURRENT	700302	Capstrip	1	1	1		31.44		m	903372		1	31.44				1				1	34	0000	0140		0140	<Any>.Capstrip
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	140			GR_NB01000012	7	GYO	140	29-06-2021 09:53:08		128	CRRNT QR5	CURRENT	700302	Capstrip	1	1	1		31.44		m	903372		1	31.44				1				1	35	0000	0140		0140	SFG (semi finished goods).Capstrip
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	150			XGT_PSTBF66A17D2	4	GYO	150	12-10-2022 14:54:35		125	CRRNT QR2	CURRENT	700304	Tread	1	1	1		1.857		m	903311		1	1.857				1				1	36	0000	0150		0150	Greentyre.Tread
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	150			XGT_PSTBF66A17D2	4	GYO	150	12-10-2022 14:54:35		125	CRRNT QR2	CURRENT	700304	Tread	1	1	1		1.857		m	903311		1	1.857				1				1	37	0000	0150		0150	Quatrac 3.Tread
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	150			XGT_PSTBF66A17D2	4	GYO	150	12-10-2022 14:54:35		125	CRRNT QR2	CURRENT	700304	Tread	1	1	1		1.857		m	903311		1	1.857				1				1	38	0000	0150		0150	<Any>.Tread
XGG_BF66A17J1	2	125	CURRENT	1	1	15-02-2023 13:59:43		XGG_BF66A17J1	2	125	CURRENT	150			XGT_PSTBF66A17D2	4	GYO	150	12-10-2022 14:54:35		125	CRRNT QR2	CURRENT	700304	Tread	1	1	1		1.857		m	903311		1	1.857				1				1	39	0000	0150		0150	SFG (semi finished goods).Tread
*/


--PROPERTIES
DROP VIEW sc_lims_dal.av_mlts_partno_properties;
--
CREATE OR REPLACE VIEW sc_lims_dal.av_mlts_partno_properties
(part_no
,revision
,plant
,preferred
,alternative
,status
,frame_id
,section_id
,section_descr
,SUB_section_id
,subsection_descr
,property_group
,pg_descr
,property
,p_descr
,type
,ref_id
,header_id
,field_id
,display_format
,layout_descr
,header_descr
,uom_id 
,uom_descr
,attribute
,attribute_descr
,test_method
,test_method_descr
,characteristic
,ch_1_descr
,ch_2
,ch_2_descr
,ch_3
,ch_3_descr
)
as
select sh.part_no
,      sh.revision
,      bh.plant
,      bh.preferred
,      bh.alternative
,      sh.status
,      sh.frame_id
,      sp.section_id
,      s.description     AS  section_descr
,      sp.SUB_section_id
,      ss.description    AS  subsection_descr
,      sp.property_group
,      pg.description    AS  pg_descr
,      sp.property
,      p.description     AS  p_descr
,      sps.type
,      sps.ref_id
,      h.header_id
,      pl.field_id
,      sps.display_format
,      l.description    AS  layout_descr
,      h.description    AS  header_descr
,      sp.uom_id 
,	   u.description    AS uom_descr
,      sp.attribute
,	   a.description    AS attribute_descr
,      sp.test_method
,	   tm.description   AS test_method_descr
,      sp.characteristic
,      c.description    AS ch_1_descr
,      sp.ch_2
,	   c2.description   AS ch_2_descr
,      sp.ch_3
,	   c3.description   AS ch_3_descr
,      CASE when pl.field_id = 1  then 'Num_1'
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
,      CASE when pl.field_id = 1  then cast(sp.Num_1 as varchar(30) )
            when pl.field_id = 2  then cast(sp.Num_2 as varchar(30) )
            when pl.field_id = 3  then cast(sp.Num_3 as varchar(30) )
            when pl.field_id = 4  then cast(sp.Num_4 as varchar(30) )
            when pl.field_id = 5  then cast(sp.Num_5 as varchar(30) )
            when pl.field_id = 6  then cast(sp.Num_6 as varchar(30) )
            when pl.field_id = 7  then cast(sp.Num_7 as varchar(30) )
            when pl.field_id = 8  then cast(sp.Num_8 as varchar(30) )
            when pl.field_id = 9  then cast(sp.Num_9 as varchar(30) )
            when pl.field_id = 10  then cast(sp.Num_10 as varchar(30) )
            when pl.field_id = 11 then sp.Char_1
            when pl.field_id = 12 then sp.Char_2
            when pl.field_id = 13 then sp.Char_3
            when pl.field_id = 14 then sp.Char_4
            when pl.field_id = 15 then sp.Char_5
            when pl.field_id = 16 then sp.Char_6
            when pl.field_id = 17 then sp.Boolean_1
            when pl.field_id = 18 then sp.Boolean_2
            when pl.field_id = 19 then sp.Boolean_3
            when pl.field_id = 20 then sp.Boolean_4
            when pl.field_id = 21 then to_char(sp.Date_1, 'dd-mm-yyyy hh24:mi:ss')
            when pl.field_id = 22 then to_char(sp.Date_2, 'dd-mm-yyyy hh24:mi:ss')
            when pl.field_id = 23 then cast(sp.UOM_id         as varchar(30) )
            when pl.field_id = 24 then cast(sp.Attribute      as varchar(30) )
            when pl.field_id = 25 then cast(sp.Test_method    as varchar(30) )
            when pl.field_id = 26 then cast(sp.Characteristic as varchar(30) )
            when pl.field_id = 27 then cast(sp.Property       as varchar(30) )
            when pl.field_id = 30 then cast(sp.Ch_2           as varchar(30) ) 
            when pl.field_id = 31 then cast(sp.Ch_3           as varchar(30) )
            when pl.field_id = 32 then sp.Tm_det_1
            when pl.field_id = 33 then sp.Tm_det_2
            when pl.field_id = 34 then sp.Tm_det_3
            when pl.field_id = 35 then sp.Tm_det_4
            when pl.field_id = 40 then sp.Info  
            else 'NULL'
       END db_field_value
from sc_interspec_ens.specification_header      sh
JOIN sc_interspec_ens.status                    st   on ( st.status    = sh.status )
JOIN sc_interspec_ens.bom_header                bh   on ( bh.part_no   = sh.part_no  and bh.revision = sh.revision )
JOIN sc_interspec_ens.specification_prop        sp   on ( sp.part_no   = sh.part_no  and sh.revision = sp.revision )
join sc_interspec_ens.specification_section     sps  on ( sps.part_no  = sp.part_no  and sps.revision = sp.revision and  sps.section_id  = sp.section_id  and sps.sub_section_id = sp.sub_section_id  )
JOIN sc_interspec_ens.layout                    l    ON ( l.layout_id  = sps.display_format and l.revision = sps.display_format_rev AND l.status = 2)
JOIN sc_interspec_ens.property_layout           pl   ON ( pl.layout_id = l.layout_id        and pl.revision = l.revision )
join sc_interspec_ens.header                    h    on ( h.header_id  = pl.header_id )
JOIN sc_interspec_ens.SECTION                   s    ON ( s.section_id        = sp.section_id )
JOIN sc_interspec_ens.SUB_SECTION               ss   on ( ss.sub_section_id   = sp.sub_section_id )
JOIN sc_interspec_ens.PROPERTY_GROUP            pg   ON ( pg.property_GROUP   = sp.property_group )
JOIN sc_interspec_ens.PROPERTY                  p    on ( p.property          = sp.property )
LEFT JOIN sc_interspec_ens.uom             u ON (pl.field_id = 23 AND u.uom_id             = sp.uom_id)
LEFT JOIN sc_interspec_ens.attribute       a ON (pl.field_id = 24 AND a.attribute          = sp.attribute)
LEFT JOIN sc_interspec_ens.test_method    tm ON (pl.field_id = 25 AND tm.test_method       = sp.test_method)
LEFT JOIN sc_interspec_ens.characteristic c  ON (pl.field_id = 26 AND c.characteristic_id  = sp.characteristic)
LEFT JOIN sc_interspec_ens.characteristic c2 ON (pl.field_id = 30 AND c2.characteristic_id = sp.ch_2)
LEFT JOIN sc_interspec_ens.characteristic c3 ON (pl.field_id = 31 AND c3.characteristic_id = sp.ch_3)
WHERE   NOT (  (  pl.field_id = 27  
               AND UPPER(h.description) = 'PROPERTY' )  --or (  pl.field_id = 23  )
            )	
--relatie is essentieel voor het bepalen van juiste display-format bij een property/group:			
AND    (  ( sps.type = 1 and sps.ref_id = sp.property_group )
       or ( sps.type = 4 and sps.ref_id = sp.property )
       )
--and   FS.FRAME_NO       = SH.FRAME_ID
--AND   SH.FRAME_ID like 'A_PCR_GT v1' 
--AND   SPS.SECTION_ID=701058
--and   SH.part_no = 'XGG_BF66A17J1' 
--and p.description like 'Side ring%'
--and   sp.part_no = 'XGG_BF66A17J1' 	
AND   st.status_type IN ('HISTORIC', 'CURRENT') 
and   sp.revision = (select max(sh2.revision) from sc_interspec_ens.specification_header sh2 where sh2.part_no = sp.part_no)
--order by  SH.part_no, SH.frame_id, SP.section_id, SP.sub_section_id, SP.property_group, SP.property
;


--example WHERE-CLAUSE
-- select * from sc_lims_dal.av_mlts_partno_properties  where part_no = 'XGG_BF66A17J1'
--select * from sc_lims_dal.av_mlts_partno_properties  where part_no = 'XGG_BF66A17J1' and p_descr like 'Side ring%'
--More than 1x DISPLAY-FORMAT. WHICH ONE SHOULD WE USE....


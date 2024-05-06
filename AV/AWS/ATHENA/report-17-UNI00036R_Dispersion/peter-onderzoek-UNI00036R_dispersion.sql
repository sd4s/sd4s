--Report name : UNI00036R_dispersion	
--Called from: UNI00403R_execution	execution-dashboard
--					"UNI00403R1_requests	"	request-to-execute
--						UNI00403R31	method-details
--							field: part-no
--
--view_2_1_1_3_1_partno_dispersion.sql

--TEST PART-NO = 'EF_Y275/30R20WPRX' 


--select BOM for part-no  INCL. RAW-MATERIALS

--TEST-QUERY
select * 
from  sc_lims_dal.av_reqov_bom_explosion_parts
where root_part = 'EF_Y275/30R20WPRX'   --'XGF_AU336S18L1'    
;

select * 
from  sc_lims_dal.av_reqov_bom_explosion_parts_NW
where root_part = 'EF_Y275/30R20WPRX'   --'XGF_AU336S18L1'    
order by path
;





--***************************************************************************************************************************
--LET OP: report used coming from EXECUTION-DASHBOARD, BUT also coming directly from MAIN-MENU: DISPERSION !!!!!!!!!!!!!!!!!!
--***************************************************************************************************************************

-* File UNI00036R_dispersion.fex
-SET &TODAY = EDIT(&YYMD, '9999/99/99 00:00:00');
 
-DEFAULT &PART_NO			= 'NONE';
-DEFAULT &PART_NO0			= 1;
-DEFAULT &EXPLOSION_DATE	= &TODAY.EVAL;
-DEFAULT &BOM_TYPE			= DISPERSION;
-DEFAULT &IMPORT_ID			= '';
 
-DEFAULT &WFFMT				= HTML;
-DEFAULT &TPFMT				= 'D12.3SC';
-DEFAULT &ALLOW_DEV			= 0;
-DEFAULTH &_PART_NO			= FOC_NONE;
-DEFAULTH &_PART_NO0		= 1;
-SET &PREFERRED		= 1;
 
-SET &PART_NO = IF &_PART_NO NE FOC_NONE THEN &_PART_NO ELSE &PART_NO;
-SET &PART_NO0 = IF &_PART_NO NE FOC_NONE THEN &_PART_NO0 ELSE &PART_NO0;
-SET &_EXPLOSION_DATE = &EXPLOSION_DATE;
 
-SET &LIMIT_ON = IF &ALLOW_DEV GT 0 THEN 'HIGHEST' ELSE 'LOWEST';
 
-*-SET &ECHO = ON;
-*-SET &ECHO_BOM = ON;
 
-*$ Standard tree explosion
-SET &BOM_TREE	= IF &BOM_TYPE EQ 'TREE' THEN '' ELSE '-*';
-*$ Raw materials only (summed)
-SET &BOM_RAW		= IF &BOM_TYPE EQ 'RAW_MATERIALS' THEN '' ELSE '-*';
 
-* Footer
-SET &FOOTERTYPE = 'LINE';
-SET &REPORTNAME = &FOCFEXNAME;
-SET &REPORTREVISION = '$Revision: 7f418736956d $';
-SET &REPORTOWNER = 'Benthem, H. van';
-*-SET &REPORTWIKI = 'XXX';
-SET &FORMAT = IF &BOM_TYPE EQ 'DISPERSION' THEN XLSX ELSE &WFFMT;
-INCLUDE GEN00003_rtvFooter
 
-SET &REPORTCODE = 'UNI00036';
 
-INCLUDE UNI00020P_initauth
-INCLUDE UNI00020P_Config
 
 
SET ASNAMES = ON
SET HOLDLIST = PRINTONLY
SET ERROROUT = OFF
 
SET CDN = SPACE
SET ACROSSTITLE = SIDE
 
SET EXCELSERVURL = ''
-RUN
 
-INCLUDE UNI00036P_Config
 
-* Initialization for Excel template
-SET &TEMPLATE_IN	= 'unilab/sheets/' || &TEMPLATE || &TEMPLATE_EXT;
-SET &TEMPLATE_OUT	= 'UNI00036H1';


-INCLUDE UNI00020P_bundleParts
-INCLUDE UNI00020R_partBOM_explosion
-* BEWARE! This is a GENERAL BoM procedure.
-* It is used in various sections of the Request Overview and Results,
-* with varying output formats and selection requirements.
-*

BY ROOT_PART	AS 'Compound'
BY IMPORTID		AS 'Import ID'
BY PRD_DATE		AS 'Production date'
-* List of specs at the correct explosion date for the type of spec (trial or production)
-* Provides tables:
-*	partList	: raw list of part-no + (sample) explosion dates
-*	specs		: list of specs at their relevant revision
   UNI00020P_WITH_partList
 

/*
COMPUTE ROOT_REV/I10 = ROOT_REV;	NOPRINT
 
&BOM_TREE.EVAL	COMPUTE TREEPART_NO/A160V = INDENTSTR || INDENTSTR || PART_NO; AS 'Part-no.'
	REVISION							AS 'Rev.'
	PART_DESCRIPTION					AS 'Description'
 
	PHR									AS 'PHR,'
	DENSITY								AS 'Density,(kg/l)'
	QUANTITY							AS 'Quantity,'
	UOM									AS ''
 
	INGREDIENT_VOLUME					AS 'Vol,(l)'
	VOLPCT								AS 'Vol%,'
 
	SPEC_TYPE							AS 'Specification,type'	NOPRINT
 
	COMPUTE CHILDPATH/A292V = IF (LAST PATH EQ '')
				 OR (LAST ROOT_PART NE ROOT_PART)
				 OR (LAST ALTERNATIVE NE ALTERNATIVE)
			THEN PATH
			ELSE IF (LAST PATH GT PATH) THEN LAST PATH
			ELSE LAST CHILDPATH;
		NOPRINT
 
	COMPUTE IS_LEAF/I3 = IF (LAST ROOT_PART NE ROOT_PART)
			  OR (LAST ALTERNATIVE NE ALTERNATIVE)
			  OR (PATH || ':' || PATHNODE NE CHILDPATH)
			THEN 1
			ELSE 0;
		NOPRINT
*/

		
--UNI00020P_BUNDLEPARTS

/*
REQUEST_CODE:        EGT2347104M 
SAMPLE_CODE:         EGT2347104M01
PART-NO:             XEM_B18-1164_46
*/


--* Determine production date or closest match for each sample part
/*
SELECT part_no
,	  to_char(coalesce(  to_date('&REFERENCE_DATE', '&FMT_TIMESTAMP'), date3, exec_start_date, creation_date )	, '&FMT_TIMESTAMP' ) AS checkin_date
FROM uvsc            S
JOIN uvscgkpart_no   P ON (P.sc = S.sc)
JOIN uvscgkspec_type T ON (T.sc = S.sc AND T.spec_type = '&SPEC_TYPE')
WHERE S.sc IN ('', INCLUDE H&BUNDLE  )
AND   P.part_no = '&PART_NO'
;
*/

SELECT sc.sc   as sample_code
,     pn.part_no
,     to_char(date3, 'dd-mm-yyyy hh24:mi:ss' )   as date3
,     to_char(exec_start_date, 'dd-mm-yyyy hh24:mi:ss' )  as exec_start_date
,     to_char(creation_date, 'dd-mm-yyyy hh24:mi:ss' )    as creation_date
,	  to_char(coalesce(   sc.date3, sc.exec_start_date, sc.creation_date )	, 'dd-mm-yyyy hh24:mi:ss' ) AS checkin_date
FROM utsc            sc
JOIN utscgkpart_no   pn ON (pn.sc = sc.sc)
--JOIN uvscgkspec_type st ON (st.sc = st.sc)
WHERE sc.sc IN ('EGT2347104M01')
AND   pn.part_no = 'XEM_B18-1164_46'
;
--sc			part-no			date3	exec_start_date			creation_date			checkin-date
--EGT2347104M01	XEM_B18-1164_46			29-11-2023 12:18:41		23-11-2023 16:02:30		29-11-2023 12:18:41
--CONCLUSIE: EXEC_START_DATE is leidend in dit geval !!!!



--* Use the sample date as reference-date, do not use the DEFAULT scenario
--SET &F_REFERENCE_DATE = 1;
-SET &PARTS_FILE = INTERSPEC_PARTS;
 
 
--INCLUDE UNI00020R_partBOM_explosion
DEFAULTH &ECHO_BOM			= OFF;
 
-IF &TOP_SCENARIO.EXISTS THEN GOTO :SKPDFLT;
-DEFAULTH &TOP_SCENARIO		= DEFAULT;
-DEFAULTH &PROD_SCENARIO	= DEFAULT;
-DEFAULTH &TRIAL_SCENARIO	= DEFAULT;
 
-DEFAULTH &ALTERNATIVE		= FOC_NONE;
-DEFAULTH &PREFERRED			= FOC_NONE;
-:SKPDFLT
 
-DEFAULTH &PARTLIST			= FOC_NONE;
-DEFAULTH &BUNDLE			= FOC_NONE;
 
-DEFAULT &_PART_NO			= 'NONE';
-DEFAULTH &_PART_NO0		= 1;
-DEFAULT &_REVISION			= '0';
 
-DEFAULT &REFERENCE_DATE	= &TODAY.EVAL;
-DEFAULTH &REFERENCE_DATE0	= 1;
 
-DEFAULTH &PARENT_BRANCH	= FOC_NONE;
-DEFAULTH &FUNCTION			= FOC_NONE;
-DEFAULTH &PARENT_FUNCTION	= FOC_NONE;
-DEFAULTH &MAXLEVEL			= FOC_NONE;
 
-DEFAULT &BOM_TYPE			= RAW_MATERIALS;
-DEFAULT &DEV				= 0;
-DEFAULT &PLANT				= FOC_NONE;
-DEFAULTH &BASE_QUANTITY	= 1;
 
-DEFAULT &WFFMT				= HTML;
-DEFAULT &TPFMT				= 'D12.3SC';
 
-DEFAULT &INDENTSTR			= '';
-DEFAULTH &BOM_TOP			= 0;
 
-* Deprecated flag
-DEFAULTH &ALLOW_DEV		= 0;
 
-*
-* Behaviour control parameters
-*
 
-* Reference date for explosion
-DEFAULTH &REFERENCE_DATE	= FOC_NONE;
 
 
-SET &ECHO_PRIME = &ECHO;
-SET &ECHO = IF &ECHO_BOM EQ ECHO THEN &ECHO ELSE &ECHO_BOM;
-TYPE Scenario: Top: &TOP_SCENARIO , Production components: &PROD_SCENARIO , Trial components: &TRIAL_SCENARIO
 
-*$ Standard tree explosion
-SET &BOM_TREE	= IF &BOM_TYPE EQ TREE THEN '' ELSE '-*';
-*$ Raw materials only (summed)
-SET &BOM_RAW	= IF &BOM_TYPE EQ RAW_MATERIALS THEN '' ELSE '-*';
 
-* Prefer current or dev specs?
-*-SET &CURR_DEV		= IF &DEV GT 0 THEN 'HIGHEST' ELSE 'LOWEST';
-SET &BOM_TOP_DUMMY		= IF &BOM_TOP EQ 0 THEN '' ELSE '''0'' AS ';
-SET &BOM_CYCLE_CHECK	= IF &BOM_TOP EQ 0 THEN 'CYCLE part_no SET e_cyclic TO ''1'' DEFAULT ''0''' ELSE '';
-SET &BOM_FULL_CYCLE	= IF &BOM_TOP EQ 0 THEN ', e_cyclic' ELSE '';
 
-SET &ALTERNATIVE		= IF &PREFERRED EQ 1 THEN FOC_NONE ELSE &ALTERNATIVE;
-SET &BOM_ALT_FIELD		= IF &PREFERRED EQ 1 THEN preferred
-							ELSE IF &ALTERNATIVE NE FOC_NONE THEN alternative
-							ELSE FOC_NONE;
 
-*SET ERROROUT = OFF
-*SET XRETRIEVAL = OFF
-**
-** Generate BoM explosions for multiple parts at a single explosion date
-** Of note:
-** -	Components in BOM_ITEM have so-called phantom revisions. To determine the correct revision of a component
-**		we select the component that is in effect at the explosion date.
-**
-** -	For DEVELOPMENT (top-level) specs, provided that they are "trial specs" (part_no LIKE 'X%'), we ignore
-**		HISTORIC revisions of components. Only CURRENT and DEVELOPMENT revisions are acceptable in that case.
-**		For non-DEVELOPMENT specs it does not matter whether a spec is a trial spec or not.
-**
-** -	To maintain the hierarchical structure of a BoM explosion, we generate fields with all a components
-**		ancestors concatenated. This is used for sorting the tree correctly, among other things.
-**
-** -	Component quantities, volumes and costs are recomputed based on the quantity of components in their
-**		parent spec.
-**
-** -	The query can perform some simple unit of measurement scale conversions (g to kg, for example)

-* List of specs at the correct explosion date for the type of spec (trial or production)
-* Provides tables:
-*	partList	: raw list of part-nos + (sample) explosion dates
-*	specs		: list of specs at their relevant revision
 
 
 
--INCLUDE UNI00020P_WITH_partList

--* Which revisions are desired?
--*	DEFAULT: Use CURRENT at root and for Trial components, use NOW for Production components
--*	HIGHEST: Use Highest available revision throughout the BoM (implies f_preferDev)
--*	REFDATE: Use revisions valid at REFDATE
--DEFAULT &I_SPEC_TYPE	= FOC_NONE;
--SET &SCN_HIGHEST_STATUSLIST	= '''HISTORIC'', ''CURRENT'', ''APPROVED'', ''SUBMIT'', ''DEVELOPMENT''';
--SET &SCN_DEFAULT_STATUSLIST	= '''HISTORIC'', ''CURRENT''';

--INCLUDE UNI00020P_bundlePartsSQL

WITH partList AS (
SELECT 'XEM_B18-1164_46' AS part_no
,      to_date('29-11-2023 12:18:41','dd-mm-yyyy hh24:mi:ss') AS default_reference_date 
FROM dual
)
, specs AS (
	SELECT
		H.part_no, H.revision, H.description AS part
	,	H.frame_id, H.frame_rev, H.created_by
	,	H.planned_effective_date, H.issued_date, H.obsolescence_date
	,	H.class3_id
	,	B.alternative, B.preferred
	,	S.status, S.sort_desc AS status_code, S.description AS status_desc, S.status_type
	,	L.default_reference_date AS reference_date
	  FROM specification_header H
	  JOIN partList L ON (H.part_no = L.part_no)
	  JOIN status S ON (S.status = H.status)
	  LEFT JOIN bom_header B ON (
	  		B.part_no = H.part_no
		AND B.revision = H.revision
	  )
	 WHERE S.status_type IN (&PART_STATUSLIST)
	   AND B.preferred = &PREFERRED
	   AND B.alternative = &ALTERNATIVE
-* Determine highest relevant (existing) revision
-IF &TOP_SCENARIO EQ 'REFDATE' THEN GOTO :TOPREFDATE;
	   AND NOT EXISTS (
			 	SELECT 1
				  FROM specification_header
				  JOIN status USING (status)
				 WHERE part_no = H.part_no
				   AND revision > H.revision
				   AND status_type IN (&PART_STATUSLIST)
		)
-:TOPREFDATE
-* We do NOT prefer DEV
		AND	(
			&TOP_SCENARIO.QUOTEDSTRING <> 'REFDATE'
		 OR (
-* We force an explosion on a reference date, revision must be valid on reference date
		 		&TOP_SCENARIO.QUOTEDSTRING = 'REFDATE'
			AND	L.default_reference_date >= coalesce(H.issued_date, H.planned_effective_date)
			AND (H.obsolescence_date IS NULL OR L.default_reference_date < H.obsolescence_date)
		 )
		)
		AND EXISTS (SELECT 1 FROM class3 C WHERE C.class = H.class3_id AND C.sort_desc = '&I_SPEC_TYPE')
 
	 GROUP BY
	 	H.part_no, H.revision, H.description
	,	H.planned_effective_date, H.issued_date, H.obsolescence_date
	,	H.frame_id, H.frame_rev, H.created_by
	,	H.class3_id
	,	B.alternative, B.preferred
	,	S.status, S.sort_desc, S.description, S.status_type
	,	L.default_reference_date
)






 
-* Top specifications filtered by scenario
, specList AS (
	SELECT
		h2.part_no, h2.revision
	,	h2.issued_date, h2.obsolescence_date, h2.planned_effective_date
	,	h2.status, s2.sort_desc AS status_code, s2.status_type
	,	h2.class3_id
	,	CASE WHEN '&TOP_SCENARIO' = 'REFDATE' THEN 1 ELSE 0 END AS f_checkRefDate
 
	  FROM specification_header h2
	  JOIN status s2 ON (
			s2.status = h2.status
		AND status_type IN (&PART_STATUSLIST)
	  )
	  WHERE ('&TOP_SCENARIO' = 'HIGHEST' OR h2.issued_date IS NOT NULL)
)
 
-* Component specifications filtered according to selected scenario
, componentList AS (
-*	Production specs
	SELECT
		h2.part_no, h2.revision
	,	h2.issued_date, h2.obsolescence_date, h2.planned_effective_date
	,	h2.status, s2.sort_desc AS status_code, s2.status_type
	,	h2.class3_id
	,	CASE WHEN '&PROD_SCENARIO' = 'REFDATE' THEN 1 ELSE 0 END AS f_checkRefDate
 
	  FROM specification_header h2
	  JOIN status s2 ON (
			s2.status = h2.status
		AND status_type IN (&PROD_STATUSLIST)
	  )
	  WHERE h2.part_no NOT LIKE 'X%'
	    AND ('&PROD_SCENARIO' = 'HIGHEST' OR h2.issued_date IS NOT NULL)
 
	UNION ALL
 
-*	Trial specs
	SELECT
		h2.part_no, h2.revision
	,	h2.issued_date, h2.obsolescence_date, h2.planned_effective_date
	,	h2.status, s2.sort_desc AS status_code, s2.status_type
	,	h2.class3_id
	,	CASE WHEN '&TRIAL_SCENARIO' = 'REFDATE' THEN 1 ELSE 0 END AS f_checkRefDate
 
	  FROM specification_header h2
	  JOIN status s2 ON (
			s2.status = h2.status
		AND status_type IN (&TRIAL_STATUSLIST)
	  )
	  WHERE h2.part_no LIKE 'X%'
	    AND ('&TRIAL_SCENARIO' = 'HIGHEST' OR h2.issued_date IS NOT NULL)
)
-*
-* Hierarchical list based on above parts (this is a so-called "recursive CTE"; SQL92 standard)
-*
 
-* CTE field list
, tree (
-*		Current node
		part_no, revision, plant, item_number
	,	status, status_code, status_type
	,	class3_id
 
-*		Parent fields
	,	parent_part, parent_rev
	,	parent_status, parent_status_type
 
-*		Part details
	,	alternative, preferred
	,	phr, quantity, density, root_density, uom
	,	num_1, num_2, num_3, num_4, num_5
	,	char_1, char_2, char_3, char_4, char_5
	,	date_1, date_2
	,	boolean_1, boolean_2, boolean_3, boolean_4
	,	ch_1, ch_2
	,	issued_date, obsolete_date
 
-*		Root node
	,	root_part, root_rev
	,	root_status, root_status_type
	,	root_alternative, root_preferred
	,	root_issued_date
	,	root_reference_date
 
-*		BoM Explosion behaviour
	,	reference_date
	,	part_reference_date
 
-*		Calculated fields
	,	lvl, path, pathNode, parent_branch, parent_seq
	,	parent_quantity, normalized_quantity
	,	component_volume, volume, normalized_volume, parent_volume
	,	branch, indentStr, breadcrumbs
	,	e_issuedAfterExplDate, e_noPhantomRevision
  ) AS (
 
-*	Initial query: "Anchor" members, containing the top-level items of the BoMs for each part
	SELECT
-*		Current node
		b1.component_part AS part_no, hh.revision, b1.plant, b1.item_number
	,	hh.status, hh.status_code, hh.status_type
	,	hh.class3_id
 
-*		Parent fields (= root here)
	,	p.part_no AS parent_part, p.revision AS parent_rev
	,	p.status AS parent_status, p.status_type AS parent_status_type
 
-*		Part details
	,	b1.alternative, bh1.preferred
	,	b1.num_5 AS phr, b1.quantity, b1.num_1 AS density, b1.num_1 AS root_density, b1.uom
	,	b1.num_1, b1.num_2, b1.num_3, b1.num_4, b1.num_5
	,	b1.char_1, b1.char_2, b1.char_3, b1.char_4, b1.char_5
	,	b1.date_1, b1.date_2
	,	b1.boolean_1, b1.boolean_2, b1.boolean_3, b1.boolean_4
	,	b1.ch_1, b1.ch_2
	,	coalesce(hh.issued_date, hh.planned_effective_date) AS issued_date
	,	hh.obsolescence_date AS obsolete_date
 
-*		Root node
	,	p.part_no AS root_part, p.revision AS root_rev
	,	p.status AS root_status, p.status_type AS root_status_type
	,	b1.alternative AS root_alternative, bh1.preferred AS root_preferred
	,	p.issued_date AS root_issued_date
	,	CAST(p.reference_date AS date) AS root_reference_date
 
-*		Behaviour
	,	CAST(p.reference_date AS date)
	,	CAST(CASE
			WHEN '&TOP_SCENARIO' = 'REFDATE' THEN p.reference_date
			WHEN '&TOP_SCENARIO' = 'DEFAULT' AND b1.component_part LIKE 'X%'
				THEN p.issued_date
			ELSE coalesce(p.obsolescence_date, CURRENT_DATE)
		END AS date)
 
-*		Calculated fields
	,	1 AS lvl
	,	CAST('0000' AS varchar2(120)) AS path
	,	to_char(b1.item_number, 'FM0999') AS pathNode
	,	CAST('' AS VARCHAR2(100)) AS parent_branch, b1.item_number AS parent_seq
 
	,	bh1.base_quantity AS parent_quantity
	,	b1.quantity * &BASE_QUANTITY / 1 AS normalized_quantity
 
	,	DECODE(b1.num_1, 0, 0, b1.quantity / b1.num_1) AS component_volume
	,	DECODE(b1.num_1, 0, 0, b1.quantity / b1.num_1) AS volume
	,	DECODE(b1.num_1, 0, 0, b1.quantity / b1.num_1) AS normalized_volume
	,	1 AS parent_volume
 
	,	CAST(to_char(b1.item_number, 'FM0999') AS varchar2(100)) AS branch
	,	CAST ('' AS VARCHAR2(200)) AS indentStr
	,	CAST('Top' AS VARCHAR2(200)) AS breadcrumbs
 
-*		Sanity checks
	,	CASE WHEN p.revision = 1 AND hh.revision = 1 AND p.reference_date < coalesce(hh.issued_date, hh.planned_effective_date)
			THEN '1'
			ELSE '0'
		END AS e_issuedAfterExplDate
	,	CASE WHEN hh.revision IS NULL THEN 1 ELSE 0 END AS e_noPhantomRevision
 
	  FROM specs p
	  LEFT JOIN bom_header bh1 ON (
			p.part_no = bh1.part_no
		AND p.revision = bh1.revision
		AND p.&BOM_ALT_FIELD = bh1.&BOM_ALT_FIELD
	  )
	  LEFT JOIN bom_item b1 ON (
			b1.part_no = bh1.part_no
		AND b1.revision = bh1.revision
		AND b1.plant = bh1.plant
		AND b1.alternative = bh1.alternative
	  )
 
	  LEFT JOIN specList hh ON (
	  		b1.component_part = hh.part_no
		AND  (f_checkRefDate = 0
		     OR (
				hh.issued_date <= p.reference_date
			AND (hh.obsolescence_date IS NULL OR p.reference_date < hh.obsolescence_date)
	    	 )
	    	)
		AND NOT EXISTS (
-*			XXX: Using specList here performs badly
			SELECT 1
			  FROM specification_header h2a
			  JOIN status s2a ON (s2a.status = h2a.status)
			 WHERE h2a.part_no = hh.part_no
			   AND h2a.revision > hh.revision
			   AND s2a.status_type IN (&PART_STATUSLIST)
			   AND ('&TOP_SCENARIO' <> 'REFDATE'
			    OR (
						h2a.issued_date <= p.reference_date
					AND (h2a.obsolescence_date IS NULL OR p.reference_date < h2a.obsolescence_date)
				)
			   )
		)
	  )
	  LEFT JOIN class3 c3 ON (c3.class = hh.class3_id)
 
	WHERE 1 = 1
	  AND bh1.preferred	= &PREFERRED
	  AND bh1.alternative	= &ALTERNATIVE
 
-IF &BOM_TOP NE 0 THEN GOTO :BOM_TOP;
	UNION ALL
 
-*====================================
-*	Repeated query: Recursive members
-*====================================
 
-*	Fields "root_part" and "root_rev" are passed on verbatim and thus will keep returning the original values from the initial part of the query.
-*	All other values get modified based on the values of their respective parent nodes values.
	SELECT
-*		Current node
		b2.component_part AS part_no, hh.revision, t.plant, b2.item_number
	,	hh.status, hh.status_code, hh.status_type
	,	hh.class3_id
 
-*		Parent node
	,	t.part_no AS parent_part, t.revision AS parent_rev
	,	t.status AS parent_status, t.status_type AS parent_status_type
 
-*		Part details
	,	b2.alternative, bh2.preferred
	,	b2.num_5 AS phr, b2.quantity, b2.num_1 AS density, t.root_density, b2.uom
	,	b2.num_1, b2.num_2, b2.num_3, b2.num_4, b2.num_5
	,	b2.char_1, b2.char_2, b2.char_3, b2.char_4, b2.char_5
	,	b2.date_1, b2.date_2
	,	b2.boolean_1, b2.boolean_2, b2.boolean_3, b2.boolean_4
	,	b2.ch_1, b2.ch_2
	,	coalesce(hh.issued_date, hh.planned_effective_date) AS issued_date
	,	hh.obsolescence_date AS obsolete_date
 
-*		Root node
	,	t.root_part, t.root_rev
	,	t.root_status, t.root_status_type
	,	t.root_alternative, t.root_preferred
	,	t.root_issued_date
	,	CAST(t.root_reference_date AS date)
 
-*		Behaviour
	,	CAST(t.reference_date AS date)
	,	CAST(CASE
			WHEN b2.component_part NOT LIKE 'X%' AND '&PROD_SCENARIO' = 'REFDATE' THEN t.reference_date
			WHEN b2.component_part LIKE 'X%' AND '&TRIAL_SCENARIO' = 'REFDATE' THEN t.reference_date
			ELSE t.part_reference_date
		END AS date)
 
-*		Calculated fields
	,	t.lvl +1 AS lvl
	,	substr(t.path || '.' || t.pathNode, 1, 120) AS path
	,	to_char(b2.item_number, 'FM0999') AS pathNode
	,	t.branch AS parent_branch, t.item_number AS parent_seq
 
	,	bh2.base_quantity AS parent_quantity
	,	DECODE(bh2.base_quantity, 0, 0, b2.quantity * t.normalized_quantity / bh2.base_quantity) AS normalized_quantity
 
	,	DECODE(b2.num_1, 0, 0, b2.quantity / b2.num_1) AS component_volume
	,	DECODE(b2.num_1, 0, 0, b2.quantity / b2.num_1)
			* coalesce(
					t.volume,
					DECODE(bh2.base_quantity, 0, 0, b2.quantity / bh2.base_quantity),
					1.0
				) AS volume
	,	DECODE(b2.num_1, 0, 0, b2.quantity / b2.num_1)
			* coalesce(
					t.volume,
					DECODE(bh2.base_quantity, 0, 0, b2.quantity * t.normalized_quantity / bh2.base_quantity),
					1.0
				) AS normalized_volume
	,	t.volume AS parent_volume
 
	,	substr(t.branch || '.' || to_char(b2.item_number, 'FM0999'), 1, 100) AS branch
	,	substr(t.indentStr || &INDENTSTR.QUOTEDSTRING, 1, 200)
	,	substr(t.breadcrumbs || ' / ' || b2.part_no, 1, 200) AS breadcrumbs
 
-*		Sanity checks
	,	CASE WHEN t.root_rev = 1
				AND hh.revision = 1
				AND t.reference_date < coalesce(hh.issued_date, hh.planned_effective_date)
			THEN '1'
			ELSE '0'
		END AS e_issuedAfterExplDate
	,	CASE WHEN hh.revision IS NULL THEN 1 ELSE 0 END AS e_noPhantomRevision
 
-* parent-node record from table "tree" (= this CTE)
	  FROM tree t
	  JOIN bom_header bh2 ON (
			bh2.part_no		= t.part_no
		AND bh2.revision	= t.revision
		AND bh2.plant		= t.plant
		AND bh2.preferred	= &PREFERRED
		AND bh2.alternative	= &ALTERNATIVE
	  )
	  JOIN bom_item b2 ON (
			b2.part_no		= bh2.part_no
		AND b2.revision		= bh2.revision
		AND b2.plant		= bh2.plant
		AND b2.alternative	= bh2.alternative
	  )
-* component part + rev @ date range
	  LEFT JOIN componentList hh ON (
	  		b2.component_part = hh.part_no
		AND (f_checkRefDate = 0
		 OR (
		 		hh.issued_date <= t.reference_date
			AND (hh.obsolescence_date IS NULL OR t.reference_date < hh.obsolescence_date)
		 )
		)
		AND NOT EXISTS (
-* Production specs; XXX: using componentList here performs badly
			SELECT 1
			  FROM specification_header h2a
			  JOIN status s2a ON (
					s2a.status = h2a.status
				AND s2a.status_type IN (&PROD_STATUSLIST)
			  )
			  WHERE h2a.part_no = hh.part_no
			    AND h2a.part_no NOT LIKE 'X%'
			    AND h2a.revision > hh.revision
			    AND ('&PROD_SCENARIO' = 'HIGHEST' OR h2a.issued_date IS NOT NULL)
 
			UNION ALL
 
-*	Trial specs
			SELECT 1
			  FROM specification_header h2a
			  JOIN status s2a ON (
					s2a.status = h2a.status
				AND s2a.status_type IN (&TRIAL_STATUSLIST)
			  )
			  WHERE h2a.part_no = hh.part_no
				AND h2a.part_no LIKE 'X%'
			    AND h2a.revision > hh.revision
			    AND ('&TRIAL_SCENARIO' = 'HIGHEST' OR h2a.issued_date IS NOT NULL)
		)
	  )
 
	 WHERE 1 = 1
	   AND t.lvl < &MAXLEVEL
-* Stop recursion for missing components
	   AND t.revision IS NOT NULL
 
-:BOM_TOP
) &BOM_CYCLE_CHECK
 
SELECT
	root_part, root_rev, root_status, root_status_type
,	root_part || ' [' || root_rev || ']' AS root_part_rev
,	alternative, preferred, root.description AS root_description
,	root_alternative, root_preferred
,	root_issued_date
,	root_reference_date
 
,	tree.part_no, tree.revision, tree.plant, tree.item_number
,	part.description AS part_description
,	tree.status_code, tree.status_type
,	coalesce(plant.description, tree.plant, 'Plant not specified') AS plant_desc
,	C3.sort_desc AS spec_type
,	CAST(issued_date AS date) AS issued_date
,	CAST(obsolete_date AS date) AS obsolete_date
,	part_reference_date AS reference_date
 
,	kw.kw_value AS function, kw.kw_label
 
,	phr, quantity, density, root_density
,	component_volume, volume, normalized_volume, parent_volume
,	normalized_quantity
,	to_char(SUM(quantity)) AS quantity_str, tree.uom
 
,	num_1, num_2, num_3, num_4, num_5
,	char_1, char_2, char_3, char_4, char_5
,	date_1, date_2
,	boolean_1, boolean_2, boolean_3, boolean_4
,	ch_1, ch_2
 
,	parent_part, parnt.description AS parent_description, parent_rev
,	parent_status, parent_status_type
,	parent_part || ' [' || parent_rev || ']' AS parent_part_rev
,	parent_kw.kw_value AS parent_function
,	lvl, pathNode, indentstr, indentstr || tree.part_no AS indent_part
,	path, branch, parent_branch, parent_seq
,	parent_quantity, tree.normalized_quantity
,	path || '.' || pathNode AS fullpath
,	breadcrumbs
 
,	e_issuedAfterExplDate, e_noPhantomRevision
,	&BOM_TOP_DUMMY e_cyclic
 
,	CASE WHEN EXISTS (SELECT 1 FROM bom_item c WHERE c.part_no = tree.part_no) THEN 0 ELSE 1 END AS leaf
 
,	part_cost.price, part_cost.uom AS cost_per_uom, part_cost.currency, part_cost.period AS cost_period
,	part_cost.price * tree.normalized_quantity * CASE
		WHEN tree.uom = 'g' AND part_cost.uom = 'kg' THEN 0.001
		WHEN tree.uom = 'mm' AND part_cost.uom = 'm' THEN 0.001
		WHEN tree.uom = 'kg' AND part_cost.uom = 'g' THEN 1000.0
		WHEN tree.uom = 'm' AND part_cost.uom = 'mm' THEN 1000.0
		ELSE 1.0
	END AS cost
 
  FROM tree
  JOIN part root ON (tree.root_part = root.part_no)
  LEFT JOIN class3 c3 ON (c3.class = tree.class3_id)
  LEFT JOIN part parnt ON (tree.parent_part = parnt.part_no)
  LEFT JOIN part ON (tree.part_no = part.part_no)
  LEFT JOIN (
 	SELECT part_no, kw_value, itkw.description AS kw_label
	FROM specification_kw skw
	JOIN itkw ON (skw.kw_id = itkw.kw_id AND itkw.description IN ('Function', 'Spec. Function'))
  ) kw ON (tree.part_no = kw.part_no)
  LEFT JOIN (
 	SELECT part_no, kw_value
	FROM specification_kw skw
	JOIN itkw ON (skw.kw_id = itkw.kw_id AND itkw.description IN ('Function', 'Spec. Function'))
  ) parent_kw ON (
  		tree.parent_part = parent_kw.part_no
  )
  LEFT JOIN plant ON (tree.plant = plant.plant)
  LEFT JOIN part_cost ON (tree.part_no = part_cost.part_no AND tree.plant = part_cost.plant)
 
 WHERE 1 = 1
   AND kw.kw_value = '&FUNCTION'           --'
   AND parent_kw.kw_value = ''&PARENT_FUNCTION'   --'
   AND parent_branch = '&PARENT_BRANCH'
 
 GROUP BY
	root_part, root_rev, root_status, root_status_type
,	alternative, preferred, root.description
,	root_alternative, root_preferred
,	root_issued_date
,	root_reference_date
 
,	tree.part_no, tree.revision, tree.plant, tree.item_number, part.description
,	tree.status_code, tree.status_type
,	plant.description
,	C3.sort_desc
,	issued_date, obsolete_date, part_reference_date
,	kw.kw_value, kw.kw_label
 
,	phr, quantity, density, root_density
,	component_volume, volume, normalized_volume, parent_volume
,	normalized_quantity
,	tree.uom
 
,	num_1, num_2, num_3, num_4, num_5
,	char_1, char_2, char_3, char_4, char_5
,	date_1, date_2
,	boolean_1, boolean_2, boolean_3, boolean_4
,	ch_1, ch_2
 
,	parent_part, parnt.description, parent_rev
,	parent_kw.kw_value
,	parent_status, parent_status_type
,	lvl, path, branch, pathNode, parent_branch, parent_seq
,	parent_quantity, tree.normalized_quantity
,	indentstr, breadcrumbs
 
,	e_issuedAfterExplDate, e_noPhantomRevision &BOM_FULL_CYCLE
 
,	part_cost.price, part_cost.uom, part_cost.currency, part_cost.period
 
 ORDER BY
	root_part, root_rev, preferred DESC, alternative, path DESC, lvl, tree.part_no, tree.revision, tree.plant
;
END





















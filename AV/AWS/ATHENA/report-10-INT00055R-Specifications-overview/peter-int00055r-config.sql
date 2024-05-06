--REPORT:  INT00055R-Specifications overview
------------------------------------------------
--[Product & Process development ]
--    - [Specifications ]
--      - [ Specifications Overview ]
--




-* File: INT00055P_Config.fex
 
-* Section constants
-SET &S_BOM					= 700576;
 
-* Heading constants
-SET &H_CRITICAL_PARAMETER	= 700503;
 
-* Template keyword
-SET &K_TEMPLATE			= 700686;


--***************************************************************
--***************************************************************
--***************************************************************
select sh.frame_id
,      sh.frame_rev
,      fh.description
,      sh.part_no
,      p.plant
,      p.description
,      kw.kw_id
,      kw.kw_value
from frame_header         fh
join specification_header sh on (sh.frame_id = fh.frame_no and sh.frame_rev  = fh.revision)
join status                s on (s.status    = sh.status   and s.status_type = 'CURRENT')
join part_plant           pp on (pp.part_no  = sh.part_no)
join plant                 p on (p.plant     = pp.plant)
join specification_kw     kw on (kw.part_no  = sh.part_no)
where fh.status = 2
;
--A_Man_RM_Polymerv1	23	Apollo raw material Polymer manufacturer	X130120_JSR_THA	ENS	Enschede Plant	700706	RM (Raw materials)

--There is 1 template available:   NRMDR Polymer Manufacturers specification

SELECT * FROM PART where description like 'NRMDR%' 
--ZZ_RnD_Pol_M_NRMDR	NRMDR Polymer Manufacturers specification	kg	I-S			700311

--wat is part-type:
select * from class3 where class = 700311;
--700311	POLYM	Polymers

--How to find this template related to PART-NO ???
SELECT sk.part_no
,      sk.kw_value
FROM specification_kw sk
JOIN itkw                 ON ( itkw.kw_id = sk.kw_id )
where sk.part_no='X130120_JSR_THA' 
;
/*
X130120_JSR_THA	<Any>				Approval document
X130120_JSR_THA	JOSS				Supplier code
X130120_JSR_THA	KRAHN				Supplier code
X130120_JSR_THA	Manufacturer		Spec. Function
X130120_JSR_THA	<Any>				Date send to supplier
X130120_JSR_THA	<Any>				Date signed specification
X130120_JSR_THA	<Any>				Project
X130120_JSR_THA	RM (Raw materials)	Specification type group
X130120_JSR_THA	Always				Template value overwrite
*/


select * from ITKW where kw_id = 700686;
--700686	Frame for Athena perspective	0	1	0	1

--******************************
--******************************
--FILTER: FIND TEMPLATE
--zoek TEMPLATE-PART-NO related to FRAME-ID of SELECTED-PART-NO. 
select distinct p.part_no
,      p.description       --This is template-name !!!!!
,      sh.part_no
,      sh.revision
,      sh.frame_id
,      kw.kw_value
,      ikw.description
FROM SPECIFICATION_KW     kw 
JOIN SPECIFICATION_HEADER sh on kw.kw_value = sh.frame_id  
JOIN ITKW                ikw on ikw.kw_id   = kw.kw_id
JOIN part                  p on p.part_no   = kw.part_no
WHERE sh.part_no = 'XGG_BF66A17J1'
AND   sh.revision = (select max(sh3.revision) from specification_header sh3 where sh3.part_no = sh.part_no)
AND   ikw.DESCRIPTION = 'Frame for Athena perspective'
;

--ITKW:		700686	Frame for Athena perspective	0	1	0	1
--
/*
P.PART_NO       P.DESCRIPTION                           SH.PART-NO      rev	frame_id	kw-value	ikw-description					
ZZ_RnD_PCR_GTX	PCR GREEN TYRE SPECIFICATION-FLIPPER	XGG_BF66A17J1	2	A_PCR_GT v1	A_PCR_GT v1	Frame for Athena perspective	
ZZ_RnD_PCR_GT	PCR GREEN TYRE SPECIFICATION			XGG_BF66A17J1	2	A_PCR_GT v1	A_PCR_GT v1	Frame for Athena perspective	
ZZ_RnD_PCR_XGT1	TRIAL DATA SHEET - BUILDING				XGG_BF66A17J1	2	A_PCR_GT v1	A_PCR_GT v1	Frame for Athena perspective	
ZZ_RnD_PCR_XGT	PCR FIRST TYRE ROUTE CARD - BUILDING	XGG_BF66A17J1	2	A_PCR_GT v1	A_PCR_GT v1	Frame for Athena perspective	

--CONCLUSIE: DIT ZIJN DE PART-NO DIE ALS TEMPLATE GEBRUIKT KUNNEN WORDEN !!!!!!!!!!!!
--           TEMPLATE-STRUCTUUR BEPAALT DAN DE OPBOUW VAN HET REPORT, TBV TONEN COMPONENTEN + PROPERTIES !!!!!!!
*/


select distinct p.part_no
,      p.description       --This is template-name !!!!!
FROM SPECIFICATION_KW     kw 
JOIN SPECIFICATION_HEADER sh on kw.kw_value = sh.frame_id  
JOIN ITKW                ikw on ikw.kw_id   = kw.kw_id
JOIN part                  p on p.part_no   = kw.part_no
--WHERE sh.part_no = 'XGG_BF66A17J1'
WHERE sh.frame_id = 'A_RM_Polymer v1'
AND   sh.revision = (select max(sh3.revision) from specification_header sh3 where sh3.part_no = sh.part_no)
AND   ikw.DESCRIPTION = 'Frame for Athena perspective'
;
/*
Mask_polymer visco	Mask Ploymer viscosity overview
ZZ_RnD_Pol_NRMDR	NRMDR Polymer specification
ZZ_RnD_Pol_OVV	Polymer specification overview
*/

select distinct p.part_no
,      p.description       --This is template-name !!!!!
FROM SPECIFICATION_HEADER sh 
JOIN SPECIFICATION_KW     kw on (kw.kw_value = sh.frame_id )
JOIN part                  p on (p.part_no   = kw.part_no)
JOIN ITKW                ikw on (ikw.kw_id   = kw.kw_id)
WHERE sh.frame_id = 'A_RM_Polymer v1'
AND   sh.revision = (select max(sh3.revision) from specification_header sh3 where sh3.part_no = sh.part_no)
and   ikw.kw_id = 700686
;

select distinct p.part_no
,      p.description       --This is template-name !!!!!
FROM SPECIFICATION_HEADER sh 
JOIN SPECIFICATION_KW     kw on (kw.kw_value = sh.frame_id )
JOIN part                  p on (p.part_no   = kw.part_no)
JOIN ITKW                ikw on (ikw.kw_id   = kw.kw_id)
WHERE sh.frame_id = 'A_RM_Polymer v1'
AND   sh.revision = (select max(sh3.revision) from specification_header sh3 where sh3.part_no = sh.part_no)
and   ikw.kw_id = 700686
;



select DISTINCT sh.frame_id
,      sh.frame_rev
--,      fh.description
--,      sh.part_no
,      template.part_no     as template_part_no
,      template.description as template_description
,      p.plant
,      p.description
--,      kw.kw_id
--,      kw.kw_value
from frame_header           fh
join specification_header   sh on (sh.frame_id = fh.frame_no and sh.frame_rev  = fh.revision)
join status                  s on (s.status    = sh.status   and s.status_type = 'CURRENT')
join part_plant             pp on (pp.part_no  = sh.part_no)
join plant                   p on (p.plant     = pp.plant)
join specification_kw       kw on (kw.KW_value = sh.frame_id)
join part             template on (template.part_no  = kw.part_no)
join part_plant            tpp on (tpp.part_no       = template.part_no and tpp.plant = p.plant)
where fh.status = 2
and   kw.kw_id = 700686
and   sh.frame_id = 'A_PCR'
and   p.plant     = 'GYO' --'ENS'
AND   sh.revision = (select max(sh3.revision) from specification_header sh3 where sh3.part_no = sh.part_no)
;

/*
A_PCR	91	ZZ_PCR_RnD_FEA		Template for FEA DOE check	ENS	Enschede Plant
A_PCR	91	Mask_Section		Section D-spec				ENS	Enschede Plant
--
A_PCR	91	ZG_PCRO1_PCT		Template for PCR overview	GYO	Gyöngyöshalász
A_PCR	91	Mask_PCR_INT00067	PAC							GYO	Gyöngyöshalász
A_PCR	91	Mask_PCR_INT00064	Layout specification		GYO	Gyöngyöshalász
A_PCR	91	Mask_PCR_INT00066	Cavity parameters			GYO	Gyöngyöshalász
A_PCR	91	Mask_PCR_INT00065	D-Spec and General			GYO	Gyöngyöshalász
*/



select DISTINCT sh.frame_id
,      sh.frame_rev
--,      fh.description
--,      sh.part_no
,      template.part_no     as template_part_no
,      template.description as template_description
,      p.plant
,      p.description
--,      kw.kw_id
--,      kw.kw_value
from frame_header           fh
join specification_header   sh on (sh.frame_id = fh.frame_no and sh.frame_rev  = fh.revision)
join status                  s on (s.status    = sh.status   and s.status_type = 'CURRENT')
join part_plant             pp on (pp.part_no  = sh.part_no)
join plant                   p on (p.plant     = pp.plant)
join specification_kw       kw on (kw.KW_value = sh.frame_id)
join part             template on (template.part_no  = kw.part_no)
join part_plant            tpp on (tpp.part_no       = template.part_no and tpp.plant = p.plant)
where fh.status = 2
and   kw.kw_id = 700686
and   sh.frame_id = 'A_Man_RM_Aux'
and   p.plant     in ( 'GYO', 'ENS' )
AND   sh.revision = (select max(sh3.revision) from specification_header sh3 where sh3.part_no = sh.part_no)
;














select sh.frame_id
,      sh.frame_rev
,      fh.description
,      sh.part_no
,      p.plant
,      p.description
,      kw.kw_id
,      kw.kw_value
from frame_header         fh
join specification_header sh on (sh.frame_id = fh.frame_no and sh.frame_rev  = fh.revision)
join status                s on (s.status    = sh.status   and s.status_type = 'CURRENT')
join part_plant           pp on (pp.part_no  = sh.part_no)
join plant                 p on (p.plant     = pp.plant)
join specification_kw     kw on (kw.part_no  = sh.part_no)
where fh.status = 2
and   kw.kw_id = 700686
;
/*
A_PCR_VULC v1	31	Apollo PCR Tyres vulcanized					Mask_PCR_INT00003	GYO	Gyöngyöshalász		700686	A_PCR_VULC v1
A_PCR_GT v1		34	Apollo Greentyres PCR						ZZ_RnD_PCR_GTX		DEV	Development Plant	700686	A_PCR_GT v1
A_PCR_GT v1		34	Apollo Greentyres PCR						ZZ_RnD_PCR_XGT1		DEV	Development Plant	700686	A_PCR_GT v1
A_PCR_GT v1		34	Apollo Greentyres PCR						ZZ_RnD_PCR_GT		DEV	Development Plant	700686	A_PCR_GT v1
A_PCR_GT v1		34	Apollo Greentyres PCR						ZZ_RnD_PCR_XGT		DEV	Development Plant	700686	A_PCR_GT v1
A_Sidewall v1	23	Apolllo Sidewall extrudates v1				Mask_PCR_INT00045	GYO	Gyöngyöshalász		700686	A_Sidewall v1
A_Ply v1		13	Cutted & slitted ply material				Mask_PCR_INT00012	GYO	Gyöngyöshalász		700686	A_Ply v1
A_TBR_GT		15	Apollo Greentyres TBR						ZZ_RnD_TBR_GT		DEV	Development Plant	700686	A_TBR_GT
A_TBR_VULC		21	Apollo TBR tyres vulcanized					Mask_PCR_INT00041	GYO	Gyöngyöshalász		700686	A_TBR_VULC
A_Bead v1		27	Specification of beads						Mask_PCR_INT00039	DEV	Development Plant	700686	A_Bead v1
A_Bead v1		27	Specification of beads						Mask_PCR_INT00039	GYO	Gyöngyöshalász		700686	A_Bead v1
A_Bead v1		27	Specification of beads						Mask_TBR_INT00055	DEV	Development Plant	700686	A_Bead v1
A_Bead v1		27	Specification of beads						Mask_TBR_INT00055	GYO	Gyöngyöshalász		700686	A_Bead v1
A_Belt v1		15	Apollo Cutted & slitted belt material v1	Mask_BELT			GYO	Gyöngyöshalász		700686	A_Belt v1
A_Belt v1		15	Apollo Cutted & slitted belt material v1	Mask_BELT2			GYO	Gyöngyöshalász		700686	A_Belt v1
*/


select * from root_function where part_no = '




--***************************************************************
--***************************************************************
--***************************************************************

-* File: INT00055P_frame_header.fex
SET HOLDLIST = PRINTONLY
 
JOIN
	FRAME_NO AND REVISION IN FRAME_HEADER TAG h TO
	FRAME_ID AND FRAME_REV IN SPECIFICATION_HEADER TAG sh AS J0
END
JOIN
	sh.PART_NO IN FRAME_HEADER TO
	PART_NO IN PART_PLANT TAG pp AS J1
END
TABLE FILE FRAME_HEADER
SUM
	COMPUTE DSP/A81 = FST.h.FRAME_NO | ' - ' | FST.h.DESCRIPTION;
 
BY h.FRAME_NO
 
WHERE h.STATUS EQ 2;
WHERE pp.PLANT EQ &PLANT;
 
ON TABLE PCHOLD FORMAT XML
END





--***************************************************************
--***************************************************************
--***************************************************************

-* File: INT00055P_frame_template.fex
-*-SET &ECHO = ON;
SET HOLDLIST = PRINTONLY
SET ASNAMES = ON
 
-INCLUDE INT00055P_Config
 
JOIN
	SK.PART_NO IN SPECIFICATION_KW TAG SK TO UNIQUE
	PART_NO IN PART TAG P AS J2
END
JOIN
	SK.PART_NO IN SPECIFICATION_KW TO UNIQUE
	PART_NO IN SPECIFICATION_HEADER TAG H2 AS J3
END
JOIN
	H2.STATUS IN SPECIFICATION_KW TO UNIQUE
	STATUS IN STATUS TAG S AS J4
END
 
TABLE FILE SPECIFICATION_KW
SUM P.DESCRIPTION
BY H2.PART_NO AS TEMPLATE
 
WHERE SK.KW_ID EQ &K_TEMPLATE;
WHERE SK.KW_VALUE EQ 'NONE'
   OR &FRAME_ID
;
 
IF S.STATUS_TYPE EQ 'CURRENT';
 
ON TABLE PCHOLD FORMAT XML
END



--eind
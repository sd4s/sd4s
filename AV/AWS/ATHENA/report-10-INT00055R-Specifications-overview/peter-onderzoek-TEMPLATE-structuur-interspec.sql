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
,      pa.part_no     as template_part_no
,      pa.description as template_description
,      p.plant
,      p.description
--,      kw.kw_id
--,      kw.kw_value
from frame_header         fh
join specification_header sh on (sh.frame_id = fh.frame_no and sh.frame_rev  = fh.revision)
join status                s on (s.status    = sh.status   and s.status_type = 'CURRENT')
join part_plant           pp on (pp.part_no  = sh.part_no)
join plant                 p on (p.plant     = pp.plant)
join specification_kw     kw on (kw.KW_value = sh.frame_id)
join part                 pa on (pa.part_no  = kw.part_no)
where fh.status = 2
and   kw.kw_id = 700686
and   sh.frame_id = 'A_PCR'
and   p.plant     = 'ENS'
AND   sh.revision = (select max(sh3.revision) from specification_header sh3 where sh3.part_no = sh.part_no)
;

/*
A_PCR	91	Mask_PCR_INT00066	Cavity parameters						ENS	Enschede Plant
A_PCR	91	ZZ_PCR_RnD_FEA		Template for FEA DOE check				ENS	Enschede Plant
A_PCR	91	Mask_PCR_INT00065	D-Spec and General						ENS	Enschede Plant
A_PCR	91	Mask_Section		Section D-spec							ENS	Enschede Plant   --> deze komt niet voor in ATHENA-report....
A_PCR	91	ZG_PCRO1_PCT		Template for PCR overview				ENS	Enschede Plant
A_PCR	91	Mask_PCR_INT00067	PAC										ENS	Enschede Plant
A_PCR	91	Mask_PCR_INT00064	Layout specification					ENS	Enschede Plant
A_PCR	91	ZZ_Labels PCR		Overview label values PCR tyres Apollo	ENS	Enschede Plant
*/


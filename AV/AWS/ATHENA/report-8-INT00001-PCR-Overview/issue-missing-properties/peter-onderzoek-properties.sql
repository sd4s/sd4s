/*
						Ply1 type	Ply1 angle	Ply1 width
EF_H165/80R14CLS	20  ME01		90			540
--
EF_H165/80R14CLS	20
EF_H165/80R15CLS	17
EF_H175/70R15CLS	13
EF_H175/80R14CLS	20
EF_H185/60Q16SN5	20
EF_H185/60V16SN5	6
EF_H185/70R15CLS	18
EF_H185/80R14CLS	23
EF_H195/55R20QPPX	13
EF_H195/55R20WPRX	21
EF_H195/65Q15SP5	27
EF_H195/65Q15WTR	20
EF_H195/65V15SP5	6
EF_H195/65V15WTR	6
EF_H205/50R15QT5	22
EF_H205/55Q16SN5	33
EF_H205/55Q17WPR	24
EF_H205/55R19WPRX	14
EF_H205/55V16SN5	7
EF_H205/55V17WPR	7
EF_H215/45R20WPRX	13
EF_H215/50R19WPR	12
EF_H215/60R17AA4X	7
EF_H215/60R17AXW	18
EF_H215/65R17AXW	13
EF_H225/45R17AXW	19
EF_H225/60R17AXWX	18
EF_H225/65R17AXWX	22
EF_H235/60D18WXS	28
EF_H235/60R18AXWX	20
EF_H235/60V18WXS	7
EF_H235/65R17AXWX	13
EF_M170/95R40TCL	19
EF_PROEFBAND A1 UF	2
*/

select "Part no.", "Ply1 type",	"Ply1 angle",	"Ply1 width"
from sc_lims_dal.mv_pcr_overview
where "Part no." in ('EF_H165/80R14CLS')
;
EF_H165/80R14CLS	ME01	90.0	540.0



/*
"substring"((bom_properties.bom -> 'Ply 1'::text) ->> 'part_no'::text, 4, 4) AS "Ply1 type",
((((((bom_properties.bom -> 'Ply 1'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Dimensions SFP'::text) -> 'Angle'::text) ->> 'Target'::text)::double precision AS "Ply1 angle",
((((((bom_properties.bom -> 'Ply 1'::text) -> 'Properties'::text) -> '(none)'::text) -> 'Dimensions SFP'::text) -> 'Width'::text) ->> 'Target'::text)::double precision AS "Ply1 width",
*/

--Uitvragen van BOM:

select  p.description, d.* 
from  sc_lims_dal.av_exec_db_partno_dispersion  d
LEFT JOIN sc_lims_dal.av_parts p on p.part_no = d.part_no
where d.root_part = 'EF_H165/80R14CLS' 
and   d.root_rev = 20
;

	
	
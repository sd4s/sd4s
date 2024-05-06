--***********************************************************************
--***********************************************************************
--TERUGZETTEN ALLE DATA IVM NIEUWE INITIELE-LOAD
--***********************************************************************
--***********************************************************************
truncate table DBA_WEIGHT_PART_NEW_REV_LOG ;
truncate table DBA_WEIGHT_RELATED_TYRE_LOG ;
truncate table dba_sync_besturing_weight_sap ;
truncate table DBA_WEIGHT_COMPONENT_PART ;
commit;

--START PROC:	
AANROEP_VUL_INIT_PART_GEWICHT (p_header_part_no                  varchar2   default 'ALLE' 
                                        ,p_header_frame_id       varchar2   default 'ALLE' 
                                        ,p_aantal                number     default 999999999
                                        ,p_show_incl_items_jn    varchar2   default 'N' 
                                        ,p_insert_weight_comp_jn varchar2   default 'J'			)
										
/*
Connecting to the database oracleprod-db-IS61-Interspc.
Aanroep header-part-no: ALLE frame: ALLE aantal: 99999999
UITVRAGEN-STUURTABEL TOEVOEGEN NIEUW Frame-id: A_PCR verwerkingperiode van: 22-04-2023 12:09:45
Frame-id: A_PCR verwerkingperiode van: 22-04-2023 12:09:45 t/m 22-04-2023 12:09:45
STUURTABEL-RECORD TOEGEVOEGD met ID =3868 Frame-id: A_PCR
Aanroep cursor TYRE-PART-NO met header-part-no:% header-frame-id: A_PCR aantal: 99999999
UITVRAGEN-STUURTABEL TOEVOEGEN NIEUW Frame-id: A_PCR_VULC v1 verwerkingperiode van: 22-04-2023 14:41:38
Frame-id: A_PCR_VULC v1 verwerkingperiode van: 22-04-2023 14:41:38 t/m 22-04-2023 14:41:38
STUURTABEL-RECORD TOEGEVOEGD met ID =3869 Frame-id: A_PCR_VULC v1
Aanroep cursor TYRE-PART-NO met header-part-no:% header-frame-id: A_PCR_VULC v1 aantal: 99999999
UITVRAGEN-STUURTABEL TOEVOEGEN NIEUW Frame-id: A_PCR_v2 verwerkingperiode van: 22-04-2023 14:41:58
Frame-id: A_PCR_v2 verwerkingperiode van: 22-04-2023 14:41:58 t/m 22-04-2023 14:41:58
STUURTABEL-RECORD TOEGEVOEGD met ID =3870 Frame-id: A_PCR_v2
Aanroep cursor TYRE-PART-NO met header-part-no:% header-frame-id: A_PCR_v2 aantal: 99999999
UITVRAGEN-STUURTABEL TOEVOEGEN NIEUW Frame-id: A_TBR verwerkingperiode van: 22-04-2023 14:42:07
Frame-id: A_TBR verwerkingperiode van: 22-04-2023 14:42:07 t/m 22-04-2023 14:42:07
STUURTABEL-RECORD TOEGEVOEGD met ID =3871 Frame-id: A_TBR
Aanroep cursor TYRE-PART-NO met header-part-no:% header-frame-id: A_TBR aantal: 99999999
UITVRAGEN-STUURTABEL TOEVOEGEN NIEUW Frame-id: E_AT verwerkingperiode van: 22-04-2023 15:04:38
Frame-id: E_AT verwerkingperiode van: 22-04-2023 15:04:38 t/m 22-04-2023 15:04:38
STUURTABEL-RECORD TOEGEVOEGD met ID =3872 Frame-id: E_AT
Aanroep cursor TYRE-PART-NO met header-part-no:% header-frame-id: E_AT aantal: 99999999
UITVRAGEN-STUURTABEL TOEVOEGEN NIEUW Frame-id: E_BBQ verwerkingperiode van: 22-04-2023 15:05:19
Frame-id: E_BBQ verwerkingperiode van: 22-04-2023 15:05:19 t/m 22-04-2023 15:05:19
STUURTABEL-RECORD TOEGEVOEGD met ID =3873 Frame-id: E_BBQ
Aanroep cursor TYRE-PART-NO met header-part-no:% header-frame-id: E_BBQ aantal: 99999999
UITVRAGEN-STUURTABEL TOEVOEGEN NIEUW Frame-id: E_PCR_VULC verwerkingperiode van: 22-04-2023 15:05:24
Frame-id: E_PCR_VULC verwerkingperiode van: 22-04-2023 15:05:24 t/m 22-04-2023 15:05:24
STUURTABEL-RECORD TOEGEVOEGD met ID =3874 Frame-id: E_PCR_VULC
Aanroep cursor TYRE-PART-NO met header-part-no:% header-frame-id: E_PCR_VULC aantal: 99999999
ALG-EXCP-DBA-INSERT-WEIGHT-COMP_PAR ERROR CALC-DATE: 22-04-2023 15:05:31 MAINPART: EV_CH205/50R17WXSX PART_NO: EM_722-66 ALT: 1 ITEM-NR: 10 COMP-PART: EM_522-19 CHR:  path: |EV_CH205/50R17WXSX,EG_CV205017WXSX-G|EG_CV205017WXSX-G-903311,ET_LV520|ET_LV520,EM_722|EM_722,EM_522 LVL: 4 : ORA-00001: unique constraint (INTERSPC.UK_WEIGHT_COMP_PART_NO) violated
ALG-EXCP-DBA-INSERT-WEIGHT-COMP_PAR ERROR CALC-DATE: 22-04-2023 15:05:31 MAINPART: EV_CH205/50R17WXSX PART_NO: EM_522-19 ALT: 1 ITEM-NR: 10 COMP-PART: EM_422-26 CHR:  path: |EV_CH205/50R17WXSX,EG_CV205017WXSX-G|EG_CV205017WXSX-G-903311,ET_LV520|ET_LV520,EM_722|EM_722,EM_522|EM_522,EM_422 LVL: 5 : ORA-00001: unique constraint (INTERSPC.UK_WEIGHT_COMP_PART_NO) violated
ALG-EXCP-DBA-INSERT-WEIGHT-COMP_PAR ERROR CALC-DATE: 22-04-2023 15:05:49 MAINPART: EV_CV205/50R17WXSX PART_NO: EM_722-66 ALT: 1 ITEM-NR: 10 COMP-PART: EM_522-19 CHR:  path: |EV_CV205/50R17WXSX,EG_CV205017WXSX-G|EG_CV205017WXSX-G-903311,ET_LV520|ET_LV520,EM_722|EM_722,EM_522 LVL: 4 : ORA-00001: unique constraint (INTERSPC.UK_WEIGHT_COMP_PART_NO) violated
ALG-EXCP-DBA-INSERT-WEIGHT-COMP_PAR ERROR CALC-DATE: 22-04-2023 15:05:49 MAINPART: EV_CV205/50R17WXSX PART_NO: EM_522-19 ALT: 1 ITEM-NR: 10 COMP-PART: EM_422-26 CHR:  path: |EV_CV205/50R17WXSX,EG_CV205017WXSX-G|EG_CV205017WXSX-G-903311,ET_LV520|ET_LV520,EM_722|EM_722,EM_522|EM_522,EM_422 LVL: 5 : ORA-00001: unique constraint (INTERSPC.UK_WEIGHT_COMP_PART_NO) violated
ALG-EXCP-DBA-INSERT-WEIGHT-COMP_PAR ERROR CALC-DATE: 22-04-2023 15:06:22 MAINPART: EV_CW275/40R20QT5X PART_NO: EM_725-57 ALT: 1 ITEM-NR: 11 COMP-PART: EM_525-8 CHR:  path: |EV_CW275/40R20QT5X,EG_CW274020QT5X-G|EG_CW274020QT5X-G-903311,ET_LV528|ET_LV528,EM_725|EM_725,EM_525 LVL: 4 : ORA-00001: unique constraint (INTERSPC.UK_WEIGHT_COMP_PART_NO) violated
ALG-EXCP-DBA-INSERT-WEIGHT-COMP_PAR ERROR CALC-DATE: 22-04-2023 15:06:22 MAINPART: EV_CW275/40R20QT5X PART_NO: EM_525-8 ALT: 1 ITEM-NR: 11 COMP-PART: EM_425-15 CHR:  path: |EV_CW275/40R20QT5X,EG_CW274020QT5X-G|EG_CW274020QT5X-G-903311,ET_LV528|ET_LV528,EM_725|EM_725,EM_525|EM_525,EM_425 LVL: 5 : ORA-00001: unique constraint (INTERSPC.UK_WEIGHT_COMP_PART_NO) violated
UITVRAGEN-STUURTABEL TOEVOEGEN NIEUW Frame-id: E_SF_BoxedWheels verwerkingperiode van: 22-04-2023 15:07:12
Frame-id: E_SF_BoxedWheels verwerkingperiode van: 22-04-2023 15:07:12 t/m 22-04-2023 15:07:12
STUURTABEL-RECORD TOEGEVOEGD met ID =3875 Frame-id: E_SF_BoxedWheels
Aanroep cursor TYRE-PART-NO met header-part-no:% header-frame-id: E_SF_BoxedWheels aantal: 99999999
UITVRAGEN-STUURTABEL TOEVOEGEN NIEUW Frame-id: E_SF_Wheelset verwerkingperiode van: 22-04-2023 15:07:41
Frame-id: E_SF_Wheelset verwerkingperiode van: 22-04-2023 15:07:41 t/m 22-04-2023 15:07:41
STUURTABEL-RECORD TOEGEVOEGD met ID =3876 Frame-id: E_SF_Wheelset
Aanroep cursor TYRE-PART-NO met header-part-no:% header-frame-id: E_SF_Wheelset aantal: 99999999
UITVRAGEN-STUURTABEL TOEVOEGEN NIEUW Frame-id: E_SM verwerkingperiode van: 22-04-2023 15:08:02
Frame-id: E_SM verwerkingperiode van: 22-04-2023 15:08:02 t/m 22-04-2023 15:08:02
STUURTABEL-RECORD TOEGEVOEGD met ID =3877 Frame-id: E_SM
Aanroep cursor TYRE-PART-NO met header-part-no:% header-frame-id: E_SM aantal: 99999999
Uitvragen van hulptabel DBA_WEIGHT_COMPONENT_PART, aantal: 5325 duur(min): 178.5
SELECT count(*), trunc(component_issueddate) FROM DBA_WEIGHT_COMPONENT_PART where component_issueddate > trunc(sysdate)-14 group by trunc(component_issueddate) order by trunc(component_issueddate);
SELECT count(*), mainpart, tech_calculation_date FROM DBA_WEIGHT_COMPONENT_PART where tech_calculation_date > trunc(sysdate) group by mainpart, tech_calculation_date order by mainpart, tech_calculation_date;
Process exited.
Disconnecting from the database oracleprod-db-IS61-Interspc.
*/

/*
select count(*), mainframeid
from dba_weight_component_part
where component_part_no is null
group by mainframeid
order by mainframeid
;
--
4411	A_PCR
6		A_PCR_VULC v1
15		A_PCR_v1
2		A_PCR_v2
--
230		A_TBR
93		E_AT
20		E_BBQ
273		E_PCR_VULC
106		E_SF_BoxedWheels
108		E_SF_Wheelset
25		E_SM
*/

/*
--ER ZAT NOG EEN FOUTJE IN DE FRAME-SELECTIE OM ALLE A_PCR GELIJK TE BEHANDELEN, EN DE TELLER WERD NIET GERESET...
delete from DBA_SYNC_BESTURING_WEIGHT_SAP where SBW_SELECTED_FRAME_ID='A_PCR_VULC_v1';
delete from DBA_SYNC_BESTURING_WEIGHT_SAP where SBW_SELECTED_FRAME_ID='A_PCR_v1';
--
--herstel DBA_SYNC_BESTURING_WEIGHT_SAP:
update DBA_SYNC_BESTURING_WEIGHT_SAP SET SBW_AANTAL_TYRES=(4411+6+15+2) WHERE ID=3868 AND SBW_SELECTED_FRAME_ID='A_PCR';
update DBA_SYNC_BESTURING_WEIGHT_SAP SET SBW_AANTAL_TYRES=230           WHERE ID=3871 AND SBW_SELECTED_FRAME_ID='A_TBR';
update DBA_SYNC_BESTURING_WEIGHT_SAP SET SBW_AANTAL_TYRES=93            WHERE ID=3872 AND SBW_SELECTED_FRAME_ID='E_AT';
update DBA_SYNC_BESTURING_WEIGHT_SAP SET SBW_AANTAL_TYRES=20            WHERE ID=3873 AND SBW_SELECTED_FRAME_ID='E_BBQ';
update DBA_SYNC_BESTURING_WEIGHT_SAP SET SBW_AANTAL_TYRES=273           WHERE ID=3874 AND SBW_SELECTED_FRAME_ID='E_PCR_VULC';
update DBA_SYNC_BESTURING_WEIGHT_SAP SET SBW_AANTAL_TYRES=106           WHERE ID=3875 AND SBW_SELECTED_FRAME_ID='E_SF_BoxedWheels';
update DBA_SYNC_BESTURING_WEIGHT_SAP SET SBW_AANTAL_TYRES=108           WHERE ID=3876 AND SBW_SELECTED_FRAME_ID='E_SF_Wheelset';
update DBA_SYNC_BESTURING_WEIGHT_SAP SET SBW_AANTAL_TYRES=25            WHERE ID=3877 AND SBW_SELECTED_FRAME_ID='E_SM';
--
commit;
*/


--VIEW-DEFINITIE AV_BHR_BOM_TYRE_PART_NO
4428	A_PCR
3		A_PCR_VULC v1
18		A_PCR_v1
1		A_PCR_v2
--
230	A_TBR
93	E_AT
37	E_BBQ
273	E_PCR_VULC
106	E_SF_BoxedWheels
108	E_SF_Wheelset
25	E_SM

--QUERY IN VERWERK-GEWICHT-MUTATIES:
select decode(bh.FRAME_ID,'A_PCR_VULC v1','A_PCR', 'A_PCR_v1','A_PCR', 'A_PCR_v2','A_PCR', bh.FRAME_ID)      frame_id
from AV_BHR_BOM_TYRE_PART_NO   bh
where bh.frame_id like pl_header_frame_id||'%' 

--QUERY IN VUL-INIT
select decode(bh.FRAME_ID,'A_PCR_VULC_v1','A_PCR','A_PCR_v1','A_PCR', bh.FRAME_ID)     frame_id
     from AV_BHR_BOM_TYRE_PART_NO   bh
     where (  (   instr(pl_header_part_no,'%') = 0 
              and bh.part_no    = pl_header_part_no
              and bh.frame_id   like pl_header_frame_id||'%'
     		     )
     	    or (   instr(pl_header_part_no,'%') > 0
     	       and bh.part_no    like pl_header_part_no||'%'   
    	       and bh.frame_id   like pl_header_frame_id||'%'
             )
          )
--conclusie: HIER ZIEN WE DE A_PCR_VULC_V1 nog met UNDERSCORE, MOET ZONDER DE UNDERSCORE ZIJN: "A_PCR_VULC v1" !!!
--           EN, de vertaalslag van A_PCR_v2 naar A_PCR ontbrak !!! Zit wel goed in de VERWERK-GEWICHT-MUTATIES...
		  
		  
--INHOUD DBA_SYNC_BESTURING_WEIGHT_SAP
--INITIAL:
5325		22-04-2023 15:08:02	INTERSPC	INITIAL	E_SM
5300		22-04-2023 15:07:41	INTERSPC	INITIAL	E_SF_Wheelset
5192		22-04-2023 15:07:12	INTERSPC	INITIAL	E_SF_BoxedWheels
5086		22-04-2023 15:05:24	INTERSPC	INITIAL	E_PCR_VULC
4813		22-04-2023 15:05:19	INTERSPC	INITIAL	E_BBQ
4776		22-04-2023 15:04:38	INTERSPC	INITIAL	E_AT
4683		22-04-2023 14:42:07	INTERSPC	INITIAL	A_TBR
--
4453		22-04-2023 14:41:58	INTERSPC	INITIAL	A_PCR_v2
4452		22-04-2023 14:41:38	INTERSPC	INITIAL	A_PCR_VULC v1
4449		22-04-2023 12:09:45	INTERSPC	INITIAL	A_PCR
--

--VERWERK-MUTATIE:
0		23-04-2023 01:06:05	INTERSPC	MUTATIE	E_SM
0		23-04-2023 01:06:05	INTERSPC	MUTATIE	E_SF_Wheelset
0		23-04-2023 01:06:05	INTERSPC	MUTATIE	E_SF_BoxedWheels
0		23-04-2023 01:06:05	INTERSPC	MUTATIE	E_PCR_VULC
0		23-04-2023 01:06:05	INTERSPC	MUTATIE	E_BBQ
0		23-04-2023 01:06:05	INTERSPC	MUTATIE	E_AT
0		23-04-2023 01:06:05	INTERSPC	MUTATIE	A_TBR
--
0		23-04-2023 01:06:05	INTERSPC	MUTATIE	A_PCR




--einde script

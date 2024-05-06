-- Get list of CoA test performed with their limits

--This is OLD-version of the VIEW, without translation of INTERSPEC-PART-NO to SAP-ARTICLE-CODE...
--The new version = sc_lims_dal.COA_VW_VENDOR_QUALITY_NW !!!!!!!!!

DROP VIEW sc_lims_dal.COA_VW_VENDOR_QUALITY;

CREATE OR REPLACE VIEW sc_lims_dal.COA_VW_VENDOR_QUALITY
(request_code
,sample_code
,part_no
,part_no_description
,productiondate
,un_supplier_code   
,is_supplier
,order_number
,parameter
,parameter_descr
,ResultParameterstatus
,ResultParameterStatusName
,unit
,results
,low_spec
,target
,high_spec
,test_date
)
AS
select sc.rq     as request_code
, sc.sc          as sample_code
, gk.value        as part_no
, p.description   as part_no_description
, iip.iivalue     as productiondate
, iis.iivalue     as un_supplier_code   
, mfc.description as is_Supplier     --MANUFACTURER
, iio.iivalue     as order_number
, pa.pa           as parameter
, pa.description  as parameter_descr
, pa.ss           as ResultParameterstatus
, s.description   as ResultParameterStatusName
, pa.unit         as unit
, pa.value_f      as results
, spa.low_spec
, spa.target
, spa.high_spec
, pa.exec_end_date as test_date
from sc_unilab_ens.utsc      sc
JOIN sc_unilab_ens.utscpa    pa  on (pa.sc = sc.sc)
JOIN sc_unilab_ens.utss      s   ON (s.ss  = pa.ss)
JOIN sc_unilab_ens.utscpaspa spa on (spa.sc = pa.sc  and spa.pg = pa.pg and spa.pa = pa.pa and spa.panode = pa.panode)
JOIN sc_unilab_ens.utscgk    gk  on (gk.sc = pa.sc and gk.gk = 'PART_NO' )
LEFT OUTER JOIN sc_interspec_ens.part        p   on (p.part_no = gk.value)
left outer join sc_interspec_ens.itprmfc   pmf   on (pmf.part_no  = p.part_no)
left outer join sc_interspec_ens.ITMFC     mfc   on (mfc.mfc_id = pmf.mfc_id)
LEFT OUTER JOIN sc_unilab_ens.utscii  iis  on (iis.sc = pa.sc and iis.ii = 'avSupplierCode' )
LEFT OUTER JOIN sc_unilab_ens.utscii  iip  on (iip.sc = pa.sc and iip.ii = 'avProductionDate' )
LEFT OUTER JOIN sc_unilab_ens.utscii  iio  on (iio.sc = pa.sc and iio.ii = 'avOrderno' )
where pa.pg  = 'CoA'
;

--and   sc.sc  = '2001000016'
/*
	2001000016	GR_5711_BMZ_BMZ	Steelcord 2*0.30 HT	11/12/2019	BMZ	BMZ	1900029347	Zn content	Zn content	CM	Completed	%	36.43	34.0	36.5	39.0	2020-01-02 06:21:32.000
	2001000016	GR_5711_BMZ_BMZ	Steelcord 2*0.30 HT	11/12/2019	BMZ	BMZ	1900029347	ST-test 20m,160C,752	Adh. T-test 20' at 160°C to RM752	CM	Completed	N	410.1	330.0			2020-01-02 06:21:32.000
	2001000016	GR_5711_BMZ_BMZ	Steelcord 2*0.30 HT	11/12/2019	BMZ	BMZ	1900029347	Mass coating	Mass coating	CM	Completed	g/kg	3.481	2.5	3.4	4.3	2020-01-02 06:21:32.000
	2001000016	GR_5711_BMZ_BMZ	Steelcord 2*0.30 HT	11/12/2019	BMZ	BMZ	1900029347	Linear density	Linear density	CM	Completed	dtex	1.13	1.04	1.12	1.2	2020-01-02 06:21:32.000
	2001000016	GR_5711_BMZ_BMZ	Steelcord 2*0.30 HT	11/12/2019	BMZ	BMZ	1900029347	Cord diameter	Cord diameter	CM	Completed	mm	0.6	0.57	0.6	0.63	2020-01-02 06:21:32.000
	2001000016	GR_5711_BMZ_BMZ	Steelcord 2*0.30 HT	11/12/2019	BMZ	BMZ	1900029347	Copper content	Copper content	CM	Completed	%	63.57	61.0	63.5	66.0	2020-01-02 06:21:32.000
	2001000016	GR_5711_BMZ_BMZ	Steelcord 2*0.30 HT	11/12/2019	BMZ	BMZ	1900029347	Breaking strength	Breaking strength	CM	Completed	N	446.0	405.0	440.0		2020-01-02 06:21:32.000
	2001000016	GR_5711_BMZ_BMZ	Steelcord 2*0.30 HT	11/12/2019	BMZ	BMZ	1900029347	Arc height	Arc height	CM	Completed	mm	18.0		20.0	30.0	2020-01-02 06:21:32.000
	2001000016	GR_5711_BMZ_BMZ	Steelcord 2*0.30 HT	11/12/2019	BMZ	BMZ	1900029347	Torsions residual	Torsions residual	CM	Completed	turns	0.2	-3.0	0.15	3.0	2020-01-02 06:21:32.000
	2001000016	GR_5711_BMZ_BMZ	Steelcord 2*0.30 HT	11/12/2019	BMZ	BMZ	1900029347	Low load elongation	Low load elongation	CM	Completed	%	0.05	0.04	0.055	0.09	2020-01-02 06:21:32.000
*/

--test view
select * from COA_VW_VENDOR_QUALITY v
where v.sample_code = '2001000016'




--************************************************************
--LOSSE QUERIES TBV testen op UNILAB/INTERSPEC
--************************************************************
select sc.rq     as request_code
, sc.sc          as sample_code
, gk.value        as material_code
, iip.iivalue     as productiondate
, iis.iivalue     as supplier_code   --MANUFACTURER
, iio.iivalue     as order_number
, pa.pa           as parameter
, pa.description  as parameter_descr
, pa.ss           as ResultParameterstatus
, s.description   as ResultParameterStatusName
, pa.unit         as unit
, pa.value_f      as measured
, spa.low_spec
, spa.target
, spa.high_spec
, pa.exec_end_date as test_date
from utsc      sc
JOIN utscpa    pa  on (pa.sc = sc.sc)
JOIN utss      s   ON (s.ss  = pa.ss)
JOIN utscpaspa spa on (spa.sc = pa.sc  and spa.pg = pa.pg and spa.pa = pa.pa and spa.panode = pa.panode)
JOIN utscgk    gk  on (gk.sc = pa.sc and gk.gk = 'PART_NO' )
LEFT OUTER JOIN utscii  iis  on (iis.sc = pa.sc and iis.ii = 'avSupplierCode' )
LEFT OUTER JOIN utscii  iip  on (iip.sc = pa.sc and iip.ii = 'avProductionDate' )
LEFT OUTER JOIN utscii  iio  on (iio.sc = pa.sc and iio.ii = 'avOrderno' )
where sc.sc like '2%'
and   pa.pg  = 'CoA'
AND   sc.sc = '2001000016'
;

select p.part_no
,      p.description part_description
,      pmf.trade_name          Supplier_Trade_Name
,      mfc.mfc_id
,      mfc.description         Supplier
from part p
left outer join  itprmfc  pmf  on pmf.part_no  = p.part_no
left outer join  ITMFC    mfc  on mfc.mfc_id = pmf.mfc_id
where p.part_no = 'GR_5711_BMZ_BMZ'  
;
--GR_5711_BMZ_BMZ	Steelcord 2*0.30 HT		700393	BMZ


/*
	2001000016	GR_5711_BMZ_BMZ	11/12/2019	BMZ	1900029347	Arc height	Arc height	CM	Completed	mm	18		20	30	02-01-2020 07.21.32.000000000 AM
	2001000016	GR_5711_BMZ_BMZ	11/12/2019	BMZ	1900029347	Breaking strength	Breaking strength	CM	Completed	N	446	405	440		02-01-2020 07.21.32.000000000 AM
	2001000016	GR_5711_BMZ_BMZ	11/12/2019	BMZ	1900029347	Copper content	Copper content	CM	Completed	%	63.57	61	63.5	66	02-01-2020 07.21.32.000000000 AM
	2001000016	GR_5711_BMZ_BMZ	11/12/2019	BMZ	1900029347	Cord diameter	Cord diameter	CM	Completed	mm	0.6	0.57	0.6	0.63	02-01-2020 07.21.32.000000000 AM
	2001000016	GR_5711_BMZ_BMZ	11/12/2019	BMZ	1900029347	Linear density	Linear density	CM	Completed	dtex	1.13	1.04	1.12	1.2	02-01-2020 07.21.32.000000000 AM
	2001000016	GR_5711_BMZ_BMZ	11/12/2019	BMZ	1900029347	Low load elongation	Low load elongation	CM	Completed	%	0.05	0.04	0.055	0.09	02-01-2020 07.21.32.000000000 AM
	2001000016	GR_5711_BMZ_BMZ	11/12/2019	BMZ	1900029347	Mass coating	Mass coating	CM	Completed	g/kg	3.481	2.5	3.4	4.3	02-01-2020 07.21.32.000000000 AM
	2001000016	GR_5711_BMZ_BMZ	11/12/2019	BMZ	1900029347	ST-test 20m,160C,752	Adh. T-test 20' at 160°C to RM752	CM	Completed	N	410.1	330			02-01-2020 07.21.32.000000000 AM
	2001000016	GR_5711_BMZ_BMZ	11/12/2019	BMZ	1900029347	Torsions residual	Torsions residual	CM	Completed	turns	0.2	-3	0.15	3	02-01-2020 07.21.32.000000000 AM
	2001000016	GR_5711_BMZ_BMZ	11/12/2019	BMZ	1900029347	Zn content	Zn content	CM	Completed	%	36.43	34	36.5	39	02-01-2020 07.21.32.000000000 AM
	*/


/*
UTSCAU: select * from utscAU where sc='2002003299'	
2002003299	Specification refere		1	AV_2132S_2

UTSCGK: select * from utscgk where sc='2002003299'
2002003299	Cert_lotnr		500	33091260619-2644
2002003299	Context			500	Release
2002003299	PART_NO			500	GR_2132_OMS_OMS
2002003299	SPEC_TYPE		512	FILL
2002003299	day				500	08
2002003299	isTest			513	0
2002003299	month			500	01
2002003299	partGroup		507	Bought material
2002003299	partGroup		508	Raw material
2002003299	partGroup		509	Ingredients
2002003299	partGroup		510	Chemicals
2002003299	partGroup		511	Fillers
2002003299	scCreateUp		506	Material lab mgt
2002003299	scCreateUp		521	Certificate control
2002003299	scCreateUp		522	Physical lab
2002003299	scCreateUp		523	Chemical lab
2002003299	scCreateUp		524	Preparation lab
2002003299	scListUp		501	Preparation lab
2002003299	scListUp		503	Physical lab
2002003299	scListUp		504	Chemical lab
2002003299	scListUp		505	Material lab mgt
2002003299	scListUp		515	Viewers
2002003299	scListUp		516	Certificate control
2002003299	scListUp		517	Purchasing
2002003299	scListUp		518	QEA
2002003299	scListUp		519	Compounding
2002003299	scListUp		520	Research
2002003299	scReceiverUp	522	Physical lab
2002003299	scReceiverUp	523	Chemical lab
2002003299	scReceiverUp	524	Material lab mgt
2002003299	scReceiverUp	525	Preparation lab
2002003299	scReceiverUp	526	Certificate control
2002003299	week			500	02
2002003299	year			500	2020
*/

select * from utscII where sc='2002003299'	
/*
2002003299	avBoughtPibs	2000000	avPibsLotNr			3000000	0001.04	1900030217			155	23	0	1	0	Lotnr (PIBS)
2002003299	avBoughtPibs	2000000	avProductionDate	4000000	0001.03	26/06/2019			155	92	0	0	0	Production date
2002003299	avBoughtPibs	2000000	avSpecRef			1000000	0001.02	AV_2132S_2			155	46	0	1	0	Specification reference
2002003299	avBoughtPibs	2000000	avSupplierCode		2000000	0001.07	OMSK				155	69	0	1	0	Supplier Code
2002003299	avBoughtRm		1000000	avAssignPg			3000000	0001.02						156	100	0	0	0	Assign Pg
2002003299	avBoughtRm		1000000	avAssignPgButton	2000000	0001.00						402	100	0	0	0	Assign Pg
2002003299	avBoughtRm		1000000	avCertificateLotnr	1000000	0001.01	33091260619-2644	156	50	0	1	0	Lotnr (Certificate)
2002003299	avBoughtRm		1000000	avCoaRemarks		6000000	0001.00						156	150	0	0	0	Remarks
2002003299	avBoughtRm		1000000	avKlars				4000000	0001.00						156	125	0	0	0	KLARS-code
2002003299	avBoughtRm		1000000	avOrderno			7000000	0001.04	1900030217			156	75	0	0	0	Order number
2002003299	avBoughtRm		1000000	avPlantationNR		8000000	0001.00						156	175	0	0	0	Plantation (in case of NR)
2002003299	avBoughtRm		1000000	avRelease			5000000	0001.00	0					156	200	0	0	1	Release on sample
*/	



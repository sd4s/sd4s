--COA query
/*
--result-query-Patrick:
--
Sample code	Material		Vendor code	Parameter			Description			Status	UoM	Measured	Low spec	target value	high spec	Date of execution
--
2001000016	GR_5711_BMZ_BMZ	BMZ			Arc height			Arc height			Completed	mm	18		20	30	02-JAN-20 07.21.32.000000000 AM
2001000016	GR_5711_BMZ_BMZ	BMZ			Breaking strength	Breaking strength	Completed	N	446	405	440		02-JAN-20 07.21.32.000000000 AM
2001000016	GR_5711_BMZ_BMZ	BMZ			Copper content		Copper content		Completed	%	63.57	61	63.5	66	02-JAN-20 07.21.32.000000000 AM
2001000016	GR_5711_BMZ_BMZ	BMZ			Cord diameter		Cord diameter		Completed	mm	0.6	0.57	0.6	0.63	02-JAN-20 07.21.32.000000000 AM
2001000016	GR_5711_BMZ_BMZ	BMZ			Linear density		Linear density		Completed	dtex	1.13	1.04	1.12	1.2	02-JAN-20 07.21.32.000000000 AM
2001000016	GR_5711_BMZ_BMZ	BMZ			Low load elongation	Low load elongation	Completed	%	0.05	0.04	0.055	0.09	02-JAN-20 07.21.32.000000000 AM
2001000016	GR_5711_BMZ_BMZ	BMZ			Mass coating		Mass coating		Completed	g/kg	3.481	2.5	3.4	4.3	02-JAN-20 07.21.32.000000000 AM
2001000016	GR_5711_BMZ_BMZ	BMZ			ST-test 20m,160C,752	Adh. T-test 20' at 160°C to RM752	Completed	N	410.1	330			02-JAN-20 07.21.32.000000000 AM
2001000016	GR_5711_BMZ_BMZ	BMZ			Torsions residual	Torsions residual	Completed	turns	0.2	-3	0.15	3	02-JAN-20 07.21.32.000000000 AM
2001000016	GR_5711_BMZ_BMZ	BMZ			Zn content			Zn content			Completed	%	36.43	34	36.5	39	02-JAN-20 07.21.32.000000000 AM
*/


select sc           sample_code
,      pa           parameter
,      description  description
,      ss           status
,      unit         UoM
,      value_f      Measured
from utscpa  
where sc = '2001000016'
and   pg = 'COA'
;

SELECT * FROM UTSCAU where sc = '2001000016';
--2001000016	Specification refere		1	AV_5711A_2

SELECT * FROM UTSCII WHERE sc = '2001000016';
/*
2001000016	avBoughtPibs	2000000	avPibsLotNr			3000000	0001.04	19-050		155	23	0	1	0	Lotnr (PIBS)	50	I	1		1	1	1	1				W	W	W	W	W	W	W	W	W	W	W	W	W	W	W	W
2001000016	avBoughtPibs	2000000	avProductionDate	4000000	0001.03	11/12/2019	155	92	0	0	0	Production date	20	G	0		1	1	1	1	II	0	AV	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N
2001000016	avBoughtPibs	2000000	avSpecRef			1000000	0001.02	AV_5711A_2	155	46	0	1	0	Specification reference	40	C	3		1	1	1	1				W	W	W	W	W	W	W	W	W	W	W	W	W	W	W	W
2001000016	avBoughtPibs	2000000	avSupplierCode		2000000	0001.07	BMZ			155	69	0	1	0	Supplier Code	40	C	3		1	1	1	1				W	W	W	W	W	W	W	W	W	W	W	W	W	W	W	W
2001000016	avBoughtReinf	1000000	avAssignPg			1000000	0001.02				155	115	0	0	0	Assign Pg	40	C	5		1	1	1	0				W	W	W	W	W	W	W	W	W	W	W	W	W	W	W	W
2001000016	avBoughtReinf	1000000	avAssignPgButton	4000000	0001.00				365	115	0	0	0	Assign Pg	20	P	0		1	1	1	0				W	W	W	W	W	W	W	W	W	W	W	W	W	W	W	W
2001000016	avBoughtReinf	1000000	avCertificateLotnr	5000000	0001.01	19-050		155	46	0	1	0	Lotnr (Certificate)	40	I	1		1	1	1	0				W	W	W	W	W	W	W	W	W	W	W	W	W	W	W	W
2001000016	avBoughtReinf	1000000	avCoaRemarks		7000000	0001.00				155	161	0	0	0	Remarks	80	C	3		1	1	1	1	II	0	AV	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N
2001000016	avBoughtReinf	1000000	avKlars				2000000	0001.00				155	138	0	0	0	KLARS-code	20	I	1		1	1	1	0				W	W	W	W	W	W	W	W	W	W	W	W	W	W	W	W
2001000016	avBoughtReinf	1000000	avOrderno			8000000	0001.04	1900029347	155	69	0	0	0	Order number	80	I	1		1	1	1	0				W	W	W	W	W	W	W	W	W	W	W	W	W	W	W	W
2001000016	avBoughtReinf	1000000	avRelease			3000000	0001.00	0			155	184	0	0	1	Release on sample	40	B	0		1	1	1	0				W	W	W	W	W	W	W	W	W	W	W	W	W	W	W	W
2001000016	avBoughtReinf	1000000	avTestCompoundRef	6000000	0001.00	1903		155	92	0	0	0	Batchno. Test Compound	20	I	1		1	1	1	1	II	0	AV	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N
*/

SELECT ii
,      iivalue  VendorCode
FROM UTSCII 
WHERE sc = '2001000016'
and   ii = 'avSupplierCode'
;

SELECT * 
FROM UTSCPASPA 
WHERE SC = '2001000016'
;
/*
                                                             lowspec  highspec      target  
2001000016	CoA	1000000	Arc height				1000000					30		0	20		0
2001000016	CoA	1000000	Breaking strength		7000000			405				0	440		0
2001000016	CoA	1000000	Copper content			4000000			61		66		0	63.5	0
2001000016	CoA	1000000	Cord diameter			8000000			0.57	0.63	0	0.6		0
2001000016	CoA	1000000	Linear density			9000000			1.04	1.2		0	1.12	0
2001000016	CoA	1000000	Low load elongation		2000000			0.04	0.09	0	0.055	0
2001000016	CoA	1000000	Mass coating			5000000			2.5		4.3		0	3.4		0
2001000016	CoA	1000000	ST-test 20m,160C,752	10000000		330				0			0
2001000016	CoA	1000000	Torsions residual		3000000			-3		3		0	0.15	0
2001000016	CoA	1000000	Zn content				6000000			34		39		0	36.5	0
*/



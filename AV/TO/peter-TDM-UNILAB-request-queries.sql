--REQUEST
select * from utrq;
--
select rq, rt, rt_version, description, creation_date from utrq where creation_date > trunc(sysdate);
/*

ANP2039009M	MT-P: XNP lab	0001.08	Testing XNP mixed on lab	21/9/2020 11:18:50

ANP2039010M	MT-P: FM lab	0001.13	Testing FM mixed on lab	21/9/2020 11:19:41
ANP2039011M	MT-P: XNP lab	0001.08	Testing XNP mixed on lab	21/9/2020 11:20:44
ANP2039012M	MT-P: FM lab	0001.13	Testing FM mixed on lab	21/9/2020 11:23:12
HKW2039013T	T-T: AT Indoor std	0001.11	Testing AT indoor standard	21/9/2020 12:46:26
ROM2039017T	T-TG: PCT indoor std	0001.03	Testing PCT indoor standard	21/9/2020 13:34:14
GKU2039008T	T: PCT indoor std	0001.19	Testing PCT indoor standard	21/9/2020 10:32:38
AAF2039014T	T-TG: PCT indoor std	0001.03	Testing PCT indoor standard	21/9/2020 12:53:32
RHI2039020T	T-O: PCT Intern tyre	0001.04	PCT Ordering Internal Tyres	21/9/2020 14:33:20
RHI2039021T	T: PCT indoor std	0001.19	Testing PCT indoor standard	21/9/2020 15:23:57
RHI2039022T	T: PCT indoor std	0001.19	Testing PCT indoor standard	21/9/2020 15:23:57
RHI2039023T	T: PCT indoor std	0001.19	Testing PCT indoor standard	21/9/2020 15:23:57
MTD2039002T	T-T: AT Indoor std	0001.11	Testing AT indoor standard	21/9/2020 9:20:05
MTD2039004T	T-T: AT Indoor std	0001.11	Testing AT indoor standard	21/9/2020 10:01:52
PAK2039018T	T: PCT indoor std	0001.19	Testing PCT indoor standard	21/9/2020 14:02:50
RZE2039015M	MT-P: XNP lab	0001.08	Testing XNP mixed on lab	21/9/2020 12:54:50
RZE2039016M	MT-P: FM lab	0001.13	Testing FM mixed on lab	21/9/2020 12:58:37
KAD2039000T	T-TG: PCT indoor std	0001.03	Testing PCT indoor standard	21/9/2020 8:54:21
KAD2039001T	T-TG: PCT indoor std	0001.03	Testing PCT indoor standard	21/9/2020 8:55:24
MUT2039003T	S-T: FEM tyre	0001.10	FEM simulations on tyre	21/9/2020 10:00:00
MUT2039005T	S-T: FEM tyre	0001.10	FEM simulations on tyre	21/9/2020 10:13:01
MUT2039006T	S-T: FEM tyre	0001.10	FEM simulations on tyre	21/9/2020 10:14:05
MUT2039007T	S-T: FEM tyre	0001.10	FEM simulations on tyre	21/9/2020 10:31:24
PAK2039019T	T: PCT indoor std	0001.19	Testing PCT indoor standard	21/9/2020 14:24:16
20.623.PAK	T-T: PCT Outdoor	0001.10	Testing PCT outdoor	21/9/2020 14:32:55
20.624.PAK	T-T: PCT Outdoor	0001.10	Testing PCT outdoor	21/9/2020 14:32:55
20.625.PAK	T-T: PCT Outdoor	0001.10	Testing PCT outdoor	21/9/2020 14:32:55
*/

select * from utrq where rt = 'MT-P: XNP lab' and rq='ANP2039009M';

--RTRQAU
select * from utrqau where rq='ANP2039009M';
--no-rows-selected

--RTRQGK
select * from utrqGK where rq='ANP2039009M' order by gk, gkseq;
/*
ANP2039009M	isRelevant		500	1
ANP2039009M	isTest			507	0
ANP2039009M	RequestCode		500	ANP2039009M
ANP2039009M	RqDay			500	21
ANP2039009M	RqMonth			500	09
ANP2039009M	RqReqReadyDate	500	19-10-20
ANP2039009M	RQrqreadyDD		500	19
ANP2039009M	RQrqreadyMM		500	10
ANP2039009M	RQrqreadyYYYY	500	20
ANP2039009M	rqStatusType	500	Relevant
ANP2039009M	rqStatusType	501	In progress
ANP2039009M	rqStatusType	503	Lab Action
ANP2039009M	RqWeek			500	39
ANP2039009M	RqYear			500	2020
ANP2039009M	Workorder		500	RDDD1823TW
*/

--RTGKRQ
select GK, VERSION, DESCRIPTION, value_unique, mandatory,default_value from utgkrq where gk in (select r.gk from utrqgk where rq='ANP2039009M') order by GK
/*
isRelevant		0	isRelevant		0	0	1
isTest			0	isTest			0	0	
RequestCode		0	Request			1	0	
RqDay			0	RqDay			0	0	
RqMonth			0	RqMonth			0	0	
RqReqReadyDate	0	Req ready sort	0	0	
RQrqreadyDD		0	Rq ready D sort	0	0	
RQrqreadyMM		0	Rq ready M sort	0	0	
RQrqreadyYYYY	0	Rq ready Y sort	0	0	
rqStatusType	0	rqStatusType	0	0	
RqWeek			0	RqWeek			0	0	
RqYear			0	RqYear			0	0	
Workorder		0	Workorder		0	0	
*/

--*************************************************************************************************
descr utrt;
--*************************************************************************************************

select count(*) from utrt where effective_till is null;
--62 TYPES nog actueel!!!

select rt, version, description,  from utrt where rt = 'MT-P: XNP lab';
/*
MT-P: XNP lab	0001.00		1/10/2008 14:48:42	1/10/2008 17:22:53	Testing XNP mixed on lab				0	0	0	A	0	DD	0		0		3		0	1	0	Material lab mgt	avScRq		avRqDef-M		R1		0	0			1		0	1	@L	0	@A	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N			
MT-P: XNP lab	0001.01		1/10/2008 17:22:53	8/10/2008 16:45:36	Testing XNP mixed on lab				0	0	0	A	0	DD	0		0		3		0	1	0	Material lab mgt	avScStdPrd		avRqDef		R1		0	0			1		0	1	@L	0	@A	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N			
MT-P: XNP lab	0001.02		8/10/2008 16:45:36	13/10/2008 15:00:51	Testing XNP mixed on lab				0	0	0	A	0	DD	0		0		3		0	1	0	Material lab mgt	avScRq		avRqDefAu		R1		0	0			1		0	1	@L	0	@A	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N			
MT-P: XNP lab	0001.03		13/10/2008 15:00:51	2/12/2009 13:02:36	Testing XNP mixed on lab				0	0	0	A	0	DD	0		0		3		0	1	0	Material lab mgt	avScRq		avRqDefAu		R1		0	0			1		0	1	@L	0	@A	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N			
MT-P: XNP lab	0001.04		2/12/2009 13:02:36	2/12/2009 17:04:27	Testing XNP mixed on lab				0	0	0	A	0	DD	0		0		3		0	1	0	Material lab mgt	avScRq		avRqDefAu		R1		0	0			1		0	1	@L	0	@A	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N			
MT-P: XNP lab	0001.05		2/12/2009 17:04:27	6/6/2012 13:18:56	Testing XNP mixed on lab				0	0	0	S	130	avRtSortOrder	0		0		3		0	1	0	Material lab mgt	avScRq		avRqDefAu		R1		0	0			1		0	1	@L	0	@A	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N		6/6/2012 13:18:56, +02:00	
MT-P: XNP lab	0001.06		6/6/2012 13:18:56	26/7/2016 15:13:28	Testing XNP mixed on lab				0	0	0	S	130	avRtSortOrder	0		0		3		0	1	0	Material lab mgt	avScRq		avRqDefAu		R1		0	0			1		0	1	@L	0	@A	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	6/6/2012 13:18:56, +02:00	26/7/2016 15:13:28, +02:00	
MT-P: XNP lab	0001.07		26/7/2016 15:13:28	22/1/2019 14:02:39	Testing XNP mixed on lab				0	0	0	S	130	avRtSortOrder	0		0		3		0	1	0	Material lab mgt	avScRq		avRqDefAu		R1		0	0			1		0	1	@L	0	@A	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	26/7/2016 15:13:28, +02:00	22/1/2019 13:02:39, +01:00	
MT-P: XNP lab	0001.08	1	22/1/2019 14:02:39						Testing XNP mixed on lab				0	0	0	S	130	avRtSortOrder	0		0		3		0	1	0	Material lab mgt	avScRq		avRqDefAu		R1		0	0			1		0	1	@L	0	@A	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	22/1/2019 13:02:39, +01:00		
*/

--type-attributen
select rt, version, au, au_version, auseq, value from UTRTAU WHERE RT = 'MT-P: XNP lab' order by rt, au, auseq;
/*
MT-P: XNP lab	0001.00	avKindOfSample		1	LabMix
MT-P: XNP lab	0001.01	avKindOfSample		1	LabMix
MT-P: XNP lab	0001.02	avRqTypeCodeId		1	M
MT-P: XNP lab	0001.02	avKindOfSample		2	LabMix
MT-P: XNP lab	0001.03	avRqTypeCodeId		1	M
MT-P: XNP lab	0001.03	avKindOfSample		2	LabMix
MT-P: XNP lab	0001.04	avRqTypeCodeId		1	M
MT-P: XNP lab	0001.04	avKindOfSample		2	LabMix
MT-P: XNP lab	0001.05	avRqTypeCodeId		1	M
MT-P: XNP lab	0001.05	avKindOfSample		2	LabMix
MT-P: XNP lab	0001.06	avRqTypeCodeId		1	M
MT-P: XNP lab	0001.06	avKindOfSample		2	LabMix
MT-P: XNP lab	0001.07	avRqTypeCodeId		1	M
MT-P: XNP lab	0001.07	avKindOfSample		2	LabMix
MT-P: XNP lab	0001.08	avRqTypeCodeId		1	M
MT-P: XNP lab	0001.08	avKindOfSample		2	LabMix
*/

--groupkey
select gk, version, description, mandatory, value_list_tp, default_value from utgkrt  where GK in (SELECT gk from utrtgk where RT = 'MT-P: XNP lab' ) order by gk, version;
/*
isTest			0	isTest					0	F	0
requesterUp		0	requester up (t.b.d)	0	Q	
RtListSortOrder	0	Sortorder in a Rt list	0	F	
SPEC_TYPE		0	specType				0	F	
userProfiles	0	user profiles (t.b.d.)	0	Q	
*/


select rt, version, gk, gk_version, gkseq, value from utrtgk where RT = 'MT-P: XNP lab' order by gk, version;
/*
MT-P: XNP lab	0001.00	isTest		507	1
MT-P: XNP lab	0001.01	isTest		507	0
MT-P: XNP lab	0001.02	isTest		507	0
MT-P: XNP lab	0001.03	isTest		507	0
MT-P: XNP lab	0001.04	isTest		507	0
MT-P: XNP lab	0001.05	isTest		507	0
MT-P: XNP lab	0001.06	isTest		507	0
MT-P: XNP lab	0001.07	isTest		507	0
MT-P: XNP lab	0001.08	isTest		507	0
MT-P: XNP lab	0001.00	requesterUp		500	Compounding
MT-P: XNP lab	0001.01	requesterUp		500	Compounding
MT-P: XNP lab	0001.02	requesterUp		500	Compounding
MT-P: XNP lab	0001.03	requesterUp		500	Compounding
MT-P: XNP lab	0001.04	requesterUp		500	Compounding
MT-P: XNP lab	0001.05	requesterUp		500	Compounding
MT-P: XNP lab	0001.06	requesterUp		500	Compounding
MT-P: XNP lab	0001.07	requesterUp		500	Compounding
MT-P: XNP lab	0001.08	requesterUp		500	Compounding
MT-P: XNP lab	0001.04	RtListSortOrder		508	110
MT-P: XNP lab	0001.05	RtListSortOrder		508	110
MT-P: XNP lab	0001.06	RtListSortOrder		508	110
MT-P: XNP lab	0001.07	RtListSortOrder		508	110
MT-P: XNP lab	0001.08	RtListSortOrder		508	110
MT-P: XNP lab	0001.00	SPEC_TYPE		506	XNP
MT-P: XNP lab	0001.01	SPEC_TYPE		506	XNP
MT-P: XNP lab	0001.02	SPEC_TYPE		506	XNP
MT-P: XNP lab	0001.03	SPEC_TYPE		506	XNP
MT-P: XNP lab	0001.04	SPEC_TYPE		506	XNP
MT-P: XNP lab	0001.05	SPEC_TYPE		506	XNP
MT-P: XNP lab	0001.06	SPEC_TYPE		506	XNP
MT-P: XNP lab	0001.07	SPEC_TYPE		506	XNP
MT-P: XNP lab	0001.08	SPEC_TYPE		506	XNP
MT-P: XNP lab	0001.00	userProfiles		505	Chemical lab
MT-P: XNP lab	0001.00	userProfiles		504	Material lab mgt
MT-P: XNP lab	0001.00	userProfiles		501	Compounding
MT-P: XNP lab	0001.00	userProfiles		502	Preparation lab
MT-P: XNP lab	0001.00	userProfiles		503	Physical lab
MT-P: XNP lab	0001.01	userProfiles		504	Material lab mgt
MT-P: XNP lab	0001.01	userProfiles		505	Chemical lab
MT-P: XNP lab	0001.01	userProfiles		503	Physical lab
MT-P: XNP lab	0001.01	userProfiles		502	Preparation lab
MT-P: XNP lab	0001.01	userProfiles		501	Compounding
MT-P: XNP lab	0001.02	userProfiles		501	Compounding
MT-P: XNP lab	0001.02	userProfiles		503	Physical lab
MT-P: XNP lab	0001.02	userProfiles		504	Material lab mgt
MT-P: XNP lab	0001.02	userProfiles		505	Chemical lab
MT-P: XNP lab	0001.02	userProfiles		502	Preparation lab
MT-P: XNP lab	0001.03	userProfiles		501	Compounding
MT-P: XNP lab	0001.03	userProfiles		502	Preparation lab
MT-P: XNP lab	0001.03	userProfiles		503	Physical lab
MT-P: XNP lab	0001.03	userProfiles		504	Material lab mgt
MT-P: XNP lab	0001.03	userProfiles		505	Chemical lab
MT-P: XNP lab	0001.04	userProfiles		501	Compounding
MT-P: XNP lab	0001.04	userProfiles		502	Preparation lab
MT-P: XNP lab	0001.04	userProfiles		503	Physical lab
MT-P: XNP lab	0001.04	userProfiles		504	Material lab mgt
MT-P: XNP lab	0001.04	userProfiles		505	Chemical lab
MT-P: XNP lab	0001.05	userProfiles		505	Chemical lab
MT-P: XNP lab	0001.05	userProfiles		504	Material lab mgt
MT-P: XNP lab	0001.05	userProfiles		503	Physical lab
MT-P: XNP lab	0001.05	userProfiles		502	Preparation lab
MT-P: XNP lab	0001.05	userProfiles		501	Compounding
MT-P: XNP lab	0001.06	userProfiles		505	Chemical lab
MT-P: XNP lab	0001.06	userProfiles		504	Material lab mgt
MT-P: XNP lab	0001.06	userProfiles		503	Physical lab
MT-P: XNP lab	0001.06	userProfiles		502	Preparation lab
MT-P: XNP lab	0001.06	userProfiles		509	Process tech. VF
MT-P: XNP lab	0001.06	userProfiles		501	Compounding
MT-P: XNP lab	0001.07	userProfiles		501	Compounding
MT-P: XNP lab	0001.07	userProfiles		509	Process tech. VF
MT-P: XNP lab	0001.07	userProfiles		505	Chemical lab
MT-P: XNP lab	0001.07	userProfiles		504	Material lab mgt
MT-P: XNP lab	0001.07	userProfiles		503	Physical lab
MT-P: XNP lab	0001.07	userProfiles		502	Preparation lab
MT-P: XNP lab	0001.08	userProfiles		505	Chemical lab
MT-P: XNP lab	0001.08	userProfiles		504	Material lab mgt
MT-P: XNP lab	0001.08	userProfiles		503	Physical lab
MT-P: XNP lab	0001.08	userProfiles		502	Preparation lab
MT-P: XNP lab	0001.08	userProfiles		501	Compounding
MT-P: XNP lab	0001.08	userProfiles		509	Process tech. VF
*/











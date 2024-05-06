--UTSS - status
select ss||';'|| name from utss order by ss;
/*
SS NAME
-- --------------------
2P To PIBS
@/ Historic
@< Checked In
@> Checked Out
@@ Default
@A Approved
@C Cancelled
@E In Editing
@O Obsolete
@P Planned
@T In Test
@~ Initial
AV Available
BL Blocked
CF Configured
CM Completed
DP Disposition
DV Development
ER Error
FA For Approval
FR For Review
GS Get SQL defaults
IE In Execution
IR Irrelevant
OR Ordered
OS Out of spec
OW Out of warning
RE Ready for execution
RJ Rejected
SC Out of Spec Conf.
ST Stopped
SU Submit
TC To Configure
TT Toggle Template
TV To validate
VA Validated
WA Wait
WC Out of Warning Conf.
WH Warehouse
--
--ACTUEEL = IN ('@A')
*/

--***********************************************
--UTRT
--***********************************************
/*
RT					VARCHAR2(20 CHAR)	No		1	name of the request type - unique
VERSION				VARCHAR2(20 CHAR)	No		2	
VERSION_IS_CURRENT	CHAR(1 CHAR)	Yes		3	
EFFECTIVE_FROM		TIMESTAMP(0) WITH LOCAL TIME ZONE	Yes		4	
EFFECTIVE_TILL		TIMESTAMP(0) WITH LOCAL TIME ZONE	Yes		5	
DESCRIPTION			VARCHAR2(40 CHAR)	Yes		6	
DESCRIPTION2		VARCHAR2(40 CHAR)	Yes		7	
DESCR_DOC			VARCHAR2(40 CHAR)	Yes		8	
DESCR_DOC_VERSION	VARCHAR2(20 CHAR)	Yes		9	
IS_TEMPLATE			CHAR(1 CHAR)	Yes		10	
CONFIRM_USERID		CHAR(1 CHAR)	Yes		11	[1/0]
NR_PLANNED_RQ		NUMBER(3,0)	Yes		12	
FREQ_TP				CHAR(1 CHAR)	Yes		13	
FREQ_VAL			NUMBER(5,0)	No		14	
FREQ_UNIT			VARCHAR2(20 CHAR)	Yes		15	
INVERT_FREQ			CHAR(1 CHAR)	Yes		16	
LAST_SCHED			TIMESTAMP(0) WITH LOCAL TIME ZONE	Yes		17	last scheduled date + time
LAST_CNT			NUMBER(5,0)	No		18	
LAST_VAL			VARCHAR2(40 CHAR)	Yes		19	
PRIORITY			NUMBER(3,0)	Yes		20	[ + INDICATOR] 
LABEL_FORMAT		VARCHAR2(20 CHAR)	Yes		21	label format used for the requests
ALLOW_ANY_ST		CHAR(1 CHAR)	Yes		22	[1/0] When adding samples dynamically to existing requests, this flag determines which list of sample types will be shown (to select from and create samples). 
ALLOW_NEW_SC		CHAR(1 CHAR)	Yes		23	[1/0]
ADD_STPP			CHAR(1 CHAR)	Yes		24	[1/0] Add sample type parameter profile. When this flag is set, the parameter profiles assigned to the sample types of the current request type are attached to the samples of the corresponding requests (on top of the parameter profiles assigned in the parameter profile template of the request type itself  
PLANNED_RESPONSIBLE	VARCHAR2(20 CHAR)	Yes		25	
SC_UC				VARCHAR2(20 CHAR)	Yes		26	
SC_UC_VERSION		VARCHAR2(20 CHAR)	Yes		27	
RQ_UC				VARCHAR2(20 CHAR)	Yes		28	unique code mask used for the requests of a certain request type; defines the code generation algorithm for the request code.
RQ_UC_VERSION		VARCHAR2(20 CHAR)	Yes		29	
RQ_LC				VARCHAR2(2 CHAR)	Yes		30	
RQ_LC_VERSION		VARCHAR2(20 CHAR)	Yes		31	
INHERIT_AU			CHAR(1 CHAR)	Yes		32	
INHERIT_GK			CHAR(1 CHAR)	Yes		33	
LAST_COMMENT		VARCHAR2(255 CHAR)	Yes		34	
RT_CLASS			VARCHAR2(2 CHAR)	Yes		35	
LOG_HS				CHAR(1 CHAR)	Yes		36	
LOG_HS_DETAILS		CHAR(1 CHAR)	Yes		37	
ALLOW_MODIFY		CHAR(1 CHAR)	Yes		38	
ACTIVE				CHAR(1 CHAR)	Yes		39	
LC					VARCHAR2(2 CHAR)	Yes		40	
LC_VERSION			VARCHAR2(20 CHAR)	Yes		41	
SS					VARCHAR2(2 CHAR)	Yes		42	
AR1					CHAR(1 CHAR)	Yes	'W'	43	
AR2					CHAR(1 CHAR)	Yes	'W'	44	
AR3					CHAR(1 CHAR)	Yes	'W'	45	
AR4					CHAR(1 CHAR)	Yes	'W'	46	
AR5					CHAR(1 CHAR)	Yes	'W'	47	
AR6					CHAR(1 CHAR)	Yes	'W'	48	
AR7					CHAR(1 CHAR)	Yes	'W'	49	
AR8					CHAR(1 CHAR)	Yes	'W'	50	
AR9					CHAR(1 CHAR)	Yes	'W'	51	
AR10				CHAR(1 CHAR)	Yes	'W'	52	
AR11				CHAR(1 CHAR)	Yes	'W'	53	
AR12				CHAR(1 CHAR)	Yes	'W'	54	
AR13				CHAR(1 CHAR)	Yes	'W'	55	
AR14				CHAR(1 CHAR)	Yes	'W'	56	
AR15				CHAR(1 CHAR)	Yes	'W'	57	
AR16				CHAR(1 CHAR)	Yes	'W'	58	
EFFECTIVE_FROM_TZ	TIMESTAMP(0) WITH TIME ZONE	Yes		59	
EFFECTIVE_TILL_TZ	TIMESTAMP(0) WITH TIME ZONE	Yes		60	
LAST_SCHED_TZ		TIMESTAMP(0) WITH TIME ZONE	Yes		61	
*/

select RT ||';'|| version ||';'|| effective_from ||';'|| effective_till ||';'|| DESCRIPTION ||';'|| is_template ||';'|| lc ||';'|| ss
from utrt
where version_is_current = 1
;
/*
M-F: AT					0001.00	16-12-2009 02.21.15.000000000 PM		Manufacturing AT production		0	@L	@A
M-F: Component			0001.12	10-08-2012 11.57.22.000000000 AM		Manufacture component			1	@L	@A
M-F: Composites			0001.14	24-11-2015 08.27.31.000000000 AM		Manufacture composites			0	@L	@A
M-F: FM					0001.17	04-02-2015 08.07.30.000000000 AM		Manufacturing FM production		0	@L	@A
M-F: PCT				0001.12	07-07-2020 03.05.57.000000000 PM		Manufacturing PCT production	0	@L	@A
M-F: SM					0001.00	23-03-2010 02.47.26.000000000 PM		Manufacturing SM production		0	@L	@A
M-F: XNP				0001.11	04-02-2015 10.58.34.000000000 AM		Manufacturing XNP production	0	@L	@A
M-O: Raw Materials		0001.02	09-09-2020 11.21.06.000000000 AM		Order Raw Materials				0	@L	@A
MT-P: FM lab			0001.14	15-02-2022 03.18.31.000000000 PM		Testing FM mixed on lab			0	@L	@A
MT-P: XNP				0001.24	12-04-2022 09.38.33.000000000 AM		isTest1 gebruik voor testen		0	@L	@A
MT-P: XNP lab			0001.09	15-02-2022 03.21.53.000000000 PM		Testing XNP mixed on lab		0	@L	@A
S-T: FEM OHT			0001.01	29-11-2022 07.09.48.000000000 PM		FEM simulations on tyre			0	@L	@A
S-T: FEM tyre			0001.11	14-04-2021 11.18.43.000000000 AM		FEM simulations on tyre			1	@L	@A
T-C: Legislation		0001.02	16-10-2017 03.40.15.000000000 PM		Legislation testing				0	@L	@A
T-CP: Airmaster			0001.02	11-08-2020 04.04.24.000000000 PM		Testing Airmaster on lab		0	@L	@A
T-CP: BBQ				0001.04	09-05-2012 08.28.50.000000000 AM		Testing FM on material lab		0	@L	@A
T-CP: Comp analysis		0001.20	05-10-2021 01.52.09.000000000 PM		Testing Competitor Analysis on lab	0	@L	@A
T-CP: General lab		0001.10	01-06-2017 10.25.24.000000000 AM		General Rq for testing on lab	0	@L	@A
T-O: PCT Intern tyre	0001.04	02-04-2020 04.08.46.000000000 PM		PCT Ordering Internal Tyres		0	@L	@A
T-O: PCT Ordering		0001.01	18-11-2020 11.50.51.000000000 AM		Ordering Tyres					0	@L	@A
T-O: PCT Ordering BM	0002.00	02-04-2020 04.09.23.000000000 PM		Order PCT for Benchmark			0	@L	@A
T-O: PCT transport		0001.11	14-09-2020 03.35.07.000000000 PM		PCT Transport Request			0	@L	@A
T-P: Component			0001.10	27-01-2021 08.37.47.000000000 AM		Testing part components lab		0	@L	@A
T-P: Composites			0001.12	26-01-2021 11.07.44.000000000 AM		Testing Composites on material lab	0	@L	@A
T-P: FM					0001.17	04-07-2014 08.29.00.000000000 AM		Testing FM on material lab		0	@L	@A
T-P: FM blend			0001.09	08-09-2014 09.11.36.000000000 AM		Testing FM on material lab with blending	0	@L	@A
T-P: Raw materials		0001.14	27-01-2021 08.19.16.000000000 AM		Testing raw materials			0	@L	@A
T-P: Reinforcement		0001.14	05-12-2022 10.42.00.000000000 AM		Testing Reinforcement on lab	0	@L	@A
T-P: XNP				0001.07	04-07-2014 08.29.33.000000000 AM		Testing XNP on material lab		0	@L	@A
T-S: Surface scan		0001.01	04-11-2021 11.15.14.000000000 AM		Surface scan					0	@L	@A
T-T: AT Indoor std		0001.12	27-10-2021 03.44.05.000000000 PM		Testing AT indoor standard		0	@L	@A
T-T: PCT Indoor BM		0001.01	06-04-2016 02.55.36.000000000 PM		Benchmark PCT Indoor			0	@L	@A
T-T: PCT Outdoor		0001.14	21-12-2022 11.49.00.000000000 AM		Testing PCT outdoor				0	@L	@A
T-T: PCT Outdoor BM		0001.03	19-07-2019 03.31.13.000000000 PM		Benchmark PCT outdoor			0	@L	@A
T-T: PCT Outdoor z I	0001.01	16-10-2015 08.44.13.000000000 AM		Testing PCT outdoor zone India	0	@L	@A
T-T: PCT RnD Indoor		0001.10	11-10-2022 01.24.54.000000000 PM		PCT RnD Indoor testing			0	@L	@A
T-T: PCT Wear			0001.11	16-11-2020 02.38.03.000000000 PM		Testing PCT Wear				0	@L	@A
T-T: SM indoor std		0001.04	19-07-2019 03.32.22.000000000 PM		Testing SM indoor standard		0	@L	@A
T-T: TWT Outdoor		0001.00	18-03-2020 01.54.59.000000000 PM		Testing TWT outdoor				0	@L	@A
T-T: TWT indoor std		0001.03	30-10-2020 11.38.08.000000000 AM		Testing TWT indoor standard		0	@L	@A
T-TG TBR indoor std		0001.00	05-12-2019 03.07.08.000000000 PM		Testing TBR indoor standard		0	@L	@A
T-TG: PCT indoor std	0001.04	26-08-2021 11.34.01.000000000 AM		Testing PCT indoor standard GYO	0	@L	@A
T: PCT indoor std		0001.27	22-06-2022 04.20.55.000000000 PM		Testing PCT indoor standard		1	@L	@A
UL_TEST_Rq001			0001.02	19-07-2016 10.56.59.000000000 AM		Testing FM on material lab		0	@L	@A
Z-Z: PCT Indoor std		0001.00	28-05-2011 03.48.14.000000000 PM		Unilab Testcase					0	@L	@A
*/

--HOW MANY REQUESTS AVAILABLE RELATED TO REQUEST-TYPE
select rt.RT ||';'||  rq.ss ||';'|| count(*) aantal_rq
from utrt rt
,    utrq rq
where rt.version_is_current = 1
and   rt.rt = rq.rt
and   rt.ss = '@A'
--and   rq.ss in ('@A')
group by rt.rt, rq.ss
order by rt.rt, rq.ss
;
/*
RT                   SS   COUNT(*)
-------------------- -- ----------
M-F: AT              @C          6
M-F: AT              DV          2
M-F: Component       @C        184
M-F: Component       AV          3
M-F: Component       CM        360
M-F: Component       DV         14
M-F: Component       RJ          4
M-F: Composites      @C        112
M-F: Composites      @P          1
M-F: Composites      AV          9
M-F: Composites      CM        104
M-F: Composites      DV          9
M-F: Composites      SU         18
M-F: FM              @C        410
M-F: FM              @P          8
M-F: FM              AV        143
M-F: FM              CM       1559
M-F: FM              DV         54
M-F: FM              RJ         13
M-F: FM              SU          1
M-F: PCT             @C        337
M-F: PCT             @P         55
M-F: PCT             AV        441
M-F: PCT             CM         35
M-F: PCT             DV         40
M-F: PCT             RJ          2
M-F: PCT             SU         13
M-F: SM              @C          2
M-F: SM              CM          1
M-F: XNP             @C        447
M-F: XNP             @P         35
M-F: XNP             AV         94
M-F: XNP             CM       1412
M-F: XNP             DV         42
M-F: XNP             RJ         10
M-F: XNP             SU         20
M-O: Raw Materials   @C         76
M-O: Raw Materials   AV          4
M-O: Raw Materials   CM         28
M-O: Raw Materials   DV          5
MT-P: FM lab         @C        450
MT-P: FM lab         AV         23
MT-P: FM lab         CM       3931
MT-P: FM lab         DV         33
MT-P: FM lab         RJ         16
MT-P: FM lab         SU          5
MT-P: XNP            @C        103
MT-P: XNP            AV          7
MT-P: XNP            CM         31
MT-P: XNP            DV          9
MT-P: XNP lab        @C        383
MT-P: XNP lab        AV         10
MT-P: XNP lab        CM       3987
MT-P: XNP lab        DV         34
MT-P: XNP lab        RJ         14
MT-P: XNP lab        SU          7
S-T: FEM OHT         @C          2
S-T: FEM OHT         AV         15
S-T: FEM OHT         CM          6
S-T: FEM OHT         DV          3
S-T: FEM tyre        @C        444
S-T: FEM tyre        AV        531
S-T: FEM tyre        CM        852
S-T: FEM tyre        DV        140
T-C: Legislation     @C         31
T-C: Legislation     AV          3
T-C: Legislation     CM          6
T-C: Legislation     DV          1
T-C: Legislation     RJ          1
T-CP: Airmaster      @C          8
T-CP: Airmaster      @P          1
T-CP: Airmaster      AV          1
T-CP: Airmaster      CM         48
T-CP: Airmaster      DV          3
T-CP: BBQ            @C         99
T-CP: BBQ            AV          4
T-CP: BBQ            CM        138
T-CP: BBQ            DV          5
T-CP: BBQ            RJ          1
T-CP: Comp analysis  @C        151
T-CP: Comp analysis  @P          7
T-CP: Comp analysis  AV          8
T-CP: Comp analysis  CM        378
T-CP: Comp analysis  DV         19
T-CP: Comp analysis  RJ         11
T-CP: General lab    @C        282
T-CP: General lab    @P          3
T-CP: General lab    AV         10
T-CP: General lab    CM       2047
T-CP: General lab    DV         44
T-CP: General lab    RJ         18
T-CP: General lab    SU          3
T-O: PCT Intern tyre @C         52
T-O: PCT Intern tyre AV          1
T-O: PCT Intern tyre CM        376
T-O: PCT Intern tyre DV         13
T-O: PCT Ordering    @C         16
T-O: PCT Ordering    AV          8
T-O: PCT Ordering    CM         49
T-O: PCT Ordering    DV          3
T-O: PCT Ordering BM @C         73
T-O: PCT Ordering BM AV         11
T-O: PCT Ordering BM CM        426
T-O: PCT Ordering BM DV         15
T-O: PCT transport   @C         19
T-O: PCT transport   AV         18
T-O: PCT transport   CM          7
T-O: PCT transport   DV          4
T-P: Component       @C        120
T-P: Component       AV          3
T-P: Component       CM        377
T-P: Component       DV         17
T-P: Component       RJ          4
T-P: Composites      @C        179
T-P: Composites      @P          5
T-P: Composites      AV          8
T-P: Composites      CM        677
T-P: Composites      DV         24
T-P: Composites      RJ          8
T-P: Composites      SU          8
T-P: Composites      TV          2
T-P: FM              @C        871
T-P: FM              @P          3
T-P: FM              AV         24
T-P: FM              CM       5838
T-P: FM              DV         72
T-P: FM              RJ         32
T-P: FM              SU          6
T-P: FM blend        @C        383
T-P: FM blend        @P          7
T-P: FM blend        AV         10
T-P: FM blend        CM       2835
T-P: FM blend        DV         31
T-P: FM blend        RJ         18
T-P: FM blend        SU          5
T-P: Raw materials   @C        127
T-P: Raw materials   @P          1
T-P: Raw materials   AV          5
T-P: Raw materials   CM        551
T-P: Raw materials   DV         18
T-P: Raw materials   RJ          4
T-P: Reinforcement   @C        117
T-P: Reinforcement   @P          2
T-P: Reinforcement   AV          2
T-P: Reinforcement   CM        455
T-P: Reinforcement   DV         15
T-P: Reinforcement   RJ          3
T-P: XNP             @C        383
T-P: XNP             @P          7
T-P: XNP             AV          4
T-P: XNP             CM       2886
T-P: XNP             DV         58
T-P: XNP             RJ         23
T-P: XNP             SU          3
T-S: Surface scan    @C          9
T-S: Surface scan    AV          3
T-S: Surface scan    CM          2
T-T: AT Indoor std   @C        217
T-T: AT Indoor std   @P          3
T-T: AT Indoor std   AV         27
T-T: AT Indoor std   CM       1756
T-T: AT Indoor std   DV         13
T-T: AT Indoor std   SU          5
T-T: PCT Indoor BM   @C         75
T-T: PCT Indoor BM   CM         18
T-T: PCT Indoor BM   DV         17
T-T: PCT Indoor BM   SU          1
T-T: PCT Outdoor     @C       1429
T-T: PCT Outdoor     @P          2
T-T: PCT Outdoor     AV        146
T-T: PCT Outdoor     CM       4785
T-T: PCT Outdoor     DV        147
T-T: PCT Outdoor     RJ         90
T-T: PCT Outdoor     SU         36
T-T: PCT Outdoor     TV         10
T-T: PCT Outdoor BM  @C          5
T-T: PCT Outdoor BM  DV          2
T-T: PCT Outdoor z I @C        161
T-T: PCT Outdoor z I @P          1
T-T: PCT Outdoor z I AV        164
T-T: PCT Outdoor z I CM        330
T-T: PCT Outdoor z I DV        192
T-T: PCT RnD Indoor  @C        172
T-T: PCT RnD Indoor  AV         38
T-T: PCT RnD Indoor  CM        329
T-T: PCT RnD Indoor  DV         13
T-T: PCT RnD Indoor  RJ          3
T-T: PCT RnD Indoor  SU          2
T-T: PCT RnD Indoor  TV          5
T-T: PCT Wear        @C        162
T-T: PCT Wear        AV         16
T-T: PCT Wear        CM        279
T-T: PCT Wear        DV          3
T-T: PCT Wear        RJ         13
T-T: PCT Wear        SU          2
T-T: SM indoor std   @C         62
T-T: SM indoor std   AV          5
T-T: SM indoor std   CM        421
T-T: SM indoor std   DV          9
T-T: SM indoor std   RJ          3
T-T: SM indoor std   SU          1
T-T: TWT Outdoor     @C          2
T-T: TWT Outdoor     CM          3
T-T: TWT Outdoor     DV          1
T-T: TWT indoor std  @C         73
T-T: TWT indoor std  AV          2
T-T: TWT indoor std  CM          6
T-T: TWT indoor std  DV          7
T-TG TBR indoor std  @C          4
T-TG TBR indoor std  AV          3
T-TG TBR indoor std  CM          1
T-TG TBR indoor std  DV          4
T-TG TBR indoor std  RJ          4
T-TG TBR indoor std  SU          2
T-TG: PCT indoor std @C        683
T-TG: PCT indoor std @P          1
T-TG: PCT indoor std AV        197
T-TG: PCT indoor std CM       4299
T-TG: PCT indoor std DV        246
T-TG: PCT indoor std RJ         33
T-TG: PCT indoor std ST          1
T-TG: PCT indoor std SU         43
T-TG: PCT indoor std TV          9
T: PCT indoor std    @C       2286
T: PCT indoor std    @P          2
T: PCT indoor std    AV        175
T: PCT indoor std    CM      12197
T: PCT indoor std    DV        308
T: PCT indoor std    RJ         74
T: PCT indoor std    ST          2
T: PCT indoor std    SU          1
T: PCT indoor std    TV          2
UL_TEST_Rq001        @C          1
UL_TEST_Rq001        CM          2
UL_TEST_Rq001        DV          9
Z-Z: PCT Indoor std  @C          2
Z-Z: PCT Indoor std  AV          2
Z-Z: PCT Indoor std  CM          1
Z-Z: PCT Indoor std  DV          4

239 rows selected.
*/

--***********************************************
--UTST
--***********************************************
/*
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 ST                                        NOT NULL VARCHAR2(20 CHAR)
 VERSION                                   NOT NULL VARCHAR2(20 CHAR)
 VERSION_IS_CURRENT                                 CHAR(1 CHAR)
 EFFECTIVE_FROM                                     TIMESTAMP(0) WITH LOCAL TIMEZONE
 EFFECTIVE_TILL                                     TIMESTAMP(0) WITH LOCAL TIMEZONE
 DESCRIPTION                                        VARCHAR2(40 CHAR)
 DESCRIPTION2                                       VARCHAR2(40 CHAR)
 IS_TEMPLATE                                        CHAR(1 CHAR)
 CONFIRM_USERID                                     CHAR(1 CHAR)
 SHELF_LIFE_VAL                            NOT NULL NUMBER(3)
 SHELF_LIFE_UNIT                                    VARCHAR2(20 CHAR)
 NR_PLANNED_SC                                      NUMBER(3)
 FREQ_TP                                            CHAR(1 CHAR)
 FREQ_VAL                                  NOT NULL NUMBER(5)
 FREQ_UNIT                                          VARCHAR2(20 CHAR)
 INVERT_FREQ                                        CHAR(1 CHAR)
 LAST_SCHED                                         TIMESTAMP(0) WITH LOCAL TIMEZONE
 LAST_CNT                                  NOT NULL NUMBER(5)
 LAST_VAL                                           VARCHAR2(40 CHAR)
 PRIORITY                                           NUMBER(3)
 LABEL_FORMAT                                       VARCHAR2(20 CHAR)
 DESCR_DOC                                          VARCHAR2(40 CHAR)
 DESCR_DOC_VERSION                                  VARCHAR2(20 CHAR)
 ALLOW_ANY_PP                                       CHAR(1 CHAR)
 SC_UC                                              VARCHAR2(20 CHAR)
 SC_UC_VERSION                                      VARCHAR2(20 CHAR)
 SC_LC                                              VARCHAR2(2 CHAR)
 SC_LC_VERSION                                      VARCHAR2(20 CHAR)
 INHERIT_AU                                         CHAR(1 CHAR)
 INHERIT_GK                                         CHAR(1 CHAR)
 LAST_COMMENT                                       VARCHAR2(255 CHAR)
 ST_CLASS                                           VARCHAR2(2 CHAR)
 LOG_HS                                             CHAR(1 CHAR)
 LOG_HS_DETAILS                                     CHAR(1 CHAR)
 ALLOW_MODIFY                                       CHAR(1 CHAR)
 ACTIVE                                             CHAR(1 CHAR)
 LC                                                 VARCHAR2(2 CHAR)
 LC_VERSION                                         VARCHAR2(20 CHAR)
 SS                                                 VARCHAR2(2 CHAR)
 AR1                                                CHAR(1 CHAR)
 AR2                                                CHAR(1 CHAR)
 AR3                                                CHAR(1 CHAR)
 AR4                                                CHAR(1 CHAR)
 AR5                                                CHAR(1 CHAR)
 AR6                                                CHAR(1 CHAR)
 AR7                                                CHAR(1 CHAR)
 AR8                                                CHAR(1 CHAR)
 AR9                                                CHAR(1 CHAR)
 AR10                                               CHAR(1 CHAR)
 AR11                                               CHAR(1 CHAR)
 AR12                                               CHAR(1 CHAR)
 AR13                                               CHAR(1 CHAR)
 AR14                                               CHAR(1 CHAR)
 AR15                                               CHAR(1 CHAR)
 AR16                                               CHAR(1 CHAR)
 EFFECTIVE_FROM_TZ                                  TIMESTAMP(0) WITH TIME ZONE
 EFFECTIVE_TILL_TZ                                  TIMESTAMP(0) WITH TIME ZONE
 LAST_SCHED_TZ                                      TIMESTAMP(0) WITH TIME ZONE
*/

select ST, version, effective_from, effective_till, DESCRIPTION, is_template, lc, ss
from utst st
where st.version_is_current = 1
;
/*
GF_2454520QPPXW      0006.01              03-JUN-23 09.00.18 AM                                                                                                                                   245/45R20 103W Quatrac Pro+ XL           0 ST @A
EF_V215/55R17AXWX    0017.01              09-MAY-23 09.01.18 AM                                                                                                                                   215/55R17 98V XL Aspire XP Winter        0 ST @A
EF_V215/50R17AXWX    0016.01              09-MAY-23 09.00.18 AM                                                                                                                                   215/50  R 17 95V XL Aspire XP Winter     0 ST @A
EF_V205/50R17AXWX    0016.01              09-MAY-23 09.01.18 AM                                                                                                                                   205/50  R 17 93V XL Aspire XP Winter     0 ST @A
EF_T225/55R16NO2X    0016.01              09-MAY-23 09.01.18 AM                                                                                                                                   225/55  R 16  99T NORDTRAC2 XL           0 ST @A
EF_T225/45R17NO2X    0016.01              09-MAY-23 09.01.18 AM                                                                                                                                   225/45  R 17  94T NORD-TRAC 2 XL         0 ST @A
EF_T225/40R18NO2X    0023.01              09-MAY-23 09.01.18 AM                                                                                                                                   225/40  R 18  92T NORD-TRAC 2 XL         0 ST @A
EF_T215/60R17NO2X    0018.01              09-MAY-23 09.01.18 AM                                                                                                                                   215/60  R 17  100T NORD-TRAC 2 XL        0 ST @A
EF_T215/60R16NO2X    0018.01              09-MAY-23 09.01.18 AM                                                                                                                                   215/60  R 16  99T NORDTRAC2 extra load   0 ST @A
EF_T215/55R16NO2X    0015.01              09-MAY-23 09.01.18 AM                                                                                                                                   215/55  R 16  97T NORDTRAC2 extra load   0 ST @A
EF_T205/55R16NO2X    0022.01              09-MAY-23 09.00.18 AM                                                                                                                                   205/55  R 16  94T NORDTRAC 2 extra load  0 ST @A
EF_T195/65R15NO2X    0019.01              09-MAY-23 09.01.18 AM                                                                                                                                   195/65  R 15  95T NORDTRAC2 extra load   0 ST @A
EF_T185/60R15NO2X    0021.01              09-MAY-23 09.01.18 AM                                                                                                                                   185/60  R 15  88T NORDTRAC2 extra load   0 ST @A
EF_H235/60R18AXWX    0018.01              09-MAY-23 09.00.18 AM                                                                                                                                   235/60R18 107H XL Aspire XP Winter       0 ST @A
EF_H225/60R17AXWX    0017.01              09-MAY-23 09.01.18 AM                                                                                                                                   225/60R17 103H XL Aspire XP Winter       0 ST @A
EF_H225/45R17AXW     0018.01              09-MAY-23 09.00.18 AM                                                                                                                                   225/45R17 91H Aspire XP Winter           0 ST @A
EF_H215/60R17AXW     0017.01              09-MAY-23 09.01.18 AM                                                                                                                                   215/60R17 96H Aspire XP Winter           0 ST @A
EF_H195/55R20WPRX    0020.01              09-MAY-23 09.01.18 AM                                                                                                                                   195/55R20 95H Wintrac Pro XL             0 ST @A
XGF_BNA5S20E2_FEA    0004.01              09-MAY-23 11.53.18 AM                                                                                                                                   255/45R20 BMW BNA5S20E Loop - FEA        0 ST @A
GF_2356517WPRXV      0005.01              09-MAY-23 11.53.18 AM                                                                                                                                   235/65R17 108V XL Wintrac Pro            0 ST @A
XGF_G23C998B         0002.01              10-MAY-23 09.00.18 AM                                                                                                                                   255/50R20 109Y Quatrac Pro XL            0 ST @A
XGF_G23C998A         0002.01              10-MAY-23 09.00.18 AM                                                                                                                                   255/50R20 109Y Quatrac Pro XL            0 ST @A
EF_Y305/35R21WPRX    0018.01              01-JUN-23 09.00.18 AM                                                                                                                                   305/35R21 109Y Wintrac Pro XL            0 ST @A
GF_2255519QPPXW      0010.01              03-JUN-23 09.00.18 AM                                                                                                                                   225/55R19 103W Quatrac Pro+ XL           0 ST @A
...
*/
--11613

--PRODUCTION-SAMPLE-TYPES
select  ST ||';'|| version ||';'|| effective_from ||';'|| effective_till ||';'|| DESCRIPTION ||';'|| is_template ||';'|| lc ||';'|| ss
from utst st
where st.version_is_current = 1
and  (  st.st not like 'T%')
;
--11395x

select ST ||';'|| version ||';'|| effective_from ||';'|| effective_till ||';'|| DESCRIPTION ||';'|| is_template ||';'|| lc ||';'|| ss
from utst st
where st.version_is_current = 1
and  (  st.st like 'T%')
;
/*
ST                   VERSION              EFFECTIVE_FROM                                                              EFFECTIVE_TILL                                                              DESCRIPTION                              I LC SS
-------------------- -------------------- --------------------------------------------------------------------------- --------------------------------------------------------------------------- ---------------------------------------- - -- --
T-C: Legislation     0001.03              17-OCT-17 11.24.55 AM                                                                                                                                   Legislation testing                      0 @L @A
T-CP: Airmaster      0001.02              11-AUG-20 11.27.38 AM                                                                                                                                   Testing Airmaster on lab                 0 @L @A
T-CP: BBQ IP         0001.00              02-APR-19 02.13.55 PM                                                                                                                                   BBQ Intermediate products                0 @L @A
T-CP: BBQ PP         0001.07              14-APR-20 03.30.59 PM                                                                                                                                   Airmaster Purchased parts                0 @L @A
T-CP: CA Apex        0001.06              02-NOV-15 01.36.19 PM                                                                                                                                   CA APEX testing lab                      0 @L @A
T-CP: CA Apex 2      0001.00              05-OCT-21 01.42.16 PM                                                                                                                                   CA APEX 2 testing lab                    0 @L @A
T-CP: CA Beadw Comp  0001.03              02-NOV-15 01.36.40 PM                                                                                                                                   CA BEADWIRE COMPOUND testing lab         0 @L @A
T-CP: CA Beadwire    0001.03              02-NOV-15 01.36.59 PM                                                                                                                                   CA BEADWIRE testing lab                  0 @L @A
T-CP: CA BeltEdgeF 1 0001.01              18-MAY-20 11.20.53 AM                                                                                                                                   CA Belt Edge Cushion 1 testing lab       0 @L @A
T-CP: CA BeltEdgeF 2 0001.01              18-MAY-20 11.21.15 AM                                                                                                                                   CA Belt Edge Cushion 2 testing lab       0 @L @A
T-CP: CA Carcass     0001.03              02-NOV-15 01.37.35 PM                                                                                                                                   CA CARCASS testing lab                   0 @L @A
T-CP: CA CarcassCmp2 0001.01              02-NOV-15 01.37.54 PM                                                                                                                                   CA CARCASS COMPOUND 2 testing lab        0 @L @A
T-CP: CA CarcassComp 0001.04              02-NOV-15 01.38.20 PM                                                                                                                                   CA CARCASS COMPOUND testing lab          0 @L @A
T-CP: CA Chafer      0001.04              02-NOV-15 01.38.39 PM                                                                                                                                   CA CHAFER testing lab                    0 @L @A
T-CP: CA HeelReinf   0001.01              02-NOV-15 01.39.02 PM                                                                                                                                   CA HEEL REINFORCEMENT testing lab        0 @L @A
T-CP: CA HeelToeRein 0001.01              02-NOV-15 01.39.22 PM                                                                                                                                   CA HEELTOE REINFORCEMENT testing lab     0 @L @A
T-CP: CA Inner Tube  0001.02              12-JUL-18 08.25.28 AM                                                                                                                                   CA INNER TUBE TWT testing lab            0 @L @A
T-CP: CA Innerliner  0001.06              02-NOV-15 01.39.53 PM                                                                                                                                   CA INNERLINER testing lab                0 @L @A
T-CP: CA Insert      0001.05              02-NOV-15 01.40.12 PM                                                                                                                                   CA INSERT testing lab                    0 @L @A
T-CP: CA Insert 2    0001.02              02-NOV-15 01.40.33 PM                                                                                                                                   CA INSERT 2 testing lab                  0 @L @A
T-CP: CA Ply Insert  0001.03              18-MAY-20 11.22.07 AM                                                                                                                                   CA Ply Insert testing lab                0 @L @A
T-CP: CA Rim Ext     0001.00              18-MAY-20 11.13.04 AM                                                                                                                                   CA Rimcushion Extension                  0 @L @A
T-CP: CA Rim cushion 0001.04              02-NOV-15 01.41.21 PM                                                                                                                                   CA RIM CUSHION testing lab               0 @L @A
T-CP: CA ShoulderIns 0001.01              02-NOV-15 01.41.41 PM                                                                                                                                   CA SHOULDER INSERT testing lab           0 @L @A
T-CP: CA Sidewall    0001.05              02-NOV-15 01.42.00 PM                                                                                                                                   CA SIDEWALL testing lab                  0 @L @A
T-CP: CA SteelBtCmp2 0001.00              11-JAN-19 02.23.53 PM                                                                                                                                   CA STEELBELT 2 COMPOUND testing lab      0 @L @A
T-CP: CA SteelBtCmp3 0001.00              11-JAN-19 02.24.11 PM                                                                                                                                   CA STEELBELT 3 COMPOUND testing lab      0 @L @A
T-CP: CA SteelBtCmp4 0001.00              11-JAN-19 02.24.24 PM                                                                                                                                   CA STEELBELT 4 COMPOUND testing lab      0 @L @A
T-CP: CA SteelBtComp 0001.03              02-NOV-15 01.42.21 PM                                                                                                                                   CA STEELBELT COMPOUND testing lab        0 @L @A
T-CP: CA SteelChafer 0001.04              02-NOV-15 01.42.42 PM                                                                                                                                   CA STEEL CHAFER testing lab              0 @L @A
T-CP: CA Steelbelt   0001.05              02-NOV-15 01.43.01 PM                                                                                                                                   CA STEEL BELT testing lab                0 @L @A
T-CP: CA Steelbelt 2 0001.00              11-JAN-19 01.58.05 PM                                                                                                                                   CA STEEL BELT 2 testing lab              0 @L @A
T-CP: CA Steelbelt 3 0001.00              11-JAN-19 01.58.35 PM                                                                                                                                   CA STEEL BELT 3 testing lab              0 @L @A
T-CP: CA Steelbelt 4 0001.00              11-JAN-19 01.59.05 PM                                                                                                                                   CA STEEL BELT 4 testing lab              0 @L @A
T-CP: CA TLB/Base2   0001.00              09-NOV-17 11.50.48 AM                                                                                                                                   CA TREAD LIKE BASE testing lab           0 @L @A
T-CP: CA TextBltComp 0001.03              02-NOV-15 01.43.20 PM                                                                                                                                   CA TEXTILEBELT COMPOUND testing lab      0 @L @A
T-CP: CA TextChafer  0001.04              02-NOV-15 01.43.45 PM                                                                                                                                   CA TEXTILE CHAFER testing lab            0 @L @A
T-CP: CA TextFlipper 0001.03              02-NOV-15 01.44.07 PM                                                                                                                                   CA TEXTILE FLIPPER testing lab           0 @L @A
T-CP: CA TextHeelToe 0001.01              02-NOV-15 01.44.28 PM                                                                                                                                   CA TEXTILE HEEL TOE BELT testing lab     0 @L @A
T-CP: CA TextileHeel 0001.01              02-NOV-15 01.44.46 PM                                                                                                                                   CA TEXTILE HEEL BELT testing lab         0 @L @A
T-CP: CA Textilebelt 0001.04              02-NOV-15 01.45.07 PM                                                                                                                                   CA TEXTILE BELT testing lab              0 @L @A
T-CP: CA Tread       0001.05              02-NOV-15 01.45.25 PM                                                                                                                                   CA TREAD testing lab                     0 @L @A
T-CP: CA Tread In    0001.02              02-NOV-15 01.45.45 PM                                                                                                                                   CA TREAD Inside testing lab              0 @L @A
T-CP: CA Tread Out   0001.01              02-NOV-15 01.46.08 PM                                                                                                                                   CA TREAD Outside testing lab             0 @L @A
T-CP: CA Undertread  0001.06              31-MAY-16 02.23.16 PM                                                                                                                                   CA UNDERTREAD testing lab                0 @L @A
T-CP: CA Wingtip     0001.04              02-NOV-15 01.46.51 PM                                                                                                                                   CA WINGTIP testing lab                   0 @L @A
T-CP: CA side Insert 0001.01              02-NOV-15 01.47.11 PM                                                                                                                                   CA SIDEWALL INSERT testing lab           0 @L @A
T-O: PCT Intern tyre 0001.06              18-NOV-20 01.03.03 PM                                                                                                                                   Ordering Internal Tyres                  0 @L @A
T-O: PCT Ordering BM 0001.10              22-NOV-17 02.45.04 PM                                                                                                                                   Ordering tyre for Benchmark              0 @L @A
T-O: Send from SW    0001.02              14-SEP-20 03.26.45 PM                                                                                                                                   Send tyres from SW                       1 @L @A
T-O: Send to SW      0001.02              14-SEP-20 03.27.00 PM                                                                                                                                   Send tyres to SW                         0 @L @A
T-P: BASE            0001.04              26-JUN-09 09.52.14 AM                                                                                                                                   BASE testing lab                         0 @L @A
T-P: BEAD            0001.03              27-JAN-21 09.58.59 AM                                                                                                                                   BEAD testing lab                         0 @L @A
T-P: BEADWIRE        0001.04              05-DEC-22 11.39.40 AM                                                                                                                                   BEADWIRE testing lab                     0 @L @A
T-P: CA Tyre         0002.02              22-JUN-22 04.25.33 PM                                                                                                                                   CA TYRE testing                          1 @L @A
T-P: CA Tyre AT      0001.01              01-NOV-21 05.21.44 PM                                                                                                                                   CA TYRE testing AT                       0 @L @A
T-P: CHAFER          0001.02              27-JAN-21 09.34.56 AM                                                                                                                                   CHAFER testing lab                       0 @L @A
T-P: CHEMICAL        0001.10              27-JAN-21 09.23.30 AM                                                                                                                                   CHEMICAL testing lab                     0 @L @A
T-P: CURING          0001.06              27-JAN-21 09.32.11 AM                                                                                                                                   CURING testing lab                       0 @L @A
T-P: Component       0001.03              11-MAY-22 08.20.02 AM                                                                                                                                   Sub component testing                    0 @L @A
T-P: FABRIC          0001.03              11-MAY-22 08.20.20 AM                                                                                                                                   FABRIC testing lab                       0 @L @A
T-P: FILL            0001.05              27-JAN-21 09.31.15 AM                                                                                                                                   FILL testing lab                         0 @L @A
T-P: FM              0001.29              11-MAY-22 08.20.45 AM                                                                                                                                   FM testing lab                           0 @L @A
T-P: FM APEX         0001.00              15-SEP-21 08.39.09 AM                                                                                                                                   FM APEX testing lab                      0 @L @A
T-P: FM BASE         0001.02              04-FEB-22 12.33.28 PM                                                                                                                                   FM BASE testing lab                      0 @L @A
T-P: FM BEAD INSUL   0001.03              04-FEB-22 12.37.02 PM                                                                                                                                   FM BEAD INSULATION testing lab           0 @L @A
T-P: FM BELT         0001.03              11-MAY-22 08.21.14 AM                                                                                                                                   FM BELT testing lab                      0 @L @A
T-P: FM BODY PLY     0001.02              11-MAY-22 08.21.27 AM                                                                                                                                   FM BODY PLY testing lab                  1 @L @A
T-P: FM CAP PLY      0001.02              11-MAY-22 08.21.42 AM                                                                                                                                   FM CAP PLY testing lab                   0 @L @A
T-P: FM GENERAL      0001.03              11-MAY-22 08.21.56 AM                                                                                                                                   FM GENERAL testing lab                   0 @L @A
T-P: FM INNERLINER   0001.01              04-FEB-22 12.43.56 PM                                                                                                                                   FM INNERLINER testing lab                0 @L @A
T-P: FM RIM CUSHION  0001.01              04-FEB-22 12.45.33 PM                                                                                                                                   FM RIM CUSHION testing lab               0 @L @A
T-P: FM SIDEWALL     0001.01              04-FEB-22 12.50.37 PM                                                                                                                                   FM SIDEWALL testing lab                  1 @L @A
T-P: FM TECH LAYER   0001.02              30-SEP-22 11.25.27 AM                                                                                                                                   TECH LAYER testing lab                   0 @L @A
T-P: FM TREAD        0001.02              22-MAR-23 04.57.52 PM                                                                                                                                   FM TREAD testing lab                     1 @L @A
T-P: FM WING TIP     0001.01              04-FEB-22 12.54.17 PM                                                                                                                                   FM WING TIP testing lab                  0 @L @A
T-P: FM blend        0001.08              11-MAY-22 08.22.32 AM                                                                                                                                   FM blend testing lab                     0 @L @A
T-P: FM release      0001.11              18-MAR-15 04.41.39 PM                                                                                                                                   FM release criteria                      0 @L @A
T-P: General         0001.03              03-APR-12 04.17.08 PM                                                                                                                                   General                                  0 @L @A
T-P: LAT100 wheel    0001.00              02-JUL-09 10.42.32 PM                                                                                                                                   LAT100 test data on wheel level          0 @L @A
T-P: POLYM           0001.07              27-JAN-21 09.26.04 AM                                                                                                                                   POLYM testing lab                        0 @L @A
T-P: RIMCUSHION      0001.03              26-JUN-09 09.54.08 AM                                                                                                                                   RIMCUSHION testing lab                   0 @L @A
T-P: Reference       0001.00              08-JAN-13 09.24.19 AM                                                                                                                                   Reference Compound                       0 @L @A
T-P: SIDEWALL        0001.03              26-JUN-09 09.53.44 AM                                                                                                                                   SIDEWALL testing lab                     0 @L @A
T-P: STEELCOMP       0001.02              27-JAN-21 10.04.33 AM                                                                                                                                   STEELCOMP testing lab                    0 @L @A
T-P: STEELCORD       0001.02              27-JAN-21 09.36.13 AM                                                                                                                                   STEELCORD testing lab                    0 @L @A
T-P: TEXTCOMP        0001.03              11-MAY-22 08.24.02 AM                                                                                                                                   TEXTCOMP testing lab                     0 @L @A
T-P: TREAD           0001.03              25-JUN-09 11.02.21 AM                                                                                                                                   TREAD testing lab                        0 @L @A
T-P: UNDERTREAD      0001.03              26-JUN-09 09.53.17 AM                                                                                                                                   UNDERTREAD testing lab                   0 @L @A
T-P: WINGTIP         0001.04              26-JUN-09 09.52.47 AM                                                                                                                                   WINGTIP testing lab                      0 @L @A
T-P: XNP             0001.10              26-JUN-15 10.26.37 AM                                                                                                                                   XNP testing lab                          1 @L @A
T-P: XNP APEX        0001.00              21-SEP-21 03.17.25 PM                                                                                                                                   XNP APEX testing lab                     0 @L @A
T-P: XNP BASE        0001.00              21-SEP-21 02.30.02 PM                                                                                                                                   XNP BASE testing lab                     1 @L @A
T-P: XNP BEAD INSUL  0001.00              21-SEP-21 03.31.09 PM                                                                                                                                   XNP BEAD INSULATION testing lab          0 @L @A
T-P: XNP BELT        0001.00              21-SEP-21 02.47.16 PM                                                                                                                                   XNP BELT testing lab                     0 @L @A
T-P: XNP BODY PLY    0001.00              21-SEP-21 03.05.17 PM                                                                                                                                   XNP BODY PLY testing lab                 0 @L @A
T-P: XNP CAP PLY     0001.01              21-SEP-21 03.10.06 PM                                                                                                                                   XNP CAP PLY testing lab                  0 @L @A
T-P: XNP GENERAL     0001.02              21-FEB-22 03.12.18 PM                                                                                                                                   XNP GENERAL testing lab                  0 @L @A
T-P: XNP INNERLINER  0001.00              21-SEP-21 03.14.23 PM                                                                                                                                   XNP INNERLINER testing lab               0 @L @A
T-P: XNP RIM CUSHION 0001.00              21-SEP-21 02.43.52 PM                                                                                                                                   XNP RIM CUSHION testing lab              0 @L @A
T-P: XNP SIDEWALL    0001.00              21-SEP-21 02.34.08 PM                                                                                                                                   XNP SIDEWALL testing lab                 0 @L @A
T-P: XNP TECH LAYER  0001.00              21-SEP-21 03.11.36 PM                                                                                                                                   XNP TECHNICAL LAYER testing lab          0 @L @A
T-P: XNP TREAD       0001.00              20-SEP-21 02.46.05 PM                                                                                                                                   XNP TREAD testing lab                    0 @L @A
T-P: XNP WING TIP    0001.01              21-SEP-21 03.35.09 PM                                                                                                                                   XNP WING TIP testing lab                 0 @L @A
T-P: XNP release     0001.06              15-OCT-09 02.44.16 PM                                                                                                                                   XNP release criteria                     0 @L @A
T-PG: CA Tyre        0001.02              02-JUL-19 03.58.52 PM                                                                                                                                   CA TYRE testing                          0 @L @A
T-S: ATP AKS 1       0001.00              30-SEP-21 01.27.02 PM                                                                                                                                   Surface scan ATP AKS 1                   1 @L @A
T-S: ATP AKS 1-L1    0001.01              30-SEP-21 01.56.31 PM                                                                                                                                   Surface scan ATP AKS 1-L1                1 @L @A
T-S: ATP AKS 1-L2    0001.01              30-SEP-21 03.15.02 PM                                                                                                                                   Surface scan ATP AKS 1-L2                0 @L @A
T-S: ATP AKS 1-R1    0001.02              30-SEP-21 02.49.21 PM                                                                                                                                   Surface scan ATP AKS 1-R1                0 @L @A
T-S: ATP AKS 1-R2    0001.00              30-SEP-21 03.35.02 PM                                                                                                                                   Surface scan ATP AKS 1-R2                0 @L @A
T-S: ATP AKS 2       0001.00              30-SEP-21 03.51.02 PM                                                                                                                                   Surface scan ATP AKS 2                   0 @L @A
T-S: ATP AKS 2-L1    0001.00              30-SEP-21 03.54.02 PM                                                                                                                                   Surface scan ATP AKS 2-L1                0 @L @A
T-S: ATP AKS 2-L2    0001.00              30-SEP-21 03.55.02 PM                                                                                                                                   Surface scan ATP AKS 2-L2                0 @L @A
T-S: ATP AKS 2-R1    0001.00              30-SEP-21 03.56.02 PM                                                                                                                                   Surface scan ATP AKS 2-R1                0 @L @A
T-S: ATP AKS 2-R2    0001.00              30-SEP-21 03.57.02 PM                                                                                                                                   Surface scan ATP AKS 2-R2                0 @L @A
T-S: ATP BMK 4       0001.00              30-SEP-21 04.04.02 PM                                                                                                                                   Surface scan ATP BMK 4                   0 @L @A
T-S: ATP BMK 4-L1    0001.00              30-SEP-21 04.14.02 PM                                                                                                                                   Surface scan ATP BMK 4-L1                0 @L @A
T-S: ATP BMK 4-L2    0001.00              30-SEP-21 04.15.02 PM                                                                                                                                   Surface scan ATP BMK 4-L2                0 @L @A
T-S: ATP BMK 4-L3    0001.00              30-SEP-21 04.16.02 PM                                                                                                                                   Surface scan ATP BMK 4-L3                0 @L @A
T-S: ATP BMK 4-R1    0001.00              30-SEP-21 04.17.02 PM                                                                                                                                   Surface scan ATP BMK 4-R1                0 @L @A
T-S: ATP BMK 4-R2    0001.00              30-SEP-21 04.19.02 PM                                                                                                                                   Surface scan ATP BMK 4-R2                0 @L @A
T-S: ATP BMK 4-R3    0001.00              30-SEP-21 04.20.02 PM                                                                                                                                   Surface scan ATP BMK 4-R3                0 @L @A
T-S: ATP BMK 6       0001.00              01-OCT-21 11.02.02 AM                                                                                                                                   Surface scan ATP BMK 6                   0 @L @A
T-S: ATP BMK 6-L1    0001.01              01-OCT-21 11.06.02 AM                                                                                                                                   Surface scan ATP BMK 6-L1                0 @L @A
T-S: ATP BMK 6-L2    0001.00              01-OCT-21 11.06.02 AM                                                                                                                                   Surface scan ATP BMK 6-L2                0 @L @A
T-S: ATP BMK 6-L3    0001.00              01-OCT-21 11.07.02 AM                                                                                                                                   Surface scan ATP BMK 6-L3                0 @L @A
T-S: ATP BMK 6-R1    0001.00              01-OCT-21 11.07.02 AM                                                                                                                                   Surface scan ATP BMK 6-R1                0 @L @A
T-S: ATP BMK 6-R2    0001.00              01-OCT-21 11.08.02 AM                                                                                                                                   Surface scan ATP BMK 6-R2                0 @L @A
T-S: ATP BMK 6-R3    0001.00              01-OCT-21 11.08.02 AM                                                                                                                                   Surface scan ATP BMK 6-R3                0 @L @A
T-S: ATP BMK 6a      0001.00              01-OCT-21 11.39.40 AM                                                                                                                                   Surface scan ATP BMK 6a                  0 @L @A
T-S: ATP BMK 6a-L1   0001.00              01-OCT-21 11.41.02 AM                                                                                                                                   Surface scan ATP BMK 6a-L1               0 @L @A
T-S: ATP BMK 6a-L2   0001.01              06-OCT-21 12.09.27 PM                                                                                                                                   Surface scan ATP BMK 6a-L2               0 @L @A
T-S: ATP BMK 6a-L3   0001.00              01-OCT-21 12.15.02 PM                                                                                                                                   Surface scan ATP BMK 6a-L3               0 @L @A
T-S: Idiada Tr2 1    0001.00              01-OCT-21 11.52.02 AM                                                                                                                                   Surface scan Idiada Tr2 1                0 @L @A
T-S: Idiada Tr2 1-L1 0001.00              01-OCT-21 11.53.02 AM                                                                                                                                   Surface scan Idiada Tr2 1-L1             0 @L @A
T-S: Idiada Tr2 1-L2 0001.00              01-OCT-21 11.53.02 AM                                                                                                                                   Surface scan Idiada Tr2 1-L2             0 @L @A
T-S: Idiada Tr2 1-R1 0001.00              01-OCT-21 11.54.02 AM                                                                                                                                   Surface scan Idiada Tr2 1-R1             0 @L @A
T-S: Idiada Tr2 1-R2 0001.00              01-OCT-21 11.54.02 AM                                                                                                                                   Surface scan Idiada Tr2 1-R2             0 @L @A
T-S: Idiada Tr2 2    0001.00              01-OCT-21 11.58.02 AM                                                                                                                                   Surface scan Idiada Tr2 2                0 @L @A
T-S: Idiada Tr2 2-L1 0001.00              01-OCT-21 12.16.02 PM                                                                                                                                   Surface scan Idiada Tr2 2-L1             0 @L @A
T-S: Idiada Tr2 2-L2 0001.00              01-OCT-21 11.59.02 AM                                                                                                                                   Surface scan Idiada Tr2 2-L2             0 @L @A
T-S: Idiada Tr2 2-R1 0001.00              01-OCT-21 12.00.02 PM                                                                                                                                   Surface scan Idiada Tr2 2-R1             0 @L @A
T-S: Idiada Tr2 2-R2 0001.00              01-OCT-21 12.00.02 PM                                                                                                                                   Surface scan Idiada Tr2 2-R2             0 @L @A
T-S: Idiada Tr7 2    0001.00              01-OCT-21 12.06.02 PM                                                                                                                                   Surface scan Idiada Tr7 2                0 @L @A
T-S: Idiada Tr7 2-L1 0001.00              01-OCT-21 12.06.02 PM                                                                                                                                   Surface scan Idiada Tr7 2-L1             0 @L @A
T-S: Idiada Tr7 2-L2 0001.00              01-OCT-21 12.07.02 PM                                                                                                                                   Surface scan Idiada Tr7 2-L2             0 @L @A
T-S: Idiada Tr7 2-L3 0001.00              01-OCT-21 12.07.02 PM                                                                                                                                   Surface scan Idiada Tr7 2-L3             0 @L @A
T-S: Idiada Tr7 2-R1 0001.00              01-OCT-21 12.08.02 PM                                                                                                                                   Surface scan Idiada Tr7 2-R1             0 @L @A
T-S: Idiada Tr7 2-R2 0001.00              01-OCT-21 12.08.02 PM                                                                                                                                   Surface scan Idiada Tr7 2-R2             0 @L @A
T-S: Idiada Tr7 2-R3 0001.00              01-OCT-21 12.08.02 PM                                                                                                                                   Surface scan Idiada Tr7 2-R3             0 @L @A
T-S: Surface scan    0001.03              01-OCT-21 12.11.02 PM                                                                                                                                   Surface scan                             1 @L @A
T-T: AT Endurance    0001.07              19-JUL-19 03.16.13 PM                                                                                                                                   AT Endurance                             1 @L @A
T-T: AT Indoor std 1 0001.12              24-NOV-21 02.46.10 PM                                                                                                                                   AT indoor testing standard               0 @L @A
T-T: PCT Aquaplaning 0001.01              11-AUG-09 12.57.29 PM                                                                                                                                   PCT Aquaplaning                          0 @L @A
T-T: PCT Dry Hand.   0001.02              11-AUG-09 12.57.53 PM                                                                                                                                   PCT Dry handling tearing                 0 @L @A
T-T: PCT Dry braking 0001.02              11-AUG-09 12.58.11 PM                                                                                                                                   PCT Dry braking                          0 @L @A
T-T: PCT Indoor adv. 0001.20              22-JUN-22 04.25.57 PM                                                                                                                                   PCT testing indoor advanced              0 @L @A
T-T: PCT Noise       0001.01              31-MAR-10 10.07.30 AM                                                                                                                                   PCT Noise                                0 @L @A
T-T: PCT Outdoor     0001.02              31-OCT-13 03.16.01 PM                                                                                                                                   PCT testing Outdoor                      0 @L @A
T-T: PCT Outdoor I   0001.06              07-JAN-16 02.13.39 PM                                                                                                                                   PCT testing Outdoor                      0 @L @A
T-T: PCT Outdoor mis 0001.01              02-DEC-15 03.47.56 PM                                                                                                                                   PCT testing indoor advanced              0 @L @A
T-T: PCT RnD Indoor  0001.09              30-NOV-20 03.19.18 PM                                                                                                                                   PCT RnD Indoor testing                   0 @L @A
T-T: PCT Section     0001.04              26-FEB-16 09.36.57 AM                                                                                                                                   PCT Section + Markings                   0 @L @A
T-T: PCT Wear        0001.04              26-OCT-11 01.48.02 PM                                                                                                                                   PCT Wear testing                         1 @L @A
T-T: PCT Wear FL     0001.01              29-SEP-16 03.50.49 PM                                                                                                                                   PCT Wear testing                         0 @L @A
T-T: PCT Wear FR     0001.01              29-SEP-16 03.47.38 PM                                                                                                                                   PCT Wear testing                         0 @L @A
T-T: PCT Wear RL     0001.01              29-SEP-16 03.51.12 PM                                                                                                                                   PCT Wear testing RL                      0 @L @A
T-T: PCT Wear RR     0001.01              29-SEP-16 03.51.30 PM                                                                                                                                   PCT Wear testing RR                      0 @L @A
T-T: PCT Wear Set    0001.03              03-OCT-16 01.31.58 PM                                                                                                                                   PCT Wear testing                         0 @L @A
T-T: PCT Wear mixed  0001.01              19-NOV-20 12.42.42 PM                                                                                                                                   PCT testing Wear mixed set               0 @L @A
T-T: PCT Wear normal 0001.02              26-NOV-20 10.38.08 AM                                                                                                                                   PCT testing Wear normal set              0 @L @A
T-T: PCT Wear open   0001.01              19-NOV-20 12.45.25 PM                                                                                                                                   PCT testing Wear open set                0 @L @A
T-T: PCT Wet braking 0001.03              11-AUG-09 12.58.50 PM                                                                                                                                   PCT Wet braking                          0 @L @A
T-T: PCT Winter test 0001.00              29-OCT-09 03.34.59 PM                                                                                                                                   PCT Winter testing                       0 @L @A
T-T: PCT indoor BM   0001.03              02-NOV-15 01.34.00 PM                                                                                                                                   Benchmark PCT indoor                     0 @L @A
T-T: PCT mixed set   0001.06              20-SEP-21 10.56.59 AM                                                                                                                                   PCT testing Outdoor mixed set            1 @L @A
T-T: PCT normal set  0001.08              20-SEP-21 10.55.32 AM                                                                                                                                   PCT testing Outdoor normal set           1 @L @A
T-T: PCT open set    0001.06              20-SEP-21 10.56.19 AM                                                                                                                                   PCT testing Outdoor open set             1 @L @A
T-T: SM indoor std 1 0001.06              19-JUL-19 03.21.02 PM                                                                                                                                   SM indoor testing standard               0 @L @A
T-T: TWT indoor std  0001.01              19-JUL-19 03.24.19 PM                                                                                                                                   TWT testing indoor standard              0 @L @A
T-T: TWT mixed set   0001.02              06-OCT-20 10.46.27 AM                                                                                                                                   TWT testing Outdoor mixed set            0 @L @A
T-TG: PCT Endurance  0001.02              02-JUL-19 03.55.53 PM                                                                                                                                   PCT Endurance testing                    0 @L @A
T-TG: PCT High speed 0001.04              13-SEP-21 05.03.41 PM                                                                                                                                   PCT High speed testing                   0 @L @A
T-TG: PCT Indoor adv 0001.03              06-MAR-23 11.44.51 AM                                                                                                                                   PCT testing adv                          0 @L @A
T-TG: PCT Runflat    0001.02              02-JUL-19 03.57.07 PM                                                                                                                                   PCT Runflat                              0 @L @A
T-TG: PCT indoor s1  0001.02              02-JUL-19 03.57.31 PM                                                                                                                                   PCT indoor testing standard              0 @L @A
T-TG: PCT indoor s2  0001.02              02-JUL-19 03.57.55 PM                                                                                                                                   PCT indoor testing standard              0 @L @A
T-TG: TBR Endurance  0001.00              05-DEC-19 04.21.08 PM                                                                                                                                   TBR Endurance testing                    0 @L @A
T-TG: TBR High speed 0001.00              05-DEC-19 03.38.08 PM                                                                                                                                   TBR High speed testing                   0 @L @A
T-TG: TBR indoor s1  0001.00              05-DEC-19 03.09.08 PM                                                                                                                                   TBR indoor testing standard              0 @L @A
T444                 0001.04              05-FEB-16 08.52.09 AM                                                                                                                                   Calibration Compound Tensile Tester      0 @L @A
T555                 0001.02              05-FEB-16 08.55.49 AM                                                                                                                                   Calibration Compound Wear Test           0 @L @A
T: PCT Endurance     0001.22              22-JUN-22 04.22.01 PM                                                                                                                                   PCT Endurance testing                    1 @L @A
T: PCT High speed    0001.21              22-JUN-22 04.22.46 PM                                                                                                                                   PCT High speed testing                   1 @L @A
T: PCT Runflat       0001.09              22-JUN-22 04.25.06 PM                                                                                                                                   PCT Runflat                              1 @L @A
T: PCT indoor adv    0001.01              01-JUL-19 02.17.26 PM                                                                                                                                   PCT testing adv                          1 @L @A
T: PCT indoor std    0001.07              25-NOV-09 11.46.23 AM                                                                                                                                   PCT testing parameters HdL               0 @L @A
T: PCT indoor std 1  0001.19              22-JUN-22 04.24.17 PM                                                                                                                                   PCT indoor testing standard              1 @L @A
T: PCT indoor std 2  0001.18              22-JUN-22 04.24.40 PM                                                                                                                                   PCT indoor testing standard              1 @L @A
TEF_1955516QT5NH     0002.01              09-JUL-19 09.00.43 AM                                                                                                                                   195/55R16 87H Quatrac 5                  0 ST @A
TEF_2255017QPRFEA4   0001.01              09-JUL-19 09.01.43 AM                                                                                                                                   225/50R17 98Y XL Quatrac Pro - REF - FEA 0 ST @A
TEF_CA16-353FEM      0001.01              30-MAR-19 09.00.10 AM                                                                                                                                   275/30R20 (97Y) XL Ultrac Vorti (FEM)    0 ST @A
TEF_E16WXS2B02       0001.01              30-MAR-19 09.00.10 AM                                                                                                                                   225/50R17 98H XL WXS2 Mould I - Const I  0 ST @A
TEF_E30A001A         0003.01              10-DEC-15 09.00.51 AM                                                                                                                                   Xpert 205/55R16V Sportrac 5 Bart Standar 0 ST @A
TEF_H215/65R16QTX    0001.01              30-MAR-19 09.00.10 AM                                                                                                                                   Xpert Test                               0 ST @A
TEF_H215/65R16XPR2   0001.01              30-MAR-19 09.00.10 AM                                                                                                                                   Xpert Test xpert test                    0 ST @A
TEF_H215/65R16XPRT   0001.01              23-APR-15 09.01.05 AM                                                                                                                                   Xpert Test xpert test                    0 ST @A
TEF_Test_Freeze      0004.01              30-MAR-19 09.00.10 AM                                                                                                                                   Xpert 205/55R16V Sportrac 5 Grooves      0 ST @A
TEF_V185/55R15SP5C   0001.01              09-DEC-22 09.00.04 AM                                                                                                                                   185/55  R 15  82V Sportrac 5             0 ST @A
TEF_Y205/50R17USA2   0001.01              30-MAR-19 09.00.10 AM                                                                                                                                   205/50R17 93Y XL Ultrac Satin Apex 35 mm 0 ST @A
TEST_FM              0002.02              30-APR-14 05.04.29 PM                                                                                                                                   test spec with new properties            0 ST @A
TGF_215/55R16QT5XV   0001.01              09-JUL-19 09.00.43 AM                                                                                                                                   215/55R16 97V XL Quatrac 5               0 ST @A
TGF_22550R17HTRFEA   0003.01              09-JUL-19 09.00.43 AM                                                                                                                                   225/50R17 94H HiTrac FEA spec            0 ST @A
TGF_U11S17_1_U062    0002.01              06-MAY-20 09.00.56 AM                                                                                                                                   205/65R17 100Y XL Ultrac mold 2          0 ST @A
TM_MZ15001           0001.01              09-JUL-19 09.00.43 AM                                                                                                                                   MB4 LRR Sidewall Tandem                  0 ST @A
TM_MZ15013           0002.01              01-JUL-20 09.00.19 AM                                                                                                                                   MB Sidewall HP Section Z15013 Tandem     0 ST @A
Tread: Master/Repass 0001.01              28-JAN-21 01.46.08 PM                                                                                                                                   Tread Master/Repass                      0 @L @A

218 rows selected.
*/

--******************************************
--UTRTST (sample-types per request-type...)
--******************************************
select r.rt ||';'||    r.st||';'||    r.seq
from UTRTST r
where r.version = (select max(r2.version) from utrtst r2 where r.rt = r2.rt)
order by r.rt, r.seq
;



--HOW MANY SAMPLES AVAILABLE RELATED TO SAMPLE-TYPE
select st.ST, sc.ss, count(*)
from utst st
,    utsc sc
where st.version_is_current = 1
and   st.st = sc.st
and   st.st like 'T%'   --not production-samples
and   st.ss = '@A'
--and   rq.ss in ('@A')
group by st.st, sc.ss
order by st.st, sc.ss
;
/*
ST                   SS   COUNT(*)
-------------------- -- ----------
T-C: Legislation     @C         26
T-C: Legislation     @P          6
T-C: Legislation     AV          3
T-C: Legislation     CM         11
T-CP: Airmaster      @C         14
T-CP: Airmaster      @P          3
T-CP: Airmaster      AV          1
T-CP: Airmaster      CM         57
T-CP: BBQ PP         @C        159     --Cancelled
T-CP: BBQ PP         @P          9
T-CP: BBQ PP         AV          8
T-CP: BBQ PP         CM        409
T-CP: BBQ PP         SC          3
T-CP: CA Apex        @C         87
T-CP: CA Apex        @P         21
T-CP: CA Apex        AV         11
T-CP: CA Apex        CM        325
T-CP: CA Apex 2      @C          4
T-CP: CA Apex 2      @P          6
T-CP: CA Apex 2      AV          1
T-CP: CA Apex 2      CM          7
T-CP: CA Beadw Comp  @C         59     --Cancelled
T-CP: CA Beadw Comp  AV          5
T-CP: CA Beadw Comp  CM         38
T-CP: CA Beadwire    @C         84
T-CP: CA Beadwire    @P         13
T-CP: CA Beadwire    AV          8
T-CP: CA Beadwire    CM        223
T-CP: CA BeltEdgeF 1 @C          2
T-CP: CA BeltEdgeF 1 @P          3
T-CP: CA BeltEdgeF 1 AV          5
T-CP: CA BeltEdgeF 1 CM          5
T-CP: CA BeltEdgeF 2 @C          1
T-CP: CA Carcass     @C        111
T-CP: CA Carcass     @P         16
T-CP: CA Carcass     AV         10
T-CP: CA Carcass     CM        386
T-CP: CA CarcassCmp2 @C          7
T-CP: CA CarcassCmp2 CM          1
T-CP: CA CarcassComp @C        100
T-CP: CA CarcassComp @P         11
T-CP: CA CarcassComp AV          9
T-CP: CA CarcassComp CM        108
T-CP: CA Chafer      @C         21
T-CP: CA Chafer      CM         21
T-CP: CA HeelReinf   @C         26
T-CP: CA HeelReinf   CM          7
T-CP: CA HeelToeRein @C          8
T-CP: CA HeelToeRein CM          9
T-CP: CA Inner Tube  @C          3
T-CP: CA Inner Tube  CM         19
T-CP: CA Innerliner  @C        102
T-CP: CA Innerliner  @P         13
T-CP: CA Innerliner  AV         12
T-CP: CA Innerliner  CM        200
T-CP: CA Insert      @C         24
T-CP: CA Insert      CM         34
T-CP: CA Insert 2    @C          3
T-CP: CA Insert 2    CM         16
T-CP: CA Ply Insert  @C          2
T-CP: CA Ply Insert  AV          5
T-CP: CA Rim Ext     @C          1
T-CP: CA Rim Ext     CM          2
T-CP: CA Rim cushion @C         73
T-CP: CA Rim cushion @P         22
T-CP: CA Rim cushion AV         11
T-CP: CA Rim cushion CM        315
T-CP: CA ShoulderIns @C         20
T-CP: CA ShoulderIns @P          3
T-CP: CA ShoulderIns CM         25
T-CP: CA Sidewall    @C        122
T-CP: CA Sidewall    @P         17
T-CP: CA Sidewall    AV         11
T-CP: CA Sidewall    CM        398
T-CP: CA SteelBtCmp2 @C          7
T-CP: CA SteelBtCmp2 CM          6
T-CP: CA SteelBtCmp3 @C          6
T-CP: CA SteelBtCmp3 CM          2
T-CP: CA SteelBtCmp4 @C          1
T-CP: CA SteelBtComp @C         88
T-CP: CA SteelBtComp @P         11
T-CP: CA SteelBtComp AV          2
T-CP: CA SteelBtComp CM        121
T-CP: CA SteelChafer @C          9
T-CP: CA SteelChafer CM         26
T-CP: CA Steelbelt   @C        102
T-CP: CA Steelbelt   @P         16
T-CP: CA Steelbelt   AV          3
T-CP: CA Steelbelt   CM        322
T-CP: CA Steelbelt 2 @C          4
T-CP: CA Steelbelt 2 @P          3
T-CP: CA Steelbelt 2 CM          5
T-CP: CA Steelbelt 3 @C          4
T-CP: CA Steelbelt 3 CM          2
T-CP: CA Steelbelt 4 @C          1
T-CP: CA TLB/Base2   @C          5
T-CP: CA TLB/Base2   CM          4
T-CP: CA TextBltComp @C         67
T-CP: CA TextBltComp @P          6
T-CP: CA TextBltComp AV          9
T-CP: CA TextBltComp CM         82
T-CP: CA TextChafer  @C         26
T-CP: CA TextChafer  CM          2
T-CP: CA TextFlipper @C         36
T-CP: CA TextFlipper CM         25
T-CP: CA TextHeelToe @C         11
T-CP: CA TextHeelToe CM          6
T-CP: CA TextileHeel @C          7
T-CP: CA TextileHeel CM          5
T-CP: CA Textilebelt @C         92
T-CP: CA Textilebelt @P         14
T-CP: CA Textilebelt AV         10
T-CP: CA Textilebelt CM        354
T-CP: CA Tread       @C        335     --Cancelled
T-CP: CA Tread       @P         23
T-CP: CA Tread       AV         18
T-CP: CA Tread       CM       1115
T-CP: CA Tread In    @C         27
T-CP: CA Tread In    @P          7
T-CP: CA Tread In    AV          4
T-CP: CA Tread In    CM         97
T-CP: CA Tread Out   @C         38
T-CP: CA Tread Out   @P          9
T-CP: CA Tread Out   AV          4
T-CP: CA Tread Out   CM         64
T-CP: CA Undertread  @C        147
T-CP: CA Undertread  @P         18
T-CP: CA Undertread  AV          8
T-CP: CA Undertread  CM        249
T-CP: CA Wingtip     @C        130
T-CP: CA Wingtip     @P          8
T-CP: CA Wingtip     AV          4
T-CP: CA Wingtip     CM         39
T-CP: CA side Insert @C         13
T-CP: CA side Insert CM         46
T-O: PCT Intern tyre @C        221     --Cancelled
T-O: PCT Intern tyre @P         11
T-O: PCT Intern tyre AV          4
T-O: PCT Intern tyre CM        867
T-O: PCT Ordering BM @C        189     --Cancelled
T-O: PCT Ordering BM @P         27
T-O: PCT Ordering BM AV         18
T-O: PCT Ordering BM CM       1085
T-O: Send from SW    @C          9     --Cancelled
T-O: Send from SW    @P         44
T-O: Send from SW    AV         13
T-O: Send from SW    CM         40
T-O: Send to SW      CM          1
T-P: BASE            @C         24
T-P: BASE            CM         13
T-P: BEAD            @C         28
T-P: BEAD            @P          2
T-P: BEAD            CM          8
T-P: BEADWIRE        @C         44     --Cancelled
T-P: BEADWIRE        @P          1
T-P: BEADWIRE        CM        119
T-P: CA Tyre         @C        943     --Cancelled
T-P: CA Tyre         @P         33
T-P: CA Tyre         AV         15
T-P: CA Tyre         CM       4958
T-P: CA Tyre         SU          7
T-P: CA Tyre         WH          2
T-P: CA Tyre AT      @C         30
T-P: CA Tyre AT      @P          9
T-P: CA Tyre AT      AV         10
T-P: CA Tyre AT      CM        148
T-P: CHAFER          @C          8
T-P: CHAFER          CM          5
T-P: CHEMICAL        @C        316
T-P: CHEMICAL        @P         16
T-P: CHEMICAL        AV          1
T-P: CHEMICAL        CM        860
T-P: CURING          @C         19
T-P: CURING          @P          3
T-P: CURING          AV          1
T-P: CURING          CM         64
T-P: Component       @C        399
T-P: Component       @P         42
T-P: Component       AV         12
T-P: Component       CM       1714
T-P: FABRIC          @C        252
T-P: FABRIC          @P         27
T-P: FABRIC          AV          9
T-P: FABRIC          CM        872
T-P: FILL            @C         72
T-P: FILL            @P          6
T-P: FILL            AV         13
T-P: FILL            CM        212
T-P: FM              @C       6651     --Cancelled
T-P: FM              @P        300
T-P: FM              AV        114
T-P: FM              CM      43313
T-P: FM              IR          1
T-P: FM APEX         @C          6
T-P: FM APEX         @P          7
T-P: FM APEX         CM         44
T-P: FM BASE         @C         20
T-P: FM BASE         @P          3
T-P: FM BASE         AV          9
T-P: FM BASE         CM        180
T-P: FM BEAD INSUL   @C          1
T-P: FM BEAD INSUL   @P          3
T-P: FM BEAD INSUL   CM          6
T-P: FM BELT         @C          4
T-P: FM BELT         @P          3
T-P: FM BELT         AV          2
T-P: FM BELT         CM         94
T-P: FM BODY PLY     @C         10
T-P: FM BODY PLY     @P          6
T-P: FM BODY PLY     AV          1
T-P: FM BODY PLY     CM         80
T-P: FM CAP PLY      @C          3
T-P: FM CAP PLY      @P          3
T-P: FM CAP PLY      CM          4
T-P: FM GENERAL      @C         39
T-P: FM GENERAL      @P          2
T-P: FM GENERAL      AV         10
T-P: FM GENERAL      CM        494
T-P: FM INNERLINER   @C          5
T-P: FM INNERLINER   @P          3
T-P: FM INNERLINER   AV          2
T-P: FM INNERLINER   CM         87
T-P: FM RIM CUSHION  @C          6
T-P: FM RIM CUSHION  @P          3
T-P: FM RIM CUSHION  AV          3
T-P: FM RIM CUSHION  CM         48
T-P: FM SIDEWALL     @C         25
T-P: FM SIDEWALL     @P          8
T-P: FM SIDEWALL     CM        116
T-P: FM TECH LAYER   @C         23
T-P: FM TECH LAYER   @P          3
T-P: FM TECH LAYER   CM         70
T-P: FM TREAD        @C        113
T-P: FM TREAD        @P         45
T-P: FM TREAD        AV         62
T-P: FM TREAD        CM        894
T-P: FM WING TIP     @C          3
T-P: FM WING TIP     @P          3
T-P: FM WING TIP     CM          7
T-P: FM blend        @C       1235
T-P: FM blend        @P        109
T-P: FM blend        AV         25
T-P: FM blend        CM       7181
T-P: FM release      @C       1673
T-P: FM release      @P        138
T-P: FM release      AV          3
T-P: FM release      CM       4769
T-P: General         @C       1444     --Cancelled
T-P: General         @P        135
T-P: General         AV         27
T-P: General         CM       7301
T-P: LAT100 wheel    @C         77     --Cancelled
T-P: LAT100 wheel    CM         25
T-P: POLYM           @C        212     --Cancelled
T-P: POLYM           @P         37
T-P: POLYM           AV          2
T-P: POLYM           CM        996
T-P: RIMCUSHION      @C         35     --Cancelled
T-P: RIMCUSHION      CM          8
T-P: Reference       @C         19     --Cancelled
T-P: Reference       CM         51
T-P: SIDEWALL        @C         97     --Cancelled
T-P: SIDEWALL        @P          1
T-P: SIDEWALL        CM         13
T-P: STEELCOMP       @C        106     --Cancelled
T-P: STEELCOMP       @P         25
T-P: STEELCOMP       AV          1
T-P: STEELCOMP       CM        492
T-P: STEELCORD       @C        121     --Cancelled
T-P: STEELCORD       AV          2
T-P: STEELCORD       CM        412
T-P: TEXTCOMP        @C        368     --Cancelled
T-P: TEXTCOMP        @P         34
T-P: TEXTCOMP        AV         13
T-P: TEXTCOMP        CM       1414
T-P: TREAD           @C        371     --Cancelled
T-P: TREAD           @P          7
T-P: TREAD           CM        456
T-P: UNDERTREAD      @C         25     --Cancelled
T-P: UNDERTREAD      @P          1
T-P: UNDERTREAD      CM          6
T-P: WINGTIP         @C          9
T-P: XNP             @C       8039     --Cancelled
T-P: XNP             @P        493
T-P: XNP             AV         30
T-P: XNP             CM      39061
T-P: XNP APEX        @C         18
T-P: XNP APEX        @P         14
T-P: XNP APEX        AV          1
T-P: XNP APEX        CM         73
T-P: XNP BASE        @C         77
T-P: XNP BASE        @P          1
T-P: XNP BASE        AV          9
T-P: XNP BASE        CM        361
T-P: XNP BEAD INSUL  @C          2
T-P: XNP BEAD INSUL  @P          1
T-P: XNP BEAD INSUL  AV          1
T-P: XNP BEAD INSUL  CM         11
T-P: XNP BELT        @C          5
T-P: XNP BELT        @P          1
T-P: XNP BELT        AV          1
T-P: XNP BELT        CM        210
T-P: XNP BODY PLY    @C          7
T-P: XNP BODY PLY    @P          4
T-P: XNP BODY PLY    AV          1
T-P: XNP BODY PLY    CM         89
T-P: XNP CAP PLY     @C          5
T-P: XNP CAP PLY     AV          1
T-P: XNP CAP PLY     CM          4
T-P: XNP GENERAL     @C         69
T-P: XNP GENERAL     @P          2
T-P: XNP GENERAL     AV          7
T-P: XNP GENERAL     CM        785
T-P: XNP INNERLINER  @C          5
T-P: XNP INNERLINER  @P          1
T-P: XNP INNERLINER  AV          1
T-P: XNP INNERLINER  CM         92
T-P: XNP RIM CUSHION @C         12
T-P: XNP RIM CUSHION @P          1
T-P: XNP RIM CUSHION AV          1
T-P: XNP RIM CUSHION CM         91
T-P: XNP SIDEWALL    @C         32
T-P: XNP SIDEWALL    @P          7
T-P: XNP SIDEWALL    AV          1
T-P: XNP SIDEWALL    CM        141
T-P: XNP TECH LAYER  @C         16
T-P: XNP TECH LAYER  @P          2
T-P: XNP TECH LAYER  AV          1
T-P: XNP TECH LAYER  CM         99
T-P: XNP TREAD       @C         96     --Cancelled
T-P: XNP TREAD       @P         62
T-P: XNP TREAD       AV         58
T-P: XNP TREAD       CM       1555
T-P: XNP WING TIP    @C          3
T-P: XNP WING TIP    @P          1
T-P: XNP WING TIP    AV          4
T-P: XNP WING TIP    CM          8
T-P: XNP release     @C        231     --Cancelled
T-P: XNP release     CM         58
T-PG: CA Tyre        @C         45
T-PG: CA Tyre        @P          2
T-PG: CA Tyre        CM         22
T-S: ATP AKS 1       @C          3
T-S: ATP AKS 1       AV          1
T-S: ATP AKS 1       CM          1
T-S: ATP AKS 1-L1    @C          3
T-S: ATP AKS 1-L1    AV          1
T-S: ATP AKS 1-L1    CM          1
T-S: ATP AKS 1-L2    @C          3
T-S: ATP AKS 1-L2    AV          1
T-S: ATP AKS 1-L2    CM          1
T-S: ATP AKS 1-R1    @C          3
T-S: ATP AKS 1-R1    AV          1
T-S: ATP AKS 1-R1    CM          1
T-S: ATP AKS 1-R2    @C          3
T-S: ATP AKS 1-R2    AV          1
T-S: ATP AKS 1-R2    CM          1
T-S: ATP AKS 2       @C          2
T-S: ATP AKS 2       AV          1
T-S: ATP AKS 2       CM          1
T-S: ATP AKS 2-L1    @C          2
T-S: ATP AKS 2-L1    AV          1
T-S: ATP AKS 2-L1    CM          1
T-S: ATP AKS 2-L2    @C          2
T-S: ATP AKS 2-L2    AV          1
T-S: ATP AKS 2-L2    CM          1
T-S: ATP AKS 2-R1    @C          2
T-S: ATP AKS 2-R1    AV          1
T-S: ATP AKS 2-R1    CM          1
T-S: ATP AKS 2-R2    @C          2
T-S: ATP AKS 2-R2    AV          1
T-S: ATP AKS 2-R2    CM          1
T-S: ATP BMK 4       @C          2
T-S: ATP BMK 4       AV          1
T-S: ATP BMK 4       CM          1
T-S: ATP BMK 4-L1    @C          2
T-S: ATP BMK 4-L1    AV          1
T-S: ATP BMK 4-L1    CM          1
T-S: ATP BMK 4-L2    @C          2
T-S: ATP BMK 4-L2    AV          1
T-S: ATP BMK 4-L2    CM          1
T-S: ATP BMK 4-L3    @C          2
T-S: ATP BMK 4-L3    AV          1
T-S: ATP BMK 4-L3    CM          1
T-S: ATP BMK 4-R1    @C          2
T-S: ATP BMK 4-R1    AV          1
T-S: ATP BMK 4-R1    CM          1
T-S: ATP BMK 4-R2    @C          2
T-S: ATP BMK 4-R2    AV          1
T-S: ATP BMK 4-R2    CM          1
T-S: ATP BMK 4-R3    @C          2
T-S: ATP BMK 4-R3    AV          1
T-S: ATP BMK 4-R3    CM          1
T-S: ATP BMK 6       @C          2
T-S: ATP BMK 6       AV          1
T-S: ATP BMK 6       CM          1
T-S: ATP BMK 6-L1    @C          2
T-S: ATP BMK 6-L1    AV          1
T-S: ATP BMK 6-L1    CM          1
T-S: ATP BMK 6-L2    @C          2
T-S: ATP BMK 6-L2    AV          1
T-S: ATP BMK 6-L2    CM          1
T-S: ATP BMK 6-L3    @C          2
T-S: ATP BMK 6-L3    AV          1
T-S: ATP BMK 6-L3    CM          1
T-S: ATP BMK 6-R1    @C          2
T-S: ATP BMK 6-R1    AV          1
T-S: ATP BMK 6-R1    CM          1
T-S: ATP BMK 6-R2    @C          2
T-S: ATP BMK 6-R2    AV          1
T-S: ATP BMK 6-R2    CM          1
T-S: ATP BMK 6-R3    @C          2
T-S: ATP BMK 6-R3    AV          1
T-S: ATP BMK 6-R3    CM          1
T-S: ATP BMK 6a      @C          2
T-S: ATP BMK 6a      AV          1
T-S: ATP BMK 6a      CM          1
T-S: ATP BMK 6a-L1   @C          2
T-S: ATP BMK 6a-L1   AV          1
T-S: ATP BMK 6a-L1   CM          1
T-S: ATP BMK 6a-L2   @C          2
T-S: ATP BMK 6a-L2   AV          1
T-S: ATP BMK 6a-L2   CM          1
T-S: ATP BMK 6a-L3   @C          2
T-S: ATP BMK 6a-L3   AV          1
T-S: ATP BMK 6a-L3   CM          1
T-S: Idiada Tr2 1    AV          1
T-S: Idiada Tr2 1-L1 AV          1
T-S: Idiada Tr2 1-L2 AV          1
T-S: Idiada Tr2 1-R1 AV          1
T-S: Idiada Tr2 1-R2 AV          1
T-S: Idiada Tr7 2    AV          1
T-S: Idiada Tr7 2-L1 AV          1
T-S: Idiada Tr7 2-L2 AV          1
T-S: Idiada Tr7 2-L3 AV          1
T-S: Idiada Tr7 2-R1 AV          1
T-S: Idiada Tr7 2-R2 AV          1
T-S: Idiada Tr7 2-R3 AV          1
T-T: AT Endurance    @C        352     --Cancelled
T-T: AT Endurance    @P          7
T-T: AT Endurance    AV         17
T-T: AT Endurance    CM       1628
T-T: AT Endurance    IR          1
T-T: AT Indoor std 1 @C        383     --Cancelled
T-T: AT Indoor std 1 @P         10
T-T: AT Indoor std 1 AV         19
T-T: AT Indoor std 1 CM       1636
T-T: PCT Aquaplaning @C         20     --Cancelled
T-T: PCT Aquaplaning AV          2
T-T: PCT Aquaplaning CM         62
T-T: PCT Dry Hand.   @C        278     --Cancelled
T-T: PCT Dry Hand.   CM         80
T-T: PCT Dry braking @C        182     --Cancelled
T-T: PCT Dry braking CM        140
T-T: PCT Indoor adv. @C       2947     --Cancelled
T-T: PCT Indoor adv. @P          9
T-T: PCT Indoor adv. AV         56
T-T: PCT Indoor adv. CM       7981
T-T: PCT Indoor adv. RJ          1
T-T: PCT Indoor adv. SU         51
T-T: PCT Indoor adv. WH         33
T-T: PCT Noise       @C        134     --Cancelled
T-T: PCT Noise       CM         22
T-T: PCT Outdoor     @C        759     --Cancelled
T-T: PCT Outdoor     AV          8
T-T: PCT Outdoor     CM         32
T-T: PCT Outdoor I   @C        676     --Cancelled
T-T: PCT Outdoor I   @P        115
T-T: PCT Outdoor I   AV        446
T-T: PCT Outdoor I   CM       1108
T-T: PCT RnD Indoor  @C        649     --Cancelled
T-T: PCT RnD Indoor  @P         74
T-T: PCT RnD Indoor  AV        153
T-T: PCT RnD Indoor  CM       2399
T-T: PCT Section     @C         63     --Cancelled
T-T: PCT Section     @P          5
T-T: PCT Section     CM         36
T-T: PCT Wear        @C        255     --Cancelled
T-T: PCT Wear        @P         11
T-T: PCT Wear        CM        483
T-T: PCT Wear FL     @C          5     --Cancelled
T-T: PCT Wear FL     CM          9
T-T: PCT Wear FR     @C          5     --Cancelled
T-T: PCT Wear FR     CM          9
T-T: PCT Wear RL     @C          5     --Cancelled
T-T: PCT Wear RL     CM          9
T-T: PCT Wear RR     @C          5     --Cancelled
T-T: PCT Wear RR     CM          8
T-T: PCT Wear Set    @C        167     --Cancelled
T-T: PCT Wear Set    @P         20
T-T: PCT Wear Set    AV          3
T-T: PCT Wear Set    CM        207
T-T: PCT Wear mixed  @C         12
T-T: PCT Wear mixed  AV         10
T-T: PCT Wear mixed  CM         16
T-T: PCT Wear normal @C         31     --Cancelled
T-T: PCT Wear normal @P         38
T-T: PCT Wear normal AV         30
T-T: PCT Wear normal CM         77
T-T: PCT Wet braking @C        224     --Cancelled
T-T: PCT Wet braking CM        180
T-T: PCT Winter test @C         55     --Cancelled
T-T: PCT Winter test CM         81
T-T: PCT indoor BM   @C         33     --Cancelled
T-T: PCT mixed set   @C        276     --Cancelled
T-T: PCT mixed set   @P         24
T-T: PCT mixed set   AV          1
T-T: PCT mixed set   CM        576
T-T: PCT normal set  @C       5151     --Cancelled
T-T: PCT normal set  @P        396
T-T: PCT normal set  AV        499
T-T: PCT normal set  CM      15944
T-T: PCT open set    @C        271     --Cancelled
T-T: PCT open set    @P         71
T-T: PCT open set    AV         34
T-T: PCT open set    CM        478
T-T: SM indoor std 1 @C        269     --Cancelled
T-T: SM indoor std 1 @P         26
T-T: SM indoor std 1 AV         12
T-T: SM indoor std 1 CM       1427
T-T: TWT indoor std  @C         68     --Cancelled
T-T: TWT indoor std  @P          4
T-T: TWT indoor std  AV          9
T-T: TWT indoor std  CM         24
T-T: TWT mixed set   @C          2
T-T: TWT mixed set   CM         14
T-TG: PCT Endurance  @C        621     --Cancelled
T-TG: PCT Endurance  @P        111
T-TG: PCT Endurance  AV         92
T-TG: PCT Endurance  CM       2119
T-TG: PCT High speed @C       2748     --Cancelled
T-TG: PCT High speed @P        502
T-TG: PCT High speed AV        415
T-TG: PCT High speed CM      13212
T-TG: PCT Indoor adv @C        230
T-TG: PCT Indoor adv @P         18
T-TG: PCT Indoor adv AV         11
T-TG: PCT Indoor adv CM        151
T-TG: PCT Runflat    @C          3
T-TG: PCT Runflat    @P          1
T-TG: PCT Runflat    CM          1
T-TG: PCT indoor s1  @C       1057     --Cancelled
T-TG: PCT indoor s1  @P        183
T-TG: PCT indoor s1  AV        122
T-TG: PCT indoor s1  CM       5772
T-TG: PCT indoor s2  @C        141     --Cancelled
T-TG: PCT indoor s2  @P         11
T-TG: PCT indoor s2  AV          3
T-TG: PCT indoor s2  CM        511
T-TG: TBR Endurance  @C          7     --Cancelled
T-TG: TBR Endurance  @P         10
T-TG: TBR Endurance  AV          4
T-TG: TBR Endurance  CM          2
T-TG: TBR High speed @C          4     --Cancelled
T-TG: TBR High speed @P          9
T-TG: TBR High speed AV          2
T-TG: TBR High speed CM          1
T-TG: TBR indoor s1  @C          2     --Cancelled
T-TG: TBR indoor s1  @P          8
T-TG: TBR indoor s1  AV          1
T444                 @C         25     --Cancelled
T444                 CM          7
T444                 SC         33
T444                 WC         11
T555                 @C         15     --Cancelled
T555                 AV          3
T555                 CM          6
T555                 OS          2
T555                 SC         16
T555                 WC          3
T: PCT Endurance     @C       4200     --Cancelled
T: PCT Endurance     @P         32
T: PCT Endurance     AV         52
T: PCT Endurance     CM      12401
T: PCT Endurance     SU         94
T: PCT Endurance     WH         19
T: PCT High speed    @C       9570     --Cancelled
T: PCT High speed    @P         60
T: PCT High speed    AV        130
T: PCT High speed    CM      34681
T: PCT High speed    OR         10
T: PCT High speed    SU        265
T: PCT High speed    WH         27
T: PCT Runflat       @C        115     --Cancelled
T: PCT Runflat       CM        114
T: PCT Runflat       RJ          1
T: PCT indoor adv    @C          4
T: PCT indoor adv    AV          2
T: PCT indoor adv    CM          1
T: PCT indoor std    @C         39
T: PCT indoor std    @P          2
T: PCT indoor std    CM         16
T: PCT indoor std 1  @C       3542     --Cancelled
T: PCT indoor std 1  @P         49
T: PCT indoor std 1  AV         72
T: PCT indoor std 1  CM       5867
T: PCT indoor std 1  OR          3
T: PCT indoor std 1  RJ          2
T: PCT indoor std 1  SU        102
T: PCT indoor std 1  WH         40
T: PCT indoor std 2  @C        799     --Cancelled
T: PCT indoor std 2  @P          4
T: PCT indoor std 2  AV          2
T: PCT indoor std 2  CM       1242
T: PCT indoor std 2  SU         13

605 rows selected.
*/

--HOW MANY SAMPLES AVAILABLE RELATED TO SAMPLE-TYPE / REQUEST-TYPE
select rt.rt, rq.ss, st.ST, sc.ss, count(*) aantal_sc
from utst st
,    utsc sc
,    utrt rt
,    utrq rq
where st.version_is_current = 1
and   rt.version_is_current = 1
and   st.st = sc.st
and   rt.rt = rq.rt
and   sc.rq = rq.rq
and   st.st like 'T%'   --NOT INCLUDED: production-samples
and   sc.ss not in ('@C')
and   rq.ss not in ('@C')
and   st.ss = '@A'      --sample-type-status=Approved 
and   rt.ss = '@A'      --request-type-status=Approved 
--and   rq.ss in ('@A')
group by rt.rt, rq.ss, st.ST, sc.ss
order by rt.rt, rq.ss, st.ST, sc.ss
;

--*************************************************************************
-- RELATION SPEC-TYPE vs REQUEST-TYPE 
--*************************************************************************
-- UTRTGKSPEC_TYPE
--*************************************************************************
select gk.SPEC_TYPE ||';'||gk.RT||';'||gk.VERSION
from utrtgkspec_type gk
where gk.version = (select max(gk2.version) from utrtgkspec_type gk2 where gk2.rt = gk.rt)
order by gk.spec_type, gk.rt


--*************************************************************************
-- RELATION REQUEST-TYPE vs SAMPLE-TYPE
--*************************************************************************
-- UTRTST
--*************************************************************************
select r.RT ||';'||r.VERSION||';'||r.ST||';'||r.seq
from utrtst r
where r.version = (select max(r2.version) from utrtst r2 where r2.rt = r.rt)
order by r.rt, r.seq
;





--***************************************************************************
--***************************************************************************
--parameters  UTPR
--***************************************************************************
--***************************************************************************
/*
PR					VARCHAR2(20 CHAR)	No		1	Parameter (configurational level)
VERSION				VARCHAR2(20 CHAR)	No		2	
VERSION_IS_CURRENT	CHAR(1 CHAR)		Yes		3	
EFFECTIVE_FROM		TIMESTAMP(0) WITH LOCAL TIME ZONE	Yes		4	
EFFECTIVE_TILL		TIMESTAMP(0) WITH LOCAL TIME ZONE	Yes		5	
DESCRIPTION			VARCHAR2(40 CHAR)	Yes		6	
DESCRIPTION2		VARCHAR2(40 CHAR)	Yes		7	
UNIT				VARCHAR2(20 CHAR)	Yes		8	type of trending unit (e.g. sample unit, time unit)
FORMAT				VARCHAR2(40 CHAR)	Yes		9	See Design Specifications 
TD_INFO				NUMBER(3,0)			No		10	counter or timer value (td_info_unit); trending info per parameter
TD_INFO_UNIT		VARCHAR2(20 CHAR)	Yes		11	Count / minute(s),...,year(s)
CONFIRM_UID			CHAR(1 CHAR)		Yes		12	[1/0] UserID and password must be entered in case of manual parameter assignment at operational level
DEF_VAL_TP			CHAR(1 CHAR)		Yes		13	CASE def_val_tp = F (fixed) => def_au_level = NULL/def_val (fixed entered value, otherwise object specific value); CASE def_val_tp = A (attribute) => def_au_level = the object type (defined in UTOBJECTS), for each occurrence the exact list will be specified/def_val contains attribute which holds the actual value.   
DEF_AU_LEVEL		VARCHAR2(4 CHAR)	Yes		14	= NULL CASE def_val_tp '= F(fixed);'= the object type (defined in UTOBJECTS) for each occurrence the exact list will be specified CASE def_val_tp '= A(attribute)'
DEF_VAL				VARCHAR2(40 CHAR)	Yes		15	fixed entered value, otherwise object specific value CASE def_val_tp '= F(fixed); contains attribute which holds the actual value CASE def_val_tp '= A
ALLOW_ANY_MT		CHAR(1 CHAR)		Yes		16	[1/0] Method selection list the analist gets(when assigning a method ad hoc to a parameter) is restricted to the parameters that have been explicitly assigned to the parameter definition or not 
DELAY				NUMBER(3,0)			No		17	
DELAY_UNIT			VARCHAR2(20 CHAR)	Yes		18	
MIN_NR_RESULTS		NUMBER(3,0)			No		19	number of measurements necessary to calculate the parameter result
CALC_METHOD			CHAR(1 CHAR)		Yes		20	[F/L/H/A/C]
CALC_CF				VARCHAR2(20 CHAR)	Yes		21	NULL except when cal_method = C
ALARM_ORDER			VARCHAR2(3 CHAR)	Yes		22	The alarm_order contains a 3 character string which indicates the evaluation order of the 3 different sets of specifications (utppspa, utppspa and utppspc)
SETA_SPECS			VARCHAR2(20 CHAR)	Yes		23	See Design Specifications for the list of values allowed
SETA_LIMITS			VARCHAR2(20 CHAR)	Yes		24	See Design Specifications for the list of values allowed
SETA_TARGET			VARCHAR2(20 CHAR)	Yes		25	See Design Specifications for the list of values allowed
SETB_SPECS			VARCHAR2(20 CHAR)	Yes		26	See Design Specifications for the list of values allowed
SETB_LIMITS			VARCHAR2(20 CHAR)	Yes		27	See Design Specifications for the list of values allowed
SETB_TARGET			VARCHAR2(20 CHAR)	Yes		28	See Design Specifications for the list of values allowed
SETC_SPECS			VARCHAR2(20 CHAR)	Yes		29	See Design Specifications for the list of values allowed
SETC_LIMITS			VARCHAR2(20 CHAR)	Yes		30	See Design Specifications for the list of values allowed
SETC_TARGET			VARCHAR2(20 CHAR)	Yes		31	See Design Specifications for the list of values allowed
IS_TEMPLATE			CHAR(1 CHAR)		Yes		32	
LOG_EXCEPTIONS		CHAR(1 CHAR)		Yes		33	[1/0] Results that are out of specifications are stored in a separate table; used for the generation of exception reports
SC_LC				VARCHAR2(2 CHAR)	Yes		34	
SC_LC_VERSION		VARCHAR2(20 CHAR)	Yes		35	
INHERIT_AU			CHAR(1 CHAR)		Yes		36	
LAST_COMMENT		VARCHAR2(255 CHAR)	Yes		37	
PR_CLASS			VARCHAR2(2 CHAR)	Yes		38	
LOG_HS				CHAR(1 CHAR)		Yes		39	
LOG_HS_DETAILS		CHAR(1 CHAR)		Yes		40	
ALLOW_MODIFY		CHAR(1 CHAR)		Yes		41	
ACTIVE				CHAR(1 CHAR)		Yes		42	
LC					VARCHAR2(2 CHAR)	Yes		43	Default life cycle model for parameter, can be changed by authorized users
LC_VERSION			VARCHAR2(20 CHAR)	Yes		44	
SS					VARCHAR2(2 CHAR)	Yes		45	state
AR1					CHAR(1 CHAR)		Yes	'W'	46	
AR2					CHAR(1 CHAR)		Yes	'W'	47	
AR3					CHAR(1 CHAR)		Yes	'W'	48	
AR4					CHAR(1 CHAR)		Yes	'W'	49	
AR5					CHAR(1 CHAR)		Yes	'W'	50	
AR6					CHAR(1 CHAR)		Yes	'W'	51	
AR7					CHAR(1 CHAR)		Yes	'W'	52	
AR8					CHAR(1 CHAR)		Yes	'W'	53	
AR9					CHAR(1 CHAR)		Yes	'W'	54	
AR10				CHAR(1 CHAR)		Yes	'W'	55	
AR11				CHAR(1 CHAR)		Yes	'W'	56	
AR12				CHAR(1 CHAR)		Yes	'W'	57	
AR13				CHAR(1 CHAR)		Yes	'W'	58	
*/

select pr ||';'|| version ||';'|| effective_from ||';'|| effective_till ||';'|| DESCRIPTION ||';'|| lc ||';'|| ss
from utpr st
where st.version_is_current = 1
;

--hoeveel parameters by parameter-type
select pa.pg ||';'|| pa.pa ||';'|| pa.ss ||';'|| count(*)
from utscpa pa
,    utpr   pr
where pa.pa = pr.pr
and   pa.pr_version = pr.version
and   pr.version_is_current = 1
and   pa.ss NOT IN ('@C')
group by pa.pg, pa.pa, pa.ss
order by pa.pg, pa.pa, pa.ss
;


--**************************************************************
--UTSCME
--**************************************************************
SELECT scme, count(*)
from (select pg ||';'|| pa ||';'|| me ||';'|| DESCRIPTION ||';'|| lc ||';'|| ss    scme
     from utscme me
     where me.ss not in ('@C')
    )
group by scme
order by scme
;

--**************************************************************
--UTSCMECELL
--**************************************************************
select * 
from utscmecell 
where sc = 'AHM0926056T05'
and   me = 'TT749A'
and   menode = 4000000
and  cell = 'Equipement'
order by sc, pg, pa, me, cell, value_s
;
--AHM0926056T05	Indoor testing	1000000	TT749AX	1000000	TT749A	4000000	0	Equipement	1000000	Equipement		TEST_TM06	D	150	115	L	15	10	0	0	0		C	-			I		SaveAsMeGk	1	10	0
select * 
from utscmecelllist 
where sc = 'AHM0926056T05'
and   me = 'TT749A'
and   menode = 4000000
and  cell = 'Equipement'
order by sc, pg, pa, me, cell, value_s
;
AHM0926056T05	Indoor testing	1000000	TT749AX	1000000	TT749A	4000000	0	Equipement	0	2		TEST_TM01	0
AHM0926056T05	Indoor testing	1000000	TT749AX	1000000	TT749A	4000000	0	Equipement	0	3		TEST_TM04	0
AHM0926056T05	Indoor testing	1000000	TT749AX	1000000	TT749A	4000000	0	Equipement	0	0		TEST_TM06	1
AHM0926056T05	Indoor testing	1000000	TT749AX	1000000	TT749A	4000000	0	Equipement	0	4		TEST_TM08	0
AHM0926056T05	Indoor testing	1000000	TT749AX	1000000	TT749A	4000000	0	Equipement	0	1		TEST_TM13	0

SELECT scmecell, count(*)
from (select pg ||';'|| pa ||';'|| me ||';'|| cell ||';' || DSP_TITLE    scmecell
     from utscmecell mec
    )
group by scmecell
order by scmecell
;

--select mecell with cell-list related
SELECT scmecell, count(*)
from (select pg ||';'|| pa ||';'|| me ||';'|| cell ||';' || DSP_TITLE    scmecell
     from utscmecell mec
	 where exists (select '' from utscmecelllist mecl where mecl.sc = mec.sc and mecl.me = mec.me and mecl.menode = mec.menode and mecl.cell = mec.cell)
    )
group by scmecell
order by scmecell
;

--NUMBER Of unike MECELLLIST
select count(distinct cell) from utscmecelllist;
--357x

--investigate vba/sql-scripts.
select table_name from all_tables where owner='UNILAB' and table_name lIKE '%SQL%';

select distinct gk from UTGKCHSQL; 
--no rows selected
select distinct gk from UTGKDCSQL;
--no rows selected
select distinct gk from UTGKMESQL;
--no rows selected
select distinct gk from UTGKPTSQL;
--no rows selected
select distinct gk from UTGKRQSQL;  
--1x RqExecutor
select distinct gk from UTGKRTSQL;
requesterUp
rqCreateUp
rqListUp
userProfiles

select distinct gk from UTGKSCSQL;
unsdlo
unsdtp

select distinct gk from UTGKSDSQL;
--no rows selected
select distinct gk from UTGKSTSQL;
Site
scCreateUp
scListUp
scReceiverUp
scRecieveUp

select distinct gk from UTGKWSSQL;  
--1x Testweek

select distinct au from UTAUSQL;
/*
AU
------------------------------------------------------------
avCustCopyIiTo
avCustCopyPartnoTo
avCustMaxScDate
avCustRqIiCopyFrom
avCustSubSampleMT
avCustSubSamplePP
avCustSubSamplePR
avCustSubSampleST
avCustWaitFor
avCustWt
avManagedByUp
avSite
avSiteDef
avSubSampleMeLink
avSuperSampleMe
avSuperSamplePa
avSuperSamplePg
avSuperSampleSc
parent_group
prcalc_addrq
prcalc_openjournal
relatedfield
uncommentad
uncommentau
uncommentch
uncommentcy
uncommenteq
uncommentic
uncommentie
uncommentip
uncommentlc
uncommentme
uncommentmt
uncommentpa
uncommentpg
uncommentpp
uncommentpr
uncommentpt
uncommentrq
uncommentrt
uncommentsc
uncommentsd
uncommentst
uncommentuc
uncommentup
uncommentws
uncommentwt
user_group

48 rows selected.
*/

select distinct ie from UTIESQL;
/*
IE
------------------------------------------------------------
AvDeliveryMain
RefSetDesc
TestLocation
TestVehicleType
avAssignPg
avDeliveryBox
avDeliveryCity
avDeliveryContact
avDeliveryCountry
avDeliveryPhone
avDeliveryStreet
avDeliveryStreetNr
avDeliveryZip
avExecLocTrack
avExecWeather
avExecutionLocation
avLPIEngineer
avPartNo
avPartNoFront
avPartNoOutdoor
avPartNoRear
avPartNoSingleTyre
avPartNoStartChars
avProdEquipement
avProject
avReinfRef
avRequester
avRqBuildingWeekNum
avRqPlannedExeWeekNu
avRqSite
avSamplingPoint
avScAmountLst
avScMatTargetStart
avScSite
avScTtPerfIndEnd
avScTtTargetEnd
avScTtTargetStart
avSite
avSpecRef
avSupplierCode
avVehicleBrandType
avVerhicleLicense
avbmRqTotalCost
testPartNoQuery

44 rows selected.
*/

select distinct tk from UTTKSQL;   
/* 
TK
------------------------------------------------------------
AssignSc2Location
FPS OHT
FPS input OHT
FPS input OHT FEA
My manufacture
My requests
My requests indoor
Pulling
SdSamples
Tyre Indoor TT510
avApprove
avApproveFlattrack
avApproveIndoor
avApproveMultiSite
avApproveOutdoor
avApprovePCT_proto
avApproveTWT
avApproveTransport
avAvailable
avCreateMult
avDef
avDefNoLab
avDefTtIndoor
avOrder
avOrderBM
avOutdoor
avPlanEquipIndoor
avPlanEquipement
avPlanning
avPower
avProtoReq
avReceive
avSend
avSetLabList
avSsMandToday
avTWT
avTemporary
avToValidate
avToValidateIndoor
avTransport
avTyreCheckin
avTyreCheckinTrial
avVulcanisation
avWarehouse2lab
*/


--######################
--UTRQIC - UTRQII
--######################
select ic, count(*) 
from utrqic
group by ic
order by ic
;
--aantal RQ per RT/IC
select rq.rt, ic.ic, count(*) 
from utrqic ic
,    utrq rq
where rq.rq = ic.rq
and   
group by rq.rt, ic.ic
order by rq.rt, ic.ic
;

select DISTINCT 'REQUEST-INFOCARD', ic, ii 
from utrqii
order by ic, ii
;


--######################
--UTscIC - UTscII
--######################
select ic, count(*) 
from utscic
group by ic
order by ic
;
--aantal SC per sT/IC
select sc.st, ic.ic, count(*) 
from utscic ic
,    utsc sc
where sc.sc = ic.sc
group by sc.st, ic.ic
order by sc.st, ic.ic
;

select DISTINCT 'SAMPLE-INFOCARD', ic, ii 
from utscii
order by ic, ii
;

--######################
--UTIE 
--######################
select ie.ie||';'|| ie.dsp_title||';'|| def_au_level||';'|| ievalue||';'|| ie.look_up_ptr
from utie ie
where version_is_current = 1
order by ie
;


--##########################
--UTBLOB - UTLONGTEXT
--##########################
select blb.id
,     blb.description 
from utblob blb
INNER JOIN utlongtext lng on blb.id = lng.doc_id
;
--no-rows-selected


--##########################
--ASSIGN FULL-TESTPLAN...
--##########################
--RELATION via UTRTST !!!!!
--##########################
--UTPP
--##########################
select pp.pp||';'||   pp.pp_key1 ||';'||     pp.description||';'||    pp.description2||';'||    pp.sc_lc
FROM UTPP pp
where  pp.effective_till is null
and pp.version = (select max(pp2.version) from utpp pp2 where pp2.pp = pp.pp )
order by pp.pp
,        pp.pp_key1
;



select rt.rt
,      rt.version
,      rt.pp
from utrtpp rt
where rt.version = (select max(rt2.version) from utrtpp rt2 where rt2.rt = rt.rt)
;
/*
MT-P: FM lab			0001.14	MP001
MT-P: FM lab			0001.14	MP003
MT-P: Reference			0001.06	MP003
MT-P: XNP lab			0001.09	MP001
MT-P: XNP lab			0001.09	MP003
T-P: FM					001.07	MP003
T-P: FM					0001.07	MP006
M-F: FM					0001.01	MF200A
M-F: FM					0001.01	MF201A
MT-P: XNP				0001.05	MP003
T-P: FM blend			0001.09	MP006
T-O: PCT Ordering BM	0002.00	PCT Order
MT-P: LAT100			0001.02	MP003
T-O: PCT Intern tyre	0001.04	PCT Order
T-O: PCT transport		0001.05	PCT Order
T-O: PCT transport		0001.05	PCT Order
T-O: PCT transport		0001.05	PCT receive req
T-O: PCT transport		0001.05	PCT transport req
*/


select table_name, column_name 
from all_tab_columns 
where owner='UNILAB' 
and column_name like 'ST'
and table_name like 'UT%'
AND TABLE_NAME NOT LIKE 'UT%GK%'
AND TABLE_NAME NOT LIKE 'UTR%'
;
/*
UTEQCA			ST
UTMELSSAVESAMPLE	ST
UTPRCYST		ST
UTPTCELLST		ST
UTPTCELLSTAU	ST
UTSC			ST
UTSCPATD		ST
UTST			ST
UTSTAU			ST
UTSTHS			ST
UTSTHSDETAILS	ST
UTSTIP			ST			--infocard/fields:  ST, IP
UTSTIPAU		ST
UTSTIPBUFFER	ST
UTSTMTFREQ		ST
UTSTMTFREQBUFFER	ST
UTSTPP			ST			--ST, PP, PP_KEY1
UTSTPPAU		ST
UTSTPPBUFFER	ST
UTSTPRFREQ		ST
UTSTPRFREQBUFFER	ST
UTWTROWS		ST
*/


--relatie UTSCPG + UTPP
select pg 
from utscpg sc
where not exists (select pp.pp from utpp pp where pp.pp = sc.pg)
;
--alleen "/" komt niet voor !!!! Dus OK !!!

--relatie UTSCPG + UTPP
select DISTINCT pa
from utscpa sc
where not exists (select pr.pr from utpr pr where pr.pr = sc.pa)
;
--Er komen wel wat PARAMETERS voor die NIET in config zitten, maar dat lijkt niet interessant te zijn...
/*
(Halo-) IIR
(halo) IIR
(halo-) IIR
/
1
10
2
3
3,4 IR
38
4
5
6
7
8
9
BR
C5
C5 group
"C5_1"
C9
C9: 
"C9_1"
"C9_2"
"C9_3"
"C9_4"
CBS
CBS_1
Cashew
Cashew: 
"Cashew_1"
Cis
"Cycloaliph Hcarb_1"
Cycloaliphatic hydro
DCBS
DCBS_1
DPG
DPG_1
EPDM
ESBR
High-vinyl BR
Koresin
"Koresin_1"
Low-cis BR
MBS
MBT/MBTS
MBT/MBTS_1
Material 1
Material 2
Material 3
Material_1
Material_10
Material_12
Material_2
Material_20
Material_3
Material_4
Material_5
Material_6
Material_7
Material_8
Material_9
NR
NR/IR
No resin detected
"Phenol formal_1"
"Phenol-form_1"
"Phenol-form_2"
"Phenol-formald_1"
Polyurethane
"Resorcinol form_1"
"Resorcinol form_2"
Rosins
"Rosins_1"
SBR
SBR cis
SBR styrene
SBR trans
SBR vinyl
SSBR
See comment
Stiffness at 32.2 Hz
Styrene
TBBS/TBSI
TBBS/TBSI_1
TBzTD/ZBEC/Vulcuren
Terpenes
Terpenes: 
"Terpenes_1"
"Terpenes_2"
"Terpenes_3"
Trans
Vinyl
Vultac
ZDT-50/SDTS/ZBOPS
cis
gfdsgfdsafdsa
high-vinyl BR
low-cis BR
p-Octyl phe
raw data
see comment
styrene
trans
vinyl
*/

--komt CONFIG-PARAMETER nog voor met relatie naar CELLEN?
select table_name, column_name 
from all_tab_columns 
where owner='UNILAB' 
and column_name like 'PR'
and table_name like 'UT%'
AND TABLE_NAME NOT LIKE 'UT%GK%'
AND TABLE_NAME NOT LIKE 'UTR%'
;
/*
UTASSIGNFULLTESTPLAN		PR         --FULL-TESTPLAN ???
UTASSIGNFULLTESTPLAN_TMP	PR
UTCOMPARECUSTOMER			PR
UTPPPR			PR
UTPPPRAU		PR
UTPPPRBUFFER	PR
UTPPSPA			PR
UTPPSPB			PR
UTPPSPC			PR
UTPR			PR
UTPRAU			PR
UTPRCYST		PR
UTPRHS			PR
UTPRHSDETAILS	PR
UTPRMT			PR          --methodes?
UTPRMTAU		PR
UTPRMTBUFFER	PR
UTSTMTFREQ		PR
UTSTMTFREQBUFFER	PR
UTSTPRFREQ			PR
UTSTPRFREQBUFFER	PR
*/

--######################################
--UTMT
--######################################
select mt.mt||';'||mt.version||';'|| mt.description||';'|| mt.description2 ||';'|| mt.unit ||';' ||mt.executor ||';'||mt.eq_tp ||';'||mt.sc_lc  
FROM UTMT mt
where  mt.effective_till is null
and mt.version = (select max(mt2.version) from utmt mt2 where mt2.mt = mt.mt )
order by mt.mt
;

--######################################
--UTPRMT   (UTMT)
--######################################
select pr.pr ||';'||pr.version ||';'||pr.mt ||';'||pr.seq ||';'||pr.freq_unit
from utprmt pr
where pr.version = (select max(pr2.version) from utprmt pr2 where pr2.pr = pr.pr)
order by pr.pr, pr.seq
;

--komt CONFIG-METHOD nog voor met relatie naar CELLEN?
select table_name, column_name 
from all_tab_columns 
where owner='UNILAB' 
and column_name like 'MT'
and table_name like 'UT%'
AND TABLE_NAME NOT LIKE 'UT%GK%'
AND TABLE_NAME NOT LIKE 'UTR%'
;
/*
UTASSIGNFULLTESTPLAN		MT		--TESTPLAN, IS HELEMAAL LEEG, WORDT DUS NIET GEBRUIKT !!!
UTASSIGNFULLTESTPLAN_TMP	MT
UTCOMPARECUSTOMER		MT
UTEQCA			MT
UTMT			MT
UTMTAU			MT
UTMTCELL		MT		--relation naar cellen !!!
UTMTCELLEQTYPE	MT
UTMTCELLLIST	MT
UTMTCELLSPIN	MT
UTMTEL			MT
UTMTHS			MT
UTMTHSDETAILS	MT
UTMTMR			MT		--relatie naar UTMTMR ?? Is helemaal LEEG, wordt dus niet gebruikt !!!!
UTPPPR			MT		--relatie vanuit UTPPPR ?? Is overal LEEG, WORDT DUS NIET GEBRUIKT !!!!
UTPPPRBUFFER	MT
UTPRMT			MT      --PRMT: OK
UTPRMTAU		MT
UTPRMTBUFFER	MT
UTSTMTFREQ		MT
UTSTMTFREQBUFFER	MT
*/

--######################################
--UTMTCELL
--######################################
SELECT c.mt ||';'||
      c.version||';'||
      c.cell||';'||
      c.seq||';'||
      c.dsp_title||';'||
      c.save_tp||';'||
      c.save_pp||';'||
      c.save_pr||';'||
      c.save_mt||';'||
      c.unit||';'||
      c.calc_tp||';'||
      c.calc_formula
FROM utmtcell c
where c.version = (select max(c2.version) from utmtcell c2 where c2.mt = c.mt)
order by c.mt
,        c.seq
;


--######################################
--UTMTCELL-LIST
--######################################
SELECT c.mt ||';'|| c.version ||';'|| c.cell ||';'||index_x ||';'||index_y ||';'||value_s
FROM UTMTCELLLIST c
where c.version = (select max(c2.version) from utmtcelllist c2 where c2.mt = c.mt)
order by c.mt
,        c.index_x
,        c.index_y
;


--###################################################
--ONDERZOEK (en vulling van CONFIG/OPERATIONAL-TABLES...)
------------------------------------------------------
--RQ = PSC2121077T			RT = T: PCT indoor std
--SC = PSC2121077T01        ST = T: PCT High speed
--
select * from utrq where rq like 'PSC2121077T';
--PSC2121077T	T: PCT indoor std	0001.20	Testing PCT indoor standard
select * from utsc where sc like 'PSC2121077T01';
--PSC2121077T01	T: PCT High speed	0001.19	800/70R38 CHO 181D TRAXION HARVEST P22-0	0	DD	28-05-2021 11.12.39.000000000 AM	28-05-2021 11.17.01.000000000 AM	%	28-05-2021 11.23.59.000000000 AM	28-05-2021 11.23.59.000000000 AM	3				PSC2121077T

select * from utscpg where sc like 'PSC2121077T01';
PSC2121077T01	Indoor testing	500000	0001.20		T: PCT High speed	 	 	 	 	Indoor testing
PSC2121077T01	Tyre checkin	1000000	0001.00	 						 	 	 	 	Tyre checkin

select * from utscpa where sc like 'PSC2121077T01';
PSC2121077T01	Indoor testing	500000	TT457A	1000000	0001.09	Bead compression 
PSC2121077T01	Tyre checkin	1000000	TT510XX	1000000	0001.04	Tyre checkin

select * from utscmecell where sc like 'PSC2121077T01';
--null

--------------------------------------------------------------
--CONFIG:
select * from utst where st like 'T: PCT High speed'
--T: PCT High speed	0001.21	1	22-06-2022 04.22.46.000000000 PM		PCT High speed testing

select * from utstpp where st like 'T: PCT High speed'
ST                  VERSION PP
T: PCT High speed	0001.21	Indoor testing			~Current~	T: PCT High speed	 	 	 	 	1	N
T: PCT High speed	0001.21	Indoor testing misc.	~Current~	T: PCT High speed	 	 	 	 	2	N
T: PCT High speed	0001.21	OEM / Magazin tests		~Current~	T: PCT High speed	 	 	 	 	3	N
T: PCT High speed	0001.21	Tyre checkin			~Current~	 	 	 	 	 					4	A

--*******************************************************************************************************************
--*******************************************************************************************************************
--*******************************************************************************************************************
--LET OP: IN TABEL UTPPPR + UTPR KOMEN PER PR MEERDERE VOORKOMENS VOOR, met alleen voor PP_KEY1 een andere WAARDE !!!!!
--PR+VERSION ZIJN HETZELFDE !!!!
--BIJV. VOOR 
--T: PCT High speed		0001.21		Tyre checkin	0001.00	TT510XX	Tyre checkin	TT510XX	0001.04	Tyre checkin

--PP = T: PCT High speed	0001.21	Tyre checkin	0001.00	Tyre checkin	TT510XX	0001.04	Tyre checkin
--SELECT * FROM UTPP WHERE PP LIKE 'Tyre checkin';
--select * from utpppr where pp LIKE 'Tyre checkin';
--select * from utpr where pr='T1510X'

--*******************************************************************************************************************
--*******************************************************************************************************************
--*******************************************************************************************************************

select DISTINCT st.st
,      st.version
,      pp.pp
,      pp.version      pp_version
,      pp.pr           AV_TEST_METHOD
--,      p.pp_key1       
,      p.description   pp_description
,      pr.pr
,      pr.version      pr_version
,      pr.description  pr_description
from utpr pr
,    utpp p
,    utpppr pp
,    utstpp st
where  pp.pr     = pr.pr
and    pp.pp     = st.pp
and    p.pp      = pp.pp
and    p.effective_till is null
and    p.version = pp.version
and    st.st = 'T: PCT High speed'
and    pr.version = (select max(pr2.version) from utpr pr2 where pr2.pr = pr.pr)
and    pp.version = (select max(pp2.version) from utpppr pp2 where pp2.pp = pp.pp)
and    st.version = (select max(st2.version) from utstpp st2 where st2.st = st.st)
order by pp.pp
,        pr.pr
;
/*
ST					VERSION PP              PP-VER  PP-PR                   PP-DESCR        PR-PR                   PR-VER  PR-DESCR                                             
T: PCT High speed	0001.21	Indoor testing	0035.01	Bead comp, min +0.38	Indoor testing	Bead comp, min +0.38	0202.01	Apollo Bead comp, minimum at +0.38
T: PCT High speed	0001.21	Indoor testing	0035.01	Bead comp, min -0.29	Indoor testing	Bead comp, min -0.29	0202.01	Apollo Bead comp, minimum at -0.29
T: PCT High speed	0001.21	Indoor testing	0035.01	Bead push off			Indoor testing	Bead push off			0201.00	FMVSS Bead Unseating
T: PCT High speed	0001.21	Indoor testing	0035.01	Bruise					Indoor testing	Bruise					0402.00	FMVSS Tyre Strength
T: PCT High speed	0001.21	Indoor testing	0035.01	Burst pressure			Indoor testing	Burst pressure			5235.00	Apollo Burst pressure
T: PCT High speed	0001.21	Indoor testing	0035.01	D_deflated SS			Indoor testing	D_deflated SS			0200.01	Diameter deflated SS
T: PCT High speed	0001.21	Indoor testing	0035.01	D_deflated_NS			Indoor testing	D_deflated_NS			0100.01	Diameter deflated NS
T: PCT High speed	0001.21	Indoor testing	0035.01	D_deflated_center		Indoor testing	D_deflated_center		0100.01	Diameter deflated center
T: PCT High speed	0001.21	Indoor testing	0035.01	D_deflated_tested		Indoor testing	D_deflated_tested		0101.01	Diameter deflated after test
T: PCT High speed	0001.21	Indoor testing	0035.01	D_inflated				Indoor testing	D_inflated				0100.02	Diameter inflated
T: PCT High speed	0001.21	Indoor testing	0035.01	D_inflated_719			Indoor testing	D_inflated_719			0100.00	Diameter inflated after 719
T: PCT High speed	0001.21	Indoor testing	0035.01	D_inflated_729			Indoor testing	D_inflated_729			0100.00	Diameter inflated after 729
T: PCT High speed	0001.21	Indoor testing	0035.01	D_inflated_tested		Indoor testing	D_inflated_tested		0100.01	Diameter inflated after test
T: PCT High speed	0001.21	Indoor testing	0035.01	Inflated symmetry		Indoor testing	Inflated symmetry		0001.01	Inflated symmetry
T: PCT High speed	0001.21	Indoor testing	0035.01	TT455AB					Indoor testing	TT455AB					0001.12	Burst pressure SM
T: PCT High speed	0001.21	Indoor testing	0035.01	TT457A					Indoor testing	TT457A					0001.09	Bead compression
T: PCT High speed	0001.21	Indoor testing	0035.01	TT525AA-TT455AB			Indoor testing	TT525AA-TT455AB			0001.15	Burst pressure SM incl. dimensions
T: PCT High speed	0001.21	Indoor testing	0035.01	TT525AA-TT711AB			Indoor testing	TT525AA-TT711AB			0001.15	Bead push off SM incl. dimensions
T: PCT High speed	0001.21	Indoor testing	0035.01	TT525AA-TT719AA			Indoor testing	TT525AA-TT719AA			0001.22	Endurance SM incl. dimensions
T: PCT High speed	0001.21	Indoor testing	0035.01	TT525AA-TT729CA			Indoor testing	TT525AA-TT729CA			0001.28	High speed SM incl. dimensions
T: PCT High speed	0001.21	Indoor testing	0035.01	TT525BA					Indoor testing	TT525BA					0001.06	Dimensions SM with symmetry
T: PCT High speed	0001.21	Indoor testing	0035.01	TT711AB					Indoor testing	TT711AB					0001.13	Bead unseating SM
T: PCT High speed	0001.21	Indoor testing	0035.01	TT729CA					Indoor testing	TT729CA					0001.18	High speed SM
T: PCT High speed	0001.21	Indoor testing	0035.01	TT761BA					Indoor testing	TT761BA					0001.13	Tyre strength SM
T: PCT High speed	0001.21	Indoor testing	0035.01	n_defects (719)			Indoor testing	n_defects (719)			0100.01	No. of severe defects (719)
T: PCT High speed	0001.21	Indoor testing	0035.01	n_defects (729)			Indoor testing	n_defects (729)			0100.01	No. of severe defects (729)
T: PCT High speed	0001.21	Indoor testing	0035.01	w_deflated				Indoor testing	w_deflated				0100.01	Width deflated
T: PCT High speed	0001.21	Indoor testing	0035.01	w_deflated_tested		Indoor testing	w_deflated_tested		0100.01	Width deflated after test
T: PCT High speed	0001.21	Indoor testing	0035.01	w_inflated				Indoor testing	w_inflated				0100.02	Width inflated
T: PCT High speed	0001.21	Indoor testing	0035.01	w_inflated_719			Indoor testing	w_inflated_719			0100.00	Width inflated after 719
T: PCT High speed	0001.21	Indoor testing	0035.01	w_inflated_729			Indoor testing	w_inflated_729			0100.00	Width inflated after 729
T: PCT High speed	0001.21	Indoor testing	0035.01	w_inflated_tested		Indoor testing	w_inflated_tested		0300.01	Width inflated after test
--
T: PCT High speed	0001.21	Indoor testing misc.	0001.12	PT110C	Indoor testing misc.	PT110C	0001.02	Preparation of small section after test
T: PCT High speed	0001.21	Indoor testing misc.	0001.12	TT351ZZ	Indoor testing misc.	TT351ZZ	0001.10	Rolling Resistance variable
T: PCT High speed	0001.21	Indoor testing misc.	0001.12	TT729YY	Indoor testing misc.	TT729YY	0001.06	High speed (Y)
T: PCT High speed	0001.21	Indoor testing misc.	0001.12	TT729ZZ	Indoor testing misc.	TT729ZZ	0001.08	High Speed with variable settings
T: PCT High speed	0001.21	Indoor testing misc.	0001.12	TT731ZZ	Indoor testing misc.	TT731ZZ	0001.03	High speed 2 degree camber variable
T: PCT High speed	0001.21	OEM / Magazin tests	0001.10	PT110C	OEM / Magazin tests	PT110C	0001.02	Preparation of small section after test
T: PCT High speed	0001.21	OEM / Magazin tests	0001.10	TT350XX-TT351AA	OEM / Magazin tests	TT350XX-TT351AA	0001.03	DRC + Rolling Resistance R117
T: PCT High speed	0001.21	OEM / Magazin tests	0001.10	TT351AA	OEM / Magazin tests	TT351AA	0001.21	Rolling Resistance ECE R117
T: PCT High speed	0001.21	OEM / Magazin tests	0001.10	TT731RD	OEM / Magazin tests	TT731RD	0001.03	High speed 2 degree Camber open end
T: PCT High speed	0001.21	OEM / Magazin tests	0001.10	TT731XX	OEM / Magazin tests	TT731XX	0001.11	High speed 2 degree Camber
T: PCT High speed	0001.21	OEM / Magazin tests	0001.10	TT732XX	OEM / Magazin tests	TT732XX	0001.05	Old Camber VW
T: PCT High speed	0001.21	OEM / Magazin tests	0001.10	TT733XX	OEM / Magazin tests	TT733XX	0001.04	High speed Camber 3 deg
T: PCT High speed	0001.21	OEM / Magazin tests	0001.10	TT734AA	OEM / Magazin tests	TT734AA	0001.02	High speed Camber 1.6 deg
T: PCT High speed	0001.21	OEM / Magazin tests	0001.10	TT734AB	OEM / Magazin tests	TT734AB	0001.02	High speed Camber 2.4 deg
T: PCT High speed	0001.21	OEM / Magazin tests	0001.10	TT739N1	OEM / Magazin tests	TT739N1	0001.01	High Speed Camber LT N1 2 deg
T: PCT High speed	0001.21	OEM / Magazin tests	0001.10	TT739N2	OEM / Magazin tests	TT739N2	0001.00	High Speed Camber LT N2 2 deg
T: PCT High speed	0001.21	OEM / Magazin tests	0001.10	TT782ZZ	OEM / Magazin tests	TT782ZZ	0001.02	Ford High Speed 04.04-L-4150
T: PCT High speed	0001.21	Tyre checkin	0001.00	TT510XX	Tyre checkin	TT510XX	0001.04	Tyre checkin
*/

--LET OP:  PARAMETER-NAAMGEVING KOMT IN EEN AANTAL GEVALLEN GEWOON UIT PR-TABEL .
--         ECHTER VOOR PARAMETER-GROUP = INDOOR-TESTING, komt NAAMGEVING helemaal NIET overeen !!!!
--         aLS AV_TEST-METHOD ZIEN WE IN UNILAB codering zoals TT351X, TT457A etc. maar die komt helemaal niet uit UTPPPR of UTPR.
--
--SELECT * FROM UTPP WHERE PP LIKE 'Indoor testing';
--
select * 
from UTSTPP st
, UTPP pp 
where pp.pp = st.pp 
and st = 'T: PCT High speed' 
and pp LIKE 'Indoor testing'
and    pp.version = (select max(pp2.version) from utpppr pp2 where pp2.pp = pp.pp)
and    st.version = (select max(st2.version) from utstpp st2 where st2.st = st.st)
;
--
select distinct PR.PR  
from UTSTPP st
, utpppr pr 
where pr.pp = st.pp 
and st.st = 'T: PCT High speed' 
and pr.pp LIKE 'Indoor testing'
and    pr.version = (select max(pr2.version) from utpppr pr2 where pr2.pp = pr.pp)
and    st.version = (select max(st2.version) from utstpp st2 where st2.st = st.st)
;
/*
Burst pressure
D_deflated_center
D_inflated
D_inflated_719
n_defects (729)
Bead comp, min +0.38
Bead comp, min -0.29
TT457A
TT525AA-TT711AB
n_defects (719)
w_inflated_719
w_inflated_729
w_inflated_tested
Bead push off
D_deflated_NS
TT525AA-TT455AB
TT525AA-TT729CA
TT729CA
w_deflated
w_inflated
D_deflated_tested
Inflated symmetry
TT455AB
TT761BA
D_deflated SS
D_inflated_729
w_deflated_tested
Bruise
TT525BA
D_inflated_tested
TT525AA-TT719AA
TT711AB
*/
--select * from UTSTPP st, UTPP pp, utpppr pr , utpr r where pp.pp = st.pp and pr.pp = pp.pp and pr.pr = r.pr and st = 'T: PCT High speed' and pp.pp LIKE 'Indoor testing';

select * 
from utpr  pr
where pr='TM108AA'
and    pr.version = (select max(pr2.version) from utpr pr2 where pr2.pr = pr.pr)
;

select Pr.*
from utpr pr
,    utpp p
,    utpppr pp
,    utstpp st
where  pp.pr     = pr.pr
and    pp.pp     = st.pp
and    p.pp      = pp.pp
and    p.effective_till is null
and    p.version = pp.version
and    st.st = 'T: PCT High speed'
and    st.pp = 'Indoor testing'
and    pr.version = (select max(pr2.version) from utpr pr2 where pr2.pr = pr.pr)
and    pp.version = (select max(pp2.version) from utpppr pp2 where pp2.pp = pp.pp)
and    st.version = (select max(st2.version) from utstpp st2 where st2.st = st.st)
order by pp.pp
,        pr.pr
;
/*
Indoor testing	0035.01	EF_195/75-18-SM	 	 	 	 	Bead comp, min +0.38
Indoor testing	0035.01	EF_195/75-18-SM	 	 	 	 	Bead comp, min -0.29
Indoor testing	0035.01	EF_195/75-18-SM	 	 	 	 	Bead push off
Indoor testing	0035.01	EF_195/75-18-SM	 	 	 	 	Bruise
Indoor testing	0035.01	EF_195/75-18-SM	 	 	 	 	Burst pressure
Indoor testing	0035.01	EF_195/75-18-SM	 	 	 	 	D_deflated SS
Indoor testing	0035.01	EF_195/75-18-SM	 	 	 	 	D_deflated_NS
Indoor testing	0035.01	EF_195/75-18-SM	 	 	 	 	D_deflated_center
Indoor testing	0035.01	EF_195/75-18-SM	 	 	 	 	D_deflated_tested
Indoor testing	0035.01	EF_195/75-18-SM	 	 	 	 	D_inflated
Indoor testing	0035.01	EF_195/75-18-SM	 	 	 	 	D_inflated_719
Indoor testing	0035.01	EF_195/75-18-SM	 	 	 	 	D_inflated_729
Indoor testing	0035.01	EF_195/75-18-SM	 	 	 	 	D_inflated_tested
Indoor testing	0035.01	EF_195/75-18-SM	 	 	 	 	Inflated symmetry
Indoor testing	0035.01	EF_195/75-18-SM	 	 	 	 	TT455AB
Indoor testing	0035.01	EF_195/75-18-SM	 	 	 	 	TT457A
Indoor testing	0035.01	EF_195/75-18-SM	 	 	 	 	TT525AA-TT455AB
Indoor testing	0035.01	EF_195/75-18-SM	 	 	 	 	TT525AA-TT711AB
Indoor testing	0035.01	EF_195/75-18-SM	 	 	 	 	TT525AA-TT719AA
Indoor testing	0035.01	EF_195/75-18-SM	 	 	 	 	TT525AA-TT729CA
Indoor testing	0035.01	EF_195/75-18-SM	 	 	 	 	TT525BA
Indoor testing	0035.01	EF_195/75-18-SM	 	 	 	 	TT711AB
Indoor testing	0035.01	EF_195/75-18-SM	 	 	 	 	TT729CA
Indoor testing	0035.01	EF_195/75-18-SM	 	 	 	 	TT761BA
Indoor testing	0035.01	EF_195/75-18-SM	 	 	 	 	n_defects (719)
Indoor testing	0035.01	EF_195/75-18-SM	 	 	 	 	n_defects (729)
Indoor testing	0035.01	EF_195/75-18-SM	 	 	 	 	w_deflated
Indoor testing	0035.01	EF_195/75-18-SM	 	 	 	 	w_deflated_tested
Indoor testing	0035.01	EF_195/75-18-SM	 	 	 	 	w_inflated
Indoor testing	0035.01	EF_195/75-18-SM	 	 	 	 	w_inflated_719
Indoor testing	0035.01	EF_195/75-18-SM	 	 	 	 	w_inflated_729
Indoor testing	0035.01	EF_195/75-18-SM	 	 	 	 	w_inflated_tested
*/

select Pr.*
from utpr pr
,    utpp p
,    utpppr pp
,    utstpp st
where  pp.pr     = pr.pr
and    pp.pp     = st.pp
and    p.pp      = pp.pp
and    p.effective_till is null
and    p.version = pp.version
and    st.st = 'T: PCT High speed'
and    st.pp = 'Indoor testing'
--and    pr.pr = 'Burst pressure'
and    pr.version = (select max(pr2.version) from utpr pr2 where pr2.pr = pr.pr)
and    pp.version = (select max(pp2.version) from utpppr pp2 where pp2.pp = pp.pp)
and    st.version = (select max(st2.version) from utstpp st2 where st2.st = st.st)
order by pp.pp
,        pr.pr
;
/*
Bead comp, min +0.38	0202.01	1	21-03-2019 04.29.13.000000000 PM		Apollo Bead comp, minimum at +0.38
Bead comp, min -0.29	0202.01	1	21-03-2019 04.26.24.000000000 PM		Apollo Bead comp, minimum at -0.29
Bead push off	0201.00	1	13-03-2019 12.26.00.000000000 PM		FMVSS Bead Unseating
Bruise	0402.00	1	20-12-2019 02.00.08.000000000 PM		FMVSS Tyre Strength
Burst pressure	5235.00	1	07-01-2020 04.23.08.000000000 PM		Apollo Burst pressure
D_deflated SS	0200.01	1	01-09-2008 02.36.25.000000000 PM		Diameter deflated SS
D_deflated_NS	0100.01	1	01-09-2008 02.36.01.000000000 PM		Diameter deflated NS
D_deflated_center	0100.01	1	01-09-2008 02.36.14.000000000 PM		Diameter deflated center
D_deflated_tested	0101.01	1	01-09-2008 02.35.41.000000000 PM		Diameter deflated after test
D_inflated	0100.02	1	01-09-2008 02.35.20.000000000 PM		Diameter inflated
D_inflated_719	0100.00	1	04-09-2008 06.01.57.000000000 PM		Diameter inflated after 719
D_inflated_729	0100.00	1	04-09-2008 06.01.57.000000000 PM		Diameter inflated after 729
D_inflated_tested	0100.01	1	01-09-2008 02.35.03.000000000 PM		Diameter inflated after test
Inflated symmetry	0001.01	1	20-11-2019 10.49.02.000000000 AM		Inflated symmetry
TT455AB	0001.12	1	26-02-2018 02.32.22.000000000 PM		Burst pressure SM
TT457A	0001.09	1	26-02-2018 02.30.59.000000000 PM		Bead compression
TT525AA-TT455AB	0001.15	1	26-02-2018 02.41.24.000000000 PM		Burst pressure SM incl. dimensions
TT525AA-TT711AB	0001.15	1	26-02-2018 02.41.10.000000000 PM		Bead push off SM incl. dimensions
TT525AA-TT719AA	0001.22	1	26-02-2018 02.40.45.000000000 PM		Endurance SM incl. dimensions
TT525AA-TT729CA	0001.28	1	26-09-2018 08.23.02.000000000 AM		High speed SM incl. dimensions
TT525BA	0001.06	1	26-02-2018 02.38.43.000000000 PM		Dimensions SM with symmetry
TT711AB	0001.13	1	26-02-2018 03.00.24.000000000 PM		Bead unseating SM
TT729CA	0001.18	1	20-04-2020 04.22.37.000000000 PM		High speed SM
TT761BA	0001.13	1	26-02-2018 03.47.26.000000000 PM		Tyre strength SM
n_defects (719)	0100.01	1	01-09-2008 02.37.11.000000000 PM		No. of severe defects (719)
n_defects (729)	0100.01	1	01-09-2008 02.37.03.000000000 PM		No. of severe defects (729)
w_deflated	0100.01	1	01-09-2008 02.38.20.000000000 PM		Width deflated
w_deflated_tested	0100.01	1	01-09-2008 02.38.08.000000000 PM		Width deflated after test
w_inflated	0100.02	1	01-09-2008 02.37.54.000000000 PM		Width inflated
w_inflated_719	0100.00	1	04-09-2008 06.03.02.000000000 PM		Width inflated after 719
w_inflated_729	0100.00	1	04-09-2008 06.03.02.000000000 PM		Width inflated after 729
w_inflated_tested	0300.01	1	01-09-2008 02.37.41.000000000 PM		Width inflated after test
*/

select distinct PR.PR , au.au, au.value 
from UTSTPP st
, utpppr pr 
, utppprau au
where pr.pp = st.pp 
and   au.pp = pr.pp
and   au.pr = pr.pr
and st.st = 'T: PCT High speed' 
and pr.pp LIKE 'Indoor testing'
and    pr.version = (select max(pr2.version) from utpppr pr2 where pr2.pp = pr.pp)
and    st.version = (select max(st2.version) from utstpp st2 where st2.st = st.st)
;
/*
TT455AB			AssignFreqTp	N
TT525AA-TT719AA	avAssignFreqTp	N
TT761BA			avAssignFreqTp	N
TT457A			avAssignFreqTp	N
TT525AA-TT729CA	avAssignFreqTp	N
TT525AA-TT455AB	avAssignFreqTp	N
TT525AA-TT711AB	avAssignFreqTp	N
TT729CA			avAssignFreqTp	N
TT711AB			avAssignFreqTp	N
TT525BA			avAssignFreqTp	N
*/

select distinct PR.PR , au.au, au.value 
from UTSTPP st
, utpppr pr 
, utprau au
where pr.pp = st.pp 
and   au.pr = pr.pr
and st.st = 'T: PCT High speed' 
and pr.pp LIKE 'Indoor testing'
and au in ('avTestMethodDesc','avTestMethod')
and    au.version = (select max(au2.version) from utprau au2 where au2.pr = au.pr)
and    pr.version = (select max(pr2.version) from utpppr pr2 where pr2.pp = pr.pp)
and    st.version = (select max(st2.version) from utstpp st2 where st2.st = st.st)
;
/*
TT729CA			avTestMethod		TT729CA
TT525AA-TT719AA	avTestMethodDesc	Endurance SM incl. dimensions
TT457A			avTestMethod		TT457A
TT525AA-TT455AB	avTestMethod		TT525AA-TT455AB
TT525AA-TT729CA	avTestMethodDesc	High speed SM incl. dimensions
TT455AB			avTestMethod		TT455AB
TT761BA			avTestMethodDesc	Tyre strength SM
TT455AB			avTestMethodDesc	Burst pressure SM
TT525BA			avTestMethodDesc	Dimensions SM with symmetry
TT457A			avTestMethodDesc	Bead compression
TT525AA-TT711AB	avTestMethod		TT525AA-TT711AB
TT525AA-TT711AB	avTestMethodDesc	Bead push off SM incl. dimensions
TT525AA-TT455AB	avTestMethodDesc	Burst pressure SM incl. dimensions
TT729CA			avTestMethodDesc	High speed SM
TT525AA-TT729CA	avTestMethod		TT525AA-TT729CA
TT761BA			avTestMethod		TT761BA
TT711AB			avTestMethod		TT711AB
TT711AB			avTestMethodDesc	Bead unseating SM
TT525AA-TT719AA	avTestMethod		TT525AA-TT719AA
TT525BA			avTestMethod		TT525BA
*/

--SELECT DATA OF MAX(VERSIONS) OF TEMPLATES !!!
select Pr.*, mt.*
from utmt   mt
,    utprmt pmt
,    utpr pr
,    utpp p
,    utpppr pp
,    utstpp st
where  pp.pr     = pr.pr
and    pp.pp     = st.pp
and    p.pp      = pp.pp
and    p.effective_till is null
and    p.version = pp.version
and    pmt.pr    = pr.pr
and    mt.mt     = pmt.mt
and    st.st = 'T: PCT High speed'
--and    st.pp = 'Indoor testing'
--and    pr.pr = 'Burst pressure'
and    mt.version = (select max(mt2.version) from utmt mt2 where mt2.mt = mt.mt)
and    pmt.version = (select max(pmt2.version) from utprmt pmt2 where pmt2.pr = pmt.pr)
and    pr.version = (select max(pr2.version) from utpr pr2 where pr2.pr = pr.pr)
and    pp.version = (select max(pp2.version) from utpppr pp2 where pp2.pp = pp.pp)
and    st.version = (select max(st2.version) from utstpp st2 where st2.st = st.st)
order by pp.pp
,        pr.pr
,        mt.mt
;



--onderzoek UNILAB-SCHERM-RESULTAAT...
select * from utpr where pr like 'TT351X';
select * from utpr where pr like 'Rolling Resistance ECE R117';

select * from utstpp st where st.st like 'T: PCT High speed' 
and st.version = (select max(st2.version) from utstpp st2 where st2.st = st.st)
;
ST                          PP
T: PCT High speed	0001.21	Indoor testing			~Current~	T: PCT High speed
T: PCT High speed	0001.21	Indoor testing misc.	~Current~	T: PCT High speed
T: PCT High speed	0001.21	OEM / Magazin tests		~Current~	T: PCT High speed
T: PCT High speed	0001.21	Tyre checkin			~Current~	 

select pr.* 
from utpr pr 
where pr.version = (select max(pr2.version) from utpr pr2 where pr2.pr = pr.pr)
--and pr.pr like 'TT351X'
;

select * from utpr where pr like 'TT351AA';
PR		VERSION	VIC																			DESCRIPTION
TT351AA	0001.20		03-09-2020 12.00.40.000000000 PM	28-11-2022 10.12.56.000000000 AM	Rolling Resistance ECE R117				0	SC	0	F		Completed	0	0	DD	-1	L		abc	WarningAskToConfirm									0	0	P1		0			1		0	1	@L	0	@A	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	03-09-2020 12.00.40.000000000 PM CET	28-11-2022 10.12.56.000000000 AM CET
TT351AA	0001.21	1	28-11-2022 10.12.56.000000000 AM										Rolling Resistance ECE R117				0	SC	0	F		Completed	0	0	DD	-1	L		abc	WarningAskToConfirm									0	0	P1		0			1		0	1	@L	0	@A	W	W	R	W	W	W	W	W	W	R	R	W	W	W	N	N	28-11-2022 10.12.56.000000000 AM CET	

select * 
from utpppr 
where pr = 'TT351AA'
and version = '0001.23' 
;
PP              VERSION PP_KEY1                             PR
Indoor testing	0001.23	T: PCT High speed	 	 	 	 	TT351AA	~Current~	1	1			0		0	0	N	0		0	0		0		2			0	

select * 
from utstpp  pp
where pp.pp = 'Indoor testing' ;
and   pp.st = 'T: PCT High speed' 
;
--T: PCT High speed	0001.21	Indoor testing	~Current~	T: PCT High speed	 	 	 	 	1	N	0		0		0		2	

select max(ppr2.version) from utpppr ppr2 where ppr2.pp = 'Indoor testing'
--0035.01

select * 
from utpppr  ppr
where ppr.pp = 'Indoor testing' 
and ppr.version = '0001.23' 
--and  ppr.version = (select max(ppr2.version) from utpppr ppr2 where ppr2.pp = ppr.pp)
;

select distinct ppr.version
from utpppr ppr
where ppr.pp = 'Indoor testing' 
order by ppr.version
;
/*
0032.00
0032.01
0033.00
0033.01
0034.00
0034.01
0035.00
0035.01
*/
select distinct pp.version
from utpp pp
where pp.pp = 'Indoor testing' 
order by pp.version
;
/*
0032.00
0032.01
0033.00
0033.01
0034.00
0034.01
0035.00
0035.01
*/

--###############################################
-- UTLONGTEXT VBA-SCRIPTS
--***********************************************
SELECT c.mt, c.version, c.cell, c.dsp_title, l.DOC_ID, c.CALC_FORMULA, l.line_nbr, l.TEXT_LINE
--ZET #-TEKEN AAN HET EIND OM LATER MET REPLACE DE CR/LF TE KUNNEN VERVANGEN DIE IN DE TEKST ZITTEN !!!!
SELECT c.mt||';'|| c.version||';'|| c.cell||';'|| c.dsp_title||';'|| l.DOC_ID||';'|| c.CALC_FORMULA||';'|| l.line_nbr||';'|| l.TEXT_LINE||'#'
FROM UTMTCELL c
,    UTLONGTEXT l
where c.calc_formula like '%#TXT'
and   c.calc_formula = l.doc_id
and   c.version = (select max(c2.version) from utmtcell c2 where c2.mt = c.mt)
order by l.doc_id, l.line_nbr
;

--maak er 1 string van...
select L.doc_id, LISTAGG(l.text_line, ' ') WITHIN GROUP (ORDER BY L.DOC_ID, l.line_nbr) "VBSCRIPT"
from UTLONGTEXT l
where l.DOC_ID like '%#TXT'
--and   l.doc_id='2023-0505-0004#TXT'
GROUP BY l.doc_id
order by l.doc_id
;


SELECT c.mt, c.cell, c.dsp_title, L.doc_id, LISTAGG(l.text_line, ' ') WITHIN GROUP (ORDER BY L.DOC_ID, l.line_nbr) "VBSCRIPT"
FROM UTMTCELL c
,    UTLONGTEXT l
where c.calc_formula like '%#TXT'
and   c.calc_tp = 'B'
and   c.calc_formula = l.doc_id
and   c.version = (select max(c2.version) from utmtcell c2 where c2.mt = c.mt)
GROUP BY c.mt, c.cell, c.dsp_title, L.doc_id
order by c.mt, c.cell, c.dsp_title, L.doc_id
;

set long 10000
SELECT c.mt, c.cell, c.dsp_title, L.doc_id, l.line_nbr, l.text_line  --count(*)  --LISTAGG(l.text_line, ' ') WITHIN GROUP (ORDER BY L.DOC_ID, l.line_nbr) "VBSCRIPT"
FROM UTMTCELL c
,    UTLONGTEXT l
where c.calc_formula like '%#TXT'
and   c.calc_tp = 'B'
and   l.doc_id='2023-0505-0004#TXT'
and   c.calc_formula = l.doc_id
and   c.version = (select max(c2.version) from utmtcell c2 where c2.mt = c.mt)
--GROUP BY c.mt, c.cell, c.dsp_title, L.doc_id, l.line_nbr
order by c.mt, c.cell, c.dsp_title, L.doc_id, l.line_nbr
;



--maak er 1 string van...
SET SERVEROUTPUT ON
declare
l_doc_id varchar2(100);
l_result varchar2(32767);
begin
select L.doc_id, LISTAGG(l.text_line, ' ') WITHIN GROUP (ORDER BY L.DOC_ID, l.line_nbr) OVER (PARTITION BY L.DOC_ID)  as "VBSCRIPT"
into l_doc_id
,    l_result
from UTLONGTEXT l
where l.DOC_ID like '%#TXT'
and   l.doc_id='2023-0505-0004#TXT'
--GROUP BY l.doc_id
order by l.doc_id
;
dbms_output.put_line('result: '||l_doc_id||'-'||l_result);
end;
/


/*
SQL> select listagg(dname, ',') within group (order by dname) result
  2  from dept;

RESULT
--------------------------------------------------------------------------------
ACCOUNTING,OPERATIONS,RESEARCH,SALES


SQL> select rtrim(xmlagg(xmlelement(e, dname ||',') order by dname).extract
  2           ('//text()'), ',') result
  3  from dept;

RESULT
--------------------------------------------------------------------------------
ACCOUNTING,OPERATIONS,RESEARCH,SALES
*/

--maak er 1 string van...
select  l.doc_id, xmlagg(xmlelement("DOC", text_line ||' ') order by doc_id, line_nbr ).extract ('//text()') result
from UTLONGTEXT l
where l.DOC_ID like '%#TXT'
--and   l.doc_id='2023-0505-0004#TXT'
group by l.doc_id
order by l.doc_id
;

/*
C1AR20MRCW=0.92
 C1AR25MRCW=0.92
 C1AR30MRCW=0.9
 C1AR35MRCW=0.9
 C1AR40MRCW=0.9
 C1AR45MRCW=0.85
 C1AR50MRCW=0.8
 C1AR55MRCW=0.8
 C1AR60MRCW=0.75
 C1AR65MRCW=0.75
 C1AR70MRCW=0.75
 C1AR75MRCW=0.7
 C1AR80MRCW=0.7
 C1AR85MRCW=0.7
 C1AR90MRCW=0.7
 
 C1AR20MIN=OK
 C1AR25MIN=OK
 C1AR30MIN=OK
 C1AR35MIN=0.85
 C1AR40MIN=0.85
 C1AR45MIN=0.8
 C1AR50MIN=0.7
 C1AR55MIN=0.7
 C1AR60MIN=0.7
 C1AR65MIN=0.7
 C1AR70MIN=0.65
 C1AR75MIN=0.65
 C1AR80MIN=0.65
 C1AR85MIN=0.65
 C1AR90MIN=0.65
 
 C1AR20MAX=OK
 C1AR25MAX=OK
 C1AR30MAX=OK
 C1AR35MAX=1
 C1AR40MAX=1
 C1AR45MAX=0.95
 C1AR50MAX=0.9
 C1AR55MAX=0.9
 C1AR60MAX=0.9
 C1AR65MAX=0.9
 C1AR70MAX=0.85
 C1AR75MAX=0.85
 C1AR80MAX=0.85
 C1AR85MAX=0.85
 C1AR90MAX=0.85
 
 C2AR40MRCW=0.9
 C2AR45MRCW=0.85
 C2AR50MRCW=0.8
 C2AR55MRCW=0.8
 C2AR60MRCW=0.75
 C2AR65MRCW=0.75
 C2AR70MRCW=0.75
 C2AR75MRCW=0.7
 C2AR80MRCW=0.7
 
 C2AR40MIN=0.85
 C2AR45MIN=0.8
 C2AR50MIN=0.75
 C2AR55MIN=0.75
 C2AR60MIN=0.725
 C2AR65MIN=0.7
 C2AR70MIN=0.675
 C2AR75MIN=0.65
 C2AR80MIN=0.65
 
 C2AR40MAX=0.925
 C2AR45MAX=0.875
 C2AR50MAX=0.825
 C2AR55MAX=0.825
 C2AR60MAX=0.825
 C2AR65MAX=0.8
 C2AR70MAX=0.8
 C2AR75MAX=0.8
 C2AR80MAX=0.8
 
 Select case LIC_s
 Case &quot;Normal&quot;, &quot;XL&quot;
 	Select case AR
 	Case &quot;20&quot;
 		MRCW=(C1AR20MRCW*SW)/25.4
 		RIM_MIN=MRCW-0.5
 		RIM_MAX=MRCW+0.5
 	Case &quot;25&quot;
 		MRCW=(C1AR25MRCW*SW)/25.4
 		RIM_MIN=MRCW-0.5
 		RIM_MAX=MRCW+0.5
 	Case &quot;30&quot;
 		MRCW=(C1AR30MRCW*SW)/25.4
 		RIM_MIN=MRCW-0.5
 		RIM_MAX=MRCW+0.5
 	Case &quot;35&quot;
 		MRCW=(C1AR35MRCW*SW)/25.4
 		RIM_MIN=(C1AR35MIN*SW)/25.4
 		RIM_MAX=(C1AR35MAX*SW)/25.4
 	Case &quot;40&quot;
 		MRCW=(C1AR40MRCW*SW)/25.4
 		RIM_MIN=(C1AR40MIN*SW)/25.4
 		RIM_MAX=(C1AR40MAX*SW)/25.4
 	Case &quot;45&quot;
 		MRCW=(C1AR45MRCW*SW)/25.4
 		RIM_MIN=(C1AR45MIN*SW)/25.4
 		RIM_MAX=(C1AR45MAX*SW)/25.4
 	Case &quot;50&quot;
 		MRCW=(C1AR50MRCW*SW)/25.4
 		RIM_MIN=(C1AR50MIN*SW)/25.4
 		RIM_MAX=(C1AR50MAX*SW)/25.4
 	Case &quot;55&quot;
 		MRCW=(C1AR55MRCW*SW)/25.4
 		RIM_MIN=(C1AR55MIN*SW)/25.4
 		RIM_MAX=(C1AR55MAX*SW)/25.4
 	Case &quot;60&quot;
 		MRCW=(C1AR60MRCW*SW)/25.4
 		RIM_MIN=(C1AR60MIN*SW)/25.4
 		RIM_MAX=(C1AR60MAX*SW)/25.4
 	Case &quot;65&quot;
 		MRCW=(C1AR65MRCW*SW)/25.4
 		RIM_MIN=(C1AR65MIN*SW)/25.4
 		RIM_MAX=(C1AR65MAX*SW)/25.4
 	Case &quot;70&quot;
 		MRCW=(C1AR70MRCW*SW)/25.4
 		RIM_MIN=(C1AR70MIN*SW)/25.4
 		RIM_MAX=(C1AR70MAX*SW)/25.4
 	Case &quot;75&quot;
 		MRCW=(C1AR75MRCW*SW)/25.4
 		RIM_MIN=(C1AR75MIN*SW)/25.4
 		RIM_MAX=(C1AR75MAX*SW)/25.4
 	Case &quot;80&quot;, &quot;82&quot;
 		MRCW=(C1AR80MRCW*SW)/25.4
 		RIM_MIN=(C1AR80MIN*SW)/25.4
 		RIM_MAX=(C1AR80MAX*SW)/25.4
 	Case &quot;85&quot;
 		MRCW=(C1AR85MRCW*SW)/25.4
 		RIM_MIN=(C1AR85MIN*SW)/25.4
 		RIM_MAX=(C1AR85MAX*SW)/25.4
 	Case &quot;90&quot;
 		MRCW=(C1AR90MRCW*SW)/25.4
 		RIM_MIN=(C1AR90MIN*SW)/25.4
 		RIM_MAX=(C1AR90MAX*SW)/25.4
 	Case &quot;95&quot;
 		MRCW=(C1AR95MRCW*SW)/25.4
 		RIM_MIN=(C1AR95MIN*SW)/25.4
 		RIM_MAX=(C1AR95MAX*SW)/25.4
 	End select
 Case Else
                    Select case AR
 	Case &quot;40&quot;
 		MRCW=(C2AR40MRCW*SW)/25.4
 		RIM_MIN=(C2AR40MIN*SW)/25.4
 		RIM_MAX=(C2AR40MAX*SW)/25.4
 	Case &quot;45&quot;
 		MRCW=(C2AR45MRCW*SW)/25.4
 		RIM_MIN=(C2AR45MIN*SW)/25.4
 		RIM_MAX=(C2AR45MAX*SW)/25.4
 	Case &quot;50&quot;
 		MRCW=(C2AR50MRCW*SW)/25.4
 		RIM_MIN=(C2AR50MIN*SW)/25.4
 		RIM_MAX=(C2AR50MAX*SW)/25.4
 	Case &quot;55&quot;
 		MRCW=(C2AR55MRCW*SW)/25.4
 		RIM_MIN=(C2AR55MIN*SW)/25.4
 		RIM_MAX=(C2AR55MAX*SW)/25.4
 	Case &quot;60&quot;
 		MRCW=(C2AR60MRCW*SW)/25.4
 		RIM_MIN=(C2AR60MIN*SW)/25.4
 		RIM_MAX=(C2AR60MAX*SW)/25.4
 	Case &quot;65&quot;
 		MRCW=(C2AR65MRCW*SW)/25.4
 		RIM_MIN=(C2AR65MIN*SW)/25.4
 		RIM_MAX=(C2AR65MAX*SW)/25.4
 	Case &quot;70&quot;
 		MRCW=(C2AR70MRCW*SW)/25.4
 		RIM_MIN=(C2AR70MIN*SW)/25.4
 		RIM_MAX=(C2AR70MAX*SW)/25.4
 	End select
 end select
 round_factor=5
 Measuring_rim=round((MRCW/round_factor),1)*round_factor
 RIM_MIN=round((RIM_MIN/round_factor),1)*round_factor
 RIM_MAX=round((RIM_MAX/round_factor),1)*round_factor
 ResultFile.WriteLine (&quot;ce_Rim_width_min_s=&quot;&amp; RIM_MIN)
 ResultFile.WriteLine (&quot;ce_Rim_width_max_s=&quot;&amp; RIM_MAX)
*/ 

--l_output_clob := p_xmldata.getClobVal();
--maak er 1 string van...
select  l.doc_id, xmlagg(xmlelement("DOC", text_line ||' ') order by doc_id, line_nbr ).extract ('//text()').getClobVal() result
from UTLONGTEXT l
where l.DOC_ID like '%#TXT'
and   c.calc_tp = 'B'
--and   l.doc_id='2023-0505-0004#TXT'   
group by l.doc_id
order by l.doc_id
;

--Haal de CR/LF uit de VB-code...
select doc_id
,     replace(result, chr(13)||chr(10), '@' ) result_text
from (select  l.doc_id, xmlagg(xmlelement("DOC", replace(text_line, chr(13)||chr(10), '@' )|| ' ') order by doc_id, line_nbr ).extract ('//text()').getClobVal() result
      from UTLONGTEXT l
      where l.DOC_ID like '%#TXT'
      and   l.doc_id='2011-0915-0005#TXT'    --'2023-0505-0004#TXT'
      group by l.doc_id
      order by l.doc_id
     )    
;

--nu alleen de "echte" VB-scripts eruit halen...
select doc_id
,     result  vbscript
from (select  l.doc_id, xmlagg(xmlelement("DOC", replace(text_line, chr(13)||chr(10), ' ' )|| ' ') order by doc_id, line_nbr ).extract ('//text()').getClobVal() result
      from UTLONGTEXT l
      where l.DOC_ID like '%#TXT'
      --and   l.doc_id='2011-0915-0005#TXT'    --'2023-0505-0004#TXT'
      and  l.doc_id in (select c.calc_formula from utmtcell c where c.calc_formula is not null and c.calc_tp = 'B' and c.calc_formula = l.doc_id)
      group by l.doc_id
      order by l.doc_id
     )    
;

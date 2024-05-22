select * from association where description like '%Template%';
--no-rows-selected
select * from characteristic where description like '%emplate%';
--no-rows-selected

select * from property where  description like '%Template%' ;
--716570	Template type	1	0

select * from specdata where property=716570;

select * from property where  description like '%rticle%' ;
--712570	Article code	1	0
--705428	Article group PG	1	0
--710531	Article type	1	0                 --> ARTICLE-TYPE = IS DIT DE WAARDE IN ARTICLE.XML ??? DAAR STAAT NL. TYPE=I + E voor !!!!
--713825	Commercial DA article code	1	0
--713860	Commercial DA article code SAP	1	0
--713824	Commercial article code	1	0
--712594	Commercial article code SAP	1	0
--716107	Date of new SAP article code	1	0

select * from specdata s
where s.part_no='EM_774' 
AND property=710531
;
900976	H: Halffabrikaten Volgordelijk
900977	I: Halffabrikaten Alternatief

select distinct part_no, property, value_s 
from specdata s
where property=710531
order by part_no, property, value_s
;
--ASSOCIATION    = 900211
900211	Artikelsoort	C	1	0

--CHARACTERISTIC = 900976
SELECT CH1.* 
FROM CHARACTERISTIC CH1
,    CHARACTERISTIC_ASSOCIATION CAS
WHERE CAS.ASSOCIATION = 900211
AND   CAS.CHARACTERISTIC = CH1.CHARACTERISTIC_ID
;
/*
900974	E: Eindprodukten volgordelijk	    1	0
900975	G: Greentyres Alternatief	        1	0
900976	H: Halffabrikaten Volgordelijk	    1	0
900977	I: Halffabrikaten Alternatief	    1	0
900978	V: Vulkanisatie output Alternatief	1	0
900979	Tubetype	                        1	0
901031	J: Halffabrikaten Altern./Volgordelijk 	1	0
901179	S: Spoiler volgordelijk	                1	0
*/


--INTERSPEC-SQL05-attributes
--ACGENERAL.AQINTSAPARTICLE-QUERY -ATTRIBUTES:
Name = 'SequenceNr'
        Name = 'Plant'
        Name = 'Article'
        Name = 'TemplateArticle'          --this is current TEMPLATE-indicator.
        Name = 'Description'
        Name = 'ArticleGroup'
        Name = 'UoM'
        Name = 'Carrier'
        Name = 'PackageQuantity'
        Name = 'UnitWeight'
        Name = 'WeightTolerance'
        Name = 'ArticleType'
        Name = 'InFinalProd'
        Name = 'MaxShelfLife'
        Name = 'MinAging'
        Name = 'SpecReference'
        Name = 'CuringTime'
        Name = 'OldArticleCode'
        Name = 'SecondGradeArticle'
        Name = 'ManufacturerName'
        Name = 'ManufacturerArtcod'
        Name = 'ManufacturerArtDescr'
        Name = 'ElectroComponent'
        Name = 'StockArtcode'
        Name = 'DocumentID'
        Name = 'PosNo'
        Name = 'CleanedArtcod'
        Name = 'InactivationFlag'
        Name = 'EplanProdgroup'
        Name = 'EplanSubgroup'
        Name = 'EplanKenLetter'
        Name = 'ManufacturerShortname'
        Name = 'BrandName'
        Name = 'MouldCode'
        Name = 'ProfileCode'
        Name = 'ProfileName'
        Name = 'AsymInd'
        Name = 'DirInd'
        Name = 'LoadRange'
        Name = 'RimProt'
        Name = 'RunFlatInd'
        Name = 'WinterInd'
        Name = 'TyreSegmentationPCT'
        Name = 'TyreTypePCT_ACT'
        Name = 'TyreTypeTWT'
        Name = 'SectionWidthCode'
        Name = 'RealSectionWidth'
        Name = 'AspectRatio'
        Name = 'RimCode'
        Name = 'Diameter'
        Name = 'OverallDia'
        Name = 'Dimension_mm'
        Name = 'Dimension_inch'
        Name = 'SpeedIndex'
        Name = 'SpeedIndex2'
        Name = 'MaxSpeed'
        Name = 'MaxSpeed_2'
        Name = 'SizeDesignation'
        Name = 'EtrtoSize'
        Name = 'Colour'
        Name = 'UstTubeless'
        Name = 'TubelessReady'
        Name = 'RadialConstruction'
        Name = 'PlyRating'
        Name = 'LoadCapacity'
        Name = 'Weight'
        Name = 'CommercialWeight'
        Name = 'DotInd'
        Name = 'BeginDOT'
        Name = 'EndDOT'
        Name = 'VersionNumber'
        Name = 'E-ApprovalCodeSound'
        Name = 'E-approvalCode'
        Name = 'OemAppInd'
        Name = 'PliesSidewall'
        Name = 'PliesTread'
        Name = 'QualityGradingWear'
        Name = 'QualityGradingTraction'
        Name = 'QualityGradingTemperature'
        Name = 'TreadDpth'
        Name = 'MinPress'
        Name = 'MaxPress'
        Name = 'TyrePress'
        Name = 'NominalTyrePress'
        Name = 'MaxPressure'
        Name = 'Press_130'
        Name = 'ActTyreDia'
        Name = 'ActTyreWeight'
        Name = 'ActTyreWidth'
        Name = 'LoadIndex'
        Name = 'LoadIndex_2'
        Name = 'MaxLoadKg'
        Name = 'MaxLoadLbs'
        Name = 'MaxLoad2Kg'
        Name = 'MaxLoad2Lbs'
        Name = 'EtrtoTargetRimWidth'
        Name = 'EtrtoLslRimWidth'
        Name = 'EtrtoUslRimWidth'
        Name = 'ApprRimWidthPlus'
        Name = 'ApprRimWidthMinus'
        Name = 'RecommRimWidth'
        Name = 'PermRimWidth'
        Name = 'AltRimWidth'
        Name = 'TargetDia'
        Name = 'TargetSectWidth'
        Name = 'TargetInflPress'
        Name = 'TargetLoadCap'
        Name = 'TargetMaxLoad'
        Name = 'TPI'
        Name = 'SRI'
        Name = 'PR_SD'
        Name = 'Content_75'
        Name = 'StaticLoadRadius'
        Name = 'RollCirc'
        Name = 'TreadPattern'
        Name = 'Valve'
        Name = 'LoadCap_20'
        Name = 'LoadCap_30'
        Name = 'LoadCap_40'
        Name = 'LoadCap_10'
        Name = 'LoadCap_130'
        Name = 'WetGripPCT'
        Name = 'RollResistPct'
        Name = 'NoisePct_dB'
        Name = 'NoisePctClass'
        Name = 'EC_VehicleClass'
        Name = 'RevisionState'
        Name = 'QualityState'
        Name = 'Variant'
        Name = 'CustomerArtNumber'




--article-attributes
<UpdateOrCreateArticle xmlns="http://apollovredestein.com/interspec_sap">
      <SequenceNr>243113</SequenceNr>
      <Plant>5M01</Plant>
      <Article>AP25535020YQPPA02</Article>
      <TemplateArticle>TEMPLATE_EF_PCR</TemplateArticle>
      <Description>255/35 R 20 97Y XL Quatrac Pro+</Description>
      <ArticleGroup>V5</ArticleGroup>
      <UoM>EA</UoM>
      <Carrier>EMPBD</Carrier>
      <PackageQuantity>16</PackageQuantity>
      <UnitWeight>11.636</UnitWeight>
      <ArticleType>E</ArticleType>
      <InFinalProd>true</InFinalProd>
      <MaxShelfLife>-1</MaxShelfLife>
      <MinAging>-1</MinAging>
      <OldArticleCode>E1Y255/35R20QPPX</OldArticleCode>
      <SecondGradeArticle/>
      <MouldCode>4334</MouldCode>
      <ProfileName>Quatrac Pro+</ProfileName>
      <LoadRange>XL</LoadRange>
      <RunFlatInd>false</RunFlatInd>
      <TyreTypePCT_ACT>Tubeless</TyreTypePCT_ACT>
      <MaxSpeed>0</MaxSpeed>
      <RadialConstruction>true</RadialConstruction>
      <DotInd>true</DotInd>
      <E-ApprovalCodeSound>028634 S2WR2</E-ApprovalCodeSound>
      <E-approvalCode>E4 02109343</E-approvalCode>
      <PliesSidewall>1 RAYON</PliesSidewall>
      <PliesTread>1 RAYON + 2 STEEL + 2 POLYAMID</PliesTread>
      <TyrePress>290</TyrePress>
      <MaxPressure>350</MaxPressure>
      <MaxLoadKg>730</MaxLoadKg>
      <MaxLoadLbs>1609</MaxLoadLbs>
      <EtrtoTargetRimWidth>9</EtrtoTargetRimWidth>
      <EtrtoLslRimWidth>8.5</EtrtoLslRimWidth>
      <EtrtoUslRimWidth>10</EtrtoUslRimWidth>
      <ApprRimWidthPlus>false</ApprRimWidthPlus>
      <ApprRimWidthMinus>false</ApprRimWidthMinus>
      <EC_VehicleClass>C1</EC_VehicleClass>
      <QR_Status>QR 5</QR_Status>
    </UpdateOrCreateArticle>
	
--CONCLUSIE: DIT ZIJN ALLE ATTRIBUTEN DIE IK OOK IN EXP2SAP.PAS tegenkom!!!. Zodra PROPERTY GEVULD IS DAN WORDT DEZE MEEGENOMEN IN xml !!!


--XML.article-type
<UpdateOrCreateArticle xmlns="http://apollovredestein.com/interspec_sap">
      <SequenceNr>243017</SequenceNr>
      <Plant>5M01</Plant>
      <Article>E1LV568</Article>
      <TemplateArticle>TEMPLATE_ET</TemplateArticle>
      <Description>LOOPVLAK WINTRAC PRO B262 SB228</Description>
      <ArticleGroup>L8</ArticleGroup>
      <UoM>M</UoM>
      <Carrier>HSPBR</Carrier>
      <PackageQuantity>75</PackageQuantity>
      <UnitWeight>2.101</UnitWeight>
      <WeightTolerance>7</WeightTolerance>
      <ArticleType>I</ArticleType>
      <InFinalProd>true</InFinalProd>
      <MaxShelfLife>21</MaxShelfLife>
      <MinAging>4</MinAging>
      <OldArticleCode>E1LV568</OldArticleCode>
      <SecondGradeArticle/>
      <QR_Status>QR 3</QR_Status>
    </UpdateOrCreateArticle>
	
<UpdateOrCreateArticle xmlns="http://apollovredestein.com/interspec_sap">
      <SequenceNr>243166</SequenceNr>
      <Plant>5M01</Plant>
      <Article>E1777</Article>
      <TemplateArticle>TEMPLATE_EM</TemplateArticle>
      <Description>FM Tread Ultrac Pro (B23-1275)</Description>
      <ArticleGroup>JD</ArticleGroup>
      <UoM>KG</UoM>
      <Carrier>PALL</Carrier>
      <PackageQuantity>230</PackageQuantity>
      <UnitWeight>1</UnitWeight>
      <ArticleType>I</ArticleType>
      <InFinalProd>true</InFinalProd>
      <MaxShelfLife>30</MaxShelfLife>
      <MinAging>8</MinAging>
      <OldArticleCode>E1777</OldArticleCode>
      <SecondGradeArticle/>
      <QR_Status>QR 3</QR_Status>
    </UpdateOrCreateArticle>
	
<UpdateOrCreateArticle xmlns="http://apollovredestein.com/interspec_sap">
      <SequenceNr>243171</SequenceNr>
      <Plant>5M01</Plant>
      <Article>AP18565015TNR2A02</Article>
      <TemplateArticle>TEMPLATE_EF_PCR</TemplateArticle>
      <Description>185/65 R 15 92 T XL NORD-TRAC 2</Description>
      <ArticleGroup>TS</ArticleGroup>
      <UoM>EA</UoM>
      <Carrier>EMPBD</Carrier>
      <PackageQuantity>26</PackageQuantity>
      <UnitWeight>7.954</UnitWeight>
      <ArticleType>E</ArticleType>
      <InFinalProd>true</InFinalProd>
      <MaxShelfLife>-1</MaxShelfLife>
      <MinAging>-1</MinAging>
      <OldArticleCode>E1T185/65R15NO2X</OldArticleCode>
      <SecondGradeArticle>AP18565015TNR2202</SecondGradeArticle>
      <QR_Status>QR 4</QR_Status>
    </UpdateOrCreateArticle>
	

-->we zien nu dat TEMPLATE afwijkt per FRAME ?? 
--BIJV. 
TEMPLATE_EM 		<ArticleType>I</ArticleType>	<ArticleGroup>JD</ArticleGroup>
TEMPLATE_ET			<ArticleType>I</ArticleType>	<ArticleGroup>L8</ArticleGroup>
TEMPLATE_EF_PCR 	<ArticleType>E</ArticleType> 	<ArticleGroup>TS</ArticleGroup> / <ArticleGroup>V5</ArticleGroup>
TEMPLATE_EG_PCR     <ArticleType>G</ArticleType>	<ArticleGroup>NY</ArticleGroup> / <ArticleGroup>N3</ArticleGroup>
TEMPLATE_EV_PCR		<ArticleType>V</ArticleType>	<ArticleGroup>PO</ArticleGroup>
TEMPALTE_GF_PCR		

--er zijn ook PARTs ZONDER template / article-type
/*
      <Article>B100003</Article>
      <TemplateArticle/>
      <Description>Spoiler connector</Description>
      <ArticleGroup>SQ</ArticleGroup>
      <UoM>EA</UoM>
      <Carrier>DOOS</Carrier>
      <PackageQuantity>100</PackageQuantity>
      <UnitWeight>0.145</UnitWeight>
      <ArticleType/>
*/

	  
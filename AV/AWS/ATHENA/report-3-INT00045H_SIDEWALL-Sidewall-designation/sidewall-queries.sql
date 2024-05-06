--INT00045P_CONFIG
/*
-* File: INT00045P_config.fex
-SET &SECTION_GENERAL_INFO		= 700579;
-SET &PG_TYRE_CHARACTERISTICS	= 701563;
-SET &PG_SIZE					= 701569;
-SET &PG_SIDEWALL_DESIGNATION	= 701568;
-SET &PG_CERTIFICATION			= 700696;
-SET &PG_TEST_SETTINGS			= 701976;
 
-SET &P_PRODUCTLINE				= 703422;
 
-SET &SECTION_DSPEC				= 700835;
-SET &PG_MASTER_DRAWING			= 185;
-SET &PG_PARENT_SEGMENT			= 186;
-SET &PG_CHILD_SEGMENT			= 182;
 
-* WISAX
-SET &SECTION_LABELSANDCERTIF   = 701095;
-SET &PG_SLUGSINSERTS			= 703980;
-SET &PART_TYPE_CERTIFICATE     = 701134;
*/

--INT00045P_PRODUCTLINE
/*
WHERE SECTION_ID EQ &SECTION_GENERAL_INFO;
WHERE PROPERTY_GROUP EQ &PG_TYRE_CHARACTERISTICS;
WHERE PROPERTY EQ &P_PRODUCTLINE;
WHERE STATUS_TYPE EQ &STATUS_TYPE;

WHERE SECTION_ID     = 700579
WHERE PROPERTY_GROUP = 701563
WHERE PROPERTY       = 703422
*/

select * from characteristic where characteristic_id = 901388;
901388	Quatrac 5	1	0

SELECT * FROM SECTION WHERE SECTION_ID = 700579;
--700579	General information	1	0
select * from property_group where property_group = 701563;
--701563	General tyre characteristics		1	0	1
select * from property where property = 703422;
--703422	Productline	1	0


--***********************************************************************
--find property = PRODUCTLINE
--***********************************************************************
select DISTINCT sp.characteristic, ch.description
from SPECIFICATION_HEADER sh
JOIN STATUS               s   ON sh.status = s.status AND s.status_type='CURRENT' 
JOIN SPECIFICATION_PROP   sp  ON sp.part_no = sh.part_no and sp.revision = sh.revision
JOIN CHARACTERISTIC       ch  ON ch.characteristic_id = sp.characteristic
WHERE sp.section_id        = 700579
and   sp.property_group    = 701563
and   sp.property          = 703422
--and   characteristic_id = 816   --901388
and  sh.frame_id = 'A_PCR' 
order by ch.description

/*
900918	AMAZER XL
900915	ASPIRE
901398	Alnac
901027	Alnac 4G
901390	Alnac 4G All season
901389	Alnac 4G Winter
901414	Alnac 4GS
903755	Alnac RS
901419	Alnac Winter
769		Altrust
903184	Altrust All Season
903753	Altrust Go
714		Altrust Grip
903185	Altrust Standard
903182	Altrust Summer
903760	Altrust+
901399	Amazer 3G
901400	Amazer 3G Maxx
901418	Amazer 4G
903221	Amazer 4G Eco
901415	Amazer 4G LIFE
903561	Amazer XP
825		Amperion
901382	Apterra  HP
901401	Apterra AT
903232	Apterra AT2
686		Apterra Cross
901402	Apterra HL
901416	Apterra HLS
901403	Apterra HT
901413	Apterra HT2
903739	Apterra Sport
901417	Apterra Winter
900489	Arctrac
900490	Arctrac SUV
900970	Aspire 4G
820		Aspire 4G+
903393	Aspire XP
903525	Aspire XP Winter
900754	Blank tyre
900491	Comtrac
757		Comtrac 2
903233	Comtrac 2 All season
694		Comtrac 2 All season+
903305	Comtrac 2 Summer
903234	Comtrac 2 Winter
695		Comtrac 2 Winter+
912		Comtrac 2+
900492	Comtrac Ice
900493	Comtrac Winter
900935	Comtrac all season
903248	Endu LT
900500	Grip+
561		Hitrac
903702	Hypertrac
901028	Nordtrac 2
658		inza AT
910		Pinza CLT
668		Pinza HT
669		Pinza MT
909		Pinza RT
901410	Quantum
901409	Quantum Plus
647		Quatrac
901388	Quatrac 5
901394	Quatrac 5 SUV
903244	Quatrac 6
903526	Quatrac Pro
841		Quatrac Pro *
830		Quatrac Pro EV
855		Quatrac Pro+
903757	SRI SN832i
901408	Sincera SN835
901318	Snow Classic
900513	Snowtrac 3
901025	Snowtrac 5
903243	Snowtrac 6
901024	Sportrac 5
698		Sportrac 5 AO
605		Sportrac 6
900517	Sprint Classic
903706	Sprint Plus
900518	Sprint+
901293	T-Trac 2
900922	Transport Classic
900521	Ultrac
696		Ultrac *
699		Ultrac * MO
697		Ultrac AO
900716	Ultrac Cento
821		Ultrac Pro
900524	Ultrac SUV Sessanta
903187	Ultrac Satin
901026	Ultrac Vorti
901313	Ultrac Vorti R
716		Ultrac Vorti R+
824		Ultrac Vorti i
715		Ultrac Vorti+
823		Ultrac i
646		Wintrac
903284	Wintrac Ice
903289	Wintrac Pro
840		Wintrac Pro *
901321	Wintrac Xtreme S
903246	Wintrac Xtreme S2
*/


/*
--QUERY FOR REPORT ITSELF...

 WHERE PART_NO EQ 'FOC_NONE';
 WHERE PART_NO IN FILE PRODLIN_PARTS;
 WHERE PART_NO FOC_NONE;
 --
 WHERE STATUS_TYPE = 'CURRENT'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       ;
 WHERE header.INTL = '0';
 WHERE header.ACCESS_GROUP <> 1745;
 WHERE (   SECTION_ID EQ 700579
           AND PROPERTY_GROUP in ( 701563, 701569, 701568, 700696, 701976, 703980 )
       OR (    SECTION_ID EQ 700835
          AND PROPERTY_GROUP in (185, 186, 182 )
       OR (   SECTION_ID EQ 701095
          AND PROPERTY_GROUP EQ 700696
       )
 OR (   SECTION_ID = 700579
    AND PROPERTY_GROUP = 701563
 );
 --
 WHERE column.DESCRIPTION <> 'Property' 
    OR (   column.DESCRIPTION = 'Property' 
	   AND SECTION_ID     = 701095 
	   AND PROPERTY_GROUP = 700696);
 --	   
 WHERE layout.STATUS = 2;
 WHERE columnH.LANG_ID = 1;
*/

--***********************************************
--ONDERZOEK MISSING CHARACTERISTIC = 'Wintrac Pro+' 
--***********************************************
select * from characteristic where description like 'Wintrac Pro+' 
--816	Wintrac Pro+	1	0

select DISTINCT sp.characteristic, ch.description
from SPECIFICATION_HEADER sh
JOIN STATUS               s   ON sh.status = s.status AND s.status_type='CURRENT' 
JOIN SPECIFICATION_PROP   sp  ON sp.part_no = sh.part_no and sp.revision = sh.revision
JOIN CHARACTERISTIC       ch  ON ch.characteristic_id = sp.characteristic
WHERE sp.section_id        = 700579
and   sp.property_group    = 701563
and   sp.property          = 703422
and   characteristic_id    = 816       --901388
--and  sh.part_no = 'FOC_NONE' 
and  sh.frame_id = 'A_PCR' 
order by ch.description


select sh.PART_NO, sh.REVISION, sp.characteristic, ch.description
from SPECIFICATION_PROP   sp  
JOIN CHARACTERISTIC       ch  ON ch.characteristic_id = sp.characteristic
WHERE sp.section_id        = 700579
and   sp.property_group    = 701563
and   sp.property          = 703422
and   characteristic_id    = 816       --901388
--and  sh.frame_id = 'A_PCR' 
order by ch.description
--816	Wintrac Pro+

/*
EF_V275/40R20WPPX	3	816	Wintrac Pro+
EF_V245/45R20WPPX	2	816	Wintrac Pro+
EF_V235/45R20WPPX	2	816	Wintrac Pro+
EF_V215/45R18WPPX	2	816	Wintrac Pro+
EF_V205/40R18WPPX	2	816	Wintrac Pro+
EF_H215/50R19WPP	2	816	Wintrac Pro+
EF_H215/45R20WPPX	2	816	Wintrac Pro+
*/

select sh.PART_NO, sh.REVISION, sh.frame_id, s.status_type, sp.characteristic, ch.description
from SPECIFICATION_HEADER sh
JOIN STATUS               s   ON sh.status = s.status --AND s.status_type='CURRENT' 
JOIN SPECIFICATION_PROP   sp  ON sp.part_no = sh.part_no and sp.revision = sh.revision
JOIN CHARACTERISTIC       ch  ON ch.characteristic_id = sp.characteristic
WHERE sp.section_id        = 700579
and   sp.property_group    = 701563
and   sp.property          = 703422
and   characteristic_id    = 816       --901388
--and  sh.frame_id = 'A_PCR' 
order by ch.description

/*
EF_V275/40R20WPPX	3	HISTORIC	816	Wintrac Pro+
EF_V245/45R20WPPX	2	HISTORIC	816	Wintrac Pro+
EF_V235/45R20WPPX	2	HISTORIC	816	Wintrac Pro+
EF_V215/45R18WPPX	2	HISTORIC	816	Wintrac Pro+
EF_V205/40R18WPPX	2	HISTORIC	816	Wintrac Pro+
EF_H215/50R19WPP	2	HISTORIC	816	Wintrac Pro+
EF_H215/45R20WPPX	2	HISTORIC	816	Wintrac Pro+
--
EF_V265/45R20WPPX	3	A_PCR	DEVELOPMENT	816	Wintrac Pro+
EF_H195/55R20WPPX	2	A_PCR	DEVELOPMENT	816	Wintrac Pro+
EF_H205/55R19WPPX	3	A_PCR	DEVELOPMENT	816	Wintrac Pro+
EF_V235/45R20WPPX	3	A_PCR	DEVELOPMENT	816	Wintrac Pro+
--
*/

--CONCLUSIE: PART-NO/REVISION is NOT CURRENT !!!!!!!

select * from specification_header where part_no='EF_V275/40R20WPPX';
/*
EF_V275/40R20WPPX	1	5	275/40R20 106V Wintrac Pro + XL	08-10-2021 00:00:00	08-10-2021 10:11:39	14-10-2021 12:53:35	14-10-2021 12:53:35	0	INTERSPC	07-10-2021 08:12:43	RHI	08-10-2021 10:09:49	A_PCR	68	1694	263	700309	1					1	0	1	0		Y	
EF_V275/40R20WPPX	2	5	275/40R20 106V Wintrac Pro + XL	14-10-2021 00:00:00	14-10-2021 12:53:35	15-10-2021 16:31:20	15-10-2021 16:31:20	0	RHI	13-10-2021 16:17:00	INTERSPC	14-10-2021 12:02:51	A_PCR	68	1694	263	700309	1					1	0	1	0		Y	
EF_V275/40R20WPPX	3	5	275/40R20 106V Wintrac Pro + XL	15-10-2021 00:00:00	15-10-2021 16:31:20	02-02-2022 15:33:41	02-02-2022 15:33:41	0	RHI	14-10-2021 13:01:39	FMO	15-10-2021 16:02:53	A_PCR	68	1694	263	700309	1					1	0	1	0		Y	
*/

select * from specification_header where part_no='EF_V265/45R20WPPX';
/*
EF_V265/45R20WPPX	1	5	265/45R20 108V Wintrac Pro + XL	08-10-2021 00:00:00	08-10-2021 10:11:39	14-10-2021 12:53:35	14-10-2021 12:53:35	0	INTERSPC	07-10-2021 08:12:50	RHI	08-10-2021 10:09:49	A_PCR	68	1694	263	700309	1					1	0	1	0		Y	
EF_V265/45R20WPPX	2	5	265/45R20 108V Wintrac Pro + XL	14-10-2021 00:00:00	14-10-2021 12:53:35	02-02-2022 15:46:53	02-02-2022 15:46:53	0	RHI	13-10-2021 16:17:01	INTERSPC	14-10-2021 12:02:51	A_PCR	68	1694	263	700309	1					1	0	1	0		Y	
EF_V265/45R20WPPX	3	1	265/45R20 108V Wintrac Pro + XL	19-09-2023 00:00:00			14-10-2021 13:01:38	0	RHI	14-10-2021 13:01:38	RHI	14-10-2021 13:01:38	A_PCR	68	1694	263	700309	1					1	0	1	0		Y	
*/


--Onderzoek-relaties tussen METHODE-CELLEN en RAW-DATA-FILE-DIRECTORIES

select count(*) from utscmecell ;
--41.521.741
select cell, count(*) from utscmecell c where c.cell like '%ilename_xy_data%' group by cell;
--filename_xy_data		2
--Filename_xy_data2		722
--Filename_xy_data		214.694

--conclusion: use only Filename with Uppercase !!!

select c.me
,      c.cell
,      count(*)
from UTSCMECELL c
where c.CELL like 'Filename_xy_data%'
AND   c.VALUE_S is not null
and   c.VALUE_S LIKE '%#LNK'
group by c.me
,        c.cell
order by c.me
,        c.cell
;
/*
SP027B	Filename_xy_data	2
SP027C	Filename_xy_data	27
SP027D	Filename_xy_data	27
SP027E	Filename_xy_data	30
SP027F	Filename_xy_data	3
SP028A	Filename_xy_data	26
ST001A	Filename_xy_data	4
ST002A	Filename_xy_data	4
ST340C	Filename_xy_data	8
ST501A	Filename_xy_data	6
TP013A	Filename_xy_data	32957
TP013C	Filename_xy_data	112
TP013D	Filename_xy_data	111
TP013E	Filename_xy_data	9309
TP013F	Filename_xy_data	304
TP013G	Filename_xy_data	677
TP013H	Filename_xy_data	3356
TP013I	Filename_xy_data	162
TP013J	Filename_xy_data	12
TP013K	Filename_xy_data	4
TP013L	Filename_xy_data	1
TP013N	Filename_xy_data	71
TP013O	Filename_xy_data	33
TP013P	Filename_xy_data	34104
TP013Z	Filename_xy_data	869
TP015B	Filename_xy_data	142
TP018A	Filename_xy_data	2331
TP018B	Filename_xy_data	595
TP018C	Filename_xy_data	6
TP018D	Filename_xy_data	2
TP018E	Filename_xy_data	2
TP027A	Filename_xy_data	23
TP027Z	Filename_xy_data	17
TP028A	Filename_xy_data	22
TP028Z	Filename_xy_data	1
TP029A	Filename_xy_data	44
TP029Z	Filename_xy_data	5
TP036A	Filename_xy_data	946
TP036B	Filename_xy_data	1558
TP037A	Filename_xy_data	1332
TP037B	Filename_xy_data	261
TP044A	Filename_xy_data	581
TP044B	Filename_xy_data	761
TP044C	Filename_xy_data	2812
TP044D	Filename_xy_data	4729
TP044G	Filename_xy_data	704
TP044H	Filename_xy_data	161
TP044J	Filename_xy_data	641
TP046A	Filename_xy_data	12360
TP046B	Filename_xy_data	14590
TP046C	Filename_xy_data	8
TP046F	Filename_xy_data	1521
TP046G	Filename_xy_data	2271
TP047A	Filename_xy_data	1216
TP047A	Filename_xy_data2	593
TP047B	Filename_xy_data	122
TP047D	Filename_xy_data	108
TP047D	Filename_xy_data2	108
TP120Z	Filename_xy_data	1
--
*/


select c.me
,      c.cell
,      count(*)
from UTSCMECELL c
where c.CELL like 'Filename_xy_data%'
AND   c.VALUE_S is not null
and   c.VALUE_S LIKE '%#LNK'
and  not exists (select ''
                 from UTLONGTEXT l
				 where l.doc_id = c.value_s
				)
group by c.me
,        c.cell
order by c.me
,        c.cell
;
/*
TP013A	Filename_xy_data	26
TP013C	Filename_xy_data	2
TP013E	Filename_xy_data	10
TP013H	Filename_xy_data	6
TP013P	Filename_xy_data	25
TP015B	Filename_xy_data	1
TP018A	Filename_xy_data	1
TP044C	Filename_xy_data	3
TP044D	Filename_xy_data	6
TP044G	Filename_xy_data	1
TP046A	Filename_xy_data	5
TP046B	Filename_xy_data	4
TP047A	Filename_xy_data	2
TP047A	Filename_xy_data2	2
TP047D	Filename_xy_data	2
TP047D	Filename_xy_data2	6
--
--conclusion: not many mismatches...
*/


--UTLONGTEXT.DOC_ID
--UTLONGTEXT.TEXT_LINE

select c.me
,      c.cell
,      l.text_line 
from UTSCMECELL c
JOIN UTLONGTEXT l on ( l.doc_id = c.value_s )
where c.CELL like 'Filename_xy_data%'
AND   c.VALUE_S is not null
and   c.VALUE_S LIKE '%#LNK'
and   c.me = 'TP046A'
;




select c.me
,      c.cell
,      substring(l.text_line, 1, 40)  as directory
,      reverse( SUBSTRING ( reverse(l.text_line), position('\\' in reverse(l.text_line) )+1)  )
,      count(*)
from UTSCMECELL c
JOIN UTLONGTEXT l on ( l.doc_id = c.value_s )
where c.CELL like 'Filename_xy_data%'
AND   c.VALUE_S is not null
and   c.VALUE_S LIKE '%#LNK'
group by c.me
,        c.cell
,      substring(l.text_line, 1, 30) 
order by c.me
,        c.cell
,      substring(l.text_line, 1, 30) 
;

--nu met dynamische-structuur om alleen gedeelte voor LAATSTE "\" te selecteren...
select   'file:\\TCE00\Data\\tce\\Lims\\RawDATA.txt' string
, '\\' || reverse(split_part(reverse(string), '\\', 1)) last_part
, reverse(string)  reverse_string
, SUBSTRING ( reverse_string, position('\\' in reverse_string )+1)   as reverse_last_part
, reverse(reverse_last_part)
, reverse( SUBSTRING ( reverse(string), position('\\' in reverse(string) )+1)  )



select c.me
,      c.cell
,      replace(reverse( SUBSTRING ( reverse(l.text_line), position('\\' in reverse(l.text_line) )+1)  ) ,'"', '')  as directory
,      count(*)
from UTSCMECELL c
JOIN UTLONGTEXT l on ( l.doc_id = c.value_s )
where c.CELL like 'Filename_xy_data%'
AND   c.VALUE_S is not null
and   c.VALUE_S LIKE '%#LNK'
group by c.me
,        c.cell
,      reverse( SUBSTRING ( reverse(l.text_line), position('\\' in reverse(l.text_line) )+1)  )
order by c.me
,        c.cell
,      reverse( SUBSTRING ( reverse(l.text_line), position('\\' in reverse(l.text_line) )+1)  )
;
/*
SP027B	Filename_xy_data	file:C:\Documents and Settings\benthem_van_h\My Documents	1
SP027B	Filename_xy_data	file:I:\tce\Projecten\Werkmappen\RDMA 2034 LIMS\Rapportages\XY data files	1
SP027C	Filename_xy_data	file:\\Tce00\data\tce\Lims\WLF	27
SP027D	Filename_xy_data	file:\\Tce00\data\tce\Lims\WLF	27
SP027E	Filename_xy_data	file:\\Tce00\data\tce\Lims\WLF	30
SP027F	Filename_xy_data	file:\\Tce00\data\tce\Lims\WLF	3
SP028A	Filename_xy_data	file:\\Tce00\data\tce\Lims\WLF	1
SP028A	Filename_xy_data	file:\\ensbackup\TCE-RESEARCH\MaterialLibrary\Scripts\STS1435081T_BKM\Apex_A268	1
SP028A	Filename_xy_data	file:\\ensbackup\TCE-RESEARCH\MaterialLibrary\Scripts\STS1435081T_BKM\Belt_Skim_B168	1
SP028A	Filename_xy_data	file:\\ensbackup\TCE-RESEARCH\MaterialLibrary\Scripts\STS1435081T_BKM\Cap_Ply_Skim_B160	1
SP028A	Filename_xy_data	file:\\ensbackup\TCE-RESEARCH\MaterialLibrary\Scripts\STS1435081T_BKM\Chaffer_Skim_XS36	1
SP028A	Filename_xy_data	file:\\ensbackup\TCE-RESEARCH\MaterialLibrary\Scripts\STS1435081T_BKM\Ply_Skim_B458	1
SP028A	Filename_xy_data	file:\\ensbackup\TCE-RESEARCH\MaterialLibrary\Scripts\STS1435081T_BKM\RimStrip_R37	1
SP028A	Filename_xy_data	file:\\ensbackup\TCE-RESEARCH\MaterialLibrary\Scripts\STS1435081T_BKM\Sidewall_XT3078	1
SP028A	Filename_xy_data	file:\\ensbackup\TCE-RESEARCH\MaterialLibrary\Scripts\STS1435081T_BKM\Tread_Base_XT3076	1
SP028A	Filename_xy_data	file:\\ensbackup\TCE-RESEARCH\MaterialLibrary\Scripts\STS1435081T_BKM\Tread_Cap_ST244	1
SP028A	Filename_xy_data	file:\\ensbackup\TCE-RESEARCH\MaterialLibrary\Scripts\STS1435081T_BKM\Tread_Cap_T6730	1
SP028A	Filename_xy_data	file:I:\tce\Lims\RawData	2
SP028A	Filename_xy_data	file:\\Tce00\data\tce\Lims\Hyperelastic	3
SP028A	Filename_xy_data	file:\\Tce00\data\tce\Lims\WLF	9
SP028A	Filename_xy_data	file:\\ensbackup\TCE-RESEARCH\MaterialLibrary\Scripts\STS1435081T_BKM	1
ST001A	Filename_xy_data	file:I:\tce\Lims\FEM-simulations\Request DOE sidewall HVB0926002T01\24540R18_result_files	1
ST001A	Filename_xy_data	file:I:\tce\Lims\FEM-simulations\Request DOE sidewall HVB0926002T01\24545R17_result_files	1
ST001A	Filename_xy_data	file:I:\tce\Lims\FEM-simulations\Request DOE sidewall HVB0926002T01\27530R19_result_files	1
ST001A	Filename_xy_data	file:I:\tce\Lims\FEM-simulations\Request DOE sidewall HVB0926002T01\29525R20_result_files	1
ST002A	Filename_xy_data	file:I:\tce\Lims\FEM-simulations\Request DOE sidewall HVB0926002T01\24540R18_result_files	1
ST002A	Filename_xy_data	file:I:\tce\Lims\FEM-simulations\Request DOE sidewall HVB0926002T01\24545R17_result_files	1
ST002A	Filename_xy_data	file:I:\tce\Lims\FEM-simulations\Request DOE sidewall HVB0926002T01\27530R19_result_files	1
ST002A	Filename_xy_data	file:I:\tce\Lims\FEM-simulations\Request DOE sidewall HVB0926002T01\29525R20_result_files	1
ST340C	Filename_xy_data	file:I:\tce\Lims\FEM-simulations	7
ST340C	Filename_xy_data	file:\\tce00\data\tce\Lims\FEM-simulations	1
ST501A	Filename_xy_data	\\Ensbackup\tce-research\LIMS\EVE1007030T	2
ST501A	Filename_xy_data	file:\\Ensbackup\tce-research\LIMS\EVE1007030T	1
ST501A	Filename_xy_data	file:\\evo_d330\eelco\LIMS\Meshes	3
TP013A	Filename_xy_data	file:C:\Documents and Settings\Luggenhorst_te_J\Bureaublad	8
TP013A	Filename_xy_data	file:H:\LIMS tials material lab\Test files	2
TP013A	Filename_xy_data	file:I:\tce\Projecten\Werkmappen\RDMA 2034 LIMS\Rapportages\XY data files	3
TP013A	Filename_xy_data	file:C:\Users\jeroen.teluggenhorst\Desktop	1
TP013A	Filename_xy_data	file:I:\tce\Lims\RawData	4
TP013A	Filename_xy_data	file:\\TCE00\data\tce\lims\rawData	7825
TP013A	Filename_xy_data	file:\\Tce00\data\tce\Lims\RawData	1
TP013A	Filename_xy_data	file:\\tce00\data\tce\lims\rawData	25043
TP013A	Filename_xy_data	file:\\tce00\data\tce\lims\rawdata	44
TP013C	Filename_xy_data	file:H:	3
TP013C	Filename_xy_data	file:I:\Material\LAB\TP013C	3
TP013C	Filename_xy_data	file:\\TCE00\data\tce\lims\rawData	104
TP013D	Filename_xy_data	file:C:\Users\tom.hammer\OneDrive - Apollo Tyres Limited\Bureaublad	7
TP013D	Filename_xy_data	file:\\TCE00\data\tce\lims\rawData	104
TP013E	Filename_xy_data	file:\\TCE00\data\tce\lims\rawData	4632
TP013E	Filename_xy_data	file:\\tce00\data\tce\lims\rawData	4664
TP013E	Filename_xy_data	file:\\tce00\data\tce\lims\rawdata	3
TP013F	Filename_xy_data	file:\\TCE00\data\tce\lims\rawData	202
TP013F	Filename_xy_data	file:\\tce00\data\tce\lims\rawData	102
TP013G	Filename_xy_data	file:\\TCE00\data\tce\lims\rawData	514
TP013G	Filename_xy_data	file:\\tce00\data\tce\lims\rawData	163
TP013H	Filename_xy_data	file:I:\tce\Lims\RawData	4
TP013H	Filename_xy_data	file:\\TCE00\data\tce\lims\rawData	3028
TP013H	Filename_xy_data	file:\\tce00\data\tce\lims\rawData	318
TP013I	Filename_xy_data	file:\\tce00\data\tce\lims\rawData	162
TP013J	Filename_xy_data	file:\\tce00\data\tce\lims\rawData	12
TP013K	Filename_xy_data	file:C:\Users\jeroen.teluggenhorst\Desktop	4
TP013L	Filename_xy_data	file:\\TCE00\data\tce\lims\rawData	1
TP013N	Filename_xy_data	file:C:\Users\jeroen.teluggenhorst\Desktop	2
TP013N	Filename_xy_data	file:\\TCE00\data\tce\lims\rawData	66
TP013N	Filename_xy_data	file:\\tce00\data\tce\lims\RawData	1
TP013N	Filename_xy_data	file:\\tce00\data\tce\lims\rawData	2
TP013O	Filename_xy_data	file:\\TCE00\data\tce\lims\rawData	20
TP013O	Filename_xy_data	file:\\tce00\data\tce\lims\rawData	13
TP013P	Filename_xy_data	file:C:\Users\jeroen.teluggenhorst\Desktop	3
TP013P	Filename_xy_data	file:C:\Users\jeroen.teluggenhorst\Documents	2
TP013P	Filename_xy_data	file:H:	1
TP013P	Filename_xy_data	file:\\TCE00\data\tce\lims\rawData	20608
TP013P	Filename_xy_data	file:\\tce00\data\tce\lims\rawData	13468
TP013Z	Filename_xy_data	file:H:	1
TP013Z	Filename_xy_data	file:\\TCE00\data\tce\lims\rawData	863
TP013Z	Filename_xy_data	file:\\tce00\data\tce\lims\rawData	6
TP015B	Filename_xy_data	file:\\TCE00\data\tce\lims\rawData	141
TP018A	Filename_xy_data	file:C:\Documents and Settings\Luggenhorst_te_J\Bureaublad	1
TP018A	Filename_xy_data	file:H:\LIMS tials material lab\Test files	3
TP018A	Filename_xy_data	file:I:\tce\Projecten\Werkmappen\RDMA 2034 LIMS\Rapportages\XY data files	2
TP018A	Filename_xy_data	file:\\tce00\data\tce\Lims\RawData	2277
TP018A	Filename_xy_data	file:\\tce00\data\tce\lims\RawData	20
TP018A	Filename_xy_data	file:\\tce00\data\tce\lims\rawData	27
TP018B	Filename_xy_data	file:C:\Documents and Settings\Luggenhorst_te_J\Bureaublad	1
TP018B	Filename_xy_data	file:\\tce00\data\tce\Lims\RawData	594
TP018C	Filename_xy_data	file:H:\LIMS\TP018CDE	1
TP018C	Filename_xy_data	file:I:\tce\Lims\RawData\temp	5
TP018D	Filename_xy_data	file:I:\tce\Lims\RawData\temp	2
TP018E	Filename_xy_data	file:I:\tce\Lims\RawData\temp	2
TP027A	Filename_xy_data	file:C:\Documents and Settings\benthem_van_h\My Documents	1
TP027A	Filename_xy_data	file:I:\tce\Projecten\Werkmappen\RDMA 2034 LIMS\Rapportages\XY data files	1
TP027A	Filename_xy_data	file:I:\Material\Eplexor\SHEAR	10
TP027A	Filename_xy_data	file:I:\Material\Eplexor\SHEAR\Eelco	11
TP027Z	Filename_xy_data	file:I:\Material\Eplexor\SHEAR\STS0921008M	14
TP027Z	Filename_xy_data	file:I:\Material\Eplexor\SHEAR\TTO0920048T	3
TP028A	Filename_xy_data	file:I:\Material\LAB\Testresultaten\Zwick Z010\Materiaalparameters voor FEM_TP028AA\Relaxatie-curve	20
TP028A	Filename_xy_data	file:I:\tce\Lims\RawData	2
TP028Z	Filename_xy_data	file:I:\Material\LAB\Testresultaten\Zwick Z010\Materiaalparameters voor FEM_TP028AA\Trek-Rek-curve\FEM-simulatie	1
TP029A	Filename_xy_data	file:I:\Material\LAB\Testresultaten\Zwick Z010\Materiaalparameters voor FEM_TP028AA\Trek-Rek-curve\FEM-simulatie	41
TP029A	Filename_xy_data	file:I:\tce\Lims\RawData	3
TP029Z	Filename_xy_data	file:I:\Material\LAB\Testresultaten\Zwick Z010\Materiaalparameters voor FEM_TP028AA\Relaxatie-curve	2
TP029Z	Filename_xy_data	file:I:\Material\LAB\Testresultaten\Zwick Z010\Materiaalparameters voor FEM_TP028AA\Trek-Rek-curve\FEM-simulatie	3
TP036A	Filename_xy_data	file:C:\Documents and Settings\Luggenhorst_te_J\Bureaublad	26
TP036A	Filename_xy_data	file:\\TCE00\data\tce\lims\rawData	90
TP036A	Filename_xy_data	file:\\tce00\data\tce\lims\rawData	830
TP036B	Filename_xy_data	file:C:\Documents and Settings\Luggenhorst_te_J\Bureaublad	3
TP036B	Filename_xy_data	file:\\TCE00\data\tce\lims\rawData	225
TP036B	Filename_xy_data	file:\\tce00\data\tce\lims\rawData	1330
TP037A	Filename_xy_data	file:.	1
TP037A	Filename_xy_data	file:\\Tce00\data\tce\Lims\RawData	1
TP037A	Filename_xy_data	file:\\tce00\data\tce\Lims\RawData	1299
TP037A	Filename_xy_data	file:\\tce00\data\tce\lims\RawData	32
TP037B	Filename_xy_data	file:\\tce00\data\tce\Lims\RawData	261
TP044A	Filename_xy_data	file:C:\Documents and Settings\Luggenhorst_te_J\Bureaublad	5
TP044A	Filename_xy_data	file:H:	1
TP044A	Filename_xy_data	file:\\TCE00\Data\tce\Lims\RawData	575
TP044B	Filename_xy_data	file:C:\Documents and Settings\Luggenhorst_te_J\Bureaublad	2
TP044B	Filename_xy_data	file:H:	2
TP044B	Filename_xy_data	file:\\TCE00\Data\tce\Lims\RawData	757
TP044C	Filename_xy_data	file:\\TCE00\Data\tce\Lims\RawData	2809
TP044D	Filename_xy_data	file:.\Out	1
TP044D	Filename_xy_data	file:\\TCE00\Data\tce\Lims\RawData	4722
TP044G	Filename_xy_data	file:\\TCE00\Data\tce\Lims\RawData	702
TP044G	Filename_xy_data	file:\\tce00\data\tce\lims\rawdata	1
TP044H	Filename_xy_data	file:\\TCE00\Data\tce\Lims\RawData	160
TP044H	Filename_xy_data	file:\\tce00\data\tce\lims\rawdata	1
TP044J	Filename_xy_data	file:\\TCE00\Data\tce\Lims\RawData	641
TP046A	Filename_xy_data	file:\\TCE00\Data\tce\Lims\RawData	19
TP046A	Filename_xy_data	file:\\tce00\data\tce\lims\RawData	7238
TP046A	Filename_xy_data	file:\\tce00\data\tce\lims\RawData2019	5098
TP046B	Filename_xy_data	file:\\TCE00\Data\tce\Lims\RawData	17
TP046B	Filename_xy_data	file:\\tce00\data\tce\lims\RawData	8492
TP046B	Filename_xy_data	file:\\tce00\data\tce\lims\RawData2019	6077
TP046C	Filename_xy_data	file:\\tce00\data\tce\lims\RawData	3
TP046C	Filename_xy_data	file:\\tce00\data\tce\lims\RawData2019	5
TP046F	Filename_xy_data	file://tce00.vredestein.com/data/tce/Lims/RawData	2
TP046F	Filename_xy_data	file:I:/tce/Lims/RawData	2
TP046F	Filename_xy_data	file:\\tce00.vredestein.com\data\tce\Lims\RawData	1517
TP046G	Filename_xy_data	file://tce00.vredestein.com/data/tce/Lims/RawData	2
TP046G	Filename_xy_data	file:I:/tce/Lims/RawData	2
TP046G	Filename_xy_data	file:\\tce00.vredestein.com\data\tce\Lims\RawData	2267
TP047A	Filename_xy_data	file:H:	3
TP047A	Filename_xy_data	file:\\tce00\data\tce\lims\RawData	620
TP047A	Filename_xy_data	file:\\tce00\data\tce\lims\RawData2019	591
TP047A	Filename_xy_data2	file:\\tce00\data\tce\lims\TanData2019	591
TP047B	Filename_xy_data	file:H:	2
TP047B	Filename_xy_data	file:H:	1
TP047B	Filename_xy_data	file:\\tce00\data\tce\lims\RawData	119
TP047D	Filename_xy_data	file://tce00.vredestein.com/data/tce/Lims/RawData	3
TP047D	Filename_xy_data	file:\\tce00.vredestein.com\data\tce\Lims\RawData	103
TP047D	Filename_xy_data2	file://tce00.vredestein.com/data/tce/Lims/TanData2019	3
TP047D	Filename_xy_data2	file:\\tce00.vredestein.com\data\tce\Lims\TanData2019	99
TP120Z	Filename_xy_data	file:C:\Program Files\Siemens\SIMATIC IT Unilab 6.1 sp1	1
*/

select replace(reverse( SUBSTRING ( reverse(l.text_line), position('\\' in reverse(l.text_line) )+1)  ) ,'"', '')  as directory
,      count(*)
from UTSCMECELL c
JOIN UTLONGTEXT l on ( l.doc_id = c.value_s )
where c.CELL like 'Filename_xy_data%'
AND   c.VALUE_S is not null
and   c.VALUE_S LIKE '%#LNK'
group by replace(reverse( SUBSTRING ( reverse(l.text_line), position('\\' in reverse(l.text_line) )+1)  ) ,'"', '') 
order by replace(reverse( SUBSTRING ( reverse(l.text_line), position('\\' in reverse(l.text_line) )+1)  ) ,'"', '') 
;

/*
\\Ensbackup\tce-research\LIMS\EVE1007030T	2
file:.	1
file:.\Out	1
file://tce00.vredestein.com/data/tce/Lims/RawData	7
file://tce00.vredestein.com/data/tce/Lims/TanData2019	3
file:C:\Documents and Settings\Luggenhorst_te_J\Bureaublad	46
file:C:\Documents and Settings\benthem_van_h\My Documents	2
file:C:\Program Files\Siemens\SIMATIC IT Unilab 6.1 sp1	1
file:C:\Users\jeroen.teluggenhorst\Desktop	10
file:C:\Users\jeroen.teluggenhorst\Documents	2
file:C:\Users\tom.hammer\OneDrive - Apollo Tyres Limited\Bureaublad	7
file:H:	14
file:H:\LIMS tials material lab\Test files	5
file:H:\LIMS\TP018CDE	1
file:I:/tce/Lims/RawData	4
file:I:\Material\Eplexor\SHEAR	10
file:I:\Material\Eplexor\SHEAR\Eelco	11
file:I:\Material\Eplexor\SHEAR\STS0921008M	14
file:I:\Material\Eplexor\SHEAR\TTO0920048T	3
file:I:\Material\LAB\TP013C	3
file:I:\Material\LAB\Testresultaten\Zwick Z010\Materiaalparameters voor FEM_TP028AA\Relaxatie-curve	22
file:I:\Material\LAB\Testresultaten\Zwick Z010\Materiaalparameters voor FEM_TP028AA\Trek-Rek-curve\FEM-simulatie	45
file:I:\tce\Lims\FEM-simulations	7
file:I:\tce\Lims\FEM-simulations\Request DOE sidewall HVB0926002T01\24540R18_result_files	2
file:I:\tce\Lims\FEM-simulations\Request DOE sidewall HVB0926002T01\24545R17_result_files	2
file:I:\tce\Lims\FEM-simulations\Request DOE sidewall HVB0926002T01\27530R19_result_files	2
file:I:\tce\Lims\FEM-simulations\Request DOE sidewall HVB0926002T01\29525R20_result_files	2
file:I:\tce\Lims\RawData	15
file:I:\tce\Lims\RawData\temp	9
file:I:\tce\Projecten\Werkmappen\RDMA 2034 LIMS\Rapportages\XY data files	7
file:\\Ensbackup\tce-research\LIMS\EVE1007030T	1
file:\\TCE00\Data\tce\Lims\RawData	10402
file:\\TCE00\data\tce\lims\rawData	38423
file:\\Tce00\data\tce\Lims\Hyperelastic	3
file:\\Tce00\data\tce\Lims\RawData	2
file:\\Tce00\data\tce\Lims\WLF	97
file:\\ensbackup\TCE-RESEARCH\MaterialLibrary\Scripts\STS1435081T_BKM	1
file:\\ensbackup\TCE-RESEARCH\MaterialLibrary\Scripts\STS1435081T_BKM\Apex_A268	1
file:\\ensbackup\TCE-RESEARCH\MaterialLibrary\Scripts\STS1435081T_BKM\Belt_Skim_B168	1
file:\\ensbackup\TCE-RESEARCH\MaterialLibrary\Scripts\STS1435081T_BKM\Cap_Ply_Skim_B160	1
file:\\ensbackup\TCE-RESEARCH\MaterialLibrary\Scripts\STS1435081T_BKM\Chaffer_Skim_XS36	1
file:\\ensbackup\TCE-RESEARCH\MaterialLibrary\Scripts\STS1435081T_BKM\Ply_Skim_B458	1
file:\\ensbackup\TCE-RESEARCH\MaterialLibrary\Scripts\STS1435081T_BKM\RimStrip_R37	1
file:\\ensbackup\TCE-RESEARCH\MaterialLibrary\Scripts\STS1435081T_BKM\Sidewall_XT3078	1
file:\\ensbackup\TCE-RESEARCH\MaterialLibrary\Scripts\STS1435081T_BKM\Tread_Base_XT3076	1
file:\\ensbackup\TCE-RESEARCH\MaterialLibrary\Scripts\STS1435081T_BKM\Tread_Cap_ST244	1
file:\\ensbackup\TCE-RESEARCH\MaterialLibrary\Scripts\STS1435081T_BKM\Tread_Cap_T6730	1
file:\\evo_d330\eelco\LIMS\Meshes	3
file:\\tce00.vredestein.com\data\tce\Lims\RawData	3887
file:\\tce00.vredestein.com\data\tce\Lims\TanData2019	99
file:\\tce00\data\tce\Lims\FEM-simulations	1
file:\\tce00\data\tce\Lims\RawData	4431
file:\\tce00\data\tce\lims\RawData	16525
file:\\tce00\data\tce\lims\RawData2019	11771
file:\\tce00\data\tce\lims\TanData2019	591
file:\\tce00\data\tce\lims\rawData	46140
file:\\tce00\data\tce\lims\rawdata	49
*/


--Report name : UNI00036R_dispersion	
--
--[Product & Process development ]
--    - [ Athena testing ]
--      - [ Dispersion ]
--TOP-FILTER: LOV IMPORTID
--
--(view_2_1_1_3_1_partno_dispersion.sql for BOM)

--Compound				Import ID	Production date			Fi
--EF_Y275/30R20WPRX		23471007	2024/03/14 00:00:00		297.31%



select me.sc, me.pa, me.me, megk.importid, me.exec_end_date
from utscme                   me
JOIN utscmegkimportid       megk on (megk.sc = me.sc and megk.pg = me.pg and megk.pgnode = me.pgnode and megk.pa = me.pa and megk.panode = me.panode and megk.me = me.me and megk.menode = me.menode)
JOIN utscgkpart_no          scgk on (scgk.sc = me.sc)
JOIN utscmegkme_is_relevant meir on (meir.sc = me.sc and meir.pg = me.pg and meir.pgnode = me.pgnode and meir.pa = me.pa and meir.panode = me.panode and meir.me = me.me and meir.menode = me.menode and meir.me_is_relevant = '1')
WHERE me.ss  IN ('AV', '@P', 'IE', 'WA', 'SU', 'ER')
AND part_no = 'EF_Y275/30R20WPRX'
; 
--23.955.WTR01	Noise R117 label	TT872A	23471007	


select * from utsc where sc = '23.955.WTR01' ;


select * from utscpa where sc = '23.955.WTR01' ;

select * from utscme where sc = '23.955.WTR01' ;



select * from specification_header where part_no = 'EF_Y275/30R20WPRX' 
--EF_Y275/30R20WPRX	16	127	275/30R20 97Y Wintrac Pro XL	17-07-2023 00:00:00	17-07-2023 13:16:05




--**************************************
--**************************************

-* File UNI00036P_importIds.fex
-DEFAULTH &PART_NO = FOC_NONE;
 
SET SHORTPATH = SQL
 
JOIN
  SC IN UVSCME TAG method TO UNIQUE
  SC IN UVSCMEGKIMPORTID TAG import AS J0
END
JOIN
  SC IN UVSCME TO UNIQUE
  SC IN UVSCGKPART_NO AS J1
END
JOIN
  SC AND PG AND PGNODE AND PA AND PANODE AND ME AND MENODE IN UVSCME TO
  SC AND PG AND PGNODE AND PA AND PANODE AND ME AND MENODE IN UVSCMEGKME_IS_RELEVANT TAG me_rel AS J2
END
JOIN LEFT_OUTER
  FILE UVSCME AT SC TO UNIQUE
  FILE UVSCGKISTEST AT SC TAG test AS J3
 
  WHERE test.SC EQ import.SC;
  WHERE test.ISTEST EQ '1';
END
TABLE FILE UVSCME
SUM FST.IMPORTID
BY PART_NO
 
WHERE test.ISTEST IS MISSING;
WHERE me_rel.ME_IS_RELEVANT EQ '1';
WHERE method.SS EQ 'AV' OR '@P' OR 'IE' OR 'WA' OR 'SU' OR 'ER';
WHERE PART_NO EQ '&PART_NO';
 
ON TABLE PCHOLD FORMAT XML
END


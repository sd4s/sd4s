--Om snel alle nieuwe SPECIFICATION-HEADER-REVISION te bepalen en op te halen
--is het handig om een INDEX op ISSUED_DATE te hebben.
--Deze wordt gebruikt vanuit AAPIWEIGHT_CALC.DBA_VERWERK_GEWICHT_MUTATIES
--Per te verwerken FRAME wordt zelfde query uitgevoerd...

DROP INDEX "INTERSPC"."IDX_ISSUED_DATE";
--
CREATE INDEX "INTERSPC"."IDX_ISSUED_DATE" ON "INTERSPC"."SPECIFICATION_HEADER" ("ISSUED_DATE") 
PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
TABLESPACE "SPECI" ;
  
/*  
SELECT sh.PART_NO
,      sh.REVISION
,      sh.FRAME_ID
,      sh.STATUS
,      s.sort_desc
,      sh.DESCRIPTION
,      sh.ISSUED_DATE   
,      sh.STATUS_CHANGE_DATE
,      sh.OBSOLESCENCE_DATE
,      bh.alternative

select count(*)
FROM STATUS                s
,    SPECIFICATION_HEADER  sh
,    BOM_HEADER            bh
WHERE sh.issued_date between to_date('01-10-2022 00:00:00','dd-mm-yyyy hh24:mi:ss')  
                     and  to_date('11-12-2022 23:59:59','dd-mm-yyyy hh24:mi:ss')   
and   s.status      = sh.status
and   s.status_type = 'CURRENT' 
and   bh.part_no  = sh.part_no
and   bh.revision = sh.revision
and   bh.preferred = 1
order by sh.part_no
;  
*/


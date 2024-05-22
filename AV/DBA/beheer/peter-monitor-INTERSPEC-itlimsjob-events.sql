--DESCR ITLIMSJOB

--overzicht lims-job-events 
SELECT COUNT(*)
, TRUNC(DATE_READY) 
, TRUNC(DATE_PROCEED)
FROM ITLIMSJOB 
GROUP BY TRUNC(DATE_READY), TRUNC(DATE_PROCEED)
ORDER BY TRUNC(DATE_READY) DESC, TRUNC(DATE_PROCEED)
;

--overzicht lims-job-events die nog niet proceed zijn !!!
--select *
select plant, part_no, revision, date_ready from itlimsjob
where date_ready > to_date('09-09-2020','dd-mm-yyyy')
and  date_proceed is null
order by plant
        , date_ready
        , part_no
;

--AANTALLEN events voor zelfde PLANT/PART-NO
SELECT plant, part_no, COUNT(*)
from ITLIMSJOB
GROUP BY PLANT, PART_NO
HAVING COUNT(*) > 1
order by plant, part_no
;

--details van events met meerder voorkomens (binnen zelfde PLANT)

SELECT PLANT, PART_NO, REVISION, DATE_READY, DATE_PROCEED
FROM ITLIMSJOB JOB
WHERE 1 < (SELECT COUNT(*)
           FROM ITLIMSJOB  job2
           where job2.PLANT = job.plant
           and   job2.PART_NO = job.part_no
          )
and  date_ready  > to_date('09-09-2020','dd-mm-yyyy')          
;
--no rows selected


--details van events met meerder voorkomens (binnen verschillende PLANT)
--Dit komt steeds vaker voor, dan is spec eerst van ENS en later van GYO.
--Dit levert problemen op bij het versturen van LIMSJOB-events van INTERSPEC naar UNILAB. 

--overzicht van PART-NO die met verschillende REVISIES voorkomen (dit is normaal gebruik en niet direct een probleem!)
SELECT PLANT, PART_NO, REVISION, DATE_READY, DATE_PROCEED
FROM ITLIMSJOB JOB
WHERE 1 < (SELECT COUNT(*)
           FROM ITLIMSJOB  job2
           where job2.PART_NO = job.part_no
		   and exists
		        (select '' 
				 from itlimsjob job3
				 where job3.date_ready  > to_date('08-09-2020','dd-mm-yyyy')          
                 and   job3.part_no = job2.part_no
				)
          )
order by part_no, plant, date_ready
;
--overzicht van PART-NO die met verschillende PLANT voorkomen (DIT IS WEL EEN PROBLEEM, LOOPT INTERFACE NAAR UNILAB OP STUK !!)
SELECT PLANT, PART_NO, REVISION, DATE_READY, DATE_PROCEED
FROM ITLIMSJOB JOB
WHERE 1 < (SELECT COUNT(DISTINCT PLANT)
           FROM ITLIMSJOB  job2
           where job2.PART_NO = job.part_no
		   --and exists
		   --     (select '' 
			--	 from itlimsjob job3
			--	 where job3.date_ready  > to_date('08-09-2020','dd-mm-yyyy')          
             --    and   job3.part_no = job2.part_no
			--	)
          )
order by part_no, plant, date_ready
;


--herstellen met het verwijderen van OUDSTE-record (DATE-PROCEED is nog niet gevuld).
--Vaak is de meest actuele versie al verwerkt. 

--part-nr: GF_1954516ULAXV
--TABEL-interspec:	itlimsjob
--TABEL-temp:			attmp_itlimsjob

insert into attmp_itlimsjob as 
select * from itlimsjob where PLANT='ENS' and part_nO='GF_1954516ULAXV' and revision=4;
commit;
delete from itlimsjob where PLANT='ENS' and part_nO='GF_1954516ULAXV' and revision=4;
commit;


--einde script


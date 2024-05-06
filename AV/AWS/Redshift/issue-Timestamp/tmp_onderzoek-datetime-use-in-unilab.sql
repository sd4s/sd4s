SELECT DATA_TYPE, COUNT(*) FROM ALL_TAB_COLUMNS 
WHERE OWNER='UNILAB' AND TABLE_NAME LIKE 'UT%'
AND DATA_TYPE IN ( 'TIMESTAMP(0) WITH LOCAL TIME ZONE','TIMESTAMP(0) WITH TIME ZONE')
GROUP BY DATA_TYPE
;
TIMESTAMP(0) WITH LOCAL TIME ZONE	245
TIMESTAMP(0) WITH TIME ZONE	245

SELECT DATA_TYPE, COUNT(*) FROM ALL_TAB_COLUMNS 
WHERE OWNER='UNILAB' AND TABLE_NAME LIKE 'UT%'
AND DATA_TYPE IN ( 'DATE')
GROUP BY DATA_TYPE
;

select min(sampling_date_tz) from utsc where sampling_date_tz is not null;
--2009
select count(*) from utsc where sampling_date is not null and sampling_date_tz is null;
--916330
select count(*), to_char(sampling_date,'yyyy') jaar 
from utsc 
where sampling_date is not null and sampling_date_tz is null
group by to_char(sampling_date,'yyyy')
order by to_char(sampling_date,'yyyy')
;
1057	2007
207527	2008
290039	2009
286483	2010
131224	2011


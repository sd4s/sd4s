select count(*), trunc(start_date), client_id 
from UNILAB.atevlog 
group by trunc(start_date), client_id 
order by client_id, trunc(start_date) ;

--wat heeft er vanacht gedraaid?

select count(*), trunc(start_date), client_id 
from UNILAB.atevlog 
where trunc(start_date) between to_date('09-09-2020 20:00:00','dd-mm-yyyy hh24:mi:ss')
                        and     to_date('10-09-2020 07:00:00','dd-mm-yyyy hh24:mi:ss')
group by trunc(start_date), client_id 
order by client_id, trunc(start_date) ;

--per uur 
select count(*), to_char(start_date,'DD-MM-YYYY HH24'), client_id 
from UNILAB.atevlog 
where trunc(start_date) between to_date('09-09-2020 20:00:00','dd-mm-yyyy hh24:mi:ss')
                        and     to_date('10-09-2020 07:00:00','dd-mm-yyyy hh24:mi:ss')
group by client_id, to_char(start_date,'DD-MM-YYYY HH24') 
order by client_id, to_char(start_date,'DD-MM-YYYY HH24') 
;

--overzicht per gebruiker
SELECT to_char(start_date,'DD-MM-YYYY HH24:mi:ss')
FROM UNILAB.ATEVLOG
where client_id LIKE 'HUNG%21'
and  start_date between to_date('08-09-2020 20:00:00','dd-mm-yyyy hh24:mi:ss')
                 and     to_date('10-09-2020 07:00:00','dd-mm-yyyy hh24:mi:ss')
;





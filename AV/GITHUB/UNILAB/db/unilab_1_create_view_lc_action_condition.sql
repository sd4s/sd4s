--view voor benaderen van de LC-info
--Per LC komt (op dit moment) maar 1 version (= 0) voor.
--Per LC heb je meerdere status-overgangen  SS_FROM - SS_TO
--Per statusovergang kun je maar 1 CONDITION meegeven. 
--Indien er meerdere CONDITIONS gelden voor functioneel zelfde statusovergang komt zelfde statusovergang meerdere keren voor
--Bij 1 statusovergang komen meerdere ACTIONS voor
--Bij 1 statusovergang komen meerdere geautoriseerde personen/afdelingen voor
--

/*
SELECT lc.lc
,      lc.name
,      lc.active
,      lc.version_is_current
from utlc lc
where lc.active='1'
and   lc.version_is_current='1'
order by lc
;

SELECT lc.lc
,      lc.name
,      lc.active
,      lc.version_is_current
,      tr.ss_from
,      tr.ss_to
,      tr.condition
from utlc   lc
,    utlctr tr
where lc.lc      = tr.lc
and   lc.version = tr.version
and   lc.active='1'
and   lc.version_is_current='1'
order by lc.lc, tr.ss_from, tr.ss_to
;

SELECT lc.lc
,      lc.name
,      lc.active
,      lc.version_is_current
,      tr.ss_from
,      tr.ss_to
,      tr.condition
from  utlc   lc
JOIN  utlctr tr ON (lc.lc = tr.lc and lc.version = tr.version)
where lc.active='1'
and   lc.version_is_current='1'
order by lc.lc, tr.ss_from, tr.ss_to
;
--392 RECORDS

SELECT lc.lc
,      lc.name
,      lc.active
,      lc.version_is_current
,      tr.ss_from
,      tr.ss_to
,      tr.condition
,      af.af
from  utlc   lc
JOIN  utlctr tr ON (lc.lc = tr.lc and lc.version = tr.version)
FULL OUTER JOIN utlcaf af ON (tr.lc = af.lc and tr.version=af.version and tr.ss_from=af.ss_from and tr.ss_to=af.ss_to)
where lc.active='1'
and   lc.version_is_current='1'
order by lc.lc, tr.ss_from, tr.ss_to, af.tr_no, af.seq
;
--478 RECORDS
*/

CREATE OR REPLACE VIEW AV_BHR_LC_SS_COND_ACTION
(lc
,lc_name
,ss_from
,ss_from_name
,ss_to
,ss_to_name
,condition
,action
)
as
SELECT lc.lc
,      lc.name
,      tr.ss_from
,      ssf.name   ss_from_name
,      tr.ss_to
,      sst.name   ss_to_name
,      tr.condition
,      LISTAGG( af.af, ',') within group (order by af.tr_no, af.seq, af.af)  as action
from  utlc   lc
JOIN  utlctr tr ON (lc.lc = tr.lc and lc.version = tr.version)
LEFT OUTER JOIN utlcaf af ON (tr.lc = af.lc and tr.version=af.version and tr.ss_from=af.ss_from and tr.ss_to=af.ss_to and tr.tr_no=af.tr_no)
JOIN utss ssf on (tr.ss_from = ssf.ss)
JOIN utss sst on (tr.ss_to   = sst.ss)
where lc.active='1'
and   lc.version_is_current='1'
group  by lc.lc, lc.name, tr.ss_from, ssf.name, tr.ss_to, sst.name, tr.condition
order  by lc.lc, lc.name, tr.ss_from, ssf.name, tr.ss_to, sst.name, tr.condition
;
--390 records

--HET LUKT NIET OM 2 LISTAGG IN 1XQUERY TE STOPPEN OP 2 VERSCHILLENDE TABELLEN.
--TOTAALOVERZICHT AUTH
CREATE OR REPLACE VIEW AV_BHR_LC_SS_COND_AUTH_US
(lc
,lc_name
,ss_from
,ss_from_name
,ss_to
,ss_to_name
,condition
,auth
)
as
SELECT lc.lc
,      lc.name
,      tr.ss_from
,      ssf.name   ss_from_name
,      tr.ss_to
,      sst.name   ss_to_name
,      tr.condition
,      LISTAGG( us.us, ',') within group (order by us.tr_no, us.us)          as auth
from  utlc   lc
JOIN  utlctr tr ON (lc.lc = tr.lc and lc.version = tr.version)
LEFT OUTER JOIN utlcus us ON (tr.lc = us.lc and tr.version=us.version and tr.ss_from=us.ss_from and tr.ss_to=us.ss_to and tr.tr_no=us.tr_no)
JOIN utss ssf on (tr.ss_from = ssf.ss)
JOIN utss sst on (tr.ss_to   = sst.ss)
where lc.active='1'
and   lc.version_is_current='1'
group  by lc.lc, lc.name, tr.ss_from, ssf.name, tr.ss_to, sst.name, tr.condition
order  by lc.lc, lc.name, tr.ss_from, ssf.name, tr.ss_to, sst.name, tr.condition
;
--387

/*
--USER=UTAD
SELECT lc.lc
,      lc.name
,      tr.ss_from
,      tr.ss_to
,      tr.condition
,      LISTAGG( substr(ad.person,1,20), ',') within group (order by us.tr_no, us.us)          as auth
from  utlc   lc
JOIN  utlctr tr ON (lc.lc = tr.lc and lc.version = tr.version)
LEFT OUTER JOIN utlcus us  ON (tr.lc = us.lc and tr.version=us.version and tr.ss_from=us.ss_from and tr.ss_to=us.ss_to)
LEFT OUTER JOIN utad   ad  ON (us.us = ad.ad)
where lc.active='1'
and   lc.version_is_current='1'
--AND   us.us not like 'UP%'  AND us.us not like '%ANY%' and us.us not like '(null)' and us.us not like '%DYNAMIC%'
--AND   us2.us like 'UP%'
group  by lc.lc, lc.name, tr.ss_from, tr.ss_to, tr.condition
order  by lc.lc, lc.name, tr.ss_from, tr.ss_to, tr.condition
;

--USER=UTUP
SELECT lc.lc
,      lc.name
,      tr.ss_from
,      tr.ss_to
,      tr.condition
,      LISTAGG( substr(up.description,1,50), ',') within group (order by us.tr_no, us.us)          as auth
from  utlc   lc
JOIN  utlctr tr ON (lc.lc = tr.lc and lc.version = tr.version)
LEFT OUTER JOIN utlcus us  ON (tr.lc = us.lc and tr.version=us.version and tr.ss_from=us.ss_from and tr.ss_to=us.ss_to)
LEFT OUTER JOIN utup   up  ON (us.us = 'UP'||up.up)
where lc.active='1'
and   lc.version_is_current='1'
--AND   us.us not like 'UP%'  AND us.us not like '%ANY%' and us.us not like '(null)' and us.us not like '%DYNAMIC%'
--AND   us2.us like 'UP%'
group  by lc.lc, lc.name, tr.ss_from, tr.ss_to, tr.condition
order  by lc.lc, lc.name, tr.ss_from, tr.ss_to, tr.condition
;
*/

--TOTAAL-VIEW-AUTHENTICATION
CREATE OR REPLACE VIEW AV_BHR_LC_SS_COND_AUTH_US_NAME
(type
,lc
,lc_name
,ss_from
,ss_from_name
,ss_to
,ss_to_name
,condition
,auth_name
)
as
SELECT 'lcad' type
,      lc.lc
,      lc.name
,      tr.ss_from
,      ssf.name   ss_from_name
,      tr.ss_to
,      sst.name   ss_to_name
,      tr.condition
,      LISTAGG( substr(ad.person,1,20), ',') within group (order by us.tr_no, us.us)          as auth
from  utlc   lc
JOIN  utlctr tr ON (lc.lc = tr.lc and lc.version = tr.version)
LEFT OUTER JOIN utlcus us  ON (tr.lc = us.lc and tr.version=us.version and tr.ss_from=us.ss_from and tr.ss_to=us.ss_to and tr.tr_no=us.tr_no)
JOIN utad   ad  ON (us.us = ad.ad)
JOIN utss ssf on (tr.ss_from = ssf.ss)
JOIN utss sst on (tr.ss_to   = sst.ss)
where lc.active='1'
and   lc.version_is_current='1'
group  by lc.lc, lc.name, tr.ss_from, ssf.name, tr.ss_to, sst.name, tr.condition
UNION
SELECT 'utlcus' type
,      lc.lc
,      lc.name
,      tr.ss_from
,      ssf.name   ss_from_name
,      tr.ss_to
,      sst.name   ss_to_name
,      tr.condition
,       us.us  as auth
from  utlc   lc
JOIN  utlctr tr ON (lc.lc = tr.lc and lc.version = tr.version)
LEFT OUTER JOIN utlcus us  ON (tr.lc = us.lc and tr.version=us.version and tr.ss_from=us.ss_from and tr.ss_to=us.ss_to and tr.tr_no=us.tr_no)
JOIN utss ssf on (tr.ss_from = ssf.ss)
JOIN utss sst on (tr.ss_to   = sst.ss)
where lc.active='1'
and   lc.version_is_current='1'
AND   (  us.us like '%ANY%' or us.us is null or us.us like '%DYNAMIC%' )
UNION
SELECT 'utup' type
,      lc.lc
,      lc.name
,      tr.ss_from
,      ssf.name   ss_from_name
,      tr.ss_to
,      sst.name   ss_to_name
,      tr.condition
,      LISTAGG( substr(up.description,1,50), ',') within group (order by us.tr_no, us.us)          as auth
from  utlc   lc
JOIN  utlctr tr ON (lc.lc = tr.lc and lc.version = tr.version)
LEFT OUTER JOIN utlcus us  ON (tr.lc = us.lc and tr.version=us.version and tr.ss_from=us.ss_from and tr.ss_to=us.ss_to and tr.tr_no=us.tr_no)
JOIN utup   up  ON (us.us = 'UP'||up.up)
JOIN utss ssf on (tr.ss_from = ssf.ss)
JOIN utss sst on (tr.ss_to   = sst.ss)
where lc.active='1'
and   lc.version_is_current='1'
AND   us.us like 'UP%'
group  by lc.lc, lc.name, tr.ss_from, ssf.name, tr.ss_to, sst.name, tr.condition
order  by 1,2,3,4,5,6,7,8
;






--TP136A, TP137A en TP138A.

Select mt.mt, mt.sop , count(*)
from utmt mt
Where mt.version_is_current = 1
--AND  mt.sop is not null
and   mT.mt in ('TP136A', 'TP137A', 'TP138A')
--and instr(mt.sop,'#BLB') > 0
--and     not exists   (select blob.id from utblob blob where blob.id = mt.sop)
group by mt.mt, mt.sop
;

--TP137A		1
--TP136A		1
--TP138A		1
--SOP IS NULL !!!!

Select mt.mt, mt.sop , count(*)
from utmt mt
Where mt.sop is not null
and   mt.version_is_current = 1
and   mT.mt in ('TP136A', 'TP137A', 'TP138A')
and instr(mt.sop,'#BLB') > 0
and     not exists   (select blob.id from utblob blob where blob.id = mt.sop)
group by mt.mt, mt.sop
;
--no-rows

Select me.ME, me.sop , count(*)
from utscme me
Where me.me in ('TP136A', 'TP137A', 'TP138A')
--and me.sop is not null
--and   instr(me.sop,'#BLB') > 0
--and     not exists   (select blob.id from utblob blob where blob.id = me.sop)
group by me.me, me.sop
order by me.me, me.sop
;
--TP136A		12
--TP137A		5
--TP138A		3
--me.sop is null !!!

/*
Select me.sop , count(*)
from utscme me
Where me.sop is not null
and instr(me.sop,'#BLB') > 0
and     not exists   (select blob.id from utblob blob where blob.id = me.sop)
group by me.sop
;
2020-1014-0032#BLB	279
TC006E-3.0.0#BLB	106
2020-0910-0001#BLB	87
20-0409-0001#BLB	1
1802022100119025#BLB	2
2020-0430-0012#BLB	224
2020-0423-0045#BLB	13
19-0828-0003#BLB	222
2011-0606-0004#BLB	202
2021-0607-0002#BLB	1
*/

/*
Select me.me, me.sop , count(*)
from utscme me
Where me.sop is not null
--and  me.me in ('TP136A', 'TP137A', 'TP138A')
and instr(me.sop,'#BLB') > 0
and     not exists   (select blob.id from utblob blob where blob.id = me.sop)
group by me.me, me.sop
;

TT501A	2020-0430-0012#BLB	224
EC007A	2021-0607-0002#BLB	1
TC001A	2011-0606-0004#BLB	202
TT763A	1802022100119025#BLB	2
TT501A	2020-1014-0032#BLB	279
TT872A	19-0828-0003#BLB	222
TT501A	2020-0423-0045#BLB	13
TC006E	TC006E-3.0.0#BLB	106
TT501A	20-0409-0001#BLB	1
TT501A	2020-0910-0001#BLB	87
*/

/*
Select me.me, me.ss, max(me.exec_start_date) 
from utscme me
where me.me in 
(select mt.mt
from utmt mt
Where mt.sop is not null
and   mt.version_is_current = 1
and instr(mt.sop,'#LNK') > 0
)
and me.ss not in ('@C')
group by me.me, me.ss
order by me.me, me.ss
;
*/


--kijken of we op deze manier ook een totaal-overzicht kunnen krijgen van alle MT waarvan de BLOB niet is overgehaald vanuit WATSON...
Select mt.mt, mt.sop , count(*)
from utmt mt
Where mt.sop is not null
and   mt.version_is_current = 1
--and   mT.mt in ('TP136A', 'TP137A', 'TP138A')
and instr(mt.sop,'#BLB') > 0
and     not exists   (select blob.id from utblob blob where blob.id = mt.sop)
group by mt.mt, mt.sop
;
--EC007A	2021-0607-0002#BLB	1
--conclusie: Query levert maar 1 RECORD op, dit is niet de juiste controle. Waarschijnlijk wordt pas in UNILAB een nieuw voorkomen gemaakt NADAT
--           hij een nieuwe DOCUMENT-VERSIE uit WATSON heeft opgehaald !!!



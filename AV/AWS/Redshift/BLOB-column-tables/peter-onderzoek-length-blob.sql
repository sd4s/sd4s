--Onderzoek naar de lengte van de BlOB-columns 


--UNILAB.utblob


select lengte
from (select (length(data)) lengte from utblob where length(data) is not null order by length(data) desc   )
--where rownum < 10
;

/*
385304219   --> complete zip-file, which is also stored on a network-share !!!  At the moment in a SUBFOLDER, AND NOT consistent with utblob.path !!! 
             -- Where are these used for? Shouldn't these files not be a LNK-LINK to a shared-file in UTLONGTEXT ?
355405985
286695315
286695315
281160614
236808248
234518326
229893071
214429087
206078541
197049170
195700620
194802216
180703308
180473591
180110258
177964964
174111247
172863133
170919500
168623912
164735008
162539888
161224205
152116757
145583195
141848236
141585641
138494652
130099380
129954788
125807607
125509489
120083327
118105240
117885072
117362553
115857662
115685293
114953453
112832608
107081650
105912030
104804873
104457121
102309702
101279386
99729283
97757802
97227102
...
*/

select lengte
from (select (length(data)) lengte from utblob where length(data) is not null order by length(data) asc   )
--where rownum < 10
;
/*
0    --empty !!
0    --empty !!
2    --test
3    --test
4    --test
5    --test
6    --test
6    --test
7    --test
8    --test
8    --test
55
55
55
55
55
55
55
55
55
55
55
55
55
55
55
55
55
55
55
55
55
55
55
55
55
55
55
55
55
55
55
55
55
55
55
62
70
77
81
82
84
84
89
94
122
...
*/



--CONCLUSIION: SHOULD ALL FIT IN VARCHAR2-FIELD IN REDSHIFT !!!!!!!!
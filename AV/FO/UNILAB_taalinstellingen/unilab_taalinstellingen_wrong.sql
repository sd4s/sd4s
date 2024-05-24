--Controle-numerieke waardes MET KOMMA als decimaal-scheider in STRING-value (ipv DECIMALE-PUNT) !!
--
--pattern
--The regular expression matching information. It can be a combination of the following:
/*
Value	Description
^		Matches the beginning of a string. If used with a match_parameter of 'm', it matches the start of a line anywhere within expression.
$		Matches the end of a string. If used with a match_parameter of 'm', it matches the end of a line anywhere within expression.
*		Matches zero or more occurrences.
+		Matches one or more occurrences.
?		Matches zero or one occurrence.
.		Matches any character except NULL.
|		Used like an "OR" to specify more than one alternative.
[ ]		Used to specify a matching list where you are trying to match any one of the characters in the list.
[^ ]	Used to specify a nonmatching list where you are trying to match any character except for the ones in the list.
( )		Used to group expressions as a subexpression.
{m}		Matches m times.
{m,}	Matches at least m times.
{m,n}	Matches at least m times, but no more than n times.
\n		n is a number between 1 and 9. Matches the nth subexpression found within ( ) before encountering \n.
[..]	Matches one collation element that can be more than one character.
[::]	Matches character classes.
[==]	Matches equivalence classes.
\d		Matches a digit character.
\D		Matches a nondigit character.
\w		Matches a word character.
\W		Matches a nonword character.
\s		Matches a whitespace character.
\S		matches a non-whitespace character.
\A		Matches the beginning of a string or matches at the end of a string before a newline character.
\Z		Matches at the end of a string.
*?		Matches the preceding pattern zero or more occurrences.
+?		Matches the preceding pattern one or more occurrences.
??		Matches the preceding pattern zero or one occurrence.
{n}?	Matches the preceding pattern n times.
{n,}?	Matches the preceding pattern at least n times.
{n,m}?	Matches the preceding pattern at least n times, but not more than m times.
match_parameter
Optional. It allows you to modify the matching behavior for the REGEXP_LIKE condition. It can be a combination of the following:

Value	Description
'c'	Perform case-sensitive matching.
'i'	Perform case-insensitive matching.
'n'	Allows the period character (.) to match the newline character. By default, the period is a wildcard.
'm'	expression is assumed to have multiple lines, where ^ is the start of a line and $ is the end of a line, regardless of the position of those characters in expression. By default, expression is assumed to be a single line.
'x'	Whitespace characters are ignored. By default, whitespace characters are matched like any other character.
*/
select me.sc, me.pg, me.pa, me.me, me.value_s, me.value_f, case WHEN REGEXP_LIKE (me.value_s, '[0-9]') THEN REGEXP_REPLACE (me.value_s, ',', '.' ) ELSE 'FOUT' end  expresult 
from utscme  me
WHERE  me.value_f is null
and  REGEXP_LIKE (me.value_s, '[0-9]') 
and  NOT REGEXP_LIKE (me.value_s, '^[A-Z]') 
and rownum< 5
--
/*
083306657		Indoor testing			TT520AX-TT729XX	TT729A	116		.	116
083403804		Indoor testing			TT520AX-TT729XX	TT729A	78		.	78
RVO1013018T01	T-T: PCT Indoor adv.	TT351AA			TT351A	9.52	.	9.52
RVO1013016T02	T-T: PCT Indoor adv.	TT351AA			TT351A	10.66	.	10.66
*/

select me.sc, me.pg, me.pa, me.me, me.value_s, me.value_f, case WHEN REGEXP_LIKE (me.value_s, '[0-9]') THEN REGEXP_REPLACE (me.value_s, ',', '.' ) ELSE 'FOUT' end  expresult 
from utscme  me
WHERE  me.value_f is null
and  REGEXP_LIKE (me.value_s, '*([0-9]),*([0-9])') 
and  NOT REGEXP_LIKE (me.value_s, '^[A-Z]') 
and rownum< 5
/*
083306657	Indoor testing	TT520AX-TT729XX	TT729A	116		116
083403804	Indoor testing	TT520AX-TT729XX	TT729A	78		78
RVO1013018T01	T-T: PCT Indoor adv.	TT351AA	TT351A	9.52		9.52
RVO1013016T02	T-T: PCT Indoor adv.	TT351AA	TT351A	10.66		10.66
*/


--***************************
--TEST CHAT-GPT-regexp
--***************************
-- ^and $ anchor the regular expression to the start and end of the string, ensuring it matches the entire string
-- -? allows for an optional minus sign for negative numbers
-- \d+ matches one or more digits
-- (\,\d+) allows for an optional decimal point and one or more digits after it. makes the regex suitable for inteegers and floats.
/*
select me.sc, me.pg, me.pa, me.me, me.value_s, me.value_f, case WHEN REGEXP_LIKE (me.value_s, '^-?\d(\,\d+)?$')  THEN REGEXP_REPLACE (me.value_s, ',', '.' ) ELSE 'FOUT' end  expresult 
from utscme  me
WHERE  me.value_f is null
and  REGEXP_LIKE (me.value_s, '^-?\d+(\,\d+)?$') 
and rownum< 5


select m.sc, m.pg, m.pa, m.me, m.value_s, m.value_f
, case WHEN REGEXP_LIKE (m.value_s, '^-?\d+(\.\d+)?$')  THEN REGEXP_REPLACE (m.value_s, ',', '.' ) ELSE 'FOUT' end  expresult 
from (
select me.sc, me.pg, me.pa, me.me, me.value_s, me.value_f
from utscme  me
WHERE  REGEXP_LIKE (me.value_s, '^-?\d+(\.\d+)?$') 
and  me.value_f is null
)  m
where rownum < 100
;
*/
/*
RVO1013018T01	T-T: PCT Indoor adv.	TT351AA	TT351A	9.52		9.52
TAE1017008T01	T-T: PCT Indoor adv.	TT351AA	TT351A	8.6		8.6
TAE1017008T02	T-T: PCT Indoor adv.	TT351AA	TT351A	8.93		8.93
RVO1018001T01	T-T: PCT Indoor adv.	TT351AA	TT351A	9.955		9.955
RVO1018001T03	T-T: PCT Indoor adv.	TT351AA	TT351A	9.065		9.065
PBR1021057T02	T-T: PCT Indoor adv.	TT351AA	TT351A	8.04		8.04
15.557.IBO01	Outdoor testing	Handling dry func	TT840A	7.2		7.2
15.557.IBO02	Outdoor testing	Handling dry func	TT840A	6		6
15.557.IBO03	Outdoor testing	Handling dry func	TT840A	6.4		6.4
*/

--********************************************
--DEZE REGEXP WERKT GOED !! 
--********************************************
--Hier zoeken we alleen naar digits followd by a komma and extra digits at the end of string
select m.sc, m.pg, m.pa, m.me, '#'||m.value_s||'#', m.value_f
, case WHEN REGEXP_LIKE (m.value_s, '^-?\d+,\d+$')  THEN REGEXP_REPLACE (m.value_s, ',', '.' ) ELSE 'FOUT' end  expresult 
from ( select me.sc, me.pg, me.pa, me.me, me.value_s, me.value_f
       from utscme  me
       WHERE  REGEXP_LIKE(me.value_s, '^-?\d+,\d+$') 
       --AND me.sc = 'RZE1843058F02'
       and  me.value_f is null
      )  m
;

--zoeken naar number met punt zonder een VALUE_F !!!!
select m.sc, m.pg, m.pa, m.me, '#'||m.value_s||'#', m.value_f
--, case WHEN REGEXP_LIKE (m.value_s, '^-?\d+,\d+$')  THEN REGEXP_REPLACE (m.value_s, ',', '.' ) ELSE 'FOUT' end  expresult 
from ( select me.sc, me.pg, me.pa, me.me, me.value_s, me.value_f
       from utscme  me
       WHERE  REGEXP_LIKE(me.value_s, '^-?\d+\.\d+$') 
       --AND me.sc = 'RZE1843058F02'
       and  me.value_f is null
      )  m
;
--ONLY 12 rows MET VALUE_F is null
--286.118 rows met VALUE_F is NOT null



spool c:\temp\peter-me-decimal-komma.txt
set pages 9999
set linesize 300
--
select me.sc, me.pg, me.pa, me.me, me.value_s, me.value_f, case WHEN REGEXP_LIKE (me.value_s, '[0-9]') THEN to_number(REGEXP_REPLACE (me.value_s, ',', '.' )) ELSE -999999999 end  expresult 
from utscme  me
WHERE  me.value_f is null
and  REGEXP_LIKE (me.value_s, '*([0-9]),*([0-9])') 
and REGEXP_INSTR(me.value_s, ',') > 0 
and  NOT REGEXP_LIKE (me.value_s, '^[A-Z]') 
;
--and rownum< 5
spool off;

--
/*
ANM1336003T01	Standard	Dispersion FM (dk)	TP005A	86,2		86.2
RZE1843058F02	Release small trials	Dispersion FM (dk)	TP005A	95,6038627395153		95.6038627395153
RZE1843058F03	Release small trials	Dispersion FM (dk)	TP005A	95,6038627395153		95.6038627395153
RZE1843058F04	Release small trials	Dispersion FM (dk)	TP005A	95,6038627395153		95.6038627395153
RZE1843065F02	Release small trials	Dispersion FM (dk)	TP005A	95,0816637457663		95.0816637457663
RZE1843065F03	Release small trials	Dispersion FM (dk)	TP005A	95,0816637457663		95.0816637457663
VKR1842009F03	Release small trials	Dispersion FM (dk)	TP005A	95,0476850104278		95.0476850104278
VKR1842009F04	Release small trials	Dispersion FM (dk)	TP005A	95,0476850104278		95.0476850104278
VKR1842009F02	Release small trials	Dispersion FM (dk)	TP005A	95,0476850104278		95.0476850104278
RZE1843065F04	Release small trials	Dispersion FM (dk)	TP005A	95,0816637457663		95.0816637457663
VKR1906001F11	Release small trials	Dispersion FM (dk)	TP005A	92,963070596494		92.963070596494
VKR1906001F12	Release small trials	Dispersion FM (dk)	TP005A	91,2489457151815		91.2489457151815
VKR1906001F13	Release small trials	Dispersion FM (dk)	TP005A	89,9577025060759		89.9577025060759
RZE1908079M01	Standard	Dispersion FM (dk)	TP005A	96,4934147295977		96.4934147295977
RZE1908079M02	Standard	Dispersion FM (dk)	TP005A	98,2665393977466		98.2665393977466
ANM1908024F08	Release small trials	Dispersion FM (dk)	TP005A	87,3636811858058		87.3636811858058
ANM1908024F09	Release small trials	Dispersion FM (dk)	TP005A	86,7612154236164		86.7612154236164
RZE1908079M03	Standard	Dispersion FM (dk)	TP005A	97,3985911053175		97.3985911053175
ANM1908024F11	Release small trials	Dispersion FM (dk)	TP005A	92,2267115818347		92.2267115818347
ANM1908024F12	Release small trials	Dispersion FM (dk)	TP005A	94,7682036656709		94.7682036656709
ANM1908024F14	Release small trials	Dispersion FM (dk)	TP005A	94,7270486099935		94.7270486099935
ANM1908024F15	Release small trials	Dispersion FM (dk)	TP005A	91,9931956825463		91.9931956825463
RZE1908079M04	Standard	Dispersion FM (dk)	TP005A	98,0740365351987		98.0740365351987
ANM1908024F17	Release small trials	Dispersion FM (dk)	TP005A	87,2676188030376		87.2676188030376
ANM1908024F18	Release small trials	Dispersion FM (dk)	TP005A	86,6661829014767		86.6661829014767
ANM1908024F20	Release small trials	Dispersion FM (dk)	TP005A	91,7990261681343		91.7990261681343
RZE1908079M05	Standard	Dispersion FM (dk)	TP005A	97,5383658403931		97.5383658403931
ANM1908024F21	Release small trials	Dispersion FM (dk)	TP005A	91,581751400851		91.581751400851
ANM1908024F22	Release small trials	Dispersion FM (dk)	TP005A	94,5929994395154		94.5929994395154
ANM1908024F24	Release small trials	Dispersion FM (dk)	TP005A	92,750140522789		92.750140522789
ANP1909040T01	Standard	Dispersion FM (dk)	TP005A	76,3022570764536		76.3022570764536
ANP1909040T02	Standard	Dispersion FM (dk)	TP005A	90,8651373088652		90.8651373088652
VKR1908056F04	Release small trials	Dispersion FM (dk)	TP005A	94,1488982196343		94.1488982196343
VKR1908056F05	Release small trials	Dispersion FM (dk)	TP005A	95,2182584861458		95.2182584861458
VKR1908056F06	Release small trials	Dispersion FM (dk)	TP005A	86,815866683157		86.815866683157
VKR1908056F07	Release small trials	Dispersion FM (dk)	TP005A	85,421868726894		85.421868726894
VKR1908056F08	Release small trials	Dispersion FM (dk)	TP005A	92,3137508425652		92.3137508425652
RZE1908104F04	Release small trials	Dispersion FM (dk)	TP005A	97,1274657771314		97.1274657771314
RZE1908104F05	Release small trials	Dispersion FM (dk)	TP005A	94,748519963215		94.748519963215
SMA1906120F02	Release small trials	Dispersion FM (dk)	TP005A	81,8103481894697		81.8103481894697
SMA1906120F03	Release small trials	Dispersion FM (dk)	TP005A	88,106581142864		88.106581142864
SMA1906120F04	Release small trials	Dispersion FM (dk)	TP005A	86,7842122329445		86.7842122329445
LVE1908092M04	Standard	Dispersion FM (dk)	TP005A	89,9961614310345		89.9961614310345
LVE1908092M05	Standard	Dispersion FM (dk)	TP005A	93,4656591168987		93.4656591168987
LVE1908092M06	Standard	Dispersion FM (dk)	TP005A	92,6661709729271		92.6661709729271
RZE1909108F02	Release small trials	Dispersion FM (dk)	TP005A	95,977233512695		95.977233512695
RZE1909108F04	Release small trials	Dispersion FM (dk)	TP005A	95,1954512563416		95.1954512563416
LVE1908092M01	Standard	Dispersion FM (dk)	TP005A	90,2110412494153		90.2110412494153
LVE1908092M02	Standard	Dispersion FM (dk)	TP005A	91,2678311579261		91.2678311579261
RZE1909108F03	Release small trials	Dispersion FM (dk)	TP005A	96,9401379634328		96.9401379634328
VKR1909129F12	Release small trials	Dispersion FM (dk)	TP005A	95,5658730118807		95.5658730118807
VKR1908056F03	Release small trials	Dispersion FM (dk)	TP005A	89,6346657426569		89.6346657426569
VKR1909129F10	Release small trials	Dispersion FM (dk)	TP005A	96,3880516510254		96.3880516510254
VKR1909129F11	Release small trials	Dispersion FM (dk)	TP005A	94,4192375335581		94.4192375335581
ANM1908024F19	Release small trials	Dispersion FM (dk)	TP005A	93,3357973462315		93.3357973462315
ANM1908024F23	Release small trials	Dispersion FM (dk)	TP005A	95,079743781625			95.079743781625
ANM1908024F10	Release small trials	Dispersion FM (dk)	TP005A	96,2162259463915		96.2162259463915
ANM1908024F13	Release small trials	Dispersion FM (dk)	TP005A	87,0085817197513		87.0085817197513
ANM1908024F16	Release small trials	Dispersion FM (dk)	TP005A	80,9776952163386		80.9776952163386
SMU1911166M06	Standard	Dispersion FM (dk)	TP005A	94,8661864345164			94.8661864345164
NEM1910047M01	Standard	Dispersion FM (dk)	TP005A	93,3402028302479			93.3402028302479
NEM1910047M03	Standard	Dispersion FM (dk)	TP005A	97,4711840127997			97.4711840127997
NEM1910047M02	Standard	Dispersion FM (dk)	TP005A	98,3787085240306			98.3787085240306
RZE1908104F03	Release small trials	Dispersion FM (dk)	TP005A	96,2512942553157		96.2512942553157
NEM1915030M04	Standard	Dispersion FM (dk)	TP005A	94,9249320460716		94.9249320460716
ANP1916054T01	Standard	Dispersion FM (dk)	TP005A	96,5995559693953		96.5995559693953
SMU1911166M05	Standard	Dispersion FM (dk)	TP005A	95,1115005845018		95.1115005845018
SMU1911166M03	Standard	Dispersion FM (dk)	TP005A	95,068709569781		95.068709569781
SMU1911166M04	Standard	Dispersion FM (dk)	TP005A	95,1133165050403		95.1133165050403
SMU1911166M01	Standard	Dispersion FM (dk)	TP005A	94,8661864345164		94.8661864345164
SMU1911166M02	Standard	Dispersion FM (dk)	TP005A	94,8731519068624		94.8731519068624
AOT1925087T03	Standard	Rebound (70C)	TP019A	54,0		54.0
AOT1925087T02	Standard	Rebound (70C)	TP019A	54,4		54.4
AOT1925087T01	Standard	Rebound (70C)	TP019A	54,4		54.4
TFE1946058T23	Standard	Dispersion FM (dk)	TP005A	91,7135535071373		91.7135535071373
TFE1946058T26	Standard	Dispersion FM (dk)	TP005A	66,4041095568243		66.4041095568243
KBA2011132M01	Standard	Dispersion FM (dk)	TP005A	93,4261981844212		93.4261981844212
TFE1946058T22	Standard	Dispersion FM (dk)	TP005A	95,5806927256624		95.5806927256624
KBA2038036M02	Standard	Dispersion FM (dk)	TP005A	69,0758413612989		69.0758413612989
KBA2038036M03	Standard	Dispersion FM (dk)	TP005A	69,0252147991246		69.0252147991246
KBA2038036M04	Standard	Dispersion FM (dk)	TP005A	58,8364709750567		58.8364709750567
ANM2137070M05	Standard	Dispersion FM (dk)	TP005A	95,7669013830066		95.7669013830066
ANM2137090F06	Release small trials	Dispersion FM (dk)	TP005A	85,7713796671693		85.7713796671693
ANM2137090F07	Release small trials	Dispersion FM (dk)	TP005A	86,5208581609239		86.5208581609239
ANM2137090F09	Release small trials	Dispersion FM (dk)	TP005A	95,5574950932762		95.5574950932762
VKR2124088T02	Standard				Dispersion FM (dk)	TP005A	69,9516938129025		69.9516938129025
NEM2113094F04	Release small trials	Dispersion FM (dk)	TP005A	93,6370444979585		93.6370444979585
VKR2115099M03	Standard				Dispersion FM (dk)	TP005A	91,7476169525156		91.7476169525156
ANP2117046M06	Standard				Dispersion FM (dk)	TP005A	83,0905499325845		83.0905499325845
VKR2122079M05	Standard				Dispersion FM (dk)	TP005A	53,9286393310588		53.9286393310588
VKR2122079M07	Standard				Dispersion FM (dk)	TP005A	69,4359945891971		69.4359945891971
RZE2123049F15	Release small trials	Dispersion FM (dk)	TP005A	81,4868898936903		81.4868898936903
NEM2125080M04	Standard				Dispersion FM (dk)	TP005A	87,594271428256		87.594271428256
RZE2123052T02	Standard				Dispersion FM (dk)	TP005A	90,2409052952265		90.2409052952265
ANP2114115F06	Release small trials	Dispersion FM (dk)	TP005A	56,5314802825819		56.5314802825819
RZE2117039F06	Release small trials	Dispersion FM (dk)	TP005A	88,7576286893467		88.7576286893467
RZE2117039F07	Release small trials	Dispersion FM (dk)	TP005A	93,0927078079		93.0927078079
RZE2117039F08	Release small trials	Dispersion FM (dk)	TP005A	89,5595971633363		89.5595971633363
RZE2123049F14	Release small trials	Dispersion FM (dk)	TP005A	89,6471349851325		89.6471349851325
*/

/*
select 'aantal met komma: '|| count(*)
from utscme  me 
WHERE  me.ss not in ('@C')
and  me.value_f is null
and  REGEXP_LIKE (me.value_s, '*([0-9]),*([0-9])') 
and  REGEXP_INSTR(me.value_s, ',') > 0 
and  NOT REGEXP_LIKE (me.value_s, '^[A-Z]') 
;
--4836

select 'aantal met punt: '|| count(*)
from utscme  me 
WHERE  me.ss not in ('@C')
and  me.value_f is null
and  REGEXP_LIKE (me.value_s, '*([0-9]),*([0-9])') 
and  REGEXP_INSTR(me.value_s, '.') > 0 
and  NOT REGEXP_LIKE (me.value_s, '^[A-Z]') 
;
--5240
*/
--***********************************************
--***********************************************
-- UTSCPA
--***********************************************
--***********************************************

--***********************************************
--DEZE REGEXP WERKT GOED !! 
--***********************************************
--Hier zoeken we alleen naar 
select m.sc, m.pg, m.pa, m.me, '#'||m.value_s||'#', m.value_f
, case WHEN REGEXP_LIKE (m.value_s, '^-?\d+,')  THEN REGEXP_REPLACE (m.value_s, ',', '.' ) ELSE 'FOUT' end  expresult 
from ( select me.sc, me.pg, me.pa, me.me, me.value_s, me.value_f
       from utscpa  me
       WHERE  REGEXP_LIKE(me.value_s, '^-?\d+,\d+$') 
       and  me.value_f is null
       --and  me.value_f is NOT null
      )  m
;

--zoeken naar number met punt zonder een VALUE_F !!!!
select m.sc, m.pg, m.pa, m.me, '#'||m.value_s||'#', m.value_f
--, case WHEN REGEXP_LIKE (m.value_s, '^-?\d+,\d+$')  THEN REGEXP_REPLACE (m.value_s, ',', '.' ) ELSE 'FOUT' end  expresult 
from ( select me.sc, me.pg, me.pa, me.me, me.value_s, me.value_f
       from utscpa  me
       WHERE  REGEXP_LIKE(me.value_s, '^-?\d+\.\d+$') 
       and  me.value_f is null
      )  m
;



--***********************************************
--***********************************************
-- UTSCMECELL
--***********************************************
--***********************************************

--***********************************************
--DEZE REGEXP WERKT GOED !! 
--***********************************************
--Hier zoeken we alleen naar 
select m.sc, m.pg, m.pa, m.me, '#'||m.value_s||'#', m.value_f
, case WHEN REGEXP_LIKE (m.value_s, '^-?\d+,')  THEN REGEXP_REPLACE (m.value_s, ',', '.' ) ELSE 'FOUT' end  expresult 
from ( select me.sc, me.pg, me.pa, me.me, me.value_s, me.value_f
       from utscmecell  me
       WHERE  REGEXP_LIKE(me.value_s, '^-?\d+,\d+$') 
       --AND me.sc = 'RZE1843058F02'
       and  me.value_f is null
      )  m
;

--zoeken naar number met punt zonder een VALUE_F !!!!
select m.sc, m.pg, m.pa, m.me, '#'||m.value_s||'#', m.value_f
--, case WHEN REGEXP_LIKE (m.value_s, '^-?\d+,\d+$')  THEN REGEXP_REPLACE (m.value_s, ',', '.' ) ELSE 'FOUT' end  expresult 
from ( select me.sc, me.pg, me.pa, me.me, me.value_s, me.value_f
       from utscmecell  me
       WHERE  REGEXP_LIKE(me.value_s, '^-?\d+\.\d+$') 
       --AND me.sc = 'RZE1843058F02'
       and  me.value_f is null
      )  m
;
--112.417    rows MET value_f is null
--12.226.667 rows MET value_f gevuld

--***********************************************
--***********************************************

--***********************************************
--***********************************************
-- UTSCMECELL-LIST
--***********************************************
--***********************************************

--***********************************************
--DEZE REGEXP WERKT GOED !! 
--***********************************************
--totaal aantal 
select count(*) from utscmecelllist;
-- 89.247.309   rows total

select count(*) from utscmecelllist where value_f is not null and value_s is null;
-- 0 rows
select count(*) from utscmecelllist where value_f is not null ;
-- 30.105.368   rows with a NUM-value

select count(*) from utscmecelllist where value_S is not null ;
-- 68.533.855   

--Hier zoeken we alleen naar strings met komma
select m.sc, m.pg, m.pa, m.me, m.cell, m.index_x, m.index_y, '#'||m.value_s||'#', m.value_f
, case WHEN REGEXP_LIKE (m.value_s, '^-?\d+,')  THEN REGEXP_REPLACE (m.value_s, ',', '.' ) ELSE 'FOUT' end  expresult 
from ( select me.sc, me.pg, me.pa, me.me,  me.cell, me.index_x, me.index_y, me.value_s, me.value_f
       from utscmecelllist  me
       WHERE   REGEXP_LIKE(me.value_s, '^-?\d+,\d+$')      --numerieke waarde (evt. beginnen met "-") en een komma bevat na numerieke waarde)
	   AND NOT REGEXP_LIKE(me.value_s, '^-?\d+,\d+,')     --niet een string met meerdere komma's
	   --AND NOT REGEXP_LIKE(me.value_s, '^-?\d+,\w+')     --niet een string met alfanumerieke waardes
       --AND me.sc = 'MOT1635051T02'
       and  me.value_f is null                            --geen numerieke waarde aanwezig...
       --and  me.value_f is NOT null                      --WEL numerieke waarde aanwezig...
      )  m
;
/*
STS1632045T01	Add to library	TC041B	TC041B	TC041B_results	1	9	#1,2,3-Benzenetriol (12.69 min)#		1.2.3-Benzenetriol (12.69 min)
JJA1628007T01	Advanced	TC041B	TC041B	TC041B_results	1	3	"#2,4-Di-tert-butylphenol (14.49 min)#"		"2.4-Di-tert-butylphenol (14.49 min)"
--
MOT1635051T02	Standard	TC040AB	TC040A	TC040A_polymer	0	1	#3,4 IR#		3.4 IR
MOT1635051T04	Standard	TC040AB	TC040A	TC040A_polymer	0	1	#3,4 IR#		3.4 IR
*/

--Hier zoeken we alleen naar STRING met punt + value_F !!
select m.sc, m.pg, m.pa, m.me, m.cell, m.index_x, m.index_y, '#'||m.value_s||'#', m.value_f
, case WHEN REGEXP_LIKE (m.value_s, '^-?\d+,')  THEN REGEXP_REPLACE (m.value_s, ',', '.' ) ELSE 'FOUT' end  expresult 
from ( select me.sc, me.pg, me.pa, me.me,  me.cell, me.index_x, me.index_y, me.value_s, me.value_f
       from utscmecelllist  me
       WHERE   REGEXP_LIKE(me.value_s, '^-?\d+\.\d+$')      --numerieke waarde (evt. beginnen met "-") en een komma bevat na numerieke waarde)
	   AND NOT REGEXP_LIKE(me.value_s, '^-?\d+:\d+$')     --niet een string met DUBBELE-PUNT
	   --AND NOT REGEXP_LIKE(me.value_s, '^-?\d+\.\d+\.')     --niet een string met meerdere punten
	   --AND NOT REGEXP_LIKE(me.value_s, '^-?\d+,\w+')     --niet een string met alfanumerieke waardes
       --AND me.sc = 'MOT1635051T02'
       and  me.value_f is null                            --geen numerieke waarde aanwezig...
      )  m
;

-- 89.247.309   rows total
-- 30.105.368   rows with a NUM-value (and a STRING-value)
-- 148.690      rows MET string met komma ZONDER value_f (is null)
-- 27.052       rows met STRING MET KOMMA MET value_f gevuld (gelijk aan string met komma)

--conclusie: INDIEN de waarde van CELLIST numeriek is hoort VALUE_F + VALUE_S gevuld te zijn !!!
--           Alle records met een NUM-value hebben ook een STRING-value.
--           De meeste STRING-values met NUM-value hebben een punt als decimaal-scheider.
--           Dat is in 30.105.368 gevallen zo, maar voor 148.690 (komma + geen value_F) + 27.052 (komma + wel value_f) NIET.
--           Om dit te herstellen zullen we value_S moeten gaan wijzigen door van komma een punt te maken.
--           En voor die situaties waarbij geen value_F aanwezig is, ook moeten vullen.



spool c:\temp\peter-mecell-decimal-komma.txt
set pages 9999
set linesize 300
--
select me.sc, me.pg, me.pa, me.me, me.cell, me.value_s, me.value_f, case WHEN REGEXP_LIKE (me.value_s, '*([0-9]),*([0-9])') THEN (REGEXP_REPLACE (me.value_s, ',', '.' )) ELSE 'ERROR' end  expresult 
from utscmecell  me
WHERE  me.value_f is null
and  REGEXP_LIKE (me.value_s, '*([0-9]),*([0-9])') 
and  REGEXP_INSTR(me.value_s, ',') > 0 
and  NOT REGEXP_LIKE (me.value_s, '^[A-Z]') 
;
spool off;




select count(*)
from utscmecell  me
WHERE  me.value_f is null
and  REGEXP_LIKE (me.value_s, '*([0-9]),*([0-9])') 
and  REGEXP_INSTR(me.value_s, ',') > 0 
and  NOT REGEXP_LIKE (me.value_s, '^[A-Z]') 
;
--73.203

select count(*)
from utscmecell  me
WHERE  me.value_f is null
and  REGEXP_LIKE (me.value_s, '*([0-9]),*([0-9])') 
and  REGEXP_INSTR(me.value_s, '.') > 0 
and  NOT REGEXP_LIKE (me.value_s, '^[A-Z]') 
;
--1.260.440


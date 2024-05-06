--FILE:  UNI00403P_GetRole

-* First determine user roles

/*
JOIN UP IN UVUPUS TAG uprof TO UP IN UVUP TAG prof AS J0
JOIN UP AND VERSION IN UVUPUS TO UP AND VERSION IN UVUPAU TAG usrgrp AS J1
JOIN LEFT_OUTER
	FILE UVUPUS AT uprof.US TO UNIQUE
	FILE UVUPUSPREF AT US TAG pref AS J2
 
	WHERE uprof.UP			EQ pref.UP;
	WHERE uprof.VERSION		EQ pref.VERSION;
	WHERE uprof.US			EQ pref.US;
	WHERE uprof.US_VERSION	EQ pref.US_VERSION;
	WHERE pref.PREF_NAME	EQ 'lab';
END
JOIN LEFT_OUTER
	FILE UVUPUS AT uprof.UP TO UNIQUE
	FILE UVUPPREF AT UP TAG dprf AS J3
 
	WHERE dprf.UP			EQ uprof.UP;
	WHERE dprf.VERSION		EQ uprof.VERSION;
	WHERE dprf.PREF_NAME	EQ 'lab';
END

TABLE FILE UVUPUS
SUM
	FST.prof.DESCRIPTION	AS ROLE
 
-*BY uprof.US
BY pref.PREF_VALUE			AS LAB
 
WHERE usrgrp.VALUE EQ '&USER_GROUP';
WHERE prof.UP EQ '&USER_PROFILE';
WHERE prof.VERSION_IS_CURRENT EQ '1';
WHERE (pref.PREF_VALUE EQ '&LAB')
   OR (pref.PREF_VALUE IS MISSING AND dprf.PREF_VALUE EQ '&LAB')
   OR ('&LAB' EQ 'NULL' AND pref.PREF_VALUE IS MISSING AND dprf.PREF_VALUE IS MISSING);
*/

SELECT prof.up
,      prof.description
--,      usrgrp.au
--,      usrgrp.value
,      pref.pref_name
,      pref.pref_value
--,      dprf.pref_name
--,      dprf.pref_value
FROM UTUP  prof
INNER JOIN UTUPUS uprof  ON uprof.up = prof.up
INNER JOIN UTUPAU usrgrp on ( usrgrp.up = uprof.up and usrgrp.version = uprof.version )
LEFT OUTER JOIN UTUPUSPREF pref on (   pref.up = uprof.up
                                   and pref.version    = uprof.version
								   and pref.us         = uprof.us
								   and pref.us_version = uprof.us_version
								   and pref.pref_name  = 'lab' 
								   )
LEFT OUTER JOIN UTUPPREF dprf on (   dprf.up = uprof.up
                                 and dprf.version = uprof.version
                                 and dprf.pref_name = 'lab' 								 
								 )
where prof.version_is_current = 1
and   usrgrp.VALUE = 'Execution' 
--and   uprof.us = 'PGO' 
and   pref.pref_value='PV RnD' 
ORDER BY prof.up


--uittesten query


/*
--PSC:
5	Physical lab		avUpClass	Execution	lab	PV RnD
7	Chemical lab		avUpClass	Execution	lab	PV RnD

--PGO:
5	Physical lab		avUpClass	Execution	lab	PV RnD
7	Chemical lab		avUpClass	Execution	lab	PV RnD
9	Certificate control	avUpClass	Execution	lab	PV RnD
10	Tyre testing std	avUpClass	Execution	lab	PV RnD
28	Proto PCT			avUpClass	Execution	lab	PV RnD
30	Proto Mixing		avUpClass	Execution	lab	PV RnD
*/


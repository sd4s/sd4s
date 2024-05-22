--WE HEBBEN 168 ACCESS-GROUPS !!!
--WE HEBBEN 95 USER-GROUPS !!!
--WE HEBBEN 274 PREFERENCES !!!


select up.up||'-'||up.description
from utup up
order by up.up
;


--SELECTIE INHOUD SPREADSHEET

SET SERVEROUTPUT ON
SET LINESIZE 999
DECLARE
CURSOR C_PREF IS
SELECT DISTINCT A.PREF_NAME
,               A.DESCRIPTION
FROM UTPREF A 
ORDER BY UPPER(A.PREF_NAME)
;
CURSOR C_UP IS
SELECT U.UP
,      U.DESCRIPTION
FROM UTUP U
ORDER BY U.UP
;
CURSOR C_UPP (P_PREF_NAME    IN VARCHAR2
             ,P_UP           IN NUMBER )
IS 
SELECT UPP.PREF_NAME
,      UPP.PREF_VALUE
,      UPP.UP
,      PREF.PREF_TP
,      PREF.APPLICABLE_OBJ
,      PREF.CATEGORY
FROM UTUPPREF UPP
,    UTPREF   PREF
WHERE UPP.PREF_NAME    = P_PREF_NAME
AND   UPP.UP           = P_UP
AND   PREF.PREF_NAME   = UPP.PREF_NAME
ORDER BY UPPER(UPP.PREF_NAME), UPP.UP, PREF.PREF_TP
;
L_STATEMENT      VARCHAR2(4000);
L_AANTAL_PREF_TP NUMBER;
BEGIN
  DBMS_OUTPUT.ENABLE(BUFFER_SIZE=>NULL);
  FOR R_PREF IN C_PREF
  LOOP
    L_STATEMENT := R_PREF.PREF_NAME||'-'||R_PREF.DESCRIPTION;
    FOR R_UP IN C_UP
	LOOP
	  L_STATEMENT := L_STATEMENT||';';
	  L_AANTAL_PREF_TP := 0;
	  FOR R_UPP IN C_UPP(R_PREF.PREF_NAME,  R_UP.UP)
	  LOOP
	    L_AANTAL_PREF_TP := L_AANTAL_PREF_TP + 1;
        IF L_AANTAL_PREF_TP > 1
		THEN
          L_STATEMENT := L_STATEMENT||'#'||R_UPP.PREF_TP||'-'||R_UPP.PREF_VALUE;
        ELSE
          L_STATEMENT := L_STATEMENT||R_UPP.PREF_TP||'-'||R_UPP.PREF_VALUE;
        END IF;
	  END LOOP;  --C-UPP
	END LOOP;  --C_UP
	--
	DBMS_OUTPUT.PUT_LINE(L_STATEMENT);
  END LOOP;  --C_PREF
END;
/


/*
--UTUP
1-Application management
2-Viewers
3-Preparation lab
4-Preparation lab mgt
5-Physical lab
6-Physical lab mgt
7-Chemical lab
8-Chemical lab mgt
9-Certificate control
10-Tyre testing std
11-Tyre testing std mgt
12-Tyre testing adv.
13-Tyre testing adv mgt
14-Process tech. VF
15-Process tech. VF mgt
16-Process tech. BV
17-Process tech. BV mgt
18-User Mgt
19-User Group
20-Purchasing
21-Obsolete users
22-Material lab mgt
23-QEA
24-Compounding
25-Reinforcement
26-Construction PCT
27-Research
28-Proto PCT
29-Proto Extrusion
30-Proto Mixing
31-Proto Tread
32-Proto Calander
33-Construction AT
34-Proto AT
35-Construction SM
36-FEA
37-FEA mgt
38-Tyre Order
39-BAM mgt
40-BAM
41-Raw material mgt
42-Construction TBR
43-Raw Matreials
44-Construction TWT
45-Raw Materials Chennai
46-Purchasing mgt
47-Tyre mounting std
*/






--WE HEBBEN 168 ACCESS-GROUPS !!!
--WE HEBBEN 95 USER-GROUPS !!!
--


select up.up||'-'||up.description
from utup up
order by up.up
;


--SELECTIE INHOUD SPREADSHEET

SET SERVEROUTPUT ON
SET LINESIZE 999
DECLARE
CURSOR C_APP IS
SELECT A.APPLIC
,      A.DESCRIPTION
FROM UTAPPLIC A 
ORDER BY A.APPLIC
;
CURSOR C_UP IS
SELECT U.UP
,      U.DESCRIPTION
,      U.DD
FROM UTUP U
ORDER BY U.UP
;
CURSOR C_UPA (P_APPLIC  IN VARCHAR2
             ,P_UP      IN NUMBER )
IS 
SELECT UPA.APPLIC
,      UPA.UP
,      UPA.TOPIC
FROM UTUPFA UPA
WHERE UPA.APPLIC   = P_APPLIC
AND   UPA.UP       = P_UP
;
L_STATEMENT VARCHAR2(4000);
L_AANTAL_TOPICS NUMBER;
BEGIN
  DBMS_OUTPUT.ENABLE(BUFFER_SIZE=>NULL);
  FOR R_APP IN C_APP
  LOOP
    L_STATEMENT := R_APP.APPLIC||'-'||R_APP.DESCRIPTION;
    FOR R_UP IN C_UP
	LOOP
	  L_STATEMENT := L_STATEMENT||';';
	  L_AANTAL_TOPICS := 0;
	  FOR R_UPA IN C_UPA(R_APP.APPLIC, R_UP.UP)
	  LOOP
	    L_AANTAL_TOPICS := L_AANTAL_TOPICS + 1;
        IF L_AANTAL_TOPICS > 1
		THEN
          L_STATEMENT := L_STATEMENT||'#'||R_UPA.TOPIC;
        ELSE
          L_STATEMENT := L_STATEMENT||R_UPA.TOPIC;
        END IF;
	  END LOOP;  --C-UPA
	END LOOP;  --C_UP
	--
	DBMS_OUTPUT.PUT_LINE(L_STATEMENT);
  END LOOP;  --C_APP
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






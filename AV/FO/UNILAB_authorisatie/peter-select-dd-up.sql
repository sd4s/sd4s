--WE HEBBEN 168 ACCESS-GROUPS !!!
--WE HEBBEN 95 USER-GROUPS !!!
--


select up.up||'-'||up.description
from utup up
order by up.up
;


--SELECTIE INHOUD SPREADSHEET

SET SERVEROUTPUT ON
DECLARE
CURSOR C_DD IS
SELECT U.DD
,      U.DESCRIPTION
FROM UTDD U 
ORDER BY TO_NUMBER(U.DD)
;
CURSOR C_UP IS
SELECT U.UP
,      U.DESCRIPTION
,      U.DD
FROM UTUP U
ORDER BY U.UP
;
L_STATEMENT VARCHAR2(4000);
BEGIN
  DBMS_OUTPUT.ENABLE(BUFFER_SIZE=>NULL);
  FOR R_DD IN C_DD
  LOOP
    L_STATEMENT := R_DD.DD||'-'||R_DD.DESCRIPTION;
    FOR R_UP IN C_UP
	LOOP
	  IF R_UP.DD = R_DD.DD
	  THEN
        L_STATEMENT := L_STATEMENT||';'||R_DD.DD;
      ELSE
        L_STATEMENT := L_STATEMENT||';';
      END IF;
	END LOOP;  --C_UP
	--
	DBMS_OUTPUT.PUT_LINE(L_STATEMENT);
  END LOOP;  --C_AD
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






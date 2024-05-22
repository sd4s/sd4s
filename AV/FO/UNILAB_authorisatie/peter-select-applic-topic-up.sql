--selectie van UP voor column-PROMPTS  1e rij...
select up.up||'-'||up.description
from utup up
order by up.up
;


--SELECTIE INHOUD SPREADSHEET

SET SERVEROUTPUT ON
SET LINESIZE 3000
DECLARE
CURSOR C_FA IS
SELECT DISTINCT A.APPLIC
,      A.TOPIC
,      A.TOPIC_DESCRIPTION
,      A.FA
FROM UTFA A
ORDER BY A.APPLIC, A.TOPIC
;
CURSOR C_UP IS
SELECT U.UP
,      U.DESCRIPTION
FROM UTUP U
ORDER BY U.UP
;
CURSOR C_UPF (P_APPLIC      IN VARCHAR2
             ,P_TOPIC       IN VARCHAR2
             ,P_UP          IN NUMBER )
IS 
SELECT UPF.APPLIC
,      UPF.TOPIC
,      UPF.FA
,      UPF.INHERIT_FA
FROM UTUPFA UPF
WHERE UPF.APPLIC   = P_APPLIC
AND   UPF.TOPIC    = P_TOPIC
AND   UPF.UP      = P_UP
ORDER BY UPF.APPLIC, UPF.TOPIC
;

L_STATEMENT    VARCHAR2(4000);
L_TELLER_FA    NUMBER;
BEGIN
  DBMS_OUTPUT.ENABLE(BUFFER_SIZE=>NULL);
  FOR R_FA IN C_FA
  LOOP
    L_STATEMENT := R_FA.APPLIC||'-'||R_FA.TOPIC||'-'||R_FA.TOPIC_DESCRIPTION;
    FOR R_UP IN C_UP
	LOOP
	  L_TELLER_FA := 0;
	  L_STATEMENT := L_STATEMENT||';';
	  FOR R_UPF IN C_UPF(R_FA.APPLIC, R_FA.TOPIC, R_UP.UP)
	  LOOP
	    L_TELLER_FA := L_TELLER_FA + 1;
        L_STATEMENT := L_STATEMENT||'UPFA:'||R_UPF.FA||'#IFA:'||R_UPF.INHERIT_FA;
	  END LOOP;  --C-UPF
	  IF L_TELLER_FA = 0
	  THEN
	    --INDIEN GEEN UTUPFA.FA dan nemen we DEFAULT uit UTAF.FA
        L_STATEMENT := L_STATEMENT||'#FA:'||R_FA.FA||'#IFA:1';
	  END IF;
	END LOOP;  --C_UP
	--
	DBMS_OUTPUT.PUT_LINE(L_STATEMENT);
  END LOOP;  --C_FA
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






--WE HEBBEN 168 ACCESS-GROUPS !!!
--WE HEBBEN 95 USER-GROUPS !!!
--

--vantevoren wel eerst een selectie uitvoeren op de USERGROUP-tabel om
--de KOLOM-HEADERS te selecteren, deze komen niet mee, met onderstaande constructie.
select ug.user_group_id||'-'||ug.description
from user_group ug
order by ug.user_group_id
;

--SELECTIE CONTENT
--Per USER(LOOP-RIJ), gaan we per USERGROUP-LOOP(=KOLOM) de gerelateerde ACCESSGROUPS/FRAMES(=CELL) ophalen.
SET SERVEROUTPUT ON
DECLARE
--selectie alle USERS
CURSOR C_USR 
IS
SELECT U.USER_ID
,      U.FORENAME||' '||U.LAST_NAME  NAAM
--,      U.PROD_ACCESS
FROM APPLICATION_USER U 
--where rownum < 10
ORDER BY U.USER_ID
;
--selectie alle UG
CURSOR C_UG 
IS
SELECT U.USER_GROUP_ID
,      U.DESCRIPTION
FROM USER_GROUP U
ORDER BY U.USER_GROUP_ID
;
--selectie alle USER-GROUPS voor USER
CURSOR C_UGL (P_USR  IN VARCHAR2
             ,P_UG  IN NUMBER )
IS 
SELECT UGL.USER_ID
,      UGL.USER_GROUP_ID
FROM USER_GROUP_LIST UGL
WHERE UGL.USER_ID       = P_USR
AND   UGL.USER_GROUP_ID = P_UG
;
--selectie alle AG binnen UG (AG kunnen wel/niet aan FRAMES gerelateerd zijn, deze willen we wel zien)
CURSOR C_AG (P_UG IN NUMBER) 
IS
SELECT A.ACCESS_GROUP
,      A.DESCRIPTION
,      UAG.USER_GROUP_ID
FROM ACCESS_GROUP A 
,    USER_ACCESS_GROUP UAG
WHERE A.ACCESS_GROUP = UAG.ACCESS_GROUP
AND   UAG.USER_GROUP_ID = P_UG
ORDER BY A.ACCESS_GROUP
;
--selectie FRAMES binnen AG
CURSOR C_F (P_AG  IN NUMBER )
IS 
SELECT count(*) aantal_frames
FROM FRAME_HEADER F
WHERE F.ACCESS_GROUP = P_AG
and   F.STATUS=2        --current
;
L_AANTAL_UG       NUMBER;
L_STATEMENT_BASE  VARCHAR2(32000);
L_STATEMENT_TOT   VARCHAR2(32000);
BEGIN
  DBMS_OUTPUT.ENABLE(BUFFER_SIZE=>NULL);
  FOR R_USR IN C_USR
  LOOP
    L_AANTAL_UG := 0;
    --iedere rij begin met USER
    L_STATEMENT_BASE := R_USR.USER_ID||'-'||R_USR.NAAM;
	--DBMS_OUTPUT.PUT_LINE(L_STATEMENT_BASE);
	--iedere kolom aparte UG
    FOR R_UG IN C_UG
	LOOP
	  --bouw per KOLOM=USERGROUP de CELL-CONTENT ( ACCESSGROUP/FRAMES) op
	  L_STATEMENT_BASE := L_STATEMENT_BASE||';';
	  --L_STATEMENT_TOT  := L_STATEMENT_BASE;
	  --INDIEN RELATIE-AANWEZIG TUSSEN USER + USERGROUP DAN EXTRA INFO BEPALEN
	  FOR R_UGL IN C_UGL(R_USR.USER_ID, R_UG.USER_GROUP_ID)
	  LOOP
        L_AANTAL_UG := L_AANTAL_UG + 1;
        --per USERGROUP kijken welke ACCESS-GROUPS voorkomen
        FOR R_AG IN C_AG (R_UGL.USER_GROUP_ID)
        LOOP
		  --per rij alle accessgroups binnen 1 cel opnemen
          --L_STATEMENT_BASE := L_STATEMENT_BASE||'@AG:'||R_AG.ACCESS_GROUP||'-'||substr(R_AG.DESCRIPTION,1,20);
          L_STATEMENT_BASE := L_STATEMENT_BASE||'@AG:'||R_AG.ACCESS_GROUP;
          FOR R_F IN C_F(R_AG.ACCESS_GROUP)
          LOOP
            --er kunnen meerdere frames per ACCESS-GROUP voorkomen. Ook deze binnen 1 cel opnemen
            L_STATEMENT_BASE := L_STATEMENT_BASE||'#'||R_F.AANTAL_FRAMES;
          END LOOP; --C-F
          --
          --DBMS_OUTPUT.PUT_LINE(L_STATEMENT_BASE);
        END LOOP;  --C_AG
	    --
	  END LOOP;  --C_UGL
	  --
	END LOOP;  --C_UG
	--
	L_STATEMENT_BASE := L_STATEMENT_BASE ||';'||L_AANTAL_UG;
	DBMS_OUTPUT.PUT_LINE(L_STATEMENT_BASE);
  END LOOP;  --C_USR
END;
/


PROMPT LET OP: LINESIZE IS NIET GROOT GENOEG VANUIT SQL*DEVELOPER.
PROMPT         DE OUTPUT-FILE DUS HANDMATIG VOOR EEN PAAR GEBRUIKERS MET EEN HELEBOEL USERGROUPS EVEN HANDMATIG IN 
PROMPT         NOTEPAD++ WEER OP 1 REGEL ZETTEN VOORDAT JE BESTAND IN EXCEL INLEEST. 
PROMPT

prompt einde script





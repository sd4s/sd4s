--WE HEBBEN 168 ACCESS-GROUPS !!!
--WE HEBBEN 95 USER-GROUPS !!!
--

--vantevoren wel eerst een selectie uitvoeren op de FRAME_HEADER-tabel om
--de KOLOM-HEADERS te selecteren, deze komen niet mee, met onderstaande constructie.
--In de FRAME_HEADER-tabel komen ook meerdere revisies bij een frame voor. 
select distinct frame_no
,               description
from frame_header
WHERE status = 2   --current
order by frame_no
;



SET SERVEROUTPUT ON
DECLARE
CURSOR C_AG IS
SELECT A.ACCESS_GROUP
,      A.DESCRIPTION
FROM ACCESS_GROUP A 
ORDER BY A.ACCESS_GROUP
;
CURSOR C_FR IS
SELECT distinct FR.FRAME_NO
,               FR.DESCRIPTION
FROM FRAME_HEADER FR
where FR.status=2     --current
ORDER BY FR.FRAME_NO
;
CURSOR C_F (P_AG  IN NUMBER
           ,P_FR  IN VARCHAR2 )
IS SELECT F.REVISION    revstat
FROM FRAME_HEADER F
WHERE F.ACCESS_GROUP = P_AG
AND   F.FRAME_NO = P_FR
and   F.STATUS=2        --current
;
L_STATEMENT VARCHAR2(4000);
BEGIN
  FOR R_AG IN C_AG 
  LOOP
    L_STATEMENT := R_AG.ACCESS_GROUP||';'||R_AG.DESCRIPTION;
    FOR R_FR IN C_FR
	LOOP
      --tussen verschillende kolommen/frames een puntkomma als scheidingsteken!
	  L_STATEMENT := L_STATEMENT||';';
	  FOR R_F IN C_F(R_AG.ACCESS_GROUP, R_FR.FRAME_NO)
	  LOOP
	    --er komen meerdere revisies voor binnen een frame, hier komma als scheidingsteken!
	    L_STATEMENT := L_STATEMENT||R_F.revstat;
	  END LOOP;
	END LOOP;  --C_UG
	--
	DBMS_OUTPUT.PUT_LINE(L_STATEMENT);
  END LOOP;  --C_AG
END;
/







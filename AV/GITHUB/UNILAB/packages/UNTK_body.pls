create or replace PACKAGE BODY        untk AS
--------------------------------------------------------------------------------
--  PROJECT : Vredestein Enschede
-------------------------------------------------------------------------------
--  PACKAGE : untk
-- ABSTRACT :
--   WRITER : Rody Sparenberg
--     DATE :
--   TARGET : Oracle 10.2.0 / Unilab 6.3
--  VERSION : av3.0
--------------------------------------------------------------------------------
--  REMARKS :
--------------------------------------------------------------------------------
--  CHANGES :
--
--  When      | Who       | What
--============|===========|=====================================================
-- 15/10/2008 | HVB       | Added function "userID"
-- 03/03/2011 | RS        | Upgrade V6.3
--                        | Changed SYSDATE INTO CURRENT_TIMESTAMP
-- 29/05/2013 | RS        | Added userLab
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := 'untk';
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- functions- and/or procedures-declarations
--------------------------------------------------------------------------------

---------------------------------------------------------------------
-- ActualWeek (based on utweeknr, format YYYYWW based on the preceding monday to avoid problems on year switches)
FUNCTION  ActualWeek
RETURN VARCHAR2 IS

CURSOR l_utweeknr_cursor IS
SELECT a.*
FROM utweeknr a
WHERE a.day_of_year = (SELECT b.day_of_year - b.day_of_week + 1
                     FROM utweeknr b
                     WHERE b.day_of_year =TRUNC(CURRENT_TIMESTAMP, 'DD'));

l_utweeknr_rec    l_utweeknr_cursor%ROWTYPE;

BEGIN

   OPEN l_utweeknr_cursor;
   FETCH l_utweeknr_cursor
   INTO l_utweeknr_rec;
   CLOSE l_utweeknr_cursor;

   RETURN(TO_CHAR(l_utweeknr_rec.day_of_year, 'YYYY')||TO_CHAR(l_utweeknr_rec.week_nr));

EXCEPTION
WHEN OTHERS THEN
   IF l_utweeknr_cursor%ISOPEN THEN
      CLOSE l_utweeknr_cursor;
   END IF;
   RETURN(NULL);
END ActualWeek;

---------------------------------------------------------------------
-- ActualShift
FUNCTION  ActualShift
RETURN VARCHAR2 IS

l_hour      INTEGER;
l_prod_day  VARCHAR2(40);
l_shift     VARCHAR2(40);
l_current_timestamp   TIMESTAMP WITH TIME ZONE;

BEGIN

   --Potential problem explicitely ignored in these 2 functions:
   --when actual shift and prod_day are called before and after 6
   -- example : at 5:59:59 ActualProdDay returns the day before
   --           at 6:00:00 ACtualShift returning 1
   --
   l_current_timestamp := CURRENT_TIMESTAMP;
   l_hour := TO_NUMBER(TO_CHAR(l_current_timestamp,'HH24'));
   l_prod_day := TO_CHAR(l_current_timestamp,'YYYYMMDD');
   IF l_hour >= 6 AND l_hour < 14 THEN
      l_shift := '1';
   ELSIF l_hour >= 14 AND l_hour < 22 THEN
      l_shift := '2';
   ELSE
      IF l_hour < 6 THEN
         l_prod_day := TO_CHAR(l_current_timestamp-1,'YYYYMMDD');
      END IF;
      l_shift := '3';
   END IF;
   RETURN(l_shift);

END ActualShift;

-- ActualProductionDay
--depends of the actual shift
FUNCTION  ActualProductionDay
RETURN VARCHAR2 IS

l_hour      INTEGER;
l_prod_day  VARCHAR2(40);
l_shift     VARCHAR2(40);
l_current_timestamp   TIMESTAMP WITH TIME ZONE;

BEGIN

   --Potential problem explicitely ignored in these 2 functions:
   --when actual shift and prod_day are called before and after 6
   -- example : at 5:59:59 ActualProdDay returns the day before
   --           at 6:00:00 ACtualShift returning 1
   --
   l_current_timestamp := CURRENT_TIMESTAMP;
   l_hour := TO_NUMBER(TO_CHAR(l_current_timestamp,'HH24'));
   l_prod_day := TO_CHAR(l_current_timestamp,'YYYYMMDD');
   IF l_hour >= 6 AND l_hour < 14 THEN
      l_shift := '1';
   ELSIF l_hour >= 14 AND l_hour < 22 THEN
      l_shift := '2';
   ELSE
      IF l_hour < 6 THEN
         l_prod_day := TO_CHAR(l_current_timestamp-1,'YYYYMMDD');
      END IF;
      l_shift := '3';
   END IF;
   RETURN(l_prod_day);

END ActualProductionDay;

---------------------------------------------------------------------
-- FirstDayOfMonth (format YYYYMMDD)
FUNCTION  FirstDayOfMonth
RETURN VARCHAR2 IS

BEGIN
   RETURN(TO_CHAR(TRUNC(CURRENT_TIMESTAMP,'MM'),'YYYYMMDD'));
END FirstDayOfMonth;
---------------------------------------------------------------------
-- Day will return the name of the day, must be always in English independently of any setting.
FUNCTION  Day
RETURN VARCHAR2 IS

BEGIN
   RETURN(TO_CHAR(CURRENT_TIMESTAMP,'Day','NLS_DATE_LANGUAGE=American'));
END Day;
---------------------------------------------------------------------
-- Month will return the full name of the month (based on Oracle Format model: MONTH) , must be always in English independently of any setting.
FUNCTION  Month
RETURN VARCHAR2 IS

BEGIN
   RETURN(TO_CHAR(CURRENT_TIMESTAMP,'MONTH','NLS_DATE_LANGUAGE=American'));
END Month;
---------------------------------------------------------------------
-- Mon will return the short name of the month (based on Oracle Format model: MON), must be always in English independently of any setting.
FUNCTION  Mon
RETURN VARCHAR2 IS

BEGIN
   RETURN(TO_CHAR(CURRENT_TIMESTAMP,'MON','NLS_DATE_LANGUAGE=American'));
END Mon;
---------------------------------------------------------------------
-- ClientId : based on the client id in Unilab.ini
FUNCTION  ClientId
RETURN VARCHAR2 IS

BEGIN
   RETURN(SUBSTR(NVL(UNAPIGEN.P_CLIENT_ID,'NoClientId'),1,40));
END ClientId;
---------------------------------------------------------------------
-- ApplicName
FUNCTION  ApplicName
RETURN VARCHAR2 IS
BEGIN
   RETURN(SUBSTR(UNAPIGEN.P_APPLIC_NAME,1,40));
END ApplicName;
---------------------------------------------------------------------
-- TERMINAL based on USERENV('TERMINAL')
FUNCTION  Terminal
RETURN VARCHAR2 IS
l_terminal VARCHAR2(255);
BEGIN
   l_terminal := USERENV('TERMINAL');
   RETURN(SUBSTR(l_terminal,1,40));
END Terminal;
---------------------------------------------------------------------
--The 2 following functions will illustrate how to make one default value dependent of the other by using the
-- City (returns Valkenburg by default when not defined on user level)
-- Country (returns country corresponding to the city, utad.country when city not set in task, The Netherlands by default)
-- This is in fact a trivial example explaining how to use the task buffer
-- In the function Country, the country corresponding to the city is searched.
--
FUNCTION  City
RETURN VARCHAR2 IS
l_city   VARCHAR2(40);
CURSOR l_city_cursor(a_ad IN VARCHAR2) IS
   SELECT city
   FROM utad
   WHERE ad = a_ad;

BEGIN
   l_city := NULL;
   OPEN l_city_cursor(UNAPIGEN.P_USER);
   FETCH l_city_cursor
   INTO l_city;
   CLOSE l_city_cursor;
   IF l_city IS NULL THEN
      l_city := 'Valkenburg';
   END IF;
   RETURN(l_city);

EXCEPTION
WHEN OTHERS THEN
   IF l_city_cursor%ISOPEN THEN
      CLOSE l_city_cursor;
   END IF;
   RETURN('Valkenburg');
END City;

FUNCTION  Country
RETURN VARCHAR2 IS

l_row          INTEGER;
l_city_found   BOOLEAN;
l_country      VARCHAR2(2000);

CURSOR l_country_cursor(a_city IN VARCHAR2) IS
   SELECT country
   FROM utad
   WHERE city = a_city;

BEGIN
   --Search the task buffer to see if the City has been set
   --If set already return the corresponding country
   l_city_found := FALSE;
   l_row := 1;
   LOOP
      IF UPPER(UNAPIUPP.P_TK_TAB(l_row).col_id)='CITY' THEN
         l_city_found := TRUE;

         EXIT;
      END IF;
      l_row := l_row +1;
      EXIT WHEN l_row > UNAPIUPP.P_TK_NR_OF_ROWS;
   END LOOP;

   l_country := NULL;
   IF l_city_found THEN
      OPEN l_country_cursor(UNAPIUPP.P_TK_TAB(l_row).def_val);
      FETCH l_country_cursor
      INTO l_country;
      CLOSE l_country_cursor;
   END IF;

   IF l_country IS NULL THEN
      l_country := 'The Netherlands';
   END IF;
   RETURN(l_country);

EXCEPTION
WHEN OTHERS THEN
   IF l_country_cursor%ISOPEN THEN
      CLOSE l_country_cursor;
   END IF;
   RETURN('The Netherlands');
END Country;
---------------------------------------------------------------------

-- userID : userID
FUNCTION  userID
RETURN VARCHAR2 IS

BEGIN
   RETURN(SUBSTR(UNAPIGEN.P_USER,1,40));
END userID;
---------------------------------------------------------------------
FUNCTION  userLab
RETURN VARCHAR2 IS
lvs_lab VARCHAR2(20);
BEGIN

   BEGIN
   select pref_value
     into lvs_lab
     from utupuspref a, utad b
    where a.pref_name = 'lab' and a.up = b.def_up and a.us = b.ad
      and a.us = UNAPIGEN.P_USER;
   EXCEPTION
   WHEN OTHERS THEN
      lvs_lab := '-';
   END;

   RETURN(lvs_lab);
END userLab;

FUNCTION GetVersion
  RETURN VARCHAR2
IS
BEGIN
  RETURN('06.07.00.00_13.00');
EXCEPTION
  WHEN OTHERS THEN
	 RETURN (NULL);
END GetVersion;


END untk;
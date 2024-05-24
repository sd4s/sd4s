create or replace PACKAGE
-- Unilab 4.0 Package
-- $Revision: 1 $
-- $Date: 10/04/01 18:00 $
              untk AS

--package functions called for tilde substitution in task default values
--example : default_vallue for a group key in a task is ~=UNTK.ActualWeek~
--          The function UNTK.ActualWeek will be called and will return the default value that will be used for
--          that task.
--          It allows to make task default value context specific : based on user, user profile, date, session, ...
--
--List fo functions
--1. ActualWeek
--2. ActualShift
--3. ActualProductionDay
--4. FirstDayOfMonth
--5. Day
--6. Month
--7. Mon
--8. ClientId
--9. ApplicName
--10. Terminal
--11. City
--12. Country
--13. userID (2008-10-15 by HVB)
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

FUNCTION  ActualWeek
RETURN VARCHAR2;

FUNCTION  ActualShift
RETURN VARCHAR2;

FUNCTION  ActualProductionDay
RETURN VARCHAR2;

FUNCTION  FirstDayOfMonth
RETURN VARCHAR2;

FUNCTION  Day
RETURN VARCHAR2;

FUNCTION  Month
RETURN VARCHAR2;

FUNCTION  Mon
RETURN VARCHAR2;

FUNCTION  ClientId
RETURN VARCHAR2;

FUNCTION  ApplicName
RETURN VARCHAR2;

FUNCTION  Terminal
RETURN VARCHAR2;

FUNCTION  City
RETURN VARCHAR2;

FUNCTION  Country
RETURN VARCHAR2;

FUNCTION  userID
RETURN VARCHAR2;

FUNCTION  userLab
RETURN VARCHAR2;

FUNCTION GetVersion
RETURN VARCHAR2;

END untk;

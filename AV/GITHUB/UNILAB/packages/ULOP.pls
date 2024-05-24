create or replace PACKAGE ulop IS

-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION HandleCreateSample
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandleSaveSample
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandleSaveScParameterGroup
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandleSaveScParameter
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandleSaveScPaResult
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandleSaveScMethod
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandleSaveScInfoCard
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandleSaveScInfoField
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandleSaveScGroupKey
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandlePlanSample
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

END ulop;
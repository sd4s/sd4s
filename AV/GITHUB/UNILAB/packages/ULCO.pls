create or replace PACKAGE ulco IS

-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION HandleSaveSampleType
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandleSaveStParameterProfile
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandleSaveStGroupkey
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandleSaveGroupkeySt
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandleSaveGroupkeySc
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandleSaveGroupkeyMe
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandleSaveParameterProfile
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandleSavePpParameter
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandleSavePpParameterSpecs
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandleSaveParameter
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandleSavePrMethod
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandleSaveMethod
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandleSaveRequestType
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandleSaveRtSampleType
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandleSaveRtParameterProfile
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandleSaveRtInfoProfile
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandleDeleteGKStStructures
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandleCreateGKStStructures
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandleDeleteGKScStructures
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandleCreateGKScStructures
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandleDeleteGKMeStructures
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandleCreateGKMeStructures
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandleSaveUserProfile
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandleSaveAddress
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandleSaveUpUser
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandleSaveTask
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandleSaveObjectAttribute
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandleSaveUsedObjectAttribute
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandleChangeObjectStatus
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandleChangeObjectLifeCycle
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandleSaveObjectAccess
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandleBeginTransaction
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandleEndTransaction
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandleSynchrEndTransaction
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandleSaveInfoProfile
(a_curr_line     IN    utlkin%ROWTYPE,
a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandleSaveIpInfoField
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandleSaveStInfoProfile
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandleSaveAttribute
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandleSaveAttributeSql
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandleSaveAttributeValue
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandleSaveInfoField
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandleSaveInfoFieldSql
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandleSaveInfoFieldValue
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandleSaveMtCell
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandleSavePpAttribute
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandleSavePpPrAttribute
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandleChangePpStatus
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandleChangePpLifeCycle
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

FUNCTION HandleSavePpAccess
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER;

END ulco;
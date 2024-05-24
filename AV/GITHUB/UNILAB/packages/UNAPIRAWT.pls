PACKAGE unapirawt AS






FUNCTION GETVERSION
   RETURN VARCHAR2;

FUNCTION REMOVEWTFROMARCHIVE
(A_WT IN VARCHAR2, A_VERSION IN VARCHAR2)
RETURN NUMBER;

FUNCTION COPYWTTOARCHDB
(A_WT IN VARCHAR2, A_VERSION IN VARCHAR2, A_IGNORE_DUP_VAL_ON_INDEX BOOLEAN)
RETURN NUMBER;

FUNCTION COPYWTFROMARCHDB
(A_WT IN VARCHAR2, A_VERSION IN VARCHAR2, A_IGNORE_DUP_VAL_ON_INDEX BOOLEAN)
RETURN NUMBER;

FUNCTION ARCHIVEWTTODB
(A_WT IN VARCHAR2, A_VERSION IN VARCHAR2)
RETURN NUMBER;

FUNCTION REMOVEWTFROMDB
(A_WT IN VARCHAR2, A_VERSION IN VARCHAR2)
RETURN NUMBER;

FUNCTION ARCHIVEWTTOFILE
(A_WT IN VARCHAR2, A_VERSION IN VARCHAR2)
RETURN NUMBER;

FUNCTION RESTOREWTFROMDB
(A_WT IN VARCHAR2, A_VERSION IN VARCHAR2)
RETURN NUMBER;

END UNAPIRAWT;
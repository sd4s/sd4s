PACKAGE unapirart AS






FUNCTION GETVERSION
   RETURN VARCHAR2;

FUNCTION REMOVERTFROMARCHIVE
(A_RT IN VARCHAR2, A_VERSION IN VARCHAR2)
RETURN NUMBER;

FUNCTION COPYRTTOARCHDB
(A_RT IN VARCHAR2, A_VERSION IN VARCHAR2, A_IGNORE_DUP_VAL_ON_INDEX BOOLEAN)
RETURN NUMBER;

FUNCTION COPYRTFROMARCHDB
(A_RT IN VARCHAR2, A_VERSION IN VARCHAR2, A_IGNORE_DUP_VAL_ON_INDEX BOOLEAN)
RETURN NUMBER;

FUNCTION ARCHIVERTTODB
(A_RT IN VARCHAR2, A_VERSION IN VARCHAR2)
RETURN NUMBER;

FUNCTION REMOVERTFROMDB
(A_RT IN VARCHAR2, A_VERSION IN VARCHAR2)
RETURN NUMBER;

FUNCTION ARCHIVERTTOFILE
(A_RT IN VARCHAR2, A_VERSION IN VARCHAR2)
RETURN NUMBER;

FUNCTION RESTORERTFROMDB
(A_RT IN VARCHAR2, A_VERSION IN VARCHAR2)
RETURN NUMBER;

END UNAPIRART;
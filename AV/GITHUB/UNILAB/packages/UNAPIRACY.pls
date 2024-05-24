PACKAGE unapiracy AS






FUNCTION GETVERSION
   RETURN VARCHAR2;

FUNCTION REMOVECYFROMARCHIVE
(A_CY IN VARCHAR2, A_VERSION IN VARCHAR2)
RETURN NUMBER;

FUNCTION COPYCYTOARCHDB
(A_CY IN VARCHAR2, A_VERSION IN VARCHAR2, A_IGNORE_DUP_VAL_ON_INDEX BOOLEAN)
RETURN NUMBER;

FUNCTION COPYCYFROMARCHDB
(A_CY IN VARCHAR2, A_VERSION IN VARCHAR2, A_IGNORE_DUP_VAL_ON_INDEX BOOLEAN)
RETURN NUMBER;

FUNCTION ARCHIVECYTODB
(A_CY IN VARCHAR2, A_VERSION IN VARCHAR2)
RETURN NUMBER;

FUNCTION REMOVECYFROMDB
(A_CY IN VARCHAR2, A_VERSION IN VARCHAR2)
RETURN NUMBER;

FUNCTION ARCHIVECYTOFILE
(A_CY IN VARCHAR2, A_VERSION IN VARCHAR2)
RETURN NUMBER;

FUNCTION RESTORECYFROMDB
(A_CY IN VARCHAR2, A_VERSION IN VARCHAR2)
RETURN NUMBER;

END UNAPIRACY;
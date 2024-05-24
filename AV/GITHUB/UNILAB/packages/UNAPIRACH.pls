PACKAGE unapirach AS






FUNCTION GETVERSION
   RETURN VARCHAR2;

FUNCTION REMOVECHFROMARCHIVE
(A_CH IN VARCHAR2)
RETURN NUMBER;

FUNCTION COPYCHTOARCHDB
(A_CH IN VARCHAR2, A_IGNORE_DUP_VAL_ON_INDEX BOOLEAN)
RETURN NUMBER;

FUNCTION COPYCHFROMARCHDB
(A_CH IN VARCHAR2, A_IGNORE_DUP_VAL_ON_INDEX BOOLEAN)
RETURN NUMBER;

FUNCTION ARCHIVECHTODB
(A_CH IN VARCHAR2)
RETURN NUMBER;

FUNCTION REMOVECHFROMDB
(A_CH IN VARCHAR2)
RETURN NUMBER;

FUNCTION ARCHIVECHTOFILE
(A_CH IN VARCHAR2)
RETURN NUMBER;

FUNCTION RESTORECHFROMDB
(A_CH IN VARCHAR2)
RETURN NUMBER;

END UNAPIRACH;
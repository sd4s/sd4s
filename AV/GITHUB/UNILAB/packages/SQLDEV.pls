create or replace PACKAGE SqlDev
IS

    FUNCTION Gauge(
        anValue IN NUMBER,
        anMin   IN NUMBER DEFAULT 0,
        anMax   IN NUMBER DEFAULT 100,
        anLow   IN NUMBER DEFAULT 65,
        anHigh  IN NUMBER DEFAULT 90
    )
    RETURN VARCHAR2;


    FUNCTION Link(
        asOwner IN VARCHAR2,
        asType  IN VARCHAR2,
        asName  IN VARCHAR2,
        asText  IN VARCHAR2 DEFAULT NULL,
        anLine  IN VARCHAR2 DEFAULT 0
    )
    RETURN VARCHAR2;
    
    FUNCTION ExtractLinkText(
        asLink IN VARCHAR2
    )
    RETURN VARCHAR2;

END;
 
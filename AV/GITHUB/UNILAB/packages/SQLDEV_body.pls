create or replace PACKAGE BODY SqlDev
IS

    FUNCTION Gauge (
        anValue IN NUMBER,
        anMin   IN NUMBER DEFAULT 0,
        anMax   IN NUMBER DEFAULT 100,
        anLow   IN NUMBER DEFAULT 65,
        anHigh  IN NUMBER DEFAULT 90
    )
    RETURN VARCHAR2
    AS
        cnDefLow  NUMBER := 65;
        cnDefHigh NUMBER := 90;

        lnDelta   NUMBER;
        lnDispMin NUMBER;
        lnDispMax NUMBER;
        lnDispVal NUMBER;
    BEGIN
        IF anHigh - anLow = 0 THEN
            lnDelta := 1;
        ELSE
            lnDelta := (cnDefHigh - cnDefLow) / (anHigh - anLow);
        END IF;
        lnDispMin := cnDefLow - (anLow - anMin) * lnDelta;
        lnDispMax := cnDefLow - (anLow - anMax) * lnDelta;
        lnDispVal := lnDelta * (anValue - anLow) + cnDefLow;
        RETURN 'SQLDEV:GAUGE:'
            || lnDispMin || ':'
            || lnDispMax || ':'
            || lnDispMin || ':'
            || lnDispMin || ':'
            || lnDispVal;
    END;


    FUNCTION Link(
        asOwner IN VARCHAR2,
        asType  IN VARCHAR2,
        asName  IN VARCHAR2,
        asText  IN VARCHAR2 DEFAULT NULL,
        anLine  IN VARCHAR2 DEFAULT 0
    )
    RETURN VARCHAR2
    AS
    BEGIN
        RETURN 'SQLDEV:LINK:'
            || asOwner || ':'
            || asType  || ':'
            || asName  || ':'
            || (anLine + 1) || ':'
            || '0' || ':'
            || NVL(asText, asName) || ':'
            || 'oracle.dbtools.raptor.controls.grid.DefaultDrillLink';
    END;
    
    FUNCTION ExtractLinkText(
        asLink IN VARCHAR2
    )
    RETURN VARCHAR2
    AS
    BEGIN
        RETURN REGEXP_REPLACE(asLink, '^SQLDEV:LINK.*:([^:]*):[^:]*$', '\1');
    END;

END;
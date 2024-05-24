--------------------------------------------------------
--  File created - dinsdag-oktober-27-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure APPLYTEMPLATE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UNILAB"."APPLYTEMPLATE" (
    asSt      VARCHAR2
) AS
    lsVersion       VARCHAR2(20);
    lsRevision      VARCHAR2(20);
    lsClientID      VARCHAR2(20);
    lsUS            VARCHAR2(20);
    lsApplic        VARCHAR2(8);
    lsNumericChars  VARCHAR2(2);
    lsDateFormat    VARCHAR2(255);
    lnUP            NUMBER;
    lsUP            VARCHAR2(40);
    lsLanguage      VARCHAR2(20);
    lsTk            VARCHAR2(20);
    lnRetVal        NUMBER;
BEGIN
    BEGIN
        SELECT version
        INTO lsVersion
        FROM utst
        WHERE st = asSt
        AND version = (SELECT MAX(version) FROM utst WHERE st = asSt)
        AND ss = 'BL';
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        unApiGen.LogError('ApplyTemplate', 'Latest version of <' || asSt || '> is not Blocked');
        RETURN;
    END;
    IF lsVersion NOT LIKE '%.00' THEN
        unApiGen.LogError('ApplyTemplate', '<' || asSt || '[' || lsVersion ||  ']> is not a major version');
        RETURN;
    END IF;

    lsRevision := apaoAction.ConvertUnilab2Interspec(lsVersion);
    
    SELECT COUNT(*)
    INTO lnRetVal
    FROM specification_header@interspec spec
    INNER JOIN status@interspec status ON status.status = spec.status
    WHERE spec.part_no = asSt
    AND spec.revision = lsRevision
    AND status.status_type = 'CURRENT';

    IF lnRetVal = 0 THEN
        unApiGen.LogError('ApplyTemplate', '<' || asSt || '[' || lsRevision ||  ']> is not a Current specification in Interspec');
        RETURN;
    END IF;

    lsClientID := 'JOB';
    lsUS := 'UNILAB';
    lsApplic := 'Database';
    lsNumericChars := '.,';
    lsDateFormat := 'DDfx/fxMM/RR HH24fx:fxMI:SS';

    lnRetVal := unApiGen.SetConnection(
        a_Client_ID => lsClientID,
        a_US => lsUS,
        a_Applic => lsApplic,
        a_Numeric_Characters => lsNumericChars,
        a_Date_Format => lsDateFormat,
        a_UP => lnUP,
        a_User_Profile => lsUP,
        a_Language => lsLanguage,
        a_TK => lsTK
    );
    IF lnRetVal <> unApiGen.DbErr_Success THEN
        unApiGen.LogError('ApplyTemplate', 'Could not set connection');
        RETURN;
    END IF;

    lnRetVal := apaoAction.StApplyTemplate(
        avs_st => asSt,
        avs_st_version => lsVersion
    );
    IF lnRetVal <> unApiGen.DbErr_Success THEN
        unApiGen.LogError('ApplyTemplate', 'Error applying template for <' || asSt || '[' || lsVersion ||  ']>');
        RETURN;
    END IF;
END;

/

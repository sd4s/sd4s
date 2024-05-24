--------------------------------------------------------
--  File created - dinsdag-oktober-27-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Function TO_NUMBER_INVARIANT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UNILAB"."TO_NUMBER_INVARIANT" (
    value IN VARCHAR2
)
RETURN NUMBER
AS
    lsNormalized VARCHAR2(32767);
BEGIN
    lsNormalized := REPLACE(TRIM(value), ',', '.');
    RETURN TO_NUMBER(
        lsNormalized,
        TRANSLATE(lsNormalized, '0123456789.', '9999999999D'),
        'nls_numeric_characters=''.,'''
    );
END;

/

--------------------------------------------------------
--  File created - dinsdag-oktober-27-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Function FORMATHASH
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UNILAB"."FORMATHASH" (
  a_hash   IN NUMBER,
  a_format IN VARCHAR2 DEFAULT 'BASE64'
) RETURN VARCHAR2
DETERMINISTIC
AS
BEGIN
    IF a_hash IS NULL THEN
        RETURN NULL;
    END IF;
    CASE UPPER(a_format)
        WHEN 'BASE64' THEN
            RETURN TRIM(TRAILING '=' FROM utl_raw.cast_to_varchar2(
                utl_encode.base64_encode(TO_CHAR(a_hash, 'FM0XXXXXXX'))
            ));
        WHEN 'HEX' THEN
            RETURN TO_CHAR(a_hash, 'FM0XXXXXXX');
    END CASE;
END FormatHash;

/

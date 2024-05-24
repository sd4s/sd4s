--------------------------------------------------------
--  File created - dinsdag-oktober-27-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Function PARSEHASH
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UNILAB"."PARSEHASH" (
  a_hash   IN VARCHAR2,
  a_format IN VARCHAR2 DEFAULT 'BASE64'
) RETURN NUMBER
DETERMINISTIC
AS
BEGIN
    CASE UPPER(a_format)
        WHEN 'BASE64' THEN
            RETURN TO_NUMBER(utl_encode.base64_decode(utl_raw.cast_to_raw(a_hash)), 'XXXXXXXX');
        WHEN 'HEX' THEN
            RETURN TO_NUMBER(a_hash, 'XXXXXXXX');
    END CASE;
END ParseHash;

/

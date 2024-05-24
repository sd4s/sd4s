--------------------------------------------------------
--  File created - dinsdag-oktober-27-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Function GETERRORHASH
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UNILAB"."GETERRORHASH" (
    a_api_name  IN VARCHAR2,
    a_error_msg IN VARCHAR2 
) RETURN NUMBER
DETERMINISTIC
AS
    l_result NUMBER;
BEGIN
    SELECT ORA_HASH(
        REGEXP_REPLACE(
            REGEXP_REPLACE(
                a_api_name,
                'Ev~\d+~(.+)',
                'Ev~%~\1'
            ),
            'UNACTION\.AssignGroupKey\(.+',
            'UNACTION.AssignGroupKey(%,%)'
        ) ||
        REGEXP_REPLACE(
            REGEXP_REPLACE(
                REGEXP_REPLACE(
                    REGEXP_REPLACE(
                        a_error_msg,
                        '^(SQL\(\d+\)|\(SQL\)).*$',
                        '(SQL)'
                    ),
                    '([A-Za-z_]+(\(\d+\))?)=[^#;]*',
                    '\1=%'
                ),
                '<[^>]*>',
                '<%>'
            ),
            '"[^"]*"',
            '"%"'
        )
    )
    INTO l_result
    FROM dual;

    RETURN l_result;
END GetErrorHash;

/

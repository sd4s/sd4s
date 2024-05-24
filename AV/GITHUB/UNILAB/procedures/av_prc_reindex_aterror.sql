--------------------------------------------------------
--  File created - dinsdag-oktober-27-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure REINDEX_ATERROR
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UNILAB"."REINDEX_ATERROR" AS 
BEGIN
    UPDATE aterror
    SET error_hash = GetErrorHash(api_name, message)
    WHERE error_hash <> GetErrorHash(api_name, message);
    dbms_output.put_line('error_hash: ' || SQL%ROWCOUNT || ' rows updated.');

    UPDATE aterror
    SET info_level = NVL((
        SELECT info_level
        FROM aterrordetails
        WHERE error_hash = aterror.error_hash
    ), 0)
    WHERE info_level <> (
        SELECT info_level
        FROM aterrordetails
        WHERE error_hash = aterror.error_hash
    );
    dbms_output.put_line('info_level: ' || SQL%ROWCOUNT || ' rows updated.');
END reindex_aterror;

/

create or replace PROCEDURE SyncNLS
IS
   ddl_cursor      INTEGER;
   ddl_statement   VARCHAR2 (1024);

   CURSOR nls_instance_settings
   IS
      SELECT parameter, value
        FROM nls_instance_parameters
       WHERE value IS NOT NULL;

BEGIN
   FOR setting IN nls_instance_settings
   LOOP
      DBMS_SESSION.set_nls (setting.parameter, '''' || setting.value || '''');
   END LOOP;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line (SQLERRM);
END SyncNLS; 
 
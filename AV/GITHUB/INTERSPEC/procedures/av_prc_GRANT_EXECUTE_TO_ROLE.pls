CREATE OR REPLACE PROCEDURE GRANT_EXECUTE_TO_ROLE
IS












   L_CURSOR                      INTEGER;

   CURSOR L_OBJECT_CURSOR(
      ASSCHEMANAME               IN       IAPITYPE.DATABASESCHEMANAME_TYPE )
   IS
      SELECT OBJECT_NAME,
             CONFIGURATOR,
             APPROVER,
             DEV_MGR,
             VIEW_ONLY,
             MRP,
             FRAME_BUILDER
        FROM GRANT_EXECUTE
       WHERE OBJECT_NAME IN( SELECT OBJECT_NAME
                              FROM DBA_OBJECTS
                             WHERE OWNER = ASSCHEMANAME );

   L_ROW                         INTEGER;
   L_SQL_STRING                  VARCHAR2( 2000 );
   L_RESULT                      INTEGER;
   LSSCHEMANAME                  VARCHAR2( 100 );
BEGIN
   SELECT OWNER
     INTO LSSCHEMANAME
     FROM DBA_OBJECTS
    WHERE OBJECT_NAME = 'IAPIDATABASE'
      AND OBJECT_TYPE = 'PACKAGE';

   L_CURSOR := DBMS_SQL.OPEN_CURSOR;

   FOR L_ROW IN L_OBJECT_CURSOR( LSSCHEMANAME )
   LOOP
      DBMS_OUTPUT.PUT_LINE( L_ROW.OBJECT_NAME );

      IF L_ROW.APPROVER = '1'
      THEN
         L_SQL_STRING :=    'GRANT execute ON '
                         || L_ROW.OBJECT_NAME
                         || ' TO APPROVER';

         BEGIN
            DBMS_SQL.PARSE( L_CURSOR,
                            L_SQL_STRING,
                            DBMS_SQL.V7 );
            L_RESULT := DBMS_SQL.EXECUTE( L_CURSOR );
         EXCEPTION
            WHEN OTHERS
            THEN
               DBMS_OUTPUT.PUT_LINE(    'An error occurred'
                                     || SUBSTR( SQLERRM,
                                                1,
                                                200 ) );
         END;
      END IF;

      IF L_ROW.DEV_MGR = '1'
      THEN
         L_SQL_STRING :=    'GRANT execute ON '
                         || L_ROW.OBJECT_NAME
                         || ' TO DEV_MGR';

         BEGIN
            DBMS_SQL.PARSE( L_CURSOR,
                            L_SQL_STRING,
                            DBMS_SQL.V7 );
            L_RESULT := DBMS_SQL.EXECUTE( L_CURSOR );
         EXCEPTION
            WHEN OTHERS
            THEN
               DBMS_OUTPUT.PUT_LINE(    'An error occurred'
                                     || SUBSTR( SQLERRM,
                                                1,
                                                200 ) );
         END;
      END IF;

      IF L_ROW.VIEW_ONLY = '1'
      THEN
         L_SQL_STRING :=    'GRANT execute ON '
                         || L_ROW.OBJECT_NAME
                         || ' TO VIEW_ONLY';

         BEGIN
            DBMS_SQL.PARSE( L_CURSOR,
                            L_SQL_STRING,
                            DBMS_SQL.V7 );
            L_RESULT := DBMS_SQL.EXECUTE( L_CURSOR );
         EXCEPTION
            WHEN OTHERS
            THEN
               DBMS_OUTPUT.PUT_LINE(    'An error occurred'
                                     || SUBSTR( SQLERRM,
                                                1,
                                                200 ) );
         END;
      END IF;

      IF L_ROW.MRP = '1'
      THEN
         L_SQL_STRING :=    'GRANT execute ON '
                         || L_ROW.OBJECT_NAME
                         || ' TO MRP';

         BEGIN
            DBMS_SQL.PARSE( L_CURSOR,
                            L_SQL_STRING,
                            DBMS_SQL.V7 );
            L_RESULT := DBMS_SQL.EXECUTE( L_CURSOR );
         EXCEPTION
            WHEN OTHERS
            THEN
               DBMS_OUTPUT.PUT_LINE(    'An error occurred'
                                     || SUBSTR( SQLERRM,
                                                1,
                                                200 ) );
         END;
      END IF;

      IF L_ROW.FRAME_BUILDER = '1'
      THEN
         L_SQL_STRING :=    'GRANT execute ON '
                         || L_ROW.OBJECT_NAME
                         || ' TO FRAME_BUILDER';

         BEGIN
            DBMS_SQL.PARSE( L_CURSOR,
                            L_SQL_STRING,
                            DBMS_SQL.V7 );
            L_RESULT := DBMS_SQL.EXECUTE( L_CURSOR );
         EXCEPTION
            WHEN OTHERS
            THEN
               DBMS_OUTPUT.PUT_LINE(    'An error occurred'
                                     || SUBSTR( SQLERRM,
                                                1,
                                                200 ) );
         END;
      END IF;
   END LOOP;

   DBMS_SQL.CLOSE_CURSOR( L_CURSOR );
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE(    'An error occurred'
                            || SUBSTR( SQLERRM,
                                       1,
                                       200 ) );

      IF DBMS_SQL.IS_OPEN( L_CURSOR )
      THEN
         DBMS_SQL.CLOSE_CURSOR( L_CURSOR );
      END IF;

      IF L_OBJECT_CURSOR%ISOPEN
      THEN
         CLOSE L_OBJECT_CURSOR;
      END IF;
END;
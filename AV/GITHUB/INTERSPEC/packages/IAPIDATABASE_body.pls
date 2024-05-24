CREATE OR REPLACE PACKAGE BODY iapiDatabase
AS
















   PSSQLERRM                     IAPITYPE.STRING_TYPE;


   FUNCTION GETPACKAGEVERSION
      RETURN IAPITYPE.STRING_TYPE
   IS
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetPackageVersion';
   BEGIN



      RETURN(    IAPIGENERAL.GETVERSION
              || ' ($Revision: 6.7.0.0 (06.07.00.00-01.00) $)' );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   END GETPACKAGEVERSION;







   PROCEDURE GRANTTABLEAPPROVER
   IS





      CURSOR L_OBJECT_CURSOR(
         ASSCHEMANAME               IN       IAPITYPE.DATABASESCHEMANAME_TYPE )
      IS
         SELECT TABLE_NAME,
                COL_SELECT,
                COL_INSERT,
                COL_UPDATE,
                COL_DELETE
           FROM APPROVER
          WHERE TABLE_NAME IN( SELECT OBJECT_NAME
                                FROM DBA_OBJECTS
                               WHERE OWNER = ASSCHEMANAME
                                 AND OBJECT_TYPE = 'TABLE' );

      LSSQL                         VARCHAR2( 2000 );
      LIRESULT                      INTEGER;
      LICURSOR                      INTEGER;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSCHEMANAME                  IAPITYPE.DATABASESCHEMANAME_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GrantTableApprover';
      LEERROR                       EXCEPTION;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIDATABASE.GETSCHEMANAME( LSSCHEMANAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
      ELSE
         LICURSOR := DBMS_SQL.OPEN_CURSOR;

         FOR L_ROW IN L_OBJECT_CURSOR( LSSCHEMANAME )
         LOOP
            BEGIN
               IF L_ROW.COL_SELECT = '1'
               THEN
                  LSSQL :=    'GRANT select ON '
                           || L_ROW.TABLE_NAME
                           || ' TO APPROVER';
                  DBMS_SQL.PARSE( LICURSOR,
                                  LSSQL,
                                  DBMS_SQL.V7 );
                  LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );
               END IF;

               IF L_ROW.COL_INSERT = '1'
               THEN
                  LSSQL :=    'GRANT insert ON '
                           || L_ROW.TABLE_NAME
                           || ' TO APPROVER';
                  DBMS_SQL.PARSE( LICURSOR,
                                  LSSQL,
                                  DBMS_SQL.V7 );
                  LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );
               END IF;

               IF L_ROW.COL_UPDATE = '1'
               THEN
                  LSSQL :=    'GRANT update ON '
                           || L_ROW.TABLE_NAME
                           || ' TO APPROVER';
                  DBMS_SQL.PARSE( LICURSOR,
                                  LSSQL,
                                  DBMS_SQL.V7 );
                  LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );
               END IF;

               IF L_ROW.COL_DELETE = '1'
               THEN
                  LSSQL :=    'GRANT delete ON '
                           || L_ROW.TABLE_NAME
                           || ' TO APPROVER';
                  DBMS_SQL.PARSE( LICURSOR,
                                  LSSQL,
                                  DBMS_SQL.V7 );
                  LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );
               END IF;
            EXCEPTION
               WHEN OTHERS
               THEN
                  PSSQLERRM := SUBSTR( SQLERRM,
                                       1,
                                       214 );
                  DBMS_OUTPUT.PUT_LINE(    'Approver - '
                                        || L_ROW.TABLE_NAME
                                        || ' - Error: '
                                        || PSSQLERRM );
            END;
         END LOOP;

         DBMS_SQL.CLOSE_CURSOR( LICURSOR );
      END IF;
   EXCEPTION
      WHEN LEERROR
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         PSSQLERRM := SUBSTR( IAPIGENERAL.GETLASTERRORTEXT( ),
                              1,
                              214 );
         DBMS_OUTPUT.PUT_LINE(    'An error '
                               || PSSQLERRM );
         ROLLBACK;

         IF DBMS_SQL.IS_OPEN( LICURSOR )
         THEN
            DBMS_SQL.CLOSE_CURSOR( LICURSOR );
         END IF;

         IF L_OBJECT_CURSOR%ISOPEN
         THEN
            CLOSE L_OBJECT_CURSOR;
         END IF;
      WHEN OTHERS
      THEN
         PSSQLERRM := SUBSTR( SQLERRM,
                              1,
                              214 );
         DBMS_OUTPUT.PUT_LINE(    'An error '
                               || PSSQLERRM );
         ROLLBACK;

         IF DBMS_SQL.IS_OPEN( LICURSOR )
         THEN
            DBMS_SQL.CLOSE_CURSOR( LICURSOR );
         END IF;

         IF L_OBJECT_CURSOR%ISOPEN
         THEN
            CLOSE L_OBJECT_CURSOR;
         END IF;
   END GRANTTABLEAPPROVER;


   PROCEDURE GRANTTABLEDEVMGR
   IS





      CURSOR L_OBJECT_CURSOR(
         ASSCHEMANAME               IN       IAPITYPE.DATABASESCHEMANAME_TYPE )
      IS
         SELECT TABLE_NAME,
                COL_SELECT,
                COL_INSERT,
                COL_UPDATE,
                COL_DELETE
           FROM DEV_MGR
          WHERE TABLE_NAME IN( SELECT OBJECT_NAME
                                FROM DBA_OBJECTS
                               WHERE OWNER = ASSCHEMANAME
                                 AND OBJECT_TYPE = 'TABLE' );

      LSSQL                         VARCHAR2( 2000 );
      LIRESULT                      INTEGER;
      LICURSOR                      INTEGER;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSCHEMANAME                  IAPITYPE.DATABASESCHEMANAME_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GrantTableDevMgr';
      LEERROR                       EXCEPTION;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIDATABASE.GETSCHEMANAME( LSSCHEMANAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
      ELSE
         LICURSOR := DBMS_SQL.OPEN_CURSOR;

         FOR L_ROW IN L_OBJECT_CURSOR( LSSCHEMANAME )
         LOOP
            BEGIN
               IF L_ROW.COL_SELECT = '1'
               THEN
                  LSSQL :=    'GRANT select ON '
                           || L_ROW.TABLE_NAME
                           || ' TO DEV_MGR';
                  DBMS_SQL.PARSE( LICURSOR,
                                  LSSQL,
                                  DBMS_SQL.V7 );
                  LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );
               END IF;

               IF L_ROW.COL_INSERT = '1'
               THEN
                  LSSQL :=    'GRANT insert ON '
                           || L_ROW.TABLE_NAME
                           || ' TO DEV_MGR';
                  DBMS_SQL.PARSE( LICURSOR,
                                  LSSQL,
                                  DBMS_SQL.V7 );
                  LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );
               END IF;

               IF L_ROW.COL_UPDATE = '1'
               THEN
                  LSSQL :=    'GRANT update ON '
                           || L_ROW.TABLE_NAME
                           || ' TO DEV_MGR';
                  DBMS_SQL.PARSE( LICURSOR,
                                  LSSQL,
                                  DBMS_SQL.V7 );
                  LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );
               END IF;

               IF L_ROW.COL_DELETE = '1'
               THEN
                  LSSQL :=    'GRANT delete ON '
                           || L_ROW.TABLE_NAME
                           || ' TO DEV_MGR';
                  DBMS_SQL.PARSE( LICURSOR,
                                  LSSQL,
                                  DBMS_SQL.V7 );
                  LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );
               END IF;
            EXCEPTION
               WHEN OTHERS
               THEN
                  PSSQLERRM := SUBSTR( SQLERRM,
                                       1,
                                       214 );
                  DBMS_OUTPUT.PUT_LINE(    'Dev Mgr - '
                                        || L_ROW.TABLE_NAME
                                        || ' - Error: '
                                        || PSSQLERRM );
            END;
         END LOOP;

         DBMS_SQL.CLOSE_CURSOR( LICURSOR );
      END IF;
   EXCEPTION
      WHEN LEERROR
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         PSSQLERRM := SUBSTR( IAPIGENERAL.GETLASTERRORTEXT( ),
                              1,
                              214 );
         DBMS_OUTPUT.PUT_LINE(    'Dev Mgr - Error: '
                               || PSSQLERRM );
         ROLLBACK;

         IF DBMS_SQL.IS_OPEN( LICURSOR )
         THEN
            DBMS_SQL.CLOSE_CURSOR( LICURSOR );
         END IF;

         IF L_OBJECT_CURSOR%ISOPEN
         THEN
            CLOSE L_OBJECT_CURSOR;
         END IF;
      WHEN OTHERS
      THEN
         PSSQLERRM := SUBSTR( SQLERRM,
                              1,
                              214 );
         DBMS_OUTPUT.PUT_LINE(    'Dev Mgr - Error: '
                               || PSSQLERRM );
         ROLLBACK;

         IF DBMS_SQL.IS_OPEN( LICURSOR )
         THEN
            DBMS_SQL.CLOSE_CURSOR( LICURSOR );
         END IF;

         IF L_OBJECT_CURSOR%ISOPEN
         THEN
            CLOSE L_OBJECT_CURSOR;
         END IF;
   END GRANTTABLEDEVMGR;


   PROCEDURE GRANTTABLELIMITED
   IS





      CURSOR L_OBJECT_CURSOR(
         ASSCHEMANAME               IN       IAPITYPE.DATABASESCHEMANAME_TYPE )
      IS
         SELECT TABLE_NAME,
                COL_SELECT,
                COL_INSERT,
                COL_UPDATE,
                COL_DELETE
           FROM LIMITED
          WHERE TABLE_NAME IN( SELECT OBJECT_NAME
                                FROM DBA_OBJECTS
                               WHERE OWNER = ASSCHEMANAME
                                 AND OBJECT_TYPE = 'TABLE' );

      LSSQL                         VARCHAR2( 2000 );
      LIRESULT                      INTEGER;
      LICURSOR                      INTEGER;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSCHEMANAME                  IAPITYPE.DATABASESCHEMANAME_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GrantTableLimited';
      LEERROR                       EXCEPTION;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIDATABASE.GETSCHEMANAME( LSSCHEMANAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
      ELSE
         LICURSOR := DBMS_SQL.OPEN_CURSOR;

         FOR L_ROW IN L_OBJECT_CURSOR( LSSCHEMANAME )
         LOOP
            BEGIN
               IF L_ROW.COL_SELECT = '1'
               THEN
                  LSSQL :=    'GRANT select ON '
                           || L_ROW.TABLE_NAME
                           || ' TO LIMITED';
                  DBMS_SQL.PARSE( LICURSOR,
                                  LSSQL,
                                  DBMS_SQL.V7 );
                  LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );
               END IF;

               IF L_ROW.COL_INSERT = '1'
               THEN
                  LSSQL :=    'GRANT insert ON '
                           || L_ROW.TABLE_NAME
                           || ' TO LIMITED';
                  DBMS_SQL.PARSE( LICURSOR,
                                  LSSQL,
                                  DBMS_SQL.V7 );
                  LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );
               END IF;

               IF L_ROW.COL_UPDATE = '1'
               THEN
                  LSSQL :=    'GRANT update ON '
                           || L_ROW.TABLE_NAME
                           || ' TO LIMITED';
                  DBMS_SQL.PARSE( LICURSOR,
                                  LSSQL,
                                  DBMS_SQL.V7 );
                  LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );
               END IF;

               IF L_ROW.COL_DELETE = '1'
               THEN
                  LSSQL :=    'GRANT delete ON '
                           || L_ROW.TABLE_NAME
                           || ' TO LIMITED';
                  DBMS_SQL.PARSE( LICURSOR,
                                  LSSQL,
                                  DBMS_SQL.V7 );
                  LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );
               END IF;
            EXCEPTION
               WHEN OTHERS
               THEN
                  PSSQLERRM := SUBSTR( SQLERRM,
                                       1,
                                       214 );
                  DBMS_OUTPUT.PUT_LINE(    'Limited - '
                                        || L_ROW.TABLE_NAME
                                        || ' - Error: '
                                        || PSSQLERRM );
            END;
         END LOOP;

         DBMS_SQL.CLOSE_CURSOR( LICURSOR );
      END IF;
   EXCEPTION
      WHEN LEERROR
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         PSSQLERRM := SUBSTR( IAPIGENERAL.GETLASTERRORTEXT( ),
                              1,
                              214 );
         DBMS_OUTPUT.PUT_LINE(    'Limited - Error: '
                               || PSSQLERRM );
         ROLLBACK;

         IF DBMS_SQL.IS_OPEN( LICURSOR )
         THEN
            DBMS_SQL.CLOSE_CURSOR( LICURSOR );
         END IF;

         IF L_OBJECT_CURSOR%ISOPEN
         THEN
            CLOSE L_OBJECT_CURSOR;
         END IF;
      WHEN OTHERS
      THEN
         PSSQLERRM := SUBSTR( SQLERRM,
                              1,
                              214 );
         DBMS_OUTPUT.PUT_LINE(    'Limited - Error: '
                               || PSSQLERRM );
         ROLLBACK;

         IF DBMS_SQL.IS_OPEN( LICURSOR )
         THEN
            DBMS_SQL.CLOSE_CURSOR( LICURSOR );
         END IF;

         IF L_OBJECT_CURSOR%ISOPEN
         THEN
            CLOSE L_OBJECT_CURSOR;
         END IF;
   END GRANTTABLELIMITED;


   PROCEDURE GRANTTABLEVIEWONLY
   IS





      CURSOR L_OBJECT_CURSOR(
         ASSCHEMANAME               IN       IAPITYPE.DATABASESCHEMANAME_TYPE )
      IS
         SELECT TABLE_NAME,
                COL_SELECT,
                COL_INSERT,
                COL_UPDATE,
                COL_DELETE
           FROM VIEW_ONLY
          WHERE TABLE_NAME IN( SELECT OBJECT_NAME
                                FROM DBA_OBJECTS
                               WHERE OWNER = ASSCHEMANAME
                                 AND OBJECT_TYPE = 'TABLE' );

      LSSQL                         VARCHAR2( 2000 );
      LIRESULT                      INTEGER;
      LICURSOR                      INTEGER;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSCHEMANAME                  IAPITYPE.DATABASESCHEMANAME_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GrantTableViewOnly';
      LEERROR                       EXCEPTION;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIDATABASE.GETSCHEMANAME( LSSCHEMANAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
      ELSE
         LICURSOR := DBMS_SQL.OPEN_CURSOR;

         FOR L_ROW IN L_OBJECT_CURSOR( LSSCHEMANAME )
         LOOP
            BEGIN
               IF L_ROW.COL_SELECT = '1'
               THEN
                  LSSQL :=    'GRANT select ON '
                           || L_ROW.TABLE_NAME
                           || ' TO VIEW_ONLY';
                  DBMS_SQL.PARSE( LICURSOR,
                                  LSSQL,
                                  DBMS_SQL.V7 );
                  LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );
               END IF;

               IF L_ROW.COL_INSERT = '1'
               THEN
                  LSSQL :=    'GRANT insert ON '
                           || L_ROW.TABLE_NAME
                           || ' TO VIEW_ONLY';
                  DBMS_SQL.PARSE( LICURSOR,
                                  LSSQL,
                                  DBMS_SQL.V7 );
                  LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );
               END IF;

               IF L_ROW.COL_UPDATE = '1'
               THEN
                  LSSQL :=    'GRANT update ON '
                           || L_ROW.TABLE_NAME
                           || ' TO VIEW_ONLY';
                  DBMS_SQL.PARSE( LICURSOR,
                                  LSSQL,
                                  DBMS_SQL.V7 );
                  LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );
               END IF;

               IF L_ROW.COL_DELETE = '1'
               THEN
                  LSSQL :=    'GRANT delete ON '
                           || L_ROW.TABLE_NAME
                           || ' TO VIEW_ONLY';
                  DBMS_SQL.PARSE( LICURSOR,
                                  LSSQL,
                                  DBMS_SQL.V7 );
                  LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );
               END IF;
            EXCEPTION
               WHEN OTHERS
               THEN
                  PSSQLERRM := SUBSTR( SQLERRM,
                                       1,
                                       214 );
                  DBMS_OUTPUT.PUT_LINE(    'View Only - '
                                        || L_ROW.TABLE_NAME
                                        || ' - Error: '
                                        || PSSQLERRM );
            END;
         END LOOP;

         DBMS_SQL.CLOSE_CURSOR( LICURSOR );
      END IF;
   EXCEPTION
      WHEN LEERROR
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         PSSQLERRM := SUBSTR( IAPIGENERAL.GETLASTERRORTEXT( ),
                              1,
                              214 );
         DBMS_OUTPUT.PUT_LINE(    'View Only - Error: '
                               || PSSQLERRM );
         ROLLBACK;

         IF DBMS_SQL.IS_OPEN( LICURSOR )
         THEN
            DBMS_SQL.CLOSE_CURSOR( LICURSOR );
         END IF;

         IF L_OBJECT_CURSOR%ISOPEN
         THEN
            CLOSE L_OBJECT_CURSOR;
         END IF;
      WHEN OTHERS
      THEN
         PSSQLERRM := SUBSTR( SQLERRM,
                              1,
                              214 );
         DBMS_OUTPUT.PUT_LINE(    'View Only - Error: '
                               || PSSQLERRM );
         ROLLBACK;

         IF DBMS_SQL.IS_OPEN( LICURSOR )
         THEN
            DBMS_SQL.CLOSE_CURSOR( LICURSOR );
         END IF;

         IF L_OBJECT_CURSOR%ISOPEN
         THEN
            CLOSE L_OBJECT_CURSOR;
         END IF;
   END GRANTTABLEVIEWONLY;


   PROCEDURE GRANTTABLEMRP
   IS





      CURSOR L_OBJECT_CURSOR(
         ASSCHEMANAME               IN       IAPITYPE.DATABASESCHEMANAME_TYPE )
      IS
         SELECT TABLE_NAME,
                COL_SELECT,
                COL_INSERT,
                COL_UPDATE,
                COL_DELETE
           FROM MRP
          WHERE TABLE_NAME IN( SELECT OBJECT_NAME
                                FROM DBA_OBJECTS
                               WHERE OWNER = ASSCHEMANAME
                                 AND OBJECT_TYPE = 'TABLE' );

      LSSQL                         VARCHAR2( 2000 );
      LIRESULT                      INTEGER;
      LICURSOR                      INTEGER;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSCHEMANAME                  IAPITYPE.DATABASESCHEMANAME_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GrantTableMrp';
      LEERROR                       EXCEPTION;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIDATABASE.GETSCHEMANAME( LSSCHEMANAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
      ELSE
         LICURSOR := DBMS_SQL.OPEN_CURSOR;

         FOR L_ROW IN L_OBJECT_CURSOR( LSSCHEMANAME )
         LOOP
            BEGIN
               IF L_ROW.COL_SELECT = '1'
               THEN
                  LSSQL :=    'GRANT select ON '
                           || L_ROW.TABLE_NAME
                           || ' TO MRP';
                  DBMS_SQL.PARSE( LICURSOR,
                                  LSSQL,
                                  DBMS_SQL.V7 );
                  LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );
               END IF;

               IF L_ROW.COL_INSERT = '1'
               THEN
                  LSSQL :=    'GRANT insert ON '
                           || L_ROW.TABLE_NAME
                           || ' TO MRP';
                  DBMS_SQL.PARSE( LICURSOR,
                                  LSSQL,
                                  DBMS_SQL.V7 );
                  LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );
               END IF;

               IF L_ROW.COL_UPDATE = '1'
               THEN
                  LSSQL :=    'GRANT update ON '
                           || L_ROW.TABLE_NAME
                           || ' TO MRP';
                  DBMS_SQL.PARSE( LICURSOR,
                                  LSSQL,
                                  DBMS_SQL.V7 );
                  LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );
               END IF;

               IF L_ROW.COL_DELETE = '1'
               THEN
                  LSSQL :=    'GRANT delete ON '
                           || L_ROW.TABLE_NAME
                           || ' TO MRP';
                  DBMS_SQL.PARSE( LICURSOR,
                                  LSSQL,
                                  DBMS_SQL.V7 );
                  LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );
               END IF;
            EXCEPTION
               WHEN OTHERS
               THEN
                  PSSQLERRM := SUBSTR( SQLERRM,
                                       1,
                                       214 );
                  DBMS_OUTPUT.PUT_LINE(    'MRP - '
                                        || L_ROW.TABLE_NAME
                                        || ' - Error: '
                                        || PSSQLERRM );
            END;
         END LOOP;

         DBMS_SQL.CLOSE_CURSOR( LICURSOR );
      END IF;
   EXCEPTION
      WHEN LEERROR
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         PSSQLERRM := SUBSTR( IAPIGENERAL.GETLASTERRORTEXT( ),
                              1,
                              214 );
         DBMS_OUTPUT.PUT_LINE(    'An error '
                               || PSSQLERRM );
         ROLLBACK;

         IF DBMS_SQL.IS_OPEN( LICURSOR )
         THEN
            DBMS_SQL.CLOSE_CURSOR( LICURSOR );
         END IF;

         IF L_OBJECT_CURSOR%ISOPEN
         THEN
            CLOSE L_OBJECT_CURSOR;
         END IF;
      WHEN OTHERS
      THEN
         PSSQLERRM := SUBSTR( SQLERRM,
                              1,
                              214 );
         DBMS_OUTPUT.PUT_LINE(    'An error '
                               || PSSQLERRM );
         ROLLBACK;

         IF DBMS_SQL.IS_OPEN( LICURSOR )
         THEN
            DBMS_SQL.CLOSE_CURSOR( LICURSOR );
         END IF;

         IF L_OBJECT_CURSOR%ISOPEN
         THEN
            CLOSE L_OBJECT_CURSOR;
         END IF;
   END GRANTTABLEMRP;


   PROCEDURE GRANTTABLEFRAMEBUILDER
   IS





      CURSOR L_OBJECT_CURSOR(
         ASSCHEMANAME               IN       IAPITYPE.DATABASESCHEMANAME_TYPE )
      IS
         SELECT TABLE_NAME,
                COL_SELECT,
                COL_INSERT,
                COL_UPDATE,
                COL_DELETE
           FROM FRAME_BUILDER
          WHERE TABLE_NAME IN( SELECT OBJECT_NAME
                                FROM DBA_OBJECTS
                               WHERE OWNER = ASSCHEMANAME
                                 AND OBJECT_TYPE = 'TABLE' );

      LSSQL                         VARCHAR2( 2000 );
      LIRESULT                      INTEGER;
      LICURSOR                      INTEGER;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSCHEMANAME                  IAPITYPE.DATABASESCHEMANAME_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GrantTableFrameBuilder';
      LEERROR                       EXCEPTION;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIDATABASE.GETSCHEMANAME( LSSCHEMANAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
      ELSE
         LICURSOR := DBMS_SQL.OPEN_CURSOR;

         FOR L_ROW IN L_OBJECT_CURSOR( LSSCHEMANAME )
         LOOP
            BEGIN
               IF L_ROW.COL_SELECT = '1'
               THEN
                  LSSQL :=    'GRANT select ON '
                           || L_ROW.TABLE_NAME
                           || ' TO FRAME_BUILDER';
                  DBMS_SQL.PARSE( LICURSOR,
                                  LSSQL,
                                  DBMS_SQL.V7 );
                  LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );
               END IF;

               IF L_ROW.COL_INSERT = '1'
               THEN
                  LSSQL :=    'GRANT insert ON '
                           || L_ROW.TABLE_NAME
                           || ' TO FRAME_BUILDER';
                  DBMS_SQL.PARSE( LICURSOR,
                                  LSSQL,
                                  DBMS_SQL.V7 );
                  LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );
               END IF;

               IF L_ROW.COL_UPDATE = '1'
               THEN
                  LSSQL :=    'GRANT update ON '
                           || L_ROW.TABLE_NAME
                           || ' TO FRAME_BUILDER';
                  DBMS_SQL.PARSE( LICURSOR,
                                  LSSQL,
                                  DBMS_SQL.V7 );
                  LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );
               END IF;

               IF L_ROW.COL_DELETE = '1'
               THEN
                  LSSQL :=    'GRANT delete ON '
                           || L_ROW.TABLE_NAME
                           || ' TO FRAME_BUILDER';
                  DBMS_SQL.PARSE( LICURSOR,
                                  LSSQL,
                                  DBMS_SQL.V7 );
                  LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );
               END IF;
            EXCEPTION
               WHEN OTHERS
               THEN
                  PSSQLERRM := SUBSTR( SQLERRM,
                                       1,
                                       214 );
                  DBMS_OUTPUT.PUT_LINE(    'FRAME BUILDER - '
                                        || L_ROW.TABLE_NAME
                                        || ' - Error: '
                                        || PSSQLERRM );
            END;
         END LOOP;

         DBMS_SQL.CLOSE_CURSOR( LICURSOR );
      END IF;
   EXCEPTION
      WHEN LEERROR
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         PSSQLERRM := SUBSTR( IAPIGENERAL.GETLASTERRORTEXT( ),
                              1,
                              214 );
         DBMS_OUTPUT.PUT_LINE(    'An error '
                               || PSSQLERRM );
         ROLLBACK;

         IF DBMS_SQL.IS_OPEN( LICURSOR )
         THEN
            DBMS_SQL.CLOSE_CURSOR( LICURSOR );
         END IF;

         IF L_OBJECT_CURSOR%ISOPEN
         THEN
            CLOSE L_OBJECT_CURSOR;
         END IF;
      WHEN OTHERS
      THEN
         PSSQLERRM := SUBSTR( SQLERRM,
                              1,
                              214 );
         DBMS_OUTPUT.PUT_LINE(    'An error '
                               || PSSQLERRM );
         ROLLBACK;

         IF DBMS_SQL.IS_OPEN( LICURSOR )
         THEN
            DBMS_SQL.CLOSE_CURSOR( LICURSOR );
         END IF;

         IF L_OBJECT_CURSOR%ISOPEN
         THEN
            CLOSE L_OBJECT_CURSOR;
         END IF;
   END GRANTTABLEFRAMEBUILDER;


   PROCEDURE GRANTALLOBJECTS
   IS






      CURSOR L_OBJECT_CURSOR(
         ASSCHEMANAME               IN       IAPITYPE.DATABASESCHEMANAME_TYPE )
      IS
         SELECT OBJECT_NAME,
                OBJECT_TYPE
           FROM DBA_OBJECTS
          WHERE OWNER = ASSCHEMANAME
            AND OBJECT_NAME NOT LIKE 'BIN$%'
            AND STATUS = 'VALID'; 

      LSSQL                         VARCHAR2( 2000 );
      LIRESULT                      INTEGER;
      LICURSOR                      INTEGER;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSCHEMANAME                  IAPITYPE.DATABASESCHEMANAME_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GrantAllObjects';
      LEERROR                       EXCEPTION;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIDATABASE.GETSCHEMANAME( LSSCHEMANAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
      ELSE
         LICURSOR := DBMS_SQL.OPEN_CURSOR;

         FOR L_ROW IN L_OBJECT_CURSOR( LSSCHEMANAME )
         LOOP
            BEGIN
               IF L_ROW.OBJECT_NAME NOT IN( 'IAPIDATABASE', 'IAPIGENERAL', 'IAPICONSTANT', 'IAPICONSTANTDBERROR', 'IAPITYPE' )
               THEN
                  IAPIGENERAL.LOGINFO( GSSOURCE,
                                       LSMETHOD,
                                          'ObjectName : '
                                       || L_ROW.OBJECT_NAME );

                  
                  IF    L_ROW.OBJECT_TYPE = 'TABLE'
                     OR L_ROW.OBJECT_TYPE = 'VIEW'
                     OR L_ROW.OBJECT_TYPE = 'SEQUENCE'
                     OR L_ROW.OBJECT_TYPE = 'PROCEDURE'
                     OR L_ROW.OBJECT_TYPE = 'PACKAGE'
                     OR L_ROW.OBJECT_TYPE = 'PACKAGE BODY'
                     OR L_ROW.OBJECT_TYPE = 'FUNCTION'
                  THEN
                     IF L_ROW.OBJECT_TYPE = 'SEQUENCE'
                     THEN
                        LSSQL :=    'GRANT select ON '
                                 || L_ROW.OBJECT_NAME
                                 || ' TO CONFIGURATOR, DEV_MGR, VIEW_ONLY, MRP, FRAME_BUILDER, APPROVER';
                     ELSIF L_ROW.OBJECT_TYPE = 'TABLE'
                     THEN
                        LSSQL :=    'GRANT select,insert,delete,update ON '
                                 || L_ROW.OBJECT_NAME
                                 || ' TO CONFIGURATOR';
                     ELSIF L_ROW.OBJECT_TYPE = 'VIEW'
                     THEN
                        LSSQL :=    'GRANT select ON '
                                 || L_ROW.OBJECT_NAME
                                 || ' TO CONFIGURATOR, DEV_MGR, VIEW_ONLY, MRP, FRAME_BUILDER, APPROVER';
                     ELSIF    L_ROW.OBJECT_TYPE = 'PROCEDURE'
                           OR L_ROW.OBJECT_TYPE = 'PACKAGE'
                           OR L_ROW.OBJECT_TYPE = 'PACKAGE BODY'
                           OR L_ROW.OBJECT_TYPE = 'FUNCTION'
                     THEN
                        IF     L_ROW.OBJECT_TYPE IN( 'PACKAGE', 'PACKAGE BODY' )
                           AND L_ROW.OBJECT_NAME LIKE 'IAPI%'
                        THEN
                           LSSQL :=    'GRANT execute ON '
                                    || L_ROW.OBJECT_NAME
                                    || ' TO CONFIGURATOR, DEV_MGR, VIEW_ONLY, MRP, FRAME_BUILDER, APPROVER';
                        ELSE
                           LSSQL :=    'GRANT execute ON '
                                    || L_ROW.OBJECT_NAME
                                    || ' TO CONFIGURATOR';
                        END IF;
                     ELSE
                        DBMS_OUTPUT.PUT_LINE(    'Error: Unkown type:'
                                              || L_ROW.OBJECT_TYPE
                                              || ' for '
                                              || L_ROW.OBJECT_NAME );
                     END IF;

                     DBMS_SQL.PARSE( LICURSOR,
                                     LSSQL,
                                     DBMS_SQL.V7 );
                     LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );
                  END IF;
               END IF;
            EXCEPTION
               WHEN OTHERS
               THEN
                  PSSQLERRM := SUBSTR( SQLERRM,
                                       1,
                                       213 );
                  DBMS_OUTPUT.PUT_LINE(    'ALL OBJECTS - '
                                        || L_ROW.OBJECT_NAME
                                        || ' '
                                        || L_ROW.OBJECT_TYPE
                                        || ' - Error: '
                                        || PSSQLERRM );
            END;
         END LOOP;

         DBMS_SQL.CLOSE_CURSOR( LICURSOR );
      END IF;
   EXCEPTION
      WHEN LEERROR
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         PSSQLERRM := SUBSTR( IAPIGENERAL.GETLASTERRORTEXT( ),
                              1,
                              214 );
         DBMS_OUTPUT.PUT_LINE(    'ALL OBJECTS - Error: '
                               || PSSQLERRM );
         ROLLBACK;

         IF DBMS_SQL.IS_OPEN( LICURSOR )
         THEN
            DBMS_SQL.CLOSE_CURSOR( LICURSOR );
         END IF;

         IF L_OBJECT_CURSOR%ISOPEN
         THEN
            CLOSE L_OBJECT_CURSOR;
         END IF;
      WHEN OTHERS
      THEN
         PSSQLERRM := SUBSTR( SQLERRM,
                              1,
                              213 );
         DBMS_OUTPUT.PUT_LINE(    'ALL OBJECTS - Error: '
                               || PSSQLERRM );
         ROLLBACK;

         IF DBMS_SQL.IS_OPEN( LICURSOR )
         THEN
            DBMS_SQL.CLOSE_CURSOR( LICURSOR );
         END IF;

         IF L_OBJECT_CURSOR%ISOPEN
         THEN
            CLOSE L_OBJECT_CURSOR;
         END IF;
   END GRANTALLOBJECTS;


   PROCEDURE GRANTEXCEPTION (ASSPECIALVIEW IN IAPITYPE.NAME_TYPE)
   IS





      LSSPECIALVIEW                 VARCHAR2( 2000 ) := 'IVPLANT';

      CURSOR L_OBJECT_CURSOR(
         ASSCHEMANAME               IN       IAPITYPE.DATABASESCHEMANAME_TYPE )
      IS
         SELECT OBJECT_NAME,
                OBJECT_TYPE
           FROM DBA_OBJECTS
          WHERE OWNER = ASSCHEMANAME
            AND OBJECT_TYPE = 'VIEW'
            AND OBJECT_NAME = LSSPECIALVIEW;

      LSSQL                         VARCHAR2( 2000 );
      LIRESULT                      INTEGER;
      LICURSOR                      INTEGER;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSCHEMANAME                  IAPITYPE.DATABASESCHEMANAME_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GrantException';
      LEERROR                       EXCEPTION;
   BEGIN




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIDATABASE.GETSCHEMANAME( LSSCHEMANAME );

      SELECT NVL(ASSPECIALVIEW, LSSPECIALVIEW) INTO LSSPECIALVIEW FROM DUAL;

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
      ELSE
         LICURSOR := DBMS_SQL.OPEN_CURSOR;

         FOR L_ROW IN ( SELECT OBJECT_NAME,
                               OBJECT_TYPE
                         FROM DBA_OBJECTS
                        WHERE OWNER = LSSCHEMANAME
                          AND OBJECT_TYPE = 'VIEW'
                          AND OBJECT_NAME = LSSPECIALVIEW )
         LOOP
            BEGIN
               LSSQL :=    'GRANT select, insert, update, delete ON '
                        || L_ROW.OBJECT_NAME
                        || ' TO CONFIGURATOR';
               DBMS_SQL.PARSE( LICURSOR,
                               LSSQL,
                               DBMS_SQL.V7 );
               LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );
            EXCEPTION
               WHEN OTHERS
               THEN
                  PSSQLERRM := SUBSTR( SQLERRM,
                                       1,
                                       213 );
                  DBMS_OUTPUT.PUT_LINE(    'ALL OBJECTS - '
                                        || L_ROW.OBJECT_NAME
                                        || ' '
                                        || L_ROW.OBJECT_TYPE
                                        || ' - Error: '
                                        || PSSQLERRM );
            END;
         END LOOP;

         DBMS_SQL.CLOSE_CURSOR( LICURSOR );
      END IF;
   EXCEPTION
      WHEN LEERROR
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         PSSQLERRM := SUBSTR( IAPIGENERAL.GETLASTERRORTEXT( ),
                              1,
                              214 );
         DBMS_OUTPUT.PUT_LINE(    'ALL OBJECTS - Error: '
                               || PSSQLERRM );
         ROLLBACK;

         IF DBMS_SQL.IS_OPEN( LICURSOR )
         THEN
            DBMS_SQL.CLOSE_CURSOR( LICURSOR );
         END IF;

         IF L_OBJECT_CURSOR%ISOPEN
         THEN
            CLOSE L_OBJECT_CURSOR;
         END IF;
      WHEN OTHERS
      THEN
         PSSQLERRM := SUBSTR( SQLERRM,
                              1,
                              213 );
         DBMS_OUTPUT.PUT_LINE(    'ALL OBJECTS - Error: '
                               || PSSQLERRM );
         ROLLBACK;

         IF DBMS_SQL.IS_OPEN( LICURSOR )
         THEN
            DBMS_SQL.CLOSE_CURSOR( LICURSOR );
         END IF;

         IF L_OBJECT_CURSOR%ISOPEN
         THEN
            CLOSE L_OBJECT_CURSOR;
         END IF;
   END GRANTEXCEPTION;


   PROCEDURE GRANTSEQUENCES
   IS





      CURSOR C_SEQ(
         ASSCHEMANAME               IN       IAPITYPE.DATABASESCHEMANAME_TYPE )
      IS
         SELECT OBJECT_NAME
           FROM DBA_OBJECTS
          WHERE OBJECT_TYPE = 'SEQUENCE'
            AND OWNER = ASSCHEMANAME;

      LSSQL                         VARCHAR2( 2000 );
      LIRESULT                      NUMBER;
      LICURSOR                      INTEGER;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSCHEMANAME                  IAPITYPE.DATABASESCHEMANAME_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GrantSequences';
      LEERROR                       EXCEPTION;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIDATABASE.GETSCHEMANAME( LSSCHEMANAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         LICURSOR := DBMS_SQL.OPEN_CURSOR;

         FOR L_ROW IN C_SEQ( LSSCHEMANAME )
         LOOP
            BEGIN
               LSSQL :=    'GRANT select ON '
                        || L_ROW.OBJECT_NAME
                        || ' TO APPROVER,DEV_MGR,FRAME_BUILDER,MRP,VIEW_ONLY';
               DBMS_SQL.PARSE( LICURSOR,
                               LSSQL,
                               DBMS_SQL.V7 );
               LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );
            EXCEPTION
               WHEN OTHERS
               THEN
                  DBMS_OUTPUT.PUT_LINE(    'SEQUENCES - '
                                        || L_ROW.OBJECT_NAME
                                        || ' - Error: '
                                        || PSSQLERRM );
                  ROLLBACK;
            END GRANTSEQUENCES;
         END LOOP;

         DBMS_SQL.CLOSE_CURSOR( LICURSOR );
      END IF;
   EXCEPTION
      WHEN LEERROR
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         PSSQLERRM := SUBSTR( IAPIGENERAL.GETLASTERRORTEXT( ),
                              1,
                              214 );
         DBMS_OUTPUT.PUT_LINE(    'SEQUENCES - Error: '
                               || PSSQLERRM );
         ROLLBACK;

         IF DBMS_SQL.IS_OPEN( LICURSOR )
         THEN
            DBMS_SQL.CLOSE_CURSOR( LICURSOR );
         END IF;
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.PUT_LINE(    'SEQUENCES - Error: '
                               || PSSQLERRM );
         ROLLBACK;

         IF DBMS_SQL.IS_OPEN( LICURSOR )
         THEN
            DBMS_SQL.CLOSE_CURSOR( LICURSOR );
         END IF;
   END GRANTSEQUENCES;





   FUNCTION GETSCHEMANAME(
      ASSCHEMANAME               OUT      IAPITYPE.DATABASESCHEMANAME_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      CURSOR LQSCHEMANAME
      IS
         SELECT OWNER
           FROM DBA_OBJECTS
          WHERE OBJECT_NAME = 'IAPIDATABASE'
            AND OBJECT_TYPE = 'PACKAGE';

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetSchemaName';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN LQSCHEMANAME;

      FETCH LQSCHEMANAME
       INTO ASSCHEMANAME;

      IF LQSCHEMANAME%NOTFOUND
      THEN
         CLOSE LQSCHEMANAME;

         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_SCHEMANAMENOTFOUND );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      CLOSE LQSCHEMANAME;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );

         IF LQSCHEMANAME%ISOPEN
         THEN
            CLOSE LQSCHEMANAME;
         END IF;

         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETSCHEMANAME;


   FUNCTION CREATESYNONYMS
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS












      CURSOR LQCREATESYN(
         ASSCHEMANAME               IN       IAPITYPE.DATABASESCHEMANAME_TYPE )
      IS
         SELECT DISTINCT OBJECT_NAME
                    FROM DBA_OBJECTS
                   WHERE OWNER = ASSCHEMANAME
                     AND OBJECT_NAME NOT IN( SELECT OBJECT_NAME
                                              FROM DBA_OBJECTS
                                             WHERE OWNER = 'PUBLIC'
                                               AND OBJECT_TYPE = 'SYNONYM' )
                     AND OBJECT_TYPE NOT IN( 'SYNONYM', 'TRIGGER', 'INDEX', 'DATABASE LINK', 'LOB', 'JAVA SOURCE', 'JAVA CLASS' )
                     AND OBJECT_NAME NOT IN
                            ( 'ATTACHED_SPECIFICATION',
                              'BOM_HEADER',
                              'BOM_ITEM',
                              'ITSHBN',
                              'ITSHDESCR_L',
                              'ITSHLNPROPLANG',
                              'PART',
                              'PART_PLANT',
                              'PLANT',
                              'REASON',
                              'SPECDATA',
                              'SPECDATA_PROCESS',
                              'SPECIFICATION_CD',
                              'SPECIFICATION_HEADER',
                              'SPECIFICATION_ING',
                              'SPECIFICATION_ING_LANG',
                              'SPECIFICATION_LINE',
                              'SPECIFICATION_LINE_PROP',
                              'SPECIFICATION_LINE_TEXT',
                              'SPECIFICATION_PROP',
                              'SPECIFICATION_PROP_LANG',
                              'SPECIFICATION_SECTION',
                              'SPECIFICATION_STAGE',
                              'SPECIFICATION_TEXT',
                              
                              'SPECIFICATION_TEXT_NORTF',
                              'SPECIFICATION_TM' )
                     AND OBJECT_NAME NOT IN
                            ( 'IVATTACHED_SPECIFICATION',
                              'IVBOM_HEADER',
                              'IVBOM_ITEM',
                              'IVITSHBN',
                              'IVITSHDESCR_L',
                              'IVITSHLNPROPLANG',
                              'IVPART',
                              'IVPART_PLANT',
                              'IVPLANT',
                              'IVREASON',
                              'IVSPECDATA',
                              'IVSPECDATA_PROCESS',
                              'IVSPECIFICATION_CD',
                              'IVSPECIFICATION_HEADER',
                              'IVSPECIFICATION_ING',
                              'IVSPECIFICATION_ING_LANG',
                              'IVSPECIFICATION_LINE',
                              'IVSPECIFICATION_LINE_PROP',
                              'IVSPECIFICATION_LINE_TEXT',
                              'IVSPECIFICATION_PROP',
                              'IVSPECIFICATION_PROP_LANG',
                              'IVSPECIFICATION_SECTION',
                              'IVSPECIFICATION_STAGE',
                              'IVSPECIFICATION_TEXT',
                              
                              'IVSPECIFICATION_TEXT_NORTF',
                              'IVSPECIFICATION_TM' );


      
      
      CURSOR LQTABLES
      IS
         (SELECT TABLE_NAME
           FROM TABS
          WHERE TABLE_NAME IN
                   ( 'ATTACHED_SPECIFICATION',
                     'BOM_HEADER',
                     'BOM_ITEM',
                     'ITSHBN',
                     'ITSHDESCR_L',
                     'ITSHLNPROPLANG',
                     'PART',
                     'PART_PLANT',
                     'PLANT',
                     'REASON',
                     'SPECDATA',
                     'SPECDATA_PROCESS',
                     'SPECIFICATION_CD',
                     'SPECIFICATION_HEADER',
                     'SPECIFICATION_ING',
                     'SPECIFICATION_ING_LANG',
                     'SPECIFICATION_LINE',
                     'SPECIFICATION_LINE_PROP',
                     'SPECIFICATION_LINE_TEXT',
                     'SPECIFICATION_PROP',
                     'SPECIFICATION_PROP_LANG',
                     'SPECIFICATION_SECTION',
                     'SPECIFICATION_STAGE',
                     'SPECIFICATION_TEXT',
                     
                     'SPECIFICATION_TEXT_NORTF',
                     'SPECIFICATION_TM' )
                     



         MINUS
         SELECT SYNONYM_NAME AS TABLE_NAME
           FROM DBA_SYNONYMS
          WHERE SYNONYM_NAME IN
                      ( 'ATTACHED_SPECIFICATION',
                     'BOM_HEADER',
                     'BOM_ITEM',
                     'ITSHBN',
                     'ITSHDESCR_L',
                     'ITSHLNPROPLANG',
                     'PART',
                     'PART_PLANT',
                     'PLANT',
                     'REASON',
                     'SPECDATA',
                     'SPECDATA_PROCESS',
                     'SPECIFICATION_CD',
                     'SPECIFICATION_HEADER',
                     'SPECIFICATION_ING',
                     'SPECIFICATION_ING_LANG',
                     'SPECIFICATION_LINE',
                     'SPECIFICATION_LINE_PROP',
                     'SPECIFICATION_LINE_TEXT',
                     'SPECIFICATION_PROP',
                     'SPECIFICATION_PROP_LANG',
                     'SPECIFICATION_SECTION',
                     'SPECIFICATION_STAGE',
                     'SPECIFICATION_TEXT',
                     
                     'SPECIFICATION_TEXT_NORTF',
                     'SPECIFICATION_TM' ));



       
      
      
      CURSOR LQVIEWS
      IS
         (SELECT OBJECT_NAME
           FROM DBA_OBJECTS
           WHERE OBJECT_TYPE = 'VIEW'
             AND OWNER = 'INTERSPC'  
             AND OBJECT_NAME IN
                   ('IVSPECIFICATION_TEXT_NORTF')
                     
         MINUS
         SELECT 'IV' || SYNONYM_NAME AS OBJECT_NAME
           FROM DBA_SYNONYMS
          WHERE SYNONYM_NAME IN
                      ('SPECIFICATION_TEXT_NORTF'));
       

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CreateSynonyms';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSCHEMANAME                  IAPITYPE.DATABASESCHEMANAME_TYPE;
      LRREC                         LQCREATESYN%ROWTYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
      LIRESULT                      INTEGER;
      LICURSOR                      INTEGER;
      LNCOUNT                       NUMBER;
      LNVERSIONNUMBER               NUMBER;

      TYPE LTOBJECTNAME IS TABLE OF VARCHAR2( 128 );

      LTOBJECTNAMES                 LTOBJECTNAME;
      LSSQL10                       IAPITYPE.SQLSTRING_TYPE := NULL;

   BEGIN



   IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIDATABASE.GETSCHEMANAME( LSSCHEMANAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      SELECT TO_NUMBER( SUBSTR( VERSION,
                                1,
                                  INSTR( VERSION,
                                         '.' )
                                - 1 ) )
        INTO LNVERSIONNUMBER
        FROM V$INSTANCE;

      LICURSOR := DBMS_SQL.OPEN_CURSOR;

      IF LNVERSIONNUMBER >= 10
      THEN
         LSSQL10 :=
               'SELECT DISTINCT object_name '
            || 'FROM dba_objects '
            || 'WHERE owner = '''
            || LSSCHEMANAME
            || ''' AND object_name NOT IN( SELECT object_name '
            || '                             FROM dba_objects '



            || '                            WHERE owner = ''PUBLIC'' '
            || '                              AND object_type = ''SYNONYM'' ) '
            || 'AND object_type NOT IN( ''SYNONYM'', ''TRIGGER'', ''INDEX'', ''DATABASE LINK'', ''LOB'' , ''JAVA SOURCE'', ''JAVA CLASS'') '
            || 'AND object_name NOT IN( SELECT object_name '
            || '                          FROM recyclebin) '
            || 'AND object_name NOT IN( ''ATTACHED_SPECIFICATION'',''BOM_HEADER'',''BOM_ITEM'',''ITSHBN'','
            || '                        ''ITSHDESCR_L'',''ITSHLNPROPLANG'',''PART'',''PART_PLANT'',''PLANT'', '                                         
            || '                        ''REASON'',''SPECDATA'',''SPECDATA_PROCESS'',''SPECIFICATION_CD'', '                                                                
            || '                        ''SPECIFICATION_HEADER'',''SPECIFICATION_ING'',''SPECIFICATION_ING_LANG'', '
            || '                        ''SPECIFICATION_LINE'',''SPECIFICATION_LINE_PROP'',''SPECIFICATION_LINE_TEXT'', '
            || '                        ''SPECIFICATION_PROP'',''SPECIFICATION_PROP_LANG'',''SPECIFICATION_SECTION'', '
            
            
            || '                        ''SPECIFICATION_STAGE'',''SPECIFICATION_TEXT'',''SPECIFICATION_TEXT_NORTF'',''SPECIFICATION_TM'' ) '
            
            || 'AND object_name NOT IN( ''IVATTACHED_SPECIFICATION'',''IVBOM_HEADER'',''IVBOM_ITEM'',''IVITSHBN'','
            || '                        ''IVITSHDESCR_L'',''IVITSHLNPROPLANG'',''IVPART'',''IVPART_PLANT'',''IVPLANT'', '
            || '                        ''IVREASON'',''IVSPECDATA'',''IVSPECDATA_PROCESS'',''IVSPECIFICATION_CD'', '
            || '                        ''IVSPECIFICATION_HEADER'',''IVSPECIFICATION_ING'',''IVSPECIFICATION_ING_LANG'', '
            || '                        ''IVSPECIFICATION_LINE'',''IVSPECIFICATION_LINE_PROP'',''IVSPECIFICATION_LINE_TEXT'', '
            || '                        ''IVSPECIFICATION_PROP'',''IVSPECIFICATION_PROP_LANG'',''IVSPECIFICATION_SECTION'', '
            
            
            || '                        ''IVSPECIFICATION_STAGE'',''IVSPECIFICATION_TEXT'',''IVSPECIFICATION_TEXT_NORTF'',''IVSPECIFICATION_TM'' ) ';            
            


         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              LSSQL10,
                              IAPICONSTANT.INFOLEVEL_3 );

         EXECUTE IMMEDIATE LSSQL10
         BULK COLLECT INTO LTOBJECTNAMES;

         IF LTOBJECTNAMES.COUNT <> 0
         THEN
            FOR LSOBJECTNAME IN LTOBJECTNAMES.FIRST .. LTOBJECTNAMES.LAST
            LOOP

               LSSQL :=    'CREATE PUBLIC SYNONYM '
                        || LTOBJECTNAMES( LSOBJECTNAME )
                        || ' FOR '
                        || LSSCHEMANAME
                        || '.'
                        || LTOBJECTNAMES( LSOBJECTNAME );




               DBMS_SQL.PARSE( LICURSOR,
                               LSSQL,
                               DBMS_SQL.V7 );
               LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );

            END LOOP;
         END IF;
      ELSE
         FOR LRREC IN LQCREATESYN( LSSCHEMANAME )
         LOOP
            LSSQL :=    'CREATE PUBLIC SYNONYM '
                     || LRREC.OBJECT_NAME
                     || ' FOR '
                     || LSSCHEMANAME
                     || '.'
                     || LRREC.OBJECT_NAME;


            DBMS_SQL.PARSE( LICURSOR,
                            LSSQL,
                            DBMS_SQL.V7 );
            LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );
         END LOOP;
      END IF;

      DBMS_SQL.CLOSE_CURSOR( LICURSOR );




      FOR LSTABLENAME IN LQTABLES
      LOOP
         LICURSOR := DBMS_SQL.OPEN_CURSOR;
         LSSQL :=    'CREATE PUBLIC SYNONYM '
                  || LSTABLENAME.TABLE_NAME
                  || ' FOR IV'
                  || LSTABLENAME.TABLE_NAME;
         DBMS_SQL.PARSE( LICURSOR,
                         LSSQL,
                         DBMS_SQL.V7 );
         LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );
         DBMS_SQL.CLOSE_CURSOR( LICURSOR );
      END LOOP;





      FOR LSVIEWNAME IN LQVIEWS
      LOOP
         LICURSOR := DBMS_SQL.OPEN_CURSOR;
         LSSQL :=    'CREATE PUBLIC SYNONYM '
                  
                   || SUBSTR (LSVIEWNAME.OBJECT_NAME, 3)
                  || ' FOR '
                  || LSVIEWNAME.OBJECT_NAME;
         DBMS_SQL.PARSE( LICURSOR,
                         LSSQL,
                         DBMS_SQL.V7 );
         LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );
         DBMS_SQL.CLOSE_CURSOR( LICURSOR );
      END LOOP;

      
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         ROLLBACK;

         IF DBMS_SQL.IS_OPEN( LICURSOR )
         THEN
            DBMS_SQL.CLOSE_CURSOR( LICURSOR );
         END IF;

         IF LQCREATESYN%ISOPEN
         THEN
            CLOSE LQCREATESYN;
         END IF;

         IF LQTABLES%ISOPEN
         THEN
            CLOSE LQTABLES;
         END IF;

         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END CREATESYNONYMS;


   FUNCTION DROPSYNONYMS
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS











      CURSOR LQDROPSYN(
         ASSCHEMANAME               IN       IAPITYPE.DATABASESCHEMANAME_TYPE )
      IS
         SELECT SYNONYM_NAME
           FROM DBA_SYNONYMS
          WHERE TABLE_OWNER = ASSCHEMANAME
            AND SYNONYM_NAME NOT IN( SELECT OBJECT_NAME
                                      FROM DBA_OBJECTS
                                     WHERE OWNER = ASSCHEMANAME
                                       AND OBJECT_TYPE NOT IN( 'SYNONYM', 'TRIGGER', 'INDEX', 'DATABASE LINK', 'LOB' ) );

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'DropSynonyms';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSCHEMANAME                  IAPITYPE.DATABASESCHEMANAME_TYPE;
      LRREC                         LQDROPSYN%ROWTYPE;
      LSSQL                         VARCHAR2( 2000 );
      LIRESULT                      INTEGER;
      LICURSOR                      INTEGER;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIDATABASE.GETSCHEMANAME( LSSCHEMANAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      LICURSOR := DBMS_SQL.OPEN_CURSOR;

      FOR LRREC IN LQDROPSYN( LSSCHEMANAME )
      LOOP
         LSSQL :=    'DROP PUBLIC SYNONYM '
                  || LRREC.SYNONYM_NAME;
         DBMS_SQL.PARSE( LICURSOR,
                         LSSQL,
                         DBMS_SQL.V7 );
         LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );
      END LOOP;

      DBMS_SQL.CLOSE_CURSOR( LICURSOR );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         ROLLBACK;

         IF DBMS_SQL.IS_OPEN( LICURSOR )
         THEN
            DBMS_SQL.CLOSE_CURSOR( LICURSOR );
         END IF;

         IF LQDROPSYN%ISOPEN
         THEN
            CLOSE LQDROPSYN;
         END IF;

         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END DROPSYNONYMS;


   FUNCTION RECREATESYNONYMS
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS












      CURSOR LQDROPSYN(
         ASSCHEMANAME               IN       IAPITYPE.DATABASESCHEMANAME_TYPE )
      IS
         SELECT SYNONYM_NAME
           FROM DBA_SYNONYMS
          WHERE TABLE_OWNER = ASSCHEMANAME
            
            
            AND SYNONYM_NAME IN( SELECT OBJECT_NAME
            
                                      FROM DBA_OBJECTS
                                     WHERE OWNER = ASSCHEMANAME
                                       AND OBJECT_TYPE NOT IN( 'SYNONYM', 'TRIGGER', 'INDEX', 'DATABASE LINK', 'LOB' ) );














      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RecreateSynonyms';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSCHEMANAME                  IAPITYPE.DATABASESCHEMANAME_TYPE;


      LRRECDEL                      LQDROPSYN%ROWTYPE;
      LSSQL                         VARCHAR2( 2000 );
      LIRESULT                      INTEGER;
      LICURSOR                      INTEGER;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIDATABASE.GETSCHEMANAME( LSSCHEMANAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      LICURSOR := DBMS_SQL.OPEN_CURSOR;

      FOR LRRECDEL IN LQDROPSYN( LSSCHEMANAME )
      LOOP
         LSSQL :=    'DROP PUBLIC SYNONYM '
                  || LRRECDEL.SYNONYM_NAME;
         DBMS_SQL.PARSE( LICURSOR,
                         LSSQL,
                         DBMS_SQL.V7 );
         LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );
      END LOOP;

      LNRETVAL := IAPIDATABASE.CREATESYNONYMS;

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      DBMS_SQL.CLOSE_CURSOR( LICURSOR );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         ROLLBACK;

         IF DBMS_SQL.IS_OPEN( LICURSOR )
         THEN
            DBMS_SQL.CLOSE_CURSOR( LICURSOR );
         END IF;

         IF LQDROPSYN%ISOPEN
         THEN
            CLOSE LQDROPSYN;
         END IF;







         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END RECREATESYNONYMS;


   FUNCTION ENABLECONSTRAINTS
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS











      CURSOR LQENABLECONST(
         ASSCHEMANAME               IN       IAPITYPE.DATABASESCHEMANAME_TYPE )
      IS
         SELECT CONSTRAINT_NAME,
                TABLE_NAME
           FROM DBA_CONSTRAINTS
          WHERE OWNER = ASSCHEMANAME
            AND CONSTRAINT_TYPE = 'R'
            AND STATUS = 'DISABLED';

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'EnableConstraints';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSCHEMANAME                  IAPITYPE.DATABASESCHEMANAME_TYPE;
      LRREC                         LQENABLECONST%ROWTYPE;
      LSSQL                         VARCHAR2( 2000 );
      LIRESULT                      INTEGER;
      LICURSOR                      INTEGER;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIDATABASE.GETSCHEMANAME( LSSCHEMANAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      LICURSOR := DBMS_SQL.OPEN_CURSOR;

      FOR LRREC IN LQENABLECONST( LSSCHEMANAME )
      LOOP
         BEGIN
            LSSQL :=    'ALTER TABLE '
                     || LSSCHEMANAME
                     || '.'
                     || LRREC.TABLE_NAME
                     || ' ENABLE CONSTRAINT '
                     || LRREC.CONSTRAINT_NAME;
            DBMS_SQL.PARSE( LICURSOR,
                            LSSQL,
                            DBMS_SQL.V7 );
            LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );
         EXCEPTION
            WHEN OTHERS
            THEN
               IAPIGENERAL.LOGINFO( GSSOURCE,
                                    LSMETHOD,
                                    SQLERRM,
                                    IAPICONSTANT.INFOLEVEL_3 );
         END;
      END LOOP;

      DBMS_SQL.CLOSE_CURSOR( LICURSOR );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         ROLLBACK;

         IF DBMS_SQL.IS_OPEN( LICURSOR )
         THEN
            DBMS_SQL.CLOSE_CURSOR( LICURSOR );
         END IF;

         IF LQENABLECONST%ISOPEN
         THEN
            CLOSE LQENABLECONST;
         END IF;

         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ENABLECONSTRAINTS;


   FUNCTION DISABLECONSTRAINTS
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS











      CURSOR LQDISABLECONST(
         ASSCHEMANAME               IN       IAPITYPE.DATABASESCHEMANAME_TYPE )
      IS
         SELECT CONSTRAINT_NAME,
                TABLE_NAME
           FROM DBA_CONSTRAINTS
          WHERE OWNER = ASSCHEMANAME
            AND CONSTRAINT_TYPE = 'R'
            AND STATUS = 'ENABLED';

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'DisableConstraints';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSCHEMANAME                  IAPITYPE.DATABASESCHEMANAME_TYPE;
      LRREC                         LQDISABLECONST%ROWTYPE;
      LSSQL                         VARCHAR2( 2000 );
      LIRESULT                      INTEGER;
      LICURSOR                      INTEGER;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIDATABASE.GETSCHEMANAME( LSSCHEMANAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      LICURSOR := DBMS_SQL.OPEN_CURSOR;

      FOR LRREC IN LQDISABLECONST( LSSCHEMANAME )
      LOOP
         LSSQL :=    'ALTER TABLE '
                  || LSSCHEMANAME
                  || '.'
                  || LRREC.TABLE_NAME
                  || ' DISABLE CONSTRAINT '
                  || LRREC.CONSTRAINT_NAME;
         DBMS_SQL.PARSE( LICURSOR,
                         LSSQL,
                         DBMS_SQL.V7 );
         LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );
      END LOOP;

      DBMS_SQL.CLOSE_CURSOR( LICURSOR );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         ROLLBACK;

         IF DBMS_SQL.IS_OPEN( LICURSOR )
         THEN
            DBMS_SQL.CLOSE_CURSOR( LICURSOR );
         END IF;

         IF LQDISABLECONST%ISOPEN
         THEN
            CLOSE LQDISABLECONST;
         END IF;

         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END DISABLECONSTRAINTS;


   FUNCTION ENABLETRIGGERS
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      CURSOR LQENABLETRIGGERS(
         ASSCHEMANAME               IN       IAPITYPE.DATABASESCHEMANAME_TYPE )
      IS
         SELECT TRIGGER_NAME
           FROM DBA_TRIGGERS
          WHERE OWNER = ASSCHEMANAME
            AND STATUS = 'DISABLED';

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'EnableTriggers';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSCHEMANAME                  IAPITYPE.DATABASESCHEMANAME_TYPE;
      LRREC                         LQENABLETRIGGERS%ROWTYPE;
      LSSQL                         VARCHAR2( 2000 );
      LIRESULT                      INTEGER;
      LICURSOR                      INTEGER;
      LNVERSIONNUMBER               NUMBER;

      TYPE LTOBJECTNAME IS TABLE OF VARCHAR2( 128 );

      LTOBJECTNAMES                 LTOBJECTNAME;
      LSSQL10                       VARCHAR2( 1000 ) := NULL;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIDATABASE.GETSCHEMANAME( LSSCHEMANAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      SELECT TO_NUMBER( SUBSTR( VERSION,
                                1,
                                  INSTR( VERSION,
                                         '.' )
                                - 1 ) )
        INTO LNVERSIONNUMBER
        FROM V$INSTANCE;

      LICURSOR := DBMS_SQL.OPEN_CURSOR;

      IF LNVERSIONNUMBER >= 10
      THEN
         LSSQL10 :=
               ' SELECT trigger_name '
            || 'FROM dba_triggers '
            || 'WHERE owner = '''
            || LSSCHEMANAME
            || ''' AND status = ''DISABLED'' '
            || 'AND trigger_name NOT IN( SELECT object_name '
            || 'FROM recyclebin '
            || 'WHERE type = ''TRIGGER'' )';

         EXECUTE IMMEDIATE LSSQL10
         BULK COLLECT INTO LTOBJECTNAMES;

         FOR LSOBJECTNAME IN LTOBJECTNAMES.FIRST .. LTOBJECTNAMES.LAST
         LOOP
            LSSQL :=    'ALTER TRIGGER '
                     || LSSCHEMANAME
                     || '.'
                     || LTOBJECTNAMES( LSOBJECTNAME )
                     || ' ENABLE ';
            DBMS_SQL.PARSE( LICURSOR,
                            LSSQL,
                            DBMS_SQL.V7 );
            LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );
         END LOOP;
      ELSE
         FOR LRREC IN LQENABLETRIGGERS( LSSCHEMANAME )
         LOOP
            LSSQL :=    'ALTER TRIGGER '
                     || LSSCHEMANAME
                     || '.'
                     || LRREC.TRIGGER_NAME
                     || ' ENABLE ';
            DBMS_SQL.PARSE( LICURSOR,
                            LSSQL,
                            DBMS_SQL.V7 );
            LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );
         END LOOP;
      END IF;

      DBMS_SQL.CLOSE_CURSOR( LICURSOR );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         ROLLBACK;

         IF DBMS_SQL.IS_OPEN( LICURSOR )
         THEN
            DBMS_SQL.CLOSE_CURSOR( LICURSOR );
         END IF;

         IF LQENABLETRIGGERS%ISOPEN
         THEN
            CLOSE LQENABLETRIGGERS;
         END IF;

         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ENABLETRIGGERS;


   FUNCTION DISABLETRIGGERS
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      CURSOR LQDISABLETRIGGERS(
         ASSCHEMANAME               IN       IAPITYPE.DATABASESCHEMANAME_TYPE )
      IS
         SELECT TRIGGER_NAME
           FROM DBA_TRIGGERS
          WHERE OWNER = ASSCHEMANAME
            AND STATUS = 'ENABLED';

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'DisableTriggers';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSCHEMANAME                  IAPITYPE.DATABASESCHEMANAME_TYPE;
      LRREC                         LQDISABLETRIGGERS%ROWTYPE;
      LSSQL                         VARCHAR2( 2000 );
      LIRESULT                      INTEGER;
      LICURSOR                      INTEGER;
      LNVERSIONNUMBER               NUMBER;

      TYPE LTOBJECTNAME IS TABLE OF VARCHAR2( 128 );

      LTOBJECTNAMES                 LTOBJECTNAME;
      LSSQL10                       VARCHAR2( 1000 ) := NULL;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIDATABASE.GETSCHEMANAME( LSSCHEMANAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      SELECT TO_NUMBER( SUBSTR( VERSION,
                                1,
                                  INSTR( VERSION,
                                         '.' )
                                - 1 ) )
        INTO LNVERSIONNUMBER
        FROM V$INSTANCE;

      LICURSOR := DBMS_SQL.OPEN_CURSOR;

      IF LNVERSIONNUMBER >= 10
      THEN
         LSSQL10 :=
               ' SELECT trigger_name '
            || 'FROM dba_triggers '
            || 'WHERE owner = '''
            || LSSCHEMANAME
            || ''' AND status = ''ENABLED'' '
            || 'AND trigger_name NOT IN( SELECT object_name '
            || 'FROM recyclebin '
            || 'WHERE type = ''TRIGGER'' )';

         EXECUTE IMMEDIATE LSSQL10
         BULK COLLECT INTO LTOBJECTNAMES;

         FOR LSOBJECTNAME IN LTOBJECTNAMES.FIRST .. LTOBJECTNAMES.LAST
         LOOP
            LSSQL :=    'ALTER TRIGGER '
                     || LSSCHEMANAME
                     || '.'
                     || LTOBJECTNAMES( LSOBJECTNAME )
                     || ' DISABLE ';
            DBMS_SQL.PARSE( LICURSOR,
                            LSSQL,
                            DBMS_SQL.V7 );
            LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );
         END LOOP;
      ELSE
         FOR LRREC IN LQDISABLETRIGGERS( LSSCHEMANAME )
         LOOP
            LSSQL :=    'ALTER TRIGGER '
                     || LSSCHEMANAME
                     || '.'
                     || LRREC.TRIGGER_NAME
                     || ' DISABLE ';
            DBMS_SQL.PARSE( LICURSOR,
                            LSSQL,
                            DBMS_SQL.V7 );
            LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );
         END LOOP;
      END IF;

      DBMS_SQL.CLOSE_CURSOR( LICURSOR );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         ROLLBACK;

         IF DBMS_SQL.IS_OPEN( LICURSOR )
         THEN
            DBMS_SQL.CLOSE_CURSOR( LICURSOR );
         END IF;

         IF LQDISABLETRIGGERS%ISOPEN
         THEN
            CLOSE LQDISABLETRIGGERS;
         END IF;

         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END DISABLETRIGGERS;


   FUNCTION DROPTRIGGERS
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      CURSOR LQDROPTRIGGERS(
         ASSCHEMANAME               IN       IAPITYPE.DATABASESCHEMANAME_TYPE )
      IS
         SELECT *
           FROM DBA_OBJECTS
          WHERE OWNER = ASSCHEMANAME
            AND OBJECT_TYPE = 'TRIGGER';

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'DropTriggers';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSCHEMANAME                  IAPITYPE.DATABASESCHEMANAME_TYPE;
      LRREC                         LQDROPTRIGGERS%ROWTYPE;
      LSSQL                         VARCHAR2( 2000 );
      LIRESULT                      INTEGER;
      LICURSOR                      INTEGER;
      LNCOUNT                       NUMBER;
      LNVERSIONNUMBER               NUMBER;

      TYPE LTOBJECTNAME IS TABLE OF VARCHAR2( 128 );

      LTOBJECTNAMES                 LTOBJECTNAME;
      LSSQL10                       VARCHAR2( 1000 ) := NULL;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIDATABASE.GETSCHEMANAME( LSSCHEMANAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      SELECT TO_NUMBER( SUBSTR( VERSION,
                                1,
                                  INSTR( VERSION,
                                         '.' )
                                - 1 ) )
        INTO LNVERSIONNUMBER
        FROM V$INSTANCE;

      LICURSOR := DBMS_SQL.OPEN_CURSOR;

      IF LNVERSIONNUMBER >= 10
      THEN
         LSSQL10 :=
               'SELECT object_name '
            || 'FROM dba_objects '
            || 'WHERE owner = '''
            || LSSCHEMANAME
            || ''' AND object_type = ''TRIGGER'' '
            || 'AND object_name NOT IN( SELECT object_name '
            || 'FROM recyclebin '
            || 'WHERE type = ''TRIGGER'' )';

         EXECUTE IMMEDIATE LSSQL10
         BULK COLLECT INTO LTOBJECTNAMES;

         IF LTOBJECTNAMES.COUNT <> 0
         THEN
            FOR LSOBJECTNAME IN LTOBJECTNAMES.FIRST .. LTOBJECTNAMES.LAST
            LOOP
               LSSQL :=    'DROP TRIGGER '
                        || LSSCHEMANAME
                        || '.'
                        || LTOBJECTNAMES( LSOBJECTNAME );
               DBMS_SQL.PARSE( LICURSOR,
                               LSSQL,
                               DBMS_SQL.V7 );
               LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );
            END LOOP;
         END IF;
      ELSE
         FOR LRREC IN LQDROPTRIGGERS( LSSCHEMANAME )
         LOOP
            LSSQL :=    'DROP TRIGGER '
                     || LSSCHEMANAME
                     || '.'
                     || LRREC.OBJECT_NAME;
            DBMS_SQL.PARSE( LICURSOR,
                            LSSQL,
                            DBMS_SQL.V7 );
            LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );
         END LOOP;
      END IF;

      DBMS_SQL.CLOSE_CURSOR( LICURSOR );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         ROLLBACK;

         IF DBMS_SQL.IS_OPEN( LICURSOR )
         THEN
            DBMS_SQL.CLOSE_CURSOR( LICURSOR );
         END IF;

         IF LQDROPTRIGGERS%ISOPEN
         THEN
            CLOSE LQDROPTRIGGERS;
         END IF;

         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END DROPTRIGGERS;


   FUNCTION COMPILE(
      ASOBJECTNAME               IN       IAPITYPE.DATABASEOBJECTNAME_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      CURSOR LQOBJECT(
         ASSCHEMANAME               IN       IAPITYPE.DATABASESCHEMANAME_TYPE )
      IS
         SELECT *
           FROM ALL_OBJECTS
          WHERE OWNER = ASSCHEMANAME
            AND OBJECT_NAME = UPPER( ASOBJECTNAME )
            AND STATUS = 'INVALID';

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'Compile';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSCHEMANAME                  IAPITYPE.DATABASESCHEMANAME_TYPE;
      LRREC                         LQOBJECT%ROWTYPE;
      LSSQL                         VARCHAR2( 2000 );
      LIRESULT                      INTEGER;
      LICURSOR                      INTEGER;
      LNCOUNT                       NUMBER;
   BEGIN



EXECUTE IMMEDIATE('ALTER SESSION SET NLS_LENGTH_SEMANTICS=CHAR'); 

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIDATABASE.GETSCHEMANAME( LSSCHEMANAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;









      LICURSOR := DBMS_SQL.OPEN_CURSOR;

      FOR LRREC IN LQOBJECT( LSSCHEMANAME )
      LOOP
         BEGIN
            IF LRREC.OBJECT_TYPE = 'PACKAGE BODY'
            THEN
               LSSQL :=    'ALTER PACKAGE '
                        || LRREC.OBJECT_NAME
                        || ' COMPILE BODY';
            ELSE
               LSSQL :=    'ALTER '
                        || LRREC.OBJECT_TYPE
                        || '  '
                        || LRREC.OBJECT_NAME
                        || ' COMPILE';
            END IF;

            DBMS_SQL.PARSE( LICURSOR,
                            LSSQL,
                            DBMS_SQL.V7 );

            BEGIN
               LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );
               IAPIGENERAL.LOGINFO( GSSOURCE,
                                    LSMETHOD,
                                    LSSQL,
                                    IAPICONSTANT.INFOLEVEL_3 );
            EXCEPTION
               WHEN OTHERS
               THEN
                  IAPIGENERAL.LOGINFO( GSSOURCE,
                                       LSMETHOD,
                                          LSSQL
                                       || ' - An error occurred: '
                                       || SQLERRM,
                                       IAPICONSTANT.INFOLEVEL_3 );
            END;
         EXCEPTION
            WHEN OTHERS
            THEN
               IAPIGENERAL.LOGINFO( GSSOURCE,
                                    LSMETHOD,
                                       LSSQL
                                    || ' - An error occurred: '
                                    || SQLERRM,
                                    IAPICONSTANT.INFOLEVEL_3 );
         END;
      END LOOP;

      DBMS_SQL.CLOSE_CURSOR( LICURSOR );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         ROLLBACK;

         IF DBMS_SQL.IS_OPEN( LICURSOR )
         THEN
            DBMS_SQL.CLOSE_CURSOR( LICURSOR );
         END IF;

         IF LQOBJECT%ISOPEN
         THEN
            CLOSE LQOBJECT;
         END IF;

         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END COMPILE;


   FUNCTION COMPILEINVALIDALL
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS












      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CompileInvalidAll';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNCOUNT                       NUMBER;
      LNSTATUSJOB                   IAPITYPE.PARAMETERDATA_TYPE;
   BEGIN



EXECUTE IMMEDIATE('ALTER SESSION SET NLS_LENGTH_SEMANTICS=CHAR'); 
   
   IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );






















      FOR LNCOUNT IN 1 .. 2
      LOOP
         LNRETVAL := IAPIDATABASE.COMPILEINVALIDPACKAGES( );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;

         LNRETVAL := IAPIDATABASE.COMPILEINVALIDPROCEDURES( );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;

         LNRETVAL := IAPIDATABASE.COMPILEINVALIDFUNCTIONS( );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;
      END LOOP;

      FOR LNCOUNT IN 1 .. 2
      LOOP
         LNRETVAL := IAPIDATABASE.COMPILEINVALIDTRIGGERS( );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;

         LNRETVAL := IAPIDATABASE.COMPILEINVALIDVIEWS( );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;
      END LOOP;








      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END COMPILEINVALIDALL;


   FUNCTION COMPILEINVALIDTRIGGERS
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      CURSOR LQINVALIDTRIGGERS(
         ASSCHEMANAME               IN       IAPITYPE.DATABASESCHEMANAME_TYPE )
      IS
         SELECT *
           FROM ALL_OBJECTS
          WHERE OWNER = ASSCHEMANAME
            AND OBJECT_TYPE = 'TRIGGER'
            AND STATUS = 'INVALID';

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CompileInvalidTriggers';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSCHEMANAME                  IAPITYPE.DATABASESCHEMANAME_TYPE;
      LRREC                         LQINVALIDTRIGGERS%ROWTYPE;
      LSSQL                         VARCHAR2( 2000 );
      LIRESULT                      INTEGER;
      LICURSOR                      INTEGER;
      LNCOUNT                       NUMBER;
   BEGIN



EXECUTE IMMEDIATE('ALTER SESSION SET NLS_LENGTH_SEMANTICS=CHAR'); 
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIDATABASE.GETSCHEMANAME( LSSCHEMANAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;









      LICURSOR := DBMS_SQL.OPEN_CURSOR;

      FOR LRREC IN LQINVALIDTRIGGERS( LSSCHEMANAME )
      LOOP
         BEGIN
            LSSQL :=    'ALTER '
                     || LRREC.OBJECT_TYPE
                     || '  '
                     || LRREC.OBJECT_NAME
                     || ' COMPILE';
            DBMS_SQL.PARSE( LICURSOR,
                            LSSQL,
                            DBMS_SQL.V7 );

            BEGIN
               LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );
               IAPIGENERAL.LOGINFO( GSSOURCE,
                                    LSMETHOD,
                                    LSSQL,
                                    IAPICONSTANT.INFOLEVEL_3 );
            EXCEPTION
               WHEN OTHERS
               THEN
                  IAPIGENERAL.LOGINFO( GSSOURCE,
                                       LSMETHOD,
                                          LSSQL
                                       || ' - An error occurred: '
                                       || SQLERRM,
                                       IAPICONSTANT.INFOLEVEL_3 );
            END;
         EXCEPTION
            WHEN OTHERS
            THEN
               IAPIGENERAL.LOGINFO( GSSOURCE,
                                    LSMETHOD,
                                       LSSQL
                                    || ' - An error occurred: '
                                    || SQLERRM,
                                    IAPICONSTANT.INFOLEVEL_3 );
         END;
      END LOOP;

      DBMS_SQL.CLOSE_CURSOR( LICURSOR );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         ROLLBACK;

         IF DBMS_SQL.IS_OPEN( LICURSOR )
         THEN
            DBMS_SQL.CLOSE_CURSOR( LICURSOR );
         END IF;

         IF LQINVALIDTRIGGERS%ISOPEN
         THEN
            CLOSE LQINVALIDTRIGGERS;
         END IF;

         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END COMPILEINVALIDTRIGGERS;


   FUNCTION COMPILEINVALIDPACKAGES
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS











      CURSOR LQINVALIDPACKAGES(
         ASSCHEMANAME               IN       IAPITYPE.DATABASESCHEMANAME_TYPE )
      IS
         SELECT *
           FROM ALL_OBJECTS
          WHERE OWNER = ASSCHEMANAME
            AND OBJECT_TYPE IN( 'PACKAGE', 'PACKAGE BODY' )
            AND STATUS = 'INVALID';

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CompileInvalidPackages';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSCHEMANAME                  IAPITYPE.DATABASESCHEMANAME_TYPE;
      LRREC                         LQINVALIDPACKAGES%ROWTYPE;
      LSSQL                         VARCHAR2( 2000 );
      LIRESULT                      INTEGER;
      LICURSOR                      INTEGER;
      LNCOUNT                       NUMBER;
   BEGIN



EXECUTE IMMEDIATE('ALTER SESSION SET NLS_LENGTH_SEMANTICS=CHAR'); 

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIDATABASE.GETSCHEMANAME( LSSCHEMANAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;









      LICURSOR := DBMS_SQL.OPEN_CURSOR;

      FOR LRREC IN LQINVALIDPACKAGES( LSSCHEMANAME )
      LOOP
         BEGIN
            IF LRREC.OBJECT_TYPE = 'PACKAGE BODY'
            THEN
               LSSQL :=    'ALTER PACKAGE '
                        || LRREC.OBJECT_NAME
                        || ' COMPILE BODY';
            ELSE
               LSSQL :=    'ALTER '
                        || LRREC.OBJECT_TYPE
                        || '  '
                        || LRREC.OBJECT_NAME
                        || ' COMPILE';
            END IF;

            DBMS_SQL.PARSE( LICURSOR,
                            LSSQL,
                            DBMS_SQL.V7 );

            BEGIN
               LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );
               IAPIGENERAL.LOGINFO( GSSOURCE,
                                    LSMETHOD,
                                    LSSQL,
                                    IAPICONSTANT.INFOLEVEL_3 );
            EXCEPTION
               WHEN OTHERS
               THEN
                  IAPIGENERAL.LOGINFO( GSSOURCE,
                                       LSMETHOD,
                                          LSSQL
                                       || ' - An error occurred: '
                                       || SQLERRM,
                                       IAPICONSTANT.INFOLEVEL_3 );
            END;
         EXCEPTION
            WHEN OTHERS
            THEN
               IAPIGENERAL.LOGINFO( GSSOURCE,
                                    LSMETHOD,
                                       LSSQL
                                    || ' - An error occurred: '
                                    || SQLERRM,
                                    IAPICONSTANT.INFOLEVEL_3 );
         END;
      END LOOP;

      DBMS_SQL.CLOSE_CURSOR( LICURSOR );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         ROLLBACK;

         IF DBMS_SQL.IS_OPEN( LICURSOR )
         THEN
            DBMS_SQL.CLOSE_CURSOR( LICURSOR );
         END IF;

         IF LQINVALIDPACKAGES%ISOPEN
         THEN
            CLOSE LQINVALIDPACKAGES;
         END IF;

         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END COMPILEINVALIDPACKAGES;


   FUNCTION COMPILEINVALIDFUNCTIONS
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS











      CURSOR LQINVALIDFUNCTIONS(
         ASSCHEMANAME               IN       IAPITYPE.DATABASESCHEMANAME_TYPE )
      IS
         SELECT *
           FROM ALL_OBJECTS
          WHERE OWNER = ASSCHEMANAME
            AND OBJECT_TYPE = 'FUNCTION'
            AND STATUS = 'INVALID';
		 
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CompileInvalidFunctions';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSCHEMANAME                  IAPITYPE.DATABASESCHEMANAME_TYPE;
      LRREC                         LQINVALIDFUNCTIONS%ROWTYPE;
      LSSQL                         VARCHAR2( 2000 );
      LIRESULT                      INTEGER;
      LICURSOR                      INTEGER;
      LNCOUNT                       NUMBER;
   BEGIN



EXECUTE IMMEDIATE('ALTER SESSION SET NLS_LENGTH_SEMANTICS=CHAR'); 

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIDATABASE.GETSCHEMANAME( LSSCHEMANAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;









      LICURSOR := DBMS_SQL.OPEN_CURSOR;

      FOR LRREC IN LQINVALIDFUNCTIONS( LSSCHEMANAME )
      LOOP
         BEGIN
            LSSQL :=    'ALTER '
                     || LRREC.OBJECT_TYPE
                     || '  '
                     || LRREC.OBJECT_NAME
                     || ' COMPILE';
            DBMS_SQL.PARSE( LICURSOR,
                            LSSQL,
                            DBMS_SQL.V7 );

            BEGIN
               LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );
               IAPIGENERAL.LOGINFO( GSSOURCE,
                                    LSMETHOD,
                                    LSSQL,
                                    IAPICONSTANT.INFOLEVEL_3 );
            EXCEPTION
               WHEN OTHERS
               THEN
                  IAPIGENERAL.LOGINFO( GSSOURCE,
                                       LSMETHOD,
                                          LSSQL
                                       || ' - An error occurred: '
                                       || SQLERRM,
                                       IAPICONSTANT.INFOLEVEL_3 );
            END;
         EXCEPTION
            WHEN OTHERS
            THEN
               IAPIGENERAL.LOGINFO( GSSOURCE,
                                    LSMETHOD,
                                       LSSQL
                                    || ' - An error occurred: '
                                    || SQLERRM,
                                    IAPICONSTANT.INFOLEVEL_3 );
         END;
      END LOOP;

      DBMS_SQL.CLOSE_CURSOR( LICURSOR );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         ROLLBACK;

         IF DBMS_SQL.IS_OPEN( LICURSOR )
         THEN
            DBMS_SQL.CLOSE_CURSOR( LICURSOR );
         END IF;

         IF LQINVALIDFUNCTIONS%ISOPEN
         THEN
            CLOSE LQINVALIDFUNCTIONS;
         END IF;

         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END COMPILEINVALIDFUNCTIONS;


   FUNCTION COMPILEINVALIDPROCEDURES
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS











      CURSOR LQINVALIDPROCS(
         ASSCHEMANAME               IN       IAPITYPE.DATABASESCHEMANAME_TYPE )
      IS
         SELECT *
           FROM ALL_OBJECTS
          WHERE OWNER = ASSCHEMANAME
            AND OBJECT_TYPE = 'PROCEDURE'
            AND STATUS = 'INVALID';

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CompileInvalidProcedures';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSCHEMANAME                  IAPITYPE.DATABASESCHEMANAME_TYPE;
      LRREC                         LQINVALIDPROCS%ROWTYPE;
      LSSQL                         VARCHAR2( 2000 );
      LIRESULT                      INTEGER;
      LICURSOR                      INTEGER;
      LNCOUNT                       NUMBER;
   BEGIN



EXECUTE IMMEDIATE('ALTER SESSION SET NLS_LENGTH_SEMANTICS=CHAR'); 

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIDATABASE.GETSCHEMANAME( LSSCHEMANAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;









      LICURSOR := DBMS_SQL.OPEN_CURSOR;

      FOR LRREC IN LQINVALIDPROCS( LSSCHEMANAME )
      LOOP
         BEGIN
            LSSQL :=    'ALTER '
                     || LRREC.OBJECT_TYPE
                     || '  '
                     || LRREC.OBJECT_NAME
                     || ' COMPILE';
            DBMS_SQL.PARSE( LICURSOR,
                            LSSQL,
                            DBMS_SQL.V7 );

            BEGIN
               LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );
               IAPIGENERAL.LOGINFO( GSSOURCE,
                                    LSMETHOD,
                                    LSSQL,
                                    IAPICONSTANT.INFOLEVEL_3 );
            EXCEPTION
               WHEN OTHERS
               THEN
                  IAPIGENERAL.LOGINFO( GSSOURCE,
                                       LSMETHOD,
                                          LSSQL
                                       || ' - An error occurred: '
                                       || SQLERRM,
                                       IAPICONSTANT.INFOLEVEL_3 );
            END;
         EXCEPTION
            WHEN OTHERS
            THEN
               IAPIGENERAL.LOGINFO( GSSOURCE,
                                    LSMETHOD,
                                       LSSQL
                                    || ' - An error occurred: '
                                    || SQLERRM,
                                    IAPICONSTANT.INFOLEVEL_3 );
         END;
      END LOOP;

      DBMS_SQL.CLOSE_CURSOR( LICURSOR );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         ROLLBACK;

         IF DBMS_SQL.IS_OPEN( LICURSOR )
         THEN
            DBMS_SQL.CLOSE_CURSOR( LICURSOR );
         END IF;

         IF LQINVALIDPROCS%ISOPEN
         THEN
            CLOSE LQINVALIDPROCS;
         END IF;

         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END COMPILEINVALIDPROCEDURES;

   FUNCTION COMPILEINVALIDVIEWS
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS











      CURSOR LQINVALIDVIEWS(
         ASSCHEMANAME               IN       IAPITYPE.DATABASESCHEMANAME_TYPE )
      IS
         SELECT *
           FROM ALL_OBJECTS
          WHERE OWNER = ASSCHEMANAME
            AND OBJECT_TYPE = 'VIEW'
            AND STATUS = 'INVALID';

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CompileInvalidViews';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSCHEMANAME                  IAPITYPE.DATABASESCHEMANAME_TYPE;
      LRREC                         LQINVALIDVIEWS%ROWTYPE;
      LSSQL                         VARCHAR2( 2000 );
      LIRESULT                      INTEGER;
      LICURSOR                      INTEGER;
      LNCOUNT                       NUMBER;
   BEGIN



EXECUTE IMMEDIATE('ALTER SESSION SET NLS_LENGTH_SEMANTICS=CHAR'); 

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIDATABASE.GETSCHEMANAME( LSSCHEMANAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;









      LICURSOR := DBMS_SQL.OPEN_CURSOR;

      FOR LRREC IN LQINVALIDVIEWS( LSSCHEMANAME )
      LOOP
         BEGIN
            LSSQL :=    'ALTER '
                     || LRREC.OBJECT_TYPE
                     || '  '
                     || LRREC.OBJECT_NAME
                     || ' COMPILE';
            DBMS_SQL.PARSE( LICURSOR,
                            LSSQL,
                            DBMS_SQL.V7 );

            BEGIN
               LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );
               IAPIGENERAL.LOGINFO( GSSOURCE,
                                    LSMETHOD,
                                    LSSQL,
                                    IAPICONSTANT.INFOLEVEL_3 );
            EXCEPTION
               WHEN OTHERS
               THEN
                  IAPIGENERAL.LOGINFO( GSSOURCE,
                                       LSMETHOD,
                                          LSSQL
                                       || ' - An error occurred: '
                                       || SQLERRM,
                                       IAPICONSTANT.INFOLEVEL_3 );
            END;
         EXCEPTION
            WHEN OTHERS
            THEN
               IAPIGENERAL.LOGINFO( GSSOURCE,
                                    LSMETHOD,
                                       LSSQL
                                    || ' - An error occurred: '
                                    || SQLERRM,
                                    IAPICONSTANT.INFOLEVEL_3 );
         END;
      END LOOP;

      DBMS_SQL.CLOSE_CURSOR( LICURSOR );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         ROLLBACK;

         IF DBMS_SQL.IS_OPEN( LICURSOR )
         THEN
            DBMS_SQL.CLOSE_CURSOR( LICURSOR );
         END IF;

         IF LQINVALIDVIEWS%ISOPEN
         THEN
            CLOSE LQINVALIDVIEWS;
         END IF;

         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END COMPILEINVALIDVIEWS;


   FUNCTION COMPILEINVALIDSYNONYMS
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      CURSOR LQINVALIDSYNONYMS(
         ASSCHEMANAME               IN       IAPITYPE.DATABASESCHEMANAME_TYPE )
      IS
         SELECT *
           FROM DBA_OBJECTS
          WHERE OWNER = ASSCHEMANAME
            AND OBJECT_TYPE NOT LIKE '%BODY%' 
            AND STATUS = 'INVALID'
				 ORDER BY OWNER, OBJECT_TYPE, OBJECT_NAME;

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CompileInvalidSynonyms';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSCHEMANAME                  IAPITYPE.DATABASESCHEMANAME_TYPE;
      LRREC                         LQINVALIDSYNONYMS%ROWTYPE;
      LSSQL                         VARCHAR2( 2000 );
      LIRESULT                      INTEGER;
      LICURSOR                      INTEGER;
      LNCOUNT                       NUMBER;
   BEGIN



EXECUTE IMMEDIATE('ALTER SESSION SET NLS_LENGTH_SEMANTICS=CHAR'); 

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIDATABASE.GETSCHEMANAME( LSSCHEMANAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;









      LICURSOR := DBMS_SQL.OPEN_CURSOR;

      FOR LRREC IN LQINVALIDSYNONYMS( LSSCHEMANAME )
      LOOP
         BEGIN
               LSSQL :=    'ALTER '
                        || LRREC.OBJECT_TYPE
                        || ' "' 
												|| LRREC.OWNER 
												|| '"."' 
												|| LRREC.OBJECT_NAME 
												|| '" COMPILE';

            DBMS_SQL.PARSE( LICURSOR,
                            LSSQL,
                            DBMS_SQL.V7 );

            BEGIN
               LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );
               IAPIGENERAL.LOGINFO( GSSOURCE,
                                    LSMETHOD,
                                    LSSQL,
                                    IAPICONSTANT.INFOLEVEL_3 );
            EXCEPTION
               WHEN OTHERS
               THEN
                  IAPIGENERAL.LOGINFO( GSSOURCE,
                                       LSMETHOD,
                                          LSSQL
                                       || ' - An error occurred: '
                                       || SQLERRM,
                                       IAPICONSTANT.INFOLEVEL_3 );
            END;
         EXCEPTION
            WHEN OTHERS
            THEN
               IAPIGENERAL.LOGINFO( GSSOURCE,
                                    LSMETHOD,
                                       LSSQL
                                    || ' - An error occurred: '
                                    || SQLERRM,
                                    IAPICONSTANT.INFOLEVEL_3 );
         END;
      END LOOP;

      DBMS_SQL.CLOSE_CURSOR( LICURSOR );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         ROLLBACK;

         IF DBMS_SQL.IS_OPEN( LICURSOR )
         THEN
            DBMS_SQL.CLOSE_CURSOR( LICURSOR );
         END IF;

         IF LQINVALIDSYNONYMS%ISOPEN
         THEN
            CLOSE LQINVALIDSYNONYMS;
         END IF;

         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END COMPILEINVALIDSYNONYMS;



   FUNCTION GETMAXOPENCURSORS(
      ANMAXOPENCURSORS           OUT      IAPITYPE.NUMVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS











      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetMaxOpenCursors';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT VALUE
        INTO ANMAXOPENCURSORS
        FROM V$PARAMETER
       WHERE NAME = 'open_cursors';

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETMAXOPENCURSORS;


   FUNCTION GRANTTABLEALL
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS









      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GrantTableAll';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      DBMS_OUTPUT.PUT_LINE( 'GRANT TABLE APPROVER' );
      GRANTTABLEAPPROVER;
      DBMS_OUTPUT.PUT_LINE( 'GRANT TABLE DEV MGR' );
      GRANTTABLEDEVMGR;
      DBMS_OUTPUT.PUT_LINE( 'GRANT TABLE LIMITED' );
      GRANTTABLELIMITED;
      DBMS_OUTPUT.PUT_LINE( 'GRANT TABLE VIEW_ONLY' );
      GRANTTABLEVIEWONLY;
      DBMS_OUTPUT.PUT_LINE( 'GRANT TABLE MRP' );
      GRANTTABLEMRP;
      DBMS_OUTPUT.PUT_LINE( 'GRANT TABLE FRAME_BUILDER' );
      GRANTTABLEFRAMEBUILDER;
      DBMS_OUTPUT.PUT_LINE( 'GRANT TABLE ALL OBJECTS' );
      GRANTALLOBJECTS;
      DBMS_OUTPUT.PUT_LINE( 'GRANT VIEW IVPLANT' );
      GRANTEXCEPTION('IVPLANT');
      DBMS_OUTPUT.PUT_LINE( 'GRANT VIEW IVUOM_UOM_GROUP' );
      GRANTEXCEPTION('IVUOM_UOM_GROUP');
      DBMS_OUTPUT.PUT_LINE( 'GRANT TABLE SEQUENCES' );
      GRANTSEQUENCES;
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GRANTTABLEALL;



END IAPIDATABASE;
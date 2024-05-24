CREATE OR REPLACE PROCEDURE Sp_Check_Server
IS














   L_FOUND                       NUMBER;
   L_RETURN_CODE                 NUMBER;
   L_SERVER_STATUS               VARCHAR2( 40 );
   LSSOURCE                      IAPITYPE.SOURCE_TYPE := 'Sp_Check_Server';
   LSMETHOD                      IAPITYPE.METHOD_TYPE := '';
   LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   SELECT JOB
     INTO L_FOUND
     FROM DBA_JOBS
    WHERE UPPER( WHAT ) LIKE '%iapiSpecDataServer.RunSpecServer%';
EXCEPTION
   WHEN TOO_MANY_ROWS
   THEN
      IAPIGENERAL.LOGERROR( LSSOURCE,
                            LSMETHOD,
                            'Specserver was running twice on the database and will be stopped.' );
      DBMS_ALERT.SIGNAL( 'SPEC_SERVER',
                         'STOP' );
      COMMIT;
   WHEN NO_DATA_FOUND
   THEN
      
      BEGIN
         LNRETVAL := IAPIGENERAL.GETCONFIGURATIONSETTING( ASSECTION => 'Specserver',
                                                          ASPARAMETER => 'STATUS',
                                                          ASPARAMETERDATA => L_SERVER_STATUS );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGERROR( LSSOURCE,
                                  LSMETHOD,
                                  'Specserver status not found in configuration table.' );
            RAISE_APPLICATION_ERROR( -20000,
                                     'Specserver status not found in configuration table.' );
         END IF;

         IAPIGENERAL.LOGINFO( LSSOURCE,
                              LSMETHOD,
                                 'Specserver status found <'
                              || L_SERVER_STATUS
                              || '>',
                              IAPICONSTANT.INFOLEVEL_3 );

         IF L_SERVER_STATUS <> 'DISABLED'
         THEN
            L_RETURN_CODE := IAPISPECDATASERVER.STARTSPECSERVER;

            IF L_RETURN_CODE = -1
            THEN
               IAPIGENERAL.LOGWARNING( LSSOURCE,
                                       LSMETHOD,
                                       'Specserver was already running again and was not started.' );
            ELSE
               IAPIGENERAL.LOGWARNING( LSSOURCE,
                                       LSMETHOD,
                                       'Specserver is not running and was started up again' );
            END IF;
         ELSE
            IAPIGENERAL.LOGWARNING( LSSOURCE,
                                    LSMETHOD,
                                    'Specserver was stopped by system administrator.' );
            RAISE_APPLICATION_ERROR( -20352,
                                     'Specserver was stopped by system administrator.' );
         END IF;
      END;
END SP_CHECK_SERVER;
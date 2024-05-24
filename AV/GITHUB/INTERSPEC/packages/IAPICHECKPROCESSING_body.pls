CREATE OR REPLACE PACKAGE BODY iapiCheckProcessing
AS
   
   
   
   
   
   
   
   
   
   
   

   
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

   
   
   

   
   
   
   PROCEDURE CHECKEMAILMESSAGES(
      ANMAXIMUM                           IAPITYPE.NUMVAL_TYPE )
   IS






      LNCOUNTER                     IAPITYPE.NUMVAL_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckEmailMessages';
   BEGIN
      SELECT COUNT( * )
        INTO LNCOUNTER
        FROM ITEMAIL;

      IF LNCOUNTER > ANMAXIMUM
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_EMAILSNOTPROCESSED,
                                               TO_CHAR( LNCOUNTER ) );
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RAISE_APPLICATION_ERROR( '-20001',
                                  SQLERRM );
   END CHECKEMAILMESSAGES;


   PROCEDURE CHECKEMAILADDRESS
   IS






      CURSOR C_ADDRESS
      IS
         SELECT USER_ID,
                   EMAIL_ADDRESS
                || DECODE( SIGN( INSTR( EMAIL_ADDRESS,
                                        '@' ) ),
                           0, PARAMETER_DATA ) ADDRESS
           FROM APPLICATION_USER,
                INTERSPC_CFG
          WHERE PARAMETER(+) = 'def_email_ext';

      LNCOUNTER                     IAPITYPE.NUMVAL_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckEmailAddress';
   BEGIN
      FOR L_ROW IN C_ADDRESS
      LOOP
         
         IF LENGTH( RTRIM( LTRIM( LOWER( LTRIM( RTRIM( L_ROW.ADDRESS ) ) ),
                                  'abcdefghijklmnopqrstuvwxyz-_.1234567890''' ),
                           'abcdefghijklmnopqrstuvwxyz-_.1234567890''' ) ) <> 1
         THEN
            LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_INVALIDEMAILADDRESS,
                                                  L_ROW.USER_ID );
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
         END IF;

         COMMIT;
      END LOOP;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RAISE_APPLICATION_ERROR( '-20001',
                                  SQLERRM );
   END CHECKEMAILADDRESS;


   PROCEDURE CHECKFRAMES(
      ANMAXIMUM                           IAPITYPE.NUMVAL_TYPE )
   IS






      LNCOUNTER                     IAPITYPE.NUMVAL_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckFrames';
   BEGIN
      SELECT COUNT( * )
        INTO LNCOUNTER
        FROM FRAMEDATA_SERVER
       WHERE DATE_PROCESSED IS NULL;

      IF LNCOUNTER > ANMAXIMUM
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_FRAMESNOTPROCESSED,
                                               TO_CHAR( LNCOUNTER ) );
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RAISE_APPLICATION_ERROR( '-20001',
                                  SQLERRM );
   END CHECKFRAMES;

   PROCEDURE CHECKSPECIFICATIONS(
      ANMAXIMUM                           IAPITYPE.NUMVAL_TYPE )
   IS






      LNCOUNTER                     IAPITYPE.NUMVAL_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckSpecifications';
   BEGIN
      SELECT COUNT( * )
        INTO LNCOUNTER
        FROM SPECDATA_SERVER
       WHERE DATE_PROCESSED IS NULL;

      IF LNCOUNTER > ANMAXIMUM
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_SPECSNOTPROCESSED,
                                               TO_CHAR( LNCOUNTER ) );
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RAISE_APPLICATION_ERROR( '-20001',
                                  SQLERRM );
   END CHECKSPECIFICATIONS;

   
   
   
   PROCEDURE CHECKPROCESSING(
      ANMAXIMUM                           IAPITYPE.NUMVAL_TYPE )
   IS






      LNEMAILINSTALLED              IAPITYPE.NUMVAL_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckProcessing';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
      THEN
         LNRETVAL := IAPIGENERAL.SETCONNECTION( USER,
                                                'CHECK PROCESSING JOB' );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            RAISE_APPLICATION_ERROR( -20000,
                                     IAPIGENERAL.GETLASTERRORTEXT( ) );
         END IF;
      END IF;

      BEGIN
         SELECT PARAMETER_DATA
           INTO LNEMAILINSTALLED
           FROM INTERSPC_CFG
          WHERE PARAMETER = 'email'
            AND SECTION = 'interspec';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            LNEMAILINSTALLED := 0;
      END;

      IF LNEMAILINSTALLED = 1
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              'CHECKING E-MAIL',
                              IAPICONSTANT.INFOLEVEL_3 );
         CHECKEMAILMESSAGES( ANMAXIMUM );
         CHECKEMAILADDRESS;
      ELSE
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              'E-MAIL NOT ACTIVATED',
                              IAPICONSTANT.INFOLEVEL_3 );
      END IF;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'CHECKING FRAMES',
                           IAPICONSTANT.INFOLEVEL_3 );
      CHECKFRAMES( ANMAXIMUM );
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'CHECKING SPECFICATIONS',
                           IAPICONSTANT.INFOLEVEL_3 );
      CHECKSPECIFICATIONS( ANMAXIMUM );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL );
         RAISE_APPLICATION_ERROR( -20000,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
   END CHECKPROCESSING;
END IAPICHECKPROCESSING;
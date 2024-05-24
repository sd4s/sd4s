CREATE OR REPLACE PACKAGE BODY iapiGeneral
AS














   
   FUNCTION GETPACKAGEVERSION
      RETURN IAPITYPE.STRING_TYPE
   IS
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetPackageVersion';
   BEGIN
      
      
      
      RETURN(    IAPIGENERAL.GETVERSION
              || ' ($Revision: 6.7.0.14 (06.07.00.14-00.00) $)' );

   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   END GETPACKAGEVERSION;

   
   
   

   
   
   
   
   PROCEDURE LOGMESSAGE(
      ASSOURCE                   IN       IAPITYPE.SOURCE_TYPE,
      ASMETHOD                   IN       IAPITYPE.METHOD_TYPE,
      ASMESSAGE                  IN       IAPITYPE.CLOB_TYPE,
      ANTYPE                     IN       IAPITYPE.ERRORMESSAGETYPE_TYPE,
      ANINFOLEVEL                IN       IAPITYPE.INFOLEVEL_TYPE )
   IS
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'LogMessage';
      LSMODULE                      ITERROR.MODULE%TYPE := 'NOT FOUND';
      LSMACHINE                     ITERROR.MACHINE%TYPE := 'NOT FOUND';
      LSDUMMY                       VARCHAR2( 40 );
      LSSQLCHUNK                    VARCHAR2( 1024 ) := NULL;
      LNCHUNKCOUNT                  NUMBER := 0;
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      
      
      
      SELECT NVL( MACHINE,
                  'NOT FOUND' )
        INTO LSMACHINE
        FROM V$SESSION
       WHERE AUDSID = USERENV( 'sessionid' )
         AND ROWNUM = 1;

      DBMS_APPLICATION_INFO.READ_MODULE( LSMODULE,
                                         LSDUMMY );
      LSSQLCHUNK := SUBSTR( ASMESSAGE,
                            1,
                            1024 );

      WHILE( LENGTH( LSSQLCHUNK ) > 0 )
      LOOP
         LNCHUNKCOUNT :=   LNCHUNKCOUNT
                         + 1;

         INSERT INTO ITERROR
                     ( SEQ_NO,
                       MACHINE,
                       MODULE,
                       SOURCE,
                       APPLIC,
                       USER_ID,
                       LOGDATE,
                       ERROR_MSG,
                       MSG_TYPE,
                       INFOLEVEL )
              VALUES ( ERROR_SEQ.NEXTVAL,
                       LSMACHINE,
                       LSMODULE,
                       ASSOURCE,
                       ASMETHOD,
                       NVL( SESSION.APPLICATIONUSER.USERID,
                            USER ),
                       SYSDATE,
                       LSSQLCHUNK,
                       ANTYPE,
                       ANINFOLEVEL );

         LSSQLCHUNK := SUBSTR( ASMESSAGE,
                                 1
                               +   1024
                                 * LNCHUNKCOUNT,
                               1024 );
      END LOOP;

      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         RAISE_APPLICATION_ERROR( -20000,
                                  SQLERRM );
   END LOGMESSAGE;

   
   
   
   
   PROCEDURE LOGERROR(
      ASSOURCE                   IN       IAPITYPE.SOURCE_TYPE,
      ASMETHOD                   IN       IAPITYPE.METHOD_TYPE,
      ASMESSAGE                  IN       IAPITYPE.CLOB_TYPE )
   IS
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'LogError';
   BEGIN
      
      
      
      LOGMESSAGE( ASSOURCE,
                  ASMETHOD,
                  ASMESSAGE,
                  IAPICONSTANT.ERRORMESSAGE_ERROR,
                  NULL );
   END LOGERROR;

   
   PROCEDURE LOGWARNING(
      ASSOURCE                   IN       IAPITYPE.SOURCE_TYPE,
      ASMETHOD                   IN       IAPITYPE.METHOD_TYPE,
      ASMESSAGE                  IN       IAPITYPE.CLOB_TYPE )
   IS
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'LogWarning';
   BEGIN
      
      
      
      
      
      IF ( LOGGINGENABLED = TRUE )
      THEN
         
         
         
         LOGMESSAGE( ASSOURCE,
                     ASMETHOD,
                     ASMESSAGE,
                     IAPICONSTANT.ERRORMESSAGE_WARNING,
                     NULL );
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
   END LOGWARNING;

   
   PROCEDURE LOGINFO(
      ASSOURCE                   IN       IAPITYPE.SOURCE_TYPE,
      ASMETHOD                   IN       IAPITYPE.METHOD_TYPE,
      ASMESSAGE                  IN       IAPITYPE.CLOB_TYPE,
      ANINFOLEVEL                IN       IAPITYPE.INFOLEVEL_TYPE DEFAULT 0 )
   IS
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'LogInfo';
   BEGIN
      
      
      
      
      
      IF ( LOGGINGENABLED = TRUE )
      THEN
         
         
         
         LOGMESSAGE( ASSOURCE,
                     ASMETHOD,
                     ASMESSAGE,
                     IAPICONSTANT.ERRORMESSAGE_INFO,
                     ANINFOLEVEL );
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
   END LOGINFO;

   
   FUNCTION GETVERSION
      RETURN IAPITYPE.STRING_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetVersion';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETVERSION;

   
   PROCEDURE ENABLELOGGING
   IS
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'EnableLogging';
   BEGIN
      
      
      
      LOGGINGENABLED := TRUE;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
   END ENABLELOGGING;

   
   PROCEDURE DISABLELOGGING
   IS
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'DisableLogging';
   BEGIN
      
      
      
      LOGGINGENABLED := FALSE;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
   END DISABLELOGGING;

   
   FUNCTION GETNLSSESSIONPARAMETER(
      ASPARAMETER                IN       NLS_SESSION_PARAMETERS.PARAMETER%TYPE,
      ANCOMPOSED                 IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0 )
      RETURN NLS_SESSION_PARAMETERS.VALUE%TYPE
   IS
      
      
      
      
      
      
      
      
      LSNLS_PARAM                   VARCHAR2( 50 );
      LSSELECT                      IAPITYPE.STRING_TYPE := 'VALUE';
      LSSQL                         IAPITYPE.STRING_TYPE;
   BEGIN
      LSSQL :=    'SELECT'
               || ' '
               || LSSELECT
               || ' '
               || 'FROM NLS_SESSION_PARAMETERS WHERE PARAMETER = :asParameter';

      EXECUTE IMMEDIATE LSSQL
                   INTO LSNLS_PARAM
                  USING ASPARAMETER;

      IF ANCOMPOSED = 1
      THEN
         LSNLS_PARAM :=    ASPARAMETER
                        || '='
                        || LSNLS_PARAM;
      END IF;

      RETURN LSNLS_PARAM;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END GETNLSSESSIONPARAMETER;

   
   FUNCTION GETCONFIGURATIONSETTING(
      ASPARAMETER                IN       IAPITYPE.PARAMETER_TYPE,
      ASSECTION                  IN       IAPITYPE.CONFIGURATIONSECTION_TYPE DEFAULT IAPICONSTANT.CFG_SECTION_STANDARD,
      ASPARAMETERDATA            OUT      IAPITYPE.PARAMETERDATA_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetConfigurationSetting';
   BEGIN
      
      
      
      
      

      
      
      
      SELECT PARAMETER_DATA
        INTO ASPARAMETERDATA
        FROM INTERSPC_CFG
       WHERE SECTION = ASSECTION
         AND PARAMETER = ASPARAMETER;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_MISSINGPARAMORSECTION,
                                                     ASSECTION,
                                                     ASPARAMETER ) );
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETCONFIGURATIONSETTING;

   
   FUNCTION SETERRORTEXTANDLOGINFO(
      ASSOURCE                   IN       IAPITYPE.SOURCE_TYPE,
      ASMETHOD                   IN       IAPITYPE.METHOD_TYPE,
      ANERRORNUMBER              IN       IAPITYPE.ERRORNUM_TYPE,
      ASPARAM1                   IN       IAPITYPE.OPTPARAM_TYPE DEFAULT NULL,
      ASPARAM2                   IN       IAPITYPE.OPTPARAM_TYPE DEFAULT NULL,
      ASPARAM3                   IN       IAPITYPE.OPTPARAM_TYPE DEFAULT NULL,
      ASPARAM4                   IN       IAPITYPE.OPTPARAM_TYPE DEFAULT NULL,
      ASPARAM5                   IN       IAPITYPE.OPTPARAM_TYPE DEFAULT NULL,
      ASPARAM6                   IN       IAPITYPE.OPTPARAM_TYPE DEFAULT NULL,
      ASPARAM7                   IN       IAPITYPE.OPTPARAM_TYPE DEFAULT NULL,
      ASPARAM8                   IN       IAPITYPE.OPTPARAM_TYPE DEFAULT NULL,
      ASPARAM9                   IN       IAPITYPE.OPTPARAM_TYPE DEFAULT NULL,
      ASPARAM0                   IN       IAPITYPE.OPTPARAM_TYPE DEFAULT NULL,
      ANINFOLEVEL                IN       IAPITYPE.INFOLEVEL_TYPE DEFAULT 0 )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      LNRETVAL := SETERRORTEXT( ANERRORNUMBER,
                                ASPARAM1,
                                ASPARAM2,
                                ASPARAM3,
                                ASPARAM4,
                                ASPARAM5,
                                ASPARAM6,
                                ASPARAM7,
                                ASPARAM8,
                                ASPARAM9,
                                ASPARAM0 );
      LOGINFO( ASSOURCE,
               ASMETHOD,
               GETLASTERRORTEXT( ),
               ANINFOLEVEL );
      RETURN LNRETVAL;
   END SETERRORTEXTANDLOGINFO;

   
   FUNCTION SETERRORTEXT(
      ANERRORNUMBER              IN       IAPITYPE.ERRORNUM_TYPE,
      ASPARAM1                   IN       IAPITYPE.OPTPARAM_TYPE DEFAULT NULL,
      ASPARAM2                   IN       IAPITYPE.OPTPARAM_TYPE DEFAULT NULL,
      ASPARAM3                   IN       IAPITYPE.OPTPARAM_TYPE DEFAULT NULL,
      ASPARAM4                   IN       IAPITYPE.OPTPARAM_TYPE DEFAULT NULL,
      ASPARAM5                   IN       IAPITYPE.OPTPARAM_TYPE DEFAULT NULL,
      ASPARAM6                   IN       IAPITYPE.OPTPARAM_TYPE DEFAULT NULL,
      ASPARAM7                   IN       IAPITYPE.OPTPARAM_TYPE DEFAULT NULL,
      ASPARAM8                   IN       IAPITYPE.OPTPARAM_TYPE DEFAULT NULL,
      ASPARAM9                   IN       IAPITYPE.OPTPARAM_TYPE DEFAULT NULL,
      ASPARAM0                   IN       IAPITYPE.OPTPARAM_TYPE DEFAULT NULL )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SetErrorText';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSERRORTEXT                   IAPITYPE.ERRORTEXT_TYPE;
   BEGIN
      
      
      
      LASTERRORTEXT := NULL;

      BEGIN
         SELECT MESSAGE
           INTO LSERRORTEXT
           FROM ITMESSAGE
          WHERE MSG_ID = TO_CHAR( ANERRORNUMBER )
            AND CULTURE_ID =
                          ( SELECT VALUE
                             FROM ITUSPREF
                            WHERE USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID
                              AND SECTION_NAME = 'General'
                              AND PREF = 'ApplicationLanguage' );
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            SELECT MESSAGE
              INTO LSERRORTEXT
              FROM ITMESSAGE
             WHERE MSG_ID = TO_CHAR( ANERRORNUMBER )
               AND CULTURE_ID = 'en';
      END;

      LSERRORTEXT := REPLACE( LSERRORTEXT,
                              '%1',
                              NVL( ASPARAM1,
                                   '<NULL>' ) );
      LSERRORTEXT := REPLACE( LSERRORTEXT,
                              '%2',
                              NVL( ASPARAM2,
                                   '<NULL>' ) );
      LSERRORTEXT := REPLACE( LSERRORTEXT,
                              '%3',
                              NVL( ASPARAM3,
                                   '<NULL>' ) );
      LSERRORTEXT := REPLACE( LSERRORTEXT,
                              '%4',
                              NVL( ASPARAM4,
                                   '<NULL>' ) );
      LSERRORTEXT := REPLACE( LSERRORTEXT,
                              '%5',
                              NVL( ASPARAM5,
                                   '<NULL>' ) );
      LSERRORTEXT := REPLACE( LSERRORTEXT,
                              '%6',
                              NVL( ASPARAM6,
                                   '<NULL>' ) );
      LSERRORTEXT := REPLACE( LSERRORTEXT,
                              '%7',
                              NVL( ASPARAM7,
                                   '<NULL>' ) );
      LSERRORTEXT := REPLACE( LSERRORTEXT,
                              '%8',
                              NVL( ASPARAM8,
                                   '<NULL>' ) );
      LSERRORTEXT := REPLACE( LSERRORTEXT,
                              '%9',
                              NVL( ASPARAM9,
                                   '<NULL>' ) );
      LSERRORTEXT := REPLACE( LSERRORTEXT,
                              '%0',
                              NVL( ASPARAM0,
                                   '<NULL>' ) );
      LASTERRORTEXT := LSERRORTEXT;
      RETURN( ANERRORNUMBER );
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         BEGIN
            SELECT MESSAGE
              INTO LSERRORTEXT
              FROM ITMESSAGE
             WHERE MSG_ID = TO_CHAR( IAPICONSTANTDBERROR.DBERR_MISSINGERRDESC )
               AND CULTURE_ID = 'en';

            LSERRORTEXT := REPLACE( LSERRORTEXT,
                                    '%1',
                                    ANERRORNUMBER );
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  LSERRORTEXT );
            LASTERRORTEXT := LSERRORTEXT;
            RETURN( ANERRORNUMBER );
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                        'Error description not found for error number <'
                                     || IAPICONSTANTDBERROR.DBERR_MISSINGERRDESC
                                     || '>' );
               RETURN( ANERRORNUMBER );
            WHEN OTHERS
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     SQLERRM );
               RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
         END;
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SETERRORTEXT;

   
   FUNCTION GETLASTERRORTEXT
      RETURN IAPITYPE.ERRORTEXT_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetLastErrorText';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      RETURN( LASTERRORTEXT );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETLASTERRORTEXT;

   
   FUNCTION INITIALISESESSION(
      ASUSERID                   IN       IAPITYPE.USERID_TYPE DEFAULT USER )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'InitialiseSession';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSALLOWGLOSSARY               IAPITYPE.STRING_TYPE;
      LSALLOWFRAMECHANGES           IAPITYPE.STRING_TYPE;
      LSALLOWFRAMEEXPORT            IAPITYPE.STRING_TYPE;
      LSPREFERENCEVALUE             IAPITYPE.PREFERENCEVALUE_TYPE;
   BEGIN
      
      
      
      SESSION.APPLICATIONUSER.USERID := ASUSERID;
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Started session for User Id <'
                           || ASUSERID
                           || '>',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      LNRETVAL := IAPIGENERAL.GETCONFIGURATIONSETTING( ASPARAMETER => 'owner',
                                                       ASPARAMETERDATA => SESSION.DATABASE.OWNER );
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Database Owner Id set to <'
                           || TO_CHAR( SESSION.DATABASE.OWNER )
                           || '>',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( LNRETVAL );
      END IF;

      SELECT DB_TYPE,
             ALLOW_GLOSSARY,
             ALLOW_FRAME_CHANGES,
             ALLOW_FRAME_EXPORT
        INTO SESSION.DATABASE.DATABASETYPE,
             LSALLOWGLOSSARY,
             LSALLOWFRAMECHANGES,
             LSALLOWFRAMEEXPORT
        FROM ITDBPROFILE
       WHERE OWNER = SESSION.DATABASE.OWNER;

      
      
      SESSION.DATABASE.CREATESECTIONHISTORY := TRUE;

      SESSION.DATABASE.CONFIGURATION.GLOSSARY :=( LSALLOWGLOSSARY = 'Y' );
      SESSION.DATABASE.CONFIGURATION.FRAMECHANGES :=( LSALLOWFRAMECHANGES = 'Y' );
      SESSION.DATABASE.CONFIGURATION.FRAMEEXPORT :=( LSALLOWFRAMEEXPORT = 'Y' );
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Started select on application_user for User Id <'
                           || ASUSERID
                           || '>',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT FORENAME,
             LAST_NAME,
             USER_INITIALS,
             TELEPHONE_NO,
             EMAIL_ADDRESS,
             DECODE( CURRENT_ONLY,
                     'Y', 1,
                     0 ),
             INITIAL_PROFILE,
             USER_PROFILE,
             DECODE( USER_DROPPED,
                     'Y', 1,
                     0 ),
             DECODE( PROD_ACCESS,
                     'Y', 1,
                     0 ),
             DECODE( PLAN_ACCESS,
                     'Y', 1,
                     0 ),
             DECODE( PHASE_ACCESS,
                     'Y', 1,
                     0 ),
             DECODE( INTL,
                     'Y', 1,
                     0 ),
             DECODE( REFERENCE_TEXT,
                     'Y', 1,
                     0 ),
             DECODE( APPROVED_ONLY,
                     'Y', 1,
                     0 ),
             LOC_ID,
             CAT_ID,
             DECODE( OVERRIDE_PART_VAL,
                     'Y', 1,
                     0 ),
             DECODE( WEB_ALLOWED,
                     'Y', 1,
                     0 ),
             DECODE( LIMITED_CONFIGURATOR,
                     'Y', 1,
                     0 ),
             DECODE( PLANT_ACCESS,
                     'Y', 1,
                     0 ),
             DECODE( VIEW_BOM,
                     'Y', 1,
                     0 ),
             VIEW_PRICE,
             OPTIONAL_DATA,
             DECODE( HISTORIC_ONLY,
                     'Y', 1,
                     0 )
        INTO SESSION.APPLICATIONUSER.FORENAME,
             SESSION.APPLICATIONUSER.LASTNAME,
             SESSION.APPLICATIONUSER.INITIALS,
             SESSION.APPLICATIONUSER.TELEPHONE,
             SESSION.APPLICATIONUSER.EMAILADDRESS,
             SESSION.APPLICATIONUSER.CURRENTONLYACCESS,
             SESSION.APPLICATIONUSER.INITIALPROFILE,
             SESSION.APPLICATIONUSER.USERPROFILE,
             SESSION.APPLICATIONUSER.USERDROPPED,
             SESSION.APPLICATIONUSER.MRPPRODUCTIONACCESS,
             SESSION.APPLICATIONUSER.MRPPLANNINGACCESS,
             SESSION.APPLICATIONUSER.MRPPHASEACCESS,
             SESSION.APPLICATIONUSER.INTERNATIONALACCESS,
             SESSION.APPLICATIONUSER.OBJECTANDREFTEXTACCESS,
             SESSION.APPLICATIONUSER.APPROVEDONLYACCESS,
             SESSION.APPLICATIONUSER.LOCATIONID,
             SESSION.APPLICATIONUSER.CATEGORYID,
             SESSION.APPLICATIONUSER.CREATELOCALPARTALLOWED,
             SESSION.APPLICATIONUSER.WEBALLOWED,
             SESSION.APPLICATIONUSER.LIMITEDCONFIGURATOR,
             SESSION.APPLICATIONUSER.PLANTACCESS,
             SESSION.APPLICATIONUSER.VIEWBOMALLOWED,
             SESSION.APPLICATIONUSER.VIEWPRICEALLOWED,
             SESSION.APPLICATIONUSER.OPTIONALDATA,
             SESSION.APPLICATIONUSER.HISTORICONLYACCESS
        FROM APPLICATION_USER
       WHERE USER_ID = ASUSERID;

      LNRETVAL := IAPIUSERPREFERENCES.GETUSERPREFERENCE( 'General',
                                                         'Metric',
                                                         ASUSERID,
                                                         LSPREFERENCEVALUE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( LNRETVAL );
      ELSE
         SESSION.SETTINGS.METRIC :=( LSPREFERENCEVALUE = 1 );
      END IF;

      IF SESSION.APPLICATIONUSER.INTERNATIONALACCESS = 1
      THEN
         LNRETVAL := IAPIUSERPREFERENCES.GETUSERPREFERENCE( 'General',
                                                            'Mode',
                                                            ASUSERID,
                                                            LSPREFERENCEVALUE );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            RETURN( LNRETVAL );
         ELSE
            SESSION.SETTINGS.INTERNATIONAL :=( LSPREFERENCEVALUE = 1 );
         END IF;
      ELSE
         SESSION.SETTINGS.INTERNATIONAL := FALSE;
      END IF;

      LNRETVAL := IAPIUSERPREFERENCES.GETUSERPREFERENCE( 'General',
                                                         'DataLanguage',
                                                         ASUSERID,
                                                         LSPREFERENCEVALUE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( LNRETVAL );
      ELSE
         SESSION.SETTINGS.LANGUAGEID := LSPREFERENCEVALUE;
      END IF;

      SESSION.SETTINGS.ALTERNATIVELANGUAGEID := SESSION.SETTINGS.LANGUAGEID;
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END INITIALISESESSION;

   
   FUNCTION CHECKLICENSE(
      ASMACHINENAME              IN       IAPITYPE.MACHINENAME_TYPE DEFAULT NULL,
      ASAPPVERSION               IN       IAPITYPE.LICENSEVERSION_TYPE,
      ANFDA21CFR11ENABLED        OUT      IAPITYPE.BOOLEAN_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckLicense';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNRETVALCONFIG                IAPITYPE.ERRORNUM_TYPE;
      LSALLOWFULLUSER               IAPITYPE.STRING_TYPE;
      LTAPPID                       CXSAPILK.VC20_TABLE_TYPE;
      LTAPPVERSION                  CXSAPILK.VC20_TABLE_TYPE;
      LTAPPCUSTOMPARAM              CXSAPILK.VC20_TABLE_TYPE;
      LTLICCHECKOK4APP              CXSAPILK.NUM_TABLE_TYPE;
      LTMAXUSERS4APP                CXSAPILK.NUM_TABLE_TYPE;
      LTUSERSID                     CXSAPILK.VC20_TABLE_TYPE;
      LTUSERNAME                    CXSAPILK.VC20_TABLE_TYPE;
      LTERRORCODE                   CXSAPILK.NUM_TABLE_TYPE;
      LTLOGONSTATION                CXSAPILK.VC40_TABLE_TYPE;
      LNNOROWS                      NUMBER;
      LSERRORMSG                    VARCHAR2( 255 );
      LBANYVALIDLICENSEFOUND        BOOLEAN;
   BEGIN
      
      
      
      
      
      LNNOROWS := 12;
      

      LTAPPID( 1 ) := 'IISS';
      LTAPPVERSION( 1 ) := ASAPPVERSION;
      LTAPPCUSTOMPARAM( 1 ) := 'I0';
      LTAPPID( 2 ) := 'IISS';
      LTAPPVERSION( 2 ) := ASAPPVERSION;
      LTAPPCUSTOMPARAM( 2 ) := 'I3';
      LTAPPID( 3 ) := 'IISC';
      LTAPPVERSION( 3 ) := ASAPPVERSION;
      LTAPPCUSTOMPARAM( 3 ) := 'I0';
      LTAPPID( 4 ) := 'IISC';
      LTAPPVERSION( 4 ) := ASAPPVERSION;
      LTAPPCUSTOMPARAM( 4 ) := 'I4';
      LTAPPID( 5 ) := 'IISC';
      LTAPPVERSION( 5 ) := ASAPPVERSION;
      LTAPPCUSTOMPARAM( 5 ) := 'I7';
      LTAPPID( 6 ) := 'IISC';
      LTAPPVERSION( 6 ) := ASAPPVERSION;
      LTAPPCUSTOMPARAM( 6 ) := 'I5';
      LTAPPID( 7 ) := 'IISC';
      LTAPPVERSION( 7 ) := ASAPPVERSION;
      LTAPPCUSTOMPARAM( 7 ) := 'I9';
      LTAPPID( 8 ) := 'IISC';
      LTAPPVERSION( 8 ) := ASAPPVERSION;
      LTAPPCUSTOMPARAM( 8 ) := 'R0';
      LTAPPID( 9 ) := 'IISC';
      LTAPPVERSION( 9 ) := ASAPPVERSION;
      LTAPPCUSTOMPARAM( 9 ) := 'R4';
      LTAPPID( 10 ) := 'IISC';
      LTAPPVERSION( 10 ) := ASAPPVERSION;
      LTAPPCUSTOMPARAM( 10 ) := 'R7';
      
      LTAPPID( 11 ) := 'RISS';
      LTAPPVERSION( 11 ) := ASAPPVERSION;
      LTAPPCUSTOMPARAM( 11 ) := 'I0';
      LTAPPID( 12 ) := 'RISS';
      LTAPPVERSION( 12 ) := ASAPPVERSION;
      LTAPPCUSTOMPARAM( 12 ) := 'I3';
      

      LNRETVAL := CXSAPILK.CHECKLICENSE( LTAPPID,
                                         LTAPPVERSION,
                                         LTAPPCUSTOMPARAM,
                                         LTLICCHECKOK4APP,
                                         LTMAXUSERS4APP,
                                         LNNOROWS,
                                         LSERRORMSG );

      IF LNRETVAL = 11
      THEN
         LNRETVAL := IAPICONSTANTDBERROR.DBERR_NORECORDS;
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'CheckLicence = '
                              || TO_CHAR( LNRETVAL )
                              || ' No licence key installed.' );
      END IF;

      IF ( LNRETVAL NOT IN( IAPICONSTANTDBERROR.DBERR_SUCCESS, IAPICONSTANTDBERROR.DBERR_OK_NO_ALM ) )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( LNRETVAL ) );
      END IF;




      LBANYVALIDLICENSEFOUND := FALSE;
      SESSION.DATABASE.CONFIGURATION.TESTSERVER := FALSE;
      SESSION.DATABASE.CONFIGURATION.RECOVERED := FALSE;

      FOR L_ROW IN 1 .. 2
      LOOP
         IF ( LTLICCHECKOK4APP( L_ROW ) IN( IAPICONSTANTDBERROR.DBERR_SUCCESS, IAPICONSTANTDBERROR.DBERR_OK_NO_ALM ) )
         THEN
            LBANYVALIDLICENSEFOUND := TRUE;

            IF LTLICCHECKOK4APP( L_ROW ) = IAPICONSTANTDBERROR.DBERR_SUCCESS
            THEN
               IF NVL( LTAPPCUSTOMPARAM( L_ROW ),
                       'I0' ) IN( 'T0', 'T3' )
               THEN
                  SESSION.DATABASE.CONFIGURATION.TESTSERVER := TRUE;
                  IAPIGENERAL.LOGINFO( GSSOURCE,
                                       LSMETHOD,
                                       'Test server installed.' );
               ELSE
                  SESSION.DATABASE.CONFIGURATION.TESTSERVER := FALSE;
               END IF;

               SESSION.DATABASE.CONFIGURATION.RECOVERED := FALSE;
            END IF;

            EXIT;
         END IF;
      END LOOP;

      
      FOR L_ROW IN 11 .. 12
      LOOP
         IF ( LTLICCHECKOK4APP( L_ROW ) IN( IAPICONSTANTDBERROR.DBERR_SUCCESS, IAPICONSTANTDBERROR.DBERR_OK_NO_ALM ) )
         THEN
            LBANYVALIDLICENSEFOUND := TRUE;

            IF LTLICCHECKOK4APP( L_ROW ) = IAPICONSTANTDBERROR.DBERR_SUCCESS
            THEN
               IF NVL( LTAPPID( L_ROW ),
                       'IISS' ) IN( 'RISS' )
               THEN
                  SESSION.DATABASE.CONFIGURATION.RECOVERED := TRUE;

                  IAPIGENERAL.LOGINFO( GSSOURCE,
                                       LSMETHOD,
                                       'Recovered license present.' );
               ELSE
                  SESSION.DATABASE.CONFIGURATION.RECOVERED := FALSE;
               END IF;
            END IF;

            EXIT;
         END IF;
      END LOOP;
      


      IF NOT LBANYVALIDLICENSEFOUND
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'CheckLicence = '
                              || TO_CHAR( LTLICCHECKOK4APP( 8 ) )
                              || ' No valid licence key found.' );
         RETURN( IAPIGENERAL.SETERRORTEXT( LTLICCHECKOK4APP( 8 ) ) );
      END IF;

      IF LTLICCHECKOK4APP( 2 ) = IAPICONSTANTDBERROR.DBERR_SUCCESS
      THEN
         ANFDA21CFR11ENABLED := 1;
      ELSE
         ANFDA21CFR11ENABLED := 0;
      END IF;

      LNNOROWS := 1;
      LTAPPID( 1 ) := 'IISC';
      LTAPPVERSION( 1 ) := ASAPPVERSION;

      IF     IAPIGENERAL.SESSION.APPLICATIONUSER.USERPROFILE = IAPICONSTANT.USERROLE_VIEWONLY
         AND NOT SESSION.DATABASE.CONFIGURATION.TESTSERVER
      THEN
         LTAPPCUSTOMPARAM( 1 ) := 'R0';
      ELSE
         LTAPPCUSTOMPARAM( 1 ) := 'I0';
      END IF;

      IF ASMACHINENAME IS NULL
      THEN
         LTLOGONSTATION( 1 ) := SYS_CONTEXT( 'USERENV',
                                             'TERMINAL' );
      ELSE
         LTLOGONSTATION( 1 ) := ASMACHINENAME;
      END IF;

      LTUSERSID( 1 ) := SYS_CONTEXT( 'USERENV',
                                     'SESSION_USERID' );
      LTUSERNAME( 1 ) := SYS_CONTEXT( 'USERENV',
                                      'SESSION_USER' );
      LNRETVAL :=
            CXSAPILK.GRANTLICENSE( LTAPPID,
                                   LTAPPVERSION,
                                   LTAPPCUSTOMPARAM,
                                   LTLOGONSTATION,
                                   LTUSERSID,
                                   LTUSERNAME,
                                   LNNOROWS,
                                   LTERRORCODE,
                                   LSERRORMSG );
      IAPIGENERAL.LICENCECUSTOMPARAM := LTAPPCUSTOMPARAM( 1 );

      
      
      
      
      IF LNRETVAL = 11
      
      THEN
         LNRETVAL := IAPICONSTANTDBERROR.DBERR_NORECORDS;
         RETURN( IAPIGENERAL.SETERRORTEXT( LNRETVAL ) );
      END IF;

      IF    ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         OR (     LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS
              AND LTERRORCODE( 1 ) <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IF     IAPIGENERAL.SESSION.APPLICATIONUSER.USERPROFILE = IAPICONSTANT.USERROLE_VIEWONLY
            AND NOT SESSION.DATABASE.CONFIGURATION.TESTSERVER
         THEN
            LNRETVALCONFIG := IAPIGENERAL.GETCONFIGURATIONSETTING( ASPARAMETER => 'allow_full_user',
                                                                   ASPARAMETERDATA => LSALLOWFULLUSER );

            IF LNRETVALCONFIG <> IAPICONSTANTDBERROR.DBERR_SUCCESS
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     IAPIGENERAL.GETLASTERRORTEXT( ) );
               RETURN( LNRETVALCONFIG );
            END IF;


            IF NVL( LSALLOWFULLUSER,
                    '0' ) = '1'
            THEN
               LTAPPCUSTOMPARAM( 1 ) := 'I0';
               LNRETVAL :=
                  CXSAPILK.GRANTLICENSE( LTAPPID,
                                         LTAPPVERSION,
                                         LTAPPCUSTOMPARAM,
                                         LTLOGONSTATION,
                                         LTUSERSID,
                                         LTUSERNAME,
                                         LNNOROWS,
                                         LTERRORCODE,
                                         LSERRORMSG );
               IAPIGENERAL.LICENCECUSTOMPARAM := LTAPPCUSTOMPARAM( 1 );

               IF LNRETVAL = 11
               THEN
                  LNRETVAL := IAPICONSTANTDBERROR.DBERR_NORECORDS;
               END IF;

               IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
               THEN
                  RETURN( IAPIGENERAL.SETERRORTEXT( LNRETVAL ) );
               ELSIF( LTERRORCODE( 1 ) <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
               THEN
                  RETURN( IAPIGENERAL.SETERRORTEXT( LTERRORCODE( 1 ) ) );
               END IF;
            ELSE
               IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
               THEN
                  RETURN( IAPIGENERAL.SETERRORTEXT( LNRETVAL ) );
               ELSIF( LTERRORCODE( 1 ) <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
               THEN
                  RETURN( IAPIGENERAL.SETERRORTEXT( LTERRORCODE( 1 ) ) );
               END IF;
            END IF;
         ELSE
            IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               RETURN( IAPIGENERAL.SETERRORTEXT( LNRETVAL ) );
            ELSIF( LTERRORCODE( 1 ) <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               RETURN( IAPIGENERAL.SETERRORTEXT( LTERRORCODE( 1 ) ) );
            END IF;
         END IF;
      END IF;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'License granted for machine <'
                           || LTLOGONSTATION( 1 )
                           || '>',
                           IAPICONSTANT.INFOLEVEL_1 );
      LICENSEGRANTED := TRUE;
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IF SQLCODE = -20000
         THEN
            LASTERRORTEXT := SUBSTR( SQLERRM( SQLCODE ),
                                     11 );
            RETURN( IAPICONSTANTDBERROR.DBERR_GENFAIL );
         ELSE
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
         END IF;
   END CHECKLICENSE;

   
   FUNCTION CHECKLICENSERDMODULES(
      ASMACHINENAME              IN       IAPITYPE.MACHINENAME_TYPE DEFAULT NULL,
      ASAPPVERSION               IN       IAPITYPE.LICENSEVERSION_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckLicenseRDModules';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNRETVALCONFIG                IAPITYPE.ERRORNUM_TYPE;
      LSALLOWFULLUSER               IAPITYPE.STRING_TYPE;
      LTAPPID                       CXSAPILK.VC20_TABLE_TYPE;
      LTAPPVERSION                  CXSAPILK.VC20_TABLE_TYPE;
      LTAPPCUSTOMPARAM              CXSAPILK.VC20_TABLE_TYPE;
      LTLICCHECKOK4APP              CXSAPILK.NUM_TABLE_TYPE;
      LTMAXUSERS4APP                CXSAPILK.NUM_TABLE_TYPE;
      LTUSERSID                     CXSAPILK.VC20_TABLE_TYPE;
      LTUSERNAME                    CXSAPILK.VC20_TABLE_TYPE;
      LTERRORCODE                   CXSAPILK.NUM_TABLE_TYPE;
      LTLOGONSTATION                CXSAPILK.VC40_TABLE_TYPE;
      LNNOROWS                      NUMBER;
      LSERRORMSG                    VARCHAR2( 255 );
      LBANYVALIDLICENSEFOUND        BOOLEAN;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LICENSEGRANTEDRD := FALSE;
      LNNOROWS := 1;
      LTAPPID( 1 ) := 'IISS';
      LTAPPVERSION( 1 ) := ASAPPVERSION;
      LTAPPCUSTOMPARAM( 1 ) := 'I6';
      LNRETVAL := CXSAPILK.CHECKLICENSE( LTAPPID,
                                         LTAPPVERSION,
                                         LTAPPCUSTOMPARAM,
                                         LTLICCHECKOK4APP,
                                         LTMAXUSERS4APP,
                                         LNNOROWS,
                                         LSERRORMSG );

      IF LNRETVAL = 2
      THEN
         LNRETVAL := IAPICONSTANTDBERROR.DBERR_NORECORDS;
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'CheckLicence = '
                              || TO_CHAR( LNRETVAL )
                              || ' No licence key installed.' );
      END IF;

      IF ( LNRETVAL NOT IN( IAPICONSTANTDBERROR.DBERR_SUCCESS, IAPICONSTANTDBERROR.DBERR_OK_NO_ALM, IAPICONSTANTDBERROR.DBERR_NOLICENSE4APP ) )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     LNRETVAL ) );
      END IF;

      IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_NOLICENSE4APP )
      THEN
         RETURN( LNRETVAL );
      END IF;

      LICENSEGRANTEDRD := TRUE;
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IF SQLCODE = -20000
         THEN
            LASTERRORTEXT := SUBSTR( SQLERRM( SQLCODE ),
                                     11 );
            RETURN( IAPICONSTANTDBERROR.DBERR_GENFAIL );
         ELSE
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
         END IF;
   END CHECKLICENSERDMODULES;

   
   FUNCTION CHECKLICENSESRD
      RETURN IAPITYPE.NUMVAL_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckLicensesRD';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSMACHINENAME                 IAPITYPE.MACHINENAME_TYPE DEFAULT NULL;
   BEGIN
      
      
      
      LNRETVAL := CHECKLICENSERDMODULES( LSMACHINENAME,
                                         GSAPPVERSION1 );

      IF NOT LICENSEGRANTEDRD
      THEN
         LNRETVAL := CHECKLICENSERDMODULES( LSMACHINENAME,
                                            GSAPPVERSION2 );
      END IF;


      IF LICENSEGRANTEDRD
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              'LicenseGrantedRD ',
                              IAPICONSTANT.INFOLEVEL_3 );
         RETURN 1;
      ELSE
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              ' Not LicenseGrantedRD ',
                              IAPICONSTANT.INFOLEVEL_3 );
         RETURN 0;
      END IF;
   END CHECKLICENSESRD;

   
   
   FUNCTION CHECKLICENSEGIL2(
      ASMACHINENAME              IN       IAPITYPE.MACHINENAME_TYPE DEFAULT NULL,
      ASAPPVERSION               IN       IAPITYPE.LICENSEVERSION_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckLicenseGIL2';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNRETVALCONFIG                IAPITYPE.ERRORNUM_TYPE;
      LSALLOWFULLUSER               IAPITYPE.STRING_TYPE;
      LTAPPID                       CXSAPILK.VC20_TABLE_TYPE;
      LTAPPVERSION                  CXSAPILK.VC20_TABLE_TYPE;
      LTAPPCUSTOMPARAM              CXSAPILK.VC20_TABLE_TYPE;
      LTLICCHECKOK4APP              CXSAPILK.NUM_TABLE_TYPE;
      LTMAXUSERS4APP                CXSAPILK.NUM_TABLE_TYPE;
      LTUSERSID                     CXSAPILK.VC20_TABLE_TYPE;
      LTUSERNAME                    CXSAPILK.VC20_TABLE_TYPE;
      LTERRORCODE                   CXSAPILK.NUM_TABLE_TYPE;
      LTLOGONSTATION                CXSAPILK.VC40_TABLE_TYPE;
      LNNOROWS                      NUMBER;
      LSERRORMSG                    VARCHAR2( 255 );
      LBANYVALIDLICENSEFOUND        BOOLEAN;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      LICENSEGRANTEDGIL := FALSE;

      LNNOROWS := 1;
      LTAPPID( 1 ) := 'IGIL';
      LTAPPVERSION( 1 ) := ASAPPVERSION;
      LTAPPCUSTOMPARAM( 1 ) := 'I0';

      LNRETVAL := CXSAPILK.CHECKLICENSE( LTAPPID,
                                         LTAPPVERSION,
                                         LTAPPCUSTOMPARAM,
                                         LTLICCHECKOK4APP,
                                         LTMAXUSERS4APP,
                                         LNNOROWS,
                                         LSERRORMSG );

      IF LNRETVAL = 2
      THEN
         LNRETVAL := IAPICONSTANTDBERROR.DBERR_NORECORDS;
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'CheckLicence = '
                              || TO_CHAR( LNRETVAL )
                              || ' No licence key installed.' );
      END IF;

      IF ( LNRETVAL NOT IN( IAPICONSTANTDBERROR.DBERR_SUCCESS, IAPICONSTANTDBERROR.DBERR_OK_NO_ALM, IAPICONSTANTDBERROR.DBERR_NOLICENSE4APP ) )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     LNRETVAL ) );
      END IF;

      IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_NOLICENSE4APP )
      THEN
         RETURN( LNRETVAL );
      END IF;

      LICENSEGRANTEDGIL := TRUE;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IF SQLCODE = -20000
         THEN
            LASTERRORTEXT := SUBSTR( SQLERRM( SQLCODE ),
                                     11 );
            RETURN( IAPICONSTANTDBERROR.DBERR_GENFAIL );
         ELSE
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
         END IF;
   END CHECKLICENSEGIL2;
   

   
   
   FUNCTION CHECKLICENSESGIL
      RETURN IAPITYPE.NUMVAL_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckLicensesGIL';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSMACHINENAME                 IAPITYPE.MACHINENAME_TYPE DEFAULT NULL;
   BEGIN
      
      
      
      LNRETVAL := CHECKLICENSEGIL2( LSMACHINENAME,
                                         GSAPPVERSION1 );

      IF NOT LICENSEGRANTEDGIL
      THEN
         LNRETVAL := CHECKLICENSEGIL2( LSMACHINENAME,
                                            GSAPPVERSION2 );
      END IF;


      IF LICENSEGRANTEDGIL
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              'LicenseGrantedGIL ',
                              IAPICONSTANT.INFOLEVEL_3 );
         RETURN 1;
      ELSE
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              ' Not LicenseGrantedGIL ',
                              IAPICONSTANT.INFOLEVEL_3 );
         RETURN 0;
      END IF;
   END CHECKLICENSESGIL;
   


   
   FUNCTION CHECKLICENSESSCCSERVER
      RETURN IAPITYPE.NUMVAL_TYPE
   IS
      
      
      
      
      
      
     
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckLicensesSCC';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LTAPPID                       CXSAPILK.VC20_TABLE_TYPE;
      LTAPPVERSION                  CXSAPILK.VC20_TABLE_TYPE;
      LTAPPCUSTOMPARAM              CXSAPILK.VC20_TABLE_TYPE;
      LTLICCHECKOK4APP              CXSAPILK.NUM_TABLE_TYPE;
      LTMAXUSERS4APP                CXSAPILK.NUM_TABLE_TYPE;
      LNNOROWS                      NUMBER;
      LSERRORMSG                    VARCHAR2( 255 );

      LNVAL1                      IAPITYPE.ERRORNUM_TYPE;

   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      LNNOROWS := 1;

      LTAPPID( 1 ) := 'ISCS';
      LTAPPVERSION( 1 ) := '0200';
      LTAPPCUSTOMPARAM( 1 ) := 'R0';

      LNRETVAL := CXSAPILK.CHECKLICENSE( LTAPPID,
                                         LTAPPVERSION,
                                         LTAPPCUSTOMPARAM,
                                         LTLICCHECKOK4APP,
                                         LTMAXUSERS4APP,
                                         LNNOROWS,
                                         LSERRORMSG );

      IF ( LNRETVAL NOT IN( IAPICONSTANTDBERROR.DBERR_SUCCESS, IAPICONSTANTDBERROR.DBERR_OK_NO_ALM, IAPICONSTANTDBERROR.DBERR_NOLICENSE4APP, IAPICONSTANTDBERROR.DBERR_LICENSEEXPIRED ) )
      THEN
         
         RETURN -1;
      END IF;

      IF ( LNRETVAL IN (IAPICONSTANTDBERROR.DBERR_NOLICENSE4APP, IAPICONSTANTDBERROR.DBERR_LICENSEEXPIRED ) )
      THEN
         
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              'No SCC Server license found',
                              IAPICONSTANT.INFOLEVEL_3 );

         RETURN -2;
      END IF;

      RETURN 0;

   EXCEPTION
      WHEN OTHERS
      THEN
        
         IF SQLCODE = -20000
         THEN
            NULL;
            
         END IF;

        
        RETURN -1;

   END CHECKLICENSESSCCSERVER;
   
  
   FUNCTION CHECKLICENSESSCCCLIENT
      RETURN IAPITYPE.NUMVAL_TYPE
   IS
      
      
      
      
      
      
     
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckLicensesSCC';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LTAPPID                       CXSAPILK.VC20_TABLE_TYPE;
      LTAPPVERSION                  CXSAPILK.VC20_TABLE_TYPE;
      LTAPPCUSTOMPARAM              CXSAPILK.VC20_TABLE_TYPE;
      LTLICCHECKOK4APP              CXSAPILK.NUM_TABLE_TYPE;
      LTMAXUSERS4APP                CXSAPILK.NUM_TABLE_TYPE;
      LNNOROWS                      NUMBER;
      LSERRORMSG                    VARCHAR2( 255 );

      LNVAL1                      IAPITYPE.ERRORNUM_TYPE;

   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      
      


          LNNOROWS := 4;

          LTAPPID( 1 ) := 'ISCS';
          LTAPPVERSION( 1 ) := '0200';
          LTAPPCUSTOMPARAM( 1 ) := 'C0';

          LTAPPID( 2 ) := 'ISCS';
          LTAPPVERSION( 2 ) := '0200';
          LTAPPCUSTOMPARAM( 2 ) := 'C1';

          LTAPPID( 3 ) := 'ISCS';
          LTAPPVERSION( 3 ) := '0200';
          LTAPPCUSTOMPARAM( 3 ) := 'C2';

          LTAPPID( 4 ) := 'ISCS';
          LTAPPVERSION( 4 ) := '0200';
          LTAPPCUSTOMPARAM( 4 ) := 'C3';

          LNRETVAL := CXSAPILK.CHECKLICENSE( LTAPPID,
                                             LTAPPVERSION,
                                             LTAPPCUSTOMPARAM,
                                             LTLICCHECKOK4APP,
                                             LTMAXUSERS4APP,
                                             LNNOROWS,
                                             LSERRORMSG );


          IF ( LNRETVAL NOT IN( IAPICONSTANTDBERROR.DBERR_SUCCESS, IAPICONSTANTDBERROR.DBERR_OK_NO_ALM, IAPICONSTANTDBERROR.DBERR_NOLICENSE4APP, IAPICONSTANTDBERROR.DBERR_LICENSEEXPIRED ) )
          THEN

             
             IAPIGENERAL.LOGINFO( GSSOURCE,
                                  LSMETHOD,
                                  'No SCC Supplier license found',
                                  IAPICONSTANT.INFOLEVEL_3 );

             RETURN -1;
          END IF;

          IF  ( LNRETVAL IN (IAPICONSTANTDBERROR.DBERR_NOLICENSE4APP, IAPICONSTANTDBERROR.DBERR_LICENSEEXPIRED ) )
          THEN
             
             RETURN -3;
          END IF;

          
    
    
    
    

          LNVAL1 :=  LTMAXUSERS4APP(1);  
         IF LNVAL1 >= 99999
          THEN
            RETURN 99999;
         END IF;
         IF LNVAL1 > 0 AND LNVAL1 < 99999
          THEN
            RETURN LNVAL1;
          ELSE
            RETURN 0;
         END IF;

     RETURN 0;

   EXCEPTION
      WHEN OTHERS
      THEN
        
         IF SQLCODE = -20000
         THEN
            NULL;
            
         END IF;

        
        RETURN -1;

   END CHECKLICENSESSCCCLIENT;
   

   
   FUNCTION SETCONNECTION(
      ASUSERID                   IN       IAPITYPE.USERID_TYPE DEFAULT USER,
      ASMODULENAME               IN       IAPITYPE.STRING_TYPE DEFAULT '',
      ANGRANTLICENSE             IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ASMACHINENAME              IN       IAPITYPE.MACHINENAME_TYPE DEFAULT NULL )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SetConnection';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSDATABASE                    IAPITYPE.DATABASETYPE_TYPE;
      ANGLOSSARYALLOWED             IAPITYPE.BOOLEAN_TYPE;
      ANFDA21CFR11ENABLED           IAPITYPE.BOOLEAN_TYPE;
   BEGIN
      LNRETVAL := SETCONNECTION( ASUSERID,
                                 ASMODULENAME,
                                 LSDATABASE,
                                 ANGLOSSARYALLOWED,
                                 ANFDA21CFR11ENABLED,
                                 ANGRANTLICENSE,
                                 ASMACHINENAME );

      IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
      THEN
         RETURN LNRETVAL;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SETCONNECTION;

   
   FUNCTION SETCONNECTION(
      ASUSERID                   IN       IAPITYPE.USERID_TYPE DEFAULT USER,
      ASMODULENAME               IN       IAPITYPE.STRING_TYPE DEFAULT '',
      ASDATABASETYPE             OUT      IAPITYPE.DATABASETYPE_TYPE,
      ANGLOSSARYALLOWED          OUT      IAPITYPE.BOOLEAN_TYPE,
      ANFDA21CFR11ENABLED        OUT      IAPITYPE.BOOLEAN_TYPE,
      ANGRANTLICENSE             IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ASMACHINENAME              IN       IAPITYPE.MACHINENAME_TYPE DEFAULT NULL,
      ASDECIMALSEPERATOR         IN       IAPITYPE.STRING_TYPE DEFAULT NULL )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SetConnection';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNEXECUTECURSOR               NUMBER;
      LCSQL                         CLOB;
      LSSQLALTER                    VARCHAR2( 1000 );
      LNTRACELEVEL                  NUMBER := 0;
      LSUSERPROFILE                 IAPITYPE.USERPROFILE_TYPE;
      LBGRANTEDROLEDBA              IAPITYPE.BOOLEAN_TYPE;
      LSSCHEMANAME                  IAPITYPE.DATABASESCHEMANAME_TYPE;
      LSOVERRULESQLNET              IAPITYPE.PARAMETERDATA_TYPE;
   BEGIN
      
      
      
      
      
      LNRETVAL := IAPIUSERS.EXISTID( ASUSERID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( LNRETVAL );
      END IF;

      LNRETVAL := IAPIDATABASE.GETSCHEMANAME( LSSCHEMANAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( LNRETVAL );
      END IF;

      BEGIN
         SELECT USER_PROFILE
           INTO LSUSERPROFILE
           FROM APPLICATION_USER
          WHERE USER_ID = USER;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            LSUSERPROFILE := NULL;
         WHEN OTHERS
         THEN
            LSUSERPROFILE := NULL;
      END;

      BEGIN
         SELECT 1
           INTO LBGRANTEDROLEDBA
           FROM DBA_ROLE_PRIVS
          WHERE GRANTEE = USER
            AND GRANTED_ROLE IN( 'DBA', 'INTERSPCDBA' );
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            LBGRANTEDROLEDBA := 0;
         WHEN OTHERS
         THEN
            LBGRANTEDROLEDBA := 0;
      END;

      
      
      IF USER = ASUSERID
      THEN
         NULL;
      ELSIF USER = LSSCHEMANAME
      THEN
         NULL;
      ELSIF     LSUSERPROFILE IS NOT NULL
            AND LSUSERPROFILE = IAPICONSTANT.USERROLE_CONFIGURATOR
      THEN
         NULL;
      ELSIF LBGRANTEDROLEDBA = 1
      THEN
         NULL;
      ELSE
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOACCESSSETCONNECTION,
                                                    ASUSERID );
      END IF;

      
      
      
           
      DBMS_APPLICATION_INFO.SET_MODULE( ASMODULENAME,
                                        NULL );
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Session marked with modulename <'
                           || ASMODULENAME
                           || '>',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIGENERAL.INITIALISESESSION( ASUSERID );

      IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
      THEN
         RETURN LNRETVAL;
      END IF;

      IF ASDECIMALSEPERATOR IS NOT NULL
      THEN
         LSSQLALTER :=    'ALTER SESSION SET NLS_NUMERIC_CHARACTERS = '''
                       || ASDECIMALSEPERATOR
                       || ' ''';

         EXECUTE IMMEDIATE LSSQLALTER;
      END IF;

      
      SP_SET_SPEC_ACCESS;

      IF SESSION.DATABASE.CONFIGURATION.GLOSSARY
      THEN
         ANGLOSSARYALLOWED := 1;
      ELSE
         ANGLOSSARYALLOWED := 0;
      END IF;

      ASDATABASETYPE := SESSION.DATABASE.DATABASETYPE;

      
      
      BEGIN
         BEGIN
            
            SELECT TO_NUMBER( VALUE )
              INTO LNTRACELEVEL
              FROM ITUSPREF
             WHERE USER_ID = SESSION.APPLICATIONUSER.USERID
               AND SECTION_NAME = 'General'
               AND PREF = 'Trace';
         EXCEPTION
            WHEN OTHERS
            THEN
               NULL;
         END;

         IF LNTRACELEVEL > 0
         THEN
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 'Trying to start database tracing' );
            LNEXECUTECURSOR := DBMS_SQL.OPEN_CURSOR;
            LCSQL := 'ALTER SESSION SET SQL_TRACE = TRUE';
            DBMS_SQL.PARSE( LNEXECUTECURSOR,
                            LCSQL,
                            DBMS_SQL.V7 );   
            LNRETVAL := DBMS_SQL.EXECUTE( LNEXECUTECURSOR );

            IF LNTRACELEVEL > 1
            THEN
               LCSQL := 'ALTER SESSION SET EVENTS=''10046 TRACE NAME CONTEXT FOREVER, LEVEL 4''';
               DBMS_SQL.PARSE( LNEXECUTECURSOR,
                               LCSQL,
                               DBMS_SQL.V7 );   
               LNRETVAL := DBMS_SQL.EXECUTE( LNEXECUTECURSOR );
            END IF;

            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                    'Database tracing with level <'
                                 || TO_CHAR( LNTRACELEVEL )
                                 || '> was started' );
            DBMS_SQL.CLOSE_CURSOR( LNEXECUTECURSOR );
         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            
            IF ( DBMS_SQL.IS_OPEN( LNEXECUTECURSOR ) )
            THEN
               DBMS_SQL.CLOSE_CURSOR( LNEXECUTECURSOR );
            END IF;
      END;

      IF ANGRANTLICENSE = 1
      THEN
         LNRETVAL := CHECKLICENSE( ASMACHINENAME,
                                   GSAPPVERSION1,
                                   ANFDA21CFR11ENABLED );

         IF NOT LICENSEGRANTED
         THEN
            LNRETVAL := CHECKLICENSE( ASMACHINENAME,
                                      GSAPPVERSION2,
                                      ANFDA21CFR11ENABLED );
         END IF;

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;

         
         LICENSEFREE := FALSE;

      END IF;



      LNRETVAL := IAPIGENERAL.GETCONFIGURATIONSETTING( ASPARAMETER => 'overrule_sqlnet',
                                                       ASPARAMETERDATA => LSOVERRULESQLNET );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      ELSE
         IF LSOVERRULESQLNET = '1'
         THEN
            SP_SET_PARAMETERS;
         END IF;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SETCONNECTION;

   
   FUNCTION TRANSFORMTOXMLDOMDOCUMENT(
      ATERROR                    IN       IAPITYPE.ERRORTAB_TYPE,
      AXERRORLIST                OUT      IAPITYPE.XMLDOMDOCUMENT_TYPE,
      ASKEY1                     IN       IAPITYPE.OPTPARAM_TYPE DEFAULT NULL,
      ASKEY1VALUE                IN       IAPITYPE.OPTPARAM_TYPE DEFAULT NULL,
      ASKEY2                     IN       IAPITYPE.OPTPARAM_TYPE DEFAULT NULL,
      ASKEY2VALUE                IN       IAPITYPE.OPTPARAM_TYPE DEFAULT NULL,
      ASKEY3                     IN       IAPITYPE.OPTPARAM_TYPE DEFAULT NULL,
      ASKEY3VALUE                IN       IAPITYPE.OPTPARAM_TYPE DEFAULT NULL,
      ASKEY4                     IN       IAPITYPE.OPTPARAM_TYPE DEFAULT NULL,
      ASKEY4VALUE                IN       IAPITYPE.OPTPARAM_TYPE DEFAULT NULL,
      ASKEY5                     IN       IAPITYPE.OPTPARAM_TYPE DEFAULT NULL,
      ASKEY5VALUE                IN       IAPITYPE.OPTPARAM_TYPE DEFAULT NULL )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'TransformToXmlDomDocument';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LXPARSER                      XMLPARSER.PARSER;
      LBPARSERCREATED               BOOLEAN;
      LXDOMELEMENT                  IAPITYPE.XMLDOMDOCUMENT_TYPE;
      LXDATA                        IAPITYPE.XMLTYPE_TYPE;
      LRERROR                       IAPITYPE.ERRORREC_TYPE;
      I                             NUMBER;
      LCDATA                        CLOB;
   BEGIN
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Number of items in error table: '
                           || ATERROR.COUNT,
                           IAPICONSTANT.INFOLEVEL_3 );

      FOR I IN 0 ..   ATERROR.COUNT
                    - 1
      LOOP
         LRERROR := ATERROR( I );
         LCDATA :=    LCDATA
                   || '<error parameterid="'
                   || LRERROR.ERRORPARAMETERID
                   || '" errortext="'
                   || LRERROR.ERRORTEXT
                   || '"></error>';
      END LOOP;

      IF ( ASKEY5 IS NOT NULL )
      THEN
         LNRETVAL := ENCAPSULATEINXMLKEY( LCDATA,
                                          ASKEY5,
                                          ASKEY5VALUE );
      END IF;

      IF ( ASKEY4 IS NOT NULL )
      THEN
         LNRETVAL := ENCAPSULATEINXMLKEY( LCDATA,
                                          ASKEY4,
                                          ASKEY4VALUE );
      END IF;

      IF ( ASKEY3 IS NOT NULL )
      THEN
         LNRETVAL := ENCAPSULATEINXMLKEY( LCDATA,
                                          ASKEY3,
                                          ASKEY3VALUE );
      END IF;

      IF ( ASKEY2 IS NOT NULL )
      THEN
         LNRETVAL := ENCAPSULATEINXMLKEY( LCDATA,
                                          ASKEY2,
                                          ASKEY2VALUE );
      END IF;

      IF ( ASKEY1 IS NOT NULL )
      THEN
         LNRETVAL := ENCAPSULATEINXMLKEY( LCDATA,
                                          ASKEY1,
                                          ASKEY1VALUE );
      END IF;

      LNRETVAL := ENCAPSULATEINXMLKEY( LCDATA,
                                       'root',
                                       'root' );
      LXDATA := XMLTYPE( LCDATA );
      
      LXPARSER := XMLPARSER.NEWPARSER;
      LBPARSERCREATED := TRUE;
      XMLPARSER.SETVALIDATIONMODE( LXPARSER,
                                   FALSE );
      XMLPARSER.PARSECLOB( LXPARSER,
                           LXDATA.GETCLOBVAL( ) );
      AXERRORLIST := XMLPARSER.GETDOCUMENT( LXPARSER );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END TRANSFORMTOXMLDOMDOCUMENT;

   
   FUNCTION ENCAPSULATEINXMLKEY(
      AXTEXT                     IN OUT   IAPITYPE.CLOB_TYPE,
      ASKEY                      IN       IAPITYPE.OPTPARAM_TYPE,
      ASKEYVALUE                 IN       IAPITYPE.OPTPARAM_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'EncapsulateInXmlKey';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      AXTEXT :=    '<'
                || ASKEY
                || ' value="'
                || ASKEYVALUE
                || '">'
                || AXTEXT
                || '</'
                || ASKEY
                || '>';
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ENCAPSULATEINXMLKEY;

   
   FUNCTION EXECUTECUSTOMFUNCTION(
      ASSTANDARDPACKAGE          IN       IAPITYPE.STRING_TYPE,
      ASSTANDARDFUNCTION         IN       IAPITYPE.STRING_TYPE,
      ASCUSTOMTYPE               IN       IAPITYPE.STRING_TYPE,
      ATERRORS                   IN OUT NOCOPY ERRORDATATABLE_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExecuteCustomFunction';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LBRECORDSFOUND                BOOLEAN := FALSE;
      LNEXECUTECURSOR               NUMBER;
      LCSQL                         CLOB;
      LNINDEX                       NUMBER;

      CURSOR LCGETPROCEDURENAME
      IS
         SELECT   PROCEDURE_NAME
             FROM ITCF
            WHERE UPPER( STANDARD_FUNCTION ) = UPPER( TRIM(    ASSTANDARDPACKAGE
                                                            || '.'
                                                            || ASSTANDARDFUNCTION ) )
              AND UPPER( CF_TYPE ) = UPPER( ASCUSTOMTYPE )
              AND CUSTOM = 1
         ORDER BY CF_ID;
   BEGIN
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'About lo launch custom objects for <'
                           || TRIM(    ASSTANDARDPACKAGE
                                    || '.'
                                    || ASSTANDARDFUNCTION )
                           || '>',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      LNEXECUTECURSOR := DBMS_SQL.OPEN_CURSOR;

      FOR LSPROCEDURENAME IN LCGETPROCEDURENAME
      LOOP
         LBRECORDSFOUND := TRUE;
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'About lo launch custom object <'
                              || LSPROCEDURENAME.PROCEDURE_NAME
                              || '>',
                              IAPICONSTANT.INFOLEVEL_3 );
         LCSQL :=    'BEGIN '
                  || LSPROCEDURENAME.PROCEDURE_NAME
                  || '; END;';
         DBMS_SQL.PARSE( LNEXECUTECURSOR,
                         LCSQL,
                         DBMS_SQL.V7 );
         
         
         LNRETVAL := DBMS_SQL.EXECUTE( LNEXECUTECURSOR );
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              'Back in launch function',
                              IAPICONSTANT.INFOLEVEL_3 );

         
         IF ( ATERRORS.COUNT > 0 )
         THEN
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                    'Errors ('
                                 || ATERRORS.COUNT
                                 || ') added by the custom function',
                                 IAPICONSTANT.INFOLEVEL_3 );
            DBMS_SQL.CLOSE_CURSOR( LNEXECUTECURSOR );
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_ERRORLIST ) );
         END IF;
      END LOOP;

      DBMS_SQL.CLOSE_CURSOR( LNEXECUTECURSOR );

      IF ( LBRECORDSFOUND = FALSE )
      THEN
         
         LNRETVAL :=
            IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                LSMETHOD,
                                                IAPICONSTANTDBERROR.DBERR_NOCUSTOMFUNCTION,
                                                ASSTANDARDPACKAGE,
                                                ASSTANDARDFUNCTION,
                                                ASCUSTOMTYPE );
      END IF;

      
      IF ( ATERRORS.COUNT > 0 )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'Already errors ('
                              || ATERRORS.COUNT
                              || ') in the error list',
                              IAPICONSTANT.INFOLEVEL_3 );
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_ERRORLIST ) );
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IF ( DBMS_SQL.IS_OPEN( LNEXECUTECURSOR ) )
         THEN
            DBMS_SQL.CLOSE_CURSOR( LNEXECUTECURSOR );
         END IF;

         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_APPLICATIONERROR,
                                               SQLCODE,
                                               SQLERRM );
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( IAPICONSTANTDBERROR.DBERR_APPLICATIONERROR );
   END EXECUTECUSTOMFUNCTION;

   
   FUNCTION ESCQUOTE(
      ASINPUTSTRING              IN       IAPITYPE.CLOB_TYPE )
      RETURN IAPITYPE.CLOB_TYPE
   IS
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'EscQuote';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSOUTPUTSTRING                IAPITYPE.CLOB_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSOUTPUTSTRING := REPLACE( ASINPUTSTRING,
                                 CHR( 39 ),
                                    CHR( 39 )
                                 || CHR( 39 ) );
      RETURN( LSOUTPUTSTRING );
   END ESCQUOTE;

   
   FUNCTION TRANSFORMFILTERRECORD(
      ARFILTERRECORD             IN       IAPITYPE.FILTERREC_TYPE,
      ASOUTPUTSTRING             OUT      IAPITYPE.STRING_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'TransformFilterRecord';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      CASE UPPER( ARFILTERRECORD.OPERATOR )
         WHEN UPPER( IAPICONSTANT.OPERATOR_EQUAL )
         THEN
            ASOUTPUTSTRING :=    ARFILTERRECORD.LEFTOPERAND
                              || ' '
                              || ARFILTERRECORD.OPERATOR
                              || ' '''
                              || ARFILTERRECORD.RIGHTOPERAND
                              || '''';
         WHEN UPPER( IAPICONSTANT.OPERATOR_NOTEQUAL )
         THEN
            ASOUTPUTSTRING :=    ARFILTERRECORD.LEFTOPERAND
                              || ' '
                              || ARFILTERRECORD.OPERATOR
                              || ' '''
                              || ARFILTERRECORD.RIGHTOPERAND
                              || '''';
         WHEN UPPER( IAPICONSTANT.OPERATOR_LIKE )
         THEN
            ASOUTPUTSTRING :=
                  IAPIGENERAL.TOUPPER( ARFILTERRECORD.LEFTOPERAND )
               || ' '
               || ARFILTERRECORD.OPERATOR
               || ' '
               || IAPIGENERAL.TOUPPER(    '''%'
                                       || ARFILTERRECORD.RIGHTOPERAND
                                       || '%''' );
         WHEN UPPER( IAPICONSTANT.OPERATOR_NOTLIKE )
         THEN
            ASOUTPUTSTRING :=
                  IAPIGENERAL.TOUPPER( ARFILTERRECORD.LEFTOPERAND )
               || ' '
               || ARFILTERRECORD.OPERATOR
               || ' '
               || IAPIGENERAL.TOUPPER(    '''%'
                                       || ARFILTERRECORD.RIGHTOPERAND
                                       || '%''' );
         WHEN UPPER( IAPICONSTANT.OPERATOR_BEGINWITH )
         THEN
            ASOUTPUTSTRING :=
                     IAPIGENERAL.TOUPPER( ARFILTERRECORD.LEFTOPERAND )
                  || ' LIKE '
                  || IAPIGENERAL.TOUPPER(    ''''
                                          || ARFILTERRECORD.RIGHTOPERAND
                                          || '%''' );
         WHEN UPPER( IAPICONSTANT.OPERATOR_ENDWITH )
         THEN
            ASOUTPUTSTRING :=
                     IAPIGENERAL.TOUPPER( ARFILTERRECORD.LEFTOPERAND )
                  || ' LIKE '
                  || IAPIGENERAL.TOUPPER(    '''%'
                                          || ARFILTERRECORD.RIGHTOPERAND
                                          || '''' );
         WHEN UPPER( IAPICONSTANT.OPERATOR_GREATER )
         THEN
            ASOUTPUTSTRING :=    ARFILTERRECORD.LEFTOPERAND
                              || ' '
                              || ARFILTERRECORD.OPERATOR
                              || ' '''
                              || ARFILTERRECORD.RIGHTOPERAND
                              || '''';
         WHEN UPPER( IAPICONSTANT.OPERATOR_GREATEROREQUAL )
         THEN
            ASOUTPUTSTRING :=    ARFILTERRECORD.LEFTOPERAND
                              || ' '
                              || ARFILTERRECORD.OPERATOR
                              || ' '''
                              || ARFILTERRECORD.RIGHTOPERAND
                              || '''';
         WHEN UPPER( IAPICONSTANT.OPERATOR_LESS )
         THEN
            ASOUTPUTSTRING :=    ARFILTERRECORD.LEFTOPERAND
                              || ' '
                              || ARFILTERRECORD.OPERATOR
                              || ' '''
                              || ARFILTERRECORD.RIGHTOPERAND
                              || '''';
         WHEN UPPER( IAPICONSTANT.OPERATOR_LESSOREQUAL )
         THEN
            ASOUTPUTSTRING :=    ARFILTERRECORD.LEFTOPERAND
                              || ' '
                              || ARFILTERRECORD.OPERATOR
                              || ' '''
                              || ARFILTERRECORD.RIGHTOPERAND
                              || '''';
         WHEN UPPER( IAPICONSTANT.OPERATOR_IN )
         THEN
            ASOUTPUTSTRING :=    ARFILTERRECORD.LEFTOPERAND
                              || ' '
                              || ARFILTERRECORD.OPERATOR
                              || ' '
                              || ARFILTERRECORD.RIGHTOPERAND
                              || ' ';
         ELSE
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_INVALIDOPERATOR,
                                                        ARFILTERRECORD.OPERATOR ) );
      END CASE;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END TRANSFORMFILTERRECORD;

   
   FUNCTION TRANSFORMERRORLISTTOREFCURSOR(
      ATERRORS                   IN       ERRORDATATABLE_TYPE,
      
      
      AQERRORS                   IN OUT      IAPITYPE.REF_TYPE )
      
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'TransformErrorListToRefCursor';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQERRORS%ISOPEN )
      THEN
         CLOSE AQERRORS;
      END IF;

      OPEN AQERRORS FOR
         SELECT MESSAGETYPE,
                PARAMETERID ERRORPARAMETERID,
                ERRORTEXT
           FROM TABLE( CAST( ATERRORS AS ERRORDATATABLE_TYPE ) );

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END TRANSFORMERRORLISTTOREFCURSOR;

   
   FUNCTION APPENDXMLFILTER(
      AXFILTER                   IN       IAPITYPE.XMLTYPE_TYPE,
      ATFILTERDATATABLE          OUT      IAPITYPE.FILTERTAB_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AppendXmlFilter';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LXPARSER                      XMLPARSER.PARSER;
      LBPARSERCREATED               BOOLEAN;
      LXDOMDOCUMENT                 XMLDOM.DOMDOCUMENT;
      LXROOTELEMENT                 XMLDOM.DOMELEMENT;
      LXFILTERNODESLIST             XMLDOM.DOMNODELIST;
      LXFILTERNODE                  XMLDOM.DOMNODE;
      LXFILTERITEMNODE              XMLDOM.DOMNODE;
      LXFILTERITEMNODESLIST         XMLDOM.DOMNODELIST;
      LXELEMENT                     XMLDOM.DOMELEMENT;
      LXNODE                        XMLDOM.DOMNODE;
      LRFILTERRECORD                IAPITYPE.FILTERREC_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LXPARSER := XMLPARSER.NEWPARSER;
      LBPARSERCREATED := TRUE;
      XMLPARSER.SETVALIDATIONMODE( LXPARSER,
                                   FALSE );
      XMLPARSER.SETPRESERVEWHITESPACE( LXPARSER,
                                       TRUE );
      XMLPARSER.PARSECLOB( LXPARSER,
                           AXFILTER.GETCLOBVAL( ) );
      LXDOMDOCUMENT := XMLPARSER.GETDOCUMENT( LXPARSER );

      IF ( NOT XMLDOM.ISNULL( LXDOMDOCUMENT ) )
      THEN
         
         LXROOTELEMENT := XMLDOM.GETDOCUMENTELEMENT( LXDOMDOCUMENT );
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'ROOT element <'
                              || XMLDOM.GETLOCALNAME( LXROOTELEMENT )
                              || '>' );
         
         LXFILTERNODESLIST := XMLDOM.GETELEMENTSBYTAGNAME( LXROOTELEMENT,
                                                           'Filter' );
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'Number of filters <'
                              || XMLDOM.GETLENGTH( LXFILTERNODESLIST )
                              || '>' );

         
         FOR I IN 0 ..   XMLDOM.GETLENGTH( LXFILTERNODESLIST )
                       - 1
         LOOP
            LXFILTERNODE := XMLDOM.ITEM( LXFILTERNODESLIST,
                                         I );
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                    'Filter <'
                                 || I
                                 || '>: <'
                                 || XMLDOM.GETNODENAME( LXFILTERNODE )
                                 || '>' );
            LRFILTERRECORD.LEFTOPERAND := NULL;
            LRFILTERRECORD.OPERATOR := NULL;
            LRFILTERRECORD.RIGHTOPERAND := NULL;
            LXFILTERITEMNODESLIST := XMLDOM.GETCHILDNODES( LXFILTERNODE );

            FOR J IN 0 ..   XMLDOM.GETLENGTH( LXFILTERITEMNODESLIST )
                          - 1
            LOOP
               LXFILTERITEMNODE := XMLDOM.ITEM( LXFILTERITEMNODESLIST,
                                                J );
               
               LXNODE := XMLDOM.GETFIRSTCHILD( LXFILTERITEMNODE );

               
               IF ( XMLDOM.ISNULL( LXNODE ) = FALSE )
               THEN
                  IF ( XMLDOM.GETNODETYPE( LXNODE ) = XMLDOM.TEXT_NODE )
                  THEN
                     IAPIGENERAL.LOGINFO( GSSOURCE,
                                          LSMETHOD,
                                             'Filter item <'
                                          || J
                                          || '>: Name: <'
                                          || XMLDOM.GETNODENAME( LXFILTERITEMNODE )
                                          || '>, Text: <'
                                          || XMLDOM.GETNODEVALUE( LXNODE )
                                          || '>' );

                     CASE XMLDOM.GETNODENAME( LXFILTERITEMNODE )
                        WHEN 'LeftOperand'
                        THEN
                           LRFILTERRECORD.LEFTOPERAND := XMLDOM.GETNODEVALUE( LXNODE );
                        WHEN 'Operator'
                        THEN
                           LRFILTERRECORD.OPERATOR := XMLDOM.GETNODEVALUE( LXNODE );
                        WHEN 'RightOperand'
                        THEN
                           LRFILTERRECORD.RIGHTOPERAND := XMLDOM.GETNODEVALUE( LXNODE );
                     END CASE;
                  END IF;
               END IF;
            END LOOP;

            ATFILTERDATATABLE( ATFILTERDATATABLE.COUNT ) := LRFILTERRECORD;
         END LOOP;

         
         XMLDOM.FREEDOCUMENT( LXDOMDOCUMENT );
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END APPENDXMLFILTER;


  
   
   FUNCTION APPENDXMLPARTNO(
      AXPARTNOLIST               IN       IAPITYPE.XMLTYPE_TYPE,
      ATPARTNOLIST               OUT      IAPITYPE.PARTNOTAB_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AppendXmlPartNo';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LXPARSER                      XMLPARSER.PARSER;
      LBPARSERCREATED               BOOLEAN;
      LXDOMDOCUMENT                 XMLDOM.DOMDOCUMENT;
      LXROOTELEMENT                 XMLDOM.DOMELEMENT;
      LXFILTERNODESLIST             XMLDOM.DOMNODELIST;
      LXFILTERNODE                  XMLDOM.DOMNODE;
      LXFILTERITEMNODE              XMLDOM.DOMNODE;
      LXFILTERITEMNODESLIST         XMLDOM.DOMNODELIST;
      LXELEMENT                     XMLDOM.DOMELEMENT;
      LXNODE                        XMLDOM.DOMNODE;
      LSPARTNO                      IAPITYPE.PARTNO_TYPE;

   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      LXPARSER := XMLPARSER.NEWPARSER;
      LBPARSERCREATED := TRUE;
      XMLPARSER.SETVALIDATIONMODE( LXPARSER,
                                   FALSE );
      XMLPARSER.SETPRESERVEWHITESPACE( LXPARSER,
                                       TRUE );
      XMLPARSER.PARSECLOB( LXPARSER,
                           AXPARTNOLIST.GETCLOBVAL( ) );

      LXDOMDOCUMENT := XMLPARSER.GETDOCUMENT( LXPARSER );

      IF ( NOT XMLDOM.ISNULL( LXDOMDOCUMENT ) )
      THEN
         
         LXROOTELEMENT := XMLDOM.GETDOCUMENTELEMENT( LXDOMDOCUMENT );

         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'ROOT element <'
                              || XMLDOM.GETLOCALNAME( LXROOTELEMENT )
                              || '>' );


        
         LXFILTERNODESLIST := XMLDOM.GETELEMENTSBYTAGNAME( LXROOTELEMENT,
                                                           'PartNos' );
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'Number of part numbers <'
                              || XMLDOM.GETLENGTH( LXFILTERNODESLIST )
                              || '>' );


         
         FOR I IN 0 ..   XMLDOM.GETLENGTH( LXFILTERNODESLIST ) - 1
         LOOP
            LXFILTERNODE := XMLDOM.ITEM( LXFILTERNODESLIST,
                                         I );
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                    'PartNo <'
                                 || I
                                 || '>: <'
                                 || XMLDOM.GETNODENAME( LXFILTERNODE )
                                 || '>' );

            LXFILTERITEMNODESLIST := XMLDOM.GETCHILDNODES( LXFILTERNODE );

            FOR J IN 0 ..   XMLDOM.GETLENGTH( LXFILTERITEMNODESLIST ) - 1
            LOOP
               LSPARTNO := NULL;

               LXFILTERITEMNODE := XMLDOM.ITEM( LXFILTERITEMNODESLIST,
                                                J );
               
               LXNODE := XMLDOM.GETFIRSTCHILD( LXFILTERITEMNODE );

               
               IF ( XMLDOM.ISNULL( LXNODE ) = FALSE )
               THEN
                  IF ( XMLDOM.GETNODETYPE( LXNODE ) = XMLDOM.TEXT_NODE )
                  THEN
                     IAPIGENERAL.LOGINFO( GSSOURCE,
                                          LSMETHOD,
                                             'PartNo item <'
                                          || J
                                          || '>: Name: <'
                                          || XMLDOM.GETNODENAME( LXFILTERITEMNODE )
                                          || '>, Text: <'
                                          || XMLDOM.GETNODEVALUE( LXNODE )
                                          || '>' );

                     CASE XMLDOM.GETNODENAME( LXFILTERITEMNODE )
                        WHEN 'p'
                        THEN
                           LSPARTNO := XMLDOM.GETNODEVALUE( LXNODE );
                     END CASE;

                   IF LSPARTNO IS NOT NULL
                   THEN
                        ATPARTNOLIST( ATPARTNOLIST.COUNT ) := LSPARTNO;
                   END IF;

                  END IF;
               END IF;

            END LOOP;

         END LOOP;

         
         XMLDOM.FREEDOCUMENT( LXDOMDOCUMENT );
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END APPENDXMLPARTNO;
  

  
   
      FUNCTION APPENDXMLREVISION(
      AXREVISIONLIST               IN       IAPITYPE.XMLTYPE_TYPE,
      ATREVISIONLIST               OUT      IAPITYPE.REVISIONTAB_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AppendXmlRevision';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LXPARSER                      XMLPARSER.PARSER;
      LBPARSERCREATED               BOOLEAN;
      LXDOMDOCUMENT                 XMLDOM.DOMDOCUMENT;
      LXROOTELEMENT                 XMLDOM.DOMELEMENT;
      LXFILTERNODESLIST             XMLDOM.DOMNODELIST;
      LXFILTERNODE                  XMLDOM.DOMNODE;
      LXFILTERITEMNODE              XMLDOM.DOMNODE;
      LXFILTERITEMNODESLIST         XMLDOM.DOMNODELIST;
      LXELEMENT                     XMLDOM.DOMELEMENT;
      LXNODE                        XMLDOM.DOMNODE;
      LNREVISION                    IAPITYPE.REVISION_TYPE;

   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      LXPARSER := XMLPARSER.NEWPARSER;
      LBPARSERCREATED := TRUE;
      XMLPARSER.SETVALIDATIONMODE( LXPARSER,
                                   FALSE );
      XMLPARSER.SETPRESERVEWHITESPACE( LXPARSER,
                                       TRUE );
      XMLPARSER.PARSECLOB( LXPARSER,
                           AXREVISIONLIST.GETCLOBVAL( ) );

      LXDOMDOCUMENT := XMLPARSER.GETDOCUMENT( LXPARSER );

      IF ( NOT XMLDOM.ISNULL( LXDOMDOCUMENT ) )
      THEN
         
         LXROOTELEMENT := XMLDOM.GETDOCUMENTELEMENT( LXDOMDOCUMENT );

         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'ROOT element <'
                              || XMLDOM.GETLOCALNAME( LXROOTELEMENT )
                              || '>' );

        
         LXFILTERNODESLIST := XMLDOM.GETELEMENTSBYTAGNAME( LXROOTELEMENT,
                                                           'Revisions' );
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'Number of revisions <'
                              || XMLDOM.GETLENGTH( LXFILTERNODESLIST )
                              || '>' );

         
         FOR I IN 0 ..   XMLDOM.GETLENGTH( LXFILTERNODESLIST ) - 1
         LOOP
            LXFILTERNODE := XMLDOM.ITEM( LXFILTERNODESLIST,
                                         I );
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                    'Revision <'
                                 || I
                                 || '>: <'
                                 || XMLDOM.GETNODENAME( LXFILTERNODE )
                                 || '>' );

            LXFILTERITEMNODESLIST := XMLDOM.GETCHILDNODES( LXFILTERNODE );

            FOR J IN 0 ..   XMLDOM.GETLENGTH( LXFILTERITEMNODESLIST ) - 1
            LOOP

               LNREVISION := 0;

               LXFILTERITEMNODE := XMLDOM.ITEM( LXFILTERITEMNODESLIST,
                                                J );
               
               LXNODE := XMLDOM.GETFIRSTCHILD( LXFILTERITEMNODE );

               
               IF ( XMLDOM.ISNULL( LXNODE ) = FALSE )
               THEN
                  IF ( XMLDOM.GETNODETYPE( LXNODE ) = XMLDOM.TEXT_NODE )
                  THEN
                     IAPIGENERAL.LOGINFO( GSSOURCE,
                                          LSMETHOD,
                                             'Revision item <'
                                          || J
                                          || '>: Name: <'
                                          || XMLDOM.GETNODENAME( LXFILTERITEMNODE )
                                          || '>, Text: <'
                                          || XMLDOM.GETNODEVALUE( LXNODE )
                                          || '>' );

                     CASE XMLDOM.GETNODENAME( LXFILTERITEMNODE )
                        WHEN 'r'
                        THEN
                           LNREVISION := XMLDOM.GETNODEVALUE( LXNODE );
                     END CASE;

                  END IF;
               END IF;

               IF LNREVISION <> 0
               THEN
                    ATREVISIONLIST( ATREVISIONLIST.COUNT ) := LNREVISION;
               END IF;

            END LOOP;

         END LOOP;

         
         XMLDOM.FREEDOCUMENT( LXDOMDOCUMENT );
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END APPENDXMLREVISION;
  

   
   FUNCTION ADDERRORTOLIST(
      ASPARAMETERID              IN       IAPITYPE.STRING_TYPE,
      ASERRORTEXT                IN       IAPITYPE.ERRORTEXT_TYPE,
      ATERRORS                   IN OUT   ERRORDATATABLE_TYPE,
      ANMESSAGETYPE              IN       IAPITYPE.ERRORMESSAGETYPE_TYPE DEFAULT IAPICONSTANT.ERRORMESSAGE_ERROR )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddErrorToList';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRERROR                       ERRORRECORD_TYPE := ERRORRECORD_TYPE( NULL,
                                                                          NULL,
                                                                          NULL );
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LRERROR.MESSAGETYPE := ANMESSAGETYPE;
      LRERROR.PARAMETERID := ASPARAMETERID;
      LRERROR.ERRORTEXT := ASERRORTEXT;
      ATERRORS.EXTEND;
      ATERRORS( ATERRORS.COUNT ) := LRERROR;
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDERRORTOLIST;

   
   FUNCTION TOUPPER(
      ASINPUTSTRING              IN       IAPITYPE.CLOB_TYPE )
      RETURN IAPITYPE.CLOB_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ToUpper';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSOUTPUTSTRING                IAPITYPE.CLOB_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSOUTPUTSTRING :=    'NLS_UPPER('
                        || ASINPUTSTRING
                        || ')';
      RETURN( LSOUTPUTSTRING );
   END TOUPPER;

   
   FUNCTION SETUOMTYPE(
      ANUOMTYPE                  IN       IAPITYPE.BOOLEAN_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SetUomType';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ANUOMTYPE = IAPICONSTANT.UOMTYPE_METRIC
      THEN
         SESSION.SETTINGS.METRIC := TRUE;
      ELSE
         SESSION.SETTINGS.METRIC := FALSE;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SETUOMTYPE;

   
   FUNCTION SETMODE(
      ANMODE                     IN       IAPITYPE.BOOLEAN_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SetMode';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ANMODE = 0
      THEN
         SESSION.SETTINGS.INTERNATIONAL := FALSE;
      ELSE
         SESSION.SETTINGS.INTERNATIONAL := TRUE;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SETMODE;

   
   PROCEDURE LOGINFOINCHUNKS(
      ASSOURCE                   IN       IAPITYPE.SOURCE_TYPE,
      ASMETHOD                   IN       IAPITYPE.METHOD_TYPE,
      ASMESSAGE                  IN       IAPITYPE.CLOB_TYPE,
      ANINFOLEVEL                IN       IAPITYPE.INFOLEVEL_TYPE DEFAULT 0 )
   IS
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'LogInfoInChunks';
      LSSQLCHUNK                    VARCHAR2( 1024 ) := NULL;
      LNCHUNKCOUNT                  NUMBER := 0;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      
      IF ( LOGGINGENABLED = TRUE )
      THEN
         
         
         
         LSSQLCHUNK := SUBSTR( ASMESSAGE,
                               1,
                               1024 );

         WHILE( LENGTH( LSSQLCHUNK ) > 0 )
         LOOP
            LNCHUNKCOUNT :=   LNCHUNKCOUNT
                            + 1;
            IAPIGENERAL.LOGINFO( ASSOURCE,
                                 ASMETHOD,
                                 LSSQLCHUNK,
                                 ANINFOLEVEL );
            LSSQLCHUNK := SUBSTR( ASMESSAGE,
                                    1
                                  +   1024
                                    * LNCHUNKCOUNT,
                                  1024 );
         END LOOP;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
   END LOGINFOINCHUNKS;

   
   FUNCTION SETLANGUAGEID(
      ANLANGUAGEID               IN       IAPITYPE.LANGUAGEID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SetLanguageId';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNLANGUAGEID                  IAPITYPE.LANGUAGEID_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      
      BEGIN
         SELECT LANG_ID
           INTO LNLANGUAGEID
           FROM ITLANG
          WHERE LANG_ID = ANLANGUAGEID;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_INVALIDLANGUAGE,
                                                        ANLANGUAGEID ) );
      END;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      SESSION.SETTINGS.LANGUAGEID := ANLANGUAGEID;
      
      IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID := SESSION.SETTINGS.LANGUAGEID;
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SETLANGUAGEID;

   
   FUNCTION SETALTERNATIVELANGUAGEID(
      ANALTERNATIVELANGUAGEID    IN       IAPITYPE.LANGUAGEID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SetAlternativeLanguageId';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNALTERNATIVELANGUAGEID       IAPITYPE.LANGUAGEID_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      
      BEGIN
         SELECT LANG_ID
           INTO LNALTERNATIVELANGUAGEID
           FROM ITLANG
          WHERE LANG_ID = ANALTERNATIVELANGUAGEID;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_INVALIDLANGUAGE,
                                                        ANALTERNATIVELANGUAGEID ) );
      END;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      SESSION.SETTINGS.ALTERNATIVELANGUAGEID := ANALTERNATIVELANGUAGEID;
			
      IAPIGENERAL.SESSION.SETTINGS.ALTERNATIVELANGUAGEID := SESSION.SETTINGS.ALTERNATIVELANGUAGEID;
			
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SETALTERNATIVELANGUAGEID;


   FUNCTION ISNUMERIC(
      ASVALUE                             IAPITYPE.STRING_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'isNumeric';
      LNVALUE                       IAPITYPE.NUMVAL_TYPE;
   BEGIN
      LNVALUE := TO_NUMBER( ASVALUE );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN VALUE_ERROR
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOTNUMERIC,
                                                    ASVALUE );
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ISNUMERIC;


   FUNCTION ISDATE(
      ASVALUE                             IAPITYPE.STRING_TYPE,
      ASFORMAT                            IAPITYPE.STRING_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'isDate';
      LDVALUE                       IAPITYPE.DATE_TYPE;
   BEGIN
      LDVALUE := TO_DATE( ASVALUE,
                          ASFORMAT );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOTVALIDDATE,
                                                    ASVALUE,
                                                    ASFORMAT );
   END ISDATE;


   FUNCTION ISVALIDSTRING(
      ASVALUE                             IAPITYPE.CLOB_TYPE,
      ANLIMIT                             IAPITYPE.NUMVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'isValidString';
      LDVALUE                       IAPITYPE.DATE_TYPE;
   BEGIN
      IF LENGTH( ASVALUE ) <= ANLIMIT
      THEN
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      ELSE
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOTVALIDSTRING,
                                                    ANLIMIT );
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ISVALIDSTRING;

   
   FUNCTION ISBOOLEAN(
      ASVALUE                             IAPITYPE.STRING_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'isBoolean';
      LNVALUE                       IAPITYPE.NUMVAL_TYPE;
   BEGIN
      IF ASVALUE IN( '0', '1' )
      THEN
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      ELSE
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOTBOOLEAN,
                                                    ASVALUE );
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ISBOOLEAN;

   
   FUNCTION TRANSFORMSTRINGTONUMARRAY(
      ASSTRING                   IN       IAPITYPE.CLOB_TYPE,
      ATLIST                     OUT      SPNUMTABLE_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      LNPOSITION                    IAPITYPE.ID_TYPE;
      LSSTRING                      IAPITYPE.CLOB_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'TransformStringtoArray';
   BEGIN
      ATLIST := SPNUMTABLE_TYPE( );
      LSSTRING :=    ASSTRING
                  || ',';

      IF LENGTH( LSSTRING ) > 1
      THEN
         LOOP
            EXIT WHEN LENGTH( LSSTRING ) = 0;
            LNPOSITION := INSTR( LSSTRING,
                                 ',' );
            ATLIST.EXTEND;
            ATLIST( ATLIST.COUNT ) := TO_NUMBER( TRIM( SUBSTR( LSSTRING,
                                                               1,
                                                               (   LNPOSITION
                                                                 - 1 ) ) ) );
            LSSTRING := SUBSTR( LSSTRING,
                                  LNPOSITION
                                + 1 );
         END LOOP;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END;

   
   FUNCTION ERRORLISTCONTAINSERRORS(
      ATERRORS                   IN       ERRORDATATABLE_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ErrorListContainsErrors';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNERRORCOUNT                  IAPITYPE.NUMVAL_TYPE := 0;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      
      SELECT COUNT( MESSAGETYPE )
        INTO LNERRORCOUNT
        FROM TABLE( CAST( ATERRORS AS ERRORDATATABLE_TYPE ) )
       WHERE MESSAGETYPE = IAPICONSTANT.ERRORMESSAGE_ERROR;

      IF ( LNERRORCOUNT = 0 )
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOERRORINLIST );
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ERRORLISTCONTAINSERRORS;

   
   PROCEDURE LOGERRORLIST(
      ASSOURCE                   IN       IAPITYPE.SOURCE_TYPE,
      ASMETHOD                   IN       IAPITYPE.METHOD_TYPE,
      ATERRORS                   IN       IAPITYPE.REF_TYPE )
   IS
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'LogErrorList';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRERROR                       IAPITYPE.ERRORREC_TYPE;
      LTERRORS                      IAPITYPE.ERRORTAB_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      FETCH ATERRORS
      BULK COLLECT INTO LTERRORS;

      IF ( LTERRORS.COUNT > 0 )
      THEN
         FOR LNINDEX IN LTERRORS.FIRST .. LTERRORS.LAST
         LOOP
            LRERROR := LTERRORS( LNINDEX );
            LOGMESSAGE( ASSOURCE,
                        ASMETHOD,
                        LRERROR.ERRORTEXT,
                        LRERROR.MESSAGETYPE,
                        NULL );
         END LOOP;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
   END LOGERRORLIST;

   
   FUNCTION GETDBDECIMALSEPERATOR
      RETURN IAPITYPE.DECIMALSEPERATOR_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'getDBDecimalSeperator';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSDBDECIMALSEPERATOR          IAPITYPE.DECIMALSEPERATOR_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT SUBSTR( VALUE,
                     1,
                     1 )
        INTO LSDBDECIMALSEPERATOR
        FROM V$NLS_PARAMETERS
       WHERE PARAMETER = 'NLS_NUMERIC_CHARACTERS';

      RETURN NVL( LSDBDECIMALSEPERATOR,
                  '.' );
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN '.';
   END GETDBDECIMALSEPERATOR;

   
   FUNCTION LPAD(
      ASINPUTSTRING              IN       IAPITYPE.STRINGVAL_TYPE,
      ANSIZE                     IN       IAPITYPE.NUMVAL_TYPE,
      ASPADINGSTRING             IN       IAPITYPE.STRINGVAL_TYPE )
      RETURN IAPITYPE.BUFFER_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'Lpad';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSPADINGSTRING                VARCHAR2( 2000 );
      LSINPUTSTRING                 VARCHAR2( 2000 );
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF (     ( ASPADINGSTRING IS NULL )
           OR ( LENGTH( ASPADINGSTRING ) < 1 ) )
      THEN
         LSPADINGSTRING := ' ';
      ELSE
         LSPADINGSTRING := ASPADINGSTRING;
      END IF;

      LSINPUTSTRING := ASINPUTSTRING;

      WHILE( LENGTH( LSINPUTSTRING ) < ANSIZE )
      LOOP
         LSINPUTSTRING :=    LSPADINGSTRING
                          || LSINPUTSTRING;
      END LOOP;

      RETURN( SUBSTR( LSINPUTSTRING,
                      -ANSIZE ) );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END LPAD;

   
   FUNCTION RPAD(
      ASINPUTSTRING              IN       IAPITYPE.STRINGVAL_TYPE,
      ANSIZE                     IN       IAPITYPE.NUMVAL_TYPE,
      ASPADINGSTRING             IN       IAPITYPE.STRINGVAL_TYPE )
      RETURN IAPITYPE.BUFFER_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'Rpad';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSPADINGSTRING                VARCHAR2( 2000 );
      LSINPUTSTRING                 VARCHAR2( 2000 );
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF (     ( ASPADINGSTRING IS NULL )
           OR ( LENGTH( ASPADINGSTRING ) < 1 ) )
      THEN
         LSPADINGSTRING := ' ';
      ELSE
         LSPADINGSTRING := ASPADINGSTRING;
      END IF;

      LSINPUTSTRING := ASINPUTSTRING;

      WHILE( LENGTH( LSINPUTSTRING ) < ANSIZE )
      LOOP
         LSINPUTSTRING :=    LSINPUTSTRING
                          || LSPADINGSTRING;
      END LOOP;

      RETURN( SUBSTR( LSINPUTSTRING,
                      1,
                      ANSIZE ) );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END RPAD;

   
   FUNCTION FREELICENSEVERSION(
      ASMACHINENAME              IN       IAPITYPE.MACHINENAME_TYPE DEFAULT NULL,
      ASAPPVERSION               IN       IAPITYPE.LICENSEVERSION_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'FreeLicenseVersion';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LTAPPID                       CXSAPILK.VC20_TABLE_TYPE;
      LTAPPVERSION                  CXSAPILK.VC20_TABLE_TYPE;
      LTLOGONSTATION                CXSAPILK.VC40_TABLE_TYPE;
      LTUSERSID                     CXSAPILK.VC20_TABLE_TYPE;
      LTUSERNAME                    CXSAPILK.VC20_TABLE_TYPE;
      LTERRORCODE                   CXSAPILK.NUM_TABLE_TYPE;
      LTAPPCUSTOMPARAM              CXSAPILK.VC20_TABLE_TYPE;
      LNNOROWS                      NUMBER := 1;
      LSERRORMSG                    VARCHAR2( 255 );
      
      LBSAVEPOINTACTIVE             BOOLEAN;
   BEGIN
      
      
      

      LBSAVEPOINTACTIVE:=FALSE;
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LTAPPID( 1 ) := 'IISC';
      LTAPPVERSION( 1 ) := ASAPPVERSION;
      LTAPPCUSTOMPARAM( 1 ) := IAPIGENERAL.LICENCECUSTOMPARAM;

      IF ASMACHINENAME IS NULL
      THEN
         LTLOGONSTATION( 1 ) := SYS_CONTEXT( 'USERENV',
                                             'TERMINAL' );
      ELSE
         LTLOGONSTATION( 1 ) := ASMACHINENAME;
      END IF;

      LTUSERSID( 1 ) := SYS_CONTEXT( 'USERENV',
                                     'SESSION_USERID' );
      LTUSERNAME( 1 ) := SYS_CONTEXT( 'USERENV',
                                      'SESSION_USER' );
      
      
      
      
      
      
      
      
      
      
      
      SAVEPOINT ISFREELICENSE;
      LBSAVEPOINTACTIVE:=TRUE;

      LNRETVAL :=
             CXSAPILK.FREELICENSE( LTAPPID,
                                   LTAPPVERSION,
                                   LTAPPCUSTOMPARAM,
                                   LTLOGONSTATION,
                                   LTUSERSID,
                                   LTUSERNAME,
                                   LNNOROWS,
                                   LTERRORCODE,
                                   LSERRORMSG );

      IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS THEN
         ROLLBACK TO SAVEPOINT ISFREELICENSE;
         LBSAVEPOINTACTIVE:=FALSE;
      END IF;

      
      
      
      
      IF LNRETVAL = 11
      

      THEN
         LNRETVAL := IAPICONSTANTDBERROR.DBERR_NORECORDS;
      END IF;

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( LNRETVAL ) );
      ELSIF( LTERRORCODE( 1 ) <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( LTERRORCODE( 1 ) ) );
      END IF;

      LICENSEFREE := TRUE;

      
      LICENSEGRANTED := FALSE;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IF LBSAVEPOINTACTIVE THEN
            ROLLBACK TO SAVEPOINT ISFREELICENSE;
            LBSAVEPOINTACTIVE:=FALSE;
         END IF;

         IF SQLCODE = -20000
         THEN
            LASTERRORTEXT := SUBSTR( SQLERRM( SQLCODE ),
                                     11 );
            RETURN( IAPICONSTANTDBERROR.DBERR_GENFAIL );
         ELSE
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
         END IF;
   END FREELICENSEVERSION;

   
   FUNCTION FREELICENSE(
      ASMACHINENAME              IN       IAPITYPE.MACHINENAME_TYPE DEFAULT NULL )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'FreeLicense';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LTAPPID                       CXSAPILK.VC20_TABLE_TYPE;
      LTAPPVERSION                  CXSAPILK.VC20_TABLE_TYPE;
      LTLOGONSTATION                CXSAPILK.VC40_TABLE_TYPE;
      LTUSERSID                     CXSAPILK.VC20_TABLE_TYPE;
      LTUSERNAME                    CXSAPILK.VC20_TABLE_TYPE;
      LTERRORCODE                   CXSAPILK.NUM_TABLE_TYPE;
      LTAPPCUSTOMPARAM              CXSAPILK.VC20_TABLE_TYPE;
      LNNOROWS                      NUMBER := 1;
      LSERRORMSG                    VARCHAR2( 255 );
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ( LICENSEGRANTED = FALSE )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              'No need to FREE the licence, it was not granted',
                              IAPICONSTANT.INFOLEVEL_3 );
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      END IF;

      LNRETVAL := FREELICENSEVERSION( ASMACHINENAME,
                                      GSAPPVERSION1 );

      IF NOT LICENSEFREE
      THEN
         LNRETVAL := FREELICENSEVERSION( ASMACHINENAME,
                                         GSAPPVERSION2 );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IF SQLCODE = -20000
         THEN
            LASTERRORTEXT := SUBSTR( SQLERRM( SQLCODE ),
                                     11 );
            RETURN( IAPICONSTANTDBERROR.DBERR_GENFAIL );
         ELSE
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
         END IF;
   END FREELICENSE;

   
   FUNCTION GETTESTSERVER(
      ANTESTSERVER               OUT      IAPITYPE.BOOLEAN_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetTestServer';
   BEGIN
      
      
      
      IF IAPIGENERAL.SESSION.DATABASE.CONFIGURATION.TESTSERVER
      THEN
         ANTESTSERVER := 1;
      ELSE
         ANTESTSERVER := 0;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETTESTSERVER;

   
   FUNCTION GETRECOVEREDSERVER(
      ANRECOVEREDSERVER          OUT      IAPITYPE.BOOLEAN_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetRecoveredServer';
   BEGIN
      
      
      
      IF IAPIGENERAL.SESSION.DATABASE.CONFIGURATION.RECOVERED
      THEN
         ANRECOVEREDSERVER := 1;
      ELSE
         ANRECOVEREDSERVER := 0;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETRECOVEREDSERVER;

   
   FUNCTION TOCHAR(
      ANNUM                      IN       IAPITYPE.FLOAT_TYPE )
      RETURN IAPITYPE.STRINGVAL_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ToChar';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSCHAR                        IAPITYPE.STRING_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF     ANNUM > 0
         AND ANNUM < 1
      THEN
         LSCHAR :=    '0'
                   || TO_CHAR( ANNUM );
      ELSIF     ANNUM < 0
            AND ANNUM > -1
      THEN
         LSCHAR :=    '-0'
                   || TO_CHAR( ABS( ANNUM ) );
      ELSE
         LSCHAR := TO_CHAR( ANNUM );
      END IF;

      RETURN LSCHAR;
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END TOCHAR;

   
   FUNCTION COMPARESTRING(
      ASSTRING1                  IN       IAPITYPE.STRINGVAL_TYPE,
      ASSTRING2                  IN       IAPITYPE.STRINGVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CompareString';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF     ASSTRING1 IS NULL
         AND ASSTRING2 IS NULL
      THEN
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      END IF;

      IF     ASSTRING1 IS NULL
         AND ASSTRING2 IS NOT NULL
      THEN
         RETURN( IAPICONSTANTDBERROR.DBERR_GENFAIL );
      END IF;

      IF     ASSTRING1 IS NOT NULL
         AND ASSTRING2 IS NULL
      THEN
         RETURN( IAPICONSTANTDBERROR.DBERR_GENFAIL );
      END IF;

      IF ASSTRING1 = ASSTRING2
      THEN
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      ELSE
         RETURN( IAPICONSTANTDBERROR.DBERR_GENFAIL );
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END COMPARESTRING;

   
   FUNCTION COMPAREFLOAT(
      AFFLOAT1                   IN       IAPITYPE.FLOAT_TYPE,
      AFFLOAT2                   IN       IAPITYPE.FLOAT_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CompareFloat';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF     AFFLOAT1 IS NULL
         AND AFFLOAT2 IS NULL
      THEN
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      END IF;

      IF     AFFLOAT1 IS NULL
         AND AFFLOAT2 IS NOT NULL
      THEN
         RETURN( IAPICONSTANTDBERROR.DBERR_GENFAIL );
      END IF;

      IF     AFFLOAT1 IS NOT NULL
         AND AFFLOAT2 IS NULL
      THEN
         RETURN( IAPICONSTANTDBERROR.DBERR_GENFAIL );
      END IF;

      IF AFFLOAT1 = AFFLOAT2
      THEN
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      ELSE
         RETURN( IAPICONSTANTDBERROR.DBERR_GENFAIL );
      END IF;
   END COMPAREFLOAT;

   
   FUNCTION COMPARENUMBER(
      ANNUMBER1                  IN       IAPITYPE.NUMVAL_TYPE,
      ANNUMBER2                  IN       IAPITYPE.NUMVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
       
       
       
      
       
       
       
       
       
       
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CompareNumber';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF     ANNUMBER1 IS NULL
         AND ANNUMBER2 IS NULL
      THEN
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      END IF;

      IF     ANNUMBER1 IS NULL
         AND ANNUMBER2 IS NOT NULL
      THEN
         RETURN( IAPICONSTANTDBERROR.DBERR_GENFAIL );
      END IF;

      IF     ANNUMBER1 IS NOT NULL
         AND ANNUMBER2 IS NULL
      THEN
         RETURN( IAPICONSTANTDBERROR.DBERR_GENFAIL );
      END IF;

      IF ANNUMBER1 = ANNUMBER2
      THEN
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      ELSE
         RETURN( IAPICONSTANTDBERROR.DBERR_GENFAIL );
      END IF;
   END COMPARENUMBER;

   
   FUNCTION COMPAREDATE(
      ADDATE1                    IN       IAPITYPE.DATE_TYPE,
      ADDATE2                    IN       IAPITYPE.DATE_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
       
       
       
      
       
       
       
       
       
       
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CompareDate';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF     ADDATE1 IS NULL
         AND ADDATE2 IS NULL
      THEN
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      END IF;

      IF     ADDATE1 IS NULL
         AND ADDATE2 IS NOT NULL
      THEN
         RETURN( IAPICONSTANTDBERROR.DBERR_GENFAIL );
      END IF;

      IF     ADDATE1 IS NOT NULL
         AND ADDATE2 IS NULL
      THEN
         RETURN( IAPICONSTANTDBERROR.DBERR_GENFAIL );
      END IF;

      IF ADDATE1 = ADDATE2
      THEN
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      ELSE
         RETURN( IAPICONSTANTDBERROR.DBERR_GENFAIL );
      END IF;
   END COMPAREDATE;


  
  
   PROCEDURE CLOSEERRORCURSOR (
      LNRETVAL                   IN      IAPITYPE.ERRORNUM_TYPE,
      AQERRORS                   IN      IAPITYPE.REF_TYPE )
   IS
      
      
      
      
      
     BEGIN
      
    IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
             IF ( AQERRORS%ISOPEN )
                 THEN
                   CLOSE AQERRORS;
             END IF;
    END IF;
   END CLOSEERRORCURSOR;
   

  

BEGIN
  
   GNRETVAL := IAPIDATABASE.GETSCHEMANAME( SCHEMANAME );
END IAPIGENERAL;
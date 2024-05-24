CREATE OR REPLACE PACKAGE BODY iapiUserPreferences
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

   
   
   

   
   
   
   FUNCTION REMOVEUSERPREFERENCES(
      ASUSERID                   IN       IAPITYPE.USERID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveUserPreferences';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      DELETE FROM ITUSPREF
            WHERE ITUSPREF.USER_ID = UPPER( ASUSERID );

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END REMOVEUSERPREFERENCES;

   
   FUNCTION SAVEUSERPREFERENCE(
      ASSECTIONNAME              IN       IAPITYPE.PREFERENCESECTIONNAME_TYPE,
      ASPREFERENCENAME           IN       IAPITYPE.PREFERENCENAME_TYPE,
      ASPREFERENCEVALUE          IN       IAPITYPE.PREFERENCEVALUE_TYPE,
      ASUSERID                   IN       IAPITYPE.USERID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveUserPreference';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      UPDATE ITUSPREF
         SET ITUSPREF.VALUE = ASPREFERENCEVALUE
       WHERE ITUSPREF.SECTION_NAME = ASSECTIONNAME
         AND ITUSPREF.PREF = ASPREFERENCENAME
         AND ITUSPREF.USER_ID = ASUSERID;

      IF SQL%NOTFOUND
      THEN
         INSERT INTO ITUSPREF
                     ( ITUSPREF.PREF,
                       ITUSPREF.SECTION_NAME,
                       ITUSPREF.USER_ID,
                       ITUSPREF.VALUE )
              VALUES ( ASPREFERENCENAME,
                       ASSECTIONNAME,
                       ASUSERID,
                       ASPREFERENCEVALUE );
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SAVEUSERPREFERENCE;

   
   FUNCTION SAVEUSERPREFERENCE(
      ASSECTIONNAME              IN       IAPITYPE.PREFERENCESECTIONNAME_TYPE,
      ASPREFERENCENAME           IN       IAPITYPE.PREFERENCENAME_TYPE,
      ASPREFERENCEVALUE          IN       IAPITYPE.PREFERENCEVALUE_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveUserPreference';
   BEGIN
      RETURN( SAVEUSERPREFERENCE( ASSECTIONNAME,
                                  ASPREFERENCENAME,
                                  ASPREFERENCEVALUE,
                                  USER ) );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SAVEUSERPREFERENCE;

   
   FUNCTION GETUSERPREFERENCES(
      ASUSERID                   IN       IAPITYPE.USERID_TYPE,
      AQUSERPREFERENCES          OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetUserPreferences';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQUSERPREFERENCES FOR
         SELECT ITUSPREF.SECTION_NAME SECTION,
                ITUSPREF.PREF PREFERENCE,
                ITUSPREF.VALUE
           FROM ITUSPREF
          WHERE ITUSPREF.USER_ID = UPPER( ASUSERID );

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETUSERPREFERENCES;

   
   FUNCTION GETUSERPREFERENCES(
      AQUSERPREFERENCES          OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetUserPreferences';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      RETURN( GETUSERPREFERENCES( USER,
                                  AQUSERPREFERENCES ) );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETUSERPREFERENCES;

   
   FUNCTION GETUSERPREFERENCE(
      ASSECTIONNAME              IN       IAPITYPE.PREFERENCESECTIONNAME_TYPE,
      ASPREFERENCENAME           IN       IAPITYPE.PREFERENCENAME_TYPE,
      ASUSERID                   IN       IAPITYPE.USERID_TYPE,
      ASPREFERENCEVALUE          OUT      IAPITYPE.PREFERENCEVALUE_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetUserPreference';

      CURSOR LQRETRIEVEUSPREFVALUE(
         ASSECTIONNAME                       IAPITYPE.PREFERENCESECTIONNAME_TYPE,
         ASPREFERENCENAME           IN       IAPITYPE.PREFERENCENAME_TYPE )
      IS
         SELECT VALUE
           FROM ITUSPREF
          WHERE USER_ID = UPPER( ASUSERID )
            AND SECTION_NAME = ASSECTIONNAME
            AND PREF = ASPREFERENCENAME;

      CURSOR LQRETRIEVEDEFPREFVALUE(
         ASSECTIONNAME                       IAPITYPE.PREFERENCESECTIONNAME_TYPE,
         ASPREFERENCENAME           IN       IAPITYPE.PREFERENCENAME_TYPE )
      IS
         SELECT VALUE
           FROM ITUSPREFDEF
          WHERE SECTION_NAME = ASSECTIONNAME
            AND PREF = ASPREFERENCENAME;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := EXISTUSERPREFERENCE( ASSECTIONNAME,
                                       ASPREFERENCENAME,
                                       ASUSERID );

      IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         OPEN LQRETRIEVEUSPREFVALUE( ASSECTIONNAME,
                                     ASPREFERENCENAME );

         FETCH LQRETRIEVEUSPREFVALUE
          INTO ASPREFERENCEVALUE;

         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      ELSE
         LNRETVAL := EXISTDEFAULTPREFERENCE( ASSECTIONNAME,
                                             ASPREFERENCENAME );

         IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            OPEN LQRETRIEVEDEFPREFVALUE( ASSECTIONNAME,
                                         ASPREFERENCENAME );

            FETCH LQRETRIEVEDEFPREFVALUE
             INTO ASPREFERENCEVALUE;

            RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
         ELSE
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_USERPREFNOTFOUND,
                                                        ASUSERID,
                                                        ASSECTIONNAME,
                                                        ASPREFERENCENAME ) );
         END IF;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETUSERPREFERENCE;

   
   FUNCTION GETUSERPREFERENCE(
      ASSECTIONNAME              IN       IAPITYPE.PREFERENCESECTIONNAME_TYPE,
      ASPREFERENCENAME           IN       IAPITYPE.PREFERENCENAME_TYPE,
      ASPREFERENCEVALUE          OUT      IAPITYPE.PREFERENCEVALUE_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetUserPreference';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      RETURN( GETUSERPREFERENCE( ASSECTIONNAME,
                                 ASPREFERENCENAME,
                                 USER,
                                 ASPREFERENCEVALUE ) );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETUSERPREFERENCE;

   
   FUNCTION EXISTUSERPREFERENCE(
      ASSECTIONNAME              IN       IAPITYPE.PREFERENCESECTIONNAME_TYPE,
      ASPREFERENCENAME           IN       IAPITYPE.PREFERENCENAME_TYPE,
      ASUSERID                   IN       IAPITYPE.USERID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExistUserPreference';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Section: <'
                           || ASSECTIONNAME
                           || '> Preference: <'
                           || ASPREFERENCENAME
                           || '>',
                           IAPICONSTANT.INFOLEVEL_1 );

      SELECT COUNT( * )
        INTO LNCOUNT
        FROM ITUSPREF
       WHERE USER_ID = UPPER( ASUSERID )
         AND SECTION_NAME = ASSECTIONNAME
         AND PREF = ASPREFERENCENAME;

      IF ( LNCOUNT = 0 )
      THEN
         RETURN( IAPICONSTANTDBERROR.DBERR_GENFAIL );
      ELSE
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EXISTUSERPREFERENCE;

   
   FUNCTION EXISTUSERPREFERENCE(
      ASSECTIONNAME              IN       IAPITYPE.PREFERENCESECTIONNAME_TYPE,
      ASPREFERENCENAME           IN       IAPITYPE.PREFERENCENAME_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExistUserPreference';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      RETURN( EXISTUSERPREFERENCE( ASSECTIONNAME,
                                   ASPREFERENCENAME,
                                   USER ) );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EXISTUSERPREFERENCE;

   
   FUNCTION EXISTDEFAULTPREFERENCE(
      ASSECTIONNAME              IN       IAPITYPE.PREFERENCESECTIONNAME_TYPE,
      ASPREFERENCENAME           IN       IAPITYPE.PREFERENCENAME_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExistDefaultPreference';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Section: <'
                           || ASSECTIONNAME
                           || '> Preference: <'
                           || ASPREFERENCENAME
                           || '>',
                           IAPICONSTANT.INFOLEVEL_1 );

      SELECT COUNT( * )
        INTO LNCOUNT
        FROM ITUSPREFDEF
       WHERE SECTION_NAME = ASSECTIONNAME
         AND PREF = ASPREFERENCENAME;

      IF ( LNCOUNT = 0 )
      THEN
         RETURN( IAPICONSTANTDBERROR.DBERR_GENFAIL );
      ELSE
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EXISTDEFAULTPREFERENCE;

   
   FUNCTION INITUSERPREFERENCES(
      ASUSERID                   IN       IAPITYPE.USERID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      CURSOR LQUSPREFDEF
      IS
         SELECT SECTION_NAME,
                PREF,
                VALUE
           FROM ITUSPREFDEF;

      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'InitUserPreferences';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      FOR LRUSPREFDEF IN LQUSPREFDEF
      LOOP
         BEGIN
            INSERT INTO ITUSPREF
                        ( USER_ID,
                          SECTION_NAME,
                          PREF,
                          VALUE )
                 VALUES ( ASUSERID,
                          LRUSPREFDEF.SECTION_NAME,
                          LRUSPREFDEF.PREF,
                          LRUSPREFDEF.VALUE );
         EXCEPTION
            WHEN DUP_VAL_ON_INDEX
            THEN
               NULL;
         END;
      END LOOP;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END INITUSERPREFERENCES;
END IAPIUSERPREFERENCES;
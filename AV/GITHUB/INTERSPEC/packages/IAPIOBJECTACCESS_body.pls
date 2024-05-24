CREATE OR REPLACE PACKAGE BODY iapiObjectAccess
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





   


   
   FUNCTION EXISTID(
      ANOBJECTID                 IN       IAPITYPE.ID_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANOWNER                    IN       IAPITYPE.OWNER_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExistId';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT COUNT( * )
        INTO LNCOUNT
        FROM ITOID
       WHERE OBJECT_ID = ANOBJECTID
         AND REVISION = ANREVISION
         AND OWNER = ANOWNER;

      IF LNCOUNT = 0
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_OBJECTNOTFOUND ) );
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EXISTID;





   FUNCTION GETVIEWACCESS(
      ANOBJECTID                 IN       IAPITYPE.ID_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANOWNER                    IN       IAPITYPE.OWNER_TYPE,
      ANACCESS                   OUT      IAPITYPE.BOOLEAN_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS















      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetViewAccess';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOINITSESSION );
      END IF;

      
      IF    ANREVISION = 0
         OR ANREVISION IS NULL
      THEN
         LNRETVAL := EXISTID( ANOBJECTID,
                              F_GET_OBJ_REV( ANOBJECTID,
                                             0,
                                             ANOWNER ),
                              ANOWNER );
      ELSE
         LNRETVAL := EXISTID( ANOBJECTID,
                              ANREVISION,
                              ANOWNER );
      END IF;

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      ANACCESS := 0;

      IF F_CHECK_OBJ_ACCESS( ANOBJECTID,
                             ANREVISION,
                             ANOWNER ) = 1
      THEN
         ANACCESS := 1;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETVIEWACCESS;


   FUNCTION GETBASICACCESS(
      ANOBJECTID                 IN       IAPITYPE.ID_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANOWNER                    IN       IAPITYPE.OWNER_TYPE,
      ANMODEINDEPENDANT          IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANACCESS                   OUT      IAPITYPE.BOOLEAN_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS















      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetBasicAccess';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNOWNER                       IAPITYPE.OWNER_TYPE;
      LNINTL                        IAPITYPE.BOOLEAN_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      ANACCESS := 0;

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID = IAPIGENERAL.SCHEMANAME
      THEN
         ANACCESS := 1;
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      END IF;

      IF ( IAPIGENERAL.SESSION.APPLICATIONUSER.USERPROFILE IN
                                              ( IAPICONSTANT.USERROLE_CONFIGURATOR, IAPICONSTANT.USERROLE_DEVMGR, IAPICONSTANT.USERROLE_FRAMEBUILDER ) )
      THEN
         LNRETVAL := GETVIEWACCESS( ANOBJECTID,
                                    ANREVISION,
                                    ANOWNER,
                                    ANACCESS );

         IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT );
            RETURN LNRETVAL;
         END IF;

         
         IF ( ANACCESS = 1 )
         THEN
            SELECT COUNT( * )
              INTO LNCOUNT
              FROM ITOIH H,
                   ITOID D
             WHERE H.OBJECT_ID = ANOBJECTID
               AND H.OWNER = ANOWNER
               AND H.OWNER = D.OWNER
               AND H.LANG_ID = IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID
               AND D.OBJECT_ID = ANOBJECTID
               AND D.REVISION = ANREVISION;

            IF LNCOUNT > 0
            THEN
               SELECT H.OWNER,
                      H.INTL
                 INTO LNOWNER,
                      LNINTL
                 FROM ITOIH H,
                      ITOID D
                WHERE H.OBJECT_ID = ANOBJECTID
                  AND H.OWNER = ANOWNER
                  AND H.OWNER = D.OWNER
                  AND H.LANG_ID = IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID
                  AND D.OBJECT_ID = ANOBJECTID
                  AND D.REVISION = ANREVISION;
            ELSE
               SELECT H.OWNER,
                      H.INTL
                 INTO LNOWNER,
                      LNINTL
                 FROM ITOIH H,
                      ITOID D
                WHERE H.OBJECT_ID = ANOBJECTID
                  AND H.OWNER = ANOWNER
                  AND H.OWNER = D.OWNER
                  AND H.LANG_ID = 1
                  AND D.OBJECT_ID = ANOBJECTID
                  AND D.REVISION = ANREVISION;
            END IF;

            IF (      (     (     LNINTL = 0
                              AND IAPIGENERAL.SESSION.SETTINGS.INTERNATIONAL )
                        OR (     LNINTL = 1
                             AND NOT IAPIGENERAL.SESSION.SETTINGS.INTERNATIONAL ) )
                 AND ( ANMODEINDEPENDANT <> 1 ) )
            THEN
               ANACCESS := 0;
               IAPIGENERAL.LOGINFO( GSSOURCE,
                                    LSMETHOD,
                                       'Mode does not match mode of object '
                                    || ANOBJECTID
                                    || ' ['
                                    || ANREVISION
                                    || ']',
                                    IAPICONSTANT.INFOLEVEL_3 );
            END IF;

            IF LNOWNER <> IAPIGENERAL.SESSION.DATABASE.OWNER
            THEN
               ANACCESS := 0;
               IAPIGENERAL.LOGINFO( GSSOURCE,
                                    LSMETHOD,
                                       'You do not own object '
                                    || ANOBJECTID
                                    || ' ['
                                    || ANREVISION
                                    || ']',
                                    IAPICONSTANT.INFOLEVEL_3 );
            END IF;
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
   END GETBASICACCESS;


   FUNCTION GETSTATUSINDEPMODIFIABLEACCESS(
      ANOBJECTID                 IN       IAPITYPE.ID_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANOWNER                    IN       IAPITYPE.OWNER_TYPE,
      ANMODEINDEPENDANT          IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANACCESS                   OUT      IAPITYPE.BOOLEAN_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS













      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetStatusIndepModifiableAccess';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSUPDATEONACCESSGROUP         VARCHAR2( 1 );
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOINITSESSION );
      END IF;

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID = IAPIGENERAL.SCHEMANAME
      THEN
         ANACCESS := 1;
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      END IF;

      
      IF    ANREVISION = 0
         OR ANREVISION IS NULL
      THEN
         LNRETVAL := EXISTID( ANOBJECTID,
                              F_GET_OBJ_REV( ANOBJECTID,
                                             0,
                                             ANOWNER ),
                              ANOWNER );
      ELSE
         LNRETVAL := EXISTID( ANOBJECTID,
                              ANREVISION,
                              ANOWNER );
      END IF;

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      ANACCESS := 0;

      SELECT MAX( UPDATE_ALLOWED )
        INTO LSUPDATEONACCESSGROUP
        FROM USER_ACCESS_GROUP
       WHERE ACCESS_GROUP IN( SELECT ACCESS_GROUP
                               FROM ITOID
                              WHERE OBJECT_ID = ANOBJECTID
                                AND REVISION = ANREVISION
                                AND OWNER = ANOWNER )
         AND USER_GROUP_ID IN( SELECT USER_GROUP_ID
                                FROM USER_GROUP_LIST
                               WHERE USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID );

      
      IF LSUPDATEONACCESSGROUP = 'Y'
      THEN
         LNRETVAL := GETBASICACCESS( ANOBJECTID,
                                     ANREVISION,
                                     ANOWNER,
                                     ANMODEINDEPENDANT,
                                     ANACCESS );

         IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT );
            RETURN LNRETVAL;
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
   END GETSTATUSINDEPMODIFIABLEACCESS;


   FUNCTION GETMODIFIABLEACCESS(
      ANOBJECTID                 IN       IAPITYPE.ID_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANOWNER                    IN       IAPITYPE.OWNER_TYPE,
      ANACCESS                   OUT      IAPITYPE.BOOLEAN_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS













      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetModifiableAccess';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSTATUSTYPE                  IAPITYPE.STATUSTYPE_TYPE;
      LSUSERID                      IAPITYPE.USERID_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID = IAPIGENERAL.SCHEMANAME
      THEN
         ANACCESS := 1;
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      END IF;

      LNRETVAL := GETSTATUSINDEPMODIFIABLEACCESS( ANOBJECTID,
                                                  ANREVISION,
                                                  ANOWNER,
                                                  0,
                                                  ANACCESS );

      IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT );
         RETURN LNRETVAL;
      END IF;

      IF ANACCESS = 1
      THEN
         SELECT B.STATUS_TYPE
           INTO LSSTATUSTYPE
           FROM ITOID A,
                STATUS B
          WHERE A.STATUS = B.STATUS
            AND OBJECT_ID = ANOBJECTID
            AND REVISION = ANREVISION
            AND OWNER = ANOWNER;

         IF LSSTATUSTYPE <> IAPICONSTANT.STATUSTYPE_DEVELOPMENT
         THEN
            ANACCESS := 0;
         END IF;

         IF NOT( ANACCESS = 0 )
         THEN
            IF (    LSUSERID IS NULL
                 OR LSUSERID = '' )
            THEN
               NULL;
            ELSE
               IF LSUSERID <> IAPIGENERAL.SESSION.APPLICATIONUSER.USERID
               THEN
                  ANACCESS := 0;
               END IF;
            END IF;
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
   END GETMODIFIABLEACCESS;


   FUNCTION GETMODEINDEPMODIFIABLEACCESS(
      ANOBJECTID                 IN       IAPITYPE.ID_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANOWNER                    IN       IAPITYPE.OWNER_TYPE,
      ANACCESS                   OUT      IAPITYPE.BOOLEAN_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS














      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetModeIndepModifiableAccess';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSTATUSTYPE                  IAPITYPE.STATUSTYPE_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID = IAPIGENERAL.SCHEMANAME
      THEN
         ANACCESS := 1;
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      END IF;

      LNRETVAL := GETSTATUSINDEPMODIFIABLEACCESS( ANOBJECTID,
                                                  ANREVISION,
                                                  ANOWNER,
                                                  1,
                                                  ANACCESS );

      IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT );
         RETURN LNRETVAL;
      END IF;

      IF ANACCESS = 1
      THEN
         SELECT B.STATUS_TYPE
           INTO LSSTATUSTYPE
           FROM ITOID A,
                STATUS B
          WHERE A.STATUS = B.STATUS
            AND OBJECT_ID = ANOBJECTID
            AND REVISION = ANREVISION
            AND OWNER = ANOWNER;

         IF LSSTATUSTYPE <> IAPICONSTANT.STATUSTYPE_DEVELOPMENT
         THEN
            ANACCESS := 0;
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
   END GETMODEINDEPMODIFIABLEACCESS;
END IAPIOBJECTACCESS;
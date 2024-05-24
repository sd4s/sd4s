CREATE OR REPLACE PACKAGE BODY iapiReferenceText
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

   
   
   

   
   
   
   FUNCTION GETBASECOLUMNS(
      ASALIAS                    IN       IAPITYPE.STRING_TYPE DEFAULT '' )
      RETURN VARCHAR2
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetBaseColumns';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LCBASECOLUMNS                 IAPITYPE.SQLSTRING_TYPE := NULL;
      LSALIAS                       IAPITYPE.STRING_TYPE := NULL;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ( ASALIAS != '' )
      THEN
         NULL;
      ELSE
         LSALIAS :=    ASALIAS
                    || '.';
      END IF;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSALIAS,
                           IAPICONSTANT.INFOLEVEL_3 );
      LCBASECOLUMNS :=
            LSALIAS
         || 'ref_text_type '
         || IAPICONSTANTCOLUMN.REFERENCETEXTTYPECOL
         || ','
         || LSALIAS
         || 'owner '
         || IAPICONSTANTCOLUMN.REFERENCETEXTTYPEOWNERCOL
         || ','
         || LSALIAS
         || 'kw_id '
         || IAPICONSTANTCOLUMN.KEYWORDIDCOL
         || ','
         || 'f_get_kwdesc('
         || LSALIAS
         || 'kw_id) '
         || IAPICONSTANTCOLUMN.NAMECOL
         || ','
         || LSALIAS
         || 'kw_value '
         || IAPICONSTANTCOLUMN.VALUECOL
         || ','
         || 'itkw.kw_type '
         || IAPICONSTANTCOLUMN.KEYWORDTYPECOL
         || ','
         || LSALIAS
         || 'intl '
         || IAPICONSTANTCOLUMN.INTERNATIONALCOL;
      RETURN( LCBASECOLUMNS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETBASECOLUMNS;

   
   FUNCTION EXISTID(
      ANREFID                    IN       IAPITYPE.ID_TYPE,
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

      SELECT COUNT( REF_TEXT_TYPE )
        INTO LNCOUNT
        FROM REFERENCE_TEXT
       WHERE REF_TEXT_TYPE = ANREFID
         AND OWNER = ANOWNER;

      IF LNCOUNT = 0
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_REFERENCETEXTNOTFOUND );
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

   
   
   
   
   FUNCTION CHECKPHANTOM(
      ANREFID                    IN       IAPITYPE.ID_TYPE,
      ANREFVER                   IN       IAPITYPE.REFERENCEVERSION_TYPE,
      ANOWNER                    IN       IAPITYPE.OWNER_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckPhantom';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
      LNUSED                        IAPITYPE.NUMVAL_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOINITSESSION );
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNUSED := 0;

      SELECT COUNT( * )
        INTO LNCOUNT
        FROM FRAME_SECTION A,
             FRAME_HEADER B
       WHERE A.REF_ID = ANREFID
         AND A.REF_OWNER = ANOWNER
         AND TYPE = IAPICONSTANT.REFTEXTTYPE
         AND (    B.STATUS = 2
               OR B.STATUS = 1 )
         AND B.FRAME_NO = A.FRAME_NO
         AND B.REVISION = A.REVISION;

      
      IF LNCOUNT > 0
      THEN
         LNUSED := 1;
      END IF;

      IF LNUSED = 0
      THEN
         SELECT COUNT( * )
           INTO LNCOUNT
           FROM SPECIFICATION_SECTION A,
                SPECIFICATION_HEADER B,
                STATUS C
          WHERE A.REF_ID = ANREFID
            AND A.REF_OWNER = ANOWNER
            AND TYPE = IAPICONSTANT.REFTEXTTYPE
            AND B.STATUS = C.STATUS
            AND (    C.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_APPROVED
                  OR C.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_CURRENT
                  OR C.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_SUBMIT
                  OR C.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_DEVELOPMENT )
            AND B.PART_NO = A.PART_NO;

         IF LNCOUNT > 0
         THEN
            LNUSED := 1;
         END IF;
      END IF;

      IF LNUSED = 1
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_REFTEXTASPHANTOM,
                                                     ANREFID,
                                                     ANREFVER,
                                                     ANOWNER ) );
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END CHECKPHANTOM;

   
   FUNCTION CHECKUSED(
      ANREFID                    IN       IAPITYPE.ID_TYPE,
      ANREFVER                   IN       IAPITYPE.REFERENCEVERSION_TYPE,
      ANOWNER                    IN       IAPITYPE.OWNER_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckUsed';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNUSED                        IAPITYPE.NUMVAL_TYPE := 0;
      LNROW2                        IAPITYPE.NUMVAL_TYPE := 0;

      CURSOR LQFRAMECURSOR
      IS
         SELECT A.REF_ID,
                A.REF_VER,
                A.REF_OWNER,
                B.STATUS
           FROM FRAME_SECTION A,
                FRAME_HEADER B
          WHERE A.REF_ID = ANREFID
            AND A.REF_VER = ANREFVER
            AND A.REF_OWNER = ANOWNER
            AND TYPE = IAPICONSTANT.REFTEXTTYPE
            AND (    B.STATUS = 2
                  OR B.STATUS = 1 )
            AND B.FRAME_NO = A.FRAME_NO
            AND B.REVISION = A.REVISION;

      CURSOR LQSPECCURSOR
      IS
         SELECT A.REF_ID,
                A.REF_VER,
                A.REF_OWNER
           FROM SPECIFICATION_SECTION A
          WHERE A.REF_ID = ANREFID
            AND A.REF_VER = ANREFVER
            AND A.REF_OWNER = ANOWNER
            AND A.TYPE = IAPICONSTANT.REFTEXTTYPE;

      CURSOR LQSPECHEADERCURSOR
      IS
         SELECT OBJECT_ID,
                REVISION,
                OWNER
           FROM ITPROBJ
          WHERE OBJECT_ID = ANREFID
            AND REVISION = ANREFVER
            AND OWNER = ANOWNER;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOINITSESSION );
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNUSED := 0;

      
      FOR LNROW2 IN LQFRAMECURSOR
      LOOP
         LNUSED := 1;
      END LOOP;

      IF LNUSED = 0
      THEN
         FOR LNROW2 IN LQSPECCURSOR
         LOOP
            LNUSED := 1;
         END LOOP;
      END IF;

      IF LNUSED = 1
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_REFTEXTALREADYUSED,
                                                     ANREFID,
                                                     ANREFVER,
                                                     ANOWNER ) );
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END CHECKUSED;

   
   FUNCTION COPYNEXTREVISION(
      ANREFID                    IN       IAPITYPE.ID_TYPE,
      ANOWNER                    IN       IAPITYPE.OWNER_TYPE,
      ANREFREVNEXT               OUT      IAPITYPE.REFERENCEVERSION_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CopyNextRevision';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNCNT                         IAPITYPE.NUMVAL_TYPE;
      LNREFREVNEXT                  IAPITYPE.NUMVAL_TYPE;
      LNREFREVCURR                  IAPITYPE.NUMVAL_TYPE;
      LDDATE                        IAPITYPE.DATE_TYPE;

   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOINITSESSION );
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := EXISTID( ANREFID,
                           ANOWNER );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := IAPIREFERENCETEXT.GETNEXTREVISION( ANREFID,
                                                     ANOWNER,
                                                     LNREFREVNEXT );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNREFREVCURR :=   LNREFREVNEXT
                      - 1;
      LDDATE := SYSDATE;

      
      INSERT INTO REFERENCE_TEXT
                  ( REF_TEXT_TYPE,
                    TEXT_REVISION,
                    TEXT,
                    CREATED_BY,
                    CREATED_ON,
                    LAST_EDITED_BY,
                    LAST_EDITED_ON_FIELDS,
                    STATUS,
                    LAST_MODIFIED_ON,
                    OWNER,
                    EXPORTED,
                    LANG_ID,
                    OBSOLESCENCE_DATE,
                    
                    ACCESS_GROUP,
                    
                    CURRENT_DATE )
         ( SELECT ANREFID,
                  LNREFREVNEXT,
                  TEXT,
                  CREATED_BY,
                  LDDATE,
                  LAST_EDITED_BY,
                  LAST_EDITED_ON_FIELDS,
                  IAPICONSTANT.STATUS_DEVELOPMENT,
                  LAST_MODIFIED_ON,
                  OWNER,
                  EXPORTED,
                  LANG_ID,
                  OBSOLESCENCE_DATE,
                  
                  ACCESS_GROUP,
                  
                  NULL
            FROM REFERENCE_TEXT
           WHERE REF_TEXT_TYPE = ANREFID
             AND OWNER = ANOWNER
             AND TEXT_REVISION = LNREFREVCURR );

      ANREFREVNEXT := LNREFREVNEXT;
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END COPYNEXTREVISION;

   
   FUNCTION DELETEREFERENCETEXT(
      ANREFID                    IN       IAPITYPE.ID_TYPE,
      ANREFVER                   IN       IAPITYPE.REFERENCEVERSION_TYPE,
      ANOWNER                    IN       IAPITYPE.OWNER_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'DeleteReferenceText';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNSTATUS                      IAPITYPE.NUMVAL_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := IAPIOBJECT.CHECKUSED( ANREFID,
                                        ANREFVER,
                                        ANOWNER );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      BEGIN
         SELECT STATUS
           INTO LNSTATUS
           FROM REFERENCE_TEXT
          WHERE REF_TEXT_TYPE = ANREFID
            AND TEXT_REVISION = ANREFVER
            AND OWNER = ANOWNER
            AND LANG_ID = 1;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            LNSTATUS := 1;
            NULL;
      END;

      IF LNSTATUS <> 1
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_REFTEXTNOTINDEVSTATUS,
                                                     ANREFID,
                                                     ANREFVER,
                                                     ANOWNER ) );
      END IF;

      DELETE FROM REFERENCE_TEXT
            WHERE REF_TEXT_TYPE = ANREFID
              AND TEXT_REVISION = ANREFVER
              AND OWNER = ANOWNER;

      DELETE FROM REF_TEXT_KW
            WHERE REF_TEXT_TYPE = ANREFID
              AND OWNER = ANOWNER
              AND INTL = '0';

      SELECT COUNT( REF_TEXT_TYPE )
        INTO LNCOUNT
        FROM REFERENCE_TEXT
       WHERE REF_TEXT_TYPE = ANREFID
         AND OWNER = ANOWNER;

      IF LNCOUNT = 0
      THEN
         DELETE FROM REF_TEXT_TYPE
               WHERE REF_TEXT_TYPE = ANREFID
                 AND OWNER = ANOWNER;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END DELETEREFERENCETEXT;

   
   FUNCTION GETNEXTREVISION(
      ANREFID                    IN       IAPITYPE.ID_TYPE,
      ANOWNER                    IN       IAPITYPE.OWNER_TYPE,
      ANREVNUMBER                OUT      IAPITYPE.REFERENCEVERSION_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetNextRevision';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNCNT                         IAPITYPE.NUMVAL_TYPE;
      LNREVNUMBER                   IAPITYPE.NUMVAL_TYPE := 0;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      ANREVNUMBER := 0;

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOINITSESSION );
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      SELECT COUNT( * )
        INTO LNCNT
        FROM REFERENCE_TEXT
       WHERE REF_TEXT_TYPE = ANREFID
         AND OWNER = ANOWNER
         AND STATUS = 1;

      IF LNCNT > 0
      THEN
         
         
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_REFTEXTINDEVSTATUS ) );
      ELSE
         
         SELECT MAX( TEXT_REVISION )
           INTO LNREVNUMBER
           FROM REFERENCE_TEXT
          WHERE REF_TEXT_TYPE = ANREFID
            AND OWNER = ANOWNER;

         ANREVNUMBER :=   NVL( LNREVNUMBER,
                               0 )
                        + 1;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETNEXTREVISION;

   
   FUNCTION IFVALIDATE(
      ASSHORTDESCRIPTION         IN       IAPITYPE.SHORTDESCRIPTION_TYPE,
      ASDESCRIPTION              IN       IAPITYPE.REFERENCETEXTTYPEDESCR_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ifValidate';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOINITSESSION );
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := IFVALIDATESHORTDESCRIPTION( ASSHORTDESCRIPTION );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := IFVALIDATEDESCRIPTION( ASDESCRIPTION );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END IFVALIDATE;

   
   FUNCTION IFVALIDATEDESCRIPTION(
      ASDESCRIPTION              IN       IAPITYPE.REFERENCETEXTTYPEDESCR_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ifValidateDescription';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOINITSESSION );
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF    ASDESCRIPTION IS NULL
         OR ASDESCRIPTION = ''
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_DESCREMPTY ) );
      END IF;

      
      SELECT COUNT( * )
        INTO LNCOUNT
        
        
        FROM ITOIH 
        
        
        
       WHERE UPPER( DESCRIPTION ) = UPPER( ASDESCRIPTION );

      IF LNCOUNT > 0
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_DESCRNOTUNIQUE ) );
      END IF;

      
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END IFVALIDATEDESCRIPTION;

   
   FUNCTION IFVALIDATESHORTDESCRIPTION(
      ASSHORTDESCRIPTION         IN       IAPITYPE.SHORTDESCRIPTION_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'IfValidateShortDescription';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOINITSESSION );
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF    ASSHORTDESCRIPTION IS NULL
         OR ASSHORTDESCRIPTION = ''
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_SHORTDESCREMPTY ) );
      END IF;

      

      
      SELECT COUNT( * )
        INTO LNCOUNT
        
        
        FROM ITOIH 
        
        
        
       WHERE UPPER( SORT_DESC ) = UPPER( ASSHORTDESCRIPTION );

      IF LNCOUNT > 0
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_SHORTDESCRNOTUNIQUE ) );
      END IF;

      
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END IFVALIDATESHORTDESCRIPTION;

   
   FUNCTION SETHISTORIC(
      ANREFID                    IN       IAPITYPE.ID_TYPE,
      ANREFVER                   IN       IAPITYPE.REFERENCEVERSION_TYPE,
      ANOWNER                    IN       IAPITYPE.OWNER_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SetHistoric';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
      LNOWNER                       IAPITYPE.NUMVAL_TYPE;
      LNUSED                        IAPITYPE.NUMVAL_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOINITSESSION );
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT PARAMETER_DATA
        INTO LNOWNER
        FROM INTERSPC_CFG
       WHERE PARAMETER = 'owner';




      IF ANOWNER = LNOWNER
      THEN
         UPDATE REFERENCE_TEXT
            SET STATUS = 3,
                OBSOLESCENCE_DATE = SYSDATE
          WHERE STATUS = 2
            AND REF_TEXT_TYPE = ANREFID
            AND TEXT_REVISION = ANREFVER
            AND OWNER = ANOWNER;
      ELSE
         IF IAPIGENERAL.SESSION.DATABASE.DATABASETYPE = 'L'
         THEN
            UPDATE REFERENCE_TEXT
               SET STATUS = 3,
                   OBSOLESCENCE_DATE = ( SELECT NVL( OBSOLESCENCE_DATE,
                                                     SYSDATE )
                                          FROM REFERENCE_TEXT
                                         WHERE REF_TEXT_TYPE = ANREFID
                                           AND OWNER = ANOWNER
                                           AND TEXT_REVISION = ANREFVER )
             WHERE STATUS = 2
               AND REF_TEXT_TYPE = ANREFID
               AND TEXT_REVISION = ANREFVER
               AND OWNER = ANOWNER;
         ELSE
            
            UPDATE REFERENCE_TEXT
               SET STATUS = 3
             WHERE STATUS = 2
               AND REF_TEXT_TYPE = ANREFID
               AND TEXT_REVISION = ANREFVER
               AND OWNER = ANOWNER;
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
   END SETHISTORIC;

   
   FUNCTION GETREFERENCETEXTID(
      ASREFERENCETEXT            IN       IAPITYPE.REFERENCETEXTTYPEDESCR_TYPE,
      ANREFERENCETEXTID          OUT      IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetReferenceTextId';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      SELECT REF_TEXT_TYPE
        INTO ANREFERENCETEXTID
        FROM REF_TEXT_TYPE
       WHERE DESCRIPTION = ASREFERENCETEXT;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_REFTEXTIDNOTFNDFORDESC,
                                                     ASREFERENCETEXT ) );
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETREFERENCETEXTID;

   
   FUNCTION GETKEYWORDS(
      ANREFID                    IN       IAPITYPE.ID_TYPE,
      ANOWNER                    IN       IAPITYPE.OWNER_TYPE,
      AQKEYWORDS                 OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetKeywords';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSQLNULL                     IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE := GETBASECOLUMNS( 'rfkw' );
      LSFROM                        IAPITYPE.STRING_TYPE := 'ref_text_kw rfkw, itkw';
   BEGIN
      
      
      
      
      
      IF ( AQKEYWORDS%ISOPEN )
      THEN
         CLOSE AQKEYWORDS;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE rfkw.ref_text_type = NULL and rfkw.owner = NULL';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQKEYWORDS FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := EXISTID( ANREFID,
                           ANOWNER );

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
      
      LSSQL :=
            'SELECT '
         || LSSELECT
         || ' FROM '
         || LSFROM
         || ' WHERE rfkw.ref_text_type = :RefId '
         || '   AND rfkw.owner         = :Owner '
         || '   AND rfkw.KW_ID         = itkw.KW_ID'
         || '   ORDER BY '
         || IAPICONSTANTCOLUMN.VALUECOL;
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQKEYWORDS%ISOPEN )
      THEN
         CLOSE AQKEYWORDS;
      END IF;

      
      OPEN AQKEYWORDS FOR LSSQL USING ANREFID,
      ANOWNER;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETKEYWORDS;

   
   FUNCTION ADDKEYWORD(
      ANREFID                    IN       IAPITYPE.ID_TYPE,
      ANOWNER                    IN       IAPITYPE.OWNER_TYPE,
      ANKEYWORDID                IN       IAPITYPE.ID_TYPE,
      ASVALUE                    IN       IAPITYPE.KEYWORDVALUE_TYPE DEFAULT '<Any>',
      ANINTERNATIONAL            IN       IAPITYPE.INTL_TYPE DEFAULT 0,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddKeyword';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      
      
      IF ( AQERRORS%ISOPEN )
      THEN
         CLOSE AQERRORS;
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      

      
      
      LNRETVAL := EXISTID( ANREFID,
                           ANOWNER );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      
      LNRETVAL := IAPIKEYWORD.EXISTID( ANKEYWORDID );

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

      INSERT INTO REF_TEXT_KW
                  ( REF_TEXT_TYPE,
                    KW_ID,
                    KW_VALUE,
                    INTL,
                    OWNER )
           VALUES ( ANREFID,
                    ANKEYWORDID,
                    ASVALUE,
                    ANINTERNATIONAL,
                    ANOWNER );

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PostConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDKEYWORD;

   
   FUNCTION REMOVEKEYWORD(
      ANREFID                    IN       IAPITYPE.ID_TYPE,
      ANOWNER                    IN       IAPITYPE.OWNER_TYPE,
      ANKEYWORDID                IN       IAPITYPE.ID_TYPE,
      ASVALUE                    IN       IAPITYPE.KEYWORDVALUE_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveKeyword';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      
      
      IF ( AQERRORS%ISOPEN )
      THEN
         CLOSE AQERRORS;
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      

      
       
      LNRETVAL := EXISTID( ANREFID,
                           ANOWNER );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      
      LNRETVAL := IAPIKEYWORD.EXISTID( ANKEYWORDID );

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

      DELETE FROM REF_TEXT_KW
            WHERE REF_TEXT_TYPE = ANREFID
              AND KW_ID = ANKEYWORDID
              AND OWNER = ANOWNER
              AND KW_VALUE = ASVALUE;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Delete Reference text <'
                           || ANREFID
                           || '> '
                           || 'Owner <'
                           || ANOWNER
                           || '> '
                           || 'KeywordId <'
                           || ANKEYWORDID
                           || '> '
                           || 'Value <'
                           || ASVALUE
                           || '>',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PostConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END REMOVEKEYWORD;
END IAPIREFERENCETEXT;
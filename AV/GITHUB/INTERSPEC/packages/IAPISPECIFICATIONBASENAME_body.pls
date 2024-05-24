CREATE OR REPLACE PACKAGE BODY iapiSpecificationBaseName
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

   
   
   

   
   
   
   
   PROCEDURE CHECKBASICBASENAMEPARAMS(
      ARBASENAME                 IN       IAPITYPE.SPBASENAMEREC_TYPE )
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckBasicBaseNameParams';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNACCESSLEVEL                 IAPITYPE.ID_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( ARBASENAME.PARTNO IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'PartNo' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asPartNo',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARBASENAME.REVISION IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Revision' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anRevision',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARBASENAME.SECTIONID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'SectionId' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anSectionId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARBASENAME.SUBSECTIONID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'SubSectionId' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anSubSectionId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      LNACCESSLEVEL := 1;

      IF F_CHECK_ITEM_ACCESS( ARBASENAME.PARTNO,
                              ARBASENAME.REVISION,
                              ARBASENAME.SECTIONID,
                              ARBASENAME.SUBSECTIONID,
                              0,
                              0,
                              0,
                              0,
                              0,
                              LNACCESSLEVEL ) = 0
      THEN
         LNRETVAL :=
            IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                LSMETHOD,
                                                IAPICONSTANTDBERROR.DBERR_NOEDITSECTIONACCESS,
                                                ARBASENAME.PARTNO,
                                                ARBASENAME.REVISION,
                                                F_SCH_DESCR( NULL,
                                                             ARBASENAME.SECTIONID,
                                                             0 ),
                                                F_SBH_DESCR( NULL,
                                                             ARBASENAME.SUBSECTIONID,
                                                             0 ),
                                                'BASE NAME' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'No Edit Access ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      LNACCESSLEVEL := 0;

      IF F_CHECK_ITEM_ACCESS( ARBASENAME.PARTNO,
                              ARBASENAME.REVISION,
                              ARBASENAME.SECTIONID,
                              ARBASENAME.SUBSECTIONID,
                              0,
                              0,
                              0,
                              0,
                              0,
                              LNACCESSLEVEL ) = 0
      THEN
         LNRETVAL :=
            IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                LSMETHOD,
                                                IAPICONSTANTDBERROR.DBERR_NOVIEWSECTIONACCESS,
                                                ARBASENAME.PARTNO,
                                                ARBASENAME.REVISION,
                                                F_SCH_DESCR( NULL,
                                                             ARBASENAME.SECTIONID,
                                                             0 ),
                                                F_SBH_DESCR( NULL,
                                                             ARBASENAME.SUBSECTIONID,
                                                             0 ),
                                                'BASE NAME' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'No View Section Access ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      LNACCESSLEVEL := 2;

      IF F_CHECK_ITEM_ACCESS( ARBASENAME.PARTNO,
                              ARBASENAME.REVISION,
                              ARBASENAME.SECTIONID,
                              ARBASENAME.SUBSECTIONID,
                              0,
                              0,
                              0,
                              0,
                              0,
                              LNACCESSLEVEL ) = 0
      THEN
         LNRETVAL :=
            IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                LSMETHOD,
                                                IAPICONSTANTDBERROR.DBERR_NOVIEWSECTIONACCESS,
                                                ARBASENAME.PARTNO,
                                                ARBASENAME.REVISION,
                                                F_SCH_DESCR( NULL,
                                                             ARBASENAME.SECTIONID,
                                                             0 ),
                                                F_SBH_DESCR( NULL,
                                                             ARBASENAME.SUBSECTIONID,
                                                             0 ),
                                                'BASE NAME' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'No View Item Access ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
   END CHECKBASICBASENAMEPARAMS;

   
   FUNCTION EXISTSECBASENAME(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                OUT      IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             OUT      IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      CURSOR LQSECBASENAME
      IS
         SELECT SECTION_ID,
                SUB_SECTION_ID
           FROM SPECIFICATION_SECTION
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND TYPE = IAPICONSTANT.SECTIONTYPE_BASENAME
            AND F_CHECK_ITEM_ACCESS( PART_NO,
                                     REVISION,
                                     SECTION_ID,
                                     SUB_SECTION_ID,
                                     IAPICONSTANT.SECTIONTYPE_ATTACHEDSPEC ) = 1;

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExistSecBaseName';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN LQSECBASENAME;

      FETCH LQSECBASENAME
       INTO ANSECTIONID,
            ANSUBSECTIONID;

      IF LQSECBASENAME%NOTFOUND
      THEN
         CLOSE LQSECBASENAME;

         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_SPSECTIONNOTFOUND,
                                                     ASPARTNO,
                                                     ANREVISION,
                                                     '',
                                                     'BaseName' ) );
      END IF;

      CLOSE LQSECBASENAME;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EXISTSECBASENAME;

   
   
   
   
   FUNCTION ADDBASENAME(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddBaseName';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRBASENAME                    IAPITYPE.SPBASENAMEREC_TYPE;
      LNALLOWED                     IAPITYPE.BOOLEAN_TYPE;
      LRINFO                        IAPITYPE.INFOREC_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
   BEGIN
      
      
      
      
      
      IF ( AQERRORS%ISOPEN )
      THEN
         CLOSE AQERRORS;
      END IF;

      IF ( AQINFO%ISOPEN )
      THEN
         CLOSE AQINFO;
      END IF;

      LRINFO.PARAMETERNAME := IAPICONSTANT.REFRESHWINDOWDESCR;
      LRINFO.PARAMETERDATA := IAPICONSTANT.NOREFRESHWINDOW;
      LSSQL :=
            'SELECT '
         || ''''
         || LRINFO.PARAMETERNAME
         || ''''
         || ' '
         || IAPICONSTANTCOLUMN.PARAMETERNAMECOL
         || ' , '
         || ''''
         || LRINFO.PARAMETERDATA
         || ''''
         || ' '
         || IAPICONSTANTCOLUMN.PARAMETERDATACOL
         || ' FROM DUAL';

      OPEN AQINFO FOR LSSQL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      GTBASENAME.DELETE;
      GTINFO.DELETE;
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRBASENAME.PARTNO := ASPARTNO;
      LRBASENAME.REVISION := ANREVISION;
      LRBASENAME.SECTIONID := ANSECTIONID;
      LRBASENAME.SUBSECTIONID := ANSUBSECTIONID;
      LRBASENAME.ITEMID := 0;
      GTBASENAME( 0 ) := LRBASENAME;

      GTINFO( 0 ) := LRINFO;
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Call CUSTOM Pre-Action',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIGENERAL.EXECUTECUSTOMFUNCTION( GSSOURCE,
                                                     LSMETHOD,
                                                     'PRE',
                                                     GTERRORS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_ERRORLIST )
         THEN
            
            LNRETVAL := IAPIGENERAL.ERRORLISTCONTAINSERRORS( GTERRORS );

            IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               
               LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                      AQERRORS );
               RETURN( IAPICONSTANTDBERROR.DBERR_ERRORLIST );
            END IF;
         ELSE
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;
      END IF;

      
      LRINFO := GTINFO( 0 );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      
      
      
      CHECKBASICBASENAMEPARAMS( LRBASENAME );

      IF ( GTERRORS.COUNT > 0 )
      THEN
         
         LNRETVAL := IAPIGENERAL.ERRORLISTCONTAINSERRORS( GTERRORS );

         IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            
            LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                   AQERRORS );

            IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               RETURN( IAPICONSTANTDBERROR.DBERR_ERRORLIST );
            ELSE
               RETURN( LNRETVAL );
            END IF;
         END IF;
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL :=
         IAPISPECIFICATIONSECTION.ADDSECTIONITEM( LRBASENAME.PARTNO,
                                                  LRBASENAME.REVISION,
                                                  LRBASENAME.SECTIONID,
                                                  LRBASENAME.SUBSECTIONID,
                                                  IAPICONSTANT.SECTIONTYPE_BASENAME,
                                                  LRBASENAME.ITEMID,
                                                  AFHANDLE => AFHANDLE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL :=
         IAPISPECIFICATIONSECTION.ISACTIONALLOWED( LRBASENAME.PARTNO,
                                                   LRBASENAME.REVISION,
                                                   LRBASENAME.SECTIONID,
                                                   LRBASENAME.SUBSECTIONID,
                                                   IAPICONSTANT.SECTIONTYPE_BASENAME,
                                                   LRBASENAME.ITEMID,
                                                   ASACTION => 'ADD',
                                                   ANALLOWED => LNALLOWED );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      IF ( LNALLOWED = 0 )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_ACTIONNOTALLOWED,
                                                     'ADD',
                                                     LRBASENAME.ITEMID,
                                                     IAPICONSTANT.SECTIONTYPE_BASENAME,
                                                     LRBASENAME.PARTNO,
                                                     LRBASENAME.REVISION,
                                                     
                                                     
                                                     
                                                     F_SCH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRBASENAME.SECTIONID, 0),
                                                     F_SBH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRBASENAME.SUBSECTIONID, 0) ));
                                                     
      END IF;

      BEGIN
         INSERT INTO ITSHBN
                     ( PART_NO,
                       REVISION,
                       SECTION_ID,
                       SECTION_REV,
                       SUB_SECTION_ID,
                       SUB_SECTION_REV,
                       BASE_NAME_ID,
                       BASE_NAME_REV )
            SELECT PART_NO,
                   REVISION,
                   SECTION_ID,
                   SECTION_REV,
                   SUB_SECTION_ID,
                   SUB_SECTION_REV,
                   LRBASENAME.ITEMID,
                   LRBASENAME.ITEMREVISION
              FROM SPECIFICATION_SECTION
             WHERE PART_NO = LRBASENAME.PARTNO
               AND REVISION = LRBASENAME.REVISION
               AND SECTION_ID = LRBASENAME.SECTIONID
               AND SUB_SECTION_ID = LRBASENAME.SUBSECTIONID
               AND TYPE = IAPICONSTANT.SECTIONTYPE_BASENAME
               AND REF_ID = 0;
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_BASEIDALREADYEXIST,
                                                        LRBASENAME.ITEMID,
                                                        LRBASENAME.PARTNO,
                                                        LRBASENAME.REVISION ) );
      END;

      
      LNRETVAL := IAPISPECIFICATIONSECTION.LOGHISTORY( LRBASENAME.PARTNO,
                                                       LRBASENAME.REVISION,
                                                       LRBASENAME.SECTIONID,
                                                       LRBASENAME.SUBSECTIONID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.LOGCHANGES( LRBASENAME.PARTNO,
                                                LRBASENAME.REVISION );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      
      
      IF ( AQINFO%ISOPEN )
      THEN
         CLOSE AQINFO;
      END IF;

      LSSQL :=
            'SELECT '
         || ''''
         || LRINFO.PARAMETERNAME
         || ''''
         || ' '
         || IAPICONSTANTCOLUMN.PARAMETERNAMECOL
         || ' , '
         || ''''
         || LRINFO.PARAMETERDATA
         || ''''
         || ' '
         || IAPICONSTANTCOLUMN.PARAMETERDATACOL
         || ' FROM DUAL';

      OPEN AQINFO FOR LSSQL;

      GTINFO.DELETE;
      GTINFO( 0 ) := LRINFO;
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Call CUSTOM Post-Action',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIGENERAL.EXECUTECUSTOMFUNCTION( GSSOURCE,
                                                     LSMETHOD,
                                                     'POST',
                                                     GTERRORS );
      LRINFO := GTINFO( 0 );

      IF ( AQINFO%ISOPEN )
      THEN
         CLOSE AQINFO;
      END IF;

      LSSQL :=
            'SELECT '
         || ''''
         || LRINFO.PARAMETERNAME
         || ''''
         || ' '
         || IAPICONSTANTCOLUMN.PARAMETERNAMECOL
         || ' , '
         || ''''
         || LRINFO.PARAMETERDATA
         || ''''
         || ' '
         || IAPICONSTANTCOLUMN.PARAMETERDATACOL
         || ' FROM DUAL';

      OPEN AQINFO FOR LSSQL;

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_ERRORLIST )
         THEN
            LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                   AQERRORS );
            RETURN( IAPICONSTANTDBERROR.DBERR_ERRORLIST );
         ELSE
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;
      END IF;

      
      
      
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
   END ADDBASENAME;

   
   FUNCTION SAVEBASENAME(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANITEMID                   IN       IAPITYPE.ID_TYPE,
      ANITEMREVISION             IN       IAPITYPE.REVISION_TYPE,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveBaseName';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRBASENAME                    IAPITYPE.SPBASENAMEREC_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LNMARKEDFOREDITING            IAPITYPE.BOOLEAN_TYPE;
      LNALLOWED                     IAPITYPE.BOOLEAN_TYPE;
      LSSECTION                     IAPITYPE.STRING_TYPE;
      LRINFO                        IAPITYPE.INFOREC_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
   BEGIN
      
      
      
      
      
      IF ( AQERRORS%ISOPEN )
      THEN
         CLOSE AQERRORS;
      END IF;

      IF ( AQINFO%ISOPEN )
      THEN
         CLOSE AQINFO;
      END IF;

      LRINFO.PARAMETERNAME := IAPICONSTANT.REFRESHWINDOWDESCR;
      LRINFO.PARAMETERDATA := IAPICONSTANT.NOREFRESHWINDOW;
      LSSQL :=
            'SELECT '
         || ''''
         || LRINFO.PARAMETERNAME
         || ''''
         || ' '
         || IAPICONSTANTCOLUMN.PARAMETERNAMECOL
         || ' , '
         || ''''
         || LRINFO.PARAMETERDATA
         || ''''
         || ' '
         || IAPICONSTANTCOLUMN.PARAMETERDATACOL
         || ' FROM DUAL';

      OPEN AQINFO FOR LSSQL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      GTBASENAME.DELETE;
      GTERRORS.DELETE;
      GTINFO.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRBASENAME.PARTNO := ASPARTNO;
      LRBASENAME.REVISION := ANREVISION;
      LRBASENAME.SECTIONID := ANSECTIONID;
      LRBASENAME.SUBSECTIONID := ANSUBSECTIONID;
      LRBASENAME.ITEMID := ANITEMID;
      LRBASENAME.ITEMREVISION := ANITEMREVISION;
      GTBASENAME( 0 ) := LRBASENAME;
      GTINFO( 0 ) := LRINFO;
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Call CUSTOM Pre-Action',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIGENERAL.EXECUTECUSTOMFUNCTION( GSSOURCE,
                                                     LSMETHOD,
                                                     'PRE',
                                                     GTERRORS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_ERRORLIST )
         THEN
            
            LNRETVAL := IAPIGENERAL.ERRORLISTCONTAINSERRORS( GTERRORS );

            IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               
               LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                      AQERRORS );
               RETURN( IAPICONSTANTDBERROR.DBERR_ERRORLIST );
            END IF;
         ELSE
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;
      END IF;

      
      LRINFO := GTINFO( 0 );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      
      
      
      
      
      CHECKBASICBASENAMEPARAMS( LRBASENAME );

      
      IF ( LRBASENAME.ITEMID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'ItemId' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anItemId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      IF ( GTERRORS.COUNT > 0 )
      THEN
         
         LNRETVAL := IAPIGENERAL.ERRORLISTCONTAINSERRORS( GTERRORS );

         IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            
            LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                   AQERRORS );

            IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               RETURN( IAPICONSTANTDBERROR.DBERR_ERRORLIST );
            ELSE
               RETURN( LNRETVAL );
            END IF;
         END IF;
      END IF;

      
      IF ( AFHANDLE IS NOT NULL )
      THEN
         LNRETVAL :=
            IAPISPECIFICATIONSECTION.ISMARKEDFOREDITING( LRBASENAME.PARTNO,
                                                         LRBASENAME.REVISION,
                                                         LRBASENAME.SECTIONID,
                                                         LRBASENAME.SUBSECTIONID,
                                                         AFHANDLE,
                                                         LNMARKEDFOREDITING );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;

         CASE LNMARKEDFOREDITING
            WHEN -1
            THEN
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_NOSAVEALLOWED,
                                                           LRBASENAME.PARTNO,
                                                           LRBASENAME.REVISION ) );
            WHEN -2
            THEN
               SELECT    F_SCH_DESCR( IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID,
                                      LRBASENAME.SECTIONID,
                                      0 )
                      || DECODE( LRBASENAME.SUBSECTIONID,
                                 0, NULL,
                                    ' - '
                                 || F_SCH_DESCR( IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID,
                                                 LRBASENAME.SUBSECTIONID,
                                                 0 ) )
                 INTO LSSECTION
                 FROM DUAL;

               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_SAVEAFTERMOD,
                                                           LRBASENAME.PARTNO,
                                                           LRBASENAME.REVISION,
                                                           LSSECTION ) );
            ELSE
               NULL;
         END CASE;
      END IF;

      
      LNRETVAL := IAPISPECIFICATIONACCESS.GETMODIFIABLEACCESS( LRBASENAME.PARTNO,
                                                               LRBASENAME.REVISION,
                                                               LNACCESS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      IF ( LNACCESS = 0 )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_NOUPDATEACCESS ) );
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL :=
         IAPISPECIFICATIONSECTION.EXISTITEMINSECTION( LRBASENAME.PARTNO,
                                                      LRBASENAME.REVISION,
                                                      LRBASENAME.SECTIONID,
                                                      LRBASENAME.SUBSECTIONID,
                                                      IAPICONSTANT.SECTIONTYPE_BASENAME,
                                                      0 );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      IF ( AFHANDLE IS NOT NULL )
      THEN
         LNRETVAL :=
            IAPISPECIFICATIONSECTION.MARKFOREDITING( LRBASENAME.PARTNO,
                                                     LRBASENAME.REVISION,
                                                     LRBASENAME.SECTIONID,
                                                     LRBASENAME.SUBSECTIONID,
                                                     AFHANDLE );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;
      END IF;

      
      LNRETVAL :=
         IAPISPECIFICATIONSECTION.ISACTIONALLOWED( LRBASENAME.PARTNO,
                                                   LRBASENAME.REVISION,
                                                   LRBASENAME.SECTIONID,
                                                   LRBASENAME.SUBSECTIONID,
                                                   IAPICONSTANT.SECTIONTYPE_BASENAME,
                                                   0,
                                                   ASACTION => 'SAVE',
                                                   ANALLOWED => LNALLOWED );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      IF ( LNALLOWED = 0 )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_ACTIONNOTALLOWED,
                                                     'SAVE',
                                                     LRBASENAME.ITEMID,
                                                     IAPICONSTANT.SECTIONTYPE_BASENAME,
                                                     LRBASENAME.PARTNO,
                                                     LRBASENAME.REVISION,
                                                     
                                                     
                                                     
                                                     F_SCH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRBASENAME.SECTIONID, 0),
                                                     F_SBH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRBASENAME.SUBSECTIONID, 0) ));
                                                     
      END IF;

      UPDATE ITSHBN
         SET BASE_NAME_ID = LRBASENAME.ITEMID,
             BASE_NAME_REV = LRBASENAME.ITEMREVISION
       WHERE PART_NO = LRBASENAME.PARTNO
         AND REVISION = LRBASENAME.REVISION
         AND SECTION_ID = LRBASENAME.SECTIONID
         AND SUB_SECTION_ID = LRBASENAME.SUBSECTIONID;

      IF SQL%ROWCOUNT = 0
      THEN
         
         INSERT INTO ITSHBN
                     ( PART_NO,
                       REVISION,
                       SECTION_ID,
                       SECTION_REV,
                       SUB_SECTION_ID,
                       SUB_SECTION_REV,
                       BASE_NAME_ID,
                       BASE_NAME_REV )
            SELECT PART_NO,
                   REVISION,
                   SECTION_ID,
                   SECTION_REV,
                   SUB_SECTION_ID,
                   SUB_SECTION_REV,
                   LRBASENAME.ITEMID,
                   LRBASENAME.ITEMREVISION
              FROM SPECIFICATION_SECTION
             WHERE PART_NO = LRBASENAME.PARTNO
               AND REVISION = LRBASENAME.REVISION
               AND SECTION_ID = LRBASENAME.SECTIONID
               AND SUB_SECTION_ID = LRBASENAME.SUBSECTIONID
               AND TYPE = IAPICONSTANT.SECTIONTYPE_BASENAME
               AND REF_ID = 0;
      END IF;

      
      LNRETVAL := IAPISPECIFICATIONSECTION.LOGHISTORY( LRBASENAME.PARTNO,
                                                       LRBASENAME.REVISION,
                                                       LRBASENAME.SECTIONID,
                                                       LRBASENAME.SUBSECTIONID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.LOGCHANGES( LRBASENAME.PARTNO,
                                                LRBASENAME.REVISION );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      
      
      IF ( AQINFO%ISOPEN )
      THEN
         CLOSE AQINFO;
      END IF;

      LSSQL :=
            'SELECT '
         || ''''
         || LRINFO.PARAMETERNAME
         || ''''
         || ' '
         || IAPICONSTANTCOLUMN.PARAMETERNAMECOL
         || ' , '
         || ''''
         || LRINFO.PARAMETERDATA
         || ''''
         || ' '
         || IAPICONSTANTCOLUMN.PARAMETERDATACOL
         || ' FROM DUAL';

      OPEN AQINFO FOR LSSQL;

      GTINFO.DELETE;
      GTINFO( 0 ) := LRINFO;
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Call CUSTOM Post-Action',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIGENERAL.EXECUTECUSTOMFUNCTION( GSSOURCE,
                                                     LSMETHOD,
                                                     'POST',
                                                     GTERRORS );
      LRINFO := GTINFO( 0 );

      IF ( AQINFO%ISOPEN )
      THEN
         CLOSE AQINFO;
      END IF;

      LSSQL :=
            'SELECT '
         || ''''
         || LRINFO.PARAMETERNAME
         || ''''
         || ' '
         || IAPICONSTANTCOLUMN.PARAMETERNAMECOL
         || ' , '
         || ''''
         || LRINFO.PARAMETERDATA
         || ''''
         || ' '
         || IAPICONSTANTCOLUMN.PARAMETERDATACOL
         || ' FROM DUAL';

      OPEN AQINFO FOR LSSQL;

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_ERRORLIST )
         THEN
            LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                   AQERRORS );
            RETURN( IAPICONSTANTDBERROR.DBERR_ERRORLIST );
         ELSE
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;
      END IF;

      
      
      
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
   END SAVEBASENAME;

   
   FUNCTION REMOVEBASENAME(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveBaseName';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRBASENAME                    IAPITYPE.SPBASENAMEREC_TYPE;
      LNALLOWED                     IAPITYPE.BOOLEAN_TYPE;
      LRERROR                       ERRORRECORD_TYPE := ERRORRECORD_TYPE( NULL,
                                                                          NULL,
                                                                          NULL );
      LTERRORS                      ERRORDATATABLE_TYPE := ERRORDATATABLE_TYPE( );
      LRINFO                        IAPITYPE.INFOREC_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
   BEGIN
      
      
      
      
      
      IF ( AQERRORS%ISOPEN )
      THEN
         CLOSE AQERRORS;
      END IF;

      IF ( AQINFO%ISOPEN )
      THEN
         CLOSE AQINFO;
      END IF;

      LRINFO.PARAMETERNAME := IAPICONSTANT.REFRESHWINDOWDESCR;
      LRINFO.PARAMETERDATA := IAPICONSTANT.NOREFRESHWINDOW;
      LSSQL :=
            'SELECT '
         || ''''
         || LRINFO.PARAMETERNAME
         || ''''
         || ' '
         || IAPICONSTANTCOLUMN.PARAMETERNAMECOL
         || ' , '
         || ''''
         || LRINFO.PARAMETERDATA
         || ''''
         || ' '
         || IAPICONSTANTCOLUMN.PARAMETERDATACOL
         || ' FROM DUAL';

      OPEN AQINFO FOR LSSQL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      GTBASENAME.DELETE;
      GTERRORS.DELETE;
      GTINFO.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRBASENAME.PARTNO := ASPARTNO;
      LRBASENAME.REVISION := ANREVISION;
      LRBASENAME.SECTIONID := ANSECTIONID;
      LRBASENAME.SUBSECTIONID := ANSUBSECTIONID;
      LRBASENAME.ITEMID := 0;
      GTBASENAME( 0 ) := LRBASENAME;

      GTINFO( 0 ) := LRINFO;
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Call CUSTOM Pre-Action',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIGENERAL.EXECUTECUSTOMFUNCTION( GSSOURCE,
                                                     LSMETHOD,
                                                     'PRE',
                                                     GTERRORS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_ERRORLIST )
         THEN
            
            LNRETVAL := IAPIGENERAL.ERRORLISTCONTAINSERRORS( GTERRORS );

            IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               
               LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                      AQERRORS );
               RETURN( IAPICONSTANTDBERROR.DBERR_ERRORLIST );
            END IF;
         ELSE
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;
      END IF;

      
      LRINFO := GTINFO( 0 );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      
      
      
      CHECKBASICBASENAMEPARAMS( LRBASENAME );

      IF ( GTERRORS.COUNT > 0 )
      THEN
         
         LNRETVAL := IAPIGENERAL.ERRORLISTCONTAINSERRORS( GTERRORS );

         IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            
            LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                   AQERRORS );

            IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               RETURN( IAPICONSTANTDBERROR.DBERR_ERRORLIST );
            ELSE
               RETURN( LNRETVAL );
            END IF;
         END IF;
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      

      
      LNRETVAL :=
         IAPISPECIFICATIONSECTION.ISACTIONALLOWED( LRBASENAME.PARTNO,
                                                   LRBASENAME.REVISION,
                                                   LRBASENAME.SECTIONID,
                                                   LRBASENAME.SUBSECTIONID,
                                                   IAPICONSTANT.SECTIONTYPE_BASENAME,
                                                   LRBASENAME.ITEMID,
                                                   ASACTION => 'REMOVE',
                                                   ANALLOWED => LNALLOWED );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      IF ( LNALLOWED = 0 )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_ACTIONNOTALLOWED,
                                                     'REMOVE',
                                                     LRBASENAME.ITEMID,
                                                     IAPICONSTANT.SECTIONTYPE_BASENAME,
                                                     LRBASENAME.PARTNO,
                                                     LRBASENAME.REVISION,
                                                     
                                                     
                                                     
                                                     F_SCH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRBASENAME.SECTIONID, 0),
                                                     F_SBH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRBASENAME.SUBSECTIONID, 0) ));
                                                     
      END IF;

     
      LNRETVAL :=
         IAPISPECIFICATIONSECTION.REMOVESECTIONITEM( LRBASENAME.PARTNO,
                                                     LRBASENAME.REVISION,
                                                     LRBASENAME.SECTIONID,
                                                     LRBASENAME.SUBSECTIONID,
                                                     IAPICONSTANT.SECTIONTYPE_BASENAME,
                                                     LRBASENAME.ITEMID,
                                                     AFHANDLE => AFHANDLE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;
     

      










































      DELETE FROM ITSHBN
            WHERE PART_NO = LRBASENAME.PARTNO
              AND REVISION = LRBASENAME.REVISION
              AND SECTION_ID = LRBASENAME.SECTIONID
              AND SUB_SECTION_ID = LRBASENAME.SUBSECTIONID;

      IF SQL%ROWCOUNT = 0
      THEN
         
         LNRETVAL :=
            IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                LSMETHOD,
                                                IAPICONSTANTDBERROR.DBERR_SPBASEIDNOTFOUND,
                                                LRBASENAME.ITEMID,
                                                LRBASENAME.PARTNO,
                                                LRBASENAME.REVISION );
      END IF;

      
      

      
      LNRETVAL := IAPISPECIFICATIONSECTION.LOGHISTORY( LRBASENAME.PARTNO,
                                                       LRBASENAME.REVISION,
                                                       LRBASENAME.SECTIONID,
                                                       LRBASENAME.SUBSECTIONID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.LOGCHANGES( LRBASENAME.PARTNO,
                                                LRBASENAME.REVISION );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      
      
      IF ( AQINFO%ISOPEN )
      THEN
         CLOSE AQINFO;
      END IF;

      LSSQL :=
            'SELECT '
         || ''''
         || LRINFO.PARAMETERNAME
         || ''''
         || ' '
         || IAPICONSTANTCOLUMN.PARAMETERNAMECOL
         || ' , '
         || ''''
         || LRINFO.PARAMETERDATA
         || ''''
         || ' '
         || IAPICONSTANTCOLUMN.PARAMETERDATACOL
         || ' FROM DUAL';

      OPEN AQINFO FOR LSSQL;

      GTINFO.DELETE;
      GTINFO( 0 ) := LRINFO;
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Call CUSTOM Post-Action',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIGENERAL.EXECUTECUSTOMFUNCTION( GSSOURCE,
                                                     LSMETHOD,
                                                     'POST',
                                                     GTERRORS );
      LRINFO := GTINFO( 0 );

      IF ( AQINFO%ISOPEN )
      THEN
         CLOSE AQINFO;
      END IF;

      LSSQL :=
            'SELECT '
         || ''''
         || LRINFO.PARAMETERNAME
         || ''''
         || ' '
         || IAPICONSTANTCOLUMN.PARAMETERNAMECOL
         || ' , '
         || ''''
         || LRINFO.PARAMETERDATA
         || ''''
         || ' '
         || IAPICONSTANTCOLUMN.PARAMETERDATACOL
         || ' FROM DUAL';

      OPEN AQINFO FOR LSSQL;

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_ERRORLIST )
         THEN
            LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                   AQERRORS );
            RETURN( IAPICONSTANTDBERROR.DBERR_ERRORLIST );
         ELSE
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;
      END IF;

      
      
      
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
   END REMOVEBASENAME;

   
   FUNCTION GETBASENAME(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      AQBASENAME                 OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetBaseName';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRBASENAME                    IAPITYPE.SPBASENAMEREC_TYPE;
      LRGETBASENAME                 SPBASENAMERECORD_TYPE := SPBASENAMERECORD_TYPE( NULL,
                                                                                    NULL,
                                                                                    NULL,
                                                                                    NULL,
                                                                                    NULL,
                                                                                    NULL,
                                                                                    NULL,
                                                                                    NULL,
                                                                                    NULL );
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 )
         :=    'part_no '
            || IAPICONSTANTCOLUMN.PARTNOCOL
            || ', revision '
            || IAPICONSTANTCOLUMN.REVISIONCOL
            || ', section_id '
            || IAPICONSTANTCOLUMN.SECTIONIDCOL
            || ', section_rev '
            || IAPICONSTANTCOLUMN.SECTIONREVISIONCOL
            || ', sub_section_id '
            || IAPICONSTANTCOLUMN.SUBSECTIONIDCOL
            || ', sub_section_rev '
            || IAPICONSTANTCOLUMN.SUBSECTIONREVISIONCOL
            || ', base_name_id '
            || IAPICONSTANTCOLUMN.ITEMIDCOL
            || ', base_name_rev '
            || IAPICONSTANTCOLUMN.ITEMREVISIONCOL
            || ', f_ing_descr(1, base_name_id, base_name_rev) '
            || IAPICONSTANTCOLUMN.INGREDIENTCOL;
      LSFROM                        IAPITYPE.STRING_TYPE := 'itshbn';
      LNSECTIONID                   IAPITYPE.ID_TYPE;
      LNSUBSECTIONID                IAPITYPE.ID_TYPE;
   BEGIN
      
      
      
      
      
      IF ( AQBASENAME%ISOPEN )
      THEN
         CLOSE AQBASENAME;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE part_no = NULL';

      OPEN AQBASENAME FOR LSSQLNULL;

      GTBASENAME.DELETE;
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRBASENAME.PARTNO := ASPARTNO;
      LRBASENAME.REVISION := ANREVISION;
      LRBASENAME.ITEMID := 0;
      GTBASENAME( 0 ) := LRBASENAME;
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Call CUSTOM Pre-Action',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIGENERAL.EXECUTECUSTOMFUNCTION( GSSOURCE,
                                                     LSMETHOD,
                                                     'PRE',
                                                     GTERRORS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_ERRORLIST )
         THEN
            
            LNRETVAL := IAPIGENERAL.ERRORLISTCONTAINSERRORS( GTERRORS );

            IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               
               LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                      AQERRORS );
               RETURN( IAPICONSTANTDBERROR.DBERR_ERRORLIST );
            END IF;
         ELSE
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := EXISTSECBASENAME( ASPARTNO,
                                    ANREVISION,
                                    LNSECTIONID,
                                    LNSUBSECTIONID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      
      LNRETVAL :=
                IAPISPECIFICATIONSECTION.EXISTITEMINSECTION( ASPARTNO,
                                                             ANREVISION,
                                                             LNSECTIONID,
                                                             LNSUBSECTIONID,
                                                             IAPICONSTANT.SECTIONTYPE_BASENAME,
                                                             0 );

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
      
      LSSQL :=    'SELECT '
               || LSSELECT
               || '  FROM '
               || LSFROM
               || ' WHERE part_no = :PartNo'
               || '   AND revision = :Revision';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQBASENAME%ISOPEN )
      THEN
         CLOSE AQBASENAME;
      END IF;

      
      OPEN AQBASENAME FOR LSSQL USING ASPARTNO,
      ANREVISION;

      
       
       
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Call CUSTOM Post-Action',
                           IAPICONSTANT.INFOLEVEL_3 );
      GTGETBASENAME.DELETE;

      LOOP
         LRBASENAME := NULL;

         FETCH AQBASENAME
          INTO LRBASENAME;

         EXIT WHEN AQBASENAME%NOTFOUND;
         LRGETBASENAME.PARTNO := LRBASENAME.PARTNO;
         LRGETBASENAME.REVISION := LRBASENAME.REVISION;
         LRGETBASENAME.SECTIONID := LRBASENAME.SECTIONID;
         LRGETBASENAME.SECTIONREVISION := LRBASENAME.SECTIONREVISION;
         LRGETBASENAME.SUBSECTIONID := LRBASENAME.SUBSECTIONID;
         LRGETBASENAME.SUBSECTIONREVISION := LRBASENAME.SUBSECTIONREVISION;
         LRGETBASENAME.ITEMID := LRBASENAME.ITEMID;
         LRGETBASENAME.ITEMREVISION := LRBASENAME.ITEMREVISION;
         LRGETBASENAME.INGREDIENT := LRBASENAME.INGREDIENT;
         GTGETBASENAME.EXTEND;
         GTGETBASENAME( GTGETBASENAME.COUNT ) := LRGETBASENAME;
      END LOOP;

      CLOSE AQBASENAME;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE part_no = NULL';

      OPEN AQBASENAME FOR LSSQLNULL;

      LNRETVAL := IAPIGENERAL.EXECUTECUSTOMFUNCTION( GSSOURCE,
                                                     LSMETHOD,
                                                     'POST',
                                                     GTERRORS );
      LSSELECT :=
            ' PARTNO '
         || IAPICONSTANTCOLUMN.PARTNOCOL
         || ', REVISION  '
         || IAPICONSTANTCOLUMN.REVISIONCOL
         || ', SECTIONID '
         || IAPICONSTANTCOLUMN.SECTIONIDCOL
         || ', SECTIONREVISION '
         || IAPICONSTANTCOLUMN.SECTIONREVISIONCOL
         || ', SUBSECTIONID '
         || IAPICONSTANTCOLUMN.SUBSECTIONIDCOL
         || ', SUBSECTIONREVISION '
         || IAPICONSTANTCOLUMN.SUBSECTIONREVISIONCOL
         || ', ITEMID '
         || IAPICONSTANTCOLUMN.ITEMIDCOL
         || ', ITEMREVISION '
         || IAPICONSTANTCOLUMN.ITEMREVISIONCOL
         || ', INGREDIENT '
         || IAPICONSTANTCOLUMN.INGREDIENTCOL;
      LSSQL :=    'SELECT '
               || LSSELECT
               || ' FROM TABLE( CAST( :gtGetBaseName AS SpBaseNameTable_Type ) ) ';

      
      IF ( AQBASENAME%ISOPEN )
      THEN
         CLOSE AQBASENAME;
      END IF;

      OPEN AQBASENAME FOR LSSQL USING GTGETBASENAME;

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_ERRORLIST )
         THEN
            LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                   AQERRORS );

            IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               RETURN( LNRETVAL );
            END IF;
         ELSE
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
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETBASENAME;

   
   FUNCTION REMOVEBASENAMEITEM(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveBaseNameItem';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRBASENAME                    IAPITYPE.SPBASENAMEREC_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LRINFO                        IAPITYPE.INFOREC_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
   BEGIN
      
      
      
      
      
      IF ( AQERRORS%ISOPEN )
      THEN
         CLOSE AQERRORS;
      END IF;

      IF ( AQINFO%ISOPEN )
      THEN
         CLOSE AQINFO;
      END IF;

      LRINFO.PARAMETERNAME := IAPICONSTANT.REFRESHWINDOWDESCR;
      LRINFO.PARAMETERDATA := IAPICONSTANT.NOREFRESHWINDOW;
      LSSQL :=
            'SELECT '
         || ''''
         || LRINFO.PARAMETERNAME
         || ''''
         || ' '
         || IAPICONSTANTCOLUMN.PARAMETERNAMECOL
         || ' , '
         || ''''
         || LRINFO.PARAMETERDATA
         || ''''
         || ' '
         || IAPICONSTANTCOLUMN.PARAMETERDATACOL
         || ' FROM DUAL';

      OPEN AQINFO FOR LSSQL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      GTBASENAME.DELETE;
      GTINFO.DELETE;
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRBASENAME.PARTNO := ASPARTNO;
      LRBASENAME.REVISION := ANREVISION;
      LRBASENAME.SECTIONID := ANSECTIONID;
      LRBASENAME.SUBSECTIONID := ANSUBSECTIONID;
      LRBASENAME.ITEMID := 0;
      GTBASENAME( 0 ) := LRBASENAME;

      GTINFO( 0 ) := LRINFO;
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Call CUSTOM Pre-Action',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIGENERAL.EXECUTECUSTOMFUNCTION( GSSOURCE,
                                                     LSMETHOD,
                                                     'PRE',
                                                     GTERRORS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_ERRORLIST )
         THEN
            LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                   AQERRORS );
            RETURN( IAPICONSTANTDBERROR.DBERR_ERRORLIST );
         ELSE
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;
      END IF;

      
      LRINFO := GTINFO( 0 );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      
      
      
      CHECKBASICBASENAMEPARAMS( LRBASENAME );

      IF ( GTERRORS.COUNT > 0 )
      THEN
         
         LNRETVAL := IAPIGENERAL.ERRORLISTCONTAINSERRORS( GTERRORS );

         IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            
            LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                   AQERRORS );

            IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               RETURN( IAPICONSTANTDBERROR.DBERR_ERRORLIST );
            ELSE
               RETURN( LNRETVAL );
            END IF;
         END IF;
      END IF;

      
      LNRETVAL := IAPISPECIFICATIONACCESS.GETMODIFIABLEACCESS( ASPARTNO,
                                                               ANREVISION,
                                                               LNACCESS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      IF ( LNACCESS = 0 )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_NOUPDATEACCESS,
                                                     ASPARTNO,
                                                     ANREVISION ) );
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Delete of the related data in itshbn',
                           IAPICONSTANT.INFOLEVEL_3 );

      




      UPDATE ITSHBN
         SET BASE_NAME_ID = LRBASENAME.ITEMID,
             BASE_NAME_REV = LRBASENAME.ITEMREVISION
       WHERE PART_NO = LRBASENAME.PARTNO
         AND REVISION = LRBASENAME.REVISION
         AND SECTION_ID = LRBASENAME.SECTIONID
         AND SUB_SECTION_ID = LRBASENAME.SUBSECTIONID;

      IF SQL%ROWCOUNT = 0
      THEN
         
         LNRETVAL :=
            IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                LSMETHOD,
                                                IAPICONSTANTDBERROR.DBERR_SPBASEIDNOTFOUND,
                                                LRBASENAME.ITEMID,
                                                LRBASENAME.PARTNO,
                                                LRBASENAME.REVISION );
      END IF;

      
      LNRETVAL := IAPISPECIFICATIONSECTION.LOGHISTORY( LRBASENAME.PARTNO,
                                                       LRBASENAME.REVISION,
                                                       LRBASENAME.SECTIONID,
                                                       LRBASENAME.SUBSECTIONID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.LOGCHANGES( LRBASENAME.PARTNO,
                                                LRBASENAME.REVISION );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      
      
      IF ( AQINFO%ISOPEN )
      THEN
         CLOSE AQINFO;
      END IF;

      LSSQL :=
            'SELECT '
         || ''''
         || LRINFO.PARAMETERNAME
         || ''''
         || ' '
         || IAPICONSTANTCOLUMN.PARAMETERNAMECOL
         || ' , '
         || ''''
         || LRINFO.PARAMETERDATA
         || ''''
         || ' '
         || IAPICONSTANTCOLUMN.PARAMETERDATACOL
         || ' FROM DUAL';

      OPEN AQINFO FOR LSSQL;

      GTINFO.DELETE;
      GTINFO( 0 ) := LRINFO;
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Call CUSTOM Post-Action',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIGENERAL.EXECUTECUSTOMFUNCTION( GSSOURCE,
                                                     LSMETHOD,
                                                     'POST',
                                                     GTERRORS );
      LRINFO := GTINFO( 0 );

      IF ( AQINFO%ISOPEN )
      THEN
         CLOSE AQINFO;
      END IF;

      LSSQL :=
            'SELECT '
         || ''''
         || LRINFO.PARAMETERNAME
         || ''''
         || ' '
         || IAPICONSTANTCOLUMN.PARAMETERNAMECOL
         || ' , '
         || ''''
         || LRINFO.PARAMETERDATA
         || ''''
         || ' '
         || IAPICONSTANTCOLUMN.PARAMETERDATACOL
         || ' FROM DUAL';

      OPEN AQINFO FOR LSSQL;

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_ERRORLIST )
         THEN
            LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                   AQERRORS );
            RETURN( IAPICONSTANTDBERROR.DBERR_ERRORLIST );
         ELSE
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;
      END IF;

      
      
      
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
   END REMOVEBASENAMEITEM;
END IAPISPECIFICATIONBASENAME;
CREATE OR REPLACE PACKAGE BODY iapiSpecificationAttachedSpecs
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

   
   
   

   
   
   
   
   PROCEDURE CHECKBASICATTSPECPARAMS(
      ARATTACHEDSPEC             IN       IAPITYPE.SPATTACHEDSPECREC_TYPE )
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckBasicAttSpecParams';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNACCESSLEVEL                 IAPITYPE.ID_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( ARATTACHEDSPEC.PARTNO IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'PartNo' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asPartNo',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARATTACHEDSPEC.REVISION IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Revision' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anRevision',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARATTACHEDSPEC.SECTIONID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'SectionId' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anSectionId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARATTACHEDSPEC.SUBSECTIONID IS NULL )
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

      IF F_CHECK_ITEM_ACCESS( ARATTACHEDSPEC.PARTNO,
                              ARATTACHEDSPEC.REVISION,
                              ARATTACHEDSPEC.SECTIONID,
                              ARATTACHEDSPEC.SUBSECTIONID,
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
                                                ARATTACHEDSPEC.PARTNO,
                                                ARATTACHEDSPEC.REVISION,
                                                F_SCH_DESCR( NULL,
                                                             ARATTACHEDSPEC.SECTIONID,
                                                             0 ),
                                                F_SBH_DESCR( NULL,
                                                             ARATTACHEDSPEC.SUBSECTIONID,
                                                             0 ),
                                                'ATTACHED SPECS' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'No Edit Access ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      LNACCESSLEVEL := 0;

      IF F_CHECK_ITEM_ACCESS( ARATTACHEDSPEC.PARTNO,
                              ARATTACHEDSPEC.REVISION,
                              ARATTACHEDSPEC.SECTIONID,
                              ARATTACHEDSPEC.SUBSECTIONID,
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
                                                ARATTACHEDSPEC.PARTNO,
                                                ARATTACHEDSPEC.REVISION,
                                                F_SCH_DESCR( NULL,
                                                             ARATTACHEDSPEC.SECTIONID,
                                                             0 ),
                                                F_SBH_DESCR( NULL,
                                                             ARATTACHEDSPEC.SUBSECTIONID,
                                                             0 ),
                                                'ATTACHED SPECS' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'No View Section Access ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      LNACCESSLEVEL := 2;

      IF F_CHECK_ITEM_ACCESS( ARATTACHEDSPEC.PARTNO,
                              ARATTACHEDSPEC.REVISION,
                              ARATTACHEDSPEC.SECTIONID,
                              ARATTACHEDSPEC.SUBSECTIONID,
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
                                                ARATTACHEDSPEC.PARTNO,
                                                ARATTACHEDSPEC.REVISION,
                                                F_SCH_DESCR( NULL,
                                                             ARATTACHEDSPEC.SECTIONID,
                                                             0 ),
                                                F_SBH_DESCR( NULL,
                                                             ARATTACHEDSPEC.SUBSECTIONID,
                                                             0 ),
                                                'ATTACHED SPECS' );
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
   END CHECKBASICATTSPECPARAMS;

   
   PROCEDURE CHECKBASICATTSPECITEMPARAMS(
      ARATTACHEDSPECITEM         IN       IAPITYPE.SPATTACHEDSPECITEMREC_TYPE )
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckBasicAttSpecItemParams';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRATTACHEDSPEC                IAPITYPE.SPATTACHEDSPECREC_TYPE;
   BEGIN
      LRATTACHEDSPEC.PARTNO := ARATTACHEDSPECITEM.PARTNO;
      LRATTACHEDSPEC.REVISION := ARATTACHEDSPECITEM.REVISION;
      LRATTACHEDSPEC.SECTIONID := ARATTACHEDSPECITEM.SECTIONID;
      LRATTACHEDSPEC.SUBSECTIONID := ARATTACHEDSPECITEM.SUBSECTIONID;
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      
      CHECKBASICATTSPECPARAMS( LRATTACHEDSPEC );

      
      IF ( ARATTACHEDSPECITEM.ITEMID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'ItemId' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anItemId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARATTACHEDSPECITEM.ATTACHEDPARTNO IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'AttachedPartNo' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asAttachedPartNo',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARATTACHEDSPECITEM.ATTACHEDREVISION IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'AttachedRevision' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anAttachedRevision',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
   END CHECKBASICATTSPECITEMPARAMS;

   
   FUNCTION EXISTITEMINLIST(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANITEMID                   IN       IAPITYPE.ID_TYPE,
      ASATTACHEDPARTNO           IN       IAPITYPE.PARTNO_TYPE,
      ANATTACHEDREVISION         IN       IAPITYPE.REVISION_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExistItemInList';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSPARTNO                      IAPITYPE.PARTNO_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      LNRETVAL := IAPISPECIFICATIONSECTION.EXISTID( ASPARTNO,
                                                    ANREVISION,
                                                    ANSECTIONID,
                                                    ANSUBSECTIONID );

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

      SELECT DISTINCT PART_NO
                 INTO LSPARTNO
                 FROM ATTACHED_SPECIFICATION
                WHERE PART_NO = ASPARTNO
                  AND REVISION = ANREVISION
                  AND SECTION_ID = ANSECTIONID
                  AND SUB_SECTION_ID = ANSUBSECTIONID
                  AND REF_ID = ANITEMID
                  AND ATTACHED_PART_NO = ASATTACHEDPARTNO
                  AND ATTACHED_REVISION = ANATTACHEDREVISION;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_SPITEMNOTFOUND,
                                                     ASPARTNO,
                                                     ANREVISION,                                                     
                                                     
                                                     
                                                     
                                                     
                                                     F_SCH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, ANSECTIONID, 0),
                                                     F_SBH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, ANSUBSECTIONID, 0),
                                                     'ATTACHED SPECS'));                                                                                                                                                      
                                                     
                                                     
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EXISTITEMINLIST;

   
   
   
   
   FUNCTION ADDATTACHEDSPEC(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
         
         
         
         
         
         
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddAttachedSpec';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRATTACHEDSPEC                IAPITYPE.SPATTACHEDSPECREC_TYPE;
      LRINFO                        IAPITYPE.INFOREC_TYPE;
      LNALLOWED                     IAPITYPE.BOOLEAN_TYPE;
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
      GTATTACHEDSPECS.DELETE;
      GTINFO.DELETE;
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRATTACHEDSPEC.PARTNO := ASPARTNO;
      LRATTACHEDSPEC.REVISION := ANREVISION;
      LRATTACHEDSPEC.SECTIONID := ANSECTIONID;
      LRATTACHEDSPEC.SUBSECTIONID := ANSUBSECTIONID;
      GTATTACHEDSPECS( 0 ) := LRATTACHEDSPEC;
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
      
      
      
      
      
      
      CHECKBASICATTSPECPARAMS( LRATTACHEDSPEC );

      
      
      IF ( GTERRORS.COUNT > 0 )
      THEN
         
         LNRETVAL := IAPIGENERAL.ERRORLISTCONTAINSERRORS( GTERRORS );

         IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            
            LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                   AQERRORS );
            RETURN( IAPICONSTANTDBERROR.DBERR_ERRORLIST );
         END IF;
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      SELECT ATTACHED_SPEC_SEQ.NEXTVAL
        INTO LRATTACHEDSPEC.ITEMID
        FROM DUAL;

      
      LNRETVAL :=
         IAPISPECIFICATIONSECTION.ADDSECTIONITEM( LRATTACHEDSPEC.PARTNO,
                                                  LRATTACHEDSPEC.REVISION,
                                                  LRATTACHEDSPEC.SECTIONID,
                                                  LRATTACHEDSPEC.SUBSECTIONID,
                                                  IAPICONSTANT.SECTIONTYPE_ATTACHEDSPEC,
                                                  LRATTACHEDSPEC.ITEMID,
                                                  AFHANDLE => AFHANDLE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL :=
         IAPISPECIFICATIONSECTION.ISACTIONALLOWED( LRATTACHEDSPEC.PARTNO,
                                                   LRATTACHEDSPEC.REVISION,
                                                   LRATTACHEDSPEC.SECTIONID,
                                                   LRATTACHEDSPEC.SUBSECTIONID,
                                                   IAPICONSTANT.SECTIONTYPE_ATTACHEDSPEC,
                                                   LRATTACHEDSPEC.ITEMID,
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
                                                     LRATTACHEDSPEC.ITEMID,
                                                     IAPICONSTANT.SECTIONTYPE_ATTACHEDSPEC,
                                                     LRATTACHEDSPEC.PARTNO,
                                                     LRATTACHEDSPEC.REVISION,
                                                     
                                                     
                                                     
                                                     F_SCH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRATTACHEDSPEC.SECTIONID, 0),
                                                     F_SBH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRATTACHEDSPEC.SUBSECTIONID, 0) ));
                                                     
      END IF;

      
      LNRETVAL :=
          IAPISPECIFICATIONSECTION.LOGHISTORY( LRATTACHEDSPEC.PARTNO,
                                               LRATTACHEDSPEC.REVISION,
                                               LRATTACHEDSPEC.SECTIONID,
                                               LRATTACHEDSPEC.SUBSECTIONID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.LOGCHANGES( LRATTACHEDSPEC.PARTNO,
                                                LRATTACHEDSPEC.REVISION );

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
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'SQL Post Action: '
                           || LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );
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
   END ADDATTACHEDSPEC;

   
   FUNCTION REMOVEATTACHEDSPEC(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANITEMID                   IN       IAPITYPE.ID_TYPE,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveAttachedSpec';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRATTACHEDSPEC                IAPITYPE.SPATTACHEDSPECREC_TYPE;
      LNALLOWED                     IAPITYPE.BOOLEAN_TYPE;
      LNITEM                        IAPITYPE.ID_TYPE;
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
      GTATTACHEDSPECS.DELETE;
      GTINFO.DELETE;
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRATTACHEDSPEC.PARTNO := ASPARTNO;
      LRATTACHEDSPEC.REVISION := ANREVISION;
      LRATTACHEDSPEC.SECTIONID := ANSECTIONID;
      LRATTACHEDSPEC.SUBSECTIONID := ANSUBSECTIONID;
      GTINFO( 0 ) := LRINFO;

      
      
      
      IF ( ANITEMID = -8 )
      THEN
         LNITEM := 0;
      ELSE
         LNITEM := ANITEMID;
      END IF;

      LRATTACHEDSPEC.ITEMID := LNITEM;
      GTATTACHEDSPECS( 0 ) := LRATTACHEDSPEC;
      
      
      
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
      
      
      
      
      
      
      CHECKBASICATTSPECPARAMS( LRATTACHEDSPEC );

      
      IF ( LRATTACHEDSPEC.ITEMID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'ItemId' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'ItemId',
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
            RETURN( IAPICONSTANTDBERROR.DBERR_ERRORLIST );
         END IF;
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
    
      

      
      LNRETVAL :=
         IAPISPECIFICATIONSECTION.ISACTIONALLOWED( LRATTACHEDSPEC.PARTNO,
                                                   LRATTACHEDSPEC.REVISION,
                                                   LRATTACHEDSPEC.SECTIONID,
                                                   LRATTACHEDSPEC.SUBSECTIONID,
                                                   IAPICONSTANT.SECTIONTYPE_ATTACHEDSPEC,
                                                   LRATTACHEDSPEC.ITEMID,
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
                                                     LRATTACHEDSPEC.ITEMID,
                                                     IAPICONSTANT.SECTIONTYPE_ATTACHEDSPEC,
                                                     LRATTACHEDSPEC.PARTNO,
                                                     LRATTACHEDSPEC.REVISION,
                                                     
                                                     
                                                     
                                                     F_SCH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRATTACHEDSPEC.SECTIONID, 0),
                                                     F_SBH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRATTACHEDSPEC.SUBSECTIONID, 0) ));
                                                     
      END IF;

      
     LNRETVAL :=
         IAPISPECIFICATIONSECTION.REMOVESECTIONITEM( LRATTACHEDSPEC.PARTNO,
                                                     LRATTACHEDSPEC.REVISION,
                                                     LRATTACHEDSPEC.SECTIONID,
                                                     LRATTACHEDSPEC.SUBSECTIONID,
                                                     IAPICONSTANT.SECTIONTYPE_ATTACHEDSPEC,
                                                     LRATTACHEDSPEC.ITEMID,
                                                     AFHANDLE => AFHANDLE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;
      
      
      
      DELETE FROM ATTACHED_SPECIFICATION
            WHERE PART_NO = LRATTACHEDSPEC.PARTNO
              AND REVISION = LRATTACHEDSPEC.REVISION
              AND SECTION_ID = LRATTACHEDSPEC.SECTIONID
              AND SUB_SECTION_ID = LRATTACHEDSPEC.SUBSECTIONID
              AND REF_ID = LRATTACHEDSPEC.ITEMID;

      
      BEGIN
         DELETE FROM ITSHEXT
               WHERE PART_NO = LRATTACHEDSPEC.PARTNO
                 AND REVISION = LRATTACHEDSPEC.REVISION
                 AND SECTION_ID = LRATTACHEDSPEC.SECTIONID
                 AND SUB_SECTION_ID = LRATTACHEDSPEC.SUBSECTIONID
                 AND TYPE = IAPICONSTANT.SECTIONTYPE_ATTACHEDSPEC
                 AND REF_ID = LRATTACHEDSPEC.ITEMID;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;   
      END;

      
      LNRETVAL :=
          IAPISPECIFICATIONSECTION.LOGHISTORY( LRATTACHEDSPEC.PARTNO,
                                               LRATTACHEDSPEC.REVISION,
                                               LRATTACHEDSPEC.SECTIONID,
                                               LRATTACHEDSPEC.SUBSECTIONID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.LOGCHANGES( LRATTACHEDSPEC.PARTNO,
                                                LRATTACHEDSPEC.REVISION );

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
   END REMOVEATTACHEDSPEC;

   
   FUNCTION ADDATTACHEDSPECITEM(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANITEMID                   IN       IAPITYPE.ID_TYPE,
      ASATTACHEDPARTNO           IN       IAPITYPE.PARTNO_TYPE,
      ANATTACHEDREVISION         IN       IAPITYPE.REVISION_TYPE,
      ANINTERNATIONAL            IN       IAPITYPE.BOOLEAN_TYPE,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddAttachedSpecItem';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRATTACHEDSPECITEM            IAPITYPE.SPATTACHEDSPECITEMREC_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LNITEM                        IAPITYPE.ID_TYPE;
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
      GTATTACHEDSPECITEMS.DELETE;
      GTINFO.DELETE;
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRATTACHEDSPECITEM.PARTNO := ASPARTNO;
      LRATTACHEDSPECITEM.REVISION := ANREVISION;
      LRATTACHEDSPECITEM.SECTIONID := ANSECTIONID;
      LRATTACHEDSPECITEM.SUBSECTIONID := ANSUBSECTIONID;

       
      
      
      IF ( ANITEMID = -8 )
      THEN
         LNITEM := 0;
      ELSE
         LNITEM := ANITEMID;
      END IF;

      LRATTACHEDSPECITEM.ITEMID := LNITEM;
      LRATTACHEDSPECITEM.INTERNATIONAL := ANINTERNATIONAL;
      LRATTACHEDSPECITEM.ATTACHEDPARTNO := ASATTACHEDPARTNO;
      LRATTACHEDSPECITEM.ATTACHEDREVISION := ANATTACHEDREVISION;
      GTATTACHEDSPECITEMS( 0 ) := LRATTACHEDSPECITEM;

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
      
      
      
      
      
      
      
      
      
      CHECKBASICATTSPECITEMPARAMS( LRATTACHEDSPECITEM );

      IF ( GTERRORS.COUNT > 0 )
      THEN
         
         LNRETVAL := IAPIGENERAL.ERRORLISTCONTAINSERRORS( GTERRORS );

         IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            
            LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                   AQERRORS );
            RETURN( IAPICONSTANTDBERROR.DBERR_ERRORLIST );
         END IF;
      END IF;

      
      LNRETVAL :=
         IAPISPECIFICATIONACCESS.GETMODIFIABLEACCESS( LRATTACHEDSPECITEM.PARTNO,
                                                      LRATTACHEDSPECITEM.REVISION,
                                                      LRATTACHEDSPECITEM.SECTIONID,
                                                      LRATTACHEDSPECITEM.SUBSECTIONID,
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

      
      LNRETVAL :=
         IAPISPECIFICATIONSECTION.EXISTITEMINSECTION( LRATTACHEDSPECITEM.PARTNO,
                                                      LRATTACHEDSPECITEM.REVISION,
                                                      LRATTACHEDSPECITEM.SECTIONID,
                                                      LRATTACHEDSPECITEM.SUBSECTIONID,
                                                      IAPICONSTANT.SECTIONTYPE_ATTACHEDSPEC,
                                                      LRATTACHEDSPECITEM.ITEMID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL :=
         IAPISPECIFICATIONATTACHEDSPECS.EXISTITEMINLIST( LRATTACHEDSPECITEM.PARTNO,
                                                         LRATTACHEDSPECITEM.REVISION,
                                                         LRATTACHEDSPECITEM.SECTIONID,
                                                         LRATTACHEDSPECITEM.SUBSECTIONID,
                                                         LRATTACHEDSPECITEM.ITEMID,
                                                         LRATTACHEDSPECITEM.ATTACHEDPARTNO,
                                                         LRATTACHEDSPECITEM.ATTACHEDREVISION );

      IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         LNRETVAL :=
            IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_ATTACHEDPARTTOOMANY,
                                      LRATTACHEDSPECITEM.ATTACHEDPARTNO,
                                      LRATTACHEDSPECITEM.PARTNO,
                                      LRATTACHEDSPECITEM.REVISION );
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      ELSIF( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SPITEMNOTFOUND )
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

      INSERT INTO ATTACHED_SPECIFICATION
                  ( PART_NO,
                    REVISION,
                    SECTION_ID,
                    SUB_SECTION_ID,
                    REF_ID,
                    INTL,
                    ATTACHED_PART_NO,
                    ATTACHED_REVISION )
           VALUES ( LRATTACHEDSPECITEM.PARTNO,
                    LRATTACHEDSPECITEM.REVISION,
                    LRATTACHEDSPECITEM.SECTIONID,
                    LRATTACHEDSPECITEM.SUBSECTIONID,
                    LRATTACHEDSPECITEM.ITEMID,
                    LRATTACHEDSPECITEM.INTERNATIONAL,
                    LRATTACHEDSPECITEM.ATTACHEDPARTNO,
                    LRATTACHEDSPECITEM.ATTACHEDREVISION );

      
      
      
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
   END ADDATTACHEDSPECITEM;

   
   FUNCTION REMOVEATTACHEDSPECITEM(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANITEMID                   IN       IAPITYPE.ID_TYPE,
      ASATTACHEDPARTNO           IN       IAPITYPE.PARTNO_TYPE,
      ANATTACHEDREVISION         IN       IAPITYPE.REVISION_TYPE,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveAttachedSpecItem';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRATTACHEDSPECITEM            IAPITYPE.SPATTACHEDSPECITEMREC_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LNITEM                        IAPITYPE.ID_TYPE;
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
      GTATTACHEDSPECITEMS.DELETE;
      GTINFO.DELETE;
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRATTACHEDSPECITEM.PARTNO := ASPARTNO;
      LRATTACHEDSPECITEM.REVISION := ANREVISION;
      LRATTACHEDSPECITEM.SECTIONID := ANSECTIONID;
      LRATTACHEDSPECITEM.SUBSECTIONID := ANSUBSECTIONID;

       
      
      
      IF ( ANITEMID = -8 )
      THEN
         LNITEM := 0;
      ELSE
         LNITEM := ANITEMID;
      END IF;

      LRATTACHEDSPECITEM.ITEMID := LNITEM;
      LRATTACHEDSPECITEM.ATTACHEDPARTNO := ASATTACHEDPARTNO;
      LRATTACHEDSPECITEM.ATTACHEDREVISION := ANATTACHEDREVISION;
      GTATTACHEDSPECITEMS( 0 ) := LRATTACHEDSPECITEM;

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
      
      
      
      
      
      
      
      
      
      CHECKBASICATTSPECITEMPARAMS( LRATTACHEDSPECITEM );

      IF ( GTERRORS.COUNT > 0 )
      THEN
         
         LNRETVAL := IAPIGENERAL.ERRORLISTCONTAINSERRORS( GTERRORS );

         IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            
            LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                   AQERRORS );
            RETURN( IAPICONSTANTDBERROR.DBERR_ERRORLIST );
         END IF;
      END IF;

      
      LNRETVAL :=
         IAPISPECIFICATIONACCESS.GETMODIFIABLEACCESS( LRATTACHEDSPECITEM.PARTNO,
                                                      LRATTACHEDSPECITEM.REVISION,
                                                      LRATTACHEDSPECITEM.SECTIONID,
                                                      LRATTACHEDSPECITEM.SUBSECTIONID,
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

      
      LNRETVAL :=
         IAPISPECIFICATIONSECTION.EXISTITEMINSECTION( LRATTACHEDSPECITEM.PARTNO,
                                                      LRATTACHEDSPECITEM.REVISION,
                                                      LRATTACHEDSPECITEM.SECTIONID,
                                                      LRATTACHEDSPECITEM.SUBSECTIONID,
                                                      IAPICONSTANT.SECTIONTYPE_ATTACHEDSPEC,
                                                      LRATTACHEDSPECITEM.ITEMID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL :=
         IAPISPECIFICATIONATTACHEDSPECS.EXISTITEMINLIST( LRATTACHEDSPECITEM.PARTNO,
                                                         LRATTACHEDSPECITEM.REVISION,
                                                         LRATTACHEDSPECITEM.SECTIONID,
                                                         LRATTACHEDSPECITEM.SUBSECTIONID,
                                                         LRATTACHEDSPECITEM.ITEMID,
                                                         LRATTACHEDSPECITEM.ATTACHEDPARTNO,
                                                         LRATTACHEDSPECITEM.ATTACHEDREVISION );

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

      DELETE FROM ATTACHED_SPECIFICATION
            WHERE PART_NO = LRATTACHEDSPECITEM.PARTNO
              AND REVISION = LRATTACHEDSPECITEM.REVISION
              AND SECTION_ID = LRATTACHEDSPECITEM.SECTIONID
              AND SUB_SECTION_ID = LRATTACHEDSPECITEM.SUBSECTIONID
              AND REF_ID = LRATTACHEDSPECITEM.ITEMID
              AND ATTACHED_PART_NO = LRATTACHEDSPECITEM.ATTACHEDPARTNO
              AND ATTACHED_REVISION = LRATTACHEDSPECITEM.ATTACHEDREVISION;

      
      
      
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
   END REMOVEATTACHEDSPECITEM;

   
   FUNCTION GETATTACHEDSPECITEMS(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE DEFAULT NULL,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE DEFAULT NULL,
      ANITEMID                   IN       IAPITYPE.ID_TYPE DEFAULT NULL,
      AQATTACHEDSPECITEMS        OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetAttachedSpecItems';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
            
      LRATTACHEDSPECITEM            IAPITYPE.SPGETATTSPECITEMREC_TYPE;                       
      LRGETATTACHEDSPECITEM         SPGETATTSPECITEMRECORD_TYPE
                     := SPGETATTSPECITEMRECORD_TYPE( NULL,
                                                     NULL,
                                                     NULL,
                                                     NULL,
                                                     NULL,
                                                     NULL,
                                                     NULL,
                                                     NULL,
                                                     NULL,
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
      LSSQLCHUNK                    VARCHAR2( 1024 ) := NULL;
      LNCHUNKCOUNT                  NUMBER := 0;
      LNITEM                        IAPITYPE.ID_TYPE;
      LSSELECT                      VARCHAR2( 4096 )
         :=    'asp.part_no '
            || IAPICONSTANTCOLUMN.PARTNOCOL
            || ', asp.revision '
            || IAPICONSTANTCOLUMN.REVISIONCOL
            || ', asp.section_id '
            || IAPICONSTANTCOLUMN.SECTIONIDCOL
            || ', asp.sub_section_id '
            || IAPICONSTANTCOLUMN.SUBSECTIONIDCOL
            || ', asp.ref_id '
            || IAPICONSTANTCOLUMN.ITEMIDCOL
            || ', asp.attached_part_no '
            || IAPICONSTANTCOLUMN.ATTACHEDPARTNOCOL            
            || ', asp.attached_revision '            
            || IAPICONSTANTCOLUMN.ATTACHEDREVISIONCOL                        
            || ', asp.intl '
            || IAPICONSTANTCOLUMN.INTERNATIONALCOL
            
            
            
            
            || ', f_sh_descr(0, asp.attached_part_no, DECODE(asp.attached_revision, 0, f_rev_part_phantom(asp.attached_part_no, 0), asp.attached_revision)) '
            
            || IAPICONSTANTCOLUMN.ATTACHEDDESCRIPTIONCOL
            || ', s.status '
            || IAPICONSTANTCOLUMN.STATUSIDCOL
            || ', s.sort_desc '
            || IAPICONSTANTCOLUMN.STATUSNAMECOL
            || ', DECODE(asp.attached_revision, 0, 1, 0) '
            || IAPICONSTANTCOLUMN.PHANTOMCOL
            || ', f_check_access(asp.attached_part_no, asp.attached_revision) '
            || IAPICONSTANTCOLUMN.SPECIFICATIONACCESSCOL
            || ', s.status_type '
            || IAPICONSTANTCOLUMN.STATUSTYPECOL
            || ', f_get_spec_owner(asp.attached_part_no, DECODE( asp.attached_revision, NULL, 0, asp.attached_revision )) '
            
            
            
            || IAPICONSTANTCOLUMN.OWNERCOL
            || ', DECODE(asp.attached_revision, 0, f_rev_part_phantom(asp.attached_part_no, 0), asp.attached_revision) '
            || IAPICONSTANTCOLUMN.ATTACHEDREVISIONPHANTOMCOL;
            
            
      LSFROM                        IAPITYPE.STRING_TYPE := 'attached_specification asp, specification_header sh, status s';              
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
                                                   
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      GTSPGETATTSPECITEMS.DELETE;
      LRATTACHEDSPECITEM.PARTNO := ASPARTNO;
      LRATTACHEDSPECITEM.REVISION := ANREVISION;
      LRATTACHEDSPECITEM.SECTIONID := ANSECTIONID;
      LRATTACHEDSPECITEM.SUBSECTIONID := ANSUBSECTIONID;

       
      
      
      IF ( ANITEMID = -8 )
      THEN
         LNITEM := 0;
      ELSE
         LNITEM := ANITEMID;
      END IF;

      LRATTACHEDSPECITEM.ITEMID := LNITEM;
      GTSPGETATTSPECITEMS( 0 ) := LRATTACHEDSPECITEM;

      IF ( AQATTACHEDSPECITEMS%ISOPEN )
      THEN
         CLOSE AQATTACHEDSPECITEMS;
      END IF;

      
      
      
      
      
      LSSQLNULL :=
            'SELECT '
         || LSSELECT
         || ' FROM '
         || LSFROM
         || ' WHERE asp.part_no = NULL'
         || '   AND sh.part_no = asp.attached_part_no '
         || '   AND sh.revision = asp.attached_revision '
         || '   AND sh.status = s.status ';
      LSSQLNULL :=    'SELECT a.*, RowNum '
                   || IAPICONSTANTCOLUMN.ROWINDEXCOL
                   || ' FROM ('
                   || LSSQLNULL
                   || ') a';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQATTACHEDSPECITEMS FOR LSSQLNULL;

      
      
      
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

      IF     NOT LRATTACHEDSPECITEM.SECTIONID IS NULL
         AND LRATTACHEDSPECITEM.ITEMID IS NOT NULL
      THEN
         LNRETVAL :=
            IAPISPECIFICATIONSECTION.EXISTITEMINSECTION( LRATTACHEDSPECITEM.PARTNO,
                                                         LRATTACHEDSPECITEM.REVISION,
                                                         LRATTACHEDSPECITEM.SECTIONID,
                                                         LRATTACHEDSPECITEM.SUBSECTIONID,
                                                         IAPICONSTANT.SECTIONTYPE_ATTACHEDSPEC,
                                                         LRATTACHEDSPECITEM.ITEMID );
                                                         
         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;
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
         || ' WHERE asp.part_no = :PartNo '
         || ' AND asp.revision = :Revision '
         || ' AND asp.section_id = NVL(:SectionId, asp.section_id) '
         || ' AND asp.sub_section_id = NVL(:SubsectionId, asp.sub_section_id) '
         || ' AND sh.part_no = asp.attached_part_no '        
         || ' AND sh.revision = DECODE(asp.attached_revision, 0, f_rev_part_phantom(asp.attached_part_no, 0), asp.attached_revision) '
         || ' AND sh.status = s.status '
         || ' AND f_check_item_access(asp.part_no, asp.revision, asp.section_id, asp.sub_section_id, :SectionType) = 1 '
         || ' ORDER BY '
         || IAPICONSTANTCOLUMN.ATTACHEDPARTNOCOL
         || ' ASC, '
         || IAPICONSTANTCOLUMN.ATTACHEDREVISIONCOL
         || ' ASC ';
      LSSQL :=    'SELECT a.*, RowNum '
               || IAPICONSTANTCOLUMN.ROWINDEXCOL
               || ' FROM ('
               || LSSQL
               || ') a';
      
      LSSQLCHUNK := SUBSTR( LSSQL,
                            1,
                            1024 );

      WHILE( LENGTH( LSSQLCHUNK ) > 0 )
      LOOP
         LNCHUNKCOUNT :=   LNCHUNKCOUNT
                         + 1;
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              LSSQLCHUNK,
                              IAPICONSTANT.INFOLEVEL_3 );
         LSSQLCHUNK := SUBSTR( LSSQL,
                                 1024
                               * LNCHUNKCOUNT,
                               1024 );
      END LOOP;

      
      IF ( AQATTACHEDSPECITEMS%ISOPEN )
      THEN
         CLOSE AQATTACHEDSPECITEMS;
      END IF;

      
      OPEN AQATTACHEDSPECITEMS FOR LSSQL
      USING LRATTACHEDSPECITEM.PARTNO,
            LRATTACHEDSPECITEM.REVISION,
            LRATTACHEDSPECITEM.SECTIONID,
            LRATTACHEDSPECITEM.SUBSECTIONID,
            IAPICONSTANT.SECTIONTYPE_ATTACHEDSPEC;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Call CUSTOM Post-Action',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      GTSPGETATTACHEDSPECITEMS.DELETE;

      LOOP
         LRATTACHEDSPECITEM := NULL;

         FETCH AQATTACHEDSPECITEMS
          INTO LRATTACHEDSPECITEM;

         EXIT WHEN AQATTACHEDSPECITEMS%NOTFOUND;
         LRGETATTACHEDSPECITEM.PARTNO := LRATTACHEDSPECITEM.PARTNO;
         LRGETATTACHEDSPECITEM.REVISION := LRATTACHEDSPECITEM.REVISION;
         LRGETATTACHEDSPECITEM.SECTIONID := LRATTACHEDSPECITEM.SECTIONID;
         LRGETATTACHEDSPECITEM.SUBSECTIONID := LRATTACHEDSPECITEM.SUBSECTIONID;
         LRGETATTACHEDSPECITEM.ITEMID := LRATTACHEDSPECITEM.ITEMID;
         LRGETATTACHEDSPECITEM.ATTACHEDPARTNO := LRATTACHEDSPECITEM.ATTACHEDPARTNO;
         LRGETATTACHEDSPECITEM.ATTACHEDREVISION := LRATTACHEDSPECITEM.ATTACHEDREVISION;
         LRGETATTACHEDSPECITEM.INTERNATIONAL := LRATTACHEDSPECITEM.INTERNATIONAL;
         LRGETATTACHEDSPECITEM.ATTACHEDDESCRIPTION := LRATTACHEDSPECITEM.ATTACHEDDESCRIPTION;
         LRGETATTACHEDSPECITEM.STATUSID := LRATTACHEDSPECITEM.STATUSID;
         LRGETATTACHEDSPECITEM.STATUSNAME := LRATTACHEDSPECITEM.STATUSNAME;
         LRGETATTACHEDSPECITEM.ATTACHEDPHANTOM := LRATTACHEDSPECITEM.ATTACHEDPHANTOM;
         LRGETATTACHEDSPECITEM.SPECIFICATIONACCESS := LRATTACHEDSPECITEM.SPECIFICATIONACCESS;
         LRGETATTACHEDSPECITEM.STATUSTYPE := LRATTACHEDSPECITEM.STATUSTYPE;
         LRGETATTACHEDSPECITEM.OWNER := LRATTACHEDSPECITEM.OWNER;
         
         LRGETATTACHEDSPECITEM.ATTACHEDREVISIONPHANTOM := LRATTACHEDSPECITEM.ATTACHEDREVISIONPHANTOM;
         
         LRGETATTACHEDSPECITEM.ROWINDEX := LRATTACHEDSPECITEM.ROWINDEX;
         GTSPGETATTACHEDSPECITEMS.EXTEND;
         GTSPGETATTACHEDSPECITEMS( GTSPGETATTACHEDSPECITEMS.COUNT ) := LRGETATTACHEDSPECITEM;
      END LOOP;

      CLOSE AQATTACHEDSPECITEMS;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQATTACHEDSPECITEMS FOR LSSQLNULL;

      LNRETVAL := IAPIGENERAL.EXECUTECUSTOMFUNCTION( GSSOURCE,
                                                     LSMETHOD,
                                                     'POST',
                                                     GTERRORS );
       
       
      
      LSSELECT :=
            'PARTNO '
         || IAPICONSTANTCOLUMN.PARTNOCOL
         || ', REVISION '
         || IAPICONSTANTCOLUMN.REVISIONCOL
         || ', SECTIONID '
         || IAPICONSTANTCOLUMN.SECTIONIDCOL
         || ', SUBSECTIONID '
         || IAPICONSTANTCOLUMN.SUBSECTIONIDCOL
         || ', ITEMID '
         || IAPICONSTANTCOLUMN.ITEMIDCOL
         || ', ATTACHEDPARTNO '
         || IAPICONSTANTCOLUMN.ATTACHEDPARTNOCOL
         || ', ATTACHEDREVISION '
         || IAPICONSTANTCOLUMN.ATTACHEDREVISIONCOL
         || ', INTERNATIONAL '
         || IAPICONSTANTCOLUMN.INTERNATIONALCOL
         || ', ATTACHEDDESCRIPTION '
         || IAPICONSTANTCOLUMN.ATTACHEDDESCRIPTIONCOL
         || ', STATUSID '
         || IAPICONSTANTCOLUMN.STATUSIDCOL
         || ', STATUSNAME '
         || IAPICONSTANTCOLUMN.STATUSNAMECOL
         || ', ATTACHEDPHANTOM '
         || IAPICONSTANTCOLUMN.PHANTOMCOL
         || ', SPECIFICATIONACCESS '
         || IAPICONSTANTCOLUMN.SPECIFICATIONACCESSCOL
         || ', STATUSTYPE '
         || IAPICONSTANTCOLUMN.STATUSTYPECOL
         || ', OWNER '
         
         
         || IAPICONSTANTCOLUMN.OWNERCOL
         || ', ATTACHEDREVISIONPHANTOM '
         || IAPICONSTANTCOLUMN.ATTACHEDREVISIONPHANTOMCOL;
         
      LSSQL :=    'SELECT '
               || LSSELECT               
               || ' FROM TABLE( CAST(:gtSpGetAttachedSpecItems AS SpGetAttSpecItemTable_Type ) ) ';
      LSSQL :=    'SELECT a.*, RowNum '
               || IAPICONSTANTCOLUMN.ROWINDEXCOL
               || ' FROM ( '
               || LSSQL
               || ' ) a';

      IF ( AQATTACHEDSPECITEMS%ISOPEN )
      THEN
         CLOSE AQATTACHEDSPECITEMS;
      END IF;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );
      
      OPEN AQATTACHEDSPECITEMS FOR LSSQL USING GTSPGETATTACHEDSPECITEMS;

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

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETATTACHEDSPECITEMS;

   
   FUNCTION SAVEATTACHEDSPEC(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANITEMID                   IN       IAPITYPE.ID_TYPE,
      ANACTION                   IN       IAPITYPE.NUMVAL_TYPE,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveAttachedSpec';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRATTACHEDSPEC                IAPITYPE.SPATTACHEDSPECREC_TYPE;
      LNITEM                        IAPITYPE.ID_TYPE;
      LRINFO                        IAPITYPE.INFOREC_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
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
      GTATTACHEDSPECS.DELETE;
      GTERRORS.DELETE;
      GTINFO.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRATTACHEDSPEC.PARTNO := ASPARTNO;
      LRATTACHEDSPEC.REVISION := ANREVISION;
      LRATTACHEDSPEC.SECTIONID := ANSECTIONID;
      LRATTACHEDSPEC.SUBSECTIONID := ANSUBSECTIONID;

       
      
      
      IF ( ANITEMID = -8 )
      THEN
         LNITEM := 0;
      ELSE
         LNITEM := ANITEMID;
      END IF;

      LRATTACHEDSPEC.ITEMID := LNITEM;
      GTATTACHEDSPECS( 0 ) := LRATTACHEDSPEC;

      GTINFO( 0 ) := LRINFO;
      LNRETVAL :=
         IAPISPECIFICATIONACCESS.GETMODIFIABLEACCESS( LRATTACHEDSPEC.PARTNO,
                                                      LRATTACHEDSPEC.REVISION,
                                                      LRATTACHEDSPEC.SECTIONID,
                                                      LRATTACHEDSPEC.SUBSECTIONID,
                                                      LNACCESS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( LNRETVAL );
      END IF;

      IF LNACCESS = 0
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOUPDATEACCESS,
                                                    ASPARTNO,
                                                    ANREVISION );
      END IF;

      CASE ANACTION
         WHEN IAPICONSTANT.ACTIONPRE
         THEN
            
            
            
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
         WHEN IAPICONSTANT.ACTIONPOST
         THEN
            
            
            
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
         ELSE
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_INVALIDACTION,
                                                        ANACTION ) );
      END CASE;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SAVEATTACHEDSPEC;
END IAPISPECIFICATIONATTACHEDSPECS;
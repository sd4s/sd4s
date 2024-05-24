CREATE OR REPLACE PACKAGE BODY iapiSpecificationObject
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

   
   
   

   
   
   
   
   PROCEDURE CHECKBASICOBJECTPARAMS(
      AROBJECT                   IN       IAPITYPE.SPOBJECTREC_TYPE )
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckBasicObjectParams';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNACCESSLEVEL                 IAPITYPE.ID_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AROBJECT.PARTNO IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'PartNo' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asPartNo',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( AROBJECT.REVISION IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Revision' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anRevision',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( AROBJECT.SECTIONID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'SectionId' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anSectionId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( AROBJECT.SUBSECTIONID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'SubSectionId' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anSubSectionId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( AROBJECT.ITEMID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'ItemId' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anItemId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      LNACCESSLEVEL := 1;

      IF F_CHECK_ITEM_ACCESS( AROBJECT.PARTNO,
                              AROBJECT.REVISION,
                              AROBJECT.SECTIONID,
                              AROBJECT.SUBSECTIONID,
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
                                                AROBJECT.PARTNO,
                                                AROBJECT.REVISION,
                                                F_SCH_DESCR( NULL,
                                                             AROBJECT.SECTIONID,
                                                             0 ),
                                                F_SBH_DESCR( NULL,
                                                             AROBJECT.SUBSECTIONID,
                                                             0 ),
                                                'OBJECT' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'No Edit Access ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      LNACCESSLEVEL := 0;

      IF F_CHECK_ITEM_ACCESS( AROBJECT.PARTNO,
                              AROBJECT.REVISION,
                              AROBJECT.SECTIONID,
                              AROBJECT.SUBSECTIONID,
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
                                                AROBJECT.PARTNO,
                                                AROBJECT.REVISION,
                                                F_SCH_DESCR( NULL,
                                                             AROBJECT.SECTIONID,
                                                             0 ),
                                                F_SBH_DESCR( NULL,
                                                             AROBJECT.SUBSECTIONID,
                                                             0 ),
                                                'OBJECT' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'No View Section Access ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      LNACCESSLEVEL := 2;

      IF F_CHECK_ITEM_ACCESS( AROBJECT.PARTNO,
                              AROBJECT.REVISION,
                              AROBJECT.SECTIONID,
                              AROBJECT.SUBSECTIONID,
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
                                                AROBJECT.PARTNO,
                                                AROBJECT.REVISION,
                                                F_SCH_DESCR( NULL,
                                                             AROBJECT.SECTIONID,
                                                             0 ),
                                                F_SBH_DESCR( NULL,
                                                             AROBJECT.SUBSECTIONID,
                                                             0 ),
                                                'OBJECT' );
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
   END CHECKBASICOBJECTPARAMS;

   
   
   
   
   FUNCTION ADDOBJECT(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANITEMID                   IN       IAPITYPE.ID_TYPE,
      ANITEMREVISION             IN       IAPITYPE.REVISION_TYPE,
      ANITEMOWNER                IN       IAPITYPE.OWNER_TYPE,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddObject';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LROBJECT                      IAPITYPE.SPOBJECTREC_TYPE;
      LNALLOWED                     IAPITYPE.BOOLEAN_TYPE;
      LRINFO                        IAPITYPE.INFOREC_TYPE;
      LSSQLINFO                     IAPITYPE.SQLSTRING_TYPE;
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
      LSSQLINFO :=
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

      OPEN AQINFO FOR LSSQLINFO;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      GTOBJECTS.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LROBJECT.PARTNO := ASPARTNO;
      LROBJECT.REVISION := ANREVISION;
      LROBJECT.SECTIONID := ANSECTIONID;
      LROBJECT.SUBSECTIONID := ANSUBSECTIONID;
      LROBJECT.ITEMID := ANITEMID;
      LROBJECT.ITEMREVISION := ANITEMREVISION;
      LROBJECT.ITEMOWNER := ANITEMOWNER;
      GTOBJECTS( 0 ) := LROBJECT;

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
      
      
      
      
      
      
      
      CHECKBASICOBJECTPARAMS( LROBJECT );

      
      
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
         IAPISPECIFICATIONSECTION.ADDSECTIONITEM( LROBJECT.PARTNO,
                                                  LROBJECT.REVISION,
                                                  LROBJECT.SECTIONID,
                                                  LROBJECT.SUBSECTIONID,
                                                  IAPICONSTANT.SECTIONTYPE_OBJECT,
                                                  LROBJECT.ITEMID,
                                                  LROBJECT.ITEMREVISION,
                                                  LROBJECT.ITEMOWNER,
                                                  AFHANDLE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL :=
         IAPISPECIFICATIONSECTION.ISACTIONALLOWED( LROBJECT.PARTNO,
                                                   LROBJECT.REVISION,
                                                   LROBJECT.SECTIONID,
                                                   LROBJECT.SUBSECTIONID,
                                                   IAPICONSTANT.SECTIONTYPE_OBJECT,
                                                   LROBJECT.ITEMID,
                                                   LROBJECT.ITEMREVISION,
                                                   LROBJECT.ITEMOWNER,
                                                   'ADD',
                                                   LNALLOWED );

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
                                                     LROBJECT.ITEMID,
                                                     IAPICONSTANT.SECTIONTYPE_OBJECT,
                                                     LROBJECT.PARTNO,
                                                     LROBJECT.REVISION,
                                                     
                                                     
                                                     
                                                     F_SCH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LROBJECT.SECTIONID, 0),
                                                     F_SBH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LROBJECT.SUBSECTIONID, 0) ));
                                                     
      END IF;

      
      LNRETVAL := IAPISPECIFICATIONSECTION.LOGHISTORY( LROBJECT.PARTNO,
                                                       LROBJECT.REVISION,
                                                       LROBJECT.SECTIONID,
                                                       LROBJECT.SUBSECTIONID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.LOGCHANGES( LROBJECT.PARTNO,
                                                LROBJECT.REVISION );

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

      LSSQLINFO :=
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

      OPEN AQINFO FOR LSSQLINFO;

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

      LSSQLINFO :=
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

      OPEN AQINFO FOR LSSQLINFO;


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
   END ADDOBJECT;

   
   FUNCTION EXTENDOBJECT(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANITEMID                   IN       IAPITYPE.ID_TYPE DEFAULT 0,
      ANITEMREVISION             IN       IAPITYPE.REVISION_TYPE DEFAULT NULL,
      ANITEMOWNER                IN       IAPITYPE.OWNER_TYPE DEFAULT NULL,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      ANSECTIONSEQUENCENUMBER    OUT      IAPITYPE.SPSECTIONSEQUENCENUMBER_TYPE,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExtendObject';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LROBJECT                      IAPITYPE.SPOBJECTREC_TYPE;
      LRINFO                        IAPITYPE.INFOREC_TYPE;
      LRINFO1                       IAPITYPE.INFOREC_TYPE;
      LTINFO                        IAPITYPE.INFOTAB_TYPE;
      LNREFRESHWINDOW               IAPITYPE.ITEMINFO_TYPE DEFAULT 0;
      LSSQLINFO                     IAPITYPE.SQLSTRING_TYPE;
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
      LRINFO.PARAMETERDATA := LNREFRESHWINDOW;
      LSSQLINFO :=
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

      OPEN AQINFO FOR LSSQLINFO;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      GTOBJECTS.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LROBJECT.PARTNO := ASPARTNO;
      LROBJECT.REVISION := ANREVISION;
      LROBJECT.SECTIONID := ANSECTIONID;
      LROBJECT.SUBSECTIONID := ANSUBSECTIONID;
      LROBJECT.ITEMID := ANITEMID;
      LROBJECT.ITEMREVISION := ANITEMREVISION;
      LROBJECT.ITEMOWNER := ANITEMOWNER;
      GTOBJECTS( 0 ) := LROBJECT;

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
      LNREFRESHWINDOW := LRINFO.PARAMETERDATA;
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      
      
      
      
      CHECKBASICOBJECTPARAMS( LROBJECT );

      
      IF (      ( LROBJECT.ITEMID IS NOT NULL )
           AND ( LROBJECT.ITEMID <> 0 ) )
      THEN
         IF ( LROBJECT.ITEMREVISION IS NULL )
         THEN
            LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                            LSMETHOD,
                                                            IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                            'ItemRevision' );
            LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anItemRevision',
                                                    IAPIGENERAL.GETLASTERRORTEXT( ),
                                                    GTERRORS );
         END IF;

         IF ( LROBJECT.ITEMOWNER IS NULL )
         THEN
            LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                            LSMETHOD,
                                                            IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                            'ItemOwner' );
            LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anItemOwner',
                                                    IAPIGENERAL.GETLASTERRORTEXT( ),
                                                    GTERRORS );
         END IF;
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
         IAPISPECIFICATIONSECTION.EXTENDSECTION( LROBJECT.PARTNO,
                                                 LROBJECT.REVISION,
                                                 LROBJECT.SECTIONID,
                                                 LROBJECT.SUBSECTIONID,
                                                 IAPICONSTANT.SECTIONTYPE_OBJECT,
                                                 0,   
                                                 NULL,
                                                 AFHANDLE => AFHANDLE,
                                                 ANSECTIONSEQUENCENUMBER => ANSECTIONSEQUENCENUMBER );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      IF ( LROBJECT.ITEMID <> 0 )
      THEN
         LNRETVAL :=
            IAPISPECIFICATIONOBJECT.ADDOBJECTVIAANYHOOK( LROBJECT.PARTNO,
                                                         LROBJECT.REVISION,
                                                         LROBJECT.SECTIONID,
                                                         LROBJECT.SUBSECTIONID,
                                                         LROBJECT.ITEMID,
                                                         LROBJECT.ITEMREVISION,
                                                         LROBJECT.ITEMOWNER,
                                                         AFHANDLE,
                                                         AQINFO,
                                                         AQERRORS );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;

         
         FETCH AQINFO
         BULK COLLECT INTO LTINFO;

         
         IF ( LTINFO.COUNT > 0 )
         THEN
            FOR LNINDEX IN LTINFO.FIRST .. LTINFO.LAST
            LOOP
               LRINFO1 := LTINFO( LNINDEX );

               IF LRINFO1.PARAMETERNAME = IAPICONSTANT.REFRESHWINDOWDESCR
               THEN
                  LRINFO.PARAMETERNAME := LRINFO1.PARAMETERNAME;
                  LRINFO.PARAMETERDATA := LRINFO1.PARAMETERDATA;
                  EXIT;
               END IF;
            END LOOP;
         END IF;
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.LOGCHANGES( LROBJECT.PARTNO,
                                                LROBJECT.REVISION );

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

      LRINFO.PARAMETERNAME := IAPICONSTANT.REFRESHWINDOWDESCR;
      LRINFO.PARAMETERDATA := LNREFRESHWINDOW;
      LSSQLINFO :=
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

      OPEN AQINFO FOR LSSQLINFO;

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
      LNREFRESHWINDOW := LRINFO.PARAMETERDATA;

      IF ( AQINFO%ISOPEN )
      THEN
         CLOSE AQINFO;
      END IF;

      LSSQLINFO :=
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

      OPEN AQINFO FOR LSSQLINFO;


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
   END EXTENDOBJECT;

   
   FUNCTION REMOVEOBJECT(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANITEMID                   IN       IAPITYPE.ID_TYPE,
      ANITEMREVISION             IN       IAPITYPE.REVISION_TYPE,
      ANITEMOWNER                IN       IAPITYPE.OWNER_TYPE,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveObject';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LROBJECT                      IAPITYPE.SPOBJECTREC_TYPE;
      LNALLOWED                     IAPITYPE.BOOLEAN_TYPE;
      LRINFO                        IAPITYPE.INFOREC_TYPE;
      LSSQLINFO                     IAPITYPE.SQLSTRING_TYPE;
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
      LSSQLINFO :=
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

      OPEN AQINFO FOR LSSQLINFO;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      GTOBJECTS.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LROBJECT.PARTNO := ASPARTNO;
      LROBJECT.REVISION := ANREVISION;
      LROBJECT.SECTIONID := ANSECTIONID;
      LROBJECT.SUBSECTIONID := ANSUBSECTIONID;
      LROBJECT.ITEMID := ANITEMID;
      LROBJECT.ITEMREVISION := ANITEMREVISION;
      LROBJECT.ITEMOWNER := ANITEMOWNER;
      GTOBJECTS( 0 ) := LROBJECT;

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
      
      
      
      
      
      
      
      CHECKBASICOBJECTPARAMS( LROBJECT );

      
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
         IAPISPECIFICATIONSECTION.ISACTIONALLOWED( LROBJECT.PARTNO,
                                                   LROBJECT.REVISION,
                                                   LROBJECT.SECTIONID,
                                                   LROBJECT.SUBSECTIONID,
                                                   IAPICONSTANT.SECTIONTYPE_OBJECT,
                                                   LROBJECT.ITEMID,
                                                   LROBJECT.ITEMREVISION,
                                                   LROBJECT.ITEMOWNER,
                                                   'REMOVE',
                                                   LNALLOWED );

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
                                                     LROBJECT.ITEMID,
                                                     IAPICONSTANT.SECTIONTYPE_OBJECT,
                                                     LROBJECT.PARTNO,
                                                     LROBJECT.REVISION,
                                                     
                                                     
                                                     
                                                     F_SCH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LROBJECT.SECTIONID, 0),
                                                     F_SBH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LROBJECT.SUBSECTIONID, 0) ));
                                                     
      END IF;

     
      LNRETVAL :=
         IAPISPECIFICATIONSECTION.REMOVESECTIONITEM( LROBJECT.PARTNO,
                                                     LROBJECT.REVISION,
                                                     LROBJECT.SECTIONID,
                                                     LROBJECT.SUBSECTIONID,
                                                     IAPICONSTANT.SECTIONTYPE_OBJECT,
                                                     LROBJECT.ITEMID,
                                                     LROBJECT.ITEMREVISION,
                                                     LROBJECT.ITEMOWNER,
                                                     AFHANDLE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;
     

       
      
      
      
      BEGIN
         DELETE FROM ITSHEXT
               WHERE PART_NO = LROBJECT.PARTNO
                 AND REVISION = LROBJECT.REVISION
                 AND SECTION_ID = LROBJECT.SECTIONID
                 AND SUB_SECTION_ID = LROBJECT.SUBSECTIONID
                 AND TYPE = IAPICONSTANT.SECTIONTYPE_OBJECT
                 AND REF_ID = LROBJECT.ITEMID;

         IF SQL%FOUND
         THEN
            DELETE FROM SPECIFICATION_SECTION
                  WHERE PART_NO = LROBJECT.PARTNO
                    AND REVISION = LROBJECT.REVISION
                    AND SECTION_ID = LROBJECT.SECTIONID
                    AND SUB_SECTION_ID = LROBJECT.SUBSECTIONID
                    AND TYPE = IAPICONSTANT.SECTIONTYPE_OBJECT
                    AND MOD( SECTION_SEQUENCE_NO,
                             100 ) <> 0;
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;   
      END;

      
      LNRETVAL := IAPISPECIFICATIONSECTION.LOGHISTORY( LROBJECT.PARTNO,
                                                       LROBJECT.REVISION,
                                                       LROBJECT.SECTIONID,
                                                       LROBJECT.SUBSECTIONID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.LOGCHANGES( LROBJECT.PARTNO,
                                                LROBJECT.REVISION );

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

      LSSQLINFO :=
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

      OPEN AQINFO FOR LSSQLINFO;

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

      LSSQLINFO :=
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

      OPEN AQINFO FOR LSSQLINFO;


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
   END REMOVEOBJECT;

   
   FUNCTION ADDOBJECTVIAANYHOOK(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANITEMID                   IN       IAPITYPE.ID_TYPE,
      ANITEMREVISION             IN       IAPITYPE.REVISION_TYPE,
      ANITEMOWNER                IN       IAPITYPE.OWNER_TYPE,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddObjectViaAnyHook';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LROBJECT                      IAPITYPE.SPOBJECTREC_TYPE;
      LRINFO                        IAPITYPE.INFOREC_TYPE;
      LSSQLINFO                     IAPITYPE.SQLSTRING_TYPE;
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
      LSSQLINFO :=
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

      OPEN AQINFO FOR LSSQLINFO;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      GTOBJECTS.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LROBJECT.PARTNO := ASPARTNO;
      LROBJECT.REVISION := ANREVISION;
      LROBJECT.SECTIONID := ANSECTIONID;
      LROBJECT.SUBSECTIONID := ANSUBSECTIONID;
      LROBJECT.ITEMID := ANITEMID;
      LROBJECT.ITEMREVISION := ANITEMREVISION;
      LROBJECT.ITEMOWNER := ANITEMOWNER;
      GTOBJECTS( 0 ) := LROBJECT;

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
      
      
      
      
      
      
      
      CHECKBASICOBJECTPARAMS( LROBJECT );

      
      IF ( LROBJECT.ITEMREVISION IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'ItemRevision' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anItemRevision',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( LROBJECT.ITEMOWNER IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'ItemOwner' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anItemOwner',
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
         IAPISPECIFICATIONSECTION.ADDSECTIONITEMVIAANYHOOK( LROBJECT.PARTNO,
                                                            LROBJECT.REVISION,
                                                            LROBJECT.SECTIONID,
                                                            LROBJECT.SUBSECTIONID,
                                                            IAPICONSTANT.SECTIONTYPE_OBJECT,
                                                            LROBJECT.ITEMID,
                                                            LROBJECT.ITEMREVISION,
                                                            LROBJECT.ITEMOWNER,
                                                            AFHANDLE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := IAPISPECIFICATIONSECTION.LOGHISTORY( LROBJECT.PARTNO,
                                                       LROBJECT.REVISION,
                                                       LROBJECT.SECTIONID,
                                                       LROBJECT.SUBSECTIONID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.LOGCHANGES( LROBJECT.PARTNO,
                                                LROBJECT.REVISION );

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

      LSSQLINFO :=
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

      OPEN AQINFO FOR LSSQLINFO;

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

      LSSQLINFO :=
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

      OPEN AQINFO FOR LSSQLINFO;


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
   END ADDOBJECTVIAANYHOOK;

   
   FUNCTION GETOBJECT(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE DEFAULT NULL,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE DEFAULT NULL,
      ANITEMID                   IN       IAPITYPE.ID_TYPE DEFAULT NULL,
      ANITEMREVISION             IN       IAPITYPE.REVISION_TYPE DEFAULT NULL,
      ANITEMOWNER                IN       IAPITYPE.OWNER_TYPE DEFAULT NULL,
      AQOBJECT                   OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetObject';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LROBJECT                      IAPITYPE.SPOBJECTREC_TYPE;
      LRGETOBJECT                   SPOBJECTRECORD_TYPE := SPOBJECTRECORD_TYPE( NULL,
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
      LSSELECT                      VARCHAR2( 4096 )
         :=    'ss.part_no '
            || IAPICONSTANTCOLUMN.PARTNOCOL
            || ', ss.revision '
            || IAPICONSTANTCOLUMN.REVISIONCOL
            || ', ss.section_id '
            || IAPICONSTANTCOLUMN.SECTIONIDCOL
            || ', ss.section_rev '
            || IAPICONSTANTCOLUMN.SECTIONREVISIONCOL
            || ', ss.sub_section_id '
            || IAPICONSTANTCOLUMN.SUBSECTIONIDCOL
            || ', ss.sub_section_rev '
            || IAPICONSTANTCOLUMN.SUBSECTIONREVISIONCOL
            || ', ss.ref_id '
            || IAPICONSTANTCOLUMN.ITEMIDCOL
            || ', ss.ref_ver '
            || IAPICONSTANTCOLUMN.ITEMREVISIONCOL
            || ', ss.ref_owner '
            || IAPICONSTANTCOLUMN.ITEMOWNERCOL
            || ', ss.section_sequence_no '
            || IAPICONSTANTCOLUMN.SECTIONSEQUENCENUMBERCOL;
      LSFROM                        IAPITYPE.STRING_TYPE := 'specification_section ss';



   BEGIN
      
      
      
      
      
      IF ( AQOBJECT%ISOPEN )
      THEN
         CLOSE AQOBJECT;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE part_no = NULL';

      OPEN AQOBJECT FOR LSSQLNULL;

      LSSELECT
         :=    'ss.part_no '
            || IAPICONSTANTCOLUMN.PARTNOCOL
            || ', ss.revision '
            || IAPICONSTANTCOLUMN.REVISIONCOL
            || ', ss.section_id '
            || IAPICONSTANTCOLUMN.SECTIONIDCOL
            || ', ss.section_rev '
            || IAPICONSTANTCOLUMN.SECTIONREVISIONCOL
            || ', ss.sub_section_id '
            || IAPICONSTANTCOLUMN.SUBSECTIONIDCOL
            || ', ss.sub_section_rev '
            || IAPICONSTANTCOLUMN.SUBSECTIONREVISIONCOL
            || ', ss.ref_id '
            || IAPICONSTANTCOLUMN.ITEMIDCOL
            
            || ', DECODE(:anItemRevision, 0, F_GET_HIGH_VERSION(6, :anItemId, :anItemOwner), :anItemRevision) ' 
            || IAPICONSTANTCOLUMN.ITEMREVISIONCOL
            || ', ss.ref_owner '
            || IAPICONSTANTCOLUMN.ITEMOWNERCOL
            || ', ss.section_sequence_no '
            || IAPICONSTANTCOLUMN.SECTIONSEQUENCENUMBERCOL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      GTOBJECTS.DELETE;
      LROBJECT.PARTNO := ASPARTNO;
      LROBJECT.REVISION := ANREVISION;
      LROBJECT.SECTIONID := ANSECTIONID;
      LROBJECT.SUBSECTIONID := ANSUBSECTIONID;
      LROBJECT.ITEMID := ANITEMID;
      LROBJECT.ITEMREVISION := ANITEMREVISION;
      LROBJECT.ITEMOWNER := ANITEMOWNER;
      GTOBJECTS( 0 ) := LROBJECT;
      
      
      
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

      
      
      IF     NOT ANSECTIONID IS NULL
         AND ANITEMID IS NOT NULL
      THEN
         LNRETVAL :=
            IAPISPECIFICATIONSECTION.EXISTITEMINSECTION( ASPARTNO,
                                                         ANREVISION,
                                                         ANSECTIONID,
                                                         ANSUBSECTIONID,
                                                         IAPICONSTANT.SECTIONTYPE_OBJECT,
                                                         ANITEMID,
                                                         ANITEMREVISION,
                                                         ANITEMOWNER );

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
         || ' WHERE ss.part_no = :PartNo '
         || '   AND ss.revision = :Revision '
         || '   AND ss.section_id = nvl(:SectionId, ss.section_id) '
         || '   AND ss.sub_section_id = nvl(:SubSectionId, ss.sub_section_id) '
         || '   AND ss.ref_id = nvl(:ItemId, ss.ref_id) '
         || '   AND ss.ref_ver = NVL( :ItemRevision, ss.ref_ver) '
         || '   AND ss.ref_owner = NVL( :ItemOwner, ss.ref_owner)'
         || '   AND ss.type = :SectionType '
         || '   AND ss.ref_ver IS NOT NULL '   
         || '   AND f_check_item_access(part_no, revision, section_id, sub_section_id, :SectionType, ref_id) = 1 '


        || '   and f_check_obj_access(nvl(:ItemId, ss.ref_id), NVL( :ItemRevision, ss.ref_ver), NVL( :ItemOwner, ss.ref_owner)) in (0, 1)';

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQOBJECT%ISOPEN )
      THEN
         CLOSE AQOBJECT;
      END IF;

      
      OPEN AQOBJECT FOR LSSQL
      USING ANITEMREVISION,
            ANITEMID,
            ANITEMOWNER,
            ANITEMREVISION,
            ASPARTNO,
            ANREVISION,
            ANSECTIONID,
            ANSUBSECTIONID,
            ANITEMID,
            ANITEMREVISION,
            ANITEMOWNER,
            IAPICONSTANT.SECTIONTYPE_OBJECT,
            IAPICONSTANT.SECTIONTYPE_OBJECT,   
            ANITEMID,
            ANITEMREVISION,
            ANITEMOWNER;

      
      
      
      GTGETOBJECTS.DELETE;

      LOOP
         LROBJECT := NULL;

         FETCH AQOBJECT
          INTO LROBJECT;

         EXIT WHEN AQOBJECT%NOTFOUND;
         LRGETOBJECT.PARTNO := LROBJECT.PARTNO;
         LRGETOBJECT.REVISION := LROBJECT.REVISION;
         LRGETOBJECT.SECTIONID := LROBJECT.SECTIONID;
         LRGETOBJECT.SECTIONREVISION := LROBJECT.SECTIONREVISION;
         LRGETOBJECT.SUBSECTIONID := LROBJECT.SUBSECTIONID;
         LRGETOBJECT.SUBSECTIONREVISION := LROBJECT.SUBSECTIONREVISION;
         LRGETOBJECT.ITEMID := LROBJECT.ITEMID;
         LRGETOBJECT.ITEMREVISION := LROBJECT.ITEMREVISION;
         LRGETOBJECT.ITEMOWNER := LROBJECT.ITEMOWNER;
         LRGETOBJECT.SECTIONSEQUENCENUMBER := LROBJECT.SECTIONSEQUENCENUMBER;
         GTGETOBJECTS.EXTEND;
         GTGETOBJECTS( GTGETOBJECTS.COUNT ) := LRGETOBJECT;
      END LOOP;

      CLOSE AQOBJECT;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQOBJECT FOR LSSQLNULL;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Call CUSTOM Post-Action',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIGENERAL.EXECUTECUSTOMFUNCTION( GSSOURCE,
                                                     LSMETHOD,
                                                     'POST',
                                                     GTERRORS );
      LSSELECT :=
            'Partno '
         || IAPICONSTANTCOLUMN.PARTNOCOL
         || ', Revision '
         || IAPICONSTANTCOLUMN.REVISIONCOL
         || ', Sectionid '
         || IAPICONSTANTCOLUMN.SECTIONIDCOL
         || ', Sectionrevision '
         || IAPICONSTANTCOLUMN.SECTIONREVISIONCOL
         || ', Subsectionid '
         || IAPICONSTANTCOLUMN.SUBSECTIONIDCOL
         || ', Subsectionrevision '
         || IAPICONSTANTCOLUMN.SUBSECTIONREVISIONCOL
         || ', Itemid '
         || IAPICONSTANTCOLUMN.ITEMIDCOL
         || ', Itemrevision '
         || IAPICONSTANTCOLUMN.ITEMREVISIONCOL
         || ', Itemowner '
         || IAPICONSTANTCOLUMN.ITEMOWNERCOL
         || ', Sectionsequencenumber '
         || IAPICONSTANTCOLUMN.SECTIONSEQUENCENUMBERCOL;
      LSSQL :=    'SELECT '
               || LSSELECT
               || ' FROM TABLE( CAST( :gtGetObjects AS SpObjectTable_Type ) ) ';

      IF ( AQOBJECT%ISOPEN )
      THEN
         CLOSE AQOBJECT;
      END IF;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQOBJECT FOR LSSQL USING GTGETOBJECTS;

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
   END GETOBJECT;

   
   FUNCTION EXTENDOBJECTPB(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANITEMID                   IN       IAPITYPE.ID_TYPE DEFAULT 0,
      ANITEMREVISION             IN       IAPITYPE.REVISION_TYPE DEFAULT NULL,
      ANITEMOWNER                IN       IAPITYPE.OWNER_TYPE DEFAULT NULL,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      AQSECTIONSEQUENCENUMBER    OUT      IAPITYPE.REF_TYPE,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExtendObjectPb';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNSECTIONSEQUENCENUMBER       IAPITYPE.SPSECTIONSEQUENCENUMBER_TYPE;
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 ) :=    ':SectionSequenceNumber '
                                                        || IAPICONSTANTCOLUMN.SECTIONSEQUENCENUMBERCOL;
      LSFROM                        IAPITYPE.STRING_TYPE := 'dual';
   BEGIN
      
      
      
      
      
      IF ( AQSECTIONSEQUENCENUMBER%ISOPEN )
      THEN
         CLOSE AQSECTIONSEQUENCENUMBER;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM;

      OPEN AQSECTIONSEQUENCENUMBER FOR LSSQLNULL USING LNSECTIONSEQUENCENUMBER;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL :=
         IAPISPECIFICATIONOBJECT.EXTENDOBJECT( ASPARTNO,
                                               ANREVISION,
                                               ANSECTIONID,
                                               ANSUBSECTIONID,
                                               ANITEMID,
                                               ANITEMREVISION,
                                               ANITEMOWNER,
                                               AFHANDLE,
                                               LNSECTIONSEQUENCENUMBER,
                                               AQINFO,
                                               AQERRORS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      IF ( AQSECTIONSEQUENCENUMBER%ISOPEN )
      THEN
         CLOSE AQSECTIONSEQUENCENUMBER;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM;

      OPEN AQSECTIONSEQUENCENUMBER FOR LSSQLNULL USING LNSECTIONSEQUENCENUMBER;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EXTENDOBJECTPB;
END IAPISPECIFICATIONOBJECT;
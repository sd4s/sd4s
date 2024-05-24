CREATE OR REPLACE PACKAGE BODY iapiSpecificationReferenceText
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

   
   
   

   
   
   
   
   PROCEDURE CHECKBASICREFERENCETEXTPARAMS(
      ARREFERENCETEXT            IN       IAPITYPE.SPREFERENCETEXTREC_TYPE )
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckBasicReferenceTextParams';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNACCESSLEVEL                 IAPITYPE.ID_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( ARREFERENCETEXT.PARTNO IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'PartNo' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asPartNo',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARREFERENCETEXT.REVISION IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Revision' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anRevision',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARREFERENCETEXT.SECTIONID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'SectionId' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anSectionId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARREFERENCETEXT.SUBSECTIONID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'SubSectionId' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anSubSectionId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARREFERENCETEXT.ITEMID IS NULL )
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

      IF F_CHECK_ITEM_ACCESS( ARREFERENCETEXT.PARTNO,
                              ARREFERENCETEXT.REVISION,
                              ARREFERENCETEXT.SECTIONID,
                              ARREFERENCETEXT.SUBSECTIONID,
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
                                                ARREFERENCETEXT.PARTNO,
                                                ARREFERENCETEXT.REVISION,
                                                F_SCH_DESCR( NULL,
                                                             ARREFERENCETEXT.SECTIONID,
                                                             0 ),
                                                F_SBH_DESCR( NULL,
                                                             ARREFERENCETEXT.SUBSECTIONID,
                                                             0 ),
                                                'REFERENCE TEXT' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'No Edit Access ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      LNACCESSLEVEL := 0;

      IF F_CHECK_ITEM_ACCESS( ARREFERENCETEXT.PARTNO,
                              ARREFERENCETEXT.REVISION,
                              ARREFERENCETEXT.SECTIONID,
                              ARREFERENCETEXT.SUBSECTIONID,
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
                                                ARREFERENCETEXT.PARTNO,
                                                ARREFERENCETEXT.REVISION,
                                                F_SCH_DESCR( NULL,
                                                             ARREFERENCETEXT.SECTIONID,
                                                             0 ),
                                                F_SBH_DESCR( NULL,
                                                             ARREFERENCETEXT.SUBSECTIONID,
                                                             0 ),
                                                'REFERENCE TEXT' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'No View Section Access ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      LNACCESSLEVEL := 2;

      IF F_CHECK_ITEM_ACCESS( ARREFERENCETEXT.PARTNO,
                              ARREFERENCETEXT.REVISION,
                              ARREFERENCETEXT.SECTIONID,
                              ARREFERENCETEXT.SUBSECTIONID,
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
                                                ARREFERENCETEXT.PARTNO,
                                                ARREFERENCETEXT.REVISION,
                                                F_SCH_DESCR( NULL,
                                                             ARREFERENCETEXT.SECTIONID,
                                                             0 ),
                                                F_SBH_DESCR( NULL,
                                                             ARREFERENCETEXT.SUBSECTIONID,
                                                             0 ),
                                                'REFERENCE TEXT' );
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
   END CHECKBASICREFERENCETEXTPARAMS;

   FUNCTION EXISTREFERENCETEXTID(
      ANITEMID                   IN       IAPITYPE.ID_TYPE,
      ANITEMREVISION             IN       IAPITYPE.REVISION_TYPE,
      ANITEMOWNER                IN       IAPITYPE.OWNER_TYPE,
      ANLANGUAGEID               IN       IAPITYPE.LANGUAGEID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      CURSOR LQRT
      IS
         SELECT REF_TEXT_TYPE
           FROM REFERENCE_TEXT
          WHERE REF_TEXT_TYPE = ANITEMID
            AND TEXT_REVISION = ANITEMREVISION
            AND OWNER = ANITEMOWNER
            AND LANG_ID = ANLANGUAGEID;

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExistReferenceTextId';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNITEMID                      IAPITYPE.ID_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN LQRT;

      FETCH LQRT
       INTO LNITEMID;

      IF LQRT%NOTFOUND
      THEN
         CLOSE LQRT;

         RETURN( IAPICONSTANTDBERROR.DBERR_GENFAIL );
      END IF;

      CLOSE LQRT;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EXISTREFERENCETEXTID;

   FUNCTION EXISTREFTEXTTYPEID(
      ANITEMID                   IN       IAPITYPE.ID_TYPE,
      ANITEMOWNER                IN       IAPITYPE.OWNER_TYPE,
      ANLANGUAGEID               IN       IAPITYPE.LANGUAGEID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      CURSOR LQRTT
      IS
         SELECT REF_TEXT_TYPE
           FROM REF_TEXT_TYPE
          WHERE REF_TEXT_TYPE = ANITEMID
            AND OWNER = ANITEMOWNER
            AND LANG_ID = ANLANGUAGEID;

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExistRefTextTypeId';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNITEMID                      IAPITYPE.ID_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN LQRTT;

      FETCH LQRTT
       INTO LNITEMID;

      IF LQRTT%NOTFOUND
      THEN
         CLOSE LQRTT;

         RETURN( IAPICONSTANTDBERROR.DBERR_GENFAIL );
      END IF;

      CLOSE LQRTT;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EXISTREFTEXTTYPEID;

   
   
   
   
   FUNCTION ADDREFERENCETEXT(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANITEMID                   IN       IAPITYPE.ID_TYPE,
      ANITEMREVISION             IN       IAPITYPE.REVISION_TYPE DEFAULT NULL,
      ANITEMOWNER                IN       IAPITYPE.OWNER_TYPE DEFAULT NULL,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddReferenceText';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRREFERENCETEXT               IAPITYPE.SPREFERENCETEXTREC_TYPE;
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
      GTREFERENCETEXTS.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRREFERENCETEXT.PARTNO := ASPARTNO;
      LRREFERENCETEXT.REVISION := ANREVISION;
      LRREFERENCETEXT.SECTIONID := ANSECTIONID;
      LRREFERENCETEXT.SUBSECTIONID := ANSUBSECTIONID;
      LRREFERENCETEXT.ITEMID := ANITEMID;
      LRREFERENCETEXT.ITEMREVISION := ANITEMREVISION;
      LRREFERENCETEXT.ITEMOWNER := ANITEMOWNER;
      GTREFERENCETEXTS( 0 ) := LRREFERENCETEXT;

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
      
      
      
      
      
      
      
      CHECKBASICREFERENCETEXTPARAMS( LRREFERENCETEXT );

      
      
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
         IAPISPECIFICATIONSECTION.ADDSECTIONITEM( LRREFERENCETEXT.PARTNO,
                                                  LRREFERENCETEXT.REVISION,
                                                  LRREFERENCETEXT.SECTIONID,
                                                  LRREFERENCETEXT.SUBSECTIONID,
                                                  IAPICONSTANT.SECTIONTYPE_REFERENCETEXT,
                                                  LRREFERENCETEXT.ITEMID,
                                                  LRREFERENCETEXT.ITEMREVISION,
                                                  LRREFERENCETEXT.ITEMOWNER,
                                                  AFHANDLE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL :=
         IAPISPECIFICATIONSECTION.ISACTIONALLOWED( LRREFERENCETEXT.PARTNO,
                                                   LRREFERENCETEXT.REVISION,
                                                   LRREFERENCETEXT.SECTIONID,
                                                   LRREFERENCETEXT.SUBSECTIONID,
                                                   IAPICONSTANT.SECTIONTYPE_REFERENCETEXT,
                                                   LRREFERENCETEXT.ITEMID,
                                                   LRREFERENCETEXT.ITEMREVISION,
                                                   LRREFERENCETEXT.ITEMOWNER,
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
                                                     LRREFERENCETEXT.ITEMID,
                                                     IAPICONSTANT.SECTIONTYPE_FREETEXT,
                                                     LRREFERENCETEXT.PARTNO,
                                                     LRREFERENCETEXT.REVISION,
                                                     
                                                     
                                                     
                                                     F_SCH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRREFERENCETEXT.SECTIONID, 0),
                                                     F_SBH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRREFERENCETEXT.SUBSECTIONID, 0) ));
                                                     

      END IF;

      
      LNRETVAL :=
         IAPISPECIFICATIONSECTION.LOGHISTORY( LRREFERENCETEXT.PARTNO,
                                              LRREFERENCETEXT.REVISION,
                                              LRREFERENCETEXT.SECTIONID,
                                              LRREFERENCETEXT.SUBSECTIONID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.LOGCHANGES( LRREFERENCETEXT.PARTNO,
                                                LRREFERENCETEXT.REVISION );

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
   END ADDREFERENCETEXT;

   
   FUNCTION EXTENDREFERENCETEXT(
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
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExtendReferenceText';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRREFERENCETEXT               IAPITYPE.SPREFERENCETEXTREC_TYPE;
      LRINFO                        IAPITYPE.INFOREC_TYPE;
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
      GTREFERENCETEXTS.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRREFERENCETEXT.PARTNO := ASPARTNO;
      LRREFERENCETEXT.REVISION := ANREVISION;
      LRREFERENCETEXT.SECTIONID := ANSECTIONID;
      LRREFERENCETEXT.SUBSECTIONID := ANSUBSECTIONID;
      LRREFERENCETEXT.ITEMID := ANITEMID;
      LRREFERENCETEXT.ITEMREVISION := ANITEMREVISION;
      LRREFERENCETEXT.ITEMOWNER := ANITEMOWNER;
      GTREFERENCETEXTS( 0 ) := LRREFERENCETEXT;

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
      
      
      
      
      
      
      
      CHECKBASICREFERENCETEXTPARAMS( LRREFERENCETEXT );

      
      IF (      ( LRREFERENCETEXT.ITEMID IS NOT NULL )
           AND ( LRREFERENCETEXT.ITEMID <> 0 ) )
      THEN
         IF ( LRREFERENCETEXT.ITEMREVISION IS NULL )
         THEN
            LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                            LSMETHOD,
                                                            IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                            'ItemRevision' );
            LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anItemRevision',
                                                    IAPIGENERAL.GETLASTERRORTEXT( ),
                                                    GTERRORS );
         END IF;

         IF ( LRREFERENCETEXT.ITEMOWNER IS NULL )
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
         IAPISPECIFICATIONSECTION.EXTENDSECTION( LRREFERENCETEXT.PARTNO,
                                                 LRREFERENCETEXT.REVISION,
                                                 LRREFERENCETEXT.SECTIONID,
                                                 LRREFERENCETEXT.SUBSECTIONID,
                                                 IAPICONSTANT.SECTIONTYPE_REFERENCETEXT,
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

      
      IF ( LRREFERENCETEXT.ITEMID <> 0 )
      THEN
         LNRETVAL :=
            IAPISPECIFICATIONREFERENCETEXT.ADDREFERENCETEXTVIAANYHOOK( LRREFERENCETEXT.PARTNO,
                                                                       LRREFERENCETEXT.REVISION,
                                                                       LRREFERENCETEXT.SECTIONID,
                                                                       LRREFERENCETEXT.SUBSECTIONID,
                                                                       LRREFERENCETEXT.ITEMID,
                                                                       LRREFERENCETEXT.ITEMREVISION,
                                                                       LRREFERENCETEXT.ITEMOWNER,
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
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.LOGCHANGES( LRREFERENCETEXT.PARTNO,
                                                LRREFERENCETEXT.REVISION );

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
   END EXTENDREFERENCETEXT;

   
   FUNCTION REMOVEREFERENCETEXT(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANITEMID                   IN       IAPITYPE.ID_TYPE,
      ANITEMREVISION             IN       IAPITYPE.REVISION_TYPE DEFAULT NULL,
      ANITEMOWNER                IN       IAPITYPE.OWNER_TYPE DEFAULT NULL,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveReferenceText';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRREFERENCETEXT               IAPITYPE.SPREFERENCETEXTREC_TYPE;
      LNALLOWED                     IAPITYPE.BOOLEAN_TYPE;
      LRINFO                        IAPITYPE.INFOREC_TYPE;
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
      GTREFERENCETEXTS.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRREFERENCETEXT.PARTNO := ASPARTNO;
      LRREFERENCETEXT.REVISION := ANREVISION;
      LRREFERENCETEXT.SECTIONID := ANSECTIONID;
      LRREFERENCETEXT.SUBSECTIONID := ANSUBSECTIONID;
      LRREFERENCETEXT.ITEMID := ANITEMID;
      LRREFERENCETEXT.ITEMREVISION := ANITEMREVISION;
      LRREFERENCETEXT.ITEMOWNER := ANITEMOWNER;
      GTREFERENCETEXTS( 0 ) := LRREFERENCETEXT;

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
      
      
      
      
      
      
      
      CHECKBASICREFERENCETEXTPARAMS( LRREFERENCETEXT );

      
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
         IAPISPECIFICATIONSECTION.ISACTIONALLOWED( LRREFERENCETEXT.PARTNO,
                                                   LRREFERENCETEXT.REVISION,
                                                   LRREFERENCETEXT.SECTIONID,
                                                   LRREFERENCETEXT.SUBSECTIONID,
                                                   IAPICONSTANT.SECTIONTYPE_REFERENCETEXT,
                                                   LRREFERENCETEXT.ITEMID,
                                                   LRREFERENCETEXT.ITEMREVISION,
                                                   LRREFERENCETEXT.ITEMOWNER,
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
                                                     LRREFERENCETEXT.ITEMID,
                                                     IAPICONSTANT.SECTIONTYPE_FREETEXT,
                                                     LRREFERENCETEXT.PARTNO,
                                                     LRREFERENCETEXT.REVISION,
                                                     
                                                     
                                                     
                                                     F_SCH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRREFERENCETEXT.SECTIONID, 0),
                                                     F_SBH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRREFERENCETEXT.SUBSECTIONID, 0) ));
                                                     
      END IF;

    
      LNRETVAL :=
         IAPISPECIFICATIONSECTION.REMOVESECTIONITEM( LRREFERENCETEXT.PARTNO,
                                                     LRREFERENCETEXT.REVISION,
                                                     LRREFERENCETEXT.SECTIONID,
                                                     LRREFERENCETEXT.SUBSECTIONID,
                                                     IAPICONSTANT.SECTIONTYPE_REFERENCETEXT,
                                                     LRREFERENCETEXT.ITEMID,
                                                     LRREFERENCETEXT.ITEMREVISION,
                                                     LRREFERENCETEXT.ITEMOWNER,
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
               WHERE PART_NO = LRREFERENCETEXT.PARTNO
                 AND REVISION = LRREFERENCETEXT.REVISION
                 AND SECTION_ID = LRREFERENCETEXT.SECTIONID
                 AND SUB_SECTION_ID = LRREFERENCETEXT.SUBSECTIONID
                 AND TYPE = IAPICONSTANT.SECTIONTYPE_REFERENCETEXT
                 AND REF_ID = LRREFERENCETEXT.ITEMID;

         IF SQL%FOUND
         THEN
            DELETE FROM SPECIFICATION_SECTION
                  WHERE PART_NO = LRREFERENCETEXT.PARTNO
                    AND REVISION = LRREFERENCETEXT.REVISION
                    AND SECTION_ID = LRREFERENCETEXT.SECTIONID
                    AND SUB_SECTION_ID = LRREFERENCETEXT.SUBSECTIONID
                    AND TYPE = IAPICONSTANT.SECTIONTYPE_REFERENCETEXT
                    AND MOD( SECTION_SEQUENCE_NO,
                             100 ) <> 0;
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;   
      END;

      
      LNRETVAL :=
         IAPISPECIFICATIONSECTION.LOGHISTORY( LRREFERENCETEXT.PARTNO,
                                              LRREFERENCETEXT.REVISION,
                                              LRREFERENCETEXT.SECTIONID,
                                              LRREFERENCETEXT.SUBSECTIONID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.LOGCHANGES( LRREFERENCETEXT.PARTNO,
                                                LRREFERENCETEXT.REVISION );

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
   END REMOVEREFERENCETEXT;

   
   FUNCTION ADDREFERENCETEXTVIAANYHOOK(
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
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddReferenceTextViaAnyHook';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRREFERENCETEXT               IAPITYPE.SPREFERENCETEXTREC_TYPE;
      LRINFO                        IAPITYPE.INFOREC_TYPE;
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
      GTREFERENCETEXTS.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRREFERENCETEXT.PARTNO := ASPARTNO;
      LRREFERENCETEXT.REVISION := ANREVISION;
      LRREFERENCETEXT.SECTIONID := ANSECTIONID;
      LRREFERENCETEXT.SUBSECTIONID := ANSUBSECTIONID;
      LRREFERENCETEXT.ITEMID := ANITEMID;
      LRREFERENCETEXT.ITEMREVISION := ANITEMREVISION;
      LRREFERENCETEXT.ITEMOWNER := ANITEMOWNER;
      GTREFERENCETEXTS( 0 ) := LRREFERENCETEXT;

      LRINFO.PARAMETERNAME := IAPICONSTANT.REFRESHWINDOWDESCR;
      LRINFO.PARAMETERDATA := LNREFRESHWINDOW;
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
      
      
      
      
      
      
      
      CHECKBASICREFERENCETEXTPARAMS( LRREFERENCETEXT );

      
      IF ( LRREFERENCETEXT.ITEMREVISION IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'ItemRevision' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anItemRevision',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( LRREFERENCETEXT.ITEMOWNER IS NULL )
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
         IAPISPECIFICATIONSECTION.ADDSECTIONITEMVIAANYHOOK( LRREFERENCETEXT.PARTNO,
                                                            LRREFERENCETEXT.REVISION,
                                                            LRREFERENCETEXT.SECTIONID,
                                                            LRREFERENCETEXT.SUBSECTIONID,
                                                            IAPICONSTANT.SECTIONTYPE_REFERENCETEXT,
                                                            LRREFERENCETEXT.ITEMID,
                                                            LRREFERENCETEXT.ITEMREVISION,
                                                            LRREFERENCETEXT.ITEMOWNER,
                                                            AFHANDLE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL :=
         IAPISPECIFICATIONSECTION.LOGHISTORY( LRREFERENCETEXT.PARTNO,
                                              LRREFERENCETEXT.REVISION,
                                              LRREFERENCETEXT.SECTIONID,
                                              LRREFERENCETEXT.SUBSECTIONID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.LOGCHANGES( LRREFERENCETEXT.PARTNO,
                                                LRREFERENCETEXT.REVISION );

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
   END ADDREFERENCETEXTVIAANYHOOK;

   
   FUNCTION GETREFERENCETEXT(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE DEFAULT NULL,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE DEFAULT NULL,
      ANITEMID                   IN       IAPITYPE.ID_TYPE DEFAULT NULL,
      ANITEMREVISION             IN       IAPITYPE.REVISION_TYPE DEFAULT NULL,
      ANITEMOWNER                IN       IAPITYPE.OWNER_TYPE DEFAULT NULL,
      ANLANGUAGEID               IN       IAPITYPE.LANGUAGEID_TYPE DEFAULT 1,
      ANALTERNATIVELANGUAGEID    IN       IAPITYPE.LANGUAGEID_TYPE DEFAULT 1,
      AQREFERENCETEXT            OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetReferenceText';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRREFERENCETEXTS              IAPITYPE.SPREFERENCETEXTREC_TYPE;
      LRGETREFERENCETEXTS           SPREFERENCETEXTRECORD_TYPE
                                        := SPREFERENCETEXTRECORD_TYPE( NULL,
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
            || ', rt.text '
            || IAPICONSTANTCOLUMN.TEXTCOL
            || ', rt.lang_id '
            || IAPICONSTANTCOLUMN.LANGUAGEIDCOL
            || ', rtt.description '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
            || ', rtt.intl '
            || IAPICONSTANTCOLUMN.INTERNATIONALCOL;
      LSFROM                        IAPITYPE.STRING_TYPE := 'specification_section ss, reference_text rt, ref_text_type rtt';
      LCTEXT                        IAPITYPE.CLOB_TYPE;
      LSDESCRIPTION                 IAPITYPE.REFERENCETEXTTYPEDESCR_TYPE;
      LSINTL                        IAPITYPE.INTL_TYPE;
      LSSQL_STRING                  VARCHAR2( 2000 );
   BEGIN
      
      
      
      
      
      IF ( AQREFERENCETEXT%ISOPEN )
      THEN
         CLOSE AQREFERENCETEXT;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE part_no = NULL';

      OPEN AQREFERENCETEXT FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      GTREFERENCETEXTS.DELETE;
      LRREFERENCETEXTS.PARTNO := ASPARTNO;
      LRREFERENCETEXTS.REVISION := ANREVISION;
      LRREFERENCETEXTS.SECTIONID := ANSECTIONID;
      LRREFERENCETEXTS.SUBSECTIONID := ANSUBSECTIONID;
      LRREFERENCETEXTS.ITEMID := ANITEMID;
      LRREFERENCETEXTS.ITEMREVISION := ANITEMREVISION;
      LRREFERENCETEXTS.ITEMOWNER := ANITEMOWNER;
      LRREFERENCETEXTS.LANGUAGEID := ANLANGUAGEID;
      GTREFERENCETEXTS( 0 ) := LRREFERENCETEXTS;
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      
      IF     ANSECTIONID IS NOT NULL
         AND ANITEMID IS NOT NULL
      THEN
         LNRETVAL :=
            IAPISPECIFICATIONSECTION.EXISTITEMINSECTION( ASPARTNO,
                                                         ANREVISION,
                                                         ANSECTIONID,
                                                         ANSUBSECTIONID,
                                                         IAPICONSTANT.SECTIONTYPE_REFERENCETEXT,
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
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LSSQL :=
            'SELECT '
         || LSSELECT
         || ' FROM '
         || LSFROM
         || ' WHERE ss.part_no = :PartNo '
         || ' AND ss.revision = :Revision '
         || ' AND ss.section_id = NVL(:SectionId, ss.section_id)'
         || ' AND ss.sub_section_id = NVL(:SubSectionId, ss.sub_section_id) '
         || ' AND ss.ref_id = NVL(:ItemId, ss.ref_id) '
         || ' AND ss.ref_ver = NVL(:ItemRevision, ss.ref_ver) '
         || ' AND ss.ref_owner = NVL(:ItemOwner, ss.ref_owner) '
         || ' AND rt.ref_text_type = ss.ref_id '
         || ' AND rt.text_revision = ss.ref_ver '
         || ' AND rt.owner = ss.ref_owner '
         || ' AND rt.lang_id = :LanguageId '
         || ' AND rtt.ref_text_type = rt.ref_text_type '
         || ' AND rtt.owner = rt.owner '
         || ' AND rtt.lang_id = rt.lang_id '
         || ' AND ss.type = :SectionType '
         || ' AND ss.ref_ver IS NOT NULL '   
         || ' AND f_check_item_access(part_no, revision, section_id, sub_section_id, :SectionType, ref_id) = 1 '


         || ' and f_check_referencetext_access(nvl(:ItemId, ss.ref_id), NVL( :ItemRevision, ss.ref_ver), NVL( :ItemOwner, ss.ref_owner)) in (0,1) ';

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQREFERENCETEXT%ISOPEN )
      THEN
         CLOSE AQREFERENCETEXT;
      END IF;

      
      OPEN AQREFERENCETEXT FOR LSSQL
      USING ASPARTNO,
            ANREVISION,
            ANSECTIONID,
            ANSUBSECTIONID,
            ANITEMID,
            ANITEMREVISION,
            ANITEMOWNER,
            ANLANGUAGEID,
            IAPICONSTANT.SECTIONTYPE_REFERENCETEXT,
            IAPICONSTANT.SECTIONTYPE_REFERENCETEXT,
            ANITEMID,
            ANITEMREVISION,
            ANITEMOWNER;
      
      
      
      GTGETREFERENCETEXTS.DELETE;

      LOOP
         LRREFERENCETEXTS := NULL;

         FETCH AQREFERENCETEXT
          INTO LRREFERENCETEXTS;

         EXIT WHEN AQREFERENCETEXT%NOTFOUND;
         LRGETREFERENCETEXTS.PARTNO := LRREFERENCETEXTS.PARTNO;
         LRGETREFERENCETEXTS.REVISION := LRREFERENCETEXTS.REVISION;
         LRGETREFERENCETEXTS.SECTIONID := LRREFERENCETEXTS.SECTIONID;
         LRGETREFERENCETEXTS.SECTIONREVISION := LRREFERENCETEXTS.SECTIONREVISION;
         LRGETREFERENCETEXTS.SUBSECTIONID := LRREFERENCETEXTS.SUBSECTIONID;
         LRGETREFERENCETEXTS.SUBSECTIONREVISION := LRREFERENCETEXTS.SUBSECTIONREVISION;
         LRGETREFERENCETEXTS.ITEMID := LRREFERENCETEXTS.ITEMID;
         LRGETREFERENCETEXTS.ITEMREVISION := LRREFERENCETEXTS.ITEMREVISION;
         LRGETREFERENCETEXTS.ITEMOWNER := LRREFERENCETEXTS.ITEMOWNER;
         LRGETREFERENCETEXTS.TEXT := LRREFERENCETEXTS.TEXT;
         LRGETREFERENCETEXTS.LANGUAGEID := LRREFERENCETEXTS.LANGUAGEID;
         LRGETREFERENCETEXTS.DESCRIPTION := LRREFERENCETEXTS.DESCRIPTION;
         LRGETREFERENCETEXTS.INTERNATIONAL := LRREFERENCETEXTS.INTERNATIONAL;
         GTGETREFERENCETEXTS.EXTEND;
         GTGETREFERENCETEXTS( GTGETREFERENCETEXTS.COUNT ) := LRGETREFERENCETEXTS;

         
         
         IF     ANALTERNATIVELANGUAGEID IS NOT NULL
            AND ANLANGUAGEID <> ANALTERNATIVELANGUAGEID
         THEN
            GTGETREFERENCETEXTS.EXTEND;
            
            LNRETVAL :=
                  EXISTREFERENCETEXTID( LRREFERENCETEXTS.ITEMID,
                                        LRREFERENCETEXTS.ITEMREVISION,
                                        LRREFERENCETEXTS.ITEMOWNER,
                                        ANALTERNATIVELANGUAGEID );

            IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               LSSQL_STRING :=
                     '  SELECT text '
                  || '    FROM reference_text '
                  || '    WHERE ref_text_type = :ref_text_type '
                  || '      AND text_revision = :text_revision '
                  || '      AND owner = :owner '
                  || '      AND lang_id = :lang_id';

               EXECUTE IMMEDIATE LSSQL_STRING
                            INTO LCTEXT
                           USING LRREFERENCETEXTS.ITEMID,
                                 LRREFERENCETEXTS.ITEMREVISION,
                                 LRREFERENCETEXTS.ITEMOWNER,
                                 ANALTERNATIVELANGUAGEID;

               LRGETREFERENCETEXTS.TEXT := LCTEXT;
            END IF;

            LRGETREFERENCETEXTS.LANGUAGEID := ANALTERNATIVELANGUAGEID;
            
            LNRETVAL := EXISTREFTEXTTYPEID( LRREFERENCETEXTS.ITEMID,
                                            LRREFERENCETEXTS.ITEMOWNER,
                                            ANALTERNATIVELANGUAGEID );

            IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               LSSQL_STRING :=
                     '  SELECT description, intl '
                  || '    FROM ref_text_type '
                  || '    WHERE ref_text_type = :ref_text_type '
                  || '      AND owner = :owner '
                  || '      AND lang_id = :lang_id';

               EXECUTE IMMEDIATE LSSQL_STRING
                            INTO LSDESCRIPTION,
                                 LSINTL
                           USING LRREFERENCETEXTS.ITEMID,
                                 LRREFERENCETEXTS.ITEMOWNER,
                                 ANALTERNATIVELANGUAGEID;

               LRGETREFERENCETEXTS.DESCRIPTION := LSDESCRIPTION;
               LRGETREFERENCETEXTS.INTERNATIONAL := LSINTL;
            END IF;

            GTGETREFERENCETEXTS( GTGETREFERENCETEXTS.COUNT ) := LRGETREFERENCETEXTS;
         END IF;
      END LOOP;

      CLOSE AQREFERENCETEXT;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQREFERENCETEXT FOR LSSQLNULL;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Call CUSTOM Post-Action',
                           IAPICONSTANT.INFOLEVEL_3 );
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
         || ', ITEMOWNER '
         || IAPICONSTANTCOLUMN.ITEMOWNERCOL
         || ', TEXT '
         || IAPICONSTANTCOLUMN.TEXTCOL
         || ', LANGUAGEID '
         || IAPICONSTANTCOLUMN.LANGUAGEIDCOL
         || ', DESCRIPTION '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
         || ', INTERNATIONAL '
         || IAPICONSTANTCOLUMN.INTERNATIONALCOL;
      LSSQL :=    'SELECT '
               || LSSELECT
               || ' FROM TABLE( CAST( :gtGetReferenceTexts AS SpReferenceTextTable_Type ) ) ';

      IF ( AQREFERENCETEXT%ISOPEN )
      THEN
         CLOSE AQREFERENCETEXT;
      END IF;

      OPEN AQREFERENCETEXT FOR LSSQL USING GTGETREFERENCETEXTS;

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
   END GETREFERENCETEXT;

   
   FUNCTION EXTENDREFERENCETEXTPB(
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
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExtendReferenceTextPb';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNSECTIONSEQUENCENUMBER       IAPITYPE.SPSECTIONSEQUENCENUMBER_TYPE;
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 ) :=    ':SectionSequenceNumber '
                                                        || IAPICONSTANTCOLUMN.SECTIONSEQUENCENUMBERCOL;
      LSFROM                        IAPITYPE.STRING_TYPE := 'dual';
      LRINFO                        IAPITYPE.INFOREC_TYPE;
      LNREFRESHWINDOW               IAPITYPE.ITEMINFO_TYPE DEFAULT 0;
      LSSQLINFO                     IAPITYPE.SQLSTRING_TYPE;
   BEGIN
      
      
      
      
      
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
         IAPISPECIFICATIONREFERENCETEXT.EXTENDREFERENCETEXT( ASPARTNO,
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
   END EXTENDREFERENCETEXTPB;
END IAPISPECIFICATIONREFERENCETEXT;